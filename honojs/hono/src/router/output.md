/Users/josh/Documents/GitHub/honojs/hono/src/router/common.case.test.ts
```typescript
import type { RunnerTestSuite } from 'vitest'
import type { ParamIndexMap, Params, Router } from '../router'

const getSuiteHierarchy = (suite?: RunnerTestSuite) => {
  const res: RunnerTestSuite[] = []
  let s: RunnerTestSuite | undefined = suite
  while (s) {
    res.unshift(s)
    s = s.suite
  }
  return res
}

export const runTest = ({
  skip = [],
  newRouter,
}: {
  skip?: {
    reason: string
    tests: string[]
  }[]
  newRouter: <T>() => Router<T>
}) => {
  describe('Common', () => {
    type Match = (method: string, path: string) => { handler: string; params: Params }[]
    let router: Router<string>
    let match: Match

    beforeEach(({ task, skip: skipTask }) => {
      const suites = getSuiteHierarchy(task.suite)
      const name = [...suites.slice(2).map((s) => s.name), task.name].join(' > ')
      const isSkip = skip.find((s) => s.tests.includes(name))
      if (isSkip) {
        console.log(`Skip: ${isSkip.reason}`)
        skipTask()
        return
      }

      router = newRouter()
      match = (method: string, path: string) => {
        const [matchRes, stash] = router.match(method, path)
        const res = matchRes.map((r) =>
          stash
            ? {
                handler: r[0],
                params: Object.keys(r[1]).reduce((acc, key) => {
                  acc[key] = stash[(r[1] as ParamIndexMap)[key]]
                  return acc
                }, Object.create(null) as Params),
              }
            : { handler: r[0], params: r[1] as Params }
        )
        return res
      }
    })

    describe('Basic Usage', () => {
      beforeEach(() => {
        router.add('GET', '/hello', 'get hello')
        router.add('POST', '/hello', 'post hello')
        router.add('PURGE', '/hello', 'purge hello')
      })

      it('GET, post hello', async () => {
        let res = match('GET', '/hello')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('get hello')
        res = match('POST', '/hello')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('post hello')
        res = match('PURGE', '/hello')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('purge hello')
        res = match('PUT', '/hello')
        expect(res.length).toBe(0)
        res = match('GET', '/')
        expect(res.length).toBe(0)
      })
    })

    describe('Reserved words', () => {
      it('Reserved words and named parameter', async () => {
        router.add('GET', '/entry/:constructor', 'get entry')
        const res = match('GET', '/entry/123')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('get entry')
        expect(res[0].params['constructor']).toBe('123')
      })

      it('Reserved words and wildcard', async () => {
        router.add('GET', '/wild/*/card', 'get wildcard')
        const res = match('GET', '/wild/constructor/card')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('get wildcard')
      })

      it('Reserved words and optional named parameter', async () => {
        router.add('GET', '/api/animals/:constructor?', 'animals')
        const res = match('GET', '/api/animals')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('animals')
        expect(res[0].params['constructor']).toBeUndefined()
      })
    })

    describe('Complex', () => {
      it('Named Param', async () => {
        router.add('GET', '/entry/:id', 'get entry')
        const res = match('GET', '/entry/123')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('get entry')
        expect(res[0].params['id']).toBe('123')
      })

      it('Wildcard', async () => {
        router.add('GET', '/wild/*/card', 'get wildcard')
        const res = match('GET', '/wild/xxx/card')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('get wildcard')
      })

      it('Default', async () => {
        router.add('GET', '/api/abc', 'get api')
        router.add('GET', '/api/*', 'fallback')
        let res = match('GET', '/api/abc')
        expect(res.length).toBe(2)
        expect(res[0].handler).toEqual('get api')
        expect(res[1].handler).toEqual('fallback')
        res = match('GET', '/api/def')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('fallback')
      })

      it('Regexp', async () => {
        router.add('GET', '/post/:date{[0-9]+}/:title{[a-z]+}', 'get post')
        let res = match('GET', '/post/20210101/hello')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('get post')
        expect(res[0].params['date']).toBe('20210101')
        expect(res[0].params['title']).toBe('hello')
        res = match('GET', '/post/onetwothree')
        expect(res.length).toBe(0)
        res = match('GET', '/post/123/123')
        expect(res.length).toBe(0)
      })

      it('/*', async () => {
        router.add('GET', '/api/*', 'auth middleware')
        router.add('GET', '/api', 'top')
        router.add('GET', '/api/posts', 'posts')
        router.add('GET', '/api/*', 'fallback')

        let res = match('GET', '/api')
        expect(res.length).toBe(3)
        expect(res[0].handler).toEqual('auth middleware')
        expect(res[1].handler).toEqual('top')
        expect(res[2].handler).toEqual('fallback')
        res = match('GET', '/api/posts')
        expect(res.length).toBe(3)
        expect(res[0].handler).toEqual('auth middleware')
        expect(res[1].handler).toEqual('posts')
        expect(res[2].handler).toEqual('fallback')
      })
    })

    describe('Registration order', () => {
      it('middleware -> handler', async () => {
        router.add('GET', '*', 'bar')
        router.add('GET', '/:type/:action', 'foo')
        const res = match('GET', '/posts/123')
        expect(res.length).toBe(2)
        expect(res[0].handler).toEqual('bar')
        expect(res[1].handler).toEqual('foo')
      })

      it('handler -> fallback', async () => {
        router.add('GET', '/:type/:action', 'foo')
        router.add('GET', '*', 'fallback')
        const res = match('GET', '/posts/123')
        expect(res.length).toBe(2)
        expect(res[0].handler).toEqual('foo')
        expect(res[1].handler).toEqual('fallback')
      })
    })

    describe('Multi match', () => {
      describe('Blog', () => {
        beforeEach(() => {
          router.add('ALL', '*', 'middleware a')
          router.add('GET', '*', 'middleware b')
          router.add('GET', '/entry', 'get entries')
          router.add('POST', '/entry/*', 'middleware c')
          router.add('POST', '/entry', 'post entry')
          router.add('GET', '/entry/:id', 'get entry')
          router.add('GET', '/entry/:id/comment/:comment_id', 'get comment')
        })

        it('GET /', async () => {
          const res = match('GET', '/')
          expect(res.length).toBe(2)
          expect(res[0].handler).toEqual('middleware a')
          expect(res[1].handler).toEqual('middleware b')
        })
        it('GET /entry/123', async () => {
          const res = match('GET', '/entry/123')
          expect(res.length).toBe(3)
          expect(res[0].handler).toEqual('middleware a')
          expect(res[0].params['id']).toBe(undefined)
          expect(res[1].handler).toEqual('middleware b')
          expect(res[1].params['id']).toBe(undefined)
          expect(res[2].handler).toEqual('get entry')
          expect(res[2].params['id']).toBe('123')
        })
        it('GET /entry/123/comment/456', async () => {
          const res = match('GET', '/entry/123/comment/456')
          expect(res.length).toBe(3)
          expect(res[0].handler).toEqual('middleware a')
          expect(res[0].params['id']).toBe(undefined)
          expect(res[0].params['comment_id']).toBe(undefined)
          expect(res[1].handler).toEqual('middleware b')
          expect(res[1].params['id']).toBe(undefined)
          expect(res[1].params['comment_id']).toBe(undefined)
          expect(res[2].handler).toEqual('get comment')
          expect(res[2].params['id']).toBe('123')
          expect(res[2].params['comment_id']).toBe('456')
        })
        it('POST /entry', async () => {
          const res = match('POST', '/entry')
          expect(res.length).toBe(3)
          expect(res[0].handler).toEqual('middleware a')
          expect(res[1].handler).toEqual('middleware c')
          expect(res[2].handler).toEqual('post entry')
        })
        it('DELETE /entry', async () => {
          const res = match('DELETE', '/entry')
          expect(res.length).toBe(1)
          expect(res[0].handler).toEqual('middleware a')
        })
      })

      describe('`params` per a handler', () => {
        beforeEach(() => {
          router.add('ALL', '*', 'middleware a')
          router.add('GET', '/entry/:id/*', 'middleware b')
          router.add('GET', '/entry/:id/:action', 'action')
        })

        it('GET /entry/123/show', async () => {
          const res = match('GET', '/entry/123/show')
          expect(res.length).toBe(3)
          expect(res[0].handler).toEqual('middleware a')
          expect(res[0].params['id']).toBe(undefined)
          expect(res[0].params['action']).toBe(undefined)
          expect(res[1].handler).toEqual('middleware b')
          expect(res[1].params['id']).toBe('123')
          expect(res[1].params['comment_id']).toBe(undefined)
          expect(res[2].handler).toEqual('action')
          expect(res[2].params['id']).toBe('123')
          expect(res[2].params['action']).toBe('show')
        })
      })

      it('hierarchy', () => {
        router.add('GET', '/posts/:id/comments/:comment_id', 'foo')
        router.add('GET', '/posts/:id', 'bar')
        expect(() => {
          router.match('GET', '/')
        }).not.toThrow()
      })
    })

    describe('Duplicate param name', () => {
      it('self', () => {
        router.add('GET', '/:id/:id', 'foo')
        const res = match('GET', '/123/456')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('foo')
        expect(res[0].params['id']).toBe('123')
      })

      it('parent', () => {
        router.add('GET', '/:id/:action', 'foo')
        router.add('GET', '/posts/:id', 'bar')
        const res = match('GET', '/posts/get')
        expect(res.length).toBe(2)
        expect(res[0].handler).toEqual('foo')
        expect(res[0].params['id']).toBe('posts')
        expect(res[0].params['action']).toBe('get')
        expect(res[1].handler).toEqual('bar')
        expect(res[1].params['id']).toBe('get')
      })

      it('child', () => {
        router.add('GET', '/posts/:id', 'foo')
        router.add('GET', '/:id/:action', 'bar')
        const res = match('GET', '/posts/get')
        expect(res.length).toBe(2)
        expect(res[0].handler).toEqual('foo')
        expect(res[0].params['id']).toBe('get')
        expect(res[1].handler).toEqual('bar')
        expect(res[1].params['id']).toBe('posts')
        expect(res[1].params['action']).toBe('get')
      })
    })

    describe('page', () => {
      it('GET /page', async () => {
        router.add('GET', '/page', 'page')
        router.add('ALL', '*', 'fallback') // or '*'

        const res = match('GET', '/page')
        expect(res.length).toBe(2)
        expect(res[0].handler).toEqual('page')
        expect(res[1].handler).toEqual('fallback')
      })
    })

    describe('star', () => {
      beforeEach(() => {
        router.add('GET', '/', '/')
        router.add('GET', '/*', '/*')
        router.add('GET', '*', '*')

        router.add('GET', '/x', '/x')
        router.add('GET', '/x/*', '/x/*')
      })

      it('top', async () => {
        const res = match('GET', '/')
        expect(res.length).toBe(3)
        expect(res[0].handler).toEqual('/')
        expect(res[1].handler).toEqual('/*')
        expect(res[2].handler).toEqual('*')
      })

      it('Under a certain path', async () => {
        const res = match('GET', '/x')
        expect(res.length).toBe(4)
        expect(res[0].handler).toEqual('/*')
        expect(res[1].handler).toEqual('*')
        expect(res[2].handler).toEqual('/x')
        expect(res[3].handler).toEqual('/x/*')
      })
    })

    describe('Optional route', () => {
      beforeEach(() => {
        router.add('GET', '/api/animals/:type?', 'animals')
        router.add('GET', '/v1/:version?/:platform?', 'result')
      })

      it('GET /api/animals/dog', async () => {
        const res = match('GET', '/api/animals/dog')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('animals')
        expect(res[0].params['type']).toBe('dog')
      })
      it('GET /api/animals', async () => {
        const res = match('GET', '/api/animals')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('animals')
        expect(res[0].params['type']).toBeUndefined()
      })
      it('GET /v1/123/abc', () => {
        const res = match('GET', '/v1/123/abc')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('result')
        expect(res[0].params['version']).toBe('123')
        expect(res[0].params['platform']).toBe('abc')
      })
      it('GET /v1/123', () => {
        const res = match('GET', '/v1/123')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('result')
        expect(res[0].params['version']).toBe('123')
        expect(res[0].params['platform']).toBeUndefined()
      })
      it('GET /v1', () => {
        const res = match('GET', '/v1')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('result')
        expect(res[0].params['version']).toBeUndefined()
        expect(res[0].params['platform']).toBeUndefined()
      })
    })

    describe('All', () => {
      beforeEach(() => {
        router.add('GET', '/hello', 'get hello')
        router.add('ALL', '/all', 'get all')
      })

      it('GET, all hello', async () => {
        const res = match('GET', '/all')
        expect(res.length).toBe(1)
      })
    })

    describe('long prefix, then star', () => {
      describe('GET only', () => {
        beforeEach(() => {
          router.add('GET', '/long/prefix/*', 'long-prefix')
          router.add('GET', '/long/*', 'long')
          router.add('GET', '*', 'star1')
          router.add('GET', '*', 'star2')
        })

        it('GET /', () => {
          const res = match('GET', '/')
          expect(res.length).toBe(2)
          expect(res[0].handler).toEqual('star1')
          expect(res[1].handler).toEqual('star2')
        })

        it('GET /long/prefix', () => {
          const res = match('GET', '/long/prefix')
          expect(res.length).toBe(4)
          expect(res[0].handler).toEqual('long-prefix')
          expect(res[1].handler).toEqual('long')
          expect(res[2].handler).toEqual('star1')
          expect(res[3].handler).toEqual('star2')
        })

        it('GET /long/prefix/test', () => {
          const res = match('GET', '/long/prefix/test')
          expect(res.length).toBe(4)
          expect(res[0].handler).toEqual('long-prefix')
          expect(res[1].handler).toEqual('long')
          expect(res[2].handler).toEqual('star1')
          expect(res[3].handler).toEqual('star2')
        })
      })

      describe('ALL and GET', () => {
        beforeEach(() => {
          router.add('ALL', '/long/prefix/*', 'long-prefix')
          router.add('ALL', '/long/*', 'long')
          router.add('GET', '*', 'star1')
          router.add('GET', '*', 'star2')
        })

        it('GET /', () => {
          const res = match('GET', '/')
          expect(res.length).toBe(2)
          expect(res[0].handler).toEqual('star1')
          expect(res[1].handler).toEqual('star2')
        })

        it('GET /long/prefix', () => {
          const res = match('GET', '/long/prefix')
          expect(res.length).toBe(4)
          expect(res[0].handler).toEqual('long-prefix')
          expect(res[1].handler).toEqual('long')
          expect(res[2].handler).toEqual('star1')
          expect(res[3].handler).toEqual('star2')
        })

        it('GET /long/prefix/test', () => {
          const res = match('GET', '/long/prefix/test')
          expect(res.length).toBe(4)
          expect(res[0].handler).toEqual('long-prefix')
          expect(res[1].handler).toEqual('long')
          expect(res[2].handler).toEqual('star1')
          expect(res[3].handler).toEqual('star2')
        })
      })
    })

    describe('Including slashes', () => {
      beforeEach(() => {
        router.add('GET', '/js/:filename{[a-z0-9/]+.js}', 'any file')
      })

      it('GET /js/main.js', () => {
        router.add('GET', '/js/main.js', 'main.js')

        const res = match('GET', '/js/main.js')
        expect(res.length).toBe(2)
        expect(res[0].handler).toEqual('any file')
        expect(res[0].params['filename']).toEqual('main.js')
        expect(res[1].handler).toEqual('main.js')
        expect(res[1].params['filename']).toEqual(undefined)
      })

      it('GET /js/chunk/123.js', () => {
        const res = match('GET', '/js/chunk/123.js')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('any file')
        expect(res[0].params['filename']).toEqual('chunk/123.js')
      })

      it('GET /js/chunk/nest/123.js', () => {
        const res = match('GET', '/js/chunk/nest/123.js')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('any file')
        expect(res[0].params['filename']).toEqual('chunk/nest/123.js')
      })
    })

    describe('Capture simple multiple directories', () => {
      beforeEach(() => {
        router.add('GET', '/:dirs{.+}/file.html', 'file.html')
      })

      it('GET /foo/bar/file.html', () => {
        const res = match('GET', '/foo/bar/file.html')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('file.html')
        expect(res[0].params['dirs']).toEqual('foo/bar')
      })
    })

    describe('Capture regex pattern has trailing wildcard', () => {
      beforeEach(() => {
        router.add('GET', '/:dir{[a-z]+}/*/file.html', 'file.html')
      })

      it('GET /foo/bar/file.html', () => {
        const res = match('GET', '/foo/bar/file.html')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('file.html')
        expect(res[0].params['dir']).toEqual('foo')
      })
    })

    describe('Capture complex multiple directories', () => {
      beforeEach(() => {
        router.add('GET', '/:first{.+}/middle-a/:reference?', '1')
        router.add('GET', '/:first{.+}/middle-b/end-c/:uuid', '2')
        router.add('GET', '/:first{.+}/middle-b/:digest', '3')
      })

      it('GET /part1/middle-b/latest', () => {
        const res = match('GET', '/part1/middle-b/latest')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('3')
        expect(res[0].params['first']).toEqual('part1')
        expect(res[0].params['digest']).toEqual('latest')
      })

      it('GET /part1/middle-b/end-c/latest', () => {
        const res = match('GET', '/part1/middle-b/end-c/latest')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('2')
        expect(res[0].params['first']).toEqual('part1')
        expect(res[0].params['uuid']).toEqual('latest')
      })
    })

    describe('Capture multiple directories and optional', () => {
      beforeEach(() => {
        router.add('GET', '/:prefix{.+}/contents/:id?', 'contents')
      })

      it('GET /foo/bar/contents', () => {
        const res = match('GET', '/foo/bar/contents')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('contents')
        expect(res[0].params['prefix']).toEqual('foo/bar')
        expect(res[0].params['id']).toEqual(undefined)
      })

      it('GET /foo/bar/contents/123', () => {
        const res = match('GET', '/foo/bar/contents/123')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('contents')
        expect(res[0].params['prefix']).toEqual('foo/bar')
        expect(res[0].params['id']).toEqual('123')
      })
    })

    describe('non ascii characters', () => {
      beforeEach(() => {
        router.add('ALL', '/$/*', 'middleware $')
        router.add('GET', '/$/:name', 'get $ name')
        router.add('ALL', '/()/*', 'middleware ()')
        router.add('GET', '/()/:name', 'get () name')
      })

      it('GET /$/hono', () => {
        const res = match('GET', '/$/hono')
        expect(res.length).toBe(2)
        expect(res[0].handler).toEqual('middleware $')
        expect(res[0].params).toEqual({})
        expect(res[1].handler).toEqual('get $ name')
        expect(res[1].params['name']).toEqual('hono')
      })

      it('GET /()/hono', () => {
        const res = match('GET', '/()/hono')
        expect(res.length).toBe(2)
        expect(res[0].handler).toEqual('middleware ()')
        expect(res[0].params).toEqual({})
        expect(res[1].handler).toEqual('get () name')
        expect(res[1].params['name']).toEqual('hono')
      })
    })

    describe('REST API', () => {
      beforeEach(() => {
        router.add('GET', '/users/:username{[a-z]+}', 'profile')
        router.add('GET', '/users/:username{[a-z]+}/posts', 'posts')
      })

      it('GET /users/hono', () => {
        const res = match('GET', '/users/hono')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('profile')
      })

      it('GET /users/hono/posts', () => {
        const res = match('GET', '/users/hono/posts')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('posts')
      })
    })

    describe('Trailing slash', () => {
      beforeEach(() => {
        router.add('GET', '/book', 'GET /book')
        router.add('GET', '/book/:id', 'GET /book/:id')
      })

      it('GET /book', () => {
        const res = match('GET', '/book')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('GET /book')
      })
      it('GET /book/', () => {
        const res = match('GET', '/book/')
        expect(res.length).toBe(0)
      })
    })

    describe('Same path', () => {
      beforeEach(() => {
        router.add('GET', '/hey', 'Middleware A')
        router.add('GET', '/hey', 'Middleware B')
      })

      it('GET /hey', () => {
        const res = match('GET', '/hey')
        expect(res.length).toBe(2)
        expect(res[0].handler).toEqual('Middleware A')
        expect(res[1].handler).toEqual('Middleware B')
      })
    })

    describe('Routing with a hostname', () => {
      beforeEach(() => {
        router.add('GET', 'www1.example.com/hello', 'www1')
        router.add('GET', 'www2.example.com/hello', 'www2')
      })
      it('GET www1.example.com/hello', () => {
        const res = match('GET', 'www1.example.com/hello')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('www1')
      })
      it('GET www2.example.com/hello', () => {
        const res = match('GET', 'www2.example.com/hello')
        expect(res.length).toBe(1)
        expect(res[0].handler).toEqual('www2')
      })
      it('GET /hello', () => {
        const res = match('GET', '/hello')
        expect(res.length).toBe(0)
      })
    })

    describe('static routes of ALL and GET', () => {
      beforeEach(() => {
        router.add('ALL', '/foo', 'foo')
        router.add('GET', '/bar', 'bar')
      })

      it('get /foo', () => {
        const res = match('GET', '/foo')
        expect(res[0].handler).toEqual('foo')
      })
    })

    describe('ALL and Star', () => {
      beforeEach(() => {
        router.add('ALL', '/x', '/x')
        router.add('GET', '*', 'star')
      })

      it('Should return /x and star', async () => {
        const res = match('GET', '/x')
        expect(res.length).toBe(2)
        expect(res[0].handler).toEqual('/x')
        expect(res[1].handler).toEqual('star')
      })
    })

    describe('GET star, ALL static, GET star...', () => {
      beforeEach(() => {
        router.add('GET', '*', 'star1')
        router.add('ALL', '/x', '/x')
        router.add('GET', '*', 'star2')
        router.add('GET', '*', 'star3')
      })

      it('Should return /x and star', async () => {
        const res = match('GET', '/x')
        expect(res.length).toBe(4)
        expect(res[0].handler).toEqual('star1')
        expect(res[1].handler).toEqual('/x')
        expect(res[2].handler).toEqual('star2')
        expect(res[3].handler).toEqual('star3')
      })
    })

    // https://github.com/honojs/hono/issues/699
    describe('GET star, GET static, ALL star...', () => {
      beforeEach(() => {
        router.add('GET', '/y/*', 'star1')
        router.add('GET', '/y/a', 'a')
        router.add('ALL', '/y/b/*', 'star2')
        router.add('GET', '/y/b/bar', 'bar')
      })

      it('Should return star1, star2, and bar', async () => {
        const res = match('GET', '/y/b/bar')
        expect(res.length).toBe(3)
        expect(res[0].handler).toEqual('star1')
        expect(res[1].handler).toEqual('star2')
        expect(res[2].handler).toEqual('bar')
      })
    })

    describe('ALL star, ALL star, GET static, ALL star...', () => {
      beforeEach(() => {
        router.add('ALL', '*', 'wildcard')
        router.add('ALL', '/a/*', 'star1')
        router.add('GET', '/a/foo', 'foo')
        router.add('ALL', '/b/*', 'star2')
        router.add('GET', '/b/bar', 'bar')
      })

      it('Should return wildcard, star2 and bar', async () => {
        const res = match('GET', '/b/bar')
        expect(res.length).toBe(3)
        expect(res[0].handler).toEqual('wildcard')
        expect(res[1].handler).toEqual('star2')
        expect(res[2].handler).toEqual('bar')
      })
    })

    describe('Capture Group', () => {
      describe('Simple capturing group', () => {
        beforeEach(() => {
          router.add('get', '/foo/:capture{(?:bar|baz)}', 'ok')
        })

        it('GET /foo/bar', () => {
          const res = match('get', '/foo/bar')
          expect(res.length).toBe(1)
          expect(res[0].handler).toBe('ok')
          expect(res[0].params['capture']).toBe('bar')
        })

        it('GET /foo/baz', () => {
          const res = match('get', '/foo/baz')
          expect(res.length).toBe(1)
          expect(res[0].handler).toBe('ok')
          expect(res[0].params['capture']).toBe('baz')
        })

        it('GET /foo/qux', () => {
          const res = match('get', '/foo/qux')
          expect(res.length).toBe(0)
        })
      })

      describe('Non-capturing group', () => {
        beforeEach(() => {
          router.add('get', '/foo/:capture{(?:bar|baz)}', 'ok')
        })

        it('GET /foo/bar', () => {
          const res = match('get', '/foo/bar')
          expect(res.length).toBe(1)
          expect(res[0].handler).toBe('ok')
          expect(res[0].params['capture']).toBe('bar')
        })

        it('GET /foo/baz', () => {
          const res = match('get', '/foo/baz')
          expect(res.length).toBe(1)
          expect(res[0].handler).toBe('ok')
          expect(res[0].params['capture']).toBe('baz')
        })

        it('GET /foo/qux', () => {
          const res = match('get', '/foo/qux')
          expect(res.length).toBe(0)
        })
      })

      describe('Non-capturing group with prefix', () => {
        beforeEach(() => {
          router.add('get', '/foo/:capture{ba(?:r|z)}', 'ok')
        })

        it('GET /foo/bar', () => {
          const res = match('get', '/foo/bar')
          expect(res.length).toBe(1)
          expect(res[0].handler).toBe('ok')
          expect(res[0].params['capture']).toBe('bar')
        })

        it('GET /foo/baz', () => {
          const res = match('get', '/foo/baz')
          expect(res.length).toBe(1)
          expect(res[0].handler).toBe('ok')
          expect(res[0].params['capture']).toBe('baz')
        })

        it('GET /foo/qux', () => {
          const res = match('get', '/foo/qux')
          expect(res.length).toBe(0)
        })
      })

      describe('Complex capturing group', () => {
        it('GET request', () => {
          router.add('get', '/foo/:capture{ba(r|z)}', 'ok')

          const res = match('get', '/foo/bar')
          expect(res.length).toBe(1)
          expect(res[0].handler).toBe('ok')
        })
      })
    })

    describe('Unknown method', () => {
      beforeEach(() => {
        router.add('GET', '/', 'index')
        router.add('ALL', '/all', 'all')
      })

      it('UNKNOWN_METHOD /', () => {
        const res = match('UNKNOWN_METHOD', '/')
        expect(res.length).toBe(0)
      })

      it('UNKNOWN_METHOD /all', () => {
        const res = match('UNKNOWN_METHOD', '/all')
        expect(res.length).toBe(1)
        expect(res[0].handler).toBe('all')
      })
    })
  })
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/reg-exp-router/index.ts
```typescript
/**
 * @module
 * RegExpRouter for Hono.
 */

