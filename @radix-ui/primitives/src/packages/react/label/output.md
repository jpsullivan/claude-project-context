/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/label/CHANGELOG.md
```
# @radix-ui/react-label

## 2.1.4

- Updated dependencies: `@radix-ui/react-primitive@2.1.0`

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/label/README.md
```
# `react-label`

View docs [here](https://radix-ui.com/primitives/docs/utilities/label).

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/label/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/label/package.json
```json
{
  "name": "@radix-ui/react-label",
  "version": "2.1.4",
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/label/tsconfig.json
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/label/src/index.ts
```typescript
'use client';
export {
  Label,
  //
  Root,
} from './label';
export type { LabelProps } from './label';

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/label/src/label.tsx
```
import * as React from 'react';
import { Primitive } from '@radix-ui/react-primitive';

/* -------------------------------------------------------------------------------------------------
 * Label
 * -----------------------------------------------------------------------------------------------*/

const NAME = 'Label';

type LabelElement = React.ElementRef<typeof Primitive.label>;
type PrimitiveLabelProps = React.ComponentPropsWithoutRef<typeof Primitive.label>;
interface LabelProps extends PrimitiveLabelProps {}

const Label = React.forwardRef<LabelElement, LabelProps>((props, forwardedRef) => {
  return (
    <Primitive.label
      {...props}
      ref={forwardedRef}
      onMouseDown={(event) => {
        // only prevent text selection if clicking inside the label itself
        const target = event.target as HTMLElement;
        if (target.closest('button, input, select, textarea')) return;

        props.onMouseDown?.(event);
        // prevent text selection when double clicking label
        if (!event.defaultPrevented && event.detail > 1) event.preventDefault();
      }}
    />
  );
});

Label.displayName = NAME;

/* -----------------------------------------------------------------------------------------------*/

const Root = Label;

export {
  Label,
  //
  Root,
};
export type { LabelProps };

```
