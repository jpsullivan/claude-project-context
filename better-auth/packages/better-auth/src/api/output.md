/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/call.test.ts
```typescript
import { describe, expect, it } from "vitest";
import { APIError } from "better-call";
import {
	createAuthEndpoint,
	createAuthMiddleware,
	getEndpoints,
	router,
} from ".";
import { init } from "../init";
import type { BetterAuthOptions, BetterAuthPlugin } from "../types";
import { z } from "zod";
import { createAuthClient } from "../client";
import { bearer } from "../plugins/bearer";

describe("call", async () => {
	const q = z.optional(
		z.object({
			testBeforeHook: z.string().optional(),
			testBeforeGlobal: z.string().optional(),
			testAfterHook: z.string().optional(),
			testAfterGlobal: z.string().optional(),
			testContext: z.string().optional(),
			message: z.string().optional(),
		}),
	);
	const testPlugin = {
		id: "test",
		endpoints: {
			test: createAuthEndpoint(
				"/test",
				{
					method: "GET",
					query: q,
				},
				async (ctx) => {
					return ctx.json({ success: ctx.query?.message || "true" });
				},
			),
			testCookies: createAuthEndpoint(
				"/test/cookies",
				{
					method: "POST",
					query: q,
					body: z.object({
						cookies: z.array(z.object({ name: z.string(), value: z.string() })),
					}),
				},
				async (ctx) => {
					for (const cookie of ctx.body.cookies) {
						ctx.setCookie(cookie.name, cookie.value);
					}
					return ctx.json({ success: true });
				},
			),
			testThrow: createAuthEndpoint(
				"/test/throw",
				{
					method: "GET",
					query: q,
				},
				async (ctx) => {
					if (ctx.query?.message === "throw-api-error") {
						throw new APIError("BAD_REQUEST", {
							message: "Test error",
						});
					}
					if (ctx.query?.message === "throw-error") {
						throw new Error("Test error");
					}
					if (ctx.query?.message === "throw redirect") {
						throw ctx.redirect("/test");
					}
					if (ctx.query?.message === "redirect with additional header") {
						ctx.setHeader("key", "value");
						throw ctx.redirect("/test");
					}
					throw new APIError("BAD_REQUEST", {
						message: ctx.query?.message,
					});
				},
			),
		},
	} satisfies BetterAuthPlugin;

	const testPlugin2 = {
		id: "test2",
		hooks: {
			before: [
				{
					matcher(ctx) {
						return ctx.path === "/test";
					},
					handler: createAuthMiddleware(async (ctx) => {
						const query = ctx.query;
						if (!query) {
							return;
						}
						if (query.testBeforeHook) {
							return ctx.json({
								before: "test",
							});
						}
						if (query.testContext) {
							ctx.query = {
								message: query.testContext,
							};
							return {
								context: ctx,
							};
						}
					}),
				},
			],
			after: [
				{
					matcher(ctx) {
						return ctx.path === "/test";
					},
					handler: createAuthMiddleware(async (ctx) => {
						const query = ctx.query?.testAfterHook;
						if (!query) {
							return;
						}

						return ctx.json({
							after: "test",
						});
					}),
				},
				{
					matcher(ctx) {
						return ctx.path === "/test/cookies";
					},
					handler: createAuthMiddleware(async (ctx) => {
						const query = ctx.query?.testAfterHook;
						if (!query) {
							return;
						}
						ctx.setCookie("after", "test");
					}),
				},
				{
					matcher(ctx) {
						return (
							(ctx.path === "/test/throw" &&
								ctx.query?.message === "throw-after-hook") ||
							ctx.query?.message === "throw-chained-hook"
						);
					},
					handler: createAuthMiddleware(async (ctx) => {
						if (ctx.query?.message === "throw-chained-hook") {
							throw new APIError("BAD_REQUEST", {
								message: "from chained hook 1",
							});
						}
						if (ctx.context.returned instanceof APIError) {
							throw ctx.error("BAD_REQUEST", {
								message: "from after hook",
							});
						}
					}),
				},
				{
					matcher(ctx) {
						return (
							ctx.path === "/test/throw" &&
							ctx.query?.message === "throw-chained-hook"
						);
					},
					handler: createAuthMiddleware(async (ctx) => {
						if (ctx.context.returned instanceof APIError) {
							const returned = ctx.context.returned;
							const message = returned.message;
							throw new APIError("BAD_REQUEST", {
								message: message.replace("1", "2"),
							});
						}
					}),
				},
			],
		},
	} satisfies BetterAuthPlugin;
	const options = {
		baseURL: "http://localhost:3000",
		plugins: [testPlugin, testPlugin2, bearer()],
		emailAndPassword: {
			enabled: true,
		},
		hooks: {
			before: createAuthMiddleware(async (ctx) => {
				if (ctx.path === "/sign-up/email") {
					return {
						context: {
							body: {
								...ctx.body,
								email: "changed@email.com",
							},
						},
					};
				}
				if (ctx.query?.testBeforeGlobal) {
					return ctx.json({ before: "global" });
				}
			}),
			after: createAuthMiddleware(async (ctx) => {
				if (ctx.query?.testAfterGlobal) {
					return ctx.json({ after: "global" });
				}
			}),
		},
	} satisfies BetterAuthOptions;
	const authContext = init(options);
	const { api } = getEndpoints(authContext, options);

	const r = router(await authContext, options);
	const client = createAuthClient({
		baseURL: "http://localhost:3000",
		fetchOptions: {
			customFetchImpl: async (url, init) => {
				return r.handler(new Request(url, init));
			},
		},
	});

	it("should call api", async () => {
		const response = await api.test();
		expect(response).toMatchObject({
			success: "true",
		});
	});

	it("should set cookies", async () => {
		const response = await api.testCookies({
			body: {
				cookies: [
					{
						name: "test-cookie",
						value: "test-value",
					},
				],
			},
			returnHeaders: true,
		});
		const setCookies = response.headers.get("set-cookie");
		expect(setCookies).toContain("test-cookie=test-value");
	});

	it("should intercept on before hook", async () => {
		const response = await api.test({
			query: {
				testBeforeHook: "true",
			},
		});
		expect(response).toMatchObject({
			before: "test",
		});
	});

	it("should change context on before hook", async () => {
		const response = await api.test({
			query: {
				testContext: "context-changed",
			},
		});
		expect(response).toMatchObject({
			success: "context-changed",
		});
	});

	it("should intercept on after hook", async () => {
		const response = await api.test({
			query: {
				testAfterHook: "true",
			},
		});
		expect(response).toMatchObject({
			after: "test",
		});
	});

	it("should return Response object", async () => {
		const response = await api.test({
			asResponse: true,
		});
		expect(response).toBeInstanceOf(Response);
	});

	it("should set cookies on after hook", async () => {
		const response = await api.testCookies({
			body: {
				cookies: [
					{
						name: "test-cookie",
						value: "test-value",
					},
				],
			},
			query: {
				testAfterHook: "true",
			},
			returnHeaders: true,
		});
		const setCookies = response.headers.get("set-cookie");
		expect(setCookies).toContain("after=test");
		expect(setCookies).toContain("test-cookie=test-value");
	});

	it("should throw APIError", async () => {
		await expect(
			api.testThrow({
				query: {
					message: "throw-api-error",
				},
			}),
		).rejects.toThrowError(APIError);
	});

	it("should throw Error", async () => {
		await expect(
			api.testThrow({
				query: {
					message: "throw-error",
				},
			}),
		).rejects.toThrowError(Error);
	});

	it("should redirect", async () => {
		await api
			.testThrow({
				query: {
					message: "throw redirect",
				},
			})
			.catch((e) => {
				expect(e).toBeInstanceOf(APIError);

				expect(e.status).toBe("FOUND");
				expect(e.headers.get("Location")).toBe("/test");
			});
	});

	it("should include base headers with redirect", async () => {
		await api
			.testThrow({
				query: {
					message: "redirect with additional header",
				},
			})
			.catch((e) => {
				expect(e).toBeInstanceOf(APIError);
				expect(e.status).toBe("FOUND");
				expect(e.headers.get("Location")).toBe("/test");
				expect(e.headers.get("key")).toBe("value");
			});
	});

	it("should throw from after hook", async () => {
		await api
			.testThrow({
				query: {
					message: "throw-after-hook",
				},
			})
			.catch((e) => {
				expect(e).toBeInstanceOf(APIError);
				expect(e.status).toBe("BAD_REQUEST");
				expect(e.message).toContain("from after hook");
			});
	});

	it("should throw from chained hook", async () => {
		await api
			.testThrow({
				query: {
					message: "throw-chained-hook",
				},
			})
			.catch((e) => {
				expect(e).toBeInstanceOf(APIError);
				expect(e.status).toBe("BAD_REQUEST");
				expect(e.message).toContain("from chained hook 2");
			});
	});

	it("should intercept on global before hook", async () => {
		const response = await api.test({
			query: {
				testBeforeGlobal: "true",
			},
		});
		expect(response).toMatchObject({
			before: "global",
		});
	});

	it("should intercept on global after hook", async () => {
		const response = await api.test({
			query: {
				testAfterGlobal: "true",
			},
		});
		expect(response).toMatchObject({
			after: "global",
		});
	});

	it("global before hook should change the context", async (ctx) => {
		const response = await api.signUpEmail({
			body: {
				email: "my-email@test.com",
				password: "password",
				name: "test",
			},
		});
		const session = await api.getSession({
			headers: new Headers({
				Authorization: `Bearer ${response?.token}`,
			}),
		});
		expect(session?.user.email).toBe("changed@email.com");
	});

	it("should fetch using a client", async () => {
		const response = await client.$fetch("/ok");
		expect(response.data).toMatchObject({
			ok: true,
		});
	});

	it("should fetch using a client with query", async () => {
		const response = await client.$fetch("/test", {
			query: {
				message: "test",
			},
		});
		expect(response.data).toMatchObject({
			success: "test",
		});
	});

	it("should set cookies using a client", async () => {
		await client.$fetch("/test/cookies", {
			method: "POST",
			body: {
				cookies: [
					{
						name: "test-cookie",
						value: "test-value",
					},
				],
			},
			onResponse(context) {
				expect(context.response.headers.get("set-cookie")).toContain(
					"test-cookie=test-value",
				);
			},
		});
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/call.ts
```typescript
import { createEndpoint, createMiddleware } from "better-call";
import type { AuthContext } from "../init";

export const optionsMiddleware = createMiddleware(async () => {
	/**
	 * This will be passed on the instance of
	 * the context. Used to infer the type
	 * here.
	 */
	return {} as AuthContext;
});

export const createAuthMiddleware = createMiddleware.create({
	use: [
		optionsMiddleware,
		/**
		 * Only use for post hooks
		 */
		createMiddleware(async () => {
			return {} as {
				returned?: unknown;
				responseHeaders?: Headers;
			};
		}),
	],
});

export const createAuthEndpoint = createEndpoint.create({
	use: [optionsMiddleware],
});

export type AuthEndpoint = ReturnType<typeof createAuthEndpoint>;
export type AuthMiddleware = ReturnType<typeof createAuthMiddleware>;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/index.ts
```typescript
import { APIError, type Middleware, createRouter } from "better-call";
import type { AuthContext } from "../init";
import type { BetterAuthOptions } from "../types";
import type { UnionToIntersection } from "../types/helper";
import { originCheckMiddleware } from "./middlewares/origin-check";
import {
	callbackOAuth,
	forgetPassword,
	forgetPasswordCallback,
	getSession,
	listSessions,
	resetPassword,
	revokeSession,
	revokeSessions,
	sendVerificationEmail,
	changeEmail,
	signInEmail,
	signInSocial,
	signOut,
	verifyEmail,
	linkSocialAccount,
	revokeOtherSessions,
	listUserAccounts,
	changePassword,
	deleteUser,
	setPassword,
	updateUser,
	deleteUserCallback,
	unlinkAccount,
	refreshToken,
} from "./routes";
import { ok } from "./routes/ok";
import { signUpEmail } from "./routes/sign-up";
import { error } from "./routes/error";
import { logger } from "../utils/logger";
import type { BetterAuthPlugin } from "../plugins";
import { onRequestRateLimit } from "./rate-limiter";
import { toAuthEndpoints } from "./to-auth-endpoints";

export function getEndpoints<
	C extends AuthContext,
	Option extends BetterAuthOptions,
>(ctx: Promise<C> | C, options: Option) {
	const pluginEndpoints = options.plugins?.reduce(
		(acc, plugin) => {
			return {
				...acc,
				...plugin.endpoints,
			};
		},
		{} as Record<string, any>,
	);

	type PluginEndpoint = UnionToIntersection<
		Option["plugins"] extends Array<infer T>
			? T extends BetterAuthPlugin
				? T extends {
						endpoints: infer E;
					}
					? E
					: {}
				: {}
			: {}
	>;

	const middlewares =
		options.plugins
			?.map((plugin) =>
				plugin.middlewares?.map((m) => {
					const middleware = (async (context: any) => {
						return m.middleware({
							...context,
							context: {
								...ctx,
								...context.context,
							},
						});
					}) as Middleware;
					middleware.options = m.middleware.options;
					return {
						path: m.path,
						middleware,
					};
				}),
			)
			.filter((plugin) => plugin !== undefined)
			.flat() || [];

	const baseEndpoints = {
		signInSocial,
		callbackOAuth,
		getSession: getSession<Option>(),
		signOut,
		signUpEmail: signUpEmail<Option>(),
		signInEmail,
		forgetPassword,
		resetPassword,
		verifyEmail,
		sendVerificationEmail,
		changeEmail,
		changePassword,
		setPassword,
		updateUser: updateUser<Option>(),
		deleteUser,
		forgetPasswordCallback,
		listSessions: listSessions<Option>(),
		revokeSession,
		revokeSessions,
		revokeOtherSessions,
		linkSocialAccount,
		listUserAccounts,
		deleteUserCallback,
		unlinkAccount,
		refreshToken,
	};
	const endpoints = {
		...baseEndpoints,
		...pluginEndpoints,
		ok,
		error,
	};
	const api = toAuthEndpoints(endpoints, ctx);
	return {
		api: api as typeof endpoints & PluginEndpoint,
		middlewares,
	};
}

export const router = <C extends AuthContext, Option extends BetterAuthOptions>(
	ctx: C,
	options: Option,
) => {
	const { api, middlewares } = getEndpoints(ctx, options);
	const basePath = new URL(ctx.baseURL).pathname;

	return createRouter(api, {
		routerContext: ctx,
		openapi: {
			disabled: true,
		},
		basePath,
		routerMiddleware: [
			{
				path: "/**",
				middleware: originCheckMiddleware,
			},
			...middlewares,
		],
		async onRequest(req) {
			//handle disabled paths
			const disabledPaths = ctx.options.disabledPaths || [];
			const path = new URL(req.url).pathname.replace(basePath, "");
			if (disabledPaths.includes(path)) {
				return new Response("Not Found", { status: 404 });
			}
			for (const plugin of ctx.options.plugins || []) {
				if (plugin.onRequest) {
					const response = await plugin.onRequest(req, ctx);
					if (response && "response" in response) {
						return response.response;
					}
				}
			}
			return onRequestRateLimit(req, ctx);
		},
		async onResponse(res) {
			for (const plugin of ctx.options.plugins || []) {
				if (plugin.onResponse) {
					const response = await plugin.onResponse(res, ctx);
					if (response) {
						return response.response;
					}
				}
			}
			return res;
		},
		onError(e) {
			if (e instanceof APIError && e.status === "FOUND") {
				return;
			}
			if (options.onAPIError?.throw) {
				throw e;
			}
			if (options.onAPIError?.onError) {
				options.onAPIError.onError(e, ctx);
				return;
			}

			const optLogLevel = options.logger?.level;
			const log =
				optLogLevel === "error" ||
				optLogLevel === "warn" ||
				optLogLevel === "debug"
					? logger
					: undefined;
			if (options.logger?.disabled !== true) {
				if (
					e &&
					typeof e === "object" &&
					"message" in e &&
					typeof e.message === "string"
				) {
					if (
						e.message.includes("no column") ||
						e.message.includes("column") ||
						e.message.includes("relation") ||
						e.message.includes("table") ||
						e.message.includes("does not exist")
					) {
						ctx.logger?.error(e.message);
						return;
					}
				}

				if (e instanceof APIError) {
					if (e.status === "INTERNAL_SERVER_ERROR") {
						ctx.logger.error(e.status, e);
					}
					log?.error(e.message);
				} else {
					ctx.logger?.error(
						e && typeof e === "object" && "name" in e ? (e.name as string) : "",
						e,
					);
				}
			}
		},
	});
};

export * from "./routes";
export * from "./middlewares";
export * from "./call";
export { APIError } from "better-call";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/to-auth-endpoints.test.ts
```typescript
import { describe, expect, it } from "vitest";
import { createAuthEndpoint, createAuthMiddleware } from "./call";
import { toAuthEndpoints } from "./to-auth-endpoints";
import { init } from "../init";
import { z } from "zod";
import { APIError } from "better-call";
import { getTestInstance } from "../test-utils/test-instance";

describe("before hook", async () => {
	describe("context", async () => {
		const endpoints = {
			query: createAuthEndpoint(
				"/query",
				{
					method: "GET",
				},
				async (c) => {
					return c.query;
				},
			),
			body: createAuthEndpoint(
				"/body",
				{
					method: "POST",
				},
				async (c) => {
					return c.body;
				},
			),
			params: createAuthEndpoint(
				"/params",
				{
					method: "GET",
				},
				async (c) => {
					return c.params;
				},
			),
			headers: createAuthEndpoint(
				"/headers",
				{
					method: "GET",
					requireHeaders: true,
				},
				async (c) => {
					return Object.fromEntries(c.headers.entries());
				},
			),
		};

		const authContext = init({
			hooks: {
				before: createAuthMiddleware(async (c) => {
					switch (c.path) {
						case "/body":
							return {
								context: {
									body: {
										name: "body",
									},
								},
							};
						case "/params":
							return {
								context: {
									params: {
										name: "params",
									},
								},
							};
						case "/headers":
							return {
								context: {
									headers: new Headers({
										name: "headers",
									}),
								},
							};
					}
					return {
						context: {
							query: {
								name: "query",
							},
						},
					};
				}),
			},
		});
		const authEndpoints = toAuthEndpoints(endpoints, authContext);

		it("should return hook set query", async () => {
			const res = await authEndpoints.query();
			expect(res?.name).toBe("query");
			const res2 = await authEndpoints.query({
				query: {
					key: "value",
				},
			});
			expect(res2).toMatchObject({
				name: "query",
				key: "value",
			});
		});

		it("should return hook set body", async () => {
			const res = await authEndpoints.body();
			expect(res?.name).toBe("body");
			const res2 = await authEndpoints.body({
				//@ts-expect-error
				body: {
					key: "value",
				},
			});
			expect(res2).toMatchObject({
				name: "body",
				key: "value",
			});
		});

		it("should return hook set param", async () => {
			const res = await authEndpoints.params();
			expect(res?.name).toBe("params");
			const res2 = await authEndpoints.params({
				params: {
					key: "value",
				},
			});
			expect(res2).toMatchObject({
				name: "params",
				key: "value",
			});
		});

		it("should return hook set headers", async () => {
			const res = await authEndpoints.headers({
				headers: new Headers({
					key: "value",
				}),
			});
			expect(res).toMatchObject({ key: "value", name: "headers" });
		});
	});

	describe("response", async () => {
		const endpoints = {
			response: createAuthEndpoint(
				"/response",
				{
					method: "GET",
				},
				async (c) => {
					return { response: true };
				},
			),
			json: createAuthEndpoint(
				"/json",
				{
					method: "GET",
				},
				async (c) => {
					return { response: true };
				},
			),
		};

		const authContext = init({
			hooks: {
				before: createAuthMiddleware(async (c) => {
					if (c.path === "/json") {
						return { before: true };
					}
					return new Response(JSON.stringify({ before: true }));
				}),
			},
		});
		const authEndpoints = toAuthEndpoints(endpoints, authContext);

		it("should return Response object", async () => {
			const response = await authEndpoints.response();
			expect(response).toBeInstanceOf(Response);
		});

		it("should return the hook response", async () => {
			const response = await authEndpoints.json();
			expect(response).toMatchObject({ before: true });
		});
	});
});

