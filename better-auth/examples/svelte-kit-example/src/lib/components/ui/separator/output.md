/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/separator/index.ts
```typescript
import Root from "./separator.svelte";

export {
	Root,
	//
	Root as Separator,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/separator/separator.svelte
```
<script lang="ts">
import { Separator as SeparatorPrimitive } from "bits-ui";

type $$Props = SeparatorPrimitive.Props;

let className: $$Props["class"] = undefined;
export let orientation: $$Props["orientation"] = "horizontal";
export let decorative: $$Props["decorative"] = undefined;
export { className as class };
</script>

<SeparatorPrimitive.Root
	class={cn(
		"bg-border shrink-0",
		orientation === "horizontal" ? "h-[1px] w-full" : "min-h-full w-[1px]",
		className
	)}
	{orientation}
	{decorative}
	{...$$restProps}
/>

```
