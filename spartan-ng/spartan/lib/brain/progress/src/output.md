/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/progress/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnProgressIndicatorComponent } from './lib/brn-progress-indicator.component';
import { BrnProgressComponent } from './lib/brn-progress.component';
export { injectBrnProgress } from './lib/brn-progress.token';

export * from './lib/brn-progress-indicator.component';
export * from './lib/brn-progress.component';

export const BrnProgressImports = [BrnProgressComponent, BrnProgressIndicatorComponent] as const;

@NgModule({
	imports: [...BrnProgressImports],
	exports: [...BrnProgressImports],
})
export class BrnProgressModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/progress/src/lib/brn-progress-indicator.component.ts
```typescript
import { Component } from '@angular/core';
import { injectBrnProgress } from './brn-progress.token';

@Component({
	selector: 'brn-progress-indicator',
	standalone: true,
	template: '',
	host: {
		'[attr.data-state]': 'progress.state()',
		'[attr.data-value]': 'progress.value()',
		'[attr.data-max]': 'progress.max()',
	},
})
export class BrnProgressIndicatorComponent {
	protected readonly progress = injectBrnProgress();
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/progress/src/lib/brn-progress.component.spec.ts
```typescript
import { Component } from '@angular/core';
import { render } from '@testing-library/angular';
import { BrnProgressModule } from '../index';
import { BrnProgressIndicatorComponent } from './brn-progress-indicator.component';
import { BrnProgressComponent, BrnProgressLabelFn } from './brn-progress.component';

@Component({
	imports: [BrnProgressModule],
	template: `
		<brn-progress [value]="value" [max]="max" [getValueLabel]="getValueLabel">
			<brn-progress-indicator />
		</brn-progress>
	`,
})
class TestHostComponent {
	public value: number | null | undefined = 0;
	public max = 100;
	public getValueLabel: BrnProgressLabelFn = (value, max) => `${Math.round((value / max) * 100)}%`;
}

describe('BrnProgressComponent', () => {
	it('should initialize with default values and set aria attributes', async () => {
		const { container } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
		});
		const progressBar = container.querySelector('brn-progress');

		expect(progressBar?.getAttribute('aria-valuemax')).toBe('100');
		expect(progressBar?.getAttribute('aria-valuemin')).toBe('0');
		expect(progressBar?.getAttribute('aria-valuenow')).toBe('0');
		expect(progressBar?.getAttribute('aria-valuetext')).toBe('0%');
	});

	it('should display "indeterminate" state when value is null or undefined', async () => {
		const { fixture, container } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
			componentProperties: { value: null },
		});
		fixture.detectChanges();

		const progressBar = container.querySelector('brn-progress');
		expect(progressBar?.getAttribute('data-state')).toBe('indeterminate');
		expect(progressBar?.getAttribute('aria-valuetext')).toBe(null);
	});

	it('should set aria attributes based on provided value and max', async () => {
		const { fixture, container } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
			componentProperties: { value: 50, max: 200 },
		});
		fixture.detectChanges();

		const progressBar = container.querySelector('brn-progress');
		expect(progressBar?.getAttribute('aria-valuenow')).toBe('50');
		expect(progressBar?.getAttribute('aria-valuemax')).toBe('200');
		expect(progressBar?.getAttribute('aria-valuetext')).toBe('25%');
	});

	it('should set state to "complete" when value equals max', async () => {
		const { fixture, container } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
			componentProperties: { value: 100, max: 100 },
		});
		fixture.detectChanges();

		const progressBar = container.querySelector('brn-progress');
		expect(progressBar?.getAttribute('data-state')).toBe('complete');
	});

	it('should set state to "loading" when value is within bounds and not equal to max', async () => {
		const { fixture, container } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
			componentProperties: { value: 50, max: 100 },
		});
		fixture.detectChanges();

		const progressBar = container.querySelector('brn-progress');
		expect(progressBar?.getAttribute('data-state')).toBe('loading');
	});

	it('should throw an error if value is out of bounds', async () => {
		const { fixture } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
		});

		expect(() => {
			fixture.componentInstance.value = 150;
			fixture.detectChanges();
		}).toThrow('Value must be 0 or greater and less or equal to max');

		expect(() => {
			fixture.componentInstance.value = -10;
			fixture.detectChanges();
		}).toThrow('Value must be 0 or greater and less or equal to max');
	});

	it('should throw an error if max is set to a negative number', async () => {
		const { fixture } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
		});

		expect(() => {
			fixture.componentInstance.max = -50;
			fixture.detectChanges();
		}).toThrow('Value must be 0 or greater and less or equal to max');
	});

	it('should reflect state, value, and max in BrnProgressIndicatorComponent', async () => {
		const { fixture, container } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
			componentProperties: { value: 30, max: 100 },
		});
		fixture.detectChanges();

		const indicator = container.querySelector('brn-progress-indicator');
		expect(indicator?.getAttribute('data-state')).toBe('loading');
		expect(indicator?.getAttribute('data-value')).toBe('30');
		expect(indicator?.getAttribute('data-max')).toBe('100');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/progress/src/lib/brn-progress.component.ts
