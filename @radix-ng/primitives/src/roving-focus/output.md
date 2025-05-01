/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/roving-focus/README.md
```
# @radix-ng/primitives/roving-focus

Secondary entry point of `@radix-ng/primitives`.

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/roving-focus/index.ts
```typescript
export * from './src/roving-focus-group.directive';
export * from './src/roving-focus-item.directive';

export type { Direction, Orientation } from './src/utils';

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/roving-focus/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/roving-focus/__test__/roving-focus-group.spec.ts
```typescript
import { Component } from '@angular/core';
import { fakeAsync, TestBed, tick } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { RdxRovingFocusGroupDirective } from '@radix-ng/primitives/roving-focus';

@Component({
    selector: 'test-host',
    standalone: true,
    template: `
        <div rdxRovingFocusGroup>
            <button id="item1">Item 1</button>
            <button id="item2">Item 2</button>
            <button id="item3">Item 3</button>
        </div>
    `,
    imports: [RdxRovingFocusGroupDirective]
})
class TestHostComponent {}

describe('RdxRovingFocusGroupDirective', () => {
    beforeEach(() => {
        TestBed.configureTestingModule({
            imports: [TestHostComponent]
        });
    });

    it('should create the directive', () => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const hostElement = fixture.nativeElement.querySelector('[rdxRovingFocusGroup]');
        expect(hostElement).toBeTruthy();
    });

    it('should correctly handle focus logic', () => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const hostElement = fixture.nativeElement.querySelector('[rdxRovingFocusGroup]');
        const buttons = hostElement.querySelectorAll('button');

        // Simulate focus on the first button
        buttons[0].focus();
        expect(document.activeElement).toBe(buttons[0]);

        // Simulate navigation to the second button
        buttons[1].focus();
        expect(document.activeElement).toBe(buttons[1]);
    });

    it('should handle `onItemFocus` and update currentTabStopId', () => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const directiveInstance = fixture.debugElement
            .query(By.directive(RdxRovingFocusGroupDirective))
            .injector.get(RdxRovingFocusGroupDirective);

        directiveInstance.onItemFocus('item1');
        expect(directiveInstance.currentTabStopId()).toBe('item1');

        directiveInstance.onItemFocus('item2');
        expect(directiveInstance.currentTabStopId()).toBe('item2');
    });

    it('should emit currentTabStopIdChange on item focus', () => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const directiveInstance = fixture.debugElement
            .query(By.directive(RdxRovingFocusGroupDirective))
            .injector.get(RdxRovingFocusGroupDirective);

        const spy = jest.spyOn(directiveInstance.currentTabStopIdChange, 'emit');

        directiveInstance.onItemFocus('item1');
        expect(spy).toHaveBeenCalledWith('item1');
    });

    it('should register and unregister focusable items correctly', () => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const directiveInstance = fixture.debugElement
            .query(By.directive(RdxRovingFocusGroupDirective))
            .injector.get(RdxRovingFocusGroupDirective);

        const item = document.createElement('div');
        directiveInstance.registerItem(item);
        expect(directiveInstance.focusableItems()).toContain(item);

        directiveInstance.unregisterItem(item);
        expect(directiveInstance.focusableItems()).not.toContain(item);
    });

    it('should handle `onFocusableItemAdd` and `onFocusableItemRemove` correctly', () => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const directiveInstance = fixture.debugElement
            .query(By.directive(RdxRovingFocusGroupDirective))
            .injector.get(RdxRovingFocusGroupDirective);

        directiveInstance.onFocusableItemAdd();
        expect(directiveInstance.getFocusableItemsCount()).toBe(1);

        directiveInstance.onFocusableItemRemove();
        expect(directiveInstance.getFocusableItemsCount()).toBe(0);
    });

    it('should handle `handleMouseDown` and set `isClickFocus` indirectly', () => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const directiveInstance = fixture.debugElement
            .query(By.directive(RdxRovingFocusGroupDirective))
            .injector.get(RdxRovingFocusGroupDirective);

        directiveInstance.handleMouseDown();

        // Use the public behavior to infer the private state change
        // For example, call a method that uses isClickFocus.
        expect(directiveInstance['isClickFocus']()).toBe(true);
    });

    it('should reset `isClickFocus` on mouse up', fakeAsync(() => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const directiveInstance = fixture.debugElement
            .query(By.directive(RdxRovingFocusGroupDirective))
            .injector.get(RdxRovingFocusGroupDirective);

        directiveInstance.handleMouseDown();
        directiveInstance.handleMouseUp();

        tick();

        expect(directiveInstance['isClickFocus']()).toBe(false);
    }));
});

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/roving-focus/stories/roving-focus-events.component.ts
```typescript
import { Component } from '@angular/core';
import { RdxRovingFocusGroupDirective, RdxRovingFocusItemDirective } from '@radix-ng/primitives/roving-focus';

