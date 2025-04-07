/Users/josh/Documents/GitHub/better-auth/better-auth/docs/content/docs/reference/contributing.mdx
````
---
title: Contributing to BetterAuth
description: A concise guide to contributing to BetterAuth
---

Thank you for your interest in contributing to Better Auth! This guide is a concise guide to contributing to Better Auth.

## Getting Started

Before diving in, here are a few important resources:

- Take a look at our existing <Link href="https://github.com/better-auth/better-auth/issues">issues</Link> and <Link href="https://github.com/better-auth/better-auth/pulls">pull requests</Link>
- Join our community discussions in <Link href="https://discord.gg/GYC3W7tZzb">Discord</Link>


## Development Setup

To get started with development:

<Callout type="warn">
  Make sure you have <Link href="https://nodejs.org/en/download">Node.JS</Link>{" "}
  installed, preferably on LTS.
</Callout>

<Steps>

    <Step>
        ### 1. Fork the repository

        Visit https://github.com/better-auth/better-auth

        Click the "Fork" button in the top right.

    </Step>

    <Step>
        ### 2. Clone your fork

        ```bash
        # Replace YOUR-USERNAME with your GitHub username
        git clone https://github.com/YOUR-USERNAME/better-auth.git
        cd better-auth
        ```
    </Step>

    <Step>
        ### 3. Install dependencies

        Make sure you have <Link href="https://pnpm.io/installation">pnpm</Link> installed!

        ```bash
        pnpm install
        ```
    </Step>

    <Step>
        ### 4. Prepare ENV files

        Copy the example env file to create your new `.env` file.

        ```bash
        cp -n ./docs/.env.example ./docs/.env
        ```
    </Step>

</Steps>

## Making changes

Once you have an idea of what you want to contribute, you can start making changes. Here are some steps to get started:

<Steps>
    <Step>
        ### 1. Create a new branch

        ```bash
        # Make sure you're on main
        git checkout main

        # Pull latest changes
        git pull upstream main

        # Create and switch to a new branch
        git checkout -b feature/your-feature-name
        ```
    </Step>
    <Step>
        ### 2. Start development server

        Start the development server:

        ```bash
        pnpm dev
        ```

        To start the docs server:

        ```bash
        pnpm -F docs dev
        ```
    </Step>
    <Step>
        ### 3. Make Your Changes

        * Make your changes to the codebase.

        * Write tests if needed. (Read more about testing <Link href="/docs/reference/contribute/testing">here</Link>)

        * Update documentation.  (Read more about documenting <Link href="/docs/reference/contribute/documenting">here</Link>)

    </Step>

</Steps>


### Issues and Bug Fixes

