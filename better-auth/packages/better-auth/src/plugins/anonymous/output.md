/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/anonymous/anon.test.ts
```typescript
import { describe, expect, it, vi } from "vitest";
import { anonymous } from ".";
import { getTestInstance } from "../../test-utils/test-instance";
import { createAuthClient } from "../../client";
import { anonymousClient } from "./client";
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

describe("anonymous", async () => {
	const linkAccountFn = vi.fn();
	const { customFetchImpl, auth, sessionSetter, testUser } =
		await getTestInstance({
			plugins: [
				anonymous({
					async onLinkAccount(data) {
						linkAccountFn(data);
					},
					schema: {
						user: {
							fields: {
								isAnonymous: "is_anon",
							},
						},
					},
				}),
			],
			socialProviders: {
				google: {
					clientId: "test",
					clientSecret: "test",
				},
			},
		});
	const headers = new Headers();
	const client = createAuthClient({
		plugins: [anonymousClient()],
		fetchOptions: {
			customFetchImpl,
		},
		baseURL: "http://localhost:3000",
	});

	it("should sign in anonymously", async () => {
		await client.signIn.anonymous({
			fetchOptions: {
				onSuccess: sessionSetter(headers),
			},
		});
		const session = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(session.data?.session).toBeDefined();
		expect(session.data?.user.isAnonymous).toBe(true);
	});

	it("link anonymous user account", async () => {
		expect(linkAccountFn).toHaveBeenCalledTimes(0);
		const res = await client.signIn.email(testUser, {
			headers,
		});
		expect(linkAccountFn).toHaveBeenCalledWith(expect.any(Object));
		linkAccountFn.mockClear();
	});

	it("should link in social sign on", async () => {
		const headers = new Headers();
		await client.signIn.anonymous({
			fetchOptions: {
				onSuccess: sessionSetter(headers),
			},
		});

		await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		const singInRes = await client.signIn.social({
			provider: "google",
			callbackURL: "/dashboard",
		});
		const state = new URL(singInRes.data?.url || "").searchParams.get("state");
		await client.$fetch("/callback/google", {
			query: {
				state,
				code: "test",
			},
			headers,
		});
		expect(linkAccountFn).toHaveBeenCalledWith(expect.any(Object));
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/anonymous/client.ts
```typescript
import type { anonymous } from ".";
import type { BetterAuthClientPlugin } from "../../client/types";

