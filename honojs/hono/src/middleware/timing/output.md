/Users/josh/Documents/GitHub/honojs/hono/src/middleware/timing/index.test.ts
```typescript
import { Hono } from '../../hono'
import { endTime, setMetric, startTime, timing } from '.'

describe('Server-Timing API', () => {
  const app = new Hono()

  const totalDescription = 'my total DescRipTion!'
  const name = 'sleep'
  const region = 'region'
  const regionDesc = 'europe-west3'

  app.use(
    '*',
    timing({
      totalDescription,
    })
  )
  app.get('/', (c) => c.text('/'))
  app.get('/api', async (c) => {
    startTime(c, name)
    await new Promise((r) => setTimeout(r, 30))
    endTime(c, name)

    return c.text('api!')
  })
  app.get('/cache', async (c) => {
    setMetric(c, region, regionDesc)

    return c.text('cache!')
  })

  const sub = new Hono()

  sub.use(timing())
  sub.get('/', (c) => c.text('sub'))
  app.route('/sub', sub)

  it('Should contain total duration', async () => {
    const res = await app.request('http://localhost/')
    expect(res).not.toBeNull()
    expect(res.headers.has('server-timing')).toBeTruthy()
    expect(res.headers.get('server-timing')?.includes('total;dur=')).toBeTruthy()
    expect(res.headers.get('server-timing')?.includes(totalDescription)).toBeTruthy()
  })

  it('Should contain value metrics', async () => {
    const res = await app.request('http://localhost/api')
    expect(res).not.toBeNull()
    expect(res.headers.has('server-timing')).toBeTruthy()
    expect(res.headers.get('server-timing')?.includes(`${name};dur=`)).toBeTruthy()
    expect(res.headers.get('server-timing')?.includes(name)).toBeTruthy()
  })

  it('Should contain value-less metrics', async () => {
    const res = await app.request('http://localhost/cache')
    expect(res).not.toBeNull()
    expect(res.headers.has('server-timing')).toBeTruthy()
    expect(
      res.headers.get('server-timing')?.includes(`${region};desc="${regionDesc}"`)
    ).toBeTruthy()
    expect(res.headers.get('server-timing')?.includes(region)).toBeTruthy()
    expect(res.headers.get('server-timing')?.includes(regionDesc)).toBeTruthy()
  })

  it('Should not be enabled if the main app has the timing middleware', async () => {
    const consoleWarnSpy = vi.spyOn(console, 'warn')
    const res = await app.request('/sub')
    expect(res.status).toBe(200)
    expect(res.headers.has('server-timing')).toBeTruthy()
    expect(res.headers.get('server-timing')?.includes(totalDescription)).toBeTruthy()
    expect(consoleWarnSpy).not.toHaveBeenCalled()
    consoleWarnSpy.mockRestore()
  })

  describe('Should handle crossOrigin setting', async () => {
    it('Should do nothing when crossOrigin is falsy', async () => {
      const crossOriginApp = new Hono()

      crossOriginApp.use(
        '*',
        timing({
          crossOrigin: false,
        })
      )

      crossOriginApp.get('/', (c) => c.text('/'))

      const res = await crossOriginApp.request('http://localhost/')

      expect(res).not.toBeNull()
      expect(res.headers.has('server-timing')).toBeTruthy()
      expect(res.headers.has('timing-allow-origin')).toBeFalsy()
    })

    it('Should set Timing-Allow-Origin to * when crossOrigin is true', async () => {
      const crossOriginApp = new Hono()

      crossOriginApp.use(
        '*',
        timing({
          crossOrigin: true,
        })
      )

      crossOriginApp.get('/', (c) => c.text('/'))

      const res = await crossOriginApp.request('http://localhost/')

      expect(res).not.toBeNull()
      expect(res.headers.has('server-timing')).toBeTruthy()
      expect(res.headers.has('timing-allow-origin')).toBeTruthy()
      expect(res.headers.get('timing-allow-origin')).toBe('*')
    })

    it('Should set Timing-Allow-Origin to the value of crossOrigin when it is a string', async () => {
      const crossOriginApp = new Hono()

      crossOriginApp.use(
        '*',
        timing({
          crossOrigin: 'https://example.com',
        })
      )

      crossOriginApp.get('/', (c) => c.text('/'))

      const res = await crossOriginApp.request('http://localhost/')

      expect(res).not.toBeNull()
      expect(res.headers.has('server-timing')).toBeTruthy()
      expect(res.headers.has('timing-allow-origin')).toBeTruthy()
      expect(res.headers.get('timing-allow-origin')).toBe('https://example.com')
    })

    it('Should set Timing-Allow-Origin to the return value of crossOrigin when it is a function', async () => {
      const crossOriginApp = new Hono()

      crossOriginApp.use(
        '*',
        timing({
          crossOrigin: (c) => c.req.header('origin') ?? '*',
        })
      )

      crossOriginApp.get('/', (c) => c.text('/'))

      const res = await crossOriginApp.request('http://localhost/', {
        headers: {
          origin: 'https://example.com',
        },
      })

      expect(res).not.toBeNull()
      expect(res.headers.has('server-timing')).toBeTruthy()
      expect(res.headers.has('timing-allow-origin')).toBeTruthy()
      expect(res.headers.get('timing-allow-origin')).toBe('https://example.com')
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/timing/index.ts
```typescript
import type { TimingVariables } from './timing'
export { TimingVariables }
export { timing, setMetric, startTime, endTime } from './timing'