export { RegExpRouter } from './router'

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/reg-exp-router/node.ts
```typescript
const LABEL_REG_EXP_STR = '[^/]+'
const ONLY_WILDCARD_REG_EXP_STR = '.*'
const TAIL_WILDCARD_REG_EXP_STR = '(?:|/.*)'
export const PATH_ERROR = Symbol()

export type ParamAssocArray = [string, number][]
export interface Context {
  varIndex: number
}

const regExpMetaChars = new Set('.\\+*[^]$()')

/**
 * Sort order:
 * 1. literal
 * 2. special pattern (e.g. :label{[0-9]+})
 * 3. common label pattern (e.g. :label)
 * 4. wildcard
 */
function compareKey(a: string, b: string): number {
  if (a.length === 1) {
    return b.length === 1 ? (a < b ? -1 : 1) : -1
  }
  if (b.length === 1) {
    return 1
  }

  // wildcard
  if (a === ONLY_WILDCARD_REG_EXP_STR || a === TAIL_WILDCARD_REG_EXP_STR) {
    return 1
  } else if (b === ONLY_WILDCARD_REG_EXP_STR || b === TAIL_WILDCARD_REG_EXP_STR) {
    return -1
  }

  // label
  if (a === LABEL_REG_EXP_STR) {
    return 1
  } else if (b === LABEL_REG_EXP_STR) {
    return -1
  }

  return a.length === b.length ? (a < b ? -1 : 1) : b.length - a.length
}

export class Node {
  #index?: number
  #varIndex?: number
  #children: Record<string, Node> = Object.create(null)

  insert(
    tokens: readonly string[],
    index: number,
    paramMap: ParamAssocArray,
    context: Context,
    pathErrorCheckOnly: boolean
  ): void {
    if (tokens.length === 0) {
      if (this.#index !== undefined) {
        throw PATH_ERROR
      }
      if (pathErrorCheckOnly) {
        return
      }

      this.#index = index
      return
    }

    const [token, ...restTokens] = tokens
    const pattern =
      token === '*'
        ? restTokens.length === 0
          ? ['', '', ONLY_WILDCARD_REG_EXP_STR] // '*' matches to all the trailing paths
          : ['', '', LABEL_REG_EXP_STR]
        : token === '/*'
        ? ['', '', TAIL_WILDCARD_REG_EXP_STR] // '/path/to/*' is /\/path\/to(?:|/.*)$
        : token.match(/^\:([^\{\}]+)(?:\{(.+)\})?$/)

    let node
    if (pattern) {
      const name = pattern[1]
      let regexpStr = pattern[2] || LABEL_REG_EXP_STR
      if (name && pattern[2]) {
        regexpStr = regexpStr.replace(/^\((?!\?:)(?=[^)]+\)$)/, '(?:') // (a|b) => (?:a|b)
        if (/\((?!\?:)/.test(regexpStr)) {
          // prefix(?:a|b) is allowed, but prefix(a|b) is not
          throw PATH_ERROR
        }
      }

      node = this.#children[regexpStr]
      if (!node) {
        if (
          Object.keys(this.#children).some(
            (k) => k !== ONLY_WILDCARD_REG_EXP_STR && k !== TAIL_WILDCARD_REG_EXP_STR
          )
        ) {
          throw PATH_ERROR
        }
        if (pathErrorCheckOnly) {
          return
        }
        node = this.#children[regexpStr] = new Node()
        if (name !== '') {
          node.#varIndex = context.varIndex++
        }
      }
      if (!pathErrorCheckOnly && name !== '') {
        paramMap.push([name, node.#varIndex as number])
      }
    } else {
      node = this.#children[token]
      if (!node) {
        if (
          Object.keys(this.#children).some(
            (k) =>
              k.length > 1 && k !== ONLY_WILDCARD_REG_EXP_STR && k !== TAIL_WILDCARD_REG_EXP_STR
          )
        ) {
          throw PATH_ERROR
        }
        if (pathErrorCheckOnly) {
          return
        }
        node = this.#children[token] = new Node()
      }
    }

    node.insert(restTokens, index, paramMap, context, pathErrorCheckOnly)
  }

  buildRegExpStr(): string {
    const childKeys = Object.keys(this.#children).sort(compareKey)

    const strList = childKeys.map((k) => {
      const c = this.#children[k]
      return (
        (typeof c.#varIndex === 'number'
          ? `(${k})@${c.#varIndex}`
          : regExpMetaChars.has(k)
          ? `\\${k}`
          : k) + c.buildRegExpStr()
      )
    })

    if (typeof this.#index === 'number') {
      strList.unshift(`#${this.#index}`)
    }

    if (strList.length === 0) {
      return ''
    }
    if (strList.length === 1) {
      return strList[0]
    }

    return '(?:' + strList.join('|') + ')'
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/reg-exp-router/router.test.ts
```typescript
import type { ParamStash } from '../../router'
import { UnsupportedPathError } from '../../router'
import { runTest } from '../common.case.test'
import { RegExpRouter } from './router'

describe('RegExpRouter', () => {
  runTest({
    skip: [
      {
        reason: 'UnsupportedPath',
        tests: [
          'Duplicate param name > parent',
          'Duplicate param name > child',
          'Capture Group > Complex capturing group > GET request',
          'Capture complex multiple directories > GET /part1/middle-b/latest',
          'Capture complex multiple directories > GET /part1/middle-b/end-c/latest',
        ],
      },
      {
        reason: 'This route can not be added with `:label` to RegExpRouter. This is ambiguous',
        tests: ['Including slashes > GET /js/main.js'],
      },
    ],
    newRouter: () => new RegExpRouter(),
  })

  describe('Return value type', () => {
    it('Should return [[T, ParamIndexMap][], ParamStash]', () => {
      const router = new RegExpRouter<string>()
      router.add('GET', '/posts/:id', 'get post')

      const [res, stash] = router.match('GET', '/posts/1')
      expect(res.length).toBe(1)
      expect(res).toEqual([['get post', { id: 1 }]])
      expect((stash as ParamStash)[1]).toBe('1')
    })
  })

  describe('UnsupportedPathError', () => {
    describe('Ambiguous', () => {
      const router = new RegExpRouter<string>()

      router.add('GET', '/:user/entries', 'get user entries')
      router.add('GET', '/entry/:name', 'get entry')
      router.add('POST', '/entry', 'create entry')

      it('GET /entry/entries', () => {
        expect(() => {
          router.match('GET', '/entry/entries')
        }).toThrowError(UnsupportedPathError)
      })
    })

    describe('Multiple handlers with different label', () => {
      const router = new RegExpRouter<string>()

      router.add('GET', '/:type/:id', ':type')
      router.add('GET', '/:class/:id', ':class')
      router.add('GET', '/:model/:id', ':model')

      it('GET /entry/123', () => {
        expect(() => {
          router.match('GET', '/entry/123')
        }).toThrowError(UnsupportedPathError)
      })
    })

    it('parent', () => {
      const router = new RegExpRouter<string>()
      router.add('GET', '/:id/:action', 'foo')
      router.add('GET', '/posts/:id', 'bar')
      expect(() => {
        router.match('GET', '/')
      }).toThrowError(UnsupportedPathError)
    })

    it('child', () => {
      const router = new RegExpRouter<string>()
      router.add('GET', '/posts/:id', 'foo')
      router.add('GET', '/:id/:action', 'bar')

      expect(() => {
        router.match('GET', '/')
      }).toThrowError(UnsupportedPathError)
    })

    describe('static and dynamic', () => {
      it('static first', () => {
        const router = new RegExpRouter<string>()
        router.add('GET', '/reg-exp/router', 'foo')
        router.add('GET', '/reg-exp/:id', 'bar')

        expect(() => {
          router.match('GET', '/')
        }).toThrowError(UnsupportedPathError)
      })

      it('long label', () => {
        const router = new RegExpRouter<string>()
        router.add('GET', '/reg-exp/router', 'foo')
        router.add('GET', '/reg-exp/:service', 'bar')

        expect(() => {
          router.match('GET', '/')
        }).toThrowError(UnsupportedPathError)
      })

      it('dynamic first', () => {
        const router = new RegExpRouter<string>()
        router.add('GET', '/reg-exp/:id', 'bar')
        router.add('GET', '/reg-exp/router', 'foo')

        expect(() => {
          router.match('GET', '/')
        }).toThrowError(UnsupportedPathError)
      })
    })

    it('different regular expression', () => {
      const router = new RegExpRouter<string>()
      router.add('GET', '/:id/:action{create|update}', 'foo')
      router.add('GET', '/:id/:action{delete}', 'bar')
      expect(() => {
        router.match('GET', '/')
      }).toThrowError(UnsupportedPathError)
    })

    describe('Capture Group', () => {
      describe('Complex capturing group', () => {
        it('GET request', () => {
          const router = new RegExpRouter<string>()
          router.add('GET', '/foo/:capture{ba(r|z)}', 'ok')
          expect(() => {
            router.match('GET', '/foo/bar')
          }).toThrowError(UnsupportedPathError)
        })
      })
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/reg-exp-router/router.ts
```typescript
import type { ParamIndexMap, Result, Router } from '../../router'
import {
  MESSAGE_MATCHER_IS_ALREADY_BUILT,
  METHOD_NAME_ALL,
  UnsupportedPathError,
} from '../../router'
import { checkOptionalParameter } from '../../utils/url'
import { PATH_ERROR } from './node'
import type { ParamAssocArray } from './node'
import { Trie } from './trie'

