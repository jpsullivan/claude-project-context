/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menu/stories/components/menu-checkbox-items.ts
```typescript
import { ChangeDetectionStrategy, Component, signal } from '@angular/core';
import { RdxMenuModule } from '@radix-ng/primitives/menu';
import { LucideAngularModule, X } from 'lucide-angular';

@Component({
    selector: 'menu-checkbox-items-story',
    imports: [RdxMenuModule, LucideAngularModule],
    styleUrl: 'styles.css',
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        <div class="MenuRoot" RdxMenuRoot>
            <div
                class="MenuTrigger"
                [menuTriggerFor]="menuGroup"
                align="start"
                sideOffset="5"
                alignOffset="-3"
                RdxMenuItem
                RdxMenuTrigger
            >
                File
            </div>
        </div>

        <ng-template #menuGroup>
            <div class="MenuContent" RdxMenuContent>
                <div
                    class="MenuCheckboxItem inset"
                    [checked]="checkedState()"
                    (menuItemTriggered)="handleSelectAll()"
                    RdxMenuItemCheckbox
                >
                    Select All
                    <lucide-icon class="MenuItemIndicator" [img]="X" RdxMenuItemIndicator size="16" strokeWidth="2" />
                </div>

                <div class="MenuSeparator" RdxMenuSeparator></div>
                @for (item of options(); track $index) {
                    <div
                        class="MenuCheckboxItem inset"
                        [checked]="selectedItems.includes(item)"
                        (menuItemTriggered)="handleSelection(item)"
                        RdxMenuItemCheckbox
                    >
                        {{ item }}
                        <lucide-icon
                            class="MenuItemIndicator"
                            [img]="X"
                            RdxMenuItemIndicator
                            size="16"
                            strokeWidth="2"
                        />
                    </div>
                }
            </div>
        </ng-template>
    `
})
export class MenuCheckboxItemsStory {
    options = signal<string[]>(['Crows', 'Ravens', 'Magpies', 'Jackdaws']);

    selectedItems = this.options();

    handleSelection(option: string) {
        if (this.selectedItems.includes(option)) {
            this.selectedItems = this.selectedItems.filter((el) => el !== option);
        } else {
            this.selectedItems = this.selectedItems.concat(option);
        }
    }

    handleSelectAll() {
        if (this.selectedItems.length === this.options().length) this.selectedItems = [];
        else this.selectedItems = this.options();
    }

    checkedState() {
        return this.selectedItems.length === this.options().length
            ? true
            : this.selectedItems.length > 0
              ? 'indeterminate'
              : false;
    }

    protected readonly X = X;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menu/stories/components/menu-radio-items.ts
```typescript
import { ChangeDetectionStrategy, Component, signal } from '@angular/core';
import { RdxMenuModule } from '@radix-ng/primitives/menu';
import { Dot, LucideAngularModule } from 'lucide-angular';

@Component({
    selector: 'menu-radio-items-story',
    imports: [RdxMenuModule, LucideAngularModule],
    styleUrl: 'styles.css',
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        <div class="MenuRoot" RdxMenuRoot>
            <div
                class="MenuTrigger"
                [menuTriggerFor]="menuGroup"
                side="bottom"
                align="start"
                sideOffset="5"
                alignOffset="-3"
                RdxMenuItem
                RdxMenuTrigger
            >
                File
            </div>
        </div>

        <ng-template #menuGroup>
            <div class="MenuContent" RdxMenuContent>
                <div class="MenuItem inset" RdxMenuItem>Minimize window</div>
                <div class="MenuItem inset" RdxMenuItem>Zoom</div>
                <div class="MenuItem inset" RdxMenuItem>Smaller</div>

                <div class="MenuSeparator" RdxMenuSeparator></div>
                <div RdxMenuRadioGroup>
                    @for (item of items(); track $index) {
                        <div
                            class="MenuRadioItem inset"
                            [checked]="item === selectedItem"
                            (menuItemTriggered)="selectedItem = item"
                            RdxMenuItemRadio
                        >
                            {{ item }}
                            <lucide-icon
                                class="MenuItemIndicator"
                                [img]="Dot"
                                RdxMenuItemIndicator
                                size="16"
                                strokeWidth="5"
                            />
                        </div>
                    }
                </div>
            </div>
        </ng-template>
    `
})
export class MenuRadioItemsStory {
    readonly items = signal(['README.md', 'index.js', 'page.css']);

