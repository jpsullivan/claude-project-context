/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/tabs/index.ts
```typescript
import { Tabs as TabsPrimitive } from "bits-ui";
import Content from "./tabs-content.svelte";
import List from "./tabs-list.svelte";
import Trigger from "./tabs-trigger.svelte";

const Root = TabsPrimitive.Root;

export {
	Root,
	Content,
	List,
	Trigger,
	//
	Root as Tabs,
	Content as TabsContent,
	List as TabsList,
	Trigger as TabsTrigger,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/tabs/tabs-content.svelte
```
<script lang="ts">
import { Tabs as TabsPrimitive } from "bits-ui";

type $$Props = TabsPrimitive.ContentProps;

let className: $$Props["class"] = undefined;
export let value: $$Props["value"];
export { className as class };
</script>

<TabsPrimitive.Content
	class={cn(
		"ring-offset-background focus-visible:ring-ring mt-2 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2",
		className
	)}
	{value}
	{...$$restProps}
>
	<slot />
</TabsPrimitive.Content>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/tabs/tabs-list.svelte
```
<script lang="ts">
import { Tabs as TabsPrimitive } from "bits-ui";

type $$Props = TabsPrimitive.ListProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<TabsPrimitive.List
	class={cn(
		"bg-muted text-muted-foreground inline-flex h-9 items-center justify-center rounded-lg p-1",
		className
	)}
	{...$$restProps}
>
	<slot />
</TabsPrimitive.List>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/tabs/tabs-trigger.svelte
```
<script lang="ts">
import { Tabs as TabsPrimitive } from "bits-ui";

type $$Props = TabsPrimitive.TriggerProps;
type $$Events = TabsPrimitive.TriggerEvents;

let className: $$Props["class"] = undefined;
export let value: $$Props["value"];
export { className as class };
</script>

<TabsPrimitive.Trigger
	class={cn(
		"ring-offset-background focus-visible:ring-ring data-[state=active]:bg-background data-[state=active]:text-foreground inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm font-medium transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=active]:shadow",
		className
	)}
	{value}
	{...$$restProps}
	on:click
	on:keydown
	on:focus
>
	<slot />
</TabsPrimitive.Trigger>

```
