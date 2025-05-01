/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-is-hydrated/README.md
```
# `react-use-is-hydrated`

## Usage

This is an internal utility, not intended for public usage.

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-is-hydrated/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-is-hydrated/package.json
```json
{
  "name": "@radix-ui/react-use-is-hydrated",
  "version": "0.0.0",
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
  "dependencies": {
    "use-sync-external-store": "^1.4.0"
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-is-hydrated/tsconfig.json
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
