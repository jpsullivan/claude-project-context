/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle-group/src/lib/brn-toggle-group.component.spec.ts
```typescript
import { Component, Input } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { fireEvent, render } from '@testing-library/angular';
import { BrnToggleGroupComponent } from './brn-toggle-group.component';
import { BrnToggleGroupItemDirective } from './brn-toggle-item.directive';

@Component({
	standalone: true,
	imports: [BrnToggleGroupItemDirective, BrnToggleGroupComponent],
	template: `
		<brn-toggle-group [(value)]="value" [disabled]="disabled" [multiple]="multiple">
			<button brnToggleGroupItem value="option-1">Option 1</button>
			<button brnToggleGroupItem value="option-2">Option 2</button>
			<button brnToggleGroupItem value="option-3">Option 3</button>
		</brn-toggle-group>
	`,
})
class BrnToggleGroupDirectiveSpecComponent {
	@Input() public value?: string | string[];
	@Input() public disabled = false;
	@Input() public multiple = false;
}

@Component({
	standalone: true,
	imports: [BrnToggleGroupItemDirective, BrnToggleGroupComponent, FormsModule],
	template: `
		<brn-toggle-group [(ngModel)]="value" [multiple]="multiple">
			<button brnToggleGroupItem value="option-1">Option 1</button>
			<button brnToggleGroupItem value="option-2">Option 2</button>
			<button brnToggleGroupItem value="option-3">Option 3</button>
		</brn-toggle-group>
	`,
})
class BrnToggleGroupDirectiveFormSpecComponent {
	@Input() public value?: string | string[];
	@Input() public multiple = false;
}

describe('BrnToggleGroupDirective', () => {
	it('should allow only a single selected toggle button when multiple is false', async () => {
		const { getAllByRole } = await render(BrnToggleGroupDirectiveSpecComponent);
		const buttons = getAllByRole('button');

		expect(buttons[0]).toHaveAttribute('data-state', 'off');
		expect(buttons[1]).toHaveAttribute('data-state', 'off');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');

		await fireEvent.click(buttons[0]);
		expect(buttons[0]).toHaveAttribute('data-state', 'on');
		expect(buttons[1]).toHaveAttribute('data-state', 'off');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');

		await fireEvent.click(buttons[1]);
		expect(buttons[0]).toHaveAttribute('data-state', 'off');
		expect(buttons[1]).toHaveAttribute('data-state', 'on');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');
	});

	it('should allow multiple selected toggle buttons when multiple is true', async () => {
		const { getAllByRole, detectChanges } = await render(BrnToggleGroupDirectiveSpecComponent, {
			inputs: {
				multiple: true,
			},
		});
		const buttons = getAllByRole('button');

		expect(buttons[0]).toHaveAttribute('data-state', 'off');
		expect(buttons[1]).toHaveAttribute('data-state', 'off');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');

		await fireEvent.click(buttons[0]);
		detectChanges();
		expect(buttons[0]).toHaveAttribute('data-state', 'on');
		expect(buttons[1]).toHaveAttribute('data-state', 'off');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');

		await fireEvent.click(buttons[1]);
		detectChanges();
		expect(buttons[0]).toHaveAttribute('data-state', 'on');
		expect(buttons[1]).toHaveAttribute('data-state', 'on');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');
	});

	it('should disable all toggle buttons when disabled is true', async () => {
		const { getAllByRole } = await render(BrnToggleGroupDirectiveSpecComponent, {
			inputs: {
				disabled: true,
			},
		});
		const buttons = getAllByRole('button');

		expect(buttons[0]).toHaveAttribute('disabled');
		expect(buttons[1]).toHaveAttribute('disabled');
		expect(buttons[2]).toHaveAttribute('disabled');
	});

	it('should initially select the button with the provided value (multiple = false)', async () => {
		const { getAllByRole, detectChanges } = await render(BrnToggleGroupDirectiveFormSpecComponent, {
			inputs: {
				value: 'option-2',
			},
		});
		detectChanges();
		const buttons = getAllByRole('button');

		expect(buttons[0]).toHaveAttribute('data-state', 'off');
		expect(buttons[1]).toHaveAttribute('data-state', 'on');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');
	});

	it('should initially select the buttons with the provided values (multiple = true)', async () => {
		const { getAllByRole, detectChanges } = await render(BrnToggleGroupDirectiveFormSpecComponent, {
			inputs: {
				value: ['option-1', 'option-3'],
				multiple: true,
			},
		});
		detectChanges();
		const buttons = getAllByRole('button');

		expect(buttons[0]).toHaveAttribute('data-state', 'on');
		expect(buttons[1]).toHaveAttribute('data-state', 'off');
		expect(buttons[2]).toHaveAttribute('data-state', 'on');
	});

	it('should initially select the button with the provided value (multiple = false) using ngModel', async () => {
		const { getAllByRole, detectChanges } = await render(BrnToggleGroupDirectiveFormSpecComponent, {
			inputs: {
				value: 'option-2',
			},
		});
		detectChanges();
		const buttons = getAllByRole('button');

		expect(buttons[0]).toHaveAttribute('data-state', 'off');
		expect(buttons[1]).toHaveAttribute('data-state', 'on');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');
	});

	it('should initially select the buttons with the provided values (multiple = true) using ngModel', async () => {
		const { getAllByRole, detectChanges } = await render(BrnToggleGroupDirectiveFormSpecComponent, {
			inputs: {
				value: ['option-1', 'option-3'],
				multiple: true,
			},
		});
		detectChanges();
		const buttons = getAllByRole('button');

		expect(buttons[0]).toHaveAttribute('data-state', 'on');
		expect(buttons[1]).toHaveAttribute('data-state', 'off');
		expect(buttons[2]).toHaveAttribute('data-state', 'on');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle-group/src/lib/brn-toggle-group.component.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { Component, booleanAttribute, computed, forwardRef, input, model, output, signal } from '@angular/core';
import { type ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { provideBrnToggleGroup } from './brn-toggle-group.token';
import { BrnToggleGroupItemDirective } from './brn-toggle-item.directive';

export const BRN_BUTTON_TOGGLE_GROUP_VALUE_ACCESSOR = {
	provide: NG_VALUE_ACCESSOR,
	useExisting: forwardRef(() => BrnToggleGroupComponent),
	multi: true,
};

export class BrnButtonToggleChange<T = unknown> {
	constructor(
		public source: BrnToggleGroupItemDirective<T>,
		public value: ToggleValue<T>,
	) {}
}

@Component({
	selector: 'brn-toggle-group',
	standalone: true,
	providers: [provideBrnToggleGroup(BrnToggleGroupComponent), BRN_BUTTON_TOGGLE_GROUP_VALUE_ACCESSOR],
	host: {
		role: 'group',
		class: 'brn-button-toggle-group',
		'[attr.aria-disabled]': 'state().disabled()',
		'[attr.data-disabled]': 'state().disabled()',
		'[attr.data-vertical]': 'vertical()',
		'(focusout)': 'onTouched()',
	},
	exportAs: 'brnToggleGroup',
	template: `
		<ng-content />
	`,
})
export class BrnToggleGroupComponent<T = unknown> implements ControlValueAccessor {
	/**
	 * The method to be called in order to update ngModel.
	 */
	// eslint-disable-next-line @typescript-eslint/no-empty-function
	private _onChange: (value: ToggleValue<T>) => void = () => {};

	/** onTouch function registered via registerOnTouch (ControlValueAccessor). */
	// eslint-disable-next-line @typescript-eslint/no-empty-function
	protected onTouched: () => void = () => {};

	/** Whether the button toggle group has a vertical orientation */
	public readonly vertical = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** Value of the toggle group. */
	public readonly value = model<ToggleValue<T>>(undefined);

	/** Whether no button toggles need to be selected. */
	public readonly nullable = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** Whether multiple button toggles can be selected. */
	public readonly multiple = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** Whether the button toggle group is disabled. */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** The internal state of the component. This can be replaced with linkedSignal in the future. */
	public readonly state = computed(() => ({
		disabled: signal(this.disabled()),
	}));

	/** Emit event when the group value changes. */
	public readonly change = output<BrnButtonToggleChange<T>>();

	writeValue(value: ToggleValue<T>): void {
		this.value.set(value);
	}

	registerOnChange(fn: (value: ToggleValue<T>) => void) {
		this._onChange = fn;
	}

	registerOnTouched(fn: () => void) {
		this.onTouched = fn;
	}

	setDisabledState(isDisabled: boolean): void {
		this.state().disabled.set(isDisabled);
	}

	/**
	 * @internal
	 * Determines whether a value can be set on the group.
	 */
	canDeselect(value: ToggleValue<T>): boolean {
		// if null values are allowed, the group can always be nullable
		if (this.nullable()) return true;

		const currentValue = this.value();

		if (this.multiple() && Array.isArray(currentValue)) {
			return !(currentValue.length === 1 && currentValue[0] === value);
		}

		return currentValue !== value;
	}

	/**
	 * @internal
	 * Selects a value.
	 */
	select(value: T, source: BrnToggleGroupItemDirective<T>): void {
		if (this.state().disabled() || this.isSelected(value)) {
			return;
		}

		const currentValue = this.value();

		// emit the valueChange event here as we should only emit based on user interaction
		if (this.multiple()) {
			this.emitSelectionChange([...((currentValue ?? []) as T[]), value], source);
		} else {
			this.emitSelectionChange(value, source);
		}

		this._onChange(this.value());
		this.change.emit(new BrnButtonToggleChange<T>(source, this.value()));
	}

	/**
	 * @internal
	 * Deselects a value.
	 */
	deselect(value: T, source: BrnToggleGroupItemDirective<T>): void {
		if (this.state().disabled() || !this.isSelected(value) || !this.canDeselect(value)) {
			return;
		}

		const currentValue = this.value();

		if (this.multiple()) {
			this.emitSelectionChange(
				((currentValue ?? []) as T[]).filter((v) => v !== value),
				source,
			);
		} else if (currentValue === value) {
			this.emitSelectionChange(null, source);
		}
	}

	/**
	 * @internal
	 * Determines whether a value is selected.
	 */
	isSelected(value: T): boolean {
		const currentValue = this.value();

		if (
			currentValue == null ||
			currentValue === undefined ||
			(Array.isArray(currentValue) && currentValue.length === 0)
		) {
			return false;
		}

		if (this.multiple()) {
			return (currentValue as T[])?.includes(value);
		}
		return currentValue === value;
	}

	/** Update the value of the group */
	private emitSelectionChange(value: ToggleValue<T>, source: BrnToggleGroupItemDirective<T>): void {
		this.value.set(value);
		this._onChange(value);
		this.change.emit(new BrnButtonToggleChange<T>(source, this.value()));
	}
}

type ToggleValue<T> = T | T[] | null | undefined;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle-group/src/lib/brn-toggle-group.token.ts
```typescript
import { ExistingProvider, InjectionToken, Type, inject } from '@angular/core';
import type { BrnToggleGroupComponent } from './brn-toggle-group.component';

