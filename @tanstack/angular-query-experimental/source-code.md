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



# ./src/util/assert-injector/assert-injector.test.ts

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
  InjectionToken,
  Injector,
  inject,
  provideExperimentalZonelessChangeDetection,
  runInInjectionContext,
} from '@angular/core'
import { TestBed } from '@angular/core/testing'
import { assertInjector } from './assert-injector'

describe('assertInjector', () => {
  const token = new InjectionToken('token', {
    factory: () => 1,
  })

  function injectDummy(injector?: Injector) {
    injector = assertInjector(injectDummy, injector)
    return runInInjectionContext(injector, () => inject(token))
  }

  function injectDummyTwo(injector?: Injector) {
    return assertInjector(injectDummyTwo, injector, () => inject(token) + 1)
  }

  it('given no custom injector, when run in injection context, then return value', () => {
    TestBed.configureTestingModule({
      providers: [provideExperimentalZonelessChangeDetection()],
    })
    TestBed.runInInjectionContext(() => {
      const value = injectDummy()
      const valueTwo = injectDummyTwo()
      expect(value).toEqual(1)
      expect(valueTwo).toEqual(2)
    })
  })

  it('given no custom injector, when run outside injection context, then throw', () => {
    expect(() => injectDummy()).toThrowError(
      /injectDummy\(\) can only be used within an injection context/i,
    )
    expect(() => injectDummyTwo()).toThrowError(
      /injectDummyTwo\(\) can only be used within an injection context/i,
    )
  })

  it('given a custom injector, when run in that injector context without providing number, then throw', () => {
    expect(() => injectDummy(Injector.create({ providers: [] }))).toThrowError(
      /No provider for InjectionToken/i,
    )
    expect(() =>
      injectDummyTwo(Injector.create({ providers: [] })),
    ).toThrowError(/No provider for InjectionToken/i)
  })

  it('given a custom injector, when run in that injector context and providing number, then return value', () => {
    const value = injectDummy(
      Injector.create({ providers: [{ provide: token, useValue: 2 }] }),
    )
    const valueTwo = injectDummyTwo(
      Injector.create({ providers: [{ provide: token, useValue: 2 }] }),
    )
    expect(value).toEqual(2)
    expect(valueTwo).toEqual(3)
  })
})



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



# ./src/__tests__/mutation-options.test-d.ts

import { mutationOptions } from '../mutation-options'

describe('mutationOptions', () => {
  test('should not allow excess properties', () => {
    return mutationOptions({
      mutationFn: () => Promise.resolve(5),
      mutationKey: ['key'],
      // @ts-expect-error this is a good error, because onMutates does not exist!
      onMutates: 1000,
    })
  })

  test('should infer types for callbacks', () => {
    return mutationOptions({
      mutationFn: () => Promise.resolve(5),
      mutationKey: ['key'],
      onSuccess: (data) => {
        expectTypeOf(data).toEqualTypeOf<number>()
      },
    })
  })
})



# ./src/__tests__/inject-mutation.test.ts

import {
  Component,
  Injectable,
  Injector,
  inject,
  input,
  provideExperimentalZonelessChangeDetection,
  signal,
} from '@angular/core'
import { TestBed } from '@angular/core/testing'
import { describe, expect, vi } from 'vitest'
import { By } from '@angular/platform-browser'
import { QueryClient, injectMutation, provideTanStackQuery } from '..'
import {
  errorMutator,
  expectSignals,
  setFixtureSignalInputs,
  successMutator,
} from './test-utils'

const MUTATION_DURATION = 1000

const resolveMutations = () => vi.advanceTimersByTimeAsync(MUTATION_DURATION)

