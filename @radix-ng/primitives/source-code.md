# ./tabs/index.ts

import { NgModule } from '@angular/core';
import { RdxTabsContentDirective } from './src/tabs-content.directive';
import { RdxTabsListDirective } from './src/tabs-list.directive';
import { RdxTabsRootDirective } from './src/tabs-root.directive';
import { RdxTabsTriggerDirective } from './src/tabs-trigger.directive';

export * from './src/tabs-content.directive';
export * from './src/tabs-list.directive';
export * from './src/tabs-root.directive';
export * from './src/tabs-trigger.directive';

const tabsImports = [
    RdxTabsRootDirective,
    RdxTabsContentDirective,
    RdxTabsListDirective,
    RdxTabsTriggerDirective
];

@NgModule({
    imports: [...tabsImports],
    exports: [...tabsImports]
})
export class RdxTabsModule {}



# ./tabs/src/tabs-root.directive.ts

import { Directive, InjectionToken, input, model, OnInit, output } from '@angular/core';

export interface TabsProps {
    /** The value for the selected tab, if controlled */
    value?: string;
    /** The value of the tab to select by default, if uncontrolled */
    defaultValue?: string;
    /** A function called when a new tab is selected */
    onValueChange?: (value: string) => void;
    /**
     * The orientation the tabs are layed out.
     * Mainly so arrow navigation is done accordingly (left & right vs. up & down)
     * @defaultValue horizontal
     */
    orientation?: string;
    /**
     * The direction of navigation between toolbar items.
     */
    dir?: string;
    /**
     * Whether a tab is activated automatically or manually.
     * @defaultValue automatic
     * */
    activationMode?: 'automatic' | 'manual';
}

export type DataOrientation = 'vertical' | 'horizontal';

export const RDX_TABS_ROOT_TOKEN = new InjectionToken<RdxTabsRootDirective>('RdxTabsRootDirective');

@Directive({
    selector: '[rdxTabsRoot]',
    standalone: true,
    providers: [
        { provide: RDX_TABS_ROOT_TOKEN, useExisting: RdxTabsRootDirective }],
    host: {
        '[attr.data-orientation]': 'orientation()',
        '[attr.dir]': 'dir()'
    }
})
export class RdxTabsRootDirective implements OnInit {
    /**
     * The controlled value of the tab to activate. Should be used in conjunction with `onValueChange`.
     */
    readonly value = model<string>();

    readonly defaultValue = input<string>();

    /**
     * When automatic, tabs are activated when receiving focus. When manual, tabs are activated when clicked.
     */
    readonly activationMode = input<'automatic' | 'manual'>('automatic');

    /**
     * The orientation of the component.
     */
    readonly orientation = input<DataOrientation>('horizontal');

    readonly dir = input<string>('ltr');

    /**
     * Event handler called when the value changes.
     */
    readonly onValueChange = output<string>();

    ngOnInit() {
        if (this.defaultValue()) {
            this.value.set(this.defaultValue());
        }
    }

    select(value: string) {
        this.value.set(value);
        this.onValueChange.emit(value);
    }

    /** @ignore */
    getBaseId() {
        return `tabs-${Math.random().toString(36).substr(2, 9)}`;
    }
}



# ./tabs/src/utils.ts

export function makeTriggerId(baseId: string, value: string | number) {
    return `${baseId}-trigger-${value}`;
}

export function makeContentId(baseId: string, value: string | number) {
    return `${baseId}-content-${value}`;
}



# ./tabs/src/tabs-list.directive.ts

import { Directive, inject } from '@angular/core';
import { RdxRovingFocusGroupDirective } from '@radix-ng/primitives/roving-focus';
import { RDX_TABS_ROOT_TOKEN } from './tabs-root.directive';

export interface TabsListProps {
    // When true, keyboard navigation will loop from last tab to first, and vice versa.
    loop?: boolean;
}

@Directive({
    selector: '[rdxTabsList]',
    standalone: true,
    hostDirectives: [{ directive: RdxRovingFocusGroupDirective, inputs: ['dir', 'orientation', 'loop'] }],
    host: {
        role: 'tablist',
        '[attr.aria-orientation]': 'tabsContext.orientation()',
        '[attr.data-orientation]': 'tabsContext.orientation()'
    }
})
export class RdxTabsListDirective {
    protected readonly tabsContext = inject(RDX_TABS_ROOT_TOKEN);
}



# ./tabs/src/tabs-content.directive.ts

import { computed, Directive, inject, input } from '@angular/core';
import { RDX_TABS_ROOT_TOKEN } from './tabs-root.directive';
import { makeContentId, makeTriggerId } from './utils';

@Directive({
    selector: '[rdxTabsContent]',
    standalone: true,
    host: {
        role: 'tabpanel',
        tabindex: '0',
        '[id]': 'contentId()',
        '[attr.aria-labelledby]': 'triggerId()',
        '[attr.data-state]': 'selected() ? "active" : "inactive"',
        '[attr.data-orientation]': 'tabsContext.orientation()',
        '[hidden]': '!selected()'
    }
})
export class RdxTabsContentDirective {
    protected readonly tabsContext = inject(RDX_TABS_ROOT_TOKEN);

    /**
     * A unique value that associates the content with a trigger.
     */
    readonly value = input.required<string>();

    protected readonly contentId = computed(() => makeContentId(this.tabsContext.getBaseId(), this.value()));
    protected readonly triggerId = computed(() => makeTriggerId(this.tabsContext.getBaseId(), this.value()));

    protected readonly selected = computed(() => this.tabsContext.value() === this.value());
}



# ./tabs/src/tabs-trigger.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, computed, Directive, effect, inject, input, InputSignalWithTransform } from '@angular/core';
import { RdxRovingFocusItemDirective } from '@radix-ng/primitives/roving-focus';
import { RDX_TABS_ROOT_TOKEN } from './tabs-root.directive';
import { makeContentId, makeTriggerId } from './utils';

interface TabsTriggerProps {
    // When true, prevents the user from interacting with the tab.
    disabled: InputSignalWithTransform<boolean, BooleanInput>;
}

@Directive({
    selector: '[rdxTabsTrigger]',
    standalone: true,
    hostDirectives: [
        {
            directive: RdxRovingFocusItemDirective,
            inputs: ['focusable', 'active', 'allowShiftKey']
        }
    ],

    host: {
        type: 'button',
        role: 'tab',
        '[id]': 'triggerId()',
        '[attr.aria-selected]': 'isSelected()',
        '[attr.aria-controls]': 'contentId()',
        '[attr.data-disabled]': "disabled() ? '' : undefined",
        '[disabled]': 'disabled()',
        '[attr.data-state]': "isSelected() ? 'active' : 'inactive'",
        '[attr.data-orientation]': 'tabsContext.orientation()',
        '(mousedown)': 'onMouseDown($event)',
        '(keydown)': 'onKeyDown($event)',
        '(focus)': 'onFocus()'
    }
})
export class RdxTabsTriggerDirective implements TabsTriggerProps {
    private readonly rdxRovingFocusItemDirective = inject(RdxRovingFocusItemDirective);

    protected readonly tabsContext = inject(RDX_TABS_ROOT_TOKEN);

    /**
     * A unique value that associates the trigger with a content.
     */
    readonly value = input.required<string>();

    /**
     * When true, prevents the user from interacting with the tab.
     */
    readonly disabled = input<boolean, BooleanInput>(false, {
        transform: booleanAttribute
    });

    protected readonly contentId = computed(() => makeContentId(this.tabsContext.getBaseId(), this.value()));
    protected readonly triggerId = computed(() => makeTriggerId(this.tabsContext.getBaseId(), this.value()));

    protected readonly isSelected = computed(() => this.tabsContext.value() === this.value());

    constructor() {
        effect(() => (this.rdxRovingFocusItemDirective.active = this.isSelected()));
    }

    protected onMouseDown(event: MouseEvent) {
        // only call handler if it's the left button (mousedown gets triggered by all mouse buttons)
        // but not when the control key is pressed (avoiding MacOS right click)
        if (!this.disabled() && event.button === 0 && !event.ctrlKey) {
            this.tabsContext?.select(this.value());
        } else {
            // prevent focus to avoid accidental activation
            event.preventDefault();
        }
    }

    protected onKeyDown(event: KeyboardEvent) {
        if ([' ', 'Enter'].includes(event.key)) {
            this.tabsContext?.select(this.value());
        }
    }

    protected onFocus() {
        const isAutomaticActivation = this.tabsContext.activationMode() !== 'manual';
        if (!this.isSelected() && !this.disabled() && isAutomaticActivation) {
            this.tabsContext?.select(this.value());
        }
    }
}



# ./pagination/README.md

# @radix-ng/primitives/pagination



# ./pagination/index.ts

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



# ./pagination/src/pagination-list.directive.ts

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



# ./pagination/src/pagination-last.directive.ts

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



# ./pagination/src/pagination-next.directive.ts

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



# ./pagination/src/pagination-prev.directive.ts

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



# ./pagination/src/utils.ts

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



# ./pagination/src/pagination-context.token.ts

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



# ./pagination/src/pagination-list-item.directive.ts

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



# ./pagination/src/pagination-first.directive.ts

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



# ./pagination/src/pagination-root.directive.ts

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



# ./pagination/src/pagination-ellipsis.directive.ts

import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxPaginationEllipsis]',
    host: {
        '[attr.data-type]': '"ellipsis"'
    }
})
export class RdxPaginationEllipsisDirective {}



# ./tooltip/README.md

# @radix-ng/primitives/tooltip

Secondary entry point of `@radix-ng/primitives`. It can be used by importing from `@radix-ng/primitives/tooltip`.



# ./tooltip/index.ts

import { NgModule } from '@angular/core';
import { RdxTooltipAnchorDirective } from './src/tooltip-anchor.directive';
import { RdxTooltipArrowDirective } from './src/tooltip-arrow.directive';
import { RdxTooltipCloseDirective } from './src/tooltip-close.directive';
import { RdxTooltipContentAttributesComponent } from './src/tooltip-content-attributes.component';
import { RdxTooltipContentDirective } from './src/tooltip-content.directive';
import { RdxTooltipRootDirective } from './src/tooltip-root.directive';
import { RdxTooltipTriggerDirective } from './src/tooltip-trigger.directive';

export * from './src/tooltip-anchor.directive';
export * from './src/tooltip-arrow.directive';
export * from './src/tooltip-close.directive';
export * from './src/tooltip-content-attributes.component';
export * from './src/tooltip-content.directive';
export * from './src/tooltip-root.directive';
export * from './src/tooltip-trigger.directive';

const _imports = [
    RdxTooltipArrowDirective,
    RdxTooltipCloseDirective,
    RdxTooltipContentDirective,
    RdxTooltipTriggerDirective,
    RdxTooltipRootDirective,
    RdxTooltipAnchorDirective,
    RdxTooltipContentAttributesComponent
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxTooltipModule {}



# ./tooltip/src/tooltip-anchor.directive.ts

import { CdkOverlayOrigin } from '@angular/cdk/overlay';
import { computed, Directive, ElementRef, forwardRef, inject } from '@angular/core';
import { injectDocument } from '@radix-ng/primitives/core';
import { RdxTooltipAnchorToken } from './tooltip-anchor.token';
import { RdxTooltipRootDirective } from './tooltip-root.directive';
import { injectTooltipRoot } from './tooltip-root.inject';

@Directive({
    selector: '[rdxTooltipAnchor]',
    exportAs: 'rdxTooltipAnchor',
    hostDirectives: [CdkOverlayOrigin],
    host: {
        type: 'button',
        '[attr.id]': 'name()',
        '[attr.aria-haspopup]': '"dialog"',
        '(click)': 'click()'
    },
    providers: [
        {
            provide: RdxTooltipAnchorToken,
            useExisting: forwardRef(() => RdxTooltipAnchorDirective)
        }
    ]
})
export class RdxTooltipAnchorDirective {
    /**
     * @ignore
     * If outside the rootDirective then null, otherwise the rootDirective directive - with optional `true` passed in as the first param.
     * If outside the rootDirective and non-null value that means the html structure is wrong - tooltip inside tooltip.
     * */
    protected rootDirective = injectTooltipRoot(true);
    /** @ignore */
    readonly elementRef = inject(ElementRef);
    /** @ignore */
    readonly overlayOrigin = inject(CdkOverlayOrigin);
    /** @ignore */
    readonly document = injectDocument();

    /** @ignore */
    readonly name = computed(() => `rdx-tooltip-external-anchor-${this.rootDirective?.uniqueId()}`);

    /** @ignore */
    click(): void {
        this.emitOutsideClick();
    }

    /** @ignore */
    setRoot(root: RdxTooltipRootDirective) {
        this.rootDirective = root;
    }

    private emitOutsideClick() {
        if (!this.rootDirective?.isOpen() || this.rootDirective?.contentDirective().onOverlayOutsideClickDisabled()) {
            return;
        }
        const clickEvent = new MouseEvent('click', {
            view: this.document.defaultView,
            bubbles: true,
            cancelable: true,
            relatedTarget: this.elementRef.nativeElement
        });
        this.rootDirective?.triggerDirective().elementRef.nativeElement.dispatchEvent(clickEvent);
    }
}



# ./tooltip/src/tooltip-close.directive.ts

import { Directive, effect, ElementRef, forwardRef, inject, Renderer2, untracked } from '@angular/core';
import { RdxTooltipCloseToken } from './tooltip-close.token';
import { injectTooltipRoot } from './tooltip-root.inject';

/**
 * TODO: to be removed? But it seems to be useful when controlled from outside
 */
@Directive({
    selector: '[rdxTooltipClose]',
    host: {
        type: 'button',
        '(click)': 'rootDirective.handleClose(true)'
    },
    providers: [
        {
            provide: RdxTooltipCloseToken,
            useExisting: forwardRef(() => RdxTooltipCloseDirective)
        }
    ]
})
export class RdxTooltipCloseDirective {
    /** @ignore */
    protected readonly rootDirective = injectTooltipRoot();
    /** @ignore */
    readonly elementRef = inject(ElementRef);
    /** @ignore */
    private readonly renderer = inject(Renderer2);

    constructor() {
        this.onIsControlledExternallyEffect();
    }

    /** @ignore */
    private onIsControlledExternallyEffect() {
        effect(() => {
            const isControlledExternally = this.rootDirective.controlledExternally()();

            untracked(() => {
                this.renderer.setStyle(
                    this.elementRef.nativeElement,
                    'display',
                    isControlledExternally ? null : 'none'
                );
            });
        });
    }
}



# ./tooltip/src/tooltip-root.inject.ts

import { assertInInjectionContext, inject, isDevMode } from '@angular/core';
import { RdxTooltipRootDirective } from './tooltip-root.directive';

export function injectTooltipRoot(optional?: false): RdxTooltipRootDirective;
export function injectTooltipRoot(optional: true): RdxTooltipRootDirective | null;
export function injectTooltipRoot(optional = false): RdxTooltipRootDirective | null {
    isDevMode() && assertInInjectionContext(injectTooltipRoot);
    return inject(RdxTooltipRootDirective, { optional });
}



# ./tooltip/src/utils/cdk-event.service.ts

import {
    DestroyRef,
    EnvironmentProviders,
    inject,
    Injectable,
    InjectionToken,
    isDevMode,
    makeEnvironmentProviders,
    NgZone,
    Provider,
    Renderer2,
    VERSION
} from '@angular/core';
import { injectDocument, injectWindow } from '@radix-ng/primitives/core';
import { RdxCdkEventServiceWindowKey } from './constants';
import { EventType, EventTypeAsPrimitiveConfigKey, PrimitiveConfig, PrimitiveConfigs } from './types';

function eventTypeAsPrimitiveConfigKey(eventType: EventType): EventTypeAsPrimitiveConfigKey {
    return `prevent${eventType[0].toUpperCase()}${eventType.slice(1)}` as EventTypeAsPrimitiveConfigKey;
}

@Injectable()
class RdxCdkEventService {
    document = injectDocument();
    destroyRef = inject(DestroyRef);
    ngZone = inject(NgZone);
    renderer2 = inject(Renderer2);
    window = injectWindow();

    primitiveConfigs?: PrimitiveConfigs;

    onDestroyCallbacks: Set<() => void> = new Set([() => deleteRdxCdkEventServiceWindowKey(this.window)]);

    #clickDomRootEventCallbacks: Set<(event: MouseEvent) => void> = new Set();

    constructor() {
        this.#listenToClickDomRootEvent();
        this.#registerOnDestroyCallbacks();
    }

    registerPrimitive<T extends object>(primitiveInstance: T) {
        if (!this.primitiveConfigs) {
            this.primitiveConfigs = new Map();
        }
        if (!this.primitiveConfigs.has(primitiveInstance)) {
            this.primitiveConfigs.set(primitiveInstance, {});
        }
    }

    deregisterPrimitive<T extends object>(primitiveInstance: T) {
        if (this.primitiveConfigs?.has(primitiveInstance)) {
            this.primitiveConfigs.delete(primitiveInstance);
        }
    }

    preventPrimitiveFromCdkEvent<T extends object>(primitiveInstance: T, eventType: EventType) {
        this.#setPreventPrimitiveFromCdkEvent(primitiveInstance, eventType, true);
    }

    allowPrimitiveForCdkEvent<T extends object>(primitiveInstance: T, eventType: EventType) {
        this.#setPreventPrimitiveFromCdkEvent(primitiveInstance, eventType, false);
    }

    preventPrimitiveFromCdkMultiEvents<T extends object>(primitiveInstance: T, eventTypes: EventType[]) {
        eventTypes.forEach((eventType) => {
            this.#setPreventPrimitiveFromCdkEvent(primitiveInstance, eventType, true);
        });
    }

    allowPrimitiveForCdkMultiEvents<T extends object>(primitiveInstance: T, eventTypes: EventType[]) {
        eventTypes.forEach((eventType) => {
            this.#setPreventPrimitiveFromCdkEvent(primitiveInstance, eventType, false);
        });
    }

    setPreventPrimitiveFromCdkMixEvents<T extends object>(primitiveInstance: T, eventTypes: PrimitiveConfig) {
        Object.keys(eventTypes).forEach((eventType) => {
            this.#setPreventPrimitiveFromCdkEvent(
                primitiveInstance,
                eventType as EventType,
                eventTypes[eventTypeAsPrimitiveConfigKey(eventType as EventType)]
            );
        });
    }

    primitivePreventedFromCdkEvent<T extends object>(primitiveInstance: T, eventType: EventType) {
        return this.primitiveConfigs?.get(primitiveInstance)?.[eventTypeAsPrimitiveConfigKey(eventType)];
    }

    addClickDomRootEventCallback(callback: (event: MouseEvent) => void) {
        this.#clickDomRootEventCallbacks.add(callback);
    }

    removeClickDomRootEventCallback(callback: (event: MouseEvent) => void) {
        return this.#clickDomRootEventCallbacks.delete(callback);
    }

    #setPreventPrimitiveFromCdkEvent<
        T extends object,
        R extends EventType,
        K extends PrimitiveConfig[EventTypeAsPrimitiveConfigKey<R>]
    >(primitiveInstance: T, eventType: R, value: K) {
        if (!this.primitiveConfigs?.has(primitiveInstance)) {
            isDevMode() &&
                console.error(
                    '[RdxCdkEventService.preventPrimitiveFromCdkEvent] RDX Primitive instance has not been registered!',
                    primitiveInstance
                );
            return;
        }
        switch (eventType) {
            case 'cdkOverlayOutsideClick':
                this.primitiveConfigs.get(primitiveInstance)!.preventCdkOverlayOutsideClick = value;
                break;
            case 'cdkOverlayEscapeKeyDown':
                this.primitiveConfigs.get(primitiveInstance)!.preventCdkOverlayEscapeKeyDown = value;
                break;
        }
    }

    #registerOnDestroyCallbacks() {
        this.destroyRef.onDestroy(() => {
            this.onDestroyCallbacks.forEach((onDestroyCallback) => onDestroyCallback());
            this.onDestroyCallbacks.clear();
        });
    }

    #listenToClickDomRootEvent() {
        const target = this.document;
        const eventName = 'click';
        const options: boolean | AddEventListenerOptions | undefined = { capture: true };
        const callback = (event: MouseEvent) => {
            this.#clickDomRootEventCallbacks.forEach((clickDomRootEventCallback) => clickDomRootEventCallback(event));
        };

        const major = parseInt(VERSION.major);
        const minor = parseInt(VERSION.minor);

        let destroyClickDomRootEventListener!: () => void;
        /**
         * @see src/cdk/platform/features/backwards-compatibility.ts in @angular/cdk
         */
        if (major > 19 || (major === 19 && minor > 0) || (major === 0 && minor === 0)) {
            destroyClickDomRootEventListener = this.ngZone.runOutsideAngular(() => {
                const destroyClickDomRootEventListenerInternal = this.renderer2.listen(
                    target,
                    eventName,
                    callback,

                    options
                );
                return () => {
                    destroyClickDomRootEventListenerInternal();
                    this.#clickDomRootEventCallbacks.clear();
                };
            });
        } else {
            /**
             * This part can get removed when v19.1 or higher is on the board
             */
            destroyClickDomRootEventListener = this.ngZone.runOutsideAngular(() => {
                target.addEventListener(eventName, callback, options);
                return () => {
                    this.ngZone.runOutsideAngular(() => target.removeEventListener(eventName, callback, options));
                    this.#clickDomRootEventCallbacks.clear();
                };
            });
        }
        this.onDestroyCallbacks.add(destroyClickDomRootEventListener);
    }
}

const RdxCdkEventServiceToken = new InjectionToken<RdxCdkEventService>('RdxCdkEventServiceToken');

const existsErrorMessage = 'RdxCdkEventService should be provided only once!';

const deleteRdxCdkEventServiceWindowKey = (window: Window & typeof globalThis) => {
    delete (window as any)[RdxCdkEventServiceWindowKey];
};

const getProvider: (throwWhenExists?: boolean) => Provider = (throwWhenExists = true) => ({
    provide: RdxCdkEventServiceToken,
    useFactory: () => {
        isDevMode() && console.log('providing RdxCdkEventService...');
        const window = injectWindow();
        if ((window as any)[RdxCdkEventServiceWindowKey]) {
            if (throwWhenExists) {
                throw Error(existsErrorMessage);
            } else {
                isDevMode() && console.warn(existsErrorMessage);
            }
        }
        (window as any)[RdxCdkEventServiceWindowKey] ??= new RdxCdkEventService();
        return (window as any)[RdxCdkEventServiceWindowKey];
    }
});

export const provideRdxCdkEventServiceInRoot: () => EnvironmentProviders = () =>
    makeEnvironmentProviders([getProvider()]);
export const provideRdxCdkEventService: () => Provider = () => getProvider(false);

export const injectRdxCdkEventService = () => inject(RdxCdkEventServiceToken, { optional: true });



# ./tooltip/src/utils/types.ts

export type EventType = 'cdkOverlayOutsideClick' | 'cdkOverlayEscapeKeyDown';
export type EventTypeCapitalized<R extends EventType = EventType> = Capitalize<R>;
export type EventTypeAsPrimitiveConfigKey<R extends EventType = EventType> = `prevent${EventTypeCapitalized<R>}`;
export type PrimitiveConfig = {
    [value in EventTypeAsPrimitiveConfigKey]?: boolean;
};
export type PrimitiveConfigs = Map<object, PrimitiveConfig>;



# ./tooltip/src/utils/constants.ts

export const RdxCdkEventServiceWindowKey = Symbol('__RdxCdkEventService__');



# ./tooltip/src/tooltip-content.directive.ts

import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import { CdkConnectedOverlay, Overlay } from '@angular/cdk/overlay';
import {
    booleanAttribute,
    computed,
    DestroyRef,
    Directive,
    effect,
    inject,
    input,
    numberAttribute,
    OnInit,
    output,
    SimpleChange,
    TemplateRef,
    untracked
} from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import {
    getAllPossibleConnectedPositions,
    getContentPosition,
    RDX_POSITIONING_DEFAULTS,
    RdxPositionAlign,
    RdxPositionSide,
    RdxPositionSideAndAlignOffsets
} from '@radix-ng/primitives/core';
import { filter, tap } from 'rxjs';
import { injectTooltipRoot } from './tooltip-root.inject';
import { RdxTooltipAttachDetachEvent } from './tooltip.types';

@Directive({
    selector: '[rdxTooltipContent]',
    hostDirectives: [
        CdkConnectedOverlay
    ]
})
export class RdxTooltipContentDirective implements OnInit {
    /** @ignore */
    private readonly rootDirective = injectTooltipRoot();
    /** @ignore */
    private readonly templateRef = inject(TemplateRef);
    /** @ignore */
    private readonly overlay = inject(Overlay);
    /** @ignore */
    private readonly destroyRef = inject(DestroyRef);
    /** @ignore */
    private readonly connectedOverlay = inject(CdkConnectedOverlay);

    /** @ignore */
    readonly name = computed(() => `rdx-tooltip-trigger-${this.rootDirective.uniqueId()}`);

    /**
     * @description The preferred side of the trigger to render against when open. Will be reversed when collisions occur and avoidCollisions is enabled.
     * @default top
     */
    readonly side = input<RdxPositionSide>(RdxPositionSide.Top);
    /**
     * @description The distance in pixels from the trigger.
     * @default undefined
     */
    readonly sideOffset = input<number, NumberInput>(NaN, {
        transform: numberAttribute
    });
    /**
     * @description The preferred alignment against the trigger. May change when collisions occur.
     * @default center
     */
    readonly align = input<RdxPositionAlign>(RdxPositionAlign.Center);
    /**
     * @description An offset in pixels from the "start" or "end" alignment options.
     * @default undefined
     */
    readonly alignOffset = input<number, NumberInput>(NaN, {
        transform: numberAttribute
    });

    /**
     * @description Whether to add some alternate positions of the content.
     * @default false
     */
    readonly alternatePositionsDisabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /** @description Whether to prevent `onOverlayEscapeKeyDown` handler from calling. */
    readonly onOverlayEscapeKeyDownDisabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });
    /** @description Whether to prevent `onOverlayOutsideClick` handler from calling. */
    readonly onOverlayOutsideClickDisabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * @description Event handler called when the escape key is down.
     * It can be prevented by setting `onOverlayEscapeKeyDownDisabled` input to `true`.
     */
    readonly onOverlayEscapeKeyDown = output<KeyboardEvent>();
    /**
     * @description Event handler called when a pointer event occurs outside the bounds of the component.
     * It can be prevented by setting `onOverlayOutsideClickDisabled` input to `true`.
     */
    readonly onOverlayOutsideClick = output<MouseEvent>();

    /**
     * @description Event handler called after the overlay is open
     */
    readonly onOpen = output<void>();
    /**
     * @description Event handler called after the overlay is closed
     */
    readonly onClosed = output<void>();

    /** @ingore */
    readonly positions = computed(() => this.computePositions());

    constructor() {
        this.onOriginChangeEffect();
        this.onPositionChangeEffect();
    }

    /** @ignore */
    ngOnInit() {
        this.setScrollStrategy();
        this.setHasBackdrop();
        this.setDisableClose();
        this.onAttach();
        this.onDetach();
        this.connectKeydownEscape();
        this.connectOutsideClick();
    }

    /** @ignore */
    open() {
        if (this.connectedOverlay.open) {
            return;
        }
        const prevOpen = this.connectedOverlay.open;
        this.connectedOverlay.open = true;
        this.fireOverlayNgOnChanges('open', this.connectedOverlay.open, prevOpen);
    }

    /** @ignore */
    close() {
        if (!this.connectedOverlay.open) {
            return;
        }
        const prevOpen = this.connectedOverlay.open;
        this.connectedOverlay.open = false;
        this.fireOverlayNgOnChanges('open', this.connectedOverlay.open, prevOpen);
    }

    /** @ignore */
    positionChange() {
        return this.connectedOverlay.positionChange.asObservable();
    }

    /** @ignore */
    private connectKeydownEscape() {
        this.connectedOverlay.overlayKeydown
            .asObservable()
            .pipe(
                filter(
                    () =>
                        !this.onOverlayEscapeKeyDownDisabled() &&
                        !this.rootDirective.rdxCdkEventService?.primitivePreventedFromCdkEvent(
                            this.rootDirective,
                            'cdkOverlayEscapeKeyDown'
                        )
                ),
                filter((event) => event.key === 'Escape'),
                tap((event) => {
                    this.onOverlayEscapeKeyDown.emit(event);
                }),
                filter(() => !this.rootDirective.firstDefaultOpen()),
                tap(() => {
                    this.rootDirective.handleClose();
                }),
                takeUntilDestroyed(this.destroyRef)
            )
            .subscribe();
    }

    /** @ignore */
    private connectOutsideClick() {
        this.connectedOverlay.overlayOutsideClick
            .asObservable()
            .pipe(
                filter(
                    () =>
                        !this.onOverlayOutsideClickDisabled() &&
                        !this.rootDirective.rdxCdkEventService?.primitivePreventedFromCdkEvent(
                            this.rootDirective,
                            'cdkOverlayOutsideClick'
                        )
                ),
                /**
                 * Handle the situation when an anchor is added and the anchor becomes the origin of the overlay
                 * hence  the trigger will be considered the outside element
                 */
                filter((event) => {
                    return (
                        !this.rootDirective.anchorDirective() ||
                        !this.rootDirective
                            .triggerDirective()
                            .elementRef.nativeElement.contains(event.target as Element)
                    );
                }),
                tap((event) => {
                    this.onOverlayOutsideClick.emit(event);
                }),
                filter(() => !this.rootDirective.firstDefaultOpen()),
                tap(() => {
                    this.rootDirective.handleClose();
                }),
                takeUntilDestroyed(this.destroyRef)
            )
            .subscribe();
    }

    /** @ignore */
    private onAttach() {
        this.connectedOverlay.attach
            .asObservable()
            .pipe(
                tap(() => {
                    /**
                     * `this.onOpen.emit();` is being delegated to the rootDirective directive due to the opening animation
                     */
                    this.rootDirective.attachDetachEvent.set(RdxTooltipAttachDetachEvent.ATTACH);
                }),
                takeUntilDestroyed(this.destroyRef)
            )
            .subscribe();
    }

    /** @ignore */
    private onDetach() {
        this.connectedOverlay.detach
            .asObservable()
            .pipe(
                tap(() => {
                    /**
                     * `this.onClosed.emit();` is being delegated to the rootDirective directive due to the closing animation
                     */
                    this.rootDirective.attachDetachEvent.set(RdxTooltipAttachDetachEvent.DETACH);
                }),
                takeUntilDestroyed(this.destroyRef)
            )
            .subscribe();
    }

    /** @ignore */
    private setScrollStrategy() {
        const prevScrollStrategy = this.connectedOverlay.scrollStrategy;
        this.connectedOverlay.scrollStrategy = this.overlay.scrollStrategies.reposition();
        this.fireOverlayNgOnChanges('scrollStrategy', this.connectedOverlay.scrollStrategy, prevScrollStrategy);
    }

    /** @ignore */
    private setHasBackdrop() {
        const prevHasBackdrop = this.connectedOverlay.hasBackdrop;
        this.connectedOverlay.hasBackdrop = false;
        this.fireOverlayNgOnChanges('hasBackdrop', this.connectedOverlay.hasBackdrop, prevHasBackdrop);
    }

    /** @ignore */
    private setDisableClose() {
        const prevDisableClose = this.connectedOverlay.disableClose;
        this.connectedOverlay.disableClose = true;
        this.fireOverlayNgOnChanges('disableClose', this.connectedOverlay.disableClose, prevDisableClose);
    }

    /** @ignore */
    private setOrigin(origin: CdkConnectedOverlay['origin']) {
        const prevOrigin = this.connectedOverlay.origin;
        this.connectedOverlay.origin = origin;
        this.fireOverlayNgOnChanges('origin', this.connectedOverlay.origin, prevOrigin);
    }

    /** @ignore */
    private setPositions(positions: CdkConnectedOverlay['positions']) {
        const prevPositions = this.connectedOverlay.positions;
        this.connectedOverlay.positions = positions;
        this.fireOverlayNgOnChanges('positions', this.connectedOverlay.positions, prevPositions);
        this.connectedOverlay.overlayRef?.updatePosition();
    }

    /** @ignore */
    private computePositions() {
        const arrowHeight = this.rootDirective.arrowDirective()?.height() ?? 0;
        const offsets: RdxPositionSideAndAlignOffsets = {
            sideOffset:
                arrowHeight + (isNaN(this.sideOffset()) ? RDX_POSITIONING_DEFAULTS.offsets.side : this.sideOffset()),
            alignOffset: isNaN(this.alignOffset()) ? RDX_POSITIONING_DEFAULTS.offsets.align : this.alignOffset()
        };
        const basePosition = getContentPosition({
            side: this.side(),
            align: this.align(),
            sideOffset: offsets.sideOffset,
            alignOffset: offsets.alignOffset
        });
        const positions = [basePosition];
        if (!this.alternatePositionsDisabled()) {
            /**
             * Alternate positions for better user experience along the X/Y axis (e.g. vertical/horizontal scrolling)
             */
            const allPossibleConnectedPositions = getAllPossibleConnectedPositions();
            allPossibleConnectedPositions.forEach((_, key) => {
                const sideAndAlignArray = key.split('|');
                if (
                    (sideAndAlignArray[0] as RdxPositionSide) !== this.side() ||
                    (sideAndAlignArray[1] as RdxPositionAlign) !== this.align()
                ) {
                    positions.push(
                        getContentPosition({
                            side: sideAndAlignArray[0] as RdxPositionSide,
                            align: sideAndAlignArray[1] as RdxPositionAlign,
                            sideOffset: offsets.sideOffset,
                            alignOffset: offsets.alignOffset
                        })
                    );
                }
            });
        }
        return positions;
    }

    private onOriginChangeEffect() {
        effect(() => {
            const origin = (this.rootDirective.anchorDirective() ?? this.rootDirective.triggerDirective())
                .overlayOrigin;
            untracked(() => {
                this.setOrigin(origin);
            });
        });
    }

    /** @ignore */
    private onPositionChangeEffect() {
        effect(() => {
            const positions = this.positions();
            this.alternatePositionsDisabled();
            untracked(() => {
                this.setPositions(positions);
            });
        });
    }

    /** @ignore */
    private fireOverlayNgOnChanges<K extends keyof CdkConnectedOverlay, V extends CdkConnectedOverlay[K]>(
        input: K,
        currentValue: V,
        previousValue: V,
        firstChange = false
    ) {
        this.connectedOverlay.ngOnChanges({
            [input]: new SimpleChange(previousValue, currentValue, firstChange)
        });
    }
}



# ./tooltip/src/tooltip-trigger.directive.ts

import { CdkOverlayOrigin } from '@angular/cdk/overlay';
import { computed, Directive, ElementRef, inject } from '@angular/core';
import { injectTooltipRoot } from './tooltip-root.inject';

@Directive({
    selector: '[rdxTooltipTrigger]',
    hostDirectives: [CdkOverlayOrigin],
    host: {
        type: 'button',
        '[attr.id]': 'name()',
        '[attr.aria-haspopup]': '"dialog"',
        '[attr.aria-expanded]': 'rootDirective.isOpen()',
        '[attr.aria-controls]': 'rootDirective.contentDirective().name()',
        '[attr.data-state]': 'rootDirective.state()',
        '(pointerenter)': 'pointerenter()',
        '(pointerleave)': 'pointerleave()',
        '(focus)': 'focus()',
        '(blur)': 'blur()',
        '(click)': 'click()'
    }
})
export class RdxTooltipTriggerDirective {
    /** @ignore */
    protected readonly rootDirective = injectTooltipRoot();
    /** @ignore */
    readonly elementRef = inject<ElementRef<HTMLElement>>(ElementRef);
    /** @ignore */
    readonly overlayOrigin = inject(CdkOverlayOrigin);

    /** @ignore */
    readonly name = computed(() => `rdx-tooltip-trigger-${this.rootDirective.uniqueId()}`);

    /** @ignore */
    pointerenter(): void {
        this.rootDirective.handleOpen();
    }

    /** @ignore */
    pointerleave(): void {
        this.rootDirective.handleClose();
    }

    /** @ignore */
    focus(): void {
        this.rootDirective.handleOpen();
    }

    /** @ignore */
    blur(): void {
        this.rootDirective.handleClose();
    }

    /** @ignore */
    click(): void {
        this.rootDirective.handleClose();
    }
}



# ./tooltip/src/tooltip-anchor.token.ts

import { InjectionToken } from '@angular/core';
import { RdxTooltipAnchorDirective } from './tooltip-anchor.directive';

export const RdxTooltipAnchorToken = new InjectionToken<RdxTooltipAnchorDirective>('RdxTooltipAnchorToken');



# ./tooltip/src/tooltip-arrow.token.ts

import { InjectionToken } from '@angular/core';
import { RdxTooltipArrowDirective } from './tooltip-arrow.directive';

export const RdxTooltipArrowToken = new InjectionToken<RdxTooltipArrowDirective>('RdxTooltipArrowToken');



# ./tooltip/src/tooltip-arrow.directive.ts

import { NumberInput } from '@angular/cdk/coercion';
import { ConnectedOverlayPositionChange } from '@angular/cdk/overlay';
import {
    afterNextRender,
    computed,
    Directive,
    effect,
    ElementRef,
    forwardRef,
    inject,
    input,
    numberAttribute,
    Renderer2,
    signal,
    untracked
} from '@angular/core';
import { toSignal } from '@angular/core/rxjs-interop';
import {
    getArrowPositionParams,
    getSideAndAlignFromAllPossibleConnectedPositions,
    RDX_POSITIONING_DEFAULTS
} from '@radix-ng/primitives/core';
import { RdxTooltipArrowToken } from './tooltip-arrow.token';
import { injectTooltipRoot } from './tooltip-root.inject';

@Directive({
    selector: '[rdxTooltipArrow]',
    providers: [
        {
            provide: RdxTooltipArrowToken,
            useExisting: forwardRef(() => RdxTooltipArrowDirective)
        }
    ]
})
export class RdxTooltipArrowDirective {
    /** @ignore */
    private readonly renderer = inject(Renderer2);
    /** @ignore */
    private readonly rootDirective = injectTooltipRoot();
    /** @ignore */
    readonly elementRef = inject(ElementRef);

    /**
     * @description The width of the arrow in pixels.
     * @default 10
     */
    readonly width = input<number, NumberInput>(RDX_POSITIONING_DEFAULTS.arrow.width, { transform: numberAttribute });

    /**
     * @description The height of the arrow in pixels.
     * @default 5
     */
    readonly height = input<number, NumberInput>(RDX_POSITIONING_DEFAULTS.arrow.height, { transform: numberAttribute });

    /** @ignore */
    readonly arrowSvgElement = computed<HTMLElement>(() => {
        const width = this.width();
        const height = this.height();

        const svgElement = this.renderer.createElement('svg', 'svg');
        this.renderer.setAttribute(svgElement, 'viewBox', '0 0 30 10');
        this.renderer.setAttribute(svgElement, 'width', String(width));
        this.renderer.setAttribute(svgElement, 'height', String(height));
        const polygonElement = this.renderer.createElement('polygon', 'svg');
        this.renderer.setAttribute(polygonElement, 'points', '0,0 30,0 15,10');
        this.renderer.setAttribute(svgElement, 'preserveAspectRatio', 'none');
        this.renderer.appendChild(svgElement, polygonElement);

        return svgElement;
    });

    /** @ignore */
    private readonly currentArrowSvgElement = signal<HTMLOrSVGElement | undefined>(void 0);
    /** @ignore */
    private readonly position = toSignal(this.rootDirective.contentDirective().positionChange());

    /** @ignore */
    private anchorOrTriggerRect: DOMRect;

    constructor() {
        afterNextRender({
            write: () => {
                if (this.elementRef.nativeElement.parentElement) {
                    this.renderer.setStyle(this.elementRef.nativeElement.parentElement, 'position', 'relative');
                }
                this.renderer.setStyle(this.elementRef.nativeElement, 'position', 'absolute');
                this.renderer.setStyle(this.elementRef.nativeElement, 'boxSizing', '');
                this.renderer.setStyle(this.elementRef.nativeElement, 'fontSize', '0px');
            }
        });
        this.onArrowSvgElementChangeEffect();
        this.onContentPositionAndArrowDimensionsChangeEffect();
    }

    /** @ignore */
    private setAnchorOrTriggerRect() {
        this.anchorOrTriggerRect = (
            this.rootDirective.anchorDirective() ?? this.rootDirective.triggerDirective()
        ).elementRef.nativeElement.getBoundingClientRect();
    }

    /** @ignore */
    private setPosition(position: ConnectedOverlayPositionChange, arrowDimensions: { width: number; height: number }) {
        this.setAnchorOrTriggerRect();
        const posParams = getArrowPositionParams(
            getSideAndAlignFromAllPossibleConnectedPositions(position.connectionPair),
            { width: arrowDimensions.width, height: arrowDimensions.height },
            { width: this.anchorOrTriggerRect.width, height: this.anchorOrTriggerRect.height }
        );

        this.renderer.setStyle(this.elementRef.nativeElement, 'top', posParams.top);
        this.renderer.setStyle(this.elementRef.nativeElement, 'bottom', '');
        this.renderer.setStyle(this.elementRef.nativeElement, 'left', posParams.left);
        this.renderer.setStyle(this.elementRef.nativeElement, 'right', '');
        this.renderer.setStyle(this.elementRef.nativeElement, 'transform', posParams.transform);
        this.renderer.setStyle(this.elementRef.nativeElement, 'transformOrigin', posParams.transformOrigin);
    }

    /** @ignore */
    private onArrowSvgElementChangeEffect() {
        effect(() => {
            const arrowElement = this.arrowSvgElement();
            untracked(() => {
                const currentArrowSvgElement = this.currentArrowSvgElement();
                if (currentArrowSvgElement) {
                    this.renderer.removeChild(this.elementRef.nativeElement, currentArrowSvgElement);
                }
                this.currentArrowSvgElement.set(arrowElement);
                this.renderer.setStyle(this.elementRef.nativeElement, 'width', `${this.width()}px`);
                this.renderer.setStyle(this.elementRef.nativeElement, 'height', `${this.height()}px`);
                this.renderer.appendChild(this.elementRef.nativeElement, this.currentArrowSvgElement());
            });
        });
    }

    /** @ignore */
    private onContentPositionAndArrowDimensionsChangeEffect() {
        effect(() => {
            const position = this.position();
            const arrowDimensions = { width: this.width(), height: this.height() };
            untracked(() => {
                if (!position) {
                    return;
                }
                this.setPosition(position, arrowDimensions);
            });
        });
    }
}



# ./tooltip/src/tooltip-content-attributes.component.ts

import { ChangeDetectionStrategy, Component, computed, forwardRef } from '@angular/core';
import { RdxTooltipContentAttributesToken } from './tooltip-content-attributes.token';
import { injectTooltipRoot } from './tooltip-root.inject';
import { RdxTooltipAnimationStatus, RdxTooltipState } from './tooltip.types';

@Component({
    selector: '[rdxTooltipContentAttributes]',
    template: `
        <ng-content />
    `,
    host: {
        '[attr.role]': '"dialog"',
        '[attr.id]': 'name()',
        '[attr.data-state]': 'rootDirective.state()',
        '[attr.data-side]': 'rootDirective.contentDirective().side()',
        '[attr.data-align]': 'rootDirective.contentDirective().align()',
        '[style]': 'disableAnimation() ? {animation: "none !important"} : null',
        '(animationstart)': 'onAnimationStart($event)',
        '(animationend)': 'onAnimationEnd($event)',
        '(pointerenter)': 'pointerenter()',
        '(pointerleave)': 'pointerleave()',
        '(focus)': 'focus()',
        '(blur)': 'blur()'
    },
    providers: [
        {
            provide: RdxTooltipContentAttributesToken,
            useExisting: forwardRef(() => RdxTooltipContentAttributesComponent)
        }
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class RdxTooltipContentAttributesComponent {
    /** @ignore */
    protected readonly rootDirective = injectTooltipRoot();

    /** @ignore */
    readonly name = computed(() => `rdx-tooltip-content-attributes-${this.rootDirective.uniqueId()}`);

    /** @ignore */
    readonly disableAnimation = computed(() => !this.canAnimate());

    /** @ignore */
    protected onAnimationStart(_: AnimationEvent) {
        this.rootDirective.cssAnimationStatus.set(
            this.rootDirective.state() === RdxTooltipState.OPEN
                ? RdxTooltipAnimationStatus.OPEN_STARTED
                : RdxTooltipAnimationStatus.CLOSED_STARTED
        );
    }

    /** @ignore */
    protected onAnimationEnd(_: AnimationEvent) {
        this.rootDirective.cssAnimationStatus.set(
            this.rootDirective.state() === RdxTooltipState.OPEN
                ? RdxTooltipAnimationStatus.OPEN_ENDED
                : RdxTooltipAnimationStatus.CLOSED_ENDED
        );
    }

    /** @ignore */
    protected pointerenter(): void {
        this.rootDirective.handleOpen();
    }

    /** @ignore */
    protected pointerleave(): void {
        this.rootDirective.handleClose();
    }

    /** @ignore */
    protected focus(): void {
        this.rootDirective.handleOpen();
    }

    /** @ignore */
    protected blur(): void {
        this.rootDirective.handleClose();
    }

    /** @ignore */
    private canAnimate() {
        return (
            this.rootDirective.cssAnimation() &&
            ((this.rootDirective.cssOpeningAnimation() && this.rootDirective.state() === RdxTooltipState.OPEN) ||
                (this.rootDirective.cssClosingAnimation() && this.rootDirective.state() === RdxTooltipState.CLOSED))
        );
    }
}



# ./tooltip/src/tooltip.types.ts

export enum RdxTooltipState {
    OPEN = 'open',
    CLOSED = 'closed'
}

export enum RdxTooltipAction {
    OPEN = 'open',
    CLOSE = 'close'
}

export enum RdxTooltipAttachDetachEvent {
    ATTACH = 'attach',
    DETACH = 'detach'
}

export enum RdxTooltipAnimationStatus {
    OPEN_STARTED = 'open_started',
    OPEN_ENDED = 'open_ended',
    CLOSED_STARTED = 'closed_started',
    CLOSED_ENDED = 'closed_ended'
}



# ./tooltip/src/tooltip-root.directive.ts

import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import {
    afterNextRender,
    booleanAttribute,
    computed,
    contentChild,
    DestroyRef,
    Directive,
    effect,
    inject,
    input,
    numberAttribute,
    signal,
    untracked,
    ViewContainerRef
} from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { debounce, map, Subject, tap, timer } from 'rxjs';
import { RdxTooltipAnchorDirective } from './tooltip-anchor.directive';
import { RdxTooltipAnchorToken } from './tooltip-anchor.token';
import { RdxTooltipArrowToken } from './tooltip-arrow.token';
import { RdxTooltipCloseToken } from './tooltip-close.token';
import { RdxTooltipContentAttributesToken } from './tooltip-content-attributes.token';
import { RdxTooltipContentDirective } from './tooltip-content.directive';
import { RdxTooltipTriggerDirective } from './tooltip-trigger.directive';
import {
    RdxTooltipAction,
    RdxTooltipAnimationStatus,
    RdxTooltipAttachDetachEvent,
    RdxTooltipState
} from './tooltip.types';
import { injectRdxCdkEventService } from './utils/cdk-event.service';

let nextId = 0;

@Directive({
    selector: '[rdxTooltipRoot]',
    exportAs: 'rdxTooltipRoot'
})
export class RdxTooltipRootDirective {
    /** @ignore */
    readonly uniqueId = signal(++nextId);
    /** @ignore */
    readonly name = computed(() => `rdx-tooltip-root-${this.uniqueId()}`);

    /**
     * @description The anchor directive that comes form outside the tooltip rootDirective
     * @default undefined
     */
    readonly anchor = input<RdxTooltipAnchorDirective | undefined>(void 0);
    /**
     * @description The open state of the tooltip when it is initially rendered. Use when you do not need to control its open state.
     * @default false
     */
    readonly defaultOpen = input<boolean, BooleanInput>(false, { transform: booleanAttribute });
    /**
     * @description The controlled state of the tooltip. `open` input take precedence of `defaultOpen` input.
     * @default undefined
     */
    readonly open = input<boolean | undefined, BooleanInput>(void 0, { transform: booleanAttribute });
    /**
     * To customise the open delay for a specific tooltip.
     */
    readonly openDelay = input<number, NumberInput>(500, {
        transform: numberAttribute
    });
    /**
     * To customise the close delay for a specific tooltip.
     */
    readonly closeDelay = input<number, NumberInput>(200, {
        transform: numberAttribute
    });
    /**
     * @description Whether to control the state of the tooltip from external. Use in conjunction with `open` input.
     * @default undefined
     */
    readonly externalControl = input<boolean | undefined, BooleanInput>(void 0, { transform: booleanAttribute });
    /**
     * @description Whether to take into account CSS opening/closing animations.
     * @default false
     */
    readonly cssAnimation = input<boolean, BooleanInput>(false, { transform: booleanAttribute });
    /**
     * @description Whether to take into account CSS opening animations. `cssAnimation` input must be set to 'true'
     * @default false
     */
    readonly cssOpeningAnimation = input<boolean, BooleanInput>(false, { transform: booleanAttribute });
    /**
     * @description Whether to take into account CSS closing animations. `cssAnimation` input must be set to 'true'
     * @default false
     */
    readonly cssClosingAnimation = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /** @ignore */
    readonly cssAnimationStatus = signal<RdxTooltipAnimationStatus | null>(null);

    /** @ignore */
    readonly contentDirective = contentChild.required(RdxTooltipContentDirective);
    /** @ignore */
    readonly triggerDirective = contentChild.required(RdxTooltipTriggerDirective);
    /** @ignore */
    readonly arrowDirective = contentChild(RdxTooltipArrowToken);
    /** @ignore */
    readonly closeDirective = contentChild(RdxTooltipCloseToken);
    /** @ignore */
    readonly contentAttributesComponent = contentChild(RdxTooltipContentAttributesToken);
    /** @ignore */
    private readonly internalAnchorDirective = contentChild(RdxTooltipAnchorToken);

    /** @ignore */
    readonly viewContainerRef = inject(ViewContainerRef);
    /** @ignore */
    readonly rdxCdkEventService = injectRdxCdkEventService();
    /** @ignore */
    readonly destroyRef = inject(DestroyRef);

    /** @ignore */
    readonly state = signal(RdxTooltipState.CLOSED);

    /** @ignore */
    readonly attachDetachEvent = signal(RdxTooltipAttachDetachEvent.DETACH);

    /** @ignore */
    private readonly isFirstDefaultOpen = signal(false);

    /** @ignore */
    readonly anchorDirective = computed(() => this.internalAnchorDirective() ?? this.anchor());

    /** @ignore */
    readonly actionSubject$ = new Subject<RdxTooltipAction>();

    constructor() {
        this.rdxCdkEventService?.registerPrimitive(this);
        this.destroyRef.onDestroy(() => this.rdxCdkEventService?.deregisterPrimitive(this));
        this.actionSubscription();
        this.onStateChangeEffect();
        this.onCssAnimationStatusChangeChangeEffect();
        this.onOpenChangeEffect();
        this.onIsFirstDefaultOpenChangeEffect();
        this.onAnchorChangeEffect();
        this.emitOpenOrClosedEventEffect();
        afterNextRender({
            write: () => {
                if (this.defaultOpen() && !this.open()) {
                    this.isFirstDefaultOpen.set(true);
                }
            }
        });
    }

    /** @ignore */
    getAnimationParamsSnapshot() {
        return {
            cssAnimation: this.cssAnimation(),
            cssOpeningAnimation: this.cssOpeningAnimation(),
            cssClosingAnimation: this.cssClosingAnimation(),
            cssAnimationStatus: this.cssAnimationStatus(),
            attachDetachEvent: this.attachDetachEvent(),
            state: this.state(),
            canEmitOnOpenOrOnClosed: this.canEmitOnOpenOrOnClosed()
        };
    }

    /** @ignore */
    controlledExternally() {
        return this.externalControl;
    }

    /** @ignore */
    firstDefaultOpen() {
        return this.isFirstDefaultOpen();
    }

    /** @ignore */
    handleOpen(): void {
        if (this.externalControl()) {
            return;
        }
        this.actionSubject$.next(RdxTooltipAction.OPEN);
    }

    /** @ignore */
    handleClose(closeButton?: boolean): void {
        if (this.isFirstDefaultOpen()) {
            this.isFirstDefaultOpen.set(false);
        }
        if (!closeButton && this.externalControl()) {
            return;
        }
        this.actionSubject$.next(RdxTooltipAction.CLOSE);
    }

    /** @ignore */
    handleToggle(): void {
        if (this.externalControl()) {
            return;
        }
        this.isOpen() ? this.handleClose() : this.handleOpen();
    }

    /** @ignore */
    isOpen(state?: RdxTooltipState) {
        return (state ?? this.state()) === RdxTooltipState.OPEN;
    }

    /** @ignore */
    private setState(state = RdxTooltipState.CLOSED): void {
        if (state === this.state()) {
            return;
        }
        this.state.set(state);
    }

    /** @ignore */
    private openContent(): void {
        this.contentDirective().open();
        if (!this.cssAnimation() || !this.cssOpeningAnimation()) {
            this.cssAnimationStatus.set(null);
        }
    }

    /** @ignore */
    private closeContent(): void {
        this.contentDirective().close();
        if (!this.cssAnimation() || !this.cssClosingAnimation()) {
            this.cssAnimationStatus.set(null);
        }
    }

    /** @ignore */
    private emitOnOpen(): void {
        this.contentDirective().onOpen.emit();
    }

    /** @ignore */
    private emitOnClosed(): void {
        this.contentDirective().onClosed.emit();
    }

    /** @ignore */
    private ifOpenOrCloseWithoutAnimations(state: RdxTooltipState) {
        return (
            !this.contentAttributesComponent() ||
            !this.cssAnimation() ||
            (this.cssAnimation() && !this.cssClosingAnimation() && state === RdxTooltipState.CLOSED) ||
            (this.cssAnimation() && !this.cssOpeningAnimation() && state === RdxTooltipState.OPEN) ||
            // !this.cssAnimationStatus() ||
            (this.cssOpeningAnimation() &&
                state === RdxTooltipState.OPEN &&
                [RdxTooltipAnimationStatus.OPEN_STARTED].includes(this.cssAnimationStatus()!)) ||
            (this.cssClosingAnimation() &&
                state === RdxTooltipState.CLOSED &&
                [RdxTooltipAnimationStatus.CLOSED_STARTED].includes(this.cssAnimationStatus()!))
        );
    }

    /** @ignore */
    private ifOpenOrCloseWithAnimations(cssAnimationStatus: RdxTooltipAnimationStatus | null) {
        return (
            this.contentAttributesComponent() &&
            this.cssAnimation() &&
            cssAnimationStatus &&
            ((this.cssOpeningAnimation() &&
                this.state() === RdxTooltipState.OPEN &&
                [RdxTooltipAnimationStatus.OPEN_ENDED].includes(cssAnimationStatus)) ||
                (this.cssClosingAnimation() &&
                    this.state() === RdxTooltipState.CLOSED &&
                    [RdxTooltipAnimationStatus.CLOSED_ENDED].includes(cssAnimationStatus)))
        );
    }

    /** @ignore */
    private openOrClose(state: RdxTooltipState) {
        const isOpen = this.isOpen(state);
        isOpen ? this.openContent() : this.closeContent();
    }

    /** @ignore */
    private emitOnOpenOrOnClosed(state: RdxTooltipState) {
        this.isOpen(state)
            ? this.attachDetachEvent() === RdxTooltipAttachDetachEvent.ATTACH && this.emitOnOpen()
            : this.attachDetachEvent() === RdxTooltipAttachDetachEvent.DETACH && this.emitOnClosed();
    }

    /** @ignore */
    private canEmitOnOpenOrOnClosed() {
        return (
            !this.cssAnimation() ||
            (!this.cssOpeningAnimation() && this.state() === RdxTooltipState.OPEN) ||
            (this.cssOpeningAnimation() &&
                this.state() === RdxTooltipState.OPEN &&
                this.cssAnimationStatus() === RdxTooltipAnimationStatus.OPEN_ENDED) ||
            (!this.cssClosingAnimation() && this.state() === RdxTooltipState.CLOSED) ||
            (this.cssClosingAnimation() &&
                this.state() === RdxTooltipState.CLOSED &&
                this.cssAnimationStatus() === RdxTooltipAnimationStatus.CLOSED_ENDED)
        );
    }

    /** @ignore */
    private onStateChangeEffect() {
        let isFirst = true;
        effect(() => {
            const state = this.state();
            untracked(() => {
                if (isFirst) {
                    isFirst = false;
                    return;
                }
                if (!this.ifOpenOrCloseWithoutAnimations(state)) {
                    return;
                }
                this.openOrClose(state);
            });
        }, {});
    }

    /** @ignore */
    private onCssAnimationStatusChangeChangeEffect() {
        let isFirst = true;
        effect(() => {
            const cssAnimationStatus = this.cssAnimationStatus();
            untracked(() => {
                if (isFirst) {
                    isFirst = false;
                    return;
                }
                if (!this.ifOpenOrCloseWithAnimations(cssAnimationStatus)) {
                    return;
                }
                this.openOrClose(this.state());
            });
        });
    }

    /** @ignore */
    private emitOpenOrClosedEventEffect() {
        let isFirst = true;
        effect(() => {
            this.attachDetachEvent();
            this.cssAnimationStatus();
            untracked(() => {
                if (isFirst) {
                    isFirst = false;
                    return;
                }
                const canEmitOpenClose = untracked(() => this.canEmitOnOpenOrOnClosed());
                if (!canEmitOpenClose) {
                    return;
                }
                this.emitOnOpenOrOnClosed(this.state());
            });
        });
    }

    /** @ignore */
    private onOpenChangeEffect() {
        effect(() => {
            const open = this.open();
            untracked(() => {
                this.setState(open ? RdxTooltipState.OPEN : RdxTooltipState.CLOSED);
            });
        });
    }

    /** @ignore */
    private onIsFirstDefaultOpenChangeEffect() {
        const effectRef = effect(() => {
            const defaultOpen = this.defaultOpen();
            untracked(() => {
                if (!defaultOpen || this.open()) {
                    effectRef.destroy();
                    return;
                }
                this.handleOpen();
            });
        });
    }

    /** @ignore */
    private onAnchorChangeEffect = () => {
        effect(() => {
            const anchor = this.anchor();
            untracked(() => {
                if (anchor) {
                    anchor.setRoot(this);
                }
            });
        });
    };

    /** @ignore */
    private actionSubscription() {
        this.actionSubject$
            .asObservable()
            .pipe(
                map((action) => {
                    console.log(action);
                    switch (action) {
                        case RdxTooltipAction.OPEN:
                            return { action, duration: this.openDelay() };
                        case RdxTooltipAction.CLOSE:
                            return { action, duration: this.closeDelay() };
                    }
                }),
                debounce((config) => timer(config.duration)),
                tap((config) => {
                    switch (config.action) {
                        case RdxTooltipAction.OPEN:
                            this.setState(RdxTooltipState.OPEN);
                            break;
                        case RdxTooltipAction.CLOSE:
                            this.setState(RdxTooltipState.CLOSED);
                            break;
                    }
                }),
                takeUntilDestroyed()
            )
            .subscribe();
    }
}



# ./tooltip/src/tooltip-content-attributes.token.ts

import { InjectionToken } from '@angular/core';
import { RdxTooltipContentAttributesComponent } from './tooltip-content-attributes.component';

export const RdxTooltipContentAttributesToken = new InjectionToken<RdxTooltipContentAttributesComponent>(
    'RdxTooltipContentAttributesToken'
);



# ./tooltip/src/tooltip-close.token.ts

import { InjectionToken } from '@angular/core';
import { RdxTooltipCloseDirective } from './tooltip-close.directive';

export const RdxTooltipCloseToken = new InjectionToken<RdxTooltipCloseDirective>('RdxTooltipCloseToken');



# ./radio/README.md

# @radix-ng/primitives/radio



# ./radio/index.ts

export * from './src/radio-root.directive';

export * from './src/radio-indicator.directive';
export * from './src/radio-item-input.directive';
export * from './src/radio-item.directive';



# ./radio/src/radio-tokens.ts

import { BooleanInput } from '@angular/cdk/coercion';
import { InjectionToken, InputSignalWithTransform, ModelSignal, Signal } from '@angular/core';

export interface RadioGroupProps {
    name?: string;
    disabled?: InputSignalWithTransform<boolean, BooleanInput>;
    defaultValue?: string;
    value: ModelSignal<string | null>;
    disableState: Signal<boolean>;
}

export interface RadioGroupDirective extends RadioGroupProps {
    select(value: string | null): void;

    onTouched(): void;
}

export const RDX_RADIO_GROUP = new InjectionToken<RadioGroupDirective>('RdxRadioGroup');



# ./radio/src/radio-item.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import {
    booleanAttribute,
    computed,
    Directive,
    ElementRef,
    inject,
    InjectionToken,
    input,
    OnInit,
    signal
} from '@angular/core';
import { RdxRovingFocusItemDirective } from '@radix-ng/primitives/roving-focus';
import { RDX_RADIO_GROUP } from './radio-tokens';

export const RdxRadioItemToken = new InjectionToken<RdxRadioItemDirective>('RadioItemToken');

export function injectRadioItem(): RdxRadioItemDirective {
    return inject(RdxRadioItemToken);
}

@Directive({
    selector: '[rdxRadioItem]',
    exportAs: 'rdxRadioItem',
    providers: [{ provide: RdxRadioItemToken, useExisting: RdxRadioItemDirective }],
    hostDirectives: [
        { directive: RdxRovingFocusItemDirective, inputs: ['tabStopId: id', 'focusable', 'active', 'allowShiftKey'] }],

    host: {
        type: 'button',
        role: 'radio',
        '[attr.aria-checked]': 'checkedState()',
        '[attr.data-disabled]': 'disabledState() ? "" : null',
        '[attr.data-state]': 'checkedState() ? "checked" : "unchecked"',
        '[disabled]': 'disabledState()',
        '(click)': 'onClick()',
        '(keydown)': 'onKeyDown($event)',
        '(keyup)': 'onKeyUp()',
        '(focus)': 'onFocus()'
    }
})
export class RdxRadioItemDirective implements OnInit {
    private readonly radioGroup = inject(RDX_RADIO_GROUP);
    private readonly elementRef = inject(ElementRef);

    readonly value = input.required<string>();

    readonly id = input<string>();

    readonly required = input<boolean>();

    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    protected readonly disabledState = computed(() => this.radioGroup.disableState() || this.disabled());

    readonly checkedState = computed(() => this.radioGroup.value() === this.value());

    private readonly ARROW_KEYS = ['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'];
    private readonly isArrowKeyPressedSignal = signal(false);

    /** @ignore */
    ngOnInit() {
        if (this.radioGroup.defaultValue === this.value()) {
            this.radioGroup.select(this.value());
        }
    }

    /** @ignore */
    onClick() {
        if (!this.disabledState()) {
            this.radioGroup.select(this.value());
            this.isArrowKeyPressedSignal.set(true);
        }
    }

    /** @ignore */
    onKeyDown(event: KeyboardEvent): void {
        if (this.ARROW_KEYS.includes(event.key)) {
            this.isArrowKeyPressedSignal.set(true);
        }
    }

    /** @ignore */
    onKeyUp() {
        this.isArrowKeyPressedSignal.set(false);
    }

    /** @ignore */
    onFocus() {
        this.radioGroup.select(this.value());
        setTimeout(() => {
            /**
             * When navigating with arrow keys, focus triggers on the radio item.
             * To "check" the radio, we programmatically trigger a click event.
             */
            if (this.isArrowKeyPressedSignal()) {
                this.elementRef.nativeElement.click();
            }
        }, 0);
    }
}



# ./radio/src/radio-indicator.directive.ts

import { Directive, inject } from '@angular/core';
import { RdxRadioItemDirective } from './radio-item.directive';
import { RDX_RADIO_GROUP, RadioGroupDirective } from './radio-tokens';

@Directive({
    selector: '[rdxRadioIndicator]',
    exportAs: 'rdxRadioIndicator',
    host: {
        '[attr.data-state]': 'radioItem.checkedState() ? "checked" : "unchecked"',
        '[attr.data-disabled]': 'radioItem.disabled() ? "" : undefined'
    }
})
export class RdxRadioIndicatorDirective {
    protected readonly radioGroup: RadioGroupDirective = inject(RDX_RADIO_GROUP);
    protected readonly radioItem: RdxRadioItemDirective = inject(RdxRadioItemDirective);
}



# ./radio/src/radio-root.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, computed, Directive, input, Input, model, output, signal } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { Orientation, RdxRovingFocusGroupDirective } from '@radix-ng/primitives/roving-focus';
import { RadioGroupDirective, RadioGroupProps, RDX_RADIO_GROUP } from './radio-tokens';

@Directive({
    selector: '[rdxRadioRoot]',
    exportAs: 'rdxRadioRoot',
    providers: [
        { provide: RDX_RADIO_GROUP, useExisting: RdxRadioGroupDirective },
        { provide: NG_VALUE_ACCESSOR, useExisting: RdxRadioGroupDirective, multi: true }
    ],
    hostDirectives: [{ directive: RdxRovingFocusGroupDirective, inputs: ['dir', 'orientation', 'loop'] }],
    host: {
        role: 'radiogroup',
        '[attr.aria-orientation]': 'orientation()',
        '[attr.aria-required]': 'required()',
        '[attr.data-disabled]': 'disableState() ? "" : null',
        '(keydown)': 'onKeydown()'
    }
})
export class RdxRadioGroupDirective implements RadioGroupProps, RadioGroupDirective, ControlValueAccessor {
    readonly value = model<string | null>(null);

    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    @Input() defaultValue?: string;

    readonly required = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    readonly orientation = input<Orientation>();

    /**
     * Event handler called when the value changes.
     */
    readonly onValueChange = output<string>();

    private readonly disable = signal<boolean>(this.disabled());
    readonly disableState = computed(() => this.disable() || this.disabled());

    /**
     * The callback function to call when the value of the radio group changes.
     */
    private onChange: (value: string) => void = () => {
        /* Empty */
    };

    /**
     * The callback function to call when the radio group is touched.
     * @ignore
     */
    onTouched: () => void = () => {
        /* Empty */
    };

    /**
     * Select a radio item.
     * @param value The value of the radio item to select.
     * @ignore
     */
    select(value: string): void {
        this.value.set(value);
        this.onValueChange.emit(value);
        this.onChange?.(value);
        this.onTouched();
    }

    /**
     * Update the value of the radio group.
     * @param value The new value of the radio group.
     * @ignore
     */
    writeValue(value: string): void {
        this.value.set(value);
    }

    /**
     * Register a callback function to call when the value of the radio group changes.
     * @param fn The callback function to call when the value of the radio group changes.
     * @ignore
     */
    registerOnChange(fn: (value: string) => void): void {
        this.onChange = fn;
    }

    /** @ignore */
    registerOnTouched(fn: () => void): void {
        this.onTouched = fn;
    }

    /**
     * Set the disabled state of the radio group.
     * @param isDisabled Whether the radio group is disabled.
     * @ignore
     */
    setDisabledState(isDisabled: boolean): void {
        this.disable.set(isDisabled);
    }

    protected onKeydown(): void {
        if (this.disableState()) return;
    }
}



# ./radio/src/radio-item-input.directive.ts

import { computed, Directive, input } from '@angular/core';
import { RdxVisuallyHiddenDirective } from '@radix-ng/primitives/visually-hidden';
import { injectRadioItem } from './radio-item.directive';

@Directive({
    selector: '[rdxRadioItemInput]',
    exportAs: 'rdxRadioItemInput',
    hostDirectives: [
        { directive: RdxVisuallyHiddenDirective, inputs: ['feature'] }],
    host: {
        type: 'radio',
        '[attr.name]': 'name()',
        '[attr.required]': 'required()',
        '[attr.disabled]': 'disabled() ? disabled() : undefined',
        '[attr.checked]': 'checked()',
        '[value]': 'value()'
    }
})
export class RdxRadioItemInputDirective {
    private readonly radioItem = injectRadioItem();

    readonly name = input<string>();
    readonly value = computed(() => this.radioItem.value() || undefined);
    readonly checked = computed(() => this.radioItem.checkedState() || undefined);
    readonly required = input<boolean | undefined>(this.radioItem.required());
    readonly disabled = input<boolean | undefined>(this.radioItem.disabled());
}



# ./core/index.ts

export * from './src/accessor/provide-value-accessor';
export * from './src/auto-focus.directive';
export * from './src/document';
export * from './src/id-generator';
export * from './src/inject-ng-control';
export * from './src/is-client';
export * from './src/is-inside-form';
export * from './src/is-nullish';
export * from './src/is-number';
export * from './src/kbd-constants';
export * from './src/window';

export * from './src/positioning/constants';
export * from './src/positioning/types';
export * from './src/positioning/utils';



# ./core/src/is-nullish.ts

export function isNullish(value: any): value is null | undefined {
    return value === null || value === undefined;
}



# ./core/src/id-generator.ts

/**
 * @license
 * Copyright Google LLC All Rights Reserved.
 *
 * Use of this source code is governed by an MIT-style license that can be
 * found in the LICENSE file at https://angular.dev/license
 */

import { APP_ID, inject, Injectable } from '@angular/core';

/**
 * Keeps track of the ID count per prefix. This helps us make the IDs a bit more deterministic
 * like they were before the service was introduced. Note that ideally we wouldn't have to do
 * this, but there are some internal tests that rely on the IDs.
 */
const counters: Record<string, number> = {};

/** Service that generates unique IDs for DOM nodes. */
@Injectable({ providedIn: 'root' })
export class _IdGenerator {
    private readonly _appId = inject(APP_ID);

    /**
     * Generates a unique ID with a specific prefix.
     * @param prefix Prefix to add to the ID.
     */
    getId(prefix: string): string {
        // Omit the app ID if it's the default `ng`. Since the vast majority of pages have one
        // Angular app on them, we can reduce the amount of breakages by not adding it.
        if (this._appId !== 'ng') {
            prefix += this._appId;
        }

        if (!Object.prototype.hasOwnProperty.call(counters, prefix)) {
            counters[prefix] = 0;
        }

        return `${prefix}${counters[prefix]++}`;
    }
}



# ./core/src/is-inside-form.ts

import { ElementRef } from '@angular/core';

export function isInsideForm(el: ElementRef<HTMLElement> | null): boolean {
    if (!el || !el.nativeElement) {
        return true;
    }
    return Boolean(el.nativeElement.closest('form'));
}



# ./core/src/mount.ts

import { AfterViewInit, Directive } from '@angular/core';

const callAll =
    <T extends (...a: never[]) => void>(...fns: (T | undefined)[]) =>
    (...a: Parameters<T>) => {
        fns.forEach(function (fn) {
            fn?.(...a);
        });
    };

@Directive({
    standalone: true
})
export class OnMountDirective implements AfterViewInit {
    #onMountFns?: () => void;

    onMount(fn: () => void) {
        this.#onMountFns = callAll(this.#onMountFns, fn);
    }

    ngAfterViewInit() {
        if (!this.#onMountFns) {
            throw new Error('The onMount function must be called before the component is mounted.');
        }
        this.#onMountFns();
    }
}



# ./core/src/inject-ng-control.ts

import { inject } from '@angular/core';
import { FormControlDirective, FormControlName, NgControl, NgModel } from '@angular/forms';

export function injectNgControl(params: {
    optional: true;
}): FormControlDirective | FormControlName | NgModel | undefined;
export function injectNgControl(params: { optional: false }): FormControlDirective | FormControlName | NgModel;
export function injectNgControl(): FormControlDirective | FormControlName | NgModel;

export function injectNgControl(params?: { optional: true } | { optional: false }) {
    const ngControl = inject(NgControl, { self: true, optional: true });

    if (!params?.optional && !ngControl) throw new Error('NgControl not found');

    if (
        ngControl instanceof FormControlDirective ||
        ngControl instanceof FormControlName ||
        ngControl instanceof NgModel
    ) {
        return ngControl;
    }

    if (params?.optional) {
        return undefined;
    }

    throw new Error('NgControl is not an instance of FormControlDirective, FormControlName or NgModel');
}



# ./core/src/accessor/provide-value-accessor.ts

import { Provider, Type } from '@angular/core';
import { NG_VALUE_ACCESSOR } from '@angular/forms';

/**
 * Include in the providers section of a component which utilizes ControlValueAccessor to redundant code.
 *
 * ```ts
 * @Directive({
 *   providers: [provideValueAccessor(ExampleDirective)]
 *}
 * export class ExampleDirective{}
 * ```
 */
export function provideValueAccessor(type: Type<never>): Provider {
    return {
        provide: NG_VALUE_ACCESSOR,
        useExisting: type,
        multi: true
    };
}



# ./core/src/document.ts

import { DOCUMENT } from '@angular/common';
import { inject } from '@angular/core';

export function injectDocument(): Document {
    return inject(DOCUMENT);
}



# ./core/src/positioning/utils.ts

import { ConnectedPosition, ConnectionPositionPair } from '@angular/cdk/overlay';
import { RDX_POSITIONS } from './constants';
import {
    RdxAllPossibleConnectedPositions,
    RdxArrowPositionParams,
    RdxPositionAlign,
    RdxPositionSide,
    RdxPositionSideAndAlign,
    RdxPositionSideAndAlignOffsets
} from './types';

export function getContentPosition(
    sideAndAlignWithOffsets: RdxPositionSideAndAlign & RdxPositionSideAndAlignOffsets
): ConnectedPosition {
    const { side, align, sideOffset, alignOffset } = sideAndAlignWithOffsets;
    const position: ConnectedPosition = {
        ...(RDX_POSITIONS[side]?.[align] ?? RDX_POSITIONS[RdxPositionSide.Top][RdxPositionAlign.Center])
    };
    if (sideOffset || alignOffset) {
        if ([RdxPositionSide.Top, RdxPositionSide.Bottom].includes(side)) {
            if (sideOffset) {
                position.offsetY = side === RdxPositionSide.Top ? -sideOffset : sideOffset;
            }
            if (alignOffset) {
                position.offsetX = alignOffset;
            }
        } else {
            if (sideOffset) {
                position.offsetX = side === RdxPositionSide.Left ? -sideOffset : sideOffset;
            }
            if (alignOffset) {
                position.offsetY = alignOffset;
            }
        }
    }
    return position;
}

let allPossibleConnectedPositions: RdxAllPossibleConnectedPositions;
export function getAllPossibleConnectedPositions() {
    if (!allPossibleConnectedPositions) {
        allPossibleConnectedPositions = new Map();
    }
    if (allPossibleConnectedPositions.size < 1) {
        for (const [side, aligns] of Object.entries(RDX_POSITIONS)) {
            for (const [align, position] of Object.entries(aligns)) {
                (allPossibleConnectedPositions as Map<any, any>).set(`${side}|${align}`, position);
            }
        }
    }
    return allPossibleConnectedPositions;
}

export function getSideAndAlignFromAllPossibleConnectedPositions(
    position: ConnectionPositionPair
): RdxPositionSideAndAlign {
    const allPossibleConnectedPositions = getAllPossibleConnectedPositions();
    let sideAndAlign: RdxPositionSideAndAlign | undefined;
    allPossibleConnectedPositions.forEach((value, key) => {
        if (
            position.originX === value.originX &&
            position.originY === value.originY &&
            position.overlayX === value.overlayX &&
            position.overlayY === value.overlayY
        ) {
            const sideAndAlignArray = key.split('|');
            sideAndAlign = {
                side: sideAndAlignArray[0] as RdxPositionSide,
                align: sideAndAlignArray[1] as RdxPositionAlign
            };
        }
    });
    if (!sideAndAlign) {
        throw Error(
            `[Rdx positioning] cannot infer both side and align from the given position (${JSON.stringify(position)})`
        );
    }
    return sideAndAlign;
}

export function getArrowPositionParams(
    sideAndAlign: RdxPositionSideAndAlign,
    arrowWidthAndHeight: { width: number; height: number },
    triggerWidthAndHeight: { width: number; height: number }
): RdxArrowPositionParams {
    const posParams: RdxArrowPositionParams = {
        top: '',
        left: '',
        transform: '',
        transformOrigin: 'center center 0px'
    };

    if ([RdxPositionSide.Top, RdxPositionSide.Bottom].includes(sideAndAlign.side)) {
        if (sideAndAlign.side === RdxPositionSide.Top) {
            posParams.top = '100%';
        } else {
            posParams.top = `-${arrowWidthAndHeight.height}px`;
            posParams.transform = `rotate(180deg)`;
        }

        if (sideAndAlign.align === RdxPositionAlign.Start) {
            posParams.left = `${(triggerWidthAndHeight.width - arrowWidthAndHeight.width) / 2}px`;
        } else if (sideAndAlign.align === RdxPositionAlign.Center) {
            posParams.left = `calc(50% - ${arrowWidthAndHeight.width / 2}px)`;
        } else if (sideAndAlign.align === RdxPositionAlign.End) {
            posParams.left = `calc(100% - ${(triggerWidthAndHeight.width + arrowWidthAndHeight.width) / 2}px)`;
        }
    } else if ([RdxPositionSide.Left, RdxPositionSide.Right].includes(sideAndAlign.side)) {
        if (sideAndAlign.side === RdxPositionSide.Left) {
            posParams.left = `calc(100% - ${arrowWidthAndHeight.width}px)`;
            posParams.transform = `rotate(-90deg)`;
            posParams.transformOrigin = 'top right 0px';
        } else {
            posParams.left = `0`;
            posParams.transform = `rotate(90deg)`;
            posParams.transformOrigin = 'top left 0px';
        }

        if (sideAndAlign.align === RdxPositionAlign.Start) {
            posParams.top = `${(triggerWidthAndHeight.height - arrowWidthAndHeight.width) / 2}px`;
        } else if (sideAndAlign.align === RdxPositionAlign.Center) {
            posParams.top = `calc(50% - ${arrowWidthAndHeight.width / 2}px)`;
        } else if (sideAndAlign.align === RdxPositionAlign.End) {
            posParams.top = `calc(100% - ${(triggerWidthAndHeight.height + arrowWidthAndHeight.width) / 2}px)`;
        }
    }

    return posParams;
}



# ./core/src/positioning/types.ts

import { ConnectionPositionPair } from '@angular/cdk/overlay';

export enum RdxPositionSide {
    Top = 'top',
    Right = 'right',
    Bottom = 'bottom',
    Left = 'left'
}

export enum RdxPositionAlign {
    Start = 'start',
    Center = 'center',
    End = 'end'
}

export type RdxPositionSideAndAlign = { side: RdxPositionSide; align: RdxPositionAlign };
export type RdxPositionSideAndAlignOffsets = { sideOffset: number; alignOffset: number };

export type RdxPositions = Readonly<{
    [key in RdxPositionSide]: Readonly<{
        [key in RdxPositionAlign]: Readonly<ConnectionPositionPair>;
    }>;
}>;

export type RdxPositioningDefaults = Readonly<{
    offsets: Readonly<{
        side: number;
        align: number;
    }>;
    arrow: Readonly<{
        width: number;
        height: number;
    }>;
}>;

export type RdxAllPossibleConnectedPositions = ReadonlyMap<
    `${RdxPositionSide}|${RdxPositionAlign}`,
    ConnectionPositionPair
>;
export type RdxArrowPositionParams = {
    top: string;
    left: string;
    transform: string;
    transformOrigin: string;
};



# ./core/src/positioning/constants.ts

import { RdxPositionAlign, RdxPositioningDefaults, RdxPositions, RdxPositionSide } from './types';

export const RDX_POSITIONS: RdxPositions = {
    [RdxPositionSide.Top]: {
        [RdxPositionAlign.Center]: {
            originX: 'center',
            originY: 'top',
            overlayX: 'center',
            overlayY: 'bottom'
        },
        [RdxPositionAlign.Start]: {
            originX: 'start',
            originY: 'top',
            overlayX: 'start',
            overlayY: 'bottom'
        },
        [RdxPositionAlign.End]: {
            originX: 'end',
            originY: 'top',
            overlayX: 'end',
            overlayY: 'bottom'
        }
    },
    [RdxPositionSide.Right]: {
        [RdxPositionAlign.Center]: {
            originX: 'end',
            originY: 'center',
            overlayX: 'start',
            overlayY: 'center'
        },
        [RdxPositionAlign.Start]: {
            originX: 'end',
            originY: 'top',
            overlayX: 'start',
            overlayY: 'top'
        },
        [RdxPositionAlign.End]: {
            originX: 'end',
            originY: 'bottom',
            overlayX: 'start',
            overlayY: 'bottom'
        }
    },
    [RdxPositionSide.Bottom]: {
        [RdxPositionAlign.Center]: {
            originX: 'center',
            originY: 'bottom',
            overlayX: 'center',
            overlayY: 'top'
        },
        [RdxPositionAlign.Start]: {
            originX: 'start',
            originY: 'bottom',
            overlayX: 'start',
            overlayY: 'top'
        },
        [RdxPositionAlign.End]: {
            originX: 'end',
            originY: 'bottom',
            overlayX: 'end',
            overlayY: 'top'
        }
    },
    [RdxPositionSide.Left]: {
        [RdxPositionAlign.Center]: {
            originX: 'start',
            originY: 'center',
            overlayX: 'end',
            overlayY: 'center'
        },
        [RdxPositionAlign.Start]: {
            originX: 'start',
            originY: 'top',
            overlayX: 'end',
            overlayY: 'top'
        },
        [RdxPositionAlign.End]: {
            originX: 'start',
            originY: 'bottom',
            overlayX: 'end',
            overlayY: 'bottom'
        }
    }
} as const;

export const RDX_POSITIONING_DEFAULTS: RdxPositioningDefaults = {
    offsets: {
        side: 4,
        align: 0
    },
    arrow: {
        width: 8,
        height: 6
    }
} as const;



# ./core/src/kbd-constants.ts

export const ALT = 'Alt';
export const ARROW_DOWN = 'ArrowDown';
export const ARROW_LEFT = 'ArrowLeft';
export const ARROW_RIGHT = 'ArrowRight';
export const ARROW_UP = 'ArrowUp';
export const BACKSPACE = 'Backspace';
export const CAPS_LOCK = 'CapsLock';
export const CONTROL = 'Control';
export const DELETE = 'Delete';
export const END = 'End';
export const ENTER = 'Enter';
export const ESCAPE = 'Escape';
export const F1 = 'F1';
export const F10 = 'F10';
export const F11 = 'F11';
export const F12 = 'F12';
export const F2 = 'F2';
export const F3 = 'F3';
export const F4 = 'F4';
export const F5 = 'F5';
export const F6 = 'F6';
export const F7 = 'F7';
export const F8 = 'F8';
export const F9 = 'F9';
export const HOME = 'Home';
export const META = 'Meta';
export const PAGE_DOWN = 'PageDown';
export const PAGE_UP = 'PageUp';
export const SHIFT = 'Shift';
export const SPACE = ' ';
export const TAB = 'Tab';
export const CTRL = 'Control';
export const ASTERISK = '*';
export const a = 'a';
export const P = 'P';
export const A = 'A';
export const p = 'p';
export const n = 'n';
export const j = 'j';
export const k = 'k';



# ./core/src/types.ts

/**
 * Nullable from `Type` adds `null` and `undefined`
 *
 * @example ```ts
 *  // Expect: string | number | undefined | null
 *  type Value = Nulling<string | number>;
 * ```
 */
export type Nullable<Type> = null | Type | undefined;

/**
 * SafeFunction is a type for functions that accept any number of arguments of unknown types
 * and return a value of an unknown type. This is useful when you want to define a function
 * without being strict about the input or output types, maintaining flexibility.
 *
 * @example ```ts
 *  const safeFn: SafeFunction = (...args) => {
 *    return args.length > 0 ? args[0] : null;
 *  };
 *
 *  const result = safeFn(1, 'hello'); // result: 1
 * ```
 */
export type SafeFunction = (...args: unknown[]) => unknown;



# ./core/src/is-number.ts

export const isNumber = (v: any): v is number => typeof v === 'number';



# ./core/src/is-client.ts

import { Platform } from '@angular/cdk/platform';
import { inject } from '@angular/core';

export function injectIsClient() {
    return inject(Platform).isBrowser;
}



# ./core/src/auto-focus.directive.ts

import { booleanAttribute, Directive, ElementRef, inject, Input, NgZone } from '@angular/core';

/*
 * <div [rdxAutoFocus]="true"></div>
 */

@Directive({
    selector: '[rdxAutoFocus]',
    standalone: true
})
export class RdxAutoFocusDirective {
    #elementRef = inject(ElementRef);
    #ngZone = inject(NgZone);

    private _autoSelect = false;

    /**
     * @default false
     */
    @Input({ alias: 'rdxAutoFocus', transform: booleanAttribute })
    set autoFocus(value: boolean) {
        if (value) {
            // Note: Running this outside Angular's zone because `element.focus()` does not trigger change detection.
            this.#ngZone.runOutsideAngular(() =>
                // Note: `element.focus()` causes re-layout which might lead to frame drops on slower devices.
                // https://gist.github.com/paulirish/5d52fb081b3570c81e3a#setting-focus
                // `setTimeout` is a macrotask executed within the current rendering frame.
                // Animation tasks are executed in the next rendering frame.
                reqAnimationFrame(() => {
                    this.#elementRef.nativeElement.focus();
                    if (this._autoSelect && this.#elementRef.nativeElement.select) {
                        this.#elementRef.nativeElement.select();
                    }
                })
            );
        }
    }

    // Setter for autoSelect attribute to enable text selection when autoFocus is true.
    @Input({ transform: booleanAttribute })
    set autoSelect(value: boolean) {
        this._autoSelect = value;
    }
}

const availablePrefixes = ['moz', 'ms', 'webkit'];

function requestAnimationFramePolyfill(): typeof requestAnimationFrame {
    let lastTime = 0;

    return function (callback: FrameRequestCallback): number {
        const currTime = new Date().getTime();
        const timeToCall = Math.max(0, 16 - (currTime - lastTime));

        const id = setTimeout(() => {
            callback(currTime + timeToCall);
        }, timeToCall) as any;

        lastTime = currTime + timeToCall;

        return id;
    };
}

// Function to get the appropriate requestAnimationFrame method with fallback to polyfill.
function getRequestAnimationFrame(): typeof requestAnimationFrame {
    if (typeof window === 'undefined') {
        return () => 0;
    }
    if (window.requestAnimationFrame) {
        // https://github.com/vuejs/vue/issues/4465
        return window.requestAnimationFrame.bind(window);
    }

    const prefix = availablePrefixes.filter((key) => `${key}RequestAnimationFrame` in window)[0];

    return prefix ? (window as any)[`${prefix}RequestAnimationFrame`] : requestAnimationFramePolyfill();
}

// Get the requestAnimationFrame function or its polyfill.
const reqAnimationFrame = getRequestAnimationFrame();



# ./core/src/window.ts

import { inject, InjectionToken } from '@angular/core';
import { injectDocument } from './document';

export const WINDOW = new InjectionToken<Window & typeof globalThis>('An abstraction over global window object', {
    factory: () => {
        const { defaultView } = injectDocument();
        if (!defaultView) {
            throw new Error('Window is not available');
        }
        return defaultView;
    }
});

export function injectWindow(): Window & typeof globalThis {
    return inject(WINDOW);
}



# ./menubar/README.md

# @radix-ng/primitives/menubar



# ./menubar/index.ts

import { NgModule } from '@angular/core';
import { RdxMenuBarContentDirective } from './src/menubar-content.directive';
import { RdxMenubarItemCheckboxDirective } from './src/menubar-item-checkbox.directive';
import { RdxMenubarItemIndicatorDirective } from './src/menubar-item-indicator.directive';
import { RdxMenubarItemRadioDirective } from './src/menubar-item-radio.directive';
import { RdxMenuBarItemDirective } from './src/menubar-item.directive';
import { RdxMenubarRadioGroupDirective } from './src/menubar-radio-group.directive';
import { RdxMenuBarRootDirective } from './src/menubar-root.directive';
import { RdxMenubarSeparatorDirective } from './src/menubar-separator.directive';
import { RdxMenuBarTriggerDirective } from './src/menubar-trigger.directive';

export * from './src/menubar-content.directive';
export * from './src/menubar-item-checkbox.directive';
export * from './src/menubar-item-indicator.directive';
export * from './src/menubar-item-radio.directive';
export * from './src/menubar-item.directive';
export * from './src/menubar-radio-group.directive';
export * from './src/menubar-root.directive';
export * from './src/menubar-separator.directive';
export * from './src/menubar-trigger.directive';

const menubarImports = [
    RdxMenuBarContentDirective,
    RdxMenuBarTriggerDirective,
    RdxMenubarSeparatorDirective,
    RdxMenubarItemCheckboxDirective,
    RdxMenuBarRootDirective,
    RdxMenuBarItemDirective,
    RdxMenubarItemIndicatorDirective,
    RdxMenubarItemRadioDirective,
    RdxMenubarRadioGroupDirective
];

@NgModule({
    imports: [...menubarImports],
    exports: [...menubarImports]
})
export class MenubarModule {}



# ./menubar/src/menubar-item.directive.ts

import { Directive } from '@angular/core';
import { RdxMenuItemDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarItem]',
    hostDirectives: [
        {
            directive: RdxMenuItemDirective,
            inputs: ['disabled'],
            outputs: ['onSelect']
        }
    ]
})
export class RdxMenuBarItemDirective {}



# ./menubar/src/menubar-group.directive.ts

import { Directive } from '@angular/core';
import { RdxMenuGroupDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarGroup]',
    hostDirectives: [RdxMenuGroupDirective]
})
export class RdxMenubarGroupDirective {}



# ./menubar/src/menubar-trigger.directive.ts

import { Directive } from '@angular/core';
import { RdxMenuTriggerDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarTrigger]',
    hostDirectives: [
        {
            directive: RdxMenuTriggerDirective,
            inputs: [
                'disabled',
                'menuTriggerFor',
                'sideOffset',
                'side',
                'align',
                'alignOffset'
            ]
        }
    ]
})
export class RdxMenuBarTriggerDirective {}



# ./menubar/src/menubar-content.directive.ts

import { Directive } from '@angular/core';
import { RdxMenuContentDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarContent]',
    hostDirectives: [RdxMenuContentDirective]
})
export class RdxMenuBarContentDirective {}



# ./menubar/src/menubar-radio-group.directive.ts

import { CdkMenuGroup } from '@angular/cdk/menu';
import { Directive } from '@angular/core';

@Directive({
    selector: '[RdxMenuBarRadioGroup]',
    hostDirectives: [CdkMenuGroup]
})
export class RdxMenubarRadioGroupDirective {}



# ./menubar/src/menubar-item-radio.directive.ts

import { Directive } from '@angular/core';
import { RdxMenuItemRadioDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarItemRadio]',
    hostDirectives: [
        {
            directive: RdxMenuItemRadioDirective,
            inputs: ['disabled', 'checked']
        }
    ]
})
export class RdxMenubarItemRadioDirective {}



# ./menubar/src/menubar-root.directive.ts

import { CdkMenuBar } from '@angular/cdk/menu';
import { Directive } from '@angular/core';

@Directive({
    selector: '[RdxMenuBarRoot]',
    hostDirectives: [CdkMenuBar],
    host: {
        tabindex: '0',
        '[attr.data-orientation]': '"horizontal"'
    }
})
export class RdxMenuBarRootDirective {}



# ./menubar/src/menubar-separator.directive.ts

import { Directive } from '@angular/core';
import { RdxMenuSeparatorDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarSeparator]',
    hostDirectives: [RdxMenuSeparatorDirective]
})
export class RdxMenubarSeparatorDirective {}



# ./menubar/src/menubar-item-checkbox.directive.ts

import { Directive } from '@angular/core';
import { RdxMenuItemCheckboxDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarCheckboxItem]',
    hostDirectives: [
        {
            directive: RdxMenuItemCheckboxDirective,
            inputs: ['checked', 'disabled']
        }
    ]
})
export class RdxMenubarItemCheckboxDirective {}



# ./menubar/src/menubar-item-indicator.directive.ts

import { Directive } from '@angular/core';
import { RdxMenuItemIndicatorDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarItemIndicator]',
    hostDirectives: [RdxMenuItemIndicatorDirective]
})
export class RdxMenubarItemIndicatorDirective {}



# ./progress/__test__/progress.spec.ts

import { Component } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RdxProgressIndicatorDirective } from '../src/progress-indicator.directive';
import { RdxProgressRootDirective } from '../src/progress-root.directive';

@Component({
    template: `
        <div [id]="id" [value]="value" [max]="max" rdxProgressRoot>
            <div rdxProgressIndicator></div>
        </div>
    `,
    imports: [RdxProgressRootDirective, RdxProgressIndicatorDirective]
})
class TestHostComponent {
    value = 50;
    max = 100;
    id = 'test-progress';
}

describe('RdxProgress', () => {
    let component: TestHostComponent;
    let fixture: ComponentFixture<TestHostComponent>;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [TestHostComponent]
        }).compileComponents();

        fixture = TestBed.createComponent(TestHostComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should set the correct aria attributes and data attributes', () => {
        const progressElement: HTMLElement = fixture.nativeElement.querySelector('div[role="progressbar"]');

        expect(progressElement.getAttribute('aria-valuemax')).toBe('100');
        expect(progressElement.getAttribute('aria-valuemin')).toBe('0');
        expect(progressElement.getAttribute('aria-valuenow')).toBe('50');
        expect(progressElement.getAttribute('aria-valuetext')).toBe('50%');
        expect(progressElement.getAttribute('data-state')).toBe('loading');
        expect(progressElement.getAttribute('data-value')).toBe('50');
        expect(progressElement.getAttribute('data-max')).toBe('100');
        expect(progressElement.id).toBe('test-progress');
    });

    it('should show complete state when value equals max', () => {
        component.value = 100;
        fixture.detectChanges();

        const progressElement: HTMLElement = fixture.nativeElement.querySelector('div[role="progressbar"]');

        expect(progressElement.getAttribute('data-state')).toBe('complete');
    });
});



# ./progress/README.md

# @radix-ng/primitives/progress

Secondary entry point of `@radix-ng/primitives`.



# ./progress/index.ts

import { NgModule } from '@angular/core';
import { RdxProgressIndicatorDirective } from './src/progress-indicator.directive';
import { RdxProgressRootDirective } from './src/progress-root.directive';

export * from './src/progress-indicator.directive';
export * from './src/progress-root.directive';

export type { ProgressProps } from './src/progress-root.directive';

const _imports = [
    RdxProgressRootDirective,
    RdxProgressIndicatorDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxProgressModule {}



# ./progress/src/progress-root.directive.ts

import { computed, Directive, effect, inject, InjectionToken, input, model } from '@angular/core';
import { isNullish, isNumber } from '@radix-ng/primitives/core';

export const RdxProgressToken = new InjectionToken<RdxProgressRootDirective>('RdxProgressDirective');

/**
 * Injects the current instance of RdxProgressRootDirective.
 * @returns The instance of RdxProgressRootDirective.
 */
export function injectProgress(): RdxProgressRootDirective {
    return inject(RdxProgressToken);
}

export type ProgressState = 'indeterminate' | 'complete' | 'loading';

export interface ProgressProps {
    value?: number | null;
    max?: number;
    /**
     * A function to get the accessible label text representing the current value in a human-readable format.
     *
     *  If not provided, the value label will be read as the numeric value as a percentage of the max value.
     */
    getValueLabel?: (value: number, max: number) => string;
}

const MIN_PERCENT = 0;
const DEFAULT_MAX = 100;

/**
 * Directive to manage progress bar state and attributes.
 *
 * This directive provides a way to create a progress bar with customizable value and max attributes.
 * It handles aria attributes for accessibility and provides different states like 'indeterminate', 'complete', and 'loading'.
 *
 * @group Components
 */
@Directive({
    selector: '[rdxProgressRoot]',
    exportAs: 'rdxProgressRoot',
    providers: [{ provide: RdxProgressToken, useExisting: RdxProgressRootDirective }],
    host: {
        role: 'progressbar',
        '[attr.aria-valuemax]': 'max()',
        '[attr.aria-valuemin]': '0',
        '[attr.aria-valuenow]': 'value()',
        '[attr.aria-valuetext]': 'label()',
        '[attr.aria-label]': 'label()',
        '[attr.data-state]': 'progressState()',
        '[attr.data-value]': 'value() ?? undefined',
        '[attr.data-max]': 'max()',
        // set tab index to -1 so screen readers will read the aria-label
        // Note: there is a known issue with JAWS that does not read progressbar aria labels on FireFox
        tabindex: '-1'
    }
})
export class RdxProgressRootDirective {
    /**
     * The current value of the progress bar.
     * @group Props
     * @defaultValue 0
     */
    readonly value = model<number>(MIN_PERCENT);

    /**
     * The maximum value of the progress bar.
     * @defaultValue 100
     * @group Props
     */
    readonly max = model<number>(DEFAULT_MAX);

    /**
     * Function to generate the value label.
     * @group Props
     */
    readonly valueLabel = input<(value: number, max: number) => string>((value, max) =>
        this.defaultGetValueLabel(value, max)
    );

    protected readonly label = computed(() => this.valueLabel()(this.value(), this.max()));

    readonly progressState = computed<ProgressState>(() => {
        if (isNullish(this.value())) {
            return 'indeterminate';
        }
        if (this.value() === this.max()) {
            return 'complete';
        }
        return 'loading';
    });

    constructor() {
        effect(() => {
            const correctedValue = this.validateValue(this.value(), this.max());
            if (correctedValue != null && correctedValue !== this.value()) {
                this.value.set(correctedValue);
            }
        });

        effect(() => {
            const correctedMax = this.validateMax(this.max());
            if (correctedMax !== this.max()) {
                this.max.set(correctedMax);
            }
        });
    }

    private validateValue(value: any, max: number): number | null {
        const isValidValueError =
            isNullish(value) || (isNumber(value) && !Number.isNaN(value) && value <= max && value >= 0);

        if (isValidValueError) return value as null;

        console.error(`Invalid prop \`value\` of value \`${value}\` supplied to \`ProgressRoot\`. The \`value\` prop must be:
  - a positive number
  - less than the value passed to \`max\` (or ${DEFAULT_MAX} if no \`max\` prop is set)
  - \`null\`  or \`undefined\` if the progress is indeterminate.

Defaulting to \`null\`.`);
        return null;
    }

    private validateMax(max: number): number {
        const isValidMaxError = isNumber(max) && !Number.isNaN(max) && max > 0;

        if (isValidMaxError) return max;

        console.error(
            `Invalid prop \`max\` of value \`${max}\` supplied to \`ProgressRoot\`. Only numbers greater than 0 are valid max values. Defaulting to \`${DEFAULT_MAX}\`.`
        );
        return DEFAULT_MAX;
    }

    private defaultGetValueLabel(value: number, max: number) {
        return `${Math.round((value / max) * 100)}%`;
    }
}



# ./progress/src/progress-indicator.directive.ts

import { Directive } from '@angular/core';
import { injectProgress } from './progress-root.directive';

/**
 * Directive to manage progress indicator state and attributes.
 *
 * This directive is used to display the progress indicator inside the progress bar.
 * It inherits the state and value from the `RdxProgressRootDirective`.
 */
@Directive({
    selector: '[rdxProgressIndicator]',
    exportAs: 'rdxProgressIndicator',
    host: {
        '[attr.data-state]': 'progress.progressState()',
        '[attr.data-value]': 'progress.value()',
        '[attr.data-max]': 'progress.max()'
    }
})
export class RdxProgressIndicatorDirective {
    /**
     * This allows the directive to access the progress bar state and values.
     */
    protected readonly progress = injectProgress();
}



# ./alert-dialog/README.md

# @radix-ng/primitives/alert-dialog



# ./alert-dialog/index.ts

import { NgModule } from '@angular/core';
import { RdxAlertDialogCancelDirective } from './src/alert-dialog-cancel.directive';
import { RdxAlertDialogContentDirective } from './src/alert-dialog-content.directive';
import { RdxAlertDialogRootDirective } from './src/alert-dialog-root.directive';
import { RdxAlertDialogTitleDirective } from './src/alert-dialog-title.directive';
import { RdxAlertDialogTriggerDirective } from './src/alert-dialog-trigger.directive';

export * from './src/alert-dialog-cancel.directive';
export * from './src/alert-dialog-content.directive';
export * from './src/alert-dialog-root.directive';
export * from './src/alert-dialog-title.directive';
export * from './src/alert-dialog-trigger.directive';

export * from './src/alert-dialog.service';

const _imports = [
    RdxAlertDialogRootDirective,
    RdxAlertDialogContentDirective,
    RdxAlertDialogCancelDirective,
    RdxAlertDialogTriggerDirective,
    RdxAlertDialogTitleDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxAlertDialogModule {}



# ./alert-dialog/src/alert-dialog-cancel.directive.ts

import { Directive, inject } from '@angular/core';
import { RdxAlertDialogService } from './alert-dialog.service';

@Directive({
    selector: '[rdxAlertDialogCancel]',
    standalone: true,
    host: {
        '(click)': 'onClick()'
    }
})
export class RdxAlertDialogCancelDirective {
    private readonly alertDialogService = inject(RdxAlertDialogService);

    onClick() {
        this.alertDialogService.close();
    }
}



# ./alert-dialog/src/alert-dialog-trigger.directive.ts

import { Directive, inject } from '@angular/core';
import { RdxAlertDialogService } from './alert-dialog.service';

@Directive({
    selector: '[rdxAlertDialogTrigger]',
    standalone: true,
    host: {
        '(click)': 'handleClick()'
    }
})
export class RdxAlertDialogTriggerDirective {
    private readonly alertDialogService = inject(RdxAlertDialogService);

    handleClick() {
        this.alertDialogService.open();
    }
}



# ./alert-dialog/src/alert-dialog-content.directive.ts

import { CdkTrapFocus } from '@angular/cdk/a11y';
import { Directive, ElementRef, inject, Input, Renderer2 } from '@angular/core';

@Directive({
    selector: '[rdxAlertDialogContent]',
    standalone: true,
    hostDirectives: [
        {
            directive: CdkTrapFocus
        }
    ],
    host: {
        '[attr.data-state]': '"open"',
        '[attr.cdkTrapFocusAutoCapture]': 'true'
    }
})
export class RdxAlertDialogContentDirective {
    private readonly renderer = inject(Renderer2);
    private readonly elementRef = inject(ElementRef);

    @Input() set maxWidth(value: string) {
        this.renderer.setStyle(this.elementRef.nativeElement, 'maxWidth', value);
    }
}



# ./alert-dialog/src/alert-dialog.service.ts

import { Overlay, OverlayRef } from '@angular/cdk/overlay';
import { TemplatePortal } from '@angular/cdk/portal';
import { Injectable, TemplateRef, ViewContainerRef } from '@angular/core';

@Injectable({
    providedIn: 'root'
})
export class RdxAlertDialogService {
    private overlayRef: OverlayRef | null | undefined;
    private dialogContent:
        | {
              viewContainerRef: ViewContainerRef;
              template: TemplateRef<any>;
          }
        | undefined;

    constructor(private overlay: Overlay) {}

    setDialogContent(viewContainerRef: ViewContainerRef, template: TemplateRef<any>) {
        this.dialogContent = { viewContainerRef, template };
    }

    open() {
        if (!this.dialogContent) {
            throw new Error('Dialog content is not set');
        }

        this.overlayRef = this.overlay.create({
            hasBackdrop: true,
            backdropClass: 'cdk-overlay-dark-backdrop',
            positionStrategy: this.overlay.position().global().centerHorizontally().centerVertically()
        });

        const templatePortal = new TemplatePortal(this.dialogContent.template, this.dialogContent.viewContainerRef);
        this.overlayRef.attach(templatePortal);

        this.overlayRef.keydownEvents().subscribe((event) => {
            if (event.key === 'Escape' || event.code === 'Escape') {
                this.close();
            }
        });
        this.overlayRef.backdropClick().subscribe(() => this.close());
    }

    close() {
        if (this.overlayRef) {
            this.overlayRef.dispose();
            this.overlayRef = null;
        }
    }
}



# ./alert-dialog/src/alert-dialog-root.directive.ts

import { Directive, inject, Input, TemplateRef, ViewContainerRef } from '@angular/core';
import { RdxAlertDialogService } from './alert-dialog.service';

@Directive({
    selector: '[rdxAlertDialogRoot]',
    standalone: true
})
export class RdxAlertDialogRootDirective {
    private readonly viewContainerRef = inject(ViewContainerRef);
    private readonly alertDialogService = inject(RdxAlertDialogService);

    @Input() set content(template: TemplateRef<any>) {
        this.alertDialogService.setDialogContent(this.viewContainerRef, template);
    }
}



# ./alert-dialog/src/alert-dialog-title.directive.ts

import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxAlertDialogTitle]',
    standalone: true
})
export class RdxAlertDialogTitleDirective {}



# ./roving-focus/__test__/roving-focus-group.spec.ts

import { Component } from '@angular/core';
import { fakeAsync, TestBed, tick } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { RdxRovingFocusGroupDirective } from '@radix-ng/primitives/roving-focus';

@Component({
    selector: 'test-host',
    standalone: true,
    template: `
        <div rdxRovingFocusGroup>
            <button id="item1">Item 1</button>
            <button id="item2">Item 2</button>
            <button id="item3">Item 3</button>
        </div>
    `,
    imports: [RdxRovingFocusGroupDirective]
})
class TestHostComponent {}

describe('RdxRovingFocusGroupDirective', () => {
    beforeEach(() => {
        TestBed.configureTestingModule({
            imports: [TestHostComponent]
        });
    });

    it('should create the directive', () => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const hostElement = fixture.nativeElement.querySelector('[rdxRovingFocusGroup]');
        expect(hostElement).toBeTruthy();
    });

    it('should correctly handle focus logic', () => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const hostElement = fixture.nativeElement.querySelector('[rdxRovingFocusGroup]');
        const buttons = hostElement.querySelectorAll('button');

        // Simulate focus on the first button
        buttons[0].focus();
        expect(document.activeElement).toBe(buttons[0]);

        // Simulate navigation to the second button
        buttons[1].focus();
        expect(document.activeElement).toBe(buttons[1]);
    });

    it('should handle `onItemFocus` and update currentTabStopId', () => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const directiveInstance = fixture.debugElement
            .query(By.directive(RdxRovingFocusGroupDirective))
            .injector.get(RdxRovingFocusGroupDirective);

        directiveInstance.onItemFocus('item1');
        expect(directiveInstance.currentTabStopId()).toBe('item1');

        directiveInstance.onItemFocus('item2');
        expect(directiveInstance.currentTabStopId()).toBe('item2');
    });

    it('should emit currentTabStopIdChange on item focus', () => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const directiveInstance = fixture.debugElement
            .query(By.directive(RdxRovingFocusGroupDirective))
            .injector.get(RdxRovingFocusGroupDirective);

        const spy = jest.spyOn(directiveInstance.currentTabStopIdChange, 'emit');

        directiveInstance.onItemFocus('item1');
        expect(spy).toHaveBeenCalledWith('item1');
    });

    it('should register and unregister focusable items correctly', () => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const directiveInstance = fixture.debugElement
            .query(By.directive(RdxRovingFocusGroupDirective))
            .injector.get(RdxRovingFocusGroupDirective);

        const item = document.createElement('div');
        directiveInstance.registerItem(item);
        expect(directiveInstance.focusableItems()).toContain(item);

        directiveInstance.unregisterItem(item);
        expect(directiveInstance.focusableItems()).not.toContain(item);
    });

    it('should handle `onFocusableItemAdd` and `onFocusableItemRemove` correctly', () => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const directiveInstance = fixture.debugElement
            .query(By.directive(RdxRovingFocusGroupDirective))
            .injector.get(RdxRovingFocusGroupDirective);

        directiveInstance.onFocusableItemAdd();
        expect(directiveInstance.getFocusableItemsCount()).toBe(1);

        directiveInstance.onFocusableItemRemove();
        expect(directiveInstance.getFocusableItemsCount()).toBe(0);
    });

    it('should handle `handleMouseDown` and set `isClickFocus` indirectly', () => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const directiveInstance = fixture.debugElement
            .query(By.directive(RdxRovingFocusGroupDirective))
            .injector.get(RdxRovingFocusGroupDirective);

        directiveInstance.handleMouseDown();

        // Use the public behavior to infer the private state change
        // For example, call a method that uses isClickFocus.
        expect(directiveInstance['isClickFocus']()).toBe(true);
    });

    it('should reset `isClickFocus` on mouse up', fakeAsync(() => {
        const fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const directiveInstance = fixture.debugElement
            .query(By.directive(RdxRovingFocusGroupDirective))
            .injector.get(RdxRovingFocusGroupDirective);

        directiveInstance.handleMouseDown();
        directiveInstance.handleMouseUp();

        tick();

        expect(directiveInstance['isClickFocus']()).toBe(false);
    }));
});



# ./roving-focus/README.md

# @radix-ng/primitives/roving-focus

Secondary entry point of `@radix-ng/primitives`.



# ./roving-focus/index.ts

export * from './src/roving-focus-group.directive';
export * from './src/roving-focus-item.directive';

export type { Direction, Orientation } from './src/utils';



# ./roving-focus/src/roving-focus-group.directive.ts

import {
    booleanAttribute,
    Directive,
    ElementRef,
    EventEmitter,
    inject,
    Input,
    NgZone,
    Output,
    signal
} from '@angular/core';
import { Direction, ENTRY_FOCUS, EVENT_OPTIONS, focusFirst, Orientation } from './utils';

@Directive({
    selector: '[rdxRovingFocusGroup]',
    standalone: true,
    host: {
        '[attr.data-orientation]': 'dataOrientation',
        '[attr.tabindex]': 'tabIndex',
        '[attr.dir]': 'dir',
        '(focus)': 'handleFocus($event)',
        '(blur)': 'handleBlur()',
        '(mouseup)': 'handleMouseUp()',
        '(mousedown)': 'handleMouseDown()',
        style: 'outline: none;'
    }
})
export class RdxRovingFocusGroupDirective {
    private readonly ngZone = inject(NgZone);
    private readonly elementRef = inject(ElementRef);

    @Input() orientation: Orientation | undefined;
    @Input() dir: Direction = 'ltr';
    @Input({ transform: booleanAttribute }) loop: boolean = true;
    @Input({ transform: booleanAttribute }) preventScrollOnEntryFocus: boolean = false;

    @Output() entryFocus = new EventEmitter<Event>();
    @Output() currentTabStopIdChange = new EventEmitter<string | null>();

    /** @ignore */
    readonly currentTabStopId = signal<string | null>(null);

    /** @ignore */
    readonly focusableItems = signal<HTMLElement[]>([]);

    private readonly isClickFocus = signal(false);
    private readonly isTabbingBackOut = signal(false);
    private readonly focusableItemsCount = signal(0);

    /** @ignore */
    get dataOrientation() {
        return this.orientation || 'horizontal';
    }

    /** @ignore */
    get tabIndex() {
        return this.isTabbingBackOut() || this.getFocusableItemsCount() === 0 ? -1 : 0;
    }

    /** @ignore */
    handleBlur() {
        this.isTabbingBackOut.set(false);
    }

    /** @ignore */
    handleMouseUp() {
        // reset `isClickFocus` after 1 tick because handleFocus might not triggered due to focused element
        this.ngZone.runOutsideAngular(() => {
            // eslint-disable-next-line promise/catch-or-return,promise/always-return
            Promise.resolve().then(() => {
                this.ngZone.run(() => {
                    this.isClickFocus.set(false);
                });
            });
        });
    }

    /** @ignore */
    handleFocus(event: FocusEvent) {
        // We normally wouldn't need this check, because we already check
        // that the focus is on the current target and not bubbling to it.
        // We do this because Safari doesn't focus buttons when clicked, and
        // instead, the wrapper will get focused and not through a bubbling event.
        const isKeyboardFocus = !this.isClickFocus();

        if (
            event.currentTarget === this.elementRef.nativeElement &&
            event.target === event.currentTarget &&
            isKeyboardFocus &&
            !this.isTabbingBackOut()
        ) {
            const entryFocusEvent = new CustomEvent(ENTRY_FOCUS, EVENT_OPTIONS);
            this.elementRef.nativeElement.dispatchEvent(entryFocusEvent);
            this.entryFocus.emit(entryFocusEvent);

            if (!entryFocusEvent.defaultPrevented) {
                const items = this.focusableItems().filter((item) => item.dataset['disabled'] !== '');
                const activeItem = items.find((item) => item.getAttribute('data-active') === 'true');
                const currentItem = items.find((item) => item.id === this.currentTabStopId());
                const candidateItems = [activeItem, currentItem, ...items].filter(Boolean) as HTMLElement[];

                focusFirst(candidateItems, this.preventScrollOnEntryFocus);
            }
        }
        this.isClickFocus.set(false);
    }

    /** @ignore */
    handleMouseDown() {
        this.isClickFocus.set(true);
    }

    /** @ignore */
    onItemFocus(tabStopId: string) {
        this.currentTabStopId.set(tabStopId);
        this.currentTabStopIdChange.emit(tabStopId);
    }

    /** @ignore */
    onItemShiftTab() {
        this.isTabbingBackOut.set(true);
    }

    /** @ignore */
    onFocusableItemAdd() {
        this.focusableItemsCount.update((count) => count + 1);
    }

    /** @ignore */
    onFocusableItemRemove() {
        this.focusableItemsCount.update((count) => Math.max(0, count - 1));
    }

    /** @ignore */
    registerItem(item: HTMLElement) {
        const currentItems = this.focusableItems();
        this.focusableItems.set([...currentItems, item]);
    }

    /** @ignore */
    unregisterItem(item: HTMLElement) {
        const currentItems = this.focusableItems();
        this.focusableItems.set(currentItems.filter((el) => el !== item));
    }

    /** @ignore */
    getFocusableItemsCount() {
        return this.focusableItemsCount();
    }
}



# ./roving-focus/src/utils.ts

export type Orientation = 'horizontal' | 'vertical';
export type Direction = 'ltr' | 'rtl';

export const ENTRY_FOCUS = 'rovingFocusGroup.onEntryFocus';
export const EVENT_OPTIONS = { bubbles: false, cancelable: true };

type FocusIntent = 'first' | 'last' | 'prev' | 'next';

export const MAP_KEY_TO_FOCUS_INTENT: Record<string, FocusIntent> = {
    ArrowLeft: 'prev',
    ArrowUp: 'prev',
    ArrowRight: 'next',
    ArrowDown: 'next',
    PageUp: 'first',
    Home: 'first',
    PageDown: 'last',
    End: 'last'
};

export function getDirectionAwareKey(key: string, dir?: Direction) {
    if (dir !== 'rtl') return key;
    return key === 'ArrowLeft' ? 'ArrowRight' : key === 'ArrowRight' ? 'ArrowLeft' : key;
}

export function getFocusIntent(event: KeyboardEvent, orientation?: Orientation, dir?: Direction) {
    const key = getDirectionAwareKey(event.key, dir);
    if (orientation === 'vertical' && ['ArrowLeft', 'ArrowRight'].includes(key)) return undefined;
    if (orientation === 'horizontal' && ['ArrowUp', 'ArrowDown'].includes(key)) return undefined;
    return MAP_KEY_TO_FOCUS_INTENT[key];
}

export function focusFirst(candidates: HTMLElement[], preventScroll = false, rootNode?: Document | ShadowRoot) {
    const PREVIOUSLY_FOCUSED_ELEMENT = rootNode?.activeElement ?? document.activeElement;
    for (const candidate of candidates) {
        // if focus is already where we want to go, we don't want to keep going through the candidates
        if (candidate === PREVIOUSLY_FOCUSED_ELEMENT) return;
        candidate.focus({ preventScroll });
        if (document.activeElement !== PREVIOUSLY_FOCUSED_ELEMENT) return;
    }
}

/**
 * Wraps an array around itself at a given start index
 * Example: `wrapArray(['a', 'b', 'c', 'd'], 2) === ['c', 'd', 'a', 'b']`
 */
export function wrapArray<T>(array: T[], startIndex: number) {
    return array.map((_, index) => array[(startIndex + index) % array.length]);
}

export function generateId(): string {
    return `rf-item-${Math.random().toString(36).slice(2, 11)}`;
}



# ./roving-focus/src/roving-focus-item.directive.ts

import {
    booleanAttribute,
    computed,
    Directive,
    ElementRef,
    inject,
    Input,
    NgZone,
    OnDestroy,
    OnInit
} from '@angular/core';
import { RdxRovingFocusGroupDirective } from './roving-focus-group.directive';
import { focusFirst, generateId, getFocusIntent, wrapArray } from './utils';

@Directive({
    selector: '[rdxRovingFocusItem]',
    standalone: true,
    host: {
        '[attr.tabindex]': 'tabIndex',
        '[attr.data-orientation]': 'parent.orientation',
        '[attr.data-active]': 'active',
        '[attr.data-disabled]': '!focusable ? "" : undefined',
        '(mousedown)': 'handleMouseDown($event)',
        '(keydown)': 'handleKeydown($event)',
        '(focus)': 'onFocus()'
    }
})
export class RdxRovingFocusItemDirective implements OnInit, OnDestroy {
    private readonly elementRef = inject(ElementRef);
    private readonly ngZone = inject(NgZone);
    protected readonly parent = inject(RdxRovingFocusGroupDirective);

    @Input({ transform: booleanAttribute }) focusable: boolean = true;
    @Input({ transform: booleanAttribute }) active: boolean = true;
    @Input() tabStopId: string;
    @Input({ transform: booleanAttribute }) allowShiftKey: boolean = false;

    private readonly id = computed(() => this.tabStopId || generateId());

    /** @ignore */
    readonly isCurrentTabStop = computed(() => this.parent.currentTabStopId() === this.id());

    /**
     * Lifecycle hook triggered on initialization.
     * Registers the element with the parent roving focus group if it is focusable.
     * @ignore
     */
    ngOnInit() {
        if (this.focusable) {
            this.parent.registerItem(this.elementRef.nativeElement);
            this.parent.onFocusableItemAdd();
        }
    }

    /**
     * Lifecycle hook triggered on destruction.
     * Unregisters the element from the parent roving focus group if it is focusable.
     * @ignore
     */
    ngOnDestroy() {
        if (this.focusable) {
            this.parent.unregisterItem(this.elementRef.nativeElement);
            this.parent.onFocusableItemRemove();
        }
    }

    /**
     * Determines the `tabIndex` of the element.
     * Returns `0` if the element is the current tab stop; otherwise, returns `-1`.
     * @ignore
     */
    get tabIndex() {
        return this.isCurrentTabStop() ? 0 : -1;
    }

    /** @ignore */
    handleMouseDown(event: MouseEvent) {
        if (!this.focusable) {
            // We prevent focusing non-focusable items on `mousedown`.
            // Even though the item has tabIndex={-1}, that only means take it out of the tab order.
            event.preventDefault();
        } else {
            // Safari doesn't focus a button when clicked so we run our logic on mousedown also
            this.parent.onItemFocus(this.id());
        }
    }

    /** @ignore */
    onFocus() {
        this.parent.onItemFocus(this.id());
    }

    /**
     * Handles the `keydown` event for keyboard navigation within the roving focus group.
     * Supports navigation based on orientation and direction, and focuses appropriate elements.
     *
     * @param event The `KeyboardEvent` object.
     * @ignore
     */
    handleKeydown(event: KeyboardEvent) {
        if (event.key === 'Tab' && event.shiftKey) {
            this.parent.onItemShiftTab();
            return;
        }

        if (event.target !== this.elementRef.nativeElement) return;

        const focusIntent = getFocusIntent(event, this.parent.orientation, this.parent.dir);

        if (focusIntent !== undefined) {
            if (event.metaKey || event.ctrlKey || event.altKey || (this.allowShiftKey ? false : event.shiftKey)) {
                return;
            }

            event.preventDefault();

            let candidateNodes = this.parent.focusableItems().filter((item) => item.dataset['disabled'] !== '');

            if (focusIntent === 'last') {
                candidateNodes.reverse();
            } else if (focusIntent === 'prev' || focusIntent === 'next') {
                if (focusIntent === 'prev') candidateNodes.reverse();
                const currentIndex = candidateNodes.indexOf(this.elementRef.nativeElement);

                candidateNodes = this.parent.loop
                    ? wrapArray(candidateNodes, currentIndex + 1)
                    : candidateNodes.slice(currentIndex + 1);
            }

            this.ngZone.runOutsideAngular(() => {
                // eslint-disable-next-line promise/always-return,promise/catch-or-return
                Promise.resolve().then(() => {
                    focusFirst(candidateNodes, false, this.elementRef.nativeElement);
                });
            });
        }
    }
}



# ./config/ng-package.json

{
    "lib": {
        "entryFile": "index.ts"
    }
}



# ./config/index.ts

export * from './src/config';
export * from './src/config.provider';



# ./config/src/config.ts

import { Direction } from '@angular/cdk/bidi';
import { Injectable, signal } from '@angular/core';

export type RadixNGConfig = {
    /**
     * The global reading direction of your application. This will be inherited by all primitives.
     * @defaultValue 'ltr'
     */
    dir?: Direction;

    /**
     * The global locale of your application. This will be inherited by all primitives.
     * @defaultValue 'en'
     */
    locale?: string;
};

@Injectable({ providedIn: 'root' })
export class RadixNG {
    readonly dir = signal<Direction>('ltr');

    readonly locale = signal<string>('en');

    setConfig(config: RadixNGConfig): void {
        const { dir, locale } = config || {};

        if (dir) this.dir.set(dir);
        if (locale) this.locale.set(locale);
    }
}



# ./config/src/config.provider.ts

import {
    EnvironmentProviders,
    inject,
    InjectionToken,
    makeEnvironmentProviders,
    provideAppInitializer
} from '@angular/core';
import { RadixNG, type RadixNGConfig } from './config';

export const RADIX_NG_CONFIG = new InjectionToken<RadixNGConfig>('RADIX_NG_CONFIG');

/**
 * Provides RadixNG configuration as environment providers.
 *
 * @param features One or more RadixNG configuration objects.
 * @returns A set of environment providers that register the RadixNG configs.
 */
export function provideRadixNG(...features: RadixNGConfig[]): EnvironmentProviders {
    const providers = features?.map((feature) => ({
        provide: RADIX_NG_CONFIG,
        useValue: feature,
        multi: false
    }));

    /**
     * Creates an AppInitializer to load and apply each RadixNG configuration
     * to the global RadixNG service before the app starts.
     */
    const initializer = provideAppInitializer(() => {
        const config = inject(RadixNG);
        features?.forEach((feature) => config.setConfig(feature));
        return;
    });

    return makeEnvironmentProviders([...providers, initializer]);
}



# ./accordion/README.md

# @radix-ng/primitives/accordion



# ./accordion/__tests__/accordion-root.directive.spec.ts

import { RdxAccordionRootDirective } from '../src/accordion-root.directive';

xdescribe('RdxAccordionRootDirective', () => {
    it('should create an instance', () => {
        const directive = new RdxAccordionRootDirective();
        expect(directive).toBeTruthy();
    });
});



# ./accordion/__tests__/accordion-content.directive.spec.ts

import { RdxAccordionContentDirective } from '../src/accordion-content.directive';

xdescribe('RdxAccordionContentDirective', () => {
    it('should create an instance', () => {
        const directive = new RdxAccordionContentDirective();
        expect(directive).toBeTruthy();
    });
});



# ./accordion/__tests__/accordion-trigger.directive.spec.ts

import { RdxAccordionTriggerDirective } from '../src/accordion-trigger.directive';

xdescribe('RdxAccordionTriggerDirective', () => {
    it('should create an instance', () => {
        const directive = new RdxAccordionTriggerDirective();
        expect(directive).toBeTruthy();
    });
});



# ./accordion/__tests__/accordion-header.directive.spec.ts

import { RdxAccordionHeaderDirective } from '../src/accordion-header.directive';

xdescribe('RdxAccordionHeaderDirective', () => {
    it('should create an instance', () => {
        const directive = new RdxAccordionHeaderDirective();
        expect(directive).toBeTruthy();
    });
});



# ./accordion/__tests__/accordion-item.directive.spec.ts

import { RdxAccordionItemDirective } from '../src/accordion-item.directive';

xdescribe('RdxAccordionItemDirective', () => {
    it('should create an instance', () => {
        const directive = new RdxAccordionItemDirective();
        expect(directive).toBeTruthy();
    });
});



# ./accordion/index.ts

import { NgModule } from '@angular/core';
import { RdxAccordionContentDirective } from './src/accordion-content.directive';
import { RdxAccordionHeaderDirective } from './src/accordion-header.directive';
import { RdxAccordionItemDirective } from './src/accordion-item.directive';
import { RdxAccordionRootDirective } from './src/accordion-root.directive';
import { RdxAccordionTriggerDirective } from './src/accordion-trigger.directive';

export * from './src/accordion-content.directive';
export * from './src/accordion-header.directive';
export * from './src/accordion-item.directive';
export * from './src/accordion-root.directive';
export * from './src/accordion-trigger.directive';

const _imports = [
    RdxAccordionContentDirective,
    RdxAccordionHeaderDirective,
    RdxAccordionItemDirective,
    RdxAccordionRootDirective,
    RdxAccordionTriggerDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxAccordionModule {}



# ./accordion/src/accordion-item.directive.ts

import { FocusableOption } from '@angular/cdk/a11y';
import { UniqueSelectionDispatcher } from '@angular/cdk/collections';
import {
    booleanAttribute,
    ChangeDetectorRef,
    ContentChild,
    Directive,
    EventEmitter,
    forwardRef,
    inject,
    Input,
    OnDestroy,
    Output
} from '@angular/core';
import { Subscription } from 'rxjs';
import { RdxAccordionContentDirective } from './accordion-content.directive';
import { RdxAccordionOrientation, RdxAccordionRootToken } from './accordion-root.directive';
import { RdxAccordionTriggerDirective } from './accordion-trigger.directive';

export type RdxAccordionItemState = 'open' | 'closed';

let nextId = 0;

/**
 * @group Components
 */
@Directive({
    selector: '[rdxAccordionItem]',
    standalone: true,
    exportAs: 'rdxAccordionItem',
    host: {
        '[attr.data-state]': 'dataState',
        '[attr.data-disabled]': 'disabled',
        '[attr.data-orientation]': 'orientation'
    },
    providers: [
        { provide: RdxAccordionRootToken, useValue: undefined }]
})
export class RdxAccordionItemDirective implements FocusableOption, OnDestroy {
    protected readonly accordion = inject(RdxAccordionRootToken, { skipSelf: true });

    protected readonly changeDetectorRef = inject(ChangeDetectorRef);

    protected readonly expansionDispatcher = inject(UniqueSelectionDispatcher);

    /**
     * @ignore
     */
    @ContentChild(RdxAccordionTriggerDirective, { descendants: true }) trigger: RdxAccordionTriggerDirective;

    /**
     * @ignore
     */
    @ContentChild(forwardRef(() => RdxAccordionContentDirective), { descendants: true })
    content: RdxAccordionContentDirective;

    get dataState(): RdxAccordionItemState {
        return this.expanded ? 'open' : 'closed';
    }

    /**
     * The unique AccordionItem id.
     * @ignore
     */
    readonly id: string = `rdx-accordion-item-${nextId++}`;

    get orientation(): RdxAccordionOrientation {
        return this.accordion.orientation;
    }

    /**
     * @defaultValue false
     * @group Props
     */
    @Input({ transform: booleanAttribute })
    set expanded(expanded: boolean) {
        // Only emit events and update the internal value if the value changes.
        if (this._expanded !== expanded) {
            this._expanded = expanded;
            this.expandedChange.emit(expanded);

            if (expanded) {
                this.opened.emit();
                /**
                 * In the unique selection dispatcher, the id parameter is the id of the CdkAccordionItem,
                 * the name value is the id of the accordion.
                 */
                const accordionId = this.accordion ? this.accordion.id : this.value;
                this.expansionDispatcher.notify(this.value, accordionId);
            } else {
                this.closed.emit();
            }

            // Ensures that the animation will run when the value is set outside of an `@Input`.
            // This includes cases like the open, close and toggle methods.
            this.changeDetectorRef.markForCheck();
        }
    }

    get expanded(): boolean {
        return this._expanded;
    }

    private _expanded = false;

    /**
     * Accordion value.
     *
     * @group Props
     */
    @Input() set value(value: string) {
        this._value = value;
    }

    get value(): string {
        return this._value || this.id;
    }

    private _value?: string;

    /**
     * Whether the AccordionItem is disabled.
     *
     * @defaultValue false
     * @group Props
     */
    @Input({ transform: booleanAttribute }) set disabled(value: boolean) {
        this._disabled = value;
    }

    get disabled(): boolean {
        return this.accordion.disabled ?? this._disabled;
    }

    private _disabled = false;

    /**
     * Event emitted every time the AccordionItem is closed.
     */
    @Output() readonly closed: EventEmitter<void> = new EventEmitter<void>();

    /** Event emitted every time the AccordionItem is opened. */
    @Output() readonly opened: EventEmitter<void> = new EventEmitter<void>();

    /**
     * Event emitted when the AccordionItem is destroyed.
     * @ignore
     */
    readonly destroyed: EventEmitter<void> = new EventEmitter<void>();

    /**
     * Emits whenever the expanded state of the accordion changes.
     * Primarily used to facilitate two-way binding.
     * @group Emits
     */
    @Output() readonly expandedChange: EventEmitter<boolean> = new EventEmitter<boolean>();

    /** Unregister function for expansionDispatcher. */
    private removeUniqueSelectionListener: () => void;

    /** Subscription to openAll/closeAll events. */
    private openCloseAllSubscription = Subscription.EMPTY;

    constructor() {
        this.removeUniqueSelectionListener = this.expansionDispatcher.listen((id: string, accordionId: string) => {
            if (this.accordion.isMultiple) {
                if (this.accordion.id === accordionId && id.includes(this.value)) {
                    this.expanded = true;
                }
            } else {
                this.expanded = this.accordion.id === accordionId && id.includes(this.value);
            }
        });

        // When an accordion item is hosted in an accordion, subscribe to open/close events.
        if (this.accordion) {
            this.openCloseAllSubscription = this.subscribeToOpenCloseAllActions();
        }
    }

    /** Emits an event for the accordion item being destroyed. */
    ngOnDestroy() {
        this.opened.complete();
        this.closed.complete();
        this.destroyed.emit();
        this.destroyed.complete();
        this.removeUniqueSelectionListener();
        this.openCloseAllSubscription.unsubscribe();
    }

    focus(): void {
        this.trigger.focus();
    }

    /** Toggles the expanded state of the accordion item. */
    toggle(): void {
        if (!this.disabled) {
            this.content.onToggle();

            this.expanded = !this.expanded;
        }
    }

    /** Sets the expanded state of the accordion item to false. */
    close(): void {
        if (!this.disabled) {
            this.expanded = false;
        }
    }

    /** Sets the expanded state of the accordion item to true. */
    open(): void {
        if (!this.disabled) {
            this.expanded = true;
        }
    }

    private subscribeToOpenCloseAllActions(): Subscription {
        return this.accordion.openCloseAllActions.subscribe((expanded) => {
            // Only change expanded state if item is enabled
            if (!this.disabled) {
                this.expanded = expanded;
            }
        });
    }
}



# ./accordion/src/accordion-root.directive.ts

import { FocusKeyManager } from '@angular/cdk/a11y';
import { Directionality } from '@angular/cdk/bidi';
import { UniqueSelectionDispatcher } from '@angular/cdk/collections';
import { ENTER, SPACE, TAB } from '@angular/cdk/keycodes';
import {
    AfterContentInit,
    booleanAttribute,
    ContentChildren,
    Directive,
    EventEmitter,
    forwardRef,
    inject,
    InjectionToken,
    Input,
    OnDestroy,
    Output,
    QueryList
} from '@angular/core';
import { merge, Subject, Subscription } from 'rxjs';
import { RdxAccordionItemDirective } from './accordion-item.directive';

export type RdxAccordionType = 'single' | 'multiple';
export type RdxAccordionOrientation = 'horizontal' | 'vertical';

export const RdxAccordionRootToken = new InjectionToken<RdxAccordionRootDirective>('RdxAccordionRootDirective');

let nextId = 0;

/**
 * @group Components
 */
@Directive({
    selector: '[rdxAccordionRoot]',
    standalone: true,
    providers: [
        { provide: RdxAccordionRootToken, useExisting: RdxAccordionRootDirective },
        { provide: UniqueSelectionDispatcher, useClass: UniqueSelectionDispatcher }
    ],
    host: {
        '[attr.data-orientation]': 'orientation',
        '(keydown)': 'handleKeydown($event)'
    }
})
export class RdxAccordionRootDirective implements AfterContentInit, OnDestroy {
    /**
     * @ignore
     */
    protected readonly selectionDispatcher = inject(UniqueSelectionDispatcher);
    /**
     * @ignore
     */
    protected readonly dir = inject(Directionality, { optional: true });

    /**
     * @ignore
     */
    protected keyManager: FocusKeyManager<RdxAccordionItemDirective>;

    /**
     * @ignore
     */
    readonly id: string = `rdx-accordion-${nextId++}`;

    /**
     * @ignore
     */
    readonly openCloseAllActions = new Subject<boolean>();

    get isMultiple(): boolean {
        return this.type === 'multiple';
    }

    /** Whether the Accordion is disabled.
     * @defaultValue false
     * @group Props
     */
    @Input({ transform: booleanAttribute }) disabled: boolean;

    /**
     * The orientation of the accordion.
     *
     * @defaultValue 'vertical'
     * @group Props
     */
    @Input() orientation: RdxAccordionOrientation = 'vertical';
    /**
     * @private
     * @ignore
     */
    @ContentChildren(forwardRef(() => RdxAccordionItemDirective), { descendants: true })
    items: QueryList<RdxAccordionItemDirective>;

    /**
     * The value of the item to expand when initially rendered and type is "single".
     * Use when you do not need to control the state of the items.
     * @group Props
     */
    @Input()
    set defaultValue(value: string[] | string) {
        if (value !== this._defaultValue) {
            this._defaultValue = Array.isArray(value) ? value : [value];
        }
    }

    get defaultValue(): string[] | string {
        return this.isMultiple ? this._defaultValue : this._defaultValue[0];
    }

    /**
     * Determines whether one or multiple items can be opened at the same time.
     * @group Props
     * @defaultValue 'single'
     */
    @Input() type: RdxAccordionType = 'single';

    /**
     * @ignore
     */
    @Input() collapsible = true;

    /**
     * The controlled value of the item to expand.
     *
     * @group Props
     */
    @Input()
    set value(value: string[] | string) {
        if (value !== this._value) {
            this._value = Array.isArray(value) ? value : [value];

            this.selectionDispatcher.notify(this.value as unknown as string, this.id);
        }
    }

    get value(): string[] | string {
        if (this._value === undefined) {
            return this.defaultValue;
        }

        return this.isMultiple ? this._value : this._value[0];
    }

    /**
     * Event handler called when the expanded state of an item changes and type is "multiple".
     * @group Emits
     */
    @Output() readonly onValueChange: EventEmitter<void> = new EventEmitter<void>();

    private _value?: string[];
    private _defaultValue: string[] | string = [];

    private onValueChangeSubscription: Subscription;

    /**
     * @ignore
     */
    ngAfterContentInit(): void {
        this.selectionDispatcher.notify((this._value ?? this._defaultValue) as unknown as string, this.id);

        this.keyManager = new FocusKeyManager(this.items).withHomeAndEnd();

        if (this.orientation === 'horizontal') {
            this.keyManager.withHorizontalOrientation(this.dir?.value || 'ltr');
        } else {
            this.keyManager.withVerticalOrientation();
        }

        this.onValueChangeSubscription = merge(...this.items.map((item) => item.expandedChange)).subscribe(() =>
            this.onValueChange.emit()
        );
    }

    /**
     * @ignore
     */
    ngOnDestroy() {
        this.openCloseAllActions.complete();
        this.onValueChangeSubscription.unsubscribe();
    }

    /**
     * @ignore
     */
    handleKeydown(event: KeyboardEvent) {
        if (!this.keyManager.activeItem) {
            this.keyManager.setFirstItemActive();
        }

        const activeItem = this.keyManager.activeItem;

        if (
            (event.keyCode === ENTER || event.keyCode === SPACE) &&
            !this.keyManager.isTyping() &&
            activeItem &&
            !activeItem.disabled
        ) {
            event.preventDefault();
            activeItem.toggle();
        } else if (event.keyCode === TAB && event.shiftKey) {
            if (this.keyManager.activeItemIndex === 0) return;

            this.keyManager.setPreviousItemActive();
            event.preventDefault();
        } else if (event.keyCode === TAB) {
            if (this.keyManager.activeItemIndex === this.items.length - 1) return;

            this.keyManager.setNextItemActive();
            event.preventDefault();
        } else {
            this.keyManager.onKeydown(event);
        }
    }

    /** Opens all enabled accordion items in an accordion where multi is enabled.
     * @ignore
     */
    openAll(): void {
        if (this.isMultiple) {
            this.openCloseAllActions.next(true);
        }
    }

    /** Closes all enabled accordion items.
     * @ignore
     */
    closeAll(): void {
        this.openCloseAllActions.next(false);
    }

    /**
     * @ignore
     */
    setActiveItem(item: RdxAccordionItemDirective) {
        this.keyManager.setActiveItem(item);
    }
}



# ./accordion/src/accordion-content.directive.ts

import { Directive, ElementRef, inject } from '@angular/core';
import { RdxAccordionItemDirective } from './accordion-item.directive';

@Directive({
    selector: '[rdxAccordionContent]',
    standalone: true,
    exportAs: 'rdxAccordionContent',
    host: {
        '[attr.role]': '"region"',
        '[style.display]': 'hidden ? "none" : ""',
        '[attr.data-state]': 'item.dataState',
        '[attr.data-disabled]': 'item.disabled',
        '[attr.data-orientation]': 'item.orientation',
        '(animationend)': 'onAnimationEnd()'
    }
})
export class RdxAccordionContentDirective {
    protected readonly item = inject(RdxAccordionItemDirective);
    protected readonly nativeElement = inject(ElementRef).nativeElement;

    protected hidden = false;

    protected onAnimationEnd() {
        this.hidden = !this.item.expanded;

        const { height, width } = this.nativeElement.getBoundingClientRect();

        this.nativeElement.style.setProperty('--radix-collapsible-content-height', `${height}px`);
        this.nativeElement.style.setProperty('--radix-collapsible-content-width', `${width}px`);

        this.nativeElement.style.setProperty(
            '--radix-accordion-content-height',
            'var(--radix-collapsible-content-height)'
        );
        this.nativeElement.style.setProperty(
            '--radix-accordion-content-width',
            'var(--radix-collapsible-content-width)'
        );
    }

    onToggle() {
        if (!this.item.expanded) {
            this.hidden = false;
        }
    }
}



# ./accordion/src/accordion-header.directive.ts

import { Directive, inject } from '@angular/core';
import { RdxAccordionItemDirective } from './accordion-item.directive';

@Directive({
    selector: '[rdxAccordionHeader]',
    standalone: true,
    host: {
        '[attr.data-state]': 'item.dataState',
        '[attr.data-disabled]': 'item.disabled',
        '[attr.data-orientation]': 'item.orientation'
    }
})
export class RdxAccordionHeaderDirective {
    protected readonly item = inject(RdxAccordionItemDirective);
}



# ./accordion/src/accordion-trigger.directive.ts

import { Directive, ElementRef, inject } from '@angular/core';
import { RdxAccordionItemDirective } from './accordion-item.directive';
import { RdxAccordionRootDirective } from './accordion-root.directive';

@Directive({
    selector: '[rdxAccordionTrigger]',
    standalone: true,
    host: {
        '[attr.role]': '"button"',
        '[attr.aria-expanded]': 'item.expanded',
        '[attr.data-state]': 'item.dataState',
        '[attr.data-disabled]': 'item.disabled',
        '[attr.disabled]': 'item.disabled ? "" : null',
        '[attr.data-orientation]': 'item.orientation',
        '(click)': 'onClick()'
    }
})
export class RdxAccordionTriggerDirective {
    protected readonly nativeElement = inject(ElementRef).nativeElement;
    protected readonly accordionRoot = inject(RdxAccordionRootDirective);
    protected readonly item = inject(RdxAccordionItemDirective);

    /**
     * Fires when trigger clicked
     */
    onClick(): void {
        if (!this.accordionRoot.collapsible && this.item.expanded) return;

        this.item.toggle();

        this.accordionRoot.setActiveItem(this.item);
    }

    focus() {
        this.nativeElement.focus();
    }
}



# ./separator/README.md

# @radix-ng/primitives/separator

Secondary entry point of `@radix-ng/primitives`.



# ./separator/__tests__/separator.directive.spec.ts

import { Component } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Orientation, RdxSeparatorRootDirective } from '../src/separator.directive';

@Component({
    template: '<div rdxSeparatorRoot [orientation]="orientation" [decorative]="decorative"></div>',
    imports: [RdxSeparatorRootDirective]
})
class TestHostComponent {
    orientation: Orientation = 'horizontal';
    decorative = false;
}

describe('SeparatorDirective', () => {
    let fixture: ComponentFixture<TestHostComponent>;
    let element: HTMLElement;

    beforeEach(() => {
        TestBed.configureTestingModule({
            imports: [TestHostComponent]
        });
        fixture = TestBed.createComponent(TestHostComponent);
        element = fixture.nativeElement.querySelector('div');
    });

    it('should set default role to "separator"', () => {
        fixture.detectChanges();
        expect(element.getAttribute('role')).toBe('separator');
    });

    it('should set role to "none" if decorative is true', () => {
        fixture.componentInstance.decorative = true;
        fixture.detectChanges();
        expect(element.getAttribute('role')).toBe('none');
    });

    it('should not set aria-orientation if orientation is horizontal', () => {
        fixture.componentInstance.orientation = 'horizontal';
        fixture.detectChanges();
        expect(element.getAttribute('aria-orientation')).toBeNull();
    });

    it('should set aria-orientation to "vertical" if orientation is vertical and decorative is false', () => {
        fixture.componentInstance.orientation = 'vertical';
        fixture.detectChanges();
        expect(element.getAttribute('aria-orientation')).toBe('vertical');
    });

    it('should not set aria-orientation if decorative is true', () => {
        fixture.componentInstance.orientation = 'vertical';
        fixture.componentInstance.decorative = true;
        fixture.detectChanges();
        expect(element.getAttribute('aria-orientation')).toBeNull();
    });

    it('should set data-orientation based on the orientation input', () => {
        fixture.componentInstance.orientation = 'vertical';
        fixture.detectChanges();
        expect(element.getAttribute('data-orientation')).toBe('vertical');

        fixture.componentInstance.orientation = 'horizontal';
        fixture.detectChanges();
        expect(element.getAttribute('data-orientation')).toBe('horizontal');
    });
});



# ./separator/index.ts

export * from './src/separator.directive';



# ./separator/src/separator.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, computed, Directive, input, linkedSignal } from '@angular/core';

const DEFAULT_ORIENTATION = 'horizontal';

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const ORIENTATIONS = ['horizontal', 'vertical'] as const;

export type Orientation = (typeof ORIENTATIONS)[number];

export interface SeparatorProps {
    /**
     * Either `vertical` or `horizontal`. Defaults to `horizontal`.
     */
    orientation?: Orientation;
    /**
     * Whether the component is purely decorative. When true, accessibility-related attributes
     * are updated so that the rendered element is removed from the accessibility tree.
     */
    decorative?: boolean;
}

/**
 * Directive that adds accessible and configurable separator element to the DOM.
 * This can be either horizontal or vertical and optionally decorative (which removes
 * it from the accessibility tree).
 *
 * @group Components
 */
@Directive({
    selector: 'div[rdxSeparatorRoot]',
    host: {
        '[attr.role]': 'decorativeEffect() ? "none" : "separator"',
        '[attr.aria-orientation]': 'computedAriaOrientation()',

        '[attr.data-orientation]': 'orientationEffect()'
    }
})
export class RdxSeparatorRootDirective {
    /**
     * Orientation of the separator, can be either 'horizontal' or 'vertical'.
     *
     * @defaultValue 'horizontal'
     * @group Props
     */
    readonly orientation = input<Orientation>(DEFAULT_ORIENTATION);

    /**
     * If true, the separator will be considered decorative and removed from
     * the accessibility tree. Defaults to false.
     *
     * @defaultValue false
     * @group Props
     */
    readonly decorative = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * Computes the `role` attribute for the separator. If `decorative` is true,
     * the role is set to "none", otherwise it is "separator".
     *
     * @ignore
     */
    protected readonly decorativeEffect = linkedSignal({
        source: this.decorative,
        computation: (value) => value
    });

    protected readonly orientationEffect = linkedSignal({
        source: this.orientation,
        computation: (value) => value
    });

    /**
     * Computes the `aria-orientation` attribute. It is set to "vertical" only if
     * the separator is not decorative and the orientation is set to "vertical".
     * For horizontal orientation, the attribute is omitted.
     *
     * @ignore
     */
    protected readonly computedAriaOrientation = computed(() =>
        !this.decorativeEffect() && this.orientationEffect() === 'vertical' ? 'vertical' : undefined
    );

    updateOrientation(value: Orientation) {
        this.orientationEffect.set(value);
    }

    updateDecorative(value: boolean) {
        this.decorativeEffect.set(value);
    }
}



# ./toolbar/README.md

# @radix-ng/primitives/toolbar

Secondary entry point of `@radix-ng/primitives/toolbar`.



# ./toolbar/index.ts

import { NgModule } from '@angular/core';
import { RdxToolbarButtonDirective } from './src/toolbar-button.directive';
import { RdxToolbarLinkDirective } from './src/toolbar-link.directive';
import { RdxToolbarRootDirective } from './src/toolbar-root.directive';
import { RdxToolbarSeparatorDirective } from './src/toolbar-separator.directive';
import { RdxToolbarToggleGroupDirective } from './src/toolbar-toggle-group.directive';
import { RdxToolbarToggleItemDirective } from './src/toolbar-toggle-item.directive';

export * from './src/toolbar-button.directive';
export * from './src/toolbar-link.directive';
export * from './src/toolbar-root.directive';
export * from './src/toolbar-root.token';
export * from './src/toolbar-separator.directive';
export * from './src/toolbar-toggle-group.directive';
export * from './src/toolbar-toggle-item.directive';

const _imports = [
    RdxToolbarRootDirective,
    RdxToolbarButtonDirective,
    RdxToolbarLinkDirective,
    RdxToolbarToggleGroupDirective,
    RdxToolbarToggleItemDirective,
    RdxToolbarSeparatorDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxToolbarModule {}



# ./toolbar/src/toolbar-toggle-item.directive.ts

import { Directive } from '@angular/core';
import { RdxToggleGroupItemDirective } from '@radix-ng/primitives/toggle-group';

@Directive({
    selector: '[rdxToolbarToggleItem]',
    hostDirectives: [{ directive: RdxToggleGroupItemDirective, inputs: ['value', 'disabled'] }]
})
export class RdxToolbarToggleItemDirective {}



# ./toolbar/src/toolbar-link.directive.ts

import { Directive } from '@angular/core';
import { RdxRovingFocusItemDirective } from '@radix-ng/primitives/roving-focus';

@Directive({
    selector: '[rdxToolbarLink]',
    hostDirectives: [{ directive: RdxRovingFocusItemDirective, inputs: ['focusable'] }],
    host: {
        '(keydown)': 'onKeyDown($event)'
    }
})
export class RdxToolbarLinkDirective {
    onKeyDown($event: KeyboardEvent) {
        if ($event.key === ' ') ($event.currentTarget as HTMLElement)?.click();
    }
}



# ./toolbar/src/toolbar-button.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, Directive, effect, inject, input, signal } from '@angular/core';
import { RdxRovingFocusItemDirective } from '@radix-ng/primitives/roving-focus';

@Directive({
    selector: '[rdxToolbarButton]',
    hostDirectives: [{ directive: RdxRovingFocusItemDirective, inputs: ['focusable'] }]
})
export class RdxToolbarButtonDirective {
    private readonly rdxRovingFocusItemDirective = inject(RdxRovingFocusItemDirective);

    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    private readonly isDisabled = signal(this.disabled());

    #disableChanges = effect(() => {
        this.rdxRovingFocusItemDirective.focusable = !this.isDisabled();
    });
}



# ./toolbar/src/toolbar-toggle-group.directive.ts

import { Directive } from '@angular/core';
import { RdxToggleGroupWithoutFocusDirective } from '@radix-ng/primitives/toggle-group';

// TODO: set rovingFocus - false
@Directive({
    selector: '[rdxToolbarToggleGroup]',
    hostDirectives: [{ directive: RdxToggleGroupWithoutFocusDirective, inputs: ['value', 'type', 'disabled'] }]
})
export class RdxToolbarToggleGroupDirective {}



# ./toolbar/src/toolbar-root.token.ts

import { inject, InjectionToken, Provider } from '@angular/core';
import { RdxToolbarRootDirective } from './toolbar-root.directive';

export const RDX_TOOLBAR_ROOT_TOKEN = new InjectionToken<RdxToolbarRootDirective>('RdxToolbarRootDirective');

export function injectRootContext(): RdxToolbarRootDirective {
    return inject(RDX_TOOLBAR_ROOT_TOKEN);
}

export function provideRootContext(): Provider {
    return {
        provide: RDX_TOOLBAR_ROOT_TOKEN,
        useExisting: RdxToolbarRootDirective
    };
}



# ./toolbar/src/toolbar-root.directive.ts

import { Directive, input } from '@angular/core';
import { RdxRovingFocusGroupDirective } from '@radix-ng/primitives/roving-focus';
import { provideRootContext } from './toolbar-root.token';

@Directive({
    selector: '[rdxToolbarRoot]',
    hostDirectives: [{ directive: RdxRovingFocusGroupDirective, inputs: ['dir', 'orientation', 'loop'] }],
    providers: [provideRootContext()],
    host: {
        role: 'toolbar',
        '[attr.aria-orientation]': 'orientation()'
    }
})
export class RdxToolbarRootDirective {
    readonly orientation = input<'horizontal' | 'vertical'>('horizontal');
    readonly dir = input<'ltr' | 'rtl'>('ltr');
}



# ./toolbar/src/toolbar-separator.directive.ts

import { Directive } from '@angular/core';
import { RdxSeparatorRootDirective } from '@radix-ng/primitives/separator';

@Directive({
    selector: '[rdxToolbarSeparator]',
    hostDirectives: [{ directive: RdxSeparatorRootDirective, inputs: ['orientation', 'decorative'] }]
})
export class RdxToolbarSeparatorDirective {}



# ./hover-card/README.md

# @radix-ng/primitives/hover-card

Secondary entry point of `@radix-ng/primitives`. It can be used by importing from `@radix-ng/primitives/hover-card`.



# ./hover-card/index.ts

import { NgModule } from '@angular/core';
import { RdxHoverCardAnchorDirective } from './src/hover-card-anchor.directive';
import { RdxHoverCardArrowDirective } from './src/hover-card-arrow.directive';
import { RdxHoverCardCloseDirective } from './src/hover-card-close.directive';
import { RdxHoverCardContentAttributesComponent } from './src/hover-card-content-attributes.component';
import { RdxHoverCardContentDirective } from './src/hover-card-content.directive';
import { RdxHoverCardRootDirective } from './src/hover-card-root.directive';
import { RdxHoverCardTriggerDirective } from './src/hover-card-trigger.directive';

export * from './src/hover-card-anchor.directive';
export * from './src/hover-card-arrow.directive';
export * from './src/hover-card-close.directive';
export * from './src/hover-card-content-attributes.component';
export * from './src/hover-card-content.directive';
export * from './src/hover-card-root.directive';
export * from './src/hover-card-trigger.directive';

const _imports = [
    RdxHoverCardArrowDirective,
    RdxHoverCardCloseDirective,
    RdxHoverCardContentDirective,
    RdxHoverCardTriggerDirective,
    RdxHoverCardRootDirective,
    RdxHoverCardAnchorDirective,
    RdxHoverCardContentAttributesComponent
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxHoverCardModule {}



# ./hover-card/src/hover-card-anchor.token.ts

import { InjectionToken } from '@angular/core';
import { RdxHoverCardAnchorDirective } from './hover-card-anchor.directive';

export const RdxHoverCardAnchorToken = new InjectionToken<RdxHoverCardAnchorDirective>('RdxHoverCardAnchorToken');



# ./hover-card/src/hover-card-arrow.directive.ts

import { NumberInput } from '@angular/cdk/coercion';
import { ConnectedOverlayPositionChange } from '@angular/cdk/overlay';
import {
    afterNextRender,
    computed,
    Directive,
    effect,
    ElementRef,
    forwardRef,
    inject,
    input,
    numberAttribute,
    Renderer2,
    signal,
    untracked
} from '@angular/core';
import { toSignal } from '@angular/core/rxjs-interop';
import {
    getArrowPositionParams,
    getSideAndAlignFromAllPossibleConnectedPositions,
    RDX_POSITIONING_DEFAULTS
} from '@radix-ng/primitives/core';
import { RdxHoverCardArrowToken } from './hover-card-arrow.token';
import { injectHoverCardRoot } from './hover-card-root.inject';

@Directive({
    selector: '[rdxHoverCardArrow]',
    providers: [
        {
            provide: RdxHoverCardArrowToken,
            useExisting: forwardRef(() => RdxHoverCardArrowDirective)
        }
    ]
})
export class RdxHoverCardArrowDirective {
    /** @ignore */
    private readonly renderer = inject(Renderer2);
    /** @ignore */
    private readonly rootDirective = injectHoverCardRoot();
    /** @ignore */
    readonly elementRef = inject(ElementRef);

    /**
     * @description The width of the arrow in pixels.
     * @default 10
     */
    readonly width = input<number, NumberInput>(RDX_POSITIONING_DEFAULTS.arrow.width, { transform: numberAttribute });

    /**
     * @description The height of the arrow in pixels.
     * @default 5
     */
    readonly height = input<number, NumberInput>(RDX_POSITIONING_DEFAULTS.arrow.height, { transform: numberAttribute });

    /** @ignore */
    readonly arrowSvgElement = computed<HTMLElement>(() => {
        const width = this.width();
        const height = this.height();

        const svgElement = this.renderer.createElement('svg', 'svg');
        this.renderer.setAttribute(svgElement, 'viewBox', '0 0 30 10');
        this.renderer.setAttribute(svgElement, 'width', String(width));
        this.renderer.setAttribute(svgElement, 'height', String(height));
        const polygonElement = this.renderer.createElement('polygon', 'svg');
        this.renderer.setAttribute(polygonElement, 'points', '0,0 30,0 15,10');
        this.renderer.setAttribute(svgElement, 'preserveAspectRatio', 'none');
        this.renderer.appendChild(svgElement, polygonElement);

        return svgElement;
    });

    /** @ignore */
    private readonly currentArrowSvgElement = signal<HTMLOrSVGElement | undefined>(void 0);
    /** @ignore */
    private readonly position = toSignal(this.rootDirective.contentDirective().positionChange());

    /** @ignore */
    private anchorOrTriggerRect: DOMRect;

    constructor() {
        afterNextRender({
            write: () => {
                if (this.elementRef.nativeElement.parentElement) {
                    this.renderer.setStyle(this.elementRef.nativeElement.parentElement, 'position', 'relative');
                }
                this.renderer.setStyle(this.elementRef.nativeElement, 'position', 'absolute');
                this.renderer.setStyle(this.elementRef.nativeElement, 'boxSizing', '');
                this.renderer.setStyle(this.elementRef.nativeElement, 'fontSize', '0px');
            }
        });
        this.onArrowSvgElementChangeEffect();
        this.onContentPositionAndArrowDimensionsChangeEffect();
    }

    /** @ignore */
    private setAnchorOrTriggerRect() {
        this.anchorOrTriggerRect = (
            this.rootDirective.anchorDirective() ?? this.rootDirective.triggerDirective()
        ).elementRef.nativeElement.getBoundingClientRect();
    }

    /** @ignore */
    private setPosition(position: ConnectedOverlayPositionChange, arrowDimensions: { width: number; height: number }) {
        this.setAnchorOrTriggerRect();
        const posParams = getArrowPositionParams(
            getSideAndAlignFromAllPossibleConnectedPositions(position.connectionPair),
            { width: arrowDimensions.width, height: arrowDimensions.height },
            { width: this.anchorOrTriggerRect.width, height: this.anchorOrTriggerRect.height }
        );

        this.renderer.setStyle(this.elementRef.nativeElement, 'top', posParams.top);
        this.renderer.setStyle(this.elementRef.nativeElement, 'bottom', '');
        this.renderer.setStyle(this.elementRef.nativeElement, 'left', posParams.left);
        this.renderer.setStyle(this.elementRef.nativeElement, 'right', '');
        this.renderer.setStyle(this.elementRef.nativeElement, 'transform', posParams.transform);
        this.renderer.setStyle(this.elementRef.nativeElement, 'transformOrigin', posParams.transformOrigin);
    }

    /** @ignore */
    private onArrowSvgElementChangeEffect() {
        effect(() => {
            const arrowElement = this.arrowSvgElement();
            untracked(() => {
                const currentArrowSvgElement = this.currentArrowSvgElement();
                if (currentArrowSvgElement) {
                    this.renderer.removeChild(this.elementRef.nativeElement, currentArrowSvgElement);
                }
                this.currentArrowSvgElement.set(arrowElement);
                this.renderer.setStyle(this.elementRef.nativeElement, 'width', `${this.width()}px`);
                this.renderer.setStyle(this.elementRef.nativeElement, 'height', `${this.height()}px`);
                this.renderer.appendChild(this.elementRef.nativeElement, this.currentArrowSvgElement());
            });
        });
    }

    /** @ignore */
    private onContentPositionAndArrowDimensionsChangeEffect() {
        effect(() => {
            const position = this.position();
            const arrowDimensions = { width: this.width(), height: this.height() };
            untracked(() => {
                if (!position) {
                    return;
                }
                this.setPosition(position, arrowDimensions);
            });
        });
    }
}



# ./hover-card/src/hover-card-root.inject.ts

import { assertInInjectionContext, inject, isDevMode } from '@angular/core';
import { RdxHoverCardRootDirective } from './hover-card-root.directive';

export function injectHoverCardRoot(optional?: false): RdxHoverCardRootDirective;
export function injectHoverCardRoot(optional: true): RdxHoverCardRootDirective | null;
export function injectHoverCardRoot(optional = false): RdxHoverCardRootDirective | null {
    isDevMode() && assertInInjectionContext(injectHoverCardRoot);
    return inject(RdxHoverCardRootDirective, { optional });
}



# ./hover-card/src/hover-card-trigger.directive.ts

import { CdkOverlayOrigin } from '@angular/cdk/overlay';
import { computed, Directive, ElementRef, inject } from '@angular/core';
import { injectHoverCardRoot } from './hover-card-root.inject';

@Directive({
    selector: '[rdxHoverCardTrigger]',
    hostDirectives: [CdkOverlayOrigin],
    host: {
        '[attr.id]': 'name()',
        '[attr.aria-haspopup]': '"dialog"',
        '[attr.aria-expanded]': 'rootDirective.isOpen()',
        '[attr.aria-controls]': 'rootDirective.contentDirective().name()',
        '[attr.data-state]': 'rootDirective.state()',
        '(pointerenter)': 'pointerenter()',
        '(pointerleave)': 'pointerleave()',
        '(focus)': 'focus()',
        '(blur)': 'blur()',
        '(click)': 'click()'
    }
})
export class RdxHoverCardTriggerDirective {
    /** @ignore */
    protected readonly rootDirective = injectHoverCardRoot();
    /** @ignore */
    readonly elementRef = inject<ElementRef<HTMLElement>>(ElementRef);
    /** @ignore */
    readonly overlayOrigin = inject(CdkOverlayOrigin);

    /** @ignore */
    readonly name = computed(() => `rdx-hover-card-trigger-${this.rootDirective.uniqueId()}`);

    /** @ignore */
    protected pointerenter(): void {
        this.rootDirective.handleOpen();
    }

    /** @ignore */
    protected pointerleave(): void {
        this.rootDirective.handleClose();
    }

    /** @ignore */
    protected focus(): void {
        this.rootDirective.handleOpen();
    }

    /** @ignore */
    protected blur(): void {
        this.rootDirective.handleClose();
    }

    /** @ignore */
    protected click(): void {
        this.rootDirective.handleClose();
    }
}



# ./hover-card/src/utils/cdk-event.service.ts

import {
    DestroyRef,
    EnvironmentProviders,
    inject,
    Injectable,
    InjectionToken,
    isDevMode,
    makeEnvironmentProviders,
    NgZone,
    Provider,
    Renderer2,
    VERSION
} from '@angular/core';
import { injectDocument, injectWindow } from '@radix-ng/primitives/core';
import { RdxCdkEventServiceWindowKey } from './constants';
import { EventType, EventTypeAsPrimitiveConfigKey, PrimitiveConfig, PrimitiveConfigs } from './types';

function eventTypeAsPrimitiveConfigKey(eventType: EventType): EventTypeAsPrimitiveConfigKey {
    return `prevent${eventType[0].toUpperCase()}${eventType.slice(1)}` as EventTypeAsPrimitiveConfigKey;
}

@Injectable()
class RdxCdkEventService {
    document = injectDocument();
    destroyRef = inject(DestroyRef);
    ngZone = inject(NgZone);
    renderer2 = inject(Renderer2);
    window = injectWindow();

    primitiveConfigs?: PrimitiveConfigs;

    onDestroyCallbacks: Set<() => void> = new Set([() => deleteRdxCdkEventServiceWindowKey(this.window)]);

    #clickDomRootEventCallbacks: Set<(event: MouseEvent) => void> = new Set();

    constructor() {
        this.#listenToClickDomRootEvent();
        this.#registerOnDestroyCallbacks();
    }

    registerPrimitive<T extends object>(primitiveInstance: T) {
        if (!this.primitiveConfigs) {
            this.primitiveConfigs = new Map();
        }
        if (!this.primitiveConfigs.has(primitiveInstance)) {
            this.primitiveConfigs.set(primitiveInstance, {});
        }
    }

    deregisterPrimitive<T extends object>(primitiveInstance: T) {
        if (this.primitiveConfigs?.has(primitiveInstance)) {
            this.primitiveConfigs.delete(primitiveInstance);
        }
    }

    preventPrimitiveFromCdkEvent<T extends object>(primitiveInstance: T, eventType: EventType) {
        this.#setPreventPrimitiveFromCdkEvent(primitiveInstance, eventType, true);
    }

    allowPrimitiveForCdkEvent<T extends object>(primitiveInstance: T, eventType: EventType) {
        this.#setPreventPrimitiveFromCdkEvent(primitiveInstance, eventType, false);
    }

    preventPrimitiveFromCdkMultiEvents<T extends object>(primitiveInstance: T, eventTypes: EventType[]) {
        eventTypes.forEach((eventType) => {
            this.#setPreventPrimitiveFromCdkEvent(primitiveInstance, eventType, true);
        });
    }

    allowPrimitiveForCdkMultiEvents<T extends object>(primitiveInstance: T, eventTypes: EventType[]) {
        eventTypes.forEach((eventType) => {
            this.#setPreventPrimitiveFromCdkEvent(primitiveInstance, eventType, false);
        });
    }

    setPreventPrimitiveFromCdkMixEvents<T extends object>(primitiveInstance: T, eventTypes: PrimitiveConfig) {
        Object.keys(eventTypes).forEach((eventType) => {
            this.#setPreventPrimitiveFromCdkEvent(
                primitiveInstance,
                eventType as EventType,
                eventTypes[eventTypeAsPrimitiveConfigKey(eventType as EventType)]
            );
        });
    }

    primitivePreventedFromCdkEvent<T extends object>(primitiveInstance: T, eventType: EventType) {
        return this.primitiveConfigs?.get(primitiveInstance)?.[eventTypeAsPrimitiveConfigKey(eventType)];
    }

    addClickDomRootEventCallback(callback: (event: MouseEvent) => void) {
        this.#clickDomRootEventCallbacks.add(callback);
    }

    removeClickDomRootEventCallback(callback: (event: MouseEvent) => void) {
        return this.#clickDomRootEventCallbacks.delete(callback);
    }

    #setPreventPrimitiveFromCdkEvent<
        T extends object,
        R extends EventType,
        K extends PrimitiveConfig[EventTypeAsPrimitiveConfigKey<R>]
    >(primitiveInstance: T, eventType: R, value: K) {
        if (!this.primitiveConfigs?.has(primitiveInstance)) {
            isDevMode() &&
                console.error(
                    '[RdxCdkEventService.preventPrimitiveFromCdkEvent] RDX Primitive instance has not been registered!',
                    primitiveInstance
                );
            return;
        }
        switch (eventType) {
            case 'cdkOverlayOutsideClick':
                this.primitiveConfigs.get(primitiveInstance)!.preventCdkOverlayOutsideClick = value;
                break;
            case 'cdkOverlayEscapeKeyDown':
                this.primitiveConfigs.get(primitiveInstance)!.preventCdkOverlayEscapeKeyDown = value;
                break;
        }
    }

    #registerOnDestroyCallbacks() {
        this.destroyRef.onDestroy(() => {
            this.onDestroyCallbacks.forEach((onDestroyCallback) => onDestroyCallback());
            this.onDestroyCallbacks.clear();
        });
    }

    #listenToClickDomRootEvent() {
        const target = this.document;
        const eventName = 'click';
        const options: boolean | AddEventListenerOptions | undefined = { capture: true };
        const callback = (event: MouseEvent) => {
            this.#clickDomRootEventCallbacks.forEach((clickDomRootEventCallback) => clickDomRootEventCallback(event));
        };

        const major = parseInt(VERSION.major);
        const minor = parseInt(VERSION.minor);

        let destroyClickDomRootEventListener!: () => void;
        /**
         * @see src/cdk/platform/features/backwards-compatibility.ts in @angular/cdk
         */
        if (major > 19 || (major === 19 && minor > 0) || (major === 0 && minor === 0)) {
            destroyClickDomRootEventListener = this.ngZone.runOutsideAngular(() => {
                const destroyClickDomRootEventListenerInternal = this.renderer2.listen(
                    target,
                    eventName,
                    callback,

                    options
                );
                return () => {
                    destroyClickDomRootEventListenerInternal();
                    this.#clickDomRootEventCallbacks.clear();
                };
            });
        } else {
            /**
             * This part can get removed when v19.1 or higher is on the board
             */
            destroyClickDomRootEventListener = this.ngZone.runOutsideAngular(() => {
                target.addEventListener(eventName, callback, options);
                return () => {
                    this.ngZone.runOutsideAngular(() => target.removeEventListener(eventName, callback, options));
                    this.#clickDomRootEventCallbacks.clear();
                };
            });
        }
        this.onDestroyCallbacks.add(destroyClickDomRootEventListener);
    }
}

const RdxCdkEventServiceToken = new InjectionToken<RdxCdkEventService>('RdxCdkEventServiceToken');

const existsErrorMessage = 'RdxCdkEventService should be provided only once!';

const deleteRdxCdkEventServiceWindowKey = (window: Window & typeof globalThis) => {
    delete (window as any)[RdxCdkEventServiceWindowKey];
};

const getProvider: (throwWhenExists?: boolean) => Provider = (throwWhenExists = true) => ({
    provide: RdxCdkEventServiceToken,
    useFactory: () => {
        isDevMode() && console.log('providing RdxCdkEventService...');
        const window = injectWindow();
        if ((window as any)[RdxCdkEventServiceWindowKey]) {
            if (throwWhenExists) {
                throw Error(existsErrorMessage);
            } else {
                isDevMode() && console.warn(existsErrorMessage);
            }
        }
        (window as any)[RdxCdkEventServiceWindowKey] ??= new RdxCdkEventService();
        return (window as any)[RdxCdkEventServiceWindowKey];
    }
});

export const provideRdxCdkEventServiceInRoot: () => EnvironmentProviders = () =>
    makeEnvironmentProviders([getProvider()]);
export const provideRdxCdkEventService: () => Provider = () => getProvider(false);

export const injectRdxCdkEventService = () => inject(RdxCdkEventServiceToken, { optional: true });



# ./hover-card/src/utils/types.ts

export type EventType = 'cdkOverlayOutsideClick' | 'cdkOverlayEscapeKeyDown';
export type EventTypeCapitalized<R extends EventType = EventType> = Capitalize<R>;
export type EventTypeAsPrimitiveConfigKey<R extends EventType = EventType> = `prevent${EventTypeCapitalized<R>}`;
export type PrimitiveConfig = {
    [value in EventTypeAsPrimitiveConfigKey]?: boolean;
};
export type PrimitiveConfigs = Map<object, PrimitiveConfig>;



# ./hover-card/src/utils/constants.ts

export const RdxCdkEventServiceWindowKey = Symbol('__RdxCdkEventService__');



# ./hover-card/src/hover-card-content.directive.ts

import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import { CdkConnectedOverlay, Overlay } from '@angular/cdk/overlay';
import {
    booleanAttribute,
    computed,
    DestroyRef,
    Directive,
    effect,
    inject,
    input,
    numberAttribute,
    OnInit,
    output,
    SimpleChange,
    TemplateRef,
    untracked
} from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import {
    getAllPossibleConnectedPositions,
    getContentPosition,
    RDX_POSITIONING_DEFAULTS,
    RdxPositionAlign,
    RdxPositionSide,
    RdxPositionSideAndAlignOffsets
} from '@radix-ng/primitives/core';
import { filter, tap } from 'rxjs';
import { injectHoverCardRoot } from './hover-card-root.inject';
import { RdxHoverCardAttachDetachEvent } from './hover-card.types';

@Directive({
    selector: '[rdxHoverCardContent]',
    hostDirectives: [
        CdkConnectedOverlay
    ]
})
export class RdxHoverCardContentDirective implements OnInit {
    /** @ignore */
    private readonly rootDirective = injectHoverCardRoot();
    /** @ignore */
    private readonly templateRef = inject(TemplateRef);
    /** @ignore */
    private readonly overlay = inject(Overlay);
    /** @ignore */
    private readonly destroyRef = inject(DestroyRef);
    /** @ignore */
    private readonly connectedOverlay = inject(CdkConnectedOverlay);

    /** @ignore */
    readonly name = computed(() => `rdx-hover-card-trigger-${this.rootDirective.uniqueId()}`);

    /**
     * @description The preferred side of the trigger to render against when open. Will be reversed when collisions occur and avoidCollisions is enabled.
     * @default top
     */
    readonly side = input<RdxPositionSide>(RdxPositionSide.Top);
    /**
     * @description The distance in pixels from the trigger.
     * @default undefined
     */
    readonly sideOffset = input<number, NumberInput>(NaN, {
        transform: numberAttribute
    });
    /**
     * @description The preferred alignment against the trigger. May change when collisions occur.
     * @default center
     */
    readonly align = input<RdxPositionAlign>(RdxPositionAlign.Center);
    /**
     * @description An offset in pixels from the "start" or "end" alignment options.
     * @default undefined
     */
    readonly alignOffset = input<number, NumberInput>(NaN, {
        transform: numberAttribute
    });

    /**
     * @description Whether to add some alternate positions of the content.
     * @default false
     */
    readonly alternatePositionsDisabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /** @description Whether to prevent `onOverlayEscapeKeyDown` handler from calling. */
    readonly onOverlayEscapeKeyDownDisabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });
    /** @description Whether to prevent `onOverlayOutsideClick` handler from calling. */
    readonly onOverlayOutsideClickDisabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * @description Event handler called when the escape key is down.
     * It can be prevented by setting `onOverlayEscapeKeyDownDisabled` input to `true`.
     */
    readonly onOverlayEscapeKeyDown = output<KeyboardEvent>();
    /**
     * @description Event handler called when a pointer event occurs outside the bounds of the component.
     * It can be prevented by setting `onOverlayOutsideClickDisabled` input to `true`.
     */
    readonly onOverlayOutsideClick = output<MouseEvent>();

    /**
     * @description Event handler called after the overlay is open
     */
    readonly onOpen = output<void>();
    /**
     * @description Event handler called after the overlay is closed
     */
    readonly onClosed = output<void>();

    /** @ingore */
    readonly positions = computed(() => this.computePositions());

    constructor() {
        this.onOriginChangeEffect();
        this.onPositionChangeEffect();
    }

    /** @ignore */
    ngOnInit() {
        this.setScrollStrategy();
        this.setHasBackdrop();
        this.setDisableClose();
        this.onAttach();
        this.onDetach();
        this.connectKeydownEscape();
        this.connectOutsideClick();
    }

    /** @ignore */
    open() {
        if (this.connectedOverlay.open) {
            return;
        }
        const prevOpen = this.connectedOverlay.open;
        this.connectedOverlay.open = true;
        this.fireOverlayNgOnChanges('open', this.connectedOverlay.open, prevOpen);
    }

    /** @ignore */
    close() {
        if (!this.connectedOverlay.open) {
            return;
        }
        const prevOpen = this.connectedOverlay.open;
        this.connectedOverlay.open = false;
        this.fireOverlayNgOnChanges('open', this.connectedOverlay.open, prevOpen);
    }

    /** @ignore */
    positionChange() {
        return this.connectedOverlay.positionChange.asObservable();
    }

    /** @ignore */
    private connectKeydownEscape() {
        this.connectedOverlay.overlayKeydown
            .asObservable()
            .pipe(
                filter(
                    () =>
                        !this.onOverlayEscapeKeyDownDisabled() &&
                        !this.rootDirective.rdxCdkEventService?.primitivePreventedFromCdkEvent(
                            this.rootDirective,
                            'cdkOverlayEscapeKeyDown'
                        )
                ),
                filter((event) => event.key === 'Escape'),
                tap((event) => {
                    this.onOverlayEscapeKeyDown.emit(event);
                }),
                filter(() => !this.rootDirective.firstDefaultOpen()),
                tap(() => {
                    this.rootDirective.handleClose();
                }),
                takeUntilDestroyed(this.destroyRef)
            )
            .subscribe();
    }

    /** @ignore */
    private connectOutsideClick() {
        this.connectedOverlay.overlayOutsideClick
            .asObservable()
            .pipe(
                filter(
                    () =>
                        !this.onOverlayOutsideClickDisabled() &&
                        !this.rootDirective.rdxCdkEventService?.primitivePreventedFromCdkEvent(
                            this.rootDirective,
                            'cdkOverlayOutsideClick'
                        )
                ),
                /**
                 * Handle the situation when an anchor is added and the anchor becomes the origin of the overlay
                 * hence  the trigger will be considered the outside element
                 */
                filter((event) => {
                    return (
                        !this.rootDirective.anchorDirective() ||
                        !this.rootDirective
                            .triggerDirective()
                            .elementRef.nativeElement.contains(event.target as Element)
                    );
                }),
                tap((event) => {
                    this.onOverlayOutsideClick.emit(event);
                }),
                filter(() => !this.rootDirective.firstDefaultOpen()),
                tap(() => {
                    this.rootDirective.handleClose();
                }),
                takeUntilDestroyed(this.destroyRef)
            )
            .subscribe();
    }

    /** @ignore */
    private onAttach() {
        this.connectedOverlay.attach
            .asObservable()
            .pipe(
                tap(() => {
                    /**
                     * `this.onOpen.emit();` is being delegated to the rootDirective directive due to the opening animation
                     */
                    this.rootDirective.attachDetachEvent.set(RdxHoverCardAttachDetachEvent.ATTACH);
                }),
                takeUntilDestroyed(this.destroyRef)
            )
            .subscribe();
    }

    /** @ignore */
    private onDetach() {
        this.connectedOverlay.detach
            .asObservable()
            .pipe(
                tap(() => {
                    /**
                     * `this.onClosed.emit();` is being delegated to the rootDirective directive due to the closing animation
                     */
                    this.rootDirective.attachDetachEvent.set(RdxHoverCardAttachDetachEvent.DETACH);
                }),
                takeUntilDestroyed(this.destroyRef)
            )
            .subscribe();
    }

    /** @ignore */
    private setScrollStrategy() {
        const prevScrollStrategy = this.connectedOverlay.scrollStrategy;
        this.connectedOverlay.scrollStrategy = this.overlay.scrollStrategies.reposition();
        this.fireOverlayNgOnChanges('scrollStrategy', this.connectedOverlay.scrollStrategy, prevScrollStrategy);
    }

    /** @ignore */
    private setHasBackdrop() {
        const prevHasBackdrop = this.connectedOverlay.hasBackdrop;
        this.connectedOverlay.hasBackdrop = false;
        this.fireOverlayNgOnChanges('hasBackdrop', this.connectedOverlay.hasBackdrop, prevHasBackdrop);
    }

    /** @ignore */
    private setDisableClose() {
        const prevDisableClose = this.connectedOverlay.disableClose;
        this.connectedOverlay.disableClose = true;
        this.fireOverlayNgOnChanges('disableClose', this.connectedOverlay.disableClose, prevDisableClose);
    }

    /** @ignore */
    private setOrigin(origin: CdkConnectedOverlay['origin']) {
        const prevOrigin = this.connectedOverlay.origin;
        this.connectedOverlay.origin = origin;
        this.fireOverlayNgOnChanges('origin', this.connectedOverlay.origin, prevOrigin);
    }

    /** @ignore */
    private setPositions(positions: CdkConnectedOverlay['positions']) {
        const prevPositions = this.connectedOverlay.positions;
        this.connectedOverlay.positions = positions;
        this.fireOverlayNgOnChanges('positions', this.connectedOverlay.positions, prevPositions);
        this.connectedOverlay.overlayRef?.updatePosition();
    }

    /** @ignore */
    private computePositions() {
        const arrowHeight = this.rootDirective.arrowDirective()?.height() ?? 0;
        const offsets: RdxPositionSideAndAlignOffsets = {
            sideOffset:
                arrowHeight + (isNaN(this.sideOffset()) ? RDX_POSITIONING_DEFAULTS.offsets.side : this.sideOffset()),
            alignOffset: isNaN(this.alignOffset()) ? RDX_POSITIONING_DEFAULTS.offsets.align : this.alignOffset()
        };
        const basePosition = getContentPosition({
            side: this.side(),
            align: this.align(),
            sideOffset: offsets.sideOffset,
            alignOffset: offsets.alignOffset
        });
        const positions = [basePosition];
        if (!this.alternatePositionsDisabled()) {
            /**
             * Alternate positions for better user experience along the X/Y axis (e.g. vertical/horizontal scrolling)
             */
            const allPossibleConnectedPositions = getAllPossibleConnectedPositions();
            allPossibleConnectedPositions.forEach((_, key) => {
                const sideAndAlignArray = key.split('|');
                if (
                    (sideAndAlignArray[0] as RdxPositionSide) !== this.side() ||
                    (sideAndAlignArray[1] as RdxPositionAlign) !== this.align()
                ) {
                    positions.push(
                        getContentPosition({
                            side: sideAndAlignArray[0] as RdxPositionSide,
                            align: sideAndAlignArray[1] as RdxPositionAlign,
                            sideOffset: offsets.sideOffset,
                            alignOffset: offsets.alignOffset
                        })
                    );
                }
            });
        }
        return positions;
    }

    private onOriginChangeEffect() {
        effect(() => {
            const origin = (this.rootDirective.anchorDirective() ?? this.rootDirective.triggerDirective())
                .overlayOrigin;
            untracked(() => {
                this.setOrigin(origin);
            });
        });
    }

    /** @ignore */
    private onPositionChangeEffect() {
        effect(() => {
            const positions = this.positions();
            this.alternatePositionsDisabled();
            untracked(() => {
                this.setPositions(positions);
            });
        });
    }

    /** @ignore */
    private fireOverlayNgOnChanges<K extends keyof CdkConnectedOverlay, V extends CdkConnectedOverlay[K]>(
        input: K,
        currentValue: V,
        previousValue: V,
        firstChange = false
    ) {
        this.connectedOverlay.ngOnChanges({
            [input]: new SimpleChange(previousValue, currentValue, firstChange)
        });
    }
}



# ./hover-card/src/hover-card-arrow.token.ts

import { InjectionToken } from '@angular/core';
import { RdxHoverCardArrowDirective } from './hover-card-arrow.directive';

export const RdxHoverCardArrowToken = new InjectionToken<RdxHoverCardArrowDirective>('RdxHoverCardArrowToken');



# ./hover-card/src/hover-card.types.ts

export enum RdxHoverCardState {
    OPEN = 'open',
    CLOSED = 'closed'
}

export enum RdxHoverCardAction {
    OPEN = 'open',
    CLOSE = 'close'
}

export enum RdxHoverCardAttachDetachEvent {
    ATTACH = 'attach',
    DETACH = 'detach'
}

export enum RdxHoverCardAnimationStatus {
    OPEN_STARTED = 'open_started',
    OPEN_ENDED = 'open_ended',
    CLOSED_STARTED = 'closed_started',
    CLOSED_ENDED = 'closed_ended'
}



# ./hover-card/src/hover-card-close.directive.ts

import { Directive, effect, ElementRef, forwardRef, inject, Renderer2, untracked } from '@angular/core';
import { RdxHoverCardCloseToken } from './hover-card-close.token';
import { injectHoverCardRoot } from './hover-card-root.inject';

/**
 * TODO: to be removed? But it seems to be useful when controlled from outside
 */
@Directive({
    selector: '[rdxHoverCardClose]',
    host: {
        type: 'button',
        '(click)': 'rootDirective.handleClose(true)'
    },
    providers: [
        {
            provide: RdxHoverCardCloseToken,
            useExisting: forwardRef(() => RdxHoverCardCloseDirective)
        }
    ]
})
export class RdxHoverCardCloseDirective {
    /** @ignore */
    protected readonly rootDirective = injectHoverCardRoot();
    /** @ignore */
    readonly elementRef = inject(ElementRef);
    /** @ignore */
    private readonly renderer = inject(Renderer2);

    constructor() {
        this.onIsControlledExternallyEffect();
    }

    /** @ignore */
    private onIsControlledExternallyEffect() {
        effect(() => {
            const isControlledExternally = this.rootDirective.controlledExternally()();

            untracked(() => {
                this.renderer.setStyle(
                    this.elementRef.nativeElement,
                    'display',
                    isControlledExternally ? null : 'none'
                );
            });
        });
    }
}



# ./hover-card/src/hover-card-anchor.directive.ts

import { CdkOverlayOrigin } from '@angular/cdk/overlay';
import { computed, Directive, ElementRef, forwardRef, inject } from '@angular/core';
import { injectDocument } from '@radix-ng/primitives/core';
import { RdxHoverCardAnchorToken } from './hover-card-anchor.token';
import { RdxHoverCardRootDirective } from './hover-card-root.directive';
import { injectHoverCardRoot } from './hover-card-root.inject';

@Directive({
    selector: '[rdxHoverCardAnchor]',
    exportAs: 'rdxHoverCardAnchor',
    hostDirectives: [CdkOverlayOrigin],
    host: {
        type: 'button',
        '[attr.id]': 'name()',
        '[attr.aria-haspopup]': '"dialog"',
        '(click)': 'click()'
    },
    providers: [
        {
            provide: RdxHoverCardAnchorToken,
            useExisting: forwardRef(() => RdxHoverCardAnchorDirective)
        }
    ]
})
export class RdxHoverCardAnchorDirective {
    /**
     * @ignore
     * If outside the rootDirective then null, otherwise the rootDirective directive - with optional `true` passed in as the first param.
     * If outside the rootDirective and non-null value that means the html structure is wrong - hover-card inside hover-card.
     * */
    protected rootDirective = injectHoverCardRoot(true);
    /** @ignore */
    readonly elementRef = inject(ElementRef);
    /** @ignore */
    readonly overlayOrigin = inject(CdkOverlayOrigin);
    /** @ignore */
    readonly document = injectDocument();

    /** @ignore */
    readonly name = computed(() => `rdx-hover-card-external-anchor-${this.rootDirective?.uniqueId()}`);

    /** @ignore */
    click(): void {
        this.emitOutsideClick();
    }

    /** @ignore */
    setRoot(root: RdxHoverCardRootDirective) {
        this.rootDirective = root;
    }

    private emitOutsideClick() {
        if (!this.rootDirective?.isOpen() || this.rootDirective?.contentDirective().onOverlayOutsideClickDisabled()) {
            return;
        }
        const clickEvent = new MouseEvent('click', {
            view: this.document.defaultView,
            bubbles: true,
            cancelable: true,
            relatedTarget: this.elementRef.nativeElement
        });
        this.rootDirective?.triggerDirective().elementRef.nativeElement.dispatchEvent(clickEvent);
    }
}



# ./hover-card/src/hover-card-close.token.ts

import { InjectionToken } from '@angular/core';
import { RdxHoverCardCloseDirective } from './hover-card-close.directive';

export const RdxHoverCardCloseToken = new InjectionToken<RdxHoverCardCloseDirective>('RdxHoverCardCloseToken');



# ./hover-card/src/hover-card-root.directive.ts

import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import {
    afterNextRender,
    booleanAttribute,
    computed,
    contentChild,
    DestroyRef,
    Directive,
    effect,
    inject,
    input,
    numberAttribute,
    signal,
    untracked,
    ViewContainerRef
} from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { debounce, map, Subject, tap, timer } from 'rxjs';
import { RdxHoverCardAnchorDirective } from './hover-card-anchor.directive';
import { RdxHoverCardAnchorToken } from './hover-card-anchor.token';
import { RdxHoverCardArrowToken } from './hover-card-arrow.token';
import { RdxHoverCardCloseToken } from './hover-card-close.token';
import { RdxHoverCardContentAttributesToken } from './hover-card-content-attributes.token';
import { RdxHoverCardContentDirective } from './hover-card-content.directive';
import { RdxHoverCardTriggerDirective } from './hover-card-trigger.directive';
import {
    RdxHoverCardAction,
    RdxHoverCardAnimationStatus,
    RdxHoverCardAttachDetachEvent,
    RdxHoverCardState
} from './hover-card.types';
import { injectRdxCdkEventService } from './utils/cdk-event.service';

let nextId = 0;

@Directive({
    selector: '[rdxHoverCardRoot]',
    exportAs: 'rdxHoverCardRoot'
})
export class RdxHoverCardRootDirective {
    /** @ignore */
    readonly uniqueId = signal(++nextId);
    /** @ignore */
    readonly name = computed(() => `rdx-hover-card-root-${this.uniqueId()}`);

    /**
     * @description The anchor directive that comes form outside the hover-card rootDirective
     * @default undefined
     */
    readonly anchor = input<RdxHoverCardAnchorDirective | undefined>(void 0);
    /**
     * @description The open state of the hover-card when it is initially rendered. Use when you do not need to control its open state.
     * @default false
     */
    readonly defaultOpen = input<boolean, BooleanInput>(false, { transform: booleanAttribute });
    /**
     * @description The controlled state of the hover-card. `open` input take precedence of `defaultOpen` input.
     * @default undefined
     */
    readonly open = input<boolean | undefined, BooleanInput>(void 0, { transform: booleanAttribute });
    /**
     * To customise the open delay for a specific hover-card.
     */
    readonly openDelay = input<number, NumberInput>(500, {
        transform: numberAttribute
    });
    /**
     * To customise the close delay for a specific hover-card.
     */
    readonly closeDelay = input<number, NumberInput>(200, {
        transform: numberAttribute
    });
    /**
     * @description Whether to control the state of the hover-card from external. Use in conjunction with `open` input.
     * @default undefined
     */
    readonly externalControl = input<boolean | undefined, BooleanInput>(void 0, { transform: booleanAttribute });
    /**
     * @description Whether to take into account CSS opening/closing animations.
     * @default false
     */
    readonly cssAnimation = input<boolean, BooleanInput>(false, { transform: booleanAttribute });
    /**
     * @description Whether to take into account CSS opening animations. `cssAnimation` input must be set to 'true'
     * @default false
     */
    readonly cssOpeningAnimation = input<boolean, BooleanInput>(false, { transform: booleanAttribute });
    /**
     * @description Whether to take into account CSS closing animations. `cssAnimation` input must be set to 'true'
     * @default false
     */
    readonly cssClosingAnimation = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /** @ignore */
    readonly cssAnimationStatus = signal<RdxHoverCardAnimationStatus | null>(null);

    /** @ignore */
    readonly contentDirective = contentChild.required(RdxHoverCardContentDirective);
    /** @ignore */
    readonly triggerDirective = contentChild.required(RdxHoverCardTriggerDirective);
    /** @ignore */
    readonly arrowDirective = contentChild(RdxHoverCardArrowToken);
    /** @ignore */
    readonly closeDirective = contentChild(RdxHoverCardCloseToken);
    /** @ignore */
    readonly contentAttributesComponent = contentChild(RdxHoverCardContentAttributesToken);
    /** @ignore */
    private readonly internalAnchorDirective = contentChild(RdxHoverCardAnchorToken);

    /** @ignore */
    readonly viewContainerRef = inject(ViewContainerRef);
    /** @ignore */
    readonly rdxCdkEventService = injectRdxCdkEventService();
    /** @ignore */
    readonly destroyRef = inject(DestroyRef);

    /** @ignore */
    readonly state = signal(RdxHoverCardState.CLOSED);

    /** @ignore */
    readonly attachDetachEvent = signal(RdxHoverCardAttachDetachEvent.DETACH);

    /** @ignore */
    private readonly isFirstDefaultOpen = signal(false);

    /** @ignore */
    readonly anchorDirective = computed(() => this.internalAnchorDirective() ?? this.anchor());

    /** @ignore */
    readonly actionSubject$ = new Subject<RdxHoverCardAction>();

    constructor() {
        this.rdxCdkEventService?.registerPrimitive(this);
        this.destroyRef.onDestroy(() => this.rdxCdkEventService?.deregisterPrimitive(this));
        this.actionSubscription();
        this.onStateChangeEffect();
        this.onCssAnimationStatusChangeChangeEffect();
        this.onOpenChangeEffect();
        this.onIsFirstDefaultOpenChangeEffect();
        this.onAnchorChangeEffect();
        this.emitOpenOrClosedEventEffect();
        afterNextRender({
            write: () => {
                if (this.defaultOpen() && !this.open()) {
                    this.isFirstDefaultOpen.set(true);
                }
            }
        });
    }

    /** @ignore */
    getAnimationParamsSnapshot() {
        return {
            cssAnimation: this.cssAnimation(),
            cssOpeningAnimation: this.cssOpeningAnimation(),
            cssClosingAnimation: this.cssClosingAnimation(),
            cssAnimationStatus: this.cssAnimationStatus(),
            attachDetachEvent: this.attachDetachEvent(),
            state: this.state(),
            canEmitOnOpenOrOnClosed: this.canEmitOnOpenOrOnClosed()
        };
    }

    /** @ignore */
    controlledExternally() {
        return this.externalControl;
    }

    /** @ignore */
    firstDefaultOpen() {
        return this.isFirstDefaultOpen();
    }

    /** @ignore */
    handleOpen(): void {
        if (this.externalControl()) {
            return;
        }
        this.actionSubject$.next(RdxHoverCardAction.OPEN);
    }

    /** @ignore */
    handleClose(closeButton?: boolean): void {
        if (this.isFirstDefaultOpen()) {
            this.isFirstDefaultOpen.set(false);
        }
        if (!closeButton && this.externalControl()) {
            return;
        }
        this.actionSubject$.next(RdxHoverCardAction.CLOSE);
    }

    /** @ignore */
    handleToggle(): void {
        if (this.externalControl()) {
            return;
        }
        this.isOpen() ? this.handleClose() : this.handleOpen();
    }

    /** @ignore */
    isOpen(state?: RdxHoverCardState) {
        return (state ?? this.state()) === RdxHoverCardState.OPEN;
    }

    /** @ignore */
    private setState(state = RdxHoverCardState.CLOSED): void {
        if (state === this.state()) {
            return;
        }
        this.state.set(state);
    }

    /** @ignore */
    private openContent(): void {
        this.contentDirective().open();
        if (!this.cssAnimation() || !this.cssOpeningAnimation()) {
            this.cssAnimationStatus.set(null);
        }
    }

    /** @ignore */
    private closeContent(): void {
        this.contentDirective().close();
        if (!this.cssAnimation() || !this.cssClosingAnimation()) {
            this.cssAnimationStatus.set(null);
        }
    }

    /** @ignore */
    private emitOnOpen(): void {
        this.contentDirective().onOpen.emit();
    }

    /** @ignore */
    private emitOnClosed(): void {
        this.contentDirective().onClosed.emit();
    }

    /** @ignore */
    private ifOpenOrCloseWithoutAnimations(state: RdxHoverCardState) {
        return (
            !this.contentAttributesComponent() ||
            !this.cssAnimation() ||
            (this.cssAnimation() && !this.cssClosingAnimation() && state === RdxHoverCardState.CLOSED) ||
            (this.cssAnimation() && !this.cssOpeningAnimation() && state === RdxHoverCardState.OPEN) ||
            // !this.cssAnimationStatus() ||
            (this.cssOpeningAnimation() &&
                state === RdxHoverCardState.OPEN &&
                [RdxHoverCardAnimationStatus.OPEN_STARTED].includes(this.cssAnimationStatus()!)) ||
            (this.cssClosingAnimation() &&
                state === RdxHoverCardState.CLOSED &&
                [RdxHoverCardAnimationStatus.CLOSED_STARTED].includes(this.cssAnimationStatus()!))
        );
    }

    /** @ignore */
    private ifOpenOrCloseWithAnimations(cssAnimationStatus: RdxHoverCardAnimationStatus | null) {
        return (
            this.contentAttributesComponent() &&
            this.cssAnimation() &&
            cssAnimationStatus &&
            ((this.cssOpeningAnimation() &&
                this.state() === RdxHoverCardState.OPEN &&
                [RdxHoverCardAnimationStatus.OPEN_ENDED].includes(cssAnimationStatus)) ||
                (this.cssClosingAnimation() &&
                    this.state() === RdxHoverCardState.CLOSED &&
                    [RdxHoverCardAnimationStatus.CLOSED_ENDED].includes(cssAnimationStatus)))
        );
    }

    /** @ignore */
    private openOrClose(state: RdxHoverCardState) {
        const isOpen = this.isOpen(state);
        isOpen ? this.openContent() : this.closeContent();
    }

    /** @ignore */
    private emitOnOpenOrOnClosed(state: RdxHoverCardState) {
        this.isOpen(state)
            ? this.attachDetachEvent() === RdxHoverCardAttachDetachEvent.ATTACH && this.emitOnOpen()
            : this.attachDetachEvent() === RdxHoverCardAttachDetachEvent.DETACH && this.emitOnClosed();
    }

    /** @ignore */
    private canEmitOnOpenOrOnClosed() {
        return (
            !this.cssAnimation() ||
            (!this.cssOpeningAnimation() && this.state() === RdxHoverCardState.OPEN) ||
            (this.cssOpeningAnimation() &&
                this.state() === RdxHoverCardState.OPEN &&
                this.cssAnimationStatus() === RdxHoverCardAnimationStatus.OPEN_ENDED) ||
            (!this.cssClosingAnimation() && this.state() === RdxHoverCardState.CLOSED) ||
            (this.cssClosingAnimation() &&
                this.state() === RdxHoverCardState.CLOSED &&
                this.cssAnimationStatus() === RdxHoverCardAnimationStatus.CLOSED_ENDED)
        );
    }

    /** @ignore */
    private onStateChangeEffect() {
        let isFirst = true;
        effect(() => {
            const state = this.state();
            untracked(() => {
                if (isFirst) {
                    isFirst = false;
                    return;
                }
                if (!this.ifOpenOrCloseWithoutAnimations(state)) {
                    return;
                }
                this.openOrClose(state);
            });
        }, {});
    }

    /** @ignore */
    private onCssAnimationStatusChangeChangeEffect() {
        let isFirst = true;
        effect(() => {
            const cssAnimationStatus = this.cssAnimationStatus();
            untracked(() => {
                if (isFirst) {
                    isFirst = false;
                    return;
                }
                if (!this.ifOpenOrCloseWithAnimations(cssAnimationStatus)) {
                    return;
                }
                this.openOrClose(this.state());
            });
        });
    }

    /** @ignore */
    private emitOpenOrClosedEventEffect() {
        let isFirst = true;
        effect(() => {
            this.attachDetachEvent();
            this.cssAnimationStatus();
            untracked(() => {
                if (isFirst) {
                    isFirst = false;
                    return;
                }
                const canEmitOpenClose = untracked(() => this.canEmitOnOpenOrOnClosed());
                if (!canEmitOpenClose) {
                    return;
                }
                this.emitOnOpenOrOnClosed(this.state());
            });
        });
    }

    /** @ignore */
    private onOpenChangeEffect() {
        effect(() => {
            const open = this.open();
            untracked(() => {
                this.setState(open ? RdxHoverCardState.OPEN : RdxHoverCardState.CLOSED);
            });
        });
    }

    /** @ignore */
    private onIsFirstDefaultOpenChangeEffect() {
        const effectRef = effect(() => {
            const defaultOpen = this.defaultOpen();
            untracked(() => {
                if (!defaultOpen || this.open()) {
                    effectRef.destroy();
                    return;
                }
                this.handleOpen();
            });
        });
    }

    /** @ignore */
    private onAnchorChangeEffect = () => {
        effect(() => {
            const anchor = this.anchor();
            untracked(() => {
                if (anchor) {
                    anchor.setRoot(this);
                }
            });
        });
    };

    /** @ignore */
    private actionSubscription() {
        this.actionSubject$
            .asObservable()
            .pipe(
                map((action) => {
                    console.log(action);
                    switch (action) {
                        case RdxHoverCardAction.OPEN:
                            return { action, duration: this.openDelay() };
                        case RdxHoverCardAction.CLOSE:
                            return { action, duration: this.closeDelay() };
                    }
                }),
                debounce((config) => timer(config.duration)),
                tap((config) => {
                    switch (config.action) {
                        case RdxHoverCardAction.OPEN:
                            this.setState(RdxHoverCardState.OPEN);
                            break;
                        case RdxHoverCardAction.CLOSE:
                            this.setState(RdxHoverCardState.CLOSED);
                            break;
                    }
                }),
                takeUntilDestroyed()
            )
            .subscribe();
    }
}



# ./hover-card/src/hover-card-content-attributes.token.ts

import { InjectionToken } from '@angular/core';
import { RdxHoverCardContentAttributesComponent } from './hover-card-content-attributes.component';

export const RdxHoverCardContentAttributesToken = new InjectionToken<RdxHoverCardContentAttributesComponent>(
    'RdxHoverCardContentAttributesToken'
);



# ./hover-card/src/hover-card-content-attributes.component.ts

import { ChangeDetectionStrategy, Component, computed, forwardRef } from '@angular/core';
import { RdxHoverCardContentAttributesToken } from './hover-card-content-attributes.token';
import { injectHoverCardRoot } from './hover-card-root.inject';
import { RdxHoverCardAnimationStatus, RdxHoverCardState } from './hover-card.types';

@Component({
    selector: '[rdxHoverCardContentAttributes]',
    template: `
        <ng-content />
    `,
    host: {
        '[attr.role]': '"dialog"',
        '[attr.id]': 'name()',
        '[attr.data-state]': 'rootDirective.state()',
        '[attr.data-side]': 'rootDirective.contentDirective().side()',
        '[attr.data-align]': 'rootDirective.contentDirective().align()',
        '[style]': 'disableAnimation() ? {animation: "none !important"} : null',
        '(animationstart)': 'onAnimationStart($event)',
        '(animationend)': 'onAnimationEnd($event)',
        '(pointerenter)': 'pointerenter()',
        '(pointerleave)': 'pointerleave()',
        '(focus)': 'focus()',
        '(blur)': 'blur()'
    },
    providers: [
        {
            provide: RdxHoverCardContentAttributesToken,
            useExisting: forwardRef(() => RdxHoverCardContentAttributesComponent)
        }
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class RdxHoverCardContentAttributesComponent {
    /** @ignore */
    protected readonly rootDirective = injectHoverCardRoot();

    /** @ignore */
    readonly name = computed(() => `rdx-hover-card-content-attributes-${this.rootDirective.uniqueId()}`);

    /** @ignore */
    readonly disableAnimation = computed(() => !this.canAnimate());

    /** @ignore */
    protected onAnimationStart(_: AnimationEvent) {
        this.rootDirective.cssAnimationStatus.set(
            this.rootDirective.state() === RdxHoverCardState.OPEN
                ? RdxHoverCardAnimationStatus.OPEN_STARTED
                : RdxHoverCardAnimationStatus.CLOSED_STARTED
        );
    }

    /** @ignore */
    protected onAnimationEnd(_: AnimationEvent) {
        this.rootDirective.cssAnimationStatus.set(
            this.rootDirective.state() === RdxHoverCardState.OPEN
                ? RdxHoverCardAnimationStatus.OPEN_ENDED
                : RdxHoverCardAnimationStatus.CLOSED_ENDED
        );
    }

    /** @ignore */
    protected pointerenter(): void {
        this.rootDirective.handleOpen();
    }

    /** @ignore */
    protected pointerleave(): void {
        this.rootDirective.handleClose();
    }

    /** @ignore */
    protected focus(): void {
        this.rootDirective.handleOpen();
    }

    /** @ignore */
    protected blur(): void {
        this.rootDirective.handleClose();
    }

    /** @ignore */
    private canAnimate() {
        return (
            this.rootDirective.cssAnimation() &&
            ((this.rootDirective.cssOpeningAnimation() && this.rootDirective.state() === RdxHoverCardState.OPEN) ||
                (this.rootDirective.cssClosingAnimation() && this.rootDirective.state() === RdxHoverCardState.CLOSED))
        );
    }
}



# ./checkbox/README.md

# @radix-ng/primitives/checkbox



# ./checkbox/index.ts

import { NgModule } from '@angular/core';
import { RdxCheckboxButtonDirective } from './src/checkbox-button.directive';
import { RdxCheckboxIndicatorDirective } from './src/checkbox-indicator.directive';
import { RdxCheckboxInputDirective } from './src/checkbox-input.directive';
import { RdxCheckboxDirective } from './src/checkbox.directive';

export * from './src/checkbox-button.directive';
export * from './src/checkbox-indicator.directive';
export * from './src/checkbox-input.directive';
export * from './src/checkbox.directive';
export type { CheckboxState } from './src/checkbox.directive';
export * from './src/checkbox.token';

const _imports = [
    RdxCheckboxInputDirective,
    RdxCheckboxDirective,
    RdxCheckboxButtonDirective,
    RdxCheckboxIndicatorDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxCheckboxModule {}



# ./checkbox/src/checkbox-button.directive.ts

import { computed, Directive, input } from '@angular/core';
import { injectCheckbox } from './checkbox.token';

@Directive({
    standalone: true,
    selector: 'button[rdxCheckboxButton]',
    host: {
        type: 'button',
        role: 'checkbox',
        tabindex: '-1',
        '[checked]': 'checkbox.checked',
        '[disabled]': 'checkbox.disabled',
        '[required]': 'checkbox.required',
        '[attr.id]': 'elementId()',
        '[attr.aria-checked]': 'checkbox.indeterminate ? "mixed" : checkbox.checked',
        '[attr.aria-required]': 'checkbox.required ? "" : null',
        '[attr.data-state]': 'checkbox.state',
        '[attr.data-disabled]': 'checkbox.disabled ? "" : null'
    }
})
export class RdxCheckboxButtonDirective {
    protected readonly checkbox = injectCheckbox();

    readonly id = input<string | null>(null);

    protected readonly elementId = computed(() => (this.id() ? this.id() : `rdx-checkbox-${this.id()}`));
}



# ./checkbox/src/checkbox-indicator.directive.ts

import { Directive } from '@angular/core';
import { injectCheckbox } from './checkbox.token';

@Directive({
    selector: '[rdxCheckboxIndicator]',
    standalone: true,
    host: {
        '[style.pointer-events]': '"none"',
        '[attr.aria-checked]': 'checkbox.indeterminate ? "mixed" : checkbox.checked',
        '[attr.data-state]': 'checkbox.state',
        '[attr.data-disabled]': 'checkbox.disabled ? "" : null'
    }
})
export class RdxCheckboxIndicatorDirective {
    protected readonly checkbox = injectCheckbox();
}



# ./checkbox/src/checkbox.directive.ts

import { booleanAttribute, Directive, EventEmitter, Input, OnChanges, Output, SimpleChanges } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { RdxCheckboxToken } from './checkbox.token';

export type CheckboxState = 'unchecked' | 'checked' | 'indeterminate';

/**
 * @group Components
 */
@Directive({
    selector: '[rdxCheckboxRoot]',
    standalone: true,
    providers: [
        { provide: RdxCheckboxToken, useExisting: RdxCheckboxDirective },
        { provide: NG_VALUE_ACCESSOR, useExisting: RdxCheckboxDirective, multi: true }
    ],
    host: {
        '[disabled]': 'disabled',
        '[attr.data-disabled]': 'disabled ? "" : null',
        '[attr.data-state]': 'state',

        '(keydown)': 'onKeyDown($event)',
        '(click)': 'onClick($event)',
        '(blur)': 'onBlur()'
    }
})
export class RdxCheckboxDirective implements ControlValueAccessor, OnChanges {
    /**
     * The controlled checked state of the checkbox. Must be used in conjunction with onCheckedChange.
     * @group Props
     */
    @Input({ transform: booleanAttribute }) checked = false;

    /**
     * Defines whether the checkbox is indeterminate.
     * @group Props
     */
    @Input({ transform: booleanAttribute }) indeterminate = false;

    /**
     * Defines whether the checkbox is disabled.
     * @group Props
     */
    @Input({ transform: booleanAttribute }) disabled = false;

    /**
     * @group Props
     */
    @Input({ transform: booleanAttribute }) required = false;

    /**
     * Event emitted when the checkbox checked state changes.
     * @group Emits
     */
    @Output() readonly checkedChange = new EventEmitter<boolean>();

    /**
     * Event emitted when the indeterminate state changes.
     * @group Emits
     */
    @Output() readonly indeterminateChange = new EventEmitter<boolean>();

    /**
     * Determine the state
     */
    get state(): CheckboxState {
        if (this.indeterminate) {
            return 'indeterminate';
        }
        return this.checked ? 'checked' : 'unchecked';
    }

    /**
     * Store the callback function that should be called when the checkbox checked state changes.
     * @internal
     */
    private onChange?: (checked: boolean) => void;

    /**
     * Store the callback function that should be called when the checkbox is blurred.
     * @internal
     */
    private onTouched?: () => void;

    protected onKeyDown(event: KeyboardEvent): void {
        // According to WAI ARIA, Checkboxes don't activate on enter keypress
        if (event.key === 'Enter') {
            event.preventDefault();
        }
    }

    protected onClick($event: MouseEvent): void {
        if (this.disabled) {
            return;
        }

        this.checked = this.indeterminate ? true : !this.checked;
        this.checkedChange.emit(this.checked);
        this.onChange?.(this.checked);

        if (this.indeterminate) {
            this.indeterminate = false;
            this.indeterminateChange.emit(this.indeterminate);
        }

        $event.preventDefault();
    }

    protected onBlur(): void {
        this.onTouched?.();
    }

    ngOnChanges(changes: SimpleChanges): void {
        if (changes['checked'] && !changes['checked'].isFirstChange()) {
            this.checkedChange.emit(this.checked);
        }
        if (changes['indeterminate'] && !changes['indeterminate'].isFirstChange()) {
            this.indeterminateChange.emit(this.indeterminate);
        }
    }

    /**
     * Sets the checked state of the checkbox.
     * @param checked The checked state of the checkbox.
     * @internal
     */
    writeValue(checked: boolean): void {
        this.checked = checked;
    }

    /**
     * Registers a callback function that should be called when the checkbox checked state changes.
     * @param fn The callback function.
     * @internal
     */
    registerOnChange(fn: (checked: boolean) => void): void {
        this.onChange = fn;
    }

    /**
     * Registers a callback function that should be called when the checkbox is blurred.
     * @param fn The callback function.
     * @internal
     */
    registerOnTouched(fn: () => void): void {
        this.onTouched = fn;
    }

    /**
     * Sets the disabled state of the checkbox.
     * @param isDisabled The disabled state of the checkbox.
     * @internal
     */
    setDisabledState(isDisabled: boolean): void {
        this.disabled = isDisabled;
    }
}



# ./checkbox/src/checkbox.token.ts

import { inject, InjectionToken } from '@angular/core';
import type { RdxCheckboxDirective } from './checkbox.directive';

export const RdxCheckboxToken = new InjectionToken<RdxCheckboxDirective>('RdxCheckboxToken');

export function injectCheckbox(): RdxCheckboxDirective {
    return inject(RdxCheckboxToken);
}



# ./checkbox/src/checkbox-input.directive.ts

import { computed, Directive, input } from '@angular/core';
import { RdxVisuallyHiddenInputDirective } from '@radix-ng/primitives/visually-hidden';
import { injectCheckbox } from './checkbox.token';

@Directive({
    standalone: true,
    selector: 'input[rdxCheckboxInput]',
    hostDirectives: [{ directive: RdxVisuallyHiddenInputDirective, inputs: ['feature: "fully-hidden"'] }],
    host: {
        type: 'checkbox',
        tabindex: '-1',
        '[checked]': 'checkbox.checked',
        '[disabled]': 'checkbox.disabled',
        '[required]': 'checkbox.required',
        '[attr.id]': 'elementId()',
        '[attr.aria-hidden]': 'true',
        '[attr.aria-checked]': 'checkbox.indeterminate ? "mixed" : checkbox.checked',
        '[attr.aria-required]': 'checkbox.required ? "" : null',
        '[attr.data-state]': 'checkbox.state',
        '[attr.data-disabled]': 'checkbox.disabled ? "" : null',
        '[attr.value]': 'value()'
    }
})
export class RdxCheckboxInputDirective {
    protected readonly checkbox = injectCheckbox();

    readonly id = input<string>();

    protected readonly elementId = computed(() => (this.id() ? this.id() : `rdx-checkbox-${this.id()}`));

    protected readonly value = computed(() => {
        const state = this.checkbox.state;
        if (state === 'indeterminate') {
            return '';
        }

        return state ? 'on' : 'off';
    });
}



# ./label/README.md

# @radix-ng/primitives/label



# ./label/__tests__/label-root.directive.spec.ts

import { Component, DebugElement } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { RdxLabelDirective } from '../src/label.directive';

/* Explanation:

    Environment Setup: In addition to the label, the template now includes a div and an input button to test interaction with different types of elements.

    Double-click Prevention: Tests whether the directive correctly prevents default actions during a double-click, except on form elements like buttons.

    Single Click Handling: Verifies that the directive does not interfere with default actions on single clicks.

    Interaction with Children: Checks that double-clicks on non-form elements like divs also trigger prevention of default actions.*/
@Component({
    template: `
        <label rdxLabel>
            Test Label
            <div>Click Me</div>
            <input type="button" value="Button" />
        </label>
    `,
    imports: [RdxLabelDirective]
})
class TestComponent {}

describe('RdxLabelDirective', () => {
    let fixture: ComponentFixture<TestComponent>;
    let labelElement: DebugElement;
    let inputElement: DebugElement;
    let divElement: DebugElement;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [TestComponent]
        }).compileComponents();

        fixture = TestBed.createComponent(TestComponent);
        fixture.detectChanges();
        labelElement = fixture.debugElement.query(By.directive(RdxLabelDirective));
        inputElement = fixture.debugElement.query(By.css('input'));
        divElement = fixture.debugElement.query(By.css('div'));
    });

    it('should create an instance of the directive', () => {
        expect(labelElement).toBeTruthy();
    });

    it('should prevent default action on double-clicking the label, not on input elements', () => {
        const mockEventLabel = new MouseEvent('mousedown', {
            bubbles: true,
            cancelable: true,
            detail: 2
        });
        Object.defineProperty(mockEventLabel, 'target', { value: labelElement.nativeElement });
        jest.spyOn(mockEventLabel, 'preventDefault');

        labelElement.triggerEventHandler('mousedown', mockEventLabel);
        expect(mockEventLabel.preventDefault).toHaveBeenCalled();

        // Double-click event targeting the input element
        const mockEventInput = new MouseEvent('mousedown', {
            bubbles: true,
            cancelable: true,
            detail: 2
        });
        Object.defineProperty(mockEventInput, 'target', { value: inputElement.nativeElement });
        jest.spyOn(mockEventInput, 'preventDefault');

        labelElement.triggerEventHandler('mousedown', mockEventInput);
        expect(mockEventInput.preventDefault).not.toHaveBeenCalled();
    });

    it('should not prevent default action on single clicks', () => {
        const mockEvent = new MouseEvent('mousedown', {
            bubbles: true,
            cancelable: true,
            detail: 1
        });
        Object.defineProperty(mockEvent, 'target', { value: labelElement.nativeElement });
        jest.spyOn(mockEvent, 'preventDefault');

        labelElement.triggerEventHandler('mousedown', mockEvent);
        expect(mockEvent.preventDefault).not.toHaveBeenCalled();
    });

    it('should prevent default action when double-clicking non-button/input/select/textarea elements within the label', () => {
        const mockEvent = new MouseEvent('mousedown', {
            bubbles: true,
            cancelable: true,
            detail: 2
        });
        Object.defineProperty(mockEvent, 'target', { value: divElement.nativeElement });
        jest.spyOn(mockEvent, 'preventDefault');

        labelElement.triggerEventHandler('mousedown', mockEvent);
        expect(mockEvent.preventDefault).toHaveBeenCalled();
    });
});



# ./label/index.ts

export * from './src/label.directive';



# ./label/src/label.directive.ts

import { computed, Directive, ElementRef, inject, input } from '@angular/core';

let idIterator = 0;

/**
 * @group Components
 */
@Directive({
    selector: 'label[rdxLabel]',
    exportAs: 'rdxLabel',
    host: {
        '[attr.id]': 'this.elementId()',
        '[attr.for]': 'htmlFor ? htmlFor() : null',
        '(mousedown)': 'onMouseDown($event)'
    }
})
export class RdxLabelDirective {
    private readonly elementRef = inject(ElementRef<HTMLElement>);

    /**
     * @default 'rdx-label-{idIterator}'
     */
    readonly id = input<string>(`rdx-label-${idIterator++}`);

    /**
     * The id of the element the label is associated with.
     * @group Props
     * @defaultValue false
     */
    readonly htmlFor = input<string>();

    protected readonly elementId = computed(() => (this.id() ? this.id() : null));

    // prevent text selection when double-clicking label
    // The main problem with double-clicks in a web app is that
    // you will have to create special code to handle this on touch enabled devices.
    /**
     * @ignore
     */
    onMouseDown(event: MouseEvent): void {
        const target = event.target as HTMLElement;

        // only prevent text selection if clicking inside the label itself
        if (['BUTTON', 'INPUT', 'SELECT', 'TEXTAREA'].includes(target.tagName)) {
            return;
        }

        // prevent text selection when double-clicking label
        if (this.elementRef.nativeElement.contains(target) && !event.defaultPrevented && event.detail > 1) {
            event.preventDefault();
        }
    }
}



# ./dropdown-menu/README.md

# @radix-ng/primitives/dropdown-menu



# ./dropdown-menu/index.ts

import { NgModule } from '@angular/core';
import { RdxDropdownMenuContentDirective } from './src/dropdown-menu-content.directive';
import { RdxDropdownMenuItemCheckboxDirective } from './src/dropdown-menu-item-checkbox.directive';
import { RdxDropdownMenuItemIndicatorDirective } from './src/dropdown-menu-item-indicator.directive';
import { RdxDropdownMenuItemRadioGroupDirective } from './src/dropdown-menu-item-radio-group.directive';
import { RdxDropdownMenuItemRadioDirective } from './src/dropdown-menu-item-radio.directive';
import { RdxDropdownMenuSelectable } from './src/dropdown-menu-item-selectable';
import { RdxDropdownMenuItemDirective } from './src/dropdown-menu-item.directive';
import { RdxDropdownMenuLabelDirective } from './src/dropdown-menu-label.directive';
import { RdxDropdownMenuSeparatorDirective } from './src/dropdown-menu-separator.directive';
import { RdxDropdownMenuTriggerDirective } from './src/dropdown-menu-trigger.directive';

export * from './src/dropdown-menu-content.directive';
export * from './src/dropdown-menu-item-checkbox.directive';
export * from './src/dropdown-menu-item-indicator.directive';
export * from './src/dropdown-menu-item-radio-group.directive';
export * from './src/dropdown-menu-item-radio.directive';
export * from './src/dropdown-menu-item-selectable';
export * from './src/dropdown-menu-item.directive';
export * from './src/dropdown-menu-label.directive';
export * from './src/dropdown-menu-separator.directive';
export * from './src/dropdown-menu-trigger.directive';

const _imports = [
    RdxDropdownMenuTriggerDirective,
    RdxDropdownMenuContentDirective,
    RdxDropdownMenuItemCheckboxDirective,
    RdxDropdownMenuItemIndicatorDirective,
    RdxDropdownMenuItemRadioGroupDirective,
    RdxDropdownMenuItemRadioDirective,
    RdxDropdownMenuSelectable,
    RdxDropdownMenuItemDirective,
    RdxDropdownMenuLabelDirective,
    RdxDropdownMenuSeparatorDirective,
    RdxDropdownMenuTriggerDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class Rdx {}



# ./dropdown-menu/src/dropdown-menu-item-radio.directive.ts

import { UniqueSelectionDispatcher } from '@angular/cdk/collections';
import { CDK_MENU, CdkMenuItem } from '@angular/cdk/menu';
import { AfterContentInit, Directive, inject, Input, OnDestroy } from '@angular/core';
import { RdxDropdownMenuContentDirective } from './dropdown-menu-content.directive';
import { RdxDropdownMenuItemRadioGroupDirective } from './dropdown-menu-item-radio-group.directive';
import { RdxDropdownMenuSelectable } from './dropdown-menu-item-selectable';
import { RdxDropdownMenuItemDirective } from './dropdown-menu-item.directive';

/** Counter used to set a unique id and name for a selectable item */
let nextId = 0;

@Directive({
    selector: '[rdxDropdownMenuItemRadio]',
    standalone: true,
    host: {
        role: 'menuitemradio'
    },
    providers: [
        { provide: RdxDropdownMenuSelectable, useExisting: RdxDropdownMenuItemRadioDirective },
        { provide: RdxDropdownMenuItemDirective, useExisting: RdxDropdownMenuSelectable },
        { provide: CdkMenuItem, useExisting: RdxDropdownMenuItemDirective },
        { provide: CDK_MENU, useExisting: RdxDropdownMenuContentDirective }
    ]
})
export class RdxDropdownMenuItemRadioDirective
    extends RdxDropdownMenuSelectable
    implements AfterContentInit, OnDestroy
{
    /** The unique selection dispatcher for this radio's `RdxDropdownMenuItemRadioGroupDirective`. */
    private readonly selectionDispatcher = inject(UniqueSelectionDispatcher);

    private readonly group = inject(RdxDropdownMenuItemRadioGroupDirective);

    @Input()
    get value() {
        return this._value || this.id;
    }

    set value(value: string) {
        this._value = value;
    }

    private _value: string | undefined;

    /** An ID to identify this radio item to the `UniqueSelectionDispatcher`. */
    private id = `${nextId++}`;

    private removeDispatcherListener!: () => void;

    constructor() {
        super();

        this.triggered.subscribe(() => {
            if (!this.disabled) {
                this.selectionDispatcher.notify(this.value, '');

                this.group.valueChange.emit(this.value);
            }
        });
    }

    ngAfterContentInit() {
        this.removeDispatcherListener = this.selectionDispatcher.listen((id: string) => {
            this.checked = this.value === id;
        });
    }

    override ngOnDestroy() {
        super.ngOnDestroy();
        this.removeDispatcherListener();
    }
}



# ./dropdown-menu/src/dropdown-menu-label.directive.ts

import { Directive } from '@angular/core';
import { RdxMenuLabelDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[rdxDropdownMenuLabel]',
    hostDirectives: [RdxMenuLabelDirective]
})
export class RdxDropdownMenuLabelDirective {}



# ./dropdown-menu/src/dropdown-menu-item-indicator.directive.ts

import { Directive, inject } from '@angular/core';
import { RdxDropdownMenuSelectable } from './dropdown-menu-item-selectable';

@Directive({
    selector: '[rdxDropdownMenuItemIndicator]',
    standalone: true,
    host: {
        '[style.display]': "item.checked ? 'block' : 'none'",
        '[attr.data-state]': "item.checked ? 'checked' : 'unchecked'"
    }
})
export class RdxDropdownMenuItemIndicatorDirective {
    item = inject(RdxDropdownMenuSelectable);
}



# ./dropdown-menu/src/dropdown-menu-item.directive.ts

import { CDK_MENU, CdkMenuItem } from '@angular/cdk/menu';
import { booleanAttribute, Directive, ElementRef, EventEmitter, inject, Input, Output } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

import { RdxDropdownMenuContentDirective } from './dropdown-menu-content.directive';

@Directive({
    selector: '[rdxDropdownMenuItem]',
    standalone: true,
    host: {
        type: 'button',
        // todo horizontal ?
        '[attr.data-orientation]': '"vertical"',
        '[attr.data-highlighted]': 'highlighted ? "" : null',
        '[attr.data-disabled]': 'disabled ? "" : null',
        '[attr.disabled]': 'disabled ? "" : null',
        '(pointermove)': 'onPointerMove()',
        '(focus)': 'menu.highlighted.next(this)',
        '(keydown)': 'onKeydown($event)'
    },
    providers: [
        { provide: CdkMenuItem, useExisting: RdxDropdownMenuItemDirective },
        { provide: CDK_MENU, useExisting: RdxDropdownMenuContentDirective }
    ]
})
export class RdxDropdownMenuItemDirective extends CdkMenuItem {
    protected readonly menu = inject(RdxDropdownMenuContentDirective);
    protected readonly nativeElement = inject(ElementRef).nativeElement;

    highlighted = false;

    @Input({ transform: booleanAttribute }) override disabled: boolean = false;

    @Output() readonly onSelect = new EventEmitter<void>();

    constructor() {
        super();

        this.menu.highlighted.pipe(takeUntilDestroyed()).subscribe((value) => {
            if (value !== this) {
                this.highlighted = false;
            }
        });

        this.triggered.subscribe(this.onSelect);
    }

    protected onPointerMove() {
        if (!this.highlighted) {
            this.nativeElement.focus({ preventScroll: true });
            this.menu.updateActiveItem(this);
        }
    }

    protected onKeydown(event: KeyboardEvent) {
        if (this.nativeElement.tagName !== 'BUTTON' && ['Enter', ' '].includes(event.key)) {
            event.preventDefault();
        }

        if (event.key === 'Escape') {
            if (!this.menu.closeOnEscape) {
                event.stopPropagation();
            } else {
                this.menu.onEscapeKeyDown(event);
            }
        }
    }
}



# ./dropdown-menu/src/dropdown-menu-separator.directive.ts

import { Directive } from '@angular/core';
import { RdxMenuSeparatorDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[rdxDropdownMenuSeparator]',
    hostDirectives: [RdxMenuSeparatorDirective]
})
export class RdxDropdownMenuSeparatorDirective {}



# ./dropdown-menu/src/dropdown-menu-item-selectable.ts

import { booleanAttribute, Directive, EventEmitter, Input, Output } from '@angular/core';
import { RdxDropdownMenuItemDirective } from './dropdown-menu-item.directive';

/** Base class providing checked state for selectable DropdownMenuItems. */
@Directive({
    standalone: true,
    host: {
        '[attr.aria-checked]': '!!checked',
        '[attr.aria-disabled]': 'disabled || null',
        '[attr.data-state]': 'checked ? "checked" : "unchecked"'
    }
})
export class RdxDropdownMenuSelectable extends RdxDropdownMenuItemDirective {
    /** Whether the element is checked */
    @Input({ transform: booleanAttribute }) checked: boolean = false;

    @Output() readonly checkedChange = new EventEmitter<boolean>();
}



# ./dropdown-menu/src/dropdown-menu-item-checkbox.directive.ts

import { CDK_MENU, CdkMenuItem } from '@angular/cdk/menu';
import { Directive } from '@angular/core';
import { RdxDropdownMenuContentDirective } from './dropdown-menu-content.directive';
import { RdxDropdownMenuSelectable } from './dropdown-menu-item-selectable';
import { RdxDropdownMenuItemDirective } from './dropdown-menu-item.directive';

@Directive({
    selector: '[rdxDropdownMenuItemCheckbox]',
    standalone: true,
    host: {
        role: 'menuitemcheckbox'
    },
    providers: [
        { provide: RdxDropdownMenuSelectable, useExisting: RdxDropdownMenuItemCheckboxDirective },
        { provide: RdxDropdownMenuItemDirective, useExisting: RdxDropdownMenuSelectable },
        { provide: CdkMenuItem, useExisting: RdxDropdownMenuItemDirective },
        { provide: CDK_MENU, useExisting: RdxDropdownMenuContentDirective }
    ]
})
export class RdxDropdownMenuItemCheckboxDirective extends RdxDropdownMenuSelectable {
    override trigger(options?: { keepOpen: boolean }) {
        if (!this.disabled) {
            this.checked = !this.checked;

            this.checkedChange.emit(this.checked);
        }

        super.trigger(options);
    }
}



# ./dropdown-menu/src/dropdown-menu-content.directive.ts

import { CdkMenu, CdkMenuItem } from '@angular/cdk/menu';
import { Directive, inject, Input } from '@angular/core';
import { pairwise, startWith, Subject } from 'rxjs';
import { RdxDropdownMenuItemDirective } from './dropdown-menu-item.directive';
import { RdxDropdownMenuTriggerDirective } from './dropdown-menu-trigger.directive';

@Directive({
    selector: '[rdxDropdownMenuContent]',
    standalone: true,
    host: {
        '[attr.data-state]': "menuTrigger.isOpen() ? 'open': 'closed'",
        '[attr.data-align]': 'menuTrigger!.align',
        '[attr.data-side]': 'menuTrigger!.side',
        '[attr.data-orientation]': 'orientation'
    },
    providers: [
        {
            provide: CdkMenu,
            useExisting: RdxDropdownMenuContentDirective
        }
    ]
})
export class RdxDropdownMenuContentDirective extends CdkMenu {
    readonly highlighted = new Subject<RdxDropdownMenuItemDirective>();
    readonly menuTrigger = inject(RdxDropdownMenuTriggerDirective, { optional: true });

    @Input() onEscapeKeyDown: (event?: Event) => void = () => undefined;
    @Input() closeOnEscape: boolean = true;

    constructor() {
        super();

        this.highlighted.pipe(startWith(null), pairwise()).subscribe(([prev, item]) => {
            if (prev) {
                prev.highlighted = false;
            }

            if (item) {
                item.highlighted = true;
            }
        });
    }

    updateActiveItem(item: CdkMenuItem) {
        this.keyManager.updateActiveItem(item);
    }
}



# ./dropdown-menu/src/dropdown-menu-trigger.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import { CdkMenuTrigger, MENU_TRIGGER, PARENT_OR_NEW_MENU_STACK_PROVIDER } from '@angular/cdk/menu';
import { ConnectedPosition, OverlayRef, VerticalConnectionPos } from '@angular/cdk/overlay';
import { booleanAttribute, Directive, Input, input, numberAttribute, TemplateRef } from '@angular/core';
import { outputFromObservable } from '@angular/core/rxjs-interop';

export enum DropdownSide {
    Top = 'top',
    Right = 'right',
    Bottom = 'bottom',
    Left = 'left'
}

export enum DropdownAlign {
    Start = 'start',
    Center = 'center',
    End = 'end'
}

export const mapRdxAlignToCdkPosition = {
    start: 'top',
    center: 'center',
    end: 'bottom'
};

const dropdownPositions: Record<DropdownSide, ConnectedPosition> = {
    top: {
        originX: 'start',
        originY: 'top',
        overlayX: 'start',
        overlayY: 'bottom',
        offsetX: 0,
        offsetY: 0
    },
    right: {
        originX: 'end',
        originY: 'top',
        overlayX: 'start',
        overlayY: 'top',
        offsetX: 0,
        offsetY: 0
    },
    bottom: {
        originX: 'start',
        originY: 'bottom',
        overlayX: 'start',
        overlayY: 'top',
        offsetX: 0,
        offsetY: 0
    },
    left: {
        originX: 'start',
        originY: 'top',
        overlayX: 'end',
        overlayY: 'top',
        offsetX: 0,
        offsetY: 0
    }
};

/**
 * @group Components
 */
@Directive({
    selector: '[rdxDropdownMenuTrigger]',
    standalone: true,
    host: {
        type: 'button',
        '[attr.aria-haspopup]': "'menu'",
        '[attr.aria-expanded]': 'isOpen()',
        '[attr.data-state]': "isOpen() ? 'open': 'closed'",
        '[attr.data-disabled]': "disabled() ? '' : undefined",
        '[disabled]': 'disabled()',

        '(pointerdown)': 'onPointerDown($event)'
    },
    providers: [
        { provide: CdkMenuTrigger, useExisting: RdxDropdownMenuTriggerDirective },
        { provide: MENU_TRIGGER, useExisting: CdkMenuTrigger },
        PARENT_OR_NEW_MENU_STACK_PROVIDER
    ]
})
export class RdxDropdownMenuTriggerDirective extends CdkMenuTrigger {
    readonly disabled = input<boolean, BooleanInput>(false, {
        transform: booleanAttribute
    });

    @Input()
    set rdxDropdownMenuTrigger(value: TemplateRef<unknown> | null) {
        this.menuTemplateRef = value;
    }

    /**
     * The preferred side of the trigger to render against when open.
     * Will be reversed when collisions occur and `avoidCollisions` is enabled.
     *
     * @group Props
     * @defaultValue 'bottom'
     */
    @Input()
    set side(value: DropdownSide) {
        if (!Object.values(DropdownSide).includes(value)) {
            throw new Error(`Unknown side: ${value}`);
        }

        this._side = value;

        this.menuPosition[0] = dropdownPositions[value];
    }

    get side(): DropdownSide {
        return this._side;
    }

    private _side: DropdownSide = DropdownSide.Bottom;

    /**
     * The preferred alignment against the trigger. May change when collisions occur.
     *
     * @group Props
     * @defaultValue 'center'
     */
    @Input()
    set align(value: DropdownAlign) {
        if (!Object.values(DropdownAlign).includes(value)) {
            throw new Error(`Unknown align: ${value}`);
        }

        this._align = value;

        if (this.isVertical) {
            this.defaultPosition.overlayX = this.defaultPosition.originX = value;
        } else {
            this.defaultPosition.overlayY = this.defaultPosition.originY = mapRdxAlignToCdkPosition[
                value
            ] as VerticalConnectionPos;
        }
    }

    get align() {
        return this._align;
    }

    private _align: DropdownAlign = DropdownAlign.Start;

    /**
     * The distance in pixels from the trigger.
     * @group Props
     * @defaultValue 0
     */
    @Input({ transform: numberAttribute })
    set sideOffset(value: number) {
        // todo need invert value for top and left
        if (this.isVertical) {
            this.defaultPosition.offsetY = value;
        } else {
            this.defaultPosition.offsetX = value;
        }
    }

    get sideOffset() {
        return this._sideOffset;
    }

    private _sideOffset: number = 0;

    /**
     * An offset in pixels from the "start" or "end" alignment options.
     * @group Props
     * @defaultValue 0
     */
    @Input({ transform: numberAttribute })
    set alignOffset(value: number) {
        // todo need invert value for top and left
        if (this.isVertical) {
            this.defaultPosition.offsetX = value;
        } else {
            this.defaultPosition.offsetY = value;
        }
    }

    get alignOffset(): number {
        return this._alignOffset;
    }

    private _alignOffset: number = 0;

    onOpenChange = outputFromObservable(this.opened);

    get isVertical(): boolean {
        return this._side === DropdownSide.Top || this._side === DropdownSide.Bottom;
    }

    get defaultPosition(): ConnectedPosition {
        return this.menuPosition[0];
    }

    constructor() {
        super();
        // todo priority
        this.menuPosition = [{ ...dropdownPositions[DropdownSide.Bottom] }];
    }

    onPointerDown($event: MouseEvent) {
        // only call handler if it's the left button (mousedown gets triggered by all mouse buttons)
        // but not when the control key is pressed (avoiding MacOS right click)
        if (!this.disabled() && $event.button === 0 && !$event.ctrlKey) {
            /* empty */
            if (!this.isOpen()) {
                // prevent trigger focusing when opening
                // this allows the content to be given focus without competition
                $event.preventDefault();
            }
        }
    }

    getOverlayRef(): OverlayRef | null {
        return this.overlayRef;
    }
}



# ./dropdown-menu/src/dropdown-menu-item-radio-group.directive.ts

import { UniqueSelectionDispatcher } from '@angular/cdk/collections';
import { AfterContentInit, Directive, EventEmitter, inject, Input, Output } from '@angular/core';

@Directive({
    selector: '[rdxDropdownMenuItemRadioGroup]',
    standalone: true,
    host: {
        role: 'group'
    },
    providers: [{ provide: UniqueSelectionDispatcher, useClass: UniqueSelectionDispatcher }]
})
export class RdxDropdownMenuItemRadioGroupDirective<T> implements AfterContentInit {
    private readonly selectionDispatcher = inject(UniqueSelectionDispatcher);

    @Input()
    set value(id: T | null) {
        this._value = id;
    }

    get value(): T | null {
        return this._value;
    }

    private _value: T | null = null;

    @Output() readonly valueChange = new EventEmitter();

    ngAfterContentInit(): void {
        this.selectionDispatcher.notify(this.value as string, '');
    }
}



# ./slider/README.md

# @radix-ng/primitives/slider



# ./slider/index.ts

import { NgModule } from '@angular/core';
import { RdxSliderRangeComponent } from './src/slider-range.component';
import { RdxSliderRootComponent } from './src/slider-root.component';
import { RdxSliderThumbComponent } from './src/slider-thumb.component';
import { RdxSliderTrackComponent } from './src/slider-track.component';

export * from './src/slider-horizontal.component';
export * from './src/slider-impl.directive';
export * from './src/slider-range.component';
export * from './src/slider-root.component';
export * from './src/slider-thumb-impl.directive';
export * from './src/slider-thumb.component';
export * from './src/slider-track.component';
export * from './src/slider-vertical.component';

const _imports = [RdxSliderRootComponent, RdxSliderTrackComponent, RdxSliderRangeComponent, RdxSliderThumbComponent];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxSliderModule {}



# ./slider/src/slider-range.component.ts

import { Component, computed, inject } from '@angular/core';
import { RdxSliderRootComponent } from './slider-root.component';
import { convertValueToPercentage } from './utils';

@Component({
    selector: 'rdx-slider-range',
    host: {
        '[attr.data-disabled]': 'rootContext.disabled() ? "" : undefined',
        '[attr.data-orientation]': 'rootContext.orientation()',
        '[style]': 'rangeStyles()'
    },
    template: `
        <ng-content />
    `
})
export class RdxSliderRangeComponent {
    protected readonly rootContext = inject(RdxSliderRootComponent);

    percentages = computed(() =>
        this.rootContext
            .modelValue()
            ?.map((value) => convertValueToPercentage(value, this.rootContext.min(), this.rootContext.max()))
    );

    offsetStart = computed(() => (this.rootContext.modelValue()!.length > 1 ? Math.min(...this.percentages()!) : 0));
    offsetEnd = computed(() => 100 - Math.max(...this.percentages()!));

    rangeStyles = computed(() => {
        const context = this.rootContext.orientationContext.context;

        return {
            [context.startEdge]: `${this.offsetStart()}%`,
            [context.endEdge]: `${this.offsetEnd()}%`
        };
    });
}



# ./slider/src/slider-root.component.ts

import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import { NgIf, NgTemplateOutlet } from '@angular/common';
import {
    booleanAttribute,
    Component,
    computed,
    inject,
    input,
    Input,
    model,
    numberAttribute,
    OnInit,
    output
} from '@angular/core';
import { RdxSliderHorizontalComponent } from './slider-horizontal.component';
import { RdxSliderOrientationContextService } from './slider-orientation-context.service';
import { RdxSliderVerticalComponent } from './slider-vertical.component';
import {
    clamp,
    getClosestValueIndex,
    getDecimalCount,
    getNextSortedValues,
    hasMinStepsBetweenValues,
    roundValue
} from './utils';

/**
 * @group Components
 */
@Component({
    selector: 'rdx-slider',
    imports: [RdxSliderHorizontalComponent, RdxSliderVerticalComponent, NgIf, NgTemplateOutlet],
    providers: [RdxSliderOrientationContextService],
    template: `
        <ng-template #transclude><ng-content /></ng-template>

        <ng-container *ngIf="orientation() === 'horizontal'">
            <rdx-slider-horizontal
                [className]="styleClass() || className"
                [min]="min()"
                [max]="max()"
                [dir]="dir()"
                [inverted]="inverted()"
                [attr.aria-disabled]="disabled()"
                [attr.data-disabled]="disabled() ? '' : undefined"
                (pointerdown)="onPointerDown()"
                (slideStart)="handleSlideStart($event)"
                (slideMove)="handleSlideMove($event)"
                (slideEnd)="handleSlideEnd()"
                (homeKeyDown)="updateValues(min(), 0, true)"
                (endKeyDown)="updateValues(max(), modelValue().length - 1, true)"
                (stepKeyDown)="handleStepKeyDown($event)"
            >
                <ng-container *ngTemplateOutlet="transclude" />
            </rdx-slider-horizontal>
        </ng-container>

        <ng-container *ngIf="orientation() === 'vertical'">
            <rdx-slider-vertical
                [className]="styleClass() || className"
                [min]="min()"
                [max]="max()"
                [dir]="dir()"
                [inverted]="inverted()"
                [attr.aria-disabled]="disabled()"
                [attr.data-disabled]="disabled() ? '' : undefined"
                (pointerdown)="onPointerDown()"
                (slideStart)="handleSlideStart($event)"
                (slideMove)="handleSlideMove($event)"
                (slideEnd)="handleSlideEnd()"
                (homeKeyDown)="updateValues(min(), 0, true)"
                (endKeyDown)="updateValues(max(), modelValue().length - 1, true)"
                (stepKeyDown)="handleStepKeyDown($event)"
            >
                <ng-container *ngTemplateOutlet="transclude" />
            </rdx-slider-vertical>
        </ng-container>
    `
})
export class RdxSliderRootComponent implements OnInit {
    /** @ignore */
    readonly orientationContext = inject(RdxSliderOrientationContextService);

    /**
     * The minimum value for the range.
     *
     * @group Props
     * @defaultValue 0
     */
    readonly min = input<number, NumberInput>(0, { transform: numberAttribute });

    /**
     * The maximum value for the range.
     *
     * @group Props
     * @defaultValue 100
     */
    readonly max = input<number, NumberInput>(100, { transform: numberAttribute });

    /**
     * The stepping interval.
     *
     * @group Props
     * @defaultValue 1
     */
    readonly step = input<number, NumberInput>(1, { transform: numberAttribute });

    /**
     * The minimum permitted steps between multiple thumbs.
     *
     * @group Props
     * @defaultValue 0
     */
    readonly minStepsBetweenThumbs = input<number, NumberInput>(0, { transform: numberAttribute });

    /**
     * The orientation of the slider.
     *
     * @group Props
     * @defaultValue 'horizontal'
     */
    readonly orientation = input<'horizontal' | 'vertical'>('horizontal');

    /**
     * When true, prevents the user from interacting with the slider.
     *
     * @group Props
     * @defaultValue false
     */
    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * Whether the slider is visually inverted.
     *
     * @group Props
     * @defaultValue false
     */
    readonly inverted = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * The reading direction of the combobox when applicable.
     *
     * @group Props
     * @defaultValue 'ltr'
     */
    readonly dir = input<'ltr' | 'rtl'>('ltr');

    @Input() className: string = '';

    /**
     * Style class of the component.
     *
     * @group Props
     */
    readonly styleClass = input<string>();

    /**
     * The controlled value of the slider.
     *
     * @group Props
     */
    readonly modelValue = model<number[]>([0]);

    /**
     * Event handler called when the slider value changes.
     *
     * @group Emits
     */
    readonly valueChange = output<number[]>();

    /**
     * Event handler called when the value changes at the end of an interaction.
     *
     * Useful when you only need to capture a final value e.g. to update a backend service.
     *
     * @group Emits
     */
    readonly valueCommit = output<number[]>();

    /** @ignore */
    readonly valueIndexToChange = model(0);

    /** @ignore */
    readonly valuesBeforeSlideStart = model<number[]>([]);

    /** @ignore */
    readonly isSlidingFromLeft = computed(
        () => (this.dir() === 'ltr' && !this.inverted()) || (this.dir() !== 'ltr' && this.inverted())
    );

    /** @ignore */
    readonly isSlidingFromBottom = computed(() => !this.inverted());

    /** @ignore */
    thumbElements: HTMLElement[] = [];

    /** @ignore */
    ngOnInit() {
        const isHorizontal = this.orientation() === 'horizontal';

        if (isHorizontal) {
            this.orientationContext.updateContext({
                direction: this.isSlidingFromLeft() ? 1 : -1,
                size: 'width',
                startEdge: this.isSlidingFromLeft() ? 'left' : 'right',
                endEdge: this.isSlidingFromLeft() ? 'right' : 'left'
            });
        } else {
            this.orientationContext.updateContext({
                direction: this.isSlidingFromBottom() ? -1 : 1,
                size: 'height',
                startEdge: this.isSlidingFromBottom() ? 'bottom' : 'top',
                endEdge: this.isSlidingFromBottom() ? 'top' : 'bottom'
            });
        }
    }

    /** @ignore */
    onPointerDown() {
        this.valuesBeforeSlideStart.set([...this.modelValue()]);
    }

    /** @ignore */
    handleSlideStart(value: number): void {
        const closestIndex = getClosestValueIndex(this.modelValue(), value);
        this.updateValues(value, closestIndex);
    }

    /** @ignore */
    handleSlideMove(value: number): void {
        this.updateValues(value, this.valueIndexToChange());
    }

    /** @ignore */
    handleSlideEnd(): void {
        const prevValue = this.valuesBeforeSlideStart()[this.valueIndexToChange()];
        const nextValue = this.modelValue()[this.valueIndexToChange()];
        const hasChanged = nextValue !== prevValue;

        if (hasChanged) {
            this.valueCommit.emit([...this.modelValue()]);
        }
    }

    /** @ignore */
    handleStepKeyDown(event: { event: KeyboardEvent; direction: number }): void {
        const stepInDirection = this.step() * event.direction;
        const atIndex = this.valueIndexToChange();
        const currentValue = this.modelValue()[atIndex];
        this.updateValues(currentValue + stepInDirection, atIndex, true);
    }

    /** @ignore */
    updateValues(value: number, atIndex: number, commit = false): void {
        const decimalCount = getDecimalCount(this.step());
        const snapToStep = roundValue(
            Math.round((value - this.min()) / this.step()) * this.step() + this.min(),
            decimalCount
        );
        const nextValue = clamp(snapToStep, this.min(), this.max());

        const nextValues = getNextSortedValues(this.modelValue(), nextValue, atIndex);

        if (hasMinStepsBetweenValues(nextValues, this.minStepsBetweenThumbs() * this.step())) {
            this.valueIndexToChange.set(nextValues.indexOf(nextValue));
            const hasChanged = String(nextValues) !== String(this.modelValue());

            if (hasChanged) {
                this.modelValue.set(nextValues);
                this.valueChange.emit([...this.modelValue()]);
                this.thumbElements[this.valueIndexToChange()]?.focus();

                if (commit) {
                    this.valueCommit.emit([...this.modelValue()]);
                }
            }
        }
    }
}



# ./slider/src/slider-impl.directive.ts

import { Directive, inject, output } from '@angular/core';
import { RdxSliderRootComponent } from './slider-root.component';
import { ARROW_KEYS, PAGE_KEYS } from './utils';

@Directive({
    selector: '[rdxSliderImpl]',
    host: {
        role: 'slider',
        tabindex: '0',
        '(keydown)': 'onKeyDown($event)',
        '(pointerdown)': 'onPointerDown($event)',
        '(pointermove)': 'onPointerMove($event)',
        '(pointerup)': 'onPointerUp($event)'
    }
})
export class RdxSliderImplDirective {
    protected readonly rootContext = inject(RdxSliderRootComponent);

    readonly slideStart = output<PointerEvent>();
    readonly slideMove = output<PointerEvent>();
    readonly slideEnd = output<PointerEvent>();
    readonly homeKeyDown = output<KeyboardEvent>();
    readonly endKeyDown = output<KeyboardEvent>();
    readonly stepKeyDown = output<KeyboardEvent>();

    onKeyDown(event: KeyboardEvent) {
        if (event.key === 'Home') {
            this.homeKeyDown.emit(event);
            // Prevent scrolling to page start
            event.preventDefault();
        } else if (event.key === 'End') {
            this.endKeyDown.emit(event);
            // Prevent scrolling to page end
            event.preventDefault();
        } else if (PAGE_KEYS.concat(ARROW_KEYS).includes(event.key)) {
            this.stepKeyDown.emit(event);
            // Prevent scrolling for directional key presses
            event.preventDefault();
        }
    }

    onPointerDown(event: PointerEvent) {
        const target = event.target as HTMLElement;
        target.setPointerCapture(event.pointerId);

        // Prevent browser focus behaviour because we focus a thumb manually when values change.
        event.preventDefault();

        // Touch devices have a delay before focusing so won't focus if touch immediately moves
        // away from target (sliding). We want thumb to focus regardless.
        if (this.rootContext.thumbElements.includes(target)) {
            target.focus();
        } else {
            this.slideStart.emit(event);
        }
    }

    onPointerMove(event: PointerEvent) {
        const target = event.target as HTMLElement;
        if (target.hasPointerCapture(event.pointerId)) {
            this.slideMove.emit(event);
        }
    }

    onPointerUp(event: PointerEvent) {
        const target = event.target as HTMLElement;
        if (target.hasPointerCapture(event.pointerId)) {
            target.releasePointerCapture(event.pointerId);
            this.slideEnd.emit(event);
        }
    }
}



# ./slider/src/slider-vertical.component.ts

import { BooleanInput } from '@angular/cdk/coercion';
import {
    booleanAttribute,
    Component,
    ElementRef,
    inject,
    input,
    Input,
    output,
    signal,
    viewChild
} from '@angular/core';
import { RdxSliderImplDirective } from './slider-impl.directive';
import { RdxSliderRootComponent } from './slider-root.component';
import { BACK_KEYS, linearScale } from './utils';

@Component({
    selector: 'rdx-slider-vertical',
    imports: [RdxSliderImplDirective],
    template: `
        <span
            #sliderElement
            [class]="className"
            [attr.data-orientation]="'vertical'"
            [style]="{ '--rdx-slider-thumb-transform': 'translateY(-50%)' }"
            (slideStart)="onSlideStart($event)"
            (slideMove)="onSlideMove($event)"
            (slideEnd)="onSlideEnd()"
            (stepKeyDown)="onStepKeyDown($event)"
            (endKeyDown)="endKeyDown.emit($event)"
            (homeKeyDown)="homeKeyDown.emit($event)"
            rdxSliderImpl
        >
            <ng-content />
        </span>
    `
})
export class RdxSliderVerticalComponent {
    private readonly rootContext = inject(RdxSliderRootComponent);

    @Input() dir: 'ltr' | 'rtl' = 'ltr';

    readonly inverted = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    @Input() min = 0;
    @Input() max = 100;

    @Input() className = '';

    readonly slideStart = output<number>();
    readonly slideMove = output<number>();
    readonly slideEnd = output<void>();
    readonly stepKeyDown = output<{ event: KeyboardEvent; direction: number }>();
    readonly endKeyDown = output<KeyboardEvent>();
    readonly homeKeyDown = output<KeyboardEvent>();

    private readonly sliderElement = viewChild<ElementRef>('sliderElement');

    private readonly rect = signal<DOMRect | undefined>(undefined);

    onSlideStart(event: PointerEvent) {
        const value = this.getValueFromPointer(event.clientY);
        this.slideStart.emit(value);
    }

    onSlideMove(event: PointerEvent) {
        const value = this.getValueFromPointer(event.clientY);
        this.slideMove.emit(value);
    }

    onSlideEnd() {
        this.rect.set(undefined);
        this.slideEnd.emit();
    }

    onStepKeyDown(event: KeyboardEvent) {
        const slideDirection = this.rootContext.isSlidingFromBottom() ? 'from-bottom' : 'from-top';
        const isBackKey = BACK_KEYS[slideDirection].includes(event.key);

        this.stepKeyDown.emit({ event, direction: isBackKey ? -1 : 1 });
    }

    private getValueFromPointer(pointerPosition: number): number {
        this.rect.set(this.sliderElement()?.nativeElement.getBoundingClientRect());
        const rect = this.rect();
        if (!rect) return 0;

        const input: [number, number] = [0, rect.height];
        const output: [number, number] = this.rootContext.isSlidingFromBottom()
            ? [this.max, this.min]
            : [this.min, this.max];

        const value = linearScale(input, output);
        this.rect.set(rect);

        return value(pointerPosition - rect.top);
    }
}



# ./slider/src/slider-horizontal.component.ts

import { BooleanInput } from '@angular/cdk/coercion';
import {
    booleanAttribute,
    Component,
    ElementRef,
    inject,
    input,
    Input,
    output,
    signal,
    viewChild
} from '@angular/core';
import { RdxSliderImplDirective } from './slider-impl.directive';
import { RdxSliderRootComponent } from './slider-root.component';
import { BACK_KEYS, linearScale } from './utils';

@Component({
    selector: 'rdx-slider-horizontal',
    imports: [RdxSliderImplDirective],
    template: `
        <span
            #sliderElement
            [class]="className"
            [attr.data-orientation]="'horizontal'"
            [style]="{ '--rdx-slider-thumb-transform': 'translateX(-50%)' }"
            (slideStart)="onSlideStart($event)"
            (slideMove)="onSlideMove($event)"
            (slideEnd)="onSlideEnd()"
            (stepKeyDown)="onStepKeyDown($event)"
            (endKeyDown)="endKeyDown.emit($event)"
            (homeKeyDown)="homeKeyDown.emit($event)"
            rdxSliderImpl
        >
            <ng-content />
        </span>
    `
})
export class RdxSliderHorizontalComponent {
    private readonly rootContext = inject(RdxSliderRootComponent);

    @Input() dir: 'ltr' | 'rtl' = 'ltr';

    readonly inverted = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    @Input() min = 0;
    @Input() max = 100;

    @Input() className = '';

    readonly slideStart = output<number>();
    readonly slideMove = output<number>();
    readonly slideEnd = output<void>();
    readonly stepKeyDown = output<{ event: KeyboardEvent; direction: number }>();
    readonly endKeyDown = output<KeyboardEvent>();
    readonly homeKeyDown = output<KeyboardEvent>();

    private readonly sliderElement = viewChild<ElementRef>('sliderElement');

    private readonly rect = signal<DOMRect | undefined>(undefined);

    onSlideStart(event: PointerEvent) {
        const value = this.getValueFromPointer(event.clientX);
        this.slideStart.emit(value);
    }

    onSlideMove(event: PointerEvent) {
        const value = this.getValueFromPointer(event.clientX);
        this.slideMove.emit(value);
    }

    onSlideEnd() {
        this.rect.set(undefined);
        this.slideEnd.emit();
    }

    onStepKeyDown(event: KeyboardEvent) {
        const slideDirection = this.rootContext.isSlidingFromLeft() ? 'from-left' : 'from-right';
        const isBackKey = BACK_KEYS[slideDirection].includes(event.key);

        this.stepKeyDown.emit({ event, direction: isBackKey ? -1 : 1 });
    }

    private getValueFromPointer(pointerPosition: number): number {
        this.rect.set(this.sliderElement()?.nativeElement.getBoundingClientRect());
        const rect = this.rect();
        if (!rect) return 0;

        const input: [number, number] = [0, rect.width];
        const output: [number, number] = this.rootContext.isSlidingFromLeft()
            ? [this.min, this.max]
            : [this.max, this.min];

        const value = linearScale(input, output);
        this.rect.set(rect);

        return value(pointerPosition - rect.left);
    }
}



# ./slider/src/slider-track.component.ts

import { Component, inject } from '@angular/core';
import { RdxSliderRootComponent } from './slider-root.component';

@Component({
    selector: 'rdx-slider-track',
    host: {
        '[attr.data-disabled]': "rootContext.disabled() ? '' : undefined",
        '[attr.data-orientation]': 'rootContext.orientation()'
    },
    template: `
        <ng-content />
    `
})
export class RdxSliderTrackComponent {
    protected readonly rootContext = inject(RdxSliderRootComponent);
}



# ./slider/src/slider-thumb-impl.directive.ts

import { isPlatformBrowser } from '@angular/common';
import { computed, Directive, ElementRef, inject, OnDestroy, OnInit, PLATFORM_ID, signal } from '@angular/core';
import { RdxSliderRootComponent } from './slider-root.component';
import { convertValueToPercentage, getThumbInBoundsOffset } from './utils';

@Directive({
    selector: '[rdxSliderThumbImpl]',
    host: {
        role: 'slider',
        '[tabindex]': 'rootContext.disabled() ? undefined : 0',

        '[attr.aria-valuenow]': 'rootContext.modelValue()',
        '[attr.aria-valuemin]': 'rootContext.min()',
        '[attr.aria-valuemax]': 'rootContext.max()',
        '[attr.aria-orientation]': 'rootContext.orientation()',

        '[attr.data-orientation]': 'rootContext.orientation()',
        '[attr.data-disabled]': 'rootContext.disabled() ? "" : undefined',

        '[style]': 'combinedStyles()',

        '(focus)': 'onFocus()'
    }
})
export class RdxSliderThumbImplDirective implements OnInit, OnDestroy {
    protected readonly rootContext = inject(RdxSliderRootComponent);
    private readonly elementRef = inject(ElementRef);
    private readonly platformId = inject(PLATFORM_ID);
    private resizeObserver!: ResizeObserver;

    isMounted = signal(false);

    thumbIndex = computed(() => {
        const thumbElement = this.elementRef.nativeElement;
        const index = this.rootContext.thumbElements.indexOf(thumbElement);
        return index >= 0 ? index : null;
    });

    value = computed(() => {
        const index = this.thumbIndex();
        if (index === null) return undefined;
        return this.rootContext.modelValue()?.[index];
    });

    percent = computed(() => {
        const val = this.value();
        if (val === undefined) return 0;
        return convertValueToPercentage(val, this.rootContext.min(), this.rootContext.max());
    });

    transform = computed(() => {
        const percent = this.percent();
        const offset = this.thumbInBoundsOffset();
        return `calc(${percent}% + ${offset}px)`;
    });

    orientationSize = signal(0);

    thumbInBoundsOffset = computed(() => {
        const context = this.rootContext.orientationContext.context;

        const size = this.orientationSize();
        const percent = this.percent();
        const direction = context.direction;

        return size ? getThumbInBoundsOffset(size, percent, direction) : 0;
    });

    combinedStyles = computed(() => {
        const context = this.rootContext.orientationContext.context;

        const startEdge = context.startEdge;
        const percent = this.percent();
        const offset = this.thumbInBoundsOffset();

        return {
            position: 'absolute',
            transform: 'var(--rdx-slider-thumb-transform)',
            display: (this.isMounted() && this.value()) === false ? 'none' : undefined,
            [startEdge]: `calc(${percent}% + ${offset}px)`
        };
    });

    onFocus() {
        if (this.thumbIndex() !== null) {
            this.rootContext.valueIndexToChange.set(this.thumbIndex()!);
        }
    }

    ngOnInit() {
        if (isPlatformBrowser(this.platformId)) {
            const thumbElement = this.elementRef.nativeElement;
            this.rootContext.thumbElements.push(thumbElement);

            this.resizeObserver = new ResizeObserver(() => {
                const rect = thumbElement.getBoundingClientRect();
                const context = this.rootContext.orientationContext.context;
                const size = context.size === 'width' ? rect.width : rect.height;
                this.orientationSize.set(size);
            });

            this.resizeObserver.observe(thumbElement);

            this.isMounted.set(true);
        }
    }

    ngOnDestroy() {
        const thumbElement = this.elementRef.nativeElement;
        const index = this.rootContext.thumbElements.indexOf(thumbElement);
        if (index >= 0) this.rootContext.thumbElements.splice(index, 1);

        if (this.resizeObserver) {
            this.resizeObserver.unobserve(thumbElement);
        }

        this.isMounted.set(false);
    }
}



# ./slider/src/utils.ts

// https://github.com/tmcw-up-for-adoption/simple-linear-scale/blob/master/index.js
export function linearScale(input: readonly [number, number], output: readonly [number, number]) {
    return (value: number) => {
        if (input[0] === input[1] || output[0] === output[1]) return output[0];
        const ratio = (output[1] - output[0]) / (input[1] - input[0]);
        return output[0] + ratio * (value - input[0]);
    };
}

/**
 * Verifies the minimum steps between all values is greater than or equal
 * to the expected minimum steps.
 *
 * @example
 * // returns false
 * hasMinStepsBetweenValues([1,2,3], 2);
 *
 * @example
 * // returns true
 * hasMinStepsBetweenValues([1,2,3], 1);
 */
export function hasMinStepsBetweenValues(values: number[], minStepsBetweenValues: number) {
    if (minStepsBetweenValues > 0) {
        const stepsBetweenValues = getStepsBetweenValues(values);
        const actualMinStepsBetweenValues = Math.min(...stepsBetweenValues);
        return actualMinStepsBetweenValues >= minStepsBetweenValues;
    }
    return true;
}

/**
 * Given a `values` array and a `nextValue`, determine which value in
 * the array is closest to `nextValue` and return its index.
 *
 * @example
 * // returns 1
 * getClosestValueIndex([10, 30], 25);
 */
export function getClosestValueIndex(values: number[], nextValue: number) {
    if (values.length === 1) return 0;
    const distances = values.map((value) => Math.abs(value - nextValue));
    const closestDistance = Math.min(...distances);
    return distances.indexOf(closestDistance);
}

/**
 * Gets an array of steps between each value.
 *
 * @example
 * // returns [1, 9]
 * getStepsBetweenValues([10, 11, 20]);
 */
export function getStepsBetweenValues(values: number[]) {
    return values.slice(0, -1).map((value, index) => values[index + 1] - value);
}

/**
 * Offsets the thumb centre point while sliding to ensure it remains
 * within the bounds of the slider when reaching the edges
 */
export function getThumbInBoundsOffset(width: number, left: number, direction: number) {
    const halfWidth = width / 2;
    const halfPercent = 50;
    const offset = linearScale([0, halfPercent], [0, halfWidth]);
    return (halfWidth - offset(left) * direction) * direction;
}

export function convertValueToPercentage(value: number, min: number, max: number) {
    const maxSteps = max - min;
    const percentPerStep = 100 / maxSteps;
    const percentage = percentPerStep * (value - min);
    return clamp(percentage, 0, 100);
}

export function getDecimalCount(value: number) {
    return (String(value).split('.')[1] || '').length;
}

export function roundValue(value: number, decimalCount: number) {
    const rounder = 10 ** decimalCount;
    return Math.round(value * rounder) / rounder;
}

export function getNextSortedValues(prevValues: number[] = [], nextValue: number, atIndex: number) {
    const nextValues = [...prevValues];
    nextValues[atIndex] = nextValue;
    return nextValues.sort((a, b) => a - b);
}

export const PAGE_KEYS = ['PageUp', 'PageDown'];
export const ARROW_KEYS = ['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'];

type SlideDirection = 'from-left' | 'from-right' | 'from-bottom' | 'from-top';
export const BACK_KEYS: Record<SlideDirection, string[]> = {
    'from-left': ['Home', 'PageDown', 'ArrowDown', 'ArrowLeft'],
    'from-right': ['Home', 'PageDown', 'ArrowDown', 'ArrowRight'],
    'from-bottom': ['Home', 'PageDown', 'ArrowDown', 'ArrowLeft'],
    'from-top': ['Home', 'PageDown', 'ArrowUp', 'ArrowLeft']
};

export interface OrientationContext {
    direction: number;
    size: 'width' | 'height';
    startEdge: 'left' | 'top';
    endEdge: 'right' | 'bottom';
}

export function clamp(
    value: number,
    min: number = Number.NEGATIVE_INFINITY,
    max: number = Number.POSITIVE_INFINITY
): number {
    return Math.min(Math.max(value, min), max);
}



# ./slider/src/slider-thumb.component.ts

import { Component } from '@angular/core';
import { RdxSliderThumbImplDirective } from './slider-thumb-impl.directive';

@Component({
    selector: 'rdx-slider-thumb',
    hostDirectives: [RdxSliderThumbImplDirective],
    template: `
        <ng-content />
    `
})
export class RdxSliderThumbComponent {}



# ./slider/src/slider-orientation-context.service.ts

import { Injectable, signal } from '@angular/core';

export interface OrientationContext {
    startEdge: string;
    endEdge: string;
    direction: number;
    size: string;
}

@Injectable()
export class RdxSliderOrientationContextService {
    private contextSignal = signal<OrientationContext>({
        startEdge: 'left',
        endEdge: 'right',
        direction: 1,
        size: 'width'
    });

    get context() {
        return this.contextSignal();
    }

    updateContext(context: Partial<OrientationContext>) {
        this.contextSignal.update((current) => ({
            ...current,
            ...context
        }));
    }
}



# ./stepper/README.md

# @radix-ng/primitives/stepper



# ./stepper/index.ts

import { NgModule } from '@angular/core';
import { RdxStepperDescriptionDirective } from './src/stepper-description.directive';
import { RdxStepperIndicatorDirective } from './src/stepper-indicator.directive';
import { RdxStepperItemDirective } from './src/stepper-item.directive';
import { RdxStepperRootDirective } from './src/stepper-root.directive';
import { RdxStepperSeparatorDirective } from './src/stepper-separator.directive';
import { RdxStepperTitleDirective } from './src/stepper-title.directive';
import { RdxStepperTriggerDirective } from './src/stepper-trigger.directive';

export * from './src/stepper-description.directive';
export * from './src/stepper-indicator.directive';
export * from './src/stepper-item.directive';
export * from './src/stepper-root-context.token';
export * from './src/stepper-root.directive';
export * from './src/stepper-separator.directive';
export * from './src/stepper-title.directive';
export * from './src/stepper-trigger.directive';
export * from './src/types';

const _imports = [
    RdxStepperDescriptionDirective,
    RdxStepperTitleDirective,
    RdxStepperSeparatorDirective,
    RdxStepperItemDirective,
    RdxStepperIndicatorDirective,
    RdxStepperRootDirective,
    RdxStepperTriggerDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxStepperModule {}



# ./stepper/src/stepper-separator.directive.ts

import { Directive, effect, inject } from '@angular/core';
import { RdxSeparatorRootDirective } from '@radix-ng/primitives/separator';
import { injectStepperItemContext } from './stepper-item-context.token';
import { injectStepperRootContext } from './stepper-root-context.token';

@Directive({
    selector: '[rdxStepperSeparator]',
    hostDirectives: [{ directive: RdxSeparatorRootDirective, inputs: ['orientation', 'decorative'] }],
    host: {
        '[attr.data-state]': 'itemContext.itemState()'
    }
})
export class RdxStepperSeparatorDirective {
    protected readonly rootContext = injectStepperRootContext();
    protected readonly itemContext = injectStepperItemContext();

    private readonly rdxSeparator = inject(RdxSeparatorRootDirective, { host: true });

    constructor() {
        effect(() => {
            this.rdxSeparator.updateDecorative(true);
            this.rdxSeparator.updateOrientation(this.rootContext.orientation());
        });
    }
}



# ./stepper/src/stepper-root.directive.ts

import { LiveAnnouncer } from '@angular/cdk/a11y';
import { Direction } from '@angular/cdk/bidi';
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import {
    booleanAttribute,
    computed,
    Directive,
    effect,
    forwardRef,
    inject,
    input,
    model,
    numberAttribute,
    output,
    signal
} from '@angular/core';
import { STEPPER_ROOT_CONTEXT, StepperRootContext } from './stepper-root-context.token';

@Directive({
    selector: '[rdxStepperRoot]',
    exportAs: 'rdxStepperRoot',
    providers: [
        {
            provide: STEPPER_ROOT_CONTEXT,
            useExisting: forwardRef(() => RdxStepperRootDirective)
        }
    ],
    host: {
        role: 'group',
        '[attr.aria-label]': '"progress"',
        '[attr.data-linear]': 'linear() ? "" : undefined',
        '[attr.data-orientation]': 'orientation()'
    }
})
export class RdxStepperRootDirective implements StepperRootContext {
    private readonly liveAnnouncer = inject(LiveAnnouncer);

    readonly defaultValue = input<number, NumberInput>(undefined, { transform: numberAttribute });

    readonly value = model<number | undefined>(this.defaultValue());

    readonly linear = input<boolean, BooleanInput>(true, { transform: booleanAttribute });

    readonly dir = input<Direction>('ltr');

    readonly orientation = input<'vertical' | 'horizontal'>('horizontal');

    /** @ignore */
    readonly totalStepperItemsArray = computed(() => Array.from(this.totalStepperItems()));

    readonly onValueChange = output<number>();

    /** @ignore */
    readonly isFirstStep = computed(() => this.value() === 1);

    /** @ignore */
    readonly isLastStep = computed(() => this.value() === this.totalStepperItemsArray().length);

    /** @ignore */
    readonly totalSteps = computed(() => this.totalStepperItems().length);

    /** @ignore */
    readonly isNextDisabled = computed<boolean>(() => {
        const item = this.nextStepperItem();
        return item ? item.hasAttribute('disabled') : true;
    });

    /** @ignore */
    readonly isPrevDisabled = computed<boolean>(() => {
        const item = this.prevStepperItem();
        return item ? item.hasAttribute('disabled') : true;
    });

    /** @ignore */
    readonly totalStepperItems = signal<HTMLElement[]>([]);

    private readonly nextStepperItem = signal<HTMLElement | null>(null);
    private readonly prevStepperItem = signal<HTMLElement | null>(null);

    constructor() {
        effect(() => {
            const items = this.totalStepperItemsArray();
            const currentValue = this.value();

            if (currentValue) {
                if (items.length && currentValue < items.length) {
                    this.nextStepperItem.set(items[currentValue]);
                } else {
                    this.nextStepperItem.set(null);
                }

                if (items.length && currentValue > 1) {
                    this.prevStepperItem.set(items[currentValue - 2]);
                } else {
                    this.prevStepperItem.set(null);
                }

                this.onValueChange.emit(currentValue);
                this.liveAnnouncer.announce(`Step ${currentValue} of ${items.length}`);
            }
        });
    }

    goToStep(step: number) {
        if (step > this.totalSteps()) {
            return;
        }

        if (step < 1) {
            return;
        }

        if (
            this.totalStepperItems().length &&
            !!this.totalStepperItemsArray()[step] &&
            this.totalStepperItemsArray()[step].hasAttribute('disabled')
        ) {
            return;
        }

        if (this.linear()) {
            const currentValue = this.value() ?? 1;
            if (step > currentValue + 1) {
                return;
            }
        }
        this.value.set(step);
        this.onValueChange.emit(step);
    }
}



# ./stepper/src/stepper-description.directive.ts

import { Directive } from '@angular/core';
import { injectStepperItemContext } from './stepper-item-context.token';

@Directive({
    selector: '[rdxStepperDescription]',
    host: {
        '[attr.id]': 'itemContext.descriptionId'
    }
})
export class RdxStepperDescriptionDirective {
    readonly itemContext = injectStepperItemContext();
}



# ./stepper/src/utils/useArrowNavigation.ts

// made by https://reka-ui.com/

import { Direction } from '@angular/cdk/bidi';

type ArrowKeyOptions = 'horizontal' | 'vertical' | 'both';

interface ArrowNavigationOptions {
    /**
     * The arrow key options to allow navigation
     *
     * @defaultValue "both"
     */
    arrowKeyOptions?: ArrowKeyOptions;

    /**
     * The attribute name to find the collection items in the parent element.
     *
     * @defaultValue "data-reka-collection-item"
     */
    attributeName?: string;

    /**
     * The parent element where contains all the collection items, this will collect every item to be used when nav
     * It will be ignored if attributeName is provided
     *
     * @defaultValue []
     */
    itemsArray?: HTMLElement[];

    /**
     * Allow loop navigation. If false, it will stop at the first and last element
     *
     * @defaultValue true
     */
    loop?: boolean;

    /**
     * The orientation of the collection
     *
     * @defaultValue "ltr"
     */
    dir?: Direction;

    /**
     * Prevent the scroll when navigating. This happens when the direction of the
     * key matches the scroll direction of any ancestor scrollable elements.
     *
     * @defaultValue true
     */
    preventScroll?: boolean;

    /**
     * By default all currentElement would trigger navigation. If `true`, currentElement nodeName in the ignore list will return null
     *
     * @defaultValue false
     */
    enableIgnoredElement?: boolean;

    /**
     * Focus the element after navigation
     *
     * @defaultValue false
     */
    focus?: boolean;
}

const ignoredElement = ['INPUT', 'TEXTAREA'];

/**
 * Allow arrow navigation for every html element with data-reka-collection-item tag
 *
 * @param e               Keyboard event
 * @param currentElement  Event initiator element or any element that wants to handle the navigation
 * @param parentElement   Parent element where contains all the collection items, this will collect every item to be used when nav
 * @param options         further options
 * @returns               the navigated html element or null if none
 */
export function useArrowNavigation(
    e: KeyboardEvent,
    currentElement: HTMLElement,
    parentElement: HTMLElement | undefined,
    options: ArrowNavigationOptions = {}
): HTMLElement | null {
    if (!currentElement || (options.enableIgnoredElement && ignoredElement.includes(currentElement.nodeName)))
        return null;

    const {
        arrowKeyOptions = 'both',
        attributeName = '[data-reka-collection-item]',
        itemsArray = [],
        loop = true,
        dir = 'ltr',
        preventScroll = true,
        focus = false
    } = options;

    const [right, left, up, down, home, end] = [
        e.key === 'ArrowRight',
        e.key === 'ArrowLeft',
        e.key === 'ArrowUp',
        e.key === 'ArrowDown',
        e.key === 'Home',
        e.key === 'End'
    ];
    const goingVertical = up || down;
    const goingHorizontal = right || left;
    if (
        !home &&
        !end &&
        ((!goingVertical && !goingHorizontal) ||
            (arrowKeyOptions === 'vertical' && goingHorizontal) ||
            (arrowKeyOptions === 'horizontal' && goingVertical))
    ) {
        return null;
    }

    const allCollectionItems: HTMLElement[] = parentElement
        ? Array.from(parentElement.querySelectorAll(attributeName))
        : itemsArray;

    if (!allCollectionItems.length) return null;

    if (preventScroll) e.preventDefault();

    let item: HTMLElement | null = null;

    if (goingHorizontal || goingVertical) {
        const goForward = goingVertical ? down : dir === 'ltr' ? right : left;
        item = findNextFocusableElement(allCollectionItems, currentElement, {
            goForward,
            loop
        });
    } else if (home) {
        item = allCollectionItems.length ? allCollectionItems[0] : null;
    } else if (end) {
        item = allCollectionItems.length ? allCollectionItems[allCollectionItems.length - 1] : null;
    }

    if (focus) item?.focus();

    return item;
}

interface FindNextFocusableElementOptions {
    /**
     * Whether to search forwards or backwards.
     */
    goForward: boolean;
    /**
     * Whether to allow looping the search. If false, it will stop at the first/last element.
     *
     * @default true
     */
    loop?: boolean;
}

/**
 * Recursive function to find the next focusable element to avoid disabled elements
 *
 * @param elements Elements to navigate
 * @param currentElement Current active element
 * @param options
 * @returns next focusable element
 */
function findNextFocusableElement(
    elements: HTMLElement[],
    currentElement: HTMLElement,
    options: FindNextFocusableElementOptions,
    iterations = elements.length
): HTMLElement | null {
    if (--iterations === 0) return null;

    const index = elements.indexOf(currentElement);
    const newIndex = options.goForward ? index + 1 : index - 1;

    if (!options.loop && (newIndex < 0 || newIndex >= elements.length)) return null;

    const adjustedNewIndex = (newIndex + elements.length) % elements.length;
    const candidate = elements[adjustedNewIndex];
    if (!candidate) return null;

    const isDisabled = candidate.hasAttribute('disabled') && candidate.getAttribute('disabled') !== 'false';
    if (isDisabled) {
        return findNextFocusableElement(elements, candidate, options, iterations);
    }
    return candidate;
}



# ./stepper/src/utils/getActiveElement.ts

export function getActiveElement(): Element | null {
    let activeElement = document.activeElement;
    if (activeElement == null) {
        return null;
    }

    while (
        activeElement != null &&
        activeElement.shadowRoot != null &&
        activeElement.shadowRoot.activeElement != null
    ) {
        activeElement = activeElement.shadowRoot.activeElement;
    }

    return activeElement;
}



# ./stepper/src/stepper-root-context.token.ts

import { Direction } from '@angular/cdk/bidi';
import { BooleanInput } from '@angular/cdk/coercion';
import {
    inject,
    InjectionToken,
    InputSignal,
    InputSignalWithTransform,
    ModelSignal,
    WritableSignal
} from '@angular/core';

export interface StepperRootContext {
    value: ModelSignal<number | undefined>;
    orientation: InputSignal<'vertical' | 'horizontal'>;
    dir: InputSignal<Direction>;
    linear: InputSignalWithTransform<boolean, BooleanInput>;
    totalStepperItems: WritableSignal<HTMLElement[]>;
}

export const STEPPER_ROOT_CONTEXT = new InjectionToken<StepperRootContext>('StepperRootContext');

export function injectStepperRootContext(): StepperRootContext {
    return inject(STEPPER_ROOT_CONTEXT);
}



# ./stepper/src/stepper-trigger.directive.ts

import { computed, Directive, ElementRef, inject, OnDestroy, OnInit } from '@angular/core';
import * as kbd from '@radix-ng/primitives/core';
import { injectStepperItemContext } from './stepper-item-context.token';
import { injectStepperRootContext } from './stepper-root-context.token';
import { getActiveElement } from './utils/getActiveElement';
import { useArrowNavigation } from './utils/useArrowNavigation';

// as button
@Directive({
    selector: 'button[rdxStepperTrigger]',
    host: {
        '[attr.tabindex]': 'itemContext.isFocusable() ? 0 : -1',
        '[attr.aria-describedby]': 'itemContext.descriptionId',
        '[attr.aria-labelledby]': 'itemContext.titleId',

        '[attr.data-state]': 'itemContext.itemState()',
        '[attr.data-orientation]': 'rootContext.orientation()',
        '[attr.disabled]': 'itemContext.disabled() || !itemContext.isFocusable() ? "" : undefined',
        '[attr.data-disabled]': 'itemContext.disabled() || !itemContext.isFocusable() ? "" : undefined',

        '(mousedown)': 'handleMouseDown($event)',

        '(keydown.Enter)': 'handleKeyDown($event)',
        '(keydown.Space)': 'handleKeyDown($event)',
        '(keydown.ArrowLeft)': 'handleKeyDown($event)',
        '(keydown.ArrowRight)': 'handleKeyDown($event)',
        '(keydown.ArrowUp)': 'handleKeyDown($event)',
        '(keydown.ArrowDown)': 'handleKeyDown($event)'
    }
})
export class RdxStepperTriggerDirective implements OnInit, OnDestroy {
    protected readonly rootContext = injectStepperRootContext();
    protected readonly itemContext = injectStepperItemContext();

    private readonly elementRef = inject(ElementRef);

    readonly stepperItems = computed(() => Array.from(this.rootContext.totalStepperItems()));

    ngOnInit() {
        const current = this.rootContext.totalStepperItems();
        this.rootContext.totalStepperItems.set([...current, this.elementRef.nativeElement]);
    }

    ngOnDestroy() {
        const current = this.rootContext.totalStepperItems();
        const updated = current.filter((el: HTMLElement) => el !== this.elementRef.nativeElement);

        this.rootContext.totalStepperItems.set(updated);
    }

    handleMouseDown(event: MouseEvent) {
        if (this.itemContext.disabled()) {
            return;
        }

        // handler only left mouse click
        if (event.button !== 0) {
            return;
        }

        if (this.rootContext.linear()) {
            if (
                this.itemContext.step() <= this.rootContext.value()! ||
                this.itemContext.step() === this.rootContext.value()! + 1
            ) {
                if (!event.ctrlKey) {
                    this.rootContext.value.set(this.itemContext.step());
                    return;
                }
            }
        } else {
            if (!event.ctrlKey) {
                this.rootContext.value.set(this.itemContext.step());
                return;
            }
        }

        // prevent focus to avoid accidental activation
        event.preventDefault();
    }

    handleKeyDown(event: KeyboardEvent) {
        event.preventDefault();

        if (this.itemContext.disabled()) {
            return;
        }

        if ((event.key === kbd.ENTER || event.key === kbd.SPACE) && !event.ctrlKey && !event.shiftKey)
            this.rootContext.value.set(this.itemContext.step());

        if ([kbd.ARROW_LEFT, kbd.ARROW_RIGHT, kbd.ARROW_UP, kbd.ARROW_DOWN].includes(event.key)) {
            useArrowNavigation(event, getActiveElement() as HTMLElement, undefined, {
                itemsArray: this.stepperItems() as HTMLElement[],
                focus: true,
                loop: false,
                arrowKeyOptions: this.rootContext.orientation(),
                dir: this.rootContext.dir()
            });
        }
    }
}



# ./stepper/src/types.ts

export type StepperState = 'completed' | 'active' | 'inactive';



# ./stepper/src/stepper-item.directive.ts

import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import { booleanAttribute, computed, Directive, forwardRef, inject, input, numberAttribute } from '@angular/core';
import { _IdGenerator } from '@radix-ng/primitives/core';
import { STEPPER_ITEM_CONTEXT, StepperItemContext } from './stepper-item-context.token';
import { injectStepperRootContext } from './stepper-root-context.token';
import { StepperState } from './types';

@Directive({
    selector: '[rdxStepperItem]',
    providers: [
        {
            provide: STEPPER_ITEM_CONTEXT,
            useExisting: forwardRef(() => RdxStepperItemDirective)
        }
    ],
    host: {
        '[attr.aria-current]': 'itemState() === "active" ? true : undefined',

        '[attr.data-state]': 'itemState()',
        '[attr.disabled]': 'disabled() || !isFocusable() ? "" : undefined',
        '[attr.data-disabled]': 'disabled() || !isFocusable() ? "" : undefined',
        '[attr.data-orientation]': 'rootContext.orientation()'
    }
})
export class RdxStepperItemDirective implements StepperItemContext {
    protected readonly rootContext = injectStepperRootContext();

    /** @ignore */
    readonly titleId = inject(_IdGenerator).getId('rdx-stepper-item-title');

    /** @ignore */
    readonly descriptionId = inject(_IdGenerator).getId('rdx-stepper-item-description');

    readonly step = input<number, NumberInput>(NaN, { transform: numberAttribute });

    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /** @ignore */
    readonly completed = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /** @ignore */
    readonly itemState = computed<StepperState>(() => {
        if (this.completed()) return 'completed';
        if (this.rootContext.value() === this.step()) return 'active';

        const step = this.step() ?? 1;
        if (this.rootContext.value()! > step) {
            return 'completed';
        }

        return 'inactive';
    });

    /** @ignore */
    readonly isFocusable = computed(() => {
        if (this.disabled()) return false;

        const step = this.step() ?? 1;
        if (this.rootContext.linear()) {
            return step <= this.rootContext.value()! || step === this.rootContext.value()! + 1;
        }

        return true;
    });
}



# ./stepper/src/stepper-title.directive.ts

import { Directive } from '@angular/core';
import { injectStepperItemContext } from './stepper-item-context.token';

@Directive({
    selector: '[rdxStepperTitle]',
    host: {
        '[attr.id]': 'itemContext.titleId'
    }
})
export class RdxStepperTitleDirective {
    readonly itemContext = injectStepperItemContext();
}



# ./stepper/src/stepper-indicator.directive.ts

import { Directive } from '@angular/core';
import { injectStepperItemContext } from './stepper-item-context.token';

@Directive({
    selector: '[rdxStepperIndicator]',
    exportAs: 'rdxStepperIndicator'
})
export class RdxStepperIndicatorDirective {
    readonly itemContext = injectStepperItemContext();
}



# ./stepper/src/stepper-item-context.token.ts

import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import { inject, InjectionToken, InputSignalWithTransform, Signal } from '@angular/core';
import { StepperState } from './types';

export interface StepperItemContext {
    titleId: string;
    descriptionId: string;
    step: InputSignalWithTransform<number, NumberInput>;
    disabled: InputSignalWithTransform<boolean, BooleanInput>;
    isFocusable: Signal<boolean>;
    itemState: Signal<StepperState>;
}

export const STEPPER_ITEM_CONTEXT = new InjectionToken<StepperItemContext>('StepperItemContext');

export function injectStepperItemContext(): StepperItemContext {
    return inject(STEPPER_ITEM_CONTEXT);
}



# ./toggle-group/README.md

# @radix-ng/primitives/toggle-group

Secondary entry point of `@radix-ng/primitives/toggle-group`.



# ./toggle-group/index.ts

export * from './src/toggle-group-item.directive';
export * from './src/toggle-group-item.token';
export * from './src/toggle-group-without-focus.directive';
export * from './src/toggle-group.directive';
export * from './src/toggle-group.token';



# ./toggle-group/src/toggle-group-item.token.ts

import { inject, InjectionToken } from '@angular/core';
import type { RdxToggleGroupItemDirective } from './toggle-group-item.directive';

export const RdxToggleGroupItemToken = new InjectionToken<RdxToggleGroupItemDirective>('RdxToggleGroupItemToken');

export function injectToggleGroupItem(): RdxToggleGroupItemDirective {
    return inject(RdxToggleGroupItemToken);
}



# ./toggle-group/src/toggle-group-item.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, computed, Directive, effect, inject, input } from '@angular/core';
import { RdxRovingFocusItemDirective } from '@radix-ng/primitives/roving-focus';
import { RdxToggleDirective } from '@radix-ng/primitives/toggle';
import { RdxToggleGroupItemToken } from './toggle-group-item.token';
import { injectToggleGroup } from './toggle-group.token';

/**
 * @group Components
 */
@Directive({
    selector: '[rdxToggleGroupItem]',
    exportAs: 'rdxToggleGroupItem',
    standalone: true,
    providers: [{ provide: RdxToggleGroupItemToken, useExisting: RdxToggleGroupItemDirective }],
    hostDirectives: [
        {
            directive: RdxRovingFocusItemDirective,
            inputs: ['focusable', 'active', 'allowShiftKey']
        },
        {
            directive: RdxToggleDirective,
            inputs: ['pressed', 'disabled']
        }
    ],
    host: {
        '(click)': 'toggle()'
    }
})
export class RdxToggleGroupItemDirective {
    private readonly rdxToggleDirective = inject(RdxToggleDirective);

    private readonly rdxRovingFocusItemDirective = inject(RdxRovingFocusItemDirective);

    /**
     * Access the toggle group.
     * @ignore
     */
    protected readonly rootContext = injectToggleGroup();

    /**
     * The value of this toggle button.
     *
     * @group Props
     */
    readonly value = input.required<string>();

    /**
     * Whether this toggle button is disabled.
     * @defaultValue false
     * @group Props
     */
    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    private readonly isPressed = computed(() => {
        return this.rootContext.type() === 'single'
            ? this.rootContext.value() === this.value()
            : this.rootContext.value()?.includes(this.value());
    });

    private readonly isDisabled = computed(() => this.rootContext.disabled() || this.disabled());

    constructor() {
        effect(() => {
            this.rdxToggleDirective.pressed.set(!!this.isPressed());
            this.rdxToggleDirective.disabledModel.set(this.isDisabled());

            this.rdxRovingFocusItemDirective.active = !!this.isPressed();
        });
    }

    /**
     * @ignore
     */
    toggle(): void {
        if (this.disabled()) {
            return;
        }

        this.rootContext.toggle(this.value());
    }
}



# ./toggle-group/src/toggle-group-without-focus.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, Directive, input, model, output, signal } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { RdxToggleGroupToken } from './toggle-group.token';

let nextId = 0;

@Directive({
    selector: '[rdxToggleGroupWithoutFocus]',
    exportAs: 'rdxToggleGroupWithoutFocus',
    standalone: true,
    providers: [
        { provide: RdxToggleGroupToken, useExisting: RdxToggleGroupWithoutFocusDirective },
        { provide: NG_VALUE_ACCESSOR, useExisting: RdxToggleGroupWithoutFocusDirective, multi: true }
    ],
    host: {
        role: 'group',
        '(focusout)': 'onTouched?.()'
    }
})
export class RdxToggleGroupWithoutFocusDirective implements ControlValueAccessor {
    /**
     * @ignore
     */
    readonly id: string = `rdx-toggle-group-${nextId++}`;

    /**
     * @group Props
     */
    readonly value = model<string | string[] | undefined>(undefined);

    /**
     * @group Props
     */
    readonly type = input<'single' | 'multiple'>('single');

    /**
     * Whether the toggle group is disabled.
     * @defaultValue false
     * @group Props
     */
    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * Event emitted when the selected toggle button changes.
     * @group Emits
     */
    readonly onValueChange = output<string[] | string | undefined>();

    /**
     * The value change callback.
     */
    private onChange?: (value: string | string[] | undefined) => void;

    /**
     * onTouch function registered via registerOnTouch (ControlValueAccessor).
     */
    protected onTouched?: () => void;

    /**
     * Toggle a value.
     * @param value The value to toggle.
     * @ignore
     */
    toggle(value: string): void {
        if (this.disabled()) {
            return;
        }

        if (this.type() === 'single') {
            this.value.set(value);
        } else {
            this.value.set(
                ((currentValue) =>
                    currentValue && Array.isArray(currentValue)
                        ? currentValue.includes(value)
                            ? currentValue.filter((v) => v !== value) // delete
                            : [...currentValue, value] // update
                        : [value])(this.value())
            );
        }

        this.onValueChange.emit(this.value());
        this.onChange?.(this.value());
    }

    /**
     * Select a value from Angular forms.
     * @param value The value to select.
     * @ignore
     */
    writeValue(value: string): void {
        this.value.set(value);
    }

    /**
     * Register a callback to be called when the value changes.
     * @param fn The callback to register.
     * @ignore
     */
    registerOnChange(fn: (value: string | string[] | undefined) => void): void {
        this.onChange = fn;
    }

    /**
     * Register a callback to be called when the toggle group is touched.
     * @param fn The callback to register.
     * @ignore
     */
    registerOnTouched(fn: () => void): void {
        this.onTouched = fn;
    }

    private readonly accessorDisabled = signal(false);

    /**
     * Set the disabled state of the toggle group.
     * @param isDisabled Whether the toggle group is disabled.
     * @ignore
     */
    setDisabledState(isDisabled: boolean): void {
        this.accessorDisabled.set(isDisabled);
    }
}



# ./toggle-group/src/toggle-group.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, Directive, forwardRef, input, model, output, signal } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { RdxRovingFocusGroupDirective } from '@radix-ng/primitives/roving-focus';
import { RdxToggleGroupToken } from './toggle-group.token';

let nextId = 0;

/**
 * @group Components
 */
@Directive({
    selector: '[rdxToggleGroup]',
    exportAs: 'rdxToggleGroup',
    providers: [
        { provide: RdxToggleGroupToken, useExisting: forwardRef(() => RdxToggleGroupDirective) },
        { provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => RdxToggleGroupDirective), multi: true }
    ],
    hostDirectives: [{ directive: RdxRovingFocusGroupDirective, inputs: ['dir', 'orientation', 'loop'] }],
    host: {
        role: 'group',

        '(focusout)': 'onTouched?.()'
    }
})
export class RdxToggleGroupDirective implements ControlValueAccessor {
    /**
     * @ignore
     */
    readonly id: string = `rdx-toggle-group-${nextId++}`;

    /**
     * @group Props
     */
    readonly value = model<string | string[] | undefined>(undefined);

    /**
     * @group Props
     */
    readonly type = input<'single' | 'multiple'>('single');

    /**
     * Whether the toggle group is disabled.
     * @defaultValue false
     * @group Props
     */
    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * Event emitted when the selected toggle button changes.
     * @group Emits
     */
    readonly onValueChange = output<string[] | string | undefined>();

    /**
     * The value change callback.
     */
    private onChange?: (value: string | string[] | undefined) => void;

    /**
     * onTouch function registered via registerOnTouch (ControlValueAccessor).
     */
    protected onTouched?: () => void;

    /**
     * Toggle a value.
     * @param value The value to toggle.
     * @ignore
     */
    toggle(value: string): void {
        if (this.disabled()) {
            return;
        }

        if (this.type() === 'single') {
            this.value.set(value);
        } else {
            this.value.set(
                ((currentValue) =>
                    currentValue && Array.isArray(currentValue)
                        ? currentValue.includes(value)
                            ? currentValue.filter((v) => v !== value) // delete
                            : [...currentValue, value] // update
                        : [value])(this.value())
            );
        }

        this.onValueChange.emit(this.value());
        this.onChange?.(this.value());
    }

    /**
     * Select a value from Angular forms.
     * @param value The value to select.
     * @ignore
     */
    writeValue(value: string): void {
        this.value.set(value);
    }

    /**
     * Register a callback to be called when the value changes.
     * @param fn The callback to register.
     * @ignore
     */
    registerOnChange(fn: (value: string | string[] | undefined) => void): void {
        this.onChange = fn;
    }

    /**
     * Register a callback to be called when the toggle group is touched.
     * @param fn The callback to register.
     * @ignore
     */
    registerOnTouched(fn: () => void): void {
        this.onTouched = fn;
    }

    private readonly accessorDisabled = signal(false);
    /**
     * Set the disabled state of the toggle group.
     * @param isDisabled Whether the toggle group is disabled.
     * @ignore
     */
    setDisabledState(isDisabled: boolean): void {
        this.accessorDisabled.set(isDisabled);
    }
}



# ./toggle-group/src/toggle-group.token.ts

import { inject, InjectionToken } from '@angular/core';

export interface IRdxToggleGroup {
    toggle(value: string): void;

    disabled: any;
    value: any;
    type: any;
}

export const RdxToggleGroupToken = new InjectionToken<IRdxToggleGroup>('RdxToggleGroupToken');

export function injectToggleGroup(): IRdxToggleGroup {
    return inject(RdxToggleGroupToken);
}



# ./context-menu/README.md

# @radix-ng/primitives/context-menu



# ./context-menu/index.ts

import { NgModule } from '@angular/core';
import { RdxContextMenuContentDirective } from './src/context-menu-content.directive';
import { RdxContextMenuItemCheckboxDirective } from './src/context-menu-item-checkbox.directive';
import { RdxContextMenuItemIndicatorDirective } from './src/context-menu-item-indicator.directive';
import { RdxContextMenuItemRadioGroupDirective } from './src/context-menu-item-radio-group.directive';
import { RdxContextMenuItemRadioDirective } from './src/context-menu-item-radio.directive';
import { RdxContextMenuSelectable } from './src/context-menu-item-selectable';
import { RdxContextMenuItemDirective } from './src/context-menu-item.directive';
import { RdxContextMenuLabelDirective } from './src/context-menu-label.directive';
import { RdxContextMenuSeparatorDirective } from './src/context-menu-separator.directive';
import { RdxContextMenuTriggerDirective } from './src/context-menu-trigger.directive';

export * from './src/context-menu-content.directive';
export * from './src/context-menu-item-checkbox.directive';
export * from './src/context-menu-item-indicator.directive';
export * from './src/context-menu-item-radio-group.directive';
export * from './src/context-menu-item-radio.directive';
export * from './src/context-menu-item-selectable';
export * from './src/context-menu-item.directive';
export * from './src/context-menu-label.directive';
export * from './src/context-menu-separator.directive';
export * from './src/context-menu-trigger.directive';

const _imports = [
    RdxContextMenuContentDirective,
    RdxContextMenuSelectable,
    RdxContextMenuItemCheckboxDirective,
    RdxContextMenuItemDirective,
    RdxContextMenuItemRadioGroupDirective,
    RdxContextMenuItemIndicatorDirective,
    RdxContextMenuItemRadioDirective,
    RdxContextMenuLabelDirective,
    RdxContextMenuSeparatorDirective,
    RdxContextMenuTriggerDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxContextMenuModule {}



# ./context-menu/src/context-menu-item-radio.directive.ts

import { UniqueSelectionDispatcher } from '@angular/cdk/collections';
import { CDK_MENU, CdkMenuItem } from '@angular/cdk/menu';
import { AfterContentInit, Directive, inject, Input, OnDestroy } from '@angular/core';
import { RdxContextMenuContentDirective } from './context-menu-content.directive';
import { RdxContextMenuItemRadioGroupDirective } from './context-menu-item-radio-group.directive';
import { RdxContextMenuSelectable } from './context-menu-item-selectable';
import { RdxContextMenuItemDirective } from './context-menu-item.directive';

/** Counter used to set a unique id and name for a selectable item */
let nextId = 0;

@Directive({
    selector: '[rdxContextMenuItemRadio]',
    standalone: true,
    host: {
        role: 'menuitemradio'
    },
    providers: [
        { provide: RdxContextMenuSelectable, useExisting: RdxContextMenuItemRadioDirective },
        { provide: RdxContextMenuItemDirective, useExisting: RdxContextMenuSelectable },
        { provide: CdkMenuItem, useExisting: RdxContextMenuItemDirective },
        { provide: CDK_MENU, useExisting: RdxContextMenuContentDirective }
    ]
})
export class RdxContextMenuItemRadioDirective extends RdxContextMenuSelectable implements AfterContentInit, OnDestroy {
    /** The unique selection dispatcher for this radio's `RdxContextMenuItemRadioGroupDirective`. */
    private readonly selectionDispatcher = inject(UniqueSelectionDispatcher);

    private readonly group = inject(RdxContextMenuItemRadioGroupDirective);

    @Input()
    get value() {
        return this._value || this.id;
    }

    set value(value: string) {
        this._value = value;
    }

    private _value: string | undefined;

    /** An ID to identify this radio item to the `UniqueSelectionDispatcher`. */
    private id = `${nextId++}`;

    private removeDispatcherListener!: () => void;

    constructor() {
        super();

        this.triggered.subscribe(() => {
            if (!this.disabled) {
                this.selectionDispatcher.notify(this.value, '');

                this.group.valueChange.emit(this.value);
            }
        });
    }

    ngAfterContentInit() {
        this.removeDispatcherListener = this.selectionDispatcher.listen((id: string) => {
            this.checked = this.value === id;
        });
    }

    override ngOnDestroy() {
        super.ngOnDestroy();
        this.removeDispatcherListener();
    }
}



# ./context-menu/src/context-menu-separator.directive.ts

import { Directive } from '@angular/core';
import { RdxSeparatorRootDirective } from '@radix-ng/primitives/separator';

@Directive({
    selector: '[rdxContextMenuSeparator]',
    standalone: true,
    hostDirectives: [RdxSeparatorRootDirective],
    host: {
        role: 'separator',
        '[attr.aria-orientation]': "'horizontal'"
    }
})
export class RdxContextMenuSeparatorDirective {}



# ./context-menu/src/context-menu-item.directive.ts

import { CDK_MENU, CdkMenuItem } from '@angular/cdk/menu';
import { booleanAttribute, Directive, ElementRef, EventEmitter, inject, Input, Output } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

import { RdxContextMenuContentDirective } from './context-menu-content.directive';

@Directive({
    selector: '[rdxContextMenuItem]',
    standalone: true,
    host: {
        type: 'button',
        '[attr.data-orientation]': '"vertical"',
        '[attr.data-highlighted]': 'highlighted ? "" : null',
        '[attr.data-disabled]': 'disabled ? "" : null',
        '[attr.disabled]': 'disabled ? "" : null',
        '(pointermove)': 'onPointerMove()',
        '(focus)': 'menu.highlighted.next(this)',
        '(keydown)': 'onKeydown($event)'
    },
    providers: [
        { provide: CdkMenuItem, useExisting: RdxContextMenuItemDirective },
        { provide: CDK_MENU, useExisting: RdxContextMenuContentDirective }
    ]
})
export class RdxContextMenuItemDirective extends CdkMenuItem {
    protected readonly menu = inject(RdxContextMenuContentDirective);
    protected readonly nativeElement = inject(ElementRef).nativeElement;

    highlighted = false;

    @Input({ transform: booleanAttribute }) override disabled = false;

    @Output() readonly onSelect = new EventEmitter<void>();

    constructor() {
        super();

        this.menu.highlighted.pipe(takeUntilDestroyed()).subscribe((value) => {
            if (value !== this) {
                this.highlighted = false;
            }
        });

        this.triggered.subscribe(this.onSelect);
    }

    protected onPointerMove() {
        this.nativeElement.focus({ preventScroll: true });
        this.menu.updateActiveItem(this);
    }

    protected onKeydown(event: KeyboardEvent) {
        if (this.nativeElement.tagName !== 'BUTTON' && ['Enter', ' '].includes(event.key)) {
            event.preventDefault();
        }

        if (event.key === 'Escape') {
            if (!this.menu.closeOnEscape) {
                event.stopPropagation();
            } else {
                this.menu.onEscapeKeyDown(event);
            }
        }
    }
}



# ./context-menu/src/context-menu-label.directive.ts

import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxContextMenuLabel]',
    standalone: true
})
export class RdxContextMenuLabelDirective {}



# ./context-menu/src/context-menu-item-checkbox.directive.ts

import { CDK_MENU, CdkMenuItem } from '@angular/cdk/menu';
import { Directive } from '@angular/core';
import { RdxContextMenuContentDirective } from './context-menu-content.directive';
import { RdxContextMenuSelectable } from './context-menu-item-selectable';
import { RdxContextMenuItemDirective } from './context-menu-item.directive';

@Directive({
    selector: '[rdxContextMenuItemCheckbox]',
    standalone: true,
    host: {
        role: 'menuitemcheckbox'
    },
    providers: [
        { provide: RdxContextMenuSelectable, useExisting: RdxContextMenuItemCheckboxDirective },
        { provide: RdxContextMenuItemDirective, useExisting: RdxContextMenuSelectable },
        { provide: CdkMenuItem, useExisting: RdxContextMenuItemDirective },
        { provide: CDK_MENU, useExisting: RdxContextMenuContentDirective }
    ]
})
export class RdxContextMenuItemCheckboxDirective extends RdxContextMenuSelectable {
    override trigger(options?: { keepOpen: boolean }) {
        if (!this.disabled) {
            this.checked = !this.checked;

            this.checkedChange.emit(this.checked);
        }

        super.trigger(options);
    }
}



# ./context-menu/src/context-menu-trigger.directive.ts

import { CdkContextMenuTrigger, MENU_STACK, MENU_TRIGGER, MenuStack } from '@angular/cdk/menu';
import { ConnectedPosition } from '@angular/cdk/overlay';
import { booleanAttribute, Directive, Input, numberAttribute, TemplateRef } from '@angular/core';
import { outputFromObservable } from '@angular/core/rxjs-interop';

export enum ContextMenuSide {
    Top = 'top',
    Right = 'right',
    Bottom = 'bottom',
    Left = 'left'
}

const ContextMenuPositions: Record<ContextMenuSide, ConnectedPosition> = {
    top: {
        originX: 'start',
        originY: 'top',
        overlayX: 'start',
        overlayY: 'bottom',
        offsetX: 0,
        offsetY: 0
    },
    right: {
        originX: 'end',
        originY: 'top',
        overlayX: 'start',
        overlayY: 'top',
        offsetX: 0,
        offsetY: 0
    },
    bottom: {
        originX: 'start',
        originY: 'bottom',
        overlayX: 'start',
        overlayY: 'top',
        offsetX: 0,
        offsetY: 0
    },
    left: {
        originX: 'start',
        originY: 'top',
        overlayX: 'end',
        overlayY: 'top',
        offsetX: 0,
        offsetY: 0
    }
};

@Directive({
    selector: '[rdxContextMenuTrigger]',
    standalone: true,
    host: {
        '[attr.data-state]': "isOpen() ? 'open': 'closed'",
        '[attr.data-disabled]': "disabled ? '' : null",

        '(contextmenu)': '_openOnContextMenu($event)'
    },
    providers: [
        { provide: MENU_TRIGGER, useExisting: RdxContextMenuTriggerDirective },
        { provide: MENU_STACK, useClass: MenuStack }
    ]
})
export class RdxContextMenuTriggerDirective extends CdkContextMenuTrigger {
    override menuPosition = [{ ...ContextMenuPositions[ContextMenuSide.Bottom] }];

    @Input()
    set rdxContextMenuTrigger(value: TemplateRef<unknown> | null) {
        this.menuTemplateRef = value;
    }

    @Input({ transform: numberAttribute })
    set alignOffset(value: number) {
        this.defaultPosition.offsetX = value;
    }

    @Input({ transform: booleanAttribute }) override disabled = false;

    onOpenChange = outputFromObservable(this.opened);

    get defaultPosition(): ConnectedPosition {
        return this.menuPosition[0];
    }
}



# ./context-menu/src/context-menu-item-selectable.ts

import { booleanAttribute, Directive, EventEmitter, Input, Output } from '@angular/core';
import { RdxContextMenuItemDirective } from './context-menu-item.directive';

/** Base class providing checked state for selectable ContextMenuItems. */
@Directive({
    standalone: true,
    host: {
        '[attr.aria-checked]': '!!checked',
        '[attr.aria-disabled]': 'disabled || null',
        '[attr.data-state]': 'checked ? "checked" : "unchecked"'
    }
})
export class RdxContextMenuSelectable extends RdxContextMenuItemDirective {
    /** Whether the element is checked */
    @Input({ transform: booleanAttribute }) checked = false;

    @Output() readonly checkedChange = new EventEmitter<boolean>();
}



# ./context-menu/src/context-menu-content.directive.ts

import { CdkMenu, CdkMenuItem } from '@angular/cdk/menu';
import { Directive, inject, Input } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { pairwise, startWith, Subject } from 'rxjs';
import { RdxContextMenuItemDirective } from './context-menu-item.directive';
import { RdxContextMenuTriggerDirective } from './context-menu-trigger.directive';

@Directive({
    selector: '[rdxContextMenuContent]',
    standalone: true,
    host: {
        '[attr.role]': "'menu'",
        '[attr.data-state]': "menuTrigger.isOpen() ? 'open': 'closed'",
        '[attr.data-orientation]': 'orientation'
    },
    providers: [
        {
            provide: CdkMenu,
            useExisting: RdxContextMenuContentDirective
        }
    ]
})
export class RdxContextMenuContentDirective extends CdkMenu {
    readonly highlighted = new Subject<RdxContextMenuItemDirective>();
    readonly menuTrigger = inject(RdxContextMenuTriggerDirective, { optional: true });

    @Input() onEscapeKeyDown: (event?: Event) => void = () => undefined;
    @Input() closeOnEscape = true;

    constructor() {
        super();

        this.highlighted.pipe(startWith(null), pairwise(), takeUntilDestroyed()).subscribe(([prev, item]) => {
            if (prev) {
                prev.highlighted = false;
            }

            if (item) {
                item.highlighted = true;
            }
        });
    }

    updateActiveItem(item: CdkMenuItem) {
        this.keyManager.updateActiveItem(item);
    }
}



# ./context-menu/src/context-menu-item-indicator.directive.ts

import { Directive, inject } from '@angular/core';
import { RdxContextMenuSelectable } from './context-menu-item-selectable';

@Directive({
    selector: '[rdxContextMenuItemIndicator]',
    standalone: true,
    host: {
        '[style.display]': "item.checked ? 'block' : 'none'",
        '[attr.data-state]': "item.checked ? 'checked' : 'unchecked'"
    }
})
export class RdxContextMenuItemIndicatorDirective {
    item = inject(RdxContextMenuSelectable);
}



# ./context-menu/src/context-menu-item-radio-group.directive.ts

import { UniqueSelectionDispatcher } from '@angular/cdk/collections';
import { AfterContentInit, Directive, EventEmitter, inject, Input, Output } from '@angular/core';

@Directive({
    selector: '[rdxContextMenuItemRadioGroup]',
    standalone: true,
    host: {
        role: 'group'
    },
    providers: [{ provide: UniqueSelectionDispatcher, useClass: UniqueSelectionDispatcher }]
})
export class RdxContextMenuItemRadioGroupDirective<T> implements AfterContentInit {
    private readonly selectionDispatcher = inject(UniqueSelectionDispatcher);

    @Input()
    set value(value: T | null) {
        this._value = value;
    }

    get value(): T | null {
        return this._value;
    }

    private _value: T | null = null;

    @Output() readonly valueChange = new EventEmitter();

    ngAfterContentInit(): void {
        this.selectionDispatcher.notify(this.value as string, '');
    }
}



# ./toggle/README.md

# @radix-ng/primitives/toggle

Secondary entry point of `@radix-ng/primitives/toggle`.



# ./toggle/__tests__/toggle.directive.spec.ts

import { Component, DebugElement, Input } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { RdxToggleDirective } from '../src/toggle.directive';

@Component({
    template:
        '<button rdxToggle [pressed]="pressed" [disabled]="disabled" (onPressedChange)="onToggle($event)">Toggle</button>',
    imports: [RdxToggleDirective]
})
class TestComponent {
    @Input() pressed = false;
    @Input() disabled = false;

    onToggle(pressed: boolean) {
        this.pressed = pressed;
    }
}

describe('RdxToggleDirective', () => {
    let component: TestComponent;
    let fixture: ComponentFixture<TestComponent>;
    let button: DebugElement;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [TestComponent]
        }).compileComponents();
    });

    beforeEach(() => {
        fixture = TestBed.createComponent(TestComponent);
        component = fixture.componentInstance;
        button = fixture.debugElement.query(By.css('button'));
        fixture.detectChanges();
    });

    it('should initialize with default values', () => {
        expect(component.pressed).toBe(false);
        expect(component.disabled).toBe(false);
    });

    it('should apply the correct aria-pressed attribute', () => {
        expect(button.nativeElement.getAttribute('aria-pressed')).toBe('false');
        component.pressed = true;
        fixture.detectChanges();
        expect(button.nativeElement.getAttribute('aria-pressed')).toBe('true');
    });

    it('should apply the correct data-state attribute', () => {
        expect(button.nativeElement.getAttribute('data-state')).toBe('off');
        component.pressed = true;
        fixture.detectChanges();
        expect(button.nativeElement.getAttribute('data-state')).toBe('on');
    });

    it('should apply the correct data-disabled attribute', () => {
        expect(button.nativeElement.getAttribute('data-disabled')).toBe(null);
        component.disabled = true;
        fixture.detectChanges();
        expect(button.nativeElement.getAttribute('data-disabled')).toBe('');
    });

    it('should toggle the pressed state on click', () => {
        expect(component.pressed).toBe(false);
        button.nativeElement.click();
        expect(component.pressed).toBe(true);
        button.nativeElement.click();
        expect(component.pressed).toBe(false);
    });

    it('should not toggle the pressed state when disabled', () => {
        component.disabled = true;
        fixture.detectChanges();
        expect(component.pressed).toBe(false);
        button.nativeElement.click();
        expect(component.pressed).toBe(false);
    });

    it('should emit the pressed state change event on toggle', () => {
        const spy = jest.spyOn(component, 'onToggle');
        button.nativeElement.click();
        expect(spy).toHaveBeenCalledWith(true);
        button.nativeElement.click();
        expect(spy).toHaveBeenCalledWith(false);
    });
});



# ./toggle/index.ts

export * from './src/toggle-visually-hidden-input.directive';
export * from './src/toggle.directive';

export type { DataState, ToggleProps } from './src/toggle.directive';



# ./toggle/src/toggle.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import {
    booleanAttribute,
    computed,
    Directive,
    forwardRef,
    input,
    model,
    output,
    OutputEmitterRef,
    signal
} from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

export interface ToggleProps {
    /**
     * The controlled state of the toggle.
     */
    pressed?: boolean;

    /**
     * The state of the toggle when initially rendered. Use `defaultPressed`
     * if you do not need to control the state of the toggle.
     * @defaultValue false
     */
    defaultPressed?: boolean;

    /**
     * The callback that fires when the state of the toggle changes.
     */
    onPressedChange?: OutputEmitterRef<boolean>;

    /**
     * Whether the toggle is disabled.
     * @defaultValue false
     */
    disabled?: boolean;
}

export type DataState = 'on' | 'off';

export const TOGGLE_VALUE_ACCESSOR: any = {
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => RdxToggleDirective),
    multi: true
};

/**
 * @group Components
 */
@Directive({
    selector: '[rdxToggle]',
    exportAs: 'rdxToggle',
    standalone: true,
    providers: [TOGGLE_VALUE_ACCESSOR],
    host: {
        '[attr.aria-pressed]': 'pressed()',
        '[attr.data-state]': 'dataState()',
        '[attr.data-disabled]': 'disabledState() ? "" : undefined',
        '[disabled]': 'disabledState()',

        '(click)': 'togglePressed()'
    }
})
export class RdxToggleDirective implements ControlValueAccessor {
    /**
     * The pressed state of the toggle when it is initially rendered.
     * Use when you do not need to control its pressed state.
     *
     * @group Props
     */
    readonly defaultPressed = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * The controlled pressed state of the toggle.
     * Must be used in conjunction with `onPressedChange`.
     *
     * @group Props
     */
    readonly pressed = model<boolean>(this.defaultPressed());

    /**
     * When true, prevents the user from interacting with the toggle.
     *
     * @group Props
     */
    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /** @ignore */
    readonly disabledModel = model<boolean>(this.disabled());

    /** @ignore */
    readonly disabledState = computed(() => this.disabled() || this.disabledModel() || this.accessorDisabled());

    protected readonly dataState = computed<DataState>(() => {
        return this.pressed() ? 'on' : 'off';
    });

    /**
     * Event handler called when the pressed state of the toggle changes.
     *
     * @group Emits
     */
    readonly onPressedChange = output<boolean>();

    protected togglePressed(): void {
        if (!this.disabled()) {
            this.pressed.set(!this.pressed());
            this.onChange(this.pressed());
            this.onPressedChange.emit(this.pressed());
        }
    }

    private readonly accessorDisabled = signal(false);

    private onChange: (value: any) => void = () => {};

    /** @ignore */
    onTouched: (() => void) | undefined;

    /** @ignore */
    writeValue(value: any): void {
        this.pressed.set(value);
    }

    /** @ignore */
    registerOnChange(fn: (value: any) => void): void {
        this.onChange = fn;
    }

    /** @ignore */
    registerOnTouched(fn: () => void): void {
        this.onTouched = fn;
    }

    /** @ignore */
    setDisabledState(isDisabled: boolean): void {
        this.accessorDisabled.set(isDisabled);
    }
}



# ./toggle/src/toggle-visually-hidden-input.directive.ts

import { Directive } from '@angular/core';
import { RdxVisuallyHiddenInputDirective } from '@radix-ng/primitives/visually-hidden';

@Directive({
    selector: 'input[rdxToggleVisuallyHiddenInput]',
    exportAs: 'rdxToggleVisuallyHiddenInput',
    standalone: true,
    hostDirectives: [
        {
            directive: RdxVisuallyHiddenInputDirective,
            inputs: [
                'name',
                'required',
                'value',
                'disabled'
            ]
        }
    ],
    host: {
        type: 'checkbox'
    }
})
export class RdxToggleVisuallyHiddenInputDirective {}



# ./dialog/README.md

# @radix-ng/primitives/dialog



# ./dialog/__tests__/dialog-content.directive.spec.ts

import { Component, DebugElement } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { Subject } from 'rxjs';
import { RdxDialogContentDirective } from '../src/dialog-content.directive';
import { RdxDialogRef } from '../src/dialog-ref';

@Component({
    template: '<div rdxDialogContent>Dialog Content</div>',
    imports: [RdxDialogContentDirective]
})
class TestComponent {}

describe('RdxDialogContentDirective', () => {
    let fixture: ComponentFixture<TestComponent>;
    let directiveElement: DebugElement;
    let directive: RdxDialogContentDirective;
    let dialogRefMock: jest.Mocked<RdxDialogRef>;
    let closedSubject: Subject<any>;

    beforeEach(async () => {
        closedSubject = new Subject();
        dialogRefMock = {
            closed$: closedSubject.asObservable(),
            close: jest.fn(),
            dismiss: jest.fn()
        } as any;

        await TestBed.configureTestingModule({
            imports: [TestComponent],
            providers: [
                { provide: RdxDialogRef, useValue: dialogRefMock }]
        }).compileComponents();

        fixture = TestBed.createComponent(TestComponent);
        directiveElement = fixture.debugElement.query(By.directive(RdxDialogContentDirective));
        directive = directiveElement.injector.get(RdxDialogContentDirective);
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(directive).toBeTruthy();
    });

    it('should have correct initial state', () => {
        expect(directive['state']()).toBe('open');
    });

    it('should update state when dialog is closed', () => {
        closedSubject.next(undefined);
        fixture.detectChanges();
        expect(directive['state']()).toBe('closed');
    });

    it('should call dialogRef.dismiss when dismiss method is called', () => {
        directive.dismiss();
        expect(dialogRefMock.dismiss).toHaveBeenCalled();
    });

    it('should call dialogRef.dismiss when dismiss method is called', () => {
        directive.dismiss();
        expect(dialogRefMock.dismiss).toHaveBeenCalled();
    });

    it('should have correct host bindings', () => {
        const element = directiveElement.nativeElement;
        expect(element.getAttribute('role')).toBe('dialog');
        expect(element.getAttribute('aria-describedby')).toBe('true');
        expect(element.getAttribute('aria-labelledby')).toBe('true');
        expect(element.getAttribute('data-state')).toBe('open');

        closedSubject.next(undefined);
        fixture.detectChanges();

        expect(element.getAttribute('data-state')).toBe('closed');
    });
});



# ./dialog/__tests__/dialog-trigger.directive.spec.ts

import { Component, OnInit, TemplateRef, ViewChild } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { of } from 'rxjs';
import { RdxDialogRef } from '../src/dialog-ref';
import { RdxDialogTriggerDirective } from '../src/dialog-trigger.directive';
import { RdxDialogConfig } from '../src/dialog.config';
import { RdxDialogService } from '../src/dialog.service';

@Component({
    template: `
        <button [rdxDialogTrigger]="dialogTemplate" [rdxDialogConfig]="config">Open Dialog</button>
        <ng-template #dialogTemplate>Dialog Content</ng-template>
    `,
    imports: [RdxDialogTriggerDirective]
})
class TestHostComponent implements OnInit {
    @ViewChild('dialogTemplate') dialogTemplate: TemplateRef<any>;

    config: RdxDialogConfig<unknown>;

    ngOnInit() {
        this.config = {
            content: this.dialogTemplate,
            modal: true,
            ariaLabel: 'Test Dialog',
            autoFocus: 'first-tabbable',
            canClose: () => true,
            canCloseWithBackdrop: true,
            mode: 'default'
        };
    }
}

describe('RdxDialogTriggerDirective', () => {
    let fixture: ComponentFixture<TestHostComponent>;
    let directive: RdxDialogTriggerDirective;
    let dialogServiceMock: jest.Mocked<RdxDialogService>;
    let dialogRefMock: jest.Mocked<RdxDialogRef>;

    beforeEach(async () => {
        dialogRefMock = {
            closed$: of(undefined)
        } as any;

        dialogServiceMock = {
            open: jest.fn().mockReturnValue(dialogRefMock)
        } as any;

        await TestBed.configureTestingModule({
            imports: [TestHostComponent],
            providers: [
                { provide: RdxDialogService, useValue: dialogServiceMock }]
        }).compileComponents();

        fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const directiveEl = fixture.debugElement.query(By.directive(RdxDialogTriggerDirective));
        directive = directiveEl.injector.get(RdxDialogTriggerDirective);
    });

    it('should create', () => {
        expect(directive).toBeTruthy();
    });

    it('should have correct initial state', () => {
        expect(directive.isOpen()).toBe(false);
        expect(directive.state()).toBe('closed');
    });
});



# ./dialog/index.ts

import { NgModule } from '@angular/core';
import { RdxDialogCloseDirective } from './src/dialog-close.directive';
import { RdxDialogContentDirective } from './src/dialog-content.directive';
import { RdxDialogDescriptionDirective } from './src/dialog-description.directive';
import { RdxDialogDismissDirective } from './src/dialog-dismiss.directive';
import { RdxDialogTitleDirective } from './src/dialog-title.directive';
import { RdxDialogTriggerDirective } from './src/dialog-trigger.directive';

export * from './src/dialog-close.directive';
export * from './src/dialog-content.directive';
export * from './src/dialog-description.directive';
export * from './src/dialog-dismiss.directive';
export * from './src/dialog-ref';
export * from './src/dialog-title.directive';
export * from './src/dialog-trigger.directive';
export * from './src/dialog.config';
export * from './src/dialog.injectors';
export * from './src/dialog.providers';
export * from './src/dialog.service';

const _imports = [
    RdxDialogTriggerDirective,
    RdxDialogContentDirective,
    RdxDialogTitleDirective,
    RdxDialogCloseDirective,
    RdxDialogDescriptionDirective,
    RdxDialogDismissDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxDialogModule {}



# ./dialog/src/dialog-description.directive.ts

import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxDialogDescription]',
    standalone: true
})
export class RdxDialogDescriptionDirective {}



# ./dialog/src/dialog.config.ts

import { AutoFocusTarget, DialogConfig } from '@angular/cdk/dialog';
import { ComponentType } from '@angular/cdk/overlay';
import { TemplateRef } from '@angular/core';
import { Observable } from 'rxjs';

const ɵdialogData = Symbol.for('rdxDialogData');
const ɵdialogResult = Symbol.for('rdxDialogResult');

export type ɵDialogDataFlag = { [ɵdialogData]: unknown };
export type ɵDialogResultFlag<R> = { [ɵdialogResult]: R };

export type RdxDialogData<T> = {
    [K in keyof T]: T[K] extends ɵDialogDataFlag ? Omit<T[K], typeof ɵdialogData> : never;
}[keyof T];

type DialogRefProps<C> = { [K in keyof C]: C[K] extends ɵDialogResultFlag<unknown> ? K : never }[keyof C] & keyof C;
export type RdxDialogResult<C> =
    DialogRefProps<C> extends never ? void : C[DialogRefProps<C>] extends ɵDialogResultFlag<infer T> ? T : void;

type RdxDialogMode = 'default' | 'sheet' | 'sheet-bottom' | 'sheet-top' | 'sheet-left' | 'sheet-right';

type RdxBaseDialogConfig<C> = {
    content: ComponentType<C> | TemplateRef<C>;

    data: RdxDialogData<C>;

    modal?: boolean;

    ariaLabel?: string;

    autoFocus?: AutoFocusTarget | 'first-input' | string;

    canClose?: (comp: C) => boolean | Observable<boolean>;

    canCloseWithBackdrop?: boolean;

    cdkConfigOverride?: Partial<DialogConfig<C>>;

    mode?: RdxDialogMode;

    backdropClass?: string | string[];

    panelClasses?: string[];

    isAlert?: boolean;
};

export type RdxDialogConfig<T> =
    RdxDialogData<T> extends never
        ? Omit<RdxBaseDialogConfig<T>, 'data'>
        : RdxBaseDialogConfig<T> & { data: Required<RdxDialogData<T>> };

export type RdxDialogState = 'open' | 'closed';

export function getState(open: boolean): RdxDialogState {
    return open ? 'open' : 'closed';
}



# ./dialog/src/dialog-title.directive.ts

import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxDialogTitle]',
    standalone: true
})
export class RdxDialogTitleDirective {}



# ./dialog/src/dialog.service.ts

import { Dialog } from '@angular/cdk/dialog';
import { inject, Injectable, Injector, Renderer2 } from '@angular/core';
import { filter, isObservable, merge, of, switchMap, take, takeUntil } from 'rxjs';
import { DISMISSED_VALUE, RdxDialogRef } from './dialog-ref';
import type { RdxDialogConfig, RdxDialogResult } from './dialog.config';

/**
 * Modality control: When `isModal` is set to `true`, the dialog will:
 *
 * - Have a backdrop that blocks interaction with the rest of the page
 * - Disable closing by clicking outside or pressing Escape
 * - Set `aria-modal="true"` for screen readers
 * - Automatically focus the first tabbable element in the dialog
 * - Restore focus to the element that opened the dialog when it's closed
 *
 *
 * When `isModal` is `false`, the dialog will:
 *
 * - Not have a backdrop, allowing interaction with the rest of the page
 * - Allow closing by clicking outside or pressing Escape
 * - Not set `aria-modal` attribute
 * - Not automatically manage focus
 */
@Injectable()
export class RdxDialogService {
    #cdkDialog = inject(Dialog);
    #injector = inject(Injector);

    open<C>(config: RdxDialogConfig<C>): RdxDialogRef<C> {
        let dialogRef: RdxDialogRef<C>;
        let modeClasses: string[] = [];

        switch (config.mode) {
            case 'sheet':
                modeClasses = ['mod-sheet', 'mod-right'];
                break;
            case 'sheet-right':
                modeClasses = ['mod-sheet', 'mod-right'];
                break;
            case 'sheet-bottom':
                modeClasses = ['mod-sheet', 'mod-bottom'];
                break;
            case 'sheet-left':
                modeClasses = ['mod-sheet', 'mod-left'];
                break;
            case 'sheet-top':
                modeClasses = ['mod-sheet', 'mod-top'];
                break;
        }

        const cdkRef = this.#cdkDialog.open<RdxDialogResult<C> | typeof DISMISSED_VALUE, unknown, C>(config.content, {
            ariaModal: config.modal ?? true,
            hasBackdrop: config.modal ?? true,
            data: 'data' in config ? config.data : null,
            restoreFocus: true,
            role: config.isAlert ? 'alertdialog' : 'dialog',
            disableClose: true,
            closeOnDestroy: true,
            injector: this.#injector,
            backdropClass: config.backdropClass ? config.backdropClass : 'cdk-overlay-dark-backdrop',
            panelClass: ['dialog', ...modeClasses, ...(config.panelClasses || [])],
            autoFocus: config.autoFocus === 'first-input' ? 'dialog' : (config.autoFocus ?? 'first-tabbable'),
            ariaLabel: config.ariaLabel,
            templateContext: () => ({ dialogRef: dialogRef }),
            providers: (ref) => {
                dialogRef = new RdxDialogRef(ref, config);
                return [
                    {
                        provide: RdxDialogRef,
                        useValue: dialogRef
                    }
                ];
            },
            // @FIXME
            ...(config.cdkConfigOverride || ({} as any))
        });

        if (cdkRef.componentRef) {
            cdkRef.componentRef.injector
                .get(Renderer2)
                .setStyle(cdkRef.componentRef.location.nativeElement, 'display', 'contents');
        }

        if (!config.isAlert) {
            merge(
                cdkRef.backdropClick,
                cdkRef.keydownEvents.pipe(filter((e) => e.key === 'Escape' && !e.defaultPrevented))
            )
                .pipe(
                    filter(() => config.canCloseWithBackdrop ?? true),
                    switchMap(() => {
                        const canClose =
                            (cdkRef.componentInstance && config.canClose?.(cdkRef.componentInstance)) ?? true;
                        const canClose$ = isObservable(canClose) ? canClose : of(canClose);
                        return canClose$.pipe(take(1));
                    }),

                    takeUntil(dialogRef!.closed$)
                )
                .subscribe((canClose) => {
                    if (canClose) {
                        cdkRef.close(DISMISSED_VALUE);
                    }
                });
        }

        return dialogRef!;
    }
}



# ./dialog/src/dialog-close.directive.ts

import { Directive, inject } from '@angular/core';
import { RdxDialogRef } from './dialog-ref';

@Directive({
    selector: '[rdxDialogClose]',
    standalone: true,
    host: {
        '(click)': 'onClick()'
    }
})
export class RdxDialogCloseDirective {
    private readonly ref = inject<RdxDialogRef>(RdxDialogRef);

    protected onClick(): void {
        this.ref.close();
    }
}



# ./dialog/src/dialog-dismiss.directive.ts

import { Directive, inject } from '@angular/core';
import { RdxDialogRef } from './dialog-ref';

@Directive({
    selector: 'button[rdxDialogDismiss]',
    standalone: true,
    host: {
        type: 'button',
        '(click)': 'onClick()'
    }
})
export class RdxDialogDismissDirective {
    private readonly ref = inject<RdxDialogRef>(RdxDialogRef);

    protected onClick(): void {
        this.ref.dismiss();
    }
}



# ./dialog/src/dialog.providers.ts

import { DialogModule } from '@angular/cdk/dialog';
import { EnvironmentProviders, importProvidersFrom, makeEnvironmentProviders, Provider } from '@angular/core';
import { RdxDialogService } from './dialog.service';

/**
 * Configures the RdxDialog module by providing necessary dependencies.
 *
 * This function sets up the environment providers required for the RdxDialog to function,
 * specifically importing the Angular CDK's DialogModule.
 *
 * @returns {EnvironmentProviders} An EnvironmentProviders instance containing the DialogModule.
 */
export function provideRdxDialogConfig(): EnvironmentProviders {
    return makeEnvironmentProviders([importProvidersFrom(DialogModule)]);
}

/**
 * Provides the RdxDialogService for dependency injection.
 *
 * This function is used to make the RdxDialogService available for injection
 * in components, directives, or other services that require dialog functionality.
 *
 * @returns {Provider} A provider for the RdxDialogService.
 */
export function provideRdxDialog(): Provider {
    return RdxDialogService;
}



# ./dialog/src/dialog-trigger.directive.ts

import { computed, Directive, inject, Input, input, signal, TemplateRef } from '@angular/core';
import { RdxDialogRef } from './dialog-ref';
import { getState, RdxDialogConfig, RdxDialogState } from './dialog.config';
import { provideRdxDialog } from './dialog.providers';
import { RdxDialogService } from './dialog.service';

let nextId = 0;

/**
 * @group Components
 */
@Directive({
    selector: '[rdxDialogTrigger]',
    standalone: true,
    providers: [provideRdxDialog()],
    host: {
        type: 'button',
        '[attr.id]': 'id()',
        '[attr.aria-haspopup]': '"dialog"',
        '[attr.aria-expanded]': 'isOpen()',
        '[attr.aria-controls]': 'dialogId()',
        '[attr.data-state]': 'state()',
        '(click)': 'onClick()'
    }
})
export class RdxDialogTriggerDirective {
    private readonly dialogService = inject(RdxDialogService);

    /**
     * @group Props
     */
    readonly id = input(`rdx-dialog-trigger-${nextId++}`);
    readonly dialogId = computed(() => `rdx-dialog-${this.id()}`);

    /**
     * @group Props
     */
    @Input({ required: true, alias: 'rdxDialogTrigger' }) dialog: TemplateRef<void>;

    /**
     * @group Props
     */
    @Input({ alias: 'rdxDialogConfig' }) dialogConfig: RdxDialogConfig<unknown>;

    readonly isOpen = signal(false);
    readonly state = computed<RdxDialogState>(() => getState(this.isOpen()));

    private currentDialogRef: RdxDialogRef | null = null;

    protected onClick() {
        this.currentDialogRef = this.dialogService.open({
            ...this.dialogConfig,
            content: this.dialog
        });

        this.isOpen.set(true);

        this.currentDialogRef.closed$.subscribe(() => {
            this.isOpen.set(false);
            this.currentDialogRef = null;
        });
    }
}



# ./dialog/src/dialog.injectors.ts

import { DIALOG_DATA } from '@angular/cdk/dialog';
import { inject } from '@angular/core';
import { RdxDialogRef, RdxDialogSelfRef } from './dialog-ref';
import { ɵDialogDataFlag, ɵDialogResultFlag } from './dialog.config';

export function injectDialogData<TData>(): TData & ɵDialogDataFlag {
    return inject<TData & ɵDialogDataFlag>(DIALOG_DATA);
}

export function injectDialogRef<R = void>(): RdxDialogSelfRef<R> & ɵDialogResultFlag<R> {
    return inject<RdxDialogSelfRef<R>>(RdxDialogRef) as RdxDialogSelfRef<R> & ɵDialogResultFlag<R>;
}



# ./dialog/src/dialog-ref.ts

import { DialogRef } from '@angular/cdk/dialog';
import { filter, isObservable, map, Observable, of, take } from 'rxjs';
import { RdxDialogConfig, RdxDialogResult } from './dialog.config';

export const DISMISSED_VALUE = {} as const;

function isDismissed(v: unknown): v is typeof DISMISSED_VALUE {
    return v === DISMISSED_VALUE;
}

/**
 * Represents a reference to an open dialog.
 * Provides methods and observables to interact with and monitor the dialog's state.
 * @template C - The type of the dialog's content component
 */
export class RdxDialogRef<C = unknown> {
    closed$: Observable<RdxDialogResult<C> | undefined> = this.cdkRef.closed.pipe(
        map((res): RdxDialogResult<C> | undefined => (isDismissed(res) ? undefined : res))
    );

    dismissed$: Observable<void> = this.cdkRef.closed.pipe(
        filter((res) => res === DISMISSED_VALUE),
        map((): void => undefined)
    );

    result$: Observable<RdxDialogResult<C>> = this.cdkRef.closed.pipe(
        filter((res): res is RdxDialogResult<C> => !isDismissed(res))
    );

    /**
     * @param cdkRef - Reference to the underlying CDK dialog
     * @param config - Configuration options for the dialog
     */
    constructor(
        public readonly cdkRef: DialogRef<RdxDialogResult<C> | typeof DISMISSED_VALUE, C>,
        public readonly config: RdxDialogConfig<C>
    ) {}

    get instance(): C | null {
        return this.cdkRef.componentInstance;
    }

    /**
     * Attempts to dismiss the dialog
     * Checks the canClose condition before dismissing
     */
    dismiss(): void {
        if (!this.instance || this.config.isAlert) {
            return;
        }

        const canClose = this.config.canClose?.(this.instance) ?? true;
        const canClose$ = isObservable(canClose) ? canClose : of(canClose);
        canClose$.pipe(take(1)).subscribe((close) => {
            if (close) {
                this.cdkRef.close(DISMISSED_VALUE);
            }
        });
    }

    close(result: RdxDialogResult<C>): void {
        this.cdkRef.close(result);
    }
}

/**
 * Represents a simplified interface for dialog interaction
 * Typically used by dialog content components
 * @template R - The type of the result when closing the dialog
 */
export type RdxDialogSelfRef<R> = { dismiss(): void; close(res: R): void };



# ./dialog/src/dialog-content.directive.ts

import { computed, DestroyRef, Directive, inject, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { RdxDialogRef } from './dialog-ref';
import { getState, RdxDialogResult } from './dialog.config';

@Directive({
    selector: '[rdxDialogContent]',
    standalone: true,
    host: {
        role: 'dialog',
        '[attr.aria-describedby]': '"true"',
        '[attr.aria-labelledby]': '"true"',
        '[attr.data-state]': 'state()'
    }
})
export class RdxDialogContentDirective<C = unknown> {
    private readonly dialogRef = inject<RdxDialogRef<C>>(RdxDialogRef);
    private readonly destroyRef = inject(DestroyRef);

    private readonly isOpen = signal(true);

    readonly state = computed(() => getState(this.isOpen()));

    constructor() {
        this.dialogRef.closed$.pipe(takeUntilDestroyed(this.destroyRef)).subscribe(() => {
            this.isOpen.set(false);
        });
    }

    /**
     * Closes the dialog with a specified result.
     *
     * @param result The result to be passed back when closing the dialog
     */
    close(result: RdxDialogResult<C>): void {
        this.dialogRef.close(result);
    }

    /**
     * Dismisses the dialog without a result.
     */
    dismiss(): void {
        this.dialogRef.dismiss();
    }
}



# ./popover/README.md

# @radix-ng/primitives/popover

Secondary entry point of `@radix-ng/primitives`. It can be used by importing from `@radix-ng/primitives/popover`.



# ./popover/index.ts

import { NgModule } from '@angular/core';
import { RdxPopoverAnchorDirective } from './src/popover-anchor.directive';
import { RdxPopoverArrowDirective } from './src/popover-arrow.directive';
import { RdxPopoverCloseDirective } from './src/popover-close.directive';
import { RdxPopoverContentAttributesComponent } from './src/popover-content-attributes.component';
import { RdxPopoverContentDirective } from './src/popover-content.directive';
import { RdxPopoverRootDirective } from './src/popover-root.directive';
import { RdxPopoverTriggerDirective } from './src/popover-trigger.directive';

export * from './src/popover-anchor.directive';
export * from './src/popover-arrow.directive';
export * from './src/popover-close.directive';
export * from './src/popover-content-attributes.component';
export * from './src/popover-content.directive';
export * from './src/popover-root.directive';
export * from './src/popover-trigger.directive';

const _imports = [
    RdxPopoverArrowDirective,
    RdxPopoverCloseDirective,
    RdxPopoverContentDirective,
    RdxPopoverTriggerDirective,
    RdxPopoverRootDirective,
    RdxPopoverAnchorDirective,
    RdxPopoverContentAttributesComponent
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxPopoverModule {}



# ./popover/src/popover-anchor.token.ts

import { InjectionToken } from '@angular/core';
import { RdxPopoverAnchorDirective } from './popover-anchor.directive';

export const RdxPopoverAnchorToken = new InjectionToken<RdxPopoverAnchorDirective>('RdxPopoverAnchorToken');



# ./popover/src/popover-content-attributes.component.ts

import { ChangeDetectionStrategy, Component, computed, forwardRef } from '@angular/core';
import { RdxPopoverContentAttributesToken } from './popover-content-attributes.token';
import { injectPopoverRoot } from './popover-root.inject';
import { RdxPopoverAnimationStatus, RdxPopoverState } from './popover.types';

@Component({
    selector: '[rdxPopoverContentAttributes]',
    template: `
        <ng-content />
    `,
    host: {
        '[attr.role]': '"dialog"',
        '[attr.id]': 'name()',
        '[attr.data-state]': 'popoverRoot.state()',
        '[attr.data-side]': 'popoverRoot.popoverContentDirective().side()',
        '[attr.data-align]': 'popoverRoot.popoverContentDirective().align()',
        '[style]': 'disableAnimation() ? {animation: "none !important"} : null',
        '(animationstart)': 'onAnimationStart($event)',
        '(animationend)': 'onAnimationEnd($event)'
    },
    providers: [
        {
            provide: RdxPopoverContentAttributesToken,
            useExisting: forwardRef(() => RdxPopoverContentAttributesComponent)
        }
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class RdxPopoverContentAttributesComponent {
    /** @ignore */
    protected readonly popoverRoot = injectPopoverRoot();

    /** @ignore */
    readonly name = computed(() => `rdx-popover-content-attributes-${this.popoverRoot.uniqueId()}`);

    /** @ignore */
    readonly disableAnimation = computed(() => !this.canAnimate());

    /** @ignore */
    protected onAnimationStart(_: AnimationEvent) {
        this.popoverRoot.cssAnimationStatus.set(
            this.popoverRoot.state() === RdxPopoverState.OPEN
                ? RdxPopoverAnimationStatus.OPEN_STARTED
                : RdxPopoverAnimationStatus.CLOSED_STARTED
        );
    }

    /** @ignore */
    protected onAnimationEnd(_: AnimationEvent) {
        this.popoverRoot.cssAnimationStatus.set(
            this.popoverRoot.state() === RdxPopoverState.OPEN
                ? RdxPopoverAnimationStatus.OPEN_ENDED
                : RdxPopoverAnimationStatus.CLOSED_ENDED
        );
    }

    /** @ignore */
    private canAnimate() {
        return (
            this.popoverRoot.cssAnimation() &&
            ((this.popoverRoot.cssOpeningAnimation() && this.popoverRoot.state() === RdxPopoverState.OPEN) ||
                (this.popoverRoot.cssClosingAnimation() && this.popoverRoot.state() === RdxPopoverState.CLOSED))
        );
    }
}



# ./popover/src/popover.types.ts

export enum RdxPopoverState {
    OPEN = 'open',
    CLOSED = 'closed'
}

export enum RdxPopoverAttachDetachEvent {
    ATTACH = 'attach',
    DETACH = 'detach'
}

export enum RdxPopoverAnimationStatus {
    OPEN_STARTED = 'open_started',
    OPEN_ENDED = 'open_ended',
    CLOSED_STARTED = 'closed_started',
    CLOSED_ENDED = 'closed_ended'
}



# ./popover/src/popover-root.inject.ts

import { assertInInjectionContext, inject, isDevMode } from '@angular/core';
import { RdxPopoverRootDirective } from './popover-root.directive';

export function injectPopoverRoot(optional?: false): RdxPopoverRootDirective;
export function injectPopoverRoot(optional: true): RdxPopoverRootDirective | null;
export function injectPopoverRoot(optional = false): RdxPopoverRootDirective | null {
    isDevMode() && assertInInjectionContext(injectPopoverRoot);
    return inject(RdxPopoverRootDirective, { optional });
}



# ./popover/src/popover-close.directive.ts

import { Directive, effect, ElementRef, forwardRef, inject, Renderer2, untracked } from '@angular/core';
import { RdxPopoverCloseToken } from './popover-close.token';
import { injectPopoverRoot } from './popover-root.inject';

@Directive({
    selector: '[rdxPopoverClose]',
    host: {
        type: 'button',
        '(click)': 'popoverRoot.handleClose()'
    },
    providers: [
        {
            provide: RdxPopoverCloseToken,
            useExisting: forwardRef(() => RdxPopoverCloseDirective)
        }
    ]
})
export class RdxPopoverCloseDirective {
    /** @ignore */
    protected readonly popoverRoot = injectPopoverRoot();
    /** @ignore */
    readonly elementRef = inject(ElementRef);
    /** @ignore */
    private readonly renderer = inject(Renderer2);

    constructor() {
        this.onIsControlledExternallyEffect();
    }

    /** @ignore */
    private onIsControlledExternallyEffect() {
        effect(() => {
            const isControlledExternally = this.popoverRoot.controlledExternally()();

            untracked(() => {
                this.renderer.setStyle(
                    this.elementRef.nativeElement,
                    'display',
                    isControlledExternally ? 'none' : null
                );
            });
        });
    }
}



# ./popover/src/utils/cdk-event.service.ts

import {
    DestroyRef,
    EnvironmentProviders,
    inject,
    Injectable,
    InjectionToken,
    isDevMode,
    makeEnvironmentProviders,
    NgZone,
    Provider,
    Renderer2,
    VERSION
} from '@angular/core';
import { injectDocument, injectWindow } from '@radix-ng/primitives/core';
import { RdxCdkEventServiceWindowKey } from './constants';
import { EventType, EventTypeAsPrimitiveConfigKey, PrimitiveConfig, PrimitiveConfigs } from './types';

function eventTypeAsPrimitiveConfigKey(eventType: EventType): EventTypeAsPrimitiveConfigKey {
    return `prevent${eventType[0].toUpperCase()}${eventType.slice(1)}` as EventTypeAsPrimitiveConfigKey;
}

@Injectable()
class RdxCdkEventService {
    document = injectDocument();
    destroyRef = inject(DestroyRef);
    ngZone = inject(NgZone);
    renderer2 = inject(Renderer2);
    window = injectWindow();

    primitiveConfigs?: PrimitiveConfigs;

    onDestroyCallbacks: Set<() => void> = new Set([() => deleteRdxCdkEventServiceWindowKey(this.window)]);

    #clickDomRootEventCallbacks: Set<(event: MouseEvent) => void> = new Set();

    constructor() {
        this.#listenToClickDomRootEvent();
        this.#registerOnDestroyCallbacks();
    }

    registerPrimitive<T extends object>(primitiveInstance: T) {
        if (!this.primitiveConfigs) {
            this.primitiveConfigs = new Map();
        }
        if (!this.primitiveConfigs.has(primitiveInstance)) {
            this.primitiveConfigs.set(primitiveInstance, {});
        }
    }

    deregisterPrimitive<T extends object>(primitiveInstance: T) {
        if (this.primitiveConfigs?.has(primitiveInstance)) {
            this.primitiveConfigs.delete(primitiveInstance);
        }
    }

    preventPrimitiveFromCdkEvent<T extends object>(primitiveInstance: T, eventType: EventType) {
        this.#setPreventPrimitiveFromCdkEvent(primitiveInstance, eventType, true);
    }

    allowPrimitiveForCdkEvent<T extends object>(primitiveInstance: T, eventType: EventType) {
        this.#setPreventPrimitiveFromCdkEvent(primitiveInstance, eventType, false);
    }

    preventPrimitiveFromCdkMultiEvents<T extends object>(primitiveInstance: T, eventTypes: EventType[]) {
        eventTypes.forEach((eventType) => {
            this.#setPreventPrimitiveFromCdkEvent(primitiveInstance, eventType, true);
        });
    }

    allowPrimitiveForCdkMultiEvents<T extends object>(primitiveInstance: T, eventTypes: EventType[]) {
        eventTypes.forEach((eventType) => {
            this.#setPreventPrimitiveFromCdkEvent(primitiveInstance, eventType, false);
        });
    }

    setPreventPrimitiveFromCdkMixEvents<T extends object>(primitiveInstance: T, eventTypes: PrimitiveConfig) {
        Object.keys(eventTypes).forEach((eventType) => {
            this.#setPreventPrimitiveFromCdkEvent(
                primitiveInstance,
                eventType as EventType,
                eventTypes[eventTypeAsPrimitiveConfigKey(eventType as EventType)]
            );
        });
    }

    primitivePreventedFromCdkEvent<T extends object>(primitiveInstance: T, eventType: EventType) {
        return this.primitiveConfigs?.get(primitiveInstance)?.[eventTypeAsPrimitiveConfigKey(eventType)];
    }

    addClickDomRootEventCallback(callback: (event: MouseEvent) => void) {
        this.#clickDomRootEventCallbacks.add(callback);
    }

    removeClickDomRootEventCallback(callback: (event: MouseEvent) => void) {
        return this.#clickDomRootEventCallbacks.delete(callback);
    }

    #setPreventPrimitiveFromCdkEvent<
        T extends object,
        R extends EventType,
        K extends PrimitiveConfig[EventTypeAsPrimitiveConfigKey<R>]
    >(primitiveInstance: T, eventType: R, value: K) {
        if (!this.primitiveConfigs?.has(primitiveInstance)) {
            isDevMode() &&
                console.error(
                    '[RdxCdkEventService.preventPrimitiveFromCdkEvent] RDX Primitive instance has not been registered!',
                    primitiveInstance
                );
            return;
        }
        switch (eventType) {
            case 'cdkOverlayOutsideClick':
                this.primitiveConfigs.get(primitiveInstance)!.preventCdkOverlayOutsideClick = value;
                break;
            case 'cdkOverlayEscapeKeyDown':
                this.primitiveConfigs.get(primitiveInstance)!.preventCdkOverlayEscapeKeyDown = value;
                break;
        }
    }

    #registerOnDestroyCallbacks() {
        this.destroyRef.onDestroy(() => {
            this.onDestroyCallbacks.forEach((onDestroyCallback) => onDestroyCallback());
            this.onDestroyCallbacks.clear();
        });
    }

    #listenToClickDomRootEvent() {
        const target = this.document;
        const eventName = 'click';
        const options: boolean | AddEventListenerOptions | undefined = { capture: true };
        const callback = (event: MouseEvent) => {
            this.#clickDomRootEventCallbacks.forEach((clickDomRootEventCallback) => clickDomRootEventCallback(event));
        };

        const major = parseInt(VERSION.major);
        const minor = parseInt(VERSION.minor);

        let destroyClickDomRootEventListener!: () => void;
        /**
         * @see src/cdk/platform/features/backwards-compatibility.ts in @angular/cdk
         */
        if (major > 19 || (major === 19 && minor > 0) || (major === 0 && minor === 0)) {
            destroyClickDomRootEventListener = this.ngZone.runOutsideAngular(() => {
                const destroyClickDomRootEventListenerInternal = this.renderer2.listen(
                    target,
                    eventName,
                    callback,

                    options
                );
                return () => {
                    destroyClickDomRootEventListenerInternal();
                    this.#clickDomRootEventCallbacks.clear();
                };
            });
        } else {
            /**
             * This part can get removed when v19.1 or higher is on the board
             */
            destroyClickDomRootEventListener = this.ngZone.runOutsideAngular(() => {
                target.addEventListener(eventName, callback, options);
                return () => {
                    this.ngZone.runOutsideAngular(() => target.removeEventListener(eventName, callback, options));
                    this.#clickDomRootEventCallbacks.clear();
                };
            });
        }
        this.onDestroyCallbacks.add(destroyClickDomRootEventListener);
    }
}

const RdxCdkEventServiceToken = new InjectionToken<RdxCdkEventService>('RdxCdkEventServiceToken');

const existsErrorMessage = 'RdxCdkEventService should be provided only once!';

const deleteRdxCdkEventServiceWindowKey = (window: Window & typeof globalThis) => {
    delete (window as any)[RdxCdkEventServiceWindowKey];
};

const getProvider: (throwWhenExists?: boolean) => Provider = (throwWhenExists = true) => ({
    provide: RdxCdkEventServiceToken,
    useFactory: () => {
        isDevMode() && console.log('providing RdxCdkEventService...');
        const window = injectWindow();
        if ((window as any)[RdxCdkEventServiceWindowKey]) {
            if (throwWhenExists) {
                throw Error(existsErrorMessage);
            } else {
                isDevMode() && console.warn(existsErrorMessage);
            }
        }
        (window as any)[RdxCdkEventServiceWindowKey] ??= new RdxCdkEventService();
        return (window as any)[RdxCdkEventServiceWindowKey];
    }
});

export const provideRdxCdkEventServiceInRoot: () => EnvironmentProviders = () =>
    makeEnvironmentProviders([getProvider()]);
export const provideRdxCdkEventService: () => Provider = () => getProvider(false);

export const injectRdxCdkEventService = () => inject(RdxCdkEventServiceToken, { optional: true });



# ./popover/src/utils/types.ts

export type EventType = 'cdkOverlayOutsideClick' | 'cdkOverlayEscapeKeyDown';
export type EventTypeCapitalized<R extends EventType = EventType> = Capitalize<R>;
export type EventTypeAsPrimitiveConfigKey<R extends EventType = EventType> = `prevent${EventTypeCapitalized<R>}`;
export type PrimitiveConfig = {
    [value in EventTypeAsPrimitiveConfigKey]?: boolean;
};
export type PrimitiveConfigs = Map<object, PrimitiveConfig>;



# ./popover/src/utils/constants.ts

export const RdxCdkEventServiceWindowKey = Symbol('__RdxCdkEventService__');



# ./popover/src/popover-arrow.token.ts

import { InjectionToken } from '@angular/core';
import { RdxPopoverArrowDirective } from './popover-arrow.directive';

export const RdxPopoverArrowToken = new InjectionToken<RdxPopoverArrowDirective>('RdxPopoverArrowToken');



# ./popover/src/popover-content.directive.ts

import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import { CdkConnectedOverlay, Overlay } from '@angular/cdk/overlay';
import {
    booleanAttribute,
    computed,
    DestroyRef,
    Directive,
    effect,
    inject,
    input,
    numberAttribute,
    OnInit,
    output,
    SimpleChange,
    TemplateRef,
    untracked
} from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import {
    getAllPossibleConnectedPositions,
    getContentPosition,
    RDX_POSITIONING_DEFAULTS,
    RdxPositionAlign,
    RdxPositionSide,
    RdxPositionSideAndAlignOffsets
} from '@radix-ng/primitives/core';
import { filter, tap } from 'rxjs';
import { injectPopoverRoot } from './popover-root.inject';
import { RdxPopoverAttachDetachEvent } from './popover.types';

@Directive({
    selector: '[rdxPopoverContent]',
    hostDirectives: [
        CdkConnectedOverlay
    ]
})
export class RdxPopoverContentDirective implements OnInit {
    /** @ignore */
    private readonly popoverRoot = injectPopoverRoot();
    /** @ignore */
    private readonly templateRef = inject(TemplateRef);
    /** @ignore */
    private readonly overlay = inject(Overlay);
    /** @ignore */
    private readonly destroyRef = inject(DestroyRef);
    /** @ignore */
    private readonly connectedOverlay = inject(CdkConnectedOverlay);

    /** @ignore */
    readonly name = computed(() => `rdx-popover-trigger-${this.popoverRoot.uniqueId()}`);

    /**
     * @description The preferred side of the trigger to render against when open. Will be reversed when collisions occur and avoidCollisions is enabled.
     * @default top
     */
    readonly side = input<RdxPositionSide>(RdxPositionSide.Top);
    /**
     * @description The distance in pixels from the trigger.
     * @default undefined
     */
    readonly sideOffset = input<number, NumberInput>(NaN, {
        transform: numberAttribute
    });
    /**
     * @description The preferred alignment against the trigger. May change when collisions occur.
     * @default center
     */
    readonly align = input<RdxPositionAlign>(RdxPositionAlign.Center);
    /**
     * @description An offset in pixels from the "start" or "end" alignment options.
     * @default undefined
     */
    readonly alignOffset = input<number, NumberInput>(NaN, {
        transform: numberAttribute
    });

    /**
     * @description Whether to add some alternate positions of the content.
     * @default false
     */
    readonly alternatePositionsDisabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /** @description Whether to prevent `onOverlayEscapeKeyDown` handler from calling. */
    readonly onOverlayEscapeKeyDownDisabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });
    /** @description Whether to prevent `onOverlayOutsideClick` handler from calling. */
    readonly onOverlayOutsideClickDisabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * @description Event handler called when the escape key is down.
     * It can be prevented by setting `onOverlayEscapeKeyDownDisabled` input to `true`.
     */
    readonly onOverlayEscapeKeyDown = output<KeyboardEvent>();
    /**
     * @description Event handler called when a pointer event occurs outside the bounds of the component.
     * It can be prevented by setting `onOverlayOutsideClickDisabled` input to `true`.
     */
    readonly onOverlayOutsideClick = output<MouseEvent>();

    /**
     * @description Event handler called after the overlay is open
     */
    readonly onOpen = output<void>();
    /**
     * @description Event handler called after the overlay is closed
     */
    readonly onClosed = output<void>();

    /** @ingore */
    readonly positions = computed(() => this.computePositions());

    constructor() {
        this.onOriginChangeEffect();
        this.onPositionChangeEffect();
    }

    /** @ignore */
    ngOnInit() {
        this.setScrollStrategy();
        this.setHasBackdrop();
        this.setDisableClose();
        this.onAttach();
        this.onDetach();
        this.connectKeydownEscape();
        this.connectOutsideClick();
    }

    /** @ignore */
    open() {
        if (this.connectedOverlay.open) {
            return;
        }
        const prevOpen = this.connectedOverlay.open;
        this.connectedOverlay.open = true;
        this.fireOverlayNgOnChanges('open', this.connectedOverlay.open, prevOpen);
    }

    /** @ignore */
    close() {
        if (!this.connectedOverlay.open) {
            return;
        }
        const prevOpen = this.connectedOverlay.open;
        this.connectedOverlay.open = false;
        this.fireOverlayNgOnChanges('open', this.connectedOverlay.open, prevOpen);
    }

    /** @ignore */
    positionChange() {
        return this.connectedOverlay.positionChange.asObservable();
    }

    /** @ignore */
    private connectKeydownEscape() {
        this.connectedOverlay.overlayKeydown
            .asObservable()
            .pipe(
                filter(
                    () =>
                        !this.onOverlayEscapeKeyDownDisabled() &&
                        !this.popoverRoot.rdxCdkEventService?.primitivePreventedFromCdkEvent(
                            this.popoverRoot,
                            'cdkOverlayEscapeKeyDown'
                        )
                ),
                filter((event) => event.key === 'Escape'),
                tap((event) => {
                    this.onOverlayEscapeKeyDown.emit(event);
                }),
                filter(() => !this.popoverRoot.firstDefaultOpen()),
                tap(() => {
                    this.popoverRoot.handleClose();
                }),
                takeUntilDestroyed(this.destroyRef)
            )
            .subscribe();
    }

    /** @ignore */
    private connectOutsideClick() {
        this.connectedOverlay.overlayOutsideClick
            .asObservable()
            .pipe(
                filter(
                    () =>
                        !this.onOverlayOutsideClickDisabled() &&
                        !this.popoverRoot.rdxCdkEventService?.primitivePreventedFromCdkEvent(
                            this.popoverRoot,
                            'cdkOverlayOutsideClick'
                        )
                ),
                /**
                 * Handle the situation when an anchor is added and the anchor becomes the origin of the overlay
                 * hence  the trigger will be considered the outside element
                 */
                filter((event) => {
                    return (
                        !this.popoverRoot.popoverAnchorDirective() ||
                        !this.popoverRoot
                            .popoverTriggerDirective()
                            .elementRef.nativeElement.contains(event.target as Element)
                    );
                }),
                tap((event) => {
                    this.onOverlayOutsideClick.emit(event);
                }),
                filter(() => !this.popoverRoot.firstDefaultOpen()),
                tap(() => {
                    this.popoverRoot.handleClose();
                }),
                takeUntilDestroyed(this.destroyRef)
            )
            .subscribe();
    }

    /** @ignore */
    private onAttach() {
        this.connectedOverlay.attach
            .asObservable()
            .pipe(
                tap(() => {
                    /**
                     * `this.onOpen.emit();` is being delegated to the root directive due to the opening animation
                     */
                    this.popoverRoot.attachDetachEvent.set(RdxPopoverAttachDetachEvent.ATTACH);
                }),
                takeUntilDestroyed(this.destroyRef)
            )
            .subscribe();
    }

    /** @ignore */
    private onDetach() {
        this.connectedOverlay.detach
            .asObservable()
            .pipe(
                tap(() => {
                    /**
                     * `this.onClosed.emit();` is being delegated to the root directive due to the closing animation
                     */
                    this.popoverRoot.attachDetachEvent.set(RdxPopoverAttachDetachEvent.DETACH);
                }),
                takeUntilDestroyed(this.destroyRef)
            )
            .subscribe();
    }

    /** @ignore */
    private setScrollStrategy() {
        const prevScrollStrategy = this.connectedOverlay.scrollStrategy;
        this.connectedOverlay.scrollStrategy = this.overlay.scrollStrategies.reposition();
        this.fireOverlayNgOnChanges('scrollStrategy', this.connectedOverlay.scrollStrategy, prevScrollStrategy);
    }

    /** @ignore */
    private setHasBackdrop() {
        const prevHasBackdrop = this.connectedOverlay.hasBackdrop;
        this.connectedOverlay.hasBackdrop = false;
        this.fireOverlayNgOnChanges('hasBackdrop', this.connectedOverlay.hasBackdrop, prevHasBackdrop);
    }

    /** @ignore */
    private setDisableClose() {
        const prevDisableClose = this.connectedOverlay.disableClose;
        this.connectedOverlay.disableClose = true;
        this.fireOverlayNgOnChanges('disableClose', this.connectedOverlay.disableClose, prevDisableClose);
    }

    /** @ignore */
    private setOrigin(origin: CdkConnectedOverlay['origin']) {
        const prevOrigin = this.connectedOverlay.origin;
        this.connectedOverlay.origin = origin;
        this.fireOverlayNgOnChanges('origin', this.connectedOverlay.origin, prevOrigin);
    }

    /** @ignore */
    private setPositions(positions: CdkConnectedOverlay['positions']) {
        const prevPositions = this.connectedOverlay.positions;
        this.connectedOverlay.positions = positions;
        this.fireOverlayNgOnChanges('positions', this.connectedOverlay.positions, prevPositions);
        this.connectedOverlay.overlayRef?.updatePosition();
    }

    /** @ignore */
    private computePositions() {
        const arrowHeight = this.popoverRoot.popoverArrowDirective()?.height() ?? 0;
        const offsets: RdxPositionSideAndAlignOffsets = {
            sideOffset:
                arrowHeight + (isNaN(this.sideOffset()) ? RDX_POSITIONING_DEFAULTS.offsets.side : this.sideOffset()),
            alignOffset: isNaN(this.alignOffset()) ? RDX_POSITIONING_DEFAULTS.offsets.align : this.alignOffset()
        };
        const basePosition = getContentPosition({
            side: this.side(),
            align: this.align(),
            sideOffset: offsets.sideOffset,
            alignOffset: offsets.alignOffset
        });
        const positions = [basePosition];
        if (!this.alternatePositionsDisabled()) {
            /**
             * Alternate positions for better user experience along the X/Y axis (e.g. vertical/horizontal scrolling)
             */
            const allPossibleConnectedPositions = getAllPossibleConnectedPositions();
            allPossibleConnectedPositions.forEach((_, key) => {
                const sideAndAlignArray = key.split('|');
                if (
                    (sideAndAlignArray[0] as RdxPositionSide) !== this.side() ||
                    (sideAndAlignArray[1] as RdxPositionAlign) !== this.align()
                ) {
                    positions.push(
                        getContentPosition({
                            side: sideAndAlignArray[0] as RdxPositionSide,
                            align: sideAndAlignArray[1] as RdxPositionAlign,
                            sideOffset: offsets.sideOffset,
                            alignOffset: offsets.alignOffset
                        })
                    );
                }
            });
        }
        return positions;
    }

    private onOriginChangeEffect() {
        effect(() => {
            const origin = (this.popoverRoot.popoverAnchorDirective() ?? this.popoverRoot.popoverTriggerDirective())
                .overlayOrigin;
            untracked(() => {
                this.setOrigin(origin);
            });
        });
    }

    /** @ignore */
    private onPositionChangeEffect() {
        effect(() => {
            const positions = this.positions();
            this.alternatePositionsDisabled();
            untracked(() => {
                this.setPositions(positions);
            });
        });
    }

    /** @ignore */
    private fireOverlayNgOnChanges<K extends keyof CdkConnectedOverlay, V extends CdkConnectedOverlay[K]>(
        input: K,
        currentValue: V,
        previousValue: V,
        firstChange = false
    ) {
        this.connectedOverlay.ngOnChanges({
            [input]: new SimpleChange(previousValue, currentValue, firstChange)
        });
    }
}



# ./popover/src/popover-arrow.directive.ts

import { NumberInput } from '@angular/cdk/coercion';
import { ConnectedOverlayPositionChange } from '@angular/cdk/overlay';
import {
    afterNextRender,
    computed,
    Directive,
    effect,
    ElementRef,
    forwardRef,
    inject,
    input,
    numberAttribute,
    Renderer2,
    signal,
    untracked
} from '@angular/core';
import { toSignal } from '@angular/core/rxjs-interop';
import {
    getArrowPositionParams,
    getSideAndAlignFromAllPossibleConnectedPositions,
    RDX_POSITIONING_DEFAULTS
} from '@radix-ng/primitives/core';
import { RdxPopoverArrowToken } from './popover-arrow.token';
import { injectPopoverRoot } from './popover-root.inject';

@Directive({
    selector: '[rdxPopoverArrow]',
    providers: [
        {
            provide: RdxPopoverArrowToken,
            useExisting: forwardRef(() => RdxPopoverArrowDirective)
        }
    ]
})
export class RdxPopoverArrowDirective {
    /** @ignore */
    private readonly renderer = inject(Renderer2);
    /** @ignore */
    private readonly popoverRoot = injectPopoverRoot();
    /** @ignore */
    readonly elementRef = inject(ElementRef);

    /**
     * @description The width of the arrow in pixels.
     * @default 10
     */
    readonly width = input<number, NumberInput>(RDX_POSITIONING_DEFAULTS.arrow.width, { transform: numberAttribute });

    /**
     * @description The height of the arrow in pixels.
     * @default 5
     */
    readonly height = input<number, NumberInput>(RDX_POSITIONING_DEFAULTS.arrow.height, { transform: numberAttribute });

    /** @ignore */
    readonly arrowSvgElement = computed<HTMLElement>(() => {
        const width = this.width();
        const height = this.height();

        const svgElement = this.renderer.createElement('svg', 'svg');
        this.renderer.setAttribute(svgElement, 'viewBox', '0 0 30 10');
        this.renderer.setAttribute(svgElement, 'width', String(width));
        this.renderer.setAttribute(svgElement, 'height', String(height));
        const polygonElement = this.renderer.createElement('polygon', 'svg');
        this.renderer.setAttribute(polygonElement, 'points', '0,0 30,0 15,10');
        this.renderer.setAttribute(svgElement, 'preserveAspectRatio', 'none');
        this.renderer.appendChild(svgElement, polygonElement);

        return svgElement;
    });

    /** @ignore */
    private readonly currentArrowSvgElement = signal<HTMLOrSVGElement | undefined>(void 0);
    /** @ignore */
    private readonly position = toSignal(this.popoverRoot.popoverContentDirective().positionChange());

    /** @ignore */
    private anchorOrTriggerRect: DOMRect;

    constructor() {
        afterNextRender({
            write: () => {
                if (this.elementRef.nativeElement.parentElement) {
                    this.renderer.setStyle(this.elementRef.nativeElement.parentElement, 'position', 'relative');
                }
                this.renderer.setStyle(this.elementRef.nativeElement, 'position', 'absolute');
                this.renderer.setStyle(this.elementRef.nativeElement, 'boxSizing', '');
                this.renderer.setStyle(this.elementRef.nativeElement, 'fontSize', '0px');
            }
        });
        this.onArrowSvgElementChangeEffect();
        this.onContentPositionAndArrowDimensionsChangeEffect();
    }

    /** @ignore */
    private setAnchorOrTriggerRect() {
        this.anchorOrTriggerRect = (
            this.popoverRoot.popoverAnchorDirective() ?? this.popoverRoot.popoverTriggerDirective()
        ).elementRef.nativeElement.getBoundingClientRect();
    }

    /** @ignore */
    private setPosition(position: ConnectedOverlayPositionChange, arrowDimensions: { width: number; height: number }) {
        this.setAnchorOrTriggerRect();
        const posParams = getArrowPositionParams(
            getSideAndAlignFromAllPossibleConnectedPositions(position.connectionPair),
            { width: arrowDimensions.width, height: arrowDimensions.height },
            { width: this.anchorOrTriggerRect.width, height: this.anchorOrTriggerRect.height }
        );

        this.renderer.setStyle(this.elementRef.nativeElement, 'top', posParams.top);
        this.renderer.setStyle(this.elementRef.nativeElement, 'bottom', '');
        this.renderer.setStyle(this.elementRef.nativeElement, 'left', posParams.left);
        this.renderer.setStyle(this.elementRef.nativeElement, 'right', '');
        this.renderer.setStyle(this.elementRef.nativeElement, 'transform', posParams.transform);
        this.renderer.setStyle(this.elementRef.nativeElement, 'transformOrigin', posParams.transformOrigin);
    }

    /** @ignore */
    private onArrowSvgElementChangeEffect() {
        effect(() => {
            const arrowElement = this.arrowSvgElement();
            untracked(() => {
                const currentArrowSvgElement = this.currentArrowSvgElement();
                if (currentArrowSvgElement) {
                    this.renderer.removeChild(this.elementRef.nativeElement, currentArrowSvgElement);
                }
                this.currentArrowSvgElement.set(arrowElement);
                this.renderer.setStyle(this.elementRef.nativeElement, 'width', `${this.width()}px`);
                this.renderer.setStyle(this.elementRef.nativeElement, 'height', `${this.height()}px`);
                this.renderer.appendChild(this.elementRef.nativeElement, this.currentArrowSvgElement());
            });
        });
    }

    /** @ignore */
    private onContentPositionAndArrowDimensionsChangeEffect() {
        effect(() => {
            const position = this.position();
            const arrowDimensions = { width: this.width(), height: this.height() };
            untracked(() => {
                if (!position) {
                    return;
                }
                this.setPosition(position, arrowDimensions);
            });
        });
    }
}



# ./popover/src/popover-trigger.directive.ts

import { CdkOverlayOrigin } from '@angular/cdk/overlay';
import { computed, Directive, ElementRef, inject } from '@angular/core';
import { injectPopoverRoot } from './popover-root.inject';

@Directive({
    selector: '[rdxPopoverTrigger]',
    hostDirectives: [CdkOverlayOrigin],
    host: {
        type: 'button',
        '[attr.id]': 'name()',
        '[attr.aria-haspopup]': '"dialog"',
        '[attr.aria-expanded]': 'popoverRoot.isOpen()',
        '[attr.aria-controls]': 'popoverRoot.popoverContentDirective().name()',
        '[attr.data-state]': 'popoverRoot.state()',
        '(click)': 'click()'
    }
})
export class RdxPopoverTriggerDirective {
    /** @ignore */
    protected readonly popoverRoot = injectPopoverRoot();
    /** @ignore */
    readonly elementRef = inject<ElementRef<HTMLElement>>(ElementRef);
    /** @ignore */
    readonly overlayOrigin = inject(CdkOverlayOrigin);

    /** @ignore */
    readonly name = computed(() => `rdx-popover-trigger-${this.popoverRoot.uniqueId()}`);

    /** @ignore */
    protected click(): void {
        this.popoverRoot.handleToggle();
    }
}



# ./popover/src/popover-anchor.directive.ts

import { CdkOverlayOrigin } from '@angular/cdk/overlay';
import { computed, Directive, ElementRef, forwardRef, inject } from '@angular/core';
import { injectDocument } from '@radix-ng/primitives/core';
import { RdxPopoverAnchorToken } from './popover-anchor.token';
import { RdxPopoverRootDirective } from './popover-root.directive';
import { injectPopoverRoot } from './popover-root.inject';

@Directive({
    selector: '[rdxPopoverAnchor]',
    exportAs: 'rdxPopoverAnchor',
    hostDirectives: [CdkOverlayOrigin],
    host: {
        type: 'button',
        '[attr.id]': 'name()',
        '[attr.aria-haspopup]': '"dialog"',
        '(click)': 'click()'
    },
    providers: [
        {
            provide: RdxPopoverAnchorToken,
            useExisting: forwardRef(() => RdxPopoverAnchorDirective)
        }
    ]
})
export class RdxPopoverAnchorDirective {
    /**
     * @ignore
     * If outside the root then null, otherwise the root directive - with optional `true` passed in as the first param.
     * If outside the root and non-null value that means the html structure is wrong - popover inside popover.
     * */
    protected popoverRoot = injectPopoverRoot(true);
    /** @ignore */
    readonly elementRef = inject(ElementRef);
    /** @ignore */
    readonly overlayOrigin = inject(CdkOverlayOrigin);
    /** @ignore */
    readonly document = injectDocument();

    /** @ignore */
    readonly name = computed(() => `rdx-popover-external-anchor-${this.popoverRoot?.uniqueId()}`);

    /** @ignore */
    click(): void {
        this.emitOutsideClick();
    }

    /** @ignore */
    setPopoverRoot(popoverRoot: RdxPopoverRootDirective) {
        this.popoverRoot = popoverRoot;
    }

    private emitOutsideClick() {
        if (
            !this.popoverRoot?.isOpen() ||
            this.popoverRoot?.popoverContentDirective().onOverlayOutsideClickDisabled()
        ) {
            return;
        }
        const clickEvent = new MouseEvent('click', {
            view: this.document.defaultView,
            bubbles: true,
            cancelable: true,
            relatedTarget: this.elementRef.nativeElement
        });
        this.popoverRoot?.popoverTriggerDirective().elementRef.nativeElement.dispatchEvent(clickEvent);
    }
}



# ./popover/src/popover-root.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import {
    afterNextRender,
    booleanAttribute,
    computed,
    contentChild,
    DestroyRef,
    Directive,
    effect,
    inject,
    input,
    signal,
    untracked,
    ViewContainerRef
} from '@angular/core';
import { RdxPopoverAnchorDirective } from './popover-anchor.directive';
import { RdxPopoverAnchorToken } from './popover-anchor.token';
import { RdxPopoverArrowToken } from './popover-arrow.token';
import { RdxPopoverCloseToken } from './popover-close.token';
import { RdxPopoverContentAttributesToken } from './popover-content-attributes.token';
import { RdxPopoverContentDirective } from './popover-content.directive';
import { RdxPopoverTriggerDirective } from './popover-trigger.directive';
import { RdxPopoverAnimationStatus, RdxPopoverAttachDetachEvent, RdxPopoverState } from './popover.types';
import { injectRdxCdkEventService } from './utils/cdk-event.service';

let nextId = 0;

@Directive({
    selector: '[rdxPopoverRoot]',
    exportAs: 'rdxPopoverRoot'
})
export class RdxPopoverRootDirective {
    /** @ignore */
    readonly uniqueId = signal(++nextId);
    /** @ignore */
    readonly name = computed(() => `rdx-popover-root-${this.uniqueId()}`);

    /**
     * @description The anchor directive that comes form outside the popover root
     * @default undefined
     */
    readonly anchor = input<RdxPopoverAnchorDirective | undefined>(void 0);
    /**
     * @description The open state of the popover when it is initially rendered. Use when you do not need to control its open state.
     * @default false
     */
    readonly defaultOpen = input<boolean, BooleanInput>(false, { transform: booleanAttribute });
    /**
     * @description The controlled state of the popover. `open` input take precedence of `defaultOpen` input.
     * @default undefined
     */
    readonly open = input<boolean | undefined, BooleanInput>(void 0, { transform: booleanAttribute });
    /**
     * @description Whether to control the state of the popover from external. Use in conjunction with `open` input.
     * @default undefined
     */
    readonly externalControl = input<boolean | undefined, BooleanInput>(void 0, { transform: booleanAttribute });
    /**
     * @description Whether to take into account CSS opening/closing animations.
     * @default false
     */
    readonly cssAnimation = input<boolean, BooleanInput>(false, { transform: booleanAttribute });
    /**
     * @description Whether to take into account CSS opening animations. `cssAnimation` input must be set to 'true'
     * @default false
     */
    readonly cssOpeningAnimation = input<boolean, BooleanInput>(false, { transform: booleanAttribute });
    /**
     * @description Whether to take into account CSS closing animations. `cssAnimation` input must be set to 'true'
     * @default false
     */
    readonly cssClosingAnimation = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /** @ignore */
    readonly cssAnimationStatus = signal<RdxPopoverAnimationStatus | null>(null);

    /** @ignore */
    readonly popoverContentDirective = contentChild.required(RdxPopoverContentDirective);
    /** @ignore */
    readonly popoverTriggerDirective = contentChild.required(RdxPopoverTriggerDirective);
    /** @ignore */
    readonly popoverArrowDirective = contentChild(RdxPopoverArrowToken);
    /** @ignore */
    readonly popoverCloseDirective = contentChild(RdxPopoverCloseToken);
    /** @ignore */
    readonly popoverContentAttributesComponent = contentChild(RdxPopoverContentAttributesToken);
    /** @ignore */
    private readonly internalPopoverAnchorDirective = contentChild(RdxPopoverAnchorToken);

    /** @ignore */
    readonly viewContainerRef = inject(ViewContainerRef);
    /** @ignore */
    readonly rdxCdkEventService = injectRdxCdkEventService();
    /** @ignore */
    readonly destroyRef = inject(DestroyRef);

    /** @ignore */
    readonly state = signal(RdxPopoverState.CLOSED);

    /** @ignore */
    readonly attachDetachEvent = signal(RdxPopoverAttachDetachEvent.DETACH);

    /** @ignore */
    private readonly isFirstDefaultOpen = signal(false);

    /** @ignore */
    readonly popoverAnchorDirective = computed(() => this.internalPopoverAnchorDirective() ?? this.anchor());

    constructor() {
        this.rdxCdkEventService?.registerPrimitive(this);
        this.destroyRef.onDestroy(() => this.rdxCdkEventService?.deregisterPrimitive(this));
        this.onStateChangeEffect();
        this.onCssAnimationStatusChangeChangeEffect();
        this.onOpenChangeEffect();
        this.onIsFirstDefaultOpenChangeEffect();
        this.onAnchorChangeEffect();
        this.emitOpenOrClosedEventEffect();
        afterNextRender({
            write: () => {
                if (this.defaultOpen() && !this.open()) {
                    this.isFirstDefaultOpen.set(true);
                }
            }
        });
    }

    /** @ignore */
    getAnimationParamsSnapshot() {
        return {
            cssAnimation: this.cssAnimation(),
            cssOpeningAnimation: this.cssOpeningAnimation(),
            cssClosingAnimation: this.cssClosingAnimation(),
            cssAnimationStatus: this.cssAnimationStatus(),
            attachDetachEvent: this.attachDetachEvent(),
            state: this.state(),
            canEmitOnOpenOrOnClosed: this.canEmitOnOpenOrOnClosed()
        };
    }

    /** @ignore */
    controlledExternally() {
        return this.externalControl;
    }

    /** @ignore */
    firstDefaultOpen() {
        return this.isFirstDefaultOpen();
    }

    /** @ignore */
    handleOpen(): void {
        if (this.externalControl()) {
            return;
        }
        this.setState(RdxPopoverState.OPEN);
    }

    /** @ignore */
    handleClose(): void {
        if (this.isFirstDefaultOpen()) {
            this.isFirstDefaultOpen.set(false);
        }
        if (this.externalControl()) {
            return;
        }
        this.setState(RdxPopoverState.CLOSED);
    }

    /** @ignore */
    handleToggle(): void {
        if (this.externalControl()) {
            return;
        }
        this.isOpen() ? this.handleClose() : this.handleOpen();
    }

    /** @ignore */
    isOpen(state?: RdxPopoverState) {
        return (state ?? this.state()) === RdxPopoverState.OPEN;
    }

    /** @ignore */
    private setState(state = RdxPopoverState.CLOSED): void {
        if (state === this.state()) {
            return;
        }
        this.state.set(state);
    }

    /** @ignore */
    private openContent(): void {
        this.popoverContentDirective().open();
        if (!this.cssAnimation() || !this.cssOpeningAnimation()) {
            this.cssAnimationStatus.set(null);
        }
    }

    /** @ignore */
    private closeContent(): void {
        this.popoverContentDirective().close();
        if (!this.cssAnimation() || !this.cssClosingAnimation()) {
            this.cssAnimationStatus.set(null);
        }
    }

    /** @ignore */
    private emitOnOpen(): void {
        this.popoverContentDirective().onOpen.emit();
    }

    /** @ignore */
    private emitOnClosed(): void {
        this.popoverContentDirective().onClosed.emit();
    }

    /** @ignore */
    private ifOpenOrCloseWithoutAnimations(state: RdxPopoverState) {
        return (
            !this.popoverContentAttributesComponent() ||
            !this.cssAnimation() ||
            (this.cssAnimation() && !this.cssClosingAnimation() && state === RdxPopoverState.CLOSED) ||
            (this.cssAnimation() && !this.cssOpeningAnimation() && state === RdxPopoverState.OPEN) ||
            // !this.cssAnimationStatus() ||
            (this.cssOpeningAnimation() &&
                state === RdxPopoverState.OPEN &&
                [RdxPopoverAnimationStatus.OPEN_STARTED].includes(this.cssAnimationStatus()!)) ||
            (this.cssClosingAnimation() &&
                state === RdxPopoverState.CLOSED &&
                [RdxPopoverAnimationStatus.CLOSED_STARTED].includes(this.cssAnimationStatus()!))
        );
    }

    /** @ignore */
    private ifOpenOrCloseWithAnimations(cssAnimationStatus: RdxPopoverAnimationStatus | null) {
        return (
            this.popoverContentAttributesComponent() &&
            this.cssAnimation() &&
            cssAnimationStatus &&
            ((this.cssOpeningAnimation() &&
                this.state() === RdxPopoverState.OPEN &&
                [RdxPopoverAnimationStatus.OPEN_ENDED].includes(cssAnimationStatus)) ||
                (this.cssClosingAnimation() &&
                    this.state() === RdxPopoverState.CLOSED &&
                    [RdxPopoverAnimationStatus.CLOSED_ENDED].includes(cssAnimationStatus)))
        );
    }

    /** @ignore */
    private openOrClose(state: RdxPopoverState) {
        const isOpen = this.isOpen(state);
        isOpen ? this.openContent() : this.closeContent();
    }

    /** @ignore */
    private emitOnOpenOrOnClosed(state: RdxPopoverState) {
        this.isOpen(state)
            ? this.attachDetachEvent() === RdxPopoverAttachDetachEvent.ATTACH && this.emitOnOpen()
            : this.attachDetachEvent() === RdxPopoverAttachDetachEvent.DETACH && this.emitOnClosed();
    }

    /** @ignore */
    private canEmitOnOpenOrOnClosed() {
        return (
            !this.cssAnimation() ||
            (!this.cssOpeningAnimation() && this.state() === RdxPopoverState.OPEN) ||
            (this.cssOpeningAnimation() &&
                this.state() === RdxPopoverState.OPEN &&
                this.cssAnimationStatus() === RdxPopoverAnimationStatus.OPEN_ENDED) ||
            (!this.cssClosingAnimation() && this.state() === RdxPopoverState.CLOSED) ||
            (this.cssClosingAnimation() &&
                this.state() === RdxPopoverState.CLOSED &&
                this.cssAnimationStatus() === RdxPopoverAnimationStatus.CLOSED_ENDED)
        );
    }

    /** @ignore */
    private onStateChangeEffect() {
        let isFirst = true;
        effect(() => {
            const state = this.state();
            untracked(() => {
                if (isFirst) {
                    isFirst = false;
                    return;
                }
                if (!this.ifOpenOrCloseWithoutAnimations(state)) {
                    return;
                }
                this.openOrClose(state);
            });
        }, {});
    }

    /** @ignore */
    private onCssAnimationStatusChangeChangeEffect() {
        let isFirst = true;
        effect(() => {
            const cssAnimationStatus = this.cssAnimationStatus();
            untracked(() => {
                if (isFirst) {
                    isFirst = false;
                    return;
                }
                if (!this.ifOpenOrCloseWithAnimations(cssAnimationStatus)) {
                    return;
                }
                this.openOrClose(this.state());
            });
        });
    }

    /** @ignore */
    private emitOpenOrClosedEventEffect() {
        let isFirst = true;
        effect(() => {
            this.attachDetachEvent();
            this.cssAnimationStatus();
            untracked(() => {
                if (isFirst) {
                    isFirst = false;
                    return;
                }
                const canEmitOpenClose = untracked(() => this.canEmitOnOpenOrOnClosed());
                if (!canEmitOpenClose) {
                    return;
                }
                this.emitOnOpenOrOnClosed(this.state());
            });
        });
    }

    /** @ignore */
    private onOpenChangeEffect() {
        effect(() => {
            const open = this.open();
            untracked(() => {
                this.setState(open ? RdxPopoverState.OPEN : RdxPopoverState.CLOSED);
            });
        });
    }

    /** @ignore */
    private onIsFirstDefaultOpenChangeEffect() {
        const effectRef = effect(() => {
            const defaultOpen = this.defaultOpen();
            untracked(() => {
                if (!defaultOpen || this.open()) {
                    effectRef.destroy();
                    return;
                }
                this.handleOpen();
            });
        });
    }

    /** @ignore */
    private onAnchorChangeEffect = () => {
        effect(() => {
            const anchor = this.anchor();
            untracked(() => {
                if (anchor) {
                    anchor.setPopoverRoot(this);
                }
            });
        });
    };
}



# ./popover/src/popover-close.token.ts

import { InjectionToken } from '@angular/core';
import { RdxPopoverCloseDirective } from './popover-close.directive';

export const RdxPopoverCloseToken = new InjectionToken<RdxPopoverCloseDirective>('RdxPopoverCloseToken');



# ./popover/src/popover-content-attributes.token.ts

import { InjectionToken } from '@angular/core';
import { RdxPopoverContentAttributesComponent } from './popover-content-attributes.component';

export const RdxPopoverContentAttributesToken = new InjectionToken<RdxPopoverContentAttributesComponent>(
    'RdxPopoverContentAttributesToken'
);



# ./presence/__test__/presence.spec.ts

import { NgZone } from '@angular/core';
import { ComponentFixture, fakeAsync, TestBed, tick } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { PresenceComponent } from './presence-test.component';

describe('presence', () => {
    let component: PresenceComponent;
    let fixture: ComponentFixture<PresenceComponent>;
    let zone: NgZone;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [PresenceComponent],
            providers: [{ provide: NgZone, useValue: new NgZone({ enableLongStackTrace: false }) }]
        }).compileComponents();

        fixture = TestBed.createComponent(PresenceComponent);
        component = fixture.componentInstance;
        zone = TestBed.inject(NgZone);

        fixture.detectChanges(); // triggers ngOnInit
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });

    it('should initialize element and context correctly', () => {
        const element = fixture.debugElement.query(By.css('div')).nativeElement;

        const context = component.getContext();

        expect(component['element']).toBe(element);
        expect(context).toEqual({ direction: 'show', dimension: 'height', maxSize: '0px' });
    });

    it('should complete animation correctly', fakeAsync(() => {
        const element = fixture.debugElement.query(By.css('div')).nativeElement;

        zone.runOutsideAngular(() => {
            element.dispatchEvent(new Event('transitionend'));
        });

        tick(600);
        fixture.detectChanges();

        expect(element.classList.contains('collapsing')).toBe(false);
        expect(element.classList.contains('show')).toBe(true);
    }));
});



# ./presence/__test__/presence-test.component.ts

import { Component, ElementRef, NgZone, OnInit } from '@angular/core';
import { usePresence } from '../src/presence';
import { CollapseContext, transitionCollapsing } from '../src/transitions/transition.collapse';

@Component({
    selector: 'app-presence',
    template: `
        <div #element>Presence Component</div>
    `,
    styles: [
        `
            .collapse {
                transition: height 0.5s ease-in-out;
            }
            .collapsing {
                height: 0px;
            }
            .show {
                height: auto;
            }
        `

    ]
})
export class PresenceComponent implements OnInit {
    private context: CollapseContext = {
        direction: 'show',
        dimension: 'height'
    };
    private element!: HTMLElement;

    constructor(
        private zone: NgZone,
        private elRef: ElementRef
    ) {}

    ngOnInit(): void {
        this.element = this.elRef.nativeElement.querySelector('div');
        const options = {
            context: this.context,
            animation: true,
            state: 'stop' as const
        };

        usePresence(this.zone, this.element, transitionCollapsing, options).subscribe();
    }

    getContext(): CollapseContext {
        return this.context;
    }
}



# ./presence/index.ts

export * from './src/presence';
export * from './src/transitions/transition.collapse';
export * from './src/transitions/transition.toast';
export * from './src/types';



# ./presence/src/utils.ts

import { NgZone } from '@angular/core';
import { Observable } from 'rxjs';

/**
 * Ensures that the observable stream runs inside Angular's NgZone.
 *
 * This function is a higher-order function that takes an observable stream as input and ensures
 * that all emissions, errors, and completion notifications are run inside Angular's NgZone. This
 * is particularly useful for ensuring that change detection is triggered properly in Angular
 * applications.
 *
 * @template T - The type of the items emitted by the observable.
 * @param {NgZone} zone - The Angular zone to control the change detection context.
 * @returns {(source: Observable<T>) => Observable<T>} - A function that takes an observable as input
 * and returns an observable that runs inside Angular's NgZone.
 *
 * Example usage:
 *
 * const source$ = of('some value');
 * const zoned$ = source$.pipe(runInZone(zone));
 * zoned$.subscribe(value => {
 *   console.log('Value:', value);
 * });
 */
function runInZone<T>(zone: NgZone): (source: Observable<T>) => Observable<T> {
    return (source: Observable<T>) =>
        new Observable((observer) =>
            source.subscribe({
                next: (value) => zone.run(() => observer.next(value)),
                error: (err) => zone.run(() => observer.error(err)),
                complete: () => zone.run(() => observer.complete())
            })
        );
}

/**
 * Calculates the total transition duration in milliseconds for a given HTML element.
 *
 * This function retrieves the computed style of the specified element and extracts the
 * transition duration and delay properties. It then converts these values from seconds
 * to milliseconds and returns their sum, representing the total transition duration.
 *
 * @param {HTMLElement} element - The HTML element for which to calculate the transition duration.
 * @returns {number} - The total transition duration in milliseconds.
 *
 * Example usage:
 *
 * const durationMs = getTransitionDurationMs(element);
 * console.log(`Transition duration: ${durationMs} ms`);
 */
function getTransitionDurationMs(element: HTMLElement): number {
    const { transitionDelay, transitionDuration } = window.getComputedStyle(element);
    const transitionDelaySec = parseFloat(transitionDelay);
    const transitionDurationSec = parseFloat(transitionDuration);

    return (transitionDelaySec + transitionDurationSec) * 1000;
}

export { getTransitionDurationMs, runInZone };

export function triggerReflow(element: HTMLElement) {
    return (element || document.body).getBoundingClientRect();
}



# ./presence/src/types.ts

import { Subject } from 'rxjs';

type TransitionOptions<T> = {
    context?: T;
    animation: boolean;
    state?: 'continue' | 'stop';
    transitionTimerDelayMs?: number;
};

type TransitionContext<T> = {
    transition$: Subject<any>;
    complete: () => void;
    context: T;
};

type TransitionStartFn<T = any> = (element: HTMLElement, animation: boolean, context: T) => TransitionEndFn | void;

type TransitionEndFn = () => void;

export { TransitionContext, TransitionEndFn, TransitionOptions, TransitionStartFn };



# ./presence/src/presence.ts

import { NgZone } from '@angular/core';
import { EMPTY, endWith, filter, fromEvent, Observable, of, race, Subject, takeUntil, timer } from 'rxjs';
import { TransitionContext, TransitionEndFn, TransitionOptions, TransitionStartFn } from './types';
import { getTransitionDurationMs, runInZone } from './utils';

const noopFn: TransitionEndFn = () => {
    /* Noop */
};
const TransitionsMap = new Map<HTMLElement, TransitionContext<any>>();

/**
 * Manages the presence of an element with optional transition animation.
 *
 * @template T - The type of the context object used in the transition.
 * @param {NgZone} zone - The Angular zone to control the change detection context.
 * @param {HTMLElement} element - The target HTML element to apply the transition.
 * @param {TransitionOptions<T>} options - Options for controlling the transition behavior.
 *   @param {T} [options.context] - An optional context object to pass through the transition.
 *   @param {boolean} options.animation - A flag indicating if the transition should be animated.
 *   @param {'start' | 'continue' | 'stop'} options.state - The desired state of the transition.
 * @param {TransitionStartFn<T>} startFn - A function to start the transition.
 * @returns {Observable<void>} - An observable that emits when the transition completes.
 *
 * The `usePresence` function is designed to manage the presence and visibility of an HTML element,
 * optionally applying a transition animation. It utilizes Angular's NgZone for efficient change
 * detection management and allows for different states of transitions ('start', 'continue', 'stop').
 * The function takes a start function to handle the beginning of the transition and returns an
 * observable that completes when the transition ends.
 *
 * Example usage:
 *
 * const options: TransitionOptions<MyContext> = {
 *   context: {}, // your context object
 *   animation: true,
 *   state: 'start'
 * };
 *
 * const startFn: TransitionStartFn<MyContext> = (el, animation, context) => {
 *   el.classList.add('active');
 *   return () => el.classList.remove('active');
 * };
 *
 * usePresence(zone, element, startFn, options).subscribe(() => {
 *   console.log('Transition completed');
 * });
 */
const usePresence = <T>(
    zone: NgZone,
    element: HTMLElement,
    startFn: TransitionStartFn<T>,
    options: TransitionOptions<T>
): Observable<void> => {
    let context = options.context || <T>{};

    const transitionTimerDelayMs = options.transitionTimerDelayMs ?? 5;
    const state = options.state ?? 'stop';

    const running = TransitionsMap.get(element);

    if (running) {
        switch (state) {
            case 'continue':
                return EMPTY;
            case 'stop':
                zone.run(() => running.transition$.complete());
                context = { ...running.context, ...context };
                TransitionsMap.delete(element);
                break;
        }
    }
    const endFn = startFn(element, options.animation, context) || noopFn;

    if (!options.animation || window.getComputedStyle(element).transitionProperty === 'none') {
        zone.run(() => endFn());
        return of(undefined).pipe(runInZone(zone));
    }

    const transition$ = new Subject<void>();
    const finishTransition$ = new Subject<void>();
    const stop$ = transition$.pipe(endWith(true));

    TransitionsMap.set(element, {
        transition$,
        complete: () => {
            finishTransition$.next();
            finishTransition$.complete();
        },
        context
    });

    const transitionDurationMs = getTransitionDurationMs(element);

    zone.runOutsideAngular(() => {
        const transitionEnd$ = fromEvent<TransitionEvent>(element, 'transitionend').pipe(
            filter(({ target }) => target === element),
            takeUntil(stop$)
        );
        const timer$ = timer(transitionDurationMs + transitionTimerDelayMs).pipe(takeUntil(stop$));

        race(timer$, transitionEnd$, finishTransition$)
            .pipe(takeUntil(stop$))
            .subscribe(() => {
                TransitionsMap.delete(element);
                zone.run(() => {
                    endFn();
                    transition$.next();
                    transition$.complete();
                });
            });
    });

    return transition$.asObservable();
};

const completeTransition = (element: HTMLElement) => {
    TransitionsMap.get(element)?.complete();
};

export { completeTransition, usePresence };



# ./presence/src/transitions/transition.collapse.ts

import { TransitionStartFn } from '../types';
import { triggerReflow } from '../utils';

export type CollapseContext = {
    direction: 'show' | 'hide';
    dimension: 'width' | 'height';
    maxSize?: string;
};

// Define constants for class names
const COLLAPSE_CLASS = 'collapse';
const COLLAPSING_CLASS = 'collapsing';
const SHOW_CLASS = 'show';
/**
 * Function to handle the start of a collapsing transition.
 *
 * @param element - The HTML element to animate.
 * @param animation - Whether to use animation or not.
 * @param context - The context containing direction and dimension information.
 * @returns A function to clean up the animation.
 */
export const transitionCollapsing: TransitionStartFn<CollapseContext> = (
    element: HTMLElement,
    animation: boolean,
    context: CollapseContext
) => {
    const { direction, dimension } = context;
    let { maxSize } = context;
    const { classList } = element;

    /**
     * Sets initial classes based on the direction.
     */
    function setInitialClasses() {
        classList.add(COLLAPSE_CLASS);
        if (direction === 'show') {
            classList.add(SHOW_CLASS);
        } else {
            classList.remove(SHOW_CLASS);
        }
    }

    if (!animation) {
        setInitialClasses();
        return;
    }

    if (!maxSize) {
        maxSize = measureCollapsingElementDimensionPx(element, dimension);
        context.maxSize = maxSize;

        // Fix the height before starting the animation
        element.style[dimension] = direction !== 'show' ? maxSize : '0px';

        classList.remove(COLLAPSE_CLASS, COLLAPSING_CLASS, 'show');

        triggerReflow(element);

        // Start the animation
        classList.add(COLLAPSING_CLASS);
    }

    element.style[dimension] = direction === 'show' ? maxSize : '0px';

    return () => {
        setInitialClasses();
        classList.remove(COLLAPSING_CLASS);
        element.style[dimension] = '';
    };
};

/**
 * Measures the dimension of the collapsing element in pixels.
 *
 * @param element - The HTML element to measure.
 * @param dimension - The dimension ('width' or 'height') to measure.
 * @returns The size of the dimension in pixels.
 */
function measureCollapsingElementDimensionPx(element: HTMLElement, dimension: 'width' | 'height'): string {
    // SSR fix
    if (typeof navigator === 'undefined') {
        return '0px';
    }

    const { classList } = element;
    const hasShownClass = classList.contains(SHOW_CLASS);
    if (!hasShownClass) {
        classList.add(SHOW_CLASS);
    }

    element.style[dimension] = '';
    const dimensionSize = element.getBoundingClientRect()[dimension] + 'px';

    if (!hasShownClass) {
        classList.remove(SHOW_CLASS);
    }

    return dimensionSize;
}



# ./presence/src/transitions/transition.toast.ts

import { TransitionStartFn } from '../types';
import { triggerReflow } from '../utils';

export const toastFadeInTransition: TransitionStartFn = (element: HTMLElement, animation: boolean) => {
    const { classList } = element;

    if (animation) {
        classList.add('fade');
    } else {
        classList.add('show');
        return;
    }

    triggerReflow(element);
    classList.add('show', 'showing');

    return () => {
        classList.remove('showing');
    };
};

export const toastFadeOutTransition: TransitionStartFn = ({ classList }: HTMLElement) => {
    classList.add('showing');
    return () => {
        classList.remove('show', 'showing');
    };
};



# ./button/src/button.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, computed, Directive, input } from '@angular/core';

export type ButtonType = 'button' | 'submit' | 'reset';

let nextId = 0;

@Directive({
    selector: '[rdxButton]',
    standalone: true,
    host: {
        '[attr.id]': 'id()',
        '[attr.type]': 'type()',
        '[attr.tabindex]': 'tabIndex()',

        '[attr.aria-disabled]': 'ariaDisabled()',
        '[attr.aria-pressed]': 'isActive()',

        '[attr.disabled]': 'attrDisabled()'
    }
})
export abstract class RdxButtonDirective {
    readonly id = input<string>(`rdx-button-${nextId++}`);

    readonly type = input<ButtonType>('button');

    readonly active = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    readonly isLoading = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    readonly #_disabled = computed(() => this.disabled());

    readonly ariaDisabled = computed(() => {
        return this.#_disabled() ? true : undefined;
    });

    readonly attrDisabled = computed(() => {
        return this.#_disabled() ? '' : undefined;
    });

    readonly tabIndex = computed(() => {
        return this.#_disabled() ? '-1' : undefined;
    });

    readonly isActive = computed(() => {
        return <boolean>this.active() || undefined;
    });
}



# ./package.json

{
    "name": "@radix-ng/primitives",
    "version": "0.32.4",
    "license": "MIT",
    "publishConfig": {
        "access": "public"
    },
    "repository": {
        "type": "git",
        "url": "https://github.com/radix-ng/primitives.git",
        "directory": "packages/primitives"
    },
    "keywords": [
        "components",
        "ui",
        "angular",
        "radix-ng",
        "headless"
    ],
    "peerDependencies": {
        "@angular/core": "^19.1.0",
        "@angular/cdk": "^19.1.0"
    },
    "devDependencies": {
        "@angular-devkit/schematics": "^19.1.0"
    },
    "schematics": "./schematics/collection.json",
    "sideEffects": false,
    "ng-add": {
        "save": "true"
    }
}



# ./collapsible/README.md

# @radix-ng/primitives/collapsible



# ./collapsible/__tests__/collapsible-content.directive.spec.ts

import { Component } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RdxCollapsibleContentDirective } from '../src/collapsible-content.directive';
import { RdxCollapsibleRootDirective } from '../src/collapsible-root.directive';

@Component({
    selector: 'rdx-collapsible-mock-trigger',
    standalone: true,
    imports: [RdxCollapsibleRootDirective, RdxCollapsibleContentDirective],
    template: `
        <div CollapsibleRoot>
            <div CollapsibleContent>Content</div>
        </div>
    `
})
class RdxCollapsibleMockComponent {}

describe('RdxCollapsibleContentDirective', () => {
    let component: RdxCollapsibleMockComponent;
    let fixture: ComponentFixture<RdxCollapsibleMockComponent>;

    beforeEach(() => {
        fixture = TestBed.createComponent(RdxCollapsibleMockComponent);
        component = fixture.componentInstance;
    });

    it('should create an instance', () => {
        expect(component).toBeTruthy();
    });
});



# ./collapsible/__tests__/collapsible-trigger.directive.spec.ts

import { Component } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RdxCollapsibleRootDirective } from '../src/collapsible-root.directive';
import { RdxCollapsibleTriggerDirective } from '../src/collapsible-trigger.directive';

@Component({
    selector: 'rdx-collapsible-mock-trigger',
    standalone: true,
    imports: [RdxCollapsibleRootDirective, RdxCollapsibleTriggerDirective],
    template: `
        <div CollapsibleRoot>
            <button CollapsibleTrigger>Trigger</button>
        </div>
    `
})
class RdxCollapsibleMockComponent {}

describe('RdxCollapsibleTriggerDirective', () => {
    let component: RdxCollapsibleMockComponent;
    let fixture: ComponentFixture<RdxCollapsibleMockComponent>;

    beforeEach(() => {
        fixture = TestBed.createComponent(RdxCollapsibleMockComponent);
        component = fixture.componentInstance;
    });

    it('should create an instance', () => {
        expect(component).toBeTruthy();
    });
});



# ./collapsible/__tests__/collapsible-root.directive.spec.ts

import { Component } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RdxCollapsibleRootDirective } from '../src/collapsible-root.directive';

@Component({
    selector: 'rdx-collapsible-mock-trigger',
    standalone: true,
    imports: [RdxCollapsibleRootDirective],
    template: `
        <div CollapsibleRoot></div>
    `
})
class RdxCollapsibleMockComponent {}

describe('RdxCollapsibleRootDirective', () => {
    let component: RdxCollapsibleMockComponent;
    let fixture: ComponentFixture<RdxCollapsibleMockComponent>;

    beforeEach(() => {
        fixture = TestBed.createComponent(RdxCollapsibleMockComponent);
        component = fixture.componentInstance;
    });

    it('should create an instance', () => {
        expect(component).toBeTruthy();
    });
});



# ./collapsible/index.ts

export * from './src/collapsible-content.directive';
export * from './src/collapsible-root.directive';
export * from './src/collapsible-trigger.directive';



# ./collapsible/src/collapsible-trigger.directive.ts

import { Directive } from '@angular/core';
import { injectCollapsible, RdxCollapsibleState } from './collapsible-root.directive';

@Directive({
    selector: '[rdxCollapsibleTrigger]',
    host: {
        '[attr.data-state]': 'getState()',
        '[attr.data-disabled]': 'getDisabled()',
        '[attr.aria-expanded]': 'getState() === "open" ? "true" : "false"',
        '[disabled]': 'getDisabled()',

        '(click)': 'onOpenToggle()'
    }
})
export class RdxCollapsibleTriggerDirective {
    /**
     * Reference to CollapsibleRoot
     * @private
     * @ignore
     */
    private readonly collapsible = injectCollapsible();

    /**
     * Called on trigger clicked
     */
    onOpenToggle(): void {
        this.collapsible.setOpen();
    }

    /**
     * Returns current directive state (open | closed)
     * @ignore
     */
    getState(): RdxCollapsibleState {
        return this.collapsible.getState();
    }

    /**
     * Returns current trigger state
     * @ignore
     */
    getDisabled(): string | undefined {
        return this.collapsible.disabled() ? 'disabled' : undefined;
    }
}



# ./collapsible/src/collapsible-content.directive.ts

import { Directive, ElementRef, inject } from '@angular/core';
import { RdxCollapsibleContentToken } from './collapsible-content.token';
import { RdxCollapsibleRootDirective } from './collapsible-root.directive';

@Directive({
    selector: '[rdxCollapsibleContent]',
    providers: [
        {
            provide: RdxCollapsibleContentToken,
            useExisting: RdxCollapsibleContentDirective
        }
    ],
    host: {
        '[attr.data-state]': 'collapsible.getState()',
        '[attr.data-disabled]': 'getDisabled()'
    }
})
export class RdxCollapsibleContentDirective {
    protected readonly collapsible = inject(RdxCollapsibleRootDirective);

    /**
     * Reference to CollapsibleContent host element
     * @ignore
     */
    readonly elementRef = inject<ElementRef<HTMLElement>>(ElementRef);

    getDisabled(): string | undefined {
        return this.collapsible.disabled() ? 'disabled' : undefined;
    }
}



# ./collapsible/src/collapsible-root.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, contentChild, Directive, inject, InjectionToken, input, Input, output } from '@angular/core';
import { asyncScheduler } from 'rxjs';
import { RdxCollapsibleContentToken } from './collapsible-content.token';

const RdxCollapsibleRootToken = new InjectionToken<RdxCollapsibleRootDirective>('RdxCollapsibleRootToken');

export function injectCollapsible(): RdxCollapsibleRootDirective {
    return inject(RdxCollapsibleRootDirective);
}

export type RdxCollapsibleState = 'open' | 'closed';

/**
 * @group Components
 */
@Directive({
    selector: '[rdxCollapsibleRoot]',
    exportAs: 'collapsibleRoot',
    providers: [{ provide: RdxCollapsibleRootToken, useExisting: RdxCollapsibleRootDirective }],
    host: {
        '[attr.data-state]': 'getState()',
        '[attr.data-disabled]': 'disabled() ? "" : undefined'
    }
})
export class RdxCollapsibleRootDirective {
    /**
     * Reference to RdxCollapsibleContent directive
     */
    private readonly contentDirective = contentChild.required(RdxCollapsibleContentToken);

    /**
     * Determines whether a directive is available for interaction.
     * When true, prevents the user from interacting with the collapsible.
     *
     * @group Props
     */
    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * The controlled open state of the collapsible.
     * Sets the state of the directive. `true` - expanded, `false` - collapsed
     *
     * @group Props
     * @defaultValue false
     */
    @Input() set open(value: boolean) {
        if (value !== this._open) {
            this.onOpenChange.emit(value);
        }

        this._open = value;
        this.setPresence();
    }

    get open(): boolean {
        return this._open;
    }

    /**
     * Stores collapsible state
     */
    private _open = false;

    /**
     * Emitted with new value when directive state changed.
     * Event handler called when the open state of the collapsible changes.
     *
     * @group Emits
     */
    readonly onOpenChange = output<boolean>();

    /**
     * Allows to change directive state
     * @param {boolean | undefined} value
     * @ignore
     */
    setOpen(value?: boolean) {
        if (this.disabled()) {
            return;
        }

        if (value === undefined) {
            this.open = !this.open;
        } else {
            this.open = value;
        }

        this.setPresence();
    }

    /**
     * Returns directive state (open | closed)
     * @ignore
     */
    getState(): RdxCollapsibleState {
        return this.open ? 'open' : 'closed';
    }

    /**
     * Returns current directive state
     * @ignore
     */
    isOpen(): boolean {
        return this.open;
    }

    /**
     * Controls visibility of content
     */
    private setPresence(): void {
        if (!this.contentDirective) {
            return;
        }

        if (this.isOpen()) {
            this.contentDirective().elementRef.nativeElement.removeAttribute('hidden');
        } else {
            asyncScheduler.schedule(() => {
                const animations = this.contentDirective().elementRef.nativeElement.getAnimations();

                if (animations === undefined || animations.length === 0) {
                    this.contentDirective().elementRef.nativeElement.setAttribute('hidden', '');
                }
            });
        }
    }
}



# ./collapsible/src/collapsible-content.token.ts

import { InjectionToken } from '@angular/core';
import { RdxCollapsibleContentDirective } from './collapsible-content.directive';

export const RdxCollapsibleContentToken = new InjectionToken<RdxCollapsibleContentDirective>(
    'RdxCollapsibleContentToken'
);



# ./visually-hidden/README.md

# @radix-ng/primitives/visually-hidden

Secondary entry point of `@radix-ng/primitives`. It can be used by importing from `@radix-ng/primitives/visually-hidden`.



# ./visually-hidden/index.ts

export * from './src/visually-hidden-input-bubble.directive';
export * from './src/visually-hidden-input.directive';
export * from './src/visually-hidden.directive';



# ./visually-hidden/src/visually-hidden-input-bubble.directive.ts

import { Directive, effect, ElementRef, inject, input, linkedSignal } from '@angular/core';
import { RdxVisuallyHiddenDirective } from './visually-hidden.directive';

/**
 *
 */
@Directive({
    selector: 'input[rdxVisuallyHiddenInputBubble]',
    hostDirectives: [{ directive: RdxVisuallyHiddenDirective, inputs: ['feature: feature'] }],
    host: {
        '[attr.name]': 'name()',
        '[attr.required]': 'required()',
        '[attr.disabled]': 'disabled()',
        '[attr.checked]': 'checked()',
        '[value]': 'value()',
        '(change)': 'onChange()'
    }
})
export class RdxVisuallyHiddenInputBubbleDirective<T> {
    private readonly elementRef = inject(ElementRef);

    readonly name = input<string>('');
    readonly value = input<T | string | null>();
    readonly checked = input<boolean | undefined>(undefined);
    readonly required = input<boolean | undefined>(undefined);
    readonly disabled = input<boolean | undefined>(undefined);
    readonly feature = input<string>('fully-hidden');

    protected readonly valueEffect = linkedSignal({
        source: this.value,
        computation: (value: NoInfer<string | T | null | undefined>) => value
    });

    constructor() {
        effect(() => {
            this.updateInputValue();
        });
    }

    updateValue(value: string) {
        this.valueEffect.set(value);
    }

    protected onChange() {
        this.updateInputValue();
    }

    private updateInputValue() {
        let valueChanged = false;
        let checkedChanged = false;

        // Check if the value has changed before applying the update
        const currentValue = this.inputElement.value;
        const newValue = String(this.value());

        if (currentValue !== newValue) {
            this.inputElement.value = newValue;
            valueChanged = true;
        }

        if (this.inputElement.type === 'checkbox' || this.inputElement.type === 'radio') {
            const currentChecked = this.inputElement.checked;
            const newChecked = !!this.checked();

            if (currentChecked !== newChecked) {
                this.inputElement.checked = newChecked;
                checkedChanged = true;
            }
        }

        if (valueChanged || checkedChanged) {
            this.dispatchInputEvents();
        }
    }

    private get inputElement() {
        return this.elementRef.nativeElement;
    }

    private dispatchInputEvents() {
        const inputEvent = new Event('input', { bubbles: true });
        const changeEvent = new Event('change', { bubbles: true });

        this.inputElement.dispatchEvent(inputEvent);
        this.inputElement.dispatchEvent(changeEvent);
    }
}



# ./visually-hidden/src/visually-hidden.directive.ts

import { Directive, input, linkedSignal } from '@angular/core';

/**
 *
 * <span rdxVisuallyHidden [feature]="'fully-hidden'">
 *   <ng-content></ng-content>
 * </span>
 *
 * <button (click)="directiveInstance.feature.set('focusable')">Make Focusable</button>
 * <button (click)="directiveInstance.feature.set('fully-hidden')">Hide</button>
 */
@Directive({
    selector: '[rdxVisuallyHidden]',
    host: {
        '[attr.aria-hidden]': 'feature() === "focusable" ? "true" : undefined',
        '[hidden]': 'feature() === "fully-hidden" ? true : undefined',
        '[attr.tabindex]': 'feature() === "fully-hidden" ? "-1" : undefined',
        '[style.position]': '"absolute"',
        '[style.border]': '"0"',
        '[style.display]': 'feature() === "focusable" ? "inline-block" : "none"',
        '[style.width]': '"1px"',
        '[style.height]': '"1px"',
        '[style.padding]': '"0"',
        '[style.margin]': '"-1px"',
        '[style.overflow]': '"hidden"',
        '[style.clip]': '"rect(0, 0, 0, 0)"',
        '[style.clipPath]': '"inset(50%)"',
        '[style.white-space]': '"nowrap"',
        '[style.word-wrap]': '"normal"'
    }
})
export class RdxVisuallyHiddenDirective {
    readonly feature = input<'focusable' | 'fully-hidden'>('focusable');

    protected readonly featureEffect = linkedSignal({
        source: this.feature,
        computation: (feature: 'focusable' | 'fully-hidden') => feature
    });

    updateFeature(feature: 'focusable' | 'fully-hidden') {
        this.featureEffect.set(feature);
    }
}



# ./visually-hidden/src/visually-hidden-input.directive.ts

// Implementation from https://github.com/unovue/radix-vue

import { Directive, ElementRef, OnInit, computed, inject, input } from '@angular/core';
import { RdxVisuallyHiddenInputBubbleDirective } from './visually-hidden-input-bubble.directive';

@Directive({
    selector: '[rdxVisuallyHiddenInput]',
    hostDirectives: [
        {
            directive: RdxVisuallyHiddenInputBubbleDirective,
            inputs: [
                'feature: feature',
                'name: name ',
                'value: value',
                'checked: checked',
                'disabled: disabled',
                'required: required'
            ]
        }
    ]
})
export class RdxVisuallyHiddenInputDirective<T> implements OnInit {
    private readonly elementRef = inject(ElementRef);

    readonly name = input<string>('');
    readonly value = input<T | string>();
    readonly checked = input<boolean | undefined>(undefined);
    readonly required = input<boolean | undefined>(undefined);
    readonly disabled = input<boolean | undefined>(undefined);
    readonly feature = input<'focusable' | 'fully-hidden'>('fully-hidden');

    readonly parsedValue = computed<{ name: string; value: any }[]>(() => {
        const value = this.value();
        const name = this.name();

        if (typeof value === 'string' || typeof value === 'number' || typeof value === 'boolean') {
            return [{ name, value }];
        }

        if (Array.isArray(value)) {
            return value.flatMap((obj, index) => {
                if (typeof obj === 'object') {
                    return Object.entries(obj).map(([key, val]) => ({
                        name: `[${name}][${index}][${key}]`,
                        value: val
                    }));
                } else {
                    return { name: `[${name}][${index}]`, value: obj };
                }
            });
        }

        if (value !== null && typeof value === 'object') {
            return Object.entries(value).map(([key, val]) => ({
                name: `[${name}][${key}]`,
                value: val
            }));
        }

        return [];
    });

    ngOnInit() {
        const parsedValues = this.parsedValue();

        parsedValues.forEach((parsed) => {
            const inputElement = this.elementRef.nativeElement;
            inputElement.setAttribute('name', parsed.name);
            inputElement.setAttribute('value', parsed.value);
        });
    }
}



# ./menu/README.md

# @radix-ng/primitives/menu



# ./menu/index.ts

import { NgModule } from '@angular/core';
import { RdxMenuContentDirective } from './src/menu-content.directive';
import { RdxMenuDirective } from './src/menu-directive';
import { RdxMenuGroupDirective } from './src/menu-group.directive';
import { RdxMenuItemCheckboxDirective } from './src/menu-item-checkbox.directive';
import { RdxMenuItemIndicatorDirective } from './src/menu-item-indicator.directive';
import { RdxMenuItemRadioDirective } from './src/menu-item-radio.directive';
import { RdxMenuItemDirective } from './src/menu-item.directive';
import { RdxMenuLabelDirective } from './src/menu-label.directive';
import { RdxMenuRadioGroupDirective } from './src/menu-radio-group.directive';
import { RdxMenuSeparatorDirective } from './src/menu-separator.directive';
import { RdxMenuTriggerDirective } from './src/menu-trigger.directive';

export * from './src/menu-content.directive';
export * from './src/menu-directive';
export * from './src/menu-group.directive';
export * from './src/menu-item-checkbox.directive';
export * from './src/menu-item-indicator.directive';
export * from './src/menu-item-radio.directive';
export * from './src/menu-item.directive';
export * from './src/menu-label.directive';
export * from './src/menu-radio-group.directive';
export * from './src/menu-separator.directive';
export * from './src/menu-trigger.directive';

export type { RdxMenuAlign, RdxMenuSide } from './src/menu-trigger.directive';

const menuImports = [
    RdxMenuDirective,
    RdxMenuItemCheckboxDirective,
    RdxMenuItemRadioDirective,
    RdxMenuItemIndicatorDirective,
    RdxMenuTriggerDirective,
    RdxMenuGroupDirective,
    RdxMenuRadioGroupDirective,
    RdxMenuItemDirective,
    RdxMenuSeparatorDirective,
    RdxMenuContentDirective,
    RdxMenuLabelDirective
];

@NgModule({
    imports: [...menuImports],
    exports: [...menuImports]
})
export class RdxMenuModule {}



# ./menu/src/menu-radio-group.directive.ts

import { CdkMenuGroup } from '@angular/cdk/menu';
import { Directive } from '@angular/core';

@Directive({
    selector: '[RdxMenuRadioGroup]',
    hostDirectives: [CdkMenuGroup]
})
export class RdxMenuRadioGroupDirective {}



# ./menu/src/menu-directive.ts

import { CdkMenu } from '@angular/cdk/menu';
import { Directive } from '@angular/core';

@Directive({
    selector: '[RdxMenuRoot],[RdxMenuSub]',
    hostDirectives: [CdkMenu]
})
export class RdxMenuDirective {}



# ./menu/src/menu-label.directive.ts

import { Directive } from '@angular/core';

@Directive({
    selector: '[RdxMenuLabel]'
})
export class RdxMenuLabelDirective {}



# ./menu/src/menu-trigger.directive.ts

import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import { CdkMenuTrigger } from '@angular/cdk/menu';
import {
    booleanAttribute,
    computed,
    Directive,
    effect,
    inject,
    input,
    numberAttribute,
    SimpleChange,
    untracked
} from '@angular/core';

export type RdxMenuAlign = 'start' | 'center' | 'end';
export type RdxMenuSide = 'top' | 'right' | 'bottom' | 'left';

@Directive({
    selector: '[RdxMenuTrigger]',
    hostDirectives: [
        {
            directive: CdkMenuTrigger,
            inputs: ['cdkMenuTriggerFor: menuTriggerFor', 'cdkMenuPosition: menuPosition']
        }
    ],
    host: {
        role: 'menuitem',
        '[attr.aria-haspopup]': "'menu'",
        '[attr.aria-expanded]': 'cdkTrigger.isOpen()',
        '[attr.data-state]': "cdkTrigger.isOpen() ? 'open': 'closed'",
        '[attr.data-disabled]': "disabled() ? '' : undefined",

        '(pointerdown)': 'onPointerDown($event)'
    }
})
export class RdxMenuTriggerDirective {
    protected readonly cdkTrigger = inject(CdkMenuTrigger, { host: true });

    readonly menuTriggerFor = input.required();

    /**
     * @description The preferred side of the trigger to render against when open. Will be reversed when collisions occur and avoidCollisions is enabled.
     */
    readonly side = input<RdxMenuSide>();

    readonly align = input<RdxMenuAlign>();

    /**
     * @description The distance in pixels from the trigger.
     */
    readonly sideOffset = input<number, NumberInput>(NaN, {
        transform: numberAttribute
    });

    /**
     * @description An offset in pixels from the "start" or "end" alignment options.
     */
    readonly alignOffset = input<number, NumberInput>(NaN, {
        transform: numberAttribute
    });

    readonly disabled = input<boolean, BooleanInput>(false, {
        transform: booleanAttribute
    });

    private enablePositions = false;

    // TODO
    private readonly positions = computed(() => this.computePositions());

    private computePositions() {
        if (this.align() || this.sideOffset() || this.alignOffset() || this.side()) {
            this.enablePositions = true;
        }

        const side = this.side() || 'bottom';
        const align = this.align() || 'center';
        const sideOffset = this.sideOffset() || 0;
        const alignOffset = this.alignOffset() || 0;

        let originX: 'start' | 'center' | 'end' = 'center';
        let originY: 'top' | 'center' | 'bottom' = 'center';
        let overlayX: 'start' | 'center' | 'end' = 'center';
        let overlayY: 'top' | 'center' | 'bottom' = 'center';
        let offsetX = 0;
        let offsetY = 0;

        switch (side) {
            case 'top':
                originY = 'top';
                overlayY = 'bottom';
                offsetY = -sideOffset;
                break;
            case 'bottom':
                originY = 'bottom';
                overlayY = 'top';
                offsetY = sideOffset;
                break;
            case 'left':
                originX = 'start';
                overlayX = 'end';
                offsetX = -sideOffset;
                break;
            case 'right':
                originX = 'end';
                overlayX = 'start';
                offsetX = sideOffset;
                break;
        }

        switch (align) {
            case 'start':
                if (side === 'top' || side === 'bottom') {
                    originX = 'start';
                    overlayX = 'start';
                    offsetX = alignOffset;
                } else {
                    originY = 'top';
                    overlayY = 'top';
                    offsetY = alignOffset;
                }
                break;
            case 'end':
                if (side === 'top' || side === 'bottom') {
                    originX = 'end';
                    overlayX = 'end';
                    offsetX = -alignOffset;
                } else {
                    originY = 'bottom';
                    overlayY = 'bottom';
                    offsetY = -alignOffset;
                }
                break;
            case 'center':
            default:
                if (side === 'top' || side === 'bottom') {
                    originX = 'center';
                    overlayX = 'center';
                } else {
                    originY = 'center';
                    overlayY = 'center';
                }
                break;
        }

        return {
            originX,
            originY,
            overlayX,
            overlayY,
            offsetX,
            offsetY
        };
    }

    constructor() {
        this.onMenuPositionEffect();
    }

    /** @ignore */
    onPointerDown($event: MouseEvent) {
        // only call handler if it's the left button (mousedown gets triggered by all mouse buttons)
        // but not when the control key is pressed (avoiding MacOS right click)
        if (!this.disabled() && $event.button === 0 && !$event.ctrlKey) {
            /* empty */
            if (!this.cdkTrigger.isOpen()) {
                // prevent trigger focusing when opening
                // this allows the content to be given focus without competition
                $event.preventDefault();
            }
        }
    }

    private onMenuPositionEffect() {
        effect(() => {
            const positions = this.positions();

            untracked(() => {
                if (this.enablePositions) {
                    this.setMenuPositions([positions]);
                }
            });
        });
    }

    private setMenuPositions(positions: CdkMenuTrigger['menuPosition']) {
        const prevMenuPosition = this.cdkTrigger.menuPosition;
        this.cdkTrigger.menuPosition = positions;
        this.fireNgOnChanges('menuPosition', this.cdkTrigger.menuPosition, prevMenuPosition);
    }

    private fireNgOnChanges<K extends keyof CdkMenuTrigger, V extends CdkMenuTrigger[K]>(
        input: K,
        currentValue: V,
        previousValue: V,
        firstChange = false
    ) {
        this.cdkTrigger.ngOnChanges({
            [input]: new SimpleChange(previousValue, currentValue, firstChange)
        });
    }
}



# ./menu/src/menu-group.directive.ts

import { CdkMenuGroup } from '@angular/cdk/menu';
import { Directive } from '@angular/core';

@Directive({
    selector: '[RdxMenuGroup]',
    hostDirectives: [CdkMenuGroup],
    host: {
        role: 'group'
    }
})
export class RdxMenuGroupDirective {}



# ./menu/src/menu-item-indicator.directive.ts

import { Directive, inject } from '@angular/core';
import { RdxMenuItemCheckboxDirective } from './menu-item-checkbox.directive';
import { RdxMenuItemRadioDirective } from './menu-item-radio.directive';
import { getCheckedState, isIndeterminate } from './utils';

@Directive({
    selector: '[RdxMenuItemIndicator]',
    host: {
        '[attr.data-state]': 'getCheckedState(isChecked)',

        '[style.display]': 'isChecked ? "" : "none"'
    }
})
export class RdxMenuItemIndicatorDirective {
    private readonly menuItemRadio = inject(RdxMenuItemRadioDirective, { host: true, optional: true });

    private readonly menuCheckboxItem = inject(RdxMenuItemCheckboxDirective, { host: true, optional: true });

    get isChecked(): boolean {
        if (this.menuItemRadio) {
            return this.menuItemRadio.checked();
        }
        if (this.menuCheckboxItem) {
            return isIndeterminate(this.menuCheckboxItem.checked()) || this.menuCheckboxItem.checked() === true;
        }
        return false;
    }

    protected readonly getCheckedState = getCheckedState;
}



# ./menu/src/menu-content.directive.ts

import { CdkMenu } from '@angular/cdk/menu';
import { Directive } from '@angular/core';

@Directive({
    selector: '[RdxMenuContent]',
    hostDirectives: [CdkMenu],
    host: {
        role: 'menu',
        '[attr.aria-orientation]': '"vertical"'
    }
})
export class RdxMenuContentDirective {}



# ./menu/src/menu-item-checkbox.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import { CdkMenuItemCheckbox } from '@angular/cdk/menu';
import { booleanAttribute, computed, Directive, effect, inject, input, signal } from '@angular/core';
import { outputFromObservable } from '@angular/core/rxjs-interop';
import { getCheckedState, isIndeterminate } from './utils';

@Directive({
    selector: '[RdxMenuItemCheckbox]',
    hostDirectives: [
        {
            directive: CdkMenuItemCheckbox,
            outputs: ['cdkMenuItemTriggered: menuItemTriggered']
        }
    ],
    host: {
        role: 'menuitemcheckbox',
        '[attr.aria-checked]': 'isIndeterminate(checked()) ? "mixed" : checked()',
        '[attr.data-state]': 'getCheckedState(checked())',
        '[attr.data-highlighted]': "highlightedState() ? '' : undefined",

        '(focus)': 'onFocus()',
        '(blur)': 'onBlur()',
        '(pointermove)': 'onPointerMove($event)'
    }
})
export class RdxMenuItemCheckboxDirective {
    private readonly cdkMenuItemCheckbox = inject(CdkMenuItemCheckbox, { host: true });

    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    readonly checked = input<boolean | 'indeterminate'>(false);

    readonly onCheckedChange = outputFromObservable(this.cdkMenuItemCheckbox.triggered);

    protected readonly disabledState = computed(() => this.disabled);

    protected readonly highlightedState = computed(() => this.isFocused());

    private readonly isFocused = signal(false);

    constructor() {
        effect(() => {
            if (isIndeterminate(this.checked())) {
                this.cdkMenuItemCheckbox.checked = true;
            } else {
                this.cdkMenuItemCheckbox.checked = !this.checked();
            }

            this.cdkMenuItemCheckbox.disabled = this.disabled();
        });
    }

    onFocus(): void {
        if (!this.disabled()) {
            this.isFocused.set(true);
        }
    }

    onBlur(): void {
        this.isFocused.set(false);
    }

    onPointerMove(event: PointerEvent) {
        if (event.defaultPrevented) return;

        if (!(event.pointerType === 'mouse')) return;

        if (!this.disabled()) {
            const item = event.currentTarget;
            (item as HTMLElement)?.focus({ preventScroll: true });
        }
    }

    protected readonly isIndeterminate = isIndeterminate;
    protected readonly getCheckedState = getCheckedState;
}



# ./menu/src/utils.ts

export type CheckedState = boolean | 'indeterminate';

export function isIndeterminate(checked?: CheckedState): checked is 'indeterminate' {
    return checked === 'indeterminate';
}

export function getCheckedState(checked: CheckedState) {
    return isIndeterminate(checked) ? 'indeterminate' : checked ? 'checked' : 'unchecked';
}



# ./menu/src/menu-item-radio.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import { CdkMenuItemRadio } from '@angular/cdk/menu';
import { booleanAttribute, computed, Directive, effect, inject, input, signal } from '@angular/core';
import { outputFromObservable } from '@angular/core/rxjs-interop';
import { getCheckedState } from './utils';

@Directive({
    selector: '[RdxMenuItemRadio]',
    hostDirectives: [
        {
            directive: CdkMenuItemRadio,
            outputs: ['cdkMenuItemTriggered: menuItemTriggered']
        }
    ],
    host: {
        role: 'menuitemradio',
        '[attr.aria-checked]': 'checked()',
        '[attr.data-state]': 'getCheckedState(checked())',
        '[attr.data-highlighted]': "highlightedState() ? '' : undefined",

        '(focus)': 'onFocus()',
        '(blur)': 'onBlur()',
        '(pointermove)': 'onPointerMove($event)'
    }
})
export class RdxMenuItemRadioDirective {
    private readonly cdkMenuItemRadio = inject(CdkMenuItemRadio, { host: true });

    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    readonly checked = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    readonly onValueChange = outputFromObservable(this.cdkMenuItemRadio.triggered);

    protected readonly disabledState = computed(() => this.disabled());

    protected readonly highlightedState = computed(() => this.isFocused());

    private readonly isFocused = signal(false);

    constructor() {
        effect(() => {
            this.cdkMenuItemRadio.checked = this.checked();
            this.cdkMenuItemRadio.disabled = this.disabled();
        });
    }

    onFocus(): void {
        if (!this.disabled()) {
            this.isFocused.set(true);
        }
    }

    onBlur(): void {
        this.isFocused.set(false);
    }

    onPointerMove(event: PointerEvent) {
        if (event.defaultPrevented) return;

        if (!(event.pointerType === 'mouse')) return;

        if (!this.disabled()) {
            const item = event.currentTarget;
            (item as HTMLElement)?.focus({ preventScroll: true });
        }
    }

    protected readonly getCheckedState = getCheckedState;
}



# ./menu/src/menu-separator.directive.ts

import { Directive } from '@angular/core';

@Directive({
    selector: '[RdxMenuSeparator]',
    host: {
        role: 'separator',
        '[attr.aria-orientation]': "'horizontal'"
    }
})
export class RdxMenuSeparatorDirective {}



# ./menu/src/menu-item.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import { CdkMenuItem } from '@angular/cdk/menu';
import { booleanAttribute, computed, Directive, effect, inject, input, signal } from '@angular/core';
import { outputFromObservable } from '@angular/core/rxjs-interop';

@Directive({
    selector: '[RdxMenuItem]',
    hostDirectives: [
        {
            directive: CdkMenuItem,
            outputs: ['cdkMenuItemTriggered: menuItemTriggered']
        }
    ],
    host: {
        role: 'menuitem',
        tabindex: '-1',
        '[attr.data-orientation]': "'horizontal'",
        '[attr.data-state]': 'isOpenState()',
        '[attr.aria-disabled]': "disabledState() ? '' : undefined",
        '[attr.data-disabled]': "disabledState() ? '' : undefined",
        '[attr.data-highlighted]': "highlightedState() ? '' : undefined",

        '(focus)': 'onFocus()',
        '(blur)': 'onBlur()',
        '(pointermove)': 'onPointerMove($event)'
    }
})
export class RdxMenuItemDirective {
    private readonly cdkMenuItem = inject(CdkMenuItem, { host: true });

    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    readonly onSelect = outputFromObservable(this.cdkMenuItem.triggered);

    private readonly isFocused = signal(false);

    protected readonly disabledState = computed(() => this.disabled());

    protected readonly isOpenState = signal(false);

    protected readonly highlightedState = computed(() => this.isFocused());

    constructor() {
        effect(() => {
            this.cdkMenuItem.disabled = this.disabled();
            this.isOpenState.set(this.cdkMenuItem.isMenuOpen());
        });
    }

    onFocus(): void {
        if (!this.disabled()) {
            this.isFocused.set(true);
        }
    }

    onBlur(): void {
        this.isFocused.set(false);
    }

    onPointerMove(event: PointerEvent) {
        if (event.defaultPrevented) return;

        if (!(event.pointerType === 'mouse')) return;

        if (!this.disabled()) {
            const item = event.currentTarget;
            (item as HTMLElement)?.focus({ preventScroll: true });
        }
    }
}



# ./avatar/README.md

# @radix-ng/primitives/avatar



# ./avatar/__tests__/avatar-image.directive.spec.ts

import { Component } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { RdxAvatarFallbackDirective } from '../src/avatar-fallback.directive';
import { RdxAvatarImageDirective } from '../src/avatar-image.directive';
import { RdxAvatarRootDirective } from '../src/avatar-root.directive';

@Component({
    selector: 'rdx-mock-component',
    standalone: true,
    imports: [RdxAvatarImageDirective, RdxAvatarRootDirective, RdxAvatarFallbackDirective],
    template: `
        <span rdxAvatarRoot>
            <img
                rdxAvatarImage
                alt="Angular Logo"
                src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNTAgMjUwIj4KICAgIDxwYXRoIGZpbGw9IiNERDAwMzEiIGQ9Ik0xMjUgMzBMMzEuOSA2My4ybDE0LjIgMTIzLjFMMTI1IDIzMGw3OC45LTQzLjcgMTQuMi0xMjMuMXoiIC8+CiAgICA8cGF0aCBmaWxsPSIjQzMwMDJGIiBkPSJNMTI1IDMwdjIyLjItLjFWMjMwbDc4LjktNDMuNyAxNC4yLTEyMy4xTDEyNSAzMHoiIC8+CiAgICA8cGF0aCAgZmlsbD0iI0ZGRkZGRiIgZD0iTTEyNSA1Mi4xTDY2LjggMTgyLjZoMjEuN2wxMS43LTI5LjJoNDkuNGwxMS43IDI5LjJIMTgzTDEyNSA1Mi4xem0xNyA4My4zaC0zNGwxNy00MC45IDE3IDQwLjl6IiAvPgogIDwvc3ZnPg=="
            />
            <span rdxAvatarFallback>Angular Logo</span>
        </span>
    `
})
class RdxMockComponent {}

describe('RdxAvatarImageDirective', () => {
    let component: RdxMockComponent;
    let fixture: ComponentFixture<RdxMockComponent>;

    beforeEach(() => {
        fixture = TestBed.createComponent(RdxMockComponent);
        component = fixture.componentInstance;
    });

    it('should compile', () => {
        expect(component).toBeTruthy();
    });

    it('should display the image initially', () => {
        const imgElement = fixture.debugElement.query(By.css('img[rdxAvatarImage]'));
        expect(imgElement).toBeTruthy();
        expect(imgElement.nativeElement.src).toContain('data:image/svg+xml');
    });
});



# ./avatar/__tests__/avatar-fallback.directive.spec.ts

import { Component, PLATFORM_ID } from '@angular/core';
import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { RdxAvatarFallbackDirective } from '../src/avatar-fallback.directive';
import { RdxAvatarRootDirective } from '../src/avatar-root.directive';

@Component({
    selector: 'rdx-mock-component',
    standalone: true,
    imports: [RdxAvatarFallbackDirective, RdxAvatarRootDirective],
    template: `
        <span rdxAvatarRoot>
            <span [delayMs]="delay" rdxAvatarFallback>fallback</span>
            <span rdxAvatarFallback>fallback2</span>
        </span>
    `
})
class RdxMockComponent {
    delay = 1000;
}

describe('RdxAvatarFallbackDirective', () => {
    let component: RdxMockComponent;
    let fixture: ComponentFixture<RdxMockComponent>;

    beforeEach(() => {
        fixture = TestBed.overrideProvider(PLATFORM_ID, { useValue: 'browser' }).createComponent(RdxMockComponent);
        component = fixture.componentInstance;
    });

    it('should compile', () => {
        expect(component).toBeTruthy();
    });

    it('should hide fallback initially', () => {
        fixture.detectChanges();
        const fallbackElement = fixture.debugElement.query(By.css('span[rdxAvatarFallback]'));
        expect(fallbackElement.nativeElement.style.display).toBe('none');
    });

    it('should show fallback after delay', fakeAsync(() => {
        fixture.detectChanges();

        tick(1000);
        fixture.detectChanges();

        const fallbackElement = fixture.debugElement.query(By.css('span[rdxAvatarFallback]'));
        expect(fallbackElement.nativeElement.style.display).not.toBe('none');
    }));
});



# ./avatar/index.ts

import { NgModule } from '@angular/core';
import { RdxAvatarFallbackDirective } from './src/avatar-fallback.directive';
import { RdxAvatarImageDirective } from './src/avatar-image.directive';
import { RdxAvatarRootDirective } from './src/avatar-root.directive';

export * from './src/avatar-fallback.directive';
export * from './src/avatar-image.directive';
export * from './src/avatar-root.directive';
export type { RdxImageLoadingStatus } from './src/avatar-root.directive';
export * from './src/avatar.config';

const _imports = [
    RdxAvatarRootDirective,
    RdxAvatarFallbackDirective,
    RdxAvatarImageDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxCheckboxModule {}



# ./avatar/src/avatar-root.directive.ts

import { Directive, Injectable, signal } from '@angular/core';

export type RdxImageLoadingStatus = 'idle' | 'loading' | 'loaded' | 'error';

@Injectable()
export class RdxAvatarRootContext {
    readonly imageLoadingStatus = signal<RdxImageLoadingStatus>('loading');
}

@Directive({
    selector: 'span[rdxAvatarRoot]',
    exportAs: 'rdxAvatarRoot',
    standalone: true,
    providers: [RdxAvatarRootContext]
})
export class RdxAvatarRootDirective {}



# ./avatar/src/avatar.config.ts

import { inject, InjectionToken, Provider } from '@angular/core';

export interface RdxAvatarConfig {
    /**
     * Define a delay before the fallback is shown.
     * This is useful to only show the fallback for those with slower connections.
     * @default 0
     */
    delayMs: number;
}

export const defaultAvatarConfig: RdxAvatarConfig = {
    delayMs: 0
};

export const RdxAvatarConfigToken = new InjectionToken<RdxAvatarConfig>('RdxAvatarConfigToken');

export function provideRdxAvatarConfig(config: Partial<RdxAvatarConfig>): Provider[] {
    return [
        {
            provide: RdxAvatarConfigToken,
            useValue: { ...defaultAvatarConfig, ...config }
        }
    ];
}

export function injectAvatarConfig(): RdxAvatarConfig {
    return inject(RdxAvatarConfigToken, { optional: true }) ?? defaultAvatarConfig;
}



# ./avatar/src/avatar-image.directive.ts

import { computed, Directive, ElementRef, inject, input, OnInit, output } from '@angular/core';
import { RdxAvatarRootContext, RdxImageLoadingStatus } from './avatar-root.directive';

/**
 * @group Components
 */
@Directive({
    selector: 'img[rdxAvatarImage]',
    standalone: true,
    exportAs: 'rdxAvatarImage',
    host: {
        '(load)': 'onLoad()',
        '(error)': 'onError()',
        '[style.display]': '(imageLoadingStatus() === "loaded")? null : "none"'
    }
})
export class RdxAvatarImageDirective implements OnInit {
    private readonly avatarRoot = inject(RdxAvatarRootContext);
    private readonly elementRef = inject(ElementRef<HTMLImageElement>);

    /**
     * @group Props
     */
    readonly src = input<string>();

    /**
     * A callback providing information about the loading status of the image.
     * This is useful in case you want to control more precisely what to render as the image is loading.
     *
     * @group Emits
     */
    readonly onLoadingStatusChange = output<RdxImageLoadingStatus>();

    protected readonly imageLoadingStatus = computed(() => this.avatarRoot.imageLoadingStatus());

    ngOnInit(): void {
        this.nativeElement.src = this.src();

        if (!this.nativeElement.src) {
            this.setImageStatus('error');
        } else if (this.nativeElement.complete) {
            this.setImageStatus('loaded');
        } else {
            this.setImageStatus('loading');
        }
    }

    onLoad() {
        this.setImageStatus('loaded');
    }

    onError() {
        this.setImageStatus('error');
    }

    private setImageStatus(status: RdxImageLoadingStatus) {
        this.avatarRoot.imageLoadingStatus.set(status);
        this.onLoadingStatusChange.emit(status);
    }

    get nativeElement() {
        return this.elementRef.nativeElement;
    }
}



# ./avatar/src/avatar-fallback.directive.ts

import { computed, Directive, effect, inject, input, OnDestroy, signal } from '@angular/core';
import { RdxAvatarRootContext } from './avatar-root.directive';
import { injectAvatarConfig } from './avatar.config';

/**
 * @group Components
 */
@Directive({
    selector: 'span[rdxAvatarFallback]',
    standalone: true,
    exportAs: 'rdxAvatarFallback',
    host: {
        '[style.display]': 'shouldRender() ? null : "none" '
    }
})
export class RdxAvatarFallbackDirective implements OnDestroy {
    protected readonly avatarRoot = inject(RdxAvatarRootContext);

    private readonly config = injectAvatarConfig();

    /**
     * Useful for delaying rendering so it only appears for those with slower connections.
     *
     * @group Props
     * @defaultValue 0
     */
    readonly delayMs = input<number>(this.config.delayMs);

    readonly shouldRender = computed(() => this.canRender() && this.avatarRoot.imageLoadingStatus() !== 'loaded');

    protected readonly canRender = signal(false);
    private timeoutId: ReturnType<typeof setTimeout> | null = null;

    constructor() {
        effect(() => {
            const status = this.avatarRoot.imageLoadingStatus();
            if (status === 'loading') {
                this.startDelayTimer();
            } else {
                this.clearDelayTimer();
                this.canRender.set(true);
            }
        });
    }

    private startDelayTimer() {
        this.clearDelayTimer();
        if (this.delayMs() > 0) {
            this.timeoutId = setTimeout(() => {
                this.canRender.set(true);
            }, this.delayMs());
        } else {
            this.canRender.set(true);
        }
    }

    private clearDelayTimer() {
        if (this.timeoutId !== null) {
            clearTimeout(this.timeoutId);
            this.timeoutId = null;
        }
    }

    ngOnDestroy() {
        this.clearDelayTimer();
    }
}



# ./aspect-ratio/README.md

# @radix-ng/primitives/avatar



# ./aspect-ratio/__tests__/aspect-ratio.directive.spec.ts

import { Component } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RdxAspectRatioDirective } from '../src/aspect-ratio.directive';

@Component({
    template: `
        <div [ratio]="ratio" rdxAspectRatio></div>
    `,
    imports: [RdxAspectRatioDirective]
})
class TestComponent {
    ratio = 16 / 9;
}

describe('AspectRatioDirective', () => {
    let fixture: ComponentFixture<TestComponent>;
    let component: TestComponent;

    beforeEach(() => {
        fixture = TestBed.configureTestingModule({
            imports: [TestComponent]
        }).createComponent(TestComponent);

        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should set paddingBottom correctly with rounded value', () => {
        const div: HTMLElement = fixture.nativeElement.querySelector('div');

        // 1 / (16/9) * 100 = 56.25%
        expect(div.style.paddingBottom).toBe('56.25%');
    });

    it('should set position to relative and width to 100%', () => {
        const div: HTMLElement = fixture.nativeElement.querySelector('div');

        expect(div.style.position).toBe('relative');
        expect(div.style.width).toBe('100%');
    });

    it('should update paddingBottom when ratio changes', () => {
        const div: HTMLElement = fixture.nativeElement.querySelector('div');

        component.ratio = 4 / 3;
        fixture.detectChanges();

        // 1 / (4/3) * 100 = 75%
        expect(div.style.paddingBottom).toBe('75%');
    });

    it('should set paddingBottom correctly for small ratios', () => {
        const div: HTMLElement = fixture.nativeElement.querySelector('div');

        component.ratio = 1 / 1;
        fixture.detectChanges();

        // 1 / (1/1) * 100 = 100%
        expect(div.style.paddingBottom).toBe('100%'); //
    });

    it('should set paddingBottom to 0% when ratio is 0 to avoid division by zero', () => {
        const div: HTMLElement = fixture.nativeElement.querySelector('div');

        component.ratio = 0;
        fixture.detectChanges();

        expect(div.style.paddingBottom).toBe('0%');
    });
});



# ./aspect-ratio/index.ts

export * from './src/aspect-ratio.directive';



# ./aspect-ratio/src/aspect-ratio.directive.ts

import { NumberInput } from '@angular/cdk/coercion';
import {
    AfterViewInit,
    computed,
    Directive,
    ElementRef,
    inject,
    input,
    numberAttribute,
    Renderer2
} from '@angular/core';

/**
 * Directive to maintain an aspect ratio for an element.
 * The element will have its `padding-bottom` dynamically calculated
 * based on the provided aspect ratio to maintain the desired ratio.
 * The content inside the element will be positioned absolutely.
 * @group Components
 */
@Directive({
    selector: '[rdxAspectRatio]',
    exportAs: 'rdxAspectRatio',
    standalone: true,
    host: {
        '[style.position]': `'relative'`,
        '[style.width]': `'100%'`,
        '[style.padding-bottom]': 'paddingBottom()'
    }
})
export class RdxAspectRatioDirective implements AfterViewInit {
    private readonly element = inject(ElementRef);
    private readonly renderer = inject(Renderer2);

    /**
     * The desired aspect ratio (e.g., 16/9).
     * By default, it is set to 1 (which results in a square, 1:1).
     * @group Props
     * @defaultValue 1
     */
    readonly ratio = input<number, NumberInput>(1, { transform: numberAttribute });

    /**
     * Dynamically computed `padding-bottom` style for the element.
     * This value is calculated based on the inverse of the aspect ratio.
     *
     * If the ratio is zero, it defaults to `0%` to avoid division by zero.
     *
     */
    protected readonly paddingBottom = computed(() => {
        const ratioValue = this.ratio();
        return `${ratioValue !== 0 ? (1 / ratioValue) * 100 : 0}%`;
    });

    ngAfterViewInit() {
        const content = this.element.nativeElement.firstElementChild;
        if (content) {
            // Set the content to cover the entire element with absolute positioning
            this.renderer.setStyle(content, 'position', 'absolute');
            this.renderer.setStyle(content, 'inset', '0');
        }
    }
}



# ./switch/README.md

# @radix-ng/primitives/switch



# ./switch/__tests__/switch.directive.spec.ts

import { TestBed } from '@angular/core/testing';

import { ElementRef } from '@angular/core';
import { RdxSwitchRootDirective } from '../src/switch-root.directive';

describe('RdxSwitchRootDirective', () => {
    let directive: RdxSwitchRootDirective;

    beforeEach(() => {
        TestBed.configureTestingModule({
            providers: [
                RdxSwitchRootDirective,
                { provide: ElementRef, useValue: new ElementRef(document.createElement('button')) }]
        });

        directive = TestBed.inject(RdxSwitchRootDirective);
    });

    it('should initialize with default state', () => {
        expect(directive.checked()).toBe(false);
        expect(directive.required()).toBe(false);
        expect(directive.disabled()).toBe(false);
    });

    it('should toggle checked state and emit event', () => {
        const onCheckedChangeSpy = jest.spyOn(directive.onCheckedChange, 'emit');
        directive.toggle();

        expect(directive.checked()).toBe(true);
        expect(onCheckedChangeSpy).toHaveBeenCalledWith(true);

        directive.toggle();

        expect(directive.checked()).toBe(false);
        expect(onCheckedChangeSpy).toHaveBeenCalledWith(false);
    });

    it('should set disabled state using ControlValueAccessor', () => {
        directive.setDisabledState(true);
        expect(directive.disabledState()).toBe(true);

        directive.setDisabledState(false);
        expect(directive.disabledState()).toBe(false);
    });

    it('should emit correct values for controlled checked state', () => {
        const onCheckedChangeSpy = jest.spyOn(directive.onCheckedChange, 'emit');

        directive.checked.set(true);
        directive.toggle(); // Controlled state logic
        expect(directive.checked()).toBe(false);
        expect(onCheckedChangeSpy).toHaveBeenCalledWith(false);
    });
});



# ./switch/index.ts

import { NgModule } from '@angular/core';
import { RdxSwitchInputDirective } from './src/switch-input.directive';
import { RdxSwitchRootDirective } from './src/switch-root.directive';
import { RdxSwitchThumbDirective } from './src/switch-thumb.directive';

export * from './src/switch-input.directive';
export * from './src/switch-root.directive';
export * from './src/switch-thumb.directive';

export type { SwitchProps } from './src/switch-root.directive';

const switchImports = [
    RdxSwitchRootDirective,
    RdxSwitchInputDirective,
    RdxSwitchThumbDirective
];

@NgModule({
    imports: [...switchImports],
    exports: [...switchImports]
})
export class RdxSwitchModule {}



# ./switch/src/switch-root.directive.ts

import { BooleanInput } from '@angular/cdk/coercion';
import {
    booleanAttribute,
    computed,
    Directive,
    effect,
    forwardRef,
    inject,
    InjectionToken,
    input,
    InputSignalWithTransform,
    model,
    ModelSignal,
    output,
    OutputEmitterRef,
    signal
} from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

export const RdxSwitchToken = new InjectionToken<RdxSwitchRootDirective>('RdxSwitchToken');

export function injectSwitch(): RdxSwitchRootDirective {
    return inject(RdxSwitchToken);
}

export const SWITCH_VALUE_ACCESSOR: any = {
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => RdxSwitchRootDirective),
    multi: true
};

export interface SwitchProps {
    checked?: ModelSignal<boolean>;
    defaultChecked?: InputSignalWithTransform<boolean, BooleanInput>;
    required?: InputSignalWithTransform<boolean, BooleanInput>;
    onCheckedChange?: OutputEmitterRef<boolean>;
}

let idIterator = 0;

/**
 * @group Components
 */
@Directive({
    selector: 'button[rdxSwitchRoot]',
    exportAs: 'rdxSwitchRoot',
    standalone: true,
    providers: [
        { provide: RdxSwitchToken, useExisting: RdxSwitchRootDirective },
        SWITCH_VALUE_ACCESSOR
    ],
    host: {
        type: 'button',
        '[id]': 'elementId()',
        '[attr.aria-checked]': 'checkedState()',
        '[attr.aria-required]': 'required()',
        '[attr.data-state]': 'checkedState() ? "checked" : "unchecked"',
        '[attr.data-disabled]': 'disabledState() ? "true" : null',
        '[attr.disabled]': 'disabledState() ? disabledState() : null',

        '(click)': 'toggle()'
    }
})
export class RdxSwitchRootDirective implements SwitchProps, ControlValueAccessor {
    readonly id = input<string | null>(`rdx-switch-${idIterator++}`);

    protected readonly elementId = computed(() => (this.id() ? this.id() : null));

    readonly inputId = input<string | null>(null);

    /**
     * When true, indicates that the user must check the switch before the owning form can be submitted.
     *
     * @default false
     * @group Props
     */
    readonly required = input<boolean, BooleanInput>(false, {
        transform: booleanAttribute
    });

    /**
     * Establishes relationships between the component and label(s) where its value should be one or more element IDs.
     * @default null
     * @group Props
     */
    readonly ariaLabelledBy = input<string | undefined>(undefined, {
        alias: 'aria-labelledby'
    });

    /**
     * Used to define a string that autocomplete attribute the current element.
     * @default null
     * @group Props
     */
    readonly ariaLabel = input<string | undefined>(undefined, {
        alias: 'aria-label'
    });

    /**
     * The controlled state of the switch. Must be used in conjunction with onCheckedChange.
     * @defaultValue false
     * @group Props
     */
    readonly checked = model<boolean>(false);

    /**
     * The state of the switch when it is initially rendered. Use when you do not need to control its state.
     * @default false
     * @group Props
     */
    readonly defaultChecked = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * The state of the switch.
     * If `defaultChecked` is provided, it takes precedence over the `checked` state.
     * @ignore
     */
    readonly checkedState = computed(() => this.checked());

    /**
     * When `true`, prevents the user from interacting with the switch.
     * @default false
     * @group Props
     */
    readonly disabled = input<boolean, BooleanInput>(false, {
        transform: booleanAttribute
    });

    /** @ignore */
    readonly disabledState = computed(() => this.disabled() || this.accessorDisabled());

    /**
     * Event handler called when the state of the switch changes.
     *
     * @param {boolean} value - Boolean value indicates that the option is changed.
     * @group Emits
     */
    readonly onCheckedChange = output<boolean>();

    private readonly defaultCheckedUsed = computed(() => this.defaultChecked());

    constructor() {
        effect(() => {
            if (this.defaultCheckedUsed()) {
                this.checked.set(this.defaultChecked());
            }
        });
    }

    /**
     * Toggles the checked state of the switch.
     * If the switch is disabled, the function returns early.
     * @ignore
     */
    toggle(): void {
        if (this.disabledState()) {
            return;
        }

        this.checked.set(!this.checked());

        this.onChange(this.checked());
        this.onCheckedChange.emit(this.checked());
    }

    private readonly accessorDisabled = signal(false);

    private onChange: (value: any) => void = () => {};
    /** @ignore */
    onTouched: (() => void) | undefined;

    /** @ignore */
    writeValue(value: any): void {
        this.checked.set(value);
    }

    /** @ignore */
    registerOnChange(fn: (value: any) => void): void {
        this.onChange = fn;
    }

    /** @ignore */
    registerOnTouched(fn: () => void): void {
        this.onTouched = fn;
    }

    /** @ignore */
    setDisabledState(isDisabled: boolean): void {
        this.accessorDisabled.set(isDisabled);
    }
}



# ./switch/src/switch-thumb.directive.ts

import { Directive } from '@angular/core';
import { injectSwitch } from './switch-root.directive';

/**
 * @group Components
 */
@Directive({
    selector: 'span[rdxSwitchThumb]',
    exportAs: 'rdxSwitchThumb',
    standalone: true,
    host: {
        '[attr.data-disabled]': 'switchRoot.disabledState() ? "true" : null',
        '[attr.data-state]': 'switchRoot.checkedState() ? "checked" : "unchecked"'
    }
})
export class RdxSwitchThumbDirective {
    protected readonly switchRoot = injectSwitch();
}



# ./switch/src/switch-input.directive.ts

import { Directive } from '@angular/core';
import { injectSwitch } from './switch-root.directive';

/**
 * @group Components
 */
@Directive({
    selector: 'input[rdxSwitchInput]',
    exportAs: 'rdxSwitchInput',
    standalone: true,
    host: {
        type: 'checkbox',
        role: 'switch',
        tabindex: '-1',
        '[attr.id]': 'switchRoot.inputId()',
        '[attr.defaultChecked]': 'switchRoot.checkedState()',
        '[attr.aria-checked]': 'switchRoot.checkedState()',
        '[attr.aria-hidden]': 'true',
        '[attr.aria-label]': 'switchRoot.ariaLabel()',
        '[attr.aria-labelledby]': 'switchRoot.ariaLabelledBy()',
        '[attr.aria-required]': 'switchRoot.required()',
        '[attr.data-state]': 'switchRoot.checkedState() ? "checked" : "unchecked"',
        '[attr.data-disabled]': 'switchRoot.disabledState() ? "true" : null',
        '[attr.disabled]': 'switchRoot.disabledState() ? switchRoot.disabledState() : null',
        '[attr.value]': 'switchRoot.checkedState() ? "on" : "off"',
        style: 'transform: translateX(-100%); position: absolute; overflow: hidden; pointerEvents: none; opacity: 0; margin: 0;',

        '(blur)': 'onBlur()'
    }
})
export class RdxSwitchInputDirective {
    protected readonly switchRoot = injectSwitch();

    /** @ignore */
    protected onBlur() {
        this.switchRoot.onTouched?.();
    }
}



# ./select/README.md

# @radix-ng/primitives/select



# ./select/__tests__/select-item.directive.spec.ts

import { RdxSelectItemDirective } from '../src/select-item.directive';

xdescribe('RdxSelectItemDirective', () => {
    it('should create an instance', () => {
        const directive = new RdxSelectItemDirective();
        expect(directive).toBeTruthy();
    });
});



# ./select/__tests__/select-content.directive.spec.ts

import { RdxSelectContentDirective } from '../src/select-content.directive';

xdescribe('RdxSelectContentDirective', () => {
    it('should create an instance', () => {
        const directive = new RdxSelectContentDirective();
        expect(directive).toBeTruthy();
    });
});



# ./select/__tests__/select-trigger.directive.spec.ts

import { RdxSelectTriggerDirective } from '../src/select-trigger.directive';

xdescribe('RdxSelectTriggerDirective', () => {
    it('should create an instance', () => {
        const directive = new RdxSelectTriggerDirective();
        expect(directive).toBeTruthy();
    });
});



# ./select/__tests__/select.directive.spec.ts

import { RdxSelectComponent } from '../src/select.component';

xdescribe('RdxSelectDirective', () => {
    it('should create an instance', () => {
        const directive = new RdxSelectComponent();
        expect(directive).toBeTruthy();
    });
});



# ./select/index.ts

import { NgModule } from '@angular/core';
import { RdxSelectContentDirective } from './src/select-content.directive';
import { RdxSelectGroupDirective } from './src/select-group.directive';
import { RdxSelectIconDirective } from './src/select-icon.directive';
import { RdxSelectItemIndicatorDirective } from './src/select-item-indicator.directive';
import { RdxSelectItemDirective } from './src/select-item.directive';
import { RdxSelectLabelDirective } from './src/select-label.directive';
import { RdxSelectSeparatorDirective } from './src/select-separator.directive';
import { RdxSelectTriggerDirective } from './src/select-trigger.directive';
import { RdxSelectValueDirective } from './src/select-value.directive';
import { RdxSelectComponent } from './src/select.component';

export * from './src/select-content.directive';
export * from './src/select-group.directive';
export * from './src/select-icon.directive';
export * from './src/select-item-indicator.directive';
export * from './src/select-item.directive';
export * from './src/select-label.directive';
export * from './src/select-separator.directive';
export * from './src/select-trigger.directive';
export * from './src/select-value.directive';
export * from './src/select.component';

const _imports = [
    RdxSelectContentDirective,
    RdxSelectGroupDirective,
    RdxSelectItemDirective,
    RdxSelectItemIndicatorDirective,
    RdxSelectLabelDirective,
    RdxSelectComponent,
    RdxSelectSeparatorDirective,
    RdxSelectTriggerDirective,
    RdxSelectValueDirective,
    RdxSelectIconDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxSelectModule {}



# ./select/src/select-icon.directive.ts

import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxSelectIcon]',
    standalone: true,
    exportAs: 'rdxSelectIcon',
    host: {
        '[attr.aria-hidden]': 'true'
    }
})
export class RdxSelectIconDirective {}



# ./select/src/select-item.directive.ts

import { Highlightable } from '@angular/cdk/a11y';
import { ENTER, SPACE } from '@angular/cdk/keycodes';
import { booleanAttribute, Directive, ElementRef, EventEmitter, inject, Input } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { RdxSelectContentDirective } from './select-content.directive';
import { RdxSelectComponent } from './select.component';

let nextId = 0;

export class RdxSelectItemChange<T = RdxSelectItemDirective> {
    constructor(public source: T) {}
}

@Directive({
    selector: '[rdxSelectItem]',
    standalone: true,
    exportAs: 'rdxSelectItem',
    host: {
        '[attr.role]': '"option"',
        '[attr.data-state]': 'dataState',
        '[attr.aria-selected]': 'selected',
        '[attr.data-disabled]': 'disabled || null',
        '[attr.data-highlighted]': 'highlighted || null',
        '[attr.tabindex]': '-1',
        '(focus)': 'content.highlighted.next(this)',
        '(click)': 'selectViaInteraction()',
        '(keydown)': 'handleKeydown($event)',
        '(pointermove)': 'onPointerMove()'
    }
})
export class RdxSelectItemDirective implements Highlightable {
    protected readonly select = inject(RdxSelectComponent);
    protected readonly content = inject(RdxSelectContentDirective);
    readonly onSelectionChange = new EventEmitter<RdxSelectItemChange>();
    protected readonly nativeElement = inject(ElementRef).nativeElement;

    highlighted: boolean = false;

    selected: boolean;

    get dataState(): string {
        return this.selected ? 'checked' : 'unchecked';
    }

    /**
     * The unique SelectItem id.
     * @ignore
     */
    readonly id: string = `rdx-select-item-${nextId++}`;

    @Input()
    set value(value: string) {
        this._value = value;
    }

    get value(): string {
        return this._value || this.id;
    }

    private _value?: string;

    @Input() textValue: string | null = null;

    /** Whether the SelectItem is disabled. */
    @Input({ transform: booleanAttribute })
    set disabled(value: boolean) {
        this._disabled = value;
    }

    get disabled(): boolean {
        return this._disabled;
    }

    private _disabled: boolean;

    get viewValue(): string {
        return this.textValue ?? this.nativeElement.textContent;
    }

    constructor() {
        this.content.highlighted.pipe(takeUntilDestroyed()).subscribe((value) => {
            if (value !== this) {
                this.highlighted = false;
            }
        });
    }

    /** Gets the label to be used when determining whether the option should be focused.
     * @ignore
     */
    getLabel(): string {
        return this.viewValue;
    }

    /**
     * `Selects the option while indicating the selection came from the user. Used to
     * determine if the select's view -> model callback should be invoked.`
     * @ignore
     */
    selectViaInteraction(): void {
        if (!this.disabled) {
            this.selected = true;

            this.onSelectionChange.emit(new RdxSelectItemChange(this));
        }
    }

    /** @ignore */
    handleKeydown(event: KeyboardEvent): void {
        if (event.keyCode === ENTER || event.keyCode === SPACE) {
            this.selectViaInteraction();

            // Prevent the page from scrolling down and form submits.
            event.preventDefault();
            event.stopPropagation();
        }
    }

    /** @ignore */
    setActiveStyles(): void {
        this.highlighted = true;
        this.nativeElement.focus({ preventScroll: true });
    }

    /** @ignore */
    setInactiveStyles(): void {
        this.highlighted = false;
    }

    protected onPointerMove(): void {
        if (!this.highlighted) {
            this.nativeElement.focus({ preventScroll: true });
            this.select.updateActiveItem(this);
        }
    }
}



# ./select/src/select-content.directive.ts

import { ActiveDescendantKeyManager } from '@angular/cdk/a11y';
import { Directionality } from '@angular/cdk/bidi';
import { AfterContentInit, ContentChildren, DestroyRef, Directive, inject, QueryList } from '@angular/core';
import { pairwise, startWith, Subject } from 'rxjs';
import { RdxSelectItemDirective } from './select-item.directive';
import { RdxSelectComponent } from './select.component';

@Directive({
    selector: '[rdxSelectContent]',
    standalone: true,
    exportAs: 'rdxSelectContent',
    host: {
        '[attr.role]': '"listbox"',
        '[attr.data-state]': "select.open ? 'open': 'closed'",
        '[attr.data-side]': 'true',
        '[attr.data-align]': 'true',
        '(keydown)': 'keyManager.onKeydown($event)'
    }
})
export class RdxSelectContentDirective implements AfterContentInit {
    protected readonly destroyRef = inject(DestroyRef);
    protected readonly dir = inject(Directionality, { optional: true });
    protected select = inject(RdxSelectComponent);

    readonly highlighted = new Subject<RdxSelectItemDirective>();

    keyManager: ActiveDescendantKeyManager<RdxSelectItemDirective>;

    @ContentChildren(RdxSelectItemDirective, { descendants: true })
    options: QueryList<RdxSelectItemDirective>;

    constructor() {
        this.highlighted.pipe(startWith(null), pairwise()).subscribe(([prev, item]) => {
            if (prev) {
                prev.highlighted = false;
            }

            if (item) {
                item.highlighted = true;
            }
        });
    }

    initKeyManager() {
        return new ActiveDescendantKeyManager<RdxSelectItemDirective>(this.options)
            .withTypeAhead()
            .withVerticalOrientation()
            .withHorizontalOrientation(this.dir?.value ?? 'ltr');
    }

    ngAfterContentInit(): void {
        this.keyManager = this.initKeyManager();
    }
}



# ./select/src/select-trigger.directive.ts

import { ContentChild, Directive, ElementRef, inject } from '@angular/core';
import { RdxSelectValueDirective } from './select-value.directive';
import { RdxSelectComponent } from './select.component';

@Directive({
    selector: '[rdxSelectTrigger]',
    standalone: true,
    host: {
        '[attr.type]': '"button"',
        '[attr.role]': '"combobox"',
        '[attr.aria-autocomplete]': '"none"',
        '[attr.dir]': 'select.dir.value',
        '[attr.aria-expanded]': 'select.open',
        '[attr.aria-required]': 'select.required',

        '[attr.disabled]': 'select.disabled ? "" : null',
        '[attr.data-disabled]': 'select.disabled ? "" : null',
        '[attr.data-state]': "select.open ? 'open': 'closed'",
        '[attr.data-placeholder]': 'value.placeholder || null'
    }
})
export class RdxSelectTriggerDirective {
    protected nativeElement = inject(ElementRef).nativeElement;
    protected select = inject(RdxSelectComponent);

    @ContentChild(RdxSelectValueDirective) protected value: RdxSelectValueDirective;

    focus() {
        this.nativeElement.focus();
    }
}



# ./select/src/select-separator.directive.ts

import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxSelectSeparator]',
    standalone: true,
    exportAs: 'rdxSelectSeparator',
    host: {
        '[attr.aria-hidden]': 'true'
    }
})
export class RdxSelectSeparatorDirective {}



# ./select/src/select.component.ts

import { ActiveDescendantKeyManager } from '@angular/cdk/a11y';
import { Directionality } from '@angular/cdk/bidi';
import { SelectionModel } from '@angular/cdk/collections';
import { CdkConnectedOverlay, ConnectedPosition, Overlay, OverlayModule } from '@angular/cdk/overlay';
import {
    AfterContentInit,
    booleanAttribute,
    ChangeDetectorRef,
    Component,
    ContentChild,
    ContentChildren,
    DestroyRef,
    ElementRef,
    EventEmitter,
    forwardRef,
    inject,
    Input,
    NgZone,
    OnInit,
    Output,
    QueryList,
    ViewChild
} from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { defer, delay, merge, Observable, Subscription, switchMap, take } from 'rxjs';
import { RdxSelectContentDirective } from './select-content.directive';
import { RdxSelectItemChange, RdxSelectItemDirective } from './select-item.directive';
import { RdxSelectTriggerDirective } from './select-trigger.directive';

let nextId = 0;

@Component({
    selector: '[rdxSelect]',
    template: `
        <ng-content select="[rdxSelectTrigger]" />

        <ng-template
            [cdkConnectedOverlayOpen]="open"
            [cdkConnectedOverlayOrigin]="elementRef"
            [cdkConnectedOverlayPositions]="positions"
            [cdkConnectedOverlayScrollStrategy]="overlay.scrollStrategies.reposition()"
            (attach)="onAttached()"
            (backdropClick)="close()"
            (detach)="onDetach()"
            cdkConnectedOverlay
        >
            <ng-content select="[rdxSelectContent]" />
        </ng-template>
    `,
    host: {
        '(click)': 'toggle()',
        '(keydown)': 'content.keyManager.onKeydown($event)'
    },
    imports: [
        OverlayModule
    ]
})
export class RdxSelectComponent implements OnInit, AfterContentInit {
    protected overlay = inject(Overlay);
    protected elementRef = inject(ElementRef);
    protected changeDetectorRef = inject(ChangeDetectorRef);
    private readonly destroyRef = inject(DestroyRef);
    private readonly ngZone = inject(NgZone);

    @ContentChild(RdxSelectTriggerDirective) protected trigger: RdxSelectTriggerDirective;

    @ContentChild(forwardRef(() => RdxSelectContentDirective))
    protected content: RdxSelectContentDirective;

    @ContentChildren(forwardRef(() => RdxSelectItemDirective), { descendants: true })
    items: QueryList<RdxSelectItemDirective>;

    @ViewChild(CdkConnectedOverlay, { static: false }) overlayDir: CdkConnectedOverlay;

    /** Deals with the selection logic. */
    selectionModel: SelectionModel<RdxSelectItemDirective>;

    /**
     * This position config ensures that the top "start" corner of the overlay
     * is aligned with the top "start" of the origin by default (overlapping
     * the trigger completely). If the panel cannot fit below the trigger, it
     * will fall back to a position above the trigger.
     */
    positions: ConnectedPosition[] = [
        {
            originX: 'start',
            originY: 'bottom',
            overlayX: 'start',
            overlayY: 'top'
        },
        {
            originX: 'start',
            originY: 'top',
            overlayX: 'start',
            overlayY: 'bottom'
        }
    ];

    private closeSubscription = Subscription.EMPTY;

    /**
     * @ignore
     */
    readonly dir = inject(Directionality, { optional: true });

    /**
     * @ignore
     */
    protected keyManager: ActiveDescendantKeyManager<RdxSelectItemDirective>;

    /**
     * @ignore
     */
    readonly id: string = `rdx-select-${nextId++}`;

    @Input() defaultValue: string;
    @Input() name: string;

    @Input({ transform: booleanAttribute }) defaultOpen: boolean;

    @Input({ transform: booleanAttribute }) open: boolean = false;

    /** Whether the Select is disabled. */
    @Input({ transform: booleanAttribute }) disabled: boolean;

    @Input({ transform: booleanAttribute }) required: boolean;

    /**
     * The controlled value of the item to expand
     */
    @Input()
    set value(value: string) {
        if (this._value !== value) {
            this._value = value;

            this.selectValue(value);

            this.changeDetectorRef.markForCheck();
        }
    }

    get value(): string | null {
        return this._value ?? this.defaultValue;
    }

    private _value?: string;

    @Output() readonly onValueChange: EventEmitter<string> = new EventEmitter<string>();

    @Output() readonly onOpenChange: EventEmitter<boolean> = new EventEmitter<boolean>();

    readonly optionSelectionChanges: Observable<RdxSelectItemChange> = defer(() => {
        if (this.content.options) {
            return merge(...this.content.options.map((option) => option.onSelectionChange));
        }

        return this.ngZone.onStable.asObservable().pipe(
            take(1),
            switchMap(() => this.optionSelectionChanges)
        );
    }) as Observable<RdxSelectItemChange>;

    get selected(): string | null {
        return this.selectionModel.selected[0].viewValue || null;
    }

    ngOnInit() {
        this.selectionModel = new SelectionModel<RdxSelectItemDirective>();

        this.selectionModel.changed.subscribe((changes) => {
            if (changes.added.length) {
                this.onValueChange.emit(this.selectionModel.selected[0].value);
            }

            if (changes.removed.length) {
                changes.removed.forEach((item) => (item.selected = false));
            }
        });
    }

    ngAfterContentInit() {
        this.selectDefaultValue();

        this.optionSelectionChanges.subscribe((event) => {
            this.selectionModel.clear();

            this.selectionModel.select(event.source);

            this.close();
            this.trigger.focus();
        });

        this.content.keyManager.tabOut.subscribe(() => {
            if (this.open) this.close();
        });

        if (this.defaultOpen) {
            this.openPanel();
        }
    }

    /**
     * Callback that is invoked when the overlay panel has been attached.
     */
    onAttached(): void {
        this.closeSubscription = this.closingActions()
            .pipe(takeUntilDestroyed(this.destroyRef))
            .pipe(delay(0))
            .subscribe(() => this.close());
    }

    onDetach() {
        this.close();
        this.closeSubscription.unsubscribe();
    }

    /** Toggles the overlay panel open or closed. */
    toggle(): void {
        if (this.open) {
            this.close();
        } else {
            this.openPanel();
        }
    }

    openPanel() {
        this.open = true;

        this.onOpenChange.emit(this.open);
    }

    close() {
        this.open = false;

        this.onOpenChange.emit(this.open);
    }

    updateActiveItem(item: RdxSelectItemDirective) {
        this.content.keyManager.updateActiveItem(item);
    }

    private selectDefaultValue(): void {
        if (!this.defaultValue) return;

        this.selectValue(this.defaultValue);
    }

    private selectValue(value: string): void {
        const option = this.content?.options.find((option) => option.value === value);

        if (option) {
            option.selected = true;
            option.highlighted = true;

            this.selectionModel.select(option);
            this.updateActiveItem(option);
        }
    }

    private closingActions() {
        return merge(this.overlayDir.overlayRef!.outsidePointerEvents(), this.overlayDir.overlayRef!.detachments());
    }
}



# ./select/src/select-item-indicator.directive.ts

import { Directive, inject } from '@angular/core';
import { RdxSelectItemDirective } from './select-item.directive';

@Directive({
    selector: '[rdxSelectItemIndicator]',
    standalone: true,
    exportAs: 'rdxSelectItemIndicator',
    host: {
        '[attr.aria-hidden]': 'true',
        '[style.display]': 'item.selected ? "" : "none"'
    }
})
export class RdxSelectItemIndicatorDirective {
    protected item = inject(RdxSelectItemDirective);
}



# ./select/src/select-value.directive.ts

import { Component, inject, Input } from '@angular/core';
import { RdxSelectComponent } from './select.component';

@Component({
    selector: '[rdxSelectValue]',
    standalone: true,
    exportAs: 'rdxSelectValue',
    template: `
        {{ select.selectionModel.isEmpty() ? placeholder : select.selected }}
    `,
    styles: `
        /* we don't want events from the children to bubble through the item they came from */
        :host {
            pointer-events: none;
        }
    `
})
export class RdxSelectValueDirective {
    select = inject(RdxSelectComponent);

    @Input() placeholder: string;
}



# ./select/src/select-group.directive.ts

import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxSelectGroup]',
    standalone: true,
    exportAs: 'rdxSelectGroup',
    host: {
        '[attr.role]': '"group"'
    }
})
export class RdxSelectGroupDirective {}



# ./select/src/select-label.directive.ts

import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxSelectLabel]',
    standalone: true,
    exportAs: 'rdxSelectLabel'
})
export class RdxSelectLabelDirective {}



