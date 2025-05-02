/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-helm/files/lib/hlm-alert-description.directive.ts.template
```
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const alertDescriptionVariants = cva('text-sm [&_p]:leading-relaxed', {
	variants: {},
});
export type AlertDescriptionVariants = VariantProps<typeof alertDescriptionVariants>;

@Directive({
	selector: '[hlmAlertDesc],[hlmAlertDescription]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmAlertDescriptionDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm(alertDescriptionVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-helm/files/lib/hlm-alert-icon.directive.ts.template
```
import { Directive } from '@angular/core';
import { provideHlmIconConfig } from '@spartan-ng/ui-icon-helm';

@Directive({
	selector: '[hlmAlertIcon]',
	standalone: true,
	providers: [provideHlmIconConfig({ size: 'sm' })],
})
export class HlmAlertIconDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-helm/files/lib/hlm-alert-title.directive.ts.template
```
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const alertTitleVariants = cva('mb-1 font-medium leading-none tracking-tight', {
	variants: {},
});
export type AlertTitleVariants = VariantProps<typeof alertTitleVariants>;

@Directive({
	selector: '[hlmAlertTitle]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmAlertTitleDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm(alertTitleVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-helm/files/lib/hlm-alert.directive.ts.template
```
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const alertVariants = cva(
	'relative w-full rounded-lg border border-border p-4 [&>[hlmAlertIcon]]:absolute [&>[hlmAlertIcon]]:text-foreground [&>[hlmAlertIcon]]:left-4 [&>[hlmAlertIcon]]:top-4 [&>[hlmAlertIcon]+div]:translate-y-[-3px] [&>[hlmAlertIcon]~*]:pl-7',
	{
		variants: {
			variant: {
				default: 'bg-background text-foreground',
				destructive:
					'text-destructive border-destructive/50 dark:border-destructive [&>[hlmAlertIcon]]:text-destructive',
			},
		},
		defaultVariants: {
			variant: 'default',
		},
	},
);
export type AlertVariants = VariantProps<typeof alertVariants>;

@Directive({
	selector: '[hlmAlert]',
	standalone: true,
	host: {
		role: 'alert',
		'[class]': '_computedClass()',
	},
})
export class HlmAlertDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm(alertVariants({ variant: this.variant() }), this.userClass()));

	public readonly variant = input<AlertVariants['variant']>('default');
}

```