type HandlerData<T> = [T, ParamIndexMap][]
type StaticMap<T> = Record<string, Result<T>>
type Matcher<T> = [RegExp, HandlerData<T>[], StaticMap<T>]
type HandlerWithMetadata<T> = [T, number] // [handler, paramCount]

const emptyParam: string[] = []
// eslint-disable-next-line @typescript-eslint/no-explicit-any
const nullMatcher: Matcher<any> = [/^$/, [], Object.create(null)]

let wildcardRegExpCache: Record<string, RegExp> = Object.create(null)
function buildWildcardRegExp(path: string): RegExp {
  return (wildcardRegExpCache[path] ??= new RegExp(
    path === '*'
      ? ''
      : `^${path.replace(/\/\*$|([.\\+*[^\]$()])/g, (_, metaChar) =>
          metaChar ? `\\${metaChar}` : '(?:|/.*)'
        )}$`
  ))
}

function clearWildcardRegExpCache() {
  wildcardRegExpCache = Object.create(null)
}

function buildMatcherFromPreprocessedRoutes<T>(
  routes: [string, HandlerWithMetadata<T>[]][]
): Matcher<T> {
  const trie = new Trie()
  const handlerData: HandlerData<T>[] = []
  if (routes.length === 0) {
    return nullMatcher
  }

  const routesWithStaticPathFlag = routes
    .map(
      (route) => [!/\*|\/:/.test(route[0]), ...route] as [boolean, string, HandlerWithMetadata<T>[]]
    )
    .sort(([isStaticA, pathA], [isStaticB, pathB]) =>
      isStaticA ? 1 : isStaticB ? -1 : pathA.length - pathB.length
    )

  const staticMap: StaticMap<T> = Object.create(null)
  for (let i = 0, j = -1, len = routesWithStaticPathFlag.length; i < len; i++) {
    const [pathErrorCheckOnly, path, handlers] = routesWithStaticPathFlag[i]
    if (pathErrorCheckOnly) {
      staticMap[path] = [handlers.map(([h]) => [h, Object.create(null)]), emptyParam]
    } else {
      j++
    }

    let paramAssoc: ParamAssocArray
    try {
      paramAssoc = trie.insert(path, j, pathErrorCheckOnly)
    } catch (e) {
      throw e === PATH_ERROR ? new UnsupportedPathError(path) : e
    }

    if (pathErrorCheckOnly) {
      continue
    }

    handlerData[j] = handlers.map(([h, paramCount]) => {
      const paramIndexMap: ParamIndexMap = Object.create(null)
      paramCount -= 1
      for (; paramCount >= 0; paramCount--) {
        const [key, value] = paramAssoc[paramCount]
        paramIndexMap[key] = value
      }
      return [h, paramIndexMap]
    })
  }

  const [regexp, indexReplacementMap, paramReplacementMap] = trie.buildRegExp()
  for (let i = 0, len = handlerData.length; i < len; i++) {
    for (let j = 0, len = handlerData[i].length; j < len; j++) {
      const map = handlerData[i][j]?.[1]
      if (!map) {
        continue
      }
      const keys = Object.keys(map)
      for (let k = 0, len = keys.length; k < len; k++) {
        map[keys[k]] = paramReplacementMap[map[keys[k]]]
      }
    }
  }

  const handlerMap: HandlerData<T>[] = []
  // using `in` because indexReplacementMap is a sparse array
  for (const i in indexReplacementMap) {
    handlerMap[i] = handlerData[indexReplacementMap[i]]
  }

  return [regexp, handlerMap, staticMap] as Matcher<T>
}

