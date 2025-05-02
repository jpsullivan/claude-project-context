/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle-group/README.md
```
# @radix-ng/primitives/toggle-group

Secondary entry point of `@radix-ng/primitives/toggle-group`.

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle-group/index.ts
```typescript
export * from './src/toggle-group-item.directive';
export * from './src/toggle-group-item.token';
export * from './src/toggle-group-without-focus.directive';
export * from './src/toggle-group.directive';
export * from './src/toggle-group.token';

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle-group/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle-group/stories/toggle-group.docs.mdx
````
import { ArgTypes, Canvas, Markdown, Meta } from '@storybook/blocks';
import * as ToggleGroupDirectiveStories from './toggle-group.stories';
import { RdxToggleGroupDirective } from '../src/toggle-group.directive';
import { RdxToggleGroupItemDirective } from '../src/toggle-group-item.directive';

<Meta title="Primitives/Toggle Group" />

# Toggle Group

#### A set of two-\_state buttons that can be toggled on or off.

<Canvas sourceState="hidden" of={ToggleGroupDirectiveStories.Default} />

## Features

- ✅ Full keyboard navigation.
- ✅ Supports horizontal/vertical orientation.
- ✅ Support single and multiple pressed buttons.
- ✅ Can be controlled or uncontrolled.

## Import

Get started with importing the directives:

```typescript
import {
  RdxToggleGroupDirective,
  RdxToggleGroupItemDirective
} from '@radix-ng/primitives/toggle-group';
```

## Examples

```html
<div class="ToggleGroup" rdxToggleGroup value="center" aria-label="Text alignment">
  <button class="ToggleGroupItem" rdxToggleGroupItem value="left" aria-label="Left aligned">
    <lucide-icon name="align-left" size="16"></lucide-icon>
  </button>
  <button class="ToggleGroupItem" rdxToggleGroupItem value="center" aria-label="Center aligned">
    <lucide-icon name="align-center" size="16"></lucide-icon>
  </button>
  <button class="ToggleGroupItem" rdxToggleGroupItem value="right" aria-label="Right aligned">
    <lucide-icon name="align-right" size="16"></lucide-icon>
  </button>
</div>
```

## API Reference

### Root

`RdxToggleGroupDirective`

<ArgTypes of={RdxToggleGroupDirective} />

<Markdown>
  {`
  | Data Attribute | Value |
  | ----------- | --------- |
  | [data-orientation]       | "vertical" or "horizontal"   |
  `}
</Markdown>

### Item

`RdxToggleGroupItemDirective`

<ArgTypes of={RdxToggleGroupItemDirective} />

## Accessibility

Uses [roving tabindex](https://www.w3.org/TR/wai-aria-practices-1.2/examples/radio/radio.html) to manage focus movement among items.

### Keyboard Interactions

<Markdown>
  {`
  | Key | Description |
  | ----------- | --------- |
  | Tab         | Moves focus to either the pressed item or the first item in the group. |
  | Space       | Activates/deactivates the item.       |
  | Enter       | Activates/deactivates the item.  |
  | ArrowDown   |    Moves focus to the next item in the group. |
  | ArrowRight  | Moves focus to the next item in the group. |
  | ArrowUp     | Moves focus to the previous item in the group. |
  | ArrowLeft   | Moves focus to the previous item in the group.  |
  | Home        | Moves focus to the first item. |
  | End         | Moves focus to the last item.  |
  `}
</Markdown>

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle-group/stories/toggle-group.stories.ts
```typescript
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { AlignCenter, AlignLeft, AlignRight, LucideAngularModule } from 'lucide-angular';
import { RdxToggleGroupItemDirective } from '../src/toggle-group-item.directive';
import { RdxToggleGroupDirective } from '../src/toggle-group.directive';

const html = String.raw;

export default {
    title: 'Primitives/Toggle Group',
    decorators: [
        moduleMetadata({
            imports: [
                RdxToggleGroupDirective,
                RdxToggleGroupItemDirective,
                LucideAngularModule,
                LucideAngularModule.pick({ AlignRight, AlignLeft, AlignCenter })
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
                        .ToggleGroup {
                            display: inline-flex;
                            background-color: var(--mauve-6);
                            border-radius: 4px;
                            box-shadow: 0 2px 10px var(--black-a7);
                        }

                        .ToggleGroupItem {
                            background-color: white;
                            color: var(--mauve-11);
                            height: 35px;
                            width: 35px;
                            display: flex;
                            font-size: 15px;
                            line-height: 1;
                            align-items: center;
                            justify-content: center;
                            margin-left: 1px;
                        }
                        .ToggleGroupItem[disabled] {
                            cursor: not-allowed;
                            opacity: 0.5;
                        }
                        .ToggleGroupItem:first-child {
                            margin-left: 0;
                            border-top-left-radius: 4px;
                            border-bottom-left-radius: 4px;
                        }
                        .ToggleGroupItem:last-child {
                            border-top-right-radius: 4px;
                            border-bottom-right-radius: 4px;
                        }
                        .ToggleGroupItem:hover {
                            background-color: var(--violet-3);
                        }
                        .ToggleGroupItem[data-state='on'] {
                            background-color: var(--violet-5);
                            color: var(--violet-11);
                        }
                        .ToggleGroupItem:focus {
                            position: relative;
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
            <div class="ToggleGroup" rdxToggleGroup value="center" aria-label="Text alignment">
                <button class="ToggleGroupItem" rdxToggleGroupItem value="left" aria-label="Left aligned">
                    <lucide-icon name="align-left" size="12"></lucide-icon>
                </button>
                <button class="ToggleGroupItem" rdxToggleGroupItem value="center" aria-label="Center aligned">
                    <lucide-icon name="align-center" size="12"></lucide-icon>
                </button>
                <button class="ToggleGroupItem" rdxToggleGroupItem value="right" aria-label="Right aligned">
                    <lucide-icon name="align-right" size="12"></lucide-icon>
                </button>
            </div>
        `
    })
};

