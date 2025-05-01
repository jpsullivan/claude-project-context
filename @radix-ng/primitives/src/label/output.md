/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/label/README.md
```
# @radix-ng/primitives/label

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/label/index.ts
```typescript
export * from './src/label.directive';

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/label/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/label/stories/label.docs.mdx
````
import { ArgTypes, Canvas, Meta } from '@storybook/blocks';
import { RdxLabelDirective } from '../src/label.directive';
import * as LabelDirectiveStories from './label.stories';

<Meta title="Primitives/Label" />

# Label

#### Renders an accessible label associated with controls.

<Canvas sourceState="hidden" of={LabelDirectiveStories.Default} />

## Features

- ✅ Text selection is prevented when double-clicking label.

## Import

Get started with importing the directive:

```typescript
import { RdxLabelDirective } from '@radix-ng/primitives/label';
```

## Examples

```html
<label rdxLabel htmlFor="uniqId">First name</label>
<input class="Input" id="uniqId" type="text" />
```

## API Reference

<ArgTypes of={RdxLabelDirective} />

## Accessibility

This component is based on the native `label` element, it will automatically apply the correct labelling
when wrapping controls or using the `for` attribute. For your own custom controls
to work correctly, ensure they use native elements such as `button` or `input` as a base.

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/label/stories/label.stories.ts
```typescript
import { CommonModule } from '@angular/common';
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { labelExclude } from '../../../../apps/storybook-radix/docs/utils/storybook';
import { RdxLabelDirective } from '../src/label.directive';

export default {
    component: RdxLabelDirective,
    title: 'Primitives/Label',
    parameters: {
        controls: {
            exclude: labelExclude
        }
    },
    decorators: [
        moduleMetadata({
            imports: [RdxLabelDirective, CommonModule]
        }),
        componentWrapperDecorator(
            (story) =>
                `<div class="radix-themes light light-theme"
                      data-radius="medium"
                      data-scaling="100%">${story}</div>`
        )
    ]
} as Meta<RdxLabelDirective>;

type Story = StoryObj<RdxLabelDirective>;

export const Default: Story = {
    render: (args) => ({
        props: {
            ...args
        },
        template: `
<label rdxLabel htmlFor="uniqId">First Name </label>
<input type="text" class="Input" id="uniqId" />

<style>
input {
  all: unset;
}

.Input {
  width: 200px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  padding: 0 10px;
  margin-left: 10px;
  height: 35px;
  font-size: 15px;
  line-height: 1;
  color: white;
  background-color: var(--black-a5);
  box-shadow: 0 0 0 1px var(--black-a9);
}

.Input:focus {
  box-shadow: 0 0 0 2px black;
}
.Input::selection {
  background-color: var(--black-a9);
  color: white;
}

label {
    color: white;
    font-size: 15px;
    line-height: 35px;
    font-weight: 500;
}
</style>
`
    })
};

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/label/__tests__/label-root.directive.spec.ts
```typescript
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

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/label/src/label.directive.ts
```typescript
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

```
