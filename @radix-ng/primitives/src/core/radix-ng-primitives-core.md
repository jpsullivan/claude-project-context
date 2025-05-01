/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/index.ts
```typescript
export * from './src/accessor/provide-value-accessor';
export * from './src/auto-focus.directive';
export * from './src/document';
export * from './src/focus-initial.directive';
export * from './src/id-generator';
export * from './src/inject-ng-control';
export * from './src/is-client';
export * from './src/is-inside-form';
export * from './src/is-nullish';
export * from './src/is-number';
export * from './src/kbd-constants';
export * from './src/window';

export * from './src/positioning/constants';
export * from './src/positioning/types';
export * from './src/positioning/utils';

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/auto-focus.directive.ts
```typescript
import { booleanAttribute, Directive, ElementRef, inject, Input, NgZone } from '@angular/core';

/*
 * <div [rdxAutoFocus]="true"></div>
 */

@Directive({
    selector: '[rdxAutoFocus]',
    standalone: true
})
export class RdxAutoFocusDirective {
    #elementRef = inject(ElementRef);
    #ngZone = inject(NgZone);

    private _autoSelect = false;

    /**
     * @default false
     */
    @Input({ alias: 'rdxAutoFocus', transform: booleanAttribute })
    set autoFocus(value: boolean) {
        if (value) {
            // Note: Running this outside Angular's zone because `element.focus()` does not trigger change detection.
            this.#ngZone.runOutsideAngular(() =>
                // Note: `element.focus()` causes re-layout which might lead to frame drops on slower devices.
                // https://gist.github.com/paulirish/5d52fb081b3570c81e3a#setting-focus
                // `setTimeout` is a macrotask executed within the current rendering frame.
                // Animation tasks are executed in the next rendering frame.
                reqAnimationFrame(() => {
                    this.#elementRef.nativeElement.focus();
                    if (this._autoSelect && this.#elementRef.nativeElement.select) {
                        this.#elementRef.nativeElement.select();
                    }
                })
            );
        }
    }

    // Setter for autoSelect attribute to enable text selection when autoFocus is true.
    @Input({ transform: booleanAttribute })
    set autoSelect(value: boolean) {
        this._autoSelect = value;
    }
}

const availablePrefixes = ['moz', 'ms', 'webkit'];

function requestAnimationFramePolyfill(): typeof requestAnimationFrame {
    let lastTime = 0;

    return function (callback: FrameRequestCallback): number {
        const currTime = new Date().getTime();
        const timeToCall = Math.max(0, 16 - (currTime - lastTime));

        const id = setTimeout(() => {
            callback(currTime + timeToCall);
        }, timeToCall) as any;

        lastTime = currTime + timeToCall;

        return id;
    };
}

// Function to get the appropriate requestAnimationFrame method with fallback to polyfill.
function getRequestAnimationFrame(): typeof requestAnimationFrame {
    if (typeof window === 'undefined') {
        return () => 0;
    }
    if (window.requestAnimationFrame) {
        // https://github.com/vuejs/vue/issues/4465
        return window.requestAnimationFrame.bind(window);
    }

    const prefix = availablePrefixes.filter((key) => `${key}RequestAnimationFrame` in window)[0];

    return prefix ? (window as any)[`${prefix}RequestAnimationFrame`] : requestAnimationFramePolyfill();
}

// Get the requestAnimationFrame function or its polyfill.
const reqAnimationFrame = getRequestAnimationFrame();

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/document.ts
```typescript
import { DOCUMENT } from '@angular/common';
import { inject } from '@angular/core';

export function injectDocument(): Document {
    return inject(DOCUMENT);
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/focus-initial.directive.ts
```typescript
import { Directive, ElementRef, inject } from '@angular/core';

@Directive({
    selector: '[rdxFocusInitial]'
})
export class RdxFocusInitialDirective {
    /** @ignore */
    private readonly nativeElement = inject(ElementRef).nativeElement;

