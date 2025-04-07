/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/oidc-provider/authorize.ts
```typescript
import { APIError } from "better-call";
import type { GenericEndpointContext } from "../../types";
import { getSessionFromCtx } from "../../api";
import type { AuthorizationQuery, Client, OIDCOptions } from "./types";
import { generateRandomString } from "../../crypto";

function redirectErrorURL(url: string, error: string, description: string) {
	return `${
		url.includes("?") ? "&" : "?"
	}error=${error}&error_description=${description}`;
}

export async function authorize(
	ctx: GenericEndpointContext,
	options: OIDCOptions,
) {
	const opts = {
		codeExpiresIn: 600,
		defaultScope: "openid",
		...options,
		scopes: [
			"openid",
			"profile",
			"email",
			"offline_access",
			...(options?.scopes || []),
		],
	};
	if (!ctx.request) {
		throw new APIError("UNAUTHORIZED", {
			error_description: "request not found",
			error: "invalid_request",
		});
	}
	const session = await getSessionFromCtx(ctx);
	if (!session) {
		/**
		 * If the user is not logged in, we need to redirect them to the
		 * login page.
		 */
		await ctx.setSignedCookie(
			"oidc_login_prompt",
			JSON.stringify(ctx.query),
			ctx.context.secret,
			{
				maxAge: 600,
				path: "/",
				sameSite: "lax",
			},
		);
		const queryFromURL = ctx.request.url?.split("?")[1];
		throw ctx.redirect(`${options.loginPage}?${queryFromURL}`);
	}

	const query = ctx.query as AuthorizationQuery;
	if (!query.client_id) {
		throw ctx.redirect(`${ctx.context.baseURL}/error?error=invalid_client`);
	}

	if (!query.response_type) {
		throw ctx.redirect(
			redirectErrorURL(
				`${ctx.context.baseURL}/error`,
				"invalid_request",
				"response_type is required",
			),
		);
	}

	const client = await ctx.context.adapter
		.findOne<Record<string, any>>({
			model: "oauthApplication",
			where: [
				{
					field: "clientId",
					value: ctx.query.client_id,
				},
			],
		})
		.then((res) => {
			if (!res) {
				return null;
			}
			return {
				...res,
				redirectURLs: res.redirectURLs.split(","),
				metadata: res.metadata ? JSON.parse(res.metadata) : {},
			} as Client;
		});
	if (!client) {
		throw ctx.redirect(`${ctx.context.baseURL}/error?error=invalid_client`);
	}
	const redirectURI = client.redirectURLs.find(
		(url) => url === ctx.query.redirect_uri,
	);

	if (!redirectURI || !query.redirect_uri) {
		/**
		 * show UI error here warning the user that the redirect URI is invalid
		 */
		throw new APIError("BAD_REQUEST", {
			message: "Invalid redirect URI",
		});
	}
	if (client.disabled) {
		throw ctx.redirect(`${ctx.context.baseURL}/error?error=client_disabled`);
	}

	if (query.response_type !== "code") {
		throw ctx.redirect(
			`${ctx.context.baseURL}/error?error=unsupported_response_type`,
		);
	}

	const requestScope =
		query.scope?.split(" ").filter((s) => s) || opts.defaultScope.split(" ");
	const invalidScopes = requestScope.filter((scope) => {
		const isInvalid =
			!opts.scopes.includes(scope) ||
			(scope === "offline_access" && query.prompt !== "consent");
		return isInvalid;
	});
	if (invalidScopes.length) {
		throw ctx.redirect(
			redirectErrorURL(
				query.redirect_uri,
				"invalid_scope",
				`The following scopes are invalid: ${invalidScopes.join(", ")}`,
			),
		);
	}

	if (
		(!query.code_challenge || !query.code_challenge_method) &&
		options.requirePKCE
	) {
		throw ctx.redirect(
			redirectErrorURL(
				query.redirect_uri,
				"invalid_request",
				"pkce is required",
			),
		);
	}

	if (!query.code_challenge_method) {
		query.code_challenge_method = "plain";
	}

	if (
		![
			"s256",
			options.allowPlainCodeChallengeMethod ? "plain" : "s256",
		].includes(query.code_challenge_method?.toLowerCase() || "")
	) {
		throw ctx.redirect(
			redirectErrorURL(
				query.redirect_uri,
				"invalid_request",
				"invalid code_challenge method",
			),
		);
	}

	const code = generateRandomString(32, "a-z", "A-Z", "0-9");
	const codeExpiresInMs = opts.codeExpiresIn * 1000;
	const expiresAt = new Date(Date.now() + codeExpiresInMs);
	try {
		/**
		 * Save the code in the database
		 */
		await ctx.context.internalAdapter.createVerificationValue({
			value: JSON.stringify({
				clientId: client.clientId,
				redirectURI: query.redirect_uri,
				scope: requestScope,
				userId: session.user.id,
				authTime: session.session.createdAt.getTime(),
				/**
				 * If the prompt is set to `consent`, then we need
				 * to require the user to consent to the scopes.
				 *
				 * This means the code now needs to be treated as a
				 * consent request.
				 *
				 * once the user consents, teh code will be updated
				 * with the actual code. This is to prevent the
				 * client from using the code before the user
				 * consents.
				 */
				requireConsent: query.prompt === "consent",
				state: query.prompt === "consent" ? query.state : null,
				codeChallenge: query.code_challenge,
				codeChallengeMethod: query.code_challenge_method,
				nonce: query.nonce,
			}),
			identifier: code,
			expiresAt,
		});
	} catch (e) {
		throw ctx.redirect(
			redirectErrorURL(
				query.redirect_uri,
				"server_error",
				"An error occurred while processing the request",
			),
		);
	}

	const redirectURIWithCode = new URL(redirectURI);
	redirectURIWithCode.searchParams.set("code", code);
	redirectURIWithCode.searchParams.set("state", ctx.query.state);

	if (query.prompt !== "consent") {
		throw ctx.redirect(redirectURIWithCode.toString());
	}

	const hasAlreadyConsented = await ctx.context.adapter
		.findOne<{
			consentGiven: boolean;
		}>({
			model: "oauthConsent",
			where: [
				{
					field: "clientId",
					value: client.clientId,
				},
				{
					field: "userId",
					value: session.user.id,
				},
			],
		})
		.then((res) => !!res?.consentGiven);

	if (hasAlreadyConsented) {
		throw ctx.redirect(redirectURIWithCode.toString());
	}

	if (options?.consentPage) {
		await ctx.setSignedCookie("oidc_consent_prompt", code, ctx.context.secret, {
			maxAge: 600,
			path: "/",
			sameSite: "lax",
		});
		const conceptURI = `${options.consentPage}?client_id=${
			client.clientId
		}&scope=${requestScope.join(" ")}`;
		throw ctx.redirect(conceptURI);
	}
	const htmlFn = options?.getConsentHTML;

	if (!htmlFn) {
		throw new APIError("INTERNAL_SERVER_ERROR", {
			message: "No consent page provided",
		});
	}

	return new Response(
		htmlFn({
			scopes: requestScope,
			clientMetadata: client.metadata,
			clientIcon: client?.icon,
			clientId: client.clientId,
			clientName: client.name,
			code,
		}),
		{
			headers: {
				"content-type": "text/html",
			},
		},
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/oidc-provider/client.ts
```typescript
import type { oidcProvider } from ".";
import type { BetterAuthClientPlugin } from "../../types";

