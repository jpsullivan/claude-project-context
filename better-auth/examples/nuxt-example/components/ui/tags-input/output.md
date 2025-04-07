/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tags-input/TagsInput.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import {
	type TagsInputRootEmits,
	type TagsInputRootProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<
	TagsInputRootProps & { class?: HTMLAttributes["class"] }
>();
const emits = defineEmits<TagsInputRootEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <TagsInputRoot v-bind="forwarded" :class="cn('flex flex-wrap gap-2 items-center rounded-md border border-input bg-background px-3 py-1.5 text-sm', props.class)">
    <slot />
  </TagsInputRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tags-input/TagsInputInput.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type TagsInputInputProps, useForwardProps } from "radix-vue";

const props = defineProps<
	TagsInputInputProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <TagsInputInput v-bind="forwardedProps" :class="cn('text-sm min-h-5 focus:outline-none flex-1 bg-transparent px-1', props.class)" />
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tags-input/TagsInputItem.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type TagsInputItemProps, useForwardProps } from "radix-vue";

const props = defineProps<
	TagsInputItemProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <TagsInputItem v-bind="forwardedProps" :class="cn('flex h-5 items-center rounded-md bg-secondary data-[state=active]:ring-ring data-[state=active]:ring-2 data-[state=active]:ring-offset-2 ring-offset-background', props.class)">
    <slot />
  </TagsInputItem>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tags-input/TagsInputItemDelete.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type TagsInputItemDeleteProps, useForwardProps } from "radix-vue";

const props = defineProps<
	TagsInputItemDeleteProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <TagsInputItemDelete v-bind="forwardedProps" :class="cn('flex rounded bg-transparent mr-1', props.class)">
    <slot>
      <Cross2Icon class="w-4 h-4" />
    </slot>
  </TagsInputItemDelete>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tags-input/TagsInputItemText.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type TagsInputItemTextProps, useForwardProps } from "radix-vue";

const props = defineProps<
	TagsInputItemTextProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <TagsInputItemText v-bind="forwardedProps" :class="cn('py-0.5 px-2 text-sm rounded bg-transparent', props.class)" />
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tags-input/index.ts
```typescript
export { default as TagsInput } from "./TagsInput.vue";
export { default as TagsInputInput } from "./TagsInputInput.vue";
export { default as TagsInputItem } from "./TagsInputItem.vue";
export { default as TagsInputItemDelete } from "./TagsInputItemDelete.vue";
export { default as TagsInputItemText } from "./TagsInputItemText.vue";

```
