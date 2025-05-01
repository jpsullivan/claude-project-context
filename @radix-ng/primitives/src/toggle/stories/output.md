/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle/stories/toggle-forms.component.ts
```typescript
import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup, ReactiveFormsModule } from '@angular/forms';
import { RdxToggleVisuallyHiddenInputDirective } from '../src/toggle-visually-hidden-input.directive';
import { RdxToggleDirective } from '../src/toggle.directive';

@Component({
    selector: 'toggle-reactive-forms',
    imports: [ReactiveFormsModule, RdxToggleDirective, RdxToggleVisuallyHiddenInputDirective],
    styleUrl: 'toggle.styles.css',
    template: `
        <form [formGroup]="formGroup" (ngSubmit)="onSubmit()">
            <button class="Toggle" #toggle="rdxToggle" formControlName="pressed" rdxToggle aria-label="Toggle bold">
                <input
                    [name]="'toggleDef'"
                    [value]="toggle.pressed() ? 'on' : 'off'"
                    [required]="false"
                    rdxToggleVisuallyHiddenInput
                />
                @if (toggle.pressed()) {
                    On
                } @else {
                    Off
                }
            </button>

            <button class="Button violet" style="margin-top: 8px;" type="submit">Submit</button>
        </form>
    `
})
export class ToggleButtonReactiveForms implements OnInit {
    formGroup!: FormGroup;

    ngOnInit() {
        this.formGroup = new FormGroup({
            pressed: new FormControl<boolean>(true)
        });
    }

    onSubmit(): void {
        console.log(this.formGroup.value);
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle/stories/toggle.docs.mdx
````
import { ArgTypes, Canvas, Markdown, Meta } from '@storybook/blocks';
import * as ToggleDirectiveStories from './toggle.stories';
import { RdxToggleDirective } from '../src/toggle.directive';
import { RdxToggleVisuallyHiddenInputDirective } from '../src/toggle-visually-hidden-input.directive';

<Meta title="Primitives/Toggle" />

# Toggle

#### A two-\_state button that can be either on or off.

<Canvas sourceState="hidden" of={ToggleDirectiveStories.Default} />

## Features

- ✅ Full keyboard navigation.
- ✅ Can be controlled or uncontrolled.

## Import

Get started with importing the directives:

```typescript
import { RdxToggleDirective } from '@radix-ng/primitives/toggle';
```

## Anatomy

```html
<button rdxToggle aria-label="Toggle italic">
  <icon />
</button>
```

## API Reference

### Toggle

`RdxToggleDirective`

The toggle.

<ArgTypes of={RdxToggleDirective} />

<Markdown>
    {`
  | Data Attribute | Value |
  | ----------- | --------- |
  | [data-state]       | "on" or "off"   |
  | [data-disabled]    | Present when disabled      |
  `}
</Markdown>

### ToggleInput

`RdxToggleVisuallyHiddenInputDirective`

Directive for a visually hidden `<input />`element, specifically designed for use with toggle components.
This directive simplifies the integration of hidden form inputs in toggle components, ensuring compatibility with form handling while maintaining a clean and accessible design.


## Accessibility

### Keyboard Interactions

<Markdown>
  {`
  | Key | Description |
  | ----------- | --------- |
  | Space       | Activates/deactivates the toggle.       |
  | Enter       | Activates/deactivates the toggle.  |
  `}
</Markdown>


## Examples

### Reactive Forms

Toggle can also be used with reactive forms. In this case, the formControlName property is used to bind the component to a form control.
<Canvas sourceState="hidden" of={ToggleDirectiveStories.ReactiveForm} />

### Disabled

When disabled is present, the element cannot be edited and focused.
<Canvas sourceState="hidden" of={ToggleDirectiveStories.Disabled} />

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle/stories/toggle.stories.ts
```typescript
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { Italic, LucideAngularModule } from 'lucide-angular';
import { RdxToggleVisuallyHiddenInputDirective } from '../src/toggle-visually-hidden-input.directive';
import { RdxToggleDirective } from '../src/toggle.directive';
import { ToggleButtonReactiveForms } from './toggle-forms.component';

const html = String.raw;

