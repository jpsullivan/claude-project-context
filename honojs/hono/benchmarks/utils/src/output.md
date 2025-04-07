/Users/josh/Documents/GitHub/honojs/hono/benchmarks/utils/src/get-path.ts
```typescript
import { run, group, bench } from 'mitata'

bench('noop', () => {})

const request = new Request('http://localhost/about/me')

group('getPath', () => {
  bench('slice + indexOf : w/o decodeURI', () => {
    const url = request.url
    const queryIndex = url.indexOf('?', 8)
    return url.slice(url.indexOf('/', 8), queryIndex === -1 ? undefined : queryIndex)
  })

  bench('regexp : w/o decodeURI', () => {
    const match = request.url.match(/^https?:\/\/[^/]+(\/[^?]*)/)
    return match ? match[1] : ''
  })

  bench('slice + indexOf', () => {
    const url = request.url
    const queryIndex = url.indexOf('?', 8)
    const path = url.slice(url.indexOf('/', 8), queryIndex === -1 ? undefined : queryIndex)
    return path.includes('%') ? decodeURIComponent(path) : path
  })

  bench('slice + for-loop + flag', () => {
    const url = request.url
    let start = url.indexOf('/', 8)
    let i = start
    let hasPercentEncoding = false
    for (; i < url.length; i++) {
      const charCode = url.charCodeAt(i)
      if (charCode === 37) {
        // '%'
        hasPercentEncoding = true
      } else if (charCode === 63) {
        // '?'
        break
      }
    }
    return hasPercentEncoding ? decodeURIComponent(url.slice(start, i)) : url.slice(start, i)
  })

  bench('slice + for-loop + immediate return', () => {
    const url = request.url
    const start = url.indexOf('/', 8)
    let i = start
    for (; i < url.length; i++) {
      const charCode = url.charCodeAt(i)
      if (charCode === 37) {
        // '%'
        // If the path contains percent encoding, use `indexOf()` to find '?' and return the result immediately.
        // Although this is a performance disadvantage, it is acceptable since we prefer cases that do not include percent encoding.
        const queryIndex = url.indexOf('?', i)
        const path = url.slice(start, queryIndex === -1 ? undefined : queryIndex)
        return decodeURI(path.includes('%25') ? path.replace(/%25/g, '%2525') : path)
      } else if (charCode === 63) {
        // '?'
        break
      }
    }
    return url.slice(start, i)
  })
})

run()

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/utils/src/loop.js
```javascript
import { run, group, bench } from 'mitata'

const arr = new Array(100000).fill(Math.random())

bench('noop', () => {})

group('loop', () => {
  bench('map', () => {
    const newArr = []
    arr.map((e) => {
      newArr.push(e)
    })
  })

  bench('forEach', () => {
    const newArr = []
    arr.forEach((e) => {
      newArr.push(e)
    })
  })

  bench('for of', () => {
    const newArr = []
    for (const e of arr) {
      newArr.push(e)
    }
  })

  bench('for', () => {
    const newArr = []
    for (let i = 0; i < arr.length; i++) {
      newArr.push(arr[i])
    }
  })
})

run()

```
