/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/index.ts
```typescript
import { BrnSliderRangeDirective } from './lib/brn-slider-range.directive';
import { BrnSliderThumbDirective } from './lib/brn-slider-thumb.directive';
import { BrnSliderTickDirective } from './lib/brn-slider-tick.directive';
import { BrnSliderTrackDirective } from './lib/brn-slider-track.directive';
import { BrnSliderDirective } from './lib/brn-slider.directive';

export * from './lib/brn-slider-range.directive';
export * from './lib/brn-slider-thumb.directive';
export * from './lib/brn-slider-tick.directive';
export * from './lib/brn-slider-track.directive';
export * from './lib/brn-slider.directive';
export * from './lib/brn-slider.token';

export const BrnSliderImports = [
	BrnSliderDirective,
	BrnSliderTrackDirective,
	BrnSliderThumbDirective,
	BrnSliderRangeDirective,
	BrnSliderTickDirective,
] as const;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/brn-slider-range.directive.ts
```typescript
import { Directive } from '@angular/core';
import { injectBrnSlider } from './brn-slider.token';

@Directive({
	selector: '[brnSliderRange]',
	host: {
		'[attr.data-disabled]': 'slider.disabled()',
		'[style.width.%]': 'slider.percentage()',
	},
})
export class BrnSliderRangeDirective {
	/** Access the slider */
	protected readonly slider = injectBrnSlider();
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/brn-slider-thumb.directive.ts
```typescript
import { DOCUMENT, isPlatformServer } from '@angular/common';
import { computed, Directive, ElementRef, HostListener, inject, PLATFORM_ID } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { fromEvent } from 'rxjs';
import { switchMap, takeUntil } from 'rxjs/operators';
import { injectBrnSlider } from './brn-slider.token';

@Directive({
	selector: '[brnSliderThumb]',
	host: {
		role: 'slider',
		'[attr.aria-valuenow]': 'slider.value()',
		'[attr.aria-valuemin]': 'slider.min()',
		'[attr.aria-valuemax]': 'slider.max()',
		'[attr.tabindex]': 'slider.disabled() ? -1 : 0',
		'[attr.data-disabled]': 'slider.disabled()',
		'[style.inset-inline-start]': 'thumbOffset()',
	},
})
export class BrnSliderThumbDirective {
	protected readonly slider = injectBrnSlider();
	private readonly _document = inject<Document>(DOCUMENT);
	private readonly _elementRef = inject<ElementRef<HTMLElement>>(ElementRef);
	private readonly _platform = inject(PLATFORM_ID);

	/**
	 * Offsets the thumb centre point while sliding to ensure it remains
	 * within the bounds of the slider when reaching the edges.
	 * Based on https://github.com/radix-ui/primitives/blob/main/packages/react/slider/src/slider.tsx
	 */
	protected readonly thumbOffset = computed(() => {
		// we can't compute the offset on the server
		if (isPlatformServer(this._platform)) {
			return this.slider.percentage() + '%';
		}

		const halfWidth = this._elementRef.nativeElement.offsetWidth / 2;
		const offset = this.linearScale([0, 50], [0, halfWidth]);
		const thumbInBoundsOffset = halfWidth - offset(this.slider.percentage());
		const percent = this.slider.percentage();

		return `calc(${percent}% + ${thumbInBoundsOffset}px)`;
	});

	constructor() {
		const mousedown = fromEvent<MouseEvent>(this._elementRef.nativeElement, 'pointerdown');
		const mouseup = fromEvent<MouseEvent>(this._document, 'pointerup');
		const mousemove = fromEvent<MouseEvent>(this._document, 'pointermove');

		// Listen for mousedown events on the slider thumb
		mousedown
			.pipe(
				switchMap(() => mousemove.pipe(takeUntil(mouseup))),
				takeUntilDestroyed(),
			)
			.subscribe(this.dragThumb.bind(this));
	}

	/** @internal */
	private dragThumb(event: MouseEvent): void {
		if (this.slider.disabled()) {
			return;
		}

		const rect = this.slider.track()?.elementRef.nativeElement.getBoundingClientRect();

		if (!rect) {
			return;
		}

		const percentage = (event.clientX - rect.left) / rect.width;

		this.slider.setValue(
			this.slider.min() + (this.slider.max() - this.slider.min()) * Math.max(0, Math.min(1, percentage)),
		);
	}

	/**
	 * Handle keyboard events.
	 * @param event
	 */
	@HostListener('keydown', ['$event'])
	protected handleKeydown(event: KeyboardEvent): void {
		const dir = getComputedStyle(this._elementRef.nativeElement).direction;
		let multiplier = event.shiftKey ? 10 : 1;
		const value = this.slider.value();

		// if the slider is RTL, flip the multiplier
		if (dir === 'rtl') {
			multiplier = event.shiftKey ? -10 : -1;
		}

		switch (event.key) {
			case 'ArrowLeft':
				this.slider.setValue(Math.max(value - this.slider.step() * multiplier, this.slider.min()));
				event.preventDefault();
				break;
			case 'ArrowRight':
				this.slider.setValue(Math.min(value + this.slider.step() * multiplier, this.slider.max()));
				event.preventDefault();
				break;
			case 'Home':
				this.slider.setValue(this.slider.min());
				event.preventDefault();
				break;
			case 'End':
				this.slider.setValue(this.slider.max());
				event.preventDefault();
				break;
		}
	}

	private linearScale(input: readonly [number, number], output: readonly [number, number]): (value: number) => number {
		return (value: number) => {
			if (input[0] === input[1] || output[0] === output[1]) return output[0];
			const ratio = (output[1] - output[0]) / (input[1] - input[0]);
			return output[0] + ratio * (value - input[0]);
		};
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/brn-slider-tick.directive.ts
```typescript
import { Directive, effect, EmbeddedViewRef, inject, OnDestroy, TemplateRef, ViewContainerRef } from '@angular/core';
import { injectBrnSlider } from './brn-slider.token';

@Directive({
	selector: '[brnSliderTick]',
})
export class BrnSliderTickDirective implements OnDestroy {
	private readonly _slider = injectBrnSlider();
	private readonly _templateRef = inject<TemplateRef<BrnSliderTickContext>>(TemplateRef);
	private readonly _viewContainer = inject(ViewContainerRef);
	private _ticks: EmbeddedViewRef<BrnSliderTickContext>[] = [];

