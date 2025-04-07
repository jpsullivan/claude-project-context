/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/stepper/Stepper.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import type { StepperRootEmits, StepperRootProps } from "radix-vue";
import { useForwardPropsEmits } from "radix-vue";

const props = defineProps<
	StepperRootProps & { class?: HTMLAttributes["class"] }
>();
const emits = defineEmits<StepperRootEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <StepperRoot
    v-slot="slotProps"
    :class="cn(
      'flex gap-2',
      props.class,
    )"
    v-bind="forwarded"
  >
    <slot v-bind="slotProps" />
  </StepperRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/stepper/StepperDescription.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import type { StepperDescriptionProps } from "radix-vue";
import { useForwardProps } from "radix-vue";

const props = defineProps<
	StepperDescriptionProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardProps(delegatedProps);
</script>

<template>
  <StepperDescription v-slot="slotProps" v-bind="forwarded" :class="cn('text-xs text-muted-foreground', props.class)">
    <slot v-bind="slotProps" />
  </StepperDescription>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/stepper/StepperIndicator.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import type { StepperIndicatorProps } from "radix-vue";
import { useForwardProps } from "radix-vue";

const props = defineProps<
	StepperIndicatorProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardProps(delegatedProps);
</script>

<template>
  <StepperIndicator
    v-bind="forwarded"
    :class="cn(
      'inline-flex items-center justify-center rounded-full text-muted-foreground/50 w-8 h-8',
      // Disabled
      'group-data-[disabled]:text-muted-foreground group-data-[disabled]:opacity-50',
      // Active
      'group-data-[state=active]:bg-primary group-data-[state=active]:text-primary-foreground',
      // Completed
      'group-data-[state=completed]:bg-accent group-data-[state=completed]:text-accent-foreground',
      props.class,
    )"
  >
    <slot />
  </StepperIndicator>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/stepper/StepperItem.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import type { StepperItemProps } from "radix-vue";
import { useForwardProps } from "radix-vue";

const props = defineProps<
	StepperItemProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardProps(delegatedProps);
</script>

<template>
  <StepperItem
    v-slot="slotProps"
    v-bind="forwarded"
    :class="cn('flex items-center gap-2 group data-[disabled]:pointer-events-none', props.class)"
  >
    <slot v-bind="slotProps" />
  </StepperItem>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/stepper/StepperSeparator.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import type { StepperSeparatorProps } from "radix-vue";
import { useForwardProps } from "radix-vue";

const props = defineProps<
	StepperSeparatorProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardProps(delegatedProps);
</script>

<template>
  <StepperSeparator
    v-bind="forwarded"
    :class="cn(
      'bg-muted',
      // Disabled
      'group-data-[disabled]:bg-muted group-data-[disabled]:opacity-50',
      // Completed
      'group-data-[state=completed]:bg-accent-foreground',
      props.class,
    )"
  />
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/stepper/StepperTitle.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import type { StepperTitleProps } from "radix-vue";
import { useForwardProps } from "radix-vue";

const props = defineProps<
	StepperTitleProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardProps(delegatedProps);
</script>

<template>
  <StepperTitle v-bind="forwarded" :class="cn('text-md font-semibold whitespace-nowrap', props.class)">
    <slot />
  </StepperTitle>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/stepper/StepperTrigger.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import type { StepperTriggerProps } from "radix-vue";
import { useForwardProps } from "radix-vue";

const props = defineProps<
	StepperTriggerProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardProps(delegatedProps);
</script>

<template>
  <StepperTrigger
    v-bind="forwarded"
    :class="cn('p-1 flex flex-col items-center text-center gap-1 rounded-md', props.class)"
  >
    <slot />
  </StepperTrigger>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/stepper/index.ts
```typescript
export { default as Stepper } from "./Stepper.vue";
export { default as StepperItem } from "./StepperItem.vue";
export { default as StepperIndicator } from "./StepperIndicator.vue";
export { default as StepperTrigger } from "./StepperTrigger.vue";
export { default as StepperTitle } from "./StepperTitle.vue";
export { default as StepperDescription } from "./StepperDescription.vue";
export { default as StepperSeparator } from "./StepperSeparator.vue";

```
