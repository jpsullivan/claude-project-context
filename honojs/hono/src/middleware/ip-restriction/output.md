/Users/josh/Documents/GitHub/honojs/hono/src/middleware/ip-restriction/index.test.ts
```typescript
import { Context } from '../../context'
import type { AddressType, GetConnInfo } from '../../helper/conninfo'
import { Hono } from '../../hono'
import { ipRestriction } from '.'
import type { IPRestrictionRule } from '.'

describe('ipRestriction middleware', () => {
  it('Should restrict', async () => {
    const getConnInfo: GetConnInfo = (c) => {
      return {
        remote: {
          address: c.env.ip,
        },
      }
    }
    const app = new Hono<{
      Bindings: {
        ip: string
      }
    }>()
    app.use(
      '/basic',
      ipRestriction(getConnInfo, {
        allowList: ['192.168.1.0', '192.168.2.0/24'],
        denyList: ['192.168.2.10'],
      })
    )
    app.get('/basic', (c) => c.text('Hello World!'))

    app.use(
      '/allow-empty',
      ipRestriction(getConnInfo, {
        denyList: ['192.168.1.0'],
      })
    )
    app.get('/allow-empty', (c) => c.text('Hello World!'))

    expect((await app.request('/basic', {}, { ip: '0.0.0.0' })).status).toBe(403)

    expect((await app.request('/basic', {}, { ip: '192.168.1.0' })).status).toBe(200)

    expect((await app.request('/basic', {}, { ip: '192.168.2.5' })).status).toBe(200)
    expect((await app.request('/basic', {}, { ip: '192.168.2.10' })).status).toBe(403)

    expect((await app.request('/allow-empty', {}, { ip: '0.0.0.0' })).status).toBe(200)

    expect((await app.request('/allow-empty', {}, { ip: '192.168.1.0' })).status).toBe(403)

    expect((await app.request('/allow-empty', {}, { ip: '192.168.2.5' })).status).toBe(200)
    expect((await app.request('/allow-empty', {}, { ip: '192.168.2.10' })).status).toBe(200)
  })
  it('Custom onerror', async () => {
    const res = await ipRestriction(
      () => '0.0.0.0',
      { denyList: ['0.0.0.0'] },
      () => new Response('error')
    )(new Context(new Request('http://localhost/')), async () => void 0)
    expect(res).toBeTruthy()
    if (res) {
      expect(await res.text()).toBe('error')
    }
  })
})

describe('isMatchForRule', () => {
  const isMatch = async (info: { addr: string; type: AddressType }, rule: IPRestrictionRule) => {
    const middleware = ipRestriction(
      () => ({
        remote: {
          address: info.addr,
          addressType: info.type,
        },
      }),
      {
        allowList: [rule],
      }
    )
    try {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await middleware(undefined as any, () => Promise.resolve())
    } catch {
      return false
    }
    return true
  }

  it('star', async () => {
    expect(await isMatch({ addr: '192.168.2.0', type: 'IPv4' }, '*')).toBeTruthy()
    expect(await isMatch({ addr: '192.168.2.1', type: 'IPv4' }, '*')).toBeTruthy()
    expect(await isMatch({ addr: '::0', type: 'IPv6' }, '*')).toBeTruthy()
  })
  it('CIDR Notation', async () => {
    expect(await isMatch({ addr: '192.168.2.0', type: 'IPv4' }, '192.168.2.0/24')).toBeTruthy()
    expect(await isMatch({ addr: '192.168.2.1', type: 'IPv4' }, '192.168.2.0/24')).toBeTruthy()
    expect(await isMatch({ addr: '192.168.2.1', type: 'IPv4' }, '192.168.2.1/32')).toBeTruthy()
    expect(await isMatch({ addr: '192.168.2.1', type: 'IPv4' }, '192.168.2.2/32')).toBeFalsy()

    expect(await isMatch({ addr: '::0', type: 'IPv6' }, '::0/1')).toBeTruthy()
  })
  it('Static Rules', async () => {
    expect(await isMatch({ addr: '192.168.2.1', type: 'IPv4' }, '192.168.2.1')).toBeTruthy()
    expect(await isMatch({ addr: '1234::5678', type: 'IPv6' }, '1234::5678')).toBeTruthy()
    expect(
      await isMatch({ addr: '::ffff:127.0.0.1', type: 'IPv6' }, '::ffff:127.0.0.1')
    ).toBeTruthy()
    expect(await isMatch({ addr: '::ffff:127.0.0.1', type: 'IPv6' }, '::ffff:7f00:1')).toBeTruthy()
  })
  it('Function Rules', async () => {
    expect(await isMatch({ addr: '0.0.0.0', type: 'IPv4' }, () => true)).toBeTruthy()
    expect(await isMatch({ addr: '0.0.0.0', type: 'IPv4' }, () => false)).toBeFalsy()

    const ipaddr = '93.184.216.34'
    await isMatch({ addr: ipaddr, type: 'IPv4' }, (ip) => {
      expect(ipaddr).toBe(ip.addr)
      return false
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/ip-restriction/index.ts
```typescript
/**
 * IP Restriction Middleware for Hono
 * @module
 */

