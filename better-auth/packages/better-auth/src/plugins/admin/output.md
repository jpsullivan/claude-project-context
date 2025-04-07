/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/admin/admin.test.ts
```typescript
import { describe, expect, it, vi } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";
import { admin, type UserWithRole } from "./admin";
import { adminClient } from "./client";
import { createAccessControl } from "../access";
import { createAuthClient } from "../../client";

describe("Admin plugin", async () => {
	const {
		auth,
		signInWithTestUser,
		signInWithUser,
		cookieSetter,
		customFetchImpl,
	} = await getTestInstance(
		{
			plugins: [
				admin({
					bannedUserMessage: "Custom banned user message",
				}),
			],
			databaseHooks: {
				user: {
					create: {
						before: async (user) => {
							if (user.name === "Admin") {
								return {
									data: {
										...user,
										role: "admin",
									},
								};
							}
						},
					},
				},
			},
		},
		{
			testUser: {
				name: "Admin",
			},
		},
	);
	const client = createAuthClient({
		fetchOptions: {
			customFetchImpl,
		},
		plugins: [adminClient()],
		baseURL: "http://localhost:3000",
	});

	const { headers: adminHeaders } = await signInWithTestUser();
	let newUser: UserWithRole | undefined;
	const testNonAdminUser = {
		email: "user@test.com",
		password: "password",
		name: "Test User",
	};
	await client.signUp.email(testNonAdminUser);
	const { headers: userHeaders } = await signInWithUser(
		testNonAdminUser.email,
		testNonAdminUser.password,
	);

	it("should allow admin to create users", async () => {
		const res = await client.admin.createUser(
			{
				name: "Test User",
				email: "test2@test.com",
				password: "test",
				role: "user",
			},
			{
				headers: adminHeaders,
			},
		);
		newUser = res.data?.user;
		expect(newUser?.role).toBe("user");
	});

	it("should allow admin to create user with multiple roles", async () => {
		const res = await client.admin.createUser(
			{
				name: "Test User mr",
				email: "testmr@test.com",
				password: "test",
				role: ["user", "admin"],
			},
			{
				headers: adminHeaders,
			},
		);
		expect(res.data?.user.role).toBe("user,admin");
		await client.admin.removeUser(
			{
				userId: res.data?.user.id || "",
			},
			{
				headers: adminHeaders,
			},
		);
	});

	it("should not allow non-admin to create users", async () => {
		const res = await client.admin.createUser(
			{
				name: "Test User",
				email: "test2@test.com",
				password: "test",
				role: "user",
			},
			{
				headers: userHeaders,
			},
		);
		expect(res.error?.status).toBe(403);
	});

	it("should allow admin to list users", async () => {
		const res = await client.admin.listUsers({
			query: {
				limit: 2,
			},
			fetchOptions: {
				headers: adminHeaders,
			},
		});
		expect(res.data?.users.length).toBe(2);
	});

	it("should list users with search query", async () => {
		const res = await client.admin.listUsers({
			query: {
				filterField: "role",
				filterOperator: "eq",
				filterValue: "admin",
			},
			fetchOptions: {
				headers: adminHeaders,
			},
		});
		expect(res.data?.total).toBe(1);
	});

	it("should not allow non-admin to list users", async () => {
		const res = await client.admin.listUsers({
			query: {
				limit: 2,
			},
			fetchOptions: {
				headers: userHeaders,
			},
		});
		expect(res.error?.status).toBe(403);
	});

	it("should allow admin to count users", async () => {
		const res = await client.admin.listUsers({
			query: {
				limit: 2,
			},
			fetchOptions: {
				headers: adminHeaders,
			},
		});
		expect(res.data?.users.length).toBe(2);
		expect(res.data?.total).toBe(3);
	});

	it("should allow to sort users by name", async () => {
		const res = await client.admin.listUsers({
			query: {
				sortBy: "name",
				sortDirection: "desc",
			},
			fetchOptions: {
				headers: adminHeaders,
			},
		});

		expect(res.data?.users[0].name).toBe("Test User");

		const res2 = await client.admin.listUsers({
			query: {
				sortBy: "name",
				sortDirection: "asc",
			},
			fetchOptions: {
				headers: adminHeaders,
			},
		});
		expect(res2.data?.users[0].name).toBe("Admin");
	});

	it("should allow offset and limit", async () => {
		const res = await client.admin.listUsers({
			query: {
				limit: 1,
				offset: 1,
			},
			fetchOptions: {
				headers: adminHeaders,
			},
		});
		expect(res.data?.users.length).toBe(1);
		expect(res.data?.users[0].name).toBe("Test User");
	});

	it("should allow to search users by name", async () => {
		const res = await client.admin.listUsers({
			query: {
				searchValue: "Admin",
				searchField: "name",
				searchOperator: "contains",
			},
			fetchOptions: {
				headers: adminHeaders,
			},
		});
		expect(res.data?.users.length).toBe(1);
	});

	it("should allow to filter users by role", async () => {
		const res = await client.admin.listUsers({
			query: {
				filterValue: "admin",
				filterField: "role",
				filterOperator: "eq",
			},
			fetchOptions: {
				headers: adminHeaders,
			},
		});
		expect(res.data?.users.length).toBe(1);
	});

	it("should allow to set user role", async () => {
		const res = await client.admin.setRole(
			{
				userId: newUser?.id || "",
				role: "admin",
			},
			{
				headers: adminHeaders,
			},
		);
		expect(res.data?.user?.role).toBe("admin");
	});

	it("should allow to set multiple user roles", async () => {
		const createdUser = await client.admin.createUser(
			{
				name: "Test User mr",
				email: "testmr@test.com",
				password: "test",
				role: "user",
			},
			{
				headers: adminHeaders,
			},
		);
		expect(createdUser.data?.user.role).toBe("user");
		const res = await client.admin.setRole(
			{
				userId: createdUser.data?.user.id || "",
				role: ["user", "admin"],
			},
			{
				headers: adminHeaders,
			},
		);
		expect(res.data?.user?.role).toBe("user,admin");
		await client.admin.removeUser(
			{
				userId: createdUser.data?.user.id || "",
			},
			{
				headers: adminHeaders,
			},
		);
	});

	it("should not allow non-admin to set user role", async () => {
		const res = await client.admin.setRole(
			{
				userId: newUser?.id || "",
				role: "admin",
			},
			{
				headers: userHeaders,
			},
		);
		expect(res.error?.status).toBe(403);
	});

	it("should allow to ban user", async () => {
		const res = await client.admin.banUser(
			{
				userId: newUser?.id || "",
			},
			{
				headers: adminHeaders,
			},
		);
		expect(res.data?.user?.banned).toBe(true);
	});

	it("should not allow non-admin to ban user", async () => {
		const res = await client.admin.banUser(
			{
				userId: newUser?.id || "",
			},
			{
				headers: userHeaders,
			},
		);
		expect(res.error?.status).toBe(403);
	});

	it("should allow to ban user with reason and expiration", async () => {
		const res = await client.admin.banUser(
			{
				userId: newUser?.id || "",
				banReason: "Test reason",
				banExpiresIn: 60 * 60 * 24,
			},
			{
				headers: adminHeaders,
			},
		);
		expect(res.data?.user?.banned).toBe(true);
		expect(res.data?.user?.banReason).toBe("Test reason");
		expect(res.data?.user?.banExpires).toBeDefined();
	});

	it("should not allow banned user to sign in", async () => {
		const res = await client.signIn.email({
			email: newUser?.email || "",
			password: "test",
		});
		expect(res.error?.code).toBe("BANNED_USER");
		expect(res.error?.status).toBe(403);
	});

	it("should change banned user message", async () => {
		const res = await client.signIn.email({
			email: newUser?.email || "",
			password: "test",
		});
		expect(res.error?.message).toBe("Custom banned user message");
	});

	it("should allow banned user to sign in if ban expired", async () => {
		vi.useFakeTimers();
		await vi.advanceTimersByTimeAsync(60 * 60 * 24 * 1000);
		const res = await client.signIn.email({
			email: newUser?.email || "",
			password: "test",
		});
		expect(res.data?.user).toBeDefined();
	});

	it("should allow to unban user", async () => {
		const res = await client.admin.unbanUser(
			{
				userId: newUser?.id || "",
			},
			{
				headers: adminHeaders,
			},
		);

		expect(res.data?.user?.banned).toBe(false);
		expect(res.data?.user?.banExpires).toBeNull();
		expect(res.data?.user?.banReason).toBeNull();
	});

	it("should not allow non-admin to unban user", async () => {
		const res = await client.admin.unbanUser(
			{
				userId: newUser?.id || "",
			},
			{
				headers: userHeaders,
			},
		);
		expect(res.error?.status).toBe(403);
	});

	it("should allow admin to list user sessions", async () => {
		const res = await client.admin.listUserSessions(
			{
				userId: newUser?.id || "",
			},
			{
				headers: adminHeaders,
			},
		);
		expect(res.data?.sessions.length).toBe(1);
	});

	it("should not allow non-admin to list user sessions", async () => {
		const res = await client.admin.listUserSessions(
			{
				userId: newUser?.id || "",
			},
			{
				headers: userHeaders,
			},
		);
		expect(res.error?.status).toBe(403);
	});

	const data = {
		email: "impersonate@mail.com",
		password: "password",
		name: "Impersonate User",
	};

	const impersonateHeaders = new Headers();
	it("should allow admins to impersonate user", async () => {
		const userToImpersonate = await client.signUp.email(data);
		const session = await client.getSession({
			fetchOptions: {
				headers: new Headers({
					Authorization: `Bearer ${userToImpersonate.data?.token}`,
				}),
			},
		});
		const res = await client.admin.impersonateUser(
			{
				userId: session.data?.user.id || "",
			},
			{
				headers: adminHeaders,
				onSuccess: (ctx) => {
					cookieSetter(impersonateHeaders)(ctx);
				},
			},
		);
		expect(res.data?.session).toBeDefined();
		expect(res.data?.user?.id).toBe(session.data?.user.id);
	});

	it("should not allow non-admin to impersonate user", async () => {
		const res = await client.admin.impersonateUser(
			{
				userId: newUser?.id || "",
			},
			{
				headers: userHeaders,
			},
		);
		expect(res.error?.status).toBe(403);
	});

	it("should filter impersonated sessions", async () => {
		const { headers } = await signInWithUser(data.email, data.password);
		const res = await client.listSessions({
			fetchOptions: {
				headers,
			},
		});
		expect(res.data?.length).toBe(2);
	});

	it("should allow admin to stop impersonating", async () => {
		const res = await client.admin.stopImpersonating(
			{},
			{
				headers: impersonateHeaders,
				onSuccess: (ctx) => {
					cookieSetter(impersonateHeaders)(ctx);
				},
			},
		);
		expect(res.data?.session).toBeDefined();

		const afterStopImpersonationRes = await client.admin.listUsers({
			fetchOptions: {
				headers: impersonateHeaders,
			},
			query: {
				filterField: "role",
				filterOperator: "eq",
				filterValue: "admin",
			},
		});
		expect(afterStopImpersonationRes.data?.users.length).toBeGreaterThan(1);
	});

	it("should allow admin to revoke user session", async () => {
		const {
			res: { user },
		} = await signInWithUser(data.email, data.password);
		const sessions = await client.admin.listUserSessions(
			{
				userId: user.id,
			},
			{
				headers: adminHeaders,
			},
		);
		expect(sessions.data?.sessions.length).toBe(4);
		const res = await client.admin.revokeUserSession(
			{ sessionToken: sessions.data?.sessions[0].token || "" },
			{ headers: adminHeaders },
		);
		expect(res.data?.success).toBe(true);
		const sessions2 = await client.admin.listUserSessions(
			{ userId: user?.id || "" },
			{ headers: adminHeaders },
		);
		expect(sessions2.data?.sessions.length).toBe(3);
	});

	it("should not allow non-admin to revoke user sessions", async () => {
		const res = await client.admin.revokeUserSessions(
			{ userId: newUser?.id || "" },
			{ headers: userHeaders },
		);
		expect(res.error?.status).toBe(403);
	});

	it("should allow admin to revoke user sessions", async () => {
		const res = await client.admin.revokeUserSessions(
			{ userId: newUser?.id || "" },
			{ headers: adminHeaders },
		);
		expect(res.data?.success).toBe(true);
		const sessions2 = await client.admin.listUserSessions(
			{ userId: newUser?.id || "" },
			{ headers: adminHeaders },
		);
		expect(sessions2.data?.sessions.length).toBe(0);
	});

	it("should list with me", async () => {
		const response = await client.admin.listUsers({
			query: {
				sortBy: "createdAt",
				sortDirection: "desc",
				filterField: "role",
				filterOperator: "ne",
				filterValue: "user",
			},
			fetchOptions: {
				headers: adminHeaders,
			},
		});
		expect(response.data?.users.length).toBe(2);
		const roles = response.data?.users.map((d) => d.role);
		expect(roles).not.toContain("user");
	});

	it("should allow admin to set user password", async () => {
		const res = await client.admin.setUserPassword(
			{
				userId: newUser?.id || "",
				newPassword: "newPassword",
			},
			{
				headers: adminHeaders,
			},
		);
		expect(res.data?.status).toBe(true);
		const res2 = await client.signIn.email({
			email: newUser?.email || "",
			password: "newPassword",
		});
		expect(res2.data?.user).toBeDefined();
	});

	it("should not allow non-admin to set user password", async () => {
		const res = await client.admin.setUserPassword(
			{
				userId: newUser?.id || "",
				newPassword: "newPassword",
			},
			{
				headers: userHeaders,
			},
		);
		expect(res.error?.status).toBe(403);
	});

	it("should allow admin to delete user", async () => {
		const res = await client.admin.removeUser(
			{
				userId: newUser?.id || "",
			},
			{
				headers: adminHeaders,
			},
		);

		expect(res.data?.success).toBe(true);
	});

	it("should not allow non-admin to delete user", async () => {
		const res = await client.admin.removeUser(
			{ userId: newUser?.id || "" },
			{ headers: userHeaders },
		);
		expect(res.error?.status).toBe(403);
	});

	it("should allow creating users from server", async () => {
		const res = await auth.api.createUser({
			body: {
				email: "test2@test.com",
				password: "password",
				name: "Test User",
			},
		});
		expect(res.user).toMatchObject({
			email: "test2@test.com",
			name: "Test User",
			role: "user",
		});
	});
});

describe("access control", async (it) => {
	const ac = createAccessControl({
		user: ["create", "read", "update", "delete", "list"],
		order: ["create", "read", "update", "delete", "update-many"],
	});

	const adminAc = ac.newRole({
		user: ["create", "read", "update", "delete", "list"],
		order: ["create", "read", "update", "delete"],
	});
	const userAc = ac.newRole({
		user: ["read"],
		order: ["read"],
	});

	const {
		signInWithTestUser,
		signInWithUser,
		cookieSetter,
		auth,
		customFetchImpl,
	} = await getTestInstance(
		{
			plugins: [
				admin({
					ac,
					roles: {
						admin: adminAc,
						user: userAc,
					},
				}),
			],
			databaseHooks: {
				user: {
					create: {
						before: async (user) => {
							if (user.name === "Admin") {
								return {
									data: {
										...user,
										role: "admin",
									},
								};
							}
						},
					},
				},
			},
		},
		{
			testUser: {
				name: "Admin",
			},
		},
	);

	const client = createAuthClient({
		plugins: [
			adminClient({
				ac,
				roles: {
					admin: adminAc,
					user: userAc,
				},
			}),
		],
		baseURL: "http://localhost:3000",
		fetchOptions: {
			customFetchImpl,
		},
	});

	const { headers, user } = await signInWithTestUser();

	it("should validate on the client", async () => {
		const canCreateOrder = client.admin.checkRolePermission({
			role: "admin",
			permission: {
				order: ["create"],
			},
		});
		expect(canCreateOrder).toBe(true);

		const canCreateUser = client.admin.checkRolePermission({
			role: "user",
			permission: {
				user: ["create"],
			},
		});
		expect(canCreateUser).toBe(false);
	});

	it("should validate using userId", async () => {
		const canCreateUser = await auth.api.userHasPermission({
			body: {
				userId: user.id,
				permission: {
					user: ["create"],
				},
			},
		});
		expect(canCreateUser.success).toBe(true);
		const canUpdateManyOrder = await auth.api.userHasPermission({
			body: {
				userId: user.id,
				permission: {
					order: ["update-many"],
				},
			},
		});
		expect(canUpdateManyOrder.success).toBe(false);
	});

	it("should validate using role", async () => {
		const canCreateUser = await auth.api.userHasPermission({
			body: {
				role: "admin",
				permission: {
					user: ["create"],
				},
			},
		});
		expect(canCreateUser.success).toBe(true);
		const canUpdateOrder = await auth.api.userHasPermission({
			body: {
				role: "user",
				permission: {
					order: ["update"],
				},
			},
		});
		expect(canUpdateOrder.success).toBe(false);
	});

	it("shouldn't allow to list users", async () => {
		const { headers } = await signInWithTestUser();
		const adminRes = await client.admin.listUsers({
			query: {
				limit: 2,
			},
			fetchOptions: {
				headers,
			},
		});
		expect(adminRes.data?.users.length).toBe(1);
		const userHeaders = new Headers();
		await client.signUp.email(
			{
				email: "test2@test.com",
				password: "password",
				name: "Test User",
			},
			{
				onSuccess: cookieSetter(userHeaders),
			},
		);
		const userRes = await client.admin.listUsers({
			query: {
				limit: 2,
			},
			fetchOptions: {
				headers: userHeaders,
			},
		});
		expect(userRes.error?.status).toBe(403);
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/admin/admin.ts
```typescript
import { z } from "zod";
import {
	APIError,
	createAuthEndpoint,
	createAuthMiddleware,
	getSessionFromCtx,
} from "../../api";
import {
	type BetterAuthPlugin,
	type InferOptionSchema,
	type AuthPluginSchema,
	type Session,
	type User,
	type Where,
} from "../../types";
import { deleteSessionCookie, setSessionCookie } from "../../cookies";
import { getDate } from "../../utils/date";
import { getEndpointResponse } from "../../utils/plugin-helper";
import { mergeSchema } from "../../db/schema";
import { type AccessControl, type Role } from "../access";
import { ADMIN_ERROR_CODES } from "./error-codes";
import { defaultStatements } from "./access";
import { hasPermission } from "./has-permission";

