/Users/josh/Documents/GitHub/better-auth/better-auth/examples/tanstack-example/app/lib/auth-client.ts
```typescript
import { twoFactorClient } from "better-auth/client/plugins";
import { createAuthClient } from "better-auth/react";

export const { useSession, signIn, signOut, signUp, twoFactor } =
	createAuthClient({
		baseURL: "http://localhost:3000",
		plugins: [twoFactorClient()],
	});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/tanstack-example/app/lib/auth.ts
```typescript
import { twoFactor } from "better-auth/plugins";
import { betterAuth } from "better-auth";
import Database from "better-sqlite3";

export const auth = betterAuth({
	database: new Database("data.db"),
	emailAndPassword: {
		enabled: true,
	},
	socialProviders: {
		discord: {
			enabled: true,
			clientId: process.env.DISCORD_CLIENT_ID!,
			clientSecret: process.env.DISCORD_CLIENT_SECRET!,
		},
		github: {
			enabled: true,
			clientId: process.env.GITHUB_CLIENT_ID!,
			clientSecret: process.env.GITHUB_CLIENT_SECRET!,
		},
	},
	plugins: [twoFactor()],
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/tanstack-example/app/lib/utils.ts
```typescript
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
	return twMerge(clsx(inputs));
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/tanstack-example/app/lib/style/global.css
```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
	:root {
		--background: 0 0% 100%;
		--foreground: 222.2 47.4% 11.2%;

		--muted: 210 40% 96.1%;
		--muted-foreground: 215.4 16.3% 46.9%;

		--popover: 0 0% 100%;
		--popover-foreground: 222.2 47.4% 11.2%;

		--border: 214.3 31.8% 91.4%;
		--input: 214.3 31.8% 91.4%;

		--card: 0 0% 100%;
		--card-foreground: 222.2 47.4% 11.2%;

		--primary: 222.2 47.4% 11.2%;
		--primary-foreground: 210 40% 98%;

		--secondary: 210 40% 96.1%;
		--secondary-foreground: 222.2 47.4% 11.2%;

		--accent: 210 40% 96.1%;
		--accent-foreground: 222.2 47.4% 11.2%;

		--destructive: 0 100% 50%;
		--destructive-foreground: 210 40% 98%;

		--ring: 215 20.2% 65.1%;

		--radius: 0.5rem;
	}

	.dark {
		--background: 224 71% 4%;
		--foreground: 213 31% 91%;

		--muted: 223 47% 11%;
		--muted-foreground: 215.4 16.3% 56.9%;

		--accent: 216 34% 17%;
		--accent-foreground: 210 40% 98%;

		--popover: 224 71% 4%;
		--popover-foreground: 215 20.2% 65.1%;

		--border: 216 34% 17%;
		--input: 216 34% 17%;

		--card: 224 71% 4%;
		--card-foreground: 213 31% 91%;

		--primary: 210 40% 98%;
		--primary-foreground: 222.2 47.4% 1.2%;

		--secondary: 222.2 47.4% 11.2%;
		--secondary-foreground: 210 40% 98%;

		--destructive: 0 63% 31%;
		--destructive-foreground: 210 40% 98%;

		--ring: 216 34% 17%;

		--radius: 0.5rem;
	}
}

@layer base {
	* {
		@apply border-border;
	}
	body {
		@apply bg-background text-foreground;
		font-feature-settings: "rlig" 1, "calt" 1;
	}
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/tanstack-example/app/lib/icons/X.tsx
```
import { X } from "lucide-react-native";
import { iconWithClassName } from "./iconWithClassName";
iconWithClassName(X);
export { X };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/tanstack-example/app/lib/icons/iconWithClassName.ts
```typescript
import type { LucideIcon } from "lucide-react-native";
import { cssInterop } from "nativewind";

export function iconWithClassName(icon: LucideIcon) {
	cssInterop(icon, {
		className: {
			target: "style",
			nativeStyleToProp: {
				color: true,
				opacity: true,
			},
		},
	});
}

```
