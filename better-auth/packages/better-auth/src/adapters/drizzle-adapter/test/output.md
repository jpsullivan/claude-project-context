/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/drizzle-adapter/test/adapter.drizzle.mysql.test.ts
```typescript
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import * as schema from "./schema.mysql";
import { runAdapterTest } from "../../test";
import { drizzleAdapter } from "..";
import { getMigrations } from "../../../db/get-migration";
import { drizzle } from "drizzle-orm/mysql2";
import type { BetterAuthOptions } from "../../../types";
import { createPool, type Pool } from "mysql2/promise";
import { Kysely, MysqlDialect } from "kysely";
import { betterAuth } from "../../../auth";

const TEST_DB_MYSQL_URL = "mysql://user:password@localhost:3306/better_auth";

const createTestPool = () => createPool(TEST_DB_MYSQL_URL);

const createKyselyInstance = (pool: any) =>
	new Kysely({
		dialect: new MysqlDialect({ pool }),
	});

const cleanupDatabase = async (mysql: Pool) => {
	await mysql.query("DROP DATABASE IF EXISTS better_auth");
	await mysql.query("CREATE DATABASE better_auth");
	await mysql.end();
};

const createTestOptions = (pool: any): BetterAuthOptions => ({
	database: pool,
	user: {
		fields: { email: "email_address" },
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
});

describe("Drizzle Adapter Tests (MySQL)", async () => {
	let pool: any;
	let mysql: Kysely<any>;
	let opts: BetterAuthOptions;

	pool = createTestPool();
	mysql = createKyselyInstance(pool);
	opts = createTestOptions(pool);
	const { runMigrations } = await getMigrations(opts);
	await runMigrations();

	afterAll(async () => {
		await cleanupDatabase(pool);
	});

	const db = drizzle({
		client: pool,
	});
	const adapter = drizzleAdapter(db, { provider: "mysql", schema });

	await runAdapterTest({
		getAdapter: async (customOptions = {}) => {
			return adapter({ ...opts, ...customOptions });
		},
	});
});

describe("Authentication Flow Tests (MySQL)", async () => {
	const pool = createTestPool();
	let mysql: Kysely<any>;
	const opts = createTestOptions(pool);
	const testUser = {
		email: "test-email@email.com",
		password: "password",
		name: "Test Name",
	};

	beforeAll(async () => {
		mysql = createKyselyInstance(pool);
		const { runMigrations } = await getMigrations(opts);
		await runMigrations();
	});

	const auth = betterAuth({
		...opts,
		database: drizzleAdapter(drizzle({ client: pool }), {
			provider: "mysql",
			schema,
		}),
		emailAndPassword: {
			enabled: true,
		},
	});

	afterAll(async () => {
		await cleanupDatabase(pool);
	});

	it("should successfully sign up a new user", async () => {
		const user = await auth.api.signUpEmail({ body: testUser });
		expect(user).toBeDefined();
		expect(user.user.id).toBeDefined();
	});

	it("should successfully sign in an existing user", async () => {
		const user = await auth.api.signInEmail({ body: testUser });
		expect(user.user).toBeDefined();
		expect(user.user.id).toBeDefined();
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/drizzle-adapter/test/adapter.drizzle.test.ts
```typescript
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import * as schema from "./schema";
import { runAdapterTest } from "../../test";
import { drizzleAdapter } from "..";
import { getMigrations } from "../../../db/get-migration";
import { drizzle } from "drizzle-orm/node-postgres";
import type { BetterAuthOptions } from "../../../types";
import { Pool } from "pg";
import { Kysely, PostgresDialect, sql } from "kysely";
import { betterAuth } from "../../../auth";

const TEST_DB_URL = "postgres://user:password@localhost:5432/better_auth";

const createTestPool = () => new Pool({ connectionString: TEST_DB_URL });

const createKyselyInstance = (pool: Pool) =>
	new Kysely({
		dialect: new PostgresDialect({ pool }),
	});

const cleanupDatabase = async (postgres: Kysely<any>) => {
	await sql`DROP SCHEMA public CASCADE; CREATE SCHEMA public;`.execute(
		postgres,
	);
	await postgres.destroy();
};

