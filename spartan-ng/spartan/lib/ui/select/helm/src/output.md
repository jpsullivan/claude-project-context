/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmSelectContentDirective } from './lib/hlm-select-content.directive';
import { HlmSelectGroupDirective } from './lib/hlm-select-group.directive';
import { HlmSelectLabelDirective } from './lib/hlm-select-label.directive';
import { HlmSelectOptionComponent } from './lib/hlm-select-option.component';
import { HlmSelectScrollDownComponent } from './lib/hlm-select-scroll-down.component';
import { HlmSelectScrollUpComponent } from './lib/hlm-select-scroll-up.component';
import { HlmSelectTriggerComponent } from './lib/hlm-select-trigger.component';
import { HlmSelectValueDirective } from './lib/hlm-select-value.directive';
import { HlmSelectDirective } from './lib/hlm-select.directive';

export * from './lib/hlm-select-content.directive';
export * from './lib/hlm-select-group.directive';
export * from './lib/hlm-select-label.directive';
export * from './lib/hlm-select-option.component';
export * from './lib/hlm-select-scroll-down.component';
export * from './lib/hlm-select-scroll-up.component';
export * from './lib/hlm-select-trigger.component';
export * from './lib/hlm-select-value.directive';
export * from './lib/hlm-select.directive';

export const HlmSelectImports = [
	HlmSelectContentDirective,
	HlmSelectTriggerComponent,
	HlmSelectOptionComponent,
	HlmSelectValueDirective,
	HlmSelectDirective,
	HlmSelectScrollUpComponent,
	HlmSelectScrollDownComponent,
	HlmSelectLabelDirective,
	HlmSelectGroupDirective,
] as const;

