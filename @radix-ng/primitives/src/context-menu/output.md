/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/README.md
```
# @radix-ng/primitives/context-menu

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/index.ts
```typescript
import { NgModule } from '@angular/core';
import { RdxContextMenuContentDirective } from './src/context-menu-content.directive';
import { RdxContextMenuItemCheckboxDirective } from './src/context-menu-item-checkbox.directive';
import { RdxContextMenuItemIndicatorDirective } from './src/context-menu-item-indicator.directive';
import { RdxContextMenuItemRadioGroupDirective } from './src/context-menu-item-radio-group.directive';
import { RdxContextMenuItemRadioDirective } from './src/context-menu-item-radio.directive';
import { RdxContextMenuSelectable } from './src/context-menu-item-selectable';
import { RdxContextMenuItemDirective } from './src/context-menu-item.directive';
import { RdxContextMenuLabelDirective } from './src/context-menu-label.directive';
import { RdxContextMenuSeparatorDirective } from './src/context-menu-separator.directive';
import { RdxContextMenuTriggerDirective } from './src/context-menu-trigger.directive';

export * from './src/context-menu-content.directive';
export * from './src/context-menu-item-checkbox.directive';
export * from './src/context-menu-item-indicator.directive';
export * from './src/context-menu-item-radio-group.directive';
export * from './src/context-menu-item-radio.directive';
export * from './src/context-menu-item-selectable';
export * from './src/context-menu-item.directive';
export * from './src/context-menu-label.directive';
export * from './src/context-menu-separator.directive';
export * from './src/context-menu-trigger.directive';

