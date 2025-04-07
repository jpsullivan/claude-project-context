/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/access/access.test.ts
```typescript
import { describe, expect, it } from "vitest";
import { createAccessControl } from "./access";

describe("access", () => {
	const ac = createAccessControl({
		project: ["create", "update", "delete", "delete-many"],
		ui: ["view", "edit", "comment", "hide"],
	});

	const role1 = ac.newRole({
		project: ["create", "update", "delete"],
		ui: ["view", "edit", "comment"],
	});

	it("should validate permissions", async () => {
		const response = role1.authorize({
			project: ["create"],
		});
		expect(response.success).toBe(true);

		const failedResponse = role1.authorize({
			project: ["delete-many"],
		});
		expect(failedResponse.success).toBe(false);
	});

	it("should validate multiple resource permissions", async () => {
		const response = role1.authorize({
			project: ["create"],
			ui: ["view"],
		});
		expect(response.success).toBe(true);

		const failedResponse = role1.authorize({
			project: ["delete-many"],
			ui: ["view"],
		});
		expect(failedResponse.success).toBe(false);
	});

	it("should validate multiple resource multiple permissions", async () => {
		const response = role1.authorize({
			project: ["create", "delete"],
			ui: ["view", "edit"],
		});
		expect(response.success).toBe(true);
		const failedResponse = role1.authorize({
			project: ["create", "delete-many"],
			ui: ["view", "edit"],
		});
		expect(failedResponse.success).toBe(false);
	});

	it("should validate using or connector", () => {
		const response = role1.authorize(
			{
				project: ["create", "delete-many"],
				ui: ["view", "edit"],
			},
			"OR",
		);
		expect(response.success).toBe(true);
	});

	it("should validate using or connector for a specific resource", () => {
		const response = role1.authorize({
			project: {
				connector: "OR",
				actions: ["create", "delete-many"],
			},
			ui: ["view", "edit"],
		});
		expect(response.success).toBe(true);

		const failedResponse = role1.authorize({
			project: {
				connector: "OR",
				actions: ["create", "delete-many"],
			},
			ui: ["view", "edit", "hide"],
		});
		expect(failedResponse.success).toBe(false);
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/access/access.ts
```typescript
import { BetterAuthError } from "../../error";
import type { Statements, Subset } from "./types";

export type AuthortizeResponse =
	| { success: false; error: string }
	| { success: true; error?: never };

export function role<TStatements extends Statements>(statements: TStatements) {
	return {
		authorize<K extends keyof TStatements>(
			request: {
				[key in K]?:
					| TStatements[key]
					| {
							actions: TStatements[key];
							connector: "OR" | "AND";
					  };
			},
			connector: "OR" | "AND" = "AND",
		): AuthortizeResponse {
			let success = false;
			for (const [requestedResource, requestedActions] of Object.entries(
				request,
			)) {
				const allowedActions = statements[requestedResource];
				if (!allowedActions) {
					return {
						success: false,
						error: `You are not allowed to access resource: ${requestedResource}`,
					};
				}
				if (Array.isArray(requestedActions)) {
					success = (requestedActions as string[]).every((requestedAction) =>
						allowedActions.includes(requestedAction),
					);
				} else {
					if (typeof requestedActions === "object") {
						const actions = requestedActions as {
							actions: string[];
							connector: "OR" | "AND";
						};
						if (actions.connector === "OR") {
							success = actions.actions.some((requestedAction) =>
								allowedActions.includes(requestedAction),
							);
						} else {
							success = actions.actions.every((requestedAction) =>
								allowedActions.includes(requestedAction),
							);
						}
					} else {
						throw new BetterAuthError("Invalid access control request");
					}
				}
				if (success && connector === "OR") {
					return { success };
				}
				if (!success && connector === "AND") {
					return {
						success: false,
						error: `unauthorized to access resource "${requestedResource}"`,
					};
				}
			}
			if (success) {
				return {
					success,
				};
			}
			return {
				success: false,
				error: "Not authorized",
			};
		},
		statements,
	};
}

export function createAccessControl<const TStatements extends Statements>(
	s: TStatements,
) {
	return {
		newRole<K extends keyof TStatements>(statements: Subset<K, TStatements>) {
			return role<Subset<K, TStatements>>(statements);
		},
		statements: s,
	};
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/access/index.ts
```typescript
export * from "./access";
export * from "./types";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/access/types.ts
```typescript
import type { LiteralString } from "../../types/helper";
import type { AuthortizeResponse, createAccessControl } from "./access";

export type SubArray<T extends unknown[] | readonly unknown[] | any[]> =
	T[number][];

export type Subset<
	K extends keyof R,
	R extends Record<
		string | LiteralString,
		readonly string[] | readonly LiteralString[]
	>,
> = {
	[P in K]: SubArray<R[P]>;
};

export type Statements = {
	readonly [resource: string]: readonly LiteralString[];
};

export type AccessControl<TStatements extends Statements = Statements> =
	ReturnType<typeof createAccessControl<TStatements>>;

export type Role<TStatements extends Statements = Record<string, any>> = {
	authorize: (request: any, connector?: "OR" | "AND") => AuthortizeResponse;
	statements: TStatements;
};

```
