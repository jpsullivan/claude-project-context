/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/radio-group/RadioGroup.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import {
	type RadioGroupRootEmits,
	type RadioGroupRootProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<
	RadioGroupRootProps & { class?: HTMLAttributes["class"] }
>();
const emits = defineEmits<RadioGroupRootEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <RadioGroupRoot
    :class="cn('grid gap-2', props.class)"
    v-bind="forwarded"
  >
    <slot />
  </RadioGroupRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/radio-group/RadioGroupItem.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type RadioGroupItemProps, useForwardProps } from "radix-vue";

const props = defineProps<
	RadioGroupItemProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <RadioGroupItem
    v-bind="forwardedProps"
    :class="
      cn(
        'aspect-square h-4 w-4 rounded-full border border-primary text-primary shadow focus:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50',
        props.class,
      )
    "
  >
    <RadioGroupIndicator class="flex items-center justify-center">
      <CheckIcon class="h-3.5 w-3.5 fill-primary" />
    </RadioGroupIndicator>
  </RadioGroupItem>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/radio-group/index.ts
```typescript
export { default as RadioGroup } from "./RadioGroup.vue";
export { default as RadioGroupItem } from "./RadioGroupItem.vue";

```
