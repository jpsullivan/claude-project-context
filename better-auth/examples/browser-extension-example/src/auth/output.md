/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/auth/auth-client.ts
```typescript
import { createAuthClient } from "better-auth/react";

export const authClient = createAuthClient({
	baseURL: "http://localhost:3000" /* base url of your Better Auth backend. */,
	plugins: [],
});

```
