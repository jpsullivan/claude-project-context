/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/apple.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import { APIError } from "better-call";
import { decodeJwt, decodeProtectedHeader, importJWK, jwtVerify } from "jose";
import type { OAuthProvider, ProviderOptions } from "../oauth2";
import {
	refreshAccessToken,
	createAuthorizationURL,
	validateAuthorizationCode,
} from "../oauth2";
export interface AppleProfile {
	/**
	 * The subject registered claim identifies the principal that’s the subject
	 * of the identity token. Because this token is for your app, the value is
	 * the unique identifier for the user.
	 */
	sub: string;
	/**
	 * A String value representing the user's email address.
	 * The email address is either the user's real email address or the proxy
	 * address, depending on their status private email relay service.
	 */
	email: string;
	/**
	 * A string or Boolean value that indicates whether the service verifies
	 * the email. The value can either be a string ("true" or "false") or a
	 * Boolean (true or false). The system may not verify email addresses for
	 * Sign in with Apple at Work & School users, and this claim is "false" or
	 * false for those users.
	 */
	email_verified: true | "true";
	/**
	 * A string or Boolean value that indicates whether the email that the user
	 * shares is the proxy address. The value can either be a string ("true" or
	 * "false") or a Boolean (true or false).
	 */
	is_private_email: boolean;
	/**
	 * An Integer value that indicates whether the user appears to be a real
	 * person. Use the value of this claim to mitigate fraud. The possible
	 * values are: 0 (or Unsupported), 1 (or Unknown), 2 (or LikelyReal). For
	 * more information, see ASUserDetectionStatus. This claim is present only
	 * in iOS 14 and later, macOS 11 and later, watchOS 7 and later, tvOS 14
	 * and later. The claim isn’t present or supported for web-based apps.
	 */
	real_user_status: number;
	/**
	 * The user’s full name in the format provided during the authorization
	 * process.
	 */
	name: string;
	/**
	 * The URL to the user's profile picture.
	 */
	picture: string;
	user?: AppleNonConformUser;
}

/**
 * This is the shape of the `user` query parameter that Apple sends the first
 * time the user consents to the app.
 * @see https://developer.apple.com/documentation/signinwithapplerestapi/request-an-authorization-to-the-sign-in-with-apple-server./
 */
export interface AppleNonConformUser {
	name: {
		firstName: string;
		lastName: string;
	};
	email: string;
}

export interface AppleOptions extends ProviderOptions<AppleProfile> {
	appBundleIdentifier?: string;
}

export const apple = (options: AppleOptions) => {
	const tokenEndpoint = "https://appleid.apple.com/auth/token";
	return {
		id: "apple",
		name: "Apple",
		async createAuthorizationURL({ state, scopes, redirectURI }) {
			const _scope = options.disableDefaultScope ? [] : ["email", "name"];
			options.scope && _scope.push(...options.scope);
			scopes && _scope.push(...scopes);
			const url = await createAuthorizationURL({
				id: "apple",
				options,
				authorizationEndpoint: "https://appleid.apple.com/auth/authorize",
				scopes: _scope,
				state,
				redirectURI,
				responseMode: "form_post",
			});
			return url;
		},
		validateAuthorizationCode: async ({ code, codeVerifier, redirectURI }) => {
			return validateAuthorizationCode({
				code,
				codeVerifier,
				redirectURI,
				options,
				tokenEndpoint,
			});
		},
		async verifyIdToken(token, nonce) {
			if (options.disableIdTokenSignIn) {
				return false;
			}
			if (options.verifyIdToken) {
				return options.verifyIdToken(token, nonce);
			}
			const decodedHeader = decodeProtectedHeader(token);
			const { kid, alg: jwtAlg } = decodedHeader;
			if (!kid || !jwtAlg) return false;
			const publicKey = await getApplePublicKey(kid);
			const { payload: jwtClaims } = await jwtVerify(token, publicKey, {
				algorithms: [jwtAlg],
				issuer: "https://appleid.apple.com",
				audience: options.appBundleIdentifier || options.clientId,
				maxTokenAge: "1h",
			});
			["email_verified", "is_private_email"].forEach((field) => {
				if (jwtClaims[field] !== undefined) {
					jwtClaims[field] = Boolean(jwtClaims[field]);
				}
			});
			if (nonce && jwtClaims.nonce !== nonce) {
				return false;
			}
			return !!jwtClaims;
		},
		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint: "https://appleid.apple.com/auth/token",
					});
				},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}
			if (!token.idToken) {
				return null;
			}
			const profile = decodeJwt<AppleProfile>(token.idToken);
			if (!profile) {
				return null;
			}
			const name = profile.user
				? `${profile.user.name.firstName} ${profile.user.name.lastName}`
				: profile.email;
			const userMap = await options.mapProfileToUser?.(profile);
			return {
				user: {
					id: profile.sub,
					name: name,
					emailVerified: false,
					email: profile.email,
					...userMap,
				},
				data: profile,
			};
		},
		options,
	} satisfies OAuthProvider<AppleProfile>;
};

export const getApplePublicKey = async (kid: string) => {
	const APPLE_BASE_URL = "https://appleid.apple.com";
	const JWKS_APPLE_URI = "/auth/keys";
	const { data } = await betterFetch<{
		keys: Array<{
			kid: string;
			alg: string;
			kty: string;
			use: string;
			n: string;
			e: string;
		}>;
	}>(`${APPLE_BASE_URL}${JWKS_APPLE_URI}`);
	if (!data?.keys) {
		throw new APIError("BAD_REQUEST", {
			message: "Keys not found",
		});
	}
	const jwk = data.keys.find((key) => key.kid === kid);
	if (!jwk) {
		throw new Error(`JWK with kid ${kid} not found`);
	}
	return await importJWK(jwk, jwk.alg);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/discord.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import type { OAuthProvider, ProviderOptions } from "../oauth2";
import { validateAuthorizationCode, refreshAccessToken } from "../oauth2";
export interface DiscordProfile extends Record<string, any> {
	/** the user's id (i.e. the numerical snowflake) */
	id: string;
	/** the user's username, not unique across the platform */
	username: string;
	/** the user's Discord-tag */
	discriminator: string;
	/** the user's display name, if it is set  */
	global_name: string | null;
	/**
	 * the user's avatar hash:
	 * https://discord.com/developers/docs/reference#image-formatting
	 */
	avatar: string | null;
	/** whether the user belongs to an OAuth2 application */
	bot?: boolean;
	/**
	 * whether the user is an Official Discord System user (part of the urgent
	 * message system)
	 */
	system?: boolean;
	/** whether the user has two factor enabled on their account */
	mfa_enabled: boolean;
	/**
	 * the user's banner hash:
	 * https://discord.com/developers/docs/reference#image-formatting
	 */
	banner: string | null;

	/** the user's banner color encoded as an integer representation of hexadecimal color code */
	accent_color: number | null;

	/**
	 * the user's chosen language option:
	 * https://discord.com/developers/docs/reference#locales
	 */
	locale: string;
	/** whether the email on this account has been verified */
	verified: boolean;
	/** the user's email */
	email: string;
	/**
	 * the flags on a user's account:
	 * https://discord.com/developers/docs/resources/user#user-object-user-flags
	 */
	flags: number;
	/**
	 * the type of Nitro subscription on a user's account:
	 * https://discord.com/developers/docs/resources/user#user-object-premium-types
	 */
	premium_type: number;
	/**
	 * the public flags on a user's account:
	 * https://discord.com/developers/docs/resources/user#user-object-user-flags
	 */
	public_flags: number;
	/** undocumented field; corresponds to the user's custom nickname */
	display_name: string | null;
	/**
	 * undocumented field; corresponds to the Discord feature where you can e.g.
	 * put your avatar inside of an ice cube
	 */
	avatar_decoration: string | null;
	/**
	 * undocumented field; corresponds to the premium feature where you can
	 * select a custom banner color
	 */
	banner_color: string | null;
	/** undocumented field; the CDN URL of their profile picture */
	image_url: string;
}

export interface DiscordOptions extends ProviderOptions<DiscordProfile> {
	prompt?: "none" | "consent";
}

export const discord = (options: DiscordOptions) => {
	return {
		id: "discord",
		name: "Discord",
		createAuthorizationURL({ state, scopes, redirectURI }) {
			const _scopes = options.disableDefaultScope ? [] : ["identify", "email"];
			scopes && _scopes.push(...scopes);
			options.scope && _scopes.push(...options.scope);
			return new URL(
				`https://discord.com/api/oauth2/authorize?scope=${_scopes.join(
					"+",
				)}&response_type=code&client_id=${
					options.clientId
				}&redirect_uri=${encodeURIComponent(
					options.redirectURI || redirectURI,
				)}&state=${state}&prompt=${options.prompt || "none"}`,
			);
		},
		validateAuthorizationCode: async ({ code, redirectURI }) => {
			return validateAuthorizationCode({
				code,
				redirectURI,
				options,
				tokenEndpoint: "https://discord.com/api/oauth2/token",
			});
		},
		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint: "https://discord.com/api/oauth2/token",
					});
				},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}
			const { data: profile, error } = await betterFetch<DiscordProfile>(
				"https://discord.com/api/users/@me",
				{
					headers: {
						authorization: `Bearer ${token.accessToken}`,
					},
				},
			);

			if (error) {
				return null;
			}
			if (profile.avatar === null) {
				const defaultAvatarNumber =
					profile.discriminator === "0"
						? Number(BigInt(profile.id) >> BigInt(22)) % 6
						: parseInt(profile.discriminator) % 5;
				profile.image_url = `https://cdn.discordapp.com/embed/avatars/${defaultAvatarNumber}.png`;
			} else {
				const format = profile.avatar.startsWith("a_") ? "gif" : "png";
				profile.image_url = `https://cdn.discordapp.com/avatars/${profile.id}/${profile.avatar}.${format}`;
			}
			const userMap = await options.mapProfileToUser?.(profile);
			return {
				user: {
					id: profile.id,
					name: profile.global_name || profile.username || "",
					email: profile.email,
					emailVerified: profile.verified,
					image: profile.image_url,
					...userMap,
				},
				data: profile,
			};
		},
		options,
	} satisfies OAuthProvider<DiscordProfile>;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/dropbox.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import type { OAuthProvider, ProviderOptions } from "../oauth2";
