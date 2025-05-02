/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/src/lib/brn-alert-dialog-content.directive.ts
```typescript
import { Directive } from '@angular/core';
import { provideExposesStateProviderExisting } from '@spartan-ng/brain/core';
import { BrnDialogContentDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: '[brnAlertDialogContent]',
	standalone: true,
	providers: [provideExposesStateProviderExisting(() => BrnAlertDialogContentDirective)],
})
export class BrnAlertDialogContentDirective<T> extends BrnDialogContentDirective<T> {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/src/lib/brn-alert-dialog-description.directive.ts
```typescript
import { Directive } from '@angular/core';
import { BrnDialogDescriptionDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: '[brnAlertDialogDescription]',
	standalone: true,
	host: {
		'[id]': '_id()',
	},
})
export class BrnAlertDialogDescriptionDirective extends BrnDialogDescriptionDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/src/lib/brn-alert-dialog-overlay.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation } from '@angular/core';
import { provideCustomClassSettableExisting } from '@spartan-ng/brain/core';
import { BrnDialogOverlayComponent } from '@spartan-ng/brain/dialog';

@Component({
	selector: 'brn-alert-dialog-overlay',
	standalone: true,
	providers: [provideCustomClassSettableExisting(() => BrnAlertDialogOverlayComponent)],
	template: '',
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnAlertDialogOverlayComponent extends BrnDialogOverlayComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/src/lib/brn-alert-dialog-title.directive.ts
```typescript
import { Directive } from '@angular/core';
import { BrnDialogTitleDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: '[brnAlertDialogTitle]',
	standalone: true,
	host: {
		'[id]': '_id()',
	},
})
export class BrnAlertDialogTitleDirective extends BrnDialogTitleDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/src/lib/brn-alert-dialog-trigger.directive.ts
```typescript
import { Directive, effect, input, untracked } from '@angular/core';
import { BrnDialogTriggerDirective } from '@spartan-ng/brain/dialog';
import type { BrnAlertDialogComponent } from './brn-alert-dialog.component';

@Directive({
	selector: 'button[brnAlertDialogTrigger],button[brnAlertDialogTriggerFor]',
	standalone: true,
	host: {
		'[id]': 'id()',
		'aria-haspopup': 'dialog',
		'[attr.aria-expanded]': "state() === 'open' ? 'true': 'false'",
		'[attr.data-state]': 'state()',
		'[attr.aria-controls]': 'dialogId',
	},
})
export class BrnAlertDialogTriggerDirective extends BrnDialogTriggerDirective {
	public readonly brnAlertDialogTriggerFor = input<BrnAlertDialogComponent | undefined>();

	constructor() {
		super();
		effect(() => {
			const brnDialog = this.brnAlertDialogTriggerFor();
			untracked(() => {
				if (brnDialog) {
					this.mutableBrnDialogTriggerFor().set(brnDialog);
				}
			});
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/src/lib/brn-alert-dialog.component.ts
```typescript
import { ChangeDetectionStrategy, Component, forwardRef, ViewEncapsulation } from '@angular/core';
import { BrnDialogComponent, BrnDialogDefaultOptions, provideBrnDialogDefaultOptions } from '@spartan-ng/brain/dialog';

export const BRN_ALERT_DIALOG_DEFAULT_OPTIONS: Partial<BrnDialogDefaultOptions> = {
	closeOnBackdropClick: false,
	closeOnOutsidePointerEvents: false,
	role: 'alertdialog',
};

@Component({
	selector: 'brn-alert-dialog',
	standalone: true,
	template: `
		<ng-content />
	`,
	providers: [
		{
			provide: BrnDialogComponent,
			useExisting: forwardRef(() => BrnAlertDialogComponent),
		},
		provideBrnDialogDefaultOptions(BRN_ALERT_DIALOG_DEFAULT_OPTIONS),
	],
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	exportAs: 'brnAlertDialog',
})
export class BrnAlertDialogComponent extends BrnDialogComponent {}

```
