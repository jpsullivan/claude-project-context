/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/badge/badge.svelte
```
<script lang="ts">
import { type Variant } from "./index.js";

let className: string | undefined | null = undefined;
export let href: string | undefined = undefined;
export let variant: Variant = "default";
export { className as class };
</script>

<svelte:element
	this={href ? "a" : "span"}
	{href}
	class={cn(badgeVariants({ variant, className }))}
	{...$$restProps}
>
	<slot />
</svelte:element>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/badge/index.ts
```typescript
import { type VariantProps, tv } from "tailwind-variants";

export { default as Badge } from "./badge.svelte";
export const badgeVariants = tv({
	base: "focus:ring-ring inline-flex select-none items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2",
	variants: {
		variant: {
			default:
				"bg-primary text-primary-foreground hover:bg-primary/80 border-transparent shadow",
			secondary:
				"bg-secondary text-secondary-foreground hover:bg-secondary/80 border-transparent",
			destructive:
				"bg-destructive text-destructive-foreground hover:bg-destructive/80 border-transparent shadow",
			outline: "text-foreground",
		},
	},
	defaultVariants: {
		variant: "default",
	},
});

export type Variant = VariantProps<typeof badgeVariants>["variant"];

```
