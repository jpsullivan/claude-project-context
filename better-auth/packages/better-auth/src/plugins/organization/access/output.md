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
