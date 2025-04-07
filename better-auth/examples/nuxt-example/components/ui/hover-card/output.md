/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/hover-card/HoverCard.vue
```
<script setup lang="ts">
import {
	type HoverCardRootEmits,
	type HoverCardRootProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<HoverCardRootProps>();
const emits = defineEmits<HoverCardRootEmits>();

const forwarded = useForwardPropsEmits(props, emits);
</script>

<template>
  <HoverCardRoot v-bind="forwarded">
    <slot />
  </HoverCardRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/hover-card/HoverCardContent.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type HoverCardContentProps, useForwardProps } from "radix-vue";

const props = withDefaults(
	defineProps<HoverCardContentProps & { class?: HTMLAttributes["class"] }>(),
	{
		sideOffset: 4,
	},
);

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <HoverCardPortal>
    <HoverCardContent
      v-bind="forwardedProps"
      :class="
        cn(
          'z-50 w-64 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2',
          props.class,
        )
      "
    >
      <slot />
    </HoverCardContent>
  </HoverCardPortal>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/hover-card/HoverCardTrigger.vue
```
<script setup lang="ts">
import { type HoverCardTriggerProps } from "radix-vue";

const props = defineProps<HoverCardTriggerProps>();
</script>

<template>
  <HoverCardTrigger v-bind="props">
    <slot />
  </HoverCardTrigger>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/hover-card/index.ts
```typescript
export { default as HoverCard } from "./HoverCard.vue";
export { default as HoverCardTrigger } from "./HoverCardTrigger.vue";
export { default as HoverCardContent } from "./HoverCardContent.vue";

```
