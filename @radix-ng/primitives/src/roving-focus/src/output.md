/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/roving-focus/src/roving-focus-group.directive.ts
```typescript
import {
    booleanAttribute,
    Directive,
    ElementRef,
    EventEmitter,
    inject,
    Input,
    NgZone,
    Output,
    signal
} from '@angular/core';
import { Direction, ENTRY_FOCUS, EVENT_OPTIONS, focusFirst, Orientation } from './utils';

@Directive({
    selector: '[rdxRovingFocusGroup]',
    standalone: true,
    host: {
        '[attr.data-orientation]': 'dataOrientation',
        '[attr.tabindex]': 'tabIndex',
        '[attr.dir]': 'dir',
        '(focus)': 'handleFocus($event)',
        '(blur)': 'handleBlur()',
        '(mouseup)': 'handleMouseUp()',
        '(mousedown)': 'handleMouseDown()',
        style: 'outline: none;'
    }
})
export class RdxRovingFocusGroupDirective {
    private readonly ngZone = inject(NgZone);
    private readonly elementRef = inject(ElementRef);

    @Input() orientation: Orientation | undefined;
    @Input() dir: Direction = 'ltr';
    @Input({ transform: booleanAttribute }) loop: boolean = true;
    @Input({ transform: booleanAttribute }) preventScrollOnEntryFocus: boolean = false;

    @Output() entryFocus = new EventEmitter<Event>();
    @Output() currentTabStopIdChange = new EventEmitter<string | null>();

    /** @ignore */
    readonly currentTabStopId = signal<string | null>(null);

    /** @ignore */
    readonly focusableItems = signal<HTMLElement[]>([]);

    private readonly isClickFocus = signal(false);
    private readonly isTabbingBackOut = signal(false);
    private readonly focusableItemsCount = signal(0);

    /** @ignore */
    get dataOrientation() {
        return this.orientation || 'horizontal';
    }

    /** @ignore */
    get tabIndex() {
        return this.isTabbingBackOut() || this.getFocusableItemsCount() === 0 ? -1 : 0;
    }

    /** @ignore */
    handleBlur() {
        this.isTabbingBackOut.set(false);
    }

    /** @ignore */
    handleMouseUp() {
        // reset `isClickFocus` after 1 tick because handleFocus might not triggered due to focused element
        this.ngZone.runOutsideAngular(() => {
            // eslint-disable-next-line promise/catch-or-return,promise/always-return
            Promise.resolve().then(() => {
                this.ngZone.run(() => {
                    this.isClickFocus.set(false);
                });
            });
        });
    }

    /** @ignore */
    handleFocus(event: FocusEvent) {
        // We normally wouldn't need this check, because we already check
        // that the focus is on the current target and not bubbling to it.
        // We do this because Safari doesn't focus buttons when clicked, and
        // instead, the wrapper will get focused and not through a bubbling event.
        const isKeyboardFocus = !this.isClickFocus();

        if (
            event.currentTarget === this.elementRef.nativeElement &&
            event.target === event.currentTarget &&
            isKeyboardFocus &&
            !this.isTabbingBackOut()
        ) {
            const entryFocusEvent = new CustomEvent(ENTRY_FOCUS, EVENT_OPTIONS);
            this.elementRef.nativeElement.dispatchEvent(entryFocusEvent);
            this.entryFocus.emit(entryFocusEvent);

            if (!entryFocusEvent.defaultPrevented) {
                const items = this.focusableItems().filter((item) => item.dataset['disabled'] !== '');
                const activeItem = items.find((item) => item.getAttribute('data-active') === 'true');
                const currentItem = items.find((item) => item.id === this.currentTabStopId());
                const candidateItems = [activeItem, currentItem, ...items].filter(Boolean) as HTMLElement[];

                focusFirst(candidateItems, this.preventScrollOnEntryFocus);
            }
        }
        this.isClickFocus.set(false);
    }

    /** @ignore */
    handleMouseDown() {
        this.isClickFocus.set(true);
    }

    /** @ignore */
    onItemFocus(tabStopId: string) {
        this.currentTabStopId.set(tabStopId);
        this.currentTabStopIdChange.emit(tabStopId);
    }

    /** @ignore */
    onItemShiftTab() {
        this.isTabbingBackOut.set(true);
    }

    /** @ignore */
    onFocusableItemAdd() {
        this.focusableItemsCount.update((count) => count + 1);
    }

    /** @ignore */
    onFocusableItemRemove() {
        this.focusableItemsCount.update((count) => Math.max(0, count - 1));
    }

    /** @ignore */
    registerItem(item: HTMLElement) {
        const currentItems = this.focusableItems();
        this.focusableItems.set([...currentItems, item]);
    }

    /** @ignore */
    unregisterItem(item: HTMLElement) {
        const currentItems = this.focusableItems();
        this.focusableItems.set(currentItems.filter((el) => el !== item));
    }

    /** @ignore */
    getFocusableItemsCount() {
        return this.focusableItemsCount();
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/roving-focus/src/roving-focus-item.directive.ts
```typescript
import {
    booleanAttribute,
    computed,
    Directive,
    ElementRef,
    inject,
    Input,
    NgZone,
    OnDestroy,
    OnInit
} from '@angular/core';
import { RdxRovingFocusGroupDirective } from './roving-focus-group.directive';
import { focusFirst, generateId, getFocusIntent, wrapArray } from './utils';

