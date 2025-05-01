/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-size/README.md
```
# `react-use-size`

This is an internal utility, not intended for public usage.

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-size/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-size/package.json
```json
{
  "name": "@radix-ui/react-use-size",
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
  "dependencies": {
    "@radix-ui/react-use-layout-effect": "workspace:*"
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-size/tsconfig.json
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-size/src/index.ts
```typescript
export { useSize } from './use-size';

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-size/src/use-size.tsx
```
import * as React from 'react';
import { useLayoutEffect } from '@radix-ui/react-use-layout-effect';

function useSize(element: HTMLElement | null) {
  const [size, setSize] = React.useState<{ width: number; height: number } | undefined>(undefined);

  useLayoutEffect(() => {
    if (element) {
      // provide size as early as possible
      setSize({ width: element.offsetWidth, height: element.offsetHeight });

      const resizeObserver = new ResizeObserver((entries) => {
        if (!Array.isArray(entries)) {
          return;
        }

        // Since we only observe the one element, we don't need to loop over the
        // array
        if (!entries.length) {
          return;
        }

        const entry = entries[0]!;
        let width: number;
        let height: number;

        if ('borderBoxSize' in entry) {
          const borderSizeEntry = entry['borderBoxSize'];
          // iron out differences between browsers
          const borderSize = Array.isArray(borderSizeEntry) ? borderSizeEntry[0] : borderSizeEntry;
          width = borderSize['inlineSize'];
          height = borderSize['blockSize'];
        } else {
          // for browsers that don't support `borderBoxSize`
          // we calculate it ourselves to get the correct border box.
          width = element.offsetWidth;
          height = element.offsetHeight;
        }

        setSize({ width, height });
      });

      resizeObserver.observe(element, { box: 'border-box' });

      return () => resizeObserver.unobserve(element);
    } else {
      // We only want to reset to `undefined` when the element becomes `null`,
      // not if it changes to another element.
      setSize(undefined);
    }
  }, [element]);

  return size;
}

export { useSize };

```
