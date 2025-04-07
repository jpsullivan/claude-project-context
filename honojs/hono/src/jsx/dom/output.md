/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/client.test.tsx
```
/** @jsxImportSource ../ */
import { JSDOM } from 'jsdom'
import DefaultExport, { createRoot, hydrateRoot } from './client'
import { useEffect } from '.'

describe('createRoot', () => {
  beforeAll(() => {
    global.requestAnimationFrame = (cb) => setTimeout(cb)
  })

  let dom: JSDOM
  let rootElement: HTMLElement
  beforeEach(() => {
    dom = new JSDOM('<html><body><div id="root"></div></body></html>', {
      runScripts: 'dangerously',
    })
    global.document = dom.window.document
    global.HTMLElement = dom.window.HTMLElement
    global.SVGElement = dom.window.SVGElement
    global.Text = dom.window.Text
    rootElement = document.getElementById('root') as HTMLElement
  })

  it('render / unmount', async () => {
    const cleanup = vi.fn()
    const App = () => {
      useEffect(() => cleanup, [])
      return <h1>Hello</h1>
    }
    const root = createRoot(rootElement)
    root.render(<App />)
    expect(rootElement.innerHTML).toBe('<h1>Hello</h1>')
    await new Promise((resolve) => setTimeout(resolve))
    root.unmount()
    await Promise.resolve()
    expect(rootElement.innerHTML).toBe('')
    expect(cleanup).toHaveBeenCalled()
  })

  it('call render twice', async () => {
    const App = <h1>Hello</h1>
    const App2 = <h1>World</h1>
    const root = createRoot(rootElement)
    root.render(App)
    expect(rootElement.innerHTML).toBe('<h1>Hello</h1>')

    const createElementSpy = vi.spyOn(dom.window.document, 'createElement')

    root.render(App2)
    await Promise.resolve()
    expect(rootElement.innerHTML).toBe('<h1>World</h1>')

    expect(createElementSpy).not.toHaveBeenCalled()
  })

  it('call render after unmount', async () => {
    const App = <h1>Hello</h1>
    const App2 = <h1>World</h1>
    const root = createRoot(rootElement)
    root.render(App)
    expect(rootElement.innerHTML).toBe('<h1>Hello</h1>')
    root.unmount()
    expect(() => root.render(App2)).toThrow('Cannot update an unmounted root')
  })
})

describe('hydrateRoot', () => {
  let dom: JSDOM
  let rootElement: HTMLElement
  beforeEach(() => {
    dom = new JSDOM('<html><body><div id="root"></div></body></html>', {
      runScripts: 'dangerously',
    })
    global.document = dom.window.document
    global.HTMLElement = dom.window.HTMLElement
    global.SVGElement = dom.window.SVGElement
    global.Text = dom.window.Text
    rootElement = document.getElementById('root') as HTMLElement
  })

  it('should return root object', async () => {
    const cleanup = vi.fn()
    const App = () => {
      useEffect(() => cleanup, [])
      return <h1>Hello</h1>
    }
    const root = hydrateRoot(rootElement, <App />)
    expect(rootElement.innerHTML).toBe('<h1>Hello</h1>')
    await new Promise((resolve) => setTimeout(resolve))
    root.unmount()
    await Promise.resolve()
    expect(rootElement.innerHTML).toBe('')
    expect(cleanup).toHaveBeenCalled()
  })

  it('call render', async () => {
    const App = <h1>Hello</h1>
    const App2 = <h1>World</h1>
    const root = hydrateRoot(rootElement, App)
    expect(rootElement.innerHTML).toBe('<h1>Hello</h1>')

    const createElementSpy = vi.spyOn(dom.window.document, 'createElement')

    root.render(App2)
    await Promise.resolve()
    expect(rootElement.innerHTML).toBe('<h1>World</h1>')

    expect(createElementSpy).not.toHaveBeenCalled()
  })

  it('call render after unmount', async () => {
    const App = <h1>Hello</h1>
    const App2 = <h1>World</h1>
    const root = hydrateRoot(rootElement, App)
    expect(rootElement.innerHTML).toBe('<h1>Hello</h1>')
    root.unmount()
    expect(() => root.render(App2)).toThrow('Cannot update an unmounted root')
  })
})

describe('default export', () => {
  ;['createRoot', 'hydrateRoot'].forEach((key) => {
    it(key, () => {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      expect((DefaultExport as any)[key]).toBeDefined()
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/client.ts
```typescript
/**
 * @module
 * This module provides APIs for `hono/jsx/dom/client`, which is compatible with `react-dom/client`.
 */

import type { Child } from '../base'
import { useState } from '../hooks'
import { buildNode, renderNode } from './render'
import type { NodeObject } from './render'

export interface Root {
  render(children: Child): void
  unmount(): void
}
export type RootOptions = Record<string, unknown>

/**
 * Create a root object for rendering
 * @param element Render target
 * @param options Options for createRoot (not supported yet)
 * @returns Root object has `render` and `unmount` methods
 */
export const createRoot = (
  element: HTMLElement | DocumentFragment,
  options: RootOptions = {}
): Root => {
  let setJsxNode:
    | undefined // initial state
    | ((jsxNode: unknown) => void) // rendered
    | null = // unmounted
    undefined

  if (Object.keys(options).length > 0) {
    console.warn('createRoot options are not supported yet')
  }

  return {
    render(jsxNode: unknown) {
      if (setJsxNode === null) {
        // unmounted
        throw new Error('Cannot update an unmounted root')
      }
      if (setJsxNode) {
        // rendered
        setJsxNode(jsxNode)
      } else {
        renderNode(
          buildNode({
            tag: () => {
              const [_jsxNode, _setJsxNode] = useState(jsxNode)
              setJsxNode = _setJsxNode
              return _jsxNode
            },
            props: {},
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
          } as any) as NodeObject,
          element
        )
      }
    },
    unmount() {
      setJsxNode?.(null)
      setJsxNode = null
    },
  }
}

/**
 * Create a root object and hydrate app to the target element.
 * In hono/jsx/dom, hydrate is equivalent to render.
 * @param element Render target
 * @param reactNode A JSXNode to render
 * @param options Options for createRoot (not supported yet)
 * @returns Root object has `render` and `unmount` methods
 */
export const hydrateRoot = (
  element: HTMLElement | DocumentFragment,
  reactNode: Child,
  options: RootOptions = {}
): Root => {
  const root = createRoot(element, options)
  root.render(reactNode)
  return root
}

