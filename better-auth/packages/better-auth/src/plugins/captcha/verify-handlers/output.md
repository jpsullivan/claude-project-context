/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/captcha/verify-handlers/cloudflare-turnstile.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import { middlewareResponse } from "../../../utils/middleware-response";
import { CAPTCHA_ERROR_CODES } from "../error-codes";
import type { TurnstileSiteVerifyResponse } from "../types";

type Params = {
	siteVerifyURL: string;
	secretKey: string;
	captchaResponse: string;
};

export const cloudflareTurnstile = async ({
	siteVerifyURL,
	captchaResponse,
	secretKey,
}: Params) => {
	const response = await betterFetch<TurnstileSiteVerifyResponse>(
		siteVerifyURL,
		{
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({
				secret: secretKey,
				response: captchaResponse,
			}),
		},
	);

	if (!response.data || response.error) {
		return middlewareResponse({
			message: CAPTCHA_ERROR_CODES.SERVICE_UNAVAILABLE,
			status: 503,
		});
	}

	if (!response.data.success) {
		return middlewareResponse({
			message: CAPTCHA_ERROR_CODES.VERIFICATION_FAILED,
			status: 403,
		});
	}

	return undefined;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/captcha/verify-handlers/google-recaptcha.ts
```typescript
import { betterFetch } from "@better-fetch/fetch";
import { middlewareResponse } from "../../../utils/middleware-response";
import { CAPTCHA_ERROR_CODES } from "../error-codes";
import type { GoogleReCAPTCHASiteVerifyResponse } from "../types";

type Params = {
	siteVerifyURL: string;
	secretKey: string;
	captchaResponse: string;
};

export const googleReCAPTCHA = async ({
	siteVerifyURL,
	captchaResponse,
	secretKey,
}: Params) => {
	const response = await betterFetch<GoogleReCAPTCHASiteVerifyResponse>(
		siteVerifyURL,
		{
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({
				secret: secretKey,
				response: captchaResponse,
			}),
		},
	);

	if (!response.data || response.error) {
		return middlewareResponse({
			message: CAPTCHA_ERROR_CODES.SERVICE_UNAVAILABLE,
			status: 503,
		});
	}

	if (!response.data.success) {
		return middlewareResponse({
			message: CAPTCHA_ERROR_CODES.VERIFICATION_FAILED,
			status: 403,
		});
	}

	return undefined;
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/packages/better-auth/src/plugins/captcha/verify-handlers/index.ts
```typescript
export { cloudflareTurnstile } from "./cloudflare-turnstile";
export { googleReCAPTCHA } from "./google-recaptcha";

```
