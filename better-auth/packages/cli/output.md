/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/build.config.ts
```typescript
import { defineBuildConfig } from "unbuild";

export default defineBuildConfig({
	outDir: "dist",
	externals: ["better-auth", "better-call"],
	entries: ["./src/index.ts"],
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/package.json
```json
{
  "name": "@better-auth/cli",
  "version": "1.2.6-beta.6",
  "description": "The CLI for Better Auth",
  "module": "dist/index.mjs",
  "repository": {
    "type": "git",
    "url": "https://github.com/better-auth/better-auth",
    "directory": "packages/cli"
  },
  "main": "./dist/index.mjs",
  "scripts": {
    "build": "unbuild",
    "stub": "unbuild --stub",
    "start": "node ./dist/index.mjs",
    "test": "vitest"
  },
  "publishConfig": {
    "executableFiles": [
      "./dist/index.mjs"
    ]
  },
  "exports": "./dist/index.mjs",
  "bin": "./dist/index.mjs",
  "devDependencies": {
    "@types/diff": "^7.0.1",
    "@types/fs-extra": "^11.0.4",
    "typescript": "catalog:",
    "unbuild": "catalog:",
    "vitest": "^1.6.0"
  },
  "dependencies": {
    "@babel/preset-react": "^7.26.3",
    "@babel/preset-typescript": "^7.26.0",
    "@clack/prompts": "^0.10.0",
    "@mrleebo/prisma-ast": "^0.12.0",
    "@prisma/client": "^5.22.0",
    "@types/better-sqlite3": "^7.6.12",
    "@types/prompts": "^2.4.9",
    "better-auth": "workspace:*",
    "better-sqlite3": "^11.6.0",
    "c12": "^2.0.1",
    "chalk": "^5.3.0",
    "commander": "^12.1.0",
    "dotenv": "^16.4.7",
    "drizzle-orm": "^0.33.0",
    "fs-extra": "^11.3.0",
    "get-tsconfig": "^4.8.1",
    "prettier": "^3.4.2",
    "prisma": "^5.22.0",
    "prompts": "^2.4.2",
    "semver": "^7.7.1",
    "tinyexec": "^0.3.1",
    "yocto-spinner": "^0.1.1",
    "zod": "^3.23.8"
  },
  "files": [
    "dist"
  ]
}
```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/test/generate.test.ts
```typescript
import { describe, expect, it } from "vitest";
import { prismaAdapter } from "better-auth/adapters/prisma";
import { generatePrismaSchema } from "../src/generators/prisma";
import { twoFactor, username } from "better-auth/plugins";
import { generateDrizzleSchema } from "../src/generators/drizzle";
import { drizzleAdapter } from "better-auth/adapters/drizzle";
import { generateMigrations } from "../src/generators/kysely";
import Database from "better-sqlite3";
import type { BetterAuthOptions } from "better-auth";

