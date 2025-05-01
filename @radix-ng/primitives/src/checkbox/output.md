/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/checkbox/README.md
```
# @radix-ng/primitives/checkbox

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/checkbox/index.ts
```typescript
import { NgModule } from '@angular/core';
import { RdxCheckboxButtonDirective } from './src/checkbox-button.directive';
import { RdxCheckboxIndicatorDirective } from './src/checkbox-indicator.directive';
import { RdxCheckboxInputDirective } from './src/checkbox-input.directive';
import { RdxCheckboxDirective } from './src/checkbox.directive';

export * from './src/checkbox-button.directive';
export * from './src/checkbox-indicator.directive';
export * from './src/checkbox-input.directive';
export * from './src/checkbox.directive';
export type { CheckboxState } from './src/checkbox.directive';
export * from './src/checkbox.token';

const _imports = [
    RdxCheckboxInputDirective,
    RdxCheckboxDirective,
    RdxCheckboxButtonDirective,
    RdxCheckboxIndicatorDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxCheckboxModule {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/checkbox/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/checkbox/stories/checkbox-group.component.ts
```typescript
import { JsonPipe } from '@angular/common';
import { Component } from '@angular/core';
import { FormBuilder, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RdxLabelDirective } from '@radix-ng/primitives/label';
import { LucideAngularModule } from 'lucide-angular';
import { RdxCheckboxIndicatorDirective } from '../src/checkbox-indicator.directive';
import { RdxCheckboxInputDirective } from '../src/checkbox-input.directive';
import { RdxCheckboxDirective } from '../src/checkbox.directive';

@Component({
    selector: 'checkbox-groups-forms-example',
    template: `
        <section [formGroup]="personality">
            <p>
                <label class="Label" rdxLabel htmlFor="r1">
                    <button class="CheckboxRoot" rdxCheckboxRoot formControlName="fun">
                        <lucide-angular class="CheckboxIndicator" rdxCheckboxIndicator size="16" name="check" />
                        <input class="Input" id="r1" rdxCheckboxInput />
                    </button>
                    Fun
                </label>
            </p>
            <p>
                <label class="Label" rdxLabel htmlFor="r2">
                    <button
                        class="CheckboxRoot rt-BaseCheckboxRoot rt-CheckboxRoot"
                        rdxCheckboxRoot
                        formControlName="serious"
                    >
                        <lucide-angular class="CheckboxIndicator" rdxCheckboxIndicator size="16" name="check" />
                        <input class="Input" id="r2" rdxCheckboxInput />
                    </button>
                    Serious
                </label>
            </p>
            <p>
                <label class="Label" rdxLabel htmlFor="r3">
                    <button class="CheckboxRoot" rdxCheckboxRoot formControlName="smart">
                        <lucide-angular class="CheckboxIndicator" rdxCheckboxIndicator size="16" name="check" />
                        <input class="Input" id="r3" rdxCheckboxInput />
                    </button>
                    Smart
                </label>
            </p>
        </section>
        <section class="Label" [formGroup]="personality">
            <h4>You chose:&nbsp;</h4>
            {{ personality.value | json }}
        </section>

        <button
            class="rt-reset rt-BaseButton rt-r-size-2 rt-variant-solid rt-Button"
            (click)="toggleDisable()"
            data-accent-color="cyan"
        >
            Toggle disabled state
        </button>
    `,
    styleUrl: 'checkbox-group.styles.scss',
    imports: [
        FormsModule,
        ReactiveFormsModule,
        JsonPipe,
        RdxLabelDirective,
        RdxCheckboxDirective,
        RdxCheckboxIndicatorDirective,
        LucideAngularModule,
        RdxCheckboxInputDirective
    ]
})
export class CheckboxReactiveFormsExampleComponent {
    personality = this.formBuilder.group({
        fun: false,
        serious: false,
        smart: false
    });

    constructor(protected formBuilder: FormBuilder) {}

    toggleDisable() {
        const checkbox = this.personality.get('serious');
        if (checkbox != null) {
            checkbox.disabled ? checkbox.enable() : checkbox.disable();
        }
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/checkbox/stories/checkbox-group.styles.scss
```
.Input {
    transform: translateX(-100%);
    position: absolute;
    pointer-events: none;
    opacity: 0;
    margin: 0;
    width: 25px;
    height: 25px;
}

.CheckboxRoot {
    all: unset;
    background-color: white;
    width: 25px;
    height: 25px;
    margin-right: 15px;
    border-radius: 4px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 2px 10px var(--black-a7);

    &:where(:disabled) {
        cursor: var(--cursor-disabled);
        background-color: var(--gray-5);
    }
}

.CheckboxRoot:focus {
    box-shadow: 0 0 0 2px black;
}

.CheckboxIndicator {
    align-items: center;
    display: flex;
    color: var(--violet-11);
}

.CheckboxIndicator[data-state='unchecked'] {
    display: none;
}

.Label {
    color: white;
    font-size: 15px;
    line-height: 1;
    display: flex;
    align-items: center;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/checkbox/stories/checkbox-indeterminate.component.ts
```typescript
import { Component, model } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RdxLabelDirective } from '@radix-ng/primitives/label';
import { LucideAngularModule } from 'lucide-angular';
import { RdxCheckboxIndicatorDirective } from '../src/checkbox-indicator.directive';
import { RdxCheckboxInputDirective } from '../src/checkbox-input.directive';
import { RdxCheckboxDirective } from '../src/checkbox.directive';

@Component({
    selector: 'checkbox-indeterminate-example',
    imports: [
        FormsModule,
        RdxLabelDirective,
        RdxCheckboxDirective,
        RdxCheckboxIndicatorDirective,
        LucideAngularModule,
        RdxCheckboxInputDirective
    ],
    template: `
        <label class="Label" rdxLabel htmlFor="r1">
            <button class="CheckboxRoot" [(indeterminate)]="indeterminate" [(ngModel)]="checked" rdxCheckboxRoot>
                <lucide-angular class="CheckboxIndicator" [name]="iconName()" rdxCheckboxIndicator size="16" />
                <input class="Input" id="r1" rdxCheckboxInput />
            </button>
            I'm a checkbox
        </label>

        <p>
            <button
                class="rt-reset rt-BaseButton rt-r-size-2 rt-variant-solid rt-Button"
                (click)="toggleIndeterminate()"
                data-accent-color="cyan"
            >
                Toggle Indeterminate state
            </button>
        </p>
    `,
    styleUrl: 'checkbox-group.styles.scss'
})
export class CheckboxIndeterminateComponent {
    readonly indeterminate = model(false);
    readonly checked = model(false);

    readonly iconName = model('check');

    toggleIndeterminate() {
        this.indeterminate.set(!this.indeterminate());

        this.iconName() === 'check' ? this.iconName.set('minus') : this.iconName.set('check');
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/checkbox/stories/checkbox.docs.mdx
````
import { ArgTypes, Canvas, Markdown, Meta } from '@storybook/blocks';
import { RdxCheckboxDirective } from '../src/checkbox.directive';
import * as CheckboxDirectiveStories from './checkbox.stories';

<Meta title="Primitives/Checkbox" />

# Checkbox

#### A control that allows the user to toggle between checked and not checked.

<Canvas sourceState="hidden" of={CheckboxDirectiveStories.Default} />

## Features

- ✅ Full keyboard navigation.
- ✅ Supports indeterminate \_state.
- ✅ Can be controlled or uncontrolled.

## Import

Get started with importing the directives:

```typescript
import { RdxCheckboxDirective, RdxCheckboxInputDirective, RdxCheckboxIndicatorDirective } from '@radix-ng/primitives/checkbox';
```

## Anatomy

```html
<button rdxCheckboxRoot [(checked)]="checked">
  <lucide-angular rdxCheckboxIndicator name="check" />
  <input rdxCheckboxInput type="checkbox" />
</button>
```

## API Reference

### RdxCheckboxDirective

<ArgTypes of={RdxCheckboxDirective} />

### RdxCheckboxIndicatorDirective

### RdxRadioIndicatorDirective

## Accessibility

Adheres to the [tri-\_state Checkbox WAI-ARIA design pattern](https://www.w3.org/WAI/ARIA/apg/patterns/checkbox).

### Keyboard Interactions

<Markdown>
  {`
  | Key | Description |
  | ----------- | --------- |
  | Space       | Checks/unchecks the checkbox.        |
  `}
</Markdown>

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/checkbox/stories/checkbox.stories.ts
```typescript
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { Check, LucideAngularModule, Minus } from 'lucide-angular';
import { RdxLabelDirective } from '../../label';
import { RdxCheckboxIndicatorDirective } from '../src/checkbox-indicator.directive';
import { RdxCheckboxInputDirective } from '../src/checkbox-input.directive';
import { RdxCheckboxDirective } from '../src/checkbox.directive';
import { CheckboxReactiveFormsExampleComponent } from './checkbox-group.component';
import { CheckboxIndeterminateComponent } from './checkbox-indeterminate.component';

const html = String.raw;

export default {
    title: 'Primitives/Checkbox',
    decorators: [
        moduleMetadata({
            imports: [
                RdxLabelDirective,
                RdxCheckboxDirective,
                RdxCheckboxIndicatorDirective,
                RdxCheckboxInputDirective,
                LucideAngularModule,
                LucideAngularModule.pick({ Check, Minus }),
                CheckboxReactiveFormsExampleComponent,
                CheckboxIndeterminateComponent
            ]
        }),
        componentWrapperDecorator(
            (story) => html`
                <div
                    class="radix-themes light light-theme radix-themes-default-fonts"
                    data-accent-color="indigo"
                    data-gray-color="slate"
                    data-radius="medium"
                    data-scaling="100%"
                >
                    ${story}
                </div>
            `
        )
    ]
} as Meta;

type Story = StoryObj;

export const Default: Story = {
    render: () => ({
        template: html`
            <form>
                <div style="display: flex; align-items: center;">
                    <button class="CheckboxRoot" rdxCheckboxRoot [(checked)]="checked">
                        <lucide-angular
                            class="CheckboxIndicator"
                            rdxCheckboxIndicator
                            size="16"
                            name="check"
                        ></lucide-angular>
                        <input id="r1" rdxCheckboxInput type="checkbox" />
                    </button>
                    <label class="Label" rdxLabel htmlFor="r1">Check Item</label>
                </div>
            </form>

            <style>
                button {
                    all: unset;
                }

                .CheckboxRoot {
                    background-color: white;
                    width: 25px;
                    height: 25px;
                    border-radius: 4px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    box-shadow: 0 2px 10px var(--black-a7);
                }
                .CheckboxRoot:hover {
                    background-color: var(--violet-3);
                }
                .CheckboxRoot:focus {
                    box-shadow: 0 0 0 2px black;
                }

                .CheckboxIndicator {
                    align-items: center;
                    display: flex;
                    color: var(--violet-11);
                }

                .CheckboxIndicator[data-state='unchecked'] {
                    display: none;
                }

                .Label {
                    color: white;
                    padding-left: 15px;
                    font-size: 15px;
                    line-height: 1;
                }
            </style>
        `
    })
};

export const CheckboxGroup: Story = {
    name: 'With Reactive forms',
    render: () => ({
        template: html`
            <checkbox-groups-forms-example></checkbox-groups-forms-example>
        `
    })
};

export const indeterminate: Story = {
    render: () => ({
        template: html`
            <checkbox-indeterminate-example></checkbox-indeterminate-example>
        `
    })
};

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/checkbox/src/checkbox-button.directive.ts
```typescript
import { computed, Directive, input } from '@angular/core';
import { injectCheckbox } from './checkbox.token';

@Directive({
    standalone: true,
    selector: 'button[rdxCheckboxButton]',
    host: {
        type: 'button',
        role: 'checkbox',
        tabindex: '-1',
        '[checked]': 'checkbox.checked',
        '[disabled]': 'checkbox.disabled',
        '[required]': 'checkbox.required',
        '[attr.id]': 'elementId()',
        '[attr.aria-checked]': 'checkbox.indeterminate ? "mixed" : checkbox.checked',
        '[attr.aria-required]': 'checkbox.required ? "" : null',
        '[attr.data-state]': 'checkbox.state',
        '[attr.data-disabled]': 'checkbox.disabled ? "" : null'
    }
})
export class RdxCheckboxButtonDirective {
    protected readonly checkbox = injectCheckbox();

    readonly id = input<string | null>(null);

    protected readonly elementId = computed(() => (this.id() ? this.id() : `rdx-checkbox-${this.id()}`));
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/checkbox/src/checkbox-indicator.directive.ts
```typescript
import { Directive } from '@angular/core';
import { injectCheckbox } from './checkbox.token';

@Directive({
    selector: '[rdxCheckboxIndicator]',
    standalone: true,
    host: {
        '[style.pointer-events]': '"none"',
        '[attr.aria-checked]': 'checkbox.indeterminate ? "mixed" : checkbox.checked',
        '[attr.data-state]': 'checkbox.state',
        '[attr.data-disabled]': 'checkbox.disabled ? "" : null'
    }
})
export class RdxCheckboxIndicatorDirective {
    protected readonly checkbox = injectCheckbox();
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/checkbox/src/checkbox-input.directive.ts
```typescript
import { computed, Directive, input } from '@angular/core';
import { RdxVisuallyHiddenInputDirective } from '@radix-ng/primitives/visually-hidden';
import { injectCheckbox } from './checkbox.token';

@Directive({
    standalone: true,
    selector: 'input[rdxCheckboxInput]',
    hostDirectives: [{ directive: RdxVisuallyHiddenInputDirective, inputs: ['feature: "fully-hidden"'] }],
    host: {
        type: 'checkbox',
        tabindex: '-1',
        '[checked]': 'checkbox.checked',
        '[disabled]': 'checkbox.disabled',
        '[required]': 'checkbox.required',
        '[attr.id]': 'elementId()',
        '[attr.aria-hidden]': 'true',
        '[attr.aria-checked]': 'checkbox.indeterminate ? "mixed" : checkbox.checked',
        '[attr.aria-required]': 'checkbox.required ? "" : null',
        '[attr.data-state]': 'checkbox.state',
        '[attr.data-disabled]': 'checkbox.disabled ? "" : null',
        '[attr.value]': 'value()'
    }
})
export class RdxCheckboxInputDirective {
    protected readonly checkbox = injectCheckbox();

    readonly id = input<string>();

    protected readonly elementId = computed(() => (this.id() ? this.id() : `rdx-checkbox-${this.id()}`));

    protected readonly value = computed(() => {
        const state = this.checkbox.state;
        if (state === 'indeterminate') {
            return '';
        }

        return state ? 'on' : 'off';
    });
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/checkbox/src/checkbox.directive.ts
```typescript
import { booleanAttribute, Directive, EventEmitter, Input, OnChanges, Output, SimpleChanges } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { RdxCheckboxToken } from './checkbox.token';

export type CheckboxState = 'unchecked' | 'checked' | 'indeterminate';

/**
 * @group Components
 */
@Directive({
    selector: '[rdxCheckboxRoot]',
    standalone: true,
    providers: [
        { provide: RdxCheckboxToken, useExisting: RdxCheckboxDirective },
        { provide: NG_VALUE_ACCESSOR, useExisting: RdxCheckboxDirective, multi: true }
    ],
    host: {
        '[disabled]': 'disabled',
        '[attr.data-disabled]': 'disabled ? "" : null',
        '[attr.data-state]': 'state',

        '(keydown)': 'onKeyDown($event)',
        '(click)': 'onClick($event)',
        '(blur)': 'onBlur()'
    }
})
export class RdxCheckboxDirective implements ControlValueAccessor, OnChanges {
    /**
     * The controlled checked state of the checkbox. Must be used in conjunction with onCheckedChange.
     * @group Props
     */
    @Input({ transform: booleanAttribute }) checked = false;

    /**
     * Defines whether the checkbox is indeterminate.
     * @group Props
     */
    @Input({ transform: booleanAttribute }) indeterminate = false;

    /**
     * Defines whether the checkbox is disabled.
     * @group Props
     */
    @Input({ transform: booleanAttribute }) disabled = false;

    /**
     * @group Props
     */
    @Input({ transform: booleanAttribute }) required = false;

    /**
     * Event emitted when the checkbox checked state changes.
     * @group Emits
     */
    @Output() readonly checkedChange = new EventEmitter<boolean>();

    /**
     * Event emitted when the indeterminate state changes.
     * @group Emits
     */
    @Output() readonly indeterminateChange = new EventEmitter<boolean>();

    /**
     * Determine the state
     */
    get state(): CheckboxState {
        if (this.indeterminate) {
            return 'indeterminate';
        }
        return this.checked ? 'checked' : 'unchecked';
    }

    /**
     * Store the callback function that should be called when the checkbox checked state changes.
     * @internal
     */
    private onChange?: (checked: boolean) => void;

    /**
     * Store the callback function that should be called when the checkbox is blurred.
     * @internal
     */
    private onTouched?: () => void;

    protected onKeyDown(event: KeyboardEvent): void {
        // According to WAI ARIA, Checkboxes don't activate on enter keypress
        if (event.key === 'Enter') {
            event.preventDefault();
        }
    }

    protected onClick($event: MouseEvent): void {
        if (this.disabled) {
            return;
        }

        this.checked = this.indeterminate ? true : !this.checked;
        this.checkedChange.emit(this.checked);
        this.onChange?.(this.checked);

        if (this.indeterminate) {
            this.indeterminate = false;
            this.indeterminateChange.emit(this.indeterminate);
        }

        $event.preventDefault();
    }

    protected onBlur(): void {
        this.onTouched?.();
    }

    ngOnChanges(changes: SimpleChanges): void {
        if (changes['checked'] && !changes['checked'].isFirstChange()) {
            this.checkedChange.emit(this.checked);
        }
        if (changes['indeterminate'] && !changes['indeterminate'].isFirstChange()) {
            this.indeterminateChange.emit(this.indeterminate);
        }
    }

    /**
     * Sets the checked state of the checkbox.
     * @param checked The checked state of the checkbox.
     * @internal
     */
    writeValue(checked: boolean): void {
        this.checked = checked;
    }

    /**
     * Registers a callback function that should be called when the checkbox checked state changes.
     * @param fn The callback function.
     * @internal
     */
    registerOnChange(fn: (checked: boolean) => void): void {
        this.onChange = fn;
    }

    /**
     * Registers a callback function that should be called when the checkbox is blurred.
     * @param fn The callback function.
     * @internal
     */
    registerOnTouched(fn: () => void): void {
        this.onTouched = fn;
    }

    /**
     * Sets the disabled state of the checkbox.
     * @param isDisabled The disabled state of the checkbox.
     * @internal
     */
    setDisabledState(isDisabled: boolean): void {
        this.disabled = isDisabled;
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/checkbox/src/checkbox.token.ts
```typescript
import { inject, InjectionToken } from '@angular/core';
import type { RdxCheckboxDirective } from './checkbox.directive';

export const RdxCheckboxToken = new InjectionToken<RdxCheckboxDirective>('RdxCheckboxToken');

export function injectCheckbox(): RdxCheckboxDirective {
    return inject(RdxCheckboxToken);
}

```
