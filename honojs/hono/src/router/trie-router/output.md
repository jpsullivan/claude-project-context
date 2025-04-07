/Users/josh/Documents/GitHub/honojs/hono/src/router/trie-router/index.ts
```typescript
/**
 * @module
 * TrieRouter for Hono.
 */

export { TrieRouter } from './router'

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/trie-router/node.test.ts
```typescript
import { Node } from './node'

describe('Root Node', () => {
  const node = new Node()
  node.insert('get', '/', 'get root')
  it('get /', () => {
    const [res] = node.search('get', '/')
    expect(res).not.toBeNull()
    expect(res[0][0]).toEqual('get root')
    expect(node.search('get', '/hello')[0].length).toBe(0)
  })
})

describe('Root Node is not defined', () => {
  const node = new Node()
  node.insert('get', '/hello', 'get hello')
  it('get /', () => {
    expect(node.search('get', '/')[0]).toEqual([])
  })
})

describe('Get with *', () => {
  const node = new Node()
  node.insert('get', '*', 'get all')
  it('get /', () => {
    expect(node.search('get', '/')[0].length).toBe(1)
    expect(node.search('get', '/hello')[0].length).toBe(1)
  })
})

describe('Get with * including JS reserved words', () => {
  const node = new Node()
  node.insert('get', '*', 'get all')
  it('get /', () => {
    expect(node.search('get', '/hello/constructor')[0].length).toBe(1)
    expect(node.search('get', '/hello/__proto__')[0].length).toBe(1)
  })
})

describe('Basic Usage', () => {
  const node = new Node()
  node.insert('get', '/hello', 'get hello')
  node.insert('post', '/hello', 'post hello')
  node.insert('get', '/hello/foo', 'get hello foo')

  it('get, post /hello', () => {
    expect(node.search('get', '/')[0].length).toBe(0)
    expect(node.search('post', '/')[0].length).toBe(0)

    expect(node.search('get', '/hello')[0][0][0]).toEqual('get hello')
    expect(node.search('post', '/hello')[0][0][0]).toEqual('post hello')
    expect(node.search('put', '/hello')[0].length).toBe(0)
  })
  it('get /nothing', () => {
    expect(node.search('get', '/nothing')[0].length).toBe(0)
  })
  it('/hello/foo, /hello/bar', () => {
    expect(node.search('get', '/hello/foo')[0][0][0]).toEqual('get hello foo')
    expect(node.search('post', '/hello/foo')[0].length).toBe(0)
    expect(node.search('get', '/hello/bar')[0].length).toBe(0)
  })
  it('/hello/foo/bar', () => {
    expect(node.search('get', '/hello/foo/bar')[0].length).toBe(0)
  })
})

describe('Name path', () => {
  const node = new Node()
  node.insert('get', '/entry/:id', 'get entry')
  node.insert('get', '/entry/:id/comment/:comment_id', 'get comment')
  node.insert('get', '/map/:location/events', 'get events')
  node.insert('get', '/about/:name/address/map', 'get address')

  it('get /entry/123', () => {
    const [res] = node.search('get', '/entry/123')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('get entry')
    expect(res[0][1]).not.toBeNull()
    expect(res[0][1]['id']).toBe('123')
    expect(res[0][1]['id']).not.toBe('1234')
  })

  it('get /entry/456/comment', () => {
    const [res] = node.search('get', '/entry/456/comment')
    expect(res.length).toBe(0)
  })

  it('get /entry/789/comment/123', () => {
    const [res] = node.search('get', '/entry/789/comment/123')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('get comment')
    expect(res[0][1]['id']).toBe('789')
    expect(res[0][1]['comment_id']).toBe('123')
  })

  it('get /map/:location/events', () => {
    const [res] = node.search('get', '/map/yokohama/events')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('get events')
    expect(res[0][1]['location']).toBe('yokohama')
  })

  it('get /about/:name/address/map', () => {
    const [res] = node.search('get', '/about/foo/address/map')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('get address')
    expect(res[0][1]['name']).toBe('foo')
  })

  it('Should not return a previous param value', () => {
    const node = new Node()
    node.insert('delete', '/resource/:id', 'resource')
    const [resA] = node.search('delete', '/resource/a')
    const [resB] = node.search('delete', '/resource/b')
    expect(resA).not.toBeNull()
    expect(resA.length).toBe(1)
    expect(resA[0][0]).toEqual('resource')
    expect(resA[0][1]).toEqual({ id: 'a' })
    expect(resB).not.toBeNull()
    expect(resB.length).toBe(1)
    expect(resB[0][0]).toEqual('resource')
    expect(resB[0][1]).toEqual({ id: 'b' })
  })

  it('Should return a sorted values', () => {
    const node = new Node()
    node.insert('get', '/resource/a', 'A')
    node.insert('get', '/resource/*', 'Star')
    const [res] = node.search('get', '/resource/a')
    expect(res).not.toBeNull()
    expect(res.length).toBe(2)
    expect(res[0][0]).toEqual('A')
    expect(res[1][0]).toEqual('Star')
  })
})

