/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/alert-dialog/alert-dialog-action.svelte
```
<script lang="ts">
import { AlertDialog as AlertDialogPrimitive } from "bits-ui";

type $$Props = AlertDialogPrimitive.ActionProps;
type $$Events = AlertDialogPrimitive.ActionEvents;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<AlertDialogPrimitive.Action
	class={cn(buttonVariants(), className)}
	{...$$restProps}
	on:click
	on:keydown
	let:builder
>
	<slot {builder} />
</AlertDialogPrimitive.Action>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/alert-dialog/alert-dialog-cancel.svelte
```
<script lang="ts">
import { AlertDialog as AlertDialogPrimitive } from "bits-ui";

type $$Props = AlertDialogPrimitive.CancelProps;
type $$Events = AlertDialogPrimitive.CancelEvents;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<AlertDialogPrimitive.Cancel
	class={cn(buttonVariants({ variant: "outline" }), "mt-2 sm:mt-0", className)}
	{...$$restProps}
	on:click
	on:keydown
	let:builder
>
	<slot {builder} />
</AlertDialogPrimitive.Cancel>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/alert-dialog/alert-dialog-content.svelte
```
<script lang="ts">
import { AlertDialog as AlertDialogPrimitive } from "bits-ui";
import { flyAndScale } from "$lib/utils.js";

type $$Props = AlertDialogPrimitive.ContentProps;

let className: $$Props["class"] = undefined;
export let transition: $$Props["transition"] = flyAndScale;
export let transitionConfig: $$Props["transitionConfig"] = undefined;
export { className as class };
</script>

<AlertDialog.Portal>
	<AlertDialog.Overlay />
	<AlertDialogPrimitive.Content
		{transition}
		{transitionConfig}
		class={cn(
			"bg-background fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border p-6 shadow-lg  sm:rounded-lg md:w-full",
			className
		)}
		{...$$restProps}
	>
		<slot />
	</AlertDialogPrimitive.Content>
</AlertDialog.Portal>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/alert-dialog/alert-dialog-description.svelte
```
<script lang="ts">
import { AlertDialog as AlertDialogPrimitive } from "bits-ui";

type $$Props = AlertDialogPrimitive.DescriptionProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<AlertDialogPrimitive.Description
	class={cn("text-muted-foreground text-sm", className)}
	{...$$restProps}
>
	<slot />
</AlertDialogPrimitive.Description>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/alert-dialog/alert-dialog-footer.svelte
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
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/alert-dialog/alert-dialog-header.svelte
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
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/alert-dialog/alert-dialog-overlay.svelte
```
<script lang="ts">
import { AlertDialog as AlertDialogPrimitive } from "bits-ui";
import { fade } from "svelte/transition";

type $$Props = AlertDialogPrimitive.OverlayProps;

let className: $$Props["class"] = undefined;
export let transition: $$Props["transition"] = fade;
export let transitionConfig: $$Props["transitionConfig"] = {
	duration: 150,
};
export { className as class };
</script>

<AlertDialogPrimitive.Overlay
	{transition}
	{transitionConfig}
	class={cn("bg-background/80 fixed inset-0 z-50 backdrop-blur-sm", className)}
	{...$$restProps}
/>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/alert-dialog/alert-dialog-portal.svelte
```
<script lang="ts">
import { AlertDialog as AlertDialogPrimitive } from "bits-ui";

type $$Props = AlertDialogPrimitive.PortalProps;
</script>

<AlertDialogPrimitive.Portal {...$$restProps}>
	<slot />
</AlertDialogPrimitive.Portal>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/alert-dialog/alert-dialog-title.svelte
```
<script lang="ts">
import { AlertDialog as AlertDialogPrimitive } from "bits-ui";

type $$Props = AlertDialogPrimitive.TitleProps;

let className: $$Props["class"] = undefined;
export let level: $$Props["level"] = "h3";
export { className as class };
</script>

<AlertDialogPrimitive.Title class={cn("text-lg font-semibold", className)} {level} {...$$restProps}>
	<slot />
</AlertDialogPrimitive.Title>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/alert-dialog/index.ts
```typescript
import { AlertDialog as AlertDialogPrimitive } from "bits-ui";

import Title from "./alert-dialog-title.svelte";
import Action from "./alert-dialog-action.svelte";
import Cancel from "./alert-dialog-cancel.svelte";
import Portal from "./alert-dialog-portal.svelte";
import Footer from "./alert-dialog-footer.svelte";
import Header from "./alert-dialog-header.svelte";
import Overlay from "./alert-dialog-overlay.svelte";
import Content from "./alert-dialog-content.svelte";
import Description from "./alert-dialog-description.svelte";

const Root = AlertDialogPrimitive.Root;
const Trigger = AlertDialogPrimitive.Trigger;

export {
	Root,
	Title,
	Action,
	Cancel,
	Portal,
	Footer,
	Header,
	Trigger,
	Overlay,
	Content,
	Description,
	//
	Root as AlertDialog,
	Title as AlertDialogTitle,
	Action as AlertDialogAction,
	Cancel as AlertDialogCancel,
	Portal as AlertDialogPortal,
	Footer as AlertDialogFooter,
	Header as AlertDialogHeader,
	Trigger as AlertDialogTrigger,
	Overlay as AlertDialogOverlay,
	Content as AlertDialogContent,
	Description as AlertDialogDescription,
};

```
