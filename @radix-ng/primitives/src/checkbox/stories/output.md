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
