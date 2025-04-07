/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/pin-input/PinInput.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import {
	type PinInputRootEmits,
	type PinInputRootProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = withDefaults(
	defineProps<PinInputRootProps & { class?: HTMLAttributes["class"] }>(),
	{
		modelValue: () => [],
	},
);
const emits = defineEmits<PinInputRootEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;
	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <PinInputRoot v-bind="forwarded" :class="cn('flex gap-2 items-center', props.class)">
    <slot />
  </PinInputRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/pin-input/PinInputGroup.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type PrimitiveProps, useForwardProps } from "radix-vue";

const props = defineProps<
	PrimitiveProps & { class?: HTMLAttributes["class"] }
>();
const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;
	return delegated;
});
const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <Primitive v-bind="forwardedProps" :class="cn('flex items-center', props.class)">
    <slot />
  </primitive>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/pin-input/PinInputInput.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type PinInputInputProps, useForwardProps } from "radix-vue";

const props = defineProps<
	PinInputInputProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;
	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <PinInputInput v-bind="forwardedProps" :class="cn('relative text-center focus:outline-none focus:ring-2 focus:ring-ring focus:relative focus:z-10 flex h-9 w-9 items-center justify-center border-y border-r border-input text-sm transition-all first:rounded-l-md first:border-l last:rounded-r-md', props.class)" />
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/pin-input/PinInputSeparator.vue
```
<script setup lang="ts">
import { type PrimitiveProps, useForwardProps } from "radix-vue";

const props = defineProps<PrimitiveProps>();
const forwardedProps = useForwardProps(props);
</script>

<template>
  <Primitive v-bind="forwardedProps">
    <slot>
      <DashIcon />
    </slot>
  </primitive>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/pin-input/index.ts
```typescript
export { default as PinInput } from "./PinInput.vue";
export { default as PinInputGroup } from "./PinInputGroup.vue";
export { default as PinInputSeparator } from "./PinInputSeparator.vue";
export { default as PinInputInput } from "./PinInputInput.vue";

```
