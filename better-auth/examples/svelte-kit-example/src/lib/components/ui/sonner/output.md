/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/sonner/index.ts
```typescript
export { default as Toaster } from "./sonner.svelte";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/sonner/sonner.svelte
```
<script lang="ts">
import { type ToasterProps as SonnerProps } from "svelte-sonner";

type $$Props = SonnerProps;
</script>

<Sonner
	theme={$mode}
	class="toaster group"
	toastOptions={{
		classes: {
			toast: "group toast group-[.toaster]:bg-background group-[.toaster]:text-foreground group-[.toaster]:border-border group-[.toaster]:shadow-lg",
			description: "group-[.toast]:text-muted-foreground",
			actionButton: "group-[.toast]:bg-primary group-[.toast]:text-primary-foreground",
			cancelButton: "group-[.toast]:bg-muted group-[.toast]:text-muted-foreground",
		},
	}}
	{...$$restProps}
/>

```
