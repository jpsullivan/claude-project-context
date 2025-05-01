/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/id/README.md
```
# `react-id`

View docs [here](https://radix-ui.com/primitives/docs/utilities/id-provider).

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/id/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/id/package.json
```json
{
  "name": "@radix-ui/react-id",
  "version": "1.1.1",
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
  "devDependencies": {
    "@repo/builder": "workspace:*",
    "@repo/eslint-config": "workspace:*",
    "@repo/typescript-config": "workspace:*",
    "@types/react": "^19.0.7",
    "@types/react-dom": "^19.0.3",
    "eslint": "^9.18.0",
    "react": "^19.1.0",
    "react-dom": "^19.1.0",
    "typescript": "^5.7.3"
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
  "homepage": "https://radix-ui.com/primitives",
  "repository": {
    "type": "git",
    "url": "git+https://github.com/radix-ui/primitives.git"
  },
  "bugs": {
    "url": "https://github.com/radix-ui/primitives/issues"
  },
  "dependencies": {
    "@radix-ui/react-use-layout-effect": "workspace:*"
  }
}

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/id/tsconfig.json
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/id/src/id.tsx
```
import * as React from 'react';
import { useLayoutEffect } from '@radix-ui/react-use-layout-effect';

// We spaces with `.trim().toString()` to prevent bundlers from trying to `import { useId } from 'react';`
const useReactId = (React as any)[' useId '.trim().toString()] || (() => undefined);
let count = 0;

function useId(deterministicId?: string): string {
  const [id, setId] = React.useState<string | undefined>(useReactId());
  // React versions older than 18 will have client-side ids only.
  useLayoutEffect(() => {
    if (!deterministicId) setId((reactId) => reactId ?? String(count++));
  }, [deterministicId]);
  return deterministicId || (id ? `radix-${id}` : '');
}

export { useId };

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/id/src/index.ts
```typescript
export { useId } from './id';

```
