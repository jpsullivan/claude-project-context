/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/pagination/PaginationEllipsis.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type PaginationEllipsisProps } from "radix-vue";

const props = defineProps<
	PaginationEllipsisProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <PaginationEllipsis v-bind="delegatedProps" :class="cn('w-9 h-9 flex items-center justify-center', props.class)">
    <slot>
      <DotsHorizontalIcon />
    </slot>
  </PaginationEllipsis>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/pagination/PaginationFirst.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type PaginationFirstProps } from "radix-vue";

const props = withDefaults(
	defineProps<PaginationFirstProps & { class?: HTMLAttributes["class"] }>(),
	{
		asChild: true,
	},
);

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <PaginationFirst v-bind="delegatedProps">
    <Button :class="cn('w-9 h-9 p-0', props.class)" variant="outline">
      <slot>
        <DoubleArrowLeftIcon />
      </slot>
    </Button>
  </PaginationFirst>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/pagination/PaginationLast.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type PaginationLastProps } from "radix-vue";

const props = withDefaults(
	defineProps<PaginationLastProps & { class?: HTMLAttributes["class"] }>(),
	{
		asChild: true,
	},
);

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <PaginationLast v-bind="delegatedProps">
    <Button :class="cn('w-9 h-9 p-0', props.class)" variant="outline">
      <slot>
        <DoubleArrowRightIcon />
      </slot>
    </Button>
  </PaginationLast>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/pagination/PaginationNext.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type PaginationNextProps } from "radix-vue";

const props = withDefaults(
	defineProps<PaginationNextProps & { class?: HTMLAttributes["class"] }>(),
	{
		asChild: true,
	},
);

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <PaginationNext v-bind="delegatedProps">
    <Button :class="cn('w-9 h-9 p-0', props.class)" variant="outline">
      <slot>
        <ChevronRightIcon />
      </slot>
    </Button>
  </PaginationNext>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/pagination/PaginationPrev.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type PaginationPrevProps } from "radix-vue";

const props = withDefaults(
	defineProps<PaginationPrevProps & { class?: HTMLAttributes["class"] }>(),
	{
		asChild: true,
	},
);

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <PaginationPrev v-bind="delegatedProps">
    <Button :class="cn('w-9 h-9 p-0', props.class)" variant="outline">
      <slot>
        <ChevronLeftIcon />
      </slot>
    </Button>
  </PaginationPrev>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/pagination/index.ts
```typescript
export {
	PaginationRoot as Pagination,
	PaginationList,
	PaginationListItem,
} from "radix-vue";
export { default as PaginationEllipsis } from "./PaginationEllipsis.vue";
export { default as PaginationFirst } from "./PaginationFirst.vue";
export { default as PaginationLast } from "./PaginationLast.vue";
export { default as PaginationNext } from "./PaginationNext.vue";
export { default as PaginationPrev } from "./PaginationPrev.vue";

```
