/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/adapter.ts
```typescript
import type { Session, User } from "../../types";
import { getDate } from "../../utils/date";
import type { OrganizationOptions } from "./organization";
import type {
	Invitation,
	InvitationInput,
	Member,
	MemberInput,
	Organization,
	OrganizationInput,
	Team,
	TeamInput,
} from "./schema";
import { BetterAuthError } from "../../error";
import type { AuthContext } from "../../types";
import parseJSON from "../../client/parser";

export const getOrgAdapter = (
	context: AuthContext,
	options?: OrganizationOptions,
) => {
	const adapter = context.adapter;
	return {
		findOrganizationBySlug: async (slug: string) => {
			const organization = await adapter.findOne<Organization>({
				model: "organization",
				where: [
					{
						field: "slug",
						value: slug,
					},
				],
			});
			return organization;
		},
		createOrganization: async (data: {
			organization: OrganizationInput;
		}) => {
			const organization = await adapter.create<
				OrganizationInput,
				Organization
			>({
				model: "organization",
				data: {
					...data.organization,
					metadata: data.organization.metadata
						? JSON.stringify(data.organization.metadata)
						: undefined,
				},
			});

			return {
				...organization,
				metadata: organization.metadata
					? JSON.parse(organization.metadata)
					: undefined,
			};
		},
		findMemberByEmail: async (data: {
			email: string;
			organizationId: string;
		}) => {
			const user = await adapter.findOne<User>({
				model: "user",
				where: [
					{
						field: "email",
						value: data.email,
					},
				],
			});
			if (!user) {
				return null;
			}
			const member = await adapter.findOne<Member>({
				model: "member",
				where: [
					{
						field: "organizationId",
						value: data.organizationId,
					},
					{
						field: "userId",
						value: user.id,
					},
				],
			});
			if (!member) {
				return null;
			}
			return {
				...member,
				user: {
					id: user.id,
					name: user.name,
					email: user.email,
					image: user.image,
				},
			};
		},
		listMembers: async (data: {
			organizationId: string;
		}) => {
			const members = await adapter.findMany<Member>({
				model: "member",
				where: [
					{
						field: "organizationId",
						value: data.organizationId,
					},
				],
				limit: options?.membershipLimit || 100,
			});
			return members;
		},
		findMemberByOrgId: async (data: {
			userId: string;
			organizationId: string;
		}) => {
			const [member, user] = await Promise.all([
				await adapter.findOne<Member>({
					model: "member",
					where: [
						{
							field: "userId",
							value: data.userId,
						},
						{
							field: "organizationId",
							value: data.organizationId,
						},
					],
				}),
				await adapter.findOne<User>({
					model: "user",
					where: [
						{
							field: "id",
							value: data.userId,
						},
					],
				}),
			]);
			if (!user || !member) {
				return null;
			}
			return {
				...member,
				user: {
					id: user.id,
					name: user.name,
					email: user.email,
					image: user.image,
				},
			};
		},
		findMemberById: async (memberId: string) => {
			const member = await adapter.findOne<Member>({
				model: "member",
				where: [
					{
						field: "id",
						value: memberId,
					},
				],
			});
			if (!member) {
				return null;
			}
			const user = await adapter.findOne<User>({
				model: "user",
				where: [
					{
						field: "id",
						value: member.userId,
					},
				],
			});
			if (!user) {
				return null;
			}
			return {
				...member,
				user: {
					id: user.id,
					name: user.name,
					email: user.email,
					image: user.image,
				},
			};
		},
		createMember: async (data: MemberInput) => {
			const member = await adapter.create<MemberInput, Member>({
				model: "member",
				data: {
					...data,
					createdAt: new Date(),
				},
			});
			return member;
		},
		updateMember: async (memberId: string, role: string) => {
			const member = await adapter.update<Member>({
				model: "member",
				where: [
					{
						field: "id",
						value: memberId,
					},
				],
				update: {
					role,
				},
			});
			return member;
		},
		deleteMember: async (memberId: string) => {
			const member = await adapter.delete<Member>({
				model: "member",
				where: [
					{
						field: "id",
						value: memberId,
					},
				],
			});
			return member;
		},
		updateOrganization: async (
			organizationId: string,
			data: Partial<Organization>,
		) => {
			const organization = await adapter.update<Organization>({
				model: "organization",
				where: [
					{
						field: "id",
						value: organizationId,
					},
				],
				update: {
					...data,
					metadata:
						typeof data.metadata === "object"
							? JSON.stringify(data.metadata)
							: data.metadata,
				},
			});
			if (!organization) {
				return null;
			}
			return {
				...organization,
				metadata: organization.metadata
					? parseJSON<Record<string, any>>(organization.metadata)
					: undefined,
			};
		},
		deleteOrganization: async (organizationId: string) => {
			await adapter.delete({
				model: "member",
				where: [
					{
						field: "organizationId",
						value: organizationId,
					},
				],
			});
			await adapter.delete({
				model: "invitation",
				where: [
					{
						field: "organizationId",
						value: organizationId,
					},
				],
			});
			await adapter.delete<Organization>({
				model: "organization",
				where: [
					{
						field: "id",
						value: organizationId,
					},
				],
			});
			return organizationId;
		},
		setActiveOrganization: async (
			sessionToken: string,
			organizationId: string | null,
		) => {
			const session = await context.internalAdapter.updateSession(
				sessionToken,
				{
					activeOrganizationId: organizationId,
				},
			);
			return session as Session;
		},
		findOrganizationById: async (organizationId: string) => {
			const organization = await adapter.findOne<Organization>({
				model: "organization",
				where: [
					{
						field: "id",
						value: organizationId,
					},
				],
			});
			return organization;
		},
		/**
		 * @requires db
		 */
		findFullOrganization: async ({
			organizationId,
			isSlug,
			includeTeams,
		}: {
			organizationId: string;
			isSlug?: boolean;
			includeTeams?: boolean;
		}) => {
			const org = await adapter.findOne<Organization>({
				model: "organization",
				where: [{ field: isSlug ? "slug" : "id", value: organizationId }],
			});
			if (!org) {
				return null;
			}
			const [invitations, members, teams] = await Promise.all([
				adapter.findMany<Invitation>({
					model: "invitation",
					where: [{ field: "organizationId", value: org.id }],
				}),
				adapter.findMany<Member>({
					model: "member",
					where: [{ field: "organizationId", value: org.id }],
					limit: options?.membershipLimit || 100,
				}),
				includeTeams
					? adapter.findMany<Team>({
							model: "team",
							where: [{ field: "organizationId", value: org.id }],
						})
					: null,
			]);

			if (!org) return null;

			const userIds = members.map((member) => member.userId);
			const users = await adapter.findMany<User>({
				model: "user",
				where: [{ field: "id", value: userIds, operator: "in" }],
				limit: options?.membershipLimit || 100,
			});

			const userMap = new Map(users.map((user) => [user.id, user]));
			const membersWithUsers = members.map((member) => {
				const user = userMap.get(member.userId);
				if (!user) {
					throw new BetterAuthError(
						"Unexpected error: User not found for member",
					);
				}
				return {
					...member,
					user: {
						id: user.id,
						name: user.name,
						email: user.email,
						image: user.image,
					},
				};
			});

			return {
				...org,
				invitations,
				members: membersWithUsers,
				teams,
			};
		},
		listOrganizations: async (userId: string) => {
			const members = await adapter.findMany<Member>({
				model: "member",
				where: [
					{
						field: "userId",
						value: userId,
					},
				],
			});

			if (!members || members.length === 0) {
				return [];
			}

			const organizationIds = members.map((member) => member.organizationId);

			const organizations = await adapter.findMany<Organization>({
				model: "organization",
				where: [
					{
						field: "id",
						value: organizationIds,
						operator: "in",
					},
				],
			});
			return organizations;
		},
		createTeam: async (data: TeamInput) => {
			const team = await adapter.create<TeamInput, Team>({
				model: "team",
				data,
			});
			return team;
		},
		findTeamById: async <IncludeMembers extends boolean>({
			teamId,
			organizationId,
			includeTeamMembers,
		}: {
			teamId: string;
			organizationId?: string;
			includeTeamMembers?: IncludeMembers;
		}): Promise<
			(Team & (IncludeMembers extends true ? { members: Member[] } : {})) | null
		> => {
			const team = await adapter.findOne<Team>({
				model: "team",
				where: [
					{
						field: "id",
						value: teamId,
					},
					...(organizationId
						? [
								{
									field: "organizationId",
									value: organizationId,
								},
							]
						: []),
				],
			});
			if (!team) {
				return null;
			}
			let members: Member[] = [];
			if (includeTeamMembers) {
				members = await adapter.findMany<Member>({
					model: "member",
					where: [
						{
							field: "teamId",
							value: teamId,
						},
					],
					limit: options?.membershipLimit || 100,
				});
				return {
					...team,
					members,
				};
			}
			return team as Team &
				(IncludeMembers extends true ? { members: Member[] } : {});
		},
		updateTeam: async (
			teamId: string,
			data: { name?: string; description?: string; status?: string },
		) => {
			const team = await adapter.update<Team>({
				model: "team",
				where: [
					{
						field: "id",
						value: teamId,
					},
				],
				update: {
					...data,
				},
			});
			return team;
		},

		deleteTeam: async (teamId: string) => {
			const team = await adapter.delete<Team>({
				model: "team",
				where: [
					{
						field: "id",
						value: teamId,
					},
				],
			});
			return team;
		},

		listTeams: async (organizationId: string) => {
			const teams = await adapter.findMany({
				model: "team",
				where: [
					{
						field: "organizationId",
						value: organizationId,
					},
				],
			});
			return teams;
		},

		createTeamInvitation: async ({
			email,
			role,
			teamId,
			organizationId,
			inviterId,
			expiresIn = 1000 * 60 * 60 * 48, // Default expiration: 48 hours
		}: {
			email: string;
			role: string;
			teamId: string;
			organizationId: string;
			inviterId: string;
			expiresIn?: number;
		}) => {
			const expiresAt = getDate(expiresIn); // Get expiration date

			const invitation = await adapter.create<InvitationInput, Invitation>({
				model: "invitation",
				data: {
					email,
					role,
					organizationId,
					teamId,
					inviterId,
					status: "pending",
					expiresAt,
				},
			});

			return invitation;
		},
		findInvitationsByTeamId: async (teamId: string) => {
			const invitations = await adapter.findMany<Invitation>({
				model: "invitation",
				where: [
					{
						field: "teamId",
						value: teamId,
					},
				],
			});
			return invitations;
		},

		createInvitation: async ({
			invitation,
			user,
		}: {
			invitation: {
				email: string;
				role: string;
				organizationId: string;
				teamId?: string;
			};
			user: User;
		}) => {
			const defaultExpiration = 60 * 60 * 48;
			const expiresAt = getDate(
				options?.invitationExpiresIn || defaultExpiration,
				"sec",
			);
			const invite = await adapter.create<InvitationInput, Invitation>({
				model: "invitation",
				data: {
					status: "pending",
					expiresAt,
					inviterId: user.id,
					...invitation,
				},
			});

			return invite;
		},
		findInvitationById: async (id: string) => {
			const invitation = await adapter.findOne<Invitation>({
				model: "invitation",
				where: [
					{
						field: "id",
						value: id,
					},
				],
			});
			return invitation;
		},
		findPendingInvitation: async (data: {
			email: string;
			organizationId: string;
		}) => {
			const invitation = await adapter.findMany<Invitation>({
				model: "invitation",
				where: [
					{
						field: "email",
						value: data.email,
					},
					{
						field: "organizationId",
						value: data.organizationId,
					},
					{
						field: "status",
						value: "pending",
					},
				],
			});
			return invitation.filter(
				(invite) => new Date(invite.expiresAt) > new Date(),
			);
		},
		updateInvitation: async (data: {
			invitationId: string;
			status: "accepted" | "canceled" | "rejected";
		}) => {
			const invitation = await adapter.update<Invitation>({
				model: "invitation",
				where: [
					{
						field: "id",
						value: data.invitationId,
					},
				],
				update: {
					status: data.status,
				},
			});
			return invitation;
		},
	};
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/call.ts
```typescript
import type { GenericEndpointContext, Session, User } from "../../types";
import { createAuthMiddleware } from "../../api/call";
import { sessionMiddleware } from "../../api";
import type { Role } from "../access";
import type { OrganizationOptions } from "./organization";
import type { defaultRoles } from "./access/statement";

export const orgMiddleware = createAuthMiddleware(async (ctx) => {
	return {} as {
		orgOptions: OrganizationOptions;
		roles: typeof defaultRoles & {
			[key: string]: Role<{}>;
		};
		getSession: (context: GenericEndpointContext) => Promise<{
			session: Session & {
				activeOrganizationId?: string;
			};
			user: User;
		}>;
	};
});