describe("after hook", async () => {
	describe("response", async () => {
		const endpoints = {
			changeResponse: createAuthEndpoint(
				"/change-response",
				{
					method: "GET",
				},
				async (c) => {
					return {
						hello: "world",
					};
				},
			),
			throwError: createAuthEndpoint(
				"/throw-error",
				{
					method: "POST",
					query: z
						.object({
							throwHook: z.boolean(),
						})
						.optional(),
				},
				async (c) => {
					throw c.error("BAD_REQUEST");
				},
			),
			multipleHooks: createAuthEndpoint(
				"/multi-hooks",
				{
					method: "GET",
				},
				async (c) => {
					return {
						return: "1",
					};
				},
			),
		};

		const authContext = init({
			plugins: [
				{
					id: "test",
					hooks: {
						after: [
							{
								matcher() {
									return true;
								},
								handler: createAuthMiddleware(async (c) => {
									if (c.path === "/multi-hooks") {
										return {
											return: "3",
										};
									}
								}),
							},
						],
					},
				},
			],
			hooks: {
				after: createAuthMiddleware(async (c) => {
					if (c.path === "/change-response") {
						return {
							hello: "auth",
						};
					}
					if (c.path === "/multi-hooks") {
						return {
							return: "2",
						};
					}
					if (c.query?.throwHook) {
						throw c.error("BAD_REQUEST", {
							message: "from after hook",
						});
					}
				}),
			},
		});

		const api = toAuthEndpoints(endpoints, authContext);

		it("should change the response object from `hello:world` to `hello:auth`", async () => {
			const response = await api.changeResponse();
			expect(response).toMatchObject({ hello: "auth" });
		});

		it("should return the last hook returned response", async () => {
			const response = await api.multipleHooks();
			expect(response).toMatchObject({
				return: "3",
			});
		});

		it("should return error as response", async () => {
			const response = await api.throwError({
				asResponse: true,
			});
			expect(response.status).toBe(400);
		});

		it("should throw the last error", async () => {
			await api
				.throwError({
					query: {
						throwHook: true,
					},
				})
				.catch((e) => {
					expect(e).toBeInstanceOf(APIError);
					expect(e?.message).toBe("from after hook");
				});
		});
	});

	describe("cookies", async () => {
		const endpoints = {
			cookies: createAuthEndpoint(
				"/cookies",
				{
					method: "POST",
				},
				async (c) => {
					c.setCookie("session", "value");
					return { hello: "world" };
				},
			),
			cookieOverride: createAuthEndpoint(
				"/cookie",
				{
					method: "GET",
				},
				async (c) => {
					c.setCookie("data", "1");
				},
			),
			noCookie: createAuthEndpoint(
				"/no-cookie",
				{
					method: "GET",
				},
				async (c) => {},
			),
		};

		const authContext = init({
			hooks: {
				after: createAuthMiddleware(async (c) => {
					c.setHeader("key", "value");
					c.setCookie("data", "2");
				}),
			},
		});

		const authEndpoints = toAuthEndpoints(endpoints, authContext);

		it("set cookies from both hook", async () => {
			const result = await authEndpoints.cookies({
				asResponse: true,
			});
			expect(result.headers.get("set-cookie")).toContain("session=value");
			expect(result.headers.get("set-cookie")).toContain("data=2");
		});

		it("should override cookie", async () => {
			const result = await authEndpoints.cookieOverride({
				asResponse: true,
			});
			expect(result.headers.get("set-cookie")).toContain("data=2");
		});

		it("should only set the hook cookie", async () => {
			const result = await authEndpoints.noCookie({
				asResponse: true,
			});
			expect(result.headers.get("set-cookie")).toContain("data=2");
		});

		it("should return cookies from return headers", async () => {
			const result = await authEndpoints.noCookie({
				returnHeaders: true,
			});
			expect(result.headers.get("set-cookie")).toContain("data=2");

			const result2 = await authEndpoints.cookies({
				asResponse: true,
			});
			expect(result2.headers.get("set-cookie")).toContain("session=value");
			expect(result2.headers.get("set-cookie")).toContain("data=2");
		});
	});
});

