/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/jwt/adapter.ts
```typescript
import type { Adapter } from "../../types";
import type { Jwk } from "./schema";

export const getJwksAdapter = (adapter: Adapter) => {
	return {
		getAllKeys: async () => {
			return await adapter.findMany<Jwk>({
				model: "jwks",
			});
		},
		getLatestKey: async () => {
			const key = await adapter.findMany<Jwk>({
				model: "jwks",
				sortBy: {
					field: "createdAt",
					direction: "desc",
				},
				limit: 1,
			});

			return key[0];
		},
		createJwk: async (webKey: Jwk) => {
			const jwk = await adapter.create<Jwk>({
				model: "jwks",
				data: {
					...webKey,
					createdAt: new Date(),
				},
			});

			return jwk;
		},
	};
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/jwt/client.ts
```typescript
import type { jwt } from "./index";
import type { BetterAuthClientPlugin } from "../../types";

export const jwtClient = () => {
	return {
		id: "better-auth-client",
		$InferServerPlugin: {} as ReturnType<typeof jwt>,
	} satisfies BetterAuthClientPlugin;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/jwt/index.ts
```typescript
import type {
	BetterAuthPlugin,
	GenericEndpointContext,
	InferOptionSchema,
	Session,
	User,
} from "../../types";
import { type Jwk, schema } from "./schema";
import { getJwksAdapter } from "./adapter";
import { exportJWK, generateKeyPair, importJWK, SignJWT } from "jose";
import {
	createAuthEndpoint,
	createAuthMiddleware,
	sessionMiddleware,
} from "../../api";
import { symmetricDecrypt, symmetricEncrypt } from "../../crypto";
import { mergeSchema } from "../../db/schema";
import { BetterAuthError } from "../../error";

type JWKOptions =
	| {
			alg: "EdDSA"; // EdDSA with either Ed25519 or Ed448 curve
			crv?: "Ed25519" | "Ed448";
	  }
	| {
			alg: "ES256"; // ECDSA with P-256 curve
			crv?: never; // Only one valid option, no need for crv
	  }
	| {
			alg: "RS256"; // RSA with SHA-256
			modulusLength?: number; // Default to 2048 or higher
	  }
	| {
			alg: "PS256"; // RSA-PSS with SHA-256
			modulusLength?: number; // Default to 2048 or higher
	  }
	| {
			alg: "ECDH-ES"; // Key agreement algorithm with P-256 as default curve
			crv?: "P-256" | "P-384" | "P-521";
	  }
	| {
			alg: "ES512"; // ECDSA with P-521 curve
			crv?: never; // Only P-521 for ES512
	  };

export interface JwtOptions {
	jwks?: {
		/**
		 * Key pair configuration
		 * @description A subset of the options available for the generateKeyPair function
		 *
		 * @see https://github.com/panva/jose/blob/main/src/runtime/node/generate.ts
		 *
		 * @default { alg: 'EdDSA', crv: 'Ed25519' }
		 */
		keyPairConfig?: JWKOptions;

		/**
		 * Disable private key encryption
		 * @description Disable the encryption of the private key in the database
		 *
		 * @default false
		 */
		disablePrivateKeyEncryption?: boolean;
	};

	jwt?: {
		issuer?: string;
		audience?: string;
		/**
		 * Set the "exp" (Expiration Time) Claim.
		 *
		 * - If a `number` is passed as an argument it is used as the claim directly.
		 * - If a `Date` instance is passed as an argument it is converted to unix timestamp and used as the
		 *   claim.
		 * - If a `string` is passed as an argument it is resolved to a time span, and then added to the
		 *   current unix timestamp and used as the claim.
		 *
		 * Format used for time span should be a number followed by a unit, such as "5 minutes" or "1
		 * day".
		 *
		 * Valid units are: "sec", "secs", "second", "seconds", "s", "minute", "minutes", "min", "mins",
		 * "m", "hour", "hours", "hr", "hrs", "h", "day", "days", "d", "week", "weeks", "w", "year",
		 * "years", "yr", "yrs", and "y". It is not possible to specify months. 365.25 days is used as an
		 * alias for a year.
		 *
		 * If the string is suffixed with "ago", or prefixed with a "-", the resulting time span gets
		 * subtracted from the current unix timestamp. A "from now" suffix can also be used for
		 * readability when adding to the current unix timestamp.
		 *
		 * @default 15m
		 */
		expirationTime?: number | string | Date;
		definePayload?: (session: {
			user: User & Record<string, any>;
			session: Session & Record<string, any>;
		}) => Promise<Record<string, any>> | Record<string, any>;
	};
	/**
	 * Custom schema for the admin plugin
	 */
	schema?: InferOptionSchema<typeof schema>;
}

export async function getJwtToken(
	ctx: GenericEndpointContext,
	options?: JwtOptions,
) {
	const adapter = getJwksAdapter(ctx.context.adapter);

	let key = await adapter.getLatestKey();
	const privateKeyEncryptionEnabled =
		!options?.jwks?.disablePrivateKeyEncryption;

	if (key === undefined) {
		const { publicKey, privateKey } = await generateKeyPair(
			options?.jwks?.keyPairConfig?.alg ?? "EdDSA",
			options?.jwks?.keyPairConfig ?? {
				crv: "Ed25519",
				extractable: true,
			},
		);

		const publicWebKey = await exportJWK(publicKey);
		const privateWebKey = await exportJWK(privateKey);
		const stringifiedPrivateWebKey = JSON.stringify(privateWebKey);

		let jwk: Partial<Jwk> = {
			id: ctx.context.generateId({
				model: "jwks",
			}),
			publicKey: JSON.stringify(publicWebKey),
			privateKey: privateKeyEncryptionEnabled
				? JSON.stringify(
						await symmetricEncrypt({
							key: ctx.context.secret,
							data: stringifiedPrivateWebKey,
						}),
					)
				: stringifiedPrivateWebKey,
			createdAt: new Date(),
		};

		key = await adapter.createJwk(jwk as Jwk);
	}

	let privateWebKey = privateKeyEncryptionEnabled
		? await symmetricDecrypt({
				key: ctx.context.secret,
				data: JSON.parse(key.privateKey),
			}).catch(() => {
				throw new BetterAuthError(
					"Failed to decrypt private private key. Make sure the secret currently in use is the same as the one used to encrypt the private key. If you are using a different secret, either cleanup your jwks or disable private key encryption.",
				);
			})
		: key.privateKey;

	const privateKey = await importJWK(
		JSON.parse(privateWebKey),
		options?.jwks?.keyPairConfig?.alg ?? "EdDSA",
	);

	const payload = !options?.jwt?.definePayload
		? ctx.context.session!.user
		: await options?.jwt.definePayload(ctx.context.session!);

	const jwt = await new SignJWT(payload)
		.setProtectedHeader({
			alg: options?.jwks?.keyPairConfig?.alg ?? "EdDSA",
			kid: key.id,
		})
		.setIssuedAt()
		.setIssuer(options?.jwt?.issuer ?? ctx.context.options.baseURL!)
		.setAudience(options?.jwt?.audience ?? ctx.context.options.baseURL!)
		.setExpirationTime(options?.jwt?.expirationTime ?? "15m")
		.setSubject(ctx.context.session!.user.id)
		.sign(privateKey);
	return jwt;
}
export const jwt = (options?: JwtOptions) => {
	return {
		id: "jwt",
		endpoints: {
			getJwks: createAuthEndpoint(
				"/jwks",
				{
					method: "GET",
					metadata: {
						openapi: {
							description: "Get the JSON Web Key Set",
							responses: {
								200: {
									description: "Success",
									content: {
										"application/json": {
											schema: {
												type: "object",
												properties: {
													keys: {
														type: "array",
														items: {
															type: "object",
															properties: {
																kid: {
																	type: "string",
																},
																kty: {
																	type: "string",
																},
																use: {
																	type: "string",
																},
																alg: {
																	type: "string",
																},
																n: {
																	type: "string",
																},
																e: {
																	type: "string",
																},
															},
														},
													},
												},
											},
										},
									},
								},
							},
						},
					},
				},
				async (ctx) => {
					const adapter = getJwksAdapter(ctx.context.adapter);

					const keySets = await adapter.getAllKeys();

					if (keySets.length === 0) {
						const alg = options?.jwks?.keyPairConfig?.alg ?? "EdDSA";
						const { publicKey, privateKey } = await generateKeyPair(
							alg,
							options?.jwks?.keyPairConfig ?? {
								crv: "Ed25519",
								extractable: true,
							},
						);

						const publicWebKey = await exportJWK(publicKey);
						const privateWebKey = await exportJWK(privateKey);
						const stringifiedPrivateWebKey = JSON.stringify(privateWebKey);
						const privateKeyEncryptionEnabled =
							!options?.jwks?.disablePrivateKeyEncryption;
						let jwk: Partial<Jwk> = {
							id: ctx.context.generateId({
								model: "jwks",
							}),
							publicKey: JSON.stringify({ alg, ...publicWebKey }),
							privateKey: privateKeyEncryptionEnabled
								? JSON.stringify(
										await symmetricEncrypt({
											key: ctx.context.secret,
											data: stringifiedPrivateWebKey,
										}),
									)
								: stringifiedPrivateWebKey,
							createdAt: new Date(),
						};

						await adapter.createJwk(jwk as Jwk);

						return ctx.json({
							keys: [
								{
									...publicWebKey,
									alg,
									kid: jwk.id,
								},
							],
						});
					}

					return ctx.json({
						keys: keySets.map((keySet) => ({
							...JSON.parse(keySet.publicKey),
							kid: keySet.id,
						})),
					});
				},
			),

			getToken: createAuthEndpoint(
				"/token",
				{
					method: "GET",
					requireHeaders: true,
					use: [sessionMiddleware],
					metadata: {
						openapi: {
							description: "Get a JWT token",
							responses: {
								200: {
									description: "Success",
									content: {
										"application/json": {
											schema: {
												type: "object",
												properties: {
													token: {
														type: "string",
													},
												},
											},
										},
									},
								},
							},
						},
					},
				},
				async (ctx) => {
					const jwt = await getJwtToken(ctx, options);
					return ctx.json({
						token: jwt,
					});
				},
			),
		},
		hooks: {
			after: [
				{
					matcher(context) {
						return context.path === "/get-session";
					},
					handler: createAuthMiddleware(async (ctx) => {
						const session = ctx.context.session || ctx.context.newSession;
						if (session && session.session) {
							const jwt = await getJwtToken(ctx, options);
							ctx.setHeader("set-auth-jwt", jwt);
							ctx.setHeader("Access-Control-Expose-Headers", "set-auth-jwt");
						}
					}),
				},
			],
		},
		schema: mergeSchema(schema, options?.schema),
	} satisfies BetterAuthPlugin;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/jwt/jwt.test.ts
```typescript
import { describe, expect } from "vitest";
import { getTestInstance } from "../../test-utils/test-instance";
import { createAuthClient } from "../../client";
import { jwtClient } from "./client";
import { jwt } from "./index";
import { importJWK, jwtVerify } from "jose";

describe("jwt", async (it) => {
	const { auth, signInWithTestUser } = await getTestInstance({
		plugins: [jwt()],
		logger: {
			level: "error",
		},
	});

	const { headers } = await signInWithTestUser();
	const client = createAuthClient({
		plugins: [jwtClient()],
		baseURL: "http://localhost:3000/api/auth",
		fetchOptions: {
			customFetchImpl: async (url, init) => {
				return auth.handler(new Request(url, init));
			},
		},
	});

	it("should get a token", async () => {
		let token = "";
		await client.getSession({
			fetchOptions: {
				headers,
				onSuccess(context) {
					token = context.response.headers.get("set-auth-jwt") || "";
				},
			},
		});

		expect(token.length).toBeGreaterThan(10);
	});

	it("Get a token", async () => {
		const token = await client.token({
			fetchOptions: {
				headers,
			},
		});

		expect(token.data?.token).toBeDefined();
	});

	it("Get JWKS", async () => {
		// If no JWK exists, this makes sure it gets added.
		// TODO: Replace this with a generate JWKS endpoint once it exists.
		const token = await client.token({
			fetchOptions: {
				headers,
			},
		});

		expect(token.data?.token).toBeDefined();

		const jwks = await client.jwks();

		expect(jwks.data?.keys).length.above(0);
	});

	it("Signed tokens can be validated with the JWKS", async () => {
		const token = await client.token({
			fetchOptions: {
				headers,
			},
		});

		const jwks = await client.jwks();

		const publicWebKey = await importJWK({
			...jwks.data?.keys[0],
			alg: "EdDSA",
		});
		const decoded = await jwtVerify(token.data?.token!, publicWebKey);

		expect(decoded).toBeDefined();
	});
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/jwt/schema.ts
```typescript
import type { AuthPluginSchema } from "../../types";
import { z } from "zod";

export const schema = {
	jwks: {
		fields: {
			publicKey: {
				type: "string",
				required: true,
			},
			privateKey: {
				type: "string",
				required: true,
			},
			createdAt: {
				type: "date",
				required: true,
			},
		},
	},
} satisfies AuthPluginSchema;

export const jwk = z.object({
	id: z.string(),
	publicKey: z.string(),
	privateKey: z.string(),
	createdAt: z.date(),
});

export type Jwk = z.infer<typeof jwk>;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/jwt/utils.ts
```typescript
import { subtle, getRandomValues } from "@better-auth/utils";
import { base64 } from "@better-auth/utils/base64";

async function deriveKey(secretKey: string): Promise<CryptoKey> {
	const enc = new TextEncoder();
	const keyMaterial = await crypto.subtle.importKey(
		"raw",
		enc.encode(secretKey),
		{ name: "PBKDF2" },
		false,
		["deriveKey"],
	);

	return subtle.deriveKey(
		{
			name: "PBKDF2",
			salt: enc.encode("encryption_salt"),
			iterations: 100000,
			hash: "SHA-256",
		},
		keyMaterial,
		{ name: "AES-GCM", length: 256 },
		false,
		["encrypt", "decrypt"],
	);
}

export async function encryptPrivateKey(
	privateKey: string,
	secretKey: string,
): Promise<{ encryptedPrivateKey: string; iv: string; authTag: string }> {
	const key = await deriveKey(secretKey); // Derive a 32-byte key from the provided secret
	const iv = getRandomValues(new Uint8Array(12)); // 12-byte IV for AES-GCM

	const enc = new TextEncoder();
	const ciphertext = await subtle.encrypt(
		{
			name: "AES-GCM",
			iv: iv,
		},
		key,
		enc.encode(privateKey),
	);

	const encryptedPrivateKey = base64.encode(ciphertext);
	const ivBase64 = base64.encode(iv);

	return {
		encryptedPrivateKey,
		iv: ivBase64,
		authTag: encryptedPrivateKey.slice(-16),
	};
}

export async function decryptPrivateKey(
	encryptedPrivate: {
		encryptedPrivateKey: string;
		iv: string;
		authTag: string;
	},
	secretKey: string,
): Promise<string> {
	const key = await deriveKey(secretKey);
	const { encryptedPrivateKey, iv } = encryptedPrivate;

	const ivBuffer = base64.decode(iv);
	const ciphertext = base64.decode(encryptedPrivateKey);

	const decrypted = await subtle.decrypt(
		{
			name: "AES-GCM",
			iv: ivBuffer,
		},
		key,
		ciphertext,
	);

	const dec = new TextDecoder();
	return dec.decode(decrypted);
}

```
