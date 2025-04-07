/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/multi-session/client.ts
```typescript
import type { multiSession } from ".";
import type { BetterAuthClientPlugin } from "../../types";

export const multiSessionClient = () => {
	return {
		id: "multi-session",
		$InferServerPlugin: {} as ReturnType<typeof multiSession>,
		atomListeners: [
			{
				matcher(path) {
					return path === "/multi-session/set-active";
				},
				signal: "$sessionSignal",
			},
		],
	} satisfies BetterAuthClientPlugin;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/multi-session/index.ts
```typescript
import { z } from "zod";
import {
	APIError,
	createAuthEndpoint,
	createAuthMiddleware,
	sessionMiddleware,
} from "../../api";
import {
	deleteSessionCookie,
	parseCookies,
	parseSetCookieHeader,
	setSessionCookie,
} from "../../cookies";
import type { BetterAuthPlugin } from "../../types";

interface MultiSessionConfig {
	/**
	 * The maximum number of sessions a user can have
	 * at a time
	 * @default 5
	 */
	maximumSessions?: number;
}

export const multiSession = (options?: MultiSessionConfig) => {
	const opts = {
		maximumSessions: 5,
		...options,
	};

	const isMultiSessionCookie = (key: string) => key.includes("_multi-");

	const ERROR_CODES = {
		INVALID_SESSION_TOKEN: "Invalid session token",
	} as const;

	return {
		id: "multi-session",
		endpoints: {
			listDeviceSessions: createAuthEndpoint(
				"/multi-session/list-device-sessions",
				{
					method: "GET",
					requireHeaders: true,
				},
				async (ctx) => {
					const cookieHeader = ctx.headers?.get("cookie");
					if (!cookieHeader) return ctx.json([]);

					const cookies = Object.fromEntries(parseCookies(cookieHeader));

					const sessionTokens = (
						await Promise.all(
							Object.entries(cookies)
								.filter(([key]) => isMultiSessionCookie(key))
								.map(
									async ([key]) =>
										await ctx.getSignedCookie(key, ctx.context.secret),
								),
						)
					).filter((v) => v !== null);

					if (!sessionTokens.length) return ctx.json([]);
					const sessions =
						await ctx.context.internalAdapter.findSessions(sessionTokens);
					const validSessions = sessions.filter(
						(session) => session && session.session.expiresAt > new Date(),
					);
					const uniqueUserSessions = validSessions.reduce(
						(acc, session) => {
							if (!acc.find((s) => s.user.id === session.user.id)) {
								acc.push(session);
							}
							return acc;
						},
						[] as typeof validSessions,
					);
					return ctx.json(uniqueUserSessions);
				},
			),
			setActiveSession: createAuthEndpoint(
				"/multi-session/set-active",
				{
					method: "POST",
					body: z.object({
						sessionToken: z.string({
							description: "The session token to set as active",
						}),
					}),
					requireHeaders: true,
					use: [sessionMiddleware],
					metadata: {
						openapi: {
							description: "Set the active session",
							responses: {
								200: {
									description: "Success",
									content: {
										"application/json": {
											schema: {
												type: "object",
												properties: {
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
					const sessionToken = ctx.body.sessionToken;
					const multiSessionCookieName = `${
						ctx.context.authCookies.sessionToken.name
					}_multi-${sessionToken.toLowerCase()}`;
					const sessionCookie = await ctx.getSignedCookie(
						multiSessionCookieName,
						ctx.context.secret,
					);
					if (!sessionCookie) {
						throw new APIError("UNAUTHORIZED", {
							message: ERROR_CODES.INVALID_SESSION_TOKEN,
						});
					}
					const session =
						await ctx.context.internalAdapter.findSession(sessionToken);
					if (!session || session.session.expiresAt < new Date()) {
						ctx.setCookie(multiSessionCookieName, "", {
							...ctx.context.authCookies.sessionToken.options,
							maxAge: 0,
						});
						throw new APIError("UNAUTHORIZED", {
							message: ERROR_CODES.INVALID_SESSION_TOKEN,
						});
					}
					await setSessionCookie(ctx, session);
					return ctx.json(session);
				},
			),
			revokeDeviceSession: createAuthEndpoint(
				"/multi-session/revoke",
				{
					method: "POST",
					body: z.object({
						sessionToken: z.string({
							description: "The session token to revoke",
						}),
					}),
					requireHeaders: true,
					use: [sessionMiddleware],
					metadata: {
						openapi: {
							description: "Revoke a device session",
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
					const sessionToken = ctx.body.sessionToken;
					const multiSessionCookieName = `${
						ctx.context.authCookies.sessionToken.name
					}_multi-${sessionToken.toLowerCase()}`;
					const sessionCookie = await ctx.getSignedCookie(
						multiSessionCookieName,
						ctx.context.secret,
					);
					if (!sessionCookie) {
						throw new APIError("UNAUTHORIZED", {
							message: ERROR_CODES.INVALID_SESSION_TOKEN,
						});
					}

					await ctx.context.internalAdapter.deleteSession(sessionToken);
					ctx.setCookie(multiSessionCookieName, "", {
						...ctx.context.authCookies.sessionToken.options,
						maxAge: 0,
					});
					const isActive = ctx.context.session?.session.token === sessionToken;
					if (!isActive) return ctx.json({ status: true });

					const cookieHeader = ctx.headers?.get("cookie");
					if (cookieHeader) {
						const cookies = Object.fromEntries(parseCookies(cookieHeader));

						const sessionTokens = (
							await Promise.all(
								Object.entries(cookies)
									.filter(([key]) => isMultiSessionCookie(key))
									.map(
										async ([key]) =>
											await ctx.getSignedCookie(key, ctx.context.secret),
									),
							)
						).filter((v): v is string => v !== undefined);
						const internalAdapter = ctx.context.internalAdapter;

						if (sessionTokens.length > 0) {
							const sessions =
								await internalAdapter.findSessions(sessionTokens);
							const validSessions = sessions.filter(
								(session) => session && session.session.expiresAt > new Date(),
							);

							if (validSessions.length > 0) {
								const nextSession = validSessions[0];
								await setSessionCookie(ctx, nextSession);
							} else {
								deleteSessionCookie(ctx);
							}
						} else {
							deleteSessionCookie(ctx);
						}
					} else {
						deleteSessionCookie(ctx);
					}
					return ctx.json({
						status: true,
					});
				},
			),
		},
		hooks: {
			after: [
				{
					matcher: () => true,
					handler: createAuthMiddleware(async (ctx) => {
						const cookieString = ctx.context.responseHeaders?.get("set-cookie");
						if (!cookieString) return;
						const setCookies = parseSetCookieHeader(cookieString);
						const sessionCookieConfig = ctx.context.authCookies.sessionToken;
						const sessionToken = ctx.context.newSession?.session.token;
						if (!sessionToken) return;
						const cookies = parseCookies(ctx.headers?.get("cookie") || "");

						const cookieName = `${
							sessionCookieConfig.name
						}_multi-${sessionToken.toLowerCase()}`;

						if (setCookies.get(cookieName) || cookies.get(cookieName)) return;

						const currentMultiSessions =
							Object.keys(Object.fromEntries(cookies)).filter(
								isMultiSessionCookie,
							).length + (cookieString.includes("session_token") ? 1 : 0);

						if (currentMultiSessions >= opts.maximumSessions) {
							return;
						}

						await ctx.setSignedCookie(
							cookieName,
							sessionToken,
							ctx.context.secret,
							sessionCookieConfig.options,
						);
					}),
				},
				{
					matcher: (context) => context.path === "/sign-out",
					handler: createAuthMiddleware(async (ctx) => {
						const cookieHeader = ctx.headers?.get("cookie");
						if (!cookieHeader) return;
						const cookies = Object.fromEntries(parseCookies(cookieHeader));
						const ids = Object.keys(cookies)
							.map((key) => {
								if (isMultiSessionCookie(key)) {
									ctx.setCookie(key.toLowerCase(), "", {
										...ctx.context.authCookies.sessionToken.options,
										maxAge: 0,
									});
									const token = cookies[key].split(".")[0];
									return token;
								}
								return null;
							})
							.filter((v): v is string => v !== null);
						await ctx.context.internalAdapter.deleteSessions(ids);
					}),
				},
			],
		},
		$ERROR_CODES: ERROR_CODES,
	} satisfies BetterAuthPlugin;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/multi-session/multi-session.test.ts
```typescript
import { describe, expect, it } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";
import { multiSession } from ".";
import { multiSessionClient } from "./client";
import { parseSetCookieHeader } from "../../cookies";

describe("multi-session", async () => {
	const { client, testUser, cookieSetter } = await getTestInstance(
		{
			plugins: [
				multiSession({
					maximumSessions: 2,
				}),
			],
		},
		{
			clientOptions: {
				plugins: [multiSessionClient()],
			},
		},
	);

	let headers = new Headers();
	const testUser2 = {
		email: "second-email@test.com",
		password: "password",
		name: "Name",
	};

	it("should set multi session when there is set-cookie header", async () => {
		await client.signIn.email(
			{
				email: testUser.email,
				password: testUser.password,
			},
			{
				onResponse(context) {
					const setCookieString = context.response.headers.get("set-cookie");
					const setCookies = parseSetCookieHeader(setCookieString || "");
					const sessionToken = setCookies
						.get("better-auth.session_token")
						?.value.split(".")[0];
					const multiSession = setCookies.get(
						`better-auth.session_token_multi-${sessionToken?.toLowerCase()}`,
					)?.value;
					expect(sessionToken).not.toBe(null);
					expect(multiSession).not.toBe(null);
					expect(multiSession).toContain(sessionToken);
					expect(setCookieString).toContain("better-auth.session_token_multi-");
				},
				onSuccess: cookieSetter(headers),
			},
		);
		await client.signUp.email(testUser2, {
			onSuccess: cookieSetter(headers),
		});
	});

	it("should get active session", async () => {
		const session = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(session.data?.user.email).toBe(testUser2.email);
	});

	let sessionToken = "";
	it("should list all device sessions", async () => {
		const res = await client.multiSession.listDeviceSessions({
			fetchOptions: {
				headers,
			},
		});
		if (res.data) {
			sessionToken =
				res.data.find((s) => s.user.email === testUser.email)?.session.token ||
				"";
		}
		expect(res.data).toHaveLength(2);
	});

	it("should set active session", async () => {
		const res = await client.multiSession.setActive({
			sessionToken,
			fetchOptions: {
				headers,
			},
		});
		expect(res.data?.user.email).toBe(testUser.email);
	});

	it("should revoke a session and set the next active", async () => {
		const testUser3 = {
			email: "my-email@email.com",
			password: "password",
			name: "Name",
		};
		let token = "";
		const signUpRes = await client.signUp.email(testUser3, {
			onSuccess: (ctx) => {
				const header = ctx.response.headers.get("set-cookie");
				expect(header).toContain("better-auth.session_token");
				const cookies = parseSetCookieHeader(header || "");
				token =
					cookies.get("better-auth.session_token")?.value.split(".")[0] || "";
			},
		});
		await client.multiSession.revoke(
			{
				fetchOptions: {
					headers,
				},
				sessionToken: token,
			},
			{
				onSuccess(context) {
					expect(context.response.headers.get("set-cookie")).toContain(
						`better-auth.session_token=`,
					);
				},
			},
		);
		const res = await client.multiSession.listDeviceSessions({
			fetchOptions: {
				headers,
			},
		});
		expect(res.data).toHaveLength(2);
	});

	it("should sign-out all sessions", async () => {
		const newHeaders = new Headers();
		await client.signOut({
			fetchOptions: {
				headers,
				onSuccess: cookieSetter(newHeaders),
			},
		});
		const res = await client.multiSession.listDeviceSessions({
			fetchOptions: {
				headers,
			},
		});
		expect(res.data).toHaveLength(0);
		const res2 = await client.multiSession.listDeviceSessions({
			fetchOptions: {
				headers: newHeaders,
			},
		});
		expect(res2.data).toHaveLength(0);
	});
});

```
