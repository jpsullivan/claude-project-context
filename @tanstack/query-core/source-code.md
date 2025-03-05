# ./package.json

{
  "name": "@tanstack/query-core",
  "version": "5.67.1",
  "description": "The framework agnostic core that powers TanStack Query",
  "author": "tannerlinsley",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/TanStack/query.git",
    "directory": "packages/query-core"
  },
  "homepage": "https://tanstack.com/query",
  "funding": {
    "type": "github",
    "url": "https://github.com/sponsors/tannerlinsley"
  },
  "scripts": {
    "clean": "premove ./build ./coverage ./dist-ts",
    "compile": "tsc --build",
    "test:eslint": "eslint ./src",
    "test:types": "npm-run-all --serial test:types:*",
    "test:types:ts50": "node ../../node_modules/typescript50/lib/tsc.js --build tsconfig.legacy.json",
    "test:types:ts51": "node ../../node_modules/typescript51/lib/tsc.js --build tsconfig.legacy.json",
    "test:types:ts52": "node ../../node_modules/typescript52/lib/tsc.js --build tsconfig.legacy.json",
    "test:types:ts53": "node ../../node_modules/typescript53/lib/tsc.js --build tsconfig.legacy.json",
    "test:types:ts54": "node ../../node_modules/typescript54/lib/tsc.js --build tsconfig.legacy.json",
    "test:types:ts55": "node ../../node_modules/typescript55/lib/tsc.js --build tsconfig.legacy.json",
    "test:types:ts56": "node ../../node_modules/typescript56/lib/tsc.js --build tsconfig.legacy.json",
    "test:types:ts57": "node ../../node_modules/typescript57/lib/tsc.js --build tsconfig.legacy.json",
    "test:types:tscurrent": "tsc --build",
    "test:lib": "vitest",
    "test:lib:dev": "pnpm run test:lib --watch",
    "test:build": "publint --strict && attw --pack",
    "build": "tsup --tsconfig tsconfig.prod.json"
  },
  "type": "module",
  "types": "build/legacy/index.d.ts",
  "main": "build/legacy/index.cjs",
  "module": "build/legacy/index.js",
  "react-native": "src/index.ts",
  "exports": {
    ".": {
      "import": {
        "types": "./build/modern/index.d.ts",
        "default": "./build/modern/index.js"
      },
      "require": {
        "types": "./build/modern/index.d.cts",
        "default": "./build/modern/index.cjs"
      }
    },
    "./package.json": "./package.json"
  },
  "sideEffects": false,
  "files": [
    "build",
    "src",
    "!src/__tests__"
  ],
  "devDependencies": {
    "@testing-library/dom": "^10.4.0",
    "npm-run-all": "^4.1.5"
  }
}



# ./src/focusManager.ts

import { Subscribable } from './subscribable'
import { isServer } from './utils'

type Listener = (focused: boolean) => void

type SetupFn = (
  setFocused: (focused?: boolean) => void,
) => (() => void) | undefined

export class FocusManager extends Subscribable<Listener> {
  #focused?: boolean
  #cleanup?: () => void

  #setup: SetupFn

  constructor() {
    super()
    this.#setup = (onFocus) => {
      // addEventListener does not exist in React Native, but window does
      // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
      if (!isServer && window.addEventListener) {
        const listener = () => onFocus()
        // Listen to visibilitychange
        window.addEventListener('visibilitychange', listener, false)

        return () => {
          // Be sure to unsubscribe if a new handler is set
          window.removeEventListener('visibilitychange', listener)
        }
      }
      return
    }
  }

  protected onSubscribe(): void {
    if (!this.#cleanup) {
      this.setEventListener(this.#setup)
    }
  }

  protected onUnsubscribe() {
    if (!this.hasListeners()) {
      this.#cleanup?.()
      this.#cleanup = undefined
    }
  }

  setEventListener(setup: SetupFn): void {
    this.#setup = setup
    this.#cleanup?.()
    this.#cleanup = setup((focused) => {
      if (typeof focused === 'boolean') {
        this.setFocused(focused)
      } else {
        this.onFocus()
      }
    })
  }

  setFocused(focused?: boolean): void {
    const changed = this.#focused !== focused
    if (changed) {
      this.#focused = focused
      this.onFocus()
    }
  }

  onFocus(): void {
    const isFocused = this.isFocused()
    this.listeners.forEach((listener) => {
      listener(isFocused)
    })
  }

  isFocused(): boolean {
    if (typeof this.#focused === 'boolean') {
      return this.#focused
    }

    // document global can be unavailable in react native
    // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
    return globalThis.document?.visibilityState !== 'hidden'
  }
}

export const focusManager = new FocusManager()



# ./src/infiniteQueryObserver.ts

import { QueryObserver } from './queryObserver'
import {
  hasNextPage,
  hasPreviousPage,
  infiniteQueryBehavior,
} from './infiniteQueryBehavior'
import type { Subscribable } from './subscribable'
import type {
  DefaultError,
  DefaultedInfiniteQueryObserverOptions,
  FetchNextPageOptions,
  FetchPreviousPageOptions,
  InfiniteData,
  InfiniteQueryObserverBaseResult,
  InfiniteQueryObserverOptions,
  InfiniteQueryObserverResult,
  QueryKey,
} from './types'
import type { QueryClient } from './queryClient'
import type { NotifyOptions } from './queryObserver'
import type { Query } from './query'

type InfiniteQueryObserverListener<TData, TError> = (
  result: InfiniteQueryObserverResult<TData, TError>,
) => void

export class InfiniteQueryObserver<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = InfiniteData<TQueryFnData>,
  TQueryData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = unknown,
> extends QueryObserver<
  TQueryFnData,
  TError,
  TData,
  InfiniteData<TQueryData, TPageParam>,
  TQueryKey
> {
  // Type override
  subscribe!: Subscribable<
    InfiniteQueryObserverListener<TData, TError>
  >['subscribe']

  // Type override
  getCurrentResult!: ReplaceReturnType<
    QueryObserver<
      TQueryFnData,
      TError,
      TData,
      InfiniteData<TQueryData, TPageParam>,
      TQueryKey
    >['getCurrentResult'],
    InfiniteQueryObserverResult<TData, TError>
  >

  // Type override
  protected fetch!: ReplaceReturnType<
    QueryObserver<
      TQueryFnData,
      TError,
      TData,
      InfiniteData<TQueryData, TPageParam>,
      TQueryKey
    >['fetch'],
    Promise<InfiniteQueryObserverResult<TData, TError>>
  >

  constructor(
    client: QueryClient,
    options: InfiniteQueryObserverOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryData,
      TQueryKey,
      TPageParam
    >,
  ) {
    super(client, options)
  }

  protected bindMethods(): void {
    super.bindMethods()
    this.fetchNextPage = this.fetchNextPage.bind(this)
    this.fetchPreviousPage = this.fetchPreviousPage.bind(this)
  }

  setOptions(
    options: InfiniteQueryObserverOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryData,
      TQueryKey,
      TPageParam
    >,
    notifyOptions?: NotifyOptions,
  ): void {
    super.setOptions(
      {
        ...options,
        behavior: infiniteQueryBehavior(),
      },
      notifyOptions,
    )
  }

  getOptimisticResult(
    options: DefaultedInfiniteQueryObserverOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryData,
      TQueryKey,
      TPageParam
    >,
  ): InfiniteQueryObserverResult<TData, TError> {
    options.behavior = infiniteQueryBehavior()
    return super.getOptimisticResult(options) as InfiniteQueryObserverResult<
      TData,
      TError
    >
  }

  fetchNextPage(
    options?: FetchNextPageOptions,
  ): Promise<InfiniteQueryObserverResult<TData, TError>> {
    return this.fetch({
      ...options,
      meta: {
        fetchMore: { direction: 'forward' },
      },
    })
  }

  fetchPreviousPage(
    options?: FetchPreviousPageOptions,
  ): Promise<InfiniteQueryObserverResult<TData, TError>> {
    return this.fetch({
      ...options,
      meta: {
        fetchMore: { direction: 'backward' },
      },
    })
  }

  protected createResult(
    query: Query<
      TQueryFnData,
      TError,
      InfiniteData<TQueryData, TPageParam>,
      TQueryKey
    >,
    options: InfiniteQueryObserverOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryData,
      TQueryKey,
      TPageParam
    >,
  ): InfiniteQueryObserverResult<TData, TError> {
    const { state } = query
    const parentResult = super.createResult(query, options)

    const { isFetching, isRefetching, isError, isRefetchError } = parentResult
    const fetchDirection = state.fetchMeta?.fetchMore?.direction

    const isFetchNextPageError = isError && fetchDirection === 'forward'
    const isFetchingNextPage = isFetching && fetchDirection === 'forward'

    const isFetchPreviousPageError = isError && fetchDirection === 'backward'
    const isFetchingPreviousPage = isFetching && fetchDirection === 'backward'

    const result: InfiniteQueryObserverBaseResult<TData, TError> = {
      ...parentResult,
      fetchNextPage: this.fetchNextPage,
      fetchPreviousPage: this.fetchPreviousPage,
      hasNextPage: hasNextPage(options, state.data),
      hasPreviousPage: hasPreviousPage(options, state.data),
      isFetchNextPageError,
      isFetchingNextPage,
      isFetchPreviousPageError,
      isFetchingPreviousPage,
      isRefetchError:
        isRefetchError && !isFetchNextPageError && !isFetchPreviousPageError,
      isRefetching:
        isRefetching && !isFetchingNextPage && !isFetchingPreviousPage,
    }

    return result as InfiniteQueryObserverResult<TData, TError>
  }
}

type ReplaceReturnType<
  TFunction extends (...args: Array<any>) => unknown,
  TReturn,
> = (...args: Parameters<TFunction>) => TReturn



# ./src/queryCache.ts

import { hashQueryKeyByOptions, matchQuery } from './utils'
import { Query } from './query'
import { notifyManager } from './notifyManager'
import { Subscribable } from './subscribable'
import type { QueryFilters } from './utils'
import type { Action, QueryState } from './query'
import type {
  DefaultError,
  NotifyEvent,
  QueryKey,
  QueryOptions,
  WithRequired,
} from './types'
import type { QueryClient } from './queryClient'
import type { QueryObserver } from './queryObserver'

// TYPES

interface QueryCacheConfig {
  onError?: (
    error: DefaultError,
    query: Query<unknown, unknown, unknown>,
  ) => void
  onSuccess?: (data: unknown, query: Query<unknown, unknown, unknown>) => void
  onSettled?: (
    data: unknown | undefined,
    error: DefaultError | null,
    query: Query<unknown, unknown, unknown>,
  ) => void
}

interface NotifyEventQueryAdded extends NotifyEvent {
  type: 'added'
  query: Query<any, any, any, any>
}

interface NotifyEventQueryRemoved extends NotifyEvent {
  type: 'removed'
  query: Query<any, any, any, any>
}

interface NotifyEventQueryUpdated extends NotifyEvent {
  type: 'updated'
  query: Query<any, any, any, any>
  action: Action<any, any>
}

interface NotifyEventQueryObserverAdded extends NotifyEvent {
  type: 'observerAdded'
  query: Query<any, any, any, any>
  observer: QueryObserver<any, any, any, any, any>
}

interface NotifyEventQueryObserverRemoved extends NotifyEvent {
  type: 'observerRemoved'
  query: Query<any, any, any, any>
  observer: QueryObserver<any, any, any, any, any>
}

interface NotifyEventQueryObserverResultsUpdated extends NotifyEvent {
  type: 'observerResultsUpdated'
  query: Query<any, any, any, any>
}

interface NotifyEventQueryObserverOptionsUpdated extends NotifyEvent {
  type: 'observerOptionsUpdated'
  query: Query<any, any, any, any>
  observer: QueryObserver<any, any, any, any, any>
}

export type QueryCacheNotifyEvent =
  | NotifyEventQueryAdded
  | NotifyEventQueryRemoved
  | NotifyEventQueryUpdated
  | NotifyEventQueryObserverAdded
  | NotifyEventQueryObserverRemoved
  | NotifyEventQueryObserverResultsUpdated
  | NotifyEventQueryObserverOptionsUpdated

type QueryCacheListener = (event: QueryCacheNotifyEvent) => void

export interface QueryStore {
  has: (queryHash: string) => boolean
  set: (queryHash: string, query: Query) => void
  get: (queryHash: string) => Query | undefined
  delete: (queryHash: string) => void
  values: () => IterableIterator<Query>
}

// CLASS

export class QueryCache extends Subscribable<QueryCacheListener> {
  #queries: QueryStore

  constructor(public config: QueryCacheConfig = {}) {
    super()
    this.#queries = new Map<string, Query>()
  }

  build<
    TQueryFnData = unknown,
    TError = DefaultError,
    TData = TQueryFnData,
    TQueryKey extends QueryKey = QueryKey,
  >(
    client: QueryClient,
    options: WithRequired<
      QueryOptions<TQueryFnData, TError, TData, TQueryKey>,
      'queryKey'
    >,
    state?: QueryState<TData, TError>,
  ): Query<TQueryFnData, TError, TData, TQueryKey> {
    const queryKey = options.queryKey
    const queryHash =
      options.queryHash ?? hashQueryKeyByOptions(queryKey, options)
    let query = this.get<TQueryFnData, TError, TData, TQueryKey>(queryHash)

    if (!query) {
      query = new Query({
        client,
        queryKey,
        queryHash,
        options: client.defaultQueryOptions(options),
        state,
        defaultOptions: client.getQueryDefaults(queryKey),
      })
      this.add(query)
    }

    return query
  }

  add(query: Query<any, any, any, any>): void {
    if (!this.#queries.has(query.queryHash)) {
      this.#queries.set(query.queryHash, query)

      this.notify({
        type: 'added',
        query,
      })
    }
  }

  remove(query: Query<any, any, any, any>): void {
    const queryInMap = this.#queries.get(query.queryHash)

    if (queryInMap) {
      query.destroy()

      if (queryInMap === query) {
        this.#queries.delete(query.queryHash)
      }

      this.notify({ type: 'removed', query })
    }
  }

  clear(): void {
    notifyManager.batch(() => {
      this.getAll().forEach((query) => {
        this.remove(query)
      })
    })
  }

  get<
    TQueryFnData = unknown,
    TError = DefaultError,
    TData = TQueryFnData,
    TQueryKey extends QueryKey = QueryKey,
  >(
    queryHash: string,
  ): Query<TQueryFnData, TError, TData, TQueryKey> | undefined {
    return this.#queries.get(queryHash) as
      | Query<TQueryFnData, TError, TData, TQueryKey>
      | undefined
  }

  getAll(): Array<Query> {
    return [...this.#queries.values()]
  }

  find<TQueryFnData = unknown, TError = DefaultError, TData = TQueryFnData>(
    filters: WithRequired<QueryFilters, 'queryKey'>,
  ): Query<TQueryFnData, TError, TData> | undefined {
    const defaultedFilters = { exact: true, ...filters }

    return this.getAll().find((query) =>
      matchQuery(defaultedFilters, query),
    ) as Query<TQueryFnData, TError, TData> | undefined
  }

  findAll(filters: QueryFilters<any, any, any, any> = {}): Array<Query> {
    const queries = this.getAll()
    return Object.keys(filters).length > 0
      ? queries.filter((query) => matchQuery(filters, query))
      : queries
  }

  notify(event: QueryCacheNotifyEvent): void {
    notifyManager.batch(() => {
      this.listeners.forEach((listener) => {
        listener(event)
      })
    })
  }

  onFocus(): void {
    notifyManager.batch(() => {
      this.getAll().forEach((query) => {
        query.onFocus()
      })
    })
  }

  onOnline(): void {
    notifyManager.batch(() => {
      this.getAll().forEach((query) => {
        query.onOnline()
      })
    })
  }
}



# ./src/infiniteQueryBehavior.ts

import { addToEnd, addToStart, ensureQueryFn } from './utils'
import type { QueryBehavior } from './query'
import type {
  InfiniteData,
  InfiniteQueryPageParamsOptions,
  OmitKeyof,
  QueryFunctionContext,
  QueryKey,
} from './types'

export function infiniteQueryBehavior<TQueryFnData, TError, TData, TPageParam>(
  pages?: number,
): QueryBehavior<TQueryFnData, TError, InfiniteData<TData, TPageParam>> {
  return {
    onFetch: (context, query) => {
      const options = context.options as InfiniteQueryPageParamsOptions<TData>
      const direction = context.fetchOptions?.meta?.fetchMore?.direction
      const oldPages = context.state.data?.pages || []
      const oldPageParams = context.state.data?.pageParams || []
      let result: InfiniteData<unknown> = { pages: [], pageParams: [] }
      let currentPage = 0

      const fetchFn = async () => {
        let cancelled = false
        const addSignalProperty = (object: unknown) => {
          Object.defineProperty(object, 'signal', {
            enumerable: true,
            get: () => {
              if (context.signal.aborted) {
                cancelled = true
              } else {
                context.signal.addEventListener('abort', () => {
                  cancelled = true
                })
              }
              return context.signal
            },
          })
        }

        const queryFn = ensureQueryFn(context.options, context.fetchOptions)

        // Create function to fetch a page
        const fetchPage = async (
          data: InfiniteData<unknown>,
          param: unknown,
          previous?: boolean,
        ): Promise<InfiniteData<unknown>> => {
          if (cancelled) {
            return Promise.reject()
          }

          if (param == null && data.pages.length) {
            return Promise.resolve(data)
          }

          const queryFnContext: OmitKeyof<
            QueryFunctionContext<QueryKey, unknown>,
            'signal'
          > = {
            client: context.client,
            queryKey: context.queryKey,
            pageParam: param,
            direction: previous ? 'backward' : 'forward',
            meta: context.options.meta,
          }

          addSignalProperty(queryFnContext)

          const page = await queryFn(
            queryFnContext as QueryFunctionContext<QueryKey, unknown>,
          )

          const { maxPages } = context.options
          const addTo = previous ? addToStart : addToEnd

          return {
            pages: addTo(data.pages, page, maxPages),
            pageParams: addTo(data.pageParams, param, maxPages),
          }
        }

        // fetch next / previous page?
        if (direction && oldPages.length) {
          const previous = direction === 'backward'
          const pageParamFn = previous ? getPreviousPageParam : getNextPageParam
          const oldData = {
            pages: oldPages,
            pageParams: oldPageParams,
          }
          const param = pageParamFn(options, oldData)

          result = await fetchPage(oldData, param, previous)
        } else {
          const remainingPages = pages ?? oldPages.length

          // Fetch all pages
          do {
            const param =
              currentPage === 0
                ? (oldPageParams[0] ?? options.initialPageParam)
                : getNextPageParam(options, result)
            if (currentPage > 0 && param == null) {
              break
            }
            result = await fetchPage(result, param)
            currentPage++
          } while (currentPage < remainingPages)
        }

        return result
      }
      if (context.options.persister) {
        context.fetchFn = () => {
          return context.options.persister?.(
            fetchFn as any,
            {
              client: context.client,
              queryKey: context.queryKey,
              meta: context.options.meta,
              signal: context.signal,
            },
            query,
          )
        }
      } else {
        context.fetchFn = fetchFn
      }
    },
  }
}

function getNextPageParam(
  options: InfiniteQueryPageParamsOptions<any>,
  { pages, pageParams }: InfiniteData<unknown>,
): unknown | undefined {
  const lastIndex = pages.length - 1
  return pages.length > 0
    ? options.getNextPageParam(
        pages[lastIndex],
        pages,
        pageParams[lastIndex],
        pageParams,
      )
    : undefined
}

function getPreviousPageParam(
  options: InfiniteQueryPageParamsOptions<any>,
  { pages, pageParams }: InfiniteData<unknown>,
): unknown | undefined {
  return pages.length > 0
    ? options.getPreviousPageParam?.(pages[0], pages, pageParams[0], pageParams)
    : undefined
}

/**
 * Checks if there is a next page.
 */
export function hasNextPage(
  options: InfiniteQueryPageParamsOptions<any, any>,
  data?: InfiniteData<unknown>,
): boolean {
  if (!data) return false
  return getNextPageParam(options, data) != null
}

/**
 * Checks if there is a previous page.
 */
export function hasPreviousPage(
  options: InfiniteQueryPageParamsOptions<any, any>,
  data?: InfiniteData<unknown>,
): boolean {
  if (!data || !options.getPreviousPageParam) return false
  return getPreviousPageParam(options, data) != null
}



# ./src/queryObserver.ts

import { focusManager } from './focusManager'
import { notifyManager } from './notifyManager'
import { fetchState } from './query'
import { Subscribable } from './subscribable'
import { pendingThenable } from './thenable'
import {
  isServer,
  isValidTimeout,
  noop,
  replaceData,
  resolveEnabled,
  resolveStaleTime,
  shallowEqualObjects,
  timeUntilStale,
} from './utils'
import type { FetchOptions, Query, QueryState } from './query'
import type { QueryClient } from './queryClient'
import type { PendingThenable, Thenable } from './thenable'
import type {
  DefaultError,
  DefaultedQueryObserverOptions,
  PlaceholderDataFunction,
  QueryKey,
  QueryObserverBaseResult,
  QueryObserverOptions,
  QueryObserverResult,
  QueryOptions,
  RefetchOptions,
} from './types'

type QueryObserverListener<TData, TError> = (
  result: QueryObserverResult<TData, TError>,
) => void

export interface NotifyOptions {
  listeners?: boolean
}

interface ObserverFetchOptions extends FetchOptions {
  throwOnError?: boolean
}

export class QueryObserver<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> extends Subscribable<QueryObserverListener<TData, TError>> {
  #client: QueryClient
  #currentQuery: Query<TQueryFnData, TError, TQueryData, TQueryKey> = undefined!
  #currentQueryInitialState: QueryState<TQueryData, TError> = undefined!
  #currentResult: QueryObserverResult<TData, TError> = undefined!
  #currentResultState?: QueryState<TQueryData, TError>
  #currentResultOptions?: QueryObserverOptions<
    TQueryFnData,
    TError,
    TData,
    TQueryData,
    TQueryKey
  >
  #currentThenable: Thenable<TData>
  #selectError: TError | null
  #selectFn?: (data: TQueryData) => TData
  #selectResult?: TData
  // This property keeps track of the last query with defined data.
  // It will be used to pass the previous data and query to the placeholder function between renders.
  #lastQueryWithDefinedData?: Query<TQueryFnData, TError, TQueryData, TQueryKey>
  #staleTimeoutId?: ReturnType<typeof setTimeout>
  #refetchIntervalId?: ReturnType<typeof setInterval>
  #currentRefetchInterval?: number | false
  #trackedProps = new Set<keyof QueryObserverResult>()

