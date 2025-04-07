/Users/josh/Documents/GitHub/better-auth/better-auth/examples/expo-example/src/app/api/auth/[...route]+api.ts
```typescript
import { auth } from "@/lib/auth";

export const GET = (request: Request) => {
	return auth.handler(request);
};

export const POST = (request: Request) => {
	return auth.handler(request);
};

```
