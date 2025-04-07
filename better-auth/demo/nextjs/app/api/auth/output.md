/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/app/api/auth/[...all]/route.ts
```typescript
import { auth } from "@/lib/auth";
import { toNextJsHandler } from "better-auth/next-js";
import { NextRequest } from "next/server";

export const { GET } = toNextJsHandler(auth);

export const POST = async (req: NextRequest) => {
	const res = await auth.handler(req);
	return res;
};

```
