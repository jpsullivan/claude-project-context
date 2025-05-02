/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmScrollAreaDirective } from './lib/hlm-scroll-area.directive';

export * from './lib/hlm-scroll-area.directive';

@NgModule({
	imports: [HlmScrollAreaDirective],
	exports: [HlmScrollAreaDirective],
})
export class HlmScrollAreaModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/src/test-setup.ts
```typescript
// @ts-expect-error https://thymikee.github.io/jest-preset-angular/docs/getting-started/test-environment
globalThis.ngJest = {
	testEnvironmentOptions: {
		errorOnUnknownElements: true,
		errorOnUnknownProperties: true,
	},
};
import 'jest-preset-angular/setup-jest';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/src/lib/hlm-scroll-area.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: 'ng-scrollbar[hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		'[style.--scrollbar-border-radius.px]': '100',
		'[style.--scrollbar-offset]': '3',
		'[style.--scrollbar-thumb-color]': '"hsl(var(--border))"',
		'[style.--scrollbar-thumb-hover-color]': '"hsl(var(--border))"',
		'[style.--scrollbar-thickness]': '7',
	},
})
export class HlmScrollAreaDirective {
	protected readonly _computedClass = computed(() => hlm('block', this.userClass()));
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
}

```
