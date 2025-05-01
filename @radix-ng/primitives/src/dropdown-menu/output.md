/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/README.md
```
# @radix-ng/primitives/dropdown-menu

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/index.ts
```typescript
import { NgModule } from '@angular/core';
import { RdxDropdownMenuContentDirective } from './src/dropdown-menu-content.directive';
import { RdxDropdownMenuItemCheckboxDirective } from './src/dropdown-menu-item-checkbox.directive';
import { RdxDropdownMenuItemIndicatorDirective } from './src/dropdown-menu-item-indicator.directive';
import { RdxDropdownMenuItemRadioGroupDirective } from './src/dropdown-menu-item-radio-group.directive';
import { RdxDropdownMenuItemRadioDirective } from './src/dropdown-menu-item-radio.directive';
import { RdxDropdownMenuSelectable } from './src/dropdown-menu-item-selectable';
import { RdxDropdownMenuItemDirective } from './src/dropdown-menu-item.directive';
import { RdxDropdownMenuLabelDirective } from './src/dropdown-menu-label.directive';
import { RdxDropdownMenuSeparatorDirective } from './src/dropdown-menu-separator.directive';
import { RdxDropdownMenuTriggerDirective } from './src/dropdown-menu-trigger.directive';

export * from './src/dropdown-menu-content.directive';
export * from './src/dropdown-menu-item-checkbox.directive';
export * from './src/dropdown-menu-item-indicator.directive';
export * from './src/dropdown-menu-item-radio-group.directive';
export * from './src/dropdown-menu-item-radio.directive';
export * from './src/dropdown-menu-item-selectable';
export * from './src/dropdown-menu-item.directive';
export * from './src/dropdown-menu-label.directive';
export * from './src/dropdown-menu-separator.directive';
export * from './src/dropdown-menu-trigger.directive';

