/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmSeparatorDirective } from './lib/hlm-separator.directive';

export * from './lib/hlm-separator.directive';

@NgModule({
	imports: [HlmSeparatorDirective],
	exports: [HlmSeparatorDirective],
})
export class HlmSeparatorModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/src/lib/hlm-separator.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export type HlmSeparatorOrientation = 'horizontal' | 'vertical';
@Directive({
	selector: '[hlmSeparator],brn-separator[hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSeparatorDirective {
	public readonly orientation = input<HlmSeparatorOrientation>('horizontal');
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'inline-flex shrink-0 border-0 bg-border',
			this.orientation() === 'horizontal' ? 'h-[1px] w-full' : 'h-full w-[1px]',
			this.userClass(),
		),
	);
}

```
