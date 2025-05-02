/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmCardContentDirective } from './lib/hlm-card-content.directive';
import { HlmCardDescriptionDirective } from './lib/hlm-card-description.directive';
import { HlmCardFooterDirective } from './lib/hlm-card-footer.directive';
import { HlmCardHeaderDirective } from './lib/hlm-card-header.directive';
import { HlmCardTitleDirective } from './lib/hlm-card-title.directive';
import { HlmCardDirective } from './lib/hlm-card.directive';

export * from './lib/hlm-card-content.directive';
export * from './lib/hlm-card-description.directive';
export * from './lib/hlm-card-footer.directive';
export * from './lib/hlm-card-header.directive';
export * from './lib/hlm-card-title.directive';
export * from './lib/hlm-card.directive';

export const HlmCardImports = [
	HlmCardDirective,
	HlmCardHeaderDirective,
	HlmCardFooterDirective,
	HlmCardTitleDirective,
	HlmCardDescriptionDirective,
	HlmCardContentDirective,
] as const;

@NgModule({
	imports: [...HlmCardImports],
	exports: [...HlmCardImports],
})
export class HlmCardModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/lib/hlm-card-content.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const cardContentVariants = cva('p-6 pt-0', {
	variants: {},
	defaultVariants: {},
});
export type CardContentVariants = VariantProps<typeof cardContentVariants>;

@Directive({
	selector: '[hlmCardContent]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCardContentDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(cardContentVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/lib/hlm-card-description.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const cardDescriptionVariants = cva('text-sm text-muted-foreground', {
	variants: {},
	defaultVariants: {},
});
export type CardDescriptionVariants = VariantProps<typeof cardDescriptionVariants>;

@Directive({
	selector: '[hlmCardDescription]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCardDescriptionDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(cardDescriptionVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/lib/hlm-card-footer.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const cardFooterVariants = cva('flex p-6 pt-0', {
	variants: {
		direction: {
			row: 'flex-row items-center space-x-1.5',
			column: 'flex-col space-y-1.5',
		},
	},
	defaultVariants: {
		direction: 'row',
	},
});
export type CardFooterVariants = VariantProps<typeof cardFooterVariants>;

@Directive({
	selector: '[hlmCardFooter]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCardFooterDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(cardFooterVariants({ direction: this.direction() }), this.userClass()));

	public readonly direction = input<CardFooterVariants['direction']>('row');
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/lib/hlm-card-header.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const cardHeaderVariants = cva('flex p-6', {
	variants: {
		direction: {
			row: 'flex-row items-center space-x-1.5',
			column: 'flex-col space-y-1.5',
		},
	},
	defaultVariants: {
		direction: 'column',
	},
});
export type CardHeaderVariants = VariantProps<typeof cardHeaderVariants>;

@Directive({
	selector: '[hlmCardHeader]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCardHeaderDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(cardHeaderVariants({ direction: this.direction() }), this.userClass()));

	public readonly direction = input<CardHeaderVariants['direction']>('column');
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/lib/hlm-card-title.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const cardTitleVariants = cva('text-lg font-semibold leading-none tracking-tight', {
	variants: {},
	defaultVariants: {},
});
export type CardTitleVariants = VariantProps<typeof cardTitleVariants>;

@Directive({
	selector: '[hlmCardTitle]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCardTitleDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(cardTitleVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/lib/hlm-card.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const cardVariants = cva(
	'rounded-lg border border-border bg-card focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 text-card-foreground shadow-sm',
	{
		variants: {},
		defaultVariants: {},
	},
);
export type CardVariants = VariantProps<typeof cardVariants>;

@Directive({
	selector: '[hlmCard]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCardDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(cardVariants(), this.userClass()));
}

```
