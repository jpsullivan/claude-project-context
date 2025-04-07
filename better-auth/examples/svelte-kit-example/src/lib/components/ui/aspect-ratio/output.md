/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/aspect-ratio/aspect-ratio.svelte
```
<script lang="ts">
import { AspectRatio as AspectRatioPrimitive } from "bits-ui";

type $$Props = AspectRatioPrimitive.Props;

export let ratio: $$Props["ratio"] = 4 / 3;
</script>

<AspectRatioPrimitive.Root {ratio} {...$$restProps}>
	<slot />
</AspectRatioPrimitive.Root>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/aspect-ratio/index.ts
```typescript
import Root from "./aspect-ratio.svelte";

export { Root, Root as AspectRatio };

```