export const orgSessionMiddleware = createAuthMiddleware(
	{
		use: [sessionMiddleware],
	},
	async (ctx) => {
		const session = ctx.context.session as {
			session: Session & {
				activeOrganizationId?: string;
			};
			user: User;
		};
		return {
			session,
		};
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/client.ts
```typescript
import { atom } from "nanostores";
import type {
	InferInvitation,
	InferMember,
	Invitation,
	Member,
	Organization,
	Team,
} from "../../plugins/organization/schema";
import type { Prettify } from "../../types/helper";
import { type AccessControl, type Role } from "../access";
import type { BetterAuthClientPlugin } from "../../client/types";
import type { organization } from "./organization";
import { useAuthQuery } from "../../client";
import { BetterAuthError } from "../../error";
import { defaultStatements, adminAc, memberAc, ownerAc } from "./access";
import { hasPermission } from "./has-permission";

interface OrganizationClientOptions {
	ac?: AccessControl;
	roles?: {
		[key in string]: Role;
	};
	teams?: {
		enabled: boolean;
	};
}

export const organizationClient = <O extends OrganizationClientOptions>(
	options?: O,
) => {
	const $listOrg = atom<boolean>(false);
	const $activeOrgSignal = atom<boolean>(false);
	const $activeMemberSignal = atom<boolean>(false);

	type DefaultStatements = typeof defaultStatements;
	type Statements = O["ac"] extends AccessControl<infer S>
		? S
		: DefaultStatements;
	const roles = {
		admin: adminAc,
		member: memberAc,
		owner: ownerAc,
		...options?.roles,
	};

	type OrganizationReturn = O["teams"] extends { enabled: true }
		? {
				members: InferMember<O>[];
				invitations: InferInvitation<O>[];
				teams: Team[];
			} & Organization
		: {
				members: InferMember<O>[];
				invitations: InferInvitation<O>[];
			} & Organization;
	return {
		id: "organization",
		$InferServerPlugin: {} as ReturnType<
			typeof organization<{
				ac: O["ac"] extends AccessControl
					? O["ac"]
					: AccessControl<DefaultStatements>;
				roles: O["roles"] extends Record<string, Role>
					? O["roles"]
					: {
							admin: Role;
							member: Role;
							owner: Role;
						};
				teams: {
					enabled: O["teams"] extends { enabled: true } ? true : false;
				};
			}>
		>,
		getActions: ($fetch) => ({
			$Infer: {
				ActiveOrganization: {} as OrganizationReturn,
				Organization: {} as Organization,
				Invitation: {} as InferInvitation<O>,
				Member: {} as InferMember<O>,
				Team: {} as Team,
			},
			organization: {
				checkRolePermission: <
					R extends O extends { roles: any }
						? keyof O["roles"]
						: "admin" | "member" | "owner",
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
		getAtoms: ($fetch) => {
			const listOrganizations = useAuthQuery<Organization[]>(
				$listOrg,
				"/organization/list",
				$fetch,
				{
					method: "GET",
				},
			);
			const activeOrganization = useAuthQuery<
				Prettify<
					Organization & {
						members: (Member & {
							user: {
								id: string;
								name: string;
								email: string;
								image: string | undefined;
							};
						})[];
						invitations: Invitation[];
					}
				>
			>(
				[$activeOrgSignal],
				"/organization/get-full-organization",
				$fetch,
				() => ({
					method: "GET",
				}),
			);

			const activeMember = useAuthQuery<Member>(
				[$activeMemberSignal],
				"/organization/get-active-member",
				$fetch,
				{
					method: "GET",
				},
			);

			return {
				$listOrg,
				$activeOrgSignal,
				$activeMemberSignal,
				activeOrganization,
				listOrganizations,
				activeMember,
			};
		},
		pathMethods: {
			"/organization/get-full-organization": "GET",
		},
		atomListeners: [
			{
				matcher(path) {
					return (
						path === "/organization/create" ||
						path === "/organization/delete" ||
						path === "/organization/update"
					);
				},
				signal: "$listOrg",
			},
			{
				matcher(path) {
					return path.startsWith("/organization");
				},
				signal: "$activeOrgSignal",
			},
			{
				matcher(path) {
					return path.startsWith("/organization/set-active");
				},
				signal: "$sessionSignal",
			},
			{
				matcher(path) {
					return path.includes("/organization/update-member-role");
				},
				signal: "$activeMemberSignal",
			},
		],
	} satisfies BetterAuthClientPlugin;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/error-codes.ts
```typescript
export const ORGANIZATION_ERROR_CODES = {
	YOU_ARE_NOT_ALLOWED_TO_CREATE_A_NEW_ORGANIZATION:
		"You are not allowed to create a new organization",
	YOU_HAVE_REACHED_THE_MAXIMUM_NUMBER_OF_ORGANIZATIONS:
		"You have reached the maximum number of organizations",
	ORGANIZATION_ALREADY_EXISTS: "Organization already exists",
	ORGANIZATION_NOT_FOUND: "Organization not found",
	USER_IS_NOT_A_MEMBER_OF_THE_ORGANIZATION:
		"User is not a member of the organization",
	YOU_ARE_NOT_ALLOWED_TO_UPDATE_THIS_ORGANIZATION:
		"You are not allowed to update this organization",
	YOU_ARE_NOT_ALLOWED_TO_DELETE_THIS_ORGANIZATION:
		"You are not allowed to delete this organization",
	NO_ACTIVE_ORGANIZATION: "No active organization",
	USER_IS_ALREADY_A_MEMBER_OF_THIS_ORGANIZATION:
		"User is already a member of this organization",
	MEMBER_NOT_FOUND: "Member not found",
	ROLE_NOT_FOUND: "Role not found",
	YOU_ARE_NOT_ALLOWED_TO_CREATE_A_NEW_TEAM:
		"You are not allowed to create a new team",
	TEAM_ALREADY_EXISTS: "Team already exists",
	TEAM_NOT_FOUND: "Team not found",
	YOU_CANNOT_LEAVE_THE_ORGANIZATION_AS_THE_ONLY_OWNER:
		"You cannot leave the organization as the only owner",
	YOU_ARE_NOT_ALLOWED_TO_DELETE_THIS_MEMBER:
		"You are not allowed to delete this member",
	YOU_ARE_NOT_ALLOWED_TO_INVITE_USERS_TO_THIS_ORGANIZATION:
		"You are not allowed to invite users to this organization",
	USER_IS_ALREADY_INVITED_TO_THIS_ORGANIZATION:
		"User is already invited to this organization",
	INVITATION_NOT_FOUND: "Invitation not found",
	YOU_ARE_NOT_THE_RECIPIENT_OF_THE_INVITATION:
		"You are not the recipient of the invitation",
	YOU_ARE_NOT_ALLOWED_TO_CANCEL_THIS_INVITATION:
		"You are not allowed to cancel this invitation",
	INVITER_IS_NO_LONGER_A_MEMBER_OF_THE_ORGANIZATION:
		"Inviter is no longer a member of the organization",
	YOU_ARE_NOT_ALLOWED_TO_INVITE_USER_WITH_THIS_ROLE:
		"you are not allowed to invite user with this role",
	FAILED_TO_RETRIEVE_INVITATION: "Failed to retrieve invitation",
	YOU_HAVE_REACHED_THE_MAXIMUM_NUMBER_OF_TEAMS:
		"You have reached the maximum number of teams",
	UNABLE_TO_REMOVE_LAST_TEAM: "Unable to remove last team",
	YOU_ARE_NOT_ALLOWED_TO_UPDATE_THIS_MEMBER:
		"You are not allowed to update this member",
	ORGANIZATION_MEMBERSHIP_LIMIT_REACHED:
		"Organization membership limit reached",
	YOU_ARE_NOT_ALLOWED_TO_CREATE_TEAMS_IN_THIS_ORGANIZATION:
		"You are not allowed to create teams in this organization",
	YOU_ARE_NOT_ALLOWED_TO_DELETE_TEAMS_IN_THIS_ORGANIZATION:
		"You are not allowed to delete teams in this organization",
	YOU_ARE_NOT_ALLOWED_TO_UPDATE_THIS_TEAM:
		"You are not allowed to update this team",
} as const;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/has-permission.ts
```typescript
import { defaultRoles } from "./access";
import type { OrganizationOptions } from "./organization";

export const hasPermission = (input: {
	role: string;
	options: OrganizationOptions;
	permission: {
		[key: string]: string[];
	};
}) => {
	const roles = input.role.split(",");
	const acRoles = input.options.roles || defaultRoles;
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
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/index.ts
```typescript
export * from "./organization";
export type * from "./schema";
export type * from "./access";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/organization.test.ts
```typescript
import { describe, expect, expectTypeOf } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";
import { organization } from "./organization";
import { createAuthClient } from "../../client";
import { organizationClient } from "./client";
import { createAccessControl } from "../access";
import { ORGANIZATION_ERROR_CODES } from "./error-codes";
import { BetterAuthError } from "../../error";
import { APIError } from "better-call";

describe("organization", async (it) => {
	const { auth, signInWithTestUser, signInWithUser, cookieSetter } =
		await getTestInstance({
			user: {
				modelName: "users",
			},
			plugins: [
				organization({
					membershipLimit: 6,
					async sendInvitationEmail(data, request) {},
					schema: {
						organization: {
							modelName: "team",
						},
						member: {
							modelName: "teamMembers",
						},
					},
				}),
			],
			logger: {
				level: "error",
			},
		});

	const { headers } = await signInWithTestUser();
	const client = createAuthClient({
		plugins: [organizationClient()],
		baseURL: "http://localhost:3000/api/auth",
		fetchOptions: {
			customFetchImpl: async (url, init) => {
				return auth.handler(new Request(url, init));
			},
		},
	});

	let organizationId: string;
	it("create organization", async () => {
		const organization = await client.organization.create({
			name: "test",
			slug: "test",
			metadata: {
				test: "test",
			},
			fetchOptions: {
				headers,
			},
		});
		organizationId = organization.data?.id as string;
		expect(organization.data?.name).toBeDefined();
		expect(organization.data?.metadata).toBeDefined();
		expect(organization.data?.members.length).toBe(1);
		expect(organization.data?.members[0].role).toBe("owner");
		const session = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect((session.data?.session as any).activeOrganizationId).toBe(
			organizationId,
		);
	});

	it("should create organization directly in the server without cookie", async () => {
		const session = await client.getSession({
			fetchOptions: {
				headers,
			},
		});

		const organization = await auth.api.createOrganization({
			body: {
				name: "test2",
				slug: "test2",
				userId: session.data?.session.userId,
			},
		});

		expect(organization?.name).toBe("test2");
		expect(organization?.members.length).toBe(1);
		expect(organization?.members[0].role).toBe("owner");
	});

	it("should allow listing organizations", async () => {
		const organizations = await client.organization.list({
			fetchOptions: {
				headers,
			},
		});
		expect(organizations.data?.length).toBe(2);
	});

	it("should allow updating organization", async () => {
		const { headers } = await signInWithTestUser();
		const organization = await client.organization.update({
			organizationId,
			data: {
				name: "test2",
			},
			fetchOptions: {
				headers,
			},
		});
		expect(organization.data?.name).toBe("test2");
	});

	it("should allow updating organization metadata", async () => {
		const { headers } = await signInWithTestUser();
		const organization = await client.organization.update({
			organizationId,
			data: {
				metadata: {
					test: "test2",
				},
			},
			fetchOptions: {
				headers,
			},
		});
		expect(organization.data?.metadata?.test).toBe("test2");
	});

	it("should allow activating organization and set session", async () => {
		const organization = await client.organization.setActive({
			organizationId,
			fetchOptions: {
				headers,
			},
		});

		expect(organization.data?.id).toBe(organizationId);
		const session = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect((session.data?.session as any).activeOrganizationId).toBe(
			organizationId,
		);
	});

	it("should allow getting full org on server", async () => {
		const org = await auth.api.getFullOrganization({
			headers,
		});
		expect(org?.members.length).toBe(1);
	});

	it("should allow getting full org on server using slug", async () => {
		const org = await auth.api.getFullOrganization({
			headers,
			query: {
				organizationSlug: "test",
			},
		});
		expect(org?.members.length).toBe(1);
	});

	it.each([
		{
			role: "owner",
			newUser: {
				email: "test2@test.com",
				password: "test123456",
				name: "test2",
			},
		},
		{
			role: "admin",
			newUser: {
				email: "test3@test.com",
				password: "test123456",
				name: "test3",
			},
		},
		{
			role: "member",
			newUser: {
				email: "test4@test.com",
				password: "test123456",
				name: "test4",
			},
		},
	])(
		"invites user to organization with $role role",
		async ({ role, newUser }) => {
			const { headers } = await signInWithTestUser();
			const invite = await client.organization.inviteMember({
				organizationId: organizationId,
				email: newUser.email,
				role: role as "owner",
				fetchOptions: {
					headers,
				},
			});
			if (!invite.data) throw new Error("Invitation not created");
			expect(invite.data.email).toBe(newUser.email);
			expect(invite.data.role).toBe(role);
			await client.signUp.email({
				email: newUser.email,
				password: newUser.password,
				name: newUser.name,
			});
			const { headers: headers2 } = await signInWithUser(
				newUser.email,
				newUser.password,
			);

			const wrongInvitation = await client.organization.acceptInvitation({
				invitationId: "123",
				fetchOptions: {
					headers: headers2,
				},
			});
			expect(wrongInvitation.error?.status).toBe(400);

			const wrongPerson = await client.organization.acceptInvitation({
				invitationId: invite.data.id,
				fetchOptions: {
					headers,
				},
			});
			expect(wrongPerson.error?.status).toBe(403);

			const invitation = await client.organization.acceptInvitation({
				invitationId: invite.data.id,
				fetchOptions: {
					headers: headers2,
				},
			});
			expect(invitation.data?.invitation.status).toBe("accepted");
			const invitedUserSession = await client.getSession({
				fetchOptions: {
					headers: headers2,
				},
			});
			expect(
				(invitedUserSession.data?.session as any).activeOrganizationId,
			).toBe(organizationId);
		},
	);

	it("should create invitation with multiple roles", async () => {
		const invite = await client.organization.inviteMember({
			organizationId: organizationId,
			email: "test5@test.com",
			role: ["admin", "member"],
			fetchOptions: {
				headers,
			},
		});
		expect(invite.data?.role).toBe("admin,member");
	});

	it("should allow getting a member", async () => {
		const { headers } = await signInWithTestUser();
		await client.organization.setActive({
			organizationId,
			fetchOptions: {
				headers,
			},
		});
		const member = await client.organization.getActiveMember({
			fetchOptions: {
				headers,
			},
		});
		expect(member.data).toMatchObject({
			role: "owner",
		});
	});

	it("should allow updating member", async () => {
		const { headers, user } = await signInWithTestUser();
		const org = await client.organization.getFullOrganization({
			query: {
				organizationId,
			},
			fetchOptions: {
				headers,
			},
		});
		if (!org.data) throw new Error("Organization not found");
		expect(org.data?.members[3].role).toBe("member");
		const member = await client.organization.updateMemberRole({
			organizationId: org.data.id,
			memberId: org.data.members[3].id,
			role: "admin",
			fetchOptions: {
				headers,
			},
		});
		expect(member.data?.role).toBe("admin");
	});

	it("should allow setting multiple roles", async () => {
		const { headers } = await signInWithTestUser();
		const org = await client.organization.getFullOrganization({
			query: {
				organizationId,
			},
			fetchOptions: {
				headers,
			},
		});
		const c = await client.organization.updateMemberRole({
			organizationId: org.data?.id as string,
			role: ["member", "admin"],
			memberId: org.data?.members[1].id as string,
			fetchOptions: {
				headers,
			},
		});
		expect(c.data?.role).toBe("member,admin");
	});

	it("should allow setting multiple roles when you have multiple yourself", async () => {
		const { headers, user } = await signInWithTestUser();
		const org = await client.organization.getFullOrganization({
			query: {
				organizationId,
			},
			fetchOptions: {
				headers,
			},
		});

		const activeMember = org?.data?.members.find((m) => m.userId === user.id);

		expect(activeMember?.role).toBe("owner");

		const c1 = await client.organization.updateMemberRole({
			organizationId: org.data?.id as string,
			role: ["owner", "admin"],
			memberId: activeMember?.id as string,
			fetchOptions: {
				headers,
			},
		});

		expect(c1.data?.role).toBe("owner,admin");

		const c2 = await client.organization.updateMemberRole({
			organizationId: org.data?.id as string,
			role: ["owner"],
			memberId: activeMember!.id as string,
			fetchOptions: {
				headers,
			},
		});

		expect(c2.data?.role).toBe("owner");
	});

	const adminUser = {
		email: "test3@test.com",
		password: "test123456",
		name: "test3",
	};

	it("should not allow inviting member with a creator role unless they are creator", async () => {
		const { headers } = await signInWithUser(
			adminUser.email,
			adminUser.password,
		);
		const invite = await client.organization.inviteMember({
			organizationId: organizationId,
			email: adminUser.email,
			role: "owner",
			fetchOptions: {
				headers,
			},
		});
		expect(invite.error?.message).toBe(
			ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_INVITE_USER_WITH_THIS_ROLE,
		);
	});

	it("should allow leaving organization", async () => {
		const newUser = {
			email: "leave@org.com",
			name: "leaving member",
			password: "password",
		};
		const headers = new Headers();
		const res = await client.signUp.email(newUser, {
			onSuccess: cookieSetter(headers),
		});
		const member = await auth.api.addMember({
			body: {
				organizationId,
				userId: res.data?.user.id!,
				role: "admin",
			},
		});
		const leaveRes = await client.organization.leave(
			{
				organizationId,
			},
			{
				headers,
			},
		);
		expect(leaveRes.data).toMatchObject({
			userId: res.data?.user.id!,
		});
	});

	it("shouldn't allow updating owner role if you're not owner", async () => {
		const { headers } = await signInWithTestUser();
		const { members } = await client.organization.getFullOrganization({
			query: {
				organizationId,
			},
			fetchOptions: {
				headers,
				throw: true,
			},
		});
		const { headers: adminHeaders } = await signInWithUser(
			adminUser.email,
			adminUser.password,
		);

		const res = await client.organization.updateMemberRole({
			organizationId: organizationId,
			role: "admin",
			memberId: members.find((m) => m.role === "owner")?.id!,
			fetchOptions: {
				headers: adminHeaders,
			},
		});
		expect(res.error?.status).toBe(403);
	});

	it("should allow removing member from organization", async () => {
		const { headers } = await signInWithTestUser();
		const orgBefore = await client.organization.getFullOrganization({
			query: {
				organizationId,
			},
			fetchOptions: {
				headers,
			},
		});

		expect(orgBefore.data?.members.length).toBe(4);
		await client.organization.removeMember({
			organizationId: organizationId,
			memberIdOrEmail: adminUser.email,
			fetchOptions: {
				headers,
			},
		});
		const org = await client.organization.getFullOrganization({
			query: {
				organizationId,
			},
			fetchOptions: {
				headers,
			},
		});
		expect(org.data?.members.length).toBe(3);
	});

	it("shouldn't allow removing last owner from organization", async () => {
		const { headers } = await signInWithTestUser();
		const org = await client.organization.getFullOrganization({
			query: {
				organizationId,
			},
			fetchOptions: {
				headers,
			},
		});
		if (!org.data) throw new Error("Organization not found");
		const removedOwner = await client.organization.removeMember({
			organizationId: org.data.id,
			memberIdOrEmail: org.data.members[0].id,
			fetchOptions: {
				headers,
			},
		});
		expect(removedOwner.error?.status).toBe(400);
	});

	it("should validate permissions", async () => {
		await client.organization.setActive({
			organizationId,
			fetchOptions: {
				headers,
			},
		});
		const hasPermission = await client.organization.hasPermission({
			permission: {
				member: ["update"],
			},
			fetchOptions: {
				headers,
			},
		});
		expect(hasPermission.data?.success).toBe(true);
	});

	it("should allow deleting organization", async () => {
		const { headers: adminHeaders } = await signInWithUser(
			adminUser.email,
			adminUser.password,
		);

		const r = await client.organization.delete({
			organizationId,
			fetchOptions: {
				headers: adminHeaders,
			},
		});
		const org = await client.organization.getFullOrganization({
			query: {
				organizationId,
			},
			fetchOptions: {
				headers: adminHeaders,
			},
		});
		expect(org.error?.status).toBe(403);
	});

	it("should have server side methods", async () => {
		expectTypeOf(auth.api.createOrganization).toBeFunction();
		expectTypeOf(auth.api.getInvitation).toBeFunction();
	});

	it("should add member on the server directly", async () => {
		const newUser = await auth.api.signUpEmail({
			body: {
				email: "new-member@email.com",
				password: "password",
				name: "new member",
			},
		});
		const session = await auth.api.getSession({
			headers: new Headers({
				Authorization: `Bearer ${newUser?.token}`,
			}),
		});
		const org = await auth.api.createOrganization({
			body: {
				name: "test2",
				slug: "test3",
			},
			headers,
		});
		const member = await auth.api.addMember({
			body: {
				organizationId: org?.id,
				userId: session?.user.id!,
				role: "admin",
			},
		});
		expect(member?.role).toBe("admin");
	});

	it("should add member on the server with multiple roles", async () => {
		const newUser = await auth.api.signUpEmail({
			body: {
				email: "new-member-mr@email.com",
				password: "password",
				name: "new member mr",
			},
		});
		const session = await auth.api.getSession({
			headers: new Headers({
				Authorization: `Bearer ${newUser?.token}`,
			}),
		});
		const org = await auth.api.createOrganization({
			body: {
				name: "test2",
				slug: "test4",
			},
			headers,
		});
		const member = await auth.api.addMember({
			body: {
				organizationId: org?.id,
				userId: session?.user.id!,
				role: ["admin", "member"],
			},
		});
		expect(member?.role).toBe("admin,member");
	});

	it("should respect membershipLimit when adding members to organization", async () => {
		const org = await auth.api.createOrganization({
			body: {
				name: "test-5-membership-limit",
				slug: "test-5-membership-limit",
			},
			headers,
		});

		const users = [
			"user1@emial.com",
			"user2@email.com",
			"user3@email.com",
			"user4@email.com",
		];

		for (const user of users) {
			const newUser = await auth.api.signUpEmail({
				body: {
					email: user,
					password: "password",
					name: user,
				},
			});
			const session = await auth.api.getSession({
				headers: new Headers({
					Authorization: `Bearer ${newUser?.token}`,
				}),
			});
			await auth.api.addMember({
				body: {
					organizationId: org?.id,
					userId: session?.user.id!,
					role: "admin",
				},
			});
		}

		const userOverLimit = {
			email: "shouldthrowerror@email.com",
			password: "password",
			name: "name",
		};
		const userOverLimit2 = {
			email: "shouldthrowerror2@email.com",
			password: "password",
			name: "name",
		};

		// test api method
		const newUser = await auth.api.signUpEmail({
			body: {
				email: userOverLimit.email,
				password: userOverLimit.password,
				name: userOverLimit.name,
			},
		});
		const session = await auth.api.getSession({
			headers: new Headers({
				Authorization: `Bearer ${newUser?.token}`,
			}),
		});
		await auth.api
			.addMember({
				body: {
					organizationId: org?.id,
					userId: session?.user.id!,
					role: "admin",
				},
			})
			.catch((e: APIError) => {
				expect(e).not.toBeNull();
				expect(e).toBeInstanceOf(APIError);
				expect(e.message).toBe(
					ORGANIZATION_ERROR_CODES.ORGANIZATION_MEMBERSHIP_LIMIT_REACHED,
				);
			});
		const invite = await client.organization.inviteMember({
			organizationId: org?.id,
			email: userOverLimit2.email,
			role: "member",
			fetchOptions: {
				headers,
			},
		});
		if (!invite.data) throw new Error("Invitation not created");
		await client.signUp.email({
			email: userOverLimit.email,
			password: userOverLimit.password,
			name: userOverLimit.name,
		});
		const { res, headers: headers2 } = await signInWithUser(
			userOverLimit2.email,
			userOverLimit2.password,
		);
		await client.signUp.email(
			{
				email: userOverLimit2.email,
				password: userOverLimit2.password,
				name: userOverLimit2.name,
			},
			{
				onSuccess: cookieSetter(headers2),
			},
		);

		const invitation = await client.organization.acceptInvitation({
			invitationId: invite.data.id,
			fetchOptions: {
				headers: headers2,
			},
		});
		console.log(invitation);
		expect(invitation.error?.message).toBe(
			ORGANIZATION_ERROR_CODES.ORGANIZATION_MEMBERSHIP_LIMIT_REACHED,
		);

		const getFullOrganization = await client.organization.getFullOrganization({
			query: {
				organizationId: org?.id,
			},
			fetchOptions: {
				headers,
			},
		});
		expect(getFullOrganization.data?.members.length).toBe(6);
	});
});

describe("access control", async (it) => {
	const ac = createAccessControl({
		project: ["create", "read", "update", "delete"],
		sales: ["create", "read", "update", "delete"],
	});
	const owner = ac.newRole({
		project: ["create", "delete", "update", "read"],
		sales: ["create", "read", "update", "delete"],
	});
	const admin = ac.newRole({
		project: ["create", "read"],
		sales: ["create", "read"],
	});
	const member = ac.newRole({
		project: ["read"],
		sales: ["read"],
	});
	const { auth, customFetchImpl, sessionSetter, signInWithTestUser } =
		await getTestInstance({
			plugins: [
				organization({
					ac,
					roles: {
						admin,
						member,
						owner,
					},
				}),
			],
		});

	const {
		organization: { checkRolePermission, hasPermission, create },
	} = createAuthClient({
		baseURL: "http://localhost:3000",
		plugins: [
			organizationClient({
				ac,
				roles: {
					admin,
					member,
					owner,
				},
			}),
		],
		fetchOptions: {
			customFetchImpl,
		},
	});

	const { headers } = await signInWithTestUser();

	const org = await create(
		{
			name: "test",
			slug: "test",
			metadata: {
				test: "test",
			},
		},
		{
			onSuccess: sessionSetter(headers),
			headers,
		},
	);

	it("should return success", async () => {
		const canCreateProject = checkRolePermission({
			role: "admin",
			permission: {
				project: ["create"],
			},
		});
		expect(canCreateProject).toBe(true);
		const canCreateProjectServer = await hasPermission({
			permission: {
				project: ["create"],
			},
			fetchOptions: {
				headers,
			},
		});
		expect(canCreateProjectServer.data?.success).toBe(true);
	});

	it("should return not success", async () => {
		const canCreateProject = checkRolePermission({
			role: "admin",
			permission: {
				project: ["delete"],
			},
		});
		expect(canCreateProject).toBe(false);
	});

	it("should return not success", async () => {
		let error: BetterAuthError | null = null;
		try {
			checkRolePermission({
				role: "admin",
				permission: {
					project: ["read"],
					sales: ["delete"],
				},
			});
		} catch (e) {
			if (e instanceof BetterAuthError) {
				error = e;
			}
		}
		expect(error).toBeInstanceOf(BetterAuthError);
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/organization.ts
````typescript
import { APIError } from "better-call";
import { z } from "zod";
import type { AuthPluginSchema, Session, User } from "../../types";
import { createAuthEndpoint } from "../../api/call";
import { getSessionFromCtx } from "../../api/routes";
import type { AuthContext } from "../../init";
import type { BetterAuthPlugin } from "../../types/plugins";
import { shimContext } from "../../utils/shim";
import { type AccessControl, type Role } from "../access";
import { getOrgAdapter } from "./adapter";
import { orgSessionMiddleware } from "./call";
import {
	acceptInvitation,
	cancelInvitation,
	createInvitation,
	getInvitation,
	rejectInvitation,
} from "./routes/crud-invites";
import {
	addMember,
	getActiveMember,
	leaveOrganization,
	removeMember,
	updateMemberRole,
} from "./routes/crud-members";
import {
	checkOrganizationSlug,
	createOrganization,
	deleteOrganization,
	getFullOrganization,
	listOrganizations,
	setActiveOrganization,
	updateOrganization,
} from "./routes/crud-org";
import {
	createTeam,
	listOrganizationTeams,
	removeTeam,
	updateTeam,
} from "./routes/crud-team";
import type { Invitation, Member, Organization, Team } from "./schema";
import type { Prettify } from "../../types/helper";
import { ORGANIZATION_ERROR_CODES } from "./error-codes";
import { defaultRoles, defaultStatements } from "./access";
import { hasPermission } from "./has-permission";

export function parseRoles(roles: string | string[]): string {
	return Array.isArray(roles) ? roles.join(",") : roles;
}

export interface OrganizationOptions {
	/**
	 * Configure whether new users are able to create new organizations.
	 * You can also pass a function that returns a boolean.
	 *
	 * 	@example
	 * ```ts
	 * allowUserToCreateOrganization: async (user) => {
	 * 		const plan = await getUserPlan(user);
	 *      return plan.name === "pro";
	 * }
	 * ```
	 * @default true
	 */
	allowUserToCreateOrganization?:
		| boolean
		| ((user: User) => Promise<boolean> | boolean);
	/**
	 * The maximum number of organizations a user can create.
	 *
	 * You can also pass a function that returns a boolean
	 */
	organizationLimit?: number | ((user: User) => Promise<boolean> | boolean);
	/**
	 * The role that is assigned to the creator of the
	 * organization.
	 *
	 * @default "owner"
	 */
	creatorRole?: string;
	/**
	 * The number of memberships a user can have in an organization.
	 *
	 * @default 100
	 */
	membershipLimit?: number;
	/**
	 * Configure the roles and permissions for the
	 * organization plugin.
	 */
	ac?: AccessControl;
	/**
	 * Custom permissions for roles.
	 */
	roles?: {
		[key in string]?: Role<any>;
	};
	/**
	 * Support for team.
	 */
	teams?: {
		/**
		 * Enable team features.
		 */
		enabled: boolean;
		/**
		 * Default team configuration
		 */
		defaultTeam?: {
			/**
			 * Enable creating a default team when an organization is created
			 *
			 * @default true
			 */
			enabled: boolean;
			/**
			 * Pass a custom default team creator function
			 */
			customCreateDefaultTeam?: (
				organization: Organization & Record<string, any>,
				request?: Request,
			) => Promise<Team & Record<string, any>>;
		};
		/**
		 * Maximum number of teams an organization can have.
		 *
		 * You can pass a number or a function that returns a number
		 *
		 * @default "unlimited"
		 *
		 * @param organization
		 * @param request
		 * @returns
		 */
		maximumTeams?:
			| ((
					data: {
						organizationId: string;
						session: {
							user: User;
							session: Session;
						} | null;
					},
					request?: Request,
			  ) => number | Promise<number>)
			| number;
		/**
		 * By default, if an organization does only have one team, they'll not be able to remove it.
		 *
		 * You can disable this behavior by setting this to `false.
		 *
		 * @default false
		 */
		allowRemovingAllTeams?: boolean;
	};
	/**
	 * The expiration time for the invitation link.
	 *
	 * @default 48 hours
	 */
	invitationExpiresIn?: number;
	/**
	 * Send an email with the
	 * invitation link to the user.
	 *
	 * Note: Better Auth doesn't
	 * generate invitation URLs.
	 * You'll need to construct the
	 * URL using the invitation ID
	 * and pass it to the
	 * acceptInvitation endpoint for
	 * the user to accept the
	 * invitation.
	 *
	 * @example
	 * ```ts
	 * sendInvitationEmail: async (data) => {
	 * 	const url = `https://yourapp.com/organization/
	 * accept-invitation?id=${data.id}`;
	 * 	await sendEmail(data.email, "Invitation to join
	 * organization", `Click the link to join the
	 * organization: ${url}`);
	 * }
	 * ```
	 */
	sendInvitationEmail?: (
		data: {
			/**
			 * the invitation id
			 */
			id: string;
			/**
			 * the role of the user
			 */
			role: string;
			/**
			 * the email of the user
			 */
			email: string;
			/**
			 * the organization the user is invited to join
			 */
			organization: Organization;
			/**
			 * the invitation object
			 */
			invitation: Invitation;
			/**
			 * the member who is inviting the user
			 */
			inviter: Member & {
				user: User;
			};
		},
		/**
		 * The request object
		 */
		request?: Request,
	) => Promise<void>;

	/**
	 * The schema for the organization plugin.
	 */
	schema?: {
		session?: {
			fields?: {
				activeOrganizationId?: string;
			};
		};
		organization?: {
			modelName?: string;
			fields?: {
				[key in keyof Omit<Organization, "id">]?: string;
			};
		};
		member?: {
			modelName?: string;
			fields?: {
				[key in keyof Omit<Member, "id">]?: string;
			};
		};
		invitation?: {
			modelName?: string;
			fields?: {
				[key in keyof Omit<Invitation, "id">]?: string;
			};
		};

		team?: {
			modelName?: string;
			fields?: {
				[key in keyof Omit<Team, "id">]?: string;
			};
		};
	};
	/**
	 * Configure how organization deletion is handled
	 */
	organizationDeletion?: {
		/**
		 * disable deleting organization
		 */
		disabled?: boolean;
		/**
		 * A callback that runs before the organization is
		 * deleted
		 *
		 * @param data - organization and user object
		 * @param request - the request object
		 * @returns
		 */
		beforeDelete?: (
			data: {
				organization: Organization;
				user: User;
			},
			request?: Request,
		) => Promise<void>;
		/**
		 * A callback that runs after the organization is
		 * deleted
		 *
		 * @param data - organization and user object
		 * @param request - the request object
		 * @returns
		 */
		afterDelete?: (
			data: {
				organization: Organization;
				user: User;
			},
			request?: Request,
		) => Promise<void>;
	};
	organizationCreation?: {
		disabled?: boolean;
		beforeCreate?: (
			data: {
				organization: Omit<Organization, "id">;
				user: User;
			},
			request?: Request,
		) => Promise<void | {
			data: Omit<Organization, "id">;
		}>;
		afterCreate?: (
			data: {
				organization: Organization;
				member: Member;
				user: User;
			},
			request?: Request,
		) => Promise<void>;
	};
}

