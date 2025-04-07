/Users/josh/Documents/GitHub/honojs/hono/src/middleware/jsx-renderer/index.test.tsx
```
/** @jsxImportSource ../../jsx */
import { expectTypeOf } from 'vitest'
import { html } from '../../helper/html'
import { Hono } from '../../hono'
import type { FC } from '../../jsx'
import { Suspense } from '../../jsx/streaming'
import { jsxRenderer, useRequestContext } from '.'

const RequestUrl: FC = () => {
  const c = useRequestContext()
  return html`${c.req.url}`
}

describe('JSX renderer', () => {
  it('basic', async () => {
    const app = new Hono()
    app.use(
      '*',
      jsxRenderer(({ children, title }) => (
        <html>
          <head>{title}</head>
          <body>{children}</body>
        </html>
      ))
    )
    app.get('/', (c) =>
      c.render(
        <h1>
          <RequestUrl />
        </h1>,
        { title: 'Title' }
      )
    )

    const app2 = new Hono()
    app2.use(
      '*',
      jsxRenderer(({ children }) => <div class='nested'>{children}</div>)
    )
    app2.get('/', (c) => c.render(<h1>http://localhost/nested</h1>, { title: 'Title' }))
    app.route('/nested', app2)

    let res = await app.request('http://localhost/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe(
      '<!DOCTYPE html><html><head>Title</head><body><h1>http://localhost/</h1></body></html>'
    )

    res = await app.request('http://localhost/nested')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe(
      '<!DOCTYPE html><div class="nested"><h1>http://localhost/nested</h1></div>'
    )
  })

  it('Should get the context object as a 2nd arg', async () => {
    const app = new Hono()
    app.use(
      jsxRenderer(
        ({ children }, c) => {
          return (
            <div>
              {children} at {c.req.path}
            </div>
          )
        },
        { docType: false }
      )
    )
    app.get('/hi', (c) => {
      return c.render('hi', { title: 'hi' })
    })

    const res = await app.request('/hi')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('<div>hi at /hi</div>')
  })

  it('nested layout with Layout', async () => {
    const app = new Hono()
    app.use(
      '*',
      jsxRenderer(({ children, title, Layout }) => (
        <Layout>
          <html>
            <head>{title}</head>
            <body>{children}</body>
          </html>
        </Layout>
      ))
    )

    const app2 = new Hono()
    app2.use(
      '*',
      jsxRenderer(({ children, Layout, title }) => (
        <Layout title={title}>
          <div class='nested'>{children}</div>
        </Layout>
      ))
    )
    app2.get('/', (c) => c.render(<h1>http://localhost/nested</h1>, { title: 'Nested' }))

    const app3 = new Hono()
    app3.use(
      '*',
      jsxRenderer(({ children, Layout, title }) => (
        <Layout title={title}>
          <div class='nested2'>{children}</div>
        </Layout>
      ))
    )
    app3.get('/', (c) => c.render(<h1>http://localhost/nested</h1>, { title: 'Nested2' }))
    app2.route('/nested2', app3)

    app.route('/nested', app2)

    let res = await app.request('http://localhost/nested')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe(
      '<!DOCTYPE html><html><head>Nested</head><body><div class="nested"><h1>http://localhost/nested</h1></div></body></html>'
    )

    res = await app.request('http://localhost/nested/nested2')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe(
      '<!DOCTYPE html><html><head>Nested2</head><body><div class="nested"><div class="nested2"><h1>http://localhost/nested</h1></div></div></body></html>'
    )
  })

  it('Should return a default doctype', async () => {
    const app = new Hono()
    app.use(
      '*',
      jsxRenderer(
        ({ children }) => {
          return (
            <html>
              <body>{children}</body>
            </html>
          )
        },
        { docType: true }
      )
    )
    app.get('/', (c) => c.render(<h1>Hello</h1>, { title: 'Title' }))
    const res = await app.request('/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('<!DOCTYPE html><html><body><h1>Hello</h1></body></html>')
  })

  it('Should return a non includes doctype', async () => {
    const app = new Hono()
    app.use(
      '*',
      jsxRenderer(
        ({ children }) => {
          return (
            <html>
              <body>{children}</body>
            </html>
          )
        },
        { docType: false }
      )
    )
    app.get('/', (c) => c.render(<h1>Hello</h1>, { title: 'Title' }))
    const res = await app.request('/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('<html><body><h1>Hello</h1></body></html>')
  })

  it('Should return a custom doctype', async () => {
    const app = new Hono()
    app.use(
      '*',
      jsxRenderer(
        ({ children }) => {
          return (
            <html>
              <body>{children}</body>
            </html>
          )
        },
        {
          docType:
            '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">',
        }
      )
    )
    app.get('/', (c) => c.render(<h1>Hello</h1>, { title: 'Title' }))
    const res = await app.request('/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe(
      '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"><html><body><h1>Hello</h1></body></html>'
    )
  })

  it('Should return as streaming content with default headers', async () => {
    const app = new Hono()
    app.use(
      '*',
      jsxRenderer(
        ({ children }) => {
          return (
            <html>
              <body>{children}</body>
            </html>
          )
        },
        {
          docType: true,
          stream: true,
        }
      )
    )
    const AsyncComponent = async () => {
      const c = useRequestContext()
      return <p>Hello {c.req.query('name')}!</p>
    }
    app.get('/', (c) =>
      c.render(
        <Suspense fallback={<p>Loading...</p>}>
          <AsyncComponent />
        </Suspense>,
        { title: 'Title' }
      )
    )
    const res = await app.request('/?name=Hono')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('Transfer-Encoding')).toEqual('chunked')
    expect(res.headers.get('Content-Type')).toEqual('text/html; charset=UTF-8')
    expect(res.headers.get('Content-Encoding')).toEqual('Identity')

    if (!res.body) {
      throw new Error('Body is null')
    }

    const chunk: string[] = []
    const reader = res.body.getReader()
    const decoder = new TextDecoder()
    for (;;) {
      const { value, done } = await reader.read()
      if (done) {
        break
      }
      chunk.push(decoder.decode(value))
    }
    expect(chunk).toEqual([
      '<!DOCTYPE html><html><body><template id="H:0"></template><p>Loading...</p><!--/$--></body></html>',
      `<template data-hono-target="H:0"><p>Hello Hono!</p></template><script>
((d,c,n) => {
c=d.currentScript.previousSibling
d=d.getElementById('H:0')
if(!d)return
do{n=d.nextSibling;n.remove()}while(n.nodeType!=8||n.nodeValue!='/$')
d.replaceWith(c.content)
})(document)
</script>`,
    ])
  })

  // this test relies upon 'Should return as streaming content with default headers'
  // this should be refactored to prevent tests depending on each other
  it('Should return as streaming content with custom headers', async () => {
    const app = new Hono()
    app.use(
      '*',
      jsxRenderer(
        ({ children }) => {
          return (
            <html>
              <body>{children}</body>
            </html>
          )
        },
        {
          docType: true,
          stream: {
            'Transfer-Encoding': 'chunked',
            'Content-Type': 'text/html',
          },
        }
      )
    )
    const AsyncComponent = async () => {
      const c = useRequestContext()
      return <p>Hello {c.req.query('name')} again!</p>
    }
    app.get('/', (c) =>
      c.render(
        <Suspense fallback={<p>Loading...</p>}>
          <AsyncComponent />
        </Suspense>,
        { title: 'Title' }
      )
    )
    const res = await app.request('/?name=Hono')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('Transfer-Encoding')).toEqual('chunked')
    expect(res.headers.get('Content-Type')).toEqual('text/html')

    if (!res.body) {
      throw new Error('Body is null')
    }

    const chunk: string[] = []
    const reader = res.body.getReader()
    const decoder = new TextDecoder()
    for (;;) {
      const { value, done } = await reader.read()
      if (done) {
        break
      }
      chunk.push(decoder.decode(value))
    }
    expect(chunk).toEqual([
      '<!DOCTYPE html><html><body><template id="H:1"></template><p>Loading...</p><!--/$--></body></html>',
      `<template data-hono-target="H:1"><p>Hello Hono again!</p></template><script>
((d,c,n) => {
c=d.currentScript.previousSibling
d=d.getElementById('H:1')
if(!d)return
do{n=d.nextSibling;n.remove()}while(n.nodeType!=8||n.nodeValue!='/$')
d.replaceWith(c.content)
})(document)
</script>`,
    ])
  })

  it('Should return as streaming content with headers added in a handler', async () => {
    const app = new Hono()
    app.use(jsxRenderer(async ({ children }) => <div>{children}</div>, { stream: true }))
    app.get('/', (c) => {
      c.header('X-Message-Set', 'Hello')
      c.header('X-Message-Append', 'Hello', { append: true })
      return c.render('Hi', { title: 'Hi' })
    })
    const res = await app.request('/')
    expect(res.status).toBe(200)
    expect(res.headers.get('Transfer-Encoding')).toBe('chunked')
    expect(res.headers.get('Content-Type')).toBe('text/html; charset=UTF-8')
    expect(res.headers.get('X-Message-Set')).toBe('Hello')
    expect(res.headers.get('X-Message-Append')).toBe('Hello')
    expect(await res.text()).toBe('<!DOCTYPE html><div>Hi</div>')
  })

  it('Env', async () => {
    type JSXRendererEnv = {
      Variables: {
        foo: string
      }
      Bindings: {
        bar: string
      }
    }

    const VariableFoo: FC = () => {
      const c = useRequestContext<JSXRendererEnv>()
      expectTypeOf(c.get('foo')).toEqualTypeOf<string>()
      return html`${c.get('foo')}`
    }

    const BindingsBar: FC = () => {
      const c = useRequestContext<JSXRendererEnv>()
      expectTypeOf(c.env.bar).toEqualTypeOf<string>()
      return html`${c.env.bar}`
    }

    const app = new Hono<JSXRendererEnv>()
    app.use('*', jsxRenderer())
    app.get('/', (c) => {
      c.set('foo', 'fooValue')
      return c.render(
        <>
          <h1>
            <VariableFoo />
          </h1>
          <p>
            <BindingsBar />
          </p>
        </>,
        { title: 'Title' }
      )
    })
    const res = await app.request('http://localhost/', undefined, { bar: 'barValue' })
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('<!DOCTYPE html><h1>fooValue</h1><p>barValue</p>')
  })

  it('Should return a resolved content', async () => {
    const app = new Hono()
    app.use(jsxRenderer(async ({ children }) => <div>{children}</div>))
    app.get('/', (c) => c.render('Hi', { title: 'Hi' }))
    const res = await app.request('/')
    expect(res.status).toBe(200)
    expect(await res.text()).toBe('<!DOCTYPE html><div>Hi</div>')
  })

  describe('keep context status', async () => {
    it('Should keep context status', async () => {
      const app = new Hono()
      app.use(
        '*',
        jsxRenderer(({ children }) => {
          return (
            <html>
              <body>{children}</body>
            </html>
          )
        })
      )
      app.get('/', (c) => {
        c.status(201)
        return c.render(<h1>Hello</h1>, { title: 'Title' })
      })
      const res = await app.request('/')
      expect(res).not.toBeNull()
      expect(res.status).toBe(201)
      expect(await res.text()).toBe('<!DOCTYPE html><html><body><h1>Hello</h1></body></html>')
    })

    it('Should keep context status with stream option', async () => {
      const app = new Hono()
      app.use(
        '*',
        jsxRenderer(
          ({ children }) => {
            return (
              <html>
                <body>{children}</body>
              </html>
            )
          },
          { stream: true }
        )
      )
      app.get('/', (c) => {
        c.status(201)
        return c.render(<h1>Hello</h1>, { title: 'Title' })
      })
      const res = await app.request('/')
      expect(res).not.toBeNull()
      expect(res.status).toBe(201)
      expect(await res.text()).toBe('<!DOCTYPE html><html><body><h1>Hello</h1></body></html>')
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/jsx-renderer/index.ts
````typescript
/**
 * @module
 * JSX Renderer Middleware for Hono.
 */

/* eslint-disable @typescript-eslint/no-explicit-any */
import type { Context, PropsForRenderer } from '../../context'
import { html, raw } from '../../helper/html'
import { Fragment, createContext, jsx, useContext } from '../../jsx'
import type { FC, Context as JSXContext, JSXNode, PropsWithChildren } from '../../jsx'
import { renderToReadableStream } from '../../jsx/streaming'
import type { Env, Input, MiddlewareHandler } from '../../types'
import type { HtmlEscapedString } from '../../utils/html'

export const RequestContext: JSXContext<Context<any, any, {}> | null> =
  createContext<Context | null>(null)

type RendererOptions = {
  docType?: boolean | string
  stream?: boolean | Record<string, string>
}

type Component = (
  props: PropsForRenderer & { Layout: FC },
  c: Context
) => HtmlEscapedString | Promise<HtmlEscapedString>

type ComponentWithChildren = (
  props: PropsWithChildren<PropsForRenderer & { Layout: FC }>,
  c: Context
) => HtmlEscapedString | Promise<HtmlEscapedString>

const createRenderer =
  (c: Context, Layout: FC, component?: Component, options?: RendererOptions) =>
  (children: JSXNode, props: PropsForRenderer) => {
    const docType =
      typeof options?.docType === 'string'
        ? options.docType
        : options?.docType === false
        ? ''
        : '<!DOCTYPE html>'

    const currentLayout = component
      ? jsx(
          (props: any) => component(props, c),
          {
            Layout,
            ...(props as any),
          },
          children as any
        )
      : children

    const body = html`${raw(docType)}${jsx(
      RequestContext.Provider,
      { value: c },
      currentLayout as any
    )}`

    if (options?.stream) {
      if (options.stream === true) {
        c.header('Transfer-Encoding', 'chunked')
        c.header('Content-Type', 'text/html; charset=UTF-8')
        c.header('Content-Encoding', 'Identity')
      } else {
        for (const [key, value] of Object.entries(options.stream)) {
          c.header(key, value)
        }
      }
      return c.body(renderToReadableStream(body))
    } else {
      return c.html(body)
    }
  }

/**
 * JSX Renderer Middleware for hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/jsx-renderer}
 *
 * @param {ComponentWithChildren} [component] - The component to render, which can accept children and props.
 * @param {RendererOptions} [options] - The options for the JSX renderer middleware.
 * @param {boolean | string} [options.docType=true] - The DOCTYPE to be added at the beginning of the HTML. If set to false, no DOCTYPE will be added.
 * @param {boolean | Record<string, string>} [options.stream=false] - If set to true, enables streaming response with default headers. If a record is provided, custom headers will be used.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.get(
 *   '/page/*',
 *   jsxRenderer(({ children }) => {
 *     return (
 *       <html>
 *         <body>
 *           <header>Menu</header>
 *           <div>{children}</div>
 *         </body>
 *       </html>
 *     )
 *   })
 * )
 *
 * app.get('/page/about', (c) => {
 *   return c.render(<h1>About me!</h1>)
 * })
 * ```
 */
export const jsxRenderer = (
  component?: ComponentWithChildren,
  options?: RendererOptions
): MiddlewareHandler =>
  function jsxRenderer(c, next) {
    const Layout = (c.getLayout() ?? Fragment) as FC
    if (component) {
      c.setLayout((props) => {
        return component({ ...props, Layout }, c)
      })
    }
    c.setRenderer(createRenderer(c, Layout, component, options) as any)
    return next()
  }

/**
 * useRequestContext for Hono.
 *
 * @template E - The environment type.
 * @template P - The parameter type.
 * @template I - The input type.
 * @returns {Context<E, P, I>} An instance of Context.
 *
 * @example
 * ```ts
 * const RequestUrlBadge: FC = () => {
 *   const c = useRequestContext()
 *   return <b>{c.req.url}</b>
 * }
 *
 * app.get('/page/info', (c) => {
 *   return c.render(
 *     <div>
 *       You are accessing: <RequestUrlBadge />
 *     </div>
 *   )
 * })
 * ```
 */
export const useRequestContext = <
  E extends Env = any,
  P extends string = any,
  I extends Input = {}