export default {
  createRoot,
  hydrateRoot,
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/components.test.tsx
```
/** @jsxImportSource ../ */
import { JSDOM } from 'jsdom'
import { ErrorBoundary as ErrorBoundaryCommon, Suspense as SuspenseCommon } from '..' // for common
// run tests by old style jsx default
// hono/jsx/jsx-runtime and hono/jsx/dom/jsx-runtime are tested in their respective settings
import { use, useState } from '../hooks'
import { ErrorBoundary as ErrorBoundaryDom, Suspense as SuspenseDom, render } from '.' // for dom

runner('Common', SuspenseCommon, ErrorBoundaryCommon)
runner('DOM', SuspenseDom, ErrorBoundaryDom)

function runner(
  name: string,
  Suspense: typeof SuspenseDom,
  ErrorBoundary: typeof ErrorBoundaryDom
) {
  describe(name, () => {
    beforeAll(() => {
      global.requestAnimationFrame = (cb) => setTimeout(cb)
    })

    describe('Suspense', () => {
      let dom: JSDOM
      let root: HTMLElement
      beforeEach(() => {
        dom = new JSDOM('<html><body><div id="root"></div></body></html>', {
          runScripts: 'dangerously',
        })
        global.document = dom.window.document
        global.HTMLElement = dom.window.HTMLElement
        global.Text = dom.window.Text
        root = document.getElementById('root') as HTMLElement
      })

      it('has no lazy load content', async () => {
        const App = <Suspense fallback={<div>Loading...</div>}>Hello</Suspense>
        render(App, root)
        expect(root.innerHTML).toBe('Hello')
      })

      it('with use()', async () => {
        let resolve: (value: number) => void = () => {}
        const promise = new Promise<number>((_resolve) => (resolve = _resolve))
        const Content = () => {
          const num = use(promise)
          return <p>{num}</p>
        }
        const Component = () => {
          return (
            <Suspense fallback={<div>Loading...</div>}>
              <Content />
            </Suspense>
          )
        }
        const App = <Component />
        render(App, root)
        expect(root.innerHTML).toBe('<div>Loading...</div>')
        resolve(1)
        await new Promise((resolve) => setTimeout(resolve))
        expect(root.innerHTML).toBe('<p>1</p>')
      })

      it('with use() update', async () => {
        const counterMap: Record<number, Promise<number>> = {}
        const getCounter = (count: number) => (counterMap[count] ||= Promise.resolve(count + 1))
        const Content = ({ count }: { count: number }) => {
          const num = use(getCounter(count))
          return (
            <>
              <div>{num}</div>
            </>
          )
        }
        const Component = () => {
          const [count, setCount] = useState(0)
          return (
            <Suspense fallback={<div>Loading...</div>}>
              <Content count={count} />
              <button onClick={() => setCount(count + 1)}>Increment</button>
            </Suspense>
          )
        }
        const App = <Component />
        render(App, root)
        expect(root.innerHTML).toBe('<div>Loading...</div>')
        await Promise.resolve()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div>1</div><button>Increment</button>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div>Loading...</div>')
        await Promise.resolve()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div>2</div><button>Increment</button>')
      })

      it('with use() nested', async () => {
        let resolve: (value: number) => void = () => {}
        const promise = new Promise<number>((_resolve) => (resolve = _resolve))
        const Content = () => {
          const num = use(promise)
          return <p>{num}</p>
        }
        let resolve2: (value: number) => void = () => {}
        const promise2 = new Promise<number>((_resolve) => (resolve2 = _resolve))
        const Content2 = () => {
          const num = use(promise2)
          return <p>{num}</p>
        }
        const Component = () => {
          return (
            <Suspense fallback={<div>Loading...</div>}>
              <Content />
              <Suspense fallback={<div>More...</div>}>
                <Content2 />
              </Suspense>
            </Suspense>
          )
        }
        const App = <Component />
        render(App, root)
        expect(root.innerHTML).toBe('<div>Loading...</div>')
        resolve(1)
        await new Promise((resolve) => setTimeout(resolve))
        expect(root.innerHTML).toBe('<p>1</p><div>More...</div>')
        resolve2(2)
        await new Promise((resolve) => setTimeout(resolve))
        expect(root.innerHTML).toBe('<p>1</p><p>2</p>')
      })

      it('race condition', async () => {
        let resolve: (value: number) => void = () => {}
        const promise = new Promise<number>((_resolve) => (resolve = _resolve))
        const Content = () => {
          const num = use(promise)
          return <p>{num}</p>
        }
        const Component = () => {
          const [show, setShow] = useState(false)
          return (
            <div>
              <button onClick={() => setShow((s) => !s)}>{show ? 'Hide' : 'Show'}</button>
              {show && (
                <Suspense fallback={<div>Loading...</div>}>
                  <Content />
                </Suspense>
              )}
            </div>
          )
        }
        const App = <Component />
        render(App, root)
        expect(root.innerHTML).toBe('<div><button>Show</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div><button>Hide</button><div>Loading...</div></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div><button>Show</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div><button>Hide</button><div>Loading...</div></div>')
        resolve(2)
        await Promise.resolve()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div><button>Hide</button><p>2</p></div>')
      })

      it('Suspense at child', async () => {
        let resolve: (value: number) => void = () => {}
        const promise = new Promise<number>((_resolve) => (resolve = _resolve))
        const Content = () => {
          const num = use(promise)
          return <p>{num}</p>
        }

        const Component = () => {
          return (
            <Suspense fallback={<div>Loading...</div>}>
              <Content />
            </Suspense>
          )
        }
        const App = () => {
          const [show, setShow] = useState(false)
          return (
            <div>
              {show && <Component />}
              <button onClick={() => setShow(true)}>Show</button>
            </div>
          )
        }
        render(<App />, root)
        expect(root.innerHTML).toBe('<div><button>Show</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div><div>Loading...</div><button>Show</button></div>')
        resolve(2)
        await Promise.resolve()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div><p>2</p><button>Show</button></div>')
      })

      it('Suspense at child counter', async () => {
        const promiseMap: Record<number, Promise<number>> = {}
        const Counter = () => {
          const [count, setCount] = useState(0)
          const promise = (promiseMap[count] ||= Promise.resolve(count))
          const value = use(promise)
          return (
            <>
              <p>{value}</p>
              <button onClick={() => setCount(count + 1)}>Increment</button>
            </>
          )
        }
        const Component = () => {
          return (
            <Suspense fallback={<div>Loading...</div>}>
              <Counter />
            </Suspense>
          )
        }
        const App = () => {
          return (
            <div>
              <Component />
            </div>
          )
        }
        render(<App />, root)
        expect(root.innerHTML).toBe('<div><div>Loading...</div></div>')
        await Promise.resolve()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div><p>0</p><button>Increment</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div><div>Loading...</div></div>')
        await Promise.resolve()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div><p>1</p><button>Increment</button></div>')
      })
    })

    describe('ErrorBoundary', () => {
      let dom: JSDOM
      let root: HTMLElement
      beforeEach(() => {
        dom = new JSDOM('<html><body><div id="root"></div></body></html>', {
          runScripts: 'dangerously',
        })
        global.document = dom.window.document
        global.HTMLElement = dom.window.HTMLElement
        global.Text = dom.window.Text
        root = document.getElementById('root') as HTMLElement
      })

      it('has no error', async () => {
        const App = (
          <ErrorBoundary fallback={<div>Error</div>}>
            <div>OK</div>
          </ErrorBoundary>
        )
        render(App, root)
        expect(root.innerHTML).toBe('<div>OK</div>')
      })

      it('has error', async () => {
        const Component = () => {
          throw new Error('error')
        }
        const App = (
          <ErrorBoundary fallback={<div>Error</div>}>
            <Component />
          </ErrorBoundary>
        )
        render(App, root)
        expect(root.innerHTML).toBe('<div>Error</div>')
      })

      it('has no error with Suspense', async () => {
        let resolve: (value: number) => void = () => {}
        const promise = new Promise<number>((_resolve) => (resolve = _resolve))
        const Content = () => {
          const num = use(promise)
          return <p>{num}</p>
        }
        const Component = () => {
          return (
            <ErrorBoundary fallback={<div>Error</div>}>
              <Suspense fallback={<div>Loading...</div>}>
                <Content />
              </Suspense>
            </ErrorBoundary>
          )
        }
        const App = <Component />
        render(App, root)
        expect(root.innerHTML).toBe('<div>Loading...</div>')
        resolve(1)
        await new Promise((resolve) => setTimeout(resolve))
        expect(root.innerHTML).toBe('<p>1</p>')
      })

      it('has error with Suspense', async () => {
        let resolve: (value: number) => void = () => {}
        const promise = new Promise<number>((_resolve) => (resolve = _resolve))
        const Content = () => {
          use(promise)
          throw new Error('error')
        }
        const Component = () => {
          return (
            <ErrorBoundary fallback={<div>Error</div>}>
              <Suspense fallback={<div>Loading...</div>}>
                <Content />
              </Suspense>
            </ErrorBoundary>
          )
        }
        const App = <Component />
        render(App, root)
        expect(root.innerHTML).toBe('<div>Loading...</div>')
        resolve(1)
        await new Promise((resolve) => setTimeout(resolve))
        expect(root.innerHTML).toBe('<div>Error</div>')
      })
    })
  })
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/components.ts
```typescript
import type { Child, FC, PropsWithChildren } from '../'
import type { ErrorHandler, FallbackRender } from '../components'
import { DOM_ERROR_HANDLER } from '../constants'
import { Fragment } from './jsx-runtime'

/* eslint-disable @typescript-eslint/no-explicit-any */
export const ErrorBoundary: FC<
  PropsWithChildren<{
    fallback?: Child
    fallbackRender?: FallbackRender
    onError?: ErrorHandler
  }>
> = (({ children, fallback, fallbackRender, onError }: any) => {
  const res = Fragment({ children })
  ;(res as any)[DOM_ERROR_HANDLER] = (err: any) => {
    if (err instanceof Promise) {
      throw err
    }
    onError?.(err)
    return fallbackRender?.(err) || fallback
  }
  return res
}) as any

export const Suspense: FC<PropsWithChildren<{ fallback: any }>> = (({
  children,
  fallback,
}: any) => {
  const res = Fragment({ children })
  ;(res as any)[DOM_ERROR_HANDLER] = (err: any, retry: () => void) => {
    if (!(err instanceof Promise)) {
      throw err
    }
    err.finally(retry)
    return fallback
  }
  return res
}) as any
/* eslint-enable @typescript-eslint/no-explicit-any */

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/context.test.tsx
```
/** @jsxImportSource ../ */
import { JSDOM } from 'jsdom'
import {
  Suspense,
  createContext as createContextCommon,
  use,
  useContext as useContextCommon,
} from '..' // for common
// run tests by old style jsx default
// hono/jsx/jsx-runtime and hono/jsx/dom/jsx-runtime are tested in their respective settings
import { createContext as createContextDom, render, useContext as useContextDom, useState } from '.' // for dom

runner('Common', createContextCommon, useContextCommon)
runner('DOM', createContextDom, useContextDom)

function runner(
  name: string,
  createContext: typeof createContextCommon,
  useContext: typeof useContextCommon
) {
  describe(name, () => {
    beforeAll(() => {
      global.requestAnimationFrame = (cb) => setTimeout(cb)
    })

    describe('Context', () => {
      let dom: JSDOM
      let root: HTMLElement
      beforeEach(() => {
        dom = new JSDOM('<html><body><div id="root"></div></body></html>', {
          runScripts: 'dangerously',
        })
        global.document = dom.window.document
        global.HTMLElement = dom.window.HTMLElement
        global.Text = dom.window.Text
        root = document.getElementById('root') as HTMLElement
      })

      it('simple context', async () => {
        const Context = createContext(0)
        const Content = () => {
          const num = useContext(Context)
          return <p>{num}</p>
        }
        const Component = () => {
          return (
            <Context.Provider value={1}>
              <Content />
            </Context.Provider>
          )
        }
        const App = <Component />
        render(App, root)
        expect(root.innerHTML).toBe('<p>1</p>')
      })

      it('<Context> as a provider ', async () => {
        const Context = createContext(0)
        const Content = () => {
          const num = useContext(Context)
          return <p>{num}</p>
        }
        const Component = () => {
          return (
            <Context value={1}>
              <Content />
            </Context>
          )
        }
        const App = <Component />
        render(App, root)
        expect(root.innerHTML).toBe('<p>1</p>')
      })

      it('simple context with state', async () => {
        const Context = createContext(0)
        const Content = () => {
          const [count, setCount] = useState(0)
          const num = useContext(Context)
          return (
            <>
              <p>
                {num} - {count}
              </p>
              <button onClick={() => setCount(count + 1)}>+</button>
            </>
          )
        }
        const Component = () => {
          return (
            <Context.Provider value={1}>
              <Content />
            </Context.Provider>
          )
        }
        const App = <Component />
        render(App, root)
        expect(root.innerHTML).toBe('<p>1 - 0</p><button>+</button>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<p>1 - 1</p><button>+</button>')
      })

      it('multiple provider', async () => {
        const Context = createContext(0)
        const Content = () => {
          const num = useContext(Context)
          return <p>{num}</p>
        }
        const Component = () => {
          return (
            <>
              <Context.Provider value={1}>
                <Content />
              </Context.Provider>
              <Context.Provider value={2}>
                <Content />
              </Context.Provider>
            </>
          )
        }
        const App = <Component />
        render(App, root)
        expect(root.innerHTML).toBe('<p>1</p><p>2</p>')
      })

      it('nested provider', async () => {
        const Context = createContext(0)
        const Content = () => {
          const num = useContext(Context)
          return <p>{num}</p>
        }
        const Component = () => {
          return (
            <>
              <Context.Provider value={1}>
                <Content />
                <Context.Provider value={3}>
                  <Content />
                </Context.Provider>
                <Content />
              </Context.Provider>
            </>
          )
        }
        const App = <Component />
        render(App, root)
        expect(root.innerHTML).toBe('<p>1</p><p>3</p><p>1</p>')
      })

      it('inside Suspense', async () => {
        const promise = Promise.resolve(2)
        const AsyncComponent = () => {
          const num = use(promise)
          return <p>{num}</p>
        }
        const Context = createContext(0)
        const Content = () => {
          const num = useContext(Context)
          return <p>{num}</p>
        }
        const Component = () => {
          return (
            <>
              <Context.Provider value={1}>
                <Content />
                <Suspense fallback={<div>Loading...</div>}>
                  <Context.Provider value={3}>
                    <Content />
                    <AsyncComponent />
                  </Context.Provider>
                </Suspense>
                <Content />
              </Context.Provider>
            </>
          )
        }
        const App = <Component />
        render(App, root)
        expect(root.innerHTML).toBe('<p>1</p><div>Loading...</div><p>1</p>')
      })
    })
  })
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/context.ts
```typescript
import type { Child } from '../base'
import { DOM_ERROR_HANDLER } from '../constants'
import type { Context } from '../context'
import { globalContexts } from '../context'
import { setInternalTagFlag } from './utils'

export const createContextProviderFunction =
  <T>(values: T[]): Function =>
  ({ value, children }: { value: T; children: Child[] }) => {
    if (!children) {
      return undefined
    }

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const props: { children: any } = {
      children: [
        {
          tag: setInternalTagFlag(() => {
            values.push(value)
          }),
          props: {},
        },
      ],
    }
    if (Array.isArray(children)) {
      props.children.push(...children.flat())
    } else {
      props.children.push(children)
    }
    props.children.push({
      tag: setInternalTagFlag(() => {
        values.pop()
      }),
      props: {},
    })
    const res = { tag: '', props, type: '' }
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    ;(res as any)[DOM_ERROR_HANDLER] = (err: unknown) => {
      values.pop()
      throw err
    }
    return res
  }

export const createContext = <T>(defaultValue: T): Context<T> => {
  const values = [defaultValue]
  const context: Context<T> = createContextProviderFunction(values) as Context<T>
  context.values = values
  context.Provider = context
  globalContexts.push(context as Context<unknown>)
  return context
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/css.test.tsx
```
/** @jsxImportSource ../ */
import { JSDOM } from 'jsdom'
// run tests by old style jsx default
// hono/jsx/jsx-runtime and hono/jsx/dom/jsx-runtime are tested in their respective settings

import type { JSXNode } from '..'
import { Style, createCssContext, css, rawCssString } from '../../helper/css'
import { minify } from '../../helper/css/common'
import { renderTest } from '../../helper/css/common.case.test'
import { render } from '.'

describe('Style and css for jsx/dom', () => {
  beforeAll(() => {
    global.requestAnimationFrame = (cb) => setTimeout(cb)
  })

  let dom: JSDOM
  let root: HTMLElement
  beforeEach(() => {
    dom = new JSDOM('<html><body><div id="root"></div></body></html>', {
      runScripts: 'dangerously',
    })
    global.document = dom.window.document
    global.HTMLElement = dom.window.HTMLElement
    global.SVGElement = dom.window.SVGElement
    global.Text = dom.window.Text
    root = document.getElementById('root') as HTMLElement
  })

  it('<Style />', async () => {
    const App = () => {
      return (
        <div>
          <Style />
          <div
            class={css`
              color: red;
            `}
          >
            red
          </div>
        </div>
      )
    }
    render(<App />, root)
    expect(root.innerHTML).toBe(
      '<div><style id="hono-css"></style><div class="css-3142110215">red</div></div>'
    )
    await Promise.resolve()
    expect(root.querySelector('style')?.sheet?.cssRules[0].cssText).toBe(
      '.css-3142110215 {color: red;}'
    )
  })

  it('<Style nonce="1234" />', async () => {
    const App = () => {
      return (
        <div>
          <Style nonce='1234' />
        </div>
      )
    }
    render(<App />, root)
    expect(root.innerHTML).toBe('<div><style id="hono-css" nonce="1234"></style></div>')
  })

  it('<Style>{css`global`}</Style>', async () => {
    const App = () => {
      return (
        <div>
          <Style>{css`
            color: red;
          `}</Style>
          <div
            class={css`
              color: red;
            `}
          >
            red
          </div>
        </div>
      )
    }
    render(<App />, root)
    expect(root.innerHTML).toBe(
      '<div><style id="hono-css">color:red</style><div class="css-3142110215">red</div></div>'
    )
  })
})

describe('render', () => {
  renderTest(() => {
    const cssContext = createCssContext({ id: 'hono-css' })

    const dom = new JSDOM('<html><body><div id="root"></div></body></html>', {
      runScripts: 'dangerously',
    })
    global.document = dom.window.document
    global.HTMLElement = dom.window.HTMLElement
    global.Text = dom.window.Text
    const root = document.getElementById('root') as HTMLElement

    const toString = async (node: JSXNode) => {
      render(node, root)
      await Promise.resolve()
      const style = root.querySelector('style')
      if (style) {
        style.textContent = minify(
          [...(style.sheet?.cssRules || [])].map((r) => r.cssText).join('') || ''
        )
      }
      return root.innerHTML
    }

    return {
      toString,
      rawCssString,
      ...cssContext,
      support: { nest: false },
    }
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/css.ts
```typescript
/**
 * @module
 * This module provides APIs that enable `hono/jsx/dom` to support.
 */

import type { FC, PropsWithChildren } from '../'
import type { CssClassName, CssVariableType } from '../../helper/css/common'
import {
  CLASS_NAME,
  DEFAULT_STYLE_ID,
  PSEUDO_GLOBAL_SELECTOR,
  SELECTOR,
  SELECTORS,
  STYLE_STRING,
  cssCommon,
  cxCommon,
  keyframesCommon,
  viewTransitionCommon,
} from '../../helper/css/common'
export { rawCssString } from '../../helper/css/common'

const splitRule = (rule: string): string[] => {
  const result: string[] = []
  let startPos = 0
  let depth = 0
  for (let i = 0, len = rule.length; i < len; i++) {
    const char = rule[i]

    // consume quote

    if (char === "'" || char === '"') {
      const quote = char
      i++
      for (; i < len; i++) {
        if (rule[i] === '\\') {
          i++
          continue
        }
        if (rule[i] === quote) {
          break
        }
      }
      continue
    }

    // comments are removed from the rule in advance
    if (char === '{') {
      depth++
      continue
    }
    if (char === '}') {
      depth--
      if (depth === 0) {
        result.push(rule.slice(startPos, i + 1))
        startPos = i + 1
      }
      continue
    }
  }
  return result
}

interface CreateCssJsxDomObjectsType {
  (args: { id: Readonly<string> }): readonly [
    {
      toString(this: CssClassName): string
    },
    FC<PropsWithChildren<void>>
  ]
}

export const createCssJsxDomObjects: CreateCssJsxDomObjectsType = ({ id }) => {
  let styleSheet: CSSStyleSheet | null | undefined = undefined
  const findStyleSheet = (): [CSSStyleSheet, Set<string>] | [] => {
    if (!styleSheet) {
      styleSheet = document.querySelector<HTMLStyleElement>(`style#${id}`)
        ?.sheet as CSSStyleSheet | null
      if (styleSheet) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        ;(styleSheet as any).addedStyles = new Set<string>()
      }
    }
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    return styleSheet ? [styleSheet, (styleSheet as any).addedStyles] : []
  }

  const insertRule = (className: string, styleString: string) => {
    const [sheet, addedStyles] = findStyleSheet()
    if (!sheet || !addedStyles) {
      Promise.resolve().then(() => {
        if (!findStyleSheet()[0]) {
          throw new Error('style sheet not found')
        }
        insertRule(className, styleString)
      })
      return
    }

    if (!addedStyles.has(className)) {
      addedStyles.add(className)
      ;(className.startsWith(PSEUDO_GLOBAL_SELECTOR)
        ? splitRule(styleString)
        : [`${className[0] === '@' ? '' : '.'}${className}{${styleString}}`]
      ).forEach((rule) => {
        sheet.insertRule(rule, sheet.cssRules.length)
      })
    }
  }

  const cssObject = {
    toString(this: CssClassName): string {
      const selector = this[SELECTOR]
      insertRule(selector, this[STYLE_STRING])
      this[SELECTORS].forEach(({ [CLASS_NAME]: className, [STYLE_STRING]: styleString }) => {
        insertRule(className, styleString)
      })

      return this[CLASS_NAME]
    },
  }

  const Style: FC<PropsWithChildren<{ nonce?: string }>> = ({ children, nonce }) =>
    ({
      tag: 'style',
      props: {
        id,
        nonce,
        children:
          children &&
          (Array.isArray(children) ? children : [children]).map(
            (c) => (c as unknown as CssClassName)[STYLE_STRING]
          ),
      },
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
    } as any)

  return [cssObject, Style] as const
}

interface CssType {
  (strings: TemplateStringsArray, ...values: CssVariableType[]): string
}

interface CxType {
  (...args: (string | boolean | null | undefined)[]): string
}

interface KeyframesType {
  (strings: TemplateStringsArray, ...values: CssVariableType[]): CssClassName
}

interface ViewTransitionType {
  (strings: TemplateStringsArray, ...values: CssVariableType[]): string
  (content: string): string
  (): string
}

interface DefaultContextType {
  css: CssType
  cx: CxType
  keyframes: KeyframesType
  viewTransition: ViewTransitionType
  Style: FC<PropsWithChildren<void>>
}

/**
 * @experimental
 * `createCssContext` is an experimental feature.
 * The API might be changed.
 */
export const createCssContext = ({ id }: { id: Readonly<string> }): DefaultContextType => {
  const [cssObject, Style] = createCssJsxDomObjects({ id })

  const newCssClassNameObject = (cssClassName: CssClassName): string => {
    cssClassName.toString = cssObject.toString
    return cssClassName as unknown as string
  }

  const css: CssType = (strings, ...values) => {
    return newCssClassNameObject(cssCommon(strings, values))
  }

  const cx: CxType = (...args) => {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    args = cxCommon(args as any) as any
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    return css(Array(args.length).fill('') as any, ...args)
  }

  const keyframes: KeyframesType = keyframesCommon

  const viewTransition: ViewTransitionType = ((
    strings: TemplateStringsArray | string | undefined,
    ...values: CssVariableType[]
  ) => {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    return newCssClassNameObject(viewTransitionCommon(strings as any, values))
  }) as ViewTransitionType

  return {
    css,
    cx,
    keyframes,
    viewTransition,
    Style,
  }
}

const defaultContext: DefaultContextType = createCssContext({ id: DEFAULT_STYLE_ID })

/**
 * @experimental
 * `css` is an experimental feature.
 * The API might be changed.
 */
export const css = defaultContext.css

/**
 * @experimental
 * `cx` is an experimental feature.
 * The API might be changed.
 */
export const cx = defaultContext.cx

/**
 * @experimental
 * `keyframes` is an experimental feature.
 * The API might be changed.
 */
export const keyframes = defaultContext.keyframes

/**
 * @experimental
 * `viewTransition` is an experimental feature.
 * The API might be changed.
 */
export const viewTransition = defaultContext.viewTransition

/**
 * @experimental
 * `Style` is an experimental feature.
 * The API might be changed.
 */
export const Style = defaultContext.Style

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/index.test.tsx
```
/** @jsxImportSource ../ */
import { JSDOM } from 'jsdom'
import type { Child, FC } from '..'
// run tests by old style jsx default
// hono/jsx/jsx-runtime and hono/jsx/dom/jsx-runtime are tested in their respective settings
import { createElement, jsx } from '..'
import type { RefObject } from '../hooks'
import {
  createRef,
  useCallback,
  useEffect,
  useInsertionEffect,
  useLayoutEffect,
  useMemo,
  useRef,
  useState,
} from '../hooks'
import DefaultExport, {
  cloneElement,
  cloneElement as cloneElementForDom,
  createElement as createElementForDom,
  createContext,
  useContext,
  createPortal,
  flushSync,
  isValidElement,
  memo,
  render,
  version,
} from '.'

describe('Common', () => {
  ;[createElement, createElementForDom].forEach((createElement) => {
    describe('createElement', () => {
      it('simple', () => {
        const element = createElement('div', { id: 'app' })
        expect(element).toEqual(expect.objectContaining({ tag: 'div', props: { id: 'app' } }))
      })

      it('children', () => {
        const element = createElement('div', { id: 'app' }, 'Hello')
        expect(element).toEqual(
          expect.objectContaining({ tag: 'div', props: { id: 'app', children: 'Hello' } })
        )
      })

      it('multiple children', () => {
        const element = createElement('div', { id: 'app' }, 'Hello', 'World')
        expect(element).toEqual(
          expect.objectContaining({
            tag: 'div',
            props: { id: 'app', children: ['Hello', 'World'] },
          })
        )
      })

      it('key', () => {
        const element = createElement('div', { id: 'app', key: 'key' })
        expect(element).toEqual(
          expect.objectContaining({ tag: 'div', props: { id: 'app' }, key: 'key' })
        )
      })

      it('ref', () => {
        const ref = { current: null }
        const element = createElement('div', { id: 'app', ref })
        expect(element).toEqual(expect.objectContaining({ tag: 'div', props: { id: 'app', ref } }))
        expect(element.ref).toBe(ref)
      })

      it('type', () => {
        const element = createElement('div', { id: 'app' })
        expect(element.type).toBe('div')
      })

      it('null props', () => {
        const element = createElement('div', null)
        expect(element).toEqual(expect.objectContaining({ tag: 'div', props: {} }))
      })
    })
  })
})

describe('DOM', () => {
  beforeAll(() => {
    global.requestAnimationFrame = (cb) => setTimeout(cb)
  })

  let dom: JSDOM
  let root: HTMLElement
  beforeEach(() => {
    dom = new JSDOM('<html><body><div id="root"></div></body></html>', {
      runScripts: 'dangerously',
    })
    global.document = dom.window.document
    global.HTMLElement = dom.window.HTMLElement
    global.SVGElement = dom.window.SVGElement
    global.Text = dom.window.Text
    root = document.getElementById('root') as HTMLElement
  })

  it('simple App', () => {
    const App = <h1>Hello</h1>
    render(App, root)
    expect(root.innerHTML).toBe('<h1>Hello</h1>')
  })

  it('replace', () => {
    dom.window.document.body.innerHTML = '<div id="root">Existing content</div>'
    root = document.getElementById('root') as HTMLElement
    const App = <h1>Hello</h1>
    render(App, root)
    expect(root.innerHTML).toBe('<h1>Hello</h1>')
  })

  it('render text directly', () => {
    const App = () => <>{'Hello'}</>
    render(<App />, root)
    expect(root.innerHTML).toBe('Hello')
  })

  describe('performance', () => {
    it('should be O(N) for each additional element', () => {
      const App = () => (
        <>
          {Array.from({ length: 1000 }, (_, i) => (
            <div>
              <span>{i}</span>
            </div>
          ))}
        </>
      )
      render(<App />, root)
      expect(root.innerHTML).toBe(
        Array.from({ length: 1000 }, (_, i) => `<div><span>${i}</span></div>`).join('')
      )
    })
  })

  describe('attribute', () => {
    it('simple', () => {
      const App = () => <div id='app' class='app' />
      render(<App />, root)
      expect(root.innerHTML).toBe('<div id="app" class="app"></div>')
    })

    it('boolean', () => {
      const App = () => <div hidden />
      render(<App />, root)
      expect(root.innerHTML).toBe('<div hidden=""></div>')
    })

    it('style', () => {
      const App = () => <div style={{ fontSize: '10px' }} />
      render(<App />, root)
      expect(root.innerHTML).toBe('<div style="font-size: 10px;"></div>')
    })

    it('update style', () => {
      const App = () => <div style={{ fontSize: '10px' }} />
      render(<App />, root)
      expect(root.innerHTML).toBe('<div style="font-size: 10px;"></div>')
    })

    it('style with CSS variables - 1', () => {
      const App = () => <div style={{ '--my-var-1': '15px' }} />
      render(<App />, root)
      expect(root.innerHTML).toBe('<div style="--my-var-1: 15px;"></div>')
    })

    it('style with CSS variables - 2', () => {
      const App = () => <div style={{ '--myVar-2': '20px' }} />
      render(<App />, root)
      expect(root.innerHTML).toBe('<div style="--myVar-2: 20px;"></div>')
    })

    it('style with string', async () => {
      const App = () => {
        const [style, setStyle] = useState<{ fontSize?: string; color?: string }>({
          fontSize: '10px',
        })
        return <div style={style} onClick={() => setStyle({ color: 'red' })} />
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div style="font-size: 10px;"></div>')
      root.querySelector('div')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div style="color: red;"></div>')
    })

    it('toString() is called', () => {
      const App = () => <div x-value={{ toString: () => 'value' }} />
      render(<App />, root)
      expect(root.innerHTML).toBe('<div x-value="value"></div>')
    })

    it('ref', () => {
      const App = () => {
        const ref = useRef<HTMLDivElement>(null)
        return <div ref={ref} />
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div></div>')
    })

    it('ref with callback', () => {
      const ref = useRef<HTMLDivElement>(null)
      const App = () => {
        return <div ref={(node: HTMLDivElement) => (ref.current = node)} />
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div></div>')
      expect(ref.current).toBeInstanceOf(HTMLElement)
    })

    it('ref with null', () => {
      const App = () => {
        return <div ref={null} />
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div></div>')
    })

    it('remove node with ref object', async () => {
      const ref = createRef<HTMLDivElement>()
      const App = () => {
        const [show, setShow] = useState(true)
        return (
          <>
            {show && <div ref={ref} />}
            <button onClick={() => setShow(false)}>remove</button>
          </>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div></div><button>remove</button>')
      expect(ref.current).toBeInstanceOf(dom.window.HTMLDivElement)
      root.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<button>remove</button>')
      expect(ref.current).toBe(null)
    })

    it('remove node with ref function', async () => {
      const ref = vi.fn()
      const App = () => {
        const [show, setShow] = useState(true)
        return (
          <>
            {show && <div ref={ref} />}
            <button onClick={() => setShow(false)}>remove</button>
          </>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div></div><button>remove</button>')
      expect(ref).toHaveBeenLastCalledWith(expect.any(dom.window.HTMLDivElement))
      root.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<button>remove</button>')
      expect(ref).toHaveBeenLastCalledWith(null)
    })

    it('ref cleanup function', async () => {
      const cleanup = vi.fn()
      const ref = vi.fn().mockReturnValue(cleanup)
      const App = () => {
        const [show, setShow] = useState(true)
        return (
          <>
            {show && <div ref={ref} />}
            <button onClick={() => setShow(false)}>remove</button>
          </>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div></div><button>remove</button>')
      expect(ref).toHaveBeenLastCalledWith(expect.any(dom.window.HTMLDivElement))
      root.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<button>remove</button>')
      expect(ref).toBeCalledTimes(1)
      expect(cleanup).toBeCalledTimes(1)
    })
  })

  describe('child component', () => {
    it('simple', async () => {
      const Child = vi.fn(({ count }: { count: number }) => <div>{count}</div>)
      const App = () => {
        const [count, setCount] = useState(0)
        return (
          <>
            <div>{count}</div>
            <Child count={Math.floor(count / 2)} />
            <button onClick={() => setCount(count + 1)}>+</button>
          </>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div>0</div><div>0</div><button>+</button>')
      expect(Child).toBeCalledTimes(1)
      root.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div>1</div><div>0</div><button>+</button>')
      expect(Child).toBeCalledTimes(2)
      root.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div>2</div><div>1</div><button>+</button>')
      expect(Child).toBeCalledTimes(3)
    })
  })

  describe('defaultProps', () => {
    it('simple', () => {
      const App: FC<{ name?: string }> = ({ name }) => <div>{name}</div>
      App.defaultProps = { name: 'default' }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div>default</div>')
    })

    it('override', () => {
      const App: FC<{ name: string }> = ({ name }) => <div>{name}</div>
      App.defaultProps = { name: 'default' }
      render(<App name='override' />, root)
      expect(root.innerHTML).toBe('<div>override</div>')
    })
  })

  describe('replace content', () => {
    it('text to text', async () => {
      let setCount: (count: number) => void = () => {}
      const App = () => {
        const [count, _setCount] = useState(0)
        setCount = _setCount
        return <>{count}</>
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('0')
      setCount(1)
      await Promise.resolve()
      expect(root.innerHTML).toBe('1')
    })

    it('text to element', async () => {
      let setCount: (count: number) => void = () => {}
      const App = () => {
        const [count, _setCount] = useState(0)
        setCount = _setCount
        return count === 0 ? <>{count}</> : <div>{count}</div>
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('0')
      setCount(1)
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div>1</div>')
    })

    it('element to element', async () => {
      let setCount: (count: number) => void = () => {}
      const App = () => {
        const [count, _setCount] = useState(0)
        setCount = _setCount
        return <div>{count}</div>
      }
      const app = <App />
      render(app, root)
      expect(root.innerHTML).toBe('<div>0</div>')

      const insertBeforeSpy = vi.spyOn(dom.window.Node.prototype, 'insertBefore')
      setCount(1)
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div>1</div>')
      expect(insertBeforeSpy).not.toHaveBeenCalled()
    })

    it('element to text to element', async () => {
      let setCount: (count: number) => void = () => {}
      const App = () => {
        const [count, _setCount] = useState(0)
        setCount = _setCount
        return count % 2 === 0 ? <div>{count}</div> : <>{count}</>
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div>0</div>')
      setCount(1)
      await Promise.resolve()
      expect(root.innerHTML).toBe('1')
      setCount(2)
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div>2</div>')
    })

    it('text to child component to text', async () => {
      let setCount: (count: number) => void = () => {}
      const Child = () => {
        return <div>Child</div>
      }
      const App = () => {
        const [count, _setCount] = useState(0)
        setCount = _setCount
        return count % 2 === 0 ? <>{count}</> : <Child />
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('0')
      setCount(1)
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div>Child</div>')
      setCount(2)
      await Promise.resolve()
      expect(root.innerHTML).toBe('2')
    })

    it('one child is updated', async () => {
      let setCount: (count: number) => void = () => {}
      const App = () => {
        const [count, _setCount] = useState(0)
        setCount = _setCount
        return <div>{count}</div>
      }
      const app = (
        <>
          <App />
          <div>Footer</div>
        </>
      )
      render(app, root)
      expect(root.innerHTML).toBe('<div>0</div><div>Footer</div>')

      const insertBeforeSpy = vi.spyOn(dom.window.Node.prototype, 'insertBefore')
      setCount(1)
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div>1</div><div>Footer</div>')
      expect(insertBeforeSpy).not.toHaveBeenCalled()
    })

    it('should not call insertBefore for unchanged complex dom tree', async () => {
      let setCount: (count: number) => void = () => {}
      const App = () => {
        const [count, _setCount] = useState(0)
        setCount = _setCount
        return (
          <form>
            <div>
              <label>label</label>
              <input />
            </div>
            <p>{count}</p>
          </form>
        )
      }
      const app = <App />

      render(app, root)
      expect(root.innerHTML).toBe('<form><div><label>label</label><input></div><p>0</p></form>')

      const insertBeforeSpy = vi.spyOn(dom.window.Node.prototype, 'insertBefore')
      setCount(1)
      await Promise.resolve()
      expect(root.innerHTML).toBe('<form><div><label>label</label><input></div><p>1</p></form>')
      expect(insertBeforeSpy).not.toHaveBeenCalled()
    })

    it('should not call textContent for unchanged text', async () => {
      let setCount: (count: number) => void = () => {}
      const App = () => {
        const [count, _setCount] = useState(0)
        setCount = _setCount
        return (
          <>
            <span>hono</span>
            <input value={count} />
          </>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<span>hono</span><input value="0">')
      setCount(1)

      const textContentSpy = vi.fn()
      Object.defineProperty(dom.window.Text.prototype, 'textContent', {
        set: textContentSpy,
      })
      await Promise.resolve()
      expect(root.innerHTML).toBe('<span>hono</span><input value="1">')
      expect(textContentSpy).not.toHaveBeenCalled()
    })
  })

  describe('children', () => {
    it('element', async () => {
      const Container = ({ children }: { children: Child }) => <div>{children}</div>
      const App = () => (
        <Container>
          <span>Content</span>
        </Container>
      )
      render(<App />, root)
      expect(root.innerHTML).toBe('<div><span>Content</span></div>')
    })

    it('array', async () => {
      const Container = ({ children }: { children: Child }) => <div>{children}</div>
      const App = () => <Container>{[<span>1</span>, <span>2</span>]}</Container>
      render(<App />, root)
      expect(root.innerHTML).toBe('<div><span>1</span><span>2</span></div>')
    })

    it('use the same children multiple times', async () => {
      const MultiChildren = ({ children }: { children: Child }) => (
        <>
          {children}
          <div>{children}</div>
        </>
      )
      const App = () => (
        <MultiChildren>
          <span>Content</span>
        </MultiChildren>
      )
      render(<App />, root)
      expect(root.innerHTML).toBe('<span>Content</span><div><span>Content</span></div>')
    })
  })

  describe('update properties', () => {
    describe('input', () => {
      it('value', async () => {
        let setValue: (value: string) => void = () => {}
        const App = () => {
          const [value, _setValue] = useState('a')
          setValue = _setValue
          return <input value={value} />
        }
        render(<App />, root)
        expect(root.innerHTML).toBe('<input value="a">')
        const valueSpy = vi.fn()
        Object.defineProperty(dom.window.HTMLInputElement.prototype, 'value', {
          set: valueSpy,
        })
        setValue('b')
        await Promise.resolve()
        expect(root.innerHTML).toBe('<input value="b">')
        expect(valueSpy).toHaveBeenCalledWith('b')
      })

      it('assign undefined', async () => {
        let setValue: (value: string | undefined) => void = () => {}
        const App = () => {
          const [value, _setValue] = useState<string | undefined>('a')
          setValue = _setValue
          return <input value={value} />
        }
        render(<App />, root)
        expect(root.innerHTML).toBe('<input value="a">')
        const valueSpy = vi.fn()
        Object.defineProperty(dom.window.HTMLInputElement.prototype, 'value', {
          set: valueSpy,
        })
        setValue(undefined)
        await Promise.resolve()
        expect(root.innerHTML).toBe('<input>')
        expect(valueSpy).toHaveBeenCalledWith(null) // assign null means empty string
      })

      it('checked', async () => {
        let setValue: (value: string) => void = () => {}
        const App = () => {
          const [value, _setValue] = useState('a')
          setValue = _setValue
          return <input type='checkbox' checked={value === 'b'} />
        }
        render(<App />, root)
        expect(root.innerHTML).toBe('<input type="checkbox">')
        const checkedSpy = vi.fn()
        Object.defineProperty(dom.window.HTMLInputElement.prototype, 'checked', {
          set: checkedSpy,
        })
        setValue('b')
        await Promise.resolve()
        expect(root.innerHTML).toBe('<input type="checkbox" checked="">')
        expect(checkedSpy).toHaveBeenCalledWith(true)
        setValue('a')
        await Promise.resolve()
        expect(root.innerHTML).toBe('<input type="checkbox">')
        expect(checkedSpy).toHaveBeenCalledWith(false)
      })
    })

    describe('textarea', () => {
      it('value', async () => {
        let setValue: (value: string) => void = () => {}
        const App = () => {
          const [value, _setValue] = useState('a')
          setValue = _setValue
          return <textarea value={value} />
        }
        render(<App />, root)
        expect(root.innerHTML).toBe('<textarea>a</textarea>')
        const valueSpy = vi.fn()
        Object.defineProperty(dom.window.HTMLTextAreaElement.prototype, 'value', {
          set: valueSpy,
        })
        setValue('b')
        await Promise.resolve()
        expect(root.innerHTML).toBe('<textarea>b</textarea>')
        expect(valueSpy).toHaveBeenCalledWith('b')
      })

      it('assign undefined', async () => {
        let setValue: (value: string | undefined) => void = () => {}
        const App = () => {
          const [value, _setValue] = useState<string | undefined>('a')
          setValue = _setValue
          return <textarea value={value} />
        }
        render(<App />, root)
        expect(root.innerHTML).toBe('<textarea>a</textarea>')
        const valueSpy = vi.fn()
        Object.defineProperty(dom.window.HTMLTextAreaElement.prototype, 'value', {
          set: valueSpy,
        })
        setValue(undefined)
        await Promise.resolve()
        expect(root.innerHTML).toBe('<textarea></textarea>')
        expect(valueSpy).toHaveBeenCalledWith(null) // assign null means empty string
      })
    })

    describe('select', () => {
      it('value', async () => {
        let setValue: (value: string) => void = () => {}
        const App = () => {
          const [value, _setValue] = useState('a')
          setValue = _setValue
          return (
            <select value={value}>
              <option value='a'>A</option>
              <option value='b'>B</option>
              <option value='c'>C</option>
            </select>
          )
        }
        render(<App />, root)
        expect(root.innerHTML).toBe(
          '<select><option value="a">A</option><option value="b">B</option><option value="c">C</option></select>'
        )
        const valueSpy = vi.fn()
        Object.defineProperty(dom.window.HTMLSelectElement.prototype, 'value', {
          set: valueSpy,
        })
        setValue('b')
        await Promise.resolve()
        expect(valueSpy).toHaveBeenCalledWith('b')
      })

      it('invalid value', async () => {
        let setValue: (value: string) => void = () => {}
        const App = () => {
          const [value, _setValue] = useState('a')
          setValue = _setValue
          return (
            <select value={value}>
              <option value='a'>A</option>
              <option value='b'>B</option>
              <option value='c'>C</option>
            </select>
          )
        }
        render(<App />, root)
        expect(root.innerHTML).toBe(
          '<select><option value="a">A</option><option value="b">B</option><option value="c">C</option></select>'
        )
        setValue('z')
        await Promise.resolve()
        const select = root.querySelector('select') as HTMLSelectElement
        expect(select.value).toBe('a') // invalid value is ignored
      })

      it('assign undefined', async () => {
        let setValue: (value: string | undefined) => void = () => {}
        const App = () => {
          const [value, _setValue] = useState<string | undefined>('a')
          setValue = _setValue
          return (
            <select value={value}>
              <option value='a'>A</option>
              <option value='b'>B</option>
              <option value='c'>C</option>
            </select>
          )
        }
        render(<App />, root)
        expect(root.innerHTML).toBe(
          '<select><option value="a">A</option><option value="b">B</option><option value="c">C</option></select>'
        )
        setValue(undefined)
        await Promise.resolve()
        const select = root.querySelector('select') as HTMLSelectElement
        expect(select.value).toBe('a') // select the first option
      })
    })

    describe('option', () => {
      it('selected', async () => {
        let setValue: (value: string) => void = () => {}
        const App = () => {
          const [value, _setValue] = useState('a')
          setValue = _setValue
          return (
            <select>
              <option value='a'>A</option>
              <option value='b' selected={value === 'b'}>
                B
              </option>
              <option value='c'>C</option>
            </select>
          )
        }
        render(<App />, root)
        expect(root.innerHTML).toBe(
          '<select><option value="a">A</option><option value="b">B</option><option value="c">C</option></select>'
        )
        setValue('b')
        await Promise.resolve()
        expect(root.innerHTML).toBe(
          '<select><option value="a">A</option><option value="b" selected="">B</option><option value="c">C</option></select>'
        )
        const select = root.querySelector('select') as HTMLSelectElement
        expect(select.value).toBe('b')
        setValue('a')
        await Promise.resolve()
        expect(root.innerHTML).toBe(
          '<select><option value="a">A</option><option value="b">B</option><option value="c">C</option></select>'
        )
        expect(select.value).toBe('a')
      })
    })
  })

  describe('dangerouslySetInnerHTML', () => {
    it('string', () => {
      const App = () => {
        return <div dangerouslySetInnerHTML={{ __html: '<p>Hello</p>' }} />
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div><p>Hello</p></div>')
    })
  })

  describe('Event', () => {
    it('bubbling phase', async () => {
      const clicked: string[] = []
      const App = () => {
        return (
          <div
            onClick={() => {
              clicked.push('div')
            }}
          >
            <button
              onClick={() => {
                clicked.push('button')
              }}
            >
              Click
            </button>
          </div>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div><button>Click</button></div>')
      root.querySelector('button')?.click()
      expect(clicked).toEqual(['button', 'div'])
    })

    it('ev.stopPropagation()', async () => {
      const clicked: string[] = []
      const App = () => {
        return (
          <div
            onClick={() => {
              clicked.push('div')
            }}
          >
            <button
              onClick={(ev) => {
                ev.stopPropagation()
                clicked.push('button')
              }}
            >
              Click
            </button>
          </div>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div><button>Click</button></div>')
      root.querySelector('button')?.click()
      expect(clicked).toEqual(['button'])
    })

    it('capture phase', async () => {
      const clicked: string[] = []
      const App = () => {
        return (
          <div
            onClickCapture={(ev) => {
              ev.stopPropagation()
              clicked.push('div')
            }}
          >
            <button
              onClickCapture={() => {
                clicked.push('button')
              }}
            >
              Click
            </button>
          </div>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div><button>Click</button></div>')
      root.querySelector('button')?.click()
      expect(clicked).toEqual(['div'])
    })

    it('remove capture phase event', async () => {
      const clicked: string[] = []
      const App = () => {
        const [canceled, setCanceled] = useState(false)
        return (
          <div
            {...(canceled
              ? {}
              : {
                  onClickCapture: () => {
                    clicked.push('div')
                  },
                })}
          >
            <button
              onClickCapture={() => {
                setCanceled(true)
                clicked.push('button')
              }}
            >
              Click
            </button>
          </div>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div><button>Click</button></div>')
      root.querySelector('button')?.click()
      expect(clicked).toEqual(['div', 'button'])
      await Promise.resolve()
      root.querySelector('button')?.click()
      expect(clicked).toEqual(['div', 'button', 'button'])
    })

    it('onGotPointerCapture', async () => {
      const App = () => {
        return <div onGotPointerCapture={() => {}}></div>
      }
      const addEventListenerSpy = vi.spyOn(dom.window.Node.prototype, 'addEventListener')
      render(<App />, root)
      expect(addEventListenerSpy).toHaveBeenCalledOnce()
      expect(addEventListenerSpy).toHaveBeenCalledWith(
        'gotpointercapture',
        expect.any(Function),
        false
      )
    })

    it('onGotPointerCaptureCapture', async () => {
      const App = () => {
        return <div onGotPointerCaptureCapture={() => {}}></div>
      }
      const addEventListenerSpy = vi.spyOn(dom.window.Node.prototype, 'addEventListener')
      render(<App />, root)
      expect(addEventListenerSpy).toHaveBeenCalledOnce()
      expect(addEventListenerSpy).toHaveBeenCalledWith(
        'gotpointercapture',
        expect.any(Function),
        true
      )
    })

    it('undefined', async () => {
      const App = () => {
        return <div onClick={undefined}></div>
      }
      const addEventListenerSpy = vi.spyOn(dom.window.Node.prototype, 'addEventListener')
      render(<App />, root)
      expect(addEventListenerSpy).not.toHaveBeenCalled()
    })

    it('invalid event handler value', async () => {
      const App = () => {
        return <div onClick={1 as unknown as () => void}></div>
      }
      expect(() => render(<App />, root)).toThrow()
    })
  })

  it('simple Counter', async () => {
    const Counter = () => {
      const [count, setCount] = useState(0)
      return (
        <div>
          <p>Count: {count}</p>
          <button onClick={() => setCount(count + 1)}>+</button>
        </div>
      )
    }
    const app = <Counter />
    render(app, root)
    expect(root.innerHTML).toBe('<div><p>Count: 0</p><button>+</button></div>')
    const button = root.querySelector('button') as HTMLButtonElement
    button.click()
    await Promise.resolve()
    expect(root.innerHTML).toBe('<div><p>Count: 1</p><button>+</button></div>')
  })

  it('multiple useState()', async () => {
    let called = 0
    const Counter = () => {
      const [countA, setCountA] = useState(0)
      const [countB, setCountB] = useState(0)
      called++
      return (
        <div>
          <p>A: {countA}</p>
          <button onClick={() => setCountA(countA + 1)}>+</button>
          <p>B: {countB}</p>
          <button onClick={() => setCountB(countB + 1)}>+</button>
        </div>
      )
    }
    const app = <Counter />
    render(app, root)
    expect(root.innerHTML).toBe(
      '<div><p>A: 0</p><button>+</button><p>B: 0</p><button>+</button></div>'
    )
    expect(called).toBe(1)
    const [buttonA, buttonB] = root.querySelectorAll('button')
    for (let i = 0; i < 3; i++) {
      buttonA.click()
      await Promise.resolve()
    }
    for (let i = 0; i < 4; i++) {
      buttonB.click()
      await Promise.resolve()
    }
    expect(root.innerHTML).toBe(
      '<div><p>A: 3</p><button>+</button><p>B: 4</p><button>+</button></div>'
    )
    expect(called).toBe(8)
  })

  it('multiple update state calls at once in onClick attributes', async () => {
    let called = 0
    const Counter = () => {
      const [countA, setCountA] = useState(0)
      const [countB, setCountB] = useState(0)
      called++
      return (
        <div>
          <button
            onClick={() => {
              setCountA(countA + 1)
              setCountB(countB + 2)
            }}
          >
            +
          </button>
          {countA} {countB}
        </div>
      )
    }
    const app = <Counter />
    render(app, root)
    expect(root.innerHTML).toBe('<div><button>+</button>0 0</div>')
    expect(called).toBe(1)
    root.querySelector('button')?.click()
    expect(called).toBe(1)
    await Promise.resolve()
    expect(called).toBe(2)
  })

  it('multiple update state calls at once in dom events', async () => {
    let called = 0
    const Counter = () => {
      const [countA, setCountA] = useState(0)
      const [countB, setCountB] = useState(0)
      const buttonRef = useRef<HTMLButtonElement>(null)
      called++

      useEffect(() => {
        buttonRef.current?.addEventListener('click', () => {
          setCountA(countA + 1)
          setCountB(countB + 2)
        })
      }, [])

      return (
        <div>
          <button ref={buttonRef}>+</button>
          {countA} {countB}
        </div>
      )
    }
    const app = <Counter />
    render(app, root)
    expect(root.innerHTML).toBe('<div><button>+</button>0 0</div>')
    expect(called).toBe(1)
    await new Promise((resolve) => setTimeout(resolve))
    root.querySelector('button')?.click()
    expect(called).toBe(1)
    await Promise.resolve()
    expect(called).toBe(2)
  })

  it('nested useState()', async () => {
    const ChildCounter = () => {
      const [count, setCount] = useState(0)
      return (
        <div>
          <p>Child Count: {count}</p>
          <button onClick={() => setCount(count + 1)}>+</button>
        </div>
      )
    }
    const Counter = () => {
      const [count, setCount] = useState(0)
      return (
        <div>
          <p>Count: {count}</p>
          <button onClick={() => setCount(count + 1)}>+</button>
          <ChildCounter />
        </div>
      )
    }
    const app = <Counter />
    render(app, root)
    expect(root.innerHTML).toBe(
      '<div><p>Count: 0</p><button>+</button><div><p>Child Count: 0</p><button>+</button></div></div>'
    )
    const [button, childButton] = root.querySelectorAll('button')
    for (let i = 0; i < 3; i++) {
      childButton.click()
      await Promise.resolve()
    }
    for (let i = 0; i < 2; i++) {
      button.click()
      await Promise.resolve()
    }
    for (let i = 0; i < 3; i++) {
      childButton.click()
      await Promise.resolve()
    }
    for (let i = 0; i < 3; i++) {
      button.click()
      await Promise.resolve()
    }
    expect(root.innerHTML).toBe(
      '<div><p>Count: 5</p><button>+</button><div><p>Child Count: 6</p><button>+</button></div></div>'
    )
  })

  it('nested useState() with children', async () => {
    const ChildCounter = () => {
      const [count, setCount] = useState(0)
      return (
        <div>
          <p>Child Count: {count}</p>
          <button onClick={() => setCount(count + 1)}>+</button>
        </div>
      )
    }
    const Counter = ({ children }: { children: Child }) => {
      const [count, setCount] = useState(0)
      return (
        <div>
          <p>Count: {count}</p>
          <button onClick={() => setCount(count + 1)}>+</button>
          {children}
        </div>
      )
    }
    const app = (
      <Counter>
        <ChildCounter />
      </Counter>
    )
    render(app, root)
    expect(root.innerHTML).toBe(
      '<div><p>Count: 0</p><button>+</button><div><p>Child Count: 0</p><button>+</button></div></div>'
    )
    const [button, childButton] = root.querySelectorAll('button')
    for (let i = 0; i < 3; i++) {
      childButton.click()
      await Promise.resolve()
    }
    for (let i = 0; i < 2; i++) {
      button.click()
      await Promise.resolve()
    }
    for (let i = 0; i < 3; i++) {
      childButton.click()
      await Promise.resolve()
    }
    for (let i = 0; i < 3; i++) {
      button.click()
      await Promise.resolve()
    }
    expect(root.innerHTML).toBe(
      '<div><p>Count: 5</p><button>+</button><div><p>Child Count: 6</p><button>+</button></div></div>'
    )
  })

  it('consecutive fragment', async () => {
    const ComponentA = () => {
      const [count, setCount] = useState(0)
      return (
        <>
          <div>A: {count}</div>
          <button id='a-button' onClick={() => setCount(count + 1)}>
            A: +
          </button>
        </>
      )
    }
    const App = () => {
      const [count, setCount] = useState(0)
      return (
        <>
          <ComponentA />
          <div>B: {count}</div>
          <button id='b-button' onClick={() => setCount(count + 1)}>
            B: +
          </button>
        </>
      )
    }
    render(<App />, root)
    expect(root.innerHTML).toBe(
      '<div>A: 0</div><button id="a-button">A: +</button><div>B: 0</div><button id="b-button">B: +</button>'
    )
    root.querySelector<HTMLButtonElement>('#b-button')?.click()
    await Promise.resolve()
    expect(root.innerHTML).toBe(
      '<div>A: 0</div><button id="a-button">A: +</button><div>B: 1</div><button id="b-button">B: +</button>'
    )
    root.querySelector<HTMLButtonElement>('#a-button')?.click()
    await Promise.resolve()
    expect(root.innerHTML).toBe(
      '<div>A: 1</div><button id="a-button">A: +</button><div>B: 1</div><button id="b-button">B: +</button>'
    )
  })

  it('switch child component', async () => {
    const Even = () => <p>Even</p>
    const Odd = () => <div>Odd</div>
    const Counter = () => {
      const [count, setCount] = useState(0)
      return (
        <div>
          {count % 2 === 0 ? <Even /> : <Odd />}
          <button onClick={() => setCount(count + 1)}>+</button>
        </div>
      )
    }
    const app = <Counter />
    render(app, root)
    expect(root.innerHTML).toBe('<div><p>Even</p><button>+</button></div>')
    const button = root.querySelector('button') as HTMLButtonElement
    button.click()
    await Promise.resolve()
    expect(root.innerHTML).toBe('<div><div>Odd</div><button>+</button></div>')
    button.click()
    await Promise.resolve()
    expect(root.innerHTML).toBe('<div><p>Even</p><button>+</button></div>')
  })

  it('add/remove/swap item', async () => {
    const TodoApp = () => {
      const [todos, setTodos] = useState(['a', 'b', 'c'])
      return (
        <div>
          {todos.map((todo) => (
            <div key={todo}>{todo}</div>
          ))}
          <button onClick={() => setTodos([...todos, 'd'])}>add</button>
          <button onClick={() => setTodos(todos.slice(0, -1))}>remove</button>
          <button onClick={() => setTodos([todos[0], todos[2], todos[1], todos[3] || ''])}>
            swap
          </button>
        </div>
      )
    }
    const app = <TodoApp />
    render(app, root)
    expect(root.innerHTML).toBe(
      '<div><div>a</div><div>b</div><div>c</div><button>add</button><button>remove</button><button>swap</button></div>'
    )
    const [addButton] = root.querySelectorAll('button')
    addButton.click()
    await Promise.resolve()
    expect(root.innerHTML).toBe(
      '<div><div>a</div><div>b</div><div>c</div><div>d</div><button>add</button><button>remove</button><button>swap</button></div>'
    )
    const [, , swapButton] = root.querySelectorAll('button')
    swapButton.click()
    await Promise.resolve()
    expect(root.innerHTML).toBe(
      '<div><div>a</div><div>c</div><div>b</div><div>d</div><button>add</button><button>remove</button><button>swap</button></div>'
    )
    const [, removeButton] = root.querySelectorAll('button')
    removeButton.click()
    await Promise.resolve()
    expect(root.innerHTML).toBe(
      '<div><div>a</div><div>c</div><div>b</div><button>add</button><button>remove</button><button>swap</button></div>'
    )
  })

  it('swap deferent type of child component', async () => {
    const Even = () => <p>Even</p>
    const Odd = () => <div>Odd</div>
    const Counter = () => {
      const [count, setCount] = useState(0)
      return (
        <div>
          {count % 2 === 0 ? (
            <>
              <Even />
              <Odd />
            </>
          ) : (
            <>
              <Odd />
              <Even />
            </>
          )}
          <button onClick={() => setCount(count + 1)}>+</button>
        </div>
      )
    }
    const app = <Counter />
    render(app, root)
    expect(root.innerHTML).toBe('<div><p>Even</p><div>Odd</div><button>+</button></div>')
    const button = root.querySelector('button') as HTMLButtonElement

    const createElementSpy = vi.spyOn(dom.window.document, 'createElement')

    button.click()
    await Promise.resolve()
    expect(root.innerHTML).toBe('<div><div>Odd</div><p>Even</p><button>+</button></div>')
    button.click()
    await Promise.resolve()
    expect(root.innerHTML).toBe('<div><p>Even</p><div>Odd</div><button>+</button></div>')

    expect(createElementSpy).not.toHaveBeenCalled()
  })

  it('useState for unnamed function', async () => {
    const Input = ({ label, onInput }: { label: string; onInput: (value: string) => void }) => {
      return (
        <div>
          <label>{label}</label>
          <input
            onInput={(e: InputEvent) => onInput((e.target as HTMLInputElement)?.value || '')}
          />
        </div>
      )
    }
    const Form = () => {
      const [values, setValues] = useState<{ [key: string]: string }>({})
      return (
        <form>
          <Input label='Name' onInput={(value) => setValues({ ...values, name: value })} />
          <Input label='Email' onInput={(value) => setValues({ ...values, email: value })} />
          <span>{JSON.stringify(values)}</span>
        </form>
      )
    }
    const app = <Form />
    render(app, root)
    expect(root.innerHTML).toBe(
      '<form><div><label>Name</label><input></div><div><label>Email</label><input></div><span>{}</span></form>'
    )
    const [nameInput] = root.querySelectorAll('input')
    nameInput.value = 'John'
    nameInput.dispatchEvent(new dom.window.Event('input'))
    await Promise.resolve()
    expect(root.innerHTML).toBe(
      '<form><div><label>Name</label><input></div><div><label>Email</label><input></div><span>{"name":"John"}</span></form>'
    )
    const [, emailInput] = root.querySelectorAll('input')
    emailInput.value = 'john@example.com'
    emailInput.dispatchEvent(new dom.window.Event('input'))
    await Promise.resolve()
    expect(root.innerHTML).toBe(
      '<form><div><label>Name</label><input></div><div><label>Email</label><input></div><span>{"name":"John","email":"john@example.com"}</span></form>'
    )
  })

  it('useState for grand child function', async () => {
    const GrandChild = () => {
      const [count, setCount] = useState(0)
      return (
        <>
          {count === 0 ? <p>Zero</p> : <span>Not Zero</span>}
          <button onClick={() => setCount(count + 1)}>+</button>
        </>
      )
    }
    const Child = () => {
      return <GrandChild />
    }
    const App = () => {
      const [show, setShow] = useState(false)
      return (
        <div>
          {show && <Child />}
          <button onClick={() => setShow(!show)}>toggle</button>
        </div>
      )
    }
    render(<App />, root)
    expect(root.innerHTML).toBe('<div><button>toggle</button></div>')
    root.querySelector('button')?.click()
    await Promise.resolve()
    expect(root.innerHTML).toBe('<div><p>Zero</p><button>+</button><button>toggle</button></div>')
    root.querySelector('button')?.click()
    await Promise.resolve()
    expect(root.innerHTML).toBe(
      '<div><span>Not Zero</span><button>+</button><button>toggle</button></div>'
    )
  })

  describe('className', () => {
    it('should convert to class attribute for intrinsic elements', () => {
      const App = <h1 className='h1'>Hello</h1>
      render(App, root)
      expect(root.innerHTML).toBe('<h1 class="h1">Hello</h1>')
    })

    it('should convert to class attribute for custom elements', () => {
      const App = <custom-element className='h1'>Hello</custom-element>
      render(App, root)
      expect(root.innerHTML).toBe('<custom-element class="h1">Hello</custom-element>')
    })

    it('should not convert to class attribute for custom components', () => {
      const App: FC<{ className: string }> = ({ className }) => (
        <div data-class-name={className}>Hello</div>
      )
      render(<App className='h1' />, root)
      expect(root.innerHTML).toBe('<div data-class-name="h1">Hello</div>')
    })
  })

  describe('memo', () => {
    it('simple', async () => {
      let renderCount = 0
      const Counter = ({ count }: { count: number }) => {
        renderCount++
        return (
          <div>
            <p>Count: {count}</p>
          </div>
        )
      }
      const MemoCounter = memo(Counter)
      const App = () => {
        const [count, setCount] = useState(0)
        return (
          <div>
            <MemoCounter count={Math.min(count, 1)} />
            <button onClick={() => setCount(count + 1)}>+</button>
          </div>
        )
      }
      const app = <App />
      render(app, root)
      expect(root.innerHTML).toBe('<div><div><p>Count: 0</p></div><button>+</button></div>')
      expect(renderCount).toBe(1)
      root.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><div><p>Count: 1</p></div><button>+</button></div>')
      expect(renderCount).toBe(2)
      root.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><div><p>Count: 1</p></div><button>+</button></div>')
      expect(renderCount).toBe(2)
    })

    it('useState', async () => {
      const Child = vi.fn(({ count }: { count: number }) => {
        const [count2, setCount2] = useState(0)
        return (
          <>
            <div>
              {count} : {count2}
            </div>
            <button id='child-button' onClick={() => setCount2(count2 + 1)}>
              Child +
            </button>
          </>
        )
      })
      const MemoChild = memo(Child)
      const App = () => {
        const [count, setCount] = useState(0)
        return (
          <>
            <button id='app-button' onClick={() => setCount(count + 1)}>
              App +
            </button>
            <MemoChild count={Math.floor(count / 2)} />
          </>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe(
        '<button id="app-button">App +</button><div>0 : 0</div><button id="child-button">Child +</button>'
      )
      root.querySelector<HTMLButtonElement>('button#app-button')?.click()
      await Promise.resolve()
      expect(Child).toBeCalledTimes(1)
      expect(root.innerHTML).toBe(
        '<button id="app-button">App +</button><div>0 : 0</div><button id="child-button">Child +</button>'
      )
      root.querySelector<HTMLButtonElement>('button#app-button')?.click()
      await Promise.resolve()
      expect(Child).toBeCalledTimes(2)
      expect(root.innerHTML).toBe(
        '<button id="app-button">App +</button><div>1 : 0</div><button id="child-button">Child +</button>'
      )
      root.querySelector<HTMLButtonElement>('button#child-button')?.click()
      await Promise.resolve()
      expect(Child).toBeCalledTimes(3)
      expect(root.innerHTML).toBe(
        '<button id="app-button">App +</button><div>1 : 1</div><button id="child-button">Child +</button>'
      )
    })

    // The react compiler generates code like the following for memoization.
    it('react compiler', async () => {
      let renderCount = 0
      const Counter = ({ count }: { count: number }) => {
        renderCount++
        return (
          <div>
            <p>Count: {count}</p>
          </div>
        )
      }

      const App = () => {
        const [cache] = useState<unknown[]>(() => [])
        const [count, setCount] = useState(0)
        const countForDisplay = Math.floor(count / 2)

        let localCounter
        if (cache[0] !== countForDisplay) {
          localCounter = <Counter count={countForDisplay} />
          cache[0] = countForDisplay
          cache[1] = localCounter
        } else {
          localCounter = cache[1]
        }

        return (
          <div>
            {localCounter}
            <button onClick={() => setCount(count + 1)}>+</button>
          </div>
        )
      }
      const app = <App />
      render(app, root)
      expect(root.innerHTML).toBe('<div><div><p>Count: 0</p></div><button>+</button></div>')
      expect(renderCount).toBe(1)
      root.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><div><p>Count: 0</p></div><button>+</button></div>')
      expect(renderCount).toBe(1)
      root.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><div><p>Count: 1</p></div><button>+</button></div>')
      expect(renderCount).toBe(2)
    })

    it('should not return memoized result when context is not changed', async () => {
      const Context = createContext<[number, (arg: number | ((value: number) => number)) => void]>([
        0,
        () => {},
      ])
      const Container: FC<{ children: Child }> = ({ children }) => {
        const [count, setCount] = useState(0)
        return <Context.Provider value={[count, setCount]}>{children}</Context.Provider>
      }
      const Content = () => {
        const [count, setCount] = useContext(Context)
        return (
          <>
            <span>{count}</span>
            <button onClick={() => setCount((c) => c + 1)}>+</button>
          </>
        )
      }
      const app = (
        <Container>
          <Content />
        </Container>
      )
      render(app, root)
      expect(root.innerHTML).toBe('<span>0</span><button>+</button>')
      root.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<span>1</span><button>+</button>')
    })
  })

  describe('useRef', async () => {
    it('simple', async () => {
      const Input = ({ label, ref }: { label: string; ref: RefObject<HTMLInputElement> }) => {
        return (
          <div>
            <label>{label}</label>
            <input ref={ref} />
          </div>
        )
      }
      const Form = () => {
        const [values, setValues] = useState<{ [key: string]: string }>({})
        const nameRef = useRef<HTMLInputElement>(null)
        const emailRef = useRef<HTMLInputElement>(null)
        return (
          <form>
            <Input label='Name' ref={nameRef} />
            <Input label='Email' ref={emailRef} />
            <button
              onClick={(ev: Event) => {
                ev.preventDefault()
                setValues({
                  name: nameRef.current?.value || '',
                  email: emailRef.current?.value || '',
                })
              }}
            >
              serialize
            </button>
            <span>{JSON.stringify(values)}</span>
          </form>
        )
      }
      const app = <Form />
      render(app, root)
      expect(root.innerHTML).toBe(
        '<form><div><label>Name</label><input></div><div><label>Email</label><input></div><button>serialize</button><span>{}</span></form>'
      )
      const [nameInput, emailInput] = root.querySelectorAll('input')
      nameInput.value = 'John'
      emailInput.value = 'john@example.com'
      const [button] = root.querySelectorAll('button')
      button.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe(
        '<form><div><label>Name</label><input></div><div><label>Email</label><input></div><button>serialize</button><span>{"name":"John","email":"john@example.com"}</span></form>'
      )
    })

    it('update current', async () => {
      const App = () => {
        const [, setState] = useState(0)
        const ref = useRef<boolean>(false)
        return (
          <>
            <button
              onClick={() => {
                setState((c) => c + 1)
                ref.current = true
              }}
            >
              update
            </button>
            <span>{String(ref.current)}</span>
          </>
        )
      }
      const app = <App />
      render(app, root)
      expect(root.innerHTML).toBe('<button>update</button><span>false</span>')
      root.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<button>update</button><span>true</span>')
    })
  })

  describe('useEffect', () => {
    it('simple', async () => {
      const Counter = () => {
        const [count, setCount] = useState(0)
        useEffect(() => {
          setCount(count + 1)
        }, [])
        return <div>{count}</div>
      }
      const app = <Counter />
      render(app, root)
      await new Promise((resolve) => setTimeout(resolve))
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div>1</div>')
    })

    it('multiple', async () => {
      const Counter = () => {
        const [count, setCount] = useState(0)
        useEffect(() => {
          setCount((c) => c + 1)
        }, [])
        useEffect(() => {
          setCount((c) => c + 1)
        }, [])
        return <div>{count}</div>
      }
      const app = <Counter />
      render(app, root)
      await new Promise((resolve) => setTimeout(resolve))
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div>2</div>')
    })

    it('cleanup', async () => {
      const Child = ({ parent }: { parent: RefObject<HTMLElement> }) => {
        useEffect(() => {
          return () => {
            parent.current?.setAttribute('data-cleanup', 'true')
          }
        }, [])
        return <div>Child</div>
      }
      const Parent = () => {
        const [show, setShow] = useState(true)
        const ref = useRef<HTMLElement>(null)
        return (
          <div ref={ref}>
            {show && <Child parent={ref} />}
            <button onClick={() => setShow(false)}>hide</button>
          </div>
        )
      }
      const app = <Parent />
      render(app, root)
      expect(root.innerHTML).toBe('<div><div>Child</div><button>hide</button></div>')
      await new Promise((resolve) => setTimeout(resolve))
      const [button] = root.querySelectorAll('button')
      button.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div data-cleanup="true"><button>hide</button></div>')
    })

    it('cleanup for deps', async () => {
      let effectCount = 0
      let cleanupCount = 0

      const App = () => {
        const [count, setCount] = useState(0)
        const [count2, setCount2] = useState(0)
        useEffect(() => {
          effectCount++
          return () => {
            cleanupCount++
          }
        }, [count])
        return (
          <div>
            <p>{count}</p>
            <p>{count2}</p>
            <button onClick={() => setCount(count + 1)}>+</button>
            <button onClick={() => setCount2(count2 + 1)}>+</button>
          </div>
        )
      }
      const app = <App />
      render(app, root)
      await new Promise((resolve) => setTimeout(resolve))
      expect(effectCount).toBe(1)
      expect(cleanupCount).toBe(0)
      root.querySelectorAll('button')[0].click() // count++
      await Promise.resolve()
      await new Promise((resolve) => setTimeout(resolve))
      expect(effectCount).toBe(2)
      expect(cleanupCount).toBe(1)
      root.querySelectorAll('button')[1].click() // count2++
      await Promise.resolve()
      expect(effectCount).toBe(2)
      expect(cleanupCount).toBe(1)
    })
  })

  describe('useLayoutEffect', () => {
    it('simple', async () => {
      const Counter = () => {
        const [count, setCount] = useState(0)
        useLayoutEffect(() => {
          setCount(count + 1)
        }, [])
        return <div>{count}</div>
      }
      const app = <Counter />
      render(app, root)
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div>1</div>')
    })

    it('multiple', async () => {
      const Counter = () => {
        const [count, setCount] = useState(0)
        useLayoutEffect(() => {
          setCount((c) => c + 1)
        }, [])
        useLayoutEffect(() => {
          setCount((c) => c + 1)
        }, [])
        return <div>{count}</div>
      }
      const app = <Counter />
      render(app, root)
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div>2</div>')
    })

    it('cleanup', async () => {
      const Child = ({ parent }: { parent: RefObject<HTMLElement> }) => {
        useLayoutEffect(() => {
          return () => {
            parent.current?.setAttribute('data-cleanup', 'true')
          }
        }, [])
        return <div>Child</div>
      }
      const Parent = () => {
        const [show, setShow] = useState(true)
        const ref = useRef<HTMLElement>(null)
        return (
          <div ref={ref}>
            {show && <Child parent={ref} />}
            <button onClick={() => setShow(false)}>hide</button>
          </div>
        )
      }
      const app = <Parent />
      render(app, root)
      expect(root.innerHTML).toBe('<div><div>Child</div><button>hide</button></div>')
      const [button] = root.querySelectorAll('button')
      button.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div data-cleanup="true"><button>hide</button></div>')
    })

    it('cleanup for deps', async () => {
      let effectCount = 0
      let cleanupCount = 0

      const App = () => {
        const [count, setCount] = useState(0)
        const [count2, setCount2] = useState(0)
        useLayoutEffect(() => {
          effectCount++
          return () => {
            cleanupCount++
          }
        }, [count])
        return (
          <div>
            <p>{count}</p>
            <p>{count2}</p>
            <button onClick={() => setCount(count + 1)}>+</button>
            <button onClick={() => setCount2(count2 + 1)}>+</button>
          </div>
        )
      }
      const app = <App />
      render(app, root)
      expect(effectCount).toBe(1)
      expect(cleanupCount).toBe(0)
      root.querySelectorAll('button')[0].click() // count++
      await Promise.resolve()
      expect(effectCount).toBe(2)
      expect(cleanupCount).toBe(1)
      root.querySelectorAll('button')[1].click() // count2++
      await Promise.resolve()
      expect(effectCount).toBe(2)
      expect(cleanupCount).toBe(1)
    })
  })

  describe('useInsertionEffect', () => {
    it('simple', async () => {
      const Counter = () => {
        const [count, setCount] = useState(0)
        useInsertionEffect(() => {
          setCount(count + 1)
        }, [])
        return <div>{count}</div>
      }
      const app = <Counter />
      render(app, root)
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div>1</div>')
    })

    it('multiple', async () => {
      const Counter = () => {
        const [count, setCount] = useState(0)
        useInsertionEffect(() => {
          setCount((c) => c + 1)
        }, [])
        useInsertionEffect(() => {
          setCount((c) => c + 1)
        }, [])
        return <div>{count}</div>
      }
      const app = <Counter />
      render(app, root)
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div>2</div>')
    })

    it('with useLayoutEffect', async () => {
      const Counter = () => {
        const [data, setData] = useState<string[]>([])
        useLayoutEffect(() => {
          setData((d) => [...d, 'useLayoutEffect'])
        }, [])
        useInsertionEffect(() => {
          setData((d) => [...d, 'useInsertionEffect'])
        }, [])
        return <div>{data.join(',')}</div>
      }
      const app = <Counter />
      render(app, root)
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div>useInsertionEffect,useLayoutEffect</div>')
    })

    it('cleanup', async () => {
      const Child = ({ parent }: { parent: RefObject<HTMLElement> }) => {
        useInsertionEffect(() => {
          return () => {
            parent.current?.setAttribute('data-cleanup', 'true')
          }
        }, [])
        return <div>Child</div>
      }
      const Parent = () => {
        const [show, setShow] = useState(true)
        const ref = useRef<HTMLElement>(null)
        return (
          <div ref={ref}>
            {show && <Child parent={ref} />}
            <button onClick={() => setShow(false)}>hide</button>
          </div>
        )
      }
      const app = <Parent />
      render(app, root)
      expect(root.innerHTML).toBe('<div><div>Child</div><button>hide</button></div>')
      const [button] = root.querySelectorAll('button')
      button.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div data-cleanup="true"><button>hide</button></div>')
    })

    it('cleanup for deps', async () => {
      let effectCount = 0
      let cleanupCount = 0

      const App = () => {
        const [count, setCount] = useState(0)
        const [count2, setCount2] = useState(0)
        useInsertionEffect(() => {
          effectCount++
          return () => {
            cleanupCount++
          }
        }, [count])
        return (
          <div>
            <p>{count}</p>
            <p>{count2}</p>
            <button onClick={() => setCount(count + 1)}>+</button>
            <button onClick={() => setCount2(count2 + 1)}>+</button>
          </div>
        )
      }
      const app = <App />
      render(app, root)
      expect(effectCount).toBe(1)
      expect(cleanupCount).toBe(0)
      root.querySelectorAll('button')[0].click() // count++
      await Promise.resolve()
      expect(effectCount).toBe(2)
      expect(cleanupCount).toBe(1)
      root.querySelectorAll('button')[1].click() // count2++
      await Promise.resolve()
      expect(effectCount).toBe(2)
      expect(cleanupCount).toBe(1)
    })
  })

  describe('useCallback', () => {
    it('deferent callbacks', async () => {
      const callbackSet = new Set<Function>()
      const Counter = () => {
        const [count, setCount] = useState(0)
        const increment = useCallback(() => {
          setCount(count + 1)
        }, [count])
        callbackSet.add(increment)
        return (
          <div>
            <p>{count}</p>
            <button onClick={increment}>+</button>
          </div>
        )
      }
      const app = <Counter />
      render(app, root)
      expect(root.innerHTML).toBe('<div><p>0</p><button>+</button></div>')
      const button = root.querySelector('button') as HTMLButtonElement
      button.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><p>1</p><button>+</button></div>')
      expect(callbackSet.size).toBe(2)
    })

    it('same callback', async () => {
      const callbackSet = new Set<Function>()
      const Counter = () => {
        const [count, setCount] = useState(0)
        const increment = useCallback(() => {
          setCount(count + 1)
        }, [count])
        callbackSet.add(increment)

        const [count2, setCount2] = useState(0)
        return (
          <div>
            <p>{count}</p>
            <button onClick={increment}>+</button>
            <p>{count2}</p>
            <button onClick={() => setCount2(count2 + 1)}>+</button>
          </div>
        )
      }
      const app = <Counter />
      render(app, root)
      expect(root.innerHTML).toBe('<div><p>0</p><button>+</button><p>0</p><button>+</button></div>')
      const [, button] = root.querySelectorAll('button')
      button.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><p>0</p><button>+</button><p>1</p><button>+</button></div>')
      expect(callbackSet.size).toBe(1)
    })

    it('deferent callbacks', async () => {
      const callbackSet = new Set<Function>()
      const Counter = () => {
        const [count, setCount] = useState(0)
        const double = useCallback((input: number): number => {
          return input * 2
        }, [])
        callbackSet.add(double)
        return (
          <div>
            <p>{double(count)}</p>
            <button onClick={() => setCount((c) => c + 1)}>+</button>
          </div>
        )
      }
      const app = <Counter />
      render(app, root)
      expect(root.innerHTML).toBe('<div><p>0</p><button>+</button></div>')
      const button = root.querySelector('button') as HTMLButtonElement
      button.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><p>2</p><button>+</button></div>')
      expect(callbackSet.size).toBe(1)
    })
  })

  describe('useMemo', () => {
    it('simple', async () => {
      let factoryCalled = 0
      const Counter = () => {
        const [count, setCount] = useState(0)
        const [count2, setCount2] = useState(0)
        const memo = useMemo(() => {
          factoryCalled++
          return count + 1
        }, [count])
        return (
          <div>
            <p>{count}</p>
            <p>{count2}</p>
            <p>{memo}</p>
            <button onClick={() => setCount(count + 1)}>+</button>
            <button onClick={() => setCount2(count2 + 1)}>+</button>
          </div>
        )
      }
      const app = <Counter />
      render(app, root)
      expect(root.innerHTML).toBe(
        '<div><p>0</p><p>0</p><p>1</p><button>+</button><button>+</button></div>'
      )
      expect(factoryCalled).toBe(1)
      root.querySelectorAll('button')[0].click()
      await Promise.resolve()
      expect(root.innerHTML).toBe(
        '<div><p>1</p><p>0</p><p>2</p><button>+</button><button>+</button></div>'
      )
      expect(factoryCalled).toBe(2)
      root.querySelectorAll('button')[1].click()
      await Promise.resolve()
      expect(root.innerHTML).toBe(
        '<div><p>1</p><p>1</p><p>2</p><button>+</button><button>+</button></div>'
      )
      expect(factoryCalled).toBe(2)
    })
  })

  describe('isValidElement', () => {
    it('valid', () => {
      expect(isValidElement(<div />)).toBe(true)
    })

    it('invalid', () => {
      expect(isValidElement({})).toBe(false)
    })
  })

  describe('createElement', () => {
    it('simple', async () => {
      const App = () => {
        const [count, setCount] = useState(0)
        return (
          <div>{createElement('p', { onClick: () => setCount(count + 1) }, String(count))}</div>
        )
      }
      const app = <App />
      render(app, root)
      expect(root.innerHTML).toBe('<div><p>0</p></div>')
      root.querySelector('p')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><p>1</p></div>')
    })

    it('title', async () => {
      const App = () => {
        return <div>{createElement('title', {}, 'Hello')}</div>
      }
      const app = <App />
      render(app, root)
      expect(document.head.innerHTML).toBe('<title>Hello</title>')
      expect(root.innerHTML).toBe('<div></div>')
    })
  })

  describe('dom-specific createElement', () => {
    it('simple', async () => {
      const App = () => {
        const [count, setCount] = useState(0)
        return <div>{createElementForDom('p', { onClick: () => setCount(count + 1) }, count)}</div>
      }
      const app = <App />
      render(app, root)
      expect(root.innerHTML).toBe('<div><p>0</p></div>')
      root.querySelector('p')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><p>1</p></div>')
    })

    it('title', async () => {
      const App = () => {
        return <div>{createElementForDom('title', {}, 'Hello')}</div>
      }
      const app = <App />
      render(app, root)
      expect(document.head.innerHTML).toBe('<title>Hello</title>')
      expect(root.innerHTML).toBe('<div></div>')
    })
  })

  describe('cloneElement', () => {
    it('simple', async () => {
      const App = () => {
        const [count, setCount] = useState(0)
        return <div>{cloneElement(<p>{count}</p>, { onClick: () => setCount(count + 1) })}</div>
      }
      const app = <App />
      render(app, root)
      expect(root.innerHTML).toBe('<div><p>0</p></div>')
      root.querySelector('p')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><p>1</p></div>')
    })
  })

  describe('dom-specific cloneElement', () => {
    it('simple', async () => {
      const App = () => {
        const [count, setCount] = useState(0)
        return (
          <div>{cloneElementForDom(<p>{count}</p>, { onClick: () => setCount(count + 1) })}</div>
        )
      }
      const app = <App />
      render(app, root)
      expect(root.innerHTML).toBe('<div><p>0</p></div>')
      root.querySelector('p')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><p>1</p></div>')
    })
  })

  describe('flushSync', () => {
    it('simple', async () => {
      const SubApp = ({ id }: { id: string }) => {
        const [count, setCount] = useState(0)
        return (
          <div id={id}>
            <p>{count}</p>
            <button onClick={() => setCount(count + 1)}>+</button>
          </div>
        )
      }
      const App = () => {
        return (
          <div>
            <SubApp id='a' />
            <SubApp id='b' />
          </div>
        )
      }
      const app = <App />
      render(app, root)
      expect(root.innerHTML).toBe(
        '<div><div id="a"><p>0</p><button>+</button></div><div id="b"><p>0</p><button>+</button></div></div>'
      )
      root.querySelector<HTMLButtonElement>('#b button')?.click()
      flushSync(() => {
        root.querySelector<HTMLButtonElement>('#a button')?.click()
      })
      expect(root.innerHTML).toBe(
        '<div><div id="a"><p>1</p><button>+</button></div><div id="b"><p>0</p><button>+</button></div></div>'
      )
      await Promise.resolve()
      expect(root.innerHTML).toBe(
        '<div><div id="a"><p>1</p><button>+</button></div><div id="b"><p>1</p><button>+</button></div></div>'
      )
    })
  })

  describe('createPortal', () => {
    it('simple', async () => {
      const App = () => {
        const [count, setCount] = useState(0)
        return (
          <div>
            <button onClick={() => setCount(count + 1)}>+</button>
            {count <= 1 && createPortal(<p>{count}</p>, document.body)}
          </div>
        )
      }
      const app = <App />
      render(app, root)
      expect(root.innerHTML).toBe('<div><button>+</button></div>')
      expect(document.body.innerHTML).toBe(
        '<div id="root"><div><button>+</button></div></div><p>0</p>'
      )
      document.body.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><button>+</button></div>')
      expect(document.body.innerHTML).toBe(
        '<div id="root"><div><button>+</button></div></div><p>1</p>'
      )
      document.body.querySelector('button')?.click()
      await Promise.resolve()
      expect(document.body.innerHTML).toBe('<div id="root"><div><button>+</button></div></div>')
    })

    it('update', async () => {
      const App = () => {
        const [count, setCount] = useState(0)
        return (
          <div>
            {createPortal(<p>{count}</p>, document.body)}
            <button onClick={() => setCount(count + 1)}>+</button>
            <div>
              <p>{count}</p>
            </div>
          </div>
        )
      }
      const app = <App />
      render(app, root)
      expect(root.innerHTML).toBe('<div><button>+</button><div><p>0</p></div></div>')
      expect(document.body.innerHTML).toBe(
        '<div id="root"><div><button>+</button><div><p>0</p></div></div></div><p>0</p>'
      )

      const createElementSpy = vi.spyOn(dom.window.document, 'createElement')

      document.body.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><button>+</button><div><p>1</p></div></div>')
      expect(document.body.innerHTML).toBe(
        '<div id="root"><div><button>+</button><div><p>1</p></div></div></div><p>1</p>'
      )
      document.body.querySelector('button')?.click()
      await Promise.resolve()
      expect(document.body.innerHTML).toBe(
        '<div id="root"><div><button>+</button><div><p>2</p></div></div></div><p>2</p>'
      )

      expect(createElementSpy).not.toHaveBeenCalled()
    })
  })

  describe('SVG', () => {
    it('simple', () => {
      const App = () => {
        return (
          <svg>
            <circle cx='50' cy='50' r='40' stroke='black' stroke-width='3' fill='red' />
          </svg>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe(
        '<svg><circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red"></circle></svg>'
      )
    })

    it('title element', () => {
      const App = () => {
        return (
          <>
            <title>Document Title</title>
            <svg>
              <title>SVG Title</title>
            </svg>
          </>
        )
      }
      render(<App />, root)
      expect(document.head.innerHTML).toBe('<title>Document Title</title>')
      expect(root.innerHTML).toBe('<svg><title>SVG Title</title></svg>')
      expect(document.querySelector('title')).toBeInstanceOf(dom.window.HTMLTitleElement)
      expect(document.querySelector('svg title')).toBeInstanceOf(dom.window.SVGTitleElement)
    })

    describe('attribute', () => {
      describe('camelCase', () => {
        test.each`
          key
          ${'attributeName'}
          ${'baseFrequency'}
          ${'calcMode'}
          ${'clipPathUnits'}
          ${'diffuseConstant'}
          ${'edgeMode'}
          ${'filterUnits'}
          ${'gradientTransform'}
          ${'gradientUnits'}
          ${'kernelMatrix'}
          ${'kernelUnitLength'}
          ${'keyPoints'}
          ${'keySplines'}
          ${'keyTimes'}
          ${'lengthAdjust'}
          ${'limitingConeAngle'}
          ${'markerHeight'}
          ${'markerUnits'}
          ${'markerWidth'}
          ${'maskContentUnits'}
          ${'maskUnits'}
          ${'numOctaves'}
          ${'pathLength'}
          ${'patternContentUnits'}
          ${'patternTransform'}
          ${'patternUnits'}
          ${'pointsAtX'}
          ${'pointsAtY'}
          ${'pointsAtZ'}
          ${'preserveAlpha'}
          ${'preserveAspectRatio'}
          ${'primitiveUnits'}
          ${'refX'}
          ${'refY'}
          ${'repeatCount'}
          ${'repeatDur'}
          ${'specularConstant'}
          ${'specularExponent'}
          ${'spreadMethod'}
          ${'startOffset'}
          ${'stdDeviation'}
          ${'stitchTiles'}
          ${'surfaceScale'}
          ${'crossorigin'}
          ${'systemLanguage'}
          ${'tableValues'}
          ${'targetX'}
          ${'targetY'}
          ${'textLength'}
          ${'viewBox'}
          ${'xChannelSelector'}
          ${'yChannelSelector'}
        `('$key', ({ key }) => {
          const App = () => {
            return (
              <svg>
                <g {...{ [key]: 'test' }} />
              </svg>
            )
          }
          render(<App />, root)
          expect(root.innerHTML).toBe(`<svg><g ${key}="test"></g></svg>`)
        })
      })

      describe('kebab-case', () => {
        test.each`
          key
          ${'alignmentBaseline'}
          ${'baselineShift'}
          ${'clipPath'}
          ${'clipRule'}
          ${'colorInterpolation'}
          ${'colorInterpolationFilters'}
          ${'dominantBaseline'}
          ${'fillOpacity'}
          ${'fillRule'}
          ${'floodColor'}
          ${'floodOpacity'}
          ${'fontFamily'}
          ${'fontSize'}
          ${'fontSizeAdjust'}
          ${'fontStretch'}
          ${'fontStyle'}
          ${'fontVariant'}
          ${'fontWeight'}
          ${'imageRendering'}
          ${'letterSpacing'}
          ${'lightingColor'}
          ${'markerEnd'}
          ${'markerMid'}
          ${'markerStart'}
          ${'overlinePosition'}
          ${'overlineThickness'}
          ${'paintOrder'}
          ${'pointerEvents'}
          ${'shapeRendering'}
          ${'stopColor'}
          ${'stopOpacity'}
          ${'strikethroughPosition'}
          ${'strikethroughThickness'}
          ${'strokeDasharray'}
          ${'strokeDashoffset'}
          ${'strokeLinecap'}
          ${'strokeLinejoin'}
          ${'strokeMiterlimit'}
          ${'strokeOpacity'}
          ${'strokeWidth'}
          ${'textAnchor'}
          ${'textDecoration'}
          ${'textRendering'}
          ${'transformOrigin'}
          ${'underlinePosition'}
          ${'underlineThickness'}
          ${'unicodeBidi'}
          ${'vectorEffect'}
          ${'wordSpacing'}
          ${'writingMode'}
        `('$key', ({ key }) => {
          const App = () => {
            return (
              <svg>
                <g {...{ [key]: 'test' }} />
              </svg>
            )
          }
          render(<App />, root)
          expect(root.innerHTML).toBe(
            `<svg><g ${key.replace(/([A-Z])/g, '-$1').toLowerCase()}="test"></g></svg>`
          )
        })
      })

      describe('data-*', () => {
        test.each`
          key
          ${'data-foo'}
          ${'data-foo-bar'}
          ${'data-fooBar'}
        `('$key', ({ key }) => {
          const App = () => {
            return (
              <svg>
                <g {...{ [key]: 'test' }} />
              </svg>
            )
          }
          render(<App />, root)
          expect(root.innerHTML).toBe(`<svg><g ${key}="test"></g></svg>`)
        })
      })
    })
  })

  describe('MathML', () => {
    it('simple', () => {
      const createElementSpy = vi.spyOn(dom.window.document, 'createElement')
      const createElementNSSpy = vi.spyOn(dom.window.document, 'createElementNS')

      const App = () => {
        return (
          <math>
            <mrow>
              <mn>1</mn>
            </mrow>
          </math>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<math><mrow><mn>1</mn></mrow></math>')

      expect(createElementSpy).not.toHaveBeenCalled()
      expect(createElementNSSpy).toHaveBeenCalledWith('http://www.w3.org/1998/Math/MathML', 'math')
      expect(createElementNSSpy).toHaveBeenCalledWith('http://www.w3.org/1998/Math/MathML', 'mrow')
    })
  })
})

describe('jsx', () => {
  it('exported as an alias of createElement', () => {
    expect(jsx).toBeDefined()
    expect(jsx('div', {}, 'Hello')).toBeInstanceOf(Object)
  })
})

describe('version', () => {
  it('should be defined with semantic versioning format', () => {
    expect(version).toMatch(/^\d+\.\d+\.\d+-hono-jsx$/)
  })
})

describe('default export', () => {
  ;[
    'version',
    'memo',
    'Fragment',
    'isValidElement',
    'createElement',
    'cloneElement',
    'ErrorBoundary',
    'createContext',
    'useContext',
    'useState',
    'useEffect',
    'useRef',
    'useCallback',
    'useReducer',
    'useDebugValue',
    'createRef',
    'forwardRef',
    'useImperativeHandle',
    'useSyncExternalStore',
    'use',
    'startTransition',
    'useTransition',
    'useDeferredValue',
    'startViewTransition',
    'useViewTransition',
    'useActionState',
    'useFormStatus',
    'useOptimistic',
    'useMemo',
    'useLayoutEffect',
    'Suspense',
    'Fragment',
    'flushSync',
    'createPortal',
    'StrictMode',
  ].forEach((key) => {
    it(key, () => {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      expect((DefaultExport as any)[key]).toBeDefined()
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/index.ts
```typescript
/**
 * @module
 * This module provides APIs for `hono/jsx/dom`.
 */

import { isValidElement, reactAPICompatVersion, shallowEqual } from '../base'
import type { Child, DOMAttributes, JSX, JSXNode, Props, FC, MemorableFC } from '../base'
import { Children } from '../children'
import { DOM_MEMO } from '../constants'
import { useContext } from '../context'
import {
  createRef,
  forwardRef,
  startTransition,
  startViewTransition,
  use,
  useCallback,
  useDebugValue,
  useDeferredValue,
  useEffect,
  useId,
  useImperativeHandle,
  useInsertionEffect,
  useLayoutEffect,
  useMemo,
  useReducer,
  useRef,
  useState,
  useSyncExternalStore,
  useTransition,
  useViewTransition,
} from '../hooks'
import { ErrorBoundary, Suspense } from './components'
import { createContext } from './context'
import { useActionState, useFormStatus, useOptimistic } from './hooks'
import { Fragment, jsx } from './jsx-runtime'
import { createPortal, flushSync } from './render'

export { render } from './render'

const createElement = (
  tag: string | ((props: Props) => JSXNode),
  props: Props | null,
  ...children: Child[]
): JSXNode => {
  const jsxProps: Props = props ? { ...props } : {}
  if (children.length) {
    jsxProps.children = children.length === 1 ? children[0] : children
  }

  let key = undefined
  if ('key' in jsxProps) {
    key = jsxProps.key
    delete jsxProps.key
  }
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  return jsx(tag, jsxProps, key) as any
}

const cloneElement = <T extends JSXNode | JSX.Element>(
  element: T,
  props: Props,
  ...children: Child[]
): T => {
  return jsx(
    (element as JSXNode).tag,
    {
      ...(element as JSXNode).props,
      ...props,
      children: children.length ? children : (element as JSXNode).props.children,
    },
    (element as JSXNode).key
  ) as T
}

const memo = <T>(
  component: FC<T>,
  propsAreEqual: (prevProps: Readonly<T>, nextProps: Readonly<T>) => boolean = shallowEqual
): FC<T> => {
  const wrapper = ((props: T) => component(props)) as MemorableFC<T>
  wrapper[DOM_MEMO] = propsAreEqual
  return wrapper as FC<T>
}

export {
  reactAPICompatVersion as version,
  createElement as jsx,
  useState,
  useEffect,
  useRef,
  useCallback,
  use,
  startTransition,
  useTransition,
  useDeferredValue,
  startViewTransition,
  useViewTransition,
  useMemo,
  useLayoutEffect,
  useInsertionEffect,
  useReducer,
  useId,
  useDebugValue,
  createRef,
  forwardRef,
  useImperativeHandle,
  useSyncExternalStore,
  useFormStatus,
  useActionState,
  useOptimistic,
  Suspense,
  ErrorBoundary,
  createContext,
  useContext,
  memo,
  isValidElement,
  createElement,
  cloneElement,
  Children,
  Fragment,
  Fragment as StrictMode,
  DOMAttributes,
  flushSync,
  createPortal,
}

export default {
  version: reactAPICompatVersion,
  useState,
  useEffect,
  useRef,
  useCallback,
  use,
  startTransition,
  useTransition,
  useDeferredValue,
  startViewTransition,
  useViewTransition,
  useMemo,
  useLayoutEffect,
  useInsertionEffect,
  useReducer,
  useId,
  useDebugValue,
  createRef,
  forwardRef,
  useImperativeHandle,
  useSyncExternalStore,
  useFormStatus,
  useActionState,
  useOptimistic,
  Suspense,
  ErrorBoundary,
  createContext,
  useContext,
  memo,
  isValidElement,
  createElement,
  cloneElement,
  Children,
  Fragment,
  StrictMode: Fragment,
  flushSync,
  createPortal,
}

export type { Context } from '../context'

export type * from '../types'

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/jsx-dev-runtime.ts
```typescript
/**
 * @module
 * This module provides the `hono/jsx/dom` dev runtime.
 */

import type { JSXNode, Props } from '../base'
import * as intrinsicElementTags from './intrinsic-element/components'

export const jsxDEV = (tag: string | Function, props: Props, key?: string): JSXNode => {
  if (typeof tag === 'string' && intrinsicElementTags[tag as keyof typeof intrinsicElementTags]) {
    tag = intrinsicElementTags[tag as keyof typeof intrinsicElementTags]
  }
  return {
    tag,
    type: tag,
    props,
    key,
    ref: props.ref,
  } as JSXNode
}

export const Fragment = (props: Record<string, unknown>): JSXNode => jsxDEV('', props, undefined)

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/jsx-runtime.ts
```typescript
/**
 * @module
 * This module provides the `hono/jsx/dom` runtime.
 */

export { jsxDEV as jsx, Fragment } from './jsx-dev-runtime'
export { jsxDEV as jsxs } from './jsx-dev-runtime'

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/render.ts
```typescript
import type { Child, FC, JSXNode, Props, MemorableFC } from '../base'
import { toArray } from '../children'
import {
  DOM_ERROR_HANDLER,
  DOM_INTERNAL_TAG,
  DOM_MEMO,
  DOM_RENDERER,
  DOM_STASH,
} from '../constants'
import type { Context as JSXContext } from '../context'
import { globalContexts as globalJSXContexts, useContext } from '../context'
import type { EffectData } from '../hooks'
import { STASH_EFFECT } from '../hooks'
import { normalizeIntrinsicElementKey, styleObjectForEach } from '../utils'
import { createContext } from './context' // import dom-specific versions

const HONO_PORTAL_ELEMENT = '_hp'

const eventAliasMap: Record<string, string> = {
  Change: 'Input',
  DoubleClick: 'DblClick',
} as const

const nameSpaceMap: Record<string, string> = {
  svg: '2000/svg',
  math: '1998/Math/MathML',
} as const

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type HasRenderToDom = FC<any> & { [DOM_RENDERER]: FC<any> }
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type ErrorHandler = (error: any, retry: () => void) => Child | undefined

type Container = HTMLElement | DocumentFragment
type LocalJSXContexts = [JSXContext<unknown>, unknown][] | undefined
type SupportedElement = HTMLElement | SVGElement | MathMLElement
export type PreserveNodeType =
  | 1 // preserve only self
  | 2 // preserve self and children

export type NodeObject = {
  pP: Props | undefined // previous props
  nN: Node | undefined // next node
  vC: Node[] // virtual dom children
  pC?: Node[] // previous virtual dom children
  vR: Node[] // virtual dom children to remove
  n?: string // namespace
  f?: boolean // force build
  s?: boolean // skip build and apply
  c: Container | undefined // container
  e: SupportedElement | Text | undefined // rendered element
  p?: PreserveNodeType // preserve HTMLElement if it will be unmounted
  a?: boolean // cancel apply() if true
  o?: NodeObject // original node
  [DOM_STASH]:
    | [
        number, // current hook index
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        any[][], // stash for hooks
        LocalJSXContexts, // context
        [Context, Function, NodeObject] // [context, error handler, node] for closest error boundary or suspense
      ]
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    | [number, any[][]]
} & JSXNode
type NodeString = {
  t: string // text content
  d: boolean // is dirty
  s?: boolean // skip build and apply
} & {
  e?: Text
  // like a NodeObject
  vC: undefined
  nN: undefined
  p?: true
  // from JSXNode
  key: undefined
  tag: undefined
}
export type Node = NodeString | NodeObject

export type PendingType =
  | 0 // no pending
  | 1 // global
  | 2 // hook
export type UpdateHook = (
  context: Context,
  node: Node,
  cb: (context: Context) => void
) => Promise<void>
export type Context =
  | [
      PendingType, // PendingType
      boolean, // got an error
      UpdateHook, // update hook
      boolean, // is in view transition
      boolean, // is in top level render
      [Context, Function, NodeObject][] //  [context, error handler, node] stack for this context
    ]
  | [PendingType, boolean, UpdateHook, boolean]
  | [PendingType, boolean, UpdateHook]
  | [PendingType, boolean]
  | [PendingType]
  | []

export const buildDataStack: [Context, Node][] = []

const refCleanupMap: WeakMap<Element, () => void> = new WeakMap()

let nameSpaceContext: JSXContext<string> | undefined = undefined
export const getNameSpaceContext = () => nameSpaceContext

const isNodeString = (node: Node): node is NodeString => 't' in (node as NodeString)

const eventCache: Record<string, [string, boolean]> = {
  // pre-define events that are used very frequently
  onClick: ['click', false],
}
const getEventSpec = (key: string): [string, boolean] | undefined => {
  if (!key.startsWith('on')) {
    return undefined
  }
  if (eventCache[key]) {
    return eventCache[key]
  }

  const match = key.match(/^on([A-Z][a-zA-Z]+?(?:PointerCapture)?)(Capture)?$/)
  if (match) {
    const [, eventName, capture] = match
    return (eventCache[key] = [(eventAliasMap[eventName] || eventName).toLowerCase(), !!capture])
  }
  return undefined
}

const toAttributeName = (element: SupportedElement, key: string): string =>
  nameSpaceContext &&
  element instanceof SVGElement &&
  /[A-Z]/.test(key) &&
  (key in element.style || // Presentation attributes are findable in style object. "clip-path", "font-size", "stroke-width", etc.
    key.match(/^(?:o|pai|str|u|ve)/)) // Other un-deprecated kebab-case attributes. "overline-position", "paint-order", "strikethrough-position", etc.
    ? key.replace(/([A-Z])/g, '-$1').toLowerCase()
    : key

const applyProps = (
  container: SupportedElement,
  attributes: Props,
  oldAttributes?: Props
): void => {
  attributes ||= {}
  for (let key in attributes) {
    const value = attributes[key]
    if (key !== 'children' && (!oldAttributes || oldAttributes[key] !== value)) {
      key = normalizeIntrinsicElementKey(key)
      const eventSpec = getEventSpec(key)
      if (eventSpec) {
        if (oldAttributes?.[key] !== value) {
          if (oldAttributes) {
            container.removeEventListener(eventSpec[0], oldAttributes[key], eventSpec[1])
          }
          if (value != null) {
            if (typeof value !== 'function') {
              throw new Error(`Event handler for "${key}" is not a function`)
            }
            container.addEventListener(eventSpec[0], value, eventSpec[1])
          }
        }
      } else if (key === 'dangerouslySetInnerHTML' && value) {
        container.innerHTML = value.__html
      } else if (key === 'ref') {
        let cleanup
        if (typeof value === 'function') {
          cleanup = value(container) || (() => value(null))
        } else if (value && 'current' in value) {
          value.current = container
          cleanup = () => (value.current = null)
        }
        refCleanupMap.set(container, cleanup)
      } else if (key === 'style') {
        const style = container.style
        if (typeof value === 'string') {
          style.cssText = value
        } else {
          style.cssText = ''
          if (value != null) {
            styleObjectForEach(value, style.setProperty.bind(style))
          }
        }
      } else {
        if (key === 'value') {
          const nodeName = container.nodeName
          if (nodeName === 'INPUT' || nodeName === 'TEXTAREA' || nodeName === 'SELECT') {
            ;(container as unknown as HTMLInputElement).value =
              value === null || value === undefined || value === false ? null : value

            if (nodeName === 'TEXTAREA') {
              container.textContent = value
              continue
            } else if (nodeName === 'SELECT') {
              if ((container as unknown as HTMLSelectElement).selectedIndex === -1) {
                ;(container as unknown as HTMLSelectElement).selectedIndex = 0
              }
              continue
            }
          }
        } else if (
          (key === 'checked' && container.nodeName === 'INPUT') ||
          (key === 'selected' && container.nodeName === 'OPTION')
        ) {
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          ;(container as any)[key] = value
        }

        const k = toAttributeName(container, key)

        if (value === null || value === undefined || value === false) {
          container.removeAttribute(k)
        } else if (value === true) {
          container.setAttribute(k, '')
        } else if (typeof value === 'string' || typeof value === 'number') {
          container.setAttribute(k, value as string)
        } else {
          container.setAttribute(k, value.toString())
        }
      }
    }
  }
  if (oldAttributes) {
    for (let key in oldAttributes) {
      const value = oldAttributes[key]
      if (key !== 'children' && !(key in attributes)) {
        key = normalizeIntrinsicElementKey(key)
        const eventSpec = getEventSpec(key)
        if (eventSpec) {
          container.removeEventListener(eventSpec[0], value, eventSpec[1])
        } else if (key === 'ref') {
          refCleanupMap.get(container)?.()
        } else {
          container.removeAttribute(toAttributeName(container, key))
        }
      }
    }
  }
}

const invokeTag = (context: Context, node: NodeObject): Child[] => {
  node[DOM_STASH][0] = 0
  buildDataStack.push([context, node])
  const func = (node.tag as HasRenderToDom)[DOM_RENDERER] || node.tag
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const props = (func as any).defaultProps
    ? {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        ...(func as any).defaultProps,
        ...node.props,
      }
    : node.props
  try {
    return [func.call(null, props)]
  } finally {
    buildDataStack.pop()
  }
}

const getNextChildren = (
  node: NodeObject,
  container: Container,
  nextChildren: Node[],
  childrenToRemove: Node[],
  callbacks: EffectData[]
): void => {
  if (node.vR?.length) {
    childrenToRemove.push(...node.vR)
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    delete (node as any).vR
  }
  if (typeof node.tag === 'function') {
    node[DOM_STASH][1][STASH_EFFECT]?.forEach((data: EffectData) => callbacks.push(data))
  }
  node.vC.forEach((child) => {
    if (isNodeString(child)) {
      nextChildren.push(child)
    } else {
      if (typeof child.tag === 'function' || child.tag === '') {
        child.c = container
        const currentNextChildrenIndex = nextChildren.length
        getNextChildren(child, container, nextChildren, childrenToRemove, callbacks)
        if (child.s) {
          for (let i = currentNextChildrenIndex; i < nextChildren.length; i++) {
            nextChildren[i].s = true
          }
          child.s = false
        }
      } else {
        nextChildren.push(child)
        if (child.vR?.length) {
          childrenToRemove.push(...child.vR)
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          delete (child as any).vR
        }
      }
    }
  })
}

const findInsertBefore = (node: Node | undefined): SupportedElement | Text | null => {
  for (; ; node = node.tag === HONO_PORTAL_ELEMENT || !node.vC || !node.pP ? node.nN : node.vC[0]) {
    if (!node) {
      return null
    }
    if (node.tag !== HONO_PORTAL_ELEMENT && node.e) {
      return node.e
    }
  }
}

const removeNode = (node: Node): void => {
  if (!isNodeString(node)) {
    node[DOM_STASH]?.[1][STASH_EFFECT]?.forEach((data: EffectData) => data[2]?.())

    refCleanupMap.get(node.e as Element)?.()
    if (node.p === 2) {
      node.vC?.forEach((n) => (n.p = 2))
    }
    node.vC?.forEach(removeNode)
  }
  if (!node.p) {
    node.e?.remove()
    delete node.e
  }
  if (typeof node.tag === 'function') {
    updateMap.delete(node)
    fallbackUpdateFnArrayMap.delete(node)
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    delete (node as any)[DOM_STASH][3] // delete explicitly for avoid circular reference
    node.a = true
  }
}

const apply = (node: NodeObject, container: Container, isNew: boolean): void => {
  node.c = container
  applyNodeObject(node, container, isNew)
}

const findChildNodeIndex = (
  childNodes: NodeListOf<ChildNode>,
  child: ChildNode | null | undefined
): number | undefined => {
  if (!child) {
    return
  }

  for (let i = 0, len = childNodes.length; i < len; i++) {
    if (childNodes[i] === child) {
      return i
    }
  }

  return
}

const cancelBuild: symbol = Symbol()
const applyNodeObject = (node: NodeObject, container: Container, isNew: boolean): void => {
  const next: Node[] = []
  const remove: Node[] = []
  const callbacks: EffectData[] = []
  getNextChildren(node, container, next, remove, callbacks)
  remove.forEach(removeNode)

  const childNodes = (isNew ? undefined : container.childNodes) as NodeListOf<ChildNode>
  let offset: number
  let insertBeforeNode: ChildNode | null = null
  if (isNew) {
    offset = -1
  } else if (!childNodes.length) {
    offset = 0
  } else {
    const offsetByNextNode = findChildNodeIndex(childNodes, findInsertBefore(node.nN))
    if (offsetByNextNode !== undefined) {
      insertBeforeNode = childNodes[offsetByNextNode]
      offset = offsetByNextNode
    } else {
      offset =
        findChildNodeIndex(childNodes, next.find((n) => n.tag !== HONO_PORTAL_ELEMENT && n.e)?.e) ??
        -1
    }

    if (offset === -1) {
      isNew = true
    }
  }

  for (let i = 0, len = next.length; i < len; i++, offset++) {
    const child = next[i]

    let el: SupportedElement | Text
    if (child.s && child.e) {
      el = child.e
      child.s = false
    } else {
      const isNewLocal = isNew || !child.e
      if (isNodeString(child)) {
        if (child.e && child.d) {
          child.e.textContent = child.t
        }
        child.d = false
        el = child.e ||= document.createTextNode(child.t)
      } else {
        el = child.e ||= child.n
          ? (document.createElementNS(child.n, child.tag as string) as SVGElement | MathMLElement)
          : document.createElement(child.tag as string)
        applyProps(el as HTMLElement, child.props, child.pP)
        applyNodeObject(child, el as HTMLElement, isNewLocal)
      }
    }
    if (child.tag === HONO_PORTAL_ELEMENT) {
      offset--
    } else if (isNew) {
      if (!el.parentNode) {
        container.appendChild(el)
      }
    } else if (childNodes[offset] !== el && childNodes[offset - 1] !== el) {
      if (childNodes[offset + 1] === el) {
        // Move extra elements to the back of the container. This is to be done efficiently when elements are swapped.
        container.appendChild(childNodes[offset])
      } else {
        container.insertBefore(el, insertBeforeNode || childNodes[offset] || null)
      }
    }
  }
  if (node.pP) {
    delete node.pP
  }
  if (callbacks.length) {
    const useLayoutEffectCbs: Array<() => void> = []
    const useEffectCbs: Array<() => void> = []
    callbacks.forEach(([, useLayoutEffectCb, , useEffectCb, useInsertionEffectCb]) => {
      if (useLayoutEffectCb) {
        useLayoutEffectCbs.push(useLayoutEffectCb)
      }
      if (useEffectCb) {
        useEffectCbs.push(useEffectCb)
      }
      useInsertionEffectCb?.() // invoke useInsertionEffect callbacks
    })
    useLayoutEffectCbs.forEach((cb) => cb()) // invoke useLayoutEffect callbacks
    if (useEffectCbs.length) {
      requestAnimationFrame(() => {
        useEffectCbs.forEach((cb) => cb()) // invoke useEffect callbacks
      })
    }
  }
}

const isSameContext = (
  oldContexts: LocalJSXContexts,
  newContexts: NonNullable<LocalJSXContexts>
): boolean =>
  !!(
    oldContexts &&
    oldContexts.length === newContexts.length &&
    oldContexts.every((ctx, i) => ctx[1] === newContexts[i][1])
  )

const fallbackUpdateFnArrayMap: WeakMap<
  NodeObject,
  Array<() => Promise<NodeObject | undefined>>
> = new WeakMap<NodeObject, Array<() => Promise<NodeObject | undefined>>>()
export const build = (context: Context, node: NodeObject, children?: Child[]): void => {
  const buildWithPreviousChildren = !children && node.pC
  if (children) {
    node.pC ||= node.vC
  }

  let foundErrorHandler: ErrorHandler | undefined
  try {
    children ||=
      typeof node.tag == 'function' ? invokeTag(context, node) : toArray(node.props.children)
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    if ((children[0] as JSXNode)?.tag === '' && (children[0] as any)[DOM_ERROR_HANDLER]) {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      foundErrorHandler = (children[0] as any)[DOM_ERROR_HANDLER] as ErrorHandler
      context[5]!.push([context, foundErrorHandler, node])
    }
    const oldVChildren: Node[] | undefined = buildWithPreviousChildren
      ? [...(node.pC as Node[])]
      : node.vC
      ? [...node.vC]
      : undefined
    const vChildren: Node[] = []
    let prevNode: Node | undefined
    for (let i = 0; i < children.length; i++) {
      if (Array.isArray(children[i])) {
        children.splice(i, 1, ...(children[i] as Child[]).flat())
      }
      let child = buildNode(children[i])
      if (child) {
        if (
          typeof child.tag === 'function' &&
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          !(child.tag as any)[DOM_INTERNAL_TAG]
        ) {
          if (globalJSXContexts.length > 0) {
            child[DOM_STASH][2] = globalJSXContexts.map((c) => [c, c.values.at(-1)])
          }
          if (context[5]?.length) {
            child[DOM_STASH][3] = context[5].at(-1) as [Context, ErrorHandler, NodeObject]
          }
        }

        let oldChild: NodeObject | undefined
        if (oldVChildren && oldVChildren.length) {
          const i = oldVChildren.findIndex(
            isNodeString(child)
              ? (c) => isNodeString(c)
              : child.key !== undefined
              ? (c) => c.key === (child as Node).key && c.tag === (child as Node).tag
              : (c) => c.tag === (child as Node).tag
          )

          if (i !== -1) {
            oldChild = oldVChildren[i] as NodeObject
            oldVChildren.splice(i, 1)
          }
        }

        if (oldChild) {
          if (isNodeString(child)) {
            if ((oldChild as unknown as NodeString).t !== child.t) {
              ;(oldChild as unknown as NodeString).t = child.t // update text content
              ;(oldChild as unknown as NodeString).d = true
            }
            child = oldChild
          } else {
            const pP = (oldChild.pP = oldChild.props)
            oldChild.props = child.props
            oldChild.f ||= child.f || node.f
            if (typeof child.tag === 'function') {
              const oldContexts = oldChild[DOM_STASH][2]
              oldChild[DOM_STASH][2] = child[DOM_STASH][2] || []
              oldChild[DOM_STASH][3] = child[DOM_STASH][3]

              if (
                !oldChild.f &&
                ((oldChild.o || oldChild) === child.o || // The code generated by the react compiler is memoized under this condition.
                  (oldChild.tag as MemorableFC<unknown>)[DOM_MEMO]?.(pP, oldChild.props)) && // The `memo` function is memoized under this condition.
                isSameContext(oldContexts, oldChild[DOM_STASH][2])
              ) {
                oldChild.s = true
              }
            }
            child = oldChild
          }
        } else if (!isNodeString(child) && nameSpaceContext) {
          const ns = useContext(nameSpaceContext)
          if (ns) {
            child.n = ns
          }
        }

        if (!isNodeString(child) && !child.s) {
          build(context, child)
          delete child.f
        }
        vChildren.push(child)

        if (prevNode && !prevNode.s && !child.s) {
          for (let p = prevNode; p && !isNodeString(p); p = p.vC?.at(-1) as NodeObject) {
            p.nN = child
          }
        }
        prevNode = child
      }
    }
    node.vR = buildWithPreviousChildren ? [...node.vC, ...(oldVChildren || [])] : oldVChildren || []
    node.vC = vChildren
    if (buildWithPreviousChildren) {
      delete node.pC
    }
  } catch (e) {
    node.f = true
    if (e === cancelBuild) {
      if (foundErrorHandler) {
        return
      } else {
        throw e
      }
    }

    const [errorHandlerContext, errorHandler, errorHandlerNode] =
      node[DOM_STASH]?.[3] || ([] as unknown as [undefined, undefined])

    if (errorHandler) {
      const fallbackUpdateFn = () =>
        update([0, false, context[2] as UpdateHook], errorHandlerNode as NodeObject)
      const fallbackUpdateFnArray =
        fallbackUpdateFnArrayMap.get(errorHandlerNode as NodeObject) || []
      fallbackUpdateFnArray.push(fallbackUpdateFn)
      fallbackUpdateFnArrayMap.set(errorHandlerNode as NodeObject, fallbackUpdateFnArray)
      const fallback = errorHandler(e, () => {
        const fnArray = fallbackUpdateFnArrayMap.get(errorHandlerNode as NodeObject)
        if (fnArray) {
          const i = fnArray.indexOf(fallbackUpdateFn)
          if (i !== -1) {
            fnArray.splice(i, 1)
            return fallbackUpdateFn()
          }
        }
      })
      if (fallback) {
        if (context[0] === 1) {
          // low priority render
          context[1] = true
        } else {
          build(context, errorHandlerNode, [fallback])
          if (
            (errorHandler.length === 1 || context !== errorHandlerContext) &&
            errorHandlerNode.c
          ) {
            // render error boundary immediately
            apply(errorHandlerNode, errorHandlerNode.c as Container, false)
            return
          }
        }
        throw cancelBuild
      }
    }

    throw e
  } finally {
    if (foundErrorHandler) {
      context[5]!.pop()
    }
  }
}

export const buildNode = (node: Child): Node | undefined => {
  if (node === undefined || node === null || typeof node === 'boolean') {
    return undefined
  } else if (typeof node === 'string' || typeof node === 'number') {
    return { t: node.toString(), d: true } as NodeString
  } else {
    if ('vR' in node) {
      node = {
        tag: (node as NodeObject).tag,
        props: (node as NodeObject).props,
        key: (node as NodeObject).key,
        f: (node as NodeObject).f,
        type: (node as NodeObject).tag,
        ref: (node as NodeObject).props.ref,
        o: (node as NodeObject).o || node,
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
      } as any
    }
    if (typeof (node as JSXNode).tag === 'function') {
      ;(node as NodeObject)[DOM_STASH] = [0, []]
    } else {
      const ns = nameSpaceMap[(node as JSXNode).tag as string]
      if (ns) {
        nameSpaceContext ||= createContext('')
        ;(node as JSXNode).props.children = [
          {
            tag: nameSpaceContext,
            props: {
              value: ((node as NodeObject).n = `http://www.w3.org/${ns}`),
              children: (node as JSXNode).props.children,
            },
          },
        ]
      }
    }
    return node as NodeObject
  }
}

