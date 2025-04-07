/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/radio/README.md
```
# @radix-ng/primitives/radio

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/radio/index.ts
```typescript
export * from './src/radio-root.directive';

export * from './src/radio-indicator.directive';
export * from './src/radio-item-input.directive';
export * from './src/radio-item.directive';

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/radio/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/radio/src/radio-indicator.directive.ts
```typescript
import { Directive, inject } from '@angular/core';
import { RdxRadioItemDirective } from './radio-item.directive';
import { RDX_RADIO_GROUP, RadioGroupDirective } from './radio-tokens';

@Directive({
    selector: '[rdxRadioIndicator]',
    exportAs: 'rdxRadioIndicator',
    host: {
        '[attr.data-state]': 'radioItem.checkedState() ? "checked" : "unchecked"',
        '[attr.data-disabled]': 'radioItem.disabled() ? "" : undefined'
    }
})
export class RdxRadioIndicatorDirective {
    protected readonly radioGroup: RadioGroupDirective = inject(RDX_RADIO_GROUP);
    protected readonly radioItem: RdxRadioItemDirective = inject(RdxRadioItemDirective);
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/radio/src/radio-item-input.directive.ts
```typescript
import { computed, Directive, input } from '@angular/core';
import { RdxVisuallyHiddenDirective } from '@radix-ng/primitives/visually-hidden';
import { injectRadioItem } from './radio-item.directive';

@Directive({
    selector: '[rdxRadioItemInput]',
    exportAs: 'rdxRadioItemInput',
    hostDirectives: [
        { directive: RdxVisuallyHiddenDirective, inputs: ['feature'] }],
    host: {
        type: 'radio',
        '[attr.name]': 'name()',
        '[attr.required]': 'required()',
        '[attr.disabled]': 'disabled() ? disabled() : undefined',
        '[attr.checked]': 'checked()',
        '[value]': 'value()'
    }
})
export class RdxRadioItemInputDirective {
    private readonly radioItem = injectRadioItem();

    readonly name = input<string>();
    readonly value = computed(() => this.radioItem.value() || undefined);
    readonly checked = computed(() => this.radioItem.checkedState() || undefined);
    readonly required = input<boolean | undefined>(this.radioItem.required());
    readonly disabled = input<boolean | undefined>(this.radioItem.disabled());
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/radio/src/radio-item.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import {
    booleanAttribute,
    computed,
    Directive,
    ElementRef,
    inject,
    InjectionToken,
    input,
    OnInit,
    signal
} from '@angular/core';
import { RdxRovingFocusItemDirective } from '@radix-ng/primitives/roving-focus';
import { RDX_RADIO_GROUP } from './radio-tokens';

export const RdxRadioItemToken = new InjectionToken<RdxRadioItemDirective>('RadioItemToken');

export function injectRadioItem(): RdxRadioItemDirective {
    return inject(RdxRadioItemToken);
}

@Directive({
    selector: '[rdxRadioItem]',
    exportAs: 'rdxRadioItem',
    providers: [{ provide: RdxRadioItemToken, useExisting: RdxRadioItemDirective }],
    hostDirectives: [
        { directive: RdxRovingFocusItemDirective, inputs: ['tabStopId: id', 'focusable', 'active', 'allowShiftKey'] }],

    host: {
        type: 'button',
        role: 'radio',
        '[attr.aria-checked]': 'checkedState()',
        '[attr.data-disabled]': 'disabledState() ? "" : null',
        '[attr.data-state]': 'checkedState() ? "checked" : "unchecked"',
        '[disabled]': 'disabledState()',
        '(click)': 'onClick()',
        '(keydown)': 'onKeyDown($event)',
        '(keyup)': 'onKeyUp()',
        '(focus)': 'onFocus()'
    }
})
export class RdxRadioItemDirective implements OnInit {
    private readonly radioGroup = inject(RDX_RADIO_GROUP);
    private readonly elementRef = inject(ElementRef);

    readonly value = input.required<string>();

    readonly id = input<string>();

    readonly required = input<boolean>();

    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    protected readonly disabledState = computed(() => this.radioGroup.disableState() || this.disabled());

    readonly checkedState = computed(() => this.radioGroup.value() === this.value());

    private readonly ARROW_KEYS = ['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'];
    private readonly isArrowKeyPressedSignal = signal(false);

    /** @ignore */
    ngOnInit() {
        if (this.radioGroup.defaultValue === this.value()) {
            this.radioGroup.select(this.value());
        }
    }

