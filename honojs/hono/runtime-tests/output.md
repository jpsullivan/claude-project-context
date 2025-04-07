/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/tsconfig.json
```json
{
  "extends": "../tsconfig.json",
  "include": [
    "**/*.ts",
    "**/*.tsx"
  ]
}
```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/deno/deno.json
```json
{
  "compilerOptions": {
    "jsx": "react-jsx",
    "jsxImportSource": "hono/jsx",
    "lib": [
      "deno.ns",
      "dom",
      "dom.iterable"
    ]
  },
  "unstable": [
    "sloppy-imports"
  ],
  "imports": {
    "@std/assert": "jsr:@std/assert@^1.0.3",
    "@std/path": "jsr:@std/path@^1.0.3",
    "@std/testing": "jsr:@std/testing@^1.0.1",
    "hono/jsx/jsx-runtime": "../../src/jsx/jsx-runtime.ts"
  }
}
```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/deno/deno.lock
```
{
  "version": "4",
  "specifiers": {
    "jsr:@std/assert@^1.0.3": "1.0.10",
    "jsr:@std/assert@^1.0.6": "1.0.10",
    "jsr:@std/internal@^1.0.5": "1.0.5",
    "jsr:@std/path@^1.0.3": "1.0.6",
    "jsr:@std/testing@^1.0.1": "1.0.3",
    "npm:@types/node@*": "22.5.4"
  },
  "jsr": {
    "@std/assert@1.0.10": {
      "integrity": "59b5cbac5bd55459a19045d95cc7c2ff787b4f8527c0dd195078ff6f9481fbb3",
      "dependencies": [
        "jsr:@std/internal"
      ]
    },
    "@std/internal@1.0.5": {
      "integrity": "54a546004f769c1ac9e025abd15a76b6671ddc9687e2313b67376125650dc7ba"
    },
    "@std/path@1.0.6": {
      "integrity": "ab2c55f902b380cf28e0eec501b4906e4c1960d13f00e11cfbcd21de15f18fed"
    },
    "@std/testing@1.0.3": {
      "integrity": "f98c2bee53860a5916727d7e7d3abe920dd6f9edace022e2d059f00d05c2cf42",
      "dependencies": [
        "jsr:@std/assert@^1.0.6"
      ]
    }
  },
  "npm": {
    "@types/node@22.5.4": {
      "integrity": "sha512-FDuKUJQm/ju9fT/SeX/6+gBzoPzlVCzfzmGkwKvRHQVxi4BntVbyIwf6a4Xn62mrvndLiml6z/UBXIdEVjQLXg==",
      "dependencies": [
        "undici-types"
      ]
    },
    "undici-types@6.19.8": {
      "integrity": "sha512-ve2KP6f/JnbPBFyobGHuerC9g1FYGn/F8n1LWTwNxCEzd6IfqTwUQcNXgEtmmQ6DlRrC1hrSrBnCZPokRrDHjw=="
    }
  },
  "workspace": {
    "dependencies": [
      "jsr:@std/assert@^1.0.3",
      "jsr:@std/path@^1.0.3",
      "jsr:@std/testing@^1.0.1"
    ]
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/deno/hono.test.ts
```typescript
import { assertEquals } from '@std/assert'

import { Context } from '../../src/context.ts'
import { env, getRuntimeKey } from '../../src/helper/adapter/index.ts'
import { Hono } from '../../src/hono.ts'

// Test just only minimal patterns.
// Because others are tested well in Cloudflare Workers environment already.

Deno.env.set('NAME', 'Deno')

Deno.test('Hello World', async () => {
  const app = new Hono()
  app.get('/:foo', (c) => {
    c.header('x-param', c.req.param('foo'))
    c.header('x-query', c.req.query('q') || '')
    return c.text('Hello Deno!')
  })

  const res = await app.request('/foo?q=bar')
  assertEquals(res.status, 200)
  assertEquals(await res.text(), 'Hello Deno!')
  assertEquals(res.headers.get('x-param'), 'foo')
  assertEquals(res.headers.get('x-query'), 'bar')
})

Deno.test('runtime', () => {
  assertEquals(getRuntimeKey(), 'deno')
})

Deno.test('environment variables', () => {
  const c = new Context(new Request('http://localhost/'))
  const { NAME } = env<{ NAME: string }>(c)
  assertEquals(NAME, 'Deno')
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/deno/middleware.test.tsx
```
import { assertEquals, assertMatch } from '@std/assert'
import { dirname, fromFileUrl } from '@std/path'
import { assertSpyCall, assertSpyCalls, spy } from '@std/testing/mock'
import { serveStatic } from '../../src/adapter/deno/index.ts'
import { Hono } from '../../src/hono.ts'
import { basicAuth } from '../../src/middleware/basic-auth/index.ts'
import { jwt } from '../../src/middleware/jwt/index.ts'

// Test just only minimal patterns.
// Because others are already tested well in Cloudflare Workers environment.

Deno.test('Basic Auth Middleware', async () => {
  const app = new Hono()

  const username = 'hono'
  const password = 'ahotproject'

  app.use(
    '/auth/*',
    basicAuth({
      username,
      password,
    })
  )

  app.get('/auth/*', () => new Response('auth'))

  const res = await app.request('http://localhost/auth/a')
  assertEquals(res.status, 401)
  assertEquals(await res.text(), 'Unauthorized')

  const credential = 'aG9ubzphaG90cHJvamVjdA=='

  const req = new Request('http://localhost/auth/a')
  req.headers.set('Authorization', `Basic ${credential}`)
  const resOK = await app.request(req)
  assertEquals(resOK.status, 200)
  assertEquals(await resOK.text(), 'auth')

  const invalidCredential = 'G9ubzphY29vbHByb2plY3Q='

  const req2 = new Request('http://localhost/auth/a')
  req2.headers.set('Authorization', `Basic ${invalidCredential}`)
  const resNG = await app.request(req2)
  assertEquals(resNG.status, 401)
  assertEquals(await resNG.text(), 'Unauthorized')
})

Deno.test('JSX middleware', async () => {
  const app = new Hono()
  app.get('/', (c) => {
    return c.html(<h1>Hello</h1>)
  })
  const res = await app.request('http://localhost/')
  assertEquals(res.status, 200)
  assertEquals(res.headers.get('Content-Type'), 'text/html; charset=UTF-8')
  assertEquals(await res.text(), '<h1>Hello</h1>')

  // Fragment
  const template = (
    <>
      <p>1</p>
      <p>2</p>
    </>
  )
  assertEquals(template.toString(), '<p>1</p><p>2</p>')
})

Deno.test('Serve Static middleware', async () => {
  const app = new Hono()
  const onNotFound = spy(() => {})
  app.all('/favicon.ico', serveStatic({ path: './runtime-tests/deno/favicon.ico' }))
  app.all(
    '/favicon-notfound.ico',
    serveStatic({ path: './runtime-tests/deno/favicon-notfound.ico', onNotFound })
  )
  app.use('/favicon-notfound.ico', async (c, next) => {
    await next()
    c.header('X-Custom', 'Deno')
  })

  app.get(
    '/static/*',
    serveStatic({
      root: './runtime-tests/deno',
      onNotFound,
    })
  )

  app.get(
    '/dot-static/*',
    serveStatic({
      root: './runtime-tests/deno',
      rewriteRequestPath: (path) => path.replace(/^\/dot-static/, './.static'),
    })
  )

  app.get('/static-absolute-root/*', serveStatic({ root: dirname(fromFileUrl(import.meta.url)) }))

  let res = await app.request('http://localhost/favicon.ico')
  assertEquals(res.status, 200)
  assertEquals(res.headers.get('Content-Type'), 'image/x-icon')
  await res.body?.cancel()

  res = await app.request('http://localhost/favicon-notfound.ico')
  assertEquals(res.status, 404)
  assertMatch(res.headers.get('Content-Type') || '', /^text\/plain/)
  assertEquals(res.headers.get('X-Custom'), 'Deno')
  assertSpyCall(onNotFound, 0)

  res = await app.request('http://localhost/static/plain.txt')
  assertEquals(res.status, 200)
  assertEquals(await res.text(), 'Deno!')

  res = await app.request('http://localhost/static/download')
  assertEquals(res.status, 200)
  assertEquals(await res.text(), 'download')

  res = await app.request('http://localhost/dot-static/plain.txt')
  assertEquals(res.status, 200)
  assertEquals(await res.text(), 'Deno!!')
  assertSpyCalls(onNotFound, 1)

  res = await app.fetch({
    method: 'GET',
    url: 'http://localhost/static/%2e%2e/static/plain.txt',
  } as Request)
  assertEquals(res.status, 404)
  assertEquals(await res.text(), '404 Not Found')

  res = await app.request('http://localhost/static/helloworld')
  assertEquals(res.status, 200)
  assertEquals(await res.text(), 'Hi\n')

  res = await app.request('http://localhost/static/hello.world')
  assertEquals(res.status, 200)
  assertEquals(await res.text(), 'Hi\n')

  res = await app.request('http://localhost/static-absolute-root/plain.txt')
  assertEquals(res.status, 200)
  assertEquals(await res.text(), 'Deno!')

  res = await app.request('http://localhost/static')
  assertEquals(res.status, 404)
  assertEquals(await res.text(), '404 Not Found')

  res = await app.request('http://localhost/static/dir')
  assertEquals(res.status, 404)
  assertEquals(await res.text(), '404 Not Found')

  res = await app.request('http://localhost/static/helloworld/nested')
  assertEquals(res.status, 404)
  assertEquals(await res.text(), '404 Not Found')

  res = await app.request('http://localhost/static/helloworld/../')
  assertEquals(res.status, 404)
  assertEquals(await res.text(), '404 Not Found')
})

Deno.test('JWT Authentication middleware', async () => {
  const app = new Hono<{ Variables: { 'x-foo': string } }>()
  app.use('/*', async (c, next) => {
    await next()
    c.header('x-foo', c.get('x-foo') || '')
  })
  app.use('/auth/*', jwt({ secret: 'a-secret' }))
  app.get('/auth/*', (c) => {
    c.set('x-foo', 'bar')
    return new Response('auth')
  })

  const req = new Request('http://localhost/auth/a')
  const res = await app.request(req)
  assertEquals(res.status, 401)
  assertEquals(await res.text(), 'Unauthorized')
  assertEquals(res.headers.get('x-foo'), '')

  const credential =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE'
  const reqOK = new Request('http://localhost/auth/a')
  reqOK.headers.set('Authorization', `Bearer ${credential}`)
  const resOK = await app.request(reqOK)
  assertEquals(resOK.status, 200)
  assertEquals(await resOK.text(), 'auth')
  assertEquals(resOK.headers.get('x-foo'), 'bar')
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/deno/ssg.test.tsx
```
import { assertEquals } from '@std/assert'
import { toSSG } from '../../src/adapter/deno/ssg.ts'
import { Hono } from '../../src/hono.ts'

Deno.test('toSSG function', async () => {
  const app = new Hono()
  app.get('/', (c) => c.text('Hello, World!'))
  app.get('/about', (c) => c.text('About Page'))
  app.get('/about/some', (c) => c.text('About Page 2tier'))
  app.post('/about/some/thing', (c) => c.text('About Page 3tier'))
  app.get('/bravo', (c) => c.html('Bravo Page'))
  app.get('/Charlie', async (c, next) => {
    c.setRenderer((content) => {
      return c.html(
        <html>
          <body>
            <p>{content}</p>
          </body>
        </html>
      )
    })
    await next()
  })
  app.get('/Charlie', (c) => {
    return c.render('Hello!')
  })

  const result = await toSSG(app, { dir: './ssg-static' })
  assertEquals(result.success, true)
  assertEquals(result.error, undefined)
  assertEquals(result.files !== undefined, true)

  await deleteDirectory('./ssg-static')
})

async function deleteDirectory(dirPath: string): Promise<void> {
  try {
    const stat = await Deno.stat(dirPath)

    if (stat.isDirectory) {
      for await (const dirEntry of Deno.readDir(dirPath)) {
        const entryPath = `${dirPath}/${dirEntry.name}`
        await deleteDirectory(entryPath)
      }
      await Deno.remove(dirPath)
    } else {
      await Deno.remove(dirPath)
    }
  } catch (error) {
    console.error(`Error deleting directory: ${error}`)
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/deno/stream.test.ts
```typescript
import { assertEquals } from '@std/assert'
import { stream, streamSSE } from '../../src/helper/streaming/index.ts'
import { Hono } from '../../src/hono.ts'

Deno.test('Should call onAbort via stream', async () => {
  const app = new Hono()
  let aborted = false
  app.get('/stream', (c) => {
    return stream(c, (stream) => {
      stream.onAbort(() => {
        aborted = true
      })
      return new Promise<void>((resolve) => {
        stream.onAbort(resolve)
      })
    })
  })

  const server = Deno.serve({ port: 0 }, app.fetch)
  const ac = new AbortController()
  const req = new Request(`http://localhost:${server.addr.port}/stream`, {
    signal: ac.signal,
  })
  const res = fetch(req).catch(() => {})
  assertEquals(aborted, false)
  await new Promise((resolve) => setTimeout(resolve, 10))
  ac.abort()
  await res
  while (!aborted) {
    await new Promise((resolve) => setTimeout(resolve))
  }
  assertEquals(aborted, true)

  await server.shutdown()
})

Deno.test('Should not call onAbort via stream if already closed', async () => {
  const app = new Hono()
  let aborted = false
  app.get('/stream', (c) => {
    return stream(c, async (stream) => {
      stream.onAbort(() => {
        aborted = true
      })
      await stream.write('Hello')
    })
  })

  const server = Deno.serve({ port: 0 }, app.fetch)
  assertEquals(aborted, false)
  const res = await fetch(`http://localhost:${server.addr.port}/stream`)
  assertEquals(await res.text(), 'Hello')
  assertEquals(aborted, false)
  await server.shutdown()
})

