/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/accordion/README.md
```
# @radix-ng/primitives/accordion

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/accordion/index.ts
```typescript
import { NgModule } from '@angular/core';
import { RdxAccordionContentDirective } from './src/accordion-content.directive';
import { RdxAccordionHeaderDirective } from './src/accordion-header.directive';
import { RdxAccordionItemDirective } from './src/accordion-item.directive';
import { RdxAccordionRootDirective } from './src/accordion-root.directive';
import { RdxAccordionTriggerDirective } from './src/accordion-trigger.directive';

export * from './src/accordion-content.directive';
export * from './src/accordion-header.directive';
export * from './src/accordion-item.directive';
export * from './src/accordion-root.directive';
export * from './src/accordion-trigger.directive';

const _imports = [
    RdxAccordionContentDirective,
    RdxAccordionHeaderDirective,
    RdxAccordionItemDirective,
    RdxAccordionRootDirective,
    RdxAccordionTriggerDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxAccordionModule {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/accordion/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/accordion/src/accordion-content.directive.ts
```typescript
import { Directive, ElementRef, inject } from '@angular/core';
import { RdxAccordionItemDirective } from './accordion-item.directive';

@Directive({
    selector: '[rdxAccordionContent]',
    standalone: true,
    exportAs: 'rdxAccordionContent',
    host: {
        '[attr.role]': '"region"',
        '[style.display]': 'hidden ? "none" : ""',
        '[attr.data-state]': 'item.dataState',
        '[attr.data-disabled]': 'item.disabled',
        '[attr.data-orientation]': 'item.orientation',
        '(animationend)': 'onAnimationEnd()'
    }
})
export class RdxAccordionContentDirective {
    protected readonly item = inject(RdxAccordionItemDirective);
    protected readonly nativeElement = inject(ElementRef).nativeElement;

    protected hidden = false;

    protected onAnimationEnd() {
        this.hidden = !this.item.expanded;

        const { height, width } = this.nativeElement.getBoundingClientRect();

        this.nativeElement.style.setProperty('--radix-collapsible-content-height', `${height}px`);
        this.nativeElement.style.setProperty('--radix-collapsible-content-width', `${width}px`);

        this.nativeElement.style.setProperty(
            '--radix-accordion-content-height',
            'var(--radix-collapsible-content-height)'
        );
        this.nativeElement.style.setProperty(
            '--radix-accordion-content-width',
            'var(--radix-collapsible-content-width)'
        );
    }

    onToggle() {
        if (!this.item.expanded) {
            this.hidden = false;
        }
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/accordion/src/accordion-header.directive.ts
```typescript
import { Directive, inject } from '@angular/core';
import { RdxAccordionItemDirective } from './accordion-item.directive';

@Directive({
    selector: '[rdxAccordionHeader]',
    standalone: true,
    host: {
        '[attr.data-state]': 'item.dataState',
        '[attr.data-disabled]': 'item.disabled',
        '[attr.data-orientation]': 'item.orientation'
    }
})
export class RdxAccordionHeaderDirective {
    protected readonly item = inject(RdxAccordionItemDirective);
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/accordion/src/accordion-item.directive.ts
```typescript
import { FocusableOption } from '@angular/cdk/a11y';
import { UniqueSelectionDispatcher } from '@angular/cdk/collections';
import {
    booleanAttribute,
    ChangeDetectorRef,
    ContentChild,
    Directive,
    EventEmitter,
    forwardRef,
    inject,
    Input,
    OnDestroy,
    Output
} from '@angular/core';
import { Subscription } from 'rxjs';
import { RdxAccordionContentDirective } from './accordion-content.directive';
import { RdxAccordionOrientation, RdxAccordionRootToken } from './accordion-root.directive';
import { RdxAccordionTriggerDirective } from './accordion-trigger.directive';

export type RdxAccordionItemState = 'open' | 'closed';

let nextId = 0;

/**
 * @group Components
 */
@Directive({
    selector: '[rdxAccordionItem]',
    standalone: true,
    exportAs: 'rdxAccordionItem',
    host: {
        '[attr.data-state]': 'dataState',
        '[attr.data-disabled]': 'disabled',
        '[attr.data-orientation]': 'orientation'
    },
    providers: [
        { provide: RdxAccordionRootToken, useValue: undefined }]
})
export class RdxAccordionItemDirective implements FocusableOption, OnDestroy {
    protected readonly accordion = inject(RdxAccordionRootToken, { skipSelf: true });

    protected readonly changeDetectorRef = inject(ChangeDetectorRef);

    protected readonly expansionDispatcher = inject(UniqueSelectionDispatcher);

    /**
     * @ignore
     */
    @ContentChild(RdxAccordionTriggerDirective, { descendants: true }) trigger: RdxAccordionTriggerDirective;

    /**
     * @ignore
     */
    @ContentChild(forwardRef(() => RdxAccordionContentDirective), { descendants: true })
    content: RdxAccordionContentDirective;

    get dataState(): RdxAccordionItemState {
        return this.expanded ? 'open' : 'closed';
    }

    /**
     * The unique AccordionItem id.
     * @ignore
     */
    readonly id: string = `rdx-accordion-item-${nextId++}`;

    get orientation(): RdxAccordionOrientation {
        return this.accordion.orientation;
    }

    /**
     * @defaultValue false
     * @group Props
     */
    @Input({ transform: booleanAttribute })
    set expanded(expanded: boolean) {
        // Only emit events and update the internal value if the value changes.
        if (this._expanded !== expanded) {
            this._expanded = expanded;
            this.expandedChange.emit(expanded);

            if (expanded) {
                this.opened.emit();
                /**
                 * In the unique selection dispatcher, the id parameter is the id of the CdkAccordionItem,
                 * the name value is the id of the accordion.
                 */
                const accordionId = this.accordion ? this.accordion.id : this.value;
                this.expansionDispatcher.notify(this.value, accordionId);
            } else {
                this.closed.emit();
            }

            // Ensures that the animation will run when the value is set outside of an `@Input`.
            // This includes cases like the open, close and toggle methods.
            this.changeDetectorRef.markForCheck();
        }
    }

    get expanded(): boolean {
        return this._expanded;
    }

    private _expanded = false;

    /**
     * Accordion value.
     *
     * @group Props
     */
    @Input() set value(value: string) {
        this._value = value;
    }

    get value(): string {
        return this._value || this.id;
    }

    private _value?: string;

    /**
     * Whether the AccordionItem is disabled.
     *
     * @defaultValue false
     * @group Props
     */
    @Input({ transform: booleanAttribute }) set disabled(value: boolean) {
        this._disabled = value;
    }

    get disabled(): boolean {
        return this.accordion.disabled ?? this._disabled;
    }

    private _disabled = false;

    /**
     * Event emitted every time the AccordionItem is closed.
     */
    @Output() readonly closed: EventEmitter<void> = new EventEmitter<void>();

    /** Event emitted every time the AccordionItem is opened. */
    @Output() readonly opened: EventEmitter<void> = new EventEmitter<void>();

    /**
     * Event emitted when the AccordionItem is destroyed.
     * @ignore
     */
    readonly destroyed: EventEmitter<void> = new EventEmitter<void>();

    /**
     * Emits whenever the expanded state of the accordion changes.
     * Primarily used to facilitate two-way binding.
     * @group Emits
     */
    @Output() readonly expandedChange: EventEmitter<boolean> = new EventEmitter<boolean>();

    /** Unregister function for expansionDispatcher. */
    private removeUniqueSelectionListener: () => void;

    /** Subscription to openAll/closeAll events. */
    private openCloseAllSubscription = Subscription.EMPTY;

    constructor() {
        this.removeUniqueSelectionListener = this.expansionDispatcher.listen((id: string, accordionId: string) => {
            if (this.accordion.isMultiple) {
                if (this.accordion.id === accordionId && id.includes(this.value)) {
                    this.expanded = true;
                }
            } else {
                this.expanded = this.accordion.id === accordionId && id.includes(this.value);
            }
        });

        // When an accordion item is hosted in an accordion, subscribe to open/close events.
        if (this.accordion) {
            this.openCloseAllSubscription = this.subscribeToOpenCloseAllActions();
        }
    }

    /** Emits an event for the accordion item being destroyed. */
    ngOnDestroy() {
        this.opened.complete();
        this.closed.complete();
        this.destroyed.emit();
        this.destroyed.complete();
        this.removeUniqueSelectionListener();
        this.openCloseAllSubscription.unsubscribe();
    }

    focus(): void {
        this.trigger.focus();
    }

    /** Toggles the expanded state of the accordion item. */
    toggle(): void {
        if (!this.disabled) {
            this.content.onToggle();

            this.expanded = !this.expanded;
        }
    }

    /** Sets the expanded state of the accordion item to false. */
    close(): void {
        if (!this.disabled) {
            this.expanded = false;
        }
    }

    /** Sets the expanded state of the accordion item to true. */
    open(): void {
        if (!this.disabled) {
            this.expanded = true;
        }
    }

    private subscribeToOpenCloseAllActions(): Subscription {
        return this.accordion.openCloseAllActions.subscribe((expanded) => {
            // Only change expanded state if item is enabled
            if (!this.disabled) {
                this.expanded = expanded;
            }
        });
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/accordion/src/accordion-root.directive.ts
```typescript
import { FocusKeyManager } from '@angular/cdk/a11y';
import { Directionality } from '@angular/cdk/bidi';
import { UniqueSelectionDispatcher } from '@angular/cdk/collections';
import { ENTER, SPACE, TAB } from '@angular/cdk/keycodes';
import {
    AfterContentInit,
    booleanAttribute,
    ContentChildren,
    Directive,
    EventEmitter,
    forwardRef,
    inject,
    InjectionToken,
    Input,
    OnDestroy,
    Output,
    QueryList
} from '@angular/core';
import { merge, Subject, Subscription } from 'rxjs';
import { RdxAccordionItemDirective } from './accordion-item.directive';

export type RdxAccordionType = 'single' | 'multiple';
export type RdxAccordionOrientation = 'horizontal' | 'vertical';

export const RdxAccordionRootToken = new InjectionToken<RdxAccordionRootDirective>('RdxAccordionRootDirective');

let nextId = 0;

/**
 * @group Components
 */
@Directive({
    selector: '[rdxAccordionRoot]',
    standalone: true,
    providers: [
        { provide: RdxAccordionRootToken, useExisting: RdxAccordionRootDirective },
        { provide: UniqueSelectionDispatcher, useClass: UniqueSelectionDispatcher }
    ],
    host: {
        '[attr.data-orientation]': 'orientation',
        '(keydown)': 'handleKeydown($event)'
    }
})
export class RdxAccordionRootDirective implements AfterContentInit, OnDestroy {
    /**
     * @ignore
     */
    protected readonly selectionDispatcher = inject(UniqueSelectionDispatcher);
    /**
     * @ignore
     */
    protected readonly dir = inject(Directionality, { optional: true });

    /**
     * @ignore
     */
    protected keyManager: FocusKeyManager<RdxAccordionItemDirective>;

    /**
     * @ignore
     */
    readonly id: string = `rdx-accordion-${nextId++}`;

    /**
     * @ignore
     */
    readonly openCloseAllActions = new Subject<boolean>();

    get isMultiple(): boolean {
        return this.type === 'multiple';
    }

    /** Whether the Accordion is disabled.
     * @defaultValue false
     * @group Props
     */
    @Input({ transform: booleanAttribute }) disabled: boolean;

    /**
     * The orientation of the accordion.
     *
     * @defaultValue 'vertical'
     * @group Props
     */
    @Input() orientation: RdxAccordionOrientation = 'vertical';
    /**
     * @private
     * @ignore
     */
    @ContentChildren(forwardRef(() => RdxAccordionItemDirective), { descendants: true })
    items: QueryList<RdxAccordionItemDirective>;

    /**
     * The value of the item to expand when initially rendered and type is "single".
     * Use when you do not need to control the state of the items.
     * @group Props
     */
    @Input()
    set defaultValue(value: string[] | string) {
        if (value !== this._defaultValue) {
            this._defaultValue = Array.isArray(value) ? value : [value];
        }
    }

    get defaultValue(): string[] | string {
        return this.isMultiple ? this._defaultValue : this._defaultValue[0];
    }

    /**
     * Determines whether one or multiple items can be opened at the same time.
     * @group Props
     * @defaultValue 'single'
     */
    @Input() type: RdxAccordionType = 'single';

    /**
     * @ignore
     */
    @Input() collapsible = true;

    /**
     * The controlled value of the item to expand.
     *
     * @group Props
     */
    @Input()
    set value(value: string[] | string) {
        if (value !== this._value) {
            this._value = Array.isArray(value) ? value : [value];

            this.selectionDispatcher.notify(this.value as unknown as string, this.id);
        }
    }

    get value(): string[] | string {
        if (this._value === undefined) {
            return this.defaultValue;
        }

        return this.isMultiple ? this._value : this._value[0];
    }

    /**
     * Event handler called when the expanded state of an item changes and type is "multiple".
     * @group Emits
     */
    @Output() readonly onValueChange: EventEmitter<void> = new EventEmitter<void>();

    private _value?: string[];
    private _defaultValue: string[] | string = [];

    private onValueChangeSubscription: Subscription;

    /**
     * @ignore
     */
    ngAfterContentInit(): void {
        this.selectionDispatcher.notify((this._value ?? this._defaultValue) as unknown as string, this.id);

        this.keyManager = new FocusKeyManager(this.items).withHomeAndEnd();

        if (this.orientation === 'horizontal') {
            this.keyManager.withHorizontalOrientation(this.dir?.value || 'ltr');
        } else {
            this.keyManager.withVerticalOrientation();
        }

        this.onValueChangeSubscription = merge(...this.items.map((item) => item.expandedChange)).subscribe(() =>
            this.onValueChange.emit()
        );
    }

    /**
     * @ignore
     */
    ngOnDestroy() {
        this.openCloseAllActions.complete();
        this.onValueChangeSubscription.unsubscribe();
    }

    /**
     * @ignore
     */
    handleKeydown(event: KeyboardEvent) {
        if (!this.keyManager.activeItem) {
            this.keyManager.setFirstItemActive();
        }

        const activeItem = this.keyManager.activeItem;

        if (
            (event.keyCode === ENTER || event.keyCode === SPACE) &&
            !this.keyManager.isTyping() &&
            activeItem &&
            !activeItem.disabled
        ) {
            event.preventDefault();
            activeItem.toggle();
        } else if (event.keyCode === TAB && event.shiftKey) {
            if (this.keyManager.activeItemIndex === 0) return;

            this.keyManager.setPreviousItemActive();
            event.preventDefault();
        } else if (event.keyCode === TAB) {
            if (this.keyManager.activeItemIndex === this.items.length - 1) return;

            this.keyManager.setNextItemActive();
            event.preventDefault();
        } else {
            this.keyManager.onKeydown(event);
        }
    }

    /** Opens all enabled accordion items in an accordion where multi is enabled.
     * @ignore
     */
    openAll(): void {
        if (this.isMultiple) {
            this.openCloseAllActions.next(true);
        }
    }

    /** Closes all enabled accordion items.
     * @ignore
     */
    closeAll(): void {
        this.openCloseAllActions.next(false);
    }

    /**
     * @ignore
     */
    setActiveItem(item: RdxAccordionItemDirective) {
        this.keyManager.setActiveItem(item);
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/accordion/src/accordion-trigger.directive.ts
```typescript
import { Directive, ElementRef, inject } from '@angular/core';
import { RdxAccordionItemDirective } from './accordion-item.directive';
import { RdxAccordionRootDirective } from './accordion-root.directive';

@Directive({
    selector: '[rdxAccordionTrigger]',
    standalone: true,
    host: {
        '[attr.role]': '"button"',
        '[attr.aria-expanded]': 'item.expanded',
        '[attr.data-state]': 'item.dataState',
        '[attr.data-disabled]': 'item.disabled',
        '[attr.disabled]': 'item.disabled ? "" : null',
        '[attr.data-orientation]': 'item.orientation',
        '(click)': 'onClick()'
    }
})
export class RdxAccordionTriggerDirective {
    protected readonly nativeElement = inject(ElementRef).nativeElement;
    protected readonly accordionRoot = inject(RdxAccordionRootDirective);
    protected readonly item = inject(RdxAccordionItemDirective);

    /**
     * Fires when trigger clicked
     */
    onClick(): void {
        if (!this.accordionRoot.collapsible && this.item.expanded) return;

        this.item.toggle();

        this.accordionRoot.setActiveItem(this.item);
    }

    focus() {
        this.nativeElement.focus();
    }
}

```