export const oidcClient = () => {
	return {
		id: "oidc-client",
		$InferServerPlugin: {} as ReturnType<typeof oidcProvider>,
	} satisfies BetterAuthClientPlugin;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/oidc-provider/index.ts
```typescript
import { SignJWT } from "jose";
import { z } from "zod";
import {
	APIError,
	createAuthEndpoint,
	createAuthMiddleware,
	getSessionFromCtx,
	sessionMiddleware,
} from "../../api";
import type { BetterAuthPlugin, GenericEndpointContext } from "../../types";
import { generateRandomString } from "../../crypto";
import { subtle } from "@better-auth/utils";
import { schema } from "./schema";
import type {
	Client,
	CodeVerificationValue,
	OAuthAccessToken,
	OIDCMetadata,
	OIDCOptions,
} from "./types";
import { authorize } from "./authorize";
import { parseSetCookieHeader } from "../../cookies";
import { createHash } from "@better-auth/utils/hash";
import { base64 } from "@better-auth/utils/base64";

const getMetadata = (
	ctx: GenericEndpointContext,
	options?: OIDCOptions,
): OIDCMetadata => {
	const issuer = ctx.context.options.baseURL as string;
	const baseURL = ctx.context.baseURL;
	return {
		issuer,
		authorization_endpoint: `${baseURL}/oauth2/authorize`,
		token_endpoint: `${baseURL}/oauth2/token`,
		userinfo_endpoint: `${baseURL}/oauth2/userinfo`,
		jwks_uri: `${baseURL}/jwks`,
		registration_endpoint: `${baseURL}/oauth2/register`,
		scopes_supported: ["openid", "profile", "email", "offline_access"],
		response_types_supported: ["code"],
		response_modes_supported: ["query"],
		grant_types_supported: ["authorization_code"],
		acr_values_supported: [
			"urn:mace:incommon:iap:silver",
			"urn:mace:incommon:iap:bronze",
		],
		subject_types_supported: ["public"],
		id_token_signing_alg_values_supported: ["RS256", "none"],
		token_endpoint_auth_methods_supported: [
			"client_secret_basic",
			"client_secret_post",
		],
		claims_supported: [
			"sub",
			"iss",
			"aud",
			"exp",
			"nbf",
			"iat",
			"jti",
			"email",
			"email_verified",
			"name",
		],
		...options?.metadata,
	};
};

/**
 * OpenID Connect (OIDC) plugin for Better Auth. This plugin implements the
 * authorization code flow and the token exchange flow. It also implements the
 * userinfo endpoint.
 *
 * @param options - The options for the OIDC plugin.
 * @returns A Better Auth plugin.
 */
export const oidcProvider = (options: OIDCOptions) => {
	const modelName = {
		oauthClient: "oauthApplication",
		oauthAccessToken: "oauthAccessToken",
		oauthConsent: "oauthConsent",
	};

	const opts = {
		codeExpiresIn: 600,
		defaultScope: "openid",
		accessTokenExpiresIn: 3600,
		refreshTokenExpiresIn: 604800,
		allowPlainCodeChallengeMethod: true,
		...options,
		scopes: [
			"openid",
			"profile",
			"email",
			"offline_access",
			...(options?.scopes || []),
		],
	};

	return {
		id: "oidc",
		hooks: {
			after: [
				{
					matcher() {
						return true;
					},
					handler: createAuthMiddleware(async (ctx) => {
						const cookie = await ctx.getSignedCookie(
							"oidc_login_prompt",
							ctx.context.secret,
						);
						const cookieName = ctx.context.authCookies.sessionToken.name;
						const parsedSetCookieHeader = parseSetCookieHeader(
							ctx.context.responseHeaders?.get("set-cookie") || "",
						);
						const hasSessionToken = parsedSetCookieHeader.has(cookieName);
						if (!cookie || !hasSessionToken) {
							return;
						}
						ctx.setCookie("oidc_login_prompt", "", {
							maxAge: 0,
						});
						const sessionCookie = parsedSetCookieHeader.get(cookieName)?.value;
						const sessionToken = sessionCookie?.split(".")[0];
						if (!sessionToken) {
							return;
						}
						const session =
							await ctx.context.internalAdapter.findSession(sessionToken);
						if (!session) {
							return;
						}
						ctx.query = JSON.parse(cookie);
						ctx.query!.prompt = "consent";
						ctx.context.session = session;
						const response = await authorize(ctx, opts);
						return response;
					}),
				},
			],
		},
		endpoints: {
			getOpenIdConfig: createAuthEndpoint(
				"/.well-known/openid-configuration",
				{
					method: "GET",
					metadata: {
						isAction: false,
					},
				},
				async (ctx) => {
					const metadata = getMetadata(ctx, options);
					return ctx.json(metadata);
				},
			),
			oAuth2authorize: createAuthEndpoint(
				"/oauth2/authorize",
				{
					method: "GET",
					query: z.record(z.string(), z.any()),
				},
				async (ctx) => {
					return authorize(ctx, opts);
				},
			),
			oAuthConsent: createAuthEndpoint(
				"/oauth2/consent",
				{
					method: "POST",
					body: z.object({
						accept: z.boolean(),
					}),
					use: [sessionMiddleware],
				},
				async (ctx) => {
					const storedCode = await ctx.getSignedCookie(
						"oidc_consent_prompt",
						ctx.context.secret,
					);
					if (!storedCode) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "No consent prompt found",
							error: "invalid_request",
						});
					}
					const verification =
						await ctx.context.internalAdapter.findVerificationValue(storedCode);
					if (!verification) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "Invalid code",
							error: "invalid_request",
						});
					}
					if (verification.expiresAt < new Date()) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "Code expired",
							error: "invalid_request",
						});
					}
					const value = JSON.parse(verification.value) as CodeVerificationValue;
					if (!value.requireConsent || !value.state) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "Consent not required",
							error: "invalid_request",
						});
					}

					if (!ctx.body.accept) {
						await ctx.context.internalAdapter.deleteVerificationValue(
							verification.id,
						);
						return ctx.json({
							redirectURI: `${value.redirectURI}?error=access_denied&error_description=User denied access`,
						});
					}
					const code = generateRandomString(32, "a-z", "A-Z", "0-9");
					const codeExpiresInMs = opts.codeExpiresIn * 1000;
					const expiresAt = new Date(Date.now() + codeExpiresInMs);
					await ctx.context.internalAdapter.updateVerificationValue(
						verification.id,
						{
							value: JSON.stringify({
								...value,
								requireConsent: false,
							}),
							identifier: code,
							expiresAt,
						},
					);
					await ctx.context.adapter.create({
						model: modelName.oauthConsent,
						data: {
							clientId: value.clientId,
							userId: value.userId,
							scopes: value.scope.join(" "),
							consentGiven: true,
							createdAt: new Date(),
							updatedAt: new Date(),
						},
					});
					const redirectURI = new URL(value.redirectURI);
					redirectURI.searchParams.set("code", code);
					redirectURI.searchParams.set("state", value.state);
					return ctx.json({
						redirectURI: redirectURI.toString(),
					});
				},
			),
			oAuth2token: createAuthEndpoint(
				"/oauth2/token",
				{
					method: "POST",
					body: z.record(z.any()),
					metadata: {
						isAction: false,
					},
				},
				async (ctx) => {
					let { body } = ctx;
					if (!body) {
						throw new APIError("BAD_REQUEST", {
							error_description: "request body not found",
							error: "invalid_request",
						});
					}
					if (body instanceof FormData) {
						body = Object.fromEntries(body.entries());
					}
					if (!(body instanceof Object)) {
						throw new APIError("BAD_REQUEST", {
							error_description: "request body is not an object",
							error: "invalid_request",
						});
					}
					let { client_id, client_secret } = body;
					const authorization =
						ctx.request?.headers.get("authorization") || null;
					if (
						authorization &&
						!client_id &&
						!client_secret &&
						authorization.startsWith("Basic ")
					) {
						try {
							const encoded = authorization.replace("Basic ", "");
							const decoded = new TextDecoder().decode(base64.decode(encoded));
							if (!decoded.includes(":")) {
								throw new APIError("UNAUTHORIZED", {
									error_description: "invalid authorization header format",
									error: "invalid_client",
								});
							}
							const [id, secret] = decoded.split(":");
							if (!id || !secret) {
								throw new APIError("UNAUTHORIZED", {
									error_description: "invalid authorization header format",
									error: "invalid_client",
								});
							}
							client_id = id;
							client_secret = secret;
						} catch (error) {
							throw new APIError("UNAUTHORIZED", {
								error_description: "invalid authorization header format",
								error: "invalid_client",
							});
						}
					}
					const {
						grant_type,
						code,
						redirect_uri,
						refresh_token,
						code_verifier,
					} = body;
					if (grant_type === "refresh_token") {
						if (!refresh_token) {
							throw new APIError("BAD_REQUEST", {
								error_description: "refresh_token is required",
								error: "invalid_request",
							});
						}
						const token = await ctx.context.adapter.findOne<OAuthAccessToken>({
							model: modelName.oauthAccessToken,
							where: [
								{
									field: "refreshToken",
									value: refresh_token.toString(),
								},
							],
						});
						if (!token) {
							throw new APIError("UNAUTHORIZED", {
								error_description: "invalid refresh token",
								error: "invalid_grant",
							});
						}
						if (token.clientId !== client_id?.toString()) {
							throw new APIError("UNAUTHORIZED", {
								error_description: "invalid client_id",
								error: "invalid_client",
							});
						}
						if (token.refreshTokenExpiresAt < new Date()) {
							throw new APIError("UNAUTHORIZED", {
								error_description: "refresh token expired",
								error: "invalid_grant",
							});
						}
						const accessToken = generateRandomString(32, "a-z", "A-Z");
						const newRefreshToken = generateRandomString(32, "a-z", "A-Z");
						const accessTokenExpiresAt = new Date(
							Date.now() + opts.accessTokenExpiresIn * 1000,
						);
						const refreshTokenExpiresAt = new Date(
							Date.now() + opts.refreshTokenExpiresIn * 1000,
						);
						await ctx.context.adapter.create({
							model: modelName.oauthAccessToken,
							data: {
								accessToken,
								refreshToken: newRefreshToken,
								accessTokenExpiresAt,
								refreshTokenExpiresAt,
								clientId: client_id.toString(),
								userId: token.userId,
								scopes: token.scopes,
								createdAt: new Date(),
								updatedAt: new Date(),
							},
						});
						return ctx.json({
							access_token: accessToken,
							token_type: "bearer",
							expires_in: opts.accessTokenExpiresIn,
							refresh_token: newRefreshToken,
							scope: token.scopes,
						});
					}

					if (!code) {
						throw new APIError("BAD_REQUEST", {
							error_description: "code is required",
							error: "invalid_request",
						});
					}

					if (options.requirePKCE && !code_verifier) {
						throw new APIError("BAD_REQUEST", {
							error_description: "code verifier is missing",
							error: "invalid_request",
						});
					}

					/**
					 * We need to check if the code is valid before we can proceed
					 * with the rest of the request.
					 */
					const verificationValue =
						await ctx.context.internalAdapter.findVerificationValue(
							code.toString(),
						);
					if (!verificationValue) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "invalid code",
							error: "invalid_grant",
						});
					}
					if (verificationValue.expiresAt < new Date()) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "code expired",
							error: "invalid_grant",
						});
					}

					await ctx.context.internalAdapter.deleteVerificationValue(
						verificationValue.id,
					);
					if (!client_id || !client_secret) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "client_id and client_secret are required",
							error: "invalid_client",
						});
					}
					if (!grant_type) {
						throw new APIError("BAD_REQUEST", {
							error_description: "grant_type is required",
							error: "invalid_request",
						});
					}
					if (grant_type !== "authorization_code") {
						throw new APIError("BAD_REQUEST", {
							error_description: "grant_type must be 'authorization_code'",
							error: "unsupported_grant_type",
						});
					}

					if (!redirect_uri) {
						throw new APIError("BAD_REQUEST", {
							error_description: "redirect_uri is required",
							error: "invalid_request",
						});
					}

					const client = await ctx.context.adapter
						.findOne<Record<string, any>>({
							model: modelName.oauthClient,
							where: [{ field: "clientId", value: client_id.toString() }],
						})
						.then((res) => {
							if (!res) {
								return null;
							}
							return {
								...res,
								redirectURLs: res.redirectURLs.split(","),
								metadata: res.metadata ? JSON.parse(res.metadata) : {},
							} as Client;
						});
					if (!client) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "invalid client_id",
							error: "invalid_client",
						});
					}
					if (client.disabled) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "client is disabled",
							error: "invalid_client",
						});
					}
					const isValidSecret =
						client.clientSecret === client_secret.toString();
					if (!isValidSecret) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "invalid client_secret",
							error: "invalid_client",
						});
					}
					const value = JSON.parse(
						verificationValue.value,
					) as CodeVerificationValue;
					if (value.clientId !== client_id.toString()) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "invalid client_id",
							error: "invalid_client",
						});
					}
					if (value.redirectURI !== redirect_uri.toString()) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "invalid redirect_uri",
							error: "invalid_client",
						});
					}
					if (value.codeChallenge && !code_verifier) {
						throw new APIError("BAD_REQUEST", {
							error_description: "code verifier is missing",
							error: "invalid_request",
						});
					}

					const challenge =
						value.codeChallengeMethod === "plain"
							? code_verifier
							: await createHash("SHA-256", "base64urlnopad").digest(
									code_verifier,
								);

					if (challenge !== value.codeChallenge) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "code verification failed",
							error: "invalid_request",
						});
					}

					const requestedScopes = value.scope;
					await ctx.context.internalAdapter.deleteVerificationValue(
						verificationValue.id,
					);
					const accessToken = generateRandomString(32, "a-z", "A-Z");
					const refreshToken = generateRandomString(32, "A-Z", "a-z");
					const accessTokenExpiresAt = new Date(
						Date.now() + opts.accessTokenExpiresIn * 1000,
					);
					const refreshTokenExpiresAt = new Date(
						Date.now() + opts.refreshTokenExpiresIn * 1000,
					);
					await ctx.context.adapter.create({
						model: modelName.oauthAccessToken,
						data: {
							accessToken,
							refreshToken,
							accessTokenExpiresAt,
							refreshTokenExpiresAt,
							clientId: client_id.toString(),
							userId: value.userId,
							scopes: requestedScopes.join(" "),
							createdAt: new Date(),
							updatedAt: new Date(),
						},
					});
					const user = await ctx.context.internalAdapter.findUserById(
						value.userId,
					);
					if (!user) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "user not found",
							error: "invalid_grant",
						});
					}
					let secretKey = {
						alg: "HS256",
						key: await subtle.generateKey(
							{
								name: "HMAC",
								hash: "SHA-256",
							},
							true,
							["sign", "verify"],
						),
					};
					const profile = {
						given_name: user.name.split(" ")[0],
						family_name: user.name.split(" ")[1],
						name: user.name,
						profile: user.image,
						updated_at: user.updatedAt.toISOString(),
					};
					const email = {
						email: user.email,
						email_verified: user.emailVerified,
					};
					const userClaims = {
						...(requestedScopes.includes("profile") ? profile : {}),
						...(requestedScopes.includes("email") ? email : {}),
					};

					const additionalUserClaims = options.getAdditionalUserInfoClaim
						? options.getAdditionalUserInfoClaim(user, requestedScopes)
						: {};

					const idToken = await new SignJWT({
						sub: user.id,
						aud: client_id.toString(),
						iat: Date.now(),
						auth_time: ctx.context.session?.session.createdAt.getTime(),
						nonce: value.nonce,
						acr: "urn:mace:incommon:iap:silver", // default to silver - ⚠︎ this should be configurable and should be validated against the client's metadata
						...userClaims,
						...additionalUserClaims,
					})
						.setProtectedHeader({ alg: secretKey.alg })
						.setIssuedAt()
						.setExpirationTime(
							Math.floor(Date.now() / 1000) + opts.accessTokenExpiresIn,
						)
						.sign(secretKey.key);

					return ctx.json(
						{
							access_token: accessToken,
							token_type: "Bearer",
							expires_in: opts.accessTokenExpiresIn,
							refresh_token: requestedScopes.includes("offline_access")
								? refreshToken
								: undefined,
							scope: requestedScopes.join(" "),
							id_token: requestedScopes.includes("openid")
								? idToken
								: undefined,
						},
						{
							headers: {
								"Cache-Control": "no-store",
								Pragma: "no-cache",
							},
						},
					);
				},
			),
			oAuth2userInfo: createAuthEndpoint(
				"/oauth2/userinfo",
				{
					method: "GET",
					metadata: {
						isAction: false,
					},
				},
				async (ctx) => {
					if (!ctx.request) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "request not found",
							error: "invalid_request",
						});
					}
					const authorization = ctx.request.headers.get("authorization");
					if (!authorization) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "authorization header not found",
							error: "invalid_request",
						});
					}
					const token = authorization.replace("Bearer ", "");
					const accessToken =
						await ctx.context.adapter.findOne<OAuthAccessToken>({
							model: modelName.oauthAccessToken,
							where: [
								{
									field: "accessToken",
									value: token,
								},
							],
						});
					if (!accessToken) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "invalid access token",
							error: "invalid_token",
						});
					}
					if (accessToken.accessTokenExpiresAt < new Date()) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "The Access Token expired",
							error: "invalid_token",
						});
					}

					const user = await ctx.context.internalAdapter.findUserById(
						accessToken.userId,
					);
					if (!user) {
						throw new APIError("UNAUTHORIZED", {
							error_description: "user not found",
							error: "invalid_token",
						});
					}
					const requestedScopes = accessToken.scopes.split(" ");
					const baseUserClaims = {
						sub: user.id,
						email: requestedScopes.includes("email") ? user.email : undefined,
						name: requestedScopes.includes("profile") ? user.name : undefined,
						picture: requestedScopes.includes("profile")
							? user.image
							: undefined,
						given_name: requestedScopes.includes("profile")
							? user.name.split(" ")[0]
							: undefined,
						family_name: requestedScopes.includes("profile")
							? user.name.split(" ")[1]
							: undefined,
						email_verified: requestedScopes.includes("email")
							? user.emailVerified
							: undefined,
					};
					const userClaims = options.getAdditionalUserInfoClaim
						? options.getAdditionalUserInfoClaim(user, requestedScopes)
						: baseUserClaims;
					return ctx.json({
						...baseUserClaims,
						...userClaims,
					});
				},
			),
			registerOAuthApplication: createAuthEndpoint(
				"/oauth2/register",
				{
					method: "POST",
					body: z.object({
						redirect_uris: z.array(z.string()),
						token_endpoint_auth_method: z
							.enum(["none", "client_secret_basic", "client_secret_post"])
							.default("client_secret_basic")
							.optional(),
						grant_types: z
							.array(
								z.enum([
									"authorization_code",
									"implicit",
									"password",
									"client_credentials",
									"refresh_token",
									"urn:ietf:params:oauth:grant-type:jwt-bearer",
									"urn:ietf:params:oauth:grant-type:saml2-bearer",
								]),
							)
							.default(["authorization_code"])
							.optional(),
						response_types: z
							.array(z.enum(["code", "token"]))
							.default(["code"])
							.optional(),
						client_name: z.string().optional(),
						client_uri: z.string().optional(),
						logo_uri: z.string().optional(),
						scope: z.string().optional(),
						contacts: z.array(z.string()).optional(),
						tos_uri: z.string().optional(),
						policy_uri: z.string().optional(),
						jwks_uri: z.string().optional(),
						jwks: z.record(z.any()).optional(),
						metadata: z.record(z.any()).optional(),
						software_id: z.string().optional(),
						software_version: z.string().optional(),
						software_statement: z.string().optional(),
					}),
				},
				async (ctx) => {
					const body = ctx.body;
					const session = await getSessionFromCtx(ctx);

					// Check authorization
					if (!session && !options.allowDynamicClientRegistration) {
						throw new APIError("UNAUTHORIZED", {
							error: "invalid_token",
							error_description:
								"Authentication required for client registration",
						});
					}

					// Validate redirect URIs for redirect-based flows
					if (
						(!body.grant_types ||
							body.grant_types.includes("authorization_code") ||
							body.grant_types.includes("implicit")) &&
						(!body.redirect_uris || body.redirect_uris.length === 0)
					) {
						throw new APIError("BAD_REQUEST", {
							error: "invalid_redirect_uri",
							error_description:
								"Redirect URIs are required for authorization_code and implicit grant types",
						});
					}

					// Validate correlation between grant_types and response_types
					if (body.grant_types && body.response_types) {
						if (
							body.grant_types.includes("authorization_code") &&
							!body.response_types.includes("code")
						) {
							throw new APIError("BAD_REQUEST", {
								error: "invalid_client_metadata",
								error_description:
									"When 'authorization_code' grant type is used, 'code' response type must be included",
							});
						}
						if (
							body.grant_types.includes("implicit") &&
							!body.response_types.includes("token")
						) {
							throw new APIError("BAD_REQUEST", {
								error: "invalid_client_metadata",
								error_description:
									"When 'implicit' grant type is used, 'token' response type must be included",
							});
						}
					}

					const clientId =
						options.generateClientId?.() ||
						generateRandomString(32, "a-z", "A-Z");
					const clientSecret =
						options.generateClientSecret?.() ||
						generateRandomString(32, "a-z", "A-Z");

					// Create the client with the existing schema
					const client: Client = await ctx.context.adapter.create({
						model: modelName.oauthClient,
						data: {
							name: body.client_name,
							icon: body.logo_uri,
							metadata: body.metadata ? JSON.stringify(body.metadata) : null,
							clientId: clientId,
							clientSecret: clientSecret,
							redirectURLs: body.redirect_uris.join(","),
							type: "web",
							authenticationScheme:
								body.token_endpoint_auth_method || "client_secret_basic",
							disabled: false,
							userId: session?.session.userId,
							createdAt: new Date(),
							updatedAt: new Date(),
						},
					});

					// Format the response according to RFC7591
					return ctx.json(
						{
							client_id: clientId,
							client_secret: clientSecret,
							client_id_issued_at: Math.floor(Date.now() / 1000),
							client_secret_expires_at: 0, // 0 means it doesn't expire
							redirect_uris: body.redirect_uris,
							token_endpoint_auth_method:
								body.token_endpoint_auth_method || "client_secret_basic",
							grant_types: body.grant_types || ["authorization_code"],
							response_types: body.response_types || ["code"],
							client_name: body.client_name,
							client_uri: body.client_uri,
							logo_uri: body.logo_uri,
							scope: body.scope,
							contacts: body.contacts,
							tos_uri: body.tos_uri,
							policy_uri: body.policy_uri,
							jwks_uri: body.jwks_uri,
							jwks: body.jwks,
							software_id: body.software_id,
							software_version: body.software_version,
							software_statement: body.software_statement,
							metadata: body.metadata,
						},
						{
							status: 201,
							headers: {
								"Cache-Control": "no-store",
								Pragma: "no-cache",
							},
						},
					);
				},
			),
			getOAuthClient: createAuthEndpoint(
				"/oauth2/client/:id",
				{
					method: "GET",
					use: [sessionMiddleware],
				},
				async (ctx) => {
					const client = await ctx.context.adapter.findOne<Record<string, any>>(
						{
							model: modelName.oauthClient,
							where: [{ field: "clientId", value: ctx.params.id }],
						},
					);
					if (!client) {
						throw new APIError("NOT_FOUND", {
							error_description: "client not found",
							error: "not_found",
						});
					}
					return ctx.json({
						clientId: client.clientId as string,
						name: client.name as string,
						icon: client.icon as string,
					});
				},
			),
		},
		schema,
	} satisfies BetterAuthPlugin;
};
export type * from "./types";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/oidc-provider/oidc.test.ts
```typescript
import { afterAll, beforeAll, describe, it } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";
import { oidcProvider } from ".";
import { genericOAuth } from "../generic-oauth";
import type { Client } from "./types";
import { createAuthClient } from "../../client";
import { oidcClient } from "./client";
import { genericOAuthClient } from "../generic-oauth/client";
import { listen, type Listener } from "listhen";
import { toNodeHandler } from "../../integrations/node";
import { jwt } from "../jwt";

describe("oidc", async () => {
	const {
		auth: authorizationServer,
		signInWithTestUser,
		customFetchImpl,
		testUser,
	} = await getTestInstance({
		baseURL: "http://localhost:3000",
		plugins: [
			oidcProvider({
				loginPage: "/login",
				consentPage: "/oauth2/authorize",
				requirePKCE: true,
				getAdditionalUserInfoClaim(user, scopes) {
					return {
						custom: "custom value",
						userId: user.id,
					};
				},
			}),
			jwt(),
		],
	});
	const { headers } = await signInWithTestUser();
	const serverClient = createAuthClient({
		plugins: [oidcClient()],
		baseURL: "http://localhost:3000",
		fetchOptions: {
			customFetchImpl,
			headers,
		},
	});

	let server: Listener;

	beforeAll(async () => {
		server = await listen(toNodeHandler(authorizationServer.handler), {
			port: 3000,
		});
	});

	afterAll(async () => {
		await server.close();
	});

	let application: Client = {
		clientId: "test-client-id",
		clientSecret: "test-client-secret-oidc",
		redirectURLs: ["http://localhost:3000/api/auth/oauth2/callback/test"],
		metadata: {},
		icon: "",
		type: "web",
		disabled: false,
		name: "test",
	};

	it("should create oidc client", async ({ expect }) => {
		const createdClient = await serverClient.oauth2.register({
			client_name: application.name,
			redirect_uris: application.redirectURLs,
			logo_uri: application.icon,
		});
		expect(createdClient.data).toMatchObject({
			client_id: expect.any(String),
			client_secret: expect.any(String),
			client_name: "test",
			logo_uri: "",
			redirect_uris: ["http://localhost:3000/api/auth/oauth2/callback/test"],
			grant_types: ["authorization_code"],
			response_types: ["code"],
			token_endpoint_auth_method: "client_secret_basic",
			client_id_issued_at: expect.any(Number),
			client_secret_expires_at: 0,
		});
		if (createdClient.data) {
			application = {
				clientId: createdClient.data.client_id,
				clientSecret: createdClient.data.client_secret,
				redirectURLs: createdClient.data.redirect_uris,
				metadata: {},
				icon: createdClient.data.logo_uri || "",
				type: "web",
				disabled: false,
				name: createdClient.data.client_name || "",
			};
		}
	});

	it("should sign in the user with the provider", async ({ expect }) => {
		// The RP (Relying Party) - the client application
		const { customFetchImpl: customFetchImplRP } = await getTestInstance({
			account: {
				accountLinking: {
					trustedProviders: ["test"],
				},
			},
			plugins: [
				genericOAuth({
					config: [
						{
							providerId: "test",
							clientId: application.clientId,
							clientSecret: application.clientSecret,
							authorizationUrl:
								"http://localhost:3000/api/auth/oauth2/authorize",
							tokenUrl: "http://localhost:3000/api/auth/oauth2/token",
							scopes: ["openid", "profile", "email"],
							pkce: true,
						},
					],
				}),
			],
		});

		const client = createAuthClient({
			plugins: [genericOAuthClient()],
			baseURL: "http://localhost:5000",
			fetchOptions: {
				customFetchImpl: customFetchImplRP,
			},
		});
		const data = await client.signIn.oauth2(
			{
				providerId: "test",
				callbackURL: "/dashboard",
			},
			{
				throw: true,
			},
		);
		expect(data.url).toContain(
			"http://localhost:3000/api/auth/oauth2/authorize",
		);
		expect(data.url).toContain(`client_id=${application.clientId}`);

		let redirectURI = "";
		await serverClient.$fetch(data.url, {
			method: "GET",
			onError(context) {
				redirectURI = context.response.headers.get("Location") || "";
			},
		});
		expect(redirectURI).toContain(
			"http://localhost:3000/api/auth/oauth2/callback/test?code=",
		);

		let callbackURL = "";
		await client.$fetch(redirectURI, {
			onError(context) {
				callbackURL = context.response.headers.get("Location") || "";
			},
		});
		expect(callbackURL).toContain("/dashboard");
	});

	it("should sign in after a consent flow", async ({ expect }) => {
		// The RP (Relying Party) - the client application
		const { customFetchImpl: customFetchImplRP, cookieSetter } =
			await getTestInstance({
				account: {
					accountLinking: {
						trustedProviders: ["test"],
					},
				},
				plugins: [
					genericOAuth({
						config: [
							{
								providerId: "test",
								clientId: application.clientId,
								clientSecret: application.clientSecret,
								authorizationUrl:
									"http://localhost:3000/api/auth/oauth2/authorize",
								tokenUrl: "http://localhost:3000/api/auth/oauth2/token",
								scopes: ["openid", "profile", "email"],
								prompt: "consent",
								pkce: true,
							},
						],
					}),
				],
			});

		const client = createAuthClient({
			plugins: [genericOAuthClient()],
			baseURL: "http://localhost:5000",
			fetchOptions: {
				customFetchImpl: customFetchImplRP,
			},
		});
		const data = await client.signIn.oauth2(
			{
				providerId: "test",
				callbackURL: "/dashboard",
			},
			{
				throw: true,
			},
		);
		expect(data.url).toContain(
			"http://localhost:3000/api/auth/oauth2/authorize",
		);
		expect(data.url).toContain(`client_id=${application.clientId}`);

		let redirectURI = "";
		const newHeaders = new Headers();
		await serverClient.$fetch(data.url, {
			method: "GET",
			onError(context) {
				redirectURI = context.response.headers.get("Location") || "";
				cookieSetter(newHeaders)(context);
				newHeaders.append("Cookie", headers.get("Cookie") || "");
			},
		});
		expect(redirectURI).toContain("/oauth2/authorize?client_id=");
		const res = await serverClient.oauth2.consent(
			{
				accept: true,
			},
			{
				headers: newHeaders,
				throw: true,
			},
		);
		expect(res.redirectURI).toContain(
			"http://localhost:3000/api/auth/oauth2/callback/test?code=",
		);

		let callbackURL = "";
		await client.$fetch(res.redirectURI, {
			onError(context) {
				callbackURL = context.response.headers.get("Location") || "";
			},
		});
		expect(callbackURL).toContain("/dashboard");
	});

	it("should sign in after a login flow", async ({ expect }) => {
		// The RP (Relying Party) - the client application
		const { customFetchImpl: customFetchImplRP, cookieSetter } =
			await getTestInstance({
				account: {
					accountLinking: {
						trustedProviders: ["test"],
					},
				},
				plugins: [
					genericOAuth({
						config: [
							{
								providerId: "test",
								clientId: application.clientId,
								clientSecret: application.clientSecret,
								authorizationUrl:
									"http://localhost:3000/api/auth/oauth2/authorize",
								tokenUrl: "http://localhost:3000/api/auth/oauth2/token",
								scopes: ["openid", "profile", "email"],
								prompt: "login",
								pkce: true,
							},
						],
					}),
				],
			});

		const client = createAuthClient({
			plugins: [genericOAuthClient()],
			baseURL: "http://localhost:5000",
			fetchOptions: {
				customFetchImpl: customFetchImplRP,
			},
		});
		const data = await client.signIn.oauth2(
			{
				providerId: "test",
				callbackURL: "/dashboard",
			},
			{
				throw: true,
			},
		);
		expect(data.url).toContain(
			"http://localhost:3000/api/auth/oauth2/authorize",
		);
		expect(data.url).toContain(`client_id=${application.clientId}`);

		let redirectURI = "";
		const newHeaders = new Headers();
		await serverClient.$fetch(data.url, {
			method: "GET",
			onError(context) {
				redirectURI = context.response.headers.get("Location") || "";
				cookieSetter(newHeaders)(context);
			},
			headers: newHeaders,
		});
		expect(redirectURI).toContain("/login");

		await serverClient.signIn.email(
			{
				email: testUser.email,
				password: testUser.password,
			},
			{
				headers: newHeaders,
				onError(context) {
					redirectURI = context.response.headers.get("Location") || "";
					cookieSetter(newHeaders)(context);
				},
			},
		);

		expect(redirectURI).toContain(
			"http://localhost:3000/api/auth/oauth2/callback/test?code=",
		);
		let callbackURL = "";
		await client.$fetch(redirectURI, {
			onError(context) {
				callbackURL = context.response.headers.get("Location") || "";
			},
		});
		expect(callbackURL).toContain("/dashboard");
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/oidc-provider/schema.ts
```typescript
import type { AuthPluginSchema } from "../../types";

export const schema = {
	oauthApplication: {
		modelName: "oauthApplication",
		fields: {
			name: {
				type: "string",
			},
			icon: {
				type: "string",
				required: false,
			},
			metadata: {
				type: "string",
				required: false,
			},
			clientId: {
				type: "string",
				unique: true,
			},
			clientSecret: {
				type: "string",
			},
			redirectURLs: {
				type: "string",
			},
			type: {
				type: "string",
			},
			disabled: {
				type: "boolean",
				required: false,
				defaultValue: false,
			},
			userId: {
				type: "string",
				required: false,
			},
			createdAt: {
				type: "date",
			},
			updatedAt: {
				type: "date",
			},
		},
	},
	oauthAccessToken: {
		modelName: "oauthAccessToken",
		fields: {
			accessToken: {
				type: "string",
				unique: true,
			},
			refreshToken: {
				type: "string",
				unique: true,
			},
			accessTokenExpiresAt: {
				type: "date",
			},
			refreshTokenExpiresAt: {
				type: "date",
			},
			clientId: {
				type: "string",
			},
			userId: {
				type: "string",
				required: false,
			},
			scopes: {
				type: "string",
			},
			createdAt: {
				type: "date",
			},
			updatedAt: {
				type: "date",
			},
		},
	},
	oauthConsent: {
		modelName: "oauthConsent",
		fields: {
			clientId: {
				type: "string",
			},
			userId: {
				type: "string",
			},
			scopes: {
				type: "string",
			},
			createdAt: {
				type: "date",
			},
			updatedAt: {
				type: "date",
			},
			consentGiven: {
				type: "boolean",
			},
		},
	},
} satisfies AuthPluginSchema;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/oidc-provider/types.ts
````typescript
import type { User } from "../../types";

export interface OIDCOptions {
	/**
	 * The amount of time in seconds that the access token is valid for.
	 *
	 * @default 3600 (1 hour) - Recommended by the OIDC spec
	 */
	accessTokenExpiresIn?: number;
	/**
	 * Allow dynamic client registration.
	 */
	allowDynamicClientRegistration?: boolean;
	/**
	 * The metadata for the OpenID Connect provider.
	 */
	metadata?: Partial<OIDCMetadata>;
	/**
	 * The amount of time in seconds that the refresh token is valid for.
	 *
	 * @default 604800 (7 days) - Recommended by the OIDC spec
	 */
	refreshTokenExpiresIn?: number;
	/**
	 * The amount of time in seconds that the authorization code is valid for.
	 *
	 * @default 600 (10 minutes) - Recommended by the OIDC spec
	 */
	codeExpiresIn?: number;
	/**
	 * The scopes that the client is allowed to request.
	 *
	 * @see https://openid.net/specs/openid-connect-core-1_0.html#ScopeClaims
	 * @default
	 * ```ts
	 * ["openid", "profile", "email", "offline_access"]
	 * ```
	 */
	scopes?: string[];
	/**
	 * The default scope to use if the client does not provide one.
	 *
	 * @default "openid"
	 */
	defaultScope?: string;
	/**
	 * A URL to the consent page where the user will be redirected if the client
	 * requests consent.
	 *
	 * After the user consents, they should be redirected by the client to the
	 * `redirect_uri` with the authorization code.
	 *
	 * When the server redirects the user to the consent page, it will include the
	 * following query parameters:
	 * authorization code.
	 * - `client_id` - The ID of the client.
	 * - `scope` - The requested scopes.
	 * - `code` - The authorization code.
	 *
	 * once the user consents, you need to call the `/oauth2/consent` endpoint
	 * with the code and `accept: true` to complete the authorization. Which will
	 * then return the client to the `redirect_uri` with the authorization code.
	 *
	 * @example
	 * ```ts
	 * consentPage: "/oauth/authorize"
	 * ```
	 */
	consentPage?: string;
	/**
	 * The HTML for the consent page. This is used if `consentPage` is not
	 * provided. This should be a function that returns an HTML string.
	 * The function will be called with the following props:
	 */
	getConsentHTML?: (props: {
		clientId: string;
		clientName: string;
		clientIcon?: string;
		clientMetadata: Record<string, any> | null;
		code: string;
		scopes: string[];
	}) => string;
	/**
	 * The URL to the login page. This is used if the client requests the `login`
	 * prompt.
	 */
	loginPage: string;
	/**
	 * Weather to require PKCE (proof key code exchange) or not
	 *
	 * According to OAuth2.1 spec this should be required. But in any
	 * case if you want to disable this you can use this options.
	 *
	 * @default true
	 */
	requirePKCE?: boolean;
	/**
	 * Allow plain to be used as a code challenge method.
	 *
	 * @default true
	 */
	allowPlainCodeChallengeMethod?: boolean;
	/**
	 * Custom function to generate a client ID.
	 */
	generateClientId?: () => string;
	/**
	 * Custom function to generate a client secret.
	 */
	generateClientSecret?: () => string;
	/**
	 * Get the additional user info claims
	 *
	 * This applies to the `userinfo` endpoint and the `id_token`.
	 *
	 * @param user - The user object.
	 * @param scopes - The scopes that the client requested.
	 * @returns The user info claim.
	 */
	getAdditionalUserInfoClaim?: (
		user: User & Record<string, any>,
		scopes: string[],
	) => Record<string, any> | Promise<Record<string, any>>;
}

export interface AuthorizationQuery {
	/**
	 * The response type. Must be 'code' or 'token'. Code is for authorization code flow, token is
	 * for implicit flow.
	 */
	response_type: "code" | "token";
	/**
	 * The redirect URI for the client. Must be one of the registered redirect URLs for the client.
	 */
	redirect_uri?: string;
	/**
	 * The scope of the request. Must be a space-separated list of case sensitive strings.
	 *
	 * - "openid" is required for all requests
	 * - "profile" is required for requests that require user profile information.
	 * - "email" is required for requests that require user email information.
	 * - "offline_access" is required for requests that require a refresh token.
	 */
	scope?: string;
	/**
	 * Opaque value used to maintain state between the request and the callback. Typically,
	 * Cross-Site Request Forgery (CSRF, XSRF) mitigation is done by cryptographically binding the
	 * value of this parameter with a browser cookie.
	 *
	 * Note: Better Auth stores the state in a database instead of a cookie. - This is to minimize
	 * the complication with native apps and other clients that may not have access to cookies.
	 */
	state: string;
	/**
	 * The client ID. Must be the ID of a registered client.
	 */
	client_id: string;
	/**
	 * The prompt parameter is used to specify the type of user interaction that is required.
	 */
	prompt?: "none" | "consent" | "login" | "select_account";
	/**
	 * The display parameter is used to specify how the authorization server displays the
	 * authentication and consent user interface pages to the end user.
	 */
	display?: "page" | "popup" | "touch" | "wap";
	/**
	 * End-User's preferred languages and scripts for the user interface, represented as a
	 * space-separated list of BCP47 [RFC5646] language tag values, ordered by preference. For
	 * instance, the value "fr-CA fr en" represents a preference for French as spoken in Canada,
	 * then French (without a region designation), followed by English (without a region
	 * designation).
	 *
	 * Better Auth does not support this parameter yet. It'll not throw an error if it's provided,
	 *
	 * 🏗️ currently not implemented
	 */
	ui_locales?: string;
	/**
	 * The maximum authentication age.
	 *
	 * Specifies the allowable elapsed time in seconds since the last time the End-User was
	 * actively authenticated by the provider. If the elapsed time is greater than this value, the
	 * provider MUST attempt to actively re-authenticate the End-User.
	 *
	 * Note that max_age=0 is equivalent to prompt=login.
	 */
	max_age?: number;
	/**
	 * Requested Authentication Context Class Reference values.
	 *
	 * Space-separated string that
	 * specifies the acr values that the Authorization Server is being requested to use for
	 * processing this Authentication Request, with the values appearing in order of preference.
	 * The Authentication Context Class satisfied by the authentication performed is returned as
	 * the acr Claim Value, as specified in Section 2. The acr Claim is requested as a Voluntary
	 * Claim by this parameter.
	 */
	acr_values?: string;
	/**
	 * Hint to the Authorization Server about the login identifier the End-User might use to log in
	 * (if necessary). This hint can be used by an RP if it first asks the End-User for their
	 * e-mail address (or other identifier) and then wants to pass that value as a hint to the
	 * discovered authorization service. It is RECOMMENDED that the hint value match the value used
	 * for discovery. This value MAY also be a phone number in the format specified for the
	 * phone_number Claim. The use of this parameter is left to the OP's discretion.
	 */
	login_hint?: string;
	/**
	 * ID Token previously issued by the Authorization Server being passed as a hint about the
	 * End-User's current or past authenticated session with the Client.
	 *
	 * 🏗️ currently not implemented
	 */
	id_token_hint?: string;
	/**
	 * Code challenge
	 */
	code_challenge?: string;
	/**
	 * Code challenge method used
	 */
	code_challenge_method?: "plain" | "s256";
	/**
	 * String value used to associate a Client session with an ID Token, and to mitigate replay
	 * attacks. The value is passed through unmodified from the Authentication Request to the ID Token.
	 * If present in the ID Token, Clients MUST verify that the nonce Claim Value is equal to the
	 * value of the nonce parameter sent in the Authentication Request. If present in the
	 * Authentication Request, Authorization Servers MUST include a nonce Claim in the ID Token
	 * with the Claim Value being the nonce value sent in the Authentication Request.
	 */
	nonce?: string;
}

export interface Client {
	/**
	 * Client ID
	 *
	 * size 32
	 *
	 * as described on https://www.rfc-editor.org/rfc/rfc6749.html#section-2.2
	 */
	clientId: string;
	/**
	 * Client Secret
	 *
	 * A secret for the client, if required by the authorization server.
	 *
	 * size 32
	 */
	clientSecret: string;
	/**
	 * The client type
	 *
	 * as described on https://www.rfc-editor.org/rfc/rfc6749.html#section-2.1
	 *
	 * - web - A web application
	 * - native - A mobile application
	 * - user-agent-based - A user-agent-based application
	 */
	type: "web" | "native" | "user-agent-based";
	/**
	 * List of registered redirect URLs. Must include the whole URL, including the protocol, port,
	 * and path.
	 *
	 * For example, `https://example.com/auth/callback`
	 */
	redirectURLs: string[];
	/**
	 * The name of the client.
	 */
	name: string;
	/**
	 * The icon of the client.
	 */
	icon?: string;
	/**
	 * Additional metadata about the client.
	 */
	metadata: {
		[key: string]: any;
	} | null;
	/**
	 * Whether the client is disabled or not.
	 */
	disabled: boolean;
}

export interface TokenBody {
	/**
	 * The grant type. Must be 'authorization_code' or 'refresh_token'.
	 */
	grant_type: "authorization_code" | "refresh_token";
	/**
	 * The authorization code received from the authorization server.
	 */
	code?: string;
	/**
	 * The redirect URI of the client.
	 */
	redirect_uri?: string;
	/**
	 * The client ID.
	 */
	client_id?: string;
	/**
	 * The client secret.
	 */
	client_secret?: string;
	/**
	 * The refresh token received from the authorization server.
	 */
	refresh_token?: string;
}

export interface CodeVerificationValue {
	/**
	 * The client ID
	 */
	clientId: string;
	/**
	 * The redirect URI for the client
	 */
	redirectURI: string;
	/**
	 * The scopes that the client requested
	 */
	scope: string[];
	/**
	 * The user ID
	 */
	userId: string;
	/**
	 * The time that the user authenticated
	 */
	authTime: number;
	/**
	 * Whether the user needs to consent to the scopes
	 * before the code can be exchanged for an access token.
	 *
	 * If this is true, then the code is treated as a consent
	 * request. Once the user consents, the code will be updated
	 * with the actual code.
	 */
	requireConsent: boolean;
	/**
	 * The state parameter from the request
	 *
	 * If the prompt is set to `consent`, then the state
	 * parameter is saved here. This is to prevent the client
	 * from using the code before the user consents.
	 */
	state: string | null;
	/**
	 * Code challenge
	 */
	codeChallenge?: string;
	/**
	 * Code Challenge Method
	 */
	codeChallengeMethod?: "sha256" | "plain";
	/**
	 * Nonce
	 */
	nonce?: string;
}

export interface OAuthAccessToken {
	/**
	 * The access token
	 */
	accessToken: string;
	/**
	 * The refresh token
	 */
	refreshToken: string;
	/**
	 * The time that the access token expires
	 */
	accessTokenExpiresAt: Date;
	/**
	 * The time that the refresh token expires
	 */
	refreshTokenExpiresAt: Date;
	/**
	 * The client ID
	 */
	clientId: string;
	/**
	 * The user ID
	 */
	userId: string;
	/**
	 * The scopes that the access token has access to
	 */
	scopes: string;
}

export interface OIDCMetadata {
	/**
	 * The issuer identifier, this is the URL of the provider and can be used to verify
	 * the `iss` claim in the ID token.
	 *
	 * default: the base URL of the server (e.g. `https://example.com`)
	 */
	issuer: string;
	/**
	 * The URL of the authorization endpoint.
	 *
	 * @default `/oauth2/authorize`
	 */
	authorization_endpoint: string;
	/**
	 * The URL of the token endpoint.
	 *
	 * @default `/oauth2/token`
	 */
	token_endpoint: string;
	/**
	 * The URL of the userinfo endpoint.
	 *
	 * @default `/oauth2/userinfo`
	 */
	userinfo_endpoint: string;
	/**
	 * The URL of the jwks_uri endpoint.
	 *
	 * For JWKS to work, you must install the `jwt` plugin.
	 *
	 * This value is automatically set to `/jwks` if the `jwt` plugin is installed.
	 *
	 * @default `/jwks`
	 */
	jwks_uri: string;
	/**
	 * The URL of the dynamic client registration endpoint.
	 *
	 * @default `/oauth2/register`
	 */
	registration_endpoint: string;
	/**
	 * Supported scopes.
	 */
	scopes_supported: string[];
	/**
	 * Supported response types.
	 *
	 * only `code` is supported.
	 */
	response_types_supported: ["code"];
	/**
	 * Supported response modes.
	 *
	 * `query`: the authorization code is returned in the query string
	 *
	 * only `query` is supported.
	 */
	response_modes_supported: ["query"];
	/**
	 * Supported grant types.
	 *
	 * only `authorization_code` is supported.
	 */
	grant_types_supported: ["authorization_code"];
	/**
	 * acr_values supported.
	 *
	 * - `urn:mace:incommon:iap:silver`: Silver level of assurance
	 * - `urn:mace:incommon:iap:bronze`: Bronze level of assurance
	 *
	 * only `urn:mace:incommon:iap:silver` and `urn:mace:incommon:iap:bronze` are supported.
	 *
	 *
	 * @default
	 * ["urn:mace:incommon:iap:silver", "urn:mace:incommon:iap:bronze"]
	 * @see https://incommon.org/federation/attributes.html
	 */
	acr_values_supported: string[];
	/**
	 * Supported subject types.
	 *
	 * pairwise: the subject identifier is unique to the client
	 * public: the subject identifier is unique to the server
	 *
	 * only `public` is supported.
	 */
	subject_types_supported: ["public"];
	/**
	 * Supported ID token signing algorithms.
	 *
	 * only `RS256` and `none` are supported.
	 *
	 * @default
	 * ["RS256", "none"]
	 */
	id_token_signing_alg_values_supported: ("RS256" | "none")[];
	/**
	 * Supported token endpoint authentication methods.
	 *
	 * only `client_secret_basic` and `client_secret_post` are supported.
	 *
	 * @default
	 * ["client_secret_basic", "client_secret_post"]
	 */
	token_endpoint_auth_methods_supported: [
		"client_secret_basic",
		"client_secret_post",
	];
	/**
	 * Supported claims.
	 *
	 * @default
	 * ["sub", "iss", "aud", "exp", "nbf", "iat", "jti", "email", "email_verified", "name"]
	 */
	claims_supported: string[];
}

````
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/oidc-provider/ui.ts
```typescript
export const authorizeHTML = ({
	scopes,
	clientIcon,
	clientName,
	redirectURI,
	cancelURI,
}: {
	scopes: string[];
	clientIcon?: string;
	clientName: string;
	redirectURI: string;
	cancelURI: string;
	clientMetadata?: Record<string, any>;
}) => `<!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta clientName="viewport" content="width=device-width, initial-scale=1.0">
      <title>Authorize Application</title>
      <style>
          :root {
              --bg-color: #000000;
              --card-color: #1a1a1a;
              --text-primary: #ffffff;
              --text-secondary: #b0b0b0;
              --border-color: #333333;
              --button-color: #ffffff;
              --button-text: #000000;
          }
          body {
              font-family: 'Inter', 'Helvetica', 'Arial', sans-serif;
              background-color: var(--bg-color);
              color: var(--text-primary);
              display: flex;
              justify-content: center;
              align-items: center;
              min-height: 100vh;
              margin: 0;
              padding: 20px;
              box-sizing: border-box;
          }
          .authorize-container {
              background-color: var(--card-color);
              border: 1px solid var(--border-color);
              padding: 32px;
              width: 100%;
              max-width: 420px;
              box-shadow: 0 8px 24px rgba(255,255,255,0.1);
          }
          .app-info {
              display: flex;
              align-items: center;
              margin-bottom: 24px;
          }
          .app-clientIcon {
              width: 64px;
              height: 64px;
              margin-right: 16px;
              object-fit: cover;
          }
          .app-clientName {
              font-size: 24px;
              font-weight: 700;
          }
          .permissions-list {
              background-color: rgba(255, 255, 255, 0.05);
              border: 1px solid var(--border-color);
              padding: 16px;
              margin-bottom: 24px;
          }
          .permissions-list h3 {
              margin-top: 0;
              font-size: 16px;
              color: var(--text-secondary);
              margin-bottom: 12px;
          }
          .permissions-list ul {
              list-style-type: none;
              padding: 0;
              margin: 0;
          }
          .permissions-list li {
              margin-bottom: 8px;
              display: flex;
              align-items: center;
          }
          .permissions-list li::before {
              content: "•";
              color: var(--text-primary);
              font-size: 18px;
              margin-right: 8px;
          }
          .buttons {
              display: flex;
              justify-content: flex-end;
              gap: 12px;
          }
          .button {
              padding: 10px 20px;
              border: none;
              font-size: 14px;
              font-weight: 600;
              cursor: pointer;
              transition: all 0.2s ease;
          }
          .authorize {
              background-color: var(--button-color);
              color: var(--button-text);
          }
          .authorize:hover {
              opacity: 0.9;
          }
          .cancel {
              background-color: transparent;
              color: var(--text-secondary);
              border: 1px solid var(--text-secondary);
          }
          .cancel:hover {
              background-color: rgba(255, 255, 255, 0.1);
          }
      </style>
  </head>
  <body>
      <div class="authorize-container">
          <div class="app-info">
              <img src="${clientIcon || ""}" alt="${clientName} clientIcon" class="app-clientIcon">
              <span class="app-clientName">${clientName}</span>
          </div>
          <p>${clientName} would like permission to access your account</p>
          <div class="permissions-list">
              <h3>This will allow ${clientName} to:</h3>
              <ul>
                  ${scopes.map((scope) => `<li>${scope}</li>`).join("")}
              </ul>
          </div>
          <div class="buttons">
                <a href="${cancelURI}" class="button cancel">Cancel</a>
               <a href="${redirectURI}" class="button authorize">Authorize</a>
          </div>
      </div>
  </body>
  </html>`;

```
