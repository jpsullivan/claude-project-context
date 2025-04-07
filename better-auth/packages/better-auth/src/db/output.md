/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/db/db.test.ts
```typescript
import { describe, expect, it } from "vitest";
import { getTestInstance } from "../test-utils/test-instance";

describe("db", async () => {
	it("should work with custom model names", async () => {
		const { client, db } = await getTestInstance({
			user: {
				modelName: "users",
			},
			session: {
				modelName: "sessions",
			},
			account: {
				modelName: "accounts",
			},
		});
		const res = await client.signUp.email({
			email: "test@email2.com",
			password: "password",
			name: "Test User",
		});
		const users = await db.findMany({
			model: "user",
		});
		const session = await db.findMany({
			model: "session",
		});
		const accounts = await db.findMany({
			model: "account",
		});
		expect(res.data).toBeDefined();
		//including the user that was created in the test instance
		expect(users).toHaveLength(2);
		expect(session).toHaveLength(2);
		expect(accounts).toHaveLength(2);
	});

	it("db hooks", async () => {
		let callback = false;
		const { client, db } = await getTestInstance({
			databaseHooks: {
				user: {
					create: {
						async before(user) {
							return {
								data: {
									...user,
									image: "test-image",
								},
							};
						},
						async after(user) {
							callback = true;
						},
					},
				},
			},
		});
		const res = await client.signUp.email({
			email: "test@email.com",
			name: "test",
			password: "password",
		});
		const session = await client.getSession({
			fetchOptions: {
				headers: {
					Authorization: `Bearer ${res.data?.token}`,
				},
				throw: true,
			},
		});
		expect(session.user?.image).toBe("test-image");
		expect(callback).toBe(true);
	});

	it("should work with custom field names", async () => {
		const { client } = await getTestInstance({
			user: {
				fields: {
					email: "email_address",
				},
			},
		});
		const res = await client.signUp.email({
			email: "test@email.com",
			password: "password",
			name: "Test User",
		});
		const session = await client.getSession({
			fetchOptions: {
				headers: {
					Authorization: `Bearer ${res.data?.token}`,
				},
				throw: true,
			},
		});
		expect(session.user.email).toBe("test@email.com");
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/db/field.ts
```typescript
import type { ZodSchema } from "zod";
import type { BetterAuthOptions } from "../types";
import type { LiteralString } from "../types/helper";

export type FieldType =
	| "string"
	| "number"
	| "boolean"
	| "date"
	| `${"string" | "number"}[]`
	| Array<LiteralString>;

type Primitive =
	| string
	| number
	| boolean
	| Date
	| null
	| undefined
	| string[]
	| number[];

export type FieldAttributeConfig<T extends FieldType = FieldType> = {
	/**
	 * If the field should be required on a new record.
	 * @default true
	 */
	required?: boolean;
	/**
	 * If the value should be returned on a response body.
	 * @default true
	 */
	returned?: boolean;
	/**
	 * If a value should be provided when creating a new record.
	 * @default true
	 */
	input?: boolean;
	/**
	 * Default value for the field
	 *
	 * Note: This will not create a default value on the database level. It will only
	 * be used when creating a new record.
	 */
	defaultValue?: Primitive | (() => Primitive);
	/**
	 * transform the value before storing it.
	 */
	transform?: {
		input?: (value: Primitive) => Primitive | Promise<Primitive>;
		output?: (value: Primitive) => Primitive | Promise<Primitive>;
	};
	/**
	 * Reference to another model.
	 */
	references?: {
		/**
		 * The model to reference.
		 */
		model: string;
		/**
		 * The field on the referenced model.
		 */
		field: string;
		/**
		 * The action to perform when the reference is deleted.
		 * @default "cascade"
		 */
		onDelete?:
			| "no action"
			| "restrict"
			| "cascade"
			| "set null"
			| "set default";
	};
	unique?: boolean;
	/**
	 * If the field should be a bigint on the database instead of integer.
	 */
	bigint?: boolean;
	/**
	 * A zod schema to validate the value.
	 */
	validator?: {
		input?: ZodSchema;
		output?: ZodSchema;
	};
	/**
	 * The name of the field on the database.
	 */
	fieldName?: string;
	/**
	 * If the field should be sortable.
	 *
	 * applicable only for `text` type.
	 * It's useful to mark fields varchar instead of text.
	 */
	sortable?: boolean;
};

export type FieldAttribute<T extends FieldType = FieldType> = {
	type: T;
} & FieldAttributeConfig<T>;

export const createFieldAttribute = <
	T extends FieldType,
	C extends Omit<FieldAttributeConfig<T>, "type">,
>(
	type: T,
	config?: C,
) => {
	return {
		type,
		...config,
	} satisfies FieldAttribute<T>;
};

export type InferValueType<T extends FieldType> = T extends "string"
	? string
	: T extends "number"
		? number
		: T extends "boolean"
			? boolean
			: T extends "date"
				? Date
				: T extends `${infer T}[]`
					? T extends "string"
						? string[]
						: number[]
					: T extends Array<any>
						? T[number]
						: never;

export type InferFieldsOutput<Field> = Field extends Record<
	infer Key,
	FieldAttribute
>
	? {
			[key in Key as Field[key]["required"] extends false
				? Field[key]["defaultValue"] extends boolean | string | number | Date
					? key
					: never
				: key]: InferFieldOutput<Field[key]>;
		} & {
			[key in Key as Field[key]["returned"] extends false
				? never
				: key]?: InferFieldOutput<Field[key]> | null;
		}
	: {};

export type InferFieldsInput<Field> = Field extends Record<
	infer Key,
	FieldAttribute
>
	? {
			[key in Key as Field[key]["required"] extends false
				? never
				: Field[key]["defaultValue"] extends string | number | boolean | Date
					? never
					: Field[key]["input"] extends false
						? never
						: key]: InferFieldInput<Field[key]>;
		} & {
			[key in Key as Field[key]["input"] extends false ? never : key]?:
				| InferFieldInput<Field[key]>
				| undefined
				| null;
		}
	: {};

/**
 * For client will add "?" on optional fields
 */
export type InferFieldsInputClient<Field> = Field extends Record<
	infer Key,
	FieldAttribute
>
	? {
			[key in Key as Field[key]["required"] extends false
				? never
				: Field[key]["defaultValue"] extends string | number | boolean | Date
					? never
					: Field[key]["input"] extends false
						? never
						: key]: InferFieldInput<Field[key]>;
		} & {
			[key in Key as Field[key]["input"] extends false
				? never
				: Field[key]["required"] extends false
					? key
					: Field[key]["defaultValue"] extends string | number | boolean | Date
						? key
						: never]?: InferFieldInput<Field[key]> | undefined | null;
		}
	: {};

type InferFieldOutput<T extends FieldAttribute> = T["returned"] extends false
	? never
	: T["required"] extends false
		? InferValueType<T["type"]> | undefined | null
		: InferValueType<T["type"]>;

type InferFieldInput<T extends FieldAttribute> = InferValueType<T["type"]>;

export type PluginFieldAttribute = Omit<
	FieldAttribute,
	"transform" | "defaultValue" | "hashValue"
>;

export type InferFieldsFromPlugins<
	Options extends BetterAuthOptions,
	Key extends string,
	Format extends "output" | "input" = "output",
> = Options["plugins"] extends Array<infer T>
	? T extends {
			schema: {
				[key in Key]: {
					fields: infer Field;
				};
			};
		}
		? Format extends "output"
			? InferFieldsOutput<Field>
			: InferFieldsInput<Field>
		: {}
	: {};

