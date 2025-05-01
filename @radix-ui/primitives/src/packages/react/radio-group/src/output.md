/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/radio-group/src/index.ts
```typescript
'use client';
export {
  createRadioGroupScope,
  //
  RadioGroup,
  RadioGroupItem,
  RadioGroupIndicator,
  //
  Root,
  Item,
  Indicator,
} from './radio-group';
export type { RadioGroupProps, RadioGroupItemProps, RadioGroupIndicatorProps } from './radio-group';

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/radio-group/src/radio-group.tsx
```
import * as React from 'react';
import { composeEventHandlers } from '@radix-ui/primitive';
import { useComposedRefs } from '@radix-ui/react-compose-refs';
import { createContextScope } from '@radix-ui/react-context';
import { Primitive } from '@radix-ui/react-primitive';
import * as RovingFocusGroup from '@radix-ui/react-roving-focus';
import { createRovingFocusGroupScope } from '@radix-ui/react-roving-focus';
import { useControllableState } from '@radix-ui/react-use-controllable-state';
import { useDirection } from '@radix-ui/react-direction';
import { Radio, RadioIndicator, createRadioScope } from './radio';

import type { Scope } from '@radix-ui/react-context';

const ARROW_KEYS = ['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'];

/* -------------------------------------------------------------------------------------------------
 * RadioGroup
 * -----------------------------------------------------------------------------------------------*/
const RADIO_GROUP_NAME = 'RadioGroup';

type ScopedProps<P> = P & { __scopeRadioGroup?: Scope };
const [createRadioGroupContext, createRadioGroupScope] = createContextScope(RADIO_GROUP_NAME, [
  createRovingFocusGroupScope,
  createRadioScope,
]);
const useRovingFocusGroupScope = createRovingFocusGroupScope();
const useRadioScope = createRadioScope();

type RadioGroupContextValue = {
  name?: string;
  required: boolean;
  disabled: boolean;
  value: string;
  onValueChange(value: string): void;
};

const [RadioGroupProvider, useRadioGroupContext] =
  createRadioGroupContext<RadioGroupContextValue>(RADIO_GROUP_NAME);

type RadioGroupElement = React.ElementRef<typeof Primitive.div>;
type RovingFocusGroupProps = React.ComponentPropsWithoutRef<typeof RovingFocusGroup.Root>;
type PrimitiveDivProps = React.ComponentPropsWithoutRef<typeof Primitive.div>;
interface RadioGroupProps extends PrimitiveDivProps {
  name?: RadioGroupContextValue['name'];
  required?: React.ComponentPropsWithoutRef<typeof Radio>['required'];
  disabled?: React.ComponentPropsWithoutRef<typeof Radio>['disabled'];
  dir?: RovingFocusGroupProps['dir'];
  orientation?: RovingFocusGroupProps['orientation'];
  loop?: RovingFocusGroupProps['loop'];
  defaultValue?: string;
  value?: RadioGroupContextValue['value'];
  onValueChange?: RadioGroupContextValue['onValueChange'];
}

const RadioGroup = React.forwardRef<RadioGroupElement, RadioGroupProps>(
  (props: ScopedProps<RadioGroupProps>, forwardedRef) => {
    const {
      __scopeRadioGroup,
      name,
      defaultValue,
      value: valueProp,
      required = false,
      disabled = false,
      orientation,
      dir,
      loop = true,
      onValueChange,
      ...groupProps
    } = props;
    const rovingFocusGroupScope = useRovingFocusGroupScope(__scopeRadioGroup);
    const direction = useDirection(dir);
    const [value, setValue] = useControllableState({
      prop: valueProp,
      defaultProp: defaultValue ?? '',
      onChange: onValueChange,
      caller: RADIO_GROUP_NAME,
    });

    return (
      <RadioGroupProvider
        scope={__scopeRadioGroup}
        name={name}
        required={required}
        disabled={disabled}
        value={value}
        onValueChange={setValue}
      >
        <RovingFocusGroup.Root
          asChild
          {...rovingFocusGroupScope}
          orientation={orientation}
          dir={direction}
          loop={loop}
        >
          <Primitive.div
            role="radiogroup"
            aria-required={required}
            aria-orientation={orientation}
            data-disabled={disabled ? '' : undefined}
            dir={direction}
            {...groupProps}
            ref={forwardedRef}
          />
        </RovingFocusGroup.Root>
      </RadioGroupProvider>
    );
  }
);

RadioGroup.displayName = RADIO_GROUP_NAME;

/* -------------------------------------------------------------------------------------------------
 * RadioGroupItem
 * -----------------------------------------------------------------------------------------------*/

const ITEM_NAME = 'RadioGroupItem';