  constructor(
    client: QueryClient,
    public options: QueryObserverOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryData,
      TQueryKey
    >,
  ) {
    super()

    this.#client = client
    this.#selectError = null
    this.#currentThenable = pendingThenable()
    if (!this.options.experimental_prefetchInRender) {
      this.#currentThenable.reject(
        new Error('experimental_prefetchInRender feature flag is not enabled'),
      )
    }

    this.bindMethods()
    this.setOptions(options)
  }

  protected bindMethods(): void {
    this.refetch = this.refetch.bind(this)
  }

  protected onSubscribe(): void {
    if (this.listeners.size === 1) {
      this.#currentQuery.addObserver(this)

      if (shouldFetchOnMount(this.#currentQuery, this.options)) {
        this.#executeFetch()
      } else {
        this.updateResult()
      }

      this.#updateTimers()
    }
  }

  protected onUnsubscribe(): void {
    if (!this.hasListeners()) {
      this.destroy()
    }
  }

  shouldFetchOnReconnect(): boolean {
    return shouldFetchOn(
      this.#currentQuery,
      this.options,
      this.options.refetchOnReconnect,
    )
  }

  shouldFetchOnWindowFocus(): boolean {
    return shouldFetchOn(
      this.#currentQuery,
      this.options,
      this.options.refetchOnWindowFocus,
    )
  }

  destroy(): void {
    this.listeners = new Set()
    this.#clearStaleTimeout()
    this.#clearRefetchInterval()
    this.#currentQuery.removeObserver(this)
  }

  setOptions(
    options: QueryObserverOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryData,
      TQueryKey
    >,
    notifyOptions?: NotifyOptions,
  ): void {
    const prevOptions = this.options
    const prevQuery = this.#currentQuery

    this.options = this.#client.defaultQueryOptions(options)

    if (
      this.options.enabled !== undefined &&
      typeof this.options.enabled !== 'boolean' &&
      typeof this.options.enabled !== 'function' &&
      typeof resolveEnabled(this.options.enabled, this.#currentQuery) !==
        'boolean'
    ) {
      throw new Error(
        'Expected enabled to be a boolean or a callback that returns a boolean',
      )
    }

    this.#updateQuery()
    this.#currentQuery.setOptions(this.options)

    if (
      prevOptions._defaulted &&
      !shallowEqualObjects(this.options, prevOptions)
    ) {
      this.#client.getQueryCache().notify({
        type: 'observerOptionsUpdated',
        query: this.#currentQuery,
        observer: this,
      })
    }

    const mounted = this.hasListeners()

    // Fetch if there are subscribers
    if (
      mounted &&
      shouldFetchOptionally(
        this.#currentQuery,
        prevQuery,
        this.options,
        prevOptions,
      )
    ) {
      this.#executeFetch()
    }

    // Update result
    this.updateResult(notifyOptions)

    // Update stale interval if needed
    if (
      mounted &&
      (this.#currentQuery !== prevQuery ||
        resolveEnabled(this.options.enabled, this.#currentQuery) !==
          resolveEnabled(prevOptions.enabled, this.#currentQuery) ||
        resolveStaleTime(this.options.staleTime, this.#currentQuery) !==
          resolveStaleTime(prevOptions.staleTime, this.#currentQuery))
    ) {
      this.#updateStaleTimeout()
    }

    const nextRefetchInterval = this.#computeRefetchInterval()

    // Update refetch interval if needed
    if (
      mounted &&
      (this.#currentQuery !== prevQuery ||
        resolveEnabled(this.options.enabled, this.#currentQuery) !==
          resolveEnabled(prevOptions.enabled, this.#currentQuery) ||
        nextRefetchInterval !== this.#currentRefetchInterval)
    ) {
      this.#updateRefetchInterval(nextRefetchInterval)
    }
  }

  getOptimisticResult(
    options: DefaultedQueryObserverOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryData,
      TQueryKey
    >,
  ): QueryObserverResult<TData, TError> {
    const query = this.#client.getQueryCache().build(this.#client, options)

    const result = this.createResult(query, options)

    if (shouldAssignObserverCurrentProperties(this, result)) {
      // this assigns the optimistic result to the current Observer
      // because if the query function changes, useQuery will be performing
      // an effect where it would fetch again.
      // When the fetch finishes, we perform a deep data cloning in order
      // to reuse objects references. This deep data clone is performed against
      // the `observer.currentResult.data` property
      // When QueryKey changes, we refresh the query and get new `optimistic`
      // result, while we leave the `observer.currentResult`, so when new data
      // arrives, it finds the old `observer.currentResult` which is related
      // to the old QueryKey. Which means that currentResult and selectData are
      // out of sync already.
      // To solve this, we move the cursor of the currentResult every time
      // an observer reads an optimistic value.

      // When keeping the previous data, the result doesn't change until new
      // data arrives.
      this.#currentResult = result
      this.#currentResultOptions = this.options
      this.#currentResultState = this.#currentQuery.state
    }
    return result
  }

  getCurrentResult(): QueryObserverResult<TData, TError> {
    return this.#currentResult
  }

  trackResult(
    result: QueryObserverResult<TData, TError>,
    onPropTracked?: (key: keyof QueryObserverResult) => void,
  ): QueryObserverResult<TData, TError> {
    const trackedResult = {} as QueryObserverResult<TData, TError>

    Object.keys(result).forEach((key) => {
      Object.defineProperty(trackedResult, key, {
        configurable: false,
        enumerable: true,
        get: () => {
          this.trackProp(key as keyof QueryObserverResult)
          onPropTracked?.(key as keyof QueryObserverResult)
          return result[key as keyof QueryObserverResult]
        },
      })
    })

    return trackedResult
  }

  trackProp(key: keyof QueryObserverResult) {
    this.#trackedProps.add(key)
  }

  getCurrentQuery(): Query<TQueryFnData, TError, TQueryData, TQueryKey> {
    return this.#currentQuery
  }

  refetch({ ...options }: RefetchOptions = {}): Promise<
    QueryObserverResult<TData, TError>
  > {
    return this.fetch({
      ...options,
    })
  }

  fetchOptimistic(
    options: QueryObserverOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryData,
      TQueryKey
    >,
  ): Promise<QueryObserverResult<TData, TError>> {
    const defaultedOptions = this.#client.defaultQueryOptions(options)

    const query = this.#client
      .getQueryCache()
      .build(this.#client, defaultedOptions)

    return query.fetch().then(() => this.createResult(query, defaultedOptions))
  }

  protected fetch(
    fetchOptions: ObserverFetchOptions,
  ): Promise<QueryObserverResult<TData, TError>> {
    return this.#executeFetch({
      ...fetchOptions,
      cancelRefetch: fetchOptions.cancelRefetch ?? true,
    }).then(() => {
      this.updateResult()
      return this.#currentResult
    })
  }

  #executeFetch(
    fetchOptions?: Omit<ObserverFetchOptions, 'initialPromise'>,
  ): Promise<TQueryData | undefined> {
    // Make sure we reference the latest query as the current one might have been removed
    this.#updateQuery()

    // Fetch
    let promise: Promise<TQueryData | undefined> = this.#currentQuery.fetch(
      this.options as QueryOptions<TQueryFnData, TError, TQueryData, TQueryKey>,
      fetchOptions,
    )

    if (!fetchOptions?.throwOnError) {
      promise = promise.catch(noop)
    }

    return promise
  }

  #updateStaleTimeout(): void {
    this.#clearStaleTimeout()
    const staleTime = resolveStaleTime(
      this.options.staleTime,
      this.#currentQuery,
    )

    if (isServer || this.#currentResult.isStale || !isValidTimeout(staleTime)) {
      return
    }

    const time = timeUntilStale(this.#currentResult.dataUpdatedAt, staleTime)

    // The timeout is sometimes triggered 1 ms before the stale time expiration.
    // To mitigate this issue we always add 1 ms to the timeout.
    const timeout = time + 1

    this.#staleTimeoutId = setTimeout(() => {
      if (!this.#currentResult.isStale) {
        this.updateResult()
      }
    }, timeout)
  }

  #computeRefetchInterval() {
    return (
      (typeof this.options.refetchInterval === 'function'
        ? this.options.refetchInterval(this.#currentQuery)
        : this.options.refetchInterval) ?? false
    )
  }

  #updateRefetchInterval(nextInterval: number | false): void {
    this.#clearRefetchInterval()

    this.#currentRefetchInterval = nextInterval

    if (
      isServer ||
      resolveEnabled(this.options.enabled, this.#currentQuery) === false ||
      !isValidTimeout(this.#currentRefetchInterval) ||
      this.#currentRefetchInterval === 0
    ) {
      return
    }

    this.#refetchIntervalId = setInterval(() => {
      if (
        this.options.refetchIntervalInBackground ||
        focusManager.isFocused()
      ) {
        this.#executeFetch()
      }
    }, this.#currentRefetchInterval)
  }

  #updateTimers(): void {
    this.#updateStaleTimeout()
    this.#updateRefetchInterval(this.#computeRefetchInterval())
  }

  #clearStaleTimeout(): void {
    if (this.#staleTimeoutId) {
      clearTimeout(this.#staleTimeoutId)
      this.#staleTimeoutId = undefined
    }
  }

  #clearRefetchInterval(): void {
    if (this.#refetchIntervalId) {
      clearInterval(this.#refetchIntervalId)
      this.#refetchIntervalId = undefined
    }
  }

  protected createResult(
    query: Query<TQueryFnData, TError, TQueryData, TQueryKey>,
    options: QueryObserverOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryData,
      TQueryKey
    >,
  ): QueryObserverResult<TData, TError> {
    const prevQuery = this.#currentQuery
    const prevOptions = this.options
    const prevResult = this.#currentResult as
      | QueryObserverResult<TData, TError>
      | undefined
    const prevResultState = this.#currentResultState
    const prevResultOptions = this.#currentResultOptions
    const queryChange = query !== prevQuery
    const queryInitialState = queryChange
      ? query.state
      : this.#currentQueryInitialState

    const { state } = query
    let newState = { ...state }
    let isPlaceholderData = false
    let data: TData | undefined

    // Optimistically set result in fetching state if needed
    if (options._optimisticResults) {
      const mounted = this.hasListeners()

      const fetchOnMount = !mounted && shouldFetchOnMount(query, options)

      const fetchOptionally =
        mounted && shouldFetchOptionally(query, prevQuery, options, prevOptions)

      if (fetchOnMount || fetchOptionally) {
        newState = {
          ...newState,
          ...fetchState(state.data, query.options),
        }
      }
      if (options._optimisticResults === 'isRestoring') {
        newState.fetchStatus = 'idle'
      }
    }

    let { error, errorUpdatedAt, status } = newState

    // Select data if needed
    if (options.select && newState.data !== undefined) {
      // Memoize select result
      if (
        prevResult &&
        newState.data === prevResultState?.data &&
        options.select === this.#selectFn
      ) {
        data = this.#selectResult
      } else {
        try {
          this.#selectFn = options.select
          data = options.select(newState.data)
          data = replaceData(prevResult?.data, data, options)
          this.#selectResult = data
          this.#selectError = null
        } catch (selectError) {
          this.#selectError = selectError as TError
        }
      }
    }
    // Use query data
    else {
      data = newState.data as unknown as TData
    }

    // Show placeholder data if needed
    if (
      options.placeholderData !== undefined &&
      data === undefined &&
      status === 'pending'
    ) {
      let placeholderData

      // Memoize placeholder data
      if (
        prevResult?.isPlaceholderData &&
        options.placeholderData === prevResultOptions?.placeholderData
      ) {
        placeholderData = prevResult.data
      } else {
        placeholderData =
          typeof options.placeholderData === 'function'
            ? (
                options.placeholderData as unknown as PlaceholderDataFunction<TQueryData>
              )(
                this.#lastQueryWithDefinedData?.state.data,
                this.#lastQueryWithDefinedData as any,
              )
            : options.placeholderData
        if (options.select && placeholderData !== undefined) {
          try {
            placeholderData = options.select(placeholderData)
            this.#selectError = null
          } catch (selectError) {
            this.#selectError = selectError as TError
          }
        }
      }

      if (placeholderData !== undefined) {
        status = 'success'
        data = replaceData(
          prevResult?.data,
          placeholderData as unknown,
          options,
        ) as TData
        isPlaceholderData = true
      }
    }

    if (this.#selectError) {
      error = this.#selectError as any
      data = this.#selectResult
      errorUpdatedAt = Date.now()
      status = 'error'
    }

    const isFetching = newState.fetchStatus === 'fetching'
    const isPending = status === 'pending'
    const isError = status === 'error'

    const isLoading = isPending && isFetching
    const hasData = data !== undefined

    const result: QueryObserverBaseResult<TData, TError> = {
      status,
      fetchStatus: newState.fetchStatus,
      isPending,
      isSuccess: status === 'success',
      isError,
      isInitialLoading: isLoading,
      isLoading,
      data,
      dataUpdatedAt: newState.dataUpdatedAt,
      error,
      errorUpdatedAt,
      failureCount: newState.fetchFailureCount,
      failureReason: newState.fetchFailureReason,
      errorUpdateCount: newState.errorUpdateCount,
      isFetched: newState.dataUpdateCount > 0 || newState.errorUpdateCount > 0,
      isFetchedAfterMount:
        newState.dataUpdateCount > queryInitialState.dataUpdateCount ||
        newState.errorUpdateCount > queryInitialState.errorUpdateCount,
      isFetching,
      isRefetching: isFetching && !isPending,
      isLoadingError: isError && !hasData,
      isPaused: newState.fetchStatus === 'paused',
      isPlaceholderData,
      isRefetchError: isError && hasData,
      isStale: isStale(query, options),
      refetch: this.refetch,
      promise: this.#currentThenable,
    }

    const nextResult = result as QueryObserverResult<TData, TError>

    if (this.options.experimental_prefetchInRender) {
      const finalizeThenableIfPossible = (thenable: PendingThenable<TData>) => {
        if (nextResult.status === 'error') {
          thenable.reject(nextResult.error)
        } else if (nextResult.data !== undefined) {
          thenable.resolve(nextResult.data)
        }
      }

      /**
       * Create a new thenable and result promise when the results have changed
       */
      const recreateThenable = () => {
        const pending =
          (this.#currentThenable =
          nextResult.promise =
            pendingThenable())

        finalizeThenableIfPossible(pending)
      }

      const prevThenable = this.#currentThenable
      switch (prevThenable.status) {
        case 'pending':
          // Finalize the previous thenable if it was pending
          // and we are still observing the same query
          if (query.queryHash === prevQuery.queryHash) {
            finalizeThenableIfPossible(prevThenable)
          }
          break
        case 'fulfilled':
          if (
            nextResult.status === 'error' ||
            nextResult.data !== prevThenable.value
          ) {
            recreateThenable()
          }
          break
        case 'rejected':
          if (
            nextResult.status !== 'error' ||
            nextResult.error !== prevThenable.reason
          ) {
            recreateThenable()
          }
          break
      }
    }

    return nextResult
  }

  updateResult(notifyOptions?: NotifyOptions): void {
    const prevResult = this.#currentResult as
      | QueryObserverResult<TData, TError>
      | undefined

    const nextResult = this.createResult(this.#currentQuery, this.options)

    this.#currentResultState = this.#currentQuery.state
    this.#currentResultOptions = this.options

    if (this.#currentResultState.data !== undefined) {
      this.#lastQueryWithDefinedData = this.#currentQuery
    }

    // Only notify and update result if something has changed
    if (shallowEqualObjects(nextResult, prevResult)) {
      return
    }

    this.#currentResult = nextResult

    // Determine which callbacks to trigger
    const defaultNotifyOptions: NotifyOptions = {}

    const shouldNotifyListeners = (): boolean => {
      if (!prevResult) {
        return true
      }

      const { notifyOnChangeProps } = this.options
      const notifyOnChangePropsValue =
        typeof notifyOnChangeProps === 'function'
          ? notifyOnChangeProps()
          : notifyOnChangeProps

      if (
        notifyOnChangePropsValue === 'all' ||
        (!notifyOnChangePropsValue && !this.#trackedProps.size)
      ) {
        return true
      }

      const includedProps = new Set(
        notifyOnChangePropsValue ?? this.#trackedProps,
      )

      if (this.options.throwOnError) {
        includedProps.add('error')
      }

      return Object.keys(this.#currentResult).some((key) => {
        const typedKey = key as keyof QueryObserverResult
        const changed = this.#currentResult[typedKey] !== prevResult[typedKey]

        return changed && includedProps.has(typedKey)
      })
    }

    if (notifyOptions?.listeners !== false && shouldNotifyListeners()) {
      defaultNotifyOptions.listeners = true
    }

    this.#notify({ ...defaultNotifyOptions, ...notifyOptions })
  }

  #updateQuery(): void {
    const query = this.#client.getQueryCache().build(this.#client, this.options)

    if (query === this.#currentQuery) {
      return
    }

    const prevQuery = this.#currentQuery as
      | Query<TQueryFnData, TError, TQueryData, TQueryKey>
      | undefined
    this.#currentQuery = query
    this.#currentQueryInitialState = query.state

    if (this.hasListeners()) {
      prevQuery?.removeObserver(this)
      query.addObserver(this)
    }
  }

  onQueryUpdate(): void {
    this.updateResult()

    if (this.hasListeners()) {
      this.#updateTimers()
    }
  }

  #notify(notifyOptions: NotifyOptions): void {
    notifyManager.batch(() => {
      // First, trigger the listeners
      if (notifyOptions.listeners) {
        this.listeners.forEach((listener) => {
          listener(this.#currentResult)
        })
      }

      // Then the cache listeners
      this.#client.getQueryCache().notify({
        query: this.#currentQuery,
        type: 'observerResultsUpdated',
      })
    })
  }
}

function shouldLoadOnMount(
  query: Query<any, any, any, any>,
  options: QueryObserverOptions<any, any, any, any>,
): boolean {
  return (
    resolveEnabled(options.enabled, query) !== false &&
    query.state.data === undefined &&
    !(query.state.status === 'error' && options.retryOnMount === false)
  )
}

function shouldFetchOnMount(
  query: Query<any, any, any, any>,
  options: QueryObserverOptions<any, any, any, any, any>,
): boolean {
  return (
    shouldLoadOnMount(query, options) ||
    (query.state.data !== undefined &&
      shouldFetchOn(query, options, options.refetchOnMount))
  )
}

function shouldFetchOn(
  query: Query<any, any, any, any>,
  options: QueryObserverOptions<any, any, any, any, any>,
  field: (typeof options)['refetchOnMount'] &
    (typeof options)['refetchOnWindowFocus'] &
    (typeof options)['refetchOnReconnect'],
) {
  if (resolveEnabled(options.enabled, query) !== false) {
    const value = typeof field === 'function' ? field(query) : field

    return value === 'always' || (value !== false && isStale(query, options))
  }
  return false
}

function shouldFetchOptionally(
  query: Query<any, any, any, any>,
  prevQuery: Query<any, any, any, any>,
  options: QueryObserverOptions<any, any, any, any, any>,
  prevOptions: QueryObserverOptions<any, any, any, any, any>,
): boolean {
  return (
    (query !== prevQuery ||
      resolveEnabled(prevOptions.enabled, query) === false) &&
    (!options.suspense || query.state.status !== 'error') &&
    isStale(query, options)
  )
}

function isStale(
  query: Query<any, any, any, any>,
  options: QueryObserverOptions<any, any, any, any, any>,
): boolean {
  return (
    resolveEnabled(options.enabled, query) !== false &&
    query.isStaleByTime(resolveStaleTime(options.staleTime, query))
  )
}

// this function would decide if we will update the observer's 'current'
// properties after an optimistic reading via getOptimisticResult
function shouldAssignObserverCurrentProperties<
  TQueryFnData = unknown,
  TError = unknown,
  TData = TQueryFnData,
  TQueryData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
>(
  observer: QueryObserver<TQueryFnData, TError, TData, TQueryData, TQueryKey>,
  optimisticResult: QueryObserverResult<TData, TError>,
) {
  // if the newly created result isn't what the observer is holding as current,
  // then we'll need to update the properties as well
  if (!shallowEqualObjects(observer.getCurrentResult(), optimisticResult)) {
    return true
  }

  // basically, just keep previous properties if nothing changed
  return false
}



# ./src/hydration.ts

import type {
  DefaultError,
  MutationKey,
  MutationMeta,
  MutationOptions,
  MutationScope,
  QueryKey,
  QueryMeta,
  QueryOptions,
} from './types'
import type { QueryClient } from './queryClient'
import type { Query, QueryState } from './query'
import type { Mutation, MutationState } from './mutation'

// TYPES
type TransformerFn = (data: any) => any
function defaultTransformerFn(data: any): any {
  return data
}

export interface DehydrateOptions {
  serializeData?: TransformerFn
  shouldDehydrateMutation?: (mutation: Mutation) => boolean
  shouldDehydrateQuery?: (query: Query) => boolean
  shouldRedactErrors?: (error: unknown) => boolean
}

export interface HydrateOptions {
  defaultOptions?: {
    deserializeData?: TransformerFn
    queries?: QueryOptions
    mutations?: MutationOptions<unknown, DefaultError, unknown, unknown>
  }
}

interface DehydratedMutation {
  mutationKey?: MutationKey
  state: MutationState
  meta?: MutationMeta
  scope?: MutationScope
}

interface DehydratedQuery {
  queryHash: string
  queryKey: QueryKey
  state: QueryState
  promise?: Promise<unknown>
  meta?: QueryMeta
}

export interface DehydratedState {
  mutations: Array<DehydratedMutation>
  queries: Array<DehydratedQuery>
}

