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
