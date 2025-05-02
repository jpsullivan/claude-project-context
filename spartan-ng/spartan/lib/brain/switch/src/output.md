/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/switch/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnSwitchThumbComponent } from './lib/brn-switch-thumb.component';
import { BrnSwitchComponent } from './lib/brn-switch.component';

export * from './lib/brn-switch-thumb.component';
export * from './lib/brn-switch.component';

export const BrnSwitchImports = [BrnSwitchComponent, BrnSwitchThumbComponent] as const;

@NgModule({
	imports: [...BrnSwitchImports],
	exports: [...BrnSwitchImports],
})
export class BrnSwitchModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/switch/src/lib/brn-switch-ng-model.spec.ts
```typescript
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';

import { Component, Input } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BrnSwitchThumbComponent } from './brn-switch-thumb.component';
import { BrnSwitchComponent } from './brn-switch.component';

@Component({
	selector: 'brn-switch-ng-model',
	template: `
		<label>
			Airplane mode is: {{ airplaneMode ? 'on' : 'off' }}
			<brn-switch [disabled]="disabled" [(ngModel)]="airplaneMode">
				<brn-switch-thumb />
			</brn-switch>
		</label>
	`,
	imports: [BrnSwitchComponent, BrnSwitchThumbComponent, FormsModule],
})
export class BrnSwitchNgModelSpecComponent {
	@Input()
	public disabled = false;
	@Input()
	public airplaneMode = false;
}

describe('BrnSwitchComponentNgModelIntegration', () => {
	const setup = async (airplaneMode = false, disabled = false) => {
		const container = await render(BrnSwitchNgModelSpecComponent, {
			componentInputs: {
				disabled,
				airplaneMode,
			},
		});
		const labelMatch = airplaneMode ? /airplane mode is: on/i : /airplane mode is: off/i;
		return {
			user: userEvent.setup(),
			container,
			switchElement: screen.getByLabelText(labelMatch),
			labelElement: screen.getByText(labelMatch),
		};
	};

	it('click should toggle value correctly', async () => {
		const { labelElement, user, container } = await setup();
		expect(labelElement).toBeInTheDocument();
		await user.click(labelElement);
		expect(await screen.findByRole('switch')).toHaveAttribute('value', 'on');
		expect(container.fixture.componentInstance.airplaneMode).toBe(true);
	});

	it('should set input as default correctly and click should toggle then', async () => {
		const { labelElement, user, container } = await setup(true);

		await user.click(labelElement);
		expect(await screen.findByRole('switch')).toHaveAttribute('value', 'off');
		expect(container.fixture.componentInstance.airplaneMode).toBe(false);

		await user.click(labelElement);
		expect(await screen.findByRole('switch')).toHaveAttribute('value', 'on');
		expect(container.fixture.componentInstance.airplaneMode).toBe(true);
	});

	it('should set input as default correctly and enter should toggle then', async () => {
		const { user, container } = await setup(true);

		await user.keyboard('[Tab][Enter]');
		expect(container.fixture.componentInstance.airplaneMode).toBe(false);

		await user.keyboard('[Enter]');
		expect(container.fixture.componentInstance.airplaneMode).toBe(true);
	});

	it('should do nothing when disabled', async () => {
		const { labelElement, user, container } = await setup(false, true);

		await user.click(labelElement);
		expect(await screen.findByRole('switch')).toHaveAttribute('value', 'off');
		expect(container.fixture.componentInstance.airplaneMode).toBe(false);

		await user.click(labelElement);
		expect(await screen.findByRole('switch')).toHaveAttribute('value', 'off');
		expect(container.fixture.componentInstance.airplaneMode).toBe(false);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/switch/src/lib/brn-switch-thumb.component.ts
```typescript
import { Component } from '@angular/core';

