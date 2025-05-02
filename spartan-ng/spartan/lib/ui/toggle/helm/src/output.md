/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmToggleDirective } from './lib/hlm-toggle.directive';

export * from './lib/hlm-toggle.directive';
@NgModule({
	imports: [HlmToggleDirective],
	exports: [HlmToggleDirective],
})
export class HlmToggleModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/src/lib/hlm-toggle.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { cva, type VariantProps } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const toggleVariants = cva(
	'inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors hover:bg-muted hover:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=on]:bg-accent data-[state=on]:text-accent-foreground',
	{
		variants: {
			variant: {
				default: 'bg-transparent',
				outline: 'border border-input bg-transparent hover:bg-accent hover:text-accent-foreground',
			},
			size: {
				default: 'h-9 px-3',
				sm: 'h-8 px-2',
				lg: 'h-10 px-3',
			},
		},
		defaultVariants: {
			variant: 'default',
			size: 'default',
		},
	},
);
export type ToggleVariants = VariantProps<typeof toggleVariants>;

@Directive({
	selector: '[hlmToggle],[brnToggle][hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmToggleDirective {
	public readonly variant = input<ToggleVariants['variant']>('default');
	public readonly size = input<ToggleVariants['size']>('default');
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => {
		const variantToUse = this.variant();
		const sizeToUse = this.size();
		const userClass = this.userClass();

		return hlm(
			toggleVariants({
				variant: variantToUse,
				size: sizeToUse,
			}),
			userClass,
		);
	});
}

```