    /** @ignore */
    focus(): void {
        this.nativeElement.focus();
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/id-generator.ts
```typescript
/**
 * @license
 * Copyright Google LLC All Rights Reserved.
 *
 * Use of this source code is governed by an MIT-style license that can be
 * found in the LICENSE file at https://angular.dev/license
 */

import { APP_ID, inject, Injectable } from '@angular/core';

/**
 * Keeps track of the ID count per prefix. This helps us make the IDs a bit more deterministic
 * like they were before the service was introduced. Note that ideally we wouldn't have to do
 * this, but there are some internal tests that rely on the IDs.
 */
const counters: Record<string, number> = {};

/** Service that generates unique IDs for DOM nodes. */
@Injectable({ providedIn: 'root' })
export class _IdGenerator {
    private readonly _appId = inject(APP_ID);

    /**
     * Generates a unique ID with a specific prefix.
     * @param prefix Prefix to add to the ID.
     */
    getId(prefix: string): string {
        // Omit the app ID if it's the default `ng`. Since the vast majority of pages have one
        // Angular app on them, we can reduce the amount of breakages by not adding it.
        if (this._appId !== 'ng') {
            prefix += this._appId;
        }

        if (!Object.prototype.hasOwnProperty.call(counters, prefix)) {
            counters[prefix] = 0;
        }

        return `${prefix}${counters[prefix]++}`;
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/inject-ng-control.ts
```typescript
import { inject } from '@angular/core';
import { FormControlDirective, FormControlName, NgControl, NgModel } from '@angular/forms';

export function injectNgControl(params: {
    optional: true;
}): FormControlDirective | FormControlName | NgModel | undefined;
export function injectNgControl(params: { optional: false }): FormControlDirective | FormControlName | NgModel;
export function injectNgControl(): FormControlDirective | FormControlName | NgModel;

export function injectNgControl(params?: { optional: true } | { optional: false }) {
    const ngControl = inject(NgControl, { self: true, optional: true });

    if (!params?.optional && !ngControl) throw new Error('NgControl not found');

    if (
        ngControl instanceof FormControlDirective ||
        ngControl instanceof FormControlName ||
        ngControl instanceof NgModel
    ) {
        return ngControl;
    }

    if (params?.optional) {
        return undefined;
    }

    throw new Error('NgControl is not an instance of FormControlDirective, FormControlName or NgModel');
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/is-client.ts
```typescript
import { Platform } from '@angular/cdk/platform';
import { inject } from '@angular/core';

export function injectIsClient() {
    return inject(Platform).isBrowser;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/is-inside-form.ts
```typescript
import { ElementRef } from '@angular/core';

export function isInsideForm(el: ElementRef<HTMLElement> | null): boolean {
    if (!el || !el.nativeElement) {
        return true;
    }
    return Boolean(el.nativeElement.closest('form'));
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/is-nullish.ts
```typescript
export function isNullish(value: any): value is null | undefined {
    return value === null || value === undefined;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/is-number.ts
```typescript
export const isNumber = (v: any): v is number => typeof v === 'number';

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/kbd-constants.ts
```typescript
export const ALT = 'Alt';
export const ARROW_DOWN = 'ArrowDown';
export const ARROW_LEFT = 'ArrowLeft';
export const ARROW_RIGHT = 'ArrowRight';
export const ARROW_UP = 'ArrowUp';
export const BACKSPACE = 'Backspace';
export const CAPS_LOCK = 'CapsLock';
export const CONTROL = 'Control';
export const DELETE = 'Delete';
export const END = 'End';
export const ENTER = 'Enter';
export const ESCAPE = 'Escape';
export const F1 = 'F1';
export const F10 = 'F10';
export const F11 = 'F11';
export const F12 = 'F12';
export const F2 = 'F2';
export const F3 = 'F3';
export const F4 = 'F4';
export const F5 = 'F5';
export const F6 = 'F6';
export const F7 = 'F7';
export const F8 = 'F8';
export const F9 = 'F9';
export const HOME = 'Home';
export const META = 'Meta';
export const PAGE_DOWN = 'PageDown';
export const PAGE_UP = 'PageUp';
export const SHIFT = 'Shift';
export const SPACE = ' ';
export const TAB = 'Tab';
export const CTRL = 'Control';
export const ASTERISK = '*';
export const a = 'a';
export const P = 'P';
export const A = 'A';
export const p = 'p';
export const n = 'n';
export const j = 'j';
export const k = 'k';

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/mount.ts
```typescript
import { AfterViewInit, Directive } from '@angular/core';

const callAll =
    <T extends (...a: never[]) => void>(...fns: (T | undefined)[]) =>
    (...a: Parameters<T>) => {
        fns.forEach(function (fn) {
            fn?.(...a);
        });
    };

@Directive({
    standalone: true
})
export class OnMountDirective implements AfterViewInit {
    #onMountFns?: () => void;

    onMount(fn: () => void) {
        this.#onMountFns = callAll(this.#onMountFns, fn);
    }

    ngAfterViewInit() {
        if (!this.#onMountFns) {
            throw new Error('The onMount function must be called before the component is mounted.');
        }
        this.#onMountFns();
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/types.ts
````typescript
/**
 * Nullable from `Type` adds `null` and `undefined`
 *
 * @example ```ts
 *  // Expect: string | number | undefined | null
 *  type Value = Nulling<string | number>;
 * ```
 */
export type Nullable<Type> = null | Type | undefined;

/**
 * SafeFunction is a type for functions that accept any number of arguments of unknown types
 * and return a value of an unknown type. This is useful when you want to define a function
 * without being strict about the input or output types, maintaining flexibility.
 *
 * @example ```ts
 *  const safeFn: SafeFunction = (...args) => {
 *    return args.length > 0 ? args[0] : null;
 *  };
 *
 *  const result = safeFn(1, 'hello'); // result: 1
 * ```
 */
export type SafeFunction = (...args: unknown[]) => unknown;

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/window.ts
```typescript
import { inject, InjectionToken } from '@angular/core';
import { injectDocument } from './document';

export const WINDOW = new InjectionToken<Window & typeof globalThis>('An abstraction over global window object', {
    factory: () => {
        const { defaultView } = injectDocument();
        if (!defaultView) {
            throw new Error('Window is not available');
        }
        return defaultView;
    }
});

export function injectWindow(): Window & typeof globalThis {
    return inject(WINDOW);
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/accessor/provide-value-accessor.ts
````typescript
import { Provider, Type } from '@angular/core';
import { NG_VALUE_ACCESSOR } from '@angular/forms';

/**
 * Include in the providers section of a component which utilizes ControlValueAccessor to redundant code.
 *
 * ```ts
 * @Directive({
 *   providers: [provideValueAccessor(ExampleDirective)]
 *}
 * export class ExampleDirective{}
 * ```
 */
export function provideValueAccessor(type: Type<never>): Provider {
    return {
        provide: NG_VALUE_ACCESSOR,
        useExisting: type,
        multi: true
    };
}

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/positioning/constants.ts
```typescript
import { RdxPositionAlign, RdxPositioningDefaults, RdxPositions, RdxPositionSide } from './types';

export const RDX_POSITIONS: RdxPositions = {
    [RdxPositionSide.Top]: {
        [RdxPositionAlign.Center]: {
            originX: 'center',
            originY: 'top',
            overlayX: 'center',
            overlayY: 'bottom'
        },
        [RdxPositionAlign.Start]: {
            originX: 'start',
            originY: 'top',
            overlayX: 'start',
            overlayY: 'bottom'
        },
        [RdxPositionAlign.End]: {
            originX: 'end',
            originY: 'top',
            overlayX: 'end',
            overlayY: 'bottom'
        }
    },
    [RdxPositionSide.Right]: {
        [RdxPositionAlign.Center]: {
            originX: 'end',
            originY: 'center',
            overlayX: 'start',
            overlayY: 'center'
        },
        [RdxPositionAlign.Start]: {
            originX: 'end',
            originY: 'top',
            overlayX: 'start',
            overlayY: 'top'
        },
        [RdxPositionAlign.End]: {
            originX: 'end',
            originY: 'bottom',
            overlayX: 'start',
            overlayY: 'bottom'
        }
    },
    [RdxPositionSide.Bottom]: {
        [RdxPositionAlign.Center]: {
            originX: 'center',
            originY: 'bottom',
            overlayX: 'center',
            overlayY: 'top'
        },
        [RdxPositionAlign.Start]: {
            originX: 'start',
            originY: 'bottom',
            overlayX: 'start',
            overlayY: 'top'
        },
        [RdxPositionAlign.End]: {
            originX: 'end',
            originY: 'bottom',
            overlayX: 'end',
            overlayY: 'top'
        }
    },
    [RdxPositionSide.Left]: {
        [RdxPositionAlign.Center]: {
            originX: 'start',
            originY: 'center',
            overlayX: 'end',
            overlayY: 'center'
        },
        [RdxPositionAlign.Start]: {
            originX: 'start',
            originY: 'top',
            overlayX: 'end',
            overlayY: 'top'
        },
        [RdxPositionAlign.End]: {
            originX: 'start',
            originY: 'bottom',
            overlayX: 'end',
            overlayY: 'bottom'
        }
    }
} as const;

export const RDX_POSITIONING_DEFAULTS: RdxPositioningDefaults = {
    offsets: {
        side: 4,
        align: 0
    },
    arrow: {
        width: 8,
        height: 6
    }
} as const;

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/positioning/types.ts
```typescript
import { ConnectionPositionPair } from '@angular/cdk/overlay';

export enum RdxPositionSide {
    Top = 'top',
    Right = 'right',
    Bottom = 'bottom',
    Left = 'left'
}

export enum RdxPositionAlign {
    Start = 'start',
    Center = 'center',
    End = 'end'
}

export type RdxPositionSideAndAlign = { side: RdxPositionSide; align: RdxPositionAlign };
export type RdxPositionSideAndAlignOffsets = { sideOffset: number; alignOffset: number };

export type RdxPositions = Readonly<{
    [key in RdxPositionSide]: Readonly<{
        [key in RdxPositionAlign]: Readonly<ConnectionPositionPair>;
    }>;
}>;

export type RdxPositioningDefaults = Readonly<{
    offsets: Readonly<{
        side: number;
        align: number;
    }>;
    arrow: Readonly<{
        width: number;
        height: number;
    }>;
}>;

export type RdxAllPossibleConnectedPositions = ReadonlyMap<
    `${RdxPositionSide}|${RdxPositionAlign}`,
    ConnectionPositionPair
>;
export type RdxArrowPositionParams = {
    top: string;
    left: string;
    transform: string;
    transformOrigin: string;
};

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/positioning/utils.ts
```typescript
import { ConnectedPosition, ConnectionPositionPair } from '@angular/cdk/overlay';
import { RDX_POSITIONS } from './constants';
import {
    RdxAllPossibleConnectedPositions,
    RdxArrowPositionParams,
    RdxPositionAlign,
    RdxPositionSide,
    RdxPositionSideAndAlign,
    RdxPositionSideAndAlignOffsets
} from './types';

export function getContentPosition(
    sideAndAlignWithOffsets: RdxPositionSideAndAlign & RdxPositionSideAndAlignOffsets
): ConnectedPosition {
    const { side, align, sideOffset, alignOffset } = sideAndAlignWithOffsets;
    const position: ConnectedPosition = {
        ...(RDX_POSITIONS[side]?.[align] ?? RDX_POSITIONS[RdxPositionSide.Top][RdxPositionAlign.Center])
    };
    if (sideOffset || alignOffset) {
        if ([RdxPositionSide.Top, RdxPositionSide.Bottom].includes(side)) {
            if (sideOffset) {
                position.offsetY = side === RdxPositionSide.Top ? -sideOffset : sideOffset;
            }
            if (alignOffset) {
                position.offsetX = alignOffset;
            }
        } else {
            if (sideOffset) {
                position.offsetX = side === RdxPositionSide.Left ? -sideOffset : sideOffset;
            }
            if (alignOffset) {
                position.offsetY = alignOffset;
            }
        }
    }
    return position;
}

let allPossibleConnectedPositions: RdxAllPossibleConnectedPositions;
export function getAllPossibleConnectedPositions() {
    if (!allPossibleConnectedPositions) {
        allPossibleConnectedPositions = new Map();
    }
    if (allPossibleConnectedPositions.size < 1) {
        for (const [side, aligns] of Object.entries(RDX_POSITIONS)) {
            for (const [align, position] of Object.entries(aligns)) {
                (allPossibleConnectedPositions as Map<any, any>).set(`${side}|${align}`, position);
            }
        }
    }
    return allPossibleConnectedPositions;
}

export function getSideAndAlignFromAllPossibleConnectedPositions(
    position: ConnectionPositionPair
): RdxPositionSideAndAlign {
    const allPossibleConnectedPositions = getAllPossibleConnectedPositions();
    let sideAndAlign: RdxPositionSideAndAlign | undefined;
    allPossibleConnectedPositions.forEach((value, key) => {
        if (
            position.originX === value.originX &&
            position.originY === value.originY &&
            position.overlayX === value.overlayX &&
            position.overlayY === value.overlayY
        ) {
            const sideAndAlignArray = key.split('|');
            sideAndAlign = {
                side: sideAndAlignArray[0] as RdxPositionSide,
                align: sideAndAlignArray[1] as RdxPositionAlign
            };
        }
    });
    if (!sideAndAlign) {
        throw Error(
            `[Rdx positioning] cannot infer both side and align from the given position (${JSON.stringify(position)})`
        );
    }
    return sideAndAlign;
}

export function getArrowPositionParams(
    sideAndAlign: RdxPositionSideAndAlign,
    arrowWidthAndHeight: { width: number; height: number },
    triggerWidthAndHeight: { width: number; height: number }
): RdxArrowPositionParams {
    const posParams: RdxArrowPositionParams = {
        top: '',
        left: '',
        transform: '',
        transformOrigin: 'center center 0px'
    };

    if ([RdxPositionSide.Top, RdxPositionSide.Bottom].includes(sideAndAlign.side)) {
        if (sideAndAlign.side === RdxPositionSide.Top) {
            posParams.top = '100%';
        } else {
            posParams.top = `-${arrowWidthAndHeight.height}px`;
            posParams.transform = `rotate(180deg)`;
        }

        if (sideAndAlign.align === RdxPositionAlign.Start) {
            posParams.left = `${(triggerWidthAndHeight.width - arrowWidthAndHeight.width) / 2}px`;
        } else if (sideAndAlign.align === RdxPositionAlign.Center) {
            posParams.left = `calc(50% - ${arrowWidthAndHeight.width / 2}px)`;
        } else if (sideAndAlign.align === RdxPositionAlign.End) {
            posParams.left = `calc(100% - ${(triggerWidthAndHeight.width + arrowWidthAndHeight.width) / 2}px)`;
        }
    } else if ([RdxPositionSide.Left, RdxPositionSide.Right].includes(sideAndAlign.side)) {
        if (sideAndAlign.side === RdxPositionSide.Left) {
            posParams.left = `calc(100% - ${arrowWidthAndHeight.width}px)`;
            posParams.transform = `rotate(-90deg)`;
            posParams.transformOrigin = 'top right 0px';
        } else {
            posParams.left = `0`;
            posParams.transform = `rotate(90deg)`;
            posParams.transformOrigin = 'top left 0px';
        }

        if (sideAndAlign.align === RdxPositionAlign.Start) {
            posParams.top = `${(triggerWidthAndHeight.height - arrowWidthAndHeight.width) / 2}px`;
        } else if (sideAndAlign.align === RdxPositionAlign.Center) {
            posParams.top = `calc(50% - ${arrowWidthAndHeight.width / 2}px)`;
        } else if (sideAndAlign.align === RdxPositionAlign.End) {
            posParams.top = `calc(100% - ${(triggerWidthAndHeight.height + arrowWidthAndHeight.width) / 2}px)`;
        }
    }

    return posParams;
}

```
