/Users/josh/Documents/GitHub/honojs/hono/src/adapter/vercel/conninfo.test.ts
```typescript
import { Context } from '../../context'
import { getConnInfo } from './conninfo'

describe('getConnInfo', () => {
  it('Should getConnInfo works', () => {
    const address = Math.random().toString()
    const req = new Request('http://localhost/', {
      headers: {
        'x-real-ip': address,
      },
    })
    const c = new Context(req)

    const info = getConnInfo(c)

    expect(info.remote.address).toBe(address)
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/vercel/conninfo.ts
```typescript
import type { GetConnInfo } from '../../helper/conninfo'

export const getConnInfo: GetConnInfo = (c) => ({
  remote: {
    // https://github.com/vercel/vercel/blob/b70bfb5fbf28a4650d4042ce68ca5c636d37cf44/packages/edge/src/edge-headers.ts#L10-L12C32
    address: c.req.header('x-real-ip'),
  },
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/vercel/handler.test.ts
```typescript
import { Hono } from '../../hono'
import { handle } from './handler'

describe('Adapter for Next.js', () => {
  it('Should return 200 response', async () => {
    const app = new Hono()
    app.get('/api/author/:name', async (c) => {
      const name = c.req.param('name')
      return c.json({
        path: '/api/author/:name',
        name,
      })
    })
    const handler = handle(app)
    const req = new Request('http://localhost/api/author/hono')
    const res = await handler(req)
    expect(res.status).toBe(200)
    expect(await res.json()).toEqual({
      path: '/api/author/:name',
      name: 'hono',
    })
  })

  it('Should not use `route()` if path argument is not passed', async () => {
    const app = new Hono().basePath('/api')

    app.onError((e) => {
      throw e
    })
    app.get('/error', () => {
      throw new Error('Custom Error')
    })

    const handler = handle(app)
    const req = new Request('http://localhost/api/error')
    expect(() => handler(req)).toThrowError('Custom Error')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/vercel/handler.ts
```typescript
/* eslint-disable @typescript-eslint/no-explicit-any */
import type { Hono } from '../../hono'

export const handle =
  (app: Hono<any, any, any>) =>
  (req: Request): Response | Promise<Response> => {
    return app.fetch(req)
  }

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/vercel/index.ts
```typescript
/**
 * @module
 * Vercel Adapter for Hono.
 */

export { handle } from './handler'
export { getConnInfo } from './conninfo'

```
