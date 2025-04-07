/Users/josh/Documents/GitHub/honojs/hono/benchmarks/webapp/hono.js
```javascript
import { Hono } from '../../dist/hono'
//import { Hono } from 'hono'

const hono = new Hono()
hono.get('/user', (c) => c.text('User'))
hono.get('/user/comments', (c) => c.text('User Comments'))
hono.get('/user/avatar', (c) => c.text('User Avatar'))
hono.get('/user/lookup/email/:address', (c) => c.text('User Lookup Email Address'))
hono.get('/event/:id', (c) => c.text('Event'))
hono.get('/event/:id/comments', (c) => c.text('Event Comments'))
hono.post('/event/:id/comments', (c) => c.text('POST Event Comments'))
hono.post('/status', (c) => c.text('Status'))
hono.get('/very/deeply/nested/route/hello/there', (c) => c.text('Very Deeply Nested Route'))
hono.get('/user/lookup/username/:username', (c) => {
  return new Response(`Hello ${c.req.param('username')}`)
})

hono.fire()

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/webapp/itty-router.js
```javascript
import { Router } from 'itty-router'

const ittyRouter = Router()
ittyRouter.get('/user', () => new Response('User'))
ittyRouter.get('/user/comments', () => new Response('User Comments'))
ittyRouter.get('/user/avatar', () => new Response('User Avatar'))
ittyRouter.get('/user/lookup/email/:address', () => new Response('User Lookup Email Address'))
ittyRouter.get('/event/:id', () => new Response('Event'))
ittyRouter.get('/event/:id/comments', () => new Response('Event Comments'))
ittyRouter.post('/event/:id/comments', () => new Response('POST Event Comments'))
ittyRouter.post('/status', () => new Response('Status'))
ittyRouter.get(
  '/very/deeply/nested/route/hello/there',
  () => new Response('Very Deeply Nested Route')
)
ittyRouter.get('/user/lookup/username/:username', ({ params }) => {
  return new Response(`Hello ${params.username}`, {
    status: 200,
    headers: {
      'Content-Type': 'text/plain;charset=UTF-8',
    },
  })
})

addEventListener('fetch', (event) => event.respondWith(ittyRouter.handle(event.request)))

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/webapp/package.json
```json
{
  "name": "webapp",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start:hono": "wrangler dev hono.js --local --port 8787",
    "start:itty-router": "wrangler dev itty-router.js --local --port 8788",
    "start:sunder": "wrangler dev sunder.js --local --port 8789"
  },
  "license": "MIT",
  "dependencies": {
    "itty-router": "^2.6.1",
    "sunder": "^0.10.1"
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/webapp/sunder.js
```javascript
import { Sunder, Router } from 'sunder'

const sunderRouter = new Router()
sunderRouter.get('/user', (ctx) => {
  ctx.response.body = 'User'
})
sunderRouter.get('/user/comments', (ctx) => {
  ctx.response.body = 'User Comments'
})
sunderRouter.get('/user/avatar', (ctx) => {
  ctx.response.body = 'User Avatar'
})
sunderRouter.get('/user/lookup/email/:address', (ctx) => {
  ctx.response.body = 'User Lookup Email Address'
})
sunderRouter.get('/event/:id', (ctx) => {
  ctx.response.body = 'Event'
})
sunderRouter.get('/event/:id/comments', (ctx) => {
  ctx.response.body = 'Event Comments'
})
sunderRouter.post('/event/:id/comments', (ctx) => {
  ctx.response.body = 'POST Event Comments'
})
sunderRouter.post('/status', (ctx) => {
  ctx.response.body = 'Status'
})
sunderRouter.get('/very/deeply/nested/route/hello/there', (ctx) => {
  ctx.response.body = 'Very Deeply Nested Route'
})
//sunderRouter.get('/static/*', () => {})
sunderRouter.get('/user/lookup/username/:username', (ctx) => {
  ctx.response.body = `Hello ${ctx.params.username}`
})
const sunderApp = new Sunder()
sunderApp.use(sunderRouter.middleware)

addEventListener('fetch', (event) => {
  event.respondWith(sunderApp.handle(event))
})

```
