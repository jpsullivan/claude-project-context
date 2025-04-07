/Users/josh/Documents/GitHub/honojs/hono/src/middleware/basic-auth/index.test.ts
```typescript
import { createHash } from 'crypto'
import { Hono } from '../../hono'
import { basicAuth } from '.'

describe('Basic Auth by Middleware', () => {
  let handlerExecuted: boolean

  beforeEach(() => {
    handlerExecuted = false
  })

  const app = new Hono()

  const username = 'hono-user-a'
  const password = 'hono-password-a'
  const unicodePassword = '炎'

  const usernameB = 'hono-user-b'
  const passwordB = 'hono-password-b'

  const usernameC = 'hono-user-c'
  const passwordC = 'hono-password-c'

  app.use(
    '/auth/*',
    basicAuth({
      username,
      password,
    })
  )
  // Test multiple handlers
  app.use('/auth/*', async (c, next) => {
    c.header('x-custom', 'foo')
    await next()
  })

  app.use(
    '/auth-unicode/*',
    basicAuth({
      username: username,
      password: unicodePassword,
    })
  )

  app.use(
    '/auth-multi/*',
    basicAuth(
      {
        username: usernameB,
        password: passwordB,
      },
      {
        username: usernameC,
        password: passwordC,
      }
    )
  )

  app.use(
    '/auth-override-func/*',
    basicAuth({
      username: username,
      password: password,
      hashFunction: (data: string) => createHash('sha256').update(data).digest('hex'),
    })
  )

  app.use('/nested/*', async (c, next) => {
    const auth = basicAuth({ username: username, password: password })
    return auth(c, next)
  })

  app.use('/verify-user/*', async (c, next) => {
    const auth = basicAuth({
      verifyUser: (username, password, c) => {
        return (
          c.req.path === '/verify-user' &&
          username === 'dynamic-user' &&
          password === 'hono-password'
        )
      },
    })
    return auth(c, next)
  })

  app.use(
    '/auth-custom-invalid-user-message-string/*',
    basicAuth({
      username,
      password,
      invalidUserMessage: 'Custom unauthorized message as string',
    })
  )

  app.use(
    '/auth-custom-invalid-user-message-object/*',
    basicAuth({
      username,
      password,
      invalidUserMessage: { message: 'Custom unauthorized message as object' },
    })
  )

  app.use(
    '/auth-custom-invalid-user-message-function-string/*',
    basicAuth({
      username,
      password,
      invalidUserMessage: () => 'Custom unauthorized message as function string',
    })
  )

  app.use(
    '/auth-custom-invalid-user-message-function-object/*',
    basicAuth({
      username,
      password,
      invalidUserMessage: () => ({ message: 'Custom unauthorized message as function object' }),
    })
  )

  app.get('/auth/*', (c) => {
    handlerExecuted = true
    return c.text('auth')
  })
  app.get('/auth-unicode/*', (c) => {
    handlerExecuted = true
    return c.text('auth')
  })
  app.get('/auth-multi/*', (c) => {
    handlerExecuted = true
    return c.text('auth')
  })
  app.get('/auth-override-func/*', (c) => {
    handlerExecuted = true
    return c.text('auth')
  })

  app.get('/nested/*', (c) => {
    handlerExecuted = true
    return c.text('nested')
  })

  app.get('/verify-user', (c) => {
    handlerExecuted = true
    return c.text('verify-user')
  })

  app.get('/auth-custom-invalid-user-message-string/*', (c) => {
    handlerExecuted = true
    return c.text('auth')
  })
  app.get('/auth-custom-invalid-user-message-object/*', (c) => {
    handlerExecuted = true
    return c.text('auth')
  })
  app.get('/auth-custom-invalid-user-message-function-string/*', (c) => {
    handlerExecuted = true
    return c.text('auth')
  })

  app.get('/auth-custom-invalid-user-message-function-object/*', (c) => {
    handlerExecuted = true
    return c.text('auth')
  })

  it('Should not authorize', async () => {
    const req = new Request('http://localhost/auth/a')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Unauthorized')
    expect(res.headers.get('x-custom')).toBeNull()
  })

  it('Should authorize', async () => {
    const credential = Buffer.from(username + ':' + password).toString('base64')

    const req = new Request('http://localhost/auth/a')
    req.headers.set('Authorization', `Basic ${credential}`)
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(handlerExecuted).toBeTruthy()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('auth')
    expect(res.headers.get('x-custom')).toBe('foo')
  })

  it('Should authorize Unicode', async () => {
    const credential = Buffer.from(username + ':' + unicodePassword).toString('base64')

    const req = new Request('http://localhost/auth-unicode/a')
    req.headers.set('Authorization', `Basic ${credential}`)
    const res = await app.request(req)
    expect(handlerExecuted).toBeTruthy()
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('auth')
  })

  it('Should authorize multiple users', async () => {
    let credential = Buffer.from(usernameB + ':' + passwordB).toString('base64')

    let req = new Request('http://localhost/auth-multi/b')
    req.headers.set('Authorization', `Basic ${credential}`)
    let res = await app.request(req)
    expect(handlerExecuted).toBeTruthy()
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('auth')

    handlerExecuted = false
    credential = Buffer.from(usernameC + ':' + passwordC).toString('base64')
    req = new Request('http://localhost/auth-multi/c')
    req.headers.set('Authorization', `Basic ${credential}`)
    res = await app.request(req)
    expect(handlerExecuted).toBeTruthy()
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('auth')
  })

  it('Should authorize with sha256 function override', async () => {
    const credential = Buffer.from(username + ':' + password).toString('base64')

    const req = new Request('http://localhost/auth-override-func/a')
    req.headers.set('Authorization', `Basic ${credential}`)
    const res = await app.request(req)
    expect(handlerExecuted).toBeTruthy()
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('auth')
  })

  it('Should authorize - nested', async () => {
    const credential = Buffer.from(username + ':' + password).toString('base64')

    const req = new Request('http://localhost/nested')
    req.headers.set('Authorization', `Basic ${credential}`)
    const res = await app.request(req)
    expect(handlerExecuted).toBeTruthy()
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('nested')
  })

  it('Should not authorize - nested', async () => {
    const credential = Buffer.from('foo' + ':' + 'bar').toString('base64')

    const req = new Request('http://localhost/nested')
    req.headers.set('Authorization', `Basic ${credential}`)
    const res = await app.request(req)
    expect(handlerExecuted).toBeFalsy()
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
  })

  it('Should authorize - verifyUser', async () => {
    const credential = Buffer.from('dynamic-user' + ':' + 'hono-password').toString('base64')

    const req = new Request('http://localhost/verify-user')
    req.headers.set('Authorization', `Basic ${credential}`)
    const res = await app.request(req)
    expect(handlerExecuted).toBeTruthy()
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('verify-user')
  })

  it('Should not authorize - verifyUser', async () => {
    const credential = Buffer.from('foo' + ':' + 'bar').toString('base64')

    const req = new Request('http://localhost/verify-user')
    req.headers.set('Authorization', `Basic ${credential}`)
    const res = await app.request(req)
    expect(handlerExecuted).toBeFalsy()
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
  })

  it('Should not authorize - custom invalid user message as string', async () => {
    const req = new Request('http://localhost/auth-custom-invalid-user-message-string')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Custom unauthorized message as string')
  })

  it('Should not authorize - custom invalid user message as object', async () => {
    const req = new Request('http://localhost/auth-custom-invalid-user-message-object')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(res.headers.get('Content-Type')).toMatch('application/json')
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('{"message":"Custom unauthorized message as object"}')
  })

  it('Should not authorize - custom invalid user message as function string', async () => {
    const req = new Request('http://localhost/auth-custom-invalid-user-message-function-string')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Custom unauthorized message as function string')
  })

  it('Should not authorize - custom invalid user message as function object', async () => {
    const req = new Request('http://localhost/auth-custom-invalid-user-message-function-object')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(res.headers.get('Content-Type')).toMatch('application/json')
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('{"message":"Custom unauthorized message as function object"}')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/basic-auth/index.ts
````typescript
/**
 * @module
 * Basic Auth Middleware for Hono.
 */

import type { Context } from '../../context'
import { HTTPException } from '../../http-exception'
import type { MiddlewareHandler } from '../../types'
import { auth } from '../../utils/basic-auth'
import { timingSafeEqual } from '../../utils/buffer'

type MessageFunction = (c: Context) => string | object | Promise<string | object>

type BasicAuthOptions =
  | {
      username: string
      password: string
      realm?: string
      hashFunction?: Function
      invalidUserMessage?: string | object | MessageFunction
    }
  | {
      verifyUser: (username: string, password: string, c: Context) => boolean | Promise<boolean>
      realm?: string
      hashFunction?: Function
      invalidUserMessage?: string | object | MessageFunction
    }

/**
 * Basic Auth Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/basic-auth}
 *
 * @param {BasicAuthOptions} options - The options for the basic authentication middleware.
 * @param {string} options.username - The username for authentication.
 * @param {string} options.password - The password for authentication.
 * @param {string} [options.realm="Secure Area"] - The realm attribute for the WWW-Authenticate header.
 * @param {Function} [options.hashFunction] - The hash function used for secure comparison.
 * @param {Function} [options.verifyUser] - The function to verify user credentials.
 * @param {string | object | MessageFunction} [options.invalidUserMessage="Unauthorized"] - The invalid user message.
 * @returns {MiddlewareHandler} The middleware handler function.
 * @throws {HTTPException} If neither "username and password" nor "verifyUser" options are provided.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use(
 *   '/auth/*',
 *   basicAuth({
 *     username: 'hono',
 *     password: 'ahotproject',
 *   })
 * )
 *
 * app.get('/auth/page', (c) => {
 *   return c.text('You are authorized')
 * })
 * ```
 */
