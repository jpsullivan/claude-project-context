/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle/README.md
```
# @radix-ng/primitives/toggle

Secondary entry point of `@radix-ng/primitives/toggle`.

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle/index.ts
```typescript
export * from './src/toggle-visually-hidden-input.directive';
export * from './src/toggle.directive';

export type { DataState, ToggleProps } from './src/toggle.directive';

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
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
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle/__tests__/toggle.directive.spec.ts
```typescript
import { Component, DebugElement, Input } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { RdxToggleDirective } from '../src/toggle.directive';

@Component({
    template:
        '<button rdxToggle [pressed]="pressed" [disabled]="disabled" (onPressedChange)="onToggle($event)">Toggle</button>',
    imports: [RdxToggleDirective]
})
class TestComponent {
    @Input() pressed = false;
    @Input() disabled = false;

    onToggle(pressed: boolean) {
        this.pressed = pressed;
    }
}

describe('RdxToggleDirective', () => {
    let component: TestComponent;
    let fixture: ComponentFixture<TestComponent>;
    let button: DebugElement;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [TestComponent]
        }).compileComponents();
    });

    beforeEach(() => {
        fixture = TestBed.createComponent(TestComponent);
        component = fixture.componentInstance;
        button = fixture.debugElement.query(By.css('button'));
        fixture.detectChanges();
    });

    it('should initialize with default values', () => {
        expect(component.pressed).toBe(false);
        expect(component.disabled).toBe(false);
    });

    it('should apply the correct aria-pressed attribute', () => {
        expect(button.nativeElement.getAttribute('aria-pressed')).toBe('false');
        component.pressed = true;
        fixture.detectChanges();
        expect(button.nativeElement.getAttribute('aria-pressed')).toBe('true');
    });

    it('should apply the correct data-state attribute', () => {
        expect(button.nativeElement.getAttribute('data-state')).toBe('off');
        component.pressed = true;
        fixture.detectChanges();
        expect(button.nativeElement.getAttribute('data-state')).toBe('on');
    });

    it('should apply the correct data-disabled attribute', () => {
        expect(button.nativeElement.getAttribute('data-disabled')).toBe(null);
        component.disabled = true;
        fixture.detectChanges();
        expect(button.nativeElement.getAttribute('data-disabled')).toBe('');
    });

    it('should toggle the pressed state on click', () => {
        expect(component.pressed).toBe(false);
        button.nativeElement.click();
        expect(component.pressed).toBe(true);
        button.nativeElement.click();
        expect(component.pressed).toBe(false);
    });

    it('should not toggle the pressed state when disabled', () => {
        component.disabled = true;
        fixture.detectChanges();
        expect(component.pressed).toBe(false);
        button.nativeElement.click();
        expect(component.pressed).toBe(false);
    });

    it('should emit the pressed state change event on toggle', () => {
        const spy = jest.spyOn(component, 'onToggle');
        button.nativeElement.click();
        expect(spy).toHaveBeenCalledWith(true);
        button.nativeElement.click();
        expect(spy).toHaveBeenCalledWith(false);
    });
});

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle/src/toggle-visually-hidden-input.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxVisuallyHiddenInputDirective } from '@radix-ng/primitives/visually-hidden';

@Directive({
    selector: 'input[rdxToggleVisuallyHiddenInput]',
    exportAs: 'rdxToggleVisuallyHiddenInput',
    hostDirectives: [
        {
            directive: RdxVisuallyHiddenInputDirective,
            inputs: [
                'name',
                'required',
                'value',
                'disabled'
            ]
        }
    ],
    host: {
        type: 'checkbox'
    }
})
export class RdxToggleVisuallyHiddenInputDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle/src/toggle.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, computed, Directive, input, model, output, OutputEmitterRef, signal } from '@angular/core';
import { ControlValueAccessor } from '@angular/forms';
import { provideValueAccessor } from '@radix-ng/primitives/core';

export interface ToggleProps {
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
    onPressedChange?: OutputEmitterRef<boolean>;

    /**
     * Whether the toggle is disabled.
     * @defaultValue false
     */
    disabled?: boolean;
}

export type DataState = 'on' | 'off';

/**
 * @group Components
 */
@Directive({
    selector: '[rdxToggle]',
    exportAs: 'rdxToggle',
    providers: [provideValueAccessor(RdxToggleDirective)],
    host: {
        '[attr.aria-pressed]': 'pressed()',
        '[attr.data-state]': 'dataState()',
        '[attr.data-disabled]': 'disabledState() ? "" : undefined',
        '[disabled]': 'disabledState()',

        '(click)': 'togglePressed()'
    }
})
export class RdxToggleDirective implements ControlValueAccessor {
    /**
     * The pressed state of the toggle when it is initially rendered.
     * Use when you do not need to control its pressed state.
     *
     * @group Props
     */
    readonly defaultPressed = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * The controlled pressed state of the toggle.
     * Must be used in conjunction with `onPressedChange`.
     *
     * @group Props
     */
    readonly pressed = model<boolean>(this.defaultPressed());

    /**
     * When true, prevents the user from interacting with the toggle.
     *
     * @group Props
     */
    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /** @ignore */
    readonly disabledModel = model<boolean>(this.disabled());

    /** @ignore */
    readonly disabledState = computed(() => this.disabled() || this.disabledModel() || this.accessorDisabled());

    protected readonly dataState = computed<DataState>(() => {
        return this.pressed() ? 'on' : 'off';
    });

    /**
     * Event handler called when the pressed state of the toggle changes.
     *
     * @group Emits
     */
    readonly onPressedChange = output<boolean>();

    protected togglePressed(): void {
        if (!this.disabled()) {
            this.pressed.set(!this.pressed());
            this.onChange(this.pressed());
            this.onPressedChange.emit(this.pressed());
        }
    }

    private readonly accessorDisabled = signal(false);

    private onChange: (value: any) => void = () => {};

    /** @ignore */
    onTouched: (() => void) | undefined;

    /** @ignore */
    writeValue(value: any): void {
        this.pressed.set(value);
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
