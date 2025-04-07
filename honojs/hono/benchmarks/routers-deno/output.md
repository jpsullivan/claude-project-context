/Users/josh/Documents/GitHub/honojs/hono/benchmarks/routers-deno/README.md
````
# Router benchmarks

Benchmark of the most commonly used HTTP routers.

Tested routes:

- [find-my-way](https://github.com/delvedor/find-my-way)
- [koa-router](https://github.com/alexmingoia/koa-router)
- [koa-tree-router](https://github.com/steambap/koa-tree-router)
- [trek-router](https://www.npmjs.com/package/trek-router)
- [@medley/router](https://www.npmjs.com/package/@medley/router)
- [Hono RegExpRouter](https://github.com/honojs/hono)
- [Hono TrieRouter](https://github.com/honojs/hono)

For Deno:

```
deno run --allow-read --allow-run src/bench.mts
```

This project is heavily impaired by [delvedor/router-benchmark](https://github.com/delvedor/router-benchmark)

## License

MIT

````
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/routers-deno/deno.json
```json
{
  "imports": {
    "npm/": "https://unpkg.com/"
  }
}
```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/routers-deno/deno.lock
```
{
  "version": "2",
  "remote": {},
  "npm": {
    "specifiers": {
      "@medley/router": "@medley/router@0.2.1",
      "find-my-way": "find-my-way@7.6.0",
      "koa-router": "koa-router@12.0.0",
      "koa-tree-router": "koa-tree-router@0.12.1",
      "mitata": "mitata@0.1.6",
      "trek-router": "trek-router@1.2.0"
    },
    "packages": {
      "@medley/router@0.2.1": {
        "integrity": "sha512-mdvS1spIxmZoUbTdYmWknHtwm72WwrGNoQCDd4RTvcXJ9G6XThxeC3g+cpOf6Fw6vIERHt50pYiJpsk5XTJQ5w==",
        "dependencies": {
          "object-treeify": "object-treeify@1.1.33"
        }
      },
      "@types/accepts@1.3.5": {
        "integrity": "sha512-jOdnI/3qTpHABjM5cx1Hc0sKsPoYCp+DP/GJRGtDlPd7fiV9oXGGIcjW/ZOxLIvjGz8MA+uMZI9metHlgqbgwQ==",
        "dependencies": {
          "@types/node": "@types/node@18.16.0"
        }
      },
      "@types/body-parser@1.19.2": {
        "integrity": "sha512-ALYone6pm6QmwZoAgeyNksccT9Q4AWZQ6PvfwR37GT6r6FWUPguq6sUmNGSMV2Wr761oQoBxwGGa6DR5o1DC9g==",
        "dependencies": {
          "@types/connect": "@types/connect@3.4.35",
          "@types/node": "@types/node@18.16.0"
        }
      },
      "@types/connect@3.4.35": {
        "integrity": "sha512-cdeYyv4KWoEgpBISTxWvqYsVy444DOqehiF3fM3ne10AmJ62RSyNkUnxMJXHQWRQQX2eR94m5y1IZyDwBjV9FQ==",
        "dependencies": {
          "@types/node": "@types/node@18.16.0"
        }
      },
      "@types/content-disposition@0.5.5": {
        "integrity": "sha512-v6LCdKfK6BwcqMo+wYW05rLS12S0ZO0Fl4w1h4aaZMD7bqT3gVUns6FvLJKGZHQmYn3SX55JWGpziwJRwVgutA==",
        "dependencies": {}
      },
      "@types/cookies@0.7.7": {
        "integrity": "sha512-h7BcvPUogWbKCzBR2lY4oqaZbO3jXZksexYJVFvkrFeLgbZjQkU4x8pRq6eg2MHXQhY0McQdqmmsxRWlVAHooA==",
        "dependencies": {
          "@types/connect": "@types/connect@3.4.35",
          "@types/express": "@types/express@4.17.17",
          "@types/keygrip": "@types/keygrip@1.0.2",
          "@types/node": "@types/node@18.16.0"
        }
      },
      "@types/express-serve-static-core@4.17.33": {
        "integrity": "sha512-TPBqmR/HRYI3eC2E5hmiivIzv+bidAfXofM+sbonAGvyDhySGw9/PQZFt2BLOrjUUR++4eJVpx6KnLQK1Fk9tA==",
        "dependencies": {
          "@types/node": "@types/node@18.16.0",
          "@types/qs": "@types/qs@6.9.7",
          "@types/range-parser": "@types/range-parser@1.2.4"
        }
      },
      "@types/express@4.17.17": {
        "integrity": "sha512-Q4FmmuLGBG58btUnfS1c1r/NQdlp3DMfGDGig8WhfpA2YRUtEkxAjkZb0yvplJGYdF1fsQ81iMDcH24sSCNC/Q==",
        "dependencies": {
          "@types/body-parser": "@types/body-parser@1.19.2",
          "@types/express-serve-static-core": "@types/express-serve-static-core@4.17.33",
          "@types/qs": "@types/qs@6.9.7",
          "@types/serve-static": "@types/serve-static@1.15.1"
        }
      },
      "@types/http-assert@1.5.3": {
        "integrity": "sha512-FyAOrDuQmBi8/or3ns4rwPno7/9tJTijVW6aQQjK02+kOQ8zmoNg2XJtAuQhvQcy1ASJq38wirX5//9J1EqoUA==",
        "dependencies": {}
      },
      "@types/http-errors@2.0.1": {
        "integrity": "sha512-/K3ds8TRAfBvi5vfjuz8y6+GiAYBZ0x4tXv1Av6CWBWn0IlADc+ZX9pMq7oU0fNQPnBwIZl3rmeLp6SBApbxSQ==",
        "dependencies": {}
      },
      "@types/keygrip@1.0.2": {
        "integrity": "sha512-GJhpTepz2udxGexqos8wgaBx4I/zWIDPh/KOGEwAqtuGDkOUJu5eFvwmdBX4AmB8Odsr+9pHCQqiAqDL/yKMKw==",
        "dependencies": {}
      },
      "@types/koa-compose@3.2.5": {
        "integrity": "sha512-B8nG/OoE1ORZqCkBVsup/AKcvjdgoHnfi4pZMn5UwAPCbhk/96xyv284eBYW8JlQbQ7zDmnpFr68I/40mFoIBQ==",
        "dependencies": {
          "@types/koa": "@types/koa@2.13.6"
        }
      },
      "@types/koa@2.13.6": {
        "integrity": "sha512-diYUfp/GqfWBAiwxHtYJ/FQYIXhlEhlyaU7lB/bWQrx4Il9lCET5UwpFy3StOAohfsxxvEQ11qIJgT1j2tfBvw==",
        "dependencies": {
          "@types/accepts": "@types/accepts@1.3.5",
          "@types/content-disposition": "@types/content-disposition@0.5.5",
          "@types/cookies": "@types/cookies@0.7.7",
          "@types/http-assert": "@types/http-assert@1.5.3",
          "@types/http-errors": "@types/http-errors@2.0.1",
          "@types/keygrip": "@types/keygrip@1.0.2",
          "@types/koa-compose": "@types/koa-compose@3.2.5",
          "@types/node": "@types/node@18.16.0"
        }
      },
      "@types/mime@3.0.1": {
        "integrity": "sha512-Y4XFY5VJAuw0FgAqPNd6NNoV44jbq9Bz2L7Rh/J6jLTiHBSBJa9fxqQIvkIld4GsoDOcCbvzOUAbLPsSKKg+uA==",
        "dependencies": {}
      },
      "@types/node@18.16.0": {
        "integrity": "sha512-BsAaKhB+7X+H4GnSjGhJG9Qi8Tw+inU9nJDwmD5CgOmBLEI6ArdhikpLX7DjbjDRDTbqZzU2LSQNZg8WGPiSZQ==",
        "dependencies": {}
      },
      "@types/qs@6.9.7": {
        "integrity": "sha512-FGa1F62FT09qcrueBA6qYTrJPVDzah9a+493+o2PCXsesWHIn27G98TsSMs3WPNbZIEj4+VJf6saSFpvD+3Zsw==",
        "dependencies": {}
      },
      "@types/range-parser@1.2.4": {
        "integrity": "sha512-EEhsLsD6UsDM1yFhAvy0Cjr6VwmpMWqFBCb9w07wVugF7w9nfajxLuVmngTIpgS6svCnm6Vaw+MZhoDCKnOfsw==",
        "dependencies": {}
      },
      "@types/serve-static@1.15.1": {
        "integrity": "sha512-NUo5XNiAdULrJENtJXZZ3fHtfMolzZwczzBbnAeBbqBwG+LaG6YaJtuwzwGSQZ2wsCrxjEhNNjAkKigy3n8teQ==",
        "dependencies": {
          "@types/mime": "@types/mime@3.0.1",
          "@types/node": "@types/node@18.16.0"
        }
      },
      "depd@2.0.0": {
        "integrity": "sha512-g7nH6P6dyDioJogAAGprGpCtVImJhpPk/roCzdb3fIh61/s/nPsfR6onyMwkCAR/OlC3yBC0lESvUoQEAssIrw==",
        "dependencies": {}
      },
      "fast-decode-uri-component@1.0.1": {
        "integrity": "sha512-WKgKWg5eUxvRZGwW8FvfbaH7AXSh2cL+3j5fMGzUMCxWBJ3dV3a7Wz8y2f/uQ0e3B6WmodD3oS54jTQ9HVTIIg==",
        "dependencies": {}
      },
      "fast-deep-equal@3.1.3": {
        "integrity": "sha512-f3qQ9oQy9j2AhBe/H9VC91wLmKBCCU/gDOnKNAYG5hswO7BLKj09Hc5HYNz9cGI++xlpDCIgDaitVs03ATR84Q==",
        "dependencies": {}
      },
      "fast-querystring@1.1.1": {
        "integrity": "sha512-qR2r+e3HvhEFmpdHMv//U8FnFlnYjaC6QKDuaXALDkw2kvHO8WDjxH+f/rHGR4Me4pnk8p9JAkRNTjYHAKRn2Q==",
        "dependencies": {
          "fast-decode-uri-component": "fast-decode-uri-component@1.0.1"
        }
      },
      "find-my-way@7.6.0": {
        "integrity": "sha512-H7berWdHJ+5CNVr4ilLWPai4ml7Y2qAsxjw3pfeBxPigZmaDTzF0wjJLj90xRCmGcWYcyt050yN+34OZDJm1eQ==",
        "dependencies": {
          "fast-deep-equal": "fast-deep-equal@3.1.3",
          "fast-querystring": "fast-querystring@1.1.1",
          "safe-regex2": "safe-regex2@2.0.0"
        }
      },
      "http-errors@2.0.0": {
        "integrity": "sha512-FtwrG/euBzaEjYeRqOgly7G0qviiXoJWnvEH2Z1plBdXgbyjv34pHTSb9zoeHMyDy33+DWy5Wt9Wo+TURtOYSQ==",
        "dependencies": {
          "depd": "depd@2.0.0",
          "inherits": "inherits@2.0.4",
          "setprototypeof": "setprototypeof@1.2.0",
          "statuses": "statuses@2.0.1",
          "toidentifier": "toidentifier@1.0.1"
        }
      },
      "inherits@2.0.4": {
        "integrity": "sha512-k/vGaX4/Yla3WzyMCvTQOXYeIHvqOKtnqBduzTHpzpQZzAskKMhZ2K+EnBiSM9zGSoIFeMpXKxa4dYeZIQqewQ==",
        "dependencies": {}
      },
      "koa-compose@4.2.0": {
        "integrity": "sha512-/Io2dpt3uU/wWkn2pkRBj3vudzsi6hMssGkREZCxLIczAIvLWy5Jw9PW7ctTxvcfXKCisbgsMLsgE1BvSZB6Kw==",
        "dependencies": {}
      },
      "koa-router@12.0.0": {
        "integrity": "sha512-zGrdiXygGYW8WvrzeGsHZvKnHs4DzyGoqJ9a8iHlRkiwuEAOAPyI27//OlhoWdgFAEIM3qbUgr0KCuRaP/TCag==",
        "dependencies": {
          "http-errors": "http-errors@2.0.0",
          "koa-compose": "koa-compose@4.2.0",
          "methods": "methods@1.1.2",
          "path-to-regexp": "path-to-regexp@6.2.1"
        }
      },
      "koa-tree-router@0.12.1": {
        "integrity": "sha512-U/jJoV+rDFYtbaU/X6r2hcNKT7+DZs8HeXONWA7/OSIMk6/cYhoW5P9MPrjg7vHWRrmZOAiFkPoW7vtxvwLWpw==",
        "dependencies": {
          "@types/koa": "@types/koa@2.13.6",
          "koa-compose": "koa-compose@4.2.0"
        }
      },
      "methods@1.1.2": {
        "integrity": "sha512-iclAHeNqNm68zFtnZ0e+1L2yUIdvzNoauKU4WBA3VvH/vPFieF7qfRlwUZU+DA9P9bPXIS90ulxoUoCH23sV2w==",
        "dependencies": {}
      },
      "mitata@0.1.6": {
        "integrity": "sha512-VKQ0r3jriTOU9E2Z+mwbZrUmbg4Li4QyFfi7kfHKl6reZhGzL0AYlu3wE0VPXzIwA5xnFzmEQoBwCcNT8stUkA==",
        "dependencies": {}
      },
      "object-treeify@1.1.33": {
        "integrity": "sha512-EFVjAYfzWqWsBMRHPMAXLCDIJnpMhdWAqR7xG6M6a2cs6PMFpl/+Z20w9zDW4vkxOFfddegBKq9Rehd0bxWE7A==",
        "dependencies": {}
      },
      "path-to-regexp@6.2.1": {
        "integrity": "sha512-JLyh7xT1kizaEvcaXOQwOc2/Yhw6KZOvPf1S8401UyLk86CU79LN3vl7ztXGm/pZ+YjoyAJ4rxmHwbkBXJX+yw==",
        "dependencies": {}
      },
      "ret@0.2.2": {
        "integrity": "sha512-M0b3YWQs7R3Z917WRQy1HHA7Ba7D8hvZg6UE5mLykJxQVE2ju0IXbGlaHPPlkY+WN7wFP+wUMXmBFA0aV6vYGQ==",
        "dependencies": {}
      },
      "safe-regex2@2.0.0": {
        "integrity": "sha512-PaUSFsUaNNuKwkBijoAPHAK6/eM6VirvyPWlZ7BAQy4D+hCvh4B6lIG+nPdhbFfIbP+gTGBcrdsOaUs0F+ZBOQ==",
        "dependencies": {
          "ret": "ret@0.2.2"
        }
      },
      "setprototypeof@1.2.0": {
        "integrity": "sha512-E5LDX7Wrp85Kil5bhZv46j8jOeboKq5JMmYM3gVGdGH8xFpPWXUMsNrlODCrkoxMEeNi/XZIwuRvY4XNwYMJpw==",
        "dependencies": {}
      },
      "statuses@2.0.1": {
        "integrity": "sha512-RwNA9Z/7PrK06rYLIzFMlaF+l73iwpzsqRIFgbMLbTcLD6cOao82TaWefPXQvB2fOC4AjuYSEndS7N/mTCbkdQ==",
        "dependencies": {}
      },
      "toidentifier@1.0.1": {
        "integrity": "sha512-o5sSPKEkg/DIQNmH43V0/uerLrpzVedkUh8tGNvaeXpfpuwjKenlSox/2O/BTlZUtEe+JG7s5YhEz608PlAHRA==",
        "dependencies": {}
      },
      "trek-router@1.2.0": {
        "integrity": "sha512-43A1krE0myUO2DV+RQBUYLwK3Q5osszQ65jFe/TFGWMnhdZx0nvq2GQXecXwIPU0weSFo1pYmHfhHHaUPPIRNg==",
        "dependencies": {}
      }
    }
  }
}

```
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