@NgModule({
	imports: [...HlmSelectImports],
	exports: [...HlmSelectImports],
})
export class HlmSelectModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-content.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm, injectExposedSideProvider, injectExposesStateProvider } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmSelectContent], hlm-select-content',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		'[attr.data-state]': '_stateProvider?.state() ?? "open"',
		'[attr.data-side]': '_sideProvider?.side() ?? "bottom"',
	},
})
export class HlmSelectContentDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly stickyLabels = input<boolean>(false);
	protected readonly _stateProvider = injectExposesStateProvider({ optional: true });
	protected readonly _sideProvider = injectExposedSideProvider({ optional: true });

	protected readonly _computedClass = computed(() =>
		hlm(
			'w-full relative z-50 min-w-[8rem] overflow-hidden rounded-md border border-border bg-popover text-popover-foreground shadow-md p-1 data-[side=bottom]:top-[2px] data-[side=top]:bottom-[2px] data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-group.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnSelectGroupDirective } from '@spartan-ng/brain/select';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmSelectGroup], hlm-select-group',
	hostDirectives: [BrnSelectGroupDirective],
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSelectGroupDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm(this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-label.directive.ts
```typescript
import { Directive, computed, inject, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnSelectLabelDirective } from '@spartan-ng/brain/select';
import type { ClassValue } from 'clsx';
import { HlmSelectContentDirective } from './hlm-select-content.directive';

@Directive({
	selector: '[hlmSelectLabel], hlm-select-label',
	hostDirectives: [BrnSelectLabelDirective],
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSelectLabelDirective {
	private readonly _selectContent = inject(HlmSelectContentDirective);
	private readonly _stickyLabels = computed(() => this._selectContent.stickyLabels());
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'pl-8 pr-2 text-sm font-semibold rtl:pl-2 rtl:pr-8',
			this._stickyLabels() ? 'sticky top-0 bg-popover block z-[2]' : '',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-option.component.ts
```typescript
import { ChangeDetectionStrategy, Component, computed, inject, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideCheck } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { BrnSelectOptionDirective } from '@spartan-ng/brain/select';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-option',
	changeDetection: ChangeDetectionStrategy.OnPush,
	hostDirectives: [{ directive: BrnSelectOptionDirective, inputs: ['disabled', 'value'] }],
	providers: [provideIcons({ lucideCheck })],
	host: {
		'[class]': '_computedClass()',
	},
	template: `
		<ng-content />
		<span
			[attr.dir]="_brnSelectOption.dir()"
			class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center rtl:left-auto rtl:right-2"
			[attr.data-state]="this._brnSelectOption.checkedState()"
		>
			@if (this._brnSelectOption.selected()) {
				<ng-icon hlm size="sm" aria-hidden="true" name="lucideCheck" />
			}
		</span>
	`,
	imports: [NgIcon, HlmIconDirective],
})
export class HlmSelectOptionComponent {
	protected readonly _brnSelectOption = inject(BrnSelectOptionDirective, { host: true });
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 rtl:flex-reverse rtl:pr-8 rtl:pl-2 text-sm outline-none data-[active]:bg-accent data-[active]:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-scroll-down.component.ts
```typescript
import { Component } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronDown } from '@ng-icons/lucide';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';

@Component({
	selector: 'hlm-select-scroll-down',
	imports: [NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideChevronDown })],
	host: {
		class: 'flex cursor-default items-center justify-center py-1',
	},
	template: `
		<ng-icon hlm size="sm" class="ml-2" name="lucideChevronDown" />
	`,
})
export class HlmSelectScrollDownComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-scroll-up.component.ts
```typescript
import { Component } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronUp } from '@ng-icons/lucide';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';

@Component({
	selector: 'hlm-select-scroll-up',
	imports: [NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideChevronUp })],
	host: {
		class: 'flex cursor-default items-center justify-center py-1',
	},
	template: `
		<ng-icon hlm size="sm" class="ml-2" name="lucideChevronUp" />
	`,
})
export class HlmSelectScrollUpComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-trigger.component.ts
```typescript
import { Component, computed, contentChild, inject, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronDown } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { BrnSelectComponent, BrnSelectTriggerDirective } from '@spartan-ng/brain/select';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const selectTriggerVariants = cva(
	'flex items-center justify-between rounded-md border border-input bg-background text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50',
	{
		variants: {
			size: {
				default: 'h-10 py-2 px-4',
				sm: 'h-9 px-3',
				lg: 'h-11 px-8',
			},
			error: {
				auto: '[&.ng-invalid.ng-touched]:text-destructive [&.ng-invalid.ng-touched]:border-destructive [&.ng-invalid.ng-touched]:focus-visible:ring-destructive',
				true: 'text-destructive border-destructive focus-visible:ring-destructive',
			},
		},
		defaultVariants: {
			size: 'default',
			error: 'auto',
		},
	},
);
type SelectTriggerVariants = VariantProps<typeof selectTriggerVariants>;

@Component({
	selector: 'hlm-select-trigger',
	imports: [BrnSelectTriggerDirective, NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideChevronDown })],
	template: `
		<button [class]="_computedClass()" #button hlmInput brnSelectTrigger type="button">
			<ng-content />
			@if (icon()) {
				<ng-content select="ng-icon" />
			} @else {
				<ng-icon hlm size="sm" class="ml-2 flex-none" name="lucideChevronDown" />
			}
		</button>
	`,
})
export class HlmSelectTriggerComponent {
	protected readonly icon = contentChild(HlmIconDirective);

	protected readonly brnSelect = inject(BrnSelectComponent, { optional: true });

	public readonly _size = input<SelectTriggerVariants['size']>('default');
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected _computedClass = computed(() =>
		hlm(selectTriggerVariants({ size: this._size(), error: this.brnSelect?.errorState() }), this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-value.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: 'hlm-select-value,[hlmSelectValue], brn-select-value[hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSelectValueDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'!inline-block ltr:text-left rtl:text-right border-border w-[calc(100%)]] min-w-0 pointer-events-none truncate data-[placeholder]:text-muted-foreground',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: 'hlm-select, brn-select [hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSelectDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm('space-y-2', this.userClass()));
}

```