describe('Name path - Multiple route', () => {
  const node = new Node()

  node.insert('get', '/:type/:id', 'common')
  node.insert('get', '/posts/:id', 'specialized')

  it('get /posts/123', () => {
    const [res] = node.search('get', '/posts/123')
    expect(res.length).toBe(2)
    expect(res[0][0]).toEqual('common')
    expect(res[0][1]['id']).toBe('123')
    expect(res[1][0]).toEqual('specialized')
    expect(res[1][1]['id']).toBe('123')
  })
})

describe('Param prefix', () => {
  const node = new Node()

  node.insert('get', '/:foo', 'onepart')
  node.insert('get', '/:bar/:baz', 'twopart')

  it('get /hello', () => {
    const [res] = node.search('get', '/hello')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('onepart')
    expect(res[0][1]['foo']).toBe('hello')
  })

  it('get /hello/world', () => {
    const [res] = node.search('get', '/hello/world')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('twopart')
    expect(res[0][1]['bar']).toBe('hello')
    expect(res[0][1]['baz']).toBe('world')
  })
})

describe('Named params and a wildcard', () => {
  const node = new Node()

  node.insert('get', '/:id/*', 'onepart')

  it('get /', () => {
    const [res] = node.search('get', '/')
    expect(res.length).toBe(0)
  })

  it('get /foo', () => {
    const [res] = node.search('get', '/foo')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('onepart')
    expect(res[0][1]['id']).toEqual('foo')
  })

  it('get /foo/bar', () => {
    const [res] = node.search('get', '/foo/bar')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('onepart')
    expect(res[0][1]['id']).toEqual('foo')
  })
})

describe('Wildcard', () => {
  const node = new Node()
  node.insert('get', '/wildcard-abc/*/wildcard-efg', 'wildcard')
  it('/wildcard-abc/xxxxxx/wildcard-efg', () => {
    const [res] = node.search('get', '/wildcard-abc/xxxxxx/wildcard-efg')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('wildcard')
  })
  node.insert('get', '/wildcard-abc/*/wildcard-efg/hijk', 'wildcard')
  it('/wildcard-abc/xxxxxx/wildcard-efg/hijk', () => {
    const [res] = node.search('get', '/wildcard-abc/xxxxxx/wildcard-efg/hijk')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('wildcard')
  })
})

describe('Regexp', () => {
  const node = new Node()
  node.insert('get', '/regex-abc/:id{[0-9]+}/comment/:comment_id{[a-z]+}', 'regexp')
  it('/regexp-abc/123/comment/abc', () => {
    const [res] = node.search('get', '/regex-abc/123/comment/abc')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('regexp')
    expect(res[0][1]['id']).toBe('123')
    expect(res[0][1]['comment_id']).toBe('abc')
  })
  it('/regexp-abc/abc', () => {
    const [res] = node.search('get', '/regex-abc/abc')
    expect(res.length).toBe(0)
  })
  it('/regexp-abc/123/comment/123', () => {
    const [res] = node.search('get', '/regex-abc/123/comment/123')
    expect(res.length).toBe(0)
  })
})

describe('All', () => {
  const node = new Node()
  node.insert('ALL', '/all-methods', 'all methods') // ALL
  it('/all-methods', () => {
    let [res] = node.search('get', '/all-methods')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('all methods')
    ;[res] = node.search('put', '/all-methods')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('all methods')
  })
})

describe('Special Wildcard', () => {
  const node = new Node()
  node.insert('ALL', '*', 'match all')

  it('/foo', () => {
    const [res] = node.search('get', '/foo')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('match all')
  })
  it('/hello', () => {
    const [res] = node.search('get', '/hello')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('match all')
  })
  it('/hello/foo', () => {
    const [res] = node.search('get', '/hello/foo')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('match all')
  })
})

describe('Special Wildcard deeply', () => {
  const node = new Node()
  node.insert('ALL', '/hello/*', 'match hello')
  it('/hello', () => {
    const [res] = node.search('get', '/hello')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('match hello')
  })
  it('/hello/foo', () => {
    const [res] = node.search('get', '/hello/foo')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('match hello')
  })
})