import {
	createAuthorizationURL,
	refreshAccessToken,
	validateAuthorizationCode,
} from "../oauth2";

export interface DropboxProfile {
	account_id: string;
	name: {
		given_name: string;
		surname: string;
		familiar_name: string;
		display_name: string;
		abbreviated_name: string;
	};
	email: string;
	email_verified: boolean;
	profile_photo_url: string;
}

export interface DropboxOptions extends ProviderOptions<DropboxProfile> {}

export const dropbox = (options: DropboxOptions) => {
	const tokenEndpoint = "https://api.dropboxapi.com/oauth2/token";

	return {
		id: "dropbox",
		name: "Dropbox",
		createAuthorizationURL: async ({
			state,
			scopes,
			codeVerifier,
			redirectURI,
		}) => {
			const _scopes = options.disableDefaultScope ? [] : ["account_info.read"];
			options.scope && _scopes.push(...options.scope);
			scopes && _scopes.push(...scopes);
			return await createAuthorizationURL({
				id: "dropbox",
				options,
				authorizationEndpoint: "https://www.dropbox.com/oauth2/authorize",
				scopes: _scopes,
				state,
				redirectURI,
				codeVerifier,
			});
		},
		validateAuthorizationCode: async ({ code, codeVerifier, redirectURI }) => {
			return await validateAuthorizationCode({
				code,
				codeVerifier,
				redirectURI,
				options,
				tokenEndpoint,
			});
		},
		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint: "https://api.dropbox.com/oauth2/token",
					});
				},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}
			const { data: profile, error } = await betterFetch<DropboxProfile>(
				"https://api.dropboxapi.com/2/users/get_current_account",
				{
					method: "POST",
					headers: {
						Authorization: `Bearer ${token.accessToken}`,
					},
				},
			);

			if (error) {
				return null;
			}
			const userMap = await options.mapProfileToUser?.(profile);
			return {
				user: {
					id: profile.account_id,
					name: profile.name?.display_name,
					email: profile.email,
					emailVerified: profile.email_verified || false,
					image: profile.profile_photo_url,
					...userMap,
				},
				data: profile,
			};
		},
		options,
	} satisfies OAuthProvider<DropboxProfile>;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/facebook.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import type { OAuthProvider, ProviderOptions } from "../oauth2";
import { createAuthorizationURL, validateAuthorizationCode } from "../oauth2";
import { createRemoteJWKSet, jwtVerify, decodeJwt } from "jose";
import { refreshAccessToken } from "../oauth2";
export interface FacebookProfile {
	id: string;
	name: string;
	email: string;
	email_verified: boolean;
	picture: {
		data: {
			height: number;
			is_silhouette: boolean;
			url: string;
			width: number;
		};
	};
}

export interface FacebookOptions extends ProviderOptions<FacebookProfile> {
	/**
	 * Extend list of fields to retrieve from the Facebook user profile.
	 *
	 * @default ["id", "name", "email", "picture"]
	 */
	fields?: string[];
}

export const facebook = (options: FacebookOptions) => {
	return {
		id: "facebook",
		name: "Facebook",
		async createAuthorizationURL({ state, scopes, redirectURI, loginHint }) {
			const _scopes = options.disableDefaultScope
				? []
				: ["email", "public_profile"];
			options.scope && _scopes.push(...options.scope);
			scopes && _scopes.push(...scopes);
			return await createAuthorizationURL({
				id: "facebook",
				options,
				authorizationEndpoint: "https://www.facebook.com/v21.0/dialog/oauth",
				scopes: _scopes,
				state,
				redirectURI,
				loginHint,
			});
		},
		validateAuthorizationCode: async ({ code, redirectURI }) => {
			return validateAuthorizationCode({
				code,
				redirectURI,
				options,
				tokenEndpoint: "https://graph.facebook.com/oauth/access_token",
			});
		},
		async verifyIdToken(token, nonce) {
			if (options.disableIdTokenSignIn) {
				return false;
			}

			if (options.verifyIdToken) {
				return options.verifyIdToken(token, nonce);
			}

			/* limited login */
			// check is limited token
			if (token.split(".").length) {
				try {
					const { payload: jwtClaims } = await jwtVerify(
						token,
						createRemoteJWKSet(
							new URL("https://www.facebook.com/.well-known/oauth/openid/jwks"),
						),
						{
							algorithms: ["RS256"],
							audience: options.clientId,
							issuer: "https://www.facebook.com",
						},
					);

					if (nonce && jwtClaims.nonce !== nonce) {
						return false;
					}

					return !!jwtClaims;
				} catch (error) {
					return false;
				}
			}

			/* access_token */
			return true;
		},
		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint:
							"https://graph.facebook.com/v18.0/oauth/access_token",
					});
				},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}

			if (token.idToken) {
				const profile = decodeJwt(token.idToken) as {
					sub: string;
					email: string;
					name: string;
					picture: string;
				};

				const user = {
					id: profile.sub,
					name: profile.name,
					email: profile.email,
					picture: {
						data: {
							url: profile.picture,
							height: 100,
							width: 100,
							is_silhouette: false,
						},
					},
				};

				// https://developers.facebook.com/docs/facebook-login/limited-login/permissions
				const userMap = await options.mapProfileToUser?.({
					...user,
					email_verified: true,
				});

				return {
					user: {
						...user,
						emailVerified: true,
						...userMap,
					},
					data: profile,
				};
			}

			const fields = [
				"id",
				"name",
				"email",
				"picture",
				...(options?.fields || []),
			];
			const { data: profile, error } = await betterFetch<FacebookProfile>(
				"https://graph.facebook.com/me?fields=" + fields.join(","),
				{
					auth: {
						type: "Bearer",
						token: token.accessToken,
					},
				},
			);
			if (error) {
				return null;
			}
			const userMap = await options.mapProfileToUser?.(profile);
			return {
				user: {
					id: profile.id,
					name: profile.name,
					email: profile.email,
					image: profile.picture.data.url,
					emailVerified: profile.email_verified,
					...userMap,
				},
				data: profile,
			};
		},
		options,
	} satisfies OAuthProvider<FacebookProfile>;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/github.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import type { OAuthProvider, ProviderOptions } from "../oauth2";
import {
	createAuthorizationURL,
	refreshAccessToken,
	validateAuthorizationCode,
} from "../oauth2";

export interface GithubProfile {
	login: string;
	id: string;
	node_id: string;
	avatar_url: string;
	gravatar_id: string;
	url: string;
	html_url: string;
	followers_url: string;
	following_url: string;
	gists_url: string;
	starred_url: string;
	subscriptions_url: string;
	organizations_url: string;
	repos_url: string;
	events_url: string;
	received_events_url: string;
	type: string;
	site_admin: boolean;
	name: string;
	company: string;
	blog: string;
	location: string;
	email: string;
	hireable: boolean;
	bio: string;
	twitter_username: string;
	public_repos: string;
	public_gists: string;
	followers: string;
	following: string;
	created_at: string;
	updated_at: string;
	private_gists: string;
	total_private_repos: string;
	owned_private_repos: string;
	disk_usage: string;
	collaborators: string;
	two_factor_authentication: boolean;
	plan: {
		name: string;
		space: string;
		private_repos: string;
		collaborators: string;
	};
}

