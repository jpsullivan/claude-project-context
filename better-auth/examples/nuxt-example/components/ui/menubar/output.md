/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/Menubar.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import {
	type MenubarRootEmits,
	type MenubarRootProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<
	MenubarRootProps & { class?: HTMLAttributes["class"] }
>();
const emits = defineEmits<MenubarRootEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <MenubarRoot
    v-bind="forwarded"
    :class="
      cn(
        'flex h-9 items-center space-x-1 rounded-md border bg-background p-1 shadow-sm',
        props.class,
      )
    "
  >
    <slot />
  </MenubarRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/MenubarCheckboxItem.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import {
	type MenubarCheckboxItemEmits,
	type MenubarCheckboxItemProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<
	MenubarCheckboxItemProps & { class?: HTMLAttributes["class"] }
>();
const emits = defineEmits<MenubarCheckboxItemEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <MenubarCheckboxItem
    v-bind="forwarded"
    :class="cn(
      'relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50',
      props.class,
    )"
  >
    <span class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
      <MenubarItemIndicator>
        <CheckIcon class="w-4 h-4" />
      </MenubarItemIndicator>
    </span>
    <slot />
  </MenubarCheckboxItem>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/MenubarContent.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type MenubarContentProps, useForwardProps } from "radix-vue";

const props = withDefaults(
	defineProps<MenubarContentProps & { class?: HTMLAttributes["class"] }>(),
	{
		align: "start",
		alignOffset: -4,
		sideOffset: 8,
	},
);

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <MenubarPortal>
    <MenubarContent
      v-bind="forwardedProps"
      :class="
        cn(
          'z-50 min-w-48 overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2',
          props.class,
        )
      "
    >
      <slot />
    </MenubarContent>
  </MenubarPortal>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/MenubarGroup.vue
```
<script setup lang="ts">
import { type MenubarGroupProps } from "radix-vue";

const props = defineProps<MenubarGroupProps>();
</script>

<template>
  <MenubarGroup v-bind="props">
    <slot />
  </MenubarGroup>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/MenubarItem.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import {
	type MenubarItemEmits,
	type MenubarItemProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<
	MenubarItemProps & { class?: HTMLAttributes["class"]; inset?: boolean }
>();

const emits = defineEmits<MenubarItemEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <MenubarItem
    v-bind="forwarded"
    :class="cn(
      'relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50',
      inset && 'pl-8',
      props.class,
    )"
  >
    <slot />
  </MenubarItem>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/MenubarLabel.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";
import { type MenubarLabelProps } from "radix-vue";

const props = defineProps<
	MenubarLabelProps & { class?: HTMLAttributes["class"]; inset?: boolean }
>();
</script>

<template>
  <MenubarLabel :class="cn('px-2 py-1.5 text-sm font-semibold', inset && 'pl-8', props.class)">
    <slot />
  </MenubarLabel>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/MenubarMenu.vue
```
<script setup lang="ts">
import { type MenubarMenuProps } from "radix-vue";

const props = defineProps<MenubarMenuProps>();
</script>

<template>
  <MenubarMenu v-bind="props">
    <slot />
  </MenubarMenu>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/MenubarRadioGroup.vue
```
<script setup lang="ts">
import {
	type MenubarRadioGroupEmits,
	type MenubarRadioGroupProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<MenubarRadioGroupProps>();

const emits = defineEmits<MenubarRadioGroupEmits>();

const forwarded = useForwardPropsEmits(props, emits);
</script>

<template>
  <MenubarRadioGroup v-bind="forwarded">
    <slot />
  </MenubarRadioGroup>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/MenubarRadioItem.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import {
	type MenubarRadioItemEmits,
	type MenubarRadioItemProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<
	MenubarRadioItemProps & { class?: HTMLAttributes["class"] }
>();
const emits = defineEmits<MenubarRadioItemEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <MenubarRadioItem
    v-bind="forwarded"
    :class="cn(
      'relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50',
      props.class,
    )"
  >
    <span class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
      <MenubarItemIndicator>
        <DotFilledIcon class="h-4 w-4 fill-current" />
      </MenubarItemIndicator>
    </span>
    <slot />
  </MenubarRadioItem>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/MenubarSeparator.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type MenubarSeparatorProps, useForwardProps } from "radix-vue";

const props = defineProps<
	MenubarSeparatorProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <MenubarSeparator :class=" cn('-mx-1 my-1 h-px bg-muted', props.class)" v-bind="forwardedProps" />
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/MenubarShortcut.vue
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
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/MenubarSub.vue
```
<script setup lang="ts">
import { type MenubarSubEmits, useForwardPropsEmits } from "radix-vue";

interface MenubarSubRootProps {
	defaultOpen?: boolean;
	open?: boolean;
}

const props = defineProps<MenubarSubRootProps>();
const emits = defineEmits<MenubarSubEmits>();

const forwarded = useForwardPropsEmits(props, emits);
</script>

<template>
  <MenubarSub v-bind="forwarded">
    <slot />
  </MenubarSub>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/MenubarSubContent.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import {
	type MenubarSubContentEmits,
	type MenubarSubContentProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<
	MenubarSubContentProps & { class?: HTMLAttributes["class"] }
>();

const emits = defineEmits<MenubarSubContentEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <MenubarPortal>
    <MenubarSubContent
      v-bind="forwarded"
      :class="
        cn(
          'z-50 min-w-32 overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-lg data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2',
          props.class,
        )
      "
    >
      <slot />
    </MenubarSubContent>
  </MenubarPortal>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/MenubarSubTrigger.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type MenubarSubTriggerProps, useForwardProps } from "radix-vue";

const props = defineProps<
	MenubarSubTriggerProps & { class?: HTMLAttributes["class"]; inset?: boolean }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <MenubarSubTrigger
    v-bind="forwardedProps"
    :class="cn(
      'flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground',
      inset && 'pl-8',
      props.class,
    )"
  >
    <slot />
    <ChevronRightIcon class="ml-auto h-4 w-4" />
  </MenubarSubTrigger>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/MenubarTrigger.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type MenubarTriggerProps, useForwardProps } from "radix-vue";

const props = defineProps<
	MenubarTriggerProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <MenubarTrigger
    v-bind="forwardedProps"
    :class="
      cn(
        'flex cursor-default select-none items-center rounded-sm px-3 py-1 text-sm font-medium outline-none focus:bg-accent focus:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground',
        props.class,
      )
    "
  >
    <slot />
  </MenubarTrigger>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/menubar/index.ts
```typescript
export { default as Menubar } from "./Menubar.vue";
export { default as MenubarItem } from "./MenubarItem.vue";
export { default as MenubarContent } from "./MenubarContent.vue";
export { default as MenubarGroup } from "./MenubarGroup.vue";
export { default as MenubarMenu } from "./MenubarMenu.vue";
export { default as MenubarRadioGroup } from "./MenubarRadioGroup.vue";
export { default as MenubarRadioItem } from "./MenubarRadioItem.vue";
export { default as MenubarCheckboxItem } from "./MenubarCheckboxItem.vue";
export { default as MenubarSeparator } from "./MenubarSeparator.vue";
export { default as MenubarSub } from "./MenubarSub.vue";
export { default as MenubarSubContent } from "./MenubarSubContent.vue";
export { default as MenubarSubTrigger } from "./MenubarSubTrigger.vue";
export { default as MenubarTrigger } from "./MenubarTrigger.vue";
export { default as MenubarShortcut } from "./MenubarShortcut.vue";
export { default as MenubarLabel } from "./MenubarLabel.vue";

```
