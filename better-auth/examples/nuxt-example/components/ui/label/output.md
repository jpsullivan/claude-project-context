/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/label/Label.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type LabelProps } from "radix-vue";

const props = defineProps<LabelProps & { class?: HTMLAttributes["class"] }>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <Label
    v-bind="delegatedProps"
    :class="
      cn(
        'text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70',
        props.class,
      )
    "
  >
    <slot />
  </Label>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/label/index.ts
```typescript
export { default as Label } from "./Label.vue";

```
