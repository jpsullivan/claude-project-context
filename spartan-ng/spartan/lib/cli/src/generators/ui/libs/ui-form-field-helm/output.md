/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-form-field-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'formfield',
		internalName: 'ui-form-field-helm',
		publicName: 'ui-formfield-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-form-field-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';
import { HlmErrorDirective } from './lib/hlm-error.directive';
import { HlmFormFieldComponent } from './lib/hlm-form-field.component';
import { HlmHintDirective } from './lib/hlm-hint.directive';

export * from './lib/hlm-error.directive';
export * from './lib/hlm-form-field.component';
export * from './lib/hlm-hint.directive';

@NgModule({
	imports: [HlmFormFieldComponent, HlmErrorDirective, HlmHintDirective],
	exports: [HlmFormFieldComponent, HlmErrorDirective, HlmHintDirective],
})
export class HlmFormFieldModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-form-field-helm/files/lib/form-field.spec.ts.template
```
/* eslint-disable @angular-eslint/component-class-suffix */
/* eslint-disable @angular-eslint/component-selector */
import { Component } from '@angular/core';
import { FormControl, ReactiveFormsModule, Validators } from '@angular/forms';
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';

import { HlmInputDirective } from '@spartan-ng/ui-input-helm';

import { ErrorStateMatcher, ShowOnDirtyErrorStateMatcher } from '@spartan-ng/brain/forms';
import { HlmErrorDirective } from './hlm-error.directive';
import { HlmFormFieldComponent } from './hlm-form-field.component';
import { HlmHintDirective } from './hlm-hint.directive';

const DIRECTIVES = [HlmFormFieldComponent, HlmErrorDirective, HlmHintDirective, HlmInputDirective];

@Component({
	standalone: true,
	selector: 'single-form-field-example',
	imports: [ReactiveFormsModule, ...DIRECTIVES],
	template: `
		<hlm-form-field>
			<input
				data-testid="hlm-input"
				aria-label="Your Name"
				[formControl]="name"
				class="w-80"
				hlmInput
				type="text"
				placeholder="Your Name"
			/>
			<hlm-error data-testid="hlm-error">Your name is required</hlm-error>
			<hlm-hint data-testid="hlm-hint">This is your public display name.</hlm-hint>
		</hlm-form-field>
	`,
})
class SingleFormFieldMock {
	public name = new FormControl('', Validators.required);
}

@Component({
	standalone: true,
	selector: 'single-form-field-dirty-example',
	imports: [ReactiveFormsModule, ...DIRECTIVES],
	template: `
		<hlm-form-field>
			<input
				data-testid="hlm-input"
				aria-label="Your Name"
				[formControl]="name"
				class="w-80"
				hlmInput
				type="text"
				placeholder="Your Name"
			/>
			<hlm-error data-testid="hlm-error">Your name is required</hlm-error>
			<hlm-hint data-testid="hlm-hint">This is your public display name.</hlm-hint>
		</hlm-form-field>
	`,
	providers: [{ provide: ErrorStateMatcher, useClass: ShowOnDirtyErrorStateMatcher }],
})
class SingleFormFieldDirtyMock {
	public name = new FormControl('', Validators.required);
}

describe('Hlm Form Field Component', () => {
	const TEXT_HINT = 'This is your public display name.';
	const TEXT_ERROR = 'Your name is required';

	const setupFormField = async () => {
		const { fixture } = await render(SingleFormFieldMock);
		return {
			user: userEvent.setup(),
			fixture,
			hint: screen.getByTestId('hlm-hint'),
			error: () => screen.queryByTestId('hlm-error'),
			trigger: screen.getByTestId('hlm-input'),
		};
	};

	const setupFormFieldWithErrorStateDirty = async () => {
		const { fixture } = await render(SingleFormFieldDirtyMock);
		return {
			user: userEvent.setup(),
			fixture,
			hint: screen.getByTestId('hlm-hint'),
			error: () => screen.queryByTestId('hlm-error'),
			trigger: screen.getByTestId('hlm-input'),
		};
	};

	describe('SingleFormField', () => {
		it('should show the hint if the errorState is false', async () => {
			const { hint } = await setupFormField();

			expect(hint.textContent).toBe(TEXT_HINT);
		});

		it('should show the error if the errorState is true', async () => {
			const { user, error, trigger } = await setupFormField();

			expect(error()).toBeNull();

			await user.click(trigger);

			await user.click(document.body);

			expect(screen.queryByTestId('hlm-hint')).toBeNull();
			expect(error()?.textContent?.trim()).toBe(TEXT_ERROR);
		});
	});

	describe('SingleFormFieldDirty', () => {
		it('should not display the error if the input does not have the dirty state due to the ErrorStateMatcher', async () => {
			const { error, user, trigger } = await setupFormFieldWithErrorStateDirty();

			await user.click(trigger);

			await user.click(document.body);

			expect(error()).toBeNull();
		});

		it('should display the error if the input has the dirty state due to the ErrorStateMatcher', async () => {
			const { error, user, trigger } = await setupFormFieldWithErrorStateDirty();

			await user.click(trigger);
			await user.type(trigger, 'a');
			await user.clear(trigger);

			await user.click(document.body);

			expect(error()?.textContent?.trim()).toBe(TEXT_ERROR);
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-form-field-helm/files/lib/hlm-error.directive.ts.template
```
import { Directive } from '@angular/core';

@Directive({
	standalone: true,
	// eslint-disable-next-line @angular-eslint/directive-selector
	selector: 'hlm-error',
	host: {
		class: 'block text-destructive text-sm font-medium',
	},
})
export class HlmErrorDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-form-field-helm/files/lib/hlm-form-field.component.ts.template
```
import { Component, computed, contentChild, contentChildren, effect } from '@angular/core';
import { BrnFormFieldControl } from '@spartan-ng/brain/form-field';
import { HlmErrorDirective } from './hlm-error.directive';

@Component({
	selector: 'hlm-form-field',
	template: `
		<ng-content />

		@switch (hasDisplayedMessage()) {
			@case ('error') {
				<ng-content select="hlm-error" />
			}
			@default {
				<ng-content select="hlm-hint" />
			}
		}
	`,
	standalone: true,
	host: {
		class: 'space-y-2 block',
	},
})
export class HlmFormFieldComponent {
	public readonly control = contentChild(BrnFormFieldControl);

	public readonly errorChildren = contentChildren(HlmErrorDirective);

	protected readonly hasDisplayedMessage = computed<'error' | 'hint'>(() =>
		this.errorChildren() && this.errorChildren().length > 0 && this.control()?.errorState() ? 'error' : 'hint',
	);

	constructor() {
		effect(() => {
			if (!this.control()) {
				throw new Error('hlm-form-field must contain a BrnFormFieldControl.');
			}
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-form-field-helm/files/lib/hlm-hint.directive.ts.template
```
import { Directive } from '@angular/core';

@Directive({
	// eslint-disable-next-line @angular-eslint/directive-selector
	selector: 'hlm-hint',
	standalone: true,
	host: {
		class: 'block text-sm text-muted-foreground',
	},
})
export class HlmHintDirective {}

```