Deno.test('Should call onAbort via streamSSE', async () => {
  const app = new Hono()
  let aborted = false
  app.get('/stream', (c) => {
    return streamSSE(c, (stream) => {
      stream.onAbort(() => {
        aborted = true
      })
      return new Promise<void>((resolve) => {
        stream.onAbort(resolve)
      })
    })
  })

  const server = Deno.serve({ port: 0 }, app.fetch)
  const ac = new AbortController()
  const req = new Request(`http://localhost:${server.addr.port}/stream`, {
    signal: ac.signal,
  })
  assertEquals
  const res = fetch(req).catch(() => {})
  assertEquals(aborted, false)
  await new Promise((resolve) => setTimeout(resolve, 10))
  ac.abort()
  await res
  while (!aborted) {
    await new Promise((resolve) => setTimeout(resolve))
  }
  assertEquals(aborted, true)

  await server.shutdown()
})

Deno.test('Should not call onAbort via streamSSE if already closed', async () => {
  const app = new Hono()
  let aborted = false
  app.get('/stream', (c) => {
    return streamSSE(c, async (stream) => {
      stream.onAbort(() => {
        aborted = true
      })
      await stream.write('Hello')
    })
  })

  const server = Deno.serve({ port: 0 }, app.fetch)
  assertEquals(aborted, false)
  const res = await fetch(`http://localhost:${server.addr.port}/stream`)
  assertEquals(await res.text(), 'Hello')
  assertEquals(aborted, false)
  await server.shutdown()
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/deno/static-absolute-root/plain.txt
```
Deno!
```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/deno/static/download
```
download
```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/deno/static/plain.txt
```
Deno!
```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/deno/static/helloworld/index.html
```html
Hi

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/deno/static/hello.world/index.html
```html
Hi

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/lambda-edge/index.test.ts
```typescript
import type {
  Callback,
  CloudFrontConfig,
  CloudFrontRequest,
  CloudFrontResponse,
} from '../../src/adapter/lambda-edge/handler'
import { handle } from '../../src/adapter/lambda-edge/handler'
import { Hono } from '../../src/hono'
import { basicAuth } from '../../src/middleware/basic-auth'

type Bindings = {
  callback: Callback
  config: CloudFrontConfig
  request: CloudFrontRequest
  response: CloudFrontResponse
}

describe('Lambda@Edge Adapter for Hono', () => {
  const app = new Hono<{ Bindings: Bindings }>()

  app.get('/', (c) => {
    return c.text('Hello Lambda!')
  })

  app.get('/binary', (c) => {
    return c.body('Fake Image', 200, {
      'Content-Type': 'image/png',
    })
  })

  app.post('/post', async (c) => {
    const body = (await c.req.parseBody()) as { message: string }
    return c.text(body.message)
  })

  app.get('/callback/request', async (c, next) => {
    await next()
    c.env.callback(null, c.env.request)
  })

  app.get('/config/eventCheck', async (c, next) => {
    await next()
    if (c.env.config.eventType in ['viewer-request', 'origin-request']) {
      c.env.callback(null, c.env.request)
    } else {
      c.env.callback(null, c.env.response)
    }
  })

  app.get('/callback/response', async (c, next) => {
    await next()
    c.env.callback(null, c.env.response)
  })

  app.post('/post/binary', async (c) => {
    const body = await c.req.blob()
    return c.text(`${body.size} bytes`)
  })

  const username = 'hono-user-a'
  const password = 'hono-password-a'
  app.use('/auth/*', basicAuth({ username, password }))
  app.get('/auth/abc', (c) => c.text('Good Night Lambda!'))

  app.get('/header/add', async (c, next) => {
    c.env.response.headers['Strict-Transport-Security'.toLowerCase()] = [
      {
        key: 'Strict-Transport-Security',
        value: 'max-age=63072000; includeSubdomains; preload',
      },
    ]
    c.env.response.headers['X-Custom'.toLowerCase()] = [
      {
        key: 'X-Custom',
        value: 'Foo',
      },
    ]
    await next()
    c.env.callback(null, c.env.response)
  })

  const handler = handle(app)

  it('Should handle a GET request and return a 200 response (Lambda@Edge viewer request)', async () => {
    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'd111111abcdef8.cloudfront.net',
              distributionId: 'EDFDVBD6EXAMPLE',
              eventType: 'viewer-request',
              requestId: '4TyzHTaYWb1GX1qTfsHhEqV6HUDd_BzoBZnwfnvQc_1oF26ClkoUSEQ==',
            },
            request: {
              clientIp: '203.0.113.178',
              headers: {
                host: [
                  {
                    key: 'Host',
                    value: 'd111111abcdef8.cloudfront.net',
                  },
                ],
                'user-agent': [
                  {
                    key: 'User-Agent',
                    value: 'curl/7.66.0',
                  },
                ],
                accept: [
                  {
                    key: 'accept',
                    value: '*/*',
                  },
                ],
              },
              method: 'GET',
              querystring: '',
              uri: '/',
            },
          },
        },
      ],
    }
    const response = await handler(event)
    expect(response.status).toBe('200')
    expect(response.body).toBe('Hello Lambda!')
    if (response.headers && response.headers['content-type']) {
      expect(response.headers['content-type'][0].value).toMatch(/^text\/plain/)
    } else {
      throw new Error("'content-type' header is missing in the response")
    }
  })

  it('Should handle a GET request and return a 200 response (Lambda@Edge origin request)', async () => {
    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'd111111abcdef8.cloudfront.net',
              distributionId: 'EDFDVBD6EXAMPLE',
              eventType: 'origin-request',
              requestId: '4TyzHTaYWb1GX1qTfsHhEqV6HUDd_BzoBZnwfnvQc_1oF26ClkoUSEQ==',
            },
            request: {
              clientIp: '203.0.113.178',
              headers: {
                'x-forwarded-for': [
                  {
                    key: 'X-Forwarded-For',
                    value: '203.0.113.178',
                  },
                ],
                'user-agent': [
                  {
                    key: 'User-Agent',
                    value: 'Amazon CloudFront',
                  },
                ],
                via: [
                  {
                    key: 'Via',
                    value: '2.0 2afae0d44e2540f472c0635ab62c232b.cloudfront.net (CloudFront)',
                  },
                ],
                host: [
                  {
                    key: 'Host',
                    value: 'example.org',
                  },
                ],
                'cache-control': [
                  {
                    key: 'Cache-Control',
                    value: 'no-cache',
                  },
                ],
              },
              method: 'GET',
              origin: {
                custom: {
                  customHeaders: {},
                  domainName: 'example.org',
                  keepaliveTimeout: 5,
                  path: '',
                  port: 443,
                  protocol: 'https',
                  readTimeout: 30,
                  sslProtocols: ['TLSv1', 'TLSv1.1', 'TLSv1.2'],
                },
              },
              querystring: '',
              uri: '/',
            },
          },
        },
      ],
    }
    const response = await handler(event)
    expect(response.status).toBe('200')
    expect(response.body).toBe('Hello Lambda!')
    if (response.headers && response.headers['content-type']) {
      expect(response.headers['content-type'][0].value).toMatch(/^text\/plain/)
    } else {
      throw new Error("'content-type' header is missing in the response")
    }
  })

  it('Should handle a GET request and return a 200 response (Lambda@Edge viewer response)', async () => {
    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'd111111abcdef8.cloudfront.net',
              distributionId: 'EDFDVBD6EXAMPLE',
              eventType: 'viewer-response',
              requestId: '4TyzHTaYWb1GX1qTfsHhEqV6HUDd_BzoBZnwfnvQc_1oF26ClkoUSEQ==',
            },
            request: {
              clientIp: '203.0.113.178',
              headers: {
                host: [
                  {
                    key: 'Host',
                    value: 'd111111abcdef8.cloudfront.net',
                  },
                ],
                'user-agent': [
                  {
                    key: 'User-Agent',
                    value: 'curl/7.66.0',
                  },
                ],
                accept: [
                  {
                    key: 'accept',
                    value: '*/*',
                  },
                ],
              },
              method: 'GET',
              querystring: '',
              uri: '/',
            },
            response: {
              headers: {
                'access-control-allow-credentials': [
                  {
                    key: 'Access-Control-Allow-Credentials',
                    value: 'true',
                  },
                ],
                'access-control-allow-origin': [
                  {
                    key: 'Access-Control-Allow-Origin',
                    value: '*',
                  },
                ],
                date: [
                  {
                    key: 'Date',
                    value: 'Mon, 13 Jan 2020 20:14:56 GMT',
                  },
                ],
                'referrer-policy': [
                  {
                    key: 'Referrer-Policy',
                    value: 'no-referrer-when-downgrade',
                  },
                ],
                server: [
                  {
                    key: 'Server',
                    value: 'ExampleCustomOriginServer',
                  },
                ],
                'x-content-type-options': [
                  {
                    key: 'X-Content-Type-Options',
                    value: 'nosniff',
                  },
                ],
                'x-frame-options': [
                  {
                    key: 'X-Frame-Options',
                    value: 'DENY',
                  },
                ],
                'x-xss-protection': [
                  {
                    key: 'X-XSS-Protection',
                    value: '1; mode=block',
                  },
                ],
                age: [
                  {
                    key: 'Age',
                    value: '2402',
                  },
                ],
                'content-type': [
                  {
                    key: 'Content-Type',
                    value: 'text/html; charset=utf-8',
                  },
                ],
                'content-length': [
                  {
                    key: 'Content-Length',
                    value: '9593',
                  },
                ],
              },
              status: '200',
              statusDescription: 'OK',
            },
          },
        },
      ],
    }
    const response = await handler(event)
    expect(response.status).toBe('200')
    expect(response.body).toBe('Hello Lambda!')
    if (response.headers && response.headers['content-type']) {
      expect(response.headers['content-type'][0].value).toMatch(/^text\/plain/)
    } else {
      throw new Error("'content-type' header is missing in the response")
    }
  })

  it('Should handle a GET request and return a 200 response (Lambda@Edge origin response)', async () => {
    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'd111111abcdef8.cloudfront.net',
              distributionId: 'EDFDVBD6EXAMPLE',
              eventType: 'origin-response',
              requestId: '4TyzHTaYWb1GX1qTfsHhEqV6HUDd_BzoBZnwfnvQc_1oF26ClkoUSEQ==',
            },
            request: {
              clientIp: '203.0.113.178',
              headers: {
                'x-forwarded-for': [
                  {
                    key: 'X-Forwarded-For',
                    value: '203.0.113.178',
                  },
                ],
                'user-agent': [
                  {
                    key: 'User-Agent',
                    value: 'Amazon CloudFront',
                  },
                ],
                via: [
                  {
                    key: 'Via',
                    value: '2.0 8f22423015641505b8c857a37450d6c0.cloudfront.net (CloudFront)',
                  },
                ],
                host: [
                  {
                    key: 'Host',
                    value: 'example.org',
                  },
                ],
                'cache-control': [
                  {
                    key: 'Cache-Control',
                    value: 'no-cache',
                  },
                ],
              },
              method: 'GET',
              origin: {
                custom: {
                  customHeaders: {},
                  domainName: 'example.org',
                  keepaliveTimeout: 5,
                  path: '',
                  port: 443,
                  protocol: 'https',
                  readTimeout: 30,
                  sslProtocols: ['TLSv1', 'TLSv1.1', 'TLSv1.2'],
                },
              },
              querystring: '',
              uri: '/',
            },
            response: {
              headers: {
                'access-control-allow-credentials': [
                  {
                    key: 'Access-Control-Allow-Credentials',
                    value: 'true',
                  },
                ],
                'access-control-allow-origin': [
                  {
                    key: 'Access-Control-Allow-Origin',
                    value: '*',
                  },
                ],
                date: [
                  {
                    key: 'Date',
                    value: 'Mon, 13 Jan 2020 20:12:38 GMT',
                  },
                ],
                'referrer-policy': [
                  {
                    key: 'Referrer-Policy',
                    value: 'no-referrer-when-downgrade',
                  },
                ],
                server: [
                  {
                    key: 'Server',
                    value: 'ExampleCustomOriginServer',
                  },
                ],
                'x-content-type-options': [
                  {
                    key: 'X-Content-Type-Options',
                    value: 'nosniff',
                  },
                ],
                'x-frame-options': [
                  {
                    key: 'X-Frame-Options',
                    value: 'DENY',
                  },
                ],
                'x-xss-protection': [
                  {
                    key: 'X-XSS-Protection',
                    value: '1; mode=block',
                  },
                ],
                'content-type': [
                  {
                    key: 'Content-Type',
                    value: 'text/html; charset=utf-8',
                  },
                ],
                'content-length': [
                  {
                    key: 'Content-Length',
                    value: '9593',
                  },
                ],
              },
              status: '200',
              statusDescription: 'OK',
            },
          },
        },
      ],
    }
    const response = await handler(event)
    expect(response.status).toBe('200')
    expect(response.body).toBe('Hello Lambda!')
    if (response.headers && response.headers['content-type']) {
      expect(response.headers['content-type'][0].value).toMatch(/^text\/plain/)
    } else {
      throw new Error("'content-type' header is missing in the response")
    }
  })

  it('Should handle a GET request and return a 200 response with binary', async () => {
    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'example.com',
              distributionId: 'EXAMPLE123',
              eventType: 'viewer-request',
              requestId: 'exampleRequestId',
            },
            request: {
              clientIp: '123.123.123.123',
              headers: {
                host: [
                  {
                    key: 'Host',
                    value: 'example.com',
                  },
                ],
              },
              method: 'GET',
              querystring: '',
              uri: '/binary',
            },
          },
        },
      ],
    }

    const response = await handler(event)

    expect(response.status).toBe('200')
    expect(response.body).toBe('RmFrZSBJbWFnZQ==') // base64 encoded fake image
    if (response.headers && response.headers['content-type']) {
      expect(response.headers['content-type'][0].value).toMatch(/^image\/png/)
    } else {
      throw new Error("'content-type' header is missing in the response")
    }
  })

  it('Should handle a GET request and return a 404 response', async () => {
    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'example.com',
              distributionId: 'EXAMPLE123',
              eventType: 'viewer-request',
              requestId: 'exampleRequestId',
            },
            request: {
              clientIp: '123.123.123.123',
              headers: {
                host: [
                  {
                    key: 'Host',
                    value: 'example.com',
                  },
                ],
              },
              method: 'GET',
              querystring: '',
              uri: '/nothing',
            },
          },
        },
      ],
    }

    const response = await handler(event)

    expect(response.status).toBe('404')
  })

  it('Should handle a POST request and return a 200 response', async () => {
    const searchParam = new URLSearchParams()
    searchParam.append('message', 'Good Morning Lambda!')

    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'example.com',
              distributionId: 'EXAMPLE123',
              eventType: 'viewer-request',
              requestId: 'exampleRequestId',
            },
            request: {
              clientIp: '123.123.123.123',
              headers: {
                host: [
                  {
                    key: 'Host',
                    value: 'example.com',
                  },
                ],
                'content-type': [
                  {
                    key: 'Content-Type',
                    value: 'application/x-www-form-urlencoded',
                  },
                ],
              },
              method: 'POST',
              querystring: '',
              uri: '/post',
              body: {
                inputTruncated: false,
                action: 'read-only',
                encoding: 'base64',
                data: Buffer.from(searchParam.toString()).toString('base64'),
              },
            },
          },
        },
      ],
    }

    const response = await handler(event)

    expect(response.status).toBe('200')
    expect(response.body).toBe('Good Morning Lambda!')
  })

  it('Should handle a POST request with binary and return a 200 response', async () => {
    const array = new Uint8Array([0xc0, 0xff, 0xee])
    const buffer = Buffer.from(array)
    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'example.com',
              distributionId: 'EXAMPLE123',
              eventType: 'viewer-request',
              requestId: 'exampleRequestId',
            },
            request: {
              clientIp: '123.123.123.123',
              headers: {
                host: [
                  {
                    key: 'Host',
                    value: 'example.com',
                  },
                ],
                'content-type': [
                  {
                    key: 'Content-Type',
                    value: 'application/x-www-form-urlencoded',
                  },
                ],
              },
              method: 'POST',
              querystring: '',
              uri: '/post/binary',
              body: {
                inputTruncated: false,
                action: 'read-only',
                encoding: 'base64',
                data: buffer.toString('base64'),
              },
            },
          },
        },
      ],
    }

    const response = await handler(event)
    expect(response.status).toBe('200')
    expect(response.body).toBe('3 bytes')
  })

  it('Should handle a request and return a 401 response with Basic auth', async () => {
    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'example.com',
              distributionId: 'EXAMPLE123',
              eventType: 'viewer-request',
              requestId: 'exampleRequestId',
            },
            request: {
              clientIp: '123.123.123.123',
              headers: {
                host: [
                  {
                    key: 'Host',
                    value: 'example.com',
                  },
                ],
                'content-type': [
                  {
                    key: 'Content-Type',
                    value: 'plain/text',
                  },
                ],
              },
              method: 'GET',
              querystring: '',
              uri: '/auth/abc',
            },
          },
        },
      ],
    }

    const response = await handler(event)

    expect(response.status).toBe('401')
  })

  it('Should handle a request and return a 401 response with Basic auth', async () => {
    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'example.com',
              distributionId: 'EXAMPLE123',
              eventType: 'viewer-request',
              requestId: 'exampleRequestId',
            },
            request: {
              clientIp: '123.123.123.123',
              headers: {
                host: [
                  {
                    key: 'Host',
                    value: 'example.com',
                  },
                ],
                'content-type': [
                  {
                    key: 'Content-Type',
                    value: 'plain/text',
                  },
                ],
              },
              method: 'GET',
              querystring: '',
              uri: '/auth/abc',
            },
          },
        },
      ],
    }

    const response = await handler(event)

    expect(response.status).toBe('401')
  })

  it('Should call a callback to continue processing the request', async () => {
    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'example.com',
              distributionId: 'EXAMPLE123',
              eventType: 'viewer-request',
              requestId: 'exampleRequestId',
            },
            request: {
              clientIp: '123.123.123.123',
              headers: {},
              method: 'GET',
              querystring: '',
              uri: '/callback/request',
            },
          },
        },
      ],
    }

    let called = false
    let requestClientIp = ''

    await handler(event, {}, (_err, result) => {
      if (result && 'clientIp' in result) {
        requestClientIp = result.clientIp
      }
      called = true
    })

    expect(called).toBe(true)
    expect(requestClientIp).toBe('123.123.123.123')
  })

  it('Should call a callback to continue processing the response', async () => {
    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'example.com',
              distributionId: 'EDFDVBD6EXAMPLE',
              eventType: 'viewer-response',
              requestId: '4TyzHTaYWb1GX1qTfsHhEqV6HUDd_BzoBZnwfnvQc_1oF26ClkoUSEQ==',
            },
            request: {
              clientIp: '203.0.113.178',
              headers: {
                host: [
                  {
                    key: 'Host',
                    value: 'example.com',
                  },
                ],
                'user-agent': [
                  {
                    key: 'User-Agent',
                    value: 'curl/7.66.0',
                  },
                ],
                accept: [
                  {
                    key: 'accept',
                    value: '*/*',
                  },
                ],
              },
              method: 'GET',
              querystring: '',
              uri: '/callback/response',
            },
            response: {
              headers: {
                'access-control-allow-credentials': [
                  {
                    key: 'Access-Control-Allow-Credentials',
                    value: 'true',
                  },
                ],
                'access-control-allow-origin': [
                  {
                    key: 'Access-Control-Allow-Origin',
                    value: '*',
                  },
                ],
                date: [
                  {
                    key: 'Date',
                    value: 'Mon, 13 Jan 2020 20:14:56 GMT',
                  },
                ],
                'referrer-policy': [
                  {
                    key: 'Referrer-Policy',
                    value: 'no-referrer-when-downgrade',
                  },
                ],
                server: [
                  {
                    key: 'Server',
                    value: 'ExampleCustomOriginServer',
                  },
                ],
                'x-content-type-options': [
                  {
                    key: 'X-Content-Type-Options',
                    value: 'nosniff',
                  },
                ],
                'x-frame-options': [
                  {
                    key: 'X-Frame-Options',
                    value: 'DENY',
                  },
                ],
                'x-xss-protection': [
                  {
                    key: 'X-XSS-Protection',
                    value: '1; mode=block',
                  },
                ],
                age: [
                  {
                    key: 'Age',
                    value: '2402',
                  },
                ],
                'content-type': [
                  {
                    key: 'Content-Type',
                    value: 'text/html; charset=utf-8',
                  },
                ],
                'content-length': [
                  {
                    key: 'Content-Length',
                    value: '9593',
                  },
                ],
              },
              status: '200',
              statusDescription: 'OK',
            },
          },
        },
      ],
    }

    interface CloudFrontHeaders {
      [name: string]: [
        {
          key: string
          value: string
        }
      ]
    }
    let called = false
    let headers: CloudFrontHeaders = {}
    await handler(event, {}, (_err, result) => {
      if (result && result.headers) {
        headers = result.headers as CloudFrontHeaders
      }
      called = true
    })

    expect(called).toBe(true)
    expect(headers['access-control-allow-credentials']).toEqual([
      {
        key: 'Access-Control-Allow-Credentials',
        value: 'true',
      },
    ])
    expect(headers['access-control-allow-origin']).toEqual([
      {
        key: 'Access-Control-Allow-Origin',
        value: '*',
      },
    ])
  })

  it('Should handle a GET request and add header (Lambda@Edge viewer response)', async () => {
    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'example.com',
              distributionId: 'EDFDVBD6EXAMPLE',
              eventType: 'viewer-response',
              requestId: '4TyzHTaYWb1GX1qTfsHhEqV6HUDd_BzoBZnwfnvQc_1oF26ClkoUSEQ==',
            },
            request: {
              clientIp: '203.0.113.178',
              headers: {
                host: [
                  {
                    key: 'Host',
                    value: 'example.com',
                  },
                ],
                'user-agent': [
                  {
                    key: 'User-Agent',
                    value: 'curl/7.66.0',
                  },
                ],
                accept: [
                  {
                    key: 'accept',
                    value: '*/*',
                  },
                ],
              },
              method: 'GET',
              querystring: '',
              uri: '/header/add',
            },
            response: {
              headers: {
                'access-control-allow-credentials': [
                  {
                    key: 'Access-Control-Allow-Credentials',
                    value: 'true',
                  },
                ],
                'access-control-allow-origin': [
                  {
                    key: 'Access-Control-Allow-Origin',
                    value: '*',
                  },
                ],
                date: [
                  {
                    key: 'Date',
                    value: 'Mon, 13 Jan 2020 20:14:56 GMT',
                  },
                ],
                'referrer-policy': [
                  {
                    key: 'Referrer-Policy',
                    value: 'no-referrer-when-downgrade',
                  },
                ],
                server: [
                  {
                    key: 'Server',
                    value: 'ExampleCustomOriginServer',
                  },
                ],
                'x-content-type-options': [
                  {
                    key: 'X-Content-Type-Options',
                    value: 'nosniff',
                  },
                ],
                'x-frame-options': [
                  {
                    key: 'X-Frame-Options',
                    value: 'DENY',
                  },
                ],
                'x-xss-protection': [
                  {
                    key: 'X-XSS-Protection',
                    value: '1; mode=block',
                  },
                ],
                age: [
                  {
                    key: 'Age',
                    value: '2402',
                  },
                ],
                'content-type': [
                  {
                    key: 'Content-Type',
                    value: 'text/html; charset=utf-8',
                  },
                ],
                'content-length': [
                  {
                    key: 'Content-Length',
                    value: '9593',
                  },
                ],
              },
              status: '200',
              statusDescription: 'OK',
            },
          },
        },
      ],
    }

    interface CloudFrontHeaders {
      [name: string]: [
        {
          key: string
          value: string
        }
      ]
    }
    let called = false
    let headers: CloudFrontHeaders = {}
    await handler(event, {}, (_err, result) => {
      if (result && result.headers) {
        headers = result.headers as CloudFrontHeaders
      }
      called = true
    })

    expect(called).toBe(true)
    expect(headers['strict-transport-security']).toEqual([
      {
        key: 'Strict-Transport-Security',
        value: 'max-age=63072000; includeSubdomains; preload',
      },
    ])
    expect(headers['x-custom']).toEqual([
      {
        key: 'X-Custom',
        value: 'Foo',
      },
    ])
  })

  it('Callback Event (Lambda@Edge response)', async () => {
    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'example.com',
              distributionId: 'EDFDVBD6EXAMPLE',
              eventType: 'viewer-response',
              requestId: '4TyzHTaYWb1GX1qTfsHhEqV6HUDd_BzoBZnwfnvQc_1oF26ClkoUSEQ==',
            },
            request: {
              clientIp: '203.0.113.178',
              headers: {
                host: [
                  {
                    key: 'Host',
                    value: 'example.com',
                  },
                ],
              },
              method: 'GET',
              querystring: '',
              uri: '/config/eventCheck',
            },
          },
        },
      ],
    }

    let called = false
    await handler(event, {}, () => {
      called = true
    })

    expect(called).toBe(true)
  })

  it('Should return a response where bodyEncoding is "base64" with binary', async () => {
    const event = {
      Records: [
        {
          cf: {
            config: {
              distributionDomainName: 'example.com',
              distributionId: 'EXAMPLE123',
              eventType: 'viewer-request',
              requestId: 'exampleRequestId',
            },
            request: {
              clientIp: '123.123.123.123',
              headers: {
                host: [
                  {
                    key: 'Host',
                    value: 'example.com',
                  },
                ],
              },
              method: 'GET',
              querystring: '',
              uri: '/binary',
            },
          },
        },
      ],
    }

    const response = await handler(event)

    expect(response.body).toBe('RmFrZSBJbWFnZQ==') // base64 encoded "Fake Image"
    expect(response.bodyEncoding).toBe('base64')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/lambda-edge/vitest.config.ts
```typescript
/// <reference types="vitest" />
import { defineConfig } from 'vitest/config'
import config from '../../vitest.config'

export default defineConfig({
  test: {
    env: {
      NAME: 'Node',
    },
    globals: true,
    include: ['**/runtime-tests/lambda-edge/**/*.+(ts|tsx|js)'],
    exclude: ['**/runtime-tests/lambda-edge/vitest.config.ts'],
    coverage: {
      ...config.test?.coverage,
      reportsDirectory: './coverage/raw/runtime-lambda-edge',
    },
  },
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/workerd/index.test.ts
```typescript
import { unstable_dev } from 'wrangler'
import type { UnstableDevWorker } from 'wrangler'
import { WebSocket } from 'ws'

describe('workerd', () => {
  let worker: UnstableDevWorker

  beforeAll(async () => {
    worker = await unstable_dev('./runtime-tests/workerd/index.ts', {
      vars: {
        NAME: 'Hono',
      },
      experimental: { disableExperimentalWarning: true },
    })
  })

  afterAll(async () => {
    await worker.stop()
  })

  it('Should return 200 response with the runtime key', async () => {
    const res = await worker.fetch('/')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('Hello from workerd')
  })

  it('Should return 200 response with the environment variable', async () => {
    const res = await worker.fetch('/env')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('Hono')
  })
})

describe('workerd with WebSocket', () => {
  // worker.fetch does not support WebSocket:
  // https://github.com/cloudflare/workers-sdk/issues/4573#issuecomment-1850420973
  it('Should handle the WebSocket connection correctly', async () => {
    const worker = await unstable_dev('./runtime-tests/workerd/index.ts', {
      experimental: { disableExperimentalWarning: true },
    })
    const ws = new WebSocket(`ws://${worker.address}:${worker.port}/ws`)

    const openHandler = vi.fn()
    const messageHandler = vi.fn()
    const closeHandler = vi.fn()

    const waitForOpen = new Promise((resolve) => {
      ws.addEventListener('open', () => {
        openHandler()
        ws.send('Hello')
        resolve(undefined)
      })
      ws.addEventListener('close', async () => {
        closeHandler()
      })
      ws.addEventListener('message', async (event) => {
        messageHandler(event.data)
        ws.close()
      })
    })

    await waitForOpen
    await worker.stop()

    expect(openHandler).toHaveBeenCalled()
    expect(messageHandler).toHaveBeenCalledWith('Hello')
    expect(closeHandler).toHaveBeenCalled()
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/workerd/index.ts
```typescript
import { upgradeWebSocket } from '../../src/adapter/cloudflare-workers'
import { env, getRuntimeKey } from '../../src/helper/adapter'
import { Hono } from '../../src/hono'

const app = new Hono()

app.get('/', (c) => c.text(`Hello from ${getRuntimeKey()}`))

app.get('/env', (c) => {
  const { NAME } = env<{ NAME: string }>(c)
  return c.text(NAME)
})

app.get(
  '/ws',
  upgradeWebSocket(() => {
    return {
      onMessage(event, ws) {
        ws.send(event.data as string)
      },
    }
  })
)

export default app

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/workerd/vitest.config.ts
```typescript
/// <reference types="vitest" />
import { defineConfig } from 'vitest/config'
import config from '../../vitest.config'

export default defineConfig({
  test: {
    globals: true,
    include: ['**/runtime-tests/workerd/**/(*.)+(test).+(ts|tsx)'],
    exclude: ['**/runtime-tests/workerd/vitest.config.ts'],
    coverage: {
      ...config.test?.coverage,
      reportsDirectory: './coverage/raw/runtime-workerd',
    },
  },
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/fastly/index.test.ts
```typescript
import { createHash } from 'crypto'
import { getRuntimeKey } from '../../src/helper/adapter'
import { Hono } from '../../src/index'
import { basicAuth } from '../../src/middleware/basic-auth'
import { jwt } from '../../src/middleware/jwt'

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
globalThis.fastly = true

const app = new Hono()

describe('Hello World', () => {
  app.get('/', (c) => c.text('Hello! Compute!'))
  app.get('/runtime-name', (c) => {
    return c.text(getRuntimeKey())
  })

  it('Should return 200', async () => {
    const res = await app.request('http://localhost/')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('Hello! Compute!')
  })

  it('Should return the correct runtime name', async () => {
    const res = await app.request('http://localhost/runtime-name')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('fastly')
  })
})

describe('Basic Auth Middleware without `hashFunction`', () => {
  const app = new Hono()

  const username = 'hono-user-a'
  const password = 'hono-password-a'
  app.use(
    '/auth/*',
    basicAuth({
      username,
      password,
    })
  )

  app.get('/auth/*', () => new Response('auth'))

  it('Should not authorize, return 401 Response', async () => {
    const req = new Request('http://localhost/auth/a')
    const res = await app.request(req)
    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
  })
})

describe('Basic Auth Middleware with `hashFunction`', () => {
  const app = new Hono()

  const username = 'hono-user-a'
  const password = 'hono-password-a'
  app.use(
    '/auth/*',
    basicAuth({
      username,
      password,
      hashFunction: (m: string) => createHash('sha256').update(m).digest('hex'),
    })
  )

  app.get('/auth/*', () => new Response('auth'))

  it('Should not authorize, return 401 Response', async () => {
    const req = new Request('http://localhost/auth/a')
    const res = await app.request(req)
    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
  })

  it('Should authorize, return 200 Response', async () => {
    const credential = 'aG9uby11c2VyLWE6aG9uby1wYXNzd29yZC1h'
    const req = new Request('http://localhost/auth/a')
    req.headers.set('Authorization', `Basic ${credential}`)
    const res = await app.request(req)
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('auth')
  })
})

describe('JWT Auth Middleware does not work', () => {
  const app = new Hono()

  // Since nodejs 20 or later, global WebCrypto object becomes stable (experimental on nodejs 18)
  // but WebCrypto does not have compatibility with Fastly Compute runtime (lacking some objects/methods in Fastly)
  // so following test should run only be polyfill-ed via vite-plugin-fastly-js-compute plugin.
  // To confirm polyfill-ed or not, check __fastlyComputeNodeDefaultCrypto field is true.
  it.runIf(!globalThis.__fastlyComputeNodeDefaultCrypto)('Should throw error', () => {
    expect(() => {
      app.use('/jwt/*', jwt({ secret: 'secret' }))
    }).toThrow(/`crypto.subtle.importKey` is undefined/)
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/fastly/vitest.config.ts
```typescript
/// <reference types="vitest" />
import fastlyCompute from 'vite-plugin-fastly-js-compute'
import { defineConfig } from 'vitest/config'
import config from '../../vitest.config'

export default defineConfig({
  plugins: [fastlyCompute()],
  test: {
    globals: true,
    include: ['**/runtime-tests/fastly/**/(*.)+(test).+(ts|tsx)'],
    exclude: ['**/runtime-tests/fastly/vitest.config.ts'],
    coverage: {
      ...config.test?.coverage,
      reportsDirectory: './coverage/raw/runtime-fastly',
    },
  },
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/bun/index.test.tsx
```
import { afterAll, afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import fs from 'fs/promises'
import path from 'path'
import { stream, streamSSE } from '../..//src/helper/streaming'
import { serveStatic, toSSG } from '../../src/adapter/bun'
import { createBunWebSocket } from '../../src/adapter/bun/websocket'
import type { BunWebSocketData } from '../../src/adapter/bun/websocket'
import { Context } from '../../src/context'
import { env, getRuntimeKey } from '../../src/helper/adapter'
import type { WSMessageReceive } from '../../src/helper/websocket'
import { Hono } from '../../src/index'
// eslint-disable-next-line @typescript-eslint/no-unused-vars
import { jsx } from '../../src/jsx'
import { basicAuth } from '../../src/middleware/basic-auth'
import { jwt } from '../../src/middleware/jwt'

// Test just only minimal patterns.
// Because others are tested well in Cloudflare Workers environment already.

Bun.env.NAME = 'Bun'

describe('Basic', () => {
  const app = new Hono()
  app.get('/a/:foo', (c) => {
    c.header('x-param', c.req.param('foo'))
    c.header('x-query', c.req.query('q'))
    return c.text('Hello Bun!')
  })

  it('Should return 200 Response', async () => {
    const req = new Request('http://localhost/a/foo?q=bar')
    const res = await app.request(req)
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('Hello Bun!')
    expect(res.headers.get('x-param')).toBe('foo')
    expect(res.headers.get('x-query')).toBe('bar')
  })

  it('returns current runtime (bun)', async () => {
    expect(getRuntimeKey()).toBe('bun')
  })
})

describe('Environment Variables', () => {
  it('Should return the environment variable', async () => {
    const c = new Context(new Request('http://localhost/'))
    const { NAME } = env<{ NAME: string }>(c)
    expect(NAME).toBe('Bun')
  })
})

describe('Basic Auth Middleware', () => {
  const app = new Hono()

  const username = 'hono-user-a'
  const password = 'hono-password-a'
  app.use(
    '/auth/*',
    basicAuth({
      username,
      password,
    })
  )

  app.get('/auth/*', () => new Response('auth'))

  it('Should not authorize, return 401 Response', async () => {
    const req = new Request('http://localhost/auth/a')
    const res = await app.request(req)
    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
  })

  it('Should authorize, return 200 Response', async () => {
    const credential = 'aG9uby11c2VyLWE6aG9uby1wYXNzd29yZC1h'
    const req = new Request('http://localhost/auth/a')
    req.headers.set('Authorization', `Basic ${credential}`)
    const res = await app.request(req)
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('auth')
  })
})

describe('Serve Static Middleware', () => {
  const app = new Hono()
  const onNotFound = vi.fn(() => {})
  app.all('/favicon.ico', serveStatic({ path: './runtime-tests/bun/favicon.ico' }))
  app.all(
    '/favicon-notfound.ico',
    serveStatic({ path: './runtime-tests/bun/favicon-notfound.ico', onNotFound })
  )
  app.use('/favicon-notfound.ico', async (c, next) => {
    await next()
    c.header('X-Custom', 'Bun')
  })
  app.get(
    '/static/*',
    serveStatic({
      root: './runtime-tests/bun/',
      onNotFound,
    })
  )
  app.get(
    '/dot-static/*',
    serveStatic({
      root: './runtime-tests/bun/',
      rewriteRequestPath: (path) => path.replace(/^\/dot-static/, './.static'),
    })
  )

  app.all('/static-absolute-root/*', serveStatic({ root: path.dirname(__filename) }))

  beforeEach(() => onNotFound.mockClear())

  it('Should return static file correctly', async () => {
    const res = await app.request(new Request('http://localhost/favicon.ico'))
    await res.arrayBuffer()
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toBe('image/x-icon')
  })

  it('Should return 404 response', async () => {
    const res = await app.request(new Request('http://localhost/favicon-notfound.ico'))
    expect(res.status).toBe(404)
    expect(res.headers.get('X-Custom')).toBe('Bun')
    expect(onNotFound).toHaveBeenCalledWith(
      './runtime-tests/bun/favicon-notfound.ico',
      expect.anything()
    )
  })

  it('Should return 200 response - /static/plain.txt', async () => {
    const res = await app.request(new Request('http://localhost/static/plain.txt'))
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('Bun!')
    expect(onNotFound).not.toHaveBeenCalled()
  })

  it('Should return 200 response - /static/download', async () => {
    const res = await app.request(new Request('http://localhost/static/download'))
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('download')
    expect(onNotFound).not.toHaveBeenCalled()
  })

  it('Should return 200 response - /dot-static/plain.txt', async () => {
    const res = await app.request(new Request('http://localhost/dot-static/plain.txt'))
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('Bun!!')
  })

  it('Should return 200 response - /static/helloworld', async () => {
    const res = await app.request('http://localhost/static/helloworld')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('Hi\n')
  })

  it('Should return 200 response - /static/hello.world', async () => {
    const res = await app.request('http://localhost/static/hello.world')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('Hi\n')
  })

  it('Should return 200 response - /static-absolute-root/plain.txt', async () => {
    const res = await app.request('http://localhost/static-absolute-root/plain.txt')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('Bun!')
    expect(onNotFound).not.toHaveBeenCalled()
  })
})

// Bun support WebCrypto since v0.2.2
// So, JWT middleware works well.
describe('JWT Auth Middleware', () => {
  const app = new Hono()
  app.use('/jwt/*', jwt({ secret: 'a-secret' }))
  app.get('/jwt/a', (c) => c.text('auth'))

  it('Should not authorize, return 401 Response', async () => {
    const req = new Request('http://localhost/jwt/a')
    const res = await app.request(req)
    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
  })

  it('Should authorize, return 200 Response', async () => {
    const credential =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE'
    const req = new Request('http://localhost/jwt/a')
    req.headers.set('Authorization', `Bearer ${credential}`)
    const res = await app.request(req)
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('auth')
  })
})

// To enable JSX middleware,
// set "jsxImportSource": "hono/jsx" in the tsconfig.json
describe('JSX Middleware', () => {
  const app = new Hono()

  const Layout = (props: { children?: string }) => {
    return <html>{props.children}</html>
  }

  app.get('/', (c) => {
    return c.html(<h1>Hello</h1>)
  })
  app.get('/nest', (c) => {
    return c.html(
      <h1>
        <a href='/top'>Hello</a>
      </h1>
    )
  })
  app.get('/layout', (c) => {
    return c.html(
      <Layout>
        <p>hello</p>
      </Layout>
    )
  })

  it('Should return rendered HTML', async () => {
    const res = await app.request(new Request('http://localhost/'))
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toBe('text/html; charset=UTF-8')
    expect(await res.text()).toBe('<h1>Hello</h1>')
  })

  it('Should return rendered HTML with nest', async () => {
    const res = await app.request(new Request('http://localhost/nest'))
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toBe('text/html; charset=UTF-8')
    expect(await res.text()).toBe('<h1><a href="/top">Hello</a></h1>')
  })

  it('Should return rendered HTML with Layout', async () => {
    const res = await app.request(new Request('http://localhost/layout'))
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toBe('text/html; charset=UTF-8')
    expect(await res.text()).toBe('<html><p>hello</p></html>')
  })
})

describe('toSSG function', () => {
  let app: Hono

  beforeEach(() => {
    app = new Hono()
    app.get('/', (c) => c.text('Hello, World!'))
    app.get('/about', (c) => c.text('About Page'))
    app.get('/about/some', (c) => c.text('About Page 2tier'))
    app.post('/about/some/thing', (c) => c.text('About Page 3tier'))
    app.get('/bravo', (c) => c.html('Bravo Page'))
    app.get('/Charlie', async (c, next) => {
      c.setRenderer((content, head) => {
        return c.html(
          <html>
            <head>
              <title>{head.title || ''}</title>
            </head>
            <body>
              <p>{content}</p>
            </body>
          </html>
        )
      })
      await next()
    })
    app.get('/Charlie', (c) => {
      return c.render('Hello!', { title: 'Charlies Page' })
    })
  })

  it('Should correctly generate static HTML files for Hono routes', async () => {
    const result = await toSSG(app, { dir: './static' })
    expect(result.success).toBeTruly
    expect(result.error).toBeUndefined()
    expect(result.files).toBeDefined()
    afterAll(async () => {
      await deleteDirectory('./static')
    })
  })
})

describe('WebSockets Helper', () => {
  const app = new Hono()
  const { websocket, upgradeWebSocket } = createBunWebSocket()

  it('Should websockets is working', async () => {
    const receivedMessagePromise = new Promise<WSMessageReceive>((resolve) =>
      app.get(
        '/ws',
        upgradeWebSocket(() => ({
          onMessage(evt) {
            resolve(evt.data)
          },
        }))
      )
    )
    const upgradedData = await new Promise<BunWebSocketData>((resolve) =>
      app.fetch(new Request('http://localhost/ws'), {
        upgrade: (_req: Request, data: { data: BunWebSocketData }) => {
          resolve(data.data)
        },
      })
    )
    const message = Math.random().toString()
    websocket.message(
      {
        close: () => undefined,
        readyState: 3,
        data: upgradedData,
        send: () => undefined,
      },
      message
    )
    const receivedMessage = await receivedMessagePromise
    expect(receivedMessage).toBe(message)
  })
})

async function deleteDirectory(dirPath) {
  if (
    await fs
      .stat(dirPath)
      .then((stat) => stat.isDirectory())
      .catch(() => false)
  ) {
    for (const entry of await fs.readdir(dirPath)) {
      const entryPath = path.join(dirPath, entry)
      await deleteDirectory(entryPath)
    }
    await fs.rmdir(dirPath)
  } else {
    await fs.unlink(dirPath)
  }
}

describe('streaming', () => {
  const app = new Hono()
  let server: ReturnType<typeof Bun.serve>
  let aborted = false

  app.get('/stream', (c) => {
    return stream(c, async (stream) => {
      stream.onAbort(() => {
        aborted = true
      })
      return new Promise<void>((resolve) => {
        stream.onAbort(resolve)
      })
    })
  })
  app.get('/streamHello', (c) => {
    return stream(c, async (stream) => {
      stream.onAbort(() => {
        aborted = true
      })
      await stream.write('Hello')
    })
  })
  app.get('/streamSSE', (c) => {
    return streamSSE(c, async (stream) => {
      stream.onAbort(() => {
        aborted = true
      })
      return new Promise<void>((resolve) => {
        stream.onAbort(resolve)
      })
    })
  })
  app.get('/streamSSEHello', (c) => {
    return streamSSE(c, async (stream) => {
      stream.onAbort(() => {
        aborted = true
      })
      await stream.write('Hello')
    })
  })

  beforeEach(() => {
    aborted = false
    server = Bun.serve({ port: 0, fetch: app.fetch })
  })

  afterEach(() => {
    server.stop()
  })

  describe('stream', () => {
    it('Should call onAbort', async () => {
      const ac = new AbortController()
      const req = new Request(`http://localhost:${server.port}/stream`, {
        signal: ac.signal,
      })
      expect(aborted).toBe(false)
      const res = fetch(req).catch(() => {})
      await new Promise((resolve) => setTimeout(resolve, 10))
      ac.abort()
      await res
      while (!aborted) {
        await new Promise((resolve) => setTimeout(resolve))
      }
      expect(aborted).toBe(true)
    })

    it('Should not be called onAbort if already closed', async () => {
      expect(aborted).toBe(false)
      const res = await fetch(`http://localhost:${server.port}/streamHello`)
      expect(await res.text()).toBe('Hello')
      expect(aborted).toBe(false)
    })
  })

  describe('streamSSE', () => {
    it('Should call onAbort', async () => {
      const ac = new AbortController()
      const req = new Request(`http://localhost:${server.port}/streamSSE`, {
        signal: ac.signal,
      })
      const res = fetch(req).catch(() => {})
      await new Promise((resolve) => setTimeout(resolve, 10))
      ac.abort()
      await res
      while (!aborted) {
        await new Promise((resolve) => setTimeout(resolve))
      }
      expect(aborted).toBe(true)
    })

    it('Should not be called onAbort if already closed', async () => {
      expect(aborted).toBe(false)
      const res = await fetch(`http://localhost:${server.port}/streamSSEHello`)
      expect(await res.text()).toBe('Hello')
      expect(aborted).toBe(false)
    })
  })
})

