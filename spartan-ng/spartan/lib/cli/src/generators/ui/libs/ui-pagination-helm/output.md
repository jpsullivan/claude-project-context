/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'pagination',
		internalName: 'ui-pagination-helm',
		publicName: 'ui-pagination-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';

import { HlmNumberedPaginationComponent } from './lib/hlm-numbered-pagination.component';
import { HlmPaginationContentDirective } from './lib/hlm-pagination-content.directive';
import { HlmPaginationEllipsisComponent } from './lib/hlm-pagination-ellipsis.component';
import { HlmPaginationItemDirective } from './lib/hlm-pagination-item.directive';
import { HlmPaginationLinkDirective } from './lib/hlm-pagination-link.directive';
import { HlmPaginationNextComponent } from './lib/hlm-pagination-next.component';
import { HlmPaginationPreviousComponent } from './lib/hlm-pagination-previous.component';
import { HlmPaginationDirective } from './lib/hlm-pagination.directive';

export * from './lib/hlm-numbered-pagination.component';
export * from './lib/hlm-pagination-content.directive';
export * from './lib/hlm-pagination-ellipsis.component';
export * from './lib/hlm-pagination-item.directive';
export * from './lib/hlm-pagination-link.directive';
export * from './lib/hlm-pagination-next.component';
export * from './lib/hlm-pagination-previous.component';
export * from './lib/hlm-pagination.directive';

export const HlmPaginationImports = [
	HlmPaginationDirective,
	HlmPaginationContentDirective,
	HlmPaginationItemDirective,
	HlmPaginationLinkDirective,
	HlmPaginationPreviousComponent,
	HlmPaginationNextComponent,
	HlmPaginationEllipsisComponent,
	HlmNumberedPaginationComponent,
] as const;