@Component({
	selector: 'brn-switch-thumb',
	template: '',
	host: {
		role: 'presentation',
		'(click)': '$event.preventDefault()',
	},
})
export class BrnSwitchThumbComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/switch/src/lib/brn-switch.component.spec.ts
```typescript
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import { axe } from 'jest-axe';
import { BrnSwitchThumbComponent } from './brn-switch-thumb.component';
import { BrnSwitchComponent } from './brn-switch.component';

describe('BrnSwitchComponent', () => {
	const setup = async () => {
		const container = await render(
			`
     <brn-switch id='switchId' name='switchName' data-testid='brnSwitch' aria-label='switch'>
             <brn-switch-thumb />
      </brn-switch>
    `,
			{
				imports: [BrnSwitchComponent, BrnSwitchThumbComponent],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			containerElement: screen.getByLabelText('switch'),
		};
	};

	const setupInsideLabel = async () => {
		const container = await render(
			`
     <label>
     Switch Inside Label
     <brn-switch id='switchId' data-testid='brnSwitch' name='switchName'>
             <brn-switch-thumb />
      </brn-switch>
      </label>
    `,
			{
				imports: [BrnSwitchComponent, BrnSwitchThumbComponent],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			containerElement: screen.getByLabelText(/switch inside label/i),
			labelElement: screen.getByText(/switch inside label/i),
		};
	};

	const setupOutsideLabelWithAriaLabelledBy = async () => {
		const container = await render(
			`
     <!-- need for because arialabelledby only provides accessible name -->
     <label id='labelId' for='switchId'>
     Switch Outside Label with ariaLabelledBy
     </label>
     <brn-switch id='switchId' name='switchName' data-testid='brnSwitch' aria-labelledby='labelId'>
             <brn-switch-thumb />
      </brn-switch>
    `,
			{
				imports: [BrnSwitchComponent, BrnSwitchThumbComponent],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			containerElement: screen.getByLabelText(/switch outside label with arialabelledby/i),
			labelElement: screen.getByText(/switch outside label with arialabelledby/i),
		};
	};

	const setupOutsideLabelWithForAndId = async () => {
		const container = await render(
			`
     <label for='switchId'>
     Switch Outside Label with id
     </label>
     <brn-switch id='switchId' name='switchName' data-testid='brnSwitch'>
             <brn-switch-thumb />
      </brn-switch>
    `,
			{
				imports: [BrnSwitchComponent, BrnSwitchThumbComponent],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			containerElement: screen.getByLabelText(/switch outside label with id/i),
			labelElement: screen.getByText(/switch outside label with id/i),
		};
	};

	type Options = Partial<{ focus: boolean; focusVisible: boolean; disabled: boolean }>;

	const validateAttributes = async (
		switchElement: HTMLElement,
		containerElement: HTMLElement,
		shouldBeChecked: boolean,
		opts?: Options,
	) => {
		expect(switchElement).toBeInTheDocument();
		expect(switchElement).toHaveAttribute('type', 'button');
		expect(switchElement).toHaveAttribute('id', 'switchId');
		expect(switchElement).toHaveAttribute('name', 'switchName');
		expect(await axe(switchElement)).toHaveNoViolations();

		expect(containerElement).toHaveAttribute('id', 'switchId-switch');
		expect(containerElement).toHaveAttribute('name', 'switchName-switch');
		expect(containerElement).toHaveAttribute('data-state', shouldBeChecked ? 'checked' : 'unchecked');
		expect(containerElement).toHaveAttribute('data-disabled', `${!!opts?.disabled}`);
		expect(containerElement).toHaveAttribute('data-focus', `${!!opts?.focus}`);
		expect(containerElement).toHaveAttribute('data-focus-visible', `${!!opts?.focusVisible}`);
		expect(await axe(containerElement)).toHaveNoViolations();
	};
	const validateSwitchOn = async (opts?: Options) => {
		const switchElement = await screen.findByRole('switch');
		const containerElement = await screen.findByTestId('brnSwitch');

		await validateAttributes(switchElement, containerElement, true, opts);
	};
	const validateSwitchOff = async (opts?: Options) => {
		const switchElement = await screen.findByRole('switch');
		const containerElement = await screen.findByTestId('brnSwitch');

		await validateAttributes(switchElement, containerElement, false, opts);
	};

	describe('with aria-label', () => {
		it('unchecked by default', async () => {
			await setup();
			await validateSwitchOff();
		});
		it('mouse click on element toggles', async () => {
			const { user, containerElement } = await setup();
			await validateSwitchOff();
			await user.click(containerElement);
			await validateSwitchOn({ focus: true });
			await user.click(containerElement);
			await validateSwitchOff({ focus: true });
		});
		it('focus with tab and enter toggles', async () => {
			const { user } = await setup();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Enter]');
			await validateSwitchOn(options);
			await user.keyboard('[Enter]');
			await validateSwitchOff(options);
			await user.keyboard('[Enter]');
			await validateSwitchOn(options);
		});
		it('focus with tab and space toggles', async () => {
			const { user } = await setup();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Space]');
			await validateSwitchOn(options);
			await user.keyboard('[Space]');
			await validateSwitchOff(options);
			await user.keyboard('[Space]');
			await validateSwitchOn(options);
		});
	});

	describe('inside <label>', () => {
		it('unchecked by default', async () => {
			await setupInsideLabel();
			await validateSwitchOff();
		});
		it('mouse click on element toggles', async () => {
			const { user, labelElement } = await setupInsideLabel();
			await validateSwitchOff();
			await user.click(labelElement);
			await validateSwitchOn({ focus: true });
			await user.click(labelElement);
			await validateSwitchOff({ focus: true });
		});
		it('focus with tab and enter toggles', async () => {
			const { user } = await setupInsideLabel();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Enter]');
			await validateSwitchOn(options);
			await user.keyboard('[Enter]');
			await validateSwitchOff(options);
			await user.keyboard('[Enter]');
			await validateSwitchOn(options);
		});
		it('focus with tab and space toggles', async () => {
			const { user } = await setupInsideLabel();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Space]');
			await validateSwitchOn(options);
			await user.keyboard('[Space]');
			await validateSwitchOff(options);
			await user.keyboard('[Space]');
			await validateSwitchOn(options);
		});
	});

	describe('outside <label> with aria-labelledby', () => {
		it('unchecked by default', async () => {
			await setupOutsideLabelWithAriaLabelledBy();
			await validateSwitchOff();
		});
		it('mouse click on element toggles', async () => {
			const { user, labelElement } = await setupOutsideLabelWithAriaLabelledBy();
			await validateSwitchOff();
			await user.click(labelElement);
			await validateSwitchOn({ focus: true });
			await user.click(labelElement);
			await validateSwitchOff({ focus: true });
		});
		it('focus with tab and enter toggles', async () => {
			const { user } = await setupOutsideLabelWithAriaLabelledBy();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Enter]');
			await validateSwitchOn(options);
			await user.keyboard('[Enter]');
			await validateSwitchOff(options);
			await user.keyboard('[Enter]');
			await validateSwitchOn(options);
		});
		it('focus with tab and space toggles', async () => {
			const { user } = await setupOutsideLabelWithAriaLabelledBy();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Space]');
			await validateSwitchOn(options);
			await user.keyboard('[Space]');
			await validateSwitchOff(options);
			await user.keyboard('[Space]');
			await validateSwitchOn(options);
		});
	});

	describe('outside <label> with for and id', () => {
		it('unchecked by default', async () => {
			await setupOutsideLabelWithForAndId();
			await validateSwitchOff();
		});
		it('mouse click on element toggles', async () => {
			const { user, labelElement } = await setupOutsideLabelWithForAndId();
			await validateSwitchOff();
			await user.click(labelElement);
			await validateSwitchOn({ focus: true });
			await user.click(labelElement);
			await validateSwitchOff({ focus: true });
		});
		it('focus with tab and enter toggles', async () => {
			const { user } = await setupOutsideLabelWithForAndId();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Enter]');
			await validateSwitchOn(options);
			await user.keyboard('[Enter]');
			await validateSwitchOff(options);
			await user.keyboard('[Enter]');
			await validateSwitchOn(options);
		});
		it('focus with tab and space toggles', async () => {
			const { user } = await setupOutsideLabelWithForAndId();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Space]');
			await validateSwitchOn(options);
			await user.keyboard('[Space]');
			await validateSwitchOff(options);
			await user.keyboard('[Space]');
			await validateSwitchOn(options);
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/switch/src/lib/brn-switch.component.ts
```typescript
import { FocusMonitor } from '@angular/cdk/a11y';
import { BooleanInput } from '@angular/cdk/coercion';
import { DOCUMENT, isPlatformBrowser } from '@angular/common';
import {
	type AfterContentInit,
	booleanAttribute,
	ChangeDetectionStrategy,
	ChangeDetectorRef,
	Component,
	computed,
	DestroyRef,
	effect,
	ElementRef,
	forwardRef,
	inject,
	input,
	linkedSignal,
	model,
	type OnDestroy,
	output,
	PLATFORM_ID,
	Renderer2,
	signal,
	viewChild,
	ViewEncapsulation,
} from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { NG_VALUE_ACCESSOR } from '@angular/forms';
import { ChangeFn, TouchFn } from '@spartan-ng/brain/forms';

