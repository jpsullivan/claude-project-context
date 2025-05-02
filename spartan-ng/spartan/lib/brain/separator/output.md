/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/separator/README.md
```
# @spartan-ng/brain/separator

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/separator`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/separator/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/separator/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { BrnSeparatorComponent } from './lib/brn-separator.component';

export * from './lib/brn-separator.component';

@NgModule({
	imports: [BrnSeparatorComponent],
	exports: [BrnSeparatorComponent],
})
export class BrnSeparatorModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/separator/src/lib/brn-separator.component.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { Component, booleanAttribute, computed, input } from '@angular/core';

export type BrnSeparatorOrientation = 'horizontal' | 'vertical';

@Component({
	selector: 'brn-separator',
	standalone: true,
	template: '',
	host: {
		'[role]': 'role()',
		'[attr.aria-orientation]': 'ariaOrientation()',
		'[attr.data-orientation]': 'orientation()',
	},
})
export class BrnSeparatorComponent {
	public readonly orientation = input<BrnSeparatorOrientation>('horizontal');
	public readonly decorative = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

	protected readonly role = computed(() => (this.decorative() ? 'none' : 'separator'));
	protected readonly ariaOrientation = computed(() =>
		this.decorative() ? undefined : this.orientation() === 'vertical' ? 'vertical' : undefined,
	);
}

```
