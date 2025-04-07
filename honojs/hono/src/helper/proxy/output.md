/Users/josh/Documents/GitHub/honojs/hono/src/helper/proxy/index.test.ts
```typescript
import { Hono } from '../../hono'
import { proxy } from '.'

describe('Proxy Middleware', () => {
  describe('proxy', () => {
    beforeEach(() => {
      global.fetch = vi.fn().mockImplementation(async (req) => {
        if (req.url === 'https://example.com/ok') {
          return Promise.resolve(new Response('ok'))
        } else if (req.url === 'https://example.com/disconnect') {
          const reader = req.body.getReader()
          let response

          req.signal.addEventListener('abort', () => {
            response = req.signal.reason
            reader.cancel()
          })

          await reader.read()

          return Promise.resolve(new Response(response))
        } else if (req.url === 'https://example.com/compressed') {
          return Promise.resolve(
            new Response('ok', {
              headers: {
                'Content-Encoding': 'gzip',
                'Content-Length': '1',
                'Content-Range': 'bytes 0-2/1024',
                'X-Response-Id': '456',
              },
            })
          )
        } else if (req.url === 'https://example.com/uncompressed') {
          return Promise.resolve(
            new Response('ok', {
              headers: {
                'Content-Length': '2',
                'Content-Range': 'bytes 0-2/1024',
                'X-Response-Id': '456',
              },
            })
          )
        } else if (req.url === 'https://example.com/post' && req.method === 'POST') {
          return Promise.resolve(new Response(`request body: ${await req.text()}`))
        } else if (req.url === 'https://example.com/hop-by-hop') {
          return Promise.resolve(
            new Response('ok', {
              headers: {
                'Transfer-Encoding': 'chunked',
              },
            })
          )
        } else if (req.url === 'https://example.com/set-cookie') {
          return Promise.resolve(
            new Response('ok', {
              headers: {
                'Set-Cookie': 'test=123',
              },
            })
          )
        }
        return Promise.resolve(new Response('not found', { status: 404 }))
      })
    })

    it('compressed', async () => {
      const app = new Hono()
      app.get('/proxy/:path', (c) =>
        proxy(
          new Request(`https://example.com/${c.req.param('path')}`, {
            headers: {
              'X-Request-Id': '123',
              'Accept-Encoding': 'gzip',
            },
          })
        )
      )
      const res = await app.request('/proxy/compressed')
      const req = (global.fetch as ReturnType<typeof vi.fn>).mock.calls[0][0]

      expect(req.url).toBe('https://example.com/compressed')
      expect(req.headers.get('X-Request-Id')).toBe('123')
      expect(req.headers.get('Accept-Encoding')).toBeNull()

      expect(res.status).toBe(200)
      expect(res.headers.get('X-Response-Id')).toBe('456')
      expect(res.headers.get('Content-Encoding')).toBeNull()
      expect(res.headers.get('Content-Length')).toBeNull()
      expect(res.headers.get('Content-Range')).toBe('bytes 0-2/1024')
    })

    it('uncompressed', async () => {
      const app = new Hono()
      app.get('/proxy/:path', (c) =>
        proxy(
          new Request(`https://example.com/${c.req.param('path')}`, {
            headers: {
              'X-Request-Id': '123',
              'Accept-Encoding': 'gzip',
            },
          })
        )
      )
      const res = await app.request('/proxy/uncompressed')
      const req = (global.fetch as ReturnType<typeof vi.fn>).mock.calls[0][0]

      expect(req.url).toBe('https://example.com/uncompressed')
      expect(req.headers.get('X-Request-Id')).toBe('123')
      expect(req.headers.get('Accept-Encoding')).toBeNull()

      expect(res.status).toBe(200)
      expect(res.headers.get('X-Response-Id')).toBe('456')
      expect(res.headers.get('Content-Length')).toBe('2')
      expect(res.headers.get('Content-Range')).toBe('bytes 0-2/1024')
    })

    it('POST request', async () => {
      const app = new Hono()
      app.all('/proxy/:path', (c) => {
        return proxy(`https://example.com/${c.req.param('path')}`, {
          ...c.req,
          headers: {
            ...c.req.header(),
            'X-Request-Id': '123',
            'Accept-Encoding': 'gzip',
          },
        })
      })
      const res = await app.request('/proxy/post', {
        method: 'POST',
        body: 'test',
      })
      const req = (global.fetch as ReturnType<typeof vi.fn>).mock.calls[0][0]

      expect(req.url).toBe('https://example.com/post')

      expect(res.status).toBe(200)
      expect(await res.text()).toBe('request body: test')
    })

    it('remove hop-by-hop headers', async () => {
      const app = new Hono()
      app.get('/proxy/:path', (c) => proxy(`https://example.com/${c.req.param('path')}`))

      const res = await app.request('/proxy/hop-by-hop', {
        headers: {
          Connection: 'keep-alive',
          'Keep-Alive': 'timeout=5, max=1000',
          'Proxy-Authorization': 'Basic 123456',
        },
      })
      const req = (global.fetch as ReturnType<typeof vi.fn>).mock.calls[0][0]

      expect(req.headers.get('Connection')).toBeNull()
      expect(req.headers.get('Keep-Alive')).toBeNull()
      expect(req.headers.get('Proxy-Authorization')).toBeNull()

      expect(res.headers.get('Transfer-Encoding')).toBeNull()
    })

    it('specify hop-by-hop header by options', async () => {
      const app = new Hono()
      app.get('/proxy/:path', (c) =>
        proxy(`https://example.com/${c.req.param('path')}`, {
          headers: {
            'Proxy-Authorization': 'Basic 123456',
          },
        })
      )

      const res = await app.request('/proxy/hop-by-hop')
      const req = (global.fetch as ReturnType<typeof vi.fn>).mock.calls[0][0]

      expect(req.headers.get('Proxy-Authorization')).toBe('Basic 123456')

      expect(res.headers.get('Transfer-Encoding')).toBeNull()
    })

    it('modify header', async () => {
      const app = new Hono()
      app.get('/proxy/:path', (c) =>
        proxy(`https://example.com/${c.req.param('path')}`, {
          headers: {
            'Set-Cookie': 'test=123',
          },
        }).then((res) => {
          res.headers.delete('Set-Cookie')
          res.headers.set('X-Response-Id', '456')
          return res
        })
      )
      const res = await app.request('/proxy/set-cookie')
      expect(res.headers.get('Set-Cookie')).toBeNull()
      expect(res.headers.get('X-Response-Id')).toBe('456')
    })

    it('does not propagate undefined request headers', async () => {
      const app = new Hono()
      app.get('/proxy/:path', (c) =>
        proxy(`https://example.com/${c.req.param('path')}`, {
          headers: {
            ...c.req.header(),
            Authorization: undefined,
          },
        })
      )
      await app.request('/proxy/ok', {
        headers: {
          Authorization: 'Bearer 123',
        },
      })
      const req = (global.fetch as ReturnType<typeof vi.fn>).mock.calls[0][0]
      expect(req.headers.get('Authorization')).toBeNull()
    })

    it('client disconnect', async () => {
      const app = new Hono()
      const controller = new AbortController()
      app.post('/proxy/:path', (c) => proxy(`https://example.com/${c.req.param('path')}`, c.req))
      const resPromise = app.request('/proxy/disconnect', {
        method: 'POST',
        body: 'test',
        signal: controller.signal,
      })
      controller.abort('client disconnect')
      const res = await resPromise
      expect(await res.text()).toBe('client disconnect')
    })

    it('not found', async () => {
      const app = new Hono()
      app.get('/proxy/:path', (c) => proxy(`https://example.com/${c.req.param('path')}`))
      const res = await app.request('/proxy/404')
      expect(res.status).toBe(404)
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/helper/proxy/index.ts
````typescript
/**
 * @module
 * Proxy Helper for Hono.
 */

import type { RequestHeader } from '../../utils/headers'

// https://datatracker.ietf.org/doc/html/rfc2616#section-13.5.1
const hopByHopHeaders = [
  'connection',
  'keep-alive',
  'proxy-authenticate',
  'proxy-authorization',
  'te',
  'trailers',
  'transfer-encoding',
]

interface ProxyRequestInit extends Omit<RequestInit, 'headers'> {
  raw?: Request
  headers?:
    | HeadersInit
    | [string, string][]
    | Record<RequestHeader, string | undefined>
    | Record<string, string | undefined>
}

interface ProxyFetch {
  (input: string | URL | Request, init?: ProxyRequestInit): Promise<Response>
}

const buildRequestInitFromRequest = (
  request: Request | undefined
): RequestInit & { duplex?: 'half' } => {
  if (!request) {
    return {}
  }

  const headers = new Headers(request.headers)
  hopByHopHeaders.forEach((header) => {
    headers.delete(header)
  })

  return {
    method: request.method,
    body: request.body,
    duplex: request.body ? 'half' : undefined,
    headers,
    signal: request.signal,
  }
}

const preprocessRequestInit = (requestInit: RequestInit): RequestInit => {
  if (
    !requestInit.headers ||
    Array.isArray(requestInit.headers) ||
    requestInit.headers instanceof Headers
  ) {
    return requestInit
  }

  const headers = new Headers()
  for (const [key, value] of Object.entries(requestInit.headers)) {
    if (value == null) {
      // delete header if value is null or undefined
      headers.delete(key)
    } else {
      headers.set(key, value)
    }
  }
  requestInit.headers = headers
  return requestInit
}

/**
 * Fetch API wrapper for proxy.
 * The parameters and return value are the same as for `fetch` (except for the proxy-specific options).
 *
 * The “Accept-Encoding” header is replaced with an encoding that the current runtime can handle.
 * Unnecessary response headers are deleted and a Response object is returned that can be returned
 * as is as a response from the handler.
 *
 * @example
 * ```ts
 * app.get('/proxy/:path', (c) => {
 *   return proxy(`http://${originServer}/${c.req.param('path')}`, {
 *     headers: {
 *       ...c.req.header(), // optional, specify only when forwarding all the request data (including credentials) is necessary.
 *       'X-Forwarded-For': '127.0.0.1',
 *       'X-Forwarded-Host': c.req.header('host'),
 *       Authorization: undefined, // do not propagate request headers contained in c.req.header('Authorization')
 *     },
 *   }).then((res) => {
 *     res.headers.delete('Set-Cookie')
 *     return res
 *   })
 * })
 *
 * app.all('/proxy/:path', (c) => {
 *   return proxy(`http://${originServer}/${c.req.param('path')}`, {
 *     ...c.req, // optional, specify only when forwarding all the request data (including credentials) is necessary.
 *     headers: {
 *       ...c.req.header(),
 *       'X-Forwarded-For': '127.0.0.1',
 *       'X-Forwarded-Host': c.req.header('host'),
 *       Authorization: undefined, // do not propagate request headers contained in c.req.header('Authorization')
 *     },
 *   })
 * })
 * ```
 */
export const proxy: ProxyFetch = async (input, proxyInit) => {
  const { raw, ...requestInit } = proxyInit ?? {}

  const req = new Request(input, {
    ...buildRequestInitFromRequest(raw),
    ...preprocessRequestInit(requestInit as RequestInit),
  })
  req.headers.delete('accept-encoding')

  const res = await fetch(req)
  const resHeaders = new Headers(res.headers)
  hopByHopHeaders.forEach((header) => {
    resHeaders.delete(header)
  })
  if (resHeaders.has('content-encoding')) {
    resHeaders.delete('content-encoding')
    // Content-Length is the size of the compressed content, not the size of the original content
    resHeaders.delete('content-length')
  }

  return new Response(res.body, {
    status: res.status,
    statusText: res.statusText,
    headers: resHeaders,
  })
}

````
