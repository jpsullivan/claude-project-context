/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tabs/Tabs.vue
```
<script setup lang="ts">
import { useForwardPropsEmits } from "radix-vue";
import type { TabsRootEmits, TabsRootProps } from "radix-vue";

const props = defineProps<TabsRootProps>();
const emits = defineEmits<TabsRootEmits>();

const forwarded = useForwardPropsEmits(props, emits);
</script>

<template>
  <TabsRoot v-bind="forwarded">
    <slot />
  </TabsRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tabs/TabsContent.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type TabsContentProps } from "radix-vue";

const props = defineProps<
	TabsContentProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <TabsContent
    :class="cn('mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2', props.class)"
    v-bind="delegatedProps"
  >
    <slot />
  </TabsContent>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tabs/TabsList.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type TabsListProps } from "radix-vue";

const props = defineProps<
	TabsListProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <TabsList
    v-bind="delegatedProps"
    :class="cn(
      'inline-flex items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground',
      props.class,
    )"
  >
    <slot />
  </TabsList>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tabs/TabsTrigger.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type TabsTriggerProps, useForwardProps } from "radix-vue";

const props = defineProps<
	TabsTriggerProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <TabsTrigger
    v-bind="forwardedProps"
    :class="cn(
      'inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow',
      props.class,
    )"
  >
    <span class="truncate">
      <slot />
    </span>
  </TabsTrigger>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/tabs/index.ts
```typescript
export { default as Tabs } from "./Tabs.vue";
export { default as TabsTrigger } from "./TabsTrigger.vue";
export { default as TabsList } from "./TabsList.vue";
export { default as TabsContent } from "./TabsContent.vue";

```