describe('injectMutation', () => {
  let queryClient: QueryClient

  beforeEach(() => {
    queryClient = new QueryClient()
    vi.useFakeTimers()
    TestBed.configureTestingModule({
      providers: [
        provideExperimentalZonelessChangeDetection(),
        provideTanStackQuery(queryClient),
      ],
    })
  })

  afterEach(() => {
    vi.useRealTimers()
  })

  test('should be in idle state initially', () => {
    const mutation = TestBed.runInInjectionContext(() => {
      return injectMutation(() => ({
        mutationFn: (params) => successMutator(params),
      }))
    })

    expectSignals(mutation, {
      isIdle: true,
      isPending: false,
      isError: false,
      isSuccess: false,
    })
  })

  test('should change state after invoking mutate', () => {
    const result = 'Mock data'

    const mutation = TestBed.runInInjectionContext(() => {
      return injectMutation(() => ({
        mutationFn: (params: string) => successMutator(params),
      }))
    })

    TestBed.flushEffects()

    mutation.mutate(result)
    vi.advanceTimersByTime(1)

    expectSignals(mutation, {
      isIdle: false,
      isPending: true,
      isError: false,
      isSuccess: false,
      data: undefined,
      error: null,
    })
  })

  test('should return error when request fails', async () => {
    const mutation = TestBed.runInInjectionContext(() => {
      return injectMutation(() => ({
        mutationFn: errorMutator,
      }))
    })

    mutation.mutate({})

    await resolveMutations()

    expectSignals(mutation, {
      isIdle: false,
      isPending: false,
      isError: true,
      isSuccess: false,
      data: undefined,
      error: Error('Some error'),
    })
  })

  test('should return data when request succeeds', async () => {
    const result = 'Mock data'
    const mutation = TestBed.runInInjectionContext(() => {
      return injectMutation(() => ({
        mutationFn: (params: string) => successMutator(params),
      }))
    })

    mutation.mutate(result)

    await resolveMutations()

    expectSignals(mutation, {
      isIdle: false,
      isPending: false,
      isError: false,
      isSuccess: true,
      data: result,
      error: null,
    })
  })

  test('reactive options should update mutation', async () => {
    const mutationCache = queryClient.getMutationCache()
    // Signal will be updated before the mutation is called
    // this test confirms that the mutation uses the updated value
    const mutationKey = signal(['1'])
    const mutation = TestBed.runInInjectionContext(() => {
      return injectMutation(() => ({
        mutationKey: mutationKey(),
        mutationFn: (params: string) => successMutator(params),
      }))
    })

    mutationKey.set(['2'])

    mutation.mutate('xyz')

    const mutations = mutationCache.find({ mutationKey: ['2'] })

    expect(mutations?.options.mutationKey).toEqual(['2'])
  })

  test('should reset state after invoking mutation.reset', async () => {
    const mutation = TestBed.runInInjectionContext(() => {
      return injectMutation(() => ({
        mutationFn: (params: string) => errorMutator(params),
      }))
    })

    mutation.mutate('')

    await resolveMutations()

    expect(mutation.isError()).toBe(true)

    mutation.reset()

    await resolveMutations()

    expectSignals(mutation, {
      isIdle: true,
      isPending: false,
      isError: false,
      isSuccess: false,
      data: undefined,
      error: null,
    })
  })

  describe('side effects', () => {
    beforeEach(() => {
      vi.clearAllMocks()
    })

    test('should call onMutate when passed as an option', async () => {
      const onMutate = vi.fn()
      const mutation = TestBed.runInInjectionContext(() => {
        return injectMutation(() => ({
          mutationFn: (params: string) => successMutator(params),
          onMutate,
        }))
      })

      mutation.mutate('')

      await resolveMutations()

      expect(onMutate).toHaveBeenCalledTimes(1)
    })

    test('should call onError when passed as an option', async () => {
      const onError = vi.fn()
      const mutation = TestBed.runInInjectionContext(() => {
        return injectMutation(() => ({
          mutationFn: (params: string) => errorMutator(params),
          onError,
        }))
      })

      mutation.mutate('')

      await resolveMutations()

      expect(onError).toHaveBeenCalledTimes(1)
    })

    test('should call onSuccess when passed as an option', async () => {
      const onSuccess = vi.fn()
      const mutation = TestBed.runInInjectionContext(() => {
        return injectMutation(() => ({
          mutationFn: (params: string) => successMutator(params),
          onSuccess,
        }))
      })

      mutation.mutate('')

      await resolveMutations()

      expect(onSuccess).toHaveBeenCalledTimes(1)
    })

    test('should call onSettled when passed as an option', async () => {
      const onSettled = vi.fn()
      const mutation = TestBed.runInInjectionContext(() => {
        return injectMutation(() => ({
          mutationFn: (params: string) => successMutator(params),
          onSettled,
        }))
      })

      mutation.mutate('')

      await resolveMutations()

      expect(onSettled).toHaveBeenCalledTimes(1)
    })

    test('should call onError when passed as an argument of mutate function', async () => {
      const onError = vi.fn()
      const mutation = TestBed.runInInjectionContext(() => {
        return injectMutation(() => ({
          mutationFn: (params: string) => errorMutator(params),
        }))
      })

      mutation.mutate('', { onError })

      await resolveMutations()

      expect(onError).toHaveBeenCalledTimes(1)
    })

    test('should call onSuccess when passed as an argument of mutate function', async () => {
      const onSuccess = vi.fn()
      const mutation = TestBed.runInInjectionContext(() => {
        return injectMutation(() => ({
          mutationFn: (params: string) => successMutator(params),
        }))
      })

      mutation.mutate('', { onSuccess })

      await resolveMutations()

      expect(onSuccess).toHaveBeenCalledTimes(1)
    })

    test('should call onSettled when passed as an argument of mutate function', async () => {
      const onSettled = vi.fn()
      const mutation = TestBed.runInInjectionContext(() => {
        return injectMutation(() => ({
          mutationFn: (params: string) => successMutator(params),
        }))
      })

      mutation.mutate('', { onSettled })

      await resolveMutations()

      expect(onSettled).toHaveBeenCalledTimes(1)
    })

    test('should fire both onSettled functions', async () => {
      const onSettled = vi.fn()
      const onSettledOnFunction = vi.fn()
      const mutation = TestBed.runInInjectionContext(() => {
        return injectMutation(() => ({
          mutationFn: (params: string) => successMutator(params),
          onSettled,
        }))
      })

      mutation.mutate('', { onSettled: onSettledOnFunction })

      await resolveMutations()

      expect(onSettled).toHaveBeenCalledTimes(1)
      expect(onSettledOnFunction).toHaveBeenCalledTimes(1)
    })
  })

  test('should support required signal inputs', async () => {
    const mutationCache = queryClient.getMutationCache()

    @Component({
      selector: 'app-fake',
      template: `
        <button (click)="mutate()"></button>
        <span>{{ mutation.data() }}</span>
      `,
      standalone: true,
    })
    class FakeComponent {
      name = input.required<string>()

      mutation = injectMutation(() => ({
        mutationKey: ['fake', this.name()],
        mutationFn: () => successMutator(this.name()),
      }))

      mutate(): void {
        this.mutation.mutate()
      }
    }

    const fixture = TestBed.createComponent(FakeComponent)
    const { debugElement } = fixture
    setFixtureSignalInputs(fixture, { name: 'value' })

    const button = debugElement.query(By.css('button'))
    button.triggerEventHandler('click')

    await resolveMutations()
    fixture.detectChanges()

    const text = debugElement.query(By.css('span')).nativeElement.textContent
    expect(text).toEqual('value')
    const mutation = mutationCache.find({ mutationKey: ['fake', 'value'] })
    expect(mutation).toBeDefined()
    expect(mutation!.options.mutationKey).toStrictEqual(['fake', 'value'])
  })

  test('should update options on required signal input change', async () => {
    const mutationCache = queryClient.getMutationCache()

    @Component({
      selector: 'app-fake',
      template: `
        <button (click)="mutate()"></button>
        <span>{{ mutation.data() }}</span>
      `,
      standalone: true,
    })
    class FakeComponent {
      name = input.required<string>()

      mutation = injectMutation(() => ({
        mutationKey: ['fake', this.name()],
        mutationFn: () => successMutator(this.name()),
      }))

      mutate(): void {
        this.mutation.mutate()
      }
    }

    const fixture = TestBed.createComponent(FakeComponent)
    const { debugElement } = fixture
    setFixtureSignalInputs(fixture, { name: 'value' })

    const button = debugElement.query(By.css('button'))
    const span = debugElement.query(By.css('span'))

    button.triggerEventHandler('click')
    await resolveMutations()
    fixture.detectChanges()

    expect(span.nativeElement.textContent).toEqual('value')

    setFixtureSignalInputs(fixture, { name: 'updatedValue' })

    button.triggerEventHandler('click')
    await resolveMutations()
    fixture.detectChanges()

    expect(span.nativeElement.textContent).toEqual('updatedValue')

    const mutations = mutationCache.findAll()
    expect(mutations.length).toBe(2)
    const [mutation1, mutation2] = mutations
    expect(mutation1!.options.mutationKey).toEqual(['fake', 'value'])
    expect(mutation2!.options.mutationKey).toEqual(['fake', 'updatedValue'])
  })

  describe('throwOnError', () => {
    test('should evaluate throwOnError when mutation is expected to throw', async () => {
      const err = new Error('Expected mock error. All is well!')
      const boundaryFn = vi.fn()
      const { mutate } = TestBed.runInInjectionContext(() => {
        return injectMutation(() => ({
          mutationKey: ['fake'],
          mutationFn: () => {
            return Promise.reject(err)
          },
          throwOnError: boundaryFn,
        }))
      })

      TestBed.flushEffects()

      mutate()

      await resolveMutations()

      expect(boundaryFn).toHaveBeenCalledTimes(1)
      expect(boundaryFn).toHaveBeenCalledWith(err)
    })
  })

  test('should throw when throwOnError is true', async () => {
    const err = new Error('Expected mock error. All is well!')
    const { mutateAsync } = TestBed.runInInjectionContext(() => {
      return injectMutation(() => ({
        mutationKey: ['fake'],
        mutationFn: () => {
          return Promise.reject(err)
        },
        throwOnError: true,
      }))
    })

    await expect(() => mutateAsync()).rejects.toThrowError(err)
  })

  test('should throw when throwOnError function returns true', async () => {
    const err = new Error('Expected mock error. All is well!')
    const { mutateAsync } = TestBed.runInInjectionContext(() => {
      return injectMutation(() => ({
        mutationKey: ['fake'],
        mutationFn: () => {
          return Promise.reject(err)
        },
        throwOnError: () => true,
      }))
    })

    await expect(() => mutateAsync()).rejects.toThrowError(err)
  })

  test('should execute callback in injection context', async () => {
    const errorSpy = vi.fn()
    @Injectable()
    class FakeService {
      updateData(name: string) {
        return Promise.resolve(name)
      }
    }

    @Component({
      selector: 'app-fake',
      template: ``,
      standalone: true,
      providers: [FakeService],
    })
    class FakeComponent {
      mutation = injectMutation(() => {
        try {
          const service = inject(FakeService)
          return {
            mutationFn: (name: string) => service.updateData(name),
          }
        } catch (e) {
          errorSpy(e)
          throw e
        }
      })
    }

    const fixture = TestBed.createComponent(FakeComponent)
    fixture.detectChanges()

    // check if injection contexts persist in a different task
    await new Promise<void>((resolve) => queueMicrotask(() => resolve()))

    expect(
      await fixture.componentInstance.mutation.mutateAsync('test'),
    ).toEqual('test')
    expect(errorSpy).not.toHaveBeenCalled()
  })

  describe('injection context', () => {
    test('throws NG0203 with descriptive error outside injection context', () => {
      expect(() => {
        injectMutation(() => ({
          mutationKey: ['injectionContextError'],
          mutationFn: () => Promise.resolve(),
        }))
      }).toThrowError(/NG0203(.*?)injectMutation/)
    })

    test('can be used outside injection context when passing an injector', () => {
      expect(() => {
        injectMutation(
          () => ({
            mutationKey: ['injectionContextError'],
            mutationFn: () => Promise.resolve(),
          }),
          TestBed.inject(Injector),
        )
      }).not.toThrow()
    })
  })
})



# ./src/__tests__/inject-mutation-state.test-d.ts

import { describe, expectTypeOf } from 'vitest'
import { injectMutationState } from '..'
import type { MutationState, MutationStatus } from '..'

describe('injectMutationState', () => {
  it('should default to QueryState', () => {
    const result = injectMutationState(() => ({
      filters: { status: 'pending' },
    }))

    expectTypeOf(result()).toEqualTypeOf<Array<MutationState>>()
  })

  it('should infer with select', () => {
    const result = injectMutationState(() => ({
      filters: { status: 'pending' },
      select: (mutation) => mutation.state.status,
    }))

    expectTypeOf(result()).toEqualTypeOf<Array<MutationStatus>>()
  })
})



# ./src/__tests__/inject-query.test.ts

import {
  Component,
  Injectable,
  Injector,
  computed,
  effect,
  inject,
  input,
  provideExperimentalZonelessChangeDetection,
  signal,
} from '@angular/core'
import { TestBed } from '@angular/core/testing'
import { afterEach, describe, expect, vi } from 'vitest'
import { QueryCache, QueryClient, injectQuery, provideTanStackQuery } from '..'
import {
  delayedFetcher,
  getSimpleFetcherWithReturnData,
  queryKey,
  rejectFetcher,
  setSignalInputs,
  simpleFetcher,
} from './test-utils'
import type { CreateQueryOptions, OmitKeyof, QueryFunction } from '..'

const QUERY_DURATION = 100

const resolveQueries = () => vi.advanceTimersByTimeAsync(QUERY_DURATION)

