/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmProgressIndicatorDirective } from './lib/hlm-progress-indicator.directive';
import { HlmProgressDirective } from './lib/hlm-progress.directive';

export * from './lib/hlm-progress-indicator.directive';
export * from './lib/hlm-progress.directive';

export const HlmProgressImports = [HlmProgressDirective, HlmProgressIndicatorDirective] as const;

@NgModule({
	imports: [...HlmProgressImports],
	exports: [...HlmProgressImports],
})
export class HlmProgressModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/src/test-setup.ts
```typescript
// @ts-expect-error https://thymikee.github.io/jest-preset-angular/docs/getting-started/test-environment
globalThis.ngJest = {
	testEnvironmentOptions: {
		errorOnUnknownElements: true,
		errorOnUnknownProperties: true,
	},
};
import 'jest-preset-angular/setup-jest';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/src/lib/hlm-progress-indicator.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { injectBrnProgress } from '@spartan-ng/brain/progress';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmProgressIndicator],brn-progress-indicator[hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		'[class.animate-indeterminate]': 'indeterminate()',
		'[style.transform]': 'transform()',
	},
})
export class HlmProgressIndicatorDirective {
	private readonly _progress = injectBrnProgress();
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm('inline-flex transform-gpu h-full w-full flex-1 bg-primary transition-all', this.userClass()),
	);

	protected readonly transform = computed(() => `translateX(-${100 - (this._progress.value() ?? 100)}%)`);

	protected readonly indeterminate = computed(
		() => this._progress.value() === null || this._progress.value() === undefined,
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/src/lib/hlm-progress.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmProgress],brn-progress[hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmProgressDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('inline-flex relative h-4 w-full overflow-hidden rounded-full bg-secondary', this.userClass()),
	);
}

```
