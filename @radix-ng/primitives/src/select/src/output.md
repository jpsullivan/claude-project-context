/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/select/src/select-content.directive.ts
```typescript
import { ActiveDescendantKeyManager } from '@angular/cdk/a11y';
import { Directionality } from '@angular/cdk/bidi';
import { AfterContentInit, ContentChildren, DestroyRef, Directive, inject, QueryList } from '@angular/core';
import { pairwise, startWith, Subject } from 'rxjs';
import { RdxSelectItemDirective } from './select-item.directive';
import { RdxSelectComponent } from './select.component';

@Directive({
    selector: '[rdxSelectContent]',
    standalone: true,
    exportAs: 'rdxSelectContent',
    host: {
        '[attr.role]': '"listbox"',
        '[attr.data-state]': "select.open ? 'open': 'closed'",
        '[attr.data-side]': 'true',
        '[attr.data-align]': 'true',
        '(keydown)': 'keyManager.onKeydown($event)'
    }
})
export class RdxSelectContentDirective implements AfterContentInit {
    protected readonly destroyRef = inject(DestroyRef);
    protected readonly dir = inject(Directionality, { optional: true });
    protected select = inject(RdxSelectComponent);

    readonly highlighted = new Subject<RdxSelectItemDirective>();

    keyManager: ActiveDescendantKeyManager<RdxSelectItemDirective>;

    @ContentChildren(RdxSelectItemDirective, { descendants: true })
    options: QueryList<RdxSelectItemDirective>;

    constructor() {
        this.highlighted.pipe(startWith(null), pairwise()).subscribe(([prev, item]) => {
            if (prev) {
                prev.highlighted = false;
            }

            if (item) {
                item.highlighted = true;
            }
        });
    }

    initKeyManager() {
        return new ActiveDescendantKeyManager<RdxSelectItemDirective>(this.options)
            .withTypeAhead()
            .withVerticalOrientation()
            .withHorizontalOrientation(this.dir?.value ?? 'ltr');
    }

    ngAfterContentInit(): void {
        this.keyManager = this.initKeyManager();
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/select/src/select-group.directive.ts
```typescript
import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxSelectGroup]',
    standalone: true,
    exportAs: 'rdxSelectGroup',
    host: {
        '[attr.role]': '"group"'
    }
})
export class RdxSelectGroupDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/select/src/select-icon.directive.ts
```typescript
import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxSelectIcon]',
    standalone: true,
    exportAs: 'rdxSelectIcon',
    host: {
        '[attr.aria-hidden]': 'true'
    }
})
export class RdxSelectIconDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/select/src/select-item-indicator.directive.ts
```typescript
import { Directive, inject } from '@angular/core';
import { RdxSelectItemDirective } from './select-item.directive';