export interface UserWithRole extends User {
	role?: string;
	banned?: boolean | null;
	banReason?: string | null;
	banExpires?: Date | null;
}

export interface SessionWithImpersonatedBy extends Session {
	impersonatedBy?: string;
}

export interface AdminOptions {
	/**
	 * The default role for a user
	 *
	 * @default "user"
	 */
	defaultRole?: string;
	/**
	 * Roles that are considered admin roles.
	 *
	 * Any user role that isn't in this list, even if they have the permission,
	 * will not be considered an admin.
	 *
	 * @default ["admin"]
	 */
	adminRoles?: string | string[];
	/**
	 * A default ban reason
	 *
	 * By default, no reason is provided
	 */
	defaultBanReason?: string;
	/**
	 * Number of seconds until the ban expires
	 *
	 * By default, the ban never expires
	 */
	defaultBanExpiresIn?: number;
	/**
	 * Duration of the impersonation session in seconds
	 *
	 * By default, the impersonation session lasts 1 hour
	 */
	impersonationSessionDuration?: number;
	/**
	 * Custom schema for the admin plugin
	 */
	schema?: InferOptionSchema<typeof schema>;
	/**
	 * Configure the roles and permissions for the admin
	 * plugin.
	 */
	ac?: AccessControl;
	/**
	 * Custom permissions for roles.
	 */
	roles?: {
		[key in string]?: Role;
	};
	/**
	 * List of user ids that should have admin access
	 *
	 * If this is set, the `adminRole` option is ignored
	 */
	adminUserIds?: string[];
	/**
	 * Message to show when a user is banned
	 *
	 * By default, the message is "You have been banned from this application"
	 */
	bannedUserMessage?: string;
}