describe('Default with wildcard', () => {
  const node = new Node()
  node.insert('ALL', '/api/*', 'fallback')
  node.insert('ALL', '/api/abc', 'match api')
  it('/api/abc', () => {
    const [res] = node.search('get', '/api/abc')
    expect(res.length).toBe(2)
    expect(res[0][0]).toEqual('fallback')
    expect(res[1][0]).toEqual('match api')
  })
  it('/api/def', () => {
    const [res] = node.search('get', '/api/def')
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('fallback')
  })
})

describe('Multi match', () => {
  describe('Basic', () => {
    const node = new Node()
    node.insert('get', '*', 'GET *')
    node.insert('get', '/abc/*', 'GET /abc/*')
    node.insert('get', '/abc/*/edf', 'GET /abc/*/edf')
    node.insert('get', '/abc/edf', 'GET /abc/edf')
    node.insert('get', '/abc/*/ghi/jkl', 'GET /abc/*/ghi/jkl')
    it('get /abc/edf', () => {
      const [res] = node.search('get', '/abc/edf')
      expect(res.length).toBe(3)
      expect(res[0][0]).toEqual('GET *')
      expect(res[1][0]).toEqual('GET /abc/*')
      expect(res[2][0]).toEqual('GET /abc/edf')
    })
    it('get /abc/xxx/edf', () => {
      const [res] = node.search('get', '/abc/xxx/edf')
      expect(res.length).toBe(3)
      expect(res[0][0]).toEqual('GET *')
      expect(res[1][0]).toEqual('GET /abc/*')
      expect(res[2][0]).toEqual('GET /abc/*/edf')
    })
    it('get /', () => {
      const [res] = node.search('get', '/')
      expect(res.length).toBe(1)
      expect(res[0][0]).toEqual('GET *')
    })
    it('post /', () => {
      const [res] = node.search('post', '/')
      expect(res.length).toBe(0)
    })
    it('get /abc/edf/ghi', () => {
      const [res] = node.search('get', '/abc/edf/ghi')
      expect(res.length).toBe(2)
      expect(res[0][0]).toEqual('GET *')
      expect(res[1][0]).toEqual('GET /abc/*')
    })
  })
  describe('Blog', () => {
    const node = new Node()
    node.insert('get', '*', 'middleware a') // 0.1
    node.insert('ALL', '*', 'middleware b') // 0.2 <===
    node.insert('get', '/entry', 'get entries') // 1.3
    node.insert('post', '/entry/*', 'middleware c') // 1.4 <===
    node.insert('post', '/entry', 'post entry') // 1.5 <===
    node.insert('get', '/entry/:id', 'get entry') // 2.6
    node.insert('get', '/entry/:id/comment/:comment_id', 'get comment') // 4.7
    it('get /entry/123', async () => {
      const [res] = node.search('get', '/entry/123')
      expect(res.length).toBe(3)
      expect(res[0][0]).toEqual('middleware a')
      expect(res[0][1]['id']).toBe(undefined)
      expect(res[1][0]).toEqual('middleware b')
      expect(res[1][1]['id']).toBe(undefined)
      expect(res[2][0]).toEqual('get entry')
      expect(res[2][1]['id']).toBe('123')
    })
    it('get /entry/123/comment/456', async () => {
      const [res] = node.search('get', '/entry/123/comment/456')
      expect(res.length).toBe(3)
      expect(res[0][0]).toEqual('middleware a')
      expect(res[0][1]['id']).toBe(undefined)
      expect(res[0][1]['comment_id']).toBe(undefined)
      expect(res[1][0]).toEqual('middleware b')
      expect(res[1][1]['id']).toBe(undefined)
      expect(res[1][1]['comment_id']).toBe(undefined)
      expect(res[2][0]).toEqual('get comment')
      expect(res[2][1]['id']).toBe('123')
      expect(res[2][1]['comment_id']).toBe('456')
    })
    it('post /entry', async () => {
      const [res] = node.search('post', '/entry')
      expect(res.length).toBe(3)
      expect(res[0][0]).toEqual('middleware b')
      expect(res[1][0]).toEqual('middleware c')
      expect(res[2][0]).toEqual('post entry')
    })
    it('delete /entry', async () => {
      const [res] = node.search('delete', '/entry')
      expect(res.length).toBe(1)
      expect(res[0][0]).toEqual('middleware b')
    })
  })
  describe('ALL', () => {
    const node = new Node()
    node.insert('ALL', '*', 'ALL *')
    node.insert('ALL', '/abc/*', 'ALL /abc/*')
    node.insert('ALL', '/abc/*/def', 'ALL /abc/*/def')
    it('get /', () => {
      const [res] = node.search('get', '/')
      expect(res.length).toBe(1)
      expect(res[0][0]).toEqual('ALL *')
    })
    it('post /abc', () => {
      const [res] = node.search('post', '/abc')
      expect(res.length).toBe(2)
      expect(res[0][0]).toEqual('ALL *')
      expect(res[1][0]).toEqual('ALL /abc/*')
    })
    it('delete /abc/xxx/def', () => {
      const [res] = node.search('post', '/abc/xxx/def')
      expect(res.length).toBe(3)
      expect(res[0][0]).toEqual('ALL *')
      expect(res[1][0]).toEqual('ALL /abc/*')
      expect(res[2][0]).toEqual('ALL /abc/*/def')
    })
  })
  describe('Regexp', () => {
    const node = new Node()
    node.insert('get', '/regex-abc/:id{[0-9]+}/*', 'middleware a')
    node.insert('get', '/regex-abc/:id{[0-9]+}/def', 'regexp')
    it('/regexp-abc/123/def', () => {
      const [res] = node.search('get', '/regex-abc/123/def')
      expect(res.length).toBe(2)
      expect(res[0][0]).toEqual('middleware a')
      expect(res[0][1]['id']).toBe('123')
      expect(res[1][0]).toEqual('regexp')
      expect(res[1][1]['id']).toBe('123')
    })
    it('/regexp-abc/123', () => {
      const [res] = node.search('get', '/regex-abc/123/ghi')
      expect(res.length).toBe(1)
      expect(res[0][0]).toEqual('middleware a')
    })
  })
  describe('Trailing slash', () => {
    const node = new Node()
    node.insert('get', '/book', 'GET /book')
    node.insert('get', '/book/:id', 'GET /book/:id')
    it('get /book', () => {
      const [res] = node.search('get', '/book')
      expect(res.length).toBe(1)
    })
    it('get /book/', () => {
      const [res] = node.search('get', '/book/')
      expect(res.length).toBe(0)
    })
  })
  describe('Same path', () => {
    const node = new Node()
    node.insert('get', '/hey', 'Middleware A')
    node.insert('get', '/hey', 'Middleware B')
    it('get /hey', () => {
      const [res] = node.search('get', '/hey')
      expect(res.length).toBe(2)
      expect(res[0][0]).toEqual('Middleware A')
      expect(res[1][0]).toEqual('Middleware B')
    })
  })
  describe('Including slashes', () => {
    const node = new Node()
    node.insert('get', '/js/:filename{[a-z0-9/]+.js}', 'any file')
    node.insert('get', '/js/main.js', 'main.js')
    it('get /js/main.js', () => {
      const [res] = node.search('get', '/js/main.js')
      expect(res.length).toBe(2)
      expect(res[0][0]).toEqual('any file')
      expect(res[0][1]).toEqual({ filename: 'main.js' })
      expect(res[1][0]).toEqual('main.js')
      expect(res[1][1]).toEqual({})
    })
    it('get /js/chunk/123.js', () => {
      const [res] = node.search('get', '/js/chunk/123.js')
      expect(res.length).toBe(1)
      expect(res[0][0]).toEqual('any file')
      expect(res[0][1]).toEqual({ filename: 'chunk/123.js' })
    })
    it('get /js/chunk/nest/123.js', () => {
      const [res] = node.search('get', '/js/chunk/nest/123.js')
      expect(res.length).toBe(1)
      expect(res[0][0]).toEqual('any file')
      expect(res[0][1]).toEqual({ filename: 'chunk/nest/123.js' })
    })
  })
  describe('REST API', () => {
    const node = new Node()
    node.insert('get', '/users/:username{[a-z]+}', 'profile')
    node.insert('get', '/users/:username{[a-z]+}/posts', 'posts')
    it('get /users/hono', () => {
      const [res] = node.search('get', '/users/hono')
      expect(res.length).toBe(1)
      expect(res[0][0]).toEqual('profile')
    })
    it('get /users/hono/posts', () => {
      const [res] = node.search('get', '/users/hono/posts')
      expect(res.length).toBe(1)
      expect(res[0][0]).toEqual('posts')
    })
  })
})

