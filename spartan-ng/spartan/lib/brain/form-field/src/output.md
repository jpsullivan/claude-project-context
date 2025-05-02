/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/form-field/src/index.ts
```typescript
export * from './lib/brn-form-field-control';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/form-field/src/lib/brn-form-field-control.ts
```typescript
import { Directive, type Signal, signal } from '@angular/core';
import type { AbstractControlDirective, NgControl } from '@angular/forms';

@Directive()
export class BrnFormFieldControl {
	/** Gets the AbstractControlDirective for this control. */
	public readonly ngControl: NgControl | AbstractControlDirective | null = null;

	/** Whether the control is in an error state. */
	public readonly errorState: Signal<boolean> = signal(false);
}

```
