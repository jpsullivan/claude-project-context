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
