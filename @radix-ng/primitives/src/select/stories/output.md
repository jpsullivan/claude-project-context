/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/select/stories/select.docs.mdx
````
import { ArgTypes, Canvas, Meta } from '@storybook/blocks';
import * as SelectStories from './select.stories';
import { RdxSelectComponent } from '../src/select.component';
import { RdxSelectItemDirective } from '../src/select-item.directive';
import { RdxSelectTriggerDirective } from '../src/select-trigger.directive';
import { RdxSelectContentDirective } from '../src/select-content.directive';

<Meta title="Primitives/Select" />

# Select

#### A vertically stacked set of interactive headings that each reveal an associated section of content.

## Single

<Canvas sourceState="hidden" of={SelectStories.Default} />

## Features

- ✅ Can be controlled or uncontrolled.
- ✅ Offers 2 positioning modes.
- ✅ Supports items, labels, groups of items.
- ✅ Focus is fully managed.
- ✅ Full keyboard navigation.
- ✅ Supports custom placeholder.
- ✅ Typeahead support.
- ✅ Supports Right to Left direction.

## Anatomy

```html
<div rdxSelectRoot>
    <div rdxSelectContent>
        <div rdxSelectItem></div>
    </div>
</div>
```

## Import

Get started with importing the directives:

```typescript
import {
  RdxAccordionRootDirective,
  RdxAccordionItemDirective,
  RdxAccordionTriggerDirective,
  RdxAccordionContentDirective
} from '@radix-ng/primitives/select';
```

## API Reference

### Root
`RdxSelectComponent`

<ArgTypes of={RdxSelectComponent} />

### Item
`RdxSelectItemDirective`

<ArgTypes of={RdxSelectItemDirective} />

### Trigger
`RdxSelectTriggerDirective`

<ArgTypes of={RdxSelectTriggerDirective} />

### Content
`RdxSelectContentDirective`