export type InferFieldsFromOptions<
	Options extends BetterAuthOptions,
	Key extends "session" | "user",
	Format extends "output" | "input" = "output",
> = Options[Key] extends {
	additionalFields: infer Field;
}
	? Format extends "output"
		? InferFieldsOutput<Field>
		: InferFieldsInput<Field>
	: {};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/db/get-migration.ts
```typescript
import type {
	AlterTableColumnAlteringBuilder,
	CreateTableBuilder,
} from "kysely";
import type { FieldAttribute, FieldType } from ".";
import { createLogger } from "../utils/logger";
import type { BetterAuthOptions } from "../types";
import { createKyselyAdapter } from "../adapters/kysely-adapter/dialect";
import type { KyselyDatabaseType } from "../adapters/kysely-adapter/types";
import { getSchema } from "./get-schema";

const postgresMap = {
	string: ["character varying", "text"],
	number: [
		"int4",
		"integer",
		"bigint",
		"smallint",
		"numeric",
		"real",
		"double precision",
	],
	boolean: ["bool", "boolean"],
	date: ["timestamp", "date"],
};
const mysqlMap = {
	string: ["varchar", "text"],
	number: [
		"integer",
		"int",
		"bigint",
		"smallint",
		"decimal",
		"float",
		"double",
	],
	boolean: ["boolean", "tinyint"],
	date: ["timestamp", "datetime", "date"],
};

const sqliteMap = {
	string: ["TEXT"],
	number: ["INTEGER", "REAL"],
	boolean: ["INTEGER", "BOOLEAN"], // 0 or 1
	date: ["DATE", "INTEGER"],
};

const mssqlMap = {
	string: ["text", "varchar"],
	number: ["int", "bigint", "smallint", "decimal", "float", "double"],
	boolean: ["bit", "smallint"],
	date: ["datetime", "date"],
};

const map = {
	postgres: postgresMap,
	mysql: mysqlMap,
	sqlite: sqliteMap,
	mssql: mssqlMap,
};

export function matchType(
	columnDataType: string,
	fieldType: FieldType,
	dbType: KyselyDatabaseType,
) {
	if (fieldType === "string[]" || fieldType === "number[]") {
		return columnDataType.toLowerCase().includes("json");
	}
	const types = map[dbType];
	const type = Array.isArray(fieldType)
		? types["string"].map((t) => t.toLowerCase())
		: types[fieldType].map((t) => t.toLowerCase());
	const matches = type.includes(columnDataType.toLowerCase());
	return matches;
}

export async function getMigrations(config: BetterAuthOptions) {
	const betterAuthSchema = getSchema(config);
	const logger = createLogger(config.logger);

	let { kysely: db, databaseType: dbType } = await createKyselyAdapter(config);

	if (!dbType) {
		logger.warn(
			"Could not determine database type, defaulting to sqlite. Please provide a type in the database options to avoid this.",
		);
		dbType = "sqlite";
	}

	if (!db) {
		logger.error(
			"Only kysely adapter is supported for migrations. You can use `generate` command to generate the schema, if you're using a different adapter.",
		);
		process.exit(1);
	}
	const tableMetadata = await db.introspection.getTables();
	const toBeCreated: {
		table: string;
		fields: Record<string, FieldAttribute>;
		order: number;
	}[] = [];
	const toBeAdded: {
		table: string;
		fields: Record<string, FieldAttribute>;
		order: number;
	}[] = [];

	for (const [key, value] of Object.entries(betterAuthSchema)) {
		const table = tableMetadata.find((t) => t.name === key);
		if (!table) {
			const tIndex = toBeCreated.findIndex((t) => t.table === key);
			const tableData = {
				table: key,
				fields: value.fields,
				order: value.order || Infinity,
			};

			const insertIndex = toBeCreated.findIndex(
				(t) => (t.order || Infinity) > tableData.order,
			);

			if (insertIndex === -1) {
				if (tIndex === -1) {
					toBeCreated.push(tableData);
				} else {
					toBeCreated[tIndex].fields = {
						...toBeCreated[tIndex].fields,
						...value.fields,
					};
				}
			} else {
				toBeCreated.splice(insertIndex, 0, tableData);
			}
			continue;
		}
		let toBeAddedFields: Record<string, FieldAttribute> = {};
		for (const [fieldName, field] of Object.entries(value.fields)) {
			const column = table.columns.find((c) => c.name === fieldName);
			if (!column) {
				toBeAddedFields[fieldName] = field;
				continue;
			}

			if (matchType(column.dataType, field.type, dbType)) {
				continue;
			} else {
				logger.warn(
					`Field ${fieldName} in table ${key} has a different type in the database. Expected ${field.type} but got ${column.dataType}.`,
				);
			}
		}
		if (Object.keys(toBeAddedFields).length > 0) {
			toBeAdded.push({
				table: key,
				fields: toBeAddedFields,
				order: value.order || Infinity,
			});
		}
	}

	const migrations: (
		| AlterTableColumnAlteringBuilder
		| CreateTableBuilder<string, string>
	)[] = [];

	function getType(field: FieldAttribute) {
		const type = field.type;
		const typeMap = {
			string: {
				sqlite: "text",
				postgres: "text",
				mysql: field.unique
					? "varchar(255)"
					: field.references
						? "varchar(36)"
						: "text",
				mssql:
					field.unique || field.sortable
						? "varchar(255)"
						: field.references
							? "varchar(36)"
							: "text",
			},
			boolean: {
				sqlite: "integer",
				postgres: "boolean",
				mysql: "boolean",
				mssql: "smallint",
			},
			number: {
				sqlite: field.bigint ? "bigint" : "integer",
				postgres: field.bigint ? "bigint" : "integer",
				mysql: field.bigint ? "bigint" : "integer",
				mssql: field.bigint ? "bigint" : "integer",
			},
			date: {
				sqlite: "date",
				postgres: "timestamp",
				mysql: "datetime",
				mssql: "datetime",
			},
		} as const;
		if (dbType === "sqlite" && (type === "string[]" || type === "number[]")) {
			return "text";
		}
		if (type === "string[]" || type === "number[]") {
			return "jsonb";
		}
		if (Array.isArray(type)) {
			return "text";
		}
		return typeMap[type][dbType || "sqlite"];
	}
	if (toBeAdded.length) {
		for (const table of toBeAdded) {
			for (const [fieldName, field] of Object.entries(table.fields)) {
				const type = getType(field);
				const exec = db.schema
					.alterTable(table.table)
					.addColumn(fieldName, type, (col) => {
						col = field.required !== false ? col.notNull() : col;
						if (field.references) {
							col = col.references(
								`${field.references.model}.${field.references.field}`,
							);
						}
						if (field.unique) {
							col = col.unique();
						}
						return col;
					});
				migrations.push(exec);
			}
		}
	}
	if (toBeCreated.length) {
		for (const table of toBeCreated) {
			let dbT = db.schema
				.createTable(table.table)
				.addColumn(
					"id",
					dbType === "mysql" || dbType === "mssql" ? "varchar(36)" : "text",
					(col) => col.primaryKey().notNull(),
				);

			for (const [fieldName, field] of Object.entries(table.fields)) {
				const type = getType(field);
				dbT = dbT.addColumn(fieldName, type, (col) => {
					col = field.required !== false ? col.notNull() : col;
					if (field.references) {
						col = col.references(
							`${field.references.model}.${field.references.field}`,
						);
					}
					if (field.unique) {
						col = col.unique();
					}
					return col;
				});
			}
			migrations.push(dbT);
		}
	}
	async function runMigrations() {
		for (const migration of migrations) {
			await migration.execute();
		}
	}
	async function compileMigrations() {
		const compiled = migrations.map((m) => m.compile().sql);
		return compiled.join(";\n\n") + ";";
	}
	return { toBeCreated, toBeAdded, runMigrations, compileMigrations };
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/db/get-schema.ts
```typescript
import { getAuthTables, type FieldAttribute } from ".";
import type { BetterAuthOptions } from "../types";

