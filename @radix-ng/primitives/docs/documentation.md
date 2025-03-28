# ./components/label.mdx

---
title: Label
slug: label
section: components
description: .
---

# Label

<Description>Renders an accessible label associated with controls.</Description>

<ComponentPreview name="label" file="label-demo" />

<FeatureList items={['Text selection is prevented when double-clicking label.']} />

## Installation

Get started with importing the directive:

```typescript
import { RdxLabelDirective } from '@radix-ng/primitives/label';
```

## Anatomy

Import all parts and piece them together.

```html
<label rdxLabel htmlFor="firstName">First Name</label>
```

## API Reference

### Label
`RdxLabelDirective`
<PropsTable name="RdxLabelDirective" />


## Accessibility
This component is based on the native `label` element, it will automatically apply the correct labelling when wrapping controls
or using the `htmlFor` attribute. For your own custom controls to work correctly,
ensure they use native elements such as `button` or `input` as a base.



# ./components/accordion.mdx

---
title: Accordion
slug: accordion
section: components
description: .
---

# Accordion
<Description>
    {"A vertically stacked set of interactive headings that each reveal an associated section of content."}
</Description>

<ComponentPreview name="accordion" file="accordion-demo" />


[//]: # (<ComponentPreview name="accordion" file="accordion-multiple-demo" />)

<FeatureList items={[
    'Full keyboard navigation.',
    'Supports horizontal/vertical orientation.',
    'Supports Right to Left direction.',
    'Can expand one or multiple items.',
    'Can be controlled or uncontrolled.'
]}/>

## API Reference

### Root
<PropsTable name="RdxAccordionRootDirective" />

<EmitsTable name="RdxAccordionRootDirective" />

<DataAttributesTable attributes={[
    { name: '[data-orientation]', value: '"vertical" | "horizontal"' }]
} />


### Item
Contains all the parts of a collapsible section.

<PropsTable name="RdxAccordionItemDirective" />

<DataAttributesTable attributes={[
    { name: '[data-state]', value: '"open" | "closed"' },
    { name: '[data-disabled]', value: 'Present when disabled' },
    { name: '[data-orientation]', value: '"vertical" | "horizontal"' }
]} />

### Header

Wraps an `rdxAccordionTrigger`.
<DataAttributesTable attributes={[
    { name: '[data-state]', value: '"open" | "closed"' },
    { name: '[data-disabled]', value: 'Present when disabled' },
    { name: '[data-orientation]', value: '"vertical" | "horizontal"' }
]} />

### Trigger

Toggles the collapsed state of its associated item. It should be nested inside an `rdxAccordionHeader`.
<DataAttributesTable attributes={[
    { name: '[data-state]', value: '"open" | "closed"' },
    { name: '[data-disabled]', value: 'Present when disabled' },
    { name: '[data-orientation]', value: '"vertical" | "horizontal"' }
]} />

### Content

Contains the collapsible content for an item.
<DataAttributesTable attributes={[
    { name: '[data-state]', value: '"open" | "closed"' },
    { name: '[data-disabled]', value: 'Present when disabled' },
    { name: '[data-orientation]', value: '"vertical" | "horizontal"' }
]} />

<CSSVariablesTable attributes={[
    { name: '--radix-accordion-content-width', value: 'The width of the content when it opens/closes' },
    { name: '--radix-accordion-content-height', value: 'The height of the content when it opens/closes' }
]} />



# ./components/aspect-ratio.mdx

---
title: Aspect Ratio
slug: aspect-ratio
section: components
description: .
---

# Aspect Ratio
<Description>Displays content within a desired ratio.</Description>

<ComponentPreview name="aspect-ratio" file="aspect-ratio-demo" />

<FeatureList items={['Accepts any custom ratio.']}/>

## Anatomy

```html
<div rdxAspectRatio>
    <img />
</div>
```

## API Reference

### Root
Contains the content you want to constrain to a given ratio.

`RdxAspectRatioDirective`
<PropsTable name="RdxAspectRatioDirective" />



# ./components/progress.mdx

---
title: Progress
slug: progress
section: components
description: .
---
import { attrDataRoot, attrDataIndicator } from '../../../demos/primitives/progress/attrs.js';

# Progress

<Description>Displays an indicator showing the completion progress of a task, typically displayed as a progress bar.</Description>

<ComponentPreview name="progress" file="progress-demo" />

<FeatureList items={['Provides context for assistive technology to read the progress of a task.']} />

## Installation

Get started with importing the directive:

```typescript
import { RdxProgressIndicatorDirective, RdxProgressRootDirective } from '@radix-ng/primitives/progress';
```

## API Reference

### Root
`RdxProgressRootDirective`
<PropsTable name="RdxProgressRootDirective" />

<DataAttributesTable attributes={attrDataRoot} />

### Indicator
`RdxProgressIndicatorDirective`
Used to show the progress visually. It also makes progress accessible to assistive technologies.

<DataAttributesTable attributes={attrDataIndicator} />


## Accessibility



# ./components/slider.mdx

---
title: Slider
slug: slider
section: components
description: .
---

# Slider

<Description>An input where the user selects a value from within a given range.</Description>

<ComponentPreview name="slider" file="slider-demo" />

<FeatureList items={[
    'Can be controlled or uncontrolled.',
    'Supports multiple thumbs.',
    'Supports a minimum value between thumbs.',
    'Supports touch or click on track to update value.',
    'Supports Right to Left direction.',
    'Full keyboard navigation.'
]} />

## Anatomy

```html
<rdx-slider>
    <rdx-slider-track>
        <rdx-slider-range />
    </rdx-slider-track>
    <rdx-slider-thumb />
</rdx-slider>
```

## API Reference

### Root
`RdxSliderRootComponent`

<PropsTable name="RdxSliderRootComponent" />

<EmitsTable name="RdxSliderRootComponent" />

<DataAttributesTable attributes={[
    { name: '[data-disabled]', value: 'Present when disabled' },
    { name: '[data-orientation]', value: '"vertical" | "horizontal"' }
]} />

### Track
`RdxSliderTrackComponent`

The track that contains the `SliderRange`.

<DataAttributesTable attributes={[
    { name: '[data-disabled]', value: 'Present when disabled' },
    { name: '[data-orientation]', value: '"vertical" | "horizontal"' }
]} />

### Range
`RdxSliderRangeComponent`

The range part. Must live inside `SliderTrack`.


<DataAttributesTable attributes={[
    { name: '[data-disabled]', value: 'Present when disabled' },
    { name: '[data-orientation]', value: '"vertical" | "horizontal"' }
]} />

### Thumb
`RdxSliderThumbComponent`

A draggable thumb. You can render multiple thumbs.


<DataAttributesTable attributes={[
    { name: '[data-disabled]', value: 'Present when disabled' },
    { name: '[data-orientation]', value: '"vertical" | "horizontal"' }
]} />

## Accessibility
Adheres to the [Slider WAI-ARIA design pattern](https://www.w3.org/WAI/ARIA/apg/patterns/slider-multithumb).

### Keyboard Interactions

<KeyboardTable attributes={[
    {
        key: 'Home',
        description: 'Sets the value to its minimum.',
    },
    {
        key: 'End',
        description: 'Sets the value to its maximum.',
    },
    {
        key: 'PageDown',
        description: ' Decreases the value by a larger step.',
    },
    {
        key: 'PageUP',
        description: ' Increases the value by a larger step.',
    },
    {
        key: 'ArrowDown',
        description: ' Decreases the value by the step amount.',
    },
    {
        key: 'ArrowRight',
        description: 'Increments/decrements by the step value depending on orientation.',
    },
    {
        key: 'ArrowUp',
        description: ' Increases the value by the step amount.',
    },
    {
        key: 'ArrowLeft',
        description: ' Increments/decrements by the step value depending on orientation. ',
    },
    {
        key: 'Shift + ArrowUp',
        description: ' Increases the value by a larger step.',
    },
    {
        key: 'Shift + ArrowDown',
        description: '  Decreases the value by a larger step.',
    }
]} />



# ./components/toggle.mdx

---
title: Toggle
slug: toggle
section: components
description: .
---

# Toggle

<Description>A two-state button that can be either on or off.</Description>

<ComponentPreview name="toggle" file="toggle-demo" />

<FeatureList items={['Full keyboard navigation.', 'Can be controlled or uncontrolled.']} />

## Anatomy

```html
<button rdxToggle aria-label="Toggle italic">
  <icon />
</button>
```

## API Reference

### Root

`RdxToggleDirective`

The toggle.

<PropsTable name="RdxToggleDirective" />

## Accessibility

### Keyboard Interactions

<KeyboardTable attributes={[
    { key: 'Space', description: 'Activates/deactivates the toggle.' },
    { key: 'Enter', description: 'Activates/deactivates the toggle.' }
]} />



# ./components/separator.mdx

---
title: Separator
slug: separator
section: components
description: .
---

# Separator

<Description>Visually or semantically separates content.</Description>

<ComponentPreview name="separator" file="separator-demo" />

<FeatureList items={['Supports horizontal and vertical orientations.']} />

## Anatomy

```html
<div rdxSeparatorRoot></div>
```

## API Reference

### Root

The separator.
`RdxSeparatorRootDirective`
<PropsTable name="RdxSeparatorRootDirective" />



# ./components/collapsible.mdx

---
title: Collapsible
slug: collapsible
section: components
description: .
---
import { attrDataContent, attrDataRoot, attrDataTrigger } from '../../../demos/primitives/collapsible/attrs';

# Collapsible

<Description>An interactive component which expands/collapses a panel.</Description>


<ComponentPreview name="collapsible" file="collapsible-demo" />

## API Reference

### Root
Contains all the parts of a collapsible.

<PropsTable name="RdxCollapsibleRootDirective" />

<EmitsTable name="RdxCollapsibleRootDirective" />

<DataAttributesTable attributes={attrDataRoot} />

### Trigger
The button that toggles the collapsible.

<DataAttributesTable attributes={attrDataTrigger} />

### Content
The component that contains the collapsible content.

<DataAttributesTable attributes={attrDataContent} />

## Accessibility
Adheres to the [Disclosure WAI-ARIA design pattern](https://www.w3.org/WAI/ARIA/apg/patterns/disclosure).



# ./components/checkbox.mdx

---
title: Checkbox
slug: checkbox
section: components
description: A control that allows the user to toggle between checked and not checked.
---

# Checkbox

<Description>A control that allows the user to toggle between checked and not checked.</Description>

<ComponentPreview name="checkbox" file="checkbox-demo" />

## Features

<FeatureList items={[
    'Full keyboard navigation.',
    'Supports indeterminate \_state.',
    'Can be controlled or uncontrolled.'
]} />

## Anatomy

```html
<button rdxCheckboxRoot [(checked)]="checked">
  <lucide-angular rdxCheckboxIndicator name="check" />
  <input rdxCheckboxInput type="checkbox" />
</button>
```

## API Reference

### Root
`RdxCheckboxDirective`

<PropsTable name="RdxCheckboxDirective" />

<DataAttributesTable attributes={[
    { name: '[data-state]', value: '"checked" | "unchecked" | "indeterminate"' },
    { name: '[data-disabled]', value: 'Present when disabled' }
]} />

## Indicator
`RdxCheckboxIndicator`

Renders when the checkbox is in a checked or indeterminate state.
You can style this element directly, or you can use it as a wrapper to put an icon into, or both.

<DataAttributesTable attributes={[
    { name: '[data-state]', value: '"checked" | "unchecked" | "indeterminate"' },
    { name: '[data-disabled]', value: 'Present when disabled' }
]} />

## Input
`RdxCheckboxInput`


## Accessibility

Adheres to the [tri-\_state Checkbox WAI-ARIA design pattern](https://www.w3.org/WAI/ARIA/apg/patterns/checkbox).

### Keyboard Interactions

<KeyboardTable attributes={[
    { key: 'Space', description: 'Checks/unchecks the checkbox.' }
]} />



# ./components/select.mdx

---
title: Select
slug: select
section: components
description: .
---

# Select

<Description>Displays a list of options for the user to pick from—triggered by a button.</Description>

<ComponentPreview name="select" file="select-demo" />

<FeatureList items={[
    'Can be controlled or uncontrolled.',
    'Supports items, labels, groups of items.',
    'Focus is fully managed.',
    'Full keyboard navigation.'
]} />

## Anatomy

```html
<div rdxSelectRoot>
    <div rdxSelectContent>
        <div rdxSelectItem></div>
    </div>
</div>
```

## API Reference

### Root



# ./components/dropdown-menu.mdx

---
title: DropdownMenu
slug: dropdown-menu
section: components
description: .
---

import {
    attrDataTrigger
} from '../../../demos/primitives/dropdown-menu/attrs';

# Dropdown Menu

<Description>Displays a menu to the user—such as a set of actions or functions—triggered by a button.</Description>

<ComponentPreview name="dropdown-menu" file="dropdown-menu-demo" />

## Anatomy

Import all parts and piece them together.

## API Reference

### Trigger

The button that toggles the dropdown menu.
By default, the DropdownMenu.Content will position itself against the trigger.

<PropsTable name="RdxDropdownMenuTriggerDirective" />

<DataAttributesTable attributes={attrDataTrigger} />

### Content

The component that pops out when the dropdown menu is open.

<PropsTable name="RdxDropdownMenuContentDirective" />



# ./components/toggle-group.mdx

---
title: Toggle Group
slug: toggle-group
section: components
description: A set of two-state buttons that can be toggled on or off.
---

# Toggle Group

<Description>A set of two-state buttons that can be toggled on or off.</Description>

<ComponentPreview name="toggle-group" file="toggle-group-demo" />

<FeatureList items={['Full keyboard navigation.',
    'Supports horizontal/vertical orientation.',
    'Support single and multiple pressed buttons.',
    'Can be controlled or uncontrolled.',]} />

## Import

Get started with importing the directives:

```typescript
import {
  RdxToggleGroupDirective,
  RdxToggleGroupItemDirective
} from '@radix-ng/primitives/toggle-group';
```

## Anatomy

```html
<div rdxToggleGroup>
  <button rdxToggleGroupItem></button>
  <button rdxToggleGroupItem></button>
  <button rdxToggleGroupItem></button>
</div>
```

## API Reference

### Root

`RdxToggleGroupDirective`

Contains all the parts of a toggle group.

<PropsTable name="RdxToggleGroupDirective" />

<DataAttributesTable attributes={[
    {
        name: '[data-orientation]',
        value: '"vertical" | "horizontal"'
    },
]} />

### Item

`RdxToggleGroupItemDirective`

An item in the group.

<PropsTable name="RdxToggleGroupItemDirective" />

<DataAttributesTable attributes={[
    {
        name: '[data-state]',
        value: '"on" | "off"'
    },
    {
        name: '[data-disabled]',
        value: 'Present when disabled',
    },
    {
        name: '[data-orientation]',
        value: '"vertical" | "horizontal"'
    },
]} />

## Accessibility

Uses [roving tabindex](https://www.w3.org/TR/wai-aria-practices-1.2/examples/radio/radio.html) to manage focus movement among items.

### Keyboard Interactions

<KeyboardTable attributes={[
    {
        key: 'Tab',
        description:
            'Moves focus to either the pressed item or the first item in the group.',
    },
    {
        key: 'Space',
        description: 'Activates/deactivates the item.',
    },
    {
        key: 'Enter',
        description: 'Activates/deactivates the item.',
    },
    {
        key: 'ArrowDown',
        description: 'Moves focus to the next item in the group.',
    },
    {
        key: 'ArrowRight',
        description: 'Moves focus to the next item in the group.',
    },
    {
        key: 'ArrowUp',
        description: 'Moves focus to the previous item in the group.',
    },
    {
        key: 'ArrowLeft',
        description: 'Moves focus to the previous item in the group.',
    },
    {
        key: 'Home',
        description: 'Moves focus to the first item.',
    },
    {
        key: 'End',
        description: 'Moves focus to the last item.',
    },
]} />



# ./components/switch.mdx

---
title: Switch
slug: switch
section: components
description: .
---

# Switch

<Description>A control that allows the user to toggle between checked and not checked.</Description>

<ComponentPreview name="switch" file="switch-demo" />

<FeatureList items={[
    'Can be controlled or uncontrolled.',
    'Full keyboard navigation.'
]} />

## Anatomy

```html
<button rdxSwitchRoot>
    <input rdxSwitchInput />
    <span rdxSwitchThumb></span>
</button>
```

## API Reference

### Root
`RdxSwitchRootDirective`

Contains all the parts of a switch. An `input` will also render when used within a `form` to ensure events propagate correctly.
<PropsTable name="RdxSwitchRootDirective" />

<EmitsTable name="RdxSwitchRootDirective" />

### Input
`RdxSwitchInputDirective`
<DataAttributesTable attributes={[
    { name: '[data-state]', value: '"open" | "closed"' },
    { name: '[data-disabled]', value: 'Present when disabled' }
]} />

### Thumb
`RdxSwitchThumbDirective`

The thumb that is used to visually indicate whether the switch is on or off.
<DataAttributesTable attributes={[
    { name: '[data-state]', value: '"open" | "closed"' },
    { name: '[data-disabled]', value: 'Present when disabled' }
]} />

## Accessibility
Adheres to the [`Switch` role requirements](https://www.w3.org/WAI/ARIA/apg/patterns/switch).

### Keyboard Interactions



# ./components/dialog.mdx

---
title: Dialog
slug: dialog
section: components
description: .
---

# Dialog

<Description>A window overlaid on either the primary window or another dialog window, rendering the content underneath inert.</Description>

<ComponentPreview name="dialog" file="dialog-demo" />

<FeatureList items={[
    'Supports modal and non-modal modes.',
    'Focus is automatically trapped when modal.',
    'Can be controlled or uncontrolled.',
    'Esc closes the component automatically.'
]} />


## Installation

### Provider

The initial configuration is defined by the `provideRdxDialogConfig` provider during application startup.

```typescript
import { ApplicationConfig } from '@angular/core';
import { provideRdxDialogConfig } from '@radix-ng/primitives/dialog';

export const appConfig: ApplicationConfig = {
    providers: [
        provideRdxDialogConfig()
    ]
};
```

In the component that will open the dialog, call `provideRdxDialog` in the providers:
```typescript

import { provideRdxDialog } from '@radix-ng/primitives/dialog';

@Component({
  selector: 'app-dialog-component',
  providers: [provideRdxDialog()]
})
export class AppDialogComponent {}

```

## API Reference

### Trigger

<PropsTable name="RdxDialogTriggerDirective" />

<DataAttributesTable attributes={[
    { name: '[data-state]', value: '"open" | "closed"' }
]} />

### Content

<DataAttributesTable attributes={[
    { name: '[data-state]', value: '"open" | "closed"' }
]} />

## Accessibility
Adheres to the [Dialog WAI-ARIA design pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal).

## Usage

### Service

To open a dialog via the service, simply call the `RdxDialogService.open()`

```typescript
@Component({...})
export class AppComponent {
    #dialog = inject(RdxDialogService);

    openDialog() {
        const dialogRef = this.#dialog.open({
            content: MyDialogContentComponent,
        });
    }
}
```

### Inject Data to the Dialog

```typescript
this.#dialog.open({
  content: MyDialogContentComponent,
  data: { name: 'Pedro Duarte' }
});
```

This ensures all type definitions are centralized in the component.

- Use `injectDialogData` to retrieve data and let the service infer the expected data type.
- Use `injectDialogRef` to declare the return type for better typing in `DialogRef`.


```typescript
@Component({
  selector: 'app-custom-dialog'
})
export class AppCustomDialogComponent {

  readonly data = injectDialogData<{ name: string; username?: string }>();

  readonly ref = injectDialogRef<boolean>();

  close(): void {
    this.ref.close(true);
  }
}
```



# ./components/avatar.mdx

---
title: Avatar
slug: avatar
section: components
description: .
---

# Avatar

<Description>Renders an accessible label associated with controls.</Description>

<ComponentPreview name="avatar" file="avatar-demo" />

<FeatureList items={['Automatic and manual control over when the image renders.', 'Fallback part accepts any children.', 'Optionally delay fallback rendering to avoid content flashing.']} />

## Anatomy

Import all parts and piece them together.

```html
<span rdxAvatarRoot>
    <img rdxAvatarImage />
    <span rdxAvatarFallback></span>
</span>
```

## API Reference

### Image
`RdxAvatarImageDirective`

The image to render.
By default it will only render when it has loaded. You can use the `onLoadingStatusChange` handler if you need more control.

<PropsTable name="RdxAvatarImageDirective" />

<EmitsTable name="RdxAvatarImageDirective" />

### Fallback
`RdxAvatarFallbackDirective`

An element that renders when the image hasn't loaded. This means whilst it's loading, or if there was an error.
If you notice a flash during loading, you can provide a `delayMs` prop to delay its rendering
so it only renders for those with slower connections.

For more control, use the `onLoadingStatusChange` handler on `rdxAvatarImage`.
<PropsTable name="RdxAvatarFallbackDirective" />



# ./overview/inject-context.mdx

---
title: Inject Context
slug: inject-context
section: overview
description: .
---

# Inject Context

## Introduction

When building Angular applications, you often need to pass a shared context to child components without having to propagate data through multiple `@Input()` properties.

One convenient way to achieve this is by using a directive as the "context root" and an `InjectionToken` for dependency injection (DI).
This allows child components within a single DOM tree to directly access the data and signals provided by the directive.

## What is InjectionToken?

`InjectionToken<T>` is a special Angular class that creates a unique token for the DI container.
You use it when you want to inject something other than a class, such as an interface or configuration object.

```typescript
export const MY_TOKEN = new InjectionToken<string>('MyToken');
```

Here, `MyToken` is a label for debugging, and `<string>` specifies the type of data the token will provide.

## Basic Usage

1. Define the interface and token

Create an interface describing the desired "context" and an injection token that will provide it:

```typescript
import { InjectionToken } from '@angular/core';

export interface MyContext {
  value: number;
  message: string;
  increment: void;
  // ... любые другие поля/методы
}

export const MY_CONTEXT_TOKEN = new InjectionToken<MyContext>('MyContextToken');
```

2. Create a directive as the "context root"

Have the directive implement `MyContext`.
In `providers`, register the token using `useExisting`.
This means that when `MY_CONTEXT_TOKEN` is requested, the directive instance itself will be returned.

```typescript
import {
  Directive,
  forwardRef
} from '@angular/core';
import { MyContext, MY_CONTEXT_TOKEN } from './my-context';

@Directive({
  selector: '[myContext]',
  providers: [
    {
      provide: MY_CONTEXT_TOKEN,
      useExisting: forwardRef(() => MyContextDirective)
    }
  ]
})
export class MyContextDirective implements MyContext {
  value = 0;
  message = 'Hello from directive';

  increment() {
    this.value++;
  }
}
```
`forwardRef` is needed to reference the directive class before it is declared.
Without it, Angular might throw an error related to declaration order during compilation.

3. Inject the context in child components

Any component or directive placed within the element hosting `myContext` can get the directive via `MY_CONTEXT_TOKEN`:

```typescript
import { Component, inject } from '@angular/core';
import { MY_CONTEXT_TOKEN } from './my-context';

@Component({
  selector: 'child-component',
  template: `
    <p>Value: {{ context.value }}</p>
    <button (click)="increment()">Increment</button>
  `
})
export class ChildComponent {
  readonly context = inject(MY_CONTEXT_TOKEN);

  increment() {
    this.context.increment();
  }
}
```

4. Use it in a template

Attach the directive to the parent element that contains the child components:

```html
<div myContext>
  <child-component />
  <child-component />
</div>
```
Both `<child-component>` instances will now share the same context, enabling them to jointly access and modify the shared data.

## Common Use Cases

- Custom Styling: Access internal state to apply dynamic styles based on component state.
- Extended Functionality: Build upon existing component logic to add new features.
- Complex Layouts: Create intricate UI patterns by composing multiple components and sharing state between them.
- Accessibility Enhancements: Utilize internal methods and state to improve keyboard navigation or screen reader support.

## Best Practices

- Use clear names: For both the `InjectionToken` and the directive itself.
- Explicitly specify the type in the `InjectionToken` so that IDEs and TypeScript can provide better checks.
- Don’t create unnecessary tokens: If the data is only needed in one place, a simple `@Input()` might suffice.
- Keep logic in the directive: Implement not just fields but also methods for managing those fields, making it easier for child components to interact with them.
- Use `useExisting` carefully: Only when you really need to return the same directive instance. If you need a different strategy (e.g., factory pattern), use `useFactory` instead.



# ./overview/contribute.mdx

---
title: Contribute
slug: contribute
section: overview
description: .
---

# Contributing to Radix-NG

First of all, thank you for showing interest in contributing to Radix-NG!
All your contributions are extremely valuable to the project!

## Ways to contribute

- **Improve documentation:** Fix incomplete or missing docs, bad wording, examples or explanations.
- **Give feedback:** We are constantly working on making Radix-NG better. Please share how you use Radix-NG, what features are missing and what is done well via [GitHub Discussions](https://github.com/orgs/radix-ng/discussions/new/choose) or [Discord](https://discord.gg/NaJb2XRWX9).
- **Contribute to the codebase:** Propose new features via [GitHub Issues](https://github.com/radix-ng/primitives/issues/new).

## Contributing workflow

- Decide on what you want to contribute.
- If you would like to implement a new feature, discuss it with the maintainer [GitHub Discussions](https://github.com/orgs/radix-ng/discussions/new/choose) or [Discord](https://discord.gg/NaJb2XRWX9)) before jumping into coding.
- After finalizing issue details, you can begin working on the code.
- If you cannot finish your task or if you change your mind – that's totally fine! Just let us know in the GitHub issue that you created during the first step of this process. The Radix-NG community is friendly – we won't judge or ask any questions if you decide to cancel your submission.
- Your PR is merged. You are awesome ❤️!

## npm scripts

All npm scripts are located at [main package.json](https://github.com/radix-ng/primitives/blob/master/package.json).
Individual packages do not have dedicated scripts.



# ./overview/introduction.mdx

---
title: Introduction
slug: introduction
section: overview
description: .
---

# Introduction

<Description>Radix-NG is an unofficial Angular port of [Radix UI](https://www.radix-ui.com/), thus we share the same principal and vision when building primitives.</Description>

Radix Primitives is a low-level UI component library with a focus on accessibility, customization and developer experience. You can use these components either as the base layer of your design system, or adopt them incrementally.

## Vision

Most of us share similar definitions for common UI patterns like accordion, checkbox, combobox, dialog, dropdown, select, slider, and tooltip. These UI patterns are documented by WAI-ARIA and generally understood by the community.

However, the implementations provided to us by the web platform are inadequate. They're either non-existent, lacking in functionality, or cannot be customized sufficiently.

So, developers are forced to build custom components; an incredibly difficult task. As a result, most components on the web are inaccessible, non-performant, and lacking important features.

Our goal is to create a well-funded, open-source component library that the community can use to build accessible design systems.

## Angular Design Principles

- Standalone Directives
- [Directive composition API](https://angular.dev/guide/directives/directive-composition-api)
Angular directives offer a great way to encapsulate reusable behaviors— directives can apply attributes, CSS classes, and event listeners to an element.


### Dependency from

- [Angular CDK](https://material.angular.io/cdk/categories)

## Key Features

Components adhere to the [WAI-ARIA design patterns](https://www.w3.org/TR/wai-aria-practices-1.2) where possible. We handle many of the difficult implementation details related to accessibility, including aria and role attributes, focus management, and keyboard navigation. Learn more in our [accessibility](./accessibility) overview.

### Unstyled

Components ship with zero styles, giving you complete control over styling. Components can be styled with any styling solution (vanilla CSS, CSS preprocessors & etc).

### Opened

Radix Primitives are designed to be customized to suit your needs. Our open component architecture provides you granular access to each component part, so you can wrap them and add your own event listeners, props, or refs.

### Uncontrolled

Where applicable, components are uncontrolled by default but can also be controlled, alternatively. All of the behavior wiring is handled internally, so you can get up and running as smoothly as possible, without needing to create any local states.

## Community

### Discord

To get involved to community, ask questions, and share tips.

[Join our Discord](https://discord.gg/NaJb2XRWX9)

### GitHub

To file issues, request features, and contribute, check out our GitHub.

[GitHub repo](https://github.com/radix-ng/primitives)

## Credits

All credits go to these open-source works and resources, on which this solution is based:

-   [Radix UI](https://radix-ui.com) (MIT License)
-   [Radix Vue](https://radix-vue.com) (MIT License)
-   [Radix Svelte](https://radix-svelte.com) (MIT License)
-   [Spartan UI](https://www.spartan.ng/) (MIT License)
-   [NG Primitives](https://ng-primitives.mintlify.app) (CC BY-ND 4.0)



# ./overview/getting-started.mdx

---
title: Getting started
slug: getting-started
section: overview
description: .
---

# Getting started

<Description>A quick tutorial to get you up and running with Radix Primitives.</Description>

## Implementing a Label
In this quick tutorial, we will install and style the [Label](/primitives/components/label) primitive.

### 1. Install the primitive package

```bash
npm install @radix-ng/primitives @angular/cdk
```

### 2. Import the parts

Import and structure the parts.


```typescript
import { Component } from '@angular/core';
import { bootstrapApplication } from '@angular/platform-browser';

import 'zone.js';

import { RdxLabelRootDirective } from '@radix-ng/primitives/label';

@Component({
    selector: 'app-root',
    standalone: true,
    imports: [RdxLabelRootDirective],
    template: `
        <h1>Hello from {{ name }}!</h1>
        <a target="_blank" href="https://angular.dev/overview">Learn more about Angular</a>
        <div>
            <label LabelRoot htmlFor="uniqId">First Name</label>
            <input type="text" class="Input" id="uniqId" />
        </div>
    `
})
export class App {
    name = 'Angular';
}

bootstrapApplication(App);
```

### 3. Add your styles
Add styles where desired.

```typescript {13-20, 9}
@Component({
    selector: 'app-root',
    standalone: true,
    imports: [RdxLabelRootDirective],
    template: `
        <h1>Hello from {{ name }}!</h1>
        <a target="_blank" href="https://angular.dev/overview">Learn more about Angular</a>
        <div>
            <label LabelRoot class="Label" htmlFor="uniqId">First Name</label>
            <input type="text" class="Input" id="uniqId" />
        </div>
    `,
    styles: `
        .Label {
            color: white;
            font-size: 15px;
            line-height: 35px;
            font-weight: 500;
        }
    `
})
```

## Summary

The steps above outline briefly what's involved in using a Radix Primitive in your application.

These components are low-level enough to give you control over how you want to wrap them. You're free to introduce your own high-level API to better suit the needs of your team and product.



# ./overview/styling.mdx

---
title: Styling
slug: styling
section: overview
description: description
---

# Styling
<Description>Learn how to style RadixNG.</Description>

<p>RadixNG are unstyled and compatible with any styling solution giving you complete control over styling.</p>

## Overview

### Classes

All components accept class attributes, just like regular Angular component. This class will be passed to the `host:`.

For some `primitives` based on `@Components`, the `className` property is used and applied to the child element of the component.

### Data attributes

When components are stateful, their state will be exposed in a `data-state` attribute.

For example, when an **Accordion Item** is opened, it includes a `data-state="open"` attribute.

## Styling with CSS

### Styling a part

You can style a component part by targeting the `class` that you provide.

```html
<div [defaultValue]="'item-1'" rdxAccordionRoot>
  <div class="AccordionItem" [value]="'item-1'" rdxAccordionItem>
    <!-- ... -->
  </div>
</div>

<style>
.AccordionItem {
  /* ... */
}
</style>
```

### Styling a state
You can style a component state by targeting its `data-state` attribute.

```css
.AccordionItem {
  border-bottom: 1px solid gainsboro;
}

.AccordionItem[data-state="open"] {
  border-bottom-width: 2px;
}
```

## Styling with Tailwind CSS

The examples below are using [Tailwind CSS](https://tailwindcss.com/), but you can use any library of your choice.

### Styling a part
You can style a component part by targeting the `class`.

```html
<div [defaultValue]="'item-1'" rdxAccordionRoot>
  <div class="border border-gray-400 rounded-2xl" [value]="'item-1'" rdxAccordionItem>
    <!-- ... -->
  </div>
</div>
```

### Styling a state

With Tailwind CSS's powerful variant selector, you can style a component state by targeting its `data-state` attribute.

```html
<div [defaultValue]="'item-1'" rdxAccordionRoot>
  <div class="
        border border-gray-400 rounded-2xl
        data-[state=open]:border-b-2 data-[state=open]:border-gray-800
      " [value]="'item-1'" rdxAccordionItem>
    <!-- ... -->
  </div>
</div>
```

## Extending a primitive

Extending a primitive is done the same way you extend any **Angular** component.

### Host Directive
One of the best ways is to use `hostDirectives`.

```typescript
import { Directive } from '@angular/core';
import { RdxLabelDirective } from '@radix-ng/primitives/label';

@Directive({
    hostDirectives: [RdxLabelDirective],
    selector: '[myLabel]',
    standalone: true
})
export class MyLabelDirective {}
```

### Components

```typescript
import { Component } from '@angular/core';
import { RdxLabelDirective } from '@radix-ng/primitives/label';

@Component({
    hostDirectives: [RdxLabelDirective],
    selector: 'my-label',
    standalone: true,
    template: `
        <ng-content />
    `
})
export class MyLabelDirective {}
```



# ./overview/accessibility.mdx

---
title: Accessibility
slug: accessibility
section: overview
description: .
---

# Accessibility

<Description>Radix Primitives follow the WAI-ARIA authoring practices guidelines and are tested in a wide selection of modern browsers and commonly used assistive technologies.</Description>

We take care of many of the difficult implementation details related to accessibility,
including `aria` and `role` attributes, focus management, and keyboard navigation.
That means that users should be able to use our components as-is in most contexts and rely on functionality to follow the expected accessibility design patterns.

## WAI-ARIA

[WAI-ARIA](https://www.w3.org/TR/wai-aria-1.2/), published and maintained by the W3C,
specifies the semantics for many common UI patterns that show up in Radix Primitives.
This is designed to provide meaning for controls that aren't built using elements provided by the browser.
For example, if you use a `div` instead of a `button` element to create a button,
there are attributes you need to add to the `div` in order to convey that it's a button for screen readers or voice recognition tools.

In addition to semantics, there are behaviors that are expected from different types of components.
A `button` element is going to respond to certain interactions in ways that a `div` will not, so it's up to the developer to reimplement those interactions with JavaScript. The [WAI-ARIA authoring practices](https://www.w3.org/TR/wai-aria-practices-1.2/) provide additional guidance for implementing behaviors for various controls that come with Radix Primitives.

## Accessible Labels

With many built-in form controls, the native HTML `label` element is designed to provide semantic meaning and context for corresponding `input` elements. For non-form control elements, or for custom controls like those provided by Radix Primitives, [WAI-ARIA provides a specification](https://www.w3.org/TR/wai-aria-1.2/#namecalculation) for how to provide accessible names and descriptions to those controls.

Where possible, Radix Primitives include abstractions to make labelling our controls simple. The [`Label`](../components/label) primitive is designed to work with many of our controls. Ultimately it's up to you to provide those labels so that users have the proper context when navigating your application.

## Keyboard Navigation

Many complex components, like [`Tabs`](../components/tabs) and [`Dialog`](../components/dialog),
come with expectations from users on how to interact with their content using a keyboard or other non-mouse input modalities.

Primitives provide basic keyboard support in accordance with the [WAI-ARIA authoring practices.](https://www.w3.org/TR/wai-aria-practices-1.2/)

## Focus Management

Proper keyboard navigation and good labelling often go hand-in-hand with managing focus.
When a user interacts with an element and something changes as a result, it's often helpful to move focus
with the interaction so that the next tab stop is logical depending on the new context of the app.
And for screen reader users, moving focus often results in an announcement to convey this new context, which relies on proper labelling.

In many Radix Primitives, we move focus based on the interactions a user normally takes in a given component.