export type InferAdminRolesFromOption<O extends AdminOptions | undefined> =
	O extends { roles: Record<string, unknown> }
		? keyof O["roles"]
		: "user" | "admin";

function parseRoles(roles: string | string[]): string {
	return Array.isArray(roles) ? roles.join(",") : roles;
}

export const admin = <O extends AdminOptions>(options?: O) => {
	const opts = {
		defaultRole: options?.defaultRole ?? "user",
		adminRoles: options?.adminRoles ?? ["admin"],
		bannedUserMessage:
			options?.bannedUserMessage ??
			"You have been banned from this application. Please contact support if you believe this is an error.",
		...options,
	};
	type DefaultStatements = typeof defaultStatements;
	type Statements = O["ac"] extends AccessControl<infer S>
		? S
		: DefaultStatements;

	const adminMiddleware = createAuthMiddleware(async (ctx) => {
		const session = await getSessionFromCtx(ctx);
		if (!session) {
			throw new APIError("UNAUTHORIZED");
		}
		return {
			session,
		} as {
			session: {
				user: UserWithRole;
				session: Session;
			};
		};
	});

	return {
		id: "admin",
		init(ctx) {
			return {
				options: {
					databaseHooks: {
						user: {
							create: {
								async before(user) {
									return {
										data: {
											role: options?.defaultRole ?? "user",
											...user,
										},
									};
								},
							},
						},
						session: {
							create: {
								async before(session) {
									const user = (await ctx.internalAdapter.findUserById(
										session.userId,
									)) as UserWithRole;

									if (user.banned) {
										if (
											user.banExpires &&
											user.banExpires.getTime() < Date.now()
										) {
											await ctx.internalAdapter.updateUser(session.userId, {
												banned: false,
												banReason: null,
												banExpires: null,
											});
											return;
										}

										throw new APIError("FORBIDDEN", {
											message: opts.bannedUserMessage,
											code: "BANNED_USER",
										});
									}
								},
							},
						},
					},
				},
			};
		},
		hooks: {
			after: [
				{
					matcher(context) {
						return context.path === "/list-sessions";
					},
					handler: createAuthMiddleware(async (ctx) => {
						const response =
							await getEndpointResponse<SessionWithImpersonatedBy[]>(ctx);

						if (!response) {
							return;
						}
						const newJson = response.filter((session) => {
							return !session.impersonatedBy;
						});

						return ctx.json(newJson);
					}),
				},
			],
		},
		endpoints: {
			setRole: createAuthEndpoint(
				"/admin/set-role",
				{
					method: "POST",
					body: z.object({
						userId: z.coerce.string({
							description: "The user id",
						}),
						role: z.union([
							z.string({
								description: "The role to set. `admin` or `user` by default",
							}),
							z.array(
								z.string({
									description: "The roles to set. `admin` or `user` by default",
								}),
							),
						]),
					}),
					use: [adminMiddleware],
					metadata: {
						openapi: {
							operationId: "setRole",
							summary: "Set the role of a user",
							description: "Set the role of a user",
							responses: {
								200: {
									description: "User role updated",
									content: {
										"application/json": {
											schema: {
												type: "object",
												properties: {
													user: {
														$ref: "#/components/schemas/User",
													},
												},
											},
										},
									},
								},
							},
						},
						$Infer: {
							body: {} as {
								userId: string;
								role:
									| InferAdminRolesFromOption<O>
									| InferAdminRolesFromOption<O>[];
							},
						},
					},
				},
				async (ctx) => {
					const canSetRole = hasPermission({
						userId: ctx.context.session.user.id,
						role: ctx.context.session.user.role,
						options: opts,
						permission: {
							user: ["set-role"],
						},
					});
					if (!canSetRole) {
						throw new APIError("FORBIDDEN", {
							message:
								ADMIN_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_CHANGE_USERS_ROLE,
						});
					}

					const updatedUser = await ctx.context.internalAdapter.updateUser(
						ctx.body.userId,
						{
							role: parseRoles(ctx.body.role),
						},
						ctx,
					);
					return ctx.json({
						user: updatedUser as UserWithRole,
					});
				},
			),
			createUser: createAuthEndpoint(
				"/admin/create-user",
				{
					method: "POST",
					body: z.object({
						email: z.string({
							description: "The email of the user",
						}),
						password: z.string({
							description: "The password of the user",
						}),
						name: z.string({
							description: "The name of the user",
						}),
						role: z
							.union([
								z.string({
									description: "The role of the user",
								}),
								z.array(
									z.string({
										description: "The roles of user",
									}),
								),
							])
							.optional(),
						/**
						 * extra fields for user
						 */
						data: z.optional(
							z.record(z.any(), {
								description:
									"Extra fields for the user. Including custom additional fields.",
							}),
						),
					}),
					metadata: {
						openapi: {
							operationId: "createUser",
							summary: "Create a new user",
							description: "Create a new user",
							responses: {
								200: {
									description: "User created",
									content: {
										"application/json": {
											schema: {
												type: "object",
												properties: {
													user: {
														$ref: "#/components/schemas/User",
													},
												},
											},
										},
									},
								},
							},
						},
						$Infer: {
							body: {} as {
								email: string;
								password: string;
								name: string;
								role?:
									| InferAdminRolesFromOption<O>
									| InferAdminRolesFromOption<O>[];
								data?: Record<string, any>;
							},
						},
					},
				},
				async (ctx) => {
					const session = await getSessionFromCtx<{ role: string }>(ctx);
					if (!session && (ctx.request || ctx.headers)) {
						throw ctx.error("UNAUTHORIZED");
					}
					if (session) {
						const canCreateUser = hasPermission({
							userId: session.user.id,
							role: session.user.role,
							options: opts,
							permission: {
								user: ["create"],
							},
						});
						if (!canCreateUser) {
							throw new APIError("FORBIDDEN", {
								message: ADMIN_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_CREATE_USERS,
							});
						}
					}
					const existUser = await ctx.context.internalAdapter.findUserByEmail(
						ctx.body.email,
					);
					if (existUser) {
						throw new APIError("BAD_REQUEST", {
							message: ADMIN_ERROR_CODES.USER_ALREADY_EXISTS,
						});
					}
					const user =
						await ctx.context.internalAdapter.createUser<UserWithRole>({
							email: ctx.body.email,
							name: ctx.body.name,
							role:
								(ctx.body.role && parseRoles(ctx.body.role)) ??
								options?.defaultRole ??
								"user",
							...ctx.body.data,
						});

					if (!user) {
						throw new APIError("INTERNAL_SERVER_ERROR", {
							message: ADMIN_ERROR_CODES.FAILED_TO_CREATE_USER,
						});
					}
					const hashedPassword = await ctx.context.password.hash(
						ctx.body.password,
					);
					await ctx.context.internalAdapter.linkAccount(
						{
							accountId: user.id,
							providerId: "credential",
							password: hashedPassword,
							userId: user.id,
						},
						ctx,
					);
					return ctx.json({
						user: user as UserWithRole,
					});
				},
			),
			listUsers: createAuthEndpoint(
				"/admin/list-users",
				{
					method: "GET",
					use: [adminMiddleware],
					query: z.object({
						searchValue: z
							.string({
								description: "The value to search for",
							})
							.optional(),
						searchField: z
							.enum(["email", "name"], {
								description:
									"The field to search in, defaults to email. Can be `email` or `name`",
							})
							.optional(),
						searchOperator: z
							.enum(["contains", "starts_with", "ends_with"], {
								description:
									"The operator to use for the search. Can be `contains`, `starts_with` or `ends_with`",
							})
							.optional(),
						limit: z
							.string({
								description: "The number of users to return",
							})
							.or(z.number())
							.optional(),
						offset: z
							.string({
								description: "The offset to start from",
							})
							.or(z.number())
							.optional(),
						sortBy: z
							.string({
								description: "The field to sort by",
							})
							.optional(),
						sortDirection: z
							.enum(["asc", "desc"], {
								description: "The direction to sort by",
							})
							.optional(),
						filterField: z
							.string({
								description: "The field to filter by",
							})
							.optional(),
						filterValue: z
							.string({
								description: "The value to filter by",
							})
							.or(z.number())
							.or(z.boolean())
							.optional(),
						filterOperator: z
							.enum(["eq", "ne", "lt", "lte", "gt", "gte"], {
								description: "The operator to use for the filter",
							})
							.optional(),
					}),
					metadata: {
						openapi: {
							operationId: "listUsers",
							summary: "List users",
							description: "List users",
							responses: {
								200: {
									description: "List of users",
									content: {
										"application/json": {
											schema: {
												type: "object",
												properties: {
													users: {
														type: "array",
														items: {
															$ref: "#/components/schemas/User",
														},
													},
													total: {
														type: "number",
													},
													limit: {
														type: "number",
													},
													offset: {
														type: "number",
													},
												},
												required: ["users", "total"],
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
					const canListUsers = hasPermission({
						userId: ctx.context.session.user.id,
						role: session.user.role,
						options: opts,
						permission: {
							user: ["list"],
						},
					});
					if (!canListUsers) {
						throw new APIError("FORBIDDEN", {
							message: ADMIN_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_LIST_USERS,
						});
					}

					const where: Where[] = [];

					if (ctx.query?.searchValue) {
						where.push({
							field: ctx.query.searchField || "email",
							operator: ctx.query.searchOperator || "contains",
							value: ctx.query.searchValue,
						});
					}

					if (ctx.query?.filterValue) {
						where.push({
							field: ctx.query.filterField || "email",
							operator: ctx.query.filterOperator || "eq",
							value: ctx.query.filterValue,
						});
					}

					try {
						const users = await ctx.context.internalAdapter.listUsers(
							Number(ctx.query?.limit) || undefined,
							Number(ctx.query?.offset) || undefined,
							ctx.query?.sortBy
								? {
										field: ctx.query.sortBy,
										direction: ctx.query.sortDirection || "asc",
									}
								: undefined,
							where.length ? where : undefined,
						);
						const total = await ctx.context.internalAdapter.countTotalUsers(
							where.length ? where : undefined,
						);
						return ctx.json({
							users: users as UserWithRole[],
							total: total,
							limit: Number(ctx.query?.limit) || undefined,
							offset: Number(ctx.query?.offset) || undefined,
						});
					} catch (e) {
						return ctx.json({
							users: [],
							total: 0,
						});
					}
				},
			),
			listUserSessions: createAuthEndpoint(
				"/admin/list-user-sessions",
				{
					method: "POST",
					use: [adminMiddleware],
					body: z.object({
						userId: z.coerce.string({
							description: "The user id",
						}),
					}),
					metadata: {
						openapi: {
							operationId: "listUserSessions",
							summary: "List user sessions",
							description: "List user sessions",
							responses: {
								200: {
									description: "List of user sessions",
									content: {
										"application/json": {
											schema: {
												type: "object",
												properties: {
													sessions: {
														type: "array",
														items: {
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
				},
				async (ctx) => {
					const session = ctx.context.session;
					const canListSessions = hasPermission({
						userId: ctx.context.session.user.id,
						role: session.user.role,
						options: opts,
						permission: {
							session: ["list"],
						},
					});
					if (!canListSessions) {
						throw new APIError("FORBIDDEN", {
							message:
								ADMIN_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_LIST_USERS_SESSIONS,
						});
					}

					const sessions = await ctx.context.internalAdapter.listSessions(
						ctx.body.userId,
					);
					return {
						sessions: sessions,
					};
				},
			),
			unbanUser: createAuthEndpoint(
				"/admin/unban-user",
				{
					method: "POST",
					body: z.object({
						userId: z.coerce.string({
							description: "The user id",
						}),
					}),
					use: [adminMiddleware],
					metadata: {
						openapi: {
							operationId: "unbanUser",
							summary: "Unban a user",
							description: "Unban a user",
							responses: {
								200: {
									description: "User unbanned",
									content: {
										"application/json": {
											schema: {
												type: "object",
												properties: {
													user: {
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
					const session = ctx.context.session;
					const canBanUser = hasPermission({
						userId: ctx.context.session.user.id,
						role: session.user.role,
						options: opts,
						permission: {
							user: ["ban"],
						},
					});
					if (!canBanUser) {
						throw new APIError("FORBIDDEN", {
							message: ADMIN_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_BAN_USERS,
						});
					}

					const user = await ctx.context.internalAdapter.updateUser(
						ctx.body.userId,
						{
							banned: false,
							banExpires: null,
							banReason: null,
						},
					);
					return ctx.json({
						user: user,
					});
				},
			),
			banUser: createAuthEndpoint(
				"/admin/ban-user",
				{
					method: "POST",
					body: z.object({
						userId: z.coerce.string({
							description: "The user id",
						}),
						/**
						 * Reason for the ban
						 */
						banReason: z
							.string({
								description: "The reason for the ban",
							})
							.optional(),
						/**
						 * Number of seconds until the ban expires
						 */
						banExpiresIn: z
							.number({
								description: "The number of seconds until the ban expires",
							})
							.optional(),
					}),
					use: [adminMiddleware],
					metadata: {
						openapi: {
							operationId: "banUser",
							summary: "Ban a user",
							description: "Ban a user",
							responses: {
								200: {
									description: "User banned",
									content: {
										"application/json": {
											schema: {
												type: "object",
												properties: {
													user: {
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
					const session = ctx.context.session;
					const canBanUser = hasPermission({
						userId: ctx.context.session.user.id,
						role: session.user.role,
						options: opts,
						permission: {
							user: ["ban"],
						},
					});
					if (!canBanUser) {
						throw new APIError("FORBIDDEN", {
							message: ADMIN_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_BAN_USERS,
						});
					}

					if (ctx.body.userId === ctx.context.session.user.id) {
						throw new APIError("BAD_REQUEST", {
							message: ADMIN_ERROR_CODES.YOU_CANNOT_BAN_YOURSELF,
						});
					}
					const user = await ctx.context.internalAdapter.updateUser(
						ctx.body.userId,
						{
							banned: true,
							banReason:
								ctx.body.banReason || options?.defaultBanReason || "No reason",
							banExpires: ctx.body.banExpiresIn
								? getDate(ctx.body.banExpiresIn, "sec")
								: options?.defaultBanExpiresIn
									? getDate(options.defaultBanExpiresIn, "sec")
									: undefined,
						},
						ctx,
					);
					//revoke all sessions
					await ctx.context.internalAdapter.deleteSessions(ctx.body.userId);
					return ctx.json({
						user: user,
					});
				},
			),
			impersonateUser: createAuthEndpoint(
				"/admin/impersonate-user",
				{
					method: "POST",
					body: z.object({
						userId: z.coerce.string({
							description: "The user id",
						}),
					}),
					use: [adminMiddleware],
					metadata: {
						openapi: {
							operationId: "impersonateUser",
							summary: "Impersonate a user",
							description: "Impersonate a user",
							responses: {
								200: {
									description: "Impersonation session created",
									content: {
										"application/json": {
											schema: {
												type: "object",
												properties: {
													session: {
														$ref: "#/components/schemas/Session",
													},
													user: {
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
					const canImpersonateUser = hasPermission({
						userId: ctx.context.session.user.id,
						role: ctx.context.session.user.role,
						options: opts,
						permission: {
							user: ["impersonate"],
						},
					});
					if (!canImpersonateUser) {
						throw new APIError("FORBIDDEN", {
							message:
								ADMIN_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_IMPERSONATE_USERS,
						});
					}

					const targetUser = await ctx.context.internalAdapter.findUserById(
						ctx.body.userId,
					);

					if (!targetUser) {
						throw new APIError("NOT_FOUND", {
							message: "User not found",
						});
					}

					const session = await ctx.context.internalAdapter.createSession(
						targetUser.id,
						undefined,
						true,
						{
							impersonatedBy: ctx.context.session.user.id,
							expiresAt: options?.impersonationSessionDuration
								? getDate(options.impersonationSessionDuration, "sec")
								: getDate(60 * 60, "sec"), // 1 hour
						},
						ctx,
						true,
					);
					if (!session) {
						throw new APIError("INTERNAL_SERVER_ERROR", {
							message: ADMIN_ERROR_CODES.FAILED_TO_CREATE_USER,
						});
					}
					const authCookies = ctx.context.authCookies;
					deleteSessionCookie(ctx);
					await ctx.setSignedCookie(
						"admin_session",
						ctx.context.session.session.token,
						ctx.context.secret,
						authCookies.sessionToken.options,
					);
					await setSessionCookie(
						ctx,
						{
							session: session,
							user: targetUser,
						},
						true,
					);
					return ctx.json({
						session: session,
						user: targetUser,
					});
				},
			),
			stopImpersonating: createAuthEndpoint(
				"/admin/stop-impersonating",
				{
					method: "POST",
				},
				async (ctx) => {
					const session = await getSessionFromCtx<
						{},
						{
							impersonatedBy: string;
						}
					>(ctx);
					if (!session) {
						throw new APIError("UNAUTHORIZED");
					}
					if (!session.session.impersonatedBy) {
						throw new APIError("BAD_REQUEST", {
							message: "You are not impersonating anyone",
						});
					}
					const user = await ctx.context.internalAdapter.findUserById(
						session.session.impersonatedBy,
					);
					if (!user) {
						throw new APIError("INTERNAL_SERVER_ERROR", {
							message: "Failed to find user",
						});
					}
					const adminCookie = await ctx.getSignedCookie(
						"admin_session",
						ctx.context.secret,
					);
					if (!adminCookie) {
						throw new APIError("INTERNAL_SERVER_ERROR", {
							message: "Failed to find admin session",
						});
					}
					const adminSession =
						await ctx.context.internalAdapter.findSession(adminCookie);
					if (!adminSession || adminSession.session.userId !== user.id) {
						throw new APIError("INTERNAL_SERVER_ERROR", {
							message: "Failed to find admin session",
						});
					}
					await setSessionCookie(ctx, adminSession);
					return ctx.json(adminSession);
				},
			),
			revokeUserSession: createAuthEndpoint(
				"/admin/revoke-user-session",
				{
					method: "POST",
					body: z.object({
						sessionToken: z.string({
							description: "The session token",
						}),
					}),
					use: [adminMiddleware],
					metadata: {
						openapi: {
							operationId: "revokeUserSession",
							summary: "Revoke a user session",
							description: "Revoke a user session",
							responses: {
								200: {
									description: "Session revoked",
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
					const session = ctx.context.session;
					const canRevokeSession = hasPermission({
						userId: ctx.context.session.user.id,
						role: session.user.role,
						options: opts,
						permission: {
							session: ["revoke"],
						},
					});
					if (!canRevokeSession) {
						throw new APIError("FORBIDDEN", {
							message:
								ADMIN_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_REVOKE_USERS_SESSIONS,
						});
					}

					await ctx.context.internalAdapter.deleteSession(
						ctx.body.sessionToken,
					);
					return ctx.json({
						success: true,
					});
				},
			),
			revokeUserSessions: createAuthEndpoint(
				"/admin/revoke-user-sessions",
				{
					method: "POST",
					body: z.object({
						userId: z.coerce.string({
							description: "The user id",
						}),
					}),
					use: [adminMiddleware],
					metadata: {
						openapi: {
							operationId: "revokeUserSessions",
							summary: "Revoke all user sessions",
							description: "Revoke all user sessions",
							responses: {
								200: {
									description: "Sessions revoked",
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
					const session = ctx.context.session;
					const canRevokeSession = hasPermission({
						userId: ctx.context.session.user.id,
						role: session.user.role,
						options: opts,
						permission: {
							session: ["revoke"],
						},
					});
					if (!canRevokeSession) {
						throw new APIError("FORBIDDEN", {
							message:
								ADMIN_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_REVOKE_USERS_SESSIONS,
						});
					}

					await ctx.context.internalAdapter.deleteSessions(ctx.body.userId);
					return ctx.json({
						success: true,
					});
				},
			),
			removeUser: createAuthEndpoint(
				"/admin/remove-user",
				{
					method: "POST",
					body: z.object({
						userId: z.coerce.string({
							description: "The user id",
						}),
					}),
					use: [adminMiddleware],
					metadata: {
						openapi: {
							operationId: "removeUser",
							summary: "Remove a user",
							description:
								"Delete a user and all their sessions and accounts. Cannot be undone.",
							responses: {
								200: {
									description: "User removed",
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
					const session = ctx.context.session;
					const canDeleteUser = hasPermission({
						userId: ctx.context.session.user.id,
						role: session.user.role,
						options: opts,
						permission: {
							user: ["delete"],
						},
					});
					if (!canDeleteUser) {
						throw new APIError("FORBIDDEN", {
							message: ADMIN_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_DELETE_USERS,
						});
					}
					await ctx.context.internalAdapter.deleteUser(ctx.body.userId);
					return ctx.json({
						success: true,
					});
				},
			),
			setUserPassword: createAuthEndpoint(
				"/admin/set-user-password",
				{
					method: "POST",
					body: z.object({
						newPassword: z.string({
							description: "The new password",
						}),
						userId: z.coerce.string({
							description: "The user id",
						}),
					}),
					use: [adminMiddleware],
					metadata: {
						openapi: {
							operationId: "setUserPassword",
							summary: "Set a user's password",
							description: "Set a user's password",
							responses: {
								200: {
									description: "Password set",
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
					const canSetUserPassword = hasPermission({
						userId: ctx.context.session.user.id,
						role: ctx.context.session.user.role,
						options: opts,
						permission: {
							user: ["set-password"],
						},
					});
					if (!canSetUserPassword) {
						throw new APIError("FORBIDDEN", {
							message:
								ADMIN_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_SET_USERS_PASSWORD,
						});
					}
					const hashedPassword = await ctx.context.password.hash(
						ctx.body.newPassword,
					);
					await ctx.context.internalAdapter.updatePassword(
						ctx.body.userId,
						hashedPassword,
					);
					return ctx.json({
						status: true,
					});
				},
			),
			userHasPermission: createAuthEndpoint(
				"/admin/has-permission",
				{
					method: "POST",
					body: z.object({
						permission: z.record(z.string(), z.array(z.string())),
						userId: z.coerce.string().optional(),
						role: z.string().optional(),
					}),
					metadata: {
						openapi: {
							description: "Check if the user has permission",
							requestBody: {
								content: {
									"application/json": {
										schema: {
											type: "object",
											properties: {
												permission: {
													type: "object",
													description: "The permission to check",
												},
											},
											required: ["permission"],
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
													error: {
														type: "string",
													},
													success: {
														type: "boolean",
													},
												},
												required: ["success"],
											},
										},
									},
								},
							},
						},
						$Infer: {
							body: {} as {
								permission: {
									//@ts-expect-error
									[key in keyof Statements]?: Array<Statements[key][number]>;
								};
								userId?: string;
								role?: InferAdminRolesFromOption<O>;
							},
						},
					},
				},
				async (ctx) => {
					if (
						!ctx.body.permission ||
						Object.keys(ctx.body.permission).length > 1
					) {
						throw new APIError("BAD_REQUEST", {
							message:
								"invalid permission check. you can only check one resource permission at a time.",
						});
					}
					const session = await getSessionFromCtx(ctx);

					if (
						!session &&
						(ctx.request || ctx.headers) &&
						!ctx.body.userId &&
						!ctx.body.role
					) {
						throw new APIError("UNAUTHORIZED");
					}
					const user =
						session?.user ||
						((await ctx.context.internalAdapter.findUserById(
							ctx.body.userId as string,
						)) as { role?: string; id: string }) ||
						(ctx.body.role ? { id: "", role: ctx.body.role } : null);
					if (!user) {
						throw new APIError("BAD_REQUEST", {
							message: "user not found",
						});
					}
					const result = hasPermission({
						userId: user.id,
						role: user.role,
						options: options as AdminOptions,
						permission: ctx.body.permission as any,
					});
					return ctx.json({
						error: null,
						success: result,
					});
				},
			),
		},
		$ERROR_CODES: ADMIN_ERROR_CODES,
		schema: mergeSchema(schema, opts.schema),
	} satisfies BetterAuthPlugin;
};

const schema = {
	user: {
		fields: {
			role: {
				type: "string",
				required: false,
				input: false,
			},
			banned: {
				type: "boolean",
				defaultValue: false,
				required: false,
				input: false,
			},
			banReason: {
				type: "string",
				required: false,
				input: false,
			},
			banExpires: {
				type: "date",
				required: false,
				input: false,
			},
		},
	},
	session: {
		fields: {
			impersonatedBy: {
				type: "string",
				required: false,
			},
		},
	},
} satisfies AuthPluginSchema;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/admin/client.ts
```typescript
import { BetterAuthError } from "../../error";
import type { BetterAuthClientPlugin } from "../../types";
import { type AccessControl, type Role } from "../access";
import { adminAc, defaultStatements, userAc } from "./access";
import type { admin } from "./admin";
import { hasPermission } from "./has-permission";

interface AdminClientOptions {
	ac?: AccessControl;
	roles?: {
		[key in string]: Role;
	};
}

export const adminClient = <O extends AdminClientOptions>(options?: O) => {
	type DefaultStatements = typeof defaultStatements;
	type Statements = O["ac"] extends AccessControl<infer S>
		? S
		: DefaultStatements;
	const roles = {
		admin: adminAc,
		user: userAc,
		...options?.roles,
	};

	return {
		id: "admin-client",
		$InferServerPlugin: {} as ReturnType<
			typeof admin<{
				ac: O["ac"] extends AccessControl
					? O["ac"]
					: AccessControl<DefaultStatements>;
				roles: O["roles"] extends Record<string, Role>
					? O["roles"]
					: {
							admin: Role;
							user: Role;
						};
			}>
		>,
		getActions: ($fetch) => ({
			admin: {
				checkRolePermission: <
					R extends O extends { roles: any }
						? keyof O["roles"]
						: "admin" | "user",
				>(data: {
					role: R;
					permission: {
						//@ts-expect-error fix this later
						[key in keyof Statements]?: Statements[key][number][];
					};
				}) => {
					if (Object.keys(data.permission).length > 1) {
						throw new BetterAuthError(
							"you can only check one resource permission at a time.",
						);
					}
					const isAuthorized = hasPermission({
						role: data.role as string,
						options: {
							ac: options?.ac,
							roles: roles,
						},
						permission: data.permission as any,
					});
					return isAuthorized;
				},
			},
		}),
		pathMethods: {
			"/admin/list-users": "GET",
			"/admin/stop-impersonating": "POST",
		},
	} satisfies BetterAuthClientPlugin;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/admin/error-codes.ts
```typescript
export const ADMIN_ERROR_CODES = {
	FAILED_TO_CREATE_USER: "Failed to create user",
	USER_ALREADY_EXISTS: "User already exists",
	YOU_CANNOT_BAN_YOURSELF: "You cannot ban yourself",
	YOU_ARE_NOT_ALLOWED_TO_CHANGE_USERS_ROLE:
		"You are not allowed to change users role",
	YOU_ARE_NOT_ALLOWED_TO_CREATE_USERS: "You are not allowed to create users",
	YOU_ARE_NOT_ALLOWED_TO_LIST_USERS: "You are not allowed to list users",
	YOU_ARE_NOT_ALLOWED_TO_LIST_USERS_SESSIONS:
		"You are not allowed to list users sessions",
	YOU_ARE_NOT_ALLOWED_TO_BAN_USERS: "You are not allowed to ban users",
	YOU_ARE_NOT_ALLOWED_TO_IMPERSONATE_USERS:
		"You are not allowed to impersonate users",
	YOU_ARE_NOT_ALLOWED_TO_REVOKE_USERS_SESSIONS:
		"You are not allowed to revoke users sessions",
	YOU_ARE_NOT_ALLOWED_TO_DELETE_USERS: "You are not allowed to delete users",
	YOU_ARE_NOT_ALLOWED_TO_SET_USERS_PASSWORD:
		"You are not allowed to set users password",
	BANNED_USER: "You have been banned from this application",
} as const;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/admin/has-permission.ts
```typescript
import { defaultRoles } from "./access";
import type { AdminOptions } from "./admin";

export const hasPermission = (input: {
	userId?: string;
	role?: string;
	options?: AdminOptions;
	permission: {
		[key: string]: string[];
	};
}) => {
	if (input.userId && input.options?.adminUserIds?.includes(input.userId)) {
		return true;
	}
	const roles = (input.role || input.options?.defaultRole || "user").split(",");
	const acRoles = input.options?.roles || defaultRoles;
	for (const role of roles) {
		const _role = acRoles[role as keyof typeof acRoles];
		const result = _role?.authorize(input.permission);
		if (result?.success) {
			return true;
		}
	}
	return false;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/admin/index.ts
```typescript
export * from "./admin";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/admin/access/index.ts
```typescript
export * from "./statement";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/admin/access/statement.ts
```typescript
import { createAccessControl } from "../../access";

export const defaultStatements = {
	user: [
		"create",
		"list",
		"set-role",
		"ban",
		"impersonate",
		"delete",
		"set-password",
	],
	session: ["list", "revoke", "delete"],
} as const;

export const defaultAc = createAccessControl(defaultStatements);

export const adminAc = defaultAc.newRole({
	user: [
		"create",
		"list",
		"set-role",
		"ban",
		"impersonate",
		"delete",
		"set-password",
	],
	session: ["list", "revoke", "delete"],
});

export const userAc = defaultAc.newRole({
	user: [],
	session: [],
});

export const defaultRoles = {
	admin: adminAc,
	user: userAc,
};

```
