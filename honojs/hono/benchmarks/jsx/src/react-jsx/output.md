/Users/josh/Documents/GitHub/honojs/hono/benchmarks/jsx/src/react-jsx/benchmark.ts
```typescript
import { Suite } from 'benchmark'
import { parse } from 'node-html-parser'

import { render as renderHono } from './hono'
import { render as renderNano } from './nano'
import { render as renderPreact } from './preact'
import { render as renderReact } from './react'

const suite = new Suite()

;[renderHono, renderReact, renderPreact, renderNano].forEach((render) => {
  const html = render()
  const doc = parse(html)
  if (doc.querySelector('p#c').textContent !== '3\nc') {
    throw new Error('Invalid output')
  } 
})

suite
  .add('Hono', () => {
    renderHono()
  })
  .add('React', () => {
    renderReact()
  })
  .add('Preact', () => {
    renderPreact()
  })
  .add('Nano', () => {
    renderNano()
  })
  .on('cycle', (ev) => {
    console.log(String(ev.target))
  })
  .on('complete', (ev) => {
    console.log(`Fastest is ${ev.currentTarget.filter('fastest').map('name')}`)
  })
  .run({ async: true })

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/jsx/src/react-jsx/hono.ts
```typescript
import { buildPage } from './page-hono'

export const render = () => buildPage()().toString()
```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/jsx/src/react-jsx/nano.ts
```typescript
import { renderSSR } from 'nano-jsx'
import { buildPage } from './page-nano.tsx'

export const render = () => renderSSR(buildPage())
```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/jsx/src/react-jsx/page-hono.tsx
```
/** @jsxImportSource ../../../../src/jsx **/

export const buildPage = () => {
  const Content = () => (
    <>
      <p id='a' class='class-name'>
        1<br />a
      </p>
      <p id='b' class='class-name'>
        2<br />b
      </p>
      <div dangerouslySetInnerHTML={{ __html: '<p id="c" class="class-name">3<br/>c</p>' }} />
      {null}
      {undefined}
    </>
  )

  const Form = () => (
    <form>
      <input type='text' value='1234567890 < 1234567891' readonly tabindex={1} />
      <input type='checkbox' value='1234567890 < 1234567891' checked={true} tabindex={2} />
      <input type='checkbox' value='1234567890 < 1234567891' checked={true} tabindex={3} />
      <input type='checkbox' value='1234567890 < 1234567891' checked={false} tabindex={4} />
      <input type='checkbox' value='1234567890 < 1234567891' checked={false} tabindex={5} />
    </form>
  )

  return () => (
    <html>
      <body>
        <Content />
        <Form />
      </body>
    </html>
  )
}

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/jsx/src/react-jsx/page-nano.tsx
```
/** @jsxImportSource nano-jsx/lib **/

export const buildPage = () => {
  const Content = () => (
    <>
      <p id='a' class='class-name'>
        1<br />a
      </p>
      <p id='b' class='class-name'>
        2<br />b
      </p>
      <div dangerouslySetInnerHTML={{ __html: '<p id="c" class="class-name">3<br/>c</p>' }} />
      {null}
      {undefined}
    </>
  )

  const Form = () => (
    <form>
      <input type='text' value='1234567890 < 1234567891' readonly tabindex={1} />
      <input type='checkbox' value='1234567890 < 1234567891' checked={true} tabindex={2} />
      <input type='checkbox' value='1234567890 < 1234567891' checked={true} tabindex={3} />
      <input type='checkbox' value='1234567890 < 1234567891' checked={false} tabindex={4} />
      <input type='checkbox' value='1234567890 < 1234567891' checked={false} tabindex={5} />
    </form>
  )

  return () => (
    <html>
      <body>
        <Content />
        <Form />
      </body>
    </html>
  )
}

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/jsx/src/react-jsx/page-preact.tsx
```
/** @jsxImportSource preact **/

export const buildPage = () => {
  const Content = () => (
    <>
      <p id='a' class='class-name'>
        1<br />a
      </p>
      <p id='b' class='class-name'>
        2<br />b
      </p>
      <div dangerouslySetInnerHTML={{ __html: '<p id="c" class="class-name">3<br/>c</p>' }} />
      {null}
      {undefined}
    </>
  )

  const Form = () => (
    <form>
      <input type='text' value='1234567890 < 1234567891' readonly tabindex={1} />
      <input type='checkbox' value='1234567890 < 1234567891' checked={true} tabindex={2} />
      <input type='checkbox' value='1234567890 < 1234567891' checked={true} tabindex={3} />
      <input type='checkbox' value='1234567890 < 1234567891' checked={false} tabindex={4} />
      <input type='checkbox' value='1234567890 < 1234567891' checked={false} tabindex={5} />
    </form>
  )

  return () => (
    <html>
      <body>
        <Content />
        <Form />
      </body>
    </html>
  )
}

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/jsx/src/react-jsx/page-react.tsx
```
/** @jsxImportSource react **/

export const buildPage = () => {
  const Content = () => (
    <>
      <p id='a' className='class-name'>
        1<br />a
      </p>
      <p id='b' className='class-name'>
        2<br />b
      </p>
      <div dangerouslySetInnerHTML={{ __html: '<p id="c" class="class-name">3<br/>c</p>' }} />
      {null}
      {undefined}
    </>
  )

  const Form = () => (
    <form>
      <input type='text' value='1234567890 < 1234567891' readOnly tabIndex={1} />
      <input type='checkbox' value='1234567890 < 1234567891' defaultChecked={true} tabIndex={2} />
      <input type='checkbox' value='1234567890 < 1234567891' defaultChecked={true} tabIndex={3} />
      <input type='checkbox' value='1234567890 < 1234567891' defaultChecked={false} tabIndex={4} />
      <input type='checkbox' value='1234567890 < 1234567891' defaultChecked={false} tabIndex={5} />
    </form>
  )

  return () => (
    <html>
      <body>
        <Content />
        <Form />
      </body>
    </html>
  )
}

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/jsx/src/react-jsx/preact.ts
```typescript
import { renderToString } from 'preact-render-to-string'
import { buildPage } from './page-preact'

export const render = () => renderToString(buildPage()() as any)
```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/jsx/src/react-jsx/react.ts
```typescript
import { renderToString } from 'react-dom/server'
import { buildPage } from './page-react.tsx'

export const render = () => renderToString(buildPage()() as any)

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/jsx/src/react-jsx/tsconfig.json
```json
{
  "compilerOptions": {
    "jsx": "react-jsx",
  }
}
```
