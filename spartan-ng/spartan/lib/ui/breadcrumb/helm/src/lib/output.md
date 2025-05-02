/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/lib/breadcrumb-ellipsis.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideEllipsis } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-breadcrumb-ellipsis',
	imports: [NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideEllipsis })],
	template: `
		<span role="presentation" aria-hidden="true" [class]="_computedClass()">
			<ng-icon hlm size="sm" name="lucideEllipsis" />
			<span class="sr-only">More</span>
		</span>
	`,
})
export class HlmBreadcrumbEllipsisComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => hlm('flex h-9 w-9 items-center justify-center', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/lib/breadcrumb-item.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmBreadcrumbItem]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmBreadcrumbItemDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => hlm('inline-flex items-center gap-1.5', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/lib/breadcrumb-link.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { RouterLink } from '@angular/router';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmBreadcrumbLink]',
	standalone: true,
	hostDirectives: [
		{
			directive: RouterLink,
			inputs: [
				'target',
				'queryParams',
				'fragment',
				'queryParamsHandling',
				'state',
				'info',
				'relativeTo',
				'preserveFragment',
				'skipLocationChange',
				'replaceUrl',
				'routerLink: link',
			],
		},
	],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmBreadcrumbLinkDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly link = input<RouterLink['routerLink']>();

	protected readonly _computedClass = computed(() => hlm('transition-colors hover:text-foreground', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/lib/breadcrumb-list.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmBreadcrumbList]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmBreadcrumbListDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm('flex flex-wrap items-center gap-1.5 break-words text-sm text-muted-foreground sm:gap-2.5', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/lib/breadcrumb-page.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmBreadcrumbPage]',
	standalone: true,
	host: {
		role: 'link',
		'[class]': '_computedClass()',
		'[attr.aria-disabled]': 'disabled',
		'[attr.aria-current]': 'page',
	},
})
export class HlmBreadcrumbPageDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => hlm('font-normal text-foreground', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/lib/breadcrumb-separator.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronRight } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	// eslint-disable-next-line @angular-eslint/component-selector
	selector: '[hlmBreadcrumbSeparator]',
	imports: [NgIcon],
	providers: [provideIcons({ lucideChevronRight })],
	host: {
		role: 'presentation',
		'[class]': '_computedClass()',
		'[attr.aria-hidden]': 'true',
	},
	template: `
		<ng-content>
			<ng-icon name="lucideChevronRight" />
		</ng-content>
	`,
})
export class HlmBreadcrumbSeparatorComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm('[&>ng-icon]:text-[14px] [&>ng-icon]:flex!', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/lib/breadcrumb.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmBreadcrumb]',
	standalone: true,
	host: {
		role: 'navigation',
		'[class]': '_computedClass()',
		'[attr.aria-label]': 'ariaLabel()',
	},
})
export class HlmBreadcrumbDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly ariaLabel = input<string>('breadcrumb', { alias: 'aria-label' });

	protected readonly _computedClass = computed(() => hlm(this.userClass()));
}

```
