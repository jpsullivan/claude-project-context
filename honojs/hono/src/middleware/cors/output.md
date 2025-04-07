/Users/josh/Documents/GitHub/honojs/hono/src/middleware/cors/index.test.ts
```typescript
import { Hono } from '../../hono'
import { cors } from '../../middleware/cors'

describe('CORS by Middleware', () => {
  const app = new Hono()

  app.use('/api/*', cors())

  app.use(
    '/api2/*',
    cors({
      origin: 'http://example.com',
      allowHeaders: ['X-Custom-Header', 'Upgrade-Insecure-Requests'],
      allowMethods: ['POST', 'GET', 'OPTIONS'],
      exposeHeaders: ['Content-Length', 'X-Kuma-Revision'],
      maxAge: 600,
      credentials: true,
    })
  )

  app.use(
    '/api3/*',
    cors({
      origin: ['http://example.com', 'http://example.org', 'http://example.dev'],
    })
  )

  app.use(
    '/api4/*',
    cors({
      origin: (origin) => (origin.endsWith('.example.com') ? origin : 'http://example.com'),
    })
  )

  app.use('/api5/*', cors())

  app.use(
    '/api6/*',
    cors({
      origin: 'http://example.com',
    })
  )
  app.use(
    '/api6/*',
    cors({
      origin: 'http://example.com',
    })
  )

  app.get('/api/abc', (c) => {
    return c.json({ success: true })
  })

  app.get('/api2/abc', (c) => {
    return c.json({ success: true })
  })

  app.get('/api3/abc', (c) => {
    return c.json({ success: true })
  })

  app.get('/api4/abc', (c) => {
    return c.json({ success: true })
  })

  app.get('/api5/abc', () => {
    return new Response(JSON.stringify({ success: true }))
  })

  it('GET default', async () => {
    const res = await app.request('http://localhost/api/abc')

    expect(res.status).toBe(200)
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('*')
    expect(res.headers.get('Vary')).toBeNull()
  })

  it('Preflight default', async () => {
    const req = new Request('https://localhost/api/abc', { method: 'OPTIONS' })
    req.headers.append('Access-Control-Request-Headers', 'X-PINGOTHER, Content-Type')
    const res = await app.request(req)

    expect(res.status).toBe(204)
    expect(res.statusText).toBe('No Content')
    expect(res.headers.get('Access-Control-Allow-Methods')?.split(',')[0]).toBe('GET')
    expect(res.headers.get('Access-Control-Allow-Headers')?.split(',')).toEqual([
      'X-PINGOTHER',
      'Content-Type',
    ])
  })

  it('Preflight with options', async () => {
    const req = new Request('https://localhost/api2/abc', {
      method: 'OPTIONS',
      headers: { origin: 'http://example.com' },
    })
    const res = await app.request(req)

    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('http://example.com')
    expect(res.headers.get('Vary')?.split(/\s*,\s*/)).toEqual(expect.arrayContaining(['Origin']))
    expect(res.headers.get('Access-Control-Allow-Headers')?.split(/\s*,\s*/)).toEqual([
      'X-Custom-Header',
      'Upgrade-Insecure-Requests',
    ])
    expect(res.headers.get('Access-Control-Allow-Methods')?.split(/\s*,\s*/)).toEqual([
      'POST',
      'GET',
      'OPTIONS',
    ])
    expect(res.headers.get('Access-Control-Expose-Headers')?.split(/\s*,\s*/)).toEqual([
      'Content-Length',
      'X-Kuma-Revision',
    ])
    expect(res.headers.get('Access-Control-Max-Age')).toBe('600')
    expect(res.headers.get('Access-Control-Allow-Credentials')).toBe('true')
  })

  it('Disallow an unmatched origin', async () => {
    const req = new Request('https://localhost/api2/abc', {
      method: 'OPTIONS',
      headers: { origin: 'http://example.net' },
    })
    const res = await app.request(req)
    expect(res.headers.has('Access-Control-Allow-Origin')).toBeFalsy()
  })

  it('Allow multiple origins', async () => {
    let req = new Request('http://localhost/api3/abc', {
      headers: {
        Origin: 'http://example.org',
      },
    })
    let res = await app.request(req)
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('http://example.org')

    req = new Request('http://localhost/api3/abc')
    res = await app.request(req)
    expect(
      res.headers.has('Access-Control-Allow-Origin'),
      'An unmatched origin should be disallowed'
    ).toBeFalsy()

    req = new Request('http://localhost/api3/abc', {
      headers: {
        Referer: 'http://example.net/',
      },
    })
    res = await app.request(req)
    expect(
      res.headers.has('Access-Control-Allow-Origin'),
      'An unmatched origin should be disallowed'
    ).toBeFalsy()
  })

  it('Allow different Vary header value', async () => {
    const res = await app.request('http://localhost/api3/abc', {
      headers: {
        Vary: 'accept-encoding',
        Origin: 'http://example.com',
      },
    })

    expect(res.status).toBe(200)
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('http://example.com')
    expect(res.headers.get('Vary')).toBe('accept-encoding')
  })

  it('Allow origins by function', async () => {
    let req = new Request('http://localhost/api4/abc', {
      headers: {
        Origin: 'http://subdomain.example.com',
      },
    })
    let res = await app.request(req)
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('http://subdomain.example.com')

    req = new Request('http://localhost/api4/abc')
    res = await app.request(req)
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('http://example.com')

    req = new Request('http://localhost/api4/abc', {
      headers: {
        Referer: 'http://evil-example.com/',
      },
    })
    res = await app.request(req)
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('http://example.com')
  })

  it('With raw Response object', async () => {
    const res = await app.request('http://localhost/api5/abc')

    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('*')
    expect(res.headers.get('Vary')).toBeNull()
  })

  it('Should not return duplicate header values', async () => {
    const res = await app.request('http://localhost/api6/abc', {
      headers: {
        origin: 'http://example.com',
      },
    })

    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('http://example.com')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/cors/index.ts
````typescript
/**
 * @module
 * CORS Middleware for Hono.
 */

import type { Context } from '../../context'
import type { MiddlewareHandler } from '../../types'

type CORSOptions = {
  origin: string | string[] | ((origin: string, c: Context) => string | undefined | null)
  allowMethods?: string[]
  allowHeaders?: string[]
  maxAge?: number
  credentials?: boolean
  exposeHeaders?: string[]
}

/**
 * CORS Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/cors}
 *
 * @param {CORSOptions} [options] - The options for the CORS middleware.
 * @param {string | string[] | ((origin: string, c: Context) => string | undefined | null)} [options.origin='*'] - The value of "Access-Control-Allow-Origin" CORS header.
 * @param {string[]} [options.allowMethods=['GET', 'HEAD', 'PUT', 'POST', 'DELETE', 'PATCH']] - The value of "Access-Control-Allow-Methods" CORS header.
 * @param {string[]} [options.allowHeaders=[]] - The value of "Access-Control-Allow-Headers" CORS header.
 * @param {number} [options.maxAge] - The value of "Access-Control-Max-Age" CORS header.
 * @param {boolean} [options.credentials] - The value of "Access-Control-Allow-Credentials" CORS header.
 * @param {string[]} [options.exposeHeaders=[]] - The value of "Access-Control-Expose-Headers" CORS header.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use('/api/*', cors())
 * app.use(
 *   '/api2/*',
 *   cors({
 *     origin: 'http://example.com',
 *     allowHeaders: ['X-Custom-Header', 'Upgrade-Insecure-Requests'],
 *     allowMethods: ['POST', 'GET', 'OPTIONS'],
 *     exposeHeaders: ['Content-Length', 'X-Kuma-Revision'],
 *     maxAge: 600,
 *     credentials: true,
 *   })
 * )
 *
 * app.all('/api/abc', (c) => {
 *   return c.json({ success: true })
 * })
 * app.all('/api2/abc', (c) => {
 *   return c.json({ success: true })
 * })
 * ```
 */
