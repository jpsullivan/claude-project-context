/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/range-calendar/RangeCalendar.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import {
	type RangeCalendarRootEmits,
	type RangeCalendarRootProps,
	useForwardPropsEmits,
} from "radix-vue";

const props = defineProps<
	RangeCalendarRootProps & { class?: HTMLAttributes["class"] }
>();

const emits = defineEmits<RangeCalendarRootEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <RangeCalendarRoot
    v-slot="{ grid, weekDays }"
    :class="cn('p-3', props.class)"
    v-bind="forwarded"
  >
    <RangeCalendarHeader>
      <RangeCalendarPrevButton />
      <RangeCalendarHeading />
      <RangeCalendarNextButton />
    </RangeCalendarHeader>

    <div class="flex flex-col gap-y-4 mt-4 sm:flex-row sm:gap-x-4 sm:gap-y-0">
      <RangeCalendarGrid v-for="month in grid" :key="month.value.toString()">
        <RangeCalendarGridHead>
          <RangeCalendarGridRow>
            <RangeCalendarHeadCell
              v-for="day in weekDays" :key="day"
            >
              {{ day }}
            </RangeCalendarHeadCell>
          </RangeCalendarGridRow>
        </RangeCalendarGridHead>
        <RangeCalendarGridBody>
          <RangeCalendarGridRow v-for="(weekDates, index) in month.rows" :key="`weekDate-${index}`" class="mt-2 w-full">
            <RangeCalendarCell
              v-for="weekDate in weekDates"
              :key="weekDate.toString()"
              :date="weekDate"
            >
              <RangeCalendarCellTrigger
                :day="weekDate"
                :month="month.value"
              />
            </RangeCalendarCell>
          </RangeCalendarGridRow>
        </RangeCalendarGridBody>
      </RangeCalendarGrid>
    </div>
  </RangeCalendarRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/range-calendar/RangeCalendarCell.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import { type RangeCalendarCellProps, useForwardProps } from "radix-vue";

const props = defineProps<
	RangeCalendarCellProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <RangeCalendarCell
    :class="cn('relative p-0 text-center text-sm focus-within:relative focus-within:z-20 [&:has([data-selected])]:bg-accent first:[&:has([data-selected])]:rounded-l-md last:[&:has([data-selected])]:rounded-r-md [&:has([data-selected][data-outside-view])]:bg-accent/50 [&:has([data-selected][data-selection-end])]:rounded-r-md [&:has([data-selected][data-selection-start])]:rounded-l-md', props.class)"
    v-bind="forwardedProps"
  >
    <slot />
  </RangeCalendarCell>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/range-calendar/RangeCalendarCellTrigger.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import { type RangeCalendarCellTriggerProps, useForwardProps } from "radix-vue";

const props = defineProps<
	RangeCalendarCellTriggerProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <RangeCalendarCellTrigger
    :class="cn(
      buttonVariants({ variant: 'ghost' }),
      'h-8 w-8 p-0 font-normal data-[selected]:opacity-100',
      '[&[data-today]:not([data-selected])]:bg-accent [&[data-today]:not([data-selected])]:text-accent-foreground',
      // Selection Start
      'data-[selection-start]:bg-primary data-[selection-start]:text-primary-foreground data-[selection-start]:hover:bg-primary data-[selection-start]:hover:text-primary-foreground data-[selection-start]:focus:bg-primary data-[selection-start]:focus:text-primary-foreground',
      // Selection End
      'data-[selection-end]:bg-primary data-[selection-end]:text-primary-foreground data-[selection-end]:hover:bg-primary data-[selection-end]:hover:text-primary-foreground data-[selection-end]:focus:bg-primary data-[selection-end]:focus:text-primary-foreground',
      // Outside months
      'data-[outside-view]:text-muted-foreground data-[outside-view]:opacity-50 [&[data-outside-view][data-selected]]:text-muted-foreground [&[data-outside-view][data-selected]]:opacity-30',
      // Disabled
      'data-[disabled]:text-muted-foreground data-[disabled]:opacity-50',
      // Unavailable
      'data-[unavailable]:text-destructive-foreground data-[unavailable]:line-through',
      props.class,
    )"
    v-bind="forwardedProps"
  >
    <slot />
  </RangeCalendarCellTrigger>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/range-calendar/RangeCalendarGrid.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import { type RangeCalendarGridProps, useForwardProps } from "radix-vue";

