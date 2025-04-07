/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/badge/Badge.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";
import { type BadgeVariants } from ".";

const props = defineProps<{
	variant?: BadgeVariants["variant"];
	class?: HTMLAttributes["class"];
}>();
</script>

<template>
  <div :class="cn(badgeVariants({ variant }), props.class)">
    <slot />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/badge/index.ts
```typescript
import { type VariantProps, cva } from "class-variance-authority";

export { default as Badge } from "./Badge.vue";

export const badgeVariants = cva(
	"inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
	{
		variants: {
			variant: {
				default:
					"border-transparent bg-primary text-primary-foreground shadow hover:bg-primary/80",
				secondary:
					"border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",
				destructive:
					"border-transparent bg-destructive text-destructive-foreground shadow hover:bg-destructive/80",
				outline: "text-foreground",
			},
		},
		defaultVariants: {
			variant: "default",
		},
	},
);

export type BadgeVariants = VariantProps<typeof badgeVariants>;

```
