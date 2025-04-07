/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/two-factor/client.ts
```typescript
import type { BetterAuthClientPlugin } from "../../client/types";
import type { twoFactor as twoFa } from "../../plugins/two-factor";

export const twoFactorClient = (options?: {
	/**
	 * a redirect function to call if a user needs to verify
	 * their two factor
	 */
	onTwoFactorRedirect?: () => void | Promise<void>;
}) => {
	return {
		id: "two-factor",
		$InferServerPlugin: {} as ReturnType<typeof twoFa>,
		atomListeners: [
			{
				matcher: (path) => path.startsWith("/two-factor/"),
				signal: "$sessionSignal",
			},
		],
		pathMethods: {
			"/two-factor/disable": "POST",
			"/two-factor/enable": "POST",
			"/two-factor/send-otp": "POST",
			"/two-factor/generate-backup-codes": "POST",
		},
		fetchPlugins: [
			{
				id: "two-factor",
				name: "two-factor",
				hooks: {
					async onSuccess(context) {
						if (context.data?.twoFactorRedirect) {
							if (options?.onTwoFactorRedirect) {
								await options.onTwoFactorRedirect();
							}
						}
					},
				},
			},
		],
	} satisfies BetterAuthClientPlugin;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/two-factor/constant.ts
```typescript
export const TWO_FACTOR_COOKIE_NAME = "two_factor";
export const TRUST_DEVICE_COOKIE_NAME = "trust_device";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/two-factor/error-code.ts
```typescript
export const TWO_FACTOR_ERROR_CODES = {
	OTP_NOT_ENABLED: "OTP not enabled",
	OTP_HAS_EXPIRED: "OTP has expired",
	TOTP_NOT_ENABLED: "TOTP not enabled",
	TWO_FACTOR_NOT_ENABLED: "Two factor isn't enabled",
	BACKUP_CODES_NOT_ENABLED: "Backup codes aren't enabled",
	INVALID_BACKUP_CODE: "Invalid backup code",
} as const;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/two-factor/index.ts
```typescript
import { generateRandomString } from "../../crypto/random";
import { z } from "zod";
import { createAuthEndpoint, createAuthMiddleware } from "../../api/call";
import { sessionMiddleware } from "../../api";
import { symmetricEncrypt } from "../../crypto";
import type { BetterAuthPlugin } from "../../types/plugins";
import { backupCode2fa, generateBackupCodes } from "./backup-codes";
import { otp2fa } from "./otp";
import { totp2fa } from "./totp";
import type { TwoFactorOptions, UserWithTwoFactor } from "./types";
import { mergeSchema } from "../../db/schema";
import { TWO_FACTOR_COOKIE_NAME, TRUST_DEVICE_COOKIE_NAME } from "./constant";
import { validatePassword } from "../../utils/password";
import { APIError } from "better-call";
import { deleteSessionCookie, setSessionCookie } from "../../cookies";
import { schema } from "./schema";
import { BASE_ERROR_CODES } from "../../error/codes";
import { createOTP } from "@better-auth/utils/otp";
import { createHMAC } from "@better-auth/utils/hmac";
import { TWO_FACTOR_ERROR_CODES } from "./error-code";
export * from "./error-code";