describe('Buffers', () => {
  const app = new Hono().get('/', async (c) => {
    return c.body(Buffer.from('hello'))
  })

  it('should allow returning buffers', async () => {
    const res = await app.request(new Request('http://localhost/'))
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('hello')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/bun/vitest.config.ts
```typescript
/// <reference types="vitest" />
import { defineConfig } from 'vitest/config'
import config from '../../vitest.config'

export default defineConfig({
  test: {
    globals: true,
    include: ['**/runtime-tests/bun/**/*.+(ts|tsx|js)'],
    coverage: {
      ...config.test?.coverage,
      reportsDirectory: './coverage/raw/runtime-bun',
    },
  },
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/bun/static-absolute-root/plain.txt
```
Bun!
```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/bun/static/download
```
download
```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/bun/static/plain.txt
```
Bun!
```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/bun/static/helloworld/index.html
```html
Hi

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/bun/static/hello.world/index.html
```html
Hi

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/lambda/index.test.ts
```typescript
import { Readable } from 'stream'
import {
  ALBProcessor,
  EventV1Processor,
  EventV2Processor,
  getProcessor,
  handle,
  streamHandle,
} from '../../src/adapter/aws-lambda/handler'
import type {
  ALBProxyEvent,
  APIGatewayProxyEventV2,
  LambdaEvent,
} from '../../src/adapter/aws-lambda/handler'
import type {
  ApiGatewayRequestContext,
  ApiGatewayRequestContextV2,
  LambdaContext,
} from '../../src/adapter/aws-lambda/types'
import { getCookie, setCookie } from '../../src/helper/cookie'
import { streamSSE } from '../../src/helper/streaming'
import { Hono } from '../../src/hono'
import { basicAuth } from '../../src/middleware/basic-auth'
import './mock'

type Bindings = {
  event: LambdaEvent
  lambdaContext: LambdaContext
  requestContext: ApiGatewayRequestContext | ApiGatewayRequestContextV2
}

const testApiGatewayRequestContextV2 = {
  accountId: '123456789012',
  apiId: 'urlid',
  authentication: null,
  authorizer: {
    iam: {
      accessKey: 'AKIA...',
      accountId: '111122223333',
      callerId: 'AIDA...',
      cognitoIdentity: null,
      principalOrgId: null,
      userArn: 'arn:aws:iam::111122223333:user/example-user',
      userId: 'AIDA...',
    },
  },
  domainName: 'example.com',
  domainPrefix: '<url-id>',
  http: {
    method: 'POST',
    path: '/my/path',
    protocol: 'HTTP/1.1',
    sourceIp: '123.123.123.123',
    userAgent: 'agent',
  },
  requestId: 'id',
  routeKey: '$default',
  stage: '$default',
  time: '12/Mar/2020:19:03:58 +0000',
  timeEpoch: 1583348638390,
  customProperty: 'customValue',
}

describe('AWS Lambda Adapter for Hono', () => {
  const app = new Hono<{ Bindings: Bindings }>()

  app.get('/', (c) => {
    return c.text('Hello Lambda!')
  })

  app.get('/binary', (c) => {
    return c.body('Fake Image', 200, {
      'Content-Type': 'image/png',
    })
  })

  app.post('/post', async (c) => {
    const body = (await c.req.parseBody()) as { message: string }
    return c.text(body.message)
  })

  app.post('/post/binary', async (c) => {
    const body = await c.req.blob()
    return c.text(`${body.size} bytes`)
  })

  const username = 'hono-user-a'
  const password = 'hono-password-a'
  app.use('/auth/*', basicAuth({ username, password }))
  app.get('/auth/abc', (c) => c.text('Good Night Lambda!'))

  app.get('/lambda-event', (c) => {
    const event = c.env.event
    return c.json(event)
  })

  app.get('/lambda-context', (c) => {
    const fnctx = c.env.lambdaContext
    return c.json(fnctx)
  })

  app.get('/custom-context/v1/apigw', (c) => {
    const lambdaContext = c.env.requestContext
    return c.json(lambdaContext)
  })

  app.get('/custom-context/apigw', (c) => {
    const lambdaContext = c.env.event.requestContext
    return c.json(lambdaContext)
  })

  app.get('/custom-context/v1/lambda', (c) => {
    const lambdaContext = c.env.requestContext
    return c.json(lambdaContext)
  })

  app.get('/custom-context/lambda', (c) => {
    const lambdaContext = c.env.event.requestContext
    return c.json(lambdaContext)
  })

  app.get('/query-params', (c) => {
    const queryParams = c.req.query()
    return c.json(queryParams)
  })

  app.get('/multi-query-params', (c) => {
    const multiQueryParams = c.req.queries()
    return c.json(multiQueryParams)
  })

  const testCookie1 = {
    key: 'id',
    value: crypto.randomUUID(),
    get serialized() {
      return `${this.key}=${this.value}; Path=/`
    },
  }
  const testCookie2 = {
    key: 'secret',
    value: crypto.randomUUID(),
    get serialized() {
      return `${this.key}=${this.value}; Path=/`
    },
  }

  app.post('/cookie', (c) => {
    setCookie(c, testCookie1.key, testCookie1.value)
    setCookie(c, testCookie2.key, testCookie2.value)
    return c.text('Cookies Set')
  })

  app.get('/cookie', (c) => {
    const validCookies =
      getCookie(c, testCookie1.key) === testCookie1.value &&
      getCookie(c, testCookie2.key) === testCookie2.value
    if (!validCookies) {
      return c.text('Invalid Cookies')
    }
    return c.text('Valid Cookies')
  })

  app.post('/headers', (c) => {
    if (c.req.header('foo')?.includes('bar')) {
      return c.json({ message: 'ok' })
    }
    return c.json({ message: 'fail' }, 400)
  })

  const handler = handle(app)

  const testApiGatewayRequestContext = {
    accountId: '123456789012',
    apiId: 'id',
    authorizer: {
      claims: null,
      scopes: null,
    },
    domainName: 'example.com',
    domainPrefix: 'id',
    extendedRequestId: 'request-id',
    httpMethod: 'GET',
    identity: {
      sourceIp: 'IP',
      userAgent: 'user-agent',
    },
    path: '/my/path',
    protocol: 'HTTP/1.1',
    requestId: 'id=',
    requestTime: '04/Mar/2020:19:15:17 +0000',
    requestTimeEpoch: 1583349317135,
    resourcePath: '/',
    stage: '$default',
    customProperty: 'customValue',
  }

  const testApiGatewayRequestContextV2 = {
    accountId: '123456789012',
    apiId: 'urlid',
    authentication: null,
    authorizer: {
      iam: {
        accessKey: 'AKIA...',
        accountId: '111122223333',
        callerId: 'AIDA...',
        cognitoIdentity: null,
        principalOrgId: null,
        userArn: 'arn:aws:iam::111122223333:user/example-user',
        userId: 'AIDA...',
      },
    },
    domainName: 'example.com',
    domainPrefix: '<url-id>',
    http: {
      method: 'POST',
      path: '/my/path',
      protocol: 'HTTP/1.1',
      sourceIp: '123.123.123.123',
      userAgent: 'agent',
    },
    requestId: 'id',
    routeKey: '$default',
    stage: '$default',
    time: '12/Mar/2020:19:03:58 +0000',
    timeEpoch: 1583348638390,
    customProperty: 'customValue',
  }

  const testALBRequestContext = {
    elb: {
      targetGroupArn:
        'arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/lambda-279XGJDqGZ5rsrHC2Fjr/49e9d65c45c6791a',
    },
  }

  it('Should handle a GET request and return a 200 response', async () => {
    const event = {
      version: '1.0',
      resource: '/',
      httpMethod: 'GET',
      headers: { 'content-type': 'text/plain' },
      path: '/',
      body: null,
      isBase64Encoded: false,
      requestContext: testApiGatewayRequestContext,
    }

    const response = await handler(event)
    expect(response.statusCode).toBe(200)
    expect(response.body).toBe('Hello Lambda!')
    expect(response.headers['content-type']).toMatch(/^text\/plain/)
    expect(response.multiValueHeaders).toBeUndefined()
    expect(response.isBase64Encoded).toBe(false)
  })

  it('Should handle a GET request and return a 200 response with binary', async () => {
    const event = {
      version: '1.0',
      resource: '/binary',
      httpMethod: 'GET',
      headers: {},
      path: '/binary',
      body: null,
      isBase64Encoded: false,
      requestContext: testApiGatewayRequestContext,
    }

    const response = await handler(event)
    expect(response.statusCode).toBe(200)
    expect(response.body).toBe('RmFrZSBJbWFnZQ==')
    expect(response.headers['content-type']).toMatch(/^image\/png/)
    expect(response.multiValueHeaders).toBeUndefined()
    expect(response.isBase64Encoded).toBe(true)
  })

  it('Should handle a GET request and return a 200 response (LambdaFunctionUrlEvent)', async () => {
    const event = {
      version: '2.0',
      routeKey: '$default',
      headers: { 'content-type': 'text/plain' },
      rawPath: '/',
      rawQueryString: '',
      body: null,
      isBase64Encoded: false,
      requestContext: testApiGatewayRequestContextV2,
    }

    testApiGatewayRequestContextV2.http.method = 'GET'

    const response = await handler(event)
    expect(response.statusCode).toBe(200)
    expect(response.body).toBe('Hello Lambda!')
    expect(response.headers['content-type']).toMatch(/^text\/plain/)
    expect(response.multiValueHeaders).toBeUndefined()
    expect(response.isBase64Encoded).toBe(false)
  })

  it('Should handle a GET request and return a 200 response (ALBEvent)', async () => {
    const event = {
      headers: { 'content-type': 'text/plain' },
      httpMethod: 'GET',
      path: '/',
      queryStringParameters: {
        query: '1234ABCD',
      },
      body: null,
      isBase64Encoded: false,
      requestContext: testALBRequestContext,
    }

    const response = await handler(event)
    expect(response.statusCode).toBe(200)
    expect(response.body).toBe('Hello Lambda!')
    expect(response.headers['content-type']).toMatch(/^text\/plain/)
    expect(response.multiValueHeaders).toBeUndefined()
    expect(response.isBase64Encoded).toBe(false)
  })

  it('Should handle a GET request and return a 404 response', async () => {
    const event = {
      version: '1.0',
      resource: '/nothing',
      httpMethod: 'GET',
      headers: { 'content-type': 'text/plain' },
      path: '/nothing',
      body: null,
      isBase64Encoded: false,
      requestContext: testApiGatewayRequestContext,
    }

    const response = await handler(event)
    expect(response.statusCode).toBe(404)
  })

  it('Should handle a POST request and return a 200 response', async () => {
    const searchParam = new URLSearchParams()
    searchParam.append('message', 'Good Morning Lambda!')
    const event = {
      version: '1.0',
      resource: '/post',
      httpMethod: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      path: '/post',
      body: Buffer.from(searchParam.toString()).toString('base64'),
      isBase64Encoded: true,
      requestContext: testApiGatewayRequestContext,
    }

    const response = await handler(event)
    expect(response.statusCode).toBe(200)
    expect(response.body).toBe('Good Morning Lambda!')
  })

  it('Should handle a POST request and return a 200 response (LambdaFunctionUrlEvent)', async () => {
    const searchParam = new URLSearchParams()
    searchParam.append('message', 'Good Morning Lambda!')
    const event = {
      version: '2.0',
      routeKey: '$default',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      rawPath: '/post',
      rawQueryString: '',
      body: Buffer.from(searchParam.toString()).toString('base64'),
      isBase64Encoded: true,
      requestContext: testApiGatewayRequestContextV2,
    }

    testApiGatewayRequestContextV2.http.method = 'POST'

    const response = await handler(event)
    expect(response.statusCode).toBe(200)
    expect(response.body).toBe('Good Morning Lambda!')
  })

  it('Should handle a POST request with binary and return a 200 response', async () => {
    const array = new Uint8Array([0xc0, 0xff, 0xee])
    const buffer = Buffer.from(array)
    const event = {
      version: '1.0',
      resource: '/post/binary',
      httpMethod: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      path: '/post/binary',
      body: buffer.toString('base64'),
      isBase64Encoded: true,
      requestContext: testApiGatewayRequestContext,
    }

    const response = await handler(event)
    expect(response.statusCode).toBe(200)
    expect(response.body).toBe('3 bytes')
  })

  it('Should handle a request and return a 401 response with Basic auth', async () => {
    const event = {
      version: '1.0',
      resource: '/auth/abc',
      httpMethod: 'GET',
      headers: {
        'Content-Type': 'plain/text',
      },
      path: '/auth/abc',
      body: null,
      isBase64Encoded: true,
      requestContext: testApiGatewayRequestContext,
    }

    const response = await handler(event)
    expect(response.statusCode).toBe(401)
  })

  it('Should handle a request and return a 200 response with Basic auth', async () => {
    const credential = 'aG9uby11c2VyLWE6aG9uby1wYXNzd29yZC1h'
    const event = {
      version: '1.0',
      resource: '/auth/abc',
      httpMethod: 'GET',
      headers: {
        'Content-Type': 'plain/text',
        Authorization: `Basic ${credential}`,
      },
      path: '/auth/abc',
      body: null,
      isBase64Encoded: true,
      requestContext: testApiGatewayRequestContext,
    }

    const response = await handler(event)
    expect(response.statusCode).toBe(200)
    expect(response.body).toBe('Good Night Lambda!')
  })

  it('Should handle a GET request and return custom context', async () => {
    const event = {
      version: '1.0',
      resource: '/custom-context/apigw',
      httpMethod: 'GET',
      headers: { 'content-type': 'application/json' },
      path: '/custom-context/apigw',
      body: null,
      isBase64Encoded: false,
      requestContext: testApiGatewayRequestContext,
    }

    const response = await handler(event)
    expect(response.statusCode).toBe(200)
    expect(JSON.parse(response.body).customProperty).toEqual('customValue')
  })

  it('Should handle a GET request and context', async () => {
    const event = {
      version: '1.0',
      resource: '/lambda-context',
      httpMethod: 'GET',
      headers: { 'content-type': 'application/json' },
      path: '/lambda-context',
      body: null,
      isBase64Encoded: false,
      requestContext: testApiGatewayRequestContext,
    }
    const context: LambdaContext = {
      callbackWaitsForEmptyEventLoop: false,
      functionName: 'myLambdaFunction',
      functionVersion: '1.0.0',
      invokedFunctionArn: 'arn:aws:lambda:us-west-2:123456789012:function:myLambdaFunction',
      memoryLimitInMB: '128',
      awsRequestId: 'c6af9ac6-a7b0-11e6-80f5-76304dec7eb7',
      logGroupName: '/aws/lambda/myLambdaFunction',
      logStreamName: '2016/11/14/[$LATEST]f2d4b21cfb33490da2e8f8ef79a483s4',
      getRemainingTimeInMillis: () => {
        return 60000 // 60 seconds
      },
    }
    const response = await handler(event, context)
    expect(response.statusCode).toBe(200)
    expect(JSON.parse(response.body).callbackWaitsForEmptyEventLoop).toEqual(false)
  })

  it('Should handle a POST request and return a 200 response with cookies set (APIGatewayProxyEvent V1 and V2)', async () => {
    const apiGatewayEvent = {
      version: '1.0',
      resource: '/cookie',
      httpMethod: 'POST',
      headers: { 'content-type': 'text/plain' },
      path: '/cookie',
      body: null,
      isBase64Encoded: false,
      requestContext: testApiGatewayRequestContext,
    }

    const apiGatewayResponse = await handler(apiGatewayEvent)

    expect(apiGatewayResponse.statusCode).toBe(200)
    expect(apiGatewayResponse.multiValueHeaders).toHaveProperty('set-cookie', [
      testCookie1.serialized,
      testCookie2.serialized,
    ])

    const apiGatewayEventV2 = {
      version: '2.0',
      routeKey: '$default',
      httpMethod: 'POST',
      headers: { 'content-type': 'text/plain' },
      rawPath: '/cookie',
      rawQueryString: '',
      body: null,
      isBase64Encoded: false,
      requestContext: testApiGatewayRequestContextV2,
    }

    const apiGatewayResponseV2 = await handler(apiGatewayEventV2)

    expect(apiGatewayResponseV2.statusCode).toBe(200)
    expect(apiGatewayResponseV2).toHaveProperty('cookies', [
      testCookie1.serialized,
      testCookie2.serialized,
    ])
  })

  describe('headers', () => {
    describe('single-value headers', () => {
      it('Should extract single-value headers and return 200 (ALBProxyEvent)', async () => {
        const event = {
          body: '{}',
          httpMethod: 'POST',
          isBase64Encoded: false,
          path: '/headers',
          headers: {
            host: 'localhost',
            foo: 'bar',
          },
          requestContext: testALBRequestContext,
        }
        const albResponse = await handler(event)
        expect(albResponse.statusCode).toBe(200)
        expect(albResponse.headers).toEqual(
          expect.objectContaining({
            'content-type': 'application/json',
          })
        )
        expect(albResponse.multiValueHeaders).toBeUndefined()
      })

      it('Should extract single-value headers and return 200 (APIGatewayProxyEvent)', async () => {
        const apigatewayProxyEvent = {
          version: '1.0',
          resource: '/headers',
          httpMethod: 'POST',
          headers: {
            host: 'localhost',
            foo: 'bar',
          },
          path: '/headers',
          body: null,
          isBase64Encoded: false,
          requestContext: testApiGatewayRequestContext,
        }
        const apiGatewayResponseV2 = await handler(apigatewayProxyEvent)
        expect(apiGatewayResponseV2.statusCode).toBe(200)
      })

      it('Should extract single-value headers and return 200 (APIGatewayProxyEventV2)', async () => {
        const apigatewayProxyV2Event = {
          version: '2.0',
          routeKey: '$default',
          headers: {
            host: 'localhost',
            foo: 'bar',
          },
          rawPath: '/headers',
          rawQueryString: '',
          requestContext: testApiGatewayRequestContextV2,
          resource: '/headers',
          body: null,
          isBase64Encoded: false,
        }
        const apiGatewayResponseV2 = await handler(apigatewayProxyV2Event)
        expect(apiGatewayResponseV2.statusCode).toBe(200)
      })
    })

    describe('multi-value headers', () => {
      it('Should extract multi-value headers and return 200 (ALBProxyEvent)', async () => {
        const event = {
          body: '{}',
          httpMethod: 'POST',
          isBase64Encoded: false,
          path: '/headers',
          multiValueHeaders: {
            host: ['localhost'],
            foo: ['bar'],
          },
          requestContext: testALBRequestContext,
        }
        const albResponse = await handler(event)
        expect(albResponse.statusCode).toBe(200)
        expect(albResponse.multiValueHeaders).toBeDefined()
        expect(albResponse.multiValueHeaders).toEqual(
          expect.objectContaining({
            'content-type': ['application/json'],
          })
        )
      })

      it('Should extract multi-value headers and return 200 (APIGatewayProxyEvent)', async () => {
        const apigatewayProxyEvent = {
          version: '1.0',
          resource: '/headers',
          httpMethod: 'POST',
          headers: {},
          multiValueHeaders: {
            host: ['localhost'],
            foo: ['bar'],
          },
          path: '/headers',
          body: null,
          isBase64Encoded: false,
          requestContext: testApiGatewayRequestContext,
        }
        const apiGatewayResponseV2 = await handler(apigatewayProxyEvent)
        expect(apiGatewayResponseV2.statusCode).toBe(200)
      })
    })
  })

  it('Should handle a POST request and return a 200 response if cookies match (APIGatewayProxyEvent V1 and V2)', async () => {
    const apiGatewayEvent = {
      version: '1.0',
      resource: '/cookie',
      httpMethod: 'GET',
      headers: {
        'content-type': 'text/plain',
        cookie: [testCookie1.serialized, testCookie2.serialized].join('; '),
      },
      path: '/cookie',
      body: null,
      isBase64Encoded: false,
      requestContext: testApiGatewayRequestContext,
    }

    const apiGatewayResponse = await handler(apiGatewayEvent)

    expect(apiGatewayResponse.statusCode).toBe(200)
    expect(apiGatewayResponse.body).toBe('Valid Cookies')
    expect(apiGatewayResponse.headers['content-type']).toMatch(/^text\/plain/)
    expect(apiGatewayResponse.isBase64Encoded).toBe(false)

    const apiGatewayEventV2 = {
      version: '2.0',
      routeKey: '$default',
      headers: { 'content-type': 'text/plain' },
      rawPath: '/cookie',
      cookies: [testCookie1.serialized, testCookie2.serialized],
      rawQueryString: '',
      body: null,
      isBase64Encoded: false,
      requestContext: testApiGatewayRequestContextV2,
    }
    testApiGatewayRequestContextV2.http.method = 'GET'

    const apiGatewayResponseV2 = await handler(apiGatewayEventV2)

    expect(apiGatewayResponseV2.statusCode).toBe(200)
    expect(apiGatewayResponseV2.body).toBe('Valid Cookies')
    expect(apiGatewayResponseV2.headers['content-type']).toMatch(/^text\/plain/)
    expect(apiGatewayResponseV2.isBase64Encoded).toBe(false)
  })

  it('Should handle a GET request and return a 200 response if cookies match (ALBProxyEvent) with default headers', async () => {
    const albEventDefaultHeaders = {
      version: '1.0',
      resource: '/cookie',
      httpMethod: 'GET',
      headers: {
        'content-type': 'text/plain',
        cookie: [testCookie1.serialized, testCookie2.serialized].join('; '),
      },
      path: '/cookie',
      body: null,
      isBase64Encoded: false,
      requestContext: testALBRequestContext,
    }

    const albResponse = await handler(albEventDefaultHeaders)

    expect(albResponse.statusCode).toBe(200)
    expect(albResponse.body).toBe('Valid Cookies')
    expect(albResponse.headers['content-type']).toMatch(/^text\/plain/)
    expect(albResponse.multiValueHeaders).toBeUndefined()
    expect(albResponse.isBase64Encoded).toBe(false)
  })

  it('Should handle a GET request and return a 200 response if cookies match (ALBProxyEvent) with multi value headers', async () => {
    const albEventMultiValueHeaders = {
      version: '1.0',
      resource: '/cookie',
      httpMethod: 'GET',
      multiValueHeaders: {
        'content-type': ['text/plain'],
        cookie: [testCookie1.serialized, testCookie2.serialized],
      },
      path: '/cookie',
      body: null,
      isBase64Encoded: false,
      requestContext: testALBRequestContext,
    }

    const albResponse = await handler(albEventMultiValueHeaders)

    expect(albResponse.statusCode).toBe(200)
    expect(albResponse.body).toBe('Valid Cookies')
    expect(albResponse.headers).toBeUndefined()
    expect(albResponse.multiValueHeaders['content-type']).toEqual([
      expect.stringMatching(/^text\/plain/),
    ])
    expect(albResponse.isBase64Encoded).toBe(false)
  })

  it('Should handle a POST request and return a 200 response with cookies (ALBProxyEvent) with default headers', async () => {
    const albEventDefaultHeaders = {
      version: '1.0',
      resource: '/cookie',
      httpMethod: 'POST',
      headers: {
        'content-type': 'text/plain',
        cookie: [testCookie1.serialized, testCookie2.serialized].join(', '),
      },
      path: '/cookie',
      body: null,
      isBase64Encoded: false,
      requestContext: testALBRequestContext,
    }

    const albResponse = await handler(albEventDefaultHeaders)

    expect(albResponse.statusCode).toBe(200)
    expect(albResponse.body).toBe('Cookies Set')
    expect(albResponse.headers['content-type']).toMatch(/^text\/plain/)
    expect(albResponse.multiValueHeaders).toBeUndefined()
    expect(albResponse.headers['set-cookie']).toEqual(
      [testCookie1.serialized, testCookie2.serialized].join(', ')
    )
    expect(albResponse.isBase64Encoded).toBe(false)
  })

  it('Should handle a POST request and return a 200 response with cookies (ALBProxyEvent) with multi value headers', async () => {
    const albEventDefaultHeaders = {
      version: '1.0',
      resource: '/cookie',
      httpMethod: 'POST',
      multiValueHeaders: {
        'content-type': ['text/plain'],
        cookie: [testCookie1.serialized, testCookie2.serialized],
      },
      path: '/cookie',
      body: null,
      isBase64Encoded: false,
      requestContext: testALBRequestContext,
    }

    const albResponse = await handler(albEventDefaultHeaders)

    expect(albResponse.statusCode).toBe(200)
    expect(albResponse.body).toBe('Cookies Set')
    expect(albResponse.headers).toBeUndefined()
    expect(albResponse.multiValueHeaders['set-cookie']).toEqual(
      expect.arrayContaining([testCookie1.serialized, testCookie2.serialized])
    )
    expect(albResponse.isBase64Encoded).toBe(false)
  })

  it('Should handle a GET request and return a 200 response with queryStringParameters (ALBProxyEvent)', async () => {
    const albEventDefaultHeaders = {
      resource: '/query-params',
      httpMethod: 'GET',
      headers: {
        'content-type': 'application/json',
      },
      queryStringParameters: {
        key1: 'value1',
        key2: 'value2',
      },
      path: '/query-params',
      body: null,
      isBase64Encoded: false,
      requestContext: testALBRequestContext,
    }

    const albResponse = await handler(albEventDefaultHeaders)

    expect(albResponse.statusCode).toBe(200)
    expect(albResponse.body).toContain(
      JSON.stringify({
        key1: 'value1',
        key2: 'value2',
      })
    )
    expect(albResponse.headers['content-type']).toMatch(/^application\/json/)
    expect(albResponse.multiValueHeaders).toBeUndefined()
    expect(albResponse.isBase64Encoded).toBe(false)
  })

  it('Should handle a GET request and return a 200 response with single value multiQueryStringParameters (ALBProxyEvent)', async () => {
    const albEventDefaultHeaders = {
      resource: '/query-params',
      httpMethod: 'GET',
      multiValueHeaders: {
        'content-type': ['application/json'],
      },
      multiValueQueryStringParameters: {
        key1: ['value1'],
        key2: ['value2'],
      },
      path: '/query-params',
      body: null,
      isBase64Encoded: false,
      requestContext: testALBRequestContext,
    }

    const albResponse = await handler(albEventDefaultHeaders)

    expect(albResponse.statusCode).toBe(200)
    expect(albResponse.body).toContain(
      JSON.stringify({
        key1: 'value1',
        key2: 'value2',
      })
    )
    expect(albResponse.headers).toBeUndefined()
    expect(albResponse.multiValueHeaders['content-type']).toEqual([
      expect.stringMatching(/^application\/json/),
    ])
    expect(albResponse.isBase64Encoded).toBe(false)
  })

  it('Should handle a GET request and return a 200 response with multi value multiQueryStringParameters (ALBProxyEvent)', async () => {
    const albEventDefaultHeaders = {
      resource: '/query-params',
      httpMethod: 'GET',
      multiValueHeaders: {
        'content-type': ['application/json'],
      },
      multiValueQueryStringParameters: {
        key1: ['value1'],
        key2: ['value2', 'otherValue2'],
      },
      path: '/multi-query-params',
      body: null,
      isBase64Encoded: false,
      requestContext: testALBRequestContext,
    }

    const albResponse = await handler(albEventDefaultHeaders)

    expect(albResponse.statusCode).toBe(200)
    expect(albResponse.body).toContain(
      JSON.stringify({
        key1: ['value1'],
        key2: ['value2', 'otherValue2'],
      })
    )
    expect(albResponse.headers).toBeUndefined()
    expect(albResponse.multiValueHeaders['content-type']).toEqual([
      expect.stringMatching(/^application\/json/),
    ])
    expect(albResponse.isBase64Encoded).toBe(false)
  })
})

describe('streamHandle function', () => {
  const app = new Hono<{ Bindings: Bindings }>()

  app.get('/', (c) => {
    return c.text('Hello Lambda!')
  })

  app.get('/stream/text', async (c) => {
    return c.streamText(async (stream) => {
      for (let i = 0; i < 3; i++) {
        await stream.writeln(`${i}`)
        await stream.sleep(1)
      }
    })
  })

  app.get('/sse', async (c) => {
    return streamSSE(c, async (stream) => {
      let id = 0
      const maxIterations = 2

      while (id < maxIterations) {
        const message = `Message\nIt is ${id}`
        await stream.writeSSE({ data: message, event: 'time-update', id: String(id++) })
        await stream.sleep(10)
      }
    })
  })

  const handler = streamHandle(app)

  it('Should streamHandle a GET request and return a 200 response (LambdaFunctionUrlEvent)', async () => {
    const event = {
      headers: { 'content-type': ' binary/octet-stream' },
      rawPath: '/stream/text',
      rawQueryString: '',
      body: null,
      isBase64Encoded: false,
      requestContext: testApiGatewayRequestContextV2,
    }

    testApiGatewayRequestContextV2.http.method = 'GET'

    const mockReadableStream = new Readable({
      // eslint-disable-next-line @typescript-eslint/no-empty-function
      read() {},
    })

    mockReadableStream.push('0\n')
    mockReadableStream.push('1\n')
    mockReadableStream.push('2\n')
    mockReadableStream.push('3\n')
    mockReadableStream.push(null) // EOF

    await handler(event, mockReadableStream)

    const chunks = []
    for await (const chunk of mockReadableStream) {
      chunks.push(chunk)
    }
    expect(chunks.join('')).toContain('0\n1\n2\n3\n')
  })

  it('Should handle a GET request for an SSE stream and return the correct chunks', async () => {
    const event = {
      headers: { 'content-type': 'text/event-stream' },
      rawPath: '/sse',
      rawQueryString: '',
      body: null,
      isBase64Encoded: false,
      requestContext: testApiGatewayRequestContextV2,
    }

    testApiGatewayRequestContextV2.http.method = 'GET'

    const mockReadableStream = new Readable({
      // eslint-disable-next-line @typescript-eslint/no-empty-function
      read() {},
    })

    const initContentType = {
      'Content-Type': 'application/vnd.awslambda.http-integration-response',
    }
    mockReadableStream.push(JSON.stringify(initContentType))

    // Send JSON formatted response headers, followed by 8 NULL characters as a separator
    const httpResponseMetadata = {
      statusCode: 200,
      headers: { 'Custom-Header': 'value' },
      cookies: ['session=abcd1234'],
    }
    const jsonResponsePrelude = JSON.stringify(httpResponseMetadata) + Buffer.alloc(8, 0).toString()
    mockReadableStream.push(jsonResponsePrelude)

    mockReadableStream.push('data: Message\ndata: It is 0\n\n')
    mockReadableStream.push('data: Message\ndata: It is 1\n\n')
    mockReadableStream.push(null) // EOF

    await handler(event, mockReadableStream)

    const chunks = []
    for await (const chunk of mockReadableStream) {
      chunks.push(chunk)
    }

    // If you have chunks, you might want to convert them to strings before checking
    const output = Buffer.concat(chunks).toString()
    expect(output).toContain('data: Message\ndata: It is 0\n\n')
    expect(output).toContain('data: Message\ndata: It is 1\n\n')

    // Assertions for the newly added header and prelude
    expect(output).toContain('application/vnd.awslambda.http-integration-response')
    expect(output).toContain('Custom-Header')
    expect(output).toContain('session=abcd1234')

    // Check for JSON prelude and NULL sequence
    const nullSequence = '\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000'
    expect(output).toContain(jsonResponsePrelude.replace(nullSequence, ''))
  })
})

describe('getProcessor function', () => {
  it('Should return ALBProcessor for an ALBProxyEvent event', () => {
    const event: ALBProxyEvent = {
      httpMethod: 'GET',
      path: '/',
      body: null,
      isBase64Encoded: false,
      requestContext: {
        elb: {
          targetGroupArn:
            'arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/lambda-279XGJDqGZ5rsrHC2Fjr/49e9d65c45c6791a',
        },
      },
    }

    const processor = getProcessor(event)
    expect(processor).toBeInstanceOf(ALBProcessor)
  })

  it('Should return EventV1Processor for an event without requestContext', () => {
    const event = {
      httpMethod: 'GET',
      path: '/',
      body: null,
      isBase64Encoded: false,
    }

    // while LambdaEvent RequestContext property is mandatory, it can be absent when testing through invoke-api or AWS Console
    // in such cases, a V1 processor should be returned
    const processor = getProcessor(event as unknown as LambdaEvent)
    expect(processor).toBeInstanceOf(EventV1Processor)
  })

  it('Should return EventV2Processor for an APIGatewayProxyEventV2 event', () => {
    const event: APIGatewayProxyEventV2 = {
      version: '2.0',
      routeKey: '$default',
      headers: { 'content-type': 'text/plain' },
      rawPath: '/',
      rawQueryString: '',
      body: null,
      isBase64Encoded: false,
      requestContext: testApiGatewayRequestContextV2,
    }

    const processor = getProcessor(event)
    expect(processor).toBeInstanceOf(EventV2Processor)
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/lambda/mock.ts
```typescript
import { vi } from 'vitest'
import type {
  APIGatewayProxyEvent,
  APIGatewayProxyEventV2,
  LambdaFunctionUrlEvent,
} from '../../src/adapter/aws-lambda/handler'
import type { LambdaContext } from '../../src/adapter/aws-lambda/types'

type StreamifyResponseHandler = (
  handlerFunc: (
    event: APIGatewayProxyEvent | APIGatewayProxyEventV2 | LambdaFunctionUrlEvent,
    responseStream: NodeJS.WritableStream,
    context: LambdaContext
  ) => Promise<void>
) => (event: APIGatewayProxyEvent, context: LambdaContext) => Promise<NodeJS.WritableStream>

const mockStreamifyResponse: StreamifyResponseHandler = (handlerFunc) => {
  return async (event, context) => {
    const mockWritableStream: NodeJS.WritableStream = new (require('stream').Writable)({
      write(chunk, encoding, callback) {
        console.log('Writing chunk:', chunk.toString())
        callback()
      },
      final(callback) {
        console.log('Finalizing stream.')
        callback()
      },
    })
    mockWritableStream.on('finish', () => {
      console.log('Stream has finished')
    })
    await handlerFunc(event, mockWritableStream, context)
    mockWritableStream.end()
    return mockWritableStream
  }
}

const awslambda = {
  streamifyResponse: mockStreamifyResponse,
}

vi.stubGlobal('awslambda', awslambda)

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/lambda/stream-mock.ts
```typescript
import { vi } from 'vitest'
import { Writable } from 'node:stream'
import type {
  APIGatewayProxyEvent,
  APIGatewayProxyEventV2,
} from '../../src/adapter/aws-lambda/handler'
import type { LambdaContext } from '../../src/adapter/aws-lambda/types'

type StreamifyResponseHandler = (
  handlerFunc: (
    event: APIGatewayProxyEvent | APIGatewayProxyEventV2,
    responseStream: Writable,
    context: LambdaContext
  ) => Promise<void>
) => (event: APIGatewayProxyEvent, context: LambdaContext) => Promise<NodeJS.WritableStream>

const mockStreamifyResponse: StreamifyResponseHandler = (handlerFunc) => {
  return async (event, context) => {
    const chunks = []
    const mockWritableStream = new Writable({
      write(chunk, encoding, callback) {
        chunks.push(chunk)
        callback()
      },
    })
    mockWritableStream.chunks = chunks
    await handlerFunc(event, mockWritableStream, context)
    mockWritableStream.end()
    return mockWritableStream
  }
}

const awslambda = {
  streamifyResponse: mockStreamifyResponse,
  HttpResponseStream: {
    from: (stream: Writable, httpResponseMetadata: unknown): Writable => {
      stream.write(Buffer.from(JSON.stringify(httpResponseMetadata)))
      return stream
    },
  },
}

vi.stubGlobal('awslambda', awslambda)

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/lambda/stream.test.ts
```typescript
import { streamHandle } from '../../src/adapter/aws-lambda/handler'
import type { LambdaEvent } from '../../src/adapter/aws-lambda/handler'
import type {
  ApiGatewayRequestContext,
  ApiGatewayRequestContextV2,
  LambdaContext,
} from '../../src/adapter/aws-lambda/types'
import { Hono } from '../../src/hono'
import './stream-mock'

type Bindings = {
  event: LambdaEvent
  lambdaContext: LambdaContext
  requestContext: ApiGatewayRequestContext | ApiGatewayRequestContextV2
}

const testApiGatewayRequestContextV2 = {
  accountId: '123456789012',
  apiId: 'urlid',
  authentication: null,
  authorizer: {
    iam: {
      accessKey: 'AKIA...',
      accountId: '111122223333',
      callerId: 'AIDA...',
      cognitoIdentity: null,
      principalOrgId: null,
      userArn: 'arn:aws:iam::111122223333:user/example-user',
      userId: 'AIDA...',
    },
  },
  domainName: 'example.com',
  domainPrefix: '<url-id>',
  http: {
    method: 'GET',
    path: '/my/path',
    protocol: 'HTTP/1.1',
    sourceIp: '123.123.123.123',
    userAgent: 'agent',
  },
  requestId: 'id',
  routeKey: '$default',
  stage: '$default',
  time: '12/Mar/2020:19:03:58 +0000',
  timeEpoch: 1583348638390,
  customProperty: 'customValue',
}

describe('streamHandle function', () => {
  const app = new Hono<{ Bindings: Bindings }>()

  app.get('/cookies', async (c) => {
    c.res.headers.append('Set-Cookie', 'cookie1=value1')
    c.res.headers.append('Set-Cookie', 'cookie2=value2')
    return c.text('Cookies Set')
  })

  const handler = streamHandle(app)

  it('to write multiple cookies into the headers', async () => {
    const event = {
      headers: { 'content-type': 'text/plain' },
      rawPath: '/cookies',
      rawQueryString: '',
      body: null,
      isBase64Encoded: false,
      requestContext: testApiGatewayRequestContextV2,
    }

    const stream = await handler(event)

    const metadata = JSON.parse(stream.chunks[0].toString())
    expect(metadata.cookies).toEqual(['cookie1=value1', 'cookie2=value2'])
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/lambda/vitest.config.ts
```typescript
/// <reference types="vitest" />
import { defineConfig } from 'vitest/config'
import config from '../../vitest.config'

export default defineConfig({
  test: {
    env: {
      NAME: 'Node',
    },
    globals: true,
    include: ['**/runtime-tests/lambda/**/*.+(ts|tsx|js)'],
    exclude: [
      '**/runtime-tests/lambda/vitest.config.ts',
      '**/runtime-tests/lambda/mock.ts',
      '**/runtime-tests/lambda/stream-mock.ts',
    ],
    coverage: {
      ...config.test?.coverage,
      reportsDirectory: './coverage/raw/runtime-lambda',
    },
  },
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/node/index.test.ts
```typescript
import { createAdaptorServer, serve } from '@hono/node-server'
import request from 'supertest'
import type { Server } from 'node:http'
import type { AddressInfo } from 'node:net'
import { Hono } from '../../src'
import { Context } from '../../src/context'
import { env, getRuntimeKey } from '../../src/helper/adapter'
import { stream, streamSSE } from '../../src/helper/streaming'
import { basicAuth } from '../../src/middleware/basic-auth'
import { compress } from '../../src/middleware/compress'
import { jwt } from '../../src/middleware/jwt'

// Test only minimal patterns.
// See <https://github.com/honojs/node-server> for more tests and information.

describe('Basic', () => {
  const app = new Hono()

  app.get('/', (c) => {
    return c.text('Hello! Node.js!')
  })
  app.get('/runtime-name', (c) => {
    return c.text(getRuntimeKey())
  })

  const server = createAdaptorServer(app)

  it('Should return 200 response', async () => {
    const res = await request(server).get('/')
    expect(res.status).toBe(200)
    expect(res.text).toBe('Hello! Node.js!')
  })

  it('Should return correct runtime name', async () => {
    const res = await request(server).get('/runtime-name')
    expect(res.status).toBe(200)
    expect(res.text).toBe('node')
  })
})

describe('Environment Variables', () => {
  it('Should return the environment variable', async () => {
    const c = new Context(new Request('http://localhost/'))
    const { NAME } = env<{ NAME: string }>(c)
    expect(NAME).toBe('Node')
  })
})

describe('Basic Auth Middleware', () => {
  const app = new Hono()

  const username = 'hono-user-a'
  const password = 'hono-password-a'
  app.use(
    '/auth/*',
    basicAuth({
      username,
      password,
    })
  )

  app.get('/auth/*', () => new Response('auth'))

  const server = createAdaptorServer(app)

  it('Should not authorize, return 401 Response', async () => {
    const res = await request(server).get('/auth/a')
    expect(res.status).toBe(401)
    expect(res.text).toBe('Unauthorized')
  })

  it('Should authorize, return 200 Response', async () => {
    const credential = 'aG9uby11c2VyLWE6aG9uby1wYXNzd29yZC1h'
    const res = await request(server).get('/auth/a').set('Authorization', `Basic ${credential}`)
    expect(res.status).toBe(200)
    expect(res.text).toBe('auth')
  })
})

describe('JWT Auth Middleware', () => {
  const app = new Hono()

  app.use('/jwt/*', jwt({ secret: 'a-secret' }))
  app.get('/jwt/a', (c) => c.text('auth'))

  const server = createAdaptorServer(app)

  it('Should not authorize, return 401 Response', async () => {
    const res = await request(server).get('/jwt/a')
    expect(res.status).toBe(401)
    expect(res.text).toBe('Unauthorized')
  })

  it('Should authorize, return 200 Response', async () => {
    const credential =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE'
    const res = await request(server).get('/jwt/a').set('Authorization', `Bearer ${credential}`)
    expect(res.status).toBe(200)
    expect(res.text).toBe('auth')
  })
})

describe('stream', () => {
  const app = new Hono()

  let aborted = false

  app.get('/stream', (c) => {
    return stream(c, async (stream) => {
      stream.onAbort(() => {
        aborted = true
      })
      return new Promise<void>((resolve) => {
        stream.onAbort(resolve)
      })
    })
  })
  app.get('/streamHello', (c) => {
    return stream(c, async (stream) => {
      stream.onAbort(() => {
        aborted = true
      })
      await stream.write('Hello')
    })
  })

  const server = createAdaptorServer(app)

  beforeEach(() => {
    aborted = false
  })

  it('Should call onAbort', async () => {
    const req = request(server)
      .get('/stream')
      .end(() => {})

    expect(aborted).toBe(false)
    await new Promise((resolve) => setTimeout(resolve, 10))
    req.abort()
    while (!aborted) {
      await new Promise((resolve) => setTimeout(resolve))
    }
    expect(aborted).toBe(true)
  })

  it('Should not be called onAbort if already closed', async () => {
    expect(aborted).toBe(false)
    const res = await request(server).get('/streamHello')
    expect(res.status).toBe(200)
    expect(res.text).toBe('Hello')
    expect(aborted).toBe(false)
  })
})

describe('streamSSE', () => {
  const app = new Hono()

  let aborted = false

  app.get('/stream', (c) => {
    return streamSSE(c, async (stream) => {
      stream.onAbort(() => {
        aborted = true
      })
      return new Promise<void>((resolve) => {
        stream.onAbort(resolve)
      })
    })
  })
  app.get('/streamHello', (c) => {
    return streamSSE(c, async (stream) => {
      stream.onAbort(() => {
        aborted = true
      })
      await stream.write('Hello')
    })
  })

  const server = createAdaptorServer(app)

  beforeEach(() => {
    aborted = false
  })

  it('Should call onAbort', async () => {
    const req = request(server)
      .get('/stream')
      .end(() => {})

    expect(aborted).toBe(false)
    await new Promise((resolve) => setTimeout(resolve, 10))
    req.abort()
    while (!aborted) {
      await new Promise((resolve) => setTimeout(resolve))
    }
    expect(aborted).toBe(true)
  })

  it('Should not be called onAbort if already closed', async () => {
    expect(aborted).toBe(false)
    const res = await request(server).get('/streamHello')
    expect(res.status).toBe(200)
    expect(res.text).toBe('Hello')
    expect(aborted).toBe(false)
  })
})

describe('compress', async () => {
  const cssContent = Array.from({ length: 60 }, () => 'body { color: red; }').join('\n')
  const [externalServer, serverInfo] = await new Promise<[Server, AddressInfo]>((resolve) => {
    const externalApp = new Hono()
    externalApp.get('/style.css', (c) =>
      c.text(cssContent, {
        headers: {
          'Content-Type': 'text/css',
        },
      })
    )
    const server = serve(
      {
        fetch: externalApp.fetch,
        port: 0,
        hostname: '0.0.0.0',
      },
      (serverInfo) => {
        resolve([server as Server, serverInfo])
      }
    )
  })

  const app = new Hono()
  app.use(compress())
  app.get('/fetch/:file', (c) => {
    return fetch(`http://${serverInfo.address}:${serverInfo.port}/${c.req.param('file')}`)
  })
  const server = createAdaptorServer(app)

  afterAll(() => {
    externalServer.close()
  })

  it('Should be compressed a fetch response', async () => {
    const res = await request(server).get('/fetch/style.css')
    expect(res.status).toBe(200)
    expect(res.headers['content-encoding']).toBe('gzip')
    expect(res.text).toBe(cssContent)
  })
})

describe('Buffers', () => {
  const app = new Hono()
    .get('/', async (c) => {
      return c.body(Buffer.from('hello'))
    })
    .get('/uint8array', async (c) => {
      return c.body(Uint8Array.from('hello'.split(''), (c) => c.charCodeAt(0)))
    })

  const server = createAdaptorServer(app)

  it('should allow returning buffers', async () => {
    const res = await request(server).get('/')
    expect(res.status).toBe(200)
    expect(res.text).toBe('hello')
  })

  it('should allow returning uint8array as well', async () => {
    const res = await request(server).get('/uint8array')
    expect(res.status).toBe(200)
    expect(res.text).toBe('hello')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/node/vitest.config.ts
```typescript
/// <reference types="vitest" />
import { defineConfig } from 'vitest/config'
import config from '../../vitest.config'

export default defineConfig({
  test: {
    env: {
      NAME: 'Node',
    },
    globals: true,
    include: ['**/runtime-tests/node/**/*.+(ts|tsx|js)'],
    exclude: ['**/runtime-tests/node/vitest.config.ts'],
    coverage: {
      ...config.test?.coverage,
      reportsDirectory: './coverage/raw/runtime-node',
    },
  },
})

```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/deno-jsx/deno.precompile.json
```json
{
  "compilerOptions": {
    "jsx": "precompile",
    "jsxImportSource": "hono/jsx",
    "lib": [
      "deno.ns",
      "dom",
      "dom.iterable"
    ]
  },
  "unstable": [
    "sloppy-imports"
  ],
  "imports": {
    "@std/assert": "jsr:@std/assert@^1.0.3",
    "hono/jsx/jsx-runtime": "../../src/jsx/jsx-runtime.ts"
  }
}
```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/deno-jsx/deno.react-jsx.json
```json
{
  "compilerOptions": {
    "jsx": "react-jsx",
    "jsxImportSource": "hono/jsx",
    "lib": [
      "deno.ns",
      "dom",
      "dom.iterable"
    ]
  },
  "unstable": [
    "sloppy-imports"
  ],
  "imports": {
    "@std/assert": "jsr:@std/assert@^1.0.3",
    "hono/jsx/jsx-runtime": "../../src/jsx/jsx-runtime.ts"
  }
}
```
/Users/josh/Documents/GitHub/honojs/hono/runtime-tests/deno-jsx/jsx.test.tsx
```
/** @jsxImportSource ../../src/jsx */
import { assertEquals } from '@std/assert'
import { Style, css } from '../../src/helper/css/index.ts'
import { Suspense, renderToReadableStream } from '../../src/jsx/streaming.ts'
import type { HtmlEscapedString } from '../../src/utils/html.ts'
import { HtmlEscapedCallbackPhase, resolveCallback } from '../../src/utils/html.ts'

Deno.test('JSX', () => {
  const Component = ({ name }: { name: string }) => <span>{name}</span>
  const html = (
    <div>
      <h1 id={'<Hello>'}>
        <Component name={'<Hono>'} />
      </h1>
    </div>
  )

  assertEquals(html.toString(), '<div><h1 id="&lt;Hello&gt;"><span>&lt;Hono&gt;</span></h1></div>')
})

Deno.test('JSX: Fragment', () => {
  const fragment = (
    <>
      <p>1</p>
      <p>2</p>
    </>
  )
  assertEquals(fragment.toString(), '<p>1</p><p>2</p>')
})

Deno.test('JSX: Empty Fragment', () => {
  const Component = () => <></>
  const html = <Component />
  assertEquals(html.toString(), '')
})

Deno.test('JSX: Async Component', async () => {
  const Component = async ({ name }: { name: string }) =>
    new Promise<HtmlEscapedString>((resolve) => setTimeout(() => resolve(<span>{name}</span>), 10))
  const stream = renderToReadableStream(
    <div>
      <Component name={'<Hono>'} />
    </div>
  )

  const chunks: string[] = []
  const textDecoder = new TextDecoder()
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  for await (const chunk of stream as any) {
    chunks.push(textDecoder.decode(chunk))
  }

  assertEquals(chunks.join(''), '<div><span>&lt;Hono&gt;</span></div>')
})

Deno.test('JSX: Suspense', async () => {
  const Content = () => {
    const content = new Promise<HtmlEscapedString>((resolve) =>
      setTimeout(() => resolve(<h1>Hello</h1>), 10)
    )
    return content
  }

  const stream = renderToReadableStream(
    <Suspense fallback={<p>Loading...</p>}>
      <Content />
    </Suspense>
  )

  const chunks: string[] = []
  const textDecoder = new TextDecoder()
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  for await (const chunk of stream as any) {
    chunks.push(textDecoder.decode(chunk))
  }

  assertEquals(chunks, [
    '<template id="H:0"></template><p>Loading...</p><!--/$-->',
    `<template data-hono-target="H:0"><h1>Hello</h1></template><script>
((d,c,n) => {
c=d.currentScript.previousSibling
d=d.getElementById('H:0')
if(!d)return
do{n=d.nextSibling;n.remove()}while(n.nodeType!=8||n.nodeValue!='/$')
d.replaceWith(c.content)
})(document)
</script>`,
  ])
})

Deno.test('JSX: css', async () => {
  const className = css`
    color: red;
  `
  const html = (
    <html>
      <head>
        <Style />
      </head>
      <body>
        <div class={className}></div>
      </body>
    </html>
  )

  const awaitedHtml = await html
  const htmlEscapedString = 'callbacks' in awaitedHtml ? awaitedHtml : await awaitedHtml.toString()
  assertEquals(
    await resolveCallback(htmlEscapedString, HtmlEscapedCallbackPhase.Stringify, false, {}),
    '<html><head><style id="hono-css">.css-3142110215{color:red}</style></head><body><div class="css-3142110215"></div></body></html>'
  )
})

Deno.test('JSX: css with CSP nonce', async () => {
  const className = css`
    color: red;
  `
  const html = (
    <html>
      <head>
        <Style nonce='1234' />
      </head>
      <body>
        <div class={className}></div>
      </body>
    </html>
  )

  const awaitedHtml = await html
  const htmlEscapedString = 'callbacks' in awaitedHtml ? awaitedHtml : await awaitedHtml.toString()
  assertEquals(
    await resolveCallback(htmlEscapedString, HtmlEscapedCallbackPhase.Stringify, false, {}),
    '<html><head><style id="hono-css" nonce="1234">.css-3142110215{color:red}</style></head><body><div class="css-3142110215"></div></body></html>'
  )
})

Deno.test('JSX: normalize key', async () => {
  const className = <div className='foo'></div>
  const htmlFor = <div htmlFor='foo'></div>
  const crossOrigin = <div crossOrigin='foo'></div>
  const httpEquiv = <div httpEquiv='foo'></div>
  const itemProp = <div itemProp='foo'></div>
  const fetchPriority = <div fetchPriority='foo'></div>
  const noModule = <div noModule='foo'></div>
  const formAction = <div formAction='foo'></div>

  assertEquals(className.toString(), '<div class="foo"></div>')
  assertEquals(htmlFor.toString(), '<div for="foo"></div>')
  assertEquals(crossOrigin.toString(), '<div crossorigin="foo"></div>')
  assertEquals(httpEquiv.toString(), '<div http-equiv="foo"></div>')
  assertEquals(itemProp.toString(), '<div itemprop="foo"></div>')
  assertEquals(fetchPriority.toString(), '<div fetchpriority="foo"></div>')
  assertEquals(noModule.toString(), '<div nomodule="foo"></div>')
  assertEquals(formAction.toString(), '<div formaction="foo"></div>')
})

Deno.test('JSX: null or undefined', async () => {
  const nullHtml = <div className={null}></div>
  const undefinedHtml = <div className={undefined}></div>

  // react-jsx : <div>
  // precompile : <div > // Extra whitespace is allowed because it is a specification.

  assertEquals(nullHtml.toString().replace(/\s+/g, ''), '<div></div>')
  assertEquals(undefinedHtml.toString().replace(/\s+/g, ''), '<div></div>')
})

Deno.test('JSX: boolean attributes', async () => {
  const trueHtml = <div disabled={true}></div>
  const falseHtml = <div disabled={false}></div>

  // output is different, but semantics as HTML is the same, so both are OK
  // react-jsx : <div disabled="">
  // precompile : <div disabled>

  assertEquals(trueHtml.toString().replace('=""', ''), '<div disabled></div>')
  assertEquals(falseHtml.toString(), '<div></div>')
})

Deno.test('JSX: number', async () => {
  const html = <div tabindex={1}></div>

  assertEquals(html.toString(), '<div tabindex="1"></div>')
})

Deno.test('JSX: style', async () => {
  const html = <div style={{ fontSize: '12px', color: null }}></div>
  assertEquals(html.toString(), '<div style="font-size:12px"></div>')
})

```
