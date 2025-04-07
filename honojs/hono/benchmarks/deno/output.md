/Users/josh/Documents/GitHub/honojs/hono/benchmarks/deno/fast.ts
```typescript
import fast, { type Context } from 'https://deno.land/x/fast@4.0.0-beta.1/mod.ts'

const app = fast()

app.get('/user', () => {})
app.get('/user/comments', () => {})
app.get('/user/avatar', () => {})
app.get('/user/lookup/email/:address', () => {})
app.get('/event/:id', () => {})
app.get('/event/:id/comments', () => {})
app.post('/event/:id/comments', () => {})
app.post('/status', () => {})
app.get('/very/deeply/nested/route/hello/there', () => {})
app.get('/user/lookup/username/:username', (ctx: Context) => {
  return { message: `Hello ${ctx.params.username}` }
})

await app.serve({
  port: 8000,
})

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/deno/faster.ts
```typescript
import { res, Server } from 'https://deno.land/x/faster@v5.7/mod.ts'
const app = new Server()

app.get('/user', () => {})
app.get('/user/comments', () => {})
app.get('/user/avatar', () => {})
app.get('/user/lookup/email/:address', () => {})
app.get('/event/:id', () => {})
app.get('/event/:id/comments', () => {})
app.post('/event/:id/comments', () => {})
app.post('/status', () => {})
app.get('/very/deeply/nested/route/hello/there', () => {})
app.get('/user/lookup/username/:username', res('json'), async (ctx: any, next: any) => {
  ctx.res.body = { message: `Hello ${ctx.params.username}` }
  await next()
})

await app.listen({ port: 8000 })

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/deno/hono.ts
```typescript
import { Hono } from '../../src/index.ts'
import { RegExpRouter } from '../../src/router/reg-exp-router/index.ts'

const app = new Hono({ router: new RegExpRouter() })

app.get('/user', (c) => c.text('User'))
app.get('/user/comments', (c) => c.text('User Comments'))
app.get('/user/avatar', (c) => c.text('User Avatar'))
app.get('/user/lookup/email/:address', (c) => c.text('User Lookup Email Address'))
app.get('/event/:id', (c) => c.text('Event'))
app.get('/event/:id/comments', (c) => c.text('Event Comments'))
app.post('/event/:id/comments', (c) => c.text('POST Event Comments'))
app.post('/status', (c) => c.text('Status'))
app.get('/very/deeply/nested/route/hello/there', (c) => c.text('Very Deeply Nested Route'))
app.get('/user/lookup/username/:username', (c) => {
  return c.json({ message: `Hello ${c.req.param('username')}` })
})

Deno.serve(app.fetch, {
  port: 8000,
})

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/deno/magalo.ts
```typescript
import { Megalo } from 'https://deno.land/x/megalo@v0.3.0/mod.ts'

const app = new Megalo()

app.get('/user', () => {})
app.get('/user/comments', () => {})
app.get('/user/avatar', () => {})
app.get('/user/lookup/email/:address', () => {})
app.get('/event/:id', () => {})
app.get('/event/:id/comments', () => {})
app.post('/event/:id/comments', () => {})
app.post('/status', () => {})
app.get('/very/deeply/nested/route/hello/there', () => {})
app.get('/user/lookup/username/:username', ({ params }, res) => {
  res.json({
    message: `Hello ${params.username}`,
  })
})

app.listen({ port: 8000 })

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/deno/oak.ts
```typescript
import { Application, Router } from 'https://deno.land/x/oak@v10.5.1/mod.ts'

const router = new Router()

router.get('/user', () => {})
router.get('/user/comments', () => {})
router.get('/user/avatar', () => {})
router.get('/user/lookup/email/:address', () => {})
router.get('/event/:id', () => {})
router.get('/event/:id/comments', () => {})
router.post('/event/:id/comments', () => {})
router.post('/status', () => {})
router.get('/very/deeply/nested/route/hello/there', () => {})
router.get('/user/lookup/username/:username', (ctx) => {
  ctx.response.body = {
    message: `Hello ${ctx.params.username}`,
  }
})

const app = new Application()
app.use(router.routes())
app.use(router.allowedMethods())

await app.listen({ port: 8000 })

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/deno/opine.ts
```typescript
import { opine } from 'https://deno.land/x/opine@2.2.0/mod.ts'

const app = opine()

app.get('/user', () => {})
app.get('/user/comments', () => {})
app.get('/user/avatar', () => {})
app.get('/user/lookup/email/:address', () => {})
app.get('/event/:id', () => {})
app.get('/event/:id/comments', () => {})
app.post('/event/:id/comments', () => {})
app.post('/status', () => {})
app.get('/very/deeply/nested/route/hello/there', () => {})
app.get('/user/lookup/username/:username', (req, res) => {
  res.send({ message: `Hello ${req.params.username}` })
})

app.listen(8000)

```