const createTestOptions = (pg: Pool): BetterAuthOptions => ({
	database: pg,
	user: {
		fields: { email: "email_address" },
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
});

describe("Drizzle Adapter Tests", async () => {
	let pg: Pool;
	let postgres: Kysely<any>;
	let opts: BetterAuthOptions;
	pg = createTestPool();
	postgres = createKyselyInstance(pg);
	opts = createTestOptions(pg);
	const { runMigrations } = await getMigrations(opts);
	await runMigrations();

	afterAll(async () => {
		await cleanupDatabase(postgres);
	});
	const db = drizzle(pg);
	const adapter = drizzleAdapter(db, { provider: "pg", schema });

	await runAdapterTest({
		getAdapter: async (customOptions = {}) => {
			return adapter({ ...opts, ...customOptions });
		},
	});
});

describe("Authentication Flow Tests", async () => {
	const pg = createTestPool();
	let postgres: Kysely<any>;
	const opts = createTestOptions(pg);
	const testUser = {
		email: "test-email@email.com",
		password: "password",
		name: "Test Name",
	};
	beforeAll(async () => {
		postgres = createKyselyInstance(pg);

		const { runMigrations } = await getMigrations(opts);
		await runMigrations();
	});

	const auth = betterAuth({
		...opts,
		database: drizzleAdapter(drizzle(pg), { provider: "pg", schema }),
		emailAndPassword: {
			enabled: true,
		},
	});

	afterAll(async () => {
		await cleanupDatabase(postgres);
	});

	it("should successfully sign up a new user", async () => {
		const user = await auth.api.signUpEmail({ body: testUser });
		expect(user).toBeDefined();
	});

	it("should successfully sign in an existing user", async () => {
		const user = await auth.api.signInEmail({ body: testUser });
		expect(user.user).toBeDefined();
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/drizzle-adapter/test/schema.mysql.ts
```typescript
import { boolean, text, varchar, datetime } from "drizzle-orm/mysql-core";
import { mysqlTable } from "drizzle-orm/mysql-core";

export const user = mysqlTable("user", {
	id: varchar("id", { length: 255 }).primaryKey(),
	name: varchar("name", { length: 255 }).notNull(),
	email_address: varchar("email_address", { length: 255 }).notNull().unique(),
	emailVerified: boolean("emailVerified").notNull(),
	test: text("test").notNull(),
	image: text("image"),
	createdAt: datetime("createdAt", { mode: "date" }).notNull(), // Use `date` mode
	updatedAt: datetime("updatedAt", { mode: "date" }).notNull(), // Use `date` mode
});

export const sessions = mysqlTable("sessions", {
	id: varchar("id", { length: 255 }).primaryKey(),
	expiresAt: datetime("expiresAt", { mode: "date" }).notNull(), // Use `date` mode
	ipAddress: varchar("ipAddress", { length: 255 }),
	userAgent: varchar("userAgent", { length: 255 }),
	token: varchar("token", { length: 255 }).notNull(),
	createdAt: datetime("createdAt", { mode: "date" }).notNull(), // Use `date` mode
	updatedAt: datetime("updatedAt", { mode: "date" }).notNull(), // Use `date` mode
	userId: varchar("userId", { length: 255 })
		.notNull()
		.references(() => user.id),
});

export const account = mysqlTable("account", {
	id: varchar("id", { length: 255 }).primaryKey(),
	accountId: varchar("accountId", { length: 255 }).notNull(),
	providerId: varchar("providerId", { length: 255 }).notNull(),
	userId: varchar("userId", { length: 255 })
		.notNull()
		.references(() => user.id),
	accessToken: text("accessToken"),
	createdAt: datetime("createdAt", { mode: "date" }).notNull(), // Use `date` mode
	updatedAt: datetime("updatedAt", { mode: "date" }).notNull(), // Use `date` mode
	refreshToken: text("refreshToken"),
	idToken: text("idToken"),
	accessTokenExpiresAt: datetime("accessTokenExpiresAt", { mode: "date" }),
	refreshTokenExpiresAt: datetime("refreshTokenExpiresAt", { mode: "date" }),
	scope: text("scope"),
	password: text("password"),
});

export const verification = mysqlTable("verification", {
	id: varchar("id", { length: 255 }).primaryKey(),
	identifier: varchar("identifier", { length: 255 }).notNull(),
	value: varchar("value", { length: 255 }).notNull(),
	expiresAt: datetime("expiresAt", { mode: "date" }).notNull(), // Use `date` mode
	createdAt: datetime("createdAt", { mode: "date" }).notNull(), // Use `date` mode
	updatedAt: datetime("updatedAt", { mode: "date" }).notNull(), // Use `date` mode
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/drizzle-adapter/test/schema.ts
```typescript
/*

This file is used explicitly for testing purposes.

It's not used in the production code.

For information on how to use the drizzle-adapter, please refer to the documentation.

https://www.better-auth.com/docs/concepts/database#drizzle-adapter

*/
import { boolean, text, timestamp } from "drizzle-orm/pg-core";
import { pgTable } from "drizzle-orm/pg-core";

export const user = pgTable("user", {
	id: text("id").primaryKey(),
	name: text("name").notNull(),
	email_address: text("email_address").notNull().unique(),
	emailVerified: boolean("emailVerified").notNull(),
	test: text("test").notNull(),
	image: text("image"),
	createdAt: timestamp("createdAt").notNull(),
	updatedAt: timestamp("updatedAt").notNull(),
});

export const sessions = pgTable("sessions", {
	id: text("id").primaryKey(),
	expiresAt: timestamp("expiresAt").notNull(),
	ipAddress: text("ipAddress"),
	userAgent: text("userAgent"),
	token: text("token").notNull(),
	createdAt: timestamp("createdAt").notNull(),
	updatedAt: timestamp("updatedAt").notNull(),
	userId: text("userId")
		.notNull()
		.references(() => user.id),
});

export const account = pgTable("account", {
	id: text("id").primaryKey(),
	accountId: text("accountId").notNull(),
	providerId: text("providerId").notNull(),
	userId: text("userId")
		.notNull()
		.references(() => user.id),
	accessToken: text("accessToken"),
	createdAt: timestamp("createdAt").notNull(),
	updatedAt: timestamp("updatedAt").notNull(),
	refreshToken: text("refreshToken"),
	idToken: text("idToken"),
	accessTokenExpiresAt: timestamp("accessTokenExpiresAt"),
	refreshTokenExpiresAt: timestamp("refreshTokenExpiresAt"),
	scope: text("scope"),
	password: text("password"),
});

export const verification = pgTable("verification", {
	id: text("id").primaryKey(),
	identifier: text("identifier").notNull(),
	value: text("value").notNull(),
	expiresAt: timestamp("expiresAt").notNull(),
	createdAt: timestamp("createdAt").notNull(),
	updatedAt: timestamp("updatedAt").notNull(),
});

```