    selectedItem: string | undefined;

    protected readonly Dot = Dot;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menu/stories/components/menu-with-labels-items.ts
```typescript
import { ChangeDetectionStrategy, Component } from '@angular/core';
import { RdxMenuModule } from '@radix-ng/primitives/menu';

@Component({
    selector: 'menu-with-labels-items-story',
    imports: [
        RdxMenuModule
    ],
    styleUrl: 'styles.css',
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        <div class="MenuRoot" RdxMenuRoot>
            <div
                class="MenuTrigger"
                [menuTriggerFor]="menuGroup"
                align="center"
                sideOffset="8"
                RdxMenuItem
                RdxMenuTrigger
            >
                File
            </div>
        </div>

        <ng-template #menuGroup>
            <div class="MenuContent" RdxMenuContent>
                <div RdxMenuGroup>
                    @for (foodGroup of foodGroups; track $index) {
                        <div class="MenuLabel" RdxMenuLabel>{{ foodGroup.label }}</div>

                        @for (food of foodGroup.foods; track $index) {
                            <div class="MenuItem" (onSelect)="handleSelect(food.value)" RdxMenuItem>
                                {{ food.label }}
                            </div>
                        }
                        @if ($index < foodGroups.length - 1) {
                            <div class="MenuSeparator" RdxMenuSeparator></div>
                        }
                    }
                </div>
            </div>
        </ng-template>
    `
})
export class MenuWithLabelsItemsStory {
    handleSelect(food: string) {
        console.log(food);
    }

