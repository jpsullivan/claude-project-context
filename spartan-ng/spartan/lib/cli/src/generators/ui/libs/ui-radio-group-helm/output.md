/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-radio-group-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'radiogroup',
		internalName: 'ui-radio-group-helm',
		publicName: 'ui-radiogroup-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-radio-group-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';

import { HlmRadioGroupComponent } from './lib/hlm-radio-group.component';
import { HlmRadioIndicatorComponent } from './lib/hlm-radio-indicator.component';
import { HlmRadioComponent } from './lib/hlm-radio.component';

export * from './lib/hlm-radio-group.component';
export * from './lib/hlm-radio-indicator.component';
export * from './lib/hlm-radio.component';

export const HlmRadioGroupImports = [HlmRadioGroupComponent, HlmRadioComponent, HlmRadioIndicatorComponent];

@NgModule({
	imports: [...HlmRadioGroupImports],
	exports: [...HlmRadioGroupImports],
})
export class HlmRadioGroupModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-radio-group-helm/files/lib/hlm-radio-group.component.ts.template
```
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnRadioGroupDirective } from '@spartan-ng/brain/radio-group';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-radio-group',
	standalone: true,
	hostDirectives: [
		{
			directive: BrnRadioGroupDirective,
			inputs: ['name', 'value', 'disabled', 'required', 'direction'],
		},
	],
	host: {
		'[class]': '_computedClass()',
	},
	template: '<ng-content />',
})
export class HlmRadioGroupComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('grid gap-2', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-radio-group-helm/files/lib/hlm-radio-indicator.component.ts.template
```
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

const btnLike =
	'aspect-square rounded-full ring-offset-background group-[.cdk-keyboard-focused]:ring-2 group-[.cdk-keyboard-focused]:ring-ring group-[.cdk-keyboard-focused]:ring-offset-2 group-[.brn-radio-disabled]:cursor-not-allowed group-[.brn-radio-disabled]:opacity-50';

@Component({
	selector: 'hlm-radio-indicator',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	template: `
		<div
			class="bg-foreground absolute inset-0 hidden scale-[55%] rounded-full group-[.brn-radio-checked]:inline-block"
		></div>
		<div class="border-primary ${btnLike} rounded-full border"></div>
	`,
})
export class HlmRadioIndicatorComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('relative inline-flex h-4 w-4', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-radio-group-helm/files/lib/hlm-radio.component.ts.template
```
import { booleanAttribute, Component, computed, input, output } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnRadioChange, BrnRadioComponent } from '@spartan-ng/brain/radio-group';
import { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-radio',
	imports: [BrnRadioComponent],
	template: `
		<brn-radio
			[id]="id()"
			[class]="_computedClass()"
			[value]="value()"
			[required]="required()"
			[disabled]="disabled()"
			[aria-label]="ariaLabel()"
			[aria-labelledby]="ariaLabelledby()"
			[aria-describedby]="ariaDescribedby()"
			(change)="change.emit($event)"
		>
			<ng-content select="[target],[indicator]" indicator />
			<ng-content />
		</brn-radio>
	`,
})
export class HlmRadioComponent<T = unknown> {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'group [&.brn-radio-disabled]:text-muted-foreground flex items-center space-x-2 rtl:space-x-reverse',
			this.userClass(),
		),
	);

	/** Used to set the id on the underlying brn element. */
	public readonly id = input<string | undefined>(undefined);

	/** Used to set the aria-label attribute on the underlying brn element. */
	public readonly ariaLabel = input<string | undefined>(undefined, { alias: 'aria-label' });

	/** Used to set the aria-labelledby attribute on the underlying brn element. */
	public readonly ariaLabelledby = input<string | undefined>(undefined, { alias: 'aria-labelledby' });

	/** Used to set the aria-describedby attribute on the underlying brn element. */
	public readonly ariaDescribedby = input<string | undefined>(undefined, { alias: 'aria-describedby' });

	/**
	 * The value this radio button represents.
	 */
	public readonly value = input.required<T>();

	/** Whether the checkbox is required. */
	public readonly required = input(false, { transform: booleanAttribute });

	/** Whether the checkbox is disabled. */
	public readonly disabled = input(false, { transform: booleanAttribute });

	/**
	 * Event emitted when the checked state of this radio button changes.
	 */
	public readonly change = output<BrnRadioChange<T>>();
}

```
