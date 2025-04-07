/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/README.md
```
# @radix-ng/primitives/pagination

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/index.ts
```typescript
import { NgModule } from '@angular/core';
import { RdxPaginationEllipsisDirective } from './src/pagination-ellipsis.directive';
import { RdxPaginationFirstDirective } from './src/pagination-first.directive';
import { RdxPaginationLastDirective } from './src/pagination-last.directive';
import { RdxPaginationListItemDirective } from './src/pagination-list-item.directive';
import { RdxPaginationListDirective } from './src/pagination-list.directive';
import { RdxPaginationNextDirective } from './src/pagination-next.directive';
import { RdxPaginationPrevDirective } from './src/pagination-prev.directive';
import { RdxPaginationRootDirective } from './src/pagination-root.directive';

export * from './src/pagination-context.token';
export * from './src/pagination-ellipsis.directive';
export * from './src/pagination-first.directive';
export * from './src/pagination-last.directive';
export * from './src/pagination-list-item.directive';
export * from './src/pagination-list.directive';
export * from './src/pagination-next.directive';
export * from './src/pagination-prev.directive';
export * from './src/pagination-root.directive';

const paginationImports = [
    RdxPaginationRootDirective,
    RdxPaginationListDirective,
    RdxPaginationFirstDirective,
    RdxPaginationPrevDirective,
    RdxPaginationLastDirective,
    RdxPaginationNextDirective,
    RdxPaginationListItemDirective,
    RdxPaginationEllipsisDirective
];

@NgModule({
    imports: [...paginationImports],
    exports: [...paginationImports]
})
export class RdxPaginationModule {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/src/pagination-context.token.ts
```typescript
import { computed, inject, InjectionToken, model } from '@angular/core';

export interface PaginationRootContext {
    page: ReturnType<typeof model<number>>;
    onPageChange: (value: number) => void;
    pageCount: ReturnType<typeof computed<number>>;
    siblingCount: ReturnType<typeof computed<number>>;
    disabled: ReturnType<typeof computed<boolean>>;
    showEdges: ReturnType<typeof computed<boolean>>;
}

export const PAGINATION_ROOT_CONTEXT = new InjectionToken<PaginationRootContext>('PaginationRootContext');

export function injectPaginationRootContext(): PaginationRootContext {
    return inject(PAGINATION_ROOT_CONTEXT);
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/src/pagination-ellipsis.directive.ts
```typescript
import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxPaginationEllipsis]',
    host: {
        '[attr.data-type]': '"ellipsis"'
    }
})
export class RdxPaginationEllipsisDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/src/pagination-first.directive.ts
```typescript
import { computed, Directive } from '@angular/core';
import { injectPaginationRootContext } from './pagination-context.token';

// as Button
@Directive({
    selector: '[rdxPaginationFirst]',
    host: {
        '[attr.aria-label]': '"First Page"',

        '[disabled]': 'disabled()',
        '(click)': 'onClick()'
    }
})
export class RdxPaginationFirstDirective {
    private readonly rootContext = injectPaginationRootContext();

    readonly disabled = computed(() => this.rootContext.page() === 1 || this.rootContext.disabled());

    onClick() {
        if (!this.disabled()) {
            this.rootContext.onPageChange(1);
        }
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/src/pagination-last.directive.ts
```typescript
import { computed, Directive } from '@angular/core';
import { injectPaginationRootContext } from './pagination-context.token';

// as Button
@Directive({
    selector: '[rdxPaginationLast]',
    host: {
        '[attr.aria-label]': '"Last Page"',

        '[disabled]': 'disabled()',
        '(click)': 'onClick()'
    }
})
export class RdxPaginationLastDirective {
    private readonly rootContext = injectPaginationRootContext();

    readonly disabled = computed(
        () => this.rootContext.page() === this.rootContext.pageCount() || this.rootContext.disabled()
    );