export interface GithubOptions extends ProviderOptions<GithubProfile> {}
export const github = (options: GithubOptions) => {
	const tokenEndpoint = "https://github.com/login/oauth/access_token";
	return {
		id: "github",
		name: "GitHub",
		createAuthorizationURL({ state, scopes, loginHint, redirectURI }) {
			const _scopes = options.disableDefaultScope
				? []
				: ["read:user", "user:email"];
			options.scope && _scopes.push(...options.scope);
			scopes && _scopes.push(...scopes);
			return createAuthorizationURL({
				id: "github",
				options,
				authorizationEndpoint: "https://github.com/login/oauth/authorize",
				scopes: _scopes,
				state,
				redirectURI,
				loginHint,
			});
		},
		validateAuthorizationCode: async ({ code, redirectURI }) => {
			return validateAuthorizationCode({
				code,
				redirectURI,
				options,
				tokenEndpoint,
			});
		},
		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint: "https://github.com/login/oauth/token",
					});
				},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}
			const { data: profile, error } = await betterFetch<GithubProfile>(
				"https://api.github.com/user",
				{
					headers: {
						"User-Agent": "better-auth",
						authorization: `Bearer ${token.accessToken}`,
					},
				},
			);
			if (error) {
				return null;
			}
			const { data: emails } = await betterFetch<
				{
					email: string;
					primary: boolean;
					verified: boolean;
					visibility: "public" | "private";
				}[]
			>("https://api.github.com/user/emails", {
				headers: {
					Authorization: `Bearer ${token.accessToken}`,
					"User-Agent": "better-auth",
				},
			});

			if (!profile.email && emails) {
				profile.email = (emails.find((e) => e.primary) ?? emails[0])
					?.email as string;
			}
			const emailVerified =
				emails?.find((e) => e.email === profile.email)?.verified ?? false;

			const userMap = await options.mapProfileToUser?.(profile);
			return {
				user: {
					id: profile.id.toString(),
					name: profile.name || profile.login,
					email: profile.email,
					image: profile.avatar_url,
					emailVerified,
					...userMap,
				},
				data: profile,
			};
		},
		options,
	} satisfies OAuthProvider<GithubProfile>;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/gitlab.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import type { OAuthProvider, ProviderOptions } from "../oauth2";
import {
	createAuthorizationURL,
	validateAuthorizationCode,
	refreshAccessToken,
} from "../oauth2";

export interface GitlabProfile extends Record<string, any> {
	id: number;
	username: string;
	email: string;
	name: string;
	state: string;
	avatar_url: string;
	web_url: string;
	created_at: string;
	bio: string;
	location?: string;
	public_email: string;
	skype: string;
	linkedin: string;
	twitter: string;
	website_url: string;
	organization: string;
	job_title: string;
	pronouns: string;
	bot: boolean;
	work_information?: string;
	followers: number;
	following: number;
	local_time: string;
	last_sign_in_at: string;
	confirmed_at: string;
	theme_id: number;
	last_activity_on: string;
	color_scheme_id: number;
	projects_limit: number;
	current_sign_in_at: string;
	identities: Array<{
		provider: string;
		extern_uid: string;
	}>;
	can_create_group: boolean;
	can_create_project: boolean;
	two_factor_enabled: boolean;
	external: boolean;
	private_profile: boolean;
	commit_email: string;
	shared_runners_minutes_limit: number;
	extra_shared_runners_minutes_limit: number;
}

export interface GitlabOptions extends ProviderOptions<GitlabProfile> {
	issuer?: string;
}

const cleanDoubleSlashes = (input: string = "") => {
	return input
		.split("://")
		.map((str) => str.replace(/\/{2,}/g, "/"))
		.join("://");
};

const issuerToEndpoints = (issuer?: string) => {
	let baseUrl = issuer || "https://gitlab.com";
	return {
		authorizationEndpoint: cleanDoubleSlashes(`${baseUrl}/oauth/authorize`),
		tokenEndpoint: cleanDoubleSlashes(`${baseUrl}/oauth/token`),
		userinfoEndpoint: cleanDoubleSlashes(`${baseUrl}/api/v4/user`),
	};
};

export const gitlab = (options: GitlabOptions) => {
	const { authorizationEndpoint, tokenEndpoint, userinfoEndpoint } =
		issuerToEndpoints(options.issuer);
	const issuerId = "gitlab";
	const issuerName = "Gitlab";
	return {
		id: issuerId,
		name: issuerName,
		createAuthorizationURL: async ({
			state,
			scopes,
			codeVerifier,
			loginHint,
			redirectURI,
		}) => {
			const _scopes = options.disableDefaultScope ? [] : ["read_user"];
			options.scope && _scopes.push(...options.scope);
			scopes && _scopes.push(...scopes);
			return await createAuthorizationURL({
				id: issuerId,
				options,
				authorizationEndpoint,
				scopes: _scopes,
				state,
				redirectURI,
				codeVerifier,
				loginHint,
			});
		},
		validateAuthorizationCode: async ({ code, redirectURI, codeVerifier }) => {
			return validateAuthorizationCode({
				code,
				redirectURI,
				options,
				codeVerifier,
				tokenEndpoint,
			});
		},
		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint: "https://gitlab.com/oauth/token",
					});
				},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}
			const { data: profile, error } = await betterFetch<GitlabProfile>(
				userinfoEndpoint,
				{ headers: { authorization: `Bearer ${token.accessToken}` } },
			);
			if (error || profile.state !== "active" || profile.locked) {
				return null;
			}
			const userMap = await options.mapProfileToUser?.(profile);
			return {
				user: {
					id: profile.id.toString(),
					name: profile.name ?? profile.username,
					email: profile.email,
					image: profile.avatar_url,
					emailVerified: true,
					...userMap,
				},
				data: profile,
			};
		},
		options,
	} satisfies OAuthProvider<GitlabProfile>;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/google.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import { decodeJwt } from "jose";
import { BetterAuthError } from "../error";
import type { OAuthProvider, ProviderOptions } from "../oauth2";
import { createAuthorizationURL, validateAuthorizationCode } from "../oauth2";
import { logger } from "../utils/logger";
import { refreshAccessToken } from "../oauth2/refresh-access-token";

export interface GoogleProfile {
	aud: string;
	azp: string;
	email: string;
	email_verified: boolean;
	exp: number;
	/**
	 * The family name of the user, or last name in most
	 * Western languages.
	 */
	family_name: string;
	/**
	 * The given name of the user, or first name in most
	 * Western languages.
	 */
	given_name: string;
	hd?: string;
	iat: number;
	iss: string;
	jti?: string;
	locale?: string;
	name: string;
	nbf?: number;
	picture: string;
	sub: string;
}

export interface GoogleOptions extends ProviderOptions<GoogleProfile> {
	/**
	 * The access type to use for the authorization code request
	 */
	accessType?: "offline" | "online";
	/**
	 * The display mode to use for the authorization code request
	 */
	display?: "page" | "popup" | "touch" | "wap";
	/**
	 * The hosted domain of the user
	 */
	hd?: string;
}

export const google = (options: GoogleOptions) => {
	return {
		id: "google",
		name: "Google",
		async createAuthorizationURL({
			state,
			scopes,
			codeVerifier,
			redirectURI,
			loginHint,
			display,
		}) {
			if (!options.clientId || !options.clientSecret) {
				logger.error(
					"Client Id and Client Secret is required for Google. Make sure to provide them in the options.",
				);
				throw new BetterAuthError("CLIENT_ID_AND_SECRET_REQUIRED");
			}
			if (!codeVerifier) {
				throw new BetterAuthError("codeVerifier is required for Google");
			}
			const _scopes = options.disableDefaultScope
				? []
				: ["email", "profile", "openid"];
			options.scope && _scopes.push(...options.scope);
			scopes && _scopes.push(...scopes);
			const url = await createAuthorizationURL({
				id: "google",
				options,
				authorizationEndpoint: "https://accounts.google.com/o/oauth2/auth",
				scopes: _scopes,
				state,
				codeVerifier,
				redirectURI,
				prompt: options.prompt,
				accessType: options.accessType,
				display: display || options.display,
				loginHint,
				hd: options.hd,
			});
			return url;
		},
		validateAuthorizationCode: async ({ code, codeVerifier, redirectURI }) => {
			return validateAuthorizationCode({
				code,
				codeVerifier,
				redirectURI,
				options,
				tokenEndpoint: "https://oauth2.googleapis.com/token",
			});
		},
		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint: "https://www.googleapis.com/oauth2/v4/token",
					});
				},
		async verifyIdToken(token, nonce) {
			if (options.disableIdTokenSignIn) {
				return false;
			}
			if (options.verifyIdToken) {
				return options.verifyIdToken(token, nonce);
			}
			const googlePublicKeyUrl = `https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=${token}`;
			const { data: tokenInfo } = await betterFetch<{
				aud: string;
				iss: string;
				email: string;
				email_verified: boolean;
				name: string;
				picture: string;
				sub: string;
			}>(googlePublicKeyUrl);
			if (!tokenInfo) {
				return false;
			}
			const isValid =
				tokenInfo.aud === options.clientId &&
				(tokenInfo.iss === "https://accounts.google.com" ||
					tokenInfo.iss === "accounts.google.com");
			return isValid;
		},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}
			if (!token.idToken) {
				return null;
			}
			const user = decodeJwt(token.idToken) as GoogleProfile;
			const userMap = await options.mapProfileToUser?.(user);
			return {
				user: {
					id: user.sub,
					name: user.name,
					email: user.email,
					image: user.picture,
					emailVerified: user.email_verified,
					...userMap,
				},
				data: user,
			};
		},
		options,
	} satisfies OAuthProvider<GoogleProfile>;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/index.ts
