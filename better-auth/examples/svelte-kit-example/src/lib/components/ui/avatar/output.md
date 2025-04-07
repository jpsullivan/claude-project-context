/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/avatar/avatar-fallback.svelte
```
<script lang="ts">
import { Avatar as AvatarPrimitive } from "bits-ui";

type $$Props = AvatarPrimitive.FallbackProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<AvatarPrimitive.Fallback
	class={cn("bg-muted flex h-full w-full items-center justify-center rounded-full", className)}
	{...$$restProps}
>
	<slot />
</AvatarPrimitive.Fallback>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/avatar/avatar-image.svelte
```
<script lang="ts">
import { Avatar as AvatarPrimitive } from "bits-ui";

type $$Props = AvatarPrimitive.ImageProps;

let className: $$Props["class"] = undefined;
export let src: $$Props["src"] = undefined;
export let alt: $$Props["alt"] = undefined;
export { className as class };
</script>

<AvatarPrimitive.Image
	{src}
	{alt}
	class={cn("aspect-square h-full w-full", className)}
	{...$$restProps}
/>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/avatar/avatar.svelte
```
<script lang="ts">
import { Avatar as AvatarPrimitive } from "bits-ui";

type $$Props = AvatarPrimitive.Props;

let className: $$Props["class"] = undefined;
export let delayMs: $$Props["delayMs"] = undefined;
export { className as class };
</script>

<AvatarPrimitive.Root
	{delayMs}
	class={cn("relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full", className)}
	{...$$restProps}
>
	<slot />
</AvatarPrimitive.Root>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/avatar/index.ts
```typescript
import Root from "./avatar.svelte";
import Image from "./avatar-image.svelte";
import Fallback from "./avatar-fallback.svelte";

export {
	Root,
	Image,
	Fallback,
	//
	Root as Avatar,
	Image as AvatarImage,
	Fallback as AvatarFallback,
};

```
