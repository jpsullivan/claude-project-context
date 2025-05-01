/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-is-hydrated/src/index.ts
```typescript
export { useIsHydrated } from './use-is-hydrated';

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-is-hydrated/src/use-is-hydrated.tsx
```
import { useSyncExternalStore } from 'use-sync-external-store/shim';

/**
 * Determines whether or not the component tree has been hydrated.
 */
export function useIsHydrated() {
  return useSyncExternalStore(
    subscribe,
    () => true,
    () => false
  );
}

function subscribe() {
  return () => {};
}

```
