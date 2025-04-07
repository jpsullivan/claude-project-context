/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/captcha/captcha.test.ts
```typescript
import { describe, expect, vi } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";
import { captcha } from ".";
import * as betterFetchModule from "@better-fetch/fetch";

vi.mock("@better-fetch/fetch", async (importOriginal) => {
	const actual = (await importOriginal()) as typeof betterFetchModule;
	return {
		...actual,
		betterFetch: vi.fn(),
	};
});

describe("cloudflare-turnstile", async (it) => {
	const mockBetterFetch = betterFetchModule.betterFetch as ReturnType<
		typeof vi.fn
	>;

	const { client } = await getTestInstance({
		plugins: [
			captcha({ provider: "cloudflare-turnstile", secretKey: "xx-secret-key" }),
		],
	});
	const headers = new Headers();

	it("Should successful sign users if they passed the CAPTCHA challenge", async () => {
		mockBetterFetch.mockResolvedValue({
			data: {
				success: true,
				challenge_ts: "2022-02-28T15:14:30.096Z",
				hostname: "example.com",
				"error-codes": [],
				action: "login",
				cdata: "sessionid-123456789",
				metadata: {
					ephemeral_id: "x:9f78e0ed210960d7693b167e",
				},
			},
		});
		const res = await client.signIn.email({
			email: "test@test.com",
			password: "test123456",
			fetchOptions: {
				headers: {
					"x-captcha-response": "captcha-token",
				},
			},
		});

		expect(res.data?.user).toBeDefined();
	});

	it("Should return 400 if no captcha token is found in the request headers", async () => {
		const res = await client.signIn.email({
			email: "test@test.com",
			password: "test123456",
			fetchOptions: {
				headers: {},
			},
		});
		expect(res.error?.status).toBe(400);
	});

	it("Should return 503 if the call to /siteverify fails", async () => {
		mockBetterFetch.mockResolvedValue({
			error: "Failed to fetch",
		});
		const res = await client.signIn.email({
			email: "test@test.com",
			password: "test123456",
			fetchOptions: {
				headers: {
					"x-captcha-response": "captcha-token",
				},
			},
		});

		expect(res.error?.status).toBe(503);
	});

	it("Should return 403 in case of a validation failure", async () => {
		mockBetterFetch.mockResolvedValue({
			data: {
				success: false,
				"error-codes": ["invalid-input-response"],
			},
		});
		const res = await client.signIn.email({
			email: "test@test.com",
			password: "test123456",
			fetchOptions: {
				headers: {
					"x-captcha-response": "captcha-token",
				},
			},
		});

		expect(res.error?.status).toBe(403);
	});

	it("Should return 500 if an unexpected error occurs", async () => {
		mockBetterFetch.mockRejectedValue(new Error("Failed to fetch"));
		const res = await client.signIn.email({
			email: "test@test.com",
			password: "test123456",
			fetchOptions: {
				headers: {
					"x-captcha-response": "captcha-token",
				},
			},
		});

		expect(res.error?.status).toBe(500);
	});
});

describe("google-recaptcha", async (it) => {
	const mockBetterFetch = betterFetchModule.betterFetch as ReturnType<
		typeof vi.fn
	>;

	const { client } = await getTestInstance({
		plugins: [
			captcha({ provider: "google-recaptcha", secretKey: "xx-secret-key" }),
		],
	});
	const headers = new Headers();

	it("Should successfuly sign users if they passed the CAPTCHA challenge", async () => {
		mockBetterFetch.mockResolvedValue({
			data: {
				success: true,
				challenge_ts: "2022-02-28T15:14:30.096Z",
				hostname: "example.com",
			},
		});
		const res = await client.signIn.email({
			email: "test@test.com",
			password: "test123456",
			fetchOptions: {
				headers: {
					"x-captcha-response": "captcha-token",
				},
			},
		});

		expect(res.data?.user).toBeDefined();
	});

	it("Should return 400 if no captcha token is found in the request headers", async () => {
		const res = await client.signIn.email({
			email: "test@test.com",
			password: "test123456",
			fetchOptions: {
				headers: {},
			},
		});
		expect(res.error?.status).toBe(400);
	});

	it("Should return 503 if the call to /siteverify fails", async () => {
		mockBetterFetch.mockResolvedValue({
			error: "Failed to fetch",
		});
		const res = await client.signIn.email({
			email: "test@test.com",
			password: "test123456",
			fetchOptions: {
				headers: {
					"x-captcha-response": "captcha-token",
				},
			},
		});

		expect(res.error?.status).toBe(503);
	});

	it("Should return 403 in case of a validation failure", async () => {
		mockBetterFetch.mockResolvedValue({
			data: {
				success: false,
				"error-codes": ["invalid-input-response"],
			},
		});
		const res = await client.signIn.email({
			email: "test@test.com",
			password: "test123456",
			fetchOptions: {
				headers: {
					"x-captcha-response": "invalid-captcha-token",
				},
			},
		});

		expect(res.error?.status).toBe(403);
	});

	it("Should return 500 if an unexpected error occurs", async () => {
		mockBetterFetch.mockRejectedValue(new Error("Failed to fetch"));
		const res = await client.signIn.email({
			email: "test@test.com",
			password: "test123456",
			fetchOptions: {
				headers: {
					"x-captcha-response": "captcha-token",
				},
			},
		});

		expect(res.error?.status).toBe(500);
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/captcha/constants.ts
```typescript
import type { Provider } from "./types";

export const defaultEndpoints = ["/sign-up", "/sign-in", "/forget-password"];

export const Providers = {
	CLOUDFLARE_TURNSTILE: "cloudflare-turnstile",
	GOOGLE_RECAPTCHA: "google-recaptcha",
} as const;

