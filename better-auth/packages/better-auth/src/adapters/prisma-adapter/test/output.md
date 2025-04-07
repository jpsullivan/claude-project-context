/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/prisma-adapter/test/adapter.prisma.test.ts
```typescript
import { beforeAll, describe } from "vitest";
import { PrismaClient } from "@prisma/client";
import { prismaAdapter } from "..";
import { runAdapterTest } from "../../test";

const db = new PrismaClient();
describe("adapter test", async () => {
	beforeAll(async () => {
		await clearDb();
	});
	const adapter = prismaAdapter(db, {
		provider: "sqlite",
	});

	await runAdapterTest({
		getAdapter: async (customOptions = {}) => {
			return adapter({
				user: {
					fields: {
						email: "email_address",
					},
					additionalFields: {
						test: {
							type: "string",
							defaultValue: "test",
						},
					},
				},
				session: {
					modelName: "sessions",
				},
				...customOptions,
			});
		},
	});
});

async function clearDb() {
	await db.user.deleteMany();
	await db.sessions.deleteMany();
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/prisma-adapter/test/client.ts
```typescript
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();
export default prisma;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/prisma-adapter/test/schema.prisma
```
generator client {
    provider        = "prisma-client-js"
    previewFeatures = ["strictUndefinedChecks"]
}

datasource db {
    provider = "sqlite"
    url      = "file:.db/dev.db"
}

model User {
    id            String   @id @default(cuid())
    email_address String   @unique
    test          String
    emailVerified Boolean  @default(false)
    name          String
    createdAt     DateTime @default(now())
    updatedAt     DateTime @default(now()) @updatedAt
}

model Sessions {
    id        String   @id @default(cuid())
    userId    String
    token     String   @unique
    expiresAt DateTime
    createdAt DateTime @default(now())
    updatedAt DateTime @default(now()) @updatedAt
}

```