describe('injectQuery', () => {
  let queryCache: QueryCache
  let queryClient: QueryClient
  beforeEach(() => {
    vi.useFakeTimers()
    queryCache = new QueryCache()
    queryClient = new QueryClient({ queryCache })
    TestBed.configureTestingModule({
      providers: [
        provideExperimentalZonelessChangeDetection(),
        provideTanStackQuery(queryClient),
      ],
    })
  })

  afterEach(() => {
    vi.useRealTimers()
  })

  test('should return the correct types', () => {
    const key = queryKey()
    // unspecified query function should default to unknown
    const noQueryFn = TestBed.runInInjectionContext(() =>
      injectQuery(() => ({
        queryKey: key,
      })),
    )
    expectTypeOf(noQueryFn.data()).toEqualTypeOf<unknown>()
    expectTypeOf(noQueryFn.error()).toEqualTypeOf<Error | null>()

    // it should infer the result type from the query function
    const fromQueryFn = TestBed.runInInjectionContext(() =>
      injectQuery(() => ({
        queryKey: key,
        queryFn: () => 'test',
      })),
    )
    expectTypeOf(fromQueryFn.data()).toEqualTypeOf<string | undefined>()
    expectTypeOf(fromQueryFn.error()).toEqualTypeOf<Error | null>()

    // it should be possible to specify the result type
    const withResult = TestBed.runInInjectionContext(() =>
      injectQuery<string>(() => ({
        queryKey: key,
        queryFn: () => 'test',
      })),
    )
    expectTypeOf(withResult.data()).toEqualTypeOf<string | undefined>()
    expectTypeOf(withResult.error()).toEqualTypeOf<Error | null>()

    // it should be possible to specify the error type
    type CustomErrorType = { message: string }
    const withError = TestBed.runInInjectionContext(() =>
      injectQuery<string, CustomErrorType>(() => ({
        queryKey: key,
        queryFn: () => 'test',
      })),
    )
    expectTypeOf(withError.data()).toEqualTypeOf<string | undefined>()
    expectTypeOf(withError.error()).toEqualTypeOf<CustomErrorType | null>()

    // it should infer the result type from the configuration
    const withResultInfer = TestBed.runInInjectionContext(() =>
      injectQuery(() => ({
        queryKey: key,
        queryFn: () => true,
      })),
    )
    expectTypeOf(withResultInfer.data()).toEqualTypeOf<boolean | undefined>()
    expectTypeOf(withResultInfer.error()).toEqualTypeOf<Error | null>()

    // it should be possible to specify a union type as result type
    const unionTypeSync = TestBed.runInInjectionContext(() =>
      injectQuery(() => ({
        queryKey: key,
        queryFn: () => (Math.random() > 0.5 ? ('a' as const) : ('b' as const)),
      })),
    )
    expectTypeOf(unionTypeSync.data()).toEqualTypeOf<'a' | 'b' | undefined>()
    const unionTypeAsync = TestBed.runInInjectionContext(() =>
      injectQuery<'a' | 'b'>(() => ({
        queryKey: key,
        queryFn: () => Promise.resolve(Math.random() > 0.5 ? 'a' : 'b'),
      })),
    )
    expectTypeOf(unionTypeAsync.data()).toEqualTypeOf<'a' | 'b' | undefined>()

    // it should error when the query function result does not match with the specified type
    TestBed.runInInjectionContext(() =>
      // @ts-expect-error
      injectQuery<number>(() => ({ queryKey: key, queryFn: () => 'test' })),
    )

    // it should infer the result type from a generic query function
    /**
     *
     */
    function queryFn<T = string>(): Promise<T> {
      return Promise.resolve({} as T)
    }

    const fromGenericQueryFn = TestBed.runInInjectionContext(() =>
      injectQuery(() => ({
        queryKey: key,
        queryFn: () => queryFn(),
      })),
    )
    expectTypeOf(fromGenericQueryFn.data()).toEqualTypeOf<string | undefined>()
    expectTypeOf(fromGenericQueryFn.error()).toEqualTypeOf<Error | null>()

    // todo use query options?
    const fromGenericOptionsQueryFn = TestBed.runInInjectionContext(() =>
      injectQuery(() => ({
        queryKey: key,
        queryFn: () => queryFn(),
      })),
    )
    expectTypeOf(fromGenericOptionsQueryFn.data()).toEqualTypeOf<
      string | undefined
    >()
    expectTypeOf(
      fromGenericOptionsQueryFn.error(),
    ).toEqualTypeOf<Error | null>()

    type MyData = number
    type MyQueryKey = readonly ['my-data', number]

    const getMyDataArrayKey: QueryFunction<MyData, MyQueryKey> = ({
      queryKey: [, n],
    }) => {
      return n + 42
    }

    const fromMyDataArrayKeyQueryFn = TestBed.runInInjectionContext(() =>
      injectQuery(() => ({
        queryKey: ['my-data', 100] as const,
        queryFn: getMyDataArrayKey,
      })),
    )
    expectTypeOf(fromMyDataArrayKeyQueryFn.data()).toEqualTypeOf<
      number | undefined
    >()

    // it should handle query-functions that return Promise<any>
    const fromPromiseAnyQueryFn = TestBed.runInInjectionContext(() =>
      injectQuery(() => ({
        queryKey: key,
        queryFn: () => fetch('return Promise<any>').then((resp) => resp.json()),
      })),
    )
    expectTypeOf(fromPromiseAnyQueryFn.data()).toEqualTypeOf<any | undefined>()

    TestBed.runInInjectionContext(() =>
      effect(() => {
        if (fromPromiseAnyQueryFn.isSuccess()) {
          expect(fromMyDataArrayKeyQueryFn.data()).toBe(142)
        }
      }),
    )

    const getMyDataStringKey: QueryFunction<MyData, ['1']> = (context) => {
      expectTypeOf(context.queryKey).toEqualTypeOf<['1']>()
      return Number(context.queryKey[0]) + 42
    }

    const fromGetMyDataStringKeyQueryFn = TestBed.runInInjectionContext(() =>
      injectQuery(() => ({
        queryKey: ['1'] as ['1'],
        queryFn: getMyDataStringKey,
      })),
    )
    expectTypeOf(fromGetMyDataStringKeyQueryFn.data()).toEqualTypeOf<
      number | undefined
    >()

    TestBed.runInInjectionContext(() =>
      effect(() => {
        if (fromGetMyDataStringKeyQueryFn.isSuccess()) {
          expect(fromGetMyDataStringKeyQueryFn.data()).toBe(43)
        }
      }),
    )

    // handles wrapped queries with custom fetcher passed as inline queryFn
    const createWrappedQuery = <
      TQueryKey extends [string, Record<string, unknown>?],
      TQueryFnData,
      TError,
      TData = TQueryFnData,
    >(
      qk: TQueryKey,
      fetcher: (
        obj: TQueryKey[1],
        token: string,
        // return type must be wrapped with TQueryFnReturn
      ) => Promise<TQueryFnData>,
      options?: OmitKeyof<
        CreateQueryOptions<TQueryFnData, TError, TData, TQueryKey>,
        'queryKey' | 'queryFn' | 'initialData',
        'safely'
      >,
    ) =>
      injectQuery(() => ({
        queryKey: qk,
        queryFn: () => fetcher(qk[1], 'token'),
        ...options,
      }))
    const fromWrappedQuery = TestBed.runInInjectionContext(() =>
      createWrappedQuery([''], async () => '1'),
    )
    expectTypeOf(fromWrappedQuery.data()).toEqualTypeOf<string | undefined>()

    // handles wrapped queries with custom fetcher passed directly to createQuery
    const createWrappedFuncStyleQuery = <
      TQueryKey extends [string, Record<string, unknown>?],
      TQueryFnData,
      TError,
      TData = TQueryFnData,
    >(
      qk: TQueryKey,
      fetcher: () => Promise<TQueryFnData>,
      options?: OmitKeyof<
        CreateQueryOptions<TQueryFnData, TError, TData, TQueryKey>,
        'queryKey' | 'queryFn' | 'initialData',
        'safely'
      >,
    ) => injectQuery(() => ({ queryKey: qk, queryFn: fetcher, ...options }))
    const fromWrappedFuncStyleQuery = TestBed.runInInjectionContext(() =>
      createWrappedFuncStyleQuery([''], async () => true),
    )
    expectTypeOf(fromWrappedFuncStyleQuery.data()).toEqualTypeOf<
      boolean | undefined
    >()
  })

  test('should return pending status initially', () => {
    const query = TestBed.runInInjectionContext(() => {
      return injectQuery(() => ({
        queryKey: ['key1'],
        queryFn: simpleFetcher,
      }))
    })

    expect(query.status()).toBe('pending')
    expect(query.isPending()).toBe(true)
    expect(query.isFetching()).toBe(true)
    expect(query.isStale()).toBe(true)
    expect(query.isFetched()).toBe(false)
  })

  test('should resolve to success and update signal: injectQuery()', async () => {
    const query = TestBed.runInInjectionContext(() => {
      return injectQuery(() => ({
        queryKey: ['key2'],
        queryFn: getSimpleFetcherWithReturnData('result2'),
      }))
    })

    await resolveQueries()

    expect(query.status()).toBe('success')
    expect(query.data()).toBe('result2')
    expect(query.isPending()).toBe(false)
    expect(query.isFetching()).toBe(false)
    expect(query.isFetched()).toBe(true)
    expect(query.isSuccess()).toBe(true)
  })

  test('should reject and update signal', async () => {
    const query = TestBed.runInInjectionContext(() => {
      return injectQuery(() => ({
        retry: false,
        queryKey: ['key3'],
        queryFn: rejectFetcher,
      }))
    })

    await resolveQueries()

    expect(query.status()).toBe('error')
    expect(query.data()).toBe(undefined)
    expect(query.error()).toMatchObject({ message: 'Some error' })
    expect(query.isPending()).toBe(false)
    expect(query.isFetching()).toBe(false)
    expect(query.isError()).toBe(true)
    expect(query.failureCount()).toBe(1)
    expect(query.failureReason()).toMatchObject({ message: 'Some error' })
  })

  test('should update query on options contained signal change', async () => {
    const key = signal(['key6', 'key7'])
    const spy = vi.fn(simpleFetcher)

    const query = TestBed.runInInjectionContext(() => {
      return injectQuery(() => ({
        queryKey: key(),
        queryFn: spy,
      }))
    })

    await resolveQueries()

    expect(spy).toHaveBeenCalledTimes(1)

    expect(query.status()).toBe('success')

    key.set(['key8'])
    TestBed.flushEffects()

    expect(spy).toHaveBeenCalledTimes(2)
    // should call queryFn with context containing the new queryKey
    expect(spy).toBeCalledWith({
      client: queryClient,
      meta: undefined,
      queryKey: ['key8'],
      signal: expect.anything(),
    })
  })

  test('should only run query once enabled signal is set to true', async () => {
    const spy = vi.fn(simpleFetcher)
    const enabled = signal(false)

    const query = TestBed.runInInjectionContext(() => {
      return injectQuery(() => ({
        queryKey: ['key9'],
        queryFn: spy,
        enabled: enabled(),
      }))
    })

    expect(spy).not.toHaveBeenCalled()
    expect(query.status()).toBe('pending')

    enabled.set(true)
    await resolveQueries()
    expect(spy).toHaveBeenCalledTimes(1)
    expect(query.status()).toBe('success')
  })

  test('should properly execute dependant queries', async () => {
    const query1 = TestBed.runInInjectionContext(() => {
      return injectQuery(() => ({
        queryKey: ['dependant1'],
        queryFn: simpleFetcher,
      }))
    })

    const dependentQueryFn = vi.fn().mockImplementation(delayedFetcher(1000))

    const query2 = TestBed.runInInjectionContext(() => {
      return injectQuery(
        computed(() => ({
          queryKey: ['dependant2'],
          queryFn: dependentQueryFn,
          enabled: !!query1.data(),
        })),
      )
    })

    expect(query1.data()).toStrictEqual(undefined)
    expect(query2.fetchStatus()).toStrictEqual('idle')
    expect(dependentQueryFn).not.toHaveBeenCalled()

    await resolveQueries()

    expect(query1.data()).toStrictEqual('Some data')
    expect(query2.fetchStatus()).toStrictEqual('fetching')

    await vi.runAllTimersAsync()

    expect(query2.fetchStatus()).toStrictEqual('idle')
    expect(query2.status()).toStrictEqual('success')
    expect(dependentQueryFn).toHaveBeenCalledTimes(1)
    expect(dependentQueryFn).toHaveBeenCalledWith(
      expect.objectContaining({ queryKey: ['dependant2'] }),
    )
  })

  test('should use the current value for the queryKey when refetch is called', async () => {
    const fetchFn = vi.fn(simpleFetcher)
    const keySignal = signal('key11')

    const query = TestBed.runInInjectionContext(() => {
      return injectQuery(() => ({
        queryKey: ['key10', keySignal()],
        queryFn: fetchFn,
        enabled: false,
      }))
    })

    expect(fetchFn).not.toHaveBeenCalled()

    query.refetch().then(() => {
      expect(fetchFn).toHaveBeenCalledTimes(1)
      expect(fetchFn).toHaveBeenCalledWith(
        expect.objectContaining({
          queryKey: ['key10', 'key11'],
        }),
      )
    })

    await resolveQueries()

    keySignal.set('key12')

    TestBed.flushEffects()

    query.refetch().then(() => {
      expect(fetchFn).toHaveBeenCalledTimes(2)
      expect(fetchFn).toHaveBeenCalledWith(
        expect.objectContaining({
          queryKey: ['key10', 'key12'],
        }),
      )
    })

    await resolveQueries()
  })

  describe('throwOnError', () => {
    test('should evaluate throwOnError when query is expected to throw', async () => {
      const boundaryFn = vi.fn()
      TestBed.runInInjectionContext(() => {
        return injectQuery(() => ({
          queryKey: ['key12'],
          queryFn: rejectFetcher,
          throwOnError: boundaryFn,
        }))
      })

      await vi.runAllTimersAsync()

      expect(boundaryFn).toHaveBeenCalledTimes(1)
      expect(boundaryFn).toHaveBeenCalledWith(
        Error('Some error'),
        expect.objectContaining({
          state: expect.objectContaining({ status: 'error' }),
        }),
      )
    })

    test('should throw when throwOnError is true', async () => {
      TestBed.runInInjectionContext(() => {
        return injectQuery(() => ({
          queryKey: ['key13'],
          queryFn: rejectFetcher,
          throwOnError: true,
        }))
      })

      await expect(vi.runAllTimersAsync()).rejects.toThrow('Some error')
    })

    test('should throw when throwOnError function returns true', async () => {
      TestBed.runInInjectionContext(() => {
        return injectQuery(() => ({
          queryKey: ['key14'],
          queryFn: rejectFetcher,
          throwOnError: () => true,
        }))
      })

      await expect(vi.runAllTimersAsync()).rejects.toThrow('Some error')
    })
  })

  test('should set state to error when queryFn returns reject promise', async () => {
    const query = TestBed.runInInjectionContext(() => {
      return injectQuery(() => ({
        retry: false,
        queryKey: ['key15'],
        queryFn: rejectFetcher,
      }))
    })

    expect(query.status()).toBe('pending')

    await resolveQueries()

    expect(query.status()).toBe('error')
  })

  test('should render with required signal inputs', async () => {
    @Component({
      selector: 'app-fake',
      template: `{{ query.data() }}`,
      standalone: true,
    })
    class FakeComponent {
      name = input.required<string>()

      query = injectQuery(() => ({
        queryKey: ['fake', this.name()],
        queryFn: () => this.name(),
      }))
    }

    const fixture = TestBed.createComponent(FakeComponent)
    setSignalInputs(fixture.componentInstance, {
      name: 'signal-input-required-test',
    })

    fixture.detectChanges()
    await resolveQueries()

    expect(fixture.componentInstance.query.data()).toEqual(
      'signal-input-required-test',
    )
  })

  test('should run optionsFn in injection context', async () => {
    @Injectable()
    class FakeService {
      getData(name: string) {
        return Promise.resolve(name)
      }
    }

    @Component({
      selector: 'app-fake',
      template: `{{ query.data() }}`,
      standalone: true,
      providers: [FakeService],
    })
    class FakeComponent {
      name = signal<string>('test name')

      query = injectQuery(() => {
        const service = inject(FakeService)

        return {
          queryKey: ['fake', this.name()],
          queryFn: () => {
            return service.getData(this.name())
          },
        }
      })
    }

    const fixture = TestBed.createComponent(FakeComponent)
    fixture.detectChanges()
    await resolveQueries()

    expect(fixture.componentInstance.query.data()).toEqual('test name')

    fixture.componentInstance.name.set('test name 2')
    fixture.detectChanges()
    await resolveQueries()

    expect(fixture.componentInstance.query.data()).toEqual('test name 2')
  })

  test('should run optionsFn in injection context and allow passing injector to queryFn', async () => {
    @Injectable()
    class FakeService {
      getData(name: string) {
        return Promise.resolve(name)
      }
    }

    @Component({
      selector: 'app-fake',
      template: `{{ query.data() }}`,
      standalone: true,
      providers: [FakeService],
    })
    class FakeComponent {
      name = signal<string>('test name')

      query = injectQuery(() => {
        const injector = inject(Injector)

        return {
          queryKey: ['fake', this.name()],
          queryFn: () => {
            const service = injector.get(FakeService)
            return service.getData(this.name())
          },
        }
      })
    }

    const fixture = TestBed.createComponent(FakeComponent)
    fixture.detectChanges()
    await resolveQueries()

    expect(fixture.componentInstance.query.data()).toEqual('test name')

    fixture.componentInstance.name.set('test name 2')
    fixture.detectChanges()
    await resolveQueries()

    expect(fixture.componentInstance.query.data()).toEqual('test name 2')
  })

  describe('injection context', () => {
    test('throws NG0203 with descriptive error outside injection context', () => {
      expect(() => {
        injectQuery(() => ({
          queryKey: ['injectionContextError'],
          queryFn: simpleFetcher,
        }))
      }).toThrowError(/NG0203(.*?)injectQuery/)
    })

    test('can be used outside injection context when passing an injector', () => {
      const query = injectQuery(
        () => ({
          queryKey: ['manualInjector'],
          queryFn: simpleFetcher,
        }),
        TestBed.inject(Injector),
      )

      expect(query.status()).toBe('pending')
    })
  })
})