    readonly foodGroups: Array<{
        label?: string;
        foods: Array<{ value: string; label: string; disabled?: boolean }>;
    }> = [
        {
            label: 'Fruits',
            foods: [
                { value: 'apple', label: 'Apple' },
                { value: 'banana', label: 'Banana' },
                { value: 'blueberry', label: 'Blueberry' },
                { value: 'grapes', label: 'Grapes' },
                { value: 'pineapple', label: 'Pineapple' }
            ]
        },
        {
            label: 'Vegetables',
            foods: [
                { value: 'aubergine', label: 'Aubergine' },
                { value: 'broccoli', label: 'Broccoli' },
                { value: 'carrot', label: 'Carrot', disabled: true },
                { value: 'courgette', label: 'Courgette' },
                { value: 'leek', label: 'Leek' }
            ]
        },
        {
            label: 'Meat',
            foods: [
                { value: 'beef', label: 'Beef' },
                { value: 'beef-with-sauce', label: 'Beef with sauce' },
                { value: 'chicken', label: 'Chicken' },
                { value: 'lamb', label: 'Lamb' },
                { value: 'pork', label: 'Pork' }
            ]
        },
        {
            foods: [
                { value: 'candies', label: 'Candies' },
                { value: 'chocolates', label: 'Chocolates' }
            ]
        }
    ];
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menu/stories/components/menu-with-sub-menu.ts
```typescript
import { ChangeDetectionStrategy, Component } from '@angular/core';
import { RdxPositionAlign, RdxPositionSide } from '@radix-ng/primitives/core';
import { RdxMenuModule } from '@radix-ng/primitives/menu';
import { ArrowRight, LucideAngularModule } from 'lucide-angular';

@Component({
    selector: 'menu-with-sub-menu-story',
    imports: [RdxMenuModule, LucideAngularModule],
    styleUrl: 'styles.css',
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        <div class="MenuRoot" RdxMenuRoot>
            <div
                class="MenuTrigger"
                [menuTriggerFor]="menuGroup"
                align="start"
                sideOffset="5"
                alignOffset="-3"
                RdxMenuItem
                RdxMenuTrigger
            >
                File
            </div>
        </div>

        <ng-template #menuGroup>
            <div class="MenuContent" RdxMenuContent>
                <div class="MenuItem " RdxMenuItem>Undo</div>
                <div class="MenuItem " RdxMenuItem>Redo</div>
                <div class="MenuSeparator" RdxMenuSeparator></div>

                <div
                    class="MenuItem"
                    [menuTriggerFor]="subMenu"
                    align="start"
                    sideOffset="-20"
                    alignOffset="210"
                    RdxMenuItem
                    RdxMenuTrigger
                >
                    Find
                    <div class="RightSlot"><lucide-angular [img]="ArrowRight" size="16" strokeWidth="2" /></div>
                </div>

                <div class="MenuSeparator" RdxMenuSeparator></div>

                <div class="MenuItem " RdxMenuItem>Cut</div>
                <div class="MenuItem " RdxMenuItem>Copy</div>
                <div class="MenuItem " RdxMenuItem>Paste</div>
            </div>
        </ng-template>

        <ng-template #subMenu>
            <div class="MenuSubContent" RdxMenuContent>
                <div class="MenuItem" RdxMenuItem>Undo</div>
                <div class="MenuItem" RdxMenuItem>Redo</div>
                <div class="MenuSeparator" RdxMenuSeparator></div>
                <div class="MenuItem" RdxMenuItem>Cut</div>
                <div class="MenuItem" RdxMenuItem>Copy</div>
                <div class="MenuItem" RdxMenuItem>Paste</div>
            </div>
        </ng-template>
    `
})
export class MenuWithSubMenuStory {
    protected readonly ArrowRight = ArrowRight;
    protected readonly RdxPositionAlign = RdxPositionAlign;
    protected readonly RdxPositionSide = RdxPositionSide;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menu/stories/components/styles.css
```css
/* reset */
:host {
    button {
        all: unset;
    }
}

.MenuRoot {
    display: flex;
    background-color: white;
    padding: 3px;
    border-radius: 6px;
    box-shadow: 0 2px 10px var(--black-a7);
}

.MenuTrigger {
    padding: 8px 12px;
    outline: none;
    user-select: none;
    font-weight: 500;
    line-height: 1;
    border-radius: 4px;
    color: var(--violet-11);
    font-size: 13px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 2px;
}

.MenuTrigger[data-highlighted],
.MenuTrigger[data-state='open'] {
    background-color: var(--violet-4);
}

.MenuContent,
.MenuSubContent {
    min-width: 220px;
    background-color: white;
    border-radius: 6px;
    padding: 5px;
    box-shadow:
        0px 10px 38px -10px rgba(22, 23, 24, 0.35),
        0px 10px 20px -15px rgba(22, 23, 24, 0.2);
    animation-duration: 400ms;
    animation-timing-function: cubic-bezier(0.16, 1, 0.3, 1);
    will-change: transform, opacity;
}

.MenuItem,
.MenuSubTrigger,
.MenuCheckboxItem,
.MenuRadioItem {
    all: unset;
    font-size: 13px;
    line-height: 1;
    color: var(--violet-11);
    border-radius: 4px;
    display: flex;
    align-items: center;
    height: 25px;
    padding: 0 10px;
    position: relative;
    user-select: none;
}

.MenuItem.inset,
.MenuSubTrigger.inset,
.MenuCheckboxItem.inset,
.MenuRadioItem.inset {
    padding-left: 20px;
}

.MenuItem[data-state='open'],
.MenuSubTrigger[data-state='open'] {
    background-color: var(--violet-4);
    color: var(--violet-11);
}

.MenuItem[data-highlighted],
.MenuSubTrigger[data-highlighted],
.MenuCheckboxItem[data-highlighted],
.MenuRadioItem[data-highlighted] {
    background-image: linear-gradient(135deg, var(--violet-9) 0%, var(--violet-10) 100%);
    color: var(--violet-1);
}

.MenuItem[data-disabled],
.MenuSubTrigger[data-disabled],
.MenuCheckboxItem[data-disabled],
.MenuRadioItem[data-disabled] {
    color: var(--mauve-8);
    pointer-events: none;
}

.MenuItemIndicator {
    position: absolute;
    left: 0;
    width: 20px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
}

.MenuSeparator {
    height: 1px;
    background-color: var(--violet-6);
    margin: 5px;
}

.MenuLabel {
    padding-left: 5px;
    font-size: 12px;
    line-height: 25px;
    color: var(--mauve-11);
}

.RightSlot {
    margin-left: auto;
    padding-left: 20px;
    color: var(--mauve-9);
}

[data-highlighted] > .RightSlot {
    color: white;
}

[data-disabled] > .RightSlot {
    color: var(--mauve-8);
}

```
