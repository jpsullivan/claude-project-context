/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle/README.md
```
# @spartan-ng/brain/toggle

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/toggle`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { BrnToggleDirective } from './lib/brn-toggle.directive';

export * from './lib/brn-toggle.directive';

@NgModule({
	imports: [BrnToggleDirective],
	exports: [BrnToggleDirective],
})
export class BrnToggleModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle/src/lib/brn-toggle.directive.spec.ts
```typescript
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import { BrnToggleDirective } from './brn-toggle.directive';

describe('BrnToggleDirective', () => {
	const setup = async (disabled = false) => {
		const container = await render(
			`
     <button ${disabled ? 'disabled' : ''} brnToggle>Toggle</button>
    `,
			{
				imports: [BrnToggleDirective],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			toggle: screen.getByRole('button'),
		};
	};

	it('should be toggled off by default and then toggle between on and off on for click', async () => {
		const { toggle, container, user } = await setup();
		expect(toggle).not.toHaveAttribute('data-disabled');
		expect(toggle).not.toHaveAttribute('disabled');

		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');

		await user.click(toggle);
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'on');

		await user.click(toggle);
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');
	});

	it('should be toggled off by default and then toggle between on and off on for enter', async () => {
		const { toggle, container, user } = await setup();
		expect(toggle).not.toHaveAttribute('data-disabled');
		expect(toggle).not.toHaveAttribute('disabled');

		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');

		await user.keyboard('[Tab][Enter]');
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'on');

		await user.keyboard('[Enter]');
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');
	});

	it('should be toggled off by default and then toggle between on and off on for space', async () => {
		const { toggle, container, user } = await setup();
		expect(toggle).not.toHaveAttribute('data-disabled');
		expect(toggle).not.toHaveAttribute('disabled');

		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');

		await user.keyboard('[Tab][Space]');
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'on');

		await user.keyboard('[Space]');
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');
	});

	it('should add correct id, aria and disabled toggling when disabled', async () => {
		const { toggle, container, user } = await setup(true);
		expect(toggle).toHaveAttribute('data-state', 'off');
		expect(toggle).toHaveAttribute('id', expect.stringMatching(/brn-toggle-\d+/));
		expect(toggle).toHaveAttribute('data-disabled');
		expect(toggle).toHaveAttribute('disabled');

		await user.keyboard('[Tab][Space]');
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');

		await user.click(toggle);
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');

		await user.keyboard('[Enter]');
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle/src/lib/brn-toggle.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { ChangeDetectorRef, Directive, booleanAttribute, computed, inject, input, model } from '@angular/core';

@Directive({
	selector: 'button[hlmToggle], button[brnToggle]',
	standalone: true,
	host: {
		'[id]': 'id()',
		'[attr.disabled]': 'disabled() ? true : null',
		'[attr.data-disabled]': 'disabled() ? true : null',
		'[attr.data-state]': '_state()',
		'[attr.aria-pressed]': 'isOn()',
		'(click)': 'toggle()',
	},
})
export class BrnToggleDirective<T> {
	private static _uniqueId = 0;

	private readonly _changeDetector = inject(ChangeDetectorRef);

	/** The id of the toggle. */
	public readonly id = input(`brn-toggle-${BrnToggleDirective._uniqueId++}`);

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
		return this.state();
	});

	toggle(): void {
		if (this.disableToggleClick()) return;

		this.state.set(this.isOn() ? 'off' : 'on');
	}
}

```
