/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/accessible-icon/src/accesible-icon.test.tsx
```
import React from 'react';
import { axe } from 'vitest-axe';
import type { RenderResult } from '@testing-library/react';
import { cleanup, render } from '@testing-library/react';
import { AccessibleIcon } from './accessible-icon';
import { afterEach, describe, it, beforeEach, vi, expect } from 'vitest';

const LABEL_TEXT = 'Close';

const AccessibleIconTest = (props: Omit<React.ComponentProps<typeof AccessibleIcon>, 'label'>) => (
  <AccessibleIcon {...props} label={LABEL_TEXT} />
);

describe('given a default AccessibleIcon', () => {
  let rendered: RenderResult;
  let label: HTMLElement;

  afterEach(cleanup);

  beforeEach(() => {
    rendered = render(
      <AccessibleIconTest>
        <svg
          viewBox="0 0 32 32"
          width={24}
          height={24}
          fill="none"
          stroke="currentColor"
          data-testid="icon"
        >
          <path d="M2 30 L30 2 M30 30 L2 2" />
        </svg>
      </AccessibleIconTest>
    );

    label = rendered.getByText(LABEL_TEXT);
  });

  it('should have no accessibility violations', async () => {
    expect(await axe(rendered.container)).toHaveNoViolations();
  });

  it('should have a label', () => {
    expect(label).toBeInTheDocument();
  });

  it('should add an aria-hidden attribute to the child', () => {
    const svg = rendered.getByTestId('icon');
    expect(svg.getAttribute('aria-hidden')).toBe('true');
  });

  it('should set focusable attribute on the child to false', () => {
    const svg = rendered.getByTestId('icon');
    expect(svg.getAttribute('focusable')).toBe('false');
  });
});

describe('given an AccessibleIcon without children', () => {
  it('should error', () => {
    // Even though the error is caught, it still gets printed to the console
    // so we mock that out to avoid the wall of red text.
    const spy = vi.spyOn(console, 'error');
    spy.mockImplementation(() => {});

    expect(() => render(<AccessibleIconTest />)).toThrowError();

    spy.mockRestore();
  });
});

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/accessible-icon/src/accessible-icon.tsx
```
import * as React from 'react';
import * as VisuallyHiddenPrimitive from '@radix-ui/react-visually-hidden';

const NAME = 'AccessibleIcon';

interface AccessibleIconProps {
  children?: React.ReactNode;
  /**
   * The accessible label for the icon. This label will be visually hidden but announced to screen
   * reader users, similar to `alt` text for `img` tags.
   */
  label: string;
}

const AccessibleIcon: React.FC<AccessibleIconProps> = ({ children, label }) => {
  const child = React.Children.only(children);
  return (
    <>
      {React.cloneElement(child as React.ReactElement<React.SVGAttributes<SVGElement>>, {
        // accessibility
        'aria-hidden': 'true',
        focusable: 'false', // See: https://allyjs.io/tutorials/focusing-in-svg.html#making-svg-elements-focusable
      })}
      <VisuallyHiddenPrimitive.Root>{label}</VisuallyHiddenPrimitive.Root>
    </>
  );
};

AccessibleIcon.displayName = NAME;

const Root = AccessibleIcon;

export {
  AccessibleIcon,
  //
  Root,
};
export type { AccessibleIconProps };

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/accessible-icon/src/index.ts
```typescript
export {
  AccessibleIcon,
  //
  Root,
} from './accessible-icon';
export type { AccessibleIconProps } from './accessible-icon';

```
