/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/libs/auth-client.ts
```typescript
import { passkeyClient, twoFactorClient } from "better-auth/client/plugins";
import { createAuthClient } from "better-auth/solid";
import { createAuthClient as createVanillaClient } from "better-auth/client";
export const {
	signIn,
	signOut,
	useSession,
	signUp,
	passkey: passkeyActions,
	useListPasskeys,
	twoFactor: twoFactorActions,
	$Infer,
	updateUser,
	changePassword,
	revokeSession,
	revokeSessions,
} = createAuthClient({
	baseURL:
		process.env.NODE_ENV === "development"
			? "http://localhost:3000"
			: undefined,
	plugins: [
		passkeyClient(),
		twoFactorClient({
			twoFactorPage: "/two-factor",
		}),
	],
});

export const { useSession: useVanillaSession } = createVanillaClient({
	baseURL:
		process.env.NODE_ENV === "development"
			? "http://localhost:3000"
			: undefined,
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/libs/cn.ts
```typescript
import type { ClassValue } from "clsx";
import clsx from "clsx";
import { twMerge } from "tailwind-merge";

export const cn = (...classLists: ClassValue[]) => twMerge(clsx(classLists));

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/libs/types.ts
```typescript
import type { $Infer } from "./auth-client";

export type ActiveSession = typeof $Infer.Session;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/libs/utils.ts
```typescript
export async function convertImageToBase64(file: File): Promise<string> {
	return new Promise((resolve, reject) => {
		const reader = new FileReader();
		reader.onloadend = () => resolve(reader.result as string);
		reader.onerror = reject;
		reader.readAsDataURL(file);
	});
}

```