describe("generate", async () => {
	it("should generate prisma schema", async () => {
		const schema = await generatePrismaSchema({
			file: "test.prisma",
			adapter: prismaAdapter(
				{},
				{
					provider: "postgresql",
				},
			)({} as BetterAuthOptions),
			options: {
				database: prismaAdapter(
					{},
					{
						provider: "postgresql",
					},
				),
				plugins: [twoFactor(), username()],
			},
		});
		expect(schema.code).toMatchFileSnapshot("./__snapshots__/schema.prisma");
	});

	it("should generate prisma schema for mongodb", async () => {
		const schema = await generatePrismaSchema({
			file: "test.prisma",
			adapter: prismaAdapter(
				{},
				{
					provider: "mongodb",
				},
			)({} as BetterAuthOptions),
			options: {
				database: prismaAdapter(
					{},
					{
						provider: "mongodb",
					},
				),
				plugins: [twoFactor(), username()],
			},
		});
		expect(schema.code).toMatchFileSnapshot(
			"./__snapshots__/schema-mongodb.prisma",
		);
	});

	it("should generate prisma schema for mysql", async () => {
		const schema = await generatePrismaSchema({
			file: "test.prisma",
			adapter: prismaAdapter(
				{},
				{
					provider: "mysql",
				},
			)({} as BetterAuthOptions),
			options: {
				database: prismaAdapter(
					{},
					{
						provider: "mongodb",
					},
				),
				plugins: [twoFactor(), username()],
			},
		});
		expect(schema.code).toMatchFileSnapshot(
			"./__snapshots__/schema-mysql.prisma",
		);
	});

	it("should generate drizzle schema", async () => {
		const schema = await generateDrizzleSchema({
			file: "test.drizzle",
			adapter: drizzleAdapter(
				{},
				{
					provider: "pg",
					schema: {},
				},
			)({} as BetterAuthOptions),
			options: {
				database: drizzleAdapter(
					{},
					{
						provider: "pg",
						schema: {},
					},
				),
				plugins: [twoFactor(), username()],
			},
		});
		expect(schema.code).toMatchFileSnapshot("./__snapshots__/auth-schema.txt");
	});

	it("should generate kysely schema", async () => {
		const schema = await generateMigrations({
			file: "test.sql",
			options: {
				database: new Database(":memory:"),
			},
			adapter: {} as any,
		});
		expect(schema.code).toMatchFileSnapshot("./__snapshots__/migrations.sql");
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/test/get-config.test.ts
```typescript
import { afterEach, beforeEach, describe, expect, it } from "vitest";

import { test } from "vitest";
import fs from "node:fs/promises";
import path from "node:path";
import { getConfig } from "../src/utils/get-config";

interface TmpDirFixture {
	tmpdir: string;
}

async function createTempDir() {
	const tmpdir = path.join(process.cwd(), "test", "getConfig_test-");
	return await fs.mkdtemp(tmpdir);
}

export const tmpdirTest = test.extend<TmpDirFixture>({
	tmpdir: async ({}, use) => {
		const directory = await createTempDir();

		await use(directory);

		await fs.rm(directory, { recursive: true });
	},
});

let tmpDir = ".";

describe("getConfig", async () => {
	beforeEach(async () => {
		const tmp = path.join(process.cwd(), "getConfig_test-");
		tmpDir = await fs.mkdtemp(tmp);
	});

	afterEach(async () => {
		await fs.rm(tmpDir, { recursive: true });
	});

	it("should resolve resolver type alias", async () => {
		const authPath = path.join(tmpDir, "server", "auth");
		const dbPath = path.join(tmpDir, "server", "db");
		await fs.mkdir(authPath, { recursive: true });
		await fs.mkdir(dbPath, { recursive: true });

		//create dummy tsconfig.json
		await fs.writeFile(
			path.join(tmpDir, "tsconfig.json"),
			`{
              "compilerOptions": {
                /* Path Aliases */
                "baseUrl": ".",
                "paths": {
                  "@server/*": ["./server/*"]
                }
              }
					}`,
		);

		//create dummy auth.ts
		await fs.writeFile(
			path.join(authPath, "auth.ts"),
			`import {betterAuth} from "better-auth";
			 import {prismaAdapter} from "better-auth/adapters/prisma";			
			 import {db} from "@server/db/db";

			 export const auth = betterAuth({
					database: prismaAdapter(db, {
							provider: 'sqlite'
					}),
					emailAndPassword: {
						enabled: true,
					}
			 })`,
		);

		//create dummy db.ts
		await fs.writeFile(
			path.join(dbPath, "db.ts"),
			`class PrismaClient {
				constructor() {}
			}
			
			export const db = new PrismaClient()`,
		);

		const config = await getConfig({
			cwd: tmpDir,
			configPath: "server/auth/auth.ts",
		});

		expect(config).not.toBe(null);
	});

	it("should resolve direct alias", async () => {
		const authPath = path.join(tmpDir, "server", "auth");
		const dbPath = path.join(tmpDir, "server", "db");
		await fs.mkdir(authPath, { recursive: true });
		await fs.mkdir(dbPath, { recursive: true });

		//create dummy tsconfig.json
		await fs.writeFile(
			path.join(tmpDir, "tsconfig.json"),
			`{
              "compilerOptions": {
                /* Path Aliases */
                "baseUrl": ".",
                "paths": {
                  "prismaDbClient": ["./server/db/db"]
                }
              }
					}`,
		);

		//create dummy auth.ts
		await fs.writeFile(
			path.join(authPath, "auth.ts"),
			`import {betterAuth} from "better-auth";
			 import {prismaAdapter} from "better-auth/adapters/prisma";			
			 import {db} from "prismaDbClient";

			 export const auth = betterAuth({
					database: prismaAdapter(db, {
							provider: 'sqlite'
					}),
					emailAndPassword: {
						enabled: true,
					}
			 })`,
		);

		//create dummy db.ts
		await fs.writeFile(
			path.join(dbPath, "db.ts"),
			`class PrismaClient {
				constructor() {}
			}
			
			export const db = new PrismaClient()`,
		);

		const config = await getConfig({
			cwd: tmpDir,
			configPath: "server/auth/auth.ts",
		});

		expect(config).not.toBe(null);
	});

	it("should resolve resolver type alias with relative path", async () => {
		const authPath = path.join(tmpDir, "test", "server", "auth");
		const dbPath = path.join(tmpDir, "test", "server", "db");
		await fs.mkdir(authPath, { recursive: true });
		await fs.mkdir(dbPath, { recursive: true });

		//create dummy tsconfig.json
		await fs.writeFile(
			path.join(tmpDir, "tsconfig.json"),
			`{
              "compilerOptions": {
                /* Path Aliases */
                "baseUrl": "./test",
                "paths": {
                  "@server/*": ["./server/*"]
                }
              }
					}`,
		);

		//create dummy auth.ts
		await fs.writeFile(
			path.join(authPath, "auth.ts"),
			`import {betterAuth} from "better-auth";
			 import {prismaAdapter} from "better-auth/adapters/prisma";			
			 import {db} from "@server/db/db";

			 export const auth = betterAuth({
					database: prismaAdapter(db, {
							provider: 'sqlite'
					}),
					emailAndPassword: {
						enabled: true,
					}
			 })`,
		);

		//create dummy db.ts
		await fs.writeFile(
			path.join(dbPath, "db.ts"),
			`class PrismaClient {
				constructor() {}
			}
			
			export const db = new PrismaClient()`,
		);

		const config = await getConfig({
			cwd: tmpDir,
			configPath: "test/server/auth/auth.ts",
		});

		expect(config).not.toBe(null);
	});

	it("should resolve direct alias with relative path", async () => {
		const authPath = path.join(tmpDir, "test", "server", "auth");
		const dbPath = path.join(tmpDir, "test", "server", "db");
		await fs.mkdir(authPath, { recursive: true });
		await fs.mkdir(dbPath, { recursive: true });

		//create dummy tsconfig.json
		await fs.writeFile(
			path.join(tmpDir, "tsconfig.json"),
			`{
              "compilerOptions": {
                /* Path Aliases */
                "baseUrl": "./test",
                "paths": {
                  "prismaDbClient": ["./server/db/db"]
                }
              }
					}`,
		);

		//create dummy auth.ts
		await fs.writeFile(
			path.join(authPath, "auth.ts"),
			`import {betterAuth} from "better-auth";
			 import {prismaAdapter} from "better-auth/adapters/prisma";			
			 import {db} from "prismaDbClient";

			 export const auth = betterAuth({
					database: prismaAdapter(db, {
							provider: 'sqlite'
					}),
					emailAndPassword: {
						enabled: true,
					}
			 })`,
		);

		//create dummy db.ts
		await fs.writeFile(
			path.join(dbPath, "db.ts"),
			`class PrismaClient {
				constructor() {}
			}
			
			export const db = new PrismaClient()`,
		);

		const config = await getConfig({
			cwd: tmpDir,
			configPath: "test/server/auth/auth.ts",
		});

		expect(config).not.toBe(null);
	});

	it("should resolve with relative import", async () => {
		const authPath = path.join(tmpDir, "test", "server", "auth");
		const dbPath = path.join(tmpDir, "test", "server", "db");
		await fs.mkdir(authPath, { recursive: true });
		await fs.mkdir(dbPath, { recursive: true });

		//create dummy tsconfig.json
		await fs.writeFile(
			path.join(tmpDir, "tsconfig.json"),
			`{
              "compilerOptions": {
                /* Path Aliases */
                "baseUrl": "./test",
                "paths": {
                  "prismaDbClient": ["./server/db/db"]
                }
              }
					}`,
		);

		//create dummy auth.ts
		await fs.writeFile(
			path.join(authPath, "auth.ts"),
			`import {betterAuth} from "better-auth";
			 import {prismaAdapter} from "better-auth/adapters/prisma";			
			 import {db} from "../db/db";

			 export const auth = betterAuth({
					database: prismaAdapter(db, {
							provider: 'sqlite'
					}),
					emailAndPassword: {
						enabled: true,
					}
			 })`,
		);

		//create dummy db.ts
		await fs.writeFile(
			path.join(dbPath, "db.ts"),
			`class PrismaClient {
				constructor() {}
			}
			
			export const db = new PrismaClient()`,
		);

		const config = await getConfig({
			cwd: tmpDir,
			configPath: "test/server/auth/auth.ts",
		});

		expect(config).not.toBe(null);
	});

	it("should error with invalid alias", async () => {
		const authPath = path.join(tmpDir, "server", "auth");
		const dbPath = path.join(tmpDir, "server", "db");
		await fs.mkdir(authPath, { recursive: true });
		await fs.mkdir(dbPath, { recursive: true });

		//create dummy tsconfig.json
		await fs.writeFile(
			path.join(tmpDir, "tsconfig.json"),
			`{
              "compilerOptions": {
                /* Path Aliases */
                "baseUrl": ".",
                "paths": {
                  "@server/*": ["./PathIsInvalid/*"]
                }
              }
					}`,
		);

		//create dummy auth.ts
		await fs.writeFile(
			path.join(authPath, "auth.ts"),
			`import {betterAuth} from "better-auth";
			 import {prismaAdapter} from "better-auth/adapters/prisma";			
			 import {db} from "@server/db/db";

			 export const auth = betterAuth({
					database: prismaAdapter(db, {
							provider: 'sqlite'
					}),
					emailAndPassword: {
						enabled: true,
					}
			 })`,
		);

		//create dummy db.ts
		await fs.writeFile(
			path.join(dbPath, "db.ts"),
			`class PrismaClient {
				constructor() {}
			}
			
			export const db = new PrismaClient()`,
		);

		await expect(() =>
			getConfig({ cwd: tmpDir, configPath: "server/auth/auth.ts" }),
		).rejects.toThrowError();
	});

	it("should resolve js config", async () => {
		const authPath = path.join(tmpDir, "server", "auth");
		const dbPath = path.join(tmpDir, "server", "db");
		await fs.mkdir(authPath, { recursive: true });
		await fs.mkdir(dbPath, { recursive: true });

		//create dummy auth.ts
		await fs.writeFile(
			path.join(authPath, "auth.js"),
			`import  { betterAuth } from "better-auth";

			 export const auth = betterAuth({
					emailAndPassword: {
						enabled: true,
					}
			 })`,
		);
		const config = await getConfig({
			cwd: tmpDir,
			configPath: "server/auth/auth.js",
		});
		expect(config).toMatchObject({
			emailAndPassword: { enabled: true },
		});
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/test/migrate.test.ts
```typescript
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { migrateAction } from "../src/commands/migrate";
import * as config from "../src/utils/get-config";
import { betterAuth, type BetterAuthPlugin } from "better-auth";
import Database from "better-sqlite3";

describe("migrate base auth instance", () => {
	const db = new Database(":memory:");

	const auth = betterAuth({
		baseURL: "http://localhost:3000",
		database: db,
		emailAndPassword: {
			enabled: true,
		},
	});

	beforeEach(() => {
		vi.spyOn(process, "exit").mockImplementation((code) => {
			return code as never;
		});
		vi.spyOn(config, "getConfig").mockImplementation(async () => auth.options);
	});

	afterEach(async () => {
		vi.restoreAllMocks();
	});

	it("should migrate the database and sign-up a user", async () => {
		await migrateAction({
			cwd: process.cwd(),
			config: "test/auth.ts",
			y: true,
		});
		const signUpRes = await auth.api.signUpEmail({
			body: {
				name: "test",
				email: "test@email.com",
				password: "password",
			},
		});
		expect(signUpRes.token).toBeDefined();
	});
});

describe("migrate auth instance with plugins", () => {
	const db = new Database(":memory:");
	const testPlugin = {
		id: "plugin",
		schema: {
			plugin: {
				fields: {
					test: {
						type: "string",
						fieldName: "test",
					},
				},
			},
		},
	} satisfies BetterAuthPlugin;

	const auth = betterAuth({
		baseURL: "http://localhost:3000",
		database: db,
		emailAndPassword: {
			enabled: true,
		},
		plugins: [testPlugin],
	});

	beforeEach(() => {
		vi.spyOn(process, "exit").mockImplementation((code) => {
			return code as never;
		});
		vi.spyOn(config, "getConfig").mockImplementation(async () => auth.options);
	});

	afterEach(async () => {
		vi.restoreAllMocks();
	});

	it("should migrate the database and sign-up a user", async () => {
		await migrateAction({
			cwd: process.cwd(),
			config: "test/auth.ts",
			y: true,
		});
		const res = db
			.prepare("INSERT INTO plugin (id, test) VALUES (?, ?)")
			.run("1", "test");
		expect(res.changes).toBe(1);
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/test/__snapshots__/auth-schema.txt
```
import { pgTable, text, integer, timestamp, boolean } from "drizzle-orm/pg-core";
			
export const user = pgTable("user", {
					id: text("id").primaryKey(),
					name: text('name').notNull(),
 email: text('email').notNull().unique(),
 emailVerified: boolean('email_verified').notNull(),
 image: text('image'),
 createdAt: timestamp('created_at').notNull(),
 updatedAt: timestamp('updated_at').notNull(),
 twoFactorEnabled: boolean('two_factor_enabled'),
 username: text('username').unique(),
 displayUsername: text('display_username')
				});

export const session = pgTable("session", {
					id: text("id").primaryKey(),
					expiresAt: timestamp('expires_at').notNull(),
 token: text('token').notNull().unique(),
 createdAt: timestamp('created_at').notNull(),
 updatedAt: timestamp('updated_at').notNull(),
 ipAddress: text('ip_address'),
 userAgent: text('user_agent'),
 userId: text('user_id').notNull().references(()=> user.id, { onDelete: 'cascade' })
				});

export const account = pgTable("account", {
					id: text("id").primaryKey(),
					accountId: text('account_id').notNull(),
 providerId: text('provider_id').notNull(),
 userId: text('user_id').notNull().references(()=> user.id, { onDelete: 'cascade' }),
 accessToken: text('access_token'),
 refreshToken: text('refresh_token'),
 idToken: text('id_token'),
 accessTokenExpiresAt: timestamp('access_token_expires_at'),
 refreshTokenExpiresAt: timestamp('refresh_token_expires_at'),
 scope: text('scope'),
 password: text('password'),
 createdAt: timestamp('created_at').notNull(),
 updatedAt: timestamp('updated_at').notNull()
				});

export const verification = pgTable("verification", {
					id: text("id").primaryKey(),
					identifier: text('identifier').notNull(),
 value: text('value').notNull(),
 expiresAt: timestamp('expires_at').notNull(),
 createdAt: timestamp('created_at'),
 updatedAt: timestamp('updated_at')
				});

export const twoFactor = pgTable("two_factor", {
					id: text("id").primaryKey(),
					secret: text('secret').notNull(),
 backupCodes: text('backup_codes').notNull(),
 userId: text('user_id').notNull().references(()=> user.id, { onDelete: 'cascade' })
				});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/test/__snapshots__/migrations.sql
```
create table "user" ("id" text not null primary key, "name" text not null, "email" text not null unique, "emailVerified" integer not null, "image" text, "createdAt" date not null, "updatedAt" date not null);

create table "session" ("id" text not null primary key, "expiresAt" date not null, "token" text not null unique, "createdAt" date not null, "updatedAt" date not null, "ipAddress" text, "userAgent" text, "userId" text not null references "user" ("id"));

create table "account" ("id" text not null primary key, "accountId" text not null, "providerId" text not null, "userId" text not null references "user" ("id"), "accessToken" text, "refreshToken" text, "idToken" text, "accessTokenExpiresAt" date, "refreshTokenExpiresAt" date, "scope" text, "password" text, "createdAt" date not null, "updatedAt" date not null);

create table "verification" ("id" text not null primary key, "identifier" text not null, "value" text not null, "expiresAt" date not null, "createdAt" date, "updatedAt" date);
```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/test/__snapshots__/schema-mongodb.prisma
```

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "mongodb"
  url      = env("DATABASE_URL")
}

model User {
  id               String      @id @map("_id")
  name             String
  email            String
  emailVerified    Boolean
  image            String?
  createdAt        DateTime
  updatedAt        DateTime
  twoFactorEnabled Boolean?
  username         String?
  displayUsername  String?
  sessions         Session[]
  accounts         Account[]
  twofactors       TwoFactor[]

  @@unique([email])
  @@unique([username])
  @@map("user")
}

model Session {
  id        String   @id @map("_id")
  expiresAt DateTime
  token     String
  createdAt DateTime
  updatedAt DateTime
  ipAddress String?
  userAgent String?
  userId    String
  user      User     @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@unique([token])
  @@map("session")
}

model Account {
  id                    String    @id @map("_id")
  accountId             String
  providerId            String
  userId                String
  user                  User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  accessToken           String?
  refreshToken          String?
  idToken               String?
  accessTokenExpiresAt  DateTime?
  refreshTokenExpiresAt DateTime?
  scope                 String?
  password              String?
  createdAt             DateTime
  updatedAt             DateTime

  @@map("account")
}

model Verification {
  id         String    @id @map("_id")
  identifier String
  value      String
  expiresAt  DateTime
  createdAt  DateTime?
  updatedAt  DateTime?

  @@map("verification")
}

model TwoFactor {
  id          String @id @map("_id")
  secret      String
  backupCodes String
  userId      String
  user        User   @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@map("twoFactor")
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/test/__snapshots__/schema-mysql.prisma
```

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "mysql"
  url      = env("DATABASE_URL")
}

model User {
  id               String      @id
  name             String      @db.Text
  email            String
  emailVerified    Boolean
  image            String?     @db.Text
  createdAt        DateTime
  updatedAt        DateTime
  twoFactorEnabled Boolean?
  username         String?
  displayUsername  String?     @db.Text
  sessions         Session[]
  accounts         Account[]
  twofactors       TwoFactor[]

  @@unique([email])
  @@unique([username])
  @@map("user")
}

model Session {
  id        String   @id
  expiresAt DateTime
  token     String
  createdAt DateTime
  updatedAt DateTime
  ipAddress String?  @db.Text
  userAgent String?  @db.Text
  userId    String
  user      User     @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@unique([token])
  @@map("session")
}

model Account {
  id                    String    @id
  accountId             String    @db.Text
  providerId            String    @db.Text
  userId                String
  user                  User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  accessToken           String?   @db.Text
  refreshToken          String?   @db.Text
  idToken               String?   @db.Text
  accessTokenExpiresAt  DateTime?
  refreshTokenExpiresAt DateTime?
  scope                 String?   @db.Text
  password              String?   @db.Text
  createdAt             DateTime
  updatedAt             DateTime

  @@map("account")
}

model Verification {
  id         String    @id
  identifier String    @db.Text
  value      String    @db.Text
  expiresAt  DateTime
  createdAt  DateTime?
  updatedAt  DateTime?

  @@map("verification")
}

model TwoFactor {
  id          String @id
  secret      String @db.Text
  backupCodes String @db.Text
  userId      String
  user        User   @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@map("twoFactor")
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/test/__snapshots__/schema.prisma
```

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id               String      @id
  name             String
  email            String
  emailVerified    Boolean
  image            String?
  createdAt        DateTime
  updatedAt        DateTime
  twoFactorEnabled Boolean?
  username         String?
  displayUsername  String?
  sessions         Session[]
  accounts         Account[]
  twofactors       TwoFactor[]

  @@unique([email])
  @@unique([username])
  @@map("user")
}

model Session {
  id        String   @id
  expiresAt DateTime
  token     String
  createdAt DateTime
  updatedAt DateTime
  ipAddress String?
  userAgent String?
  userId    String
  user      User     @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@unique([token])
  @@map("session")
}

model Account {
  id                    String    @id
  accountId             String
  providerId            String
  userId                String
  user                  User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  accessToken           String?
  refreshToken          String?
  idToken               String?
  accessTokenExpiresAt  DateTime?
  refreshTokenExpiresAt DateTime?
  scope                 String?
  password              String?
  createdAt             DateTime
  updatedAt             DateTime

  @@map("account")
}

model Verification {
  id         String    @id
  identifier String
  value      String
  expiresAt  DateTime
  createdAt  DateTime?
  updatedAt  DateTime?

  @@map("verification")
}

model TwoFactor {
  id          String @id
  secret      String
  backupCodes String
  userId      String
  user        User   @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@map("twoFactor")
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/index.ts
```typescript
#!/usr/bin/env node

import { Command } from "commander";
import { migrate } from "./commands/migrate";
import { generate } from "./commands/generate";
import "dotenv/config";
import { generateSecret } from "./commands/secret";
import { getPackageInfo } from "./utils/get-package-info";
import { init } from "./commands/init";
// handle exit
process.on("SIGINT", () => process.exit(0));
process.on("SIGTERM", () => process.exit(0));

async function main() {
	const program = new Command("better-auth");
	let packageInfo: Record<string, any> = {};
	try {
		packageInfo = await getPackageInfo();
	} catch (error) {
		// it doesn't matter if we can't read the package.json file, we'll just use an empty object
	}
	program
		.addCommand(migrate)
		.addCommand(generate)
		.addCommand(generateSecret)
		.addCommand(init)
		.version(packageInfo.version || "1.1.2")
		.description("Better Auth CLI");
	program.parse();
}

main();

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/utils/add-svelte-kit-env-modules.ts
```typescript
export function addSvelteKitEnvModules(aliases: Record<string, string>) {
	aliases["$env/dynamic/private"] = createDataUriModule(
		createDynamicEnvModule(),
	);
	aliases["$env/dynamic/public"] = createDataUriModule(
		createDynamicEnvModule(),
	);
	aliases["$env/static/private"] = createDataUriModule(
		createStaticEnvModule(filterPrivateEnv("PUBLIC_", "")),
	);
	aliases["$env/static/public"] = createDataUriModule(
		createStaticEnvModule(filterPublicEnv("PUBLIC_", "")),
	);
}

function createDataUriModule(module: string) {
	return `data:text/javascript;charset=utf-8,${encodeURIComponent(module)}`;
}

function createStaticEnvModule(env: Record<string, string>) {
	const declarations = Object.keys(env)
		.filter((k) => validIdentifier.test(k) && !reserved.has(k))
		.map((k) => `export const ${k} = ${JSON.stringify(env[k])};`);

	return `
  ${declarations.join("\n")}
  // jiti dirty hack: .unknown
  `;
}

function createDynamicEnvModule() {
	return `
  export const env = process.env;
  // jiti dirty hack: .unknown
  `;
}

export function filterPrivateEnv(publicPrefix: string, privatePrefix: string) {
	return Object.fromEntries(
		Object.entries(process.env).filter(
			([k]) =>
				k.startsWith(privatePrefix) &&
				(publicPrefix === "" || !k.startsWith(publicPrefix)),
		),
	) as Record<string, string>;
}

export function filterPublicEnv(publicPrefix: string, privatePrefix: string) {
	return Object.fromEntries(
		Object.entries(process.env).filter(
			([k]) =>
				k.startsWith(publicPrefix) &&
				(privatePrefix === "" || !k.startsWith(privatePrefix)),
		),
	) as Record<string, string>;
}

const validIdentifier = /^[a-zA-Z_$][a-zA-Z0-9_$]*$/;
const reserved = new Set([
	"do",
	"if",
	"in",
	"for",
	"let",
	"new",
	"try",
	"var",
	"case",
	"else",
	"enum",
	"eval",
	"null",
	"this",
	"true",
	"void",
	"with",
	"await",
	"break",
	"catch",
	"class",
	"const",
	"false",
	"super",
	"throw",
	"while",
	"yield",
	"delete",
	"export",
	"import",
	"public",
	"return",
	"static",
	"switch",
	"typeof",
	"default",
	"extends",
	"finally",
	"package",
	"private",
	"continue",
	"debugger",
	"function",
	"arguments",
	"interface",
	"protected",
	"implements",
	"instanceof",
]);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/utils/check-package-managers.ts
```typescript
import { exec } from "child_process";

function checkCommand(command: string): Promise<boolean> {
	return new Promise((resolve) => {
		exec(`${command} --version`, (error) => {
			if (error) {
				resolve(false); // Command not found or error occurred
			} else {
				resolve(true); // Command exists
			}
		});
	});
}

export async function checkPackageManagers(): Promise<{
	hasPnpm: boolean;
	hasBun: boolean;
}> {
	const hasPnpm = await checkCommand("pnpm");
	const hasBun = await checkCommand("bun");

	return {
		hasPnpm,
		hasBun,
	};
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/utils/format-ms.ts
```typescript
/**
 * Only supports up to seconds.
 */
export function formatMilliseconds(ms: number) {
	if (ms < 0) {
		throw new Error("Milliseconds cannot be negative");
	}
	if (ms < 1000) {
		return `${ms}ms`;
	}

	const seconds = Math.floor(ms / 1000);
	const milliseconds = ms % 1000;

	return `${seconds}s ${milliseconds}ms`;
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/utils/get-config.ts
```typescript
import { loadConfig } from "c12";
import type { BetterAuthOptions } from "better-auth";
import { logger } from "better-auth";
import path from "path";
// @ts-ignore
import babelPresetTypescript from "@babel/preset-typescript";
// @ts-ignore
import babelPresetReact from "@babel/preset-react";
import fs, { existsSync } from "fs";
import { BetterAuthError } from "better-auth";
import { addSvelteKitEnvModules } from "./add-svelte-kit-env-modules";
import { getTsconfigInfo } from "./get-tsconfig-info";

let possiblePaths = [
	"auth.ts",
	"auth.tsx",
	"auth.js",
	"auth.jsx",
	"auth.server.js",
	"auth.server.ts",
];

possiblePaths = [
	...possiblePaths,
	...possiblePaths.map((it) => `lib/server/${it}`),
	...possiblePaths.map((it) => `server/${it}`),
	...possiblePaths.map((it) => `lib/${it}`),
	...possiblePaths.map((it) => `utils/${it}`),
];
possiblePaths = [
	...possiblePaths,
	...possiblePaths.map((it) => `src/${it}`),
	...possiblePaths.map((it) => `app/${it}`),
];

function getPathAliases(cwd: string): Record<string, string> | null {
	const tsConfigPath = path.join(cwd, "tsconfig.json");
	if (!fs.existsSync(tsConfigPath)) {
		return null;
	}
	try {
		const tsConfig = getTsconfigInfo(cwd);
		const { paths = {}, baseUrl = "." } = tsConfig.compilerOptions || {};
		const result: Record<string, string> = {};
		const obj = Object.entries(paths) as [string, string[]][];
		for (const [alias, aliasPaths] of obj) {
			for (const aliasedPath of aliasPaths) {
				const resolvedBaseUrl = path.join(cwd, baseUrl);
				const finalAlias = alias.slice(-1) === "*" ? alias.slice(0, -1) : alias;
				const finalAliasedPath =
					aliasedPath.slice(-1) === "*"
						? aliasedPath.slice(0, -1)
						: aliasedPath;

				result[finalAlias || ""] = path.join(resolvedBaseUrl, finalAliasedPath);
			}
		}
		addSvelteKitEnvModules(result);
		return result;
	} catch (error) {
		console.error(error);
		throw new BetterAuthError("Error parsing tsconfig.json");
	}
}
/**
 * .tsx files are not supported by Jiti.
 */
const jitiOptions = (cwd: string) => {
	const alias = getPathAliases(cwd) || {};
	return {
		transformOptions: {
			babel: {
				presets: [
					[
						babelPresetTypescript,
						{
							isTSX: true,
							allExtensions: true,
						},
					],
					[babelPresetReact, { runtime: "automatic" }],
				],
			},
		},
		extensions: [".ts", ".tsx", ".js", ".jsx"],
		alias,
	};
};
export async function getConfig({
	cwd,
	configPath,
	shouldThrowOnError = false,
}: {
	cwd: string;
	configPath?: string;
	shouldThrowOnError?: boolean;
}) {
	try {
		let configFile: BetterAuthOptions | null = null;
		if (configPath) {
			let resolvedPath: string = path.join(cwd, configPath);
			if (existsSync(configPath)) resolvedPath = configPath; // If the configPath is a file, use it as is, as it means the path wasn't relative.
			const { config } = await loadConfig<{
				auth: {
					options: BetterAuthOptions;
				};
				default?: {
					options: BetterAuthOptions;
				};
			}>({
				configFile: resolvedPath,
				dotenv: true,
				jitiOptions: jitiOptions(cwd),
			});
			if (!config.auth && !config.default) {
				if (shouldThrowOnError) {
					throw new Error(
						`Couldn't read your auth config in ${resolvedPath}. Make sure to default export your auth instance or to export as a variable named auth.`,
					);
				}
				logger.error(
					`[#better-auth]: Couldn't read your auth config in ${resolvedPath}. Make sure to default export your auth instance or to export as a variable named auth.`,
				);
				process.exit(1);
			}
			configFile = config.auth?.options || config.default?.options || null;
		}

		if (!configFile) {
			for (const possiblePath of possiblePaths) {
				try {
					const { config } = await loadConfig<{
						auth: {
							options: BetterAuthOptions;
						};
						default?: {
							options: BetterAuthOptions;
						};
					}>({
						configFile: possiblePath,
						jitiOptions: jitiOptions(cwd),
					});
					const hasConfig = Object.keys(config).length > 0;
					if (hasConfig) {
						configFile =
							config.auth?.options || config.default?.options || null;
						if (!configFile) {
							if (shouldThrowOnError) {
								throw new Error(
									"Couldn't read your auth config. Make sure to default export your auth instance or to export as a variable named auth.",
								);
							}
							logger.error("[#better-auth]: Couldn't read your auth config.");
							console.log("");
							logger.info(
								"[#better-auth]: Make sure to default export your auth instance or to export as a variable named auth.",
							);
							process.exit(1);
						}
						break;
					}
				} catch (e) {
					if (
						typeof e === "object" &&
						e &&
						"message" in e &&
						typeof e.message === "string" &&
						e.message.includes(
							"This module cannot be imported from a Client Component module",
						)
					) {
						if (shouldThrowOnError) {
							throw new Error(
								`Please remove import 'server-only' from your auth config file temporarily. The CLI cannot resolve the configuration with it included. You can re-add it after running the CLI.`,
							);
						}
						logger.error(
							`Please remove import 'server-only' from your auth config file temporarily. The CLI cannot resolve the configuration with it included. You can re-add it after running the CLI.`,
						);
						process.exit(1);
					}
					if (shouldThrowOnError) {
						throw e;
					}
					logger.error("[#better-auth]: Couldn't read your auth config.", e);
					process.exit(1);
				}
			}
		}
		return configFile;
	} catch (e) {
		if (
			typeof e === "object" &&
			e &&
			"message" in e &&
			typeof e.message === "string" &&
			e.message.includes(
				"This module cannot be imported from a Client Component module",
			)
		) {
			if (shouldThrowOnError) {
				throw new Error(
					`Please remove import 'server-only' from your auth config file temporarily. The CLI cannot resolve the configuration with it included. You can re-add it after running the CLI.`,
				);
			}
			logger.error(
				`Please remove import 'server-only' from your auth config file temporarily. The CLI cannot resolve the configuration with it included. You can re-add it after running the CLI.`,
			);
			process.exit(1);
		}
		if (shouldThrowOnError) {
			throw e;
		}

		logger.error("Couldn't read your auth config.", e);
		process.exit(1);
	}
}

export { possiblePaths };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/utils/get-package-info.ts
```typescript
import path from "path";
import fs from "fs-extra";

export function getPackageInfo(cwd?: string) {
	const packageJsonPath = cwd
		? path.join(cwd, "package.json")
		: path.join("package.json");
	try {
		return fs.readJSONSync(packageJsonPath);
	} catch (error) {
		throw error;
	}
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/utils/get-tsconfig-info.ts
```typescript
import path from "path";
import fs from "fs-extra";

export function stripJsonComments(jsonString: string): string {
	return jsonString
		.replace(/\\"|"(?:\\"|[^"])*"|(\/\/.*|\/\*[\s\S]*?\*\/)/g, (m, g) =>
			g ? "" : m,
		)
		.replace(/,(?=\s*[}\]])/g, "");
}

