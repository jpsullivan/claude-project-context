/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/lib/auth-client.ts
```typescript
import { createAuthClient } from "better-auth/vue";

export const authClient = createAuthClient();

export const {
	signIn,
	signOut,
	signUp,
	useSession,
	forgetPassword,
	resetPassword,
} = authClient;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/lib/auth.ts
```typescript
import Database from "better-sqlite3";
import { betterAuth } from "better-auth";

export const auth = betterAuth({
	database: new Database("./db.sqlite"),
	socialProviders: {
		google: {
			clientId: process.env.GOOGLE_CLIENT_ID || "",
			clientSecret: process.env.GOOGLE_CLIENT_SECRET || "",
		},
	},
	emailAndPassword: {
		enabled: true,
		async sendResetPassword(url, user) {
			console.log("Reset password url:", url);
		},
	},
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/lib/utils.ts
```typescript
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
	return twMerge(clsx(inputs));
}

```
