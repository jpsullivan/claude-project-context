/Users/josh/Documents/GitHub/better-auth/better-auth/dev/bun/README.md
````
# bun

To install dependencies:

```bash
bun install
```

To run:

```bash
bun run index.ts
```

This project was created using `bun init` in bun v1.1.26. [Bun](https://bun.sh) is a fast all-in-one JavaScript runtime.

````
/Users/josh/Documents/GitHub/better-auth/better-auth/dev/bun/auth.ts
```typescript
import { betterAuth } from "better-auth";
import { prismaAdapter } from "better-auth/adapters/prisma";
import { twoFactor } from "better-auth/plugins";

export const auth = betterAuth({
	baseURL: "http://localhost:4000",
	database: prismaAdapter(
		{},
		{
			provider: "sqlite",
		},
	),
	emailAndPassword: {
		enabled: true,
	},
	plugins: [twoFactor()],
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/dev/bun/client.ts
```typescript
await fetch("http://localhost:4000/api/auth/sign-up/email", {
	method: "POST",
	body: JSON.stringify({
		email: "test-2@test.com",
		password: "password",
		name: "test-2",
	}),
	headers: {
		"content-type": "application/json",
	},
})
	.then((res) => res.json())
	.then((data) => console.log(data));

```
/Users/josh/Documents/GitHub/better-auth/better-auth/dev/bun/index.ts
```typescript
import { auth } from "./auth";

Bun.serve({
	fetch: auth.handler,
	port: 4000,
});
console.log("Server running on port 4000");

```
/Users/josh/Documents/GitHub/better-auth/better-auth/dev/bun/package.json
```json
{
  "name": "@dev/bun",
  "module": "index.ts",
  "type": "module",
  "scripts": {
    "dev": "bun index.ts --hot"
  },
  "devDependencies": {
    "@types/bun": "latest"
  },
  "peerDependencies": {
    "typescript": "^5.7.2"
  },
  "dependencies": {
    "@noble/ciphers": "^0.6.0",
    "@types/better-sqlite3": "^7.6.12",
    "better-auth": "workspace:*",
    "better-sqlite3": "^11.6.0",
    "pg": "^8.13.1"
  }
}
```
/Users/josh/Documents/GitHub/better-auth/better-auth/dev/bun/tsconfig.json
```json
{
	"compilerOptions": {
		"lib": ["ESNext", "DOM"],
		"target": "ESNext",
		"module": "ESNext",
		"moduleDetection": "force",
		"jsx": "react-jsx",
		"allowJs": true,
		"declaration": true,
		"moduleResolution": "bundler",
		"allowImportingTsExtensions": true,
		"verbatimModuleSyntax": true,
		"noEmit": true,
		"strict": true,
		"skipLibCheck": true,
		"noFallthroughCasesInSwitch": true,
		"noUnusedLocals": false,
		"noUnusedParameters": false,
		"noPropertyAccessFromIndexSignature": false,
		"paths": {
			"@/*": ["./src/*"]
		}
	}
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/dev/bun/prisma/schema.prisma
```
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "mysql"
  url      = env("DATABASE_URL")
}

model User {
  id            String    @id
  name          String
  email         String
  emailVerified Boolean
  image         String?
  createdAt     DateTime
  updatedAt     DateTime
  Session       Session[]
  Account       Account[]

  twoFactorEnabled     Boolean?
  twoFactorSecret      String?
  twoFactorBackupCodes String?

  @@unique([email])
  @@map("user")
}

model Session {
  id        String   @id
  expiresAt DateTime
  ipAddress String?
  userAgent String?
  userId    String
  users     User     @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@map("session")
}

model Account {
  id           String    @id
  accountId    String
  providerId   String
  userId       String
  users        User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  accessToken  String?
  refreshToken String?
  idToken      String?
  expiresAt    DateTime?
  password     String?

  @@map("account")
}

```