@NgModule({
	imports: [...HlmPaginationImports],
	exports: [...HlmPaginationImports],
})
export class HlmPaginationModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-numbered-pagination.component.ts.template
```
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import {
	ChangeDetectionStrategy,
	Component,
	booleanAttribute,
	computed,
	input,
	model,
	numberAttribute,
	untracked,
} from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BrnSelectImports } from '@spartan-ng/brain/select';
import { HlmSelectImports } from '@spartan-ng/ui-select-helm';
import { HlmPaginationContentDirective } from './hlm-pagination-content.directive';
import { HlmPaginationEllipsisComponent } from './hlm-pagination-ellipsis.component';
import { HlmPaginationItemDirective } from './hlm-pagination-item.directive';
import { HlmPaginationLinkDirective } from './hlm-pagination-link.directive';
import { HlmPaginationNextComponent } from './hlm-pagination-next.component';
import { HlmPaginationPreviousComponent } from './hlm-pagination-previous.component';
import { HlmPaginationDirective } from './hlm-pagination.directive';

@Component({
	selector: 'hlm-numbered-pagination',
	template: `
		<div class="flex items-center justify-between gap-2 px-4 py-2">
			<div class="flex items-center gap-1 text-nowrap text-sm text-gray-600">
				<b>{{ totalItems() }}</b>
				total items |
				<b>{{ pages().length }}</b>
				pages
			</div>

			<nav hlmPagination>
				<ul hlmPaginationContent>
					@if (showEdges() && !isFirstPageActive()) {
						<li hlmPaginationItem (click)="goToPrevious()">
							<hlm-pagination-previous />
						</li>
					}

					@for (page of pages(); track page) {
						<li hlmPaginationItem>
							@if (page === '...') {
								<hlm-pagination-ellipsis />
							} @else {
								<a hlmPaginationLink [isActive]="currentPage() === page" (click)="currentPage.set(page)">
									{{ page }}
								</a>
							}
						</li>
					}

					@if (showEdges() && !isLastPageActive()) {
						<li hlmPaginationItem (click)="goToNext()">
							<hlm-pagination-next />
						</li>
					}
				</ul>
			</nav>

			<!-- Show Page Size selector -->
			<brn-select [(ngModel)]="itemsPerPage" class="ml-auto" placeholder="Page size">
				<hlm-select-trigger class="w-fit">
					<hlm-select-value />
				</hlm-select-trigger>
				<hlm-select-content>
					@for (pageSize of pageSizesWithCurrent(); track pageSize) {
						<hlm-option [value]="pageSize">{{ pageSize }} / page</hlm-option>
					}
				</hlm-select-content>
			</brn-select>
		</div>
	`,
	imports: [
		FormsModule,
		HlmPaginationDirective,
		HlmPaginationContentDirective,
		HlmPaginationItemDirective,
		HlmPaginationPreviousComponent,
		HlmPaginationNextComponent,
		HlmPaginationLinkDirective,
		HlmPaginationEllipsisComponent,
		BrnSelectImports,
		HlmSelectImports,
	],
	changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HlmNumberedPaginationComponent {
	/**
	 * The current (active) page.
	 */
	public readonly currentPage = model.required<number>();

	/**
	 * The number of items per paginated page.
	 */
	public readonly itemsPerPage = model.required<number>();

	/**
	 * The total number of items in the collection. Only useful when
	 * doing server-side paging, where the collection size is limited
	 * to a single page returned by the server API.
	 */
	public readonly totalItems = input.required<number, NumberInput>({
		transform: numberAttribute,
	});

	/**
	 * The number of page links to show.
	 */
	public readonly maxSize = input<number, NumberInput>(7, {
		transform: numberAttribute,
	});

	/**
	 * Show the first and last page buttons.
	 */
	public readonly showEdges = input<boolean, BooleanInput>(true, {
		transform: booleanAttribute,
	});

	/**
	 * The page sizes to show.
	 * Defaults to [10, 20, 50, 100]
	 */
	public readonly pageSizes = input<number[]>([10, 20, 50, 100]);

	protected readonly pageSizesWithCurrent = computed(() => {
		const pageSizes = this.pageSizes();
		return pageSizes.includes(this.itemsPerPage())
			? pageSizes // if current page size is included, return the same array
			: [...pageSizes, this.itemsPerPage()].sort((a, b) => a - b); // otherwise, add current page size and sort the array
	});

	protected readonly isFirstPageActive = computed(() => this.currentPage() === 1);
	protected readonly isLastPageActive = computed(() => this.currentPage() === this.lastPageNumber());

	protected readonly lastPageNumber = computed(() => {
		if (this.totalItems() < 1) {
			// when there are 0 or fewer (an error case) items, there are no "pages" as such,
			// but it makes sense to consider a single, empty page as the last page.
			return 1;
		}
		return Math.ceil(this.totalItems() / this.itemsPerPage());
	});

	protected readonly pages = computed(() => {
		const correctedCurrentPage = outOfBoundCorrection(this.totalItems(), this.itemsPerPage(), this.currentPage());

		if (correctedCurrentPage !== this.currentPage()) {
			// update the current page
			untracked(() => this.currentPage.set(correctedCurrentPage));
		}

		return createPageArray(correctedCurrentPage, this.itemsPerPage(), this.totalItems(), this.maxSize());
	});

	protected goToPrevious(): void {
		this.currentPage.set(this.currentPage() - 1);
	}

	protected goToNext(): void {
		this.currentPage.set(this.currentPage() + 1);
	}

	protected goToFirst(): void {
		this.currentPage.set(1);
	}

	protected goToLast(): void {
		this.currentPage.set(this.lastPageNumber());
	}
}

type Page = number | '...';

/**
 * Checks that the instance.currentPage property is within bounds for the current page range.
 * If not, return a correct value for currentPage, or the current value if OK.
 *
 * Copied from 'ngx-pagination' package
 */
function outOfBoundCorrection(totalItems: number, itemsPerPage: number, currentPage: number): number {
	const totalPages = Math.ceil(totalItems / itemsPerPage);
	if (totalPages < currentPage && 0 < totalPages) {
		return totalPages;
	}

	if (currentPage < 1) {
		return 1;
	}

	return currentPage;
}

/**
 * Returns an array of Page objects to use in the pagination controls.
 *
 * Copied from 'ngx-pagination' package
 */
function createPageArray(
	currentPage: number,
	itemsPerPage: number,
	totalItems: number,
	paginationRange: number,
): Page[] {
	// paginationRange could be a string if passed from attribute, so cast to number.
	paginationRange = +paginationRange;
	const pages: Page[] = [];

	// Return 1 as default page number
	// Make sense to show 1 instead of empty when there are no items
	const totalPages = Math.max(Math.ceil(totalItems / itemsPerPage), 1);
	const halfWay = Math.ceil(paginationRange / 2);

	const isStart = currentPage <= halfWay;
	const isEnd = totalPages - halfWay < currentPage;
	const isMiddle = !isStart && !isEnd;

	const ellipsesNeeded = paginationRange < totalPages;
	let i = 1;

	while (i <= totalPages && i <= paginationRange) {
		let label: number | '...';
		const pageNumber = calculatePageNumber(i, currentPage, paginationRange, totalPages);
		const openingEllipsesNeeded = i === 2 && (isMiddle || isEnd);
		const closingEllipsesNeeded = i === paginationRange - 1 && (isMiddle || isStart);
		if (ellipsesNeeded && (openingEllipsesNeeded || closingEllipsesNeeded)) {
			label = '...';
		} else {
			label = pageNumber;
		}
		pages.push(label);
		i++;
	}

	return pages;
}

/**
 * Given the position in the sequence of pagination links [i],
 * figure out what page number corresponds to that position.
 *
 * Copied from 'ngx-pagination' package
 */
function calculatePageNumber(i: number, currentPage: number, paginationRange: number, totalPages: number) {
	const halfWay = Math.ceil(paginationRange / 2);
	if (i === paginationRange) {
		return totalPages;
	}

	if (i === 1) {
		return i;
	}

	if (paginationRange < totalPages) {
		if (totalPages - halfWay < currentPage) {
			return totalPages - paginationRange + i;
		}
		if (halfWay < currentPage) {
			return currentPage - halfWay + i;
		}
		return i;
	}

	return i;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-pagination-content.directive.ts.template
```
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import { ClassValue } from 'clsx';