export function getTsconfigInfo(cwd?: string) {
	const packageJsonPath = cwd
		? path.join(cwd, "tsconfig.json")
		: path.join("tsconfig.json");
	try {
		const text = fs.readFileSync(packageJsonPath, "utf-8");
		return JSON.parse(stripJsonComments(text));
	} catch (error) {
		throw error;
	}
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/utils/install-dependencies.ts
```typescript
import { exec } from "child_process";

export function installDependencies({
	dependencies,
	packageManager,
	cwd,
}: {
	dependencies: string[];
	packageManager: "npm" | "pnpm" | "bun" | "yarn";
	cwd: string;
}): Promise<boolean> {
	let installCommand: string;
	switch (packageManager) {
		case "npm":
			installCommand = "npm install --force";
			break;
		case "pnpm":
			installCommand = "pnpm install";
			break;
		case "bun":
			installCommand = "bun install";
			break;
		case "yarn":
			installCommand = "yarn install";
			break;
		default:
			throw new Error("Invalid package manager");
	}
	const command = `${installCommand} ${dependencies.join(" ")}`;

	return new Promise((resolve, reject) => {
		exec(command, { cwd }, (error, stdout, stderr) => {
			if (error) {
				reject(new Error(stderr));
				return;
			}
			resolve(true);
		});
	});
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/commands/generate.ts
```typescript
import { Command } from "commander";
import { getConfig } from "../utils/get-config";
import { z } from "zod";
import { existsSync } from "fs";
import path from "path";
import { logger } from "better-auth";
import yoctoSpinner from "yocto-spinner";
import prompts from "prompts";
import fs from "fs/promises";
import chalk from "chalk";
import { getAdapter } from "better-auth/db";
import { getGenerator } from "../generators";

export async function generateAction(opts: any) {
	const options = z
		.object({
			cwd: z.string(),
			config: z.string().optional(),
			output: z.string().optional(),
			y: z.boolean().optional(),
		})
		.parse(opts);

	const cwd = path.resolve(options.cwd);
	if (!existsSync(cwd)) {
		logger.error(`The directory "${cwd}" does not exist.`);
		process.exit(1);
	}
	const config = await getConfig({
		cwd,
		configPath: options.config,
	});
	if (!config) {
		logger.error(
			"No configuration file found. Add a `auth.ts` file to your project or pass the path to the configuration file using the `--config` flag.",
		);
		return;
	}

	const adapter = await getAdapter(config).catch((e) => {
		logger.error(e.message);
		process.exit(1);
	});

	const spinner = yoctoSpinner({ text: "preparing schema..." }).start();

	const schema = await getGenerator({
		adapter,
		file: options.output,
		options: config,
	});

	spinner.stop();
	if (!schema.code) {
		logger.info("Your schema is already up to date.");
		process.exit(0);
	}
	if (schema.append || schema.overwrite) {
		let confirm = options.y;
		if (!confirm) {
			const response = await prompts({
				type: "confirm",
				name: "confirm",
				message: `The file ${
					schema.fileName
				} already exists. Do you want to ${chalk.yellow(
					`${schema.overwrite ? "overwrite" : "append"}`,
				)} the schema to the file?`,
			});
			confirm = response.confirm;
		}

		if (confirm) {
			const exist = existsSync(path.join(cwd, schema.fileName));
			if (!exist) {
				await fs.mkdir(path.dirname(path.join(cwd, schema.fileName)), {
					recursive: true,
				});
			}
			if (schema.overwrite) {
				await fs.writeFile(path.join(cwd, schema.fileName), schema.code);
			} else {
				await fs.appendFile(path.join(cwd, schema.fileName), schema.code);
			}
			logger.success(
				`🚀 Schema was ${
					schema.overwrite ? "overwritten" : "appended"
				} successfully!`,
			);
			process.exit(0);
		} else {
			logger.error("Schema generation aborted.");
			process.exit(1);
		}
	}

	let confirm = options.y;

	if (!confirm) {
		const response = await prompts({
			type: "confirm",
			name: "confirm",
			message: `Do you want to generate the schema to ${chalk.yellow(
				schema.fileName,
			)}?`,
		});
		confirm = response.confirm;
	}

	if (!confirm) {
		logger.error("Schema generation aborted.");
		process.exit(1);
	}

	if (!options.output) {
		const dirExist = existsSync(path.dirname(path.join(cwd, schema.fileName)));
		if (!dirExist) {
			await fs.mkdir(path.dirname(path.join(cwd, schema.fileName)), {
				recursive: true,
			});
		}
	}
	await fs.writeFile(
		options.output || path.join(cwd, schema.fileName),
		schema.code,
	);
	logger.success(`🚀 Schema was generated successfully!`);
	process.exit(0);
}

export const generate = new Command("generate")
	.option(
		"-c, --cwd <cwd>",
		"the working directory. defaults to the current directory.",
		process.cwd(),
	)
	.option(
		"--config <config>",
		"the path to the configuration file. defaults to the first configuration file found.",
	)
	.option("--output <output>", "the file to output to the generated schema")
	.option("-y, --y", "automatically answer yes to all prompts", false)
	.action(generateAction);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/commands/init.ts
```typescript
import { parse } from "dotenv";
import semver from "semver";
import { format as prettierFormat } from "prettier";
import { Command } from "commander";
import { z } from "zod";
import { existsSync } from "fs";
import path from "path";
import fs from "fs/promises";
import { getPackageInfo } from "../utils/get-package-info";
import chalk from "chalk";
import {
	cancel,
	confirm,
	intro,
	isCancel,
	log,
	multiselect,
	outro,
	select,
	spinner,
	text,
} from "@clack/prompts";
import { installDependencies } from "../utils/install-dependencies";
import { checkPackageManagers } from "../utils/check-package-managers";
import { formatMilliseconds } from "../utils/format-ms";
import { generateSecretHash } from "./secret";
import { generateAuthConfig } from "../generators/auth-config";
import { getTsconfigInfo } from "../utils/get-tsconfig-info";

/**
 * Should only use any database that is core DBs, and supports the BetterAuth CLI generate functionality.
 */
const supportedDatabases = [
	// Built-in kysely
	"sqlite",
	"mysql",
	"mssql",
	"postgres",
	// Drizzle
	"drizzle:pg",
	"drizzle:mysql",
	"drizzle:sqlite",
	// Prisma
	"prisma:postgresql",
	"prisma:mysql",
	"prisma:sqlite",
	// Mongo
	"mongodb",
] as const;

export type SupportedDatabases = (typeof supportedDatabases)[number];

export const supportedPlugins = [
	{
		id: "two-factor",
		name: "twoFactor",
		path: `better-auth/plugins`,
		clientName: "twoFactorClient",
		clientPath: "better-auth/client/plugins",
	},
	{
		id: "username",
		name: "username",
		clientName: "usernameClient",
		path: `better-auth/plugins`,
		clientPath: "better-auth/client/plugins",
	},
	{
		id: "anonymous",
		name: "anonymous",
		clientName: "anonymousClient",
		path: `better-auth/plugins`,
		clientPath: "better-auth/client/plugins",
	},
	{
		id: "phone-number",
		name: "phoneNumber",
		clientName: "phoneNumberClient",
		path: `better-auth/plugins`,
		clientPath: "better-auth/client/plugins",
	},
	{
		id: "magic-link",
		name: "magicLink",
		clientName: "magicLinkClient",
		clientPath: "better-auth/client/plugins",
		path: `better-auth/plugins`,
	},
	{
		id: "email-otp",
		name: "emailOTP",
		clientName: "emailOTPClient",
		path: `better-auth/plugins`,
		clientPath: "better-auth/client/plugins",
	},
	{
		id: "passkey",
		name: "passkey",
		clientName: "passkeyClient",
		path: `better-auth/plugins/passkey`,
		clientPath: "better-auth/client/plugins",
	},
	{
		id: "generic-oauth",
		name: "genericOAuth",
		clientName: "genericOAuthClient",
		path: `better-auth/plugins`,
		clientPath: "better-auth/client/plugins",
	},
	{
		id: "one-tap",
		name: "oneTap",
		clientName: "oneTapClient",
		path: `better-auth/plugins`,
		clientPath: "better-auth/client/plugins",
	},
	{
		id: "api-key",
		name: "apiKey",
		clientName: "apiKeyClient",
		path: `better-auth/plugins`,
		clientPath: "better-auth/client/plugins",
	},
	{
		id: "admin",
		name: "admin",
		clientName: "adminClient",
		path: `better-auth/plugins`,
		clientPath: "better-auth/client/plugins",
	},
	{
		id: "organization",
		name: "organization",
		clientName: "organizationClient",
		path: `better-auth/plugins`,
		clientPath: "better-auth/client/plugins",
	},
	{
		id: "oidc",
		name: "oidcProvider",
		clientName: "oidcClient",
		path: `better-auth/plugins`,
		clientPath: "better-auth/client/plugins",
	},
	{
		id: "sso",
		name: "sso",
		clientName: "ssoClient",
		path: `better-auth/plugins/sso`,
		clientPath: "better-auth/client/plugins",
	},
	{
		id: "bearer",
		name: "bearer",
		clientName: undefined,
		path: `better-auth/plugins`,
		clientPath: undefined,
	},
	{
		id: "multi-session",
		name: "multiSession",
		clientName: "multiSessionClient",
		path: `better-auth/plugins`,
		clientPath: "better-auth/client/plugins",
	},
	{
		id: "oauth-proxy",
		name: "oAuthProxy",
		clientName: undefined,
		path: `better-auth/plugins`,
		clientPath: undefined,
	},
	{
		id: "open-api",
		name: "openAPI",
		clientName: undefined,
		path: `better-auth/plugins`,
		clientPath: undefined,
	},
	{
		id: "jwt",
		name: "jwt",
		clientName: undefined,
		clientPath: undefined,
		path: `better-auth/plugins`,
	},
	{
		id: "next-cookies",
		name: "nextCookies",
		clientPath: undefined,
		clientName: undefined,
		path: `better-auth/next-js`,
	},
] as const;

export type SupportedPlugin = (typeof supportedPlugins)[number];

const defaultFormatOptions = {
	trailingComma: "all" as const,
	useTabs: false,
	tabWidth: 4,
};

const getDefaultAuthConfig = async ({
	appName,
}: {
	appName?: string;
}) =>
	await prettierFormat(
		[
			"import { betterAuth } from 'better-auth';",
			"",
			"export const auth = betterAuth({",
			appName ? `appName: "${appName}",` : "",
			"plugins: [],",
			"});",
		].join("\n"),
		{
			filepath: "auth.ts",
			...defaultFormatOptions,
		},
	);

type SupportedFrameworks =
	| "vanilla"
	| "react"
	| "vue"
	| "svelte"
	| "solid"
	| "nextjs";

type Import = {
	path: string;
	variables:
		| { asType?: boolean; name: string; as?: string }[]
		| { asType?: boolean; name: string; as?: string };
};

const getDefaultAuthClientConfig = async ({
	auth_config_path,
	framework,
	clientPlugins,
}: {
	framework: SupportedFrameworks;
	auth_config_path: string;
	clientPlugins: {
		id: string;
		name: string;
		contents: string;
		imports: Import[];
	}[];
}) => {
	function groupImportVariables(): Import[] {
		const result: Import[] = [
			{
				path: "better-auth/client/plugins",
				variables: [{ name: "inferAdditionalFields" }],
			},
		];
		for (const plugin of clientPlugins) {
			for (const import_ of plugin.imports) {
				if (Array.isArray(import_.variables)) {
					for (const variable of import_.variables) {
						const existingIndex = result.findIndex(
							(x) => x.path === import_.path,
						);
						if (existingIndex !== -1) {
							const vars = result[existingIndex]!.variables;
							if (Array.isArray(vars)) {
								vars.push(variable);
							} else {
								result[existingIndex]!.variables = [vars, variable];
							}
						} else {
							result.push({
								path: import_.path,
								variables: [variable],
							});
						}
					}
				} else {
					const existingIndex = result.findIndex(
						(x) => x.path === import_.path,
					);
					if (existingIndex !== -1) {
						const vars = result[existingIndex]!.variables;
						if (Array.isArray(vars)) {
							vars.push(import_.variables);
						} else {
							result[existingIndex]!.variables = [vars, import_.variables];
						}
					} else {
						result.push({
							path: import_.path,
							variables: [import_.variables],
						});
					}
				}
			}
		}
		return result;
	}
	let imports = groupImportVariables();
	let importString = "";
	for (const import_ of imports) {
		if (Array.isArray(import_.variables)) {
			importString += `import { ${import_.variables
				.map(
					(x) =>
						`${x.asType ? "type " : ""}${x.name}${x.as ? ` as ${x.as}` : ""}`,
				)
				.join(", ")} } from "${import_.path}";\n`;
		} else {
			importString += `import ${import_.variables.asType ? "type " : ""}${
				import_.variables.name
			}${import_.variables.as ? ` as ${import_.variables.as}` : ""} from "${
				import_.path
			}";\n`;
		}
	}

	return await prettierFormat(
		[
			`import { createAuthClient } from "better-auth/${
				framework === "nextjs"
					? "react"
					: framework === "vanilla"
						? "client"
						: framework
			}";`,
			`import type { auth } from "${auth_config_path}";`,
			importString,
			``,
			`export const authClient = createAuthClient({`,
			`baseURL: "http://localhost:3000",`,
			`plugins: [inferAdditionalFields<typeof auth>(),${clientPlugins
				.map((x) => `${x.name}(${x.contents})`)
				.join(", ")}],`,
			`});`,
		].join("\n"),
		{
			filepath: "auth-client.ts",
			...defaultFormatOptions,
		},
	);
};