    /** @ignore */
    onClick() {
        if (!this.disabledState()) {
            this.radioGroup.select(this.value());
            this.isArrowKeyPressedSignal.set(true);
        }
    }

    /** @ignore */
    onKeyDown(event: KeyboardEvent): void {
        if (this.ARROW_KEYS.includes(event.key)) {
            this.isArrowKeyPressedSignal.set(true);
        }
    }

    /** @ignore */
    onKeyUp() {
        this.isArrowKeyPressedSignal.set(false);
    }

    /** @ignore */
    onFocus() {
        this.radioGroup.select(this.value());
        setTimeout(() => {
            /**
             * When navigating with arrow keys, focus triggers on the radio item.
             * To "check" the radio, we programmatically trigger a click event.
             */
            if (this.isArrowKeyPressedSignal()) {
                this.elementRef.nativeElement.click();
            }
        }, 0);
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/radio/src/radio-root.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, computed, Directive, input, Input, model, output, signal } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { Orientation, RdxRovingFocusGroupDirective } from '@radix-ng/primitives/roving-focus';
import { RadioGroupDirective, RadioGroupProps, RDX_RADIO_GROUP } from './radio-tokens';

@Directive({
    selector: '[rdxRadioRoot]',
    exportAs: 'rdxRadioRoot',
    providers: [
        { provide: RDX_RADIO_GROUP, useExisting: RdxRadioGroupDirective },
        { provide: NG_VALUE_ACCESSOR, useExisting: RdxRadioGroupDirective, multi: true }
    ],
    hostDirectives: [{ directive: RdxRovingFocusGroupDirective, inputs: ['dir', 'orientation', 'loop'] }],
    host: {
        role: 'radiogroup',
        '[attr.aria-orientation]': 'orientation()',
        '[attr.aria-required]': 'required()',
        '[attr.data-disabled]': 'disableState() ? "" : null',
        '(keydown)': 'onKeydown()'
    }
})
export class RdxRadioGroupDirective implements RadioGroupProps, RadioGroupDirective, ControlValueAccessor {
    readonly value = model<string | null>(null);

    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    @Input() defaultValue?: string;

    readonly required = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    readonly orientation = input<Orientation>();

    /**
     * Event handler called when the value changes.
     */
    readonly onValueChange = output<string>();

    private readonly disable = signal<boolean>(this.disabled());
    readonly disableState = computed(() => this.disable() || this.disabled());

    /**
     * The callback function to call when the value of the radio group changes.
     */
    private onChange: (value: string) => void = () => {
        /* Empty */
    };

    /**
     * The callback function to call when the radio group is touched.
     * @ignore
     */
    onTouched: () => void = () => {
        /* Empty */
    };

    /**
     * Select a radio item.
     * @param value The value of the radio item to select.
     * @ignore
     */
    select(value: string): void {
        this.value.set(value);
        this.onValueChange.emit(value);
        this.onChange?.(value);
        this.onTouched();
    }

    /**
     * Update the value of the radio group.
     * @param value The new value of the radio group.
     * @ignore
     */
    writeValue(value: string): void {
        this.value.set(value);
    }

    /**
     * Register a callback function to call when the value of the radio group changes.
     * @param fn The callback function to call when the value of the radio group changes.
     * @ignore
     */
    registerOnChange(fn: (value: string) => void): void {
        this.onChange = fn;
    }

    /** @ignore */
    registerOnTouched(fn: () => void): void {
        this.onTouched = fn;
    }

    /**
     * Set the disabled state of the radio group.
     * @param isDisabled Whether the radio group is disabled.
     * @ignore
     */
    setDisabledState(isDisabled: boolean): void {
        this.disable.set(isDisabled);
    }

    protected onKeydown(): void {
        if (this.disableState()) return;
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/radio/src/radio-tokens.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { InjectionToken, InputSignalWithTransform, ModelSignal, Signal } from '@angular/core';

export interface RadioGroupProps {
    name?: string;
    disabled?: InputSignalWithTransform<boolean, BooleanInput>;
    defaultValue?: string;
    value: ModelSignal<string | null>;
    disableState: Signal<boolean>;
}

export interface RadioGroupDirective extends RadioGroupProps {
    select(value: string | null): void;

    onTouched(): void;
}

export const RDX_RADIO_GROUP = new InjectionToken<RadioGroupDirective>('RdxRadioGroup');

```