// FUNCTIONS

function dehydrateMutation(mutation: Mutation): DehydratedMutation {
  return {
    mutationKey: mutation.options.mutationKey,
    state: mutation.state,
    ...(mutation.options.scope && { scope: mutation.options.scope }),
    ...(mutation.meta && { meta: mutation.meta }),
  }
}

// Most config is not dehydrated but instead meant to configure again when
// consuming the de/rehydrated data, typically with useQuery on the client.
// Sometimes it might make sense to prefetch data on the server and include
// in the html-payload, but not consume it on the initial render.
function dehydrateQuery(
  query: Query,
  serializeData: TransformerFn,
  shouldRedactErrors: (error: unknown) => boolean,
): DehydratedQuery {
  return {
    state: {
      ...query.state,
      ...(query.state.data !== undefined && {
        data: serializeData(query.state.data),
      }),
    },
    queryKey: query.queryKey,
    queryHash: query.queryHash,
    ...(query.state.status === 'pending' && {
      promise: query.promise?.then(serializeData).catch((error) => {
        if (!shouldRedactErrors(error)) {
          // Reject original error if it should not be redacted
          return Promise.reject(error)
        }
        // If not in production, log original error before rejecting redacted error
        if (process.env.NODE_ENV !== 'production') {
          console.error(
            `A query that was dehydrated as pending ended up rejecting. [${query.queryHash}]: ${error}; The error will be redacted in production builds`,
          )
        }
        return Promise.reject(new Error('redacted'))
      }),
    }),
    ...(query.meta && { meta: query.meta }),
  }
}

export function defaultShouldDehydrateMutation(mutation: Mutation) {
  return mutation.state.isPaused
}

export function defaultShouldDehydrateQuery(query: Query) {
  return query.state.status === 'success'
}

export function defaultshouldRedactErrors(_: unknown) {
  return true
}

export function dehydrate(
  client: QueryClient,
  options: DehydrateOptions = {},
): DehydratedState {
  const filterMutation =
    options.shouldDehydrateMutation ??
    client.getDefaultOptions().dehydrate?.shouldDehydrateMutation ??
    defaultShouldDehydrateMutation

  const mutations = client
    .getMutationCache()
    .getAll()
    .flatMap((mutation) =>
      filterMutation(mutation) ? [dehydrateMutation(mutation)] : [],
    )

  const filterQuery =
    options.shouldDehydrateQuery ??
    client.getDefaultOptions().dehydrate?.shouldDehydrateQuery ??
    defaultShouldDehydrateQuery

  const shouldRedactErrors =
    options.shouldRedactErrors ??
    client.getDefaultOptions().dehydrate?.shouldRedactErrors ??
    defaultshouldRedactErrors

  const serializeData =
    options.serializeData ??
    client.getDefaultOptions().dehydrate?.serializeData ??
    defaultTransformerFn

  const queries = client
    .getQueryCache()
    .getAll()
    .flatMap((query) =>
      filterQuery(query)
        ? [dehydrateQuery(query, serializeData, shouldRedactErrors)]
        : [],
    )

  return { mutations, queries }
}

export function hydrate(
  client: QueryClient,
  dehydratedState: unknown,
  options?: HydrateOptions,
): void {
  if (typeof dehydratedState !== 'object' || dehydratedState === null) {
    return
  }

  const mutationCache = client.getMutationCache()
  const queryCache = client.getQueryCache()
  const deserializeData =
    options?.defaultOptions?.deserializeData ??
    client.getDefaultOptions().hydrate?.deserializeData ??
    defaultTransformerFn

  // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
  const mutations = (dehydratedState as DehydratedState).mutations || []
  // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
  const queries = (dehydratedState as DehydratedState).queries || []

  mutations.forEach(({ state, ...mutationOptions }) => {
    mutationCache.build(
      client,
      {
        ...client.getDefaultOptions().hydrate?.mutations,
        ...options?.defaultOptions?.mutations,
        ...mutationOptions,
      },
      state,
    )
  })

  queries.forEach(({ queryKey, state, queryHash, meta, promise }) => {
    let query = queryCache.get(queryHash)

    const data =
      state.data === undefined ? state.data : deserializeData(state.data)

    // Do not hydrate if an existing query exists with newer data
    if (query) {
      if (query.state.dataUpdatedAt < state.dataUpdatedAt) {
        // omit fetchStatus from dehydrated state
        // so that query stays in its current fetchStatus
        const { fetchStatus: _ignored, ...serializedState } = state
        query.setState({
          ...serializedState,
          data,
        })
      }
    } else {
      // Restore query
      query = queryCache.build(
        client,
        {
          ...client.getDefaultOptions().hydrate?.queries,
          ...options?.defaultOptions?.queries,
          queryKey,
          queryHash,
          meta,
        },
        // Reset fetch status to idle to avoid
        // query being stuck in fetching state upon hydration
        {
          ...state,
          data,
          fetchStatus: 'idle',
        },
      )
    }

    if (promise) {
      // Note: `Promise.resolve` required cause
      // RSC transformed promises are not thenable
      const initialPromise = Promise.resolve(promise).then(deserializeData)

      // this doesn't actually fetch - it just creates a retryer
      // which will re-use the passed `initialPromise`
      void query.fetch(undefined, { initialPromise })
    }
  })
}



# ./src/mutationCache.ts

import { notifyManager } from './notifyManager'
import { Mutation } from './mutation'
import { matchMutation, noop } from './utils'
import { Subscribable } from './subscribable'
import type { MutationObserver } from './mutationObserver'
import type { DefaultError, MutationOptions, NotifyEvent } from './types'
import type { QueryClient } from './queryClient'
import type { Action, MutationState } from './mutation'
import type { MutationFilters } from './utils'

// TYPES

interface MutationCacheConfig {
  onError?: (
    error: DefaultError,
    variables: unknown,
    context: unknown,
    mutation: Mutation<unknown, unknown, unknown>,
  ) => Promise<unknown> | unknown
  onSuccess?: (
    data: unknown,
    variables: unknown,
    context: unknown,
    mutation: Mutation<unknown, unknown, unknown>,
  ) => Promise<unknown> | unknown
  onMutate?: (
    variables: unknown,
    mutation: Mutation<unknown, unknown, unknown>,
  ) => Promise<unknown> | unknown
  onSettled?: (
    data: unknown | undefined,
    error: DefaultError | null,
    variables: unknown,
    context: unknown,
    mutation: Mutation<unknown, unknown, unknown>,
  ) => Promise<unknown> | unknown
}

interface NotifyEventMutationAdded extends NotifyEvent {
  type: 'added'
  mutation: Mutation<any, any, any, any>
}
interface NotifyEventMutationRemoved extends NotifyEvent {
  type: 'removed'
  mutation: Mutation<any, any, any, any>
}

interface NotifyEventMutationObserverAdded extends NotifyEvent {
  type: 'observerAdded'
  mutation: Mutation<any, any, any, any>
  observer: MutationObserver<any, any, any>
}

interface NotifyEventMutationObserverRemoved extends NotifyEvent {
  type: 'observerRemoved'
  mutation: Mutation<any, any, any, any>
  observer: MutationObserver<any, any, any>
}

interface NotifyEventMutationObserverOptionsUpdated extends NotifyEvent {
  type: 'observerOptionsUpdated'
  mutation?: Mutation<any, any, any, any>
  observer: MutationObserver<any, any, any, any>
}

interface NotifyEventMutationUpdated extends NotifyEvent {
  type: 'updated'
  mutation: Mutation<any, any, any, any>
  action: Action<any, any, any, any>
}

export type MutationCacheNotifyEvent =
  | NotifyEventMutationAdded
  | NotifyEventMutationRemoved
  | NotifyEventMutationObserverAdded
  | NotifyEventMutationObserverRemoved
  | NotifyEventMutationObserverOptionsUpdated
  | NotifyEventMutationUpdated

type MutationCacheListener = (event: MutationCacheNotifyEvent) => void

// CLASS

export class MutationCache extends Subscribable<MutationCacheListener> {
  #mutations: Set<Mutation<any, any, any, any>>
  #scopes: Map<string, Array<Mutation<any, any, any, any>>>
  #mutationId: number

  constructor(public config: MutationCacheConfig = {}) {
    super()
    this.#mutations = new Set()
    this.#scopes = new Map()
    this.#mutationId = 0
  }

  build<TData, TError, TVariables, TContext>(
    client: QueryClient,
    options: MutationOptions<TData, TError, TVariables, TContext>,
    state?: MutationState<TData, TError, TVariables, TContext>,
  ): Mutation<TData, TError, TVariables, TContext> {
    const mutation = new Mutation({
      mutationCache: this,
      mutationId: ++this.#mutationId,
      options: client.defaultMutationOptions(options),
      state,
    })

    this.add(mutation)

    return mutation
  }

  add(mutation: Mutation<any, any, any, any>): void {
    this.#mutations.add(mutation)
    const scope = scopeFor(mutation)
    if (typeof scope === 'string') {
      const scopedMutations = this.#scopes.get(scope)
      if (scopedMutations) {
        scopedMutations.push(mutation)
      } else {
        this.#scopes.set(scope, [mutation])
      }
    }
    this.notify({ type: 'added', mutation })
  }

  remove(mutation: Mutation<any, any, any, any>): void {
    if (this.#mutations.delete(mutation)) {
      const scope = scopeFor(mutation)
      if (typeof scope === 'string') {
        const scopedMutations = this.#scopes.get(scope)
        if (scopedMutations) {
          if (scopedMutations.length > 1) {
            const index = scopedMutations.indexOf(mutation)
            if (index !== -1) {
              scopedMutations.splice(index, 1)
            }
          } else if (scopedMutations[0] === mutation) {
            this.#scopes.delete(scope)
          }
        }
      }
    }

    // Currently we notify the removal even if the mutation was already removed.
    // Consider making this an error or not notifying of the removal depending on the desired semantics.
    this.notify({ type: 'removed', mutation })
  }

  canRun(mutation: Mutation<any, any, any, any>): boolean {
    const scope = scopeFor(mutation)
    if (typeof scope === 'string') {
      const mutationsWithSameScope = this.#scopes.get(scope)
      const firstPendingMutation = mutationsWithSameScope?.find(
        (m) => m.state.status === 'pending',
      )
      // we can run if there is no current pending mutation (start use-case)
      // or if WE are the first pending mutation (continue use-case)
      return !firstPendingMutation || firstPendingMutation === mutation
    } else {
      // For unscoped mutations there are never any pending mutations in front of the
      // current mutation
      return true
    }
  }

  runNext(mutation: Mutation<any, any, any, any>): Promise<unknown> {
    const scope = scopeFor(mutation)
    if (typeof scope === 'string') {
      const foundMutation = this.#scopes
        .get(scope)
        ?.find((m) => m !== mutation && m.state.isPaused)

      return foundMutation?.continue() ?? Promise.resolve()
    } else {
      return Promise.resolve()
    }
  }

  clear(): void {
    notifyManager.batch(() => {
      this.#mutations.forEach((mutation) => {
        this.notify({ type: 'removed', mutation })
      })
      this.#mutations.clear()
      this.#scopes.clear()
    })
  }

  getAll(): Array<Mutation> {
    return Array.from(this.#mutations)
  }

  find<
    TData = unknown,
    TError = DefaultError,
    TVariables = any,
    TContext = unknown,
  >(
    filters: MutationFilters,
  ): Mutation<TData, TError, TVariables, TContext> | undefined {
    const defaultedFilters = { exact: true, ...filters }

    return this.getAll().find((mutation) =>
      matchMutation(defaultedFilters, mutation),
    ) as Mutation<TData, TError, TVariables, TContext> | undefined
  }

  findAll(filters: MutationFilters = {}): Array<Mutation> {
    return this.getAll().filter((mutation) => matchMutation(filters, mutation))
  }

  notify(event: MutationCacheNotifyEvent) {
    notifyManager.batch(() => {
      this.listeners.forEach((listener) => {
        listener(event)
      })
    })
  }

  resumePausedMutations(): Promise<unknown> {
    const pausedMutations = this.getAll().filter((x) => x.state.isPaused)

    return notifyManager.batch(() =>
      Promise.all(
        pausedMutations.map((mutation) => mutation.continue().catch(noop)),
      ),
    )
  }
}

function scopeFor(mutation: Mutation<any, any, any, any>) {
  return mutation.options.scope?.id
}



# ./src/subscribable.ts

export class Subscribable<TListener extends Function> {
  protected listeners = new Set<TListener>()

  constructor() {
    this.subscribe = this.subscribe.bind(this)
  }

  subscribe(listener: TListener): () => void {
    this.listeners.add(listener)

    this.onSubscribe()

    return () => {
      this.listeners.delete(listener)
      this.onUnsubscribe()
    }
  }

  hasListeners(): boolean {
    return this.listeners.size > 0
  }

  protected onSubscribe(): void {
    // Do nothing
  }

  protected onUnsubscribe(): void {
    // Do nothing
  }
}



# ./src/utils.ts

import type {
  DefaultError,
  Enabled,
  FetchStatus,
  MutationKey,
  MutationStatus,
  QueryFunction,
  QueryKey,
  QueryOptions,
  StaleTime,
} from './types'
import type { Mutation } from './mutation'
import type { FetchOptions, Query } from './query'

// TYPES

export interface QueryFilters<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> {
  /**
   * Filter to active queries, inactive queries or all queries
   */
  type?: QueryTypeFilter
  /**
   * Match query key exactly
   */
  exact?: boolean
  /**
   * Include queries matching this predicate function
   */
  predicate?: (query: Query<TQueryFnData, TError, TData, TQueryKey>) => boolean
  /**
   * Include queries matching this query key
   */
  queryKey?: TQueryKey
  /**
   * Include or exclude stale queries
   */
  stale?: boolean
  /**
   * Include queries matching their fetchStatus
   */
  fetchStatus?: FetchStatus
}

export interface MutationFilters<
  TData = unknown,
  TError = DefaultError,
  TVariables = unknown,
  TContext = unknown,
> {
  /**
   * Match mutation key exactly
   */
  exact?: boolean
  /**
   * Include mutations matching this predicate function
   */
  predicate?: (
    mutation: Mutation<TData, TError, TVariables, TContext>,
  ) => boolean
  /**
   * Include mutations matching this mutation key
   */
  mutationKey?: MutationKey
  /**
   * Filter by mutation status
   */
  status?: MutationStatus
}

export type Updater<TInput, TOutput> = TOutput | ((input: TInput) => TOutput)

export type QueryTypeFilter = 'all' | 'active' | 'inactive'

// UTILS

export const isServer = typeof window === 'undefined' || 'Deno' in globalThis

export function noop(): void
export function noop(): undefined
export function noop() {}

export function functionalUpdate<TInput, TOutput>(
  updater: Updater<TInput, TOutput>,
  input: TInput,
): TOutput {
  return typeof updater === 'function'
    ? (updater as (_: TInput) => TOutput)(input)
    : updater
}

export function isValidTimeout(value: unknown): value is number {
  return typeof value === 'number' && value >= 0 && value !== Infinity
}

export function timeUntilStale(updatedAt: number, staleTime?: number): number {
  return Math.max(updatedAt + (staleTime || 0) - Date.now(), 0)
}

export function resolveStaleTime<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
>(
  staleTime: undefined | StaleTime<TQueryFnData, TError, TData, TQueryKey>,
  query: Query<TQueryFnData, TError, TData, TQueryKey>,
): number | undefined {
  return typeof staleTime === 'function' ? staleTime(query) : staleTime
}

export function resolveEnabled<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
>(
  enabled: undefined | Enabled<TQueryFnData, TError, TData, TQueryKey>,
  query: Query<TQueryFnData, TError, TData, TQueryKey>,
): boolean | undefined {
  return typeof enabled === 'function' ? enabled(query) : enabled
}

export function matchQuery(
  filters: QueryFilters,
  query: Query<any, any, any, any>,
): boolean {
  const {
    type = 'all',
    exact,
    fetchStatus,
    predicate,
    queryKey,
    stale,
  } = filters

  if (queryKey) {
    if (exact) {
      if (query.queryHash !== hashQueryKeyByOptions(queryKey, query.options)) {
        return false
      }
    } else if (!partialMatchKey(query.queryKey, queryKey)) {
      return false
    }
  }

  if (type !== 'all') {
    const isActive = query.isActive()
    if (type === 'active' && !isActive) {
      return false
    }
    if (type === 'inactive' && isActive) {
      return false
    }
  }

  if (typeof stale === 'boolean' && query.isStale() !== stale) {
    return false
  }

  if (fetchStatus && fetchStatus !== query.state.fetchStatus) {
    return false
  }

  if (predicate && !predicate(query)) {
    return false
  }

  return true
}

export function matchMutation(
  filters: MutationFilters,
  mutation: Mutation<any, any>,
): boolean {
  const { exact, status, predicate, mutationKey } = filters
  if (mutationKey) {
    if (!mutation.options.mutationKey) {
      return false
    }
    if (exact) {
      if (hashKey(mutation.options.mutationKey) !== hashKey(mutationKey)) {
        return false
      }
    } else if (!partialMatchKey(mutation.options.mutationKey, mutationKey)) {
      return false
    }
  }

  if (status && mutation.state.status !== status) {
    return false
  }

  if (predicate && !predicate(mutation)) {
    return false
  }

  return true
}

export function hashQueryKeyByOptions<TQueryKey extends QueryKey = QueryKey>(
  queryKey: TQueryKey,
  options?: Pick<QueryOptions<any, any, any, any>, 'queryKeyHashFn'>,
): string {
  const hashFn = options?.queryKeyHashFn || hashKey
  return hashFn(queryKey)
}

/**
 * Default query & mutation keys hash function.
 * Hashes the value into a stable hash.
 */
export function hashKey(queryKey: QueryKey | MutationKey): string {
  return JSON.stringify(queryKey, (_, val) =>
    isPlainObject(val)
      ? Object.keys(val)
          .sort()
          .reduce((result, key) => {
            result[key] = val[key]
            return result
          }, {} as any)
      : val,
  )
}

/**
 * Checks if key `b` partially matches with key `a`.
 */
export function partialMatchKey(a: QueryKey, b: QueryKey): boolean
export function partialMatchKey(a: any, b: any): boolean {
  if (a === b) {
    return true
  }

  if (typeof a !== typeof b) {
    return false
  }

  if (a && b && typeof a === 'object' && typeof b === 'object') {
    return !Object.keys(b).some((key) => !partialMatchKey(a[key], b[key]))
  }

  return false
}

/**
 * This function returns `a` if `b` is deeply equal.
 * If not, it will replace any deeply equal children of `b` with those of `a`.
 * This can be used for structural sharing between JSON values for example.
 */
export function replaceEqualDeep<T>(a: unknown, b: T): T
export function replaceEqualDeep(a: any, b: any): any {
  if (a === b) {
    return a
  }

  const array = isPlainArray(a) && isPlainArray(b)

  if (array || (isPlainObject(a) && isPlainObject(b))) {
    const aItems = array ? a : Object.keys(a)
    const aSize = aItems.length
    const bItems = array ? b : Object.keys(b)
    const bSize = bItems.length
    const copy: any = array ? [] : {}

    let equalItems = 0

    for (let i = 0; i < bSize; i++) {
      const key = array ? i : bItems[i]
      if (
        ((!array && aItems.includes(key)) || array) &&
        a[key] === undefined &&
        b[key] === undefined
      ) {
        copy[key] = undefined
        equalItems++
      } else {
        copy[key] = replaceEqualDeep(a[key], b[key])
        if (copy[key] === a[key] && a[key] !== undefined) {
          equalItems++
        }
      }
    }

    return aSize === bSize && equalItems === aSize ? a : copy
  }

  return b
}

/**
 * Shallow compare objects.
 */
export function shallowEqualObjects<T extends Record<string, any>>(
  a: T,
  b: T | undefined,
): boolean {
  if (!b || Object.keys(a).length !== Object.keys(b).length) {
    return false
  }

  for (const key in a) {
    if (a[key] !== b[key]) {
      return false
    }
  }

  return true
}

export function isPlainArray(value: unknown) {
  return Array.isArray(value) && value.length === Object.keys(value).length
}

// Copied from: https://github.com/jonschlinkert/is-plain-object
// eslint-disable-next-line @typescript-eslint/no-wrapper-object-types
export function isPlainObject(o: any): o is Object {
  if (!hasObjectPrototype(o)) {
    return false
  }

  // If has no constructor
  const ctor = o.constructor
  if (ctor === undefined) {
    return true
  }

  // If has modified prototype
  const prot = ctor.prototype
  if (!hasObjectPrototype(prot)) {
    return false
  }

  // If constructor does not have an Object-specific method
  if (!prot.hasOwnProperty('isPrototypeOf')) {
    return false
  }

  // Handles Objects created by Object.create(<arbitrary prototype>)
  if (Object.getPrototypeOf(o) !== Object.prototype) {
    return false
  }

  // Most likely a plain Object
  return true
}

function hasObjectPrototype(o: any): boolean {
  return Object.prototype.toString.call(o) === '[object Object]'
}

export function sleep(timeout: number): Promise<void> {
  return new Promise((resolve) => {
    setTimeout(resolve, timeout)
  })
}

export function replaceData<
  TData,
  TOptions extends QueryOptions<any, any, any, any>,
>(prevData: TData | undefined, data: TData, options: TOptions): TData {
  if (typeof options.structuralSharing === 'function') {
    return options.structuralSharing(prevData, data) as TData
  } else if (options.structuralSharing !== false) {
    if (process.env.NODE_ENV !== 'production') {
      try {
        return replaceEqualDeep(prevData, data)
      } catch (error) {
        console.error(
          `Structural sharing requires data to be JSON serializable. To fix this, turn off structuralSharing or return JSON-serializable data from your queryFn. [${options.queryHash}]: ${error}`,
        )
      }
    }
    // Structurally share data between prev and new data if needed
    return replaceEqualDeep(prevData, data)
  }
  return data
}

export function keepPreviousData<T>(
  previousData: T | undefined,
): T | undefined {
  return previousData
}

