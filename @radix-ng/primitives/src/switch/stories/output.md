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
