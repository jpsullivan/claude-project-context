/Users/josh/Documents/GitHub/better-auth/better-auth/examples/remix-example/app/lib/auth-client.ts
```typescript
import { createAuthClient } from "better-auth/react";
import { passkeyClient, twoFactorClient } from "better-auth/client/plugins";

export const authClient = createAuthClient({
	plugins: [passkeyClient(), twoFactorClient()],
});

export const { signIn, signUp, signOut, useSession } = authClient;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/remix-example/app/lib/auth-types.ts
```typescript
import { authClient } from "./auth-client";

export type Session = typeof authClient.$Infer.Session;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/remix-example/app/lib/auth.ts
```typescript
import { betterAuth } from "better-auth";
import Database from "better-sqlite3";
import { twoFactor, passkey } from "better-auth/plugins";

export const auth = betterAuth({
	database: new Database("./sqlite.db"),
	emailAndPassword: {
		enabled: true,
		sendEmailVerificationOnSignUp: true,
		async sendVerificationEmail() {
			console.log("Send email to verify email address");
		},
		async sendResetPassword(url, user) {
			console.log("Send email to reset password");
		},
	},
	socialProviders: {
		google: {
			clientId: process.env.GOOGLE_CLIENT_ID || "",
			clientSecret: process.env.GOOGLE_CLIENT_SECRET || "",
		},
		github: {
			clientId: process.env.GITHUB_CLIENT_ID || "",
			clientSecret: process.env.GITHUB_CLIENT_SECRET || "",
		},
		discord: {
			clientId: process.env.DISCORD_CLIENT_ID || "",
			clientSecret: process.env.DISCORD_CLIENT_SECRET || "",
		},
	},
	plugins: [twoFactor(), passkey()],
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/remix-example/app/lib/utils.ts
```typescript
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
	return twMerge(clsx(inputs));
}

```