# ./src/__tests__/test-utils.ts

import { isSignal, untracked } from '@angular/core'
import { SIGNAL, signalSetFn } from '@angular/core/primitives/signals'
import type { InputSignal, Signal } from '@angular/core'
import type { ComponentFixture } from '@angular/core/testing'

let queryKeyCount = 0
export function queryKey() {
  queryKeyCount++
  return [`query_${queryKeyCount}`]
}

export function simpleFetcher(): Promise<string> {
  return new Promise((resolve) => {
    setTimeout(() => {
      return resolve('Some data')
    }, 0)
  })
}

export function delayedFetcher(timeout = 0): () => Promise<string> {
  return () =>
    new Promise((resolve) => {
      setTimeout(() => {
        return resolve('Some data')
      }, timeout)
    })
}

export function getSimpleFetcherWithReturnData(returnData: unknown) {
  return () =>
    new Promise((resolve) => setTimeout(() => resolve(returnData), 0))
}

export function rejectFetcher(): Promise<Error> {
  return new Promise((_, reject) => {
    setTimeout(() => {
      return reject(new Error('Some error'))
    }, 0)
  })
}

export function infiniteFetcher({
  pageParam,
}: {
  pageParam?: number
}): Promise<string> {
  return new Promise((resolve) => {
    setTimeout(() => {
      return resolve('data on page ' + pageParam)
    }, 0)
  })
}

