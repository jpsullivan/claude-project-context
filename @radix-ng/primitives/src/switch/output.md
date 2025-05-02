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
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/switch/stories/switch-forms.component.ts
```typescript
import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup, ReactiveFormsModule } from '@angular/forms';
import { RdxLabelDirective } from '@radix-ng/primitives/label';
import { RdxSwitchInputDirective } from '../src/switch-input.directive';
import { RdxSwitchRootDirective } from '../src/switch-root.directive';
import { RdxSwitchThumbDirective } from '../src/switch-thumb.directive';

@Component({
    selector: 'switch-reactive-forms',
    imports: [
        ReactiveFormsModule,
        RdxLabelDirective,
        RdxSwitchRootDirective,
        RdxSwitchInputDirective,
        RdxSwitchThumbDirective
    ],
    styleUrl: './switch.styles.css',
    template: `
        <form [formGroup]="formGroup" (ngSubmit)="onSubmit()">
            <label class="Label" rdxLabel htmlFor="airplane-mode-form">
                Airplane mode
                <button class="SwitchRoot" id="airplane-mode-form" formControlName="policy" rdxSwitchRoot>
                    <input rdxSwitchInput />
                    <span class="SwitchThumb" rdxSwitchThumb></span>
                </button>
            </label>
            <button class="Button violet" style="margin-top: 8px;" type="submit">Submit</button>
        </form>
        <p>
            <button class="Button violet" (click)="setValue()">Set preset value</button>
        </p>
    `
})
export class SwitchReactiveForms implements OnInit {
    formGroup!: FormGroup;

    ngOnInit() {
        this.formGroup = new FormGroup({
            policy: new FormControl<boolean>(true)
        });
    }

    onSubmit(): void {
        console.log(this.formGroup.value);
    }

    setValue() {
        this.formGroup.setValue({ policy: false });
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/switch/stories/switch.docs.mdx
````
import { ArgTypes, Canvas, Markdown, Meta } from '@storybook/blocks';
import { switchExclude } from '../../../../apps/storybook-radix/docs/utils/storybook';
import { RdxSwitchRootDirective } from '../src/switch-root.directive';
import * as SwitchDirectiveStories from './switch.stories';

<Meta title="Primitives/Switch" />

# Switch

#### A control that allows the user to toggle between checked and not checked.

<Canvas sourceState="hidden" of={SwitchDirectiveStories.Default} />

## Features

- ✅ Full keyboard navigation.
- ✅ Can be controlled or uncontrolled.

## Import

Get started with importing the directives:

```typescript
import { RdxSwitchRootDirective, RdxSwitchThumbDirective, RdxSwitchInputDirective } from '@radix-ng/primitives/switch';
```

## Examples

```html
<label rdxLabel htmlFor="airplane-mode">Airplane mode</label>
<button id="airplane-mode" rdxSwitchRoot [(checked)]="checked">
  <span rdxSwitchThumb></span>
</button>
```

```html
<label rdxLabel htmlFor="airplane-mode">Airplane mode</label>
<button id="airplane-mode" rdxSwitchRoot [(checked)]="checked">
  <input rdxSwitchInput />
  <span rdxSwitchThumb></span>
</button>
```

## API Reference

### Root

`RdxSwitchRootDirective`
<ArgTypes exclude={switchExclude} of={RdxSwitchRootDirective} />

<Markdown>
  {`
  | Data Attribute     | Value |
  | ------------------ | -------------------------- |
  | [data-state]       | "checked" or "unchecked"   |
  | [data-disabled]    | Present when disabled      |
  `}
</Markdown>

### Thumb

`RdxThumbDirective`
<Markdown>
  {`
  | Data Attribute     | Value |
  | ------------------ | -------------------------- |
  | [data-state]       | "checked" or "unchecked"   |
  | [data-disabled]    | Present when disabled      |
  `}
</Markdown>

## Accessibility

Adheres to the [`switch` role requirements](https://www.w3.org/WAI/ARIA/apg/patterns/switch).

### Keyboard Interactions

<Markdown>
  {`
  | Key | Description |
  | ----------- | --------- |
  | Space       | Toggles the component's state.        |
  | Enter       | Toggles the component's state.    |
  `}
</Markdown>

### Screen Reader

Switch component uses a hidden native checkbox element with `switch` role internally that is only visible to screen readers.
Value to describe the component can either be provided via `label` tag using `ariaLabelledBy`, `ariaLabel` props.

```html
<label for="switch1">Remember Me</label>
<button rdxSwitchRoot id="switch1" ></button>

