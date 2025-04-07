/Users/josh/Documents/GitHub/honojs/hono/src/helper/conninfo/index.ts
```typescript
/**
 * @module
 * ConnInfo Helper for Hono.
 */

export type { AddressType, NetAddrInfo, ConnInfo, GetConnInfo } from './types'

```
/Users/josh/Documents/GitHub/honojs/hono/src/helper/conninfo/types.ts
```typescript
import type { Context } from '../../context'

export type AddressType = 'IPv6' | 'IPv4' | undefined

export type NetAddrInfo = {
  /**
   * Transport protocol type
   */
  transport?: 'tcp' | 'udp'
  /**
   * Transport port number
   */
  port?: number

  address?: string
  addressType?: AddressType
} & (
  | {
      /**
       * Host name such as IP Addr
       */
      address: string

      /**
       * Host name type
       */
      addressType: AddressType
    }
  | {}
)

/**
 * HTTP Connection information
 */
export interface ConnInfo {
  /**
   * Remote information
   */
  remote: NetAddrInfo
}

/**
 * Helper type
 */
export type GetConnInfo = (c: Context) => ConnInfo

```
