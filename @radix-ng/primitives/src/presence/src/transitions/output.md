/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/presence/src/transitions/transition.collapse.ts
```typescript
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

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/presence/src/transitions/transition.toast.ts
```typescript
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

```
