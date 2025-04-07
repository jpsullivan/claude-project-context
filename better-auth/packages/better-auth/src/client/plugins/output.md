/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/client/plugins/index.ts
```typescript
export * from "../../plugins/organization/client";
export * from "../../plugins/username/client";
export * from "../../plugins/passkey/client";
export * from "../../plugins/two-factor/client";
export * from "../../plugins/magic-link/client";
export * from "../../plugins/phone-number/client";
export * from "../../plugins/anonymous/client";
export * from "../../plugins/additional-fields/client";
export * from "../../plugins/admin/client";
export * from "../../plugins/generic-oauth/client";
export * from "../../plugins/jwt/client";
export * from "../../plugins/multi-session/client";
export * from "../../plugins/email-otp/client";
export * from "../../plugins/one-tap/client";
export * from "../../plugins/custom-session/client";
export * from "./infer-plugin";
export * from "../../plugins/sso/client";
export * from "../../plugins/oidc-provider/client";
export * from "../../plugins/api-key/client";
export type * from "@simplewebauthn/server";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/client/plugins/infer-plugin.ts
```typescript
import type { BetterAuthClientPlugin, BetterAuthOptions } from "../../types";

export const InferServerPlugin = <
	AuthOrOption extends
		| BetterAuthOptions
		| {
				options: BetterAuthOptions;
		  },
	ID extends string,
>() => {
	type Option = AuthOrOption extends { options: infer O } ? O : AuthOrOption;
	type Plugin = Option["plugins"] extends Array<infer P>
		? P extends {
				id: ID;
			}
			? P
			: never
		: never;
	return {
		id: "infer-server-plugin",
		$InferServerPlugin: {} as Plugin,
	} satisfies BetterAuthClientPlugin;
};

```