type RadioGroupItemElement = React.ElementRef<typeof Radio>;
type RadioProps = React.ComponentPropsWithoutRef<typeof Radio>;
interface RadioGroupItemProps extends Omit<RadioProps, 'onCheck' | 'name'> {
  value: string;
}

const RadioGroupItem = React.forwardRef<RadioGroupItemElement, RadioGroupItemProps>(
  (props: ScopedProps<RadioGroupItemProps>, forwardedRef) => {
    const { __scopeRadioGroup, disabled, ...itemProps } = props;
    const context = useRadioGroupContext(ITEM_NAME, __scopeRadioGroup);
    const isDisabled = context.disabled || disabled;
    const rovingFocusGroupScope = useRovingFocusGroupScope(__scopeRadioGroup);
    const radioScope = useRadioScope(__scopeRadioGroup);
    const ref = React.useRef<React.ElementRef<typeof Radio>>(null);
    const composedRefs = useComposedRefs(forwardedRef, ref);
    const checked = context.value === itemProps.value;
    const isArrowKeyPressedRef = React.useRef(false);

    React.useEffect(() => {
      const handleKeyDown = (event: KeyboardEvent) => {
        if (ARROW_KEYS.includes(event.key)) {
          isArrowKeyPressedRef.current = true;
        }
      };
      const handleKeyUp = () => (isArrowKeyPressedRef.current = false);
      document.addEventListener('keydown', handleKeyDown);
      document.addEventListener('keyup', handleKeyUp);
      return () => {
        document.removeEventListener('keydown', handleKeyDown);
        document.removeEventListener('keyup', handleKeyUp);
      };
    }, []);

    return (
      <RovingFocusGroup.Item
        asChild
        {...rovingFocusGroupScope}
        focusable={!isDisabled}
        active={checked}
      >
        <Radio
          disabled={isDisabled}
          required={context.required}
          checked={checked}
          {...radioScope}
          {...itemProps}
          name={context.name}
          ref={composedRefs}
          onCheck={() => context.onValueChange(itemProps.value)}
          onKeyDown={composeEventHandlers((event) => {
            // According to WAI ARIA, radio groups don't activate items on enter keypress
            if (event.key === 'Enter') event.preventDefault();
          })}
          onFocus={composeEventHandlers(itemProps.onFocus, () => {
            /**
             * Our `RovingFocusGroup` will focus the radio when navigating with arrow keys
             * and we need to "check" it in that case. We click it to "check" it (instead
             * of updating `context.value`) so that the radio change event fires.
             */
            if (isArrowKeyPressedRef.current) ref.current?.click();
          })}
        />
      </RovingFocusGroup.Item>
    );
  }
);

RadioGroupItem.displayName = ITEM_NAME;

/* -------------------------------------------------------------------------------------------------
 * RadioGroupIndicator
 * -----------------------------------------------------------------------------------------------*/

const INDICATOR_NAME = 'RadioGroupIndicator';

type RadioGroupIndicatorElement = React.ElementRef<typeof RadioIndicator>;
type RadioIndicatorProps = React.ComponentPropsWithoutRef<typeof RadioIndicator>;
interface RadioGroupIndicatorProps extends RadioIndicatorProps {}

const RadioGroupIndicator = React.forwardRef<RadioGroupIndicatorElement, RadioGroupIndicatorProps>(
  (props: ScopedProps<RadioGroupIndicatorProps>, forwardedRef) => {
    const { __scopeRadioGroup, ...indicatorProps } = props;
    const radioScope = useRadioScope(__scopeRadioGroup);
    return <RadioIndicator {...radioScope} {...indicatorProps} ref={forwardedRef} />;
  }
);

RadioGroupIndicator.displayName = INDICATOR_NAME;

/* ---------------------------------------------------------------------------------------------- */

const Root = RadioGroup;
const Item = RadioGroupItem;
const Indicator = RadioGroupIndicator;