/**
 * Organization plugin for Better Auth. Organization allows you to create teams, members,
 * and manage access control for your users.
 *
 * @example
 * ```ts
 * const auth = betterAuth({
 * 	plugins: [
 * 		organization({
 * 			allowUserToCreateOrganization: true,
 * 		}),
 * 	],
 * });
 * ```
 */
export const organization = <O extends OrganizationOptions>(options?: O) => {
	let endpoints = {
		createOrganization,
		updateOrganization,
		deleteOrganization,
		setActiveOrganization: setActiveOrganization<O>(),
		getFullOrganization: getFullOrganization<O>(),
		listOrganizations,
		createInvitation: createInvitation(options as O),
		cancelInvitation,
		acceptInvitation,
		getInvitation,
		rejectInvitation,
		checkOrganizationSlug,
		addMember: addMember<O>(),
		removeMember,
		updateMemberRole: updateMemberRole(options as O),
		getActiveMember,
		leaveOrganization,
	};
	const teamSupport = options?.teams?.enabled;
	const teamEndpoints = {
		createTeam: createTeam(options as O),
		listOrganizationTeams,
		removeTeam,
		updateTeam,
	};
	if (teamSupport) {
		endpoints = {
			...endpoints,
			...teamEndpoints,
		};
	}
	const roles = {
		...defaultRoles,
		...options?.roles,
	};

	const teamSchema = teamSupport
		? ({
				team: {
					modelName: options?.schema?.team?.modelName,
					fields: {
						name: {
							type: "string",
							required: true,
							fieldName: options?.schema?.team?.fields?.name,
						},
						organizationId: {
							type: "string",
							required: true,
							references: {
								model: "organization",
								field: "id",
							},
							fieldName: options?.schema?.team?.fields?.organizationId,
						},
						createdAt: {
							type: "date",
							required: true,
							fieldName: options?.schema?.team?.fields?.createdAt,
						},
						updatedAt: {
							type: "date",
							required: false,
							fieldName: options?.schema?.team?.fields?.updatedAt,
						},
					},
				},
			} satisfies AuthPluginSchema)
		: undefined;

	const api = shimContext(endpoints, {
		orgOptions: options || {},
		roles,
		getSession: async (context: AuthContext) => {
			//@ts-expect-error
			return await getSessionFromCtx(context);
		},
	});

	type DefaultStatements = typeof defaultStatements;
	type Statements = O["ac"] extends AccessControl<infer S>
		? S
		: DefaultStatements;
	return {
		id: "organization",
		endpoints: {
			...(api as O["teams"] extends { enabled: true }
				? typeof teamEndpoints & typeof endpoints
				: typeof endpoints),
			hasPermission: createAuthEndpoint(
				"/organization/has-permission",
				{
					method: "POST",
					requireHeaders: true,
					body: z.object({
						organizationId: z.string().optional(),
						permission: z.record(z.string(), z.array(z.string())),
					}),
					use: [orgSessionMiddleware],
					metadata: {
						$Infer: {
							body: {} as {
								permission: {
									//@ts-expect-error
									[key in keyof Statements]?: Array<Statements[key][number]>;
								};
								organizationId?: string;
							},
						},
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
					},
				},
				async (ctx) => {
					const activeOrganizationId =
						ctx.body.organizationId ||
						ctx.context.session.session.activeOrganizationId;
					if (!activeOrganizationId) {
						throw new APIError("BAD_REQUEST", {
							message: ORGANIZATION_ERROR_CODES.NO_ACTIVE_ORGANIZATION,
						});
					}
					const adapter = getOrgAdapter(ctx.context);
					const member = await adapter.findMemberByOrgId({
						userId: ctx.context.session.user.id,
						organizationId: activeOrganizationId,
					});
					if (!member) {
						throw new APIError("UNAUTHORIZED", {
							message:
								ORGANIZATION_ERROR_CODES.USER_IS_NOT_A_MEMBER_OF_THE_ORGANIZATION,
						});
					}
					const result = hasPermission({
						role: member.role,
						options: options as OrganizationOptions,
						permission: ctx.body.permission as any,
					});
					return ctx.json({
						error: null,
						success: result,
					});
				},
			),
		},
		schema: {
			session: {
				fields: {
					activeOrganizationId: {
						type: "string",
						required: false,
						fieldName: options?.schema?.session?.fields?.activeOrganizationId,
					},
				},
			},
			organization: {
				modelName: options?.schema?.organization?.modelName,
				fields: {
					name: {
						type: "string",
						required: true,
						sortable: true,
						fieldName: options?.schema?.organization?.fields?.name,
					},
					slug: {
						type: "string",
						unique: true,
						sortable: true,
						fieldName: options?.schema?.organization?.fields?.slug,
					},
					logo: {
						type: "string",
						required: false,
						fieldName: options?.schema?.organization?.fields?.logo,
					},
					createdAt: {
						type: "date",
						required: true,
						fieldName: options?.schema?.organization?.fields?.createdAt,
					},
					metadata: {
						type: "string",
						required: false,
						fieldName: options?.schema?.organization?.fields?.metadata,
					},
				},
			},
			member: {
				modelName: options?.schema?.member?.modelName,
				fields: {
					organizationId: {
						type: "string",
						required: true,
						references: {
							model: "organization",
							field: "id",
						},
						fieldName: options?.schema?.member?.fields?.organizationId,
					},
					userId: {
						type: "string",
						required: true,
						fieldName: options?.schema?.member?.fields?.userId,
						references: {
							model: "user",
							field: "id",
						},
					},
					role: {
						type: "string",
						required: true,
						sortable: true,
						defaultValue: "member",
						fieldName: options?.schema?.member?.fields?.role,
					},
					...(teamSupport
						? {
								teamId: {
									type: "string",
									required: false,
									sortable: true,
									fieldName: options?.schema?.member?.fields?.teamId,
								},
							}
						: {}),
					createdAt: {
						type: "date",
						required: true,
						fieldName: options?.schema?.member?.fields?.createdAt,
					},
				},
			},
			invitation: {
				modelName: options?.schema?.invitation?.modelName,
				fields: {
					organizationId: {
						type: "string",
						required: true,
						references: {
							model: "organization",
							field: "id",
						},
						fieldName: options?.schema?.invitation?.fields?.organizationId,
					},
					email: {
						type: "string",
						required: true,
						sortable: true,
						fieldName: options?.schema?.invitation?.fields?.email,
					},
					role: {
						type: "string",
						required: false,
						sortable: true,
						fieldName: options?.schema?.invitation?.fields?.role,
					},
					...(teamSupport
						? {
								teamId: {
									type: "string",
									required: false,
									sortable: true,
									fieldName: options?.schema?.invitation?.fields?.teamId,
								},
							}
						: {}),
					status: {
						type: "string",
						required: true,
						sortable: true,
						defaultValue: "pending",
						fieldName: options?.schema?.invitation?.fields?.status,
					},
					expiresAt: {
						type: "date",
						required: true,
						fieldName: options?.schema?.invitation?.fields?.expiresAt,
					},
					inviterId: {
						type: "string",
						references: {
							model: "user",
							field: "id",
						},
						fieldName: options?.schema?.invitation?.fields?.inviterId,
						required: true,
					},
				},
			},
			...(teamSupport ? teamSchema : {}),
		},
		$Infer: {
			Organization: {} as Organization,
			Invitation: {} as Invitation,
			Member: {} as Member,
			Team: teamSupport ? ({} as Team) : ({} as any),
			ActiveOrganization: {} as Prettify<
				Organization & {
					members: Prettify<
						Member & {
							user: {
								id: string;
								name: string;
								email: string;
								image?: string | null;
							};
						}
					>[];
					invitations: Invitation[];
				}
			>,
		},
		$ERROR_CODES: ORGANIZATION_ERROR_CODES,
	} satisfies BetterAuthPlugin;
};

