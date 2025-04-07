/Users/josh/Documents/GitHub/honojs/hono/src/helper/dev/index.test.ts
```typescript
import { Hono } from '../../hono'
import { RegExpRouter } from '../../router/reg-exp-router'
import type { Handler, MiddlewareHandler } from '../../types'
import { getRouterName, inspectRoutes, showRoutes } from '.'

const namedMiddleware: MiddlewareHandler = (_, next) => next()
const namedHandler: Handler = (c) => c.text('hi')
const app = new Hono()
  .use('*', (c, next) => next())
  .get(
    '/',
    (_, next) => next(),
    (c) => c.text('hi')
  )
  .get('/named', namedMiddleware, namedHandler)
  .post('/', (c) => c.text('hi'))
  .put('/', (c) => c.text('hi'))
  .patch('/', (c) => c.text('hi'))
  .delete('/', (c) => c.text('hi'))
  .options('/', (c) => c.text('hi'))
  .get('/static', () => new Response('hi'))

describe('inspectRoutes()', () => {
  it('should return correct data', async () => {
    expect(inspectRoutes(app)).toEqual([
      { path: '/*', method: 'ALL', name: '[middleware]', isMiddleware: true },
      { path: '/', method: 'GET', name: '[middleware]', isMiddleware: true },
      { path: '/', method: 'GET', name: '[handler]', isMiddleware: false },
      { path: '/named', method: 'GET', name: 'namedMiddleware', isMiddleware: true },
      { path: '/named', method: 'GET', name: 'namedHandler', isMiddleware: false },
      { path: '/', method: 'POST', name: '[handler]', isMiddleware: false },
      { path: '/', method: 'PUT', name: '[handler]', isMiddleware: false },
      { path: '/', method: 'PATCH', name: '[handler]', isMiddleware: false },
      { path: '/', method: 'DELETE', name: '[handler]', isMiddleware: false },
      { path: '/', method: 'OPTIONS', name: '[handler]', isMiddleware: false },
      { path: '/static', method: 'GET', name: '[handler]', isMiddleware: false },
    ])
  })

  it('should return [handler] also for sub app', async () => {
    const subApp = new Hono()

    subApp.get('/', (c) => c.json(0))
    subApp.onError((_, c) => c.json(0))

    const mainApp = new Hono()
    mainApp.route('/', subApp)
    expect(inspectRoutes(mainApp)).toEqual([
      {
        isMiddleware: false,
        method: 'GET',
        name: '[handler]',
        path: '/',
      },
    ])
  })
})

describe('showRoutes()', () => {
  let logs: string[] = []

  let originalLog: typeof console.log
  beforeAll(() => {
    originalLog = console.log
    console.log = (...args) => logs.push(...args)
  })
  afterAll(() => {
    console.log = originalLog
  })

  beforeEach(() => {
    logs = []
  })
  it('should render simple output', async () => {
    showRoutes(app)
    expect(logs).toEqual([
      '\x1b[32mGET\x1b[0m      /',
      '\x1b[32mGET\x1b[0m      /named',
      '\x1b[32mPOST\x1b[0m     /',
      '\x1b[32mPUT\x1b[0m      /',
      '\x1b[32mPATCH\x1b[0m    /',
      '\x1b[32mDELETE\x1b[0m   /',
      '\x1b[32mOPTIONS\x1b[0m  /',
      '\x1b[32mGET\x1b[0m      /static',
    ])
  })

  it('should render output includes handlers and middlewares', async () => {
    showRoutes(app, { verbose: true })
    expect(logs).toEqual([
      '\x1b[32mALL\x1b[0m      /*',
      '           [middleware]',
      '\x1b[32mGET\x1b[0m      /',
      '           [middleware]',
      '           [handler]',
      '\x1b[32mGET\x1b[0m      /named',
      '           namedMiddleware',
      '           namedHandler',
      '\x1b[32mPOST\x1b[0m     /',
      '           [handler]',
      '\x1b[32mPUT\x1b[0m      /',
      '           [handler]',
      '\x1b[32mPATCH\x1b[0m    /',
      '           [handler]',
      '\x1b[32mDELETE\x1b[0m   /',
      '           [handler]',
      '\x1b[32mOPTIONS\x1b[0m  /',
      '           [handler]',
      '\x1b[32mGET\x1b[0m      /static',
      '           [handler]',
    ])
  })

  it('should render not colorized output', async () => {
    showRoutes(app, { colorize: false })
    expect(logs).toEqual([
      'GET      /',
      'GET      /named',
      'POST     /',
      'PUT      /',
      'PATCH    /',
      'DELETE   /',
      'OPTIONS  /',
      'GET      /static',
    ])
  })
})

describe('showRoutes() in NO_COLOR', () => {
  let logs: string[] = []

  let originalLog: typeof console.log
  beforeAll(() => {
    vi.stubEnv('NO_COLOR', '1')
    originalLog = console.log
    console.log = (...args) => logs.push(...args)
  })
  afterAll(() => {
    vi.unstubAllEnvs()
    console.log = originalLog
  })

  beforeEach(() => {
    logs = []
  })
  it('should render not colorized output', async () => {
    showRoutes(app)
    expect(logs).toEqual([
      'GET      /',
      'GET      /named',
      'POST     /',
      'PUT      /',
      'PATCH    /',
      'DELETE   /',
      'OPTIONS  /',
      'GET      /static',
    ])
  })
  it('should render colorized output if colorize: true', async () => {
    showRoutes(app, { colorize: true })
    expect(logs).toEqual([
      '\x1b[32mGET\x1b[0m      /',
      '\x1b[32mGET\x1b[0m      /named',
      '\x1b[32mPOST\x1b[0m     /',
      '\x1b[32mPUT\x1b[0m      /',
      '\x1b[32mPATCH\x1b[0m    /',
      '\x1b[32mDELETE\x1b[0m   /',
      '\x1b[32mOPTIONS\x1b[0m  /',
      '\x1b[32mGET\x1b[0m      /static',
    ])
  })
})

describe('getRouterName()', () => {
  it('Should return the correct router name', async () => {
    const app = new Hono({
      router: new RegExpRouter(),
    })
    expect(getRouterName(app)).toBe('RegExpRouter')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/helper/dev/index.ts
```typescript
/**
 * @module
 * Dev Helper for Hono.
 */

