/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tabs/index.ts
```typescript
import { NgModule } from '@angular/core';
import { RdxTabsContentDirective } from './src/tabs-content.directive';
import { RdxTabsListDirective } from './src/tabs-list.directive';
import { RdxTabsRootDirective } from './src/tabs-root.directive';
import { RdxTabsTriggerDirective } from './src/tabs-trigger.directive';

export * from './src/tabs-content.directive';
export * from './src/tabs-list.directive';
export * from './src/tabs-root.directive';
export * from './src/tabs-trigger.directive';

const tabsImports = [
    RdxTabsRootDirective,
    RdxTabsContentDirective,
    RdxTabsListDirective,
    RdxTabsTriggerDirective
];

@NgModule({
    imports: [...tabsImports],
    exports: [...tabsImports]
})
export class RdxTabsModule {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tabs/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tabs/stories/tabs.docs.mdx
````
import { ArgTypes, Canvas, Markdown, Meta } from '@storybook/blocks';
import * as TabsStories from './tabs.stories';
import { RdxTabsRootDirective } from '../src/tabs-root.directive';
import { RdxTabsTriggerDirective } from '../src/tabs-trigger.directive';
import { RdxTabsContentDirective } from '../src/tabs-content.directive';

<Meta title="Primitives/Tabs" />

# Tabs

#### A set of layered sections of content—known as tab panels—that are displayed one at a time.

<Canvas sourceState="hidden" of={TabsStories.Default} />

## Features

- ✅ Can be controlled or uncontrolled.
- ✅ Supports horizontal/vertical orientation.
- ✅ Full keyboard navigation.

## Import

Get started with importing the directives:

```typescript
import {
    RdxTabsRootDirective,
    RdxTabsListDirective,
    RdxTabsTriggerDirective,
    RdxTabsContentDirective } from '@radix-ng/primitives/tabs';
```

## Anatomy

```html
<div rdxTabsRoot>
    <div rdxTabsList>
        <button rdxTabsTrigger></button>
        <button rdxTabsTrigger></button>
        <button rdxTabsTrigger></button>
    </div>
    <div rdxTabsContent></div>
    <div rdxTabsContent></div>
    <div rdxTabsContent></div>
</div>
```

## API Reference

### TabsRoot

`RdxTabsRootDirective`

<ArgTypes of={RdxTabsRootDirective} />

### TabsList

`RdxTabsListDirective`

<Markdown>
    {`
| Data attribute | Value          |
|----------------|----------------|
| [data-orientation]   | <code>"vertical" | "horizontal"</code>
`}
</Markdown>

### TabsTrigger

`RdxTabsTriggerDirective`

<ArgTypes of={RdxTabsTriggerDirective} />

### TabsContent

`RdxTabsContentDirective`

<ArgTypes of={RdxTabsContentDirective} />

## Accessibility

Adheres to the [Tabs WAI-ARIA design pattern](https://www.w3.org/WAI/ARIA/apg/patterns/tabs).

### Keyboard Interactions

**Screen Reader**

Tabs container is defined with the **tablist** role, as any attribute is passed to the container element **aria-labelledby** can be
optionally used to specify an element to describe the Tabs. Each tab header has a **tab** role along with **aria-selected**
state attribute and **aria-controls** to refer to the corresponding tab content element.

The content element of each tab has **tabpanel** role, an id to match the **aria-controls** of the header and **aria-labelledby**
reference to the header as the accessible name.

<Markdown>
    {`
  | Key | Description |
  | ----------- | --------- |
  | Tab       | When focus moves onto the tabs, focuses the active trigger. When a trigger is focused, moves focus to the active content.        |
  | ArrowDown       | Moves focus to the next trigger depending on **orientation** and activates its associated content.    |
  | ArrowRight | Moves focus to the next trigger depending on **orientation** and activates its associated content. |
  | ArrowUp | Moves focus to the previous trigger depending on **orientation** and activates its associated content. |
  | ArrowLeft | Moves focus to the previous trigger depending on **orientation** and activates its associated content. |
  | Home | Moves focus to the first trigger and activates its associated content. |
  | End | Moves focus to the last trigger and activates its associated content. |
  `}
</Markdown>

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tabs/stories/tabs.stories.ts
```typescript
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { RdxTabsContentDirective } from '../src/tabs-content.directive';
import { RdxTabsListDirective } from '../src/tabs-list.directive';
import { RdxTabsRootDirective } from '../src/tabs-root.directive';
import { RdxTabsTriggerDirective } from '../src/tabs-trigger.directive';