````
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/schema.ts
```typescript
import { z, ZodLiteral } from "zod";
import { generateId } from "../../utils";
import type { OrganizationOptions } from "./organization";

export const role = z.string();
export const invitationStatus = z
	.enum(["pending", "accepted", "rejected", "canceled"])
	.default("pending");

export const organizationSchema = z.object({
	id: z.string().default(generateId),
	name: z.string(),
	slug: z.string(),
	logo: z.string().nullish(),
	metadata: z
		.record(z.string())
		.or(z.string().transform((v) => JSON.parse(v)))

		.nullish(),
	createdAt: z.date(),
});

export const memberSchema = z.object({
	id: z.string().default(generateId),
	organizationId: z.string(),
	userId: z.coerce.string(),
	role,
	createdAt: z.date().default(() => new Date()),
	teamId: z.string().optional(),
});

export const invitationSchema = z.object({
	id: z.string().default(generateId),
	organizationId: z.string(),
	email: z.string(),
	role,
	status: invitationStatus,
	teamId: z.string().optional(),
	inviterId: z.string(),
	expiresAt: z.date(),
});
export const teamSchema = z.object({
	id: z.string().default(generateId),
	name: z.string().min(1),
	organizationId: z.string(),
	createdAt: z.date(),
	updatedAt: z.date().optional(),
});
export type Organization = z.infer<typeof organizationSchema> &
	Record<string, any>;
export type Member = z.infer<typeof memberSchema>;
export type Team = z.infer<typeof teamSchema>;
export type Invitation = z.infer<typeof invitationSchema>;
export type InvitationInput = z.input<typeof invitationSchema>;
export type MemberInput = z.input<typeof memberSchema>;
export type OrganizationInput = z.input<typeof organizationSchema>;
export type TeamInput = z.infer<typeof teamSchema>;
export type InferOrganizationZodRolesFromOption<
	O extends OrganizationOptions | undefined,
> = ZodLiteral<
	O extends {
		roles: {
			[key: string]: any;
		};
	}
		? keyof O["roles"] | (keyof O["roles"])[]
		: "admin" | "member" | "owner" | ("admin" | "member" | "owner")[]
>;
export type InferOrganizationRolesFromOption<
	O extends OrganizationOptions | undefined,
> = O extends { roles: any } ? keyof O["roles"] : "admin" | "member" | "owner";

export type InvitationStatus = "pending" | "accepted" | "rejected" | "canceled";

export type InferMember<O extends OrganizationOptions> = O["teams"] extends {
	enabled: true;
}
	? {
			id: string;
			organizationId: string;
			role: InferOrganizationRolesFromOption<O>;
			createdAt: Date;
			userId: string;
			teamId?: string;
			user: {
				email: string;
				name: string;
				image?: string;
			};
		}
	: {
			id: string;
			organizationId: string;
			role: InferOrganizationRolesFromOption<O>;
			createdAt: Date;
			userId: string;
			user: {
				email: string;
				name: string;
				image?: string;
			};
		};

export type InferInvitation<O extends OrganizationOptions> =
	O["teams"] extends {
		enabled: true;
	}
		? {
				id: string;
				organizationId: string;
				email: string;
				role: InferOrganizationRolesFromOption<O>;
				status: InvitationStatus;
				inviterId: string;
				expiresAt: Date;
				teamId?: string;
			}
		: {
				id: string;
				organizationId: string;
				email: string;
				role: InferOrganizationRolesFromOption<O>;
				status: InvitationStatus;
				inviterId: string;
				expiresAt: Date;
			};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/team.test.ts
```typescript
import { describe, expect } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";
import { organization } from "./organization";
import { createAuthClient } from "../../client";
import { organizationClient } from "./client";

