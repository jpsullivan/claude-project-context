/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/switch/README.md
```
# @radix-ng/primitives/switch

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/switch/index.ts
```typescript
import { NgModule } from '@angular/core';
import { RdxSwitchInputDirective } from './src/switch-input.directive';
import { RdxSwitchRootDirective } from './src/switch-root.directive';
import { RdxSwitchThumbDirective } from './src/switch-thumb.directive';

export * from './src/switch-input.directive';
export * from './src/switch-root.directive';
export * from './src/switch-thumb.directive';

export type { SwitchProps } from './src/switch-root.directive';

const switchImports = [
    RdxSwitchRootDirective,
    RdxSwitchInputDirective,
    RdxSwitchThumbDirective
];

@NgModule({
    imports: [...switchImports],
    exports: [...switchImports]
})
export class RdxSwitchModule {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/switch/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/switch/src/switch-input.directive.ts
```typescript
import { Directive } from '@angular/core';
import { injectSwitch } from './switch-root.directive';

/**
 * @group Components
 */
@Directive({
    selector: 'input[rdxSwitchInput]',
    exportAs: 'rdxSwitchInput',
    standalone: true,
    host: {
        type: 'checkbox',
        role: 'switch',
        tabindex: '-1',
        '[attr.id]': 'switchRoot.inputId()',
        '[attr.defaultChecked]': 'switchRoot.checkedState()',
        '[attr.aria-checked]': 'switchRoot.checkedState()',
        '[attr.aria-hidden]': 'true',
        '[attr.aria-label]': 'switchRoot.ariaLabel()',
        '[attr.aria-labelledby]': 'switchRoot.ariaLabelledBy()',
        '[attr.aria-required]': 'switchRoot.required()',
        '[attr.data-state]': 'switchRoot.checkedState() ? "checked" : "unchecked"',
        '[attr.data-disabled]': 'switchRoot.disabledState() ? "true" : null',
        '[attr.disabled]': 'switchRoot.disabledState() ? switchRoot.disabledState() : null',
        '[attr.value]': 'switchRoot.checkedState() ? "on" : "off"',
        style: 'transform: translateX(-100%); position: absolute; overflow: hidden; pointerEvents: none; opacity: 0; margin: 0;',

        '(blur)': 'onBlur()'
    }
})
export class RdxSwitchInputDirective {
    protected readonly switchRoot = injectSwitch();

    /** @ignore */
    protected onBlur() {
        this.switchRoot.onTouched?.();
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/switch/src/switch-root.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import {
    booleanAttribute,
    computed,
    Directive,
    effect,
    forwardRef,
    inject,
    InjectionToken,
    input,
    InputSignalWithTransform,
    model,
    ModelSignal,
    output,
    OutputEmitterRef,
    signal
} from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

export const RdxSwitchToken = new InjectionToken<RdxSwitchRootDirective>('RdxSwitchToken');

export function injectSwitch(): RdxSwitchRootDirective {
    return inject(RdxSwitchToken);
}

export const SWITCH_VALUE_ACCESSOR: any = {
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => RdxSwitchRootDirective),
    multi: true
};

export interface SwitchProps {
    checked?: ModelSignal<boolean>;
    defaultChecked?: InputSignalWithTransform<boolean, BooleanInput>;
    required?: InputSignalWithTransform<boolean, BooleanInput>;
    onCheckedChange?: OutputEmitterRef<boolean>;
}

let idIterator = 0;

/**
 * @group Components
 */
@Directive({
    selector: 'button[rdxSwitchRoot]',
    exportAs: 'rdxSwitchRoot',
    standalone: true,
    providers: [
        { provide: RdxSwitchToken, useExisting: RdxSwitchRootDirective },
        SWITCH_VALUE_ACCESSOR
    ],
    host: {
        type: 'button',
        '[id]': 'elementId()',
        '[attr.aria-checked]': 'checkedState()',
        '[attr.aria-required]': 'required()',
        '[attr.data-state]': 'checkedState() ? "checked" : "unchecked"',
        '[attr.data-disabled]': 'disabledState() ? "true" : null',
        '[attr.disabled]': 'disabledState() ? disabledState() : null',

        '(click)': 'toggle()'
    }
})
export class RdxSwitchRootDirective implements SwitchProps, ControlValueAccessor {
    readonly id = input<string | null>(`rdx-switch-${idIterator++}`);

    protected readonly elementId = computed(() => (this.id() ? this.id() : null));

    readonly inputId = input<string | null>(null);

    /**
     * When true, indicates that the user must check the switch before the owning form can be submitted.
     *
     * @default false
     * @group Props
     */
    readonly required = input<boolean, BooleanInput>(false, {
        transform: booleanAttribute
    });

    /**
     * Establishes relationships between the component and label(s) where its value should be one or more element IDs.
     * @default null
     * @group Props
     */
    readonly ariaLabelledBy = input<string | undefined>(undefined, {
        alias: 'aria-labelledby'
    });

    /**
     * Used to define a string that autocomplete attribute the current element.
     * @default null
     * @group Props
     */
    readonly ariaLabel = input<string | undefined>(undefined, {
        alias: 'aria-label'
    });

    /**
     * The controlled state of the switch. Must be used in conjunction with onCheckedChange.
     * @defaultValue false
     * @group Props
     */
    readonly checked = model<boolean>(false);

    /**
     * The state of the switch when it is initially rendered. Use when you do not need to control its state.
     * @default false
     * @group Props
     */
    readonly defaultChecked = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * The state of the switch.
     * If `defaultChecked` is provided, it takes precedence over the `checked` state.
     * @ignore
     */
    readonly checkedState = computed(() => this.checked());

    /**
     * When `true`, prevents the user from interacting with the switch.
     * @default false
     * @group Props
     */
    readonly disabled = input<boolean, BooleanInput>(false, {
        transform: booleanAttribute
    });

    /** @ignore */
    readonly disabledState = computed(() => this.disabled() || this.accessorDisabled());

    /**
     * Event handler called when the state of the switch changes.
     *
     * @param {boolean} value - Boolean value indicates that the option is changed.
     * @group Emits
     */
    readonly onCheckedChange = output<boolean>();

    private readonly defaultCheckedUsed = computed(() => this.defaultChecked());

    constructor() {
        effect(() => {
            if (this.defaultCheckedUsed()) {
                this.checked.set(this.defaultChecked());
            }
        });
    }

    /**
     * Toggles the checked state of the switch.
     * If the switch is disabled, the function returns early.
     * @ignore
     */
    toggle(): void {
        if (this.disabledState()) {
            return;
        }

        this.checked.set(!this.checked());

        this.onChange(this.checked());
        this.onCheckedChange.emit(this.checked());
    }

    private readonly accessorDisabled = signal(false);

    private onChange: (value: any) => void = () => {};
    /** @ignore */
    onTouched: (() => void) | undefined;

    /** @ignore */
    writeValue(value: any): void {
        this.checked.set(value);
    }

    /** @ignore */
    registerOnChange(fn: (value: any) => void): void {
        this.onChange = fn;
    }

    /** @ignore */
    registerOnTouched(fn: () => void): void {
        this.onTouched = fn;
    }

    /** @ignore */
    setDisabledState(isDisabled: boolean): void {
        this.accessorDisabled.set(isDisabled);
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/switch/src/switch-thumb.directive.ts
```typescript
import { Directive } from '@angular/core';
import { injectSwitch } from './switch-root.directive';

/**
 * @group Components
 */
@Directive({
    selector: 'span[rdxSwitchThumb]',
    exportAs: 'rdxSwitchThumb',
    standalone: true,
    host: {
        '[attr.data-disabled]': 'switchRoot.disabledState() ? "true" : null',
        '[attr.data-state]': 'switchRoot.checkedState() ? "checked" : "unchecked"'
    }
})
export class RdxSwitchThumbDirective {
    protected readonly switchRoot = injectSwitch();
}

```