const html = String.raw;

export default {
    title: 'Primitives/Tabs',
    decorators: [
        moduleMetadata({
            imports: [
                RdxTabsRootDirective,
                RdxTabsListDirective,
                RdxTabsTriggerDirective,
                RdxTabsContentDirective
            ]
        }),
        componentWrapperDecorator(
            (story) => html`
                <div class="radix-themes light light-theme" data-radius="medium" data-scaling="100%">
                    ${story}
                    <style>
                        /* reset */
                        button,
                        fieldset,
                        input {
                            all: unset;
                        }

                        .TabsRoot {
                            display: flex;
                            flex-direction: column;
                            width: 300px;
                            box-shadow: 0 2px 10px var(--black-a4);
                        }

                        .TabsList {
                            flex-shrink: 0;
                            display: flex;
                            border-bottom: 1px solid var(--mauve-6);
                        }

                        .TabsTrigger {
                            font-family: inherit;
                            background-color: white;
                            padding: 0 20px;
                            height: 45px;
                            flex: 1;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 15px;
                            line-height: 1;
                            color: var(--mauve-11);
                            user-select: none;
                        }
                        .TabsTrigger:first-child {
                            border-top-left-radius: 6px;
                        }
                        .TabsTrigger:last-child {
                            border-top-right-radius: 6px;
                        }
                        .TabsTrigger:hover {
                            color: var(--violet-11);
                        }
                        .TabsTrigger[data-state='active'] {
                            color: var(--violet-11);
                            box-shadow:
                                inset 0 -1px 0 0 currentColor,
                                0 1px 0 0 currentColor;
                        }
                        .TabsTrigger:focus {
                            position: relative;
                            box-shadow: 0 0 0 2px black;
                        }

                        .TabsContent {
                            flex-grow: 1;
                            padding: 20px;
                            background-color: white;
                            border-bottom-left-radius: 6px;
                            border-bottom-right-radius: 6px;
                            outline: none;
                        }
                        .TabsContent:focus {
                            box-shadow: 0 0 0 2px black;
                        }

                        .Text {
                            margin-top: 0;
                            margin-bottom: 20px;
                            color: var(--mauve-11);
                            font-size: 15px;
                            line-height: 1.5;
                        }

                        .Fieldset {
                            margin-bottom: 15px;
                            width: 100%;
                            display: flex;
                            flex-direction: column;
                            justify-content: flex-start;
                        }

                        .Label {
                            font-size: 13px;
                            line-height: 1;
                            margin-bottom: 10px;
                            color: var(--violet-12);
                            display: block;
                        }

                        .Input {
                            flex: 1 0 auto;
                            border-radius: 4px;
                            padding: 0 10px;
                            font-size: 15px;
                            line-height: 1;
                            color: var(--violet-11);
                            box-shadow: 0 0 0 1px var(--violet-7);
                            height: 35px;
                        }
                        .Input:focus {
                            box-shadow: 0 0 0 2px var(--violet-8);
                        }

                        .Button {
                            display: inline-flex;
                            align-items: center;
                            justify-content: center;
                            border-radius: 4px;
                            padding: 0 15px;
                            font-size: 15px;
                            line-height: 1;
                            font-weight: 500;
                            height: 35px;
                        }
                        .Button.green {
                            background-color: var(--green-4);
                            color: var(--green-11);
                        }
                        .Button.green:hover {
                            background-color: var(--green-5);
                        }
                        .Button.green:focus {
                            box-shadow: 0 0 0 2px var(--green-7);
                        }

                        h2,
                        p {
                            color: #ffffff;
                        }

                        section {
                            width: 500px;
                        }
                    </style>
                </div>
            `
        )
    ]
} as Meta;

type Story = StoryObj;