- Check our [GitHub issues](https://github.com/better-auth/better-auth/issues) for tasks labeled `good first issue`
- When reporting bugs, include steps to reproduce and expected behavior
- Comment on issues you'd like to work on to avoid duplicate efforts

### Framework Integrations

We welcome contributions to support more frameworks:

- Focus on framework-agnostic solutions where possible
- Keep integrations minimal and maintainable
- All integrations currently live in the main package

### Plugin Development

- For core plugins: Open an issue first to discuss your idea
- For community plugins: Feel free to develop independently
- Follow our plugin architecture guidelines

### Documentation

- Fix typos and errors
- Add examples and clarify existing content
- Ensure documentation is up-to-date with code changes

## Testing

We use Vitest for testing. Place test files next to the source files they test:

```ts
import { describe, it, expect } from "vitest";
import { getTestInstance } from "./test-utils/test-instance";

describe("Feature", () => {
    it("should work as expected", async () => {
        const { client } = getTestInstance();
        // Test code here
        expect(result).toBeDefined();
    });
});
```

### Testing Best Practices

- Write clear commit messages
- Update documentation to reflect your changes
- Add tests for new features
- Follow our coding standards
- Keep pull requests focused on a single change

## Need Help?

Don't hesitate to ask for help! You can:

- Open an <Link href="https://github.com/better-auth/better-auth/issues">issue</Link> with questions
- Join our <Link href="https://discord.gg/GYC3W7tZzb">community discussions</Link>
- Reach out to project maintainers

Thank you for contributing to Better Auth!
````
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/content/docs/reference/faq.mdx
````
---
title: FAQ
description: Frequently asked questions about Better Auth.
---

This page contains frequently asked questions, common issues, and other helpful information about Better Auth.

<Accordions>
  <Accordion title="Auth client not working">
  When encountering `createAuthClient` related errors, make sure to have the correct import path as it varies based on environment.

If you're using the auth client on react front-end, you'll need to import it from `/react`:

```ts title="component.ts"
import { createAuthClient } from "better-auth/react";
```

Where as if you're using the auth client in Next.js middleware, server-actions, server-components or anything server-related, you'll likely need to import it from `/client`:

```ts title="server.ts"
import { createAuthClient } from "better-auth/client";
```

</Accordion>

<Accordion title="getSession not working">
If you try to call `authClient.getSession` on a server environment (e.g, a Next.js server component), it doesn't work since it can't access the cookies. You can use the `auth.api.getSession` instead and pass the request headers to it. 

```tsx title="server.tsx"
import { auth } from "./auth";
import { headers } from "next/headers";

const session = await auth.api.getSession({
    headers: await headers()
})
```

if you need to use the auth client on the server for different purposes, you still can pass the request headers to it:

```tsx title="server.tsx"
import { authClient } from "./auth-client";
import { headers } from "next/headers";

const session = await authClient.getSession({
    fetchOptions:{
      headers: await headers()
    }
})
```
</Accordion>

<Accordion title="Adding custom fields to the users table">

Better Auth provides a type-safe way to extend the user and session schemas, take a look at our docs on <Link href="/docs/concepts/database#extending-core-schema">extending core schema</Link>.

</Accordion>

<Accordion title="Difference between getSession and useSession">
Both `useSession` and `getSession` instances are used fundamentally different based on the situation.

`useSession` is a hook, meaning it can trigger re-renders whenever session data changes.

If you have UI you need to change based on user or session data, you can use this hook.

<Callout type="warn">
  For performance reasons, do not use this hook on your `layout.tsx` file. We
  recommend using RSC and use your server auth instance to get the session data
  via `auth.api.getSession`.
</Callout>

`getSession` returns a promise containing data and error.

For all other situations where you shouldn't use `useSession`, is when you should be using `getSession`.

<Callout type="info">
   `getSession` is available on both server and client auth instances.
   Not just the latter.
</Callout>
</Accordion>

<Accordion title="Common Typescript Errors">
If you're facing typescript errors, make sure your tsconfig has `strict` set to `true`:
```json title="tsconfig.json"
{
  "compilerOptions": {
    "strict": true,
  }
}
```

if you can't set strict to true, you can enable strictNullChecks:
```json title="tsconfig.json"
{
  "compilerOptions": {
    "strictNullChecks": true,
  }
}
```

You can learn more in our <Link href="/docs/concepts/typescript#typescript-config">Typescript docs</Link>.
</Accordion>

</Accordions>

````
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/content/docs/reference/options.mdx
````
---
title: Options
description: Better Auth configuration options reference.
---

List of all the available options for configuring Better Auth. See [Better Auth Options](https://github.com/better-auth/better-auth/blob/main/packages/better-auth/src/types/options.ts#L13).

## `appName`

The name of the application.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	appName: "My App",
})
```

## `baseURL`

Base URL for Better Auth. This is typically the root URL where your application server is hosted.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	baseURL: "https://example.com",
})
```

If not explicitly set, the system will check for the environment variable `process.env.BETTER_AUTH_URL`

## `basePath`

Base path for Better Auth. This is typically the path where the Better Auth routes are mounted.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	basePath: "/api/auth",
})
```

Default: `/api/auth`

## `secret`

The secret used for encryption, signing, and hashing.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	secret: "your-secret-key",
})
```

By default, Better Auth will look for the following environment variables:
- `process.env.BETTER_AUTH_SECRET`
- `process.env.AUTH_SECRET`

If none of these environment variables are set, it will default to `"better-auth-secret-123456789"`. In production, if it's not set, it will throw an error.

You can generate a good secret using the following command:

```bash
openssl rand -base64 32
```

## `database`

Database configuration for Better Auth.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	database: {
		dialect: "postgres",
		type: "postgres",
		casing: "camel"
	},
})
```

Better Auth supports various database configurations including [PostgreSQL](/docs/adapters/postgresql), [MySQL](/docs/adapters/mysql), and [SQLite](/docs/adapters/sqlite).

Read more about databases [here](/docs/concepts/database).

## `secondaryStorage`

Secondary storage configuration used to store session and rate limit data.

```ts
import { betterAuth } from "better-auth";
import { redisStorage } from "better-auth/storage";