export function addToEnd<T>(items: Array<T>, item: T, max = 0): Array<T> {
  const newItems = [...items, item]
  return max && newItems.length > max ? newItems.slice(1) : newItems
}

export function addToStart<T>(items: Array<T>, item: T, max = 0): Array<T> {
  const newItems = [item, ...items]
  return max && newItems.length > max ? newItems.slice(0, -1) : newItems
}

export const skipToken = Symbol()
export type SkipToken = typeof skipToken

export function ensureQueryFn<
  TQueryFnData = unknown,
  TQueryKey extends QueryKey = QueryKey,
>(
  options: {
    queryFn?: QueryFunction<TQueryFnData, TQueryKey> | SkipToken
    queryHash?: string
  },
  fetchOptions?: FetchOptions<TQueryFnData>,
): QueryFunction<TQueryFnData, TQueryKey> {
  if (process.env.NODE_ENV !== 'production') {
    if (options.queryFn === skipToken) {
      console.error(
        `Attempted to invoke queryFn when set to skipToken. This is likely a configuration error. Query hash: '${options.queryHash}'`,
      )
    }
  }

  // if we attempt to retry a fetch that was triggered from an initialPromise
  // when we don't have a queryFn yet, we can't retry, so we just return the already rejected initialPromise
  // if an observer has already mounted, we will be able to retry with that queryFn
  if (!options.queryFn && fetchOptions?.initialPromise) {
    return () => fetchOptions.initialPromise!
  }

  if (!options.queryFn || options.queryFn === skipToken) {
    return () =>
      Promise.reject(new Error(`Missing queryFn: '${options.queryHash}'`))
  }

  return options.queryFn
}



# ./src/retryer.ts

import { focusManager } from './focusManager'
import { onlineManager } from './onlineManager'
import { pendingThenable } from './thenable'
import { isServer, sleep } from './utils'
import type { CancelOptions, DefaultError, NetworkMode } from './types'

// TYPES

interface RetryerConfig<TData = unknown, TError = DefaultError> {
  fn: () => TData | Promise<TData>
  initialPromise?: Promise<TData>
  abort?: () => void
  onError?: (error: TError) => void
  onSuccess?: (data: TData) => void
  onFail?: (failureCount: number, error: TError) => void
  onPause?: () => void
  onContinue?: () => void
  retry?: RetryValue<TError>
  retryDelay?: RetryDelayValue<TError>
  networkMode: NetworkMode | undefined
  canRun: () => boolean
}

export interface Retryer<TData = unknown> {
  promise: Promise<TData>
  cancel: (cancelOptions?: CancelOptions) => void
  continue: () => Promise<unknown>
  cancelRetry: () => void
  continueRetry: () => void
  canStart: () => boolean
  start: () => Promise<TData>
}

export type RetryValue<TError> = boolean | number | ShouldRetryFunction<TError>

type ShouldRetryFunction<TError = DefaultError> = (
  failureCount: number,
  error: TError,
) => boolean

export type RetryDelayValue<TError> = number | RetryDelayFunction<TError>

type RetryDelayFunction<TError = DefaultError> = (
  failureCount: number,
  error: TError,
) => number

function defaultRetryDelay(failureCount: number) {
  return Math.min(1000 * 2 ** failureCount, 30000)
}

export function canFetch(networkMode: NetworkMode | undefined): boolean {
  return (networkMode ?? 'online') === 'online'
    ? onlineManager.isOnline()
    : true
}

export class CancelledError extends Error {
  revert?: boolean
  silent?: boolean
  constructor(options?: CancelOptions) {
    super('CancelledError')
    this.revert = options?.revert
    this.silent = options?.silent
  }
}

export function isCancelledError(value: any): value is CancelledError {
  return value instanceof CancelledError
}

export function createRetryer<TData = unknown, TError = DefaultError>(
  config: RetryerConfig<TData, TError>,
): Retryer<TData> {
  let isRetryCancelled = false
  let failureCount = 0
  let isResolved = false
  let continueFn: ((value?: unknown) => void) | undefined

  const thenable = pendingThenable<TData>()

  const cancel = (cancelOptions?: CancelOptions): void => {
    if (!isResolved) {
      reject(new CancelledError(cancelOptions))

      config.abort?.()
    }
  }
  const cancelRetry = () => {
    isRetryCancelled = true
  }

  const continueRetry = () => {
    isRetryCancelled = false
  }

  const canContinue = () =>
    focusManager.isFocused() &&
    (config.networkMode === 'always' || onlineManager.isOnline()) &&
    config.canRun()

  const canStart = () => canFetch(config.networkMode) && config.canRun()

  const resolve = (value: any) => {
    if (!isResolved) {
      isResolved = true
      config.onSuccess?.(value)
      continueFn?.()
      thenable.resolve(value)
    }
  }

  const reject = (value: any) => {
    if (!isResolved) {
      isResolved = true
      config.onError?.(value)
      continueFn?.()
      thenable.reject(value)
    }
  }

  const pause = () => {
    return new Promise((continueResolve) => {
      continueFn = (value) => {
        if (isResolved || canContinue()) {
          continueResolve(value)
        }
      }
      config.onPause?.()
    }).then(() => {
      continueFn = undefined
      if (!isResolved) {
        config.onContinue?.()
      }
    })
  }

  // Create loop function
  const run = () => {
    // Do nothing if already resolved
    if (isResolved) {
      return
    }

    let promiseOrValue: any

    // we can re-use config.initialPromise on the first call of run()
    const initialPromise =
      failureCount === 0 ? config.initialPromise : undefined

    // Execute query
    try {
      promiseOrValue = initialPromise ?? config.fn()
    } catch (error) {
      promiseOrValue = Promise.reject(error)
    }

    Promise.resolve(promiseOrValue)
      .then(resolve)
      .catch((error) => {
        // Stop if the fetch is already resolved
        if (isResolved) {
          return
        }

        // Do we need to retry the request?
        const retry = config.retry ?? (isServer ? 0 : 3)
        const retryDelay = config.retryDelay ?? defaultRetryDelay
        const delay =
          typeof retryDelay === 'function'
            ? retryDelay(failureCount, error)
            : retryDelay
        const shouldRetry =
          retry === true ||
          (typeof retry === 'number' && failureCount < retry) ||
          (typeof retry === 'function' && retry(failureCount, error))

        if (isRetryCancelled || !shouldRetry) {
          // We are done if the query does not need to be retried
          reject(error)
          return
        }

        failureCount++

        // Notify on fail
        config.onFail?.(failureCount, error)

        // Delay
        sleep(delay)
          // Pause if the document is not visible or when the device is offline
          .then(() => {
            return canContinue() ? undefined : pause()
          })
          .then(() => {
            if (isRetryCancelled) {
              reject(error)
            } else {
              run()
            }
          })
      })
  }

  return {
    promise: thenable,
    cancel,
    continue: () => {
      continueFn?.()
      return thenable
    },
    cancelRetry,
    continueRetry,
    canStart,
    start: () => {
      // Start loop
      if (canStart()) {
        run()
      } else {
        pause().then(run)
      }
      return thenable
    },
  }
}



# ./src/types.ts

/* istanbul ignore file */

import type { QueryClient } from './queryClient'
import type { DehydrateOptions, HydrateOptions } from './hydration'
import type { MutationState } from './mutation'
import type { FetchDirection, Query, QueryBehavior } from './query'
import type { RetryDelayValue, RetryValue } from './retryer'
import type { QueryFilters, QueryTypeFilter, SkipToken } from './utils'
import type { QueryCache } from './queryCache'
import type { MutationCache } from './mutationCache'

export type OmitKeyof<
  TObject,
  TKey extends TStrictly extends 'safely'
    ?
        | keyof TObject
        | (string & Record<never, never>)
        | (number & Record<never, never>)
        | (symbol & Record<never, never>)
    : keyof TObject,
  TStrictly extends 'strictly' | 'safely' = 'strictly',
> = Omit<TObject, TKey>

export type Override<TTargetA, TTargetB> = {
  [AKey in keyof TTargetA]: AKey extends keyof TTargetB
    ? TTargetB[AKey]
    : TTargetA[AKey]
}

export type NoInfer<T> = [T][T extends any ? 0 : never]

export interface Register {
  // defaultError: Error
  // queryMeta: Record<string, unknown>
  // mutationMeta: Record<string, unknown>
  // queryKey: ReadonlyArray<unknown>
  // mutationKey: ReadonlyArray<unknown>
}

export type DefaultError = Register extends {
  defaultError: infer TError
}
  ? TError
  : Error

export type QueryKey = Register extends {
  queryKey: infer TQueryKey
}
  ? TQueryKey extends ReadonlyArray<unknown>
    ? TQueryKey
    : TQueryKey extends Array<unknown>
      ? TQueryKey
      : ReadonlyArray<unknown>
  : ReadonlyArray<unknown>

export const dataTagSymbol = Symbol('dataTagSymbol')
export type dataTagSymbol = typeof dataTagSymbol
export const dataTagErrorSymbol = Symbol('dataTagErrorSymbol')
export type dataTagErrorSymbol = typeof dataTagErrorSymbol
export const unsetMarker = Symbol('unsetMarker')
export type UnsetMarker = typeof unsetMarker
export type AnyDataTag = {
  [dataTagSymbol]: any
  [dataTagErrorSymbol]: any
}
export type DataTag<
  TType,
  TValue,
  TError = UnsetMarker,
> = TType extends AnyDataTag
  ? TType
  : TType & {
      [dataTagSymbol]: TValue
      [dataTagErrorSymbol]: TError
    }

export type InferDataFromTag<TQueryFnData, TTaggedQueryKey extends QueryKey> =
  TTaggedQueryKey extends DataTag<unknown, infer TaggedValue, unknown>
    ? TaggedValue
    : TQueryFnData

export type InferErrorFromTag<TError, TTaggedQueryKey extends QueryKey> =
  TTaggedQueryKey extends DataTag<unknown, unknown, infer TaggedError>
    ? TaggedError extends UnsetMarker
      ? TError
      : TaggedError
    : TError

export type QueryFunction<
  T = unknown,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = never,
> = (context: QueryFunctionContext<TQueryKey, TPageParam>) => T | Promise<T>

export type StaleTime<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> = number | ((query: Query<TQueryFnData, TError, TData, TQueryKey>) => number)

export type Enabled<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> =
  | boolean
  | ((query: Query<TQueryFnData, TError, TData, TQueryKey>) => boolean)

export type QueryPersister<
  T = unknown,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = never,
> = [TPageParam] extends [never]
  ? (
      queryFn: QueryFunction<T, TQueryKey, never>,
      context: QueryFunctionContext<TQueryKey>,
      query: Query,
    ) => T | Promise<T>
  : (
      queryFn: QueryFunction<T, TQueryKey, TPageParam>,
      context: QueryFunctionContext<TQueryKey>,
      query: Query,
    ) => T | Promise<T>

export type QueryFunctionContext<
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = never,
> = [TPageParam] extends [never]
  ? {
      client: QueryClient
      queryKey: TQueryKey
      signal: AbortSignal
      meta: QueryMeta | undefined
      pageParam?: unknown
      /**
       * @deprecated
       * if you want access to the direction, you can add it to the pageParam
       */
      direction?: unknown
    }
  : {
      client: QueryClient
      queryKey: TQueryKey
      signal: AbortSignal
      pageParam: TPageParam
      /**
       * @deprecated
       * if you want access to the direction, you can add it to the pageParam
       */
      direction: FetchDirection
      meta: QueryMeta | undefined
    }

export type InitialDataFunction<T> = () => T | undefined

type NonFunctionGuard<T> = T extends Function ? never : T

export type PlaceholderDataFunction<
  TQueryFnData = unknown,
  TError = DefaultError,
  TQueryData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> = (
  previousData: TQueryData | undefined,
  previousQuery: Query<TQueryFnData, TError, TQueryData, TQueryKey> | undefined,
) => TQueryData | undefined

export type QueriesPlaceholderDataFunction<TQueryData> = (
  previousData: undefined,
  previousQuery: undefined,
) => TQueryData | undefined

export type QueryKeyHashFunction<TQueryKey extends QueryKey> = (
  queryKey: TQueryKey,
) => string

export type GetPreviousPageParamFunction<TPageParam, TQueryFnData = unknown> = (
  firstPage: TQueryFnData,
  allPages: Array<TQueryFnData>,
  firstPageParam: TPageParam,
  allPageParams: Array<TPageParam>,
) => TPageParam | undefined | null

export type GetNextPageParamFunction<TPageParam, TQueryFnData = unknown> = (
  lastPage: TQueryFnData,
  allPages: Array<TQueryFnData>,
  lastPageParam: TPageParam,
  allPageParams: Array<TPageParam>,
) => TPageParam | undefined | null

export interface InfiniteData<TData, TPageParam = unknown> {
  pages: Array<TData>
  pageParams: Array<TPageParam>
}

export type QueryMeta = Register extends {
  queryMeta: infer TQueryMeta
}
  ? TQueryMeta extends Record<string, unknown>
    ? TQueryMeta
    : Record<string, unknown>
  : Record<string, unknown>

export type NetworkMode = 'online' | 'always' | 'offlineFirst'

export type NotifyOnChangeProps =
  | Array<keyof InfiniteQueryObserverResult>
  | 'all'
  | undefined
  | (() => Array<keyof InfiniteQueryObserverResult> | 'all' | undefined)

export interface QueryOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = never,
> {
  /**
   * If `false`, failed queries will not retry by default.
   * If `true`, failed queries will retry infinitely., failureCount: num
   * If set to an integer number, e.g. 3, failed queries will retry until the failed query count meets that number.
   * If set to a function `(failureCount, error) => boolean` failed queries will retry until the function returns false.
   */
  retry?: RetryValue<TError>
  retryDelay?: RetryDelayValue<TError>
  networkMode?: NetworkMode
  /**
   * The time in milliseconds that unused/inactive cache data remains in memory.
   * When a query's cache becomes unused or inactive, that cache data will be garbage collected after this duration.
   * When different garbage collection times are specified, the longest one will be used.
   * Setting it to `Infinity` will disable garbage collection.
   */
  gcTime?: number
  queryFn?: QueryFunction<TQueryFnData, TQueryKey, TPageParam> | SkipToken
  persister?: QueryPersister<
    NoInfer<TQueryFnData>,
    NoInfer<TQueryKey>,
    NoInfer<TPageParam>
  >
  queryHash?: string
  queryKey?: TQueryKey
  queryKeyHashFn?: QueryKeyHashFunction<TQueryKey>
  initialData?: TData | InitialDataFunction<TData>
  initialDataUpdatedAt?: number | (() => number | undefined)
  behavior?: QueryBehavior<TQueryFnData, TError, TData, TQueryKey>
  /**
   * Set this to `false` to disable structural sharing between query results.
   * Set this to a function which accepts the old and new data and returns resolved data of the same type to implement custom structural sharing logic.
   * Defaults to `true`.
   */
  structuralSharing?:
    | boolean
    | ((oldData: unknown | undefined, newData: unknown) => unknown)
  _defaulted?: boolean
  /**
   * Additional payload to be stored on each query.
   * Use this property to pass information that can be used in other places.
   */
  meta?: QueryMeta
  /**
   * Maximum number of pages to store in the data of an infinite query.
   */
  maxPages?: number
}

export interface InitialPageParam<TPageParam = unknown> {
  initialPageParam: TPageParam
}

export interface InfiniteQueryPageParamsOptions<
  TQueryFnData = unknown,
  TPageParam = unknown,
> extends InitialPageParam<TPageParam> {
  /**
   * This function can be set to automatically get the previous cursor for infinite queries.
   * The result will also be used to determine the value of `hasPreviousPage`.
   */
  getPreviousPageParam?: GetPreviousPageParamFunction<TPageParam, TQueryFnData>
  /**
   * This function can be set to automatically get the next cursor for infinite queries.
   * The result will also be used to determine the value of `hasNextPage`.
   */
  getNextPageParam: GetNextPageParamFunction<TPageParam, TQueryFnData>
}

export type ThrowOnError<
  TQueryFnData,
  TError,
  TQueryData,
  TQueryKey extends QueryKey,
> =
  | boolean
  | ((
      error: TError,
      query: Query<TQueryFnData, TError, TQueryData, TQueryKey>,
    ) => boolean)

export interface QueryObserverOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = never,
> extends WithRequired<
    QueryOptions<TQueryFnData, TError, TQueryData, TQueryKey, TPageParam>,
    'queryKey'
  > {
  /**
   * Set this to `false` or a function that returns `false` to disable automatic refetching when the query mounts or changes query keys.
   * To refetch the query, use the `refetch` method returned from the `useQuery` instance.
   * Accepts a boolean or function that returns a boolean.
   * Defaults to `true`.
   */
  enabled?: Enabled<TQueryFnData, TError, TQueryData, TQueryKey>
  /**
   * The time in milliseconds after data is considered stale.
   * If set to `Infinity`, the data will never be considered stale.
   * If set to a function, the function will be executed with the query to compute a `staleTime`.
   * Defaults to `0`.
   */
  staleTime?: StaleTime<TQueryFnData, TError, TQueryData, TQueryKey>
  /**
   * If set to a number, the query will continuously refetch at this frequency in milliseconds.
   * If set to a function, the function will be executed with the latest data and query to compute a frequency
   * Defaults to `false`.
   */
  refetchInterval?:
    | number
    | false
    | ((
        query: Query<TQueryFnData, TError, TQueryData, TQueryKey>,
      ) => number | false | undefined)
  /**
   * If set to `true`, the query will continue to refetch while their tab/window is in the background.
   * Defaults to `false`.
   */
  refetchIntervalInBackground?: boolean
  /**
   * If set to `true`, the query will refetch on window focus if the data is stale.
   * If set to `false`, the query will not refetch on window focus.
   * If set to `'always'`, the query will always refetch on window focus.
   * If set to a function, the function will be executed with the latest data and query to compute the value.
   * Defaults to `true`.
   */
  refetchOnWindowFocus?:
    | boolean
    | 'always'
    | ((
        query: Query<TQueryFnData, TError, TQueryData, TQueryKey>,
      ) => boolean | 'always')
  /**
   * If set to `true`, the query will refetch on reconnect if the data is stale.
   * If set to `false`, the query will not refetch on reconnect.
   * If set to `'always'`, the query will always refetch on reconnect.
   * If set to a function, the function will be executed with the latest data and query to compute the value.
   * Defaults to the value of `networkOnline` (`true`)
   */
  refetchOnReconnect?:
    | boolean
    | 'always'
    | ((
        query: Query<TQueryFnData, TError, TQueryData, TQueryKey>,
      ) => boolean | 'always')
  /**
   * If set to `true`, the query will refetch on mount if the data is stale.
   * If set to `false`, will disable additional instances of a query to trigger background refetch.
   * If set to `'always'`, the query will always refetch on mount.
   * If set to a function, the function will be executed with the latest data and query to compute the value
   * Defaults to `true`.
   */
  refetchOnMount?:
    | boolean
    | 'always'
    | ((
        query: Query<TQueryFnData, TError, TQueryData, TQueryKey>,
      ) => boolean | 'always')
  /**
   * If set to `false`, the query will not be retried on mount if it contains an error.
   * Defaults to `true`.
   */
  retryOnMount?: boolean
  /**
   * If set, the component will only re-render if any of the listed properties change.
   * When set to `['data', 'error']`, the component will only re-render when the `data` or `error` properties change.
   * When set to `'all'`, the component will re-render whenever a query is updated.
   * When set to a function, the function will be executed to compute the list of properties.
   * By default, access to properties will be tracked, and the component will only re-render when one of the tracked properties change.
   */
  notifyOnChangeProps?: NotifyOnChangeProps
  /**
   * Whether errors should be thrown instead of setting the `error` property.
   * If set to `true` or `suspense` is `true`, all errors will be thrown to the error boundary.
   * If set to `false` and `suspense` is `false`, errors are returned as state.
   * If set to a function, it will be passed the error and the query, and it should return a boolean indicating whether to show the error in an error boundary (`true`) or return the error as state (`false`).
   * Defaults to `false`.
   */
  throwOnError?: ThrowOnError<TQueryFnData, TError, TQueryData, TQueryKey>
  /**
   * This option can be used to transform or select a part of the data returned by the query function.
   */
  select?: (data: TQueryData) => TData
  /**
   * If set to `true`, the query will suspend when `status === 'pending'`
   * and throw errors when `status === 'error'`.
   * Defaults to `false`.
   */
  suspense?: boolean
  /**
   * If set, this value will be used as the placeholder data for this particular query observer while the query is still in the `loading` data and no initialData has been provided.
   */
  placeholderData?:
    | NonFunctionGuard<TQueryData>
    | PlaceholderDataFunction<
        NonFunctionGuard<TQueryData>,
        TError,
        NonFunctionGuard<TQueryData>,
        TQueryKey
      >

  _optimisticResults?: 'optimistic' | 'isRestoring'

  /**
   * Enable prefetching during rendering
   */
  experimental_prefetchInRender?: boolean
}

export type WithRequired<TTarget, TKey extends keyof TTarget> = TTarget & {
  [_ in TKey]: {}
}
export type Optional<TTarget, TKey extends keyof TTarget> = Pick<
  Partial<TTarget>,
  TKey
> &
  OmitKeyof<TTarget, TKey>

export type DefaultedQueryObserverOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> = WithRequired<
  QueryObserverOptions<TQueryFnData, TError, TData, TQueryData, TQueryKey>,
  'throwOnError' | 'refetchOnReconnect' | 'queryHash'
>

export interface InfiniteQueryObserverOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = unknown,
> extends QueryObserverOptions<
      TQueryFnData,
      TError,
      TData,
      InfiniteData<TQueryData, TPageParam>,
      TQueryKey,
      TPageParam
    >,
    InfiniteQueryPageParamsOptions<TQueryFnData, TPageParam> {}

export type DefaultedInfiniteQueryObserverOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = unknown,
> = WithRequired<
  InfiniteQueryObserverOptions<
    TQueryFnData,
    TError,
    TData,
    TQueryData,
    TQueryKey,
    TPageParam
  >,
  'throwOnError' | 'refetchOnReconnect' | 'queryHash'
>

