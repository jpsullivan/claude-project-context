/Users/josh/Documents/GitHub/honojs/hono/src/middleware/bearer-auth/index.test.ts
```typescript
import { Hono } from '../../hono'
import { bearerAuth } from '.'

describe('Bearer Auth by Middleware', () => {
  let app: Hono
  let handlerExecuted: boolean
  let token: string
  let tokens: string[]

  beforeEach(async () => {
    app = new Hono()
    handlerExecuted = false
    token = 'abcdefg12345-._~+/='
    tokens = ['abcdefg12345-._~+/=', 'alternative']

    app.use('/auth/*', bearerAuth({ token }))
    app.use('/auth/*', async (c, next) => {
      c.header('x-custom', 'foo')
      await next()
    })
    app.get('/auth/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use('/authBot/*', bearerAuth({ token, prefix: 'Bot' }))
    app.get('/authBot/*', (c) => {
      handlerExecuted = true
      return c.text('auth bot')
    })

    app.use('/apiKey/*', bearerAuth({ token, prefix: '', headerName: 'X-Api-Key' }))
    app.get('/apiKey/*', (c) => {
      handlerExecuted = true
      return c.text('auth apiKey')
    })

    app.use('/nested/*', async (c, next) => {
      const auth = bearerAuth({ token })
      return auth(c, next)
    })
    app.get('/nested/*', (c) => {
      handlerExecuted = true
      return c.text('auth nested')
    })

    app.use('/auths/*', bearerAuth({ token: tokens }))
    app.get('/auths/*', (c) => {
      handlerExecuted = true
      return c.text('auths')
    })

    app.use(
      '/auth-verify-token/*',
      bearerAuth({
        verifyToken: async (token, c) => {
          return c.req.path === '/auth-verify-token' && token === 'dynamic-token'
        },
      })
    )
    app.get('/auth-verify-token/*', (c) => {
      handlerExecuted = true
      return c.text('auth-verify-token')
    })

    app.use('/auth-custom-header/*', bearerAuth({ token: tokens, headerName: 'X-Auth' }))
    app.get('/auth-custom-header/*', (c) => {
      handlerExecuted = true
      return c.text('auth-custom-header')
    })

    app.use(
      '/auth-custom-no-authentication-header-message-string/*',
      bearerAuth({
        token,
        noAuthenticationHeaderMessage: 'Custom no authentication header message as string',
      })
    )
    app.get('/auth-custom-no-authentication-header-message-string/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-no-authentication-header-message-object/*',
      bearerAuth({
        token,
        noAuthenticationHeaderMessage: {
          message: 'Custom no authentication header message as object',
        },
      })
    )
    app.get('/auth-custom-no-authentication-header-message-object/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-no-authentication-header-message-function-string/*',
      bearerAuth({
        token,
        noAuthenticationHeaderMessage: () =>
          'Custom no authentication header message as function string',
      })
    )
    app.get('/auth-custom-no-authentication-header-message-function-string/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-no-authentication-header-message-function-object/*',
      bearerAuth({
        token,
        noAuthenticationHeaderMessage: () => ({
          message: 'Custom no authentication header message as function object',
        }),
      })
    )
    app.get('/auth-custom-no-authentication-header-message-function-object/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-authentication-header-message-string/*',
      bearerAuth({
        token,
        invalidAuthenticationHeaderMessage:
          'Custom invalid authentication header message as string',
      })
    )
    app.get('/auth-custom-invalid-authentication-header-message-string/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-authentication-header-message-object/*',
      bearerAuth({
        token,
        invalidAuthenticationHeaderMessage: {
          message: 'Custom invalid authentication header message as object',
        },
      })
    )
    app.get('/auth-custom-invalid-authentication-header-message-object/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-authentication-header-message-function-string/*',
      bearerAuth({
        token,
        invalidAuthenticationHeaderMessage: () =>
          'Custom invalid authentication header message as function string',
      })
    )
    app.get('/auth-custom-invalid-authentication-header-message-function-string/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-authentication-header-message-function-object/*',
      bearerAuth({
        token,
        invalidAuthenticationHeaderMessage: () => ({
          message: 'Custom invalid authentication header message as function object',
        }),
      })
    )
    app.get('/auth-custom-invalid-authentication-header-message-function-object/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-token-message-string/*',
      bearerAuth({
        token,
        invalidTokenMessage: 'Custom invalid token message as string',
      })
    )
    app.get('/auth-custom-invalid-token-message-string/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-token-message-object/*',
      bearerAuth({
        token,
        invalidTokenMessage: { message: 'Custom invalid token message as object' },
      })
    )
    app.get('/auth-custom-invalid-token-message-object/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-token-message-function-string/*',
      bearerAuth({
        token,
        invalidTokenMessage: () => 'Custom invalid token message as function string',
      })
    )
    app.get('/auth-custom-invalid-token-message-function-string/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-token-message-function-object/*',
      bearerAuth({
        token,
        invalidTokenMessage: () => ({
          message: 'Custom invalid token message as function object',
        }),
      })
    )
    app.get('/auth-custom-invalid-token-message-function-object/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })
  })

  it('Should authorize', async () => {
    const req = new Request('http://localhost/auth/a')
    req.headers.set('Authorization', 'Bearer abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res.text()).toBe('auth')
    expect(res.headers.get('x-custom')).toBe('foo')
  })

  it('Should not authorize - no authorization header', async () => {
    const req = new Request('http://localhost/auth/a')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Unauthorized')
    expect(res.headers.get('x-custom')).toBeNull()
  })

  it('Should not authorize - invalid request', async () => {
    const req = new Request('http://localhost/auth/a')
    req.headers.set('Authorization', 'Beare abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(handlerExecuted).toBeFalsy()
    expect(res.status).toBe(400)
    expect(await res.text()).toBe('Bad Request')
    expect(res.headers.get('x-custom')).toBeNull()
  })

  it('Should not authorize - invalid token', async () => {
    const req = new Request('http://localhost/auth/a')
    req.headers.set('Authorization', 'Bearer invalid-token')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
    expect(res.headers.get('x-custom')).toBeNull()
  })

  it('Should authorize', async () => {
    const req = new Request('http://localhost/authBot/a')
    req.headers.set('Authorization', 'Bot abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res.text()).toBe('auth bot')
  })

  it('Should not authorize - invalid request', async () => {
    const req = new Request('http://localhost/authBot/a')
    req.headers.set('Authorization', 'Bearer abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(handlerExecuted).toBeFalsy()
    expect(res.status).toBe(400)
    expect(await res.text()).toBe('Bad Request')
  })

  it('Should authorize', async () => {
    const req = new Request('http://localhost/apiKey/a')
    req.headers.set('X-Api-Key', 'abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res.text()).toBe('auth apiKey')
  })

  it('Should not authorize - invalid request', async () => {
    const req = new Request('http://localhost/apiKey/a')
    req.headers.set('Authorization', 'Bearer abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(handlerExecuted).toBeFalsy()
    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
  })

  it('Should authorize - nested', async () => {
    const req = new Request('http://localhost/nested/a')
    req.headers.set('Authorization', 'Bearer abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res.text()).toBe('auth nested')
  })

  it('Should not authorize - nested', async () => {
    const req = new Request('http://localhost/nested/a')
    req.headers.set('Authorization', 'Bearer invalid-token')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(handlerExecuted).toBeFalsy()
    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
  })

  it('Should authorize - with any token in list', async () => {
    const req1 = new Request('http://localhost/auths/a')
    req1.headers.set('Authorization', 'Bearer abcdefg12345-._~+/=')
    const res1 = await app.request(req1)
    expect(res1).not.toBeNull()
    expect(res1.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res1.text()).toBe('auths')

    const req2 = new Request('http://localhost/auths/a')
    req2.headers.set('Authorization', 'Bearer alternative')
    const res2 = await app.request(req2)
    expect(res2).not.toBeNull()
    expect(res2.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res2.text()).toBe('auths')
  })

  it('Should authorize - verifyToken option', async () => {
    const res = await app.request('/auth-verify-token', {
      headers: { Authorization: 'Bearer dynamic-token' },
    })
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res.text()).toBe('auth-verify-token')
  })

  it('Should not authorize - verifyToken option', async () => {
    const res = await app.request('/auth-verify-token', {
      headers: { Authorization: 'Bearer invalid-token' },
    })
    expect(res).not.toBeNull()
    expect(handlerExecuted).toBeFalsy()
    expect(res.status).toBe(401)
  })

  it('Should authorize - custom header', async () => {
    const req = new Request('http://localhost/auth-custom-header/a')
    req.headers.set('X-Auth', 'Bearer abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res.text()).toBe('auth-custom-header')
  })

  it('Should not authorize - custom header', async () => {
    const req = new Request('http://localhost/auth-custom-header/a')
    req.headers.set('X-Auth', 'Bearer invalid-token')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(handlerExecuted).toBeFalsy()
    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
  })

  it('Should not authorize - custom no authorization header message as string', async () => {
    const req = new Request('http://localhost/auth-custom-no-authentication-header-message-string')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Custom no authentication header message as string')
  })

  it('Should not authorize - custom no authorization header message as object', async () => {
    const req = new Request('http://localhost/auth-custom-no-authentication-header-message-object')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(res.headers.get('Content-Type')).toMatch('application/json')
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('{"message":"Custom no authentication header message as object"}')
  })

  it('Should not authorize - custom no authorization header message as function string', async () => {
    const req = new Request(
      'http://localhost/auth-custom-no-authentication-header-message-function-string'
    )
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Custom no authentication header message as function string')
  })

  it('Should not authorize - custom no authorization header message as function object', async () => {
    const req = new Request(
      'http://localhost/auth-custom-no-authentication-header-message-function-object'
    )
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(res.headers.get('Content-Type')).toMatch('application/json')
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe(
      '{"message":"Custom no authentication header message as function object"}'
    )
  })

  it('Should not authorize - custom invalid authentication header message as string', async () => {
    const req = new Request(
      'http://localhost/auth-custom-invalid-authentication-header-message-string'
    )
    req.headers.set('Authorization', 'Beare abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(400)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Custom invalid authentication header message as string')
  })

  it('Should not authorize - custom invalid authentication header message as object', async () => {
    const req = new Request(
      'http://localhost/auth-custom-invalid-authentication-header-message-object'
    )
    req.headers.set('Authorization', 'Beare abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(400)
    expect(res.headers.get('Content-Type')).toMatch('application/json')
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe(
      '{"message":"Custom invalid authentication header message as object"}'
    )
  })

  it('Should not authorize - custom invalid authentication header message as function string', async () => {
    const req = new Request(
      'http://localhost/auth-custom-invalid-authentication-header-message-function-string'
    )
    req.headers.set('Authorization', 'Beare abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(400)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Custom invalid authentication header message as function string')
  })

  it('Should not authorize - custom invalid authentication header message as function object', async () => {
    const req = new Request(
      'http://localhost/auth-custom-invalid-authentication-header-message-function-object'
    )
    req.headers.set('Authorization', 'Beare abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(400)
    expect(res.headers.get('Content-Type')).toMatch('application/json')
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe(
      '{"message":"Custom invalid authentication header message as function object"}'
    )
  })

  it('Should not authorize - custom invalid token message as string', async () => {
    const req = new Request('http://localhost/auth-custom-invalid-token-message-string')
    req.headers.set('Authorization', 'Bearer invalid-token')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Custom invalid token message as string')
  })

  it('Should not authorize - custom invalid token message as object', async () => {
    const req = new Request('http://localhost/auth-custom-invalid-token-message-object')
    req.headers.set('Authorization', 'Bearer invalid-token')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(res.headers.get('Content-Type')).toMatch('application/json')
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('{"message":"Custom invalid token message as object"}')
  })

  it('Should not authorize - custom invalid token message as function string', async () => {
    const req = new Request('http://localhost/auth-custom-invalid-token-message-function-string')
    req.headers.set('Authorization', 'Bearer invalid-token')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Custom invalid token message as function string')
  })

  it('Should not authorize - custom invalid token message as function object', async () => {
    const req = new Request('http://localhost/auth-custom-invalid-token-message-function-object')
    req.headers.set('Authorization', 'Bearer invalid-token')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(res.headers.get('Content-Type')).toMatch('application/json')
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('{"message":"Custom invalid token message as function object"}')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/bearer-auth/index.ts
````typescript
/**
 * @module
 * Bearer Auth Middleware for Hono.
 */

import type { Context } from '../../context'
import { HTTPException } from '../../http-exception'
import type { MiddlewareHandler } from '../../types'
import { timingSafeEqual } from '../../utils/buffer'
import type { ContentfulStatusCode } from '../../utils/http-status'

const TOKEN_STRINGS = '[A-Za-z0-9._~+/-]+=*'
const PREFIX = 'Bearer'
const HEADER = 'Authorization'

type MessageFunction = (c: Context) => string | object | Promise<string | object>

type BearerAuthOptions =
  | {
      token: string | string[]
      realm?: string
      prefix?: string
      headerName?: string
      hashFunction?: Function
      noAuthenticationHeaderMessage?: string | object | MessageFunction
      invalidAuthenticationHeaderMessage?: string | object | MessageFunction
      invalidTokenMessage?: string | object | MessageFunction
    }
  | {
      realm?: string
      prefix?: string
      headerName?: string
      verifyToken: (token: string, c: Context) => boolean | Promise<boolean>
      hashFunction?: Function
      noAuthenticationHeaderMessage?: string | object | MessageFunction
      invalidAuthenticationHeaderMessage?: string | object | MessageFunction
      invalidTokenMessage?: string | object | MessageFunction
    }

/**
 * Bearer Auth Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/bearer-auth}
 *
 * @param {BearerAuthOptions} options - The options for the bearer authentication middleware.
 * @param {string | string[]} [options.token] - The string or array of strings to validate the incoming bearer token against.
 * @param {Function} [options.verifyToken] - The function to verify the token.
 * @param {string} [options.realm=""] - The domain name of the realm, as part of the returned WWW-Authenticate challenge header.
 * @param {string} [options.prefix="Bearer"] - The prefix (or known as `schema`) for the Authorization header value. If set to the empty string, no prefix is expected.
 * @param {string} [options.headerName=Authorization] - The header name.
 * @param {Function} [options.hashFunction] - A function to handle hashing for safe comparison of authentication tokens.
 * @param {string | object | MessageFunction} [options.noAuthenticationHeaderMessage="Unauthorized"] - The no authentication header message.
 * @param {string | object | MessageFunction} [options.invalidAuthenticationHeaderMeasage="Bad Request"] - The invalid authentication header message.
 * @param {string | object | MessageFunction} [options.invalidTokenMessage="Unauthorized"] - The invalid token message.
 * @returns {MiddlewareHandler} The middleware handler function.
 * @throws {Error} If neither "token" nor "verifyToken" options are provided.
 * @throws {HTTPException} If authentication fails, with 401 status code for missing or invalid token, or 400 status code for invalid request.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * const token = 'honoishot'
 *
 * app.use('/api/*', bearerAuth({ token }))
 *
 * app.get('/api/page', (c) => {
 *   return c.json({ message: 'You are authorized' })
 * })
 * ```
 */
