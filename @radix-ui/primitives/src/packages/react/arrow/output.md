/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/arrow/CHANGELOG.md
```
# @radix-ui/react-arrow

## 1.1.4

- Updated dependencies: `@radix-ui/react-primitive@2.1.0`

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/arrow/README.md
```
# `react-arrow`

This is an internal utility, not intended for public usage.

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/arrow/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/arrow/package.json
```json
{
  "name": "@radix-ui/react-arrow",
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/arrow/tsconfig.json
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/arrow/src/arrow.test.tsx
```
import { axe } from 'vitest-axe';
import type { RenderResult } from '@testing-library/react';
import { cleanup, render } from '@testing-library/react';
import { Arrow } from './arrow';
import { afterEach, describe, it, beforeEach, expect } from 'vitest';

const WIDTH = 40;
const HEIGHT = 30;

describe('given a default Arrow', () => {
  let rendered: RenderResult;
  let svg: HTMLElement;

  afterEach(cleanup);

  beforeEach(() => {
    rendered = render(<Arrow width={WIDTH} height={HEIGHT} data-testid="test-arrow" />);
    svg = rendered.getByTestId('test-arrow');
  });

  it('should have no accessibility violations', async () => {
    expect(await axe(rendered.container)).toHaveNoViolations();
  });

  it('should have width attribute', () => {
    expect(svg).toHaveAttribute('width', String(WIDTH));
  });

  it('should have height attribute', () => {
    expect(svg).toHaveAttribute('height', String(HEIGHT));
  });
});

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/arrow/src/arrow.tsx
```
import * as React from 'react';
import { Primitive } from '@radix-ui/react-primitive';

/* -------------------------------------------------------------------------------------------------
 * Arrow
 * -----------------------------------------------------------------------------------------------*/

const NAME = 'Arrow';

type ArrowElement = React.ElementRef<typeof Primitive.svg>;
type PrimitiveSvgProps = React.ComponentPropsWithoutRef<typeof Primitive.svg>;
interface ArrowProps extends PrimitiveSvgProps {}

const Arrow = React.forwardRef<ArrowElement, ArrowProps>((props, forwardedRef) => {
  const { children, width = 10, height = 5, ...arrowProps } = props;
  return (
    <Primitive.svg
      {...arrowProps}
      ref={forwardedRef}
      width={width}
      height={height}
      viewBox="0 0 30 10"
      preserveAspectRatio="none"
    >
      {/* We use their children if they're slotting to replace the whole svg */}
      {props.asChild ? children : <polygon points="0,0 30,0 15,10" />}
    </Primitive.svg>
  );
});

Arrow.displayName = NAME;

/* -----------------------------------------------------------------------------------------------*/

const Root = Arrow;

export {
  Arrow,
  //
  Root,
};
export type { ArrowProps };

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/arrow/src/index.ts
```typescript
export {
  Arrow,
  //
  Root,
} from './arrow';
export type { ArrowProps } from './arrow';

```