declare module '../..' {
  interface ContextVariableMap extends TimingVariables {}
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/timing/timing.ts
````typescript
/**
 * @module
 * Server-Timing Middleware for Hono.
 */

import type { Context } from '../../context'
import type { MiddlewareHandler } from '../../types'
import '../../context'

export type TimingVariables = {
  metric?: {
    headers: string[]
    timers: Map<string, Timer>
  }
}

interface Timer {
  description?: string
  start: number
}

interface TimingOptions {
  total?: boolean
  enabled?: boolean | ((c: Context) => boolean)
  totalDescription?: string
  autoEnd?: boolean
  crossOrigin?: boolean | string | ((c: Context) => boolean | string)
}

const getTime = (): number => {
  try {
    return performance.now()
  } catch {}
  return Date.now()
}

/**
 * Server-Timing Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/timing}
 *
 * @param {TimingOptions} [config] - The options for the timing middleware.
 * @param {boolean} [config.total=true] - Show the total response time.
 * @param {boolean | ((c: Context) => boolean)} [config.enabled=true] - Whether timings should be added to the headers or not.
 * @param {string} [config.totalDescription=Total Response Time] - Description for the total response time.
 * @param {boolean} [config.autoEnd=true] - If `startTime()` should end automatically at the end of the request.
 * @param {boolean | string | ((c: Context) => boolean | string)} [config.crossOrigin=false] - The origin this timings header should be readable.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * // add the middleware to your router
 * app.use(timing());
 *
 * app.get('/', async (c) => {
 *   // add custom metrics
 *   setMetric(c, 'region', 'europe-west3')
 *
 *   // add custom metrics with timing, must be in milliseconds
 *   setMetric(c, 'custom', 23.8, 'My custom Metric')
 *
 *   // start a new timer
 *   startTime(c, 'db');
 *
 *   const data = await db.findMany(...);
 *
 *   // end the timer
 *   endTime(c, 'db');
 *
 *   return c.json({ response: data });
 * });
 * ```
 */
export const timing = (config?: TimingOptions): MiddlewareHandler => {
  const options: TimingOptions = {
    total: true,
    enabled: true,
    totalDescription: 'Total Response Time',
    autoEnd: true,
    crossOrigin: false,
    ...config,
  }
  return async function timing(c, next) {
    const headers: string[] = []
    const timers = new Map<string, Timer>()

    if (c.get('metric')) {
      return await next()
    }

    c.set('metric', { headers, timers })

    if (options.total) {
      startTime(c, 'total', options.totalDescription)
    }
    await next()

    if (options.total) {
      endTime(c, 'total')
    }

    if (options.autoEnd) {
      timers.forEach((_, key) => endTime(c, key))
    }

    const enabled = typeof options.enabled === 'function' ? options.enabled(c) : options.enabled

    if (enabled) {
      c.res.headers.append('Server-Timing', headers.join(','))

      const crossOrigin =
        typeof options.crossOrigin === 'function' ? options.crossOrigin(c) : options.crossOrigin

      if (crossOrigin) {
        c.res.headers.append(
          'Timing-Allow-Origin',
          typeof crossOrigin === 'string' ? crossOrigin : '*'
        )
      }
    }
  }
}

interface SetMetric {
  (c: Context, name: string, value: number, description?: string, precision?: number): void

  (c: Context, name: string, description?: string): void
}

/**
 * Set a metric for the timing middleware.
 *
 * @param {Context} c - The context of the request.
 * @param {string} name - The name of the metric.
 * @param {number | string} [valueDescription] - The value or description of the metric.
 * @param {string} [description] - The description of the metric.
 * @param {number} [precision] - The precision of the metric value.
 *
 * @example
 * ```ts
 * setMetric(c, 'region', 'europe-west3')
 * setMetric(c, 'custom', 23.8, 'My custom Metric')
 * ```
 */
export const setMetric: SetMetric = (
  c: Context,
  name: string,
  valueDescription: number | string | undefined,
  description?: string,
  precision?: number
) => {
  const metrics = c.get('metric')
  if (!metrics) {
    console.warn('Metrics not initialized! Please add the `timing()` middleware to this route!')
    return
  }
  if (typeof valueDescription === 'number') {
    const dur = valueDescription.toFixed(precision || 1)

    const metric = description ? `${name};dur=${dur};desc="${description}"` : `${name};dur=${dur}`

    metrics.headers.push(metric)
  } else {
    // Value-less metric
    const metric = valueDescription ? `${name};desc="${valueDescription}"` : `${name}`

    metrics.headers.push(metric)
  }
}

/**
 * Start a timer for the timing middleware.
 *
 * @param {Context} c - The context of the request.
 * @param {string} name - The name of the timer.
 * @param {string} [description] - The description of the timer.
 *
 * @example
 * ```ts
 * startTime(c, 'db')
 * ```
 */
export const startTime = (c: Context, name: string, description?: string) => {
  const metrics = c.get('metric')
  if (!metrics) {
    console.warn('Metrics not initialized! Please add the `timing()` middleware to this route!')
    return
  }
  metrics.timers.set(name, { description, start: getTime() })
}

/**
 * End a timer for the timing middleware.
 *
 * @param {Context} c - The context of the request.
 * @param {string} name - The name of the timer.
 * @param {number} [precision] - The precision of the timer value.
 *
 * @example
 * ```ts
 * endTime(c, 'db')
 * ```
 */
export const endTime = (c: Context, name: string, precision?: number) => {
  const metrics = c.get('metric')
  if (!metrics) {
    console.warn('Metrics not initialized! Please add the `timing()` middleware to this route!')
    return
  }
  const timer = metrics.timers.get(name)
  if (!timer) {
    console.warn(`Timer "${name}" does not exist!`)
    return
  }
  const { description, start } = timer

  const duration = getTime() - start

  setMetric(c, name, duration, description, precision)
  metrics.timers.delete(name)
}

````
