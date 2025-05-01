/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-effect-event/CHANGELOG.md
```
# @radix-ui/react-use-effect-event

## 0.0.2

- Patch additional issues with conditional React imports

## 0.0.1

- Update how potentially missing React APIs are imported to breaking webpack builds. See https://github.com/radix-ui/primitives/issues/3485.

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-effect-event/README.md
```
# `react-use-is-hydrated`

## Usage

This is an internal utility, not intended for public usage.

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-effect-event/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-effect-event/package.json
```json
{
  "name": "@radix-ui/react-use-effect-event",
  "version": "0.0.2",
  "license": "MIT",
  "source": "./src/index.ts",
  "main": "./src/index.ts",
  "module": "./src/index.ts",
  "publishConfig": {
    "main": "./dist/index.js",
    "module": "./dist/index.mjs",
    "types": "./dist/index.d.ts",
    "exports": {
      ".": {
        "import": {
          "types": "./dist/index.d.mts",
          "default": "./dist/index.mjs"
        },
        "require": {
          "types": "./dist/index.d.ts",
          "default": "./dist/index.js"
        }
      }
    }
  },
  "files": [
    "src",
    "dist",
    "README.md"
  ],
  "sideEffects": false,
  "scripts": {
    "lint": "eslint --max-warnings 0 src",
    "clean": "rm -rf dist",
    "typecheck": "tsc --noEmit",
    "build": "radix-build"
  },
  "peerDependencies": {
    "@types/react": "*",
    "react": "^16.8 || ^17.0 || ^18.0 || ^19.0 || ^19.0.0-rc"
  },
  "peerDependenciesMeta": {
    "@types/react": {
      "optional": true
    }
  },
  "dependencies": {
    "@radix-ui/react-use-layout-effect": "workspace:*"
  },
  "devDependencies": {
    "@repo/builder": "workspace:*",
    "@repo/eslint-config": "workspace:*",
    "@repo/typescript-config": "workspace:*",
    "@types/react": "^19.0.7",
    "@types/react-dom": "^19.0.3",
    "@types/use-sync-external-store": "^0.0.6",
    "eslint": "^9.18.0",
    "react": "^19.1.0",
    "react-dom": "^19.1.0",
    "typescript": "^5.7.3"
  },
  "homepage": "https://radix-ui.com/primitives",
  "repository": {
    "type": "git",
    "url": "git+https://github.com/radix-ui/primitives.git"
  },
  "bugs": {
    "url": "https://github.com/radix-ui/primitives/issues"
  }
}

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-effect-event/tsconfig.json
```json
{
  "extends": "@repo/typescript-config/react-library.json",
  "compilerOptions": {
    "outDir": "dist",
    "types": ["@repo/typescript-config/react-library"]
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-effect-event/src/index.ts
```typescript
export { useEffectEvent } from './use-effect-event';

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-effect-event/src/use-effect-event.tsx
```
/* eslint-disable react-hooks/rules-of-hooks */
import { useLayoutEffect } from '@radix-ui/react-use-layout-effect';
import * as React from 'react';

type AnyFunction = (...args: any[]) => any;

// See https://github.com/webpack/webpack/issues/14814
const useReactEffectEvent = (React as any)[' useEffectEvent '.trim().toString()];
const useReactInsertionEffect = (React as any)[' useInsertionEffect '.trim().toString()];

/**
 * Designed to approximate the behavior on `experimental_useEffectEvent` as best
 * as possible until its stable release, and back-fill it as a shim as needed.
 */
export function useEffectEvent<T extends AnyFunction>(callback?: T): T {
  if (typeof useReactEffectEvent === 'function') {
    return useReactEffectEvent(callback);
  }

  const ref = React.useRef<AnyFunction | undefined>(() => {
    throw new Error('Cannot call an event handler while rendering.');
  });
  // See https://github.com/webpack/webpack/issues/14814
  if (typeof useReactInsertionEffect === 'function') {
    useReactInsertionEffect(() => {
      ref.current = callback;
    });
  } else {
    useLayoutEffect(() => {
      ref.current = callback;
    });
  }

  // https://github.com/facebook/react/issues/19240
  return React.useMemo(() => ((...args) => ref.current?.(...args)) as T, []);
}

```