export function successMutator<T>(param: T): Promise<T> {
  return new Promise((resolve) => {
    setTimeout(() => {
      return resolve(param)
    }, 0)
  })
}

export function errorMutator(_parameter?: unknown): Promise<Error> {
  return rejectFetcher()
}

// Evaluate all signals on an object and return the result
function evaluateSignals<T extends Record<string, any>>(
  obj: T,
): { [K in keyof T]: ReturnType<T[K]> } {
  const result: Partial<{ [K in keyof T]: ReturnType<T[K]> }> = {}

  untracked(() => {
    for (const key in obj) {
      if (
        Object.prototype.hasOwnProperty.call(obj, key) &&
        // Only evaluate signals, not normal functions
        isSignal(obj[key])
      ) {
        const func = obj[key]
        result[key] = func()
      }
    }
  })

  return result as { [K in keyof T]: ReturnType<T[K]> }
}

export const expectSignals = <T extends Record<string, any>>(
  obj: T,
  expected: Partial<{
    [K in keyof T]: T[K] extends Signal<any> ? ReturnType<T[K]> : never
  }>,
): void => {
  expect(evaluateSignals(obj)).toMatchObject(expected)
}

type ToSignalInputUpdatableMap<T> = {
  [K in keyof T as T[K] extends InputSignal<any>
    ? K
    : never]: T[K] extends InputSignal<infer Value> ? Value : never
}

function componentHasSignalInputProperty<TProperty extends string>(
  component: object,
  property: TProperty,
): component is { [key in TProperty]: InputSignal<unknown> } {
  return (
    component.hasOwnProperty(property) && (component as any)[property][SIGNAL]
  )
}

/**
 * Set required signal input value to component fixture
 * @see https://github.com/angular/angular/issues/54013
 */
export function setSignalInputs<T extends NonNullable<unknown>>(
  component: T,
  inputs: ToSignalInputUpdatableMap<T>,
) {
  for (const inputKey in inputs) {
    if (componentHasSignalInputProperty(component, inputKey)) {
      signalSetFn(component[inputKey][SIGNAL], inputs[inputKey])
    }
  }
}

export function setFixtureSignalInputs<T extends NonNullable<unknown>>(
  componentFixture: ComponentFixture<T>,
  inputs: ToSignalInputUpdatableMap<T>,
  options: { detectChanges: boolean } = { detectChanges: true },
) {
  setSignalInputs(componentFixture.componentInstance, inputs)
  if (options.detectChanges) {
    componentFixture.detectChanges()
  }
}



# ./src/__tests__/query-options.test-d.ts

import { assertType, describe, expectTypeOf } from 'vitest'
import { QueryClient, dataTagSymbol, injectQuery, queryOptions } from '..'
import type { Signal } from '@angular/core'

describe('queryOptions', () => {
  test('should not allow excess properties', () => {
    return queryOptions({
      queryKey: ['key'],
      queryFn: () => Promise.resolve(5),
      // @ts-expect-error this is a good error, because stallTime does not exist!
      stallTime: 1000,
    })
  })

  test('should infer types for callbacks', () => {
    return queryOptions({
      queryKey: ['key'],
      queryFn: () => Promise.resolve(5),
      staleTime: 1000,
      select: (data) => {
        expectTypeOf(data).toEqualTypeOf<number>()
      },
    })
  })

  test('should allow undefined response in initialData', () => {
    return (id: string | null) =>
      queryOptions({
        queryKey: ['todo', id],
        queryFn: () =>
          Promise.resolve({
            id: '1',
            title: 'Do Laundry',
          }),
        initialData: () =>
          !id
            ? undefined
            : {
                id,
                title: 'Initial Data',
              },
      })
  })
})

test('should work when passed to injectQuery', () => {
  const options = queryOptions({
    queryKey: ['key'],
    queryFn: () => Promise.resolve(5),
  })

  const { data } = injectQuery(() => options)
  expectTypeOf(data).toEqualTypeOf<Signal<number | undefined>>()
})

test('should work when passed to fetchQuery', () => {
  const options = queryOptions({
    queryKey: ['key'],
    queryFn: () => Promise.resolve(5),
  })

  const data = new QueryClient().fetchQuery(options)
  assertType<Promise<number>>(data)
})

test('should tag the queryKey with the result type of the QueryFn', () => {
  const { queryKey } = queryOptions({
    queryKey: ['key'],
    queryFn: () => Promise.resolve(5),
  })
  assertType<number>(queryKey[dataTagSymbol])
})

test('should tag the queryKey even if no promise is returned', () => {
  const { queryKey } = queryOptions({
    queryKey: ['key'],
    queryFn: () => 5,
  })
  assertType<number>(queryKey[dataTagSymbol])
})

test('should tag the queryKey with unknown if there is no queryFn', () => {
  const { queryKey } = queryOptions({
    queryKey: ['key'],
  })

  assertType<unknown>(queryKey[dataTagSymbol])
})

test('should tag the queryKey with the result type of the QueryFn if select is used', () => {
  const { queryKey } = queryOptions({
    queryKey: ['key'],
    queryFn: () => Promise.resolve(5),
    select: (data) => data.toString(),
  })

  assertType<number>(queryKey[dataTagSymbol])
})

test('should return the proper type when passed to getQueryData', () => {
  const { queryKey } = queryOptions({
    queryKey: ['key'],
    queryFn: () => Promise.resolve(5),
  })

  const queryClient = new QueryClient()
  const data = queryClient.getQueryData(queryKey)

  expectTypeOf(data).toEqualTypeOf<number | undefined>()
})

test('should properly type updaterFn when passed to setQueryData', () => {
  const { queryKey } = queryOptions({
    queryKey: ['key'],
    queryFn: () => Promise.resolve(5),
  })

  const queryClient = new QueryClient()
  const data = queryClient.setQueryData(queryKey, (prev) => {
    expectTypeOf(prev).toEqualTypeOf<number | undefined>()
    return prev
  })

  expectTypeOf(data).toEqualTypeOf<number | undefined>()
})

test('should properly type value when passed to setQueryData', () => {
  const { queryKey } = queryOptions({
    queryKey: ['key'],
    queryFn: () => Promise.resolve(5),
  })

  const queryClient = new QueryClient()

  // @ts-expect-error value should be a number
  queryClient.setQueryData(queryKey, '5')
  // @ts-expect-error value should be a number
  queryClient.setQueryData(queryKey, () => '5')

  const data = queryClient.setQueryData(queryKey, 5)

  expectTypeOf(data).toEqualTypeOf<number | undefined>()
})



# ./src/__tests__/providers.test.ts

import { beforeEach, describe, expect, test, vi } from 'vitest'
import { QueryClient } from '@tanstack/query-core'
import { TestBed } from '@angular/core/testing'
import {
  ENVIRONMENT_INITIALIZER,
  provideExperimentalZonelessChangeDetection,
  signal,
} from '@angular/core'
import { isDevMode } from '../util/is-dev-mode/is-dev-mode'
import { provideTanStackQuery, withDevtools } from '../providers'
import type { DevtoolsOptions } from '../providers'
import type { Mock } from 'vitest'
import type {
  DevtoolsButtonPosition,
  DevtoolsErrorType,
  DevtoolsPosition,
} from '@tanstack/query-devtools'

vi.mock('../util/is-dev-mode/is-dev-mode', () => ({
  isDevMode: vi.fn(),
}))

