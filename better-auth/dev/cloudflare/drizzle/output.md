/Users/josh/Documents/GitHub/better-auth/better-auth/dev/cloudflare/drizzle/0000_clean_vector.sql
```
CREATE TABLE `account` (
	`id` text PRIMARY KEY NOT NULL,
	`account_id` text NOT NULL,
	`provider_id` text NOT NULL,
	`user_id` text NOT NULL,
	`access_token` text,
	`refresh_token` text,
	`id_token` text,
	`access_token_expires_at` integer,
	`refresh_token_expires_at` integer,
	`scope` text,
	`password` text,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `session` (
	`id` text PRIMARY KEY NOT NULL,
	`expires_at` integer NOT NULL,
	`token` text NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	`ip_address` text,
	`user_agent` text,
	`user_id` text NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE UNIQUE INDEX `session_token_unique` ON `session` (`token`);--> statement-breakpoint
CREATE TABLE `user` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`email` text NOT NULL,
	`email_verified` integer NOT NULL,
	`image` text,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `user_email_unique` ON `user` (`email`);--> statement-breakpoint
CREATE TABLE `verification` (
	`id` text PRIMARY KEY NOT NULL,
	`identifier` text NOT NULL,
	`value` text NOT NULL,
	`expires_at` integer NOT NULL,
	`created_at` integer,
	`updated_at` integer
);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/dev/cloudflare/drizzle/meta/0000_snapshot.json
```json
{
  "version": "6",
  "dialect": "sqlite",
  "id": "dde09aa0-ff07-4e38-a49a-742a3c2b7af4",
  "prevId": "00000000-0000-0000-0000-000000000000",
  "tables": {
    "account": {
      "name": "account",
      "columns": {
        "id": {
          "name": "id",
          "type": "text",
          "primaryKey": true,
          "notNull": true,
          "autoincrement": false
        },
        "account_id": {
          "name": "account_id",
          "type": "text",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "provider_id": {
          "name": "provider_id",
          "type": "text",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "user_id": {
          "name": "user_id",
          "type": "text",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "access_token": {
          "name": "access_token",
          "type": "text",
          "primaryKey": false,
          "notNull": false,
          "autoincrement": false
        },
        "refresh_token": {
          "name": "refresh_token",
          "type": "text",
          "primaryKey": false,
          "notNull": false,
          "autoincrement": false
        },
        "id_token": {
          "name": "id_token",
          "type": "text",
          "primaryKey": false,
          "notNull": false,
          "autoincrement": false
        },
        "access_token_expires_at": {
          "name": "access_token_expires_at",
          "type": "integer",
          "primaryKey": false,
          "notNull": false,
          "autoincrement": false
        },
        "refresh_token_expires_at": {
          "name": "refresh_token_expires_at",
          "type": "integer",
          "primaryKey": false,
          "notNull": false,
          "autoincrement": false
        },
        "scope": {
          "name": "scope",
          "type": "text",
          "primaryKey": false,
          "notNull": false,
          "autoincrement": false
        },
        "password": {
          "name": "password",
          "type": "text",
          "primaryKey": false,
          "notNull": false,
          "autoincrement": false
        },
        "created_at": {
          "name": "created_at",
          "type": "integer",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "updated_at": {
          "name": "updated_at",
          "type": "integer",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        }
      },
      "indexes": {},
      "foreignKeys": {
        "account_user_id_user_id_fk": {
          "name": "account_user_id_user_id_fk",
          "tableFrom": "account",
          "tableTo": "user",
          "columnsFrom": [
            "user_id"
          ],
          "columnsTo": [
            "id"
          ],
          "onDelete": "cascade",
          "onUpdate": "no action"
        }
      },
      "compositePrimaryKeys": {},
      "uniqueConstraints": {},
      "checkConstraints": {}
    },
    "session": {
      "name": "session",
      "columns": {
        "id": {
          "name": "id",
          "type": "text",
          "primaryKey": true,
          "notNull": true,
          "autoincrement": false
        },
        "expires_at": {
          "name": "expires_at",
          "type": "integer",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "token": {
          "name": "token",
          "type": "text",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "created_at": {
          "name": "created_at",
          "type": "integer",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "updated_at": {
          "name": "updated_at",
          "type": "integer",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "ip_address": {
          "name": "ip_address",
          "type": "text",
          "primaryKey": false,
          "notNull": false,
          "autoincrement": false
        },
        "user_agent": {
          "name": "user_agent",
          "type": "text",
          "primaryKey": false,
          "notNull": false,
          "autoincrement": false
        },
        "user_id": {
          "name": "user_id",
          "type": "text",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        }
      },
      "indexes": {
        "session_token_unique": {
          "name": "session_token_unique",
          "columns": [
            "token"
          ],
          "isUnique": true
        }
      },
      "foreignKeys": {
        "session_user_id_user_id_fk": {
          "name": "session_user_id_user_id_fk",
          "tableFrom": "session",
          "tableTo": "user",
          "columnsFrom": [
            "user_id"
          ],
          "columnsTo": [
            "id"
          ],
          "onDelete": "cascade",
          "onUpdate": "no action"
        }
      },
      "compositePrimaryKeys": {},
      "uniqueConstraints": {},
      "checkConstraints": {}
    },
    "user": {
      "name": "user",
      "columns": {
        "id": {
          "name": "id",
          "type": "text",
          "primaryKey": true,
          "notNull": true,
          "autoincrement": false
        },
        "name": {
          "name": "name",
          "type": "text",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "email": {
          "name": "email",
          "type": "text",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "email_verified": {
          "name": "email_verified",
          "type": "integer",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "image": {
          "name": "image",
          "type": "text",
          "primaryKey": false,
          "notNull": false,
          "autoincrement": false
        },
        "created_at": {
          "name": "created_at",
          "type": "integer",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "updated_at": {
          "name": "updated_at",
          "type": "integer",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        }
      },
      "indexes": {
        "user_email_unique": {
          "name": "user_email_unique",
          "columns": [
            "email"
          ],
          "isUnique": true
        }
      },
      "foreignKeys": {},
      "compositePrimaryKeys": {},
      "uniqueConstraints": {},
      "checkConstraints": {}
    },
    "verification": {
      "name": "verification",
      "columns": {
        "id": {
          "name": "id",
          "type": "text",
          "primaryKey": true,
          "notNull": true,
          "autoincrement": false
        },
        "identifier": {
          "name": "identifier",
          "type": "text",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "value": {
          "name": "value",
          "type": "text",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "expires_at": {
          "name": "expires_at",
          "type": "integer",
          "primaryKey": false,
          "notNull": true,
          "autoincrement": false
        },
        "created_at": {
          "name": "created_at",
          "type": "integer",
          "primaryKey": false,
          "notNull": false,
          "autoincrement": false
        },
        "updated_at": {
          "name": "updated_at",
          "type": "integer",
          "primaryKey": false,
          "notNull": false,
          "autoincrement": false
        }
      },
      "indexes": {},
      "foreignKeys": {},
      "compositePrimaryKeys": {},
      "uniqueConstraints": {},
      "checkConstraints": {}
    }
  },
  "views": {},
  "enums": {},
  "_meta": {
    "schemas": {},
    "tables": {},
    "columns": {}
  },
  "internal": {
    "indexes": {}
  }
}
```
/Users/josh/Documents/GitHub/better-auth/better-auth/dev/cloudflare/drizzle/meta/_journal.json
```json
{
  "version": "7",
  "dialect": "sqlite",
  "entries": [
    {
      "idx": 0,
      "version": "6",
      "when": 1740122602683,
      "tag": "0000_clean_vector",
      "breakpoints": true
    }
  ]
}
```