const _imports = [
    RdxDropdownMenuTriggerDirective,
    RdxDropdownMenuContentDirective,
    RdxDropdownMenuItemCheckboxDirective,
    RdxDropdownMenuItemIndicatorDirective,
    RdxDropdownMenuItemRadioGroupDirective,
    RdxDropdownMenuItemRadioDirective,
    RdxDropdownMenuSelectable,
    RdxDropdownMenuItemDirective,
    RdxDropdownMenuLabelDirective,
    RdxDropdownMenuSeparatorDirective,
    RdxDropdownMenuTriggerDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class Rdx {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
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
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/src/dropdown-menu-content.directive.ts
```typescript
import { CdkMenu, CdkMenuItem } from '@angular/cdk/menu';
import { Directive, inject, Input } from '@angular/core';
import { pairwise, startWith, Subject } from 'rxjs';
import { RdxDropdownMenuItemDirective } from './dropdown-menu-item.directive';
import { RdxDropdownMenuTriggerDirective } from './dropdown-menu-trigger.directive';

@Directive({
    selector: '[rdxDropdownMenuContent]',
    standalone: true,
    host: {
        '[attr.data-state]': "menuTrigger.isOpen() ? 'open': 'closed'",
        '[attr.data-align]': 'menuTrigger!.align',
        '[attr.data-side]': 'menuTrigger!.side',
        '[attr.data-orientation]': 'orientation'
    },
    providers: [
        {
            provide: CdkMenu,
            useExisting: RdxDropdownMenuContentDirective
        }
    ]
})
export class RdxDropdownMenuContentDirective extends CdkMenu {
    readonly highlighted = new Subject<RdxDropdownMenuItemDirective>();
    readonly menuTrigger = inject(RdxDropdownMenuTriggerDirective, { optional: true });

    @Input() onEscapeKeyDown: (event?: Event) => void = () => undefined;
    @Input() closeOnEscape: boolean = true;

    constructor() {
        super();

        this.highlighted.pipe(startWith(null), pairwise()).subscribe(([prev, item]) => {
            if (prev) {
                prev.highlighted = false;
            }

            if (item) {
                item.highlighted = true;
            }
        });
    }

    updateActiveItem(item: CdkMenuItem) {
        this.keyManager.updateActiveItem(item);
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/src/dropdown-menu-item-checkbox.directive.ts
```typescript
import { CDK_MENU, CdkMenuItem } from '@angular/cdk/menu';
import { Directive } from '@angular/core';
import { RdxDropdownMenuContentDirective } from './dropdown-menu-content.directive';
import { RdxDropdownMenuSelectable } from './dropdown-menu-item-selectable';
import { RdxDropdownMenuItemDirective } from './dropdown-menu-item.directive';

@Directive({
    selector: '[rdxDropdownMenuItemCheckbox]',
    standalone: true,
    host: {
        role: 'menuitemcheckbox'
    },
    providers: [
        { provide: RdxDropdownMenuSelectable, useExisting: RdxDropdownMenuItemCheckboxDirective },
        { provide: RdxDropdownMenuItemDirective, useExisting: RdxDropdownMenuSelectable },
        { provide: CdkMenuItem, useExisting: RdxDropdownMenuItemDirective },
        { provide: CDK_MENU, useExisting: RdxDropdownMenuContentDirective }
    ]
})
export class RdxDropdownMenuItemCheckboxDirective extends RdxDropdownMenuSelectable {
    override trigger(options?: { keepOpen: boolean }) {
        if (!this.disabled) {
            this.checked = !this.checked;

            this.checkedChange.emit(this.checked);
        }

        super.trigger(options);
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/src/dropdown-menu-item-indicator.directive.ts
```typescript
import { Directive, inject } from '@angular/core';
import { RdxDropdownMenuSelectable } from './dropdown-menu-item-selectable';

@Directive({
    selector: '[rdxDropdownMenuItemIndicator]',
    standalone: true,
    host: {
        '[style.display]': "item.checked ? 'block' : 'none'",
        '[attr.data-state]': "item.checked ? 'checked' : 'unchecked'"
    }
})
export class RdxDropdownMenuItemIndicatorDirective {
    item = inject(RdxDropdownMenuSelectable);
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/src/dropdown-menu-item-radio-group.directive.ts
```typescript
import { UniqueSelectionDispatcher } from '@angular/cdk/collections';
import { AfterContentInit, Directive, EventEmitter, inject, Input, Output } from '@angular/core';

@Directive({
    selector: '[rdxDropdownMenuItemRadioGroup]',
    standalone: true,
    host: {
        role: 'group'
    },
    providers: [{ provide: UniqueSelectionDispatcher, useClass: UniqueSelectionDispatcher }]
})
export class RdxDropdownMenuItemRadioGroupDirective<T> implements AfterContentInit {
    private readonly selectionDispatcher = inject(UniqueSelectionDispatcher);

    @Input()
    set value(id: T | null) {
        this._value = id;
    }

    get value(): T | null {
        return this._value;
    }

    private _value: T | null = null;

    @Output() readonly valueChange = new EventEmitter();

    ngAfterContentInit(): void {
        this.selectionDispatcher.notify(this.value as string, '');
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/src/dropdown-menu-item-radio.directive.ts
```typescript
import { UniqueSelectionDispatcher } from '@angular/cdk/collections';
import { CDK_MENU, CdkMenuItem } from '@angular/cdk/menu';
import { AfterContentInit, Directive, inject, Input, OnDestroy } from '@angular/core';
import { RdxDropdownMenuContentDirective } from './dropdown-menu-content.directive';
import { RdxDropdownMenuItemRadioGroupDirective } from './dropdown-menu-item-radio-group.directive';
import { RdxDropdownMenuSelectable } from './dropdown-menu-item-selectable';
import { RdxDropdownMenuItemDirective } from './dropdown-menu-item.directive';

/** Counter used to set a unique id and name for a selectable item */
let nextId = 0;

@Directive({
    selector: '[rdxDropdownMenuItemRadio]',
    standalone: true,
    host: {
        role: 'menuitemradio'
    },
    providers: [
        { provide: RdxDropdownMenuSelectable, useExisting: RdxDropdownMenuItemRadioDirective },
        { provide: RdxDropdownMenuItemDirective, useExisting: RdxDropdownMenuSelectable },
        { provide: CdkMenuItem, useExisting: RdxDropdownMenuItemDirective },
        { provide: CDK_MENU, useExisting: RdxDropdownMenuContentDirective }
    ]
})
export class RdxDropdownMenuItemRadioDirective
    extends RdxDropdownMenuSelectable
    implements AfterContentInit, OnDestroy
{
    /** The unique selection dispatcher for this radio's `RdxDropdownMenuItemRadioGroupDirective`. */
    private readonly selectionDispatcher = inject(UniqueSelectionDispatcher);

    private readonly group = inject(RdxDropdownMenuItemRadioGroupDirective);

    @Input()
    get value() {
        return this._value || this.id;
    }

    set value(value: string) {
        this._value = value;
    }

    private _value: string | undefined;

    /** An ID to identify this radio item to the `UniqueSelectionDispatcher`. */
    private id = `${nextId++}`;

    private removeDispatcherListener!: () => void;

    constructor() {
        super();

        this.triggered.subscribe(() => {
            if (!this.disabled) {
                this.selectionDispatcher.notify(this.value, '');

                this.group.valueChange.emit(this.value);
            }
        });
    }

    ngAfterContentInit() {
        this.removeDispatcherListener = this.selectionDispatcher.listen((id: string) => {
            this.checked = this.value === id;
        });
    }

    override ngOnDestroy() {
        super.ngOnDestroy();
        this.removeDispatcherListener();
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/src/dropdown-menu-item-selectable.ts
```typescript
import { booleanAttribute, Directive, EventEmitter, Input, Output } from '@angular/core';
import { RdxDropdownMenuItemDirective } from './dropdown-menu-item.directive';

/** Base class providing checked state for selectable DropdownMenuItems. */
@Directive({
    standalone: true,
    host: {
        '[attr.aria-checked]': '!!checked',
        '[attr.aria-disabled]': 'disabled || null',
        '[attr.data-state]': 'checked ? "checked" : "unchecked"'
    }
})
export class RdxDropdownMenuSelectable extends RdxDropdownMenuItemDirective {
    /** Whether the element is checked */
    @Input({ transform: booleanAttribute }) checked: boolean = false;

    @Output() readonly checkedChange = new EventEmitter<boolean>();
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/src/dropdown-menu-item.directive.ts
```typescript
import { CDK_MENU, CdkMenuItem } from '@angular/cdk/menu';
import { booleanAttribute, Directive, ElementRef, EventEmitter, inject, Input, Output } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

import { RdxDropdownMenuContentDirective } from './dropdown-menu-content.directive';

@Directive({
    selector: '[rdxDropdownMenuItem]',
    standalone: true,
    host: {
        type: 'button',
        // todo horizontal ?
        '[attr.data-orientation]': '"vertical"',
        '[attr.data-highlighted]': 'highlighted ? "" : null',
        '[attr.data-disabled]': 'disabled ? "" : null',
        '[attr.disabled]': 'disabled ? "" : null',
        '(pointermove)': 'onPointerMove()',
        '(focus)': 'menu.highlighted.next(this)',
        '(keydown)': 'onKeydown($event)'
    },
    providers: [
        { provide: CdkMenuItem, useExisting: RdxDropdownMenuItemDirective },
        { provide: CDK_MENU, useExisting: RdxDropdownMenuContentDirective }
    ]
})
export class RdxDropdownMenuItemDirective extends CdkMenuItem {
    protected readonly menu = inject(RdxDropdownMenuContentDirective);
    protected readonly nativeElement = inject(ElementRef).nativeElement;

    highlighted = false;

    @Input({ transform: booleanAttribute }) override disabled: boolean = false;

    @Output() readonly onSelect = new EventEmitter<void>();

    constructor() {
        super();

        this.menu.highlighted.pipe(takeUntilDestroyed()).subscribe((value) => {
            if (value !== this) {
                this.highlighted = false;
            }
        });

        this.triggered.subscribe(this.onSelect);
    }

    protected onPointerMove() {
        if (!this.highlighted) {
            this.nativeElement.focus({ preventScroll: true });
            this.menu.updateActiveItem(this);
        }
    }

    protected onKeydown(event: KeyboardEvent) {
        if (this.nativeElement.tagName !== 'BUTTON' && ['Enter', ' '].includes(event.key)) {
            event.preventDefault();
        }

        if (event.key === 'Escape') {
            if (!this.menu.closeOnEscape) {
                event.stopPropagation();
            } else {
                this.menu.onEscapeKeyDown(event);
            }
        }
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/src/dropdown-menu-label.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxMenuLabelDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[rdxDropdownMenuLabel]',
    hostDirectives: [RdxMenuLabelDirective]
})
export class RdxDropdownMenuLabelDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/src/dropdown-menu-separator.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxMenuSeparatorDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[rdxDropdownMenuSeparator]',
    hostDirectives: [RdxMenuSeparatorDirective]
})
export class RdxDropdownMenuSeparatorDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dropdown-menu/src/dropdown-menu-trigger.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { CdkMenuTrigger, MENU_TRIGGER, PARENT_OR_NEW_MENU_STACK_PROVIDER } from '@angular/cdk/menu';
import { ConnectedPosition, OverlayRef, VerticalConnectionPos } from '@angular/cdk/overlay';
import { booleanAttribute, Directive, Input, input, numberAttribute, TemplateRef } from '@angular/core';
import { outputFromObservable } from '@angular/core/rxjs-interop';

export enum DropdownSide {
    Top = 'top',
    Right = 'right',
    Bottom = 'bottom',
    Left = 'left'
}

export enum DropdownAlign {
    Start = 'start',
    Center = 'center',
    End = 'end'
}

export const mapRdxAlignToCdkPosition = {
    start: 'top',
    center: 'center',
    end: 'bottom'
};

const dropdownPositions: Record<DropdownSide, ConnectedPosition> = {
    top: {
        originX: 'start',
        originY: 'top',
        overlayX: 'start',
        overlayY: 'bottom',
        offsetX: 0,
        offsetY: 0
    },
    right: {
        originX: 'end',
        originY: 'top',
        overlayX: 'start',
        overlayY: 'top',
        offsetX: 0,
        offsetY: 0
    },
    bottom: {
        originX: 'start',
        originY: 'bottom',
        overlayX: 'start',
        overlayY: 'top',
        offsetX: 0,
        offsetY: 0
    },
    left: {
        originX: 'start',
        originY: 'top',
        overlayX: 'end',
        overlayY: 'top',
        offsetX: 0,
        offsetY: 0
    }
};

/**
 * @group Components
 */
@Directive({
    selector: '[rdxDropdownMenuTrigger]',
    standalone: true,
    host: {
        type: 'button',
        '[attr.aria-haspopup]': "'menu'",
        '[attr.aria-expanded]': 'isOpen()',
        '[attr.data-state]': "isOpen() ? 'open': 'closed'",
        '[attr.data-disabled]': "disabled() ? '' : undefined",
        '[disabled]': 'disabled()',

        '(pointerdown)': 'onPointerDown($event)'
    },
    providers: [
        { provide: CdkMenuTrigger, useExisting: RdxDropdownMenuTriggerDirective },
        { provide: MENU_TRIGGER, useExisting: CdkMenuTrigger },
        PARENT_OR_NEW_MENU_STACK_PROVIDER
    ]
})
export class RdxDropdownMenuTriggerDirective extends CdkMenuTrigger {
    readonly disabled = input<boolean, BooleanInput>(false, {
        transform: booleanAttribute
    });

    @Input()
    set rdxDropdownMenuTrigger(value: TemplateRef<unknown> | null) {
        this.menuTemplateRef = value;
    }

    /**
     * The preferred side of the trigger to render against when open.
     * Will be reversed when collisions occur and `avoidCollisions` is enabled.
     *
     * @group Props
     * @defaultValue 'bottom'
     */
    @Input()
    set side(value: DropdownSide) {
        if (!Object.values(DropdownSide).includes(value)) {
            throw new Error(`Unknown side: ${value}`);
        }

        this._side = value;

        this.menuPosition[0] = dropdownPositions[value];
    }

    get side(): DropdownSide {
        return this._side;
    }

    private _side: DropdownSide = DropdownSide.Bottom;

    /**
     * The preferred alignment against the trigger. May change when collisions occur.
     *
     * @group Props
     * @defaultValue 'center'
     */
    @Input()
    set align(value: DropdownAlign) {
        if (!Object.values(DropdownAlign).includes(value)) {
            throw new Error(`Unknown align: ${value}`);
        }

        this._align = value;

        if (this.isVertical) {
            this.defaultPosition.overlayX = this.defaultPosition.originX = value;
        } else {
            this.defaultPosition.overlayY = this.defaultPosition.originY = mapRdxAlignToCdkPosition[
                value
            ] as VerticalConnectionPos;
        }
    }

    get align() {
        return this._align;
    }

    private _align: DropdownAlign = DropdownAlign.Start;

    /**
     * The distance in pixels from the trigger.
     * @group Props
     * @defaultValue 0
     */
    @Input({ transform: numberAttribute })
    set sideOffset(value: number) {
        // todo need invert value for top and left
        if (this.isVertical) {
            this.defaultPosition.offsetY = value;
        } else {
            this.defaultPosition.offsetX = value;
        }
    }

    get sideOffset() {
        return this._sideOffset;
    }

    private _sideOffset: number = 0;

    /**
     * An offset in pixels from the "start" or "end" alignment options.
     * @group Props
     * @defaultValue 0
     */
    @Input({ transform: numberAttribute })
    set alignOffset(value: number) {
        // todo need invert value for top and left
        if (this.isVertical) {
            this.defaultPosition.offsetX = value;
        } else {
            this.defaultPosition.offsetY = value;
        }
    }

    get alignOffset(): number {
        return this._alignOffset;
    }

    private _alignOffset: number = 0;

    onOpenChange = outputFromObservable(this.opened);

    get isVertical(): boolean {
        return this._side === DropdownSide.Top || this._side === DropdownSide.Bottom;
    }

    get defaultPosition(): ConnectedPosition {
        return this.menuPosition[0];
    }

    constructor() {
        super();
        // todo priority
        this.menuPosition = [{ ...dropdownPositions[DropdownSide.Bottom] }];
    }

    onPointerDown($event: MouseEvent) {
        // only call handler if it's the left button (mousedown gets triggered by all mouse buttons)
        // but not when the control key is pressed (avoiding MacOS right click)
        if (!this.disabled() && $event.button === 0 && !$event.ctrlKey) {
            /* empty */
            if (!this.isOpen()) {
                // prevent trigger focusing when opening
                // this allows the content to be given focus without competition
                $event.preventDefault();
            }
        }
    }

    getOverlayRef(): OverlayRef | null {
        return this.overlayRef;
    }
}

```
