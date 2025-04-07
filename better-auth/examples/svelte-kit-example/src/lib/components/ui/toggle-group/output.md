/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/toggle-group/index.ts
```typescript
import type { VariantProps } from "tailwind-variants";
import { getContext, setContext } from "svelte";
import Root from "./toggle-group.svelte";
import Item from "./toggle-group-item.svelte";
import type { toggleVariants } from "$lib/components/ui/toggle/index.js";

export type ToggleVariants = VariantProps<typeof toggleVariants>;

export function setToggleGroupCtx(props: ToggleVariants) {
	setContext("toggleGroup", props);
}

export function getToggleGroupCtx() {
	return getContext<ToggleVariants>("toggleGroup");
}

export {
	Root,
	Item,
	//
	Root as ToggleGroup,
	Item as ToggleGroupItem,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/toggle-group/toggle-group-item.svelte
```
<script lang="ts">
import { ToggleGroup as ToggleGroupPrimitive } from "bits-ui";
import { type ToggleVariants, getToggleGroupCtx } from "./index.js";

type $$Props = ToggleGroupPrimitive.ItemProps & ToggleVariants;

let className: string | undefined | null = undefined;

export { className as class };
export let variant: $$Props["variant"] = "default";
export let size: $$Props["size"] = "default";
export let value: $$Props["value"];

const ctx = getToggleGroupCtx();
</script>

<ToggleGroupPrimitive.Item
	class={cn(
		toggleVariants({
			variant: ctx.variant || variant,
			size: ctx.size || size,
		}),
		className
	)}
	{value}
	{...$$restProps}
>
	<slot />
</ToggleGroupPrimitive.Item>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/toggle-group/toggle-group.svelte
```
<script lang="ts">
import type { VariantProps } from "tailwind-variants";
import { ToggleGroup as ToggleGroupPrimitive } from "bits-ui";
import { setToggleGroupCtx } from "./index.js";
import type { toggleVariants } from "$lib/components/ui/toggle/index.js";

type T = $$Generic<"single" | "multiple">;
type $$Props = ToggleGroupPrimitive.Props<T> &
	VariantProps<typeof toggleVariants>;

let className: string | undefined | null = undefined;
export { className as class };
export let variant: $$Props["variant"] = "default";
export let size: $$Props["size"] = "default";
export let value: $$Props["value"] = undefined;

setToggleGroupCtx({
	variant,
	size,
});
</script>

<ToggleGroupPrimitive.Root
	class={cn("flex items-center justify-center gap-1", className)}
	bind:value
	{...$$restProps}
	let:builder
>
	<slot {builder} />
</ToggleGroupPrimitive.Root>

```
