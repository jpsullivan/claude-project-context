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