export const Default: Story = {
    render: (args) => ({
        props: args,
        template: html`
            <div class="TabsRoot" rdxTabsRoot defaultValue="tab1">
                <div class="TabsList" rdxTabsList>
                    <button class="TabsTrigger" rdxTabsTrigger value="tab1">Account</button>
                    <button class="TabsTrigger" rdxTabsTrigger value="tab2">Password</button>
                </div>
                <div class="TabsContent" rdxTabsContent value="tab1">
                    <p class="Text">Make changes to your account here. Click save when you're done.</p>
                    <fieldset class="Fieldset">
                        <label class="Label" for="name">Name</label>
                        <input class="Input" id="name" value="Pedro Duarte" />
                    </fieldset>
                    <fieldset class="Fieldset">
                        <label class="Label" for="username">Username</label>
                        <input class="Input" id="username" value="@peduarte" />
                    </fieldset>
                    <div style="display: flex; margin-top: 20px; justify-content: flex-end; ">
                        <button class="Button green">Save changes</button>
                    </div>
                </div>
                <div class="TabsContent" rdxTabsContent value="tab2">
                    <p class="Text">Change your password here. After saving, you'll be logged out.</p>
                    <fieldset class="Fieldset">
                        <label class="Label" for="currentPassword">Current password</label>
                        <input class="Input" id="currentPassword" type="password" />
                    </fieldset>
                    <fieldset class="Fieldset">
                        <label class="Label" for="newPassword">New password</label>
                        <input class="Input" id="newPassword" type="password" />
                    </fieldset>
                    <fieldset class="Fieldset">
                        <label class="Label" for="confirmPassword">Confirm password</label>
                        <input class="Input" id="confirmPassword" type="password" />
                    </fieldset>
                    <div style="display: flex; margin-top: 20px; justify-content: flex-end;">
                        <button class="Button green">Change password</button>
                    </div>
                </div>
            </div>
        `
    })
};

export const ActivationMode: Story = {
    render: (args) => ({
        props: args,
        template: html`
            <div class="TabsRoot" rdxTabsRoot activationMode="manual" defaultValue="tab1">
                <div class="TabsList" rdxTabsList>
                    <button class="TabsTrigger" rdxTabsTrigger value="tab1">Account</button>
                    <button class="TabsTrigger" rdxTabsTrigger value="tab2">Password</button>
                </div>
                <div class="TabsContent" rdxTabsContent value="tab1">
                    <p class="Text">Make changes to your account here. Click save when you're done.</p>
                    <fieldset class="Fieldset">
                        <label class="Label" for="name">Name</label>
                        <input class="Input" id="name" value="Pedro Duarte" />
                    </fieldset>
                    <fieldset class="Fieldset">
                        <label class="Label" for="username">Username</label>
                        <input class="Input" id="username" value="@peduarte" />
                    </fieldset>
                    <div style="display: flex; margin-top: 20px; justify-content: flex-end; ">
                        <button class="Button green">Save changes</button>
                    </div>
                </div>
                <div class="TabsContent" rdxTabsContent value="tab2">
                    <p class="Text">Change your password here. After saving, you'll be logged out.</p>
                    <fieldset class="Fieldset">
                        <label class="Label" for="currentPassword">Current password</label>
                        <input class="Input" id="currentPassword" type="password" />
                    </fieldset>
                    <fieldset class="Fieldset">
                        <label class="Label" for="newPassword">New password</label>
                        <input class="Input" id="newPassword" type="password" />
                    </fieldset>
                    <fieldset class="Fieldset">
                        <label class="Label" for="confirmPassword">Confirm password</label>
                        <input class="Input" id="confirmPassword" type="password" />
                    </fieldset>
                    <div style="display: flex; margin-top: 20px; justify-content: flex-end;">
                        <button class="Button green">Change password</button>
                    </div>
                </div>
            </div>
        `
    })
};