describe('Duplicate param name', () => {
  it('self', () => {
    const node = new Node()
    node.insert('get', '/:id/:id', 'foo')
    const [res] = node.search('get', '/123/456')
    expect(res.length).toBe(1)
    expect(res[0][0]).toBe('foo')
    expect(res[0][1]['id']).toBe('123')
  })

  describe('parent', () => {
    const node = new Node()
    node.insert('get', '/:id/:action', 'foo')
    node.insert('get', '/posts/:id', 'bar')
    node.insert('get', '/posts/:id/comments/:comment_id', 'comment')

    it('get /123/action', () => {
      const [res] = node.search('get', '/123/action')
      expect(res.length).toBe(1)
      expect(res[0][0]).toBe('foo')
      expect(res[0][1]).toEqual({ id: '123', action: 'action' })
    })
  })

  it('get /posts/456 for comments', () => {
    const node = new Node()
    node.insert('get', '/posts/:id/comments/:comment_id', 'comment')
    const [res] = node.search('get', '/posts/abc/comments/edf')
    expect(res.length).toBe(1)
    expect(res[0][0]).toBe('comment')
    expect(res[0][1]).toEqual({ id: 'abc', comment_id: 'edf' })
  })

  describe('child', () => {
    const node = new Node()
    node.insert('get', '/posts/:id', 'foo')
    node.insert('get', '/:id/:action', 'bar')
    it('get /posts/action', () => {
      const [res] = node.search('get', '/posts/action')
      expect(res.length).toBe(2)
      expect(res[0][0]).toBe('foo')
      expect(res[0][1]).toEqual({ id: 'action' })
      expect(res[1][0]).toBe('bar')
      expect(res[1][1]).toEqual({ id: 'posts', action: 'action' })
    })
  })

  describe('regular expression', () => {
    const node = new Node()
    node.insert('get', '/:id/:action{create|update}', 'foo')
    node.insert('get', '/:id/:action{delete}', 'bar')
    it('get /123/create', () => {
      const [res] = node.search('get', '/123/create')
      expect(res.length).toBe(1)
      expect(res[0][0]).toBe('foo')
      expect(res[0][1]).toEqual({ id: '123', action: 'create' })
    })
    it('get /123/delete', () => {
      const [res] = node.search('get', '/123/delete')
      expect(res.length).toBe(1)
      expect(res[0][0]).toBe('bar')
      expect(res[0][1]).toEqual({ id: '123', action: 'delete' })
    })
  })
})

