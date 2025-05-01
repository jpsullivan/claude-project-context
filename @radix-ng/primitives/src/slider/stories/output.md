/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/slider/stories/slider.docs.mdx
````
import { ArgTypes, Canvas, Meta } from '@storybook/blocks';
import * as SliderStories from './slider.stories';
import { RdxSliderRootComponent } from '../src/slider-root.component';

<Meta title="Primitives/Slider" />

# Slider

#### An input where the user selects a value from within a given range.

<Canvas sourceState="hidden" of={SliderStories.Default} />

## Features

- ✅ Can be controlled or uncontrolled.
- ✅ Supports multiple thumbs.
- ✅ Supports a minimum value between thumbs.
- ✅ Supports touch or click on track to update value.
- ✅ Supports Right to Left direction.
- ✅ Full keyboard navigation.

## Anatomy

Import all parts and piece them together.


```html
<rdx-slider>
    <rdx-slider-track >
        <rdx-slider-range />
    </rdx-slider-track>
    <rdx-slider-thumb />
</rdx-slider>
```

## API Reference

<ArgTypes of={RdxSliderRootComponent} />

## Accessibility
Adheres to the [Slider WAI-ARIA design pattern](https://www.w3.org/WAI/ARIA/apg/patterns/slider-multithumb).


````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/slider/stories/slider.stories.ts
```typescript
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { RdxSliderRangeComponent } from '../src/slider-range.component';
import { RdxSliderRootComponent } from '../src/slider-root.component';
import { RdxSliderThumbComponent } from '../src/slider-thumb.component';
import { RdxSliderTrackComponent } from '../src/slider-track.component';

const html = String.raw;

export default {
    title: 'Primitives/Slider',
    decorators: [
        moduleMetadata({
            imports: [
                RdxSliderRootComponent,
                RdxSliderTrackComponent,
                RdxSliderRangeComponent,
                RdxSliderThumbComponent
            ]
        }),
        componentWrapperDecorator(
            (story) => html`
                <div class="radix-themes light light-theme" data-radius="medium" data-scaling="100%">
                    ${story}

                    <style>
                        /*Look at root main.scss*/
                    </style>
                </div>
            `
        )
    ]
} as Meta;

type Story = StoryObj;

export const Default: Story = {
    render: (args) => ({
        props: args,
        template: html`
            <rdx-slider styleClass="SliderRoot" [modelValue]="[45]" [step]="5">
                <rdx-slider-track class="SliderTrack">
                    <rdx-slider-range class="SliderRange" />
                </rdx-slider-track>
                <rdx-slider-thumb class="SliderThumb" />
            </rdx-slider>
        `
    })
};

export const Inverted: Story = {
    render: (args) => ({
        props: args,
        template: html`
            <rdx-slider styleClass="SliderRoot" inverted [modelValue]="[45]" [step]="5">
                <rdx-slider-track class="SliderTrack">
                    <rdx-slider-range class="SliderRange" />
                </rdx-slider-track>
                <rdx-slider-thumb class="SliderThumb" />
            </rdx-slider>
        `
    })
};

export const Thumbs: Story = {
    render: (args) => ({
        props: args,
        template: html`
            <rdx-slider styleClass="SliderRoot" [modelValue]="[45, 80]" [step]="5">
                <rdx-slider-track class="SliderTrack">
                    <rdx-slider-range class="SliderRange" />
                </rdx-slider-track>
                <rdx-slider-thumb class="SliderThumb" />
                <rdx-slider-thumb class="SliderThumb" />
            </rdx-slider>
        `
    })
};

export const Vertical: Story = {
    render: (args) => ({
        props: args,
        template: html`
            <rdx-slider styleClass="SliderRootV" [orientation]="'vertical'" [modelValue]="[45]" [step]="5">
                <rdx-slider-track class="SliderTrackV">
                    <rdx-slider-range class="SliderRangeV" />
                </rdx-slider-track>
                <rdx-slider-thumb class="SliderThumbV" />
            </rdx-slider>

            <rdx-slider styleClass="SliderRoot" [orientation]="'horizontal'" [modelValue]="[45]" [step]="5">
                <rdx-slider-track class="SliderTrack">
                    <rdx-slider-range class="SliderRange" />
                </rdx-slider-track>
                <rdx-slider-thumb class="SliderThumb" />
            </rdx-slider>
        `
    })
};

export const VerticalInverted: Story = {
    render: (args) => ({
        props: args,
        template: html`
            <rdx-slider
                styleClass="SliderRootV"
                style="display: flex; height: 200px;"
                inverted
                [orientation]="'vertical'"
                [modelValue]="[45]"
                [step]="5"
            >
                <rdx-slider-track class="SliderTrackV">
                    <rdx-slider-range class="SliderRangeV" />
                </rdx-slider-track>
                <rdx-slider-thumb class="SliderThumbV" />
            </rdx-slider>
        `
    })
};

```
