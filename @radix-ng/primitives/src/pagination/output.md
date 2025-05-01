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
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/stories/pagination.docs.mdx
````
import { ArgTypes, Canvas, Markdown, Meta } from '@storybook/blocks';
import * as Stories from './pagination.stories';
import {RdxPaginationRootDirective} from "../src/pagination-root.directive";

<Meta title="Primitives/Pagination" />

# Pagination

####  Displays data in paged format and provides navigation between pages.

<Canvas sourceState="hidden" of={Stories.WithEllipsis} />

## Features

- ✅ Enable quick access to first, or last page.
- ✅ Enable to show edges constantly, or not.

## Import

Get started with importing the directives:

```typescript
import { RdxPaginationModule } from '@radix-ng/primitives/pagination';
```

## Anatomy

```html
<div rdxPaginationRoot>
    <div rdxPaginationList #list="rdxPaginationList">
        <button rdxPaginationFirst></button>
        <button rdxPaginationPrev></button>

        @for (item of list.transformedRange(); track item) {
            <button rdxPaginationListItem [value]="item.value">{{ item.value }}</button>
        }

        <button rdxPaginationNext></button>
        <button rdxPaginationLast></button>
    </div>
</div>
```

## API Reference

### Root

`RdxPaginationRootDirective`

<ArgTypes of={RdxPaginationRootDirective} />

### List

`RdxPaginationListDirective`

Used to show the list of pages. It also makes pagination accessible to assistive technologies.

### Item

`RdxPaginationListItemDirective`

Used to render the button that changes the current page.

<Markdown>
    {`
  | Data Attribute     | Value |
  | ------------------ | -------------------------- |
  | [data-selected]    | "true" or ""   |
  | [data-type]        | "page"        |
  `}
</Markdown>

### Ellipsis

`RdxPaginationEllipsisDirective`

Placeholder element when the list is long, and only a small amount of `siblingCount` was set and `showEdges` was set to `true`.

<Markdown>
    {`
  | Data Attribute     | Value |
  | ------------------ | -------------------------- |
  | [data-type]        | "ellipsis"        |
  `}
</Markdown>

## Accessibility

### Keyboard Interactions

<Markdown>
  {`
  | Key | Description |
  | ----------- | --------- |
  | Tab         | Moves focus to the next focusable element.  |
  | Space       | When focus is on a any trigger, trigger selected page or arrow navigation.    |
  | Enter       | When focus is on a any trigger, trigger selected page or arrow navigation.  |
  `}
</Markdown>

## Examples

### With ellipsis

You can add `rdxPaginationEllipsis` as a visual cue for more previous and after items.

```html
<div rdxPaginationRoot>
    <div rdxPaginationList #list="rdxPaginationList">

        @for (item of list.transformedRange(); track item) {
            @if (item.type == 'page') {
                <button rdxPaginationListItem [value]="item.value">{{ item.value }}</button>
            } @else {
                <div rdxPaginationEllipsis>&#8230;</div>
            }
        }

    </div>
</div>
```

### With first/last button

You can add `rdxPaginationFirst` to allow user to navigate to first page, or `rdxPaginationLast` to navigate to last page.

