/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/switch/CHANGELOG.md
```
# @radix-ui/react-switch

## 1.2.2

- Updated dependencies: `@radix-ui/react-use-controllable-state@1.2.2`

## 1.2.1

- Updated dependencies: `@radix-ui/react-use-controllable-state@1.2.1`

## 1.2.0

- All form controls with internal bubble inputs now use the Radix `Primitive` component by default. This will allow us to expose these components directly so users can better control this behavior in the future.
- Minor improvements to `useControllableState` to enhance performance, reduce surface area for bugs, and log warnings when misused (#3455)
- Updated dependencies: `@radix-ui/react-use-controllable-state@1.2.0`, `@radix-ui/react-primitive@2.1.0`

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/switch/README.md
```
# `react-switch`

View docs [here](https://radix-ui.com/primitives/docs/components/switch).

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/switch/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/switch/package.json
```json
{
  "name": "@radix-ui/react-switch",
  "version": "1.2.2",
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
    "@radix-ui/react-compose-refs": "workspace:*",
    "@radix-ui/react-context": "workspace:*",
    "@radix-ui/react-primitive": "workspace:*",
    "@radix-ui/react-use-controllable-state": "workspace:*",
    "@radix-ui/react-use-previous": "workspace:*",
    "@radix-ui/react-use-size": "workspace:*"
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/switch/tsconfig.json
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/switch/src/index.ts
```typescript
'use client';
export {
  createSwitchScope,
  //
  Switch,
  SwitchThumb,
  //
  Root,
  Thumb,
} from './switch';
export type { SwitchProps, SwitchThumbProps } from './switch';

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/switch/src/switch.test.tsx
```
import * as Switch from './switch';
import { cleanup, render } from '@testing-library/react';
import { afterEach, describe, it, expect } from 'vitest';

describe('given a default Switch', () => {
  afterEach(cleanup);

  let cleanedUp = false;

  function Test() {
    return (
      <Switch.Root
        ref={() => () => {
          cleanedUp = true;
        }}
      >
        <Switch.Thumb />
      </Switch.Root>
    );
  }

  it('should correctly invoke the cleanup function of a ref callback', () => {
    const rendered = render(<Test />);
    rendered.unmount();
    expect(cleanedUp).toBe(true);
  });
});

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/switch/src/switch.tsx
```
import * as React from 'react';
import { composeEventHandlers } from '@radix-ui/primitive';
import { useComposedRefs } from '@radix-ui/react-compose-refs';
import { createContextScope } from '@radix-ui/react-context';
import { useControllableState } from '@radix-ui/react-use-controllable-state';
import { usePrevious } from '@radix-ui/react-use-previous';
import { useSize } from '@radix-ui/react-use-size';
import { Primitive } from '@radix-ui/react-primitive';

import type { Scope } from '@radix-ui/react-context';

/* -------------------------------------------------------------------------------------------------
 * Switch
 * -----------------------------------------------------------------------------------------------*/

const SWITCH_NAME = 'Switch';

type ScopedProps<P> = P & { __scopeSwitch?: Scope };
const [createSwitchContext, createSwitchScope] = createContextScope(SWITCH_NAME);

type SwitchContextValue = { checked: boolean; disabled?: boolean };
const [SwitchProvider, useSwitchContext] = createSwitchContext<SwitchContextValue>(SWITCH_NAME);

type SwitchElement = React.ElementRef<typeof Primitive.button>;
type PrimitiveButtonProps = React.ComponentPropsWithoutRef<typeof Primitive.button>;
interface SwitchProps extends PrimitiveButtonProps {
  checked?: boolean;
  defaultChecked?: boolean;
  required?: boolean;
  onCheckedChange?(checked: boolean): void;
}

const Switch = React.forwardRef<SwitchElement, SwitchProps>(
  (props: ScopedProps<SwitchProps>, forwardedRef) => {
    const {
      __scopeSwitch,
      name,
      checked: checkedProp,
      defaultChecked,
      required,
      disabled,
      value = 'on',
      onCheckedChange,
      form,
      ...switchProps
    } = props;
    const [button, setButton] = React.useState<HTMLButtonElement | null>(null);
    const composedRefs = useComposedRefs(forwardedRef, (node) => setButton(node));
    const hasConsumerStoppedPropagationRef = React.useRef(false);
    // We set this to true by default so that events bubble to forms without JS (SSR)
    const isFormControl = button ? form || !!button.closest('form') : true;
    const [checked, setChecked] = useControllableState({
      prop: checkedProp,
      defaultProp: defaultChecked ?? false,
      onChange: onCheckedChange,
      caller: SWITCH_NAME,
    });

    return (
      <SwitchProvider scope={__scopeSwitch} checked={checked} disabled={disabled}>
        <Primitive.button
          type="button"
          role="switch"
          aria-checked={checked}
          aria-required={required}
          data-state={getState(checked)}
          data-disabled={disabled ? '' : undefined}
          disabled={disabled}
          value={value}
          {...switchProps}
          ref={composedRefs}
          onClick={composeEventHandlers(props.onClick, (event) => {
            setChecked((prevChecked) => !prevChecked);
            if (isFormControl) {
              hasConsumerStoppedPropagationRef.current = event.isPropagationStopped();
              // if switch is in a form, stop propagation from the button so that we only propagate
              // one click event (from the input). We propagate changes from an input so that native
              // form validation works and form events reflect switch updates.
              if (!hasConsumerStoppedPropagationRef.current) event.stopPropagation();
            }
          })}
        />
        {isFormControl && (
          <SwitchBubbleInput
            control={button}
            bubbles={!hasConsumerStoppedPropagationRef.current}
            name={name}
            value={value}
            checked={checked}
            required={required}
            disabled={disabled}
            form={form}
            // We transform because the input is absolutely positioned but we have
            // rendered it **after** the button. This pulls it back to sit on top
            // of the button.
            style={{ transform: 'translateX(-100%)' }}
          />
        )}
      </SwitchProvider>
    );
  }
);

Switch.displayName = SWITCH_NAME;

/* -------------------------------------------------------------------------------------------------
 * SwitchThumb
 * -----------------------------------------------------------------------------------------------*/

const THUMB_NAME = 'SwitchThumb';

type SwitchThumbElement = React.ElementRef<typeof Primitive.span>;
type PrimitiveSpanProps = React.ComponentPropsWithoutRef<typeof Primitive.span>;
interface SwitchThumbProps extends PrimitiveSpanProps {}

const SwitchThumb = React.forwardRef<SwitchThumbElement, SwitchThumbProps>(
  (props: ScopedProps<SwitchThumbProps>, forwardedRef) => {
    const { __scopeSwitch, ...thumbProps } = props;
    const context = useSwitchContext(THUMB_NAME, __scopeSwitch);
    return (
      <Primitive.span
        data-state={getState(context.checked)}
        data-disabled={context.disabled ? '' : undefined}
        {...thumbProps}
        ref={forwardedRef}
      />
    );
  }
);

SwitchThumb.displayName = THUMB_NAME;

/* -------------------------------------------------------------------------------------------------
 * SwitchBubbleInput
 * -----------------------------------------------------------------------------------------------*/

const BUBBLE_INPUT_NAME = 'SwitchBubbleInput';

type InputProps = React.ComponentPropsWithoutRef<typeof Primitive.input>;
interface SwitchBubbleInputProps extends Omit<InputProps, 'checked'> {
  checked: boolean;
  control: HTMLElement | null;
  bubbles: boolean;
}

const SwitchBubbleInput = React.forwardRef<HTMLInputElement, SwitchBubbleInputProps>(
  (
    {
      __scopeSwitch,
      control,
      checked,
      bubbles = true,
      ...props
    }: ScopedProps<SwitchBubbleInputProps>,
    forwardedRef
  ) => {
    const ref = React.useRef<HTMLInputElement>(null);
    const composedRefs = useComposedRefs(ref, forwardedRef);
    const prevChecked = usePrevious(checked);
    const controlSize = useSize(control);

    // Bubble checked change to parents (e.g form change event)
    React.useEffect(() => {
      const input = ref.current;
      if (!input) return;

      const inputProto = window.HTMLInputElement.prototype;
      const descriptor = Object.getOwnPropertyDescriptor(
        inputProto,
        'checked'
      ) as PropertyDescriptor;
      const setChecked = descriptor.set;
      if (prevChecked !== checked && setChecked) {
        const event = new Event('click', { bubbles });
        setChecked.call(input, checked);
        input.dispatchEvent(event);
      }
    }, [prevChecked, checked, bubbles]);

    return (
      <input
        type="checkbox"
        aria-hidden
        defaultChecked={checked}
        {...props}
        tabIndex={-1}
        ref={composedRefs}
        style={{
          ...props.style,
          ...controlSize,
          position: 'absolute',
          pointerEvents: 'none',
          opacity: 0,
          margin: 0,
        }}
      />
    );
  }
);

SwitchBubbleInput.displayName = BUBBLE_INPUT_NAME;

/* -----------------------------------------------------------------------------------------------*/

function getState(checked: boolean) {
  return checked ? 'checked' : 'unchecked';
}

const Root = Switch;
const Thumb = SwitchThumb;

export {
  createSwitchScope,
  //
  Switch,
  SwitchThumb,
  //
  Root,
  Thumb,
};
export type { SwitchProps, SwitchThumbProps };

```
