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
