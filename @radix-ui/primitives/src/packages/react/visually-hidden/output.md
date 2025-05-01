/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/visually-hidden/CHANGELOG.md
```
# @radix-ui/react-visually-hidden

## 1.2.0

- All form controls with internal bubble inputs now use the Radix `Primitive` component by default. This will allow us to expose these components directly so users can better control this behavior in the future.
- Updated dependencies: `@radix-ui/react-primitive@2.1.0`

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/visually-hidden/README.md
```
# `react-visually-hidden`

View docs [here](https://radix-ui.com/primitives/docs/utilities/visually-hidden).

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/visually-hidden/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/visually-hidden/package.json
```json
{
  "name": "@radix-ui/react-visually-hidden",
  "version": "1.2.0",
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
    "@radix-ui/react-primitive": "workspace:*"
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/visually-hidden/tsconfig.json
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/visually-hidden/src/index.ts
```typescript
export {
  VisuallyHidden,
  //
  Root,
  //
  VISUALLY_HIDDEN_STYLES,
} from './visually-hidden';
export type { VisuallyHiddenProps } from './visually-hidden';

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/visually-hidden/src/visually-hidden.tsx
```
import * as React from 'react';
import { Primitive } from '@radix-ui/react-primitive';

/* -------------------------------------------------------------------------------------------------
 * VisuallyHidden
 * -----------------------------------------------------------------------------------------------*/

const VISUALLY_HIDDEN_STYLES = Object.freeze({
  // See: https://github.com/twbs/bootstrap/blob/main/scss/mixins/_visually-hidden.scss
  position: 'absolute',
  border: 0,
  width: 1,
  height: 1,
  padding: 0,
  margin: -1,
  overflow: 'hidden',
  clip: 'rect(0, 0, 0, 0)',
  whiteSpace: 'nowrap',
  wordWrap: 'normal',
}) satisfies React.CSSProperties;

const NAME = 'VisuallyHidden';

type VisuallyHiddenElement = React.ElementRef<typeof Primitive.span>;
type PrimitiveSpanProps = React.ComponentPropsWithoutRef<typeof Primitive.span>;
interface VisuallyHiddenProps extends PrimitiveSpanProps {}

const VisuallyHidden = React.forwardRef<VisuallyHiddenElement, VisuallyHiddenProps>(
  (props, forwardedRef) => {
    return (
      <Primitive.span
        {...props}
        ref={forwardedRef}
        style={{ ...VISUALLY_HIDDEN_STYLES, ...props.style }}
      />
    );
  }
);

VisuallyHidden.displayName = NAME;

/* -----------------------------------------------------------------------------------------------*/

const Root = VisuallyHidden;

export {
  VisuallyHidden,
  //
  Root,
  //
  VISUALLY_HIDDEN_STYLES,
};
export type { VisuallyHiddenProps };

```