<span id="switch2">Remember Me</span>
<button rdxSwitchRoot ariaLabelledBy="switch2"></button>

<button rdxSwitchRoot ariaLabel="Remember Me"></button>
```


## Examples

### Reactive Forms

Switch can also be used with reactive forms. In this case, the `formControlName` property is used to bind the component to a form control.

<Canvas sourceState="hidden" of={SwitchDirectiveStories.ReactiveForm} />

### Disabled

When `disabled` is present, the element cannot be edited and focused.

<Canvas sourceState="hidden" of={SwitchDirectiveStories.Disabled} />

### Preselection

Enabling `checked` property displays the component as active initially.

<Canvas sourceState="hidden" of={SwitchDirectiveStories.Preselection} />

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/switch/stories/switch.stories.ts
```typescript
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { RdxLabelDirective } from '../../label';
import { RdxSwitchInputDirective } from '../src/switch-input.directive';
import { RdxSwitchRootDirective } from '../src/switch-root.directive';
import { RdxSwitchThumbDirective } from '../src/switch-thumb.directive';
import { SwitchReactiveForms } from './switch-forms.component';

const html = String.raw;

export default {
    title: 'Primitives/Switch',
    decorators: [
        moduleMetadata({
            imports: [
                RdxLabelDirective,
                RdxSwitchRootDirective,
                RdxSwitchInputDirective,
                RdxSwitchThumbDirective,
                SwitchReactiveForms
            ]
        }),
        componentWrapperDecorator(
            (story) => html`
                <div class="radix-themes light light-theme" data-radius="medium" data-scaling="100%">
                    ${story}

                    <style>
                        button {
                            all: unset;
                        }

                        .SwitchRoot {
                            width: 42px;
                            height: 25px;
                            background-color: var(--black-a9);
                            border-radius: 9999px;
                            margin-left: 15px;
                            position: relative;
                            box-shadow: 0 2px 10px var(--black-a7);
                            -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
                        }
                        .SwitchRoot:focus {
                            box-shadow: 0 0 0 2px black;
                        }
                        .SwitchRoot[data-state='checked'] {
                            background-color: black;
                        }
                        .SwitchRoot[data-disabled='true'] {
                            background-color: var(--black-a6);
                            cursor: not-allowed;
                            box-shadow: none;
                        }

                        .SwitchThumb {
                            display: block;
                            width: 21px;
                            height: 21px;
                            background-color: white;
                            border-radius: 9999px;
                            box-shadow: 0 2px 2px var(--black-a7);
                            transition: transform 100ms;
                            transform: translateX(2px);
                            will-change: transform;
                        }
                        .SwitchThumb[data-state='checked'] {
                            transform: translateX(19px);
                        }

                        .Label {
                            color: white;
                            font-size: 15px;
                            line-height: 1;
                            display: flex;
                            align-items: center;
                        }
                    </style>
                </div>
            `
        )
    ]
} as Meta;

type Story = StoryObj;

export const Default: Story = {
    render: () => ({
        template: html`
            <label class="Label" rdxLabel htmlFor="airplane-mode">
                Airplane mode
                <button class="SwitchRoot" id="airplane-mode" rdxSwitchRoot defaultChecked>
                    <span class="SwitchThumb" rdxSwitchThumb></span>
                </button>
            </label>
        `
    })
};

export const Preselection: Story = {
    argTypes: {
        checked: {
            control: {
                type: 'boolean'
            }
        }
    },
    args: {
        checked: true
    },
    render: (args) => ({
        props: {
            config: args
        },
        template: html`
            <label class="Label" rdxLabel htmlFor="airplane-mode-model">
                Airplane mode
                <button class="SwitchRoot" id="airplane-mode-model" rdxSwitchRoot [checked]="config.checked">
                    <input rdxSwitchInput />
                    <span class="SwitchThumb" rdxSwitchThumb></span>
                </button>
            </label>
        `
    })
};

export const Disabled: Story = {
    name: 'Disabled',
    render: () => ({
        template: html`
            <label class="Label" rdxLabel htmlFor="airplane-mode-disabled">
                Airplane mode
                <button class="SwitchRoot" id="airplane-mode-disabled" rdxSwitchRoot disabled>
                    <input rdxSwitchInput />
                    <span class="SwitchThumb" rdxSwitchThumb></span>
                </button>
            </label>
        `
    })
};

