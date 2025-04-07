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
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/lambda-edge/conninfo.test.ts
```typescript
import { Context } from '../../context'
import { getConnInfo } from './conninfo'
import type { CloudFrontEdgeEvent } from './handler'

describe('getConnInfo', () => {
  it('Should info is valid', () => {
    const clientIp = Math.random().toString()
    const env = {
      event: {
        Records: [
          {
            cf: {
              request: {
                clientIp,
              },
            },
          },
        ],
      } as CloudFrontEdgeEvent,
    }

    const c = new Context(new Request('http://localhost/'), { env })
    const info = getConnInfo(c)

    expect(info.remote.address).toBe(clientIp)
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/lambda-edge/conninfo.ts
```typescript
import type { Context } from '../../context'
import type { GetConnInfo } from '../../helper/conninfo'
import type { CloudFrontEdgeEvent } from './handler'

type Env = {
  Bindings: {
    event: CloudFrontEdgeEvent
  }
}

export const getConnInfo: GetConnInfo = (c: Context<Env>) => ({
  remote: {
    address: c.env.event.Records[0].cf.request.clientIp,
  },
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/lambda-edge/handler.test.ts
```typescript
import { describe } from 'vitest'
import { setCookie } from '../../helper/cookie'
import { Hono } from '../../hono'
import { encodeBase64 } from '../../utils/encode'
import type { CloudFrontEdgeEvent } from './handler'
import { createBody, handle, isContentTypeBinary } from './handler'

describe('isContentTypeBinary', () => {
  it('Should determine whether it is binary', () => {
    expect(isContentTypeBinary('image/png')).toBe(true)
    expect(isContentTypeBinary('font/woff2')).toBe(true)
    expect(isContentTypeBinary('image/svg+xml')).toBe(false)
    expect(isContentTypeBinary('image/svg+xml; charset=UTF-8')).toBe(false)
    expect(isContentTypeBinary('text/plain')).toBe(false)
    expect(isContentTypeBinary('text/plain; charset=UTF-8')).toBe(false)
    expect(isContentTypeBinary('text/css')).toBe(false)
    expect(isContentTypeBinary('text/javascript')).toBe(false)
    expect(isContentTypeBinary('application/json')).toBe(false)
    expect(isContentTypeBinary('application/ld+json')).toBe(false)
    expect(isContentTypeBinary('application/json')).toBe(false)
  })
})

describe('createBody', () => {
  it('Should the request be a GET or HEAD, the Request must not include a Body', () => {
    const encoder = new TextEncoder()
    const data = encoder.encode('test')
    const body = {
      action: 'read-only',
      data: encodeBase64(data),
      encoding: 'base64',
      inputTruncated: false,
    }

    expect(createBody('GET', body)).toEqual(undefined)
    expect(createBody('GET', body)).not.toEqual(data)
    expect(createBody('HEAD', body)).toEqual(undefined)
    expect(createBody('HEAD', body)).not.toEqual(data)
    expect(createBody('POST', body)).toEqual(data)
    expect(createBody('POST', body)).not.toEqual(undefined)
  })
})

describe('handle', () => {
  const cloudFrontEdgeEvent: CloudFrontEdgeEvent = {
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
            clientIp: '1.2.3.4',
            headers: {
              host: [
                {
                  key: 'Host',
                  value: 'hono.dev',
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
            uri: '/test-path',
          },
        },
      },
    ],
  }

  it('Should support alternate domain names', async () => {
    const app = new Hono()
    app.get('/test-path', (c) => {
      return c.text(c.req.url)
    })
    const handler = handle(app)

    const res = await handler(cloudFrontEdgeEvent)

    expect(res.body).toBe('https://hono.dev/test-path')
  })

  it('Should support multiple cookies', async () => {
    const app = new Hono()
    app.get('/test-path', (c) => {
      setCookie(c, 'cookie1', 'value1')
      setCookie(c, 'cookie2', 'value2')
      return c.text('')
    })
    const handler = handle(app)

    const res = await handler(cloudFrontEdgeEvent)

    expect(res.headers).toEqual({
      'content-type': [
        {
          key: 'content-type',
          value: 'text/plain; charset=UTF-8',
        },
      ],
      'set-cookie': [
        {
          key: 'set-cookie',
          value: 'cookie1=value1; Path=/',
        },
        {
          key: 'set-cookie',
          value: 'cookie2=value2; Path=/',
        },
      ],
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/lambda-edge/handler.ts
```typescript
import crypto from 'node:crypto'
import type { Hono } from '../../hono'

import { decodeBase64, encodeBase64 } from '../../utils/encode'

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
globalThis.crypto ??= crypto

interface CloudFrontHeader {
  key: string
  value: string
}

interface CloudFrontHeaders {
  [name: string]: CloudFrontHeader[]
}

interface CloudFrontCustomOrigin {
  customHeaders: CloudFrontHeaders
  domainName: string
  keepaliveTimeout: number
  path: string
  port: number
  protocol: string
  readTimeout: number
  sslProtocols: string[]
}
// https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-event-structure.html
interface CloudFrontS3Origin {
  authMethod: 'origin-access-identity' | 'none'
  customHeaders: CloudFrontHeaders
  domainName: string
  path: string
  region: string
}
type CloudFrontOrigin =
  | { s3: CloudFrontS3Origin; custom?: never }
  | { custom: CloudFrontCustomOrigin; s3?: never }

export interface CloudFrontRequest {
  clientIp: string
  headers: CloudFrontHeaders
  method: string
  querystring: string
  uri: string
  body?: {
    inputTruncated: boolean
    action: string
    encoding: string
    data: string
  }
  origin?: CloudFrontOrigin
}

export interface CloudFrontResponse {
  headers: CloudFrontHeaders
  status: string
  statusDescription?: string
}

export interface CloudFrontConfig {
  distributionDomainName: string
  distributionId: string
  eventType: string
  requestId: string
}

interface CloudFrontEvent {
  cf: {
    config: CloudFrontConfig
    request: CloudFrontRequest
    response?: CloudFrontResponse
  }
}

export interface CloudFrontEdgeEvent {
  Records: CloudFrontEvent[]
}

type CloudFrontContext = {}

export interface Callback {
  (err: Error | null, result?: CloudFrontRequest | CloudFrontResult): void
}

// https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-generating-http-responses-in-requests.html#lambda-generating-http-responses-programming-model
interface CloudFrontResult {
  status: string
  statusDescription?: string
  headers?: {
    [header: string]: {
      key: string
      value: string
    }[]
  }
  body?: string
  bodyEncoding?: 'text' | 'base64'
}

/**
 * Accepts events from 'Lambda@Edge' event
 * https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-event-structure.html
 */
const convertHeaders = (headers: Headers): CloudFrontHeaders => {
  const cfHeaders: CloudFrontHeaders = {}
  headers.forEach((value, key) => {
    cfHeaders[key.toLowerCase()] = [
      ...(cfHeaders[key.toLowerCase()] || []),
      { key: key.toLowerCase(), value },
    ]
  })
  return cfHeaders
}

export const handle = (
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  app: Hono<any>
): ((
  event: CloudFrontEdgeEvent,
  context?: CloudFrontContext,
  callback?: Callback
) => Promise<CloudFrontResult>) => {
  return async (event, context?, callback?) => {
    const res = await app.fetch(createRequest(event), {
      event,
      context,
      callback: (err: Error | null, result?: CloudFrontResult | CloudFrontRequest) => {
        callback?.(err, result)
      },
      config: event.Records[0].cf.config,
      request: event.Records[0].cf.request,
      response: event.Records[0].cf.response,
    })
    return createResult(res)
  }
}

const createResult = async (res: Response): Promise<CloudFrontResult> => {
  const isBase64Encoded = isContentTypeBinary(res.headers.get('content-type') || '')
  const body = isBase64Encoded ? encodeBase64(await res.arrayBuffer()) : await res.text()

  return {
    status: res.status.toString(),
    headers: convertHeaders(res.headers),
    body,
    ...(isBase64Encoded && { bodyEncoding: 'base64' }),
  }
}

const createRequest = (event: CloudFrontEdgeEvent): Request => {
  const queryString = event.Records[0].cf.request.querystring
  const host =
    event.Records[0].cf.request.headers?.host?.[0]?.value ||
    event.Records[0].cf.config.distributionDomainName
  const urlPath = `https://${host}${event.Records[0].cf.request.uri}`
  const url = queryString ? `${urlPath}?${queryString}` : urlPath

  const headers = new Headers()
  Object.entries(event.Records[0].cf.request.headers).forEach(([k, v]) => {
    v.forEach((header) => headers.set(k, header.value))
  })

  const requestBody = event.Records[0].cf.request.body
  const method = event.Records[0].cf.request.method
  const body = createBody(method, requestBody)

  return new Request(url, {
    headers,
    method,
    body,
  })
}

export const createBody = (
  method: string,
  requestBody: CloudFrontRequest['body']
): string | Uint8Array | undefined => {
  if (!requestBody || !requestBody.data) {
    return undefined
  }
  if (method === 'GET' || method === 'HEAD') {
    return undefined
  }
  if (requestBody.encoding === 'base64') {
    return decodeBase64(requestBody.data)
  }
  return requestBody.data
}

export const isContentTypeBinary = (contentType: string): boolean => {
  return !/^(text\/(plain|html|css|javascript|csv).*|application\/(.*json|.*xml).*|image\/svg\+xml.*)$/.test(
    contentType
  )
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/lambda-edge/index.ts
```typescript
/**
 * @module
 * Lambda@Edge Adapter for Hono.
 */

export { handle } from './handler'
export { getConnInfo } from './conninfo'
export type {
  Callback,
  CloudFrontConfig,
  CloudFrontRequest,
  CloudFrontResponse,
  CloudFrontEdgeEvent,
} from './handler'

```
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
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/aws-lambda/handler.test.ts
```typescript
import type { LambdaEvent } from './handler'
import { getProcessor, isContentEncodingBinary, isContentTypeBinary } from './handler'

describe('isContentTypeBinary', () => {
  it('Should determine whether it is binary', () => {
    expect(isContentTypeBinary('image/png')).toBe(true)
    expect(isContentTypeBinary('font/woff2')).toBe(true)
    expect(isContentTypeBinary('image/svg+xml')).toBe(false)
    expect(isContentTypeBinary('image/svg+xml; charset=UTF-8')).toBe(false)
    expect(isContentTypeBinary('text/plain')).toBe(false)
    expect(isContentTypeBinary('text/plain; charset=UTF-8')).toBe(false)
    expect(isContentTypeBinary('text/css')).toBe(false)
    expect(isContentTypeBinary('text/javascript')).toBe(false)
    expect(isContentTypeBinary('application/json')).toBe(false)
    expect(isContentTypeBinary('application/ld+json')).toBe(false)
    expect(isContentTypeBinary('application/json')).toBe(false)
  })
})

describe('isContentEncodingBinary', () => {
  it('Should determine whether it is compressed', () => {
    expect(isContentEncodingBinary('gzip')).toBe(true)
    expect(isContentEncodingBinary('compress')).toBe(true)
    expect(isContentEncodingBinary('deflate')).toBe(true)
    expect(isContentEncodingBinary('br')).toBe(true)
    expect(isContentEncodingBinary('deflate, gzip')).toBe(true)
    expect(isContentEncodingBinary('')).toBe(false)
    expect(isContentEncodingBinary('unknown')).toBe(false)
  })
})

describe('EventProcessor.createRequest', () => {
  it('Should return valid Request object from version 1.0 API Gateway event', () => {
    const event: LambdaEvent = {
      version: '1.0',
      resource: '/my/path',
      path: '/my/path',
      httpMethod: 'GET',
      headers: {
        'content-type': 'application/json',
        header1: 'value1',
        header2: 'value1',
      },
      multiValueHeaders: {
        header1: ['value1'],
        header2: ['value1', 'value2', 'value3'],
      },
      // This value doesn't match multi value's content.
      // We want to assert handler is using the multi value's content when both are available.
      queryStringParameters: {
        parameter2: 'value',
      },
      multiValueQueryStringParameters: {
        parameter1: ['value1', 'value2'],
        parameter2: ['value'],
      },
      requestContext: {
        accountId: '123456789012',
        apiId: 'id',
        authorizer: {
          claims: null,
          scopes: null,
        },
        domainName: 'id.execute-api.us-east-1.amazonaws.com',
        domainPrefix: 'id',
        extendedRequestId: 'request-id',
        httpMethod: 'GET',
        identity: {
          sourceIp: '192.0.2.1',
          userAgent: 'user-agent',
          clientCert: {
            clientCertPem: 'CERT_CONTENT',
            subjectDN: 'www.example.com',
            issuerDN: 'Example issuer',
            serialNumber: 'a1:a1:a1:a1:a1:a1:a1:a1:a1:a1:a1:a1:a1:a1:a1:a1',
            validity: {
              notBefore: 'May 28 12:30:02 2019 GMT',
              notAfter: 'Aug  5 09:36:04 2021 GMT',
            },
          },
        },
        path: '/my/path',
        protocol: 'HTTP/1.1',
        requestId: 'id=',
        requestTime: '04/Mar/2020:19:15:17 +0000',
        requestTimeEpoch: 1583349317135,
        resourcePath: '/my/path',
        stage: '$default',
      },
      pathParameters: {},
      stageVariables: {},
      body: null,
      isBase64Encoded: false,
    }

    const processor = getProcessor(event)
    const request = processor.createRequest(event)

    expect(request.method).toEqual('GET')
    expect(request.url).toEqual(
      'https://id.execute-api.us-east-1.amazonaws.com/my/path?parameter1=value1&parameter1=value2&parameter2=value'
    )
    expect(Object.fromEntries(request.headers)).toEqual({
      'content-type': 'application/json',
      header1: 'value1',
      header2: 'value1, value2, value3',
    })
  })

  it('Should return valid Request object from version 2.0 API Gateway event', () => {
    const event: LambdaEvent = {
      version: '2.0',
      routeKey: '$default',
      rawPath: '/my/path',
      rawQueryString: 'parameter1=value1&parameter1=value2&parameter2=value',
      cookies: ['cookie1', 'cookie2'],
      headers: {
        'content-type': 'application/json',
        header1: 'value1',
        header2: 'value1,value2',
      },
      queryStringParameters: {
        parameter1: 'value1,value2',
        parameter2: 'value',
      },
      requestContext: {
        accountId: '123456789012',
        apiId: 'api-id',
        authentication: null,
        authorizer: {},
        domainName: 'id.execute-api.us-east-1.amazonaws.com',
        domainPrefix: 'id',
        http: {
          method: 'POST',
          path: '/my/path',
          protocol: 'HTTP/1.1',
          sourceIp: '192.0.2.1',
          userAgent: 'agent',
        },
        requestId: 'id',
        routeKey: '$default',
        stage: '$default',
        time: '12/Mar/2020:19:03:58 +0000',
        timeEpoch: 1583348638390,
      },
      body: 'Hello from Lambda',
      pathParameters: {
        parameter1: 'value1',
      },
      isBase64Encoded: false,
      stageVariables: {
        stageVariable1: 'value1',
        stageVariable2: 'value2',
      },
    }

    const processor = getProcessor(event)
    const request = processor.createRequest(event)

    expect(request.method).toEqual('POST')
    expect(request.url).toEqual(
      'https://id.execute-api.us-east-1.amazonaws.com/my/path?parameter1=value1&parameter1=value2&parameter2=value'
    )
    expect(Object.fromEntries(request.headers)).toEqual({
      'content-type': 'application/json',
      cookie: 'cookie1; cookie2',
      header1: 'value1',
      header2: 'value1,value2',
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/aws-lambda/handler.ts
```typescript
import type { Hono } from '../../hono'
import type { Env, Schema } from '../../types'
import { decodeBase64, encodeBase64 } from '../../utils/encode'
import type {
  ALBRequestContext,
  ApiGatewayRequestContext,
  ApiGatewayRequestContextV2,
  Handler,
  LambdaContext,
} from './types'

export type LambdaEvent = APIGatewayProxyEvent | APIGatewayProxyEventV2 | ALBProxyEvent

// When calling HTTP API or Lambda directly through function urls
export interface APIGatewayProxyEventV2 {
  version: string
  routeKey: string
  headers: Record<string, string | undefined>
  multiValueHeaders?: undefined
  cookies?: string[]
  rawPath: string
  rawQueryString: string
  body: string | null
  isBase64Encoded: boolean
  requestContext: ApiGatewayRequestContextV2
  queryStringParameters?: {
    [name: string]: string | undefined
  }
  pathParameters?: {
    [name: string]: string | undefined
  }
  stageVariables?: {
    [name: string]: string | undefined
  }
}

// When calling Lambda through an API Gateway
export interface APIGatewayProxyEvent {
  version: string
  httpMethod: string
  headers: Record<string, string | undefined>
  multiValueHeaders?: {
    [headerKey: string]: string[]
  }
  path: string
  body: string | null
  isBase64Encoded: boolean
  queryStringParameters?: Record<string, string | undefined>
  requestContext: ApiGatewayRequestContext
  resource: string
  multiValueQueryStringParameters?: {
    [parameterKey: string]: string[]
  }
  pathParameters?: Record<string, string>
  stageVariables?: Record<string, string>
}

// When calling Lambda through an Application Load Balancer
export interface ALBProxyEvent {
  httpMethod: string
  headers?: Record<string, string | undefined>
  multiValueHeaders?: Record<string, string[] | undefined>
  path: string
  body: string | null
  isBase64Encoded: boolean
  queryStringParameters?: Record<string, string | undefined>
  multiValueQueryStringParameters?: {
    [parameterKey: string]: string[]
  }
  requestContext: ALBRequestContext
}

type WithHeaders = {
  headers: Record<string, string>
  multiValueHeaders?: undefined
}
type WithMultiValueHeaders = {
  headers?: undefined
  multiValueHeaders: Record<string, string[]>
}

export type APIGatewayProxyResult = {
  statusCode: number
  statusDescription?: string
  body: string
  cookies?: string[]
  isBase64Encoded: boolean
} & (WithHeaders | WithMultiValueHeaders)

const getRequestContext = (
  event: LambdaEvent
): ApiGatewayRequestContext | ApiGatewayRequestContextV2 | ALBRequestContext => {
  return event.requestContext
}

const streamToNodeStream = async (
  reader: ReadableStreamDefaultReader<Uint8Array>,
  writer: NodeJS.WritableStream
): Promise<void> => {
  let readResult = await reader.read()
  while (!readResult.done) {
    writer.write(readResult.value)
    readResult = await reader.read()
  }
  writer.end()
}

export const streamHandle = <
  E extends Env = Env,
  S extends Schema = {},
  BasePath extends string = '/'
>(
  app: Hono<E, S, BasePath>
): Handler => {
  // @ts-expect-error awslambda is not a standard API
  return awslambda.streamifyResponse(
    async (event: LambdaEvent, responseStream: NodeJS.WritableStream, context: LambdaContext) => {
      const processor = getProcessor(event)
      try {
        const req = processor.createRequest(event)
        const requestContext = getRequestContext(event)

        const res = await app.fetch(req, {
          event,
          requestContext,
          context,
        })

        const headers: Record<string, string> = {}
        const cookies: string[] = []
        res.headers.forEach((value, name) => {
          if (name === 'set-cookie') {
            cookies.push(value)
          } else {
            headers[name] = value
          }
        })

        // Check content type
        const httpResponseMetadata = {
          statusCode: res.status,
          headers,
          cookies,
        }

        // Update response stream
        // @ts-expect-error awslambda is not a standard API
        responseStream = awslambda.HttpResponseStream.from(responseStream, httpResponseMetadata)

        if (res.body) {
          await streamToNodeStream(res.body.getReader(), responseStream)
        } else {
          responseStream.write('')
        }
      } catch (error) {
        console.error('Error processing request:', error)
        responseStream.write('Internal Server Error')
      } finally {
        responseStream.end()
      }
    }
  )
}

/**
 * Accepts events from API Gateway/ELB(`APIGatewayProxyEvent`) and directly through Function Url(`APIGatewayProxyEventV2`)
 */
export const handle = <E extends Env = Env, S extends Schema = {}, BasePath extends string = '/'>(
  app: Hono<E, S, BasePath>
): (<L extends LambdaEvent>(
  event: L,
  lambdaContext?: LambdaContext
) => Promise<
  APIGatewayProxyResult &
    (L extends { multiValueHeaders: Record<string, string[]> }
      ? WithMultiValueHeaders
      : WithHeaders)
>) => {
  // @ts-expect-error FIXME: Fix return typing
  return async (event, lambdaContext?) => {
    const processor = getProcessor(event)

    const req = processor.createRequest(event)
    const requestContext = getRequestContext(event)

    const res = await app.fetch(req, {
      event,
      requestContext,
      lambdaContext,
    })

    return processor.createResult(event, res)
  }
}

export abstract class EventProcessor<E extends LambdaEvent> {
  protected abstract getPath(event: E): string

  protected abstract getMethod(event: E): string

  protected abstract getQueryString(event: E): string

  protected abstract getHeaders(event: E): Headers

  protected abstract getCookies(event: E, headers: Headers): void

  protected abstract setCookiesToResult(result: APIGatewayProxyResult, cookies: string[]): void

  createRequest(event: E): Request {
    const queryString = this.getQueryString(event)
    const domainName =
      event.requestContext && 'domainName' in event.requestContext
        ? event.requestContext.domainName
        : event.headers?.['host'] ?? event.multiValueHeaders?.['host']?.[0]
    const path = this.getPath(event)
    const urlPath = `https://${domainName}${path}`
    const url = queryString ? `${urlPath}?${queryString}` : urlPath

    const headers = this.getHeaders(event)

    const method = this.getMethod(event)
    const requestInit: RequestInit = {
      headers,
      method,
    }

    if (event.body) {
      requestInit.body = event.isBase64Encoded ? decodeBase64(event.body) : event.body
    }

    return new Request(url, requestInit)
  }

  async createResult(event: E, res: Response): Promise<APIGatewayProxyResult> {
    const contentType = res.headers.get('content-type')
    let isBase64Encoded = contentType && isContentTypeBinary(contentType) ? true : false

    if (!isBase64Encoded) {
      const contentEncoding = res.headers.get('content-encoding')
      isBase64Encoded = isContentEncodingBinary(contentEncoding)
    }

    const body = isBase64Encoded ? encodeBase64(await res.arrayBuffer()) : await res.text()

    const result: APIGatewayProxyResult = {
      body: body,
      statusCode: res.status,
      isBase64Encoded,
      ...(event.multiValueHeaders
        ? {
            multiValueHeaders: {},
          }
        : {
            headers: {},
          }),
    }

    this.setCookies(event, res, result)
    if (result.multiValueHeaders) {
      res.headers.forEach((value, key) => {
        result.multiValueHeaders[key] = [value]
      })
    } else {
      res.headers.forEach((value, key) => {
        result.headers[key] = value
      })
    }

    return result
  }

  setCookies(event: E, res: Response, result: APIGatewayProxyResult) {
    if (res.headers.has('set-cookie')) {
      const cookies = res.headers.getSetCookie
        ? res.headers.getSetCookie()
        : Array.from(res.headers.entries())
            .filter(([k]) => k === 'set-cookie')
            .map(([, v]) => v)

      if (Array.isArray(cookies)) {
        this.setCookiesToResult(result, cookies)
        res.headers.delete('set-cookie')
      }
    }
  }
}

export class EventV2Processor extends EventProcessor<APIGatewayProxyEventV2> {
  protected getPath(event: APIGatewayProxyEventV2): string {
    return event.rawPath
  }

  protected getMethod(event: APIGatewayProxyEventV2): string {
    return event.requestContext.http.method
  }

  protected getQueryString(event: APIGatewayProxyEventV2): string {
    return event.rawQueryString
  }

  protected getCookies(event: APIGatewayProxyEventV2, headers: Headers): void {
    if (Array.isArray(event.cookies)) {
      headers.set('Cookie', event.cookies.join('; '))
    }
  }

  protected setCookiesToResult(result: APIGatewayProxyResult, cookies: string[]): void {
    result.cookies = cookies
  }

  protected getHeaders(event: APIGatewayProxyEventV2): Headers {
    const headers = new Headers()
    this.getCookies(event, headers)
    if (event.headers) {
      for (const [k, v] of Object.entries(event.headers)) {
        if (v) {
          headers.set(k, v)
        }
      }
    }
    return headers
  }
}

const v2Processor: EventV2Processor = new EventV2Processor()

export class EventV1Processor extends EventProcessor<Exclude<LambdaEvent, APIGatewayProxyEventV2>> {
  protected getPath(event: Exclude<LambdaEvent, APIGatewayProxyEventV2>): string {
    return event.path
  }

  protected getMethod(event: Exclude<LambdaEvent, APIGatewayProxyEventV2>): string {
    return event.httpMethod
  }

  protected getQueryString(event: Exclude<LambdaEvent, APIGatewayProxyEventV2>): string {
    // In the case of gateway Integration either queryStringParameters or multiValueQueryStringParameters can be present not both
    if (event.multiValueQueryStringParameters) {
      return Object.entries(event.multiValueQueryStringParameters || {})
        .filter(([, value]) => value)
        .map(([key, value]) => `${key}=${value.join(`&${key}=`)}`)
        .join('&')
    } else {
      return Object.entries(event.queryStringParameters || {})
        .filter(([, value]) => value)
        .map(([key, value]) => `${key}=${value}`)
        .join('&')
    }
  }

  protected getCookies(
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    event: Exclude<LambdaEvent, APIGatewayProxyEventV2>,
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    headers: Headers
  ): void {
    // nop
  }

  protected getHeaders(event: APIGatewayProxyEvent): Headers {
    const headers = new Headers()
    this.getCookies(event, headers)
    if (event.headers) {
      for (const [k, v] of Object.entries(event.headers)) {
        if (v) {
          headers.set(k, v)
        }
      }
    }
    if (event.multiValueHeaders) {
      for (const [k, values] of Object.entries(event.multiValueHeaders)) {
        if (values) {
          // avoid duplicating already set headers
          const foundK = headers.get(k)
          values.forEach((v) => (!foundK || !foundK.includes(v)) && headers.append(k, v))
        }
      }
    }
    return headers
  }

  protected setCookiesToResult(result: APIGatewayProxyResult, cookies: string[]): void {
    result.multiValueHeaders = {
      'set-cookie': cookies,
    }
  }
}

const v1Processor: EventV1Processor = new EventV1Processor()

export class ALBProcessor extends EventProcessor<ALBProxyEvent> {
  protected getHeaders(event: ALBProxyEvent): Headers {
    const headers = new Headers()
    // if multiValueHeaders is present the ALB will use it instead of the headers field
    // https://docs.aws.amazon.com/elasticloadbalancing/latest/application/lambda-functions.html#multi-value-headers
    if (event.multiValueHeaders) {
      for (const [key, values] of Object.entries(event.multiValueHeaders)) {
        if (values && Array.isArray(values)) {
          // https://www.rfc-editor.org/rfc/rfc9110.html#name-common-rules-for-defining-f
          headers.set(key, values.join('; '))
        }
      }
    } else {
      for (const [key, value] of Object.entries(event.headers ?? {})) {
        if (value) {
          headers.set(key, value)
        }
      }
    }
    return headers
  }

  protected getPath(event: ALBProxyEvent): string {
    return event.path
  }

  protected getMethod(event: ALBProxyEvent): string {
    return event.httpMethod
  }

  protected getQueryString(event: ALBProxyEvent): string {
    // In the case of ALB Integration either queryStringParameters or multiValueQueryStringParameters can be present not both
    /*
      In other cases like when using the serverless framework, the event object does contain both queryStringParameters and multiValueQueryStringParameters:
      Below is an example event object for this URL: /payment/b8c55e69?select=amount&select=currency
      {
        ...
        queryStringParameters: { select: 'currency' },
        multiValueQueryStringParameters: { select: [ 'amount', 'currency' ] },
      }
      The expected results is for select to be an array with two items. However the pre-fix code is only returning one item ('currency') in the array.
      A simple fix would be to invert the if statement and check the multiValueQueryStringParameters first.
    */
    if (event.multiValueQueryStringParameters) {
      return Object.entries(event.multiValueQueryStringParameters || {})
        .filter(([, value]) => value)
        .map(([key, value]) => `${key}=${value.join(`&${key}=`)}`)
        .join('&')
    } else {
      return Object.entries(event.queryStringParameters || {})
        .filter(([, value]) => value)
        .map(([key, value]) => `${key}=${value}`)
        .join('&')
    }
  }

  protected getCookies(event: ALBProxyEvent, headers: Headers): void {
    let cookie
    if (event.multiValueHeaders) {
      cookie = event.multiValueHeaders['cookie']?.join('; ')
    } else {
      cookie = event.headers ? event.headers['cookie'] : undefined
    }
    if (cookie) {
      headers.append('Cookie', cookie)
    }
  }

  protected setCookiesToResult(result: APIGatewayProxyResult, cookies: string[]): void {
    // when multi value headers is enabled
    if (result.multiValueHeaders) {
      result.multiValueHeaders['set-cookie'] = cookies
    } else {
      // otherwise serialize the set-cookie
      result.headers['set-cookie'] = cookies.join(', ')
    }
  }
}

const albProcessor: ALBProcessor = new ALBProcessor()

export const getProcessor = (event: LambdaEvent): EventProcessor<LambdaEvent> => {
  if (isProxyEventALB(event)) {
    return albProcessor
  }
  if (isProxyEventV2(event)) {
    return v2Processor
  }
  return v1Processor
}

const isProxyEventALB = (event: LambdaEvent): event is ALBProxyEvent => {
  if (event.requestContext) {
    return Object.hasOwn(event.requestContext, 'elb')
  }
  return false
}

const isProxyEventV2 = (event: LambdaEvent): event is APIGatewayProxyEventV2 => {
  return Object.hasOwn(event, 'rawPath')
}

export const isContentTypeBinary = (contentType: string) => {
  return !/^(text\/(plain|html|css|javascript|csv).*|application\/(.*json|.*xml).*|image\/svg\+xml.*)$/.test(
    contentType
  )
}

export const isContentEncodingBinary = (contentEncoding: string | null) => {
  if (contentEncoding === null) {
    return false
  }
  return /^(gzip|deflate|compress|br)/.test(contentEncoding)
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/aws-lambda/index.ts
```typescript
/**
 * @module
 * AWS Lambda Adapter for Hono.
 */

export { handle, streamHandle } from './handler'
export type { APIGatewayProxyResult, LambdaEvent } from './handler'
export type {
  ApiGatewayRequestContext,
  ApiGatewayRequestContextV2,
  ALBRequestContext,
  LambdaContext,
} from './types'

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/aws-lambda/types.ts
```typescript
/* eslint-disable @typescript-eslint/no-explicit-any */

export interface CognitoIdentity {
  cognitoIdentityId: string
  cognitoIdentityPoolId: string
}

export interface ClientContext {
  client: ClientContextClient

  Custom?: any
  env: ClientContextEnv
}

export interface ClientContextClient {
  installationId: string
  appTitle: string
  appVersionName: string
  appVersionCode: string
  appPackageName: string
}

export interface ClientContextEnv {
  platformVersion: string
  platform: string
  make: string
  model: string
  locale: string
}

/**
 * {@link Handler} context parameter.
 * See {@link https://docs.aws.amazon.com/lambda/latest/dg/nodejs-prog-model-context.html AWS documentation}.
 */
export interface LambdaContext {
  callbackWaitsForEmptyEventLoop: boolean
  functionName: string
  functionVersion: string
  invokedFunctionArn: string
  memoryLimitInMB: string
  awsRequestId: string
  logGroupName: string
  logStreamName: string
  identity?: CognitoIdentity | undefined
  clientContext?: ClientContext | undefined

  getRemainingTimeInMillis(): number
}

type Callback<TResult = any> = (error?: Error | string | null, result?: TResult) => void

export type Handler<TEvent = any, TResult = any> = (
  event: TEvent,
  context: LambdaContext,
  callback: Callback<TResult>
) => void | Promise<TResult>

interface ClientCert {
  clientCertPem: string
  subjectDN: string
  issuerDN: string
  serialNumber: string
  validity: {
    notBefore: string
    notAfter: string
  }
}

interface Identity {
  accessKey?: string
  accountId?: string
  caller?: string
  cognitoAuthenticationProvider?: string
  cognitoAuthenticationType?: string
  cognitoIdentityId?: string
  cognitoIdentityPoolId?: string
  principalOrgId?: string
  sourceIp: string
  user?: string
  userAgent: string
  userArn?: string
  clientCert?: ClientCert
}

export interface ApiGatewayRequestContext {
  accountId: string
  apiId: string
  authorizer: {
    claims?: unknown
    scopes?: unknown
  }
  domainName: string
  domainPrefix: string
  extendedRequestId: string
  httpMethod: string
  identity: Identity
  path: string
  protocol: string
  requestId: string
  requestTime: string
  requestTimeEpoch: number
  resourceId?: string
  resourcePath: string
  stage: string
}

interface Authorizer {
  iam?: {
    accessKey: string
    accountId: string
    callerId: string
    cognitoIdentity: null
    principalOrgId: null
    userArn: string
    userId: string
  }
}

export interface ApiGatewayRequestContextV2 {
  accountId: string
  apiId: string
  authentication: null
  authorizer: Authorizer
  domainName: string
  domainPrefix: string
  http: {
    method: string
    path: string
    protocol: string
    sourceIp: string
    userAgent: string
  }
  requestId: string
  routeKey: string
  stage: string
  time: string
  timeEpoch: number
}

export interface ALBRequestContext {
  elb: {
    targetGroupArn: string
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/cloudflare-pages/handler.test.ts
```typescript
import { getCookie } from '../../helper/cookie'
import { Hono } from '../../hono'
import { HTTPException } from '../../http-exception'
import type { EventContext } from './handler'
import { handle, handleMiddleware, serveStatic } from './handler'

type Env = {
  Bindings: {
    TOKEN: string
  }
}

function createEventContext(
  context: Partial<EventContext<Env['Bindings']>>
): EventContext<Env['Bindings']> {
  return {
    data: {},
    env: {
      ...context.env,
      ASSETS: { fetch: vi.fn(), ...context.env?.ASSETS },
      TOKEN: context.env?.TOKEN ?? 'HONOISHOT',
    },
    functionPath: '_worker.js',
    next: vi.fn(),
    params: {},
    passThroughOnException: vi.fn(),
    request: new Request('http://localhost/api/foo'),
    waitUntil: vi.fn(),
    ...context,
  }
}

describe('Adapter for Cloudflare Pages', () => {
  it('Should return 200 response', async () => {
    const request = new Request('http://localhost/api/foo')
    const env = {
      ASSETS: { fetch },
      TOKEN: 'HONOISHOT',
    }
    const waitUntil = vi.fn()
    const passThroughOnException = vi.fn()
    const eventContext = createEventContext({
      request,
      env,
      waitUntil,
      passThroughOnException,
    })
    const app = new Hono<Env>()
    const appFetchSpy = vi.spyOn(app, 'fetch')
    app.get('/api/foo', (c) => {
      return c.json({ TOKEN: c.env.TOKEN, requestURL: c.req.url })
    })
    const handler = handle(app)
    const res = await handler(eventContext)
    expect(appFetchSpy).toHaveBeenCalledWith(
      request,
      { ...env, eventContext },
      { waitUntil, passThroughOnException }
    )
    expect(res.status).toBe(200)
    expect(await res.json()).toEqual({
      TOKEN: 'HONOISHOT',
      requestURL: 'http://localhost/api/foo',
    })
  })

  it('Should not use `basePath()` if path argument is not passed', async () => {
    const request = new Request('http://localhost/api/error')
    const eventContext = createEventContext({ request })
    const app = new Hono().basePath('/api')

    app.onError((e) => {
      throw e
    })
    app.get('/error', () => {
      throw new Error('Custom Error')
    })

    const handler = handle(app)
    // It does throw the error if app is NOT "subApp"
    expect(() => handler(eventContext)).toThrowError('Custom Error')
  })
})

describe('Middleware adapter for Cloudflare Pages', () => {
  it('Should return the middleware response', async () => {
    const request = new Request('http://localhost/api/foo', {
      headers: {
        Cookie: 'my_cookie=1234',
      },
    })
    const next = vi.fn().mockResolvedValue(Response.json('From Cloudflare Pages'))
    const eventContext = createEventContext({ request, next })
    const handler = handleMiddleware(async (c, next) => {
      const cookie = getCookie(c, 'my_cookie')

      await next()

      return c.json({ cookie, response: await c.res.json() })
    })

    const res = await handler(eventContext)

    expect(next).toHaveBeenCalled()

    expect(await res.json()).toEqual({
      cookie: '1234',
      response: 'From Cloudflare Pages',
    })
  })

  it('Should return the middleware response when exceptions are handled', async () => {
    const request = new Request('http://localhost/api/foo')
    const handler = handleMiddleware(async (c, next) => {
      await next()

      return c.json({ error: c.error?.message })
    })

    const next = vi.fn().mockRejectedValue(new Error('Error from next()'))
    const eventContext = createEventContext({ request, next })
    const res = await handler(eventContext)

    expect(next).toHaveBeenCalled()

    expect(await res.json()).toEqual({
      error: 'Error from next()',
    })
  })

  it('Should return the middleware response if next() is not called', async () => {
    const request = new Request('http://localhost/api/foo')
    const handler = handleMiddleware(async (c) => {
      return c.json({ response: 'Skip Cloudflare Pages' })
    })

    const next = vi.fn()
    const eventContext = createEventContext({ request, next })
    const res = await handler(eventContext)

    expect(next).not.toHaveBeenCalled()

    expect(await res.json()).toEqual({
      response: 'Skip Cloudflare Pages',
    })
  })

  it('Should return the Pages response if the middleware does not return a response', async () => {
    const request = new Request('http://localhost/api/foo')
    const handler = handleMiddleware((c, next) => next())

    const next = vi.fn().mockResolvedValue(Response.json('From Cloudflare Pages'))
    const eventContext = createEventContext({ request, next })
    const res = await handler(eventContext)

    expect(next).toHaveBeenCalled()

    expect(await res.json()).toEqual('From Cloudflare Pages')
  })

  it('Should handle a HTTPException by returning error.getResponse()', async () => {
    const request = new Request('http://localhost/api/foo')
    const handler = handleMiddleware(() => {
      const res = new Response('Unauthorized', { status: 401 })
      throw new HTTPException(401, { res })
    })

    const next = vi.fn()
    const eventContext = createEventContext({ request, next })
    const res = await handler(eventContext)

    expect(next).not.toHaveBeenCalled()

    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
  })

  it('Should handle an HTTPException thrown by next()', async () => {
    const request = new Request('http://localhost/api/foo')
    const handler = handleMiddleware((c, next) => next())

    const next = vi
      .fn()
      .mockRejectedValue(new HTTPException(401, { res: Response.json('Unauthorized') }))
    const eventContext = createEventContext({ request, next })
    const res = await handler(eventContext)

    expect(next).toHaveBeenCalled()

    expect(await res.json()).toEqual('Unauthorized')
  })

  it('Should handle an Error thrown by next()', async () => {
    const request = new Request('http://localhost/api/foo')
    const handler = handleMiddleware((c, next) => next())

    const next = vi.fn().mockRejectedValue(new Error('Error from next()'))
    const eventContext = createEventContext({ request, next })
    await expect(handler(eventContext)).rejects.toThrowError('Error from next()')
    expect(next).toHaveBeenCalled()
  })

  it('Should handle a non-Error thrown by next()', async () => {
    const request = new Request('http://localhost/api/foo')
    const handler = handleMiddleware((c, next) => next())

    const next = vi.fn().mockRejectedValue('Error from next()')
    const eventContext = createEventContext({ request, next })
    await expect(handler(eventContext)).rejects.toThrowError('Error from next()')
    expect(next).toHaveBeenCalled()
  })

  it('Should rethrow an Error', async () => {
    const request = new Request('http://localhost/api/foo')
    const handler = handleMiddleware(() => {
      throw new Error('Something went wrong')
    })

    const next = vi.fn()
    const eventContext = createEventContext({ request, next })
    await expect(handler(eventContext)).rejects.toThrowError('Something went wrong')
    expect(next).not.toHaveBeenCalled()
  })

  it('Should rethrow non-Error exceptions', async () => {
    const request = new Request('http://localhost/api/foo')
    const handler = handleMiddleware(() => Promise.reject('Something went wrong'))
    const next = vi.fn()
    const eventContext = createEventContext({ request, next })
    await expect(handler(eventContext)).rejects.toThrowError('Something went wrong')
    expect(next).not.toHaveBeenCalled()
  })

  it('Should set the data in eventContext.data', async () => {
    const next = vi.fn()
    const eventContext = createEventContext({ next })
    const handler = handleMiddleware(async (c, next) => {
      c.env.eventContext.data.user = 'Joe'
      await next()
    })
    expect(eventContext.data.user).toBeUndefined()
    await handler(eventContext)
    expect(eventContext.data.user).toBe('Joe')
  })
})

describe('serveStatic()', () => {
  it('Should pass the raw request to ASSETS.fetch', async () => {
    const assetsFetch = vi.fn().mockResolvedValue(new Response('foo.png'))
    const request = new Request('http://localhost/foo.png')
    const env = {
      ASSETS: { fetch: assetsFetch },
      TOKEN: 'HONOISHOT',
    }

    const eventContext = createEventContext({ request, env })
    const app = new Hono<Env>()
    app.use(serveStatic())
    const handler = handle(app)
    const res = await handler(eventContext)

    expect(assetsFetch).toHaveBeenCalledWith(request)
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('foo.png')
  })

  it('Should respond with 404 if ASSETS.fetch returns a 404 response', async () => {
    const assetsFetch = vi.fn().mockResolvedValue(new Response(null, { status: 404 }))
    const request = new Request('http://localhost/foo.png')
    const env = {
      ASSETS: { fetch: assetsFetch },
      TOKEN: 'HONOISHOT',
    }

    const eventContext = createEventContext({ request, env })
    const app = new Hono<Env>()
    app.use(serveStatic())
    const handler = handle(app)
    const res = await handler(eventContext)

    expect(assetsFetch).toHaveBeenCalledWith(request)
    expect(res.status).toBe(404)
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/cloudflare-pages/handler.ts
```typescript
import { Context } from '../../context'
import type { Hono } from '../../hono'
import { HTTPException } from '../../http-exception'
import type { BlankSchema, Env, Input, MiddlewareHandler, Schema } from '../../types'

// Ref: https://github.com/cloudflare/workerd/blob/main/types/defines/pages.d.ts

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type Params<P extends string = any> = Record<P, string | string[]>

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type EventContext<Env = {}, P extends string = any, Data = Record<string, unknown>> = {
  request: Request
  functionPath: string
  waitUntil: (promise: Promise<unknown>) => void
  passThroughOnException: () => void
  next: (input?: Request | string, init?: RequestInit) => Promise<Response>
  env: Env & { ASSETS: { fetch: typeof fetch } }
  params: Params<P>
  data: Data
}

declare type PagesFunction<
  Env = unknown,
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  Params extends string = any,
  Data extends Record<string, unknown> = Record<string, unknown>
> = (context: EventContext<Env, Params, Data>) => Response | Promise<Response>

export const handle =
  <E extends Env = Env, S extends Schema = BlankSchema, BasePath extends string = '/'>(
    app: Hono<E, S, BasePath>
  ): PagesFunction<E['Bindings']> =>
  (eventContext) => {
    return app.fetch(
      eventContext.request,
      { ...eventContext.env, eventContext },
      {
        waitUntil: eventContext.waitUntil,
        passThroughOnException: eventContext.passThroughOnException,
      }
    )
  }

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function handleMiddleware<E extends Env = {}, P extends string = any, I extends Input = {}>(
  middleware: MiddlewareHandler<
    E & {
      Bindings: {
        eventContext: EventContext
      }
    },
    P,
    I
  >
): PagesFunction<E['Bindings']> {
  return async (executionCtx) => {
    const context = new Context(executionCtx.request, {
      env: { ...executionCtx.env, eventContext: executionCtx },
      executionCtx,
    })

    let response: Response | void = undefined

    try {
      response = await middleware(context, async () => {
        try {
          context.res = await executionCtx.next()
        } catch (error) {
          if (error instanceof Error) {
            context.error = error
          } else {
            throw error
          }
        }
      })
    } catch (error) {
      if (error instanceof Error) {
        context.error = error
      } else {
        throw error
      }
    }

    if (response) {
      return response
    }

    if (context.error instanceof HTTPException) {
      return context.error.getResponse()
    }

    if (context.error) {
      throw context.error
    }

    return context.res
  }
}

declare abstract class FetcherLike {
  fetch(input: RequestInfo, init?: RequestInit): Promise<Response>
}

/**
 *
 * @description `serveStatic()` is for advanced mode:
 * https://developers.cloudflare.com/pages/platform/functions/advanced-mode/#set-up-a-function
 *
 */
export const serveStatic = (): MiddlewareHandler => {
  return async (c) => {
    const env = c.env as { ASSETS: FetcherLike }
    const res = await env.ASSETS.fetch(c.req.raw)
    if (res.status === 404) {
      return c.notFound()
    }
    return res
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/cloudflare-pages/index.ts
```typescript
/**
 * @module
 * Cloudflare Pages Adapter for Hono.
 */

export { handle, handleMiddleware, serveStatic } from './handler'
export type { EventContext } from './handler'

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/bun/conninfo.test.ts
```typescript
import { Context } from '../../context'
import type { AddressType } from '../../helper/conninfo'
import { getConnInfo } from './conninfo'

const createRandomBunServer = ({
  address = Math.random().toString(),
  port = Math.floor(Math.random() * (65535 + 1)),
  family = 'IPv6',
}: {
  address?: string
  port?: number
  family?: AddressType | string
} = {}) => {
  return {
    address,
    port,
    server: {
      requestIP() {
        return {
          address,
          family,
          port,
        }
      },
    },
  }
}
describe('getConnInfo', () => {
  it('Should info is valid', () => {
    const { port, server, address } = createRandomBunServer()
    const c = new Context(new Request('http://localhost/'), { env: server })
    const info = getConnInfo(c)

    expect(info.remote.port).toBe(port)
    expect(info.remote.address).toBe(address)
    expect(info.remote.addressType).toBe('IPv6')
    expect(info.remote.transport).toBeUndefined()
  })
  it('Should getConnInfo works when env is { server: server }', () => {
    const { port, server, address } = createRandomBunServer()
    const c = new Context(new Request('http://localhost/'), { env: { server } })

    const info = getConnInfo(c)

    expect(info.remote.port).toBe(port)
    expect(info.remote.address).toBe(address)
    expect(info.remote.addressType).toBe('IPv6')
    expect(info.remote.transport).toBeUndefined()
  })
  it('should return undefined when addressType is invalid string', () => {
    const { server } = createRandomBunServer({ family: 'invalid' })
    const c = new Context(new Request('http://localhost/'), { env: { server } })

    const info = getConnInfo(c)

    expect(info.remote.addressType).toBeUndefined()
  })
  it('Should throw error when user did not give server', () => {
    const c = new Context(new Request('http://localhost/'), { env: {} })

    expect(() => getConnInfo(c)).toThrowError(TypeError)
  })
  it('Should throw error when requestIP is not function', () => {
    const c = new Context(new Request('http://localhost/'), {
      env: {
        requestIP: 0,
      },
    })
    expect(() => getConnInfo(c)).toThrowError(TypeError)
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/bun/conninfo.ts
```typescript
import type { Context } from '../..'
import type { GetConnInfo } from '../../helper/conninfo'
import { getBunServer } from './server'

/**
 * Get ConnInfo with Bun
 * @param c Context
 * @returns ConnInfo
 */
export const getConnInfo: GetConnInfo = (c: Context) => {
  const server = getBunServer(c)

  if (!server) {
    throw new TypeError('env has to include the 2nd argument of fetch.')
  }
  if (typeof server.requestIP !== 'function') {
    throw new TypeError('server.requestIP is not a function.')
  }
  const info = server.requestIP(c.req.raw)

  return {
    remote: {
      address: info.address,
      addressType: info.family === 'IPv6' || info.family === 'IPv4' ? info.family : undefined,
      port: info.port,
    },
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/bun/index.ts
```typescript
/**
 * @module
 * Bun Adapter for Hono.
 */

export { serveStatic } from './serve-static'
export { bunFileSystemModule, toSSG } from './ssg'
export { createBunWebSocket } from './websocket'
export type { BunWebSocketData, BunWebSocketHandler } from './websocket'
export { getConnInfo } from './conninfo'

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/bun/serve-static.ts
```typescript
/* eslint-disable @typescript-eslint/ban-ts-comment */
import { stat } from 'node:fs/promises'
import { serveStatic as baseServeStatic } from '../../middleware/serve-static'
import type { ServeStaticOptions } from '../../middleware/serve-static'
import type { Env, MiddlewareHandler } from '../../types'

export const serveStatic = <E extends Env = Env>(
  options: ServeStaticOptions<E>
): MiddlewareHandler => {
  return async function serveStatic(c, next) {
    const getContent = async (path: string) => {
      path = path.startsWith('/') ? path : `./${path}`
      // @ts-ignore
      const file = Bun.file(path)
      return (await file.exists()) ? file : null
    }
    const pathResolve = (path: string) => {
      return path.startsWith('/') ? path : `./${path}`
    }
    const isDir = async (path: string) => {
      let isDir
      try {
        const stats = await stat(path)
        isDir = stats.isDirectory()
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
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/bun/server.test.ts
```typescript
import { Context } from '../../context'
import { getBunServer } from './server'
import type { BunServer } from './server'

describe('getBunServer', () => {
  it('Should success to pick Server', () => {
    const server = {} as BunServer

    expect(getBunServer(new Context(new Request('http://localhost/'), { env: server }))).toBe(
      server
    )
    expect(getBunServer(new Context(new Request('http://localhost/'), { env: { server } }))).toBe(
      server
    )
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/bun/server.ts
```typescript
/**
 * Getting Bun Server Object for Bun adapters
 * @module
 */
import type { Context } from '../../context'

/**
 * Bun Server Object
 */
export interface BunServer {
  requestIP?: (req: Request) => {
    address: string
    family: string
    port: number
  }
  upgrade<T>(
    req: Request,
    options?: {
      data: T
    }
  ): boolean
}

/**
 * Get Bun Server Object from Context
 * @param c Context
 * @returns Bun Server
 */
export const getBunServer = (c: Context): BunServer | undefined =>
  ('server' in c.env ? c.env.server : c.env) as BunServer | undefined

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/bun/ssg.ts
```typescript
/* eslint-disable @typescript-eslint/ban-ts-comment */
import { toSSG as baseToSSG } from '../../helper/ssg'
import type { FileSystemModule, ToSSGAdaptorInterface } from '../../helper/ssg'

// @ts-ignore
const { write } = Bun

/**
 * @experimental
 * `bunFileSystemModule` is an experimental feature.
 * The API might be changed.
 */
export const bunFileSystemModule: FileSystemModule = {
  writeFile: async (path, data) => {
    await write(path, data)
  },
  mkdir: async () => {},
}

/**
 * @experimental
 * `toSSG` is an experimental feature.
 * The API might be changed.
 */
export const toSSG: ToSSGAdaptorInterface = async (app, options) => {
  return baseToSSG(app, bunFileSystemModule, options)
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/bun/websocket.test.ts
```typescript
import { Context } from '../../context'
import type { BunWebSocketData, BunServerWebSocket } from './websocket'
import { createWSContext, createBunWebSocket } from './websocket'

describe('createWSContext()', () => {
  it('Should send() and close() works', () => {
    const send = vi.fn()
    const close = vi.fn()
    const ws = createWSContext({
      send(data) {
        send(data)
      },
      close(code, reason) {
        close(code, reason)
      },
      data: {},
    } as BunServerWebSocket<BunWebSocketData>)
    ws.send('message')
    expect(send).toBeCalled()
    ws.close()
    expect(close).toBeCalled()
  })
})
describe('upgradeWebSocket()', () => {
  it('Should throw error when server is null', async () => {
    const { upgradeWebSocket } = createBunWebSocket()
    const run = async () =>
      await upgradeWebSocket(() => ({}))(
        new Context(new Request('http://localhost'), {
          env: {
            server: null,
          },
        }),
        () => Promise.resolve()
      )

    await expect(run).rejects.toThrowError(/env has/)
  })
  it('Should response null when upgraded', async () => {
    const { upgradeWebSocket } = createBunWebSocket()
    const upgraded = await upgradeWebSocket(() => ({}))(
      new Context(new Request('http://localhost'), {
        env: {
          upgrade: () => true,
        },
      }),
      () => Promise.resolve()
    )
    expect(upgraded).toBeTruthy()
  })
  it('Should response undefined when upgrade failed', async () => {
    const { upgradeWebSocket } = createBunWebSocket()
    const upgraded = await upgradeWebSocket(() => ({}))(
      new Context(new Request('http://localhost'), {
        env: {
          upgrade: () => undefined,
        },
      }),
      () => Promise.resolve()
    )
    expect(upgraded).toBeFalsy()
  })
})
describe('createBunWebSocket()', () => {
  beforeAll(() => {
    // @ts-expect-error patch global
    globalThis.CloseEvent = Event
  })
  afterAll(() => {
    // @ts-expect-error patch global
    delete globalThis.CloseEvent
  })
  it('Should events are called', async () => {
    const { websocket, upgradeWebSocket } = createBunWebSocket()

    const open = vi.fn()
    const message = vi.fn()
    const close = vi.fn()

    const ws = {
      data: {
        events: {
          // eslint-disable-next-line @typescript-eslint/no-unused-vars
          onOpen(evt, ws) {
            open()
          },
          // eslint-disable-next-line @typescript-eslint/no-unused-vars
          onMessage(evt, ws) {
            message()
            if (evt.data instanceof ArrayBuffer) {
              receivedArrayBuffer = evt.data
            }
          },
          // eslint-disable-next-line @typescript-eslint/no-unused-vars
          onClose(evt, ws) {
            close()
          },
        },
      },
    } as BunServerWebSocket<BunWebSocketData>

    let receivedArrayBuffer: ArrayBuffer | undefined = undefined
    await upgradeWebSocket(() => ({}))(
      new Context(new Request('http://localhost'), {
        env: {
          upgrade() {
            return true
          },
        },
      }),
      () => Promise.resolve()
    )

    websocket.open(ws)
    expect(open).toBeCalled()

    websocket.message(ws, 'message')
    expect(message).toBeCalled()

    websocket.message(ws, new Uint8Array(16))
    expect(receivedArrayBuffer).toBeInstanceOf(ArrayBuffer)
    expect(receivedArrayBuffer!.byteLength).toBe(16)

    websocket.close(ws)
    expect(close).toBeCalled()
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/bun/websocket.ts
```typescript
import type { UpgradeWebSocket, WSEvents, WSMessageReceive } from '../../helper/websocket'
import { createWSMessageEvent, defineWebSocketHelper, WSContext } from '../../helper/websocket'
import { getBunServer } from './server'

/**
 * @internal
 */
export interface BunServerWebSocket<T> {
  send(data: string | ArrayBuffer | Uint8Array, compress?: boolean): void
  close(code?: number, reason?: string): void
  data: T
  readyState: 0 | 1 | 2 | 3
}

export interface BunWebSocketHandler<T> {
  open(ws: BunServerWebSocket<T>): void
  close(ws: BunServerWebSocket<T>, code?: number, reason?: string): void
  message(ws: BunServerWebSocket<T>, message: string | { buffer: ArrayBufferLike }): void
}
interface CreateWebSocket<T> {
  upgradeWebSocket: UpgradeWebSocket<T>
  websocket: BunWebSocketHandler<BunWebSocketData>
}
export interface BunWebSocketData {
  events: WSEvents
  url: URL
  protocol: string
}

/**
 * @internal
 */
export const createWSContext = (ws: BunServerWebSocket<BunWebSocketData>): WSContext => {
  return new WSContext({
    send: (source, options) => {
      ws.send(source, options?.compress)
    },
    raw: ws,
    readyState: ws.readyState,
    url: ws.data.url,
    protocol: ws.data.protocol,
    close(code, reason) {
      ws.close(code, reason)
    },
  })
}

export const createBunWebSocket = <T>(): CreateWebSocket<T> => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const upgradeWebSocket: UpgradeWebSocket<any> = defineWebSocketHelper((c, events) => {
    const server = getBunServer(c)
    if (!server) {
      throw new TypeError('env has to include the 2nd argument of fetch.')
    }
    const upgradeResult = server.upgrade<BunWebSocketData>(c.req.raw, {
      data: {
        events,
        url: new URL(c.req.url),
        protocol: c.req.url,
      },
    })
    if (upgradeResult) {
      return new Response(null)
    }
    return // failed
  })
  const websocket: BunWebSocketHandler<BunWebSocketData> = {
    open(ws) {
      const websocketListeners = ws.data.events
      if (websocketListeners.onOpen) {
        websocketListeners.onOpen(new Event('open'), createWSContext(ws))
      }
    },
    close(ws, code, reason) {
      const websocketListeners = ws.data.events
      if (websocketListeners.onClose) {
        websocketListeners.onClose(
          new CloseEvent('close', {
            code,
            reason,
          }),
          createWSContext(ws)
        )
      }
    },
    message(ws, message) {
      const websocketListeners = ws.data.events
      if (websocketListeners.onMessage) {
        const normalizedReceiveData =
          typeof message === 'string' ? message : (message.buffer satisfies WSMessageReceive)

        websocketListeners.onMessage(
          createWSMessageEvent(normalizedReceiveData),
          createWSContext(ws)
        )
      }
    },
  }
  return {
    upgradeWebSocket,
    websocket,
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/netlify/handler.ts
```typescript
/* eslint-disable @typescript-eslint/no-explicit-any */
import type { Hono } from '../../hono'

export const handle = (
  app: Hono<any, any>
): ((req: Request, context: any) => Response | Promise<Response>) => {
  return (req: Request, context: any) => {
    return app.fetch(req, { context })
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/netlify/index.ts
```typescript
/**
 * @module
 * Netlify Adapter for Hono.
 */

export * from './mod'

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/netlify/mod.ts
```typescript
export { handle } from './handler'

```
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
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/service-worker/handler.test.ts
```typescript
import { Hono } from '../../hono'
import { handle } from './handler'
import type { FetchEvent } from './types'

beforeAll(() => {
  // fetch errors when it's not bound to globalThis in service worker
  // set a fetch stub to emulate that behavior
  vi.stubGlobal(
    'fetch',
    function fetch(this: undefined | typeof globalThis, arg0: string | Request) {
      if (this !== globalThis) {
        const error = new Error(
          "Failed to execute 'fetch' on 'WorkerGlobalScope': Illegal invocation"
        )
        error.name = 'TypeError'
        throw error
      }
      if (arg0 instanceof Request && arg0.url === 'http://localhost/fallback') {
        return new Response('hello world')
      }
      return Response.error()
    }
  )
})
afterAll(() => {
  vi.unstubAllGlobals()
})

describe('handle', () => {
  it('Success to fetch', async () => {
    const app = new Hono()
    app.get('/', (c) => {
      return c.json({ hello: 'world' })
    })
    const handler = handle(app)
    const json = await new Promise<Response>((resolve) => {
      handler({
        request: new Request('http://localhost/'),
        respondWith(res) {
          resolve(res)
        },
      } as FetchEvent)
    }).then((res) => res.json())
    expect(json).toStrictEqual({ hello: 'world' })
  })
  it('Fallback 404', async () => {
    const app = new Hono()
    const handler = handle(app)
    const text = await new Promise<Response>((resolve) => {
      handler({
        request: new Request('http://localhost/fallback'),
        respondWith(res) {
          resolve(res)
        },
      } as FetchEvent)
    }).then((res) => res.text())
    expect(text).toBe('hello world')
  })
  it('Fallback 404 with explicit fetch', async () => {
    const app = new Hono()
    const handler = handle(app, {
      async fetch() {
        return new Response('hello world')
      },
    })
    const text = await new Promise<Response>((resolve) => {
      handler({
        request: new Request('http://localhost/'),
        respondWith(res) {
          resolve(res)
        },
      } as FetchEvent)
    }).then((res) => res.text())
    expect(text).toBe('hello world')
  })
  it('Do not fallback 404 when fetch is undefined', async () => {
    const app = new Hono()
    app.get('/', (c) => c.text('Not found', 404))
    const handler = handle(app, {
      fetch: undefined,
    })
    const result = await new Promise<Response>((resolve) =>
      handler({
        request: new Request('https://localhost/'),
        respondWith(r) {
          resolve(r)
        },
      } as FetchEvent)
    )

    expect(result.status).toBe(404)
    expect(await result.text()).toBe('Not found')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/service-worker/handler.ts
```typescript
/**
 * Handler for Service Worker
 * @module
 */

import type { Hono } from '../../hono'
import type { FetchEvent } from './types'

type Handler = (evt: FetchEvent) => void

/**
 * Adapter for Service Worker
 */
export const handle = (
  app: Hono,
  opts: {
    fetch?: typeof fetch
  } = {
    // To use `fetch` on a Service Worker correctly, bind it to `globalThis`.
    fetch: globalThis.fetch.bind(globalThis),
  }
): Handler => {
  return (evt) => {
    evt.respondWith(
      (async () => {
        const res = await app.fetch(evt.request)
        if (opts.fetch && res.status === 404) {
          return await opts.fetch(evt.request)
        }
        return res
      })()
    )
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/service-worker/index.ts
```typescript
/**
 * Service Worker Adapter for Hono.
 * @module
 */
export { handle } from './handler'

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/service-worker/types.ts
```typescript
interface ExtendableEvent extends Event {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  waitUntil(f: Promise<any>): void
}

export interface FetchEvent extends ExtendableEvent {
  readonly clientId: string
  readonly handled: Promise<undefined>
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  readonly preloadResponse: Promise<any>
  readonly request: Request
  readonly resultingClientId: string
  respondWith(r: Response | PromiseLike<Response>): void
}

```
