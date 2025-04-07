/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/select/index.ts
```typescript
import { Select as SelectPrimitive } from "bits-ui";

import Label from "./select-label.svelte";
import Item from "./select-item.svelte";
import Content from "./select-content.svelte";
import Trigger from "./select-trigger.svelte";
import Separator from "./select-separator.svelte";

const Root = SelectPrimitive.Root;
const Group = SelectPrimitive.Group;
const Input = SelectPrimitive.Input;
const Value = SelectPrimitive.Value;

export {
	Root,
	Item,
	Group,
	Input,
	Label,
	Value,
	Content,
	Trigger,
	Separator,
	//
	Root as Select,
	Item as SelectItem,
	Group as SelectGroup,
	Input as SelectInput,
	Label as SelectLabel,
	Value as SelectValue,
	Content as SelectContent,
	Trigger as SelectTrigger,
	Separator as SelectSeparator,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/select/select-content.svelte
```
<script lang="ts">
import { Select as SelectPrimitive } from "bits-ui";
import { scale } from "svelte/transition";
import { flyAndScale } from "$lib/utils.js";

type $$Props = SelectPrimitive.ContentProps;

let className: $$Props["class"] = undefined;
export let sideOffset: $$Props["sideOffset"] = 4;
export let inTransition: $$Props["inTransition"] = flyAndScale;
export let inTransitionConfig: $$Props["inTransitionConfig"] = undefined;
export let outTransition: $$Props["outTransition"] = scale;
export let outTransitionConfig: $$Props["outTransitionConfig"] = {
	start: 0.95,
	opacity: 0,
	duration: 50,
};
export { className as class };
</script>

<SelectPrimitive.Content
	{inTransition}
	{inTransitionConfig}
	{outTransition}
	{outTransitionConfig}
	{sideOffset}
	class={cn(
		"bg-popover text-popover-foreground relative z-50 min-w-[8rem] overflow-hidden rounded-md border shadow-md focus:outline-none",
		className
	)}
	{...$$restProps}
>
	<div class="w-full p-1">
		<slot />
	</div>
</SelectPrimitive.Content>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/select/select-item.svelte
```
<script lang="ts">
import { Select as SelectPrimitive } from "bits-ui";

type $$Props = SelectPrimitive.ItemProps;
type $$Events = Required<SelectPrimitive.ItemEvents>;

let className: $$Props["class"] = undefined;
export let value: $$Props["value"];
export let label: $$Props["label"] = undefined;
export let disabled: $$Props["disabled"] = undefined;
export { className as class };
</script>

<SelectPrimitive.Item
	{value}
	{disabled}
	{label}
	class={cn(
		"data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-2 pr-8 text-sm outline-none data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
		className
	)}
	{...$$restProps}
	on:click
	on:pointermove
	on:focusin
>
	<span class="absolute right-2 flex h-3.5 w-3.5 items-center justify-center">
		<SelectPrimitive.ItemIndicator>
			<Check class="h-4 w-4" />
		</SelectPrimitive.ItemIndicator>
	</span>
	<slot>
		{label || value}
	</slot>
</SelectPrimitive.Item>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/select/select-label.svelte
```
<script lang="ts">
import { Select as SelectPrimitive } from "bits-ui";

type $$Props = SelectPrimitive.LabelProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<SelectPrimitive.Label class={cn("px-2 py-1.5 text-sm font-semibold", className)} {...$$restProps}>
	<slot />
</SelectPrimitive.Label>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/select/select-separator.svelte
```
<script lang="ts">
import { Select as SelectPrimitive } from "bits-ui";

type $$Props = SelectPrimitive.SeparatorProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<SelectPrimitive.Separator class={cn("bg-muted -mx-1 my-1 h-px", className)} {...$$restProps} />

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/select/select-trigger.svelte
```
<script lang="ts">
import { Select as SelectPrimitive } from "bits-ui";

type $$Props = SelectPrimitive.TriggerProps;
type $$Events = SelectPrimitive.TriggerEvents;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<SelectPrimitive.Trigger
	class={cn(
		"border-input ring-offset-background placeholder:text-muted-foreground focus-visible:ring-ring aria-[invalid]:border-destructive data-[placeholder]:[&>span]:text-muted-foreground flex h-9 w-full items-center justify-between whitespace-nowrap rounded-md border bg-transparent px-3 py-2 text-sm shadow-sm focus-visible:outline-none focus-visible:ring-1 disabled:cursor-not-allowed disabled:opacity-50 [&>span]:line-clamp-1",
		className
	)}
	{...$$restProps}
>
	<slot />
	<div>
		<CaretSort class="h-4 w-4 opacity-50" />
	</div>
</SelectPrimitive.Trigger>

```
