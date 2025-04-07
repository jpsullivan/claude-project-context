/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/navigation-menu/NavigationMenu.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import {
	type NavigationMenuRootEmits,
	type NavigationMenuRootProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<
	NavigationMenuRootProps & { class?: HTMLAttributes["class"] }
>();

const emits = defineEmits<NavigationMenuRootEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <NavigationMenuRoot
    v-bind="forwarded"
    :class="cn('relative z-10 flex max-w-max flex-1 items-center justify-center', props.class)"
  >
    <slot />
    <NavigationMenuViewport />
  </NavigationMenuRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/navigation-menu/NavigationMenuContent.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import {
	type NavigationMenuContentEmits,
	type NavigationMenuContentProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<
	NavigationMenuContentProps & { class?: HTMLAttributes["class"] }
>();

const emits = defineEmits<NavigationMenuContentEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <NavigationMenuContent
    v-bind="forwarded"
    :class="cn(
      'left-0 top-0 w-full data-[motion^=from-]:animate-in data-[motion^=to-]:animate-out data-[motion^=from-]:fade-in data-[motion^=to-]:fade-out data-[motion=from-end]:slide-in-from-right-52 data-[motion=from-start]:slide-in-from-left-52 data-[motion=to-end]:slide-out-to-right-52 data-[motion=to-start]:slide-out-to-left-52 md:absolute md:w-auto',
      props.class,
    )"
  >
    <slot />
  </NavigationMenuContent>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/navigation-menu/NavigationMenuIndicator.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type NavigationMenuIndicatorProps, useForwardProps } from "radix-vue";

const props = defineProps<
	NavigationMenuIndicatorProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <NavigationMenuIndicator
    v-bind="forwardedProps"
    :class="cn('top-full z-[1] flex h-1.5 items-end justify-center overflow-hidden data-[state=visible]:animate-in data-[state=hidden]:animate-out data-[state=hidden]:fade-out data-[state=visible]:fade-in', props.class)"
  >
    <div class="relative top-[60%] h-2 w-2 rotate-45 rounded-tl-sm bg-border shadow-md" />
  </NavigationMenuIndicator>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/navigation-menu/NavigationMenuItem.vue
```
<script setup lang="ts">
import { type NavigationMenuItemProps } from "radix-vue";

const props = defineProps<NavigationMenuItemProps>();
</script>

<template>
  <NavigationMenuItem v-bind="props">
    <slot />
  </NavigationMenuItem>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/navigation-menu/NavigationMenuLink.vue
```
<script setup lang="ts">
import {
	type NavigationMenuLinkEmits,
	type NavigationMenuLinkProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<NavigationMenuLinkProps>();
const emits = defineEmits<NavigationMenuLinkEmits>();

const forwarded = useForwardPropsEmits(props, emits);
</script>

<template>
  <NavigationMenuLink v-bind="forwarded">
    <slot />
  </NavigationMenuLink>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/navigation-menu/NavigationMenuList.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type NavigationMenuListProps, useForwardProps } from "radix-vue";

const props = defineProps<
	NavigationMenuListProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <NavigationMenuList
    v-bind="forwardedProps"
    :class="
      cn(
        'group flex flex-1 list-none items-center justify-center gap-x-1',
        props.class,
      )
    "
  >
    <slot />
  </NavigationMenuList>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/navigation-menu/NavigationMenuTrigger.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type NavigationMenuTriggerProps, useForwardProps } from "radix-vue";

const props = defineProps<
	NavigationMenuTriggerProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <NavigationMenuTrigger
    v-bind="forwardedProps"
    :class="cn(navigationMenuTriggerStyle(), 'group', props.class)"
  >
    <slot />
    <ChevronDownIcon
      class="relative top-px ml-1 h-3 w-3 transition duration-300 group-data-[state=open]:rotate-180"
      aria-hidden="true"
    />
  </NavigationMenuTrigger>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/navigation-menu/NavigationMenuViewport.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type NavigationMenuViewportProps, useForwardProps } from "radix-vue";

const props = defineProps<
	NavigationMenuViewportProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <div class="absolute left-0 top-full flex justify-center">
    <NavigationMenuViewport
      v-bind="forwardedProps"
      :class="
        cn(
          'origin-top-center relative mt-1.5 h-[--radix-navigation-menu-viewport-height] w-full overflow-hidden rounded-md border bg-popover text-popover-foreground shadow data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-90 md:w-[--radix-navigation-menu-viewport-width]',
          props.class,
        )
      "
    />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/navigation-menu/index.ts
```typescript
import { cva } from "class-variance-authority";

export { default as NavigationMenu } from "./NavigationMenu.vue";
export { default as NavigationMenuList } from "./NavigationMenuList.vue";
export { default as NavigationMenuItem } from "./NavigationMenuItem.vue";
export { default as NavigationMenuTrigger } from "./NavigationMenuTrigger.vue";
export { default as NavigationMenuContent } from "./NavigationMenuContent.vue";
export { default as NavigationMenuLink } from "./NavigationMenuLink.vue";

export const navigationMenuTriggerStyle = cva(
	"group inline-flex h-9 w-max items-center justify-center rounded-md bg-background px-4 py-2 text-sm font-medium transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground focus:outline-none disabled:pointer-events-none disabled:opacity-50 data-[active]:bg-accent/50 data-[state=open]:bg-accent/50",
);

```
