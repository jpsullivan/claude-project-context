/Users/josh/Documents/GitHub/better-auth/better-auth/examples/expo-example/src/lib/auth-client.ts
```typescript
import { createAuthClient } from "better-auth/react";
import { expoClient } from "@better-auth/expo/client";
import * as SecureStore from "expo-secure-store";

export const authClient = createAuthClient({
	baseURL: "http://localhost:8081",
	disableDefaultFetchPlugins: true,
	plugins: [
		expoClient({
			scheme: "better-auth",
			storage: SecureStore,
		}),
	],
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/expo-example/src/lib/auth.ts
```typescript
import { betterAuth } from "better-auth";
import { expo } from "@better-auth/expo";
import { Pool } from "pg";

export const auth = betterAuth({
	database: new Pool({
		connectionString: process.env.DATABASE_URL,
	}),
	emailAndPassword: {
		enabled: true,
	},
	plugins: [expo()],
	socialProviders: {
		github: {
			clientId: process.env.GITHUB_CLIENT_ID!,
			clientSecret: process.env.GITHUB_CLIENT_SECRET!,
		},
		google: {
			clientId: process.env.GOOGLE_CLIENT_ID!,
			clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
		},
	},
	trustedOrigins: ["exp://"],
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/expo-example/src/lib/utils.ts
```typescript
import { type ClassValue, clsx } from "clsx";
import { PressableStateCallbackType } from "react-native";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
	return twMerge(clsx(inputs));
}
export function isTextChildren(
	children:
		| React.ReactNode
		| ((state: PressableStateCallbackType) => React.ReactNode),
) {
	return Array.isArray(children)
		? children.every((child) => typeof child === "string")
		: typeof children === "string";
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/expo-example/src/lib/icons/X.tsx
```
import { X } from "lucide-react-native";
import { iconWithClassName } from "./iconWithClassName";
iconWithClassName(X);
export { X };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/expo-example/src/lib/icons/iconWithClassName.ts
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
