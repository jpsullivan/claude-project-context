/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/popover/Popover.vue
```
<script setup lang="ts">
import { useForwardPropsEmits } from "radix-vue";
import type { PopoverRootEmits, PopoverRootProps } from "radix-vue";

const props = defineProps<PopoverRootProps>();
const emits = defineEmits<PopoverRootEmits>();

const forwarded = useForwardPropsEmits(props, emits);
</script>

<template>
  <PopoverRoot v-bind="forwarded">
    <slot />
  </PopoverRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/popover/PopoverContent.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import {
	type PopoverContentEmits,
	type PopoverContentProps,
	useForwardPropsEmits,
} from "radix-vue";

defineOptions({
	inheritAttrs: false,
});

const props = withDefaults(
	defineProps<PopoverContentProps & { class?: HTMLAttributes["class"] }>(),
	{
		align: "center",
		sideOffset: 4,
	},
);
const emits = defineEmits<PopoverContentEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <PopoverPortal>
    <PopoverContent
      v-bind="{ ...forwarded, ...$attrs }"
      :class="
        cn(
          'z-50 w-72 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2',
          props.class,
        )
      "
    >
      <slot />
    </PopoverContent>
  </PopoverPortal>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/popover/PopoverTrigger.vue
```
<script setup lang="ts">
import { type PopoverTriggerProps } from "radix-vue";

const props = defineProps<PopoverTriggerProps>();
</script>

<template>
  <PopoverTrigger v-bind="props">
    <slot />
  </PopoverTrigger>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/popover/index.ts
```typescript
export { PopoverAnchor } from "radix-vue";
export { default as Popover } from "./Popover.vue";
export { default as PopoverTrigger } from "./PopoverTrigger.vue";
export { default as PopoverContent } from "./PopoverContent.vue";

```