describe("team", async (it) => {
	const { auth, signInWithTestUser, signInWithUser, cookieSetter } =
		await getTestInstance({
			user: {
				modelName: "users",
			},
			plugins: [
				organization({
					async sendInvitationEmail(data, request) {},
					teams: {
						enabled: true,
					},
				}),
			],
			logger: {
				level: "error",
			},
		});

	const { headers } = await signInWithTestUser();
	const client = createAuthClient({
		plugins: [
			organizationClient({
				teams: {
					enabled: true,
				},
			}),
		],
		baseURL: "http://localhost:3000/api/auth",
		fetchOptions: {
			customFetchImpl: async (url, init) => {
				return auth.handler(new Request(url, init));
			},
		},
	});

	let organizationId: string;
	let teamId: string;
	let secondTeamId: string;

	const invitedUser = {
		email: "invited@email.com",
		password: "password",
		name: "Invited User",
	};

	it("should create an organization and a team", async () => {
		const createOrganizationResponse = await client.organization.create({
			name: "Test Organization",
			slug: "test-org",
			metadata: {
				test: "organization-metadata",
			},
			fetchOptions: {
				headers,
			},
		});

		organizationId = createOrganizationResponse.data?.id as string;
		expect(createOrganizationResponse.data?.name).toBe("Test Organization");
		expect(createOrganizationResponse.data?.slug).toBe("test-org");
		expect(createOrganizationResponse.data?.members.length).toBe(1);
		expect(createOrganizationResponse.data?.metadata?.test).toBe(
			"organization-metadata",
		);

		const createTeamResponse = await client.organization.createTeam(
			{
				name: "Development Team",
				organizationId,
			},
			{
				headers,
			},
		);

		teamId = createTeamResponse.data?.id as string;
		expect(createTeamResponse.data?.name).toBe("Development Team");
		expect(createTeamResponse.data?.organizationId).toBe(organizationId);

		const createSecondTeamResponse = await client.organization.createTeam(
			{
				name: "Marketing Team",
				organizationId,
			},
			{
				headers,
			},
		);

		secondTeamId = createSecondTeamResponse.data?.id as string;
		expect(createSecondTeamResponse.data?.name).toBe("Marketing Team");
		expect(createSecondTeamResponse.data?.organizationId).toBe(organizationId);
	});

	it("should invite member to team", async () => {
		expect(teamId).toBeDefined();

		const res = await client.organization.inviteMember(
			{
				teamId,
				email: invitedUser.email,
				role: "member",
			},
			{
				headers,
			},
		);

		expect(res.data).toMatchObject({
			email: invitedUser.email,
			role: "member",
			teamId,
		});

		const newHeaders = new Headers();
		const signUpRes = await client.signUp.email(invitedUser, {
			onSuccess: cookieSetter(newHeaders),
		});

		expect(signUpRes.data?.user).toBeDefined();

		const invitation = await client.organization.acceptInvitation(
			{
				invitationId: res.data?.id as string,
			},
			{
				headers: newHeaders,
			},
		);

		expect(invitation.data?.member).toMatchObject({
			role: "member",
			teamId,
			userId: signUpRes.data?.user.id,
		});
	});

	it("should get full organization", async () => {
		const organization = await client.organization.getFullOrganization({
			fetchOptions: {
				headers,
			},
		});

		const teams = organization.data?.teams;
		expect(teams).toBeDefined();
		expect(teams?.length).toBe(3);

		const teamNames = teams?.map((team) => team.name);
		expect(teamNames).toContain("Development Team");
		expect(teamNames).toContain("Marketing Team");
	});

	it("should get all teams", async () => {
		const teamsResponse = await client.organization.listTeams({
			fetchOptions: { headers },
		});

		expect(teamsResponse.data).toBeInstanceOf(Array);
		expect(teamsResponse.data).toHaveLength(3);
	});

	it("should update a team", async () => {
		const updateTeamResponse = await client.organization.updateTeam({
			teamId,
			data: {
				name: "Updated Development Team",
			},
			fetchOptions: { headers },
		});

		expect(updateTeamResponse.data?.name).toBe("Updated Development Team");
		expect(updateTeamResponse.data?.id).toBe(teamId);
	});

	it("should remove a team", async () => {
		const teamsBeforeRemoval = await client.organization.listTeams({
			fetchOptions: { headers },
		});
		expect(teamsBeforeRemoval.data).toHaveLength(3);

		const removeTeamResponse = await client.organization.removeTeam({
			teamId,
			organizationId,
			fetchOptions: { headers },
		});

		expect(removeTeamResponse.data?.message).toBe("Team removed successfully.");

		const teamsAfterRemoval = await client.organization.listTeams({
			fetchOptions: { headers },
		});

		expect(teamsAfterRemoval.data).toHaveLength(2);
	});

	it("should not be able to remove the last team when allowRemovingAllTeams is not enabled", async () => {
		try {
			await client.organization.removeTeam({
				teamId: secondTeamId,
				organizationId,
				fetchOptions: { headers },
			});
			expect(true).toBe(false);
		} catch (error) {
			expect(error).toBeDefined();
		}
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/access/index.ts
```typescript
export * from "./statement";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/access/statement.ts
```typescript
import { createAccessControl } from "../../access";

export const defaultStatements = {
	organization: ["update", "delete"],
	member: ["create", "update", "delete"],
	invitation: ["create", "cancel"],
	team: ["create", "update", "delete"],
} as const;

export const defaultAc = createAccessControl(defaultStatements);

export const adminAc = defaultAc.newRole({
	organization: ["update"],
	invitation: ["create", "cancel"],
	member: ["create", "update", "delete"],
	team: ["create", "update", "delete"],
});

export const ownerAc = defaultAc.newRole({
	organization: ["update", "delete"],
	member: ["create", "update", "delete"],
	invitation: ["create", "cancel"],
	team: ["create", "update", "delete"],
});

export const memberAc = defaultAc.newRole({
	organization: [],
	member: [],
	invitation: [],
	team: [],
});

export const defaultRoles = {
	admin: adminAc,
	owner: ownerAc,
	member: memberAc,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/routes/crud-invites.ts
```typescript
import { z } from "zod";
import { createAuthEndpoint } from "../../../api/call";
import { getSessionFromCtx } from "../../../api/routes";
import { getOrgAdapter } from "../adapter";
import { orgMiddleware, orgSessionMiddleware } from "../call";
import { type InferOrganizationRolesFromOption } from "../schema";
import { APIError } from "better-call";
import { parseRoles, type OrganizationOptions } from "../organization";
import { ORGANIZATION_ERROR_CODES } from "../error-codes";
import { hasPermission } from "../has-permission";

export const createInvitation = <O extends OrganizationOptions | undefined>(
	option: O,
) =>
	createAuthEndpoint(
		"/organization/invite-member",
		{
			method: "POST",
			use: [orgMiddleware, orgSessionMiddleware],
			body: z.object({
				email: z.string({
					description: "The email address of the user to invite",
				}),
				role: z.union([
					z.string({
						description: "The role to assign to the user",
					}),
					z.array(
						z.string({
							description: "The roles to assign to the user",
						}),
					),
				]),
				organizationId: z
					.string({
						description: "The organization ID to invite the user to",
					})
					.optional(),
				resend: z
					.boolean({
						description:
							"Resend the invitation email, if the user is already invited",
					})
					.optional(),
				teamId: z
					.string({
						description: "The team ID to invite the user to",
					})
					.optional(),
			}),
			metadata: {
				$Infer: {
					body: {} as {
						/**
						 * The email address of the user
						 * to invite
						 */
						email: string;
						/**
						 * The role to assign to the user
						 */
						role:
							| InferOrganizationRolesFromOption<O>
							| InferOrganizationRolesFromOption<O>[];
						/**
						 * The organization ID to invite
						 * the user to
						 */
						organizationId?: string;
						/**
						 * Resend the invitation email, if
						 * the user is already invited
						 */
						resend?: boolean;
					} & (O extends { teams: { enabled: true } }
						? {
								/**
								 * The team the user is
								 * being invited to.
								 */
								teamId?: string;
							}
						: {}),
				},
				openapi: {
					description: "Invite a user to an organization",
					responses: {
						"200": {
							description: "Success",
							content: {
								"application/json": {
									schema: {
										type: "object",
										properties: {
											id: {
												type: "string",
											},
											email: {
												type: "string",
											},
											role: {
												type: "string",
											},
											organizationId: {
												type: "string",
											},
											inviterId: {
												type: "string",
											},
											status: {
												type: "string",
											},
											expiresAt: {
												type: "string",
											},
										},
										required: [
											"id",
											"email",
											"role",
											"organizationId",
											"inviterId",
											"status",
											"expiresAt",
										],
									},
								},
							},
						},
					},
				},
			},
		},
		async (ctx) => {
			if (!ctx.context.orgOptions.sendInvitationEmail) {
				ctx.context.logger.warn(
					"Invitation email is not enabled. Pass `sendInvitationEmail` to the plugin options to enable it.",
				);
				throw new APIError("BAD_REQUEST", {
					message: "Invitation email is not enabled",
				});
			}

			const session = ctx.context.session;
			const organizationId =
				ctx.body.organizationId || session.session.activeOrganizationId;
			if (!organizationId) {
				throw new APIError("BAD_REQUEST", {
					message: ORGANIZATION_ERROR_CODES.ORGANIZATION_NOT_FOUND,
				});
			}
			const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
			const member = await adapter.findMemberByOrgId({
				userId: session.user.id,
				organizationId: organizationId,
			});
			if (!member) {
				throw new APIError("BAD_REQUEST", {
					message: ORGANIZATION_ERROR_CODES.MEMBER_NOT_FOUND,
				});
			}
			const canInvite = hasPermission({
				role: member.role,
				options: ctx.context.orgOptions,
				permission: {
					invitation: ["create"],
				},
			});
			if (!canInvite) {
				throw new APIError("FORBIDDEN", {
					message:
						ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_INVITE_USERS_TO_THIS_ORGANIZATION,
				});
			}

			const creatorRole = ctx.context.orgOptions.creatorRole || "owner";

			const roles = parseRoles(ctx.body.role as string | string[]);

			if (
				member.role !== creatorRole &&
				roles.split(",").includes(creatorRole)
			) {
				throw new APIError("FORBIDDEN", {
					message:
						ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_INVITE_USER_WITH_THIS_ROLE,
				});
			}

			const alreadyMember = await adapter.findMemberByEmail({
				email: ctx.body.email,
				organizationId: organizationId,
			});
			if (alreadyMember) {
				throw new APIError("BAD_REQUEST", {
					message:
						ORGANIZATION_ERROR_CODES.USER_IS_ALREADY_A_MEMBER_OF_THIS_ORGANIZATION,
				});
			}
			const alreadyInvited = await adapter.findPendingInvitation({
				email: ctx.body.email,
				organizationId: organizationId,
			});
			if (alreadyInvited.length && !ctx.body.resend) {
				throw new APIError("BAD_REQUEST", {
					message:
						ORGANIZATION_ERROR_CODES.USER_IS_ALREADY_INVITED_TO_THIS_ORGANIZATION,
				});
			}
			const invitation = await adapter.createInvitation({
				invitation: {
					role: roles,
					email: ctx.body.email,
					organizationId: organizationId,
					...("teamId" in ctx.body
						? {
								teamId: ctx.body.teamId,
							}
						: {}),
				},
				user: session.user,
			});

			const organization = await adapter.findOrganizationById(organizationId);

			if (!organization) {
				throw new APIError("BAD_REQUEST", {
					message: ORGANIZATION_ERROR_CODES.ORGANIZATION_NOT_FOUND,
				});
			}

			await ctx.context.orgOptions.sendInvitationEmail?.(
				{
					id: invitation.id,
					role: invitation.role as string,
					email: invitation.email.toLowerCase(),
					organization: organization,
					inviter: {
						...member,
						user: session.user,
					},
					invitation,
				},
				ctx.request,
			);
			return ctx.json(invitation);
		},
	);

export const acceptInvitation = createAuthEndpoint(
	"/organization/accept-invitation",
	{
		method: "POST",
		body: z.object({
			invitationId: z.string({
				description: "The ID of the invitation to accept",
			}),
		}),
		use: [orgMiddleware, orgSessionMiddleware],
		metadata: {
			openapi: {
				description: "Accept an invitation to an organization",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										invitation: {
											type: "object",
										},
										member: {
											type: "object",
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
		const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
		const invitation = await adapter.findInvitationById(ctx.body.invitationId);
		if (
			!invitation ||
			invitation.expiresAt < new Date() ||
			invitation.status !== "pending"
		) {
			throw new APIError("BAD_REQUEST", {
				message: ORGANIZATION_ERROR_CODES.INVITATION_NOT_FOUND,
			});
		}
		if (invitation.email !== session.user.email) {
			throw new APIError("FORBIDDEN", {
				message:
					ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_THE_RECIPIENT_OF_THE_INVITATION,
			});
		}
		const membershipLimit = ctx.context.orgOptions?.membershipLimit || 100;
		const members = await adapter.listMembers({
			organizationId: invitation.organizationId,
		});

		if (members.length >= membershipLimit) {
			throw new APIError("FORBIDDEN", {
				message: ORGANIZATION_ERROR_CODES.ORGANIZATION_MEMBERSHIP_LIMIT_REACHED,
			});
		}
		const acceptedI = await adapter.updateInvitation({
			invitationId: ctx.body.invitationId,
			status: "accepted",
		});
		if (!acceptedI) {
			throw new APIError("BAD_REQUEST", {
				message: ORGANIZATION_ERROR_CODES.FAILED_TO_RETRIEVE_INVITATION,
			});
		}
		const member = await adapter.createMember({
			organizationId: invitation.organizationId,
			userId: session.user.id,
			role: invitation.role,
			createdAt: new Date(),
			...("teamId" in acceptedI
				? {
						teamId: acceptedI.teamId,
					}
				: {}),
		});
		await adapter.setActiveOrganization(
			session.session.token,
			invitation.organizationId,
		);
		if (!acceptedI) {
			return ctx.json(null, {
				status: 400,
				body: {
					message: ORGANIZATION_ERROR_CODES.INVITATION_NOT_FOUND,
				},
			});
		}
		return ctx.json({
			invitation: acceptedI,
			member,
		});
	},
);
export const rejectInvitation = createAuthEndpoint(
	"/organization/reject-invitation",
	{
		method: "POST",
		body: z.object({
			invitationId: z.string({
				description: "The ID of the invitation to reject",
			}),
		}),
		use: [orgMiddleware, orgSessionMiddleware],
		metadata: {
			openapi: {
				description: "Reject an invitation to an organization",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										invitation: {
											type: "object",
										},
										member: {
											type: "null",
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
		const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
		const invitation = await adapter.findInvitationById(ctx.body.invitationId);
		if (
			!invitation ||
			invitation.expiresAt < new Date() ||
			invitation.status !== "pending"
		) {
			throw new APIError("BAD_REQUEST", {
				message: "Invitation not found!",
			});
		}
		if (invitation.email !== session.user.email) {
			throw new APIError("FORBIDDEN", {
				message:
					ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_THE_RECIPIENT_OF_THE_INVITATION,
			});
		}
		const rejectedI = await adapter.updateInvitation({
			invitationId: ctx.body.invitationId,
			status: "rejected",
		});
		return ctx.json({
			invitation: rejectedI,
			member: null,
		});
	},
);

export const cancelInvitation = createAuthEndpoint(
	"/organization/cancel-invitation",
	{
		method: "POST",
		body: z.object({
			invitationId: z.string({
				description: "The ID of the invitation to cancel",
			}),
		}),
		use: [orgMiddleware, orgSessionMiddleware],
		openapi: {
			description: "Cancel an invitation to an organization",
			responses: {
				"200": {
					description: "Success",
					content: {
						"application/json": {
							schema: {
								type: "object",
								properties: {
									invitation: {
										type: "object",
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
		const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
		const invitation = await adapter.findInvitationById(ctx.body.invitationId);
		if (!invitation) {
			throw new APIError("BAD_REQUEST", {
				message: ORGANIZATION_ERROR_CODES.INVITATION_NOT_FOUND,
			});
		}
		const member = await adapter.findMemberByOrgId({
			userId: session.user.id,
			organizationId: invitation.organizationId,
		});
		if (!member) {
			throw new APIError("BAD_REQUEST", {
				message: ORGANIZATION_ERROR_CODES.MEMBER_NOT_FOUND,
			});
		}
		const canCancel = hasPermission({
			role: member.role,
			options: ctx.context.orgOptions,
			permission: {
				invitation: ["cancel"],
			},
		});
		if (!canCancel) {
			throw new APIError("FORBIDDEN", {
				message:
					ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_CANCEL_THIS_INVITATION,
			});
		}
		const canceledI = await adapter.updateInvitation({
			invitationId: ctx.body.invitationId,
			status: "canceled",
		});
		return ctx.json(canceledI);
	},
);

export const getInvitation = createAuthEndpoint(
	"/organization/get-invitation",
	{
		method: "GET",
		use: [orgMiddleware],
		requireHeaders: true,
		query: z.object({
			id: z.string({
				description: "The ID of the invitation to get",
			}),
		}),
		metadata: {
			openapi: {
				description: "Get an invitation by ID",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										id: {
											type: "string",
										},
										email: {
											type: "string",
										},
										role: {
											type: "string",
										},
										organizationId: {
											type: "string",
										},
										inviterId: {
											type: "string",
										},
										status: {
											type: "string",
										},
										expiresAt: {
											type: "string",
										},
										organizationName: {
											type: "string",
										},
										organizationSlug: {
											type: "string",
										},
										inviterEmail: {
											type: "string",
										},
									},
									required: [
										"id",
										"email",
										"role",
										"organizationId",
										"inviterId",
										"status",
										"expiresAt",
										"organizationName",
										"organizationSlug",
										"inviterEmail",
									],
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		const session = await getSessionFromCtx(ctx);
		if (!session) {
			throw new APIError("UNAUTHORIZED", {
				message: "Not authenticated",
			});
		}
		const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
		const invitation = await adapter.findInvitationById(ctx.query.id);
		if (
			!invitation ||
			invitation.status !== "pending" ||
			invitation.expiresAt < new Date()
		) {
			throw new APIError("BAD_REQUEST", {
				message: "Invitation not found!",
			});
		}
		if (invitation.email !== session.user.email) {
			throw new APIError("FORBIDDEN", {
				message:
					ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_THE_RECIPIENT_OF_THE_INVITATION,
			});
		}
		const organization = await adapter.findOrganizationById(
			invitation.organizationId,
		);
		if (!organization) {
			throw new APIError("BAD_REQUEST", {
				message: ORGANIZATION_ERROR_CODES.ORGANIZATION_NOT_FOUND,
			});
		}
		const member = await adapter.findMemberByOrgId({
			userId: invitation.inviterId,
			organizationId: invitation.organizationId,
		});
		if (!member) {
			throw new APIError("BAD_REQUEST", {
				message:
					ORGANIZATION_ERROR_CODES.INVITER_IS_NO_LONGER_A_MEMBER_OF_THE_ORGANIZATION,
			});
		}

		return ctx.json({
			...invitation,
			organizationName: organization.name,
			organizationSlug: organization.slug,
			inviterEmail: member.user.email,
		});
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/routes/crud-members.ts
```typescript
import { z } from "zod";
import { createAuthEndpoint } from "../../../api/call";
import { getOrgAdapter } from "../adapter";
import { orgMiddleware, orgSessionMiddleware } from "../call";
import type { InferOrganizationRolesFromOption, Member } from "../schema";
import { APIError } from "better-call";
import { generateId } from "../../../utils";
import { parseRoles, type OrganizationOptions } from "../organization";
import { getSessionFromCtx, sessionMiddleware } from "../../../api";
import { ORGANIZATION_ERROR_CODES } from "../error-codes";
import { BASE_ERROR_CODES } from "../../../error/codes";
import { hasPermission } from "../has-permission";

export const addMember = <O extends OrganizationOptions>() =>
	createAuthEndpoint(
		"/organization/add-member",
		{
			method: "POST",
			body: z.object({
				userId: z.coerce.string(),
				role: z.union([z.string(), z.array(z.string())]),
				organizationId: z.string().optional(),
			}),
			use: [orgMiddleware],
			metadata: {
				SERVER_ONLY: true,
				$Infer: {
					body: {} as {
						userId: string;
						role:
							| InferOrganizationRolesFromOption<O>
							| InferOrganizationRolesFromOption<O>[];
						organizationId?: string;
					} & (O extends { teams: { enabled: true } }
						? { teamId?: string }
						: {}),
				},
			},
		},
		async (ctx) => {
			const session = ctx.body.userId
				? await getSessionFromCtx<{
						session: {
							activeOrganizationId?: string;
						};
					}>(ctx).catch((e) => null)
				: null;
			const orgId =
				ctx.body.organizationId || session?.session.activeOrganizationId;
			if (!orgId) {
				return ctx.json(null, {
					status: 400,
					body: {
						message: ORGANIZATION_ERROR_CODES.NO_ACTIVE_ORGANIZATION,
					},
				});
			}

			const teamId = "teamId" in ctx.body ? ctx.body.teamId : undefined;
			if (teamId && !ctx.context.orgOptions.teams?.enabled) {
				ctx.context.logger.error("Teams are not enabled");
				throw new APIError("BAD_REQUEST", {
					message: "Teams are not enabled",
				});
			}

			const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);

			const user = await ctx.context.internalAdapter.findUserById(
				ctx.body.userId,
			);

			if (!user) {
				throw new APIError("BAD_REQUEST", {
					message: BASE_ERROR_CODES.USER_NOT_FOUND,
				});
			}

			const alreadyMember = await adapter.findMemberByEmail({
				email: user.email,
				organizationId: orgId,
			});

			if (alreadyMember) {
				throw new APIError("BAD_REQUEST", {
					message:
						ORGANIZATION_ERROR_CODES.USER_IS_ALREADY_A_MEMBER_OF_THIS_ORGANIZATION,
				});
			}

			if (teamId) {
				const team = await adapter.findTeamById({
					teamId,
					organizationId: orgId,
				});
				if (!team || team.organizationId !== orgId) {
					throw new APIError("BAD_REQUEST", {
						message: ORGANIZATION_ERROR_CODES.TEAM_NOT_FOUND,
					});
				}
			}

			const membershipLimit = ctx.context.orgOptions?.membershipLimit || 100;
			const members = await adapter.listMembers({ organizationId: orgId });

			if (members.length >= membershipLimit) {
				throw new APIError("FORBIDDEN", {
					message:
						ORGANIZATION_ERROR_CODES.ORGANIZATION_MEMBERSHIP_LIMIT_REACHED,
				});
			}

			const createdMember = await adapter.createMember({
				id: generateId(),
				organizationId: orgId,
				userId: user.id,
				role: parseRoles(ctx.body.role as string | string[]),
				createdAt: new Date(),
				...(teamId ? { teamId: teamId } : {}),
			});

			return ctx.json(createdMember);
		},
	);

export const removeMember = createAuthEndpoint(
	"/organization/remove-member",
	{
		method: "POST",
		body: z.object({
			memberIdOrEmail: z.string({
				description: "The ID or email of the member to remove",
			}),
			/**
			 * If not provided, the active organization will be used
			 */
			organizationId: z
				.string({
					description:
						"The ID of the organization to remove the member from. If not provided, the active organization will be used",
				})
				.optional(),
		}),
		use: [orgMiddleware, orgSessionMiddleware],
		metadata: {
			openapi: {
				description: "Remove a member from an organization",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										member: {
											type: "object",
											properties: {
												id: {
													type: "string",
												},
												userId: {
													type: "string",
												},
												organizationId: {
													type: "string",
												},
												role: {
													type: "string",
												},
											},
											required: ["id", "userId", "organizationId", "role"],
										},
									},
									required: ["member"],
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
		const organizationId =
			ctx.body.organizationId || session.session.activeOrganizationId;
		if (!organizationId) {
			return ctx.json(null, {
				status: 400,
				body: {
					message: ORGANIZATION_ERROR_CODES.NO_ACTIVE_ORGANIZATION,
				},
			});
		}
		const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
		const member = await adapter.findMemberByOrgId({
			userId: session.user.id,
			organizationId: organizationId,
		});
		if (!member) {
			throw new APIError("BAD_REQUEST", {
				message: ORGANIZATION_ERROR_CODES.MEMBER_NOT_FOUND,
			});
		}
		let toBeRemovedMember: Member | null = null;
		if (ctx.body.memberIdOrEmail.includes("@")) {
			toBeRemovedMember = await adapter.findMemberByEmail({
				email: ctx.body.memberIdOrEmail,
				organizationId: organizationId,
			});
		} else {
			toBeRemovedMember = await adapter.findMemberById(
				ctx.body.memberIdOrEmail,
			);
		}
		if (!toBeRemovedMember) {
			throw new APIError("BAD_REQUEST", {
				message: ORGANIZATION_ERROR_CODES.MEMBER_NOT_FOUND,
			});
		}
		const roles = toBeRemovedMember.role.split(",");
		const creatorRole = ctx.context.orgOptions?.creatorRole || "owner";
		const isOwner = roles.includes(creatorRole);
		if (isOwner) {
			if (member.role !== creatorRole) {
				throw new APIError("BAD_REQUEST", {
					message:
						ORGANIZATION_ERROR_CODES.YOU_CANNOT_LEAVE_THE_ORGANIZATION_AS_THE_ONLY_OWNER,
				});
			}
			const members = await adapter.listMembers({
				organizationId: organizationId,
			});
			const owners = members.filter((member) => {
				const roles = member.role.split(",");
				return roles.includes(creatorRole);
			});
			if (owners.length <= 1) {
				throw new APIError("BAD_REQUEST", {
					message:
						ORGANIZATION_ERROR_CODES.YOU_CANNOT_LEAVE_THE_ORGANIZATION_AS_THE_ONLY_OWNER,
				});
			}
		}
		const canDeleteMember = hasPermission({
			role: member.role,
			options: ctx.context.orgOptions,
			permission: {
				member: ["delete"],
			},
		});
		if (!canDeleteMember) {
			throw new APIError("UNAUTHORIZED", {
				message:
					ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_DELETE_THIS_MEMBER,
			});
		}

		if (toBeRemovedMember?.organizationId !== organizationId) {
			throw new APIError("BAD_REQUEST", {
				message: ORGANIZATION_ERROR_CODES.MEMBER_NOT_FOUND,
			});
		}
		await adapter.deleteMember(toBeRemovedMember.id);
		if (
			session.user.id === toBeRemovedMember.userId &&
			session.session.activeOrganizationId === toBeRemovedMember.organizationId
		) {
			await adapter.setActiveOrganization(session.session.token, null);
		}
		return ctx.json({
			member: toBeRemovedMember,
		});
	},
);

export const updateMemberRole = <O extends OrganizationOptions>(option: O) =>
	createAuthEndpoint(
		"/organization/update-member-role",
		{
			method: "POST",
			body: z.object({
				role: z.union([z.string(), z.array(z.string())]),
				memberId: z.string(),
				organizationId: z.string().optional(),
			}),
			use: [orgMiddleware, orgSessionMiddleware],
			metadata: {
				$Infer: {
					body: {} as {
						role:
							| InferOrganizationRolesFromOption<O>
							| InferOrganizationRolesFromOption<O>[];
						memberId: string;
						/**
						 * If not provided, the active organization will be used
						 */
						organizationId?: string;
					},
				},
				openapi: {
					description: "Update the role of a member in an organization",
					responses: {
						"200": {
							description: "Success",
							content: {
								"application/json": {
									schema: {
										type: "object",
										properties: {
											member: {
												type: "object",
												properties: {
													id: {
														type: "string",
													},
													userId: {
														type: "string",
													},
													organizationId: {
														type: "string",
													},
													role: {
														type: "string",
													},
												},
												required: ["id", "userId", "organizationId", "role"],
											},
										},
										required: ["member"],
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

			if (!ctx.body.role) {
				throw new APIError("BAD_REQUEST");
			}

			const organizationId =
				ctx.body.organizationId || session.session.activeOrganizationId;

			if (!organizationId) {
				throw new APIError("BAD_REQUEST", {
					message: ORGANIZATION_ERROR_CODES.NO_ACTIVE_ORGANIZATION,
				});
			}

			const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
			const roleToSet: string[] = Array.isArray(ctx.body.role)
				? (ctx.body.role as string[])
				: ctx.body.role
					? [ctx.body.role as string]
					: [];

			const member = await adapter.findMemberByOrgId({
				userId: session.user.id,
				organizationId: organizationId,
			});

			if (!member) {
				throw new APIError("BAD_REQUEST", {
					message: ORGANIZATION_ERROR_CODES.MEMBER_NOT_FOUND,
				});
			}

			const toBeUpdatedMember =
				member.id !== ctx.body.memberId
					? await adapter.findMemberById(ctx.body.memberId)
					: member;

			if (!toBeUpdatedMember) {
				throw new APIError("BAD_REQUEST", {
					message: ORGANIZATION_ERROR_CODES.MEMBER_NOT_FOUND,
				});
			}

			const toBeUpdatedMemberRoles = toBeUpdatedMember.role.split(",");
			const updatingMemberRoles = member.role.split(",");
			const creatorRole = ctx.context.orgOptions?.creatorRole || "owner";

			if (
				(toBeUpdatedMemberRoles.includes(creatorRole) &&
					!updatingMemberRoles.includes(creatorRole)) ||
				(roleToSet.includes(creatorRole) &&
					!updatingMemberRoles.includes(creatorRole))
			) {
				throw new APIError("FORBIDDEN", {
					message:
						ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_UPDATE_THIS_MEMBER,
				});
			}

			const canUpdateMember = hasPermission({
				role: member.role,
				options: ctx.context.orgOptions,
				permission: {
					member: ["update"],
				},
			});

			if (!canUpdateMember) {
				throw new APIError("FORBIDDEN", {
					message:
						ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_UPDATE_THIS_MEMBER,
				});
			}
			const updatedMember = await adapter.updateMember(
				ctx.body.memberId,
				parseRoles(ctx.body.role as string | string[]),
			);
			if (!updatedMember) {
				throw new APIError("BAD_REQUEST", {
					message: ORGANIZATION_ERROR_CODES.MEMBER_NOT_FOUND,
				});
			}
			return ctx.json(updatedMember);
		},
	);

export const getActiveMember = createAuthEndpoint(
	"/organization/get-active-member",
	{
		method: "GET",
		use: [orgMiddleware, orgSessionMiddleware],
		metadata: {
			openapi: {
				description: "Get the active member in the organization",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									properties: {
										id: {
											type: "string",
										},
										userId: {
											type: "string",
										},
										organizationId: {
											type: "string",
										},
										role: {
											type: "string",
										},
									},
									required: ["id", "userId", "organizationId", "role"],
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
		const organizationId = session.session.activeOrganizationId;
		if (!organizationId) {
			return ctx.json(null, {
				status: 400,
				body: {
					message: ORGANIZATION_ERROR_CODES.NO_ACTIVE_ORGANIZATION,
				},
			});
		}
		const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
		const member = await adapter.findMemberByOrgId({
			userId: session.user.id,
			organizationId: organizationId,
		});
		if (!member) {
			return ctx.json(null, {
				status: 400,
				body: {
					message: ORGANIZATION_ERROR_CODES.MEMBER_NOT_FOUND,
				},
			});
		}
		return ctx.json(member);
	},
);

export const leaveOrganization = createAuthEndpoint(
	"/organization/leave",
	{
		method: "POST",
		body: z.object({
			organizationId: z.string(),
		}),
		use: [sessionMiddleware, orgMiddleware],
	},
	async (ctx) => {
		const session = ctx.context.session;
		const adapter = getOrgAdapter(ctx.context);
		const member = await adapter.findMemberByOrgId({
			userId: session.user.id,
			organizationId: ctx.body.organizationId,
		});
		if (!member) {
			throw new APIError("BAD_REQUEST", {
				message: ORGANIZATION_ERROR_CODES.MEMBER_NOT_FOUND,
			});
		}
		const isOwnerLeaving =
			member.role === (ctx.context.orgOptions?.creatorRole || "owner");
		if (isOwnerLeaving) {
			const members = await ctx.context.adapter.findMany<Member>({
				model: "member",
				where: [
					{
						field: "organizationId",
						value: ctx.body.organizationId,
					},
				],
			});
			const owners = members.filter(
				(member) =>
					member.role === (ctx.context.orgOptions?.creatorRole || "owner"),
			);
			if (owners.length <= 1) {
				throw new APIError("BAD_REQUEST", {
					message:
						ORGANIZATION_ERROR_CODES.YOU_CANNOT_LEAVE_THE_ORGANIZATION_AS_THE_ONLY_OWNER,
				});
			}
		}
		await adapter.deleteMember(member.id);
		if (session.session.activeOrganizationId === ctx.body.organizationId) {
			await adapter.setActiveOrganization(session.session.token, null);
		}
		return ctx.json(member);
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/routes/crud-org.ts
```typescript
import { z } from "zod";
import { createAuthEndpoint } from "../../../api/call";
import { generateId } from "../../../utils/id";
import { getOrgAdapter } from "../adapter";
import { orgMiddleware, orgSessionMiddleware } from "../call";
import { APIError } from "better-call";
import { setSessionCookie } from "../../../cookies";
import { ORGANIZATION_ERROR_CODES } from "../error-codes";
import { getSessionFromCtx, requestOnlySessionMiddleware } from "../../../api";
import type { OrganizationOptions } from "../organization";
import type {
	InferInvitation,
	InferMember,
	Member,
	Organization,
	Team,
} from "../schema";
import { hasPermission } from "../has-permission";

export const createOrganization = createAuthEndpoint(
	"/organization/create",
	{
		method: "POST",
		body: z.object({
			name: z.string({
				description: "The name of the organization",
			}),
			slug: z.string({
				description: "The slug of the organization",
			}),
			userId: z.coerce
				.string({
					description:
						"The user id of the organization creator. If not provided, the current user will be used. Should only be used by admins or when called by the server.",
				})
				.optional(),
			logo: z
				.string({
					description: "The logo of the organization",
				})
				.optional(),
			metadata: z
				.record(z.string(), z.any(), {
					description: "The metadata of the organization",
				})
				.optional(),
			keepCurrentActiveOrganization: z
				.boolean({
					description:
						"Whether to keep the current active organization active after creating a new one",
				})
				.optional(),
		}),
		use: [orgMiddleware],
		metadata: {
			openapi: {
				description: "Create an organization",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									description: "The organization that was created",
									$ref: "#/components/schemas/Organization",
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		const session = await getSessionFromCtx(ctx);

		if (!session && (ctx.request || ctx.headers)) {
			throw new APIError("UNAUTHORIZED");
		}
		let user = session?.user || null;
		if (!user) {
			if (!ctx.body.userId) {
				throw new APIError("UNAUTHORIZED");
			}
			user = await ctx.context.internalAdapter.findUserById(ctx.body.userId);
		}
		if (!user) {
			return ctx.json(null, {
				status: 401,
			});
		}
		const options = ctx.context.orgOptions;
		const canCreateOrg =
			typeof options?.allowUserToCreateOrganization === "function"
				? await options.allowUserToCreateOrganization(user)
				: options?.allowUserToCreateOrganization === undefined
					? true
					: options.allowUserToCreateOrganization;

		if (!canCreateOrg) {
			throw new APIError("FORBIDDEN", {
				message:
					ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_CREATE_A_NEW_ORGANIZATION,
			});
		}
		const adapter = getOrgAdapter(ctx.context, options);

		const userOrganizations = await adapter.listOrganizations(user.id);
		const hasReachedOrgLimit =
			typeof options.organizationLimit === "number"
				? userOrganizations.length >= options.organizationLimit
				: typeof options.organizationLimit === "function"
					? await options.organizationLimit(user)
					: false;

		if (hasReachedOrgLimit) {
			throw new APIError("FORBIDDEN", {
				message:
					ORGANIZATION_ERROR_CODES.YOU_HAVE_REACHED_THE_MAXIMUM_NUMBER_OF_ORGANIZATIONS,
			});
		}

		const existingOrganization = await adapter.findOrganizationBySlug(
			ctx.body.slug,
		);
		if (existingOrganization) {
			throw new APIError("BAD_REQUEST", {
				message: ORGANIZATION_ERROR_CODES.ORGANIZATION_ALREADY_EXISTS,
			});
		}

		let hookResponse:
			| {
					data: Omit<Organization, "id">;
			  }
			| undefined = undefined;
		if (options.organizationCreation?.beforeCreate) {
			const response = await options.organizationCreation.beforeCreate(
				{
					organization: {
						slug: ctx.body.slug,
						name: ctx.body.name,
						logo: ctx.body.logo,
						createdAt: new Date(),
						metadata: ctx.body.metadata,
					},
					user,
				},
				ctx.request,
			);
			if (response && typeof response === "object" && "data" in response) {
				hookResponse = response;
			}
		}

		const organization = await adapter.createOrganization({
			organization: {
				id: generateId(),
				slug: ctx.body.slug,
				name: ctx.body.name,
				logo: ctx.body.logo,
				createdAt: new Date(),
				metadata: ctx.body.metadata,
				...(hookResponse?.data || {}),
			},
		});
		let member: Member | undefined;
		if (
			options?.teams?.enabled &&
			options.teams.defaultTeam?.enabled !== false
		) {
			const defaultTeam =
				(await options.teams.defaultTeam?.customCreateDefaultTeam?.(
					organization,
					ctx.request,
				)) ||
				(await adapter.createTeam({
					id: generateId(),
					organizationId: organization.id,
					name: `${organization.name}`,
					createdAt: new Date(),
				}));

			member = await adapter.createMember({
				teamId: defaultTeam.id,
				userId: user.id,
				organizationId: organization.id,
				role: ctx.context.orgOptions.creatorRole || "owner",
			});
		} else {
			member = await adapter.createMember({
				userId: user.id,
				organizationId: organization.id,
				role: ctx.context.orgOptions.creatorRole || "owner",
			});
		}

		if (options.organizationCreation?.afterCreate) {
			await options.organizationCreation.afterCreate(
				{
					organization,
					user,
					member,
				},
				ctx.request,
			);
		}

		if (ctx.context.session && !ctx.body.keepCurrentActiveOrganization) {
			await adapter.setActiveOrganization(
				ctx.context.session.session.token,
				organization.id,
			);
		}

		return ctx.json({
			...organization,
			metadata: ctx.body.metadata,
			members: [member],
		});
	},
);

export const checkOrganizationSlug = createAuthEndpoint(
	"/organization/check-slug",
	{
		method: "POST",
		body: z.object({
			slug: z.string(),
		}),
		use: [requestOnlySessionMiddleware, orgMiddleware],
	},
	async (ctx) => {
		const orgAdapter = getOrgAdapter(ctx.context);
		const org = await orgAdapter.findOrganizationBySlug(ctx.body.slug);
		if (!org) {
			return ctx.json({
				status: true,
			});
		}
		throw new APIError("BAD_REQUEST", {
			message: "slug is taken",
		});
	},
);

export const updateOrganization = createAuthEndpoint(
	"/organization/update",
	{
		method: "POST",
		body: z.object({
			data: z
				.object({
					name: z
						.string({
							description: "The name of the organization",
						})
						.optional(),
					slug: z
						.string({
							description: "The slug of the organization",
						})
						.optional(),
					logo: z
						.string({
							description: "The logo of the organization",
						})
						.optional(),
					metadata: z
						.record(z.string(), z.any(), {
							description: "The metadata of the organization",
						})
						.optional(),
				})
				.partial(),
			organizationId: z.string().optional(),
		}),
		requireHeaders: true,
		use: [orgMiddleware],
		metadata: {
			openapi: {
				description: "Update an organization",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "object",
									description: "The updated organization",
									$ref: "#/components/schemas/Organization",
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		const session = await ctx.context.getSession(ctx);
		if (!session) {
			throw new APIError("UNAUTHORIZED", {
				message: "User not found",
			});
		}
		const organizationId =
			ctx.body.organizationId || session.session.activeOrganizationId;
		if (!organizationId) {
			throw new APIError("BAD_REQUEST", {
				message: ORGANIZATION_ERROR_CODES.ORGANIZATION_NOT_FOUND,
			});
		}
		const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
		const member = await adapter.findMemberByOrgId({
			userId: session.user.id,
			organizationId: organizationId,
		});
		if (!member) {
			throw new APIError("BAD_REQUEST", {
				message:
					ORGANIZATION_ERROR_CODES.USER_IS_NOT_A_MEMBER_OF_THE_ORGANIZATION,
			});
		}
		const canUpdateOrg = hasPermission({
			permission: {
				organization: ["update"],
			},
			role: member.role,
			options: ctx.context.orgOptions,
		});
		if (!canUpdateOrg) {
			throw new APIError("FORBIDDEN", {
				message:
					ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_UPDATE_THIS_ORGANIZATION,
			});
		}
		const updatedOrg = await adapter.updateOrganization(
			organizationId,
			ctx.body.data,
		);
		return ctx.json(updatedOrg);
	},
);

export const deleteOrganization = createAuthEndpoint(
	"/organization/delete",
	{
		method: "POST",
		body: z.object({
			organizationId: z.string({
				description: "The organization id to delete",
			}),
		}),
		requireHeaders: true,
		use: [orgMiddleware],
		metadata: {
			openapi: {
				description: "Delete an organization",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "string",
									description: "The organization id that was deleted",
								},
							},
						},
					},
				},
			},
		},
	},
	async (ctx) => {
		const session = await ctx.context.getSession(ctx);
		if (!session) {
			return ctx.json(null, {
				status: 401,
			});
		}
		const organizationId = ctx.body.organizationId;
		if (!organizationId) {
			return ctx.json(null, {
				status: 400,
				body: {
					message: ORGANIZATION_ERROR_CODES.ORGANIZATION_NOT_FOUND,
				},
			});
		}
		const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
		const member = await adapter.findMemberByOrgId({
			userId: session.user.id,
			organizationId: organizationId,
		});
		if (!member) {
			return ctx.json(null, {
				status: 400,
				body: {
					message:
						ORGANIZATION_ERROR_CODES.USER_IS_NOT_A_MEMBER_OF_THE_ORGANIZATION,
				},
			});
		}
		const canDeleteOrg = hasPermission({
			role: member.role,
			permission: {
				organization: ["delete"],
			},
			options: ctx.context.orgOptions,
		});
		if (!canDeleteOrg) {
			throw new APIError("FORBIDDEN", {
				message:
					ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_DELETE_THIS_ORGANIZATION,
			});
		}
		if (organizationId === session.session.activeOrganizationId) {
			/**
			 * If the organization is deleted, we set the active organization to null
			 */
			await adapter.setActiveOrganization(session.session.token, null);
		}
		const option = ctx.context.orgOptions.organizationDeletion;
		if (option?.disabled) {
			throw new APIError("FORBIDDEN");
		}
		const org = await adapter.findOrganizationById(organizationId);
		if (!org) {
			throw new APIError("BAD_REQUEST");
		}
		if (option?.beforeDelete) {
			await option.beforeDelete({
				organization: org,
				user: session.user,
			});
		}
		await adapter.deleteOrganization(organizationId);
		if (option?.afterDelete) {
			await option.afterDelete({
				organization: org,
				user: session.user,
			});
		}
		return ctx.json(org);
	},
);

export const getFullOrganization = <O extends OrganizationOptions>() =>
	createAuthEndpoint(
		"/organization/get-full-organization",
		{
			method: "GET",
			query: z.optional(
				z.object({
					organizationId: z
						.string({
							description: "The organization id to get",
						})
						.optional(),
					organizationSlug: z
						.string({
							description: "The organization slug to get",
						})
						.optional(),
				}),
			),
			requireHeaders: true,
			use: [orgMiddleware, orgSessionMiddleware],
			metadata: {
				openapi: {
					description: "Get the full organization",
					responses: {
						"200": {
							description: "Success",
							content: {
								"application/json": {
									schema: {
										type: "object",
										description: "The organization",
										$ref: "#/components/schemas/Organization",
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
			const organizationId =
				ctx.query?.organizationSlug ||
				ctx.query?.organizationId ||
				session.session.activeOrganizationId;
			if (!organizationId) {
				return ctx.json(null, {
					status: 200,
				});
			}
			const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
			const organization = await adapter.findFullOrganization({
				organizationId,
				isSlug: !!ctx.query?.organizationSlug,
				includeTeams: ctx.context.orgOptions.teams?.enabled,
			});
			const isMember = organization?.members.find(
				(member) => member.userId === session.user.id,
			);
			if (!isMember) {
				throw new APIError("FORBIDDEN", {
					message:
						ORGANIZATION_ERROR_CODES.USER_IS_NOT_A_MEMBER_OF_THE_ORGANIZATION,
				});
			}
			if (!organization) {
				throw new APIError("BAD_REQUEST", {
					message: ORGANIZATION_ERROR_CODES.ORGANIZATION_NOT_FOUND,
				});
			}
			type OrganizationReturn = O["teams"] extends { enabled: true }
				? {
						members: InferMember<O>[];
						invitations: InferInvitation<O>[];
						teams: Team[];
					} & Organization
				: {
						members: InferMember<O>[];
						invitations: InferInvitation<O>[];
					} & Organization;
			return ctx.json(organization as unknown as OrganizationReturn);
		},
	);

export const setActiveOrganization = <O extends OrganizationOptions>() => {
	return createAuthEndpoint(
		"/organization/set-active",
		{
			method: "POST",
			body: z.object({
				organizationId: z
					.string({
						description:
							"The organization id to set as active. It can be null to unset the active organization",
					})
					.nullable()
					.optional(),
				organizationSlug: z
					.string({
						description:
							"The organization slug to set as active. It can be null to unset the active organization if organizationId is not provided",
					})
					.optional(),
			}),
			use: [orgSessionMiddleware, orgMiddleware],
			metadata: {
				openapi: {
					description: "Set the active organization",
					responses: {
						"200": {
							description: "Success",
							content: {
								"application/json": {
									schema: {
										type: "object",
										description: "The organization",
										$ref: "#/components/schemas/Organization",
									},
								},
							},
						},
					},
				},
			},
		},
		async (ctx) => {
			const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
			const session = ctx.context.session;
			let organizationId = ctx.body.organizationSlug || ctx.body.organizationId;
			if (organizationId === null) {
				const sessionOrgId = session.session.activeOrganizationId;
				if (!sessionOrgId) {
					return ctx.json(null);
				}
				const updatedSession = await adapter.setActiveOrganization(
					session.session.token,
					null,
				);
				await setSessionCookie(ctx, {
					session: updatedSession,
					user: session.user,
				});
				return ctx.json(null);
			}
			if (!organizationId) {
				const sessionOrgId = session.session.activeOrganizationId;
				if (!sessionOrgId) {
					return ctx.json(null);
				}
				organizationId = sessionOrgId;
			}
			const organization = await adapter.findFullOrganization({
				organizationId,
				isSlug: !!ctx.body.organizationSlug,
			});
			const isMember = organization?.members.find(
				(member) => member.userId === session.user.id,
			);
			if (!isMember) {
				await adapter.setActiveOrganization(session.session.token, null);
				throw new APIError("FORBIDDEN", {
					message:
						ORGANIZATION_ERROR_CODES.USER_IS_NOT_A_MEMBER_OF_THE_ORGANIZATION,
				});
			}
			if (!organization) {
				throw new APIError("BAD_REQUEST", {
					message: ORGANIZATION_ERROR_CODES.ORGANIZATION_NOT_FOUND,
				});
			}
			const updatedSession = await adapter.setActiveOrganization(
				session.session.token,
				organization.id,
			);
			await setSessionCookie(ctx, {
				session: updatedSession,
				user: session.user,
			});
			type OrganizationReturn = O["teams"] extends { enabled: true }
				? {
						members: InferMember<O>[];
						invitations: InferInvitation<O>[];
						teams: Team[];
					} & Organization
				: {
						members: InferMember<O>[];
						invitations: InferInvitation<O>[];
					} & Organization;
			return ctx.json(organization as unknown as OrganizationReturn);
		},
	);
};

export const listOrganizations = createAuthEndpoint(
	"/organization/list",
	{
		method: "GET",
		use: [orgMiddleware, orgSessionMiddleware],
		metadata: {
			openapi: {
				description: "List all organizations",
				responses: {
					"200": {
						description: "Success",
						content: {
							"application/json": {
								schema: {
									type: "array",
									items: {
										$ref: "#/components/schemas/Organization",
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
		const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
		const organizations = await adapter.listOrganizations(
			ctx.context.session.user.id,
		);
		return ctx.json(organizations);
	},
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/organization/routes/crud-team.ts
```typescript
import { z } from "zod";
import { createAuthEndpoint } from "../../../api/call";
import { getOrgAdapter } from "../adapter";
import { orgMiddleware, orgSessionMiddleware } from "../call";
import { APIError } from "better-call";
import { generateId } from "../../../utils";
import { getSessionFromCtx } from "../../../api";
import { ORGANIZATION_ERROR_CODES } from "../error-codes";
import type { OrganizationOptions } from "../organization";
import { teamSchema } from "../schema";
import { hasPermission } from "../has-permission";

export const createTeam = <O extends OrganizationOptions | undefined>(
	options?: O,
) =>
	createAuthEndpoint(
		"/organization/create-team",
		{
			method: "POST",
			body: z.object({
				organizationId: z.string().optional(),
				name: z.string(),
			}),
			use: [orgMiddleware],
		},
		async (ctx) => {
			const session = await getSessionFromCtx(ctx);
			const organizationId =
				ctx.body.organizationId || session?.session.activeOrganizationId;
			if (!session && (ctx.request || ctx.headers)) {
				throw new APIError("UNAUTHORIZED");
			}

			if (!organizationId) {
				throw new APIError("BAD_REQUEST", {
					message: ORGANIZATION_ERROR_CODES.NO_ACTIVE_ORGANIZATION,
				});
			}
			const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
			if (session) {
				const member = await adapter.findMemberByOrgId({
					userId: session.user.id,
					organizationId,
				});
				if (!member) {
					throw new APIError("FORBIDDEN", {
						message:
							ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_INVITE_USERS_TO_THIS_ORGANIZATION,
					});
				}
				const canCreate = hasPermission({
					role: member.role,
					options: ctx.context.orgOptions,
					permission: {
						team: ["create"],
					},
				});
				if (!canCreate) {
					throw new APIError("FORBIDDEN", {
						message:
							ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_CREATE_TEAMS_IN_THIS_ORGANIZATION,
					});
				}
			}

			const existingTeams = await adapter.listTeams(organizationId);
			const maximum =
				typeof ctx.context.orgOptions.teams?.maximumTeams === "function"
					? await ctx.context.orgOptions.teams?.maximumTeams(
							{
								organizationId,
								session,
							},
							ctx.request,
						)
					: ctx.context.orgOptions.teams?.maximumTeams;

			const maxTeamsReached = maximum ? existingTeams.length >= maximum : false;
			if (maxTeamsReached) {
				throw new APIError("BAD_REQUEST", {
					message:
						ORGANIZATION_ERROR_CODES.YOU_HAVE_REACHED_THE_MAXIMUM_NUMBER_OF_TEAMS,
				});
			}
			const createdTeam = await adapter.createTeam({
				id: generateId(),
				name: ctx.body.name,
				organizationId,
				createdAt: new Date(),
				updatedAt: new Date(),
			});
			return ctx.json(createdTeam);
		},
	);

export const removeTeam = createAuthEndpoint(
	"/organization/remove-team",
	{
		method: "POST",
		body: z.object({
			teamId: z.string(),
			organizationId: z.string().optional(),
		}),
		use: [orgMiddleware],
	},
	async (ctx) => {
		const session = await getSessionFromCtx(ctx);
		const organizationId =
			ctx.body.organizationId || session?.session.activeOrganizationId;
		if (!organizationId) {
			return ctx.json(null, {
				status: 400,
				body: {
					message: ORGANIZATION_ERROR_CODES.NO_ACTIVE_ORGANIZATION,
				},
			});
		}
		if (!session && (ctx.request || ctx.headers)) {
			throw new APIError("UNAUTHORIZED");
		}
		const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
		if (session) {
			const member = await adapter.findMemberByOrgId({
				userId: session.user.id,
				organizationId,
			});

			if (!member || member.teamId === ctx.body.teamId) {
				throw new APIError("FORBIDDEN", {
					message:
						ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_INVITE_USERS_TO_THIS_ORGANIZATION,
				});
			}

			const canRemove = hasPermission({
				role: member.role,
				options: ctx.context.orgOptions,
				permission: {
					team: ["delete"],
				},
			});
			if (!canRemove) {
				throw new APIError("FORBIDDEN", {
					message:
						ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_DELETE_TEAMS_IN_THIS_ORGANIZATION,
				});
			}
		}
		const team = await adapter.findTeamById({
			teamId: ctx.body.teamId,
			organizationId,
		});
		if (!team || team.organizationId !== organizationId) {
			throw new APIError("BAD_REQUEST", {
				message: ORGANIZATION_ERROR_CODES.TEAM_NOT_FOUND,
			});
		}

		if (!ctx.context.orgOptions.teams?.allowRemovingAllTeams) {
			const teams = await adapter.listTeams(organizationId);
			if (teams.length <= 1) {
				throw new APIError("BAD_REQUEST", {
					message: ORGANIZATION_ERROR_CODES.UNABLE_TO_REMOVE_LAST_TEAM,
				});
			}
		}

		await adapter.deleteTeam(team.id);
		return ctx.json({ message: "Team removed successfully." });
	},
);

export const updateTeam = createAuthEndpoint(
	"/organization/update-team",
	{
		method: "POST",
		body: z.object({
			teamId: z.string(),
			data: teamSchema.partial(),
		}),
		use: [orgMiddleware, orgSessionMiddleware],
	},
	async (ctx) => {
		const session = ctx.context.session;
		const organizationId =
			ctx.body.data.organizationId || session.session.activeOrganizationId;
		if (!organizationId) {
			return ctx.json(null, {
				status: 400,
				body: {
					message: ORGANIZATION_ERROR_CODES.NO_ACTIVE_ORGANIZATION,
				},
			});
		}
		const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
		const member = await adapter.findMemberByOrgId({
			userId: session.user.id,
			organizationId,
		});

		if (!member) {
			throw new APIError("FORBIDDEN", {
				message:
					ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_UPDATE_THIS_TEAM,
			});
		}

		const canUpdate = hasPermission({
			role: member.role,
			options: ctx.context.orgOptions,
			permission: {
				team: ["update"],
			},
		});
		if (!canUpdate) {
			throw new APIError("FORBIDDEN", {
				message:
					ORGANIZATION_ERROR_CODES.YOU_ARE_NOT_ALLOWED_TO_UPDATE_THIS_TEAM,
			});
		}

		const team = await adapter.findTeamById({
			teamId: ctx.body.teamId,
			organizationId,
		});

		if (!team || team.organizationId !== organizationId) {
			throw new APIError("BAD_REQUEST", {
				message: ORGANIZATION_ERROR_CODES.TEAM_NOT_FOUND,
			});
		}

		const updatedTeam = await adapter.updateTeam(team.id, {
			name: ctx.body.data.name,
		});

		return ctx.json(updatedTeam);
	},
);

export const listOrganizationTeams = createAuthEndpoint(
	"/organization/list-teams",
	{
		method: "GET",
		query: z.optional(
			z.object({
				organizationId: z.string().optional(),
			}),
		),
		use: [orgMiddleware, orgSessionMiddleware],
	},
	async (ctx) => {
		const session = ctx.context.session;
		const organizationId =
			session.session.activeOrganizationId || ctx.query?.organizationId;

		if (!organizationId) {
			return ctx.json(null, {
				status: 400,
				body: {
					message: ORGANIZATION_ERROR_CODES.NO_ACTIVE_ORGANIZATION,
				},
			});
		}
		const adapter = getOrgAdapter(ctx.context, ctx.context.orgOptions);
		const member = await adapter.findMemberByOrgId({
			userId: session?.user.id,
			organizationId: organizationId || "",
		});

		if (!member) {
			throw new APIError("FORBIDDEN");
		}

		const teams = await adapter.listTeams(organizationId);

		return ctx.json(teams);
	},
);

```
