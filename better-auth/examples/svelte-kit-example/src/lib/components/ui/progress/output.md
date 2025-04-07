/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/progress/index.ts
```typescript
import Root from "./progress.svelte";

export {
	Root,
	//
	Root as Progress,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/progress/progress.svelte
```
<script lang="ts">
import { Progress as ProgressPrimitive } from "bits-ui";

type $$Props = ProgressPrimitive.Props;

let className: $$Props["class"] = undefined;
export let max: $$Props["max"] = 100;
export let value: $$Props["value"] = undefined;
export { className as class };
</script>

<ProgressPrimitive.Root
	class={cn("bg-primary/20 relative h-2 w-full overflow-hidden rounded-full", className)}
	{...$$restProps}
>
	<div
		class="bg-primary h-full w-full flex-1 transition-all"
		style={`transform: translateX(-${100 - (100 * (value ?? 0)) / (max ?? 1)}%)`}
	></div>
</ProgressPrimitive.Root>

```