const optionsSchema = z.object({
	cwd: z.string(),
	config: z.string().optional(),
	database: z.enum(supportedDatabases).optional(),
	"skip-db": z.boolean().optional(),
	"skip-plugins": z.boolean().optional(),
	"package-manager": z.string().optional(),
});

const outroText = `🥳 All Done, Happy Hacking!`;

export async function initAction(opts: any) {
	console.log();
	intro("👋 Initializing Better Auth");

	const options = optionsSchema.parse(opts);

	const cwd = path.resolve(options.cwd);
	let packageManagerPreference: "bun" | "pnpm" | "yarn" | "npm" | undefined =
		undefined;

	let config_path: string = "";
	let framework: SupportedFrameworks = "vanilla";

	const format = async (code: string) =>
		await prettierFormat(code, {
			filepath: config_path,
			...defaultFormatOptions,
		});

	// ===== package.json =====
	let packageInfo: Record<string, any>;
	try {
		packageInfo = getPackageInfo(cwd);
	} catch (error) {
		log.error(`❌ Couldn't read your package.json file. (dir: ${cwd})`);
		log.error(JSON.stringify(error, null, 2));
		process.exit(1);
	}

	// ===== ENV files =====
	const envFiles = await getEnvFiles(cwd);
	if (!envFiles.length) {
		outro("❌ No .env files found. Please create an env file first.");
		process.exit(0);
	}
	let targetEnvFile: string;
	if (envFiles.includes(".env")) targetEnvFile = ".env";
	else if (envFiles.includes(".env.local")) targetEnvFile = ".env.local";
	else if (envFiles.includes(".env.development"))
		targetEnvFile = ".env.development";
	else if (envFiles.length === 1) targetEnvFile = envFiles[0]!;
	else targetEnvFile = "none";

	// ===== tsconfig.json =====
	let tsconfigInfo: Record<string, any>;
	try {
		tsconfigInfo = await getTsconfigInfo(cwd);
	} catch (error) {
		log.error(`❌ Couldn't read your tsconfig.json file. (dir: ${cwd})`);
		console.error(error);
		process.exit(1);
	}
	if (
		!(
			"compilerOptions" in tsconfigInfo &&
			"strict" in tsconfigInfo.compilerOptions &&
			tsconfigInfo.compilerOptions.strict === true
		)
	) {
		log.warn(
			`Better Auth requires your tsconfig.json to have "compilerOptions.strict" set to true.`,
		);
		const shouldAdd = await confirm({
			message: `Would you like us to set ${chalk.bold(
				`strict`,
			)} to ${chalk.bold(`true`)}?`,
		});
		if (isCancel(shouldAdd)) {
			cancel(`✋ Operation cancelled.`);
			process.exit(0);
		}
		if (shouldAdd) {
			try {
				await fs.writeFile(
					path.join(cwd, "tsconfig.json"),
					await prettierFormat(
						JSON.stringify(
							Object.assign(tsconfigInfo, {
								compilerOptions: {
									strict: true,
								},
							}),
						),
						{ filepath: "tsconfig.json", ...defaultFormatOptions },
					),
					"utf-8",
				);
				log.success(`🚀 tsconfig.json successfully updated!`);
			} catch (error) {
				log.error(
					`Failed to add "compilerOptions.strict" to your tsconfig.json file.`,
				);
				console.error(error);
				process.exit(1);
			}
		}
	}

	// ===== install better-auth =====
	const s = spinner({ indicator: "dots" });
	s.start(`Checking better-auth installation`);

	let latest_betterauth_version: string;
	try {
		latest_betterauth_version = await getLatestNpmVersion("better-auth");
	} catch (error) {
		log.error(`❌ Couldn't get latest version of better-auth.`);
		console.error(error);
		process.exit(1);
	}

	if (
		!packageInfo.dependencies ||
		!Object.keys(packageInfo.dependencies).includes("better-auth")
	) {
		s.stop("Finished fetching latest version of better-auth.");
		const s2 = spinner({ indicator: "dots" });
		const shouldInstallBetterAuthDep = await confirm({
			message: `Would you like to install Better Auth?`,
		});
		if (isCancel(shouldInstallBetterAuthDep)) {
			cancel(`✋ Operation cancelled.`);
			process.exit(0);
		}
		if (packageManagerPreference === undefined) {
			packageManagerPreference = await getPackageManager();
		}
		if (shouldInstallBetterAuthDep) {
			s2.start(
				`Installing Better Auth using ${chalk.bold(packageManagerPreference)}`,
			);
			try {
				const start = Date.now();
				await installDependencies({
					dependencies: ["better-auth@latest"],
					packageManager: packageManagerPreference,
					cwd: cwd,
				});
				s2.stop(
					`Better Auth installed ${chalk.greenBright(
						`successfully`,
					)}! ${chalk.gray(`(${formatMilliseconds(Date.now() - start)})`)}`,
				);
			} catch (error: any) {
				s2.stop(`Failed to install Better Auth:`);
				console.error(error);
				process.exit(1);
			}
		}
	} else if (
		packageInfo.dependencies["better-auth"] !== "workspace:*" &&
		semver.lt(
			semver.coerce(packageInfo.dependencies["better-auth"])?.toString()!,
			semver.clean(latest_betterauth_version)!,
		)
	) {
		s.stop("Finished fetching latest version of better-auth.");
		const shouldInstallBetterAuthDep = await confirm({
			message: `Your current Better Auth dependency is out-of-date. Would you like to update it? (${chalk.bold(
				packageInfo.dependencies["better-auth"],
			)} → ${chalk.bold(`v${latest_betterauth_version}`)})`,
		});
		if (isCancel(shouldInstallBetterAuthDep)) {
			cancel(`✋ Operation cancelled.`);
			process.exit(0);
		}
		if (shouldInstallBetterAuthDep) {
			if (packageManagerPreference === undefined) {
				packageManagerPreference = await getPackageManager();
			}
			const s = spinner({ indicator: "dots" });
			s.start(
				`Updating Better Auth using ${chalk.bold(packageManagerPreference)}`,
			);
			try {
				const start = Date.now();
				await installDependencies({
					dependencies: ["better-auth@latest"],
					packageManager: packageManagerPreference,
					cwd: cwd,
				});
				s.stop(
					`Better Auth updated ${chalk.greenBright(
						`successfully`,
					)}! ${chalk.gray(`(${formatMilliseconds(Date.now() - start)})`)}`,
				);
			} catch (error: any) {
				s.stop(`Failed to update Better Auth:`);
				log.error(error.message);
				process.exit(1);
			}
		}
	} else {
		s.stop(`Better Auth dependencies are ${chalk.greenBright(`up-to-date`)}!`);
	}

	// ===== appName =====

	const packageJson = getPackageInfo(cwd);
	let appName: string;
	if (!packageJson.name) {
		const newAppName = await text({
			message: "What is the name of your application?",
		});
		if (isCancel(newAppName)) {
			cancel("✋ Operation cancelled.");
			process.exit(0);
		}
		appName = newAppName;
	} else {
		appName = packageJson.name;
	}

	// ===== config path =====

	let possiblePaths = ["auth.ts", "auth.tsx", "auth.js", "auth.jsx"];
	possiblePaths = [
		...possiblePaths,
		...possiblePaths.map((it) => `lib/server/${it}`),
		...possiblePaths.map((it) => `server/${it}`),
		...possiblePaths.map((it) => `lib/${it}`),
		...possiblePaths.map((it) => `utils/${it}`),
	];
	possiblePaths = [
		...possiblePaths,
		...possiblePaths.map((it) => `src/${it}`),
		...possiblePaths.map((it) => `app/${it}`),
	];

	if (options.config) {
		config_path = path.join(cwd, options.config);
	} else {
		for (const possiblePath of possiblePaths) {
			const doesExist = existsSync(path.join(cwd, possiblePath));
			if (doesExist) {
				config_path = path.join(cwd, possiblePath);
				break;
			}
		}
	}

	// ===== create auth config =====
	let current_user_config = "";
	let database: SupportedDatabases | null = null;
	let add_plugins: SupportedPlugin[] = [];

	if (!config_path) {
		const shouldCreateAuthConfig = await select({
			message: `Would you like to create an auth config file?`,
			options: [
				{ label: "Yes", value: "yes" },
				{ label: "No", value: "no" },
			],
		});
		if (isCancel(shouldCreateAuthConfig)) {
			cancel(`✋ Operation cancelled.`);
			process.exit(0);
		}
		if (shouldCreateAuthConfig === "yes") {
			const shouldSetupDb = await confirm({
				message: `Would you like to set up your ${chalk.bold(`database`)}?`,
				initialValue: true,
			});
			if (isCancel(shouldSetupDb)) {
				cancel(`✋ Operating cancelled.`);
				process.exit(0);
			}
			if (shouldSetupDb) {
				const prompted_database = await select({
					message: "Choose a Database Dialect",
					options: supportedDatabases.map((it) => ({ value: it, label: it })),
				});
				if (isCancel(prompted_database)) {
					cancel(`✋ Operating cancelled.`);
					process.exit(0);
				}
				database = prompted_database;
			}

			if (options["skip-plugins"] !== false) {
				const shouldSetupPlugins = await confirm({
					message: `Would you like to set up ${chalk.bold(`plugins`)}?`,
				});
				if (isCancel(shouldSetupPlugins)) {
					cancel(`✋ Operating cancelled.`);
					process.exit(0);
				}
				if (shouldSetupPlugins) {
					const prompted_plugins = await multiselect({
						message: "Select your new plugins",
						options: supportedPlugins
							.filter((x) => x.id !== "next-cookies")
							.map((x) => ({ value: x.id, label: x.id })),
						required: false,
					});
					if (isCancel(prompted_plugins)) {
						cancel(`✋ Operating cancelled.`);
						process.exit(0);
					}
					add_plugins = prompted_plugins.map(
						(x) => supportedPlugins.find((y) => y.id === x)!,
					);

					const possible_next_config_paths = [
						"next.config.js",
						"next.config.ts",
						"next.config.mjs",
						".next/server/next.config.js",
						".next/server/next.config.ts",
						".next/server/next.config.mjs",
					];
					for (const possible_next_config_path of possible_next_config_paths) {
						if (existsSync(path.join(cwd, possible_next_config_path))) {
							framework = "nextjs";
							break;
						}
					}
					if (framework === "nextjs") {
						const result = await confirm({
							message: `It looks like you're using NextJS. Do you want to add the next-cookies plugin? ${chalk.bold(
								`(Recommended)`,
							)}`,
						});
						if (isCancel(result)) {
							cancel(`✋ Operating cancelled.`);
							process.exit(0);
						}
						if (result) {
							add_plugins.push(
								supportedPlugins.find((x) => x.id === "next-cookies")!,
							);
						}
					}
				}
			}

			const filePath = path.join(cwd, "auth.ts");
			config_path = filePath;
			log.info(`Creating auth config file: ${filePath}`);
			try {
				current_user_config = await getDefaultAuthConfig({
					appName,
				});
				const { dependencies, envs, generatedCode } = await generateAuthConfig({
					current_user_config,
					format,
					//@ts-ignore
					s,
					plugins: add_plugins,
					database,
				});
				current_user_config = generatedCode;
				await fs.writeFile(filePath, current_user_config);
				config_path = filePath;
				log.success(`🚀 Auth config file successfully created!`);

				if (envs.length !== 0) {
					log.info(
						`There are ${envs.length} environment variables for your database of choice.`,
					);
					const shouldUpdateEnvs = await confirm({
						message: `Would you like us to update your ENV files?`,
					});
					if (isCancel(shouldUpdateEnvs)) {
						cancel("✋ Operation cancelled.");
						process.exit(0);
					}
					if (shouldUpdateEnvs) {
						const filesToUpdate = await multiselect({
							message: "Select the .env files you want to update",
							options: envFiles.map((x) => ({
								value: path.join(cwd, x),
								label: x,
							})),
							required: false,
						});
						if (isCancel(filesToUpdate)) {
							cancel("✋ Operation cancelled.");
							process.exit(0);
						}
						if (filesToUpdate.length === 0) {
							log.info("No .env files to update. Skipping...");
						} else {
							try {
								await updateEnvs({
									files: filesToUpdate,
									envs,
									isCommented: true,
								});
							} catch (error) {
								log.error(`Failed to update .env files:`);
								log.error(JSON.stringify(error, null, 2));
								process.exit(1);
							}
							log.success(`🚀 ENV files successfully updated!`);
						}
					}
				}
				if (dependencies.length !== 0) {
					log.info(
						`There are ${
							dependencies.length
						} dependencies to install. (${dependencies
							.map((x) => chalk.green(x))
							.join(", ")})`,
					);
					const shouldInstallDeps = await confirm({
						message: `Would you like us to install dependencies?`,
					});
					if (isCancel(shouldInstallDeps)) {
						cancel("✋ Operation cancelled.");
						process.exit(0);
					}
					if (shouldInstallDeps) {
						const s = spinner({ indicator: "dots" });
						if (packageManagerPreference === undefined) {
							packageManagerPreference = await getPackageManager();
						}
						s.start(
							`Installing dependencies using ${chalk.bold(
								packageManagerPreference,
							)}...`,
						);
						try {
							const start = Date.now();
							await installDependencies({
								dependencies: dependencies,
								packageManager: packageManagerPreference,
								cwd: cwd,
							});
							s.stop(
								`Dependencies installed ${chalk.greenBright(
									`successfully`,
								)} ${chalk.gray(
									`(${formatMilliseconds(Date.now() - start)})`,
								)}`,
							);
						} catch (error: any) {
							s.stop(
								`Failed to install dependencies using ${packageManagerPreference}:`,
							);
							log.error(error.message);
							process.exit(1);
						}
					}
				}
			} catch (error) {
				log.error(`Failed to create auth config file: ${filePath}`);
				console.error(error);
				process.exit(1);
			}
		} else if (shouldCreateAuthConfig === "no") {
			log.info(`Skipping auth config file creation.`);
		}
	} else {
		log.message();
		log.success(`Found auth config file. ${chalk.gray(`(${config_path})`)}`);
		log.message();
	}

	// ===== auth client path =====

	let possibleClientPaths = [
		"auth-client.ts",
		"auth-client.tsx",
		"auth-client.js",
		"auth-client.jsx",
		"client.ts",
		"client.tsx",
		"client.js",
		"client.jsx",
	];
	possibleClientPaths = [
		...possibleClientPaths,
		...possibleClientPaths.map((it) => `lib/server/${it}`),
		...possibleClientPaths.map((it) => `server/${it}`),
		...possibleClientPaths.map((it) => `lib/${it}`),
		...possibleClientPaths.map((it) => `utils/${it}`),
	];
	possibleClientPaths = [
		...possibleClientPaths,
		...possibleClientPaths.map((it) => `src/${it}`),
		...possibleClientPaths.map((it) => `app/${it}`),
	];

	let authClientConfigPath: string | null = null;
	for (const possiblePath of possibleClientPaths) {
		const doesExist = existsSync(path.join(cwd, possiblePath));
		if (doesExist) {
			authClientConfigPath = path.join(cwd, possiblePath);
			break;
		}
	}

	if (!authClientConfigPath) {
		const choice = await select({
			message: `Would you like to create an auth client config file?`,
			options: [
				{ label: "Yes", value: "yes" },
				{ label: "No", value: "no" },
			],
		});
		if (isCancel(choice)) {
			cancel(`✋ Operation cancelled.`);
			process.exit(0);
		}
		if (choice === "yes") {
			authClientConfigPath = path.join(cwd, "auth-client.ts");
			log.info(`Creating auth client config file: ${authClientConfigPath}`);
			try {
				let contents = await getDefaultAuthClientConfig({
					auth_config_path: (
						"./" + path.join(config_path.replace(cwd, ""))
					).replace(".//", "./"),
					clientPlugins: add_plugins
						.filter((x) => x.clientName)
						.map((plugin) => {
							let contents = "";
							if (plugin.id === "one-tap") {
								contents = `{ clientId: "MY_CLIENT_ID" }`;
							}
							return {
								contents,
								id: plugin.id,
								name: plugin.clientName!,
								imports: [
									{
										path: "better-auth/client/plugins",
										variables: [{ name: plugin.clientName! }],
									},
								],
							};
						}),
					framework: framework,
				});
				await fs.writeFile(authClientConfigPath, contents);
				log.success(`🚀 Auth client config file successfully created!`);
			} catch (error) {
				log.error(
					`Failed to create auth client config file: ${authClientConfigPath}`,
				);
				log.error(JSON.stringify(error, null, 2));
				process.exit(1);
			}
		} else if (choice === "no") {
			log.info(`Skipping auth client config file creation.`);
		}
	} else {
		log.success(
			`Found auth client config file. ${chalk.gray(
				`(${authClientConfigPath})`,
			)}`,
		);
	}

	if (targetEnvFile !== "none") {
		try {
			const fileContents = await fs.readFile(
				path.join(cwd, targetEnvFile),
				"utf8",
			);
			const parsed = parse(fileContents);
			let isMissingSecret = false;
			let isMissingUrl = false;
			if (parsed.BETTER_AUTH_SECRET === undefined) isMissingSecret = true;
			if (parsed.BETTER_AUTH_URL === undefined) isMissingUrl = true;
			if (isMissingSecret || isMissingUrl) {
				let txt = "";
				if (isMissingSecret && !isMissingUrl)
					txt = chalk.bold(`BETTER_AUTH_SECRET`);
				else if (!isMissingSecret && isMissingUrl)
					txt = chalk.bold(`BETTER_AUTH_URL`);
				else
					txt =
						chalk.bold.underline(`BETTER_AUTH_SECRET`) +
						` and ` +
						chalk.bold.underline(`BETTER_AUTH_URL`);
				log.warn(`Missing ${txt} in ${targetEnvFile}`);

				const shouldAdd = await select({
					message: `Do you want to add ${txt} to ${targetEnvFile}?`,
					options: [
						{ label: "Yes", value: "yes" },
						{ label: "No", value: "no" },
						{ label: "Choose other file(s)", value: "other" },
					],
				});
				if (isCancel(shouldAdd)) {
					cancel(`✋ Operation cancelled.`);
					process.exit(0);
				}
				let envs: string[] = [];
				if (isMissingSecret) {
					envs.push("BETTER_AUTH_SECRET");
				}
				if (isMissingUrl) {
					envs.push("BETTER_AUTH_URL");
				}
				if (shouldAdd === "yes") {
					try {
						await updateEnvs({
							files: [path.join(cwd, targetEnvFile)],
							envs: envs,
							isCommented: false,
						});
					} catch (error) {
						log.error(`Failed to add ENV variables to ${targetEnvFile}`);
						log.error(JSON.stringify(error, null, 2));
						process.exit(1);
					}
					log.success(`🚀 ENV variables successfully added!`);
					if (isMissingUrl) {
						log.info(
							`Be sure to update your BETTER_AUTH_URL according to your app's needs.`,
						);
					}
				} else if (shouldAdd === "no") {
					log.info(`Skipping ENV step.`);
				} else if (shouldAdd === "other") {
					if (!envFiles.length) {
						cancel("No env files found. Please create an env file first.");
						process.exit(0);
					}
					const envFilesToUpdate = await multiselect({
						message: "Select the .env files you want to update",
						options: envFiles.map((x) => ({
							value: path.join(cwd, x),
							label: x,
						})),
						required: false,
					});
					if (isCancel(envFilesToUpdate)) {
						cancel("✋ Operation cancelled.");
						process.exit(0);
					}
					if (envFilesToUpdate.length === 0) {
						log.info("No .env files to update. Skipping...");
					} else {
						try {
							await updateEnvs({
								files: envFilesToUpdate,
								envs: envs,
								isCommented: false,
							});
						} catch (error) {
							log.error(`Failed to update .env files:`);
							log.error(JSON.stringify(error, null, 2));
							process.exit(1);
						}
						log.success(`🚀 ENV files successfully updated!`);
					}
				}
			}
		} catch (error) {
			// if fails, ignore, and do not proceed with ENV operations.
		}
	}

	outro(outroText);
	console.log();
	process.exit(0);
}