@Directive({
    selector: '[rdxRovingFocusItem]',
    standalone: true,
    host: {
        '[attr.tabindex]': 'tabIndex',
        '[attr.data-orientation]': 'parent.orientation',
        '[attr.data-active]': 'active',
        '[attr.data-disabled]': '!focusable ? "" : undefined',
        '(mousedown)': 'handleMouseDown($event)',
        '(keydown)': 'handleKeydown($event)',
        '(focus)': 'onFocus()'
    }
})
export class RdxRovingFocusItemDirective implements OnInit, OnDestroy {
    private readonly elementRef = inject(ElementRef);
    private readonly ngZone = inject(NgZone);
    protected readonly parent = inject(RdxRovingFocusGroupDirective);

    @Input({ transform: booleanAttribute }) focusable: boolean = true;
    @Input({ transform: booleanAttribute }) active: boolean = true;
    @Input() tabStopId: string;
    @Input({ transform: booleanAttribute }) allowShiftKey: boolean = false;

    private readonly id = computed(() => this.tabStopId || generateId());

    /** @ignore */
    readonly isCurrentTabStop = computed(() => this.parent.currentTabStopId() === this.id());

    /**
     * Lifecycle hook triggered on initialization.
     * Registers the element with the parent roving focus group if it is focusable.
     * @ignore
     */
    ngOnInit() {
        if (this.focusable) {
            this.parent.registerItem(this.elementRef.nativeElement);
            this.parent.onFocusableItemAdd();
        }
    }

    /**
     * Lifecycle hook triggered on destruction.
     * Unregisters the element from the parent roving focus group if it is focusable.
     * @ignore
     */
    ngOnDestroy() {
        if (this.focusable) {
            this.parent.unregisterItem(this.elementRef.nativeElement);
            this.parent.onFocusableItemRemove();
        }
    }

    /**
     * Determines the `tabIndex` of the element.
     * Returns `0` if the element is the current tab stop; otherwise, returns `-1`.
     * @ignore
     */
    get tabIndex() {
        return this.isCurrentTabStop() ? 0 : -1;
    }

    /** @ignore */
    handleMouseDown(event: MouseEvent) {
        if (!this.focusable) {
            // We prevent focusing non-focusable items on `mousedown`.
            // Even though the item has tabIndex={-1}, that only means take it out of the tab order.
            event.preventDefault();
        } else {
            // Safari doesn't focus a button when clicked so we run our logic on mousedown also
            this.parent.onItemFocus(this.id());
        }
    }

    /** @ignore */
    onFocus() {
        this.parent.onItemFocus(this.id());
    }