@Directive({
    selector: '[rdxSelectItemIndicator]',
    standalone: true,
    exportAs: 'rdxSelectItemIndicator',
    host: {
        '[attr.aria-hidden]': 'true',
        '[style.display]': 'item.selected ? "" : "none"'
    }
})
export class RdxSelectItemIndicatorDirective {
    protected item = inject(RdxSelectItemDirective);
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/select/src/select-item.directive.ts
```typescript
import { Highlightable } from '@angular/cdk/a11y';
import { ENTER, SPACE } from '@angular/cdk/keycodes';
import { booleanAttribute, Directive, ElementRef, EventEmitter, inject, Input } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { RdxSelectContentDirective } from './select-content.directive';
import { RdxSelectComponent } from './select.component';

let nextId = 0;

export class RdxSelectItemChange<T = RdxSelectItemDirective> {
    constructor(public source: T) {}
}

@Directive({
    selector: '[rdxSelectItem]',
    standalone: true,
    exportAs: 'rdxSelectItem',
    host: {
        '[attr.role]': '"option"',
        '[attr.data-state]': 'dataState',
        '[attr.aria-selected]': 'selected',
        '[attr.data-disabled]': 'disabled || null',
        '[attr.data-highlighted]': 'highlighted || null',
        '[attr.tabindex]': '-1',
        '(focus)': 'content.highlighted.next(this)',
        '(click)': 'selectViaInteraction()',
        '(keydown)': 'handleKeydown($event)',
        '(pointermove)': 'onPointerMove()'
    }
})
export class RdxSelectItemDirective implements Highlightable {
    protected readonly select = inject(RdxSelectComponent);
    protected readonly content = inject(RdxSelectContentDirective);
    readonly onSelectionChange = new EventEmitter<RdxSelectItemChange>();
    protected readonly nativeElement = inject(ElementRef).nativeElement;

    highlighted: boolean = false;

    selected: boolean;

    get dataState(): string {
        return this.selected ? 'checked' : 'unchecked';
    }

    /**
     * The unique SelectItem id.
     * @ignore
     */
    readonly id: string = `rdx-select-item-${nextId++}`;

    @Input()
    set value(value: string) {
        this._value = value;
    }

    get value(): string {
        return this._value || this.id;
    }

    private _value?: string;

    @Input() textValue: string | null = null;

    /** Whether the SelectItem is disabled. */
    @Input({ transform: booleanAttribute })
    set disabled(value: boolean) {
        this._disabled = value;
    }

    get disabled(): boolean {
        return this._disabled;
    }

    private _disabled: boolean;

    get viewValue(): string {
        return this.textValue ?? this.nativeElement.textContent;
    }

    constructor() {
        this.content.highlighted.pipe(takeUntilDestroyed()).subscribe((value) => {
            if (value !== this) {
                this.highlighted = false;
            }
        });
    }

    /** Gets the label to be used when determining whether the option should be focused.
     * @ignore
     */
    getLabel(): string {
        return this.viewValue;
    }

    /**
     * `Selects the option while indicating the selection came from the user. Used to
     * determine if the select's view -> model callback should be invoked.`
     * @ignore
     */
    selectViaInteraction(): void {
        if (!this.disabled) {
            this.selected = true;

            this.onSelectionChange.emit(new RdxSelectItemChange(this));
        }
    }

    /** @ignore */
    handleKeydown(event: KeyboardEvent): void {
        if (event.keyCode === ENTER || event.keyCode === SPACE) {
            this.selectViaInteraction();

            // Prevent the page from scrolling down and form submits.
            event.preventDefault();
            event.stopPropagation();
        }
    }

    /** @ignore */
    setActiveStyles(): void {
        this.highlighted = true;
        this.nativeElement.focus({ preventScroll: true });
    }

    /** @ignore */
    setInactiveStyles(): void {
        this.highlighted = false;
    }

    protected onPointerMove(): void {
        if (!this.highlighted) {
            this.nativeElement.focus({ preventScroll: true });
            this.select.updateActiveItem(this);
        }
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/select/src/select-label.directive.ts
```typescript
import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxSelectLabel]',
    standalone: true,
    exportAs: 'rdxSelectLabel'
})
export class RdxSelectLabelDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/select/src/select-separator.directive.ts
```typescript
import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxSelectSeparator]',
    standalone: true,
    exportAs: 'rdxSelectSeparator',
    host: {
        '[attr.aria-hidden]': 'true'
    }
})
export class RdxSelectSeparatorDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/select/src/select-trigger.directive.ts
```typescript
import { ContentChild, Directive, ElementRef, inject } from '@angular/core';
import { RdxSelectValueDirective } from './select-value.directive';
import { RdxSelectComponent } from './select.component';

@Directive({
    selector: '[rdxSelectTrigger]',
    standalone: true,
    host: {
        '[attr.type]': '"button"',
        '[attr.role]': '"combobox"',
        '[attr.aria-autocomplete]': '"none"',
        '[attr.dir]': 'select.dir.value',
        '[attr.aria-expanded]': 'select.open',
        '[attr.aria-required]': 'select.required',

        '[attr.disabled]': 'select.disabled ? "" : null',
        '[attr.data-disabled]': 'select.disabled ? "" : null',
        '[attr.data-state]': "select.open ? 'open': 'closed'",
        '[attr.data-placeholder]': 'value.placeholder || null'
    }
})
export class RdxSelectTriggerDirective {
    protected nativeElement = inject(ElementRef).nativeElement;
    protected select = inject(RdxSelectComponent);

    @ContentChild(RdxSelectValueDirective) protected value: RdxSelectValueDirective;

    focus() {
        this.nativeElement.focus();
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/select/src/select-value.directive.ts
```typescript
import { Component, inject, Input } from '@angular/core';
import { RdxSelectComponent } from './select.component';

