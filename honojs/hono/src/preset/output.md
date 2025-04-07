/Users/josh/Documents/GitHub/honojs/hono/src/preset/quick.test.ts
```typescript
import { getRouterName } from '../helper/dev'
import { Hono } from './quick'

describe('hono/quick preset', () => {
  it('Should have SmartRouter + LinearRouter', async () => {
    const app = new Hono()
    expect(getRouterName(app)).toBe('SmartRouter + LinearRouter')
  })
})

describe('Generics for Bindings and Variables', () => {
  interface CloudflareBindings {
    MY_VARIABLE: string
  }

  it('Should not throw type errors', () => {
    // @ts-expect-error Bindings should extend object
    new Hono<{
      Bindings: number
    }>()

    const appWithInterface = new Hono<{
      Bindings: CloudflareBindings
    }>()

    appWithInterface.get('/', (c) => {
      expectTypeOf(c.env.MY_VARIABLE).toMatchTypeOf<string>()
      return c.text('/')
    })

    const appWithType = new Hono<{
      Bindings: {
        foo: string
      }
    }>()

    appWithType.get('/', (c) => {
      expectTypeOf(c.env.foo).toMatchTypeOf<string>()
      return c.text('Hello Hono!')
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/preset/quick.ts
```typescript
/**
 * @module
 * The preset that uses `LinearRouter`.
 */

import { HonoBase } from '../hono-base'
import type { HonoOptions } from '../hono-base'
import { LinearRouter } from '../router/linear-router'
import { SmartRouter } from '../router/smart-router'
import { TrieRouter } from '../router/trie-router'
import type { BlankEnv, BlankSchema, Env, Schema } from '../types'

export class Hono<
  E extends Env = BlankEnv,
  S extends Schema = BlankSchema,
  BasePath extends string = '/'
> extends HonoBase<E, S, BasePath> {
  constructor(options: HonoOptions<E> = {}) {
    super(options)
    this.router = new SmartRouter({
      routers: [new LinearRouter(), new TrieRouter()],
    })
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/preset/tiny.test.ts
```typescript
import { getRouterName } from '../helper/dev'
import { Hono } from './tiny'

describe('hono/tiny preset', () => {
  it('Should have PatternRouter', async () => {
    const app = new Hono()
    expect(getRouterName(app)).toBe('PatternRouter')
  })
})

describe('Generics for Bindings and Variables', () => {
  interface CloudflareBindings {
    MY_VARIABLE: string
  }

  it('Should not throw type errors', () => {
    // @ts-expect-error Bindings should extend object
    new Hono<{
      Bindings: number
    }>()

    const appWithInterface = new Hono<{
      Bindings: CloudflareBindings
    }>()

    appWithInterface.get('/', (c) => {
      expectTypeOf(c.env.MY_VARIABLE).toMatchTypeOf<string>()
      return c.text('/')
    })

    const appWithType = new Hono<{
      Bindings: {
        foo: string
      }
    }>()

    appWithType.get('/', (c) => {
      expectTypeOf(c.env.foo).toMatchTypeOf<string>()
      return c.text('Hello Hono!')
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/preset/tiny.ts
```typescript
/**
 * @module
 * The preset that uses `PatternRouter`.
 */

import { HonoBase } from '../hono-base'
import type { HonoOptions } from '../hono-base'
import { PatternRouter } from '../router/pattern-router'
import type { BlankEnv, BlankSchema, Env, Schema } from '../types'

export class Hono<
  E extends Env = BlankEnv,
  S extends Schema = BlankSchema,
  BasePath extends string = '/'
> extends HonoBase<E, S, BasePath> {
  constructor(options: HonoOptions<E> = {}) {
    super(options)
    this.router = new PatternRouter()
  }
}

```