import type { Hono } from '../../hono'
import type { Env, RouterRoute } from '../../types'
import { getColorEnabled } from '../../utils/color'
import { findTargetHandler, isMiddleware } from '../../utils/handler'

interface ShowRoutesOptions {
  verbose?: boolean
  colorize?: boolean
}

interface RouteData {
  path: string
  method: string
  name: string
  isMiddleware: boolean
}

const handlerName = (handler: Function): string => {
  return handler.name || (isMiddleware(handler) ? '[middleware]' : '[handler]')
}

export const inspectRoutes = <E extends Env>(hono: Hono<E>): RouteData[] => {
  return hono.routes.map(({ path, method, handler }: RouterRoute) => {
    const targetHandler = findTargetHandler(handler)
    return {
      path,
      method,
      name: handlerName(targetHandler),
      isMiddleware: isMiddleware(targetHandler),
    }
  })
}

export const showRoutes = <E extends Env>(hono: Hono<E>, opts?: ShowRoutesOptions): void => {
  const colorEnabled = opts?.colorize ?? getColorEnabled()
  const routeData: Record<string, RouteData[]> = {}
  let maxMethodLength = 0
  let maxPathLength = 0

  inspectRoutes(hono)
    .filter(({ isMiddleware }) => opts?.verbose || !isMiddleware)
    .map((route) => {
      const key = `${route.method}-${route.path}`
      ;(routeData[key] ||= []).push(route)
      if (routeData[key].length > 1) {
        return
      }
      maxMethodLength = Math.max(maxMethodLength, route.method.length)
      maxPathLength = Math.max(maxPathLength, route.path.length)
      return { method: route.method, path: route.path, routes: routeData[key] }
    })
    .forEach((data) => {
      if (!data) {
        return
      }
      const { method, path, routes } = data

      const methodStr = colorEnabled ? `\x1b[32m${method}\x1b[0m` : method
      console.log(`${methodStr} ${' '.repeat(maxMethodLength - method.length)} ${path}`)

      if (!opts?.verbose) {
        return
      }

      routes.forEach(({ name }) => {
        console.log(`${' '.repeat(maxMethodLength + 3)} ${name}`)
      })
    })
}

export const getRouterName = <E extends Env>(app: Hono<E>): string => {
  app.router.match('GET', '/')
  return app.router.name
}

```