@Component({
    selector: '[rdxSelectValue]',
    standalone: true,
    exportAs: 'rdxSelectValue',
    template: `
        {{ select.selectionModel.isEmpty() ? placeholder : select.selected }}
    `,
    styles: `
        /* we don't want events from the children to bubble through the item they came from */
        :host {
            pointer-events: none;
        }
    `
})
export class RdxSelectValueDirective {
    select = inject(RdxSelectComponent);

    @Input() placeholder: string;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/select/src/select.component.ts
```typescript
import { ActiveDescendantKeyManager } from '@angular/cdk/a11y';
import { Directionality } from '@angular/cdk/bidi';
import { SelectionModel } from '@angular/cdk/collections';
import { CdkConnectedOverlay, ConnectedPosition, Overlay, OverlayModule } from '@angular/cdk/overlay';
import {
    AfterContentInit,
    booleanAttribute,
    ChangeDetectorRef,
    Component,
    ContentChild,
    ContentChildren,
    DestroyRef,
    ElementRef,
    EventEmitter,
    forwardRef,
    inject,
    Input,
    NgZone,
    OnInit,
    Output,
    QueryList,
    ViewChild
} from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { defer, delay, merge, Observable, Subscription, switchMap, take } from 'rxjs';
import { RdxSelectContentDirective } from './select-content.directive';
import { RdxSelectItemChange, RdxSelectItemDirective } from './select-item.directive';
import { RdxSelectTriggerDirective } from './select-trigger.directive';

let nextId = 0;

@Component({
    selector: '[rdxSelect]',
    template: `
        <ng-content select="[rdxSelectTrigger]" />

