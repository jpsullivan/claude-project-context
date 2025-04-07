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