export interface FetchQueryOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = never,
> extends WithRequired<
    QueryOptions<TQueryFnData, TError, TData, TQueryKey, TPageParam>,
    'queryKey'
  > {
  initialPageParam?: never
  /**
   * The time in milliseconds after data is considered stale.
   * If the data is fresh it will be returned from the cache.
   */
  staleTime?: StaleTime<TQueryFnData, TError, TData, TQueryKey>
}

export interface EnsureQueryDataOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = never,
> extends FetchQueryOptions<
    TQueryFnData,
    TError,
    TData,
    TQueryKey,
    TPageParam
  > {
  revalidateIfStale?: boolean
}

export type EnsureInfiniteQueryDataOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = unknown,
> = FetchInfiniteQueryOptions<
  TQueryFnData,
  TError,
  TData,
  TQueryKey,
  TPageParam
> & {
  revalidateIfStale?: boolean
}

type FetchInfiniteQueryPages<TQueryFnData = unknown, TPageParam = unknown> =
  | { pages?: never }
  | {
      pages: number
      getNextPageParam: GetNextPageParamFunction<TPageParam, TQueryFnData>
    }

export type FetchInfiniteQueryOptions<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
  TPageParam = unknown,
> = Omit<
  FetchQueryOptions<
    TQueryFnData,
    TError,
    InfiniteData<TData, TPageParam>,
    TQueryKey,
    TPageParam
  >,
  'initialPageParam'
> &
  InitialPageParam<TPageParam> &
  FetchInfiniteQueryPages<TQueryFnData, TPageParam>

export interface ResultOptions {
  throwOnError?: boolean
}

export interface RefetchOptions extends ResultOptions {
  /**
   * If set to `true`, a currently running request will be cancelled before a new request is made
   *
   * If set to `false`, no refetch will be made if there is already a request running.
   *
   * Defaults to `true`.
   */
  cancelRefetch?: boolean
}

export interface InvalidateQueryFilters<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> extends QueryFilters<TQueryFnData, TError, TData, TQueryKey> {
  refetchType?: QueryTypeFilter | 'none'
}

export interface RefetchQueryFilters<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> extends QueryFilters<TQueryFnData, TError, TData, TQueryKey> {}

export interface InvalidateOptions extends RefetchOptions {}
export interface ResetOptions extends RefetchOptions {}

export interface FetchNextPageOptions extends ResultOptions {
  /**
   * If set to `true`, calling `fetchNextPage` repeatedly will invoke `queryFn` every time,
   * whether the previous invocation has resolved or not. Also, the result from previous invocations will be ignored.
   *
   * If set to `false`, calling `fetchNextPage` repeatedly won't have any effect until the first invocation has resolved.
   *
   * Defaults to `true`.
   */
  cancelRefetch?: boolean
}

export interface FetchPreviousPageOptions extends ResultOptions {
  /**
   * If set to `true`, calling `fetchPreviousPage` repeatedly will invoke `queryFn` every time,
   * whether the previous invocation has resolved or not. Also, the result from previous invocations will be ignored.
   *
   * If set to `false`, calling `fetchPreviousPage` repeatedly won't have any effect until the first invocation has resolved.
   *
   * Defaults to `true`.
   */
  cancelRefetch?: boolean
}

export type QueryStatus = 'pending' | 'error' | 'success'
export type FetchStatus = 'fetching' | 'paused' | 'idle'

export interface QueryObserverBaseResult<
  TData = unknown,
  TError = DefaultError,
> {
  /**
   * The last successfully resolved data for the query.
   */
  data: TData | undefined
  /**
   * The timestamp for when the query most recently returned the `status` as `"success"`.
   */
  dataUpdatedAt: number
  /**
   * The error object for the query, if an error was thrown.
   * - Defaults to `null`.
   */
  error: TError | null
  /**
   * The timestamp for when the query most recently returned the `status` as `"error"`.
   */
  errorUpdatedAt: number
  /**
   * The failure count for the query.
   * - Incremented every time the query fails.
   * - Reset to `0` when the query succeeds.
   */
  failureCount: number
  /**
   * The failure reason for the query retry.
   * - Reset to `null` when the query succeeds.
   */
  failureReason: TError | null
  /**
   * The sum of all errors.
   */
  errorUpdateCount: number
  /**
   * A derived boolean from the `status` variable, provided for convenience.
   * - `true` if the query attempt resulted in an error.
   */
  isError: boolean
  /**
   * Will be `true` if the query has been fetched.
   */
  isFetched: boolean
  /**
   * Will be `true` if the query has been fetched after the component mounted.
   * - This property can be used to not show any previously cached data.
   */
  isFetchedAfterMount: boolean
  /**
   * A derived boolean from the `fetchStatus` variable, provided for convenience.
   * - `true` whenever the `queryFn` is executing, which includes initial `pending` as well as background refetch.
   */
  isFetching: boolean
  /**
   * Is `true` whenever the first fetch for a query is in-flight.
   * - Is the same as `isFetching && isPending`.
   */
  isLoading: boolean
  /**
   * Will be `pending` if there's no cached data and no query attempt was finished yet.
   */
  isPending: boolean
  /**
   * Will be `true` if the query failed while fetching for the first time.
   */
  isLoadingError: boolean
  /**
   * @deprecated `isInitialLoading` is being deprecated in favor of `isLoading`
   * and will be removed in the next major version.
   */
  isInitialLoading: boolean
  /**
   * A derived boolean from the `fetchStatus` variable, provided for convenience.
   * - The query wanted to fetch, but has been `paused`.
   */
  isPaused: boolean
  /**
   * Will be `true` if the data shown is the placeholder data.
   */
  isPlaceholderData: boolean
  /**
   * Will be `true` if the query failed while refetching.
   */
  isRefetchError: boolean
  /**
   * Is `true` whenever a background refetch is in-flight, which _does not_ include initial `pending`.
   * - Is the same as `isFetching && !isPending`.
   */
  isRefetching: boolean
  /**
   * Will be `true` if the data in the cache is invalidated or if the data is older than the given `staleTime`.
   */
  isStale: boolean
  /**
   * A derived boolean from the `status` variable, provided for convenience.
   * - `true` if the query has received a response with no errors and is ready to display its data.
   */
  isSuccess: boolean
  /**
   * A function to manually refetch the query.
   */
  refetch: (
    options?: RefetchOptions,
  ) => Promise<QueryObserverResult<TData, TError>>
  /**
   * The status of the query.
   * - Will be:
   *   - `pending` if there's no cached data and no query attempt was finished yet.
   *   - `error` if the query attempt resulted in an error.
   *   - `success` if the query has received a response with no errors and is ready to display its data.
   */
  status: QueryStatus
  /**
   * The fetch status of the query.
   * - `fetching`: Is `true` whenever the queryFn is executing, which includes initial `pending` as well as background refetch.
   * - `paused`: The query wanted to fetch, but has been `paused`.
   * - `idle`: The query is not fetching.
   * - See [Network Mode](https://tanstack.com/query/latest/docs/framework/react/guides/network-mode) for more information.
   */
  fetchStatus: FetchStatus
  /**
   * A stable promise that will be resolved with the data of the query.
   * Requires the `experimental_prefetchInRender` feature flag to be enabled.
   * @example
   *
   * ### Enabling the feature flag
   * ```ts
   * const client = new QueryClient({
   *   defaultOptions: {
   *     queries: {
   *       experimental_prefetchInRender: true,
   *     },
   *   },
   * })
   * ```
   *
   * ### Usage
   * ```tsx
   * import { useQuery } from '@tanstack/react-query'
   * import React from 'react'
   * import { fetchTodos, type Todo } from './api'
   *
   * function TodoList({ query }: { query: UseQueryResult<Todo[], Error> }) {
   *   const data = React.use(query.promise)
   *
   *   return (
   *     <ul>
   *       {data.map(todo => (
   *         <li key={todo.id}>{todo.title}</li>
   *       ))}
   *     </ul>
   *   )
   * }
   *
   * export function App() {
   *   const query = useQuery({ queryKey: ['todos'], queryFn: fetchTodos })
   *
   *   return (
   *     <>
   *       <h1>Todos</h1>
   *       <React.Suspense fallback={<div>Loading...</div>}>
   *         <TodoList query={query} />
   *       </React.Suspense>
   *     </>
   *   )
   * }
   * ```
   */
  promise: Promise<TData>
}

export interface QueryObserverPendingResult<
  TData = unknown,
  TError = DefaultError,
> extends QueryObserverBaseResult<TData, TError> {
  data: undefined
  error: null
  isError: false
  isPending: true
  isLoadingError: false
  isRefetchError: false
  isSuccess: false
  isPlaceholderData: false
  status: 'pending'
}

export interface QueryObserverLoadingResult<
  TData = unknown,
  TError = DefaultError,
> extends QueryObserverBaseResult<TData, TError> {
  data: undefined
  error: null
  isError: false
  isPending: true
  isLoading: true
  isLoadingError: false
  isRefetchError: false
  isSuccess: false
  isPlaceholderData: false
  status: 'pending'
}

export interface QueryObserverLoadingErrorResult<
  TData = unknown,
  TError = DefaultError,
> extends QueryObserverBaseResult<TData, TError> {
  data: undefined
  error: TError
  isError: true
  isPending: false
  isLoading: false
  isLoadingError: true
  isRefetchError: false
  isSuccess: false
  isPlaceholderData: false
  status: 'error'
}

export interface QueryObserverRefetchErrorResult<
  TData = unknown,
  TError = DefaultError,
> extends QueryObserverBaseResult<TData, TError> {
  data: TData
  error: TError
  isError: true
  isPending: false
  isLoading: false
  isLoadingError: false
  isRefetchError: true
  isSuccess: false
  isPlaceholderData: false
  status: 'error'
}

export interface QueryObserverSuccessResult<
  TData = unknown,
  TError = DefaultError,
> extends QueryObserverBaseResult<TData, TError> {
  data: TData
  error: null
  isError: false
  isPending: false
  isLoading: false
  isLoadingError: false
  isRefetchError: false
  isSuccess: true
  isPlaceholderData: false
  status: 'success'
}

export interface QueryObserverPlaceholderResult<
  TData = unknown,
  TError = DefaultError,
> extends QueryObserverBaseResult<TData, TError> {
  data: TData
  isError: false
  error: null
  isPending: false
  isLoading: false
  isLoadingError: false
  isRefetchError: false
  isSuccess: true
  isPlaceholderData: true
  status: 'success'
}

export type DefinedQueryObserverResult<
  TData = unknown,
  TError = DefaultError,
> =
  | QueryObserverRefetchErrorResult<TData, TError>
  | QueryObserverSuccessResult<TData, TError>

export type QueryObserverResult<TData = unknown, TError = DefaultError> =
  | DefinedQueryObserverResult<TData, TError>
  | QueryObserverLoadingErrorResult<TData, TError>
  | QueryObserverLoadingResult<TData, TError>
  | QueryObserverPendingResult<TData, TError>
  | QueryObserverPlaceholderResult<TData, TError>

export interface InfiniteQueryObserverBaseResult<
  TData = unknown,
  TError = DefaultError,
> extends QueryObserverBaseResult<TData, TError> {
  /**
   * This function allows you to fetch the next "page" of results.
   */
  fetchNextPage: (
    options?: FetchNextPageOptions,
  ) => Promise<InfiniteQueryObserverResult<TData, TError>>
  /**
   * This function allows you to fetch the previous "page" of results.
   */
  fetchPreviousPage: (
    options?: FetchPreviousPageOptions,
  ) => Promise<InfiniteQueryObserverResult<TData, TError>>
  /**
   * Will be `true` if there is a next page to be fetched (known via the `getNextPageParam` option).
   */
  hasNextPage: boolean
  /**
   * Will be `true` if there is a previous page to be fetched (known via the `getPreviousPageParam` option).
   */
  hasPreviousPage: boolean
  /**
   * Will be `true` if the query failed while fetching the next page.
   */
  isFetchNextPageError: boolean
  /**
   * Will be `true` while fetching the next page with `fetchNextPage`.
   */
  isFetchingNextPage: boolean
  /**
   * Will be `true` if the query failed while fetching the previous page.
   */
  isFetchPreviousPageError: boolean
  /**
   * Will be `true` while fetching the previous page with `fetchPreviousPage`.
   */
  isFetchingPreviousPage: boolean
}

export interface InfiniteQueryObserverPendingResult<
  TData = unknown,
  TError = DefaultError,
> extends InfiniteQueryObserverBaseResult<TData, TError> {
  data: undefined
  error: null
  isError: false
  isPending: true
  isLoadingError: false
  isRefetchError: false
  isFetchNextPageError: false
  isFetchPreviousPageError: false
  isSuccess: false
  isPlaceholderData: false
  status: 'pending'
}

export interface InfiniteQueryObserverLoadingResult<
  TData = unknown,
  TError = DefaultError,
> extends InfiniteQueryObserverBaseResult<TData, TError> {
  data: undefined
  error: null
  isError: false
  isPending: true
  isLoading: true
  isLoadingError: false
  isRefetchError: false
  isFetchNextPageError: false
  isFetchPreviousPageError: false
  isSuccess: false
  isPlaceholderData: false
  status: 'pending'
}

export interface InfiniteQueryObserverLoadingErrorResult<
  TData = unknown,
  TError = DefaultError,
> extends InfiniteQueryObserverBaseResult<TData, TError> {
  data: undefined
  error: TError
  isError: true
  isPending: false
  isLoading: false
  isLoadingError: true
  isRefetchError: false
  isFetchNextPageError: false
  isFetchPreviousPageError: false
  isSuccess: false
  isPlaceholderData: false
  status: 'error'
}

export interface InfiniteQueryObserverRefetchErrorResult<
  TData = unknown,
  TError = DefaultError,
> extends InfiniteQueryObserverBaseResult<TData, TError> {
  data: TData
  error: TError
  isError: true
  isPending: false
  isLoading: false
  isLoadingError: false
  isRefetchError: true
  isSuccess: false
  isPlaceholderData: false
  status: 'error'
}

export interface InfiniteQueryObserverSuccessResult<
  TData = unknown,
  TError = DefaultError,
> extends InfiniteQueryObserverBaseResult<TData, TError> {
  data: TData
  error: null
  isError: false
  isPending: false
  isLoading: false
  isLoadingError: false
  isRefetchError: false
  isFetchNextPageError: false
  isFetchPreviousPageError: false
  isSuccess: true
  isPlaceholderData: false
  status: 'success'
}

export interface InfiniteQueryObserverPlaceholderResult<
  TData = unknown,
  TError = DefaultError,
> extends InfiniteQueryObserverBaseResult<TData, TError> {
  data: TData
  isError: false
  error: null
  isPending: false
  isLoading: false
  isLoadingError: false
  isRefetchError: false
  isSuccess: true
  isPlaceholderData: true
  isFetchNextPageError: false
  isFetchPreviousPageError: false
  status: 'success'
}

export type DefinedInfiniteQueryObserverResult<
  TData = unknown,
  TError = DefaultError,
> =
  | InfiniteQueryObserverRefetchErrorResult<TData, TError>
  | InfiniteQueryObserverSuccessResult<TData, TError>

export type InfiniteQueryObserverResult<
  TData = unknown,
  TError = DefaultError,
> =
  | DefinedInfiniteQueryObserverResult<TData, TError>
  | InfiniteQueryObserverLoadingErrorResult<TData, TError>
  | InfiniteQueryObserverLoadingResult<TData, TError>
  | InfiniteQueryObserverPendingResult<TData, TError>
  | InfiniteQueryObserverPlaceholderResult<TData, TError>

export type MutationKey = Register extends {
  mutationKey: infer TMutationKey
}
  ? TMutationKey extends Array<unknown>
    ? TMutationKey
    : TMutationKey extends Array<unknown>
      ? TMutationKey
      : ReadonlyArray<unknown>
  : ReadonlyArray<unknown>

export type MutationStatus = 'idle' | 'pending' | 'success' | 'error'

export type MutationScope = {
  id: string
}

export type MutationMeta = Register extends {
  mutationMeta: infer TMutationMeta
}
  ? TMutationMeta extends Record<string, unknown>
    ? TMutationMeta
    : Record<string, unknown>
  : Record<string, unknown>

export type MutationFunction<TData = unknown, TVariables = unknown> = (
  variables: TVariables,
) => Promise<TData>

export interface MutationOptions<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
> {
  mutationFn?: MutationFunction<TData, TVariables>
  mutationKey?: MutationKey
  onMutate?: (
    variables: TVariables,
  ) => Promise<TContext | undefined> | TContext | undefined
  onSuccess?: (
    data: TData,
    variables: TVariables,
    context: TContext,
  ) => Promise<unknown> | unknown
  onError?: (
    error: TError,
    variables: TVariables,
    context: TContext | undefined,
  ) => Promise<unknown> | unknown
  onSettled?: (
    data: TData | undefined,
    error: TError | null,
    variables: TVariables,
    context: TContext | undefined,
  ) => Promise<unknown> | unknown
  retry?: RetryValue<TError>
  retryDelay?: RetryDelayValue<TError>
  networkMode?: NetworkMode
  gcTime?: number
  _defaulted?: boolean
  meta?: MutationMeta
  scope?: MutationScope
}

export interface MutationObserverOptions<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
> extends MutationOptions<TData, TError, TVariables, TContext> {
  throwOnError?: boolean | ((error: TError) => boolean)
}

export interface MutateOptions<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
> {
  onSuccess?: (data: TData, variables: TVariables, context: TContext) => void
  onError?: (
    error: TError,
    variables: TVariables,
    context: TContext | undefined,
  ) => void
  onSettled?: (
    data: TData | undefined,
    error: TError | null,
    variables: TVariables,
    context: TContext | undefined,
  ) => void
}

export type MutateFunction<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
> = (
  variables: TVariables,
  options?: MutateOptions<TData, TError, TVariables, TContext>,
) => Promise<TData>

export interface MutationObserverBaseResult<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
> extends MutationState<TData, TError, TVariables, TContext> {
  /**
   * The last successfully resolved data for the mutation.
   */
  data: TData | undefined
  /**
   * The variables object passed to the `mutationFn`.
   */
  variables: TVariables | undefined
  /**
   * The error object for the mutation, if an error was encountered.
   * - Defaults to `null`.
   */
  error: TError | null
  /**
   * A boolean variable derived from `status`.
   * - `true` if the last mutation attempt resulted in an error.
   */
  isError: boolean
  /**
   * A boolean variable derived from `status`.
   * - `true` if the mutation is in its initial state prior to executing.
   */
  isIdle: boolean
  /**
   * A boolean variable derived from `status`.
   * - `true` if the mutation is currently executing.
   */
  isPending: boolean
  /**
   * A boolean variable derived from `status`.
   * - `true` if the last mutation attempt was successful.
   */
  isSuccess: boolean
  /**
   * The status of the mutation.
   * - Will be:
   *   - `idle` initial status prior to the mutation function executing.
   *   - `pending` if the mutation is currently executing.
   *   - `error` if the last mutation attempt resulted in an error.
   *   - `success` if the last mutation attempt was successful.
   */
  status: MutationStatus
  /**
   * The mutation function you can call with variables to trigger the mutation and optionally hooks on additional callback options.
   * @param variables - The variables object to pass to the `mutationFn`.
   * @param options.onSuccess - This function will fire when the mutation is successful and will be passed the mutation's result.
   * @param options.onError - This function will fire if the mutation encounters an error and will be passed the error.
   * @param options.onSettled - This function will fire when the mutation is either successfully fetched or encounters an error and be passed either the data or error.
   * @remarks
   * - If you make multiple requests, `onSuccess` will fire only after the latest call you've made.
   * - All the callback functions (`onSuccess`, `onError`, `onSettled`) are void functions, and the returned value will be ignored.
   */
  mutate: MutateFunction<TData, TError, TVariables, TContext>
  /**
   * A function to clean the mutation internal state (i.e., it resets the mutation to its initial state).
   */
  reset: () => void
}

export interface MutationObserverIdleResult<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
> extends MutationObserverBaseResult<TData, TError, TVariables, TContext> {
  data: undefined
  variables: undefined
  error: null
  isError: false
  isIdle: true
  isPending: false
  isSuccess: false
  status: 'idle'
}

export interface MutationObserverLoadingResult<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
> extends MutationObserverBaseResult<TData, TError, TVariables, TContext> {
  data: undefined
  variables: TVariables
  error: null
  isError: false
  isIdle: false
  isPending: true
  isSuccess: false
  status: 'pending'
}

export interface MutationObserverErrorResult<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
> extends MutationObserverBaseResult<TData, TError, TVariables, TContext> {
  data: undefined
  error: TError
  variables: TVariables
  isError: true
  isIdle: false
  isPending: false
  isSuccess: false
  status: 'error'
}

export interface MutationObserverSuccessResult<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
> extends MutationObserverBaseResult<TData, TError, TVariables, TContext> {
  data: TData
  error: null
  variables: TVariables
  isError: false
  isIdle: false
  isPending: false
  isSuccess: true
  status: 'success'
}

export type MutationObserverResult<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
> =
  | MutationObserverIdleResult<TData, TError, TVariables, TContext>
  | MutationObserverLoadingResult<TData, TError, TVariables, TContext>
  | MutationObserverErrorResult<TData, TError, TVariables, TContext>
  | MutationObserverSuccessResult<TData, TError, TVariables, TContext>

export interface QueryClientConfig {
  queryCache?: QueryCache
  mutationCache?: MutationCache
  defaultOptions?: DefaultOptions
}

export interface DefaultOptions<TError = DefaultError> {
  queries?: OmitKeyof<
    QueryObserverOptions<unknown, TError>,
    'suspense' | 'queryKey'
  >
  mutations?: MutationObserverOptions<unknown, TError, unknown, unknown>
  hydrate?: HydrateOptions['defaultOptions']
  dehydrate?: DehydrateOptions
}

export interface CancelOptions {
  revert?: boolean
  silent?: boolean
}

export interface SetDataOptions {
  updatedAt?: number
}

export type NotifyEventType =
  | 'added'
  | 'removed'
  | 'updated'
  | 'observerAdded'
  | 'observerRemoved'
  | 'observerResultsUpdated'
  | 'observerOptionsUpdated'

