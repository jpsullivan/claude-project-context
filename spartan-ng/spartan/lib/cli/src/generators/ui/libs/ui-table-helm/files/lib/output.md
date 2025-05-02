/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-table-helm/files/lib/hlm-caption.component.ts.template
```
import {
	ChangeDetectionStrategy,
	Component,
	ViewEncapsulation,
	booleanAttribute,
	computed,
	effect,
	inject,
	input,
	untracked,
} from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';
import { HlmTableComponent } from './hlm-table.component';

let captionIdSequence = 0;

@Component({
	selector: 'hlm-caption',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		'[id]': 'id()',
	},
	template: `
		<ng-content />
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class HlmCaptionComponent {
	private readonly _table = inject(HlmTableComponent, { optional: true });

	protected readonly id = input<string | null | undefined>(`${captionIdSequence++}`);

	public readonly hidden = input(false, { transform: booleanAttribute });
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'text-center block mt-4 text-sm text-muted-foreground',
			this.hidden() ? 'sr-only' : 'order-last',
			this.userClass(),
		),
	);

	constructor() {
		effect(() => {
			const id = this.id();
			untracked(() => {
				if (!this._table) return;
				this._table.labeledBy.set(id);
			});
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-table-helm/files/lib/hlm-table.component.ts.template
```
import {
	ChangeDetectionStrategy,
	Component,
	ViewEncapsulation,
	computed,
	effect,
	input,
	signal,
	untracked,
} from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-table',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		role: 'table',
		'[attr.aria-labelledby]': 'labeledBy()',
	},
	template: `
		<ng-content />
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class HlmTableComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('flex flex-col text-sm [&_hlm-trow:last-child]:border-0', this.userClass()),
	);

	// we aria-labelledby to be settable from outside but use the input by default.
	public readonly _labeledByInput = input<string | null | undefined>(undefined, { alias: 'aria-labelledby' });
	public readonly labeledBy = signal<string | null | undefined>(undefined);

	constructor() {
		effect(() => {
			const labeledBy = this._labeledByInput();
			untracked(() => {
				this.labeledBy.set(labeledBy);
			});
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-table-helm/files/lib/hlm-table.directive.ts.template
```
import { Directive } from '@angular/core';
import { injectTableClassesSettable } from '@spartan-ng/brain/core';

@Directive({ standalone: true, selector: '[hlmTable],brn-table[hlm]' })
export class HlmTableDirective {
	private readonly _tableClassesSettable = injectTableClassesSettable({ host: true, optional: true });

	constructor() {
		this._tableClassesSettable?.setTableClasses({
			table: 'flex flex-col text-sm [&_cdk-row:last-child]:border-0',
			headerRow:
				'flex min-w-[100%] w-fit border-b border-border [&.cdk-table-sticky]:bg-background ' +
				'[&.cdk-table-sticky>*]:z-[101] [&.cdk-table-sticky]:before:z-0 [&.cdk-table-sticky]:before:block [&.cdk-table-sticky]:hover:before:bg-muted/50 [&.cdk-table-sticky]:before:absolute [&.cdk-table-sticky]:before:inset-0',
			bodyRow:
				'flex min-w-[100%] w-fit border-b border-border transition-[background-color] hover:bg-muted/50 [&:has([role=checkbox][aria-checked=true])]:bg-muted',
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-table-helm/files/lib/hlm-td.component.ts.template
```
import { NgTemplateOutlet } from '@angular/common';
import {
	ChangeDetectionStrategy,
	Component,
	ViewEncapsulation,
	booleanAttribute,
	computed,
	inject,
	input,
} from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnColumnDefComponent } from '@spartan-ng/brain/table';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-td',
	imports: [NgTemplateOutlet],
	host: {
		'[class]': '_computedClass()',
	},
	template: `
		<ng-template #content>
			<ng-content />
		</ng-template>
		@if (truncate()) {
			<span class="flex-1 truncate">
				<ng-container [ngTemplateOutlet]="content" />
			</span>
		} @else {
			<ng-container [ngTemplateOutlet]="content" />
		}
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class HlmTdComponent {
	private readonly _columnDef? = inject(BrnColumnDefComponent, { optional: true });
	public readonly truncate = input(false, { transform: booleanAttribute });

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('flex flex-none p-4 items-center [&:has([role=checkbox])]:pr-0', this._columnDef?.class(), this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-table-helm/files/lib/hlm-th.component.ts.template
```
import { NgTemplateOutlet } from '@angular/common';
import {
	ChangeDetectionStrategy,
	Component,
	ViewEncapsulation,
	booleanAttribute,
	computed,
	inject,
	input,
} from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnColumnDefComponent } from '@spartan-ng/brain/table';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-th',
	imports: [NgTemplateOutlet],
	host: {
		'[class]': '_computedClass()',
	},
	template: `
		<ng-template #content>
			<ng-content />
		</ng-template>
		@if (truncate()) {
			<span class="flex-1 truncate">
				<ng-container [ngTemplateOutlet]="content" />
			</span>
		} @else {
			<ng-container [ngTemplateOutlet]="content" />
		}
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class HlmThComponent {
	private readonly _columnDef? = inject(BrnColumnDefComponent, { optional: true });
	public readonly truncate = input(false, { transform: booleanAttribute });

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'flex flex-none h-12 px-4 text-sm items-center font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0',
			this._columnDef?.class(),
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-table-helm/files/lib/hlm-trow.component.ts.template
```
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-trow',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		role: 'row',
	},
	template: `
		<ng-content />
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class HlmTrowComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'flex flex border-b border-border transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted',
			this.userClass(),
		),
	);
}

```
