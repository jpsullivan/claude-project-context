/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/accordion/accordion-content.svelte
```
<script lang="ts">
import { Accordion as AccordionPrimitive } from "bits-ui";
import { slide } from "svelte/transition";

type $$Props = AccordionPrimitive.ContentProps;

let className: $$Props["class"] = undefined;
export let transition: $$Props["transition"] = slide;
export let transitionConfig: $$Props["transitionConfig"] = {
	duration: 200,
};

export { className as class };
</script>

<AccordionPrimitive.Content
	class={cn("overflow-hidden text-sm", className)}
	{transition}
	{transitionConfig}
	{...$$restProps}
>
	<div class="pb-4 pt-0">
		<slot />
	</div>
</AccordionPrimitive.Content>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/accordion/accordion-item.svelte
```
<script lang="ts">
import { Accordion as AccordionPrimitive } from "bits-ui";

type $$Props = AccordionPrimitive.ItemProps;

let className: $$Props["class"] = undefined;
export { className as class };
export let value: $$Props["value"];
</script>

<AccordionPrimitive.Item {value} class={cn("border-b", className)} {...$$restProps}>
	<slot />
</AccordionPrimitive.Item>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/accordion/accordion-trigger.svelte
```
<script lang="ts">
import { Accordion as AccordionPrimitive } from "bits-ui";

type $$Props = AccordionPrimitive.TriggerProps;
type $$Events = AccordionPrimitive.TriggerEvents;

let className: $$Props["class"] = undefined;
export let level: AccordionPrimitive.HeaderProps["level"] = 3;
export { className as class };
</script>

<AccordionPrimitive.Header {level} class="flex">
	<AccordionPrimitive.Trigger
		class={cn(
			"flex flex-1 items-center justify-between py-4 text-sm font-medium transition-all hover:underline [&[data-state=open]>svg]:rotate-180",
			className
		)}
		{...$$restProps}
		on:click
	>
		<slot />
		<ChevronDown
			class="text-muted-foreground h-4 w-4 shrink-0 transition-transform duration-200"
		/>
	</AccordionPrimitive.Trigger>
</AccordionPrimitive.Header>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/accordion/index.ts
```typescript
import { Accordion as AccordionPrimitive } from "bits-ui";
import Content from "./accordion-content.svelte";
import Item from "./accordion-item.svelte";
import Trigger from "./accordion-trigger.svelte";

const Root = AccordionPrimitive.Root;
export {
	Root,
	Content,
	Item,
	Trigger,
	//
	Root as Accordion,
	Content as AccordionContent,
	Item as AccordionItem,
	Trigger as AccordionTrigger,
};

```