export const Multiple: Story = {
    render: () => ({
        props: {
            selectedValues: ['left', 'center']
        },
        template: html`
            <div
                class="ToggleGroup"
                rdxToggleGroup
                type="multiple"
                [value]="selectedValues"
                aria-label="Text alignment"
            >
                <button class="ToggleGroupItem" rdxToggleGroupItem value="left" aria-label="Left aligned">
                    <lucide-icon name="align-left" size="12"></lucide-icon>
                </button>
                <button class="ToggleGroupItem" rdxToggleGroupItem value="center" aria-label="Center aligned">
                    <lucide-icon name="align-center" size="12"></lucide-icon>
                </button>
                <button class="ToggleGroupItem" rdxToggleGroupItem value="right" aria-label="Right aligned">
                    <lucide-icon name="align-right" size="12"></lucide-icon>
                </button>
            </div>
        `
    })
};

export const Disable: Story = {
    render: () => ({
        props: {
            selectedValues: ['center']
        },
        template: html`
            <div
                class="ToggleGroup"
                rdxToggleGroup
                type="multiple"
                [value]="selectedValues"
                aria-label="Text alignment"
            >
                <button class="ToggleGroupItem" disabled rdxToggleGroupItem value="left" aria-label="Left aligned">
                    <lucide-icon name="align-left" size="12"></lucide-icon>
                </button>
                <button class="ToggleGroupItem" rdxToggleGroupItem value="center" aria-label="Center aligned">
                    <lucide-icon name="align-center" size="12"></lucide-icon>
                </button>
                <button class="ToggleGroupItem" disabled rdxToggleGroupItem value="right" aria-label="Right aligned">
                    <lucide-icon name="align-right" size="12"></lucide-icon>
                </button>
            </div>
        `
    })
};

export const DisableGroup: Story = {
    render: () => ({
        template: html`
            <div class="ToggleGroup" rdxToggleGroup aria-label="Text alignment" disabled>
                <button class="ToggleGroupItem" rdxToggleGroupItem value="left" aria-label="Left aligned">
                    <lucide-icon name="align-left" size="12"></lucide-icon>
                </button>
                <button class="ToggleGroupItem" rdxToggleGroupItem value="center" aria-label="Center aligned">
                    <lucide-icon name="align-center" size="12"></lucide-icon>
                </button>
                <button class="ToggleGroupItem" rdxToggleGroupItem value="right" aria-label="Right aligned">
                    <lucide-icon name="align-right" size="12"></lucide-icon>
                </button>
            </div>
        `
    })
};

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle-group/src/toggle-group-item.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, computed, Directive, effect, inject, input } from '@angular/core';
import { RdxRovingFocusItemDirective } from '@radix-ng/primitives/roving-focus';
import { RdxToggleDirective } from '@radix-ng/primitives/toggle';
import { RdxToggleGroupItemToken } from './toggle-group-item.token';
import { injectToggleGroup } from './toggle-group.token';

/**
 * @group Components
 */
