/Users/josh/Documents/GitHub/better-auth/better-auth/docs/content/changelogs/1-2.mdx
````
---
title: 1.2 Release
description: Stripe, Captcha, API Keys, Teams, Init CLI, and more.
date: 2025-03-01
---

# Better Auth 1.2 – Stripe, Captcha, API Keys, Teams, Init CLI, and more

To upgrade, run:

```package-install
npm install better-auth@1.2
```

---

### **Stripe Plugin (Beta)**

Stripe integration for customer management, subscriptions, and webhooks.

```package-install
npm install @better-auth/stripe
```

```ts title="auth.ts"
import { stripe } from "@better-auth/stripe"; // [!code highlight]

export const auth = betterAuth({
  plugins: [
    stripe({
      // [!code highlight]
      createCustomerOnSignup: true, // [!code highlight]
      subscription: { // [!code highlight]
        enabled: true, // [!code highlight]
        plans: [// [!code highlight]
          { // [!code highlight]
            name: "pro", // [!code highlight]
            priceId: "price_1234567890", // [!code highlight]
          }, // [!code highlight]
        ], // [!code highlight]
      }, // [!code highlight]
    }), // [!code highlight]
  ],
});
```

Read the [Stripe Plugin docs](/docs/plugins/stripe) for more information.

### **Captcha Plugin**

Protect your authentication flows with Google reCAPTCHA and Cloudflare Turnstile. Works for signup, signin, and password resets.

```ts title="auth.ts"
import { captcha } from "better-auth/plugins";

const auth = betterAuth({
  plugins: [
    // [!code highlight]
    captcha({
      // [!code highlight]
      provider: "cloudflare-turnstile", // or "google-recaptcha" // [!code highlight]
      secretKey: process.env.TURNSTILE_SECRET_KEY!, // [!code highlight]
    }), // [!code highlight]
  ], // [!code highlight]
});
```

Read the [Captcha Plugin docs](/docs/plugins/captcha) for more information.

### **API Key Plugin**

Generate and manage API keys with rate limiting, expiration, and metadata. Supports session creation from API keys.

```ts title="auth.ts"
import { apiKey } from "better-auth/plugins";

const auth = betterAuth({
  plugins: [apiKey()],
});
```

Read the [API Key Plugin docs](/docs/plugins/api-key) for more information.

### **Teams/Sub-Organizations**

Organizations can now have teams or sub-organizations under them.

```ts title="auth.ts"
const auth = betterAuth({
  plugins: [
    organization({
      teams: {
        enabled: true,
      },
    }),
  ],
});
```

Read the [Organization Plugin docs](/docs/plugins/organization#teams) for more information.

### **Init CLI**

The CLI now includes an `init` command to add better auth to your project.

```bash title="terminal"
npx @better-auth/cli init
```

### **Username**

- Added `displayName` for case-insensitive lookups while preserving original formatting.
- Built-in validation.

<Callout type="info">
  If you're using the Username plugin, make sure to add the `displayName` field
  to your schema.
</Callout>

### **Organization**

- **Multiple Roles per User** – Assign more than one role to a user.

### **Admin Plugin**

- Manage roles and permissions within the admin plugin. [Learn more](/docs/plugins/admin)
- `adminUserIds` option to grant specific users admin privileges. [Learn more](/docs/plugins/admin#usage)

---

## 🎭 New Social Providers

- [TikTok](/docs/authentication/tiktok)
- [Roblox](/docs/authentication/roblox)
- [VK](/docs/authentication/vk)

---

## ✨ Core Enhancements

- **Auto Cleanup** for expired verification data
- **Improved Google One Tap** integration with JWT verification and enhanced prompt handling
- **Phone-based Password Reset** functionality
- **Provider Control Options**:
  - Disable signups for specific providers
  - Disable implicit signups for specific providers
  - Control default scopes and allow custom scopes on request
- **Enhanced Database Hooks** with additional context information

---

## 🚀 Performance Boosts

We rewrote **better-call** (the core library behind Better Auth) to fix TypeScript editor lag. Your IDE should now feel much snappier when working with Better Auth.

---

## ⚡ CLI Enhancements

### **`init` Command**

The CLI now includes an `init` command to speed up setup:

- Scaffold new projects
- Generate schemas
- Run migrations

[Learn more](/docs/concepts/cli)

---

## 🛠 Bug Fixes & Stability Improvements

A lot of fixes and refinements to make everything smoother, faster, and more reliable. Check out the [changelog](https://github.com/better-auth/better-auth/releases/tag/v1.2.0) for more details.

---

```package-install
npm install better-auth@1.2.0
```

**Upgrade now and take advantage of these powerful new features!** 🚀

````
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/content/changelogs/1.0.mdx
````
---
title: v1.0
description: Built in CLI for managing your project.
date: 2021-10-01
---

Version update

Better Auth comes with a built-in CLI to help you manage the database schema needed for both core functionality and plugins.

## Generate

The `generate` command creates the schema required by Better Auth. If you're using a database adapter like Prisma or Drizzle, this command will generate the right schema for your ORM. If you're using the built-in Kysely adapter, it will generate an SQL file you can run directly on your database.

```bash title="Terminal"
npx @better-auth/cli@latest generate
```

### Options

- `--output` - Where to save the generated schema. For Prisma, it will be saved in prisma/schema.prisma. For Drizzle, it goes to schema.ts in your project root. For Kysely, it’s an SQL file saved as schema.sql in your project root.
- `--config` - The path to your Better Auth config file. By default, the CLI will search for a better-auth.ts file in **./**, **./utils**, **./lib**, or any of these directories under `src` directory.
- `--y` - Skip the confirmation prompt and generate the schema directly.

## Migrate

The migrate command applies the Better Auth schema directly to your database. This is available if you’re using the built-in Kysely adapter.

```bash title="Terminal"
npx @better-auth/cli@latest migrate
```

### Options

- `--config` - The path to your Better Auth config file. By default, the CLI will search for a better-auth.ts file in **./**, **./utils**, **./lib**, or any of these directories under `src` directory.
- `--y` - Skip the confirmation prompt and apply the schema directly.

## Common Issues

**Error: Cannot find module X**

If you see this error, it means the CLI can’t resolve imported modules in your Better Auth config file. We're working on a fix for many of these issues, but in the meantime, you can try the following:

- Remove any import aliases in your config file and use relative paths instead. After running the CLI, you can revert to using aliases.

## Secret

The CLI also provides a way to generate a secret key for your Better Auth instance.

```bash title="Terminal"
npx @better-auth/cli@latest secret
```

````