const BrnToggleGroupToken = new InjectionToken<BrnToggleGroupComponent>('BrnToggleGroupToken');

export function injectBrnToggleGroup<T>(): BrnToggleGroupComponent<T> | null {
	return inject(BrnToggleGroupToken, { optional: true }) as BrnToggleGroupComponent<T> | null;
}

export function provideBrnToggleGroup<T>(value: Type<BrnToggleGroupComponent<T>>): ExistingProvider {
	return { provide: BrnToggleGroupToken, useExisting: value };
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle-group/src/lib/brn-toggle-item.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { ChangeDetectorRef, Directive, booleanAttribute, computed, inject, input, model } from '@angular/core';
import { injectBrnToggleGroup } from './brn-toggle-group.token';

@Directive({
	selector: 'button[hlmToggleGroupItem], button[brnToggleGroupItem]',
	standalone: true,
	host: {
		'[id]': 'id()',
		'[attr.disabled]': 'disabled() || group?.disabled() ? true : null',
		'[attr.data-disabled]': 'disabled() || group?.disabled() ? true : null',
		'[attr.data-state]': '_state()',
		'[attr.aria-pressed]': 'isOn()',
		'(click)': 'toggle()',
	},
})
export class BrnToggleGroupItemDirective<T> {
	private static _uniqueId = 0;

	private readonly _changeDetector = inject(ChangeDetectorRef);

	/** Access the toggle group if available. */
	protected readonly group = injectBrnToggleGroup<T>();

	/** The id of the toggle. */
	public readonly id = input(`brn-toggle-group-item-${BrnToggleGroupItemDirective._uniqueId++}`);

	/** The value this toggle represents. */
	public readonly value = input<T>();

	/** Whether the toggle is disabled. */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** The current state of the toggle when not used in a group. */
	public readonly state = model<'on' | 'off'>('off');

	/** Whether the toggle is responds to click events. */
	public readonly disableToggleClick = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** Whether the toggle is in the on state. */
	protected readonly isOn = computed(() => this._state() === 'on');

	/** The current state that reflects the group state or the model state. */
	protected readonly _state = computed(() => {
		if (this.group) {
			return this.group.isSelected(this.value() as T) ? 'on' : 'off';
		}
		return this.state();
	});

	toggle(): void {
		if (this.disableToggleClick()) return;

		if (this.group) {
			if (this.isOn()) {
				this.group.deselect(this.value() as T, this);
			} else {
				this.group.select(this.value() as T, this);
			}
		} else {
			this.state.set(this.isOn() ? 'off' : 'on');
		}
	}
}

```
