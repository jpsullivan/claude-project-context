/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/portal/CHANGELOG.md
```
# @radix-ui/react-portal

## 1.1.6

- Updated dependencies: `@radix-ui/react-primitive@2.1.0`

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/portal/README.md
```
# `react-portal`

View docs [here](https://radix-ui.com/primitives/docs/utilities/portal).

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/portal/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/portal/package.json
```json
{
  "name": "@radix-ui/react-portal",
  "version": "1.1.6",
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
    "@radix-ui/react-primitive": "workspace:*",
    "@radix-ui/react-use-layout-effect": "workspace:*"
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
    "@types/react-dom": "*",
    "react": "^16.8 || ^17.0 || ^18.0 || ^19.0 || ^19.0.0-rc",
    "react-dom": "^16.8 || ^17.0 || ^18.0 || ^19.0 || ^19.0.0-rc"
  },
  "peerDependenciesMeta": {
    "@types/react": {
      "optional": true
    },
    "@types/react-dom": {
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
  }
}

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/portal/tsconfig.json
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/portal/src/index.ts
```typescript
'use client';
export {
  Portal,
  //
  Root,
} from './portal';
export type { PortalProps } from './portal';

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/portal/src/portal.tsx
```
import * as React from 'react';
import ReactDOM from 'react-dom';
import { Primitive } from '@radix-ui/react-primitive';
import { useLayoutEffect } from '@radix-ui/react-use-layout-effect';

/* -------------------------------------------------------------------------------------------------
 * Portal
 * -----------------------------------------------------------------------------------------------*/

const PORTAL_NAME = 'Portal';

type PortalElement = React.ElementRef<typeof Primitive.div>;
type PrimitiveDivProps = React.ComponentPropsWithoutRef<typeof Primitive.div>;
interface PortalProps extends PrimitiveDivProps {
  /**
   * An optional container where the portaled content should be appended.
   */
  container?: Element | DocumentFragment | null;
}

const Portal = React.forwardRef<PortalElement, PortalProps>((props, forwardedRef) => {
  const { container: containerProp, ...portalProps } = props;
  const [mounted, setMounted] = React.useState(false);
  useLayoutEffect(() => setMounted(true), []);
  const container = containerProp || (mounted && globalThis?.document?.body);
  return container
    ? ReactDOM.createPortal(<Primitive.div {...portalProps} ref={forwardedRef} />, container)
    : null;
});

Portal.displayName = PORTAL_NAME;

/* -----------------------------------------------------------------------------------------------*/

const Root = Portal;

export {
  Portal,
  //
  Root,
};
export type { PortalProps };

```