@Directive({
    selector: '[rdxToggleGroupItem]',
    exportAs: 'rdxToggleGroupItem',
    providers: [{ provide: RdxToggleGroupItemToken, useExisting: RdxToggleGroupItemDirective }],
    hostDirectives: [
        {
            directive: RdxRovingFocusItemDirective,
            inputs: ['focusable', 'active', 'allowShiftKey']
        },
        {
            directive: RdxToggleDirective,
            inputs: ['pressed', 'disabled']
        }
    ],
    host: {
        '(click)': 'toggle()'
    }
})
export class RdxToggleGroupItemDirective {
    private readonly rdxToggleDirective = inject(RdxToggleDirective);

    private readonly rdxRovingFocusItemDirective = inject(RdxRovingFocusItemDirective);

    /**
     * Access the toggle group.
     * @ignore
     */
    protected readonly rootContext = injectToggleGroup();

    /**
     * The value of this toggle button.
     *
     * @group Props
     */
    readonly value = input.required<string>();

    /**
     * Whether this toggle button is disabled.
     * @defaultValue false
     * @group Props
     */
    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    private readonly isPressed = computed(() => {
        return this.rootContext.type() === 'single'
            ? this.rootContext.value() === this.value()
            : this.rootContext.value()?.includes(this.value());
    });

    private readonly isDisabled = computed(() => this.rootContext.disabled() || this.disabled());

    constructor() {
        effect(() => {
            this.rdxToggleDirective.pressed.set(!!this.isPressed());
            this.rdxToggleDirective.disabledModel.set(this.isDisabled());

            this.rdxRovingFocusItemDirective.active = !!this.isPressed();
        });
    }

