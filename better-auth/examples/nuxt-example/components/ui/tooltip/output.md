/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tooltip/Tooltip.vue
```
<script setup lang="ts">
import {
	type TooltipRootEmits,
	type TooltipRootProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<TooltipRootProps>();
const emits = defineEmits<TooltipRootEmits>();

const forwarded = useForwardPropsEmits(props, emits);
</script>

<template>
  <TooltipRoot v-bind="forwarded">
    <slot />
  </TooltipRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tooltip/TooltipContent.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import {
	type TooltipContentEmits,
	type TooltipContentProps,
	useForwardPropsEmits,
} from "radix-vue";

defineOptions({
	inheritAttrs: false,
});

const props = withDefaults(
	defineProps<TooltipContentProps & { class?: HTMLAttributes["class"] }>(),
	{
		sideOffset: 4,
	},
);

const emits = defineEmits<TooltipContentEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <TooltipPortal>
    <TooltipContent v-bind="{ ...forwarded, ...$attrs }" :class="cn('z-50 overflow-hidden rounded-md bg-primary px-3 py-1.5 text-xs text-primary-foreground animate-in fade-in-0 zoom-in-95 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2', props.class)">
      <slot />
    </TooltipContent>
  </TooltipPortal>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tooltip/TooltipProvider.vue
```
<script setup lang="ts">
import { type TooltipProviderProps } from "radix-vue";

const props = defineProps<TooltipProviderProps>();
</script>

<template>
  <TooltipProvider v-bind="props">
    <slot />
  </TooltipProvider>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tooltip/TooltipTrigger.vue
```
<script setup lang="ts">
import { type TooltipTriggerProps } from "radix-vue";

const props = defineProps<TooltipTriggerProps>();
</script>

<template>
  <TooltipTrigger v-bind="props">
    <slot />
  </TooltipTrigger>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tooltip/index.ts
```typescript
export { default as Tooltip } from "./Tooltip.vue";
export { default as TooltipContent } from "./TooltipContent.vue";
export { default as TooltipTrigger } from "./TooltipTrigger.vue";
export { default as TooltipProvider } from "./TooltipProvider.vue";

```