const replaceContainer = (node: NodeObject, from: DocumentFragment, to: Container): void => {
  if (node.c === from) {
    node.c = to
    node.vC.forEach((child) => replaceContainer(child as NodeObject, from, to))
  }
}

const updateSync = (context: Context, node: NodeObject): void => {
  node[DOM_STASH][2]?.forEach(([c, v]) => {
    c.values.push(v)
  })
  try {
    build(context, node, undefined)
  } catch {
    return
  }
  if (node.a) {
    delete node.a
    return
  }
  node[DOM_STASH][2]?.forEach(([c]) => {
    c.values.pop()
  })
  if (context[0] !== 1 || !context[1]) {
    apply(node, node.c as Container, false)
  }
}

type UpdateMapResolve = (node: NodeObject | undefined) => void
const updateMap: WeakMap<NodeObject, [UpdateMapResolve, Function]> = new WeakMap<
  NodeObject,
  [UpdateMapResolve, Function]
>()
const currentUpdateSets: Set<NodeObject>[] = []
export const update = async (
  context: Context,
  node: NodeObject
): Promise<NodeObject | undefined> => {
  context[5] ||= []

  const existing = updateMap.get(node)
  if (existing) {
    // execute only the last update() call, so the previous update will be canceled.
    existing[0](undefined)
  }

  let resolve: UpdateMapResolve | undefined
  const promise = new Promise<NodeObject | undefined>((r) => (resolve = r))
  updateMap.set(node, [
    resolve as UpdateMapResolve,
    () => {
      if (context[2]) {
        context[2](context, node, (context) => {
          updateSync(context, node)
        }).then(() => (resolve as UpdateMapResolve)(node))
      } else {
        updateSync(context, node)
        ;(resolve as UpdateMapResolve)(node)
      }
    },
  ])

  if (currentUpdateSets.length) {
    ;(currentUpdateSets.at(-1) as Set<NodeObject>).add(node)
  } else {
    await Promise.resolve()

    const latest = updateMap.get(node)
    if (latest) {
      updateMap.delete(node)
      latest[1]()
    }
  }

  return promise
}

