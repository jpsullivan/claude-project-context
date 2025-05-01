/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/aspect-ratio/src/aspect-ratio.test.tsx
```
import { axe } from 'vitest-axe';
import type { RenderResult } from '@testing-library/react';
import { cleanup, render } from '@testing-library/react';
import { AspectRatio } from './aspect-ratio';
import { afterEach, describe, it, beforeEach, expect } from 'vitest';

const RATIO = 1 / 2;

describe('given a default Arrow', () => {
  let rendered: RenderResult;

  afterEach(cleanup);

  beforeEach(() => {
    rendered = render(
      <div style={{ width: 500 }}>
        <AspectRatio ratio={RATIO}>
          <span>Hello</span>
        </AspectRatio>
      </div>
    );
  });

  it('should have no accessibility violations', async () => {
    expect(await axe(rendered.container)).toHaveNoViolations();
  });
});

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/aspect-ratio/src/aspect-ratio.tsx
```
import * as React from 'react';
import { Primitive } from '@radix-ui/react-primitive';

/* -------------------------------------------------------------------------------------------------
 * AspectRatio
 * -----------------------------------------------------------------------------------------------*/

const NAME = 'AspectRatio';

type AspectRatioElement = React.ElementRef<typeof Primitive.div>;
type PrimitiveDivProps = React.ComponentPropsWithoutRef<typeof Primitive.div>;
interface AspectRatioProps extends PrimitiveDivProps {
  ratio?: number;
}

const AspectRatio = React.forwardRef<AspectRatioElement, AspectRatioProps>(
  (props, forwardedRef) => {
    const { ratio = 1 / 1, style, ...aspectRatioProps } = props;
    return (
      <div
        style={{
          // ensures inner element is contained
          position: 'relative',
          // ensures padding bottom trick maths works
          width: '100%',
          paddingBottom: `${100 / ratio}%`,
        }}
        data-radix-aspect-ratio-wrapper=""
      >
        <Primitive.div
          {...aspectRatioProps}
          ref={forwardedRef}
          style={{
            ...style,
            // ensures children expand in ratio
            position: 'absolute',
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
          }}
        />
      </div>
    );
  }
);

AspectRatio.displayName = NAME;

/* -----------------------------------------------------------------------------------------------*/

const Root = AspectRatio;

export {
  AspectRatio,
  //
  Root,
};
export type { AspectRatioProps };

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/aspect-ratio/src/index.ts
```typescript
export {
  AspectRatio,
  //
  Root,
} from './aspect-ratio';
export type { AspectRatioProps } from './aspect-ratio';

```