describe("disabled paths", async () => {
	const { client } = await getTestInstance({
		disabledPaths: ["/sign-in/email"],
	});

	it("should return 404 for disabled paths", async () => {
		const response = await client.$fetch("/ok");
		expect(response.data).toEqual({ ok: true });
		const { error } = await client.signIn.email({
			email: "test@test.com",
			password: "test",
		});
		expect(error?.status).toBe(404);
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/to-auth-endpoints.ts
```typescript
import {
	APIError,
	toResponse,
	type EndpointContext,
	type EndpointOptions,
	type InputContext,
} from "better-call";
import type { AuthEndpoint, AuthMiddleware } from "./call";
import type { AuthContext, HookEndpointContext } from "../types";
import defu from "defu";

type InternalContext = InputContext<string, any> &
	EndpointContext<string, any> & {
		asResponse?: boolean;
		context: AuthContext & {
			returned?: unknown;
			responseHeaders?: Headers;
		};
	};

export function toAuthEndpoints<E extends Record<string, AuthEndpoint>>(
	endpoints: E,
	ctx: AuthContext | Promise<AuthContext>,
) {
	const api: Record<
		string,
		((
			context: EndpointContext<string, any> & InputContext<string, any>,
		) => Promise<any>) & {
			path?: string;
			options?: EndpointOptions;
		}
	> = {};

	for (const [key, endpoint] of Object.entries(endpoints)) {
		api[key] = async (context) => {
			const authContext = await ctx;
			let internalContext: InternalContext = {
				...context,
				context: {
					...authContext,
					returned: undefined,
					responseHeaders: undefined,
					session: null,
				},
				path: endpoint.path,
				headers: context?.headers ? new Headers(context?.headers) : undefined,
			};
			const { beforeHooks, afterHooks } = getHooks(authContext);
			const before = await runBeforeHooks(internalContext, beforeHooks);
			/**
			 * If `before.context` is returned, it should
			 * get merged with the original context
			 */
			if (
				"context" in before &&
				before.context &&
				typeof before.context === "object"
			) {
				const { headers, ...rest } = before.context as {
					headers: Headers;
				};
				/**
				 * Headers should be merged differently
				 * so the hook doesn't override the whole
				 * header
				 */
				if (headers) {
					headers.forEach((value, key) => {
						(internalContext.headers as Headers).set(key, value);
					});
				}
				internalContext = defu(rest, internalContext);
			} else if (before) {
				/* Return before hook response if it's anything other than a context return */
				return before;
			}

			internalContext.asResponse = false;
			internalContext.returnHeaders = true;
			const result = (await endpoint(internalContext as any).catch((e: any) => {
				if (e instanceof APIError) {
					/**
					 * API Errors from response are caught
					 * and returned to hooks
					 */
					return {
						response: e,
						headers: e.headers ? new Headers(e.headers) : null,
					};
				}
				throw e;
			})) as {
				headers: Headers;
				response: any;
			};
			internalContext.context.returned = result.response;
			internalContext.context.responseHeaders = result.headers;

			const after = await runAfterHooks(internalContext, afterHooks);

			if (after.response) {
				result.response = after.response;
			}

			if (result.response instanceof APIError && !context?.asResponse) {
				throw result.response;
			}
			const response = context?.asResponse
				? toResponse(result.response, {
						headers: result.headers,
					})
				: context?.returnHeaders
					? {
							headers: result.headers,
							response: result.response,
						}
					: result.response;
			return response;
		};
		api[key].path = endpoint.path;
		api[key].options = endpoint.options;
	}
	return api as E;
}

async function runBeforeHooks(
	context: HookEndpointContext,
	hooks: {
		matcher: (context: HookEndpointContext) => boolean;
		handler: AuthMiddleware;
	}[],
) {
	let modifiedContext: {
		headers?: Headers;
	} = {};
	for (const hook of hooks) {
		if (hook.matcher(context)) {
			const result = await hook.handler({
				...context,
				returnHeaders: false,
			});
			if (result && typeof result === "object") {
				if ("context" in result && typeof result.context === "object") {
					const { headers, ...rest } = result.context as {
						headers: Headers;
					};
					if (headers instanceof Headers) {
						if (modifiedContext.headers) {
							headers.forEach((value, key) => {
								modifiedContext.headers?.set(key, value);
							});
						} else {
							modifiedContext.headers = headers;
						}
					}
					modifiedContext = defu(rest, modifiedContext);
					continue;
				}
				return result;
			}
		}
	}
	return { context: modifiedContext };
}

async function runAfterHooks(
	context: HookEndpointContext,
	hooks: {
		matcher: (context: HookEndpointContext) => boolean;
		handler: AuthMiddleware;
	}[],
) {
	for (const hook of hooks) {
		if (hook.matcher(context)) {
			const result = (await hook.handler(context).catch((e) => {
				if (e instanceof APIError) {
					return {
						response: e,
						headers: e.headers ? new Headers(e.headers) : null,
					};
				}
				throw e;
			})) as {
				response: any;
				headers: Headers;
			};
			if (result.headers) {
				result.headers.forEach((value, key) => {
					if (!context.context.responseHeaders) {
						context.context.responseHeaders = new Headers({
							[key]: value,
						});
					} else {
						if (key.toLowerCase() === "set-cookie") {
							context.context.responseHeaders.append(key, value);
						} else {
							context.context.responseHeaders.set(key, value);
						}
					}
				});
			}
			if (result.response) {
				context.context.returned = result.response;
			}
		}
	}
	return {
		response: context.context.returned,
		headers: context.context.responseHeaders,
	};
}

function getHooks(authContext: AuthContext) {
	const plugins = authContext.options.plugins || [];
	const beforeHooks: {
		matcher: (context: HookEndpointContext) => boolean;
		handler: AuthMiddleware;
	}[] = [];
	const afterHooks: {
		matcher: (context: HookEndpointContext) => boolean;
		handler: AuthMiddleware;
	}[] = [];
	if (authContext.options.hooks?.before) {
		beforeHooks.push({
			matcher: () => true,
			handler: authContext.options.hooks.before,
		});
	}
	if (authContext.options.hooks?.after) {
		afterHooks.push({
			matcher: () => true,
			handler: authContext.options.hooks.after,
		});
	}
	const pluginBeforeHooks = plugins
		.map((plugin) => {
			if (plugin.hooks?.before) {
				return plugin.hooks.before;
			}
		})
		.filter((plugin) => plugin !== undefined)
		.flat();
	const pluginAfterHooks = plugins
		.map((plugin) => {
			if (plugin.hooks?.after) {
				return plugin.hooks.after;
			}
		})
		.filter((plugin) => plugin !== undefined)
		.flat();

	/**
	 * Add plugin added hooks at last
	 */
	pluginBeforeHooks.length && beforeHooks.push(...pluginBeforeHooks);
	pluginAfterHooks.length && afterHooks.push(...pluginAfterHooks);

	return {
		beforeHooks,
		afterHooks,
	};
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/middlewares/index.ts
```typescript
export * from "./origin-check";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/middlewares/origin-check.test.ts
```typescript
import { describe, expect } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";
import { createAuthClient } from "../../client";
import { createAuthEndpoint } from "../call";
import { originCheck } from "./origin-check";
import { z } from "zod";

describe("Origin Check", async (it) => {
	const { customFetchImpl, testUser } = await getTestInstance({
		trustedOrigins: [
			"http://localhost:5000",
			"https://trusted.com",
			"*.my-site.com",
		],
		emailAndPassword: {
			enabled: true,
			async sendResetPassword(url, user) {},
		},
		advanced: {
			disableCSRFCheck: false,
		},
	});

	it("should allow trusted origins", async (ctx) => {
		const client = createAuthClient({
			baseURL: "http://localhost:3000",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "http://localhost:3000",
				},
			},
		});
		const res = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
			callbackURL: "http://localhost:3000/callback",
		});
		expect(res.data?.user).toBeDefined();
	});

	it("should not allow untrusted origins", async (ctx) => {
		const client = createAuthClient({
			baseURL: "http://localhost:3000",
			fetchOptions: {
				customFetchImpl,
			},
		});
		const res = await client.signIn.email({
			email: "test@test.com",
			password: "password",
			callbackURL: "http://malicious.com",
		});
		expect(res.error?.status).toBe(403);
		expect(res.error?.message).toBe("Invalid callbackURL");
	});

	it("should allow query params in callback url", async (ctx) => {
		const client = createAuthClient({
			baseURL: "http://localhost:3000",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "https://localhost:3000",
				},
			},
		});
		const res = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
			callbackURL: "/dashboard?test=123",
		});
		expect(res.data?.user).toBeDefined();
	});

	it("should allow plus signs in the callback url", async (ctx) => {
		const client = createAuthClient({
			baseURL: "http://localhost:3000",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "https://localhost:3000",
				},
			},
		});
		const res = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
			callbackURL: "/dashboard+page?test=123+456",
		});
		expect(res.data?.user).toBeDefined();
	});

	it("should reject callback url with double slash", async (ctx) => {
		const client = createAuthClient({
			baseURL: "http://localhost:3000",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "https://localhost:3000",
				},
			},
		});
		const res = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
			callbackURL: "//evil.com",
		});
		expect(res.error?.status).toBe(403);
	});

	it("should reject callback urls with encoded malicious content", async (ctx) => {
		const client = createAuthClient({
			baseURL: "http://localhost:3000",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "https://localhost:3000",
				},
			},
		});

		const maliciousPatterns = [
			"/%5C/evil.com",
			`/\\/\\/evil.com`,
			"/%5C/evil.com",
			"/..%2F..%2Fevil.com",
			"javascript:alert('xss')",
			"data:text/html,<script>alert('xss')</script>",
		];

		for (const pattern of maliciousPatterns) {
			const res = await client.signIn.email({
				email: testUser.email,
				password: testUser.password,
				callbackURL: pattern,
			});
			expect(res.error?.status).toBe(403);
		}
	});

	it("should reject untrusted origin headers", async (ctx) => {
		const client = createAuthClient({
			baseURL: "http://localhost:3000",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "malicious.com",
					cookie: "session=123",
				},
			},
		});
		const res = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
		});
		expect(res.error?.status).toBe(403);
	});

	it("should reject untrusted origin headers which start with trusted origin", async (ctx) => {
		const client = createAuthClient({
			baseURL: "http://localhost:3000",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "https://trusted.com.malicious.com",
					cookie: "session=123",
				},
			},
		});
		const res = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
		});
		expect(res.error?.status).toBe(403);
	});

	it("should reject untrusted origin subdomains", async (ctx) => {
		const client = createAuthClient({
			baseURL: "http://localhost:3000",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "http://sub-domain.trusted.com",
					cookie: "session=123",
				},
			},
		});
		const res = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
		});
		expect(res.error?.status).toBe(403);
	});

	it("should allow untrusted origin if they don't contain cookies", async (ctx) => {
		const client = createAuthClient({
			baseURL: "http://localhost:3000",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "http://sub-domain.trusted.com",
				},
			},
		});
		const res = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
		});
		expect(res.data?.user).toBeDefined();
	});

	it("should reject untrusted redirectTo", async (ctx) => {
		const client = createAuthClient({
			baseURL: "http://localhost:3000",
			fetchOptions: {
				customFetchImpl,
			},
		});
		const res = await client.forgetPassword({
			email: testUser.email,
			redirectTo: "http://malicious.com",
		});
		expect(res.error?.status).toBe(403);
		expect(res.error?.message).toBe("Invalid redirectURL");
	});

	it("should work with list of trusted origins", async (ctx) => {
		const client = createAuthClient({
			baseURL: "http://localhost:3000",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "https://trusted.com",
				},
			},
		});
		const res = await client.forgetPassword({
			email: testUser.email,
			redirectTo: "http://localhost:5000/reset-password",
		});
		expect(res.data?.status).toBeTruthy();

		const res2 = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
			fetchOptions: {
				query: {
					currentURL: "http://localhost:5000",
				},
			},
		});
		expect(res2.data?.user).toBeDefined();
	});

	it("should work with wildcard trusted origins", async (ctx) => {
		const client = createAuthClient({
			baseURL: "https://sub-domain.my-site.com",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "https://sub-domain.my-site.com",
				},
			},
		});
		const res = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
			callbackURL: "https://sub-domain.my-site.com/callback",
		});
		expect(res.data?.user).toBeDefined();

		// Test another subdomain with the wildcard pattern
		const client2 = createAuthClient({
			baseURL: "https://another-sub.my-site.com",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "https://another-sub.my-site.com",
				},
			},
		});
		const res2 = await client2.signIn.email({
			email: testUser.email,
			password: testUser.password,
			callbackURL: "https://another-sub.my-site.com/callback",
		});
		expect(res2.data?.user).toBeDefined();
	});

	it("should work with GET requests", async (ctx) => {
		const client = createAuthClient({
			baseURL: "https://sub-domain.my-site.com",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "https://google.com",
					cookie: "value",
				},
			},
		});
		const res = await client.$fetch("/ok");
		expect(res.data).toMatchObject({ ok: true });
	});

	it("should handle POST requests with proper origin validation", async (ctx) => {
		// Test with valid origin
		const validClient = createAuthClient({
			baseURL: "http://localhost:3000",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "http://localhost:5000",
					cookie: "session=123",
				},
			},
		});
		const validRes = await validClient.signIn.email({
			email: testUser.email,
			password: testUser.password,
		});
		expect(validRes.data?.user).toBeDefined();

		// Test with invalid origin
		const invalidClient = createAuthClient({
			baseURL: "http://localhost:3000",
			fetchOptions: {
				customFetchImpl,
				headers: {
					origin: "http://untrusted-domain.com",
					cookie: "session=123",
				},
			},
		});
		const invalidRes = await invalidClient.signIn.email({
			email: testUser.email,
			password: testUser.password,
		});
		expect(invalidRes.error?.status).toBe(403);
	});
});

describe("origin check middleware", async (it) => {
	it("should return invalid origin", async () => {
		const { client } = await getTestInstance({
			trustedOrigins: ["https://trusted-site.com"],
			plugins: [
				{
					id: "test",
					endpoints: {
						test: createAuthEndpoint(
							"/test",
							{
								method: "GET",
								query: z.object({
									callbackURL: z.string(),
								}),
								use: [originCheck((c) => c.query.callbackURL)],
							},
							async (c) => {
								return c.query.callbackURL;
							},
						),
					},
				},
			],
		});
		const invalid = await client.$fetch(
			"/test?callbackURL=https://malicious-site.com",
		);
		expect(invalid.error?.status).toBe(403);
		const valid = await client.$fetch("/test?callbackURL=/dashboard");
		expect(valid.data).toBe("/dashboard");
		const validTrusted = await client.$fetch(
			"/test?callbackURL=https://trusted-site.com/path",
		);
		expect(validTrusted.data).toBe("https://trusted-site.com/path");

		const sampleInternalEndpointInvalid = await client.$fetch(
			"/verify-email?callbackURL=https://malicious-site.com&token=xyz",
		);
		expect(sampleInternalEndpointInvalid.error?.status).toBe(403);
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/middlewares/origin-check.ts
```typescript
import { APIError } from "better-call";
import { createAuthMiddleware } from "../call";
import { wildcardMatch } from "../../utils/wildcard";
import { getHost, getOrigin, getProtocol } from "../../utils/url";
import type { GenericEndpointContext } from "../../types";

/**
 * A middleware to validate callbackURL and origin against
 * trustedOrigins.
 */
export const originCheckMiddleware = createAuthMiddleware(async (ctx) => {
	if (ctx.request?.method !== "POST" || !ctx.request) {
		return;
	}
	const { body, query, context } = ctx;
	const originHeader =
		ctx.headers?.get("origin") || ctx.headers?.get("referer") || "";
	const callbackURL = body?.callbackURL || query?.callbackURL;
	const redirectURL = body?.redirectTo;
	const errorCallbackURL = body?.errorCallbackURL;
	const newUserCallbackURL = body?.newUserCallbackURL;
	const trustedOrigins: string[] = Array.isArray(context.options.trustedOrigins)
		? context.trustedOrigins
		: [
				...context.trustedOrigins,
				...((await context.options.trustedOrigins?.(ctx.request)) || []),
			];
	const usesCookies = ctx.headers?.has("cookie");

	const matchesPattern = (url: string, pattern: string): boolean => {
		if (url.startsWith("/")) {
			return false;
		}
		if (pattern.includes("*")) {
			return wildcardMatch(pattern)(getHost(url));
		}

		const protocol = getProtocol(url);
		return protocol === "http:" || protocol === "https:" || !protocol
			? pattern === getOrigin(url)
			: url.startsWith(pattern);
	};
	const validateURL = (url: string | undefined, label: string) => {
		if (!url) {
			return;
		}
		const isTrustedOrigin = trustedOrigins.some(
			(origin) =>
				matchesPattern(url, origin) ||
				(url?.startsWith("/") &&
					label !== "origin" &&
					/^\/(?!\/|\\|%2f|%5c)[\w\-.\+/]*(?:\?[\w\-.\+/=&%]*)?$/.test(url)),
		);
		if (!isTrustedOrigin) {
			ctx.context.logger.error(`Invalid ${label}: ${url}`);
			ctx.context.logger.info(
				`If it's a valid URL, please add ${url} to trustedOrigins in your auth config\n`,
				`Current list of trustedOrigins: ${trustedOrigins}`,
			);
			throw new APIError("FORBIDDEN", { message: `Invalid ${label}` });
		}
	};
	if (usesCookies && !ctx.context.options.advanced?.disableCSRFCheck) {
		validateURL(originHeader, "origin");
	}
	callbackURL && validateURL(callbackURL, "callbackURL");
	redirectURL && validateURL(redirectURL, "redirectURL");
	errorCallbackURL && validateURL(errorCallbackURL, "errorCallbackURL");
	newUserCallbackURL && validateURL(newUserCallbackURL, "newUserCallbackURL");
});

export const originCheck = (
	getValue: (ctx: GenericEndpointContext) => string | string[],
) =>
	createAuthMiddleware(async (ctx) => {
		if (!ctx.request) {
			return;
		}
		const { context } = ctx;
		const callbackURL = getValue(ctx);
		const trustedOrigins: string[] = Array.isArray(
			context.options.trustedOrigins,
		)
			? context.trustedOrigins
			: [
					...context.trustedOrigins,
					...((await context.options.trustedOrigins?.(ctx.request)) || []),
				];

		const matchesPattern = (url: string, pattern: string): boolean => {
			if (url.startsWith("/")) {
				return false;
			}
			if (pattern.includes("*")) {
				return wildcardMatch(pattern)(getHost(url));
			}
			return url.startsWith(pattern);
		};

		const validateURL = (url: string | undefined, label: string) => {
			if (!url) {
				return;
			}
			const isTrustedOrigin = trustedOrigins.some(
				(origin) =>
					matchesPattern(url, origin) ||
					(url?.startsWith("/") &&
						label !== "origin" &&
						/^\/(?!\/|\\|%2f|%5c)[\w\-.\+/]*(?:\?[\w\-.\+/=&%]*)?$/.test(url)),
			);
			if (!isTrustedOrigin) {
				ctx.context.logger.error(`Invalid ${label}: ${url}`);
				ctx.context.logger.info(
					`If it's a valid URL, please add ${url} to trustedOrigins in your auth config\n`,
					`Current list of trustedOrigins: ${trustedOrigins}`,
				);
				throw new APIError("FORBIDDEN", { message: `Invalid ${label}` });
			}
		};
		const callbacks = Array.isArray(callbackURL) ? callbackURL : [callbackURL];
		for (const url of callbacks) {
			validateURL(url, "callbackURL");
		}
	});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/rate-limiter/index.ts
```typescript
import type { AuthContext, RateLimit } from "../../types";
import { getIp } from "../../utils/get-request-ip";
import { wildcardMatch } from "../../utils/wildcard";

function shouldRateLimit(
	max: number,
	window: number,
	rateLimitData: RateLimit,
) {
	const now = Date.now();
	const windowInMs = window * 1000;
	const timeSinceLastRequest = now - rateLimitData.lastRequest;
	return timeSinceLastRequest < windowInMs && rateLimitData.count >= max;
}

function rateLimitResponse(retryAfter: number) {
	return new Response(
		JSON.stringify({
			message: "Too many requests. Please try again later.",
		}),
		{
			status: 429,
			statusText: "Too Many Requests",
			headers: {
				"X-Retry-After": retryAfter.toString(),
			},
		},
	);
}

function getRetryAfter(lastRequest: number, window: number) {
	const now = Date.now();
	const windowInMs = window * 1000;
	return Math.ceil((lastRequest + windowInMs - now) / 1000);
}

function createDBStorage(ctx: AuthContext, modelName?: string) {
	const model = ctx.options.rateLimit?.modelName || "rateLimit";
	const db = ctx.adapter;
	return {
		get: async (key: string) => {
			const res = await db.findMany<RateLimit>({
				model,
				where: [{ field: "key", value: key }],
			});
			const data = res[0];

			if (typeof data?.lastRequest === "bigint") {
				data.lastRequest = Number(data.lastRequest);
			}

			return data;
		},
		set: async (key: string, value: RateLimit, _update?: boolean) => {
			try {
				if (_update) {
					await db.updateMany({
						model: "rateLimit",
						where: [{ field: "key", value: key }],
						update: {
							count: value.count,
							lastRequest: value.lastRequest,
						},
					});
				} else {
					await db.create({
						model: "rateLimit",
						data: {
							key,
							count: value.count,
							lastRequest: value.lastRequest,
						},
					});
				}
			} catch (e) {
				ctx.logger.error("Error setting rate limit", e);
			}
		},
	};
}

const memory = new Map<string, RateLimit>();
export function getRateLimitStorage(ctx: AuthContext) {
	if (ctx.options.rateLimit?.customStorage) {
		return ctx.options.rateLimit.customStorage;
	}
	if (ctx.rateLimit.storage === "secondary-storage") {
		return {
			get: async (key: string) => {
				const stringified = await ctx.options.secondaryStorage?.get(key);
				return stringified ? (JSON.parse(stringified) as RateLimit) : undefined;
			},
			set: async (key: string, value: RateLimit) => {
				await ctx.options.secondaryStorage?.set?.(key, JSON.stringify(value));
			},
		};
	}
	const storage = ctx.rateLimit.storage;
	if (storage === "memory") {
		return {
			async get(key: string) {
				return memory.get(key);
			},
			async set(key: string, value: RateLimit, _update?: boolean) {
				memory.set(key, value);
			},
		};
	}
	return createDBStorage(ctx, ctx.rateLimit.modelName);
}

export async function onRequestRateLimit(req: Request, ctx: AuthContext) {
	if (!ctx.rateLimit.enabled) {
		return;
	}
	const path = new URL(req.url).pathname.replace(
		ctx.options.basePath || "/api/auth",
		"",
	);
	let window = ctx.rateLimit.window;
	let max = ctx.rateLimit.max;
	const ip = getIp(req, ctx.options);
	if (!ip) {
		return;
	}
	const key = ip + path;
	const specialRules = getDefaultSpecialRules();
	const specialRule = specialRules.find((rule) => rule.pathMatcher(path));

	if (specialRule) {
		window = specialRule.window;
		max = specialRule.max;
	}

	for (const plugin of ctx.options.plugins || []) {
		if (plugin.rateLimit) {
			const matchedRule = plugin.rateLimit.find((rule) =>
				rule.pathMatcher(path),
			);
			if (matchedRule) {
				window = matchedRule.window;
				max = matchedRule.max;
				break;
			}
		}
	}

	if (ctx.rateLimit.customRules) {
		const _path = Object.keys(ctx.rateLimit.customRules).find((p) => {
			if (p.includes("*")) {
				const isMatch = wildcardMatch(p)(path);
				return isMatch;
			}
			return p === path;
		});
		if (_path) {
			const customRule = ctx.rateLimit.customRules[_path];
			const resolved =
				typeof customRule === "function" ? await customRule(req) : customRule;
			if (resolved) {
				window = resolved.window;
				max = resolved.max;
			}
		}
	}

	const storage = getRateLimitStorage(ctx);
	const data = await storage.get(key);
	const now = Date.now();

	if (!data) {
		await storage.set(key, {
			key,
			count: 1,
			lastRequest: now,
		});
	} else {
		const timeSinceLastRequest = now - data.lastRequest;

		if (shouldRateLimit(max, window, data)) {
			const retryAfter = getRetryAfter(data.lastRequest, window);
			return rateLimitResponse(retryAfter);
		} else if (timeSinceLastRequest > window * 1000) {
			// Reset the count if the window has passed since the last request
			await storage.set(
				key,
				{
					...data,
					count: 1,
					lastRequest: now,
				},
				true,
			);
		} else {
			await storage.set(
				key,
				{
					...data,
					count: data.count + 1,
					lastRequest: now,
				},
				true,
			);
		}
	}
}

function getDefaultSpecialRules() {
	const specialRules = [
		{
			pathMatcher(path: string) {
				return (
					path.startsWith("/sign-in") ||
					path.startsWith("/sign-up") ||
					path.startsWith("/change-password") ||
					path.startsWith("/change-email")
				);
			},
			window: 10,
			max: 3,
		},
	];
	return specialRules;
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/rate-limiter/rate-limiter.test.ts
```typescript
import { describe, it, expect, vi } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";

describe(
	"rate-limiter",
	{
		timeout: 10000,
	},
	async () => {
		const { client, testUser } = await getTestInstance({
			rateLimit: {
				enabled: true,
				window: 10,
				max: 20,
			},
		});

		it("should return 429 after 3 request for sign-in", async () => {
			for (let i = 0; i < 5; i++) {
				const response = await client.signIn.email({
					email: testUser.email,
					password: testUser.password,
				});
				if (i >= 3) {
					expect(response.error?.status).toBe(429);
				} else {
					expect(response.error).toBeNull();
				}
			}
		});

		it("should reset the limit after the window period", async () => {
			vi.useFakeTimers();
			vi.advanceTimersByTime(11000);
			for (let i = 0; i < 5; i++) {
				const res = await client.signIn.email({
					email: testUser.email,
					password: testUser.password,
				});
				if (i >= 3) {
					expect(res.error?.status).toBe(429);
				} else {
					expect(res.error).toBeNull();
				}
			}
		});

		it("should respond the correct retry-after header", async () => {
			vi.useFakeTimers();
			vi.advanceTimersByTime(3000);
			let retryAfter = "";
			await client.signIn.email(
				{
					email: testUser.email,
					password: testUser.password,
				},
				{
					onError(context) {
						retryAfter = context.response.headers.get("X-Retry-After") ?? "";
					},
				},
			);
			expect(retryAfter).toBe("7");
		});

		it("should rate limit based on the path", async () => {
			const signInRes = await client.signIn.email({
				email: testUser.email,
				password: testUser.password,
			});
			expect(signInRes.error?.status).toBe(429);

			const signUpRes = await client.signUp.email({
				email: "new-test@email.com",
				password: testUser.password,
				name: "test",
			});
			expect(signUpRes.error).toBeNull();
		});

		it("non-special-rules limits", async () => {
			for (let i = 0; i < 25; i++) {
				const response = await client.getSession();
				expect(response.error?.status).toBe(i >= 20 ? 429 : undefined);
			}
		});

		it("query params should be ignored", async () => {
			for (let i = 0; i < 25; i++) {
				const response = await client.listSessions({
					fetchOptions: {
						// @ts-ignore
						query: {
							"test-query": Math.random().toString(),
						},
					},
				});

				if (i >= 20) {
					expect(response.error?.status).toBe(429);
				} else {
					expect(response.error?.status).toBe(401);
				}
			}
		});
	},
);

describe("custom rate limiting storage", async () => {
	let store = new Map<string, string>();
	const { client, testUser } = await getTestInstance({
		rateLimit: {
			enabled: true,
		},
		secondaryStorage: {
			set(key, value, ttl) {
				store.set(key, value);
			},
			get(key) {
				return store.get(key) || null;
			},
			delete(key) {
				store.delete(key);
			},
		},
	});

	it("should use custom storage", async () => {
		await client.getSession();
		expect(store.size).toBe(3);
		for (let i = 0; i < 4; i++) {
			const response = await client.signIn.email({
				email: testUser.email,
				password: testUser.password,
			});
			if (i >= 3) {
				expect(response.error?.status).toBe(429);
			} else {
				expect(response.error).toBeNull();
			}
		}
	});
});

describe("should work with custom rules", async () => {
	const { client, testUser } = await getTestInstance({
		rateLimit: {
			enabled: true,
			storage: "database",
			customRules: {
				"/sign-in/*": {
					window: 10,
					max: 2,
				},
				"/sign-up/email": {
					window: 10,
					max: 3,
				},
			},
		},
	});

	it("should use custom rules", async () => {
		for (let i = 0; i < 4; i++) {
			const response = await client.signIn.email({
				email: testUser.email,
				password: testUser.password,
			});
			if (i >= 2) {
				expect(response.error?.status).toBe(429);
			} else {
				expect(response.error).toBeNull();
			}
		}

		for (let i = 0; i < 5; i++) {
			const response = await client.signUp.email({
				email: `${Math.random()}@test.com`,
				password: testUser.password,
				name: "test",
			});
			if (i >= 3) {
				expect(response.error?.status).toBe(429);
			} else {
				expect(response.error).toBeNull();
			}
		}
	});

	it("should use default rules if custom rules are not defined", async () => {
		for (let i = 0; i < 5; i++) {
			const response = await client.getSession();
			if (i >= 20) {
				expect(response.error?.status).toBe(429);
			} else {
				expect(response.error).toBeNull();
			}
		}
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/account.test.ts
```typescript
import { describe, expect, it, vi } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";
import { parseSetCookieHeader } from "../../cookies";
import type { GoogleProfile } from "../../social-providers";
import { DEFAULT_SECRET } from "../../utils/constants";
import { getOAuth2Tokens } from "../../oauth2";
import { signJWT } from "../../crypto/jwt";
import { BASE_ERROR_CODES } from "../../error/codes";

let email = "";
vi.mock("../../oauth2", async (importOriginal) => {
	const original = (await importOriginal()) as any;
	return {
		...original,
		validateAuthorizationCode: vi
			.fn()
			.mockImplementation(async (...args: any) => {
				const data: GoogleProfile = {
					email,
					email_verified: true,
					name: "First Last",
					picture: "https://lh3.googleusercontent.com/a-/AOh14GjQ4Z7Vw",
					exp: 1234567890,
					sub: "1234567890",
					iat: 1234567890,
					aud: "test",
					azp: "test",
					nbf: 1234567890,
					iss: "test",
					locale: "en",
					jti: "test",
					given_name: "First",
					family_name: "Last",
				};
				const testIdToken = await signJWT(data, DEFAULT_SECRET);
				const tokens = getOAuth2Tokens({
					access_token: "test",
					refresh_token: "test",
					id_token: testIdToken,
				});
				return tokens;
			}),
	};
});

describe("account", async () => {
	const { auth, client, signInWithTestUser } = await getTestInstance({
		socialProviders: {
			google: {
				clientId: "test",
				clientSecret: "test",
				enabled: true,
			},
		},
		account: {
			accountLinking: {
				allowDifferentEmails: true,
			},
		},
	});

	const ctx = await auth.$context;

	const { headers } = await signInWithTestUser();

	it("should list all accounts", async () => {
		const accounts = await client.listAccounts({
			fetchOptions: {
				headers,
			},
		});
		expect(accounts.data?.length).toBe(1);
	});

	it("should link first account", async () => {
		const linkAccountRes = await client.linkSocial(
			{
				provider: "google",
				callbackURL: "/callback",
			},
			{
				headers,
				onSuccess(context) {
					const cookies = parseSetCookieHeader(
						context.response.headers.get("set-cookie") || "",
					);
					headers.set(
						"cookie",
						`better-auth.state=${cookies.get("better-auth.state")?.value}`,
					);
				},
			},
		);
		expect(linkAccountRes.data).toMatchObject({
			url: expect.stringContaining("google.com"),
			redirect: true,
		});
		const state =
			new URL(linkAccountRes.data!.url).searchParams.get("state") || "";
		email = "test@test.com";
		await client.$fetch("/callback/google", {
			query: {
				state,
				code: "test",
			},
			method: "GET",
			headers,
			onError(context) {
				expect(context.response.status).toBe(302);
				const location = context.response.headers.get("location");
				expect(location).toBeDefined();
				expect(location).toContain("/callback");
			},
		});

		const { headers: headers2 } = await signInWithTestUser();
		const accounts = await client.listAccounts({
			fetchOptions: { headers: headers2 },
		});
		expect(accounts.data?.length).toBe(2);
	});

	it("should link second account from the same provider", async () => {
		const { headers: headers2 } = await signInWithTestUser();
		const linkAccountRes = await client.linkSocial(
			{
				provider: "google",
				callbackURL: "/callback",
			},
			{
				headers: headers2,
				onSuccess(context) {
					const cookies = parseSetCookieHeader(
						context.response.headers.get("set-cookie") || "",
					);
					headers.set(
						"cookie",
						`better-auth.state=${cookies.get("better-auth.state")?.value}`,
					);
				},
			},
		);
		expect(linkAccountRes.data).toMatchObject({
			url: expect.stringContaining("google.com"),
			redirect: true,
		});
		const state =
			new URL(linkAccountRes.data!.url).searchParams.get("state") || "";
		email = "test2@test.com";
		await client.$fetch("/callback/google", {
			query: {
				state,
				code: "test",
			},
			method: "GET",
			headers,
			onError(context) {
				expect(context.response.status).toBe(302);
				const location = context.response.headers.get("location");
				expect(location).toBeDefined();
				expect(location).toContain("/callback");
			},
		});

		const { headers: headers3 } = await signInWithTestUser();
		const accounts = await client.listAccounts({
			fetchOptions: { headers: headers3 },
		});
		expect(accounts.data?.length).toBe(3);
	});
	it("should unlink account", async () => {
		const { headers } = await signInWithTestUser();
		const previousAccounts = await client.listAccounts({
			fetchOptions: {
				headers,
			},
		});
		expect(previousAccounts.data?.length).toBe(3);
		const unlinkAccountId = previousAccounts.data![1].accountId;
		const unlinkRes = await client.unlinkAccount({
			providerId: "google",
			accountId: unlinkAccountId!,
			fetchOptions: {
				headers,
			},
		});
		expect(unlinkRes.data?.status).toBe(true);
		const accounts = await client.listAccounts({
			fetchOptions: {
				headers,
			},
		});
		expect(accounts.data?.length).toBe(2);
	});

	it("should fail to unlink the last account of a provider", async () => {
		const { headers } = await signInWithTestUser();
		const previousAccounts = await client.listAccounts({
			fetchOptions: {
				headers,
			},
		});
		await ctx.adapter.delete({
			model: "account",
			where: [
				{
					field: "providerId",
					value: "google",
				},
			],
		});
		const unlinkAccountId = previousAccounts.data![0].accountId;
		const unlinkRes = await client.unlinkAccount({
			providerId: "credential",
			accountId: unlinkAccountId,
			fetchOptions: {
				headers,
			},
		});
		expect(unlinkRes.error?.message).toBe(
			BASE_ERROR_CODES.FAILED_TO_UNLINK_LAST_ACCOUNT,
		);
	});

	it("should unlink account with specific accountId", async () => {
		const { headers } = await signInWithTestUser();
		const previousAccounts = await client.listAccounts({
			fetchOptions: {
				headers,
			},
		});
		expect(previousAccounts.data?.length).toBeGreaterThan(0);

		const accountToUnlink = previousAccounts.data![0];
		const unlinkAccountId = accountToUnlink.accountId;
		const providerId = accountToUnlink.provider;
		const accountsWithSameProvider = previousAccounts.data!.filter(
			(account) => account.provider === providerId,
		);
		if (accountsWithSameProvider.length <= 1) {
			return;
		}

		const unlinkRes = await client.unlinkAccount({
			providerId,
			accountId: unlinkAccountId!,
			fetchOptions: {
				headers,
			},
		});

		expect(unlinkRes.data?.status).toBe(true);

		const accountsAfterUnlink = await client.listAccounts({
			fetchOptions: {
				headers,
			},
		});

		expect(accountsAfterUnlink.data?.length).toBe(
			previousAccounts.data!.length - 1,
		);
		expect(
			accountsAfterUnlink.data?.find((a) => a.accountId === unlinkAccountId),
		).toBeUndefined();
	});

	it("should unlink all accounts with specific providerId", async () => {
		const { headers, user } = await signInWithTestUser();
		await ctx.adapter.create({
			model: "account",
			data: {
				providerId: "google",
				accountId: "123",
				userId: user.id,
				createdAt: new Date(),
				updatedAt: new Date(),
			},
		});

		await ctx.adapter.create({
			model: "account",
			data: {
				providerId: "google",
				accountId: "345",
				userId: user.id,
				createdAt: new Date(),
				updatedAt: new Date(),
			},
		});

		const previousAccounts = await client.listAccounts({
			fetchOptions: {
				headers,
			},
		});

		const googleAccounts = previousAccounts.data!.filter(
			(account) => account.provider === "google",
		);
		expect(googleAccounts.length).toBeGreaterThan(1);

		for (let i = 0; i < googleAccounts.length - 1; i++) {
			const unlinkRes = await client.unlinkAccount({
				providerId: "google",
				accountId: googleAccounts[i].accountId!,
				fetchOptions: {
					headers,
				},
			});
			expect(unlinkRes.data?.status).toBe(true);
		}

		const accountsAfterUnlink = await client.listAccounts({
			fetchOptions: {
				headers,
			},
		});

		const remainingGoogleAccounts = accountsAfterUnlink.data!.filter(
			(account) => account.provider === "google",
		);
		expect(remainingGoogleAccounts.length).toBe(1);
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/account.ts
```typescript
import { z } from "zod";
import { createAuthEndpoint } from "../call";
import { socialProviderList } from "../../social-providers";
import { APIError } from "better-call";
import { generateState } from "../../oauth2";
import { freshSessionMiddleware, sessionMiddleware } from "./session";
import { BASE_ERROR_CODES } from "../../error/codes";

export const listUserAccounts = createAuthEndpoint(
	"/list-accounts",
	{
		method: "GET",
		use: [sessionMiddleware],
		metadata: {
			openapi: {
				description: "List all accounts linked to the user",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "array",
									items: {
										type: "object",
										properties: {
											id: {
												type: "string",
											},
											provider: {
												type: "string",
											},
											createdAt: {
												type: "string",
											},
											updatedAt: {
												type: "string",
											},
											accountId: {
												type: "string",
											},
											scopes: {
												type: "array",
												items: { type: "string" },
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
	},
	async (c) => {
		const session = c.context.session;
		const accounts = await c.context.internalAdapter.findAccounts(
			session.user.id,
		);
		return c.json(
			accounts.map((a) => ({
				id: a.id,
				provider: a.providerId,
				createdAt: a.createdAt,
				updatedAt: a.updatedAt,
				accountId: a.accountId,
				scopes: a.scope?.split(",") || [],
			})),
		);
	},
);

export const linkSocialAccount = createAuthEndpoint(
	"/link-social",
	{
		method: "POST",
		requireHeaders: true,
		body: z.object({
			/**
			 * Callback URL to redirect to after the user has signed in.
			 */
			callbackURL: z
				.string({
					description: "The URL to redirect to after the user has signed in",
				})
				.optional(),
			/**
			 * OAuth2 provider to use
			 */
			provider: z.enum(socialProviderList, {
				description: "The OAuth2 provider to use",
			}),
		}),
		use: [sessionMiddleware],
		metadata: {
			openapi: {
				description: "Link a social account to the user",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										url: {
											type: "string",
										},
										redirect: {
											type: "boolean",
										},
									},
									required: ["url", "redirect"],
								},
							},
						},
					},
				},
			},
		},
	},
	async (c) => {
		const session = c.context.session;

		const provider = c.context.socialProviders.find(
			(p) => p.id === c.body.provider,
		);

		if (!provider) {
			c.context.logger.error(
				"Provider not found. Make sure to add the provider in your auth config",
				{
					provider: c.body.provider,
				},
			);
			throw new APIError("NOT_FOUND", {
				message: BASE_ERROR_CODES.PROVIDER_NOT_FOUND,
			});
		}

		const state = await generateState(c, {
			userId: session.user.id,
			email: session.user.email,
		});

		const url = await provider.createAuthorizationURL({
			state: state.state,
			codeVerifier: state.codeVerifier,
			redirectURI: `${c.context.baseURL}/callback/${provider.id}`,
		});

		return c.json({
			url: url.toString(),
			redirect: true,
		});
	},
);

export const unlinkAccount = createAuthEndpoint(
	"/unlink-account",
	{
		method: "POST",
		body: z.object({
			providerId: z.string(),
			accountId: z.string().optional(),
		}),
		use: [freshSessionMiddleware],
	},
	async (ctx) => {
		const { providerId, accountId } = ctx.body;
		const accounts = await ctx.context.internalAdapter.findAccounts(
			ctx.context.session.user.id,
		);
		if (
			accounts.length === 1 &&
			!ctx.context.options.account?.accountLinking?.allowUnlinkingAll
		) {
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.FAILED_TO_UNLINK_LAST_ACCOUNT,
			});
		}
		const accountExist = accounts.find((account) =>
			accountId
				? account.accountId === accountId && account.providerId === providerId
				: account.providerId === providerId,
		);
		if (!accountExist) {
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.ACCOUNT_NOT_FOUND,
			});
		}
		await ctx.context.internalAdapter.deleteAccount(accountExist.id);
		return ctx.json({
			status: true,
		});
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/callback.ts
```typescript
import { z } from "zod";
import { setSessionCookie } from "../../cookies";
import type { OAuth2Tokens } from "../../oauth2";
import { handleOAuthUserInfo } from "../../oauth2/link-account";
import { parseState } from "../../oauth2/state";
import { HIDE_METADATA } from "../../utils/hide-metadata";
import { createAuthEndpoint } from "../call";

const schema = z.object({
	code: z.string().optional(),
	error: z.string().optional(),
	device_id: z.string().optional(),
	error_description: z.string().optional(),
	state: z.string().optional(),
});

export const callbackOAuth = createAuthEndpoint(
	"/callback/:id",
	{
		method: ["GET", "POST"],
		body: schema.optional(),
		query: schema.optional(),
		metadata: HIDE_METADATA,
	},
	async (c) => {
		let queryOrBody: z.infer<typeof schema>;
		const defaultErrorURL =
			c.context.options.onAPIError?.errorURL || `${c.context.baseURL}/error`;
		try {
			if (c.method === "GET") {
				queryOrBody = schema.parse(c.query);
			} else if (c.method === "POST") {
				queryOrBody = schema.parse(c.body);
			} else {
				throw new Error("Unsupported method");
			}
		} catch (e) {
			c.context.logger.error("INVALID_CALLBACK_REQUEST", e);
			throw c.redirect(`${defaultErrorURL}?error=invalid_callback_request`);
		}

		const { code, error, state, error_description, device_id } = queryOrBody;

		if (error) {
			throw c.redirect(
				`${defaultErrorURL}?error=${error}&error_description=${error_description}`,
			);
		}

		if (!state) {
			c.context.logger.error("State not found", error);
			throw c.redirect(`${defaultErrorURL}?error=state_not_found`);
		}
		const {
			codeVerifier,
			callbackURL,
			link,
			errorURL,
			newUserURL,
			requestSignUp,
		} = await parseState(c);

		function redirectOnError(error: string) {
			let url = errorURL || defaultErrorURL;
			if (url.includes("?")) {
				url = `${url}&error=${error}`;
			} else {
				url = `${url}?error=${error}`;
			}
			throw c.redirect(url);
		}

		if (!code) {
			c.context.logger.error("Code not found");
			throw redirectOnError("no_code");
		}
		const provider = c.context.socialProviders.find(
			(p) => p.id === c.params.id,
		);

		if (!provider) {
			c.context.logger.error(
				"Oauth provider with id",
				c.params.id,
				"not found",
			);
			throw redirectOnError("oauth_provider_not_found");
		}

		let tokens: OAuth2Tokens;
		try {
			tokens = await provider.validateAuthorizationCode({
				code: code,
				codeVerifier,
				deviceId: device_id,
				redirectURI: `${c.context.baseURL}/callback/${provider.id}`,
			});
		} catch (e) {
			c.context.logger.error("", e);
			throw redirectOnError("invalid_code");
		}
		const userInfo = await provider
			.getUserInfo(tokens)
			.then((res) => res?.user);

		if (!userInfo) {
			c.context.logger.error("Unable to get user info");
			return redirectOnError("unable_to_get_user_info");
		}

		if (!userInfo.email) {
			c.context.logger.error(
				"Provider did not return email. This could be due to misconfiguration in the provider settings.",
			);
			return redirectOnError("email_not_found");
		}

		if (!callbackURL) {
			c.context.logger.error("No callback URL found");
			throw redirectOnError("no_callback_url");
		}

		if (link) {
			const existingAccount = await c.context.internalAdapter.findAccount(
				userInfo.id,
			);

			if (existingAccount) {
				if (existingAccount.userId.toString() !== link.userId.toString()) {
					return redirectOnError("account_already_linked_to_different_user");
				}
			}

			const newAccount = await c.context.internalAdapter.createAccount(
				{
					userId: link.userId,
					providerId: provider.id,
					accountId: userInfo.id,
					...tokens,
					scope: tokens.scopes?.join(","),
				},
				c,
			);

			if (!newAccount) {
				return redirectOnError("unable_to_link_account");
			}

			let toRedirectTo: string;
			try {
				const url = callbackURL;
				toRedirectTo = url.toString();
			} catch {
				toRedirectTo = callbackURL;
			}
			throw c.redirect(toRedirectTo);
		}

		const result = await handleOAuthUserInfo(c, {
			userInfo: {
				...userInfo,
				email: userInfo.email,
				name: userInfo.name || userInfo.email,
			},
			account: {
				providerId: provider.id,
				accountId: userInfo.id,
				...tokens,
				scope: tokens.scopes?.join(","),
			},
			callbackURL,
			disableSignUp:
				(provider.disableImplicitSignUp && !requestSignUp) ||
				provider.options?.disableSignUp,
		});
		if (result.error) {
			c.context.logger.error(result.error.split(" ").join("_"));
			return redirectOnError(result.error.split(" ").join("_"));
		}
		const { session, user } = result.data!;
		await setSessionCookie(c, {
			session,
			user,
		});
		let toRedirectTo: string;
		try {
			const url = result.isRegister ? newUserURL || callbackURL : callbackURL;
			toRedirectTo = url.toString();
		} catch {
			toRedirectTo = result.isRegister
				? newUserURL || callbackURL
				: callbackURL;
		}
		throw c.redirect(toRedirectTo);
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/email-verification.test.ts
```typescript
import { describe, expect, it, vi } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";

describe("Email Verification", async () => {
	const mockSendEmail = vi.fn();
	let token: string;
	const { auth, testUser, client, signInWithUser } = await getTestInstance({
		emailAndPassword: {
			enabled: true,
			requireEmailVerification: true,
		},
		emailVerification: {
			async sendVerificationEmail({ user, url, token: _token }) {
				token = _token;
				mockSendEmail(user.email, url);
			},
		},
	});

	it("should send a verification email when enabled", async () => {
		await auth.api.sendVerificationEmail({
			body: {
				email: testUser.email,
			},
		});
		expect(mockSendEmail).toHaveBeenCalledWith(
			testUser.email,
			expect.any(String),
		);
	});

	it("should send a verification email if verification is required and user is not verified", async () => {
		await signInWithUser(testUser.email, testUser.password);

		expect(mockSendEmail).toHaveBeenCalledWith(
			testUser.email,
			expect.any(String),
		);
	});

	it("should verify email", async () => {
		const res = await client.verifyEmail({
			query: {
				token,
			},
		});
		expect(res.data?.status).toBe(true);
	});

	it("should redirect to callback", async () => {
		await client.verifyEmail(
			{
				query: {
					token,
					callbackURL: "/callback",
				},
			},
			{
				onError: (ctx) => {
					const location = ctx.response.headers.get("location");
					expect(location).toBe("/callback");
				},
			},
		);
	});

	it("should sign after verification", async () => {
		const { testUser, signInWithUser, client } = await getTestInstance({
			emailAndPassword: {
				enabled: true,
				requireEmailVerification: true,
			},
			emailVerification: {
				async sendVerificationEmail({ user, url, token: _token }) {
					token = _token;
					mockSendEmail(user.email, url);
				},
				autoSignInAfterVerification: true,
			},
		});
		await signInWithUser(testUser.email, testUser.password);

		let sessionToken = "";
		const res = await client.verifyEmail({
			query: {
				token,
			},
			fetchOptions: {
				onSuccess(context) {
					sessionToken = context.response.headers.get("set-auth-token") || "";
				},
			},
		});
		expect(sessionToken.length).toBeGreaterThan(10);
	});

	it("should use custom expiresIn", async () => {
		const { auth, client } = await getTestInstance({
			emailAndPassword: {
				enabled: true,
				requireEmailVerification: true,
			},
			emailVerification: {
				async sendVerificationEmail({ user, url, token: _token }) {
					token = _token;
					mockSendEmail(user.email, url);
				},
				expiresIn: 10,
			},
		});
		await auth.api.sendVerificationEmail({
			body: {
				email: testUser.email,
			},
		});
		vi.useFakeTimers();
		await vi.advanceTimersByTimeAsync(10 * 1000);
		const res = await client.verifyEmail({
			query: {
				token,
			},
		});
		expect(res.error?.code).toBe("TOKEN_EXPIRED");
	});

	it("should call onEmailVerification callback when email is verified", async () => {
		const onEmailVerificationMock = vi.fn();
		const { auth, client } = await getTestInstance({
			emailAndPassword: {
				enabled: true,
				requireEmailVerification: true,
			},
			emailVerification: {
				async sendVerificationEmail({ user, url, token: _token }) {
					token = _token;
					mockSendEmail(user.email, url);
				},
				onEmailVerification: onEmailVerificationMock,
			},
		});

		await auth.api.sendVerificationEmail({
			body: {
				email: testUser.email,
			},
		});

		const res = await client.verifyEmail({
			query: {
				token,
			},
		});

		expect(res.data?.status).toBe(true);
		expect(onEmailVerificationMock).toHaveBeenCalledWith(
			expect.objectContaining({ email: testUser.email }),
			expect.any(Object),
		);
	});
});

describe("Email Verification Secondary Storage", async () => {
	let store = new Map<string, string>();
	let token: string;
	const { client, signInWithTestUser, db, auth, testUser, cookieSetter } =
		await getTestInstance({
			secondaryStorage: {
				set(key, value, ttl) {
					store.set(key, value);
				},
				get(key) {
					return store.get(key) || null;
				},
				delete(key) {
					store.delete(key);
				},
			},
			rateLimit: {
				enabled: false,
			},
			emailAndPassword: {
				enabled: true,
			},
			emailVerification: {
				async sendVerificationEmail({ user, url, token: _token }) {
					token = _token;
				},
				autoSignInAfterVerification: true,
			},
			user: {
				changeEmail: {
					enabled: true,
					async sendChangeEmailVerification(data, request) {
						token = data.token;
					},
				},
			},
		});

	it("should verify email", async () => {
		await auth.api.sendVerificationEmail({
			body: {
				email: testUser.email,
			},
		});
		const headers = new Headers();
		await client.verifyEmail({
			query: {
				token,
			},
			fetchOptions: {
				onSuccess: cookieSetter(headers),
			},
		});
		const session = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(session.data?.user.email).toBe(testUser.email);
		expect(session.data?.user.emailVerified).toBe(true);
	});

	it("should change email", async () => {
		const { headers } = await signInWithTestUser();
		await auth.api.changeEmail({
			body: {
				newEmail: "new@email.com",
			},
			headers,
		});
		const newHeaders = new Headers();
		await client.verifyEmail({
			query: {
				token,
			},
			fetchOptions: {
				onSuccess: cookieSetter(newHeaders),
				headers,
			},
		});
		const session = await client.getSession({
			fetchOptions: {
				headers: newHeaders,
			},
		});
		expect(session.data?.user.email).toBe("new@email.com");
		expect(session.data?.user.emailVerified).toBe(false);
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/email-verification.ts
```typescript
import { z } from "zod";
import { createAuthEndpoint } from "../call";
import { APIError } from "better-call";
import { getSessionFromCtx } from "./session";
import { setSessionCookie } from "../../cookies";
import type { GenericEndpointContext, User } from "../../types";
import { BASE_ERROR_CODES } from "../../error/codes";
import { jwtVerify, type JWTPayload, type JWTVerifyResult } from "jose";
import { signJWT } from "../../crypto/jwt";
import { originCheck } from "../middlewares";
import { JWTExpired } from "jose/errors";

export async function createEmailVerificationToken(
	secret: string,
	email: string,
	/**
	 * The email to update from
	 */
	updateTo?: string,
	/**
	 * The time in seconds for the token to expire
	 */
	expiresIn: number = 3600,
) {
	const token = await signJWT(
		{
			email: email.toLowerCase(),
			updateTo,
		},
		secret,
		expiresIn,
	);
	return token;
}

/**
 * A function to send a verification email to the user
 */
export async function sendVerificationEmailFn(
	ctx: GenericEndpointContext,
	user: User,
) {
	if (!ctx.context.options.emailVerification?.sendVerificationEmail) {
		ctx.context.logger.error("Verification email isn't enabled.");
		throw new APIError("BAD_REQUEST", {
			message: "Verification email isn't enabled",
		});
	}
	const token = await createEmailVerificationToken(
		ctx.context.secret,
		user.email,
		undefined,
		ctx.context.options.emailVerification?.expiresIn,
	);
	const url = `${ctx.context.baseURL}/verify-email?token=${token}&callbackURL=${
		ctx.body.callbackURL || "/"
	}`;
	await ctx.context.options.emailVerification.sendVerificationEmail(
		{
			user: user,
			url,
			token,
		},
		ctx.request,
	);
}

export const sendVerificationEmail = createAuthEndpoint(
	"/send-verification-email",
	{
		method: "POST",
		body: z.object({
			email: z
				.string({
					description: "The email to send the verification email to",
				})
				.email(),
			callbackURL: z
				.string({
					description: "The URL to use for email verification callback",
				})
				.optional(),
		}),
		metadata: {
			openapi: {
				description: "Send a verification email to the user",
				requestBody: {
					content: {
						"application/json": {
							schema: {
								type: "object",
								properties: {
									email: {
										type: "string",
										description: "The email to send the verification email to",
									},
									callbackURL: {
										type: "string",
										description:
											"The URL to use for email verification callback",
									},
								},
								required: ["email"],
							},
						},
					},
				},
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										status: {
											type: "boolean",
										},
									},
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		if (!ctx.context.options.emailVerification?.sendVerificationEmail) {
			ctx.context.logger.error("Verification email isn't enabled.");
			throw new APIError("BAD_REQUEST", {
				message: "Verification email isn't enabled",
			});
		}
		const { email } = ctx.body;
		const user = await ctx.context.internalAdapter.findUserByEmail(email);
		if (!user) {
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.USER_NOT_FOUND,
			});
		}
		await sendVerificationEmailFn(ctx, user.user);
		return ctx.json({
			status: true,
		});
	},
);

export const verifyEmail = createAuthEndpoint(
	"/verify-email",
	{
		method: "GET",
		query: z.object({
			token: z.string({
				description: "The token to verify the email",
			}),
			callbackURL: z
				.string({
					description: "The URL to redirect to after email verification",
				})
				.optional(),
		}),
		use: [originCheck((ctx) => ctx.query.callbackURL)],
		metadata: {
			openapi: {
				description: "Verify the email of the user",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										user: {
											type: "object",
											ref: "#/components/schemas/User",
										},
										status: {
											type: "boolean",
										},
									},
									required: ["user", "status"],
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		function redirectOnError(error: string) {
			if (ctx.query.callbackURL) {
				if (ctx.query.callbackURL.includes("?")) {
					throw ctx.redirect(`${ctx.query.callbackURL}&error=${error}`);
				}
				throw ctx.redirect(`${ctx.query.callbackURL}?error=${error}`);
			}
			throw new APIError("UNAUTHORIZED", {
				message: error,
			});
		}
		const { token } = ctx.query;
		let jwt: JWTVerifyResult<JWTPayload>;
		try {
			jwt = await jwtVerify(
				token,
				new TextEncoder().encode(ctx.context.secret),
				{
					algorithms: ["HS256"],
				},
			);
		} catch (e) {
			if (e instanceof JWTExpired) {
				return redirectOnError("token_expired");
			}
			return redirectOnError("invalid_token");
		}
		const schema = z.object({
			email: z.string().email(),
			updateTo: z.string().optional(),
		});
		const parsed = schema.parse(jwt.payload);
		const user = await ctx.context.internalAdapter.findUserByEmail(
			parsed.email,
		);
		if (!user) {
			return redirectOnError("user_not_found");
		}
		if (parsed.updateTo) {
			const session = await getSessionFromCtx(ctx);
			if (!session) {
				if (ctx.query.callbackURL) {
					throw ctx.redirect(`${ctx.query.callbackURL}?error=unauthorized`);
				}
				return redirectOnError("unauthorized");
			}
			if (session.user.email !== parsed.email) {
				if (ctx.query.callbackURL) {
					throw ctx.redirect(`${ctx.query.callbackURL}?error=unauthorized`);
				}
				return redirectOnError("unauthorized");
			}

			const updatedUser = await ctx.context.internalAdapter.updateUserByEmail(
				parsed.email,
				{
					email: parsed.updateTo,
					emailVerified: false,
				},
				ctx,
			);

			const newToken = await createEmailVerificationToken(
				ctx.context.secret,
				parsed.updateTo,
			);

			//send verification email to the new email
			await ctx.context.options.emailVerification?.sendVerificationEmail?.(
				{
					user: updatedUser,
					url: `${
						ctx.context.baseURL
					}/verify-email?token=${newToken}&callbackURL=${
						ctx.query.callbackURL || "/"
					}`,
					token: newToken,
				},
				ctx.request,
			);

			await setSessionCookie(ctx, {
				session: session.session,
				user: {
					...session.user,
					email: parsed.updateTo,
					emailVerified: false,
				},
			});

			if (ctx.query.callbackURL) {
				throw ctx.redirect(ctx.query.callbackURL);
			}
			return ctx.json({
				status: true,
				user: {
					id: updatedUser.id,
					email: updatedUser.email,
					name: updatedUser.name,
					image: updatedUser.image,
					emailVerified: updatedUser.emailVerified,
					createdAt: updatedUser.createdAt,
					updatedAt: updatedUser.updatedAt,
				},
			});
		}
		await ctx.context.options.emailVerification?.onEmailVerification?.(
			user.user,
			ctx.request,
		);
		await ctx.context.internalAdapter.updateUserByEmail(
			parsed.email,
			{
				emailVerified: true,
			},
			ctx,
		);
		if (ctx.context.options.emailVerification?.autoSignInAfterVerification) {
			const currentSession = await getSessionFromCtx(ctx);
			if (!currentSession || currentSession.user.email !== parsed.email) {
				const session = await ctx.context.internalAdapter.createSession(
					user.user.id,
					ctx.request,
				);
				if (!session) {
					throw new APIError("INTERNAL_SERVER_ERROR", {
						message: "Failed to create session",
					});
				}
				await setSessionCookie(ctx, {
					session,
					user: {
						...user.user,
						emailVerified: true,
					},
				});
			} else {
				await setSessionCookie(ctx, {
					session: currentSession.session,
					user: {
						...currentSession.user,
						emailVerified: true,
					},
				});
			}
		}

		if (ctx.query.callbackURL) {
			throw ctx.redirect(ctx.query.callbackURL);
		}
		return ctx.json({
			status: true,
			user: null,
		});
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/error.ts
```typescript
import { HIDE_METADATA } from "../../utils/hide-metadata";
import { createAuthEndpoint } from "../call";

function sanitize(input: string): string {
	return input
		.replace(/&/g, "&amp;")
		.replace(/</g, "&lt;")
		.replace(/>/g, "&gt;")
		.replace(/"/g, "&quot;")
		.replace(/'/g, "&#39;");
}

const html = (errorCode: string = "Unknown") => `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Authentication Error</title>
    <style>
        :root {
            --bg-color: #f8f9fa;
            --text-color: #212529;
            --accent-color: #000000;
            --error-color: #dc3545;
            --border-color: #e9ecef;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            line-height: 1.5;
        }
        .error-container {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            padding: 2.5rem;
            text-align: center;
            max-width: 90%;
            width: 400px;
        }
        h1 {
            color: var(--error-color);
            font-size: 1.75rem;
            margin-bottom: 1rem;
            font-weight: 600;
        }
        p {
            margin-bottom: 1.5rem;
            color: #495057;
        }
        .btn {
            background-color: var(--accent-color);
            color: #ffffff;
            text-decoration: none;
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            transition: all 0.3s ease;
            display: inline-block;
            font-weight: 500;
            border: 2px solid var(--accent-color);
        }
        .btn:hover {
            background-color: #131721;
        }
        .error-code {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border-color);
        }
        .icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="icon">⚠️</div>
        <h1>Better Auth Error</h1>
        <p>We encountered an issue while processing your request. Please try again or contact the application owner if the problem persists.</p>
        <a href="/" id="returnLink" class="btn">Return to Application</a>
        <div class="error-code">Error Code: <span id="errorCode">${sanitize(
					errorCode,
				)}</span></div>
    </div>
</body>
</html>`;

export const error = createAuthEndpoint(
	"/error",
	{
		method: "GET",
		metadata: {
			...HIDE_METADATA,
			openapi: {
				description: "Displays an error page",
				responses: {
					"200": {
						description: "Success",
						content: {
							"text/html": {
								schema: {
									type: "string",
								},
							},
						},
					},
				},
			},
		},
	},
	async (c) => {
		const query =
			new URL(c.request?.url || "").searchParams.get("error") || "Unknown";
		return new Response(html(query), {
			headers: {
				"Content-Type": "text/html",
			},
		});
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/forget-password.test.ts
```typescript
import { describe, expect, vi } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";

describe("forget password", async (it) => {
	const mockSendEmail = vi.fn();
	let token = "";

	const { client, testUser } = await getTestInstance(
		{
			emailAndPassword: {
				enabled: true,
				async sendResetPassword({ url }) {
					token = url.split("?")[0].split("/").pop() || "";
					await mockSendEmail();
				},
			},
		},
		{
			testWith: "sqlite",
		},
	);
	it("should send a reset password email when enabled", async () => {
		await client.forgetPassword({
			email: testUser.email,
			redirectTo: "http://localhost:3000",
		});
		expect(token.length).toBeGreaterThan(10);
	});

	it("should fail on invalid password", async () => {
		const res = await client.resetPassword(
			{
				newPassword: "short",
			},
			{
				query: {
					token,
				},
			},
		);
		expect(res.error?.status).toBe(400);
	});

	it("should verify the token", async () => {
		const newPassword = "new-password";
		const res = await client.resetPassword(
			{
				newPassword,
			},
			{
				query: {
					token,
				},
			},
		);
		expect(res.data).toMatchObject({
			status: true,
		});
	});

	it("should sign-in with the new password", async () => {
		const withOldCred = await client.signIn.email({
			email: testUser.email,
			password: testUser.email,
		});
		expect(withOldCred.error?.status).toBe(401);
		const newCred = await client.signIn.email({
			email: testUser.email,
			password: "new-password",
		});
		expect(newCred.data?.user).toBeDefined();
	});

	it("shouldn't allow the token to be used twice", async () => {
		const newPassword = "new-password";
		const res = await client.resetPassword(
			{
				newPassword,
			},
			{
				query: {
					token,
				},
			},
		);

		expect(res.error?.status).toBe(400);
	});

	it("should expire", async () => {
		const { client, signInWithTestUser, testUser } = await getTestInstance({
			emailAndPassword: {
				enabled: true,
				async sendResetPassword({ token: _token }) {
					token = _token;
					await mockSendEmail();
				},
				resetPasswordTokenExpiresIn: 10,
			},
		});
		const { headers } = await signInWithTestUser();
		await client.forgetPassword({
			email: testUser.email,
			redirectTo: "/sign-in",
			fetchOptions: {
				headers,
			},
		});
		vi.useFakeTimers();
		await vi.advanceTimersByTimeAsync(1000 * 9);
		const callbackRes = await client.$fetch("/reset-password/:token", {
			params: {
				token,
			},
			query: {
				callbackURL: "/cb",
			},
			onError(context) {
				const location = context.response.headers.get("location");
				expect(location).not.toContain("error");
				expect(location).toContain("token");
			},
		});
		const res = await client.resetPassword({
			newPassword: "new-password",
			token,
		});
		expect(res.data?.status).toBe(true);
		await client.forgetPassword({
			email: testUser.email,
			redirectTo: "/sign-in",
			fetchOptions: {
				headers,
			},
		});
		vi.useFakeTimers();
		await vi.advanceTimersByTimeAsync(1000 * 11);
		const res2 = await client.resetPassword({
			newPassword: "new-password",
			token,
		});
		expect(res2.error?.status).toBe(400);
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/forget-password.ts
```typescript
import { z } from "zod";
import { createAuthEndpoint } from "../call";
import { APIError } from "better-call";
import type { AuthContext } from "../../init";
import { getDate } from "../../utils/date";
import { generateId } from "../../utils";
import { BASE_ERROR_CODES } from "../../error/codes";
import { originCheck } from "../middlewares";

function redirectError(
	ctx: AuthContext,
	callbackURL: string | undefined,
	query?: Record<string, string>,
): string {
	const url = callbackURL
		? new URL(callbackURL, ctx.baseURL)
		: new URL(`${ctx.baseURL}/error`);
	if (query)
		Object.entries(query).forEach(([k, v]) => url.searchParams.set(k, v));
	return url.href;
}

function redirectCallback(
	ctx: AuthContext,
	callbackURL: string,
	query?: Record<string, string>,
): string {
	const url = new URL(callbackURL, ctx.baseURL);
	if (query)
		Object.entries(query).forEach(([k, v]) => url.searchParams.set(k, v));
	return url.href;
}

export const forgetPassword = createAuthEndpoint(
	"/forget-password",
	{
		method: "POST",
		body: z.object({
			/**
			 * The email address of the user to send a password reset email to.
			 */
			email: z
				.string({
					description:
						"The email address of the user to send a password reset email to",
				})
				.email(),
			/**
			 * The URL to redirect the user to reset their password.
			 * If the token isn't valid or expired, it'll be redirected with a query parameter `?
			 * error=INVALID_TOKEN`. If the token is valid, it'll be redirected with a query parameter `?
			 * token=VALID_TOKEN
			 */
			redirectTo: z
				.string({
					description:
						"The URL to redirect the user to reset their password. If the token isn't valid or expired, it'll be redirected with a query parameter `?error=INVALID_TOKEN`. If the token is valid, it'll be redirected with a query parameter `?token=VALID_TOKEN",
				})
				.optional(),
		}),
		metadata: {
			openapi: {
				description: "Send a password reset email to the user",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										status: {
											type: "boolean",
										},
									},
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		if (!ctx.context.options.emailAndPassword?.sendResetPassword) {
			ctx.context.logger.error(
				"Reset password isn't enabled.Please pass an emailAndPassword.sendResetPassword function in your auth config!",
			);
			throw new APIError("BAD_REQUEST", {
				message: "Reset password isn't enabled",
			});
		}
		const { email, redirectTo } = ctx.body;

		const user = await ctx.context.internalAdapter.findUserByEmail(email, {
			includeAccounts: true,
		});
		if (!user) {
			ctx.context.logger.error("Reset Password: User not found", { email });
			return ctx.json({
				status: true,
			});
		}
		const defaultExpiresIn = 60 * 60 * 1;
		const expiresAt = getDate(
			ctx.context.options.emailAndPassword.resetPasswordTokenExpiresIn ||
				defaultExpiresIn,
			"sec",
		);
		const verificationToken = generateId(24);
		await ctx.context.internalAdapter.createVerificationValue({
			value: user.user.id,
			identifier: `reset-password:${verificationToken}`,
			expiresAt,
		});
		const url = `${ctx.context.baseURL}/reset-password/${verificationToken}?callbackURL=${redirectTo}`;
		await ctx.context.options.emailAndPassword.sendResetPassword(
			{
				user: user.user,
				url,
				token: verificationToken,
			},
			ctx.request,
		);
		return ctx.json({
			status: true,
		});
	},
);

export const forgetPasswordCallback = createAuthEndpoint(
	"/reset-password/:token",
	{
		method: "GET",
		query: z.object({
			callbackURL: z.string({
				description: "The URL to redirect the user to reset their password",
			}),
		}),
		use: [originCheck((ctx) => ctx.query.callbackURL)],
		metadata: {
			openapi: {
				description: "Redirects the user to the callback URL with the token",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										token: {
											type: "string",
										},
									},
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		const { token } = ctx.params;
		const { callbackURL } = ctx.query;
		if (!token || !callbackURL) {
			throw ctx.redirect(
				redirectError(ctx.context, callbackURL, { error: "INVALID_TOKEN" }),
			);
		}
		const verification =
			await ctx.context.internalAdapter.findVerificationValue(
				`reset-password:${token}`,
			);
		if (!verification || verification.expiresAt < new Date()) {
			throw ctx.redirect(
				redirectError(ctx.context, callbackURL, { error: "INVALID_TOKEN" }),
			);
		}

		throw ctx.redirect(redirectCallback(ctx.context, callbackURL, { token }));
	},
);

export const resetPassword = createAuthEndpoint(
	"/reset-password",
	{
		method: "POST",
		query: z
			.object({
				token: z.string().optional(),
			})
			.optional(),
		body: z.object({
			newPassword: z.string({
				description: "The new password to set",
			}),
			token: z
				.string({
					description: "The token to reset the password",
				})
				.optional(),
		}),
		metadata: {
			openapi: {
				description: "Reset the password for a user",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										status: {
											type: "boolean",
										},
									},
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		const token = ctx.body.token || ctx.query?.token;
		if (!token) {
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.INVALID_TOKEN,
			});
		}

		const { newPassword } = ctx.body;

		const minLength = ctx.context.password?.config.minPasswordLength;
		const maxLength = ctx.context.password?.config.maxPasswordLength;
		if (newPassword.length < minLength) {
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.PASSWORD_TOO_SHORT,
			});
		}
		if (newPassword.length > maxLength) {
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.PASSWORD_TOO_LONG,
			});
		}

		const id = `reset-password:${token}`;

		const verification =
			await ctx.context.internalAdapter.findVerificationValue(id);
		if (!verification || verification.expiresAt < new Date()) {
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.INVALID_TOKEN,
			});
		}
		const userId = verification.value;
		const hashedPassword = await ctx.context.password.hash(newPassword);
		const accounts = await ctx.context.internalAdapter.findAccounts(userId);
		const account = accounts.find((ac) => ac.providerId === "credential");
		if (!account) {
			await ctx.context.internalAdapter.createAccount(
				{
					userId,
					providerId: "credential",
					password: hashedPassword,
					accountId: userId,
				},
				ctx,
			);
			await ctx.context.internalAdapter.deleteVerificationValue(
				verification.id,
			);

			return ctx.json({
				status: true,
			});
		}
		await ctx.context.internalAdapter.updatePassword(
			userId,
			hashedPassword,
			ctx,
		);
		await ctx.context.internalAdapter.deleteVerificationValue(verification.id);

		return ctx.json({
			status: true,
		});
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/index.ts
```typescript
export * from "./sign-in";
export * from "./callback";
export * from "./session";
export * from "./sign-out";
export * from "./forget-password";
export * from "./email-verification";
export * from "./update-user";
export * from "./error";
export * from "./ok";
export * from "./sign-up";
export * from "./account";
export * from "./refresh-token";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/ok.ts
```typescript
import { HIDE_METADATA } from "../../utils/hide-metadata";
import { createAuthEndpoint } from "../call";

export const ok = createAuthEndpoint(
	"/ok",
	{
		method: "GET",
		metadata: {
			...HIDE_METADATA,
			openapi: {
				description: "Check if the API is working",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										ok: {
											type: "boolean",
										},
									},
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		return ctx.json({
			ok: true,
		});
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/refresh-token.ts
```typescript
import { createAuthEndpoint } from "../call";
import { z } from "zod";
import { APIError } from "better-call";
import type { OAuth2Tokens } from "../../oauth2";
import { getSessionFromCtx } from "./session";

export const refreshToken = createAuthEndpoint(
	"/refresh-token",
	{
		method: "POST",
		body: z.object({
			providerId: z.string({
				description: "The provider ID for the OAuth provider",
			}),
			accountId: z
				.string({
					description: "The account ID associated with the refresh token",
				})
				.optional(),
			userId: z
				.string({
					description: "The user ID associated with the account",
				})
				.optional(),
		}),
		metadata: {
			openapi: {
				description: "Refresh the access token using a refresh token",
				responses: {
					200: {
						description: "Access token refreshed successfully",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										tokenType: {
											type: "string",
										},
										idToken: {
											type: "string",
										},
										accessToken: {
											type: "string",
										},
										refreshToken: {
											type: "string",
										},
										accessTokenExpiresAt: {
											type: "string",
											format: "date-time",
										},
										refreshTokenExpiresAt: {
											type: "string",
											format: "date-time",
										},
									},
								},
							},
						},
					},
					400: {
						description: "Invalid refresh token or provider configuration",
					},
				},
			},
		},
	},
	async (ctx) => {
		const { providerId, accountId, userId } = ctx.body;
		const req = ctx.request;
		const session = await getSessionFromCtx(ctx);
		if (req && !session) {
			throw ctx.error("UNAUTHORIZED");
		}
		let resolvedUserId = session?.user?.id || userId;
		if (!resolvedUserId) {
			throw new APIError("BAD_REQUEST", {
				message: `Either userId or session is required`,
			});
		}
		const accounts =
			await ctx.context.internalAdapter.findAccounts(resolvedUserId);
		const account = accounts.find((acc) =>
			accountId
				? acc.id === accountId && acc.providerId === providerId
				: acc.providerId === providerId,
		);
		if (!account) {
			throw new APIError("BAD_REQUEST", {
				message: "Account not found",
			});
		}
		const provider = ctx.context.socialProviders.find(
			(p) => p.id === providerId,
		);
		if (!provider) {
			throw new APIError("BAD_REQUEST", {
				message: `Provider ${providerId} not found.`,
			});
		}
		if (!provider.refreshAccessToken) {
			throw new APIError("BAD_REQUEST", {
				message: `Provider ${providerId} does not support token refreshing.`,
			});
		}
		try {
			const tokens: OAuth2Tokens = await provider.refreshAccessToken(
				account.refreshToken as string,
			);
			await ctx.context.internalAdapter.updateAccount(account.id, {
				accessToken: tokens.accessToken,
				accessTokenExpiresAt: tokens.accessTokenExpiresAt,
				refreshToken: tokens.refreshToken,
				refreshTokenExpiresAt: tokens.refreshTokenExpiresAt,
			});
			return ctx.json(tokens);
		} catch (error) {
			throw new APIError("BAD_REQUEST", {
				message: "Failed to refresh access token",
				cause: error,
			});
		}
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/session-api.test.ts
```typescript
import { describe, expect, it, vi } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";
import { parseSetCookieHeader } from "../../cookies";
import { getDate } from "../../utils/date";
import { memoryAdapter, type MemoryDB } from "../../adapters/memory-adapter";

describe("session", async () => {
	const { client, testUser, sessionSetter, cookieSetter, auth } =
		await getTestInstance();

	it("should set cookies correctly on sign in", async () => {
		const headers = new Headers();
		await client.signIn.email(
			{
				email: testUser.email,
				password: testUser.password,
			},
			{
				onSuccess(context) {
					const header = context.response.headers.get("set-cookie");
					const cookies = parseSetCookieHeader(header || "");
					cookieSetter(headers)(context);
					const cookie = cookies.get("better-auth.session_token");
					expect(cookie).toMatchObject({
						value: expect.any(String),
						"max-age": 60 * 60 * 24 * 7,
						path: "/",
						samesite: "lax",
						httponly: true,
					});
				},
			},
		);
		const { data } = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		const expiresAt = new Date(data?.session.expiresAt || "");
		const now = new Date();

		expect(expiresAt.getTime()).toBeGreaterThan(
			now.getTime() + 6 * 24 * 60 * 60 * 1000,
		);
	});

	it("should return null when not authenticated", async () => {
		const response = await client.getSession();
		expect(response.data).toBeNull();
	});

	it("should update session when update age is reached", async () => {
		const { client, testUser } = await getTestInstance({
			session: {
				updateAge: 60,
				expiresIn: 60 * 2,
			},
		});
		let headers = new Headers();

		await client.signIn.email(
			{
				email: testUser.email,
				password: testUser.password,
			},
			{
				onSuccess(context) {
					const header = context.response.headers.get("set-cookie");
					const cookies = parseSetCookieHeader(header || "");
					const signedCookie = cookies.get("better-auth.session_token")?.value;
					headers.set("cookie", `better-auth.session_token=${signedCookie}`);
				},
			},
		);

		const data = await client.getSession({
			fetchOptions: {
				headers,
				throw: true,
			},
		});

		if (!data) {
			throw new Error("No session found");
		}
		expect(new Date(data?.session.expiresAt).getTime()).toBeGreaterThan(
			new Date(Date.now() + 1000 * 2 * 59).getTime(),
		);

		expect(new Date(data?.session.expiresAt).getTime()).toBeLessThan(
			new Date(Date.now() + 1000 * 2 * 60).getTime(),
		);
		for (const t of [60, 80, 100, 121]) {
			const span = new Date();
			span.setSeconds(span.getSeconds() + t);
			vi.setSystemTime(span);
			const response = await client.getSession({
				fetchOptions: {
					headers,
					onSuccess(context) {
						const parsed = parseSetCookieHeader(
							context.response.headers.get("set-cookie") || "",
						);
						const maxAge = parsed.get("better-auth.session_token")?.["max-age"];
						expect(maxAge).toBe(t === 121 ? 0 : 60 * 2);
					},
				},
			});
			if (t === 121) {
				//expired
				expect(response.data).toBeNull();
			} else {
				expect(
					new Date(response.data?.session.expiresAt!).getTime(),
				).toBeGreaterThan(new Date(Date.now() + 1000 * 2 * 59).getTime());
			}
		}
		vi.useRealTimers();
	});

	it("should update the session every time when set to 0", async () => {
		const { client, signInWithTestUser } = await getTestInstance({
			session: {
				updateAge: 0,
			},
		});
		const { headers } = await signInWithTestUser();

		const session = await client.getSession({
			fetchOptions: {
				headers,
			},
		});

		vi.useFakeTimers();
		await vi.advanceTimersByTimeAsync(1000 * 60 * 5);
		const session2 = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(session2.data?.session.expiresAt).not.toBe(
			session.data?.session.expiresAt,
		);
		expect(
			new Date(session2.data!.session.expiresAt).getTime(),
		).toBeGreaterThan(new Date(session.data!.session.expiresAt).getTime());
	});

	it("should handle 'don't remember me' option", async () => {
		let headers = new Headers();
		const res = await client.signIn.email(
			{
				email: testUser.email,
				password: testUser.password,
				rememberMe: false,
			},
			{
				onSuccess(context) {
					const header = context.response.headers.get("set-cookie");
					const cookies = parseSetCookieHeader(header || "");
					const signedCookie = cookies.get("better-auth.session_token")?.value;
					const dontRememberMe = cookies.get(
						"better-auth.dont_remember",
					)?.value;
					headers.set(
						"cookie",
						`better-auth.session_token=${signedCookie};better-auth.dont_remember=${dontRememberMe}`,
					);
				},
			},
		);
		const data = await client.getSession({
			fetchOptions: {
				headers,
				throw: true,
			},
		});
		if (!data) {
			throw new Error("No session found");
		}
		const expiresAt = data.session.expiresAt;
		expect(new Date(expiresAt).valueOf()).toBeLessThanOrEqual(
			getDate(1000 * 60 * 60 * 24).valueOf(),
		);
		const response = await client.getSession({
			fetchOptions: {
				headers,
			},
		});

		if (!response.data?.session) {
			throw new Error("No session found");
		}
		// Check that the session wasn't update
		expect(
			new Date(response.data.session.expiresAt).valueOf(),
		).toBeLessThanOrEqual(getDate(1000 * 60 * 60 * 24).valueOf());
	});

	it("should set cookies correctly on sign in after changing config", async () => {
		const headers = new Headers();
		await client.signIn.email(
			{
				email: testUser.email,
				password: testUser.password,
			},
			{
				onSuccess(context) {
					const header = context.response.headers.get("set-cookie");
					const cookies = parseSetCookieHeader(header || "");
					expect(cookies.get("better-auth.session_token")).toMatchObject({
						value: expect.any(String),
						"max-age": 60 * 60 * 24 * 7,
						path: "/",
						httponly: true,
						samesite: "lax",
					});
					headers.set(
						"cookie",
						`better-auth.session_token=${
							cookies.get("better-auth.session_token")?.value
						}`,
					);
				},
			},
		);
		const data = await client.getSession({
			fetchOptions: {
				headers,
				throw: true,
			},
		});
		if (!data) {
			throw new Error("No session found");
		}
		const expiresAt = new Date(data?.session?.expiresAt || "");
		const now = new Date();

		expect(expiresAt.getTime()).toBeGreaterThan(
			now.getTime() + 6 * 24 * 60 * 60 * 1000,
		);
	});

	it("should clear session on sign out", async () => {
		let headers = new Headers();
		const res = await client.signIn.email(
			{
				email: testUser.email,
				password: testUser.password,
			},
			{
				onSuccess(context) {
					const header = context.response.headers.get("set-cookie");
					const cookies = parseSetCookieHeader(header || "");
					const signedCookie = cookies.get("better-auth.session_token")?.value;
					headers.set("cookie", `better-auth.session_token=${signedCookie}`);
				},
			},
		);
		const data = await client.getSession({
			fetchOptions: {
				headers,
				throw: true,
			},
		});

		expect(data).not.toBeNull();
		await client.signOut({
			fetchOptions: {
				headers,
			},
		});
		const response = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(response.data);
	});

	it("should list sessions", async () => {
		const headers = new Headers();
		await client.signIn.email(
			{
				email: testUser.email,
				password: testUser.password,
			},
			{
				onSuccess: sessionSetter(headers),
			},
		);

		const response = await client.listSessions({
			fetchOptions: {
				headers,
			},
		});

		expect(response.data?.length).toBeGreaterThan(1);
	});

	it("should revoke session", async () => {
		const headers = new Headers();
		const headers2 = new Headers();
		const res = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
			fetchOptions: {
				onSuccess: sessionSetter(headers),
			},
		});
		await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
			fetchOptions: {
				onSuccess: sessionSetter(headers2),
			},
		});
		const session = await client.getSession({
			fetchOptions: {
				headers,
				throw: true,
			},
		});
		await client.revokeSession({
			fetchOptions: {
				headers,
			},
			token: session?.session?.token || "",
		});
		const newSession = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(newSession.data).toBeNull();
		const revokeRes = await client.revokeSessions({
			fetchOptions: {
				headers: headers2,
			},
		});
		expect(revokeRes.data?.status).toBe(true);
	});
});

describe("session storage", async () => {
	let store = new Map<string, string>();
	const { client, signInWithTestUser, db } = await getTestInstance({
		secondaryStorage: {
			set(key, value, ttl) {
				store.set(key, value);
			},
			get(key) {
				return store.get(key) || null;
			},
			delete(key) {
				store.delete(key);
			},
		},
		rateLimit: {
			enabled: false,
		},
	});

	it("should store session in secondary storage", async () => {
		//since the instance creates a session on init, we expect the store to have 2 item (1 for session and 1 for active sessions record for the user)
		expect(store.size).toBe(2);
		const { headers } = await signInWithTestUser();
		expect(store.size).toBe(3);
		const session = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(session.data).toMatchObject({
			session: {
				userId: expect.any(String),
				token: expect.any(String),
				expiresAt: expect.any(Date),
				ipAddress: expect.any(String),
				userAgent: expect.any(String),
			},
			user: {
				id: expect.any(String),
				name: "test user",
				email: "test@test.com",
				emailVerified: false,
				image: null,
				createdAt: expect.any(Date),
				updatedAt: expect.any(Date),
			},
		});
	});

	it("should list sessions", async () => {
		const { headers } = await signInWithTestUser();
		const response = await client.listSessions({
			fetchOptions: {
				headers,
			},
		});
		expect(response.data?.length).toBeGreaterThan(1);
	});

	it("should revoke session", async () => {
		const { headers } = await signInWithTestUser();
		const session = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(session.data).not.toBeNull();
		const res = await client.revokeSession({
			fetchOptions: {
				headers,
			},
			token: session.data?.session?.token || "",
		});
		const revokedSession = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(revokedSession.data).toBeNull();
	});
});

describe("cookie cache", async () => {
	const database: MemoryDB = {
		user: [],
		account: [],
		session: [],
		verification: [],
	};
	const adapter = memoryAdapter(database);

	const { client, testUser, auth, cookieSetter } = await getTestInstance({
		database: adapter,
		session: {
			cookieCache: {
				enabled: true,
			},
		},
	});
	const ctx = await auth.$context;

	it("should cache cookies", async () => {});
	const fn = vi.spyOn(ctx.adapter, "findOne");

	const headers = new Headers();
	it("should cache cookies", async () => {
		await client.signIn.email(
			{
				email: testUser.email,
				password: testUser.password,
			},
			{
				onSuccess(context) {
					const header = context.response.headers.get("set-cookie");
					const cookies = parseSetCookieHeader(header || "");
					headers.set(
						"cookie",
						`better-auth.session_token=${
							cookies.get("better-auth.session_token")?.value
						};better-auth.session_data=${
							cookies.get("better-auth.session_data")?.value
						}`,
					);
				},
			},
		);
		expect(fn).toHaveBeenCalledTimes(1);
		const session = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(session.data).not.toBeNull();
		expect(fn).toHaveBeenCalledTimes(1);
	});

	it("should disable cookie cache", async () => {
		const ctx = await auth.$context;

		const s = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(s.data?.user.emailVerified).toBe(false);
		await ctx.internalAdapter.updateUser(s.data?.user.id || "", {
			emailVerified: true,
		});
		expect(fn).toHaveBeenCalledTimes(1);

		const session = await client.getSession({
			query: {
				disableCookieCache: true,
			},
			fetchOptions: {
				headers,
			},
		});
		expect(session.data?.user.emailVerified).toBe(true);
		expect(session.data).not.toBeNull();
		expect(fn).toHaveBeenCalledTimes(3);
	});

	it("should reset cache when expires", async () => {
		expect(fn).toHaveBeenCalledTimes(3);
		await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		vi.useFakeTimers();
		await vi.advanceTimersByTimeAsync(1000 * 60 * 10); // 10 minutes
		await client.getSession({
			fetchOptions: {
				headers,
				onSuccess(context) {
					cookieSetter(headers)(context);
				},
			},
		});
		expect(fn).toHaveBeenCalledTimes(5);
		await client.getSession({
			fetchOptions: {
				headers,
				onSuccess(context) {
					cookieSetter(headers)(context);
				},
			},
		});
		expect(fn).toHaveBeenCalledTimes(5);
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/session.ts
```typescript
import { APIError } from "better-call";
import { createAuthEndpoint, createAuthMiddleware } from "../call";
import { getDate } from "../../utils/date";
import {
	deleteSessionCookie,
	setCookieCache,
	setSessionCookie,
} from "../../cookies";
import { z } from "zod";
import type {
	BetterAuthOptions,
	GenericEndpointContext,
	InferSession,
	InferUser,
	Session,
	User,
} from "../../types";
import type { Prettify } from "../../types/helper";
import { safeJSONParse } from "../../utils/json";
import { BASE_ERROR_CODES } from "../../error/codes";
import { createHMAC } from "@better-auth/utils/hmac";
import { base64 } from "@better-auth/utils/base64";
import { binary } from "@better-auth/utils/binary";

export const getSession = <Option extends BetterAuthOptions>() =>
	createAuthEndpoint(
		"/get-session",
		{
			method: "GET",
			query: z.optional(
				z.object({
					/**
					 * If cookie cache is enabled, it will disable the cache
					 * and fetch the session from the database
					 */
					disableCookieCache: z
						.optional(
							z
								.boolean({
									description:
										"Disable cookie cache and fetch session from database",
								})
								.or(z.string().transform((v) => v === "true")),
						)
						.optional(),
					disableRefresh: z
						.boolean({
							description:
								"Disable session refresh. Useful for checking session status, without updating the session",
						})
						.or(z.string().transform((v) => v === "true"))
						.optional(),
				}),
			),
			requireHeaders: true,
			metadata: {
				openapi: {
					description: "Get the current session",
					responses: {
						"200": {
							description: "Success",
							content: {
								"application/json": {
									schema: {
										type: "object",
										properties: {
											session: {
												type: "object",
												$ref: "#/components/schemas/Session",
											},
											user: {
												type: "object",
												$ref: "#/components/schemas/User",
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
		async (ctx) => {
			try {
				const sessionCookieToken = await ctx.getSignedCookie(
					ctx.context.authCookies.sessionToken.name,
					ctx.context.secret,
				);

				if (!sessionCookieToken) {
					return null;
				}
				const sessionDataCookie = ctx.getCookie(
					ctx.context.authCookies.sessionData.name,
				);
				const sessionDataPayload = sessionDataCookie
					? safeJSONParse<{
							session: {
								session: Session;
								user: User;
							};
							signature: string;
							expiresAt: number;
						}>(binary.decode(base64.decode(sessionDataCookie)))
					: null;

				if (sessionDataPayload) {
					const isValid = await createHMAC("SHA-256", "base64urlnopad").verify(
						ctx.context.secret,
						JSON.stringify({
							...sessionDataPayload.session,
							expiresAt: sessionDataPayload.expiresAt,
						}),
						sessionDataPayload.signature,
					);
					if (!isValid) {
						const dataCookie = ctx.context.authCookies.sessionData.name;
						ctx.setCookie(dataCookie, "", {
							maxAge: 0,
						});
					}
				}

				const dontRememberMe = await ctx.getSignedCookie(
					ctx.context.authCookies.dontRememberToken.name,
					ctx.context.secret,
				);
				/**
				 * If session data is present in the cookie, return it
				 */
				if (
					sessionDataPayload?.session &&
					ctx.context.options.session?.cookieCache?.enabled &&
					!ctx.query?.disableCookieCache
				) {
					const session = sessionDataPayload.session;
					const hasExpired =
						sessionDataPayload.expiresAt < Date.now() ||
						session.session.expiresAt < new Date();
					if (!hasExpired) {
						return ctx.json(
							session as {
								session: InferSession<Option>;
								user: InferUser<Option>;
							},
						);
					} else {
						const dataCookie = ctx.context.authCookies.sessionData.name;
						ctx.setCookie(dataCookie, "", {
							maxAge: 0,
						});
					}
				}

				const session =
					await ctx.context.internalAdapter.findSession(sessionCookieToken);
				ctx.context.session = session;
				if (!session || session.session.expiresAt < new Date()) {
					deleteSessionCookie(ctx);
					if (session) {
						/**
						 * if session expired clean up the session
						 */
						await ctx.context.internalAdapter.deleteSession(
							session.session.token,
						);
					}
					return ctx.json(null);
				}
				/**
				 * We don't need to update the session if the user doesn't want to be remembered
				 * or if the session refresh is disabled
				 */
				if (dontRememberMe || ctx.query?.disableRefresh) {
					return ctx.json(
						session as unknown as {
							session: InferSession<Option>;
							user: InferUser<Option>;
						},
					);
				}
				const expiresIn = ctx.context.sessionConfig.expiresIn;
				const updateAge = ctx.context.sessionConfig.updateAge;
				/**
				 * Calculate last updated date to throttle write updates to database
				 * Formula: ({expiry date} - sessionMaxAge) + sessionUpdateAge
				 *
				 * e.g. ({expiry date} - 30 days) + 1 hour
				 *
				 * inspired by: https://github.com/nextauthjs/next-auth/blob/main/packages/core/src/lib/actions/session.ts
				 */
				const sessionIsDueToBeUpdatedDate =
					session.session.expiresAt.valueOf() -
					expiresIn * 1000 +
					updateAge * 1000;
				const shouldBeUpdated = sessionIsDueToBeUpdatedDate <= Date.now();

				if (shouldBeUpdated) {
					const updatedSession =
						await ctx.context.internalAdapter.updateSession(
							session.session.token,
							{
								expiresAt: getDate(ctx.context.sessionConfig.expiresIn, "sec"),
							},
						);
					if (!updatedSession) {
						/**
						 * Handle case where session update fails (e.g., concurrent deletion)
						 */
						deleteSessionCookie(ctx);
						return ctx.json(null, { status: 401 });
					}
					const maxAge =
						(updatedSession.expiresAt.valueOf() - Date.now()) / 1000;
					await setSessionCookie(
						ctx,
						{
							session: updatedSession,
							user: session.user,
						},
						false,
						{
							maxAge,
						},
					);

					return ctx.json({
						session: updatedSession,
						user: session.user,
					} as unknown as {
						session: InferSession<Option>;
						user: InferUser<Option>;
					});
				}
				await setCookieCache(ctx, session);
				return ctx.json(
					session as unknown as {
						session: InferSession<Option>;
						user: InferUser<Option>;
					},
				);
			} catch (error) {
				ctx.context.logger.error("INTERNAL_SERVER_ERROR", error);
				throw new APIError("INTERNAL_SERVER_ERROR", {
					message: BASE_ERROR_CODES.FAILED_TO_GET_SESSION,
				});
			}
		},
	);

export const getSessionFromCtx = async <
	U extends Record<string, any> = Record<string, any>,
	S extends Record<string, any> = Record<string, any>,
>(
	ctx: GenericEndpointContext,
	config?: {
		disableCookieCache?: boolean;
		disableRefresh?: boolean;
	},
) => {
	if (ctx.context.session) {
		return ctx.context.session as {
			session: S & Session;
			user: U & User;
		};
	}

	const session = await getSession()({
		...ctx,
		asResponse: false,
		headers: ctx.headers!,
		returnHeaders: false,
		query: {
			...config,
			...ctx.query,
		},
	}).catch((e) => {
		return null;
	});
	ctx.context.session = session;
	return session as {
		session: S & Session;
		user: U & User;
	} | null;
};

export const sessionMiddleware = createAuthMiddleware(async (ctx) => {
	const session = await getSessionFromCtx(ctx);
	if (!session?.session) {
		throw new APIError("UNAUTHORIZED");
	}
	return {
		session,
	};
});

export const requestOnlySessionMiddleware = createAuthMiddleware(
	async (ctx) => {
		const session = await getSessionFromCtx(ctx);
		if (!session?.session && (ctx.request || ctx.headers)) {
			throw new APIError("UNAUTHORIZED");
		}
		return { session };
	},
);

export const freshSessionMiddleware = createAuthMiddleware(async (ctx) => {
	const session = await getSessionFromCtx(ctx);
	if (!session?.session) {
		throw new APIError("UNAUTHORIZED");
	}
	if (ctx.context.sessionConfig.freshAge === 0) {
		return {
			session,
		};
	}
	const freshAge = ctx.context.sessionConfig.freshAge;
	const lastUpdated =
		session.session.updatedAt?.valueOf() || session.session.createdAt.valueOf();
	const now = Date.now();
	const isFresh = now - lastUpdated < freshAge * 1000;
	if (!isFresh) {
		throw new APIError("FORBIDDEN", {
			message: "Session is not fresh",
		});
	}
	return {
		session,
	};
});

/**
 * user active sessions list
 */
export const listSessions = <Option extends BetterAuthOptions>() =>
	createAuthEndpoint(
		"/list-sessions",
		{
			method: "GET",
			use: [sessionMiddleware],
			requireHeaders: true,
			metadata: {
				openapi: {
					description: "List all active sessions for the user",
					responses: {
						"200": {
							description: "Success",
							content: {
								"application/json": {
									schema: {
										type: "array",
										items: {
											type: "object",
											properties: {
												token: {
													type: "string",
												},
												userId: {
													type: "string",
												},
												expiresAt: {
													type: "string",
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
		async (ctx) => {
			try {
				const sessions = await ctx.context.internalAdapter.listSessions(
					ctx.context.session.user.id,
				);
				const activeSessions = sessions.filter((session) => {
					return session.expiresAt > new Date();
				});
				return ctx.json(
					activeSessions as unknown as Prettify<InferSession<Option>>[],
				);
			} catch (e: any) {
				ctx.context.logger.error(e);
				throw ctx.error("INTERNAL_SERVER_ERROR");
			}
		},
	);

/**
 * revoke a single session
 */
export const revokeSession = createAuthEndpoint(
	"/revoke-session",
	{
		method: "POST",
		body: z.object({
			token: z.string({
				description: "The token to revoke",
			}),
		}),
		use: [sessionMiddleware],
		requireHeaders: true,
		metadata: {
			openapi: {
				description: "Revoke a single session",
				requestBody: {
					content: {
						"application/json": {
							schema: {
								type: "object",
								properties: {
									token: {
										type: "string",
									},
								},
								required: ["token"],
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		const token = ctx.body.token;
		const findSession = await ctx.context.internalAdapter.findSession(token);
		if (!findSession) {
			throw new APIError("BAD_REQUEST", {
				message: "Session not found",
			});
		}
		if (findSession.session.userId !== ctx.context.session.user.id) {
			throw new APIError("UNAUTHORIZED");
		}
		try {
			await ctx.context.internalAdapter.deleteSession(token);
		} catch (error) {
			ctx.context.logger.error(
				error && typeof error === "object" && "name" in error
					? (error.name as string)
					: "",
				error,
			);
			throw new APIError("INTERNAL_SERVER_ERROR");
		}
		return ctx.json({
			status: true,
		});
	},
);
/**
 * revoke all user sessions
 */
export const revokeSessions = createAuthEndpoint(
	"/revoke-sessions",
	{
		method: "POST",
		use: [sessionMiddleware],
		requireHeaders: true,
		metadata: {
			openapi: {
				description: "Revoke all sessions for the user",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										status: {
											type: "boolean",
										},
									},
									required: ["status"],
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		try {
			await ctx.context.internalAdapter.deleteSessions(
				ctx.context.session.user.id,
			);
		} catch (error) {
			ctx.context.logger.error(
				error && typeof error === "object" && "name" in error
					? (error.name as string)
					: "",
				error,
			);
			throw new APIError("INTERNAL_SERVER_ERROR");
		}
		return ctx.json({
			status: true,
		});
	},
);

export const revokeOtherSessions = createAuthEndpoint(
	"/revoke-other-sessions",
	{
		method: "POST",
		requireHeaders: true,
		use: [sessionMiddleware],
		metadata: {
			openapi: {
				description:
					"Revoke all other sessions for the user except the current one",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										status: {
											type: "boolean",
										},
									},
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		const session = ctx.context.session;
		if (!session.user) {
			throw new APIError("UNAUTHORIZED");
		}
		const sessions = await ctx.context.internalAdapter.listSessions(
			session.user.id,
		);
		const activeSessions = sessions.filter((session) => {
			return session.expiresAt > new Date();
		});
		const otherSessions = activeSessions.filter(
			(session) => session.token !== ctx.context.session.session.token,
		);
		await Promise.all(
			otherSessions.map((session) =>
				ctx.context.internalAdapter.deleteSession(session.token),
			),
		);
		return ctx.json({
			status: true,
		});
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/sign-in.test.ts
```typescript
import { describe, expect } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";
import { parseSetCookieHeader } from "../../cookies";

/**
 * More test can be found in `session.test.ts`
 */
describe("sign-in", async (it) => {
	const { auth, testUser, cookieSetter } = await getTestInstance();

	it("should return a response with a set-cookie header", async () => {
		const signInRes = await auth.api.signInEmail({
			body: {
				email: testUser.email,
				password: testUser.password,
			},
			asResponse: true,
		});
		const setCookie = signInRes.headers.get("set-cookie");
		const parsed = parseSetCookieHeader(setCookie || "");
		expect(parsed.get("better-auth.session_token")).toBeDefined();
	});

	it("should read the ip address and user agent from the headers", async () => {
		const headerObj = {
			"X-Forwarded-For": "127.0.0.1",
			"User-Agent": "Test",
		};
		const headers = new Headers(headerObj);
		const signInRes = await auth.api.signInEmail({
			body: {
				email: testUser.email,
				password: testUser.password,
			},
			asResponse: true,
			headers,
		});
		cookieSetter(headers)({
			response: signInRes,
		});
		const session = await auth.api.getSession({
			headers,
		});
		expect(session?.session.ipAddress).toBe(headerObj["X-Forwarded-For"]);
		expect(session?.session.userAgent).toBe(headerObj["User-Agent"]);
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/sign-in.ts
```typescript
import { APIError } from "better-call";
import { z } from "zod";
import { createAuthEndpoint } from "../call";
import { setSessionCookie } from "../../cookies";
import { SocialProviderListEnum } from "../../social-providers";
import { createEmailVerificationToken } from "./email-verification";
import { generateState } from "../../utils";
import { handleOAuthUserInfo } from "../../oauth2/link-account";
import { BASE_ERROR_CODES } from "../../error/codes";

export const signInSocial = createAuthEndpoint(
	"/sign-in/social",
	{
		method: "POST",
		body: z.object({
			/**
			 * Callback URL to redirect to after the user
			 * has signed in.
			 */
			callbackURL: z
				.string({
					description:
						"Callback URL to redirect to after the user has signed in",
				})
				.optional(),
			/**
			 * callback url to redirect if the user is newly registered.
			 *
			 * useful if you have different routes for existing users and new users
			 */
			newUserCallbackURL: z.string().optional(),
			/**
			 * Callback url to redirect to if an error happens
			 *
			 * If it's initiated from the client sdk this defaults to
			 * the current url.
			 */
			errorCallbackURL: z
				.string({
					description: "Callback URL to redirect to if an error happens",
				})
				.optional(),
			/**
			 * OAuth2 provider to use`
			 */
			provider: SocialProviderListEnum,
			/**
			 * Disable automatic redirection to the provider
			 *
			 * This is useful if you want to handle the redirection
			 * yourself like in a popup or a different tab.
			 */
			disableRedirect: z
				.boolean({
					description:
						"Disable automatic redirection to the provider. Useful for handling the redirection yourself",
				})
				.optional(),
			/**
			 * ID token from the provider
			 *
			 * This is used to sign in the user
			 * if the user is already signed in with the
			 * provider in the frontend.
			 *
			 * Only applicable if the provider supports
			 * it. Currently only `apple` and `google` is
			 * supported out of the box.
			 */
			idToken: z.optional(
				z.object({
					/**
					 * ID token from the provider
					 */
					token: z.string({
						description: "ID token from the provider",
					}),
					/**
					 * The nonce used to generate the token
					 */
					nonce: z
						.string({
							description: "Nonce used to generate the token",
						})
						.optional(),
					/**
					 * Access token from the provider
					 */
					accessToken: z
						.string({
							description: "Access token from the provider",
						})
						.optional(),
					/**
					 * Refresh token from the provider
					 */
					refreshToken: z
						.string({
							description: "Refresh token from the provider",
						})
						.optional(),
					/**
					 * Expiry date of the token
					 */
					expiresAt: z
						.number({
							description: "Expiry date of the token",
						})
						.optional(),
				}),
				{
					description:
						"ID token from the provider to sign in the user with id token",
				},
			),
			scopes: z
				.array(z.string(), {
					description:
						"Array of scopes to request from the provider. This will override the default scopes passed.",
				})
				.optional(),
			/**
			 * Explicitly request sign-up
			 *
			 * Should be used to allow sign up when
			 * disableImplicitSignUp for this provider is
			 * true
			 */
			requestSignUp: z
				.boolean({
					description:
						"Explicitly request sign-up. Useful when disableImplicitSignUp is true for this provider",
				})
				.optional(),
			/**
			 * The login hint to use for the authorization code request
			 */
			loginHint: z
				.string({
					description:
						"The login hint to use for the authorization code request",
				})
				.optional(),
		}),
		metadata: {
			openapi: {
				description: "Sign in with a social provider",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										token: {
											type: "string",
										},
										user: {
											type: "object",
											ref: "#/components/schemas/User",
										},
										url: {
											type: "string",
										},
										redirect: {
											type: "boolean",
										},
									},
									required: ["redirect"],
								},
							},
						},
					},
				},
			},
		},
	},
	async (c) => {
		const provider = c.context.socialProviders.find(
			(p) => p.id === c.body.provider,
		);
		if (!provider) {
			c.context.logger.error(
				"Provider not found. Make sure to add the provider in your auth config",
				{
					provider: c.body.provider,
				},
			);
			throw new APIError("NOT_FOUND", {
				message: BASE_ERROR_CODES.PROVIDER_NOT_FOUND,
			});
		}

		if (c.body.idToken) {
			if (!provider.verifyIdToken) {
				c.context.logger.error(
					"Provider does not support id token verification",
					{
						provider: c.body.provider,
					},
				);
				throw new APIError("NOT_FOUND", {
					message: BASE_ERROR_CODES.ID_TOKEN_NOT_SUPPORTED,
				});
			}
			const { token, nonce } = c.body.idToken;
			const valid = await provider.verifyIdToken(token, nonce);
			if (!valid) {
				c.context.logger.error("Invalid id token", {
					provider: c.body.provider,
				});
				throw new APIError("UNAUTHORIZED", {
					message: BASE_ERROR_CODES.INVALID_TOKEN,
				});
			}
			const userInfo = await provider.getUserInfo({
				idToken: token,
				accessToken: c.body.idToken.accessToken,
				refreshToken: c.body.idToken.refreshToken,
			});
			if (!userInfo || !userInfo?.user) {
				c.context.logger.error("Failed to get user info", {
					provider: c.body.provider,
				});
				throw new APIError("UNAUTHORIZED", {
					message: BASE_ERROR_CODES.FAILED_TO_GET_USER_INFO,
				});
			}
			if (!userInfo.user.email) {
				c.context.logger.error("User email not found", {
					provider: c.body.provider,
				});
				throw new APIError("UNAUTHORIZED", {
					message: BASE_ERROR_CODES.USER_EMAIL_NOT_FOUND,
				});
			}
			const data = await handleOAuthUserInfo(c, {
				userInfo: {
					email: userInfo.user.email,
					id: userInfo.user.id,
					name: userInfo.user.name || "",
					image: userInfo.user.image,
					emailVerified: userInfo.user.emailVerified || false,
				},
				account: {
					providerId: provider.id,
					accountId: userInfo.user.id,
					accessToken: c.body.idToken.accessToken,
				},
				disableSignUp:
					(provider.disableImplicitSignUp && !c.body.requestSignUp) ||
					provider.disableSignUp,
			});
			if (data.error) {
				throw new APIError("UNAUTHORIZED", {
					message: data.error,
				});
			}
			await setSessionCookie(c, data.data!);
			return c.json({
				redirect: false,
				token: data.data!.session.token,
				url: undefined,
				user: {
					id: data.data!.user.id,
					email: data.data!.user.email,
					name: data.data!.user.name,
					image: data.data!.user.image,
					emailVerified: data.data!.user.emailVerified,
					createdAt: data.data!.user.createdAt,
					updatedAt: data.data!.user.updatedAt,
				},
			});
		}

		const { codeVerifier, state } = await generateState(c);
		const url = await provider.createAuthorizationURL({
			state,
			codeVerifier,
			redirectURI: `${c.context.baseURL}/callback/${provider.id}`,
			scopes: c.body.scopes,
			loginHint: c.body.loginHint,
		});

		return c.json({
			url: url.toString(),
			redirect: !c.body.disableRedirect,
		});
	},
);

export const signInEmail = createAuthEndpoint(
	"/sign-in/email",
	{
		method: "POST",
		body: z.object({
			/**
			 * Email of the user
			 */
			email: z.string({
				description: "Email of the user",
			}),
			/**
			 * Password of the user
			 */
			password: z.string({
				description: "Password of the user",
			}),
			/**
			 * Callback URL to use as a redirect for email
			 * verification and for possible redirects
			 */
			callbackURL: z
				.string({
					description:
						"Callback URL to use as a redirect for email verification",
				})
				.optional(),
			/**
			 * If this is false, the session will not be remembered
			 * @default true
			 */
			rememberMe: z
				.boolean({
					description:
						"If this is false, the session will not be remembered. Default is `true`.",
				})
				.default(true)
				.optional(),
		}),
		metadata: {
			openapi: {
				description: "Sign in with email and password",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										token: {
											type: "string",
										},
										user: {
											type: "object",
											ref: "#/components/schemas/User",
										},
										url: {
											type: "string",
										},
										redirect: {
											type: "boolean",
										},
									},
									required: ["token", "user", "redirect"],
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		if (!ctx.context.options?.emailAndPassword?.enabled) {
			ctx.context.logger.error(
				"Email and password is not enabled. Make sure to enable it in the options on you `auth.ts` file. Check `https://better-auth.com/docs/authentication/email-password` for more!",
			);
			throw new APIError("BAD_REQUEST", {
				message: "Email and password is not enabled",
			});
		}
		const { email, password } = ctx.body;
		const isValidEmail = z.string().email().safeParse(email);
		if (!isValidEmail.success) {
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.INVALID_EMAIL,
			});
		}
		const user = await ctx.context.internalAdapter.findUserByEmail(email, {
			includeAccounts: true,
		});

		if (!user) {
			await ctx.context.password.hash(password);
			ctx.context.logger.error("User not found", { email });
			throw new APIError("UNAUTHORIZED", {
				message: BASE_ERROR_CODES.INVALID_EMAIL_OR_PASSWORD,
			});
		}

		const credentialAccount = user.accounts.find(
			(a) => a.providerId === "credential",
		);
		if (!credentialAccount) {
			ctx.context.logger.error("Credential account not found", { email });
			throw new APIError("UNAUTHORIZED", {
				message: BASE_ERROR_CODES.INVALID_EMAIL_OR_PASSWORD,
			});
		}
		const currentPassword = credentialAccount?.password;
		if (!currentPassword) {
			ctx.context.logger.error("Password not found", { email });
			throw new APIError("UNAUTHORIZED", {
				message: BASE_ERROR_CODES.INVALID_EMAIL_OR_PASSWORD,
			});
		}
		const validPassword = await ctx.context.password.verify({
			hash: currentPassword,
			password,
		});
		if (!validPassword) {
			ctx.context.logger.error("Invalid password");
			throw new APIError("UNAUTHORIZED", {
				message: BASE_ERROR_CODES.INVALID_EMAIL_OR_PASSWORD,
			});
		}

		if (
			ctx.context.options?.emailAndPassword?.requireEmailVerification &&
			!user.user.emailVerified
		) {
			if (!ctx.context.options?.emailVerification?.sendVerificationEmail) {
				throw new APIError("FORBIDDEN", {
					message: BASE_ERROR_CODES.EMAIL_NOT_VERIFIED,
				});
			}
			const token = await createEmailVerificationToken(
				ctx.context.secret,
				user.user.email,
				undefined,
				ctx.context.options.emailVerification?.expiresIn,
			);
			const url = `${
				ctx.context.baseURL
			}/verify-email?token=${token}&callbackURL=${ctx.body.callbackURL || "/"}`;
			await ctx.context.options.emailVerification.sendVerificationEmail(
				{
					user: user.user,
					url,
					token,
				},
				ctx.request,
			);
			throw new APIError("FORBIDDEN", {
				message: BASE_ERROR_CODES.EMAIL_NOT_VERIFIED,
			});
		}

		const session = await ctx.context.internalAdapter.createSession(
			user.user.id,
			ctx.headers,
			ctx.body.rememberMe === false,
		);

		if (!session) {
			ctx.context.logger.error("Failed to create session");
			throw new APIError("UNAUTHORIZED", {
				message: BASE_ERROR_CODES.FAILED_TO_CREATE_SESSION,
			});
		}

		await setSessionCookie(
			ctx,
			{
				session,
				user: user.user,
			},
			ctx.body.rememberMe === false,
		);
		return ctx.json({
			redirect: !!ctx.body.callbackURL,
			token: session.token,
			url: ctx.body.callbackURL,
			user: {
				id: user.user.id,
				email: user.user.email,
				name: user.user.name,
				image: user.user.image,
				emailVerified: user.user.emailVerified,
				createdAt: user.user.createdAt,
				updatedAt: user.user.updatedAt,
			},
		});
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/sign-out.test.ts
```typescript
import { describe, expect } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";

describe("sign-out", async (it) => {
	const { signInWithTestUser, client } = await getTestInstance();

	it("should sign out", async () => {
		const { headers } = await signInWithTestUser();
		const res = await client.signOut({
			fetchOptions: {
				headers,
			},
		});
		expect(res.data).toMatchObject({
			success: true,
		});
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/sign-out.ts
```typescript
import { createAuthEndpoint } from "../call";
import { deleteSessionCookie } from "../../cookies";
import { APIError } from "better-call";
import { BASE_ERROR_CODES } from "../../error/codes";

export const signOut = createAuthEndpoint(
	"/sign-out",
	{
		method: "POST",
		requireHeaders: true,
		metadata: {
			openapi: {
				description: "Sign out the current user",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										success: {
											type: "boolean",
										},
									},
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		const sessionCookieToken = await ctx.getSignedCookie(
			ctx.context.authCookies.sessionToken.name,
			ctx.context.secret,
		);
		if (!sessionCookieToken) {
			deleteSessionCookie(ctx);
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.FAILED_TO_GET_SESSION,
			});
		}
		await ctx.context.internalAdapter.deleteSession(sessionCookieToken);
		deleteSessionCookie(ctx);
		return ctx.json({
			success: true,
		});
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/sign-up.test.ts
```typescript
import { describe, expect, vi } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";

describe("sign-up with custom fields", async (it) => {
	const mockFn = vi.fn();
	const { auth, db } = await getTestInstance(
		{
			account: {
				fields: {
					providerId: "provider_id",
					accountId: "account_id",
				},
			},
			user: {
				additionalFields: {
					newField: {
						type: "string",
						required: false,
					},
					newField2: {
						type: "string",
						required: false,
					},
				},
			},
			emailVerification: {
				sendOnSignUp: true,
				sendVerificationEmail: async ({ user, url, token }, request) => {
					mockFn(user, url);
				},
			},
		},
		{
			disableTestUser: true,
		},
	);
	it("should work with custom fields on account table", async () => {
		const res = await auth.api.signUpEmail({
			body: {
				email: "email@test.com",
				password: "password",
				name: "Test Name",
			},
		});
		expect(res.token).toBeDefined();
		const accounts = await db.findMany({
			model: "account",
		});
		expect(accounts).toHaveLength(1);
	});

	it("should send verification email", async () => {
		expect(mockFn).toHaveBeenCalledWith(expect.any(Object), expect.any(String));
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/sign-up.ts
```typescript
import { z } from "zod";
import { createAuthEndpoint } from "../call";
import { createEmailVerificationToken } from "./email-verification";
import { setSessionCookie } from "../../cookies";
import { APIError } from "better-call";
import type {
	AdditionalUserFieldsInput,
	BetterAuthOptions,
	User,
} from "../../types";
import { parseUserInput } from "../../db/schema";
import { BASE_ERROR_CODES } from "../../error/codes";
import { isDevelopment } from "../../utils/env";

export const signUpEmail = <O extends BetterAuthOptions>() =>
	createAuthEndpoint(
		"/sign-up/email",
		{
			method: "POST",
			body: z.record(z.string(), z.any()),
			metadata: {
				$Infer: {
					body: {} as {
						name: string;
						email: string;
						password: string;
					} & AdditionalUserFieldsInput<O>,
				},
				openapi: {
					description: "Sign up a user using email and password",
					requestBody: {
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										name: {
											type: "string",
											description: "The name of the user",
										},
										email: {
											type: "string",
											description: "The email of the user",
										},
										password: {
											type: "string",
											description: "The password of the user",
										},
										callbackURL: {
											type: "string",
											description:
												"The URL to use for email verification callback",
										},
									},
									required: ["name", "email", "password"],
								},
							},
						},
					},
					responses: {
						"200": {
							description: "Success",
							content: {
								"application/json": {
									schema: {
										type: "object",
										properties: {
											id: {
												type: "string",
												description: "The id of the user",
											},
											email: {
												type: "string",
												description: "The email of the user",
											},
											name: {
												type: "string",
												description: "The name of the user",
											},
											image: {
												type: "string",
												description: "The image of the user",
											},
											emailVerified: {
												type: "boolean",
												description: "If the email is verified",
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
		async (ctx) => {
			if (
				!ctx.context.options.emailAndPassword?.enabled ||
				ctx.context.options.emailAndPassword?.disableSignUp
			) {
				throw new APIError("BAD_REQUEST", {
					message: "Email and password sign up is not enabled",
				});
			}
			const body = ctx.body as any as User & {
				password: string;
				callbackURL?: string;
			} & {
				[key: string]: any;
			};
			const { name, email, password, image, callbackURL, ...additionalFields } =
				body;
			const isValidEmail = z.string().email().safeParse(email);

			if (!isValidEmail.success) {
				throw new APIError("BAD_REQUEST", {
					message: BASE_ERROR_CODES.INVALID_EMAIL,
				});
			}

			const minPasswordLength = ctx.context.password.config.minPasswordLength;
			if (password.length < minPasswordLength) {
				ctx.context.logger.error("Password is too short");
				throw new APIError("BAD_REQUEST", {
					message: BASE_ERROR_CODES.PASSWORD_TOO_SHORT,
				});
			}

			const maxPasswordLength = ctx.context.password.config.maxPasswordLength;
			if (password.length > maxPasswordLength) {
				ctx.context.logger.error("Password is too long");
				throw new APIError("BAD_REQUEST", {
					message: BASE_ERROR_CODES.PASSWORD_TOO_LONG,
				});
			}
			const dbUser = await ctx.context.internalAdapter.findUserByEmail(email);
			if (dbUser?.user) {
				ctx.context.logger.info(`Sign-up attempt for existing email: ${email}`);
				throw new APIError("UNPROCESSABLE_ENTITY", {
					message: BASE_ERROR_CODES.USER_ALREADY_EXISTS,
				});
			}

			const additionalData = parseUserInput(
				ctx.context.options,
				additionalFields as any,
			);
			let createdUser: User;
			try {
				createdUser = await ctx.context.internalAdapter.createUser(
					{
						email: email.toLowerCase(),
						name,
						image,
						...additionalData,
						emailVerified: false,
					},
					ctx,
				);
				if (!createdUser) {
					throw new APIError("BAD_REQUEST", {
						message: BASE_ERROR_CODES.FAILED_TO_CREATE_USER,
					});
				}
			} catch (e) {
				if (isDevelopment) {
					ctx.context.logger.error("Failed to create user", e);
				}
				throw new APIError("UNPROCESSABLE_ENTITY", {
					message: BASE_ERROR_CODES.FAILED_TO_CREATE_USER,
					details: e,
				});
			}
			if (!createdUser) {
				throw new APIError("UNPROCESSABLE_ENTITY", {
					message: BASE_ERROR_CODES.FAILED_TO_CREATE_USER,
				});
			}
			/**
			 * Link the account to the user
			 */
			const hash = await ctx.context.password.hash(password);
			await ctx.context.internalAdapter.linkAccount(
				{
					userId: createdUser.id,
					providerId: "credential",
					accountId: createdUser.id,
					password: hash,
				},
				ctx,
			);
			if (
				ctx.context.options.emailVerification?.sendOnSignUp ||
				ctx.context.options.emailAndPassword.requireEmailVerification
			) {
				const token = await createEmailVerificationToken(
					ctx.context.secret,
					createdUser.email,
					undefined,
					ctx.context.options.emailVerification?.expiresIn,
				);
				const url = `${
					ctx.context.baseURL
				}/verify-email?token=${token}&callbackURL=${body.callbackURL || "/"}`;
				await ctx.context.options.emailVerification?.sendVerificationEmail?.(
					{
						user: createdUser,
						url,
						token,
					},
					ctx.request,
				);
			}

			if (
				ctx.context.options.emailAndPassword.autoSignIn === false ||
				ctx.context.options.emailAndPassword.requireEmailVerification
			) {
				return ctx.json({
					token: null,
					user: {
						id: createdUser.id,
						email: createdUser.email,
						name: createdUser.name,
						image: createdUser.image,
						emailVerified: createdUser.emailVerified,
						createdAt: createdUser.createdAt,
						updatedAt: createdUser.updatedAt,
					},
				});
			}

			const session = await ctx.context.internalAdapter.createSession(
				createdUser.id,
				ctx.request,
			);
			if (!session) {
				throw new APIError("BAD_REQUEST", {
					message: BASE_ERROR_CODES.FAILED_TO_CREATE_SESSION,
				});
			}
			await setSessionCookie(ctx, {
				session,
				user: createdUser,
			});
			return ctx.json({
				token: session.token,
				user: {
					id: createdUser.id,
					email: createdUser.email,
					name: createdUser.name,
					image: createdUser.image,
					emailVerified: createdUser.emailVerified,
					createdAt: createdUser.createdAt,
					updatedAt: createdUser.updatedAt,
				},
			});
		},
	);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/update-user.test.ts
```typescript
import { describe, expect, it, vi } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";

describe("updateUser", async () => {
	const sendChangeEmail = vi.fn();
	let emailVerificationToken = "";
	const { client, testUser, sessionSetter, db, customFetchImpl } =
		await getTestInstance({
			emailVerification: {
				async sendVerificationEmail({ user, url, token }) {
					emailVerificationToken = token;
				},
			},
			user: {
				changeEmail: {
					enabled: true,
					sendChangeEmailVerification: async ({
						user,
						newEmail,
						url,
						token,
					}) => {
						sendChangeEmail(user, newEmail, url, token);
					},
				},
			},
		});
	const headers = new Headers();
	const session = await client.signIn.email({
		email: testUser.email,
		password: testUser.password,
		fetchOptions: {
			onSuccess: sessionSetter(headers),
			onRequest(context) {
				return context;
			},
		},
	});
	if (!session) {
		throw new Error("No session");
	}

	it("should update the user's name", async () => {
		const updated = await client.updateUser({
			name: "newName",
			image: "https://example.com/image.jpg",
			fetchOptions: {
				headers,
			},
		});
		const session = await client.getSession({
			fetchOptions: {
				headers,
				throw: true,
			},
		});
		expect(updated.data?.status).toBe(true);
		expect(session.user.name).toBe("newName");
	});

	it("should unset image", async () => {
		const updated = await client.updateUser({
			image: null,
			fetchOptions: {
				headers,
			},
		});
		const session = await client.getSession({
			fetchOptions: {
				headers,
				throw: true,
			},
		});
		expect(session.user.image).toBeNull();
	});

	it("should update user email", async () => {
		const newEmail = "new-email@email.com";
		const res = await client.changeEmail({
			newEmail,
			fetchOptions: {
				headers: headers,
			},
		});
		const session = await client.getSession({
			fetchOptions: {
				headers,
				throw: true,
			},
		});
		expect(session.user.email).toBe(newEmail);
		expect(session.user.emailVerified).toBe(false);
	});

	it("should verify email", async () => {
		await client.verifyEmail({
			query: {
				token: emailVerificationToken,
			},
			fetchOptions: {
				headers,
			},
		});
		const session = await client.getSession({
			fetchOptions: {
				headers,
				throw: true,
			},
		});
		expect(session.user.emailVerified).toBe(true);
	});

	it("should send email verification before update", async () => {
		await db.update({
			model: "user",
			update: {
				emailVerified: true,
			},
			where: [
				{
					field: "email",
					value: "new-email@email.com",
				},
			],
		});
		await client.changeEmail({
			newEmail: "new-email-2@email.com",
			fetchOptions: {
				headers: headers,
			},
		});
		expect(sendChangeEmail).toHaveBeenCalledWith(
			expect.objectContaining({
				email: "new-email@email.com",
			}),
			"new-email-2@email.com",
			expect.any(String),
			expect.any(String),
		);
	});

	it("should update the user's password", async () => {
		const newEmail = "new-email@email.com";
		const updated = await client.changePassword({
			newPassword: "newPassword",
			currentPassword: testUser.password,
			revokeOtherSessions: true,
			fetchOptions: {
				headers: headers,
			},
		});
		expect(updated).toBeDefined();
		const signInRes = await client.signIn.email({
			email: newEmail,
			password: "newPassword",
		});
		expect(signInRes.data?.user).toBeDefined();
		const signInCurrentPassword = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
		});
		expect(signInCurrentPassword.data).toBeNull();
	});

	it("should revoke other sessions", async () => {
		const newHeaders = new Headers();
		await client.changePassword({
			newPassword: "newPassword",
			currentPassword: testUser.password,
			revokeOtherSessions: true,
			fetchOptions: {
				headers: headers,
				onSuccess: sessionSetter(newHeaders),
			},
		});
		const cookie = newHeaders.get("cookie");
		const oldCookie = headers.get("cookie");
		expect(cookie).not.toBe(oldCookie);
		const sessionAttempt = await client.getSession({
			fetchOptions: {
				headers: headers,
			},
		});
		expect(sessionAttempt.data).toBeNull();
	});

	it("shouldn't pass defaults", async () => {
		const { client, sessionSetter, db } = await getTestInstance(
			{
				user: {
					additionalFields: {
						newField: {
							type: "string",
							defaultValue: "default",
						},
					},
				},
			},
			{
				disableTestUser: true,
			},
		);
		const headers = new Headers();
		await client.signUp.email({
			email: "new-email@emial.com",
			name: "name",
			password: "password",
			fetchOptions: {
				onSuccess: sessionSetter(headers),
			},
		});

		const res = await db.update<{ newField: string }>({
			model: "user",
			update: {
				newField: "new",
			},
			where: [
				{
					field: "email",
					value: "new-email@emial.com",
				},
			],
		});
		expect(res?.newField).toBe("new");

		const updated = await client.updateUser({
			name: "newName",
			fetchOptions: {
				headers,
			},
		});
		const session = await client.getSession({
			fetchOptions: {
				headers,
				throw: true,
			},
		});
		// @ts-ignore
		expect(session?.user.newField).toBe("new");
	});
});

describe("delete user", async () => {
	it("should delete the user", async () => {
		const { auth, client, signInWithTestUser } = await getTestInstance({
			user: {
				deleteUser: {
					enabled: true,
				},
			},
		});
		const { headers } = await signInWithTestUser();
		const res = await client.deleteUser({
			fetchOptions: {
				headers,
			},
		});
		expect(res.data).toMatchObject({
			success: true,
		});
		const session = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(session.data).toBeNull();
	});

	it("should delete with verification flow", async () => {
		let token = "";
		const { client, signInWithTestUser } = await getTestInstance({
			user: {
				deleteUser: {
					enabled: true,
					async sendDeleteAccountVerification(data, _) {
						token = data.token;
					},
				},
			},
		});
		const { headers } = await signInWithTestUser();
		const res = await client.deleteUser({
			fetchOptions: {
				headers,
			},
		});
		expect(res.data).toMatchObject({
			success: true,
		});
		expect(token.length).toBe(32);
		const session = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(session.data).toBeDefined();
		const deleteCallbackRes = await client.deleteUser({
			token,
			fetchOptions: {
				headers,
			},
		});
		expect(deleteCallbackRes.data).toMatchObject({
			success: true,
		});
		const nullSession = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(nullSession.data).toBeNull();
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/api/routes/update-user.ts
```typescript
import { z } from "zod";
import { createAuthEndpoint } from "../call";

import { deleteSessionCookie, setSessionCookie } from "../../cookies";
import { getSessionFromCtx, sessionMiddleware } from "./session";
import { APIError } from "better-call";
import { createEmailVerificationToken } from "./email-verification";
import type { AdditionalUserFieldsInput, BetterAuthOptions } from "../../types";
import { parseUserInput } from "../../db/schema";
import { generateRandomString } from "../../crypto";
import { BASE_ERROR_CODES } from "../../error/codes";
import { originCheck } from "../middlewares";
import type { Prettify } from "../../types/helper";

export const updateUser = <O extends BetterAuthOptions>() =>
	createAuthEndpoint(
		"/update-user",
		{
			method: "POST",
			body: z.record(z.string(), z.any()),
			use: [sessionMiddleware],
			metadata: {
				$Infer: {
					body: {} as Partial<
						Prettify<
							AdditionalUserFieldsInput<O> & {
								name?: string;
								image?: string | null;
							}
						>
					>,
				},
				openapi: {
					description: "Update the current user",
					requestBody: {
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										name: {
											type: "string",
											description: "The name of the user",
										},
										image: {
											type: "string",
											description: "The image of the user",
										},
									},
								},
							},
						},
					},
					responses: {
						"200": {
							description: "Success",
							content: {
								"application/json": {
									schema: {
										type: "object",
										properties: {
											user: {
												type: "object",
												ref: "#/components/schemas/User",
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
		async (ctx) => {
			const body = ctx.body as {
				name?: string;
				image?: string;
				[key: string]: any;
			};

			if (body.email) {
				throw new APIError("BAD_REQUEST", {
					message: BASE_ERROR_CODES.EMAIL_CAN_NOT_BE_UPDATED,
				});
			}
			const { name, image, ...rest } = body;
			const session = ctx.context.session;
			if (
				image === undefined &&
				name === undefined &&
				Object.keys(rest).length === 0
			) {
				return ctx.json({
					status: true,
				});
			}
			const additionalFields = parseUserInput(
				ctx.context.options,
				rest,
				"update",
			);
			const user = await ctx.context.internalAdapter.updateUser(
				session.user.id,
				{
					name,
					image,
					...additionalFields,
				},
				ctx,
			);
			/**
			 * Update the session cookie with the new user data
			 */
			await setSessionCookie(ctx, {
				session: session.session,
				user,
			});
			return ctx.json({
				status: true,
			});
		},
	);

export const changePassword = createAuthEndpoint(
	"/change-password",
	{
		method: "POST",
		body: z.object({
			/**
			 * The new password to set
			 */
			newPassword: z.string({
				description: "The new password to set",
			}),
			/**
			 * The current password of the user
			 */
			currentPassword: z.string({
				description: "The current password",
			}),
			/**
			 * revoke all sessions that are not the
			 * current one logged in by the user
			 */
			revokeOtherSessions: z
				.boolean({
					description: "Revoke all other sessions",
				})
				.optional(),
		}),
		use: [sessionMiddleware],
		metadata: {
			openapi: {
				description: "Change the password of the user",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										user: {
											description: "The user object",
											$ref: "#/components/schemas/User",
										},
									},
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		const { newPassword, currentPassword, revokeOtherSessions } = ctx.body;
		const session = ctx.context.session;
		const minPasswordLength = ctx.context.password.config.minPasswordLength;
		if (newPassword.length < minPasswordLength) {
			ctx.context.logger.error("Password is too short");
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.PASSWORD_TOO_SHORT,
			});
		}

		const maxPasswordLength = ctx.context.password.config.maxPasswordLength;

		if (newPassword.length > maxPasswordLength) {
			ctx.context.logger.error("Password is too long");
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.PASSWORD_TOO_LONG,
			});
		}

		const accounts = await ctx.context.internalAdapter.findAccounts(
			session.user.id,
		);
		const account = accounts.find(
			(account) => account.providerId === "credential" && account.password,
		);
		if (!account || !account.password) {
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.CREDENTIAL_ACCOUNT_NOT_FOUND,
			});
		}
		const passwordHash = await ctx.context.password.hash(newPassword);
		const verify = await ctx.context.password.verify({
			hash: account.password,
			password: currentPassword,
		});
		if (!verify) {
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.INVALID_PASSWORD,
			});
		}
		await ctx.context.internalAdapter.updateAccount(account.id, {
			password: passwordHash,
		});
		let token = null;
		if (revokeOtherSessions) {
			await ctx.context.internalAdapter.deleteSessions(session.user.id);
			const newSession = await ctx.context.internalAdapter.createSession(
				session.user.id,
				ctx.headers,
			);
			if (!newSession) {
				throw new APIError("INTERNAL_SERVER_ERROR", {
					message: BASE_ERROR_CODES.FAILED_TO_GET_SESSION,
				});
			}
			// set the new session cookie
			await setSessionCookie(ctx, {
				session: newSession,
				user: session.user,
			});
			token = newSession.token;
		}

		return ctx.json({
			token,
			user: {
				id: session.user.id,
				email: session.user.email,
				name: session.user.name,
				image: session.user.image,
				emailVerified: session.user.emailVerified,
				createdAt: session.user.createdAt,
				updatedAt: session.user.updatedAt,
			},
		});
	},
);

export const setPassword = createAuthEndpoint(
	"/set-password",
	{
		method: "POST",
		body: z.object({
			/**
			 * The new password to set
			 */
			newPassword: z.string(),
		}),
		metadata: {
			SERVER_ONLY: true,
		},
		use: [sessionMiddleware],
	},
	async (ctx) => {
		const { newPassword } = ctx.body;
		const session = ctx.context.session;
		const minPasswordLength = ctx.context.password.config.minPasswordLength;
		if (newPassword.length < minPasswordLength) {
			ctx.context.logger.error("Password is too short");
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.PASSWORD_TOO_SHORT,
			});
		}

		const maxPasswordLength = ctx.context.password.config.maxPasswordLength;

		if (newPassword.length > maxPasswordLength) {
			ctx.context.logger.error("Password is too long");
			throw new APIError("BAD_REQUEST", {
				message: BASE_ERROR_CODES.PASSWORD_TOO_LONG,
			});
		}

		const accounts = await ctx.context.internalAdapter.findAccounts(
			session.user.id,
		);
		const account = accounts.find(
			(account) => account.providerId === "credential" && account.password,
		);
		const passwordHash = await ctx.context.password.hash(newPassword);
		if (!account) {
			await ctx.context.internalAdapter.linkAccount(
				{
					userId: session.user.id,
					providerId: "credential",
					accountId: session.user.id,
					password: passwordHash,
				},
				ctx,
			);
			return ctx.json({
				status: true,
			});
		}
		throw new APIError("BAD_REQUEST", {
			message: "user already has a password",
		});
	},
);

export const deleteUser = createAuthEndpoint(
	"/delete-user",
	{
		method: "POST",
		use: [sessionMiddleware],
		body: z.object({
			/**
			 * The callback URL to redirect to after the user is deleted
			 * this is only used on delete user callback
			 */
			callbackURL: z.string().optional(),
			/**
			 * The password of the user. If the password isn't provided, session freshness
			 * will be checked.
			 */
			password: z.string().optional(),
			/**
			 * The token to delete the user. If the token is provided, the user will be deleted
			 */
			token: z.string().optional(),
		}),
		metadata: {
			openapi: {
				description: "Delete the user",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		if (!ctx.context.options.user?.deleteUser?.enabled) {
			ctx.context.logger.error(
				"Delete user is disabled. Enable it in the options",
				{
					session: ctx.context.session,
				},
			);
			throw new APIError("NOT_FOUND");
		}
		const session = ctx.context.session;

		if (ctx.body.password) {
			const accounts = await ctx.context.internalAdapter.findAccounts(
				session.user.id,
			);
			const account = accounts.find(
				(account) => account.providerId === "credential" && account.password,
			);
			if (!account || !account.password) {
				throw new APIError("BAD_REQUEST", {
					message: BASE_ERROR_CODES.CREDENTIAL_ACCOUNT_NOT_FOUND,
				});
			}
			const verify = await ctx.context.password.verify({
				hash: account.password,
				password: ctx.body.password,
			});
			if (!verify) {
				throw new APIError("BAD_REQUEST", {
					message: BASE_ERROR_CODES.INVALID_PASSWORD,
				});
			}
		} else {
			if (ctx.context.options.session?.freshAge) {
				const currentAge = session.session.createdAt.getTime();
				const freshAge = ctx.context.options.session.freshAge;
				const now = Date.now();
				if (now - currentAge > freshAge) {
					throw new APIError("BAD_REQUEST", {
						message: BASE_ERROR_CODES.SESSION_EXPIRED,
					});
				}
			}
		}

		if (ctx.body.token) {
			//@ts-expect-error
			await deleteUserCallback({
				...ctx,
				query: {
					token: ctx.body.token,
				},
			});
			return ctx.json({
				success: true,
				message: "User deleted",
			});
		}

		if (ctx.context.options.user.deleteUser?.sendDeleteAccountVerification) {
			const token = generateRandomString(32, "0-9", "a-z");
			await ctx.context.internalAdapter.createVerificationValue({
				value: session.user.id,
				identifier: `delete-account-${token}`,
				expiresAt: new Date(Date.now() + 1000 * 60 * 60 * 24),
			});
			const url = `${
				ctx.context.baseURL
			}/delete-user/callback?token=${token}&callbackURL=${
				ctx.body.callbackURL || "/"
			}`;
			await ctx.context.options.user.deleteUser.sendDeleteAccountVerification(
				{
					user: session.user,
					url,
					token,
				},
				ctx.request,
			);
			return ctx.json({
				success: true,
				message: "Verification email sent",
			});
		}
		const beforeDelete = ctx.context.options.user.deleteUser?.beforeDelete;
		if (beforeDelete) {
			await beforeDelete(session.user, ctx.request);
		}
		await ctx.context.internalAdapter.deleteUser(session.user.id);
		await ctx.context.internalAdapter.deleteSessions(session.user.id);
		await ctx.context.internalAdapter.deleteAccounts(session.user.id);
		deleteSessionCookie(ctx);
		const afterDelete = ctx.context.options.user.deleteUser?.afterDelete;
		if (afterDelete) {
			await afterDelete(session.user, ctx.request);
		}
		return ctx.json({
			success: true,
			message: "User deleted",
		});
	},
);

export const deleteUserCallback = createAuthEndpoint(
	"/delete-user/callback",
	{
		method: "GET",
		query: z.object({
			token: z.string(),
			callbackURL: z.string().optional(),
		}),
		use: [originCheck((ctx) => ctx.query.callbackURL)],
	},
	async (ctx) => {
		if (!ctx.context.options.user?.deleteUser?.enabled) {
			ctx.context.logger.error(
				"Delete user is disabled. Enable it in the options",
			);
			throw new APIError("NOT_FOUND");
		}
		const session = await getSessionFromCtx(ctx);
		if (!session) {
			throw new APIError("NOT_FOUND", {
				message: BASE_ERROR_CODES.FAILED_TO_GET_USER_INFO,
			});
		}
		const token = await ctx.context.internalAdapter.findVerificationValue(
			`delete-account-${ctx.query.token}`,
		);
		if (!token || token.expiresAt < new Date()) {
			throw new APIError("NOT_FOUND", {
				message: BASE_ERROR_CODES.INVALID_TOKEN,
			});
		}
		if (token.value !== session.user.id) {
			throw new APIError("NOT_FOUND", {
				message: BASE_ERROR_CODES.INVALID_TOKEN,
			});
		}
		const beforeDelete = ctx.context.options.user.deleteUser?.beforeDelete;
		if (beforeDelete) {
			await beforeDelete(session.user, ctx.request);
		}
		await ctx.context.internalAdapter.deleteUser(session.user.id);
		await ctx.context.internalAdapter.deleteSessions(session.user.id);
		await ctx.context.internalAdapter.deleteAccounts(session.user.id);
		await ctx.context.internalAdapter.deleteVerificationValue(token.id);

		deleteSessionCookie(ctx);

		const afterDelete = ctx.context.options.user.deleteUser?.afterDelete;
		if (afterDelete) {
			await afterDelete(session.user, ctx.request);
		}
		if (ctx.query.callbackURL) {
			throw ctx.redirect(ctx.query.callbackURL || "/");
		}
		return ctx.json({
			success: true,
			message: "User deleted",
		});
	},
);

export const changeEmail = createAuthEndpoint(
	"/change-email",
	{
		method: "POST",
		body: z.object({
			newEmail: z
				.string({
					description: "The new email to set",
				})
				.email(),
			callbackURL: z
				.string({
					description: "The URL to redirect to after email verification",
				})
				.optional(),
		}),
		use: [sessionMiddleware],
		metadata: {
			openapi: {
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										user: {
											type: "object",
											ref: "#/components/schemas/User",
										},
										status: {
											type: "boolean",
										},
									},
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		if (!ctx.context.options.user?.changeEmail?.enabled) {
			ctx.context.logger.error("Change email is disabled.");
			throw new APIError("BAD_REQUEST", {
				message: "Change email is disabled",
			});
		}

		const newEmail = ctx.body.newEmail.toLowerCase();

		if (newEmail === ctx.context.session.user.email) {
			ctx.context.logger.error("Email is the same");
			throw new APIError("BAD_REQUEST", {
				message: "Email is the same",
			});
		}
		const existingUser =
			await ctx.context.internalAdapter.findUserByEmail(newEmail);
		if (existingUser) {
			ctx.context.logger.error("Email already exists");
			throw new APIError("BAD_REQUEST", {
				message: "Couldn't update your email",
			});
		}
		/**
		 * If the email is not verified, we can update the email
		 */
		if (ctx.context.session.user.emailVerified !== true) {
			const existing =
				await ctx.context.internalAdapter.findUserByEmail(newEmail);
			if (existing) {
				throw new APIError("UNPROCESSABLE_ENTITY", {
					message: BASE_ERROR_CODES.USER_ALREADY_EXISTS,
				});
			}
			await ctx.context.internalAdapter.updateUserByEmail(
				ctx.context.session.user.email,
				{
					email: newEmail,
				},
				ctx,
			);
			await setSessionCookie(ctx, {
				session: ctx.context.session.session,
				user: {
					...ctx.context.session.user,
					email: newEmail,
				},
			});
			if (ctx.context.options.emailVerification?.sendVerificationEmail) {
				const token = await createEmailVerificationToken(
					ctx.context.secret,
					newEmail,
					undefined,
					ctx.context.options.emailVerification?.expiresIn,
				);
				const url = `${
					ctx.context.baseURL
				}/verify-email?token=${token}&callbackURL=${
					ctx.body.callbackURL || "/"
				}`;
				await ctx.context.options.emailVerification.sendVerificationEmail(
					{
						user: {
							...ctx.context.session.user,
							email: newEmail,
						},
						url,
						token,
					},
					ctx.request,
				);
			}

			return ctx.json({
				status: true,
			});
		}

		/**
		 * If the email is verified, we need to send a verification email
		 */
		if (!ctx.context.options.user.changeEmail.sendChangeEmailVerification) {
			ctx.context.logger.error("Verification email isn't enabled.");
			throw new APIError("BAD_REQUEST", {
				message: "Verification email isn't enabled",
			});
		}

		const token = await createEmailVerificationToken(
			ctx.context.secret,
			ctx.context.session.user.email,
			newEmail,
			ctx.context.options.emailVerification?.expiresIn,
		);
		const url = `${
			ctx.context.baseURL
		}/verify-email?token=${token}&callbackURL=${ctx.body.callbackURL || "/"}`;
		await ctx.context.options.user.changeEmail.sendChangeEmailVerification(
			{
				user: ctx.context.session.user,
				newEmail: newEmail,
				url,
				token,
			},
			ctx.request,
		);
		return ctx.json({
			status: true,
		});
	},
);

```
