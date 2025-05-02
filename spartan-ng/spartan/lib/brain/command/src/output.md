/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { BrnCommandEmptyDirective } from './lib/brn-command-empty.directive';
import { BrnCommandGroupDirective } from './lib/brn-command-group.directive';
import { BrnCommandItemDirective } from './lib/brn-command-item.directive';
import { BrnCommandListDirective } from './lib/brn-command-list.directive';
import { BrnCommandSearchInputDirective } from './lib/brn-command-search-input.directive';
import { BrnCommandDirective } from './lib/brn-command.directive';

export * from './lib/brn-command-empty.directive';
export * from './lib/brn-command-group.directive';
export * from './lib/brn-command-item.directive';
export * from './lib/brn-command-item.token';
export * from './lib/brn-command-list.directive';
export * from './lib/brn-command-search-input.directive';
export * from './lib/brn-command-search-input.token';
export * from './lib/brn-command.directive';
export * from './lib/brn-command.token';

export const BrnCommandImports = [
	BrnCommandEmptyDirective,
	BrnCommandGroupDirective,
	BrnCommandItemDirective,
	BrnCommandListDirective,
	BrnCommandSearchInputDirective,
	BrnCommandDirective,
] as const;

@NgModule({
	imports: [...BrnCommandImports],
	exports: [...BrnCommandImports],
})
export class BrnCommandModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command-empty.directive.ts
```typescript
import { computed, Directive, effect, inject, TemplateRef, ViewContainerRef } from '@angular/core';
import { injectBrnCommand } from './brn-command.token';

@Directive({
	standalone: true,
	selector: '[brnCommandEmpty]',
})
export class BrnCommandEmptyDirective {
	private readonly _templateRef = inject<TemplateRef<void>>(TemplateRef);
	private readonly _viewContainerRef = inject(ViewContainerRef);
	private readonly _command = injectBrnCommand();

	/** Determine if the command has any visible items */
	private readonly _visible = computed(() => this._command.items().some((item) => item.visible()));

	constructor() {
		effect(() => {
			if (this._visible()) {
				this._viewContainerRef.clear();
			} else {
				this._viewContainerRef.createEmbeddedView(this._templateRef);
			}
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command-group.directive.ts
```typescript
import { computed, contentChildren, Directive, input } from '@angular/core';
import { BrnCommandItemToken } from './brn-command-item.token';

@Directive({
	selector: '[brnCommandGroup]',
	standalone: true,
	host: {
		role: 'group',
		'[attr.data-hidden]': '!visible() ? "" : null',
		'[id]': 'id()',
	},
})
export class BrnCommandGroupDirective {
	private static _id = 0;

	/** The id of the command list */
	public readonly id = input<string>(`brn-command-group-${BrnCommandGroupDirective._id++}`);

	/** Get the items in the group */
	private readonly _items = contentChildren(BrnCommandItemToken, {
		descendants: true,
	});

