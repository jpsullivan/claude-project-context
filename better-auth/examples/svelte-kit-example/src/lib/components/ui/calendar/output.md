/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/calendar/calendar-cell.svelte
```
<script lang="ts">
import { Calendar as CalendarPrimitive } from "bits-ui";

type $$Props = CalendarPrimitive.CellProps;

export let date: $$Props["date"];
let className: $$Props["class"] = undefined;
export { className as class };
</script>

<CalendarPrimitive.Cell
	{date}
	class={cn(
		"[&:has([data-selected])]:bg-accent [&:has([data-selected][data-outside-month])]:bg-accent/50 relative p-0 text-center text-sm focus-within:relative focus-within:z-20 [&:has([data-selected])]:rounded-md",
		className
	)}
	{...$$restProps}
>
	<slot />
</CalendarPrimitive.Cell>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/calendar/calendar-day.svelte
```
<script lang="ts">
import { Calendar as CalendarPrimitive } from "bits-ui";

type $$Props = CalendarPrimitive.DayProps;
type $$Events = CalendarPrimitive.DayEvents;

export let date: $$Props["date"];
export let month: $$Props["month"];
let className: $$Props["class"] = undefined;
export { className as class };
</script>

<CalendarPrimitive.Day
	on:click
	{date}
	{month}
	class={cn(
		buttonVariants({ variant: "ghost" }),
		"h-8 w-8 p-0 font-normal",
		// Today
		"[&[data-today]:not([data-selected])]:bg-accent [&[data-today]:not([data-selected])]:text-accent-foreground",
		// Selected
		"data-[selected]:bg-primary data-[selected]:text-primary-foreground data-[selected]:hover:bg-primary data-[selected]:hover:text-primary-foreground data-[selected]:focus:bg-primary data-[selected]:focus:text-primary-foreground data-[selected]:opacity-100",
		// Disabled
		"data-[disabled]:text-muted-foreground data-[disabled]:opacity-50",
		// Unavailable
		"data-[unavailable]:text-destructive-foreground data-[unavailable]:line-through",
		// Outside months
		"data-[outside-month]:text-muted-foreground [&[data-outside-month][data-selected]]:bg-accent/50 [&[data-outside-month][data-selected]]:text-muted-foreground data-[outside-month]:pointer-events-none data-[outside-month]:opacity-50 [&[data-outside-month][data-selected]]:opacity-30",
		className
	)}
	{...$$restProps}
	let:selected
	let:disabled
	let:unavailable
	let:builder
>
	<slot {selected} {disabled} {unavailable} {builder}>
		{date.day}
	</slot>
</CalendarPrimitive.Day>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/calendar/calendar-grid-body.svelte
```
<script lang="ts">
import { Calendar as CalendarPrimitive } from "bits-ui";

type $$Props = CalendarPrimitive.GridBodyProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<CalendarPrimitive.GridBody class={cn(className)} {...$$restProps}>
	<slot />
</CalendarPrimitive.GridBody>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/calendar/calendar-grid-head.svelte
```
<script lang="ts">
import { Calendar as CalendarPrimitive } from "bits-ui";

type $$Props = CalendarPrimitive.GridHeadProps;

let className: string | undefined | null = undefined;
export { className as class };
</script>

<CalendarPrimitive.GridHead class={cn(className)} {...$$restProps}>
	<slot />
</CalendarPrimitive.GridHead>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/calendar/calendar-grid-row.svelte
```
<script lang="ts">
import { Calendar as CalendarPrimitive } from "bits-ui";

type $$Props = CalendarPrimitive.GridRowProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<CalendarPrimitive.GridRow class={cn("flex", className)} {...$$restProps}>
	<slot />
</CalendarPrimitive.GridRow>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/calendar/calendar-grid.svelte
```
<script lang="ts">
import { Calendar as CalendarPrimitive } from "bits-ui";

type $$Props = CalendarPrimitive.GridProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<CalendarPrimitive.Grid class={cn("w-full border-collapse space-y-1", className)} {...$$restProps}>
	<slot />
</CalendarPrimitive.Grid>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/calendar/calendar-head-cell.svelte
```
<script lang="ts">
import { Calendar as CalendarPrimitive } from "bits-ui";

type $$Props = CalendarPrimitive.HeadCellProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<CalendarPrimitive.HeadCell
	class={cn("text-muted-foreground w-8 rounded-md text-[0.8rem] font-normal", className)}
	{...$$restProps}
>
	<slot />
</CalendarPrimitive.HeadCell>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/calendar/calendar-header.svelte
```
<script lang="ts">
import { Calendar as CalendarPrimitive } from "bits-ui";