// ===== Init Command =====

export const init = new Command("init")
	.option("-c, --cwd <cwd>", "The working directory.", process.cwd())
	.option(
		"--config <config>",
		"The path to the auth configuration file. defaults to the first `auth.ts` file found.",
	)
	.option("--skip-db", "Skip the database setup.")
	.option("--skip-plugins", "Skip the plugins setup.")
	.option(
		"--package-manager <package-manager>",
		"The package manager you want to use.",
	)
	.action(initAction);

async function getLatestNpmVersion(packageName: string): Promise<string> {
	try {
		const response = await fetch(`https://registry.npmjs.org/${packageName}`);

		if (!response.ok) {
			throw new Error(`Package not found: ${response.statusText}`);
		}

		const data = await response.json();
		return data["dist-tags"].latest; // Get the latest version from dist-tags
	} catch (error: any) {
		throw error?.message;
	}
}

async function getPackageManager() {
	const { hasBun, hasPnpm } = await checkPackageManagers();
	if (!hasBun && !hasPnpm) return "npm";

	const packageManagerOptions: {
		value: "bun" | "pnpm" | "yarn" | "npm";
		label?: string;
		hint?: string;
	}[] = [];

	if (hasPnpm) {
		packageManagerOptions.push({
			value: "pnpm",
			label: "pnpm",
			hint: "recommended",
		});
	}
	if (hasBun) {
		packageManagerOptions.push({
			value: "bun",
			label: "bun",
		});
	}
	packageManagerOptions.push({
		value: "npm",
		hint: "not recommended",
	});

	let packageManager = await select({
		message: "Choose a package manager",
		options: packageManagerOptions,
	});
	if (isCancel(packageManager)) {
		cancel(`Operation cancelled.`);
		process.exit(0);
	}
	return packageManager;
}