describe('Sort Order', () => {
  describe('Basic', () => {
    const node = new Node()
    node.insert('get', '*', 'a')
    node.insert('get', '/page', '/page')
    node.insert('get', '/:slug', '/:slug')

    it('get /page', () => {
      const [res] = node.search('get', '/page')
      expect(res.length).toBe(3)
      expect(res[0][0]).toEqual('a')
      expect(res[1][0]).toEqual('/page')
      expect(res[2][0]).toEqual('/:slug')
    })
  })

  describe('With Named path', () => {
    const node = new Node()
    node.insert('get', '*', 'a')
    node.insert('get', '/posts/:id', '/posts/:id')
    node.insert('get', '/:type/:id', '/:type/:id')

    it('get /posts/123', () => {
      const [res] = node.search('get', '/posts/123')
      expect(res.length).toBe(3)
      expect(res[0][0]).toEqual('a')
      expect(res[1][0]).toEqual('/posts/:id')
      expect(res[2][0]).toEqual('/:type/:id')
    })
  })

  describe('With Wildcards', () => {
    const node = new Node()
    node.insert('get', '/api/*', '1st')
    node.insert('get', '/api/*', '2nd')
    node.insert('get', '/api/posts/:id', '3rd')
    node.insert('get', '/api/*', '4th')

    it('get /api/posts/123', () => {
      const [res] = node.search('get', '/api/posts/123')
      expect(res.length).toBe(4)
      expect(res[0][0]).toEqual('1st')
      expect(res[1][0]).toEqual('2nd')
      expect(res[2][0]).toEqual('3rd')
      expect(res[3][0]).toEqual('4th')
    })
  })

  describe('With special Wildcard', () => {
    const node = new Node()
    node.insert('get', '/posts', '/posts') // 1.1
    node.insert('get', '/posts/*', '/posts/*') // 1.2
    node.insert('get', '/posts/:id', '/posts/:id') // 2.3

    it('get /posts', () => {
      const [res] = node.search('get', '/posts')
      expect(res.length).toBe(2)
      expect(res[0][0]).toEqual('/posts')
      expect(res[1][0]).toEqual('/posts/*')
    })
  })

  describe('Complex', () => {
    const node = new Node()
    node.insert('get', '/api', 'a') // not match
    node.insert('get', '/api/*', 'b') // match
    node.insert('get', '/api/:type', 'c') // not match
    node.insert('get', '/api/:type/:id', 'd') // match
    node.insert('get', '/api/posts/:id', 'e') // match
    node.insert('get', '/api/posts/123', 'f') // match
    node.insert('get', '/*/*/:id', 'g') // match
    node.insert('get', '/api/posts/*/comment', 'h') // not match
    node.insert('get', '*', 'i') // match
    node.insert('get', '*', 'j') // match

    it('get /api/posts/123', () => {
      const [res] = node.search('get', '/api/posts/123')
      expect(res.length).toBe(7)
      expect(res[0][0]).toEqual('b')
      expect(res[1][0]).toEqual('d')
      expect(res[2][0]).toEqual('e')
      expect(res[3][0]).toEqual('f')
      expect(res[4][0]).toEqual('g')
      expect(res[5][0]).toEqual('i')
      expect(res[6][0]).toEqual('j')
    })
  })

  describe('Multi match', () => {
    const node = new Node()
    node.insert('get', '*', 'GET *') // 0.1
    node.insert('get', '/abc/*', 'GET /abc/*') // 1.2
    node.insert('get', '/abc/edf', 'GET /abc/edf') // 2.3
    node.insert('get', '/abc/*/ghi/jkl', 'GET /abc/*/ghi/jkl') // 4.4
    it('get /abc/edf', () => {
      const [res] = node.search('get', '/abc/edf')
      expect(res.length).toBe(3)
      expect(res[0][0]).toEqual('GET *')
      expect(res[1][0]).toEqual('GET /abc/*')
      expect(res[2][0]).toEqual('GET /abc/edf')
    })
  })

  describe('Multi match', () => {
    const node = new Node()

    node.insert('get', '/api/*', 'a') // 2.1 for /api/entry
    node.insert('get', '/api/entry', 'entry') // 2.2
    node.insert('ALL', '/api/*', 'b') // 2.3 for /api/entry

    it('get /api/entry', async () => {
      const [res] = node.search('get', '/api/entry')
      expect(res.length).toBe(3)
      expect(res[0][0]).toEqual('a')
      expect(res[1][0]).toEqual('entry')
      expect(res[2][0]).toEqual('b')
    })
  })

  describe('fallback', () => {
    describe('Blog - failed', () => {
      const node = new Node()
      node.insert('post', '/entry', 'post entry') // 1.1
      node.insert('post', '/entry/*', 'fallback') // 1.2
      node.insert('get', '/entry/:id', 'get entry') // 2.3
      it('post /entry', async () => {
        const [res] = node.search('post', '/entry')
        expect(res.length).toBe(2)
        expect(res[0][0]).toEqual('post entry')
        expect(res[1][0]).toEqual('fallback')
      })
    })
  })
  describe('page', () => {
    const node = new Node()
    node.insert('get', '/page', 'page') // 1.1
    node.insert('ALL', '/*', 'fallback') // 1.2
    it('get /page', async () => {
      const [res] = node.search('get', '/page')
      expect(res.length).toBe(2)
      expect(res[0][0]).toEqual('page')
      expect(res[1][0]).toEqual('fallback')
    })
  })
})