>(): Context<E, P, I> => {
  const c = useContext(RequestContext)
  if (!c) {
    throw new Error('RequestContext is not provided.')
  }
  return c
}

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/jwt/index.test.ts
```typescript
import { Hono } from '../../hono'
import { HTTPException } from '../../http-exception'
import { jwt } from '.'

describe('JWT', () => {
  describe('Credentials in header', () => {
    let handlerExecuted: boolean

    beforeEach(() => {
      handlerExecuted = false
    })

    const app = new Hono()

    app.use('/auth/*', jwt({ secret: 'a-secret' }))
    app.use('/auth-unicode/*', jwt({ secret: 'a-secret' }))
    app.use('/nested/*', async (c, next) => {
      const auth = jwt({ secret: 'a-secret' })
      return auth(c, next)
    })

    app.get('/auth/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/auth-unicode/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/nested/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })

    it('Should not authorize', async () => {
      const req = new Request('http://localhost/auth/a')
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(await res.text()).toBe('Unauthorized')
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should authorize', async () => {
      const credential =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE'
      const req = new Request('http://localhost/auth/a')
      req.headers.set('Authorization', `Bearer ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should authorize Unicode', async () => {
      const credential =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE'

      const req = new Request('http://localhost/auth-unicode/a')
      req.headers.set('Authorization', `Basic ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should not authorize Unicode', async () => {
      const invalidToken =
        'ssyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE'

      const url = 'http://localhost/auth-unicode/a'
      const req = new Request(url)
      req.headers.set('Authorization', `Basic ${invalidToken}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(res.headers.get('www-authenticate')).toEqual(
        `Bearer realm="${url}",error="invalid_token",error_description="token verification failure"`
      )
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should not authorize', async () => {
      const invalid_token = 'invalid token'
      const url = 'http://localhost/auth/a'
      const req = new Request(url)
      req.headers.set('Authorization', `Bearer ${invalid_token}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(res.headers.get('www-authenticate')).toEqual(
        `Bearer realm="${url}",error="invalid_request",error_description="invalid credentials structure"`
      )
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should not authorize - nested', async () => {
      const req = new Request('http://localhost/nested/a')
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(await res.text()).toBe('Unauthorized')
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should authorize - nested', async () => {
      const credential =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE'
      const req = new Request('http://localhost/nested/a')
      req.headers.set('Authorization', `Bearer ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })
  })

  describe('Credentials in cookie', () => {
    let handlerExecuted: boolean

    beforeEach(() => {
      handlerExecuted = false
    })

    const app = new Hono()

    app.use('/auth/*', jwt({ secret: 'a-secret', cookie: 'access_token' }))
    app.use('/auth-unicode/*', jwt({ secret: 'a-secret', cookie: 'access_token' }))

    app.get('/auth/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/auth-unicode/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })

    it('Should not authorize', async () => {
      const req = new Request('http://localhost/auth/a')
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(await res.text()).toBe('Unauthorized')
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should authorize', async () => {
      const url = 'http://localhost/auth/a'
      const credential =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE'
      const req = new Request(url, {
        headers: new Headers({
          Cookie: `access_token=${credential}`,
        }),
      })
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(res.status).toBe(200)
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should authorize Unicode', async () => {
      const credential =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE'

      const req = new Request('http://localhost/auth-unicode/a', {
        headers: new Headers({
          Cookie: `access_token=${credential}`,
        }),
      })
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should not authorize Unicode', async () => {
      const invalidToken =
        'ssyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE'

      const url = 'http://localhost/auth-unicode/a'
      const req = new Request(url)
      req.headers.set('Cookie', `access_token=${invalidToken}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(res.headers.get('www-authenticate')).toEqual(
        `Bearer realm="${url}",error="invalid_token",error_description="token verification failure"`
      )
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should not authorize', async () => {
      const invalidToken = 'invalid token'
      const url = 'http://localhost/auth/a'
      const req = new Request(url)
      req.headers.set('Cookie', `access_token=${invalidToken}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(res.headers.get('www-authenticate')).toEqual(
        `Bearer realm="${url}",error="invalid_token",error_description="token verification failure"`
      )
      expect(handlerExecuted).toBeFalsy()
    })
  })

  describe('Error handling with `cause`', () => {
    const app = new Hono()

    app.use('/auth/*', jwt({ secret: 'a-secret' }))
    app.get('/auth/*', (c) => c.text('Authorized'))

    app.onError((e, c) => {
      if (e instanceof HTTPException && e.cause instanceof Error) {
        return c.json({ name: e.cause.name, message: e.cause.message }, 401)
      }
      return c.text(e.message, 401)
    })

    it('Should not authorize', async () => {
      const credential = 'abc.def.ghi'
      const req = new Request('http://localhost/auth')
      req.headers.set('Authorization', `Bearer ${credential}`)
      const res = await app.request(req)
      expect(res.status).toBe(401)
      expect(await res.json()).toEqual({
        name: 'JwtTokenInvalid',
        message: `invalid JWT token: ${credential}`,
      })
    })
  })

  describe('Credentials in signed cookie with prefix Options', () => {
    let handlerExecuted: boolean

    beforeEach(() => {
      handlerExecuted = false
    })

    const app = new Hono()

    app.use(
      '/auth/*',
      jwt({
        secret: 'a-secret',
        cookie: {
          key: 'cookie_name',
          secret: 'cookie_secret',
          prefixOptions: 'host',
        },
      })
    )

    app.get('/auth/*', async (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })

    it('Should not authorize', async () => {
      const req = new Request('http://localhost/auth/a')
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(await res.text()).toBe('Unauthorized')
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should authorize', async () => {
      const url = 'http://localhost/auth/a'
      const req = new Request(url, {
        headers: new Headers({
          Cookie:
            '__Host-cookie_name=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE.i2NSvtJOXOPS9NDL1u8dqTYmMrzcD4mNSws6P6qmeV0%3D; Path=/',
        }),
      })
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })
  })

  describe('Credentials in signed cookie without prefix Options', () => {
    let handlerExecuted: boolean

    beforeEach(() => {
      handlerExecuted = false
    })

    const app = new Hono()

    app.use(
      '/auth/*',
      jwt({
        secret: 'a-secret',
        cookie: {
          key: 'cookie_name',
          secret: 'cookie_secret',
        },
      })
    )

    app.get('/auth/*', async (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })

    it('Should not authorize', async () => {
      const req = new Request('http://localhost/auth/a')
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(await res.text()).toBe('Unauthorized')
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should authorize', async () => {
      const url = 'http://localhost/auth/a'
      const req = new Request(url, {
        headers: new Headers({
          Cookie:
            'cookie_name=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE.i2NSvtJOXOPS9NDL1u8dqTYmMrzcD4mNSws6P6qmeV0%3D; Path=/',
        }),
      })
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })
  })

  describe('Credentials in cookie object with prefix Options', () => {
    let handlerExecuted: boolean

    beforeEach(() => {
      handlerExecuted = false
    })

    const app = new Hono()

    app.use(
      '/auth/*',
      jwt({
        secret: 'a-secret',
        cookie: {
          key: 'cookie_name',
          prefixOptions: 'host',
        },
      })
    )

    app.get('/auth/*', async (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })

    it('Should not authorize', async () => {
      const req = new Request('http://localhost/auth/a')
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(await res.text()).toBe('Unauthorized')
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should authorize', async () => {
      const url = 'http://localhost/auth/a'
      const req = new Request(url, {
        headers: new Headers({
          Cookie:
            '__Host-cookie_name=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE',
        }),
      })
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })
  })

  describe('Credentials in cookie object without prefix Options', () => {
    let handlerExecuted: boolean

    beforeEach(() => {
      handlerExecuted = false
    })

    const app = new Hono()

    app.use(
      '/auth/*',
      jwt({
        secret: 'a-secret',
        cookie: {
          key: 'cookie_name',
        },
      })
    )

    app.get('/auth/*', async (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })

    it('Should not authorize', async () => {
      const req = new Request('http://localhost/auth/a')
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(await res.text()).toBe('Unauthorized')
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should authorize', async () => {
      const url = 'http://localhost/auth/a'
      const req = new Request(url, {
        headers: new Headers({
          Cookie:
            'cookie_name=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE',
        }),
      })
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/jwt/index.ts
```typescript
import type { JwtVariables } from './jwt'
export type { JwtVariables }
export { jwt, verify, decode, sign } from './jwt'
import type {} from '../..'

declare module '../..' {
  interface ContextVariableMap extends JwtVariables {}
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/jwt/jwt.ts
````typescript
/**
 * @module
 * JWT Auth Middleware for Hono.
 */

import type { Context } from '../../context'
import { getCookie, getSignedCookie } from '../../helper/cookie'
import { HTTPException } from '../../http-exception'
import type { MiddlewareHandler } from '../../types'
import type { CookiePrefixOptions } from '../../utils/cookie'
import { Jwt } from '../../utils/jwt'
import '../../context'
import type { SignatureAlgorithm } from '../../utils/jwt/jwa'
import type { SignatureKey } from '../../utils/jwt/jws'

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type JwtVariables<T = any> = {
  jwtPayload: T
}

/**
 * JWT Auth Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/jwt}
 *
 * @param {object} options - The options for the JWT middleware.
 * @param {SignatureKey} [options.secret] - A value of your secret key.
 * @param {string} [options.cookie] - If this value is set, then the value is retrieved from the cookie header using that value as a key, which is then validated as a token.
 * @param {SignatureAlgorithm} [options.alg=HS256] - An algorithm type that is used for verifying. Available types are `HS256` | `HS384` | `HS512` | `RS256` | `RS384` | `RS512` | `PS256` | `PS384` | `PS512` | `ES256` | `ES384` | `ES512` | `EdDSA`.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use(
 *   '/auth/*',
 *   jwt({
 *     secret: 'it-is-very-secret',
 *   })
 * )
 *
 * app.get('/auth/page', (c) => {
 *   return c.text('You are authorized')
 * })
 * ```
 */
export const jwt = (options: {
  secret: SignatureKey
  cookie?:
    | string
    | { key: string; secret?: string | BufferSource; prefixOptions?: CookiePrefixOptions }
  alg?: SignatureAlgorithm
}): MiddlewareHandler => {
  if (!options || !options.secret) {
    throw new Error('JWT auth middleware requires options for "secret"')
  }

  if (!crypto.subtle || !crypto.subtle.importKey) {
    throw new Error('`crypto.subtle.importKey` is undefined. JWT auth middleware requires it.')
  }

  return async function jwt(ctx, next) {
    const credentials = ctx.req.raw.headers.get('Authorization')
    let token
    if (credentials) {
      const parts = credentials.split(/\s+/)
      if (parts.length !== 2) {
        const errDescription = 'invalid credentials structure'
        throw new HTTPException(401, {
          message: errDescription,
          res: unauthorizedResponse({
            ctx,
            error: 'invalid_request',
            errDescription,
          }),
        })
      } else {
        token = parts[1]
      }
    } else if (options.cookie) {
      if (typeof options.cookie == 'string') {
        token = getCookie(ctx, options.cookie)
      } else if (options.cookie.secret) {
        if (options.cookie.prefixOptions) {
          token = await getSignedCookie(
            ctx,
            options.cookie.secret,
            options.cookie.key,
            options.cookie.prefixOptions
          )
        } else {
          token = await getSignedCookie(ctx, options.cookie.secret, options.cookie.key)
        }
      } else {
        if (options.cookie.prefixOptions) {
          token = getCookie(ctx, options.cookie.key, options.cookie.prefixOptions)
        } else {
          token = getCookie(ctx, options.cookie.key)
        }
      }
    }

    if (!token) {
      const errDescription = 'no authorization included in request'
      throw new HTTPException(401, {
        message: errDescription,
        res: unauthorizedResponse({
          ctx,
          error: 'invalid_request',
          errDescription,
        }),
      })
    }

    let payload
    let cause
    try {
      payload = await Jwt.verify(token, options.secret, options.alg)
    } catch (e) {
      cause = e
    }
    if (!payload) {
      throw new HTTPException(401, {
        message: 'Unauthorized',
        res: unauthorizedResponse({
          ctx,
          error: 'invalid_token',
          statusText: 'Unauthorized',
          errDescription: 'token verification failure',
        }),
        cause,
      })
    }

    ctx.set('jwtPayload', payload)

    await next()
  }
}

function unauthorizedResponse(opts: {
  ctx: Context
  error: string
  errDescription: string
  statusText?: string
}) {
  return new Response('Unauthorized', {
    status: 401,
    statusText: opts.statusText,
    headers: {
      'WWW-Authenticate': `Bearer realm="${opts.ctx.req.url}",error="${opts.error}",error_description="${opts.errDescription}"`,
    },
  })
}

export const verify = Jwt.verify
export const decode = Jwt.decode
export const sign = Jwt.sign

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/compress/index.test.ts
```typescript
import { stream, streamSSE } from '../../helper/streaming'
import { Hono } from '../../hono'
import { compress } from '.'

describe('Compress Middleware', () => {
  const app = new Hono()

  // Apply compress middleware to all routes
  app.use('*', compress())

  // Test routes
  app.get('/small', (c) => {
    c.header('Content-Type', 'text/plain')
    c.header('Content-Length', '5')
    return c.text('small')
  })
  app.get('/large', (c) => {
    c.header('Content-Type', 'text/plain')
    c.header('Content-Length', '1024')
    return c.text('a'.repeat(1024))
  })
  app.get('/small-json', (c) => {
    c.header('Content-Type', 'application/json')
    c.header('Content-Length', '26')
    return c.json({ message: 'Hello, World!' })
  })
  app.get('/large-json', (c) => {
    c.header('Content-Type', 'application/json')
    c.header('Content-Length', '1024')
    return c.json({ data: 'a'.repeat(1024), message: 'Large JSON' })
  })
  app.get('/no-transform', (c) => {
    c.header('Content-Type', 'text/plain')
    c.header('Content-Length', '1024')
    c.header('Cache-Control', 'no-transform')
    return c.text('a'.repeat(1024))
  })
  app.get('/jpeg-image', (c) => {
    c.header('Content-Type', 'image/jpeg')
    c.header('Content-Length', '1024')
    return c.body(new Uint8Array(1024)) // Simulated JPEG data
  })
  app.get('/already-compressed', (c) => {
    c.header('Content-Type', 'application/octet-stream')
    c.header('Content-Encoding', 'br')
    c.header('Content-Length', '1024')
    return c.body(new Uint8Array(1024)) // Simulated compressed data
  })
  app.get('/transfer-encoding-deflate', (c) => {
    c.header('Content-Type', 'application/octet-stream')
    c.header('Transfer-Encoding', 'deflate')
    c.header('Content-Length', '1024')
    return c.body(new Uint8Array(1024)) // Simulated deflate data
  })
  app.get('/chunked', (c) => {
    c.header('Content-Type', 'application/octet-stream')
    c.header('Transfer-Encoding', 'chunked')
    c.header('Content-Length', '1024')
    return c.body(new Uint8Array(1024)) // Simulated chunked data
  })
  app.get('/stream', (c) =>
    stream(c, async (stream) => {
      c.header('Content-Type', 'text/plain')
      // 60000 bytes
      for (let i = 0; i < 10000; i++) {
        await stream.write('chunk ')
      }
    })
  )
  app.get('/already-compressed-stream', (c) =>
    stream(c, async (stream) => {
      c.header('Content-Type', 'text/plain')
      c.header('Content-Encoding', 'br')
      // 60000 bytes
      for (let i = 0; i < 10000; i++) {
        await stream.write(new Uint8Array([0, 1, 2, 3, 4, 5])) // Simulated compressed data
      }
    })
  )
  app.get('/sse', (c) =>
    streamSSE(c, async (stream) => {
      for (let i = 0; i < 1000; i++) {
        await stream.writeSSE({ data: 'chunk' })
      }
    })
  )
  app.notFound((c) => c.text('Custom NotFound', 404))

  const testCompression = async (
    path: string,
    acceptEncoding: string,
    expectedEncoding: string | null
  ) => {
    const req = new Request(`http://localhost${path}`, {
      method: 'GET',
      headers: new Headers({ 'Accept-Encoding': acceptEncoding }),
    })
    const res = await app.request(req)
    expect(res.headers.get('Content-Encoding')).toBe(expectedEncoding)
    return res
  }

  describe('Compression Behavior', () => {
    it('should compress large responses with gzip', async () => {
      const res = await testCompression('/large', 'gzip', 'gzip')
      expect(res.headers.get('Content-Length')).toBeNull()
      expect((await res.arrayBuffer()).byteLength).toBeLessThan(1024)
    })

    it('should compress large responses with deflate', async () => {
      const res = await testCompression('/large', 'deflate', 'deflate')
      expect((await res.arrayBuffer()).byteLength).toBeLessThan(1024)
    })

    it('should prioritize gzip over deflate when both are accepted', async () => {
      await testCompression('/large', 'gzip, deflate', 'gzip')
    })

    it('should not compress small responses', async () => {
      const res = await testCompression('/small', 'gzip, deflate', null)
      expect(res.headers.get('Content-Length')).toBe('5')
    })

    it('should not compress when no Accept-Encoding is provided', async () => {
      await testCompression('/large', '', null)
    })

    it('should not compress images', async () => {
      const res = await testCompression('/jpeg-image', 'gzip', null)
      expect(res.headers.get('Content-Type')).toBe('image/jpeg')
      expect(res.headers.get('Content-Length')).toBe('1024')
    })

    it('should not compress already compressed responses', async () => {
      const res = await testCompression('/already-compressed', 'gzip', 'br')
      expect(res.headers.get('Content-Length')).toBe('1024')
    })

    it('should remove Content-Length when compressing', async () => {
      const res = await testCompression('/large', 'gzip', 'gzip')
      expect(res.headers.get('Content-Length')).toBeNull()
    })

    it('should not remove Content-Length when not compressing', async () => {
      const res = await testCompression('/jpeg-image', 'gzip', null)
      expect(res.headers.get('Content-Length')).toBeDefined()
    })

    it('should not compress transfer-encoding: deflate', async () => {
      const res = await testCompression('/transfer-encoding-deflate', 'gzip', null)
      expect(res.headers.get('Content-Length')).toBe('1024')
      expect(res.headers.get('Transfer-Encoding')).toBe('deflate')
    })

    it('should not compress transfer-encoding: chunked', async () => {
      const res = await testCompression('/chunked', 'gzip', null)
      expect(res.headers.get('Content-Length')).toBe('1024')
      expect(res.headers.get('Transfer-Encoding')).toBe('chunked')
    })
  })

  describe('JSON Handling', () => {
    it('should not compress small JSON responses', async () => {
      const res = await testCompression('/small-json', 'gzip', null)
      expect(res.headers.get('Content-Length')).toBe('26')
    })

    it('should compress large JSON responses', async () => {
      const res = await testCompression('/large-json', 'gzip', 'gzip')
      expect(res.headers.get('Content-Length')).toBeNull()
      const decompressed = await decompressResponse(res)
      const json = JSON.parse(decompressed)
      expect(json.data.length).toBe(1024)
      expect(json.message).toBe('Large JSON')
    })
  })

  describe('Streaming Responses', () => {
    it('should compress streaming responses written in multiple chunks', async () => {
      const res = await testCompression('/stream', 'gzip', 'gzip')
      const decompressed = await decompressResponse(res)
      expect(decompressed.length).toBe(60000)
    })

    it('should not compress already compressed streaming responses', async () => {
      const res = await testCompression('/already-compressed-stream', 'gzip', 'br')
      expect((await res.arrayBuffer()).byteLength).toBe(60000)
    })

    it('should not compress server-sent events', async () => {
      const res = await testCompression('/sse', 'gzip', null)
      expect((await res.arrayBuffer()).byteLength).toBe(13000)
    })
  })

  describe('Edge Cases', () => {
    it('should not compress responses with Cache-Control: no-transform', async () => {
      await testCompression('/no-transform', 'gzip', null)
    })

    it('should handle HEAD requests without compression', async () => {
      const req = new Request('http://localhost/large', {
        method: 'HEAD',
        headers: new Headers({ 'Accept-Encoding': 'gzip' }),
      })
      const res = await app.request(req)
      expect(res.headers.get('Content-Encoding')).toBeNull()
    })

    it('should compress custom 404 Not Found responses', async () => {
      const res = await testCompression('/not-found', 'gzip', 'gzip')
      expect(res.status).toBe(404)
      const decompressed = await decompressResponse(res)
      expect(decompressed).toBe('Custom NotFound')
    })
  })
})

async function decompressResponse(res: Response): Promise<string> {
  const decompressedStream = res.body!.pipeThrough(new DecompressionStream('gzip'))
  const decompressedResponse = new Response(decompressedStream)
  return await decompressedResponse.text()
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/compress/index.ts
````typescript
/**
 * @module
 * Compress Middleware for Hono.
 */

import type { MiddlewareHandler } from '../../types'
import { COMPRESSIBLE_CONTENT_TYPE_REGEX } from '../../utils/compress'

const ENCODING_TYPES = ['gzip', 'deflate'] as const
const cacheControlNoTransformRegExp = /(?:^|,)\s*?no-transform\s*?(?:,|$)/i

interface CompressionOptions {
  encoding?: (typeof ENCODING_TYPES)[number]
  threshold?: number
}

/**
 * Compress Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/compress}
 *
 * @param {CompressionOptions} [options] - The options for the compress middleware.
 * @param {'gzip' | 'deflate'} [options.encoding] - The compression scheme to allow for response compression. Either 'gzip' or 'deflate'. If not defined, both are allowed and will be used based on the Accept-Encoding header. 'gzip' is prioritized if this option is not provided and the client provides both in the Accept-Encoding header.
 * @param {number} [options.threshold=1024] - The minimum size in bytes to compress. Defaults to 1024 bytes.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use(compress())
 * ```
 */
export const compress = (options?: CompressionOptions): MiddlewareHandler => {
  const threshold = options?.threshold ?? 1024

  return async function compress(ctx, next) {
    await next()

    const contentLength = ctx.res.headers.get('Content-Length')

    // Check if response should be compressed
    if (
      ctx.res.headers.has('Content-Encoding') || // already encoded
      ctx.res.headers.has('Transfer-Encoding') || // already encoded or chunked
      ctx.req.method === 'HEAD' || // HEAD request
      (contentLength && Number(contentLength) < threshold) || // content-length below threshold
      !shouldCompress(ctx.res) || // not compressible type
      !shouldTransform(ctx.res) // cache-control: no-transform
    ) {
      return
    }

    const accepted = ctx.req.header('Accept-Encoding')
    const encoding =
      options?.encoding ?? ENCODING_TYPES.find((encoding) => accepted?.includes(encoding))
    if (!encoding || !ctx.res.body) {
      return
    }

    // Compress the response
    const stream = new CompressionStream(encoding)
    ctx.res = new Response(ctx.res.body.pipeThrough(stream), ctx.res)
    ctx.res.headers.delete('Content-Length')
    ctx.res.headers.set('Content-Encoding', encoding)
  }
}

const shouldCompress = (res: Response) => {
  const type = res.headers.get('Content-Type')
  return type && COMPRESSIBLE_CONTENT_TYPE_REGEX.test(type)
}

const shouldTransform = (res: Response) => {
  const cacheControl = res.headers.get('Cache-Control')
  // Don't compress for Cache-Control: no-transform
  // https://tools.ietf.org/html/rfc7234#section-5.2.2.4
  return !cacheControl || !cacheControlNoTransformRegExp.test(cacheControl)
}

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/logger/index.test.ts
```typescript
import { Hono } from '../../hono'
import { logger } from '.'

describe('Logger by Middleware', () => {
  let app: Hono
  let log: string

  beforeEach(() => {
    function sleep(time: number) {
      return new Promise((resolve) => setTimeout(resolve, time))
    }

    app = new Hono()

    const logFn = (str: string) => {
      log = str
    }

    const shortRandomString = 'hono'
    const longRandomString = 'hono'.repeat(1000)

    app.use('*', logger(logFn))
    app.get('/short', (c) => c.text(shortRandomString))
    app.get('/long', (c) => c.text(longRandomString))
    app.get('/seconds', async (c) => {
      await sleep(1000)

      return c.text(longRandomString)
    })
    app.get('/empty', (c) => c.text(''))
    app.get('/redirect', (c) => {
      return c.redirect('/empty', 301)
    })
    app.get('/server-error', (c) => {
      const res = new Response('', { status: 511 })
      if (c.req.query('status')) {
        // test status code not yet supported by runtime `Response` object
        Object.defineProperty(res, 'status', { value: parseInt(c.req.query('status') as string) })
      }
      return res
    })
  })

  it('Log status 200 with empty body', async () => {
    const res = await app.request('http://localhost/empty')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(log.startsWith('--> GET /empty \x1b[32m200\x1b[0m')).toBe(true)
    expect(log).toMatch(/m?s$/)
  })

  it('Log status 200 with small body', async () => {
    const res = await app.request('http://localhost/short')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(log.startsWith('--> GET /short \x1b[32m200\x1b[0m')).toBe(true)
    expect(log).toMatch(/m?s$/)
  })

  it('Log status 200 with small body and query param', async () => {
    const res = await app.request('http://localhost/short?foo=bar')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(log.startsWith('--> GET /short?foo=bar \x1b[32m200\x1b[0m')).toBe(true)
    expect(log).toMatch(/m?s$/)
  })

  it('Log status 200 with big body', async () => {
    const res = await app.request('http://localhost/long')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(log.startsWith('--> GET /long \x1b[32m200\x1b[0m')).toBe(true)
    expect(log).toMatch(/m?s$/)
  })

  it('Time in seconds', async () => {
    const res = await app.request('http://localhost/seconds')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(log.startsWith('--> GET /seconds \x1b[32m200\x1b[0m')).toBe(true)
    expect(log).toMatch(/1s/)
  })

  it('Log status 301 with empty body', async () => {
    const res = await app.request('http://localhost/redirect')
    expect(res).not.toBeNull()
    expect(res.status).toBe(301)
    expect(log.startsWith('--> GET /redirect \x1b[36m301\x1b[0m')).toBe(true)
    expect(log).toMatch(/m?s$/)
  })

  it('Log status 404', async () => {
    const msg = 'Default 404 Not Found'
    app.all('*', (c) => {
      return c.text(msg, 404)
    })
    const res = await app.request('http://localhost/notfound')
    expect(res).not.toBeNull()
    expect(res.status).toBe(404)
    expect(log.startsWith('--> GET /notfound \x1b[33m404\x1b[0m')).toBe(true)
    expect(log).toMatch(/m?s$/)
  })

  it('Log status 511 with empty body', async () => {
    const res = await app.request('http://localhost/server-error')
    expect(res).not.toBeNull()
    expect(res.status).toBe(511)
    expect(log.startsWith('--> GET /server-error \x1b[31m511\x1b[0m')).toBe(true)
    expect(log).toMatch(/m?s$/)
  })

  it('Log status 100', async () => {
    const res = await app.request('http://localhost/server-error?status=100')
    expect(res).not.toBeNull()
    expect(res.status).toBe(100)
    expect(log.startsWith('--> GET /server-error?status=100 100')).toBe(true)
    expect(log).toMatch(/m?s$/)
  })

  it('Log status 700', async () => {
    const res = await app.request('http://localhost/server-error?status=700')
    expect(res).not.toBeNull()
    expect(res.status).toBe(700)
    expect(log.startsWith('--> GET /server-error?status=700 700')).toBe(true)
    expect(log).toMatch(/m?s$/)
  })
})

describe('Logger by Middleware in NO_COLOR', () => {
  let app: Hono
  let log: string

  beforeEach(() => {
    vi.stubEnv('NO_COLOR', '1')
    function sleep(time: number) {
      return new Promise((resolve) => setTimeout(resolve, time))
    }

    app = new Hono()

    const logFn = (str: string) => {
      log = str
    }

    const shortRandomString = 'hono'
    const longRandomString = 'hono'.repeat(1000)

    app.use('*', logger(logFn))
    app.get('/short', (c) => c.text(shortRandomString))
    app.get('/long', (c) => c.text(longRandomString))
    app.get('/seconds', async (c) => {
      await sleep(1000)

      return c.text(longRandomString)
    })
    app.get('/empty', (c) => c.text(''))
  })
  afterAll(() => {
    vi.unstubAllEnvs()
  })
  it('Log status 200 with empty body', async () => {
    const res = await app.request('http://localhost/empty')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(log.startsWith('--> GET /empty 200')).toBe(true)
    expect(log).toMatch(/m?s$/)
  })

  it('Log status 200 with small body', async () => {
    const res = await app.request('http://localhost/short')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(log.startsWith('--> GET /short 200')).toBe(true)
    expect(log).toMatch(/m?s$/)
  })

  it('Log status 200 with big body', async () => {
    const res = await app.request('http://localhost/long')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(log.startsWith('--> GET /long 200')).toBe(true)
    expect(log).toMatch(/m?s$/)
  })

  it('Time in seconds', async () => {
    const res = await app.request('http://localhost/seconds')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(log.startsWith('--> GET /seconds 200')).toBe(true)
    expect(log).toMatch(/1s/)
  })

  it('Log status 404', async () => {
    const msg = 'Default 404 Not Found'
    app.all('*', (c) => {
      return c.text(msg, 404)
    })
    const res = await app.request('http://localhost/notfound')
    expect(res).not.toBeNull()
    expect(res.status).toBe(404)
    expect(log.startsWith('--> GET /notfound 404')).toBe(true)
    expect(log).toMatch(/m?s$/)
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/logger/index.ts
````typescript
/**
 * @module
 * Logger Middleware for Hono.
 */

import type { MiddlewareHandler } from '../../types'
import { getColorEnabled } from '../../utils/color'

enum LogPrefix {
  Outgoing = '-->',
  Incoming = '<--',
  Error = 'xxx',
}

const humanize = (times: string[]) => {
  const [delimiter, separator] = [',', '.']

  const orderTimes = times.map((v) => v.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1' + delimiter))

  return orderTimes.join(separator)
}

const time = (start: number) => {
  const delta = Date.now() - start
  return humanize([delta < 1000 ? delta + 'ms' : Math.round(delta / 1000) + 's'])
}

const colorStatus = (status: number) => {
  const colorEnabled = getColorEnabled()
  if (colorEnabled) {
    switch ((status / 100) | 0) {
      case 5: // red = error
        return `\x1b[31m${status}\x1b[0m`
      case 4: // yellow = warning
        return `\x1b[33m${status}\x1b[0m`
      case 3: // cyan = redirect
        return `\x1b[36m${status}\x1b[0m`
      case 2: // green = success
        return `\x1b[32m${status}\x1b[0m`
    }
  }
  // Fallback to unsupported status code.
  // E.g.) Bun and Deno supports new Response with 101, but Node.js does not.
  // And those may evolve to accept more status.
  return `${status}`
}

type PrintFunc = (str: string, ...rest: string[]) => void

function log(
  fn: PrintFunc,
  prefix: string,
  method: string,
  path: string,
  status: number = 0,
  elapsed?: string
) {
  const out =
    prefix === LogPrefix.Incoming
      ? `${prefix} ${method} ${path}`
      : `${prefix} ${method} ${path} ${colorStatus(status)} ${elapsed}`
  fn(out)
}

/**
 * Logger Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/logger}
 *
 * @param {PrintFunc} [fn=console.log] - Optional function for customized logging behavior.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use(logger())
 * app.get('/', (c) => c.text('Hello Hono!'))
 * ```
 */
export const logger = (fn: PrintFunc = console.log): MiddlewareHandler => {
  return async function logger(c, next) {
    const { method, url } = c.req

    const path = url.slice(url.indexOf('/', 8))

    log(fn, LogPrefix.Incoming, method, path)

    const start = Date.now()

    await next()

    log(fn, LogPrefix.Outgoing, method, path, c.res.status, time(start))
  }
}

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/cache/index.test.ts
```typescript
import type { ExecutionContext } from '../../context'
import { Hono } from '../../hono'
import { cache } from '.'

// Mock
class Context implements ExecutionContext {
  passThroughOnException(): void {
    throw new Error('Method not implemented.')
  }
  async waitUntil(promise: Promise<unknown>): Promise<void> {
    await promise
  }
}

describe('Customizing Caching Keys', () => {
  const app = new Hono()

  const dynamicCacheName = 'dynamic-cache-name'
  app.use(
    '/dynamic-cache-name/*',
    cache({
      cacheName: async () => dynamicCacheName,
      wait: true,
      cacheControl: 'max-age=10',
    })
  )
  app.get('/dynamic-cache-name/', (c) => {
    return c.text('cached')
  })

  const dynamicCacheKey = 'dynamic-cache-key'
  app.use(
    '/dynamic-cache-key/*',
    cache({
      cacheName: 'my-app-v1',
      wait: true,
      cacheControl: 'max-age=10',
      keyGenerator: async () => dynamicCacheKey,
    })
  )
  app.get('/dynamic-cache-key/', (c) => {
    return c.text('cached')
  })

  app.use(
    '/dynamic-cache/*',
    cache({
      cacheName: async () => dynamicCacheName,
      cacheControl: 'max-age=10',
      keyGenerator: async () => dynamicCacheKey,
    })
  )
  app.get('/dynamic-cache/', (c) => {
    return c.text('cached')
  })

  const ctx = new Context()

  it('Should use dynamically generated cache name', async () => {
    await app.request('http://localhost/dynamic-cache-name/', undefined, ctx)
    const cache = await caches.open(dynamicCacheName)
    const keys = Array.from(await cache.keys())
    expect(keys.length).toBe(1)
  })

  it('Should use dynamically generated cache key', async () => {
    await app.request('http://localhost/dynamic-cache-key/')
    const cache = await caches.open('my-app-v1')
    const response = await cache.match(dynamicCacheKey)
    expect(response).not.toBeNull()
  })

  it('Should retrieve cached response with dynamic cache name and key', async () => {
    await app.request('http://localhost/dynamic-cache/', undefined, undefined, ctx)
    const res = await app.request('http://localhost/dynamic-cache/', undefined, undefined, ctx)
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('cache-control')).toBe('max-age=10')
  })
})

describe('Cache Middleware', () => {
  const app = new Hono()

  let count = 1
  // wait, because this is test.
  // You don't have to set `wait: true`.
  app.use('/wait/*', cache({ cacheName: 'my-app-v1', wait: true, cacheControl: 'max-age=10' }))
  app.get('/wait/', (c) => {
    c.header('X-Count', `${count}`)
    count++
    return c.text('cached')
  })

  // Default, use `waitUntil`
  app.use('/not-wait/*', cache({ cacheName: 'my-app-v1', cacheControl: 'max-age=10' }))
  app.get('/not-wait/', (c) => {
    return c.text('not cached')
  })

  app.use('/wait2/*', cache({ cacheName: 'my-app-v1', wait: true, cacheControl: 'max-age=10' }))
  app.use('/wait2/*', cache({ cacheName: 'my-app-v1', wait: true, cacheControl: 'Max-Age=20' }))
  app.get('/wait2/', (c) => {
    return c.text('cached')
  })

  app.use('/wait3/*', cache({ cacheName: 'my-app-v1', wait: true, cacheControl: 'max-age=10' }))
  app.use(
    '/wait3/private/*',
    cache({ cacheName: 'my-app-v1', wait: true, cacheControl: 'private' })
  )
  app.get('/wait3/private/', (c) => {
    return c.text('cached')
  })

  app.use('/wait4/*', cache({ cacheName: 'my-app-v1', wait: true, cacheControl: 'max-age=10' }))
  app.get('/wait4/', (c) => {
    c.header('Cache-Control', 'private')
    return c.text('cached')
  })

  app.use('/vary1/*', cache({ cacheName: 'my-app-v1', wait: true, vary: ['Accept'] }))
  app.get('/vary1/', (c) => {
    return c.text('cached')
  })

  app.use('/vary2/*', cache({ cacheName: 'my-app-v1', wait: true, vary: ['Accept'] }))
  app.get('/vary2/', (c) => {
    c.header('Vary', 'Accept-Encoding')
    return c.text('cached')
  })

  app.use(
    '/vary3/*',
    cache({ cacheName: 'my-app-v1', wait: true, vary: ['Accept', 'Accept-Encoding'] })
  )
  app.get('/vary3/', (c) => {
    c.header('Vary', 'Accept-Language')
    return c.text('cached')
  })

  app.use(
    '/vary4/*',
    cache({ cacheName: 'my-app-v1', wait: true, vary: ['Accept', 'Accept-Encoding'] })
  )
  app.get('/vary4/', (c) => {
    c.header('Vary', 'Accept, Accept-Language')
    return c.text('cached')
  })

  app.use('/vary5/*', cache({ cacheName: 'my-app-v1', wait: true, vary: 'Accept' }))
  app.get('/vary5/', (c) => {
    return c.text('cached with Accept and Accept-Encoding headers')
  })

  app.use(
    '/vary6/*',
    cache({ cacheName: 'my-app-v1', wait: true, vary: 'Accept, Accept-Encoding' })
  )
  app.get('/vary6/', (c) => {
    c.header('Vary', 'Accept, Accept-Language')
    return c.text('cached with Accept and Accept-Encoding headers as array')
  })

  app.use('/vary7/*', cache({ cacheName: 'my-app-v1', wait: true, vary: ['Accept'] }))
  app.get('/vary7/', (c) => {
    c.header('Vary', '*')
    return c.text('cached')
  })

  app.use(
    '/not-found/*',
    cache({ cacheName: 'my-app-v1', wait: true, cacheControl: 'max-age=10', vary: ['Accept'] })
  )

  const ctx = new Context()

  it('Should return cached response', async () => {
    await app.request('http://localhost/wait/')
    const res = await app.request('http://localhost/wait/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('cache-control')).toBe('max-age=10')
    expect(res.headers.get('x-count')).toBe('1')
  })

  it('Should not return cached response', async () => {
    await app.fetch(new Request('http://localhost/not-wait/'), undefined, ctx)
    const res = await app.fetch(new Request('http://localhost/not-wait/'), undefined, ctx)
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('cache-control')).toBe('max-age=10')
  })

  it('Should not return duplicate header values', async () => {
    const res = await app.request('/wait2/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('cache-control')).toBe('max-age=20')
  })

  it('Should return composed middleware header values', async () => {
    const res = await app.request('/wait3/private/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('cache-control')).toBe('private, max-age=10')
  })

  it('Should return composed handler header values', async () => {
    const res = await app.request('/wait4/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('cache-control')).toBe('private, max-age=10')
  })

  it('Should correctly apply a single Vary header from middleware', async () => {
    const res = await app.request('http://localhost/vary1/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('vary')).toBe('accept')
  })

  it('Should merge Vary headers from middleware and handler without duplicating', async () => {
    const res = await app.request('http://localhost/vary2/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('vary')).toBe('accept, accept-encoding')
  })

  it('Should deduplicate while merging multiple Vary headers from middleware and handler', async () => {
    const res = await app.request('http://localhost/vary3/')
    expect(res.headers.get('vary')).toBe('accept, accept-encoding, accept-language')
  })

  it('Should prevent duplication of Vary headers when identical ones are set by both middleware and handler', async () => {
    const res = await app.request('http://localhost/vary4/')
    expect(res.headers.get('vary')).toBe('accept, accept-encoding, accept-language')
  })

  it('Should correctly apply and return a single Vary header with Accept specified by middleware', async () => {
    const res = await app.request('http://localhost/vary5/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('vary')).toBe('accept')
  })

  it('Should merge Vary headers specified by middleware as a string with additional headers added by handler', async () => {
    const res = await app.request('http://localhost/vary6/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('vary')).toBe('accept, accept-encoding, accept-language')
  })

  it('Should prioritize the "*" Vary header from handler over any set by middleware', async () => {
    const res = await app.request('http://localhost/vary7/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('vary')).toBe('*')
  })

  it('Should not allow "*" as a Vary header in middleware configuration due to its impact on caching effectiveness', async () => {
    expect(() => cache({ cacheName: 'my-app-v1', wait: true, vary: ['*'] })).toThrow()
    expect(() => cache({ cacheName: 'my-app-v1', wait: true, vary: '*' })).toThrow()
  })

  it('Should not cache if it is not found', async () => {
    const res = await app.request('/not-found/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(404)
    expect(res.headers.get('cache-control')).toBeFalsy()
    expect(res.headers.get('vary')).toBeFalsy()
  })

  it('Should not be enabled if caches is not defined', async () => {
    vi.stubGlobal('caches', undefined)
    const app = new Hono()
    app.use(cache({ cacheName: 'my-app-v1', cacheControl: 'max-age=10' }))
    app.get('/', (c) => {
      return c.text('cached')
    })
    expect(caches).toBeUndefined()
    const res = await app.request('/')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('cache-control')).toBe(null)
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/cache/index.ts
````typescript
/**
 * @module
 * Cache Middleware for Hono.
 */

import type { Context } from '../../context'
import type { MiddlewareHandler } from '../../types'

/**
 * Cache Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/cache}
 *
 * @param {Object} options - The options for the cache middleware.
 * @param {string | Function} options.cacheName - The name of the cache. Can be used to store multiple caches with different identifiers.
 * @param {boolean} [options.wait=false] - A boolean indicating if Hono should wait for the Promise of the `cache.put` function to resolve before continuing with the request. Required to be true for the Deno environment.
 * @param {string} [options.cacheControl] - A string of directives for the `Cache-Control` header.
 * @param {string | string[]} [options.vary] - Sets the `Vary` header in the response. If the original response header already contains a `Vary` header, the values are merged, removing any duplicates.
 * @param {Function} [options.keyGenerator] - Generates keys for every request in the `cacheName` store. This can be used to cache data based on request parameters or context parameters.
 * @returns {MiddlewareHandler} The middleware handler function.
 * @throws {Error} If the `vary` option includes "*".
 *
 * @example
 * ```ts
 * app.get(
 *   '*',
 *   cache({
 *     cacheName: 'my-app',
 *     cacheControl: 'max-age=3600',
 *   })
 * )
 * ```
 */
export const cache = (options: {
  cacheName: string | ((c: Context) => Promise<string> | string)
  wait?: boolean
  cacheControl?: string
  vary?: string | string[]
  keyGenerator?: (c: Context) => Promise<string> | string
}): MiddlewareHandler => {
  if (!globalThis.caches) {
    console.log('Cache Middleware is not enabled because caches is not defined.')
    return async (_c, next) => await next()
  }

  if (options.wait === undefined) {
    options.wait = false
  }

  const cacheControlDirectives = options.cacheControl
    ?.split(',')
    .map((directive) => directive.toLowerCase())
  const varyDirectives = Array.isArray(options.vary)
    ? options.vary
    : options.vary?.split(',').map((directive) => directive.trim())
  // RFC 7231 Section 7.1.4 specifies that "*" is not allowed in Vary header.
  // See: https://datatracker.ietf.org/doc/html/rfc7231#section-7.1.4
  if (options.vary?.includes('*')) {
    throw new Error(
      'Middleware vary configuration cannot include "*", as it disallows effective caching.'
    )
  }

  const addHeader = (c: Context) => {
    if (cacheControlDirectives) {
      const existingDirectives =
        c.res.headers
          .get('Cache-Control')
          ?.split(',')
          .map((d) => d.trim().split('=', 1)[0]) ?? []
      for (const directive of cacheControlDirectives) {
        let [name, value] = directive.trim().split('=', 2)
        name = name.toLowerCase()
        if (!existingDirectives.includes(name)) {
          c.header('Cache-Control', `${name}${value ? `=${value}` : ''}`, { append: true })
        }
      }
    }

    if (varyDirectives) {
      const existingDirectives =
        c.res.headers
          .get('Vary')
          ?.split(',')
          .map((d) => d.trim()) ?? []

      const vary = Array.from(
        new Set(
          [...existingDirectives, ...varyDirectives].map((directive) => directive.toLowerCase())
        )
      ).sort()

      if (vary.includes('*')) {
        c.header('Vary', '*')
      } else {
        c.header('Vary', vary.join(', '))
      }
    }
  }

  return async function cache(c, next) {
    let key = c.req.url
    if (options.keyGenerator) {
      key = await options.keyGenerator(c)
    }

    const cacheName =
      typeof options.cacheName === 'function' ? await options.cacheName(c) : options.cacheName
    const cache = await caches.open(cacheName)
    const response = await cache.match(key)
    if (response) {
      return new Response(response.body, response)
    }

    await next()
    if (!c.res.ok) {
      return
    }
    addHeader(c)
    const res = c.res.clone()
    if (options.wait) {
      await cache.put(key, res)
    } else {
      c.executionCtx.waitUntil(cache.put(key, res))
    }
  }
}

````
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
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/secure-headers/index.test.ts
```typescript
import { Hono } from '../../hono'
import { poweredBy } from '../powered-by'
import { NONCE, secureHeaders } from '.'
import type { ContentSecurityPolicyOptionHandler } from '.'

declare module '../..' {
  interface ContextVariableMap {
    ['test-scriptSrc-nonce']?: string
    ['test-styleSrc-nonce']?: string
  }
}

describe('Secure Headers Middleware', () => {
  it('default middleware', async () => {
    const app = new Hono()
    app.use('*', secureHeaders())
    app.get('/test', async (ctx) => {
      return ctx.text('test')
    })

    const res = await app.request('/test')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Frame-Options')).toEqual('SAMEORIGIN')
    expect(res.headers.get('Strict-Transport-Security')).toEqual(
      'max-age=15552000; includeSubDomains'
    )
    expect(res.headers.get('X-Download-Options')).toEqual('noopen')
    expect(res.headers.get('X-XSS-Protection')).toEqual('0')
    expect(res.headers.get('X-Powered-By')).toBeNull()
    expect(res.headers.get('X-DNS-Prefetch-Control')).toEqual('off')
    expect(res.headers.get('X-Content-Type-Options')).toEqual('nosniff')
    expect(res.headers.get('Referrer-Policy')).toEqual('no-referrer')
    expect(res.headers.get('X-Permitted-Cross-Domain-Policies')).toEqual('none')
    expect(res.headers.get('Cross-Origin-Resource-Policy')).toEqual('same-origin')
    expect(res.headers.get('Cross-Origin-Opener-Policy')).toEqual('same-origin')
    expect(res.headers.get('Origin-Agent-Cluster')).toEqual('?1')
    expect(res.headers.get('Permissions-Policy')).toBeNull()
    expect(res.headers.get('Content-Security-Policy')).toBeFalsy()
    expect(res.headers.get('Content-Security-Policy-ReportOnly')).toBeFalsy()
  })

  it('all headers enabled', async () => {
    const app = new Hono()
    app.use(
      '*',
      secureHeaders({
        contentSecurityPolicy: {
          defaultSrc: ["'self'"],
        },
        contentSecurityPolicyReportOnly: {
          defaultSrc: ["'self'"],
        },
        crossOriginEmbedderPolicy: true,
        permissionsPolicy: {
          camera: [],
        },
      })
    )
    app.get('/test', async (ctx) => {
      return ctx.text('test')
    })

    const res = await app.request('/test')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Frame-Options')).toEqual('SAMEORIGIN')
    expect(res.headers.get('Strict-Transport-Security')).toEqual(
      'max-age=15552000; includeSubDomains'
    )
    expect(res.headers.get('X-Download-Options')).toEqual('noopen')
    expect(res.headers.get('X-XSS-Protection')).toEqual('0')
    expect(res.headers.get('X-Powered-By')).toBeNull()
    expect(res.headers.get('X-DNS-Prefetch-Control')).toEqual('off')
    expect(res.headers.get('X-Content-Type-Options')).toEqual('nosniff')
    expect(res.headers.get('Referrer-Policy')).toEqual('no-referrer')
    expect(res.headers.get('X-Permitted-Cross-Domain-Policies')).toEqual('none')
    expect(res.headers.get('Cross-Origin-Resource-Policy')).toEqual('same-origin')
    expect(res.headers.get('Cross-Origin-Opener-Policy')).toEqual('same-origin')
    expect(res.headers.get('Origin-Agent-Cluster')).toEqual('?1')
    expect(res.headers.get('Cross-Origin-Embedder-Policy')).toEqual('require-corp')
    expect(res.headers.get('Permissions-Policy')).toEqual('camera=()')
    expect(res.headers.get('Content-Security-Policy')).toEqual("default-src 'self'")
    expect(res.headers.get('Content-Security-Policy-Report-Only')).toEqual("default-src 'self'")
  })

  it('specific headers disabled', async () => {
    const app = new Hono()
    app.use('*', secureHeaders({ xFrameOptions: false, xXssProtection: false }))
    app.get('/test', async (ctx) => {
      return ctx.text('test')
    })

    const res = await app.request('/test')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Frame-Options')).toBeNull()
    expect(res.headers.get('Strict-Transport-Security')).toEqual(
      'max-age=15552000; includeSubDomains'
    )
    expect(res.headers.get('X-Download-Options')).toEqual('noopen')
    expect(res.headers.get('X-XSS-Protection')).toBeNull()
    expect(res.headers.get('X-Powered-By')).toBeNull()
    expect(res.headers.get('X-DNS-Prefetch-Control')).toEqual('off')
    expect(res.headers.get('X-Content-Type-Options')).toEqual('nosniff')
    expect(res.headers.get('Referrer-Policy')).toEqual('no-referrer')
    expect(res.headers.get('X-Permitted-Cross-Domain-Policies')).toEqual('none')
    expect(res.headers.get('Cross-Origin-Resource-Policy')).toEqual('same-origin')
    expect(res.headers.get('Cross-Origin-Opener-Policy')).toEqual('same-origin')
    expect(res.headers.get('Permissions-Policy')).toBeNull()
    expect(res.headers.get('Origin-Agent-Cluster')).toEqual('?1')
  })

  it('should remove x-powered-by header', async () => {
    const appBefore = new Hono()
    appBefore.use('*', secureHeaders())
    appBefore.use('*', poweredBy())

    const resBefore = await appBefore.request('/')
    expect(resBefore.headers.get('x-powered-by')).toBeFalsy()

    const appAfter = new Hono()
    appAfter.use('*', poweredBy())
    appAfter.use('*', secureHeaders())

    const resAfter = await appAfter.request('/')
    expect(resAfter.headers.get('x-powered-by')).toBe('Hono')
  })

  it('should override Strict-Transport-Security header after middleware', async () => {
    const app = new Hono()
    app.use('/test1', secureHeaders())

    app.all('*', async (c) => {
      c.res.headers.set('Strict-Transport-Security', 'Hono')
      return c.text('header updated')
    })

    const res1 = await app.request('/test1')
    expect(res1.headers.get('Strict-Transport-Security')).toEqual(
      'max-age=15552000; includeSubDomains'
    )

    const res2 = await app.request('/test2')
    expect(res2.headers.get('Strict-Transport-Security')).toEqual('Hono')
  })

  it('should use custom value when overridden', async () => {
    const app = new Hono()
    app.use(
      '/test',
      secureHeaders({
        strictTransportSecurity: 'max-age=31536000; includeSubDomains; preload;',
        xFrameOptions: 'DENY',
        xXssProtection: '1',
      })
    )

    const res = await app.request('/test')
    expect(res.headers.get('Strict-Transport-Security')).toEqual(
      'max-age=31536000; includeSubDomains; preload;'
    )
    expect(res.headers.get('X-FRAME-OPTIONS')).toEqual('DENY')
    expect(res.headers.get('X-XSS-Protection')).toEqual('1')
  })

  it('should set Permission-Policy header correctly', async () => {
    const app = new Hono()
    app.use(
      '/test',
      secureHeaders({
        permissionsPolicy: {
          fullscreen: ['self'],
          bluetooth: ['none'],
          payment: ['self', 'example.com'],
          syncXhr: [],
          camera: false,
          microphone: true,
          geolocation: ['*'],
          usb: ['self', 'https://a.example.com', 'https://b.example.com'],
          accelerometer: ['https://*.example.com'],
          gyroscope: ['src'],
          magnetometer: ['https://a.example.com', 'https://b.example.com'],
        },
      })
    )

    const res = await app.request('/test')
    expect(res.headers.get('Permissions-Policy')).toEqual(
      'fullscreen=(self), bluetooth=none, payment=(self "example.com"), sync-xhr=(), camera=none, microphone=*, ' +
        'geolocation=*, usb=(self "https://a.example.com" "https://b.example.com"), ' +
        'accelerometer=("https://*.example.com"), gyroscope=(src), ' +
        'magnetometer=("https://a.example.com" "https://b.example.com")'
    )
  })

  it('Remove X-Powered-By', async () => {
    const app = new Hono()

    app.get('/test', secureHeaders(), poweredBy(), async (c) => {
      return c.text('Hono is hot')
    })

    app.get(
      '/test2',
      secureHeaders({
        removePoweredBy: false,
      }),
      poweredBy(),
      async (c) => {
        return c.text('Hono is hot')
      }
    )

    const res = await app.request('/test')
    const poweredby = res.headers.get('X-Powered-By')
    expect(poweredby).toEqual(null)
    expect(await res.text()).toEqual('Hono is hot')

    const res2 = await app.request('/test2')
    const poweredby2 = res2.headers.get('X-Powered-By')
    expect(poweredby2).toEqual('Hono')
    expect(await res2.text()).toEqual('Hono is hot')
  })

  describe.each([
    { cspSettingName: 'contentSecurityPolicy', cspHeaderName: 'Content-Security-Policy' },
    {
      cspSettingName: 'contentSecurityPolicyReportOnly',
      cspHeaderName: 'Content-Security-Policy-Report-Only',
    },
  ])('CSP Setting ($cspSettingName)', ({ cspSettingName, cspHeaderName }) => {
    it('CSP Setting', async () => {
      const app = new Hono()
      app.use(
        '/test',
        secureHeaders({
          [cspSettingName]: {
            defaultSrc: ["'self'"],
            baseUri: ["'self'"],
            fontSrc: ["'self'", 'https:', 'data:'],
            frameAncestors: ["'self'"],
            imgSrc: ["'self'", 'data:'],
            objectSrc: ["'none'"],
            scriptSrc: ["'self'"],
            scriptSrcAttr: ["'none'"],
            styleSrc: ["'self'", 'https:', "'unsafe-inline'"],
          },
        })
      )

      app.all('*', async (c) => {
        c.res.headers.set('Strict-Transport-Security', 'Hono')
        return c.text('header updated')
      })

      const res = await app.request('/test')
      expect(res.headers.get(cspHeaderName)).toEqual(
        "default-src 'self'; base-uri 'self'; font-src 'self' https: data:; frame-ancestors 'self'; img-src 'self' data:; object-src 'none'; script-src 'self'; script-src-attr 'none'; style-src 'self' https: 'unsafe-inline'"
      )
    })

    it('CSP Setting one only', async () => {
      const app = new Hono()
      app.use(
        '/test',
        secureHeaders({
          [cspSettingName]: {
            defaultSrc: ["'self'"],
          },
        })
      )

      app.all('*', async (c) => {
        return c.text('header updated')
      })

      const res = await app.request('/test')
      expect(res.headers.get(cspHeaderName)).toEqual("default-src 'self'")
    })

    it('No CSP Setting', async () => {
      const app = new Hono()
      app.use('/test', secureHeaders({ [cspSettingName]: {} }))

      app.all('*', async (c) => {
        return c.text('header updated')
      })

      const res = await app.request('/test')
      expect(res.headers.get(cspHeaderName)).toEqual('')
    })

    it('CSP with reportTo', async () => {
      const app = new Hono()
      app.use(
        '/test1',
        secureHeaders({
          reportingEndpoints: [
            {
              name: 'endpoint-1',
              url: 'https://example.com/reports',
            },
          ],
          [cspSettingName]: {
            defaultSrc: ["'self'"],
            reportTo: 'endpoint-1',
          },
        })
      )

      app.use(
        '/test2',
        secureHeaders({
          reportTo: [
            {
              group: 'endpoint-1',
              max_age: 10886400,
              endpoints: [{ url: 'https://example.com/reports' }],
            },
          ],
          [cspSettingName]: {
            defaultSrc: ["'self'"],
            reportTo: 'endpoint-1',
          },
        })
      )

      app.use(
        '/test3',
        secureHeaders({
          reportTo: [
            {
              group: 'g1',
              max_age: 10886400,
              endpoints: [
                { url: 'https://a.example.com/reports' },
                { url: 'https://b.example.com/reports' },
              ],
            },
            {
              group: 'g2',
              max_age: 10886400,
              endpoints: [
                { url: 'https://c.example.com/reports' },
                { url: 'https://d.example.com/reports' },
              ],
            },
          ],
          [cspSettingName]: {
            defaultSrc: ["'self'"],
            reportTo: 'g2',
          },
        })
      )

      app.use(
        '/test4',
        secureHeaders({
          reportingEndpoints: [
            {
              name: 'e1',
              url: 'https://a.example.com/reports',
            },
            {
              name: 'e2',
              url: 'https://b.example.com/reports',
            },
          ],
          [cspSettingName]: {
            defaultSrc: ["'self'"],
            reportTo: 'e1',
          },
        })
      )

      app.all('*', async (c) => {
        return c.text('header updated')
      })

      const res1 = await app.request('/test1')
      expect(res1.headers.get('Reporting-Endpoints')).toEqual(
        'endpoint-1="https://example.com/reports"'
      )
      expect(res1.headers.get(cspHeaderName)).toEqual("default-src 'self'; report-to endpoint-1")

      const res2 = await app.request('/test2')
      expect(res2.headers.get('Report-To')).toEqual(
        '{"group":"endpoint-1","max_age":10886400,"endpoints":[{"url":"https://example.com/reports"}]}'
      )
      expect(res2.headers.get(cspHeaderName)).toEqual("default-src 'self'; report-to endpoint-1")

      const res3 = await app.request('/test3')
      expect(res3.headers.get('Report-To')).toEqual(
        '{"group":"g1","max_age":10886400,"endpoints":[{"url":"https://a.example.com/reports"},{"url":"https://b.example.com/reports"}]}, {"group":"g2","max_age":10886400,"endpoints":[{"url":"https://c.example.com/reports"},{"url":"https://d.example.com/reports"}]}'
      )
      expect(res3.headers.get(cspHeaderName)).toEqual("default-src 'self'; report-to g2")

      const res4 = await app.request('/test4')
      expect(res4.headers.get('Reporting-Endpoints')).toEqual(
        'e1="https://a.example.com/reports", e2="https://b.example.com/reports"'
      )
      expect(res4.headers.get(cspHeaderName)).toEqual("default-src 'self'; report-to e1")
    })

    it('CSP nonce for script-src', async () => {
      const app = new Hono()
      app.use(
        '/test',
        secureHeaders({
          [cspSettingName]: {
            scriptSrc: ["'self'", NONCE],
          },
        })
      )

      app.all('*', async (c) => {
        return c.text(`nonce: ${c.get('secureHeadersNonce')}`)
      })

      const res = await app.request('/test')
      const csp = res.headers.get(cspHeaderName)
      const nonce = csp?.match(/script-src 'self' 'nonce-([a-zA-Z0-9+/]+=*)'/)?.[1] || ''
      expect(csp).toMatch(`script-src 'self' 'nonce-${nonce}'`)
      expect(await res.text()).toEqual(`nonce: ${nonce}`)
    })

    it('CSP nonce for script-src and style-src', async () => {
      const app = new Hono()
      app.use(
        '/test',
        secureHeaders({
          [cspSettingName]: {
            scriptSrc: ["'self'", NONCE],
            styleSrc: ["'self'", NONCE],
          },
        })
      )

      app.all('*', async (c) => {
        return c.text(`nonce: ${c.get('secureHeadersNonce')}`)
      })

      const res = await app.request('/test')
      const csp = res.headers.get(cspHeaderName)
      const nonce = csp?.match(/script-src 'self' 'nonce-([a-zA-Z0-9+/]+=*)'/)?.[1] || ''
      expect(csp).toMatch(`script-src 'self' 'nonce-${nonce}'`)
      expect(csp).toMatch(`style-src 'self' 'nonce-${nonce}'`)
      expect(await res.text()).toEqual(`nonce: ${nonce}`)
    })

    it('CSP nonce by app own function', async () => {
      const app = new Hono()
      const setNonce: ContentSecurityPolicyOptionHandler = (ctx, directive) => {
        ctx.set(`test-${directive}-nonce`, directive)
        return `'nonce-${directive}'`
      }
      app.use(
        '/test',
        secureHeaders({
          [cspSettingName]: {
            scriptSrc: ["'self'", setNonce],
            styleSrc: ["'self'", setNonce],
          },
        })
      )

      app.all('*', async (c) => {
        return c.text(
          `script: ${c.get('test-scriptSrc-nonce')}, style: ${c.get('test-styleSrc-nonce')}`
        )
      })

      const res = await app.request('/test')
      const csp = res.headers.get(cspHeaderName)
      expect(csp).toMatch(`script-src 'self' 'nonce-scriptSrc'`)
      expect(csp).toMatch(`style-src 'self' 'nonce-styleSrc'`)
      expect(await res.text()).toEqual('script: scriptSrc, style: styleSrc')
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/secure-headers/index.ts
```typescript
export type { ContentSecurityPolicyOptionHandler } from './secure-headers'
export { NONCE, secureHeaders } from './secure-headers'
import type { SecureHeadersVariables } from './secure-headers'
export type { SecureHeadersVariables }

declare module '../..' {
  interface ContextVariableMap extends SecureHeadersVariables {}
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/secure-headers/permissions-policy.ts
```typescript
// https://github.com/w3c/webappsec-permissions-policy/blob/main/features.md

export type PermissionsPolicyDirective =
  | StandardizedFeatures
  | ProposedFeatures
  | ExperimentalFeatures

/**
 * These features have been declared in a published version of the respective specification.
 */
type StandardizedFeatures =
  | 'accelerometer'
  | 'ambientLightSensor'
  | 'attributionReporting'
  | 'autoplay'
  | 'battery'
  | 'bluetooth'
  | 'camera'
  | 'chUa'
  | 'chUaArch'
  | 'chUaBitness'
  | 'chUaFullVersion'
  | 'chUaFullVersionList'
  | 'chUaMobile'
  | 'chUaModel'
  | 'chUaPlatform'
  | 'chUaPlatformVersion'
  | 'chUaWow64'
  | 'computePressure'
  | 'crossOriginIsolated'
  | 'directSockets'
  | 'displayCapture'
  | 'encryptedMedia'
  | 'executionWhileNotRendered'
  | 'executionWhileOutOfViewport'
  | 'fullscreen'
  | 'geolocation'
  | 'gyroscope'
  | 'hid'
  | 'identityCredentialsGet'
  | 'idleDetection'
  | 'keyboardMap'
  | 'magnetometer'
  | 'microphone'
  | 'midi'
  | 'navigationOverride'
  | 'payment'
  | 'pictureInPicture'
  | 'publickeyCredentialsGet'
  | 'screenWakeLock'
  | 'serial'
  | 'storageAccess'
  | 'syncXhr'
  | 'usb'
  | 'webShare'
  | 'windowManagement'
  | 'xrSpatialTracking'

/**
 * These features have been proposed, but the definitions have not yet been integrated into their respective specs.
 */
type ProposedFeatures =
  | 'clipboardRead'
  | 'clipboardWrite'
  | 'gemepad'
  | 'sharedAutofill'
  | 'speakerSelection'

/**
 * These features generally have an explainer only, but may be available for experimentation by web developers.
 */
type ExperimentalFeatures =
  | 'allScreensCapture'
  | 'browsingTopics'
  | 'capturedSurfaceControl'
  | 'conversionMeasurement'
  | 'digitalCredentialsGet'
  | 'focusWithoutUserActivation'
  | 'joinAdInterestGroup'
  | 'localFonts'
  | 'runAdAuction'
  | 'smartCard'
  | 'syncScript'
  | 'trustTokenRedemption'
  | 'unload'
  | 'verticalScroll'

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/secure-headers/secure-headers.ts
````typescript
/**
 * @module
 * Secure Headers Middleware for Hono.
 */

import type { Context } from '../../context'
import type { MiddlewareHandler } from '../../types'
import { encodeBase64 } from '../../utils/encode'
import type { PermissionsPolicyDirective } from './permissions-policy'

export type SecureHeadersVariables = {
  secureHeadersNonce?: string
}

export type ContentSecurityPolicyOptionHandler = (ctx: Context, directive: string) => string
type ContentSecurityPolicyOptionValue = (string | ContentSecurityPolicyOptionHandler)[]

interface ContentSecurityPolicyOptions {
  defaultSrc?: ContentSecurityPolicyOptionValue
  baseUri?: ContentSecurityPolicyOptionValue
  childSrc?: ContentSecurityPolicyOptionValue
  connectSrc?: ContentSecurityPolicyOptionValue
  fontSrc?: ContentSecurityPolicyOptionValue
  formAction?: ContentSecurityPolicyOptionValue
  frameAncestors?: ContentSecurityPolicyOptionValue
  frameSrc?: ContentSecurityPolicyOptionValue
  imgSrc?: ContentSecurityPolicyOptionValue
  manifestSrc?: ContentSecurityPolicyOptionValue
  mediaSrc?: ContentSecurityPolicyOptionValue
  objectSrc?: ContentSecurityPolicyOptionValue
  reportTo?: string
  sandbox?: ContentSecurityPolicyOptionValue
  scriptSrc?: ContentSecurityPolicyOptionValue
  scriptSrcAttr?: ContentSecurityPolicyOptionValue
  scriptSrcElem?: ContentSecurityPolicyOptionValue
  styleSrc?: ContentSecurityPolicyOptionValue
  styleSrcAttr?: ContentSecurityPolicyOptionValue
  styleSrcElem?: ContentSecurityPolicyOptionValue
  upgradeInsecureRequests?: ContentSecurityPolicyOptionValue
  workerSrc?: ContentSecurityPolicyOptionValue
}

interface ReportToOptions {
  group: string
  max_age: number
  endpoints: ReportToEndpoint[]
}

interface ReportToEndpoint {
  url: string
}

interface ReportingEndpointOptions {
  name: string
  url: string
}

type PermissionsPolicyValue = '*' | 'self' | 'src' | 'none' | string

type PermissionsPolicyOptions = Partial<
  Record<PermissionsPolicyDirective, PermissionsPolicyValue[] | boolean>
>

type overridableHeader = boolean | string

interface SecureHeadersOptions {
  contentSecurityPolicy?: ContentSecurityPolicyOptions
  contentSecurityPolicyReportOnly?: ContentSecurityPolicyOptions
  crossOriginEmbedderPolicy?: overridableHeader
  crossOriginResourcePolicy?: overridableHeader
  crossOriginOpenerPolicy?: overridableHeader
  originAgentCluster?: overridableHeader
  referrerPolicy?: overridableHeader
  reportingEndpoints?: ReportingEndpointOptions[]
  reportTo?: ReportToOptions[]
  strictTransportSecurity?: overridableHeader
  xContentTypeOptions?: overridableHeader
  xDnsPrefetchControl?: overridableHeader
  xDownloadOptions?: overridableHeader
  xFrameOptions?: overridableHeader
  xPermittedCrossDomainPolicies?: overridableHeader
  xXssProtection?: overridableHeader
  removePoweredBy?: boolean
  permissionsPolicy?: PermissionsPolicyOptions
}

type HeadersMap = {
  [key in keyof SecureHeadersOptions]: [string, string]
}

const HEADERS_MAP: HeadersMap = {
  crossOriginEmbedderPolicy: ['Cross-Origin-Embedder-Policy', 'require-corp'],
  crossOriginResourcePolicy: ['Cross-Origin-Resource-Policy', 'same-origin'],
  crossOriginOpenerPolicy: ['Cross-Origin-Opener-Policy', 'same-origin'],
  originAgentCluster: ['Origin-Agent-Cluster', '?1'],
  referrerPolicy: ['Referrer-Policy', 'no-referrer'],
  strictTransportSecurity: ['Strict-Transport-Security', 'max-age=15552000; includeSubDomains'],
  xContentTypeOptions: ['X-Content-Type-Options', 'nosniff'],
  xDnsPrefetchControl: ['X-DNS-Prefetch-Control', 'off'],
  xDownloadOptions: ['X-Download-Options', 'noopen'],
  xFrameOptions: ['X-Frame-Options', 'SAMEORIGIN'],
  xPermittedCrossDomainPolicies: ['X-Permitted-Cross-Domain-Policies', 'none'],
  xXssProtection: ['X-XSS-Protection', '0'],
}

const DEFAULT_OPTIONS: SecureHeadersOptions = {
  crossOriginEmbedderPolicy: false,
  crossOriginResourcePolicy: true,
  crossOriginOpenerPolicy: true,
  originAgentCluster: true,
  referrerPolicy: true,
  strictTransportSecurity: true,
  xContentTypeOptions: true,
  xDnsPrefetchControl: true,
  xDownloadOptions: true,
  xFrameOptions: true,
  xPermittedCrossDomainPolicies: true,
  xXssProtection: true,
  removePoweredBy: true,
  permissionsPolicy: {},
}

type SecureHeadersCallback = (
  ctx: Context,
  headersToSet: [string, string | string[]][]
) => [string, string][]

const generateNonce = () => {
  const arrayBuffer = new Uint8Array(16)
  crypto.getRandomValues(arrayBuffer)
  return encodeBase64(arrayBuffer.buffer)
}

export const NONCE: ContentSecurityPolicyOptionHandler = (ctx) => {
  const key = 'secureHeadersNonce'
  const init = ctx.get(key)
  const nonce = init || generateNonce()
  if (init == null) {
    ctx.set(key, nonce)
  }
  return `'nonce-${nonce}'`
}

/**
 * Secure Headers Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/secure-headers}
 *
 * @param {Partial<SecureHeadersOptions>} [customOptions] - The options for the secure headers middleware.
 * @param {ContentSecurityPolicyOptions} [customOptions.contentSecurityPolicy] - Settings for the Content-Security-Policy header.
 * @param {ContentSecurityPolicyOptions} [customOptions.contentSecurityPolicyReportOnly] - Settings for the Content-Security-Policy-Report-Only header.
 * @param {overridableHeader} [customOptions.crossOriginEmbedderPolicy=false] - Settings for the Cross-Origin-Embedder-Policy header.
 * @param {overridableHeader} [customOptions.crossOriginResourcePolicy=true] - Settings for the Cross-Origin-Resource-Policy header.
 * @param {overridableHeader} [customOptions.crossOriginOpenerPolicy=true] - Settings for the Cross-Origin-Opener-Policy header.
 * @param {overridableHeader} [customOptions.originAgentCluster=true] - Settings for the Origin-Agent-Cluster header.
 * @param {overridableHeader} [customOptions.referrerPolicy=true] - Settings for the Referrer-Policy header.
 * @param {ReportingEndpointOptions[]} [customOptions.reportingEndpoints] - Settings for the Reporting-Endpoints header.
 * @param {ReportToOptions[]} [customOptions.reportTo] - Settings for the Report-To header.
 * @param {overridableHeader} [customOptions.strictTransportSecurity=true] - Settings for the Strict-Transport-Security header.
 * @param {overridableHeader} [customOptions.xContentTypeOptions=true] - Settings for the X-Content-Type-Options header.
 * @param {overridableHeader} [customOptions.xDnsPrefetchControl=true] - Settings for the X-DNS-Prefetch-Control header.
 * @param {overridableHeader} [customOptions.xDownloadOptions=true] - Settings for the X-Download-Options header.
 * @param {overridableHeader} [customOptions.xFrameOptions=true] - Settings for the X-Frame-Options header.
 * @param {overridableHeader} [customOptions.xPermittedCrossDomainPolicies=true] - Settings for the X-Permitted-Cross-Domain-Policies header.
 * @param {overridableHeader} [customOptions.xXssProtection=true] - Settings for the X-XSS-Protection header.
 * @param {boolean} [customOptions.removePoweredBy=true] - Settings for remove X-Powered-By header.
 * @param {PermissionsPolicyOptions} [customOptions.permissionsPolicy] - Settings for the Permissions-Policy header.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 * app.use(secureHeaders())
 * ```
 */
export const secureHeaders = (customOptions?: SecureHeadersOptions): MiddlewareHandler => {
  const options = { ...DEFAULT_OPTIONS, ...customOptions }
  const headersToSet = getFilteredHeaders(options)
  const callbacks: SecureHeadersCallback[] = []

  if (options.contentSecurityPolicy) {
    const [callback, value] = getCSPDirectives(options.contentSecurityPolicy)
    if (callback) {
      callbacks.push(callback)
    }
    headersToSet.push(['Content-Security-Policy', value as string])
  }

  if (options.contentSecurityPolicyReportOnly) {
    const [callback, value] = getCSPDirectives(options.contentSecurityPolicyReportOnly)
    if (callback) {
      callbacks.push(callback)
    }
    headersToSet.push(['Content-Security-Policy-Report-Only', value as string])
  }

  if (options.permissionsPolicy && Object.keys(options.permissionsPolicy).length > 0) {
    headersToSet.push([
      'Permissions-Policy',
      getPermissionsPolicyDirectives(options.permissionsPolicy),
    ])
  }

  if (options.reportingEndpoints) {
    headersToSet.push(['Reporting-Endpoints', getReportingEndpoints(options.reportingEndpoints)])
  }

  if (options.reportTo) {
    headersToSet.push(['Report-To', getReportToOptions(options.reportTo)])
  }

  return async function secureHeaders(ctx, next) {
    // should evaluate callbacks before next()
    // some callback calls ctx.set() for embedding nonce to the page
    const headersToSetForReq =
      callbacks.length === 0
        ? headersToSet
        : callbacks.reduce((acc, cb) => cb(ctx, acc), headersToSet)
    await next()
    setHeaders(ctx, headersToSetForReq)

    if (options?.removePoweredBy) {
      ctx.res.headers.delete('X-Powered-By')
    }
  }
}

function getFilteredHeaders(options: SecureHeadersOptions): [string, string][] {
  return Object.entries(HEADERS_MAP)
    .filter(([key]) => options[key as keyof SecureHeadersOptions])
    .map(([key, defaultValue]) => {
      const overrideValue = options[key as keyof SecureHeadersOptions]
      return typeof overrideValue === 'string' ? [defaultValue[0], overrideValue] : defaultValue
    })
}

function getCSPDirectives(
  contentSecurityPolicy: ContentSecurityPolicyOptions
): [SecureHeadersCallback | undefined, string | string[]] {
  const callbacks: ((ctx: Context, values: string[]) => void)[] = []
  const resultValues: string[] = []

  for (const [directive, value] of Object.entries(contentSecurityPolicy)) {
    const valueArray = Array.isArray(value) ? value : [value]

    valueArray.forEach((value, i) => {
      if (typeof value === 'function') {
        const index = i * 2 + 2 + resultValues.length
        callbacks.push((ctx, values) => {
          values[index] = value(ctx, directive)
        })
      }
    })

    resultValues.push(
      directive.replace(/[A-Z]+(?![a-z])|[A-Z]/g, (match, offset) =>
        offset ? '-' + match.toLowerCase() : match.toLowerCase()
      ),
      ...valueArray.flatMap((value) => [' ', value]),
      '; '
    )
  }
  resultValues.pop()

  return callbacks.length === 0
    ? [undefined, resultValues.join('')]
    : [
        (ctx, headersToSet) =>
          headersToSet.map((values) => {
            if (
              values[0] === 'Content-Security-Policy' ||
              values[0] === 'Content-Security-Policy-Report-Only'
            ) {
              const clone = values[1].slice() as unknown as string[]
              callbacks.forEach((cb) => {
                cb(ctx, clone)
              })
              return [values[0], clone.join('')]
            } else {
              return values as [string, string]
            }
          }),
        resultValues,
      ]
}

function getPermissionsPolicyDirectives(policy: PermissionsPolicyOptions): string {
  return Object.entries(policy)
    .map(([directive, value]) => {
      const kebabDirective = camelToKebab(directive)

      if (typeof value === 'boolean') {
        return `${kebabDirective}=${value ? '*' : 'none'}`
      }

      if (Array.isArray(value)) {
        if (value.length === 0) {
          return `${kebabDirective}=()`
        }
        if (value.length === 1 && (value[0] === '*' || value[0] === 'none')) {
          return `${kebabDirective}=${value[0]}`
        }
        const allowlist = value.map((item) => (['self', 'src'].includes(item) ? item : `"${item}"`))
        return `${kebabDirective}=(${allowlist.join(' ')})`
      }

      return ''
    })
    .filter(Boolean)
    .join(', ')
}

function camelToKebab(str: string): string {
  return str.replace(/([a-z\d])([A-Z])/g, '$1-$2').toLowerCase()
}

function getReportingEndpoints(
  reportingEndpoints: SecureHeadersOptions['reportingEndpoints'] = []
): string {
  return reportingEndpoints.map((endpoint) => `${endpoint.name}="${endpoint.url}"`).join(', ')
}

function getReportToOptions(reportTo: SecureHeadersOptions['reportTo'] = []): string {
  return reportTo.map((option) => JSON.stringify(option)).join(', ')
}

function setHeaders(ctx: Context, headersToSet: [string, string][]) {
  headersToSet.forEach(([header, value]) => {
    ctx.res.headers.set(header, value)
  })
}

````
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
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/timeout/index.test.ts
```typescript
import type { Context } from '../../context'
import { Hono } from '../../hono'
import { HTTPException } from '../../http-exception'
import type { HTTPExceptionFunction } from '.'
import { timeout } from '.'

describe('Timeout API', () => {
  const app = new Hono()

  app.use('/slow-endpoint', timeout(1000))
  app.use(
    '/slow-endpoint/custom',
    timeout(
      1100,
      () => new HTTPException(408, { message: 'Request timeout. Please try again later.' })
    )
  )
  const exception500: HTTPExceptionFunction = (context: Context) =>
    new HTTPException(500, { message: `Internal Server Error at ${context.req.path}` })
  app.use('/slow-endpoint/error', timeout(1200, exception500))
  app.use('/normal-endpoint', timeout(1000))

  app.get('/slow-endpoint', async (c) => {
    await new Promise((resolve) => setTimeout(resolve, 1100))
    return c.text('This should not show up')
  })

  app.get('/slow-endpoint/custom', async (c) => {
    await new Promise((resolve) => setTimeout(resolve, 1200))
    return c.text('This should not show up')
  })

  app.get('/slow-endpoint/error', async (c) => {
    await new Promise((resolve) => setTimeout(resolve, 1300))
    return c.text('This should not show up')
  })

  app.get('/normal-endpoint', async (c) => {
    await new Promise((resolve) => setTimeout(resolve, 900))
    return c.text('This should not show up')
  })

  it('Should trigger default timeout exception', async () => {
    const res = await app.request('http://localhost/slow-endpoint')
    expect(res).not.toBeNull()
    expect(res.status).toBe(504)
    expect(await res.text()).toContain('Gateway Timeout')
  })

  it('Should apply custom exception with function', async () => {
    const res = await app.request('http://localhost/slow-endpoint/custom')
    expect(res).not.toBeNull()
    expect(res.status).toBe(408)
    expect(await res.text()).toContain('Request timeout. Please try again later.')
  })

  it('Error timeout with custom status code and message', async () => {
    const res = await app.request('http://localhost/slow-endpoint/error')
    expect(res).not.toBeNull()
    expect(res.status).toBe(500)
    expect(await res.text()).toContain('Internal Server Error at /slow-endpoint/error')
  })

  it('No Timeout should pass', async () => {
    const res = await app.request('http://localhost/normal-endpoint')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toContain('This should not show up')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/timeout/index.ts
````typescript
/**
 * @module
 * Timeout Middleware for Hono.
 */

import type { Context } from '../../context'
import { HTTPException } from '../../http-exception'
import type { MiddlewareHandler } from '../../types'

export type HTTPExceptionFunction = (context: Context) => HTTPException

const defaultTimeoutException = new HTTPException(504, {
  message: 'Gateway Timeout',
})

/**
 * Timeout Middleware for Hono.
 *
 * @param {number} duration - The timeout duration in milliseconds.
 * @param {HTTPExceptionFunction | HTTPException} [exception=defaultTimeoutException] - The exception to throw when the timeout occurs. Can be a function that returns an HTTPException or an HTTPException object.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use(
 *   '/long-request',
 *   timeout(5000) // Set timeout to 5 seconds
 * )
 *
 * app.get('/long-request', async (c) => {
 *   await someLongRunningFunction()
 *   return c.text('Completed within time limit')
 * })
 * ```
 */
export const timeout = (
  duration: number,
  exception: HTTPExceptionFunction | HTTPException = defaultTimeoutException
): MiddlewareHandler => {
  return async function timeout(context, next) {
    let timer: number | undefined
    const timeoutPromise = new Promise<void>((_, reject) => {
      timer = setTimeout(() => {
        reject(typeof exception === 'function' ? exception(context) : exception)
      }, duration) as unknown as number
    })

    try {
      await Promise.race([next(), timeoutPromise])
    } finally {
      if (timer !== undefined) {
        clearTimeout(timer)
      }
    }
  }
}

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/powered-by/index.test.ts
```typescript
import { Hono } from '../../hono'
import { poweredBy } from '.'

describe('Powered by Middleware', () => {
  const app = new Hono()

  app.use('/poweredBy/*', poweredBy())
  app.get('/poweredBy', (c) => c.text('root'))

  app.use('/poweredBy2/*', poweredBy())
  app.use('/poweredBy2/*', poweredBy())
  app.get('/poweredBy2', (c) => c.text('root'))

  app.use('/poweredBy3/*', poweredBy({ serverName: 'Foo' }))
  app.get('/poweredBy3', (c) => c.text('root'))

  it('Should return with X-Powered-By header', async () => {
    const res = await app.request('http://localhost/poweredBy')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Powered-By')).toBe('Hono')
  })

  it('Should not return duplicate values', async () => {
    const res = await app.request('http://localhost/poweredBy2')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Powered-By')).toBe('Hono')
  })

  it('Should return custom serverName', async () => {
    const res = await app.request('http://localhost/poweredBy3')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Powered-By')).toBe('Foo')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/powered-by/index.ts
````typescript
/**
 * @module
 * Powered By Middleware for Hono.
 */
import type { MiddlewareHandler } from '../../types'

type PoweredByOptions = {
  /**
   * The value for X-Powered-By header.
   * @default Hono
   */
  serverName?: string
}

/**
 * Powered By Middleware for Hono.
 *
 * @param options - The options for the Powered By Middleware.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * import { poweredBy } from 'hono/powered-by'
 *
 * const app = new Hono()
 *
 * app.use(poweredBy()) // With options: poweredBy({ serverName: "My Server" })
 * ```
 */
export const poweredBy = (options?: PoweredByOptions): MiddlewareHandler => {
  return async function poweredBy(c, next) {
    await next()
    c.res.headers.set('X-Powered-By', options?.serverName ?? 'Hono')
  }
}

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/language/index.test.ts
```typescript
import { Hono } from '../../hono'
import { detectors } from './language'
import { languageDetector } from '.'

describe('languageDetector', () => {
  const createTestApp = (options = {}) => {
    const app = new Hono()

    app.use('/*', languageDetector(options))

    app.get('/*', (c) => c.text(c.get('language')))

    return app
  }

  describe('Query Parameter Detection', () => {
    it('should detect language from query parameter', async () => {
      const app = createTestApp({
        supportedLanguages: ['en', 'fr', 'es'],
        fallbackLanguage: 'en',
      })

      const res = await app.request('/?lang=fr')
      expect(await res.text()).toBe('fr')
    })

    it('should ignore unsupported languages in query', async () => {
      const app = createTestApp({
        supportedLanguages: ['en', 'fr'],
        fallbackLanguage: 'en',
      })

      const res = await app.request('/?lang=de')
      expect(await res.text()).toBe('en')
    })
  })

  describe('Cookie Detection', () => {
    it('should detect language from cookie', async () => {
      const app = createTestApp({
        supportedLanguages: ['en', 'fr'],
        fallbackLanguage: 'en',
      })

      const res = await app.request('/', {
        headers: {
          cookie: 'language=fr',
        },
      })
      expect(await res.text()).toBe('fr')
    })

    it('should cache detected language in cookie when enabled', async () => {
      const app = createTestApp({
        supportedLanguages: ['en', 'fr'],
        fallbackLanguage: 'en',
        caches: ['cookie'],
      })

      const res = await app.request('/?lang=fr')
      expect(res.headers.get('set-cookie')).toContain('language=fr')
    })
  })

  describe('Header Detection', () => {
    it('should detect language from Accept-Language header', async () => {
      const app = createTestApp({
        supportedLanguages: ['en', 'fr', 'es'],
        fallbackLanguage: 'en',
      })

      const res = await app.request('/', {
        headers: {
          'accept-language': 'fr-FR,fr;q=0.9,en;q=0.8',
        },
      })
      expect(await res.text()).toBe('fr')
    })

    it('should handle malformed Accept-Language headers', async () => {
      const app = createTestApp({
        supportedLanguages: ['en', 'fr'],
        fallbackLanguage: 'en',
      })

      const res = await app.request('/', {
        headers: {
          'accept-language': 'invalid;header;;format',
        },
      })
      expect(await res.text()).toBe('en')
    })
  })

  describe('Path Detection', () => {
    it('should detect language from path', async () => {
      const app = createTestApp({
        order: ['path'],
        supportedLanguages: ['en', 'fr'],
        fallbackLanguage: 'en',
        lookupFromPathIndex: 0,
      })

      const res = await app.request('/fr/page')
      expect(await res.text()).toBe('fr')
    })

    it('should handle invalid path index gracefully', async () => {
      const app = createTestApp({
        order: ['path'],
        supportedLanguages: ['en', 'fr'],
        fallbackLanguage: 'en',
        lookupFromPathIndex: 99,
      })

      const res = await app.request('/fr/page')
      expect(await res.text()).toBe('en')
    })
  })

  describe('Detection Order', () => {
    it('should respect detection order', async () => {
      const app = createTestApp({
        order: ['cookie', 'querystring'],
        supportedLanguages: ['en', 'fr', 'es'],
        fallbackLanguage: 'en',
      })

      const res = await app.request('/?lang=fr', {
        headers: {
          cookie: 'language=es',
        },
      })

      // Since cookie is first in order, it should use 'es'
      expect(await res.text()).toBe('es')
    })

    it('should fall back to next detector if first fails', async () => {
      const app = createTestApp({
        order: ['cookie', 'querystring'],
        supportedLanguages: ['en', 'fr'],
        fallbackLanguage: 'en',
      })

      const res = await app.request('/?lang=fr') // No cookie
      expect(await res.text()).toBe('fr') // Should use querystring
    })
  })

  describe('Language Conversion', () => {
    it('should apply language conversion function', async () => {
      const app = createTestApp({
        supportedLanguages: ['en', 'fr'],
        fallbackLanguage: 'en',
        convertDetectedLanguage: (lang: string) => lang.split('-')[0],
      })

      const res = await app.request('/?lang=fr-FR')
      expect(await res.text()).toBe('fr')
    })

    it('should handle case sensitivity according to options', async () => {
      const app = createTestApp({
        supportedLanguages: ['en', 'fr'],
        fallbackLanguage: 'en',
        ignoreCase: false,
      })

      const res = await app.request('/?lang=FR')
      expect(await res.text()).toBe('en') // Falls back because case doesn't match
    })
  })

  describe('Error Handling', () => {
    it('should fall back to default language on error', async () => {
      const app = createTestApp({
        supportedLanguages: ['en', 'fr'],
        fallbackLanguage: 'en',
      })

      const detector = vi.spyOn(detectors, 'querystring').mockImplementation(() => {
        throw new Error('Simulated error')
      })

      const res = await app.request('/?lang=fr')
      expect(await res.text()).toBe('en')

      detector.mockRestore()
    })

    it('should handle missing cookie values gracefully', async () => {
      const app = createTestApp({
        supportedLanguages: ['en', 'fr'],
        fallbackLanguage: 'en',
        order: ['cookie'],
      })

      const res = await app.request('/')
      expect(await res.text()).toBe('en')
    })
  })

  describe('Configuration Validation', () => {
    it('should throw if fallback language is not in supported languages', () => {
      expect(() => {
        createTestApp({
          supportedLanguages: ['fr', 'es'],
          fallbackLanguage: 'en',
        })
      }).toThrow()
    })

    it('should throw if path index is negative', () => {
      expect(() => {
        createTestApp({
          lookupFromPathIndex: -1,
        })
      }).toThrow()
    })

    it('should handle empty supported languages list', () => {
      expect(() => {
        createTestApp({
          supportedLanguages: [],
        })
      }).toThrow()
    })
  })

  describe('Debug Mode', () => {
    it('should log errors in debug mode', async () => {
      const consoleErrorSpy = vi.spyOn(console, 'error')

      const app = createTestApp({
        supportedLanguages: ['en', 'fr'],
        fallbackLanguage: 'en',
        debug: true,
      })

      const detector = vi.spyOn(detectors, 'querystring').mockImplementation(() => {
        throw new Error('Simulated error')
      })

      await app.request('/?lang=fr')

      expect(consoleErrorSpy).toHaveBeenCalledWith(
        'Error in querystring detector:',
        expect.any(Error)
      )

      detector.mockRestore()
      consoleErrorSpy.mockRestore()
    })

    // The log test remains unchanged
    it('should log debug information when enabled', async () => {
      const consoleSpy = vi.spyOn(console, 'log')

      const app = createTestApp({
        supportedLanguages: ['en', 'fr'],
        fallbackLanguage: 'en',
        debug: true,
      })

      await app.request('/?lang=fr')

      expect(consoleSpy).toHaveBeenCalledWith(
        expect.stringContaining('Language detected from querystring')
      )

      consoleSpy.mockRestore()
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/language/index.ts
```typescript
import type { LanguageVariables, DetectorOptions, DetectorType, CacheType } from './language'
export type { LanguageVariables, DetectorOptions, DetectorType, CacheType }
export {
  languageDetector,
  detectFromCookie,
  detectFromHeader,
  detectFromPath,
  detectFromQuery,
} from './language'
declare module '../..' {
  interface ContextVariableMap extends LanguageVariables {}
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/language/language.ts
```typescript
/**
 * @module
 * Language module for Hono.
 */
import type { Context } from '../../context'
import { setCookie, getCookie } from '../../helper/cookie'
import type { MiddlewareHandler } from '../../types'
import { parseAccept } from '../../utils/accept'

export type DetectorType = 'path' | 'querystring' | 'cookie' | 'header'
export type CacheType = 'cookie'

export interface DetectorOptions {
  /** Order of language detection strategies */
  order: DetectorType[]
  /** Query parameter name for language */
  lookupQueryString: string
  /** Cookie name for language */
  lookupCookie: string
  /** Index in URL path where language code appears */
  lookupFromPathIndex: number
  /** Header key for language detection */
  lookupFromHeaderKey: string
  /** Caching strategies */
  caches: CacheType[] | false
  /** Cookie configuration options */
  cookieOptions?: {
    domain?: string
    path?: string
    sameSite?: 'Strict' | 'Lax' | 'None'
    secure?: boolean
    maxAge?: number
    httpOnly?: boolean
  }
  /** Whether to ignore case in language codes */
  ignoreCase: boolean
  /** Default language if none detected */
  fallbackLanguage: string
  /** List of supported language codes */
  supportedLanguages: string[]
  /** Optional function to transform detected language codes */
  convertDetectedLanguage?: (lang: string) => string
  /** Enable debug logging */
  debug?: boolean
}

export interface LanguageVariables {
  language: string
}

export const DEFAULT_OPTIONS: DetectorOptions = {
  order: ['querystring', 'cookie', 'header'],
  lookupQueryString: 'lang',
  lookupCookie: 'language',
  lookupFromHeaderKey: 'accept-language',
  lookupFromPathIndex: 0,
  caches: ['cookie'],
  ignoreCase: true,
  fallbackLanguage: 'en',
  supportedLanguages: ['en'],
  cookieOptions: {
    sameSite: 'Strict',
    secure: true,
    maxAge: 365 * 24 * 60 * 60,
    httpOnly: true,
  },
  debug: false,
}
/**
 * Parse Accept-Language header values with quality scores
 * @param header Accept-Language header string
 * @returns Array of parsed languages with quality scores
 */
export function parseAcceptLanguage(header: string): Array<{ lang: string; q: number }> {
  return parseAccept(header).map(({ type, q }) => ({ lang: type, q }))
}

/**
 * Validate and normalize language codes
 * @param lang Language code to normalize
 * @param options Detector options
 * @returns Normalized language code or undefined
 */
export const normalizeLanguage = (
  lang: string | null | undefined,
  options: DetectorOptions
): string | undefined => {
  if (!lang) {
    return undefined
  }

  try {
    let normalizedLang = lang.trim()
    if (options.convertDetectedLanguage) {
      normalizedLang = options.convertDetectedLanguage(normalizedLang)
    }

    const compLang = options.ignoreCase ? normalizedLang.toLowerCase() : normalizedLang
    const compSupported = options.supportedLanguages.map((l) =>
      options.ignoreCase ? l.toLowerCase() : l
    )

    const matchedLang = compSupported.find((l) => l === compLang)
    return matchedLang ? options.supportedLanguages[compSupported.indexOf(matchedLang)] : undefined
  } catch {
    return undefined
  }
}

/**
 * Detects language from query parameter
 */
export const detectFromQuery = (c: Context, options: DetectorOptions): string | undefined => {
  try {
    const query = c.req.query(options.lookupQueryString)
    return normalizeLanguage(query, options)
  } catch {
    return undefined
  }
}

/**
 * Detects language from cookie
 */
export const detectFromCookie = (c: Context, options: DetectorOptions): string | undefined => {
  try {
    const cookie = getCookie(c, options.lookupCookie)
    return normalizeLanguage(cookie, options)
  } catch {
    return undefined
  }
}

/**
 * Detects language from Accept-Language header
 */
export function detectFromHeader(c: Context, options: DetectorOptions): string | undefined {
  try {
    const acceptLanguage = c.req.header(options.lookupFromHeaderKey)
    if (!acceptLanguage) {
      return undefined
    }

    const languages = parseAcceptLanguage(acceptLanguage)
    for (const { lang } of languages) {
      const normalizedLang = normalizeLanguage(lang, options)
      if (normalizedLang) {
        return normalizedLang
      }
    }
    return undefined
  } catch {
    return undefined
  }
}

/**
 * Detects language from URL path
 */
export function detectFromPath(c: Context, options: DetectorOptions): string | undefined {
  try {
    const pathSegments = c.req.path.split('/').filter(Boolean)
    const langSegment = pathSegments[options.lookupFromPathIndex]
    return normalizeLanguage(langSegment, options)
  } catch {
    return undefined
  }
}

/**
 * Collection of all language detection strategies
 */
export const detectors = {
  querystring: detectFromQuery,
  cookie: detectFromCookie,
  header: detectFromHeader,
  path: detectFromPath,
} as const

/** Type for detector functions */
export type DetectorFunction = (c: Context, options: DetectorOptions) => string | undefined

/** Type-safe detector map */
export type Detectors = Record<keyof typeof detectors, DetectorFunction>

/**
 * Validate detector options
 * @param options Detector options to validate
 * @throws Error if options are invalid
 */
export function validateOptions(options: DetectorOptions): void {
  if (!options.supportedLanguages.includes(options.fallbackLanguage)) {
    throw new Error('Fallback language must be included in supported languages')
  }

  if (options.lookupFromPathIndex < 0) {
    throw new Error('Path index must be non-negative')
  }

  if (!options.order.every((detector) => Object.keys(detectors).includes(detector))) {
    throw new Error('Invalid detector type in order array')
  }
}

/**
 * Cache detected language
 */
function cacheLanguage(c: Context, language: string, options: DetectorOptions): void {
  if (!Array.isArray(options.caches) || !options.caches.includes('cookie')) {
    return
  }

  try {
    setCookie(c, options.lookupCookie, language, options.cookieOptions)
  } catch (error) {
    if (options.debug) {
      console.error('Failed to cache language:', error)
    }
  }
}

/**
 * Detect language from request
 */
const detectLanguage = (c: Context, options: DetectorOptions): string => {
  let detectedLang: string | undefined

  for (const detectorName of options.order) {
    const detector = detectors[detectorName]
    if (!detector) {
      continue
    }

    try {
      detectedLang = detector(c, options)
      if (detectedLang) {
        if (options.debug) {
          console.log(`Language detected from ${detectorName}: ${detectedLang}`)
        }
        break
      }
    } catch (error) {
      if (options.debug) {
        console.error(`Error in ${detectorName} detector:`, error)
      }
      continue
    }
  }

  const finalLang = detectedLang || options.fallbackLanguage

  if (detectedLang && options.caches) {
    cacheLanguage(c, finalLang, options)
  }

  return finalLang
}

/**
 * Language detector middleware factory
 * @param userOptions Configuration options for the language detector
 * @returns Hono middleware function
 */
export const languageDetector = (userOptions: Partial<DetectorOptions>): MiddlewareHandler => {
  const options: DetectorOptions = {
    ...DEFAULT_OPTIONS,
    ...userOptions,
    cookieOptions: {
      ...DEFAULT_OPTIONS.cookieOptions,
      ...userOptions.cookieOptions,
    },
  }

  validateOptions(options)

  return async function languageDetector(ctx, next) {
    try {
      const lang = detectLanguage(ctx, options)
      ctx.set('language', lang)
    } catch (error) {
      if (options.debug) {
        console.error('Language detection failed:', error)
      }
      ctx.set('language', options.fallbackLanguage)
    }

    await next()
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/jwk/index.test.ts
```typescript
import { HttpResponse, http } from 'msw'
import { setupServer } from 'msw/node'
import { setSignedCookie } from '../../helper/cookie'
import { Hono } from '../../hono'
import { HTTPException } from '../../http-exception'
import { encodeBase64Url } from '../../utils/encode'
import { Jwt } from '../../utils/jwt'
import type { HonoJsonWebKey } from '../../utils/jwt/jws'
import { signing } from '../../utils/jwt/jws'
import { verifyFromJwks } from '../../utils/jwt/jwt'
import type { JWTPayload } from '../../utils/jwt/types'
import { utf8Encoder } from '../../utils/jwt/utf8'
import * as test_keys from './keys.test.json'
import { jwk } from '.'

const verify_keys = test_keys.public_keys

describe('JWK', () => {
  const server = setupServer(
    http.get('http://localhost/.well-known/jwks.json', () => {
      return HttpResponse.json({ keys: verify_keys })
    }),
    http.get('http://localhost/.well-known/missing-jwks.json', () => {
      return HttpResponse.json({})
    }),
    http.get('http://localhost/.well-known/bad-jwks.json', () => {
      return HttpResponse.json({ keys: 'bad-keys' })
    }),
    http.get('http://localhost/.well-known/404-jwks.json', () => {
      return HttpResponse.text('Not Found', { status: 404 })
    })
  )
  beforeAll(() => server.listen())
  afterEach(() => server.resetHandlers())
  afterAll(() => server.close())

  describe('verifyFromJwks', () => {
    it('Should throw error on missing options', async () => {
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[0])
      await expect(verifyFromJwks(credential, {})).rejects.toThrow(
        'verifyFromJwks requires options for either "keys" or "jwks_uri" or both'
      )
    })
  })

  describe('Credentials in header', () => {
    let handlerExecuted: boolean

    beforeEach(() => {
      handlerExecuted = false
    })

    const app = new Hono()

    app.use('/auth-with-keys/*', jwk({ keys: verify_keys }))
    app.use('/auth-with-keys-unicode/*', jwk({ keys: verify_keys }))
    app.use('/auth-with-keys-nested/*', async (c, next) => {
      const auth = jwk({ keys: verify_keys })
      return auth(c, next)
    })
    app.use(
      '/auth-with-keys-fn/*',
      jwk({
        keys: async () => {
          const response = await fetch('http://localhost/.well-known/jwks.json')
          const data = await response.json()
          return data.keys
        },
      })
    )
    app.use(
      '/auth-with-jwks_uri/*',
      jwk({
        jwks_uri: 'http://localhost/.well-known/jwks.json',
      })
    )
    app.use(
      '/auth-with-keys-and-jwks_uri/*',
      jwk({
        keys: verify_keys,
        jwks_uri: 'http://localhost/.well-known/jwks.json',
      })
    )
    app.use(
      '/auth-with-missing-jwks_uri/*',
      jwk({
        jwks_uri: 'http://localhost/.well-known/missing-jwks.json',
      })
    )
    app.use(
      '/auth-with-404-jwks_uri/*',
      jwk({
        jwks_uri: 'http://localhost/.well-known/404-jwks.json',
      })
    )
    app.use(
      '/auth-with-bad-jwks_uri/*',
      jwk({
        jwks_uri: 'http://localhost/.well-known/bad-jwks.json',
      })
    )

    app.get('/auth-with-keys/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/auth-with-keys-unicode/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/auth-with-keys-nested/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/auth-with-keys-fn/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/auth-with-jwks_uri/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/auth-with-keys-and-jwks_uri/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/auth-with-missing-jwks_uri/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/auth-with-404-jwks_uri/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/auth-with-bad-jwks_uri/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })

    it('Should throw an error if the middleware is missing both keys and jwks_uri (empty)', async () => {
      expect(() => app.use('/auth-with-empty-middleware/*', jwk({}))).toThrow(
        'JWK auth middleware requires options for either "keys" or "jwks_uri"'
      )
    })

    it('Should throw an error when crypto.subtle is missing', async () => {
      const subtleSpy = vi.spyOn(global.crypto, 'subtle', 'get').mockReturnValue({
        importKey: undefined,
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
      } as any)
      expect(() => app.use('/auth-with-bad-env/*', jwk({ keys: verify_keys }))).toThrow()
      subtleSpy.mockRestore()
    })

    it('Should return a server error if options.jwks_uri returns a 404', async () => {
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[0])
      const req = new Request('http://localhost/auth-with-404-jwks_uri/a')
      req.headers.set('Authorization', `Basic ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(500)
    })

    it('Should return a server error if the remotely fetched keys from options.jwks_uri are missing', async () => {
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[0])
      const req = new Request('http://localhost/auth-with-missing-jwks_uri/a')
      req.headers.set('Authorization', `Basic ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(500)
    })

    it('Should return a server error if the remotely fetched keys from options.jwks_uri are malformed', async () => {
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[0])
      const req = new Request('http://localhost/auth-with-bad-jwks_uri/a')
      req.headers.set('Authorization', `Basic ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(500)
    })

    it('Should not authorize requests with missing access token', async () => {
      const req = new Request('http://localhost/auth-with-keys/a')
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(await res.text()).toBe('Unauthorized')
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should authorize from a static array passed to options.keys (key 1)', async () => {
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[0])
      const req = new Request('http://localhost/auth-with-keys/a')
      req.headers.set('Authorization', `Bearer ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should authorize from a static array passed to options.keys (key 2)', async () => {
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[1])
      const req = new Request('http://localhost/auth-with-keys/a')
      req.headers.set('Authorization', `Bearer ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
      expect(res.status).toBe(200)
    })

    it('Should not authorize a token without header', async () => {
      const encodeJwtPart = (part: unknown): string =>
        encodeBase64Url(utf8Encoder.encode(JSON.stringify(part))).replace(/=/g, '')
      const encodeSignaturePart = (buf: ArrayBufferLike): string =>
        encodeBase64Url(buf).replace(/=/g, '')
      const jwtSignWithoutHeader = async (payload: JWTPayload, privateKey: HonoJsonWebKey) => {
        const encodedPayload = encodeJwtPart(payload)
        const signaturePart = await signing(
          privateKey,
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          privateKey.alg as any,
          utf8Encoder.encode(encodedPayload)
        )
        const signature = encodeSignaturePart(signaturePart)
        return `${encodedPayload}.${signature}`
      }
      const credential = await jwtSignWithoutHeader(
        { message: 'hello world' },
        test_keys.private_keys[1]
      )
      const req = new Request('http://localhost/auth-with-keys/a')
      req.headers.set('Authorization', `Bearer ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
    })

    it('Should not authorize a token with missing "kid" in header', async () => {
      const encodeJwtPart = (part: unknown): string =>
        encodeBase64Url(utf8Encoder.encode(JSON.stringify(part))).replace(/=/g, '')
      const encodeSignaturePart = (buf: ArrayBufferLike): string =>
        encodeBase64Url(buf).replace(/=/g, '')
      const jwtSignWithoutKid = async (payload: JWTPayload, privateKey: HonoJsonWebKey) => {
        const encodedPayload = encodeJwtPart(payload)
        const encodedHeader = encodeJwtPart({ alg: privateKey.alg, typ: 'JWT' })
        const partialToken = `${encodedHeader}.${encodedPayload}`
        const signaturePart = await signing(
          privateKey,
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          privateKey.alg as any,
          utf8Encoder.encode(partialToken)
        )
        const signature = encodeSignaturePart(signaturePart)
        return `${partialToken}.${signature}`
      }
      const credential = await jwtSignWithoutKid(
        { message: 'hello world' },
        test_keys.private_keys[1]
      )
      const req = new Request('http://localhost/auth-with-keys/a')
      req.headers.set('Authorization', `Bearer ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
    })

    it('Should not authorize a token with invalid "kid" in header', async () => {
      const copy = structuredClone(test_keys.private_keys[1])
      copy.kid = 'invalid-kid'
      const credential = await Jwt.sign({ message: 'hello world' }, copy)
      const req = new Request('http://localhost/auth-with-keys/a')
      req.headers.set('Authorization', `Bearer ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
    })

    it('Should authorize with Unicode payload from a static array passed to options.keys', async () => {
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[0])
      const req = new Request('http://localhost/auth-with-keys-unicode/a')
      req.headers.set('Authorization', `Basic ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should authorize from a function passed to options.keys', async () => {
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[0])
      const req = new Request('http://localhost/auth-with-keys-fn/a')
      req.headers.set('Authorization', `Basic ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should authorize from keys remotely fetched from options.jwks_uri', async () => {
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[0])
      const req = new Request('http://localhost/auth-with-jwks_uri/a')
      req.headers.set('Authorization', `Basic ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should authorize from keys and hard-coded and remotely fetched from options.jwks_uri', async () => {
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[0])
      const req = new Request('http://localhost/auth-with-keys-and-jwks_uri/a')
      req.headers.set('Authorization', `Basic ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should not authorize requests with invalid Unicode payload in header', async () => {
      const invalidToken =
        'ssyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE'
      const url = 'http://localhost/auth-with-keys-unicode/a'
      const req = new Request(url)
      req.headers.set('Authorization', `Basic ${invalidToken}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(res.headers.get('www-authenticate')).toEqual(
        `Bearer realm="${url}",error="invalid_token",error_description="token verification failure"`
      )
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should not authorize requests with malformed token structure in header', async () => {
      const invalid_token = 'invalid token'
      const url = 'http://localhost/auth-with-keys/a'
      const req = new Request(url)
      req.headers.set('Authorization', `Bearer ${invalid_token}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(res.headers.get('www-authenticate')).toEqual(
        `Bearer realm="${url}",error="invalid_request",error_description="invalid credentials structure"`
      )
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should not authorize requests without authorization in nested JWK middleware', async () => {
      const req = new Request('http://localhost/auth-with-keys-nested/a')
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(await res.text()).toBe('Unauthorized')
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should authorize requests with authorization in nested JWK middleware', async () => {
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[0])
      const req = new Request('http://localhost/auth-with-keys-nested/a')
      req.headers.set('Authorization', `Bearer ${credential}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })
  })

  describe('Credentials in cookie', () => {
    let handlerExecuted: boolean

    beforeEach(() => {
      handlerExecuted = false
    })

    const app = new Hono()

    app.use('/auth-with-keys/*', jwk({ keys: verify_keys, cookie: 'access_token' }))
    app.use('/auth-with-keys-unicode/*', jwk({ keys: verify_keys, cookie: 'access_token' }))
    app.use(
      '/auth-with-keys-prefixed/*',
      jwk({ keys: verify_keys, cookie: { key: 'access_token', prefixOptions: 'host' } })
    )
    app.use(
      '/auth-with-keys-unprefixed/*',
      jwk({ keys: verify_keys, cookie: { key: 'access_token' } })
    )

    app.get('/auth-with-keys/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/auth-with-keys-prefixed/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/auth-with-keys-unprefixed/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/auth-with-keys-unicode/*', (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })

    it('Should not authorize requests with missing access token', async () => {
      const req = new Request('http://localhost/auth-with-keys/a')
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(await res.text()).toBe('Unauthorized')
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should authorize cookie from a static array passed to options.keys', async () => {
      const url = 'http://localhost/auth-with-keys/a'
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[0])
      const req = new Request(url, {
        headers: new Headers({
          Cookie: `access_token=${credential}`,
        }),
      })
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(res.status).toBe(200)
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should authorize prefixed cookie from a static array passed to options.keys', async () => {
      const url = 'http://localhost/auth-with-keys-prefixed/a'
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[0])
      const req = new Request(url, {
        headers: new Headers({
          Cookie: `__Host-access_token=${credential}`,
        }),
      })
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(res.status).toBe(200)
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should authorize unprefixed cookie from a static array passed to options.keys', async () => {
      const url = 'http://localhost/auth-with-keys-unprefixed/a'
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[0])
      const req = new Request(url, {
        headers: new Headers({
          Cookie: `access_token=${credential}`,
        }),
      })
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(res.status).toBe(200)
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should authorize with Unicode payload from a static array passed to options.keys', async () => {
      const credential = await Jwt.sign({ message: 'hello world' }, test_keys.private_keys[0])
      const req = new Request('http://localhost/auth-with-keys-unicode/a', {
        headers: new Headers({
          Cookie: `access_token=${credential}`,
        }),
      })
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'hello world' })
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should not authorize requests with invalid Unicode payload in cookie', async () => {
      const invalidToken =
        'ssyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE'

      const url = 'http://localhost/auth-with-keys-unicode/a'
      const req = new Request(url)
      req.headers.set('Cookie', `access_token=${invalidToken}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(res.headers.get('www-authenticate')).toEqual(
        `Bearer realm="${url}",error="invalid_token",error_description="token verification failure"`
      )
      expect(handlerExecuted).toBeFalsy()
    })

    it('Should not authorize requests with malformed token structure in cookie', async () => {
      const invalidToken = 'invalid token'
      const url = 'http://localhost/auth-with-keys/a'
      const req = new Request(url)
      req.headers.set('Cookie', `access_token=${invalidToken}`)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(401)
      expect(res.headers.get('www-authenticate')).toEqual(
        `Bearer realm="${url}",error="invalid_token",error_description="token verification failure"`
      )
      expect(handlerExecuted).toBeFalsy()
    })
  })

  describe('Credentials in a signed cookie', () => {
    let handlerExecuted: boolean

    beforeEach(() => {
      handlerExecuted = false
    })

    const app = new Hono()
    const test_secret = 'Shhh'

    app.use(
      '/auth-with-signed-cookie/*',
      jwk({ keys: verify_keys, cookie: { key: 'access_token', secret: test_secret } })
    )
    app.use(
      '/auth-with-signed-with-prefix-options-cookie/*',
      jwk({
        keys: verify_keys,
        cookie: { key: 'access_token', secret: test_secret, prefixOptions: 'host' },
      })
    )

    app.get('/sign-cookie', async (c) => {
      const credential = await Jwt.sign(
        { message: 'signed hello world' },
        test_keys.private_keys[0]
      )
      await setSignedCookie(c, 'access_token', credential, test_secret)
      return c.text('OK')
    })
    app.get('/sign-cookie-with-prefix', async (c) => {
      const credential = await Jwt.sign(
        { message: 'signed hello world' },
        test_keys.private_keys[0]
      )
      await setSignedCookie(c, 'access_token', credential, test_secret, { prefix: 'host' })
      return c.text('OK')
    })
    app.get('/auth-with-signed-cookie/*', async (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })
    app.get('/auth-with-signed-with-prefix-options-cookie/*', async (c) => {
      handlerExecuted = true
      const payload = c.get('jwtPayload')
      return c.json(payload)
    })

    it('Should authorize signed cookie', async () => {
      const url = 'http://localhost/auth-with-signed-cookie/a'
      const sign_res = await app.request('http://localhost/sign-cookie')
      const cookieHeader = sign_res.headers.get('Set-Cookie') as string
      expect(cookieHeader).not.toBeNull()
      const req = new Request(url)
      req.headers.set('Cookie', cookieHeader)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'signed hello world' })
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should authorize prefixed signed cookie', async () => {
      const url = 'http://localhost/auth-with-signed-with-prefix-options-cookie/a'
      const sign_res = await app.request('http://localhost/sign-cookie-with-prefix')
      const cookieHeader = sign_res.headers.get('Set-Cookie') as string
      expect(cookieHeader).not.toBeNull()
      const req = new Request(url)
      req.headers.set('Cookie', cookieHeader)
      const res = await app.request(req)
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({ message: 'signed hello world' })
      expect(handlerExecuted).toBeTruthy()
    })

    it('Should not authorize an unsigned cookie', async () => {
      const url = 'http://localhost/auth-with-signed-cookie/a'
      const credential = await Jwt.sign(
        { message: 'unsigned hello world' },
        test_keys.private_keys[0]
      )
      const unsignedCookie = `access_token=${credential}`
      const req = new Request(url)
      req.headers.set('Cookie', unsignedCookie)
      const res = await app.request(req)
      expect(res.status).toBe(401)
      expect(await res.text()).toBe('Unauthorized')
      expect(handlerExecuted).toBeFalsy()
    })
  })

  describe('Error handling with `cause`', () => {
    const app = new Hono()

    app.use('/auth-with-keys/*', jwk({ keys: verify_keys }))
    app.get('/auth-with-keys/*', (c) => c.text('Authorized'))

    app.onError((e, c) => {
      if (e instanceof HTTPException && e.cause instanceof Error) {
        return c.json({ name: e.cause.name, message: e.cause.message }, 401)
      }
      return c.text(e.message, 401)
    })

    it('Should not authorize', async () => {
      const credential = 'abc.def.ghi'
      const req = new Request('http://localhost/auth-with-keys')
      req.headers.set('Authorization', `Bearer ${credential}`)
      const res = await app.request(req)
      expect(res.status).toBe(401)
      expect(await res.json()).toEqual({
        name: 'JwtTokenInvalid',
        message: `invalid JWT token: ${credential}`,
      })
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/jwk/index.ts
```typescript
export { jwk } from './jwk'

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/jwk/jwk.ts
````typescript
/**
 * @module
 * JWK Auth Middleware for Hono.
 */

import type { Context } from '../../context'
import { getCookie, getSignedCookie } from '../../helper/cookie'
import { HTTPException } from '../../http-exception'
import type { MiddlewareHandler } from '../../types'
import type { CookiePrefixOptions } from '../../utils/cookie'
import { Jwt } from '../../utils/jwt'
import '../../context'
import type { HonoJsonWebKey } from '../../utils/jwt/jws'

/**
 * JWK Auth Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/jwk}
 *
 * @param {object} options - The options for the JWK middleware.
 * @param {HonoJsonWebKey[] | (() => Promise<HonoJsonWebKey[]>)} [options.keys] - The values of your public keys, or a function that returns them.
 * @param {string} [options.jwks_uri] - If this value is set, attempt to fetch JWKs from this URI, expecting a JSON response with `keys` which are added to the provided options.keys
 * @param {string} [options.cookie] - If this value is set, then the value is retrieved from the cookie header using that value as a key, which is then validated as a token.
 * @param {RequestInit} [init] - Optional initialization options for the `fetch` request when retrieving JWKS from a URI.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use("/auth/*", jwk({ jwks_uri: "https://example-backend.hono.dev/.well-known/jwks.json" }))
 *
 * app.get('/auth/page', (c) => {
 *   return c.text('You are authorized')
 * })
 * ```
 */

export const jwk = (
  options: {
    keys?: HonoJsonWebKey[] | (() => Promise<HonoJsonWebKey[]>)
    jwks_uri?: string
    cookie?:
      | string
      | { key: string; secret?: string | BufferSource; prefixOptions?: CookiePrefixOptions }
  },
  init?: RequestInit
): MiddlewareHandler => {
  if (!options || !(options.keys || options.jwks_uri)) {
    throw new Error('JWK auth middleware requires options for either "keys" or "jwks_uri" or both')
  }

  if (!crypto.subtle || !crypto.subtle.importKey) {
    throw new Error('`crypto.subtle.importKey` is undefined. JWK auth middleware requires it.')
  }

  return async function jwk(ctx, next) {
    const credentials = ctx.req.raw.headers.get('Authorization')
    let token
    if (credentials) {
      const parts = credentials.split(/\s+/)
      if (parts.length !== 2) {
        const errDescription = 'invalid credentials structure'
        throw new HTTPException(401, {
          message: errDescription,
          res: unauthorizedResponse({
            ctx,
            error: 'invalid_request',
            errDescription,
          }),
        })
      } else {
        token = parts[1]
      }
    } else if (options.cookie) {
      if (typeof options.cookie == 'string') {
        token = getCookie(ctx, options.cookie)
      } else if (options.cookie.secret) {
        if (options.cookie.prefixOptions) {
          token = await getSignedCookie(
            ctx,
            options.cookie.secret,
            options.cookie.key,
            options.cookie.prefixOptions
          )
        } else {
          token = await getSignedCookie(ctx, options.cookie.secret, options.cookie.key)
        }
      } else {
        if (options.cookie.prefixOptions) {
          token = getCookie(ctx, options.cookie.key, options.cookie.prefixOptions)
        } else {
          token = getCookie(ctx, options.cookie.key)
        }
      }
    }

    if (!token) {
      const errDescription = 'no authorization included in request'
      throw new HTTPException(401, {
        message: errDescription,
        res: unauthorizedResponse({
          ctx,
          error: 'invalid_request',
          errDescription,
        }),
      })
    }

    let payload
    let cause
    try {
      payload = await Jwt.verifyFromJwks(token, options, init)
    } catch (e) {
      cause = e
    }

    if (!payload) {
      if (cause instanceof Error && cause.constructor === Error) {
        throw cause
      }
      throw new HTTPException(401, {
        message: 'Unauthorized',
        res: unauthorizedResponse({
          ctx,
          error: 'invalid_token',
          statusText: 'Unauthorized',
          errDescription: 'token verification failure',
        }),
        cause,
      })
    }

    ctx.set('jwtPayload', payload)

    await next()
  }
}

function unauthorizedResponse(opts: {
  ctx: Context
  error: string
  errDescription: string
  statusText?: string
}) {
  return new Response('Unauthorized', {
    status: 401,
    statusText: opts.statusText,
    headers: {
      'WWW-Authenticate': `Bearer realm="${opts.ctx.req.url}",error="${opts.error}",error_description="${opts.errDescription}"`,
    },
  })
}

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/jwk/keys.test.json
```json
{
  "public_keys": [
    {
      "kid": "hono-test-kid-1",
      "kty": "RSA",
      "use": "sig",
      "alg": "RS256",
      "e": "AQAB",
      "n": "2XGQh8VC_p8gRqfBLY0E3RycnfBl5g1mKyeiyRSPjdaR7fmNPuC3mHjVWXtyXWSvAuRYPYfL_pSi6erpxVv7NuPJbKaZ-I1MwdRPdG2qHu9mNYxniws73gvF3tUN9eSsQUIBL0sYEOnVMjniDcOxIr3Rgz_RxdLB_FxTDXYhzzG49L79wGV1udILGHq0lqlMtmUX6LRtbaoRt1fJB4rTCkYeQp9r5HYP79PKTR43vLIq0aZryI4CyBkPG_0vGEvnzasGdp-qE9Ywt_J2anQKt3nvVVR4Yhs2EIoPQkYoDnVySjeuRsUA5JQYKThrM4sFZSQsO82dHTvwKo2z2x6ZMw"
    },
    {
      "kid": "hono-test-kid-2",
      "kty": "RSA",
      "use": "sig",
      "alg": "RS256",
      "e": "AQAB",
      "n": "uRVR5DkH22a_FM4RtqvnVxd6QAjdfj8oFYPaxIux7K8oTaBy5YagxTWN0qeKI5lI3nL20cx72XxD_UF4TETCFgfD-XB48cdjnSQlOXXbRPXUX0Rdte48naAt4przAb7ydUxrfvDlbSZe02Du-ZGRzEB6RW6KLFWUvTadI4w33qb2i8hauQuTcRmaIUESt8oytUGS44dXAw3Nqt_NL-e7TRgX5o1u_31Uvet1ofsv6Mx8vxJ6zMdM_AKvzLt2iuoK_8vL4R86CjD3dpal2BwO7RkRl2Wcuf5jxjM4pruJ2RBCpzBieEvSIH8kKHIm9SfTzTDJqRhoXd7KM5jL1GNzyw"
    }
  ],
  "private_keys": [
    {
      "kid": "hono-test-kid-1",
      "alg": "RS256",
      "d": "A5CR2gGPegHwOYUbUzylZvdgUFNWMetOUK7M3TClGdVgSkWpELrTLhpTa3m50KYlG446x03baxUGU4D_MoKx7GukX0-fGCzY17FvWNOwOLACcPMYT3ZwfAQ2_jkBimJxU7CNUtH18KQ-U1B3nQ1apHZc-1Xa6CKIY5nv32yfj6uTrERRLOs7Fn9xpOE4uMHEf-l1ppIEIqK5QkEoPRMCUBABsGBSfiJP2hQVa-R-nezX3kVSxKTxAjDEOkquzb-CKlJW7xN2xQ7p40Wi7lDWZkOapBNGr59Z4gcFfo6f8XpQrqoFjDfsGsdH5q9MH_3lEEtD14wymXNnCoRHNr_mwQ",
      "dp": "WMq_BNbd3At-J9VzXgE-aLvPhztS1W8K9xlghITpwAyzhEfCp9mO7IOEVtNWKoEtVFEaZrWKuNWKd-dnzjvydltCkpJ7QhTmiFNFsEzKNJdGQ1Tfsj9658csbVLUOhI4oVcN6kiCa6OdH41Z_JMyN75cTgd4z5h_FRYRRgjoUEU",
      "dq": "Lz9vM7L-aEsPJOM5K2PqInLP9HNwDl943S79d_aw6w-JnHPFcu95no6-6nRcd87eSWoTvHZeFgsle4oiV0UpAocEO7xraCBa_Z9o-jGbBfynOLyXMH2l70yWBdCGCzgc_Wg2sKJwiYYXXfGJ3CzSeIRet82Rn54Q9mMlB6Ie8LE",
      "e": "AQAB",
      "kty": "RSA",
      "n": "2XGQh8VC_p8gRqfBLY0E3RycnfBl5g1mKyeiyRSPjdaR7fmNPuC3mHjVWXtyXWSvAuRYPYfL_pSi6erpxVv7NuPJbKaZ-I1MwdRPdG2qHu9mNYxniws73gvF3tUN9eSsQUIBL0sYEOnVMjniDcOxIr3Rgz_RxdLB_FxTDXYhzzG49L79wGV1udILGHq0lqlMtmUX6LRtbaoRt1fJB4rTCkYeQp9r5HYP79PKTR43vLIq0aZryI4CyBkPG_0vGEvnzasGdp-qE9Ywt_J2anQKt3nvVVR4Yhs2EIoPQkYoDnVySjeuRsUA5JQYKThrM4sFZSQsO82dHTvwKo2z2x6ZMw",
      "p": "7K-X3xMf3xxdlHTRs17x4WkbFUq4ZCU9L1al88UW2tpoF8ZDLUvaKXeF0vkosKvYUsiHsV1fbGVo6Oy75iII-op-t6-tP3R61nkjaytyJ8p32nbxBI1UWpFxZYNxG_Od07kau3LwkgDh8Ogr6zqmq8-lKoBPio-4K7PY5FiyWzs",
      "q": "6y__IKt1n1pTc-S9l1WfSuC96jX8iQhEsGSxnshyNZi59mH1AigkrAw9T5b7OFX7ulHXwuithsVi8cxkq2inNmemxD3koiiU-sv6vg6lRCoZsXFHiUCP-2HoK17sR1zUb6HQpp5MEHY8qoC3Mi3IpkNC7gAbAukbMQo3WlIGqmk",
      "qi": "flgM56Nw2hzHHy0Lz8ewBtOkkzfq1r_n6SmSZdU0zWlEp1lLovpHmuwyVeXpQlLJUHqcNVRw0NlwV7EN0rPd4rG3hcMdogj_Jl-r52TYzx4kVpbMEIh4xKs5rFzxbb96A3F9Ox-muRWvfOUCpXxGXCCGqHRmjRUolxDxsiPznuk"
    },
    {
      "kid": "hono-test-kid-2",
      "alg": "RS256",
      "d": "JCIL50TVClnQQyUJ40JDO0b7mGXCrCNzVWP1ATsOhNkbQrBozfOPDoEqi24m81U5GyiRlBraMPboJRizfhxMUdW5RkjVa8pT4blNRR8DrD5b9C9aJir5DYLYgm1itLwNBKZjNBieicUcbSL29KUdNCWAWW6_rfEVRS1U1zxIKgDUPVd6d7jiIwAKuKvGlMc11RGRZj5eKSNMQyLU5u8Qs_VQuoBRNAyWLZZcHMlAWbh3er7m0jkmUDRdVU0y_n1UAGsr9cAxPwf2HtS5j5R2ahEodatsJynnafYtj6jbOR6jvO3N2Vf-NJ7jVY2-kfv1rJd86KAxD-tIAGx2w1VRTQ",
      "dp": "wQhiWfdvVxk7ERmYj7Fn04wqjP7o7-72bn3SznGyBSkvpkg1WX4j467vpRtXVn4qxSSMXCj2UMKCrovba2RWHp1cnkvT-TFTbONkBuhOBpbx3TVwgGd-IfDJVa_i89XjiYgtEApHz173kRodEENXxcOj_mbOGyBb9Yl2M45A-tU",
      "dq": "ERdP5mdziJ46OsDHTdZ4hOX2ti0EljtVqGo1B4WKXey6DMH0JGHGU_3fFiF4Gomhy3nyGUI7Qhk3kf7lixAtSsk1lWAAeQLPt1r8yZkD5odLKXLyua_yZJ041d3O3wxRYXl3OvzoVy6rPhzRPIaxevNp-Pp5ZNoKfonQPz3bDGc",
      "e": "AQAB",
      "kty": "RSA",
      "n": "uRVR5DkH22a_FM4RtqvnVxd6QAjdfj8oFYPaxIux7K8oTaBy5YagxTWN0qeKI5lI3nL20cx72XxD_UF4TETCFgfD-XB48cdjnSQlOXXbRPXUX0Rdte48naAt4przAb7ydUxrfvDlbSZe02Du-ZGRzEB6RW6KLFWUvTadI4w33qb2i8hauQuTcRmaIUESt8oytUGS44dXAw3Nqt_NL-e7TRgX5o1u_31Uvet1ofsv6Mx8vxJ6zMdM_AKvzLt2iuoK_8vL4R86CjD3dpal2BwO7RkRl2Wcuf5jxjM4pruJ2RBCpzBieEvSIH8kKHIm9SfTzTDJqRhoXd7KM5jL1GNzyw",
      "p": "7cY_nFnn4w5pVi7wq_S9FJHIGsxCwogXqSSC_d7yWopbI2rW3Ugx21IMcWT2pnpsF_VYQx5FnNFviFufNOloREOguqci4lBinAilYBf3VXaN_YrxSk4flJmykwm_HBbXpHt_L3t4HBf-uuY-klJxFkeTbBErjxMS0U0EheEpDYU",
      "q": "x0UidqgkzWPqXa7vZ5noYTY5e3TDQZ_l8A26lFDKAbB62lXvnp_MhnQYDAx9VgUGYYrXv7UmaH-ZCSzuMM9Uhuw0lXRyojF-TLowNjASMlWbkJsJus3zi_AI4pAKyYnhNADxZrT1kxseI8zHiq0_bQa8qLaleXBTdkpc3Z6M1Q8",
      "qi": "x5VJcfnlX9ZhH6eMKx27rOGQrPjQ4BjZgmND7rrX-CSrE0M0RG4KuC4ZOu5XpQ-YsOC_bIzolBN2cHGn4ttPXeUc3y5bnqJYo7FxMdGn4gPRbXlVjCrE54JH_cdkl8cDqcaybjme1-ilNu-vHJWgHPdpbOguhRpicARkptAkOe0"
    }
  ]
}
```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/method-override/index.test.ts
```typescript
import { Hono } from '../../hono'
import { methodOverride } from './index'

describe('Method Override Middleware', () => {
  describe('Form', () => {
    const app = new Hono()
    app.use('/posts/*', methodOverride({ app }))
    app.use('/posts-custom/*', methodOverride({ app, form: 'custom-input-name' }))
    app.on(['post', 'delete'], ['/posts', '/posts-custom'], async (c) => {
      const form = await c.req.formData()
      return c.json({
        method: c.req.method,
        message: form.get('message'),
        contentType: c.req.header('content-type') ?? '',
      })
    })

    describe('multipart/form-data', () => {
      it('Should override POST to DELETE', async () => {
        const form = new FormData()
        form.append('message', 'Hello')
        form.append('_method', 'DELETE')
        const res = await app.request('/posts', {
          body: form,
          method: 'POST',
        })
        expect(res.status).toBe(200)
        const data = await res.json()
        expect(data.method).toBe('DELETE')
        expect(data.message).toBe('Hello')
        expect(data.contentType).toMatch(/^multipart\/form-data;/)
      })

      it('Should override POST to DELETE - with a custom form input name', async () => {
        const form = new FormData()
        form.append('message', 'Hello')
        form.append('custom-input-name', 'DELETE')
        const res = await app.request('/posts-custom', {
          body: form,
          method: 'POST',
        })
        expect(res.status).toBe(200)
        const data = await res.json()
        expect(data.method).toBe('DELETE')
        expect(data.message).toBe('Hello')
        expect(data.contentType).toMatch(/^multipart\/form-data;/)
      })

      it('Should override POST to PATCH - not found', async () => {
        const form = new FormData()
        form.append('message', 'Hello')
        form.append('_method', 'PATCH')
        const res = await app.request('/posts', {
          body: form,
          method: 'POST',
        })
        expect(res.status).toBe(404)
      })
    })

    describe('application/x-www-form-urlencoded', () => {
      it('Should override POST to DELETE', async () => {
        const params = new URLSearchParams()
        params.append('message', 'Hello')
        params.append('_method', 'DELETE')
        const res = await app.request('/posts', {
          body: params,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          method: 'POST',
        })
        expect(res.status).toBe(200)
        const data = await res.json()
        expect(data.method).toBe('DELETE')
        expect(data.message).toBe('Hello')
        expect(data.contentType).toBe('application/x-www-form-urlencoded')
      })

      it('Should override POST to DELETE - with a custom form input name', async () => {
        const params = new URLSearchParams()
        params.append('message', 'Hello')
        params.append('custom-input-name', 'DELETE')
        const res = await app.request('/posts-custom', {
          body: params,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          method: 'POST',
        })
        expect(res.status).toBe(200)
        const data = await res.json()
        expect(data.method).toBe('DELETE')
        expect(data.message).toBe('Hello')
        expect(data.contentType).toBe('application/x-www-form-urlencoded')
      })

      it('Should override POST to PATCH - not found', async () => {
        const form = new FormData()
        form.append('message', 'Hello')
        form.append('_method', 'PATCH')
        const res = await app.request('/posts', {
          body: form,
          method: 'POST',
        })
        expect(res.status).toBe(404)
      })
    })
  })

  describe('Header', () => {
    const app = new Hono()
    app.use('/posts/*', methodOverride({ app, header: 'X-METHOD-OVERRIDE' }))
    app.on(['get', 'post', 'delete'], '/posts', async (c) => {
      return c.json({
        method: c.req.method,
        headerValue: c.req.header('X-METHOD-OVERRIDE') ?? null,
      })
    })

    it('Should override POST to DELETE', async () => {
      const res = await app.request('/posts', {
        method: 'POST',
        headers: {
          'X-METHOD-OVERRIDE': 'DELETE',
        },
      })
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({
        method: 'DELETE',
        headerValue: null,
      })
    })

    it('Should not override GET request', async () => {
      const res = await app.request('/posts', {
        method: 'GET',
        headers: {
          'X-METHOD-OVERRIDE': 'DELETE',
        },
      })
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({
        method: 'GET',
        headerValue: 'DELETE', // It does not modify the headers.
      })
    })
  })

  describe('Query', () => {
    const app = new Hono()
    app.use('/posts/*', methodOverride({ app, query: '_method' }))
    app.on(['get', 'post', 'delete'], '/posts', async (c) => {
      return c.json({
        method: c.req.method,
        queryValue: c.req.query('_method') ?? null,
      })
    })

    it('Should override POST to DELETE', async () => {
      const res = await app.request('/posts?_method=delete', {
        method: 'POST',
      })
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({
        method: 'DELETE',
        queryValue: null,
      })
    })

    it('Should not override GET request', async () => {
      const res = await app.request('/posts?_method=delete', {
        method: 'GET',
      })
      expect(res.status).toBe(200)
      expect(await res.json()).toEqual({
        method: 'GET',
        queryValue: 'delete', // It does not modify the queries.
      })
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/method-override/index.ts
````typescript
/**
 * @module
 * Method Override Middleware for Hono.
 */

import type { Context, ExecutionContext } from '../../context'
import type { Hono } from '../../hono'
import type { MiddlewareHandler } from '../../types'
import { parseBody } from '../../utils/body'

type MethodOverrideOptions = {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  app: Hono<any, any, any>
} & (
  | {
      // Default is 'form' and the value is `_method`
      form?: string
      header?: never
      query?: never
    }
  | {
      form?: never
      header: string
      query?: never
    }
  | {
      form?: never
      header?: never
      query: string
    }
)

const DEFAULT_METHOD_FORM_NAME = '_method'

/**
 * Method Override Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/method-override}
 *
 * @param {MethodOverrideOptions} options - The options for the method override middleware.
 * @param {Hono} options.app - The instance of Hono is used in your application.
 * @param {string} [options.form=_method] - Form key with a value containing the method name.
 * @param {string} [options.header] - Header name with a value containing the method name.
 * @param {string} [options.query] - Query parameter key with a value containing the method name.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * // If no options are specified, the value of `_method` in the form,
 * // e.g. DELETE, is used as the method.
 * app.use('/posts', methodOverride({ app }))
 *
 * app.delete('/posts', (c) => {
 *   // ....
 * })
 * ```
 */
export const methodOverride = (options: MethodOverrideOptions): MiddlewareHandler =>
  async function methodOverride(c, next) {
    if (c.req.method === 'GET') {
      return await next()
    }

    const app = options.app
    // Method override by form
    if (!(options.header || options.query)) {
      const contentType = c.req.header('content-type')
      const methodFormName = options.form || DEFAULT_METHOD_FORM_NAME
      const clonedRequest = c.req.raw.clone()
      const newRequest = clonedRequest.clone()
      // Content-Type is `multipart/form-data`
      if (contentType?.startsWith('multipart/form-data')) {
        const form = await clonedRequest.formData()
        const method = form.get(methodFormName)
        if (method) {
          const newForm = await newRequest.formData()
          newForm.delete(methodFormName)
          const newHeaders = new Headers(clonedRequest.headers)
          newHeaders.delete('content-type')
          newHeaders.delete('content-length')
          const request = new Request(c.req.url, {
            body: newForm,
            headers: newHeaders,
            method: method as string,
          })
          return app.fetch(request, c.env, getExecutionCtx(c))
        }
      }
      // Content-Type is `application/x-www-form-urlencoded`
      if (contentType === 'application/x-www-form-urlencoded') {
        const params = await parseBody<Record<string, string>>(clonedRequest)
        const method = params[methodFormName]
        if (method) {
          delete params[methodFormName]
          const newParams = new URLSearchParams(params)
          const request = new Request(newRequest, {
            body: newParams,
            method: method as string,
          })
          return app.fetch(request, c.env, getExecutionCtx(c))
        }
      }
    }
    // Method override by header
    else if (options.header) {
      const headerName = options.header
      const method = c.req.header(headerName)
      if (method) {
        const newHeaders = new Headers(c.req.raw.headers)
        newHeaders.delete(headerName)
        const request = new Request(c.req.raw, {
          headers: newHeaders,
          method,
        })
        return app.fetch(request, c.env, getExecutionCtx(c))
      }
    }
    // Method override by query
    else if (options.query) {
      const queryName = options.query
      const method = c.req.query(queryName)
      if (method) {
        const url = new URL(c.req.url)
        url.searchParams.delete(queryName)
        const request = new Request(url.toString(), {
          body: c.req.raw.body,
          headers: c.req.raw.headers,
          method,
        })
        return app.fetch(request, c.env, getExecutionCtx(c))
      }
    }
    await next()
  }

const getExecutionCtx = (c: Context) => {
  let executionCtx: ExecutionContext | undefined
  try {
    executionCtx = c.executionCtx
  } catch {
    // Do nothing
  }
  return executionCtx
}

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/pretty-json/index.test.ts
```typescript
import { Hono } from '../../hono'
import { prettyJSON } from '.'

describe('JSON pretty by Middleware', () => {
  it('Should return pretty JSON output', async () => {
    const app = new Hono()
    app.use('*', prettyJSON())
    app.get('/', (c) => {
      return c.json({ message: 'Hono!' })
    })

    const res = await app.request('http://localhost/?pretty')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe(`{
  "message": "Hono!"
}`)
  })

  it('Should return pretty JSON output with 4 spaces', async () => {
    const app = new Hono()
    app.use('*', prettyJSON({ space: 4 }))
    app.get('/', (c) => {
      return c.json({ message: 'Hono!' })
    })

    const res = await app.request('http://localhost/?pretty')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(await res.text()).toBe(`{
    "message": "Hono!"
}`)
  })

  it('Should return pretty JSON output when middleware received custom query', async () => {
    const targetQuery = 'format'

    const app = new Hono()
    app.use(
      '*',
      prettyJSON({
        query: targetQuery,
      })
    )
    app.get('/', (c) =>
      c.json({
        message: 'Hono!',
      })
    )

    const prettyText = await (await app.request(`?${targetQuery}`)).text()
    expect(prettyText).toBe(`{
  "message": "Hono!"
}`)
    const nonPrettyText = await (await app.request('?pretty')).text()
    expect(nonPrettyText).toBe('{"message":"Hono!"}')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/pretty-json/index.ts
````typescript
/**
 * @module
 * Pretty JSON Middleware for Hono.
 */

import type { MiddlewareHandler } from '../../types'

interface PrettyOptions {
  /**
   * Number of spaces for indentation.
   * @default 2
   */
  space?: number

  /**
   * Query conditions for when to Pretty.
   * @default 'pretty'
   */
  query?: string
}

/**
 * Pretty JSON Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/pretty-json}
 *
 * @param options - The options for the pretty JSON middleware.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use(prettyJSON()) // With options: prettyJSON({ space: 4 })
 * app.get('/', (c) => {
 *   return c.json({ message: 'Hono!' })
 * })
 * ```
 */
export const prettyJSON = (options?: PrettyOptions): MiddlewareHandler => {
  const targetQuery = options?.query ?? 'pretty'
  return async function prettyJSON(c, next) {
    const pretty = c.req.query(targetQuery) || c.req.query(targetQuery) === ''
    await next()
    if (pretty && c.res.headers.get('Content-Type')?.startsWith('application/json')) {
      const obj = await c.res.json()
      c.res = new Response(JSON.stringify(obj, null, options?.space ?? 2), c.res)
    }
  }
}

````
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
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/csrf/index.test.ts
```typescript
import type { Context } from '../../context'
import { Hono } from '../../hono'
import { csrf } from '../../middleware/csrf'

const simplePostHandler = vi.fn(async (c: Context) => {
  if (c.req.header('content-type') === 'application/json') {
    return c.text((await c.req.json<{ name: string }>())['name'])
  } else {
    const body = await c.req.parseBody<{ name: string }>()
    return c.text(body['name'])
  }
})

const buildSimplePostRequestData = (origin?: string) => ({
  method: 'POST',
  headers: Object.assign(
    {
      'content-type': 'application/x-www-form-urlencoded',
    },
    origin ? { origin } : {}
  ) as Record<string, string>,
  body: 'name=hono',
})

describe('CSRF by Middleware', () => {
  beforeEach(() => {
    simplePostHandler.mockClear()
  })

  describe('simple usage', () => {
    const app = new Hono()

    app.use('*', csrf())
    app.get('/form', (c) => c.html('<form></form>'))
    app.post('/form', simplePostHandler)
    app.put('/form', (c) => c.text('OK'))
    app.delete('/form', (c) => c.text('OK'))
    app.patch('/form', (c) => c.text('OK'))

    describe('GET /form', async () => {
      it('should be 200 for any request', async () => {
        const res = await app.request('http://localhost/form')

        expect(res.status).toBe(200)
        expect(await res.text()).toBe('<form></form>')
      })
    })

    describe('HEAD /form', async () => {
      it('should be 200 for any request', async () => {
        const res = await app.request('http://localhost/form', { method: 'HEAD' })

        expect(res.status).toBe(200)
      })
    })

    describe('POST /form', async () => {
      it('should be 200 for local request', async () => {
        /*
         * <form action="/form" method="POST"><input name="name" value="hono" /></form>
         * or
         * <script>
         * fetch('/form', {
         *   method: 'POST',
         *   headers: {
         *     'content-type': 'application/x-www-form-urlencoded',
         *   },
         *   body: 'name=hono',
         * });
         * </script>
         */
        const res = await app.request(
          'http://localhost/form',
          buildSimplePostRequestData('http://localhost')
        )

        expect(res.status).toBe(200)
        expect(await res.text()).toBe('hono')
      })

      it('should be 403 for "application/x-www-form-urlencoded" cross origin', async () => {
        /*
         * via http://example.com
         *
         * <form action="http://localhost/form" method="POST">
         *   <input name="name" value="hono" />
         * </form>
         * or
         * <script>
         * fetch('http://localhost/form', {
         *   method: 'POST',
         *   headers: {
         *     'content-type': 'application/x-www-form-urlencoded',
         *   },
         *   body: 'name=hono',
         * });
         * </script>
         */
        const res = await app.request(
          'http://localhost/form',
          buildSimplePostRequestData('http://example.com')
        )

        expect(res.status).toBe(403)
        expect(simplePostHandler).not.toHaveBeenCalled()
      })
    })

    it('should be 403 for "multipart/form-data" cross origin', async () => {
      /*
       * via http://example.com
       *
       * <form action="http://localhost/form" method="POST" enctype="multipart/form-data">
       *   <input name="name" value="hono" />
       * </form>
       * or
       * <script>
       * fetch('http://localhost/form', {
       *   method: 'POST',
       *   headers: {
       *     'content-type': 'multipart/form-data',
       *   },
       *   body: 'name=hono',
       * });
       * </script>
       */
      const res = await app.request(
        'http://localhost/form',
        buildSimplePostRequestData('http://example.com')
      )

      expect(res.status).toBe(403)
      expect(simplePostHandler).not.toHaveBeenCalled()
    })

    it('should be 403 for "text/plain" cross origin', async () => {
      /*
       * via http://example.com
       *
       * <form action="http://localhost/form" method="POST" enctype="text/plain">
       *   <input name="name" value="hono" />
       * </form>
       * or
       * <script>
       * fetch('http://localhost/form', {
       *   method: 'POST',
       *   headers: {
       *     'content-type': 'text/plain',
       *   },
       *   body: 'name=hono',
       * });
       * </script>
       */
      const res = await app.request(
        'http://localhost/form',
        buildSimplePostRequestData('http://example.com')
      )

      expect(res.status).toBe(403)
      expect(simplePostHandler).not.toHaveBeenCalled()
    })

    it('should be 403 if request has no origin header', async () => {
      const res = await app.request('http://localhost/form', buildSimplePostRequestData())

      expect(res.status).toBe(403)
      expect(simplePostHandler).not.toHaveBeenCalled()
    })

    it('should be 200 for application/json', async () => {
      /*
       * via http://example.com
       * Assume localhost allows cross origin POST
       *
       * <script>
       * fetch('http://localhost/form', {
       *   method: 'POST',
       *   headers: {
       *     'content-type': 'application/json',
       *   },
       *   body: JSON.stringify({ name: 'hono' }),
       * });
       * </script>
       */
      const res = await app.request('http://localhost/form', {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          origin: 'http://example.com',
        },
        body: JSON.stringify({ name: 'hono' }),
      })

      expect(res.status).toBe(200)
      expect(await res.text()).toBe('hono')
    })

    it('should be 403 for "Application/x-www-form-urlencoded" cross origin', async () => {
      const res = await app.request('http://localhost/form', {
        method: 'POST',
        headers: Object.assign({
          'content-type': 'Application/x-www-form-urlencoded',
        }),
        body: 'name=hono',
      })
      expect(res.status).toBe(403)
      expect(simplePostHandler).not.toHaveBeenCalled()
    })

    it('should be 403 if the content-type is not set', async () => {
      const res = await app.request('/form', {
        method: 'POST',
        body: new Blob(['test'], {}),
      })
      expect(res.status).toBe(403)
      expect(simplePostHandler).not.toHaveBeenCalled()
    })
  })

  describe('with origin option', () => {
    describe('string', () => {
      const app = new Hono()

      app.use(
        '*',
        csrf({
          origin: 'https://example.com',
        })
      )
      app.post('/form', simplePostHandler)

      it('should be 200 for allowed origin', async () => {
        const res = await app.request(
          'https://example.com/form',
          buildSimplePostRequestData('https://example.com')
        )
        expect(res.status).toBe(200)
      })

      it('should be 403 for not allowed origin', async () => {
        const res = await app.request(
          'https://example.jp/form',
          buildSimplePostRequestData('https://example.jp')
        )
        expect(res.status).toBe(403)
        expect(simplePostHandler).not.toHaveBeenCalled()
      })
    })

    describe('string[]', () => {
      const app = new Hono()

      app.use(
        '*',
        csrf({
          origin: ['https://example.com', 'https://hono.example.com'],
        })
      )
      app.post('/form', simplePostHandler)

      it('should be 200 for allowed origin', async () => {
        let res = await app.request(
          'https://hono.example.com/form',
          buildSimplePostRequestData('https://hono.example.com')
        )
        expect(res.status).toBe(200)

        res = await app.request(
          'https://example.com/form',
          buildSimplePostRequestData('https://example.com')
        )
        expect(res.status).toBe(200)
      })

      it('should be 403 for not allowed origin', async () => {
        const res = await app.request(
          'http://example.jp/form',
          buildSimplePostRequestData('http://example.jp')
        )
        expect(res.status).toBe(403)
        expect(simplePostHandler).not.toHaveBeenCalled()
      })
    })

    describe('IsAllowedOriginHandler', () => {
      const app = new Hono()

      app.use(
        '*',
        csrf({
          origin: (origin) => /https:\/\/(\w+\.)?example\.com$/.test(origin),
        })
      )
      app.post('/form', simplePostHandler)

      it('should be 200 for allowed origin', async () => {
        let res = await app.request(
          'https://hono.example.com/form',
          buildSimplePostRequestData('https://hono.example.com')
        )
        expect(res.status).toBe(200)

        res = await app.request(
          'https://example.com/form',
          buildSimplePostRequestData('https://example.com')
        )
        expect(res.status).toBe(200)
      })

      it('should be 403 for not allowed origin', async () => {
        let res = await app.request(
          'http://honojs.hono.example.jp/form',
          buildSimplePostRequestData('http://example.jp')
        )
        expect(res.status).toBe(403)
        expect(simplePostHandler).not.toHaveBeenCalled()

        res = await app.request(
          'http://example.jp/form',
          buildSimplePostRequestData('http://example.jp')
        )
        expect(res.status).toBe(403)
        expect(simplePostHandler).not.toHaveBeenCalled()
      })
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/csrf/index.ts
````typescript
/**
 * @module
 * CSRF Protection Middleware for Hono.
 */

import type { Context } from '../../context'
import { HTTPException } from '../../http-exception'
import type { MiddlewareHandler } from '../../types'

type IsAllowedOriginHandler = (origin: string, context: Context) => boolean
interface CSRFOptions {
  origin?: string | string[] | IsAllowedOriginHandler
}

const isSafeMethodRe = /^(GET|HEAD)$/
const isRequestedByFormElementRe =
  /^\b(application\/x-www-form-urlencoded|multipart\/form-data|text\/plain)\b/i

/**
 * CSRF Protection Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/csrf}
 *
 * @param {CSRFOptions} [options] - The options for the CSRF protection middleware.
 * @param {string|string[]|(origin: string, context: Context) => boolean} [options.origin] - Specify origins.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use(csrf())
 *
 * // Specifying origins with using `origin` option
 * // string
 * app.use(csrf({ origin: 'myapp.example.com' }))
 *
 * // string[]
 * app.use(
 *   csrf({
 *     origin: ['myapp.example.com', 'development.myapp.example.com'],
 *   })
 * )
 *
 * // Function
 * // It is strongly recommended that the protocol be verified to ensure a match to `$`.
 * // You should *never* do a forward match.
 * app.use(
 *   '*',
 *   csrf({
 *     origin: (origin) => /https:\/\/(\w+\.)?myapp\.example\.com$/.test(origin),
 *   })
 * )
 * ```
 */
export const csrf = (options?: CSRFOptions): MiddlewareHandler => {
  const handler: IsAllowedOriginHandler = ((optsOrigin) => {
    if (!optsOrigin) {
      return (origin, c) => origin === new URL(c.req.url).origin
    } else if (typeof optsOrigin === 'string') {
      return (origin) => origin === optsOrigin
    } else if (typeof optsOrigin === 'function') {
      return optsOrigin
    } else {
      return (origin) => optsOrigin.includes(origin)
    }
  })(options?.origin)
  const isAllowedOrigin = (origin: string | undefined, c: Context) => {
    if (origin === undefined) {
      // denied always when origin header is not present
      return false
    }
    return handler(origin, c)
  }

  return async function csrf(c, next) {
    if (
      !isSafeMethodRe.test(c.req.method) &&
      isRequestedByFormElementRe.test(c.req.header('content-type') || 'text/plain') &&
      !isAllowedOrigin(c.req.header('origin'), c)
    ) {
      const res = new Response('Forbidden', {
        status: 403,
      })
      throw new HTTPException(403, { res })
    }

    await next()
  }
}

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/body-limit/index.test.ts
```typescript
import { Hono } from '../../hono'
import { bodyLimit } from '.'

const buildRequestInit = (init: RequestInit = {}): RequestInit & { duplex: 'half' } => {
  const headers: Record<string, string> = {
    'Content-Type': 'text/plain',
  }
  if (typeof init.body === 'string') {
    headers['Content-Length'] = init.body.length.toString()
  }
  return {
    method: 'POST',
    headers,
    body: null,
    ...init,
    duplex: 'half',
  }
}

describe('Body Limit Middleware', () => {
  let app: Hono

  const exampleText = 'hono is so hot' // 14byte
  const exampleText2 = 'hono is so hot and cute' // 23byte

  beforeEach(() => {
    app = new Hono()
    app.use('*', bodyLimit({ maxSize: 14 }))
    app.get('/', (c) => c.text('index'))
    app.post('/body-limit-15byte', async (c) => {
      return c.text(await c.req.raw.text())
    })
  })

  describe('GET request', () => {
    it('should return 200 response', async () => {
      const res = await app.request('/')
      expect(res).not.toBeNull()
      expect(res.status).toBe(200)
      expect(await res.text()).toBe('index')
    })
  })

  describe('POST request', () => {
    describe('string body', () => {
      it('should return 200 response', async () => {
        const res = await app.request('/body-limit-15byte', buildRequestInit({ body: exampleText }))

        expect(res).not.toBeNull()
        expect(res.status).toBe(200)
        expect(await res.text()).toBe(exampleText)
      })

      it('should return 413 response', async () => {
        const res = await app.request(
          '/body-limit-15byte',
          buildRequestInit({ body: exampleText2 })
        )

        expect(res).not.toBeNull()
        expect(res.status).toBe(413)
        expect(await res.text()).toBe('Payload Too Large')
      })
    })

    describe('ReadableStream body', () => {
      it('should return 200 response', async () => {
        const contents = ['a', 'b', 'c']
        const stream = new ReadableStream({
          start(controller) {
            while (contents.length) {
              controller.enqueue(new TextEncoder().encode(contents.shift() as string))
            }
            controller.close()
          },
        })
        const res = await app.request('/body-limit-15byte', buildRequestInit({ body: stream }))

        expect(res).not.toBeNull()
        expect(res.status).toBe(200)
        expect(await res.text()).toBe('abc')
      })

      it('should return 413 response', async () => {
        const readSpy = vi.fn().mockImplementation(() => {
          return {
            done: false,
            value: new TextEncoder().encode(exampleText),
          }
        })
        const stream = new ReadableStream()
        vi.spyOn(stream, 'getReader').mockReturnValue({
          read: readSpy,
        } as unknown as ReadableStreamDefaultReader)
        const res = await app.request('/body-limit-15byte', buildRequestInit({ body: stream }))

        expect(res).not.toBeNull()
        expect(res.status).toBe(413)
        expect(readSpy).toHaveBeenCalledTimes(2)
        expect(await res.text()).toBe('Payload Too Large')
      })
    })
  })

  describe('custom error handler', () => {
    beforeEach(() => {
      app = new Hono()
      app.post(
        '/text-limit-15byte-custom',
        bodyLimit({
          maxSize: 15,
          onError: (c) => {
            return c.text('no', 413)
          },
        }),
        (c) => {
          return c.text('yes')
        }
      )
    })

    it('should return the custom error handler', async () => {
      const res = await app.request(
        '/text-limit-15byte-custom',
        buildRequestInit({ body: exampleText2 })
      )

      expect(res).not.toBeNull()
      expect(res.status).toBe(413)
      expect(await res.text()).toBe('no')
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/body-limit/index.ts
````typescript
/**
 * @module
 * Body Limit Middleware for Hono.
 */

import type { Context } from '../../context'
import { HTTPException } from '../../http-exception'
import type { MiddlewareHandler } from '../../types'

const ERROR_MESSAGE = 'Payload Too Large'

type OnError = (c: Context) => Response | Promise<Response>
type BodyLimitOptions = {
  maxSize: number
  onError?: OnError
}

class BodyLimitError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'BodyLimitError'
  }
}

/**
 * Body Limit Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/body-limit}
 *
 * @param {BodyLimitOptions} options - The options for the body limit middleware.
 * @param {number} options.maxSize - The maximum body size allowed.
 * @param {OnError} [options.onError] - The error handler to be invoked if the specified body size is exceeded.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.post(
 *   '/upload',
 *   bodyLimit({
 *     maxSize: 50 * 1024, // 50kb
 *     onError: (c) => {
 *       return c.text('overflow :(', 413)
 *     },
 *   }),
 *   async (c) => {
 *     const body = await c.req.parseBody()
 *     if (body['file'] instanceof File) {
 *       console.log(`Got file sized: ${body['file'].size}`)
 *     }
 *     return c.text('pass :)')
 *   }
 * )
 * ```
 */
export const bodyLimit = (options: BodyLimitOptions): MiddlewareHandler => {
  const onError: OnError =
    options.onError ||
    (() => {
      const res = new Response(ERROR_MESSAGE, {
        status: 413,
      })
      throw new HTTPException(413, { res })
    })
  const maxSize = options.maxSize

  return async function bodyLimit(c, next) {
    if (!c.req.raw.body) {
      // maybe GET or HEAD request
      return next()
    }

    if (c.req.raw.headers.has('content-length')) {
      // we can trust content-length header because it's already validated by server
      const contentLength = parseInt(c.req.raw.headers.get('content-length') || '0', 10)
      return contentLength > maxSize ? onError(c) : next()
    }

    // maybe chunked transfer encoding

    let size = 0
    const rawReader = c.req.raw.body.getReader()
    const reader = new ReadableStream({
      async start(controller) {
        try {
          for (;;) {
            const { done, value } = await rawReader.read()
            if (done) {
              break
            }
            size += value.length
            if (size > maxSize) {
              controller.error(new BodyLimitError(ERROR_MESSAGE))
              break
            }

            controller.enqueue(value)
          }
        } finally {
          controller.close()
        }
      },
    })

    const requestInit: RequestInit & { duplex: 'half' } = { body: reader, duplex: 'half' }
    c.req.raw = new Request(c.req.raw, requestInit as RequestInit)

    await next()

    if (c.error instanceof BodyLimitError) {
      c.res = await onError(c)
    }
  }
}

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/bearer-auth/index.test.ts
```typescript
import { Hono } from '../../hono'
import { bearerAuth } from '.'

describe('Bearer Auth by Middleware', () => {
  let app: Hono
  let handlerExecuted: boolean
  let token: string
  let tokens: string[]

  beforeEach(async () => {
    app = new Hono()
    handlerExecuted = false
    token = 'abcdefg12345-._~+/='
    tokens = ['abcdefg12345-._~+/=', 'alternative']

    app.use('/auth/*', bearerAuth({ token }))
    app.use('/auth/*', async (c, next) => {
      c.header('x-custom', 'foo')
      await next()
    })
    app.get('/auth/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use('/authBot/*', bearerAuth({ token, prefix: 'Bot' }))
    app.get('/authBot/*', (c) => {
      handlerExecuted = true
      return c.text('auth bot')
    })

    app.use('/apiKey/*', bearerAuth({ token, prefix: '', headerName: 'X-Api-Key' }))
    app.get('/apiKey/*', (c) => {
      handlerExecuted = true
      return c.text('auth apiKey')
    })

    app.use('/nested/*', async (c, next) => {
      const auth = bearerAuth({ token })
      return auth(c, next)
    })
    app.get('/nested/*', (c) => {
      handlerExecuted = true
      return c.text('auth nested')
    })

    app.use('/auths/*', bearerAuth({ token: tokens }))
    app.get('/auths/*', (c) => {
      handlerExecuted = true
      return c.text('auths')
    })

    app.use(
      '/auth-verify-token/*',
      bearerAuth({
        verifyToken: async (token, c) => {
          return c.req.path === '/auth-verify-token' && token === 'dynamic-token'
        },
      })
    )
    app.get('/auth-verify-token/*', (c) => {
      handlerExecuted = true
      return c.text('auth-verify-token')
    })

    app.use('/auth-custom-header/*', bearerAuth({ token: tokens, headerName: 'X-Auth' }))
    app.get('/auth-custom-header/*', (c) => {
      handlerExecuted = true
      return c.text('auth-custom-header')
    })

    app.use(
      '/auth-custom-no-authentication-header-message-string/*',
      bearerAuth({
        token,
        noAuthenticationHeaderMessage: 'Custom no authentication header message as string',
      })
    )
    app.get('/auth-custom-no-authentication-header-message-string/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-no-authentication-header-message-object/*',
      bearerAuth({
        token,
        noAuthenticationHeaderMessage: {
          message: 'Custom no authentication header message as object',
        },
      })
    )
    app.get('/auth-custom-no-authentication-header-message-object/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-no-authentication-header-message-function-string/*',
      bearerAuth({
        token,
        noAuthenticationHeaderMessage: () =>
          'Custom no authentication header message as function string',
      })
    )
    app.get('/auth-custom-no-authentication-header-message-function-string/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-no-authentication-header-message-function-object/*',
      bearerAuth({
        token,
        noAuthenticationHeaderMessage: () => ({
          message: 'Custom no authentication header message as function object',
        }),
      })
    )
    app.get('/auth-custom-no-authentication-header-message-function-object/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-authentication-header-message-string/*',
      bearerAuth({
        token,
        invalidAuthenticationHeaderMessage:
          'Custom invalid authentication header message as string',
      })
    )
    app.get('/auth-custom-invalid-authentication-header-message-string/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-authentication-header-message-object/*',
      bearerAuth({
        token,
        invalidAuthenticationHeaderMessage: {
          message: 'Custom invalid authentication header message as object',
        },
      })
    )
    app.get('/auth-custom-invalid-authentication-header-message-object/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-authentication-header-message-function-string/*',
      bearerAuth({
        token,
        invalidAuthenticationHeaderMessage: () =>
          'Custom invalid authentication header message as function string',
      })
    )
    app.get('/auth-custom-invalid-authentication-header-message-function-string/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-authentication-header-message-function-object/*',
      bearerAuth({
        token,
        invalidAuthenticationHeaderMessage: () => ({
          message: 'Custom invalid authentication header message as function object',
        }),
      })
    )
    app.get('/auth-custom-invalid-authentication-header-message-function-object/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-token-message-string/*',
      bearerAuth({
        token,
        invalidTokenMessage: 'Custom invalid token message as string',
      })
    )
    app.get('/auth-custom-invalid-token-message-string/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-token-message-object/*',
      bearerAuth({
        token,
        invalidTokenMessage: { message: 'Custom invalid token message as object' },
      })
    )
    app.get('/auth-custom-invalid-token-message-object/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-token-message-function-string/*',
      bearerAuth({
        token,
        invalidTokenMessage: () => 'Custom invalid token message as function string',
      })
    )
    app.get('/auth-custom-invalid-token-message-function-string/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })

    app.use(
      '/auth-custom-invalid-token-message-function-object/*',
      bearerAuth({
        token,
        invalidTokenMessage: () => ({
          message: 'Custom invalid token message as function object',
        }),
      })
    )
    app.get('/auth-custom-invalid-token-message-function-object/*', (c) => {
      handlerExecuted = true
      return c.text('auth')
    })
  })

  it('Should authorize', async () => {
    const req = new Request('http://localhost/auth/a')
    req.headers.set('Authorization', 'Bearer abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res.text()).toBe('auth')
    expect(res.headers.get('x-custom')).toBe('foo')
  })

  it('Should not authorize - no authorization header', async () => {
    const req = new Request('http://localhost/auth/a')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Unauthorized')
    expect(res.headers.get('x-custom')).toBeNull()
  })

  it('Should not authorize - invalid request', async () => {
    const req = new Request('http://localhost/auth/a')
    req.headers.set('Authorization', 'Beare abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(handlerExecuted).toBeFalsy()
    expect(res.status).toBe(400)
    expect(await res.text()).toBe('Bad Request')
    expect(res.headers.get('x-custom')).toBeNull()
  })

  it('Should not authorize - invalid token', async () => {
    const req = new Request('http://localhost/auth/a')
    req.headers.set('Authorization', 'Bearer invalid-token')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
    expect(res.headers.get('x-custom')).toBeNull()
  })

  it('Should authorize', async () => {
    const req = new Request('http://localhost/authBot/a')
    req.headers.set('Authorization', 'Bot abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res.text()).toBe('auth bot')
  })

  it('Should not authorize - invalid request', async () => {
    const req = new Request('http://localhost/authBot/a')
    req.headers.set('Authorization', 'Bearer abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(handlerExecuted).toBeFalsy()
    expect(res.status).toBe(400)
    expect(await res.text()).toBe('Bad Request')
  })

  it('Should authorize', async () => {
    const req = new Request('http://localhost/apiKey/a')
    req.headers.set('X-Api-Key', 'abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res.text()).toBe('auth apiKey')
  })

  it('Should not authorize - invalid request', async () => {
    const req = new Request('http://localhost/apiKey/a')
    req.headers.set('Authorization', 'Bearer abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(handlerExecuted).toBeFalsy()
    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
  })

  it('Should authorize - nested', async () => {
    const req = new Request('http://localhost/nested/a')
    req.headers.set('Authorization', 'Bearer abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res.text()).toBe('auth nested')
  })

  it('Should not authorize - nested', async () => {
    const req = new Request('http://localhost/nested/a')
    req.headers.set('Authorization', 'Bearer invalid-token')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(handlerExecuted).toBeFalsy()
    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
  })

  it('Should authorize - with any token in list', async () => {
    const req1 = new Request('http://localhost/auths/a')
    req1.headers.set('Authorization', 'Bearer abcdefg12345-._~+/=')
    const res1 = await app.request(req1)
    expect(res1).not.toBeNull()
    expect(res1.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res1.text()).toBe('auths')

    const req2 = new Request('http://localhost/auths/a')
    req2.headers.set('Authorization', 'Bearer alternative')
    const res2 = await app.request(req2)
    expect(res2).not.toBeNull()
    expect(res2.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res2.text()).toBe('auths')
  })

  it('Should authorize - verifyToken option', async () => {
    const res = await app.request('/auth-verify-token', {
      headers: { Authorization: 'Bearer dynamic-token' },
    })
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res.text()).toBe('auth-verify-token')
  })

  it('Should not authorize - verifyToken option', async () => {
    const res = await app.request('/auth-verify-token', {
      headers: { Authorization: 'Bearer invalid-token' },
    })
    expect(res).not.toBeNull()
    expect(handlerExecuted).toBeFalsy()
    expect(res.status).toBe(401)
  })

  it('Should authorize - custom header', async () => {
    const req = new Request('http://localhost/auth-custom-header/a')
    req.headers.set('X-Auth', 'Bearer abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(handlerExecuted).toBeTruthy()
    expect(await res.text()).toBe('auth-custom-header')
  })

  it('Should not authorize - custom header', async () => {
    const req = new Request('http://localhost/auth-custom-header/a')
    req.headers.set('X-Auth', 'Bearer invalid-token')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(handlerExecuted).toBeFalsy()
    expect(res.status).toBe(401)
    expect(await res.text()).toBe('Unauthorized')
  })

  it('Should not authorize - custom no authorization header message as string', async () => {
    const req = new Request('http://localhost/auth-custom-no-authentication-header-message-string')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Custom no authentication header message as string')
  })

  it('Should not authorize - custom no authorization header message as object', async () => {
    const req = new Request('http://localhost/auth-custom-no-authentication-header-message-object')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(res.headers.get('Content-Type')).toMatch('application/json')
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('{"message":"Custom no authentication header message as object"}')
  })

  it('Should not authorize - custom no authorization header message as function string', async () => {
    const req = new Request(
      'http://localhost/auth-custom-no-authentication-header-message-function-string'
    )
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Custom no authentication header message as function string')
  })

  it('Should not authorize - custom no authorization header message as function object', async () => {
    const req = new Request(
      'http://localhost/auth-custom-no-authentication-header-message-function-object'
    )
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(res.headers.get('Content-Type')).toMatch('application/json')
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe(
      '{"message":"Custom no authentication header message as function object"}'
    )
  })

  it('Should not authorize - custom invalid authentication header message as string', async () => {
    const req = new Request(
      'http://localhost/auth-custom-invalid-authentication-header-message-string'
    )
    req.headers.set('Authorization', 'Beare abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(400)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Custom invalid authentication header message as string')
  })

  it('Should not authorize - custom invalid authentication header message as object', async () => {
    const req = new Request(
      'http://localhost/auth-custom-invalid-authentication-header-message-object'
    )
    req.headers.set('Authorization', 'Beare abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(400)
    expect(res.headers.get('Content-Type')).toMatch('application/json')
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe(
      '{"message":"Custom invalid authentication header message as object"}'
    )
  })

  it('Should not authorize - custom invalid authentication header message as function string', async () => {
    const req = new Request(
      'http://localhost/auth-custom-invalid-authentication-header-message-function-string'
    )
    req.headers.set('Authorization', 'Beare abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(400)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Custom invalid authentication header message as function string')
  })

  it('Should not authorize - custom invalid authentication header message as function object', async () => {
    const req = new Request(
      'http://localhost/auth-custom-invalid-authentication-header-message-function-object'
    )
    req.headers.set('Authorization', 'Beare abcdefg12345-._~+/=')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(400)
    expect(res.headers.get('Content-Type')).toMatch('application/json')
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe(
      '{"message":"Custom invalid authentication header message as function object"}'
    )
  })

  it('Should not authorize - custom invalid token message as string', async () => {
    const req = new Request('http://localhost/auth-custom-invalid-token-message-string')
    req.headers.set('Authorization', 'Bearer invalid-token')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Custom invalid token message as string')
  })

  it('Should not authorize - custom invalid token message as object', async () => {
    const req = new Request('http://localhost/auth-custom-invalid-token-message-object')
    req.headers.set('Authorization', 'Bearer invalid-token')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(res.headers.get('Content-Type')).toMatch('application/json')
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('{"message":"Custom invalid token message as object"}')
  })

  it('Should not authorize - custom invalid token message as function string', async () => {
    const req = new Request('http://localhost/auth-custom-invalid-token-message-function-string')
    req.headers.set('Authorization', 'Bearer invalid-token')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('Custom invalid token message as function string')
  })

  it('Should not authorize - custom invalid token message as function object', async () => {
    const req = new Request('http://localhost/auth-custom-invalid-token-message-function-object')
    req.headers.set('Authorization', 'Bearer invalid-token')
    const res = await app.request(req)
    expect(res).not.toBeNull()
    expect(res.status).toBe(401)
    expect(res.headers.get('Content-Type')).toMatch('application/json')
    expect(handlerExecuted).toBeFalsy()
    expect(await res.text()).toBe('{"message":"Custom invalid token message as function object"}')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/bearer-auth/index.ts
````typescript
/**
 * @module
 * Bearer Auth Middleware for Hono.
 */

import type { Context } from '../../context'
import { HTTPException } from '../../http-exception'
import type { MiddlewareHandler } from '../../types'
import { timingSafeEqual } from '../../utils/buffer'
import type { ContentfulStatusCode } from '../../utils/http-status'

const TOKEN_STRINGS = '[A-Za-z0-9._~+/-]+=*'
const PREFIX = 'Bearer'
const HEADER = 'Authorization'

type MessageFunction = (c: Context) => string | object | Promise<string | object>

type BearerAuthOptions =
  | {
      token: string | string[]
      realm?: string
      prefix?: string
      headerName?: string
      hashFunction?: Function
      noAuthenticationHeaderMessage?: string | object | MessageFunction
      invalidAuthenticationHeaderMessage?: string | object | MessageFunction
      invalidTokenMessage?: string | object | MessageFunction
    }
  | {
      realm?: string
      prefix?: string
      headerName?: string
      verifyToken: (token: string, c: Context) => boolean | Promise<boolean>
      hashFunction?: Function
      noAuthenticationHeaderMessage?: string | object | MessageFunction
      invalidAuthenticationHeaderMessage?: string | object | MessageFunction
      invalidTokenMessage?: string | object | MessageFunction
    }

/**
 * Bearer Auth Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/bearer-auth}
 *
 * @param {BearerAuthOptions} options - The options for the bearer authentication middleware.
 * @param {string | string[]} [options.token] - The string or array of strings to validate the incoming bearer token against.
 * @param {Function} [options.verifyToken] - The function to verify the token.
 * @param {string} [options.realm=""] - The domain name of the realm, as part of the returned WWW-Authenticate challenge header.
 * @param {string} [options.prefix="Bearer"] - The prefix (or known as `schema`) for the Authorization header value. If set to the empty string, no prefix is expected.
 * @param {string} [options.headerName=Authorization] - The header name.
 * @param {Function} [options.hashFunction] - A function to handle hashing for safe comparison of authentication tokens.
 * @param {string | object | MessageFunction} [options.noAuthenticationHeaderMessage="Unauthorized"] - The no authentication header message.
 * @param {string | object | MessageFunction} [options.invalidAuthenticationHeaderMeasage="Bad Request"] - The invalid authentication header message.
 * @param {string | object | MessageFunction} [options.invalidTokenMessage="Unauthorized"] - The invalid token message.
 * @returns {MiddlewareHandler} The middleware handler function.
 * @throws {Error} If neither "token" nor "verifyToken" options are provided.
 * @throws {HTTPException} If authentication fails, with 401 status code for missing or invalid token, or 400 status code for invalid request.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * const token = 'honoishot'
 *
 * app.use('/api/*', bearerAuth({ token }))
 *
 * app.get('/api/page', (c) => {
 *   return c.json({ message: 'You are authorized' })
 * })
 * ```
 */
export const bearerAuth = (options: BearerAuthOptions): MiddlewareHandler => {
  if (!('token' in options || 'verifyToken' in options)) {
    throw new Error('bearer auth middleware requires options for "token"')
  }
  if (!options.realm) {
    options.realm = ''
  }
  if (options.prefix === undefined) {
    options.prefix = PREFIX
  }

  const realm = options.realm?.replace(/"/g, '\\"')
  const prefixRegexStr = options.prefix === '' ? '' : `${options.prefix} +`
  const regexp = new RegExp(`^${prefixRegexStr}(${TOKEN_STRINGS}) *$`)
  const wwwAuthenticatePrefix = options.prefix === '' ? '' : `${options.prefix} `

  const throwHTTPException = async (
    c: Context,
    status: ContentfulStatusCode,
    wwwAuthenticateHeader: string,
    messageOption: string | object | MessageFunction
  ): Promise<Response> => {
    const headers = {
      'WWW-Authenticate': wwwAuthenticateHeader,
    }
    const responseMessage =
      typeof messageOption === 'function' ? await messageOption(c) : messageOption
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

  return async function bearerAuth(c, next) {
    const headerToken = c.req.header(options.headerName || HEADER)
    if (!headerToken) {
      // No Authorization header
      await throwHTTPException(
        c,
        401,
        `${wwwAuthenticatePrefix}realm="${realm}"`,
        options.noAuthenticationHeaderMessage || 'Unauthorized'
      )
    } else {
      const match = regexp.exec(headerToken)
      if (!match) {
        // Invalid Request
        await throwHTTPException(
          c,
          400,
          `${wwwAuthenticatePrefix}error="invalid_request"`,
          options.invalidAuthenticationHeaderMessage || 'Bad Request'
        )
      } else {
        let equal = false
        if ('verifyToken' in options) {
          equal = await options.verifyToken(match[1], c)
        } else if (typeof options.token === 'string') {
          equal = await timingSafeEqual(options.token, match[1], options.hashFunction)
        } else if (Array.isArray(options.token) && options.token.length > 0) {
          for (const token of options.token) {
            if (await timingSafeEqual(token, match[1], options.hashFunction)) {
              equal = true
              break
            }
          }
        }
        if (!equal) {
          // Invalid Token
          await throwHTTPException(
            c,
            401,
            `${wwwAuthenticatePrefix}error="invalid_token"`,
            options.invalidTokenMessage || 'Unauthorized'
          )
        }
      }
    }
    await next()
  }
}

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/cors/index.test.ts
```typescript
import { Hono } from '../../hono'
import { cors } from '../../middleware/cors'

describe('CORS by Middleware', () => {
  const app = new Hono()

  app.use('/api/*', cors())

  app.use(
    '/api2/*',
    cors({
      origin: 'http://example.com',
      allowHeaders: ['X-Custom-Header', 'Upgrade-Insecure-Requests'],
      allowMethods: ['POST', 'GET', 'OPTIONS'],
      exposeHeaders: ['Content-Length', 'X-Kuma-Revision'],
      maxAge: 600,
      credentials: true,
    })
  )

  app.use(
    '/api3/*',
    cors({
      origin: ['http://example.com', 'http://example.org', 'http://example.dev'],
    })
  )

  app.use(
    '/api4/*',
    cors({
      origin: (origin) => (origin.endsWith('.example.com') ? origin : 'http://example.com'),
    })
  )

  app.use('/api5/*', cors())

  app.use(
    '/api6/*',
    cors({
      origin: 'http://example.com',
    })
  )
  app.use(
    '/api6/*',
    cors({
      origin: 'http://example.com',
    })
  )

  app.get('/api/abc', (c) => {
    return c.json({ success: true })
  })

  app.get('/api2/abc', (c) => {
    return c.json({ success: true })
  })

  app.get('/api3/abc', (c) => {
    return c.json({ success: true })
  })

  app.get('/api4/abc', (c) => {
    return c.json({ success: true })
  })

  app.get('/api5/abc', () => {
    return new Response(JSON.stringify({ success: true }))
  })

  it('GET default', async () => {
    const res = await app.request('http://localhost/api/abc')

    expect(res.status).toBe(200)
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('*')
    expect(res.headers.get('Vary')).toBeNull()
  })

  it('Preflight default', async () => {
    const req = new Request('https://localhost/api/abc', { method: 'OPTIONS' })
    req.headers.append('Access-Control-Request-Headers', 'X-PINGOTHER, Content-Type')
    const res = await app.request(req)

    expect(res.status).toBe(204)
    expect(res.statusText).toBe('No Content')
    expect(res.headers.get('Access-Control-Allow-Methods')?.split(',')[0]).toBe('GET')
    expect(res.headers.get('Access-Control-Allow-Headers')?.split(',')).toEqual([
      'X-PINGOTHER',
      'Content-Type',
    ])
  })

  it('Preflight with options', async () => {
    const req = new Request('https://localhost/api2/abc', {
      method: 'OPTIONS',
      headers: { origin: 'http://example.com' },
    })
    const res = await app.request(req)

    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('http://example.com')
    expect(res.headers.get('Vary')?.split(/\s*,\s*/)).toEqual(expect.arrayContaining(['Origin']))
    expect(res.headers.get('Access-Control-Allow-Headers')?.split(/\s*,\s*/)).toEqual([
      'X-Custom-Header',
      'Upgrade-Insecure-Requests',
    ])
    expect(res.headers.get('Access-Control-Allow-Methods')?.split(/\s*,\s*/)).toEqual([
      'POST',
      'GET',
      'OPTIONS',
    ])
    expect(res.headers.get('Access-Control-Expose-Headers')?.split(/\s*,\s*/)).toEqual([
      'Content-Length',
      'X-Kuma-Revision',
    ])
    expect(res.headers.get('Access-Control-Max-Age')).toBe('600')
    expect(res.headers.get('Access-Control-Allow-Credentials')).toBe('true')
  })

  it('Disallow an unmatched origin', async () => {
    const req = new Request('https://localhost/api2/abc', {
      method: 'OPTIONS',
      headers: { origin: 'http://example.net' },
    })
    const res = await app.request(req)
    expect(res.headers.has('Access-Control-Allow-Origin')).toBeFalsy()
  })

  it('Allow multiple origins', async () => {
    let req = new Request('http://localhost/api3/abc', {
      headers: {
        Origin: 'http://example.org',
      },
    })
    let res = await app.request(req)
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('http://example.org')

    req = new Request('http://localhost/api3/abc')
    res = await app.request(req)
    expect(
      res.headers.has('Access-Control-Allow-Origin'),
      'An unmatched origin should be disallowed'
    ).toBeFalsy()

    req = new Request('http://localhost/api3/abc', {
      headers: {
        Referer: 'http://example.net/',
      },
    })
    res = await app.request(req)
    expect(
      res.headers.has('Access-Control-Allow-Origin'),
      'An unmatched origin should be disallowed'
    ).toBeFalsy()
  })

  it('Allow different Vary header value', async () => {
    const res = await app.request('http://localhost/api3/abc', {
      headers: {
        Vary: 'accept-encoding',
        Origin: 'http://example.com',
      },
    })

    expect(res.status).toBe(200)
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('http://example.com')
    expect(res.headers.get('Vary')).toBe('accept-encoding')
  })

  it('Allow origins by function', async () => {
    let req = new Request('http://localhost/api4/abc', {
      headers: {
        Origin: 'http://subdomain.example.com',
      },
    })
    let res = await app.request(req)
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('http://subdomain.example.com')

    req = new Request('http://localhost/api4/abc')
    res = await app.request(req)
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('http://example.com')

    req = new Request('http://localhost/api4/abc', {
      headers: {
        Referer: 'http://evil-example.com/',
      },
    })
    res = await app.request(req)
    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('http://example.com')
  })

  it('With raw Response object', async () => {
    const res = await app.request('http://localhost/api5/abc')

    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('*')
    expect(res.headers.get('Vary')).toBeNull()
  })

  it('Should not return duplicate header values', async () => {
    const res = await app.request('http://localhost/api6/abc', {
      headers: {
        origin: 'http://example.com',
      },
    })

    expect(res.headers.get('Access-Control-Allow-Origin')).toBe('http://example.com')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/cors/index.ts
````typescript
/**
 * @module
 * CORS Middleware for Hono.
 */

import type { Context } from '../../context'
import type { MiddlewareHandler } from '../../types'

type CORSOptions = {
  origin: string | string[] | ((origin: string, c: Context) => string | undefined | null)
  allowMethods?: string[]
  allowHeaders?: string[]
  maxAge?: number
  credentials?: boolean
  exposeHeaders?: string[]
}

/**
 * CORS Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/cors}
 *
 * @param {CORSOptions} [options] - The options for the CORS middleware.
 * @param {string | string[] | ((origin: string, c: Context) => string | undefined | null)} [options.origin='*'] - The value of "Access-Control-Allow-Origin" CORS header.
 * @param {string[]} [options.allowMethods=['GET', 'HEAD', 'PUT', 'POST', 'DELETE', 'PATCH']] - The value of "Access-Control-Allow-Methods" CORS header.
 * @param {string[]} [options.allowHeaders=[]] - The value of "Access-Control-Allow-Headers" CORS header.
 * @param {number} [options.maxAge] - The value of "Access-Control-Max-Age" CORS header.
 * @param {boolean} [options.credentials] - The value of "Access-Control-Allow-Credentials" CORS header.
 * @param {string[]} [options.exposeHeaders=[]] - The value of "Access-Control-Expose-Headers" CORS header.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use('/api/*', cors())
 * app.use(
 *   '/api2/*',
 *   cors({
 *     origin: 'http://example.com',
 *     allowHeaders: ['X-Custom-Header', 'Upgrade-Insecure-Requests'],
 *     allowMethods: ['POST', 'GET', 'OPTIONS'],
 *     exposeHeaders: ['Content-Length', 'X-Kuma-Revision'],
 *     maxAge: 600,
 *     credentials: true,
 *   })
 * )
 *
 * app.all('/api/abc', (c) => {
 *   return c.json({ success: true })
 * })
 * app.all('/api2/abc', (c) => {
 *   return c.json({ success: true })
 * })
 * ```
 */
export const cors = (options?: CORSOptions): MiddlewareHandler => {
  const defaults: CORSOptions = {
    origin: '*',
    allowMethods: ['GET', 'HEAD', 'PUT', 'POST', 'DELETE', 'PATCH'],
    allowHeaders: [],
    exposeHeaders: [],
  }
  const opts = {
    ...defaults,
    ...options,
  }

  const findAllowOrigin = ((optsOrigin) => {
    if (typeof optsOrigin === 'string') {
      if (optsOrigin === '*') {
        return () => optsOrigin
      } else {
        return (origin: string) => (optsOrigin === origin ? origin : null)
      }
    } else if (typeof optsOrigin === 'function') {
      return optsOrigin
    } else {
      return (origin: string) => (optsOrigin.includes(origin) ? origin : null)
    }
  })(opts.origin)

  return async function cors(c, next) {
    function set(key: string, value: string) {
      c.res.headers.set(key, value)
    }

    const allowOrigin = findAllowOrigin(c.req.header('origin') || '', c)
    if (allowOrigin) {
      set('Access-Control-Allow-Origin', allowOrigin)
    }

    // Suppose the server sends a response with an Access-Control-Allow-Origin value with an explicit origin (rather than the "*" wildcard).
    // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin
    if (opts.origin !== '*') {
      const existingVary = c.req.header('Vary')

      if (existingVary) {
        set('Vary', existingVary)
      } else {
        set('Vary', 'Origin')
      }
    }

    if (opts.credentials) {
      set('Access-Control-Allow-Credentials', 'true')
    }

    if (opts.exposeHeaders?.length) {
      set('Access-Control-Expose-Headers', opts.exposeHeaders.join(','))
    }

    if (c.req.method === 'OPTIONS') {
      if (opts.maxAge != null) {
        set('Access-Control-Max-Age', opts.maxAge.toString())
      }

      if (opts.allowMethods?.length) {
        set('Access-Control-Allow-Methods', opts.allowMethods.join(','))
      }

      let headers = opts.allowHeaders
      if (!headers?.length) {
        const requestHeaders = c.req.header('Access-Control-Request-Headers')
        if (requestHeaders) {
          headers = requestHeaders.split(/\s*,\s*/)
        }
      }
      if (headers?.length) {
        set('Access-Control-Allow-Headers', headers.join(','))
        c.res.headers.append('Vary', 'Access-Control-Request-Headers')
      }

      c.res.headers.delete('Content-Length')
      c.res.headers.delete('Content-Type')

      return new Response(null, {
        headers: c.res.headers,
        status: 204,
        statusText: 'No Content',
      })
    }
    await next()
  }
}

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/serve-static/index.test.ts
```typescript
import { Hono } from '../../hono'
import { serveStatic as baseServeStatic } from '.'

describe('Serve Static Middleware', () => {
  const app = new Hono()
  const getContent = vi.fn(async (path) => {
    if (path.endsWith('not-found.txt')) {
      return null
    }
    return `Hello in ${path}`
  })

  const serveStatic = baseServeStatic({
    getContent,
    pathResolve: (path) => {
      return `./${path}`
    },
    isDir: (path) => {
      return path === 'static/hello.world'
    },
    onFound: (path, c) => {
      if (path.endsWith('hello.html')) {
        c.header('X-Custom', `Found the file at ${path}`)
      }
    },
  })

  app.get('/static/*', serveStatic)

  beforeEach(() => {
    getContent.mockClear()
  })

  it('Should return 200 response - /static/hello.html', async () => {
    const res = await app.request('/static/hello.html')
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Encoding')).toBeNull()
    expect(res.headers.get('Content-Type')).toMatch(/^text\/html/)
    expect(await res.text()).toBe('Hello in ./static/hello.html')
    expect(res.headers.get('X-Custom')).toBe('Found the file at ./static/hello.html')
  })

  it('Should return 200 response - /static/sub', async () => {
    const res = await app.request('/static/sub')
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toMatch(/^text\/html/)
    expect(await res.text()).toBe('Hello in ./static/sub/index.html')
  })

  it('Should return 200 response - /static/helloworld', async () => {
    const res = await app.request('/static/helloworld')
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toMatch(/^text\/html/)
    expect(await res.text()).toBe('Hello in ./static/helloworld/index.html')
  })

  it('Should return 200 response - /static/hello.world', async () => {
    const res = await app.request('/static/hello.world')
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toMatch(/^text\/html/)
    expect(await res.text()).toBe('Hello in ./static/hello.world/index.html')
  })

  it('Should decode URI strings - /static/%E7%82%8E.txt', async () => {
    const res = await app.request('/static/%E7%82%8E.txt')
    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Type')).toMatch(/^text\/plain/)
    expect(await res.text()).toBe('Hello in ./static/炎.txt')
  })

  it('Should return 404 response - /static/not-found.txt', async () => {
    const res = await app.request('/static/not-found.txt')
    expect(res.status).toBe(404)
    expect(res.headers.get('Content-Encoding')).toBeNull()
    expect(res.headers.get('Content-Type')).toMatch(/^text\/plain/)
    expect(await res.text()).toBe('404 Not Found')
    expect(getContent).toBeCalledTimes(1)
  })

  it('Should not allow a directory traversal - /static/%2e%2e/static/hello.html', async () => {
    const res = await app.fetch({
      method: 'GET',
      url: 'http://localhost/static/%2e%2e/static/hello.html',
    } as Request)
    expect(res.status).toBe(404)
    expect(res.headers.get('Content-Type')).toMatch(/^text\/plain/)
    expect(await res.text()).toBe('404 Not Found')
  })

  it('Should return a pre-compressed zstd response - /static/hello.html', async () => {
    const app = new Hono().use(
      '*',
      baseServeStatic({
        getContent,
        precompressed: true,
      })
    )

    const res = await app.request('/static/hello.html', {
      headers: { 'Accept-Encoding': 'zstd' },
    })

    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Encoding')).toBe('zstd')
    expect(res.headers.get('Vary')).toBe('Accept-Encoding')
    expect(res.headers.get('Content-Type')).toMatch(/^text\/html/)
    expect(await res.text()).toBe('Hello in static/hello.html.zst')
  })

  it('Should return a pre-compressed brotli response - /static/hello.html', async () => {
    const app = new Hono().use(
      '*',
      baseServeStatic({
        getContent,
        precompressed: true,
      })
    )

    const res = await app.request('/static/hello.html', {
      headers: { 'Accept-Encoding': 'wompwomp, gzip, br, deflate, zstd' },
    })

    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Encoding')).toBe('br')
    expect(res.headers.get('Vary')).toBe('Accept-Encoding')
    expect(res.headers.get('Content-Type')).toMatch(/^text\/html/)
    expect(await res.text()).toBe('Hello in static/hello.html.br')
  })

  it('Should return a pre-compressed brotli response - /static/hello.unknown', async () => {
    const app = new Hono().use(
      '*',
      baseServeStatic({
        getContent,
        precompressed: true,
      })
    )

    const res = await app.request('/static/hello.unknown', {
      headers: { 'Accept-Encoding': 'wompwomp, gzip, br, deflate, zstd' },
    })

    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Encoding')).toBe('br')
    expect(res.headers.get('Vary')).toBe('Accept-Encoding')
    expect(res.headers.get('Content-Type')).toBe('application/octet-stream')
    expect(await res.text()).toBe('Hello in static/hello.unknown.br')
  })

  it('Should not return a pre-compressed response - /static/not-found.txt', async () => {
    const app = new Hono().use(
      '*',
      baseServeStatic({
        getContent,
        precompressed: true,
      })
    )

    const res = await app.request('/static/not-found.txt', {
      headers: { 'Accept-Encoding': 'gzip, zstd, br' },
    })

    expect(res.status).toBe(404)
    expect(res.headers.get('Content-Encoding')).toBeNull()
    expect(res.headers.get('Vary')).toBeNull()
    expect(res.headers.get('Content-Type')).toMatch(/^text\/plain/)
    expect(await res.text()).toBe('404 Not Found')
  })

  it('Should not return a pre-compressed response - /static/hello.html', async () => {
    const app = new Hono().use(
      '*',
      baseServeStatic({
        getContent,
        precompressed: true,
      })
    )

    const res = await app.request('/static/hello.html', {
      headers: { 'Accept-Encoding': 'wompwomp, unknown' },
    })

    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Encoding')).toBeNull()
    expect(res.headers.get('Vary')).toBeNull()
    expect(res.headers.get('Content-Type')).toMatch(/^text\/html/)
    expect(await res.text()).toBe('Hello in static/hello.html')
  })

  it('Should not find pre-compressed files - /static/hello.jpg', async () => {
    const app = new Hono().use(
      '*',
      baseServeStatic({
        getContent,
        precompressed: true,
      })
    )

    const res = await app.request('/static/hello.jpg', {
      headers: { 'Accept-Encoding': 'gzip, br, deflate, zstd' },
    })

    expect(res.status).toBe(200)
    expect(res.headers.get('Content-Encoding')).toBeNull()
    expect(res.headers.get('Vary')).toBeNull()
    expect(res.headers.get('Content-Type')).toMatch(/^image\/jpeg/)
    expect(await res.text()).toBe('Hello in static/hello.jpg')
  })

  it('Should return response object content as-is', async () => {
    const body = new ReadableStream()
    const response = new Response(body)
    const app = new Hono().use(
      '*',
      baseServeStatic({
        getContent: async () => {
          return response
        },
      })
    )

    const res = await app.fetch({
      method: 'GET',
      url: 'http://localhost',
    } as Request)
    expect(res.status).toBe(200)
    expect(res.body).toBe(body)
  })

  describe('Changing root path', () => {
    const pathResolve = (path: string) => {
      return path.startsWith('/') ? path : `./${path}`
    }

    it('Should return the content with absolute root path', async () => {
      const app = new Hono()
      const serveStatic = baseServeStatic({
        getContent,
        pathResolve,
        root: '/home/hono/child',
      })
      app.get('/static/*', serveStatic)

      const res = await app.request('/static/html/hello.html')
      expect(await res.text()).toBe('Hello in /home/hono/child/static/html/hello.html')
    })

    it('Should traverse the directories with absolute root path', async () => {
      const app = new Hono()
      const serveStatic = baseServeStatic({
        getContent,
        pathResolve,
        root: '/home/hono/../parent',
      })
      app.get('/static/*', serveStatic)

      const res = await app.request('/static/html/hello.html')
      expect(await res.text()).toBe('Hello in /home/parent/static/html/hello.html')
    })

    it('Should treat the root path includes .. as relative path', async () => {
      const app = new Hono()
      const serveStatic = baseServeStatic({
        getContent,
        pathResolve,
        root: '../home/hono',
      })
      app.get('/static/*', serveStatic)

      const res = await app.request('/static/html/hello.html')
      expect(await res.text()).toBe('Hello in ./../home/hono/static/html/hello.html')
    })

    it('Should not allow directory traversal with . as relative path', async () => {
      const app = new Hono()
      const serveStatic = baseServeStatic({
        getContent,
        pathResolve,
        root: '.',
      })
      app.get('*', serveStatic)

      const res = await app.request('///etc/passwd')
      expect(res.status).toBe(404)
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/serve-static/index.ts
```typescript
/**
 * @module
 * Serve Static Middleware for Hono.
 */

import type { Context, Data } from '../../context'
import type { Env, MiddlewareHandler } from '../../types'
import { COMPRESSIBLE_CONTENT_TYPE_REGEX } from '../../utils/compress'
import { getFilePath, getFilePathWithoutDefaultDocument } from '../../utils/filepath'
import { getMimeType } from '../../utils/mime'

export type ServeStaticOptions<E extends Env = Env> = {
  root?: string
  path?: string
  precompressed?: boolean
  mimes?: Record<string, string>
  rewriteRequestPath?: (path: string) => string
  onFound?: (path: string, c: Context<E>) => void | Promise<void>
  onNotFound?: (path: string, c: Context<E>) => void | Promise<void>
}

const ENCODINGS = {
  br: '.br',
  zstd: '.zst',
  gzip: '.gz',
} as const
const ENCODINGS_ORDERED_KEYS = Object.keys(ENCODINGS) as (keyof typeof ENCODINGS)[]

const DEFAULT_DOCUMENT = 'index.html'
const defaultPathResolve = (path: string) => path

/**
 * This middleware is not directly used by the user. Create a wrapper specifying `getContent()` by the environment such as Deno or Bun.
 */
export const serveStatic = <E extends Env = Env>(
  options: ServeStaticOptions<E> & {
    getContent: (path: string, c: Context<E>) => Promise<Data | Response | null>
    pathResolve?: (path: string) => string
    isDir?: (path: string) => boolean | undefined | Promise<boolean | undefined>
  }
): MiddlewareHandler => {
  let isAbsoluteRoot = false
  let root: string

  if (options.root) {
    if (options.root.startsWith('/')) {
      isAbsoluteRoot = true
      root = new URL(`file://${options.root}`).pathname
    } else {
      root = options.root
    }
  }

  return async (c, next) => {
    // Do nothing if Response is already set
    if (c.finalized) {
      await next()
      return
    }

    let filename = options.path ?? decodeURI(c.req.path)
    filename = options.rewriteRequestPath ? options.rewriteRequestPath(filename) : filename

    // If it was Directory, force `/` on the end.
    if (!filename.endsWith('/') && options.isDir) {
      const path = getFilePathWithoutDefaultDocument({
        filename,
        root,
      })
      if (path && (await options.isDir(path))) {
        filename += '/'
      }
    }

    let path = getFilePath({
      filename,
      root,
      defaultDocument: DEFAULT_DOCUMENT,
    })

    if (!path) {
      return await next()
    }

    if (isAbsoluteRoot) {
      path = '/' + path
    }

    const getContent = options.getContent
    const pathResolve = options.pathResolve ?? defaultPathResolve
    path = pathResolve(path)
    let content = await getContent(path, c)

    if (!content) {
      let pathWithoutDefaultDocument = getFilePathWithoutDefaultDocument({
        filename,
        root,
      })
      if (!pathWithoutDefaultDocument) {
        return await next()
      }
      pathWithoutDefaultDocument = pathResolve(pathWithoutDefaultDocument)

      if (pathWithoutDefaultDocument !== path) {
        content = await getContent(pathWithoutDefaultDocument, c)
        if (content) {
          path = pathWithoutDefaultDocument
        }
      }
    }

    if (content instanceof Response) {
      return c.newResponse(content.body, content)
    }

    if (content) {
      const mimeType = (options.mimes && getMimeType(path, options.mimes)) || getMimeType(path)
      c.header('Content-Type', mimeType || 'application/octet-stream')

      if (options.precompressed && (!mimeType || COMPRESSIBLE_CONTENT_TYPE_REGEX.test(mimeType))) {
        const acceptEncodingSet = new Set(
          c.req
            .header('Accept-Encoding')
            ?.split(',')
            .map((encoding) => encoding.trim())
        )

        for (const encoding of ENCODINGS_ORDERED_KEYS) {
          if (!acceptEncodingSet.has(encoding)) {
            continue
          }
          const compressedContent = (await getContent(path + ENCODINGS[encoding], c)) as Data | null

          if (compressedContent) {
            content = compressedContent
            c.header('Content-Encoding', encoding)
            c.header('Vary', 'Accept-Encoding', { append: true })
            break
          }
        }
      }
      await options.onFound?.(path, c)
      return c.body(content)
    }

    await options.onNotFound?.(path, c)
    await next()
    return
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/context-storage/index.test.ts
```typescript
import { Hono } from '../../hono'
import { contextStorage, getContext } from '.'

describe('Context Storage Middleware', () => {
  type Env = {
    Variables: {
      message: string
    }
  }

  const app = new Hono<Env>()

  app.use(contextStorage())
  app.use(async (c, next) => {
    c.set('message', 'Hono is hot!!')
    await next()
  })
  app.get('/', (c) => {
    return c.text(getMessage())
  })

  const getMessage = () => {
    return getContext<Env>().var.message
  }

  it('Should get context', async () => {
    const res = await app.request('/')
    expect(await res.text()).toBe('Hono is hot!!')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/context-storage/index.ts
````typescript
/**
 * @module
 * Context Storage Middleware for Hono.
 */

import { AsyncLocalStorage } from 'node:async_hooks'
import type { Context } from '../../context'
import type { Env, MiddlewareHandler } from '../../types'

const asyncLocalStorage = new AsyncLocalStorage<Context>()

/**
 * Context Storage Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/context-storage}
 *
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * type Env = {
 *   Variables: {
 *     message: string
 *   }
 * }
 *
 * const app = new Hono<Env>()
 *
 * app.use(contextStorage())
 *
 * app.use(async (c, next) => {
 *   c.set('message', 'Hono is hot!!)
 *   await next()
 * })
 *
 * app.get('/', async (c) => { c.text(getMessage()) })
 *
 * const getMessage = () => {
 *   return getContext<Env>().var.message
 * }
 * ```
 */
export const contextStorage = (): MiddlewareHandler => {
  return async function contextStorage(c, next) {
    await asyncLocalStorage.run(c, next)
  }
}

export const getContext = <E extends Env = Env>(): Context<E> => {
  const context = asyncLocalStorage.getStore()
  if (!context) {
    throw new Error('Context is not available')
  }
  return context
}

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/ip-restriction/index.test.ts
```typescript
import { Context } from '../../context'
import type { AddressType, GetConnInfo } from '../../helper/conninfo'
import { Hono } from '../../hono'
import { ipRestriction } from '.'
import type { IPRestrictionRule } from '.'

describe('ipRestriction middleware', () => {
  it('Should restrict', async () => {
    const getConnInfo: GetConnInfo = (c) => {
      return {
        remote: {
          address: c.env.ip,
        },
      }
    }
    const app = new Hono<{
      Bindings: {
        ip: string
      }
    }>()
    app.use(
      '/basic',
      ipRestriction(getConnInfo, {
        allowList: ['192.168.1.0', '192.168.2.0/24'],
        denyList: ['192.168.2.10'],
      })
    )
    app.get('/basic', (c) => c.text('Hello World!'))

    app.use(
      '/allow-empty',
      ipRestriction(getConnInfo, {
        denyList: ['192.168.1.0'],
      })
    )
    app.get('/allow-empty', (c) => c.text('Hello World!'))

    expect((await app.request('/basic', {}, { ip: '0.0.0.0' })).status).toBe(403)

    expect((await app.request('/basic', {}, { ip: '192.168.1.0' })).status).toBe(200)

    expect((await app.request('/basic', {}, { ip: '192.168.2.5' })).status).toBe(200)
    expect((await app.request('/basic', {}, { ip: '192.168.2.10' })).status).toBe(403)

    expect((await app.request('/allow-empty', {}, { ip: '0.0.0.0' })).status).toBe(200)

    expect((await app.request('/allow-empty', {}, { ip: '192.168.1.0' })).status).toBe(403)

    expect((await app.request('/allow-empty', {}, { ip: '192.168.2.5' })).status).toBe(200)
    expect((await app.request('/allow-empty', {}, { ip: '192.168.2.10' })).status).toBe(200)
  })
  it('Custom onerror', async () => {
    const res = await ipRestriction(
      () => '0.0.0.0',
      { denyList: ['0.0.0.0'] },
      () => new Response('error')
    )(new Context(new Request('http://localhost/')), async () => void 0)
    expect(res).toBeTruthy()
    if (res) {
      expect(await res.text()).toBe('error')
    }
  })
})

describe('isMatchForRule', () => {
  const isMatch = async (info: { addr: string; type: AddressType }, rule: IPRestrictionRule) => {
    const middleware = ipRestriction(
      () => ({
        remote: {
          address: info.addr,
          addressType: info.type,
        },
      }),
      {
        allowList: [rule],
      }
    )
    try {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await middleware(undefined as any, () => Promise.resolve())
    } catch {
      return false
    }
    return true
  }

  it('star', async () => {
    expect(await isMatch({ addr: '192.168.2.0', type: 'IPv4' }, '*')).toBeTruthy()
    expect(await isMatch({ addr: '192.168.2.1', type: 'IPv4' }, '*')).toBeTruthy()
    expect(await isMatch({ addr: '::0', type: 'IPv6' }, '*')).toBeTruthy()
  })
  it('CIDR Notation', async () => {
    expect(await isMatch({ addr: '192.168.2.0', type: 'IPv4' }, '192.168.2.0/24')).toBeTruthy()
    expect(await isMatch({ addr: '192.168.2.1', type: 'IPv4' }, '192.168.2.0/24')).toBeTruthy()
    expect(await isMatch({ addr: '192.168.2.1', type: 'IPv4' }, '192.168.2.1/32')).toBeTruthy()
    expect(await isMatch({ addr: '192.168.2.1', type: 'IPv4' }, '192.168.2.2/32')).toBeFalsy()

    expect(await isMatch({ addr: '::0', type: 'IPv6' }, '::0/1')).toBeTruthy()
  })
  it('Static Rules', async () => {
    expect(await isMatch({ addr: '192.168.2.1', type: 'IPv4' }, '192.168.2.1')).toBeTruthy()
    expect(await isMatch({ addr: '1234::5678', type: 'IPv6' }, '1234::5678')).toBeTruthy()
    expect(
      await isMatch({ addr: '::ffff:127.0.0.1', type: 'IPv6' }, '::ffff:127.0.0.1')
    ).toBeTruthy()
    expect(await isMatch({ addr: '::ffff:127.0.0.1', type: 'IPv6' }, '::ffff:7f00:1')).toBeTruthy()
  })
  it('Function Rules', async () => {
    expect(await isMatch({ addr: '0.0.0.0', type: 'IPv4' }, () => true)).toBeTruthy()
    expect(await isMatch({ addr: '0.0.0.0', type: 'IPv4' }, () => false)).toBeFalsy()

    const ipaddr = '93.184.216.34'
    await isMatch({ addr: ipaddr, type: 'IPv4' }, (ip) => {
      expect(ipaddr).toBe(ip.addr)
      return false
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/ip-restriction/index.ts
```typescript
/**
 * IP Restriction Middleware for Hono
 * @module
 */

import type { Context, MiddlewareHandler } from '../..'
import type { AddressType, GetConnInfo } from '../../helper/conninfo'
import { HTTPException } from '../../http-exception'
import {
  convertIPv4ToBinary,
  convertIPv6BinaryToString,
  convertIPv6ToBinary,
  distinctRemoteAddr,
} from '../../utils/ipaddr'

/**
 * Function to get IP Address
 */
type GetIPAddr = GetConnInfo | ((c: Context) => string)

/**
 * ### IPv4 and IPv6
 * - `*` match all
 *
 * ### IPv4
 * - `192.168.2.0` static
 * - `192.168.2.0/24` CIDR Notation
 *
 * ### IPv6
 * - `::1` static
 * - `::1/10` CIDR Notation
 */
type IPRestrictionRuleFunction = (addr: { addr: string; type: AddressType }) => boolean
export type IPRestrictionRule = string | ((addr: { addr: string; type: AddressType }) => boolean)

const IS_CIDR_NOTATION_REGEX = /\/[0-9]{0,3}$/
const buildMatcher = (
  rules: IPRestrictionRule[]
): ((addr: { addr: string; type: AddressType; isIPv4: boolean }) => boolean) => {
  const functionRules: IPRestrictionRuleFunction[] = []
  const staticRules: Set<string> = new Set()
  const cidrRules: [boolean, bigint, bigint][] = []

  for (let rule of rules) {
    if (rule === '*') {
      return () => true
    } else if (typeof rule === 'function') {
      functionRules.push(rule)
    } else {
      if (IS_CIDR_NOTATION_REGEX.test(rule)) {
        const separatedRule = rule.split('/')

        const addrStr = separatedRule[0]
        const type = distinctRemoteAddr(addrStr)
        if (type === undefined) {
          throw new TypeError(`Invalid rule: ${rule}`)
        }

        const isIPv4 = type === 'IPv4'
        const prefix = parseInt(separatedRule[1])

        if (isIPv4 ? prefix === 32 : prefix === 128) {
          // this rule is a static rule
          rule = addrStr
        } else {
          const addr = (isIPv4 ? convertIPv4ToBinary : convertIPv6ToBinary)(addrStr)
          const mask = ((1n << BigInt(prefix)) - 1n) << BigInt((isIPv4 ? 32 : 128) - prefix)

          cidrRules.push([isIPv4, addr & mask, mask] as [boolean, bigint, bigint])
          continue
        }
      }

      const type = distinctRemoteAddr(rule)
      if (type === undefined) {
        throw new TypeError(`Invalid rule: ${rule}`)
      }
      staticRules.add(
        type === 'IPv4'
          ? rule // IPv4 address is already normalized, so it is registered as is.
          : convertIPv6BinaryToString(convertIPv6ToBinary(rule)) // normalize IPv6 address (e.g. 0000:0000:0000:0000:0000:0000:0000:0001 => ::1)
      )
    }
  }

  return (remote: {
    addr: string
    type: AddressType
    isIPv4: boolean
    binaryAddr?: bigint
  }): boolean => {
    if (staticRules.has(remote.addr)) {
      return true
    }
    for (const [isIPv4, addr, mask] of cidrRules) {
      if (isIPv4 !== remote.isIPv4) {
        continue
      }
      const remoteAddr = (remote.binaryAddr ||= (
        isIPv4 ? convertIPv4ToBinary : convertIPv6ToBinary
      )(remote.addr))
      if ((remoteAddr & mask) === addr) {
        return true
      }
    }
    for (const rule of functionRules) {
      if (rule({ addr: remote.addr, type: remote.type })) {
        return true
      }
    }
    return false
  }
}

/**
 * Rules for IP Restriction Middleware
 */
export interface IPRestrictionRules {
  denyList?: IPRestrictionRule[]
  allowList?: IPRestrictionRule[]
}

/**
 * IP Restriction Middleware
 *
 * @param getIP function to get IP Address
 */
export const ipRestriction = (
  getIP: GetIPAddr,
  { denyList = [], allowList = [] }: IPRestrictionRules,
  onError?: (
    remote: { addr: string; type: AddressType },
    c: Context
  ) => Response | Promise<Response>
): MiddlewareHandler => {
  const allowLength = allowList.length

  const denyMatcher = buildMatcher(denyList)
  const allowMatcher = buildMatcher(allowList)

  const blockError = (c: Context): HTTPException =>
    new HTTPException(403, {
      res: c.text('Forbidden', {
        status: 403,
      }),
    })

  return async function ipRestriction(c, next) {
    const connInfo = getIP(c)
    const addr = typeof connInfo === 'string' ? connInfo : connInfo.remote.address
    if (!addr) {
      throw blockError(c)
    }
    const type =
      (typeof connInfo !== 'string' && connInfo.remote.addressType) || distinctRemoteAddr(addr)

    const remoteData = { addr, type, isIPv4: type === 'IPv4' }

    if (denyMatcher(remoteData)) {
      if (onError) {
        return onError({ addr, type }, c)
      }
      throw blockError(c)
    }
    if (allowMatcher(remoteData)) {
      return await next()
    }

    if (allowLength === 0) {
      return await next()
    } else {
      if (onError) {
        return await onError({ addr, type }, c)
      }
      throw blockError(c)
    }
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/etag/digest.ts
```typescript
const mergeBuffers = (buffer1: ArrayBuffer | undefined, buffer2: Uint8Array): Uint8Array => {
  if (!buffer1) {
    return buffer2
  }
  const merged = new Uint8Array(buffer1.byteLength + buffer2.byteLength)
  merged.set(new Uint8Array(buffer1), 0)
  merged.set(buffer2, buffer1.byteLength)
  return merged
}

export const generateDigest = async (
  stream: ReadableStream<Uint8Array> | null,
  generator: (body: Uint8Array) => ArrayBuffer | Promise<ArrayBuffer>
): Promise<string | null> => {
  if (!stream) {
    return null
  }

  let result: ArrayBuffer | undefined = undefined

  const reader = stream.getReader()
  for (;;) {
    const { value, done } = await reader.read()
    if (done) {
      break
    }

    result = await generator(mergeBuffers(result, value))
  }

  if (!result) {
    return null
  }

  return Array.prototype.map
    .call(new Uint8Array(result), (x) => x.toString(16).padStart(2, '0'))
    .join('')
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/etag/index.test.ts
```typescript
import { Hono } from '../../hono'
import { RETAINED_304_HEADERS, etag } from '.'

describe('Etag Middleware', () => {
  it('Should return etag header', async () => {
    const app = new Hono()
    app.use('/etag/*', etag())
    app.get('/etag/abc', (c) => {
      return c.text('Hono is hot')
    })
    app.get('/etag/def', (c) => {
      return c.json({ message: 'Hono is hot' })
    })
    let res = await app.request('http://localhost/etag/abc')
    expect(res.headers.get('ETag')).not.toBeFalsy()
    expect(res.headers.get('ETag')).toBe('"d104fafdb380655dab607c9bddc4d4982037afa1"')

    res = await app.request('http://localhost/etag/def')
    expect(res.headers.get('ETag')).not.toBeFalsy()
    expect(res.headers.get('ETag')).toBe('"67340414f1a52c4669a6cec71f0ae04532b29249"')
  })

  it('Should return etag header with another algorithm', async () => {
    const app = new Hono()
    app.use(
      '/etag/*',
      etag({
        generateDigest: (body) =>
          crypto.subtle.digest(
            {
              name: 'SHA-256',
            },
            body
          ),
      })
    )
    app.get('/etag/abc', (c) => {
      return c.text('Hono is hot')
    })
    app.get('/etag/def', (c) => {
      return c.json({ message: 'Hono is hot' })
    })
    let res = await app.request('http://localhost/etag/abc')
    expect(res.headers.get('ETag')).not.toBeFalsy()
    expect(res.headers.get('ETag')).toBe(
      '"ed00834279b4fd5dcdc7ab6a5c9774de8afb2de30da2c8e0f17d0952839b5370"'
    )

    res = await app.request('http://localhost/etag/def')
    expect(res.headers.get('ETag')).not.toBeFalsy()
    expect(res.headers.get('ETag')).toBe(
      '"83b61a767db6e22afea68dd645b4d4597a06276c8ce7f895ad865cf4ab154ec4"'
    )
  })

  it('Should return etag header - binary', async () => {
    const app = new Hono()
    app.use('/etag/*', etag())
    app.get('/etag', async (c) => {
      return c.body(new Uint8Array(1))
    })

    const res = await app.request('http://localhost/etag')
    expect(res.headers.get('ETag')).not.toBeFalsy()
    const etagHeader = res.headers.get('ETag')
    expect(etagHeader).toBe('"5ba93c9db0cff93f52b521d7420e43f6eda2784f"')
  })

  it('Should not be the same etag - arrayBuffer', async () => {
    const app = new Hono()
    app.use('/etag/*', etag())
    app.get('/etag/ab1', (c) => {
      return c.body(new ArrayBuffer(1))
    })
    app.get('/etag/ab2', (c) => {
      return c.body(new ArrayBuffer(2))
    })

    let res = await app.request('http://localhost/etag/ab1')
    const hash = res.headers.get('Etag')
    res = await app.request('http://localhost/etag/ab2')
    expect(res.headers.get('ETag')).not.toBe(hash)
  })

  it('Should not be the same etag - Uint8Array', async () => {
    const app = new Hono()
    app.use('/etag/*', etag())
    app.get('/etag/ui1', (c) => {
      return c.body(new Uint8Array([1, 2, 3]))
    })
    app.get('/etag/ui2', (c) => {
      return c.body(new Uint8Array([1, 2, 3, 4]))
    })

    let res = await app.request('http://localhost/etag/ui1')
    const hash = res.headers.get('Etag')
    res = await app.request('http://localhost/etag/ui2')
    expect(res.headers.get('ETag')).not.toBe(hash)
  })

  it('Should not be the same etag - ReadableStream', async () => {
    const app = new Hono()
    app.use('/etag/*', etag())
    app.get('/etag/rs1', (c) => {
      return c.body(
        new ReadableStream({
          start(controller) {
            controller.enqueue(new Uint8Array([1]))
            controller.enqueue(new Uint8Array([2]))
            controller.close()
          },
        })
      )
    })
    app.get('/etag/rs2', (c) => {
      return c.body(
        new ReadableStream({
          start(controller) {
            controller.enqueue(new Uint8Array([1]))
            controller.enqueue(new Uint8Array([3]))
            controller.close()
          },
        })
      )
    })

    let res = await app.request('http://localhost/etag/rs1')
    const hash = res.headers.get('Etag')
    res = await app.request('http://localhost/etag/rs2')
    expect(res.headers.get('ETag')).not.toBe(hash)
  })

  it('Should not return etag header when the stream is empty', async () => {
    const app = new Hono()
    app.use('/etag/*', etag())
    app.get('/etag/abc', (c) => {
      const stream = new ReadableStream({
        start(controller) {
          controller.close()
        },
      })
      return c.body(stream)
    })
    const res = await app.request('http://localhost/etag/abc')
    expect(res.status).toBe(200)
    expect(res.headers.get('ETag')).toBeNull()
  })

  it('Should not return etag header when body is null', async () => {
    const app = new Hono()
    app.use('/etag/*', etag())
    app.get('/etag/abc', () => new Response(null, { status: 500 }))
    const res = await app.request('http://localhost/etag/abc')
    expect(res.status).toBe(500)
    expect(res.headers.get('ETag')).toBeNull()
  })

  it('Should return etag header - weak', async () => {
    const app = new Hono()
    app.use('/etag/*', etag({ weak: true }))
    app.get('/etag/abc', (c) => {
      return c.text('Hono is hot')
    })

    const res = await app.request('http://localhost/etag/abc')
    expect(res.headers.get('ETag')).not.toBeFalsy()
    expect(res.headers.get('ETag')).toBe('W/"d104fafdb380655dab607c9bddc4d4982037afa1"')
  })

  it('Should handle conditional GETs', async () => {
    const app = new Hono()
    app.use('/etag/*', etag())
    app.get('/etag/ghi', (c) =>
      c.text('Hono is great', 200, {
        'cache-control': 'public, max-age=120',
        date: 'Mon, Feb 27 2023 12:08:36 GMT',
        expires: 'Mon, Feb 27 2023 12:10:36 GMT',
        server: 'Upstream 1.2',
        vary: 'Accept-Language',
      })
    )

    // unconditional GET
    let res = await app.request('http://localhost/etag/ghi')
    expect(res.status).toBe(200)
    expect(res.headers.get('ETag')).not.toBeFalsy()
    const etagHeaderValue = res.headers.get('ETag') || ''

    // conditional GET with the wrong ETag:
    res = await app.request('http://localhost/etag/ghi', {
      headers: {
        'If-None-Match': '"not the right etag"',
      },
    })
    expect(res.status).toBe(200)

    // conditional GET with matching ETag:
    res = await app.request('http://localhost/etag/ghi', {
      headers: {
        'If-None-Match': etagHeaderValue,
      },
    })
    expect(res.status).toBe(304)
    expect(res.headers.get('Etag')).toBe(etagHeaderValue)
    expect(await res.text()).toBe('')
    expect(res.headers.get('cache-control')).toBe('public, max-age=120')
    expect(res.headers.get('date')).toBe('Mon, Feb 27 2023 12:08:36 GMT')
    expect(res.headers.get('expires')).toBe('Mon, Feb 27 2023 12:10:36 GMT')
    expect(res.headers.get('server')).toBeFalsy()
    expect(res.headers.get('vary')).toBe('Accept-Language')

    // conditional GET with matching ETag among list:
    res = await app.request('http://localhost/etag/ghi', {
      headers: {
        'If-None-Match': `"mismatch 1", ${etagHeaderValue}, "mismatch 2"`,
      },
    })
    expect(res.status).toBe(304)
  })

  it('Should not return duplicate etag header values', async () => {
    const app = new Hono()
    app.use('/etag/*', etag())
    app.use('/etag/*', etag())
    app.get('/etag/abc', (c) => c.text('Hono is hot'))

    const res = await app.request('http://localhost/etag/abc')
    expect(res.headers.get('ETag')).not.toBeFalsy()
    expect(res.headers.get('ETag')).toBe('"d104fafdb380655dab607c9bddc4d4982037afa1"')
  })

  it('Should not override ETag headers from upstream', async () => {
    const app = new Hono()
    app.use('/etag/*', etag())
    app.get('/etag/predefined', (c) =>
      c.text('This response has an ETag', 200, { ETag: '"f-0194-d"' })
    )

    const res = await app.request('http://localhost/etag/predefined')
    expect(res.headers.get('ETag')).toBe('"f-0194-d"')
  })

  it('Should retain the default and the specified headers', async () => {
    const cacheControl = 'public, max-age=120'
    const message = 'Hello!'
    const app = new Hono()
    app.use(
      '/etag/*',
      etag({
        retainedHeaders: ['x-message-retain', ...RETAINED_304_HEADERS],
      })
    )
    app.get('/etag', (c) => {
      return c.text('Hono is hot', 200, {
        'cache-control': cacheControl,
        'x-message-retain': message,
        'x-message': message,
      })
    })
    const res = await app.request('/etag', {
      headers: {
        'If-None-Match': '"d104fafdb380655dab607c9bddc4d4982037afa1"',
      },
    })
    expect(res.status).toBe(304)
    expect(res.headers.get('ETag')).not.toBeFalsy()
    expect(res.headers.get('ETag')).toBe('"d104fafdb380655dab607c9bddc4d4982037afa1"')
    expect(res.headers.get('Cache-Control')).toBe(cacheControl)
    expect(res.headers.get('x-message-retain')).toBe(message)
    expect(res.headers.get('x-message')).toBeFalsy()
  })

  describe('When crypto is not available', () => {
    let _crypto: Crypto | undefined
    beforeAll(() => {
      _crypto = globalThis.crypto
      Object.defineProperty(globalThis, 'crypto', {
        value: {},
      })
    })

    afterAll(() => {
      Object.defineProperty(globalThis, 'crypto', {
        value: _crypto,
      })
    })

    it('Should not generate etag', async () => {
      const app = new Hono()
      app.use('/etag/*', etag())
      app.get('/etag/no-digest', (c) => c.text('Hono is hot'))
      const res = await app.request('/etag/no-digest')
      expect(res.status).toBe(200)
      expect(res.headers.get('ETag')).toBeNull()
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/etag/index.ts
````typescript
/**
 * @module
 * ETag Middleware for Hono.
 */

import type { MiddlewareHandler } from '../../types'
import { generateDigest } from './digest'

type ETagOptions = {
  retainedHeaders?: string[]
  weak?: boolean
  generateDigest?: (body: Uint8Array) => ArrayBuffer | Promise<ArrayBuffer>
}

/**
 * Default headers to pass through on 304 responses. From the spec:
 * > The response must not contain a body and must include the headers that
 * > would have been sent in an equivalent 200 OK response: Cache-Control,
 * > Content-Location, Date, ETag, Expires, and Vary.
 */
export const RETAINED_304_HEADERS = [
  'cache-control',
  'content-location',
  'date',
  'etag',
  'expires',
  'vary',
]

function etagMatches(etag: string, ifNoneMatch: string | null) {
  return ifNoneMatch != null && ifNoneMatch.split(/,\s*/).indexOf(etag) > -1
}

function initializeGenerator(
  generator?: ETagOptions['generateDigest']
): ETagOptions['generateDigest'] | undefined {
  if (!generator) {
    if (crypto && crypto.subtle) {
      generator = (body: Uint8Array) =>
        crypto.subtle.digest(
          {
            name: 'SHA-1',
          },
          body
        )
    }
  }

  return generator
}

/**
 * ETag Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/etag}
 *
 * @param {ETagOptions} [options] - The options for the ETag middleware.
 * @param {boolean} [options.weak=false] - Define using or not using a weak validation. If true is set, then `W/` is added to the prefix of the value.
 * @param {string[]} [options.retainedHeaders=RETAINED_304_HEADERS] - The headers that you want to retain in the 304 Response.
 * @param {function(Uint8Array): ArrayBuffer | Promise<ArrayBuffer>} [options.generateDigest] -
 * A custom digest generation function. By default, it uses 'SHA-1'
 * This function is called with the response body as a `Uint8Array` and should return a hash as an `ArrayBuffer` or a Promise of one.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use('/etag/*', etag())
 * app.get('/etag/abc', (c) => {
 *   return c.text('Hono is hot')
 * })
 * ```
 */
export const etag = (options?: ETagOptions): MiddlewareHandler => {
  const retainedHeaders = options?.retainedHeaders ?? RETAINED_304_HEADERS
  const weak = options?.weak ?? false
  const generator = initializeGenerator(options?.generateDigest)

  return async function etag(c, next) {
    const ifNoneMatch = c.req.header('If-None-Match') ?? null

    await next()

    const res = c.res as Response
    let etag = res.headers.get('ETag')

    if (!etag) {
      if (!generator) {
        return
      }
      const hash = await generateDigest(res.clone().body, generator)
      if (hash === null) {
        return
      }
      etag = weak ? `W/"${hash}"` : `"${hash}"`
    }

    if (etagMatches(etag, ifNoneMatch)) {
      c.res = new Response(null, {
        status: 304,
        statusText: 'Not Modified',
        headers: {
          ETag: etag,
        },
      })
      c.res.headers.forEach((_, key) => {
        if (retainedHeaders.indexOf(key.toLowerCase()) === -1) {
          c.res.headers.delete(key)
        }
      })
    } else {
      c.res.headers.set('ETag', etag)
    }
  }
}

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/trailing-slash/index.test.ts
```typescript
import { Hono } from '../../hono'
import { appendTrailingSlash, trimTrailingSlash } from '.'

describe('Resolve trailing slash', () => {
  let app: Hono

  it('Trim', async () => {
    app = new Hono({ strict: true })

    app.use('*', trimTrailingSlash())

    app.get('/', async (c) => {
      return c.text('ok')
    })
    app.get('/the/example/endpoint/without/trailing/slash', async (c) => {
      return c.text('ok')
    })

    let resp: Response, loc: URL

    resp = await app.request('/')
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(200)

    resp = await app.request('/the/example/endpoint/without/trailing/slash')
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(200)

    resp = await app.request('/the/example/endpoint/without/trailing/slash/')
    loc = new URL(resp.headers.get('location')!)
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(301)
    expect(loc.pathname).toBe('/the/example/endpoint/without/trailing/slash')

    resp = await app.request('/the/example/endpoint/without/trailing/slash/?exampleParam=1')
    loc = new URL(resp.headers.get('location')!)
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(301)
    expect(loc.pathname).toBe('/the/example/endpoint/without/trailing/slash')
    expect(loc.searchParams.get('exampleParam')).toBe('1')
  })

  it('Append', async () => {
    app = new Hono({ strict: true })

    app.use('*', appendTrailingSlash())

    app.get('/', async (c) => {
      return c.text('ok')
    })
    app.get('/the/example/endpoint/with/trailing/slash/', async (c) => {
      return c.text('ok')
    })
    app.get('/the/example/simulate/a.file', async (c) => {
      return c.text('ok')
    })

    let resp: Response, loc: URL

    resp = await app.request('/')
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(200)

    resp = await app.request('/the/example/simulate/a.file')
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(200)

    resp = await app.request('/the/example/endpoint/with/trailing/slash/')
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(200)

    resp = await app.request('/the/example/endpoint/with/trailing/slash')
    loc = new URL(resp.headers.get('location')!)
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(301)
    expect(loc.pathname).toBe('/the/example/endpoint/with/trailing/slash/')

    resp = await app.request('/the/example/endpoint/with/trailing/slash?exampleParam=1')
    loc = new URL(resp.headers.get('location')!)
    expect(resp).not.toBeNull()
    expect(resp.status).toBe(301)
    expect(loc.pathname).toBe('/the/example/endpoint/with/trailing/slash/')
    expect(loc.searchParams.get('exampleParam')).toBe('1')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/trailing-slash/index.ts
````typescript
/**
 * @module
 * Trailing Slash Middleware for Hono.
 */

import type { MiddlewareHandler } from '../../types'

/**
 * Trailing Slash Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/trailing-slash}
 *
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use(trimTrailingSlash())
 * app.get('/about/me/', (c) => c.text('With Trailing Slash'))
 * ```
 */
export const trimTrailingSlash = (): MiddlewareHandler => {
  return async function trimTrailingSlash(c, next) {
    await next()

    if (
      c.res.status === 404 &&
      c.req.method === 'GET' &&
      c.req.path !== '/' &&
      c.req.path.at(-1) === '/'
    ) {
      const url = new URL(c.req.url)
      url.pathname = url.pathname.substring(0, url.pathname.length - 1)

      c.res = c.redirect(url.toString(), 301)
    }
  }
}

/**
 * Append trailing slash middleware for Hono.
 * Append a trailing slash to the URL if it doesn't have one. For example, `/path/to/page` will be redirected to `/path/to/page/`.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/trailing-slash}
 *
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 *
 * app.use(appendTrailingSlash())
 * ```
 */
export const appendTrailingSlash = (): MiddlewareHandler => {
  return async function appendTrailingSlash(c, next) {
    await next()

    if (c.res.status === 404 && c.req.method === 'GET' && c.req.path.at(-1) !== '/') {
      const url = new URL(c.req.url)
      url.pathname += '/'

      c.res = c.redirect(url.toString(), 301)
    }
  }
}

````
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/request-id/index.test.ts
```typescript
import type { Context } from '../../context'
import { Hono } from '../../hono'
import { requestId } from '.'

const regexUUIDv4 = /([0-9a-f]{8})-([0-9a-f]{4})-([0-9a-f]{4})-([0-9a-f]{4})-([0-9a-f]{12})/

describe('Request ID Middleware', () => {
  const app = new Hono()
  app.use('*', requestId())
  app.get('/requestId', (c) => c.text(c.get('requestId') ?? 'No Request ID'))

  it('Should return random request id', async () => {
    const res = await app.request('http://localhost/requestId')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Request-Id')).toMatch(regexUUIDv4)
    expect(await res.text()).match(regexUUIDv4)
  })

  it('Should return custom request id', async () => {
    const res = await app.request('http://localhost/requestId', {
      headers: {
        'X-Request-Id': 'hono-is-hot',
      },
    })
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Request-Id')).toBe('hono-is-hot')
    expect(await res.text()).toBe('hono-is-hot')
  })

  it('Should return random request id without using request header', async () => {
    const res = await app.request('http://localhost/requestId', {
      headers: {
        'X-Request-Id': 'Hello!12345-@*^',
      },
    })
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Request-Id')).toMatch(regexUUIDv4)
    expect(await res.text()).toMatch(regexUUIDv4)
  })
})

describe('Request ID Middleware with custom generator', () => {
  function generateWord() {
    return 'HonoIsWebFramework'
  }
  function generateDoubleRequestId(c: Context) {
    const honoId = c.req.header('Hono-Request-Id')
    const ohnoId = c.req.header('Ohno-Request-Id')
    if (honoId && ohnoId) {
      return honoId + ohnoId
    }
    return crypto.randomUUID()
  }
  const app = new Hono()
  app.use('/word', requestId({ generator: generateWord }))
  app.use('/doubleRequestId', requestId({ generator: generateDoubleRequestId }))
  app.get('/word', (c) => c.text(c.get('requestId') ?? 'No Request ID'))
  app.get('/doubleRequestId', (c) => c.text(c.get('requestId') ?? 'No Request ID'))
  it('Should return custom request id', async () => {
    const res = await app.request('http://localhost/word')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Request-Id')).toBe('HonoIsWebFramework')
    expect(await res.text()).toBe('HonoIsWebFramework')
  })

  it('Should return complex request id', async () => {
    const res = await app.request('http://localhost/doubleRequestId', {
      headers: {
        'Hono-Request-Id': 'Hello',
        'Ohno-Request-Id': 'World',
      },
    })
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Request-Id')).toBe('HelloWorld')
    expect(await res.text()).toBe('HelloWorld')
  })
})

describe('Request ID Middleware with limit length', () => {
  const charactersOf255 = 'h'.repeat(255)
  const charactersOf256 = 'h'.repeat(256)

  const app = new Hono()
  app.use('/requestId', requestId())
  app.use('/limit256', requestId({ limitLength: 256 }))
  app.get('/requestId', (c) => c.text(c.get('requestId') ?? 'No Request ID'))
  app.get('/limit256', (c) => c.text(c.get('requestId') ?? 'No Request ID'))

  it('Should return custom request id', async () => {
    const res = await app.request('http://localhost/requestId', {
      headers: {
        'X-Request-Id': charactersOf255,
      },
    })
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Request-Id')).toBe(charactersOf255)
    expect(await res.text()).toBe(charactersOf255)
  })
  it('Should return random request id without using request header', async () => {
    const res = await app.request('http://localhost/requestId', {
      headers: {
        'X-Request-Id': charactersOf256,
      },
    })
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Request-Id')).toMatch(regexUUIDv4)
    expect(await res.text()).toMatch(regexUUIDv4)
  })
  it('Should return custom request id with 256 characters', async () => {
    const res = await app.request('http://localhost/limit256', {
      headers: {
        'X-Request-Id': charactersOf256,
      },
    })
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Request-Id')).toBe(charactersOf256)
    expect(await res.text()).toBe(charactersOf256)
  })
})

describe('Request ID Middleware with custom header', () => {
  const app = new Hono()
  app.use('/requestId', requestId({ headerName: 'Hono-Request-Id' }))
  app.get('/emptyId', requestId({ headerName: '' }))
  app.get('/requestId', (c) => c.text(c.get('requestId') ?? 'No Request ID'))
  app.get('/emptyId', (c) => c.text(c.get('requestId') ?? 'No Request ID'))

  it('Should return custom request id', async () => {
    const res = await app.request('http://localhost/requestId', {
      headers: {
        'Hono-Request-Id': 'hono-is-hot',
      },
    })
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('Hono-Request-Id')).toBe('hono-is-hot')
    expect(await res.text()).toBe('hono-is-hot')
  })

  it('Should not return request id', async () => {
    const res = await app.request('http://localhost/emptyId')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Request-Id')).toBeNull()
    expect(await res.text()).toMatch(regexUUIDv4)
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/request-id/index.ts
```typescript
import type { RequestIdVariables } from './request-id'
export type { RequestIdVariables }
export { requestId } from './request-id'

declare module '../..' {
  interface ContextVariableMap extends RequestIdVariables {}
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/request-id/request-id.ts
````typescript
/**
 * @module
 * Request ID Middleware for Hono.
 */

import type { Context } from '../../context'
import type { MiddlewareHandler } from '../../types'

export type RequestIdVariables = {
  requestId: string
}

export type RequestIdOptions = {
  limitLength?: number
  headerName?: string
  generator?: (c: Context) => string
}

/**
 * Request ID Middleware for Hono.
 *
 * @param {object} options - Options for Request ID middleware.
 * @param {number} [options.limitLength=255] - The maximum length of request id.
 * @param {string} [options.headerName=X-Request-Id] - The header name used in request id.
 * @param {generator} [options.generator=() => crypto.randomUUID()] - The request id generation function.
 *
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * type Variables = RequestIdVariables
 * const app = new Hono<{Variables: Variables}>()
 *
 * app.use(requestId())
 * app.get('/', (c) => {
 *   console.log(c.get('requestId')) // Debug
 *   return c.text('Hello World!')
 * })
 * ```
 */
export const requestId = ({
  limitLength = 255,
  headerName = 'X-Request-Id',
  generator = () => crypto.randomUUID(),
}: RequestIdOptions = {}): MiddlewareHandler => {
  return async function requestId(c, next) {
    // If `headerName` is empty string, req.header will return the object
    let reqId = headerName ? c.req.header(headerName) : undefined
    if (!reqId || reqId.length > limitLength || /[^\w\-]/.test(reqId)) {
      reqId = generator(c)
    }

    c.set('requestId', reqId)
    if (headerName) {
      c.header(headerName, reqId)
    }
    await next()
  }
}

````