function findMiddleware<T>(
  middleware: Record<string, T[]> | undefined,
  path: string
): T[] | undefined {
  if (!middleware) {
    return undefined
  }

  for (const k of Object.keys(middleware).sort((a, b) => b.length - a.length)) {
    if (buildWildcardRegExp(k).test(path)) {
      return [...middleware[k]]
    }
  }

  return undefined
}

export class RegExpRouter<T> implements Router<T> {
  name: string = 'RegExpRouter'
  #middleware?: Record<string, Record<string, HandlerWithMetadata<T>[]>>
  #routes?: Record<string, Record<string, HandlerWithMetadata<T>[]>>

  constructor() {
    this.#middleware = { [METHOD_NAME_ALL]: Object.create(null) }
    this.#routes = { [METHOD_NAME_ALL]: Object.create(null) }
  }

  add(method: string, path: string, handler: T) {
    const middleware = this.#middleware
    const routes = this.#routes

    if (!middleware || !routes) {
      throw new Error(MESSAGE_MATCHER_IS_ALREADY_BUILT)
    }

    if (!middleware[method]) {
      ;[middleware, routes].forEach((handlerMap) => {
        handlerMap[method] = Object.create(null)
        Object.keys(handlerMap[METHOD_NAME_ALL]).forEach((p) => {
          handlerMap[method][p] = [...handlerMap[METHOD_NAME_ALL][p]]
        })
      })
    }

    if (path === '/*') {
      path = '*'
    }

    const paramCount = (path.match(/\/:/g) || []).length

    if (/\*$/.test(path)) {
      const re = buildWildcardRegExp(path)
      if (method === METHOD_NAME_ALL) {
        Object.keys(middleware).forEach((m) => {
          middleware[m][path] ||=
            findMiddleware(middleware[m], path) ||
            findMiddleware(middleware[METHOD_NAME_ALL], path) ||
            []
        })
      } else {
        middleware[method][path] ||=
          findMiddleware(middleware[method], path) ||
          findMiddleware(middleware[METHOD_NAME_ALL], path) ||
          []
      }
      Object.keys(middleware).forEach((m) => {
        if (method === METHOD_NAME_ALL || method === m) {
          Object.keys(middleware[m]).forEach((p) => {
            re.test(p) && middleware[m][p].push([handler, paramCount])
          })
        }
      })

      Object.keys(routes).forEach((m) => {
        if (method === METHOD_NAME_ALL || method === m) {
          Object.keys(routes[m]).forEach(
            (p) => re.test(p) && routes[m][p].push([handler, paramCount])
          )
        }
      })

      return
    }

    const paths = checkOptionalParameter(path) || [path]
    for (let i = 0, len = paths.length; i < len; i++) {
      const path = paths[i]

      Object.keys(routes).forEach((m) => {
        if (method === METHOD_NAME_ALL || method === m) {
          routes[m][path] ||= [
            ...(findMiddleware(middleware[m], path) ||
              findMiddleware(middleware[METHOD_NAME_ALL], path) ||
              []),
          ]
          routes[m][path].push([handler, paramCount - len + i + 1])
        }
      })
    }
  }