export const renderNode = (node: NodeObject, container: Container): void => {
  const context: Context = []
  ;(context as Context)[5] = [] // error handler stack
  ;(context as Context)[4] = true // start top level render
  build(context, node, undefined)
  ;(context as Context)[4] = false // finish top level render

  const fragment = document.createDocumentFragment()
  apply(node, fragment, true)
  replaceContainer(node, fragment, container)
  container.replaceChildren(fragment)
}

export const render = (jsxNode: Child, container: Container): void => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  renderNode(buildNode({ tag: '', props: { children: jsxNode } } as any) as NodeObject, container)
}

export const flushSync = (callback: () => void): void => {
  const set = new Set<NodeObject>()
  currentUpdateSets.push(set)
  callback()
  set.forEach((node) => {
    const latest = updateMap.get(node)
    if (latest) {
      updateMap.delete(node)
      latest[1]()
    }
  })
  currentUpdateSets.pop()
}

export const createPortal = (children: Child, container: HTMLElement, key?: string): Child =>
  ({
    tag: HONO_PORTAL_ELEMENT,
    props: {
      children,
    },
    key,
    e: container,
    p: 1,
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
  } as any)

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/server.test.tsx
```
/** @jsxImportSource ../ */
import { renderToReadableStream, renderToString } from './server'

describe('renderToString', () => {
  it('Should be able to render HTML element', () => {
    expect(renderToString(<h1>Hello</h1>)).toBe('<h1>Hello</h1>')
  })

  it('Should be able to render null', () => {
    expect(renderToString(null)).toBe('')
  })

  it('Should be able to render undefined', () => {
    expect(renderToString(undefined)).toBe('')
  })

  it('Should be able to render number', () => {
    expect(renderToString(1)).toBe('1')
  })

  it('Should be able to render string', () => {
    expect(renderToString('Hono')).toBe('Hono')
  })

  it('Should omit options', () => {
    expect(renderToString('Hono', { identifierPrefix: 'test' })).toBe('Hono')
  })

  it('Should raise error for async component', async () => {
    const AsyncComponent = async () => <h1>Hello from async component</h1>
    expect(() => renderToString(<AsyncComponent />)).toThrowError()
  })
})

describe('renderToReadableStream', () => {
  const textDecoder = new TextDecoder()
  const getStringFromStream = async (stream: ReadableStream<Uint8Array>): Promise<string> => {
    const reader = stream.getReader()
    let str = ''
    for (;;) {
      const { done, value } = await reader.read()
      if (done) {
        break
      }
      str += textDecoder.decode(value)
    }
    return str
  }

  it('Should be able to render HTML element', async () => {
    const stream = await renderToReadableStream(<h1>Hello</h1>)
    const reader = stream.getReader()
    let { done, value } = await reader.read()
    expect(done).toBe(false)
    expect(textDecoder.decode(value)).toBe('<h1>Hello</h1>')
    done = (await reader.read()).done
    expect(done).toBe(true)
  })

  it('Should be able to render null', async () => {
    expect(await getStringFromStream(await renderToReadableStream(null))).toBe('')
  })

  it('Should be able to render undefined', async () => {
    expect(await getStringFromStream(await renderToReadableStream(undefined))).toBe('')
  })

  it('Should be able to render number', async () => {
    expect(await getStringFromStream(await renderToReadableStream(1))).toBe('1')
  })

  it('Should be able to render string', async () => {
    expect(await getStringFromStream(await renderToReadableStream('Hono'))).toBe('Hono')
  })

  it('Should be called `onError` if there is an error', async () => {
    const ErrorComponent = async () => {
      throw new Error('Server error')
    }

    const onError = vi.fn()
    expect(
      await getStringFromStream(await renderToReadableStream(<ErrorComponent />, { onError }))
    ).toBe('')
    expect(onError).toBeCalledWith(new Error('Server error'))
  })

  it('Should not be called `onError` if there is no error', async () => {
    const onError = vi.fn(() => 'error')
    expect(await getStringFromStream(await renderToReadableStream('Hono', { onError }))).toBe(
      'Hono'
    )
    expect(onError).toBeCalledTimes(0)
  })

  it('Should omit options, except onError', async () => {
    expect(
      await getStringFromStream(await renderToReadableStream('Hono', { identifierPrefix: 'test' }))
    ).toBe('Hono')
  })

  it('Should be able to render async component', async () => {
    const ChildAsyncComponent = async () => {
      await new Promise((resolve) => setTimeout(resolve, 10))
      return <span>child async component</span>
    }

    const AsyncComponent = async () => {
      await new Promise((resolve) => setTimeout(resolve, 10))
      return (
        <h1>
          Hello from async component
          <ChildAsyncComponent />
        </h1>
      )
    }

    const stream = await renderToReadableStream(<AsyncComponent />)
    const reader = stream.getReader()
    let { done, value } = await reader.read()
    expect(done).toBe(false)
    expect(textDecoder.decode(value)).toBe(
      '<h1>Hello from async component<span>child async component</span></h1>'
    )
    done = (await reader.read()).done
    expect(done).toBe(true)
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/server.ts
```typescript
/**
 * @module
 * This module provides APIs for `hono/jsx/server`, which is compatible with `react-dom/server`.
 */

