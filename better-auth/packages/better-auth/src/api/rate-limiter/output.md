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