async function getEnvFiles(cwd: string) {
	const files = await fs.readdir(cwd);
	return files.filter((x) => x.startsWith(".env"));
}

async function updateEnvs({
	envs,
	files,
	isCommented,
}: {
	/**
	 * The ENVs to append to the file
	 */
	envs: string[];
	/**
	 * Full file paths
	 */
	files: string[];
	/**
	 * Weather to comment the all of the envs or not
	 */
	isCommented: boolean;
}) {
	let previouslyGeneratedSecret: string | null = null;
	for (const file of files) {
		const content = await fs.readFile(file, "utf8");
		const lines = content.split("\n");
		const newLines = envs.map(
			(x) =>
				`${isCommented ? "# " : ""}${x}=${
					getEnvDescription(x) ?? `"some_value"`
				}`,
		);
		newLines.push("");
		newLines.push(...lines);
		await fs.writeFile(file, newLines.join("\n"), "utf8");
	}

	function getEnvDescription(env: string) {
		if (env === "DATABASE_HOST") {
			return `"The host of your database"`;
		}
		if (env === "DATABASE_PORT") {
			return `"The port of your database"`;
		}
		if (env === "DATABASE_USER") {
			return `"The username of your database"`;
		}
		if (env === "DATABASE_PASSWORD") {
			return `"The password of your database"`;
		}
		if (env === "DATABASE_NAME") {
			return `"The name of your database"`;
		}
		if (env === "DATABASE_URL") {
			return `"The URL of your database"`;
		}
		if (env === "BETTER_AUTH_SECRET") {
			previouslyGeneratedSecret =
				previouslyGeneratedSecret ?? generateSecretHash();
			return `"${previouslyGeneratedSecret}"`;
		}
		if (env === "BETTER_AUTH_URL") {
			return `"http://localhost:3000" # Your APP URL`;
		}
	}
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/commands/migrate.ts
```typescript
import { Command } from "commander";
import { z } from "zod";
import { existsSync } from "fs";
import path from "path";
import yoctoSpinner from "yocto-spinner";
import chalk from "chalk";
import prompts from "prompts";
import { logger } from "better-auth";
import { getAdapter, getMigrations } from "better-auth/db";
import { getConfig } from "../utils/get-config";

export async function migrateAction(opts: any) {
	const options = z
		.object({
			cwd: z.string(),
			config: z.string().optional(),
			y: z.boolean().optional(),
		})
		.parse(opts);
	const cwd = path.resolve(options.cwd);
	if (!existsSync(cwd)) {
		logger.error(`The directory "${cwd}" does not exist.`);
		process.exit(1);
	}
	const config = await getConfig({
		cwd,
		configPath: options.config,
	});
	if (!config) {
		logger.error(
			"No configuration file found. Add a `auth.ts` file to your project or pass the path to the configuration file using the `--config` flag.",
		);
		return;
	}

	const db = await getAdapter(config);

	if (!db) {
		logger.error(
			"Invalid database configuration. Make sure you're not using adapters. Migrate command only works with built-in Kysely adapter.",
		);
		process.exit(1);
	}

	if (db.id !== "kysely") {
		if (db.id === "prisma") {
			logger.error(
				"The migrate command only works with the built-in Kysely adapter. For Prisma, run `npx @better-auth/cli generate` to create the schema, then use Prisma’s migrate or push to apply it.",
			);
			process.exit(0);
		}
		if (db.id === "drizzle") {
			logger.error(
				"The migrate command only works with the built-in Kysely adapter. For Drizzle, run `npx @better-auth/cli generate` to create the schema, then use Drizzle’s migrate or push to apply it.",
			);
			process.exit(0);
		}
		logger.error("Migrate command isn't supported for this adapter.");
		process.exit(1);
	}

	const spinner = yoctoSpinner({ text: "preparing migration..." }).start();

	const { toBeAdded, toBeCreated, runMigrations } = await getMigrations(config);

	if (!toBeAdded.length && !toBeCreated.length) {
		spinner.stop();
		logger.info("🚀 No migrations needed.");
		process.exit(0);
	}

	spinner.stop();
	logger.info(`🔑 The migration will affect the following:`);

	for (const table of [...toBeCreated, ...toBeAdded]) {
		console.log(
			"->",
			chalk.magenta(Object.keys(table.fields).join(", ")),
			chalk.white("fields on"),
			chalk.yellow(`${table.table}`),
			chalk.white("table."),
		);
	}

	let migrate = options.y;
	if (!migrate) {
		const response = await prompts({
			type: "confirm",
			name: "migrate",
			message: "Are you sure you want to run these migrations?",
			initial: false,
		});
		migrate = response.migrate;
	}

	if (!migrate) {
		logger.info("Migration cancelled.");
		process.exit(0);
	}

	spinner?.start("migrating...");
	await runMigrations();
	spinner.stop();
	logger.info("🚀 migration was completed successfully!");
	process.exit(0);
}

export const migrate = new Command("migrate")
	.option(
		"-c, --cwd <cwd>",
		"the working directory. defaults to the current directory.",
		process.cwd(),
	)
	.option(
		"--config <config>",
		"the path to the configuration file. defaults to the first configuration file found.",
	)
	.option(
		"-y, --y",
		"automatically accept and run migrations without prompting",
		false,
	)
	.action(migrateAction);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/commands/secret.ts
```typescript
import { logger } from "better-auth";
import chalk from "chalk";
import { Command } from "commander";
import Crypto from "crypto";

export const generateSecret = new Command("secret").action(() => {
	const secret = generateSecretHash();
	logger.info(`\nAdd the following to your .env file: 
${
	chalk.gray("# Auth Secret") + chalk.green(`\nBETTER_AUTH_SECRET=${secret}`)
}`);
});

export const generateSecretHash = () => {
	return Crypto.randomBytes(32).toString("hex");
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/generators/auth-config.ts
```typescript
import {
	type SupportedDatabases,
	type SupportedPlugin,
} from "../commands/init";
import { logger } from "better-auth";
import { type spinner as clackSpinner } from "@clack/prompts";

export type Import = {
	path: string;
	variables:
		| { asType?: boolean; name: string; as?: string }[]
		| { asType?: boolean; name: string; as?: string };
};

type Format = (code: string) => Promise<string>;

type CommonIndexConfig_Regex<AdditionalFields> = {
	type: "regex";
	regex: RegExp;
	getIndex: (args: {
		matchIndex: number;
		match: RegExpMatchArray;
		additionalFields: AdditionalFields;
	}) => number | null;
};
type CommonIndexConfig_manual<AdditionalFields> = {
	type: "manual";
	getIndex: (args: {
		content: string;
		additionalFields: AdditionalFields;
	}) => number | null;
};

export type CommonIndexConfig<AdditionalFields> =
	| CommonIndexConfig_Regex<AdditionalFields>
	| CommonIndexConfig_manual<AdditionalFields>;

export async function generateAuthConfig({
	format,
	current_user_config,
	spinner,
	plugins,
	database,
}: {
	format: Format;
	current_user_config: string;
	spinner: ReturnType<typeof clackSpinner>;
	plugins: SupportedPlugin[];
	database: SupportedDatabases | null;
}): Promise<{
	generatedCode: string;
	dependencies: string[];
	envs: string[];
}> {
	let _start_of_plugins_common_index = {
		START_OF_PLUGINS: {
			type: "regex",
			regex: /betterAuth\([\w\W]*plugins:[\W]*\[()/m,
			getIndex: ({ matchIndex, match }) => {
				return matchIndex + match[0].length;
			},
		} satisfies CommonIndexConfig<{}>,
	};
	const common_indexs = {
		START_OF_PLUGINS:
			_start_of_plugins_common_index.START_OF_PLUGINS satisfies CommonIndexConfig<{}>,
		END_OF_PLUGINS: {
			type: "manual",
			getIndex: ({ content, additionalFields }) => {
				const clsoingBracketIndex = findClosingBracket(
					content,
					additionalFields.start_of_plugins,
					"[",
					"]",
				);
				return clsoingBracketIndex;
			},
		} satisfies CommonIndexConfig<{ start_of_plugins: number }>,
		START_OF_BETTERAUTH: {
			type: "regex",
			regex: /betterAuth\({()/m,
			getIndex: ({ matchIndex }) => {
				return matchIndex + "betterAuth({".length;
			},
		} satisfies CommonIndexConfig<{}>,
	};

	const config_generation = {
		add_plugin: async (opts: {
			direction_in_plugins_array: "append" | "prepend";
			pluginFunctionName: string;
			pluginContents: string;
			config: string;
		}): Promise<{ code: string; dependencies: string[]; envs: string[] }> => {
			let start_of_plugins = getGroupInfo(
				opts.config,
				common_indexs.START_OF_PLUGINS,
				{},
			);

			// console.log(`start of plugins:`, start_of_plugins);

			if (!start_of_plugins) {
				throw new Error(
					"Couldn't find start of your plugins array in your auth config file.",
				);
			}
			let end_of_plugins = getGroupInfo(
				opts.config,
				common_indexs.END_OF_PLUGINS,
				{ start_of_plugins: start_of_plugins.index },
			);

			// console.log(`end of plugins:`, end_of_plugins);

			if (!end_of_plugins) {
				throw new Error(
					"Couldn't find end of your plugins array in your auth config file.",
				);
			}
			// console.log(
			// 	"slice:\n",
			// 	opts.config.slice(start_of_plugins.index, end_of_plugins.index),
			// );
			let new_content: string;

			if (opts.direction_in_plugins_array === "prepend") {
				new_content = insertContent({
					line: start_of_plugins.line,
					character: start_of_plugins.character,
					content: opts.config,
					insert_content: `${opts.pluginFunctionName}(${opts.pluginContents}),`,
				});
			} else {
				let has_found_comma = false;
				const str = opts.config
					.slice(start_of_plugins.index, end_of_plugins.index)
					.split("")
					.reverse();
				for (let index = 0; index < str.length; index++) {
					const char = str[index];
					if (char === ",") {
						has_found_comma = true;
					}
					if (char === ")") {
						break;
					}
				}

				new_content = insertContent({
					line: end_of_plugins.line,
					character: end_of_plugins.character,
					content: opts.config,
					insert_content: `${!has_found_comma ? "," : ""}${
						opts.pluginFunctionName
					}(${opts.pluginContents})`,
				});
			}

			// console.log(`new_content`, new_content);
			try {
				new_content = await format(new_content);
			} catch (error) {
				console.error(error);
				throw new Error(
					`Failed to generate new auth config during plugin addition phase.`,
				);
			}
			return { code: await new_content, dependencies: [], envs: [] };
		},
		add_import: async (opts: {
			imports: Import[];
			config: string;
		}): Promise<{ code: string; dependencies: string[]; envs: string[] }> => {
			let importString = "";
			for (const import_ of opts.imports) {
				if (Array.isArray(import_.variables)) {
					importString += `import { ${import_.variables
						.map(
							(x) =>
								`${x.asType ? "type " : ""}${x.name}${
									x.as ? ` as ${x.as}` : ""
								}`,
						)
						.join(", ")} } from "${import_.path}";\n`;
				} else {
					importString += `import ${import_.variables.asType ? "type " : ""}${
						import_.variables.name
					}${import_.variables.as ? ` as ${import_.variables.as}` : ""} from "${
						import_.path
					}";\n`;
				}
			}
			try {
				let new_content = format(importString + opts.config);
				return { code: await new_content, dependencies: [], envs: [] };
			} catch (error) {
				console.error(error);
				throw new Error(
					`Failed to generate new auth config during import addition phase.`,
				);
			}
		},
		add_database: async (opts: {
			database: SupportedDatabases;
			config: string;
		}): Promise<{ code: string; dependencies: string[]; envs: string[] }> => {
			const required_envs: string[] = [];
			const required_deps: string[] = [];
			let database_code_str: string = "";

			async function add_db({
				db_code,
				dependencies,
				envs,
				imports,
				code_before_betterAuth,
			}: {
				imports: Import[];
				db_code: string;
				envs: string[];
				dependencies: string[];
				/**
				 * Any code you want to put before the betterAuth export
				 */
				code_before_betterAuth?: string;
			}) {
				if (code_before_betterAuth) {
					let start_of_betterauth = getGroupInfo(
						opts.config,
						common_indexs.START_OF_BETTERAUTH,
						{},
					);
					if (!start_of_betterauth) {
						throw new Error("Couldn't find start of betterAuth() function.");
					}
					opts.config = insertContent({
						line: start_of_betterauth.line - 1,
						character: 0,
						content: opts.config,
						insert_content: `\n${code_before_betterAuth}\n`,
					});
				}

				const code_gen = await config_generation.add_import({
					config: opts.config,
					imports: imports,
				});
				opts.config = code_gen.code;
				database_code_str = db_code;
				required_envs.push(...envs, ...code_gen.envs);
				required_deps.push(...dependencies, ...code_gen.dependencies);
			}

			if (opts.database === "sqlite") {
				await add_db({
					db_code: `new Database(process.env.DATABASE_URL || "database.sqlite")`,
					dependencies: ["better-sqlite3"],
					envs: ["DATABASE_URL"],
					imports: [
						{
							path: "better-sqlite3",
							variables: {
								asType: false,
								name: "Database",
							},
						},
					],
				});
			} else if (opts.database === "postgres") {
				await add_db({
					db_code: `new Pool({\nconnectionString: process.env.DATABASE_URL || "postgresql://postgres:password@localhost:5432/database"\n})`,
					dependencies: ["pg"],
					envs: ["DATABASE_URL"],
					imports: [
						{
							path: "pg",
							variables: [
								{
									asType: false,
									name: "Pool",
								},
							],
						},
					],
				});
			} else if (opts.database === "mysql") {
				await add_db({
					db_code: `createPool(process.env.DATABASE_URL!)`,
					dependencies: ["mysql2"],
					envs: ["DATABASE_URL"],
					imports: [
						{
							path: "mysql2/promise",
							variables: [
								{
									asType: false,
									name: "createPool",
								},
							],
						},
					],
				});
			} else if (opts.database === "mssql") {
				const dialectCode = `new MssqlDialect({
						tarn: {
							...Tarn,
							options: {
							min: 0,
							max: 10,
							},
						},
						tedious: {
							...Tedious,
							connectionFactory: () => new Tedious.Connection({
							authentication: {
								options: {
								password: 'password',
								userName: 'username',
								},
								type: 'default',
							},
							options: {
								database: 'some_db',
								port: 1433,
								trustServerCertificate: true,
							},
							server: 'localhost',
							}),
						},
					})`;
				await add_db({
					code_before_betterAuth: dialectCode,
					db_code: `dialect`,
					dependencies: ["tedious", "tarn", "kysely"],
					envs: ["DATABASE_URL"],
					imports: [
						{
							path: "tedious",
							variables: {
								name: "*",
								as: "Tedious",
							},
						},
						{
							path: "tarn",
							variables: {
								name: "*",
								as: "Tarn",
							},
						},
						{
							path: "kysely",
							variables: [
								{
									name: "MssqlDialect",
								},
							],
						},
					],
				});
			} else if (
				opts.database === "drizzle:mysql" ||
				opts.database === "drizzle:sqlite" ||
				opts.database === "drizzle:pg"
			) {
				await add_db({
					db_code: `drizzleAdapter(db, {\nprovider: "${opts.database.replace(
						"drizzle:",
						"",
					)}",\n})`,
					dependencies: [""],
					envs: [],
					imports: [
						{
							path: "better-auth/adapters/drizzle",
							variables: [
								{
									name: "drizzleAdapter",
								},
							],
						},
						{
							path: "./database.ts",
							variables: [
								{
									name: "db",
								},
							],
						},
					],
				});
			} else if (
				opts.database === "prisma:mysql" ||
				opts.database === "prisma:sqlite" ||
				opts.database === "prisma:postgresql"
			) {
				await add_db({
					db_code: `prismaAdapter(client, {\nprovider: "${opts.database.replace(
						"prisma:",
						"",
					)}",\n})`,
					dependencies: [`@prisma/client`],
					envs: [],
					code_before_betterAuth: "const client = new PrismaClient();",
					imports: [
						{
							path: "better-auth/adapters/prisma",
							variables: [
								{
									name: "prismaAdapter",
								},
							],
						},
						{
							path: "@prisma/client",
							variables: [
								{
									name: "PrismaClient",
								},
							],
						},
					],
				});
			} else if (opts.database === "mongodb") {
				await add_db({
					db_code: `mongodbAdapter(db)`,
					dependencies: ["mongodb"],
					envs: [`DATABASE_URL`],
					code_before_betterAuth: [
						`const client = new MongoClient(process.env.DATABASE_URL || "mongodb://localhost:27017/database");`,
						`const db = client.db();`,
					].join("\n"),
					imports: [
						{
							path: "better-auth/adapters/mongo",
							variables: [
								{
									name: "mongodbAdapter",
								},
							],
						},
						{
							path: "mongodb",
							variables: [
								{
									name: "MongoClient",
								},
							],
						},
					],
				});
			}

			let start_of_betterauth = getGroupInfo(
				opts.config,
				common_indexs.START_OF_BETTERAUTH,
				{},
			);
			if (!start_of_betterauth) {
				throw new Error("Couldn't find start of betterAuth() function.");
			}
			let new_content: string;
			new_content = insertContent({
				line: start_of_betterauth.line,
				character: start_of_betterauth.character,
				content: opts.config,
				insert_content: `database: ${database_code_str},`,
			});

			try {
				new_content = await format(new_content);
				return {
					code: new_content,
					dependencies: required_deps,
					envs: required_envs,
				};
			} catch (error) {
				console.error(error);
				throw new Error(
					`Failed to generate new auth config during database addition phase.`,
				);
			}
		},
	};

	let new_user_config: string = await format(current_user_config);
	let total_dependencies: string[] = [];
	let total_envs: string[] = [];

	if (plugins.length !== 0) {
		const imports: {
			path: string;
			variables: {
				asType: boolean;
				name: string;
			}[];
		}[] = [];
		for await (const plugin of plugins) {
			const existingIndex = imports.findIndex((x) => x.path === plugin.path);
			if (existingIndex !== -1) {
				imports[existingIndex]!.variables.push({
					name: plugin.name,
					asType: false,
				});
			} else {
				imports.push({
					path: plugin.path,
					variables: [
						{
							name: plugin.name,
							asType: false,
						},
					],
				});
			}
		}
		if (imports.length !== 0) {
			const { code, envs, dependencies } = await config_generation.add_import({
				config: new_user_config,
				imports: imports,
			});
			total_dependencies.push(...dependencies);
			total_envs.push(...envs);
			new_user_config = code;
		}
	}

	for await (const plugin of plugins) {
		try {
			// console.log(`--------- UPDATE: ${plugin} ---------`);
			let pluginContents = "";
			if (plugin.id === "magic-link") {
				pluginContents = `{\nsendMagicLink({ email, token, url }, request) {\n// Send email with magic link\n},\n}`;
			} else if (plugin.id === "email-otp") {
				pluginContents = `{\nasync sendVerificationOTP({ email, otp, type }, request) {\n// Send email with OTP\n},\n}`;
			} else if (plugin.id === "generic-oauth") {
				pluginContents = `{\nconfig: [],\n}`;
			} else if (plugin.id === "oidc") {
				pluginContents = `{\nloginPage: "/sign-in",\n}`;
			}
			const { code, dependencies, envs } = await config_generation.add_plugin({
				config: new_user_config,
				direction_in_plugins_array:
					plugin.id === "next-cookies" ? "append" : "prepend",
				pluginFunctionName: plugin.name,
				pluginContents: pluginContents,
			});
			new_user_config = code;
			total_envs.push(...envs);
			total_dependencies.push(...dependencies);
			// console.log(new_user_config);
			// console.log(`--------- UPDATE END ---------`);
		} catch (error: any) {
			spinner.stop(
				`Something went wrong while generating/updating your new auth config file.`,
				1,
			);
			logger.error(error.message);
			process.exit(1);
		}
	}

	if (database) {
		try {
			const { code, dependencies, envs } = await config_generation.add_database(
				{
					config: new_user_config,
					database: database,
				},
			);
			new_user_config = code;
			total_dependencies.push(...dependencies);
			total_envs.push(...envs);
		} catch (error: any) {
			spinner.stop(
				`Something went wrong while generating/updating your new auth config file.`,
				1,
			);
			logger.error(error.message);
			process.exit(1);
		}
	}

	return {
		generatedCode: new_user_config,
		dependencies: total_dependencies,
		envs: total_envs,
	};
}

