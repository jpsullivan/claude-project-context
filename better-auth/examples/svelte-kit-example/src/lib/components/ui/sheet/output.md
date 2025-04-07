/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/sheet/index.ts
```typescript
import { Dialog as SheetPrimitive } from "bits-ui";
import { type VariantProps, tv } from "tailwind-variants";

import Portal from "./sheet-portal.svelte";
import Overlay from "./sheet-overlay.svelte";
import Content from "./sheet-content.svelte";
import Header from "./sheet-header.svelte";
import Footer from "./sheet-footer.svelte";
import Title from "./sheet-title.svelte";
import Description from "./sheet-description.svelte";

const Root = SheetPrimitive.Root;
const Close = SheetPrimitive.Close;
const Trigger = SheetPrimitive.Trigger;

export {
	Root,
	Close,
	Trigger,
	Portal,
	Overlay,
	Content,
	Header,
	Footer,
	Title,
	Description,
	//
	Root as Sheet,
	Close as SheetClose,
	Trigger as SheetTrigger,
	Portal as SheetPortal,
	Overlay as SheetOverlay,
	Content as SheetContent,
	Header as SheetHeader,
	Footer as SheetFooter,
	Title as SheetTitle,
	Description as SheetDescription,
};

export const sheetVariants = tv({
	base: "bg-background fixed z-50 gap-4 p-6 shadow-lg",
	variants: {
		side: {
			top: "inset-x-0 top-0 border-b ",
			bottom: "inset-x-0 bottom-0 border-t",
			left: "inset-y-0 left-0 h-full w-3/4 border-r sm:max-w-sm",
			right: "inset-y-0 right-0 h-full w-3/4 border-l sm:max-w-sm",
		},
	},
	defaultVariants: {
		side: "right",
	},
});

export const sheetTransitions = {
	top: {
		in: {
			y: "-100%",
			duration: 500,
			opacity: 1,
		},
		out: {
			y: "-100%",
			duration: 300,
			opacity: 1,
		},
	},
	bottom: {
		in: {
			y: "100%",
			duration: 500,
			opacity: 1,
		},
		out: {
			y: "100%",
			duration: 300,
			opacity: 1,
		},
	},
	left: {
		in: {
			x: "-100%",
			duration: 500,
			opacity: 1,
		},
		out: {
			x: "-100%",
			duration: 300,
			opacity: 1,
		},
	},
	right: {
		in: {
			x: "100%",
			duration: 500,
			opacity: 1,
		},
		out: {
			x: "100%",
			duration: 300,
			opacity: 1,
		},
	},
};

export type Side = VariantProps<typeof sheetVariants>["side"];

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/sheet/sheet-content.svelte
```
<script lang="ts">
import { Dialog as SheetPrimitive } from "bits-ui";
import { fly } from "svelte/transition";
import { type Side, sheetTransitions } from "./index.js";

type $$Props = SheetPrimitive.ContentProps & {
	side?: Side;
};

let className: $$Props["class"] = undefined;
export let side: $$Props["side"] = "right";
export { className as class };
export let inTransition: $$Props["inTransition"] = fly;
export let inTransitionConfig: $$Props["inTransitionConfig"] =
	sheetTransitions[side ?? "right"].in;
export let outTransition: $$Props["outTransition"] = fly;
export let outTransitionConfig: $$Props["outTransitionConfig"] =
	sheetTransitions[side ?? "right"].out;
</script>

<SheetPortal>
	<SheetOverlay />
	<SheetPrimitive.Content
		{inTransition}
		{inTransitionConfig}
		{outTransition}
		{outTransitionConfig}
		class={cn(sheetVariants({ side }), className)}
		{...$$restProps}
	>
		<slot />
		<SheetPrimitive.Close
			class="ring-offset-background focus:ring-ring data-[state=open]:bg-secondary absolute right-4 top-4 rounded-sm opacity-70 transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:pointer-events-none"
		>
			<Cross2 class="h-4 w-4" />
			<span class="sr-only">Close</span>
		</SheetPrimitive.Close>
	</SheetPrimitive.Content>
</SheetPortal>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/sheet/sheet-description.svelte
```
<script lang="ts">
import { Dialog as SheetPrimitive } from "bits-ui";

type $$Props = SheetPrimitive.DescriptionProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<SheetPrimitive.Description class={cn("text-muted-foreground text-sm", className)} {...$$restProps}>
	<slot />
</SheetPrimitive.Description>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/sheet/sheet-footer.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLDivElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<div
	class={cn("flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2", className)}
	{...$$restProps}
>
	<slot />
</div>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/sheet/sheet-header.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLDivElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<div class={cn("flex flex-col space-y-2 text-center sm:text-left", className)} {...$$restProps}>
	<slot />
</div>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/sheet/sheet-overlay.svelte
```
<script lang="ts">
import { Dialog as SheetPrimitive } from "bits-ui";
import { fade } from "svelte/transition";

type $$Props = SheetPrimitive.OverlayProps;

let className: $$Props["class"] = undefined;
export { className as class };
export let transition: $$Props["transition"] = fade;
export let transitionConfig: $$Props["transitionConfig"] = {
	duration: 150,
};
</script>

<SheetPrimitive.Overlay
	{transition}
	{transitionConfig}
	class={cn("bg-background/80 fixed inset-0 z-50 backdrop-blur-sm", className)}
	{...$$restProps}
/>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/sheet/sheet-portal.svelte
```
<script lang="ts">
import { Dialog as SheetPrimitive } from "bits-ui";

type $$Props = SheetPrimitive.PortalProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<SheetPrimitive.Portal class={cn(className)} {...$$restProps}>
	<slot />
</SheetPrimitive.Portal>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/sheet/sheet-title.svelte
```
<script lang="ts">
import { Dialog as SheetPrimitive } from "bits-ui";

type $$Props = SheetPrimitive.TitleProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<SheetPrimitive.Title
	class={cn("text-foreground text-lg font-semibold", className)}
	{...$$restProps}
>
	<slot />
</SheetPrimitive.Title>

```
