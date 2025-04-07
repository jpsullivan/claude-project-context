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