function findClosingBracket(
	content: string,
	startIndex: number,
	openingBracket: string,
	closingBracket: string,
): number | null {
	let stack = 0;
	let inString = false; // To track if we are inside a string
	let quoteChar: string | null = null; // To track the type of quote

	for (let i = startIndex; i < content.length; i++) {
		const char = content[i];

		// Check if we are entering or exiting a string
		if (char === '"' || char === "'" || char === "`") {
			if (!inString) {
				inString = true;
				quoteChar = char; // Set the quote character
			} else if (char === quoteChar) {
				inString = false; // Exiting the string
				quoteChar = null; // Reset the quote character
			}
			continue; // Skip processing for characters inside strings
		}

		// If we are not inside a string, check for brackets
		if (!inString) {
			if (char === openingBracket) {
				// console.log(`Found opening bracket:`, stack);
				stack++;
			} else if (char === closingBracket) {
				// console.log(`Found closing bracket:`, stack, closingBracket, i);
				if (stack === 0) {
					return i; // Found the matching closing bracket
				}
				stack--;
			}
		}
	}

	return null; // No matching closing bracket found
}

/**
 * Helper function to insert content at a specific line and character position in a string.
 */
function insertContent(params: {
	line: number;
	character: number;
	content: string;
	insert_content: string;
}): string {
	const { line, character, content, insert_content } = params;

	// Split the content into lines
	const lines = content.split("\n");

	// Check if the specified line number is valid
	if (line < 1 || line > lines.length) {
		throw new Error("Invalid line number");
	}

	// Adjust for zero-based index
	const targetLineIndex = line - 1;

	// Check if the specified character index is valid
	if (character < 0 || character > lines[targetLineIndex]!.length) {
		throw new Error("Invalid character index");
	}

	// Insert the new content at the specified position
	const targetLine = lines[targetLineIndex]!;
	const updatedLine =
		targetLine.slice(0, character) +
		insert_content +
		targetLine.slice(character);
	lines[targetLineIndex] = updatedLine;

	// Join the lines back into a single string
	return lines.join("\n");
}

