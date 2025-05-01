/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-rect/src/index.ts
```typescript
export { useRect } from './use-rect';

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-rect/src/use-rect.tsx
```
import * as React from 'react';
import { observeElementRect } from '@radix-ui/rect';

import type { Measurable } from '@radix-ui/rect';

/**
 * Use this custom hook to get access to an element's rect (getBoundingClientRect)
 * and observe it along time.
 */
function useRect(measurable: Measurable | null) {
  const [rect, setRect] = React.useState<DOMRect>();
  React.useEffect(() => {
    if (measurable) {
      const unobserve = observeElementRect(measurable, setRect);
      return () => {
        setRect(undefined);
        unobserve();
      };
    }
    return;
  }, [measurable]);
  return rect;
}

export { useRect };

```