  match(method: string, path: string): Result<T> {
    clearWildcardRegExpCache() // no longer used.

    const matchers = this.#buildAllMatchers()

    this.match = (method, path) => {
      const matcher = (matchers[method] || matchers[METHOD_NAME_ALL]) as Matcher<T>

      const staticMatch = matcher[2][path]
      if (staticMatch) {
        return staticMatch
      }

      const match = path.match(matcher[0])
      if (!match) {
        return [[], emptyParam]
      }

      const index = match.indexOf('', 1)
      return [matcher[1][index], match]
    }

    return this.match(method, path)
  }

  #buildAllMatchers(): Record<string, Matcher<T> | null> {
    const matchers: Record<string, Matcher<T> | null> = Object.create(null)

    Object.keys(this.#routes!)
      .concat(Object.keys(this.#middleware!))
      .forEach((method) => {
        matchers[method] ||= this.#buildMatcher(method)
      })

    // Release cache
    this.#middleware = this.#routes = undefined

    return matchers
  }

  #buildMatcher(method: string): Matcher<T> | null {
    const routes: [string, HandlerWithMetadata<T>[]][] = []

    let hasOwnRoute = method === METHOD_NAME_ALL

    ;[this.#middleware!, this.#routes!].forEach((r) => {
      const ownRoute = r[method]
        ? Object.keys(r[method]).map((path) => [path, r[method][path]])
        : []
      if (ownRoute.length !== 0) {
        hasOwnRoute ||= true
        routes.push(...(ownRoute as [string, HandlerWithMetadata<T>[]][]))
      } else if (method !== METHOD_NAME_ALL) {
        routes.push(
          ...(Object.keys(r[METHOD_NAME_ALL]).map((path) => [path, r[METHOD_NAME_ALL][path]]) as [
            string,
            HandlerWithMetadata<T>[]
          ][])
        )
      }
    })

    if (!hasOwnRoute) {
      return null
    } else {
      return buildMatcherFromPreprocessedRoutes(routes)
    }
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/reg-exp-router/trie.ts
```typescript
import type { Context, ParamAssocArray } from './node'
import { Node } from './node'

export type ReplacementMap = number[]

export class Trie {
  #context: Context = { varIndex: 0 }
  #root: Node = new Node()

  insert(path: string, index: number, pathErrorCheckOnly: boolean): ParamAssocArray {
    const paramAssoc: ParamAssocArray = []

    const groups: [string, string][] = [] // [mark, original string]
    for (let i = 0; ; ) {
      let replaced = false
      path = path.replace(/\{[^}]+\}/g, (m) => {
        const mark = `@\\${i}`
        groups[i] = [mark, m]
        i++
        replaced = true
        return mark
      })
      if (!replaced) {
        break
      }
    }

    /**
     *  - pattern (:label, :label{0-9]+}, ...)
     *  - /* wildcard
     *  - character
     */
    const tokens = path.match(/(?::[^\/]+)|(?:\/\*$)|./g) || []
    for (let i = groups.length - 1; i >= 0; i--) {
      const [mark] = groups[i]
      for (let j = tokens.length - 1; j >= 0; j--) {
        if (tokens[j].indexOf(mark) !== -1) {
          tokens[j] = tokens[j].replace(mark, groups[i][1])
          break
        }
      }
    }

    this.#root.insert(tokens, index, paramAssoc, this.#context, pathErrorCheckOnly)

    return paramAssoc
  }

  buildRegExp(): [RegExp, ReplacementMap, ReplacementMap] {
    let regexp = this.#root.buildRegExpStr()
    if (regexp === '') {
      return [/^$/, [], []] // never match
    }

    let captureIndex = 0
    const indexReplacementMap: ReplacementMap = []
    const paramReplacementMap: ReplacementMap = []

    regexp = regexp.replace(/#(\d+)|@(\d+)|\.\*\$/g, (_, handlerIndex, paramIndex) => {
      if (handlerIndex !== undefined) {
        indexReplacementMap[++captureIndex] = Number(handlerIndex)
        return '$()'
      }
      if (paramIndex !== undefined) {
        paramReplacementMap[Number(paramIndex)] = ++captureIndex
        return ''
      }

      return ''
    })

    return [new RegExp(`^${regexp}`), indexReplacementMap, paramReplacementMap]
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/smart-router/index.ts
```typescript
/**
 * @module
 * SmartRouter for Hono.
 */

export { SmartRouter } from './router'

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/smart-router/router.test.ts
```typescript
import { runTest } from '../common.case.test'
import { RegExpRouter } from '../reg-exp-router'
import { TrieRouter } from '../trie-router'
import { SmartRouter } from './router'

describe('SmartRouter', () => {
  runTest({
    newRouter: () =>
      new SmartRouter({
        routers: [new RegExpRouter(), new TrieRouter()],
      }),
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/smart-router/router.ts
```typescript
import type { Result, Router } from '../../router'
import { MESSAGE_MATCHER_IS_ALREADY_BUILT, UnsupportedPathError } from '../../router'

export class SmartRouter<T> implements Router<T> {
  name: string = 'SmartRouter'
  #routers: Router<T>[] = []
  #routes?: [string, string, T][] = []

  constructor(init: { routers: Router<T>[] }) {
    this.#routers = init.routers
  }

  add(method: string, path: string, handler: T) {
    if (!this.#routes) {
      throw new Error(MESSAGE_MATCHER_IS_ALREADY_BUILT)
    }

    this.#routes.push([method, path, handler])
  }

  match(method: string, path: string): Result<T> {
    if (!this.#routes) {
      throw new Error('Fatal error')
    }

    const routers = this.#routers
    const routes = this.#routes

    const len = routers.length
    let i = 0
    let res
    for (; i < len; i++) {
      const router = routers[i]
      try {
        for (let i = 0, len = routes.length; i < len; i++) {
          router.add(...routes[i])
        }
        res = router.match(method, path)
      } catch (e) {
        if (e instanceof UnsupportedPathError) {
          continue
        }
        throw e
      }

      this.match = router.match.bind(router)
      this.#routers = [router]
      this.#routes = undefined
      break
    }

    if (i === len) {
      // not found
      throw new Error('Fatal error')
    }

    // e.g. "SmartRouter + RegExpRouter"
    this.name = `SmartRouter + ${this.activeRouter.name}`

    return res as Result<T>
  }

  get activeRouter(): Router<T> {
    if (this.#routes || this.#routers.length !== 1) {
      throw new Error('No active router has been determined yet.')
    }

    return this.#routers[0]
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/pattern-router/index.ts
```typescript
/**
 * @module
 * PatternRouter for Hono.
 */

export { PatternRouter } from './router'

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/pattern-router/router.test.ts
```typescript
import { UnsupportedPathError } from '../../router'
import { runTest } from '../common.case.test'
import { PatternRouter } from './router'

describe('Pattern', () => {
  runTest({
    skip: [
      {
        reason: 'UnsupportedPath',
        tests: ['Duplicate param name > self'],
      },
      {
        reason: 'PatternRouter allows trailing slashes',
        tests: ['Trailing slash > GET /book/'],
      },
    ],
    newRouter: () => new PatternRouter(),
  })

  describe('Duplicate param name', () => {
    it('self', () => {
      const router = new PatternRouter<string>()
      expect(() => {
        router.add('GET', '/:id/:id', 'foo')
      }).toThrowError(UnsupportedPathError)
    })
  })
  describe('Trailing slash', () => {
    const router = new PatternRouter<string>()

    beforeEach(() => {
      router.add('GET', '/book', 'GET /book')
      router.add('GET', '/book/:id', 'GET /book/:id')
    })

    it('GET /book/', () => {
      const [res] = router.match('GET', '/book/')
      expect(res.length).toBe(1)
      expect(res[0][0]).toBe('GET /book')
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/pattern-router/router.ts
```typescript
import type { Params, Result, Router } from '../../router'
import { METHOD_NAME_ALL, UnsupportedPathError } from '../../router'

type Route<T> = [RegExp, string, T] // [pattern, method, handler]

const emptyParams = Object.create(null)

export class PatternRouter<T> implements Router<T> {
  name: string = 'PatternRouter'
  #routes: Route<T>[] = []

  add(method: string, path: string, handler: T) {
    const endsWithWildcard = path.at(-1) === '*'
    if (endsWithWildcard) {
      path = path.slice(0, -2)
    }
    if (path.at(-1) === '?') {
      path = path.slice(0, -1)
      this.add(method, path.replace(/\/[^/]+$/, ''), handler)
    }

    const parts = (path.match(/\/?(:\w+(?:{(?:(?:{[\d,]+})|[^}])+})?)|\/?[^\/\?]+/g) || []).map(
      (part) => {
        const match = part.match(/^\/:([^{]+)(?:{(.*)})?/)
        return match
          ? `/(?<${match[1]}>${match[2] || '[^/]+'})`
          : part === '/*'
          ? '/[^/]+'
          : part.replace(/[.\\+*[^\]$()]/g, '\\$&')
      }
    )

    try {
      this.#routes.push([
        new RegExp(`^${parts.join('')}${endsWithWildcard ? '' : '/?$'}`),
        method,
        handler,
      ])
    } catch {
      throw new UnsupportedPathError()
    }
  }

  match(method: string, path: string): Result<T> {
    const handlers: [T, Params][] = []

    for (let i = 0, len = this.#routes.length; i < len; i++) {
      const [pattern, routeMethod, handler] = this.#routes[i]

      if (routeMethod === method || routeMethod === METHOD_NAME_ALL) {
        const match = pattern.exec(path)
        if (match) {
          handlers.push([handler, match.groups || emptyParams])
        }
      }
    }

    return [handlers]
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/linear-router/index.ts
```typescript
/**
 * @module
 * LinearRouter for Hono.
 */

export { LinearRouter } from './router'

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/linear-router/router.test.ts
```typescript
import { UnsupportedPathError } from '../../router'
import { runTest } from '../common.case.test'
import { LinearRouter } from './router'

describe('LinearRouter', () => {
  runTest({
    skip: [
      {
        reason: 'UnsupportedPath',
        tests: [
          'Multi match > `params` per a handler > GET /entry/123/show',
          'Capture regex pattern has trailing wildcard > GET /foo/bar/file.html',
        ],
      },
      {
        reason: 'LinearRouter allows trailing slashes',
        tests: ['Trailing slash > GET /book/'],
      },
    ],
    newRouter: () => new LinearRouter(),
  })

  describe('Multi match', () => {
    describe('`params` per a handler', () => {
      const router = new LinearRouter<string>()

      beforeEach(() => {
        router.add('ALL', '*', 'middleware a')
        router.add('GET', '/entry/:id/*', 'middleware b')
        router.add('GET', '/entry/:id/:action', 'action')
      })

      it('GET /entry/123/show', () => {
        expect(() => {
          router.match('GET', '/entry/123/show')
        }).toThrowError(UnsupportedPathError)
      })
    })
  })

  describe('Trailing slash', () => {
    const router = new LinearRouter<string>()

    beforeEach(() => {
      router.add('GET', '/book', 'GET /book')
      router.add('GET', '/book/:id', 'GET /book/:id')
    })

    it('GET /book/', () => {
      const [res] = router.match('GET', '/book/')
      expect(res.length).toBe(1)
      expect(res[0][0]).toBe('GET /book')
    })
  })

  describe('Skip part', () => {
    const router = new LinearRouter<string>()

    beforeEach(() => {
      router.add('GET', '/products/:id{d+}', 'GET /products/:id{d+}')
    })

    it('GET /products/list', () => {
      const [res] = router.match('GET', '/products/list')
      expect(res.length).toBe(0)
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/router/linear-router/router.ts
```typescript
import type { Params, Result, Router } from '../../router'
import { METHOD_NAME_ALL, UnsupportedPathError } from '../../router'
import { checkOptionalParameter } from '../../utils/url'

type RegExpMatchArrayWithIndices = RegExpMatchArray & { indices: [number, number][] }

const emptyParams = Object.create(null)

const splitPathRe = /\/(:\w+(?:{(?:(?:{[\d,]+})|[^}])+})?)|\/[^\/\?]+|(\?)/g
const splitByStarRe = /\*/
export class LinearRouter<T> implements Router<T> {
  name: string = 'LinearRouter'
  #routes: [string, string, T][] = []

  add(method: string, path: string, handler: T) {
    for (
      let i = 0, paths = checkOptionalParameter(path) || [path], len = paths.length;
      i < len;
      i++
    ) {
      this.#routes.push([method, paths[i], handler])
    }
  }

  match(method: string, path: string): Result<T> {
    const handlers: [T, Params][] = []
    ROUTES_LOOP: for (let i = 0, len = this.#routes.length; i < len; i++) {
      const [routeMethod, routePath, handler] = this.#routes[i]
      if (routeMethod === method || routeMethod === METHOD_NAME_ALL) {
        if (routePath === '*' || routePath === '/*') {
          handlers.push([handler, emptyParams])
          continue
        }

        const hasStar = routePath.indexOf('*') !== -1
        const hasLabel = routePath.indexOf(':') !== -1
        if (!hasStar && !hasLabel) {
          if (routePath === path || routePath + '/' === path) {
            handlers.push([handler, emptyParams])
          }
        } else if (hasStar && !hasLabel) {
          const endsWithStar = routePath.charCodeAt(routePath.length - 1) === 42
          const parts = (endsWithStar ? routePath.slice(0, -2) : routePath).split(splitByStarRe)

          const lastIndex = parts.length - 1
          for (let j = 0, pos = 0, len = parts.length; j < len; j++) {
            const part = parts[j]
            const index = path.indexOf(part, pos)
            if (index !== pos) {
              continue ROUTES_LOOP
            }
            pos += part.length
            if (j === lastIndex) {
              if (
                !endsWithStar &&
                pos !== path.length &&
                !(pos === path.length - 1 && path.charCodeAt(pos) === 47)
              ) {
                continue ROUTES_LOOP
              }
            } else {
              const index = path.indexOf('/', pos)
              if (index === -1) {
                continue ROUTES_LOOP
              }
              pos = index
            }
          }
          handlers.push([handler, emptyParams])
        } else if (hasLabel && !hasStar) {
          const params: Record<string, string> = Object.create(null)
          const parts = routePath.match(splitPathRe) as string[]

          const lastIndex = parts.length - 1
          for (let j = 0, pos = 0, len = parts.length; j < len; j++) {
            if (pos === -1 || pos >= path.length) {
              continue ROUTES_LOOP
            }

            const part = parts[j]
            if (part.charCodeAt(1) === 58) {
              // /:label
              let name = part.slice(2)
              let value

              if (name.charCodeAt(name.length - 1) === 125) {
                // :label{pattern}
                const openBracePos = name.indexOf('{')
                const next = parts[j + 1]
                const lookahead = next && next[1] !== ':' && next[1] !== '*' ? `(?=${next})` : ''
                const pattern = name.slice(openBracePos + 1, -1) + lookahead
                const restPath = path.slice(pos + 1)
                const match = new RegExp(pattern, 'd').exec(restPath) as RegExpMatchArrayWithIndices
                if (!match || match.indices[0][0] !== 0 || match.indices[0][1] === 0) {
                  continue ROUTES_LOOP
                }
                name = name.slice(0, openBracePos)
                value = restPath.slice(...match.indices[0])
                pos += match.indices[0][1] + 1
              } else {
                let endValuePos = path.indexOf('/', pos + 1)
                if (endValuePos === -1) {
                  if (pos + 1 === path.length) {
                    continue ROUTES_LOOP
                  }
                  endValuePos = path.length
                }
                value = path.slice(pos + 1, endValuePos)
                pos = endValuePos
              }

              params[name] ||= value as string
            } else {
              const index = path.indexOf(part, pos)
              if (index !== pos) {
                continue ROUTES_LOOP
              }
              pos += part.length
            }

            if (j === lastIndex) {
              if (
                pos !== path.length &&
                !(pos === path.length - 1 && path.charCodeAt(pos) === 47)
              ) {
                continue ROUTES_LOOP
              }
            }
          }

          handlers.push([handler, params])
        } else if (hasLabel && hasStar) {
          throw new UnsupportedPathError()
        }
      }
    }

    return [handlers]
  }
}

```
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
