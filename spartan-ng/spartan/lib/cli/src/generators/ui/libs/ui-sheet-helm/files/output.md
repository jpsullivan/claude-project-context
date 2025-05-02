/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';

import { HlmSheetCloseDirective } from './lib/hlm-sheet-close.directive';
import { HlmSheetContentComponent } from './lib/hlm-sheet-content.component';
import { HlmSheetDescriptionDirective } from './lib/hlm-sheet-description.directive';
import { HlmSheetFooterComponent } from './lib/hlm-sheet-footer.component';
import { HlmSheetHeaderComponent } from './lib/hlm-sheet-header.component';
import { HlmSheetOverlayDirective } from './lib/hlm-sheet-overlay.directive';
import { HlmSheetTitleDirective } from './lib/hlm-sheet-title.directive';
import { HlmSheetComponent } from './lib/hlm-sheet.component';

export * from './lib/hlm-sheet-close.directive';
export * from './lib/hlm-sheet-content.component';
export * from './lib/hlm-sheet-description.directive';
export * from './lib/hlm-sheet-footer.component';
export * from './lib/hlm-sheet-header.component';
export * from './lib/hlm-sheet-overlay.directive';
export * from './lib/hlm-sheet-title.directive';
export * from './lib/hlm-sheet.component';

export const HlmSheetImports = [
	HlmSheetComponent,
	HlmSheetCloseDirective,
	HlmSheetContentComponent,
	HlmSheetDescriptionDirective,
	HlmSheetFooterComponent,
	HlmSheetHeaderComponent,
	HlmSheetOverlayDirective,
	HlmSheetTitleDirective,
] as const;

@NgModule({
	imports: [...HlmSheetImports],
	exports: [...HlmSheetImports],
})
export class HlmSheetModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet-close.directive.ts.template
```
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmSheetClose],[brnSheetClose][hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSheetCloseDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'absolute flex h-4 w-4 right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet-content.component.ts.template
```
import { Component, ElementRef, Renderer2, computed, effect, inject, input, signal } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideX } from '@ng-icons/lucide';
import { hlm, injectExposedSideProvider, injectExposesStateProvider } from '@spartan-ng/brain/core';
import { BrnSheetCloseDirective } from '@spartan-ng/brain/sheet';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import { cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';
import { HlmSheetCloseDirective } from './hlm-sheet-close.directive';

export const sheetVariants = cva(
	'fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:duration-300 data-[state=open]:duration-500',
	{
		variants: {
			side: {
				top: 'border-border inset-x-0 top-0 border-b data-[state=closed]:slide-out-to-top data-[state=open]:slide-in-from-top',
				bottom:
					'border-border inset-x-0 bottom-0 border-t data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom',
				left: 'border-border inset-y-0 left-0 h-full w-3/4 border-r data-[state=closed]:slide-out-to-left data-[state=open]:slide-in-from-left sm:max-w-sm',
				right:
					'border-border inset-y-0 right-0 h-full w-3/4  border-l data-[state=closed]:slide-out-to-right data-[state=open]:slide-in-from-right sm:max-w-sm',
			},
		},
		defaultVariants: {
			side: 'right',
		},
	},
);

@Component({
	selector: 'hlm-sheet-content',
	imports: [HlmSheetCloseDirective, BrnSheetCloseDirective, NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideX })],
	host: {
		'[class]': '_computedClass()',
		'[attr.data-state]': 'state()',
	},
	template: `
		<ng-content />
		<button brnSheetClose hlm>
			<span class="sr-only">Close</span>
			<ng-icon hlm size="sm" name="lucideX" />
		</button>
	`,
})
export class HlmSheetContentComponent {
	private readonly _stateProvider = injectExposesStateProvider({ host: true });
	private readonly _sideProvider = injectExposedSideProvider({ host: true });
	public state = this._stateProvider.state ?? signal('closed');
	private readonly _renderer = inject(Renderer2);
	private readonly _element = inject(ElementRef);

	constructor() {
		effect(() => {
			this._renderer.setAttribute(this._element.nativeElement, 'data-state', this.state());
		});
	}

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(sheetVariants({ side: this._sideProvider.side() }), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet-description.directive.ts.template
```
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnSheetDescriptionDirective } from '@spartan-ng/brain/sheet';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmSheetDescription]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [BrnSheetDescriptionDirective],
})
export class HlmSheetDescriptionDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('text-sm text-muted-foreground', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet-footer.component.ts.template
```
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-sheet-footer',
	standalone: true,
	template: `
		<ng-content />
	`,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSheetFooterComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm('flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet-header.component.ts.template
```
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-sheet-header',
	standalone: true,
	template: `
		<ng-content />
	`,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSheetHeaderComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('flex flex-col space-y-2 text-center sm:text-left', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet-overlay.directive.ts.template
```
import { Directive, computed, effect, input, untracked } from '@angular/core';
import { hlm, injectCustomClassSettable } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmSheetOverlay],brn-sheet-overlay[hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSheetOverlayDirective {
	private readonly _classSettable = injectCustomClassSettable({ optional: true, host: true });
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'bg-black/80 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0',
			this.userClass(),
		),
	);

	constructor() {
		effect(() => {
			const classValue = this._computedClass();
			untracked(() => this._classSettable?.setClassToCustomElement(classValue));
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet-title.directive.ts.template
```
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnSheetTitleDirective } from '@spartan-ng/brain/sheet';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmSheetTitle]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [BrnSheetTitleDirective],
})
export class HlmSheetTitleDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('text-lg font-semibold', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet.component.ts.template
```
import { ChangeDetectionStrategy, Component, forwardRef, ViewEncapsulation } from '@angular/core';
import { BrnDialogComponent, provideBrnDialogDefaultOptions } from '@spartan-ng/brain/dialog';
import { BrnSheetComponent, BrnSheetOverlayComponent } from '@spartan-ng/brain/sheet';
import { HlmSheetOverlayDirective } from './hlm-sheet-overlay.directive';

@Component({
	selector: 'hlm-sheet',
	imports: [BrnSheetOverlayComponent, HlmSheetOverlayDirective],
	providers: [
		{
			provide: BrnDialogComponent,
			useExisting: forwardRef(() => BrnSheetComponent),
		},
		{
			provide: BrnSheetComponent,
			useExisting: forwardRef(() => HlmSheetComponent),
		},
		provideBrnDialogDefaultOptions({
			// add custom options here
		}),
	],
	template: `
		<brn-sheet-overlay hlm />
		<ng-content />
	`,
	encapsulation: ViewEncapsulation.None,
	changeDetection: ChangeDetectionStrategy.OnPush,
	exportAs: 'hlmSheet',
})
export class HlmSheetComponent extends BrnSheetComponent {}

```