```typescript
import type { Prettify } from "../types/helper";
import { apple } from "./apple";
import { discord } from "./discord";
import { facebook } from "./facebook";
import { github } from "./github";
import { google } from "./google";
import { microsoft } from "./microsoft-entra-id";
import { spotify } from "./spotify";
import { twitch } from "./twitch";
import { twitter } from "./twitter";
import { dropbox } from "./dropbox";
import { linkedin } from "./linkedin";
import { gitlab } from "./gitlab";
import { tiktok } from "./tiktok";
import { reddit } from "./reddit";
import { roblox } from "./roblox";
import { z } from "zod";
import { vk } from "./vk";
import { kick } from "./kick";
export const socialProviders = {
	apple,
	discord,
	facebook,
	github,
	microsoft,
	google,
	spotify,
	twitch,
	twitter,
	dropbox,
	kick,
	linkedin,
	gitlab,
	tiktok,
	reddit,
	roblox,
	vk,
};

export const socialProviderList = Object.keys(socialProviders) as [
	"github",
	...(keyof typeof socialProviders)[],
];

export const SocialProviderListEnum = z.enum(socialProviderList, {
	description: "OAuth2 provider to use",
});

export type SocialProvider = z.infer<typeof SocialProviderListEnum>;

export type SocialProviders = {
	[K in SocialProviderList[number]]?: Prettify<
		Parameters<(typeof socialProviders)[K]>[0] & {
			enabled?: boolean;
		}
	>;
};

export * from "./github";
export * from "./google";
export * from "./apple";
export * from "./microsoft-entra-id";
export * from "./discord";
export * from "./spotify";
export * from "./twitch";
export * from "./facebook";
export * from "./twitter";
export * from "./dropbox";
export * from "./linkedin";
export * from "./gitlab";
export * from "./tiktok";
export * from "./reddit";
export * from "./roblox";
export * from "./vk";
export * from "./kick";

export type SocialProviderList = typeof socialProviderList;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/kick.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import {
	createAuthorizationURL,
	type OAuthProvider,
	type ProviderOptions,
	validateAuthorizationCode,
} from "../oauth2";

export interface KickProfile {
	/**
	 * The user id of the user
	 */
	user_id: string;
	/**
	 * The name of the user
	 */
	name: string;
	/**
	 * The email of the user
	 */
	email: string;
	/**
	 * The picture of the user
	 */
	profile_picture: string;
}

export interface KickOptions extends ProviderOptions<KickProfile> {}

export const kick = (options: KickOptions) => {
	return {
		id: "kick",
		name: "Kick",
		createAuthorizationURL({ state, scopes, redirectURI, codeVerifier }) {
			const _scopes = options.disableDefaultScope ? [] : ["user:read"];
			options.scope && _scopes.push(...options.scope);
			scopes && _scopes.push(...scopes);

			return createAuthorizationURL({
				id: "kick",
				redirectURI,
				options,
				authorizationEndpoint: "https://id.kick.com/oauth/authorize",
				scopes: _scopes,
				codeVerifier,
				state,
			});
		},
		async validateAuthorizationCode({ code, redirectURI, codeVerifier }) {
			return validateAuthorizationCode({
				code,
				redirectURI,
				options,
				tokenEndpoint: "https://id.kick.com/oauth/token",
				codeVerifier,
			});
		},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}

			const { data, error } = await betterFetch<{
				data: KickProfile[];
			}>("https://api.kick.com/public/v1/users", {
				method: "GET",
				headers: {
					Authorization: `Bearer ${token.accessToken}`,
				},
			});

			if (error) {
				return null;
			}

			const profile = data.data[0];

			const userMap = await options.mapProfileToUser?.(profile);

			return {
				user: {
					id: profile.user_id,
					name: profile.name,
					email: profile.email,
					image: profile.profile_picture,
					emailVerified: true,
					...userMap,
				},
				data: profile,
			};
		},
		options,
	} satisfies OAuthProvider<KickProfile>;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/linkedin.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import type { OAuthProvider, ProviderOptions } from "../oauth2";
import {
	createAuthorizationURL,
	validateAuthorizationCode,
	refreshAccessToken,
} from "../oauth2";

export interface LinkedInProfile {
	sub: string;
	name: string;
	given_name: string;
	family_name: string;
	picture: string;
	locale: {
		country: string;
		language: string;
	};
	email: string;
	email_verified: boolean;
}

export interface LinkedInOptions extends ProviderOptions<LinkedInProfile> {}

export const linkedin = (options: LinkedInOptions) => {
	const authorizationEndpoint =
		"https://www.linkedin.com/oauth/v2/authorization";
	const tokenEndpoint = "https://www.linkedin.com/oauth/v2/accessToken";

	return {
		id: "linkedin",
		name: "Linkedin",
		createAuthorizationURL: async ({
			state,
			scopes,
			redirectURI,
			loginHint,
		}) => {
			const _scopes = options.disableDefaultScope
				? []
				: ["profile", "email", "openid"];
			options.scope && _scopes.push(...options.scope);
			scopes && _scopes.push(...scopes);
			return await createAuthorizationURL({
				id: "linkedin",
				options,
				authorizationEndpoint,
				scopes: _scopes,
				state,
				loginHint,
				redirectURI,
			});
		},
		validateAuthorizationCode: async ({ code, redirectURI }) => {
			return await validateAuthorizationCode({
				code,
				redirectURI,
				options,
				tokenEndpoint,
			});
		},
		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint,
					});
				},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}
			const { data: profile, error } = await betterFetch<LinkedInProfile>(
				"https://api.linkedin.com/v2/userinfo",
				{
					method: "GET",
					headers: {
						Authorization: `Bearer ${token.accessToken}`,
					},
				},
			);

			if (error) {
				return null;
			}

			const userMap = await options.mapProfileToUser?.(profile);
			return {
				user: {
					id: profile.sub,
					name: profile.name,
					email: profile.email,
					emailVerified: profile.email_verified || false,
					image: profile.picture,
					...userMap,
				},
				data: profile,
			};
		},
		options,
	} satisfies OAuthProvider<LinkedInProfile>;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/microsoft-entra-id.ts
```typescript
import type { ProviderOptions } from "../oauth2";
import { validateAuthorizationCode, createAuthorizationURL } from "../oauth2";
import type { OAuthProvider } from "../oauth2";
import { betterFetch } from "@better-fetch/fetch";
import { logger } from "../utils/logger";
import { decodeJwt } from "jose";
import { base64 } from "@better-auth/utils/base64";

export interface MicrosoftEntraIDProfile extends Record<string, any> {
	sub: string;
	name: string;
	email: string;
	picture: string;
}

export interface MicrosoftOptions
	extends ProviderOptions<MicrosoftEntraIDProfile> {
	/**
	 * The tenant ID of the Microsoft account
	 * @default "common"
	 */
	tenantId?: string;
	/**
	 * The size of the profile photo
	 * @default 48
	 */
	profilePhotoSize?: 48 | 64 | 96 | 120 | 240 | 360 | 432 | 504 | 648;
	/**
	 * Disable profile photo
	 */
	disableProfilePhoto?: boolean;
}

export const microsoft = (options: MicrosoftOptions) => {
	const tenant = options.tenantId || "common";
	const authorizationEndpoint = `https://login.microsoftonline.com/${tenant}/oauth2/v2.0/authorize`;
	const tokenEndpoint = `https://login.microsoftonline.com/${tenant}/oauth2/v2.0/token`;
	return {
		id: "microsoft",
		name: "Microsoft EntraID",
		createAuthorizationURL(data) {
			const scopes = options.disableDefaultScope
				? []
				: ["openid", "profile", "email", "User.Read"];
			options.scope && scopes.push(...options.scope);
			data.scopes && scopes.push(...scopes);
			return createAuthorizationURL({
				id: "microsoft",
				options,
				authorizationEndpoint,
				state: data.state,
				codeVerifier: data.codeVerifier,
				scopes,
				redirectURI: data.redirectURI,
				prompt: options.prompt,
			});
		},
		validateAuthorizationCode({ code, codeVerifier, redirectURI }) {
			return validateAuthorizationCode({
				code,
				codeVerifier,
				redirectURI,
				options,
				tokenEndpoint,
			});
		},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}
			if (!token.idToken) {
				return null;
			}
			const user = decodeJwt(token.idToken) as MicrosoftEntraIDProfile;
			const profilePhotoSize = options.profilePhotoSize || 48;
			await betterFetch<ArrayBuffer>(
				`https://graph.microsoft.com/v1.0/me/photos/${profilePhotoSize}x${profilePhotoSize}/$value`,
				{
					headers: {
						Authorization: `Bearer ${token.accessToken}`,
					},
					async onResponse(context) {
						if (options.disableProfilePhoto || !context.response.ok) {
							return;
						}
						try {
							const response = context.response.clone();
							const pictureBuffer = await response.arrayBuffer();
							const pictureBase64 = base64.encode(pictureBuffer);
							user.picture = `data:image/jpeg;base64, ${pictureBase64}`;
						} catch (e) {
							logger.error(
								e && typeof e === "object" && "name" in e
									? (e.name as string)
									: "",
								e,
							);
						}
					},
				},
			);
			const userMap = await options.mapProfileToUser?.(user);
			return {
				user: {
					id: user.sub,
					name: user.name,
					email: user.email,
					image: user.picture,
					emailVerified: true,
					...userMap,
				},
				data: user,
			};
		},
		options,
	} satisfies OAuthProvider;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/reddit.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import type { OAuthProvider, ProviderOptions } from "../oauth2";
