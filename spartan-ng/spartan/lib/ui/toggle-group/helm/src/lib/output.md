/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/src/lib/hlm-toggle-group.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { VariantProps } from 'class-variance-authority';
import type { ClassValue } from 'clsx';
import { provideHlmToggleGroup } from './hlm-toggle-group.token';
import { toggleGroupItemVariants } from './hlm-toggle-item.directive';

type ToggleGroupItemVariants = VariantProps<typeof toggleGroupItemVariants>;
@Directive({
	selector: 'brn-toggle-group[hlm],[hlmToggleGroup]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	providers: [provideHlmToggleGroup(HlmToggleGroupDirective)],
})
export class HlmToggleGroupDirective {
	public readonly variant = input<ToggleGroupItemVariants['variant']>('default');
	public readonly size = input<ToggleGroupItemVariants['size']>('default');
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm('inline-flex items-center gap-x-2 focus:[&>[hlm][brnToggle]]:z-10', {
			'gap-x-0 rounded-md first-of-type:[&>[hlmToggleGroupItem]]:rounded-l-md last-of-type:[&>[hlmToggleGroupItem]]:rounded-r-md [&>[hlmToggleGroupItem][variant="outline"]]:-mx-[0.5px] [&>[hlmToggleGroupItem]]:rounded-none':
				this.variant() === 'merged',
			[String(this.userClass())]: !!this.userClass(),
		}),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/src/lib/hlm-toggle-group.token.ts
```typescript
import { ExistingProvider, InjectionToken, Type, inject } from '@angular/core';
import type { HlmToggleGroupDirective } from './hlm-toggle-group.directive';

const HlmToggleGroupToken = new InjectionToken<HlmToggleGroupDirective>('HlmToggleGroupToken');

export function provideHlmToggleGroup(config: Type<HlmToggleGroupDirective>): ExistingProvider {
	return { provide: HlmToggleGroupToken, useExisting: config };
}

export function injectHlmToggleGroup(): HlmToggleGroupDirective {
	return inject(HlmToggleGroupToken, { optional: true }) as HlmToggleGroupDirective;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/src/lib/hlm-toggle-item.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';
import { injectHlmToggleGroup } from './hlm-toggle-group.token';

export const toggleGroupItemVariants = cva(
	'inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors hover:bg-muted hover:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=on]:bg-accent data-[state=on]:text-accent-foreground',
	{
		variants: {
			variant: {
				default: 'bg-transparent',
				outline: 'border border-input bg-transparent hover:bg-accent hover:text-accent-foreground',
				merged:
					'border border-l-0 first-of-type:border-l border-input bg-transparent hover:bg-accent hover:text-accent-foreground',
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
type ToggleGroupItemVariants = VariantProps<typeof toggleGroupItemVariants>;

@Directive({
	selector: '[hlmToggleGroupItem],[brnToggleGroupItem][hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmToggleGroupItemDirective {
	private readonly _parentGroup = injectHlmToggleGroup();
	public readonly variant = input<ToggleGroupItemVariants['variant']>('default');
	public readonly size = input<ToggleGroupItemVariants['size']>('default');
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => {
		const variantToUse = this._parentGroup?.variant() ?? this.variant();
		const sizeToUse = this._parentGroup?.size() ?? this.size();
		const userClass = this._parentGroup?.userClass() ?? this.userClass();
		return hlm(
			toggleGroupItemVariants({
				variant: variantToUse,
				size: sizeToUse,
			}),
			userClass,
		);
	});
}

```