export const bearerAuth = (options: BearerAuthOptions): MiddlewareHandler => {
  if (!('token' in options || 'verifyToken' in options)) {
    throw new Error('bearer auth middleware requires options for "token"')
  }
  if (!options.realm) {
    options.realm = ''
  }
  if (options.prefix === undefined) {
    options.prefix = PREFIX
  }

  const realm = options.realm?.replace(/"/g, '\\"')
  const prefixRegexStr = options.prefix === '' ? '' : `${options.prefix} +`
  const regexp = new RegExp(`^${prefixRegexStr}(${TOKEN_STRINGS}) *$`)
  const wwwAuthenticatePrefix = options.prefix === '' ? '' : `${options.prefix} `

  const throwHTTPException = async (
    c: Context,
    status: ContentfulStatusCode,
    wwwAuthenticateHeader: string,
    messageOption: string | object | MessageFunction
  ): Promise<Response> => {
    const headers = {
      'WWW-Authenticate': wwwAuthenticateHeader,
    }
    const responseMessage =
      typeof messageOption === 'function' ? await messageOption(c) : messageOption
    const res =
      typeof responseMessage === 'string'
        ? new Response(responseMessage, { status, headers })
        : new Response(JSON.stringify(responseMessage), {
            status,
            headers: {
              ...headers,
              'content-type': 'application/json',
            },
          })
    throw new HTTPException(status, { res })
  }

  return async function bearerAuth(c, next) {
    const headerToken = c.req.header(options.headerName || HEADER)
    if (!headerToken) {
      // No Authorization header
      await throwHTTPException(
        c,
        401,
        `${wwwAuthenticatePrefix}realm="${realm}"`,
        options.noAuthenticationHeaderMessage || 'Unauthorized'
      )
    } else {
      const match = regexp.exec(headerToken)
      if (!match) {
        // Invalid Request
        await throwHTTPException(
          c,
          400,
          `${wwwAuthenticatePrefix}error="invalid_request"`,
          options.invalidAuthenticationHeaderMessage || 'Bad Request'
        )
      } else {
        let equal = false
        if ('verifyToken' in options) {
          equal = await options.verifyToken(match[1], c)
        } else if (typeof options.token === 'string') {
          equal = await timingSafeEqual(options.token, match[1], options.hashFunction)
        } else if (Array.isArray(options.token) && options.token.length > 0) {
          for (const token of options.token) {
            if (await timingSafeEqual(token, match[1], options.hashFunction)) {
              equal = true
              break
            }
          }
        }
        if (!equal) {
          // Invalid Token
          await throwHTTPException(
            c,
            401,
            `${wwwAuthenticatePrefix}error="invalid_token"`,
            options.invalidTokenMessage || 'Unauthorized'
          )
        }
      }
    }
    await next()
  }
}

````
