/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-skeleton-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';
import { HlmSkeletonComponent } from './lib/hlm-skeleton.component';

export * from './lib/hlm-skeleton.component';

@NgModule({
	imports: [HlmSkeletonComponent],
	exports: [HlmSkeletonComponent],
})
export class HlmSkeletonModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-skeleton-helm/files/lib/hlm-skeleton.component.ts.template
```
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-skeleton',
	standalone: true,
	template: '',
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSkeletonComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('block animate-pulse rounded-md bg-muted', this.userClass()));
}

```
