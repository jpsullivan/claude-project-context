/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/README.md
```
# @spartan-ng/brain/dialog

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/dialog`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnDialogCloseDirective } from './lib/brn-dialog-close.directive';
import { BrnDialogContentDirective } from './lib/brn-dialog-content.directive';
import { BrnDialogDescriptionDirective } from './lib/brn-dialog-description.directive';
import { BrnDialogOverlayComponent } from './lib/brn-dialog-overlay.component';
import { BrnDialogTitleDirective } from './lib/brn-dialog-title.directive';
import { BrnDialogTriggerDirective } from './lib/brn-dialog-trigger.directive';
import { BrnDialogComponent } from './lib/brn-dialog.component';

export * from './lib/brn-dialog-close.directive';
export * from './lib/brn-dialog-content.directive';
export * from './lib/brn-dialog-description.directive';
export * from './lib/brn-dialog-options';
export * from './lib/brn-dialog-overlay.component';
export * from './lib/brn-dialog-ref';
export * from './lib/brn-dialog-state';
export * from './lib/brn-dialog-title.directive';
export * from './lib/brn-dialog-token';
export * from './lib/brn-dialog-trigger.directive';
export * from './lib/brn-dialog-utils';
export * from './lib/brn-dialog.component';
export * from './lib/brn-dialog.service';

export const BrnDialogImports = [
	BrnDialogComponent,
	BrnDialogOverlayComponent,
	BrnDialogTriggerDirective,
	BrnDialogCloseDirective,
	BrnDialogContentDirective,
	BrnDialogTitleDirective,
	BrnDialogDescriptionDirective,
] as const;

@NgModule({
	imports: [...BrnDialogImports],
	exports: [...BrnDialogImports],
})
export class BrnDialogModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-close.directive.ts
```typescript
import { coerceNumberProperty } from '@angular/cdk/coercion';
import { Directive, inject, input } from '@angular/core';
import { BrnDialogRef } from './brn-dialog-ref';

@Directive({
	selector: 'button[brnDialogClose]',
	standalone: true,
	host: {
		'(click)': 'close()',
	},
})
export class BrnDialogCloseDirective {
	private readonly _brnDialogRef = inject(BrnDialogRef);

	public readonly delay = input<number | undefined, number>(undefined, { transform: coerceNumberProperty });

	public close() {
		this._brnDialogRef.close(undefined, this.delay());
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-content.directive.ts
```typescript
import { computed, Directive, effect, inject, input, TemplateRef, untracked } from '@angular/core';
import { provideExposesStateProviderExisting } from '@spartan-ng/brain/core';
import { BrnDialogRef } from './brn-dialog-ref';
import { BrnDialogComponent } from './brn-dialog.component';

@Directive({
	selector: '[brnDialogContent]',
	standalone: true,
	providers: [provideExposesStateProviderExisting(() => BrnDialogContentDirective)],
})
export class BrnDialogContentDirective<T> {
	private readonly _brnDialog = inject(BrnDialogComponent, { optional: true });
	private readonly _brnDialogRef = inject(BrnDialogRef, { optional: true });
	private readonly _template = inject(TemplateRef);
	public readonly state = computed(() => this._brnDialog?.stateComputed() ?? this._brnDialogRef?.state() ?? 'closed');

	public readonly className = input<string | null | undefined>(undefined, { alias: 'class' });

	public readonly context = input<T | undefined>(undefined);