import {
	createAuthorizationURL,
	getOAuth2Tokens,
	refreshAccessToken,
} from "../oauth2";
import { base64 } from "@better-auth/utils/base64";

export interface RedditProfile {
	id: string;
	name: string;
	icon_img: string | null;
	has_verified_email: boolean;
	oauth_client_id: string;
	verified: boolean;
}

export interface RedditOptions extends ProviderOptions<RedditProfile> {
	duration?: string;
}

export const reddit = (options: RedditOptions) => {
	return {
		id: "reddit",
		name: "Reddit",
		createAuthorizationURL({ state, scopes, redirectURI }) {
			const _scopes = options.disableDefaultScope ? [] : ["identity"];
			options.scope && _scopes.push(...options.scope);
			scopes && _scopes.push(...scopes);
			return createAuthorizationURL({
				id: "reddit",
				options,
				authorizationEndpoint: "https://www.reddit.com/api/v1/authorize",
				scopes: _scopes,
				state,
				redirectURI,
				duration: options.duration,
			});
		},
		validateAuthorizationCode: async ({ code, redirectURI }) => {
			const body = new URLSearchParams({
				grant_type: "authorization_code",
				code,
				redirect_uri: options.redirectURI || redirectURI,
			});
			const headers = {
				"content-type": "application/x-www-form-urlencoded",
				accept: "text/plain",
				"user-agent": "better-auth",
				Authorization: `Basic ${base64.encode(
					`${options.clientId}:${options.clientSecret}`,
				)}`,
			};

			const { data, error } = await betterFetch<object>(
				"https://www.reddit.com/api/v1/access_token",
				{
					method: "POST",
					headers,
					body: body.toString(),
				},
			);

			if (error) {
				throw error;
			}

			return getOAuth2Tokens(data);
		},

		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint: "https://www.reddit.com/api/v1/access_token",
					});
				},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}

			const { data: profile, error } = await betterFetch<RedditProfile>(
				"https://oauth.reddit.com/api/v1/me",
				{
					headers: {
						Authorization: `Bearer ${token.accessToken}`,
						"User-Agent": "better-auth",
					},
				},
			);

			if (error) {
				return null;
			}

			const userMap = await options.mapProfileToUser?.(profile);

			return {
				user: {
					id: profile.id,
					name: profile.name,
					email: profile.oauth_client_id,
					emailVerified: profile.has_verified_email,
					image: profile.icon_img?.split("?")[0],
					...userMap,
				},
				data: profile,
			};
		},
		options,
	} satisfies OAuthProvider<RedditProfile>;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/roblox.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import type { OAuthProvider, ProviderOptions } from "../oauth2";
import { validateAuthorizationCode, refreshAccessToken } from "../oauth2";

export interface RobloxProfile extends Record<string, any> {
	/** the user's id */
	sub: string;
	/** the user's username */
	preferred_username: string;
	/** the user's display name, will return the same value as the preffered_username if not set */
	nickname: string;
	/** the user's display name, again, will return the same value as the preffered_username if not set */
	name: string;
	/** the account creation date as a unix timestamp in seconds */
	created_at: number;
	/** the user's profile url */
	profile: string;
	/** the user's avatar url */
	picture: string;
}

export interface RobloxOptions extends ProviderOptions<RobloxProfile> {
	prompt?:
		| "none"
		| "consent"
		| "login"
		| "select_account"
		| "select_account+consent";
}

export const roblox = (options: RobloxOptions) => {
	return {
		id: "roblox",
		name: "Roblox",
		createAuthorizationURL({ state, scopes, redirectURI }) {
			const _scopes = options.disableDefaultScope ? [] : ["openid", "profile"];
			options.scope && _scopes.push(...options.scope);
			scopes && _scopes.push(...scopes);
			return new URL(
				`https://apis.roblox.com/oauth/v1/authorize?scope=${_scopes.join(
					"+",
				)}&response_type=code&client_id=${
					options.clientId
				}&redirect_uri=${encodeURIComponent(
					options.redirectURI || redirectURI,
				)}&state=${state}&prompt=${options.prompt || "select_account+consent"}`,
			);
		},
		validateAuthorizationCode: async ({ code, redirectURI }) => {
			return validateAuthorizationCode({
				code,
				redirectURI: options.redirectURI || redirectURI,
				options,
				tokenEndpoint: "https://apis.roblox.com/oauth/v1/token",
				authentication: "post",
			});
		},

		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint: "https://apis.roblox.com/oauth/v1/token",
					});
				},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}
			const { data: profile, error } = await betterFetch<RobloxProfile>(
				"https://apis.roblox.com/oauth/v1/userinfo",
				{
					headers: {
						authorization: `Bearer ${token.accessToken}`,
					},
				},
			);

			if (error) {
				return null;
			}

			const userMap = await options.mapProfileToUser?.(profile);

			return {
				user: {
					id: profile.sub,
					name: profile.nickname || profile.preferred_username || "",
					image: profile.picture,
					email: profile.preferred_username || null, // Roblox does not provide email
					emailVerified: true,
					...userMap,
				},
				data: {
					...profile,
				},
			};
		},
		options,
	} satisfies OAuthProvider<RobloxProfile>;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/social.test.ts
