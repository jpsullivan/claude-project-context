# ./README.md

![TanStack Query Header](https://github.com/TanStack/query/raw/main/media/repo-header.png)

[![npm version](https://img.shields.io/npm/v/@tanstack/angular-query-experimental)](https://www.npmjs.com/package/@tanstack/angular-query-experimental)
[![npm license](https://img.shields.io/npm/l/@tanstack/angular-query-experimental)](https://github.com/TanStack/query/blob/main/LICENSE)
[![bundle size](https://img.shields.io/bundlephobia/minzip/@tanstack/angular-query-experimental)](https://bundlephobia.com/package/@tanstack/angular-query-experimental)
[![npm](https://img.shields.io/npm/dm/@tanstack/angular-query-experimental)](https://www.npmjs.com/package/@tanstack/angular-query-experimental)

# Angular Query

> IMPORTANT: This library is currently in an experimental stage. This means that breaking changes may happen in minor AND patch releases. Upgrade carefully. If you use this in production while in experimental stage, please lock your version to a patch-level version to avoid unexpected breaking changes.

Functions for fetching, caching and updating asynchronous data in Angular

# Documentation

Visit https://tanstack.com/query/latest/docs/framework/angular/overview

## Quick Features

- Transport/protocol/backend agnostic data fetching (REST, GraphQL, promises, whatever!)
- Auto Caching + Refetching (stale-while-revalidate, Window Refocus, Polling/Realtime)
- Parallel + Dependent Queries
- Mutations + Reactive Query Refetching
- Multi-layer Cache + Automatic Garbage Collection
- Paginated + Cursor-based Queries
- Load-More + Infinite Scroll Queries w/ Scroll Recovery
- Request Cancellation
- Dedicated Devtools

# Quick Start

> The Angular adapter for TanStack Query requires Angular 16 or higher.

1. Install `angular-query`

```bash
$ npm i @tanstack/angular-query-experimental
```

or

```bash
$ pnpm add @tanstack/angular-query-experimental
```

or

```bash
$ yarn add @tanstack/angular-query-experimental
```

or

```bash
$ bun add @tanstack/angular-query-experimental
```

2. Initialize **TanStack Query** by adding **provideTanStackQuery** to your application

```ts
import { provideTanStackQuery } from '@tanstack/angular-query-experimental'
import { QueryClient } from '@tanstack/angular-query-experimental'

bootstrapApplication(AppComponent, {
  providers: [provideTanStackQuery(new QueryClient())],
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
```

3. Inject query

```ts
import { injectQuery } from '@tanstack/angular-query-experimental'
import { Component } from '@angular/core'

@Component({...})
export class TodosComponent {
  info = injectQuery(() => ({ queryKey: ['todos'], queryFn: fetchTodoList }))
}
```

4. If you need to update options on your query dynamically, make sure to pass them as signals. The query will refetch automatically if data for an updated query key is stale or not present.

[Open in StackBlitz](https://stackblitz.com/github/TanStack/query/tree/main/examples/angular/router)

```ts
@Component({})
export class PostComponent {
  #postsService = inject(PostsService)
  postId = input.required({
    transform: numberAttribute,
  })

  postQuery = injectQuery(() => ({
    queryKey: ['post', this.postId()],
    queryFn: () => {
      return lastValueFrom(this.#postsService.postById$(this.postId()))
    },
  }))
}

@Injectable({
  providedIn: 'root',
})
export class PostsService {
  #http = inject(HttpClient)

  postById$ = (postId: number) =>
    this.#http.get<Post>(`https://jsonplaceholder.typicode.com/posts/${postId}`)
}

export interface Post {
  id: number
  title: string
  body: string
}
```



# ./package.json

{
  "name": "@tanstack/angular-query-experimental",
  "version": "5.67.1",
  "description": "Signals for managing, caching and syncing asynchronous and remote data in Angular",
  "author": "Arnoud de Vries",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "git+https://github.com/TanStack/query.git",
    "directory": "packages/angular-query-experimental"
  },
  "homepage": "https://tanstack.com/query",
  "funding": {
    "type": "github",
    "url": "https://github.com/sponsors/tannerlinsley"
  },
  "keywords": [
    "angular query",
    "angular",
    "cache",
    "performance",
    "reactive",
    "rxjs",
    "signals",
    "state management",
    "state",
    "tanstack"
  ],
  "scripts": {
    "clean": "premove ./build ./coverage ./dist-ts",
    "compile": "tsc --build",
    "test:eslint": "eslint ./src",
    "test:types": "npm-run-all --serial test:types:*",
    "test:types:ts50": "node ../../node_modules/typescript50/lib/tsc.js --build",
    "test:types:ts51": "node ../../node_modules/typescript51/lib/tsc.js --build",
    "test:types:ts52": "node ../../node_modules/typescript52/lib/tsc.js --build",
    "test:types:ts53": "node ../../node_modules/typescript53/lib/tsc.js --build",
    "test:types:ts54": "node ../../node_modules/typescript54/lib/tsc.js --build",
    "test:types:ts55": "node ../../node_modules/typescript55/lib/tsc.js --build",
    "test:types:ts56": "node ../../node_modules/typescript56/lib/tsc.js  --build",
    "test:types:ts57": "node ../../node_modules/typescript57/lib/tsc.js  --build",
    "test:types:tscurrent": "tsc --build",
    "test:lib": "vitest",
    "test:lib:dev": "pnpm run test:lib --watch",
    "test:build": "publint --strict && attw --pack",
    "build": "pnpm build:tsup",
    "build:tsup": "tsup --tsconfig tsconfig.prod.json"
  },
  "type": "module",
  "types": "build/index.d.ts",
  "module": "build/index.mjs",
  "exports": {
    ".": {
      "types": "./build/index.d.ts",
      "default": "./build/index.mjs"
    },
    "./package.json": {
      "default": "./package.json"
    }
  },
  "sideEffects": false,
  "files": [
    "build",
    "src",
    "!src/__tests__"
  ],
  "dependencies": {
    "@tanstack/query-core": "workspace:*",
    "@tanstack/query-devtools": "workspace:*"
  },
  "devDependencies": {
    "@angular/compiler": "^19.1.0-next.0",
    "@angular/core": "^19.1.0-next.0",
    "@angular/platform-browser": "^19.1.0-next.0",
    "@angular/platform-browser-dynamic": "^19.1.0-next.0",
    "@microsoft/api-extractor": "^7.48.1",
    "eslint-plugin-jsdoc": "^50.5.0",
    "npm-run-all": "^4.1.5",
    "tsup": "8.0.2",
    "typescript": "5.8.2"
  },
  "peerDependencies": {
    "@angular/common": ">=16.0.0",
    "@angular/core": ">=16.0.0"
  }
}



# ./src/inject-query.ts

import { QueryObserver } from '@tanstack/query-core'
import { assertInjector } from './util/assert-injector/assert-injector'
import { createBaseQuery } from './create-base-query'
import type { Injector } from '@angular/core'
import type { DefaultError, QueryKey } from '@tanstack/query-core'
import type {
  CreateQueryOptions,
  CreateQueryResult,
  DefinedCreateQueryResult,
} from './types'
import type {
  DefinedInitialDataOptions,
  UndefinedInitialDataOptions,
} from './query-options'

/**
 * Injects a query: a declarative dependency on an asynchronous source of data that is tied to a unique key.
 *
 * **Basic example**
 * ```ts
 * class ServiceOrComponent {
 *   query = injectQuery(() => ({
 *     queryKey: ['repoData'],
 *     queryFn: () =>
 *       this.#http.get<Response>('https://api.github.com/repos/tanstack/query'),
 *   }))
 * }
 * ```
 *
 * Similar to `computed` from Angular, the function passed to `injectQuery` will be run in the reactive context.
 * In the example below, the query will be automatically enabled and executed when the filter signal changes
 * to a truthy value. When the filter signal changes back to a falsy value, the query will be disabled.
 *
 * **Reactive example**
 * ```ts
 * class ServiceOrComponent {
 *   filter = signal('')
 *
 *   todosQuery = injectQuery(() => ({
 *     queryKey: ['todos', this.filter()],
 *     queryFn: () => fetchTodos(this.filter()),
 *     // Signals can be combined with expressions
 *     enabled: !!this.filter(),
 *   }))
 * }
 * ```
 * @param optionsFn - A function that returns query options.
 * @param injector - The Angular injector to use.
 * @returns The query result.
 * @public
 * @see https://tanstack.com/query/latest/docs/framework/angular/guides/queries
 */
export function injectQuery<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
>(
  optionsFn: () => DefinedInitialDataOptions<
    TQueryFnData,
    TError,
    TData,
    TQueryKey
  >,
  injector?: Injector,
): DefinedCreateQueryResult<TData, TError>

/**
 * Injects a query: a declarative dependency on an asynchronous source of data that is tied to a unique key.
 *
 * **Basic example**
 * ```ts
 * class ServiceOrComponent {
 *   query = injectQuery(() => ({
 *     queryKey: ['repoData'],
 *     queryFn: () =>
 *       this.#http.get<Response>('https://api.github.com/repos/tanstack/query'),
 *   }))
 * }
 * ```
 *
 * Similar to `computed` from Angular, the function passed to `injectQuery` will be run in the reactive context.
 * In the example below, the query will be automatically enabled and executed when the filter signal changes
 * to a truthy value. When the filter signal changes back to a falsy value, the query will be disabled.
 *
 * **Reactive example**
 * ```ts
 * class ServiceOrComponent {
 *   filter = signal('')
 *
 *   todosQuery = injectQuery(() => ({
 *     queryKey: ['todos', this.filter()],
 *     queryFn: () => fetchTodos(this.filter()),
 *     // Signals can be combined with expressions
 *     enabled: !!this.filter(),
 *   }))
 * }
 * ```
 * @param optionsFn - A function that returns query options.
 * @param injector - The Angular injector to use.
 * @returns The query result.
 * @public
 * @see https://tanstack.com/query/latest/docs/framework/angular/guides/queries
 */
export function injectQuery<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
>(
  optionsFn: () => UndefinedInitialDataOptions<
    TQueryFnData,
    TError,
    TData,
    TQueryKey
  >,
  injector?: Injector,
): CreateQueryResult<TData, TError>

/**
 * Injects a query: a declarative dependency on an asynchronous source of data that is tied to a unique key.
 *
 * **Basic example**
 * ```ts
 * class ServiceOrComponent {
 *   query = injectQuery(() => ({
 *     queryKey: ['repoData'],
 *     queryFn: () =>
 *       this.#http.get<Response>('https://api.github.com/repos/tanstack/query'),
 *   }))
 * }
 * ```
 *
 * Similar to `computed` from Angular, the function passed to `injectQuery` will be run in the reactive context.
 * In the example below, the query will be automatically enabled and executed when the filter signal changes
 * to a truthy value. When the filter signal changes back to a falsy value, the query will be disabled.
 *
 * **Reactive example**
 * ```ts
 * class ServiceOrComponent {
 *   filter = signal('')
 *
 *   todosQuery = injectQuery(() => ({
 *     queryKey: ['todos', this.filter()],
 *     queryFn: () => fetchTodos(this.filter()),
 *     // Signals can be combined with expressions
 *     enabled: !!this.filter(),
 *   }))
 * }
 * ```
 * @param optionsFn - A function that returns query options.
 * @param injector - The Angular injector to use.
 * @returns The query result.
 * @public
 * @see https://tanstack.com/query/latest/docs/framework/angular/guides/queries
 */
export function injectQuery<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
>(
  optionsFn: () => CreateQueryOptions<TQueryFnData, TError, TData, TQueryKey>,
  injector?: Injector,
): CreateQueryResult<TData, TError>

/**
 * Injects a query: a declarative dependency on an asynchronous source of data that is tied to a unique key.
 *
 * **Basic example**
 * ```ts
 * class ServiceOrComponent {
 *   query = injectQuery(() => ({
 *     queryKey: ['repoData'],
 *     queryFn: () =>
 *       this.#http.get<Response>('https://api.github.com/repos/tanstack/query'),
 *   }))
 * }
 * ```
 *
 * Similar to `computed` from Angular, the function passed to `injectQuery` will be run in the reactive context.
 * In the example below, the query will be automatically enabled and executed when the filter signal changes
 * to a truthy value. When the filter signal changes back to a falsy value, the query will be disabled.
 *
 * **Reactive example**
 * ```ts
 * class ServiceOrComponent {
 *   filter = signal('')
 *
 *   todosQuery = injectQuery(() => ({
 *     queryKey: ['todos', this.filter()],
 *     queryFn: () => fetchTodos(this.filter()),
 *     // Signals can be combined with expressions
 *     enabled: !!this.filter(),
 *   }))
 * }
 * ```
 * @param optionsFn - A function that returns query options.
 * @param injector - The Angular injector to use.
 * @returns The query result.
 * @public
 * @see https://tanstack.com/query/latest/docs/framework/angular/guides/queries
 */
export function injectQuery(
  optionsFn: () => CreateQueryOptions,
  injector?: Injector,
) {
  return assertInjector(injectQuery, injector, () =>
    createBaseQuery(optionsFn, QueryObserver),
  ) as unknown as CreateQueryResult
}



# ./src/util/assert-injector/assert-injector.ts

/* eslint-disable cspell/spellchecker */
/**
 * The code in this file is adapted from NG Extension Platform at https://ngxtension.netlify.app.
 *
 * Original Author: Chau Tran
 *
 * NG Extension Platform is an open-source project licensed under the MIT license.
 *
 * For more information about the original code, see
 * https://github.com/nartc/ngxtension-platform
 */
/* eslint-enable */

import {
  Injector,
  assertInInjectionContext,
  inject,
  runInInjectionContext,
} from '@angular/core'

/**
 * `assertInjector` extends `assertInInjectionContext` with an optional `Injector`
 * After assertion, `assertInjector` runs the `runner` function with the guaranteed `Injector`
 * whether it is the default `Injector` within the current **Injection Context**
 * or the custom `Injector` that was passed in.
 *
 * @template {() => any} Runner - Runner is a function that can return anything
 * @param {Function} fn - the Function to pass in `assertInInjectionContext`
 * @param {Injector | undefined | null} injector - the optional "custom" Injector
 * @param {Runner} runner - the runner fn
 * @returns {ReturnType<Runner>} result - returns the result of the Runner
 *
 * @example
 * ```ts
 * function injectValue(injector?: Injector) {
 *  return assertInjector(injectValue, injector, () => 'value');
 * }
 *
 * injectValue(); // string
 * ```
 */
export function assertInjector<TRunner extends () => any>(
  fn: Function,
  injector: Injector | undefined | null,
  runner: TRunner,
): ReturnType<TRunner>
/**
 * `assertInjector` extends `assertInInjectionContext` with an optional `Injector`
 * After assertion, `assertInjector` returns a guaranteed `Injector` whether it is the default `Injector`
 * within the current **Injection Context** or the custom `Injector` that was passed in.
 *
 * @param {Function} fn - the Function to pass in `assertInInjectionContext`
 * @param {Injector | undefined | null} injector - the optional "custom" Injector
 * @returns Injector
 *
 * @example
 * ```ts
 * function injectDestroy(injector?: Injector) {
 *  injector = assertInjector(injectDestroy, injector);
 *
 *  return runInInjectionContext(injector, () => {
 *    // code
 *  })
 * }
 * ```
 */
export function assertInjector(
  fn: Function,
  injector: Injector | undefined | null,
): Injector
export function assertInjector(
  fn: Function,
  injector: Injector | undefined | null,
  runner?: () => any,
) {
  !injector && assertInInjectionContext(fn)
  const assertedInjector = injector ?? inject(Injector)

  if (!runner) return assertedInjector
  return runInInjectionContext(assertedInjector, runner)
}



# ./src/util/index.ts

export function shouldThrowError<T extends (...args: Array<any>) => boolean>(
  throwError: boolean | T | undefined,
  params: Parameters<T>,
): boolean {
  // Allow throwError function to override throwing behavior on a per-error basis
  if (typeof throwError === 'function') {
    return throwError(...params)
  }

  return !!throwError
}

export function noop(): void {}



# ./src/util/is-dev-mode/is-dev-mode.ts

// Re-export for mocking in tests

export { isDevMode } from '@angular/core'



# ./src/create-base-query.ts

import {
  DestroyRef,
  Injector,
  NgZone,
  VERSION,
  computed,
  effect,
  inject,
  runInInjectionContext,
  signal,
  untracked,
} from '@angular/core'
import { QueryClient, notifyManager } from '@tanstack/query-core'
import { signalProxy } from './signal-proxy'
import { shouldThrowError } from './util'
import type {
  QueryKey,
  QueryObserver,
  QueryObserverResult,
} from '@tanstack/query-core'
import type { CreateBaseQueryOptions } from './types'

/**
 * Base implementation for `injectQuery` and `injectInfiniteQuery`.
 */
export function createBaseQuery<
  TQueryFnData,
  TError,
  TData,
  TQueryData,
  TQueryKey extends QueryKey,
>(
  optionsFn: () => CreateBaseQueryOptions<
    TQueryFnData,
    TError,
    TData,
    TQueryData,
    TQueryKey
  >,
  Observer: typeof QueryObserver,
) {
  const injector = inject(Injector)
  const ngZone = injector.get(NgZone)
  const destroyRef = injector.get(DestroyRef)
  const queryClient = injector.get(QueryClient)

  /**
   * Signal that has the default options from query client applied
   * computed() is used so signals can be inserted into the options
   * making it reactive. Wrapping options in a function ensures embedded expressions
   * are preserved and can keep being applied after signal changes
   */
  const defaultedOptionsSignal = computed(() => {
    const options = runInInjectionContext(injector, () => optionsFn())
    const defaultedOptions = queryClient.defaultQueryOptions(options)
    defaultedOptions._optimisticResults = 'optimistic'
    return defaultedOptions
  })

  const observerSignal = (() => {
    let instance: QueryObserver<
      TQueryFnData,
      TError,
      TData,
      TQueryData,
      TQueryKey
    > | null = null

    return computed(() => {
      return (instance ||= new Observer(queryClient, defaultedOptionsSignal()))
    })
  })()

  const optimisticResultSignal = computed(() =>
    observerSignal().getOptimisticResult(defaultedOptionsSignal()),
  )

  const resultFromSubscriberSignal = signal<QueryObserverResult<
    TData,
    TError
  > | null>(null)

  effect(
    (onCleanup) => {
      const observer = observerSignal()
      const defaultedOptions = defaultedOptionsSignal()

      untracked(() => {
        observer.setOptions(defaultedOptions, {
          // Do not notify on updates because of changes in the options because
          // these changes should already be reflected in the optimistic result.
          listeners: false,
        })
      })
      onCleanup(() => {
        ngZone.run(() => resultFromSubscriberSignal.set(null))
      })
    },
    {
      // Set allowSignalWrites to support Angular < v19
      // Set to undefined to avoid warning on newer versions
      allowSignalWrites: VERSION.major < '19' || undefined,
      injector,
    },
  )

  effect(() => {
    // observer.trackResult is not used as this optimization is not needed for Angular
    const observer = observerSignal()

    untracked(() => {
      const unsubscribe = ngZone.runOutsideAngular(() =>
        observer.subscribe(
          notifyManager.batchCalls((state) => {
            ngZone.run(() => {
              if (
                state.isError &&
                !state.isFetching &&
                // !isRestoring() && // todo: enable when client persistence is implemented
                shouldThrowError(observer.options.throwOnError, [
                  state.error,
                  observer.getCurrentQuery(),
                ])
              ) {
                throw state.error
              }
              resultFromSubscriberSignal.set(state)
            })
          }),
        ),
      )
      destroyRef.onDestroy(unsubscribe)
    })
  })

  return signalProxy(
    computed(() => {
      const subscriberResult = resultFromSubscriberSignal()
      const optimisticResult = optimisticResultSignal()
      return subscriberResult ?? optimisticResult
    }),
  )
}



# ./src/inject-mutation-state.ts

import { DestroyRef, NgZone, computed, inject, signal } from '@angular/core'
import {
  QueryClient,
  notifyManager,
  replaceEqualDeep,
} from '@tanstack/query-core'
import { assertInjector } from './util/assert-injector/assert-injector'
import type { Injector, Signal } from '@angular/core'
import type {
  Mutation,
  MutationCache,
  MutationFilters,
  MutationState,
} from '@tanstack/query-core'

type MutationStateOptions<TResult = MutationState> = {
  filters?: MutationFilters
  select?: (mutation: Mutation) => TResult
}

function getResult<TResult = MutationState>(
  mutationCache: MutationCache,
  options: MutationStateOptions<TResult>,
): Array<TResult> {
  return mutationCache
    .findAll(options.filters)
    .map(
      (mutation): TResult =>
        (options.select ? options.select(mutation) : mutation.state) as TResult,
    )
}

/**
 * @public
 */
export interface InjectMutationStateOptions {
  injector?: Injector
}

/**
 * Injects a signal that tracks the state of all mutations.
 * @param mutationStateOptionsFn - A function that returns mutation state options.
 * @param options - The Angular injector to use.
 * @returns The signal that tracks the state of all mutations.
 * @public
 */
export function injectMutationState<TResult = MutationState>(
  mutationStateOptionsFn: () => MutationStateOptions<TResult> = () => ({}),
  options?: InjectMutationStateOptions,
): Signal<Array<TResult>> {
  return assertInjector(injectMutationState, options?.injector, () => {
    const destroyRef = inject(DestroyRef)
    const ngZone = inject(NgZone)
    const queryClient = inject(QueryClient)

    const mutationCache = queryClient.getMutationCache()

    /**
     * Computed signal that gets result from mutation cache based on passed options
     * First element is the result, second element is the time when the result was set
     */
    const resultFromOptionsSignal = computed(() => {
      return [
        getResult(mutationCache, mutationStateOptionsFn()),
        performance.now(),
      ] as const
    })

    /**
     * Signal that contains result set by subscriber
     * First element is the result, second element is the time when the result was set
     */
    const resultFromSubscriberSignal = signal<[Array<TResult>, number] | null>(
      null,
    )

    /**
     * Returns the last result by either subscriber or options
     */
    const effectiveResultSignal = computed(() => {
      const optionsResult = resultFromOptionsSignal()
      const subscriberResult = resultFromSubscriberSignal()
      return subscriberResult && subscriberResult[1] > optionsResult[1]
        ? subscriberResult[0]
        : optionsResult[0]
    })

    const unsubscribe = ngZone.runOutsideAngular(() =>
      mutationCache.subscribe(
        notifyManager.batchCalls(() => {
          const [lastResult] = effectiveResultSignal()
          const nextResult = replaceEqualDeep(
            lastResult,
            getResult(mutationCache, mutationStateOptionsFn()),
          )
          if (lastResult !== nextResult) {
            ngZone.run(() => {
              resultFromSubscriberSignal.set([nextResult, performance.now()])
            })
          }
        }),
      ),
    )

    destroyRef.onDestroy(unsubscribe)

    return effectiveResultSignal
  })
}



# ./src/inject-is-mutating.ts

import { DestroyRef, NgZone, inject, signal } from '@angular/core'
import { QueryClient, notifyManager } from '@tanstack/query-core'
import { assertInjector } from './util/assert-injector/assert-injector'
import type { MutationFilters } from '@tanstack/query-core'
import type { Injector, Signal } from '@angular/core'

/**
 * Injects a signal that tracks the number of mutations that your application is fetching.
 *
 * Can be used for app-wide loading indicators
 * @param filters - The filters to apply to the query.
 * @param injector - The Angular injector to use.
 * @returns signal with number of fetching mutations.
 * @public
 */
export function injectIsMutating(
  filters?: MutationFilters,
  injector?: Injector,
): Signal<number> {
  return assertInjector(injectIsMutating, injector, () => {
    const destroyRef = inject(DestroyRef)
    const ngZone = inject(NgZone)
    const queryClient = inject(QueryClient)

    const cache = queryClient.getMutationCache()
    // isMutating is the prev value initialized on mount *
    let isMutating = queryClient.isMutating(filters)

    const result = signal(isMutating)

    const unsubscribe = ngZone.runOutsideAngular(() =>
      cache.subscribe(
        notifyManager.batchCalls(() => {
          const newIsMutating = queryClient.isMutating(filters)
          if (isMutating !== newIsMutating) {
            // * and update with each change
            isMutating = newIsMutating
            ngZone.run(() => {
              result.set(isMutating)
            })
          }
        }),
      ),
    )

    destroyRef.onDestroy(unsubscribe)

    return result
  })
}



# ./src/signal-proxy.ts

import { computed, untracked } from '@angular/core'
import type { Signal } from '@angular/core'

export type MapToSignals<T> = {
  [K in keyof T]: T[K] extends Function ? T[K] : Signal<T[K]>
}

/**
 * Exposes fields of an object passed via an Angular `Signal` as `Computed` signals.
 * Functions on the object are passed through as-is.
 * @param inputSignal - `Signal` that must return an object.
 * @returns A proxy object with the same fields as the input object, but with each field wrapped in a `Computed` signal.
 */
export function signalProxy<TInput extends Record<string | symbol, any>>(
  inputSignal: Signal<TInput>,
) {
  const internalState = {} as MapToSignals<TInput>

  return new Proxy<MapToSignals<TInput>>(internalState, {
    get(target, prop) {
      // first check if we have it in our internal state and return it
      const computedField = target[prop]
      if (computedField) return computedField

      // then, check if it's a function on the resultState and return it
      const targetField = untracked(inputSignal)[prop]
      if (typeof targetField === 'function') return targetField

      // finally, create a computed field, store it and return it
      // @ts-expect-error
      return (target[prop] = computed(() => inputSignal()[prop]))
    },
    has(_, prop) {
      return !!untracked(inputSignal)[prop]
    },
    ownKeys() {
      return Reflect.ownKeys(untracked(inputSignal))
    },
    getOwnPropertyDescriptor() {
      return {
        enumerable: true,
        configurable: true,
      }
    },
  })
}



# ./src/query-options.ts

import type {
  DataTag,
  DefaultError,
  InitialDataFunction,
  QueryKey,
} from '@tanstack/query-core'
import type { CreateQueryOptions, NonUndefinedGuard } from './types'

/**
 * @public
 */
export type UndefinedInitialDataOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> = CreateQueryOptions<TQueryFnData, TError, TData, TQueryKey> & {
  initialData?: undefined | InitialDataFunction<NonUndefinedGuard<TQueryFnData>>
}

/**
 * @public
 */
export type DefinedInitialDataOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> = CreateQueryOptions<TQueryFnData, TError, TData, TQueryKey> & {
  initialData:
    | NonUndefinedGuard<TQueryFnData>
    | (() => NonUndefinedGuard<TQueryFnData>)
}

/**
 * Allows to share and re-use query options in a type-safe way.
 *
 * The `queryKey` will be tagged with the type from `queryFn`.
 *
 * **Example**
 *
 * ```ts
 *  const { queryKey } = queryOptions({
 *     queryKey: ['key'],
 *     queryFn: () => Promise.resolve(5),
 *     //  ^?  Promise<number>
 *   })
 *
 *   const queryClient = new QueryClient()
 *   const data = queryClient.getQueryData(queryKey)
 *   //    ^?  number | undefined
 * ```
 * @param options - The query options to tag with the type from `queryFn`.
 * @returns The tagged query options.
 * @public
 */
export function queryOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
>(
  options: DefinedInitialDataOptions<TQueryFnData, TError, TData, TQueryKey>,
): DefinedInitialDataOptions<TQueryFnData, TError, TData, TQueryKey> & {
  queryKey: DataTag<TQueryKey, TQueryFnData>
}

/**
 * Allows to share and re-use query options in a type-safe way.
 *
 * The `queryKey` will be tagged with the type from `queryFn`.
 *
 * **Example**
 *
 * ```ts
 *  const { queryKey } = queryOptions({
 *     queryKey: ['key'],
 *     queryFn: () => Promise.resolve(5),
 *     //  ^?  Promise<number>
 *   })
 *
 *   const queryClient = new QueryClient()
 *   const data = queryClient.getQueryData(queryKey)
 *   //    ^?  number | undefined
 * ```
 * @param options - The query options to tag with the type from `queryFn`.
 * @returns The tagged query options.
 * @public
 */
export function queryOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
>(
  options: UndefinedInitialDataOptions<TQueryFnData, TError, TData, TQueryKey>,
): UndefinedInitialDataOptions<TQueryFnData, TError, TData, TQueryKey> & {
  queryKey: DataTag<TQueryKey, TQueryFnData>
}

/**
 * Allows to share and re-use query options in a type-safe way.
 *
 * The `queryKey` will be tagged with the type from `queryFn`.
 *
 * **Example**
 *
 * ```ts
 *  const { queryKey } = queryOptions({
 *     queryKey: ['key'],
 *     queryFn: () => Promise.resolve(5),
 *     //  ^?  Promise<number>
 *   })
 *
 *   const queryClient = new QueryClient()
 *   const data = queryClient.getQueryData(queryKey)
 *   //    ^?  number | undefined
 * ```
 * @param options - The query options to tag with the type from `queryFn`.
 * @returns The tagged query options.
 * @public
 */
export function queryOptions(options: unknown) {
  return options
}



# ./src/inject-mutation.ts

import {
  DestroyRef,
  Injector,
  NgZone,
  computed,
  effect,
  inject,
  runInInjectionContext,
  signal,
  untracked,
} from '@angular/core'
import {
  MutationObserver,
  QueryClient,
  notifyManager,
} from '@tanstack/query-core'
import { assertInjector } from './util/assert-injector/assert-injector'
import { signalProxy } from './signal-proxy'
import { noop, shouldThrowError } from './util'
import type { DefaultError, MutationObserverResult } from '@tanstack/query-core'
import type { CreateMutateFunction, CreateMutationResult } from './types'
import type { CreateMutationOptions } from './mutation-options'

/**
 * Injects a mutation: an imperative function that can be invoked which typically performs server side effects.
 *
 * Unlike queries, mutations are not run automatically.
 * @param optionsFn - A function that returns mutation options.
 * @param injector - The Angular injector to use.
 * @returns The mutation.
 * @public
 */
export function injectMutation<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
>(
  optionsFn: () => CreateMutationOptions<TData, TError, TVariables, TContext>,
  injector?: Injector,
): CreateMutationResult<TData, TError, TVariables, TContext> {
  return assertInjector(injectMutation, injector, () => {
    const currentInjector = inject(Injector)
    const destroyRef = inject(DestroyRef)
    const ngZone = inject(NgZone)
    const queryClient = inject(QueryClient)

    /**
     * computed() is used so signals can be inserted into the options
     * making it reactive. Wrapping options in a function ensures embedded expressions
     * are preserved and can keep being applied after signal changes
     */
    const optionsSignal = computed(() =>
      runInInjectionContext(currentInjector, () => optionsFn()),
    )

    const observerSignal = (() => {
      let instance: MutationObserver<
        TData,
        TError,
        TVariables,
        TContext
      > | null = null

      return computed(() => {
        return (instance ||= new MutationObserver(queryClient, optionsSignal()))
      })
    })()

    const mutateFnSignal = computed<
      CreateMutateFunction<TData, TError, TVariables, TContext>
    >(() => {
      const observer = observerSignal()
      return (variables, mutateOptions) => {
        observer.mutate(variables, mutateOptions).catch(noop)
      }
    })

    /**
     * Computed signal that gets result from mutation cache based on passed options
     */
    const resultFromInitialOptionsSignal = computed(() => {
      const observer = observerSignal()
      return observer.getCurrentResult()
    })

    /**
     * Signal that contains result set by subscriber
     */
    const resultFromSubscriberSignal = signal<MutationObserverResult<
      TData,
      TError,
      TVariables,
      TContext
    > | null>(null)

    effect(
      () => {
        const observer = observerSignal()
        const options = optionsSignal()

        untracked(() => {
          observer.setOptions(options)
        })
      },
      {
        injector,
      },
    )

    effect(
      () => {
        // observer.trackResult is not used as this optimization is not needed for Angular
        const observer = observerSignal()

        untracked(() => {
          const unsubscribe = ngZone.runOutsideAngular(() =>
            observer.subscribe(
              notifyManager.batchCalls((state) => {
                ngZone.run(() => {
                  if (
                    state.isError &&
                    shouldThrowError(observer.options.throwOnError, [
                      state.error,
                    ])
                  ) {
                    throw state.error
                  }

                  resultFromSubscriberSignal.set(state)
                })
              }),
            ),
          )
          destroyRef.onDestroy(unsubscribe)
        })
      },
      {
        injector,
      },
    )

    const resultSignal = computed(() => {
      const resultFromSubscriber = resultFromSubscriberSignal()
      const resultFromInitialOptions = resultFromInitialOptionsSignal()

      const result = resultFromSubscriber ?? resultFromInitialOptions

      return {
        ...result,
        mutate: mutateFnSignal(),
        mutateAsync: result.mutate,
      }
    })

    return signalProxy(resultSignal) as CreateMutationResult<
      TData,
      TError,
      TVariables,
      TContext
    >
  })
}



# ./src/test-setup.ts

import {
  BrowserDynamicTestingModule,
  platformBrowserDynamicTesting,
} from '@angular/platform-browser-dynamic/testing'
import { getTestBed } from '@angular/core/testing'

getTestBed().initTestEnvironment(
  BrowserDynamicTestingModule,
  platformBrowserDynamicTesting(),
)



# ./src/providers.ts

import {
  DestroyRef,
  ENVIRONMENT_INITIALIZER,
  Injector,
  PLATFORM_ID,
  computed,
  effect,
  inject,
  makeEnvironmentProviders,
  runInInjectionContext,
} from '@angular/core'
import { QueryClient, onlineManager } from '@tanstack/query-core'
import { isPlatformBrowser } from '@angular/common'
import { isDevMode } from './util/is-dev-mode/is-dev-mode'
import { noop } from './util'
import type { EnvironmentProviders, Provider } from '@angular/core'
import type {
  DevtoolsButtonPosition,
  DevtoolsErrorType,
  DevtoolsPosition,
  TanstackQueryDevtools,
} from '@tanstack/query-devtools'

/**
 * Usually {@link provideTanStackQuery} is used once to set up TanStack Query and the
 * {@link https://tanstack.com/query/latest/docs/reference/QueryClient|QueryClient}
 * for the entire application. You can use `provideQueryClient` to provide a
 * different `QueryClient` instance for a part of the application.
 * @param queryClient - the `QueryClient` instance to provide.
 * @public
 */
export function provideQueryClient(queryClient: QueryClient) {
  return { provide: QueryClient, useValue: queryClient }
}

/**
 * Sets up providers necessary to enable TanStack Query functionality for Angular applications.
 *
 * Allows to configure a `QueryClient` and optional features such as developer tools.
 *
 * **Example - standalone**
 *
 * ```ts
 * import {
 *   provideTanStackQuery,
 *   QueryClient,
 * } from '@tanstack/angular-query-experimental'
 *
 * bootstrapApplication(AppComponent, {
 *   providers: [provideTanStackQuery(new QueryClient())],
 * })
 * ```
 *
 * **Example - NgModule-based**
 *
 * ```ts
 * import {
 *   provideTanStackQuery,
 *   QueryClient,
 * } from '@tanstack/angular-query-experimental'
 *
 * @NgModule({
 *   declarations: [AppComponent],
 *   imports: [BrowserModule],
 *   providers: [provideTanStackQuery(new QueryClient())],
 *   bootstrap: [AppComponent],
 * })
 * export class AppModule {}
 * ```
 *
 * You can also enable optional developer tools by adding `withDevtools`. By
 * default the tools will then be loaded when your app is in development mode.
 * ```ts
 * import {
 *   provideTanStackQuery,
 *   withDevtools
 *   QueryClient,
 * } from '@tanstack/angular-query-experimental'
 *
 * bootstrapApplication(AppComponent,
 *   {
 *     providers: [
 *       provideTanStackQuery(new QueryClient(), withDevtools())
 *     ]
 *   }
 * )
 * ```
 * @param queryClient - A `QueryClient` instance.
 * @param features - Optional features to configure additional Query functionality.
 * @returns A set of providers to set up TanStack Query.
 * @public
 * @see https://tanstack.com/query/v5/docs/framework/angular/quick-start
 * @see withDevtools
 */
export function provideTanStackQuery(
  queryClient: QueryClient,
  ...features: Array<QueryFeatures>
): EnvironmentProviders {
  return makeEnvironmentProviders([
    provideQueryClient(queryClient),
    {
      // Do not use provideEnvironmentInitializer to support Angular < v19
      provide: ENVIRONMENT_INITIALIZER,
      multi: true,
      useValue: () => {
        queryClient.mount()
        // Unmount the query client on application destroy
        inject(DestroyRef).onDestroy(() => queryClient.unmount())
      },
    },
    features.map((feature) => feature.ɵproviders),
  ])
}

/**
 * Sets up providers necessary to enable TanStack Query functionality for Angular applications.
 *
 * Allows to configure a `QueryClient`.
 * @param queryClient - A `QueryClient` instance.
 * @returns A set of providers to set up TanStack Query.
 * @public
 * @see https://tanstack.com/query/v5/docs/framework/angular/quick-start
 * @deprecated Use `provideTanStackQuery` instead.
 */
export function provideAngularQuery(
  queryClient: QueryClient,
): EnvironmentProviders {
  return provideTanStackQuery(queryClient)
}

/**
 * Helper type to represent a Query feature.
 */
export interface QueryFeature<TFeatureKind extends QueryFeatureKind> {
  ɵkind: TFeatureKind
  ɵproviders: Array<Provider>
}

/**
 * Helper function to create an object that represents a Query feature.
 * @param kind -
 * @param providers -
 * @returns A Query feature.
 */
function queryFeature<TFeatureKind extends QueryFeatureKind>(
  kind: TFeatureKind,
  providers: Array<Provider>,
): QueryFeature<TFeatureKind> {
  return { ɵkind: kind, ɵproviders: providers }
}

/**
 * A type alias that represents a feature which enables developer tools.
 * The type is used to describe the return value of the `withDevtools` function.
 * @public
 * @see {@link withDevtools}
 */
export type DeveloperToolsFeature = QueryFeature<'DeveloperTools'>

/**
 * Options for configuring the TanStack Query devtools.
 * @public
 */
export interface DevtoolsOptions {
  /**
   * Set this true if you want the devtools to default to being open
   */
  initialIsOpen?: boolean
  /**
   * The position of the TanStack logo to open and close the devtools panel.
   * `top-left` | `top-right` | `bottom-left` | `bottom-right` | `relative`
   * Defaults to `bottom-right`.
   */
  buttonPosition?: DevtoolsButtonPosition
  /**
   * The position of the TanStack Query devtools panel.
   * `top` | `bottom` | `left` | `right`
   * Defaults to `bottom`.
   */
  position?: DevtoolsPosition
  /**
   * Custom instance of QueryClient
   */
  client?: QueryClient
  /**
   * Use this so you can define custom errors that can be shown in the devtools.
   */
  errorTypes?: Array<DevtoolsErrorType>
  /**
   * Use this to pass a nonce to the style tag that is added to the document head. This is useful if you are using a Content Security Policy (CSP) nonce to allow inline styles.
   */
  styleNonce?: string
  /**
   * Use this so you can attach the devtool's styles to a specific element in the DOM.
   */
  shadowDOMTarget?: ShadowRoot

  /**
   * Whether the developer tools should load.
   * - `auto`- (Default) Lazily loads devtools when in development mode. Skips loading in production mode.
   * - `true`- Always load the devtools, regardless of the environment.
   * - `false`- Never load the devtools, regardless of the environment.
   *
   * You can use `true` and `false` to override loading developer tools from an environment file.
   * For example, a test environment might run in production mode but you may want to load developer tools.
   *
   * Additionally, you can use a signal in the callback to dynamically load the devtools based on a condition. For example,
   * a signal created from a RxJS observable that listens for a keyboard shortcut.
   *
   * **Example**
   * ```ts
   *    withDevtools(() => ({
   *      initialIsOpen: true,
   *      loadDevtools: inject(ExampleService).loadDevtools()
   *    }))
   *  ```
   */
  loadDevtools?: 'auto' | boolean
}

/**
 * Enables developer tools.
 *
 * **Example**
 *
 * ```ts
 * export const appConfig: ApplicationConfig = {
 *   providers: [
 *     provideTanStackQuery(new QueryClient(), withDevtools())
 *   ]
 * }
 * ```
 * By default the devtools will be loaded when Angular runs in development mode and rendered in `<body>`.
 *
 * If you need more control over when devtools are loaded, you can use the `loadDevtools` option. This is particularly useful if you want to load devtools based on environment configurations. For instance, you might have a test environment running in production mode but still require devtools to be available.
 *
 * If you need more control over where devtools are rendered, consider `injectDevtoolsPanel`. This allows rendering devtools inside your own devtools for example.
 * @param optionsFn - A function that returns `DevtoolsOptions`.
 * @returns A set of providers for use with `provideTanStackQuery`.
 * @public
 * @see {@link provideTanStackQuery}
 * @see {@link DevtoolsOptions}
 */
export function withDevtools(
  optionsFn?: () => DevtoolsOptions,
): DeveloperToolsFeature {
  let providers: Array<Provider> = []
  if (!isDevMode() && !optionsFn) {
    providers = []
  } else {
    providers = [
      {
        provide: ENVIRONMENT_INITIALIZER,
        multi: true,
        useFactory: () => {
          if (!isPlatformBrowser(inject(PLATFORM_ID))) return noop
          const injector = inject(Injector)
          const options = computed(() =>
            runInInjectionContext(injector, () => optionsFn?.() ?? {}),
          )

          let devtools: TanstackQueryDevtools | null = null
          let el: HTMLElement | null = null

          const shouldLoadToolsSignal = computed(() => {
            const { loadDevtools } = options()
            return typeof loadDevtools === 'boolean'
              ? loadDevtools
              : isDevMode()
          })

          const destroyRef = inject(DestroyRef)

          const getResolvedQueryClient = () => {
            const injectedClient = injector.get(QueryClient, null)
            const client = options().client ?? injectedClient
            if (!client) {
              throw new Error('No QueryClient found')
            }
            return client
          }

          const destroyDevtools = () => {
            devtools?.unmount()
            el?.remove()
            devtools = null
          }

          return () =>
            effect(() => {
              const shouldLoadTools = shouldLoadToolsSignal()
              const {
                client,
                position,
                errorTypes,
                buttonPosition,
                initialIsOpen,
              } = options()

              if (devtools && !shouldLoadTools) {
                destroyDevtools()
                return
              } else if (devtools && shouldLoadTools) {
                client && devtools.setClient(client)
                position && devtools.setPosition(position)
                errorTypes && devtools.setErrorTypes(errorTypes)
                buttonPosition && devtools.setButtonPosition(buttonPosition)
                initialIsOpen && devtools.setInitialIsOpen(initialIsOpen)
                return
              } else if (!shouldLoadTools) {
                return
              }

              el = document.body.appendChild(document.createElement('div'))
              el.classList.add('tsqd-parent-container')

              import('@tanstack/query-devtools').then((queryDevtools) =>
                runInInjectionContext(injector, () => {
                  devtools = new queryDevtools.TanstackQueryDevtools({
                    ...options(),
                    client: getResolvedQueryClient(),
                    queryFlavor: 'Angular Query',
                    version: '5',
                    onlineManager,
                  })

                  el && devtools.mount(el)

                  // Unmount the devtools on application destroy
                  destroyRef.onDestroy(destroyDevtools)
                }),
              )
            })
        },
      },
    ]
  }
  return queryFeature('DeveloperTools', providers)
}

/**
 * A type alias that represents all Query features available for use with `provideTanStackQuery`.
 * Features can be enabled by adding special functions to the `provideTanStackQuery` call.
 * See documentation for each symbol to find corresponding function name. See also `provideTanStackQuery`
 * documentation on how to use those functions.
 * @public
 * @see {@link provideTanStackQuery}
 */
export type QueryFeatures = DeveloperToolsFeature // Union type of features but just one now

export const queryFeatures = ['DeveloperTools'] as const

export type QueryFeatureKind = (typeof queryFeatures)[number]



# ./src/types.ts

/* istanbul ignore file */

import type {
  DefaultError,
  DefinedInfiniteQueryObserverResult,
  DefinedQueryObserverResult,
  InfiniteQueryObserverOptions,
  InfiniteQueryObserverResult,
  MutateFunction,
  MutationObserverResult,
  OmitKeyof,
  Override,
  QueryKey,
  QueryObserverOptions,
  QueryObserverResult,
} from '@tanstack/query-core'
import type { Signal } from '@angular/core'
import type { MapToSignals } from './signal-proxy'

/**
 * @public
 */
export interface CreateBaseQueryOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> extends QueryObserverOptions<
    TQueryFnData,
    TError,
    TData,
    TQueryData,
    TQueryKey
  > {}

/**
 * @public
 */
export interface CreateQueryOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> extends OmitKeyof<
    CreateBaseQueryOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryFnData,
      TQueryKey
    >,
    'suspense'
  > {}

/**
 * @public
 */
type CreateStatusBasedQueryResult<
  TStatus extends QueryObserverResult['status'],
  TData = unknown,
  TError = DefaultError,
> = Extract<QueryObserverResult<TData, TError>, { status: TStatus }>

/**
 * @public
 */
export interface BaseQueryNarrowing<TData = unknown, TError = DefaultError> {
  isSuccess: (
    this: CreateBaseQueryResult<TData, TError>,
  ) => this is CreateBaseQueryResult<
    TData,
    TError,
    CreateStatusBasedQueryResult<'success', TData, TError>
  >
  isError: (
    this: CreateBaseQueryResult<TData, TError>,
  ) => this is CreateBaseQueryResult<
    TData,
    TError,
    CreateStatusBasedQueryResult<'error', TData, TError>
  >
  isPending: (
    this: CreateBaseQueryResult<TData, TError>,
  ) => this is CreateBaseQueryResult<
    TData,
    TError,
    CreateStatusBasedQueryResult<'pending', TData, TError>
  >
}

/**
 * @public
 */
export interface CreateInfiniteQueryOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = unknown,
> extends OmitKeyof<
    InfiniteQueryObserverOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryData,
      TQueryKey,
      TPageParam
    >,
    'suspense'
  > {}

/**
 * @public
 */
export type CreateBaseQueryResult<
  TData = unknown,
  TError = DefaultError,
  TState = QueryObserverResult<TData, TError>,
> = BaseQueryNarrowing<TData, TError> &
  MapToSignals<OmitKeyof<TState, keyof BaseQueryNarrowing, 'safely'>>

/**
 * @public
 */
export type CreateQueryResult<
  TData = unknown,
  TError = DefaultError,
> = CreateBaseQueryResult<TData, TError>

/**
 * @public
 */
export type DefinedCreateQueryResult<
  TData = unknown,
  TError = DefaultError,
  TState = DefinedQueryObserverResult<TData, TError>,
> = BaseQueryNarrowing<TData, TError> &
  MapToSignals<OmitKeyof<TState, keyof BaseQueryNarrowing, 'safely'>>

/**
 * @public
 */
export type CreateInfiniteQueryResult<
  TData = unknown,
  TError = DefaultError,
> = MapToSignals<InfiniteQueryObserverResult<TData, TError>>

/**
 * @public
 */
export type DefinedCreateInfiniteQueryResult<
  TData = unknown,
  TError = DefaultError,
  TDefinedInfiniteQueryObserver = DefinedInfiniteQueryObserverResult<
    TData,
    TError
  >,
> = MapToSignals<TDefinedInfiniteQueryObserver>

/**
 * @public
 */
export type CreateMutateFunction<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
> = (
  ...args: Parameters<MutateFunction<TData, TError, TVariables, TContext>>
) => void

/**
 * @public
 */
export type CreateMutateAsyncFunction<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
> = MutateFunction<TData, TError, TVariables, TContext>

/**
 * @public
 */
export type CreateBaseMutationResult<
  TData = unknown,
  TError = DefaultError,
  TVariables = unknown,
  TContext = unknown,
> = Override<
  MutationObserverResult<TData, TError, TVariables, TContext>,
  { mutate: CreateMutateFunction<TData, TError, TVariables, TContext> }
> & {
  mutateAsync: CreateMutateAsyncFunction<TData, TError, TVariables, TContext>
}

/**
 * @public
 */
type CreateStatusBasedMutationResult<
  TStatus extends CreateBaseMutationResult['status'],
  TData = unknown,
  TError = DefaultError,
  TVariables = unknown,
  TContext = unknown,
> = Extract<
  CreateBaseMutationResult<TData, TError, TVariables, TContext>,
  { status: TStatus }
>

type SignalFunction<T extends () => any> = T & Signal<ReturnType<T>>

/**
 * @public
 */
export interface BaseMutationNarrowing<
  TData = unknown,
  TError = DefaultError,
  TVariables = unknown,
  TContext = unknown,
> {
  isSuccess: SignalFunction<
    (
      this: CreateMutationResult<TData, TError, TVariables, TContext>,
    ) => this is CreateMutationResult<
      TData,
      TError,
      TVariables,
      TContext,
      CreateStatusBasedMutationResult<
        'success',
        TData,
        TError,
        TVariables,
        TContext
      >
    >
  >
  isError: SignalFunction<
    (
      this: CreateMutationResult<TData, TError, TVariables, TContext>,
    ) => this is CreateMutationResult<
      TData,
      TError,
      TVariables,
      TContext,
      CreateStatusBasedMutationResult<
        'error',
        TData,
        TError,
        TVariables,
        TContext
      >
    >
  >
  isPending: SignalFunction<
    (
      this: CreateMutationResult<TData, TError, TVariables, TContext>,
    ) => this is CreateMutationResult<
      TData,
      TError,
      TVariables,
      TContext,
      CreateStatusBasedMutationResult<
        'pending',
        TData,
        TError,
        TVariables,
        TContext
      >
    >
  >
  isIdle: SignalFunction<
    (
      this: CreateMutationResult<TData, TError, TVariables, TContext>,
    ) => this is CreateMutationResult<
      TData,
      TError,
      TVariables,
      TContext,
      CreateStatusBasedMutationResult<
        'idle',
        TData,
        TError,
        TVariables,
        TContext
      >
    >
  >
}

/**
 * @public
 */
export type CreateMutationResult<
  TData = unknown,
  TError = DefaultError,
  TVariables = unknown,
  TContext = unknown,
  TState = CreateStatusBasedMutationResult<
    CreateBaseMutationResult['status'],
    TData,
    TError,
    TVariables,
    TContext
  >,
> = BaseMutationNarrowing<TData, TError, TVariables, TContext> &
  MapToSignals<OmitKeyof<TState, keyof BaseMutationNarrowing, 'safely'>>

/**
 * @public
 */
export type NonUndefinedGuard<T> = T extends undefined ? never : T



# ./src/infinite-query-options.ts

import type {
  DataTag,
  DefaultError,
  InfiniteData,
  QueryKey,
} from '@tanstack/query-core'
import type { CreateInfiniteQueryOptions, NonUndefinedGuard } from './types'

/**
 * @public
 */
export type UndefinedInitialDataInfiniteOptions<
  TQueryFnData,
  TError = DefaultError,
  TData = InfiniteData<TQueryFnData>,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = unknown,
> = CreateInfiniteQueryOptions<
  TQueryFnData,
  TError,
  TData,
  TQueryFnData,
  TQueryKey,
  TPageParam
> & {
  initialData?: undefined
}

/**
 * @public
 */
export type DefinedInitialDataInfiniteOptions<
  TQueryFnData,
  TError = DefaultError,
  TData = InfiniteData<TQueryFnData>,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = unknown,
> = CreateInfiniteQueryOptions<
  TQueryFnData,
  TError,
  TData,
  TQueryFnData,
  TQueryKey,
  TPageParam
> & {
  initialData:
    | NonUndefinedGuard<InfiniteData<TQueryFnData, TPageParam>>
    | (() => NonUndefinedGuard<InfiniteData<TQueryFnData, TPageParam>>)
}

/**
 * Allows to share and re-use infinite query options in a type-safe way.
 *
 * The `queryKey` will be tagged with the type from `queryFn`.
 * @param options - The infinite query options to tag with the type from `queryFn`.
 * @returns The tagged infinite query options.
 * @public
 */
export function infiniteQueryOptions<
  TQueryFnData,
  TError = DefaultError,
  TData = InfiniteData<TQueryFnData>,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = unknown,
>(
  options: DefinedInitialDataInfiniteOptions<
    TQueryFnData,
    TError,
    TData,
    TQueryKey,
    TPageParam
  >,
): DefinedInitialDataInfiniteOptions<
  TQueryFnData,
  TError,
  TData,
  TQueryKey,
  TPageParam
> & {
  queryKey: DataTag<TQueryKey, InfiniteData<TQueryFnData>>
}

/**
 * Allows to share and re-use infinite query options in a type-safe way.
 *
 * The `queryKey` will be tagged with the type from `queryFn`.
 * @param options - The infinite query options to tag with the type from `queryFn`.
 * @returns The tagged infinite query options.
 * @public
 */
export function infiniteQueryOptions<
  TQueryFnData,
  TError = DefaultError,
  TData = InfiniteData<TQueryFnData>,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = unknown,
>(
  options: UndefinedInitialDataInfiniteOptions<
    TQueryFnData,
    TError,
    TData,
    TQueryKey,
    TPageParam
  >,
): UndefinedInitialDataInfiniteOptions<
  TQueryFnData,
  TError,
  TData,
  TQueryKey,
  TPageParam
> & {
  queryKey: DataTag<TQueryKey, InfiniteData<TQueryFnData>>
}

/**
 * Allows to share and re-use infinite query options in a type-safe way.
 *
 * The `queryKey` will be tagged with the type from `queryFn`.
 * @param options - The infinite query options to tag with the type from `queryFn`.
 * @returns The tagged infinite query options.
 * @public
 */
export function infiniteQueryOptions(options: unknown) {
  return options
}



# ./src/mutation-options.ts

import type {
  DefaultError,
  MutationObserverOptions,
  OmitKeyof,
} from '@tanstack/query-core'

/**
 * Allows to share and re-use mutation options in a type-safe way.
 *
 * **Example**
 *
 * ```ts
 * export class QueriesService {
 *   private http = inject(HttpClient);
 *
 *   updatePost(id: number) {
 *     return mutationOptions({
 *       mutationFn: (post: Post) => Promise.resolve(post),
 *       mutationKey: ["updatePost", id],
 *       onSuccess: (newPost) => {
 *         //           ^? newPost: Post
 *         this.queryClient.setQueryData(["posts", id], newPost);
 *       },
 *     });
 *   }
 * }
 *
 * queries = inject(QueriesService)
 * idSignal = new Signal(0);
 * mutation = injectMutation(() => this.queries.updatePost(this.idSignal()))
 *
 * mutation.mutate({ title: 'New Title' })
 * ```
 * @param options - The mutation options.
 * @returns Mutation options.
 * @public
 */
export function mutationOptions<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
>(
  options: MutationObserverOptions<TData, TError, TVariables, TContext>,
): CreateMutationOptions<TData, TError, TVariables, TContext> {
  return options
}

/**
 * @public
 */
export interface CreateMutationOptions<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
> extends OmitKeyof<
    MutationObserverOptions<TData, TError, TVariables, TContext>,
    '_defaulted'
  > {}



# ./src/inject-infinite-query.ts

import { InfiniteQueryObserver } from '@tanstack/query-core'
import { createBaseQuery } from './create-base-query'
import { assertInjector } from './util/assert-injector/assert-injector'
import type { Injector } from '@angular/core'
import type {
  DefaultError,
  InfiniteData,
  QueryKey,
  QueryObserver,
} from '@tanstack/query-core'
import type {
  CreateInfiniteQueryOptions,
  CreateInfiniteQueryResult,
  DefinedCreateInfiniteQueryResult,
} from './types'
import type {
  DefinedInitialDataInfiniteOptions,
  UndefinedInitialDataInfiniteOptions,
} from './infinite-query-options'

/**
 * Injects an infinite query: a declarative dependency on an asynchronous source of data that is tied to a unique key.
 * Infinite queries can additively "load more" data onto an existing set of data or "infinite scroll"
 * @param optionsFn - A function that returns infinite query options.
 * @param injector - The Angular injector to use.
 * @returns The infinite query result.
 * @public
 */
export function injectInfiniteQuery<
  TQueryFnData,
  TError = DefaultError,
  TData = InfiniteData<TQueryFnData>,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = unknown,
>(
  optionsFn: () => DefinedInitialDataInfiniteOptions<
    TQueryFnData,
    TError,
    TData,
    TQueryKey,
    TPageParam
  >,
  injector?: Injector,
): DefinedCreateInfiniteQueryResult<TData, TError>

/**
 * Injects an infinite query: a declarative dependency on an asynchronous source of data that is tied to a unique key.
 * Infinite queries can additively "load more" data onto an existing set of data or "infinite scroll"
 * @param optionsFn - A function that returns infinite query options.
 * @param injector - The Angular injector to use.
 * @returns The infinite query result.
 * @public
 */
export function injectInfiniteQuery<
  TQueryFnData,
  TError = DefaultError,
  TData = InfiniteData<TQueryFnData>,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = unknown,
>(
  optionsFn: () => UndefinedInitialDataInfiniteOptions<
    TQueryFnData,
    TError,
    TData,
    TQueryKey,
    TPageParam
  >,
  injector?: Injector,
): CreateInfiniteQueryResult<TData, TError>

/**
 * Injects an infinite query: a declarative dependency on an asynchronous source of data that is tied to a unique key.
 * Infinite queries can additively "load more" data onto an existing set of data or "infinite scroll"
 * @param optionsFn - A function that returns infinite query options.
 * @param injector - The Angular injector to use.
 * @returns The infinite query result.
 * @public
 */
export function injectInfiniteQuery<
  TQueryFnData,
  TError = DefaultError,
  TData = InfiniteData<TQueryFnData>,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = unknown,
>(
  optionsFn: () => CreateInfiniteQueryOptions<
    TQueryFnData,
    TError,
    TData,
    TQueryFnData,
    TQueryKey,
    TPageParam
  >,
  injector?: Injector,
): CreateInfiniteQueryResult<TData, TError>

/**
 * Injects an infinite query: a declarative dependency on an asynchronous source of data that is tied to a unique key.
 * Infinite queries can additively "load more" data onto an existing set of data or "infinite scroll"
 * @param optionsFn - A function that returns infinite query options.
 * @param injector - The Angular injector to use.
 * @returns The infinite query result.
 * @public
 */
export function injectInfiniteQuery(
  optionsFn: () => CreateInfiniteQueryOptions,
  injector?: Injector,
) {
  return assertInjector(injectInfiniteQuery, injector, () =>
    createBaseQuery(optionsFn, InfiniteQueryObserver as typeof QueryObserver),
  )
}



# ./src/index.ts

/* istanbul ignore file */

// Re-export core
export * from '@tanstack/query-core'

export * from './types'

export type {
  DefinedInitialDataOptions,
  UndefinedInitialDataOptions,
} from './query-options'
export { queryOptions } from './query-options'
export { mutationOptions } from './mutation-options'
export type { CreateMutationOptions } from './mutation-options'

export type {
  DefinedInitialDataInfiniteOptions,
  UndefinedInitialDataInfiniteOptions,
} from './infinite-query-options'
export { infiniteQueryOptions } from './infinite-query-options'

export * from './inject-infinite-query'
export * from './inject-is-fetching'
export * from './inject-is-mutating'
export * from './inject-mutation'
export * from './inject-mutation-state'
export * from './inject-queries'
export * from './inject-query'
export * from './inject-query-client'
export * from './providers'



# ./src/inject-is-fetching.ts

import { DestroyRef, NgZone, inject, signal } from '@angular/core'
import { QueryClient, notifyManager } from '@tanstack/query-core'
import { assertInjector } from './util/assert-injector/assert-injector'
import type { QueryFilters } from '@tanstack/query-core'
import type { Injector, Signal } from '@angular/core'

/**
 * Injects a signal that tracks the number of queries that your application is loading or
 * fetching in the background.
 *
 * Can be used for app-wide loading indicators
 * @param filters - The filters to apply to the query.
 * @param injector - The Angular injector to use.
 * @returns signal with number of loading or fetching queries.
 * @public
 */
export function injectIsFetching(
  filters?: QueryFilters,
  injector?: Injector,
): Signal<number> {
  return assertInjector(injectIsFetching, injector, () => {
    const destroyRef = inject(DestroyRef)
    const ngZone = inject(NgZone)
    const queryClient = inject(QueryClient)

    const cache = queryClient.getQueryCache()
    // isFetching is the prev value initialized on mount *
    let isFetching = queryClient.isFetching(filters)

    const result = signal(isFetching)

    const unsubscribe = ngZone.runOutsideAngular(() =>
      cache.subscribe(
        notifyManager.batchCalls(() => {
          const newIsFetching = queryClient.isFetching(filters)
          if (isFetching !== newIsFetching) {
            // * and update with each change
            isFetching = newIsFetching
            ngZone.run(() => {
              result.set(isFetching)
            })
          }
        }),
      ),
    )

    destroyRef.onDestroy(unsubscribe)

    return result
  })
}



# ./src/inject-query-client.ts

import { Injector, inject } from '@angular/core'
import { QueryClient } from '@tanstack/query-core'
import type { InjectOptions } from '@angular/core'

/**
 * Injects a `QueryClient` instance and allows passing a custom injector.
 * @param injectOptions - Type of the options argument to inject and optionally a custom injector.
 * @returns The `QueryClient` instance.
 * @public
 * @deprecated Use `inject(QueryClient)` instead.
 * If you need to get a `QueryClient` from a custom injector, use `injector.get(QueryClient)`.
 *
 *
 * **Example**
 * ```ts
 * const queryClient = injectQueryClient();
 * ```
 */
export function injectQueryClient(
  injectOptions: InjectOptions & { injector?: Injector } = {},
) {
  return (injectOptions.injector ?? inject(Injector)).get(QueryClient)
}



# ./src/inject-queries.ts

import {
  QueriesObserver,
  QueryClient,
  notifyManager,
} from '@tanstack/query-core'
import {
  DestroyRef,
  NgZone,
  computed,
  effect,
  inject,
  signal,
} from '@angular/core'
import { assertInjector } from './util/assert-injector/assert-injector'
import type { Injector, Signal } from '@angular/core'
import type {
  DefaultError,
  OmitKeyof,
  QueriesObserverOptions,
  QueriesPlaceholderDataFunction,
  QueryFunction,
  QueryKey,
  QueryObserverOptions,
  QueryObserverResult,
  ThrowOnError,
} from '@tanstack/query-core'

// This defines the `CreateQueryOptions` that are accepted in `QueriesOptions` & `GetOptions`.
// `placeholderData` function does not have a parameter
type QueryObserverOptionsForCreateQueries<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> = OmitKeyof<
  QueryObserverOptions<TQueryFnData, TError, TData, TQueryFnData, TQueryKey>,
  'placeholderData'
> & {
  placeholderData?: TQueryFnData | QueriesPlaceholderDataFunction<TQueryFnData>
}

// Avoid TS depth-limit error in case of large array literal
type MAXIMUM_DEPTH = 20

// Widen the type of the symbol to enable type inference even if skipToken is not immutable.
type SkipTokenForUseQueries = symbol

type GetOptions<T> =
  // Part 1: responsible for applying explicit type parameter to function arguments, if object { queryFnData: TQueryFnData, error: TError, data: TData }
  T extends {
    queryFnData: infer TQueryFnData
    error?: infer TError
    data: infer TData
  }
    ? QueryObserverOptionsForCreateQueries<TQueryFnData, TError, TData>
    : T extends { queryFnData: infer TQueryFnData; error?: infer TError }
      ? QueryObserverOptionsForCreateQueries<TQueryFnData, TError>
      : T extends { data: infer TData; error?: infer TError }
        ? QueryObserverOptionsForCreateQueries<unknown, TError, TData>
        : // Part 2: responsible for applying explicit type parameter to function arguments, if tuple [TQueryFnData, TError, TData]
          T extends [infer TQueryFnData, infer TError, infer TData]
          ? QueryObserverOptionsForCreateQueries<TQueryFnData, TError, TData>
          : T extends [infer TQueryFnData, infer TError]
            ? QueryObserverOptionsForCreateQueries<TQueryFnData, TError>
            : T extends [infer TQueryFnData]
              ? QueryObserverOptionsForCreateQueries<TQueryFnData>
              : // Part 3: responsible for inferring and enforcing type if no explicit parameter was provided
                T extends {
                    queryFn?:
                      | QueryFunction<infer TQueryFnData, infer TQueryKey>
                      | SkipTokenForUseQueries
                    select: (data: any) => infer TData
                    throwOnError?: ThrowOnError<any, infer TError, any, any>
                  }
                ? QueryObserverOptionsForCreateQueries<
                    TQueryFnData,
                    unknown extends TError ? DefaultError : TError,
                    unknown extends TData ? TQueryFnData : TData,
                    TQueryKey
                  >
                : // Fallback
                  QueryObserverOptionsForCreateQueries

type GetResults<T> =
  // Part 1: responsible for mapping explicit type parameter to function result, if object
  T extends { queryFnData: any; error?: infer TError; data: infer TData }
    ? QueryObserverResult<TData, TError>
    : T extends { queryFnData: infer TQueryFnData; error?: infer TError }
      ? QueryObserverResult<TQueryFnData, TError>
      : T extends { data: infer TData; error?: infer TError }
        ? QueryObserverResult<TData, TError>
        : // Part 2: responsible for mapping explicit type parameter to function result, if tuple
          T extends [any, infer TError, infer TData]
          ? QueryObserverResult<TData, TError>
          : T extends [infer TQueryFnData, infer TError]
            ? QueryObserverResult<TQueryFnData, TError>
            : T extends [infer TQueryFnData]
              ? QueryObserverResult<TQueryFnData>
              : // Part 3: responsible for mapping inferred type to results, if no explicit parameter was provided
                T extends {
                    queryFn?:
                      | QueryFunction<infer TQueryFnData, any>
                      | SkipTokenForUseQueries
                    select: (data: any) => infer TData
                    throwOnError?: ThrowOnError<any, infer TError, any, any>
                  }
                ? QueryObserverResult<
                    unknown extends TData ? TQueryFnData : TData,
                    unknown extends TError ? DefaultError : TError
                  >
                : // Fallback
                  QueryObserverResult

/**
 * QueriesOptions reducer recursively unwraps function arguments to infer/enforce type param
 * @public
 */
export type QueriesOptions<
  T extends Array<any>,
  TResult extends Array<any> = [],
  TDepth extends ReadonlyArray<number> = [],
> = TDepth['length'] extends MAXIMUM_DEPTH
  ? Array<QueryObserverOptionsForCreateQueries>
  : T extends []
    ? []
    : T extends [infer Head]
      ? [...TResult, GetOptions<Head>]
      : T extends [infer Head, ...infer Tail]
        ? QueriesOptions<
            [...Tail],
            [...TResult, GetOptions<Head>],
            [...TDepth, 1]
          >
        : ReadonlyArray<unknown> extends T
          ? T
          : // If T is *some* array but we couldn't assign unknown[] to it, then it must hold some known/homogenous type!
            // use this to infer the param types in the case of Array.map() argument
            T extends Array<
                QueryObserverOptionsForCreateQueries<
                  infer TQueryFnData,
                  infer TError,
                  infer TData,
                  infer TQueryKey
                >
              >
            ? Array<
                QueryObserverOptionsForCreateQueries<
                  TQueryFnData,
                  TError,
                  TData,
                  TQueryKey
                >
              >
            : // Fallback
              Array<QueryObserverOptionsForCreateQueries>

/**
 * QueriesResults reducer recursively maps type param to results
 * @public
 */
export type QueriesResults<
  T extends Array<any>,
  TResult extends Array<any> = [],
  TDepth extends ReadonlyArray<number> = [],
> = TDepth['length'] extends MAXIMUM_DEPTH
  ? Array<QueryObserverResult>
  : T extends []
    ? []
    : T extends [infer Head]
      ? [...TResult, GetResults<Head>]
      : T extends [infer Head, ...infer Tail]
        ? QueriesResults<
            [...Tail],
            [...TResult, GetResults<Head>],
            [...TDepth, 1]
          >
        : T extends Array<
              QueryObserverOptionsForCreateQueries<
                infer TQueryFnData,
                infer TError,
                infer TData,
                any
              >
            >
          ? // Dynamic-size (homogenous) CreateQueryOptions array: map directly to array of results
            Array<
              QueryObserverResult<
                unknown extends TData ? TQueryFnData : TData,
                unknown extends TError ? DefaultError : TError
              >
            >
          : // Fallback
            Array<QueryObserverResult>

/**
 * @param root0
 * @param root0.queries
 * @param root0.combine
 * @param injector
 * @public
 */
export function injectQueries<
  T extends Array<any>,
  TCombinedResult = QueriesResults<T>,
>(
  {
    queries,
    ...options
  }: {
    queries: Signal<[...QueriesOptions<T>]>
    combine?: (result: QueriesResults<T>) => TCombinedResult
  },
  injector?: Injector,
): Signal<TCombinedResult> {
  return assertInjector(injectQueries, injector, () => {
    const destroyRef = inject(DestroyRef)
    const ngZone = inject(NgZone)
    const queryClient = inject(QueryClient)

    const defaultedQueries = computed(() => {
      return queries().map((opts) => {
        const defaultedOptions = queryClient.defaultQueryOptions(opts)
        // Make sure the results are already in fetching state before subscribing or updating options
        defaultedOptions._optimisticResults = 'optimistic'

        return defaultedOptions as QueryObserverOptions
      })
    })

    const observer = new QueriesObserver<TCombinedResult>(
      queryClient,
      defaultedQueries(),
      options as QueriesObserverOptions<TCombinedResult>,
    )

    // Do not notify on updates because of changes in the options because
    // these changes should already be reflected in the optimistic result.
    effect(() => {
      observer.setQueries(
        defaultedQueries(),
        options as QueriesObserverOptions<TCombinedResult>,
        { listeners: false },
      )
    })

    const [, getCombinedResult] = observer.getOptimisticResult(
      defaultedQueries(),
      (options as QueriesObserverOptions<TCombinedResult>).combine,
    )

    const result = signal(getCombinedResult() as any)

    const unsubscribe = ngZone.runOutsideAngular(() =>
      observer.subscribe(notifyManager.batchCalls(result.set)),
    )
    destroyRef.onDestroy(unsubscribe)

    return result
  })
}