```typescript
import { type NumberInput } from '@angular/cdk/coercion';
import { Component, OnChanges, SimpleChanges, computed, input, numberAttribute } from '@angular/core';
import { provideBrnProgress } from './brn-progress.token';

@Component({
	selector: 'brn-progress',
	standalone: true,
	template: '<ng-content/>',
	exportAs: 'brnProgress',
	providers: [provideBrnProgress(BrnProgressComponent)],
	host: {
		role: 'progressbar',
		'[attr.aria-valuemax]': 'max()',
		'[attr.aria-valuemin]': '0',
		'[attr.aria-valuenow]': 'value()',
		'[attr.aria-valuetext]': 'label()',
		'[attr.data-state]': 'state()',
		'[attr.data-value]': 'value()',
		'[attr.data-max]': 'max()',
	},
})
export class BrnProgressComponent implements OnChanges {
	public readonly value = input<number | null | undefined, NumberInput>(undefined, {
		transform: (value) => (value === undefined || value === null ? undefined : Number(value)),
	});
	public readonly max = input<number, NumberInput>(100, { transform: numberAttribute });
	public readonly getValueLabel = input<BrnProgressLabelFn>((value, max) => `${Math.round((value / max) * 100)}%`);
	protected readonly label = computed(() => {
		const value = this.value();
		return value === null || value === undefined ? undefined : this.getValueLabel()(value, this.max());
	});

	protected readonly state = computed(() => {
		const value = this.value();
		const max = this.max();

		return value === null || value === undefined ? 'indeterminate' : value === max ? 'complete' : 'loading';
	});

	ngOnChanges(changes: SimpleChanges): void {
		if ('value' in changes || 'max' in changes) {
			this.validate();
		}
	}

	private validate(): void {
		// validate that the value is within the bounds of the max
		const value = this.value();
		const max = this.max();

		if (value === null || value === undefined) {
			return;
		}

		if (value > max || value < 0) {
			throw Error('Value must be 0 or greater and less or equal to max');
		}

		if (max < 0) {
			throw Error('max must be greater than 0');
		}
	}
}

export type BrnProgressLabelFn = (value: number, max: number) => string;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/progress/src/lib/brn-progress.token.ts
```typescript
import { ExistingProvider, InjectionToken, Type, inject } from '@angular/core';
import type { BrnProgressComponent } from './brn-progress.component';

const BrnProgressToken = new InjectionToken<BrnProgressComponent>('BrnProgressComponent');

export function provideBrnProgress(progress: Type<BrnProgressComponent>): ExistingProvider {
	return { provide: BrnProgressToken, useExisting: progress };
}

export function injectBrnProgress(): BrnProgressComponent {
	return inject(BrnProgressToken);
}

```
