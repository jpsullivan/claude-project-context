/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/presence/index.ts
```typescript
export * from './src/presence';
export * from './src/transitions/transition.collapse';
export * from './src/transitions/transition.toast';
export * from './src/types';

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/presence/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/presence/__test__/presence-test.component.ts
```typescript
import { Component, ElementRef, NgZone, OnInit } from '@angular/core';
import { usePresence } from '../src/presence';
import { CollapseContext, transitionCollapsing } from '../src/transitions/transition.collapse';

@Component({
    selector: 'app-presence',
    template: `
        <div #element>Presence Component</div>
    `,
    styles: [
        `
            .collapse {
                transition: height 0.5s ease-in-out;
            }
            .collapsing {
                height: 0px;
            }
            .show {
                height: auto;
            }
        `

    ]
})
export class PresenceComponent implements OnInit {
    private context: CollapseContext = {
        direction: 'show',
        dimension: 'height'
    };
    private element!: HTMLElement;

    constructor(
        private zone: NgZone,
        private elRef: ElementRef
    ) {}

    ngOnInit(): void {
        this.element = this.elRef.nativeElement.querySelector('div');
        const options = {
            context: this.context,
            animation: true,
            state: 'stop' as const
        };

        usePresence(this.zone, this.element, transitionCollapsing, options).subscribe();
    }

