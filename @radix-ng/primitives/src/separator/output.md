/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/separator/README.md
```
# @radix-ng/primitives/separator

Secondary entry point of `@radix-ng/primitives`.

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/separator/index.ts
```typescript
export * from './src/separator.directive';

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/separator/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/separator/stories/separator.docs.mdx
````
import { ArgTypes, Canvas, Meta } from '@storybook/blocks';
import { RdxSeparatorRootDirective } from '../src/separator.directive';
import * as SeparatorDirectiveStories from './separator.stories';

<Meta title="Primitives/Separator" />

# Separator

#### Visually or semantically separates content.

<Canvas sourceState="hidden" of={SeparatorDirectiveStories.Default} />

## Features

- ✅ Supports horizontal and vertical orientations.

## Usage

Get started with importing the directive:

```typescript
import { RdxSeparatorRootDirective } from '@radix-ng/primitives/separator';
```

## Examples

```html
<div rdxSeparatorRoot decorative="decorative" orientation="vertical"></div>
```

## API Reference

<ArgTypes of={RdxSeparatorRootDirective} />

## Accessibility

Adheres to the [`separator` role requirements](https://www.w3.org/TR/wai-aria-1.2/#separator).

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/separator/stories/separator.stories.ts
```typescript
import { CommonModule } from '@angular/common';
import { componentWrapperDecorator, moduleMetadata } from '@storybook/angular';
import { RdxSeparatorRootDirective } from '../src/separator.directive';

const html = String.raw;

export default {
    component: RdxSeparatorRootDirective,
    title: 'Primitives/Separator',
    decorators: [
        moduleMetadata({
            imports: [RdxSeparatorRootDirective, CommonModule]
        }),
        componentWrapperDecorator(
            (story) => html`
                <div class="radix-themes light light-theme" data-radius="medium" data-scaling="100%">${story}</div>
            `
        )
    ]
};

export const Default = {
    render: () => ({
        template: html`
            <style>
                .SeparatorRoot {
                    background-color: var(--violet-6);
                }

                .SeparatorRoot[data-orientation='horizontal'] {
                    height: 1px;
                    width: 100%;
                }

                .SeparatorRoot[data-orientation='vertical'] {
                    height: 100%;
                    width: 1px;
                }

                .Text {
                    color: white;
                    font-size: 15px;
                    line-height: 20px;
                }
            </style>
            <div style="width: 100%; max-width: 300px; margin: 0 15px;">
                <div class="Text">Radix Primitives</div>
                <div class="Text" style="font-weight: 500;">An open-source UI component library.</div>
                <div class="SeparatorRoot" rdxSeparatorRoot style="margin: 15px 0;"></div>
                <div style="display: flex; height: 1.25rem; align-items: center;">
                    <div class="Text">Blog</div>
                    <div
                        class="SeparatorRoot"
                        rdxSeparatorRoot
                        decorative="decorative"
                        orientation="vertical"
                        style="margin: 0 15px;"
                    ></div>
                    <div class="Text">Docs</div>
                    <div
                        class="SeparatorRoot"
                        rdxSeparatorRoot
                        decorative="decorative"
                        orientation="vertical"
                        style="margin: 0 15px;"
                    ></div>
                    <div class="Text">Source</div>
                </div>
            </div>
        `
    })
};

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/separator/__tests__/separator.directive.spec.ts
```typescript
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

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/separator/src/separator.directive.ts
```typescript
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

```
