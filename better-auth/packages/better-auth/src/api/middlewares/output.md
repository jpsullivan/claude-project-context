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
