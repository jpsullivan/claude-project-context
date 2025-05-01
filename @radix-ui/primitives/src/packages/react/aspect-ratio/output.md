/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/aspect-ratio/CHANGELOG.md
```
# @radix-ui/react-aspect-ratio

## 1.1.4

- Updated dependencies: `@radix-ui/react-primitive@2.1.0`

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/aspect-ratio/README.md
```
# `react-aspect-ratio`

View docs [here](https://radix-ui.com/primitives/docs/utilities/aspect-ratio).

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/aspect-ratio/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/aspect-ratio/package.json
```json
{
  "name": "@radix-ui/react-aspect-ratio",
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/aspect-ratio/tsconfig.json
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/aspect-ratio/src/aspect-ratio.test.tsx
```
import { axe } from 'vitest-axe';
import type { RenderResult } from '@testing-library/react';
import { cleanup, render } from '@testing-library/react';
import { AspectRatio } from './aspect-ratio';
import { afterEach, describe, it, beforeEach, expect } from 'vitest';

const RATIO = 1 / 2;

describe('given a default Arrow', () => {
  let rendered: RenderResult;

  afterEach(cleanup);

  beforeEach(() => {
    rendered = render(
      <div style={{ width: 500 }}>
        <AspectRatio ratio={RATIO}>
          <span>Hello</span>
        </AspectRatio>
      </div>
    );
  });

  it('should have no accessibility violations', async () => {
    expect(await axe(rendered.container)).toHaveNoViolations();
  });
});

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/aspect-ratio/src/aspect-ratio.tsx
```
import * as React from 'react';
import { Primitive } from '@radix-ui/react-primitive';

/* -------------------------------------------------------------------------------------------------
 * AspectRatio
 * -----------------------------------------------------------------------------------------------*/

const NAME = 'AspectRatio';

type AspectRatioElement = React.ElementRef<typeof Primitive.div>;
type PrimitiveDivProps = React.ComponentPropsWithoutRef<typeof Primitive.div>;
interface AspectRatioProps extends PrimitiveDivProps {
  ratio?: number;
}

const AspectRatio = React.forwardRef<AspectRatioElement, AspectRatioProps>(
  (props, forwardedRef) => {
    const { ratio = 1 / 1, style, ...aspectRatioProps } = props;
    return (
      <div
        style={{
          // ensures inner element is contained
          position: 'relative',
          // ensures padding bottom trick maths works
          width: '100%',
          paddingBottom: `${100 / ratio}%`,
        }}
        data-radix-aspect-ratio-wrapper=""
      >
        <Primitive.div
          {...aspectRatioProps}
          ref={forwardedRef}
          style={{
            ...style,
            // ensures children expand in ratio
            position: 'absolute',
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
          }}
        />
      </div>
    );
  }
);

AspectRatio.displayName = NAME;

/* -----------------------------------------------------------------------------------------------*/

const Root = AspectRatio;

export {
  AspectRatio,
  //
  Root,
};
export type { AspectRatioProps };

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/aspect-ratio/src/index.ts
```typescript
export {
  AspectRatio,
  //
  Root,
} from './aspect-ratio';
export type { AspectRatioProps } from './aspect-ratio';

```