export const basicAuth = (
  options: BasicAuthOptions,
  ...users: { username: string; password: string }[]
): MiddlewareHandler => {
  const usernamePasswordInOptions = 'username' in options && 'password' in options
  const verifyUserInOptions = 'verifyUser' in options

  if (!(usernamePasswordInOptions || verifyUserInOptions)) {
    throw new Error(
      'basic auth middleware requires options for "username and password" or "verifyUser"'
    )
  }

  if (!options.realm) {
    options.realm = 'Secure Area'
  }

  if (!options.invalidUserMessage) {
    options.invalidUserMessage = 'Unauthorized'
  }

  if (usernamePasswordInOptions) {
    users.unshift({ username: options.username, password: options.password })
  }

  return async function basicAuth(ctx, next) {
    const requestUser = auth(ctx.req.raw)
    if (requestUser) {
      if (verifyUserInOptions) {
        if (await options.verifyUser(requestUser.username, requestUser.password, ctx)) {
          await next()
          return
        }
      } else {
        for (const user of users) {
          const [usernameEqual, passwordEqual] = await Promise.all([
            timingSafeEqual(user.username, requestUser.username, options.hashFunction),
            timingSafeEqual(user.password, requestUser.password, options.hashFunction),
          ])
          if (usernameEqual && passwordEqual) {
            await next()
            return
          }
        }
      }
    }
    // Invalid user.
    const status = 401
    const headers = {
      'WWW-Authenticate': 'Basic realm="' + options.realm?.replace(/"/g, '\\"') + '"',
    }
    const responseMessage =
      typeof options.invalidUserMessage === 'function'
        ? await options.invalidUserMessage(ctx)
        : options.invalidUserMessage
    const res =
      typeof responseMessage === 'string'
        ? new Response(responseMessage, { status, headers })
        : new Response(JSON.stringify(responseMessage), {
            status,
            headers: {
              ...headers,
              'content-type': 'application/json',
            },
          })
    throw new HTTPException(status, { res })
  }
}

````
