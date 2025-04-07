/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/test.ts
```typescript
import { expect, test } from "vitest";
import type { Adapter, BetterAuthOptions, User } from "../types";
import { generateId } from "../utils";

interface AdapterTestOptions {
	getAdapter: (
		customOptions?: Omit<BetterAuthOptions, "database">,
	) => Promise<Adapter>;
	skipGenerateIdTest?: boolean;
}

export async function runAdapterTest(opts: AdapterTestOptions) {
	const adapter = await opts.getAdapter();
	const user = {
		id: "1",
		name: "user",
		email: "user@email.com",
		emailVerified: true,
		createdAt: new Date(),
		updatedAt: new Date(),
	};

	test("create model", async () => {
		const res = await adapter.create({
			model: "user",
			data: user,
		});
		expect({
			name: res.name,
			email: res.email,
		}).toEqual({
			name: user.name,
			email: user.email,
		});
		user.id = res.id;
	});

	test("find model", async () => {
		const res = await adapter.findOne<User>({
			model: "user",
			where: [
				{
					field: "id",
					value: user.id,
				},
			],
		});
		expect({
			name: res?.name,
			email: res?.email,
		}).toEqual({
			name: user.name,
			email: user.email,
		});
	});

	test("find model without id", async () => {
		const res = await adapter.findOne<User>({
			model: "user",
			where: [
				{
					field: "email",
					value: user.email,
				},
			],
		});
		expect({
			name: res?.name,
			email: res?.email,
		}).toEqual({
			name: user.name,
			email: user.email,
		});
	});

	test("find model with select", async () => {
		const res = await adapter.findOne({
			model: "user",
			where: [
				{
					field: "id",
					value: user.id,
				},
			],
			select: ["email"],
		});
		expect(res).toEqual({ email: user.email });
	});

	test("update model", async () => {
		const newEmail = "updated@email.com";

		const res = await adapter.update<User>({
			model: "user",
			where: [
				{
					field: "id",
					value: user.id,
				},
			],
			update: {
				email: newEmail,
			},
		});
		expect(res).toMatchObject({
			email: newEmail,
			name: user.name,
		});
	});

	test("should find many", async () => {
		const res = await adapter.findMany({
			model: "user",
		});
		expect(res.length).toBe(1);
	});

	test("should find many with where", async () => {
		const user = await adapter.create<User>({
			model: "user",
			data: {
				id: "2",
				name: "user2",
				email: "test@email.com",
				emailVerified: true,
				createdAt: new Date(),
				updatedAt: new Date(),
			},
		});
		const res = await adapter.findMany({
			model: "user",
			where: [
				{
					field: "id",
					value: user.id,
				},
			],
		});
		expect(res.length).toBe(1);
	});

	test("should find many with operators", async () => {
		const newUser = await adapter.create<User>({
			model: "user",
			data: {
				id: "3",
				name: "user",
				email: "test-email2@email.com",
				emailVerified: true,
				createdAt: new Date(),
				updatedAt: new Date(),
			},
		});
		const res = await adapter.findMany({
			model: "user",
			where: [
				{
					field: "id",
					operator: "in",
					value: [user.id, newUser.id],
				},
			],
		});
		expect(res.length).toBe(2);
	});

	test("should work with reference fields", async () => {
		let token = null;
		const user = await adapter.create<{ id: string } & Record<string, any>>({
			model: "user",
			data: {
				id: "4",
				name: "user",
				email: "my-email@email.com",
				emailVerified: true,
				createdAt: new Date(),
				updatedAt: new Date(),
			},
		});
		const session = await adapter.create({
			model: "session",
			data: {
				id: "1",
				token: generateId(),
				createdAt: new Date(),
				updatedAt: new Date(),
				userId: user.id,
				expiresAt: new Date(),
			},
		});
		token = session.token;
		const res = await adapter.findOne({
			model: "session",
			where: [
				{
					field: "userId",
					value: user.id,
				},
			],
		});
		const resToken = await adapter.findOne({
			model: "session",
			where: [
				{
					field: "token",
					value: token,
				},
			],
		});
		expect(res).toMatchObject({
			userId: user.id,
		});
		expect(resToken).toMatchObject({
			userId: user.id,
		});
	});

	test("should find many with sortBy", async () => {
		await adapter.create({
			model: "user",
			data: {
				id: "5",
				name: "a",
				email: "a@email.com",
				emailVerified: true,
				createdAt: new Date(),
				updatedAt: new Date(),
			},
		});
		const res = await adapter.findMany<User>({
			model: "user",
			sortBy: {
				field: "name",
				direction: "asc",
			},
		});
		expect(res[0].name).toBe("a");

		const res2 = await adapter.findMany<User>({
			model: "user",
			sortBy: {
				field: "name",
				direction: "desc",
			},
		});

		expect(res2[res2.length - 1].name).toBe("a");
	});

	test("should find many with limit", async () => {
		const res = await adapter.findMany({
			model: "user",
			limit: 1,
		});
		expect(res.length).toBe(1);
	});

	test("should find many with offset", async () => {
		const res = await adapter.findMany({
			model: "user",
			offset: 2,
		});
		expect(res.length).toBe(3);
	});

	test("should update with multiple where", async () => {
		await adapter.updateMany({
			model: "user",
			where: [
				{
					field: "name",
					value: user.name,
				},
				{
					field: "email",
					value: user.email,
				},
			],
			update: {
				email: "updated@email.com",
			},
		});
		const updatedUser = await adapter.findOne<User>({
			model: "user",
			where: [
				{
					field: "email",
					value: "updated@email.com",
				},
			],
		});
		expect(updatedUser).toMatchObject({
			name: user.name,
			email: "updated@email.com",
		});
	});

	test("delete model", async () => {
		await adapter.delete({
			model: "user",
			where: [
				{
					field: "id",
					value: user.id,
				},
			],
		});
		const findRes = await adapter.findOne({
			model: "user",
			where: [
				{
					field: "id",
					value: user.id,
				},
			],
		});
		expect(findRes).toBeNull();
	});

	test("should delete many", async () => {
		for (const id of ["to-be-delete1", "to-be-delete2", "to-be-delete3"]) {
			await adapter.create({
				model: "user",
				data: {
					id,
					name: "to-be-deleted",
					email: `email@test-${id}.com`,
					emailVerified: true,
					createdAt: new Date(),
					updatedAt: new Date(),
				},
			});
		}
		const findResFirst = await adapter.findMany({
			model: "user",
			where: [
				{
					field: "name",
					value: "to-be-deleted",
				},
			],
		});
		expect(findResFirst.length).toBe(3);
		await adapter.deleteMany({
			model: "user",
			where: [
				{
					field: "name",
					value: "to-be-deleted",
				},
			],
		});
		const findRes = await adapter.findMany({
			model: "user",
			where: [
				{
					field: "name",
					value: "to-be-deleted",
				},
			],
		});
		expect(findRes.length).toBe(0);
	});

	test("shouldn't throw on delete record not found", async () => {
		await adapter.delete({
			model: "user",
			where: [
				{
					field: "id",
					value: "5",
				},
			],
		});
	});

	test("shouldn't throw on record not found", async () => {
		const res = await adapter.findOne({
			model: "user",
			where: [
				{
					field: "id",
					value: "5",
				},
			],
		});
		expect(res).toBeNull();
	});

	test("should find many with contains operator", async () => {
		const res = await adapter.findMany({
			model: "user",
			where: [
				{
					field: "name",
					operator: "contains",
					value: "user2",
				},
			],
		});
		expect(res.length).toBe(1);
	});

	test("should search users with startsWith", async () => {
		const res = await adapter.findMany({
			model: "user",
			where: [
				{
					field: "name",
					operator: "starts_with",
					value: "us",
				},
			],
		});
		expect(res.length).toBe(3);
	});

	test("should search users with endsWith", async () => {
		const res = await adapter.findMany({
			model: "user",
			where: [
				{
					field: "name",
					operator: "ends_with",
					value: "er2",
				},
			],
		});
		expect(res.length).toBe(1);
	});

	test.skipIf(opts.skipGenerateIdTest)(
		"should prefer generateId if provided",
		async () => {
			const customAdapter = await opts.getAdapter({
				advanced: {
					generateId: () => "mocked-id",
				},
			});

			const res = await customAdapter.create({
				model: "user",
				data: {
					id: "1",
					name: "user4",
					email: "user4@email.com",
					emailVerified: true,
					createdAt: new Date(),
					updatedAt: new Date(),
				},
			});

			expect(res.id).toBe("mocked-id");
		},
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/utils.ts
```typescript
import type { FieldAttribute } from "../db";

