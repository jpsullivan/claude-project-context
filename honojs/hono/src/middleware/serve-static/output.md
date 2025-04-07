/Users/josh/Documents/GitHub/honojs/hono/src/middleware/serve-static/index.test.ts
```typescript
import { Hono } from '../../hono'
import { serveStatic as baseServeStatic } from '.'

describe('Serve Static Middleware', () => {
  const app = new Hono()
  const getContent = vi.fn(async (path) => {
    if (path.endsWith('not-found.txt')) {
      return null
    }
    return `Hello in ${path}`
  })

  const serveStatic = baseServeStatic({
    getContent,
    pathResolve: (path) => {
      return `./${path}`
    },
    isDir: (path) => {
      return path === 'static/hello.world'
    },
    onFound: (path, c) => {
      if (path.endsWith('hello.html')) {
        c.header('X-Custom', `Found the file at ${path}`)
      }
    },
  })

  app.get('/static/*', serveStatic)

  beforeEach(() => {
    getContent.mockClear()
  })

  it('Should return 200 response - /static/hello.html', async () => {
    const res = await app.request('/static/hello.html')
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Encoding')).toBeNull()
    expect(res.headers.get('Content-Type')).toMatch(/^text\/html/)
    expect(await res.text()).toBe('Hello in ./static/hello.html')
    expect(res.headers.get('X-Custom')).toBe('Found the file at ./static/hello.html')
  })

  it('Should return 200 response - /static/sub', async () => {
    const res = await app.request('/static/sub')
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toMatch(/^text\/html/)
    expect(await res.text()).toBe('Hello in ./static/sub/index.html')
  })

  it('Should return 200 response - /static/helloworld', async () => {
    const res = await app.request('/static/helloworld')
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toMatch(/^text\/html/)
    expect(await res.text()).toBe('Hello in ./static/helloworld/index.html')
  })

  it('Should return 200 response - /static/hello.world', async () => {
    const res = await app.request('/static/hello.world')
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toMatch(/^text\/html/)
    expect(await res.text()).toBe('Hello in ./static/hello.world/index.html')
  })

  it('Should decode URI strings - /static/%E7%82%8E.txt', async () => {
    const res = await app.request('/static/%E7%82%8E.txt')
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toMatch(/^text\/plain/)
    expect(await res.text()).toBe('Hello in ./static/炎.txt')
  })

  it('Should return 404 response - /static/not-found.txt', async () => {
    const res = await app.request('/static/not-found.txt')
    expect(res.status).toBe(404)
    expect(res.headers.get('Content-Encoding')).toBeNull()
    expect(res.headers.get('Content-Type')).toMatch(/^text\/plain/)
    expect(await res.text()).toBe('404 Not Found')
    expect(getContent).toBeCalledTimes(1)
  })

  it('Should not allow a directory traversal - /static/%2e%2e/static/hello.html', async () => {
    const res = await app.fetch({
      method: 'GET',
      url: 'http://localhost/static/%2e%2e/static/hello.html',
    } as Request)
    expect(res.status).toBe(404)
    expect(res.headers.get('Content-Type')).toMatch(/^text\/plain/)
    expect(await res.text()).toBe('404 Not Found')
  })

  it('Should return a pre-compressed zstd response - /static/hello.html', async () => {
    const app = new Hono().use(
      '*',
      baseServeStatic({
        getContent,
        precompressed: true,
      })
    )

    const res = await app.request('/static/hello.html', {
      headers: { 'Accept-Encoding': 'zstd' },
    })

    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Encoding')).toBe('zstd')
    expect(res.headers.get('Vary')).toBe('Accept-Encoding')
    expect(res.headers.get('Content-Type')).toMatch(/^text\/html/)
    expect(await res.text()).toBe('Hello in static/hello.html.zst')
  })

  it('Should return a pre-compressed brotli response - /static/hello.html', async () => {
    const app = new Hono().use(
      '*',
      baseServeStatic({
        getContent,
        precompressed: true,
      })
    )

    const res = await app.request('/static/hello.html', {
      headers: { 'Accept-Encoding': 'wompwomp, gzip, br, deflate, zstd' },
    })

    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Encoding')).toBe('br')
    expect(res.headers.get('Vary')).toBe('Accept-Encoding')
    expect(res.headers.get('Content-Type')).toMatch(/^text\/html/)
    expect(await res.text()).toBe('Hello in static/hello.html.br')
  })

  it('Should return a pre-compressed brotli response - /static/hello.unknown', async () => {
    const app = new Hono().use(
      '*',
      baseServeStatic({
        getContent,
        precompressed: true,
      })
    )

    const res = await app.request('/static/hello.unknown', {
      headers: { 'Accept-Encoding': 'wompwomp, gzip, br, deflate, zstd' },
    })

    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Encoding')).toBe('br')
    expect(res.headers.get('Vary')).toBe('Accept-Encoding')
    expect(res.headers.get('Content-Type')).toBe('application/octet-stream')
    expect(await res.text()).toBe('Hello in static/hello.unknown.br')
  })

  it('Should not return a pre-compressed response - /static/not-found.txt', async () => {
    const app = new Hono().use(
      '*',
      baseServeStatic({
        getContent,
        precompressed: true,
      })
    )

    const res = await app.request('/static/not-found.txt', {
      headers: { 'Accept-Encoding': 'gzip, zstd, br' },
    })

    expect(res.status).toBe(404)
    expect(res.headers.get('Content-Encoding')).toBeNull()
    expect(res.headers.get('Vary')).toBeNull()
    expect(res.headers.get('Content-Type')).toMatch(/^text\/plain/)
    expect(await res.text()).toBe('404 Not Found')
  })

  it('Should not return a pre-compressed response - /static/hello.html', async () => {
    const app = new Hono().use(
      '*',
      baseServeStatic({
        getContent,
        precompressed: true,
      })
    )

    const res = await app.request('/static/hello.html', {
      headers: { 'Accept-Encoding': 'wompwomp, unknown' },
    })

    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Encoding')).toBeNull()
    expect(res.headers.get('Vary')).toBeNull()
    expect(res.headers.get('Content-Type')).toMatch(/^text\/html/)
    expect(await res.text()).toBe('Hello in static/hello.html')
  })

  it('Should not find pre-compressed files - /static/hello.jpg', async () => {
    const app = new Hono().use(
      '*',
      baseServeStatic({
        getContent,
        precompressed: true,
      })
    )

    const res = await app.request('/static/hello.jpg', {
      headers: { 'Accept-Encoding': 'gzip, br, deflate, zstd' },
    })

    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Encoding')).toBeNull()
    expect(res.headers.get('Vary')).toBeNull()
    expect(res.headers.get('Content-Type')).toMatch(/^image\/jpeg/)
    expect(await res.text()).toBe('Hello in static/hello.jpg')
  })

  it('Should return response object content as-is', async () => {
    const body = new ReadableStream()
    const response = new Response(body)
    const app = new Hono().use(
      '*',
      baseServeStatic({
        getContent: async () => {
          return response
        },
      })
    )

    const res = await app.fetch({
      method: 'GET',
      url: 'http://localhost',
    } as Request)
    expect(res.status).toBe(200)
    expect(res.body).toBe(body)
  })

  describe('Changing root path', () => {
    const pathResolve = (path: string) => {
      return path.startsWith('/') ? path : `./${path}`
    }

    it('Should return the content with absolute root path', async () => {
      const app = new Hono()
      const serveStatic = baseServeStatic({
        getContent,
        pathResolve,
        root: '/home/hono/child',
      })
      app.get('/static/*', serveStatic)

      const res = await app.request('/static/html/hello.html')
      expect(await res.text()).toBe('Hello in /home/hono/child/static/html/hello.html')
    })

    it('Should traverse the directories with absolute root path', async () => {
      const app = new Hono()
      const serveStatic = baseServeStatic({
        getContent,
        pathResolve,
        root: '/home/hono/../parent',
      })
      app.get('/static/*', serveStatic)

      const res = await app.request('/static/html/hello.html')
      expect(await res.text()).toBe('Hello in /home/parent/static/html/hello.html')
    })

    it('Should treat the root path includes .. as relative path', async () => {
      const app = new Hono()
      const serveStatic = baseServeStatic({
        getContent,
        pathResolve,
        root: '../home/hono',
      })
      app.get('/static/*', serveStatic)

      const res = await app.request('/static/html/hello.html')
      expect(await res.text()).toBe('Hello in ./../home/hono/static/html/hello.html')
    })

    it('Should not allow directory traversal with . as relative path', async () => {
      const app = new Hono()
      const serveStatic = baseServeStatic({
        getContent,
        pathResolve,
        root: '.',
      })
      app.get('*', serveStatic)

      const res = await app.request('///etc/passwd')
      expect(res.status).toBe(404)
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/serve-static/index.ts
```typescript
/**
 * @module
 * Serve Static Middleware for Hono.
 */

