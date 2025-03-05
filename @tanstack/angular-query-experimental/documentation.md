# ./framework/angular/overview.md

---
id: overview
title: Overview
---

> IMPORTANT: This library is currently in an experimental stage. This means that breaking changes will happen in minor AND patch releases. Upgrade carefully. If you use this in production while in experimental stage, please lock your version to a patch-level version to avoid unexpected breaking changes.

The `@tanstack/angular-query-experimental` package offers a 1st-class API for using TanStack Query via Angular.

## Feedback welcome!

We are in the process of getting to a stable API for TanStack Query on Angular. If you have any feedback, please contact us at the [TanStack Discord](https://tlinz.com/discord) server or [visit this discussion](https://github.com/TanStack/query/discussions/6293) on Github.

## Supported Angular Versions

TanStack Query is compatible with Angular v16 and higher.

TanStack Query (FKA React Query) is often described as the missing data-fetching library for web applications, but in more technical terms, it makes **fetching, caching, synchronizing and updating server state** in your web applications a breeze.

## Motivation

Most core web frameworks **do not** come with an opinionated way of fetching or updating data in a holistic way. Because of this developers end up building either meta-frameworks which encapsulate strict opinions about data-fetching, or they invent their own ways of fetching data. This usually means cobbling together component-based state and side-effects, or using more general purpose state management libraries to store and provide asynchronous data throughout their apps.

While most traditional state management libraries are great for working with client state, they are **not so great at working with async or server state**. This is because **server state is totally different**. For starters, server state:

- Is persisted remotely in a location you may not control or own
- Requires asynchronous APIs for fetching and updating
- Implies shared ownership and can be changed by other people without your knowledge
- Can potentially become "out of date" in your applications if you're not careful

Once you grasp the nature of server state in your application, **even more challenges will arise** as you go, for example:

- Caching... (possibly the hardest thing to do in programming)
- Deduping multiple requests for the same data into a single request
- Updating "out of date" data in the background
- Knowing when data is "out of date"
- Reflecting updates to data as quickly as possible
- Performance optimizations like pagination and lazy loading data
- Managing memory and garbage collection of server state
- Memoizing query results with structural sharing

If you're not overwhelmed by that list, then that must mean that you've probably solved all of your server state problems already and deserve an award. However, if you are like a vast majority of people, you either have yet to tackle all or most of these challenges and we're only scratching the surface!

TanStack Query is hands down one of the _best_ libraries for managing server state. It works amazingly well **out-of-the-box, with zero-config, and can be customized** to your liking as your application grows.

TanStack Query allows you to defeat and overcome the tricky challenges and hurdles of _server state_ and control your app data before it starts to control you.

On a more technical note, TanStack Query will likely:

- Help you remove **many** lines of complicated and misunderstood code from your application and replace with just a handful of lines of Angular Query logic.
- Make your application more maintainable and easier to build new features without worrying about wiring up new server state data sources
- Have a direct impact on your end-users by making your application feel faster and more responsive than ever before.
- Potentially help you save on bandwidth and increase memory performance

[//]: # 'Example'

## Enough talk, show me some code already!

In the example below, you can see TanStack Query in its most basic and simple form being used to fetch the GitHub stats for the TanStack Query GitHub project itself:

[Open in StackBlitz](https://stackblitz.com/github/TanStack/query/tree/main/examples/angular/simple)

```angular-ts
import { ChangeDetectionStrategy, Component, inject } from '@angular/core'
import { HttpClient } from '@angular/common/http'
import { CommonModule } from '@angular/common'
import { injectQuery } from '@tanstack/angular-query-experimental'
import { lastValueFrom } from 'rxjs'

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'simple-example',
  standalone: true,
  template: `
    @if (query.isPending()) {
      Loading...
    }
    @if (query.error()) {
      An error has occurred: {{ query.error().message }}
    }
    @if (query.data(); as data) {
      <h1>{{ data.name }}</h1>
      <p>{{ data.description }}</p>
      <strong>👀 {{ data.subscribers_count }}</strong>
      <strong>✨ {{ data.stargazers_count }}</strong>
      <strong>🍴 {{ data.forks_count }}</strong>
    }
  `
})
export class SimpleExampleComponent {
  http = inject(HttpClient)

  query = injectQuery(() => ({
    queryKey: ['repoData'],
    queryFn: () =>
      lastValueFrom(
        this.http.get<Response>('https://api.github.com/repos/tanstack/query'),
      ),
  }))
}

interface Response {
  name: string
  description: string
  subscribers_count: number
  stargazers_count: number
  forks_count: number
}
```

## You talked me into it, so what now?

- Learn TanStack Query at your own pace with our amazingly thorough [Walkthrough Guide](../installation) and [API Reference](../reference/functions/injectquery)



# ./framework/angular/devtools.md

---
id: devtools
title: Devtools
---

## Enable devtools

The devtools help you debug and inspect your queries and mutations. You can enable the devtools by adding `withDevtools` to `provideTanStackQuery`.

By default, the devtools are enabled when Angular [`isDevMode`](https://angular.dev/api/core/isDevMode) returns true. So you don't need to worry about excluding them during a production build. The core tools are lazily loaded and excluded from bundled code. In most cases, all you'll need to do is add `withDevtools()` to `provideTanStackQuery` without any additional configuration.

```ts
import {
  QueryClient,
  provideTanStackQuery,
  withDevtools,
} from '@tanstack/angular-query-experimental'

export const appConfig: ApplicationConfig = {
  providers: [provideTanStackQuery(new QueryClient(), withDevtools())],
}
```

## Configuring if devtools are loaded

If you need more control over when devtools are loaded, you can use the `loadDevtools` option. This is particularly useful if you want to load devtools based on environment configurations. For instance, you might have a test environment running in production mode but still require devtools to be available.

When not setting the option or setting it to 'auto', the devtools will be loaded when Angular is in development mode.

```ts
provideTanStackQuery(new QueryClient(), withDevtools())

// which is equivalent to
provideTanStackQuery(
  new QueryClient(),
  withDevtools(() => ({ loadDevtools: 'auto' })),
)
```

When setting the option to true, the devtools will be loaded in both development and production mode.

```ts
provideTanStackQuery(
  new QueryClient(),
  withDevtools(() => ({ loadDevtools: true })),
)
```

When setting the option to false, the devtools will not be loaded.

```ts
provideTanStackQuery(
  new QueryClient(),
  withDevtools(() => ({ loadDevtools: false })),
)
```

The `withDevtools` options are returned from a callback function to support reactivity through signals. In the following example
a signal is created from a RxJS observable that listens for a keyboard shortcut. When the event is triggered, the devtools are lazily loaded.
Using this technique allows you to support on-demand loading of the devtools even in production mode, without including the full tools in the bundled code.

```ts
@Injectable({ providedIn: 'root' })
class DevtoolsOptionsManager {
  loadDevtools = toSignal(
    fromEvent<KeyboardEvent>(document, 'keydown').pipe(
      map(
        (event): boolean =>
          event.metaKey && event.ctrlKey && event.shiftKey && event.key === 'D',
      ),
      scan((acc, curr) => acc || curr, false),
    ),
    {
      initialValue: false,
    },
  )
}

export const appConfig: ApplicationConfig = {
  providers: [
    provideHttpClient(),
    provideTanStackQuery(
      new QueryClient(),
      withDevtools(() => ({
        initialIsOpen: true,
        loadDevtools: inject(DevtoolsOptionsManager).loadDevtools(),
      })),
    ),
  ],
}
```

### Options

Of these options `client`, `position`, `errorTypes`, `buttonPosition`, and `initialIsOpen` support reactivity through signals.

- `loadDevtools?: 'auto' | boolean`
  - Defaults to `auto`: lazily loads devtools when in development mode. Skips loading in production mode.
  - Use this to control if the devtools are loaded.
- `initialIsOpen?: Boolean`
  - Set this to `true` if you want the tools to default to being open
- `buttonPosition?: "top-left" | "top-right" | "bottom-left" | "bottom-right" | "relative"`
  - Defaults to `bottom-right`
  - The position of the TanStack logo to open and close the devtools panel
  - If `relative`, the button is placed in the location that you render the devtools.
- `position?: "top" | "bottom" | "left" | "right"`
  - Defaults to `bottom`
  - The position of the Angular Query devtools panel
- `client?: QueryClient`,
  - Use this to use a custom QueryClient. Otherwise, the QueryClient provided through `provideTanStackQuery` will be injected.
- `errorTypes?: { name: string; initializer: (query: Query) => TError}[]`
  - Use this to predefine some errors that can be triggered on your queries. Initializer will be called (with the specific query) when that error is toggled on from the UI. It must return an Error.
- `styleNonce?: string`
  - Use this to pass a nonce to the style tag that is added to the document head. This is useful if you are using a Content Security Policy (CSP) nonce to allow inline styles.
- `shadowDOMTarget?: ShadowRoot`
  - Default behavior will apply the devtool's styles to the head tag within the DOM.
  - Use this to pass a shadow DOM target to the devtools so that the styles will be applied within the shadow DOM instead of within the head tag in the light DOM.



# ./framework/angular/quick-start.md

---
id: quick-start
title: Quick Start
---

> IMPORTANT: This library is currently in an experimental stage. This means that breaking changes will happen in minor AND patch releases. Upgrade carefully. If you use this in production while in experimental stage, please lock your version to a patch-level version to avoid unexpected breaking changes.

[//]: # 'Example'

If you're looking for a fully functioning example, please have a look at our [basic codesandbox example](../examples/basic)

### Provide the client to your App

```ts
import { provideHttpClient } from '@angular/common/http'
import {
  provideTanStackQuery,
  QueryClient,
} from '@tanstack/angular-query-experimental'

bootstrapApplication(AppComponent, {
  providers: [provideHttpClient(), provideTanStackQuery(new QueryClient())],
})
```

or in a NgModule-based app

```ts
import { provideHttpClient } from '@angular/common/http'
import {
  provideTanStackQuery,
  QueryClient,
} from '@tanstack/angular-query-experimental'

@NgModule({
  declarations: [AppComponent],
  imports: [BrowserModule],
  providers: [provideTanStackQuery(new QueryClient())],
  bootstrap: [AppComponent],
})
export class AppModule {}
```

### Component with query and mutation

```angular-ts
import { Component, Injectable, inject } from '@angular/core'
import { HttpClient } from '@angular/common/http'
import { lastValueFrom } from 'rxjs'

import {
  injectMutation,
  injectQuery,
  QueryClient
} from '@tanstack/angular-query-experimental'

@Component({
  standalone: true,
  template: `
    <div>
      <button (click)="onAddTodo()">Add Todo</button>

      <ul>
        @for (todo of query.data(); track todo.title) {
          <li>{{ todo.title }}</li>
        }
      </ul>
    </div>
  `,
})
export class TodosComponent {
  todoService = inject(TodoService)
  queryClient = inject(QueryClient)

  query = injectQuery(() => ({
    queryKey: ['todos'],
    queryFn: () => this.todoService.getTodos(),
  }))

  mutation = injectMutation(() => ({
    mutationFn: (todo: Todo) => this.todoService.addTodo(todo),
    onSuccess: () => {
      this.queryClient.invalidateQueries({ queryKey: ['todos'] })
    },
  }))

  onAddTodo() {
    this.mutation.mutate({
      id: Date.now().toString(),
      title: 'Do Laundry',
    })
  }
}

@Injectable({ providedIn: 'root' })
export class TodoService {
  private http = inject(HttpClient)

  getTodos(): Promise<Todo[]> {
    return lastValueFrom(
      this.http.get<Todo[]>('https://jsonplaceholder.typicode.com/todos'),
    )
  }

  addTodo(todo: Todo): Promise<Todo> {
    return lastValueFrom(
      this.http.post<Todo>('https://jsonplaceholder.typicode.com/todos', todo),
    )
  }
}

interface Todo {
  id: string
  title: string
}
```

[//]: # 'Example'



# ./framework/angular/guides/query-retries.md

---
id: query-retries
title: Query Retries
ref: docs/framework/react/guides/query-retries.md
replace:
  {
    'Provider': 'Plugin',
    'useQuery': 'injectQuery',
    'useMutation': 'injectMutation',
  }
---

[//]: # 'Info'
[//]: # 'Info'
[//]: # 'Example'

```ts
import { injectQuery } from '@tanstack/angular-query-experimental'

// Make a specific query retry a certain number of times
const result = injectQuery(() => ({
  queryKey: ['todos', 1],
  queryFn: fetchTodoListPage,
  retry: 10, // Will retry failed requests 10 times before displaying an error
}))
```

[//]: # 'Example'
[//]: # 'Example2'

```ts
// Configure for all queries
import {
  QueryCache,
  QueryClient,
  QueryClientProvider,
} from '@tanstack/angular-query-experimental'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000),
    },
  },
})

bootstrapApplication(AppComponent, {
  providers: [provideTanStackQuery(queryClient)],
})
```

[//]: # 'Example2'

Though it is not recommended, you can obviously override the `retryDelay` function/integer in both the Provider and individual query options. If set to an integer instead of a function the delay will always be the same amount of time:

[//]: # 'Example3'

```ts
const result = injectQuery(() => ({
  queryKey: ['todos'],
  queryFn: fetchTodoList,
  retryDelay: 1000, // Will always wait 1000ms to retry, regardless of how many retries
}))
```

[//]: # 'Example3'



# ./framework/angular/guides/query-options.md

---
id: query-options
title: Query Options
ref: docs/framework/react/guides/query-options.md
---

[//]: # 'Example1'

```ts
import { queryOptions } from '@tanstack/angular-query-experimental'

@Injectable({
  providedIn: 'root',
})
export class QueriesService {
  private http = inject(HttpClient)

  post(postId: number) {
    return queryOptions({
      queryKey: ['post', postId],
      queryFn: () => {
        return lastValueFrom(
          this.http.get<Post>(
            `https://jsonplaceholder.typicode.com/posts/${postId}`,
          ),
        )
      },
    })
  }
}

// usage:

postId = input.required({
  transform: numberAttribute,
})
queries = inject(QueriesService)

postQuery = injectQuery(() => this.queries.post(this.postId()))

queryClient.prefetchQuery(this.queries.post(23))
queryClient.setQueryData(this.queries.post(42).queryKey, newPost)
```

[//]: # 'Example1'
[//]: # 'Example2'

```ts
// Type inference still works, so query.data will be the return type of select instead of queryFn
queries = inject(QueriesService)

query = injectQuery(() => ({
  ...groupOptions(1),
  select: (data) => data.title,
}))
```

[//]: # 'Example2'



# ./framework/angular/guides/queries.md

---
id: queries
title: Queries
ref: docs/framework/react/guides/queries.md
replace:
  {
    'React': 'Angular',
    'react-query': 'angular-query',
    'promise': 'promise or observable',
    'custom hooks': 'services',
    'the `useQuery` hook': '`injectQuery`',
    '`useQuery`': '`injectQuery`',
    "TypeScript will also narrow the type of data correctly if you've checked for pending and error before accessing it.": 'TypeScript will only narrow the type when checking boolean signals such as `isPending` and `isError`.',
  }
---

[//]: # 'Example'

```ts
import { injectQuery } from '@tanstack/angular-query-experimental'

export class TodosComponent {
  info = injectQuery(() => ({ queryKey: ['todos'], queryFn: fetchTodoList }))
}
```

[//]: # 'Example'
[//]: # 'Example2'

```ts
result = injectQuery(() => ({ queryKey: ['todos'], queryFn: fetchTodoList }))
```

[//]: # 'Example2'
[//]: # 'Example3'

```angular-ts
@Component({
  selector: 'todos',
  standalone: true,
  template: `
    @if (todos.isPending()) {
      <span>Loading...</span>
    } @else if (todos.isError()) {
      <span>Error: {{ todos.error()?.message }}</span>
    } @else {
      <!-- We can assume by this point that status === 'success' -->
      @for (todo of todos.data(); track todo.id) {
        <li>{{ todo.title }}</li>
      } @empty {
        <li>No todos found</li>
      }
    }
  `,
})
export class PostsComponent {
  todos = injectQuery(() => ({
    queryKey: ['todos'],
    queryFn: fetchTodoList,
  }))
}
```

[//]: # 'Example3'

If booleans aren't your thing, you can always use the `status` state as well:

[//]: # 'Example4'

```angular-ts
@Component({
  selector: 'todos',
  standalone: true,
  template: `
    @switch (todos.status()) {
      @case ('pending') {
        <span>Loading...</span>
      }
      @case ('error') {
        <span>Error: {{ todos.error()?.message }}</span>
      }
      <!-- also status === 'success', but "else" logic works, too -->
      @default {
        <ul>
          @for (todo of todos.data(); track todo.id) {
            <li>{{ todo.title }}</li>
          } @empty {
            <li>No todos found</li>
          }
        </ul>
      }
    }
  `,
})
class TodosComponent {}
```

[//]: # 'Example4'
[//]: # 'Materials'
[//]: # 'Materials'



# ./framework/angular/guides/query-invalidation.md

---
id: query-invalidation
title: Query Invalidation
ref: docs/framework/react/guides/query-invalidation.md
replace: { 'useQuery': 'injectQuery', 'hooks': 'functions' }
---

[//]: # 'Example2'

```ts
import { injectQuery, QueryClient } from '@tanstack/angular-query-experimental'

class QueryInvalidationExample {
  queryClient = inject(QueryClient)

  invalidateQueries() {
    this.queryClient.invalidateQueries({ queryKey: ['todos'] })
  }

  // Both queries below will be invalidated
  todoListQuery = injectQuery(() => ({
    queryKey: ['todos'],
    queryFn: fetchTodoList,
  }))
  todoListQuery = injectQuery(() => ({
    queryKey: ['todos', { page: 1 }],
    queryFn: fetchTodoList,
  }))
}
```

[//]: # 'Example2'

You can even invalidate queries with specific variables by passing a more specific query key to the `invalidateQueries` method:

[//]: # 'Example3'

```ts
queryClient.invalidateQueries({
  queryKey: ['todos', { type: 'done' }],
})

// The query below will be invalidated
todoListQuery = injectQuery(() => ({
  queryKey: ['todos', { type: 'done' }],
  queryFn: fetchTodoList,
}))

// However, the following query below will NOT be invalidated
todoListQuery = injectQuery(() => ({
  queryKey: ['todos'],
  queryFn: fetchTodoList,
}))
```

[//]: # 'Example3'

The `invalidateQueries` API is very flexible, so even if you want to **only** invalidate `todos` queries that don't have any more variables or subkeys, you can pass an `exact: true` option to the `invalidateQueries` method:

[//]: # 'Example4'

```ts
queryClient.invalidateQueries({
  queryKey: ['todos'],
  exact: true,
})

// The query below will be invalidated
todoListQuery = injectQuery(() => ({
  queryKey: ['todos'],
  queryFn: fetchTodoList,
}))

// However, the following query below will NOT be invalidated
const todoListQuery = injectQuery(() => ({
  queryKey: ['todos', { type: 'done' }],
  queryFn: fetchTodoList,
}))
```

[//]: # 'Example4'

If you find yourself wanting **even more** granularity, you can pass a predicate function to the `invalidateQueries` method. This function will receive each `Query` instance from the query cache and allow you to return `true` or `false` for whether you want to invalidate that query:

[//]: # 'Example5'

```ts
queryClient.invalidateQueries({
  predicate: (query) =>
    query.queryKey[0] === 'todos' && query.queryKey[1]?.version >= 10,
})

// The query below will be invalidated
todoListQuery = injectQuery(() => ({
  queryKey: ['todos', { version: 20 }],
  queryFn: fetchTodoList,
}))

// The query below will be invalidated
todoListQuery = injectQuery(() => ({
  queryKey: ['todos', { version: 10 }],
  queryFn: fetchTodoList,
}))

// However, the following query below will NOT be invalidated
todoListQuery = injectQuery(() => ({
  queryKey: ['todos', { version: 5 }],
  queryFn: fetchTodoList,
}))
```

[//]: # 'Example5'



# ./framework/angular/guides/query-cancellation.md

---
id: query-cancellation
title: Query Cancellation
---

TanStack Query provides each query function with an [`AbortSignal` instance](https://developer.mozilla.org/docs/Web/API/AbortSignal). When a query becomes out-of-date or inactive, this `signal` will become aborted. This means that all queries are cancellable, and you can respond to the cancellation inside your query function if desired. The best part about this is that it allows you to continue to use normal async/await syntax while getting all the benefits of automatic cancellation.

## Default behavior

By default, queries that unmount or become unused before their promises are resolved are _not_ cancelled. This means that after the promise has resolved, the resulting data will be available in the cache. This is helpful if you've started receiving a query, but then unmount the component before it finishes. If you mount the component again and the query has not been garbage collected yet, data will be available.

However, if you consume the `AbortSignal`, the Promise will be cancelled (e.g. aborting the fetch) and therefore, also the Query must be cancelled. Cancelling the query will result in its state being _reverted_ to its previous state.

## Using `HttpClient`

```ts
import { HttpClient } from '@angular/common/http'
import { injectQuery } from '@tanstack/angular-query-experimental'

postQuery = injectQuery(() => ({
  enabled: this.postId() > 0,
  queryKey: ['post', this.postId()],
  queryFn: async (context): Promise<Post> => {
    const abort$ = fromEvent(context.signal, 'abort')
    return lastValueFrom(this.getPost$(this.postId()).pipe(takeUntil(abort$)))
  },
}))
```

## Using `fetch`

[//]: # 'Example2'

```ts
query = injectQuery(() => ({
  queryKey: ['todos'],
  queryFn: async ({ signal }) => {
    const todosResponse = await fetch('/todos', {
      // Pass the signal to one fetch
      signal,
    })
    const todos = await todosResponse.json()

    const todoDetails = todos.map(async ({ details }) => {
      const response = await fetch(details, {
        // Or pass it to several
        signal,
      })
      return response.json()
    })

    return Promise.all(todoDetails)
  },
}))
```

[//]: # 'Example2'

## Using `axios`

[//]: # 'Example3'

```tsx
import axios from 'axios'

const query = injectQuery(() => ({
  queryKey: ['todos'],
  queryFn: ({ signal }) =>
    axios.get('/todos', {
      // Pass the signal to `axios`
      signal,
    }),
}))
```

[//]: # 'Example3'

## Manual Cancellation

You might want to cancel a query manually. For example, if the request takes a long time to finish, you can allow the user to click a cancel button to stop the request. To do this, you just need to call `queryClient.cancelQueries({ queryKey })`, which will cancel the query and revert it back to its previous state. If you have consumed the `signal` passed to the query function, TanStack Query will additionally also cancel the Promise.

[//]: # 'Example7'

```angular-ts
@Component({
  standalone: true,
  template: `<button (click)="onCancel()">Cancel</button>`,
})
export class TodosComponent {
  query = injectQuery(() => ({
    queryKey: ['todos'],
    queryFn: async ({ signal }) => {
      const resp = await fetch('/todos', { signal })
      return resp.json()
    },
  }))

  queryClient = inject(QueryClient)

  onCancel() {
    this.queryClient.cancelQueries(['todos'])
  }
}
```

[//]: # 'Example7'



# ./framework/angular/guides/caching.md

---
id: caching
title: Caching Examples
---

> Please thoroughly read the [Important Defaults](../important-defaults) before reading this guide

## Basic Example

This caching example illustrates the story and lifecycle of:

- Query Instances with and without cache data
- Background Refetching
- Inactive Queries
- Garbage Collection

Let's assume we are using the default `gcTime` of **5 minutes** and the default `staleTime` of `0`.

- A new instance of `injectQuery(() => ({ queryKey: ['todos'], queryFn: fetchTodos }))` initializes.
  - Since no other queries have been made with the `['todos']` query key, this query will show a hard loading state and make a network request to fetch the data.
  - When the network request has completed, the returned data will be cached under the `['todos']` key.
  - The date will be marked as stale after the configured `staleTime` (defaults to `0`, or immediately).
- A second instance of `injectQuery(() => ({ queryKey: ['todos'], queryFn: fetchTodos })` initializes elsewhere.
  - Since the cache already has data for the `['todos']` key from the first query, that data is immediately returned from the cache.
  - The new instance triggers a new network request using its query function.
    - Note that regardless of whether both `fetchTodos` query functions are identical or not, both queries' [`status`](../../reference/injectQuery) are updated (including `isFetching`, `isPending`, and other related values) because they have the same query key.
  - When the request completes successfully, the cache's data under the `['todos']` key is updated with the new data, and both instances are updated with the new data.
- Both instances of the `injectQuery(() => ({ queryKey: ['todos'], queryFn: fetchTodos })` query are destroyed and no longer in use.
  - Since there are no more active instances of this query, a garbage collection timeout is set using `gcTime` to delete and garbage collect the query (defaults to **5 minutes**).
- Before the cache timeout has completed, another instance of `injectQuery(() => ({ queryKey: ['todos'], queyFn: fetchTodos })` mounts. The query immediately returns the available cached data while the `fetchTodos` function is being run in the background. When it completes successfully, it will populate the cache with fresh data.
- The final instance of `injectQuery(() => ({ queryKey: ['todos'], queryFn: fetchTodos })` gets destroyed.
- No more instances of `injectQuery(() => ({ queryKey: ['todos'], queryFn: fetchTodos })` appear within **5 minutes**.
  - The cached data under the `['todos']` key is deleted and garbage collected.



# ./framework/angular/guides/network-mode.md

---
id: network-mode
title: Network Mode
ref: docs/framework/react/guides/network-mode.md
---



# ./framework/angular/guides/filters.md

---
id: filters
title: Filters
ref: docs/framework/react/guides/filters.md
---



# ./framework/angular/guides/default-query-function.md

---
id: default-query-function
title: Default Query Function
ref: docs/framework/react/guides/default-query-function.md
---

[//]: # 'Example'

```ts
// Define a default query function that will receive the query key
const defaultQueryFn: QueryFunction = async ({ queryKey }) => {
  const { data } = await axios.get(
    `https://jsonplaceholder.typicode.com${queryKey[0]}`,
  )
  return data
}

// provide the default query function to your app with defaultOptions
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      queryFn: defaultQueryFn,
    },
  },
})

bootstrapApplication(MyAppComponent, {
  providers: [provideTanStackQuery(queryClient)],
})

export class PostsComponent {
  // All you have to do now is pass a key!
  postsQuery = injectQuery<Array<Post>>(() => ({
    queryKey: ['/posts'],
  }))
  // ...
}

export class PostComponent {
  // You can even leave out the queryFn and just go straight into options
  postQuery = injectQuery<Post>(() => ({
    enabled: this.postIdSignal() > 0,
    queryKey: [`/posts/${this.postIdSignal()}`],
  }))
  // ...
}
```

[//]: # 'Example'



# ./framework/angular/guides/optimistic-updates.md

---
id: optimistic-updates
title: Optimistic Updates
ref: docs/framework/react/guides/optimistic-updates.md
replace:
  {
    'React': 'Angular',
    'useMutation': 'injectMutation',
    'hook': 'function',
    'useMutationState': 'injectMutationState',
    'addTodoMutation': 'addTodo',
  }
---

[//]: # 'ExampleUI1'

```ts
addTodo = injectMutation(() => ({
  mutationFn: (newTodo: string) => axios.post('/api/data', { text: newTodo }),
  // make sure to _return_ the Promise from the query invalidation
  // so that the mutation stays in `pending` state until the refetch is finished
  onSettled: async () => {
    return await queryClient.invalidateQueries({ queryKey: ['todos'] })
  },
}))
```

[//]: # 'ExampleUI1'
[//]: # 'ExampleUI2'

```angular-ts
@Component({
  template: `
    @for (todo of todos.data(); track todo.id) {
      <li>{{ todo.title }}</li>
    }
    @if (addTodo.isPending()) {
      <li style="opacity: 0.5">{{ addTodo.variables() }}</li>
    }
  `,
})
class TodosComponent {}
```

[//]: # 'ExampleUI2'
[//]: # 'ExampleUI3'

```angular-ts
@Component({
  template: `
    @if (addTodo.isError()) {
      <li style="color: red">
        {{ addTodo.variables() }}
        <button (click)="addTodo.mutate(addTodo.variables())">Retry</button>
      </li>
    }
  `,
})
class TodosComponent {}
```

[//]: # 'ExampleUI3'
[//]: # 'ExampleUI4'

```ts
// somewhere in your app
addTodo = injectMutation(() => ({
  mutationFn: (newTodo: string) => axios.post('/api/data', { text: newTodo }),
  onSettled: () => queryClient.invalidateQueries({ queryKey: ['todos'] }),
  mutationKey: ['addTodo'],
}))

// access variables somewhere else

mutationState = injectMutationState<string>(() => ({
  filters: { mutationKey: ['addTodo'], status: 'pending' },
  select: (mutation) => mutation.state.variables,
}))
```

[//]: # 'ExampleUI4'
[//]: # 'Example'

```ts
queryClient = inject(QueryClient)

updateTodo = injectMutation(() => ({
  mutationFn: updateTodo,
  // When mutate is called:
  onMutate: async (newTodo) => {
    // Cancel any outgoing refetches
    // (so they don't overwrite our optimistic update)
    await this.queryClient.cancelQueries({ queryKey: ['todos'] })

    // Snapshot the previous value
    const previousTodos = client.getQueryData(['todos'])

    // Optimistically update to the new value
    this.queryClient.setQueryData(['todos'], (old) => [...old, newTodo])

    // Return a context object with the snapshotted value
    return { previousTodos }
  },
  // If the mutation fails,
  // use the context returned from onMutate to roll back
  onError: (err, newTodo, context) => {
    client.setQueryData(['todos'], context.previousTodos)
  },
  // Always refetch after error or success:
  onSettled: () => {
    this.queryClient.invalidateQueries({ queryKey: ['todos'] })
  },
}))
```

[//]: # 'Example'
[//]: # 'Example2'

```ts
queryClient = inject(QueryClient)

updateTodo = injectMutation(() => ({
  mutationFn: updateTodo,
  // When mutate is called:
  onMutate: async (newTodo) => {
    // Cancel any outgoing refetches
    // (so they don't overwrite our optimistic update)
    await this.queryClient.cancelQueries({ queryKey: ['todos', newTodo.id] })

    // Snapshot the previous value
    const previousTodo = this.queryClient.getQueryData(['todos', newTodo.id])

    // Optimistically update to the new value
    this.queryClient.setQueryData(['todos', newTodo.id], newTodo)

    // Return a context with the previous and new todo
    return { previousTodo, newTodo }
  },
  // If the mutation fails, use the context we returned above
  onError: (err, newTodo, context) => {
    this.queryClient.setQueryData(
      ['todos', context.newTodo.id],
      context.previousTodo,
    )
  },
  // Always refetch after error or success:
  onSettled: (newTodo) => {
    this.queryClient.invalidateQueries({ queryKey: ['todos', newTodo.id] })
  },
}))
```

[//]: # 'Example2'
[//]: # 'Example3'

```ts
injectMutation({
  mutationFn: updateTodo,
  // ...
  onSettled: (newTodo, error, variables, context) => {
    if (error) {
      // do something
    }
  },
})
```

[//]: # 'Example3'



# ./framework/angular/guides/important-defaults.md

---
id: important-defaults
title: Important Defaults
ref: docs/framework/react/guides/important-defaults.md
replace:
  {
    'React': 'Angular',
    'react-query': 'angular-query',
    'useQuery': 'injectQuery',
    'useInfiniteQuery': 'injectInfiniteQuery',
    'useMemo and useCallback': 'setting signal values',
  }
---

[//]: # 'Materials'
[//]: # 'Materials'



# ./framework/angular/guides/initial-query-data.md

---
id: initial-query-data
title: Initial Query Data
ref: docs/framework/react/guides/initial-query-data.md
replace:
  {
    'render': 'service or component instance',
    ' when it mounts': '',
    'after mount': 'after initialization',
    'on mount': 'on initialization',
  }
---

[//]: # 'Example'

```ts
result = injectQuery(() => ({
  queryKey: ['todos'],
  queryFn: () => fetch('/todos'),
  initialData: initialTodos,
}))
```

[//]: # 'Example'
[//]: # 'Example2'

```ts
// Will show initialTodos immediately, but also immediately refetch todos
// when an instance of the component or service is created
result = injectQuery(() => ({
  queryKey: ['todos'],
  queryFn: () => fetch('/todos'),
  initialData: initialTodos,
}))
```

[//]: # 'Example2'
[//]: # 'Example3'

```ts
// Show initialTodos immediately, but won't refetch until
// another interaction event is encountered after 1000 ms
result = injectQuery(() => ({
  queryKey: ['todos'],
  queryFn: () => fetch('/todos'),
  initialData: initialTodos,
  staleTime: 1000,
}))
```

[//]: # 'Example3'
[//]: # 'Example4'

```ts
// Show initialTodos immediately, but won't refetch until
// another interaction event is encountered after 1000 ms
result = injectQuery(() => ({
  queryKey: ['todos'],
  queryFn: () => fetch('/todos'),
  initialData: initialTodos,
  staleTime: 60 * 1000, // 1 minute
  // This could be 10 seconds ago or 10 minutes ago
  initialDataUpdatedAt: initialTodosUpdatedTimestamp, // eg. 1608412420052
}))
```

[//]: # 'Example4'
[//]: # 'Example5'

```ts
result = injectQuery(() => ({
  queryKey: ['todos'],
  queryFn: () => fetch('/todos'),
  initialData: () => getExpensiveTodos(),
}))
```

[//]: # 'Example5'
[//]: # 'Example6'

```ts
result = injectQuery(() => ({
  queryKey: ['todo', this.todoId()],
  queryFn: () => fetch('/todos'),
  initialData: () => {
    // Use a todo from the 'todos' query as the initial data for this todo query
    return this.queryClient
      .getQueryData(['todos'])
      ?.find((d) => d.id === this.todoId())
  },
}))
```

[//]: # 'Example6'
[//]: # 'Example7'

```ts
result = injectQuery(() => ({
  queryKey: ['todos', this.todoId()],
  queryFn: () => fetch(`/todos/${this.todoId()}`),
  initialData: () =>
    queryClient.getQueryData(['todos'])?.find((d) => d.id === this.todoId()),
  initialDataUpdatedAt: () =>
    queryClient.getQueryState(['todos'])?.dataUpdatedAt,
}))
```

[//]: # 'Example7'
[//]: # 'Example8'

```ts
result = injectQuery(() => ({
  queryKey: ['todo', this.todoId()],
  queryFn: () => fetch(`/todos/${this.todoId()}`),
  initialData: () => {
    // Get the query state
    const state = queryClient.getQueryState(['todos'])

    // If the query exists and has data that is no older than 10 seconds...
    if (state && Date.now() - state.dataUpdatedAt <= 10 * 1000) {
      // return the individual todo
      return state.data.find((d) => d.id === this.todoId())
    }

    // Otherwise, return undefined and let it fetch from a hard loading state!
  },
}))
```

[//]: # 'Example8'
[//]: # 'Materials'
[//]: # 'Materials'



# ./framework/angular/guides/infinite-queries.md

---
id: infinite-queries
title: Infinite Queries
ref: docs/framework/react/guides/infinite-queries.md
replace:
  { 'useQuery': 'injectQuery', 'useInfiniteQuery': 'injectInfiniteQuery' }
---

[//]: # 'Example'

```angular-ts
import { Component, computed, inject } from '@angular/core'
import { injectInfiniteQuery } from '@tanstack/angular-query-experimental'
import { lastValueFrom } from 'rxjs'
import { ProjectsService } from './projects-service'

@Component({
  selector: 'example',
  templateUrl: './example.component.html',
})
export class Example {
  projectsService = inject(ProjectsService)

  query = injectInfiniteQuery(() => ({
    queryKey: ['projects'],
    queryFn: async ({ pageParam }) => {
      return lastValueFrom(this.projectsService.getProjects(pageParam))
    },
    initialPageParam: 0,
    getPreviousPageParam: (firstPage) => firstPage.previousId ?? undefined,
    getNextPageParam: (lastPage) => lastPage.nextId ?? undefined,
    maxPages: 3,
  }))

  nextButtonDisabled = computed(
    () => !this.#hasNextPage() || this.#isFetchingNextPage(),
  )
  nextButtonText = computed(() =>
    this.#isFetchingNextPage()
      ? 'Loading more...'
      : this.#hasNextPage()
        ? 'Load newer'
        : 'Nothing more to load',
  )

  #hasNextPage = this.query.hasNextPage
  #isFetchingNextPage = this.query.isFetchingNextPage
}
```

```angular-html
<div>
  @if (query.isPending()) {
  <p>Loading...</p>
  } @else if (query.isError()) {
  <span>Error: {{ query?.error().message }}</span>
  } @else { @for (page of query?.data().pages; track $index) { @for (project of
  page.data; track project.id) {
  <p>{{ project.name }} {{ project.id }}</p>
  } }
  <div>
    <button (click)="query.fetchNextPage()" [disabled]="nextButtonDisabled()">
      {{ nextButtonText() }}
    </button>
  </div>
  }
</div>
```

[//]: # 'Example'
[//]: # 'Example1'

```angular-ts
@Component({
  template: ` <list-component (endReached)="fetchNextPage()" /> `,
})
export class Example {
  query = injectInfiniteQuery(() => ({
    queryKey: ['projects'],
    queryFn: async ({ pageParam }) => {
      return lastValueFrom(this.projectsService.getProjects(pageParam))
    },
  }))

  fetchNextPage() {
    // Do nothing if already fetching
    if (this.query.isFetching()) return
    this.query.fetchNextPage()
  }
}
```

[//]: # 'Example1'
[//]: # 'Example3'

```ts
query = injectInfiniteQuery(() => ({
  queryKey: ['projects'],
  queryFn: fetchProjects,
  getNextPageParam: (lastPage, pages) => lastPage.nextCursor,
  getPreviousPageParam: (firstPage, pages) => firstPage.prevCursor,
}))
```

[//]: # 'Example3'
[//]: # 'Example4'

```ts
query = injectInfiniteQuery(() => ({
  queryKey: ['projects'],
  queryFn: fetchProjects,
  select: (data) => ({
    pages: [...data.pages].reverse(),
    pageParams: [...data.pageParams].reverse(),
  }),
}))
```

[//]: # 'Example4'
[//]: # 'Example8'

```ts
injectInfiniteQuery(() => ({
  queryKey: ['projects'],
  queryFn: fetchProjects,
  initialPageParam: 0,
  getNextPageParam: (lastPage, pages) => lastPage.nextCursor,
  getPreviousPageParam: (firstPage, pages) => firstPage.prevCursor,
  maxPages: 3,
}))
```

[//]: # 'Example8'
[//]: # 'Example9'

```ts
injectInfiniteQuery(() => ({
  queryKey: ['projects'],
  queryFn: fetchProjects,
  initialPageParam: 0,
  getNextPageParam: (lastPage, allPages, lastPageParam) => {
    if (lastPage.length === 0) {
      return undefined
    }
    return lastPageParam + 1
  },
  getPreviousPageParam: (firstPage, allPages, firstPageParam) => {
    if (firstPageParam <= 1) {
      return undefined
    }
    return firstPageParam - 1
  },
}))
```

[//]: # 'Example9'



# ./framework/angular/guides/query-functions.md

---
id: query-functions
title: Query Functions
ref: docs/framework/react/guides/query-functions.md
---

[//]: # 'Example'

```ts
injectQuery(() => ({ queryKey: ['todos'], queryFn: fetchAllTodos }))
injectQuery(() => ({ queryKey: ['todos', todoId], queryFn: () => fetchTodoById(todoId) })
injectQuery(() => ({
  queryKey: ['todos', todoId],
  queryFn: async () => {
    const data = await fetchTodoById(todoId)
    return data
  },
}))
injectQuery(() => ({
  queryKey: ['todos', todoId],
  queryFn: ({ queryKey }) => fetchTodoById(queryKey[1]),
}))
```

[//]: # 'Example'
[//]: # 'Example2'

```ts
todos = injectQuery(() => ({
  queryKey: ['todos', todoId()],
  queryFn: async () => {
    if (somethingGoesWrong) {
      throw new Error('Oh no!')
    }
    if (somethingElseGoesWrong) {
      return Promise.reject(new Error('Oh no!'))
    }

    return data
  },
}))
```

[//]: # 'Example2'
[//]: # 'Example3'

```ts
todos = injectQuery(() => ({
  queryKey: ['todos', todoId()],
  queryFn: async () => {
    const response = await fetch('/todos/' + todoId)
    if (!response.ok) {
      throw new Error('Network response was not ok')
    }
    return response.json()
  },
}))
```

[//]: # 'Example3'
[//]: # 'Example4'

```ts
result = injectQuery(() => ({
  queryKey: ['todos', { status: status(), page: page() }],
  queryFn: fetchTodoList,
}))

// Access the key, status and page variables in your query function!
function fetchTodoList({ queryKey }) {
  const [_key, { status, page }] = queryKey
  return new Promise()
}
```

[//]: # 'Example4'



# ./framework/angular/guides/scroll-restoration.md

---
id: scroll-restoration
title: Scroll Restoration
ref: docs/framework/react/guides/scroll-restoration.md
---



# ./framework/angular/guides/window-focus-refetching.md

---
id: window-focus-refetching
title: Window Focus Refetching
ref: docs/framework/react/guides/window-focus-refetching.md
replace: { '@tanstack/react-query': '@tanstack/angular-query-experimental' }
---

[//]: # 'Example'

```ts
export const appConfig: ApplicationConfig = {
  providers: [
    provideTanStackQuery(
      new QueryClient({
        defaultOptions: {
          queries: {
            refetchOnWindowFocus: false, // default: true
          },
        },
      }),
    ),
  ],
}
```

[//]: # 'Example'
[//]: # 'Example2'

```ts
injectQuery(() => ({
  queryKey: ['todos'],
  queryFn: fetchTodos,
  refetchOnWindowFocus: false,
}))
```

[//]: # 'Example2'
[//]: # 'ReactNative'
[//]: # 'ReactNative'



# ./framework/angular/guides/paginated-queries.md

---
id: paginated-queries
title: Paginated / Lagged Queries
ref: docs/framework/react/guides/paginated-queries.md
replace:
  {
    'useQuery': 'injectQuery',
    'useInfiniteQuery': 'injectInfiniteQuery',
    'hook': 'function',
  }
---

[//]: # 'Example'

```ts
const result = injectQuery(() => ({
  queryKey: ['projects', page()],
  queryFn: fetchProjects,
}))
```

[//]: # 'Example'
[//]: # 'Example2'

```angular-ts
@Component({
  selector: 'pagination-example',
  template: `
    <div>
      <p>
        In this example, each page of data remains visible as the next page is
        fetched. The buttons and capability to proceed to the next page are also
        suppressed until the next page cursor is known. Each page is cached as a
        normal query too, so when going to previous pages, you'll see them
        instantaneously while they are also re-fetched invisibly in the
        background.
      </p>
      @if (query.status() === 'pending') {
        <div>Loading...</div>
      } @else if (query.status() === 'error') {
        <div>Error: {{ query.error().message }}</div>
      } @else {
        <!-- 'data' will either resolve to the latest page's data -->
        <!-- or if fetching a new page, the last successful page's data -->
        <div>
          @for (project of query.data().projects; track project.id) {
            <p>{{ project.name }}</p>
          }
        </div>
      }

      <div>Current Page: {{ page() + 1 }}</div>
      <button (click)="previousPage()" [disabled]="page() === 0">
        Previous Page
      </button>
      <button
        (click)="nextPage()"
        [disabled]="query.isPlaceholderData() || !query.data()?.hasMore"
      >
        Next Page
      </button>
      <!-- Since the last page's data potentially sticks around between page requests, -->
      <!-- we can use 'isFetching' to show a background loading -->
      <!-- indicator since our status === 'pending' state won't be triggered -->
      @if (query.isFetching()) {
        <span> Loading...</span>
      }
    </div>
  `,
})
export class PaginationExampleComponent {
  page = signal(0)
  queryClient = inject(QueryClient)

  query = injectQuery(() => ({
    queryKey: ['projects', this.page()],
    queryFn: () => lastValueFrom(fetchProjects(this.page())),
    placeholderData: keepPreviousData,
    staleTime: 5000,
  }))

  constructor() {
    effect(() => {
      // Prefetch the next page!
      if (!this.query.isPlaceholderData() && this.query.data()?.hasMore) {
        this.#queryClient.prefetchQuery({
          queryKey: ['projects', this.page() + 1],
          queryFn: () => lastValueFrom(fetchProjects(this.page() + 1)),
        })
      }
    })
  }

  previousPage() {
    this.page.update((old) => Math.max(old - 1, 0))
  }

  nextPage() {
    this.page.update((old) => (this.query.data()?.hasMore ? old + 1 : old))
  }
}
```

[//]: # 'Example2'



# ./framework/angular/guides/placeholder-query-data.md

---
id: placeholder-query-data
title: Placeholder Query Data
ref: docs/framework/react/guides/placeholder-query-data.md
---

[//]: # 'ExampleValue'

```ts
class TodosComponent {
  result = injectQuery(() => ({
    queryKey: ['todos'],
    queryFn: () => fetch('/todos'),
    placeholderData: placeholderTodos,
  }))
}
```

[//]: # 'ExampleValue'
[//]: # 'Memoization'
[//]: # 'Memoization'
[//]: # 'ExampleFunction'

```ts
class TodosComponent {
  result = injectQuery(() => ({
    queryKey: ['todos', id()],
    queryFn: () => fetch(`/todos/${id}`),
    placeholderData: (previousData, previousQuery) => previousData,
  }))
}
```

[//]: # 'ExampleFunction'
[//]: # 'ExampleCache'

```ts
export class BlogPostComponent {
  // Until Angular supports signal-based inputs, we have to set a signal
  @Input({ required: true, alias: 'postId' })
  set _postId(value: number) {
    this.postId.set(value)
  }
  postId = signal(0)
  queryClient = inject(QueryClient)

  result = injectQuery(() => ({
    queryKey: ['blogPost', this.postId()],
    queryFn: () => fetch(`/blogPosts/${this.postId()}`),
    placeholderData: () => {
      // Use the smaller/preview version of the blogPost from the 'blogPosts'
      // query as the placeholder data for this blogPost query
      return queryClient
        .getQueryData(['blogPosts'])
        ?.find((d) => d.id === this.postId())
    },
  }))
}
```

[//]: # 'ExampleCache'
[//]: # 'Materials'
[//]: # 'Materials'



# ./framework/angular/guides/dependent-queries.md

---
id: dependent-queries
title: Dependent Queries
ref: docs/framework/react/guides/dependent-queries.md
replace: { 'useQuery': 'injectQuery', 'useQueries': 'injectQueries' }
---

[//]: # 'Example'

```ts
// Get the user
userQuery = injectQuery(() => ({
  queryKey: ['user', email],
  queryFn: getUserByEmail,
}))

// Then get the user's projects
projectsQuery = injectQuery(() => ({
  queryKey: ['projects', this.userQuery.data()?.id],
  queryFn: getProjectsByUser,
  // The query will not execute until the user id exists
  enabled: !!this.userQuery.data()?.id,
}))
```

[//]: # 'Example'
[//]: # 'Example2'

```ts
// injectQueries is under development for Angular Query
```

[//]: # 'Example2'



# ./framework/angular/guides/invalidations-from-mutations.md

---
id: invalidations-from-mutations
title: Invalidations from Mutations
ref: docs/framework/react/guides/invalidations-from-mutations.md
replace: { 'useMutation': 'injectMutation', 'hook': 'function' }
---

[//]: # 'Example'

```ts
mutation = injectMutation(() => ({
  mutationFn: postTodo,
}))
```

[//]: # 'Example'
[//]: # 'Example2'

```ts
import {
  injectMutation,
  QueryClient,
} from '@tanstack/angular-query-experimental'

export class TodosComponent {
  queryClient = inject(QueryClient)

  // When this mutation succeeds, invalidate any queries with the `todos` or `reminders` query key
  mutation = injectMutation(() => ({
    mutationFn: addTodo,
    onSuccess: () => {
      this.queryClient.invalidateQueries({ queryKey: ['todos'] })
      this.queryClient.invalidateQueries({ queryKey: ['reminders'] })
    },
  }))
}
```

[//]: # 'Example2'

You can wire up your invalidations to happen using any of the callbacks available in the [`injectMutation` function](../mutations)



# ./framework/angular/guides/disabling-queries.md

---
id: disabling-queries
title: Disabling/Pausing Queries
ref: docs/framework/react/guides/disabling-queries.md
replace: { 'useQuery': 'injectQuery' }
---

[//]: # 'Example'

```angular-ts
@Component({
  selector: 'todos',
  template: `<div>
    <button (click)="query.refetch()">Fetch Todos</button>

    @if (query.data()) {
      <ul>
        @for (todo of query.data(); track todo.id) {
          <li>{{ todo.title }}</li>
        }
      </ul>
    } @else {
      @if (query.isError()) {
        <span>Error: {{ query.error().message }}</span>
      } @else if (query.isLoading()) {
        <span>Loading...</span>
      } @else if (!query.isLoading() && !query.isError()) {
        <span>Not ready ...</span>
      }
    }

    <div>{{ query.isLoading() ? 'Fetching...' : '' }}</div>
  </div>`,
})
export class TodosComponent {
  query = injectQuery(() => ({
    queryKey: ['todos'],
    queryFn: fetchTodoList,
    enabled: false,
  }))
}
```

[//]: # 'Example'
[//]: # 'Example2'

```angular-ts
@Component({
  selector: 'todos',
  template: `
    <div>
      // 🚀 applying the filter will enable and execute the query
      <filters-form onApply="filter.set" />
      <todos-table data="query.data()" />
    </div>
  `,
})
export class TodosComponent {
  filter = signal('')

  todosQuery = injectQuery(() => ({
    queryKey: ['todos', this.filter()],
    queryFn: () => fetchTodos(this.filter()),
    enabled: !!this.filter(),
  }))
}
```

[//]: # 'Example2'
[//]: # 'Example3'

```angular-ts
import { skipToken, injectQuery } from '@tanstack/query-angular'

@Component({
  selector: 'todos',
  template: `
    <div>
      // 🚀 applying the filter will enable and execute the query
      <filters-form onApply="filter.set" />
      <todos-table data="query.data()" />
    </div>
  `,
})
export class TodosComponent {
  filter = signal('')

  todosQuery = injectQuery(() => ({
    queryKey: ['todos', this.filter()],
    queryFn: this.filter() ? () => fetchTodos(this.filter()) : skipToken,
  }))
}
```

[//]: # 'Example3'



# ./framework/angular/guides/does-this-replace-client-state.md

---
id: does-this-replace-client-state
title: Does TanStack Query replace global state managers?
ref: docs/framework/react/guides/does-this-replace-client-state.md
replace:
  {
    'useQuery': 'injectQuery',
    'useMutation': 'injectMutation',
    'hook': 'function',
  }
---



# ./framework/angular/guides/mutations.md

---
id: mutations
title: Mutations
ref: docs/framework/react/guides/mutations.md
replace:
  {
    'useMutation': 'injectMutation',
    'hook': 'function',
    'still mounted': 'still active',
    'unmounts': 'gets destroyed',
    'mounted': 'initialized',
  }
---

[//]: # 'Example'

```angular-ts
@Component({
  template: `
    <div>
      @if (mutation.isPending()) {
        <span>Adding todo...</span>
      } @else if (mutation.isError()) {
        <div>An error occurred: {{ mutation.error()?.message }}</div>
      } @else if (mutation.isSuccess()) {
        <div>Todo added!</div>
      }
      <button (click)="mutation.mutate(1)">Create Todo</button>
    </div>
  `,
})
export class TodosComponent {
  todoService = inject(TodoService)
  mutation = injectMutation(() => ({
    mutationFn: (todoId: number) =>
      lastValueFrom(this.todoService.create(todoId)),
  }))
}
```

[//]: # 'Example'
[//]: # 'Info1'
[//]: # 'Info1'
[//]: # 'Example2'
[//]: # 'Example2'
[//]: # 'Example3'

```angular-ts
@Component({
  standalone: true,
  selector: 'todo-item',
  imports: [ReactiveFormsModule],
  template: `
    <form [formGroup]="todoForm" (ngSubmit)="onCreateTodo()">
      @if (mutation.error()) {
        <h5 (click)="mutation.reset()">{{ mutation.error() }}</h5>
      }
      <input type="text" formControlName="title" />
      <br />
      <button type="submit">Create Todo</button>
    </form>
  `,
})
export class TodosComponent {
  mutation = injectMutation(() => ({
    mutationFn: createTodo,
  }))

  fb = inject(NonNullableFormBuilder)

  todoForm = this.fb.group({
    title: this.fb.control('', {
      validators: [Validators.required],
    }),
  })

  title = toSignal(this.todoForm.controls.title.valueChanges, {
    initialValue: '',
  })

  onCreateTodo = () => {
    this.mutation.mutate(this.title())
  }
}
```

[//]: # 'Example3'
[//]: # 'Example4'

```ts
mutation = injectMutation(() => ({
  mutationFn: addTodo,
  onMutate: (variables) => {
    // A mutation is about to happen!

    // Optionally return a context containing data to use when for example rolling back
    return { id: 1 }
  },
  onError: (error, variables, context) => {
    // An error happened!
    console.log(`rolling back optimistic update with id ${context.id}`)
  },
  onSuccess: (data, variables, context) => {
    // Boom baby!
  },
  onSettled: (data, error, variables, context) => {
    // Error or success... doesn't matter!
  },
}))
```

[//]: # 'Example4'
[//]: # 'Example5'

```ts
mutation = injectMutation(() => ({
  mutationFn: addTodo,
  onSuccess: async () => {
    console.log("I'm first!")
  },
  onSettled: async () => {
    console.log("I'm second!")
  },
}))
```

[//]: # 'Example5'
[//]: # 'Example6'

```ts
mutation = injectMutation(() => ({
  mutationFn: addTodo,
  onSuccess: (data, variables, context) => {
    // I will fire first
  },
  onError: (error, variables, context) => {
    // I will fire first
  },
  onSettled: (data, error, variables, context) => {
    // I will fire first
  },
}))

mutation.mutate(todo, {
  onSuccess: (data, variables, context) => {
    // I will fire second!
  },
  onError: (error, variables, context) => {
    // I will fire second!
  },
  onSettled: (data, error, variables, context) => {
    // I will fire second!
  },
})
```

[//]: # 'Example6'
[//]: # 'Example7'

```ts
export class Example {
  mutation = injectMutation(() => ({
    mutationFn: addTodo,
    onSuccess: (data, variables, context) => {
      // Will be called 3 times
    },
  }))

  doMutations() {
    ;['Todo 1', 'Todo 2', 'Todo 3'].forEach((todo) => {
      this.mutation.mutate(todo, {
        onSuccess: (data, variables, context) => {
          // Will execute only once, for the last mutation (Todo 3),
          // regardless which mutation resolves first
        },
      })
    })
  }
}
```

[//]: # 'Example7'
[//]: # 'Example8'

```ts
mutation = injectMutation(() => ({ mutationFn: addTodo }))

try {
  const todo = await mutation.mutateAsync(todo)
  console.log(todo)
} catch (error) {
  console.error(error)
} finally {
  console.log('done')
}
```

[//]: # 'Example8'
[//]: # 'Example9'

```ts
mutation = injectMutation(() => ({
  mutationFn: addTodo,
  retry: 3,
}))
```

[//]: # 'Example9'
[//]: # 'Example10'

```ts
const queryClient = new QueryClient()

// Define the "addTodo" mutation
queryClient.setMutationDefaults(['addTodo'], {
  mutationFn: addTodo,
  onMutate: async (variables) => {
    // Cancel current queries for the todos list
    await queryClient.cancelQueries({ queryKey: ['todos'] })

    // Create optimistic todo
    const optimisticTodo = { id: uuid(), title: variables.title }

    // Add optimistic todo to todos list
    queryClient.setQueryData(['todos'], (old) => [...old, optimisticTodo])

    // Return context with the optimistic todo
    return { optimisticTodo }
  },
  onSuccess: (result, variables, context) => {
    // Replace optimistic todo in the todos list with the result
    queryClient.setQueryData(['todos'], (old) =>
      old.map((todo) =>
        todo.id === context.optimisticTodo.id ? result : todo,
      ),
    )
  },
  onError: (error, variables, context) => {
    // Remove optimistic todo from the todos list
    queryClient.setQueryData(['todos'], (old) =>
      old.filter((todo) => todo.id !== context.optimisticTodo.id),
    )
  },
  retry: 3,
})

class someComponent {
  // Start mutation in some component:
  mutation = injectMutation(() => ({ mutationKey: ['addTodo'] }))

  someMethod() {
    mutation.mutate({ title: 'title' })
  }
}

// If the mutation has been paused because the device is for example offline,
// Then the paused mutation can be dehydrated when the application quits:
const state = dehydrate(queryClient)

// The mutation can then be hydrated again when the application is started:
hydrate(queryClient, state)

// Resume the paused mutations:
queryClient.resumePausedMutations()
```

[//]: # 'Example10'
[//]: # 'Example11'
[//]: # 'Example11'
[//]: # 'Materials'
[//]: # 'Materials'



# ./framework/angular/guides/parallel-queries.md

---
id: parallel-queries
title: Parallel Queries
ref: docs/framework/react/guides/parallel-queries.md
replace:
  {
    'If the number of queries you need to execute is changing from render to render, you cannot use manual querying since that would violate the rules of hooks. Instead, ': '',
    'hook': 'function',
    'React': 'Angular',
    'hooks': 'functions',
    'useQuery': 'injectQuery',
    'useInfiniteQuery': 'injectInfiniteQuery',
    'useQueries': 'injectQueries',
  }
---

[//]: # 'Example'

```ts
export class AppComponent {
  // The following queries will execute in parallel
  usersQuery = injectQuery(() => ({ queryKey: ['users'], queryFn: fetchUsers }))
  teamsQuery = injectQuery(() => ({ queryKey: ['teams'], queryFn: fetchTeams }))
  projectsQuery = injectQuery(() => ({
    queryKey: ['projects'],
    queryFn: fetchProjects,
  }))
}
```

[//]: # 'Example'
[//]: # 'Info'
[//]: # 'Info'
[//]: # 'DynamicParallelIntro'

TanStack Query provides `injectQueries`, which you can use to dynamically execute as many queries in parallel as you'd like.

[//]: # 'DynamicParallelIntro'
[//]: # 'Example2'

```ts
export class AppComponent {
  users = signal<Array<User>>([])

  // Please note injectQueries is under development and this code does not work yet
  userQueries = injectQueries(() => ({
    queries: users().map((user) => {
      return {
        queryKey: ['user', user.id],
        queryFn: () => fetchUserById(user.id),
      }
    }),
  }))
}
```

[//]: # 'Example2'



# ./framework/angular/guides/mutation-options.md

---
id: query-options
title: Mutation Options
---

One of the best ways to share mutation options between multiple places,
is to use the `mutationOptions` helper. At runtime, this helper just returns whatever you pass into it,
but it has a lot of advantages when using it [with TypeScript](../../typescript#typing-query-options).
You can define all possible options for a mutation in one place,
and you'll also get type inference and type safety for all of them.

```ts
export class QueriesService {
  private http = inject(HttpClient)

  updatePost(id: number) {
    return mutationOptions({
      mutationFn: (post: Post) => Promise.resolve(post),
      mutationKey: ['updatePost', id],
      onSuccess: (newPost) => {
        //           ^? newPost: Post
        this.queryClient.setQueryData(['posts', id], newPost)
      },
    })
  }
}
```



# ./framework/angular/guides/query-keys.md

---
id: query-keys
title: Query Keys
ref: docs/framework/react/guides/query-keys.md
#todo: exhaustive-deps is at least for now React-only
---

[//]: # 'Example'

```ts
// A list of todos
injectQuery(() => ({ queryKey: ['todos'], ... }))

// Something else, whatever!
injectQuery(() => ({ queryKey: ['something', 'special'], ... }))
```

[//]: # 'Example'
[//]: # 'Example2'

```ts
// An individual todo
injectQuery(() => ({queryKey: ['todo', 5], ...}))

// An individual todo in a "preview" format
injectQuery(() => ({queryKey: ['todo', 5, {preview: true}], ...}))

// A list of todos that are "done"
injectQuery(() => ({queryKey: ['todos', {type: 'done'}], ...}))
```

[//]: # 'Example2'
[//]: # 'Example3'

```ts
injectQuery(() => ({ queryKey: ['todos', { status, page }], ... }))
injectQuery(() => ({ queryKey: ['todos', { page, status }], ...}))
injectQuery(() => ({ queryKey: ['todos', { page, status, other: undefined }], ... }))
```

[//]: # 'Example3'
[//]: # 'Example4'

```ts
injectQuery(() => ({ queryKey: ['todos', status, page], ... }))
injectQuery(() => ({ queryKey: ['todos', page, status], ...}))
injectQuery(() => ({ queryKey: ['todos', undefined, page, status], ...}))
```

[//]: # 'Example4'
[//]: # 'Example5'

```ts
todoId = signal(-1)

injectQuery(() => ({
  enabled: todoId() > 0,
  queryKey: ['todos', todoId()],
  queryFn: () => fetchTodoById(todoId()),
}))
```

[//]: # 'Example5'
[//]: # 'Materials'
[//]: # 'Materials'



# ./framework/angular/guides/background-fetching-indicators.md

---
id: background-fetching-indicators
title: Background Fetching Indicators
ref: docs/framework/react/guides/background-fetching-indicators.md
---

[//]: # 'Example'

```angular-ts
@Component({
  selector: 'todos',
  template: `
    @if (todosQuery.isPending()) {
      Loading...
    } @else if (todosQuery.isError()) {
      An error has occurred: {{ todosQuery.error().message }}
    } @else if (todosQuery.isSuccess()) {
      @if (todosQuery.isFetching()) {
        Refreshing...
      }
      @for (todos of todosQuery.data(); track todo.id) {
        <todo [todo]="todo" />
      }
    }
  `,
})
class TodosComponent {
  todosQuery = injectQuery(() => ({
    queryKey: ['todos'],
    queryFn: fetchTodos,
  }))
}
```

[//]: # 'Example'
[//]: # 'Example2'

```angular-ts
import { injectIsFetching } from '@tanstack/angular-query-experimental'

@Component({
  selector: 'global-loading-indicator',
  template: `
    @if (isFetching()) {
      <div>Queries are fetching in the background...</div>
    }
  `,
})
export class GlobalLoadingIndicatorComponent {
  isFetching = injectIsFetching()
}
```

[//]: # 'Example2'



# ./framework/angular/angular-httpclient-and-other-data-fetching-clients.md

---
id: Angular-HttpClient-and-other-data-fetching-clients
title: Angular HttpClient and other data fetching clients
---

Because TanStack Query's fetching mechanisms are agnostically built on Promises, you can use literally any asynchronous data fetching client, including the browser native `fetch` API, `graphql-request`, and more.

## Using Angular's `HttpClient` for data fetching

`HttpClient` is a powerful and integrated part of Angular, which gives the following benefits:

- Mock responses in unit tests using [provideHttpClientTesting](https://angular.dev/guide/http/testing).
- [Interceptors](https://angular.dev/guide/http/interceptors) can be used for a wide range of functionality including adding authentication headers, performing logging, etc. While some data fetching libraries have their own interceptor system, `HttpClient` interceptors are integrated with Angular's dependency injection system.
- `HttpClient` automatically informs [`PendingTasks`](https://angular.dev/api/core/PendingTasks#), which enables Angular to be aware of pending requests. Unit tests and SSR can use the resulting application _stableness_ information to wait for pending requests to finish. This makes unit testing much easier for [Zoneless](https://angular.dev/guide/experimental/zoneless) applications.
- When using SSR, `HttpClient` will [cache requests](https://angular.dev/guide/ssr#caching-data-when-using-HttpClient) performed on the server. This will prevent unneeded requests on the client. `HttpClient` SSR caching works out of the box. TanStack Query has its own hydration functionality which may be more powerful but requires some setup. Which one fits your needs best depends on your use case.

### Using observables in `queryFn`

As TanStack Query is a promise based library, observables from `HttpClient` need to be converted to promises. This can be done with the `lastValueFrom` or `firstValueFrom` functions from `rxjs`.

```ts
@Component({
  // ...
})
class ExampleComponent {
  private readonly http = inject(HttpClient)

  readonly query = injectQuery(() => ({
    queryKey: ['repoData'],
    queryFn: () =>
      lastValueFrom(
        this.http.get('https://api.github.com/repos/tanstack/query'),
      ),
  }))
}
```

> Since Angular is moving towards RxJS as an optional dependency, it's expected that `HttpClient` will also support promises in the future.
>
> Support for observables in TanStack Query for Angular is planned.

## Comparison table

| Data fetching client                                | Pros                                                | Cons                                                                       |
| --------------------------------------------------- | --------------------------------------------------- | -------------------------------------------------------------------------- |
| **Angular HttpClient**                              | Featureful and very well integrated with Angular.   | Observables need to be converted to Promises.                              |
| **Fetch**                                           | Browser native API, so adds nothing to bundle size. | Barebones API which lacks many features.                                   |
| **Specialized libraries such as `graphql-request`** | Specialized features for specific use cases.        | If it's not an Angular library it won't integrate well with the framework. |



# ./framework/angular/installation.md

---
id: installation
title: Installation
---

> IMPORTANT: This library is currently in an experimental stage. This means that breaking changes will happen in minor AND patch releases. Upgrade carefully. If you use this in production while in experimental stage, please lock your version to a patch-level version to avoid unexpected breaking changes.

### NPM

_Angular Query is compatible with Angular v16 and higher_

```bash
npm i @tanstack/angular-query-experimental
```

or

```bash
pnpm add @tanstack/angular-query-experimental
```

or

```bash
yarn add @tanstack/angular-query-experimental
```

or

```bash
bun add @tanstack/angular-query-experimental
```

> Wanna give it a spin before you download? Try out the [simple](../examples/simple) or [basic](../examples/basic) examples!



# ./framework/angular/typescript.md

---
id: typescript
title: TypeScript
ref: docs/framework/react/typescript.md
replace:
  {
    'useQuery': 'injectQuery',
    'useMutation': 'injectMutation',
    'react-query': 'angular-query-experimental',
    'public API of React Query': 'public API of TanStack Query and - after the experimental phase, the angular-query package',
    'still follows': 'still follow',
    'React Query': 'TanStack Query',
    '`success`': '`isSuccess()`',
    'function:': 'function.',
  }
---

[//]: # 'TypeInference1'

```angular-ts
@Component({
  // ...
  template: `@let data = query.data();`,
  //               ^? data: number | undefined
})
class MyComponent {
  query = injectQuery(() => ({
    queryKey: ['test'],
    queryFn: () => Promise.resolve(5),
  }))
}
```

[//]: # 'TypeInference1'
[//]: # 'TypeInference2'

```angular-ts
@Component({
  // ...
  template: `@let data = query.data();`,
  //               ^? data: string | undefined
})
class MyComponent {
  query = injectQuery(() => ({
    queryKey: ['test'],
    queryFn: () => Promise.resolve(5),
    select: (data) => data.toString(),
  }))
}
```

[//]: # 'TypeInference2'
[//]: # 'TypeInference3'

In this example we pass Group[] to the type parameter of HttpClient's `get` method.

```angular-ts
@Component({
  template: `@let data = query.data();`,
  //               ^? data: Group[] | undefined
})
class MyComponent {
  http = inject(HttpClient)

  query = injectQuery(() => ({
    queryKey: ['groups'],
    queryFn: () => lastValueFrom(this.http.get<Group[]>('/groups')),
  }))
}
```

[//]: # 'TypeInference3'
[//]: # 'TypeNarrowing'

```angular-ts
@Component({
  // ...
  template: `
    @if (query.isSuccess()) {
      @let data = query.data();
      //    ^? data: number
    }
  `,
})
class MyComponent {
  query = injectQuery(() => ({
    queryKey: ['test'],
    queryFn: () => Promise.resolve(5),
  }))
}
```

> TypeScript currently does not support discriminated unions on object methods. Narrowing on signal fields on objects such as query results only works on signals returning a boolean. Prefer using `isSuccess()` and similar boolean status signals over `status() === 'success'`.

[//]: # 'TypeNarrowing'
[//]: # 'TypingError'

```angular-ts
@Component({
  // ...
  template: `@let error = query.error();`,
  //                ^? error: Error | null
})
class MyComponent {
  query = injectQuery(() => ({
    queryKey: ['groups'],
    queryFn: fetchGroups
  }))
}
```

[//]: # 'TypingError'
[//]: # 'TypingError2'

```angular-ts
@Component({
  // ...
  template: `@let error = query.error();`,
  //                ^? error: string | null
})
class MyComponent {
  query = injectQuery<Group[], string>(() => ({
    queryKey: ['groups'],
    queryFn: fetchGroups,
  }))
}
```

[//]: # 'TypingError2'
[//]: # 'TypingError3'

```ts
import axios from 'axios'

query = injectQuery(() => ({ queryKey: ['groups'], queryFn: fetchGroups }))

computed(() => {
  const error = query.error()
  //     ^? error: Error | null

  if (axios.isAxiosError(error)) {
    error
    // ^? const error: AxiosError
  }
})
```

[//]: # 'TypingError3'
[//]: # 'RegisterErrorType'

```ts
import '@tanstack/angular-query-experimental'

declare module '@tanstack/angular-query-experimental' {
  interface Register {
    defaultError: AxiosError
  }
}

const query = injectQuery(() => ({
  queryKey: ['groups'],
  queryFn: fetchGroups,
}))

computed(() => {
  const error = query.error()
  //      ^? error: AxiosError | null
})
```

[//]: # 'RegisterErrorType'
[//]: # 'TypingQueryOptions'

## Typing Query Options

If you inline query options into `injectQuery`, you'll get automatic type inference. However, you might want to extract the query options into a separate function to share them between `injectQuery` and e.g. `prefetchQuery` or manage them in a service. In that case, you'd lose type inference. To get it back, you can use the `queryOptions` helper:

```ts
@Injectable({
  providedIn: 'root',
})
export class QueriesService {
  private http = inject(HttpClient)

  post(postId: number) {
    return queryOptions({
      queryKey: ['post', postId],
      queryFn: () => {
        return lastValueFrom(
          this.http.get<Post>(
            `https://jsonplaceholder.typicode.com/posts/${postId}`,
          ),
        )
      },
    })
  }
}

@Component({
  // ...
})
export class Component {
  queryClient = inject(QueryClient)

  postId = signal(1)

  queries = inject(QueriesService)
  optionsSignal = computed(() => this.queries.post(this.postId()))

  postQuery = injectQuery(() => this.queries.post(1))
  postQuery = injectQuery(() => this.queries.post(this.postId()))

  // You can also pass a signal which returns query options
  postQuery = injectQuery(this.optionsSignal)

  someMethod() {
    this.queryClient.prefetchQuery(this.queries.post(23))
  }
}
```

Further, the `queryKey` returned from `queryOptions` knows about the `queryFn` associated with it, and we can leverage that type information to make functions like `queryClient.getQueryData` aware of those types as well:

```ts
data = this.queryClient.getQueryData(groupOptions().queryKey)
// ^? data: Post | undefined
```

Without `queryOptions`, the type of data would be unknown, unless we'd pass a type parameter:

```ts
data = queryClient.getQueryData<Post>(['post', 1])
```

## Typing Mutation Options

Similarly to `queryOptions`, you can use `mutationOptions` to extract mutation options into a separate function:

```ts
export class QueriesService {
  private http = inject(HttpClient)

  updatePost(id: number) {
    return mutationOptions({
      mutationFn: (post: Post) => Promise.resolve(post),
      mutationKey: ['updatePost', id],
      onSuccess: (newPost) => {
        //           ^? newPost: Post
        this.queryClient.setQueryData(['posts', id], newPost)
      },
    })
  }
}
```

[//]: # 'TypingQueryOptions'
[//]: # 'Materials'
[//]: # 'Materials'



# ./framework/angular/reference/type-aliases/createmutatefunction.md

---
id: CreateMutateFunction
title: CreateMutateFunction
---

# Type Alias: CreateMutateFunction()\<TData, TError, TVariables, TContext\>

```ts
type CreateMutateFunction<TData, TError, TVariables, TContext>: (...args) => void;
```

## Type Parameters

• **TData** = `unknown`

• **TError** = `DefaultError`

• **TVariables** = `void`

• **TContext** = `unknown`

## Parameters

• ...**args**: `Parameters`\<`MutateFunction`\<`TData`, `TError`, `TVariables`, `TContext`\>\>

## Returns

`void`

## Defined in

[types.ts:176](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L176)



# ./framework/angular/reference/type-aliases/nonundefinedguard.md

---
id: NonUndefinedGuard
title: NonUndefinedGuard
---

# Type Alias: NonUndefinedGuard\<T\>

```ts
type NonUndefinedGuard<T>: T extends undefined ? never : T;
```

## Type Parameters

• **T**

## Defined in

[types.ts:316](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L316)



# ./framework/angular/reference/type-aliases/createbasequeryresult.md

---
id: CreateBaseQueryResult
title: CreateBaseQueryResult
---

# Type Alias: CreateBaseQueryResult\<TData, TError, TState\>

```ts
type CreateBaseQueryResult<TData, TError, TState>: BaseQueryNarrowing<TData, TError> & MapToSignals<OmitKeyof<TState, keyof BaseQueryNarrowing, "safely">>;
```

## Type Parameters

• **TData** = `unknown`

• **TError** = `DefaultError`

• **TState** = `QueryObserverResult`\<`TData`, `TError`\>

## Defined in

[types.ts:116](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L116)



# ./framework/angular/reference/type-aliases/definedcreatequeryresult.md

---
id: DefinedCreateQueryResult
title: DefinedCreateQueryResult
---

# Type Alias: DefinedCreateQueryResult\<TData, TError, TDefinedQueryObserver\>

```ts
type DefinedCreateQueryResult<TData, TError, TDefinedQueryObserver>: MapToSignals<TDefinedQueryObserver>;
```

## Type Parameters

• **TData** = `unknown`

• **TError** = `DefaultError`

• **TDefinedQueryObserver** = `DefinedQueryObserverResult`\<`TData`, `TError`\>

## Defined in

[types.ts:134](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L134)



# ./framework/angular/reference/type-aliases/undefinedinitialdataoptions.md

---
id: UndefinedInitialDataOptions
title: UndefinedInitialDataOptions
---

# Type Alias: UndefinedInitialDataOptions\<TQueryFnData, TError, TData, TQueryKey\>

```ts
type UndefinedInitialDataOptions<TQueryFnData, TError, TData, TQueryKey>: CreateQueryOptions<TQueryFnData, TError, TData, TQueryKey> & object;
```

## Type declaration

### initialData?

```ts
optional initialData: undefined;
```

## Type Parameters

• **TQueryFnData** = `unknown`

• **TError** = `DefaultError`

• **TData** = `TQueryFnData`

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

## Defined in

[query-options.ts:7](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/query-options.ts#L7)



# ./framework/angular/reference/type-aliases/queriesoptions.md

---
id: QueriesOptions
title: QueriesOptions
---

# Type Alias: QueriesOptions\<T, TResult, TDepth\>

```ts
type QueriesOptions<T, TResult, TDepth>: TDepth["length"] extends MAXIMUM_DEPTH ? QueryObserverOptionsForCreateQueries[] : T extends [] ? [] : T extends [infer Head] ? [...TResult, GetOptions<Head>] : T extends [infer Head, ...(infer Tail)] ? QueriesOptions<[...Tail], [...TResult, GetOptions<Head>], [...TDepth, 1]> : ReadonlyArray<unknown> extends T ? T : T extends QueryObserverOptionsForCreateQueries<infer TQueryFnData, infer TError, infer TData, infer TQueryKey>[] ? QueryObserverOptionsForCreateQueries<TQueryFnData, TError, TData, TQueryKey>[] : QueryObserverOptionsForCreateQueries[];
```

QueriesOptions reducer recursively unwraps function arguments to infer/enforce type param

## Type Parameters

• **T** _extends_ `any`[]

• **TResult** _extends_ `any`[] = []

• **TDepth** _extends_ `ReadonlyArray`\<`number`\> = []

## Defined in

[inject-queries.ts:108](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-queries.ts#L108)



# ./framework/angular/reference/type-aliases/definedcreateinfinitequeryresult.md

---
id: DefinedCreateInfiniteQueryResult
title: DefinedCreateInfiniteQueryResult
---

# Type Alias: DefinedCreateInfiniteQueryResult\<TData, TError, TDefinedInfiniteQueryObserver\>

```ts
type DefinedCreateInfiniteQueryResult<TData, TError, TDefinedInfiniteQueryObserver>: MapToSignals<TDefinedInfiniteQueryObserver>;
```

## Type Parameters

• **TData** = `unknown`

• **TError** = `DefaultError`

• **TDefinedInfiniteQueryObserver** = `DefinedInfiniteQueryObserverResult`\<`TData`, `TError`\>

## Defined in

[types.ts:151](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L151)



# ./framework/angular/reference/type-aliases/queriesresults.md

---
id: QueriesResults
title: QueriesResults
---

# Type Alias: QueriesResults\<T, TResult, TDepth\>

```ts
type QueriesResults<T, TResult, TDepth>: TDepth["length"] extends MAXIMUM_DEPTH ? QueryObserverResult[] : T extends [] ? [] : T extends [infer Head] ? [...TResult, GetResults<Head>] : T extends [infer Head, ...(infer Tail)] ? QueriesResults<[...Tail], [...TResult, GetResults<Head>], [...TDepth, 1]> : T extends QueryObserverOptionsForCreateQueries<infer TQueryFnData, infer TError, infer TData, any>[] ? QueryObserverResult<unknown extends TData ? TQueryFnData : TData, unknown extends TError ? DefaultError : TError>[] : QueryObserverResult[];
```

QueriesResults reducer recursively maps type param to results

## Type Parameters

• **T** _extends_ `any`[]

• **TResult** _extends_ `any`[] = []

• **TDepth** _extends_ `ReadonlyArray`\<`number`\> = []

## Defined in

[inject-queries.ts:151](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-queries.ts#L151)



# ./framework/angular/reference/type-aliases/createmutationresult.md

---
id: CreateMutationResult
title: CreateMutationResult
---

# Type Alias: CreateMutationResult\<TData, TError, TVariables, TContext, TState\>

```ts
type CreateMutationResult<TData, TError, TVariables, TContext, TState>: BaseMutationNarrowing<TData, TError, TVariables, TContext> & MapToSignals<OmitKeyof<TState, keyof BaseMutationNarrowing, "safely">>;
```

## Type Parameters

• **TData** = `unknown`

• **TError** = `DefaultError`

• **TVariables** = `unknown`

• **TContext** = `unknown`

• **TState** = `CreateStatusBasedMutationResult`\<[`CreateBaseMutationResult`](createbasemutationresult.md)\[`"status"`\], `TData`, `TError`, `TVariables`, `TContext`\>

## Defined in

[types.ts:292](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L292)



# ./framework/angular/reference/type-aliases/createbasemutationresult.md

---
id: CreateBaseMutationResult
title: CreateBaseMutationResult
---

# Type Alias: CreateBaseMutationResult\<TData, TError, TVariables, TContext\>

```ts
type CreateBaseMutationResult<TData, TError, TVariables, TContext>: Override<MutationObserverResult<TData, TError, TVariables, TContext>, object> & object;
```

## Type declaration

### mutateAsync

```ts
mutateAsync: CreateMutateAsyncFunction<TData, TError, TVariables, TContext>
```

## Type Parameters

• **TData** = `unknown`

• **TError** = `DefaultError`

• **TVariables** = `unknown`

• **TContext** = `unknown`

## Defined in

[types.ts:198](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L198)



# ./framework/angular/reference/type-aliases/createmutateasyncfunction.md

---
id: CreateMutateAsyncFunction
title: CreateMutateAsyncFunction
---

# Type Alias: CreateMutateAsyncFunction\<TData, TError, TVariables, TContext\>

```ts
type CreateMutateAsyncFunction<TData, TError, TVariables, TContext>: MutateFunction<TData, TError, TVariables, TContext>;
```

## Type Parameters

• **TData** = `unknown`

• **TError** = `DefaultError`

• **TVariables** = `void`

• **TContext** = `unknown`

## Defined in

[types.ts:188](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L188)



# ./framework/angular/reference/type-aliases/createinfinitequeryresult.md

---
id: CreateInfiniteQueryResult
title: CreateInfiniteQueryResult
---

# Type Alias: CreateInfiniteQueryResult\<TData, TError\>

```ts
type CreateInfiniteQueryResult<TData, TError>: MapToSignals<InfiniteQueryObserverResult<TData, TError>>;
```

## Type Parameters

• **TData** = `unknown`

• **TError** = `DefaultError`

## Defined in

[types.ts:143](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L143)



# ./framework/angular/reference/type-aliases/definedinitialdatainfiniteoptions.md

---
id: DefinedInitialDataInfiniteOptions
title: DefinedInitialDataInfiniteOptions
---

# Type Alias: DefinedInitialDataInfiniteOptions\<TQueryFnData, TError, TData, TQueryKey, TPageParam\>

```ts
type DefinedInitialDataInfiniteOptions<TQueryFnData, TError, TData, TQueryKey, TPageParam>: CreateInfiniteQueryOptions<TQueryFnData, TError, TData, TQueryFnData, TQueryKey, TPageParam> & object;
```

## Type declaration

### initialData

```ts
initialData: NonUndefinedGuard<InfiniteData<TQueryFnData, TPageParam>> | () => NonUndefinedGuard<InfiniteData<TQueryFnData, TPageParam>>;
```

## Type Parameters

• **TQueryFnData**

• **TError** = `DefaultError`

• **TData** = `InfiniteData`\<`TQueryFnData`\>

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

• **TPageParam** = `unknown`

## Defined in

[infinite-query-options.ts:32](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/infinite-query-options.ts#L32)



# ./framework/angular/reference/type-aliases/definedinitialdataoptions.md

---
id: DefinedInitialDataOptions
title: DefinedInitialDataOptions
---

# Type Alias: DefinedInitialDataOptions\<TQueryFnData, TError, TData, TQueryKey\>

```ts
type DefinedInitialDataOptions<TQueryFnData, TError, TData, TQueryKey>: CreateQueryOptions<TQueryFnData, TError, TData, TQueryKey> & object;
```

## Type declaration

### initialData

```ts
initialData: NonUndefinedGuard<TQueryFnData> | () => NonUndefinedGuard<TQueryFnData>;
```

## Type Parameters

• **TQueryFnData** = `unknown`

• **TError** = `DefaultError`

• **TData** = `TQueryFnData`

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

## Defined in

[query-options.ts:19](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/query-options.ts#L19)



# ./framework/angular/reference/type-aliases/undefinedinitialdatainfiniteoptions.md

---
id: UndefinedInitialDataInfiniteOptions
title: UndefinedInitialDataInfiniteOptions
---

# Type Alias: UndefinedInitialDataInfiniteOptions\<TQueryFnData, TError, TData, TQueryKey, TPageParam\>

```ts
type UndefinedInitialDataInfiniteOptions<TQueryFnData, TError, TData, TQueryKey, TPageParam>: CreateInfiniteQueryOptions<TQueryFnData, TError, TData, TQueryFnData, TQueryKey, TPageParam> & object;
```

## Type declaration

### initialData?

```ts
optional initialData: undefined;
```

## Type Parameters

• **TQueryFnData**

• **TError** = `DefaultError`

• **TData** = `InfiniteData`\<`TQueryFnData`\>

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

• **TPageParam** = `unknown`

## Defined in

[infinite-query-options.ts:12](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/infinite-query-options.ts#L12)



# ./framework/angular/reference/type-aliases/createqueryresult.md

---
id: CreateQueryResult
title: CreateQueryResult
---

# Type Alias: CreateQueryResult\<TData, TError\>

```ts
type CreateQueryResult<TData, TError>: CreateBaseQueryResult<TData, TError>;
```

## Type Parameters

• **TData** = `unknown`

• **TError** = `DefaultError`

## Defined in

[types.ts:126](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L126)



# ./framework/angular/reference/index.md

---
id: '@tanstack/angular-query-experimental'
title: '@tanstack/angular-query-experimental'
---

# @tanstack/angular-query-experimental

## Interfaces

- [BaseMutationNarrowing](interfaces/basemutationnarrowing.md)
- [BaseQueryNarrowing](interfaces/basequerynarrowing.md)
- [CreateBaseQueryOptions](interfaces/createbasequeryoptions.md)
- [CreateInfiniteQueryOptions](interfaces/createinfinitequeryoptions.md)
- [CreateMutationOptions](interfaces/createmutationoptions.md)
- [CreateQueryOptions](interfaces/createqueryoptions.md)
- [InjectMutationStateOptions](interfaces/injectmutationstateoptions.md)

## Type Aliases

- [CreateBaseMutationResult](type-aliases/createbasemutationresult.md)
- [CreateBaseQueryResult](type-aliases/createbasequeryresult.md)
- [CreateInfiniteQueryResult](type-aliases/createinfinitequeryresult.md)
- [CreateMutateAsyncFunction](type-aliases/createmutateasyncfunction.md)
- [CreateMutateFunction](type-aliases/createmutatefunction.md)
- [CreateMutationResult](type-aliases/createmutationresult.md)
- [CreateQueryResult](type-aliases/createqueryresult.md)
- [DefinedCreateInfiniteQueryResult](type-aliases/definedcreateinfinitequeryresult.md)
- [DefinedCreateQueryResult](type-aliases/definedcreatequeryresult.md)
- [DefinedInitialDataInfiniteOptions](type-aliases/definedinitialdatainfiniteoptions.md)
- [DefinedInitialDataOptions](type-aliases/definedinitialdataoptions.md)
- [NonUndefinedGuard](type-aliases/nonundefinedguard.md)
- [QueriesOptions](type-aliases/queriesoptions.md)
- [QueriesResults](type-aliases/queriesresults.md)
- [UndefinedInitialDataInfiniteOptions](type-aliases/undefinedinitialdatainfiniteoptions.md)
- [UndefinedInitialDataOptions](type-aliases/undefinedinitialdataoptions.md)

## Functions

- [infiniteQueryOptions](functions/infinitequeryoptions.md)
- [injectInfiniteQuery](functions/injectinfinitequery.md)
- [injectIsFetching](functions/injectisfetching.md)
- [injectIsMutating](functions/injectismutating.md)
- [injectMutation](functions/injectmutation.md)
- [injectMutationState](functions/injectmutationstate.md)
- [injectQueries](functions/injectqueries.md)
- [injectQuery](functions/injectquery.md)
- [injectQueryClient](functions/injectqueryclient.md)
- [provideAngularQuery](functions/provideangularquery.md)
- [provideQueryClient](functions/providequeryclient.md)
- [queryOptions](functions/queryoptions.md)



# ./framework/angular/reference/functions/injectqueries.md

---
id: injectQueries
title: injectQueries
---

# Function: injectQueries()

```ts
function injectQueries<T, TCombinedResult>(
  __namedParameters,
  injector?,
): Signal<TCombinedResult>
```

## Type Parameters

• **T** _extends_ `any`[]

• **TCombinedResult** = `T` _extends_ [] ? [] : `T` _extends_ [`Head`] ? [`GetResults`\<`Head`\>] : `T` _extends_ [`Head`, `...Tail[]`] ? [`...Tail[]`] _extends_ [] ? [] : [`...Tail[]`] _extends_ [`Head`] ? [`GetResults`\<`Head`\>, `GetResults`\<`Head`\>] : [`...Tail[]`] _extends_ [`Head`, `...Tail[]`] ? [`...Tail[]`] _extends_ [] ? [] : [`...Tail[]`] _extends_ [`Head`] ? [`GetResults`\<`Head`\>, `GetResults`\<`Head`\>, `GetResults`\<`Head`\>] : [`...Tail[]`] _extends_ [`Head`, `...Tail[]`] ? [`...(...)[]`] _extends_ [] ? [] : ... _extends_ ... ? ... : ... : [`...(...)[]`] _extends_ ...[] ? ...[] : ...[] : [`...Tail[]`] _extends_ `QueryObserverOptionsForCreateQueries`\<`TQueryFnData`, `TError`, `TData`, `any`\>[] ? `QueryObserverResult`\<`unknown` _extends_ `TData` ? `TQueryFnData` : `TData`, `unknown` _extends_ `TError` ? `Error` : `TError`\>[] : `QueryObserverResult`[] : `T` _extends_ `QueryObserverOptionsForCreateQueries`\<`TQueryFnData`, `TError`, `TData`, `any`\>[] ? `QueryObserverResult`\<`unknown` _extends_ `TData` ? `TQueryFnData` : `TData`, `unknown` _extends_ `TError` ? `Error` : `TError`\>[] : `QueryObserverResult`[]

## Parameters

• **\_\_namedParameters**

• **\_\_namedParameters.combine?**

• **\_\_namedParameters.queries?**: `Signal`\<[`...(T extends [] ? [] : T extends [Head] ? [GetOptions<Head>] : T extends [Head, ...Tail[]] ? [...Tail[]] extends [] ? [] : [...Tail[]] extends [Head] ? [GetOptions<Head>, GetOptions<Head>] : [...Tail[]] extends [Head, ...Tail[]] ? [...(...)[]] extends [] ? [] : (...) extends (...) ? (...) : (...) : readonly (...)[] extends [...(...)[]] ? [...(...)[]] : (...) extends (...) ? (...) : (...) : readonly unknown[] extends T ? T : T extends QueryObserverOptionsForCreateQueries<TQueryFnData, TError, TData, TQueryKey>[] ? QueryObserverOptionsForCreateQueries<TQueryFnData, TError, TData, TQueryKey>[] : QueryObserverOptionsForCreateQueries<unknown, Error, unknown, QueryKey>[])[]`]\>

• **injector?**: `Injector`

## Returns

`Signal`\<`TCombinedResult`\>

## Defined in

[inject-queries.ts:188](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-queries.ts#L188)



# ./framework/angular/reference/functions/injectinfinitequery.md

---
id: injectInfiniteQuery
title: injectInfiniteQuery
---

# Function: injectInfiniteQuery()

Injects an infinite query: a declarative dependency on an asynchronous source of data that is tied to a unique key.
Infinite queries can additively "load more" data onto an existing set of data or "infinite scroll"

## Param

A function that returns infinite query options.

## Param

The Angular injector to use.

## injectInfiniteQuery(optionsFn, injector)

```ts
function injectInfiniteQuery<
  TQueryFnData,
  TError,
  TData,
  TQueryKey,
  TPageParam,
>(optionsFn, injector?): CreateInfiniteQueryResult<TData, TError>
```

Injects an infinite query: a declarative dependency on an asynchronous source of data that is tied to a unique key.
Infinite queries can additively "load more" data onto an existing set of data or "infinite scroll"

### Type Parameters

• **TQueryFnData**

• **TError** = `Error`

• **TData** = `InfiniteData`\<`TQueryFnData`, `unknown`\>

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

• **TPageParam** = `unknown`

### Parameters

• **optionsFn**

A function that returns infinite query options.

• **injector?**: `Injector`

The Angular injector to use.

### Returns

[`CreateInfiniteQueryResult`](../type-aliases/createinfinitequeryresult.md)\<`TData`, `TError`\>

The infinite query result.

The infinite query result.

### Param

A function that returns infinite query options.

### Param

The Angular injector to use.

### Defined in

[inject-infinite-query.ts:30](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-infinite-query.ts#L30)

## injectInfiniteQuery(optionsFn, injector)

```ts
function injectInfiniteQuery<
  TQueryFnData,
  TError,
  TData,
  TQueryKey,
  TPageParam,
>(optionsFn, injector?): DefinedCreateInfiniteQueryResult<TData, TError>
```

Injects an infinite query: a declarative dependency on an asynchronous source of data that is tied to a unique key.
Infinite queries can additively "load more" data onto an existing set of data or "infinite scroll"

### Type Parameters

• **TQueryFnData**

• **TError** = `Error`

• **TData** = `InfiniteData`\<`TQueryFnData`, `unknown`\>

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

• **TPageParam** = `unknown`

### Parameters

• **optionsFn**

A function that returns infinite query options.

• **injector?**: `Injector`

The Angular injector to use.

### Returns

[`DefinedCreateInfiniteQueryResult`](../type-aliases/definedcreateinfinitequeryresult.md)\<`TData`, `TError`\>

The infinite query result.

The infinite query result.

### Param

A function that returns infinite query options.

### Param

The Angular injector to use.

### Defined in

[inject-infinite-query.ts:57](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-infinite-query.ts#L57)

## injectInfiniteQuery(optionsFn, injector)

```ts
function injectInfiniteQuery<
  TQueryFnData,
  TError,
  TData,
  TQueryKey,
  TPageParam,
>(optionsFn, injector?): CreateInfiniteQueryResult<TData, TError>
```

Injects an infinite query: a declarative dependency on an asynchronous source of data that is tied to a unique key.
Infinite queries can additively "load more" data onto an existing set of data or "infinite scroll"

### Type Parameters

• **TQueryFnData**

• **TError** = `Error`

• **TData** = `InfiniteData`\<`TQueryFnData`, `unknown`\>

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

• **TPageParam** = `unknown`

### Parameters

• **optionsFn**

A function that returns infinite query options.

• **injector?**: `Injector`

The Angular injector to use.

### Returns

[`CreateInfiniteQueryResult`](../type-aliases/createinfinitequeryresult.md)\<`TData`, `TError`\>

The infinite query result.

The infinite query result.

### Param

A function that returns infinite query options.

### Param

The Angular injector to use.

### Defined in

[inject-infinite-query.ts:84](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-infinite-query.ts#L84)



# ./framework/angular/reference/functions/injectismutating.md

---
id: injectIsMutating
title: injectIsMutating
---

# Function: injectIsMutating()

```ts
function injectIsMutating(filters?, injector?): Signal<number>
```

Injects a signal that tracks the number of mutations that your application is fetching.

Can be used for app-wide loading indicators

## Parameters

• **filters?**: `MutationFilters`

The filters to apply to the query.

• **injector?**: `Injector`

The Angular injector to use.

## Returns

`Signal`\<`number`\>

signal with number of fetching mutations.

## Defined in

[inject-is-mutating.ts:16](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-is-mutating.ts#L16)



# ./framework/angular/reference/functions/injectmutation.md

---
id: injectMutation
title: injectMutation
---

# Function: injectMutation()

```ts
function injectMutation<TData, TError, TVariables, TContext>(
  optionsFn,
  injector?,
): CreateMutationResult<TData, TError, TVariables, TContext>
```

Injects a mutation: an imperative function that can be invoked which typically performs server side effects.

Unlike queries, mutations are not run automatically.

## Type Parameters

• **TData** = `unknown`

• **TError** = `Error`

• **TVariables** = `void`

• **TContext** = `unknown`

## Parameters

• **optionsFn**

A function that returns mutation options.

• **injector?**: `Injector`

The Angular injector to use.

## Returns

[`CreateMutationResult`](../type-aliases/createmutationresult.md)\<`TData`, `TError`, `TVariables`, `TContext`\>

The mutation.

## Defined in

[inject-mutation.ts:38](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-mutation.ts#L38)



# ./framework/angular/reference/functions/injectmutationstate.md

---
id: injectMutationState
title: injectMutationState
---

# Function: injectMutationState()

```ts
function injectMutationState<TResult>(
  mutationStateOptionsFn,
  options?,
): Signal<TResult[]>
```

Injects a signal that tracks the state of all mutations.

## Type Parameters

• **TResult** = `MutationState`\<`unknown`, `Error`, `unknown`, `unknown`\>

## Parameters

• **mutationStateOptionsFn** = `...`

A function that returns mutation state options.

• **options?**: [`InjectMutationStateOptions`](../interfaces/injectmutationstateoptions.md)

The Angular injector to use.

## Returns

`Signal`\<`TResult`[]\>

The signal that tracks the state of all mutations.

## Defined in

[inject-mutation-state.ts:53](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-mutation-state.ts#L53)



# ./framework/angular/reference/functions/provideangularquery.md

---
id: provideAngularQuery
title: provideAngularQuery
---

# Function: provideAngularQuery()

```ts
function provideAngularQuery(queryClient): EnvironmentProviders
```

Sets up providers necessary to enable TanStack Query functionality for Angular applications.

Allows to configure a `QueryClient`.

**Example - standalone**

```ts
import {
  provideAngularQuery,
  QueryClient,
} from '@tanstack/angular-query-experimental'

bootstrapApplication(AppComponent, {
  providers: [provideAngularQuery(new QueryClient())],
})
```

**Example - NgModule-based**

```ts
import {
  provideAngularQuery,
  QueryClient,
} from '@tanstack/angular-query-experimental'

@NgModule({
  declarations: [AppComponent],
  imports: [BrowserModule],
  providers: [provideAngularQuery(new QueryClient())],
  bootstrap: [AppComponent],
})
export class AppModule {}
```

## Parameters

• **queryClient**: `QueryClient`

A `QueryClient` instance.

## Returns

`EnvironmentProviders`

A set of providers to set up TanStack Query.

## See

https://tanstack.com/query/v5/docs/framework/angular/quick-start

## Defined in

[providers.ts:50](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/providers.ts#L50)



# ./framework/angular/reference/functions/providequeryclient.md

---
id: provideQueryClient
title: provideQueryClient
---

# Function: provideQueryClient()

```ts
function provideQueryClient(value): Provider
```

Usually [provideAngularQuery](provideangularquery.md) is used once to set up TanStack Query and the
[https://tanstack.com/query/latest/docs/reference/QueryClient|QueryClient](https://tanstack.com/query/latest/docs/reference/QueryClient|QueryClient)
for the entire application. You can use `provideQueryClient` to provide a
different `QueryClient` instance for a part of the application.

## Parameters

• **value**: `QueryClient` \| () => `QueryClient`

## Returns

`Provider`

## Defined in

[inject-query-client.ts:25](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-query-client.ts#L25)



# ./framework/angular/reference/functions/injectquery.md

---
id: injectQuery
title: injectQuery
---

# Function: injectQuery()

Injects a query: a declarative dependency on an asynchronous source of data that is tied to a unique key.

**Basic example**

```ts
class ServiceOrComponent {
  query = injectQuery(() => ({
    queryKey: ['repoData'],
    queryFn: () =>
      this.#http.get<Response>('https://api.github.com/repos/tanstack/query'),
  }))
}
```

Similar to `computed` from Angular, the function passed to `injectQuery` will be run in the reactive context.
In the example below, the query will be automatically enabled and executed when the filter signal changes
to a truthy value. When the filter signal changes back to a falsy value, the query will be disabled.

**Reactive example**

```ts
class ServiceOrComponent {
  filter = signal('')

  todosQuery = injectQuery(() => ({
    queryKey: ['todos', this.filter()],
    queryFn: () => fetchTodos(this.filter()),
    // Signals can be combined with expressions
    enabled: !!this.filter(),
  }))
}
```

## Param

A function that returns query options.

## Param

The Angular injector to use.

## See

https://tanstack.com/query/latest/docs/framework/angular/guides/queries

## injectQuery(optionsFn, injector)

```ts
function injectQuery<TQueryFnData, TError, TData, TQueryKey>(
  optionsFn,
  injector?,
): DefinedCreateQueryResult<TData, TError>
```

Injects a query: a declarative dependency on an asynchronous source of data that is tied to a unique key.

**Basic example**

```ts
class ServiceOrComponent {
  query = injectQuery(() => ({
    queryKey: ['repoData'],
    queryFn: () =>
      this.#http.get<Response>('https://api.github.com/repos/tanstack/query'),
  }))
}
```

Similar to `computed` from Angular, the function passed to `injectQuery` will be run in the reactive context.
In the example below, the query will be automatically enabled and executed when the filter signal changes
to a truthy value. When the filter signal changes back to a falsy value, the query will be disabled.

**Reactive example**

```ts
class ServiceOrComponent {
  filter = signal('')

  todosQuery = injectQuery(() => ({
    queryKey: ['todos', this.filter()],
    queryFn: () => fetchTodos(this.filter()),
    // Signals can be combined with expressions
    enabled: !!this.filter(),
  }))
}
```

### Type Parameters

• **TQueryFnData** = `unknown`

• **TError** = `Error`

• **TData** = `TQueryFnData`

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

### Parameters

• **optionsFn**

A function that returns query options.

• **injector?**: `Injector`

The Angular injector to use.

### Returns

[`DefinedCreateQueryResult`](../type-aliases/definedcreatequeryresult.md)\<`TData`, `TError`\>

The query result.

The query result.

### Param

A function that returns query options.

### Param

The Angular injector to use.

### See

https://tanstack.com/query/latest/docs/framework/angular/guides/queries

### See

https://tanstack.com/query/latest/docs/framework/angular/guides/queries

### Defined in

[inject-query.ts:53](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-query.ts#L53)

## injectQuery(optionsFn, injector)

```ts
function injectQuery<TQueryFnData, TError, TData, TQueryKey>(
  optionsFn,
  injector?,
): CreateQueryResult<TData, TError>
```

Injects a query: a declarative dependency on an asynchronous source of data that is tied to a unique key.

**Basic example**

```ts
class ServiceOrComponent {
  query = injectQuery(() => ({
    queryKey: ['repoData'],
    queryFn: () =>
      this.#http.get<Response>('https://api.github.com/repos/tanstack/query'),
  }))
}
```

Similar to `computed` from Angular, the function passed to `injectQuery` will be run in the reactive context.
In the example below, the query will be automatically enabled and executed when the filter signal changes
to a truthy value. When the filter signal changes back to a falsy value, the query will be disabled.

**Reactive example**

```ts
class ServiceOrComponent {
  filter = signal('')

  todosQuery = injectQuery(() => ({
    queryKey: ['todos', this.filter()],
    queryFn: () => fetchTodos(this.filter()),
    // Signals can be combined with expressions
    enabled: !!this.filter(),
  }))
}
```

### Type Parameters

• **TQueryFnData** = `unknown`

• **TError** = `Error`

• **TData** = `TQueryFnData`

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

### Parameters

• **optionsFn**

A function that returns query options.

• **injector?**: `Injector`

The Angular injector to use.

### Returns

[`CreateQueryResult`](../type-aliases/createqueryresult.md)\<`TData`, `TError`\>

The query result.

The query result.

### Param

A function that returns query options.

### Param

The Angular injector to use.

### See

https://tanstack.com/query/latest/docs/framework/angular/guides/queries

### See

https://tanstack.com/query/latest/docs/framework/angular/guides/queries

### Defined in

[inject-query.ts:102](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-query.ts#L102)

## injectQuery(optionsFn, injector)

```ts
function injectQuery<TQueryFnData, TError, TData, TQueryKey>(
  optionsFn,
  injector?,
): CreateQueryResult<TData, TError>
```

Injects a query: a declarative dependency on an asynchronous source of data that is tied to a unique key.

**Basic example**

```ts
class ServiceOrComponent {
  query = injectQuery(() => ({
    queryKey: ['repoData'],
    queryFn: () =>
      this.#http.get<Response>('https://api.github.com/repos/tanstack/query'),
  }))
}
```

Similar to `computed` from Angular, the function passed to `injectQuery` will be run in the reactive context.
In the example below, the query will be automatically enabled and executed when the filter signal changes
to a truthy value. When the filter signal changes back to a falsy value, the query will be disabled.

**Reactive example**

```ts
class ServiceOrComponent {
  filter = signal('')

  todosQuery = injectQuery(() => ({
    queryKey: ['todos', this.filter()],
    queryFn: () => fetchTodos(this.filter()),
    // Signals can be combined with expressions
    enabled: !!this.filter(),
  }))
}
```

### Type Parameters

• **TQueryFnData** = `unknown`

• **TError** = `Error`

• **TData** = `TQueryFnData`

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

### Parameters

• **optionsFn**

A function that returns query options.

• **injector?**: `Injector`

The Angular injector to use.

### Returns

[`CreateQueryResult`](../type-aliases/createqueryresult.md)\<`TData`, `TError`\>

The query result.

The query result.

### Param

A function that returns query options.

### Param

The Angular injector to use.

### See

https://tanstack.com/query/latest/docs/framework/angular/guides/queries

### See

https://tanstack.com/query/latest/docs/framework/angular/guides/queries

### Defined in

[inject-query.ts:151](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-query.ts#L151)



# ./framework/angular/reference/functions/injectisfetching.md

---
id: injectIsFetching
title: injectIsFetching
---

# Function: injectIsFetching()

```ts
function injectIsFetching(filters?, injector?): Signal<number>
```

Injects a signal that tracks the number of queries that your application is loading or
fetching in the background.

Can be used for app-wide loading indicators

## Parameters

• **filters?**: `QueryFilters`

The filters to apply to the query.

• **injector?**: `Injector`

The Angular injector to use.

## Returns

`Signal`\<`number`\>

signal with number of loading or fetching queries.

## Defined in

[inject-is-fetching.ts:17](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-is-fetching.ts#L17)



# ./framework/angular/reference/functions/queryoptions.md

---
id: queryOptions
title: queryOptions
---

# Function: queryOptions()

Allows to share and re-use query options in a type-safe way.

The `queryKey` will be tagged with the type from `queryFn`.

**Example**

```ts
const { queryKey } = queryOptions({
  queryKey: ['key'],
  queryFn: () => Promise.resolve(5),
  //  ^?  Promise<number>
})

const queryClient = new QueryClient()
const data = queryClient.getQueryData(queryKey)
//    ^?  number | undefined
```

## Param

The query options to tag with the type from `queryFn`.

## queryOptions(options)

```ts
function queryOptions<TQueryFnData, TError, TData, TQueryKey>(
  options,
): UndefinedInitialDataOptions<TQueryFnData, TError, TData, TQueryKey> & object
```

Allows to share and re-use query options in a type-safe way.

The `queryKey` will be tagged with the type from `queryFn`.

**Example**

```ts
const { queryKey } = queryOptions({
  queryKey: ['key'],
  queryFn: () => Promise.resolve(5),
  //  ^?  Promise<number>
})

const queryClient = new QueryClient()
const data = queryClient.getQueryData(queryKey)
//    ^?  number | undefined
```

### Type Parameters

• **TQueryFnData** = `unknown`

• **TError** = `Error`

• **TData** = `TQueryFnData`

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

### Parameters

• **options**: [`UndefinedInitialDataOptions`](../type-aliases/undefinedinitialdataoptions.md)\<`TQueryFnData`, `TError`, `TData`, `TQueryKey`\>

The query options to tag with the type from `queryFn`.

### Returns

[`UndefinedInitialDataOptions`](../type-aliases/undefinedinitialdataoptions.md)\<`TQueryFnData`, `TError`, `TData`, `TQueryKey`\> & `object`

The tagged query options.

The tagged query options.

### Param

The query options to tag with the type from `queryFn`.

### Defined in

[query-options.ts:52](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/query-options.ts#L52)

## queryOptions(options)

```ts
function queryOptions<TQueryFnData, TError, TData, TQueryKey>(
  options,
): DefinedInitialDataOptions<TQueryFnData, TError, TData, TQueryKey> & object
```

Allows to share and re-use query options in a type-safe way.

The `queryKey` will be tagged with the type from `queryFn`.

**Example**

```ts
const { queryKey } = queryOptions({
  queryKey: ['key'],
  queryFn: () => Promise.resolve(5),
  //  ^?  Promise<number>
})

const queryClient = new QueryClient()
const data = queryClient.getQueryData(queryKey)
//    ^?  number | undefined
```

### Type Parameters

• **TQueryFnData** = `unknown`

• **TError** = `Error`

• **TData** = `TQueryFnData`

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

### Parameters

• **options**: [`DefinedInitialDataOptions`](../type-aliases/definedinitialdataoptions.md)\<`TQueryFnData`, `TError`, `TData`, `TQueryKey`\>

The query options to tag with the type from `queryFn`.

### Returns

[`DefinedInitialDataOptions`](../type-aliases/definedinitialdataoptions.md)\<`TQueryFnData`, `TError`, `TData`, `TQueryKey`\> & `object`

The tagged query options.

The tagged query options.

### Param

The query options to tag with the type from `queryFn`.

### Defined in

[query-options.ts:85](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/query-options.ts#L85)



# ./framework/angular/reference/functions/injectqueryclient.md

---
id: injectQueryClient
title: injectQueryClient
---

# Function: injectQueryClient()

Injects the `QueryClient` instance into the component or service.

**Example**

```ts
const queryClient = injectQueryClient()
```

## injectQueryClient()

```ts
function injectQueryClient(): QueryClient
```

Injects the `QueryClient` instance into the component or service.

**Example**

```ts
const queryClient = injectQueryClient()
```

### Returns

`QueryClient`

### Defined in

[inject-query-client.ts:16](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-query-client.ts#L16)

## injectQueryClient(injectOptions)

```ts
function injectQueryClient(injectOptions): QueryClient
```

Injects the `QueryClient` instance into the component or service.

**Example**

```ts
const queryClient = injectQueryClient()
```

### Parameters

• **injectOptions**: `InjectOptions` & `object` & `object`

### Returns

`QueryClient`

### Defined in

[inject-query-client.ts:16](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-query-client.ts#L16)

## injectQueryClient(injectOptions)

```ts
function injectQueryClient(injectOptions): null | QueryClient
```

Injects the `QueryClient` instance into the component or service.

**Example**

```ts
const queryClient = injectQueryClient()
```

### Parameters

• **injectOptions**: `InjectOptions` & `object`

### Returns

`null` \| `QueryClient`

### Defined in

[inject-query-client.ts:16](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-query-client.ts#L16)



# ./framework/angular/reference/functions/infinitequeryoptions.md

---
id: infiniteQueryOptions
title: infiniteQueryOptions
---

# Function: infiniteQueryOptions()

Allows to share and re-use infinite query options in a type-safe way.

The `queryKey` will be tagged with the type from `queryFn`.

## Param

The infinite query options to tag with the type from `queryFn`.

## infiniteQueryOptions(options)

```ts
function infiniteQueryOptions<
  TQueryFnData,
  TError,
  TData,
  TQueryKey,
  TPageParam,
>(
  options,
): UndefinedInitialDataInfiniteOptions<
  TQueryFnData,
  TError,
  TData,
  TQueryKey,
  TPageParam
> &
  object
```

Allows to share and re-use infinite query options in a type-safe way.

The `queryKey` will be tagged with the type from `queryFn`.

### Type Parameters

• **TQueryFnData**

• **TError** = `Error`

• **TData** = `InfiniteData`\<`TQueryFnData`, `unknown`\>

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

• **TPageParam** = `unknown`

### Parameters

• **options**: [`UndefinedInitialDataInfiniteOptions`](../type-aliases/undefinedinitialdatainfiniteoptions.md)\<`TQueryFnData`, `TError`, `TData`, `TQueryKey`, `TPageParam`\>

The infinite query options to tag with the type from `queryFn`.

### Returns

[`UndefinedInitialDataInfiniteOptions`](../type-aliases/undefinedinitialdatainfiniteoptions.md)\<`TQueryFnData`, `TError`, `TData`, `TQueryKey`, `TPageParam`\> & `object`

The tagged infinite query options.

The tagged infinite query options.

### Param

The infinite query options to tag with the type from `queryFn`.

### Defined in

[infinite-query-options.ts:59](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/infinite-query-options.ts#L59)

## infiniteQueryOptions(options)

```ts
function infiniteQueryOptions<
  TQueryFnData,
  TError,
  TData,
  TQueryKey,
  TPageParam,
>(
  options,
): DefinedInitialDataInfiniteOptions<
  TQueryFnData,
  TError,
  TData,
  TQueryKey,
  TPageParam
> &
  object
```

Allows to share and re-use infinite query options in a type-safe way.

The `queryKey` will be tagged with the type from `queryFn`.

### Type Parameters

• **TQueryFnData**

• **TError** = `Error`

• **TData** = `InfiniteData`\<`TQueryFnData`, `unknown`\>

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

• **TPageParam** = `unknown`

### Parameters

• **options**: [`DefinedInitialDataInfiniteOptions`](../type-aliases/definedinitialdatainfiniteoptions.md)\<`TQueryFnData`, `TError`, `TData`, `TQueryKey`, `TPageParam`\>

The infinite query options to tag with the type from `queryFn`.

### Returns

[`DefinedInitialDataInfiniteOptions`](../type-aliases/definedinitialdatainfiniteoptions.md)\<`TQueryFnData`, `TError`, `TData`, `TQueryKey`, `TPageParam`\> & `object`

The tagged infinite query options.

The tagged infinite query options.

### Param

The infinite query options to tag with the type from `queryFn`.

### Defined in

[infinite-query-options.ts:91](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/infinite-query-options.ts#L91)



# ./framework/angular/reference/interfaces/createinfinitequeryoptions.md

---
id: CreateInfiniteQueryOptions
title: CreateInfiniteQueryOptions
---

# Interface: CreateInfiniteQueryOptions\<TQueryFnData, TError, TData, TQueryData, TQueryKey, TPageParam\>

## Extends

- `OmitKeyof`\<`InfiniteQueryObserverOptions`\<`TQueryFnData`, `TError`, `TData`, `TQueryData`, `TQueryKey`, `TPageParam`\>, `"suspense"`\>

## Type Parameters

• **TQueryFnData** = `unknown`

• **TError** = `DefaultError`

• **TData** = `TQueryFnData`

• **TQueryData** = `TQueryFnData`

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`

• **TPageParam** = `unknown`



# ./framework/angular/reference/interfaces/injectmutationstateoptions.md

---
id: InjectMutationStateOptions
title: InjectMutationStateOptions
---

# Interface: InjectMutationStateOptions

## Properties

### injector?

```ts
optional injector: Injector;
```

#### Defined in

[inject-mutation-state.ts:43](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/inject-mutation-state.ts#L43)



# ./framework/angular/reference/interfaces/createmutationoptions.md

---
id: CreateMutationOptions
title: CreateMutationOptions
---

# Interface: CreateMutationOptions\<TData, TError, TVariables, TContext\>

## Extends

- `OmitKeyof`\<`MutationObserverOptions`\<`TData`, `TError`, `TVariables`, `TContext`\>, `"_defaulted"`\>

## Type Parameters

• **TData** = `unknown`

• **TError** = `DefaultError`

• **TVariables** = `void`

• **TContext** = `unknown`



# ./framework/angular/reference/interfaces/basequerynarrowing.md

---
id: BaseQueryNarrowing
title: BaseQueryNarrowing
---

# Interface: BaseQueryNarrowing\<TData, TError\>

## Type Parameters

• **TData** = `unknown`

• **TError** = `DefaultError`

## Properties

### isError()

```ts
isError: (this) => this is CreateBaseQueryResult<TData, TError, CreateStatusBasedQueryResult<"error", TData, TError>>;
```

#### Parameters

• **this**: [`CreateBaseQueryResult`](../type-aliases/createbasequeryresult.md)\<`TData`, `TError`, `QueryObserverResult`\<`TData`, `TError`\>\>

#### Returns

`this is CreateBaseQueryResult<TData, TError, CreateStatusBasedQueryResult<"error", TData, TError>>`

#### Defined in

[types.ts:75](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L75)

---

### isPending()

```ts
isPending: (this) => this is CreateBaseQueryResult<TData, TError, CreateStatusBasedQueryResult<"pending", TData, TError>>;
```

#### Parameters

• **this**: [`CreateBaseQueryResult`](../type-aliases/createbasequeryresult.md)\<`TData`, `TError`, `QueryObserverResult`\<`TData`, `TError`\>\>

#### Returns

`this is CreateBaseQueryResult<TData, TError, CreateStatusBasedQueryResult<"pending", TData, TError>>`

#### Defined in

[types.ts:82](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L82)

---

### isSuccess()

```ts
isSuccess: (this) => this is CreateBaseQueryResult<TData, TError, QueryObserverSuccessResult<TData, TError>>;
```

#### Parameters

• **this**: [`CreateBaseQueryResult`](../type-aliases/createbasequeryresult.md)\<`TData`, `TError`, `QueryObserverResult`\<`TData`, `TError`\>\>

#### Returns

`this is CreateBaseQueryResult<TData, TError, QueryObserverSuccessResult<TData, TError>>`

#### Defined in

[types.ts:68](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L68)



# ./framework/angular/reference/interfaces/basemutationnarrowing.md

---
id: BaseMutationNarrowing
title: BaseMutationNarrowing
---

# Interface: BaseMutationNarrowing\<TData, TError, TVariables, TContext\>

## Type Parameters

• **TData** = `unknown`

• **TError** = `DefaultError`

• **TVariables** = `unknown`

• **TContext** = `unknown`

## Properties

### isError()

```ts
isError: (this) => this is CreateMutationResult<TData, TError, TVariables, TContext, Override<MutationObserverErrorResult<TData, TError, TVariables, TContext>, Object> & Object>;
```

#### Parameters

• **this**: [`CreateMutationResult`](../type-aliases/createmutationresult.md)\<`TData`, `TError`, `TVariables`, `TContext`, `CreateStatusBasedMutationResult`\<`"error"` \| `"success"` \| `"pending"` \| `"idle"`, `TData`, `TError`, `TVariables`, `TContext`\>\>

#### Returns

`this is CreateMutationResult<TData, TError, TVariables, TContext, Override<MutationObserverErrorResult<TData, TError, TVariables, TContext>, Object> & Object>`

#### Defined in

[types.ts:248](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L248)

---

### isIdle()

```ts
isIdle: (this) => this is CreateMutationResult<TData, TError, TVariables, TContext, Override<MutationObserverIdleResult<TData, TError, TVariables, TContext>, Object> & Object>;
```

#### Parameters

• **this**: [`CreateMutationResult`](../type-aliases/createmutationresult.md)\<`TData`, `TError`, `TVariables`, `TContext`, `CreateStatusBasedMutationResult`\<`"error"` \| `"success"` \| `"pending"` \| `"idle"`, `TData`, `TError`, `TVariables`, `TContext`\>\>

#### Returns

`this is CreateMutationResult<TData, TError, TVariables, TContext, Override<MutationObserverIdleResult<TData, TError, TVariables, TContext>, Object> & Object>`

#### Defined in

[types.ts:278](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L278)

---

### isPending()

```ts
isPending: (this) => this is CreateMutationResult<TData, TError, TVariables, TContext, Override<MutationObserverLoadingResult<TData, TError, TVariables, TContext>, Object> & Object>;
```

#### Parameters

• **this**: [`CreateMutationResult`](../type-aliases/createmutationresult.md)\<`TData`, `TError`, `TVariables`, `TContext`, `CreateStatusBasedMutationResult`\<`"error"` \| `"success"` \| `"pending"` \| `"idle"`, `TData`, `TError`, `TVariables`, `TContext`\>\>

#### Returns

`this is CreateMutationResult<TData, TError, TVariables, TContext, Override<MutationObserverLoadingResult<TData, TError, TVariables, TContext>, Object> & Object>`

#### Defined in

[types.ts:263](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L263)

---

### isSuccess()

```ts
isSuccess: (this) => this is CreateMutationResult<TData, TError, TVariables, TContext, Override<MutationObserverSuccessResult<TData, TError, TVariables, TContext>, Object> & Object>;
```

#### Parameters

• **this**: [`CreateMutationResult`](../type-aliases/createmutationresult.md)\<`TData`, `TError`, `TVariables`, `TContext`, `CreateStatusBasedMutationResult`\<`"error"` \| `"success"` \| `"pending"` \| `"idle"`, `TData`, `TError`, `TVariables`, `TContext`\>\>

#### Returns

`this is CreateMutationResult<TData, TError, TVariables, TContext, Override<MutationObserverSuccessResult<TData, TError, TVariables, TContext>, Object> & Object>`

#### Defined in

[types.ts:233](https://github.com/TanStack/query/blob/dac5da5416b82b0be38a8fb34dde1fc6670f0a59/packages/angular-query-experimental/src/types.ts#L233)



# ./framework/angular/reference/interfaces/createbasequeryoptions.md

---
id: CreateBaseQueryOptions
title: CreateBaseQueryOptions
---

# Interface: CreateBaseQueryOptions\<TQueryFnData, TError, TData, TQueryData, TQueryKey\>

## Extends

- `QueryObserverOptions`\<`TQueryFnData`, `TError`, `TData`, `TQueryData`, `TQueryKey`\>

## Type Parameters

• **TQueryFnData** = `unknown`

• **TError** = `DefaultError`

• **TData** = `TQueryFnData`

• **TQueryData** = `TQueryFnData`

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`



# ./framework/angular/reference/interfaces/createqueryoptions.md

---
id: CreateQueryOptions
title: CreateQueryOptions
---

# Interface: CreateQueryOptions\<TQueryFnData, TError, TData, TQueryKey\>

## Extends

- `OmitKeyof`\<[`CreateBaseQueryOptions`](createbasequeryoptions.md)\<`TQueryFnData`, `TError`, `TData`, `TQueryFnData`, `TQueryKey`\>, `"suspense"`\>

## Type Parameters

• **TQueryFnData** = `unknown`

• **TError** = `DefaultError`

• **TData** = `TQueryFnData`

• **TQueryKey** _extends_ `QueryKey` = `QueryKey`



# ./framework/angular/zoneless.md

---
id: zoneless
title: Zoneless Angular
---

Because the Angular adapter for TanStack Query is built on signals, it fully supports Zoneless!

Among Zoneless benefits are improved performance and debugging experience. For details see the [Angular documentation](https://angular.dev/guide/experimental/zoneless).

> Keep in mind that the API for Angular Zoneless is currently experimental and can change in Angular patch versions.
> Besides Zoneless, ZoneJS change detection is also fully supported.