const props = defineProps<
	RangeCalendarGridProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <RangeCalendarGrid
    :class="cn('w-full border-collapse space-y-1', props.class)"
    v-bind="forwardedProps"
  >
    <slot />
  </RangeCalendarGrid>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/range-calendar/RangeCalendarGridBody.vue
```
<script lang="ts" setup>
import { type RangeCalendarGridBodyProps } from "radix-vue";

const props = defineProps<RangeCalendarGridBodyProps>();
</script>

<template>
  <RangeCalendarGridBody v-bind="props">
    <slot />
  </RangeCalendarGridBody>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/range-calendar/RangeCalendarGridHead.vue
```
<script lang="ts" setup>
import { type RangeCalendarGridHeadProps } from "radix-vue";

const props = defineProps<RangeCalendarGridHeadProps>();
</script>

<template>
  <RangeCalendarGridHead v-bind="props">
    <slot />
  </RangeCalendarGridHead>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/range-calendar/RangeCalendarGridRow.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import { type RangeCalendarGridRowProps, useForwardProps } from "radix-vue";

const props = defineProps<
	RangeCalendarGridRowProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <RangeCalendarGridRow :class="cn('flex', props.class)" v-bind="forwardedProps">
    <slot />
  </RangeCalendarGridRow>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/range-calendar/RangeCalendarHeadCell.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import { type RangeCalendarHeadCellProps, useForwardProps } from "radix-vue";

const props = defineProps<
	RangeCalendarHeadCellProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <RangeCalendarHeadCell
    :class="cn('w-8 rounded-md text-[0.8rem] font-normal text-muted-foreground', props.class)"
    v-bind="forwardedProps"
  >
    <slot />
  </RangeCalendarHeadCell>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/range-calendar/RangeCalendarHeader.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import { type RangeCalendarHeaderProps, useForwardProps } from "radix-vue";

const props = defineProps<
	RangeCalendarHeaderProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <RangeCalendarHeader :class="cn('relative flex w-full items-center justify-between pt-1', props.class)" v-bind="forwardedProps">
    <slot />
  </RangeCalendarHeader>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/range-calendar/RangeCalendarHeading.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import { type RangeCalendarHeadingProps, useForwardProps } from "radix-vue";

const props = defineProps<
	RangeCalendarHeadingProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <RangeCalendarHeading
    v-slot="{ headingValue }"
    :class="cn('text-sm font-medium', props.class)"
    v-bind="forwardedProps"
  >
    <slot :heading-value>
      {{ headingValue }}
    </slot>
  </RangeCalendarHeading>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/range-calendar/RangeCalendarNextButton.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import { type RangeCalendarNextProps, useForwardProps } from "radix-vue";

const props = defineProps<
	RangeCalendarNextProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <RangeCalendarNext
    :class="cn(
      buttonVariants({ variant: 'outline' }),
      'h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100',
      props.class,
    )"
    v-bind="forwardedProps"
  >
    <slot>
      <ChevronRightIcon class="h-4 w-4" />
    </slot>
  </RangeCalendarNext>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/range-calendar/RangeCalendarPrevButton.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, computed } from "vue";
import { type RangeCalendarPrevProps, useForwardProps } from "radix-vue";

const props = defineProps<
	RangeCalendarPrevProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <RangeCalendarPrev
    :class="cn(
      buttonVariants({ variant: 'outline' }),
      'h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100',
      props.class,
    )"
    v-bind="forwardedProps"
  >
    <slot>
      <ChevronLeftIcon class="h-4 w-4" />
    </slot>
  </RangeCalendarPrev>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/range-calendar/index.ts
```typescript
export { default as RangeCalendar } from "./RangeCalendar.vue";
export { default as RangeCalendarCell } from "./RangeCalendarCell.vue";
export { default as RangeCalendarCellTrigger } from "./RangeCalendarCellTrigger.vue";
export { default as RangeCalendarGrid } from "./RangeCalendarGrid.vue";
export { default as RangeCalendarGridBody } from "./RangeCalendarGridBody.vue";
export { default as RangeCalendarGridHead } from "./RangeCalendarGridHead.vue";
export { default as RangeCalendarGridRow } from "./RangeCalendarGridRow.vue";
export { default as RangeCalendarHeadCell } from "./RangeCalendarHeadCell.vue";
export { default as RangeCalendarHeader } from "./RangeCalendarHeader.vue";
export { default as RangeCalendarHeading } from "./RangeCalendarHeading.vue";
export { default as RangeCalendarNextButton } from "./RangeCalendarNextButton.vue";
export { default as RangeCalendarPrevButton } from "./RangeCalendarPrevButton.vue";

```
