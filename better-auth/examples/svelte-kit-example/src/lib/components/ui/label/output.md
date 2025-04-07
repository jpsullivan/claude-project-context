/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/label/index.ts
```typescript
import Root from "./label.svelte";

export {
	Root,
	//
	Root as Label,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/label/label.svelte
```
<script lang="ts">
import { Label as LabelPrimitive } from "bits-ui";

type $$Props = LabelPrimitive.Props;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<LabelPrimitive.Root
	class={cn(
		"text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70",
		className
	)}
	{...$$restProps}
>
	<slot />
</LabelPrimitive.Root>

```
