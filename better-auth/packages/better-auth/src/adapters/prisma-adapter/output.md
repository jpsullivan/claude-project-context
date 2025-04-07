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