export const twoFactor = (options?: TwoFactorOptions) => {
	const opts = {
		twoFactorTable: "twoFactor",
	};
	const totp = totp2fa(options?.totpOptions);
	const backupCode = backupCode2fa(options?.backupCodeOptions);
	const otp = otp2fa(options?.otpOptions);

	return {
		id: "two-factor",
		endpoints: {
			...totp.endpoints,
			...otp.endpoints,
			...backupCode.endpoints,
			enableTwoFactor: createAuthEndpoint(
				"/two-factor/enable",
				{
					method: "POST",
					body: z.object({
						password: z.string({
							description: "User password",
						}),
					}),
					use: [sessionMiddleware],
					metadata: {
						openapi: {
							summary: "Enable two factor authentication",
							description:
								"Use this endpoint to enable two factor authentication. This will generate a TOTP URI and backup codes. Once the user verifies the TOTP URI, the two factor authentication will be enabled.",
							responses: {
								200: {
									description: "Successful response",
									content: {
										"application/json": {
											schema: {
												type: "object",
												properties: {
													totpURI: {
														type: "string",
														description: "TOTP URI",
													},
													backupCodes: {
														type: "array",
														items: {
															type: "string",
														},
														description: "Backup codes",
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
					const user = ctx.context.session.user as UserWithTwoFactor;
					const { password } = ctx.body;
					const isPasswordValid = await validatePassword(ctx, {
						password,
						userId: user.id,
					});
					if (!isPasswordValid) {
						throw new APIError("BAD_REQUEST", {
							message: BASE_ERROR_CODES.INVALID_PASSWORD,
						});
					}
					const secret = generateRandomString(32);
					const encryptedSecret = await symmetricEncrypt({
						key: ctx.context.secret,
						data: secret,
					});
					const backupCodes = await generateBackupCodes(
						ctx.context.secret,
						options?.backupCodeOptions,
					);
					if (options?.skipVerificationOnEnable) {
						const updatedUser = await ctx.context.internalAdapter.updateUser(
							user.id,
							{
								twoFactorEnabled: true,
							},
							ctx,
						);
						const newSession = await ctx.context.internalAdapter.createSession(
							updatedUser.id,
							ctx.request,
							false,
							ctx.context.session.session,
						);
						/**
						 * Update the session cookie with the new user data
						 */
						await setSessionCookie(ctx, {
							session: newSession,
							user: updatedUser,
						});

						//remove current session
						await ctx.context.internalAdapter.deleteSession(
							ctx.context.session.session.token,
						);
					}
					//delete existing two factor
					await ctx.context.adapter.deleteMany({
						model: opts.twoFactorTable,
						where: [
							{
								field: "userId",
								value: user.id,
							},
						],
					});

					await ctx.context.adapter.create({
						model: opts.twoFactorTable,
						data: {
							secret: encryptedSecret,
							backupCodes: backupCodes.encryptedBackupCodes,
							userId: user.id,
						},
					});
					const totpURI = createOTP(secret, {
						digits: options?.totpOptions?.digits || 6,
						period: options?.totpOptions?.period,
					}).url(options?.issuer || ctx.context.appName, user.email);
					return ctx.json({ totpURI, backupCodes: backupCodes.backupCodes });
				},
			),
			disableTwoFactor: createAuthEndpoint(
				"/two-factor/disable",
				{
					method: "POST",
					body: z.object({
						password: z.string({
							description: "User password",
						}),
					}),
					use: [sessionMiddleware],
					metadata: {
						openapi: {
							summary: "Disable two factor authentication",
							description:
								"Use this endpoint to disable two factor authentication.",
							responses: {
								200: {
									description: "Successful response",
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
					const user = ctx.context.session.user as UserWithTwoFactor;
					const { password } = ctx.body;
					const isPasswordValid = await validatePassword(ctx, {
						password,
						userId: user.id,
					});
					if (!isPasswordValid) {
						throw new APIError("BAD_REQUEST", {
							message: "Invalid password",
						});
					}
					const updatedUser = await ctx.context.internalAdapter.updateUser(
						user.id,
						{
							twoFactorEnabled: false,
						},
						ctx,
					);
					await ctx.context.adapter.delete({
						model: opts.twoFactorTable,
						where: [
							{
								field: "userId",
								value: updatedUser.id,
							},
						],
					});
					const newSession = await ctx.context.internalAdapter.createSession(
						updatedUser.id,
						ctx.request,
						false,
						ctx.context.session.session,
					);
					/**
					 * Update the session cookie with the new user data
					 */
					await setSessionCookie(ctx, {
						session: newSession,
						user: updatedUser,
					});
					//remove current session
					await ctx.context.internalAdapter.deleteSession(
						ctx.context.session.session.token,
					);
					return ctx.json({ status: true });
				},
			),
		},
		options: options,
		hooks: {
			after: [
				{
					matcher(context) {
						return (
							context.path === "/sign-in/email" ||
							context.path === "/sign-in/username" ||
							context.path === "/sign-in/phone-number"
						);
					},
					handler: createAuthMiddleware(async (ctx) => {
						const data = ctx.context.newSession;
						if (!data) {
							return;
						}

						if (!data?.user.twoFactorEnabled) {
							return;
						}
						// Check for trust device cookie
						const trustDeviceCookieName = ctx.context.createAuthCookie(
							TRUST_DEVICE_COOKIE_NAME,
						);
						const trustDeviceCookie = await ctx.getSignedCookie(
							trustDeviceCookieName.name,
							ctx.context.secret,
						);
						if (trustDeviceCookie) {
							const [token, sessionToken] = trustDeviceCookie.split("!");
							const expectedToken = await createHMAC(
								"SHA-256",
								"base64urlnopad",
							).sign(ctx.context.secret, `${data.user.id}!${sessionToken}`);

							if (token === expectedToken) {
								// Trust device cookie is valid, refresh it and skip 2FA
								const newToken = await createHMAC(
									"SHA-256",
									"base64urlnopad",
								).sign(ctx.context.secret, `${data.user.id}!${sessionToken}`);
								await ctx.setSignedCookie(
									trustDeviceCookieName.name,
									`${newToken}!${data.session.token}`,
									ctx.context.secret,
									trustDeviceCookieName.attributes,
								);
								return;
							}
						}

						/**
						 * remove the session cookie. It's set by the sign in credential
						 */
						deleteSessionCookie(ctx, true);
						await ctx.context.internalAdapter.deleteSession(data.session.token);
						const twoFactorCookie = ctx.context.createAuthCookie(
							TWO_FACTOR_COOKIE_NAME,
							{
								maxAge: 60 * 10, // 10 minutes
							},
						);
						/**
						 * We set the user id and the session
						 * id as a hash. Later will fetch for
						 * sessions with the user id compare
						 * the hash and set that as session.
						 */
						await ctx.setSignedCookie(
							twoFactorCookie.name,
							data.user.id,
							ctx.context.secret,
							twoFactorCookie.attributes,
						);
						return ctx.json({
							twoFactorRedirect: true,
						});
					}),
				},
			],
		},
		schema: mergeSchema(schema, options?.schema),
		rateLimit: [
			{
				pathMatcher(path) {
					return path.startsWith("/two-factor/");
				},
				window: 10,
				max: 3,
			},
		],
		$ERROR_CODES: TWO_FACTOR_ERROR_CODES,
	} satisfies BetterAuthPlugin;
};

export * from "./client";
export * from "./types";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/two-factor/schema.ts
```typescript
import type { AuthPluginSchema } from "../../types";

export const schema = {
	user: {
		fields: {
			twoFactorEnabled: {
				type: "boolean",
				required: false,
				defaultValue: false,
				input: false,
			},
		},
	},
	twoFactor: {
		fields: {
			secret: {
				type: "string",
				required: true,
				returned: false,
			},
			backupCodes: {
				type: "string",
				required: true,
				returned: false,
			},
			userId: {
				type: "string",
				required: true,
				returned: false,
				references: {
					model: "user",
					field: "id",
				},
			},
		},
	},
} satisfies AuthPluginSchema;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/two-factor/two-factor.test.ts
```typescript
import { describe, expect, it, vi } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";
import { twoFactor, twoFactorClient } from ".";
import { createAuthClient } from "../../client";
import { parseSetCookieHeader } from "../../cookies";
import type { TwoFactorTable, UserWithTwoFactor } from "./types";
import { DEFAULT_SECRET } from "../../utils/constants";
import { symmetricDecrypt } from "../../crypto";
import { convertSetCookieToCookie } from "../../test-utils/headers";
import { createOTP } from "@better-auth/utils/otp";

describe("two factor", async () => {
	let OTP = "";
	const { testUser, customFetchImpl, sessionSetter, db, auth } =
		await getTestInstance({
			secret: DEFAULT_SECRET,
			plugins: [
				twoFactor({
					otpOptions: {
						sendOTP({ otp }) {
							OTP = otp;
						},
					},
				}),
			],
		});

	const headers = new Headers();

	const client = createAuthClient({
		plugins: [twoFactorClient()],
		fetchOptions: {
			customFetchImpl,
			baseURL: "http://localhost:3000/api/auth",
		},
	});
	const session = await client.signIn.email({
		email: testUser.email,
		password: testUser.password,
		fetchOptions: {
			onSuccess: sessionSetter(headers),
		},
	});
	if (!session) {
		throw new Error("No session");
	}

	it("should return uri and backup codes and shouldn't enable twoFactor yet", async () => {
		const res = await client.twoFactor.enable({
			password: testUser.password,
			fetchOptions: {
				headers,
			},
		});

		expect(res.data?.backupCodes.length).toEqual(10);
		expect(res.data?.totpURI).toBeDefined();
		const dbUser = await db.findOne<UserWithTwoFactor>({
			model: "user",
			where: [
				{
					field: "id",
					value: session.data?.user.id as string,
				},
			],
		});
		const twoFactor = await db.findOne<TwoFactorTable>({
			model: "twoFactor",
			where: [
				{
					field: "userId",
					value: session.data?.user.id as string,
				},
			],
		});
		expect(dbUser?.twoFactorEnabled).toBe(null);
		expect(twoFactor?.secret).toBeDefined();
		expect(twoFactor?.backupCodes).toBeDefined();
	});

	it("should enable twoFactor", async () => {
		const twoFactor = await db.findOne<TwoFactorTable>({
			model: "twoFactor",
			where: [
				{
					field: "userId",
					value: session.data?.user.id as string,
				},
			],
		});
		if (!twoFactor) {
			throw new Error("No two factor");
		}

		const decrypted = await symmetricDecrypt({
			key: DEFAULT_SECRET,
			data: twoFactor.secret,
		});
		const code = await createOTP(decrypted).totp();

		const res = await client.twoFactor.verifyTotp({
			code,
			fetchOptions: {
				headers,
				onSuccess: sessionSetter(headers),
			},
		});
		expect(res.data?.token).toBeDefined();
	});

	it("should require two factor", async () => {
		const headers = new Headers();
		const res = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
			rememberMe: false,
			fetchOptions: {
				onResponse(context) {
					const parsed = parseSetCookieHeader(
						context.response.headers.get("Set-Cookie") || "",
					);
					expect(parsed.get("better-auth.session_token")?.value).toBe("");
					expect(parsed.get("better-auth.two_factor")?.value).toBeDefined();
					expect(parsed.get("better-auth.dont_remember")?.value).toBeDefined();
					headers.append(
						"cookie",
						`better-auth.two_factor=${
							parsed.get("better-auth.two_factor")?.value
						}`,
					);
					headers.append(
						"cookie",
						`better-auth.dont_remember=${
							parsed.get("better-auth.dont_remember")?.value
						}`,
					);
				},
			},
		});
		expect((res.data as any)?.twoFactorRedirect).toBe(true);
		await client.twoFactor.sendOtp({
			fetchOptions: {
				headers,
			},
		});

		const verifyRes = await client.twoFactor.verifyOtp({
			code: OTP,
			fetchOptions: {
				headers,
				onResponse(context) {
					const parsed = parseSetCookieHeader(
						context.response.headers.get("Set-Cookie") || "",
					);
					expect(parsed.get("better-auth.session_token")?.value).toBeDefined();
					// max age should be undefined because we are not using remember me
					expect(
						parsed.get("better-auth.session_token")?.["max-age"],
					).not.toBeDefined();
				},
			},
		});
		expect(verifyRes.data?.token).toBeDefined();
	});

	let backupCodes: string[] = [];
	it("should generate backup codes", async () => {
		await client.twoFactor.enable({
			password: testUser.password,
			fetchOptions: {
				headers,
			},
		});
		const backupCodesRes = await client.twoFactor.generateBackupCodes({
			fetchOptions: {
				headers,
			},
			password: testUser.password,
		});
		expect(backupCodesRes.data?.backupCodes).toBeDefined();
		backupCodes = backupCodesRes.data?.backupCodes || [];
	});

	it("should allow sign in with backup code", async () => {
		const headers = new Headers();
		await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
			fetchOptions: {
				onSuccess(context) {
					const parsed = parseSetCookieHeader(
						context.response.headers.get("Set-Cookie") || "",
					);
					const token = parsed.get("better-auth.session_token")?.value;
					expect(token).toBe("");
					headers.append(
						"cookie",
						`better-auth.two_factor=${
							parsed.get("better-auth.two_factor")?.value
						}`,
					);
				},
			},
		});
		const backupCode = backupCodes[0];

		let parsedCookies = new Map();
		await client.twoFactor.verifyBackupCode({
			code: backupCode,
			fetchOptions: {
				headers,
				onSuccess(context) {
					parsedCookies = parseSetCookieHeader(
						context.response.headers.get("Set-Cookie") || "",
					);
				},
			},
		});
		const token = parsedCookies.get("better-auth.session_token")?.value;
		expect(token?.length).toBeGreaterThan(0);
		const currentBackupCodes = await auth.api.viewBackupCodes({
			body: {
				userId: session.data?.user.id!,
			},
		});
		expect(currentBackupCodes.backupCodes).toBeDefined();
		expect(currentBackupCodes.backupCodes).not.toContain(backupCode);

		const res = await client.twoFactor.verifyBackupCode({
			code: "invalid-code",
			fetchOptions: {
				headers,
				onSuccess(context) {
					const parsed = parseSetCookieHeader(
						context.response.headers.get("Set-Cookie") || "",
					);
					const token = parsed.get("better-auth.session_token")?.value;
					expect(token?.length).toBeGreaterThan(0);
				},
			},
		});
		expect(res.error?.message).toBe("Invalid backup code");
	});

	it("should trust device", async () => {
		const headers = new Headers();
		const res = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
			fetchOptions: {
				onSuccess(context) {
					const parsed = parseSetCookieHeader(
						context.response.headers.get("Set-Cookie") || "",
					);
					headers.append(
						"cookie",
						`better-auth.two_factor=${
							parsed.get("better-auth.two_factor")?.value
						}`,
					);
				},
			},
		});
		expect((res.data as any)?.twoFactorRedirect).toBe(true);
		const otpRes = await client.twoFactor.sendOtp({
			fetchOptions: {
				headers,
				onSuccess(context) {
					const parsed = parseSetCookieHeader(
						context.response.headers.get("Set-Cookie") || "",
					);
					headers.append(
						"cookie",
						`better-auth.otp.counter=${
							parsed.get("better-auth.otp_counter")?.value
						}`,
					);
				},
			},
		});
		const newHeaders = new Headers();
		await client.twoFactor.verifyOtp({
			trustDevice: true,
			code: OTP,
			fetchOptions: {
				headers,
				onSuccess(context) {
					const parsed = parseSetCookieHeader(
						context.response.headers.get("Set-Cookie") || "",
					);
					newHeaders.set(
						"cookie",
						`better-auth.trust_device=${
							parsed.get("better-auth.trust_device")?.value
						}`,
					);
				},
			},
		});

		const signInRes = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
			fetchOptions: {
				headers: newHeaders,
			},
		});
		expect(signInRes.data?.user).toBeDefined();
	});

	it("should disable two factor", async () => {
		const res = await client.twoFactor.disable({
			password: testUser.password,
			fetchOptions: {
				headers,
			},
		});

		expect(res.data?.status).toBe(true);
		const dbUser = await db.findOne<UserWithTwoFactor>({
			model: "user",
			where: [
				{
					field: "id",
					value: session.data?.user.id as string,
				},
			],
		});
		expect(dbUser?.twoFactorEnabled).toBe(false);

		const signInRes = await client.signIn.email({
			email: testUser.email,
			password: testUser.password,
		});
		expect(signInRes.data?.user).toBeDefined();
	});
});

describe("two factor auth api", async () => {
	let OTP = "";
	const sendOTP = vi.fn();
	const { auth, signInWithTestUser, testUser } = await getTestInstance({
		secret: DEFAULT_SECRET,
		plugins: [
			twoFactor({
				otpOptions: {
					sendOTP({ otp }) {
						OTP = otp;
						sendOTP(otp);
					},
				},
				skipVerificationOnEnable: true,
			}),
		],
	});
	let { headers } = await signInWithTestUser();

	it("enable two factor", async () => {
		const res = await auth.api.enableTwoFactor({
			body: {
				password: testUser.password,
			},
			headers,
			asResponse: true,
		});
		headers = convertSetCookieToCookie(res.headers);

		const json = (await res.json()) as {
			status: boolean;
			backupCodes: string[];
			totpURI: string;
		};
		expect(json.backupCodes.length).toBe(10);
		expect(json.totpURI).toBeDefined();
		const session = await auth.api.getSession({
			headers,
		});
		expect(session?.user.twoFactorEnabled).toBe(true);
	});

	it("should get totp uri", async () => {
		const res = await auth.api.getTOTPURI({
			headers,
			body: {
				password: testUser.password,
			},
		});
		expect(res.totpURI).toBeDefined();
	});

	it("should request second factor", async () => {
		const signInRes = await auth.api.signInEmail({
			body: {
				email: testUser.email,
				password: testUser.password,
			},
			asResponse: true,
		});

		headers = convertSetCookieToCookie(signInRes.headers);

		expect(signInRes).toBeInstanceOf(Response);
		expect(signInRes.status).toBe(200);
		const parsed = parseSetCookieHeader(
			signInRes.headers.get("Set-Cookie") || "",
		);
		const twoFactorCookie = parsed.get("better-auth.two_factor");
		expect(twoFactorCookie).toBeDefined();
		const sessionToken = parsed.get("better-auth.session_token");
		expect(sessionToken?.value).toBeFalsy();
	});

	it("should send otp", async () => {
		await auth.api.sendTwoFactorOTP({
			headers,
			body: {
				trustDevice: false,
			},
		});
		expect(OTP.length).toBe(6);
		expect(sendOTP).toHaveBeenCalledWith(OTP);
	});

	it("should verify otp", async () => {
		const res = await auth.api.verifyTwoFactorOTP({
			headers,
			body: {
				code: OTP,
			},
			asResponse: true,
		});
		expect(res.status).toBe(200);
		expect(res.headers.get("Set-Cookie")).toBeDefined();
		headers = convertSetCookieToCookie(res.headers);
	});

	it("should disable two factor", async () => {
		const res = await auth.api.disableTwoFactor({
			headers,
			body: {
				password: testUser.password,
			},
			asResponse: true,
		});
		headers = convertSetCookieToCookie(res.headers);
		expect(res.status).toBe(200);
		const session = await auth.api.getSession({
			headers,
		});
		expect(session?.user.twoFactorEnabled).toBe(false);
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/two-factor/types.ts
```typescript
import type { User } from "../../types";
import type { AuthEndpoint } from "../../api/call";
import type { LiteralString } from "../../types/helper";
import type { BackupCodeOptions } from "./backup-codes";
import type { OTPOptions } from "./otp";
import type { TOTPOptions } from "./totp";
import type { InferOptionSchema } from "../../types";
import type { schema } from "./schema";

export interface TwoFactorOptions {
	/**
	 * Application Name
	 */
	issuer?: string;
	/**
	 * TOTP OPtions
	 */
	totpOptions?: Omit<TOTPOptions, "issuer">;
	/**
	 * OTP Options
	 */
	otpOptions?: OTPOptions;
	/**
	 * Backup code options
	 */
	backupCodeOptions?: BackupCodeOptions;
	/**
	 * Skip verification on enabling two factor authentication.
	 * @default false
	 */
	skipVerificationOnEnable?: boolean;
	/**
	 * Custom schema for the two factor plugin
	 */
	schema?: InferOptionSchema<typeof schema>;
}

export interface UserWithTwoFactor extends User {
	/**
	 * If the user has enabled two factor authentication.
	 */
	twoFactorEnabled: boolean;
}

export interface TwoFactorProvider {
	id: LiteralString;
	endpoints?: Record<string, AuthEndpoint>;
}

export interface TwoFactorTable {
	userId: string;
	secret: string;
	backupCodes: string;
	enabled: boolean;
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/two-factor/verify-middleware.ts
```typescript
import { APIError } from "better-call";
import { createAuthMiddleware } from "../../api/call";
import { TRUST_DEVICE_COOKIE_NAME, TWO_FACTOR_COOKIE_NAME } from "./constant";
import { setSessionCookie } from "../../cookies";
import { z } from "zod";
import { getSessionFromCtx } from "../../api";
import type { UserWithTwoFactor } from "./types";
import { createHMAC } from "@better-auth/utils/hmac";
import type { GenericEndpointContext } from "../../types";

export const verifyTwoFactorMiddleware = createAuthMiddleware(
	{
		body: z.object({
			/**
			 * if true, the device will be trusted
			 * for 30 days. It'll be refreshed on
			 * every sign in request within this time.
			 */
			trustDevice: z.boolean().optional(),
		}),
	},
	async (ctx) => {
		const session = await getSessionFromCtx(ctx);
		if (!session) {
			const cookieName = ctx.context.createAuthCookie(TWO_FACTOR_COOKIE_NAME);
			const userId = await ctx.getSignedCookie(
				cookieName.name,
				ctx.context.secret,
			);
			if (!userId) {
				throw new APIError("UNAUTHORIZED", {
					message: "invalid two factor cookie",
				});
			}
			const user = (await ctx.context.internalAdapter.findUserById(
				userId,
			)) as UserWithTwoFactor;
			if (!user) {
				throw new APIError("UNAUTHORIZED", {
					message: "invalid two factor cookie",
				});
			}
			const dontRememberMe = await ctx.getSignedCookie(
				ctx.context.authCookies.dontRememberToken.name,
				ctx.context.secret,
			);
			const session = await ctx.context.internalAdapter.createSession(
				userId,
				ctx.request,
				!!dontRememberMe,
			);
			if (!session) {
				throw new APIError("INTERNAL_SERVER_ERROR", {
					message: "failed to create session",
				});
			}
			return {
				valid: async (ctx: GenericEndpointContext) => {
					await setSessionCookie(ctx, {
						session,
						user,
					});
					if (ctx.body.trustDevice) {
						const trustDeviceCookie = ctx.context.createAuthCookie(
							TRUST_DEVICE_COOKIE_NAME,
							{
								maxAge: 30 * 24 * 60 * 60, // 30 days, it'll be refreshed on sign in requests
							},
						);
						/**
						 * create a token that will be used to
						 * verify the device
						 */
						const token = await createHMAC("SHA-256", "base64urlnopad").sign(
							ctx.context.secret,
							`${user.id}!${session.token}`,
						);
						await ctx.setSignedCookie(
							trustDeviceCookie.name,
							`${token}!${session.token}`,
							ctx.context.secret,
							trustDeviceCookie.attributes,
						);
						// delete the dont remember me cookie
						ctx.setCookie(ctx.context.authCookies.dontRememberToken.name, "", {
							maxAge: 0,
						});
						// delete the two factor cookie
						ctx.setCookie(cookieName.name, "", {
							maxAge: 0,
						});
					}
					return ctx.json({
						token: session.token,
						user: {
							id: user.id,
							email: user.email,
							emailVerified: user.emailVerified,
							name: user.name,
							image: user.image,
							createdAt: user.createdAt,
							updatedAt: user.updatedAt,
						},
					});
				},
				invalid: async () => {
					throw new APIError("UNAUTHORIZED", {
						message: "invalid two factor authentication",
					});
				},
				session: {
					session,
					user,
				},
			};
		}
		return {
			valid: async (ctx: GenericEndpointContext) => {
				return ctx.json({
					token: session.session.token,
					user: {
						id: session.user.id,
						email: session.user.email,
						emailVerified: session.user.emailVerified,
						name: session.user.name,
						image: session.user.image,
						createdAt: session.user.createdAt,
						updatedAt: session.user.updatedAt,
					},
				});
			},
			invalid: async () => {
				throw new APIError("UNAUTHORIZED", {
					message: "invalid two factor authentication",
				});
			},
			session,
		};
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/two-factor/otp/index.ts
```typescript
import { APIError } from "better-call";
import { z } from "zod";
import { createAuthEndpoint } from "../../../api/call";
import { verifyTwoFactorMiddleware } from "../verify-middleware";
import type {
	TwoFactorProvider,
	TwoFactorTable,
	UserWithTwoFactor,
} from "../types";
import { TWO_FACTOR_ERROR_CODES } from "../error-code";
import { generateRandomString } from "../../../crypto";
import { setSessionCookie } from "../../../cookies";

export interface OTPOptions {
	/**
	 * How long the opt will be valid for in
	 * minutes
	 *
	 * @default "3 mins"
	 */
	period?: number;
	/**
	 * Number of digits for the OTP code
	 *
	 * @default 6
	 */
	digits?: number;
	/**
	 * Send the otp to the user
	 *
	 * @param user - The user to send the otp to
	 * @param otp - The otp to send
	 * @param request - The request object
	 * @returns void | Promise<void>
	 */
	sendOTP?: (
		/**
		 * The user to send the otp to
		 * @type UserWithTwoFactor
		 * @default UserWithTwoFactors
		 */
		data: {
			user: UserWithTwoFactor;
			otp: string;
		},
		/**
		 * The request object
		 */
		request?: Request,
	) => Promise<void> | void;
}

/**
 * The otp adapter is created from the totp adapter.
 */
export const otp2fa = (options?: OTPOptions) => {
	const opts = {
		...options,
		digits: options?.digits || 6,
		period: (options?.period || 3) * 60 * 1000,
	};
	const twoFactorTable = "twoFactor";

	/**
	 * Generate OTP and send it to the user.
	 */
	const send2FaOTP = createAuthEndpoint(
		"/two-factor/send-otp",
		{
			method: "POST",
			body: z
				.object({
					/**
					 * if true, the device will be trusted
					 * for 30 days. It'll be refreshed on
					 * every sign in request within this time.
					 */
					trustDevice: z.boolean().optional(),
				})
				.optional(),
			use: [verifyTwoFactorMiddleware],
			metadata: {
				openapi: {
					summary: "Send two factor OTP",
					description: "Send two factor OTP to the user",
					responses: {
						200: {
							description: "Successful response",
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
			if (!options || !options.sendOTP) {
				ctx.context.logger.error(
					"send otp isn't configured. Please configure the send otp function on otp options.",
				);
				throw new APIError("BAD_REQUEST", {
					message: "otp isn't configured",
				});
			}
			const user = ctx.context.session.user as UserWithTwoFactor;
			const twoFactor = await ctx.context.adapter.findOne<TwoFactorTable>({
				model: twoFactorTable,
				where: [
					{
						field: "userId",
						value: user.id,
					},
				],
			});
			if (!twoFactor) {
				throw new APIError("BAD_REQUEST", {
					message: TWO_FACTOR_ERROR_CODES.OTP_NOT_ENABLED,
				});
			}
			const code = generateRandomString(opts.digits, "0-9");
			await ctx.context.internalAdapter.createVerificationValue({
				value: code,
				identifier: `2fa-otp-${user.id}`,
				expiresAt: new Date(Date.now() + opts.period),
			});
			await options.sendOTP({ user, otp: code }, ctx.request);
			return ctx.json({ status: true });
		},
	);

	const verifyOTP = createAuthEndpoint(
		"/two-factor/verify-otp",
		{
			method: "POST",
			body: z.object({
				code: z.string({
					description: "The otp code to verify",
				}),
				/**
				 * if true, the device will be trusted
				 * for 30 days. It'll be refreshed on
				 * every sign in request within this time.
				 */
				trustDevice: z.boolean().optional(),
			}),
			use: [verifyTwoFactorMiddleware],
			metadata: {
				openapi: {
					summary: "Verify two factor OTP",
					description: "Verify two factor OTP",
					responses: {
						200: {
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
			const user = ctx.context.session.user;
			const twoFactor = await ctx.context.adapter.findOne<TwoFactorTable>({
				model: twoFactorTable,
				where: [
					{
						field: "userId",
						value: user.id,
					},
				],
			});
			if (!twoFactor) {
				throw new APIError("BAD_REQUEST", {
					message: TWO_FACTOR_ERROR_CODES.OTP_NOT_ENABLED,
				});
			}
			const toCheckOtp =
				await ctx.context.internalAdapter.findVerificationValue(
					`2fa-otp-${user.id}`,
				);
			if (!toCheckOtp || toCheckOtp.expiresAt < new Date()) {
				throw new APIError("BAD_REQUEST", {
					message: TWO_FACTOR_ERROR_CODES.OTP_HAS_EXPIRED,
				});
			}
			if (toCheckOtp.value === ctx.body.code) {
				if (!user.twoFactorEnabled) {
					const updatedUser = await ctx.context.internalAdapter.updateUser(
						user.id,
						{
							twoFactorEnabled: true,
						},
					);
					const newSession = await ctx.context.internalAdapter.createSession(
						user.id,
						ctx.request,
						false,
						ctx.context.session.session,
					);
					await ctx.context.internalAdapter.deleteSession(
						ctx.context.session.session.token,
					);

					await setSessionCookie(ctx, {
						session: newSession,
						user: updatedUser,
					});
				}
				return ctx.context.valid(ctx);
			} else {
				return ctx.context.invalid();
			}
		},
	);

	return {
		id: "otp",
		endpoints: {
			sendTwoFactorOTP: send2FaOTP,
			verifyTwoFactorOTP: verifyOTP,
		},
	} satisfies TwoFactorProvider;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/two-factor/backup-codes/index.ts
```typescript
import { generateRandomString } from "../../../crypto/random";
import { z } from "zod";
import { createAuthEndpoint } from "../../../api/call";
import { sessionMiddleware } from "../../../api";
import { symmetricDecrypt, symmetricEncrypt } from "../../../crypto";
import { verifyTwoFactorMiddleware } from "../verify-middleware";
import type {
	TwoFactorProvider,
	TwoFactorTable,
	UserWithTwoFactor,
} from "../types";
import { APIError } from "better-call";
import { setSessionCookie } from "../../../cookies";
import { TWO_FACTOR_ERROR_CODES } from "../error-code";

export interface BackupCodeOptions {
	/**
	 * The amount of backup codes to generate
	 *
	 * @default 10
	 */
	amount?: number;
	/**
	 * The length of the backup codes
	 *
	 * @default 10
	 */
	length?: number;
	customBackupCodesGenerate?: () => string[];
}

function generateBackupCodesFn(options?: BackupCodeOptions) {
	return Array.from({ length: options?.amount ?? 10 })
		.fill(null)
		.map(() => generateRandomString(options?.length ?? 10, "a-z", "0-9", "A-Z"))
		.map((code) => `${code.slice(0, 5)}-${code.slice(5)}`);
}

export async function generateBackupCodes(
	secret: string,
	options?: BackupCodeOptions,
) {
	const key = secret;
	const backupCodes = options?.customBackupCodesGenerate
		? options.customBackupCodesGenerate()
		: generateBackupCodesFn(options);
	const encCodes = await symmetricEncrypt({
		data: JSON.stringify(backupCodes),
		key: key,
	});
	return {
		backupCodes,
		encryptedBackupCodes: encCodes,
	};
}

export async function verifyBackupCode(
	data: {
		backupCodes: string;
		code: string;
	},
	key: string,
) {
	const codes = await getBackupCodes(data.backupCodes, key);
	if (!codes) {
		return {
			status: false,
			updated: null,
		};
	}
	return {
		status: codes.includes(data.code),
		updated: codes.filter((code) => code !== data.code),
	};
}

export async function getBackupCodes(backupCodes: string, key: string) {
	const secret = new TextDecoder("utf-8").decode(
		new TextEncoder().encode(
			await symmetricDecrypt({ key, data: backupCodes }),
		),
	);
	const data = JSON.parse(secret);
	const result = z.array(z.string()).safeParse(data);
	if (result.success) {
		return result.data;
	}
	return null;
}

export const backupCode2fa = (options?: BackupCodeOptions) => {
	const twoFactorTable = "twoFactor";
	return {
		id: "backup_code",
		endpoints: {
			verifyBackupCode: createAuthEndpoint(
				"/two-factor/verify-backup-code",

				{
					method: "POST",
					body: z.object({
						code: z.string(),
						/**
						 * Disable setting the session cookie
						 */
						disableSession: z
							.boolean({
								description: "If true, the session cookie will not be set.",
							})
							.optional(),
						/**
						 * if true, the device will be trusted
						 * for 30 days. It'll be refreshed on
						 * every sign in request within this time.
						 */
						trustDevice: z
							.boolean({
								description:
									"If true, the device will be trusted for 30 days. It'll be refreshed on every sign in request within this time.",
							})
							.optional(),
					}),
					use: [verifyTwoFactorMiddleware],
				},
				async (ctx) => {
					const user = ctx.context.session.user as UserWithTwoFactor;
					const twoFactor = await ctx.context.adapter.findOne<TwoFactorTable>({
						model: twoFactorTable,
						where: [
							{
								field: "userId",
								value: user.id,
							},
						],
					});
					if (!twoFactor) {
						throw new APIError("BAD_REQUEST", {
							message: TWO_FACTOR_ERROR_CODES.BACKUP_CODES_NOT_ENABLED,
						});
					}
					const validate = await verifyBackupCode(
						{
							backupCodes: twoFactor.backupCodes,
							code: ctx.body.code,
						},
						ctx.context.secret,
					);
					if (!validate.status) {
						throw new APIError("UNAUTHORIZED", {
							message: TWO_FACTOR_ERROR_CODES.INVALID_BACKUP_CODE,
						});
					}
					const updatedBackupCodes = await symmetricEncrypt({
						key: ctx.context.secret,
						data: JSON.stringify(validate.updated),
					});

					await ctx.context.adapter.updateMany({
						model: twoFactorTable,
						update: {
							backupCodes: updatedBackupCodes,
						},
						where: [
							{
								field: "userId",
								value: user.id,
							},
						],
					});

					if (!ctx.body.disableSession) {
						await setSessionCookie(ctx, {
							session: ctx.context.session.session,
							user,
						});
					}
					return ctx.json({
						user: user,
						session: ctx.context.session,
					});
				},
			),
			generateBackupCodes: createAuthEndpoint(
				"/two-factor/generate-backup-codes",
				{
					method: "POST",
					body: z.object({
						password: z.string(),
					}),
					use: [sessionMiddleware],
				},
				async (ctx) => {
					const user = ctx.context.session.user as UserWithTwoFactor;
					if (!user.twoFactorEnabled) {
						throw new APIError("BAD_REQUEST", {
							message: TWO_FACTOR_ERROR_CODES.TWO_FACTOR_NOT_ENABLED,
						});
					}
					await ctx.context.password.checkPassword(user.id, ctx);
					const backupCodes = await generateBackupCodes(
						ctx.context.secret,
						options,
					);
					await ctx.context.adapter.update({
						model: twoFactorTable,
						update: {
							backupCodes: backupCodes.encryptedBackupCodes,
						},
						where: [
							{
								field: "userId",
								value: ctx.context.session.user.id,
							},
						],
					});
					return ctx.json({
						status: true,
						backupCodes: backupCodes.backupCodes,
					});
				},
			),
			viewBackupCodes: createAuthEndpoint(
				"/two-factor/view-backup-codes",
				{
					method: "GET",
					body: z.object({
						userId: z.coerce.string(),
					}),
					metadata: {
						SERVER_ONLY: true,
					},
				},
				async (ctx) => {
					const twoFactor = await ctx.context.adapter.findOne<TwoFactorTable>({
						model: twoFactorTable,
						where: [
							{
								field: "userId",
								value: ctx.body.userId,
							},
						],
					});
					if (!twoFactor) {
						throw new APIError("BAD_REQUEST", {
							message: "Backup codes aren't enabled",
						});
					}
					const backupCodes = await getBackupCodes(
						twoFactor.backupCodes,
						ctx.context.secret,
					);
					if (!backupCodes) {
						throw new APIError("BAD_REQUEST", {
							message: TWO_FACTOR_ERROR_CODES.BACKUP_CODES_NOT_ENABLED,
						});
					}
					return ctx.json({
						status: true,
						backupCodes: backupCodes,
					});
				},
			),
		},
	} satisfies TwoFactorProvider;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/two-factor/totp/index.ts
```typescript
import { APIError } from "better-call";
import { z } from "zod";
import { createAuthEndpoint } from "../../../api/call";
import { sessionMiddleware } from "../../../api";
import { symmetricDecrypt } from "../../../crypto";
import type { BackupCodeOptions } from "../backup-codes";
import { verifyTwoFactorMiddleware } from "../verify-middleware";
import type {
	TwoFactorProvider,
	TwoFactorTable,
	UserWithTwoFactor,
} from "../types";
import { setSessionCookie } from "../../../cookies";
import { TWO_FACTOR_ERROR_CODES } from "../error-code";
import { createOTP } from "@better-auth/utils/otp";

export type TOTPOptions = {
	/**
	 * Issuer
	 */
	issuer?: string;
	/**
	 * How many digits the otp to be
	 *
	 * @default 6
	 */
	digits?: 6 | 8;
	/**
	 * Period for otp in seconds.
	 * @default 30
	 */
	period?: number;
	/**
	 * Backup codes configuration
	 */
	backupCodes?: BackupCodeOptions;
	/**
	 * Disable totp
	 */
	disable?: boolean;
};

export const totp2fa = (options?: TOTPOptions) => {
	const opts = {
		...options,
		digits: options?.digits || 6,
		period: options?.period || 30,
	};

	const twoFactorTable = "twoFactor";

	const generateTOTP = createAuthEndpoint(
		"/totp/generate",
		{
			method: "POST",
			use: [sessionMiddleware],
			metadata: {
				openapi: {
					summary: "Generate TOTP code",
					description: "Use this endpoint to generate a TOTP code",
					responses: {
						200: {
							description: "Successful response",
							content: {
								"application/json": {
									schema: {
										type: "object",
										properties: {
											code: {
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
			if (options?.disable) {
				ctx.context.logger.error(
					"totp isn't configured. please pass totp option on two factor plugin to enable totp",
				);
				throw new APIError("BAD_REQUEST", {
					message: "totp isn't configured",
				});
			}
			const user = ctx.context.session.user as UserWithTwoFactor;
			const twoFactor = await ctx.context.adapter.findOne<TwoFactorTable>({
				model: twoFactorTable,
				where: [
					{
						field: "userId",
						value: user.id,
					},
				],
			});
			if (!twoFactor) {
				throw new APIError("BAD_REQUEST", {
					message: TWO_FACTOR_ERROR_CODES.TOTP_NOT_ENABLED,
				});
			}
			const code = await createOTP(twoFactor.secret, {
				period: opts.period,
				digits: opts.digits,
			}).totp();
			return { code };
		},
	);

	const getTOTPURI = createAuthEndpoint(
		"/two-factor/get-totp-uri",
		{
			method: "POST",
			use: [sessionMiddleware],
			body: z.object({
				password: z.string({
					description: "User password",
				}),
			}),
			metadata: {
				openapi: {
					summary: "Get TOTP URI",
					description: "Use this endpoint to get the TOTP URI",
					responses: {
						200: {
							description: "Successful response",
							content: {
								"application/json": {
									schema: {
										type: "object",
										properties: {
											totpURI: {
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
			if (options?.disable) {
				ctx.context.logger.error(
					"totp isn't configured. please pass totp option on two factor plugin to enable totp",
				);
				throw new APIError("BAD_REQUEST", {
					message: "totp isn't configured",
				});
			}
			const user = ctx.context.session.user as UserWithTwoFactor;
			const twoFactor = await ctx.context.adapter.findOne<TwoFactorTable>({
				model: twoFactorTable,
				where: [
					{
						field: "userId",
						value: user.id,
					},
				],
			});
			if (!twoFactor || !user.twoFactorEnabled) {
				throw new APIError("BAD_REQUEST", {
					message: TWO_FACTOR_ERROR_CODES.TOTP_NOT_ENABLED,
				});
			}
			const secret = await symmetricDecrypt({
				key: ctx.context.secret,
				data: twoFactor.secret,
			});
			await ctx.context.password.checkPassword(user.id, ctx);
			const totpURI = createOTP(secret, {
				digits: opts.digits,
				period: opts.period,
			}).url(options?.issuer || ctx.context.appName, user.email);
			return {
				totpURI,
			};
		},
	);

	const verifyTOTP = createAuthEndpoint(
		"/two-factor/verify-totp",
		{
			method: "POST",
			body: z.object({
				code: z.string({
					description: "The otp code to verify",
				}),
				/**
				 * if true, the device will be trusted
				 * for 30 days. It'll be refreshed on
				 * every sign in request within this time.
				 */
				trustDevice: z
					.boolean({
						description:
							"If true, the device will be trusted for 30 days. It'll be refreshed on every sign in request within this time.",
					})
					.optional(),
			}),
			use: [verifyTwoFactorMiddleware],
			metadata: {
				openapi: {
					summary: "Verify two factor TOTP",
					description: "Verify two factor TOTP",
					responses: {
						200: {
							description: "Successful response",
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
			if (options?.disable) {
				ctx.context.logger.error(
					"totp isn't configured. please pass totp option on two factor plugin to enable totp",
				);
				throw new APIError("BAD_REQUEST", {
					message: "totp isn't configured",
				});
			}
			const user = ctx.context.session.user as UserWithTwoFactor;
			const twoFactor = await ctx.context.adapter.findOne<TwoFactorTable>({
				model: twoFactorTable,
				where: [
					{
						field: "userId",
						value: user.id,
					},
				],
			});

			if (!twoFactor) {
				throw new APIError("BAD_REQUEST", {
					message: TWO_FACTOR_ERROR_CODES.TOTP_NOT_ENABLED,
				});
			}
			const decrypted = await symmetricDecrypt({
				key: ctx.context.secret,
				data: twoFactor.secret,
			});
			const status = await createOTP(decrypted, {
				period: opts.period,
				digits: opts.digits,
			}).verify(ctx.body.code);
			if (!status) {
				return ctx.context.invalid();
			}

			if (!user.twoFactorEnabled) {
				const updatedUser = await ctx.context.internalAdapter.updateUser(
					user.id,
					{
						twoFactorEnabled: true,
					},
					ctx,
				);
				const newSession = await ctx.context.internalAdapter
					.createSession(
						user.id,
						ctx.request,
						false,
						ctx.context.session.session,
					)
					.catch((e) => {
						throw e;
					});

				await ctx.context.internalAdapter.deleteSession(
					ctx.context.session.session.token,
				);
				await setSessionCookie(ctx, {
					session: newSession,
					user: updatedUser,
				});
			}
			return ctx.context.valid(ctx);
		},
	);
	return {
		id: "totp",
		endpoints: {
			generateTOTP: generateTOTP,
			getTOTPURI: getTOTPURI,
			verifyTOTP,
		},
	} satisfies TwoFactorProvider;
};

```
