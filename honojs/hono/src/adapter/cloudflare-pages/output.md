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
