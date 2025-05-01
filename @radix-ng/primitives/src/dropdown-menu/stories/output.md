/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/stories/dropdown-menu-item-checkbox.component.ts
```typescript
import { Component } from '@angular/core';
import { LucideAngularModule } from 'lucide-angular';
import { RdxDropdownMenuContentDirective } from '../src/dropdown-menu-content.directive';
import { RdxDropdownMenuItemCheckboxDirective } from '../src/dropdown-menu-item-checkbox.directive';
import { RdxDropdownMenuItemIndicatorDirective } from '../src/dropdown-menu-item-indicator.directive';
import { RdxDropdownMenuItemDirective } from '../src/dropdown-menu-item.directive';
import { RdxDropdownMenuLabelDirective } from '../src/dropdown-menu-label.directive';
import { RdxDropdownMenuSeparatorDirective } from '../src/dropdown-menu-separator.directive';
import { RdxDropdownMenuTriggerDirective } from '../src/dropdown-menu-trigger.directive';

@Component({
    selector: 'dropdown-menu-item-checkbox',
    styleUrl: 'dropdown-menu-item-checkbox.styles.scss',
    template: `
        <button
            class="IconButton"
            [rdxDropdownMenuTrigger]="menu"
            sideOffset="4"
            alignOffset="-5"
            aria-label="Customise options"
        >
            <lucide-angular size="16" name="menu" style="height: 1.2rem;" />
        </button>

        <ng-template #menu>
            <div class="DropdownMenuContent" [onEscapeKeyDown]="onEscapeKeyDown" rdxDropdownMenuContent>
                <button
                    class="DropdownMenuItem"
                    [(checked)]="itemState"
                    (onSelect)="onSelect()"
                    rdxDropdownMenuItemCheckbox
                >
                    <div class="DropdownMenuItemIndicator" rdxDropdownMenuItemIndicator>
                        <lucide-icon size="16" name="check" />
                    </div>
                    New Tab
                    <div class="RightSlot">⌘ T</div>
                </button>
                <button class="DropdownMenuItem" rdxDropdownMenuItemCheckbox disabled>
                    New Window
                    <div class="RightSlot">⌘ N</div>
                </button>
                <button
                    class="DropdownMenuItem"
                    [(checked)]="itemState2"
                    (onSelect)="onSelect()"
                    rdxDropdownMenuItemCheckbox
                >
                    <div class="DropdownMenuItemIndicator" rdxDropdownMenuItemIndicator>
                        <lucide-icon size="16" name="check" />
                    </div>
                    New Incognito Window
                </button>
                <div class="DropdownMenuSeparator" rdxDropdownMenuSeparator></div>
                <div class="DropdownMenuLabel" rdxDropdownMenuLabel>Label</div>
                <button class="DropdownMenuItem" [rdxDropdownMenuTrigger]="share" [side]="'right'" rdxDropdownMenuItem>
                    Share
                    <div class="RightSlot">></div>
                </button>
                <div class="DropdownMenuSeparator" rdxDropdownMenuSeparator></div>
                <button class="DropdownMenuItem" (onSelect)="onSelect()" rdxDropdownMenuItem>
                    Print…
                    <div class="RightSlot">⌘ P</div>
                </button>
            </div>
        </ng-template>

        <ng-template #share>
            <div class="DropdownMenuSubContent" rdxDropdownMenuContent>
                <button class="DropdownMenuItem" rdxDropdownMenuItem>Undo</button>
                <button class="DropdownMenuItem" rdxDropdownMenuItem>Redo</button>
                <div class="DropdownMenuSeparator" rdxDropdownMenuSeparator></div>
                <button class="DropdownMenuItem" rdxDropdownMenuItem>Cut</button>
                <button class="DropdownMenuItem" rdxDropdownMenuItem>Copy</button>
                <button class="DropdownMenuItem" rdxDropdownMenuItem>Paste</button>
            </div>
        </ng-template>
    `,
    imports: [
        RdxDropdownMenuTriggerDirective,
        RdxDropdownMenuItemDirective,
        RdxDropdownMenuItemCheckboxDirective,
        RdxDropdownMenuItemIndicatorDirective,
        RdxDropdownMenuSeparatorDirective,
        RdxDropdownMenuContentDirective,
        RdxDropdownMenuLabelDirective,
        LucideAngularModule
    ]
})
export class DropdownMenuItemCheckboxExampleComponent {
    itemState = true;
    itemState2 = false;

    onSelect() {
        console.log('onSelect');
    }

    onEscapeKeyDown(event: Event) {
        event.stopPropagation();

        console.log('onEscapeKeyDown: ', event);
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/stories/dropdown-menu-item-checkbox.styles.scss
```
button {
    all: unset;
}

