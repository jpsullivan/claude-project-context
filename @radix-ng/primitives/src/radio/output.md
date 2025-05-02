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
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/radio/stories/radio-group.component.ts
```typescript
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RdxLabelDirective } from '@radix-ng/primitives/label';
import { RdxRadioGroupDirective, RdxRadioIndicatorDirective, RdxRadioItemDirective } from '@radix-ng/primitives/radio';
import { RdxRadioItemInputDirective } from '../src/radio-item-input.directive';

@Component({
    selector: 'radio-groups-forms-example',
    template: `
        <div
            class="RadioGroupRoot"
            [(ngModel)]="hotelRoom"
            orientation="vertical"
            rdxRadioRoot
            aria-label="View density"
        >
            @for (room of rooms; track $index) {
                <div class="RadioGroup">
                    <button class="RadioGroupItem" [value]="room" [id]="room" rdxRadioItem>
                        <div class="RadioGroupIndicator" rdxRadioIndicator></div>
                        <input class="Input" rdxRadioItemInput feature="fully-hidden" />
                    </button>
                    <label class="Label" [htmlFor]="room" rdxLabel>
                        {{ room }}
                    </label>
                </div>
            }
        </div>
        <p>
            <span>Your room is: {{ hotelRoom }}</span>
        </p>
    `,
    styleUrl: 'radio-group.styles.scss',
    imports: [
        FormsModule,
        RdxLabelDirective,
        RdxRadioItemDirective,
        RdxRadioIndicatorDirective,
        RdxRadioGroupDirective,
        RdxRadioItemInputDirective
    ]
})
export class RadioGroupComponent {
    hotelRoom: string | undefined;
    rooms = ['Default', 'Comfortable'];
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/radio/stories/radio-group.styles.scss
```
/* reset */
button {
    all: unset;
}

.RadioGroup {
    display: flex;
    align-items: center;
}

