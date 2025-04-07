/Users/josh/Documents/GitHub/honojs/hono/src/middleware/trailing-slash/index.test.ts
```typescript
import { Hono } from '../../hono'
import { appendTrailingSlash, trimTrailingSlash } from '.'

describe('Resolve trailing slash', () => {
  let app: Hono

  it('Trim', async () => {
    app = new Hono({ strict: true })

    app.use('*', trimTrailingSlash())

    app.get('/', async (c) => {
      return c.text('ok')
    })
    app.get('/the/example/endpoint/without/trailing/slash', async (c) => {
      return c.text('ok')
    })

    let resp: Response, loc: URL

    resp = await app.request('/')
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(200)

    resp = await app.request('/the/example/endpoint/without/trailing/slash')
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(200)

    resp = await app.request('/the/example/endpoint/without/trailing/slash/')
    loc = new URL(resp.headers.get('location')!)
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(301)
    expect(loc.pathname).toBe('/the/example/endpoint/without/trailing/slash')

    resp = await app.request('/the/example/endpoint/without/trailing/slash/?exampleParam=1')
    loc = new URL(resp.headers.get('location')!)
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(301)
    expect(loc.pathname).toBe('/the/example/endpoint/without/trailing/slash')
    expect(loc.searchParams.get('exampleParam')).toBe('1')
  })

  it('Append', async () => {
    app = new Hono({ strict: true })

    app.use('*', appendTrailingSlash())

    app.get('/', async (c) => {
      return c.text('ok')
    })
    app.get('/the/example/endpoint/with/trailing/slash/', async (c) => {
      return c.text('ok')
    })
    app.get('/the/example/simulate/a.file', async (c) => {
      return c.text('ok')
    })

    let resp: Response, loc: URL

    resp = await app.request('/')
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(200)

    resp = await app.request('/the/example/simulate/a.file')
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(200)

    resp = await app.request('/the/example/endpoint/with/trailing/slash/')
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(200)

    resp = await app.request('/the/example/endpoint/with/trailing/slash')
    loc = new URL(resp.headers.get('location')!)
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(301)
    expect(loc.pathname).toBe('/the/example/endpoint/with/trailing/slash/')

    resp = await app.request('/the/example/endpoint/with/trailing/slash?exampleParam=1')
    loc = new URL(resp.headers.get('location')!)
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(301)
    expect(loc.pathname).toBe('/the/example/endpoint/with/trailing/slash/')
    expect(loc.searchParams.get('exampleParam')).toBe('1')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/trailing-slash/index.ts
````typescript
/**
 * @module
 * Trailing Slash Middleware for Hono.
 */

import type { MiddlewareHandler } from '../../types'

/**
 * Trailing Slash Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/trailing-slash}
 *
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use(trimTrailingSlash())
 * app.get('/about/me/', (c) => c.text('With Trailing Slash'))
 * ```
 */
export const trimTrailingSlash = (): MiddlewareHandler => {
  return async function trimTrailingSlash(c, next) {
    await next()

    if (
      c.res.status === 404 &&
      c.req.method === 'GET' &&
      c.req.path !== '/' &&
      c.req.path.at(-1) === '/'
    ) {
      const url = new URL(c.req.url)
      url.pathname = url.pathname.substring(0, url.pathname.length - 1)

      c.res = c.redirect(url.toString(), 301)
    }
  }
}

/**
 * Append trailing slash middleware for Hono.
 * Append a trailing slash to the URL if it doesn't have one. For example, `/path/to/page` will be redirected to `/path/to/page/`.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/trailing-slash}
 *
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use(appendTrailingSlash())
 * ```
 */
export const appendTrailingSlash = (): MiddlewareHandler => {
  return async function appendTrailingSlash(c, next) {
    await next()

    if (c.res.status === 404 && c.req.method === 'GET' && c.req.path.at(-1) !== '/') {
      const url = new URL(c.req.url)
      url.pathname += '/'

      c.res = c.redirect(url.toString(), 301)
    }
  }
}

````