import type { HtmlEscapedString } from '../../utils/html'
import type { Child } from '../base'
import { renderToReadableStream as renderToReadableStreamHono } from '../streaming'
import version from './'

export interface RenderToStringOptions {
  identifierPrefix?: string
}

/**
 * Render JSX element to string.
 * @param element JSX element to render.
 * @param options Options for rendering.
 * @returns Rendered string.
 */
const renderToString = (element: Child, options: RenderToStringOptions = {}): string => {
  if (Object.keys(options).length > 0) {
    console.warn('options are not supported yet')
  }
  const res = element?.toString() ?? ''
  if (typeof res !== 'string') {
    throw new Error('Async component is not supported in renderToString')
  }
  return res
}

export interface RenderToReadableStreamOptions {
  identifierPrefix?: string
  namespaceURI?: string
  nonce?: string
  bootstrapScriptContent?: string
  bootstrapScripts?: string[]
  bootstrapModules?: string[]
  progressiveChunkSize?: number
  signal?: AbortSignal
  onError?: (error: unknown) => string | void
}

/**
 * Render JSX element to readable stream.
 * @param element JSX element to render.
 * @param options Options for rendering.
 * @returns Rendered readable stream.
 */
const renderToReadableStream = async (
  element: Child,
  options: RenderToReadableStreamOptions = {}
): Promise<ReadableStream<Uint8Array>> => {
  if (Object.keys(options).some((key) => key !== 'onError')) {
    console.warn('options are not supported yet, except onError')
  }

  if (!element || typeof element !== 'object') {
    element = element?.toString() ?? ''
  }

  return renderToReadableStreamHono(element as HtmlEscapedString, options.onError)
}