export const BRN_SWITCH_VALUE_ACCESSOR = {
	provide: NG_VALUE_ACCESSOR,
	useExisting: forwardRef(() => BrnSwitchComponent),
	multi: true,
};

const CONTAINER_POST_FIX = '-switch';

let uniqueIdCounter = 0;

@Component({
	selector: 'brn-switch',
	template: `
		<button
			#switch
			role="switch"
			type="button"
			[class]="class()"
			[id]="getSwitchButtonId(state().id) ?? ''"
			[name]="getSwitchButtonId(state().name) ?? ''"
			[value]="checked() ? 'on' : 'off'"
			[attr.aria-checked]="checked()"
			[attr.aria-label]="ariaLabel() || null"
			[attr.aria-labelledby]="mutableAriaLabelledby() || null"
			[attr.aria-describedby]="ariaDescribedby() || null"
			[attr.data-state]="checked() ? 'checked' : 'unchecked'"
			[attr.data-focus-visible]="focusVisible()"
			[attr.data-focus]="focused()"
			[attr.data-disabled]="state().disabled()"
			[disabled]="state().disabled()"
			[tabIndex]="tabIndex()"
			(click)="$event.preventDefault(); toggle()"
		>
			<ng-content select="brn-switch-thumb" />
		</button>
	`,
	host: {
		'[style]': '{display: "contents"}',
		'[attr.id]': 'state().id',
		'[attr.name]': 'state().name',
		'[attr.aria-labelledby]': 'null',
		'[attr.aria-label]': 'null',
		'[attr.aria-describedby]': 'null',
		'[attr.data-state]': 'checked() ? "checked" : "unchecked"',
		'[attr.data-focus-visible]': 'focusVisible()',
		'[attr.data-focus]': 'focused()',
		'[attr.data-disabled]': 'state().disabled()',
	},
	providers: [BRN_SWITCH_VALUE_ACCESSOR],
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnSwitchComponent implements AfterContentInit, OnDestroy {
	private readonly _destroyRef = inject(DestroyRef);
	private readonly _renderer = inject(Renderer2);
	private readonly _isBrowser = isPlatformBrowser(inject(PLATFORM_ID));
	private readonly _elementRef = inject<ElementRef<HTMLElement>>(ElementRef);
	private readonly _focusMonitor = inject(FocusMonitor);
	private readonly _cdr = inject(ChangeDetectorRef);
	private readonly _document = inject(DOCUMENT);

	protected readonly focusVisible = signal(false);
	protected readonly focused = signal(false);

	/**
	 * Whether the switch is checked.
	 * Can be bound with [(checked)]
	 */
	public readonly checked = model<boolean>(false);

	/**
	 * Sets the ID on the switch.
	 * When provided, the inner button gets this ID without the '-switch' suffix.
	 */
	public readonly id = input<string | null>(uniqueIdCounter++ + '');

	/**
	 * Sets the name on the switch.
	 * When provided, the inner button gets this name without a '-switch' suffix.
	 */
	public readonly name = input<string | null>(null);

	/**
	 * Sets class set on the inner button
	 */
	public readonly class = input<string | null>(null);

	/**
	 * Sets the aria-label attribute for accessibility.
	 */
	public readonly ariaLabel = input<string | null>(null, { alias: 'aria-label' });

	/**
	 * Sets the aria-labelledby attribute for accessibility.
	 */
	public readonly ariaLabelledby = input<string | null>(null, { alias: 'aria-labelledby' });
	public readonly mutableAriaLabelledby = linkedSignal(() => this.ariaLabelledby());

	/**
	 * Sets the aria-describedby attribute for accessibility.
	 */
	public readonly ariaDescribedby = input<string | null>(null, { alias: 'aria-describedby' });

	/**
	 * Whether the switch is required in a form.
	 */
	public readonly required = input(false, { transform: booleanAttribute });

	/**
	 * Whether the switch is disabled.
	 */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/**
	 * tabIndex of the switch.
	 */
	public readonly tabIndex = input(0);

	/**
	 * Event emitted when the switch value changes.
	 */
	public readonly changed = output<boolean>();

	/**
	 * Event emitted when the switch is blurred (loses focus).
	 */
	public readonly touched = output<void>();

	// eslint-disable-next-line @typescript-eslint/no-empty-function
	protected _onChange: ChangeFn<boolean> = () => {};
	// eslint-disable-next-line @typescript-eslint/no-empty-function
	private _onTouched: TouchFn = () => {};

	public readonly switch = viewChild.required<ElementRef<HTMLInputElement>>('switch');

	protected readonly state = computed(() => {
		const name = this.name();
		const id = this.id();
		return {
			disabled: signal(this.disabled()),
			name: name ? name + CONTAINER_POST_FIX : null,
			id: id ? id + CONTAINER_POST_FIX : null,
		};
	});

	constructor() {
		effect(() => {
			const state = this.state();
			const isDisabled = state.disabled();

			if (!this._elementRef.nativeElement || !this._isBrowser) return;

			const newLabelId = state.id + '-label';
			const switchButtonId = this.getSwitchButtonId(state.id);
			const labelElement =
				this._elementRef.nativeElement.closest('label') ??
				this._document.querySelector(`label[for="${switchButtonId}"]`);

			if (!labelElement) return;
			const existingLabelId = labelElement.id;

			this._renderer.setAttribute(labelElement, 'data-disabled', isDisabled ? 'true' : 'false');
			this.mutableAriaLabelledby.set(existingLabelId || newLabelId);

			if (!existingLabelId || existingLabelId.length === 0) {
				this._renderer.setAttribute(labelElement, 'id', newLabelId);
			}
		});
	}

	protected toggle(): void {
		if (this.state().disabled()) return;

		this.checked.update((checked) => !checked);
		this._onChange(this.checked());
		this.changed.emit(this.checked());
	}

	ngAfterContentInit() {
		this._focusMonitor
			.monitor(this._elementRef, true)
			.pipe(takeUntilDestroyed(this._destroyRef))
			.subscribe((focusOrigin) => {
				if (focusOrigin) this.focused.set(true);
				if (focusOrigin === 'keyboard' || focusOrigin === 'program') {
					this.focusVisible.set(true);
					this._cdr.markForCheck();
				}
				if (!focusOrigin) {
					// When a focused element becomes disabled, the browser *immediately* fires a blur event.
					// Angular does not expect events to be raised during change detection, so any state
					// change (such as a form control's ng-touched) will cause a changed-after-checked error.
					// See https://github.com/angular/angular/issues/17793. To work around this, we defer
					// telling the form control it has been touched until the next tick.
					Promise.resolve().then(() => {
						this.focusVisible.set(false);
						this.focused.set(false);
						this._onTouched();
						this.touched.emit();
						this._cdr.markForCheck();
					});
				}
			});

		if (!this.switch()) return;
		this.switch().nativeElement.value = this.checked() ? 'on' : 'off';
		this.switch().nativeElement.dispatchEvent(new Event('change'));
	}

	ngOnDestroy() {
		this._focusMonitor.stopMonitoring(this._elementRef);
	}

	/** We intercept the id passed to the wrapper component and pass it to the underlying button switch control **/
	protected getSwitchButtonId(idPassedToContainer: string | null | undefined): string | null {
		return idPassedToContainer ? idPassedToContainer.replace(CONTAINER_POST_FIX, '') : null;
	}

	writeValue(value: boolean): void {
		this.checked.set(Boolean(value));
	}

	registerOnChange(fn: ChangeFn<boolean>): void {
		this._onChange = fn;
	}

	registerOnTouched(fn: TouchFn): void {
		this._onTouched = fn;
	}

	/** Implemented as a part of ControlValueAccessor. */
	setDisabledState(isDisabled: boolean): void {
		this.state().disabled.set(isDisabled);
		this._cdr.markForCheck();
	}
}

```