export const cors = (options?: CORSOptions): MiddlewareHandler => {
  const defaults: CORSOptions = {
    origin: '*',
    allowMethods: ['GET', 'HEAD', 'PUT', 'POST', 'DELETE', 'PATCH'],
    allowHeaders: [],
    exposeHeaders: [],
  }
  const opts = {
    ...defaults,
    ...options,
  }

  const findAllowOrigin = ((optsOrigin) => {
    if (typeof optsOrigin === 'string') {
      if (optsOrigin === '*') {
        return () => optsOrigin
      } else {
        return (origin: string) => (optsOrigin === origin ? origin : null)
      }
    } else if (typeof optsOrigin === 'function') {
      return optsOrigin
    } else {
      return (origin: string) => (optsOrigin.includes(origin) ? origin : null)
    }
  })(opts.origin)

  return async function cors(c, next) {
    function set(key: string, value: string) {
      c.res.headers.set(key, value)
    }

    const allowOrigin = findAllowOrigin(c.req.header('origin') || '', c)
    if (allowOrigin) {
      set('Access-Control-Allow-Origin', allowOrigin)
    }

    // Suppose the server sends a response with an Access-Control-Allow-Origin value with an explicit origin (rather than the "*" wildcard).
    // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin
    if (opts.origin !== '*') {
      const existingVary = c.req.header('Vary')

      if (existingVary) {
        set('Vary', existingVary)
      } else {
        set('Vary', 'Origin')
      }
    }

    if (opts.credentials) {
      set('Access-Control-Allow-Credentials', 'true')
    }

    if (opts.exposeHeaders?.length) {
      set('Access-Control-Expose-Headers', opts.exposeHeaders.join(','))
    }

    if (c.req.method === 'OPTIONS') {
      if (opts.maxAge != null) {
        set('Access-Control-Max-Age', opts.maxAge.toString())
      }

      if (opts.allowMethods?.length) {
        set('Access-Control-Allow-Methods', opts.allowMethods.join(','))
      }

      let headers = opts.allowHeaders
      if (!headers?.length) {
        const requestHeaders = c.req.header('Access-Control-Request-Headers')
        if (requestHeaders) {
          headers = requestHeaders.split(/\s*,\s*/)
        }
      }
      if (headers?.length) {
        set('Access-Control-Allow-Headers', headers.join(','))
        c.res.headers.append('Vary', 'Access-Control-Request-Headers')
      }

      c.res.headers.delete('Content-Length')
      c.res.headers.delete('Content-Type')

      return new Response(null, {
        headers: c.res.headers,
        status: 204,
        statusText: 'No Content',
      })
    }
    await next()
  }
}

````