export interface NotifyEvent {
  type: NotifyEventType
}



# ./src/onlineManager.ts

import { Subscribable } from './subscribable'
import { isServer } from './utils'

type Listener = (online: boolean) => void
type SetupFn = (setOnline: Listener) => (() => void) | undefined

export class OnlineManager extends Subscribable<Listener> {
  #online = true
  #cleanup?: () => void

  #setup: SetupFn

  constructor() {
    super()
    this.#setup = (onOnline) => {
      // addEventListener does not exist in React Native, but window does
      // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
      if (!isServer && window.addEventListener) {
        const onlineListener = () => onOnline(true)
        const offlineListener = () => onOnline(false)
        // Listen to online
        window.addEventListener('online', onlineListener, false)
        window.addEventListener('offline', offlineListener, false)

        return () => {
          // Be sure to unsubscribe if a new handler is set
          window.removeEventListener('online', onlineListener)
          window.removeEventListener('offline', offlineListener)
        }
      }

      return
    }
  }

  protected onSubscribe(): void {
    if (!this.#cleanup) {
      this.setEventListener(this.#setup)
    }
  }

  protected onUnsubscribe() {
    if (!this.hasListeners()) {
      this.#cleanup?.()
      this.#cleanup = undefined
    }
  }

  setEventListener(setup: SetupFn): void {
    this.#setup = setup
    this.#cleanup?.()
    this.#cleanup = setup(this.setOnline.bind(this))
  }

  setOnline(online: boolean): void {
    const changed = this.#online !== online

    if (changed) {
      this.#online = online
      this.listeners.forEach((listener) => {
        listener(online)
      })
    }
  }

  isOnline(): boolean {
    return this.#online
  }
}

export const onlineManager = new OnlineManager()



# ./src/removable.ts

import { isServer, isValidTimeout } from './utils'

export abstract class Removable {
  gcTime!: number
  #gcTimeout?: ReturnType<typeof setTimeout>

  destroy(): void {
    this.clearGcTimeout()
  }

  protected scheduleGc(): void {
    this.clearGcTimeout()

    if (isValidTimeout(this.gcTime)) {
      this.#gcTimeout = setTimeout(() => {
        this.optionalRemove()
      }, this.gcTime)
    }
  }

  protected updateGcTime(newGcTime: number | undefined): void {
    // Default to 5 minutes (Infinity for server-side) if no gcTime is set
    this.gcTime = Math.max(
      this.gcTime || 0,
      newGcTime ?? (isServer ? Infinity : 5 * 60 * 1000),
    )
  }

  protected clearGcTimeout() {
    if (this.#gcTimeout) {
      clearTimeout(this.#gcTimeout)
      this.#gcTimeout = undefined
    }
  }

  protected abstract optionalRemove(): void
}



# ./src/queryClient.ts

import {
  functionalUpdate,
  hashKey,
  hashQueryKeyByOptions,
  noop,
  partialMatchKey,
  resolveStaleTime,
  skipToken,
} from './utils'
import { QueryCache } from './queryCache'
import { MutationCache } from './mutationCache'
import { focusManager } from './focusManager'
import { onlineManager } from './onlineManager'
import { notifyManager } from './notifyManager'
import { infiniteQueryBehavior } from './infiniteQueryBehavior'
import type {
  CancelOptions,
  DefaultError,
  DefaultOptions,
  DefaultedQueryObserverOptions,
  EnsureInfiniteQueryDataOptions,
  EnsureQueryDataOptions,
  FetchInfiniteQueryOptions,
  FetchQueryOptions,
  InferDataFromTag,
  InferErrorFromTag,
  InfiniteData,
  InvalidateOptions,
  InvalidateQueryFilters,
  MutationKey,
  MutationObserverOptions,
  MutationOptions,
  NoInfer,
  OmitKeyof,
  QueryClientConfig,
  QueryKey,
  QueryObserverOptions,
  QueryOptions,
  RefetchOptions,
  RefetchQueryFilters,
  ResetOptions,
  SetDataOptions,
} from './types'
import type { QueryState } from './query'
import type { MutationFilters, QueryFilters, Updater } from './utils'

// TYPES

interface QueryDefaults {
  queryKey: QueryKey
  defaultOptions: OmitKeyof<QueryOptions<any, any, any>, 'queryKey'>
}

interface MutationDefaults {
  mutationKey: MutationKey
  defaultOptions: MutationOptions<any, any, any, any>
}

// CLASS

export class QueryClient {
  #queryCache: QueryCache
  #mutationCache: MutationCache
  #defaultOptions: DefaultOptions
  #queryDefaults: Map<string, QueryDefaults>
  #mutationDefaults: Map<string, MutationDefaults>
  #mountCount: number
  #unsubscribeFocus?: () => void
  #unsubscribeOnline?: () => void

  constructor(config: QueryClientConfig = {}) {
    this.#queryCache = config.queryCache || new QueryCache()
    this.#mutationCache = config.mutationCache || new MutationCache()
    this.#defaultOptions = config.defaultOptions || {}
    this.#queryDefaults = new Map()
    this.#mutationDefaults = new Map()
    this.#mountCount = 0
  }

  mount(): void {
    this.#mountCount++
    if (this.#mountCount !== 1) return

    this.#unsubscribeFocus = focusManager.subscribe(async (focused) => {
      if (focused) {
        await this.resumePausedMutations()
        this.#queryCache.onFocus()
      }
    })
    this.#unsubscribeOnline = onlineManager.subscribe(async (online) => {
      if (online) {
        await this.resumePausedMutations()
        this.#queryCache.onOnline()
      }
    })
  }

  unmount(): void {
    this.#mountCount--
    if (this.#mountCount !== 0) return

    this.#unsubscribeFocus?.()
    this.#unsubscribeFocus = undefined

    this.#unsubscribeOnline?.()
    this.#unsubscribeOnline = undefined
  }

  isFetching<
    TQueryFilters extends QueryFilters<any, any, any, any> = QueryFilters,
  >(filters?: TQueryFilters): number {
    return this.#queryCache.findAll({ ...filters, fetchStatus: 'fetching' })
      .length
  }

  isMutating<
    TMutationFilters extends MutationFilters<any, any> = MutationFilters,
  >(filters?: TMutationFilters): number {
    return this.#mutationCache.findAll({ ...filters, status: 'pending' }).length
  }

  getQueryData<
    TQueryFnData = unknown,
    TTaggedQueryKey extends QueryKey = QueryKey,
    TInferredQueryFnData = InferDataFromTag<TQueryFnData, TTaggedQueryKey>,
  >(queryKey: TTaggedQueryKey): TInferredQueryFnData | undefined {
    const options = this.defaultQueryOptions({ queryKey })

    return this.#queryCache.get(options.queryHash)?.state.data as
      | TInferredQueryFnData
      | undefined
  }

  ensureQueryData<
    TQueryFnData,
    TError = DefaultError,
    TData = TQueryFnData,
    TQueryKey extends QueryKey = QueryKey,
  >(
    options: EnsureQueryDataOptions<TQueryFnData, TError, TData, TQueryKey>,
  ): Promise<TData> {
    const defaultedOptions = this.defaultQueryOptions(options)
    const query = this.#queryCache.build(this, defaultedOptions)
    const cachedData = query.state.data

    if (cachedData === undefined) {
      return this.fetchQuery(options)
    }

    if (
      options.revalidateIfStale &&
      query.isStaleByTime(resolveStaleTime(defaultedOptions.staleTime, query))
    ) {
      void this.prefetchQuery(defaultedOptions)
    }

    return Promise.resolve(cachedData)
  }

  getQueriesData<
    TQueryFnData = unknown,
    TQueryFilters extends QueryFilters<
      any,
      any,
      any,
      any
    > = QueryFilters<TQueryFnData>,
    TInferredQueryFnData = TQueryFilters extends QueryFilters<
      infer TData,
      any,
      any,
      any
    >
      ? TData
      : TQueryFnData,
  >(
    filters: TQueryFilters,
  ): Array<[QueryKey, TInferredQueryFnData | undefined]> {
    return this.#queryCache.findAll(filters).map(({ queryKey, state }) => {
      const data = state.data as TInferredQueryFnData | undefined
      return [queryKey, data]
    })
  }

  setQueryData<
    TQueryFnData = unknown,
    TTaggedQueryKey extends QueryKey = QueryKey,
    TInferredQueryFnData = InferDataFromTag<TQueryFnData, TTaggedQueryKey>,
  >(
    queryKey: TTaggedQueryKey,
    updater: Updater<
      NoInfer<TInferredQueryFnData> | undefined,
      NoInfer<TInferredQueryFnData> | undefined
    >,
    options?: SetDataOptions,
  ): TInferredQueryFnData | undefined {
    const defaultedOptions = this.defaultQueryOptions<
      any,
      any,
      unknown,
      any,
      QueryKey
    >({ queryKey })

    const query = this.#queryCache.get<TInferredQueryFnData>(
      defaultedOptions.queryHash,
    )
    const prevData = query?.state.data
    const data = functionalUpdate(updater, prevData)

    if (data === undefined) {
      return undefined
    }

    return this.#queryCache
      .build(this, defaultedOptions)
      .setData(data, { ...options, manual: true })
  }

  setQueriesData<
    TQueryFnData,
    TQueryFilters extends QueryFilters<
      any,
      any,
      any,
      any
    > = QueryFilters<TQueryFnData>,
    TInferredQueryFnData = TQueryFilters extends QueryFilters<
      infer TData,
      any,
      any,
      any
    >
      ? TData
      : TQueryFnData,
  >(
    filters: TQueryFilters,
    updater: Updater<
      NoInfer<TInferredQueryFnData> | undefined,
      NoInfer<TInferredQueryFnData> | undefined
    >,
    options?: SetDataOptions,
  ): Array<[QueryKey, TInferredQueryFnData | undefined]> {
    return notifyManager.batch(() =>
      this.#queryCache
        .findAll(filters)
        .map(({ queryKey }) => [
          queryKey,
          this.setQueryData<TInferredQueryFnData>(queryKey, updater, options),
        ]),
    )
  }

  getQueryState<
    TQueryFnData = unknown,
    TError = DefaultError,
    TTaggedQueryKey extends QueryKey = QueryKey,
    TInferredQueryFnData = InferDataFromTag<TQueryFnData, TTaggedQueryKey>,
    TInferredError = InferErrorFromTag<TError, TTaggedQueryKey>,
  >(
    queryKey: TTaggedQueryKey,
  ): QueryState<TInferredQueryFnData, TInferredError> | undefined {
    const options = this.defaultQueryOptions({ queryKey })
    return this.#queryCache.get<TInferredQueryFnData, TInferredError>(
      options.queryHash,
    )?.state
  }

  removeQueries<
    TQueryFnData = unknown,
    TError = DefaultError,
    TTaggedQueryKey extends QueryKey = QueryKey,
    TInferredQueryFnData = InferDataFromTag<TQueryFnData, TTaggedQueryKey>,
    TInferredError = InferErrorFromTag<TError, TTaggedQueryKey>,
  >(
    filters?: QueryFilters<
      TInferredQueryFnData,
      TInferredError,
      TInferredQueryFnData,
      TTaggedQueryKey
    >,
  ): void {
    const queryCache = this.#queryCache
    notifyManager.batch(() => {
      queryCache.findAll(filters).forEach((query) => {
        queryCache.remove(query)
      })
    })
  }

  resetQueries<
    TQueryFnData = unknown,
    TError = DefaultError,
    TTaggedQueryKey extends QueryKey = QueryKey,
    TInferredQueryFnData = InferDataFromTag<TQueryFnData, TTaggedQueryKey>,
    TInferredError = InferErrorFromTag<TError, TTaggedQueryKey>,
  >(
    filters?: QueryFilters<
      TInferredQueryFnData,
      TInferredError,
      TInferredQueryFnData,
      TTaggedQueryKey
    >,
    options?: ResetOptions,
  ): Promise<void> {
    const queryCache = this.#queryCache

    return notifyManager.batch(() => {
      queryCache.findAll(filters).forEach((query) => {
        query.reset()
      })
      return this.refetchQueries(
        {
          type: 'active',
          ...filters,
        },
        options,
      )
    })
  }

  cancelQueries<
    TQueryFnData = unknown,
    TError = DefaultError,
    TTaggedQueryKey extends QueryKey = QueryKey,
    TInferredQueryFnData = InferDataFromTag<TQueryFnData, TTaggedQueryKey>,
    TInferredError = InferErrorFromTag<TError, TTaggedQueryKey>,
  >(
    filters?: QueryFilters<
      TInferredQueryFnData,
      TInferredError,
      TInferredQueryFnData,
      TTaggedQueryKey
    >,
    cancelOptions: CancelOptions = {},
  ): Promise<void> {
    const defaultedCancelOptions = { revert: true, ...cancelOptions }

    const promises = notifyManager.batch(() =>
      this.#queryCache
        .findAll(filters)
        .map((query) => query.cancel(defaultedCancelOptions)),
    )

    return Promise.all(promises).then(noop).catch(noop)
  }

  invalidateQueries<
    TQueryFnData = unknown,
    TError = DefaultError,
    TTaggedQueryKey extends QueryKey = QueryKey,
    TInferredQueryFnData = InferDataFromTag<TQueryFnData, TTaggedQueryKey>,
    TInferredError = InferErrorFromTag<TError, TTaggedQueryKey>,
  >(
    filters?: InvalidateQueryFilters<
      TInferredQueryFnData,
      TInferredError,
      TInferredQueryFnData,
      TTaggedQueryKey
    >,
    options: InvalidateOptions = {},
  ): Promise<void> {
    return notifyManager.batch(() => {
      this.#queryCache.findAll(filters).forEach((query) => {
        query.invalidate()
      })

      if (filters?.refetchType === 'none') {
        return Promise.resolve()
      }
      return this.refetchQueries(
        {
          ...filters,
          type: filters?.refetchType ?? filters?.type ?? 'active',
        },
        options,
      )
    })
  }

  refetchQueries<
    TQueryFnData = unknown,
    TError = DefaultError,
    TTaggedQueryKey extends QueryKey = QueryKey,
    TInferredQueryFnData = InferDataFromTag<TQueryFnData, TTaggedQueryKey>,
    TInferredError = InferErrorFromTag<TError, TTaggedQueryKey>,
  >(
    filters?: RefetchQueryFilters<
      TInferredQueryFnData,
      TInferredError,
      TInferredQueryFnData,
      TTaggedQueryKey
    >,
    options: RefetchOptions = {},
  ): Promise<void> {
    const fetchOptions = {
      ...options,
      cancelRefetch: options.cancelRefetch ?? true,
    }
    const promises = notifyManager.batch(() =>
      this.#queryCache
        .findAll(filters)
        .filter((query) => !query.isDisabled())
        .map((query) => {
          let promise = query.fetch(undefined, fetchOptions)
          if (!fetchOptions.throwOnError) {
            promise = promise.catch(noop)
          }
          return query.state.fetchStatus === 'paused'
            ? Promise.resolve()
            : promise
        }),
    )

    return Promise.all(promises).then(noop)
  }

  fetchQuery<
    TQueryFnData,
    TError = DefaultError,
    TData = TQueryFnData,
    TQueryKey extends QueryKey = QueryKey,
    TPageParam = never,
  >(
    options: FetchQueryOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryKey,
      TPageParam
    >,
  ): Promise<TData> {
    const defaultedOptions = this.defaultQueryOptions(options)

    // https://github.com/tannerlinsley/react-query/issues/652
    if (defaultedOptions.retry === undefined) {
      defaultedOptions.retry = false
    }

    const query = this.#queryCache.build(this, defaultedOptions)

    return query.isStaleByTime(
      resolveStaleTime(defaultedOptions.staleTime, query),
    )
      ? query.fetch(defaultedOptions)
      : Promise.resolve(query.state.data as TData)
  }

  prefetchQuery<
    TQueryFnData = unknown,
    TError = DefaultError,
    TData = TQueryFnData,
    TQueryKey extends QueryKey = QueryKey,
  >(
    options: FetchQueryOptions<TQueryFnData, TError, TData, TQueryKey>,
  ): Promise<void> {
    return this.fetchQuery(options).then(noop).catch(noop)
  }

  fetchInfiniteQuery<
    TQueryFnData,
    TError = DefaultError,
    TData = TQueryFnData,
    TQueryKey extends QueryKey = QueryKey,
    TPageParam = unknown,
  >(
    options: FetchInfiniteQueryOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryKey,
      TPageParam
    >,
  ): Promise<InfiniteData<TData, TPageParam>> {
    options.behavior = infiniteQueryBehavior<
      TQueryFnData,
      TError,
      TData,
      TPageParam
    >(options.pages)
    return this.fetchQuery(options as any)
  }

  prefetchInfiniteQuery<
    TQueryFnData,
    TError = DefaultError,
    TData = TQueryFnData,
    TQueryKey extends QueryKey = QueryKey,
    TPageParam = unknown,
  >(
    options: FetchInfiniteQueryOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryKey,
      TPageParam
    >,
  ): Promise<void> {
    return this.fetchInfiniteQuery(options).then(noop).catch(noop)
  }

  ensureInfiniteQueryData<
    TQueryFnData,
    TError = DefaultError,
    TData = TQueryFnData,
    TQueryKey extends QueryKey = QueryKey,
    TPageParam = unknown,
  >(
    options: EnsureInfiniteQueryDataOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryKey,
      TPageParam
    >,
  ): Promise<InfiniteData<TData, TPageParam>> {
    options.behavior = infiniteQueryBehavior<
      TQueryFnData,
      TError,
      TData,
      TPageParam
    >(options.pages)

    return this.ensureQueryData(options as any)
  }

  resumePausedMutations(): Promise<unknown> {
    if (onlineManager.isOnline()) {
      return this.#mutationCache.resumePausedMutations()
    }
    return Promise.resolve()
  }

  getQueryCache(): QueryCache {
    return this.#queryCache
  }

  getMutationCache(): MutationCache {
    return this.#mutationCache
  }

  getDefaultOptions(): DefaultOptions {
    return this.#defaultOptions
  }

  setDefaultOptions(options: DefaultOptions): void {
    this.#defaultOptions = options
  }

  setQueryDefaults<
    TQueryFnData = unknown,
    TError = DefaultError,
    TData = TQueryFnData,
    TQueryData = TQueryFnData,
  >(
    queryKey: QueryKey,
    options: Partial<
      OmitKeyof<
        QueryObserverOptions<TQueryFnData, TError, TData, TQueryData>,
        'queryKey'
      >
    >,
  ): void {
    this.#queryDefaults.set(hashKey(queryKey), {
      queryKey,
      defaultOptions: options,
    })
  }

  getQueryDefaults(
    queryKey: QueryKey,
  ): OmitKeyof<QueryObserverOptions<any, any, any, any, any>, 'queryKey'> {
    const defaults = [...this.#queryDefaults.values()]

    const result: OmitKeyof<
      QueryObserverOptions<any, any, any, any, any>,
      'queryKey'
    > = {}

    defaults.forEach((queryDefault) => {
      if (partialMatchKey(queryKey, queryDefault.queryKey)) {
        Object.assign(result, queryDefault.defaultOptions)
      }
    })
    return result
  }

  setMutationDefaults<
    TData = unknown,
    TError = DefaultError,
    TVariables = void,
    TContext = unknown,
  >(
    mutationKey: MutationKey,
    options: OmitKeyof<
      MutationObserverOptions<TData, TError, TVariables, TContext>,
      'mutationKey'
    >,
  ): void {
    this.#mutationDefaults.set(hashKey(mutationKey), {
      mutationKey,
      defaultOptions: options,
    })
  }

  getMutationDefaults(
    mutationKey: MutationKey,
  ): OmitKeyof<MutationObserverOptions<any, any, any, any>, 'mutationKey'> {
    const defaults = [...this.#mutationDefaults.values()]

    const result: OmitKeyof<
      MutationObserverOptions<any, any, any, any>,
      'mutationKey'
    > = {}

    defaults.forEach((queryDefault) => {
      if (partialMatchKey(mutationKey, queryDefault.mutationKey)) {
        Object.assign(result, queryDefault.defaultOptions)
      }
    })

    return result
  }

  defaultQueryOptions<
    TQueryFnData = unknown,
    TError = DefaultError,
    TData = TQueryFnData,
    TQueryData = TQueryFnData,
    TQueryKey extends QueryKey = QueryKey,
    TPageParam = never,
  >(
    options:
      | QueryObserverOptions<
          TQueryFnData,
          TError,
          TData,
          TQueryData,
          TQueryKey,
          TPageParam
        >
      | DefaultedQueryObserverOptions<
          TQueryFnData,
          TError,
          TData,
          TQueryData,
          TQueryKey
        >,
  ): DefaultedQueryObserverOptions<
    TQueryFnData,
    TError,
    TData,
    TQueryData,
    TQueryKey
  > {
    if (options._defaulted) {
      return options as DefaultedQueryObserverOptions<
        TQueryFnData,
        TError,
        TData,
        TQueryData,
        TQueryKey
      >
    }

    const defaultedOptions = {
      ...this.#defaultOptions.queries,
      ...this.getQueryDefaults(options.queryKey),
      ...options,
      _defaulted: true,
    }

    if (!defaultedOptions.queryHash) {
      defaultedOptions.queryHash = hashQueryKeyByOptions(
        defaultedOptions.queryKey,
        defaultedOptions,
      )
    }

    // dependent default values
    if (defaultedOptions.refetchOnReconnect === undefined) {
      defaultedOptions.refetchOnReconnect =
        defaultedOptions.networkMode !== 'always'
    }
    if (defaultedOptions.throwOnError === undefined) {
      defaultedOptions.throwOnError = !!defaultedOptions.suspense
    }

    if (!defaultedOptions.networkMode && defaultedOptions.persister) {
      defaultedOptions.networkMode = 'offlineFirst'
    }

    if (defaultedOptions.queryFn === skipToken) {
      defaultedOptions.enabled = false
    }

    return defaultedOptions as DefaultedQueryObserverOptions<
      TQueryFnData,
      TError,
      TData,
      TQueryData,
      TQueryKey
    >
  }

  defaultMutationOptions<T extends MutationOptions<any, any, any, any>>(
    options?: T,
  ): T {
    if (options?._defaulted) {
      return options
    }
    return {
      ...this.#defaultOptions.mutations,
      ...(options?.mutationKey &&
        this.getMutationDefaults(options.mutationKey)),
      ...options,
      _defaulted: true,
    } as T
  }

  clear(): void {
    this.#queryCache.clear()
    this.#mutationCache.clear()
  }
}



