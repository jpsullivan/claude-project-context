/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/command/Command.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import type { ComboboxRootEmits, ComboboxRootProps } from "radix-vue";
import { useForwardPropsEmits } from "radix-vue";

const props = withDefaults(
	defineProps<ComboboxRootProps & { class?: HTMLAttributes["class"] }>(),
	{
		open: true,
		modelValue: "",
	},
);

const emits = defineEmits<ComboboxRootEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <ComboboxRoot
    v-bind="forwarded"
    :class="cn('flex h-full w-full flex-col overflow-hidden rounded-md bg-popover text-popover-foreground', props.class)"
  >
    <slot />
  </ComboboxRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/command/CommandDialog.vue
```
<script setup lang="ts">
import { useForwardPropsEmits } from "radix-vue";
import type { DialogRootEmits, DialogRootProps } from "radix-vue";

const props = defineProps<DialogRootProps>();
const emits = defineEmits<DialogRootEmits>();

const forwarded = useForwardPropsEmits(props, emits);
</script>

<template>
  <Dialog v-bind="forwarded">
    <DialogContent class="overflow-hidden p-0 shadow-lg">
      <Command class="[&_[cmdk-group-heading]]:px-2 [&_[cmdk-group-heading]]:font-medium [&_[cmdk-group-heading]]:text-muted-foreground [&_[cmdk-group]:not([hidden])_~[cmdk-group]]:pt-0 [&_[cmdk-group]]:px-2 [&_[cmdk-input-wrapper]_svg]:h-5 [&_[cmdk-input-wrapper]_svg]:w-5 [&_[cmdk-input]]:h-12 [&_[cmdk-item]]:px-2 [&_[cmdk-item]]:py-3 [&_[cmdk-item]_svg]:h-5 [&_[cmdk-item]_svg]:w-5">
        <slot />
      </Command>
    </DialogContent>
  </Dialog>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/command/CommandEmpty.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import type { ComboboxEmptyProps } from "radix-vue";

const props = defineProps<
	ComboboxEmptyProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <ComboboxEmpty v-bind="delegatedProps" :class="cn('py-6 text-center text-sm', props.class)">
    <slot />
  </ComboboxEmpty>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/command/CommandGroup.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import type { ComboboxGroupProps } from "radix-vue";

const props = defineProps<
	ComboboxGroupProps & {
		class?: HTMLAttributes["class"];
		heading?: string;
	}
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <ComboboxGroup
    v-bind="delegatedProps"
    :class="cn('overflow-hidden p-1 text-foreground [&_[cmdk-group-heading]]:px-2 [&_[cmdk-group-heading]]:py-1.5 [&_[cmdk-group-heading]]:text-xs [&_[cmdk-group-heading]]:font-medium [&_[cmdk-group-heading]]:text-muted-foreground', props.class)"
  >
    <ComboboxLabel v-if="heading" class="px-2 py-1.5 text-xs font-medium text-muted-foreground">
      {{ heading }}
    </ComboboxLabel>
    <slot />
  </ComboboxGroup>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/command/CommandInput.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type ComboboxInputProps, useForwardProps } from "radix-vue";

defineOptions({
	inheritAttrs: false,
});

const props = defineProps<
	ComboboxInputProps & {
		class?: HTMLAttributes["class"];
	}
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <div class="flex items-center border-b px-3" cmdk-input-wrapper>
    <MagnifyingGlassIcon class="mr-2 h-4 w-4 shrink-0 opacity-50" />
    <ComboboxInput
      v-bind="{ ...forwardedProps, ...$attrs }"
      auto-focus
      :class="cn('flex h-10 w-full rounded-md bg-transparent py-3 text-sm outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50', props.class)"
    />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/command/CommandItem.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import type { ComboboxItemEmits, ComboboxItemProps } from "radix-vue";
import { useForwardPropsEmits } from "radix-vue";

const props = defineProps<
	ComboboxItemProps & { class?: HTMLAttributes["class"] }
>();
const emits = defineEmits<ComboboxItemEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <ComboboxItem
    v-bind="forwarded"
    :class="cn('relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50', props.class)"
  >
    <slot />
  </ComboboxItem>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/command/CommandList.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import type { ComboboxContentEmits, ComboboxContentProps } from "radix-vue";
import { useForwardPropsEmits } from "radix-vue";

const props = withDefaults(
	defineProps<ComboboxContentProps & { class?: HTMLAttributes["class"] }>(),
	{
		dismissable: false,
	},
);
const emits = defineEmits<ComboboxContentEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <ComboboxContent v-bind="forwarded" :class="cn('max-h-[300px] overflow-y-auto overflow-x-hidden', props.class)">
    <div role="presentation">
      <slot />
    </div>
  </ComboboxContent>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/command/CommandSeparator.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import type { ComboboxSeparatorProps } from "radix-vue";

const props = defineProps<
	ComboboxSeparatorProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <ComboboxSeparator
    v-bind="delegatedProps"
    :class="cn('-mx-1 h-px bg-border', props.class)"
  >
    <slot />
  </ComboboxSeparator>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/command/CommandShortcut.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();
</script>

<template>
  <span :class="cn('ml-auto text-xs tracking-widest text-muted-foreground', props.class)">
    <slot />
  </span>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/command/index.ts
```typescript
export { default as Command } from "./Command.vue";
export { default as CommandDialog } from "./CommandDialog.vue";
export { default as CommandEmpty } from "./CommandEmpty.vue";
export { default as CommandGroup } from "./CommandGroup.vue";
export { default as CommandInput } from "./CommandInput.vue";
export { default as CommandItem } from "./CommandItem.vue";
export { default as CommandList } from "./CommandList.vue";
export { default as CommandSeparator } from "./CommandSeparator.vue";
export { default as CommandShortcut } from "./CommandShortcut.vue";

```
