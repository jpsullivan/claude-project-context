/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/middleware/auth.global.ts
```typescript
import { authClient } from "~/lib/auth-client";

export default defineNuxtRouteMiddleware(async (to, from) => {
	const { data: session } = await authClient.useSession(useFetch);
	if (!session.value) {
		if (to.path === "/dashboard") {
			return navigateTo("/");
		}
	}
});

```