	constructor() {
		if (!this._brnDialog) return;
		this._brnDialog.registerTemplate(this._template);
		effect(() => {
			const context = this.context();
			if (!this._brnDialog || !context) return;
			untracked(() => this._brnDialog?.setContext(context));
		});
		effect(() => {
			if (!this._brnDialog) return;
			const newClass = this.className();
			untracked(() => this._brnDialog?.setPanelClass(newClass));
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-description.directive.ts
```typescript
import { Directive, effect, inject, signal } from '@angular/core';
import { BrnDialogRef } from './brn-dialog-ref';

@Directive({
	selector: '[brnDialogDescription]',
	standalone: true,
	host: {
		'[id]': '_id()',
	},
})
export class BrnDialogDescriptionDirective {
	private readonly _brnDialogRef = inject(BrnDialogRef);

	protected _id = signal(`brn-dialog-description-${this._brnDialogRef?.dialogId}`);

	constructor() {
		effect(() => {
			this._brnDialogRef.setAriaDescribedBy(this._id());
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-options.ts
```typescript
import type { AutoFocusTarget } from '@angular/cdk/dialog';
import type {
	ConnectedPosition,
	FlexibleConnectedPositionStrategyOrigin,
	PositionStrategy,
	ScrollStrategy,
} from '@angular/cdk/overlay';
import type { ElementRef, StaticProvider } from '@angular/core';

export type BrnDialogOptions = {
	id: string;
	role: 'dialog' | 'alertdialog';
	hasBackdrop: boolean;
	panelClass: string | string[];
	backdropClass: string | string[];
	positionStrategy: PositionStrategy | null | undefined;
	scrollStrategy: ScrollStrategy | null | undefined;
	restoreFocus: boolean | string | ElementRef;
	closeDelay: number;
	closeOnOutsidePointerEvents: boolean;
	closeOnBackdropClick: boolean;
	attachTo: FlexibleConnectedPositionStrategyOrigin | null | undefined;
	attachPositions: ConnectedPosition[];
	autoFocus: AutoFocusTarget | (Record<never, never> & string);
	disableClose: boolean;
	ariaDescribedBy: string | null | undefined;
	ariaLabelledBy: string | null | undefined;
	ariaLabel: string | null | undefined;
	ariaModal: boolean;
	providers?: StaticProvider[] | (() => StaticProvider[]);
};

export const DEFAULT_BRN_DIALOG_OPTIONS: Readonly<Partial<BrnDialogOptions>> = {
	role: 'dialog',
	attachPositions: [],
	attachTo: null,
	autoFocus: 'first-tabbable',
	backdropClass: '',
	closeDelay: 100,
	closeOnBackdropClick: true,
	closeOnOutsidePointerEvents: false,
	hasBackdrop: true,
	panelClass: '',
	positionStrategy: null,
	restoreFocus: true,
	scrollStrategy: null,
	disableClose: false,
	ariaLabel: undefined,
	ariaModal: true,
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-overlay.component.ts
```typescript
import { ChangeDetectionStrategy, Component, effect, inject, input, untracked, ViewEncapsulation } from '@angular/core';
import { provideCustomClassSettableExisting } from '@spartan-ng/brain/core';
import { BrnDialogComponent } from './brn-dialog.component';

@Component({
	selector: 'brn-dialog-overlay',
	standalone: true,
	template: '',
	providers: [provideCustomClassSettableExisting(() => BrnDialogOverlayComponent)],
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnDialogOverlayComponent {
	private readonly _brnDialog = inject(BrnDialogComponent);

	public readonly className = input<string | null | undefined>(undefined, { alias: 'class' });

	setClassToCustomElement(newClass: string) {
		this._brnDialog.setOverlayClass(newClass);
	}
	constructor() {
		effect(() => {
			if (!this._brnDialog) return;
			const newClass = this.className();
			untracked(() => this._brnDialog.setOverlayClass(newClass));
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-ref.ts
```typescript
import type { DialogRef } from '@angular/cdk/dialog';
import type { Signal, WritableSignal } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { take } from 'rxjs/operators';
import type { BrnDialogOptions } from './brn-dialog-options';
import type { BrnDialogState } from './brn-dialog-state';
import { cssClassesToArray } from './brn-dialog-utils';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export class BrnDialogRef<DialogResult = any> {
	private readonly _closing$ = new Subject<void>();
	public readonly closing$ = this._closing$.asObservable();

	public readonly closed$: Observable<DialogResult | undefined>;

	private _previousTimeout: ReturnType<typeof setTimeout> | undefined;

	public get open() {
		return this.state() === 'open';
	}

	constructor(
		private readonly _cdkDialogRef: DialogRef<DialogResult>,
		private readonly _open: WritableSignal<boolean>,
		public readonly state: Signal<BrnDialogState>,
		public readonly dialogId: number,
		private readonly _options?: BrnDialogOptions,
	) {
		this.closed$ = this._cdkDialogRef.closed.pipe(take(1));
	}

	public close(result?: DialogResult, delay: number = this._options?.closeDelay ?? 0) {
		if (!this.open || this._options?.disableClose) return;

		this._closing$.next();
		this._open.set(false);

		if (this._previousTimeout) {
			clearTimeout(this._previousTimeout);
		}

		this._previousTimeout = setTimeout(() => {
			this._cdkDialogRef.close(result);
		}, delay);
	}

	public setPanelClass(paneClass: string | null | undefined) {
		this._cdkDialogRef.config.panelClass = cssClassesToArray(paneClass);
	}

	public setOverlayClass(overlayClass: string | null | undefined) {
		this._cdkDialogRef.config.backdropClass = cssClassesToArray(overlayClass);
	}

	public setAriaDescribedBy(ariaDescribedBy: string | null | undefined) {
		this._cdkDialogRef.config.ariaDescribedBy = ariaDescribedBy;
	}

	public setAriaLabelledBy(ariaLabelledBy: string | null | undefined) {
		this._cdkDialogRef.config.ariaLabelledBy = ariaLabelledBy;
	}

	public setAriaLabel(ariaLabel: string | null | undefined) {
		this._cdkDialogRef.config.ariaLabel = ariaLabel;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-state.ts
```typescript
export type BrnDialogState = 'closed' | 'open';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-title.directive.ts
```typescript
import { Directive, effect, inject, signal } from '@angular/core';
import { BrnDialogRef } from './brn-dialog-ref';

@Directive({
	selector: '[brnDialogTitle]',
	standalone: true,
	host: {
		'[id]': '_id()',
	},
})
export class BrnDialogTitleDirective {
	private readonly _brnDialogRef = inject(BrnDialogRef);

	protected _id = signal(`brn-dialog-title-${this._brnDialogRef?.dialogId}`);

	constructor() {
		effect(() => {
			this._brnDialogRef.setAriaLabelledBy(this._id());
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-token.ts
```typescript
import { inject, InjectionToken, ValueProvider } from '@angular/core';
import { BrnDialogOptions } from './brn-dialog-options';

export interface BrnDialogDefaultOptions {
	/** A connected position as specified by the user. */
	attachPositions: BrnDialogOptions['attachPositions'];

	/** Options for where to set focus to automatically on dialog open */
	autoFocus: BrnDialogOptions['autoFocus'];

	/** The delay in milliseconds before the dialog closes. */
	closeDelay: number;

	/** Close dialog on backdrop click */
	closeOnBackdropClick: boolean;

	/** Close dialog on outside pointer event */
	closeOnOutsidePointerEvents: boolean;

	/** Whether the dialog closes with the escape key or pointer events outside the panel element. */
	disableClose: boolean;

	/** Whether the dialog has a backdrop. */
	hasBackdrop: boolean;

	/** Strategy to use when positioning the dialog */
	positionStrategy: BrnDialogOptions['positionStrategy'];

	/** Whether the dialog should restore focus to the previously-focused element upon closing. */
	restoreFocus: BrnDialogOptions['restoreFocus'];

	/** The role of the dialog */
	role: BrnDialogOptions['role'];

	/** Scroll strategy to be used for the dialog. */
	scrollStrategy: BrnDialogOptions['scrollStrategy'] | 'close' | 'reposition';
}

export const defaultOptions: BrnDialogDefaultOptions = {
	attachPositions: [],
	autoFocus: 'first-tabbable',
	closeDelay: 100,
	closeOnBackdropClick: true,
	closeOnOutsidePointerEvents: false,
	disableClose: false,
	hasBackdrop: true,
	positionStrategy: null,
	restoreFocus: true,
	role: 'dialog',
	scrollStrategy: null,
};

const BRN_DIALOG_DEFAULT_OPTIONS = new InjectionToken<BrnDialogDefaultOptions>('brn-dialog-default-options', {
	providedIn: 'root',
	factory: () => defaultOptions,
});

export function provideBrnDialogDefaultOptions(options: Partial<BrnDialogDefaultOptions>): ValueProvider {
	return { provide: BRN_DIALOG_DEFAULT_OPTIONS, useValue: { ...defaultOptions, ...options } };
}

export function injectBrnDialogDefaultOptions(): BrnDialogDefaultOptions {
	return inject(BRN_DIALOG_DEFAULT_OPTIONS, { optional: true }) ?? defaultOptions;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-trigger.directive.ts
```typescript
import { computed, Directive, effect, inject, input, type Signal, signal } from '@angular/core';
import { BrnDialogRef } from './brn-dialog-ref';
import type { BrnDialogState } from './brn-dialog-state';
import { BrnDialogComponent } from './brn-dialog.component';

let idSequence = 0;

@Directive({
	selector: 'button[brnDialogTrigger],button[brnDialogTriggerFor]',
	standalone: true,
	host: {
		'[id]': 'id()',
		'(click)': 'open()',
		'aria-haspopup': 'dialog',
		'[attr.aria-expanded]': "state() === 'open' ? 'true': 'false'",
		'[attr.data-state]': 'state()',
		'[attr.aria-controls]': 'dialogId',
	},
	exportAs: 'brnDialogTrigger',
})
export class BrnDialogTriggerDirective {
	protected _brnDialog = inject(BrnDialogComponent, { optional: true });
	protected readonly _brnDialogRef = inject(BrnDialogRef, { optional: true });

	public readonly id = input(`brn-dialog-trigger-${idSequence++}`);

	public readonly state: Signal<BrnDialogState> = this._brnDialogRef?.state ?? signal('closed');
	public readonly dialogId = `brn-dialog-${this._brnDialogRef?.dialogId ?? idSequence++}`;

	public readonly brnDialogTriggerFor = input<BrnDialogComponent | undefined>(undefined, {
		alias: 'brnDialogTriggerFor',
	});
	public readonly mutableBrnDialogTriggerFor = computed(() => signal(this.brnDialogTriggerFor()));
	public readonly brnDialogTriggerForState = computed(() => this.mutableBrnDialogTriggerFor()());

	constructor() {
		effect(() => {
			const brnDialog = this.brnDialogTriggerForState();
			if (!brnDialog) return;
			this._brnDialog = brnDialog;
		});
	}

	open() {
		this._brnDialog?.open();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-utils.ts
```typescript
// brn-dialog-utils.ts

export const cssClassesToArray = (classes: string | string[] | undefined | null, defaultClass = ''): string[] => {
	if (typeof classes === 'string') {
		const splitClasses = classes.trim().split(' ');
		if (splitClasses.length === 0) {
			return [defaultClass];
		}
		return splitClasses;
	}
	return classes ?? [];
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog.component.ts
```typescript
import { OverlayPositionBuilder, ScrollStrategy, ScrollStrategyOptions } from '@angular/cdk/overlay';
import {
	booleanAttribute,
	ChangeDetectionStrategy,
	Component,
	computed,
	effect,
	type EffectRef,
	inject,
	Injector,
	input,
	numberAttribute,
	output,
	runInInjectionContext,
	signal,
	type TemplateRef,
	untracked,
	ViewContainerRef,
	ViewEncapsulation,
} from '@angular/core';
import { take } from 'rxjs/operators';
import { type BrnDialogOptions } from './brn-dialog-options';
import type { BrnDialogRef } from './brn-dialog-ref';
import type { BrnDialogState } from './brn-dialog-state';
import { injectBrnDialogDefaultOptions } from './brn-dialog-token';
import { BrnDialogService } from './brn-dialog.service';

@Component({
	selector: 'brn-dialog',
	standalone: true,
	template: `
		<ng-content />
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	exportAs: 'brnDialog',
})
export class BrnDialogComponent {
	private readonly _dialogService = inject(BrnDialogService);
	private readonly _vcr = inject(ViewContainerRef);
	public readonly positionBuilder = inject(OverlayPositionBuilder);
	public readonly ssos = inject(ScrollStrategyOptions);
	private readonly _injector = inject(Injector);

	protected readonly _defaultOptions = injectBrnDialogDefaultOptions();

	private _context = {};
	public readonly stateComputed = computed(() => this._dialogRef()?.state() ?? 'closed');

	private _contentTemplate: TemplateRef<unknown> | undefined;
	private readonly _dialogRef = signal<BrnDialogRef | undefined>(undefined);
	private _dialogStateEffectRef?: EffectRef;
	private readonly _backdropClass = signal<string | null | undefined>(null);
	private readonly _panelClass = signal<string | null | undefined>(null);

	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	public readonly closed = output<any>();

	public readonly stateChanged = output<BrnDialogState>();

	public readonly state = input<BrnDialogState | null>(null);

	public readonly role = input<BrnDialogOptions['role']>(this._defaultOptions.role);

	public readonly hasBackdrop = input(this._defaultOptions.hasBackdrop, { transform: booleanAttribute });

	public readonly positionStrategy = input<BrnDialogOptions['positionStrategy']>(this._defaultOptions.positionStrategy);
	public readonly mutablePositionStrategy = computed(() => signal(this.positionStrategy()));
	private readonly _positionStrategyState = computed(() => this.mutablePositionStrategy()());

	public readonly scrollStrategy = input<BrnDialogOptions['scrollStrategy'] | 'close' | 'reposition' | null>(
		this._defaultOptions.scrollStrategy,
	);

	protected _options = computed<Partial<BrnDialogOptions>>(() => {
		const scrollStrategyInput = this.scrollStrategy();
		let scrollStrategy: ScrollStrategy | null | undefined;

		if (scrollStrategyInput === 'close') {
			scrollStrategy = this.ssos.close();
		} else if (scrollStrategyInput === 'reposition') {
			scrollStrategy = this.ssos.reposition();
		} else {
			scrollStrategy = scrollStrategyInput;
		}

		return {
			role: this.role(),
			hasBackdrop: this.hasBackdrop(),
			positionStrategy: this._positionStrategyState(),
			scrollStrategy,
			restoreFocus: this.restoreFocus(),
			closeOnOutsidePointerEvents: this._closeOnOutsidePointerEventsState(),
			closeOnBackdropClick: this.closeOnBackdropClick(),
			attachTo: this._attachToState(),
			attachPositions: this._attachPositionsState(),
			autoFocus: this.autoFocus(),
			closeDelay: this.closeDelay(),
			disableClose: this.disableClose(),
			backdropClass: this._backdropClass() ?? '',
			panelClass: this._panelClass() ?? '',
			ariaDescribedBy: this._ariaDescribedByState(),
			ariaLabelledBy: this._ariaLabelledByState(),
			ariaLabel: this._ariaLabelState(),
			ariaModal: this._ariaModalState(),
		};
	});

	constructor() {
		effect(() => {
			const state = this.state();
			if (state === 'open') {
				untracked(() => this.open());
			}
			if (state === 'closed') {
				untracked(() => this.close());
			}
		});
	}

	public readonly restoreFocus = input<BrnDialogOptions['restoreFocus']>(this._defaultOptions.restoreFocus);

	public readonly closeOnOutsidePointerEvents = input(this._defaultOptions.closeOnOutsidePointerEvents, {
		transform: booleanAttribute,
	});
	public readonly mutableCloseOnOutsidePointerEvents = computed(() => signal(this.closeOnOutsidePointerEvents()));
	private readonly _closeOnOutsidePointerEventsState = computed(() => this.mutableCloseOnOutsidePointerEvents()());

	public readonly closeOnBackdropClick = input(this._defaultOptions.closeOnBackdropClick, {
		transform: booleanAttribute,
	});

	public readonly attachTo = input<BrnDialogOptions['attachTo']>(null);
	public readonly mutableAttachTo = computed(() => signal(this.attachTo()));
	private readonly _attachToState = computed(() => this.mutableAttachTo()());

	public readonly attachPositions = input<BrnDialogOptions['attachPositions']>(this._defaultOptions.attachPositions);
	public readonly mutableAttachPositions = computed(() => signal(this.attachPositions()));
	private readonly _attachPositionsState = computed(() => this.mutableAttachPositions()());

	public readonly autoFocus = input<BrnDialogOptions['autoFocus']>(this._defaultOptions.autoFocus);

	public readonly closeDelay = input(this._defaultOptions.closeDelay, {
		transform: numberAttribute,
	});

	public readonly disableClose = input(this._defaultOptions.disableClose, { transform: booleanAttribute });

	public readonly ariaDescribedBy = input<BrnDialogOptions['ariaDescribedBy']>(null, {
		alias: 'aria-describedby',
	});
	private readonly _mutableAriaDescribedBy = computed(() => signal(this.ariaDescribedBy()));
	private readonly _ariaDescribedByState = computed(() => this._mutableAriaDescribedBy()());

	public readonly ariaLabelledBy = input<BrnDialogOptions['ariaLabelledBy']>(null, { alias: 'aria-labelledby' });
	private readonly _mutableAriaLabelledBy = computed(() => signal(this.ariaLabelledBy()));
	private readonly _ariaLabelledByState = computed(() => this._mutableAriaLabelledBy()());

	public readonly ariaLabel = input<BrnDialogOptions['ariaLabel']>(null, { alias: 'aria-label' });
	private readonly _mutableAriaLabel = computed(() => signal(this.ariaLabel()));
	private readonly _ariaLabelState = computed(() => this._mutableAriaLabel()());

	public readonly ariaModal = input(true, { alias: 'aria-modal', transform: booleanAttribute });
	private readonly _mutableAriaModal = computed(() => signal(this.ariaModal()));
	private readonly _ariaModalState = computed(() => this._mutableAriaModal()());

	public open<DialogContext>() {
		if (!this._contentTemplate || this._dialogRef()) return;

		this._dialogStateEffectRef?.destroy();

		const dialogRef = this._dialogService.open<DialogContext>(
			this._contentTemplate,
			this._vcr,
			this._context as DialogContext,
			this._options(),
		);

		this._dialogRef.set(dialogRef);

		runInInjectionContext(this._injector, () => {
			this._dialogStateEffectRef = effect(() => {
				const state = dialogRef.state();
				untracked(() => this.stateChanged.emit(state));
			});
		});

		dialogRef.closed$.pipe(take(1)).subscribe((result) => {
			this._dialogRef.set(undefined);
			this.closed.emit(result);
		});
	}

	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	public close(result?: any, delay?: number) {
		this._dialogRef()?.close(result, delay ?? this._options().closeDelay);
	}

	public registerTemplate(template: TemplateRef<unknown>) {
		this._contentTemplate = template;
	}

	public setOverlayClass(overlayClass: string | null | undefined) {
		this._backdropClass.set(overlayClass);
		this._dialogRef()?.setOverlayClass(overlayClass);
	}

	public setPanelClass(panelClass: string | null | undefined) {
		this._panelClass.set(panelClass ?? '');
		this._dialogRef()?.setPanelClass(panelClass);
	}

	public setContext(context: unknown) {
		// eslint-disable-next-line @typescript-eslint/ban-ts-comment
		// @ts-expect-error
		this._context = { ...this._context, ...context };
	}

	public setAriaDescribedBy(ariaDescribedBy: string | null | undefined) {
		this._mutableAriaDescribedBy().set(ariaDescribedBy);
		this._dialogRef()?.setAriaDescribedBy(ariaDescribedBy);
	}

	public setAriaLabelledBy(ariaLabelledBy: string | null | undefined) {
		this._mutableAriaLabelledBy().set(ariaLabelledBy);
		this._dialogRef()?.setAriaLabelledBy(ariaLabelledBy);
	}

	public setAriaLabel(ariaLabel: string | null | undefined) {
		this._mutableAriaLabel().set(ariaLabel);
		this._dialogRef()?.setAriaLabel(ariaLabel);
	}

	public setAriaModal(ariaModal: boolean) {
		this._mutableAriaModal().set(ariaModal);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog.service.ts
```typescript
import { DIALOG_DATA, Dialog } from '@angular/cdk/dialog';
import { type ComponentType, OverlayPositionBuilder, ScrollStrategyOptions } from '@angular/cdk/overlay';
import {
	type EffectRef,
	type InjectOptions,
	Injectable,
	Injector,
	RendererFactory2,
	type StaticProvider,
	type TemplateRef,
	type ViewContainerRef,
	computed,
	effect,
	inject,
	runInInjectionContext,
	signal,
} from '@angular/core';
import { Subject } from 'rxjs';
import { filter, takeUntil } from 'rxjs/operators';
import type { BrnDialogOptions } from './brn-dialog-options';
import { BrnDialogRef } from './brn-dialog-ref';
import type { BrnDialogState } from './brn-dialog-state';
import { cssClassesToArray } from './brn-dialog-utils';

let dialogSequence = 0;

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type BrnDialogContext<T> = T & { close: (result?: any) => void };

/** @deprecated `injectBrnDialogCtx` will no longer be supported once components are stable. Use `injectBrnDialogContext` instead.  */
export const injectBrnDialogCtx = <T>(): BrnDialogContext<T> => {
	return inject(DIALOG_DATA);
};

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const injectBrnDialogContext = <DialogContext = any>(options: InjectOptions = {}) => {
	return inject(DIALOG_DATA, options) as DialogContext;
};

@Injectable({ providedIn: 'root' })
export class BrnDialogService {
	private readonly _cdkDialog = inject(Dialog);
	private readonly _rendererFactory = inject(RendererFactory2);
	private readonly _renderer = this._rendererFactory.createRenderer(null, null);
	private readonly _positionBuilder = inject(OverlayPositionBuilder);
	private readonly _sso = inject(ScrollStrategyOptions);
	private readonly _injector = inject(Injector);

	public open<DialogContext>(
		content: ComponentType<unknown> | TemplateRef<unknown>,
		vcr?: ViewContainerRef,
		context?: DialogContext,
		options?: Partial<BrnDialogOptions>,
	) {
		if (options?.id && this._cdkDialog.getDialogById(options.id)) {
			throw new Error(`Dialog with ID: ${options.id} already exists`);
		}

		const positionStrategy =
			options?.positionStrategy ??
			(options?.attachTo && options?.attachPositions && options?.attachPositions?.length > 0
				? this._positionBuilder?.flexibleConnectedTo(options.attachTo).withPositions(options.attachPositions ?? [])
				: this._positionBuilder.global().centerHorizontally().centerVertically());

		let brnDialogRef!: BrnDialogRef;
		let effectRef!: EffectRef;

		// eslint-disable-next-line @typescript-eslint/no-explicit-any
		const contextOrData: BrnDialogContext<any> = {
			...context,
			// eslint-disable-next-line @typescript-eslint/no-explicit-any
			close: (result: any = undefined) => brnDialogRef.close(result, options?.closeDelay),
		};

		const destroyed$ = new Subject<void>();
		const open = signal<boolean>(true);
		const state = computed<BrnDialogState>(() => (open() ? 'open' : 'closed'));
		const dialogId = dialogSequence++;

		// eslint-disable-next-line @typescript-eslint/ban-ts-comment
		// @ts-ignore
		const cdkDialogRef = this._cdkDialog.open(content, {
			id: options?.id ?? `brn-dialog-${dialogId}`,
			role: options?.role,
			viewContainerRef: vcr,
			templateContext: () => ({
				$implicit: contextOrData,
			}),
			data: contextOrData,
			hasBackdrop: options?.hasBackdrop,
			panelClass: cssClassesToArray(options?.panelClass),
			backdropClass: cssClassesToArray(options?.backdropClass, 'bg-transparent'),
			positionStrategy,
			scrollStrategy: options?.scrollStrategy ?? this._sso?.block(),
			restoreFocus: options?.restoreFocus,
			disableClose: true,
			autoFocus: options?.autoFocus ?? 'first-tabbable',
			ariaDescribedBy: options?.ariaDescribedBy ?? `brn-dialog-description-${dialogId}`,
			ariaLabelledBy: options?.ariaLabelledBy ?? `brn-dialog-title-${dialogId}`,
			ariaLabel: options?.ariaLabel,
			ariaModal: options?.ariaModal,
			providers: (cdkDialogRef) => {
				brnDialogRef = new BrnDialogRef(cdkDialogRef, open, state, dialogId, options as BrnDialogOptions);

				runInInjectionContext(this._injector, () => {
					effectRef = effect(() => {
						if (overlay) {
							this._renderer.setAttribute(overlay, 'data-state', state());
						}
						if (backdrop) {
							this._renderer.setAttribute(backdrop, 'data-state', state());
						}
					});
				});

				const providers: StaticProvider[] = [
					{
						provide: BrnDialogRef,
						useValue: brnDialogRef,
					},
				];

				if (options?.providers) {
					if (typeof options.providers === 'function') {
						providers.push(...options.providers());
					}

					if (Array.isArray(options.providers)) {
						providers.push(...options.providers);
					}
				}

				return providers;
			},
		});

		const overlay = cdkDialogRef.overlayRef.overlayElement;
		const backdrop = cdkDialogRef.overlayRef.backdropElement;

		if (options?.closeOnOutsidePointerEvents) {
			cdkDialogRef.outsidePointerEvents.pipe(takeUntil(destroyed$)).subscribe(() => {
				brnDialogRef.close(undefined, options?.closeDelay);
			});
		}

		if (options?.closeOnBackdropClick) {
			cdkDialogRef.backdropClick.pipe(takeUntil(destroyed$)).subscribe(() => {
				brnDialogRef.close(undefined, options?.closeDelay);
			});
		}

		if (!options?.disableClose) {
			cdkDialogRef.keydownEvents
				.pipe(
					filter((e) => e.key === 'Escape'),
					takeUntil(destroyed$),
				)
				.subscribe(() => {
					brnDialogRef.close(undefined, options?.closeDelay);
				});
		}

		cdkDialogRef.closed.pipe(takeUntil(destroyed$)).subscribe(() => {
			effectRef?.destroy();
			destroyed$.next();
		});

		return brnDialogRef;
	}
}

```
