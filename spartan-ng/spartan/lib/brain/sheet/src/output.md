/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnSheetCloseDirective } from './lib/brn-sheet-close.directive';
import { BrnSheetContentDirective } from './lib/brn-sheet-content.directive';
import { BrnSheetDescriptionDirective } from './lib/brn-sheet-description.directive';
import { BrnSheetOverlayComponent } from './lib/brn-sheet-overlay.component';
import { BrnSheetTitleDirective } from './lib/brn-sheet-title.directive';
import { BrnSheetTriggerDirective } from './lib/brn-sheet-trigger.directive';
import { BrnSheetComponent } from './lib/brn-sheet.component';

export * from './lib/brn-sheet-close.directive';
export * from './lib/brn-sheet-content.directive';
export * from './lib/brn-sheet-description.directive';
export * from './lib/brn-sheet-overlay.component';
export * from './lib/brn-sheet-title.directive';
export * from './lib/brn-sheet-trigger.directive';
export * from './lib/brn-sheet.component';

export const BrnSheetImports = [
	BrnSheetComponent,
	BrnSheetOverlayComponent,
	BrnSheetTriggerDirective,
	BrnSheetCloseDirective,
	BrnSheetContentDirective,
	BrnSheetTitleDirective,
	BrnSheetDescriptionDirective,
] as const;

@NgModule({
	imports: [...BrnSheetImports],
	exports: [...BrnSheetImports],
})
export class BrnSheetModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/lib/brn-sheet-close.directive.ts
```typescript
import { Directive } from '@angular/core';
import { BrnDialogCloseDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: 'button[brnSheetClose]',
	standalone: true,
})
export class BrnSheetCloseDirective extends BrnDialogCloseDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/lib/brn-sheet-content.directive.ts
```typescript
import { Directive, inject } from '@angular/core';
import {
	type ExposesSide,
	provideExposedSideProviderExisting,
	provideExposesStateProviderExisting,
} from '@spartan-ng/brain/core';
import { BrnDialogContentDirective } from '@spartan-ng/brain/dialog';
import { BrnSheetComponent } from './brn-sheet.component';

@Directive({
	selector: '[brnSheetContent]',
	standalone: true,
	providers: [
		provideExposesStateProviderExisting(() => BrnSheetContentDirective),
		provideExposedSideProviderExisting(() => BrnSheetContentDirective),
	],
})
export class BrnSheetContentDirective<T> extends BrnDialogContentDirective<T> implements ExposesSide {
	public readonly side = inject(BrnSheetComponent).side;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/lib/brn-sheet-description.directive.ts
```typescript
import { Directive } from '@angular/core';
import { BrnDialogDescriptionDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: '[brnSheetDescription]',
	standalone: true,
	host: {
		'[id]': '_id()',
	},
})
export class BrnSheetDescriptionDirective extends BrnDialogDescriptionDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/lib/brn-sheet-overlay.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation } from '@angular/core';
import { provideCustomClassSettableExisting } from '@spartan-ng/brain/core';
import { BrnDialogOverlayComponent } from '@spartan-ng/brain/dialog';

@Component({
	selector: 'brn-sheet-overlay',
	standalone: true,
	providers: [provideCustomClassSettableExisting(() => BrnSheetOverlayComponent)],
	template: '',
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnSheetOverlayComponent extends BrnDialogOverlayComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/lib/brn-sheet-title.directive.ts
```typescript
import { Directive } from '@angular/core';
import { BrnDialogTitleDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: '[brnSheetTitle]',
	standalone: true,
	host: {
		'[id]': '_id()',
	},
})
export class BrnSheetTitleDirective extends BrnDialogTitleDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/lib/brn-sheet-trigger.directive.ts
```typescript
import { Directive, inject, input } from '@angular/core';
import { BrnDialogTriggerDirective } from '@spartan-ng/brain/dialog';
import { BrnSheetComponent } from './brn-sheet.component';

@Directive({
	selector: 'button[brnSheetTrigger]',
	standalone: true,
})
export class BrnSheetTriggerDirective extends BrnDialogTriggerDirective {
	private readonly _sheet = inject(BrnSheetComponent, { optional: true });

	public side = input<'top' | 'bottom' | 'left' | 'right' | undefined>(undefined);

	override open() {
		const side = this.side();
		if (this._sheet && side) {
			this._sheet.sideInputState().set(side);
		}
		super.open();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/lib/brn-sheet.component.ts
```typescript
import {
	ChangeDetectionStrategy,
	Component,
	computed,
	effect,
	forwardRef,
	input,
	signal,
	untracked,
	ViewEncapsulation,
} from '@angular/core';
import { BrnDialogComponent } from '@spartan-ng/brain/dialog';

@Component({
	selector: 'brn-sheet',
	standalone: true,
	template: `
		<ng-content />
	`,
	providers: [
		{
			provide: BrnDialogComponent,
			useExisting: forwardRef(() => BrnSheetComponent),
		},
	],
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	exportAs: 'brnSheet',
})
export class BrnSheetComponent extends BrnDialogComponent {
	public readonly sideInput = input<'top' | 'bottom' | 'left' | 'right'>('top', { alias: 'side' });
	public readonly sideInputState = computed(() => signal(this.sideInput()));
	public readonly side = computed(() => this.sideInputState().asReadonly()());
	constructor() {
		super();
		effect(() => {
			const side = this.side();
			untracked(() => {
				if (side === 'top') {
					this.mutablePositionStrategy().set(this.positionBuilder.global().top());
				}
				if (side === 'bottom') {
					this.mutablePositionStrategy().set(this.positionBuilder.global().bottom());
				}
				if (side === 'left') {
					this.mutablePositionStrategy().set(this.positionBuilder.global().left());
				}
				if (side === 'right') {
					this.mutablePositionStrategy().set(this.positionBuilder.global().right());
				}
			});
		});
	}
}

```
