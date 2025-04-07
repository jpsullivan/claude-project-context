/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/skeleton/index.ts
```typescript
import Root from "./skeleton.svelte";

export {
	Root,
	//
	Root as Skeleton,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/skeleton/skeleton.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLDivElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<div class={cn("bg-primary/10 animate-pulse rounded-md", className)} {...$$restProps}></div>

```
