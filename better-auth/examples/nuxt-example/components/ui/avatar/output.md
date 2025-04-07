/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/avatar/Avatar.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";
import { type AvatarVariants } from ".";

const props = withDefaults(
	defineProps<{
		class?: HTMLAttributes["class"];
		size?: AvatarVariants["size"];
		shape?: AvatarVariants["shape"];
	}>(),
	{
		size: "sm",
		shape: "circle",
	},
);
</script>

<template>
  <AvatarRoot :class="cn(avatarVariant({ size, shape }), props.class)">
    <slot />
  </AvatarRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/avatar/AvatarFallback.vue
```
<script setup lang="ts">
import { type AvatarFallbackProps } from "radix-vue";

const props = defineProps<AvatarFallbackProps>();
</script>

<template>
  <AvatarFallback v-bind="props">
    <slot />
  </AvatarFallback>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/avatar/AvatarImage.vue
```
<script setup lang="ts">
import { type AvatarImageProps } from "radix-vue";

const props = defineProps<AvatarImageProps>();
</script>

<template>
  <AvatarImage v-bind="props" class="h-full w-full object-cover" />
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/avatar/index.ts
```typescript
import { type VariantProps, cva } from "class-variance-authority";

export { default as Avatar } from "./Avatar.vue";
export { default as AvatarImage } from "./AvatarImage.vue";
export { default as AvatarFallback } from "./AvatarFallback.vue";

export const avatarVariant = cva(
	"inline-flex items-center justify-center font-normal text-foreground select-none shrink-0 bg-secondary overflow-hidden",
	{
		variants: {
			size: {
				sm: "h-10 w-10 text-xs",
				base: "h-16 w-16 text-2xl",
				lg: "h-32 w-32 text-5xl",
			},
			shape: {
				circle: "rounded-full",
				square: "rounded-md",
			},
		},
	},
);

export type AvatarVariants = VariantProps<typeof avatarVariant>;

```
