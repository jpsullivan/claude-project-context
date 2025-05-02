/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/popover/src/lib/brn-popover-close.directive.ts
```typescript
import { Directive } from '@angular/core';
import { BrnDialogCloseDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: 'button[brnPopoverClose]',
	standalone: true,
})
export class BrnPopoverCloseDirective extends BrnDialogCloseDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/popover/src/lib/brn-popover-content.directive.ts
```typescript
import { Directive } from '@angular/core';
import { provideExposesStateProviderExisting } from '@spartan-ng/brain/core';
import { BrnDialogContentDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: '[brnPopoverContent]',
	standalone: true,
	providers: [provideExposesStateProviderExisting(() => BrnPopoverContentDirective)],
})
export class BrnPopoverContentDirective<T> extends BrnDialogContentDirective<T> {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/popover/src/lib/brn-popover-trigger.directive.ts
```typescript
import { Directive, ElementRef, effect, inject, input, untracked } from '@angular/core';
import { BrnDialogTriggerDirective } from '@spartan-ng/brain/dialog';
import type { BrnPopoverComponent } from './brn-popover.component';

@Directive({
	selector: 'button[brnPopoverTrigger],button[brnPopoverTriggerFor]',
	standalone: true,
	host: {
		'[id]': 'id()',
		'aria-haspopup': 'dialog',
		'[attr.aria-expanded]': "state() === 'open' ? 'true': 'false'",
		'[attr.data-state]': 'state()',
		'[attr.aria-controls]': 'dialogId',
	},
})
export class BrnPopoverTriggerDirective extends BrnDialogTriggerDirective {
	private readonly _host = inject(ElementRef, { host: true });

	public readonly brnPopoverTriggerFor = input<BrnPopoverComponent | undefined>(undefined, {
		alias: 'brnPopoverTriggerFor',
	});

	constructor() {
		super();
		if (!this._brnDialog) return;
		this._brnDialog.mutableAttachTo().set(this._host.nativeElement);
		this._brnDialog.mutableCloseOnOutsidePointerEvents().set(true);

		effect(() => {
			const brnDialog = this.brnPopoverTriggerFor();
			untracked(() => {
				if (!brnDialog) return;
				brnDialog.mutableAttachTo().set(this._host.nativeElement);
				brnDialog.mutableCloseOnOutsidePointerEvents().set(true);
				this.mutableBrnDialogTriggerFor().set(brnDialog);
			});
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/popover/src/lib/brn-popover.component.ts
```typescript
import {
	ChangeDetectionStrategy,
	Component,
	effect,
	forwardRef,
	input,
	numberAttribute,
	untracked,
	ViewEncapsulation,
} from '@angular/core';
import { BrnDialogComponent, BrnDialogDefaultOptions, provideBrnDialogDefaultOptions } from '@spartan-ng/brain/dialog';

export const BRN_POPOVER_DIALOG_DEFAULT_OPTIONS: Partial<BrnDialogDefaultOptions> = {
	hasBackdrop: false,
	scrollStrategy: 'reposition',
};

export type BrnPopoverAlign = 'start' | 'center' | 'end';

@Component({
	selector: 'brn-popover',
	standalone: true,
	template: `
		<ng-content />
	`,
	providers: [
		{
			provide: BrnDialogComponent,
			useExisting: forwardRef(() => BrnPopoverComponent),
		},
		provideBrnDialogDefaultOptions(BRN_POPOVER_DIALOG_DEFAULT_OPTIONS),
	],
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	exportAs: 'brnPopover',
})
export class BrnPopoverComponent extends BrnDialogComponent {
	public readonly align = input<BrnPopoverAlign>('center');
	public readonly sideOffset = input(0, { transform: numberAttribute });

	constructor() {
		super();
		this.setAriaDescribedBy('');
		this.setAriaLabelledBy('');

		effect(() => {
			const align = this.align();
			untracked(() => {
				this.mutableAttachPositions().set([
					{
						originX: align,
						originY: 'bottom',
						overlayX: align,
						overlayY: 'top',
					},
					{
						originX: align,
						originY: 'top',
						overlayX: align,
						overlayY: 'bottom',
					},
				]);
			});
			untracked(() => {
				this.applySideOffset(this.sideOffset());
			});
		});
		effect(() => {
			const sideOffset = this.sideOffset();
			untracked(() => {
				this.applySideOffset(sideOffset);
			});
		});
	}

	private applySideOffset(sideOffset: number) {
		this.mutableAttachPositions().update((positions) =>
			positions.map((position) => ({
				...position,
				offsetY: position.originY === 'top' ? -sideOffset : sideOffset,
			})),
		);
	}
}

```
