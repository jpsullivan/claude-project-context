/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/api-key/routes/create-api-key.ts
```typescript
import { z } from "zod";
import { APIError, createAuthEndpoint, getSessionFromCtx } from "../../../api";
import { ERROR_CODES } from "..";
import { generateId } from "../../../utils";
import { getDate } from "../../../utils/date";
import { apiKeySchema } from "../schema";
import type { ApiKey } from "../types";
import type { AuthContext } from "../../../types";
import { createHash } from "@better-auth/utils/hash";
import { base64Url } from "@better-auth/utils/base64";
import type { PredefinedApiKeyOptions } from ".";
import { safeJSONParse } from "../../../utils/json";

export function createApiKey({
	keyGenerator,
	opts,
	schema,
	deleteAllExpiredApiKeys,
}: {
	keyGenerator: (options: { length: number; prefix: string | undefined }) =>
		| Promise<string>
		| string;
	opts: PredefinedApiKeyOptions;
	schema: ReturnType<typeof apiKeySchema>;
	deleteAllExpiredApiKeys(
		ctx: AuthContext,
		byPassLastCheckTime?: boolean,
	): Promise<number> | undefined;
}) {
	return createAuthEndpoint(
		"/api-key/create",
		{
			method: "POST",
			body: z.object({
				name: z.string({ description: "Name of the Api Key" }).optional(),
				expiresIn: z
					.number({
						description: "Expiration time of the Api Key in seconds",
					})
					.min(1)
					.optional()
					.nullable()
					.default(null),

				userId: z.coerce
					.string({
						description:
							"User Id of the user that the Api Key belongs to. Useful for server-side only.",
					})
					.optional(),
				prefix: z
					.string({ description: "Prefix of the Api Key" })
					.regex(/^[a-zA-Z0-9_-]+$/, {
						message:
							"Invalid prefix format, must be alphanumeric and contain only underscores and hyphens.",
					})
					.optional(),
				remaining: z
					.number({
						description: "Remaining number of requests. Server side only",
					})
					.min(0)
					.optional()
					.nullable()
					.default(null),
				metadata: z.any({ description: "Metadata of the Api Key" }).optional(),
				refillAmount: z
					.number({
						description:
							"Amount to refill the remaining count of the Api Key. Server Only Property",
					})
					.min(1)
					.optional(),
				refillInterval: z
					.number({
						description:
							"Interval to refill the Api Key in milliseconds. Server Only Property.",
					})
					.optional(),
				rateLimitTimeWindow: z
					.number({
						description:
							"The duration in milliseconds where each request is counted. Once the `maxRequests` is reached, the request will be rejected until the `timeWindow` has passed, at which point the `timeWindow` will be reset. Server Only Property.",
					})
					.optional(),
				rateLimitMax: z
					.number({
						description:
							"Maximum amount of requests allowed within a window. Once the `maxRequests` is reached, the request will be rejected until the `timeWindow` has passed, at which point the `timeWindow` will be reset. Server Only Property.",
					})
					.optional(),
				rateLimitEnabled: z
					.boolean({
						description:
							"Whether the key has rate limiting enabled. Server Only Property.",
					})
					.optional(),
				permissions: z.record(z.string(), z.array(z.string())).optional(),
			}),
		},
		async (ctx) => {
			const {
				name,
				expiresIn,
				prefix,
				remaining,
				metadata,
				refillAmount,
				refillInterval,
				permissions,
				rateLimitMax,
				rateLimitTimeWindow,
				rateLimitEnabled,
			} = ctx.body;

			const session = await getSessionFromCtx(ctx);
			const authRequired = (ctx.request || ctx.headers) && !ctx.body.userId;
			const user =
				session?.user ?? (authRequired ? null : { id: ctx.body.userId });
			if (!user?.id) {
				throw new APIError("UNAUTHORIZED", {
					message: ERROR_CODES.UNAUTHORIZED_SESSION,
				});
			}

			if (authRequired) {
				// if this endpoint was being called from the client,
				// we must make sure they can't use server-only properties.
				if (
					refillAmount !== undefined ||
					refillInterval !== undefined ||
					rateLimitMax !== undefined ||
					rateLimitTimeWindow !== undefined ||
					rateLimitEnabled !== undefined ||
					permissions !== undefined ||
					remaining !== null
				) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.SERVER_ONLY_PROPERTY,
					});
				}
			}

			// if metadata is defined, than check that it's an object.
			if (metadata) {
				if (opts.enableMetadata === false) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.METADATA_DISABLED,
					});
				}
				if (typeof metadata !== "object") {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.INVALID_METADATA_TYPE,
					});
				}
			}

			// make sure that if they pass a refill amount, they also pass a refill interval
			if (refillAmount && !refillInterval) {
				throw new APIError("BAD_REQUEST", {
					message: ERROR_CODES.REFILL_AMOUNT_AND_INTERVAL_REQUIRED,
				});
			}
			// make sure that if they pass a refill interval, they also pass a refill amount
			if (refillInterval && !refillAmount) {
				throw new APIError("BAD_REQUEST", {
					message: ERROR_CODES.REFILL_INTERVAL_AND_AMOUNT_REQUIRED,
				});
			}

			if (expiresIn) {
				if (opts.keyExpiration.disableCustomExpiresTime === true) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.KEY_DISABLED_EXPIRATION,
					});
				}

				const expiresIn_in_days = expiresIn / (60 * 60 * 24);

				if (opts.keyExpiration.minExpiresIn > expiresIn_in_days) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.EXPIRES_IN_IS_TOO_SMALL,
					});
				} else if (opts.keyExpiration.maxExpiresIn < expiresIn_in_days) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.EXPIRES_IN_IS_TOO_LARGE,
					});
				}
			}
			if (prefix) {
				if (prefix.length < opts.minimumPrefixLength) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.INVALID_PREFIX_LENGTH,
					});
				}
				if (prefix.length > opts.maximumPrefixLength) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.INVALID_PREFIX_LENGTH,
					});
				}
			}

			if (name) {
				if (name.length < opts.minimumNameLength) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.INVALID_NAME_LENGTH,
					});
				}
				if (name.length > opts.maximumNameLength) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.INVALID_NAME_LENGTH,
					});
				}
			}

			deleteAllExpiredApiKeys(ctx.context);

			const key = await keyGenerator({
				length: opts.defaultKeyLength,
				prefix: prefix || opts.defaultPrefix,
			});

			const hash = await createHash("SHA-256").digest(key);
			const hashed = base64Url.encode(hash, {
				padding: false,
			});

			let start: string | null = null;

			if (opts.startingCharactersConfig.shouldStore) {
				start = key.substring(
					0,
					opts.startingCharactersConfig.charactersLength,
				);
			}

			const defaultPermissions = opts.permissions?.defaultPermissions
				? typeof opts.permissions.defaultPermissions === "function"
					? await opts.permissions.defaultPermissions(user.id, ctx)
					: opts.permissions.defaultPermissions
				: undefined;
			const permissionsToApply = permissions
				? JSON.stringify(permissions)
				: defaultPermissions
					? JSON.stringify(defaultPermissions)
					: undefined;
			let data: ApiKey = {
				id: generateId(),
				createdAt: new Date(),
				updatedAt: new Date(),
				name: name ?? null,
				prefix: prefix ?? opts.defaultPrefix ?? null,
				start: start,
				key: hashed,
				enabled: true,
				expiresAt: expiresIn
					? getDate(expiresIn, "sec")
					: opts.keyExpiration.defaultExpiresIn
						? getDate(opts.keyExpiration.defaultExpiresIn, "sec")
						: null,
				userId: user.id,
				lastRefillAt: null,
				lastRequest: null,
				metadata: null,
				rateLimitMax: rateLimitMax ?? opts.rateLimit.maxRequests ?? null,
				rateLimitTimeWindow:
					rateLimitTimeWindow ?? opts.rateLimit.timeWindow ?? null,
				remaining: remaining || refillAmount || null,
				refillAmount: refillAmount ?? null,
				refillInterval: refillInterval ?? null,
				rateLimitEnabled: rateLimitEnabled ?? true,
				requestCount: 0,
				//@ts-ignore - we intentionally save the permissions as string on DB.
				permissions: permissionsToApply,
			};

			if (metadata) {
				//@ts-expect-error - we intentionally save the metadata as string on DB.
				data.metadata = schema.apikey.fields.metadata.transform.input(metadata);
			}

			const apiKey = await ctx.context.adapter.create<ApiKey>({
				model: schema.apikey.modelName,
				data: data,
			});
			return ctx.json({
				...apiKey,
				key: key,
				metadata: metadata ?? null,
				permissions: apiKey.permissions
					? safeJSONParse(
							//@ts-ignore - from DB, this value is always a string
							apiKey.permissions,
						)
					: null,
			});
		},
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/api-key/routes/delete-all-expired-api-keys.ts
```typescript
import { createAuthEndpoint } from "../../../api";
import type { AuthContext } from "../../../types";