type $$Props = CalendarPrimitive.HeaderProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<CalendarPrimitive.Header
	class={cn("relative flex w-full items-center justify-between pt-1", className)}
	{...$$restProps}
>
	<slot />
</CalendarPrimitive.Header>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/calendar/calendar-heading.svelte
```
<script lang="ts">
import { Calendar as CalendarPrimitive } from "bits-ui";

type $$Props = CalendarPrimitive.HeadingProps;

let className: string | undefined | null = undefined;
export { className as class };
</script>

<CalendarPrimitive.Heading
	let:headingValue
	class={cn("text-sm font-medium", className)}
	{...$$restProps}
>
	<slot {headingValue}>
		{headingValue}
	</slot>
</CalendarPrimitive.Heading>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/calendar/calendar-months.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";

type $$Props = HTMLAttributes<HTMLDivElement>;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<div
	class={cn("mt-4 flex flex-col space-y-4 sm:flex-row sm:space-x-4 sm:space-y-0", className)}
	{...$$restProps}
>
	<slot />
</div>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/calendar/calendar-next-button.svelte
```
<script lang="ts">
import { Calendar as CalendarPrimitive } from "bits-ui";

type $$Props = CalendarPrimitive.NextButtonProps;
type $$Events = CalendarPrimitive.NextButtonEvents;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<CalendarPrimitive.NextButton
	on:click
	class={cn(
		buttonVariants({ variant: "outline" }),
		"h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100",
		className
	)}
	{...$$restProps}
	let:builder
>
	<slot {builder}>
		<ChevronRight class="h-4 w-4" />
	</slot>
</CalendarPrimitive.NextButton>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/calendar/calendar-prev-button.svelte
```
<script lang="ts">
import { Calendar as CalendarPrimitive } from "bits-ui";

type $$Props = CalendarPrimitive.PrevButtonProps;
type $$Events = CalendarPrimitive.PrevButtonEvents;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<CalendarPrimitive.PrevButton
	on:click
	class={cn(
		buttonVariants({ variant: "outline" }),
		"h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100",
		className
	)}
	{...$$restProps}
	let:builder
>
	<slot {builder}>
		<ChevronLeft class="h-4 w-4" />
	</slot>
</CalendarPrimitive.PrevButton>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/calendar/calendar.svelte
```
<script lang="ts">
import { Calendar as CalendarPrimitive } from "bits-ui";

type $$Props = CalendarPrimitive.Props;
type $$Events = CalendarPrimitive.Events;

export let value: $$Props["value"] = undefined;
export let placeholder: $$Props["placeholder"] = undefined;
export let weekdayFormat: $$Props["weekdayFormat"] = "short";

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<CalendarPrimitive.Root
	bind:value
	bind:placeholder
	{weekdayFormat}
	class={cn("p-3", className)}
	{...$$restProps}
	on:keydown
	let:months
	let:weekdays
>
	<Calendar.Header>
		<Calendar.PrevButton />
		<Calendar.Heading />
		<Calendar.NextButton />
	</Calendar.Header>
	<Calendar.Months>
		{#each months as month}
			<Calendar.Grid>
				<Calendar.GridHead>
					<Calendar.GridRow class="flex">
						{#each weekdays as weekday}
							<Calendar.HeadCell>
								{weekday.slice(0, 2)}
							</Calendar.HeadCell>
						{/each}
					</Calendar.GridRow>
				</Calendar.GridHead>
				<Calendar.GridBody>
					{#each month.weeks as weekDates}
						<Calendar.GridRow class="mt-2 w-full">
							{#each weekDates as date}
								<Calendar.Cell {date}>
									<Calendar.Day {date} month={month.value} />
								</Calendar.Cell>
							{/each}
						</Calendar.GridRow>
					{/each}
				</Calendar.GridBody>
			</Calendar.Grid>
		{/each}
	</Calendar.Months>
</CalendarPrimitive.Root>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/calendar/index.ts
```typescript
import Root from "./calendar.svelte";
import Cell from "./calendar-cell.svelte";
import Day from "./calendar-day.svelte";
import Grid from "./calendar-grid.svelte";
import Header from "./calendar-header.svelte";
import Months from "./calendar-months.svelte";
import GridRow from "./calendar-grid-row.svelte";
import Heading from "./calendar-heading.svelte";
import GridBody from "./calendar-grid-body.svelte";
import GridHead from "./calendar-grid-head.svelte";
import HeadCell from "./calendar-head-cell.svelte";
import NextButton from "./calendar-next-button.svelte";
import PrevButton from "./calendar-prev-button.svelte";

export {
	Day,
	Cell,
	Grid,
	Header,
	Months,
	GridRow,
	Heading,
	GridBody,
	GridHead,
	HeadCell,
	NextButton,
	PrevButton,
	//
	Root as Calendar,
};

```