.DropdownMenuContent,
.DropdownMenuSubContent {
    flex-direction: column;
    display: inline-flex;
    min-width: 220px;
    background-color: white;
    border-radius: 6px;
    padding: 5px;
    box-shadow:
        0px 10px 38px -10px rgba(22, 23, 24, 0.35),
        0px 10px 20px -15px rgba(22, 23, 24, 0.2);
    will-change: transform, opacity;
}

.DropdownMenuItem,
.DropdownMenuCheckboxItem,
.DropdownMenuRadioItem,
.DropdownMenuSubTrigger {
    font-size: 13px;
    line-height: 1;
    color: var(--violet-11);
    border-radius: 3px;
    display: flex;
    align-items: center;
    height: 25px;
    position: relative;
    padding: 0 5px 0 25px;
    user-select: none;
    outline: none;
}

.DropdownMenuItem[data-disabled],
.DropdownMenuCheckboxItem[data-disabled],
.DropdownMenuRadioItem[data-disabled] {
    color: var(--mauve-8);
    pointer-events: none;
}

.DropdownMenuItem[data-highlighted],
.DropdownMenuCheckboxItem[data-highlighted],
.DropdownMenuRadioItem[data-highlighted] {
    background-color: var(--violet-9);
    color: var(--violet-1);
}

.DropdownMenuSeparator {
    height: 1px;
    background-color: var(--violet-6);
    margin: 5px;
}

.DropdownMenuLabel {
    padding-left: 25px;
    font-size: 12px;
    line-height: 25px;
    color: var(--mauve-11);
}

.IconButton {
    font-family: inherit;
    border-radius: 100%;
    height: 35px;
    width: 35px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    color: var(--violet-11);
    background-color: white;
    box-shadow: 0 2px 10px var(--black-a7);
}

.DropdownMenuSubTrigger[data-state='open'] {
    background-color: var(--violet-4);
    color: var(--violet-11);
}

.DropdownMenuItemIndicator {
    position: absolute;
    left: 4px;
    width: 25px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
}

.IconButton:hover {
    background-color: var(--violet-3);
}

.IconButton:focus {
    box-shadow: 0 0 0 2px black;
}