        <ng-template
            [cdkConnectedOverlayOpen]="open"
            [cdkConnectedOverlayOrigin]="elementRef"
            [cdkConnectedOverlayPositions]="positions"
            [cdkConnectedOverlayScrollStrategy]="overlay.scrollStrategies.reposition()"
            (attach)="onAttached()"
            (backdropClick)="close()"
            (detach)="onDetach()"
            cdkConnectedOverlay
        >
            <ng-content select="[rdxSelectContent]" />
        </ng-template>
    `,
    host: {
        '(click)': 'toggle()',
        '(keydown)': 'content.keyManager.onKeydown($event)'
    },
    imports: [
        OverlayModule
    ]
})
export class RdxSelectComponent implements OnInit, AfterContentInit {
    protected overlay = inject(Overlay);
    protected elementRef = inject(ElementRef);
    protected changeDetectorRef = inject(ChangeDetectorRef);
    private readonly destroyRef = inject(DestroyRef);
    private readonly ngZone = inject(NgZone);

    @ContentChild(RdxSelectTriggerDirective) protected trigger: RdxSelectTriggerDirective;

    @ContentChild(forwardRef(() => RdxSelectContentDirective))
    protected content: RdxSelectContentDirective;

    @ContentChildren(forwardRef(() => RdxSelectItemDirective), { descendants: true })
    items: QueryList<RdxSelectItemDirective>;

    @ViewChild(CdkConnectedOverlay, { static: false }) overlayDir: CdkConnectedOverlay;

    /** Deals with the selection logic. */
    selectionModel: SelectionModel<RdxSelectItemDirective>;

    /**
     * This position config ensures that the top "start" corner of the overlay
     * is aligned with the top "start" of the origin by default (overlapping
     * the trigger completely). If the panel cannot fit below the trigger, it
     * will fall back to a position above the trigger.
     */
    positions: ConnectedPosition[] = [
        {
            originX: 'start',
            originY: 'bottom',
            overlayX: 'start',
            overlayY: 'top'
        },
        {
            originX: 'start',
            originY: 'top',
            overlayX: 'start',
            overlayY: 'bottom'
        }
    ];

    private closeSubscription = Subscription.EMPTY;

    /**
     * @ignore
     */
    readonly dir = inject(Directionality, { optional: true });

    /**
     * @ignore
     */
    protected keyManager: ActiveDescendantKeyManager<RdxSelectItemDirective>;

    /**
     * @ignore
     */
    readonly id: string = `rdx-select-${nextId++}`;

    @Input() defaultValue: string;
    @Input() name: string;

    @Input({ transform: booleanAttribute }) defaultOpen: boolean;

    @Input({ transform: booleanAttribute }) open: boolean = false;

    /** Whether the Select is disabled. */
    @Input({ transform: booleanAttribute }) disabled: boolean;

    @Input({ transform: booleanAttribute }) required: boolean;

    /**
     * The controlled value of the item to expand
     */
    @Input()
    set value(value: string) {
        if (this._value !== value) {
            this._value = value;

            this.selectValue(value);

            this.changeDetectorRef.markForCheck();
        }
    }

    get value(): string | null {
        return this._value ?? this.defaultValue;
    }

    private _value?: string;

    @Output() readonly onValueChange: EventEmitter<string> = new EventEmitter<string>();

    @Output() readonly onOpenChange: EventEmitter<boolean> = new EventEmitter<boolean>();

    readonly optionSelectionChanges: Observable<RdxSelectItemChange> = defer(() => {
        if (this.content.options) {
            return merge(...this.content.options.map((option) => option.onSelectionChange));
        }

        return this.ngZone.onStable.asObservable().pipe(
            take(1),
            switchMap(() => this.optionSelectionChanges)
        );
    }) as Observable<RdxSelectItemChange>;

    get selected(): string | null {
        return this.selectionModel.selected[0].viewValue || null;
    }

    ngOnInit() {
        this.selectionModel = new SelectionModel<RdxSelectItemDirective>();

        this.selectionModel.changed.subscribe((changes) => {
            if (changes.added.length) {
                this.onValueChange.emit(this.selectionModel.selected[0].value);
            }

            if (changes.removed.length) {
                changes.removed.forEach((item) => (item.selected = false));
            }
        });
    }

    ngAfterContentInit() {
        this.selectDefaultValue();

        this.optionSelectionChanges.subscribe((event) => {
            this.selectionModel.clear();

            this.selectionModel.select(event.source);

            this.close();
            this.trigger.focus();
        });

        this.content.keyManager.tabOut.subscribe(() => {
            if (this.open) this.close();
        });

        if (this.defaultOpen) {
            this.openPanel();
        }
    }

    /**
     * Callback that is invoked when the overlay panel has been attached.
     */
    onAttached(): void {
        this.closeSubscription = this.closingActions()
            .pipe(takeUntilDestroyed(this.destroyRef))
            .pipe(delay(0))
            .subscribe(() => this.close());
    }

    onDetach() {
        this.close();
        this.closeSubscription.unsubscribe();
    }

    /** Toggles the overlay panel open or closed. */
    toggle(): void {
        if (this.open) {
            this.close();
        } else {
            this.openPanel();
        }
    }

    openPanel() {
        this.open = true;

        this.onOpenChange.emit(this.open);
    }

    close() {
        this.open = false;

        this.onOpenChange.emit(this.open);
    }

    updateActiveItem(item: RdxSelectItemDirective) {
        this.content.keyManager.updateActiveItem(item);
    }

    private selectDefaultValue(): void {
        if (!this.defaultValue) return;

        this.selectValue(this.defaultValue);
    }

    private selectValue(value: string): void {
        const option = this.content?.options.find((option) => option.value === value);

        if (option) {
            option.selected = true;
            option.highlighted = true;

            this.selectionModel.select(option);
            this.updateActiveItem(option);
        }
    }

    private closingActions() {
        return merge(this.overlayDir.overlayRef!.outsidePointerEvents(), this.overlayDir.overlayRef!.detachments());
    }
}

```
