/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/alert/Alert.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";
import { type AlertVariants } from ".";

const props = defineProps<{
	class?: HTMLAttributes["class"];
	variant?: AlertVariants["variant"];
}>();
</script>

<template>
  <div :class="cn(alertVariants({ variant }), props.class)" role="alert">
    <slot />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/alert/AlertDescription.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();
</script>

<template>
  <div :class="cn('text-sm [&_p]:leading-relaxed', props.class)">
    <slot />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/alert/AlertTitle.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();
</script>

<template>
  <h5 :class="cn('mb-1 font-medium leading-none tracking-tight', props.class)">
    <slot />
  </h5>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/alert/index.ts
```typescript
import { type VariantProps, cva } from "class-variance-authority";

export { default as Alert } from "./Alert.vue";
export { default as AlertTitle } from "./AlertTitle.vue";
export { default as AlertDescription } from "./AlertDescription.vue";

export const alertVariants = cva(
	"relative w-full rounded-lg border px-4 py-3 text-sm [&>svg+div]:translate-y-[-3px] [&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:text-foreground [&>svg~*]:pl-7",
	{
		variants: {
			variant: {
				default: "bg-background text-foreground",
				destructive:
					"border-destructive/50 text-destructive dark:border-destructive [&>svg]:text-destructive",
			},
		},
		defaultVariants: {
			variant: "default",
		},
	},
);

export type AlertVariants = VariantProps<typeof alertVariants>;

```
