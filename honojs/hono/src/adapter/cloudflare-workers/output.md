/Users/josh/Documents/GitHub/honojs/hono/src/adapter/cloudflare-workers/conninfo.test.ts
```typescript
import { Context } from '../../context'
import { getConnInfo } from './conninfo'

describe('getConnInfo', () => {
  it('Should getConnInfo works', () => {
    const address = Math.random().toString()
    const req = new Request('http://localhost/', {
      headers: {
        'cf-connecting-ip': address,
      },
    })
    const c = new Context(req)

    const info = getConnInfo(c)

    expect(info.remote.address).toBe(address)
    expect(info.remote.addressType).toBeUndefined()
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/cloudflare-workers/conninfo.ts
```typescript
import type { GetConnInfo } from '../../helper/conninfo'

export const getConnInfo: GetConnInfo = (c) => ({
  remote: {
    address: c.req.header('cf-connecting-ip'),
  },
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/cloudflare-workers/index.ts
```typescript
/**
 * @module
 * Cloudflare Workers Adapter for Hono.
 */

export { serveStatic } from './serve-static-module'
export { upgradeWebSocket } from './websocket'
export { getConnInfo } from './conninfo'

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/cloudflare-workers/serve-static-module.ts
```typescript
// For ES module mode
import type { Env, MiddlewareHandler } from '../../types'
import type { ServeStaticOptions } from './serve-static'
import { serveStatic } from './serve-static'

const module = <E extends Env = Env>(
  options: Omit<ServeStaticOptions<E>, 'namespace'>
): MiddlewareHandler => {
  return serveStatic<E>(options)
}

export { module as serveStatic }

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/cloudflare-workers/serve-static.test.ts
```typescript
import type { Context } from '../../context'
import { Hono } from '../../hono'
import type { Next } from '../../types'
import { serveStatic } from './serve-static'

// Mock
const store: Record<string, string> = {
  'assets/static/plain.abcdef.txt': 'This is plain.txt',
  'assets/static/hono.abcdef.html': '<h1>Hono!</h1>',
  'assets/static/top/index.abcdef.html': '<h1>Top</h1>',
  'static-no-root/plain.abcdef.txt': 'That is plain.txt',
  'assets/static/options/foo.abcdef.txt': 'With options',
  'assets/.static/plain.abcdef.txt': 'In the dot',
  'assets/static/video/morning-routine.abcdef.m3u8': 'Good morning',
  'assets/static/video/morning-routine1.abcdef.ts': 'Good',
  'assets/static/video/introduction.abcdef.mp4': 'Let me introduce myself',
  'assets/static/download': 'download',
}
const manifest = JSON.stringify({
  'assets/static/plain.txt': 'assets/static/plain.abcdef.txt',
  'assets/static/hono.html': 'assets/static/hono.abcdef.html',
  'assets/static/top/index.html': 'assets/static/top/index.abcdef.html',
  'static-no-root/plain.txt': 'static-no-root/plain.abcdef.txt',
  'assets/.static/plain.txt': 'assets/.static/plain.abcdef.txt',
  'assets/static/download': 'assets/static/download',
})

Object.assign(global, { __STATIC_CONTENT_MANIFEST: manifest })
Object.assign(global, {
  __STATIC_CONTENT: {
    get: (path: string) => {
      return store[path]
    },
  },
})

describe('ServeStatic Middleware', () => {
  const app = new Hono()
  const onNotFound = vi.fn(() => {})
  app.use('/static/*', serveStatic({ root: './assets', onNotFound, manifest }))
  app.use('/static-no-root/*', serveStatic({ manifest }))
  app.use(
    '/dot-static/*',
    serveStatic({
      root: './assets',
      rewriteRequestPath: (path) => path.replace(/^\/dot-static/, '/.static'),
      manifest,
    })
  )

  beforeEach(() => onNotFound.mockClear())

  it('Should return plain.txt', async () => {
    const res = await app.request('http://localhost/static/plain.txt')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('This is plain.txt')
    expect(res.headers.get('Content-Type')).toBe('text/plain; charset=utf-8')
    expect(onNotFound).not.toHaveBeenCalled()
  })

  it('Should return hono.html', async () => {
    const res = await app.request('http://localhost/static/hono.html')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('<h1>Hono!</h1>')
    expect(res.headers.get('Content-Type')).toBe('text/html; charset=utf-8')
    expect(onNotFound).not.toHaveBeenCalled()
  })

  it('Should return 404 response', async () => {
    const res = await app.request('http://localhost/static/not-found.html')
    expect(res.status).toBe(404)
    expect(onNotFound).toHaveBeenCalledWith('assets/static/not-found.html', expect.anything())
  })

  it('Should return plan.txt', async () => {
    const res = await app.request('http://localhost/static-no-root/plain.txt')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('That is plain.txt')
    expect(res.headers.get('Content-Type')).toBe('text/plain; charset=utf-8')
  })

  it('Should return index.html', async () => {
    const res = await app.request('http://localhost/static/top')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('<h1>Top</h1>')
    expect(res.headers.get('Content-Type')).toBe('text/html; charset=utf-8')
  })

  it('Should return plain.txt with a rewriteRequestPath option', async () => {
    const res = await app.request('http://localhost/dot-static/plain.txt')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('In the dot')
    expect(res.headers.get('Content-Type')).toBe('text/plain; charset=utf-8')
  })
})

describe('With options', () => {
  const manifest = {
    'assets/static/options/foo.txt': 'assets/static/options/foo.abcdef.txt',
  }

  const app = new Hono()
  app.use('/static/*', serveStatic({ root: './assets', manifest: manifest }))

  it('Should return foo.txt', async () => {
    const res = await app.request('http://localhost/static/options/foo.txt')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('With options')
    expect(res.headers.get('Content-Type')).toBe('text/plain; charset=utf-8')
  })
})

describe('With `file` options', () => {
  const app = new Hono()
  app.get('/foo/*', serveStatic({ path: './assets/static/hono.html', manifest }))
  app.get('/bar/*', serveStatic({ path: './static/hono.html', root: './assets', manifest }))

  it('Should return hono.html', async () => {
    const res = await app.request('http://localhost/foo/fallback')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('<h1>Hono!</h1>')
  })

  it('Should return hono.html - with `root` option', async () => {
    const res = await app.request('http://localhost/bar/fallback')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('<h1>Hono!</h1>')
  })
})

describe('With `mimes` options', () => {
  const mimes = {
    m3u8: 'application/vnd.apple.mpegurl',
    ts: 'video/mp2t',
  }
  const manifest = {
    'assets/static/video/morning-routine.m3u8': 'assets/static/video/morning-routine.abcdef.m3u8',
    'assets/static/video/morning-routine1.ts': 'assets/static/video/morning-routine1.abcdef.ts',
    'assets/static/video/introduction.mp4': 'assets/static/video/introduction.abcdef.mp4',
  }

  const app = new Hono()
  app.use('/static/*', serveStatic({ root: './assets', mimes, manifest }))

  it('Should return content-type of m3u8', async () => {
    const res = await app.request('http://localhost/static/video/morning-routine.m3u8')
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toBe('application/vnd.apple.mpegurl')
  })
  it('Should return content-type of ts', async () => {
    const res = await app.request('http://localhost/static/video/morning-routine1.ts')
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toBe('video/mp2t')
  })
  it('Should return content-type of default on Hono', async () => {
    const res = await app.request('http://localhost/static/video/introduction.mp4')
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toBe('video/mp4')
  })
})

describe('With middleware', () => {
  const app = new Hono()
  const md1 = async (c: Context, next: Next) => {
    await next()
    c.res.headers.append('x-foo', 'bar')
  }
  const md2 = async (c: Context, next: Next) => {
    await next()
    c.res.headers.append('x-foo2', 'bar2')
  }

  app.use('/static/*', md1)
  app.use('/static/*', md2)
  app.use('/static/*', serveStatic({ root: './assets', manifest }))
  app.get('/static/foo', (c) => {
    return c.text('bar')
  })

  it('Should return plain.txt with correct headers', async () => {
    const res = await app.request('http://localhost/static/plain.txt')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('This is plain.txt')
    expect(res.headers.get('Content-Type')).toBe('text/plain; charset=utf-8')
    expect(res.headers.get('x-foo')).toBe('bar')
    expect(res.headers.get('x-foo2')).toBe('bar2')
  })

  it('Should return 200 Response', async () => {
    const res = await app.request('http://localhost/static/foo')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('bar')
  })

  it('Should handle a file without an extension', async () => {
    const res = await app.request('http://localhost/static/download')
    expect(res.status).toBe(200)
  })
})

describe('Types of middleware', () => {
  it('Should pass env type from generics of serveStatic', async () => {
    type Env = {
      Bindings: {
        HOGE: string
      }
    }
    const app = new Hono<Env>()
    app.use(
      '/static/*',
      serveStatic<Env>({
        root: './assets',
        onNotFound: (_, c) => {
          expectTypeOf(c.env).toEqualTypeOf<Env['Bindings']>()
        },
        manifest,
      })
    )
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/cloudflare-workers/serve-static.ts
```typescript
import { serveStatic as baseServeStatic } from '../../middleware/serve-static'
import type { ServeStaticOptions as BaseServeStaticOptions } from '../../middleware/serve-static'
import type { Env, MiddlewareHandler } from '../../types'
import { getContentFromKVAsset } from './utils'

export type ServeStaticOptions<E extends Env = Env> = BaseServeStaticOptions<E> & {
  // namespace is KVNamespace
  namespace?: unknown
  manifest: object | string
}

/**
 * @deprecated
 * `serveStatic` in the Cloudflare Workers adapter is deprecated.
 * You can serve static files directly using Cloudflare Static Assets.
 * @see https://developers.cloudflare.com/workers/static-assets/
 * Cloudflare Static Assets is currently in open beta. If this doesn't work for you,
 * please consider using Cloudflare Pages. You can start to create the Cloudflare Pages
 * application with the `npm create hono@latest` command.
 */
export const serveStatic = <E extends Env = Env>(
  options: ServeStaticOptions<E>
): MiddlewareHandler => {
  return async function serveStatic(c, next) {
    const getContent = async (path: string) => {
      return getContentFromKVAsset(path, {
        manifest: options.manifest,
        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
        // @ts-ignore
        namespace: options.namespace
          ? options.namespace
          : c.env
          ? c.env.__STATIC_CONTENT
          : undefined,
      })
    }
    return baseServeStatic({
      ...options,
      getContent,
    })(c, next)
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/cloudflare-workers/utils.test.ts
```typescript
import { getContentFromKVAsset } from './utils'

// Mock
const store: { [key: string]: string } = {
  'index.abcdef.html': 'This is index',
  'assets/static/plain.abcdef.txt': 'Asset text',
}
const manifest = JSON.stringify({
  'index.html': 'index.abcdef.html',
  'assets/static/plain.txt': 'assets/static/plain.abcdef.txt',
})

Object.assign(global, { __STATIC_CONTENT_MANIFEST: manifest })
Object.assign(global, {
  __STATIC_CONTENT: {
    get: (path: string) => {
      return store[path]
    },
  },
})

describe('Utils for Cloudflare Workers', () => {
  it('getContentFromKVAsset', async () => {
    let content = await getContentFromKVAsset('not-found.txt')
    expect(content).toBeFalsy()
    content = await getContentFromKVAsset('index.html')
    expect(content).toBeTruthy()
    expect(content).toBe('This is index')
    content = await getContentFromKVAsset('assets/static/plain.txt')
    expect(content).toBeTruthy()
    expect(content).toBe('Asset text')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/cloudflare-workers/utils.ts
```typescript
// __STATIC_CONTENT is KVNamespace
declare const __STATIC_CONTENT: unknown
declare const __STATIC_CONTENT_MANIFEST: string

export type KVAssetOptions = {
  manifest?: object | string
  // namespace is KVNamespace
  namespace?: unknown
}

export const getContentFromKVAsset = async (
  path: string,
  options?: KVAssetOptions
): Promise<ReadableStream | null> => {
  let ASSET_MANIFEST: Record<string, string>

  if (options && options.manifest) {
    if (typeof options.manifest === 'string') {
      ASSET_MANIFEST = JSON.parse(options.manifest)
    } else {
      ASSET_MANIFEST = options.manifest as Record<string, string>
    }
  } else {
    if (typeof __STATIC_CONTENT_MANIFEST === 'string') {
      ASSET_MANIFEST = JSON.parse(__STATIC_CONTENT_MANIFEST)
    } else {
      ASSET_MANIFEST = __STATIC_CONTENT_MANIFEST
    }
  }

  // ASSET_NAMESPACE is KVNamespace
  let ASSET_NAMESPACE: unknown
  if (options && options.namespace) {
    ASSET_NAMESPACE = options.namespace
  } else {
    ASSET_NAMESPACE = __STATIC_CONTENT
  }

  const key = ASSET_MANIFEST[path] || path
  if (!key) {
    return null
  }

  // @ts-expect-error ASSET_NAMESPACE is not typed
  const content = await ASSET_NAMESPACE.get(key, { type: 'stream' })
  if (!content) {
    return null
  }
  return content as unknown as ReadableStream
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/cloudflare-workers/websocket.test.ts
```typescript
import { Hono } from '../..'
import { Context } from '../../context'
import { upgradeWebSocket } from '.'

describe('upgradeWebSocket middleware', () => {
  const server = new EventTarget()

  // @ts-expect-error Cloudflare API
  globalThis.WebSocketPair = class {
    0: WebSocket // client
    1: WebSocket // server
    constructor() {
      this[0] = {} as WebSocket
      this[1] = server as WebSocket
    }
  }

  const app = new Hono()

  const wsPromise = new Promise((resolve) =>
    app.get(
      '/ws',
      upgradeWebSocket(() => ({
        onMessage(evt, ws) {
          resolve([evt.data, ws.readyState || 1])
        },
      }))
    )
  )
  it('Should receive message and readyState is valid', async () => {
    const sendingData = Math.random().toString()
    await app.request('/ws', {
      headers: {
        Upgrade: 'websocket',
      },
    })
    server.dispatchEvent(
      new MessageEvent('message', {
        data: sendingData,
      })
    )

    expect([sendingData, 1]).toStrictEqual(await wsPromise)
  })
  it('Should call next() when header does not have upgrade', async () => {
    const next = vi.fn()
    await upgradeWebSocket(() => ({}))(
      new Context(
        new Request('http://localhost', {
          headers: {
            Upgrade: 'example',
          },
        })
      ),
      next
    )
    expect(next).toBeCalled()
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/cloudflare-workers/websocket.ts
```typescript
import { WSContext, defineWebSocketHelper } from '../../helper/websocket'
import type { UpgradeWebSocket, WSEvents, WSReadyState } from '../../helper/websocket'

// Based on https://github.com/honojs/hono/issues/1153#issuecomment-1767321332
export const upgradeWebSocket: UpgradeWebSocket<
  WebSocket,
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  any,
  Omit<WSEvents<WebSocket>, 'onOpen'>
> = defineWebSocketHelper(async (c, events) => {
  const upgradeHeader = c.req.header('Upgrade')
  if (upgradeHeader !== 'websocket') {
    return
  }

  // @ts-expect-error WebSocketPair is not typed
  const webSocketPair = new WebSocketPair()
  const client: WebSocket = webSocketPair[0]
  const server: WebSocket = webSocketPair[1]

  const wsContext = new WSContext<WebSocket>({
    close: (code, reason) => server.close(code, reason),
    get protocol() {
      return server.protocol
    },
    raw: server,
    get readyState() {
      return server.readyState as WSReadyState
    },
    url: server.url ? new URL(server.url) : null,
    send: (source) => server.send(source),
  })

  // note: cloudflare workers doesn't support 'open' event

  if (events.onClose) {
    server.addEventListener('close', (evt: CloseEvent) => events.onClose?.(evt, wsContext))
  }
  if (events.onMessage) {
    server.addEventListener('message', (evt: MessageEvent) => events.onMessage?.(evt, wsContext))
  }
  if (events.onError) {
    server.addEventListener('error', (evt: Event) => events.onError?.(evt, wsContext))
  }

  // @ts-expect-error - server.accept is not typed
  server.accept?.()
  return new Response(null, {
    status: 101,
    // @ts-expect-error - webSocket is not typed
    webSocket: client,
  })
})

```
