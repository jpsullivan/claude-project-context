/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/select/Select.vue
```
<script setup lang="ts">
import type { SelectRootEmits, SelectRootProps } from "radix-vue";
import { useForwardPropsEmits } from "radix-vue";

const props = defineProps<SelectRootProps>();
const emits = defineEmits<SelectRootEmits>();

const forwarded = useForwardPropsEmits(props, emits);
</script>

<template>
  <SelectRoot v-bind="forwarded">
    <slot />
  </SelectRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/select/SelectContent.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import {
	type SelectContentEmits,
	type SelectContentProps,
	useForwardPropsEmits,
} from "radix-vue";

defineOptions({
	inheritAttrs: false,
});

const props = withDefaults(
	defineProps<SelectContentProps & { class?: HTMLAttributes["class"] }>(),
	{
		position: "popper",
	},
);
const emits = defineEmits<SelectContentEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <SelectPortal>
    <SelectContent
      v-bind="{ ...forwarded, ...$attrs }" :class="cn(
        'relative z-50 max-h-96 min-w-32 overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2',
        position === 'popper'
          && 'data-[side=bottom]:translate-y-1 data-[side=left]:-translate-x-1 data-[side=right]:translate-x-1 data-[side=top]:-translate-y-1',
        props.class,
      )
      "
    >
      <SelectScrollUpButton />
      <SelectViewport :class="cn('p-1', position === 'popper' && 'h-[--radix-select-trigger-height] w-full min-w-[--radix-select-trigger-width]')">
        <slot />
      </SelectViewport>
      <SelectScrollDownButton />
    </SelectContent>
  </SelectPortal>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/select/SelectGroup.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type SelectGroupProps } from "radix-vue";

const props = defineProps<
	SelectGroupProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <SelectGroup :class="cn('p-1 w-full', props.class)" v-bind="delegatedProps">
    <slot />
  </SelectGroup>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/select/SelectItem.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type SelectItemProps, useForwardProps } from "radix-vue";

const props = defineProps<
	SelectItemProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <SelectItem
    v-bind="forwardedProps"
    :class="
      cn(
        'relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-2 pr-8 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50',
        props.class,
      )
    "
  >
    <span class="absolute right-2 flex h-3.5 w-3.5 items-center justify-center">
      <SelectItemIndicator>
        <CheckIcon class="h-4 w-4" />
      </SelectItemIndicator>
    </span>

    <SelectItemText>
      <slot />
    </SelectItemText>
  </SelectItem>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/select/SelectItemText.vue
```
<script setup lang="ts">
import { type SelectItemTextProps } from "radix-vue";

const props = defineProps<SelectItemTextProps>();
</script>

<template>
  <SelectItemText v-bind="props">
    <slot />
  </SelectItemText>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/select/SelectLabel.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";
import { type SelectLabelProps } from "radix-vue";

const props = defineProps<
	SelectLabelProps & { class?: HTMLAttributes["class"] }
>();
</script>

<template>
  <SelectLabel :class="cn('px-2 py-1.5 text-sm font-semibold', props.class)">
    <slot />
  </SelectLabel>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/select/SelectScrollDownButton.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type SelectScrollDownButtonProps, useForwardProps } from "radix-vue";

const props = defineProps<
	SelectScrollDownButtonProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <SelectScrollDownButton v-bind="forwardedProps" :class="cn('flex cursor-default items-center justify-center py-1', props.class)">
    <slot>
      <ChevronDownIcon />
    </slot>
  </SelectScrollDownButton>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/select/SelectScrollUpButton.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type SelectScrollUpButtonProps, useForwardProps } from "radix-vue";

const props = defineProps<
	SelectScrollUpButtonProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <SelectScrollUpButton v-bind="forwardedProps" :class="cn('flex cursor-default items-center justify-center py-1', props.class)">
    <slot>
      <ChevronUpIcon />
    </slot>
  </SelectScrollUpButton>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/select/SelectSeparator.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type SelectSeparatorProps } from "radix-vue";

const props = defineProps<
	SelectSeparatorProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <SelectSeparator v-bind="delegatedProps" :class="cn('-mx-1 my-1 h-px bg-muted', props.class)" />
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/select/SelectTrigger.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type SelectTriggerProps, useForwardProps } from "radix-vue";

const props = defineProps<
	SelectTriggerProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <SelectTrigger
    v-bind="forwardedProps"
    :class="cn(
      'flex h-9 w-full items-center justify-between whitespace-nowrap rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50 [&>span]:truncate text-start',
      props.class,
    )"
  >
    <slot />
    <SelectIcon as-child>
      <CaretSortIcon class="w-4 h-4 opacity-50 shrink-0" />
    </SelectIcon>
  </SelectTrigger>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/select/SelectValue.vue
```
<script setup lang="ts">
import { type SelectValueProps } from "radix-vue";

const props = defineProps<SelectValueProps>();
</script>

<template>
  <SelectValue v-bind="props">
    <slot />
  </SelectValue>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/select/index.ts
```typescript
export { default as Select } from "./Select.vue";
export { default as SelectValue } from "./SelectValue.vue";
export { default as SelectTrigger } from "./SelectTrigger.vue";
export { default as SelectContent } from "./SelectContent.vue";
export { default as SelectGroup } from "./SelectGroup.vue";
export { default as SelectItem } from "./SelectItem.vue";
export { default as SelectItemText } from "./SelectItemText.vue";
export { default as SelectLabel } from "./SelectLabel.vue";
export { default as SelectSeparator } from "./SelectSeparator.vue";
export { default as SelectScrollUpButton } from "./SelectScrollUpButton.vue";
export { default as SelectScrollDownButton } from "./SelectScrollDownButton.vue";

```
