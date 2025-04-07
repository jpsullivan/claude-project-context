/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/oauth-proxy/index.ts
```typescript
import { z } from "zod";
import {
	createAuthEndpoint,
	createAuthMiddleware,
	originCheck,
} from "../../api";
import { symmetricDecrypt, symmetricEncrypt } from "../../crypto";
import type { BetterAuthPlugin } from "../../types";
import { env } from "../../utils/env";
import { getOrigin } from "../../utils/url";

function getVenderBaseURL() {
	const vercel = env.VERCEL_URL;
	const netlify = env.NETLIFY_URL;
	const render = env.RENDER_URL;
	const aws = env.AWS_LAMBDA_FUNCTION_NAME;
	const google = env.GOOGLE_CLOUD_FUNCTION_NAME;
	const azure = env.AZURE_FUNCTION_NAME;

	return vercel || netlify || render || aws || google || azure;
}

interface OAuthProxyOptions {
	/**
	 * The current URL of the application.
	 * The plugin will attempt to infer the current URL from your environment
	 * by checking the base URL from popular hosting providers,
	 * from the request URL if invoked by a client,
	 * or as a fallback, from the `baseURL` in your auth config.
	 * If the URL is not inferred correctly, you can provide a value here."
	 */
	currentURL?: string;
	/**
	 * If a request in a production url it won't be proxied.
	 *
	 * default to `BETTER_AUTH_URL`
	 */
	productionURL?: string;
}

/**
 * A proxy plugin, that allows you to proxy OAuth requests.
 * Useful for development and preview deployments where
 * the redirect URL can't be known in advance to add to the OAuth provider.
 */
export const oAuthProxy = (opts?: OAuthProxyOptions) => {
	return {
		id: "oauth-proxy",
		endpoints: {
			oAuthProxy: createAuthEndpoint(
				"/oauth-proxy-callback",
				{
					method: "GET",
					query: z.object({
						callbackURL: z.string({
							description: "The URL to redirect to after the proxy",
						}),
						cookies: z.string({
							description: "The cookies to set after the proxy",
						}),
					}),
					use: [originCheck((ctx) => ctx.query.callbackURL)],
					metadata: {
						openapi: {
							description: "OAuth Proxy Callback",
							parameters: [
								{
									in: "query",
									name: "callbackURL",
									required: true,
									description: "The URL to redirect to after the proxy",
								},
								{
									in: "query",
									name: "cookies",
									required: true,
									description: "The cookies to set after the proxy",
								},
							],
							responses: {
								302: {
									description: "Redirect",
									headers: {
										Location: {
											description: "The URL to redirect to",
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
				async (ctx) => {
					const cookies = ctx.query.cookies;
					const decryptedCookies = await symmetricDecrypt({
						key: ctx.context.secret,
						data: cookies,
					});
					ctx.setHeader("set-cookie", decryptedCookies);
					throw ctx.redirect(ctx.query.callbackURL);
				},
			),
		},
		hooks: {
			after: [
				{
					matcher(context) {
						return context.path?.startsWith("/callback");
					},
					handler: createAuthMiddleware(async (ctx) => {
						const headers = ctx.context.responseHeaders;
						const location = headers?.get("location");
						if (location?.includes("/oauth-proxy-callback?callbackURL")) {
							if (!location.startsWith("http")) {
								return;
							}
							const locationURL = new URL(location);
							const origin = locationURL.origin;
							/**
							 * We don't want to redirect to the proxy URL if the origin is the same
							 * as the current URL
							 */
							if (origin === getOrigin(ctx.context.baseURL)) {
								const newLocation = locationURL.searchParams.get("callbackURL");
								if (!newLocation) {
									return;
								}
								ctx.setHeader("location", newLocation);
								return;
							}

							const setCookies = headers?.get("set-cookie");

							if (!setCookies) {
								return;
							}
							const encryptedCookies = await symmetricEncrypt({
								key: ctx.context.secret,
								data: setCookies,
							});
							const locationWithCookies = `${location}&cookies=${encodeURIComponent(
								encryptedCookies,
							)}`;
							ctx.setHeader("location", locationWithCookies);
						}
					}),
				},
			],
			before: [
				{
					matcher(context) {
						return context.path?.startsWith("/sign-in/social");
					},
					handler: createAuthMiddleware(async (ctx) => {
						const url = new URL(
							opts?.currentURL ||
								ctx.request?.url ||
								getVenderBaseURL() ||
								ctx.context.baseURL,
						);
						const productionURL = opts?.productionURL || env.BETTER_AUTH_URL;
						if (productionURL === ctx.context.options.baseURL) {
							return;
						}
						ctx.body.callbackURL = `${url.origin}${
							ctx.context.options.basePath || "/api/auth"
						}/oauth-proxy-callback?callbackURL=${encodeURIComponent(
							ctx.body.callbackURL || ctx.context.baseURL,
						)}`;
						return {
							context: ctx,
						};
					}),
				},
			],
		},
	} satisfies BetterAuthPlugin;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/oauth-proxy/oauth-proxy.test.ts
```typescript
import { describe, vi, it, expect } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";
import { oAuthProxy } from ".";
import type { GoogleProfile } from "../../social-providers";
import { DEFAULT_SECRET } from "../../utils/constants";
import { getOAuth2Tokens } from "../../oauth2";
import { signJWT } from "../../crypto/jwt";

vi.mock("../../oauth2", async (importOriginal) => {
	const original = (await importOriginal()) as any;
	return {
		...original,
		validateAuthorizationCode: vi
			.fn()
			.mockImplementation(async (...args: any) => {
				const data: GoogleProfile = {
					email: "user@email.com",
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

describe("oauth-proxy", async () => {
	const { client } = await getTestInstance({
		plugins: [
			oAuthProxy({
				currentURL: "http://preview-localhost:3000",
			}),
		],
		socialProviders: {
			google: {
				clientId: "test",
				clientSecret: "test",
			},
		},
	});

	it("should redirect to proxy url", async () => {
		const res = await client.signIn.social(
			{
				provider: "google",
				callbackURL: "/dashboard",
			},
			{
				throw: true,
			},
		);
		const state = new URL(res.url!).searchParams.get("state");
		await client.$fetch(`/callback/google?code=test&state=${state}`, {
			onError(context) {
				const location = context.response.headers.get("location");
				if (!location) {
					throw new Error("Location header not found");
				}
				expect(location).toContain(
					"http://preview-localhost:3000/api/auth/oauth-proxy-callback?callbackURL=%2Fdashboard",
				);
				const cookies = new URL(location).searchParams.get("cookies");
				expect(cookies).toBeTruthy();
			},
		});
	});

	it("shouldn't redirect to proxy url on same origin", async () => {
		const { client } = await getTestInstance({
			plugins: [oAuthProxy()],
			socialProviders: {
				google: {
					clientId: "test",
					clientSecret: "test",
				},
			},
		});
		const res = await client.signIn.social(
			{
				provider: "google",
				callbackURL: "/dashboard",
			},
			{
				throw: true,
			},
		);
		const state = new URL(res.url!).searchParams.get("state");
		await client.$fetch(`/callback/google?code=test&state=${state}`, {
			onError(context) {
				const location = context.response.headers.get("location");
				if (!location) {
					throw new Error("Location header not found");
				}
				expect(location).not.toContain("/api/auth/oauth-proxy-callback");
				expect(location).toContain("/dashboard");
			},
		});
	});
});

```