export const Disabled: Story = {
    render: (args) => ({
        props: args,
        template: html`
            <section>
                <h2>Disabled</h2>
                <p>Enabling disabled property of a Tab prevents user interaction.</p>
                <div class="TabsRoot" rdxTabsRoot activationMode="manual" defaultValue="tab1">
                    <div class="TabsList" rdxTabsList>
                        <button class="TabsTrigger" rdxTabsTrigger value="tab1">Account</button>
                        <button class="TabsTrigger" rdxTabsTrigger disabled value="tab2">Password</button>
                    </div>
                    <div class="TabsContent" rdxTabsContent value="tab1">
                        <p class="Text">Make changes to your account here. Click save when you're done.</p>
                        <fieldset class="Fieldset">
                            <label class="Label" for="name">Name</label>
                            <input class="Input" id="name" value="Pedro Duarte" />
                        </fieldset>
                        <fieldset class="Fieldset">
                            <label class="Label" for="username">Username</label>
                            <input class="Input" id="username" value="@peduarte" />
                        </fieldset>
                        <div style="display: flex; margin-top: 20px; justify-content: flex-end; ">
                            <button class="Button green">Save changes</button>
                        </div>
                    </div>
                    <div class="TabsContent" rdxTabsContent value="tab2">
                        <p class="Text">Change your password here. After saving, you'll be logged out.</p>
                        <fieldset class="Fieldset">
                            <label class="Label" for="currentPassword">Current password</label>
                            <input class="Input" id="currentPassword" type="password" />
                        </fieldset>
                        <fieldset class="Fieldset">
                            <label class="Label" for="newPassword">New password</label>
                            <input class="Input" id="newPassword" type="password" />
                        </fieldset>
                        <fieldset class="Fieldset">
                            <label class="Label" for="confirmPassword">Confirm password</label>
                            <input class="Input" id="confirmPassword" type="password" />
                        </fieldset>
                        <div style="display: flex; margin-top: 20px; justify-content: flex-end;">
                            <button class="Button green">Change password</button>
                        </div>
                    </div>
                </div>
            </section>
        `
    })
};

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tabs/src/tabs-content.directive.ts
```typescript
import { computed, Directive, inject, input } from '@angular/core';
import { RDX_TABS_ROOT_TOKEN } from './tabs-root.directive';
import { makeContentId, makeTriggerId } from './utils';

@Directive({
    selector: '[rdxTabsContent]',
    host: {
        role: 'tabpanel',
        tabindex: '0',
        '[id]': 'contentId()',
        '[attr.aria-labelledby]': 'triggerId()',
        '[attr.data-state]': 'selected() ? "active" : "inactive"',
        '[attr.data-orientation]': 'tabsContext.orientation()',
        '[hidden]': '!selected()'
    }
})
export class RdxTabsContentDirective {
    protected readonly tabsContext = inject(RDX_TABS_ROOT_TOKEN);

    /**
     * A unique value that associates the content with a trigger.
     */
    readonly value = input.required<string>();

    protected readonly contentId = computed(() => makeContentId(this.tabsContext.getBaseId(), this.value()));
    protected readonly triggerId = computed(() => makeTriggerId(this.tabsContext.getBaseId(), this.value()));

    protected readonly selected = computed(() => this.tabsContext.value() === this.value());
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tabs/src/tabs-list.directive.ts
```typescript
import { Directive, inject } from '@angular/core';
import { RdxRovingFocusGroupDirective } from '@radix-ng/primitives/roving-focus';
import { RDX_TABS_ROOT_TOKEN } from './tabs-root.directive';

export interface TabsListProps {
    // When true, keyboard navigation will loop from last tab to first, and vice versa.
    loop?: boolean;
}

