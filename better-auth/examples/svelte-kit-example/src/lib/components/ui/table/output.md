/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/table/index.ts
```typescript
import Root from "./table.svelte";
import Body from "./table-body.svelte";
import Caption from "./table-caption.svelte";
import Cell from "./table-cell.svelte";
import Footer from "./table-footer.svelte";
import Head from "./table-head.svelte";
import Header from "./table-header.svelte";
import Row from "./table-row.svelte";

export {
	Root,
	Body,
	Caption,
	Cell,
	Footer,
	Head,
	Header,
	Row,
	//
	Root as Table,
	Body as TableBody,
	Caption as TableCaption,
	Cell as TableCell,
	Footer as TableFooter,
	Head as TableHead,
	Header as TableHeader,
	Row as TableRow,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/table/table-body.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLTableSectionElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<tbody class={cn("[&_tr:last-child]:border-0", className)} {...$$restProps}>
	<slot />
</tbody>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/table/table-caption.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLTableCaptionElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<caption class={cn("text-muted-foreground mt-4 text-sm", className)} {...$$restProps}>
	<slot />
</caption>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/table/table-cell.svelte
```
<script lang="ts">
import type { HTMLTdAttributes } from "svelte/elements";

type $$Props = HTMLTdAttributes;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<td
	class={cn(
		"p-2 align-middle [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
		className
	)}
	{...$$restProps}
	on:click
	on:keydown
>
	<slot />
</td>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/table/table-footer.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLTableSectionElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<tfoot class={cn("bg-primary text-primary-foreground font-medium", className)} {...$$restProps}>
	<slot />
</tfoot>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/table/table-head.svelte
```
<script lang="ts">
import type { HTMLThAttributes } from "svelte/elements";

type $$Props = HTMLThAttributes;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<th
	class={cn(
		"text-muted-foreground h-10 px-2 text-left align-middle font-medium [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
		className
	)}
	{...$$restProps}
>
	<slot />
</th>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/table/table-header.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLTableSectionElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<!-- svelte-ignore a11y-no-noninteractive-element-interactions -->
<thead class={cn("[&_tr]:border-b", className)} {...$$restProps} on:click on:keydown>
	<slot />
</thead>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/table/table-row.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLTableRowElement> & {
	"data-state"?: unknown;
};

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<tr
	class={cn(
		"hover:bg-muted/50 data-[state=selected]:bg-muted border-b transition-colors",
		className
	)}
	{...$$restProps}
	on:click
	on:keydown
>
	<slot />
</tr>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/table/table.svelte
```
<script lang="ts">
import type { HTMLTableAttributes } from "svelte/elements";

type $$Props = HTMLTableAttributes;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<div class="relative w-full overflow-auto">
	<table class={cn("w-full caption-bottom text-sm", className)} {...$$restProps}>
		<slot />
	</table>
</div>

```
