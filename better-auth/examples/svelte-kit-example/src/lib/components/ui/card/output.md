/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/card/card-content.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLDivElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<div class={cn("p-6 pt-0", className)} {...$$restProps}>
	<slot />
</div>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/card/card-description.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLParagraphElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<p class={cn("text-muted-foreground text-sm", className)} {...$$restProps}>
	<slot />
</p>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/card/card-footer.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLDivElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<div class={cn("flex items-center p-6 pt-0", className)} {...$$restProps}>
	<slot />
</div>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/card/card-header.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLDivElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<div class={cn("flex flex-col space-y-1.5 p-6", className)} {...$$restProps}>
	<slot />
</div>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/card/card-title.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";
import type { HeadingLevel } from "./index.js";

type $$Props = HTMLAttributes<HTMLHeadingElement> & {
	tag?: HeadingLevel;
};

let className: $$Props["class"] = undefined;
export let tag: $$Props["tag"] = "h3";
export { className as class };
</script>

<svelte:element
	this={tag}
	class={cn("font-semibold leading-none tracking-tight", className)}
	{...$$restProps}
>
	<slot />
</svelte:element>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/card/card.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLDivElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<!-- svelte-ignore a11y-no-static-element-interactions -->
<div
	class={cn("bg-card text-card-foreground rounded-xl border shadow", className)}
	{...$$restProps}
	on:click
	on:focusin
	on:focusout
	on:mouseenter
	on:mouseleave
>
	<slot />
</div>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/card/index.ts
```typescript
import Root from "./card.svelte";
import Content from "./card-content.svelte";
import Description from "./card-description.svelte";
import Footer from "./card-footer.svelte";
import Header from "./card-header.svelte";
import Title from "./card-title.svelte";

export {
	Root,
	Content,
	Description,
	Footer,
	Header,
	Title,
	//
	Root as Card,
	Content as CardContent,
	Description as CardDescription,
	Footer as CardFooter,
	Header as CardHeader,
	Title as CardTitle,
};

export type HeadingLevel = "h1" | "h2" | "h3" | "h4" | "h5" | "h6";

```
