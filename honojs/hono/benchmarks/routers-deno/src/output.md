/Users/josh/Documents/GitHub/honojs/hono/benchmarks/routers-deno/src/bench.mts
```
import { run, bench, group } from 'npm:mitata'
import { findMyWayRouter } from './find-my-way.mts'
import { regExpRouter, trieRouter, patternRouter } from './hono.mts'
import { koaRouter } from './koa-router.mts'
import { koaTreeRouter } from './koa-tree-router.mts'
import { medleyRouter } from './medley-router.mts'
import type { Route, RouterInterface } from './tool.mts'
import { trekRouter } from './trek-router.mts'

const routers: RouterInterface[] = [
  regExpRouter,
  trieRouter,
  patternRouter,
  medleyRouter,
  findMyWayRouter,
  koaTreeRouter,
  trekRouter,
  koaRouter,
]

medleyRouter.match({ method: 'GET', path: '/user' })

const routes: (Route & { name: string })[] = [
  {
    name: 'short static',
    method: 'GET',
    path: '/user',
  },
  {
    name: 'static with same radix',
    method: 'GET',
    path: '/user/comments',
  },
  {
    name: 'dynamic route',
    method: 'GET',
    path: '/user/lookup/username/hey',
  },
  {
    name: 'mixed static dynamic',
    method: 'GET',
    path: '/event/abcd1234/comments',
  },
  {
    name: 'post',
    method: 'POST',
    path: '/event/abcd1234/comment',
  },
  {
    name: 'long static',
    method: 'GET',
    path: '/very/deeply/nested/route/hello/there',
  },
  {
    name: 'wildcard',
    method: 'GET',
    path: '/static/index.html',
  },
]

for (const route of routes) {
  group(`${route.name} - ${route.method} ${route.path}`, () => {
    for (const router of routers) {
      bench(router.name, async () => {
        router.match(route)
      })
    }
  })
}

group('all together', () => {
  for (const router of routers) {
    bench(router.name, async () => {
      for (const route of routes) {
        router.match(route)
      }
    })
  }
})

await run()

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/routers-deno/src/find-my-way.mts
```
import type { HTTPMethod } from 'npm:find-my-way'
import findMyWay from 'npm:find-my-way'
import type { RouterInterface } from './tool.mts'
import { routes, handler } from './tool.mts'

const name = 'find-my-way'
const router = findMyWay()

for (const route of routes) {
  router.on(route.method as HTTPMethod, route.path, handler)
}

export const findMyWayRouter: RouterInterface = {
  name,
  match: (route) => {
    router.find(route.method as HTTPMethod, route.path)
  },
}

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/routers-deno/src/hono.mts
```
import type { Router } from '../../../src/router.ts'
import { RegExpRouter } from '../../../src/router/reg-exp-router/index.ts'
import { TrieRouter } from '../../../src/router/trie-router/index.ts'
import { PatternRouter } from '../../../src/router/pattern-router/index.ts'
import type { RouterInterface } from './tool.mts'
import { routes, handler } from './tool.mts'

const createHonoRouter = (name: string, router: Router<unknown>): RouterInterface => {
  for (const route of routes) {
    router.add(route.method, route.path, handler)
  }
  return {
    name: `Hono ${name}`,
    match: (route) => {
      router.match(route.method, route.path)
    },
  }
}

export const regExpRouter = createHonoRouter('RegExpRouter', new RegExpRouter())
export const trieRouter = createHonoRouter('TrieRouter', new TrieRouter())
export const patternRouter = createHonoRouter('PatternRouter', new PatternRouter())

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/routers-deno/src/koa-router.mts
```
import KoaRouter from 'npm:koa-router'
import type { RouterInterface } from './tool.mts'
import { routes, handler } from './tool.mts'

const name = 'koa-router'
const router = new KoaRouter()

for (const route of routes) {
  if (route.method === 'GET') {
    router.get(route.path.replace('*', '(.*)'), handler)
  } else {
    router.post(route.path, handler)
  }
}

export const koaRouter: RouterInterface = {
  name,
  match: (route) => {
    router.match(route.path, route.method) // only matching
  },
}

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/routers-deno/src/koa-tree-router.mts
```
import KoaRouter from 'npm:koa-tree-router'
import type { RouterInterface } from './tool.mts'
import { routes, handler } from './tool.mts'

const name = 'koa-tree-router'
const router = new KoaRouter()

for (const route of routes) {
  router.on(route.method, route.path.replace('*', '*foo'), handler)
}

export const koaTreeRouter: RouterInterface = {
  name,
  match: (route) => {
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    router.find(route.method, route.path)
  },
}

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/routers-deno/src/medley-router.mts
```
import Router from 'npm:@medley/router'
import type { RouterInterface } from './tool.mts'
import { routes, handler } from './tool.mts'

const name = '@medley/router'
const router = new Router()

for (const route of routes) {
  const store = router.register(route.path)
  store[route.method] = handler
}

export const medleyRouter: RouterInterface = {
  name,
  match: (route) => {
    const match = router.find(route.path)
    match.store[route.method] // get handler
  },
}

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/routers-deno/src/tool.mts
```
export const handler = () => {}

export type Route = {
  method: 'GET' | 'POST'
  path: string
}

export interface RouterInterface {
  name: string
  match: (route: Route) => unknown
}

export const routes: Route[] = [
  { method: 'GET', path: '/user' },
  { method: 'GET', path: '/user/comments' },
  { method: 'GET', path: '/user/avatar' },
  { method: 'GET', path: '/user/lookup/username/:username' },
  { method: 'GET', path: '/user/lookup/email/:address' },
  { method: 'GET', path: '/event/:id' },
  { method: 'GET', path: '/event/:id/comments' },
  { method: 'POST', path: '/event/:id/comment' },
  { method: 'GET', path: '/map/:location/events' },
  { method: 'GET', path: '/status' },
  { method: 'GET', path: '/very/deeply/nested/route/hello/there' },
  { method: 'GET', path: '/static/*' },
]

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/routers-deno/src/trek-router.mts
```
import TrekRouter from 'npm:trek-router'
import type { RouterInterface } from './tool.mts'
import { routes, handler } from './tool.mts'

const name = 'trek-router'

const router = new TrekRouter()
for (const route of routes) {
  router.add(route.method, route.path, handler())
}

export const trekRouter: RouterInterface = {
  name,
  match: (route) => {
    router.find(route.method, route.path)
  },
}

```