export default {
    title: 'Primitives/Toggle',
    decorators: [
        moduleMetadata({
            imports: [
                RdxToggleDirective,
                RdxToggleVisuallyHiddenInputDirective,
                ToggleButtonReactiveForms,
                LucideAngularModule,
                LucideAngularModule.pick({ Italic })
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
                        .Toggle {
                            background-color: white;
                            color: var(--mauve-11);
                            height: 35px;
                            width: 35px;
                            border-radius: 4px;
                            display: flex;
                            font-size: 15px;
                            line-height: 1;
                            align-items: center;
                            justify-content: center;
                            box-shadow: 0 2px 10px var(--black-a7);
                        }
                        .Toggle:hover {
                            background-color: var(--violet-3);
                        }
                        .Toggle[disabled] {
                            pointer-events: none;
                            opacity: 0.5;
                        }
                        .Toggle[data-state='on'] {
                            background-color: var(--violet-6);
                            color: var(--violet-12);
                        }
                        .Toggle:focus {
                            box-shadow: 0 0 0 2px black;
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
            <button class="Toggle" rdxToggle aria-label="Toggle italic">
                <lucide-angular name="italic" size="12"></lucide-angular>
            </button>
        `
    })
};

export const State: Story = {
    argTypes: {
        pressed: {
            control: 'boolean'
        },
        disabled: {
            control: 'boolean'
        }
    },
    render: (args) => ({
        props: {
            config: args
        },
        template: html`
            <button
                class="Toggle"
                rdxToggle
                [disabled]="config.disabled"
                [pressed]="config.pressed"
                aria-label="Toggle italic"
            >
                <lucide-angular name="italic" size="12"></lucide-angular>
            </button>
        `
    })
};

export const Controlled: Story = {
    render: (args) => ({
        props: {
            config: args
        },
        template: html`
            <h1>Uncontrolled</h1>
            <span class="">default off</span>
            <button class="Toggle" rdxToggle [pressed]="false" aria-label="Toggle bold" #toggle="rdxToggle">
                <input
                    rdxToggleVisuallyHiddenInput
                    [name]="'toggleDef'"
                    [value]="toggle.pressed()"
                    [required]="false"
                />
                <lucide-angular name="italic" size="12"></lucide-angular>
            </button>

            <h1>Controlled</h1>
            <span class="">default on</span>
            <button
                class="Toggle"
                rdxToggle
                [defaultPressed]="true"
                [pressed]="true"
                aria-label="Toggle bold"
                #toggle="rdxToggle"
            >
                <input
                    rdxToggleVisuallyHiddenInput
                    [name]="'toggleDef'"
                    [value]="toggle.pressed()"
                    [required]="false"
                />
                <lucide-angular name="italic" size="12"></lucide-angular>
            </button>

            <span class="">default off</span>
            <button
                class="Toggle"
                rdxToggle
                [defaultPressed]="false"
                [pressed]="false"
                aria-label="Toggle bold"
                #toggle="rdxToggle"
            >
                <input
                    rdxToggleVisuallyHiddenInput
                    [name]="'toggleDef'"
                    [value]="toggle.pressed()"
                    [required]="false"
                />
                <lucide-angular name="italic" size="12"></lucide-angular>
            </button>

            <h1>Events</h1>
            <span class="">default off</span>
            <button class="Toggle" rdxToggle [pressed]="false" aria-label="Toggle bold" #toggle="rdxToggle">
                <input
                    rdxToggleVisuallyHiddenInput
                    [name]="'toggleDef'"
                    [value]="toggle.pressed()"
                    [required]="false"
                />
                <lucide-angular name="italic" size="12"></lucide-angular>
            </button>
        `
    })
};

export const Disabled: Story = {
    render: () => ({
        template: html`
            <button class="Toggle" disabled rdxToggle #toggle="rdxToggle" aria-label="Toggle disabled">
                <input
                    rdxToggleVisuallyHiddenInput
                    [name]="'toggleDef'"
                    [value]="toggle.pressed()"
                    [required]="false"
                    [disabled]="toggle.disabled()"
                />
                <lucide-angular name="italic" size="12"></lucide-angular>
            </button>
        `
    })
};

export const ReactiveForm: Story = {
    render: () => ({
        template: html`
            <toggle-reactive-forms></toggle-reactive-forms>
        `
    })
};

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle/stories/toggle.styles.css
```css
button {
    all: unset;
}

.Toggle {
    background-color: white;
    color: var(--mauve-11);
    height: 35px;
    width: 35px;
    border-radius: 4px;
    display: flex;
    font-size: 15px;
    line-height: 1;
    align-items: center;
    justify-content: center;
    box-shadow: 0 2px 10px var(--black-a7);
}

.Toggle:hover {
    background-color: var(--violet-3);
}

.Toggle[disabled] {
    pointer-events: none;
    opacity: 0.5;
}

.Toggle[data-state='on'] {
    background-color: var(--violet-6);
    color: var(--violet-12);
}

.Toggle:focus {
    box-shadow: 0 0 0 2px black;
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
