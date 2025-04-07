/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dropdown-menu/dropdown-menu-checkbox-item.svelte
```
<script lang="ts">
import { DropdownMenu as DropdownMenuPrimitive } from "bits-ui";

type $$Props = DropdownMenuPrimitive.CheckboxItemProps;
type $$Events = DropdownMenuPrimitive.CheckboxItemEvents;

let className: $$Props["class"] = undefined;
export let checked: $$Props["checked"] = undefined;
export { className as class };
</script>

<DropdownMenuPrimitive.CheckboxItem
	bind:checked
	class={cn(
		"data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
		className
	)}
	{...$$restProps}
	on:click
	on:keydown
	on:focusin
	on:focusout
	on:pointerdown
	on:pointerleave
	on:pointermove
>
	<span class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
		<DropdownMenuPrimitive.CheckboxIndicator>
			<Check class="h-4 w-4" />
		</DropdownMenuPrimitive.CheckboxIndicator>
	</span>
	<slot />
</DropdownMenuPrimitive.CheckboxItem>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dropdown-menu/dropdown-menu-content.svelte
```
<script lang="ts">
import { DropdownMenu as DropdownMenuPrimitive } from "bits-ui";
import { flyAndScale } from "$lib/utils.js";

type $$Props = DropdownMenuPrimitive.ContentProps;

let className: $$Props["class"] = undefined;
export let sideOffset: $$Props["sideOffset"] = 4;
export let transition: $$Props["transition"] = flyAndScale;
export let transitionConfig: $$Props["transitionConfig"] = undefined;
export { className as class };
</script>

<DropdownMenuPrimitive.Content
	{transition}
	{transitionConfig}
	{sideOffset}
	class={cn(
		"bg-popover text-popover-foreground z-50 min-w-[8rem] rounded-md border p-1 shadow-md focus:outline-none",
		className
	)}
	{...$$restProps}
	on:keydown
>
	<slot />
</DropdownMenuPrimitive.Content>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dropdown-menu/dropdown-menu-item.svelte
```
<script lang="ts">
import { DropdownMenu as DropdownMenuPrimitive } from "bits-ui";

type $$Props = DropdownMenuPrimitive.ItemProps & {
	inset?: boolean;
};
type $$Events = DropdownMenuPrimitive.ItemEvents;

let className: $$Props["class"] = undefined;
export let inset: $$Props["inset"] = undefined;
export { className as class };
</script>

<DropdownMenuPrimitive.Item
	class={cn(
		"data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
		inset && "pl-8",
		className
	)}
	on:click
	on:keydown
	on:focusin
	on:focusout
	on:pointerdown
	on:pointerleave
	on:pointermove
	{...$$restProps}
>
	<slot />
</DropdownMenuPrimitive.Item>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dropdown-menu/dropdown-menu-label.svelte
```
<script lang="ts">
import { DropdownMenu as DropdownMenuPrimitive } from "bits-ui";

type $$Props = DropdownMenuPrimitive.LabelProps & {
	inset?: boolean;
};

let className: $$Props["class"] = undefined;
export let inset: $$Props["inset"] = undefined;
export { className as class };
</script>

<DropdownMenuPrimitive.Label
	class={cn("px-2 py-1.5 text-sm font-semibold", inset && "pl-8", className)}
	{...$$restProps}
>
	<slot />
</DropdownMenuPrimitive.Label>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dropdown-menu/dropdown-menu-radio-group.svelte
```
<script lang="ts">
import { DropdownMenu as DropdownMenuPrimitive } from "bits-ui";

type $$Props = DropdownMenuPrimitive.RadioGroupProps;

export let value: $$Props["value"] = undefined;
</script>

<DropdownMenuPrimitive.RadioGroup {...$$restProps} bind:value>
	<slot />
</DropdownMenuPrimitive.RadioGroup>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dropdown-menu/dropdown-menu-radio-item.svelte
```
<script lang="ts">
import { DropdownMenu as DropdownMenuPrimitive } from "bits-ui";

type $$Props = DropdownMenuPrimitive.RadioItemProps;
type $$Events = DropdownMenuPrimitive.RadioItemEvents;

let className: $$Props["class"] = undefined;
export let value: DropdownMenuPrimitive.RadioItemProps["value"];
export { className as class };
</script>

<DropdownMenuPrimitive.RadioItem
	class={cn(
		"data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
		className
	)}
	{value}
	{...$$restProps}
	on:click
	on:keydown
	on:focusin
	on:focusout
	on:pointerdown
	on:pointerleave
	on:pointermove