.RightSlot {
    margin-left: auto;
    padding-left: 20px;
    color: var(--mauve-9);
    display: flex;
    flex-direction: row;
    flex: 1;
    justify-content: flex-end;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/stories/dropdown-menu-item-radio.component.ts
```typescript
import { Component } from '@angular/core';
import { LucideAngularModule } from 'lucide-angular';
import { RdxDropdownMenuContentDirective } from '../src/dropdown-menu-content.directive';
import { RdxDropdownMenuItemIndicatorDirective } from '../src/dropdown-menu-item-indicator.directive';
import { RdxDropdownMenuItemRadioGroupDirective } from '../src/dropdown-menu-item-radio-group.directive';
import { RdxDropdownMenuItemRadioDirective } from '../src/dropdown-menu-item-radio.directive';
import { RdxDropdownMenuItemDirective } from '../src/dropdown-menu-item.directive';
import { RdxDropdownMenuLabelDirective } from '../src/dropdown-menu-label.directive';
import { RdxDropdownMenuSeparatorDirective } from '../src/dropdown-menu-separator.directive';
import { RdxDropdownMenuTriggerDirective } from '../src/dropdown-menu-trigger.directive';

@Component({
    selector: 'dropdown-menu-item-radio',
    styleUrl: 'dropdown-menu-item-radio.styles.scss',
    template: `
        <button
            class="IconButton"
            [rdxDropdownMenuTrigger]="menu"
            sideOffset="4"
            alignOffset="-5"
            aria-label="Customise options"
        >
            <lucide-angular size="16" name="menu" style="height: 1.2rem;" />
        </button>
        <ng-template #menu>
            <div class="DropdownMenuContent" [closeOnEscape]="false" rdxDropdownMenuContent>
                <div [(value)]="selectedValue" (valueChange)="onValueChange($event)" rdxDropdownMenuItemRadioGroup>
                    <div class="DropdownMenuItem" [value]="'1'" rdxDropdownMenuItemRadio>
                        <div class="DropdownMenuItemIndicator" rdxDropdownMenuItemIndicator>
                            <lucide-icon size="16" name="dot" strokeWidth="8" />
                        </div>
                        New Tab
                        <div class="RightSlot">⌘ T</div>
                    </div>
                    <div class="DropdownMenuItem" [value]="'2'" disabled rdxDropdownMenuItemRadio>
                        <div class="DropdownMenuItemIndicator" rdxDropdownMenuItemIndicator>
                            <lucide-icon size="16" name="dot" strokeWidth="8" />
                        </div>
                        New Window
                        <div class="RightSlot">⌘ N</div>
                    </div>
                    <div class="DropdownMenuItem" [value]="'3'" rdxDropdownMenuItemRadio>
                        <div class="DropdownMenuItemIndicator" rdxDropdownMenuItemIndicator>
                            <lucide-icon size="16" name="dot" strokeWidth="8" />
                        </div>
                        New Incognito Window
                    </div>
                </div>
                <div class="DropdownMenuSeparator" rdxDropdownMenuSeparator></div>
                <div class="DropdownMenuLabel" rdxDropdownMenuLabel>Label</div>
                <button class="DropdownMenuItem" [rdxDropdownMenuTrigger]="share" [side]="'right'" rdxDropdownMenuItem>
                    Share
                    <div class="RightSlot">></div>
                </button>
                <div class="DropdownMenuSeparator" rdxDropdownMenuSeparator></div>
                <button class="DropdownMenuItem" rdxDropdownMenuItem>
                    Print…
                    <div class="RightSlot">⌘ P</div>
                </button>
            </div>
        </ng-template>

        <ng-template #share>
            <div class="DropdownMenuSubContent" rdxDropdownMenuContent>
                <button class="DropdownMenuItem" rdxDropdownMenuItem>Undo</button>
                <button class="DropdownMenuItem" rdxDropdownMenuItem>Redo</button>
                <div class="DropdownMenuSeparator" rdxDropdownMenuSeparator></div>
                <button class="DropdownMenuItem" rdxDropdownMenuItem>Cut</button>
                <button class="DropdownMenuItem" rdxDropdownMenuItem>Copy</button>
                <button class="DropdownMenuItem" rdxDropdownMenuItem>Paste</button>
            </div>
        </ng-template>
    `,
    imports: [
        RdxDropdownMenuTriggerDirective,
        RdxDropdownMenuItemDirective,
        RdxDropdownMenuItemRadioDirective,
        RdxDropdownMenuItemRadioGroupDirective,
        RdxDropdownMenuItemIndicatorDirective,
        RdxDropdownMenuSeparatorDirective,
        RdxDropdownMenuContentDirective,
        RdxDropdownMenuLabelDirective,
        LucideAngularModule
    ]
})
export class DropdownMenuItemRadioExampleComponent {
    selectedValue = '2';

    onValueChange(value: string) {
        this.selectedValue = value;

        console.log('this.selectedValue', this.selectedValue);
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/stories/dropdown-menu-item-radio.styles.scss
```
button {
    all: unset;
}

.DropdownMenuContent,
.DropdownMenuSubContent {
    flex-direction: column;
    display: inline-flex;
    min-width: 220px;
    background-color: white;
    border-radius: 6px;
    padding: 5px;
    box-shadow:
        0px 10px 38px -10px rgba(22, 23, 24, 0.35),
        0px 10px 20px -15px rgba(22, 23, 24, 0.2);
    will-change: transform, opacity;
}

.DropdownMenuItem,
.DropdownMenuCheckboxItem,
.DropdownMenuRadioItem,
.DropdownMenuSubTrigger {
    font-size: 13px;
    line-height: 1;
    color: var(--violet-11);
    border-radius: 3px;
    display: flex;
    align-items: center;
    height: 25px;
    position: relative;
    padding: 0 5px 0 25px;
    user-select: none;
    outline: none;
}

.DropdownMenuItem[data-disabled],
.DropdownMenuCheckboxItem[data-disabled],
.DropdownMenuRadioItem[data-disabled] {
    color: var(--mauve-8);
    pointer-events: none;
}

.DropdownMenuItem[data-highlighted],
.DropdownMenuCheckboxItem[data-highlighted],
.DropdownMenuRadioItem[data-highlighted] {
    background-color: var(--violet-9);
    color: var(--violet-1);
}

.DropdownMenuSeparator {
    height: 1px;
    background-color: var(--violet-6);
    margin: 5px;
}

.DropdownMenuLabel {
    padding-left: 25px;
    font-size: 12px;
    line-height: 25px;
    color: var(--mauve-11);
}

.IconButton {
    font-family: inherit;
    border-radius: 100%;
    height: 35px;
    width: 35px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    color: var(--violet-11);
    background-color: white;
    box-shadow: 0 2px 10px var(--black-a7);
}

.DropdownMenuSubTrigger[data-state='open'] {
    background-color: var(--violet-4);
    color: var(--violet-11);
}

.DropdownMenuItemIndicator {
    position: absolute;
    left: 4px;
    width: 25px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
}

.IconButton:hover {
    background-color: var(--violet-3);
}

.IconButton:focus {
    box-shadow: 0 0 0 2px black;
}

.RightSlot {
    margin-left: auto;
    padding-left: 20px;
    color: var(--mauve-9);
    display: flex;
    flex-direction: row;
    flex: 1;
    justify-content: flex-end;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/stories/dropdown.docs.mdx
```
import { Canvas, Meta } from '@storybook/blocks';
import * as DropdownStories from './dropdown.stories';

<Meta title="Primitives/Dropdown Menu" />

# Dropdown Menu

#### Displays a menu to the user—such as a set of actions or functions—triggered by a button.

<Canvas sourceState="hidden" of={DropdownStories.Default} height="300px" />

## Features

- ✅ Supports submenus with configurable reading direction.
- ✅ Supports items, labels, groups of items.
- ✅ Customize side, alignment, offsets.

ToDo

- Can be controlled or uncontrolled.
- Supports checkable items (single or multiple) with optional indeterminate state.
- Supports modal and non-modal modes.
- Optionally render a pointing arrow.
- Focus is fully managed.
- Full keyboard navigation.
- Typeahead support.
- Dismissing and layering behavior is highly customizable.

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/stories/dropdown.stories.ts
```typescript
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { Check, Dot, LucideAngularModule, Menu } from 'lucide-angular';

import { RdxDropdownMenuContentDirective } from '../src/dropdown-menu-content.directive';
import { RdxDropdownMenuItemCheckboxDirective } from '../src/dropdown-menu-item-checkbox.directive';
import { RdxDropdownMenuItemIndicatorDirective } from '../src/dropdown-menu-item-indicator.directive';
import { RdxDropdownMenuItemDirective } from '../src/dropdown-menu-item.directive';
import { RdxDropdownMenuSeparatorDirective } from '../src/dropdown-menu-separator.directive';
import { RdxDropdownMenuTriggerDirective } from '../src/dropdown-menu-trigger.directive';
import { DropdownMenuItemCheckboxExampleComponent } from './dropdown-menu-item-checkbox.component';
import { DropdownMenuItemRadioExampleComponent } from './dropdown-menu-item-radio.component';

export default {
    title: 'Primitives/Dropdown Menu',
    decorators: [
        moduleMetadata({
            imports: [
                RdxDropdownMenuTriggerDirective,
                RdxDropdownMenuItemDirective,
                RdxDropdownMenuItemCheckboxDirective,
                RdxDropdownMenuItemIndicatorDirective,
                RdxDropdownMenuSeparatorDirective,
                RdxDropdownMenuContentDirective,
                LucideAngularModule,
                LucideAngularModule.pick({ Menu, Check, Dot }),
                DropdownMenuItemCheckboxExampleComponent,
                DropdownMenuItemRadioExampleComponent
            ]
        }),
        componentWrapperDecorator(
            (story) => `
                <div class="radix-themes light light-theme radix-themes-default-fonts rt-Flex rt-r-ai-start rt-r-jc-center rt-r-position-relative"
                    data-accent-color="indigo"
                    data-radius="medium"
                    data-scaling="100%"
                >
                    ${story}
                </div>`
        )
    ]
} as Meta;

type Story = StoryObj;

export const Default: Story = {
    render: () => ({
        template: `
<button [rdxDropdownMenuTrigger]="menu"
        sideOffset="4"
        alignOffset="-5"
        class="IconButton" aria-label="Customise options">
    <lucide-angular size="16" name="menu" style="height: 1.2rem;"></lucide-angular>
</button>

<ng-template #menu>
  <div class="DropdownMenuContent" rdxDropdownMenuContent>
    <button class="DropdownMenuItem" rdxDropdownMenuItem>
        New Tab <div class="RightSlot">⌘ T</div>
    </button>
    <button class="DropdownMenuItem" rdxDropdownMenuItem disabled>
        New Window <div class="RightSlot">⌘ N</div>
    </button>
    <button class="DropdownMenuItem" rdxDropdownMenuItem>
        New Incognito Window
    </button>
    <div rdxDropdownMenuSeparator class="DropdownMenuSeparator"></div>
    <div class="DropdownMenuLabel" rdxDropdownMenuLabel>
        Label
    </div>
    <button
        class="DropdownMenuItem"
        rdxDropdownMenuItem
        [rdxDropdownMenuTrigger]="share"
        [side]="'right'"
    >
        Share <div class="RightSlot">></div>
    </button>
    <div rdxDropdownMenuSeparator class="DropdownMenuSeparator"></div>
    <button class="DropdownMenuItem" rdxDropdownMenuItem>
        Print… <div class="RightSlot">⌘ P</div>
    </button>
  </div>
</ng-template>

<ng-template #share>
  <div class="DropdownMenuContent" rdxDropdownMenuContent>
    <button class="DropdownMenuItem" rdxDropdownMenuItem>Undo</button>
    <button class="DropdownMenuItem" rdxDropdownMenuItem>Redo</button>
    <div rdxDropdownMenuSeparator class="DropdownMenuSeparator"></div>
    <button class="DropdownMenuItem" rdxDropdownMenuItem>Cut</button>
    <button class="DropdownMenuItem" rdxDropdownMenuItem>Copy</button>
    <button class="DropdownMenuItem" rdxDropdownMenuItem>Paste</button>
  </div>
</ng-template>

<style>
/* reset */
button {
  all: unset;
}

.DropdownMenuContent {
  flex-direction: column;
  display: inline-flex;
  min-width: 220px;
  background-color: white;
  border-radius: 6px;
  padding: 5px;
  box-shadow: 0px 10px 38px -10px rgba(22, 23, 24, 0.35), 0px 10px 20px -15px rgba(22, 23, 24, 0.2);
  will-change: transform, opacity;
}

.DropdownMenuItem,
.DropdownMenuCheckboxItem,
.DropdownMenuRadioItem {
  font-size: 13px;
  line-height: 1;
  color: var(--violet-11);
  border-radius: 3px;
  display: flex;
  align-items: center;
  height: 25px;
  position: relative;
  padding: 0 5px 0 25px;
  user-select: none;
  outline: none;
}

.DropdownMenuItem[data-disabled],
.DropdownMenuCheckboxItem[data-disabled],
.DropdownMenuRadioItem[data-disabled] {
  color: var(--mauve-8);
  pointer-events: none;
}
.DropdownMenuItem[data-highlighted],
.DropdownMenuCheckboxItem[data-highlighted],
.DropdownMenuRadioItem[data-highlighted] {
  background-color: var(--violet-9);
  color: var(--violet-1);
}

.DropdownMenuSeparator {
  height: 1px;
  background-color: var(--violet-6);
  margin: 5px;
}

.DropdownMenuLabel {
  padding-left: 25px;
  font-size: 12px;
  line-height: 25px;
  color: var(--mauve-11);
}

.IconButton {
  font-family: inherit;
  border-radius: 100%;
  height: 35px;
  width: 35px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: var(--violet-11);
  background-color: white;
  box-shadow: 0 2px 10px var(--black-a7);
}

.DropdownMenuItemIndicator {
  position: absolute;
  left: 4px;
  width: 25px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.IconButton:hover {
  background-color: var(--violet-3);
}

.IconButton:focus {
  box-shadow: 0 0 0 2px black;
}

.RightSlot {
  margin-left: auto;
  padding-left: 20px;
  color: var(--mauve-9);
  display: flex;
  flex-direction: row;
  flex: 1;
  justify-content: flex-end;
}

</style>
`
    })
};

export const DropdownMenuItemCheckbox: Story = {
    name: 'Checkbox',
    render: () => ({
        template: `<dropdown-menu-item-checkbox/>`
    })
};

export const DropdownMenuItemRadio: Story = {
    name: 'Radio',
    render: () => ({
        template: `<dropdown-menu-item-radio/>`
    })
};

```
