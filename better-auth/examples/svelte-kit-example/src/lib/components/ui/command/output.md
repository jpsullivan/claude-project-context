/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/command/command-dialog.svelte
```
<script lang="ts">
import type { Dialog as DialogPrimitive } from "bits-ui";
import type { Command as CommandPrimitive } from "cmdk-sv";

type $$Props = DialogPrimitive.Props & CommandPrimitive.CommandProps;

export let open: $$Props["open"] = false;
export let value: $$Props["value"] = undefined;
</script>

<Dialog.Root bind:open {...$$restProps}>
	<Dialog.Content class="overflow-hidden p-0">
		<Command
			class="[&_[data-cmdk-group-heading]]:text-muted-foreground [&_[data-cmdk-group-heading]]:px-2 [&_[data-cmdk-group-heading]]:font-medium [&_[data-cmdk-group]:not([hidden])_~[data-cmdk-group]]:pt-0 [&_[data-cmdk-group]]:px-2 [&_[data-cmdk-input-wrapper]_svg]:h-5 [&_[data-cmdk-input-wrapper]_svg]:w-5 [&_[data-cmdk-input]]:h-12 [&_[data-cmdk-item]]:px-2 [&_[data-cmdk-item]]:py-3 [&_[data-cmdk-item]_svg]:h-5 [&_[data-cmdk-item]_svg]:w-5"
			{...$$restProps}
			bind:value
		>
			<slot />
		</Command>
	</Dialog.Content>
</Dialog.Root>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/command/command-empty.svelte
```
<script lang="ts">
import { Command as CommandPrimitive } from "cmdk-sv";

type $$Props = CommandPrimitive.EmptyProps;
let className: string | undefined | null = undefined;
export { className as class };
</script>

<CommandPrimitive.Empty class={cn("py-6 text-center text-sm", className)} {...$$restProps}>
	<slot />
</CommandPrimitive.Empty>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/command/command-group.svelte
```
<script lang="ts">
import { Command as CommandPrimitive } from "cmdk-sv";
type $$Props = CommandPrimitive.GroupProps;

let className: string | undefined | null = undefined;
export { className as class };
</script>

<CommandPrimitive.Group
	class={cn(
		"text-foreground [&_[data-cmdk-group-heading]]:text-muted-foreground overflow-hidden p-1 [&_[data-cmdk-group-heading]]:px-2 [&_[data-cmdk-group-heading]]:py-1.5 [&_[data-cmdk-group-heading]]:text-xs [&_[data-cmdk-group-heading]]:font-medium",
		className
	)}
	{...$$restProps}
>
	<slot />
</CommandPrimitive.Group>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/command/command-input.svelte
```
<script lang="ts">
import { Command as CommandPrimitive } from "cmdk-sv";

type $$Props = CommandPrimitive.InputProps;

let className: string | undefined | null = undefined;
export { className as class };
export let value: string = "";
</script>

<div class="flex items-center border-b px-3" data-cmdk-input-wrapper="">
	<MagnifyingGlass class="mr-2 h-4 w-4 shrink-0 opacity-50" />
	<CommandPrimitive.Input
		class={cn(
			"placeholder:text-muted-foreground flex h-10 w-full rounded-md bg-transparent py-3 text-sm outline-none disabled:cursor-not-allowed disabled:opacity-50",
			className
		)}
		{...$$restProps}
		bind:value
	/>
</div>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/command/command-item.svelte
```
<script lang="ts">
import { Command as CommandPrimitive } from "cmdk-sv";

type $$Props = CommandPrimitive.ItemProps;

export let asChild = false;

let className: string | undefined | null = undefined;
export { className as class };
</script>

<CommandPrimitive.Item
	{asChild}
	class={cn(
		"aria-selected:bg-accent aria-selected:text-accent-foreground relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
		className
	)}
	{...$$restProps}
	let:action
	let:attrs
>
	<slot {action} {attrs} />
</CommandPrimitive.Item>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/command/command-list.svelte
```
<script lang="ts">
import { Command as CommandPrimitive } from "cmdk-sv";

type $$Props = CommandPrimitive.ListProps;
let className: string | undefined | null = undefined;
export { className as class };
</script>

<CommandPrimitive.List
	class={cn("max-h-[300px] overflow-y-auto overflow-x-hidden", className)}
	{...$$restProps}
>
	<slot />
</CommandPrimitive.List>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/command/command-separator.svelte
```
<script lang="ts">
import { Command as CommandPrimitive } from "cmdk-sv";

type $$Props = CommandPrimitive.SeparatorProps;
let className: string | undefined | null = undefined;
export { className as class };
</script>

<CommandPrimitive.Separator class={cn("bg-border -mx-1 h-px", className)} {...$$restProps} />

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/command/command-shortcut.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLSpanElement>;

let className: string | undefined | null = undefined;
export { className as class };
</script>

<span
	class={cn("text-muted-foreground ml-auto text-xs tracking-widest", className)}
	{...$$restProps}
>
	<slot />
</span>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/command/command.svelte
```
<script lang="ts">
import { Command as CommandPrimitive } from "cmdk-sv";

type $$Props = CommandPrimitive.CommandProps;

export let value: $$Props["value"] = undefined;

let className: string | undefined | null = undefined;
export { className as class };
</script>

<CommandPrimitive.Root
	class={cn(
		"bg-popover text-popover-foreground flex h-full w-full flex-col overflow-hidden rounded-md",
		className
	)}
	bind:value
	{...$$restProps}
>
	<slot />
</CommandPrimitive.Root>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/command/index.ts
```typescript
import { Command as CommandPrimitive } from "cmdk-sv";

import Root from "./command.svelte";
import Dialog from "./command-dialog.svelte";
import Empty from "./command-empty.svelte";
import Group from "./command-group.svelte";
import Item from "./command-item.svelte";
import Input from "./command-input.svelte";
import List from "./command-list.svelte";
import Separator from "./command-separator.svelte";
import Shortcut from "./command-shortcut.svelte";

const Loading = CommandPrimitive.Loading;

export {
	Root,
	Dialog,
	Empty,
	Group,
	Item,
	Input,
	List,
	Separator,
	Shortcut,
	Loading,
	//
	Root as Command,
	Dialog as CommandDialog,
	Empty as CommandEmpty,
	Group as CommandGroup,
	Item as CommandItem,
	Input as CommandInput,
	List as CommandList,
	Separator as CommandSeparator,
	Shortcut as CommandShortcut,
	Loading as CommandLoading,
};

```
