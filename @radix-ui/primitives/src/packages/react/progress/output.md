/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/progress/CHANGELOG.md
```
# @radix-ui/react-progress

## 1.1.4

- Updated dependencies: `@radix-ui/react-primitive@2.1.0`

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/progress/README.md
```
# `react-progress`

View docs [here](https://radix-ui.com/primitives/docs/components/progress).

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/progress/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/progress/package.json
```json
{
  "name": "@radix-ui/react-progress",
  "version": "1.1.4",
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
    "@radix-ui/react-context": "workspace:*",
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/progress/tsconfig.json
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/progress/src/index.ts
```typescript
'use client';
export {
  createProgressScope,
  //
  Progress,
  ProgressIndicator,
  //
  Root,
  Indicator,
} from './progress';
export type { ProgressProps, ProgressIndicatorProps } from './progress';

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/progress/src/progress.tsx
```
import * as React from 'react';
import { createContextScope } from '@radix-ui/react-context';
import { Primitive } from '@radix-ui/react-primitive';

import type { Scope } from '@radix-ui/react-context';

/* -------------------------------------------------------------------------------------------------
 * Progress
 * -----------------------------------------------------------------------------------------------*/

const PROGRESS_NAME = 'Progress';
const DEFAULT_MAX = 100;

type ScopedProps<P> = P & { __scopeProgress?: Scope };
const [createProgressContext, createProgressScope] = createContextScope(PROGRESS_NAME);

type ProgressState = 'indeterminate' | 'complete' | 'loading';
type ProgressContextValue = { value: number | null; max: number };
const [ProgressProvider, useProgressContext] =
  createProgressContext<ProgressContextValue>(PROGRESS_NAME);

type ProgressElement = React.ElementRef<typeof Primitive.div>;
type PrimitiveDivProps = React.ComponentPropsWithoutRef<typeof Primitive.div>;
interface ProgressProps extends PrimitiveDivProps {
  value?: number | null | undefined;
  max?: number;
  getValueLabel?(value: number, max: number): string;
}

const Progress = React.forwardRef<ProgressElement, ProgressProps>(
  (props: ScopedProps<ProgressProps>, forwardedRef) => {
    const {
      __scopeProgress,
      value: valueProp = null,
      max: maxProp,
      getValueLabel = defaultGetValueLabel,
      ...progressProps
    } = props;

    if ((maxProp || maxProp === 0) && !isValidMaxNumber(maxProp)) {
      console.error(getInvalidMaxError(`${maxProp}`, 'Progress'));
    }

    const max = isValidMaxNumber(maxProp) ? maxProp : DEFAULT_MAX;

    if (valueProp !== null && !isValidValueNumber(valueProp, max)) {
      console.error(getInvalidValueError(`${valueProp}`, 'Progress'));
    }

    const value = isValidValueNumber(valueProp, max) ? valueProp : null;
    const valueLabel = isNumber(value) ? getValueLabel(value, max) : undefined;

    return (
      <ProgressProvider scope={__scopeProgress} value={value} max={max}>
        <Primitive.div
          aria-valuemax={max}
          aria-valuemin={0}
          aria-valuenow={isNumber(value) ? value : undefined}
          aria-valuetext={valueLabel}
          role="progressbar"
          data-state={getProgressState(value, max)}
          data-value={value ?? undefined}
          data-max={max}
          {...progressProps}
          ref={forwardedRef}
        />
      </ProgressProvider>
    );
  }
);

Progress.displayName = PROGRESS_NAME;

/* -------------------------------------------------------------------------------------------------
 * ProgressIndicator
 * -----------------------------------------------------------------------------------------------*/

const INDICATOR_NAME = 'ProgressIndicator';

type ProgressIndicatorElement = React.ElementRef<typeof Primitive.div>;
interface ProgressIndicatorProps extends PrimitiveDivProps {}

const ProgressIndicator = React.forwardRef<ProgressIndicatorElement, ProgressIndicatorProps>(
  (props: ScopedProps<ProgressIndicatorProps>, forwardedRef) => {
    const { __scopeProgress, ...indicatorProps } = props;
    const context = useProgressContext(INDICATOR_NAME, __scopeProgress);
    return (
      <Primitive.div
        data-state={getProgressState(context.value, context.max)}
        data-value={context.value ?? undefined}
        data-max={context.max}
        {...indicatorProps}
        ref={forwardedRef}
      />
    );
  }
);

ProgressIndicator.displayName = INDICATOR_NAME;

/* ---------------------------------------------------------------------------------------------- */

function defaultGetValueLabel(value: number, max: number) {
  return `${Math.round((value / max) * 100)}%`;
}

function getProgressState(value: number | undefined | null, maxValue: number): ProgressState {
  return value == null ? 'indeterminate' : value === maxValue ? 'complete' : 'loading';
}

function isNumber(value: any): value is number {
  return typeof value === 'number';
}

function isValidMaxNumber(max: any): max is number {
  // prettier-ignore
  return (
    isNumber(max) &&
    !isNaN(max) &&
    max > 0
  );
}

function isValidValueNumber(value: any, max: number): value is number {
  // prettier-ignore
  return (
    isNumber(value) &&
    !isNaN(value) &&
    value <= max &&
    value >= 0
  );
}

// Split this out for clearer readability of the error message.
function getInvalidMaxError(propValue: string, componentName: string) {
  return `Invalid prop \`max\` of value \`${propValue}\` supplied to \`${componentName}\`. Only numbers greater than 0 are valid max values. Defaulting to \`${DEFAULT_MAX}\`.`;
}

function getInvalidValueError(propValue: string, componentName: string) {
  return `Invalid prop \`value\` of value \`${propValue}\` supplied to \`${componentName}\`. The \`value\` prop must be:
  - a positive number
  - less than the value passed to \`max\` (or ${DEFAULT_MAX} if no \`max\` prop is set)
  - \`null\` or \`undefined\` if the progress is indeterminate.

Defaulting to \`null\`.`;
}

const Root = Progress;
const Indicator = ProgressIndicator;

export {
  createProgressScope,
  //
  Progress,
  ProgressIndicator,
  //
  Root,
  Indicator,
};
export type { ProgressProps, ProgressIndicatorProps };

```