    onClick() {
        if (!this.disabled()) {
            this.rootContext.onPageChange(this.rootContext.pageCount());
        }
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/src/pagination-list-item.directive.ts
```typescript
import { computed, Directive, input } from '@angular/core';
import { injectPaginationRootContext } from './pagination-context.token';

// as Button
@Directive({
    selector: '[rdxPaginationListItem]',
    host: {
        '[data-type]': '"page"',

        '[attr.aria-label]': '"Page " + value()',
        '[attr.aria-current]': 'isSelected() ? "page" : undefined',
        '[attr.data-selected]': 'isSelected() ? true : undefined',

        '[disabled]': 'disabled()',
        '(click)': 'onClick()'
    }
})
export class RdxPaginationListItemDirective {
    private readonly rootContext = injectPaginationRootContext();

    readonly value = input<number>();

    readonly disabled = computed(() => this.rootContext.disabled());

    readonly isSelected = computed(() => this.rootContext.page() === this.value());

    onClick() {
        const pageValue = this.value();
        if (!this.disabled() && typeof pageValue === 'number') {
            this.rootContext.onPageChange(pageValue);
        }
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/src/pagination-list.directive.ts
```typescript
import { computed, Directive } from '@angular/core';
import { injectPaginationRootContext } from './pagination-context.token';
import { getRange, transform } from './utils';

@Directive({
    selector: '[rdxPaginationList]',
    exportAs: 'rdxPaginationList'
})
export class RdxPaginationListDirective {
    private readonly rootContext = injectPaginationRootContext();

    readonly transformedRange = computed(() => {
        return transform(
            getRange(
                this.rootContext.page(),
                this.rootContext.pageCount(),
                this.rootContext.siblingCount(),
                this.rootContext.showEdges()
            )
        );
    });
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/src/pagination-next.directive.ts
```typescript
import { computed, Directive } from '@angular/core';
import { injectPaginationRootContext } from './pagination-context.token';

// as Button
@Directive({
    selector: '[rdxPaginationNext]',
    host: {
        '[attr.aria-label]': '"Next Page"',

        '[disabled]': 'disabled()',
        '(click)': 'onClick()'
    }
})
export class RdxPaginationNextDirective {
    private readonly rootContext = injectPaginationRootContext();

    readonly disabled = computed(
        () => this.rootContext.page() === this.rootContext.pageCount() || this.rootContext.disabled()
    );

    onClick() {
        if (!this.disabled()) {
            this.rootContext.onPageChange(this.rootContext.page() + 1);
        }
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/src/pagination-prev.directive.ts
```typescript
import { computed, Directive } from '@angular/core';
import { injectPaginationRootContext } from './pagination-context.token';

// as Button
@Directive({
    selector: '[rdxPaginationPrev]',
    host: {
        '[attr.aria-label]': '"Previous Page"',

        '[disabled]': 'disabled()',
        '(click)': 'onClick()'
    }
})
export class RdxPaginationPrevDirective {
    private readonly rootContext = injectPaginationRootContext();

    readonly disabled = computed(() => this.rootContext.page() === 1 || this.rootContext.disabled());

    onClick() {
        if (!this.disabled()) {
            this.rootContext.onPageChange(this.rootContext.page() - 1);
        }
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/src/pagination-root.directive.ts
```typescript
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import {
    booleanAttribute,
    computed,
    Directive,
    forwardRef,
    input,
    model,
    numberAttribute,
    output
} from '@angular/core';
import { PAGINATION_ROOT_CONTEXT } from './pagination-context.token';

@Directive({
    selector: '[rdxPaginationRoot]',
    exportAs: 'rdxPaginationRoot',
    providers: [
        { provide: PAGINATION_ROOT_CONTEXT, useExisting: forwardRef(() => RdxPaginationRootDirective) }]
})
export class RdxPaginationRootDirective {
    readonly defaultPage = input<number, NumberInput>(1, { transform: numberAttribute });

    readonly page = model<number>(this.defaultPage());

    readonly itemsPerPage = input<number, NumberInput>(undefined, { transform: numberAttribute });

    readonly total = input<number, NumberInput>(0, { transform: numberAttribute });

    readonly siblingCount = input<number, NumberInput>(2, { transform: numberAttribute });

    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    readonly showEdges = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    readonly updatePage = output<number>();

    /** @ignore */
    readonly pageCount = computed(() => Math.max(1, Math.ceil(this.total() / (this.itemsPerPage() || 1))));

    /** @ignore */
    onPageChange(value: number) {
        if (!this.disabled()) {
            this.page.set(value);
            this.updatePage.emit(value);
        }
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/src/utils.ts
```typescript
// reference https://github.com/chakra-ui/zag/blob/main/packages/machines/pagination/src/pagination.utils.ts

type Pages = Array<{ type: 'ellipsis' } | { type: 'page'; value: number }>;

function range(start: number, end: number) {
    const length = end - start + 1;
    return Array.from({ length }, (_, idx) => idx + start);
}

export function transform(items: (string | number)[]): Pages {
    return items.map((value) => {
        if (typeof value === 'number') return { type: 'page', value };
        return { type: 'ellipsis' };
    });
}

const ELLIPSIS = 'ellipsis';

export function getRange(currentPage: number, pageCount: number, siblingCount: number, showEdges: boolean) {
    const firstPageIndex = 1;
    const lastPageIndex = pageCount;

    const leftSiblingIndex = Math.max(currentPage - siblingCount, firstPageIndex);
    const rightSiblingIndex = Math.min(currentPage + siblingCount, lastPageIndex);

    if (showEdges) {
        /**
         * `2 * siblingCount + 5` explanation:
         * 2 * siblingCount for left/right siblings
         * 5 for 2x left/right ellipsis, 2x first/last page + 1x current page
         *
         * For some page counts (e.g. totalPages: 8, siblingCount: 2),
         * calculated max page is higher than total pages,
         * so we need to take the minimum of both.
         */
        const totalPageNumbers = Math.min(2 * siblingCount + 5, pageCount);

        const itemCount = totalPageNumbers - 2; // 2 stands for one ellipsis and either first or last page

        const showLeftEllipsis =
            // default condition
            leftSiblingIndex > firstPageIndex + 2 &&
            // if the current page is towards the end of the list
            Math.abs(lastPageIndex - itemCount - firstPageIndex + 1) > 2 &&
            // if the current page is towards the middle of the list
            Math.abs(leftSiblingIndex - firstPageIndex) > 2;

        const showRightEllipsis =
            // default condition
            rightSiblingIndex < lastPageIndex - 2 &&
            // if the current page is towards the start of the list
            Math.abs(lastPageIndex - itemCount) > 2 &&
            // if the current page is towards the middle of the list
            Math.abs(lastPageIndex - rightSiblingIndex) > 2;

        if (!showLeftEllipsis && showRightEllipsis) {
            const leftRange = range(1, itemCount);

            return [...leftRange, ELLIPSIS, lastPageIndex];
        }

        if (showLeftEllipsis && !showRightEllipsis) {
            const rightRange = range(lastPageIndex - itemCount + 1, lastPageIndex);

            return [firstPageIndex, ELLIPSIS, ...rightRange];
        }

        if (showLeftEllipsis && showRightEllipsis) {
            const middleRange = range(leftSiblingIndex, rightSiblingIndex);

            return [firstPageIndex, ELLIPSIS, ...middleRange, ELLIPSIS, lastPageIndex];
        }

        const fullRange = range(firstPageIndex, lastPageIndex);
        return fullRange;
    } else {
        const itemCount = siblingCount * 2 + 1;

        if (pageCount < itemCount) return range(1, lastPageIndex);
        else if (currentPage <= siblingCount + 1) return range(firstPageIndex, itemCount);
        else if (pageCount - currentPage <= siblingCount) return range(pageCount - itemCount + 1, lastPageIndex);
        else return range(leftSiblingIndex, rightSiblingIndex);
    }
}

```