export {
  createRadioGroupScope,
  //
  RadioGroup,
  RadioGroupItem,
  RadioGroupIndicator,
  //
  Root,
  Item,
  Indicator,
};
export type { RadioGroupProps, RadioGroupItemProps, RadioGroupIndicatorProps };

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/radio-group/src/radio.tsx
```
import * as React from 'react';
import { composeEventHandlers } from '@radix-ui/primitive';
import { useComposedRefs } from '@radix-ui/react-compose-refs';
import { createContextScope } from '@radix-ui/react-context';
import { useSize } from '@radix-ui/react-use-size';
import { usePrevious } from '@radix-ui/react-use-previous';
import { Presence } from '@radix-ui/react-presence';
import { Primitive } from '@radix-ui/react-primitive';

import type { Scope } from '@radix-ui/react-context';

/* -------------------------------------------------------------------------------------------------
 * Radio
 * -----------------------------------------------------------------------------------------------*/

const RADIO_NAME = 'Radio';

type ScopedProps<P> = P & { __scopeRadio?: Scope };
const [createRadioContext, createRadioScope] = createContextScope(RADIO_NAME);

type RadioContextValue = { checked: boolean; disabled?: boolean };
const [RadioProvider, useRadioContext] = createRadioContext<RadioContextValue>(RADIO_NAME);

type RadioElement = React.ElementRef<typeof Primitive.button>;
type PrimitiveButtonProps = React.ComponentPropsWithoutRef<typeof Primitive.button>;
interface RadioProps extends PrimitiveButtonProps {
  checked?: boolean;
  required?: boolean;
  onCheck?(): void;
}

const Radio = React.forwardRef<RadioElement, RadioProps>(
  (props: ScopedProps<RadioProps>, forwardedRef) => {
    const {
      __scopeRadio,
      name,
      checked = false,
      required,
      disabled,
      value = 'on',
      onCheck,
      form,
      ...radioProps
    } = props;
    const [button, setButton] = React.useState<HTMLButtonElement | null>(null);
    const composedRefs = useComposedRefs(forwardedRef, (node) => setButton(node));
    const hasConsumerStoppedPropagationRef = React.useRef(false);
    // We set this to true by default so that events bubble to forms without JS (SSR)
    const isFormControl = button ? form || !!button.closest('form') : true;

    return (
      <RadioProvider scope={__scopeRadio} checked={checked} disabled={disabled}>
        <Primitive.button
          type="button"
          role="radio"
          aria-checked={checked}
          data-state={getState(checked)}
          data-disabled={disabled ? '' : undefined}
          disabled={disabled}
          value={value}
          {...radioProps}
          ref={composedRefs}
          onClick={composeEventHandlers(props.onClick, (event) => {
            // radios cannot be unchecked so we only communicate a checked state
            if (!checked) onCheck?.();
            if (isFormControl) {
              hasConsumerStoppedPropagationRef.current = event.isPropagationStopped();
              // if radio is in a form, stop propagation from the button so that we only propagate
              // one click event (from the input). We propagate changes from an input so that native
              // form validation works and form events reflect radio updates.
              if (!hasConsumerStoppedPropagationRef.current) event.stopPropagation();
            }
          })}
        />
        {isFormControl && (
          <RadioBubbleInput
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
      </RadioProvider>
    );
  }
);

Radio.displayName = RADIO_NAME;

/* -------------------------------------------------------------------------------------------------
 * RadioIndicator
 * -----------------------------------------------------------------------------------------------*/

const INDICATOR_NAME = 'RadioIndicator';

type RadioIndicatorElement = React.ElementRef<typeof Primitive.span>;
type PrimitiveSpanProps = React.ComponentPropsWithoutRef<typeof Primitive.span>;
export interface RadioIndicatorProps extends PrimitiveSpanProps {
  /**
   * Used to force mounting when more control is needed. Useful when
   * controlling animation with React animation libraries.
   */
  forceMount?: true;
}

const RadioIndicator = React.forwardRef<RadioIndicatorElement, RadioIndicatorProps>(
  (props: ScopedProps<RadioIndicatorProps>, forwardedRef) => {
    const { __scopeRadio, forceMount, ...indicatorProps } = props;
    const context = useRadioContext(INDICATOR_NAME, __scopeRadio);
    return (
      <Presence present={forceMount || context.checked}>
        <Primitive.span
          data-state={getState(context.checked)}
          data-disabled={context.disabled ? '' : undefined}
          {...indicatorProps}
          ref={forwardedRef}
        />
      </Presence>
    );
  }
);

RadioIndicator.displayName = INDICATOR_NAME;

/* -------------------------------------------------------------------------------------------------
 * RadioBubbleInput
 * -----------------------------------------------------------------------------------------------*/

const BUBBLE_INPUT_NAME = 'RadioBubbleInput';

type InputProps = React.ComponentPropsWithoutRef<typeof Primitive.input>;
interface RadioBubbleInputProps extends Omit<InputProps, 'checked'> {
  checked: boolean;
  control: HTMLElement | null;
  bubbles: boolean;
}

const RadioBubbleInput = React.forwardRef<HTMLInputElement, RadioBubbleInputProps>(
  (
    {
      __scopeRadio,
      control,
      checked,
      bubbles = true,
      ...props
    }: ScopedProps<RadioBubbleInputProps>,
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
      <Primitive.input
        type="radio"
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

RadioBubbleInput.displayName = BUBBLE_INPUT_NAME;

/* ---------------------------------------------------------------------------------------------- */

function getState(checked: boolean) {
  return checked ? 'checked' : 'unchecked';
}

export {
  createRadioScope,
  //
  Radio,
  RadioIndicator,
};
export type { RadioProps };

```