export const paginationContentVariants = cva('flex flex-row items-center gap-1', {
	variants: {},
	defaultVariants: {},
});
export type PaginationContentVariants = VariantProps<typeof paginationContentVariants>;

@Directive({
	selector: '[hlmPaginationContent]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmPaginationContentDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm(paginationContentVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-pagination-ellipsis.component.ts.template
```
import { Component, computed, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideEllipsis } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-pagination-ellipsis',
	imports: [NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideEllipsis })],
	template: `
		<span [class]="_computedClass()">
			<ng-icon hlm size="sm" name="lucideEllipsis" />
			<span class="sr-only">More pages</span>
		</span>
	`,
})
export class HlmPaginationEllipsisComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => hlm('flex h-9 w-9 items-center justify-center', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-pagination-item.directive.ts.template
```
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import { ClassValue } from 'clsx';

export const paginationItemVariants = cva('', {
	variants: {},
	defaultVariants: {},
});

export type PaginationItemVariants = VariantProps<typeof paginationItemVariants>;

@Directive({
	selector: '[hlmPaginationItem]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmPaginationItemDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => hlm(paginationItemVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-pagination-link.directive.ts.template
```
import { BooleanInput } from '@angular/cdk/coercion';
import { Directive, booleanAttribute, computed, input } from '@angular/core';
import { RouterLink } from '@angular/router';
import { hlm } from '@spartan-ng/brain/core';
import { type ButtonVariants, buttonVariants } from '@spartan-ng/ui-button-helm';
import { type VariantProps, cva } from 'class-variance-authority';
import { ClassValue } from 'clsx';

export const paginationLinkVariants = cva('', {
	variants: {},
	defaultVariants: {},
});
export type PaginationLinkVariants = VariantProps<typeof paginationLinkVariants>;

@Directive({
	selector: '[hlmPaginationLink]',
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
		'[attr.aria-current]': 'isActive() ? "page" : null',
	},
})
export class HlmPaginationLinkDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly isActive = input<boolean, BooleanInput>(false, { transform: booleanAttribute });
	public readonly size = input<ButtonVariants['size']>('icon');
	public readonly link = input<RouterLink['routerLink']>();

	protected readonly _computedClass = computed(() =>
		hlm(
			paginationLinkVariants(),
			this.link() === undefined ? 'cursor-pointer' : '',
			buttonVariants({
				variant: this.isActive() ? 'outline' : 'ghost',
				size: this.size(),
			}),
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-pagination-next.component.ts.template
```
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, Component, computed, input } from '@angular/core';
import { RouterLink } from '@angular/router';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronRight } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { ButtonVariants } from '@spartan-ng/ui-button-helm';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import { ClassValue } from 'clsx';
import { HlmPaginationLinkDirective } from './hlm-pagination-link.directive';

@Component({
	selector: 'hlm-pagination-next',
	imports: [HlmPaginationLinkDirective, NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideChevronRight })],
	template: `
		<a
			[class]="_computedClass()"
			hlmPaginationLink
			[link]="link()"
			[queryParams]="queryParams()"
			[queryParamsHandling]="queryParamsHandling()"
			[size]="size()"
			[attr.aria-label]="ariaLabel()"
		>
			<span [class.sr-only]="iconOnly()">{{ text() }}</span>
			<ng-icon hlm size="sm" name="lucideChevronRight" />
		</a>
	`,
})
export class HlmPaginationNextComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly link = input<RouterLink['routerLink']>();
	public readonly queryParams = input<RouterLink['queryParams']>();
	public readonly queryParamsHandling = input<RouterLink['queryParamsHandling']>();

	public readonly ariaLabel = input<string>('Go to next page', { alias: 'aria-label' });
	public readonly text = input<string>('Next');
	public readonly iconOnly = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	protected readonly size = computed<ButtonVariants['size']>(() => (this.iconOnly() ? 'icon' : 'default'));

	protected readonly _computedClass = computed(() => hlm('gap-1', !this.iconOnly() ? 'pr-2.5' : '', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-pagination-previous.component.ts.template
```
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, Component, computed, input } from '@angular/core';
import { RouterLink } from '@angular/router';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronLeft } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { ButtonVariants } from '@spartan-ng/ui-button-helm';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import { ClassValue } from 'clsx';
import { HlmPaginationLinkDirective } from './hlm-pagination-link.directive';

@Component({
	selector: 'hlm-pagination-previous',
	imports: [HlmPaginationLinkDirective, NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideChevronLeft })],
	template: `
		<a
			[class]="_computedClass()"
			hlmPaginationLink
			[link]="link()"
			[queryParams]="queryParams()"
			[queryParamsHandling]="queryParamsHandling()"
			[size]="size()"
			[attr.aria-label]="ariaLabel()"
		>
			<ng-icon hlm size="sm" name="lucideChevronLeft" />
			<span [class.sr-only]="iconOnly()">{{ text() }}</span>
		</a>
	`,
})
export class HlmPaginationPreviousComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly link = input<RouterLink['routerLink']>();
	public readonly queryParams = input<RouterLink['queryParams']>();
	public readonly queryParamsHandling = input<RouterLink['queryParamsHandling']>();

	public readonly ariaLabel = input<string>('Go to previous page', { alias: 'aria-label' });
	public readonly text = input<string>('Previous');
	public readonly iconOnly = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	protected readonly size = computed<ButtonVariants['size']>(() => (this.iconOnly() ? 'icon' : 'default'));

	protected readonly _computedClass = computed(() => hlm('gap-1', !this.iconOnly() ? 'pl-2.5' : '', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-pagination.directive.ts.template
```
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const paginationVariants = cva('mx-auto flex w-full justify-center', {
	variants: {},
	defaultVariants: {},
});
export type PaginationVariants = VariantProps<typeof paginationVariants>;

@Directive({
	selector: '[hlmPagination]',
	standalone: true,
	host: {
		role: 'navigation',
		'[class]': '_computedClass()',
		'[attr.aria-label]': 'ariaLabel()',
	},
})
export class HlmPaginationDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	public readonly ariaLabel = input<string>('pagination', { alias: 'aria-label' });

	protected readonly _computedClass = computed(() => hlm(paginationVariants(), this.userClass()));
}

```