```typescript
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { getTestInstance } from "../test-utils/test-instance";
import { DEFAULT_SECRET } from "../utils/constants";
import type { GoogleProfile } from "./google";
import { parseSetCookieHeader } from "../cookies";
import { getOAuth2Tokens, refreshAccessToken } from "../oauth2";
import { signJWT } from "../crypto/jwt";
import { OAuth2Server } from "oauth2-mock-server";
import { betterFetch } from "@better-fetch/fetch";

let server = new OAuth2Server();

vi.mock("../oauth2", async (importOriginal) => {
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
		refreshAccessToken: vi.fn().mockImplementation(async (args) => {
			const { refreshToken, options, tokenEndpoint } = args;
			expect(refreshToken).toBeDefined();
			expect(options.clientId).toBe("test-client-id");
			expect(options.clientSecret).toBe("test-client-secret");
			expect(tokenEndpoint).toBe("http://localhost:8080/token");

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
				access_token: "new-access-token",
				refresh_token: "new-refresh-token",
				id_token: testIdToken,
				token_type: "Bearer",
				expires_in: 3600, // Token expires in 1 hour
			});
			return tokens;
		}),
	};
});

describe("Social Providers", async (c) => {
	const { auth, customFetchImpl, client, cookieSetter } = await getTestInstance(
		{
			user: {
				additionalFields: {
					firstName: {
						type: "string",
					},
					lastName: {
						type: "string",
					},
					isOAuth: {
						type: "boolean",
					},
				},
			},
			socialProviders: {
				google: {
					clientId: "test",
					clientSecret: "test",
					enabled: true,
					mapProfileToUser(profile) {
						return {
							firstName: profile.given_name,
							lastName: profile.family_name,
							isOAuth: true,
						};
					},
				},
				apple: {
					clientId: "test",
					clientSecret: "test",
				},
			},
		},
		{
			disableTestUser: true,
		},
	);

	beforeAll(async () => {
		await server.issuer.keys.generate("RS256");
		server.issuer.on;
		await server.start(8080, "localhost");
		console.log("Issuer URL:", server.issuer.url); // -> http://localhost:8080
	});
	afterAll(async () => {
		await server.stop().catch(console.error);
	});
	server.service.on("beforeRsponse", (tokenResponse, req) => {
		tokenResponse.body = {
			accessToken: "access-token",
			refreshToken: "refresher-token",
		};
		tokenResponse.statusCode = 200;
	});
	server.service.on("beforeUserinfo", (userInfoResponse, req) => {
		userInfoResponse.body = {
			email: "test@localhost.com",
			name: "OAuth2 Test",
			sub: "oauth2",
			picture: "https://test.com/picture.png",
			email_verified: true,
		};
		userInfoResponse.statusCode = 200;
	});

	server.service.on("beforeTokenSigning", (token, req) => {
		token.payload.email = "sso-user@localhost:8000.com";
		token.payload.email_verified = true;
		token.payload.name = "Test User";
		token.payload.picture = "https://test.com/picture.png";
	});
	let state = "";

	const headers = new Headers();
	describe("signin", async () => {
		async function simulateOAuthFlowRefresh(
			authUrl: string,
			headers: Headers,
			fetchImpl?: (...args: any) => any,
		) {
			let location: string | null = null;
			await betterFetch(authUrl, {
				method: "GET",
				redirect: "manual",
				onError(context) {
					location = context.response.headers.get("location");
				},
			});
			if (!location) throw new Error("No redirect location found");

			const tokens = await refreshAccessToken({
				refreshToken: "mock-refresh-token",
				options: {
					clientId: "test-client-id",
					clientKey: "test-client-key",
					clientSecret: "test-client-secret",
				},
				tokenEndpoint: "http://localhost:8080/token",
			});
			return tokens;
		}
		it("should be able to add social providers", async () => {
			const signInRes = await client.signIn.social({
				provider: "google",
				callbackURL: "/callback",
				newUserCallbackURL: "/welcome",
			});
			expect(signInRes.data).toMatchObject({
				url: expect.stringContaining("google.com"),
				redirect: true,
			});
			state = new URL(signInRes.data!.url!).searchParams.get("state") || "";
		});

		it("should be able to sign in with social providers", async () => {
			await client.$fetch("/callback/google", {
				query: {
					state,
					code: "test",
				},
				method: "GET",
				onError(context) {
					expect(context.response.status).toBe(302);
					const location = context.response.headers.get("location");
					expect(location).toBeDefined();
					expect(location).toContain("/welcome");
					const cookies = parseSetCookieHeader(
						context.response.headers.get("set-cookie") || "",
					);
					expect(cookies.get("better-auth.session_token")?.value).toBeDefined();
				},
			});
		});

		it("should use callback url if the user is already registered", async () => {
			const signInRes = await client.signIn.social({
				provider: "google",
				callbackURL: "/callback",
				newUserCallbackURL: "/welcome",
			});
			expect(signInRes.data).toMatchObject({
				url: expect.stringContaining("google.com"),
				redirect: true,
			});
			state = new URL(signInRes.data!.url!).searchParams.get("state") || "";

			await client.$fetch("/callback/google", {
				query: {
					state,
					code: "test",
				},
				method: "GET",
				onError(context) {
					expect(context.response.status).toBe(302);
					const location = context.response.headers.get("location");
					expect(location).toBeDefined();
					expect(location).toContain("/callback");
					const cookies = parseSetCookieHeader(
						context.response.headers.get("set-cookie") || "",
					);
					expect(cookies.get("better-auth.session_token")?.value).toBeDefined();
				},
			});
		});

		it("should be able to map profile to user", async () => {
			const signInRes = await client.signIn.social({
				provider: "google",
				callbackURL: "/callback",
			});
			expect(signInRes.data).toMatchObject({
				url: expect.stringContaining("google.com"),
				redirect: true,
			});
			state = new URL(signInRes.data!.url!).searchParams.get("state") || "";

			const headers = new Headers();

			const profile = await client.$fetch("/callback/google", {
				query: {
					state,
					code: "test",
				},
				method: "GET",
				onError: (c) => {
					//TODO: fix this
					cookieSetter(headers)(c as any);
				},
			});
			const session = await client.getSession({
				fetchOptions: {
					headers,
				},
			});
			expect(session.data?.user).toMatchObject({
				isOAuth: true,
				firstName: "First",
				lastName: "Last",
			});
		});

		it("should be protected from callback URL attacks", async () => {
			const signInRes = await client.signIn.social(
				{
					provider: "google",
					callbackURL: "https://evil.com/callback",
				},
				{
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

			expect(signInRes.error?.status).toBe(403);
			expect(signInRes.error?.message).toBe("Invalid callbackURL");
		});

		it("should refresh the access token", async () => {
			const signInRes = await client.signIn.social({
				provider: "google",
				callbackURL: "/callback",
				newUserCallbackURL: "/welcome",
			});
			const headers = new Headers();
			expect(signInRes.data).toMatchObject({
				url: expect.stringContaining("google.com"),
				redirect: true,
			});
			state = new URL(signInRes.data!.url!).searchParams.get("state") || "";
			await client.$fetch("/callback/google", {
				query: {
					state,
					code: "test",
				},
				method: "GET",
				onError(context) {
					expect(context.response.status).toBe(302);
					const location = context.response.headers.get("location");
					expect(location).toBeDefined();
					expect(location).toContain("/callback");
					const cookies = parseSetCookieHeader(
						context.response.headers.get("set-cookie") || "",
					);
					cookieSetter(headers)(context as any);
					expect(cookies.get("better-auth.session_token")?.value).toBeDefined();
				},
			});
			const accounts = await client.listAccounts({
				fetchOptions: { headers },
			});
			await client.$fetch("/refresh-token", {
				body: {
					accountId: "test-id",
					providerId: "google",
				},
				headers,
				method: "POST",
				onError(context) {
					cookieSetter(headers)(context as any);
				},
			});

			const authUrl = signInRes.data.url;
			const mockEndpoint = authUrl.replace(
				"https://accounts.google.com/o/oauth2/auth",
				"http://localhost:8080/authorize",
			);
			const result = await simulateOAuthFlowRefresh(mockEndpoint, headers);
			const { accessToken, refreshToken } = result;
			expect({ accessToken, refreshToken }).toEqual({
				accessToken: "new-access-token",
				refreshToken: "new-refresh-token",
			});
		});
	});
});
describe("Redirect URI", async () => {
	it("should infer redirect uri", async () => {
		const { client } = await getTestInstance({
			basePath: "/custom/path",
			socialProviders: {
				google: {
					clientId: "test",
					clientSecret: "test",
					enabled: true,
				},
			},
		});

		await client.signIn.social(
			{
				provider: "google",
				callbackURL: "/callback",
			},
			{
				onSuccess(context) {
					const redirectURI = context.data.url;
					expect(redirectURI).toContain(
						"http%3A%2F%2Flocalhost%3A3000%2Fcustom%2Fpath%2Fcallback%2Fgoogle",
					);
				},
			},
		);
	});

	it("should respect custom redirect uri", async () => {
		const { auth, customFetchImpl, client } = await getTestInstance({
			socialProviders: {
				google: {
					clientId: "test",
					clientSecret: "test",
					enabled: true,
					redirectURI: "https://test.com/callback",
				},
			},
		});

		await client.signIn.social(
			{
				provider: "google",
				callbackURL: "/callback",
			},
			{
				onSuccess(context) {
					const redirectURI = context.data.url;
					expect(redirectURI).toContain(
						"redirect_uri=https%3A%2F%2Ftest.com%2Fcallback",
					);
				},
			},
		);
	});
});

describe("Disable implicit signup", async () => {
	it("Should not create user when implicit sign up is disabled", async () => {
		const { client } = await getTestInstance({
			socialProviders: {
				google: {
					clientId: "test",
					clientSecret: "test",
					enabled: true,
					disableImplicitSignUp: true,
				},
			},
		});

		const signInRes = await client.signIn.social({
			provider: "google",
			callbackURL: "/callback",
			newUserCallbackURL: "/welcome",
		});
		expect(signInRes.data).toMatchObject({
			url: expect.stringContaining("google.com"),
			redirect: true,
		});
		const state = new URL(signInRes.data!.url!).searchParams.get("state") || "";

		await client.$fetch("/callback/google", {
			query: {
				state,
				code: "test",
			},
			method: "GET",
			onError(context) {
				expect(context.response.status).toBe(302);
				const location = context.response.headers.get("location");
				expect(location).toBeDefined();
				expect(location).toContain(
					"http://localhost:3000/api/auth/error?error=signup_disabled",
				);
			},
		});
	});

	it("Should create user when implicit sign up is disabled but it is requested", async () => {
		const { client } = await getTestInstance({
			socialProviders: {
				google: {
					clientId: "test",
					clientSecret: "test",
					enabled: true,
					disableImplicitSignUp: true,
				},
			},
		});

		const signInRes = await client.signIn.social({
			provider: "google",
			callbackURL: "/callback",
			newUserCallbackURL: "/welcome",
			requestSignUp: true,
		});
		expect(signInRes.data).toMatchObject({
			url: expect.stringContaining("google.com"),
			redirect: true,
		});
		const state = new URL(signInRes.data!.url!).searchParams.get("state") || "";

		await client.$fetch("/callback/google", {
			query: {
				state,
				code: "test",
			},
			method: "GET",
			onError(context) {
				expect(context.response.status).toBe(302);
				const location = context.response.headers.get("location");
				expect(location).toBeDefined();
				expect(location).toContain("/welcome");
				const cookies = parseSetCookieHeader(
					context.response.headers.get("set-cookie") || "",
				);
				expect(cookies.get("better-auth.session_token")?.value).toBeDefined();
			},
		});
	});
});

describe("Disable signup", async () => {
	it("Should not create user when sign up is disabled", async () => {
		const { client } = await getTestInstance({
			socialProviders: {
				google: {
					clientId: "test",
					clientSecret: "test",
					enabled: true,
					disableSignUp: true,
				},
			},
		});

		const signInRes = await client.signIn.social({
			provider: "google",
			callbackURL: "/callback",
			newUserCallbackURL: "/welcome",
		});
		expect(signInRes.data).toMatchObject({
			url: expect.stringContaining("google.com"),
			redirect: true,
		});
		const state = new URL(signInRes.data!.url!).searchParams.get("state") || "";

		await client.$fetch("/callback/google", {
			query: {
				state,
				code: "test",
			},
			method: "GET",
			onError(context) {
				expect(context.response.status).toBe(302);
				const location = context.response.headers.get("location");
				expect(location).toBeDefined();
				expect(location).toContain(
					"http://localhost:3000/api/auth/error?error=signup_disabled",
				);
			},
		});
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/spotify.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import type { OAuthProvider, ProviderOptions } from "../oauth2";
import {
	createAuthorizationURL,
	validateAuthorizationCode,
	refreshAccessToken,
} from "../oauth2";

export interface SpotifyProfile {
	id: string;
	display_name: string;
	email: string;
	images: {
		url: string;
	}[];
}

export interface SpotifyOptions extends ProviderOptions<SpotifyProfile> {}

export const spotify = (options: SpotifyOptions) => {
	return {
		id: "spotify",
		name: "Spotify",
		createAuthorizationURL({ state, scopes, codeVerifier, redirectURI }) {
			const _scopes = options.disableDefaultScope ? [] : ["user-read-email"];
			options.scope && _scopes.push(...options.scope);
			scopes && _scopes.push(...scopes);
			return createAuthorizationURL({
				id: "spotify",
				options,
				authorizationEndpoint: "https://accounts.spotify.com/authorize",
				scopes: _scopes,
				state,
				codeVerifier,
				redirectURI,
			});
		},
		validateAuthorizationCode: async ({ code, codeVerifier, redirectURI }) => {
			return validateAuthorizationCode({
				code,
				codeVerifier,
				redirectURI,
				options,
				tokenEndpoint: "https://accounts.spotify.com/api/token",
			});
		},
		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint: "https://accounts.spotify.com/api/token",
					});
				},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}
			const { data: profile, error } = await betterFetch<SpotifyProfile>(
				"https://api.spotify.com/v1/me",
				{
					method: "GET",
					headers: {
						Authorization: `Bearer ${token.accessToken}`,
					},
				},
			);
			if (error) {
				return null;
			}
			const userMap = await options.mapProfileToUser?.(profile);
			return {
				user: {
					id: profile.id,
					name: profile.display_name,
					email: profile.email,
					image: profile.images[0]?.url,
					emailVerified: false,
					...userMap,
				},
				data: profile,
			};
		},
		options,
	} satisfies OAuthProvider<SpotifyProfile>;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/tiktok.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import type { OAuthProvider, ProviderOptions } from "../oauth2";
import { refreshAccessToken, validateAuthorizationCode } from "../oauth2";

/**
 * [More info](https://developers.tiktok.com/doc/tiktok-api-v2-get-user-info/)
 */
export interface TiktokProfile extends Record<string, any> {
	data: {
		user: {
			/**
			 * The unique identification of the user in the current application.Open id
			 * for the client.
			 *
			 * To return this field, add `fields=open_id` in the user profile request's query parameter.
			 */
			open_id: string;
			/**
			 * The unique identification of the user across different apps for the same developer.
			 * For example, if a partner has X number of clients,
			 * it will get X number of open_id for the same TikTok user,
			 * but one persistent union_id for the particular user.
			 *
			 * To return this field, add `fields=union_id` in the user profile request's query parameter.
			 */
			union_id?: string;
			/**
			 * User's profile image.
			 *
			 * To return this field, add `fields=avatar_url` in the user profile request's query parameter.
			 */
			avatar_url?: string;
			/**
			 * User`s profile image in 100x100 size.
			 *
			 * To return this field, add `fields=avatar_url_100` in the user profile request's query parameter.
			 */
			avatar_url_100?: string;
			/**
			 * User's profile image with higher resolution
			 *
			 * To return this field, add `fields=avatar_url_100` in the user profile request's query parameter.
			 */
			avatar_large_url: string;
			/**
			 * User's profile name
			 *
			 * To return this field, add `fields=display_name` in the user profile request's query parameter.
			 */
			display_name: string;
			/**
			 * User's username.
			 *
			 * To return this field, add `fields=username` in the user profile request's query parameter.
			 */
			username: string;
			/** @note Email is currently unsupported by TikTok  */
			email?: string;
			/**
			 * User's bio description if there is a valid one.
			 *
			 * To return this field, add `fields=bio_description` in the user profile request's query parameter.
			 */
			bio_description?: string;
			/**
			 * The link to user's TikTok profile page.
			 *
			 * To return this field, add `fields=profile_deep_link` in the user profile request's query parameter.
			 */
			profile_deep_link?: string;
			/**
			 * Whether TikTok has provided a verified badge to the account after confirming
			 * that it belongs to the user it represents.
			 *
			 * To return this field, add `fields=is_verified` in the user profile request's query parameter.
			 */
			is_verified?: boolean;
			/**
			 * User's followers count.
			 *
			 * To return this field, add `fields=follower_count` in the user profile request's query parameter.
			 */
			follower_count?: number;
			/**
			 * The number of accounts that the user is following.
			 *
			 * To return this field, add `fields=following_count` in the user profile request's query parameter.
			 */
			following_count?: number;
			/**
			 * The total number of likes received by the user across all of their videos.
			 *
			 * To return this field, add `fields=likes_count` in the user profile request's query parameter.
			 */
			likes_count?: number;
			/**
			 * The total number of publicly posted videos by the user.
			 *
			 * To return this field, add `fields=video_count` in the user profile request's query parameter.
			 */
			video_count?: number;
		};
	};
	error?: {
		/**
		 * The error category in string.
		 */
		code?: string;
		/**
		 * The error message in string.
		 */
		message?: string;
		/**
		 * The error message in string.
		 */
		log_id?: string;
	};
}