    /**
     * Handles the `keydown` event for keyboard navigation within the roving focus group.
     * Supports navigation based on orientation and direction, and focuses appropriate elements.
     *
     * @param event The `KeyboardEvent` object.
     * @ignore
     */
    handleKeydown(event: KeyboardEvent) {
        if (event.key === 'Tab' && event.shiftKey) {
            this.parent.onItemShiftTab();
            return;
        }

        if (event.target !== this.elementRef.nativeElement) return;

        const focusIntent = getFocusIntent(event, this.parent.orientation, this.parent.dir);

        if (focusIntent !== undefined) {
            if (event.metaKey || event.ctrlKey || event.altKey || (this.allowShiftKey ? false : event.shiftKey)) {
                return;
            }

            event.preventDefault();

            let candidateNodes = this.parent.focusableItems().filter((item) => item.dataset['disabled'] !== '');

            if (focusIntent === 'last') {
                candidateNodes.reverse();
            } else if (focusIntent === 'prev' || focusIntent === 'next') {
                if (focusIntent === 'prev') candidateNodes.reverse();
                const currentIndex = candidateNodes.indexOf(this.elementRef.nativeElement);

                candidateNodes = this.parent.loop
                    ? wrapArray(candidateNodes, currentIndex + 1)
                    : candidateNodes.slice(currentIndex + 1);
            }

            this.ngZone.runOutsideAngular(() => {
                // eslint-disable-next-line promise/always-return,promise/catch-or-return
                Promise.resolve().then(() => {
                    focusFirst(candidateNodes, false, this.elementRef.nativeElement);
                });
            });
        }
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/roving-focus/src/utils.ts
```typescript
export type Orientation = 'horizontal' | 'vertical';
export type Direction = 'ltr' | 'rtl';

export const ENTRY_FOCUS = 'rovingFocusGroup.onEntryFocus';
export const EVENT_OPTIONS = { bubbles: false, cancelable: true };

type FocusIntent = 'first' | 'last' | 'prev' | 'next';

export const MAP_KEY_TO_FOCUS_INTENT: Record<string, FocusIntent> = {
    ArrowLeft: 'prev',
    ArrowUp: 'prev',
    ArrowRight: 'next',
    ArrowDown: 'next',
    PageUp: 'first',
    Home: 'first',
    PageDown: 'last',
    End: 'last'
};

export function getDirectionAwareKey(key: string, dir?: Direction) {
    if (dir !== 'rtl') return key;
    return key === 'ArrowLeft' ? 'ArrowRight' : key === 'ArrowRight' ? 'ArrowLeft' : key;
}

export function getFocusIntent(event: KeyboardEvent, orientation?: Orientation, dir?: Direction) {
    const key = getDirectionAwareKey(event.key, dir);
    if (orientation === 'vertical' && ['ArrowLeft', 'ArrowRight'].includes(key)) return undefined;
    if (orientation === 'horizontal' && ['ArrowUp', 'ArrowDown'].includes(key)) return undefined;
    return MAP_KEY_TO_FOCUS_INTENT[key];
}

export function focusFirst(candidates: HTMLElement[], preventScroll = false, rootNode?: Document | ShadowRoot) {
    const PREVIOUSLY_FOCUSED_ELEMENT = rootNode?.activeElement ?? document.activeElement;
    for (const candidate of candidates) {
        // if focus is already where we want to go, we don't want to keep going through the candidates
        if (candidate === PREVIOUSLY_FOCUSED_ELEMENT) return;
        candidate.focus({ preventScroll });
        if (document.activeElement !== PREVIOUSLY_FOCUSED_ELEMENT) return;
    }
}

/**
 * Wraps an array around itself at a given start index
 * Example: `wrapArray(['a', 'b', 'c', 'd'], 2) === ['c', 'd', 'a', 'b']`
 */
export function wrapArray<T>(array: T[], startIndex: number) {
    return array.map((_, index) => array[(startIndex + index) % array.length]);
}

export function generateId(): string {
    return `rf-item-${Math.random().toString(36).slice(2, 11)}`;
}

```
