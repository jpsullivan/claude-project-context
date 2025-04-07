/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/client/react/index.ts
```typescript
import { getClientConfig } from "../config";
import type {
	BetterAuthClientPlugin,
	ClientOptions,
	InferActions,
	InferClientAPI,
	InferErrorCodes,
	IsSignal,
} from "../types";
import { createDynamicPathProxy } from "../proxy";
import type { PrettifyDeep, UnionToIntersection } from "../../types/helper";
import type {
	BetterFetchError,
	BetterFetchResponse,
} from "@better-fetch/fetch";
import { useStore } from "./react-store";
import type { BASE_ERROR_CODES } from "../../error/codes";

function getAtomKey(str: string) {
	return `use${capitalizeFirstLetter(str)}`;
}

export function capitalizeFirstLetter(str: string) {
	return str.charAt(0).toUpperCase() + str.slice(1);
}

type InferResolvedHooks<O extends ClientOptions> = O["plugins"] extends Array<
	infer Plugin
>
	? Plugin extends BetterAuthClientPlugin
		? Plugin["getAtoms"] extends (fetch: any) => infer Atoms
			? Atoms extends Record<string, any>
				? {
						[key in keyof Atoms as IsSignal<key> extends true
							? never
							: key extends string
								? `use${Capitalize<key>}`
								: never]: () => ReturnType<Atoms[key]["get"]>;
					}
				: {}
			: {}
		: {}
	: {};

export function createAuthClient<Option extends ClientOptions>(
	options?: Option,
) {
	const {
		pluginPathMethods,
		pluginsActions,
		pluginsAtoms,
		$fetch,
		$store,
		atomListeners,
	} = getClientConfig(options);
	let resolvedHooks: Record<string, any> = {};
	for (const [key, value] of Object.entries(pluginsAtoms)) {
		resolvedHooks[getAtomKey(key)] = () => useStore(value);
	}

	const routes = {
		...pluginsActions,
		...resolvedHooks,
		$fetch,
		$store,
	};
	const proxy = createDynamicPathProxy(
		routes,
		$fetch,
		pluginPathMethods,
		pluginsAtoms,
		atomListeners,
	);

	type ClientAPI = InferClientAPI<Option>;
	type Session = ClientAPI extends {
		getSession: () => Promise<infer Res>;
	}
		? Res extends BetterFetchResponse<infer S>
			? S
			: Res
		: never;
	return proxy as UnionToIntersection<InferResolvedHooks<Option>> &
		ClientAPI &
		InferActions<Option> & {
			useSession: () => {
				data: Session;
				isPending: boolean;
				error: BetterFetchError | null;
				refetch: () => void;
			};
			$Infer: {
				Session: NonNullable<Session>;
			};
			$fetch: typeof $fetch;
			$store: typeof $store;
			$ERROR_CODES: PrettifyDeep<
				InferErrorCodes<Option> & typeof BASE_ERROR_CODES
			>;
		};
}

export { useStore };
export type * from "@better-fetch/fetch";
export type * from "nanostores";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/client/react/react-store.ts
````typescript
import { listenKeys } from "nanostores";
import { useCallback, useRef, useSyncExternalStore } from "react";
import type { Store, StoreValue } from "nanostores";
import type { DependencyList } from "react";

type StoreKeys<T> = T extends { setKey: (k: infer K, v: any) => unknown }
	? K
	: never;

export interface UseStoreOptions<SomeStore> {
	/**
	 * @default
	 * ```ts
	 * [store, options.keys]
	 * ```
	 */
	deps?: DependencyList;

	/**
	 * Will re-render components only on specific key changes.
	 */
	keys?: StoreKeys<SomeStore>[];
}

/**
 * Subscribe to store changes and get store's value.
 *
 * Can be user with store builder too.
 *
 * ```js
 * import { useStore } from 'nanostores/react'
 *
 * import { router } from '../store/router'
 *
 * export const Layout = () => {
 *   let page = useStore(router)
 *   if (page.route === 'home') {
 *     return <HomePage />
 *   } else {
 *     return <Error404 />
 *   }
 * }
 * ```
 *
 * @param store Store instance.
 * @returns Store value.
 */
export function useStore<SomeStore extends Store>(
	store: SomeStore,
	options: UseStoreOptions<SomeStore> = {},
): StoreValue<SomeStore> {
	let snapshotRef = useRef<StoreValue<SomeStore>>(store.get());

	const { keys, deps = [store, keys] } = options;

	let subscribe = useCallback((onChange: () => void) => {
		const emitChange = (value: StoreValue<SomeStore>) => {
			if (snapshotRef.current === value) return;
			snapshotRef.current = value;
			onChange();
		};

		emitChange(store.value);
		if (keys?.length) {
			return listenKeys(store as any, keys, emitChange);
		}
		return store.listen(emitChange);
	}, deps);

	let get = () => snapshotRef.current as StoreValue<SomeStore>;

	return useSyncExternalStore(subscribe, get, get);
}

````