const mockDevtoolsInstance = {
  mount: vi.fn(),
  unmount: vi.fn(),
  setClient: vi.fn(),
  setPosition: vi.fn(),
  setErrorTypes: vi.fn(),
  setButtonPosition: vi.fn(),
  setInitialIsOpen: vi.fn(),
}

const mockTanstackQueryDevtools = vi.fn(() => mockDevtoolsInstance)

vi.mock('@tanstack/query-devtools', () => ({
  TanstackQueryDevtools: mockTanstackQueryDevtools,
}))

describe('withDevtools feature', () => {
  let isDevModeMock: Mock

  beforeEach(() => {
    vi.useFakeTimers()
    isDevModeMock = isDevMode as Mock
  })

  afterEach(() => {
    vi.restoreAllMocks()
  })

  test.each([
    {
      description:
        'should provide developer tools in development mode by default',
      isDevModeValue: true,
      expectedCalled: true,
    },
    {
      description:
        'should not provide developer tools in production mode by default',
      isDevModeValue: false,
      expectedCalled: false,
    },
    {
      description: `should provide developer tools in development mode when 'loadDeveloperTools' is set to 'auto'`,
      isDevModeValue: true,
      loadDevtools: 'auto',
      expectedCalled: true,
    },
    {
      description: `should not provide developer tools in production mode when 'loadDeveloperTools' is set to 'auto'`,
      isDevModeValue: false,
      loadDevtools: 'auto',
      expectedCalled: false,
    },
    {
      description:
        "should provide developer tools in development mode when 'loadDevtools' is set to true",
      isDevModeValue: true,
      loadDevtools: true,
      expectedCalled: true,
    },
    {
      description:
        "should provide developer tools in production mode when 'loadDevtools' is set to true",
      isDevModeValue: false,
      loadDevtools: true,
      expectedCalled: true,
    },
    {
      description:
        "should not provide developer tools in development mode when 'loadDevtools' is set to false",
      isDevModeValue: true,
      loadDevtools: false,
      expectedCalled: false,
    },
    {
      description:
        "should not provide developer tools in production mode when 'loadDevtools' is set to false",
      isDevModeValue: false,
      loadDevtools: false,
      expectedCalled: false,
    },
  ])(
    '$description',
    async ({ isDevModeValue, loadDevtools, expectedCalled }) => {
      isDevModeMock.mockReturnValue(isDevModeValue)

      const providers = [
        provideExperimentalZonelessChangeDetection(),
        provideTanStackQuery(
          new QueryClient(),
          loadDevtools !== undefined
            ? withDevtools(
                () =>
                  ({
                    loadDevtools,
                  }) as DevtoolsOptions,
              )
            : withDevtools(),
        ),
      ]

      TestBed.configureTestingModule({
        providers,
      })

      TestBed.inject(ENVIRONMENT_INITIALIZER)
      await vi.runAllTimersAsync()

      if (expectedCalled) {
        expect(mockTanstackQueryDevtools).toHaveBeenCalled()
      } else {
        expect(mockTanstackQueryDevtools).not.toHaveBeenCalled()
      }
    },
  )

  it('should update error types', async () => {
    const errorTypes = signal([] as Array<DevtoolsErrorType>)

    TestBed.configureTestingModule({
      providers: [
        provideExperimentalZonelessChangeDetection(),
        provideTanStackQuery(
          new QueryClient(),
          withDevtools(() => ({
            loadDevtools: true,
            errorTypes: errorTypes(),
          })),
        ),
      ],
    })

    TestBed.inject(ENVIRONMENT_INITIALIZER)
    await vi.runAllTimersAsync()

    TestBed.flushEffects()

    expect(mockDevtoolsInstance.setErrorTypes).toHaveBeenCalledTimes(0)

    errorTypes.set([
      {
        name: '',
        initializer: () => new Error(),
      },
    ])

    TestBed.flushEffects()

    expect(mockDevtoolsInstance.setErrorTypes).toHaveBeenCalledTimes(1)
  })

  it('should update client', async () => {
    const client = signal(new QueryClient())

    TestBed.configureTestingModule({
      providers: [
        provideExperimentalZonelessChangeDetection(),
        provideTanStackQuery(
          new QueryClient(),
          withDevtools(() => ({
            loadDevtools: true,
            client: client(),
          })),
        ),
      ],
    })

    TestBed.inject(ENVIRONMENT_INITIALIZER)
    await vi.runAllTimersAsync()

    TestBed.flushEffects()

    expect(mockDevtoolsInstance.setClient).toHaveBeenCalledTimes(0)

    client.set(new QueryClient())

    TestBed.flushEffects()

    expect(mockDevtoolsInstance.setClient).toHaveBeenCalledTimes(1)
  })

  it('should update position', async () => {
    const position = signal<DevtoolsPosition>('top')

    TestBed.configureTestingModule({
      providers: [
        provideExperimentalZonelessChangeDetection(),
        provideTanStackQuery(
          new QueryClient(),
          withDevtools(() => ({
            loadDevtools: true,
            position: position(),
          })),
        ),
      ],
    })

    TestBed.inject(ENVIRONMENT_INITIALIZER)
    await vi.runAllTimersAsync()

    TestBed.flushEffects()

    expect(mockDevtoolsInstance.setPosition).toHaveBeenCalledTimes(0)

    position.set('left')

    TestBed.flushEffects()

    expect(mockDevtoolsInstance.setPosition).toHaveBeenCalledTimes(1)
  })

  it('should update button position', async () => {
    const buttonPosition = signal<DevtoolsButtonPosition>('bottom-left')

    TestBed.configureTestingModule({
      providers: [
        provideExperimentalZonelessChangeDetection(),
        provideTanStackQuery(
          new QueryClient(),
          withDevtools(() => ({
            loadDevtools: true,
            buttonPosition: buttonPosition(),
          })),
        ),
      ],
    })

    TestBed.inject(ENVIRONMENT_INITIALIZER)
    await vi.runAllTimersAsync()

    TestBed.flushEffects()

    expect(mockDevtoolsInstance.setButtonPosition).toHaveBeenCalledTimes(0)

    buttonPosition.set('bottom-right')

    TestBed.flushEffects()

    expect(mockDevtoolsInstance.setButtonPosition).toHaveBeenCalledTimes(1)
  })

  it('should update initialIsOpen', async () => {
    const initialIsOpen = signal(false)

    TestBed.configureTestingModule({
      providers: [
        provideExperimentalZonelessChangeDetection(),
        provideTanStackQuery(
          new QueryClient(),
          withDevtools(() => ({
            loadDevtools: true,
            initialIsOpen: initialIsOpen(),
          })),
        ),
      ],
    })

    TestBed.inject(ENVIRONMENT_INITIALIZER)
    await vi.runAllTimersAsync()

    TestBed.flushEffects()

    expect(mockDevtoolsInstance.setInitialIsOpen).toHaveBeenCalledTimes(0)

    initialIsOpen.set(true)

    TestBed.flushEffects()

    expect(mockDevtoolsInstance.setInitialIsOpen).toHaveBeenCalledTimes(1)
  })

  it('should destroy devtools', async () => {
    const loadDevtools = signal(true)

    TestBed.configureTestingModule({
      providers: [
        provideExperimentalZonelessChangeDetection(),
        provideTanStackQuery(
          new QueryClient(),
          withDevtools(() => ({
            loadDevtools: loadDevtools(),
          })),
        ),
      ],
    })

    TestBed.inject(ENVIRONMENT_INITIALIZER)
    await vi.runAllTimersAsync()

    expect(mockDevtoolsInstance.mount).toHaveBeenCalledTimes(1)
    expect(mockDevtoolsInstance.unmount).toHaveBeenCalledTimes(0)

    loadDevtools.set(false)

    TestBed.flushEffects()

    expect(mockDevtoolsInstance.unmount).toHaveBeenCalledTimes(1)
  })
})



# ./src/__tests__/signal-proxy.test.ts

import { isSignal, signal } from '@angular/core'
import { describe } from 'vitest'
import { signalProxy } from '../signal-proxy'

describe('signalProxy', () => {
  const inputSignal = signal({ fn: () => 'bar', baz: 'qux' })
  const proxy = signalProxy(inputSignal)

  test('should have computed fields', () => {
    expect(proxy.baz()).toEqual('qux')
    expect(isSignal(proxy.baz)).toBe(true)
  })

  test('should pass through functions as-is', () => {
    expect(proxy.fn()).toEqual('bar')
    expect(isSignal(proxy.fn)).toBe(false)
  })

  test('supports "in" operator', () => {
    expect('baz' in proxy).toBe(true)
    expect('foo' in proxy).toBe(false)
  })

  test('supports "Object.keys"', () => {
    expect(Object.keys(proxy)).toEqual(['fn', 'baz'])
  })
})



# ./src/__tests__/inject-query.test-d.ts

import { describe, expectTypeOf, it } from 'vitest'
import { injectQuery, queryOptions } from '..'
import { simpleFetcher } from './test-utils'
import type { Signal } from '@angular/core'

