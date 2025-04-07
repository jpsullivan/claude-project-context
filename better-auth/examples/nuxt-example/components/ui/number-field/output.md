/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/number-field/NumberField.vue
```
<script setup lang="ts">
import type { NumberFieldRootEmits, NumberFieldRootProps } from "radix-vue";
import { useForwardPropsEmits } from "radix-vue";
import { type HTMLAttributes, computed } from "vue";

const props = defineProps<
	NumberFieldRootProps & { class?: HTMLAttributes["class"] }
>();
const emits = defineEmits<NumberFieldRootEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <NumberFieldRoot v-bind="forwarded" :class="cn('grid gap-1.5', props.class)">
    <slot />
  </NumberFieldRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/number-field/NumberFieldContent.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();
</script>

<template>
  <div :class="cn('relative [&>[data-slot=input]]:has-[[data-slot=increment]]:pr-5 [&>[data-slot=input]]:has-[[data-slot=decrement]]:pl-5', props.class)">
    <slot />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/number-field/NumberFieldDecrement.vue
```
<script setup lang="ts">
import type { NumberFieldDecrementProps } from "radix-vue";
import { useForwardProps } from "radix-vue";
import { type HTMLAttributes, computed } from "vue";

const props = defineProps<
	NumberFieldDecrementProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardProps(delegatedProps);
</script>

<template>
  <NumberFieldDecrement data-slot="decrement" v-bind="forwarded" :class="cn('absolute top-1/2 -translate-y-1/2 left-0 p-3 disabled:cursor-not-allowed disabled:opacity-20', props.class)">
    <slot>
      <Minus class="h-4 w-4" />
    </slot>
  </NumberFieldDecrement>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/number-field/NumberFieldIncrement.vue
```
<script setup lang="ts">
import type { NumberFieldIncrementProps } from "radix-vue";
import { useForwardProps } from "radix-vue";
import { type HTMLAttributes, computed } from "vue";

const props = defineProps<
	NumberFieldIncrementProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardProps(delegatedProps);
</script>

<template>
  <NumberFieldIncrement data-slot="increment" v-bind="forwarded" :class="cn('absolute top-1/2 -translate-y-1/2 right-0 disabled:cursor-not-allowed disabled:opacity-20 p-3', props.class)">
    <slot>
      <Plus class="h-4 w-4" />
    </slot>
  </NumberFieldIncrement>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/number-field/NumberFieldInput.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();
</script>

<template>
  <NumberFieldInput
    data-slot="input"
    :class="cn('flex h-9 w-full rounded-md border border-input bg-transparent py-1 text-sm text-center shadow-sm transition-colors placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50', props.class)"
  />
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/number-field/index.ts
```typescript
export { default as NumberField } from "./NumberField.vue";
export { default as NumberFieldInput } from "./NumberFieldInput.vue";
export { default as NumberFieldIncrement } from "./NumberFieldIncrement.vue";
export { default as NumberFieldDecrement } from "./NumberFieldDecrement.vue";
export { default as NumberFieldContent } from "./NumberFieldContent.vue";

```
