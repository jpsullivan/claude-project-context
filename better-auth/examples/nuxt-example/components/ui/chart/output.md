/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/chart/ChartCrosshair.vue
```
<script setup lang="ts">
import type { BulletLegendItemInterface } from "@unovis/ts";
import { omit } from "@unovis/ts";
import { type Component, createApp } from "vue";
import { ChartTooltip } from ".";

const props = withDefaults(
	defineProps<{
		colors: string[];
		index: string;
		items: BulletLegendItemInterface[];
		customTooltip?: Component;
	}>(),
	{
		colors: () => [],
	},
);

// Use weakmap to store reference to each datapoint for Tooltip
const wm = new WeakMap();
function template(d: any) {
	if (wm.has(d)) {
		return wm.get(d);
	} else {
		const componentDiv = document.createElement("div");
		const omittedData = Object.entries(omit(d, [props.index])).map(
			([key, value]) => {
				const legendReference = props.items.find((i) => i.name === key);
				return { ...legendReference, value };
			},
		);
		const TooltipComponent = props.customTooltip ?? ChartTooltip;
		createApp(TooltipComponent, {
			title: d[props.index].toString(),
			data: omittedData,
		}).mount(componentDiv);
		wm.set(d, componentDiv.innerHTML);
		return componentDiv.innerHTML;
	}
}

function color(d: unknown, i: number) {
	return props.colors[i] ?? "transparent";
}
</script>

<template>
  <VisTooltip :horizontal-shift="20" :vertical-shift="20" />
  <VisCrosshair :template="template" :color="color" />
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/chart/ChartLegend.vue
```
<script setup lang="ts">
import type { BulletLegendItemInterface } from "@unovis/ts";
import { BulletLegend } from "@unovis/ts";
import { nextTick, onMounted, ref } from "vue";
import { buttonVariants } from "@/components/ui/button";

const props = withDefaults(
	defineProps<{ items: BulletLegendItemInterface[] }>(),
	{
		items: () => [],
	},
);

const emits = defineEmits<{
	legendItemClick: [d: BulletLegendItemInterface, i: number];
	"update:items": [payload: BulletLegendItemInterface[]];
}>();

const elRef = ref<HTMLElement>();

onMounted(() => {
	const selector = `.${BulletLegend.selectors.item}`;
	nextTick(() => {
		const elements = elRef.value?.querySelectorAll(selector);
		const classes = buttonVariants({ variant: "ghost", size: "xs" }).split(" ");
		elements?.forEach((el) =>
			el.classList.add(...classes, "!inline-flex", "!mr-2"),
		);
	});
});

function onLegendItemClick(d: BulletLegendItemInterface, i: number) {
	emits("legendItemClick", d, i);
	const isBulletActive = !props.items[i].inactive;
	const isFilterApplied = props.items.some((i) => i.inactive);
	if (isFilterApplied && isBulletActive) {
		// reset filter
		emits(
			"update:items",
			props.items.map((item) => ({ ...item, inactive: false })),
		);
	} else {
		// apply selection, set other item as inactive
		emits(
			"update:items",
			props.items.map((item) =>
				item.name === d.name
					? { ...d, inactive: false }
					: { ...item, inactive: true },
			),
		);
	}
}
</script>

<template>
  <div ref="elRef" class="w-max">
    <VisBulletLegend
      :items="items"
      :on-legend-item-click="onLegendItemClick"
    />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/chart/ChartSingleTooltip.vue
```
<script setup lang="ts">
import type { BulletLegendItemInterface } from "@unovis/ts";
import { omit } from "@unovis/ts";
import { type Component, createApp } from "vue";
import { ChartTooltip } from ".";

const props = withDefaults(
	defineProps<{
		selector: string;
		index: string;
		items?: BulletLegendItemInterface[];
		valueFormatter?: (tick: number, i?: number, ticks?: number[]) => string;
		customTooltip?: Component;
	}>(),
	{
		valueFormatter: (tick: number) => `${tick}`,
	},
);

// Use weakmap to store reference to each datapoint for Tooltip
const wm = new WeakMap();
function template(d: any, i: number, elements: (HTMLElement | SVGElement)[]) {
	if (props.index in d) {
		if (wm.has(d)) {
			return wm.get(d);
		} else {
			const componentDiv = document.createElement("div");
			const omittedData = Object.entries(omit(d, [props.index])).map(
				([key, value]) => {
					const legendReference = props.items?.find((i) => i.name === key);
					return { ...legendReference, value: props.valueFormatter(value) };
				},
			);
			const TooltipComponent = props.customTooltip ?? ChartTooltip;
			createApp(TooltipComponent, {
				title: d[props.index],
				data: omittedData,
			}).mount(componentDiv);
			wm.set(d, componentDiv.innerHTML);
			return componentDiv.innerHTML;
		}
	} else {
		const data = d.data;

		if (wm.has(data)) {
			return wm.get(data);
		} else {
			const style = getComputedStyle(elements[i]);
			const omittedData = [
				{
					name: data.name,
					value: props.valueFormatter(data[props.index]),
					color: style.fill,
				},
			];
			const componentDiv = document.createElement("div");
			const TooltipComponent = props.customTooltip ?? ChartTooltip;
			createApp(TooltipComponent, {
				title: d[props.index],
				data: omittedData,
			}).mount(componentDiv);
			wm.set(d, componentDiv.innerHTML);
			return componentDiv.innerHTML;
		}
	}
}
</script>

<template>
  <VisTooltip
    :horizontal-shift="20" :vertical-shift="20" :triggers="{
      [selector]: template,
    }"
  />
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/chart/ChartTooltip.vue
```
<script setup lang="ts">
defineProps<{
	title?: string;
	data: {
		name: string;
		color: string;
		value: any;
	}[];
}>();
</script>

