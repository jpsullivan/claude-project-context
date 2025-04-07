/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/collapsible/collapsible-content.svelte
```
<script lang="ts">
import { Collapsible as CollapsiblePrimitive } from "bits-ui";
import { slide } from "svelte/transition";
type $$Props = CollapsiblePrimitive.ContentProps;

export let transition: $$Props["transition"] = slide;
export let transitionConfig: $$Props["transitionConfig"] = {
	duration: 150,
};
</script>

<CollapsiblePrimitive.Content {transition} {transitionConfig} {...$$restProps}>
	<slot />
</CollapsiblePrimitive.Content>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/collapsible/index.ts
```typescript
import { Collapsible as CollapsiblePrimitive } from "bits-ui";
import Content from "./collapsible-content.svelte";

const Root = CollapsiblePrimitive.Root;
const Trigger = CollapsiblePrimitive.Trigger;

export {
	Root,
	Content,
	Trigger,
	//
	Root as Collapsible,
	Content as CollapsibleContent,
	Trigger as CollapsibleTrigger,
};

```