export interface TiktokOptions extends ProviderOptions {}

export const tiktok = (options: TiktokOptions) => {
	return {
		id: "tiktok",
		name: "TikTok",
		createAuthorizationURL({ state, scopes, redirectURI }) {
			const _scopes = options.disableDefaultScope ? [] : ["user.info.profile"];
			options.scope && _scopes.push(...options.scope);
			scopes && _scopes.push(...scopes);
			return new URL(
				`https://www.tiktok.com/v2/auth/authorize?scope=${_scopes.join(
					",",
				)}&response_type=code&client_key=${options.clientKey}&client_secret=${
					options.clientSecret
				}&redirect_uri=${encodeURIComponent(
					options.redirectURI || redirectURI,
				)}&state=${state}`,
			);
		},

		validateAuthorizationCode: async ({ code, redirectURI }) => {
			return validateAuthorizationCode({
				code,
				redirectURI: options.redirectURI || redirectURI,
				options,
				tokenEndpoint: "https://open.tiktokapis.com/v2/oauth/token/",
			});
		},
		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint: "https://open.tiktokapis.com/v2/oauth/token/",
					});
				},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}

			const fields = [
				"open_id",
				"avatar_large_url",
				"display_name",
				"username",
			];
			const { data: profile, error } = await betterFetch<TiktokProfile>(
				`https://open.tiktokapis.com/v2/user/info/?fields=${fields.join(",")}`,
				{
					headers: {
						authorization: `Bearer ${token.accessToken}`,
					},
				},
			);

			if (error) {
				return null;
			}

			return {
				user: {
					email: profile.data.user.email || profile.data.user.username,
					id: profile.data.user.open_id,
					name: profile.data.user.display_name || profile.data.user.username,
					image: profile.data.user.avatar_large_url,
					/** @note Tiktok does not provide emailVerified or even email*/
					emailVerified: profile.data.user.email ? true : false,
				},
				data: profile,
			};
		},
		options,
	} satisfies OAuthProvider<TiktokProfile>;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/twitch.ts
