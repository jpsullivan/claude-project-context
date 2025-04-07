/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/custom-session/client.ts
```typescript
import { InferServerPlugin } from "../../client/plugins";
import type { BetterAuthOptions } from "../../types";

export const customSessionClient = <
	A extends {
		options: BetterAuthOptions;
	},
>() => {
	return InferServerPlugin<A, "custom-session">();
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/custom-session/custom-session.test.ts
```typescript
import { describe, expect, it } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";
import { customSession } from ".";
import { admin } from "../admin";
import { createAuthClient } from "../../client";
import { customSessionClient } from "./client";
import type { BetterAuthOptions } from "../../types";
import { adminClient } from "../admin/client";

describe("Custom Session Plugin Tests", async () => {
	const options = {
		plugins: [admin()],
	} satisfies BetterAuthOptions;
	const { auth, signInWithTestUser, testUser, customFetchImpl } =
		await getTestInstance({
			plugins: [
				...options.plugins,
				customSession(async ({ user, session }) => {
					const newData = {
						message: "Hello, World!",
					};
					return {
						user: {
							firstName: user.name.split(" ")[0],
							lastName: user.name.split(" ")[1],
						},
						newData,
						session,
					};
				}, options),
			],
		});

	const client = createAuthClient({
		baseURL: "http://localhost:3000",
		plugins: [customSessionClient<typeof auth>(), adminClient()],
		fetchOptions: { customFetchImpl },
	});

	it("should return the session", async () => {
		const { headers } = await signInWithTestUser();
		const session = await auth.api.getSession({ headers });
		const s = await client.getSession({ fetchOptions: { headers } });
		expect(s.data?.newData).toEqual({ message: "Hello, World!" });
		expect(session?.newData).toEqual({ message: "Hello, World!" });
	});

	it("should return set cookie headers", async () => {
		const { headers } = await signInWithTestUser();
		await client.getSession({
			fetchOptions: {
				headers,
				onResponse(context) {
					expect(context.response.headers.get("set-cookie")).toBeDefined();
				},
			},
		});
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/custom-session/index.ts
```typescript
import { z } from "zod";
import { createAuthEndpoint, getSession } from "../../api";
import type {
	BetterAuthOptions,
	BetterAuthPlugin,
	InferSession,
	InferUser,
} from "../../types";

export const customSession = <
	Returns extends Record<string, any>,
	O extends BetterAuthOptions = BetterAuthOptions,
>(
	fn: (session: {
		user: InferUser<O>;
		session: InferSession<O>;
	}) => Promise<Returns>,
	options?: O,
) => {
	return {
		id: "custom-session",
		endpoints: {
			getSession: createAuthEndpoint(
				"/get-session",
				{
					method: "GET",
					metadata: {
						CUSTOM_SESSION: true,
					},
					query: z.optional(
						z.object({
							/**
							 * If cookie cache is enabled, it will disable the cache
							 * and fetch the session from the database
							 */
							disableCookieCache: z
								.boolean({
									description:
										"Disable cookie cache and fetch session from database",
								})
								.or(z.string().transform((v) => v === "true"))
								.optional(),
							disableRefresh: z
								.boolean({
									description:
										"Disable session refresh. Useful for checking session status, without updating the session",
								})
								.optional(),
						}),
					),
					requireHeaders: true,
				},
				async (ctx) => {
					const session = await getSession()({
						...ctx,
						asResponse: false,
						headers: ctx.headers,
						returnHeaders: true,
					}).catch((e) => {
						return null;
					});
					if (!session?.response) {
						return ctx.json(null);
					}
					const fnResult = await fn(session.response as any);
					session.headers.forEach((value, key) => {
						ctx.setHeader(key, value);
					});
					return ctx.json(fnResult);
				},
			),
		},
	} satisfies BetterAuthPlugin;
};

```