describe('star', () => {
  const node = new Node()
  node.insert('get', '/', '/')
  node.insert('get', '/*', '/*')
  node.insert('get', '*', '*')

  node.insert('get', '/x', '/x')
  node.insert('get', '/x/*', '/x/*')

  it('top', async () => {
    const [res] = node.search('get', '/')
    expect(res.length).toBe(3)
    expect(res[0][0]).toEqual('/')
    expect(res[1][0]).toEqual('/*')
    expect(res[2][0]).toEqual('*')
  })

  it('Under a certain path', async () => {
    const [res] = node.search('get', '/x')
    expect(res.length).toBe(4)
    expect(res[0][0]).toEqual('/*')
    expect(res[1][0]).toEqual('*')
    expect(res[2][0]).toEqual('/x')
    expect(res[3][0]).toEqual('/x/*')
  })
})

describe('Routing order With named parameters', () => {
  const node = new Node()
  node.insert('get', '/book/a', 'no-slug')
  node.insert('get', '/book/:slug', 'slug')
  node.insert('get', '/book/b', 'no-slug-b')
  it('/book/a', () => {
    const [res] = node.search('get', '/book/a')
    expect(res).not.toBeNull()
    expect(res.length).toBe(2)
    expect(res[0][0]).toEqual('no-slug')
    expect(res[0][1]).toEqual({})
    expect(res[1][0]).toEqual('slug')
    expect(res[1][1]).toEqual({ slug: 'a' })
  })
  it('/book/foo', () => {
    const [res] = node.search('get', '/book/foo')
    expect(res).not.toBeNull()
    expect(res.length).toBe(1)
    expect(res[0][0]).toEqual('slug')
    expect(res[0][1]).toEqual({ slug: 'foo' })
    expect(res[0][1]['slug']).toBe('foo')
  })
  it('/book/b', () => {
    const [res] = node.search('get', '/book/b')
    expect(res).not.toBeNull()
    expect(res.length).toBe(2)
    expect(res[0][0]).toEqual('slug')
    expect(res[0][1]).toEqual({ slug: 'b' })
    expect(res[1][0]).toEqual('no-slug-b')
    expect(res[1][1]).toEqual({})
  })
})