export function withApplyDefault(
	value: any,
	field: FieldAttribute,
	action: "create" | "update",
) {
	if (action === "update") {
		return value;
	}
	if (value === undefined || value === null) {
		if (field.defaultValue) {
			if (typeof field.defaultValue === "function") {
				return field.defaultValue();
			}
			return field.defaultValue;
		}
	}
	return value;
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/prisma-adapter/index.ts
```typescript
export * from "./prisma-adapter";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/prisma-adapter/prisma-adapter.ts
```typescript
import { getAuthTables } from "../../db";
import { BetterAuthError } from "../../error";
import type { Adapter, BetterAuthOptions, Where } from "../../types";
import { generateId } from "../../utils";
import { withApplyDefault } from "../utils";

export interface PrismaConfig {
	/**
	 * Database provider.
	 */
	provider:
		| "sqlite"
		| "cockroachdb"
		| "mysql"
		| "postgresql"
		| "sqlserver"
		| "mongodb";
}

interface PrismaClient {}

interface PrismaClientInternal {
	[model: string]: {
		create: (data: any) => Promise<any>;
		findFirst: (data: any) => Promise<any>;
		findMany: (data: any) => Promise<any>;
		update: (data: any) => Promise<any>;
		delete: (data: any) => Promise<any>;
		[key: string]: any;
	};
}

const createTransform = (config: PrismaConfig, options: BetterAuthOptions) => {
	const schema = getAuthTables(options);

	function getField(model: string, field: string) {
		if (field === "id") {
			return field;
		}
		const f = schema[model].fields[field];
		return f.fieldName || field;
	}

	function operatorToPrismaOperator(operator: string) {
		switch (operator) {
			case "starts_with":
				return "startsWith";
			case "ends_with":
				return "endsWith";
			default:
				return operator;
		}
	}

	function getModelName(model: string) {
		return schema[model].modelName;
	}

	const useDatabaseGeneratedId = options?.advanced?.generateId === false;
	return {
		transformInput(
			data: Record<string, any>,
			model: string,
			action: "create" | "update",
		) {
			const transformedData: Record<string, any> =
				useDatabaseGeneratedId || action === "update"
					? {}
					: {
							id: options.advanced?.generateId
								? options.advanced.generateId({
										model,
									})
								: data.id || generateId(),
						};
			const fields = schema[model].fields;
			for (const field in fields) {
				const value = data[field];
				if (
					value === undefined &&
					(!fields[field].defaultValue || action === "update")
				) {
					continue;
				}
				transformedData[fields[field].fieldName || field] = withApplyDefault(
					value,
					fields[field],
					action,
				);
			}
			return transformedData;
		},
		transformOutput(
			data: Record<string, any>,
			model: string,
			select: string[] = [],
		) {
			if (!data) return null;
			const transformedData: Record<string, any> =
				data.id || data._id
					? select.length === 0 || select.includes("id")
						? {
								id: data.id,
							}
						: {}
					: {};
			const tableSchema = schema[model].fields;
			for (const key in tableSchema) {
				if (select.length && !select.includes(key)) {
					continue;
				}
				const field = tableSchema[key];
				if (field) {
					transformedData[key] = data[field.fieldName || key];
				}
			}
			return transformedData as any;
		},
		convertWhereClause(model: string, where?: Where[]) {
			if (!where) return {};
			if (where.length === 1) {
				const w = where[0];
				if (!w) {
					return;
				}
				return {
					[getField(model, w.field)]:
						w.operator === "eq" || !w.operator
							? w.value
							: {
									[operatorToPrismaOperator(w.operator)]: w.value,
								},
				};
			}
			const and = where.filter((w) => w.connector === "AND" || !w.connector);
			const or = where.filter((w) => w.connector === "OR");
			const andClause = and.map((w) => {
				return {
					[getField(model, w.field)]:
						w.operator === "eq" || !w.operator
							? w.value
							: {
									[operatorToPrismaOperator(w.operator)]: w.value,
								},
				};
			});
			const orClause = or.map((w) => {
				return {
					[getField(model, w.field)]: {
						[w.operator || "eq"]: w.value,
					},
				};
			});

			return {
				...(andClause.length ? { AND: andClause } : {}),
				...(orClause.length ? { OR: orClause } : {}),
			};
		},
		convertSelect: (select?: string[], model?: string) => {
			if (!select || !model) return undefined;
			return select.reduce((prev, cur) => {
				return {
					...prev,
					[getField(model, cur)]: true,
				};
			}, {});
		},
		getModelName,
		getField,
	};
};

export const prismaAdapter =
	(prisma: PrismaClient, config: PrismaConfig) =>
	(options: BetterAuthOptions) => {
		const db = prisma as PrismaClientInternal;
		const {
			transformInput,
			transformOutput,
			convertWhereClause,
			convertSelect,
			getModelName,
			getField,
		} = createTransform(config, options);
		return {
			id: "prisma",
			async create(data) {
				const { model, data: values, select } = data;
				const transformed = transformInput(values, model, "create");
				if (!db[getModelName(model)]) {
					throw new BetterAuthError(
						`Model ${model} does not exist in the database. If you haven't generated the Prisma client, you need to run 'npx prisma generate'`,
					);
				}
				const result = await db[getModelName(model)].create({
					data: transformed,
					select: convertSelect(select, model),
				});
				return transformOutput(result, model, select);
			},
			async findOne(data) {
				const { model, where, select } = data;
				const whereClause = convertWhereClause(model, where);
				if (!db[getModelName(model)]) {
					throw new BetterAuthError(
						`Model ${model} does not exist in the database. If you haven't generated the Prisma client, you need to run 'npx prisma generate'`,
					);
				}
				const result = await db[getModelName(model)].findFirst({
					where: whereClause,
					select: convertSelect(select, model),
				});
				return transformOutput(result, model, select);
			},
			async findMany(data) {
				const { model, where, limit, offset, sortBy } = data;
				const whereClause = convertWhereClause(model, where);
				if (!db[getModelName(model)]) {
					throw new BetterAuthError(
						`Model ${model} does not exist in the database. If you haven't generated the Prisma client, you need to run 'npx prisma generate'`,
					);
				}

				const result = (await db[getModelName(model)].findMany({
					where: whereClause,
					take: limit || 100,
					skip: offset || 0,
					...(sortBy?.field
						? {
								orderBy: {
									[getField(model, sortBy.field)]:
										sortBy.direction === "desc" ? "desc" : "asc",
								},
							}
						: {}),
				})) as any[];
				return result.map((r) => transformOutput(r, model));
			},
			async count(data) {
				const { model, where } = data;
				const whereClause = convertWhereClause(model, where);
				if (!db[getModelName(model)]) {
					throw new BetterAuthError(
						`Model ${model} does not exist in the database. If you haven't generated the Prisma client, you need to run 'npx prisma generate'`,
					);
				}
				const result = await db[getModelName(model)].count({
					where: whereClause,
				});
				return result;
			},
			async update(data) {
				const { model, where, update } = data;
				if (!db[getModelName(model)]) {
					throw new BetterAuthError(
						`Model ${model} does not exist in the database. If you haven't generated the Prisma client, you need to run 'npx prisma generate'`,
					);
				}
				const whereClause = convertWhereClause(model, where);
				const transformed = transformInput(update, model, "update");
				const result = await db[getModelName(model)].update({
					where: whereClause,
					data: transformed,
				});
				return transformOutput(result, model);
			},
			async updateMany(data) {
				const { model, where, update } = data;
				const whereClause = convertWhereClause(model, where);
				const transformed = transformInput(update, model, "update");
				const result = await db[getModelName(model)].updateMany({
					where: whereClause,
					data: transformed,
				});
				return result ? (result.count as number) : 0;
			},
			async delete(data) {
				const { model, where } = data;
				const whereClause = convertWhereClause(model, where);
				try {
					await db[getModelName(model)].delete({
						where: whereClause,
					});
				} catch (e) {
					// If the record doesn't exist, we don't want to throw an error
				}
			},
			async deleteMany(data) {
				const { model, where } = data;
				const whereClause = convertWhereClause(model, where);
				const result = await db[getModelName(model)].deleteMany({
					where: whereClause,
				});
				return result ? (result.count as number) : 0;
			},
			options: config,
		} satisfies Adapter;
	};

```
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
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/mongodb-adapter/adapter.mongo-db.test.ts
```typescript
import { describe, beforeAll, it, expect } from "vitest";

import { MongoClient } from "mongodb";
import { runAdapterTest } from "../test";
import { mongodbAdapter } from ".";
import { getTestInstance } from "../../test-utils/test-instance";
describe("adapter test", async () => {
	const dbClient = async (connectionString: string, dbName: string) => {
		const client = new MongoClient(connectionString);
		await client.connect();
		const db = client.db(dbName);
		return db;
	};

	const user = "user";
	const db = await dbClient("mongodb://127.0.0.1:27017", "better-auth");
	async function clearDb() {
		await db.collection(user).deleteMany({});
		await db.collection("session").deleteMany({});
	}

	beforeAll(async () => {
		await clearDb();
	});

	const adapter = mongodbAdapter(db);
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
		skipGenerateIdTest: true,
	});
});

