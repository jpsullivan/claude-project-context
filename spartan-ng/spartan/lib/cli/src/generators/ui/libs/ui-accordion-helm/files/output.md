/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-accordion-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';

import { HlmAccordionContentComponent } from './lib/hlm-accordion-content.component';
import { HlmAccordionIconDirective } from './lib/hlm-accordion-icon.directive';
import { HlmAccordionItemDirective } from './lib/hlm-accordion-item.directive';
import { HlmAccordionTriggerDirective } from './lib/hlm-accordion-trigger.directive';
import { HlmAccordionDirective } from './lib/hlm-accordion.directive';

export * from './lib/hlm-accordion-content.component';
export * from './lib/hlm-accordion-icon.directive';
export * from './lib/hlm-accordion-item.directive';
export * from './lib/hlm-accordion-trigger.directive';
export * from './lib/hlm-accordion.directive';

export const HlmAccordionImports = [
	HlmAccordionDirective,
	HlmAccordionItemDirective,
	HlmAccordionTriggerDirective,
	HlmAccordionIconDirective,
	HlmAccordionContentComponent,
] as const;

@NgModule({
	imports: [...HlmAccordionImports],
	exports: [...HlmAccordionImports],
})
export class HlmAccordionModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-accordion-helm/files/lib/hlm-accordion-content.component.ts.template
```
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, input } from '@angular/core';
import { BrnAccordionContentComponent } from '@spartan-ng/brain/accordion';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-accordion-content',
	template: `
		<div [attr.inert]="_addInert()" style="overflow: hidden">
			<p [class]="_contentClass()">
				<ng-content />
			</p>
		</div>
	`,
	standalone: true,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmAccordionContentComponent extends BrnAccordionContentComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => {
		const gridRows = this.state() === 'open' ? 'grid-rows-[1fr]' : 'grid-rows-[0fr]';
		return hlm('text-sm transition-all grid', gridRows, this.userClass());
	});

	constructor() {
		super();
		this.setClassToCustomElement('pt-1 pb-4');
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-accordion-helm/files/lib/hlm-accordion-icon.directive.ts.template
```
import { Directive, computed, input } from '@angular/core';
import { provideIcons } from '@ng-icons/core';
import { lucideChevronDown } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { provideHlmIconConfig } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';

@Directive({
	selector: 'ng-icon[hlmAccordionIcon], ng-icon[hlmAccIcon]',
	standalone: true,
	providers: [provideIcons({ lucideChevronDown }), provideHlmIconConfig({ size: 'sm' })],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmAccordionIconDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('inline-block h-4 w-4 transition-transform [animation-duration:200]', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-accordion-helm/files/lib/hlm-accordion-item.directive.ts.template
```
import { Directive, computed, input } from '@angular/core';
import { BrnAccordionItemDirective } from '@spartan-ng/brain/accordion';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmAccordionItem],brn-accordion-item[hlm],hlm-accordion-item',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [
		{
			directive: BrnAccordionItemDirective,
			inputs: ['isOpened'],
		},
	],
})
export class HlmAccordionItemDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('flex flex-1 flex-col border-b border-border', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-accordion-helm/files/lib/hlm-accordion-trigger.directive.ts.template
```
import { Directive, computed, input } from '@angular/core';
import { BrnAccordionTriggerDirective } from '@spartan-ng/brain/accordion';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmAccordionTrigger]',
	standalone: true,
	host: {
		'[style.--tw-ring-offset-shadow]': '"0 0 #000"',
		'[class]': '_computedClass()',
	},
	hostDirectives: [BrnAccordionTriggerDirective],
})
export class HlmAccordionTriggerDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'w-full focus-visible:outline-none text-sm focus-visible:ring-1 focus-visible:ring-ring focus-visible:ring-offset-2 flex flex-1 items-center justify-between py-4 px-0.5 font-medium underline-offset-4 hover:underline [&[data-state=open]>[hlmAccordionIcon]]:rotate-180 [&[data-state=open]>[hlmAccIcon]]:rotate-180',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-accordion-helm/files/lib/hlm-accordion.directive.ts.template
```
import { Directive, computed, inject, input } from '@angular/core';
import { BrnAccordionDirective } from '@spartan-ng/brain/accordion';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmAccordion], hlm-accordion',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [{ directive: BrnAccordionDirective, inputs: ['type', 'dir', 'orientation'] }],
})
export class HlmAccordionDirective {
	private readonly _brn = inject(BrnAccordionDirective);

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('flex', this._brn.orientation() === 'horizontal' ? 'flex-row' : 'flex-col', this.userClass()),
	);
}

```