@Directive({
    selector: '[rdxTabsList]',
    hostDirectives: [{ directive: RdxRovingFocusGroupDirective, inputs: ['dir', 'orientation', 'loop'] }],
    host: {
        role: 'tablist',
        '[attr.aria-orientation]': 'tabsContext.orientation()',
        '[attr.data-orientation]': 'tabsContext.orientation()'
    }
})
export class RdxTabsListDirective {
    protected readonly tabsContext = inject(RDX_TABS_ROOT_TOKEN);
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tabs/src/tabs-root.directive.ts
```typescript
import { Directive, InjectionToken, input, model, OnInit, output } from '@angular/core';
import { provideToken } from '@radix-ng/primitives/core';

export interface TabsProps {
    /** The value for the selected tab, if controlled */
    value?: string;
    /** The value of the tab to select by default, if uncontrolled */
    defaultValue?: string;
    /** A function called when a new tab is selected */
    onValueChange?: (value: string) => void;
    /**
     * The orientation the tabs are layed out.
     * Mainly so arrow navigation is done accordingly (left & right vs. up & down)
     * @defaultValue horizontal
     */
    orientation?: string;
    /**
     * The direction of navigation between toolbar items.
     */
    dir?: string;
    /**
     * Whether a tab is activated automatically or manually.
     * @defaultValue automatic
     * */
    activationMode?: 'automatic' | 'manual';
}

export type DataOrientation = 'vertical' | 'horizontal';

export const RDX_TABS_ROOT_TOKEN = new InjectionToken<RdxTabsRootDirective>('RdxTabsRootDirective');

@Directive({
    selector: '[rdxTabsRoot]',
    providers: [
        provideToken(RDX_TABS_ROOT_TOKEN, RdxTabsRootDirective)],
    host: {
        '[attr.data-orientation]': 'orientation()',
        '[attr.dir]': 'dir()'
    }
})
export class RdxTabsRootDirective implements OnInit {
    /**
     * The controlled value of the tab to activate. Should be used in conjunction with `onValueChange`.
     */
    readonly value = model<string>();

    readonly defaultValue = input<string>();

    /**
     * When automatic, tabs are activated when receiving focus. When manual, tabs are activated when clicked.
     */
    readonly activationMode = input<'automatic' | 'manual'>('automatic');

    /**
     * The orientation of the component.
     */
    readonly orientation = input<DataOrientation>('horizontal');

    readonly dir = input<string>('ltr');

    /**
     * Event handler called when the value changes.
     */
    readonly onValueChange = output<string>();

    ngOnInit() {
        if (this.defaultValue()) {
            this.value.set(this.defaultValue());
        }
    }

    select(value: string) {
        this.value.set(value);
        this.onValueChange.emit(value);
    }

    /** @ignore */
    getBaseId() {
        return `tabs-${Math.random().toString(36).substr(2, 9)}`;
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tabs/src/tabs-trigger.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, computed, Directive, effect, inject, input, InputSignalWithTransform } from '@angular/core';
import { RdxRovingFocusItemDirective } from '@radix-ng/primitives/roving-focus';
import { RDX_TABS_ROOT_TOKEN } from './tabs-root.directive';
import { makeContentId, makeTriggerId } from './utils';

interface TabsTriggerProps {
    // When true, prevents the user from interacting with the tab.
    disabled: InputSignalWithTransform<boolean, BooleanInput>;
}

@Directive({
    selector: '[rdxTabsTrigger]',
    hostDirectives: [
        {
            directive: RdxRovingFocusItemDirective,
            inputs: ['focusable', 'active', 'allowShiftKey']
        }
    ],

    host: {
        type: 'button',
        role: 'tab',
        '[id]': 'triggerId()',
        '[attr.aria-selected]': 'isSelected()',
        '[attr.aria-controls]': 'contentId()',
        '[attr.data-disabled]': "disabled() ? '' : undefined",
        '[disabled]': 'disabled()',
        '[attr.data-state]': "isSelected() ? 'active' : 'inactive'",
        '[attr.data-orientation]': 'tabsContext.orientation()',
        '(mousedown)': 'onMouseDown($event)',
        '(keydown)': 'onKeyDown($event)',
        '(focus)': 'onFocus()'
    }
})
export class RdxTabsTriggerDirective implements TabsTriggerProps {
    private readonly rdxRovingFocusItemDirective = inject(RdxRovingFocusItemDirective);

    protected readonly tabsContext = inject(RDX_TABS_ROOT_TOKEN);

    /**
     * A unique value that associates the trigger with a content.
     */
    readonly value = input.required<string>();

    /**
     * When true, prevents the user from interacting with the tab.
     */
    readonly disabled = input<boolean, BooleanInput>(false, {
        transform: booleanAttribute
    });

    protected readonly contentId = computed(() => makeContentId(this.tabsContext.getBaseId(), this.value()));
    protected readonly triggerId = computed(() => makeTriggerId(this.tabsContext.getBaseId(), this.value()));

    protected readonly isSelected = computed(() => this.tabsContext.value() === this.value());

    constructor() {
        effect(() => (this.rdxRovingFocusItemDirective.active = this.isSelected()));
    }

    protected onMouseDown(event: MouseEvent) {
        // only call handler if it's the left button (mousedown gets triggered by all mouse buttons)
        // but not when the control key is pressed (avoiding MacOS right click)
        if (!this.disabled() && event.button === 0 && !event.ctrlKey) {
            this.tabsContext?.select(this.value());
        } else {
            // prevent focus to avoid accidental activation
            event.preventDefault();
        }
    }

    protected onKeyDown(event: KeyboardEvent) {
        if ([' ', 'Enter'].includes(event.key)) {
            this.tabsContext?.select(this.value());
        }
    }

    protected onFocus() {
        const isAutomaticActivation = this.tabsContext.activationMode() !== 'manual';
        if (!this.isSelected() && !this.disabled() && isAutomaticActivation) {
            this.tabsContext?.select(this.value());
        }
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tabs/src/utils.ts
```typescript
export function makeTriggerId(baseId: string, value: string | number) {
    return `${baseId}-trigger-${value}`;
}

export function makeContentId(baseId: string, value: string | number) {
    return `${baseId}-content-${value}`;
}

```