export function deleteAllExpiredApiKeysEndpoint({
	deleteAllExpiredApiKeys,
}: {
	deleteAllExpiredApiKeys(
		ctx: AuthContext,
		byPassLastCheckTime?: boolean,
	): Promise<number> | undefined;
}) {
	return createAuthEndpoint(
		"/api-key/delete-all-expired-api-keys",
		{
			method: "POST",
			metadata: {
				SERVER_ONLY: true,
			},
		},
		async (ctx) => {
			try {
				await deleteAllExpiredApiKeys(ctx.context, true);
			} catch (error) {
				ctx.context.logger.error(
					"[API KEY PLUGIN] Failed to delete expired API keys:",
					error,
				);
				return ctx.json({
					success: false,
					error: error,
				});
			}

			return ctx.json({ success: true, error: null });
		},
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/api-key/routes/delete-api-key.ts
```typescript
import { z } from "zod";
import { APIError, createAuthEndpoint, sessionMiddleware } from "../../../api";
import { ERROR_CODES } from "..";
import type { apiKeySchema } from "../schema";
import type { ApiKey } from "../types";
import type { AuthContext } from "../../../types";
import type { PredefinedApiKeyOptions } from ".";

export function deleteApiKey({
	opts,
	schema,
	deleteAllExpiredApiKeys,
}: {
	opts: PredefinedApiKeyOptions;
	schema: ReturnType<typeof apiKeySchema>;
	deleteAllExpiredApiKeys(
		ctx: AuthContext,
		byPassLastCheckTime?: boolean,
	): Promise<number> | undefined;
}) {
	return createAuthEndpoint(
		"/api-key/delete",
		{
			method: "POST",
			body: z.object({
				keyId: z.string({
					description: "The id of the Api Key",
				}),
			}),
			use: [sessionMiddleware],
		},
		async (ctx) => {
			const { keyId } = ctx.body;
			const session = ctx.context.session;
			if (session.user.banned === true) {
				throw new APIError("UNAUTHORIZED", {
					message: ERROR_CODES.USER_BANNED,
				});
			}
			const apiKey = await ctx.context.adapter.findOne<ApiKey>({
				model: schema.apikey.modelName,
				where: [
					{
						field: "id",
						value: keyId,
					},
				],
			});

			if (!apiKey || apiKey.userId !== session.user.id) {
				throw new APIError("NOT_FOUND", {
					message: ERROR_CODES.KEY_NOT_FOUND,
				});
			}

			try {
				await ctx.context.adapter.delete<ApiKey>({
					model: schema.apikey.modelName,
					where: [
						{
							field: "id",
							value: apiKey.id,
						},
					],
				});
			} catch (error: any) {
				throw new APIError("INTERNAL_SERVER_ERROR", {
					message: error?.message,
				});
			}
			deleteAllExpiredApiKeys(ctx.context);
			return ctx.json({
				success: true,
			});
		},
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/api-key/routes/get-api-key.ts
```typescript
import { z } from "zod";
import { APIError, createAuthEndpoint, sessionMiddleware } from "../../../api";
import { ERROR_CODES } from "..";
import type { apiKeySchema } from "../schema";
import type { ApiKey } from "../types";
import type { AuthContext } from "../../../types";
import type { PredefinedApiKeyOptions } from ".";
import { safeJSONParse } from "../../../utils/json";

export function getApiKey({
	opts,
	schema,
	deleteAllExpiredApiKeys,
}: {
	opts: PredefinedApiKeyOptions;
	schema: ReturnType<typeof apiKeySchema>;
	deleteAllExpiredApiKeys(
		ctx: AuthContext,
		byPassLastCheckTime?: boolean,
	): Promise<number> | undefined;
}) {
	return createAuthEndpoint(
		"/api-key/get",
		{
			method: "GET",
			query: z.object({
				id: z.string({
					description: "The id of the Api Key",
				}),
			}),
			use: [sessionMiddleware],
		},
		async (ctx) => {
			const { id } = ctx.query;

			const session = ctx.context.session;

			let apiKey = await ctx.context.adapter.findOne<ApiKey>({
				model: schema.apikey.modelName,
				where: [
					{
						field: "id",
						value: id,
					},
					{
						field: "userId",
						value: session.user.id,
					},
				],
			});

			if (!apiKey) {
				throw new APIError("NOT_FOUND", {
					message: ERROR_CODES.KEY_NOT_FOUND,
				});
			}

			deleteAllExpiredApiKeys(ctx.context);

			// convert metadata string back to object
			apiKey.metadata = schema.apikey.fields.metadata.transform.output(
				apiKey.metadata as never as string,
			);

			const { key, ...returningApiKey } = apiKey;

			return ctx.json({
				...returningApiKey,
				permissions: returningApiKey.permissions
					? safeJSONParse<{
							[key: string]: string[];
						}>(
							//@ts-ignore - From DB this is always a string
							returningApiKey.permissions,
						)
					: null,
			});
		},
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/api-key/routes/index.ts
```typescript
import type { AuthContext } from "../../../types";
import type { apiKeySchema } from "../schema";
import type { ApiKey, ApiKeyOptions } from "../types";
import { createApiKey } from "./create-api-key";
import { deleteApiKey } from "./delete-api-key";
import { getApiKey } from "./get-api-key";
import { updateApiKey } from "./update-api-key";
import { verifyApiKey } from "./verify-api-key";
import { listApiKeys } from "./list-api-keys";
import { deleteAllExpiredApiKeysEndpoint } from "./delete-all-expired-api-keys";

export type PredefinedApiKeyOptions = ApiKeyOptions &
	Required<
		Pick<
			ApiKeyOptions,
			| "apiKeyHeaders"
			| "defaultKeyLength"
			| "keyExpiration"
			| "rateLimit"
			| "maximumPrefixLength"
			| "minimumPrefixLength"
			| "maximumNameLength"
			| "minimumNameLength"
			| "enableMetadata"
			| "disableSessionForAPIKeys"
			| "startingCharactersConfig"
		>
	> & {
		keyExpiration: Required<ApiKeyOptions["keyExpiration"]>;
		startingCharactersConfig: Required<
			ApiKeyOptions["startingCharactersConfig"]
		>;
	};

export function createApiKeyRoutes({
	keyGenerator,
	opts,
	schema,
}: {
	keyGenerator: (options: { length: number; prefix: string | undefined }) =>
		| Promise<string>
		| string;
	opts: PredefinedApiKeyOptions;
	schema: ReturnType<typeof apiKeySchema>;
}) {
	let lastChecked: Date | null = null;

	function deleteAllExpiredApiKeys(
		ctx: AuthContext,
		byPassLastCheckTime = false,
	) {
		if (lastChecked && !byPassLastCheckTime) {
			const now = new Date();
			const diff = now.getTime() - lastChecked.getTime();
			if (diff < 10000) {
				return;
			}
		}
		lastChecked = new Date();
		try {
			return ctx.adapter.deleteMany({
				model: schema.apikey.modelName,
				where: [
					{
						field: "expiresAt" satisfies keyof ApiKey,
						operator: "lt",
						value: new Date(),
					},
				],
			});
		} catch (error) {
			ctx.logger.error(`Failed to delete expired API keys:`, error);
		}
	}

	return {
		createApiKey: createApiKey({
			keyGenerator,
			opts,
			schema,
			deleteAllExpiredApiKeys,
		}),
		verifyApiKey: verifyApiKey({ opts, schema, deleteAllExpiredApiKeys }),
		getApiKey: getApiKey({ opts, schema, deleteAllExpiredApiKeys }),
		updateApiKey: updateApiKey({ opts, schema, deleteAllExpiredApiKeys }),
		deleteApiKey: deleteApiKey({ opts, schema, deleteAllExpiredApiKeys }),
		listApiKeys: listApiKeys({ opts, schema, deleteAllExpiredApiKeys }),
		deleteAllExpiredApiKeys: deleteAllExpiredApiKeysEndpoint({
			deleteAllExpiredApiKeys,
		}),
	};
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/api-key/routes/list-api-keys.ts
```typescript
import { createAuthEndpoint, sessionMiddleware } from "../../../api";
import type { apiKeySchema } from "../schema";
import type { ApiKey } from "../types";
import type { AuthContext } from "../../../types";
import type { PredefinedApiKeyOptions } from ".";
import { safeJSONParse } from "../../../utils/json";

export function listApiKeys({
	opts,
	schema,
	deleteAllExpiredApiKeys,
}: {
	opts: PredefinedApiKeyOptions;
	schema: ReturnType<typeof apiKeySchema>;
	deleteAllExpiredApiKeys(
		ctx: AuthContext,
		byPassLastCheckTime?: boolean,
	): Promise<number> | undefined;
}) {
	return createAuthEndpoint(
		"/api-key/list",
		{
			method: "GET",
			use: [sessionMiddleware],
		},
		async (ctx) => {
			const session = ctx.context.session;
			let apiKeys = await ctx.context.adapter.findMany<ApiKey>({
				model: schema.apikey.modelName,
				where: [
					{
						field: "userId",
						value: session.user.id,
					},
				],
			});

			deleteAllExpiredApiKeys(ctx.context);
			apiKeys = apiKeys.map((apiKey) => {
				return {
					...apiKey,
					metadata: schema.apikey.fields.metadata.transform.output(
						apiKey.metadata as never as string,
					),
				};
			});

			let returningApiKey = apiKeys.map((x) => {
				const { key, ...returningApiKey } = x;
				return {
					...returningApiKey,
					permissions: returningApiKey.permissions
						? safeJSONParse<{
								[key: string]: string[];
							}>(
								//@ts-ignore - From DB this is always a string
								returningApiKey.permissions,
							)
						: null,
				};
			});

			return ctx.json(returningApiKey);
		},
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/api-key/routes/update-api-key.ts
```typescript
import { z } from "zod";
import { APIError, createAuthEndpoint, getSessionFromCtx } from "../../../api";
import { ERROR_CODES } from "..";
import type { apiKeySchema } from "../schema";
import type { ApiKey } from "../types";
import { getDate } from "../../../utils/date";
import type { AuthContext } from "../../../types";
import type { PredefinedApiKeyOptions } from ".";
import { safeJSONParse } from "../../../utils/json";

export function updateApiKey({
	opts,
	schema,
	deleteAllExpiredApiKeys,
}: {
	opts: PredefinedApiKeyOptions;
	schema: ReturnType<typeof apiKeySchema>;
	deleteAllExpiredApiKeys(
		ctx: AuthContext,
		byPassLastCheckTime?: boolean,
	): Promise<number> | undefined;
}) {
	return createAuthEndpoint(
		"/api-key/update",
		{
			method: "POST",
			body: z.object({
				keyId: z.string({
					description: "The id of the Api Key",
				}),
				userId: z.coerce.string().optional(),
				name: z
					.string({
						description: "The name of the key",
					})
					.optional(),
				enabled: z
					.boolean({
						description: "Whether the Api Key is enabled or not",
					})
					.optional(),
				remaining: z
					.number({
						description: "The number of remaining requests",
					})
					.min(1)
					.optional(),
				refillAmount: z
					.number({
						description: "The refill amount",
					})
					.optional(),
				refillInterval: z
					.number({
						description: "The refill interval",
					})
					.optional(),
				metadata: z
					.any({
						description: "The metadata of the Api Key",
					})
					.optional(),
				expiresIn: z
					.number({
						description: "Expiration time of the Api Key in seconds",
					})
					.min(1)
					.optional()
					.nullable(),
				rateLimitEnabled: z
					.boolean({
						description: "Whether the key has rate limiting enabled.",
					})
					.optional(),
				rateLimitTimeWindow: z
					.number({
						description:
							"The duration in milliseconds where each request is counted.",
					})
					.optional(),
				rateLimitMax: z
					.number({
						description:
							"Maximum amount of requests allowed within a window. Once the `maxRequests` is reached, the request will be rejected until the `timeWindow` has passed, at which point the `timeWindow` will be reset.",
					})
					.optional(),
				permissions: z
					.record(z.string(), z.array(z.string()))
					.optional()
					.nullable(),
			}),
		},
		async (ctx) => {
			const {
				keyId,
				expiresIn,
				enabled,
				metadata,
				refillAmount,
				refillInterval,
				remaining,
				name,
				permissions,
				rateLimitEnabled,
				rateLimitTimeWindow,
				rateLimitMax,
			} = ctx.body;

			const session = await getSessionFromCtx(ctx);
			const authRequired = (ctx.request || ctx.headers) && !ctx.body.userId;
			const user =
				session?.user ?? (authRequired ? null : { id: ctx.body.userId });
			if (!user?.id) {
				throw new APIError("UNAUTHORIZED", {
					message: ERROR_CODES.UNAUTHORIZED_SESSION,
				});
			}

			if (authRequired) {
				// if this endpoint was being called from the client,
				// we must make sure they can't use server-only properties.
				if (
					refillAmount !== undefined ||
					refillInterval !== undefined ||
					rateLimitMax !== undefined ||
					rateLimitTimeWindow !== undefined ||
					rateLimitEnabled !== undefined ||
					remaining !== undefined ||
					permissions !== undefined
				) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.SERVER_ONLY_PROPERTY,
					});
				}
			}

			const apiKey = await ctx.context.adapter.findOne<ApiKey>({
				model: schema.apikey.modelName,
				where: [
					{
						field: "id",
						value: keyId,
					},
					{
						field: "userId",
						value: user.id,
					},
				],
			});

			if (!apiKey) {
				throw new APIError("NOT_FOUND", {
					message: ERROR_CODES.KEY_NOT_FOUND,
				});
			}

			let newValues: Partial<ApiKey> = {};

			if (name !== undefined) {
				if (name.length < opts.minimumNameLength) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.INVALID_NAME_LENGTH,
					});
				} else if (name.length > opts.maximumNameLength) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.INVALID_NAME_LENGTH,
					});
				}
				newValues.name = name;
			}

			if (enabled !== undefined) {
				newValues.enabled = enabled;
			}
			if (expiresIn !== undefined) {
				if (opts.keyExpiration.disableCustomExpiresTime === true) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.KEY_DISABLED_EXPIRATION,
					});
				}
				if (expiresIn !== null) {
					// if expires is not null, check if it's under the valid range
					// if it IS null, this means the user wants to disable expiration time on the key
					const expiresIn_in_days = expiresIn / (60 * 60 * 24);

					if (expiresIn_in_days < opts.keyExpiration.minExpiresIn) {
						throw new APIError("BAD_REQUEST", {
							message: ERROR_CODES.EXPIRES_IN_IS_TOO_SMALL,
						});
					} else if (expiresIn_in_days > opts.keyExpiration.maxExpiresIn) {
						throw new APIError("BAD_REQUEST", {
							message: ERROR_CODES.EXPIRES_IN_IS_TOO_LARGE,
						});
					}
				}
				newValues.expiresAt = expiresIn ? getDate(expiresIn, "sec") : null;
			}
			if (metadata !== undefined) {
				if (typeof metadata !== "object") {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.INVALID_METADATA_TYPE,
					});
				}
				//@ts-ignore - we need this to be a string to save into DB.
				newValues.metadata =
					schema.apikey.fields.metadata.transform.input(metadata);
			}
			if (remaining !== undefined) {
				newValues.remaining = remaining;
			}
			if (refillAmount !== undefined || refillInterval !== undefined) {
				if (refillAmount !== undefined && refillInterval === undefined) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.REFILL_AMOUNT_AND_INTERVAL_REQUIRED,
					});
				} else if (refillInterval !== undefined && refillAmount === undefined) {
					throw new APIError("BAD_REQUEST", {
						message: ERROR_CODES.REFILL_INTERVAL_AND_AMOUNT_REQUIRED,
					});
				}
				newValues.refillAmount = refillAmount;
				newValues.refillInterval = refillInterval;
			}

			if (rateLimitEnabled !== undefined) {
				newValues.rateLimitEnabled = rateLimitEnabled;
			}
			if (rateLimitTimeWindow !== undefined) {
				newValues.rateLimitTimeWindow = rateLimitTimeWindow;
			}
			if (rateLimitMax !== undefined) {
				newValues.rateLimitMax = rateLimitMax;
			}

			if (permissions !== undefined) {
				//@ts-ignore - we need this to be a string to save into DB.
				newValues.permissions = JSON.stringify(permissions);
			}

			if (Object.keys(newValues).length === 0) {
				throw new APIError("BAD_REQUEST", {
					message: ERROR_CODES.NO_VALUES_TO_UPDATE,
				});
			}

			let newApiKey: ApiKey = apiKey;
			try {
				let result = await ctx.context.adapter.update<ApiKey>({
					model: schema.apikey.modelName,
					where: [
						{
							field: "id",
							value: apiKey.id,
						},
						{
							field: "userId",
							value: user.id,
						},
					],
					update: {
						lastRequest: new Date(),
						remaining: apiKey.remaining === null ? null : apiKey.remaining - 1,
						...newValues,
					},
				});
				if (result) newApiKey = result;
			} catch (error: any) {
				throw new APIError("INTERNAL_SERVER_ERROR", {
					message: error?.message,
				});
			}

			deleteAllExpiredApiKeys(ctx.context);

			// transform metadata from string back to object
			newApiKey.metadata = schema.apikey.fields.metadata.transform.output(
				newApiKey.metadata as never as string,
			);

			const { key, ...returningApiKey } = newApiKey;

			return ctx.json({
				...returningApiKey,
				permissions: returningApiKey.permissions
					? safeJSONParse<{
							[key: string]: string[];
						}>(
							//@ts-ignore - from DB, this value is always a string
							returningApiKey.permissions,
						)
					: null,
			});
		},
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/api-key/routes/verify-api-key.ts
```typescript
import { z } from "zod";
import { createAuthEndpoint } from "../../../api";
import { ERROR_CODES } from "..";
import type { apiKeySchema } from "../schema";
import type { ApiKey } from "../types";
import { base64Url } from "@better-auth/utils/base64";
import { createHash } from "@better-auth/utils/hash";
import { isRateLimited } from "../rate-limit";
import type { AuthContext } from "../../../types";
import type { PredefinedApiKeyOptions } from ".";
import { safeJSONParse } from "../../../utils/json";
import { role } from "../../access";

export function verifyApiKey({
	opts,
	schema,
	deleteAllExpiredApiKeys,
}: {
	opts: PredefinedApiKeyOptions;
	schema: ReturnType<typeof apiKeySchema>;
	deleteAllExpiredApiKeys(
		ctx: AuthContext,
		byPassLastCheckTime?: boolean,
	): Promise<number> | undefined;
}) {
	return createAuthEndpoint(
		"/api-key/verify",
		{
			method: "POST",
			body: z.object({
				key: z.string({
					description: "The key to verify",
				}),
				permissions: z.record(z.string(), z.array(z.string())).optional(),
			}),
			metadata: {
				SERVER_ONLY: true,
			},
		},
		async (ctx) => {
			const { key } = ctx.body;

			if (key.length < opts.defaultKeyLength) {
				// if the key is shorter than the default key length, than we know the key is invalid.
				// we can't check if the key is exactly equal to the default key length, because
				// a prefix may be added to the key.
				return ctx.json({
					valid: false,
					error: {
						message: ERROR_CODES.INVALID_API_KEY,
						code: "KEY_NOT_FOUND" as const,
					},
					key: null,
				});
			}

			if (
				opts.customAPIKeyValidator &&
				!opts.customAPIKeyValidator({ ctx, key })
			) {
				return ctx.json({
					valid: false,
					error: {
						message: ERROR_CODES.INVALID_API_KEY,
						code: "KEY_NOT_FOUND" as const,
					},
					key: null,
				});
			}

			const hash = await createHash("SHA-256").digest(
				new TextEncoder().encode(key),
			);
			const hashed = base64Url.encode(new Uint8Array(hash), {
				padding: false,
			});

			const apiKey = await ctx.context.adapter.findOne<ApiKey>({
				model: schema.apikey.modelName,
				where: [
					{
						field: "key",
						value: hashed,
					},
				],
			});

			// No api key found
			if (!apiKey) {
				return ctx.json({
					valid: false,
					error: {
						message: ERROR_CODES.KEY_NOT_FOUND,
						code: "KEY_NOT_FOUND" as const,
					},
					key: null,
				});
			}

			// key is disabled
			if (apiKey.enabled === false) {
				return ctx.json({
					valid: false,
					error: {
						message: ERROR_CODES.USAGE_EXCEEDED,
						code: "KEY_DISABLED" as const,
					},
					key: null,
				});
			}

			// key is expired
			if (apiKey.expiresAt) {
				const now = new Date().getTime();
				const expiresAt = apiKey.expiresAt.getTime();
				if (now > expiresAt) {
					try {
						ctx.context.adapter.delete({
							model: schema.apikey.modelName,
							where: [
								{
									field: "id",
									value: apiKey.id,
								},
							],
						});
					} catch (error) {
						ctx.context.logger.error(
							`Failed to delete expired API keys:`,
							error,
						);
					}

					return ctx.json({
						valid: false,
						error: {
							message: ERROR_CODES.KEY_EXPIRED,
							code: "KEY_EXPIRED" as const,
						},
						key: null,
					});
				}
			}

			const requiredPermissions = ctx.body.permissions;
			const apiKeyPermissions = apiKey.permissions
				? safeJSONParse<{
						[key: string]: string[];
					}>(
						//@ts-ignore - from DB, this value is always a string
						apiKey.permissions,
					)
				: null;

			if (requiredPermissions) {
				if (!apiKeyPermissions) {
					return ctx.json({
						valid: false,
						error: {
							message: ERROR_CODES.KEY_NOT_FOUND,
							code: "KEY_NOT_FOUND" as const,
						},
						key: null,
					});
				}
				const r = role(apiKeyPermissions as any);
				const result = r.authorize(requiredPermissions);
				if (!result.success) {
					return ctx.json({
						valid: false,
						error: {
							message: ERROR_CODES.KEY_NOT_FOUND,
							code: "KEY_NOT_FOUND" as const,
						},
						key: null,
					});
				}
			}

			let remaining = apiKey.remaining;
			let lastRefillAt = apiKey.lastRefillAt;

			if (apiKey.remaining === 0 && apiKey.refillAmount === null) {
				// if there is no more remaining requests, and there is no refill amount, than the key is revoked
				try {
					ctx.context.adapter.delete({
						model: schema.apikey.modelName,
						where: [
							{
								field: "id",
								value: apiKey.id,
							},
						],
					});
				} catch (error) {
					ctx.context.logger.error(`Failed to delete expired API keys:`, error);
				}

				return ctx.json({
					valid: false,
					error: {
						message: ERROR_CODES.USAGE_EXCEEDED,
						code: "USAGE_EXCEEDED" as const,
					},
					key: null,
				});
			} else if (remaining !== null) {
				let now = new Date().getTime();
				const refillInterval = apiKey.refillInterval;
				const refillAmount = apiKey.refillAmount;
				let lastTime = (lastRefillAt ?? apiKey.createdAt).getTime();

				if (refillInterval && refillAmount) {
					// if they provide refill info, then we should refill once the interval is reached.

					const timeSinceLastRequest = (now - lastTime) / (1000 * 60 * 60 * 24); // in days
					if (timeSinceLastRequest > refillInterval) {
						remaining = refillAmount;
						lastRefillAt = new Date();
					}
				}

				if (remaining === 0) {
					// if there are no more remaining requests, than the key is invalid

					// throw new APIError("FORBIDDEN", {
					// 	message: ERROR_CODES.USAGE_EXCEEDED,
					// });
					return ctx.json({
						valid: false,
						error: {
							message: ERROR_CODES.USAGE_EXCEEDED,
							code: "USAGE_EXCEEDED" as const,
						},
						key: null,
					});
				} else {
					remaining--;
				}
			}

			const { message, success, update, tryAgainIn } = isRateLimited(
				apiKey,
				opts,
			);
			const newApiKey = await ctx.context.adapter.update<ApiKey>({
				model: schema.apikey.modelName,
				where: [
					{
						field: "id",
						value: apiKey.id,
					},
				],
				update: {
					...update,
					remaining,
					lastRefillAt,
				},
			});
			if (success === false) {
				return ctx.json({
					valid: false,
					error: {
						message,
						code: "RATE_LIMITED" as const,
						details: {
							tryAgainIn,
						},
					},
					key: null,
				});
			}
			deleteAllExpiredApiKeys(ctx.context);

			const { key: _, ...returningApiKey } = newApiKey ?? {
				key: 1,
				permissions: undefined,
			};
			if ("metadata" in returningApiKey) {
				returningApiKey.metadata =
					schema.apikey.fields.metadata.transform.output(
						returningApiKey.metadata as never as string,
					);
			}

			returningApiKey.permissions = returningApiKey.permissions
				? safeJSONParse<{
						[key: string]: string[];
					}>(
						//@ts-ignore - from DB, this value is always a string
						returningApiKey.permissions,
					)
				: null;

			return ctx.json({
				valid: true,
				error: null,
				key:
					newApiKey === null ? null : (returningApiKey as Omit<ApiKey, "key">),
			});
		},
	);
}

```