const _imports = [
    RdxContextMenuContentDirective,
    RdxContextMenuSelectable,
    RdxContextMenuItemCheckboxDirective,
    RdxContextMenuItemDirective,
    RdxContextMenuItemRadioGroupDirective,
    RdxContextMenuItemIndicatorDirective,
    RdxContextMenuItemRadioDirective,
    RdxContextMenuLabelDirective,
    RdxContextMenuSeparatorDirective,
    RdxContextMenuTriggerDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxContextMenuModule {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/stories/context-menu.docs.mdx
```
import { Canvas, Meta } from '@storybook/blocks';
import * as ContextMenuStories from './context-menu.stories';

<Meta title="Primitives/Context Menu" />

# Context Menu

#### Displays a menu to the user—such as a set of actions or functions—triggered by a button.

<Canvas sourceState="hidden" of={ContextMenuStories.Default} height="300px" />

## Features

- ✅ Supports submenus with configurable reading direction.
- ✅ Supports items, labels, groups of items.
- ✅ Supports checkable items (single or multiple) with optional indeterminate state.
- ✅ Supports modal and non-modal modes.
- ✅ Customize side, alignment, offsets, collision handling.
- ✅ Focus is fully managed.
- ✅ Full keyboard navigation.
- ✅ Typeahead support.
- ✅ Dismissing and layering behavior is highly customizable.
- ✅ Triggers with a long press on touch devices

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/stories/context-menu.stories.ts
```typescript
import {
    RdxDropdownMenuContentDirective,
    RdxDropdownMenuItemDirective,
    RdxDropdownMenuTriggerDirective
} from '@radix-ng/primitives/dropdown-menu';
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { Check, Dot, LucideAngularModule, Menu } from 'lucide-angular';

import { RdxContextMenuContentDirective } from '../src/context-menu-content.directive';
import { RdxContextMenuItemCheckboxDirective } from '../src/context-menu-item-checkbox.directive';
import { RdxContextMenuItemIndicatorDirective } from '../src/context-menu-item-indicator.directive';
import { RdxContextMenuItemRadioGroupDirective } from '../src/context-menu-item-radio-group.directive';
import { RdxContextMenuItemRadioDirective } from '../src/context-menu-item-radio.directive';
import { RdxContextMenuItemDirective } from '../src/context-menu-item.directive';
import { RdxContextMenuSeparatorDirective } from '../src/context-menu-separator.directive';
import { RdxContextMenuTriggerDirective } from '../src/context-menu-trigger.directive';

export default {
    title: 'Primitives/Context Menu',
    decorators: [
        moduleMetadata({
            imports: [
                RdxContextMenuTriggerDirective,
                RdxDropdownMenuTriggerDirective,
                RdxContextMenuItemDirective,
                RdxDropdownMenuItemDirective,
                RdxContextMenuItemCheckboxDirective,
                RdxContextMenuItemRadioDirective,
                RdxContextMenuItemRadioGroupDirective,
                RdxContextMenuItemIndicatorDirective,
                RdxContextMenuSeparatorDirective,
                RdxContextMenuContentDirective,
                RdxDropdownMenuContentDirective,
                LucideAngularModule,
                LucideAngularModule.pick({ Menu, Check, Dot })
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
<div class="context-menu-trigger"
    [rdxContextMenuTrigger]="menu">
    Right click here
</div>

<ng-template #menu>
  <div class="ContextMenuContent" rdxContextMenuContent>
    <button class="ContextMenuItem" rdxContextMenuItem>
        Back <div class="RightSlot">⌘ + [</div>
    </button>
    <button class="ContextMenuItem" rdxContextMenuItem disabled>
        Forward <div class="RightSlot">⌘ + ]</div>
    </button>
    <button class="ContextMenuItem" rdxContextMenuItem>
        Reload <div class="RightSlot">⌘ + R</div>
    </button>
    <button
        class="ContextMenuItem"
        rdxContextMenuItem
        [rdxDropdownMenuTrigger]="share"
        [side]="'right'"
    >
        More Tools <div class="RightSlot">></div>
    </button>

    <div rdxContextMenuSeparator class="ContextMenuSeparator"></div>

    <button class="ContextMenuItem" rdxContextMenuItemCheckbox [checked]="true">
        <div class="ContextMenuItemIndicator" rdxContextMenuItemIndicator>
            <lucide-icon size="16" name="check"></lucide-icon>
        </div>
        Show Bookmarks <div class="RightSlot">⌘ + B</div>
    </button>
    <button class="ContextMenuItem" rdxContextMenuItemCheckbox>
        <div class="ContextMenuItemIndicator" rdxContextMenuItemIndicator>
            <lucide-icon size="16" name="check"></lucide-icon>
        </div>
        Show Full URLs
    </button>

    <div rdxContextMenuSeparator class="ContextMenuSeparator"></div>

    <div class="ContextMenuLabel" rdxContextMenuLabel>People</div>
    <div class="ContextMenuItemRadioGroup" rdxContextMenuItemRadioGroup [value]="'1'">
        <button class="ContextMenuItem" rdxContextMenuItemRadio [value]="'1'">
            <div class="ContextMenuItemIndicator" rdxContextMenuItemIndicator>
                <lucide-icon size="16" name="dot" strokeWidth="8"></lucide-icon>
            </div>
            Pedro Duarte
        </button>
        <button class="ContextMenuItem" rdxContextMenuItemRadio [value]="'2'">
            <div class="ContextMenuItemIndicator" rdxContextMenuItemIndicator>
                <lucide-icon size="16" name="dot" strokeWidth="8"></lucide-icon>
            </div>
            Colm Tuite
        </button>
    </div>
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
    .context-menu-trigger {
        display: block;
        border: 2px dashed #fff;
        color: #fff;
        border-radius: 4px;
        font-size: 15px;
        -webkit-user-select: none;
        user-select: none;
        padding: 45px 0;
        width: 300px;
        text-align: center;

      &:focus: {
        outline: none;
        box-shadow: 0 0 0 2px rgba(0, 0, 0, 0.5);
      },

        &[data-state="open"]: {
            background-color: lightblue;
            /*display: flex;*/
            /*align-items: center;*/
            /*justify-content: center;*/
            /*width: 200vw;*/
            /*height: 200vh;*/
            /*gap: 20;*/
        }
    }
/* reset */
button {
  all: unset;
}

.ContextMenuContent,
.DropdownMenuContent {
  flex-direction: column;
  display: inline-flex;
  min-width: 220px;
  background-color: white;
  border-radius: 6px;
  padding: 5px;
  box-shadow: 0 10px 38px -10px rgba(22, 23, 24, 0.35), 0 10px 20px -15px rgba(22, 23, 24, 0.2);
  will-change: transform, opacity;
}

.ContextMenuItem,
.DropdownMenuItem,
.ContextMenuCheckboxItem,
.ContextMenuRadioItem {
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

.ContextMenuItem[data-disabled],
.DropdownMenuItem[data-disabled],
.ContextMenuCheckboxItem[data-disabled],
.ContextMenuRadioItem[data-disabled] {
  color: var(--mauve-8);
  pointer-events: none;
}
.ContextMenuItem[data-highlighted],
.DropdownMenuItem[data-highlighted],
.ContextMenuCheckboxItem[data-highlighted],
.ContextMenuRadioItem[data-highlighted] {
  background-color: var(--violet-9);
  color: var(--violet-1);
}

.DropdownMenuSeparator,
.ContextMenuSeparator {
  height: 1px;
  background-color: var(--violet-6);
  margin: 5px;
}

.ContextMenuLabel {
  padding-left: 25px;
  font-size: 12px;
  line-height: 25px;
  color: var(--mauve-11);
}

.ContextMenuItemIndicator {
  position: absolute;
  left: 4px;
  width: 25px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.ContextMenuItemRadioGroup {
  display: flex;
  flex-direction: column;
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

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/src/context-menu-content.directive.ts
```typescript
import { CdkMenu, CdkMenuItem } from '@angular/cdk/menu';
import { Directive, inject, Input } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { pairwise, startWith, Subject } from 'rxjs';
import { RdxContextMenuItemDirective } from './context-menu-item.directive';
import { RdxContextMenuTriggerDirective } from './context-menu-trigger.directive';

@Directive({
    selector: '[rdxContextMenuContent]',
    standalone: true,
    host: {
        '[attr.role]': "'menu'",
        '[attr.data-state]': "menuTrigger.isOpen() ? 'open': 'closed'",
        '[attr.data-orientation]': 'orientation'
    },
    providers: [
        {
            provide: CdkMenu,
            useExisting: RdxContextMenuContentDirective
        }
    ]
})
export class RdxContextMenuContentDirective extends CdkMenu {
    readonly highlighted = new Subject<RdxContextMenuItemDirective>();
    readonly menuTrigger = inject(RdxContextMenuTriggerDirective, { optional: true });

    @Input() onEscapeKeyDown: (event?: Event) => void = () => undefined;
    @Input() closeOnEscape = true;

    constructor() {
        super();

        this.highlighted.pipe(startWith(null), pairwise(), takeUntilDestroyed()).subscribe(([prev, item]) => {
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
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/src/context-menu-item-checkbox.directive.ts
```typescript
import { CDK_MENU, CdkMenuItem } from '@angular/cdk/menu';
import { Directive } from '@angular/core';
import { RdxContextMenuContentDirective } from './context-menu-content.directive';
import { RdxContextMenuSelectable } from './context-menu-item-selectable';
import { RdxContextMenuItemDirective } from './context-menu-item.directive';

@Directive({
    selector: '[rdxContextMenuItemCheckbox]',
    standalone: true,
    host: {
        role: 'menuitemcheckbox'
    },
    providers: [
        { provide: RdxContextMenuSelectable, useExisting: RdxContextMenuItemCheckboxDirective },
        { provide: RdxContextMenuItemDirective, useExisting: RdxContextMenuSelectable },
        { provide: CdkMenuItem, useExisting: RdxContextMenuItemDirective },
        { provide: CDK_MENU, useExisting: RdxContextMenuContentDirective }
    ]
})
export class RdxContextMenuItemCheckboxDirective extends RdxContextMenuSelectable {
    override trigger(options?: { keepOpen: boolean }) {
        if (!this.disabled) {
            this.checked = !this.checked;

            this.checkedChange.emit(this.checked);
        }

        super.trigger(options);
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/src/context-menu-item-indicator.directive.ts
```typescript
import { Directive, inject } from '@angular/core';
import { RdxContextMenuSelectable } from './context-menu-item-selectable';

@Directive({
    selector: '[rdxContextMenuItemIndicator]',
    standalone: true,
    host: {
        '[style.display]': "item.checked ? 'block' : 'none'",
        '[attr.data-state]': "item.checked ? 'checked' : 'unchecked'"
    }
})
export class RdxContextMenuItemIndicatorDirective {
    item = inject(RdxContextMenuSelectable);
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/src/context-menu-item-radio-group.directive.ts
```typescript
import { UniqueSelectionDispatcher } from '@angular/cdk/collections';
import { AfterContentInit, Directive, EventEmitter, inject, Input, Output } from '@angular/core';

@Directive({
    selector: '[rdxContextMenuItemRadioGroup]',
    standalone: true,
    host: {
        role: 'group'
    },
    providers: [{ provide: UniqueSelectionDispatcher, useClass: UniqueSelectionDispatcher }]
})
export class RdxContextMenuItemRadioGroupDirective<T> implements AfterContentInit {
    private readonly selectionDispatcher = inject(UniqueSelectionDispatcher);

    @Input()
    set value(value: T | null) {
        this._value = value;
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
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/src/context-menu-item-radio.directive.ts
```typescript
import { UniqueSelectionDispatcher } from '@angular/cdk/collections';
import { CDK_MENU, CdkMenuItem } from '@angular/cdk/menu';
import { AfterContentInit, Directive, inject, Input, OnDestroy } from '@angular/core';
import { RdxContextMenuContentDirective } from './context-menu-content.directive';
import { RdxContextMenuItemRadioGroupDirective } from './context-menu-item-radio-group.directive';
import { RdxContextMenuSelectable } from './context-menu-item-selectable';
import { RdxContextMenuItemDirective } from './context-menu-item.directive';

/** Counter used to set a unique id and name for a selectable item */
let nextId = 0;

@Directive({
    selector: '[rdxContextMenuItemRadio]',
    standalone: true,
    host: {
        role: 'menuitemradio'
    },
    providers: [
        { provide: RdxContextMenuSelectable, useExisting: RdxContextMenuItemRadioDirective },
        { provide: RdxContextMenuItemDirective, useExisting: RdxContextMenuSelectable },
        { provide: CdkMenuItem, useExisting: RdxContextMenuItemDirective },
        { provide: CDK_MENU, useExisting: RdxContextMenuContentDirective }
    ]
})
export class RdxContextMenuItemRadioDirective extends RdxContextMenuSelectable implements AfterContentInit, OnDestroy {
    /** The unique selection dispatcher for this radio's `RdxContextMenuItemRadioGroupDirective`. */
    private readonly selectionDispatcher = inject(UniqueSelectionDispatcher);

    private readonly group = inject(RdxContextMenuItemRadioGroupDirective);

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
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/src/context-menu-item-selectable.ts
```typescript
import { booleanAttribute, Directive, EventEmitter, Input, Output } from '@angular/core';
import { RdxContextMenuItemDirective } from './context-menu-item.directive';

/** Base class providing checked state for selectable ContextMenuItems. */
@Directive({
    standalone: true,
    host: {
        '[attr.aria-checked]': '!!checked',
        '[attr.aria-disabled]': 'disabled || null',
        '[attr.data-state]': 'checked ? "checked" : "unchecked"'
    }
})
export class RdxContextMenuSelectable extends RdxContextMenuItemDirective {
    /** Whether the element is checked */
    @Input({ transform: booleanAttribute }) checked = false;

    @Output() readonly checkedChange = new EventEmitter<boolean>();
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/src/context-menu-item.directive.ts
```typescript
import { CDK_MENU, CdkMenuItem } from '@angular/cdk/menu';
import { booleanAttribute, Directive, ElementRef, EventEmitter, inject, Input, Output } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

import { RdxContextMenuContentDirective } from './context-menu-content.directive';

@Directive({
    selector: '[rdxContextMenuItem]',
    standalone: true,
    host: {
        type: 'button',
        '[attr.data-orientation]': '"vertical"',
        '[attr.data-highlighted]': 'highlighted ? "" : null',
        '[attr.data-disabled]': 'disabled ? "" : null',
        '[attr.disabled]': 'disabled ? "" : null',
        '(pointermove)': 'onPointerMove()',
        '(focus)': 'menu.highlighted.next(this)',
        '(keydown)': 'onKeydown($event)'
    },
    providers: [
        { provide: CdkMenuItem, useExisting: RdxContextMenuItemDirective },
        { provide: CDK_MENU, useExisting: RdxContextMenuContentDirective }
    ]
})
export class RdxContextMenuItemDirective extends CdkMenuItem {
    protected readonly menu = inject(RdxContextMenuContentDirective);
    protected readonly nativeElement = inject(ElementRef).nativeElement;

    highlighted = false;

    @Input({ transform: booleanAttribute }) override disabled = false;

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
        this.nativeElement.focus({ preventScroll: true });
        this.menu.updateActiveItem(this);
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
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/src/context-menu-label.directive.ts
```typescript
import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxContextMenuLabel]',
    standalone: true
})
export class RdxContextMenuLabelDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/src/context-menu-separator.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxSeparatorRootDirective } from '@radix-ng/primitives/separator';

@Directive({
    selector: '[rdxContextMenuSeparator]',
    standalone: true,
    hostDirectives: [RdxSeparatorRootDirective],
    host: {
        role: 'separator',
        '[attr.aria-orientation]': "'horizontal'"
    }
})
export class RdxContextMenuSeparatorDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/context-menu/src/context-menu-trigger.directive.ts
```typescript
import { CdkContextMenuTrigger, MENU_STACK, MENU_TRIGGER, MenuStack } from '@angular/cdk/menu';
import { ConnectedPosition } from '@angular/cdk/overlay';
import { booleanAttribute, Directive, Input, numberAttribute, TemplateRef } from '@angular/core';
import { outputFromObservable } from '@angular/core/rxjs-interop';

export enum ContextMenuSide {
    Top = 'top',
    Right = 'right',
    Bottom = 'bottom',
    Left = 'left'
}

const ContextMenuPositions: Record<ContextMenuSide, ConnectedPosition> = {
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

@Directive({
    selector: '[rdxContextMenuTrigger]',
    standalone: true,
    host: {
        '[attr.data-state]': "isOpen() ? 'open': 'closed'",
        '[attr.data-disabled]': "disabled ? '' : null",

        '(contextmenu)': '_openOnContextMenu($event)'
    },
    providers: [
        { provide: MENU_TRIGGER, useExisting: RdxContextMenuTriggerDirective },
        { provide: MENU_STACK, useClass: MenuStack }
    ]
})
export class RdxContextMenuTriggerDirective extends CdkContextMenuTrigger {
    override menuPosition = [{ ...ContextMenuPositions[ContextMenuSide.Bottom] }];

    @Input()
    set rdxContextMenuTrigger(value: TemplateRef<unknown> | null) {
        this.menuTemplateRef = value;
    }

    @Input({ transform: numberAttribute })
    set alignOffset(value: number) {
        this.defaultPosition.offsetX = value;
    }

    @Input({ transform: booleanAttribute }) override disabled = false;

    onOpenChange = outputFromObservable(this.opened);

    get defaultPosition(): ConnectedPosition {
        return this.menuPosition[0];
    }
}

```
