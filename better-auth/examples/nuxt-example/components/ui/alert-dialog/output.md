/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/alert-dialog/AlertDialog.vue
```
<script setup lang="ts">
import {
	type AlertDialogEmits,
	type AlertDialogProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<AlertDialogProps>();
const emits = defineEmits<AlertDialogEmits>();

const forwarded = useForwardPropsEmits(props, emits);
</script>

<template>
  <AlertDialogRoot v-bind="forwarded">
    <slot />
  </AlertDialogRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/alert-dialog/AlertDialogAction.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type AlertDialogActionProps } from "radix-vue";

const props = defineProps<
	AlertDialogActionProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <AlertDialogAction v-bind="delegatedProps" :class="cn(buttonVariants(), props.class)">
    <slot />
  </AlertDialogAction>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/alert-dialog/AlertDialogCancel.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type AlertDialogCancelProps } from "radix-vue";

const props = defineProps<
	AlertDialogCancelProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <AlertDialogCancel v-bind="delegatedProps" :class="cn(buttonVariants({ variant: 'outline' }), 'mt-2 sm:mt-0', props.class)">
    <slot />
  </AlertDialogCancel>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/alert-dialog/AlertDialogContent.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import {
	type AlertDialogContentEmits,
	type AlertDialogContentProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<
	AlertDialogContentProps & { class?: HTMLAttributes["class"] }
>();
const emits = defineEmits<AlertDialogContentEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <AlertDialogPortal>
    <AlertDialogOverlay
      class="fixed inset-0 z-50 bg-black/80 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0"
    />
    <AlertDialogContent
      v-bind="forwarded"
      :class="
        cn(
          'fixed left-1/2 top-1/2 z-50 grid w-full max-w-lg -translate-x-1/2 -translate-y-1/2 gap-4 border bg-background p-6 shadow-lg duration-200 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=closed]:slide-out-to-left-1/2 data-[state=closed]:slide-out-to-top-[48%] data-[state=open]:slide-in-from-left-1/2 data-[state=open]:slide-in-from-top-[48%] sm:rounded-lg',
          props.class,
        )
      "
    >
      <slot />
    </AlertDialogContent>
  </AlertDialogPortal>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/alert-dialog/AlertDialogDescription.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type AlertDialogDescriptionProps } from "radix-vue";

const props = defineProps<
	AlertDialogDescriptionProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <AlertDialogDescription
    v-bind="delegatedProps"
    :class="cn('text-sm text-muted-foreground', props.class)"
  >
    <slot />
  </AlertDialogDescription>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/alert-dialog/AlertDialogFooter.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();
</script>

<template>
  <div
    :class="
      cn(
        'flex flex-col-reverse sm:flex-row sm:justify-end sm:gap-x-2',
        props.class,
      )
    "
  >
    <slot />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/alert-dialog/AlertDialogHeader.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();
</script>

<template>
  <div
    :class="cn('flex flex-col gap-y-2 text-center sm:text-left', props.class)"
  >
    <slot />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/alert-dialog/AlertDialogTitle.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type AlertDialogTitleProps } from "radix-vue";

const props = defineProps<
	AlertDialogTitleProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <AlertDialogTitle
    v-bind="delegatedProps"
    :class="cn('text-lg font-semibold', props.class)"
  >
    <slot />
  </AlertDialogTitle>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/alert-dialog/AlertDialogTrigger.vue
```
<script setup lang="ts">
import { type AlertDialogTriggerProps } from "radix-vue";

const props = defineProps<AlertDialogTriggerProps>();
</script>

<template>
  <AlertDialogTrigger v-bind="props">
    <slot />
  </AlertDialogTrigger>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/alert-dialog/index.ts
```typescript
export { default as AlertDialog } from "./AlertDialog.vue";
export { default as AlertDialogTrigger } from "./AlertDialogTrigger.vue";
export { default as AlertDialogContent } from "./AlertDialogContent.vue";
export { default as AlertDialogHeader } from "./AlertDialogHeader.vue";
export { default as AlertDialogTitle } from "./AlertDialogTitle.vue";
export { default as AlertDialogDescription } from "./AlertDialogDescription.vue";
export { default as AlertDialogFooter } from "./AlertDialogFooter.vue";
export { default as AlertDialogAction } from "./AlertDialogAction.vue";
export { default as AlertDialogCancel } from "./AlertDialogCancel.vue";

```