	/** Determine if there are any visible items in the group */
	protected readonly visible = computed(() => this._items().some((item) => item.visible()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command-item.directive.ts
```typescript
import { Highlightable } from '@angular/cdk/a11y';
import { BooleanInput } from '@angular/cdk/coercion';
import { isPlatformBrowser } from '@angular/common';
import {
	booleanAttribute,
	computed,
	Directive,
	ElementRef,
	HostListener,
	inject,
	input,
	OnInit,
	output,
	PLATFORM_ID,
	signal,
} from '@angular/core';
import { provideBrnCommandItem } from './brn-command-item.token';
import { injectBrnCommand } from './brn-command.token';

@Directive({
	selector: 'button[brnCommandItem]',
	standalone: true,
	providers: [provideBrnCommandItem(BrnCommandItemDirective)],
	host: {
		type: 'button',
		role: 'option',
		tabIndex: '-1',
		'[id]': 'id()',
		'[attr.disabled]': '_disabled() ? true : null',
		'[attr.data-value]': 'value()',
		'[attr.data-hidden]': "!visible() ? '' : null",
		'[attr.aria-selected]': 'active()',
		'[attr.data-selected]': "active() ? '' : null",
	},
})
export class BrnCommandItemDirective implements Highlightable, OnInit {
	private static _id = 0;

	private readonly _platform = inject(PLATFORM_ID);

	private readonly _elementRef = inject<ElementRef<HTMLElement>>(ElementRef);

	/** Access the command component */
	private readonly _command = injectBrnCommand();

	/** A unique id for the item */
	public readonly id = input(`brn-command-item-${BrnCommandItemDirective._id++}`);

	/** The value this item represents. */
	public readonly value = input.required<string>();

	/** Whether the item is disabled. */
	public readonly _disabled = input<boolean, BooleanInput>(false, {
		alias: 'disabled',
		transform: booleanAttribute,
	});

	/** Expose disabled as a value - used by the Highlightable interface */
	public get disabled() {
		return this._disabled();
	}

	/** Whether the item is initialized, this is to prevent accessing the value-input before the component is initialized.
	 * The brn-command-empty directive accesses the value before the component is initialized, which causes an error.
	 */
	private readonly _initialized = signal(false);

	/** Whether the item is selected. */
	protected readonly active = signal(false);

	/** Emits when the item is selected. */
	public readonly selected = output<void>();

	/** @internal Determine if this item is visible based on the current search query */
	public readonly visible = computed(() => {
		return this._command.filter()(this.safeValue(), this._command.search());
	});

	/** @internal Get the value of the item, with check if it has been initialized to avoid errors */
	public safeValue = computed(() => {
		if (!this._initialized()) {
			return '';
		}
		return this.value();
	});

	/** @internal Get the display value */
	public getLabel(): string {
		return this.safeValue();
	}

	/** @internal */
	setActiveStyles(): void {
		this.active.set(true);

		// ensure the item is in view
		if (isPlatformBrowser(this._platform)) {
			this._elementRef.nativeElement.scrollIntoView({ block: 'nearest' });
		}
	}

	/** @internal */
	setInactiveStyles(): void {
		this.active.set(false);
	}

	@HostListener('click')
	protected onClick(): void {
		this._command.keyManager.setActiveItem(this);
		this.selected.emit();
	}

	ngOnInit(): void {
		this._initialized.set(true);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command-item.token.ts
```typescript
import { ExistingProvider, InjectionToken, Type } from '@angular/core';
import type { BrnCommandItemDirective } from './brn-command-item.directive';

export const BrnCommandItemToken = new InjectionToken<BrnCommandItemDirective>('BrnCommandItemToken');

export function provideBrnCommandItem(command: Type<BrnCommandItemDirective>): ExistingProvider {
	return { provide: BrnCommandItemToken, useExisting: command };
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command-list.directive.ts
```typescript
import { Directive, input } from '@angular/core';

@Directive({
	standalone: true,
	selector: '[brnCommandList]',
	host: {
		role: 'listbox',
		'[id]': 'id()',
	},
})
export class BrnCommandListDirective {
	private static _id = 0;

	/** The id of the command list */
	public readonly id = input<string>(`brn-command-list-${BrnCommandListDirective._id++}`);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command-search-input.directive.ts
```typescript
import { computed, Directive, effect, ElementRef, Inject, input, Optional, Renderer2, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { COMPOSITION_BUFFER_MODE, DefaultValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { startWith } from 'rxjs/operators';
import { provideBrnCommandSearchInput } from './brn-command-search-input.token';
import { injectBrnCommand } from './brn-command.token';

@Directive({
	selector: 'input[brnCommandSearchInput]',
	standalone: true,
	providers: [
		provideBrnCommandSearchInput(BrnCommandSearchInputDirective),
		{
			provide: NG_VALUE_ACCESSOR,
			useExisting: BrnCommandSearchInputDirective,
			multi: true,
		},
	],
	host: {
		role: 'combobox',
		'aria-autocomplete': 'list',
		'[attr.aria-activedescendant]': '_activeDescendant()',
		'(keydown)': 'onKeyDown($event)',
		'(input)': 'onInput()',
	},
})
export class BrnCommandSearchInputDirective extends DefaultValueAccessor {
	private readonly _command = injectBrnCommand();

	/** The initial value of the search input */
	public readonly value = input<string>('');

	/** @internal The mutable value of the search input */
	public readonly mutableValue = computed(() => signal(this.value()));

	/** @internal The "real" value of the search input */
	public readonly valueState = computed(() => this.mutableValue()());

	/** The id of the active option */
	protected readonly _activeDescendant = signal<string | undefined>(undefined);

	constructor(
		renderer: Renderer2,
		private readonly elementRef: ElementRef,
		@Optional() @Inject(COMPOSITION_BUFFER_MODE) compositionMode: boolean,
	) {
		super(renderer, elementRef, compositionMode);
		this._command.keyManager.change
			.pipe(startWith(this._command.keyManager.activeItemIndex), takeUntilDestroyed())
			.subscribe(() => this._activeDescendant.set(this._command.keyManager.activeItem?.id()));
		effect(() => {
			this.elementRef.nativeElement.value = this.valueState();
		});
	}
	/** Listen for changes to the input value */
	protected onInput(): void {
		this.mutableValue().set(this.elementRef.nativeElement.value);
	}

	/** Listen for keydown events */
	protected onKeyDown(event: KeyboardEvent): void {
		this._command.keyManager.onKeydown(event);
	}

	/** CONROL VALUE ACCESSOR */
	override writeValue(value: string | null): void {
		super.writeValue(value);
		if (value) {
			this.mutableValue().set(value);
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command-search-input.token.ts
```typescript
import { ExistingProvider, InjectionToken, Type } from '@angular/core';
import type { BrnCommandSearchInputDirective } from './brn-command-search-input.directive';

export const BrnCommandSearchInputToken = new InjectionToken<BrnCommandSearchInputDirective>(
	'BrnCommandSearchInputToken',
);

export function provideBrnCommandSearchInput(command: Type<BrnCommandSearchInputDirective>): ExistingProvider {
	return { provide: BrnCommandSearchInputToken, useExisting: command };
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command.directive.ts
```typescript
import { ActiveDescendantKeyManager } from '@angular/cdk/a11y';
import { isPlatformBrowser } from '@angular/common';
import {
	AfterViewInit,
	computed,
	contentChild,
	contentChildren,
	Directive,
	effect,
	HostListener,
	inject,
	Injector,
	input,
	output,
	PLATFORM_ID,
	untracked,
} from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { BrnCommandItemToken } from './brn-command-item.token';
import { BrnCommandSearchInputDirective } from './brn-command-search-input.directive';
import { provideBrnCommand } from './brn-command.token';

@Directive({
	selector: '[brnCommand]',
	standalone: true,
	providers: [provideBrnCommand(BrnCommandDirective)],
	host: {
		'[id]': 'id()',
	},
})
export class BrnCommandDirective implements AfterViewInit {
	private static _id = 0;

	private readonly _platform = inject(PLATFORM_ID);

	private readonly _injector = inject(Injector);

	/** The id of the command */
	public readonly id = input<string>(`brn-command-${BrnCommandDirective._id++}`);

	/** The default filter function */
	private readonly _defaultFilter = (value: string, search: string) =>
		value.toLowerCase().includes(search.toLowerCase());

	/** A custom filter function to use when searching. */
	public readonly filter = input<CommandFilter>(this._defaultFilter);

	/** when the selection has changed */
	public readonly valueChange = output<string>();

	/** @internal The search query */
	public readonly search = computed(() => this._searchInput()?.valueState() ?? '');

	/** Access the search input if present */
	private readonly _searchInput = contentChild(BrnCommandSearchInputDirective, {
		descendants: true,
	});

	/** @internal Access all the items within the commmand */
	public readonly items = contentChildren(BrnCommandItemToken, {
		descendants: true,
	});

	/** @internal The key manager for managing active descendant */
	public readonly keyManager = new ActiveDescendantKeyManager(this.items, this._injector);

	constructor() {
		this.keyManager
			.withVerticalOrientation()
			.withHomeAndEnd()
			.withWrap()
			.skipPredicate((item) => item.disabled || !item.visible());

		// When clearing the search input we also want to reset the active item to the first one
		effect(() => {
			const searchInput = this.search();
			untracked(() => {
				const activeItemIsVisible = this.keyManager.activeItem?.visible();
				if ((searchInput !== undefined && searchInput.length === 0) || !activeItemIsVisible) {
					this.keyManager.setFirstItemActive();
				}
			});
		});

		this.keyManager.change.pipe(takeUntilDestroyed()).subscribe(() => {
			const value = this.keyManager.activeItem?.safeValue();
			if (value) {
				this.valueChange.emit(value);
			}
		});
	}

	ngAfterViewInit(): void {
		if (isPlatformBrowser(this._platform) && this.items().length) {
			this.keyManager.setActiveItem(0);
		}
	}

	@HostListener('keydown.enter')
	protected selectActiveItem(): void {
		this.keyManager.activeItem?.selected.emit();
	}
}

export type CommandFilter = (value: string, search: string) => boolean;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command.token.ts
```typescript
import { ExistingProvider, inject, InjectionToken, Type } from '@angular/core';
import type { BrnCommandDirective } from './brn-command.directive';

export const BrnCommandToken = new InjectionToken<BrnCommandDirective>('BrnCommandToken');

export function provideBrnCommand(command: Type<BrnCommandDirective>): ExistingProvider {
	return { provide: BrnCommandToken, useExisting: command };
}

export function injectBrnCommand(): BrnCommandDirective {
	return inject(BrnCommandToken);
}

```
