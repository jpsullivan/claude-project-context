/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/toggle/CHANGELOG.md
```
# @radix-ui/react-toggle

## 1.1.6

- Updated dependencies: `@radix-ui/react-use-controllable-state@1.2.2`

## 1.1.5

- Updated dependencies: `@radix-ui/react-use-controllable-state@1.2.1`

## 1.1.4

- Minor improvements to `useControllableState` to enhance performance, reduce surface area for bugs, and log warnings when misused (#3455)
- Updated dependencies: `@radix-ui/react-use-controllable-state@1.2.0`, `@radix-ui/react-primitive@2.1.0`

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/toggle/README.md
```
# `react-toggle`

View docs [here](https://radix-ui.com/primitives/docs/components/toggle).

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/toggle/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/toggle/package.json
```json
{
  "name": "@radix-ui/react-toggle",
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
    "@radix-ui/primitive": "workspace:*",
    "@radix-ui/react-primitive": "workspace:*",
    "@radix-ui/react-use-controllable-state": "workspace:*"
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/toggle/tsconfig.json
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/toggle/src/index.ts
```typescript
'use client';
export {
  Toggle,
  //
  Root,
} from './toggle';
export type { ToggleProps } from './toggle';

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/toggle/src/toggle.test.tsx
```
import type { RenderResult } from '@testing-library/react';
import { cleanup, fireEvent, render } from '@testing-library/react';
import * as Toggle from './toggle';
import { axe } from 'vitest-axe';
import { afterEach, describe, it, beforeEach, vi, expect } from 'vitest';

const TEXT_CHILD = 'Like';

describe('given a Toggle with text', () => {
  let rendered: RenderResult;

  beforeEach(() => {
    rendered = render(<Toggle.Root>{TEXT_CHILD}</Toggle.Root>);
  });

  afterEach(cleanup);

  it('should have no accessibility violations', async () => {
    expect(await axe(rendered.container)).toHaveNoViolations();
  });

  it('should render with attributes as false/off by default', () => {
    const button = rendered.getByRole('button', { name: TEXT_CHILD });

    expect(button).toHaveAttribute('aria-pressed', 'false');
    expect(button).toHaveAttribute('data-state', 'off');
  });

  it('Click event should change pressed attributes to true/on', () => {
    const button = rendered.getByRole('button', { name: TEXT_CHILD });

    fireEvent(
      button,
      new MouseEvent('click', {
        bubbles: true,
        cancelable: true,
      })
    );

    expect(button).toHaveAttribute('aria-pressed', 'true');
    expect(button).toHaveAttribute('data-state', 'on');
  });
});

describe('given a Toggle with text and defaultPressed="true"', () => {
  let rendered: RenderResult;

  beforeEach(() => {
    rendered = render(<Toggle.Root defaultPressed>{TEXT_CHILD}</Toggle.Root>);
  });

  afterEach(cleanup);

  it('should render with attributes true/on by default', () => {
    const button = rendered.getByRole('button', { name: TEXT_CHILD });

    expect(button).toHaveAttribute('aria-pressed', 'true');
    expect(button).toHaveAttribute('data-state', 'on');
  });

  it('Click event should change attributes back to off/false', () => {
    const button = rendered.getByRole('button', { name: TEXT_CHILD });

    fireEvent(
      button,
      new MouseEvent('click', {
        bubbles: true,
        cancelable: true,
      })
    );

    expect(button).toHaveAttribute('aria-pressed', 'false');
    expect(button).toHaveAttribute('data-state', 'off');
  });
});

describe('given a Toggle with text and disabled="true"', () => {
  let rendered: RenderResult;

  beforeEach(() => {
    rendered = render(<Toggle.Root disabled>{TEXT_CHILD}</Toggle.Root>);
  });

  afterEach(cleanup);

  it('on click the attributes do not change', () => {
    const button = rendered.getByRole('button', { name: TEXT_CHILD });

    expect(button).toHaveAttribute('aria-pressed', 'false');
    expect(button).toHaveAttribute('data-state', 'off');
    expect(button).toHaveAttribute('disabled', '');

    fireEvent(
      button,
      new MouseEvent('click', {
        bubbles: true,
        cancelable: true,
      })
    );

    expect(button).toHaveAttribute('aria-pressed', 'false');
    expect(button).toHaveAttribute('data-state', 'off');
  });
});

describe('given a controlled Toggle (with pressed and onPressedChange)', () => {
  let rendered: RenderResult;
  const onPressedChangeMock = vi.fn();

  beforeEach(() => {
    rendered = render(
      <Toggle.Root pressed onPressedChange={onPressedChangeMock}>
        {TEXT_CHILD}
      </Toggle.Root>
    );
  });

  afterEach(cleanup);

  it('Click event should keep the same attributes, and pass the new state to onPressedChange', () => {
    const button = rendered.getByRole('button', { name: TEXT_CHILD });

    expect(button).toHaveAttribute('aria-pressed', 'true');
    expect(button).toHaveAttribute('data-state', 'on');

    fireEvent(
      button,
      new MouseEvent('click', {
        bubbles: true,
        cancelable: true,
      })
    );

    expect(onPressedChangeMock).toHaveBeenCalledTimes(1);
    expect(onPressedChangeMock).toHaveBeenCalledWith(false);

    // The attributes do not change, they keep the same
    // because it's a controlled component.
    expect(button).toHaveAttribute('aria-pressed', 'true');
    expect(button).toHaveAttribute('data-state', 'on');
  });
});

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/toggle/src/toggle.tsx
```
import * as React from 'react';
import { composeEventHandlers } from '@radix-ui/primitive';
import { useControllableState } from '@radix-ui/react-use-controllable-state';
import { Primitive } from '@radix-ui/react-primitive';

/* -------------------------------------------------------------------------------------------------
 * Toggle
 * -----------------------------------------------------------------------------------------------*/

const NAME = 'Toggle';

type ToggleElement = React.ElementRef<typeof Primitive.button>;
type PrimitiveButtonProps = React.ComponentPropsWithoutRef<typeof Primitive.button>;
interface ToggleProps extends PrimitiveButtonProps {
  /**
   * The controlled state of the toggle.
   */
  pressed?: boolean;
  /**
   * The state of the toggle when initially rendered. Use `defaultPressed`
   * if you do not need to control the state of the toggle.
   * @defaultValue false
   */
  defaultPressed?: boolean;
  /**
   * The callback that fires when the state of the toggle changes.
   */
  onPressedChange?(pressed: boolean): void;
}

const Toggle = React.forwardRef<ToggleElement, ToggleProps>((props, forwardedRef) => {
  const { pressed: pressedProp, defaultPressed, onPressedChange, ...buttonProps } = props;

  const [pressed, setPressed] = useControllableState({
    prop: pressedProp,
    onChange: onPressedChange,
    defaultProp: defaultPressed ?? false,
    caller: NAME,
  });

  return (
    <Primitive.button
      type="button"
      aria-pressed={pressed}
      data-state={pressed ? 'on' : 'off'}
      data-disabled={props.disabled ? '' : undefined}
      {...buttonProps}
      ref={forwardedRef}
      onClick={composeEventHandlers(props.onClick, () => {
        if (!props.disabled) {
          setPressed(!pressed);
        }
      })}
    />
  );
});

Toggle.displayName = NAME;

/* ---------------------------------------------------------------------------------------------- */

const Root = Toggle;

export {
  Toggle,
  //
  Root,
};
export type { ToggleProps };

```
