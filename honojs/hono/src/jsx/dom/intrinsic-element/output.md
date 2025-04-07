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
