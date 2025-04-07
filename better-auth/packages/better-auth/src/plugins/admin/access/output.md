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