export const auth = betterAuth({
	secondaryStorage: redisStorage({
		url: "redis://localhost:6379"
	}),
})
```

Read more about secondary storage [here](/docs/concepts/database#secondary-storage).

## `emailVerification`

Email verification configuration.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	emailVerification: {
		sendVerificationEmail: async ({ user, url, token }) => {
			// Send verification email to user
		},
		sendOnSignUp: true,
		autoSignInAfterVerification: true,
		expiresIn: 3600 // 1 hour
	},
})
```

- `sendVerificationEmail`: Function to send verification email
- `sendOnSignUp`: Send verification email automatically after sign up (default: `false`)
- `autoSignInAfterVerification`: Auto sign in the user after they verify their email
- `expiresIn`: Number of seconds the verification token is valid for (default: `3600` seconds)

## `emailAndPassword`

Email and password authentication configuration.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	emailAndPassword: {
		enabled: true,
		disableSignUp: false,
		requireEmailVerification: true,
		minPasswordLength: 8,
		maxPasswordLength: 128,
		autoSignIn: true,
		sendResetPassword: async ({ user, url, token }) => {
			// Send reset password email
		},
		resetPasswordTokenExpiresIn: 3600, // 1 hour
		password: {
			hash: async (password) => {
				// Custom password hashing
				return hashedPassword;
			},
			verify: async ({ hash, password }) => {
				// Custom password verification
				return isValid;
			}
		}
	},
})
```

- `enabled`: Enable email and password authentication (default: `false`)
- `disableSignUp`: Disable email and password sign up (default: `false`)
- `requireEmailVerification`: Require email verification before a session can be created
- `minPasswordLength`: Minimum password length (default: `8`)
- `maxPasswordLength`: Maximum password length (default: `128`)
- `autoSignIn`: Automatically sign in the user after sign up
- `sendResetPassword`: Function to send reset password email
- `resetPasswordTokenExpiresIn`: Number of seconds the reset password token is valid for (default: `3600` seconds)
- `password`: Custom password hashing and verification functions

## `socialProviders`

Configure social login providers.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	socialProviders: {
		google: {
			clientId: "your-client-id",
			clientSecret: "your-client-secret",
			redirectUri: "https://example.com/api/auth/callback/google"
		},
		github: {
			clientId: "your-client-id",
			clientSecret: "your-client-secret",
			redirectUri: "https://example.com/api/auth/callback/github"
		}
	},
})
```

## `plugins`

List of Better Auth plugins.

```ts
import { betterAuth } from "better-auth";
import { emailOTP } from "better-auth/plugins";

export const auth = betterAuth({
	plugins: [
		emailOTP({
			sendVerificationOTP: async ({ email, otp, type }) => {
				// Send OTP to user's email
			}
		})
	],
})
```

## `user`

User configuration options.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	user: {
		modelName: "users",
		fields: {
			email: "emailAddress",
			name: "fullName"
		},
		additionalFields: {
			customField: {
				type: "string",
				nullable: true
			}
		},
		changeEmail: {
			enabled: true,
			sendChangeEmailVerification: async ({ user, newEmail, url, token }) => {
				// Send change email verification
			}
		},
		deleteUser: {
			enabled: true,
			sendDeleteAccountVerification: async ({ user, url, token }) => {
				// Send delete account verification
			},
			beforeDelete: async (user) => {
				// Perform actions before user deletion
			},
			afterDelete: async (user) => {
				// Perform cleanup after user deletion
			}
		}
	},
})
```

- `modelName`: The model name for the user (default: `"user"`)
- `fields`: Map fields to different column names
- `additionalFields`: Additional fields for the user table
- `changeEmail`: Configuration for changing email
- `deleteUser`: Configuration for user deletion

## `session`

Session configuration options.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	session: {
		modelName: "sessions",
		fields: {
			userId: "user_id"
		},
		expiresIn: 604800, // 7 days
		updateAge: 86400, // 1 day
		additionalFields: {
			customField: {
				type: "string",
				nullable: true
			}
		},
		storeSessionInDatabase: true,
		preserveSessionInDatabase: false,
		cookieCache: {
			enabled: true,
			maxAge: 300 // 5 minutes
		}
	},
})
```