describe('The same name is used for path params', () => {
  describe('Basic', () => {
    const node = new Node()
    node.insert('get', '/:a/:b/:c', 'abc')
    node.insert('get', '/:a/:b/:c/:d', 'abcd')
    it('/1/2/3', () => {
      const [res] = node.search('get', '/1/2/3')
      expect(res).not.toBeNull()
      expect(res.length).toBe(1)
      expect(res[0][0]).toEqual('abc')
      expect(res[0][1]).toEqual({ a: '1', b: '2', c: '3' })
    })
  })

  describe('Complex', () => {
    const node = new Node()
    node.insert('get', '/:a', 'a')
    node.insert('get', '/:b/:a', 'ba')
    it('/about/me', () => {
      const [res] = node.search('get', '/about/me')
      expect(res).not.toBeNull()
      expect(res.length).toBe(1)
      expect(res[0][0]).toEqual('ba')
      expect(res[0][1]).toEqual({ b: 'about', a: 'me' })
    })
  })

  describe('Complex with tails', () => {
    const node = new Node()
    node.insert('get', '/:id/:id2/comments', 'a')
    node.insert('get', '/posts/:id/comments', 'b')
    it('/posts/123/comments', () => {
      const [res] = node.search('get', '/posts/123/comments')
      expect(res).not.toBeNull()
      expect(res.length).toBe(2)
      expect(res[0][0]).toEqual('a')
      expect(res[0][1]).toEqual({ id: 'posts', id2: '123' })
      expect(res[1][0]).toEqual('b')
      expect(res[1][1]).toEqual({ id: '123' })
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/trie-router/node.ts
```typescript
import type { Params } from '../../router'
import { METHOD_NAME_ALL } from '../../router'
import type { Pattern } from '../../utils/url'
import { getPattern, splitPath, splitRoutingPath } from '../../utils/url'

type HandlerSet<T> = {
  handler: T
  possibleKeys: string[]
  score: number
}

type HandlerParamsSet<T> = HandlerSet<T> & {
  params: Record<string, string>
}

const emptyParams = Object.create(null)

export class Node<T> {
  #methods: Record<string, HandlerSet<T>>[]

  #children: Record<string, Node<T>>
  #patterns: Pattern[]
  #order: number = 0
  #params: Record<string, string> = emptyParams

  constructor(method?: string, handler?: T, children?: Record<string, Node<T>>) {
    this.#children = children || Object.create(null)
    this.#methods = []
    if (method && handler) {
      const m: Record<string, HandlerSet<T>> = Object.create(null)
      m[method] = { handler, possibleKeys: [], score: 0 }
      this.#methods = [m]
    }
    this.#patterns = []
  }

  insert(method: string, path: string, handler: T): Node<T> {
    this.#order = ++this.#order

    // eslint-disable-next-line @typescript-eslint/no-this-alias
    let curNode: Node<T> = this
    const parts = splitRoutingPath(path)

    const possibleKeys: string[] = []

    for (let i = 0, len = parts.length; i < len; i++) {
      const p: string = parts[i]
      const nextP = parts[i + 1]
      const pattern = getPattern(p, nextP)
      const key = Array.isArray(pattern) ? pattern[0] : p

      if (Object.keys(curNode.#children).includes(key)) {
        curNode = curNode.#children[key]
        const pattern = getPattern(p, nextP)
        if (pattern) {
          possibleKeys.push(pattern[1])
        }
        continue
      }

      curNode.#children[key] = new Node()

      if (pattern) {
        curNode.#patterns.push(pattern)
        possibleKeys.push(pattern[1])
      }
      curNode = curNode.#children[key]
    }

    const m: Record<string, HandlerSet<T>> = Object.create(null)

    const handlerSet: HandlerSet<T> = {
      handler,
      possibleKeys: possibleKeys.filter((v, i, a) => a.indexOf(v) === i),
      score: this.#order,
    }

    m[method] = handlerSet
    curNode.#methods.push(m)

    return curNode
  }

  #getHandlerSets(
    node: Node<T>,
    method: string,
    nodeParams: Record<string, string>,
    params?: Record<string, string>
  ): HandlerParamsSet<T>[] {
    const handlerSets: HandlerParamsSet<T>[] = []
    for (let i = 0, len = node.#methods.length; i < len; i++) {
      const m = node.#methods[i]
      const handlerSet = (m[method] || m[METHOD_NAME_ALL]) as HandlerParamsSet<T>
      const processedSet: Record<number, boolean> = {}
      if (handlerSet !== undefined) {
        handlerSet.params = Object.create(null)
        handlerSets.push(handlerSet)
        if (nodeParams !== emptyParams || (params && params !== emptyParams)) {
          for (let i = 0, len = handlerSet.possibleKeys.length; i < len; i++) {
            const key = handlerSet.possibleKeys[i]
            const processed = processedSet[handlerSet.score]
            handlerSet.params[key] =
              params?.[key] && !processed ? params[key] : nodeParams[key] ?? params?.[key]
            processedSet[handlerSet.score] = true
          }
        }
      }
    }
    return handlerSets
  }

  search(method: string, path: string): [[T, Params][]] {
    const handlerSets: HandlerParamsSet<T>[] = []
    this.#params = emptyParams

    // eslint-disable-next-line @typescript-eslint/no-this-alias
    const curNode: Node<T> = this
    let curNodes = [curNode]
    const parts = splitPath(path)
    const curNodesQueue: Node<T>[][] = []

    for (let i = 0, len = parts.length; i < len; i++) {
      const part: string = parts[i]
      const isLast = i === len - 1
      const tempNodes: Node<T>[] = []

      for (let j = 0, len2 = curNodes.length; j < len2; j++) {
        const node = curNodes[j]
        const nextNode = node.#children[part]

        if (nextNode) {
          nextNode.#params = node.#params
          if (isLast) {
            // '/hello/*' => match '/hello'
            if (nextNode.#children['*']) {
              handlerSets.push(
                ...this.#getHandlerSets(nextNode.#children['*'], method, node.#params)
              )
            }
            handlerSets.push(...this.#getHandlerSets(nextNode, method, node.#params))
          } else {
            tempNodes.push(nextNode)
          }
        }

        for (let k = 0, len3 = node.#patterns.length; k < len3; k++) {
          const pattern = node.#patterns[k]
          const params = node.#params === emptyParams ? {} : { ...node.#params }

          // Wildcard
          // '/hello/*/foo' => match /hello/bar/foo
          if (pattern === '*') {
            const astNode = node.#children['*']
            if (astNode) {
              handlerSets.push(...this.#getHandlerSets(astNode, method, node.#params))
              astNode.#params = params
              tempNodes.push(astNode)
            }
            continue
          }

          if (part === '') {
            continue
          }

          const [key, name, matcher] = pattern

          const child = node.#children[key]

          // `/js/:filename{[a-z]+.js}` => match /js/chunk/123.js
          const restPathString = parts.slice(i).join('/')
          if (matcher instanceof RegExp) {
            const m = matcher.exec(restPathString)
            if (m) {
              params[name] = m[0]
              handlerSets.push(...this.#getHandlerSets(child, method, node.#params, params))

              if (Object.keys(child.#children).length) {
                child.#params = params
                const componentCount = m[0].match(/\//)?.length ?? 0
                const targetCurNodes = (curNodesQueue[componentCount] ||= [])
                targetCurNodes.push(child)
              }

              continue
            }
          }

          if (matcher === true || matcher.test(part)) {
            params[name] = part
            if (isLast) {
              handlerSets.push(...this.#getHandlerSets(child, method, params, node.#params))
              if (child.#children['*']) {
                handlerSets.push(
                  ...this.#getHandlerSets(child.#children['*'], method, params, node.#params)
                )
              }
            } else {
              child.#params = params
              tempNodes.push(child)
            }
          }
        }
      }

      curNodes = tempNodes.concat(curNodesQueue.shift() ?? [])
    }

    if (handlerSets.length > 1) {
      handlerSets.sort((a, b) => {
        return a.score - b.score
      })
    }

    return [handlerSets.map(({ handler, params }) => [handler, params] as [T, Params])]
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/trie-router/router.test.ts
```typescript
import { runTest } from '../common.case.test'
import { TrieRouter } from './router'

describe('TrieRouter', () => {
  runTest({
    newRouter: () => new TrieRouter(),
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/trie-router/router.ts
```typescript
import type { Result, Router } from '../../router'
import { checkOptionalParameter } from '../../utils/url'
import { Node } from './node'

export class TrieRouter<T> implements Router<T> {
  name: string = 'TrieRouter'
  #node: Node<T>

  constructor() {
    this.#node = new Node()
  }

  add(method: string, path: string, handler: T) {
    const results = checkOptionalParameter(path)
    if (results) {
      for (let i = 0, len = results.length; i < len; i++) {
        this.#node.insert(method, results[i], handler)
      }
      return
    }

    this.#node.insert(method, path, handler)
  }

  match(method: string, path: string): Result<T> {
    return this.#node.search(method, path)
  }
}

```