.RadioGroupRoot {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.RadioGroupItem {
    background-color: white;
    width: 25px;
    height: 25px;
    border-radius: 100%;
    box-shadow: 0 2px 10px var(--black-a7);
}

.RadioGroupItem:hover {
    background-color: var(--violet-3);
}

.RadioGroupItem:focus {
    box-shadow: 0 0 0 2px black;
}

.RadioGroupIndicator {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    height: 100%;
    position: relative;
}

.RadioGroupIndicator::after {
    content: '';
    display: block;
    width: 11px;
    height: 11px;
    border-radius: 50%;
    background-color: var(--violet-11);
}

.RadioGroupIndicator[data-state='unchecked'] {
    display: none;
}

.Input {
    transform: translateX(-100%);
    position: absolute;
    pointer-events: none;
    opacity: 0;
    margin: 0;
    width: 25px;
    height: 25px;
}

.Label {
    color: white;
    font-size: 15px;
    line-height: 1;
    padding-left: 15px;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/radio/stories/radio.docs.mdx
````
import { ArgTypes, Canvas, Markdown, Meta } from '@storybook/blocks';
import * as RadioDirectiveStories from './radio.stories';
import { RdxRadioGroupDirective } from '../src/radio-root.directive';
import { RdxRadioItemDirective } from '../src/radio-item.directive';

<Meta title="Primitives/Radio Group" />

# Radio Group

#### A set of checkable buttons—known as radio buttons—where no more than one of the buttons can be checked at a time.

<Canvas sourceState="hidden" of={RadioDirectiveStories.Default} />

## Features

- ✅ Full keyboard navigation.
- ✅ Supports horizontal/vertical orientation.
- ✅ Can be controlled or uncontrolled.

## Import

Get started with importing the directives:

```typescript
import { RdxRadioIndicatorDirective, RadioItemDirective } from '@radix-ng/primitives/radio';
```

## Anatomy

```html
<div rdxRadioRoot>
  <button rdxRadioItem value="default">
    <div rdxRadioIndicator></div>
  </button>
</div>
```

## API Reference

### RadioGroup

`RdxRadioGroupDirective`

<ArgTypes of={RdxRadioGroupDirective} />

### RadioGroupItem

`RdxRadioGroupItemDirective`

<ArgTypes of={RdxRadioItemDirective} />

### RadioIndicator

`RdxRadioIndicatorDirective`

## Accessibility

Adheres to the [Radio Group WAI-ARIA design pattern](https://www.w3.org/WAI/ARIA/apg/patterns/radiobutton)
and uses [roving tabindex](https://www.w3.org/TR/wai-aria-practices-1.2/examples/radio/radio.html) to manage focus movement among radio items.

### Keyboard Interactions

<Markdown>
  {`
  | Key | Description |
  | ----------- | --------- |
  | Tab         | Moves focus to either the checked radio item or the first radio item in the group. |
  | Space       | When focus is on an unchecked radio item, checks it.        |
  | ArrowDown   | Moves focus and checks the next radio item in the group.    |
  | ArrowRight  |  Moves focus and checks the next radio item in the group.   |
  | ArrowUp     |  Moves focus to the previous radio item in the group.       |
  | ArrowLeft   |  Moves focus to the previous radio item in the group.       |
  `}
</Markdown>

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/radio/stories/radio.stories.ts
```typescript
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { RdxLabelDirective } from '../../label';
import { RdxRovingFocusGroupDirective, RdxRovingFocusItemDirective } from '../../roving-focus';
import { RdxRadioIndicatorDirective } from '../src/radio-indicator.directive';
import { RdxRadioItemInputDirective } from '../src/radio-item-input.directive';
import { RdxRadioItemDirective } from '../src/radio-item.directive';
import { RdxRadioGroupDirective } from '../src/radio-root.directive';
import { RadioGroupComponent } from './radio-group.component';

const html = String.raw;

export default {
    title: 'Primitives/Radio Group',
    decorators: [
        moduleMetadata({
            imports: [
                RdxLabelDirective,
                RdxRadioItemDirective,
                RdxRadioIndicatorDirective,
                RdxRadioItemInputDirective,
                RdxRadioGroupDirective,
                RdxRovingFocusGroupDirective,
                RdxRovingFocusItemDirective,
                RadioGroupComponent
            ]
        }),
        componentWrapperDecorator(
            (story) => html`
                <div class="radix-themes light light-theme" data-radius="medium" data-scaling="100%">${story}</div>

                <style>
                    /* reset */
                    button {
                        all: unset;
                    }

                    .RadioGroupRoot {
                        display: flex;
                        flex-direction: column;
                        gap: 10px;
                    }

                    .RadioGroupItem {
                        background-color: white;
                        width: 25px;
                        height: 25px;
                        border-radius: 100%;
                        box-shadow: 0 2px 10px var(--black-a7);
                    }
                    .RadioGroupItem:hover {
                        background-color: var(--violet-3);
                    }
                    .RadioGroupItem:focus {
                        box-shadow: 0 0 0 2px black;
                    }

                    .RadioGroupItem:disabled {
                        background-color: var(--gray-4);
                        box-shadow: none;
                        cursor: not-allowed;
                    }

                    .RadioGroupItem:disabled:hover {
                        background-color: var(--gray-4);
                    }

                    .RadioGroupIndicator {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        width: 100%;
                        height: 100%;
                        position: relative;
                    }
                    .RadioGroupIndicator::after {
                        content: '';
                        display: block;
                        width: 11px;
                        height: 11px;
                        border-radius: 50%;
                        background-color: var(--violet-11);
                    }

                    .RadioGroupIndicator[data-state='unchecked'] {
                        display: none;
                    }

                    .Input {
                        transform: translateX(-100%);
                        position: absolute;
                        pointer-events: none;
                        opacity: 0;
                        margin: 0;
                        width: 25px;
                        height: 25px;
                    }

                    .Label {
                        color: white;
                        font-size: 15px;
                        line-height: 1;
                        padding-left: 15px;
                    }
                </style>
            `
        )
    ]
} as Meta;

type Story = StoryObj;

export const Default: Story = {
    render: () => ({
        template: html`
            <form>
                <div class="RadioGroupRoot" rdxRadioRoot orientation="vertical" aria-label="View density">
                    <div style="display: flex; align-items: center;">
                        <button class="RadioGroupItem" id="r1" rdxRadioItem value="default">
                            <div class="RadioGroupIndicator" rdxRadioIndicator></div>
                            <input class="Input" rdxRadioItemInput feature="fully-hidden" />
                        </button>
                        <label class="Label" rdxLabel htmlFor="r1">Default</label>
                    </div>
                    <div style="display: flex; align-items: center;">
                        <button class="RadioGroupItem" id="r2" rdxRadioItem [required]="true" value="comfortable">
                            <div class="RadioGroupIndicator" rdxRadioIndicator></div>
                            <input class="Input" rdxRadioItemInput feature="fully-hidden" />
                        </button>
                        <label class="Label" rdxLabel htmlFor="r2">Comfortable</label>
                    </div>
                    <div style="display: flex; align-items: center;">
                        <button class="RadioGroupItem" id="r3" rdxRadioItem value="compact">
                            <div class="RadioGroupIndicator" rdxRadioIndicator></div>
                            <input class="Input" rdxRadioItemInput feature="fully-hidden" />
                        </button>
                        <label class="Label" rdxLabel htmlFor="r3">Compact</label>
                    </div>
                </div>
            </form>
        `
    })
};

export const RadioGroup: Story = {
    render: () => ({
        template: `<radio-groups-forms-example></radio-groups-forms-example>`
    })
};

export const DisabledGroup: Story = {
    render: () => ({
        template: html`
            <div
                class="RadioGroupRoot"
                rdxRadioRoot
                [value]="'comfortable'"
                disabled
                orientation="vertical"
                aria-label="View density"
            >
                <div style="display: flex; align-items: center;">
                    <button class="RadioGroupItem" id="r1" rdxRadioItem value="default">
                        <div class="RadioGroupIndicator" rdxRadioIndicator></div>
                        <input class="Input" rdxRadioItemInput feature="fully-hidden" />
                    </button>
                    <label class="Label" rdxLabel htmlFor="r1">Default</label>
                </div>
                <div style="display: flex; align-items: center;">
                    <button class="RadioGroupItem" id="r2" rdxRadioItem [required]="true" value="comfortable">
                        <div class="RadioGroupIndicator" rdxRadioIndicator></div>
                        <input class="Input" rdxRadioItemInput feature="fully-hidden" />
                    </button>
                    <label class="Label" rdxLabel htmlFor="r2">Comfortable</label>
                </div>
                <div style="display: flex; align-items: center;">
                    <button class="RadioGroupItem" id="r3" rdxRadioItem value="compact">
                        <div class="RadioGroupIndicator" rdxRadioIndicator></div>
                        <input class="Input" rdxRadioItemInput feature="fully-hidden" />
                    </button>
                    <label class="Label" rdxLabel htmlFor="r3">Compact</label>
                </div>
            </div>
        `
    })
};

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
import { provideToken } from '@radix-ng/primitives/core';
import { RdxRovingFocusItemDirective } from '@radix-ng/primitives/roving-focus';
import { RDX_RADIO_GROUP } from './radio-tokens';

export const RdxRadioItemToken = new InjectionToken<RdxRadioItemDirective>('RadioItemToken');

export function injectRadioItem(): RdxRadioItemDirective {
    return inject(RdxRadioItemToken);
}

@Directive({
    selector: '[rdxRadioItem]',
    exportAs: 'rdxRadioItem',
    providers: [provideToken(RdxRadioItemToken, RdxRadioItemDirective)],
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
import { ControlValueAccessor } from '@angular/forms';
import { provideValueAccessor } from '@radix-ng/primitives/core';
import { Orientation, RdxRovingFocusGroupDirective } from '@radix-ng/primitives/roving-focus';
import { RadioGroupDirective, RadioGroupProps, RDX_RADIO_GROUP } from './radio-tokens';

@Directive({
    selector: '[rdxRadioRoot]',
    exportAs: 'rdxRadioRoot',
    providers: [
        provideValueAccessor(RdxRadioGroupDirective),
        { provide: RDX_RADIO_GROUP, useExisting: RdxRadioGroupDirective }],
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