describe("simple-flow", async () => {
	const { auth, client, sessionSetter, db } = await getTestInstance(
		{},
		{
			disableTestUser: true,
			testWith: "mongodb",
		},
	);
	const testUser = {
		email: "test-eamil@email.com",
		password: "password",
		name: "Test Name",
	};

	it("should sign up", async () => {
		const user = await auth.api.signUpEmail({
			body: testUser,
		});
		expect(user).toBeDefined();
	});

	it("should sign in", async () => {
		const user = await auth.api.signInEmail({
			body: testUser,
		});
		expect(user).toBeDefined();
	});

	it("should get session", async () => {
		const headers = new Headers();
		await client.signIn.email(
			{
				email: testUser.email,
				password: testUser.password,
			},
			{
				onSuccess: sessionSetter(headers),
			},
		);
		const { data: session } = await client.getSession({
			fetchOptions: { headers },
		});
		expect(session?.user).toBeDefined();
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/mongodb-adapter/index.ts
```typescript
export * from "./mongodb-adapter";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/mongodb-adapter/mongodb-adapter.ts
```typescript
import { ObjectId, type Db } from "mongodb";
import { getAuthTables } from "../../db";
import type { Adapter, BetterAuthOptions, Where } from "../../types";
import { withApplyDefault } from "../utils";

const createTransform = (options: BetterAuthOptions) => {
	const schema = getAuthTables(options);
	/**
	 * if custom id gen is provided we don't want to override with object id
	 */
	const customIdGen = options.advanced?.generateId;

	function serializeID(field: string, value: any, model: string) {
		if (customIdGen) {
			return value;
		}
		if (
			field === "id" ||
			field === "_id" ||
			schema[model].fields[field].references?.field === "id"
		) {
			if (typeof value !== "string") {
				if (value instanceof ObjectId) {
					return value;
				}
				if (Array.isArray(value)) {
					return value.map((v) => {
						if (typeof v === "string") {
							try {
								return new ObjectId(v);
							} catch (e) {
								return v;
							}
						}
						if (v instanceof ObjectId) {
							return v;
						}
						throw new Error("Invalid id value");
					});
				}
				throw new Error("Invalid id value");
			}
			try {
				return new ObjectId(value);
			} catch (e) {
				return value;
			}
		}
		return value;
	}

	function deserializeID(field: string, value: any, model: string) {
		if (customIdGen) {
			return value;
		}
		if (
			field === "id" ||
			schema[model].fields[field].references?.field === "id"
		) {
			if (value instanceof ObjectId) {
				return value.toHexString();
			}
			if (Array.isArray(value)) {
				return value.map((v) => {
					if (v instanceof ObjectId) {
						return v.toHexString();
					}
					return v;
				});
			}
			return value;
		}
		return value;
	}

	function getField(field: string, model: string) {
		if (field === "id") {
			if (customIdGen) {
				return "id";
			}
			return "_id";
		}
		const f = schema[model].fields[field];
		return f.fieldName || field;
	}

	return {
		transformInput(
			data: Record<string, any>,
			model: string,
			action: "create" | "update",
		) {
			const transformedData: Record<string, any> =
				action === "update"
					? {}
					: customIdGen
						? {
								id: customIdGen({ model }),
							}
						: {
								_id: new ObjectId(),
							};
			const fields = schema[model].fields;
			for (const field in fields) {
				const value = data[field];
				if (
					value === undefined &&
					(!fields[field].defaultValue || action === "update")
				) {
					continue;
				}
				transformedData[fields[field].fieldName || field] = withApplyDefault(
					serializeID(field, value, model),
					fields[field],
					action,
				);
			}
			return transformedData;
		},
		transformOutput(
			data: Record<string, any>,
			model: string,
			select: string[] = [],
		) {
			const transformedData: Record<string, any> =
				data.id || data._id
					? select.length === 0 || select.includes("id")
						? {
								id: data.id ? data.id.toString() : data._id.toString(),
							}
						: {}
					: {};

			const tableSchema = schema[model].fields;
			for (const key in tableSchema) {
				if (select.length && !select.includes(key)) {
					continue;
				}
				const field = tableSchema[key];
				if (field) {
					transformedData[key] = deserializeID(
						key,
						data[field.fieldName || key],
						model,
					);
				}
			}
			return transformedData as any;
		},
		convertWhereClause(where: Where[], model: string) {
			if (!where.length) return {};
			const conditions = where.map((w) => {
				const { field: _field, value, operator = "eq", connector = "AND" } = w;
				let condition: any;
				const field = getField(_field, model);
				switch (operator.toLowerCase()) {
					case "eq":
						condition = {
							[field]: serializeID(_field, value, model),
						};
						break;
					case "in":
						condition = {
							[field]: {
								$in: Array.isArray(value)
									? serializeID(_field, value, model)
									: [serializeID(_field, value, model)],
							},
						};
						break;
					case "gt":
						condition = { [field]: { $gt: value } };
						break;
					case "gte":
						condition = { [field]: { $gte: value } };
						break;
					case "lt":
						condition = { [field]: { $lt: value } };
						break;
					case "lte":
						condition = { [field]: { $lte: value } };
						break;
					case "ne":
						condition = { [field]: { $ne: value } };
						break;

					case "contains":
						condition = { [field]: { $regex: `.*${value}.*` } };
						break;
					case "starts_with":
						condition = { [field]: { $regex: `${value}.*` } };
						break;
					case "ends_with":
						condition = { [field]: { $regex: `.*${value}` } };
						break;
					default:
						throw new Error(`Unsupported operator: ${operator}`);
				}
				return { condition, connector };
			});
			if (conditions.length === 1) {
				return conditions[0].condition;
			}
			const andConditions = conditions
				.filter((c) => c.connector === "AND")
				.map((c) => c.condition);
			const orConditions = conditions
				.filter((c) => c.connector === "OR")
				.map((c) => c.condition);

			let clause = {};
			if (andConditions.length) {
				clause = { ...clause, $and: andConditions };
			}
			if (orConditions.length) {
				clause = { ...clause, $or: orConditions };
			}
			return clause;
		},
		getModelName: (model: string) => {
			return schema[model].modelName;
		},
		getField,
	};
};

export const mongodbAdapter = (db: Db) => (options: BetterAuthOptions) => {
	const transform = createTransform(options);
	const hasCustomId = options.advanced?.generateId;
	return {
		id: "mongodb-adapter",
		async create(data) {
			const { model, data: values, select } = data;
			const transformedData = transform.transformInput(values, model, "create");
			if (transformedData.id && !hasCustomId) {
				// biome-ignore lint/performance/noDelete: setting id to undefined will cause the id to be null in the database which is not what we want
				delete transformedData.id;
			}
			const res = await db
				.collection(transform.getModelName(model))
				.insertOne(transformedData);
			const id = res.insertedId;
			const insertedData = { id: id.toString(), ...transformedData };
			const t = transform.transformOutput(insertedData, model, select);
			return t;
		},
		async findOne(data) {
			const { model, where, select } = data;
			const clause = transform.convertWhereClause(where, model);
			const res = await db
				.collection(transform.getModelName(model))
				.findOne(clause);
			if (!res) return null;
			const transformedData = transform.transformOutput(res, model, select);
			return transformedData;
		},
		async findMany(data) {
			const { model, where, limit, offset, sortBy } = data;
			const clause = where ? transform.convertWhereClause(where, model) : {};
			const cursor = db.collection(transform.getModelName(model)).find(clause);
			if (limit) cursor.limit(limit);
			if (offset) cursor.skip(offset);
			if (sortBy)
				cursor.sort(
					transform.getField(sortBy.field, model),
					sortBy.direction === "desc" ? -1 : 1,
				);
			const res = await cursor.toArray();
			return res.map((r) => transform.transformOutput(r, model));
		},
		async count(data) {
			const { model } = data;
			const res = await db
				.collection(transform.getModelName(model))
				.countDocuments();
			return res;
		},
		async update(data) {
			const { model, where, update: values } = data;
			const clause = transform.convertWhereClause(where, model);

			const transformedData = transform.transformInput(values, model, "update");

			const res = await db
				.collection(transform.getModelName(model))
				.findOneAndUpdate(
					clause,
					{ $set: transformedData },
					{
						returnDocument: "after",
					},
				);
			if (!res) return null;
			return transform.transformOutput(res, model);
		},
		async updateMany(data) {
			const { model, where, update: values } = data;
			const clause = transform.convertWhereClause(where, model);
			const transformedData = transform.transformInput(values, model, "update");
			const res = await db
				.collection(transform.getModelName(model))
				.updateMany(clause, { $set: transformedData });
			return res.modifiedCount;
		},
		async delete(data) {
			const { model, where } = data;
			const clause = transform.convertWhereClause(where, model);
			const res = await db
				.collection(transform.getModelName(model))
				.findOneAndDelete(clause);
			if (!res) return null;
			return transform.transformOutput(res, model);
		},
		async deleteMany(data) {
			const { model, where } = data;
			const clause = transform.convertWhereClause(where, model);
			const res = await db
				.collection(transform.getModelName(model))
				.deleteMany(clause);
			return res.deletedCount;
		},
	} satisfies Adapter;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/kysely-adapter/dialect.ts
```typescript
import { Kysely, MssqlDialect } from "kysely";
import {
	type Dialect,
	MysqlDialect,
	PostgresDialect,
	SqliteDialect,
} from "kysely";
import type { BetterAuthOptions } from "../../types";
import type { KyselyDatabaseType } from "./types";

function getDatabaseType(
	db: BetterAuthOptions["database"],
): KyselyDatabaseType | null {
	if (!db) {
		return null;
	}
	if ("dialect" in db) {
		return getDatabaseType(db.dialect as Dialect);
	}
	if ("createDriver" in db) {
		if (db instanceof SqliteDialect) {
			return "sqlite";
		}
		if (db instanceof MysqlDialect) {
			return "mysql";
		}
		if (db instanceof PostgresDialect) {
			return "postgres";
		}
		if (db instanceof MssqlDialect) {
			return "mssql";
		}
	}
	if ("aggregate" in db) {
		return "sqlite";
	}

	if ("getConnection" in db) {
		return "mysql";
	}
	if ("connect" in db) {
		return "postgres";
	}

	return null;
}

export const createKyselyAdapter = async (config: BetterAuthOptions) => {
	const db = config.database;

	if (!db) {
		return {
			kysely: null,
			databaseType: null,
		};
	}

	if ("db" in db) {
		return {
			kysely: db.db,
			databaseType: db.type,
		};
	}

	if ("dialect" in db) {
		return {
			kysely: new Kysely<any>({ dialect: db.dialect }),
			databaseType: db.type,
		};
	}

	let dialect: Dialect | undefined = undefined;

	const databaseType = getDatabaseType(db);

	if ("createDriver" in db) {
		dialect = db;
	}

	if ("aggregate" in db) {
		dialect = new SqliteDialect({
			database: db,
		});
	}

	if ("getConnection" in db) {
		// @ts-ignore - mysql2/promise
		dialect = new MysqlDialect(db);
	}

	if ("connect" in db) {
		dialect = new PostgresDialect({
			pool: db,
		});
	}

	return {
		kysely: dialect ? new Kysely<any>({ dialect }) : null,
		databaseType,
	};
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/kysely-adapter/index.ts
```typescript
export * from "./dialect";
export * from "./types";
export * from "./kysely-adapter";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/kysely-adapter/kysely-adapter.ts
```typescript
import { getAuthTables } from "../../db";
import type { Adapter, BetterAuthOptions, Where } from "../../types";
import { generateId } from "../../utils";
import { withApplyDefault } from "../utils";
import type { KyselyDatabaseType } from "./types";
import type { InsertQueryBuilder, Kysely, UpdateQueryBuilder } from "kysely";

interface KyselyAdapterConfig {
	/**
	 * Database type.
	 */
	type?: KyselyDatabaseType;
}

const createTransform = (
	db: Kysely<any>,
	options: BetterAuthOptions,
	config?: KyselyAdapterConfig,
) => {
	const schema = getAuthTables(options);

	function getField(model: string, field: string) {
		if (field === "id") {
			return field;
		}
		const f = schema[model].fields[field];
		if (!f) {
			console.log("Field not found", model, field);
		}
		return f.fieldName || field;
	}

	function transformValueToDB(value: any, model: string, field: string) {
		if (field === "id") {
			return value;
		}
		const { type = "sqlite" } = config || {};
		const f = schema[model].fields[field];
		if (
			f.type === "boolean" &&
			(type === "sqlite" || type === "mssql") &&
			value !== null &&
			value !== undefined
		) {
			return value ? 1 : 0;
		}
		if (f.type === "date" && value && value instanceof Date) {
			return type === "sqlite" ? value.toISOString() : value;
		}
		return value;
	}

	function transformValueFromDB(value: any, model: string, field: string) {
		const { type = "sqlite" } = config || {};

		const f = schema[model].fields[field];
		if (
			f.type === "boolean" &&
			(type === "sqlite" || type === "mssql") &&
			value !== null
		) {
			return value === 1;
		}
		if (f.type === "date" && value) {
			return new Date(value);
		}
		return value;
	}

	function getModelName(model: string) {
		return schema[model].modelName;
	}

	const useDatabaseGeneratedId = options?.advanced?.generateId === false;
	return {
		transformInput(
			data: Record<string, any>,
			model: string,
			action: "create" | "update",
		) {
			const transformedData: Record<string, any> =
				useDatabaseGeneratedId || action === "update"
					? {}
					: {
							id: options.advanced?.generateId
								? options.advanced.generateId({
										model,
									})
								: data.id || generateId(),
						};
			const fields = schema[model].fields;
			for (const field in fields) {
				const value = data[field];
				transformedData[fields[field].fieldName || field] = withApplyDefault(
					transformValueToDB(value, model, field),
					fields[field],
					action,
				);
			}
			return transformedData;
		},
		transformOutput(
			data: Record<string, any>,
			model: string,
			select: string[] = [],
		) {
			if (!data) return null;
			const transformedData: Record<string, any> = data.id
				? select.length === 0 || select.includes("id")
					? {
							id: data.id,
						}
					: {}
				: {};
			const tableSchema = schema[model].fields;
			for (const key in tableSchema) {
				if (select.length && !select.includes(key)) {
					continue;
				}
				const field = tableSchema[key];
				if (field) {
					transformedData[key] = transformValueFromDB(
						data[field.fieldName || key],
						model,
						key,
					);
				}
			}
			return transformedData as any;
		},
		convertWhereClause(model: string, w?: Where[]) {
			if (!w)
				return {
					and: null,
					or: null,
				};

			const conditions = {
				and: [] as any[],
				or: [] as any[],
			};

			w.forEach((condition) => {
				let {
					field: _field,
					value,
					operator = "=",
					connector = "AND",
				} = condition;
				const field = getField(model, _field);
				value = transformValueToDB(value, model, _field);
				const expr = (eb: any) => {
					if (operator.toLowerCase() === "in") {
						return eb(field, "in", Array.isArray(value) ? value : [value]);
					}

					if (operator === "contains") {
						return eb(field, "like", `%${value}%`);
					}

					if (operator === "starts_with") {
						return eb(field, "like", `${value}%`);
					}

					if (operator === "ends_with") {
						return eb(field, "like", `%${value}`);
					}

					if (operator === "eq") {
						return eb(field, "=", value);
					}

					if (operator === "ne") {
						return eb(field, "<>", value);
					}

					if (operator === "gt") {
						return eb(field, ">", value);
					}

					if (operator === "gte") {
						return eb(field, ">=", value);
					}

					if (operator === "lt") {
						return eb(field, "<", value);
					}

					if (operator === "lte") {
						return eb(field, "<=", value);
					}

					return eb(field, operator, value);
				};

				if (connector === "OR") {
					conditions.or.push(expr);
				} else {
					conditions.and.push(expr);
				}
			});

			return {
				and: conditions.and.length ? conditions.and : null,
				or: conditions.or.length ? conditions.or : null,
			};
		},
		async withReturning(
			values: Record<string, any>,
			builder:
				| InsertQueryBuilder<any, any, any>
				| UpdateQueryBuilder<any, string, string, any>,
			model: string,
			where: Where[],
		) {
			let res: any;
			if (config?.type === "mysql") {
				//this isn't good, but kysely doesn't support returning in mysql and it doesn't return the inserted id. Change this if there is a better way.
				await builder.execute();
				const field = values.id ? "id" : where[0].field ? where[0].field : "id";
				const value = values[field] || where[0].value;
				res = await db
					.selectFrom(getModelName(model))
					.selectAll()
					.where(getField(model, field), "=", value)
					.executeTakeFirst();
				return res;
			}
			if (config?.type === "mssql") {
				res = await builder.outputAll("inserted").executeTakeFirst();
				return res;
			}
			res = await builder.returningAll().executeTakeFirst();
			return res;
		},
		getModelName,
		getField,
	};
};

export const kyselyAdapter =
	(db: Kysely<any>, config?: KyselyAdapterConfig) =>
	(opts: BetterAuthOptions) => {
		const {
			transformInput,
			withReturning,
			transformOutput,
			convertWhereClause,
			getModelName,
			getField,
		} = createTransform(db, opts, config);
		return {
			id: "kysely",
			async create(data) {
				const { model, data: values, select } = data;
				const transformed = transformInput(values, model, "create");
				const builder = db.insertInto(getModelName(model)).values(transformed);
				return transformOutput(
					await withReturning(transformed, builder, model, []),
					model,
					select,
				);
			},
			async findOne(data) {
				const { model, where, select } = data;
				const { and, or } = convertWhereClause(model, where);
				let query = db.selectFrom(getModelName(model)).selectAll();
				if (and) {
					query = query.where((eb) => eb.and(and.map((expr) => expr(eb))));
				}
				if (or) {
					query = query.where((eb) => eb.or(or.map((expr) => expr(eb))));
				}
				const res = await query.executeTakeFirst();
				if (!res) return null;
				return transformOutput(res, model, select);
			},
			async findMany(data) {
				const { model, where, limit, offset, sortBy } = data;
				const { and, or } = convertWhereClause(model, where);
				let query = db.selectFrom(getModelName(model));
				if (and) {
					query = query.where((eb) => eb.and(and.map((expr) => expr(eb))));
				}
				if (or) {
					query = query.where((eb) => eb.or(or.map((expr) => expr(eb))));
				}
				if (config?.type === "mssql") {
					if (!offset) {
						query = query.top(limit || 100);
					}
				} else {
					query = query.limit(limit || 100);
				}
				if (sortBy) {
					query = query.orderBy(
						getField(model, sortBy.field),
						sortBy.direction,
					);
				}
				if (offset) {
					if (config?.type === "mssql") {
						if (!sortBy) {
							query = query.orderBy(getField(model, "id"));
						}
						query = query.offset(offset).fetch(limit || 100);
					} else {
						query = query.offset(offset);
					}
				}

				const res = await query.selectAll().execute();
				if (!res) return [];
				return res.map((r) => transformOutput(r, model));
			},
			async update(data) {
				const { model, where, update: values } = data;
				const { and, or } = convertWhereClause(model, where);
				const transformedData = transformInput(values, model, "update");

				let query = db.updateTable(getModelName(model)).set(transformedData);
				if (and) {
					query = query.where((eb) => eb.and(and.map((expr) => expr(eb))));
				}
				if (or) {
					query = query.where((eb) => eb.or(or.map((expr) => expr(eb))));
				}
				const res = await transformOutput(
					await withReturning(transformedData, query, model, where),
					model,
				);
				return res;
			},
			async updateMany(data) {
				const { model, where, update: values } = data;
				const { and, or } = convertWhereClause(model, where);
				const transformedData = transformInput(values, model, "update");
				let query = db.updateTable(getModelName(model)).set(transformedData);
				if (and) {
					query = query.where((eb) => eb.and(and.map((expr) => expr(eb))));
				}
				if (or) {
					query = query.where((eb) => eb.or(or.map((expr) => expr(eb))));
				}
				const res = await query.execute();
				return res.length;
			},
			async count(data) {
				const { model, where } = data;
				const { and, or } = convertWhereClause(model, where);
				let query = db
					.selectFrom(getModelName(model))
					// a temporal solution for counting other than "*" - see more - https://www.sqlite.org/quirks.html#double_quoted_string_literals_are_accepted
					.select(db.fn.count("id").as("count"));
				if (and) {
					query = query.where((eb) => eb.and(and.map((expr) => expr(eb))));
				}
				if (or) {
					query = query.where((eb) => eb.or(or.map((expr) => expr(eb))));
				}
				const res = await query.execute();
				return res[0].count as number;
			},
			async delete(data) {
				const { model, where } = data;
				const { and, or } = convertWhereClause(model, where);
				let query = db.deleteFrom(getModelName(model));
				if (and) {
					query = query.where((eb) => eb.and(and.map((expr) => expr(eb))));
				}

				if (or) {
					query = query.where((eb) => eb.or(or.map((expr) => expr(eb))));
				}
				await query.execute();
			},
			async deleteMany(data) {
				const { model, where } = data;
				const { and, or } = convertWhereClause(model, where);
				let query = db.deleteFrom(getModelName(model));
				if (and) {
					query = query.where((eb) => eb.and(and.map((expr) => expr(eb))));
				}
				if (or) {
					query = query.where((eb) => eb.or(or.map((expr) => expr(eb))));
				}
				return (await query.execute()).length;
			},
			options: config,
		} satisfies Adapter;
	};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/kysely-adapter/types.ts
```typescript
export type KyselyDatabaseType = "postgres" | "mysql" | "sqlite" | "mssql";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/kysely-adapter/test/adapter.kysley.test.ts
```typescript
import fs from "fs/promises";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { runAdapterTest } from "../../test";
import { getMigrations } from "../../../db/get-migration";
import path from "path";
import Database from "better-sqlite3";
import { kyselyAdapter } from "..";
import { Kysely, MysqlDialect, sql, SqliteDialect } from "kysely";
import type { BetterAuthOptions } from "../../../types";
import { createPool } from "mysql2/promise";

import * as tedious from "tedious";
import * as tarn from "tarn";
import { MssqlDialect } from "kysely";
import { getTestInstance } from "../../../test-utils/test-instance";

describe("adapter test", async () => {
	const sqlite = new Database(path.join(__dirname, "test.db"));
	const mysql = createPool("mysql://user:password@localhost:3306/better_auth");
	const sqliteKy = new Kysely({
		dialect: new SqliteDialect({
			database: sqlite,
		}),
	});
	const mysqlKy = new Kysely({
		dialect: new MysqlDialect(mysql),
	});
	const opts = (database: BetterAuthOptions["database"]) =>
		({
			database: database,
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
		}) satisfies BetterAuthOptions;
	const mysqlOptions = opts({
		db: mysqlKy,
		type: "mysql",
	});
	const sqliteOptions = opts({
		db: sqliteKy,
		type: "sqlite",
	});
	beforeAll(async () => {
		const { runMigrations } = await getMigrations(mysqlOptions);
		await runMigrations();
		const { runMigrations: runMigrationsSqlite } =
			await getMigrations(sqliteOptions);
		await runMigrationsSqlite();
	});

	afterAll(async () => {
		await mysql.query("DROP DATABASE IF EXISTS better_auth");
		await mysql.query("CREATE DATABASE better_auth");
		await mysql.end();
		await fs.unlink(path.join(__dirname, "test.db"));
	});

	const mysqlAdapter = kyselyAdapter(mysqlKy, {
		type: "mysql",
	});
	await runAdapterTest({
		getAdapter: async (customOptions = {}) => {
			return mysqlAdapter({ ...mysqlOptions, ...customOptions });
		},
	});

	const sqliteAdapter = kyselyAdapter(sqliteKy, {
		type: "sqlite",
	});
	await runAdapterTest({
		getAdapter: async (customOptions = {}) => {
			return sqliteAdapter({ ...sqliteOptions, ...customOptions });
		},
	});
});

describe("mssql", async () => {
	const dialect = new MssqlDialect({
		tarn: {
			...tarn,
			options: {
				min: 0,
				max: 10,
			},
		},
		tedious: {
			...tedious,
			connectionFactory: () =>
				new tedious.Connection({
					authentication: {
						options: {
							password: "Password123!",
							userName: "sa",
						},
						type: "default",
					},
					options: {
						port: 1433,
						trustServerCertificate: true,
					},
					server: "localhost",
				}),
		},
	});
	const opts = {
		database: dialect,
		user: {
			modelName: "users",
		},
	} satisfies BetterAuthOptions;
	beforeAll(async () => {
		const { runMigrations, toBeAdded, toBeCreated } = await getMigrations(opts);
		await runMigrations();
	});
	const mssql = new Kysely({
		dialect: dialect,
	});
	const getAdapter = kyselyAdapter(mssql, {
		type: "mssql",
	});

	const adapter = getAdapter(opts);

	async function resetDB() {
		await sql`DROP TABLE dbo.session;`.execute(mssql);
		await sql`DROP TABLE dbo.verification;`.execute(mssql);
		await sql`DROP TABLE dbo.account;`.execute(mssql);
		await sql`DROP TABLE dbo.users;`.execute(mssql);
	}

	afterAll(async () => {
		await resetDB();
	});

	await runAdapterTest({
		getAdapter: async (customOptions = {}) => {
			return adapter;
		},
		skipGenerateIdTest: true,
	});

	describe("simple flow", async () => {
		const { auth } = await getTestInstance(
			{
				database: dialect,
				user: {
					modelName: "users",
				},
			},
			{
				disableTestUser: true,
			},
		);
		it("should sign-up", async () => {
			const res = await auth.api.signUpEmail({
				body: {
					name: "test",
					password: "password",
					email: "test-2@email.com",
				},
			});
			expect(res.user.name).toBe("test");
			expect(res.token?.length).toBeTruthy();
		});

		let token = "";
		it("should sign in", async () => {
			//sign in
			const signInRes = await auth.api.signInEmail({
				body: {
					password: "password",
					email: "test-2@email.com",
				},
			});

			expect(signInRes.token?.length).toBeTruthy();
			expect(signInRes.user.name).toBe("test");
			token = signInRes.token;
		});

		it("should return session", async () => {
			const session = await auth.api.getSession({
				headers: new Headers({
					Authorization: `Bearer ${token}`,
				}),
			});
			expect(session).toMatchObject({
				session: {
					token,
					userId: expect.any(String),
				},
				user: {
					name: "test",
					email: "test-2@email.com",
				},
			});
		});
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/drizzle-adapter/drizzle-adapter.ts
```typescript
import {
	and,
	asc,
	count,
	desc,
	eq,
	inArray,
	like,
	lt,
	lte,
	or,
	SQL,
} from "drizzle-orm";
import { getAuthTables } from "../../db";
import { BetterAuthError } from "../../error";
import type { Adapter, BetterAuthOptions, Where } from "../../types";
import { generateId } from "../../utils";
import { withApplyDefault } from "../utils";

export interface DB {
	[key: string]: any;
}

const createTransform = (
	db: DB,
	config: DrizzleAdapterConfig,
	options: BetterAuthOptions,
) => {
	const schema = getAuthTables(options);

	function getField(model: string, field: string) {
		if (field === "id") {
			return field;
		}
		const f = schema[model].fields[field];
		return f.fieldName || field;
	}

	function getSchema(modelName: string) {
		const schema = config.schema || db._.fullSchema;
		if (!schema) {
			throw new BetterAuthError(
				"Drizzle adapter failed to initialize. Schema not found. Please provide a schema object in the adapter options object.",
			);
		}
		const model = getModelName(modelName);
		const schemaModel = schema[model];
		if (!schemaModel) {
			throw new BetterAuthError(
				`[# Drizzle Adapter]: The model "${model}" was not found in the schema object. Please pass the schema directly to the adapter options.`,
			);
		}
		return schemaModel;
	}

	const getModelName = (model: string) => {
		return schema[model].modelName !== model
			? schema[model].modelName
			: config.usePlural
				? `${model}s`
				: model;
	};

	function convertWhereClause(where: Where[], model: string) {
		const schemaModel = getSchema(model);
		if (!where) return [];
		if (where.length === 1) {
			const w = where[0];
			if (!w) {
				return [];
			}
			const field = getField(model, w.field);
			if (!schemaModel[field]) {
				throw new BetterAuthError(
					`The field "${w.field}" does not exist in the schema for the model "${model}". Please update your schema.`,
				);
			}
			if (w.operator === "in") {
				if (!Array.isArray(w.value)) {
					throw new BetterAuthError(
						`The value for the field "${w.field}" must be an array when using the "in" operator.`,
					);
				}
				return [inArray(schemaModel[field], w.value)];
			}

			if (w.operator === "contains") {
				return [like(schemaModel[field], `%${w.value}%`)];
			}

			if (w.operator === "starts_with") {
				return [like(schemaModel[field], `${w.value}%`)];
			}

			if (w.operator === "ends_with") {
				return [like(schemaModel[field], `%${w.value}`)];
			}

			if (w.operator === "lt") {
				return [lt(schemaModel[field], w.value)];
			}

			if (w.operator === "lte") {
				return [lte(schemaModel[field], w.value)];
			}

			return [eq(schemaModel[field], w.value)];
		}
		const andGroup = where.filter((w) => w.connector === "AND" || !w.connector);
		const orGroup = where.filter((w) => w.connector === "OR");

		const andClause = and(
			...andGroup.map((w) => {
				const field = getField(model, w.field);
				if (w.operator === "in") {
					if (!Array.isArray(w.value)) {
						throw new BetterAuthError(
							`The value for the field "${w.field}" must be an array when using the "in" operator.`,
						);
					}
					return inArray(schemaModel[field], w.value);
				}
				return eq(schemaModel[field], w.value);
			}),
		);
		const orClause = or(
			...orGroup.map((w) => {
				const field = getField(model, w.field);
				return eq(schemaModel[field], w.value);
			}),
		);

		const clause: SQL<unknown>[] = [];

		if (andGroup.length) clause.push(andClause!);
		if (orGroup.length) clause.push(orClause!);
		return clause;
	}

	const useDatabaseGeneratedId = options?.advanced?.generateId === false;
	return {
		getSchema,
		transformInput(
			data: Record<string, any>,
			model: string,
			action: "create" | "update",
		) {
			const transformedData: Record<string, any> =
				useDatabaseGeneratedId || action === "update"
					? {}
					: {
							id: options.advanced?.generateId
								? options.advanced.generateId({
										model,
									})
								: data.id || generateId(),
						};
			const fields = schema[model].fields;
			for (const field in fields) {
				const value = data[field];
				if (value === undefined && !fields[field].defaultValue) {
					continue;
				}
				transformedData[fields[field].fieldName || field] = withApplyDefault(
					value,
					fields[field],
					action,
				);
			}
			return transformedData;
		},
		transformOutput(
			data: Record<string, any>,
			model: string,
			select: string[] = [],
		) {
			if (!data) return null;
			const transformedData: Record<string, any> =
				data.id || data._id
					? select.length === 0 || select.includes("id")
						? {
								id: data.id,
							}
						: {}
					: {};
			const tableSchema = schema[model].fields;
			for (const key in tableSchema) {
				if (select.length && !select.includes(key)) {
					continue;
				}
				const field = tableSchema[key];
				if (field) {
					transformedData[key] = data[field.fieldName || key];
				}
			}
			return transformedData as any;
		},
		convertWhereClause,
		withReturning: async (
			model: string,
			builder: any,
			data: Record<string, any>,
			where?: Where[],
		) => {
			if (config.provider !== "mysql") {
				const c = await builder.returning();
				return c[0];
			}
			await builder.execute();
			const schemaModel = getSchema(model);
			const builderVal = builder.config?.values;
			if (where?.length) {
				const clause = convertWhereClause(where, model);
				const res = await db
					.select()
					.from(schemaModel)
					.where(...clause);
				return res[0];
			} else if (builderVal) {
				const tId = builderVal[0]?.id.value;
				const res = await db
					.select()
					.from(schemaModel)
					.where(eq(schemaModel.id, tId));
				return res[0];
			} else if (data.id) {
				const res = await db
					.select()
					.from(schemaModel)
					.where(eq(schemaModel.id, data.id));
				return res[0];
			}
		},
		getField,
		getModelName,
	};
};

export interface DrizzleAdapterConfig {
	/**
	 * The schema object that defines the tables and fields
	 */
	schema?: Record<string, any>;
	/**
	 * The database provider
	 */
	provider: "pg" | "mysql" | "sqlite";
	/**
	 * If the table names in the schema are plural
	 * set this to true. For example, if the schema
	 * has an object with a key "users" instead of "user"
	 */
	usePlural?: boolean;
}

function checkMissingFields(
	schema: Record<string, any>,
	model: string,
	values: Record<string, any>,
) {
	if (!schema) {
		throw new BetterAuthError(
			"Drizzle adapter failed to initialize. Schema not found. Please provide a schema object in the adapter options object.",
		);
	}
	for (const key in values) {
		if (!schema[key]) {
			throw new BetterAuthError(
				`The field "${key}" does not exist in the "${model}" schema. Please update your drizzle schema or re-generate using "npx @better-auth/cli generate".`,
			);
		}
	}
}

export const drizzleAdapter =
	(db: DB, config: DrizzleAdapterConfig) => (options: BetterAuthOptions) => {
		const {
			transformInput,
			transformOutput,
			convertWhereClause,
			getSchema,
			withReturning,
			getField,
			getModelName,
		} = createTransform(db, config, options);
		return {
			id: "drizzle",
			async create(data) {
				const { model, data: values } = data;
				const transformed = transformInput(values, model, "create");
				const schemaModel = getSchema(model);
				checkMissingFields(schemaModel, getModelName(model), transformed);
				const builder = db.insert(schemaModel).values(transformed);
				const returned = await withReturning(model, builder, transformed);
				return transformOutput(returned, model);
			},
			async findOne(data) {
				const { model, where, select } = data;
				const schemaModel = getSchema(model);
				const clause = convertWhereClause(where, model);
				const res = await db
					.select()
					.from(schemaModel)
					.where(...clause);

				if (!res.length) return null;
				return transformOutput(res[0], model, select);
			},
			async findMany(data) {
				const { model, where, sortBy, limit, offset } = data;
				const schemaModel = getSchema(model);
				const clause = where ? convertWhereClause(where, model) : [];

				const sortFn = sortBy?.direction === "desc" ? desc : asc;
				const builder = db
					.select()
					.from(schemaModel)
					.limit(limit || 100)
					.offset(offset || 0);
				if (sortBy?.field) {
					builder.orderBy(sortFn(schemaModel[getField(model, sortBy?.field)]));
				}
				const res = (await builder.where(...clause)) as any[];
				return res.map((r) => transformOutput(r, model));
			},
			async count(data) {
				const { model, where } = data;
				const schemaModel = getSchema(model);
				const clause = where ? convertWhereClause(where, model) : [];
				const res = await db
					.select({ count: count() })
					.from(schemaModel)
					.where(...clause);
				return res.count;
			},
			async update(data) {
				const { model, where, update: values } = data;
				const schemaModel = getSchema(model);
				const clause = convertWhereClause(where, model);
				const transformed = transformInput(values, model, "update");
				const builder = db
					.update(schemaModel)
					.set(transformed)
					.where(...clause);
				const returned = await withReturning(
					model,
					builder,
					transformed,
					where,
				);
				return transformOutput(returned, model);
			},
			async updateMany(data) {
				const { model, where, update: values } = data;
				const schemaModel = getSchema(model);
				const clause = convertWhereClause(where, model);
				const transformed = transformInput(values, model, "update");
				const builder = db
					.update(schemaModel)
					.set(transformed)
					.where(...clause);
				const res = await builder;
				return res ? res.changes : 0;
			},
			async delete(data) {
				const { model, where } = data;
				const schemaModel = getSchema(model);
				const clause = convertWhereClause(where, model);
				const builder = db.delete(schemaModel).where(...clause);
				await builder;
			},
			async deleteMany(data) {
				const { model, where } = data;
				const schemaModel = getSchema(model);
				const clause = convertWhereClause(where, model); //con
				const builder = db.delete(schemaModel).where(...clause);
				const res = await builder;
				return res ? res.length : 0;
			},
			options: config,
		} satisfies Adapter;
	};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/drizzle-adapter/index.ts
```typescript
export * from "./drizzle-adapter";

```
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
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/memory-adapter/index.ts
```typescript
export * from "./memory-adapter";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/memory-adapter/memory-adapter.ts
```typescript
import { getAuthTables } from "../../db";
import type { Adapter, BetterAuthOptions, Where } from "../../types";
import { generateId } from "../../utils";
import { withApplyDefault } from "../utils";

export interface MemoryDB {
	[key: string]: any[];
}

const createTransform = (options: BetterAuthOptions) => {
	const schema = getAuthTables(options);

	function getField(model: string, field: string) {
		if (field === "id") {
			return field;
		}
		const f = schema[model].fields[field];
		return f.fieldName || field;
	}
	return {
		transformInput(
			data: Record<string, any>,
			model: string,
			action: "update" | "create",
		) {
			const transformedData: Record<string, any> =
				action === "update"
					? {}
					: {
							id: options.advanced?.generateId
								? options.advanced.generateId({
										model,
									})
								: data.id || generateId(),
						};

			const fields = schema[model].fields;
			for (const field in fields) {
				const value = data[field];
				if (value === undefined && !fields[field].defaultValue) {
					continue;
				}
				transformedData[fields[field].fieldName || field] = withApplyDefault(
					value,
					fields[field],
					action,
				);
			}
			return transformedData;
		},
		transformOutput(
			data: Record<string, any>,
			model: string,
			select: string[] = [],
		) {
			if (!data) return null;
			const transformedData: Record<string, any> =
				data.id || data._id
					? select.length === 0 || select.includes("id")
						? {
								id: data.id,
							}
						: {}
					: {};
			const tableSchema = schema[model].fields;
			for (const key in tableSchema) {
				if (select.length && !select.includes(key)) {
					continue;
				}
				const field = tableSchema[key];
				if (field) {
					transformedData[key] = data[field.fieldName || key];
				}
			}
			return transformedData as any;
		},
		convertWhereClause(where: Where[], table: any[], model: string) {
			return table.filter((record) => {
				return where.every((clause) => {
					const { field: _field, value, operator } = clause;
					const field = getField(model, _field);
					if (operator === "in") {
						if (!Array.isArray(value)) {
							throw new Error("Value must be an array");
						}
						// @ts-ignore
						return value.includes(record[field]);
					} else if (operator === "contains") {
						return record[field].includes(value);
					} else if (operator === "starts_with") {
						return record[field].startsWith(value);
					} else if (operator === "ends_with") {
						return record[field].endsWith(value);
					} else {
						return record[field] === value;
					}
				});
			});
		},
		getField,
	};
};

export const memoryAdapter = (db: MemoryDB) => (options: BetterAuthOptions) => {
	const { transformInput, transformOutput, convertWhereClause, getField } =
		createTransform(options);

	return {
		id: "memory",
		create: async ({ model, data }) => {
			const transformed = transformInput(data, model, "create");
			db[model].push(transformed);
			return transformOutput(transformed, model);
		},
		findOne: async ({ model, where, select }) => {
			const table = db[model];
			const res = convertWhereClause(where, table, model);
			const record = res[0] || null;
			return transformOutput(record, model, select);
		},
		findMany: async ({ model, where, sortBy, limit, offset }) => {
			let table = db[model];
			if (where) {
				table = convertWhereClause(where, table, model);
			}
			if (sortBy) {
				table = table.sort((a, b) => {
					const field = getField(model, sortBy.field);
					if (sortBy.direction === "asc") {
						return a[field] > b[field] ? 1 : -1;
					} else {
						return a[field] < b[field] ? 1 : -1;
					}
				});
			}
			if (offset !== undefined) {
				table = table.slice(offset);
			}
			if (limit !== undefined) {
				table = table.slice(0, limit);
			}
			return table.map((record) => transformOutput(record, model));
		},
		count: async ({ model }) => {
			return db[model].length;
		},
		update: async ({ model, where, update }) => {
			const table = db[model];
			const res = convertWhereClause(where, table, model);
			res.forEach((record) => {
				Object.assign(record, transformInput(update, model, "update"));
			});
			return transformOutput(res[0], model);
		},
		delete: async ({ model, where }) => {
			const table = db[model];
			const res = convertWhereClause(where, table, model);
			db[model] = table.filter((record) => !res.includes(record));
		},
		deleteMany: async ({ model, where }) => {
			const table = db[model];
			const res = convertWhereClause(where, table, model);
			let count = 0;
			db[model] = table.filter((record) => {
				if (res.includes(record)) {
					count++;
					return false;
				}
				return !res.includes(record);
			});
			return count;
		},
		updateMany(data) {
			const { model, where, update } = data;
			const table = db[model];
			const res = convertWhereClause(where, table, model);
			res.forEach((record) => {
				Object.assign(record, update);
			});
			return res[0] || null;
		},
	} satisfies Adapter;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/adapters/memory-adapter/memory.test.ts
```typescript
import { describe } from "vitest";
import { memoryAdapter } from "./memory-adapter";
import { runAdapterTest } from "../test";

describe("adapter test", async () => {
	const db = {
		user: [],
		session: [],
		account: [],
	};
	const adapter = memoryAdapter(db);
	await runAdapterTest({
		getAdapter: async (customOptions = {}) => {
			return adapter({
				user: {
					fields: {
						email: "email_address",
					},
				},
				...customOptions,
			});
		},
	});
});

```
