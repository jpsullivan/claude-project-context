/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dialog/dialog-content.svelte
```
<script lang="ts">
import { Dialog as DialogPrimitive } from "bits-ui";
import { flyAndScale } from "$lib/utils.js";

type $$Props = DialogPrimitive.ContentProps;

let className: $$Props["class"] = undefined;
export let transition: $$Props["transition"] = flyAndScale;
export let transitionConfig: $$Props["transitionConfig"] = {
	duration: 200,
};
export { className as class };
</script>

<Dialog.Portal>
	<Dialog.Overlay />
	<DialogPrimitive.Content
		{transition}
		{transitionConfig}
		class={cn(
			"bg-background fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border p-6 shadow-lg sm:rounded-lg md:w-full",
			className
		)}
		{...$$restProps}
	>
		<slot />
		<DialogPrimitive.Close
			class="ring-offset-background focus:ring-ring data-[state=open]:bg-accent data-[state=open]:text-muted-foreground absolute right-4 top-4 rounded-sm opacity-70 transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:pointer-events-none"
		>
			<Cross2 class="h-4 w-4" />
			<span class="sr-only">Close</span>
		</DialogPrimitive.Close>
	</DialogPrimitive.Content>
</Dialog.Portal>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dialog/dialog-description.svelte
```
<script lang="ts">
import { Dialog as DialogPrimitive } from "bits-ui";

type $$Props = DialogPrimitive.DescriptionProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<DialogPrimitive.Description
	class={cn("text-muted-foreground text-sm", className)}
	{...$$restProps}
>
	<slot />
</DialogPrimitive.Description>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dialog/dialog-footer.svelte
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
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dialog/dialog-header.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLDivElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<div class={cn("flex flex-col space-y-1.5 text-center sm:text-left", className)} {...$$restProps}>
	<slot />
</div>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dialog/dialog-overlay.svelte
```
<script lang="ts">
import { Dialog as DialogPrimitive } from "bits-ui";
import { fade } from "svelte/transition";

type $$Props = DialogPrimitive.OverlayProps;

let className: $$Props["class"] = undefined;
export let transition: $$Props["transition"] = fade;
export let transitionConfig: $$Props["transitionConfig"] = {
	duration: 150,
};
export { className as class };
</script>

<DialogPrimitive.Overlay
	{transition}
	{transitionConfig}
	class={cn("bg-background/80 fixed inset-0 z-50 backdrop-blur-sm ", className)}
	{...$$restProps}
/>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dialog/dialog-portal.svelte
```
<script lang="ts">
import { Dialog as DialogPrimitive } from "bits-ui";

type $$Props = DialogPrimitive.PortalProps;
</script>

<DialogPrimitive.Portal {...$$restProps}>
	<slot />
</DialogPrimitive.Portal>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dialog/dialog-title.svelte
```
<script lang="ts">
import { Dialog as DialogPrimitive } from "bits-ui";

type $$Props = DialogPrimitive.TitleProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<DialogPrimitive.Title
	class={cn("text-lg font-semibold leading-none tracking-tight", className)}
	{...$$restProps}
>
	<slot />
</DialogPrimitive.Title>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dialog/index.ts
```typescript
import { Dialog as DialogPrimitive } from "bits-ui";

import Title from "./dialog-title.svelte";
import Portal from "./dialog-portal.svelte";
import Footer from "./dialog-footer.svelte";
import Header from "./dialog-header.svelte";
import Overlay from "./dialog-overlay.svelte";
import Content from "./dialog-content.svelte";
import Description from "./dialog-description.svelte";

const Root = DialogPrimitive.Root;
const Trigger = DialogPrimitive.Trigger;
const Close = DialogPrimitive.Close;

export {
	Root,
	Title,
	Portal,
	Footer,
	Header,
	Trigger,
	Overlay,
	Content,
	Description,
	Close,
	//
	Root as Dialog,
	Title as DialogTitle,
	Portal as DialogPortal,
	Footer as DialogFooter,
	Header as DialogHeader,
	Trigger as DialogTrigger,
	Overlay as DialogOverlay,
	Content as DialogContent,
	Description as DialogDescription,
	Close as DialogClose,
};

```