describe('initialData', () => {
  describe('Config object overload', () => {
    it('TData should always be defined when initialData is provided as an object', () => {
      const { data } = injectQuery(() => ({
        queryKey: ['key'],
        queryFn: () => ({ wow: true }),
        initialData: { wow: true },
      }))

      expectTypeOf(data).toEqualTypeOf<Signal<{ wow: boolean }>>()
    })

    it('TData should be defined when passed through queryOptions', () => {
      const options = () =>
        queryOptions({
          queryKey: ['key'],
          queryFn: () => {
            return {
              wow: true,
            }
          },
          initialData: {
            wow: true,
          },
        })
      const { data } = injectQuery(options)

      expectTypeOf(data).toEqualTypeOf<Signal<{ wow: boolean }>>()
    })

    it('should be possible to define a different TData than TQueryFnData using select with queryOptions spread into useQuery', () => {
      const options = queryOptions({
        queryKey: ['key'],
        queryFn: () => Promise.resolve(1),
      })

      const query = injectQuery(() => ({
        ...options,
        select: (data) => data > 1,
      }))

      expectTypeOf(query.data).toEqualTypeOf<Signal<boolean | undefined>>()
    })

    it('TData should always be defined when initialData is provided as a function which ALWAYS returns the data', () => {
      const { data } = injectQuery(() => ({
        queryKey: ['key'],
        queryFn: () => {
          return {
            wow: true,
          }
        },
        initialData: () => ({
          wow: true,
        }),
      }))

      expectTypeOf(data).toEqualTypeOf<Signal<{ wow: boolean }>>()
    })

    it('TData should have undefined in the union when initialData is NOT provided', () => {
      const { data } = injectQuery(() => ({
        queryKey: ['key'],
        queryFn: () => {
          return {
            wow: true,
          }
        },
      }))

      expectTypeOf(data).toEqualTypeOf<Signal<{ wow: boolean } | undefined>>()
    })

    it('TData should have undefined in the union when initialData is provided as a function which can return undefined', () => {
      const { data } = injectQuery(() => ({
        queryKey: ['key'],
        queryFn: () => {
          return {
            wow: true,
          }
        },
        initialData: () => undefined as { wow: boolean } | undefined,
      }))

      expectTypeOf(data).toEqualTypeOf<Signal<{ wow: boolean } | undefined>>()
    })

    it('TData should be narrowed after an isSuccess check when initialData is provided as a function which can return undefined', () => {
      const query = injectQuery(() => ({
        queryKey: ['key'],
        queryFn: () => {
          return {
            wow: true,
          }
        },
        initialData: () => undefined as { wow: boolean } | undefined,
      }))

      if (query.isSuccess()) {
        expectTypeOf(query.data).toEqualTypeOf<Signal<{ wow: boolean }>>()
      }
    })
  })

  describe('structuralSharing', () => {
    it('should restrict to same types', () => {
      injectQuery(() => ({
        queryKey: ['key'],
        queryFn: () => 5,
        structuralSharing: (_oldData, newData) => {
          return newData
        },
      }))
    })
  })
})

describe('Discriminated union return type', () => {
  test('data should be possibly undefined by default', () => {
    const query = injectQuery(() => ({
      queryKey: ['key'],
      queryFn: simpleFetcher,
    }))

    expectTypeOf(query.data).toEqualTypeOf<Signal<string | undefined>>()
  })

  test('data should be defined when query is success', () => {
    const query = injectQuery(() => ({
      queryKey: ['key'],
      queryFn: simpleFetcher,
    }))

    if (query.isSuccess()) {
      expectTypeOf(query.data).toEqualTypeOf<Signal<string>>()
    }
  })

  test('error should be null when query is success', () => {
    const query = injectQuery(() => ({
      queryKey: ['key'],
      queryFn: simpleFetcher,
    }))

    if (query.isSuccess()) {
      expectTypeOf(query.error).toEqualTypeOf<Signal<null>>()
    }
  })

  test('data should be undefined when query is pending', () => {
    const query = injectQuery(() => ({
      queryKey: ['key'],
      queryFn: simpleFetcher,
    }))

    if (query.isPending()) {
      expectTypeOf(query.data).toEqualTypeOf<Signal<undefined>>()
    }
  })

  test('error should be defined when query is error', () => {
    const query = injectQuery(() => ({
      queryKey: ['key'],
      queryFn: simpleFetcher,
    }))

    if (query.isError()) {
      expectTypeOf(query.error).toEqualTypeOf<Signal<Error>>()
    }
  })
})



# ./src/__tests__/inject-mutation.test-d.ts

import { describe, expectTypeOf } from 'vitest'
import { injectMutation } from '..'
import { successMutator } from './test-utils'
import type { Signal } from '@angular/core'

describe('Discriminated union return type', () => {
  test('data should be possibly undefined by default', () => {
    const mutation = injectMutation(() => ({
      mutationFn: successMutator<string>,
    }))

    expectTypeOf(mutation.data).toEqualTypeOf<Signal<string | undefined>>()
  })

  test('data should be defined when mutation is success', () => {
    const mutation = injectMutation(() => ({
      mutationFn: successMutator<string>,
    }))

    if (mutation.isSuccess()) {
      expectTypeOf(mutation.data).toEqualTypeOf<Signal<string>>()
    }
  })

  test('error should be null when mutation is success', () => {
    const mutation = injectMutation(() => ({
      mutationFn: successMutator<string>,
    }))

    if (mutation.isSuccess()) {
      expectTypeOf(mutation.error).toEqualTypeOf<Signal<null>>()
    }
  })

  test('data should be undefined when mutation is pending', () => {
    const mutation = injectMutation(() => ({
      mutationFn: successMutator<string>,
    }))

    if (mutation.isPending()) {
      expectTypeOf(mutation.data).toEqualTypeOf<Signal<undefined>>()
    }
  })

  test('error should be defined when mutation is error', () => {
    const mutation = injectMutation(() => ({
      mutationFn: successMutator<string>,
    }))

    if (mutation.isError()) {
      expectTypeOf(mutation.error).toEqualTypeOf<Signal<Error>>()
    }
  })

  test('should narrow variables', () => {
    const mutation = injectMutation(() => ({
      mutationFn: successMutator<string>,
    }))

    if (mutation.isIdle()) {
      expectTypeOf(mutation.variables).toEqualTypeOf<Signal<undefined>>()
    }
    if (mutation.isPending()) {
      expectTypeOf(mutation.variables).toEqualTypeOf<Signal<string>>()
    }
    if (mutation.isSuccess()) {
      expectTypeOf(mutation.variables).toEqualTypeOf<Signal<string>>()
    }
    expectTypeOf(mutation.variables).toEqualTypeOf<Signal<string | undefined>>()
  })
})



# ./src/__tests__/inject-is-fetching.test.ts

import { TestBed } from '@angular/core/testing'
import { beforeEach, describe, expect } from 'vitest'
import {
  Injector,
  provideExperimentalZonelessChangeDetection,
} from '@angular/core'
import {
  QueryClient,
  injectIsFetching,
  injectQuery,
  provideTanStackQuery,
} from '..'
import { delayedFetcher } from './test-utils'

const QUERY_DURATION = 100

const resolveQueries = () => vi.advanceTimersByTimeAsync(QUERY_DURATION)

describe('injectIsFetching', () => {
  let queryClient: QueryClient

  beforeEach(() => {
    vi.useFakeTimers()
    queryClient = new QueryClient()

    TestBed.configureTestingModule({
      providers: [
        provideExperimentalZonelessChangeDetection(),
        provideTanStackQuery(queryClient),
      ],
    })
  })

  afterEach(() => {
    vi.useRealTimers()
  })

  test('Returns number of fetching queries', async () => {
    const isFetching = TestBed.runInInjectionContext(() => {
      injectQuery(() => ({
        queryKey: ['isFetching1'],
        queryFn: delayedFetcher(100),
      }))
      return injectIsFetching()
    })

    vi.advanceTimersByTime(1)

    expect(isFetching()).toStrictEqual(1)
    await resolveQueries()
    expect(isFetching()).toStrictEqual(0)
  })

  describe('injection context', () => {
    test('throws NG0203 with descriptive error outside injection context', () => {
      expect(() => {
        injectIsFetching()
      }).toThrowError(/NG0203(.*?)injectIsFetching/)
    })

    test('can be used outside injection context when passing an injector', () => {
      expect(
        injectIsFetching(undefined, TestBed.inject(Injector)),
      ).not.toThrow()
    })
  })
})



# ./src/__tests__/inject-infinite-query.test.ts

import { TestBed } from '@angular/core/testing'
import { afterEach } from 'vitest'
import {
  Injector,
  provideExperimentalZonelessChangeDetection,
} from '@angular/core'
import { QueryClient, injectInfiniteQuery, provideTanStackQuery } from '..'
import { expectSignals, infiniteFetcher } from './test-utils'

