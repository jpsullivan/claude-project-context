/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/input-otp/src/lib/brn-input-otp-slot.component.ts
```typescript
import { NumberInput } from '@angular/cdk/coercion';
import { Component, computed, input, numberAttribute } from '@angular/core';
import { injectBrnInputOtp } from './brn-input-otp.token';

@Component({
	selector: 'brn-input-otp-slot',
	standalone: true,
	template: `
		{{ slot().char }}

		@if (slot().hasFakeCaret) {
			<ng-content />
		}
	`,
	host: {
		'[attr.data-active]': 'slot().isActive',
	},
})
export class BrnInputOtpSlotComponent {
	/** Access the input-otp component */
	protected readonly inputOtp = injectBrnInputOtp();

	public readonly index = input.required<number, NumberInput>({ transform: numberAttribute });

	public readonly slot = computed(() => this.inputOtp.context()[this.index()]);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/input-otp/src/lib/brn-input-otp.component.ts
```typescript
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import {
	booleanAttribute,
	Component,
	computed,
	forwardRef,
	input,
	model,
	numberAttribute,
	output,
	signal,
} from '@angular/core';
import { ControlValueAccessor, FormsModule, NG_VALUE_ACCESSOR } from '@angular/forms';
import { ChangeFn, TouchFn } from '@spartan-ng/brain/forms';
import { provideBrnInputOtp } from './brn-input-otp.token';

export const BRN_INPUT_OTP_VALUE_ACCESSOR = {
	provide: NG_VALUE_ACCESSOR,
	useExisting: forwardRef(() => BrnInputOtpComponent),
	multi: true,
};

export type InputMode = 'text' | 'tel' | 'url' | 'email' | 'numeric' | 'decimal' | 'search';

@Component({
	selector: 'brn-input-otp',
	imports: [FormsModule],
	template: `
		<ng-content />
		<div [style]="containerStyles()">
			<input
				[class]="inputClass()"
				autocomplete="one-time-code"
				data-slot="input-otp"
				[style]="inputStyles()"
				[disabled]="state().disabled()"
				[inputMode]="inputMode()"
				[ngModel]="value()"
				(input)="onInputChange($event)"
				(paste)="onPaste($event)"
				(focus)="focused.set(true)"
				(blur)="focused.set(false)"
			/>
		</div>
	`,
	host: {
		'[style]': 'hostStyles()',
		'data-input-otp-container': 'true',
	},
	providers: [BRN_INPUT_OTP_VALUE_ACCESSOR, provideBrnInputOtp(BrnInputOtpComponent)],
})
export class BrnInputOtpComponent implements ControlValueAccessor {
	/** Whether the input has focus. */
	protected readonly focused = signal<boolean>(false);

	public readonly hostStyles = input<string>(
		'position: relative; cursor: text; user-select: none; pointer-events: none;',
	);

	public readonly inputStyles = input<string>(
		'position: absolute; inset: 0; width: 100%; height: 100%; display: flex; textAlign: left; opacity: 1; color: transparent; pointerEvents: all; background: transparent; caret-color: transparent; border: 0px solid transparent; outline: transparent solid 0px; box-shadow: none; line-height: 1; letter-spacing: -0.5em; font-family: monospace; font-variant-numeric: tabular-nums;',
	);

	public readonly containerStyles = input<string>('position: absolute; inset: 0; pointer-events: none;');

	/** Determine if the date picker is disabled. */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** The number of slots. */
	public readonly maxLength = input.required<number, NumberInput>({ transform: numberAttribute });

	/** Virtual keyboard appearance on mobile */
	public readonly inputMode = input<InputMode>('numeric');

	public readonly inputClass = input<string>('');

	/**
	 * Defines how the pasted text should be transformed before saving to model/form.
	 * Allows pasting text which contains extra characters like spaces, dashes, etc. and are longer than the maxLength.
	 *
	 * "XXX-XXX": (pastedText) => pastedText.replaceAll('-', '')
	 * "XXX XXX": (pastedText) => pastedText.replaceAll(/\s+/g, '')
	 */
	public readonly transformPaste = input<(pastedText: string, maxLength: number) => string>((text) => text);

	/** The value controlling the input */
	public readonly value = model('');

	public readonly context = computed(() => {
		const value = this.value();
		const focused = this.focused();
		const maxLength = this.maxLength();
		const slots = Array.from({ length: this.maxLength() }).map((_, slotIndex) => {
			const char = value[slotIndex] !== undefined ? value[slotIndex] : null;

			const isActive =
				focused && (value.length === slotIndex || (value.length === maxLength && slotIndex === maxLength - 1));

			return {
				char,
				isActive,
				hasFakeCaret: isActive && value.length === slotIndex,
			};
		});

		return slots;
	});

	/** Emitted when the input is complete, triggered through input or paste.  */
	public readonly completed = output<string>();

	protected readonly state = computed(() => ({
		disabled: signal(this.disabled()),
	}));

	protected _onChange?: ChangeFn<string>;
	protected _onTouched?: TouchFn;

	protected onInputChange(event: Event) {
		let newValue = (event.target as HTMLInputElement).value;
		const maxLength = this.maxLength();

		if (newValue.length > maxLength) {
			// Replace the last character when max length is exceeded
			newValue = newValue.slice(0, maxLength - 1) + newValue.slice(-1);
		}

		this.updateValue(newValue, maxLength);
	}

	protected onPaste(event: ClipboardEvent) {
		event.preventDefault();
		const clipboardData = event.clipboardData?.getData('text/plain') || '';

		const maxLength = this.maxLength();

		const content = this.transformPaste()(clipboardData, maxLength);
		const newValue = content.slice(0, maxLength);

		this.updateValue(newValue, maxLength);
	}

	/** CONTROL VALUE ACCESSOR */
	writeValue(value: string | null): void {
		// optional FormControl is initialized with null value
		if (value === null) return;

		this.updateValue(value, this.maxLength());
	}

	registerOnChange(fn: ChangeFn<string>): void {
		this._onChange = fn;
	}

	registerOnTouched(fn: TouchFn): void {
		this._onTouched = fn;
	}

	setDisabledState(isDisabled: boolean): void {
		this.state().disabled.set(isDisabled);
	}

	private isCompleted(newValue: string, previousValue: string, maxLength: number) {
		return newValue !== previousValue && previousValue.length < maxLength && newValue.length === maxLength;
	}

	private updateValue(newValue: string, maxLength: number) {
		const previousValue = this.value();

		this.value.set(newValue);
		this._onChange?.(newValue);

		if (this.isCompleted(newValue, previousValue, maxLength)) {
			this.completed.emit(newValue);
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/input-otp/src/lib/brn-input-otp.token.ts
```typescript
import { ExistingProvider, inject, InjectionToken, Type } from '@angular/core';
import { BrnInputOtpComponent } from './brn-input-otp.component';

export const BrnInputOtpToken = new InjectionToken<BrnInputOtpComponent>('BrnInputOtpToken');

export function injectBrnInputOtp(): BrnInputOtpComponent {
	return inject(BrnInputOtpToken) as BrnInputOtpComponent;
}

export function provideBrnInputOtp(inputOtp: Type<BrnInputOtpComponent>): ExistingProvider {
	return { provide: BrnInputOtpToken, useExisting: inputOtp };
}

```
