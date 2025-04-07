/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/scroll-area/index.ts
```typescript
import Scrollbar from "./scroll-area-scrollbar.svelte";
import Root from "./scroll-area.svelte";

export {
	Root,
	Scrollbar,
	//,
	Root as ScrollArea,
	Scrollbar as ScrollAreaScrollbar,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/scroll-area/scroll-area-scrollbar.svelte
```
<script lang="ts">
import { ScrollArea as ScrollAreaPrimitive } from "bits-ui";

type $$Props = ScrollAreaPrimitive.ScrollbarProps & {
	orientation?: "vertical" | "horizontal";
};

let className: $$Props["class"] = undefined;
export let orientation: $$Props["orientation"] = "vertical";
export { className as class };
</script>

<ScrollAreaPrimitive.Scrollbar
	{orientation}
	class={cn(
		"flex touch-none select-none transition-colors",
		orientation === "vertical" && "h-full w-2.5 border-l border-l-transparent p-px",
		orientation === "horizontal" && "h-2.5 w-full border-t border-t-transparent p-px",
		className
	)}
>
	<slot />
	<ScrollAreaPrimitive.Thumb
		class={cn("bg-border relative rounded-full", orientation === "vertical" && "flex-1")}
	/>
</ScrollAreaPrimitive.Scrollbar>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/scroll-area/scroll-area.svelte
```
<script lang="ts">
import { ScrollArea as ScrollAreaPrimitive } from "bits-ui";

type $$Props = ScrollAreaPrimitive.Props & {
	orientation?: "vertical" | "horizontal" | "both";
	scrollbarXClasses?: string;
	scrollbarYClasses?: string;
};

let className: $$Props["class"] = undefined;
export { className as class };
export let orientation = "vertical";
export let scrollbarXClasses: string = "";
export let scrollbarYClasses: string = "";
</script>

<ScrollAreaPrimitive.Root {...$$restProps} class={cn("relative overflow-hidden", className)}>
	<ScrollAreaPrimitive.Viewport class="h-full w-full rounded-[inherit]">
		<ScrollAreaPrimitive.Content>
			<slot />
		</ScrollAreaPrimitive.Content>
	</ScrollAreaPrimitive.Viewport>
	{#if orientation === "vertical" || orientation === "both"}
		<Scrollbar orientation="vertical" class={scrollbarYClasses} />
	{/if}
	{#if orientation === "horizontal" || orientation === "both"}
		<Scrollbar orientation="horizontal" class={scrollbarXClasses} />
	{/if}
	<ScrollAreaPrimitive.Corner />
</ScrollAreaPrimitive.Root>

```