	constructor() {
		effect(() => {
			const ticks = this._slider.ticks();

			// remove any existing ticks
			this._ticks.forEach((tick) => this._viewContainer.remove(this._viewContainer.indexOf(tick)));

			// create new ticks
			this._ticks = [];

			ticks.forEach((tick, index) => {
				const view = this._viewContainer.createEmbeddedView(this._templateRef, {
					$implicit: tick,
					index,
					position: (index / (ticks.length - 1)) * 100,
				});
				this._ticks.push(view);
			});
		});
	}

	ngOnDestroy(): void {
		this._ticks.forEach((tick) => this._viewContainer.remove(this._viewContainer.indexOf(tick)));
	}
}

interface BrnSliderTickContext {
	$implicit: number;
	index: number;
	position: number;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/brn-slider-track.directive.ts
```typescript
import { Directive, ElementRef, HostListener, inject } from '@angular/core';
import { provideBrnSliderTrack } from './brn-slider-track.token';
import { injectBrnSlider } from './brn-slider.token';

@Directive({
	selector: '[brnSliderTrack]',
	providers: [provideBrnSliderTrack(BrnSliderTrackDirective)],
	host: {
		'[attr.data-disabled]': 'slider.disabled()',
	},
})
export class BrnSliderTrackDirective {
	/** Access the slider */
	protected readonly slider = injectBrnSlider();

	/** @internal Access the slider track */
	public readonly elementRef = inject<ElementRef<HTMLElement>>(ElementRef);

	constructor() {
		this.slider.track.set(this);
	}

	@HostListener('mousedown', ['$event'])
	protected moveThumbToPoint(event: MouseEvent): void {
		if (this.slider.disabled()) {
			return;
		}

		const position = event.clientX;
		const rect = this.elementRef.nativeElement.getBoundingClientRect();
		const percentage = (position - rect.left) / rect.width;

		// update the value based on the position
		this.slider.setValue(this.slider.min() + (this.slider.max() - this.slider.min()) * percentage);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/brn-slider-track.token.ts
```typescript
import { ExistingProvider, inject, InjectionToken, Type } from '@angular/core';
import type { BrnSliderTrackDirective } from './brn-slider-track.directive';

export const BrnSliderTrackToken = new InjectionToken<BrnSliderTrackDirective>('BrnSliderTrackToken');

export function provideBrnSliderTrack(slider: Type<BrnSliderTrackDirective>): ExistingProvider {
	return { provide: BrnSliderTrackToken, useExisting: slider };
}

export function injectBrnSliderTrack(): BrnSliderTrackDirective {
	return inject(BrnSliderTrackToken);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/brn-slider.directive.ts
```typescript
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import {
	booleanAttribute,
	ChangeDetectorRef,
	computed,
	Directive,
	ElementRef,
	inject,
	input,
	linkedSignal,
	model,
	numberAttribute,
	OnInit,
	signal,
} from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { ChangeFn, TouchFn } from '@spartan-ng/brain/forms';
import type { BrnSliderTrackDirective } from './brn-slider-track.directive';
import { provideBrnSlider } from './brn-slider.token';

@Directive({
	selector: '[brnSlider]',
	exportAs: 'brnSlider',
	providers: [
		provideBrnSlider(BrnSliderDirective),
		{
			provide: NG_VALUE_ACCESSOR,
			useExisting: BrnSliderDirective,
			multi: true,
		},
	],
	host: {
		'aria-orientation': 'horizontal',
		'(focusout)': '_onTouched?.()',
	},
})
export class BrnSliderDirective implements ControlValueAccessor, OnInit {
	private readonly _changeDetectorRef = inject(ChangeDetectorRef);
	private readonly _elementRef = inject<ElementRef<HTMLElement>>(ElementRef);

	public readonly value = model<number>(0);

	public readonly min = input<number, NumberInput>(0, {
		transform: numberAttribute,
	});

	public readonly max = input<number, NumberInput>(100, {
		transform: numberAttribute,
	});

	public readonly step = input<number, NumberInput>(1, {
		transform: numberAttribute,
	});

	public readonly _disabled = input<boolean, BooleanInput>(false, {
		alias: 'disabled',
		transform: booleanAttribute,
	});

	/** Whether we should show tick marks */
	public readonly showTicks = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** @internal */
	public readonly ticks = computed(() => {
		const value = this.value();

		if (!this.showTicks()) {
			return [];
		}

		let numActive = Math.max(Math.floor((value - this.min()) / this.step()), 0);
		let numInactive = Math.max(Math.floor((this.max() - value) / this.step()), 0);

		const direction = getComputedStyle(this._elementRef.nativeElement).direction;

		direction === 'rtl' ? numInactive++ : numActive++;

		return Array(numActive).fill(true).concat(Array(numInactive).fill(false));
	});

	/** @internal */
	public readonly disabled = linkedSignal(() => this._disabled());

	/** @internal */
	public readonly percentage = computed(() => ((this.value() - this.min()) / (this.max() - this.min())) * 100);

	/** @internal Store the on change callback */
	protected _onChange?: ChangeFn<number>;

	/** @internal Store the on touched callback */
	protected _onTouched?: TouchFn;

	/** @internal Store the track */
	public readonly track = signal<BrnSliderTrackDirective | null>(null);

	ngOnInit(): void {
		// ensure the value is within the min and max range
		if (this.value() < this.min()) {
			this.value.set(this.min());
		}
		if (this.value() > this.max()) {
			this.value.set(this.max());
		}
	}

	registerOnChange(fn: (value: number) => void): void {
		this._onChange = fn;
	}

	registerOnTouched(fn: () => void): void {
		this._onTouched = fn;
	}

	setDisabledState(isDisabled: boolean): void {
		this.disabled.set(isDisabled);
	}

	writeValue(value: number): void {
		const clampedValue = clamp(value, [this.min(), this.max()]);
		this.value.set(clampedValue);

		if (value !== clampedValue) {
			this._onChange?.(clampedValue);
		}

		this._changeDetectorRef.detectChanges();
	}

	setValue(value: number): void {
		const decimalCount = getDecimalCount(this.step());
		const snapToStep = roundValue(
			Math.round((value - this.min()) / this.step()) * this.step() + this.min(),
			decimalCount,
		);

		value = clamp(snapToStep, [this.min(), this.max()]);

		this.value.set(value);
		this._onChange?.(value);
	}
}

function roundValue(value: number, decimalCount: number): number {
	const rounder = Math.pow(10, decimalCount);
	return Math.round(value * rounder) / rounder;
}

function getDecimalCount(value: number): number {
	return (String(value).split('.')[1] || '').length;
}

function clamp(value: number, [min, max]: [number, number]): number {
	return Math.min(max, Math.max(min, value));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/brn-slider.token.ts
```typescript
import { ExistingProvider, inject, InjectionToken, Type } from '@angular/core';
import type { BrnSliderDirective } from './brn-slider.directive';

const BrnSliderToken = new InjectionToken<BrnSliderDirective>('BrnSliderToken');

export function provideBrnSlider(slider: Type<BrnSliderDirective>): ExistingProvider {
	return { provide: BrnSliderToken, useExisting: slider };
}

export function injectBrnSlider(): BrnSliderDirective {
	return inject(BrnSliderToken);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/tests/brn-slider-reactive-form.spec.ts
```typescript
import { render } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import { ReactiveFormSliderComponent } from './brn-slider-states.component';

async function setupSlider() {
	const { getByRole, getByTestId, fixture } = await render(ReactiveFormSliderComponent);

	return {
		fixture,
		thumb: getByRole('slider'),
		changeValueBtn: getByTestId('change-value-btn'),
		valueIndicatorPre: getByTestId('value-indicator-pre'),
	};
}

describe('Reactive Form Slider State', () => {
	it('should reflect the correct value indicator and the related aria attributes when selecting a value between min and max', async () => {
		const { thumb, valueIndicatorPre, fixture } = await setupSlider();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 46');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('46');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

		fixture.componentInstance.changeValue(25);
		fixture.detectChanges();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 25');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('25');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
	});

	it('Should reflect the correct value indicator and the related aria attributes when selecting a value below min', async () => {
		const { thumb, valueIndicatorPre, fixture } = await setupSlider();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 46');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('46');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

		fixture.componentInstance.changeValue(-25);
		fixture.detectChanges();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 0');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
	});

	it('Should reflect the correct value indicator and the related aria attributes when selecting a value after max', async () => {
		const { fixture, thumb, valueIndicatorPre } = await setupSlider();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 46');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('46');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

		//simulate slider dragging/selecting a value
		fixture.componentInstance.changeValue(225);
		fixture.detectChanges();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 100');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('100');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
	});

	it('Should reflect the correct value indicator and the related aria attributes when changing the slider value', async () => {
		const { thumb, fixture, changeValueBtn, valueIndicatorPre } = await setupSlider();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 46');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('46');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

		//simulate slider dragging/selecting a value
		fixture.componentInstance.changeValue(225);
		fixture.detectChanges();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 100');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('100');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

		//change slider value using a button
		await userEvent.click(changeValueBtn);

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 24');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('24');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/tests/brn-slider-states.component.ts
```typescript
import { Component, model } from '@angular/core';
import { FormControl, FormGroup, FormsModule, ReactiveFormsModule } from '@angular/forms';
import {
	BrnSliderDirective,
	BrnSliderRangeDirective,
	BrnSliderThumbDirective,
	BrnSliderTrackDirective,
} from '../../index';

@Component({
	template: `
		<div>
			<pre data-testid="value-indicator-pre">Temperature: {{ temperature() }}</pre>
		</div>
		<form ngForm>
			<div brnSlider aria-label="fallback-label" [min]="0" [(ngModel)]="temperature" name="temperature">
				<div brnSliderTrack>
					<div brnSliderRange></div>
				</div>

				<span brnSliderThumb></span>
			</div>
		</form>
		<button data-testid="change-value-btn" (click)="changeValue(24)">Change temperature value</button>
	`,
	imports: [FormsModule, BrnSliderDirective, BrnSliderThumbDirective, BrnSliderTrackDirective, BrnSliderRangeDirective],
})
export class TemplateDrivenFormSliderComponent {
	public readonly temperature = model<number>(0);

	changeValue(value: number) {
		this.temperature.set(value);
	}
}

@Component({
	template: `
		<div>
			<pre data-testid="value-indicator-pre">
				Temperature: {{ temperatureGroup.controls.temperature.getRawValue() }}
			</pre
			>
		</div>
		<form [formGroup]="temperatureGroup">
			<div brnSlider aria-label="fallback-label" [min]="0" formControlName="temperature">
				<div brnSliderTrack>
					<div brnSliderRange></div>
				</div>

				<span brnSliderThumb></span>
			</div>
		</form>
		<button data-testid="change-value-btn" (click)="changeValue(24)">Change temperature value</button>
	`,
	imports: [
		ReactiveFormsModule,
		BrnSliderDirective,
		BrnSliderThumbDirective,
		BrnSliderTrackDirective,
		BrnSliderRangeDirective,
	],
})
export class ReactiveFormSliderComponent {
	public readonly temperature = model<number>(46);

	protected readonly temperatureGroup = new FormGroup({
		temperature: new FormControl<number>(this.temperature()),
	});

	changeValue(value: number) {
		this.temperatureGroup.controls.temperature.patchValue(value);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/tests/brn-slider-template-driven-form.spec.ts
```typescript
import { render } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import { TemplateDrivenFormSliderComponent } from './brn-slider-states.component';

async function setupSlider() {
	const { fixture, getByRole, getByTestId } = await render(TemplateDrivenFormSliderComponent);

	return {
		fixture,
		thumb: getByRole('slider'),
		changeValueBtn: getByTestId('change-value-btn'),
		valueIndicatorPre: getByTestId('value-indicator-pre'),
	};
}

async function setupSliderWithInitialValue(initialValue: number) {
	const { getByRole, getByTestId, fixture } = await render(TemplateDrivenFormSliderComponent, {
		componentInputs: { temperature: initialValue },
	});

	return {
		fixture,
		thumb: getByRole('slider'),
		changeValueBtn: getByTestId('change-value-btn'),
		valueIndicatorPre: getByTestId('value-indicator-pre'),
	};
}

describe('Template Driven Form Slider State', () => {
	describe('Default Initial Value', () => {
		it('Should reflect the correct value indicator and the related aria attributes when selecting a value between min and max', async () => {
			const { thumb, fixture, valueIndicatorPre } = await setupSlider();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 0');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(25);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 25');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('25');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});

		it('Should reflect the correct value indicator and the related aria attributes when selecting a value below min', async () => {
			const { thumb, valueIndicatorPre, fixture } = await setupSlider();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 0');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(-25);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 0');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});

		it('Should reflect the correct value indicator and the related aria attributes when selecting a value after max', async () => {
			const { thumb, valueIndicatorPre, fixture } = await setupSlider();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 0');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(225);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 100');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('100');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});

		it('Should reflect the correct value indicator and the related aria attributes when changing the slider value', async () => {
			const { fixture, thumb, changeValueBtn, valueIndicatorPre } = await setupSlider();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 0');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(225);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 100');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('100');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//change slider value using a button
			await userEvent.click(changeValueBtn);

			fixture.detectChanges();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 24');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('24');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});
	});

	describe('With Initial Value', () => {
		it('Should reflect the correct value indicator and the related aria attributes when selecting a value between min and max', async () => {
			const { fixture, thumb, valueIndicatorPre } = await setupSliderWithInitialValue(12);

			fixture.detectChanges();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 12');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('12');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(25);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 25');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('25');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});

		it('Should reflect the correct value indicator and the related aria attributes when selecting a value below min', async () => {
			const { fixture, thumb, valueIndicatorPre } = await setupSliderWithInitialValue(67);

			fixture.detectChanges();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 67');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('67');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(-25);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 0');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});

		it('Should reflect the correct value indicator and the related aria attributes when selecting a value after max', async () => {
			const { fixture, thumb, valueIndicatorPre } = await setupSliderWithInitialValue(34);

			fixture.detectChanges();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 34');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('34');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(225);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 100');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('100');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});

		it('Should reflect the correct value indicator and the related aria attributes when changing the slider value', async () => {
			const { fixture, thumb, changeValueBtn, valueIndicatorPre } = await setupSliderWithInitialValue(88);

			fixture.detectChanges();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 88');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('88');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(225);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 100');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('100');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//change slider value using a button
			await userEvent.click(changeValueBtn);

			fixture.detectChanges();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 24');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('24');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});
	});
});

```
