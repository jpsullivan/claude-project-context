/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/api/auth/[...all].ts
```typescript
import type { APIRoute } from "astro";
import { auth } from "../../../auth";

export const GET: APIRoute = async (ctx) => {
	return auth.handler(ctx.request);
};

export const ALL: APIRoute = async (ctx) => {
	return auth.handler(ctx.request);
};

```
