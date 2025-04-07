/Users/josh/Documents/GitHub/better-auth/better-auth/examples/tanstack-example/app/routes/api/auth/$.ts
```typescript
import { createAPIFileRoute } from "@tanstack/start/api";
import { auth } from "~/lib/auth";

export const APIRoute = createAPIFileRoute("/api/auth/$")({
	GET: ({ request }) => {
		return auth.handler(request);
	},
	POST: ({ request }) => {
		return auth.handler(request);
	},
});

```