<template>
  <Card class="text-sm">
    <CardHeader v-if="title" class="p-3 border-b">
      <CardTitle>
        {{ title }}
      </CardTitle>
    </CardHeader>
    <CardContent class="p-3 min-w-[180px] flex flex-col gap-1">
      <div v-for="(item, key) in data" :key="key" class="flex justify-between">
        <div class="flex items-center">
          <span class="w-2.5 h-2.5 mr-2">
            <svg width="100%" height="100%" viewBox="0 0 30 30">
              <path
                d=" M 15 15 m -14, 0 a 14,14 0 1,1 28,0 a 14,14 0 1,1 -28,0"
                :stroke="item.color"
                :fill="item.color"
                stroke-width="1"
              />
            </svg>
          </span>
          <span>{{ item.name }}</span>
        </div>
        <span class="ml-4 font-semibold">{{ item.value }}</span>
      </div>
    </CardContent>
  </Card>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/chart/index.ts
```typescript
export { default as ChartTooltip } from "./ChartTooltip.vue";
export { default as ChartSingleTooltip } from "./ChartSingleTooltip.vue";
export { default as ChartLegend } from "./ChartLegend.vue";
export { default as ChartCrosshair } from "./ChartCrosshair.vue";

export function defaultColors(count: number = 3) {
	const quotient = Math.floor(count / 2);
	const remainder = count % 2;

	const primaryCount = quotient + remainder;
	const secondaryCount = quotient;
	return [
		...Array.from(Array(primaryCount).keys()).map(
			(i) => `hsl(var(--vis-primary-color) / ${1 - (1 / primaryCount) * i})`,
		),
		...Array.from(Array(secondaryCount).keys()).map(
			(i) =>
				`hsl(var(--vis-secondary-color) / ${1 - (1 / secondaryCount) * i})`,
		),
	];
}

export * from "./interface";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/chart/interface.ts
```typescript
import type { Spacing } from "@unovis/ts";

type KeyOf<T extends Record<string, any>> = Extract<keyof T, string>;

export interface BaseChartProps<T extends Record<string, any>> {
	/**
	 * The source data, in which each entry is a dictionary.
	 */
	data: T[];
	/**
	 * Select the categories from your data. Used to populate the legend and toolip.
	 */
	categories: KeyOf<T>[];
	/**
	 * Sets the key to map the data to the axis.
	 */
	index: KeyOf<T>;
	/**
	 * Change the default colors.
	 */
	colors?: string[];
	/**
	 * Margin of each the container
	 */
	margin?: Spacing;
	/**
	 * Change the opacity of the non-selected field
	 * @default 0.2
	 */
	filterOpacity?: number;
	/**
	 * Function to format X label
	 */
	xFormatter?: (
		tick: number | Date,
		i: number,
		ticks: number[] | Date[],
	) => string;
	/**
	 * Function to format Y label
	 */
	yFormatter?: (
		tick: number | Date,
		i: number,
		ticks: number[] | Date[],
	) => string;
	/**
	 * Controls the visibility of the X axis.
	 * @default true
	 */
	showXAxis?: boolean;
	/**
	 * Controls the visibility of the Y axis.
	 * @default true
	 */
	showYAxis?: boolean;
	/**
	 * Controls the visibility of tooltip.
	 * @default true
	 */
	showTooltip?: boolean;
	/**
	 * Controls the visibility of legend.
	 * @default true
	 */
	showLegend?: boolean;
	/**
	 * Controls the visibility of gridline.
	 * @default true
	 */
	showGridLine?: boolean;
}

```
