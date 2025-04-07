/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/drawer/drawer-content.svelte
```
<script lang="ts">
import { Drawer as DrawerPrimitive } from "vaul-svelte";

type $$Props = DrawerPrimitive.ContentProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<DrawerPrimitive.Portal>
	<DrawerOverlay />
	<DrawerPrimitive.Content
		class={cn(
			"bg-background fixed inset-x-0 bottom-0 z-50 mt-24 flex h-auto flex-col rounded-t-[10px] border",
			className
		)}
		{...$$restProps}
	>
		<div class="bg-muted mx-auto mt-4 h-2 w-[100px] rounded-full"></div>
		<slot />
	</DrawerPrimitive.Content>
</DrawerPrimitive.Portal>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/drawer/drawer-description.svelte
```
<script lang="ts">
import { Drawer as DrawerPrimitive } from "vaul-svelte";

type $$Props = DrawerPrimitive.DescriptionProps;

export let el: $$Props["el"] = undefined;
let className: $$Props["class"] = undefined;
export { className as class };
</script>

<DrawerPrimitive.Description
	bind:el
	class={cn("text-muted-foreground text-sm", className)}
	{...$$restProps}
>
	<slot />
</DrawerPrimitive.Description>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/drawer/drawer-footer.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLDivElement> & {
	el?: HTMLDivElement;
};

export let el: $$Props["el"] = undefined;
let className: $$Props["class"] = undefined;
export { className as class };
</script>

<div bind:this={el} class={cn("mt-auto flex flex-col gap-2 p-4", className)} {...$$restProps}>
	<slot />
</div>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/drawer/drawer-header.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLDivElement> & {
	el?: HTMLDivElement;
};
export let el: $$Props["el"] = undefined;
let className: $$Props["class"] = undefined;
export { className as class };
</script>

<div
	bind:this={el}
	class={cn("grid gap-1.5 p-4 text-center sm:text-left", className)}
	{...$$restProps}
>
	<slot />
</div>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/drawer/drawer-nested.svelte
```
<script lang="ts">
import { Drawer as DrawerPrimitive } from "vaul-svelte";

type $$Props = DrawerPrimitive.Props;
export let shouldScaleBackground: $$Props["shouldScaleBackground"] = true;
export let open: $$Props["open"] = false;
export let activeSnapPoint: $$Props["activeSnapPoint"] = undefined;
</script>

<DrawerPrimitive.NestedRoot {shouldScaleBackground} bind:open bind:activeSnapPoint {...$$restProps}>
	<slot />
</DrawerPrimitive.NestedRoot>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/drawer/drawer-overlay.svelte
```
<script lang="ts">
import { Drawer as DrawerPrimitive } from "vaul-svelte";

type $$Props = DrawerPrimitive.OverlayProps;

export let el: $$Props["el"] = undefined;
let className: $$Props["class"] = undefined;
export { className as class };
</script>

<DrawerPrimitive.Overlay
	bind:el
	class={cn("fixed inset-0 z-50 bg-black/80", className)}
	{...$$restProps}
>
	<slot />
</DrawerPrimitive.Overlay>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/drawer/drawer-title.svelte
```
<script lang="ts">
import { Drawer as DrawerPrimitive } from "vaul-svelte";

type $$Props = DrawerPrimitive.TitleProps;

export let el: $$Props["el"] = undefined;
let className: $$Props["class"] = undefined;
export { className as class };
</script>

<DrawerPrimitive.Title
	bind:el
	class={cn("text-lg font-semibold leading-none tracking-tight", className)}
	{...$$restProps}
>
	<slot />
</DrawerPrimitive.Title>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/drawer/drawer.svelte
```
<script lang="ts">
import { Drawer as DrawerPrimitive } from "vaul-svelte";

type $$Props = DrawerPrimitive.Props;
export let shouldScaleBackground: $$Props["shouldScaleBackground"] = true;
export let open: $$Props["open"] = false;
export let activeSnapPoint: $$Props["activeSnapPoint"] = undefined;
</script>

<DrawerPrimitive.Root {shouldScaleBackground} bind:open bind:activeSnapPoint {...$$restProps}>
	<slot />
</DrawerPrimitive.Root>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/drawer/index.ts
```typescript
import { Drawer as DrawerPrimitive } from "vaul-svelte";

import Root from "./drawer.svelte";
import Content from "./drawer-content.svelte";
import Description from "./drawer-description.svelte";
import Overlay from "./drawer-overlay.svelte";
import Footer from "./drawer-footer.svelte";
import Header from "./drawer-header.svelte";
import Title from "./drawer-title.svelte";
import NestedRoot from "./drawer-nested.svelte";

const Trigger = DrawerPrimitive.Trigger;
const Portal = DrawerPrimitive.Portal;
const Close = DrawerPrimitive.Close;

export {
	Root,
	NestedRoot,
	Content,
	Description,
	Overlay,
	Footer,
	Header,
	Title,
	Trigger,
	Portal,
	Close,
	//
	Root as Drawer,
	NestedRoot as DrawerNestedRoot,
	Content as DrawerContent,
	Description as DrawerDescription,
	Overlay as DrawerOverlay,
	Footer as DrawerFooter,
	Header as DrawerHeader,
	Title as DrawerTitle,
	Trigger as DrawerTrigger,
	Portal as DrawerPortal,
	Close as DrawerClose,
};

```
