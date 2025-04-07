/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/pagination/index.ts
```typescript
import Root from "./pagination.svelte";
import Content from "./pagination-content.svelte";
import Item from "./pagination-item.svelte";
import Link from "./pagination-link.svelte";
import PrevButton from "./pagination-prev-button.svelte";
import NextButton from "./pagination-next-button.svelte";
import Ellipsis from "./pagination-ellipsis.svelte";
export {
	Root,
	Content,
	Item,
	Link,
	PrevButton,
	NextButton,
	Ellipsis,
	//
	Root as Pagination,
	Content as PaginationContent,
	Item as PaginationItem,
	Link as PaginationLink,
	PrevButton as PaginationPrevButton,
	NextButton as PaginationNextButton,
	Ellipsis as PaginationEllipsis,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/pagination/pagination-content.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLUListElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<ul class={cn("flex flex-row items-center gap-1", className)} {...$$restProps}>
	<slot />
</ul>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/pagination/pagination-ellipsis.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLSpanElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<span
	aria-hidden
	class={cn("flex h-9 w-9 items-center justify-center", className)}
	{...$$restProps}
>
	<DotsHorizontal class="h-4 w-4" />
	<span class="sr-only">More pages</span>
</span>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/pagination/pagination-item.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLLIElement>;
let className: $$Props["class"] = undefined;

export { className as class };
</script>

<li class={cn("", className)} {...$$restProps}>
	<slot />
</li>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/pagination/pagination-link.svelte
```
<script lang="ts">
import { Pagination as PaginationPrimitive } from "bits-ui";
import { type Props } from "$lib/components/ui/button/index.js";

type $$Props = PaginationPrimitive.PageProps &
	Props & {
		isActive: boolean;
	};

type $$Events = PaginationPrimitive.PageEvents;

let className: $$Props["class"] = undefined;
export let page: $$Props["page"];
export let size: $$Props["size"] = "icon";
export let isActive: $$Props["isActive"] = false;

export { className as class };
</script>

<PaginationPrimitive.Page
	bind:page
	class={cn(
		buttonVariants({
			variant: isActive ? "outline" : "ghost",
			size,
		}),
		className
	)}
	{...$$restProps}
	on:click
>
	<slot>{page.value}</slot>
</PaginationPrimitive.Page>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/pagination/pagination-next-button.svelte
```
<script lang="ts">
import { Pagination as PaginationPrimitive } from "bits-ui";

type $$Props = PaginationPrimitive.NextButtonProps;
type $$Events = PaginationPrimitive.NextButtonEvents;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<PaginationPrimitive.NextButton asChild let:builder>
	<Button
		variant="ghost"
		class={cn("gap-1 pr-2.5", className)}
		builders={[builder]}
		on:click
		{...$$restProps}
	>
		<slot>
			<span>Next</span>
			<ChevronRight class="h-4 w-4" />
		</slot>
	</Button>
</PaginationPrimitive.NextButton>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/pagination/pagination-prev-button.svelte
```
<script lang="ts">
import { Pagination as PaginationPrimitive } from "bits-ui";

type $$Props = PaginationPrimitive.PrevButtonProps;
type $$Events = PaginationPrimitive.PrevButtonEvents;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<PaginationPrimitive.PrevButton asChild let:builder>
	<Button
		variant="ghost"
		class={cn("gap-1 pl-2.5", className)}
		builders={[builder]}
		on:click
		{...$$restProps}
	>
		<slot>
			<ChevronLeft class="h-4 w-4" />
			<span>Previous</span>
		</slot>
	</Button>
</PaginationPrimitive.PrevButton>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/pagination/pagination.svelte
```
<script lang="ts">
import { Pagination as PaginationPrimitive } from "bits-ui";

type $$Props = PaginationPrimitive.Props;
type $$Events = PaginationPrimitive.Events;

let className: $$Props["class"] = undefined;
export let count: $$Props["count"] = 0;
export let perPage: $$Props["perPage"] = 10;
export let page: $$Props["page"] = 1;
export let siblingCount: $$Props["siblingCount"] = 1;

export { className as class };

$: currentPage = page;
</script>

<PaginationPrimitive.Root
	{count}
	{perPage}
	{siblingCount}
	bind:page
	let:builder
	let:pages
	let:range
	asChild
	{...$$restProps}
>
	<nav {...builder} class={cn("mx-auto flex w-full flex-col items-center", className)}>
		<slot {pages} {range} {currentPage} />
	</nav>
</PaginationPrimitive.Root>

```
