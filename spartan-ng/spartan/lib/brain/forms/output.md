/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/forms/README.md
```
# @spartan-ng/brain/forms

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/forms`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/forms/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/forms/src/index.ts
```typescript
export * from './lib/control-value-accessor';
export * from './lib/error-options';
export * from './lib/error-state-tracker';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/forms/src/lib/control-value-accessor.ts
```typescript
export type ChangeFn<T> = (value: T) => void;
export type TouchFn = () => void;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/forms/src/lib/error-options.ts
```typescript
import { Injectable } from '@angular/core';
import type { AbstractControl, FormGroupDirective, NgForm } from '@angular/forms';

/** Error state matcher that matches when a control is invalid and dirty. */
@Injectable()
export class ShowOnDirtyErrorStateMatcher implements ErrorStateMatcher {
	isInvalid(control: AbstractControl | null, form: FormGroupDirective | NgForm | null): boolean {
		return !!(control && control.invalid && (control.dirty || (form && form.submitted)));
	}
}

/** Provider that defines how form controls behave with regards to displaying error messages. */
@Injectable({ providedIn: 'root' })
export class ErrorStateMatcher {
	isInvalid(control: AbstractControl | null, form: FormGroupDirective | NgForm | null): boolean {
		return !!(control && control.invalid && (control.touched || (form && form.submitted)));
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/forms/src/lib/error-state-tracker.ts
```typescript
import { signal } from '@angular/core';
import type { AbstractControl, FormGroupDirective, NgControl, NgForm } from '@angular/forms';
import type { ErrorStateMatcher } from './error-options';

export class ErrorStateTracker {
	/** Whether the tracker is currently in an error state. */
	public readonly errorState = signal(false);

	/** User-defined matcher for the error state. */
	public matcher: ErrorStateMatcher | null = null;

	constructor(
		private readonly _defaultMatcher: ErrorStateMatcher | null,
		public ngControl: NgControl | null,
		private readonly _parentFormGroup: FormGroupDirective | null,
		private readonly _parentForm: NgForm | null,
	) {}

	/** Updates the error state based on the provided error state matcher. */
	updateErrorState() {
		const oldState = this.errorState();
		const parent = this._parentFormGroup || this._parentForm;
		const matcher = this.matcher || this._defaultMatcher;
		const control = this.ngControl ? (this.ngControl.control as AbstractControl) : null;
		const newState = matcher?.isInvalid(control, parent) ?? false;

		if (newState !== oldState) {
			this.errorState.set(newState);
		}
	}
}

```
