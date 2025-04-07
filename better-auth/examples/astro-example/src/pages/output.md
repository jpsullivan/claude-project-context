/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/dashboard.astro
```
---
import { auth } from "@/auth";

const activeSessions = await auth.api
	.listSessions({
		headers: Astro.request.headers,
	})
	.catch((e) => {
		return [];
	});
const session = await auth.api.getSession({
	headers: Astro.request.headers,
});
---

<RootLayout>
	<UserCard activeSessions={activeSessions} initialSession={session} client:only />
</RootLayout>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/index.astro
```
---
---

<RootLayout>
  <div class="min-h-[80vh] flex flex-col items-center justify-center overflow-hidden no-visible-scrollbar px-6 md:px-0">
    <h3 class="font-bold text-xl text-black dark:text-white text-center">
      Better Auth.
    </h3>
    <p class="text-center break-words text-sm md:text-base">
      Official astro
      <a
        href="https://better-auth.com"
        target="_blank"
        class="italic underline"
      >
        better-auth
      </a>{" "}
      example. <br />
    </p> 
    <a href="/sign-in">
      <button
        id="login"
        class="bg-black mt-3 flex items-center gap-2 rounded-sm py-2 px-3 text-white text-sm"
      >
        Sign In
      </button>  
    </a>
    <a href="/dashboard">
      <button
        id="dashboard"
        class="bg-black mt-3 flex items-center gap-2 rounded-sm py-2 px-3 text-white text-sm"
      >
        Dashboard
      </button> 
    </a>
  </div>
</RootLayout>

<script>
  import { useVanillaSession } from "../libs/auth-client";
  useVanillaSession.subscribe((val) => {
    if (val.data) {
      document.getElementById("login")!.style.display = "none";
      document.getElementById("dashboard")!.style.display = "flex";
    } else {
      if(val.error){
        document.getElementById("login")!.style.display = "flex";
        document.getElementById("dashboard")!.style.display = "none";
      }
    }
  });
</script>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/sign-in.astro
```
---
---

<RootLayout>
  <SignInCard client:load />
</RootLayout>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/sign-up.astro
```
---
---

<RootLayout>
  <SignUpCard client:load />
</RootLayout>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/two-factor.astro
```
---
---

<RootLayout>
  <TwoFactorComponent client:load />
</RootLayout>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/api/auth/[...all].ts
```typescript
import type { APIRoute } from "astro";
import { auth } from "../../../auth";

export const GET: APIRoute = async (ctx) => {
	return auth.handler(ctx.request);
};

export const ALL: APIRoute = async (ctx) => {
	return auth.handler(ctx.request);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/two-factor/email.astro
```
---
---

<RootLayout>
  <TwoFactorEmail client:load />
</RootLayout>

```