    getContext(): CollapseContext {
        return this.context;
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/presence/__test__/presence.spec.ts
```typescript
import { NgZone } from '@angular/core';
import { ComponentFixture, fakeAsync, TestBed, tick } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { PresenceComponent } from './presence-test.component';

describe('presence', () => {
    let component: PresenceComponent;
    let fixture: ComponentFixture<PresenceComponent>;
    let zone: NgZone;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [PresenceComponent],
            providers: [{ provide: NgZone, useValue: new NgZone({ enableLongStackTrace: false }) }]
        }).compileComponents();

        fixture = TestBed.createComponent(PresenceComponent);
        component = fixture.componentInstance;
        zone = TestBed.inject(NgZone);

        fixture.detectChanges(); // triggers ngOnInit
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should initialize element and context correctly', () => {
        const element = fixture.debugElement.query(By.css('div')).nativeElement;

        const context = component.getContext();

        expect(component['element']).toBe(element);
        expect(context).toEqual({ direction: 'show', dimension: 'height', maxSize: '0px' });
    });

    it('should complete animation correctly', fakeAsync(() => {
        const element = fixture.debugElement.query(By.css('div')).nativeElement;

        zone.runOutsideAngular(() => {
            element.dispatchEvent(new Event('transitionend'));
        });

        tick(600);
        fixture.detectChanges();

        expect(element.classList.contains('collapsing')).toBe(false);
        expect(element.classList.contains('show')).toBe(true);
    }));
});

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/presence/src/presence.ts
```typescript
import { NgZone } from '@angular/core';
import { EMPTY, endWith, filter, fromEvent, Observable, of, race, Subject, takeUntil, timer } from 'rxjs';
import { TransitionContext, TransitionEndFn, TransitionOptions, TransitionStartFn } from './types';
import { getTransitionDurationMs, runInZone } from './utils';

const noopFn: TransitionEndFn = () => {
    /* Noop */
};
const TransitionsMap = new Map<HTMLElement, TransitionContext<any>>();

/**
 * Manages the presence of an element with optional transition animation.
 *
 * @template T - The type of the context object used in the transition.
 * @param {NgZone} zone - The Angular zone to control the change detection context.
 * @param {HTMLElement} element - The target HTML element to apply the transition.
 * @param {TransitionOptions<T>} options - Options for controlling the transition behavior.
 *   @param {T} [options.context] - An optional context object to pass through the transition.
 *   @param {boolean} options.animation - A flag indicating if the transition should be animated.
 *   @param {'start' | 'continue' | 'stop'} options.state - The desired state of the transition.
 * @param {TransitionStartFn<T>} startFn - A function to start the transition.
 * @returns {Observable<void>} - An observable that emits when the transition completes.
 *
 * The `usePresence` function is designed to manage the presence and visibility of an HTML element,
 * optionally applying a transition animation. It utilizes Angular's NgZone for efficient change
 * detection management and allows for different states of transitions ('start', 'continue', 'stop').
 * The function takes a start function to handle the beginning of the transition and returns an
 * observable that completes when the transition ends.
 *
 * Example usage:
 *
 * const options: TransitionOptions<MyContext> = {
 *   context: {}, // your context object
 *   animation: true,
 *   state: 'start'
 * };
 *
 * const startFn: TransitionStartFn<MyContext> = (el, animation, context) => {
 *   el.classList.add('active');
 *   return () => el.classList.remove('active');
 * };
 *
 * usePresence(zone, element, startFn, options).subscribe(() => {
 *   console.log('Transition completed');
 * });
 */
const usePresence = <T>(
    zone: NgZone,
    element: HTMLElement,
    startFn: TransitionStartFn<T>,
    options: TransitionOptions<T>
): Observable<void> => {
    let context = options.context || <T>{};

    const transitionTimerDelayMs = options.transitionTimerDelayMs ?? 5;
    const state = options.state ?? 'stop';

    const running = TransitionsMap.get(element);

    if (running) {
        switch (state) {
            case 'continue':
                return EMPTY;
            case 'stop':
                zone.run(() => running.transition$.complete());
                context = { ...running.context, ...context };
                TransitionsMap.delete(element);
                break;
        }
    }
    const endFn = startFn(element, options.animation, context) || noopFn;

    if (!options.animation || window.getComputedStyle(element).transitionProperty === 'none') {
        zone.run(() => endFn());
        return of(undefined).pipe(runInZone(zone));
    }

    const transition$ = new Subject<void>();
    const finishTransition$ = new Subject<void>();
    const stop$ = transition$.pipe(endWith(true));

    TransitionsMap.set(element, {
        transition$,
        complete: () => {
            finishTransition$.next();
            finishTransition$.complete();
        },
        context
    });

    const transitionDurationMs = getTransitionDurationMs(element);

    zone.runOutsideAngular(() => {
        const transitionEnd$ = fromEvent<TransitionEvent>(element, 'transitionend').pipe(
            filter(({ target }) => target === element),
            takeUntil(stop$)
        );
        const timer$ = timer(transitionDurationMs + transitionTimerDelayMs).pipe(takeUntil(stop$));

        race(timer$, transitionEnd$, finishTransition$)
            .pipe(takeUntil(stop$))
            .subscribe(() => {
                TransitionsMap.delete(element);
                zone.run(() => {
                    endFn();
                    transition$.next();
                    transition$.complete();
                });
            });
    });

    return transition$.asObservable();
};

const completeTransition = (element: HTMLElement) => {
    TransitionsMap.get(element)?.complete();
};

export { completeTransition, usePresence };

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/presence/src/types.ts
```typescript
import { Subject } from 'rxjs';

type TransitionOptions<T> = {
    context?: T;
    animation: boolean;
    state?: 'continue' | 'stop';
    transitionTimerDelayMs?: number;
};

type TransitionContext<T> = {
    transition$: Subject<any>;
    complete: () => void;
    context: T;
};

type TransitionStartFn<T = any> = (element: HTMLElement, animation: boolean, context: T) => TransitionEndFn | void;

type TransitionEndFn = () => void;

export { TransitionContext, TransitionEndFn, TransitionOptions, TransitionStartFn };

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/presence/src/utils.ts
```typescript
import { NgZone } from '@angular/core';
import { Observable } from 'rxjs';

/**
 * Ensures that the observable stream runs inside Angular's NgZone.
 *
 * This function is a higher-order function that takes an observable stream as input and ensures
 * that all emissions, errors, and completion notifications are run inside Angular's NgZone. This
 * is particularly useful for ensuring that change detection is triggered properly in Angular
 * applications.
 *
 * @template T - The type of the items emitted by the observable.
 * @param {NgZone} zone - The Angular zone to control the change detection context.
 * @returns {(source: Observable<T>) => Observable<T>} - A function that takes an observable as input
 * and returns an observable that runs inside Angular's NgZone.
 *
 * Example usage:
 *
 * const source$ = of('some value');
 * const zoned$ = source$.pipe(runInZone(zone));
 * zoned$.subscribe(value => {
 *   console.log('Value:', value);
 * });
 */
function runInZone<T>(zone: NgZone): (source: Observable<T>) => Observable<T> {
    return (source: Observable<T>) =>
        new Observable((observer) =>
            source.subscribe({
                next: (value) => zone.run(() => observer.next(value)),
                error: (err) => zone.run(() => observer.error(err)),
                complete: () => zone.run(() => observer.complete())
            })
        );
}

/**
 * Calculates the total transition duration in milliseconds for a given HTML element.
 *
 * This function retrieves the computed style of the specified element and extracts the
 * transition duration and delay properties. It then converts these values from seconds
 * to milliseconds and returns their sum, representing the total transition duration.
 *
 * @param {HTMLElement} element - The HTML element for which to calculate the transition duration.
 * @returns {number} - The total transition duration in milliseconds.
 *
 * Example usage:
 *
 * const durationMs = getTransitionDurationMs(element);
 * console.log(`Transition duration: ${durationMs} ms`);
 */
function getTransitionDurationMs(element: HTMLElement): number {
    const { transitionDelay, transitionDuration } = window.getComputedStyle(element);
    const transitionDelaySec = parseFloat(transitionDelay);
    const transitionDurationSec = parseFloat(transitionDuration);

    return (transitionDelaySec + transitionDurationSec) * 1000;
}

export { getTransitionDurationMs, runInZone };

export function triggerReflow(element: HTMLElement) {
    return (element || document.body).getBoundingClientRect();
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/presence/src/transitions/transition.collapse.ts
```typescript
import { TransitionStartFn } from '../types';
import { triggerReflow } from '../utils';

export type CollapseContext = {
    direction: 'show' | 'hide';
    dimension: 'width' | 'height';
    maxSize?: string;
};

// Define constants for class names
const COLLAPSE_CLASS = 'collapse';
const COLLAPSING_CLASS = 'collapsing';
const SHOW_CLASS = 'show';
/**
 * Function to handle the start of a collapsing transition.
 *
 * @param element - The HTML element to animate.
 * @param animation - Whether to use animation or not.
 * @param context - The context containing direction and dimension information.
 * @returns A function to clean up the animation.
 */
export const transitionCollapsing: TransitionStartFn<CollapseContext> = (
    element: HTMLElement,
    animation: boolean,
    context: CollapseContext
) => {
    const { direction, dimension } = context;
    let { maxSize } = context;
    const { classList } = element;

    /**
     * Sets initial classes based on the direction.
     */
    function setInitialClasses() {
        classList.add(COLLAPSE_CLASS);
        if (direction === 'show') {
            classList.add(SHOW_CLASS);
        } else {
            classList.remove(SHOW_CLASS);
        }
    }

    if (!animation) {
        setInitialClasses();
        return;
    }

    if (!maxSize) {
        maxSize = measureCollapsingElementDimensionPx(element, dimension);
        context.maxSize = maxSize;

        // Fix the height before starting the animation
        element.style[dimension] = direction !== 'show' ? maxSize : '0px';

        classList.remove(COLLAPSE_CLASS, COLLAPSING_CLASS, 'show');

        triggerReflow(element);

        // Start the animation
        classList.add(COLLAPSING_CLASS);
    }

    element.style[dimension] = direction === 'show' ? maxSize : '0px';

    return () => {
        setInitialClasses();
        classList.remove(COLLAPSING_CLASS);
        element.style[dimension] = '';
    };
};

/**
 * Measures the dimension of the collapsing element in pixels.
 *
 * @param element - The HTML element to measure.
 * @param dimension - The dimension ('width' or 'height') to measure.
 * @returns The size of the dimension in pixels.
 */
function measureCollapsingElementDimensionPx(element: HTMLElement, dimension: 'width' | 'height'): string {
    // SSR fix
    if (typeof navigator === 'undefined') {
        return '0px';
    }

    const { classList } = element;
    const hasShownClass = classList.contains(SHOW_CLASS);
    if (!hasShownClass) {
        classList.add(SHOW_CLASS);
    }

    element.style[dimension] = '';
    const dimensionSize = element.getBoundingClientRect()[dimension] + 'px';

    if (!hasShownClass) {
        classList.remove(SHOW_CLASS);
    }

    return dimensionSize;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/presence/src/transitions/transition.toast.ts
```typescript
import { TransitionStartFn } from '../types';
import { triggerReflow } from '../utils';

export const toastFadeInTransition: TransitionStartFn = (element: HTMLElement, animation: boolean) => {
    const { classList } = element;

    if (animation) {
        classList.add('fade');
    } else {
        classList.add('show');
        return;
    }

    triggerReflow(element);
    classList.add('show', 'showing');

    return () => {
        classList.remove('showing');
    };
};

export const toastFadeOutTransition: TransitionStartFn = ({ classList }: HTMLElement) => {
    classList.add('showing');
    return () => {
        classList.remove('show', 'showing');
    };
};

```
