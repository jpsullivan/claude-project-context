/Users/josh/Documents/GitHub/honojs/hono/src/helper/html/index.test.ts
```typescript
import { HtmlEscapedCallbackPhase, resolveCallback } from '../../utils/html'
import { html, raw } from '.'

describe('Tagged Template Literals', () => {
  it('Should escape special characters', () => {
    const name = 'John "Johnny" Smith'

    expect(html`<p>I'm ${name}.</p>`.toString()).toBe("<p>I'm John &quot;Johnny&quot; Smith.</p>")
  })

  describe('Booleans, Null, and Undefined Are Ignored', () => {
    it.each([true, false, undefined, null])('%s', (item) => {
      expect(html`${item}`.toString()).toBe('')
    })

    it('falsy value', () => {
      expect(html`${0}`.toString()).toBe('0')
    })
  })

  it('Should call $array.flat(Infinity)', () => {
    const values = [
      'Name:',
      ['John "Johnny" Smith', undefined, null],
      ' Contact:',
      [html`<a href="http://example.com/">My Website</a>`],
    ]
    expect(html`<p>${values}</p>`.toString()).toBe(
      '<p>Name:John &quot;Johnny&quot; Smith Contact:<a href="http://example.com/">My Website</a></p>'
    )
  })

  describe('Promise', () => {
    it('Should return Promise<string> when some variables contains Promise<string> in variables', async () => {
      const name = Promise.resolve('John "Johnny" Smith')
      const res = html`<p>I'm ${name}.</p>`
      expect(res).toBeInstanceOf(Promise)

      expect((await res).toString()).toBe("<p>I'm John &quot;Johnny&quot; Smith.</p>")
    })

    it('Should return raw value when some variables contains Promise<HtmlEscapedString> in variables', async () => {
      const name = Promise.resolve(raw('John "Johnny" Smith'))
      const res = html`<p>I'm ${name}.</p>`
      expect(res).toBeInstanceOf(Promise)
      expect((await res).toString()).toBe('<p>I\'m John "Johnny" Smith.</p>')
    })
  })

  describe('HtmlEscapedString', () => {
    it('Should preserve callbacks', async () => {
      const name = raw('Hono', [
        ({ buffer }) => {
          if (buffer) {
            buffer[0] = buffer[0].replace('Hono', 'Hono!')
          }
          return undefined
        },
      ])
      const res = html`<p>I'm ${name}.</p>`
      expect(res).toBeInstanceOf(Promise)

      expect((await res).toString()).toBe("<p>I'm Hono.</p>")
      expect(await resolveCallback(await res, HtmlEscapedCallbackPhase.Stringify, false, {})).toBe(
        "<p>I'm Hono!.</p>"
      )
    })
  })
})

describe('raw', () => {
  it('Should be marked as escaped.', () => {
    const name = 'John &quot;Johnny&quot; Smith'
    expect(html`<p>I'm ${raw(name)}.</p>`.toString()).toBe(
      "<p>I'm John &quot;Johnny&quot; Smith.</p>"
    )
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/helper/html/index.ts
```typescript
/**
 * @module
 * html Helper for Hono.
 */

import { escapeToBuffer, raw, resolveCallbackSync, stringBufferToString } from '../../utils/html'
import type { HtmlEscaped, HtmlEscapedString, StringBufferWithCallbacks } from '../../utils/html'

export { raw }

export const html = (
  strings: TemplateStringsArray,
  ...values: unknown[]
): HtmlEscapedString | Promise<HtmlEscapedString> => {
  const buffer: StringBufferWithCallbacks = [''] as StringBufferWithCallbacks

  for (let i = 0, len = strings.length - 1; i < len; i++) {
    buffer[0] += strings[i]

    const children = Array.isArray(values[i])
      ? (values[i] as Array<unknown>).flat(Infinity)
      : [values[i]]
    for (let i = 0, len = children.length; i < len; i++) {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const child = children[i] as any
      if (typeof child === 'string') {
        escapeToBuffer(child, buffer)
      } else if (typeof child === 'number') {
        ;(buffer[0] as string) += child
      } else if (typeof child === 'boolean' || child === null || child === undefined) {
        continue
      } else if (typeof child === 'object' && (child as HtmlEscaped).isEscaped) {
        if ((child as HtmlEscapedString).callbacks) {
          buffer.unshift('', child)
        } else {
          const tmp = child.toString()
          if (tmp instanceof Promise) {
            buffer.unshift('', tmp)
          } else {
            buffer[0] += tmp
          }
        }
      } else if (child instanceof Promise) {
        buffer.unshift('', child)
      } else {
        escapeToBuffer(child.toString(), buffer)
      }
    }
  }
  buffer[0] += strings.at(-1) as string

  return buffer.length === 1
    ? 'callbacks' in buffer
      ? raw(resolveCallbackSync(raw(buffer[0], buffer.callbacks)))
      : raw(buffer[0])
    : stringBufferToString(buffer, buffer.callbacks)
}

```