import type { Context, Data } from '../../context'
import type { Env, MiddlewareHandler } from '../../types'
import { COMPRESSIBLE_CONTENT_TYPE_REGEX } from '../../utils/compress'
import { getFilePath, getFilePathWithoutDefaultDocument } from '../../utils/filepath'
import { getMimeType } from '../../utils/mime'

export type ServeStaticOptions<E extends Env = Env> = {
  root?: string
  path?: string
  precompressed?: boolean
  mimes?: Record<string, string>
  rewriteRequestPath?: (path: string) => string
  onFound?: (path: string, c: Context<E>) => void | Promise<void>
  onNotFound?: (path: string, c: Context<E>) => void | Promise<void>
}

const ENCODINGS = {
  br: '.br',
  zstd: '.zst',
  gzip: '.gz',
} as const
const ENCODINGS_ORDERED_KEYS = Object.keys(ENCODINGS) as (keyof typeof ENCODINGS)[]

const DEFAULT_DOCUMENT = 'index.html'
const defaultPathResolve = (path: string) => path

/**
 * This middleware is not directly used by the user. Create a wrapper specifying `getContent()` by the environment such as Deno or Bun.
 */
export const serveStatic = <E extends Env = Env>(
  options: ServeStaticOptions<E> & {
    getContent: (path: string, c: Context<E>) => Promise<Data | Response | null>
    pathResolve?: (path: string) => string
    isDir?: (path: string) => boolean | undefined | Promise<boolean | undefined>
  }
): MiddlewareHandler => {
  let isAbsoluteRoot = false
  let root: string

  if (options.root) {
    if (options.root.startsWith('/')) {
      isAbsoluteRoot = true
      root = new URL(`file://${options.root}`).pathname
    } else {
      root = options.root
    }
  }

  return async (c, next) => {
    // Do nothing if Response is already set
    if (c.finalized) {
      await next()
      return
    }

    let filename = options.path ?? decodeURI(c.req.path)
    filename = options.rewriteRequestPath ? options.rewriteRequestPath(filename) : filename

    // If it was Directory, force `/` on the end.
    if (!filename.endsWith('/') && options.isDir) {
      const path = getFilePathWithoutDefaultDocument({
        filename,
        root,
      })
      if (path && (await options.isDir(path))) {
        filename += '/'
      }
    }

    let path = getFilePath({
      filename,
      root,
      defaultDocument: DEFAULT_DOCUMENT,
    })

    if (!path) {
      return await next()
    }

    if (isAbsoluteRoot) {
      path = '/' + path
    }

    const getContent = options.getContent
    const pathResolve = options.pathResolve ?? defaultPathResolve
    path = pathResolve(path)
    let content = await getContent(path, c)

    if (!content) {
      let pathWithoutDefaultDocument = getFilePathWithoutDefaultDocument({
        filename,
        root,
      })
      if (!pathWithoutDefaultDocument) {
        return await next()
      }
      pathWithoutDefaultDocument = pathResolve(pathWithoutDefaultDocument)

      if (pathWithoutDefaultDocument !== path) {
        content = await getContent(pathWithoutDefaultDocument, c)
        if (content) {
          path = pathWithoutDefaultDocument
        }
      }
    }

    if (content instanceof Response) {
      return c.newResponse(content.body, content)
    }

    if (content) {
      const mimeType = (options.mimes && getMimeType(path, options.mimes)) || getMimeType(path)
      c.header('Content-Type', mimeType || 'application/octet-stream')

      if (options.precompressed && (!mimeType || COMPRESSIBLE_CONTENT_TYPE_REGEX.test(mimeType))) {
        const acceptEncodingSet = new Set(
          c.req
            .header('Accept-Encoding')
            ?.split(',')
            .map((encoding) => encoding.trim())
        )

        for (const encoding of ENCODINGS_ORDERED_KEYS) {
          if (!acceptEncodingSet.has(encoding)) {
            continue
          }
          const compressedContent = (await getContent(path + ENCODINGS[encoding], c)) as Data | null

          if (compressedContent) {
            content = compressedContent
            c.header('Content-Encoding', encoding)
            c.header('Vary', 'Accept-Encoding', { append: true })
            break
          }
        }
      }
      await options.onFound?.(path, c)
      return c.body(content)
    }

    await options.onNotFound?.(path, c)
    await next()
    return
  }
}

```
