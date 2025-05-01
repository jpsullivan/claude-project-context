/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/presence/stories/presence-story.componen.ts
```typescript
import { Component, ElementRef, inject, NgZone, OnInit } from '@angular/core';
import { usePresence } from '../src/presence';
import { CollapseContext, transitionCollapsing } from '../src/transitions/transition.collapse';

@Component({
    selector: 'app-presence',
    standalone: true,
    template: `
        <div>
            <button (click)="toggle()">Toggle</button>
            <div class="collapse-content" #collapseContent>Content to be collapsed</div>
        </div>
    `,
    styles: [
        `
            .collapse-content {
                overflow: hidden;
                transition: height 0.5s ease-in-out;
            }
            .collapse:not(.show) {
                display: none;
            }
            .show {
                height: auto;
            }
        `

    ]
})
export class PresenceStoryComponent implements OnInit {
    private elRef = inject(ElementRef);
    private zone = inject(NgZone);

    private element!: HTMLElement;

    private _isCollapsed = false;
    private afterInit = false;

    set collapsed(isCollapsed: boolean) {
        if (this._isCollapsed !== isCollapsed) {
            this._isCollapsed = isCollapsed;
            if (this.afterInit) {
                this.initCollapse(this._isCollapsed, true);
            }
        }
    }

    ngOnInit(): void {
        this.element = this.elRef.nativeElement.querySelector('.collapse-content');
        this.initCollapse(this._isCollapsed, false);
        this.afterInit = true;
    }

    toggle(open: boolean = this._isCollapsed) {
        this.collapsed = !open;
    }

    private initCollapse(collapsed: boolean, animation: boolean): void {
        const options = {
            context: {
                direction: collapsed ? 'hide' : 'show',
                dimension: 'height'
            } as CollapseContext,
            animation
        };

        usePresence(this.zone, this.element, transitionCollapsing, options).subscribe();
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/presence/stories/presence.docs.mdx
````
import { ArgTypes, Canvas, Markdown, Meta } from '@storybook/blocks';

<Meta title="Primitives/Presence" />

# Presence

The `usePresence` function is a utility designed to manage transitions and animations
for DOM elements in an Angular application.
It provides a consistent way to handle animations, ensuring that they run correctly within Angular's zone.

By using `usePresence`, developers can manage transitions and animations in a consistent and performant manner, ensuring that their Angular applications remain responsive and efficient.

## Function Signature

```typescript
export const usePresence = <T>(
  zone: NgZone,
  element: HTMLElement,
  startFn: TransitionStartFn<T>,
  options: TransitionOptions<T>
): Observable<void> => { ... }

```

### Parameters

- `zone` (NgZone): Angular's NgZone service, which is used to manage change detection and ensure that transitions and animations are run outside of Angular's zone, avoiding unnecessary change detection cycles.
- `element` (HTMLElement): The DOM element that the transition will be applied to.
- startFn (`TransitionStartFn<T>`): A function that initiates the transition. It takes the element, the animation flag, and the context as parameters, and returns a cleanup function (TransitionEndFn) to be called when the transition ends.
- options (`TransitionOptions<T>`): An object containing options for the transition.
  - context (T): A context object that provides additional information needed for the transition.
  - animation (boolean): A boolean indicating whether the transition should include animation.
  - state ('stop' | 'continue'): Specifies whether to stop any running transition ('stop') or continue with the current one ('continue'). The default value is 'stop'.
  - transitionTimerDelayMs (number, optional): An optional delay (in milliseconds) to be added to the transition timer. Default value is 5.

## Notes

- Transition Context: The context object can hold any additional data required for the transition. It allows for flexible and reusable transition logic.
- Zone Management: Running transition logic outside Angular's zone prevents unnecessary change detection cycles, improving performance.
- Customizable Delay: The optional transitionTimerDelayMs allows for fine-tuning the transition timing.

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/presence/stories/presence.stories.ts
```typescript
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { PresenceStoryComponent } from './presence-story.componen';

export default {
    title: 'Primitives/Presence',
    decorators: [
        moduleMetadata({
            imports: [PresenceStoryComponent]
        }),
        componentWrapperDecorator(
            (story) =>
                `<div class="radix-themes light light-theme"
                      data-radius="medium"
                      data-scaling="100%">${story}</div>`
        )
    ]
} as Meta;

type Story = StoryObj;

export const Default: Story = {
    render: (args) => ({
        props: args,
        template: `
<app-presence></app-presence>

`
    })
};

```