import type { Context, MiddlewareHandler } from '../..'
import type { AddressType, GetConnInfo } from '../../helper/conninfo'
import { HTTPException } from '../../http-exception'
import {
  convertIPv4ToBinary,
  convertIPv6BinaryToString,
  convertIPv6ToBinary,
  distinctRemoteAddr,
} from '../../utils/ipaddr'

/**
 * Function to get IP Address
 */
type GetIPAddr = GetConnInfo | ((c: Context) => string)

/**
 * ### IPv4 and IPv6
 * - `*` match all
 *
 * ### IPv4
 * - `192.168.2.0` static
 * - `192.168.2.0/24` CIDR Notation
 *
 * ### IPv6
 * - `::1` static
 * - `::1/10` CIDR Notation
 */
type IPRestrictionRuleFunction = (addr: { addr: string; type: AddressType }) => boolean
export type IPRestrictionRule = string | ((addr: { addr: string; type: AddressType }) => boolean)

const IS_CIDR_NOTATION_REGEX = /\/[0-9]{0,3}$/
const buildMatcher = (
  rules: IPRestrictionRule[]
): ((addr: { addr: string; type: AddressType; isIPv4: boolean }) => boolean) => {
  const functionRules: IPRestrictionRuleFunction[] = []
  const staticRules: Set<string> = new Set()
  const cidrRules: [boolean, bigint, bigint][] = []

  for (let rule of rules) {
    if (rule === '*') {
      return () => true
    } else if (typeof rule === 'function') {
      functionRules.push(rule)
    } else {
      if (IS_CIDR_NOTATION_REGEX.test(rule)) {
        const separatedRule = rule.split('/')

        const addrStr = separatedRule[0]
        const type = distinctRemoteAddr(addrStr)
        if (type === undefined) {
          throw new TypeError(`Invalid rule: ${rule}`)
        }

        const isIPv4 = type === 'IPv4'
        const prefix = parseInt(separatedRule[1])

        if (isIPv4 ? prefix === 32 : prefix === 128) {
          // this rule is a static rule
          rule = addrStr
        } else {
          const addr = (isIPv4 ? convertIPv4ToBinary : convertIPv6ToBinary)(addrStr)
          const mask = ((1n << BigInt(prefix)) - 1n) << BigInt((isIPv4 ? 32 : 128) - prefix)

          cidrRules.push([isIPv4, addr & mask, mask] as [boolean, bigint, bigint])
          continue
        }
      }

      const type = distinctRemoteAddr(rule)
      if (type === undefined) {
        throw new TypeError(`Invalid rule: ${rule}`)
      }
      staticRules.add(
        type === 'IPv4'
          ? rule // IPv4 address is already normalized, so it is registered as is.
          : convertIPv6BinaryToString(convertIPv6ToBinary(rule)) // normalize IPv6 address (e.g. 0000:0000:0000:0000:0000:0000:0000:0001 => ::1)
      )
    }
  }

  return (remote: {
    addr: string
    type: AddressType
    isIPv4: boolean
    binaryAddr?: bigint
  }): boolean => {
    if (staticRules.has(remote.addr)) {
      return true
    }
    for (const [isIPv4, addr, mask] of cidrRules) {
      if (isIPv4 !== remote.isIPv4) {
        continue
      }
      const remoteAddr = (remote.binaryAddr ||= (
        isIPv4 ? convertIPv4ToBinary : convertIPv6ToBinary
      )(remote.addr))
      if ((remoteAddr & mask) === addr) {
        return true
      }
    }
    for (const rule of functionRules) {
      if (rule({ addr: remote.addr, type: remote.type })) {
        return true
      }
    }
    return false
  }
}

/**
 * Rules for IP Restriction Middleware
 */
export interface IPRestrictionRules {
  denyList?: IPRestrictionRule[]
  allowList?: IPRestrictionRule[]
}

/**
 * IP Restriction Middleware
 *
 * @param getIP function to get IP Address
 */
export const ipRestriction = (
  getIP: GetIPAddr,
  { denyList = [], allowList = [] }: IPRestrictionRules,
  onError?: (
    remote: { addr: string; type: AddressType },
    c: Context
  ) => Response | Promise<Response>
): MiddlewareHandler => {
  const allowLength = allowList.length

  const denyMatcher = buildMatcher(denyList)
  const allowMatcher = buildMatcher(allowList)

  const blockError = (c: Context): HTTPException =>
    new HTTPException(403, {
      res: c.text('Forbidden', {
        status: 403,
      }),
    })

  return async function ipRestriction(c, next) {
    const connInfo = getIP(c)
    const addr = typeof connInfo === 'string' ? connInfo : connInfo.remote.address
    if (!addr) {
      throw blockError(c)
    }
    const type =
      (typeof connInfo !== 'string' && connInfo.remote.addressType) || distinctRemoteAddr(addr)

    const remoteData = { addr, type, isIPv4: type === 'IPv4' }

    if (denyMatcher(remoteData)) {
      if (onError) {
        return onError({ addr, type }, c)
      }
      throw blockError(c)
    }
    if (allowMatcher(remoteData)) {
      return await next()
    }

    if (allowLength === 0) {
      return await next()
    } else {
      if (onError) {
        return await onError({ addr, type }, c)
      }
      throw blockError(c)
    }
  }
}

```
