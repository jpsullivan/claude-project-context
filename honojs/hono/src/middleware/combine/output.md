/Users/josh/Documents/GitHub/honojs/hono/src/middleware/combine/index.test.ts
```typescript
import { Hono } from '../../hono'
import type { MiddlewareHandler } from '../../types'
import { every, except, some } from '.'

const nextMiddleware: MiddlewareHandler = async (_, next) => await next()

describe('some', () => {
  let app: Hono

  beforeEach(() => {
    app = new Hono()
  })

  it('Should call only the first middleware', async () => {
    const middleware1 = vi.fn(nextMiddleware)
    const middleware2 = vi.fn(nextMiddleware)

    app.use('/', some(middleware1, middleware2))
    app.get('/', (c) => {
      return c.text('Hello World')
    })
    const res = await app.request('http://localhost/')

    expect(middleware1).toBeCalled()
    expect(middleware2).not.toBeCalled()
    expect(await res.text()).toBe('Hello World')
  })

  it('Should try to call the second middleware if the first one throws an error', async () => {
    const middleware1 = () => {
      throw new Error('Error')
    }
    const middleware2 = vi.fn(nextMiddleware)

    app.use('/', some(middleware1, middleware2))
    app.get('/', (c) => {
      return c.text('Hello World')
    })
    const res = await app.request('http://localhost/')

    expect(middleware2).toBeCalled()
    expect(await res.text()).toBe('Hello World')
  })

  it('Should try to call the second middleware if the first one returns false', async () => {
    const middleware1 = () => false
    const middleware2 = vi.fn(nextMiddleware)

    app.use('/', some(middleware1, middleware2))
    app.get('/', (c) => {
      return c.text('Hello World')
    })
    const res = await app.request('http://localhost/')

    expect(middleware2).toBeCalled()
    expect(await res.text()).toBe('Hello World')
  })

  it('Should throw last error if all middleware throw an error', async () => {
    const middleware1 = () => {
      throw new Error('Error1')
    }
    const middleware2 = () => {
      throw new Error('Error2')
    }

    app.use('/', some(middleware1, middleware2))
    app.get('/', (c) => {
      return c.text('Hello World')
    })
    app.onError((error, c) => {
      return c.text(error.message)
    })
    const res = await app.request('http://localhost/')

    expect(await res.text()).toBe('Error2')
  })

  it('Should throw error if all middleware return false', async () => {
    const middleware1 = () => false
    const middleware2 = () => false

    app.use('/', some(middleware1, middleware2))
    app.get('/', (c) => {
      return c.text('Hello World')
    })
    app.onError((_, c) => {
      return c.text('oops')
    })
    const res = await app.request('http://localhost/')

    expect(await res.text()).toBe('oops')
  })

  it('Should not call skipped middleware even if an error is thrown', async () => {
    const middleware1: MiddlewareHandler = async (c, next) => {
      await next()
    }
    const middleware2 = vi.fn(() => true)

    app.use(
      '/',
      every(some(middleware1, middleware2), () => {
        throw new Error('Error')
      })
    )
    app.get('/', (c) => c.text('OK'))
    app.onError((_, c) => {
      return c.text('oops')
    })
    const res = await app.request('http://localhost/')

    expect(middleware2).not.toBeCalled()
    expect(await res.text()).toBe('oops')
  })

  it('Should not call skipped middleware even if an error is thrown with returning truthy value middleware', async () => {
    const middleware1 = () => true
    const middleware2 = vi.fn(() => true)

    app.use(
      '/',
      every(some(middleware1, middleware2), () => {
        throw new Error('Error')
      })
    )
    app.get('/', (c) => c.text('OK'))
    app.onError((_, c) => {
      return c.text('oops')
    })
    const res = await app.request('http://localhost/')

    expect(middleware2).not.toBeCalled()
    expect(await res.text()).toBe('oops')
  })
})

describe('every', () => {
  let app: Hono

  beforeEach(() => {
    app = new Hono()
  })

  it('Should call all middleware', async () => {
    const middleware1 = vi.fn(nextMiddleware)
    const middleware2 = vi.fn(nextMiddleware)

    app.use('/', every(middleware1, middleware2))
    app.get('/', (c) => {
      return c.text('Hello World')
    })
    const res = await app.request('http://localhost/')

    expect(middleware1).toBeCalled()
    expect(middleware2).toBeCalled()
    expect(await res.text()).toBe('Hello World')
  })

  it('Should throw error if any middleware throws an error', async () => {
    const middleware1 = () => {
      throw new Error('Error1')
    }
    const middleware2 = vi.fn(nextMiddleware)

    app.use('/', every(middleware1, middleware2))
    app.get('/', (c) => {
      return c.text('Hello World')
    })
    app.onError((error, c) => {
      return c.text(error.message)
    })
    const res = await app.request('http://localhost/')

    expect(await res.text()).toBe('Error1')
    expect(middleware2).not.toBeCalled()
  })

  it('Should throw error if any middleware returns false', async () => {
    const middleware1 = () => false
    const middleware2 = vi.fn(nextMiddleware)

    app.use('/', every(middleware1, middleware2))
    app.get('/', (c) => {
      return c.text('Hello World')
    })
    app.onError((_, c) => {
      return c.text('oops')
    })
    const res = await app.request('http://localhost/')

    expect(await res.text()).toBe('oops')
    expect(middleware2).not.toBeCalled()
  })

  it('Should return the same response a middleware returns if it short-circuits the chain', async () => {
    const middleware1: MiddlewareHandler = async (c) => {
      return c.text('Hello Middleware 1')
    }
    const middleware2 = vi.fn(nextMiddleware)

    app.use('/', every(middleware1, middleware2))
    app.get('/', (c) => {
      return c.text('Hello World')
    })
    const res = await app.request('http://localhost/')

    expect(await res.text()).toBe('Hello Middleware 1')
    expect(middleware2).not.toBeCalled()
  })

  it('Should pass the path params to middlewares', async () => {
    const app = new Hono()
    app.use('*', nextMiddleware)
    const paramMiddleware: MiddlewareHandler = async (c) => {
      return c.json(c.req.param(), 200)
    }

    app.use('/:id', every(paramMiddleware))
    app.get('/:id', (c) => {
      return c.text('Hello World')
    })

    const res = await app.request('http://localhost/123')
    expect(await res.json()).toEqual({ id: '123' })
  })
})

describe('except', () => {
  let app: Hono

  beforeEach(() => {
    app = new Hono()
  })

  it('Should call all middleware, except the one that matches the condition', async () => {
    const middleware1 = vi.fn(nextMiddleware)
    const middleware2 = vi.fn(nextMiddleware)

    app.use('*', except('/maintenance', middleware1, middleware2))
    app.get('/maintenance', (c) => {
      return c.text('Hello Maintenance')
    })
    app.get('*', (c) => {
      return c.redirect('/maintenance')
    })
    let res = await app.request('http://localhost/')

    expect(middleware1).toBeCalled()
    expect(middleware2).toBeCalled()
    expect(res.headers.get('location')).toBe('/maintenance')

    middleware1.mockClear()
    middleware2.mockClear()
    res = await app.request('http://localhost/maintenance')

    expect(middleware1).not.toBeCalled()
    expect(middleware2).not.toBeCalled()
    expect(await res.text()).toBe('Hello Maintenance')
  })

  it('Should call all middleware, except the one that matches some of the conditions', async () => {
    const middleware1 = vi.fn(nextMiddleware)
    const middleware2 = vi.fn(nextMiddleware)

    app.use('*', except(['/maintenance', '/public/users/:id'], middleware1, middleware2))
    app.get('/maintenance', (c) => {
      return c.text('Hello Maintenance')
    })
    app.get('/public/users/:id', (c) => {
      return c.text(`Hello Public User ${c.req.param('id')}`)
    })
    app.get('/secret', (c) => {
      return c.text('Hello Secret')
    })
    let res = await app.request('http://localhost/secret')

    expect(middleware1).toBeCalled()
    expect(middleware2).toBeCalled()
    expect(await res.text()).toBe('Hello Secret')

    middleware1.mockClear()
    middleware2.mockClear()
    res = await app.request('http://localhost/maintenance')

    expect(middleware1).not.toBeCalled()
    expect(middleware2).not.toBeCalled()
    expect(await res.text()).toBe('Hello Maintenance')

    middleware1.mockClear()
    middleware2.mockClear()
    res = await app.request('http://localhost/public/users/123')

    expect(middleware1).not.toBeCalled()
    expect(middleware2).not.toBeCalled()
    expect(await res.text()).toBe('Hello Public User 123')
  })

  it('Should call all middleware, except the one that matches some of the condition function', async () => {
    const middleware1 = vi.fn(nextMiddleware)
    const middleware2 = vi.fn(nextMiddleware)

    app.use(
      '*',
      except(['/maintenance', (c) => !!c.req.path.match(/public/)], middleware1, middleware2)
    )
    app.get('/maintenance', (c) => {
      return c.text('Hello Maintenance')
    })
    app.get('/public/users/:id', (c) => {
      return c.text(`Hello Public User ${c.req.param('id')}`)
    })
    app.get('/secret', (c) => {
      return c.text('Hello Secret')
    })
    let res = await app.request('http://localhost/secret')

    expect(middleware1).toBeCalled()
    expect(middleware2).toBeCalled()
    expect(await res.text()).toBe('Hello Secret')

    middleware1.mockClear()
    middleware2.mockClear()
    res = await app.request('http://localhost/maintenance')

    expect(middleware1).not.toBeCalled()
    expect(middleware2).not.toBeCalled()
    expect(await res.text()).toBe('Hello Maintenance')

    middleware1.mockClear()
    middleware2.mockClear()
    res = await app.request('http://localhost/public/users/123')

    expect(middleware1).not.toBeCalled()
    expect(middleware2).not.toBeCalled()
    expect(await res.text()).toBe('Hello Public User 123')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/combine/index.ts
````typescript
/**
 * @module
 * Combine Middleware for Hono.
 */

import { compose } from '../../compose'
import type { Context } from '../../context'
import { METHOD_NAME_ALL } from '../../router'
import { TrieRouter } from '../../router/trie-router'
import type { MiddlewareHandler, Next } from '../../types'

type Condition = (c: Context) => boolean

/**
 * Create a composed middleware that runs the first middleware that returns true.
 *
 * @param middleware - An array of MiddlewareHandler or Condition functions.
 * Middleware is applied in the order it is passed, and if any middleware exits without returning
 * an exception first, subsequent middleware will not be executed.
 * You can also pass a condition function that returns a boolean value. If returns true
 * the evaluation will be halted, and rest of the middleware will not be executed.
 * @returns A composed middleware.
 *
 * @example
 * ```ts
 * import { some } from 'hono/combine'
 * import { bearerAuth } from 'hono/bearer-auth'
 * import { myRateLimit } from '@/rate-limit'
 *
 * // If client has a valid token, then skip rate limiting.
 * // Otherwise, apply rate limiting.
 * app.use('/api/*', some(
 *   bearerAuth({ token }),
 *   myRateLimit({ limit: 100 }),
 * ));
 * ```
 */
export const some = (...middleware: (MiddlewareHandler | Condition)[]): MiddlewareHandler => {
  return async function some(c, next) {
    let isNextCalled = false
    const wrappedNext = () => {
      isNextCalled = true
      return next()
    }

    let lastError: unknown
    for (const handler of middleware) {
      try {
        const result = await handler(c, wrappedNext)
        if (result === true && !c.finalized) {
          await wrappedNext()
        } else if (result === false) {
          lastError = new Error('No successful middleware found')
          continue
        }
        lastError = undefined
        break
      } catch (error) {
        lastError = error
        if (isNextCalled) {
          break
        }
      }
    }
    if (lastError) {
      throw lastError
    }
  }
}

/**
 * Create a composed middleware that runs all middleware and throws an error if any of them fail.
 *
 * @param middleware - An array of MiddlewareHandler or Condition functions.
 * Middleware is applied in the order it is passed, and if any middleware throws an error,
 * subsequent middleware will not be executed.
 * You can also pass a condition function that returns a boolean value. If returns false
 * the evaluation will be halted, and rest of the middleware will not be executed.
 * @returns A composed middleware.
 *
 * @example
 * ```ts
 * import { some, every } from 'hono/combine'
 * import { bearerAuth } from 'hono/bearer-auth'
 * import { myCheckLocalNetwork } from '@/check-local-network'
 * import { myRateLimit } from '@/rate-limit'
 *
 * // If client is in local network, then skip authentication and rate limiting.
 * // Otherwise, apply authentication and rate limiting.
 * app.use('/api/*', some(
 *   myCheckLocalNetwork(),
 *   every(
 *     bearerAuth({ token }),
 *     myRateLimit({ limit: 100 }),
 *   ),
 * ));
 * ```
 */
export const every = (...middleware: (MiddlewareHandler | Condition)[]): MiddlewareHandler => {
  return async function every(c, next) {
    const currentRouteIndex = c.req.routeIndex
    await compose(
      middleware.map((m) => [
        [
          async (c: Context, next: Next) => {
            c.req.routeIndex = currentRouteIndex // should be unchanged in this context
            const res = await m(c, next)
            if (res === false) {
              throw new Error('Unmet condition')
            }
            return res
          },
        ],
      ])
    )(c, next)
  }
}

/**
 * Create a composed middleware that runs all middleware except when the condition is met.
 *
 * @param condition - A string or Condition function.
 * If there are multiple targets to match any of them, they can be passed as an array.
 * If a string is passed, it will be treated as a path pattern to match.
 * If a Condition function is passed, it will be evaluated against the request context.
 * @param middleware - A composed middleware
 *
 * @example
 * ```ts
 * import { except } from 'hono/combine'
 * import { bearerAuth } from 'hono/bearer-auth
 *
 * // If client is accessing public API, then skip authentication.
 * // Otherwise, require a valid token.
 * app.use('/api/*', except(
 *   '/api/public/*',
 *   bearerAuth({ token }),
 * ));
 * ```
 */
export const except = (
  condition: string | Condition | (string | Condition)[],
  ...middleware: MiddlewareHandler[]
): MiddlewareHandler => {
  let router: TrieRouter<true> | undefined = undefined
  const conditions = (Array.isArray(condition) ? condition : [condition])
    .map((condition) => {
      if (typeof condition === 'string') {
        router ||= new TrieRouter()
        router.add(METHOD_NAME_ALL, condition, true)
      } else {
        return condition
      }
    })
    .filter(Boolean) as Condition[]

  if (router) {
    conditions.unshift((c: Context) => !!router?.match(METHOD_NAME_ALL, c.req.path)?.[0]?.[0]?.[0])
  }

  const handler = some((c: Context) => conditions.some((cond) => cond(c)), every(...middleware))
  return async function except(c, next) {
    await handler(c, next)
  }
}

````