export const anonymousClient = () => {
	return {
		id: "anonymous",
		$InferServerPlugin: {} as ReturnType<typeof anonymous>,
		pathMethods: {
			"/sign-in/anonymous": "POST",
		},
	} satisfies BetterAuthClientPlugin;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/anonymous/index.ts
```typescript
import {
	APIError,
	createAuthEndpoint,
	createAuthMiddleware,
	getSessionFromCtx,
} from "../../api";
import type {
	BetterAuthPlugin,
	InferOptionSchema,
	AuthPluginSchema,
	Session,
	User,
} from "../../types";
import { parseSetCookieHeader, setSessionCookie } from "../../cookies";
import { getOrigin } from "../../utils/url";
import { mergeSchema } from "../../db/schema";

export interface UserWithAnonymous extends User {
	isAnonymous: boolean;
}
export interface AnonymousOptions {
	/**
	 * Configure the domain name of the temporary email
	 * address for anonymous users in the database.
	 * @default "baseURL"
	 */
	emailDomainName?: string;
	/**
	 * A useful hook to run after an anonymous user
	 * is about to link their account.
	 */
	onLinkAccount?: (data: {
		anonymousUser: {
			user: UserWithAnonymous & Record<string, any>;
			session: Session & Record<string, any>;
		};
		newUser: {
			user: User & Record<string, any>;
			session: Session & Record<string, any>;
		};
	}) => Promise<void> | void;
	/**
	 * Disable deleting the anonymous user after linking
	 */
	disableDeleteAnonymousUser?: boolean;
	/**
	 * Custom schema for the anonymous plugin
	 */
	schema?: InferOptionSchema<typeof schema>;
}

const schema = {
	user: {
		fields: {
			isAnonymous: {
				type: "boolean",
				required: false,
			},
		},
	},
} satisfies AuthPluginSchema;

export const anonymous = (options?: AnonymousOptions) => {
	const ERROR_CODES = {
		FAILED_TO_CREATE_USER: "Failed to create user",
		COULD_NOT_CREATE_SESSION: "Could not create session",
		ANONYMOUS_USERS_CANNOT_SIGN_IN_AGAIN_ANONYMOUSLY:
			"Anonymous users cannot sign in again anonymously",
	} as const;
	return {
		id: "anonymous",
		endpoints: {
			signInAnonymous: createAuthEndpoint(
				"/sign-in/anonymous",
				{
					method: "POST",
					metadata: {
						openapi: {
							description: "Sign in anonymously",
							responses: {
								200: {
									description: "Sign in anonymously",
									content: {
										"application/json": {
											schema: {
												type: "object",
												properties: {
													user: {
														$ref: "#/components/schemas/User",
													},
													session: {
														$ref: "#/components/schemas/Session",
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
					const { emailDomainName = getOrigin(ctx.context.baseURL) } =
						options || {};
					const id = ctx.context.generateId({ model: "user" });
					const email = `temp-${id}@${emailDomainName}`;
					const newUser = await ctx.context.internalAdapter.createUser(
						{
							id,
							email,
							emailVerified: false,
							isAnonymous: true,
							name: "Anonymous",
							createdAt: new Date(),
							updatedAt: new Date(),
						},
						ctx,
					);
					if (!newUser) {
						throw ctx.error("INTERNAL_SERVER_ERROR", {
							message: ERROR_CODES.FAILED_TO_CREATE_USER,
						});
					}
					const session = await ctx.context.internalAdapter.createSession(
						newUser.id,
						ctx.request,
					);
					if (!session) {
						return ctx.json(null, {
							status: 400,
							body: {
								message: ERROR_CODES.COULD_NOT_CREATE_SESSION,
							},
						});
					}
					await setSessionCookie(ctx, {
						session,
						user: newUser,
					});
					return ctx.json({
						token: session.token,
						user: {
							id: newUser.id,
							email: newUser.email,
							emailVerified: newUser.emailVerified,
							name: newUser.name,
							createdAt: newUser.createdAt,
							updatedAt: newUser.updatedAt,
						},
					});
				},
			),
		},
		hooks: {
			after: [
				{
					matcher(ctx) {
						return (
							ctx.path.startsWith("/sign-in") ||
							ctx.path.startsWith("/sign-up") ||
							ctx.path.startsWith("/callback") ||
							ctx.path.startsWith("/oauth2/callback") ||
							ctx.path.startsWith("/magic-link/verify") ||
							ctx.path.startsWith("/email-otp/verify-email")
						);
					},
					handler: createAuthMiddleware(async (ctx) => {
						const setCookie = ctx.context.responseHeaders?.get("set-cookie");

						/**
						 * We can consider the user is about to sign in or sign up
						 * if the response contains a session token.
						 */
						const sessionTokenName = ctx.context.authCookies.sessionToken.name;
						/**
						 * The user is about to link their account.
						 */
						const sessionCookie = parseSetCookieHeader(setCookie || "")
							.get(sessionTokenName)
							?.value.split(".")[0];

						if (!sessionCookie) {
							return;
						}
						/**
						 * Make sure the user had an anonymous session.
						 */
						const session = await getSessionFromCtx<{ isAnonymous: boolean }>(
							ctx,
							{
								disableRefresh: true,
							},
						);

						if (!session || !session.user.isAnonymous) {
							return;
						}

						if (ctx.path === "/sign-in/anonymous") {
							throw new APIError("BAD_REQUEST", {
								message:
									ERROR_CODES.ANONYMOUS_USERS_CANNOT_SIGN_IN_AGAIN_ANONYMOUSLY,
							});
						}
						const newSession = ctx.context.newSession;
						if (!newSession) {
							return;
						}
						if (options?.onLinkAccount) {
							await options?.onLinkAccount?.({
								anonymousUser: session,
								newUser: newSession,
							});
						}
						if (!options?.disableDeleteAnonymousUser) {
							await ctx.context.internalAdapter.deleteUser(session.user.id);
						}
					}),
				},
			],
		},
		schema: mergeSchema(schema, options?.schema),
		$ERROR_CODES: ERROR_CODES,
	} satisfies BetterAuthPlugin;
};

```