@Component({
    selector: 'rvg-events',
    imports: [RdxRovingFocusItemDirective, RdxRovingFocusGroupDirective],
    template: `
        <div
            [orientation]="'horizontal'"
            [loop]="true"
            (entryFocus)="onEntryFocus($event)"
            (currentTabStopIdChange)="onTabStopChange($event)"
            rdxRovingFocusGroup
        >
            <button rdxRovingFocusItem tabStopId="item1">Item 1</button>
            <button rdxRovingFocusItem tabStopId="item2">Item 2</button>
            <button rdxRovingFocusItem tabStopId="item3">Item 3</button>
        </div>
    `
})
export class RovingFocusEventsComponent {
    onEntryFocus(event: Event) {
        console.log('Entry focus triggered:', event);
    }

    onTabStopChange(tabStopId: string | null) {
        console.log('Current tab stop changed to:', tabStopId);
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/roving-focus/stories/roving-focus.docs.mdx
````
import { ArgTypes, Canvas, Meta } from '@storybook/blocks';
import * as Stories from './roving-focus.stories';
import { RdxRovingFocusGroupDirective } from '../src/roving-focus-group.directive';
import { RdxRovingFocusItemDirective } from '../src/roving-focus-item.directive';


<Meta title="Utilities/Roving Focus" />

# Roving Focus


<Canvas sourceState="hidden" of={Stories.Default} />


## Anatomy

```html
<div rdxRovingFocusGroup>
    <button rdxRovingFocusItem></button>
    <button rdxRovingFocusItem></button>
    <button rdxRovingFocusItem></button>
</div>
```

## API Reference

### Focus Group
The `RdxRovingFocusGroupDirective` allows managing focus within a group of elements, such as buttons, links, or any interactive items. It provides an accessible navigation pattern for keyboard users and ensures intuitive interaction.

#### Usage

This directive can be added to a container element, and all its focusable children will be managed as a group.

<ArgTypes of={RdxRovingFocusGroupDirective} />

### Focus Item
The `RdxRovingFocusItemDirective` is a companion directive to `RdxRovingFocusGroupDirective`. It manages individual items within the group, ensuring smooth keyboard navigation and intuitive focus behavior.

#### Usage
This directive should be used on individual elements (e.g., buttons or links) within a container that has the `RdxRovingFocusGroupDirective`.

<ArgTypes of={RdxRovingFocusItemDirective} />

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/roving-focus/stories/roving-focus.stories.ts
```typescript
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { RdxRovingFocusGroupDirective } from '../src/roving-focus-group.directive';
import { RdxRovingFocusItemDirective } from '../src/roving-focus-item.directive';
import { RovingFocusEventsComponent } from './roving-focus-events.component';

const html = String.raw;

export default {
    title: 'Utilities/Roving Focus',
    decorators: [
        moduleMetadata({
            imports: [
                RdxRovingFocusGroupDirective,
                RdxRovingFocusItemDirective,
                RovingFocusEventsComponent
            ]
        }),
        componentWrapperDecorator(
            (story) => html`
                <div class="radix-themes light light-theme" data-radius="medium" data-scaling="100%">
                    ${story}

                    <style>
                        h2,
                        p {
                            color: #ffffff;
                        }

                        section {
                            width: 500px;
                        }

                        [rdxRovingFocusGroup] {
                            display: flex;
                            gap: 8px;
                        }

                        [rdxRovingFocusGroup][data-orientation='vertical'] {
                            width: 90px;
                            flex-direction: column;
                        }

                        [rdxRovingFocusGroup][data-orientation='horizontal'] {
                            flex-direction: row;
                        }

                        [rdxRovingFocusItem] {
                            padding: 8px 16px;
                            border: 1px solid #ccc;
                            border-radius: 4px;
                            background-color: #f9f9f9;
                            cursor: pointer;
                            transition:
                                background-color 0.2s,
                                transform 0.2s;
                        }

                        [rdxRovingFocusItem]:focus {
                            outline: none;
                            background-color: #007bff;
                            color: white;
                            transform: scale(1.05);
                        }

                        [rdxRovingFocusItem][data-disabled] {
                            cursor: not-allowed;
                            opacity: 0.5;
                            background-color: #f1f1f1;
                        }
                    </style>
                </div>
            `
        )
    ]
} as Meta;

type Story = StoryObj;

export const Default: Story = {
    render: () => ({
        template: html`
            <section>
                <h2>Horizontal Navigation with Looping</h2>
                <p>
                    Use the ArrowLeft and ArrowRight keys to navigate between buttons. Ensure that when reaching the end
                    of the group, the focus cycles back to the first item (and vice versa).
                </p>
                <div rdxRovingFocusGroup [orientation]="'horizontal'" [loop]="true">
                    <button rdxRovingFocusItem>Item 1</button>
                    <button rdxRovingFocusItem>Item 2</button>
                    <button rdxRovingFocusItem>Item 3</button>
                </div>
            </section>
        `
    })
};

export const HorizontalRTL: Story = {
    render: () => ({
        template: html`
            <section>
                <h2>Horizontal Navigation in RTL Direction</h2>
                <p>
                    Use the ArrowLeft and ArrowRight keys. In RTL direction, the keys should behave inversely
                    (ArrowRight moves to the previous item, and ArrowLeft moves to the next item).
                </p>
                <div rdxRovingFocusGroup [orientation]="'horizontal'" [dir]="'rtl'" [loop]="true">
                    <button rdxRovingFocusItem>Left</button>
                    <button rdxRovingFocusItem>Center</button>
                    <button rdxRovingFocusItem>Right</button>
                </div>
            </section>
        `
    })
};

export const WithHomeAndEnd: Story = {
    render: () => ({
        template: html`
            <section>
                <h2>Navigation with "Home" and "End" Keys</h2>
                <p>
                    Press the Home key to move focus to the first item. Press the End key to move focus to the last
                    item.
                </p>
                <div rdxRovingFocusGroup [orientation]="'horizontal'" [loop]="false">
                    <button rdxRovingFocusItem>Left</button>
                    <button rdxRovingFocusItem>Center</button>
                    <button rdxRovingFocusItem>Right</button>
                </div>
            </section>
        `
    })
};

export const MixedActiveAndInactive: Story = {
    render: () => ({
        template: html`
            <section>
                <h2>Mixed Active and Inactive States</h2>
                <p>Try navigating with arrow keys. Ensure that the inactive item (Disabled) is skipped.</p>
                <div rdxRovingFocusGroup [orientation]="'horizontal'" [loop]="true">
                    <button rdxRovingFocusItem [focusable]="true">Left</button>
                    <button rdxRovingFocusItem [focusable]="false">Center</button>
                    <button rdxRovingFocusItem [focusable]="true">Right</button>
                </div>
            </section>
        `
    })
};

export const VerticalWithoutLooping: Story = {
    render: () => ({
        template: html`
            <section>
                <h2>Vertical Navigation without Looping</h2>
                <p>
                    Use the ArrowLeft and ArrowRight keys to navigate between buttons. Ensure that when reaching the end
                    of the group, the focus cycles back to the first item (and vice versa).
                </p>
                <div rdxRovingFocusGroup [orientation]="'vertical'" [loop]="false">
                    <button rdxRovingFocusItem>Item 1</button>
                    <button rdxRovingFocusItem>Item 2</button>
                    <button rdxRovingFocusItem>Item 3</button>
                </div>
            </section>
        `
    })
};

export const IgnoreShiftKey: Story = {
    render: () => ({
        template: html`
            <section>
                <h2>Ignore Shift Key (allowShiftKey)</h2>
                <p>
                    Use the ArrowLeft and ArrowRight keys to navigate between buttons. Holding the
                    <code>Shift</code>
                    key should not affect focus behavior.
                </p>
                <div rdxRovingFocusGroup [orientation]="'horizontal'" [loop]="true">
                    <button rdxRovingFocusItem allowShiftKey="true">Item 1 (Shift Allowed)</button>
                    <button rdxRovingFocusItem>Item 2 (Default)</button>
                    <button rdxRovingFocusItem allowShiftKey="true">Item 3 (Shift Allowed)</button>
                </div>
            </section>
        `
    })
};

export const EventHandling: Story = {
    render: () => ({
        template: html`
            <h2>Event Handling</h2>
            <p>
                Verify that the
                <code>entryFocus</code>
                and
                <code>currentTabStopIdChange</code>
                events are triggered during the appropriate actions.
            </p>
            <rvg-events />
        `
    })
};

```
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