export const ReactiveForm: Story = {
    render: () => ({
        template: html`
            <switch-reactive-forms />
        `
    })
};

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/switch/stories/switch.styles.css
```css
button {
    all: unset;
}

.SwitchRoot {
    width: 42px;
    height: 25px;
    background-color: var(--black-a9);
    border-radius: 9999px;
    margin-left: 15px;
    position: relative;
    box-shadow: 0 2px 10px var(--black-a7);
    -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
}

.SwitchRoot:focus {
    box-shadow: 0 0 0 2px black;
}

.SwitchRoot[data-state='checked'] {
    background-color: black;
}

.SwitchRoot[data-disabled='true'] {
    background-color: var(--black-a6);
    cursor: not-allowed;
    box-shadow: none;
}

.SwitchThumb {
    display: block;
    width: 21px;
    height: 21px;
    background-color: white;
    border-radius: 9999px;
    box-shadow: 0 2px 2px var(--black-a7);
    transition: transform 100ms;
    transform: translateX(2px);
    will-change: transform;
}

.SwitchThumb[data-state='checked'] {
    transform: translateX(19px);
}

.Label {
    color: white;
    font-size: 15px;
    line-height: 1;
    display: flex;
    align-items: center;
}

.Button.violet {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 4px;
    padding: 0 15px;
    font-size: 15px;
    line-height: 1;
    font-weight: 500;
    height: 35px;
    background-color: white;
    color: var(--violet-11);
    box-shadow: 0 2px 10px var(--black-a7);
}

.Button.violet:hover {
    background-color: var(--mauve-3);
}

.Button.violet:focus {
    box-shadow: 0 0 0 2px black;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/switch/__tests__/switch.directive.spec.ts
```typescript
import { TestBed } from '@angular/core/testing';

import { ElementRef } from '@angular/core';
import { RdxSwitchRootDirective } from '../src/switch-root.directive';

describe('RdxSwitchRootDirective', () => {
    let directive: RdxSwitchRootDirective;

    beforeEach(() => {
        TestBed.configureTestingModule({
            providers: [
                RdxSwitchRootDirective,
                { provide: ElementRef, useValue: new ElementRef(document.createElement('button')) }]
        });

        directive = TestBed.inject(RdxSwitchRootDirective);
    });

    it('should initialize with default state', () => {
        expect(directive.checked()).toBe(false);
        expect(directive.required()).toBe(false);
        expect(directive.disabled()).toBe(false);
    });

    it('should toggle checked state and emit event', () => {
        const onCheckedChangeSpy = jest.spyOn(directive.onCheckedChange, 'emit');
        directive.toggle();

        expect(directive.checked()).toBe(true);
        expect(onCheckedChangeSpy).toHaveBeenCalledWith(true);

        directive.toggle();

        expect(directive.checked()).toBe(false);
        expect(onCheckedChangeSpy).toHaveBeenCalledWith(false);
    });

    it('should set disabled state using ControlValueAccessor', () => {
        directive.setDisabledState(true);
        expect(directive.disabledState()).toBe(true);

        directive.setDisabledState(false);
        expect(directive.disabledState()).toBe(false);
    });

    it('should emit correct values for controlled checked state', () => {
        const onCheckedChangeSpy = jest.spyOn(directive.onCheckedChange, 'emit');

        directive.checked.set(true);
        directive.toggle(); // Controlled state logic
        expect(directive.checked()).toBe(false);
        expect(onCheckedChangeSpy).toHaveBeenCalledWith(false);
    });
});

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
import { ControlValueAccessor } from '@angular/forms';
import { provideToken, provideValueAccessor } from '@radix-ng/primitives/core';

export const RdxSwitchToken = new InjectionToken<RdxSwitchRootDirective>('RdxSwitchToken');

export function injectSwitch(): RdxSwitchRootDirective {
    return inject(RdxSwitchToken);
}

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
    providers: [
        provideToken(RdxSwitchToken, RdxSwitchRootDirective),
        provideValueAccessor(RdxSwitchRootDirective)],
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
    host: {
        '[attr.data-disabled]': 'switchRoot.disabledState() ? "true" : null',
        '[attr.data-state]': 'switchRoot.checkedState() ? "checked" : "unchecked"'
    }
})
export class RdxSwitchThumbDirective {
    protected readonly switchRoot = injectSwitch();
}

```
