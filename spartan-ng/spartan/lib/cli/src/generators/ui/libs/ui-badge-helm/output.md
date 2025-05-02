/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-badge-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'badge',
		internalName: 'ui-badge-helm',
		publicName: 'ui-badge-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-badge-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';
import { HlmBadgeDirective } from './lib/hlm-badge.directive';

export * from './lib/hlm-badge.directive';

@NgModule({
	imports: [HlmBadgeDirective],
	exports: [HlmBadgeDirective],
})
export class HlmBadgeModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-badge-helm/files/lib/hlm-badge.directive.ts.template
```
import type { BooleanInput } from '@angular/cdk/coercion';
import { Directive, booleanAttribute, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const badgeVariants = cva(
	'inline-flex items-center border rounded-full px-2.5 py-0.5 font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2',
	{
		variants: {
			variant: {
				default: 'bg-primary border-transparent text-primary-foreground',
				secondary: 'bg-secondary border-transparent text-secondary-foreground',
				destructive: 'bg-destructive border-transparent text-destructive-foreground',
				outline: 'text-foreground border-border',
			},
			size: {
				default: 'text-xs',
				lg: 'text-sm',
			},
			static: { true: '', false: '' },
		},
		compoundVariants: [
			{
				variant: 'default',
				static: false,
				class: 'hover:bg-primary/80',
			},
			{
				variant: 'secondary',
				static: false,
				class: 'hover:bg-secondary/80',
			},
			{
				variant: 'destructive',
				static: false,
				class: 'hover:bg-destructive/80',
			},
		],
		defaultVariants: {
			variant: 'default',
			size: 'default',
			static: false,
		},
	},
);
export type BadgeVariants = VariantProps<typeof badgeVariants>;

@Directive({
	selector: '[hlmBadge]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmBadgeDirective {
	protected readonly _computedClass = computed(() =>
		hlm(badgeVariants({ variant: this.variant(), size: this.size(), static: this.static() }), this.userClass()),
	);

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly variant = input<BadgeVariants['variant']>('default');
	public readonly static = input<BadgeVariants['static'], BooleanInput>(false, { transform: booleanAttribute });
	public readonly size = input<BadgeVariants['size']>('default');
}

```