/**
 * Helper function to get the line and character position of a specific group in a string using a CommonIndexConfig.
 */
function getGroupInfo<AdditionalFields>(
	content: string,
	commonIndexConfig: CommonIndexConfig<AdditionalFields>,
	additionalFields: AdditionalFields,
): {
	line: number;
	character: number;
	index: number;
} | null {
	if (commonIndexConfig.type === "regex") {
		const { regex, getIndex } = commonIndexConfig;
		const match = regex.exec(content);
		if (match) {
			const matchIndex = match.index;
			const groupIndex = getIndex({ matchIndex, match, additionalFields });
			if (groupIndex === null) return null;
			const position = getPosition(content, groupIndex);
			return {
				line: position.line,
				character: position.character,
				index: groupIndex,
			};
		}

		return null; // Return null if no match is found
	} else {
		const { getIndex } = commonIndexConfig;
		const index = getIndex({ content, additionalFields });
		if (index === null) return null;

		const { line, character } = getPosition(content, index);
		return {
			line: line,
			character: character,
			index,
		};
	}
}

/**
 * Helper function to calculate line and character position based on an index
 */
const getPosition = (str: string, index: number) => {
	const lines = str.slice(0, index).split("\n");
	return {
		line: lines.length,
		character: lines[lines.length - 1]!.length,
	};
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/generators/drizzle.ts
```typescript
import { getAuthTables, type FieldAttribute } from "better-auth/db";
import { existsSync } from "fs";
import type { SchemaGenerator } from "./types";

export function convertToSnakeCase(str: string) {
	return str.replace(/[A-Z]/g, (letter) => `_${letter.toLowerCase()}`);
}

export const generateDrizzleSchema: SchemaGenerator = async ({
	options,
	file,
	adapter,
}) => {
	const tables = getAuthTables(options);
	const filePath = file || "./auth-schema.ts";
	const databaseType = adapter.options?.provider;
	const usePlural = adapter.options?.usePlural;
	const timestampAndBoolean =
		databaseType !== "sqlite" ? "timestamp, boolean" : "";
	const int = databaseType === "mysql" ? "int" : "integer";
	const hasBigint = Object.values(tables).some((table) =>
		Object.values(table.fields).some((field) => field.bigint),
	);
	const bigint = databaseType !== "sqlite" ? "bigint" : "";
	const text = databaseType === "mysql" ? "varchar, text" : "text";
	let code = `import { ${databaseType}Table, ${text}, ${int}${
		hasBigint ? `, ${bigint}` : ""
	}, ${timestampAndBoolean} } from "drizzle-orm/${databaseType}-core";
			`;

	const fileExist = existsSync(filePath);

	for (const table in tables) {
		const modelName = usePlural
			? `${tables[table].modelName}s`
			: tables[table].modelName;
		const fields = tables[table].fields;
		function getType(name: string, field: FieldAttribute) {
			name = convertToSnakeCase(name);
			const type = field.type;
			const typeMap = {
				string: {
					sqlite: `text('${name}')`,
					pg: `text('${name}')`,
					mysql: field.unique
						? `varchar('${name}', { length: 255 })`
						: field.references
							? `varchar('${name}', { length: 36 })`
							: `text('${name}')`,
				},
				boolean: {
					sqlite: `integer('${name}', { mode: 'boolean' })`,
					pg: `boolean('${name}')`,
					mysql: `boolean('${name}')`,
				},
				number: {
					sqlite: `integer('${name}')`,
					pg: field.bigint
						? `bigint('${name}', { mode: 'number' })`
						: `integer('${name}')`,
					mysql: field.bigint
						? `bigint('${name}', { mode: 'number' })`
						: `int('${name}')`,
				},
				date: {
					sqlite: `integer('${name}', { mode: 'timestamp' })`,
					pg: `timestamp('${name}')`,
					mysql: `timestamp('${name}')`,
				},
			} as const;
			return typeMap[type as "boolean"][(databaseType as "sqlite") || "sqlite"];
		}
		const id =
			databaseType === "mysql"
				? `varchar("id", { length: 36 }).primaryKey()`
				: `text("id").primaryKey()`;
		const schema = `export const ${modelName} = ${databaseType}Table("${convertToSnakeCase(
			modelName,
		)}", {
					id: ${id},
					${Object.keys(fields)
						.map((field) => {
							const attr = fields[field];
							return `${field}: ${getType(field, attr)}${
								attr.required ? ".notNull()" : ""
							}${attr.unique ? ".unique()" : ""}${
								attr.references
									? `.references(()=> ${
											usePlural
												? `${attr.references.model}s`
												: attr.references.model
										}.${attr.references.field}, { onDelete: 'cascade' })`
									: ""
							}`;
						})
						.join(",\n ")}
				});`;
		code += `\n${schema}\n`;
	}

	return {
		code: code,
		fileName: filePath,
		overwrite: fileExist,
	};
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/generators/index.ts
```typescript
import { logger, type Adapter, type BetterAuthOptions } from "better-auth";
import { generateDrizzleSchema } from "./drizzle";
import { generatePrismaSchema } from "./prisma";
import { generateMigrations } from "./kysely";

export const adapters = {
	prisma: generatePrismaSchema,
	drizzle: generateDrizzleSchema,
	kysely: generateMigrations,
};

export const getGenerator = (opts: {
	adapter: Adapter;
	file?: string;
	options: BetterAuthOptions;
}) => {
	const adapter = opts.adapter;
	const generator =
		adapter.id in adapters
			? adapters[adapter.id as keyof typeof adapters]
			: null;
	if (!generator) {
		logger.error(`${adapter.id} is not supported.`);
		process.exit(1);
	}
	return generator(opts);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/generators/kysely.ts
```typescript
import { getMigrations } from "better-auth/db";
import type { SchemaGenerator } from "./types";

export const generateMigrations: SchemaGenerator = async ({
	options,
	file,
}) => {
	const { compileMigrations } = await getMigrations(options);
	const migrations = await compileMigrations();
	return {
		code: migrations,
		fileName:
			file ||
			`./better-auth_migrations/${new Date()
				.toISOString()
				.replace(/:/g, "-")}.sql`,
	};
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/generators/prisma.ts
```typescript
import { getAuthTables, type FieldType } from "better-auth/db";
import { produceSchema } from "@mrleebo/prisma-ast";
import { existsSync } from "fs";
import path from "path";
import fs from "fs/promises";
import { capitalizeFirstLetter } from "better-auth";
import type { SchemaGenerator } from "./types";

export const generatePrismaSchema: SchemaGenerator = async ({
	adapter,
	options,
	file,
}) => {
	const provider = adapter.options?.provider || "postgresql";
	const tables = getAuthTables(options);
	const filePath = file || "./prisma/schema.prisma";
	const schemaPrismaExist = existsSync(path.join(process.cwd(), filePath));
	let schemaPrisma = "";
	if (schemaPrismaExist) {
		schemaPrisma = await fs.readFile(
			path.join(process.cwd(), filePath),
			"utf-8",
		);
	} else {
		schemaPrisma = getNewPrisma(provider);
	}

	// Create a map to store many-to-many relationships
	const manyToManyRelations = new Map();

	// First pass: identify many-to-many relationships
	for (const table in tables) {
		const fields = tables[table]?.fields;
		for (const field in fields) {
			const attr = fields[field]!;
			if (attr.references) {
				const referencedModel = capitalizeFirstLetter(attr.references.model);
				if (!manyToManyRelations.has(referencedModel)) {
					manyToManyRelations.set(referencedModel, new Set());
				}
				manyToManyRelations
					.get(referencedModel)
					.add(capitalizeFirstLetter(table));
			}
		}
	}

	const schema = produceSchema(schemaPrisma, (builder) => {
		for (const table in tables) {
			const fields = tables[table]?.fields;
			const originalTable = tables[table]?.modelName;
			const modelName = capitalizeFirstLetter(originalTable || "");

			function getType(
				type: FieldType,
				isOptional: boolean,
				isBigint: boolean,
			) {
				if (type === "string") {
					return isOptional ? "String?" : "String";
				}
				if (type === "number" && isBigint) {
					return isOptional ? "BigInt?" : "BigInt";
				}
				if (type === "number") {
					return isOptional ? "Int?" : "Int";
				}
				if (type === "boolean") {
					return isOptional ? "Boolean?" : "Boolean";
				}
				if (type === "date") {
					return isOptional ? "DateTime?" : "DateTime";
				}
				if (type === "string[]") {
					return isOptional ? "String[]" : "String[]";
				}
				if (type === "number[]") {
					return isOptional ? "Int[]" : "Int[]";
				}
			}

			const prismaModel = builder.findByType("model", {
				name: modelName,
			});

			if (!prismaModel) {
				if (provider === "mongodb") {
					builder
						.model(modelName)
						.field("id", "String")
						.attribute("id")
						.attribute(`map("_id")`);
				} else {
					builder.model(modelName).field("id", "String").attribute("id");
				}
			}

			for (const field in fields) {
				const attr = fields[field]!;

				if (prismaModel) {
					const isAlreadyExist = builder.findByType("field", {
						name: field,
						within: prismaModel.properties,
					});
					if (isAlreadyExist) {
						continue;
					}
				}

				builder
					.model(modelName)
					.field(
						field,
						getType(attr.type, !attr?.required, attr?.bigint || false),
					);
				if (attr.unique) {
					builder.model(modelName).blockAttribute(`unique([${field}])`);
				}
				if (attr.references) {
					builder
						.model(modelName)
						.field(
							`${attr.references.model.toLowerCase()}`,
							capitalizeFirstLetter(attr.references.model),
						)
						.attribute(
							`relation(fields: [${field}], references: [${attr.references.field}], onDelete: Cascade)`,
						);
				}
				if (
					!attr.unique &&
					!attr.references &&
					provider === "mysql" &&
					attr.type === "string"
				) {
					builder.model(modelName).field(field).attribute("db.Text");
				}
			}

			// Add many-to-many fields
			if (manyToManyRelations.has(modelName)) {
				for (const relatedModel of manyToManyRelations.get(modelName)) {
					const fieldName = `${relatedModel.toLowerCase()}s`;
					const existingField = builder.findByType("field", {
						name: fieldName,
						within: prismaModel?.properties,
					});
					if (!existingField) {
						builder.model(modelName).field(fieldName, `${relatedModel}[]`);
					}
				}
			}

			const hasAttribute = builder.findByType("attribute", {
				name: "map",
				within: prismaModel?.properties,
			});
			if (originalTable !== modelName && !hasAttribute) {
				builder.model(modelName).blockAttribute("map", originalTable);
			}
		}
	});

	return {
		code: schema.trim() === schemaPrisma.trim() ? "" : schema,
		fileName: filePath,
	};
};

const getNewPrisma = (provider: string) => `generator client {
    provider = "prisma-client-js"
  }
  
  datasource db {
    provider = "${provider}"
    url      = ${
			provider === "sqlite" ? `"file:./dev.db"` : `env("DATABASE_URL")`
		}
  }`;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/cli/src/generators/types.ts
```typescript
import type { Adapter, BetterAuthOptions } from "better-auth";

export interface SchemaGenerator {
	(opts: {
		file?: string;
		adapter: Adapter;
		options: BetterAuthOptions;
	}): Promise<{
		code?: string;
		fileName: string;
		overwrite?: boolean;
		append?: boolean;
	}>;
}

```