- `modelName`: The model name for the session (default: `"session"`)
- `fields`: Map fields to different column names
- `expiresIn`: Expiration time for the session token in seconds (default: `604800` - 7 days)
- `updateAge`: How often the session should be refreshed in seconds (default: `86400` - 1 day)
- `additionalFields`: Additional fields for the session table
- `storeSessionInDatabase`: Store session in database when secondary storage is provided (default: `false`)
- `preserveSessionInDatabase`: Preserve session records in database when deleted from secondary storage (default: `false`)
- `cookieCache`: Enable caching session in cookie

## `account`

Account configuration options.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	account: {
		modelName: "accounts",
		fields: {
			userId: "user_id"
		},
		accountLinking: {
			enabled: true,
			trustedProviders: ["google", "github", "email-password"],
			allowDifferentEmails: false
		}
	},
})
```

- `modelName`: The model name for the account
- `fields`: Map fields to different column names

### `accountLinking`

Configuration for account linking.

- `enabled`: Enable account linking (default: `false`)
- `trustedProviders`: List of trusted providers
- `allowDifferentEmails`: Allow users to link accounts with different email addresses
- `allowUnlinkingAll`: Allow users to unlink all accounts

## `verification`

Verification configuration options.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	verification: {
		modelName: "verifications",
		fields: {
			userId: "user_id"
		},
		disableCleanup: false
	},
})
```

- `modelName`: The model name for the verification table
- `fields`: Map fields to different column names
- `disableCleanup`: Disable cleaning up expired values when a verification value is fetched

## `rateLimit`

Rate limiting configuration.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	rateLimit: {
		enabled: true,
		window: 10,
		max: 100,
		customRules: {
			"/example/path": {
				window: 10,
				max: 100
			}
		},
		storage: "memory",
		modelName: "rateLimit"
	}
})
```

- `enabled`: Enable rate limiting (defaults: `true` in production, `false` in development)
- `window`: Time window to use for rate limiting. The value should be in seconds. (default: `10`)
- `max`: The default maximum number of requests allowed within the window. (default: `100`)
- `customRules`: Custom rate limit rules to apply to specific paths.
- `storage`: Storage configuration. If you passed a secondary storage, rate limiting will be stored in the secondary storage. (options: `"memory", "database", "secondary-storage"`, default: `"memory"`)
- `modelName`: The name of the table to use for rate limiting if database is used as storage. (default: `"rateLimit"`)


## `advanced`

Advanced configuration options.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	advanced: {
		ipAddress: {
			ipAddressHeaders: ["x-client-ip", "x-forwarded-for"],
			disableIpTracking: false
		},
		useSecureCookies: true,
		disableCSRFCheck: false,
		crossSubDomainCookies: {
			enabled: true,
			additionalCookies: ["custom_cookie"],
			domain: "example.com"
		},
		cookies: {
			session_token: {
				name: "custom_session_token",
				attributes: {
					httpOnly: true,
					secure: true
				}
			}
		},
		defaultCookieAttributes: {
			httpOnly: true,
			secure: true
		},
		cookiePrefix: "myapp",
		generateId: ((options: {
			model: LiteralUnion<Models, string>;
			size?: number;
		}) => {
			// Generate a unique ID for the model
			return "my-id";
		}) 
	},
})
```

- `ipAddress`: IP address configuration for rate limiting and session tracking
- `useSecureCookies`: Use secure cookies (default: `false`)
- `disableCSRFCheck`: Disable trusted origins check (⚠️ security risk)
- `crossSubDomainCookies`: Configure cookies to be shared across subdomains
- `cookies`: Customize cookie names and attributes
- `defaultCookieAttributes`: Default attributes for all cookies
- `cookiePrefix`: Prefix for cookies
- `generateId`: Function to generate a unique ID for a model

## `databaseHooks`