```html
<div rdxPaginationRoot>
    <div rdxPaginationList #list="rdxPaginationList">
        <button rdxPaginationFirst></button>
        ...
        <button rdxPaginationLast></button>
    </div>
</div>
```

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/pagination/stories/pagination.stories.ts
```typescript
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { ChevronLeft, ChevronRight, ChevronsLeft, ChevronsRight, LucideAngularModule } from 'lucide-angular';
import { RdxPaginationEllipsisDirective } from '../src/pagination-ellipsis.directive';
import { RdxPaginationFirstDirective } from '../src/pagination-first.directive';
import { RdxPaginationLastDirective } from '../src/pagination-last.directive';
import { RdxPaginationListItemDirective } from '../src/pagination-list-item.directive';
import { RdxPaginationListDirective } from '../src/pagination-list.directive';
import { RdxPaginationNextDirective } from '../src/pagination-next.directive';
import { RdxPaginationPrevDirective } from '../src/pagination-prev.directive';
import { RdxPaginationRootDirective } from '../src/pagination-root.directive';

const html = String.raw;

export default {
    title: 'Primitives/Pagination',
    decorators: [
        moduleMetadata({
            imports: [
                RdxPaginationRootDirective,
                RdxPaginationListDirective,
                RdxPaginationFirstDirective,
                RdxPaginationPrevDirective,
                RdxPaginationLastDirective,
                RdxPaginationNextDirective,
                RdxPaginationListItemDirective,
                RdxPaginationEllipsisDirective,
                LucideAngularModule,
                LucideAngularModule.pick({ ChevronLeft, ChevronRight, ChevronsRight, ChevronsLeft })
            ]
        }),
        componentWrapperDecorator(
            (story) => html`
                <div class="radix-themes light light-theme" data-radius="medium" data-scaling="100%">
                    ${story}

                    <style>
                        button {
                            all: unset;
                        }

                        .Button {
                            text-align: center;
                            font-size: 15px;
                            line-height: 1;
                            align-items: center;
                            justify-content: center;
                            height: 2.25rem;
                            width: 2.25rem;
                            border-radius: 0.25rem;
                            transition: all 150ms cubic-bezier(0.4, 0, 0.2, 1);
                            cursor: pointer;
                        }

                        .Button:disabled {
                            opacity: 0.5;
                        }

                        .Button:hover {
                            background-color: rgb(255 255 255 / 0.1);
                        }

                        .Button[data-selected] {
                            background-color: rgb(255 255 255);
                            color: var(--black-a11);
                        }

                        .PaginationList {
                            display: flex;
                            align-items: center;
                            gap: 0.25rem;
                            color: rgb(255 255 255);
                        }

                        .PaginationEllipsis {
                            display: flex;
                            height: 2.25rem;
                            width: 2.25rem;
                            align-items: center;
                            justify-content: center;
                        }
                    </style>
                </div>
            `
        )
    ]
} as Meta;

type Story = StoryObj;

export const Default: Story = {
    render: () => ({
        template: `
            <div rdxPaginationRoot total="34" siblingCount="1" itemsPerPage="10">
                <div class="PaginationList" rdxPaginationList #list="rdxPaginationList">
                    <button class="Button" rdxPaginationFirst>
                        <lucide-icon name="chevrons-left" size="16" strokeWidth="2" />
                    </button>
                    <button class="Button" rdxPaginationPrev style="margin-right: 16px;">
                        <lucide-icon name="chevron-left" size="16" strokeWidth="2" />
                    </button>

                    @for (item of list.transformedRange(); track item) {
                        <button class="Button" rdxPaginationListItem [value]="item.value">{{ item.value }}</button>
                    }

                    <button class="Button" rdxPaginationNext style="margin-left: 16px;">
                        <lucide-icon name="chevron-right" size="16" strokeWidth="2" />
                    </button>
                    <button class="Button" rdxPaginationLast>
                        <lucide-icon name="chevrons-right" size="16" strokeWidth="2" />
                    </button>
                </div>
            </div>
        `
    })
};

export const WithEllipsis: Story = {
    render: () => ({
        template: `
            <div rdxPaginationRoot total="100" siblingCount="1" defaultPage="2" showEdges itemsPerPage="10">
                <div class="PaginationList" rdxPaginationList #list="rdxPaginationList">
                    <button class="Button" rdxPaginationFirst>
                        <lucide-icon name="chevrons-left" size="16" strokeWidth="2" />
                    </button>
                    <button class="Button" rdxPaginationPrev style="margin-right: 16px;">
                        <lucide-icon name="chevron-left" size="16" strokeWidth="2" />
                    </button>

                    @for (item of list.transformedRange(); track item) {
                        @if (item.type == 'page') {
                            <button class="Button" rdxPaginationListItem [value]="item.value">{{ item.value }}</button>
                        } @else {
                            <div class="PaginationEllipsis" rdxPaginationEllipsis>&#8230;</div>
                        }
                    }

                    <button class="Button" rdxPaginationNext style="margin-left: 16px;">
                        <lucide-icon name="chevron-right" size="16" strokeWidth="2" />
                    </button>
                    <button class="Button" rdxPaginationLast>
                        <lucide-icon name="chevrons-right" size="16" strokeWidth="2" />
                    </button>
                </div>
            </div>
        `
    })
};

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
