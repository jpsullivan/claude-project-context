/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/README.md
```
# @spartan-ng/brain/core

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/core`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/index.ts
```typescript
export * from './helpers/custom-element-class-settable';
export * from './helpers/dev-mode';
export * from './helpers/exposes-side';
export * from './helpers/exposes-state';
export * from './helpers/hlm';
export * from './helpers/table-classes-settable';
export * from './helpers/zone-free';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/create-injection-token.ts
```typescript
import { type InjectOptions, InjectionToken, type Provider, type Type, forwardRef, inject } from '@angular/core';

type InjectFn<TTokenValue> = {
	(): TTokenValue;
	(injectOptions: InjectOptions & { optional?: false }): TTokenValue;
	(injectOptions: InjectOptions & { optional: true }): TTokenValue | null;
};

type ProvideFn<TTokenValue> = (value: TTokenValue) => Provider;

type ProvideExistingFn<TTokenValue> = (valueFactory: () => Type<TTokenValue>) => Provider;

export type CreateInjectionTokenReturn<TTokenValue> = [
	InjectFn<TTokenValue>,
	ProvideFn<TTokenValue>,
	ProvideExistingFn<TTokenValue>,
	InjectionToken<TTokenValue>,
];

export function createInjectionToken<TTokenValue>(description: string): CreateInjectionTokenReturn<TTokenValue> {
	const token = new InjectionToken<TTokenValue>(description);

	const provideFn = (value: TTokenValue) => {
		return { provide: token, useValue: value };
	};

	const provideExistingFn = (value: () => TTokenValue) => {
		return { provide: token, useExisting: forwardRef(value) };
	};

	const injectFn = (options: InjectOptions = {}) => {
		return inject(token, options);
	};

	return [injectFn, provideFn, provideExistingFn, token] as CreateInjectionTokenReturn<TTokenValue>;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/custom-element-class-settable.ts
```typescript
import { createInjectionToken } from './create-injection-token';

export interface CustomElementClassSettable {
	setClassToCustomElement: (newClass: string) => void;
}

export const [
	injectCustomClassSettable,
	provideCustomClassSettable,
	provideCustomClassSettableExisting,
	SET_CLASS_TO_CUSTOM_ELEMENT_TOKEN,
] = createInjectionToken<CustomElementClassSettable>('@spartan-ng SET_CLASS_TO_CUSTOM_ELEMENT_TOKEN');

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/dev-mode.ts
```typescript
declare const ngDevMode: boolean;
/**
 * Set by Angular to true when in development mode.
 * Allows for tree-shaking code that is only used in development.
 */
export const brnDevMode = ngDevMode;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/exposes-side.ts
```typescript
import type { Signal } from '@angular/core';
import { createInjectionToken } from './create-injection-token';

export interface ExposesSide {
	side: Signal<'top' | 'bottom' | 'left' | 'right'>;
}

export const [
	injectExposedSideProvider,
	provideExposedSideProvider,
	provideExposedSideProviderExisting,
	EXPOSES_SIDE_TOKEN,
] = createInjectionToken<ExposesSide>('@spartan-ng EXPOSES_SIDE_TOKEN');

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/exposes-state.ts
```typescript
import type { Signal } from '@angular/core';
import { createInjectionToken } from './create-injection-token';

export interface ExposesState {
	state: Signal<'open' | 'closed'>;
}

export const [
	injectExposesStateProvider,
	provideExposesStateProvider,
	provideExposesStateProviderExisting,
	EXPOSES_STATE_TOKEN,
] = createInjectionToken<ExposesState>('@spartan-ng EXPOSES_STATE_TOKEN');

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/hlm.ts
```typescript
import { type ClassValue, clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function hlm(...inputs: ClassValue[]) {
	return twMerge(clsx(inputs));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/table-classes-settable.ts
```typescript
import { createInjectionToken } from './create-injection-token';

export interface TableClassesSettable {
	setTableClasses: (classes: Partial<{ table: string; headerRow: string; bodyRow: string }>) => void;
}

export const [
	injectTableClassesSettable,
	provideTableClassesSettable,
	provideTableClassesSettableExisting,
	SET_TABLE_CLASSES_TOKEN,
] = createInjectionToken<TableClassesSettable>('@spartan-ng SET_TABLE_CLASSES_TOKEN');

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/zone-free.ts
```typescript
/**
 * We are building on shoulders of giants here and use the implementation provided by the incredible TaigaUI
 * team: https://github.com/taiga-family/taiga-ui/blob/main/projects/cdk/observables/zone-free.ts#L22
 * Check them out! Give them a try! Leave a star! Their work is incredible!
 */
import type { NgZone } from '@angular/core';
import { type MonoTypeOperatorFunction, Observable, pipe } from 'rxjs';

export function brnZoneFull<T>(zone: NgZone): MonoTypeOperatorFunction<T> {
	return (source) =>
		new Observable((subscriber) =>
			source.subscribe({
				next: (value) => zone.run(() => subscriber.next(value)),
				error: (error: unknown) => zone.run(() => subscriber.error(error)),
				complete: () => zone.run(() => subscriber.complete()),
			}),
		);
}

export function brnZoneFree<T>(zone: NgZone): MonoTypeOperatorFunction<T> {
	return (source) => new Observable((subscriber) => zone.runOutsideAngular(() => source.subscribe(subscriber)));
}

export function brnZoneOptimized<T>(zone: NgZone): MonoTypeOperatorFunction<T> {
	return pipe(brnZoneFree(zone), brnZoneFull(zone));
}

```