const QUERY_DURATION = 1000

const resolveQueries = () => vi.advanceTimersByTimeAsync(QUERY_DURATION)

describe('injectInfiniteQuery', () => {
  let queryClient: QueryClient

  beforeEach(() => {
    queryClient = new QueryClient()
    vi.useFakeTimers()
    TestBed.configureTestingModule({
      providers: [
        provideExperimentalZonelessChangeDetection(),
        provideTanStackQuery(queryClient),
      ],
    })
  })

  afterEach(() => {
    vi.useRealTimers()
  })

  test('should properly execute infinite query', async () => {
    const query = TestBed.runInInjectionContext(() => {
      return injectInfiniteQuery(() => ({
        queryKey: ['infiniteQuery'],
        queryFn: infiniteFetcher,
        initialPageParam: 0,
        getNextPageParam: () => 12,
      }))
    })

    expectSignals(query, {
      data: undefined,
      status: 'pending',
    })

    await resolveQueries()

    expectSignals(query, {
      data: {
        pageParams: [0],
        pages: ['data on page 0'],
      },
      status: 'success',
    })

    void query.fetchNextPage()

    await resolveQueries()

    expectSignals(query, {
      data: {
        pageParams: [0, 12],
        pages: ['data on page 0', 'data on page 12'],
      },
      status: 'success',
    })
  })

  describe('injection context', () => {
    test('throws NG0203 with descriptive error outside injection context', () => {
      expect(() => {
        injectInfiniteQuery(() => ({
          queryKey: ['injectionContextError'],
          queryFn: infiniteFetcher,
          initialPageParam: 0,
          getNextPageParam: () => 12,
        }))
      }).toThrowError(/NG0203(.*?)injectInfiniteQuery/)
    })

    test('can be used outside injection context when passing an injector', () => {
      const query = injectInfiniteQuery(
        () => ({
          queryKey: ['manualInjector'],
          queryFn: infiniteFetcher,
          initialPageParam: 0,
          getNextPageParam: () => 12,
        }),
        TestBed.inject(Injector),
      )

      expect(query.status()).toBe('pending')
    })
  })
})



# ./src/__tests__/inject-is-mutating.test.ts

import { beforeEach, describe } from 'vitest'
import { TestBed } from '@angular/core/testing'
import {
  Injector,
  provideExperimentalZonelessChangeDetection,
} from '@angular/core'
import {
  QueryClient,
  injectIsMutating,
  injectMutation,
  provideTanStackQuery,
} from '..'
import { successMutator } from './test-utils'

describe('injectIsMutating', () => {
  let queryClient: QueryClient

  beforeEach(() => {
    vi.useFakeTimers()
    queryClient = new QueryClient()

    TestBed.configureTestingModule({
      providers: [
        provideExperimentalZonelessChangeDetection(),
        provideTanStackQuery(queryClient),
      ],
    })
  })

  afterEach(() => {
    vi.useRealTimers()
  })

  test('should properly return isMutating state', async () => {
    TestBed.runInInjectionContext(() => {
      const isMutating = injectIsMutating()
      const mutation = injectMutation(() => ({
        mutationKey: ['isMutating1'],
        mutationFn: successMutator<{ par1: string }>,
      }))

      expect(isMutating()).toBe(0)

      mutation.mutate({
        par1: 'par1',
      })

      vi.advanceTimersByTime(1)

      expect(isMutating()).toBe(1)
    })
  })

  describe('injection context', () => {
    test('throws NG0203 with descriptive error outside injection context', () => {
      expect(() => {
        injectIsMutating()
      }).toThrowError(/NG0203(.*?)injectIsMutating/)
    })

    test('can be used outside injection context when passing an injector', () => {
      expect(
        injectIsMutating(undefined, TestBed.inject(Injector)),
      ).not.toThrow()
    })
  })
})



# ./src/__tests__/inject-mutation-state.test.ts

import {
  Component,
  Injector,
  input,
  provideExperimentalZonelessChangeDetection,
  signal,
} from '@angular/core'
import { TestBed } from '@angular/core/testing'
import { describe, expect, test, vi } from 'vitest'
import { By } from '@angular/platform-browser'
import {
  QueryClient,
  injectMutation,
  injectMutationState,
  provideTanStackQuery,
} from '..'
import { setFixtureSignalInputs, successMutator } from './test-utils'

const MUTATION_DURATION = 1000

const resolveMutations = () => vi.advanceTimersByTimeAsync(MUTATION_DURATION)

describe('injectMutationState', () => {
  let queryClient: QueryClient

  beforeEach(() => {
    queryClient = new QueryClient()
    vi.useFakeTimers()
    TestBed.configureTestingModule({
      providers: [
        provideExperimentalZonelessChangeDetection(),
        provideTanStackQuery(queryClient),
      ],
    })
  })

  afterEach(() => {
    vi.useRealTimers()
  })

  describe('injectMutationState', () => {
    test('should return variables after calling mutate 1', () => {
      const mutationKey = ['mutation']
      const variables = 'foo123'

      const mutation = TestBed.runInInjectionContext(() => {
        return injectMutation(() => ({
          mutationKey: mutationKey,
          mutationFn: (params: string) => successMutator(params),
        }))
      })

      mutation.mutate(variables)

      const mutationState = TestBed.runInInjectionContext(() => {
        return injectMutationState(() => ({
          filters: { mutationKey, status: 'pending' },
          select: (m) => m.state.variables,
        }))
      })

      expect(mutationState()).toEqual([variables])
    })

    test('reactive options should update injectMutationState', () => {
      const mutationKey1 = ['mutation1']
      const mutationKey2 = ['mutation2']
      const variables1 = 'foo123'
      const variables2 = 'bar234'

      const [mutation1, mutation2] = TestBed.runInInjectionContext(() => {
        return [
          injectMutation(() => ({
            mutationKey: mutationKey1,
            mutationFn: (params: string) => successMutator(params),
          })),
          injectMutation(() => ({
            mutationKey: mutationKey2,
            mutationFn: (params: string) => successMutator(params),
          })),
        ]
      })

      mutation1.mutate(variables1)
      mutation2.mutate(variables2)

      const filterKey = signal(mutationKey1)

      const mutationState = TestBed.runInInjectionContext(() => {
        return injectMutationState(() => ({
          filters: { mutationKey: filterKey(), status: 'pending' },
          select: (m) => m.state.variables,
        }))
      })

      expect(mutationState()).toEqual([variables1])

      filterKey.set(mutationKey2)
      expect(mutationState()).toEqual([variables2])
    })

    test('should return variables after calling mutate 2', () => {
      queryClient.clear()
      const mutationKey = ['mutation']
      const variables = 'bar234'

      const mutation = TestBed.runInInjectionContext(() => {
        return injectMutation(() => ({
          mutationKey: mutationKey,
          mutationFn: (params: string) => successMutator(params),
        }))
      })

      mutation.mutate(variables)

      const mutationState = TestBed.runInInjectionContext(() => {
        return injectMutationState()
      })

      expect(mutationState()[0]?.variables).toEqual(variables)
    })

    test('should support required signal inputs', async () => {
      queryClient.clear()
      const fakeName = 'name1'
      const mutationKey1 = ['fake', fakeName]

      const mutations = TestBed.runInInjectionContext(() => {
        return [
          injectMutation(() => ({
            mutationKey: mutationKey1,
            mutationFn: () => Promise.resolve('myValue'),
          })),
          injectMutation(() => ({
            mutationKey: mutationKey1,
            mutationFn: () => Promise.reject('myValue2'),
          })),
        ]
      })

      mutations.forEach((mutation) => mutation.mutate())

      @Component({
        selector: 'app-fake',
        template: `
          @for (mutation of mutationState(); track mutation) {
            <span>{{ mutation.status }}</span>
          }
        `,
        standalone: true,
      })
      class FakeComponent {
        name = input.required<string>()

        mutationState = injectMutationState(() => ({
          filters: {
            mutationKey: ['fake', this.name()],
            exact: true,
          },
        }))
      }

      const fixture = TestBed.createComponent(FakeComponent)
      const { debugElement } = fixture
      setFixtureSignalInputs(fixture, { name: fakeName })

      let spans = debugElement
        .queryAll(By.css('span'))
        .map((span) => span.nativeNode.textContent)

      expect(spans).toEqual(['pending', 'pending'])

      await resolveMutations()
      fixture.detectChanges()

      spans = debugElement
        .queryAll(By.css('span'))
        .map((span) => span.nativeNode.textContent)

      expect(spans).toEqual(['success', 'error'])
    })

    describe('injection context', () => {
      test('throws NG0203 with descriptive error outside injection context', () => {
        expect(() => {
          injectMutationState()
        }).toThrowError(/NG0203(.*?)injectMutationState/)
      })

      test('can be used outside injection context when passing an injector', () => {
        const injector = TestBed.inject(Injector)
        expect(
          injectMutationState(undefined, {
            injector,
          }),
        ).not.toThrow()
      })
    })
  })
})



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