export const siteVerifyMap: Record<Provider, string> = {
	[Providers.CLOUDFLARE_TURNSTILE]:
		"https://challenges.cloudflare.com/turnstile/v0/siteverify",
	[Providers.GOOGLE_RECAPTCHA]:
		"https://www.google.com/recaptcha/api/siteverify",
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/captcha/error-codes.ts
```typescript
export const CAPTCHA_ERROR_CODES = {
	MISSING_RESPONSE: "Missing CAPTCHA response",
	SERVICE_UNAVAILABLE: "CAPTCHA service unavailable",
	VERIFICATION_FAILED: "Captcha verification failed",
	UNKNOWN_ERROR: "Something went wrong",
} as const;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/captcha/index.ts
```typescript
import type { BetterAuthPlugin } from "../../plugins";
import type { Provider } from "./types";
import { defaultEndpoints, Providers, siteVerifyMap } from "./constants";
import { CAPTCHA_ERROR_CODES } from "./error-codes";
import { middlewareResponse } from "../../utils/middleware-response";
import * as verifyHandlers from "./verify-handlers";

export interface CaptchaOptions {
	provider: Provider;
	secretKey: string;
	endpoints?: string[];
	siteVerifyURLOverride?: string;
}

export const captcha = (options: CaptchaOptions) =>
	({
		id: "captcha",
		onRequest: async (request) => {
			try {
				if (request.method !== "POST") return undefined;

				const endpoints = options.endpoints?.length
					? options.endpoints
					: defaultEndpoints;

				if (!endpoints.some((endpoint) => request.url.includes(endpoint)))
					return;

				const captchaResponse = request.headers.get("x-captcha-response");

				if (!captchaResponse) {
					return middlewareResponse({
						message: CAPTCHA_ERROR_CODES.MISSING_RESPONSE,
						status: 400,
					});
				}

				const siteVerifyURL =
					options.siteVerifyURLOverride || siteVerifyMap[options.provider];

				if (options.provider === Providers.CLOUDFLARE_TURNSTILE) {
					return await verifyHandlers.cloudflareTurnstile({
						secretKey: options.secretKey,
						captchaResponse,
						siteVerifyURL,
					});
				}

				if (options.provider === Providers.GOOGLE_RECAPTCHA) {
					return await verifyHandlers.googleReCAPTCHA({
						secretKey: options.secretKey,
						captchaResponse,
						siteVerifyURL,
					});
				}
			} catch (_error) {
				return middlewareResponse({
					message: CAPTCHA_ERROR_CODES.UNKNOWN_ERROR,
					status: 500,
				});
			}
		},
	}) satisfies BetterAuthPlugin;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/captcha/types.ts
```typescript
import type { Providers } from "./constants";
export type Provider = (typeof Providers)[keyof typeof Providers];

export type TurnstileSiteVerifyResponse = {
	success: boolean;
	"error-codes"?: string[];
	challenge_ts?: string;
	hostname?: string;
	action?: string;
	cdata?: string;
	metadata?: {
		interactive: boolean;
	};
	messages?: string[];
};

export type GoogleReCAPTCHASiteVerifyResponse = {
	success: boolean;
	challenge_ts: string;
	hostname: string;
	"error-codes":
		| Array<
				| "missing-input-secret"
				| "invalid-input-secret"
				| "missing-input-response"
				| "invalid-input-response"
				| "bad-request"
				| "timeout-or-duplicate"
		  >
		| undefined;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/captcha/verify-handlers/cloudflare-turnstile.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import { middlewareResponse } from "../../../utils/middleware-response";
import { CAPTCHA_ERROR_CODES } from "../error-codes";
import type { TurnstileSiteVerifyResponse } from "../types";

type Params = {
	siteVerifyURL: string;
	secretKey: string;
	captchaResponse: string;
};

export const cloudflareTurnstile = async ({
	siteVerifyURL,
	captchaResponse,
	secretKey,
}: Params) => {
	const response = await betterFetch<TurnstileSiteVerifyResponse>(
		siteVerifyURL,
		{
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({
				secret: secretKey,
				response: captchaResponse,
			}),
		},
	);

	if (!response.data || response.error) {
		return middlewareResponse({
			message: CAPTCHA_ERROR_CODES.SERVICE_UNAVAILABLE,
			status: 503,
		});
	}

	if (!response.data.success) {
		return middlewareResponse({
			message: CAPTCHA_ERROR_CODES.VERIFICATION_FAILED,
			status: 403,
		});
	}

	return undefined;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/captcha/verify-handlers/google-recaptcha.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import { middlewareResponse } from "../../../utils/middleware-response";
import { CAPTCHA_ERROR_CODES } from "../error-codes";
import type { GoogleReCAPTCHASiteVerifyResponse } from "../types";

type Params = {
	siteVerifyURL: string;
	secretKey: string;
	captchaResponse: string;
};

export const googleReCAPTCHA = async ({
	siteVerifyURL,
	captchaResponse,
	secretKey,
}: Params) => {
	const response = await betterFetch<GoogleReCAPTCHASiteVerifyResponse>(
		siteVerifyURL,
		{
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({
				secret: secretKey,
				response: captchaResponse,
			}),
		},
	);

	if (!response.data || response.error) {
		return middlewareResponse({
			message: CAPTCHA_ERROR_CODES.SERVICE_UNAVAILABLE,
			status: 503,
		});
	}

	if (!response.data.success) {
		return middlewareResponse({
			message: CAPTCHA_ERROR_CODES.VERIFICATION_FAILED,
			status: 403,
		});
	}

	return undefined;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/captcha/verify-handlers/index.ts
```typescript
export { cloudflareTurnstile } from "./cloudflare-turnstile";
export { googleReCAPTCHA } from "./google-recaptcha";

```