# ./src/mutationObserver.ts

import { getDefaultState } from './mutation'
import { notifyManager } from './notifyManager'
import { Subscribable } from './subscribable'
import { hashKey, shallowEqualObjects } from './utils'
import type { QueryClient } from './queryClient'
import type {
  DefaultError,
  MutateOptions,
  MutationObserverOptions,
  MutationObserverResult,
} from './types'
import type { Action, Mutation } from './mutation'

// TYPES

type MutationObserverListener<TData, TError, TVariables, TContext> = (
  result: MutationObserverResult<TData, TError, TVariables, TContext>,
) => void

// CLASS

export class MutationObserver<
  TData = unknown,
  TError = DefaultError,
  TVariables = void,
  TContext = unknown,
> extends Subscribable<
  MutationObserverListener<TData, TError, TVariables, TContext>
> {
  options!: MutationObserverOptions<TData, TError, TVariables, TContext>

  #client: QueryClient
  #currentResult: MutationObserverResult<TData, TError, TVariables, TContext> =
    undefined!
  #currentMutation?: Mutation<TData, TError, TVariables, TContext>
  #mutateOptions?: MutateOptions<TData, TError, TVariables, TContext>

  constructor(
    client: QueryClient,
    options: MutationObserverOptions<TData, TError, TVariables, TContext>,
  ) {
    super()

    this.#client = client
    this.setOptions(options)
    this.bindMethods()
    this.#updateResult()
  }

  protected bindMethods(): void {
    this.mutate = this.mutate.bind(this)
    this.reset = this.reset.bind(this)
  }

  setOptions(
    options: MutationObserverOptions<TData, TError, TVariables, TContext>,
  ) {
    const prevOptions = this.options as
      | MutationObserverOptions<TData, TError, TVariables, TContext>
      | undefined
    this.options = this.#client.defaultMutationOptions(options)
    if (!shallowEqualObjects(this.options, prevOptions)) {
      this.#client.getMutationCache().notify({
        type: 'observerOptionsUpdated',
        mutation: this.#currentMutation,
        observer: this,
      })
    }

    if (
      prevOptions?.mutationKey &&
      this.options.mutationKey &&
      hashKey(prevOptions.mutationKey) !== hashKey(this.options.mutationKey)
    ) {
      this.reset()
    } else if (this.#currentMutation?.state.status === 'pending') {
      this.#currentMutation.setOptions(this.options)
    }
  }

  protected onUnsubscribe(): void {
    if (!this.hasListeners()) {
      this.#currentMutation?.removeObserver(this)
    }
  }

  onMutationUpdate(action: Action<TData, TError, TVariables, TContext>): void {
    this.#updateResult()

    this.#notify(action)
  }

  getCurrentResult(): MutationObserverResult<
    TData,
    TError,
    TVariables,
    TContext
  > {
    return this.#currentResult
  }

  reset(): void {
    // reset needs to remove the observer from the mutation because there is no way to "get it back"
    // another mutate call will yield a new mutation!
    this.#currentMutation?.removeObserver(this)
    this.#currentMutation = undefined
    this.#updateResult()
    this.#notify()
  }

  mutate(
    variables: TVariables,
    options?: MutateOptions<TData, TError, TVariables, TContext>,
  ): Promise<TData> {
    this.#mutateOptions = options

    this.#currentMutation?.removeObserver(this)

    this.#currentMutation = this.#client
      .getMutationCache()
      .build(this.#client, this.options)

    this.#currentMutation.addObserver(this)

    return this.#currentMutation.execute(variables)
  }

  #updateResult(): void {
    const state =
      this.#currentMutation?.state ??
      getDefaultState<TData, TError, TVariables, TContext>()

    this.#currentResult = {
      ...state,
      isPending: state.status === 'pending',
      isSuccess: state.status === 'success',
      isError: state.status === 'error',
      isIdle: state.status === 'idle',
      mutate: this.mutate,
      reset: this.reset,
    } as MutationObserverResult<TData, TError, TVariables, TContext>
  }

  #notify(action?: Action<TData, TError, TVariables, TContext>): void {
    notifyManager.batch(() => {
      // First trigger the mutate callbacks
      if (this.#mutateOptions && this.hasListeners()) {
        const variables = this.#currentResult.variables!
        const context = this.#currentResult.context

        if (action?.type === 'success') {
          this.#mutateOptions.onSuccess?.(action.data, variables, context!)
          this.#mutateOptions.onSettled?.(action.data, null, variables, context)
        } else if (action?.type === 'error') {
          this.#mutateOptions.onError?.(action.error, variables, context)
          this.#mutateOptions.onSettled?.(
            undefined,
            action.error,
            variables,
            context,
          )
        }
      }

      // Then trigger the listeners
      this.listeners.forEach((listener) => {
        listener(this.#currentResult)
      })
    })
  }
}



# ./src/mutation.ts

import { notifyManager } from './notifyManager'
import { Removable } from './removable'
import { createRetryer } from './retryer'
import type {
  DefaultError,
  MutationMeta,
  MutationOptions,
  MutationStatus,
} from './types'
import type { MutationCache } from './mutationCache'
import type { MutationObserver } from './mutationObserver'
import type { Retryer } from './retryer'

// TYPES

interface MutationConfig<TData, TError, TVariables, TContext> {
  mutationId: number
  mutationCache: MutationCache
  options: MutationOptions<TData, TError, TVariables, TContext>
  state?: MutationState<TData, TError, TVariables, TContext>
}

export interface MutationState<
  TData = unknown,
  TError = DefaultError,
  TVariables = unknown,
  TContext = unknown,
> {
  context: TContext | undefined
  data: TData | undefined
  error: TError | null
  failureCount: number
  failureReason: TError | null
  isPaused: boolean
  status: MutationStatus
  variables: TVariables | undefined
  submittedAt: number
}

interface FailedAction<TError> {
  type: 'failed'
  failureCount: number
  error: TError | null
}

interface PendingAction<TVariables, TContext> {
  type: 'pending'
  isPaused: boolean
  variables?: TVariables
  context?: TContext
}

interface SuccessAction<TData> {
  type: 'success'
  data: TData
}

interface ErrorAction<TError> {
  type: 'error'
  error: TError
}

interface PauseAction {
  type: 'pause'
}

interface ContinueAction {
  type: 'continue'
}

export type Action<TData, TError, TVariables, TContext> =
  | ContinueAction
  | ErrorAction<TError>
  | FailedAction<TError>
  | PendingAction<TVariables, TContext>
  | PauseAction
  | SuccessAction<TData>

// CLASS

export class Mutation<
  TData = unknown,
  TError = DefaultError,
  TVariables = unknown,
  TContext = unknown,
> extends Removable {
  state: MutationState<TData, TError, TVariables, TContext>
  options!: MutationOptions<TData, TError, TVariables, TContext>
  readonly mutationId: number

  #observers: Array<MutationObserver<TData, TError, TVariables, TContext>>
  #mutationCache: MutationCache
  #retryer?: Retryer<TData>

  constructor(config: MutationConfig<TData, TError, TVariables, TContext>) {
    super()

    this.mutationId = config.mutationId
    this.#mutationCache = config.mutationCache
    this.#observers = []
    this.state = config.state || getDefaultState()

    this.setOptions(config.options)
    this.scheduleGc()
  }

  setOptions(
    options: MutationOptions<TData, TError, TVariables, TContext>,
  ): void {
    this.options = options

    this.updateGcTime(this.options.gcTime)
  }

  get meta(): MutationMeta | undefined {
    return this.options.meta
  }

  addObserver(observer: MutationObserver<any, any, any, any>): void {
    if (!this.#observers.includes(observer)) {
      this.#observers.push(observer)

      // Stop the mutation from being garbage collected
      this.clearGcTimeout()

      this.#mutationCache.notify({
        type: 'observerAdded',
        mutation: this,
        observer,
      })
    }
  }

  removeObserver(observer: MutationObserver<any, any, any, any>): void {
    this.#observers = this.#observers.filter((x) => x !== observer)

    this.scheduleGc()

    this.#mutationCache.notify({
      type: 'observerRemoved',
      mutation: this,
      observer,
    })
  }

  protected optionalRemove() {
    if (!this.#observers.length) {
      if (this.state.status === 'pending') {
        this.scheduleGc()
      } else {
        this.#mutationCache.remove(this)
      }
    }
  }

  continue(): Promise<unknown> {
    return (
      this.#retryer?.continue() ??
      // continuing a mutation assumes that variables are set, mutation must have been dehydrated before
      this.execute(this.state.variables!)
    )
  }

  async execute(variables: TVariables): Promise<TData> {
    this.#retryer = createRetryer({
      fn: () => {
        if (!this.options.mutationFn) {
          return Promise.reject(new Error('No mutationFn found'))
        }
        return this.options.mutationFn(variables)
      },
      onFail: (failureCount, error) => {
        this.#dispatch({ type: 'failed', failureCount, error })
      },
      onPause: () => {
        this.#dispatch({ type: 'pause' })
      },
      onContinue: () => {
        this.#dispatch({ type: 'continue' })
      },
      retry: this.options.retry ?? 0,
      retryDelay: this.options.retryDelay,
      networkMode: this.options.networkMode,
      canRun: () => this.#mutationCache.canRun(this),
    })

    const restored = this.state.status === 'pending'
    const isPaused = !this.#retryer.canStart()

    try {
      if (!restored) {
        this.#dispatch({ type: 'pending', variables, isPaused })
        // Notify cache callback
        await this.#mutationCache.config.onMutate?.(
          variables,
          this as Mutation<unknown, unknown, unknown, unknown>,
        )
        const context = await this.options.onMutate?.(variables)
        if (context !== this.state.context) {
          this.#dispatch({
            type: 'pending',
            context,
            variables,
            isPaused,
          })
        }
      }
      const data = await this.#retryer.start()

      // Notify cache callback
      await this.#mutationCache.config.onSuccess?.(
        data,
        variables,
        this.state.context,
        this as Mutation<unknown, unknown, unknown, unknown>,
      )

      await this.options.onSuccess?.(data, variables, this.state.context!)

      // Notify cache callback
      await this.#mutationCache.config.onSettled?.(
        data,
        null,
        this.state.variables,
        this.state.context,
        this as Mutation<unknown, unknown, unknown, unknown>,
      )

      await this.options.onSettled?.(data, null, variables, this.state.context)

      this.#dispatch({ type: 'success', data })
      return data
    } catch (error) {
      try {
        // Notify cache callback
        await this.#mutationCache.config.onError?.(
          error as any,
          variables,
          this.state.context,
          this as Mutation<unknown, unknown, unknown, unknown>,
        )

        await this.options.onError?.(
          error as TError,
          variables,
          this.state.context,
        )

        // Notify cache callback
        await this.#mutationCache.config.onSettled?.(
          undefined,
          error as any,
          this.state.variables,
          this.state.context,
          this as Mutation<unknown, unknown, unknown, unknown>,
        )

        await this.options.onSettled?.(
          undefined,
          error as TError,
          variables,
          this.state.context,
        )
        throw error
      } finally {
        this.#dispatch({ type: 'error', error: error as TError })
      }
    } finally {
      this.#mutationCache.runNext(this)
    }
  }

  #dispatch(action: Action<TData, TError, TVariables, TContext>): void {
    const reducer = (
      state: MutationState<TData, TError, TVariables, TContext>,
    ): MutationState<TData, TError, TVariables, TContext> => {
      switch (action.type) {
        case 'failed':
          return {
            ...state,
            failureCount: action.failureCount,
            failureReason: action.error,
          }
        case 'pause':
          return {
            ...state,
            isPaused: true,
          }
        case 'continue':
          return {
            ...state,
            isPaused: false,
          }
        case 'pending':
          return {
            ...state,
            context: action.context,
            data: undefined,
            failureCount: 0,
            failureReason: null,
            error: null,
            isPaused: action.isPaused,
            status: 'pending',
            variables: action.variables,
            submittedAt: Date.now(),
          }
        case 'success':
          return {
            ...state,
            data: action.data,
            failureCount: 0,
            failureReason: null,
            error: null,
            status: 'success',
            isPaused: false,
          }
        case 'error':
          return {
            ...state,
            data: undefined,
            error: action.error,
            failureCount: state.failureCount + 1,
            failureReason: action.error,
            isPaused: false,
            status: 'error',
          }
      }
    }
    this.state = reducer(this.state)

    notifyManager.batch(() => {
      this.#observers.forEach((observer) => {
        observer.onMutationUpdate(action)
      })
      this.#mutationCache.notify({
        mutation: this,
        type: 'updated',
        action,
      })
    })
  }
}

export function getDefaultState<
  TData,
  TError,
  TVariables,
  TContext,
>(): MutationState<TData, TError, TVariables, TContext> {
  return {
    context: undefined,
    data: undefined,
    error: null,
    failureCount: 0,
    failureReason: null,
    isPaused: false,
    status: 'idle',
    variables: undefined,
    submittedAt: 0,
  }
}



# ./src/index.ts

/* istanbul ignore file */

export { CancelledError } from './retryer'
export { QueryCache } from './queryCache'
export type { QueryCacheNotifyEvent } from './queryCache'
export { QueryClient } from './queryClient'
export { QueryObserver } from './queryObserver'
export { QueriesObserver } from './queriesObserver'
export { InfiniteQueryObserver } from './infiniteQueryObserver'
export { MutationCache } from './mutationCache'
export type { MutationCacheNotifyEvent } from './mutationCache'
export { MutationObserver } from './mutationObserver'
export { notifyManager } from './notifyManager'
export { focusManager } from './focusManager'
export { onlineManager } from './onlineManager'
export {
  hashKey,
  replaceEqualDeep,
  isServer,
  matchQuery,
  matchMutation,
  keepPreviousData,
  skipToken,
} from './utils'
export type { MutationFilters, QueryFilters, Updater, SkipToken } from './utils'
export { isCancelledError } from './retryer'
export {
  dehydrate,
  hydrate,
  defaultShouldDehydrateQuery,
  defaultShouldDehydrateMutation,
} from './hydration'

// Types
export * from './types'
export type { QueryState } from './query'
export { Query } from './query'
export type { MutationState } from './mutation'
export { Mutation } from './mutation'
export type {
  DehydrateOptions,
  DehydratedState,
  HydrateOptions,
} from './hydration'
export type { QueriesObserverOptions } from './queriesObserver'



# ./src/query.ts

import {
  ensureQueryFn,
  noop,
  replaceData,
  resolveEnabled,
  skipToken,
  timeUntilStale,
} from './utils'
import { notifyManager } from './notifyManager'
import { canFetch, createRetryer, isCancelledError } from './retryer'
import { Removable } from './removable'
import type { QueryCache } from './queryCache'
import type { QueryClient } from './queryClient'
import type {
  CancelOptions,
  DefaultError,
  FetchStatus,
  InitialDataFunction,
  OmitKeyof,
  QueryFunction,
  QueryFunctionContext,
  QueryKey,
  QueryMeta,
  QueryOptions,
  QueryStatus,
  SetDataOptions,
} from './types'
import type { QueryObserver } from './queryObserver'
import type { Retryer } from './retryer'

// TYPES

interface QueryConfig<
  TQueryFnData,
  TError,
  TData,
  TQueryKey extends QueryKey = QueryKey,
> {
  client: QueryClient
  queryKey: TQueryKey
  queryHash: string
  options?: QueryOptions<TQueryFnData, TError, TData, TQueryKey>
  defaultOptions?: QueryOptions<TQueryFnData, TError, TData, TQueryKey>
  state?: QueryState<TData, TError>
}

export interface QueryState<TData = unknown, TError = DefaultError> {
  data: TData | undefined
  dataUpdateCount: number
  dataUpdatedAt: number
  error: TError | null
  errorUpdateCount: number
  errorUpdatedAt: number
  fetchFailureCount: number
  fetchFailureReason: TError | null
  fetchMeta: FetchMeta | null
  isInvalidated: boolean
  status: QueryStatus
  fetchStatus: FetchStatus
}

export interface FetchContext<
  TQueryFnData,
  TError,
  TData,
  TQueryKey extends QueryKey = QueryKey,
> {
  fetchFn: () => unknown | Promise<unknown>
  fetchOptions?: FetchOptions
  signal: AbortSignal
  options: QueryOptions<TQueryFnData, TError, TData, any>
  client: QueryClient
  queryKey: TQueryKey
  state: QueryState<TData, TError>
}

export interface QueryBehavior<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> {
  onFetch: (
    context: FetchContext<TQueryFnData, TError, TData, TQueryKey>,
    query: Query,
  ) => void
}

export type FetchDirection = 'forward' | 'backward'

export interface FetchMeta {
  fetchMore?: { direction: FetchDirection }
}

export interface FetchOptions<TData = unknown> {
  cancelRefetch?: boolean
  meta?: FetchMeta
  initialPromise?: Promise<TData>
}

interface FailedAction<TError> {
  type: 'failed'
  failureCount: number
  error: TError
}

interface FetchAction {
  type: 'fetch'
  meta?: FetchMeta
}

interface SuccessAction<TData> {
  data: TData | undefined
  type: 'success'
  dataUpdatedAt?: number
  manual?: boolean
}

interface ErrorAction<TError> {
  type: 'error'
  error: TError
}

interface InvalidateAction {
  type: 'invalidate'
}

interface PauseAction {
  type: 'pause'
}

interface ContinueAction {
  type: 'continue'
}

interface SetStateAction<TData, TError> {
  type: 'setState'
  state: Partial<QueryState<TData, TError>>
  setStateOptions?: SetStateOptions
}

export type Action<TData, TError> =
  | ContinueAction
  | ErrorAction<TError>
  | FailedAction<TError>
  | FetchAction
  | InvalidateAction
  | PauseAction
  | SetStateAction<TData, TError>
  | SuccessAction<TData>

export interface SetStateOptions {
  meta?: any
}

// CLASS

export class Query<
  TQueryFnData = unknown,
  TError = DefaultError,
  TData = TQueryFnData,
  TQueryKey extends QueryKey = QueryKey,