Database lifecycle hooks for core operations.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	databaseHooks: {
		user: {
			create: {
				before: async (user) => {
					// Modify user data before creation
					return { data: { ...user, customField: "value" } };
				},
				after: async (user) => {
					// Perform actions after user creation
				}
			},
			update: {
				before: async (userData) => {
					// Modify user data before update
					return { data: { ...userData, updatedAt: new Date() } };
				},
				after: async (user) => {
					// Perform actions after user update
				}
			}
		},
		session: {
			// Session hooks
		},
		account: {
			// Account hooks
		},
		verification: {
			// Verification hooks
		}
	},
})
```

## `onAPIError`

API error handling configuration.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	onAPIError: {
		throw: true,
		onError: (error, ctx) => {
			// Custom error handling
			console.error("Auth error:", error);
		},
		errorURL: "/auth/error"
	},
})
```

- `throw`: Throw an error on API error (default: `false`)
- `onError`: Custom error handler
- `errorURL`: URL to redirect to on error (default: `/api/auth/error`)

## `hooks`

Request lifecycle hooks.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	hooks: {
		before: async (request, ctx) => {
			// Execute before processing the request
		},
		after: async (request, response, ctx) => {
			// Execute after processing the request
		}
	},
})
```

## `disabledPaths`

Disable specific auth paths.

```ts
import { betterAuth } from "better-auth";
export const auth = betterAuth({
	disabledPaths: ["/sign-up/email", "/sign-in/email"],
})
```


````
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/content/docs/reference/security.mdx
```
---
title: Security
description: Better Auth security features.
---

This page contains information about security features of Better Auth.


## Password Hashing

Better Auth uses the `scrypt` algorithm to hash passwords by default. This algorithm is designed to be memory-hard and CPU-intensive, making it resistant to brute-force attacks. You can customize the password hashing function by setting the `password` option in the configuration. This option should include a `hash` function to hash passwords and a `verify` function to verify them.

## Session Management

### Session Expiration

Better Auth uses secure session management to protect user data. Sessions are stored in the database or a secondary storage, if configured, to prevent unauthorized access. By default, sessions expire after 7 days, but you can customize this value in the configuration. Additionally, each time a session is used, if it reaches the `updateAge` threshold, the expiration date is extended, which by default is set to 1 day.

### Session Revocation

Better Auth allows you to revoke sessions to enhance security. When a session is revoked, the user is logged out and can no longer access the application. A logged in user can also revoke their own sessions to log out from different devices or browsers.

See the [session management](/docs/concepts/session-management) for more details.

## CSRF Protection

Better Auth ensures CSRF protection by validating the Origin header in requests. This check confirms that requests originate from the application or a trusted source. If a request comes from an untrusted origin, it is blocked to prevent potential CSRF attacks. By default, the origin matching the base URL is trusted, but you can set a list of trusted origins in the trustedOrigins configuration option.

## OAuth State and PKCE

To secure OAuth flows, Better Auth stores the OAuth state and PKCE (Proof Key for Code Exchange) in the database. The state helps prevent CSRF attacks, while PKCE protects against code injection threats. Once the OAuth process completes, these values are removed from the database.

## Cookies

Better Auth assigns secure cookies by default when the base URL uses `https`. These secure cookies are encrypted and only sent over secure connections, adding an extra layer of protection. They are also set with the `sameSite` attribute to `lax` by default to prevent cross-site request forgery attacks. And the `httpOnly` attribute is enabled to prevent client-side JavaScript from accessing the cookie. 

For Cross-Subdomain Cookies, you can set the `crossSubDomainCookies` option in the configuration. This option allows cookies to be shared across subdomains, enabling seamless authentication across multiple subdomains.

### Customizing Cookies

You can customize cookie names to minimize the risk of fingerprinting attacks and set specific cookie options as needed for additional control. For more information, refer to the [cookie options](/docs/concepts/cookies).

Plugins can also set custom cookie options to align with specific security needs. If you're using Better Auth in non-browser environments, plugins offer ways to manage cookies securely in those contexts as well.

## Rate Limiting

Better Auth includes built-in rate limiting to safeguard against brute-force attacks. Rate limits are applied across all routes by default, with specific routes subject to stricter limits based on potential risk.

## Trusted Origins

Trusted origins prevent CSRF attacks and block open redirects. You can set a list of trusted origins in the `trustedOrigins` configuration option. Requests from origins not on this list are automatically blocked.

## Reporting Vulnerabilities

If you discover a security vulnerability in Better Auth, please report it to us at [security@better-auth.com](mailto:security@better-auth.com). We address all reports promptly, and credits will be given for validated discoveries.

```