export function getSchema(config: BetterAuthOptions) {
	const tables = getAuthTables(config);
	let schema: Record<
		string,
		{
			fields: Record<string, FieldAttribute>;
			order: number;
		}
	> = {};
	for (const key in tables) {
		const table = tables[key];
		const fields = table.fields;
		let actualFields: Record<string, FieldAttribute> = {};
		Object.entries(fields).forEach(([key, field]) => {
			actualFields[field.fieldName || key] = field;
			if (field.references) {
				const refTable = tables[field.references.model];
				if (refTable) {
					actualFields[field.fieldName || key].references = {
						model: refTable.modelName,
						field: field.references.field,
					};
				}
			}
		});
		if (schema[table.modelName]) {
			schema[table.modelName].fields = {
				...schema[table.modelName].fields,
				...actualFields,
			};
			continue;
		}
		schema[table.modelName] = {
			fields: actualFields,
			order: table.order || Infinity,
		};
	}
	return schema;
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/db/get-tables.ts
```typescript
import type { FieldAttribute } from ".";
import type { BetterAuthOptions } from "../types";

export type BetterAuthDbSchema = Record<
	string,
	{
		/**
		 * The name of the table in the database
		 */
		modelName: string;
		/**
		 * The fields of the table
		 */
		fields: Record<string, FieldAttribute>;
		/**
		 * Whether to disable migrations for this table
		 * @default false
		 */
		disableMigrations?: boolean;
		/**
		 * The order of the table
		 */
		order?: number;
	}
>;

export const getAuthTables = (
	options: BetterAuthOptions,
): BetterAuthDbSchema => {
	const pluginSchema = options.plugins?.reduce(
		(acc, plugin) => {
			const schema = plugin.schema;
			if (!schema) return acc;
			for (const [key, value] of Object.entries(schema)) {
				acc[key] = {
					fields: {
						...acc[key]?.fields,
						...value.fields,
					},
					modelName: value.modelName || key,
				};
			}
			return acc;
		},
		{} as Record<
			string,
			{ fields: Record<string, FieldAttribute>; modelName: string }
		>,
	);

	const shouldAddRateLimitTable = options.rateLimit?.storage === "database";
	const rateLimitTable = {
		rateLimit: {
			modelName: options.rateLimit?.modelName || "rateLimit",
			fields: {
				key: {
					type: "string",
					fieldName: options.rateLimit?.fields?.key || "key",
				},
				count: {
					type: "number",
					fieldName: options.rateLimit?.fields?.count || "count",
				},
				lastRequest: {
					type: "number",
					bigint: true,
					fieldName: options.rateLimit?.fields?.lastRequest || "lastRequest",
				},
			},
		},
	} satisfies BetterAuthDbSchema;

	const { user, session, account, ...pluginTables } = pluginSchema || {};

	const sessionTable = {
		session: {
			modelName: options.session?.modelName || "session",
			fields: {
				expiresAt: {
					type: "date",
					required: true,
					fieldName: options.session?.fields?.expiresAt || "expiresAt",
				},
				token: {
					type: "string",
					required: true,
					fieldName: options.session?.fields?.token || "token",
					unique: true,
				},
				createdAt: {
					type: "date",
					required: true,
					fieldName: options.session?.fields?.createdAt || "createdAt",
				},
				updatedAt: {
					type: "date",
					required: true,
					fieldName: options.session?.fields?.updatedAt || "updatedAt",
				},
				ipAddress: {
					type: "string",
					required: false,
					fieldName: options.session?.fields?.ipAddress || "ipAddress",
				},
				userAgent: {
					type: "string",
					required: false,
					fieldName: options.session?.fields?.userAgent || "userAgent",
				},
				userId: {
					type: "string",
					fieldName: options.session?.fields?.userId || "userId",
					references: {
						model: options.user?.modelName || "user",
						field: "id",
						onDelete: "cascade",
					},
					required: true,
				},
				...session?.fields,
				...options.session?.additionalFields,
			},
			order: 2,
		},
	} satisfies BetterAuthDbSchema;

	return {
		user: {
			modelName: options.user?.modelName || "user",
			fields: {
				name: {
					type: "string",
					required: true,
					fieldName: options.user?.fields?.name || "name",
					sortable: true,
				},
				email: {
					type: "string",
					unique: true,
					required: true,
					fieldName: options.user?.fields?.email || "email",
					sortable: true,
				},
				emailVerified: {
					type: "boolean",
					defaultValue: () => false,
					required: true,
					fieldName: options.user?.fields?.emailVerified || "emailVerified",
				},
				image: {
					type: "string",
					required: false,
					fieldName: options.user?.fields?.image || "image",
				},
				createdAt: {
					type: "date",
					defaultValue: () => new Date(),
					required: true,
					fieldName: options.user?.fields?.createdAt || "createdAt",
				},
				updatedAt: {
					type: "date",
					defaultValue: () => new Date(),
					required: true,
					fieldName: options.user?.fields?.updatedAt || "updatedAt",
				},
				...user?.fields,
				...options.user?.additionalFields,
			},
			order: 1,
		},
		//only add session table if it's not stored in secondary storage
		...(!options.secondaryStorage || options.session?.storeSessionInDatabase
			? sessionTable
			: {}),
		account: {
			modelName: options.account?.modelName || "account",
			fields: {
				accountId: {
					type: "string",
					required: true,
					fieldName: options.account?.fields?.accountId || "accountId",
				},
				providerId: {
					type: "string",
					required: true,
					fieldName: options.account?.fields?.providerId || "providerId",
				},
				userId: {
					type: "string",
					references: {
						model: options.user?.modelName || "user",
						field: "id",
						onDelete: "cascade",
					},
					required: true,
					fieldName: options.account?.fields?.userId || "userId",
				},
				accessToken: {
					type: "string",
					required: false,
					fieldName: options.account?.fields?.accessToken || "accessToken",
				},
				refreshToken: {
					type: "string",
					required: false,
					fieldName: options.account?.fields?.refreshToken || "refreshToken",
				},
				idToken: {
					type: "string",
					required: false,
					fieldName: options.account?.fields?.idToken || "idToken",
				},
				accessTokenExpiresAt: {
					type: "date",
					required: false,
					fieldName:
						options.account?.fields?.accessTokenExpiresAt ||
						"accessTokenExpiresAt",
				},
				refreshTokenExpiresAt: {
					type: "date",
					required: false,
					fieldName:
						options.account?.fields?.accessTokenExpiresAt ||
						"refreshTokenExpiresAt",
				},
				scope: {
					type: "string",
					required: false,
					fieldName: options.account?.fields?.scope || "scope",
				},
				password: {
					type: "string",
					required: false,
					fieldName: options.account?.fields?.password || "password",
				},
				createdAt: {
					type: "date",
					required: true,
					fieldName: options.account?.fields?.createdAt || "createdAt",
				},
				updatedAt: {
					type: "date",
					required: true,
					fieldName: options.account?.fields?.updatedAt || "updatedAt",
				},
				...account?.fields,
			},
			order: 3,
		},
		verification: {
			modelName: options.verification?.modelName || "verification",
			fields: {
				identifier: {
					type: "string",
					required: true,
					fieldName: options.verification?.fields?.identifier || "identifier",
				},
				value: {
					type: "string",
					required: true,
					fieldName: options.verification?.fields?.value || "value",
				},
				expiresAt: {
					type: "date",
					required: true,
					fieldName: options.verification?.fields?.expiresAt || "expiresAt",
				},
				createdAt: {
					type: "date",
					required: false,
					defaultValue: () => new Date(),
					fieldName: options.verification?.fields?.createdAt || "createdAt",
				},
				updatedAt: {
					type: "date",
					required: false,
					defaultValue: () => new Date(),
					fieldName: options.verification?.fields?.updatedAt || "updatedAt",
				},
			},
			order: 4,
		},
		...pluginTables,
		...(shouldAddRateLimitTable ? rateLimitTable : {}),
	} satisfies BetterAuthDbSchema;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/db/index.ts
```typescript
export * from "./internal-adapter";
export * from "./field";
export * from "./get-tables";
export * from "./with-hooks";
export * from "./to-zod";
export * from "./utils";
export * from "./get-migration";
export * from "./get-schema";
export * from "./schema";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/db/internal-adapter.test.ts
```typescript
import { beforeAll, expect, it, describe, vi, afterEach } from "vitest";
import type { BetterAuthOptions, BetterAuthPlugin } from "../types";
import Database from "better-sqlite3";
import { init } from "../init";
import { getMigrations } from "./get-migration";
import { SqliteDialect } from "kysely";
import { getTestInstance } from "../test-utils/test-instance";

describe("adapter test", async () => {
	const sqliteDialect = new SqliteDialect({
		database: new Database(":memory:"),
	});
	const map = new Map();
	let id = 1;
	const hookUserCreateBefore = vi.fn();
	const hookUserCreateAfter = vi.fn();
	const pluginHookUserCreateBefore = vi.fn();
	const pluginHookUserCreateAfter = vi.fn();
	const opts = {
		database: {
			dialect: sqliteDialect,
			type: "sqlite",
		},
		user: {
			fields: {
				email: "email_address",
				emailVerified: "email_verified",
			},
		},
		secondaryStorage: {
			set(key, value, ttl) {
				map.set(key, value);
			},
			get(key) {
				return map.get(key);
			},
			delete(key) {
				map.delete(key);
			},
		},
		advanced: {
			generateId() {
				return (id++).toString();
			},
		},
		databaseHooks: {
			user: {
				create: {
					async before(user, context) {
						hookUserCreateBefore(user, context);
						return { data: user };
					},
					async after(user, context) {
						hookUserCreateAfter(user, context);
						return;
					},
				},
			},
		},
		plugins: [
			{
				id: "test-plugin",
				init(ctx) {
					return {
						options: {
							databaseHooks: {
								user: {
									create: {
										async before(user, context) {
											pluginHookUserCreateBefore(user, context);
											return { data: user };
										},
										async after(user, context) {
											pluginHookUserCreateAfter(user, context);
										},
									},
								},
								session: {
									create: {
										before: async (session) => {
											return {
												data: {
													...session,
													activeOrganizationId: "1",
												},
											};
										},
									},
								},
							},
						},
					};
				},
			} satisfies BetterAuthPlugin,
		],
	} satisfies BetterAuthOptions;
	beforeAll(async () => {
		(await getMigrations(opts)).runMigrations();
	});
	afterEach(async () => {
		vi.clearAllMocks();
	});
	const ctx = await init(opts);
	const internalAdapter = ctx.internalAdapter;

	it("should create oauth user with custom generate id", async () => {
		const user = await internalAdapter.createOAuthUser(
			{
				email: "email@email.com",
				name: "name",
				emailVerified: false,
			},
			{
				providerId: "provider",
				accountId: "account",
				accessTokenExpiresAt: new Date(),
				refreshTokenExpiresAt: new Date(),
				createdAt: new Date(),
				updatedAt: new Date(),
			},
		);
		expect(user).toMatchObject({
			user: {
				id: "1",
				name: "name",
				email: "email@email.com",
				emailVerified: false,
				image: null,
				createdAt: expect.any(Date),
				updatedAt: expect.any(Date),
			},
			account: {
				id: "2",
				userId: expect.any(String),
				providerId: "provider",
				accountId: "account",
				accessToken: null,
				refreshToken: null,
				refreshTokenExpiresAt: expect.any(Date),
				accessTokenExpiresAt: expect.any(Date),
			},
		});
		expect(user?.user.id).toBe(user?.account.userId);
		expect(pluginHookUserCreateAfter).toHaveBeenCalledOnce();
		expect(pluginHookUserCreateBefore).toHaveBeenCalledOnce();
		expect(hookUserCreateAfter).toHaveBeenCalledOnce();
		expect(hookUserCreateBefore).toHaveBeenCalledOnce();
	});
	it("should find session with custom userId", async () => {
		const { client, signInWithTestUser } = await getTestInstance({
			session: {
				fields: {
					userId: "user_id",
				},
			},
		});
		const { headers } = await signInWithTestUser();
		const session = await client.getSession({
			fetchOptions: {
				headers,
			},
		});
		expect(session.data?.session).toBeDefined();
	});

	it("should delete expired verification values on find", async () => {
		await internalAdapter.createVerificationValue({
			identifier: `test-id-1`,
			value: "test-id-1",
			expiresAt: new Date(Date.now() - 1000),
		});
		const value = await internalAdapter.findVerificationValue("test-id-1");
		expect(value).toMatchObject({
			identifier: "test-id-1",
		});
		const value2 = await internalAdapter.findVerificationValue("test-id-1");
		expect(value2).toBe(undefined);
		await internalAdapter.createVerificationValue({
			identifier: `test-id-1`,
			value: "test-id-1",
			expiresAt: new Date(Date.now() + 1000),
		});
		const value3 = await internalAdapter.findVerificationValue("test-id-1");
		expect(value3).toMatchObject({
			identifier: "test-id-1",
		});
		const value4 = await internalAdapter.findVerificationValue("test-id-1");
		expect(value4).toMatchObject({
			identifier: "test-id-1",
		});
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/db/internal-adapter.ts
```typescript
import { getDate } from "../utils/date";
import { parseSessionOutput, parseUserOutput } from "./schema";
import {
	type Account,
	type Session,
	type User,
	type Verification,
} from "../types";
import { getWithHooks } from "./with-hooks";
import { getIp } from "../utils/get-request-ip";
import { safeJSONParse } from "../utils/json";
import { generateId } from "../utils";
import type {
	Adapter,
	AuthContext,
	BetterAuthOptions,
	GenericEndpointContext,
	Where,
} from "../types";

export const createInternalAdapter = (
	adapter: Adapter,
	ctx: {
		options: BetterAuthOptions;
		hooks: Exclude<BetterAuthOptions["databaseHooks"], undefined>[];
		generateId: AuthContext["generateId"];
	},
) => {
	const options = ctx.options;
	const secondaryStorage = options.secondaryStorage;
	const sessionExpiration = options.session?.expiresIn || 60 * 60 * 24 * 7; // 7 days
	const { createWithHooks, updateWithHooks, updateManyWithHooks } =
		getWithHooks(adapter, ctx);

	return {
		createOAuthUser: async (
			user: Omit<User, "id" | "createdAt" | "updatedAt"> & Partial<User>,
			account: Omit<Account, "userId" | "id" | "createdAt" | "updatedAt"> &
				Partial<Account>,
			context?: GenericEndpointContext,
		) => {
			const createdUser = await createWithHooks(
				{
					createdAt: new Date(),
					updatedAt: new Date(),
					...user,
				},
				"user",
				undefined,
				context,
			);
			const createdAccount = await createWithHooks(
				{
					...account,
					userId: createdUser.id || user.id,
					createdAt: new Date(),
					updatedAt: new Date(),
				},
				"account",
				undefined,
				context,
			);
			return {
				user: createdUser,
				account: createdAccount,
			};
		},
		createUser: async <T>(
			user: Omit<User, "id" | "createdAt" | "updatedAt" | "emailVerified"> &
				Partial<User> &
				Record<string, any>,
			context?: GenericEndpointContext,
		) => {
			const createdUser = await createWithHooks(
				{
					createdAt: new Date(),
					updatedAt: new Date(),
					emailVerified: false,
					...user,
					email: user.email?.toLowerCase(),
				},
				"user",
				undefined,
				context,
			);
			return createdUser as T & User;
		},
		createAccount: async <T>(
			account: Omit<Account, "id" | "createdAt" | "updatedAt"> &
				Partial<Account> &
				Record<string, any>,
			context?: GenericEndpointContext,
		) => {
			const createdAccount = await createWithHooks(
				{
					createdAt: new Date(),
					updatedAt: new Date(),
					...account,
				},
				"account",
				undefined,
				context,
			);
			return createdAccount as T & Account;
		},
		listSessions: async (userId: string) => {
			if (secondaryStorage) {
				const currentList = await secondaryStorage.get(
					`active-sessions-${userId}`,
				);
				if (!currentList) return [];

				const list: { token: string; expiresAt: number }[] =
					safeJSONParse(currentList) || [];
				const now = Date.now();

				const validSessions = list.filter((s) => s.expiresAt > now);
				const sessions = [];

				for (const session of validSessions) {
					const sessionStringified = await secondaryStorage.get(session.token);
					if (sessionStringified) {
						const s = JSON.parse(sessionStringified);
						const parsedSession = parseSessionOutput(ctx.options, {
							...s.session,
							expiresAt: new Date(s.session.expiresAt),
						});
						sessions.push(parsedSession);
					}
				}
				return sessions;
			}

			const sessions = await adapter.findMany<Session>({
				model: "session",
				where: [
					{
						field: "userId",
						value: userId,
					},
				],
			});
			return sessions;
		},
		listUsers: async (
			limit?: number,
			offset?: number,
			sortBy?: {
				field: string;
				direction: "asc" | "desc";
			},
			where?: Where[],
		) => {
			const users = await adapter.findMany<User>({
				model: "user",
				limit,
				offset,
				sortBy,
				where,
			});
			return users;
		},
		countTotalUsers: async (where?: Where[]) => {
			const total = await adapter.count({
				model: "user",
				where,
			});
			return total;
		},
		deleteUser: async (userId: string) => {
			if (secondaryStorage) {
				await secondaryStorage.delete(`active-sessions-${userId}`);
			}

			if (!secondaryStorage || options.session?.storeSessionInDatabase) {
				await adapter.deleteMany({
					model: "session",
					where: [
						{
							field: "userId",
							value: userId,
						},
					],
				});
			}

			await adapter.deleteMany({
				model: "account",
				where: [
					{
						field: "userId",
						value: userId,
					},
				],
			});
			await adapter.delete({
				model: "user",
				where: [
					{
						field: "id",
						value: userId,
					},
				],
			});
		},
		createSession: async (
			userId: string,
			request: Request | Headers | undefined,
			dontRememberMe?: boolean,
			override?: Partial<Session> & Record<string, any>,
			context?: GenericEndpointContext,
			overrideAll?: boolean,
		) => {
			const headers =
				request && "headers" in request ? request.headers : request;
			const { id: _, ...rest } = override || {};
			const data: Omit<Session, "id"> = {
				ipAddress: request ? getIp(request, ctx.options) || "" : "",
				userAgent: headers?.get("user-agent") || "",
				...rest,
				/**
				 * If the user doesn't want to be remembered
				 * set the session to expire in 1 day.
				 * The cookie will be set to expire at the end of the session
				 */
				expiresAt: dontRememberMe
					? getDate(60 * 60 * 24, "sec") // 1 day
					: getDate(sessionExpiration, "sec"),
				userId,
				token: generateId(32),
				createdAt: new Date(),
				updatedAt: new Date(),
				...(overrideAll ? rest : {}),
			};
			const res = await createWithHooks(
				data,
				"session",
				secondaryStorage
					? {
							fn: async (sessionData) => {
								/**
								 * store the session token for the user
								 * so we can retrieve it later for listing sessions
								 */
								const currentList = await secondaryStorage.get(
									`active-sessions-${userId}`,
								);

								let list: { token: string; expiresAt: number }[] = [];
								const now = Date.now();

								if (currentList) {
									list = safeJSONParse(currentList) || [];
									list = list.filter((session) => session.expiresAt > now);
								}

								list.push({
									token: data.token,
									expiresAt: now + sessionExpiration * 1000,
								});

								await secondaryStorage.set(
									`active-sessions-${userId}`,
									JSON.stringify(list),
									sessionExpiration,
								);

								return sessionData;
							},
							executeMainFn: options.session?.storeSessionInDatabase,
						}
					: undefined,
				context,
			);
			return res as Session;
		},
		findSession: async (
			token: string,
		): Promise<{
			session: Session & Record<string, any>;
			user: User & Record<string, any>;
		} | null> => {
			if (secondaryStorage) {
				const sessionStringified = await secondaryStorage.get(token);
				if (!sessionStringified && !options.session?.storeSessionInDatabase) {
					return null;
				}
				if (sessionStringified) {
					const s = JSON.parse(sessionStringified);
					const parsedSession = parseSessionOutput(ctx.options, {
						...s.session,
						expiresAt: new Date(s.session.expiresAt),
						createdAt: new Date(s.session.createdAt),
						updatedAt: new Date(s.session.updatedAt),
					});
					const parsedUser = parseUserOutput(ctx.options, {
						...s.user,
						createdAt: new Date(s.user.createdAt),
						updatedAt: new Date(s.user.updatedAt),
					});
					return {
						session: parsedSession,
						user: parsedUser,
					};
				}
			}

			const session = await adapter.findOne<Session>({
				model: "session",
				where: [
					{
						value: token,
						field: "token",
					},
				],
			});

			if (!session) {
				return null;
			}

			const user = await adapter.findOne<User>({
				model: "user",
				where: [
					{
						value: session.userId,
						field: "id",
					},
				],
			});
			if (!user) {
				return null;
			}
			const parsedSession = parseSessionOutput(ctx.options, session);
			const parsedUser = parseUserOutput(ctx.options, user);

			return {
				session: parsedSession,
				user: parsedUser,
			};
		},
		findSessions: async (sessionTokens: string[]) => {
			if (secondaryStorage) {
				const sessions: {
					session: Session;
					user: User;
				}[] = [];
				for (const sessionToken of sessionTokens) {
					const sessionStringified = await secondaryStorage.get(sessionToken);
					if (sessionStringified) {
						const s = JSON.parse(sessionStringified);
						const session = {
							session: {
								...s.session,
								expiresAt: new Date(s.session.expiresAt),
							},
							user: {
								...s.user,
								createdAt: new Date(s.user.createdAt),
								updatedAt: new Date(s.user.updatedAt),
							},
						} as {
							session: Session;
							user: User;
						};
						sessions.push(session);
					}
				}
				return sessions;
			}

			const sessions = await adapter.findMany<Session>({
				model: "session",
				where: [
					{
						field: "token",
						value: sessionTokens,
						operator: "in",
					},
				],
			});
			const userIds = sessions.map((session) => {
				return session.userId;
			});
			if (!userIds.length) return [];
			const users = await adapter.findMany<User>({
				model: "user",
				where: [
					{
						field: "id",
						value: userIds,
						operator: "in",
					},
				],
			});
			return sessions.map((session) => {
				const user = users.find((u) => u.id === session.userId);
				if (!user) return null;
				return {
					session,
					user,
				};
			}) as {
				session: Session;
				user: User;
			}[];
		},
		updateSession: async (
			sessionToken: string,
			session: Partial<Session> & Record<string, any>,
			context?: GenericEndpointContext,
		) => {
			const updatedSession = await updateWithHooks<Session>(
				session,
				[{ field: "token", value: sessionToken }],
				"session",
				secondaryStorage
					? {
							async fn(data) {
								const currentSession = await secondaryStorage.get(sessionToken);
								let updatedSession: Session | null = null;
								if (currentSession) {
									const parsedSession = JSON.parse(currentSession) as {
										session: Session;
										user: User;
									};
									updatedSession = {
										...parsedSession.session,
										...data,
									};
									return updatedSession;
								} else {
									return null;
								}
							},
							executeMainFn: options.session?.storeSessionInDatabase,
						}
					: undefined,
				context,
			);
			return updatedSession;
		},
		deleteSession: async (token: string) => {
			if (secondaryStorage) {
				await secondaryStorage.delete(token);

				if (
					!options.session?.storeSessionInDatabase ||
					ctx.options.session?.preserveSessionInDatabase
				) {
					return;
				}
			}
			await adapter.delete<Session>({
				model: "session",
				where: [
					{
						field: "token",
						value: token,
					},
				],
			});
		},
		deleteAccounts: async (userId: string) => {
			await adapter.deleteMany({
				model: "account",
				where: [
					{
						field: "userId",
						value: userId,
					},
				],
			});
		},
		deleteAccount: async (accountId: string) => {
			await adapter.delete({
				model: "account",
				where: [
					{
						field: "id",
						value: accountId,
					},
				],
			});
		},
		deleteSessions: async (userIdOrSessionTokens: string | string[]) => {
			if (secondaryStorage) {
				if (typeof userIdOrSessionTokens === "string") {
					const activeSession = await secondaryStorage.get(
						`active-sessions-${userIdOrSessionTokens}`,
					);
					const sessions = activeSession
						? safeJSONParse<{ token: string }[]>(activeSession)
						: [];
					if (!sessions) return;
					for (const session of sessions) {
						await secondaryStorage.delete(session.token);
					}
				} else {
					for (const sessionToken of userIdOrSessionTokens) {
						const session = await secondaryStorage.get(sessionToken);
						if (session) {
							await secondaryStorage.delete(sessionToken);
						}
					}
				}

				if (
					!options.session?.storeSessionInDatabase ||
					ctx.options.session?.preserveSessionInDatabase
				) {
					return;
				}
			}
			await adapter.deleteMany({
				model: "session",
				where: [
					{
						field: Array.isArray(userIdOrSessionTokens) ? "token" : "userId",
						value: userIdOrSessionTokens,
						operator: Array.isArray(userIdOrSessionTokens) ? "in" : undefined,
					},
				],
			});
		},
		findOAuthUser: async (
			email: string,
			accountId: string,
			providerId: string,
		) => {
			const account = await adapter.findOne<Account>({
				model: "account",
				where: [
					{
						value: accountId,
						field: "accountId",
					},
					{
						value: providerId,
						field: "providerId",
					},
				],
			});
			if (account) {
				const user = await adapter.findOne<User>({
					model: "user",
					where: [
						{
							value: account.userId,
							field: "id",
						},
					],
				});
				if (user) {
					return {
						user,
						accounts: [account],
					};
				} else {
					return null;
				}
			} else {
				const user = await adapter.findOne<User>({
					model: "user",
					where: [
						{
							value: email.toLowerCase(),
							field: "email",
						},
					],
				});
				if (user) {
					const accounts = await adapter.findMany<Account>({
						model: "account",
						where: [
							{
								value: user.id,
								field: "userId",
							},
						],
					});
					return {
						user,
						accounts: accounts || [],
					};
				} else {
					return null;
				}
			}
		},
		findUserByEmail: async (
			email: string,
			options?: { includeAccounts: boolean },
		) => {
			const user = await adapter.findOne<User>({
				model: "user",
				where: [
					{
						value: email.toLowerCase(),
						field: "email",
					},
				],
			});
			if (!user) return null;
			if (options?.includeAccounts) {
				const accounts = await adapter.findMany<Account>({
					model: "account",
					where: [
						{
							value: user.id,
							field: "userId",
						},
					],
				});
				return {
					user,
					accounts,
				};
			}
			return {
				user,
				accounts: [],
			};
		},
		findUserById: async (userId: string) => {
			const user = await adapter.findOne<User>({
				model: "user",
				where: [
					{
						field: "id",
						value: userId,
					},
				],
			});
			return user;
		},
		linkAccount: async (
			account: Omit<Account, "id" | "createdAt" | "updatedAt"> &
				Partial<Account>,
			context?: GenericEndpointContext,
		) => {
			const _account = await createWithHooks(
				{
					...account,
					createdAt: new Date(),
					updatedAt: new Date(),
				},
				"account",
				undefined,
				context,
			);
			return _account;
		},
		updateUser: async (
			userId: string,
			data: Partial<User> & Record<string, any>,
			context?: GenericEndpointContext,
		) => {
			const user = await updateWithHooks<User>(
				data,
				[
					{
						field: "id",
						value: userId,
					},
				],
				"user",
				undefined,
				context,
			);
			return user;
		},
		updateUserByEmail: async (
			email: string,
			data: Partial<User & Record<string, any>>,
			context?: GenericEndpointContext,
		) => {
			const user = await updateWithHooks<User>(
				data,
				[
					{
						field: "email",
						value: email.toLowerCase(),
					},
				],
				"user",
				undefined,
				context,
			);
			return user;
		},
		updatePassword: async (
			userId: string,
			password: string,
			context?: GenericEndpointContext,
		) => {
			await updateManyWithHooks(
				{
					password,
				},
				[
					{
						field: "userId",
						value: userId,
					},
					{
						field: "providerId",
						value: "credential",
					},
				],
				"account",
				undefined,
				context,
			);
		},
		findAccounts: async (userId: string) => {
			const accounts = await adapter.findMany<Account>({
				model: "account",
				where: [
					{
						field: "userId",
						value: userId,
					},
				],
			});
			return accounts;
		},
		findAccount: async (accountId: string) => {
			const account = await adapter.findOne<Account>({
				model: "account",
				where: [
					{
						field: "accountId",
						value: accountId,
					},
				],
			});
			return account;
		},
		findAccountByUserId: async (userId: string) => {
			const account = await adapter.findMany<Account>({
				model: "account",
				where: [
					{
						field: "userId",
						value: userId,
					},
				],
			});
			return account;
		},
		updateAccount: async (
			accountId: string,
			data: Partial<Account>,
			context?: GenericEndpointContext,
		) => {
			const account = await updateWithHooks<Account>(
				data,
				[{ field: "id", value: accountId }],
				"account",
				undefined,
				context,
			);
			return account;
		},
		createVerificationValue: async (
			data: Omit<Verification, "createdAt" | "id" | "updatedAt"> &
				Partial<Verification>,
			context?: GenericEndpointContext,
		) => {
			const verification = await createWithHooks(
				{
					createdAt: new Date(),
					updatedAt: new Date(),
					...data,
				},
				"verification",
				undefined,
				context,
			);
			return verification as Verification;
		},
		findVerificationValue: async (identifier: string) => {
			const verification = await adapter.findMany<Verification>({
				model: "verification",
				where: [
					{
						field: "identifier",
						value: identifier,
					},
				],
				sortBy: {
					field: "createdAt",
					direction: "desc",
				},
				limit: 1,
			});
			if (!options.verification?.disableCleanup) {
				await adapter.deleteMany({
					model: "verification",
					where: [
						{
							field: "expiresAt",
							value: new Date(),
							operator: "lt",
						},
					],
				});
			}
			const lastVerification = verification[0];
			return lastVerification as Verification | null;
		},
		deleteVerificationValue: async (id: string) => {
			await adapter.delete<Verification>({
				model: "verification",
				where: [
					{
						field: "id",
						value: id,
					},
				],
			});
		},
		deleteVerificationByIdentifier: async (identifier: string) => {
			await adapter.delete<Verification>({
				model: "verification",
				where: [
					{
						field: "identifier",
						value: identifier,
					},
				],
			});
		},
		updateVerificationValue: async (
			id: string,
			data: Partial<Verification>,
			context?: GenericEndpointContext,
		) => {
			const verification = await updateWithHooks<Verification>(
				data,
				[{ field: "id", value: id }],
				"verification",
				undefined,
				context,
			);
			return verification;
		},
	};
};

export type InternalAdapter = ReturnType<typeof createInternalAdapter>;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/db/schema.ts
```typescript
import { z } from "zod";
import type { FieldAttribute } from ".";
import type { AuthPluginSchema } from "../types/plugins";
import type { BetterAuthOptions } from "../types/options";
import { APIError } from "better-call";
import type { Account, Session, User } from "../types";

export const accountSchema = z.object({
	id: z.string(),
	providerId: z.string(),
	accountId: z.string(),
	userId: z.coerce.string(),
	accessToken: z.string().nullish(),
	refreshToken: z.string().nullish(),
	idToken: z.string().nullish(),
	/**
	 * Access token expires at
	 */
	accessTokenExpiresAt: z.date().nullish(),
	/**
	 * Refresh token expires at
	 */
	refreshTokenExpiresAt: z.date().nullish(),
	/**
	 * The scopes that the user has authorized
	 */
	scope: z.string().nullish(),
	/**
	 * Password is only stored in the credential provider
	 */
	password: z.string().nullish(),
	createdAt: z.date().default(() => new Date()),
	updatedAt: z.date().default(() => new Date()),
});

export const userSchema = z.object({
	id: z.string(),
	email: z.string().transform((val) => val.toLowerCase()),
	emailVerified: z.boolean().default(false),
	name: z.string(),
	image: z.string().nullish(),
	createdAt: z.date().default(() => new Date()),
	updatedAt: z.date().default(() => new Date()),
});

export const sessionSchema = z.object({
	id: z.string(),
	userId: z.coerce.string(),
	expiresAt: z.date(),
	createdAt: z.date().default(() => new Date()),
	updatedAt: z.date().default(() => new Date()),
	token: z.string(),
	ipAddress: z.string().nullish(),
	userAgent: z.string().nullish(),
});

export const verificationSchema = z.object({
	id: z.string(),
	value: z.string(),
	createdAt: z.date().default(() => new Date()),
	updatedAt: z.date().default(() => new Date()),
	expiresAt: z.date(),
	identifier: z.string(),
	nonce: z.string().nullish(),
});

export function parseOutputData<T extends Record<string, any>>(
	data: T,
	schema: {
		fields: Record<string, FieldAttribute>;
	},
) {
	const fields = schema.fields;
	const parsedData: Record<string, any> = {};
	for (const key in data) {
		const field = fields[key];
		if (!field) {
			parsedData[key] = data[key];
			continue;
		}
		if (field.returned === false) {
			continue;
		}
		parsedData[key] = data[key];
	}
	return parsedData as T;
}

export function getAllFields(options: BetterAuthOptions, table: string) {
	let schema: Record<string, FieldAttribute> = {
		...(table === "user" ? options.user?.additionalFields : {}),
		...(table === "session" ? options.session?.additionalFields : {}),
	};
	for (const plugin of options.plugins || []) {
		if (plugin.schema && plugin.schema[table]) {
			schema = {
				...schema,
				...plugin.schema[table].fields,
			};
		}
	}
	return schema;
}

export function parseUserOutput(options: BetterAuthOptions, user: User) {
	const schema = getAllFields(options, "user");
	return parseOutputData(user, { fields: schema });
}

export function parseAccountOutput(
	options: BetterAuthOptions,
	account: Account,
) {
	const schema = getAllFields(options, "account");
	return parseOutputData(account, { fields: schema });
}

export function parseSessionOutput(
	options: BetterAuthOptions,
	session: Session,
) {
	const schema = getAllFields(options, "session");
	return parseOutputData(session, { fields: schema });
}

export function parseInputData<T extends Record<string, any>>(
	data: T,
	schema: {
		fields: Record<string, FieldAttribute>;
		action?: "create" | "update";
	},
) {
	const action = schema.action || "create";
	const fields = schema.fields;
	const parsedData: Record<string, any> = {};
	for (const key in fields) {
		if (key in data) {
			if (fields[key].input === false) {
				if (fields[key].defaultValue) {
					parsedData[key] = fields[key].defaultValue;
					continue;
				}
				continue;
			}
			if (fields[key].validator?.input && data[key] !== undefined) {
				parsedData[key] = fields[key].validator.input.parse(data[key]);
				continue;
			}
			if (fields[key].transform?.input && data[key] !== undefined) {
				parsedData[key] = fields[key].transform?.input(data[key]);
				continue;
			}
			parsedData[key] = data[key];
			continue;
		}

		if (fields[key].defaultValue && action === "create") {
			parsedData[key] = fields[key].defaultValue;
			continue;
		}

		if (fields[key].required && action === "create") {
			throw new APIError("BAD_REQUEST", {
				message: `${key} is required`,
			});
		}
	}
	return parsedData as Partial<T>;
}

export function parseUserInput(
	options: BetterAuthOptions,
	user?: Record<string, any>,
	action?: "create" | "update",
) {
	const schema = getAllFields(options, "user");
	return parseInputData(user || {}, { fields: schema, action });
}

export function parseAdditionalUserInput(
	options: BetterAuthOptions,
	user?: Record<string, any>,
) {
	const schema = getAllFields(options, "user");
	return parseInputData(user || {}, { fields: schema });
}

export function parseAccountInput(
	options: BetterAuthOptions,
	account: Partial<Account>,
) {
	const schema = getAllFields(options, "account");
	return parseInputData(account, { fields: schema });
}

export function parseSessionInput(
	options: BetterAuthOptions,
	session: Partial<Session>,
) {
	const schema = getAllFields(options, "session");
	return parseInputData(session, { fields: schema });
}

export function mergeSchema<S extends AuthPluginSchema>(
	schema: S,
	newSchema?: {
		[K in keyof S]?: {
			modelName?: string;
			fields?: {
				[P: string]: string;
			};
		};
	},
) {
	if (!newSchema) {
		return schema;
	}
	for (const table in newSchema) {
		const newModelName = newSchema[table]?.modelName;
		if (newModelName) {
			schema[table].modelName = newModelName;
		}
		for (const field in schema[table].fields) {
			const newField = newSchema[table]?.fields?.[field];
			if (!newField) {
				continue;
			}
			schema[table].fields[field].fieldName = newField;
		}
	}
	return schema;
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/db/to-zod.ts
```typescript
import { type ZodSchema, z } from "zod";
import type { FieldAttribute } from ".";

export function toZodSchema(fields: Record<string, FieldAttribute>) {
	const schema = z.object({
		...Object.keys(fields).reduce((acc, key) => {
			const field = fields[key];
			if (!field) {
				return acc;
			}
			if (field.type === "string[]" || field.type === "number[]") {
				return {
					...acc,
					[key]: z.array(field.type === "string[]" ? z.string() : z.number()),
				};
			}
			if (Array.isArray(field.type)) {
				return {
					...acc,
					[key]: z.any(),
				};
			}
			let schema: ZodSchema = z[field.type]();
			if (field?.required === false) {
				schema = schema.optional();
			}
			if (field?.returned === false) {
				return acc;
			}
			return {
				...acc,
				[key]: schema,
			};
		}, {}),
	});
	return schema;
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/db/utils.ts
```typescript
import { getAuthTables, type FieldAttribute } from ".";
import { BetterAuthError } from "../error";
import type { Adapter, BetterAuthOptions } from "../types";
import { createKyselyAdapter } from "../adapters/kysely-adapter/dialect";
import { kyselyAdapter } from "../adapters/kysely-adapter";
import { memoryAdapter } from "../adapters/memory-adapter";
import { logger } from "../utils";

export async function getAdapter(options: BetterAuthOptions): Promise<Adapter> {
	if (!options.database) {
		const tables = getAuthTables(options);
		const memoryDB = Object.keys(tables).reduce((acc, key) => {
			// @ts-ignore
			acc[key] = [];
			return acc;
		}, {});
		logger.warn(
			"No database configuration provided. Using memory adapter in development",
		);
		return memoryAdapter(memoryDB)(options);
	}

	if (typeof options.database === "function") {
		return options.database(options);
	}

	const { kysely, databaseType } = await createKyselyAdapter(options);
	if (!kysely) {
		throw new BetterAuthError("Failed to initialize database adapter");
	}
	return kyselyAdapter(kysely, {
		type: databaseType || "sqlite",
	})(options);
}

export function convertToDB<T extends Record<string, any>>(
	fields: Record<string, FieldAttribute>,
	values: T,
) {
	let result: Record<string, any> = values.id
		? {
				id: values.id,
			}
		: {};
	for (const key in fields) {
		const field = fields[key];
		const value = values[key];
		if (value === undefined) {
			continue;
		}
		result[field.fieldName || key] = value;
	}
	return result as T;
}

export function convertFromDB<T extends Record<string, any>>(
	fields: Record<string, FieldAttribute>,
	values: T | null,
) {
	if (!values) {
		return null;
	}
	let result: Record<string, any> = {
		id: values.id,
	};
	for (const [key, value] of Object.entries(fields)) {
		result[key] = values[value.fieldName || key];
	}
	return result as T;
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/db/with-hooks.ts
```typescript
import type {
	Adapter,
	BetterAuthOptions,
	GenericEndpointContext,
	Models,
	Where,
} from "../types";

export function getWithHooks(
	adapter: Adapter,
	ctx: {
		options: BetterAuthOptions;
		hooks: Exclude<BetterAuthOptions["databaseHooks"], undefined>[];
	},
) {
	const hooks = ctx.hooks;
	type BaseModels = Extract<
		Models,
		"user" | "account" | "session" | "verification"
	>;
	async function createWithHooks<T extends Record<string, any>>(
		data: T,
		model: BaseModels,
		customCreateFn?: {
			fn: (data: Record<string, any>) => void | Promise<any>;
			executeMainFn?: boolean;
		},
		context?: GenericEndpointContext,
	) {
		let actualData = data;
		for (const hook of hooks || []) {
			const toRun = hook[model]?.create?.before;
			if (toRun) {
				const result = await toRun(actualData as any, context);
				if (result === false) {
					return null;
				}
				const isObject = typeof result === "object" && "data" in result;
				if (isObject) {
					actualData = {
						...actualData,
						...result.data,
					};
				}
			}
		}

		const customCreated = customCreateFn
			? await customCreateFn.fn(actualData)
			: null;
		const created =
			!customCreateFn || customCreateFn.executeMainFn
				? await adapter.create<T>({
						model,
						data: actualData as any,
					})
				: customCreated;

		for (const hook of hooks || []) {
			const toRun = hook[model]?.create?.after;
			if (toRun) {
				await toRun(created as any, context);
			}
		}

		return created;
	}

	async function updateWithHooks<T extends Record<string, any>>(
		data: any,
		where: Where[],
		model: BaseModels,
		customUpdateFn?: {
			fn: (data: Record<string, any>) => void | Promise<any>;
			executeMainFn?: boolean;
		},
		context?: GenericEndpointContext,
	) {
		let actualData = data;

		for (const hook of hooks || []) {
			const toRun = hook[model]?.update?.before;
			if (toRun) {
				const result = await toRun(data as any, context);
				if (result === false) {
					return null;
				}
				const isObject = typeof result === "object";
				actualData = isObject ? (result as any).data : result;
			}
		}

		const customUpdated = customUpdateFn
			? await customUpdateFn.fn(actualData)
			: null;

		const updated =
			!customUpdateFn || customUpdateFn.executeMainFn
				? await adapter.update<T>({
						model,
						update: actualData,
						where,
					})
				: customUpdated;

		for (const hook of hooks || []) {
			const toRun = hook[model]?.update?.after;
			if (toRun) {
				await toRun(updated as any, context);
			}
		}
		return updated;
	}

	async function updateManyWithHooks<T extends Record<string, any>>(
		data: any,
		where: Where[],
		model: BaseModels,
		customUpdateFn?: {
			fn: (data: Record<string, any>) => void | Promise<any>;
			executeMainFn?: boolean;
		},
		context?: GenericEndpointContext,
	) {
		let actualData = data;

		for (const hook of hooks || []) {
			const toRun = hook[model]?.update?.before;
			if (toRun) {
				const result = await toRun(data as any, context);
				if (result === false) {
					return null;
				}
				const isObject = typeof result === "object";
				actualData = isObject ? (result as any).data : result;
			}
		}

		const customUpdated = customUpdateFn
			? await customUpdateFn.fn(actualData)
			: null;

		const updated =
			!customUpdateFn || customUpdateFn.executeMainFn
				? await adapter.updateMany({
						model,
						update: actualData,
						where,
					})
				: customUpdated;

		for (const hook of hooks || []) {
			const toRun = hook[model]?.update?.after;
			if (toRun) {
				await toRun(updated as any, context);
			}
		}

		return updated;
	}
	return {
		createWithHooks,
		updateWithHooks,
		updateManyWithHooks,
	};
}

```