<ArgTypes of={RdxSelectContentDirective} />

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/select/stories/select.stories.ts
```typescript
import { BrowserAnimationsModule, provideAnimations } from '@angular/platform-browser/animations';
import {
    RdxSelectComponent,
    RdxSelectContentDirective,
    RdxSelectGroupDirective,
    RdxSelectIconDirective,
    RdxSelectItemDirective,
    RdxSelectItemIndicatorDirective,
    RdxSelectLabelDirective,
    RdxSelectSeparatorDirective,
    RdxSelectTriggerDirective,
    RdxSelectValueDirective
} from '@radix-ng/primitives/select';
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { Check, ChevronDown, LucideAngularModule } from 'lucide-angular';

const html = String.raw;

export default {
    title: 'Primitives/Select',
    decorators: [
        moduleMetadata({
            imports: [
                RdxSelectComponent,
                RdxSelectSeparatorDirective,
                RdxSelectLabelDirective,
                RdxSelectItemIndicatorDirective,
                RdxSelectItemDirective,
                RdxSelectGroupDirective,
                BrowserAnimationsModule,
                RdxSelectContentDirective,
                RdxSelectTriggerDirective,
                RdxSelectValueDirective,
                RdxSelectIconDirective,
                LucideAngularModule,
                LucideAngularModule.pick({ ChevronDown, Check })
            ],
            providers: [provideAnimations()]
        }),
        componentWrapperDecorator(
            (story) => html`
                <div
                    class="radix-themes light light-theme radix-themes-default-fonts"
                    data-accent-color="indigo"
                    data-radius="medium"
                    data-scaling="100%"
                >
                    ${story}
                </div>

                <style>
                    /* reset */
                    button {
                        all: unset;
                    }

                    .SelectTrigger {
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        border-radius: 4px;
                        padding: 0 15px;
                        font-size: 13px;
                        line-height: 1;
                        height: 35px;
                        gap: 5px;
                        background-color: white;
                        color: var(--violet-11);
                        box-shadow: 0 2px 10px var(--black-a7);
                    }
                    .SelectTrigger:hover {
                        background-color: var(--mauve-3);
                    }
                    .SelectTrigger:focus {
                        box-shadow: 0 0 0 2px black;
                    }
                    .SelectTrigger[data-placeholder] {
                        color: var(--violet-9);
                    }

                    .SelectIcon {
                        color: Var(--violet-11);
                    }

                    .SelectContent {
                        overflow: hidden;
                        background-color: white;
                        border-radius: 6px;
                        box-shadow:
                            0px 10px 38px -10px rgba(22, 23, 24, 0.35),
                            0px 10px 20px -15px rgba(22, 23, 24, 0.2);
                    }

                    .SelectViewport {
                        padding: 5px;
                    }

                    .SelectItem {
                        font-size: 13px;
                        line-height: 1;
                        color: var(--violet-11);
                        border-radius: 3px;
                        display: flex;
                        align-items: center;
                        height: 25px;
                        padding: 0 35px 0 25px;
                        position: relative;
                        user-select: none;
                    }
                    .SelectItem[data-disabled] {
                        color: var(--mauve-8);
                        pointer-events: none;
                    }
                    .SelectItem[data-highlighted] {
                        outline: none;
                        background-color: var(--violet-9);
                        color: var(--violet-1);
                    }

                    .SelectLabel {
                        padding: 0 25px;
                        font-size: 12px;
                        line-height: 25px;
                        color: var(--mauve-11);
                    }

                    .SelectSeparator {
                        height: 1px;
                        background-color: var(--violet-6);
                        margin: 5px;
                    }

                    .SelectItemIndicator {
                        position: absolute;
                        left: 0;
                        width: 25px;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                    }

                    .SelectScrollButton {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        height: 25px;
                        background-color: white;
                        color: var(--violet-11);
                        cursor: default;
                    }
                </style>
            `
        )
    ]
} as Meta;

type Story = StoryObj;

export const Default: Story = {
    args: {
        foodGroups: [
            {
                label: 'Fruits',
                foods: [
                    { value: 'apple', label: 'Apple' },
                    { value: 'banana', label: 'Banana' },
                    { value: 'blueberry', label: 'Blueberry' },
                    { value: 'grapes', label: 'Grapes' },
                    { value: 'pineapple', label: 'Pineapple' }
                ]
            },
            {
                label: 'Vegetables',
                foods: [
                    { value: 'aubergine', label: 'Aubergine' },
                    { value: 'broccoli', label: 'Broccoli' },
                    { value: 'carrot', label: 'Carrot', disabled: true },
                    { value: 'courgette', label: 'Courgette' },
                    { value: 'leek', label: 'Leek' }
                ]
            },
            {
                label: 'Meat',
                foods: [
                    { value: 'beef', label: 'Beef' },
                    { value: 'beef-with-sauce', label: 'Beef with sauce' },
                    { value: 'chicken', label: 'Chicken' },
                    { value: 'lamb', label: 'Lamb' },
                    { value: 'pork', label: 'Pork' }
                ]
            },
            {
                foods: [
                    { value: 'candies', label: 'Candies' },
                    { value: 'chocolates', label: 'Chocolates' }
                ]
            }
        ]
    },
    render: (args) => ({
        props: args,
        template: html`
            <span rdxSelect>
                <button class="SelectTrigger" rdxSelectTrigger>
                    <span rdxSelectValue placeholder="Select a fruit…"></span>
                    <lucide-icon class="SelectIcon" size="16" name="chevron-down" rdxSelectIcon />
                </button>
                <div class="SelectContent SelectViewport" rdxSelectContent>
                    @for (group of foodGroups; track group; let last = $last) {
                    <div class="SelectGroup" rdxSelectGroup>
                        <div class="SelectLabel" rdxSelectLabel>{{ group.label }}</div>
                        @for (food of group.foods; track food) {
                        <div class="SelectItem" rdxSelectItem [value]="food.value" [disabled]="food.disabled">
                            <lucide-icon class="SelectItemIndicator" rdxSelectItemIndicator size="16" name="check" />
                            {{ food.label }}
                        </div>
                        }
                    </div>
                    @if (!last) {
                    <div class="SelectSeparator" rdxSelectSeparator></div>
                    } }
                </div>
            </span>
        `
    })
};

```