> extends Removable {
  queryKey: TQueryKey
  queryHash: string
  options!: QueryOptions<TQueryFnData, TError, TData, TQueryKey>
  state: QueryState<TData, TError>

  #initialState: QueryState<TData, TError>
  #revertState?: QueryState<TData, TError>
  #cache: QueryCache
  #client: QueryClient
  #retryer?: Retryer<TData>
  observers: Array<QueryObserver<any, any, any, any, any>>
  #defaultOptions?: QueryOptions<TQueryFnData, TError, TData, TQueryKey>
  #abortSignalConsumed: boolean

  constructor(config: QueryConfig<TQueryFnData, TError, TData, TQueryKey>) {
    super()

    this.#abortSignalConsumed = false
    this.#defaultOptions = config.defaultOptions
    this.setOptions(config.options)
    this.observers = []
    this.#client = config.client
    this.#cache = this.#client.getQueryCache()
    this.queryKey = config.queryKey
    this.queryHash = config.queryHash
    this.#initialState = getDefaultState(this.options)
    this.state = config.state ?? this.#initialState
    this.scheduleGc()
  }
  get meta(): QueryMeta | undefined {
    return this.options.meta
  }

  get promise(): Promise<TData> | undefined {
    return this.#retryer?.promise
  }

  setOptions(
    options?: QueryOptions<TQueryFnData, TError, TData, TQueryKey>,
  ): void {
    this.options = { ...this.#defaultOptions, ...options }

    this.updateGcTime(this.options.gcTime)
  }

  protected optionalRemove() {
    if (!this.observers.length && this.state.fetchStatus === 'idle') {
      this.#cache.remove(this)
    }
  }

  setData(
    newData: TData,
    options?: SetDataOptions & { manual: boolean },
  ): TData {
    const data = replaceData(this.state.data, newData, this.options)

    // Set data and mark it as cached
    this.#dispatch({
      data,
      type: 'success',
      dataUpdatedAt: options?.updatedAt,
      manual: options?.manual,
    })

    return data
  }

  setState(
    state: Partial<QueryState<TData, TError>>,
    setStateOptions?: SetStateOptions,
  ): void {
    this.#dispatch({ type: 'setState', state, setStateOptions })
  }

  cancel(options?: CancelOptions): Promise<void> {
    const promise = this.#retryer?.promise
    this.#retryer?.cancel(options)
    return promise ? promise.then(noop).catch(noop) : Promise.resolve()
  }

  destroy(): void {
    super.destroy()

    this.cancel({ silent: true })
  }

  reset(): void {
    this.destroy()
    this.setState(this.#initialState)
  }

  isActive(): boolean {
    return this.observers.some(
      (observer) => resolveEnabled(observer.options.enabled, this) !== false,
    )
  }

  isDisabled(): boolean {
    if (this.getObserversCount() > 0) {
      return !this.isActive()
    }
    // if a query has no observers, it should still be considered disabled if it never attempted a fetch
    return (
      this.options.queryFn === skipToken ||
      this.state.dataUpdateCount + this.state.errorUpdateCount === 0
    )
  }

  isStale(): boolean {
    if (this.state.isInvalidated) {
      return true
    }

    if (this.getObserversCount() > 0) {
      return this.observers.some(
        (observer) => observer.getCurrentResult().isStale,
      )
    }

    return this.state.data === undefined
  }

  isStaleByTime(staleTime = 0): boolean {
    return (
      this.state.isInvalidated ||
      this.state.data === undefined ||
      !timeUntilStale(this.state.dataUpdatedAt, staleTime)
    )
  }

  onFocus(): void {
    const observer = this.observers.find((x) => x.shouldFetchOnWindowFocus())

    observer?.refetch({ cancelRefetch: false })

    // Continue fetch if currently paused
    this.#retryer?.continue()
  }

  onOnline(): void {
    const observer = this.observers.find((x) => x.shouldFetchOnReconnect())

    observer?.refetch({ cancelRefetch: false })

    // Continue fetch if currently paused
    this.#retryer?.continue()
  }

  addObserver(observer: QueryObserver<any, any, any, any, any>): void {
    if (!this.observers.includes(observer)) {
      this.observers.push(observer)

      // Stop the query from being garbage collected
      this.clearGcTimeout()

      this.#cache.notify({ type: 'observerAdded', query: this, observer })
    }
  }

  removeObserver(observer: QueryObserver<any, any, any, any, any>): void {
    if (this.observers.includes(observer)) {
      this.observers = this.observers.filter((x) => x !== observer)

      if (!this.observers.length) {
        // If the transport layer does not support cancellation
        // we'll let the query continue so the result can be cached
        if (this.#retryer) {
          if (this.#abortSignalConsumed) {
            this.#retryer.cancel({ revert: true })
          } else {
            this.#retryer.cancelRetry()
          }
        }

        this.scheduleGc()
      }

      this.#cache.notify({ type: 'observerRemoved', query: this, observer })
    }
  }

  getObserversCount(): number {
    return this.observers.length
  }

  invalidate(): void {
    if (!this.state.isInvalidated) {
      this.#dispatch({ type: 'invalidate' })
    }
  }

  fetch(
    options?: QueryOptions<TQueryFnData, TError, TData, TQueryKey>,
    fetchOptions?: FetchOptions<TQueryFnData>,
  ): Promise<TData> {
    if (this.state.fetchStatus !== 'idle') {
      if (this.state.data !== undefined && fetchOptions?.cancelRefetch) {
        // Silently cancel current fetch if the user wants to cancel refetch
        this.cancel({ silent: true })
      } else if (this.#retryer) {
        // make sure that retries that were potentially cancelled due to unmounts can continue
        this.#retryer.continueRetry()
        // Return current promise if we are already fetching
        return this.#retryer.promise
      }
    }

    // Update config if passed, otherwise the config from the last execution is used
    if (options) {
      this.setOptions(options)
    }

    // Use the options from the first observer with a query function if no function is found.
    // This can happen when the query is hydrated or created with setQueryData.
    if (!this.options.queryFn) {
      const observer = this.observers.find((x) => x.options.queryFn)
      if (observer) {
        this.setOptions(observer.options)
      }
    }

    if (process.env.NODE_ENV !== 'production') {
      if (!Array.isArray(this.options.queryKey)) {
        console.error(
          `As of v4, queryKey needs to be an Array. If you are using a string like 'repoData', please change it to an Array, e.g. ['repoData']`,
        )
      }
    }

    const abortController = new AbortController()

    // Adds an enumerable signal property to the object that
    // which sets abortSignalConsumed to true when the signal
    // is read.
    const addSignalProperty = (object: unknown) => {
      Object.defineProperty(object, 'signal', {
        enumerable: true,
        get: () => {
          this.#abortSignalConsumed = true
          return abortController.signal
        },
      })
    }

    // Create fetch function
    const fetchFn = () => {
      const queryFn = ensureQueryFn(this.options, fetchOptions)

      // Create query function context
      const queryFnContext: OmitKeyof<
        QueryFunctionContext<TQueryKey>,
        'signal'
      > = {
        client: this.#client,
        queryKey: this.queryKey,
        meta: this.meta,
      }

      addSignalProperty(queryFnContext)

      this.#abortSignalConsumed = false
      if (this.options.persister) {
        return this.options.persister(
          queryFn as QueryFunction<any>,
          queryFnContext as QueryFunctionContext<TQueryKey>,
          this as unknown as Query,
        )
      }

      return queryFn(queryFnContext as QueryFunctionContext<TQueryKey>)
    }

    // Trigger behavior hook
    const context: OmitKeyof<
      FetchContext<TQueryFnData, TError, TData, TQueryKey>,
      'signal'
    > = {
      fetchOptions,
      options: this.options,
      queryKey: this.queryKey,
      client: this.#client,
      state: this.state,
      fetchFn,
    }

    addSignalProperty(context)

    this.options.behavior?.onFetch(
      context as FetchContext<TQueryFnData, TError, TData, TQueryKey>,
      this as unknown as Query,
    )

    // Store state in case the current fetch needs to be reverted
    this.#revertState = this.state

    // Set to fetching state if not already in it
    if (
      this.state.fetchStatus === 'idle' ||
      this.state.fetchMeta !== context.fetchOptions?.meta
    ) {
      this.#dispatch({ type: 'fetch', meta: context.fetchOptions?.meta })
    }

    const onError = (error: TError | { silent?: boolean }) => {
      // Optimistically update state if needed
      if (!(isCancelledError(error) && error.silent)) {
        this.#dispatch({
          type: 'error',
          error: error as TError,
        })
      }

      if (!isCancelledError(error)) {
        // Notify cache callback
        this.#cache.config.onError?.(
          error as any,
          this as Query<any, any, any, any>,
        )
        this.#cache.config.onSettled?.(
          this.state.data,
          error as any,
          this as Query<any, any, any, any>,
        )
      }

      // Schedule query gc after fetching
      this.scheduleGc()
    }

    // Try to fetch the data
    this.#retryer = createRetryer({
      initialPromise: fetchOptions?.initialPromise as
        | Promise<TData>
        | undefined,
      fn: context.fetchFn as () => Promise<TData>,
      abort: abortController.abort.bind(abortController),
      onSuccess: (data) => {
        if (data === undefined) {
          if (process.env.NODE_ENV !== 'production') {
            console.error(
              `Query data cannot be undefined. Please make sure to return a value other than undefined from your query function. Affected query key: ${this.queryHash}`,
            )
          }
          onError(new Error(`${this.queryHash} data is undefined`) as any)
          return
        }

        try {
          this.setData(data)
        } catch (error) {
          onError(error as TError)
          return
        }

        // Notify cache callback
        this.#cache.config.onSuccess?.(data, this as Query<any, any, any, any>)
        this.#cache.config.onSettled?.(
          data,
          this.state.error as any,
          this as Query<any, any, any, any>,
        )

        // Schedule query gc after fetching
        this.scheduleGc()
      },
      onError,
      onFail: (failureCount, error) => {
        this.#dispatch({ type: 'failed', failureCount, error })
      },
      onPause: () => {
        this.#dispatch({ type: 'pause' })
      },
      onContinue: () => {
        this.#dispatch({ type: 'continue' })
      },
      retry: context.options.retry,
      retryDelay: context.options.retryDelay,
      networkMode: context.options.networkMode,
      canRun: () => true,
    })

    return this.#retryer.start()
  }

  #dispatch(action: Action<TData, TError>): void {
    const reducer = (
      state: QueryState<TData, TError>,
    ): QueryState<TData, TError> => {
      switch (action.type) {
        case 'failed':
          return {
            ...state,
            fetchFailureCount: action.failureCount,
            fetchFailureReason: action.error,
          }
        case 'pause':
          return {
            ...state,
            fetchStatus: 'paused',
          }
        case 'continue':
          return {
            ...state,
            fetchStatus: 'fetching',
          }
        case 'fetch':
          return {
            ...state,
            ...fetchState(state.data, this.options),
            fetchMeta: action.meta ?? null,
          }
        case 'success':
          return {
            ...state,
            data: action.data,
            dataUpdateCount: state.dataUpdateCount + 1,
            dataUpdatedAt: action.dataUpdatedAt ?? Date.now(),
            error: null,
            isInvalidated: false,
            status: 'success',
            ...(!action.manual && {
              fetchStatus: 'idle',
              fetchFailureCount: 0,
              fetchFailureReason: null,
            }),
          }
        case 'error':
          const error = action.error

          if (isCancelledError(error) && error.revert && this.#revertState) {
            return { ...this.#revertState, fetchStatus: 'idle' }
          }

          return {
            ...state,
            error,
            errorUpdateCount: state.errorUpdateCount + 1,
            errorUpdatedAt: Date.now(),
            fetchFailureCount: state.fetchFailureCount + 1,
            fetchFailureReason: error,
            fetchStatus: 'idle',
            status: 'error',
          }
        case 'invalidate':
          return {
            ...state,
            isInvalidated: true,
          }
        case 'setState':
          return {
            ...state,
            ...action.state,
          }
      }
    }

    this.state = reducer(this.state)

    notifyManager.batch(() => {
      this.observers.forEach((observer) => {
        observer.onQueryUpdate()
      })

      this.#cache.notify({ query: this, type: 'updated', action })
    })
  }
}

export function fetchState<
  TQueryFnData,
  TError,
  TData,
  TQueryKey extends QueryKey,
>(
  data: TData | undefined,
  options: QueryOptions<TQueryFnData, TError, TData, TQueryKey>,
) {
  return {
    fetchFailureCount: 0,
    fetchFailureReason: null,
    fetchStatus: canFetch(options.networkMode) ? 'fetching' : 'paused',
    ...(data === undefined &&
      ({
        error: null,
        status: 'pending',
      } as const)),
  } as const
}

function getDefaultState<
  TQueryFnData,
  TError,
  TData,
  TQueryKey extends QueryKey,
>(
  options: QueryOptions<TQueryFnData, TError, TData, TQueryKey>,
): QueryState<TData, TError> {
  const data =
    typeof options.initialData === 'function'
      ? (options.initialData as InitialDataFunction<TData>)()
      : options.initialData

  const hasData = data !== undefined

  const initialDataUpdatedAt = hasData
    ? typeof options.initialDataUpdatedAt === 'function'
      ? (options.initialDataUpdatedAt as () => number | undefined)()
      : options.initialDataUpdatedAt
    : 0

  return {
    data,
    dataUpdateCount: 0,
    dataUpdatedAt: hasData ? (initialDataUpdatedAt ?? Date.now()) : 0,
    error: null,
    errorUpdateCount: 0,
    errorUpdatedAt: 0,
    fetchFailureCount: 0,
    fetchFailureReason: null,
    fetchMeta: null,
    isInvalidated: false,
    status: hasData ? 'success' : 'pending',
    fetchStatus: 'idle',
  }
}



# ./src/queriesObserver.ts

import { notifyManager } from './notifyManager'
import { QueryObserver } from './queryObserver'
import { Subscribable } from './subscribable'
import { replaceEqualDeep } from './utils'
import type {
  DefaultedQueryObserverOptions,
  QueryObserverOptions,
  QueryObserverResult,
} from './types'
import type { QueryClient } from './queryClient'
import type { NotifyOptions } from './queryObserver'

function difference<T>(array1: Array<T>, array2: Array<T>): Array<T> {
  return array1.filter((x) => !array2.includes(x))
}

function replaceAt<T>(array: Array<T>, index: number, value: T): Array<T> {
  const copy = array.slice(0)
  copy[index] = value
  return copy
}

type QueriesObserverListener = (result: Array<QueryObserverResult>) => void

type CombineFn<TCombinedResult> = (
  result: Array<QueryObserverResult>,
) => TCombinedResult

export interface QueriesObserverOptions<
  TCombinedResult = Array<QueryObserverResult>,
> {
  combine?: CombineFn<TCombinedResult>
}

export class QueriesObserver<
  TCombinedResult = Array<QueryObserverResult>,
> extends Subscribable<QueriesObserverListener> {
  #client: QueryClient
  #result!: Array<QueryObserverResult>
  #queries: Array<QueryObserverOptions>
  #options?: QueriesObserverOptions<TCombinedResult>
  #observers: Array<QueryObserver>
  #combinedResult?: TCombinedResult
  #lastCombine?: CombineFn<TCombinedResult>
  #lastResult?: Array<QueryObserverResult>
  #observerMatches: Array<QueryObserverMatch> = []

  constructor(
    client: QueryClient,
    queries: Array<QueryObserverOptions<any, any, any, any, any>>,
    options?: QueriesObserverOptions<TCombinedResult>,
  ) {
    super()

    this.#client = client
    this.#options = options
    this.#queries = []
    this.#observers = []
    this.#result = []

    this.setQueries(queries)
  }

  protected onSubscribe(): void {
    if (this.listeners.size === 1) {
      this.#observers.forEach((observer) => {
        observer.subscribe((result) => {
          this.#onUpdate(observer, result)
        })
      })
    }
  }

  protected onUnsubscribe(): void {
    if (!this.listeners.size) {
      this.destroy()
    }
  }

  destroy(): void {
    this.listeners = new Set()
    this.#observers.forEach((observer) => {
      observer.destroy()
    })
  }

  setQueries(
    queries: Array<QueryObserverOptions>,
    options?: QueriesObserverOptions<TCombinedResult>,
    notifyOptions?: NotifyOptions,
  ): void {
    this.#queries = queries
    this.#options = options

    if (process.env.NODE_ENV !== 'production') {
      const queryHashes = queries.map(
        (query) => this.#client.defaultQueryOptions(query).queryHash,
      )
      if (new Set(queryHashes).size !== queryHashes.length) {
        console.warn(
          '[QueriesObserver]: Duplicate Queries found. This might result in unexpected behavior.',
        )
      }
    }

    notifyManager.batch(() => {
      const prevObservers = this.#observers

      const newObserverMatches = this.#findMatchingObservers(this.#queries)
      this.#observerMatches = newObserverMatches

      // set options for the new observers to notify of changes
      newObserverMatches.forEach((match) =>
        match.observer.setOptions(match.defaultedQueryOptions, notifyOptions),
      )

      const newObservers = newObserverMatches.map((match) => match.observer)
      const newResult = newObservers.map((observer) =>
        observer.getCurrentResult(),
      )

      const hasIndexChange = newObservers.some(
        (observer, index) => observer !== prevObservers[index],
      )

      if (prevObservers.length === newObservers.length && !hasIndexChange) {
        return
      }

      this.#observers = newObservers
      this.#result = newResult

      if (!this.hasListeners()) {
        return
      }

      difference(prevObservers, newObservers).forEach((observer) => {
        observer.destroy()
      })

      difference(newObservers, prevObservers).forEach((observer) => {
        observer.subscribe((result) => {
          this.#onUpdate(observer, result)
        })
      })

      this.#notify()
    })
  }

  getCurrentResult(): Array<QueryObserverResult> {
    return this.#result
  }

  getQueries() {
    return this.#observers.map((observer) => observer.getCurrentQuery())
  }

  getObservers() {
    return this.#observers
  }

  getOptimisticResult(
    queries: Array<QueryObserverOptions>,
    combine: CombineFn<TCombinedResult> | undefined,
  ): [
    rawResult: Array<QueryObserverResult>,
    combineResult: (r?: Array<QueryObserverResult>) => TCombinedResult,
    trackResult: () => Array<QueryObserverResult>,
  ] {
    const matches = this.#findMatchingObservers(queries)
    const result = matches.map((match) =>
      match.observer.getOptimisticResult(match.defaultedQueryOptions),
    )

    return [
      result,
      (r?: Array<QueryObserverResult>) => {
        return this.#combineResult(r ?? result, combine)
      },
      () => {
        return this.#trackResult(result, matches)
      },
    ]
  }

  #trackResult(
    result: Array<QueryObserverResult>,
    matches: Array<QueryObserverMatch>,
  ) {
    return matches.map((match, index) => {
      const observerResult = result[index]!
      return !match.defaultedQueryOptions.notifyOnChangeProps
        ? match.observer.trackResult(observerResult, (accessedProp) => {
            // track property on all observers to ensure proper (synchronized) tracking (#7000)
            matches.forEach((m) => {
              m.observer.trackProp(accessedProp)
            })
          })
        : observerResult
    })
  }

  #combineResult(
    input: Array<QueryObserverResult>,
    combine: CombineFn<TCombinedResult> | undefined,
  ): TCombinedResult {
    if (combine) {
      if (
        !this.#combinedResult ||
        this.#result !== this.#lastResult ||
        combine !== this.#lastCombine
      ) {
        this.#lastCombine = combine
        this.#lastResult = this.#result
        this.#combinedResult = replaceEqualDeep(
          this.#combinedResult,
          combine(input),
        )
      }

      return this.#combinedResult
    }
    return input as any
  }

  #findMatchingObservers(
    queries: Array<QueryObserverOptions>,
  ): Array<QueryObserverMatch> {
    const prevObserversMap = new Map(
      this.#observers.map((observer) => [observer.options.queryHash, observer]),
    )

    const observers: Array<QueryObserverMatch> = []

    queries.forEach((options) => {
      const defaultedOptions = this.#client.defaultQueryOptions(options)
      const match = prevObserversMap.get(defaultedOptions.queryHash)
      if (match) {
        observers.push({
          defaultedQueryOptions: defaultedOptions,
          observer: match,
        })
      } else {
        observers.push({
          defaultedQueryOptions: defaultedOptions,
          observer: new QueryObserver(this.#client, defaultedOptions),
        })
      }
    })

    return observers
  }

  #onUpdate(observer: QueryObserver, result: QueryObserverResult): void {
    const index = this.#observers.indexOf(observer)
    if (index !== -1) {
      this.#result = replaceAt(this.#result, index, result)
      this.#notify()
    }
  }

  #notify(): void {
    if (this.hasListeners()) {
      const previousResult = this.#combinedResult
      const newTracked = this.#trackResult(this.#result, this.#observerMatches)
      const newResult = this.#combineResult(newTracked, this.#options?.combine)

      if (previousResult !== newResult) {
        notifyManager.batch(() => {
          this.listeners.forEach((listener) => {
            listener(this.#result)
          })
        })
      }
    }
  }
}

type QueryObserverMatch = {
  defaultedQueryOptions: DefaultedQueryObserverOptions
  observer: QueryObserver
}



# ./src/thenable.ts

/**
 * Thenable types which matches React's types for promises
 *
 * React seemingly uses `.status`, `.value` and `.reason` properties on a promises to optimistically unwrap data from promises
 *
 * @see https://github.com/facebook/react/blob/main/packages/shared/ReactTypes.js#L112-L138
 * @see https://github.com/facebook/react/blob/4f604941569d2e8947ce1460a0b2997e835f37b9/packages/react-debug-tools/src/ReactDebugHooks.js#L224-L227
 */

interface Fulfilled<T> {
  status: 'fulfilled'
  value: T
}
interface Rejected {
  status: 'rejected'
  reason: unknown
}
interface Pending<T> {
  status: 'pending'

  /**
   * Resolve the promise with a value.
   * Will remove the `resolve` and `reject` properties from the promise.
   */
  resolve: (value: T) => void
  /**
   * Reject the promise with a reason.
   * Will remove the `resolve` and `reject` properties from the promise.
   */
  reject: (reason: unknown) => void
}

export type FulfilledThenable<T> = Promise<T> & Fulfilled<T>
export type RejectedThenable<T> = Promise<T> & Rejected
export type PendingThenable<T> = Promise<T> & Pending<T>

export type Thenable<T> =
  | FulfilledThenable<T>
  | RejectedThenable<T>
  | PendingThenable<T>

export function pendingThenable<T>(): PendingThenable<T> {
  let resolve: Pending<T>['resolve']
  let reject: Pending<T>['reject']
  // this could use `Promise.withResolvers()` in the future
  const thenable = new Promise((_resolve, _reject) => {
    resolve = _resolve
    reject = _reject
  }) as PendingThenable<T>

  thenable.status = 'pending'
  thenable.catch(() => {
    // prevent unhandled rejection errors
  })

  function finalize(data: Fulfilled<T> | Rejected) {
    Object.assign(thenable, data)

    // clear pending props props to avoid calling them twice
    delete (thenable as Partial<PendingThenable<T>>).resolve
    delete (thenable as Partial<PendingThenable<T>>).reject
  }

  thenable.resolve = (value) => {
    finalize({
      status: 'fulfilled',
      value,
    })

    resolve(value)
  }
  thenable.reject = (reason) => {
    finalize({
      status: 'rejected',
      reason,
    })

    reject(reason)
  }

  return thenable
}



# ./src/notifyManager.ts

// TYPES

type NotifyCallback = () => void

type NotifyFunction = (callback: () => void) => void

type BatchNotifyFunction = (callback: () => void) => void

type BatchCallsCallback<T extends Array<unknown>> = (...args: T) => void

type ScheduleFunction = (callback: () => void) => void

export function createNotifyManager() {
  let queue: Array<NotifyCallback> = []
  let transactions = 0
  let notifyFn: NotifyFunction = (callback) => {
    callback()
  }
  let batchNotifyFn: BatchNotifyFunction = (callback: () => void) => {
    callback()
  }
  let scheduleFn: ScheduleFunction = (cb) => setTimeout(cb, 0)

  const schedule = (callback: NotifyCallback): void => {
    if (transactions) {
      queue.push(callback)
    } else {
      scheduleFn(() => {
        notifyFn(callback)
      })
    }
  }
  const flush = (): void => {
    const originalQueue = queue
    queue = []
    if (originalQueue.length) {
      scheduleFn(() => {
        batchNotifyFn(() => {
          originalQueue.forEach((callback) => {
            notifyFn(callback)
          })
        })
      })
    }
  }

  return {
    batch: <T>(callback: () => T): T => {
      let result
      transactions++
      try {
        result = callback()
      } finally {
        transactions--
        if (!transactions) {
          flush()
        }
      }
      return result
    },
    /**
     * All calls to the wrapped function will be batched.
     */
    batchCalls: <T extends Array<unknown>>(
      callback: BatchCallsCallback<T>,
    ): BatchCallsCallback<T> => {
      return (...args) => {
        schedule(() => {
          callback(...args)
        })
      }
    },
    schedule,
    /**
     * Use this method to set a custom notify function.
     * This can be used to for example wrap notifications with `React.act` while running tests.
     */
    setNotifyFunction: (fn: NotifyFunction) => {
      notifyFn = fn
    },
    /**
     * Use this method to set a custom function to batch notifications together into a single tick.
     * By default React Query will use the batch function provided by ReactDOM or React Native.
     */
    setBatchNotifyFunction: (fn: BatchNotifyFunction) => {
      batchNotifyFn = fn
    },
    setScheduler: (fn: ScheduleFunction) => {
      scheduleFn = fn
    },
  } as const
}

// SINGLETON
export const notifyManager = createNotifyManager()
