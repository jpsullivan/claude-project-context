/Users/josh/Documents/GitHub/honojs/hono/benchmarks/query-param/src/bench.mts
```
import { run, group, bench } from 'mitata'
import fastQuerystring from './fast-querystring.mts'
import hono from './hono.mts'
import qs from './qs.mts'
;[
  {
    url: 'http://example.com/?page=1',
    key: 'page',
  },
  {
    url: 'http://example.com/?url=http://example.com&page=1',
    key: 'page',
  },
  {
    url: 'http://example.com/?page=1',
    key: undefined,
  },
  {
    url: 'http://example.com/?url=http://example.com&page=1',
    key: undefined,
  },
  {
    url: 'http://example.com/?url=http://example.com/very/very/deep/path/to/something&search=very-long-search-string',
    key: undefined,
  },
  {
    url: 'http://example.com/?search=Hono+is+a+small,+simple,+and+ultrafast+web+framework+for+the+Edge.&page=1',
    key: undefined,
  },
  {
    url: 'http://example.com/?a=1&b=2&c=3&d=4&e=5&f=6&g=7&h=8&i=9&j=10',
    key: undefined,
  },
].forEach((data) => {
  const { url, key } = data

  group(JSON.stringify(data), () => {
    bench('hono', () => hono(url, key))
    bench('fastQuerystring', () => fastQuerystring(url, key))
    bench('qs', () => qs(url, key))
  })
})

run()

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/query-param/src/fast-querystring.mts
```
import { parse } from 'fast-querystring'

const getQueryStringFromURL = (url: string): string => {
  const queryIndex = url.indexOf('?', 8)
  const result = queryIndex !== -1 ? url.slice(queryIndex + 1) : ''
  return result
}

export default (url, key?) => {
  const data = parse(getQueryStringFromURL(url))
  return key !== undefined ? data[key] : data 
}

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/query-param/src/hono.mts
```
import { getQueryParam } from '../../../src/utils/url'

export default (url, key?) => {
  return getQueryParam(url, key)
}

```
/Users/josh/Documents/GitHub/honojs/hono/benchmarks/query-param/src/qs.mts
```
import qs from 'qs'

const getQueryStringFromURL = (url: string): string => {
  const queryIndex = url.indexOf('?', 8)
  const result = queryIndex !== -1 ? url.slice(queryIndex + 1) : ''
  return result
}

export default (url, key?) => {
  const data = qs.parse(getQueryStringFromURL(url))
  return key !== undefined ? data[key] : data
}

```
