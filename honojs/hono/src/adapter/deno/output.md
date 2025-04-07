/Users/josh/Documents/GitHub/honojs/hono/src/adapter/deno/conninfo.test.ts
```typescript
import { Context } from '../../context'
import { getConnInfo } from './conninfo'

describe('getConnInfo', () => {
  it('Should info is valid', () => {
    const transport = 'tcp'
    const address = Math.random().toString()
    const port = Math.floor(Math.random() * (65535 + 1))
    const c = new Context(new Request('http://localhost/'), {
      env: {
        remoteAddr: {
          transport,
          hostname: address,
          port,
        },
      },
    })
    const info = getConnInfo(c)

    expect(info.remote.port).toBe(port)
    expect(info.remote.address).toBe(address)
    expect(info.remote.addressType).toBeUndefined()
    expect(info.remote.transport).toBe(transport)
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/deno/conninfo.ts
```typescript
import type { GetConnInfo } from '../../helper/conninfo'

/**
 * Get conninfo with Deno
 * @param c Context
 * @returns ConnInfo
 */
export const getConnInfo: GetConnInfo = (c) => {
  const { remoteAddr } = c.env
  return {
    remote: {
      address: remoteAddr.hostname,
      port: remoteAddr.port,
      transport: remoteAddr.transport,
    },
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/deno/deno.d.ts
```typescript
declare namespace Deno {
  interface FileHandleLike {
    readonly readable: ReadableStream<Uint8Array>
  }

  /**
   * Open the file using the specified path.
   *
   * @param path The path to open the file.
   * @returns FileHandle object.
   */
  export function open(path: string): Promise<FileHandleLike>

  interface StatsLike {
    isDirectory: boolean
  }

  /**
   * Get stats with the specified path.
   *
   * @param path The path to get stats.
   * @returns Stats object.
   */
  export function lstatSync(path: string): StatsLike

  /**
   * Creates a new directory with the specified path.
   *
   * @param path The path to create a directory.
   * @param options Options for creating a directory.
   * @returns A promise that resolves when the directory is created.
   */
  export function mkdir(path: string, options?: { recursive?: boolean }): Promise<void>

  /**
   * Write a new file, with the specified path and data.
   *
   * @param path The path to the file to write.
   * @param data The data to write into the file.
   * @returns A promise that resolves when the file is written.
   */
  export function writeFile(path: string, data: Uint8Array): Promise<void>

  /**
   * Errors of Deno
   */
  export const errors: Record<string, Function>

  export function upgradeWebSocket(
    req: Request,
    options: UpgradeWebSocketOptions
  ): {
    response: Response
    socket: WebSocket
  }

  /**
   * Options of `upgradeWebSocket`
   */
  export interface UpgradeWebSocketOptions {
    /**
     * Sets the `.protocol` property on the client-side web socket to the
     * value provided here, which should be one of the strings specified in the
     * `protocols` parameter when requesting the web socket. This is intended
     * for clients and servers to specify sub-protocols to use to communicate to
     * each other.
     */
    protocol?: string
    /**
     * If the client does not respond to this frame with a
     * `pong` within the timeout specified, the connection is deemed
     * unhealthy and is closed. The `close` and `error` events will be emitted.
     *
     * The unit is seconds, with a default of 30.
     * Set to `0` to disable timeouts.
     */
    idleTimeout?: number
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/deno/index.ts
```typescript
/**
 * @module
 * Deno Adapter for Hono.
 */

export { serveStatic } from './serve-static'
export { toSSG, denoFileSystemModule } from './ssg'
export { upgradeWebSocket } from './websocket'
export { getConnInfo } from './conninfo'

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/deno/serve-static.ts
```typescript
import type { ServeStaticOptions } from '../../middleware/serve-static'
import { serveStatic as baseServeStatic } from '../../middleware/serve-static'
import type { Env, MiddlewareHandler } from '../../types'

const { open, lstatSync, errors } = Deno

export const serveStatic = <E extends Env = Env>(
  options: ServeStaticOptions<E>
): MiddlewareHandler => {
  return async function serveStatic(c, next) {
    const getContent = async (path: string) => {
      try {
        if (isDir(path)) {
          return null
        }

        const file = await open(path)
        return file.readable
      } catch (e) {
        if (!(e instanceof errors.NotFound)) {
          console.warn(`${e}`)
        }
        return null
      }
    }
    const pathResolve = (path: string) => {
      return path.startsWith('/') ? path : `./${path}`
    }
    const isDir = (path: string) => {
      let isDir
      try {
        const stat = lstatSync(path)
        isDir = stat.isDirectory
      } catch {}
      return isDir
    }

    return baseServeStatic({
      ...options,
      getContent,
      pathResolve,
      isDir,
    })(c, next)
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/deno/ssg.ts
```typescript
import { toSSG as baseToSSG } from '../../helper/ssg/index'
import type { FileSystemModule, ToSSGAdaptorInterface } from '../../helper/ssg/index'

/**
 * @experimental
 * `denoFileSystemModule` is an experimental feature.
 * The API might be changed.
 */
export const denoFileSystemModule: FileSystemModule = {
  writeFile: async (path, data) => {
    const uint8Data =
      typeof data === 'string' ? new TextEncoder().encode(data) : new Uint8Array(data)
    await Deno.writeFile(path, uint8Data)
  },
  mkdir: async (path, options) => {
    return Deno.mkdir(path, { recursive: options?.recursive ?? false })
  },
}

/**
 * @experimental
 * `toSSG` is an experimental feature.
 * The API might be changed.
 */
export const toSSG: ToSSGAdaptorInterface = async (app, options) => {
  return baseToSSG(app, denoFileSystemModule, options)
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/deno/websocket.test.ts
```typescript
import { Hono } from '../..'
import { Context } from '../../context'
import { upgradeWebSocket } from './websocket'

globalThis.Deno = {} as typeof Deno

describe('WebSockets', () => {
  let app: Hono
  beforeEach(() => {
    app = new Hono()
  })

  it('Should receive data is valid', async () => {
    const messagePromise = new Promise((resolve) =>
      app.get(
        '/ws',
        upgradeWebSocket(() => ({
          onMessage: (evt) => resolve(evt.data),
        }))
      )
    )
    const socket = new EventTarget() as WebSocket
    Deno.upgradeWebSocket = () => {
      return {
        response: new Response(),
        socket,
      }
    }
    await app.request('/ws', {
      headers: {
        upgrade: 'websocket',
      },
    })
    const data = Math.random().toString()
    socket.onmessage &&
      socket.onmessage(
        new MessageEvent('message', {
          data,
        })
      )
    expect(await messagePromise).toBe(data)
  })

  it('Should receive data is valid with Options', async () => {
    const messagePromise = new Promise((resolve) =>
      app.get(
        '/ws',
        upgradeWebSocket(
          () => ({
            onMessage: (evt) => resolve(evt.data),
          }),
          {
            idleTimeout: 5000,
          }
        )
      )
    )
    const socket = new EventTarget() as WebSocket
    Deno.upgradeWebSocket = () => {
      return {
        response: new Response(),
        socket,
      }
    }
    await app.request('/ws', {
      headers: {
        upgrade: 'websocket',
      },
    })
    const data = Math.random().toString()
    socket.onmessage &&
      socket.onmessage(
        new MessageEvent('message', {
          data,
        })
      )
    expect(await messagePromise).toBe(data)
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
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/deno/websocket.ts
```typescript
import type { UpgradeWebSocket, WSReadyState } from '../../helper/websocket'
import { WSContext, defineWebSocketHelper } from '../../helper/websocket'

export const upgradeWebSocket: UpgradeWebSocket<WebSocket, Deno.UpgradeWebSocketOptions> =
  defineWebSocketHelper(async (c, events, options) => {
    if (c.req.header('upgrade') !== 'websocket') {
      return
    }

    const { response, socket } = Deno.upgradeWebSocket(c.req.raw, options ?? {})

    const wsContext: WSContext<WebSocket> = new WSContext({
      close: (code, reason) => socket.close(code, reason),
      get protocol() {
        return socket.protocol
      },
      raw: socket,
      get readyState() {
        return socket.readyState as WSReadyState
      },
      url: socket.url ? new URL(socket.url) : null,
      send: (source) => socket.send(source),
    })
    socket.onopen = (evt) => events.onOpen?.(evt, wsContext)
    socket.onmessage = (evt) => events.onMessage?.(evt, wsContext)
    socket.onclose = (evt) => events.onClose?.(evt, wsContext)
    socket.onerror = (evt) => events.onError?.(evt, wsContext)

    return response
  })

```