>
	<span class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
		<DropdownMenuPrimitive.RadioIndicator>
			<DotFilled class="h-4 w-4 fill-current" />
		</DropdownMenuPrimitive.RadioIndicator>
	</span>
	<slot />
</DropdownMenuPrimitive.RadioItem>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dropdown-menu/dropdown-menu-separator.svelte
```
<script lang="ts">
import { DropdownMenu as DropdownMenuPrimitive } from "bits-ui";

type $$Props = DropdownMenuPrimitive.SeparatorProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<DropdownMenuPrimitive.Separator
	class={cn("bg-muted -mx-1 my-1 h-px", className)}
	{...$$restProps}
/>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dropdown-menu/dropdown-menu-shortcut.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLSpanElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<span class={cn("ml-auto text-xs tracking-widest opacity-60", className)} {...$$restProps}>
	<slot />
</span>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dropdown-menu/dropdown-menu-sub-content.svelte
```
<script lang="ts">
import { DropdownMenu as DropdownMenuPrimitive } from "bits-ui";
import { flyAndScale } from "$lib/utils.js";

type $$Props = DropdownMenuPrimitive.SubContentProps;

let className: $$Props["class"] = undefined;
export let transition: $$Props["transition"] = flyAndScale;
export let transitionConfig: $$Props["transitionConfig"] = {
	x: -10,
	y: 0,
};
export { className as class };
</script>

<DropdownMenuPrimitive.SubContent
	{transition}
	{transitionConfig}
	class={cn(
		"bg-popover text-popover-foreground z-50 min-w-[8rem] rounded-md border p-1 shadow-lg focus:outline-none",
		className
	)}
	{...$$restProps}
	on:keydown
	on:focusout
	on:pointermove
>
	<slot />
</DropdownMenuPrimitive.SubContent>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dropdown-menu/dropdown-menu-sub-trigger.svelte
```
<script lang="ts">
import { DropdownMenu as DropdownMenuPrimitive } from "bits-ui";

type $$Props = DropdownMenuPrimitive.SubTriggerProps & {
	inset?: boolean;
};
type $$Events = DropdownMenuPrimitive.SubTriggerEvents;

let className: $$Props["class"] = undefined;
export let inset: $$Props["inset"] = undefined;
export { className as class };
</script>

<DropdownMenuPrimitive.SubTrigger
	class={cn(
		"data-[highlighted]:bg-accent data-[state=open]:bg-accent data-[highlighted]:text-accent-foreground data-[state=open]:text-accent-foreground flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none",
		inset && "pl-8",
		className
	)}
	{...$$restProps}
	on:click
	on:keydown
	on:focusin
	on:focusout
	on:pointerleave
	on:pointermove
>
	<slot />
	<ChevronRight class="ml-auto h-4 w-4" />
</DropdownMenuPrimitive.SubTrigger>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/dropdown-menu/index.ts
```typescript
import { DropdownMenu as DropdownMenuPrimitive } from "bits-ui";
import Item from "./dropdown-menu-item.svelte";
import Label from "./dropdown-menu-label.svelte";
import Content from "./dropdown-menu-content.svelte";
import Shortcut from "./dropdown-menu-shortcut.svelte";
import RadioItem from "./dropdown-menu-radio-item.svelte";
import Separator from "./dropdown-menu-separator.svelte";
import RadioGroup from "./dropdown-menu-radio-group.svelte";
import SubContent from "./dropdown-menu-sub-content.svelte";
import SubTrigger from "./dropdown-menu-sub-trigger.svelte";
import CheckboxItem from "./dropdown-menu-checkbox-item.svelte";

const Sub = DropdownMenuPrimitive.Sub;
const Root = DropdownMenuPrimitive.Root;
const Trigger = DropdownMenuPrimitive.Trigger;
const Group = DropdownMenuPrimitive.Group;

export {
	Sub,
	Root,
	Item,
	Label,
	Group,
	Trigger,
	Content,
	Shortcut,
	Separator,
	RadioItem,
	SubContent,
	SubTrigger,
	RadioGroup,
	CheckboxItem,
	//
	Root as DropdownMenu,
	Sub as DropdownMenuSub,
	Item as DropdownMenuItem,
	Label as DropdownMenuLabel,
	Group as DropdownMenuGroup,
	Content as DropdownMenuContent,
	Trigger as DropdownMenuTrigger,
	Shortcut as DropdownMenuShortcut,
	RadioItem as DropdownMenuRadioItem,
	Separator as DropdownMenuSeparator,
	RadioGroup as DropdownMenuRadioGroup,
	SubContent as DropdownMenuSubContent,
	SubTrigger as DropdownMenuSubTrigger,
	CheckboxItem as DropdownMenuCheckboxItem,
};

```