```typescript
import type { OAuthProvider, ProviderOptions } from "../oauth2";
import { logger } from "../utils";
import {
	createAuthorizationURL,
	validateAuthorizationCode,
	refreshAccessToken,
} from "../oauth2";
import { decodeJwt } from "jose";

export interface TwitchProfile {
	/**
	 * The sub of the user
	 */
	sub: string;
	/**
	 * The preferred username of the user
	 */
	preferred_username: string;
	/**
	 * The email of the user
	 */
	email: string;
	/**
	 * The picture of the user
	 */
	picture: string;
}

export interface TwitchOptions extends ProviderOptions<TwitchProfile> {
	claims?: string[];
}
export const twitch = (options: TwitchOptions) => {
	return {
		id: "twitch",
		name: "Twitch",
		createAuthorizationURL({ state, scopes, redirectURI }) {
			const _scopes = options.disableDefaultScope
				? []
				: ["user:read:email", "openid"];
			options.scope && _scopes.push(...options.scope);
			scopes && _scopes.push(...scopes);
			return createAuthorizationURL({
				id: "twitch",
				redirectURI,
				options,
				authorizationEndpoint: "https://id.twitch.tv/oauth2/authorize",
				scopes: _scopes,
				state,
				claims: options.claims || [
					"email",
					"email_verified",
					"preferred_username",
					"picture",
				],
			});
		},
		validateAuthorizationCode: async ({ code, redirectURI }) => {
			return validateAuthorizationCode({
				code,
				redirectURI,
				options,
				tokenEndpoint: "https://id.twitch.tv/oauth2/token",
			});
		},
		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint: "https://id.twitch.tv/oauth2/token",
					});
				},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}
			const idToken = token.idToken;
			if (!idToken) {
				logger.error("No idToken found in token");
				return null;
			}
			const profile = decodeJwt(idToken) as TwitchProfile;
			const userMap = await options.mapProfileToUser?.(profile);
			return {
				user: {
					id: profile.sub,
					name: profile.preferred_username,
					email: profile.email,
					image: profile.picture,
					emailVerified: false,
					...userMap,
				},
				data: profile,
			};
		},
		options,
	} satisfies OAuthProvider<TwitchProfile>;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/twitter.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import type { OAuthProvider, ProviderOptions } from "../oauth2";
import {
	createAuthorizationURL,
	refreshAccessToken,
	validateAuthorizationCode,
} from "../oauth2";

export interface TwitterProfile {
	data: {
		/**
		 * Unique identifier of this user. This is returned as a string in order to avoid complications with languages and tools
		 * that cannot handle large integers.
		 */
		id: string;
		/** The friendly name of this user, as shown on their profile. */
		name: string;
		/** @note Email is currently unsupported by Twitter.  */
		email?: string;
		/** The Twitter handle (screen name) of this user. */
		username: string;
		/**
		 * The location specified in the user's profile, if the user provided one.
		 * As this is a freeform value, it may not indicate a valid location, but it may be fuzzily evaluated when performing searches with location queries.
		 *
		 * To return this field, add `user.fields=location` in the authorization request's query parameter.
		 */
		location?: string;
		/**
		 * This object and its children fields contain details about text that has a special meaning in the user's description.
		 *
		 *To return this field, add `user.fields=entities` in the authorization request's query parameter.
		 */
		entities?: {
			/** Contains details about the user's profile website. */
			url: {
				/** Contains details about the user's profile website. */
				urls: Array<{
					/** The start position (zero-based) of the recognized user's profile website. All start indices are inclusive. */
					start: number;
					/** The end position (zero-based) of the recognized user's profile website. This end index is exclusive. */
					end: number;
					/** The URL in the format entered by the user. */
					url: string;
					/** The fully resolved URL. */
					expanded_url: string;
					/** The URL as displayed in the user's profile. */
					display_url: string;
				}>;
			};
			/** Contains details about URLs, Hashtags, Cashtags, or mentions located within a user's description. */
			description: {
				hashtags: Array<{
					start: number;
					end: number;
					tag: string;
				}>;
			};
		};
		/**
		 * Indicate if this user is a verified Twitter user.
		 *
		 * To return this field, add `user.fields=verified` in the authorization request's query parameter.
		 */
		verified?: boolean;
		/**
		 * The text of this user's profile description (also known as bio), if the user provided one.
		 *
		 * To return this field, add `user.fields=description` in the authorization request's query parameter.
		 */
		description?: string;
		/**
		 * The URL specified in the user's profile, if present.
		 *
		 * To return this field, add `user.fields=url` in the authorization request's query parameter.
		 */
		url?: string;
		/** The URL to the profile image for this user, as shown on the user's profile. */
		profile_image_url?: string;
		protected?: boolean;
		/**
		 * Unique identifier of this user's pinned Tweet.
		 *
		 *  You can obtain the expanded object in `includes.tweets` by adding `expansions=pinned_tweet_id` in the authorization request's query parameter.
		 */
		pinned_tweet_id?: string;
		created_at?: string;
	};
	includes?: {
		tweets?: Array<{
			id: string;
			text: string;
		}>;
	};
	[claims: string]: unknown;
}

export interface TwitterOption extends ProviderOptions<TwitterProfile> {}

export const twitter = (options: TwitterOption) => {
	return {
		id: "twitter",
		name: "Twitter",
		createAuthorizationURL(data) {
			const _scopes = options.disableDefaultScope
				? []
				: ["users.read", "tweet.read", "offline.access"];
			options.scope && _scopes.push(...options.scope);
			data.scopes && _scopes.push(...data.scopes);
			return createAuthorizationURL({
				id: "twitter",
				options,
				authorizationEndpoint: "https://x.com/i/oauth2/authorize",
				scopes: _scopes,
				state: data.state,
				codeVerifier: data.codeVerifier,
				redirectURI: data.redirectURI,
			});
		},
		validateAuthorizationCode: async ({ code, codeVerifier, redirectURI }) => {
			return validateAuthorizationCode({
				code,
				codeVerifier,
				authentication: "basic",
				redirectURI,
				options,
				tokenEndpoint: "https://api.x.com/2/oauth2/token",
			});
		},

		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint: "https://api.twitter.com/2/oauth2/token",
					});
				},
		async getUserInfo(token) {
			if (options.getUserInfo) {
				return options.getUserInfo(token);
			}
			const { data: profile, error } = await betterFetch<TwitterProfile>(
				"https://api.x.com/2/users/me?user.fields=profile_image_url",
				{
					method: "GET",
					headers: {
						Authorization: `Bearer ${token.accessToken}`,
					},
				},
			);
			if (error) {
				return null;
			}
			const userMap = await options.mapProfileToUser?.(profile);
			return {
				user: {
					id: profile.data.id,
					name: profile.data.name,
					email: profile.data.username || null,
					image: profile.data.profile_image_url,
					emailVerified: profile.data.verified || false,
					...userMap,
				},
				data: profile,
			};
		},
		options,
	} satisfies OAuthProvider<TwitterProfile>;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/social-providers/vk.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import { type OAuthProvider, type ProviderOptions } from "../oauth2";
import {
	createAuthorizationURL,
	validateAuthorizationCode,
	refreshAccessToken,
} from "../oauth2";

export interface VkProfile {
	user: {
		user_id: string;
		first_name: string;
		last_name: string;
		email?: string;
		phone?: number;
		avatar?: string;
		sex?: number;
		verified?: boolean;
		birthday: string;
	};
}

export const enum LANG {
	RUS = 0,
	UKR = 1,
	ENG = 3,
	SPA = 4,
	GERMAN = 6,
	POL = 15,
	FRA = 16,
	TURKEY = 82,
}

export interface VkOption extends ProviderOptions {
	lang_id?: LANG;
	scheme?: "light" | "dark";
}

export const vk = (options: VkOption) => {
	return {
		id: "vk",
		name: "VK",
		async createAuthorizationURL({ state, scopes, codeVerifier, redirectURI }) {
			const _scopes = options.disableDefaultScope ? [] : ["email", "phone"];
			options.scope && _scopes.push(...options.scope);
			scopes && _scopes.push(...scopes);
			const authorizationEndpoint = "https://id.vk.com/authorize";

			return createAuthorizationURL({
				id: "vk",
				options,
				authorizationEndpoint,
				scopes: _scopes,
				state,
				redirectURI,
				codeVerifier,
			});
		},
		validateAuthorizationCode: async ({
			code,
			codeVerifier,
			redirectURI,
			deviceId,
		}) => {
			return validateAuthorizationCode({
				code,
				codeVerifier,
				redirectURI: options.redirectURI || redirectURI,
				options,
				deviceId,
				tokenEndpoint: "https://id.vk.com/oauth2/auth",
			});
		},
		refreshAccessToken: options.refreshAccessToken
			? options.refreshAccessToken
			: async (refreshToken) => {
					return refreshAccessToken({
						refreshToken,
						options: {
							clientId: options.clientId,
							clientKey: options.clientKey,
							clientSecret: options.clientSecret,
						},
						tokenEndpoint: "https://id.vk.com/oauth2/auth",
					});
				},
		async getUserInfo(data) {
			if (options.getUserInfo) {
				return options.getUserInfo(data);
			}
			if (!data.accessToken) {
				return null;
			}
			const formBody = new URLSearchParams({
				access_token: data.accessToken,
				client_id: options.clientId,
			}).toString();
			const { data: profile, error } = await betterFetch<VkProfile>(
				"https://id.vk.com/oauth2/user_info",
				{
					method: "POST",
					headers: {
						"Content-Type": "application/x-www-form-urlencoded",
					},
					body: formBody,
				},
			);
			if (error) {
				return null;
			}
			if (!profile.user.email) {
				return null;
			}

			const userMap = await options.mapProfileToUser?.(profile);

			return {
				user: {
					id: profile.user.user_id,
					first_name: profile.user.first_name,
					last_name: profile.user.last_name,
					email: profile.user.email,
					image: profile.user.avatar,
					/** @note VK does not provide emailVerified*/
					emailVerified: !!profile.user.email,
					birthday: profile.user.birthday,
					sex: profile.user.sex,
					...userMap,
				},
				data: profile,
			};
		},
		options,
	} satisfies OAuthProvider<VkProfile>;
};

```
