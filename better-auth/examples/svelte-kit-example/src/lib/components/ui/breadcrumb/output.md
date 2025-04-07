/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/breadcrumb/breadcrumb-ellipsis.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLSpanElement> & {
	el?: HTMLSpanElement;
};

export let el: $$Props["el"] = undefined;
let className: $$Props["class"] = undefined;
export { className as class };
</script>

<span
	bind:this={el}
	role="presentation"
	aria-hidden="true"
	class={cn("flex h-9 w-9 items-center justify-center", className)}
	{...$$restProps}
>
	<DotsHorizontal class="h-4 w-4 outline-none" tabindex="-1" />
	<span class="sr-only">More</span>
</span>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/breadcrumb/breadcrumb-item.svelte
```
<script lang="ts">
import type { HTMLLiAttributes } from "svelte/elements";

type $$Props = HTMLLiAttributes & {
	el?: HTMLLIElement;
};

export let el: $$Props["el"] = undefined;
let className: $$Props["class"] = undefined;
export { className as class };
</script>

<li bind:this={el} class={cn("inline-flex items-center gap-1.5", className)}>
	<slot />
</li>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/breadcrumb/breadcrumb-link.svelte
```
<script lang="ts">
import type { HTMLAnchorAttributes } from "svelte/elements";
import { cn } from "$lib/utils.js";

type $$Props = HTMLAnchorAttributes & {
	el?: HTMLAnchorElement;
	asChild?: boolean;
};

export let href: $$Props["href"] = undefined;
export let el: $$Props["el"] = undefined;
export let asChild: $$Props["asChild"] = false;
let className: $$Props["class"] = undefined;
export { className as class };

let attrs: Record<string, unknown>;

$: attrs = {
	class: cn("hover:text-foreground transition-colors", className),
	href,
	...$$restProps,
};
</script>

{#if asChild}
	<slot {attrs} />
{:else}
	<a bind:this={el} {...attrs} {href}>
		<slot {attrs} />
	</a>
{/if}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/breadcrumb/breadcrumb-list.svelte
```
<script lang="ts">
import type { HTMLOlAttributes } from "svelte/elements";

type $$Props = HTMLOlAttributes & {
	el?: HTMLOListElement;
};

export let el: $$Props["el"] = undefined;
let className: $$Props["class"] = undefined;
export { className as class };
</script>

<ol
	bind:this={el}
	class={cn(
		"text-muted-foreground flex flex-wrap items-center gap-1.5 break-words text-sm sm:gap-2.5",
		className
	)}
	{...$$restProps}
>
	<slot />
</ol>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/breadcrumb/breadcrumb-page.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLSpanElement> & {
	el?: HTMLSpanElement;
};

export let el: $$Props["el"] = undefined;
export let className: $$Props["class"] = undefined;
export { className as class };
</script>

<span
	bind:this={el}
	role="link"
	aria-disabled="true"
	aria-current="page"
	class={cn("text-foreground font-normal", className)}
	{...$$restProps}
>
	<slot />
</span>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/breadcrumb/breadcrumb-separator.svelte
```
<script lang="ts">
import type { HTMLLiAttributes } from "svelte/elements";

type $$Props = HTMLLiAttributes & {
	el?: HTMLLIElement;
};

export let el: $$Props["el"] = undefined;
let className: $$Props["class"] = undefined;
export { className as class };
</script>

<li
	role="presentation"
	aria-hidden="true"
	class={cn("[&>svg]:size-3.5", className)}
	bind:this={el}
	{...$$restProps}
>
	<slot>
		<ChevronRight tabindex="-1" />
	</slot>
</li>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/breadcrumb/breadcrumb.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLElement> & {
	el?: HTMLElement;
};

export let el: $$Props["el"] = undefined;
let className: $$Props["class"] = undefined;
export { className as class };
</script>

<nav class={className} bind:this={el} aria-label="breadcrumb" {...$$restProps}>
	<slot />
</nav>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/breadcrumb/index.ts
```typescript
import Root from "./breadcrumb.svelte";
import Ellipsis from "./breadcrumb-ellipsis.svelte";
import Item from "./breadcrumb-item.svelte";
import Separator from "./breadcrumb-separator.svelte";
import Link from "./breadcrumb-link.svelte";
import List from "./breadcrumb-list.svelte";
import Page from "./breadcrumb-page.svelte";

export {
	Root,
	Ellipsis,
	Item,
	Separator,
	Link,
	List,
	Page,
	//
	Root as Breadcrumb,
	Ellipsis as BreadcrumbEllipsis,
	Item as BreadcrumbItem,
	Separator as BreadcrumbSeparator,
	Link as BreadcrumbLink,
	List as BreadcrumbList,
	Page as BreadcrumbPage,
};

```