export { renderToString, renderToReadableStream, version }
export default {
  renderToString,
  renderToReadableStream,
  version,
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/utils.ts
```typescript
import { DOM_INTERNAL_TAG } from '../constants'

export const setInternalTagFlag = (fn: Function): Function => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  ;(fn as any)[DOM_INTERNAL_TAG] = true
  return fn
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/hooks/index.test.tsx
```
/** @jsxImportSource ../../ */
import { JSDOM } from 'jsdom'
import { render, useCallback, useState } from '..'
import { useActionState, useFormStatus, useOptimistic } from '.'

describe('Hooks', () => {
  beforeAll(() => {
    global.requestAnimationFrame = (cb) => setTimeout(cb)
  })

  let dom: JSDOM
  let root: HTMLElement
  beforeEach(() => {
    dom = new JSDOM('<html><body><div id="root"></div></body></html>', {
      runScripts: 'dangerously',
    })
    global.document = dom.window.document
    global.HTMLElement = dom.window.HTMLElement
    global.SVGElement = dom.window.SVGElement
    global.Text = dom.window.Text
    global.FormData = dom.window.FormData
    root = document.getElementById('root') as HTMLElement
  })

  describe('useActionState', () => {
    it('should return initial state', () => {
      const [state] = useActionState(() => {}, 'initial')
      expect(state).toBe('initial')
    })

    it('should return updated state', async () => {
      const action = vi.fn().mockReturnValue('updated')

      const App = () => {
        const [state, formAction] = useActionState(action, 'initial')
        return (
          <>
            <div>{state}</div>
            <form action={formAction}>
              <input type='text' name='name' value='updated' />
              <button>Submit</button>
            </form>
          </>
        )
      }

      render(<App />, root)
      expect(root.innerHTML).toBe(
        '<div>initial</div><form><input type="text" name="name" value="updated"><button>Submit</button></form>'
      )
      root.querySelector('button')?.click()
      await Promise.resolve()
      await Promise.resolve()
      expect(root.innerHTML).toBe(
        '<div>updated</div><form><input type="text" name="name" value="updated"><button>Submit</button></form>'
      )

      expect(action).toHaveBeenCalledOnce()
      const [initialState, formData] = action.mock.calls[0]
      expect(initialState).toBe('initial')
      expect(formData).toBeInstanceOf(FormData)
      expect(formData.get('name')).toBe('updated')
    })
  })

  describe('useFormStatus', () => {
    it('should return initial state', () => {
      const status = useFormStatus()
      expect(status).toEqual({
        pending: false,
        data: null,
        method: null,
        action: null,
      })
    })

    it('should return updated state', async () => {
      let formResolve: () => void = () => {}
      const formPromise = new Promise<void>((r) => (formResolve = r))
      let status: ReturnType<typeof useFormStatus> | undefined
      const Status = () => {
        status = useFormStatus()
        return null
      }
      const App = () => {
        const [, setCount] = useState(0)
        const action = useCallback(() => {
          setCount((count) => count + 1)
          return formPromise
        }, [])
        return (
          <>
            <form action={action}>
              <Status />
              <input type='text' name='name' value='updated' />
              <button>Submit</button>
            </form>
          </>
        )
      }

      render(<App />, root)
      expect(root.innerHTML).toBe(
        '<form><input type="text" name="name" value="updated"><button>Submit</button></form>'
      )
      root.querySelector('button')?.click()
      await Promise.resolve()
      await Promise.resolve()
      await Promise.resolve()
      await Promise.resolve()
      expect(status).toEqual({
        pending: true,
        data: expect.any(FormData),
        method: 'post',
        action: expect.any(Function),
      })
      formResolve?.()
      await Promise.resolve()
      await Promise.resolve()
      expect(status).toEqual({
        pending: false,
        data: null,
        method: null,
        action: null,
      })
    })
  })

  describe('useOptimistic', () => {
    it('should return updated state', async () => {
      let formResolve: () => void = () => {}
      const formPromise = new Promise<void>((r) => (formResolve = r))
      const App = () => {
        const [count, setCount] = useState(0)
        const [optimisticCount, setOptimisticCount] = useOptimistic(count, (c, n: number) => n)
        const action = useCallback(async () => {
          setOptimisticCount(count + 1)
          await formPromise
          setCount((count) => count + 2)
        }, [])

        return (
          <>
            <form action={action}>
              <div>{optimisticCount}</div>
              <input type='text' name='name' value='updated' />
              <button>Submit</button>
            </form>
          </>
        )
      }

      render(<App />, root)
      expect(root.innerHTML).toBe(
        '<form><div>0</div><input type="text" name="name" value="updated"><button>Submit</button></form>'
      )
      root.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe(
        '<form><div>1</div><input type="text" name="name" value="updated"><button>Submit</button></form>'
      )
      formResolve?.()
      await Promise.resolve()
      await Promise.resolve()
      await Promise.resolve()
      await Promise.resolve()
      expect(root.innerHTML).toBe(
        '<form><div>2</div><input type="text" name="name" value="updated"><button>Submit</button></form>'
      )
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/hooks/index.ts
```typescript
/**
 * Provide hooks used only in jsx/dom
 */

import { PERMALINK } from '../../constants'
import type { Context } from '../../context'
import { useContext } from '../../context'
import { useCallback, useState } from '../../hooks'
import { createContext } from '../context'

type FormStatus =
  | {
      pending: false
      data: null
      method: null
      action: null
    }
  | {
      pending: true
      data: FormData
      method: 'get' | 'post'
      action: string | ((formData: FormData) => void | Promise<void>)
    }
export const FormContext: Context<FormStatus> = createContext<FormStatus>({
  pending: false,
  data: null,
  method: null,
  action: null,
})

const actions: Set<Promise<unknown>> = new Set()
export const registerAction = (action: Promise<unknown>) => {
  actions.add(action)
  action.finally(() => actions.delete(action))
}

/**
 * This hook returns the current form status
 * @returns FormStatus
 */
export const useFormStatus = (): FormStatus => {
  return useContext(FormContext)
}

/**
 * This hook returns the current state and a function to update the state optimistically
 * The current state is updated optimistically and then reverted to the original state when all actions are resolved
 * @param state
 * @param updateState
 * @returns [T, (action: N) => void]
 */
export const useOptimistic = <T, N>(
  state: T,
  updateState: (currentState: T, action: N) => T
): [T, (action: N) => void] => {
  const [optimisticState, setOptimisticState] = useState(state)
  if (actions.size > 0) {
    Promise.all(actions).finally(() => {
      setOptimisticState(state)
    })
  } else {
    setOptimisticState(state)
  }

  const cb = useCallback((newData: N) => {
    setOptimisticState((currentState) => updateState(currentState, newData))
  }, [])

  return [optimisticState, cb]
}

/**
 * This hook returns the current state and a function to update the state by form action
 * @param fn
 * @param initialState
 * @param permalink
 * @returns [T, (data: FormData) => void]
 */
export const useActionState = <T>(
  fn: Function,
  initialState: T,
  permalink?: string
): [T, Function] => {
  const [state, setState] = useState(initialState)
  const actionState = async (data: FormData) => {
    setState(await fn(state, data))
  }
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  ;(actionState as any)[PERMALINK] = permalink
  return [state, actionState]
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/intrinsic-element/components.test.tsx
```
/** @jsxImportSource ../../ */
import { JSDOM, ResourceLoader } from 'jsdom'
import { Suspense, render } from '..'
import { useState } from '../../hooks'
import { clearCache, composeRef } from './components'

describe('intrinsic element', () => {
  let CustomResourceLoader: typeof ResourceLoader
  beforeAll(() => {
    global.requestAnimationFrame = (cb) => setTimeout(cb)

    CustomResourceLoader = class CustomResourceLoader extends ResourceLoader {
      fetch(url: string) {
        return url.includes('invalid')
          ? Promise.reject('Invalid URL')
          : // eslint-disable-next-line @typescript-eslint/no-explicit-any
            (Promise.resolve(Buffer.from('')) as any)
      }
    }
  })

  let dom: JSDOM
  let root: HTMLElement
  beforeEach(() => {
    clearCache()

    dom = new JSDOM('<html><head></head><body><div id="root"></div></body></html>', {
      runScripts: 'dangerously',
      resources: new CustomResourceLoader(),
    })
    global.document = dom.window.document
    global.HTMLElement = dom.window.HTMLElement
    global.SVGElement = dom.window.SVGElement
    global.Text = dom.window.Text
    global.FormData = dom.window.FormData
    global.CustomEvent = dom.window.CustomEvent
    root = document.getElementById('root') as HTMLElement
  })

  describe('document metadata', () => {
    describe('title element', () => {
      it('should be inserted into head', () => {
        const App = () => {
          return (
            <div>
              <title>Document Title</title>
              Content
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('<title>Document Title</title>')
        expect(root.innerHTML).toBe('<div>Content</div>')
      })

      it('should be updated', async () => {
        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              <title>Document Title {count}</title>
              <button onClick={() => setCount(count + 1)}>+</button>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('<title>Document Title 0</title>')
        expect(root.innerHTML).toBe('<div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe('<title>Document Title 1</title>')
      })

      it('should be removed when unmounted', async () => {
        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              {count === 1 && <title>Document Title {count}</title>}
              <div>{count}</div>
              <button onClick={() => setCount(count + 1)}>+</button>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('')
        expect(root.innerHTML).toBe('<div><div>0</div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe('<title>Document Title 1</title>')
        expect(root.innerHTML).toBe('<div><div>1</div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe('')
        expect(root.innerHTML).toBe('<div><div>2</div><button>+</button></div>')
      })

      it('should be inserted bottom of head if existing element is removed', async () => {
        document.head.innerHTML = '<title>Existing Title</title>'

        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              {count === 1 && <title>Document Title {count}</title>}
              <div>{count}</div>
              <button onClick={() => setCount(count + 1)}>+</button>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('<title>Existing Title</title>')
        expect(root.innerHTML).toBe('<div><div>0</div><button>+</button></div>')
        root.querySelector('button')?.click()
        document.head.querySelector('title')?.remove()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe('<title>Document Title 1</title>')
        expect(root.innerHTML).toBe('<div><div>1</div><button>+</button></div>')
      })

      it('should be inserted before existing title element', async () => {
        document.head.innerHTML = '<title>Existing Title</title>'

        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              {count === 1 && <title>Document Title {count}</title>}
              <div>{count}</div>
              <button onClick={() => setCount(count + 1)}>+</button>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('<title>Existing Title</title>')
        expect(root.innerHTML).toBe('<div><div>0</div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe(
          '<title>Document Title 1</title><title>Existing Title</title>'
        )
        expect(root.innerHTML).toBe('<div><div>1</div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe('<title>Existing Title</title>')
        expect(root.innerHTML).toBe('<div><div>2</div><button>+</button></div>')
      })
    })

    describe('link element', () => {
      it('should be inserted into head', () => {
        const App = () => {
          return (
            <div>
              <link rel='stylesheet' href='style.css' precedence='default' />
              Content
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe(
          '<link href="style.css" rel="stylesheet" data-precedence="default">'
        )
        expect(root.innerHTML).toBe('<div>Content</div>')
      })

      it('should be updated', async () => {
        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              <link rel='stylesheet' href={`style${count}.css`} precedence='default' />
              <button onClick={() => setCount(count + 1)}>+</button>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe(
          '<link href="style0.css" rel="stylesheet" data-precedence="default">'
        )
        expect(root.innerHTML).toBe('<div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe(
          '<link href="style1.css" rel="stylesheet" data-precedence="default">'
        )
      })

      it('should not do special behavior if disabled is present', () => {
        const App = () => {
          return (
            <div>
              <link rel='stylesheet' href={'style.css'} precedence='default' disabled={true} />
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('')
        expect(root.innerHTML).toBe(
          '<div><link rel="stylesheet" href="style.css" precedence="default" disabled=""></div>'
        )
      })

      it('should be ordered by precedence attribute', () => {
        const App = () => {
          return (
            <div>
              <link rel='stylesheet' href='style-a.css' precedence='default' />
              <link rel='stylesheet' href='style-b.css' precedence='high' />
              <link rel='stylesheet' href='style-c.css' precedence='default' />
              Content
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe(
          '<link href="style-a.css" rel="stylesheet" data-precedence="default"><link href="style-c.css" rel="stylesheet" data-precedence="default"><link href="style-b.css" rel="stylesheet" data-precedence="high">'
        )
        expect(root.innerHTML).toBe('<div>Content</div>')
      })

      it('should be de-duplicated by href attribute', async () => {
        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              <link rel='stylesheet' href='style-a.css' precedence='default' />
              <link rel='stylesheet' href='style-b.css' precedence='high' />
              {count === 1 && (
                <>
                  <link rel='stylesheet' href='style-a.css' precedence='default' />
                  <link rel='stylesheet' href='style-c.css' precedence='other' />
                </>
              )}
              <button onClick={() => setCount(count + 1)}>+</button>
              {count}
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe(
          '<link href="style-a.css" rel="stylesheet" data-precedence="default"><link href="style-b.css" rel="stylesheet" data-precedence="high">'
        )
        expect(root.innerHTML).toBe('<div><button>+</button>0</div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe(
          '<link href="style-a.css" rel="stylesheet" data-precedence="default"><link href="style-b.css" rel="stylesheet" data-precedence="high"><link href="style-c.css" rel="stylesheet" data-precedence="other">'
        )
        expect(root.innerHTML).toBe('<div><button>+</button>1</div>')
      })

      it('should be preserved when unmounted', async () => {
        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              {count === 1 && <link rel='stylesheet' href='style.css' precedence='default' />}
              <div>{count}</div>
              <button onClick={() => setCount(count + 1)}>+</button>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('')
        expect(root.innerHTML).toBe('<div><div>0</div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe(
          '<link href="style.css" rel="stylesheet" data-precedence="default">'
        )
        expect(root.innerHTML).toBe('<div><div>1</div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe(
          '<link href="style.css" rel="stylesheet" data-precedence="default">'
        )
        expect(root.innerHTML).toBe('<div><div>2</div><button>+</button></div>')
      })

      it('should be blocked by blocking attribute', async () => {
        const Component = () => {
          return (
            <Suspense fallback={<div>Loading...</div>}>
              <div>
                <link
                  rel='stylesheet'
                  href='http://localhost/style.css'
                  precedence='default'
                  blocking='render'
                />
                Content
              </div>
            </Suspense>
          )
        }
        const App = () => {
          const [show, setShow] = useState(false)
          return (
            <div>
              {show && <Component />}
              <button onClick={() => setShow(true)}>Show</button>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('')
        expect(root.innerHTML).toBe('<div><button>Show</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div><div>Loading...</div><button>Show</button></div>')
        await new Promise((resolve) => setTimeout(resolve))
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div><div>Content</div><button>Show</button></div>')
      })
    })

    describe('style element', () => {
      it('should be inserted into head', () => {
        const App = () => {
          return (
            <div>
              <style href='red' precedence='default'>
                {'body { color: red; }'}
              </style>
              Content
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe(
          '<style data-href="red" data-precedence="default">body { color: red; }</style>'
        )
        expect(root.innerHTML).toBe('<div>Content</div>')
      })

      it('should be updated', async () => {
        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              <style href='color' precedence='default'>{`body { color: ${
                count % 2 ? 'red' : 'blue'
              }; }`}</style>
              <button onClick={() => setCount(count + 1)}>+</button>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe(
          '<style data-href="color" data-precedence="default">body { color: blue; }</style>'
        )
        expect(root.innerHTML).toBe('<div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe(
          '<style data-href="color" data-precedence="default">body { color: red; }</style>'
        )
      })

      it('should be preserved when unmounted', async () => {
        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              {count === 1 && (
                <style href='red' precedence='default'>
                  {'body { color: red; }'}
                </style>
              )}
              <div>{count}</div>
              <button onClick={() => setCount(count + 1)}>+</button>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('')
        expect(root.innerHTML).toBe('<div><div>0</div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe(
          '<style data-href="red" data-precedence="default">body { color: red; }</style>'
        )
        expect(root.innerHTML).toBe('<div><div>1</div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe(
          '<style data-href="red" data-precedence="default">body { color: red; }</style>'
        )
        expect(root.innerHTML).toBe('<div><div>2</div><button>+</button></div>')
      })

      it('should be de-duplicated by href attribute', async () => {
        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              <style href='red' precedence='default'>
                {'body { color: red; }'}
              </style>
              <style href='blue' precedence='default'>
                {'body { color: blue; }'}
              </style>
              <style href='green' precedence='default'>
                {'body { color: green; }'}
              </style>
              {count === 1 && (
                <>
                  <style href='blue' precedence='default'>
                    {'body { color: blue; }'}
                  </style>
                  <style href='yellow' precedence='default'>
                    {'body { color: yellow; }'}
                  </style>
                </>
              )}
              <button onClick={() => setCount(count + 1)}>+</button>
              {count}
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe(
          '<style data-href="red" data-precedence="default">body { color: red; }</style><style data-href="blue" data-precedence="default">body { color: blue; }</style><style data-href="green" data-precedence="default">body { color: green; }</style>'
        )
        expect(root.innerHTML).toBe('<div><button>+</button>0</div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe(
          '<style data-href="red" data-precedence="default">body { color: red; }</style><style data-href="blue" data-precedence="default">body { color: blue; }</style><style data-href="green" data-precedence="default">body { color: green; }</style><style data-href="yellow" data-precedence="default">body { color: yellow; }</style>'
        )
        expect(root.innerHTML).toBe('<div><button>+</button>1</div>')
      })

      it('should be ordered by precedence attribute', () => {
        const App = () => {
          return (
            <div>
              <style href='red' precedence='default'>
                {'body { color: red; }'}
              </style>
              <style href='green' precedence='high'>
                {'body { color: green; }'}
              </style>
              <style href='blue' precedence='default'>
                {'body { color: blue; }'}
              </style>
              Content
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe(
          '<style data-href="red" data-precedence="default">body { color: red; }</style><style data-href="blue" data-precedence="default">body { color: blue; }</style><style data-href="green" data-precedence="high">body { color: green; }</style>'
        )
        expect(root.innerHTML).toBe('<div>Content</div>')
      })

      it('should not do special behavior if href is present', () => {
        const template = (
          <html>
            <head></head>
            <body>
              <style>{'body { color: red; }'}</style>
              <h1>World</h1>
            </body>
          </html>
        )
        render(template, root)
        expect(document.head.innerHTML).toBe('')
        expect(root.innerHTML).toBe(
          '<html><head></head><body><style>body { color: red; }</style><h1>World</h1></body></html>'
        )
      })
    })

    describe('meta element', () => {
      it('should be inserted into head', () => {
        const App = () => {
          return (
            <div>
              <meta name='description' content='description' />
              Content
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('<meta name="description" content="description">')
        expect(root.innerHTML).toBe('<div>Content</div>')
      })

      it('should be updated', async () => {
        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              <meta name='description' content={`description ${count}`} />
              <button onClick={() => setCount(count + 1)}>+</button>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('<meta name="description" content="description 0">')
        expect(root.innerHTML).toBe('<div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe('<meta name="description" content="description 1">')
      })

      it('should not do special behavior if itemProp is present', () => {
        const App = () => {
          return (
            <div>
              <meta name='description' content='description' itemProp='test' />
              Content
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('')
        expect(root.innerHTML).toBe(
          '<div><meta name="description" content="description" itemprop="test">Content</div>'
        )
      })

      it('should ignore precedence attribute', () => {
        const App = () => {
          return (
            <div>
              <meta name='description-a' content='description-a' precedence='default' />
              <meta name='description-b' content='description-b' precedence='high' />
              <meta name='description-c' content='description-c' precedence='default' />
              Content
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe(
          '<meta name="description-a" content="description-a"><meta name="description-b" content="description-b"><meta name="description-c" content="description-c">'
        )
        expect(root.innerHTML).toBe('<div>Content</div>')
      })

      it('should be de-duplicated by name attribute', async () => {
        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              <meta name='description-a' content='description-a' />
              <meta name='description-b' content='description-b' />
              {count === 1 && (
                <>
                  <meta name='description-a' content='description-a' />
                  <meta name='description-c' content='description-c' />
                </>
              )}
              <button onClick={() => setCount(count + 1)}>+</button>
              {count}
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe(
          '<meta name="description-a" content="description-a"><meta name="description-b" content="description-b">'
        )
        expect(root.innerHTML).toBe('<div><button>+</button>0</div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe(
          '<meta name="description-a" content="description-a"><meta name="description-b" content="description-b"><meta name="description-c" content="description-c">'
        )
        expect(root.innerHTML).toBe('<div><button>+</button>1</div>')
      })
    })

    describe('script element', () => {
      it('should be inserted into head', async () => {
        const App = () => {
          return (
            <div>
              <script src='script.js' async={true} />
              Content
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('<script src="script.js" async=""></script>')
        expect(root.innerHTML).toBe('<div>Content</div>')
      })

      it('should be updated', async () => {
        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              <script src={`script${count}.js`} async={true} />
              <button onClick={() => setCount(count + 1)}>+</button>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('<script src="script0.js" async=""></script>')
        expect(root.innerHTML).toBe('<div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe('<script src="script1.js" async=""></script>')
      })

      it('should be de-duplicated by src attribute with async=true', async () => {
        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              <script src='script-a.js' async={true} />
              <script src='script-b.js' async={true} />
              {count === 1 && (
                <>
                  <script src='script-a.js' async={true} />
                  <script src='script-c.js' async={true} />
                </>
              )}
              <button onClick={() => setCount(count + 1)}>+</button>
              {count}
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe(
          '<script src="script-a.js" async=""></script><script src="script-b.js" async=""></script>'
        )
        expect(root.innerHTML).toBe('<div><button>+</button>0</div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe(
          '<script src="script-a.js" async=""></script><script src="script-b.js" async=""></script><script src="script-c.js" async=""></script>'
        )
        expect(root.innerHTML).toBe('<div><button>+</button>1</div>')
      })

      it('should be preserved when unmounted', async () => {
        const App = () => {
          const [count, setCount] = useState(0)
          return (
            <div>
              {count === 1 && <script src='script.js' async={true} />}
              <div>{count}</div>
              <button onClick={() => setCount(count + 1)}>+</button>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('')
        expect(root.innerHTML).toBe('<div><div>0</div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe('<script src="script.js" async=""></script>')
        expect(root.innerHTML).toBe('<div><div>1</div><button>+</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(document.head.innerHTML).toBe('<script src="script.js" async=""></script>')
        expect(root.innerHTML).toBe('<div><div>2</div><button>+</button></div>')
      })

      it('should be fired onLoad event', async () => {
        const onLoad = vi.fn()
        const onError = vi.fn()
        const App = () => {
          return (
            <div>
              <script
                src='http://localhost/script.js'
                async={true}
                onLoad={onLoad}
                onError={onError}
              />
              Content
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe(
          '<script src="http://localhost/script.js" async=""></script>'
        )
        await Promise.resolve()
        await new Promise((resolve) => setTimeout(resolve))
        expect(onLoad).toBeCalledTimes(1)
        expect(onError).not.toBeCalled()
      })

      it('should be fired onError event', async () => {
        const onLoad = vi.fn()
        const onError = vi.fn()
        const App = () => {
          return (
            <div>
              <script
                src='http://localhost/invalid.js'
                async={true}
                onLoad={onLoad}
                onError={onError}
              />
              Content
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe(
          '<script src="http://localhost/invalid.js" async=""></script>'
        )
        await Promise.resolve()
        await new Promise((resolve) => setTimeout(resolve))
        await Promise.resolve()
        await new Promise((resolve) => setTimeout(resolve))
        await Promise.resolve()
        await new Promise((resolve) => setTimeout(resolve))
        await Promise.resolve()
        await new Promise((resolve) => setTimeout(resolve))
        expect(onLoad).not.toBeCalled()
        expect(onError).toBeCalledTimes(1)
      })

      it('should be blocked by blocking attribute', async () => {
        const Component = () => {
          return (
            <Suspense fallback={<div>Loading...</div>}>
              <div>
                <script src='http://localhost/script.js' async={true} blocking='render' />
                Content
              </div>
            </Suspense>
          )
        }
        const App = () => {
          const [show, setShow] = useState(false)
          return (
            <div>
              {show && <Component />}
              <button onClick={() => setShow(true)}>Show</button>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('')
        expect(root.innerHTML).toBe('<div><button>Show</button></div>')
        root.querySelector('button')?.click()
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div><div>Loading...</div><button>Show</button></div>')
        await new Promise((resolve) => setTimeout(resolve))
        await Promise.resolve()
        expect(root.innerHTML).toBe('<div><div>Content</div><button>Show</button></div>')
      })

      it('should be inserted into body if has no props', async () => {
        const App = () => {
          return (
            <div>
              <script>alert('Hello')</script>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('')
        // prettier-ignore
        expect(root.innerHTML).toBe('<div><script>alert(\'Hello\')</script></div>')
      })

      it('should be inserted into body if has only src prop', async () => {
        const App = () => {
          return (
            <div>
              <script src='script.js'></script>
            </div>
          )
        }
        render(<App />, root)
        expect(document.head.innerHTML).toBe('')
        expect(root.innerHTML).toBe('<div><script src="script.js"></script></div>')
      })
    })

    it('accept ref object', async () => {
      const ref = { current: null }
      const App = () => {
        return (
          <div>
            <script src='script-a.js' ref={ref} async={true} />
          </div>
        )
      }
      render(<App />, root)
      expect(ref.current).toBe(document.head.querySelector('script'))
    })

    it('accept ref function', async () => {
      const ref = vi.fn()
      const App = () => {
        return (
          <div>
            <script src='script-a.js' ref={ref} async={true} />
          </div>
        )
      }
      render(<App />, root)
      expect(ref).toHaveBeenCalledTimes(1)
    })
  })

  describe('form element', () => {
    it('should accept Function as action', () => {
      const action = vi.fn()
      const App = () => {
        return (
          <form action={action} method='post'>
            <input type='text' name='name' value='Hello' />
            <button type='submit'>Submit</button>
          </form>
        )
      }
      render(<App />, root)
      root.querySelector('button')?.click()
      expect(action).toBeCalledTimes(1)
      const formData = action.mock.calls[0][0]
      expect(formData.get('name')).toBe('Hello')
    })

    it('should accept string as action', () => {
      const App = () => {
        return (
          <form action={'/entries'} method='post'>
            <button type='submit'>Submit</button>
          </form>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe(
        '<form method="post" action="/entries"><button type="submit">Submit</button></form>'
      )
    })

    it('toggle show / hide form', async () => {
      const action = vi.fn()
      const App = () => {
        const [show, setShow] = useState(false)
        return (
          <div>
            {show && (
              <form action={action} method='post'>
                <input type='text' name='name' value='Hello' />
              </form>
            )}
            <button onClick={() => setShow((status) => !status)}>Toggle</button>
          </div>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div><button>Toggle</button></div>')
      root.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe(
        '<div><form method="post"><input type="text" name="name" value="Hello"></form><button>Toggle</button></div>'
      )
      root.querySelector('button')?.click()
      await Promise.resolve()
      await Promise.resolve()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><button>Toggle</button></div>')
    })
  })

  describe('input element', () => {
    it('should accept Function as formAction', () => {
      const action = vi.fn()
      const App = () => {
        return (
          <form>
            <input type='text' name='name' value='Hello' />
            <input type='submit' value='Submit' formAction={action} />
          </form>
        )
      }
      render(<App />, root)
      root.querySelector<HTMLInputElement>('input[type="submit"]')?.click()
      expect(action).toBeCalledTimes(1)
      const formData = action.mock.calls[0][0]
      expect(formData.get('name')).toBe('Hello')
    })

    it('should accept string as formAction', () => {
      const App = () => {
        return (
          <form method='post'>
            <input type='submit' formAction={'/entries'} value='Submit' />
          </form>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<form method="post"><input type="submit" value="Submit"></form>')
    })

    it('toggle show / hide input', async () => {
      const action = vi.fn()
      const App = () => {
        const [show, setShow] = useState(false)
        return (
          <div>
            {show && (
              <form method='post'>
                <input type='submit' formAction={action} value='Submit' />
              </form>
            )}
            <button onClick={() => setShow((status) => !status)}>Toggle</button>
          </div>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div><button>Toggle</button></div>')
      root.querySelector('button')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe(
        '<div><form method="post"><input type="submit" value="Submit"></form><button>Toggle</button></div>'
      )
      root.querySelector('button')?.click()
      await Promise.resolve()
      await Promise.resolve()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><button>Toggle</button></div>')
    })
  })

  describe('button element', () => {
    it('should accept Function as formAction', () => {
      const action = vi.fn()
      const App = () => {
        return (
          <form>
            <input type='text' name='name' value='Hello' />
            <button type='submit' formAction={action}>
              Submit
            </button>
          </form>
        )
      }
      render(<App />, root)
      root.querySelector('button')?.click()
      expect(action).toBeCalledTimes(1)
      const formData = action.mock.calls[0][0]
      expect(formData.get('name')).toBe('Hello')
    })

    it('should accept string as formAction', () => {
      const App = () => {
        return (
          <form method='post'>
            <button type='submit' formAction={'/entries'}>
              Submit
            </button>
          </form>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe(
        '<form method="post"><button type="submit">Submit</button></form>'
      )
    })

    it('toggle show / hide', async () => {
      const action = vi.fn()
      const App = () => {
        const [show, setShow] = useState(false)
        return (
          <div>
            {show && (
              <form method='post'>
                <button formAction={action}>Submit</button>
              </form>
            )}
            <button id='toggle' onClick={() => setShow((status) => !status)}>
              Toggle
            </button>
          </div>
        )
      }
      render(<App />, root)
      expect(root.innerHTML).toBe('<div><button id="toggle">Toggle</button></div>')
      root.querySelector<HTMLButtonElement>('#toggle')?.click()
      await Promise.resolve()
      expect(root.innerHTML).toBe(
        '<div><form method="post"><button>Submit</button></form><button id="toggle">Toggle</button></div>'
      )
      root.querySelector<HTMLButtonElement>('#toggle')?.click()
      await Promise.resolve()
      await Promise.resolve()
      await Promise.resolve()
      expect(root.innerHTML).toBe('<div><button id="toggle">Toggle</button></div>')
    })
  })
})

describe('internal utility method', () => {
  describe('composeRef()', () => {
    it('should compose a ref object', () => {
      const ref = { current: null }
      const cbCleanUp = vi.fn()
      const cb = vi.fn().mockReturnValue(cbCleanUp)
      const composed = composeRef(ref, cb)
      const cleanup = composed('ref')
      expect(ref.current).toBe('ref')
      expect(cb).toBeCalledWith('ref')
      expect(cbCleanUp).not.toBeCalled()
      cleanup()
      expect(ref.current).toBe(null)
      expect(cbCleanUp).toBeCalledTimes(1)
    })

    it('should compose a function', () => {
      const ref = vi.fn()
      const cbCleanUp = vi.fn()
      const cb = vi.fn().mockReturnValue(cbCleanUp)
      const composed = composeRef(ref, cb)
      const cleanup = composed('ref')
      expect(ref).toBeCalledWith('ref')
      expect(cb).toBeCalledWith('ref')
      expect(cbCleanUp).not.toBeCalled()
      cleanup()
      expect(ref).toBeCalledWith(null)
      expect(cbCleanUp).toBeCalledTimes(1)
    })

    it('should compose a function returns a cleanup function', () => {
      const refCleanUp = vi.fn()
      const ref = vi.fn().mockReturnValue(refCleanUp)
      const cbCleanUp = vi.fn()
      const cb = vi.fn().mockReturnValue(cbCleanUp)
      const composed = composeRef(ref, cb)
      const cleanup = composed('ref')
      expect(ref).toBeCalledWith('ref')
      expect(cb).toBeCalledWith('ref')
      expect(refCleanUp).not.toBeCalled()
      expect(cbCleanUp).not.toBeCalled()
      cleanup()
      expect(ref).toHaveBeenCalledTimes(1)
      expect(refCleanUp).toBeCalledTimes(1)
      expect(cbCleanUp).toBeCalledTimes(1)
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/jsx/dom/intrinsic-element/components.ts
```typescript
import type { Props } from '../../base'
import { useContext } from '../../context'
import { use, useCallback, useMemo, useState } from '../../hooks'
import { dataPrecedenceAttr, deDupeKeyMap, domRenderers } from '../../intrinsic-element/common'
import type { IntrinsicElements } from '../../intrinsic-elements'
import type { FC, JSXNode, PropsWithChildren, RefObject } from '../../types'
import { FormContext, registerAction } from '../hooks'
import type { PreserveNodeType } from '../render'
import { createPortal, getNameSpaceContext } from '../render'

// this function is a testing utility and should not be exported to the user
export const clearCache = () => {
  blockingPromiseMap = Object.create(null)
  createdElements = Object.create(null)
}

// this function is exported for testing and should not be used by the user
export const composeRef = <T>(
  ref: RefObject<T> | Function | undefined,
  cb: (e: T) => void | (() => void)
): ((e: T) => () => void) => {
  return useMemo(
    () => (e: T) => {
      let refCleanup: (() => void) | undefined
      if (ref) {
        if (typeof ref === 'function') {
          refCleanup =
            ref(e) ||
            (() => {
              ref(null)
            })
        } else if (ref && 'current' in ref) {
          ref.current = e
          refCleanup = () => {
            ref.current = null
          }
        }
      }

      const cbCleanup = cb(e)
      return () => {
        cbCleanup?.()
        refCleanup?.()
      }
    },
    [ref]
  )
}

let blockingPromiseMap: Record<string, Promise<Event> | undefined> = Object.create(null)
let createdElements: Record<string, HTMLElement> = Object.create(null)
const documentMetadataTag = (
  tag: string,
  props: Props,
  preserveNodeType: PreserveNodeType | undefined,
  supportSort: boolean,
  supportBlocking: boolean
) => {
  if (props?.itemProp) {
    return {
      tag,
      props,
      type: tag,
      ref: props.ref,
    }
  }

  const head = document.head

  let { onLoad, onError, precedence, blocking, ...restProps } = props
  let element: HTMLElement | null = null
  let created = false

  const deDupeKeys = deDupeKeyMap[tag]
  let existingElements: NodeListOf<HTMLElement> | undefined = undefined
  if (deDupeKeys.length > 0) {
    const tags = head.querySelectorAll<HTMLElement>(tag)
    LOOP: for (const e of tags) {
      for (const key of deDupeKeyMap[tag]) {
        if (e.getAttribute(key) === props[key]) {
          element = e
          break LOOP
        }
      }
    }

    if (!element) {
      const cacheKey = deDupeKeys.reduce(
        (acc, key) => (props[key] === undefined ? acc : `${acc}-${key}-${props[key]}`),
        tag
      )
      created = !createdElements[cacheKey]
      element = createdElements[cacheKey] ||= (() => {
        const e = document.createElement(tag)
        for (const key of deDupeKeys) {
          if (props[key] !== undefined) {
            e.setAttribute(key, props[key] as string)
          }
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          if ((props as any).rel) {
            e.setAttribute('rel', props.rel)
          }
        }
        return e
      })()
    }
  } else {
    existingElements = head.querySelectorAll<HTMLElement>(tag)
  }

  precedence = supportSort ? precedence ?? '' : undefined
  if (supportSort) {
    restProps[dataPrecedenceAttr] = precedence
  }

  const insert = useCallback(
    (e: HTMLElement) => {
      if (deDupeKeys.length > 0) {
        let found = false
        for (const existingElement of head.querySelectorAll<HTMLElement>(tag)) {
          if (found && existingElement.getAttribute(dataPrecedenceAttr) !== precedence) {
            head.insertBefore(e, existingElement)
            return
          }
          if (existingElement.getAttribute(dataPrecedenceAttr) === precedence) {
            found = true
          }
        }

        // if sentinel is not found, append to the end
        head.appendChild(e)
      } else if (existingElements) {
        let found = false
        for (const existingElement of existingElements!) {
          if (existingElement === e) {
            found = true
            break
          }
        }
        if (!found) {
          // newly created element
          head.insertBefore(
            e,
            head.contains(existingElements[0]) ? existingElements[0] : head.querySelector(tag)
          )
        }
        existingElements = undefined
      }
    },
    [precedence]
  )

  const ref = composeRef(props.ref, (e: HTMLElement) => {
    const key = deDupeKeys[0]

    if (preserveNodeType === 2) {
      e.innerHTML = ''
    }

    if (created || existingElements) {
      insert(e)
    }

    if (!onError && !onLoad) {
      return
    }

    let promise = (blockingPromiseMap[e.getAttribute(key) as string] ||= new Promise<Event>(
      (resolve, reject) => {
        e.addEventListener('load', resolve)
        e.addEventListener('error', reject)
      }
    ))
    if (onLoad) {
      promise = promise.then(onLoad)
    }
    if (onError) {
      promise = promise.catch(onError)
    }
    promise.catch(() => {})
  })

  if (supportBlocking && blocking === 'render') {
    const key = deDupeKeyMap[tag][0]
    if (props[key]) {
      const value = props[key]
      const promise = (blockingPromiseMap[value] ||= new Promise<Event>((resolve, reject) => {
        insert(element as HTMLElement)
        element!.addEventListener('load', resolve)
        element!.addEventListener('error', reject)
      }))
      use(promise)
    }
  }

  const jsxNode = {
    tag,
    type: tag,
    props: {
      ...restProps,
      ref,
    },
    ref,
  } as unknown as JSXNode & { e?: HTMLElement; p?: PreserveNodeType }

  jsxNode.p = preserveNodeType // preserve for unmounting
  if (element) {
    jsxNode.e = element
  }

  return createPortal(
    jsxNode,
    head
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
  ) as any
}
export const title: FC<PropsWithChildren> = (props) => {
  const nameSpaceContext = getNameSpaceContext()
  const ns = nameSpaceContext && useContext(nameSpaceContext)
  if (ns?.endsWith('svg')) {
    return {
      tag: 'title',
      props,
      type: 'title',
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      ref: (props as any).ref,
    } as unknown as JSXNode
  }
  return documentMetadataTag('title', props, undefined, false, false)
}

export const script: FC<PropsWithChildren<IntrinsicElements['script']>> = (props) => {
  if (!props || ['src', 'async'].some((k) => !props[k])) {
    return {
      tag: 'script',
      props,
      type: 'script',
      ref: props.ref,
    } as unknown as JSXNode
  }
  return documentMetadataTag('script', props, 1, false, true)
}

export const style: FC<PropsWithChildren<IntrinsicElements['style']>> = (props) => {
  if (!props || !['href', 'precedence'].every((k) => k in props)) {
    return {
      tag: 'style',
      props,
      type: 'style',
      ref: props.ref,
    } as unknown as JSXNode
  }
  props['data-href'] = props.href
  delete props.href
  return documentMetadataTag('style', props, 2, true, true)
}

export const link: FC<PropsWithChildren<IntrinsicElements['link']>> = (props) => {
  if (
    !props ||
    ['onLoad', 'onError'].some((k) => k in props) ||
    (props.rel === 'stylesheet' && (!('precedence' in props) || 'disabled' in props))
  ) {
    return {
      tag: 'link',
      props,
      type: 'link',
      ref: props.ref,
    } as unknown as JSXNode
  }
  return documentMetadataTag('link', props, 1, 'precedence' in props, true)
}

export const meta: FC<PropsWithChildren> = (props) => {
  return documentMetadataTag('meta', props, undefined, false, false)
}

const customEventFormAction = Symbol()
export const form: FC<
  PropsWithChildren<{
    action?: Function | string
    method?: 'get' | 'post'
    ref?: RefObject<HTMLFormElement> | ((e: HTMLFormElement | null) => void | (() => void))
  }>
> = (props) => {
  const { action, ...restProps } = props
  if (typeof action !== 'function') {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    ;(restProps as any).action = action
  }

  const [state, setState] = useState<[FormData | null, boolean]>([null, false]) // [FormData, isDirty]
  const onSubmit = useCallback<(ev: SubmitEvent | CustomEvent) => void>(
    async (ev: SubmitEvent | CustomEvent) => {
      const currentAction = ev.isTrusted
        ? action
        : (ev as CustomEvent).detail[customEventFormAction]
      if (typeof currentAction !== 'function') {
        return
      }

      ev.preventDefault()
      const formData = new FormData(ev.target as HTMLFormElement)
      setState([formData, true])
      const actionRes = currentAction(formData)
      if (actionRes instanceof Promise) {
        registerAction(actionRes)
        await actionRes
      }
      setState([null, true])
    },
    []
  )

  const ref = composeRef(props.ref, (el: HTMLFormElement) => {
    el.addEventListener('submit', onSubmit)
    return () => {
      el.removeEventListener('submit', onSubmit)
    }
  })

  const [data, isDirty] = state
  state[1] = false
  return {
    tag: FormContext as unknown as Function,
    props: {
      value: {
        pending: data !== null,
        data,
        method: data ? 'post' : null,
        action: data ? action : null,
      },
      children: {
        tag: 'form',
        props: {
          ...restProps,
          ref,
        },
        type: 'form',
        ref,
      },
    },
    f: isDirty,
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
  } as any
}

const formActionableElement = (
  tag: string,
  {
    formAction,
    ...props
  }: {
    formAction?: Function | string
    ref?: RefObject<HTMLInputElement> | ((e: HTMLInputElement) => void | (() => void))
  }
) => {
  if (typeof formAction === 'function') {
    const onClick = useCallback<(ev: MouseEvent) => void>((ev: MouseEvent) => {
      ev.preventDefault()
      ;(ev.currentTarget! as HTMLInputElement).form!.dispatchEvent(
        new CustomEvent('submit', { detail: { [customEventFormAction]: formAction } })
      )
    }, [])

    props.ref = composeRef(props.ref, (el: HTMLInputElement) => {
      el.addEventListener('click', onClick)
      return () => {
        el.removeEventListener('click', onClick)
      }
    })
  }

  return {
    tag,
    props,
    type: tag,
    ref: props.ref,
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
  } as any
}

export const input: FC<PropsWithChildren<IntrinsicElements['input']>> = (props) =>
  formActionableElement('input', props)

export const button: FC<PropsWithChildren<IntrinsicElements['button']>> = (props) =>
  formActionableElement('button', props)

Object.assign(domRenderers, {
  title,
  script,
  style,
  link,
  meta,
  form,
  input,
  button,
})

```
