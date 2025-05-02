/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/src/index.ts
```typescript
// this file can't be empty, otherwise the build will fail
export default true;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/src/test-setup.ts
```typescript
import '@testing-library/jest-dom';
import { setupZoneTestEnv } from 'jest-preset-angular/setup-env/zone';

setupZoneTestEnv();

import { toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

```
