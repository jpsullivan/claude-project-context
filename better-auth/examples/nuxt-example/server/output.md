/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/server/tsconfig.json
```json
{
	"extends": "../.nuxt/tsconfig.server.json"
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/server/api/auth/[...all].ts
```typescript
import { auth } from "~/lib/auth";

export default defineEventHandler((event) => {
	return auth.handler(toWebRequest(event));
});

```