    /**
     * @ignore
     */
    toggle(): void {
        if (this.disabled()) {
            return;
        }

        this.rootContext.toggle(this.value());
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle-group/src/toggle-group-item.token.ts
```typescript
import { inject, InjectionToken } from '@angular/core';
import type { RdxToggleGroupItemDirective } from './toggle-group-item.directive';

export const RdxToggleGroupItemToken = new InjectionToken<RdxToggleGroupItemDirective>('RdxToggleGroupItemToken');

export function injectToggleGroupItem(): RdxToggleGroupItemDirective {
    return inject(RdxToggleGroupItemToken);
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle-group/src/toggle-group-without-focus.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, Directive, input, model, output, signal } from '@angular/core';
import { ControlValueAccessor } from '@angular/forms';
import { provideValueAccessor } from '@radix-ng/primitives/core';
import { RdxToggleGroupToken } from './toggle-group.token';

let nextId = 0;

@Directive({
    selector: '[rdxToggleGroupWithoutFocus]',
    exportAs: 'rdxToggleGroupWithoutFocus',
    providers: [
        { provide: RdxToggleGroupToken, useExisting: RdxToggleGroupWithoutFocusDirective },
        provideValueAccessor(RdxToggleGroupWithoutFocusDirective)],
    host: {
        role: 'group',
        '(focusout)': 'onTouched?.()'
    }
})
export class RdxToggleGroupWithoutFocusDirective implements ControlValueAccessor {
    /**
     * @ignore
     */
    readonly id: string = `rdx-toggle-group-${nextId++}`;

    /**
     * @group Props
     */
    readonly value = model<string | string[] | undefined>(undefined);

    /**
     * @group Props
     */
    readonly type = input<'single' | 'multiple'>('single');

    /**
     * Whether the toggle group is disabled.
     * @defaultValue false
     * @group Props
     */
    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * Event emitted when the selected toggle button changes.
     * @group Emits
     */
    readonly onValueChange = output<string[] | string | undefined>();

    /**
     * The value change callback.
     */
    private onChange?: (value: string | string[] | undefined) => void;

    /**
     * onTouch function registered via registerOnTouch (ControlValueAccessor).
     */
    protected onTouched?: () => void;

    /**
     * Toggle a value.
     * @param value The value to toggle.
     * @ignore
     */
    toggle(value: string): void {
        if (this.disabled()) {
            return;
        }

        if (this.type() === 'single') {
            this.value.set(value);
        } else {
            this.value.set(
                ((currentValue) =>
                    currentValue && Array.isArray(currentValue)
                        ? currentValue.includes(value)
                            ? currentValue.filter((v) => v !== value) // delete
                            : [...currentValue, value] // update
                        : [value])(this.value())
            );
        }

        this.onValueChange.emit(this.value());
        this.onChange?.(this.value());
    }

    /**
     * Select a value from Angular forms.
     * @param value The value to select.
     * @ignore
     */
    writeValue(value: string): void {
        this.value.set(value);
    }

    /**
     * Register a callback to be called when the value changes.
     * @param fn The callback to register.
     * @ignore
     */
    registerOnChange(fn: (value: string | string[] | undefined) => void): void {
        this.onChange = fn;
    }

    /**
     * Register a callback to be called when the toggle group is touched.
     * @param fn The callback to register.
     * @ignore
     */
    registerOnTouched(fn: () => void): void {
        this.onTouched = fn;
    }

    private readonly accessorDisabled = signal(false);

    /**
     * Set the disabled state of the toggle group.
     * @param isDisabled Whether the toggle group is disabled.
     * @ignore
     */
    setDisabledState(isDisabled: boolean): void {
        this.accessorDisabled.set(isDisabled);
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle-group/src/toggle-group.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, Directive, input, model, output, signal } from '@angular/core';
import { ControlValueAccessor } from '@angular/forms';
import { provideToken, provideValueAccessor } from '@radix-ng/primitives/core';
import { RdxRovingFocusGroupDirective } from '@radix-ng/primitives/roving-focus';
import { RdxToggleGroupToken } from './toggle-group.token';

let nextId = 0;

/**
 * @group Components
 */
@Directive({
    selector: '[rdxToggleGroup]',
    exportAs: 'rdxToggleGroup',
    providers: [
        provideToken(RdxToggleGroupToken, RdxToggleGroupDirective),
        provideValueAccessor(RdxToggleGroupDirective)],
    hostDirectives: [{ directive: RdxRovingFocusGroupDirective, inputs: ['dir', 'orientation', 'loop'] }],
    host: {
        role: 'group',

        '(focusout)': 'onTouched?.()'
    }
})
export class RdxToggleGroupDirective implements ControlValueAccessor {
    /**
     * @ignore
     */
    readonly id: string = `rdx-toggle-group-${nextId++}`;

    /**
     * @group Props
     */
    readonly value = model<string | string[] | undefined>(undefined);

    /**
     * @group Props
     */
    readonly type = input<'single' | 'multiple'>('single');

    /**
     * Whether the toggle group is disabled.
     * @defaultValue false
     * @group Props
     */
    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * Event emitted when the selected toggle button changes.
     * @group Emits
     */
    readonly onValueChange = output<string[] | string | undefined>();

    /**
     * The value change callback.
     */
    private onChange?: (value: string | string[] | undefined) => void;

    /**
     * onTouch function registered via registerOnTouch (ControlValueAccessor).
     */
    protected onTouched?: () => void;

    /**
     * Toggle a value.
     * @param value The value to toggle.
     * @ignore
     */
    toggle(value: string): void {
        if (this.disabled()) {
            return;
        }

        if (this.type() === 'single') {
            this.value.set(value);
        } else {
            this.value.set(
                ((currentValue) =>
                    currentValue && Array.isArray(currentValue)
                        ? currentValue.includes(value)
                            ? currentValue.filter((v) => v !== value) // delete
                            : [...currentValue, value] // update
                        : [value])(this.value())
            );
        }

        this.onValueChange.emit(this.value());
        this.onChange?.(this.value());
    }

    /**
     * Select a value from Angular forms.
     * @param value The value to select.
     * @ignore
     */
    writeValue(value: string): void {
        this.value.set(value);
    }

    /**
     * Register a callback to be called when the value changes.
     * @param fn The callback to register.
     * @ignore
     */
    registerOnChange(fn: (value: string | string[] | undefined) => void): void {
        this.onChange = fn;
    }

    /**
     * Register a callback to be called when the toggle group is touched.
     * @param fn The callback to register.
     * @ignore
     */
    registerOnTouched(fn: () => void): void {
        this.onTouched = fn;
    }

    private readonly accessorDisabled = signal(false);
    /**
     * Set the disabled state of the toggle group.
     * @param isDisabled Whether the toggle group is disabled.
     * @ignore
     */
    setDisabledState(isDisabled: boolean): void {
        this.accessorDisabled.set(isDisabled);
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toggle-group/src/toggle-group.token.ts
```typescript
import { inject, InjectionToken } from '@angular/core';

export interface IRdxToggleGroup {
    toggle(value: string): void;
    disabled: any;
    value: any;
    type: any;
}

export const RdxToggleGroupToken = new InjectionToken<IRdxToggleGroup>('RdxToggleGroupToken');

export function injectToggleGroup(): IRdxToggleGroup {
    return inject(RdxToggleGroupToken);
}

```
