/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/carousel/carousel-content.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";
import { getEmblaContext } from "./context.js";

type $$Props = HTMLAttributes<HTMLDivElement>;

let className: string | undefined | null = undefined;
export { className as class };

const { orientation, options, plugins, onInit } = getEmblaContext(
	"<Carousel.Content/>",
);
</script>

<div
	class="overflow-hidden"
	use:emblaCarouselSvelte={{
		options: {
			container: "[data-embla-container]",
			slides: "[data-embla-slide]",
			...$options,
			axis: $orientation === "horizontal" ? "x" : "y",
		},
		plugins: $plugins,
	}}
	on:emblaInit={onInit}
>
	<div
		class={cn("flex", $orientation === "horizontal" ? "-ml-4" : "-mt-4 flex-col", className)}
		data-embla-container=""
		{...$$restProps}
	>
		<slot />
	</div>
</div>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/carousel/carousel-item.svelte
```
<script lang="ts">
import type { HTMLAttributes } from "svelte/elements";
import { getEmblaContext } from "./context.js";

type $$Props = HTMLAttributes<HTMLDivElement>;
let className: string | undefined | null = undefined;
export { className as class };

const { orientation } = getEmblaContext("<Carousel.Item/>");
</script>

<div
	role="group"
	aria-roledescription="slide"
	class={cn(
		"min-w-0 shrink-0 grow-0 basis-full",
		$orientation === "horizontal" ? "pl-4" : "pt-4",
		className
	)}
	data-embla-slide=""
	{...$$restProps}
>
	<slot />
</div>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/carousel/carousel-next.svelte
```
<script lang="ts">
import type { VariantProps } from "tailwind-variants";
import { getEmblaContext } from "./context.js";
import {
	type Props,
	type buttonVariants,
} from "$lib/components/ui/button/index.js";

type $$Props = Props;

let className: $$Props["class"] = undefined;
export { className as class };
export let variant: VariantProps<typeof buttonVariants>["variant"] = "outline";
export let size: VariantProps<typeof buttonVariants>["size"] = "icon";

const { orientation, canScrollNext, scrollNext, handleKeyDown } =
	getEmblaContext("<Carousel.Next/>");
</script>

<Button
	{variant}
	{size}
	class={cn(
		"absolute h-8 w-8 touch-manipulation rounded-full",
		$orientation === "horizontal"
			? "-right-12 top-1/2 -translate-y-1/2"
			: "-bottom-12 left-1/2 -translate-x-1/2 rotate-90",
		className
	)}
	disabled={!$canScrollNext}
	on:click={scrollNext}
	on:keydown={handleKeyDown}
	{...$$restProps}
>
	<ArrowRight class="h-4 w-4" />
	<span class="sr-only">Next slide</span>
</Button>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/carousel/carousel-previous.svelte
```
<script lang="ts">
import type { VariantProps } from "tailwind-variants";
import { getEmblaContext } from "./context.js";
import {
	type Props,
	type buttonVariants,
} from "$lib/components/ui/button/index.js";

type $$Props = Props;

let className: $$Props["class"] = undefined;
export { className as class };
export let variant: VariantProps<typeof buttonVariants>["variant"] = "outline";
export let size: VariantProps<typeof buttonVariants>["size"] = "icon";

const { orientation, canScrollPrev, scrollPrev, handleKeyDown } =
	getEmblaContext("<Carousel.Previous/>");
</script>

<Button
	{variant}
	{size}
	class={cn(
		"absolute h-8 w-8 touch-manipulation rounded-full",
		$orientation === "horizontal"
			? "-left-12 top-1/2 -translate-y-1/2"
			: "-top-12 left-1/2 -translate-x-1/2 rotate-90",
		className
	)}
	disabled={!$canScrollPrev}
	on:click={scrollPrev}
	on:keydown={handleKeyDown}
	{...$$restProps}
>
	<ArrowLeft class="h-4 w-4" />
	<span class="sr-only">Previous slide</span>
</Button>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/carousel/carousel.svelte
```
<script lang="ts">
import { writable } from "svelte/store";
import { onDestroy } from "svelte";
import {
	type CarouselAPI,
	type CarouselProps,
	setEmblaContext,
} from "./context.js";

type $$Props = CarouselProps;

export let opts = {};
export let plugins: NonNullable<$$Props["plugins"]> = [];
export let api: $$Props["api"] = undefined;
export let orientation: NonNullable<$$Props["orientation"]> = "horizontal";

let className: $$Props["class"] = undefined;
export { className as class };

const apiStore = writable<CarouselAPI | undefined>(undefined);
const orientationStore = writable(orientation);
const canScrollPrev = writable(false);
const canScrollNext = writable(false);
const optionsStore = writable(opts);
const pluginStore = writable(plugins);
const scrollSnapsStore = writable<number[]>([]);
const selectedIndexStore = writable(0);

$: orientationStore.set(orientation);
$: pluginStore.set(plugins);
$: optionsStore.set(opts);

function scrollPrev() {
	api?.scrollPrev();
}
function scrollNext() {
	api?.scrollNext();
}
function scrollTo(index: number, jump?: boolean) {
	api?.scrollTo(index, jump);
}

function onSelect(api: CarouselAPI) {
	if (!api) return;
	canScrollPrev.set(api.canScrollPrev());
	canScrollNext.set(api.canScrollNext());
}

$: if (api) {
	onSelect(api);
	api.on("select", onSelect);
	api.on("reInit", onSelect);
}

function handleKeyDown(e: KeyboardEvent) {
	if (e.key === "ArrowLeft") {
		e.preventDefault();
		scrollPrev();
	} else if (e.key === "ArrowRight") {
		e.preventDefault();
		scrollNext();
	}
}

setEmblaContext({
	api: apiStore,
	scrollPrev,
	scrollNext,
	orientation: orientationStore,
	canScrollNext,
	canScrollPrev,
	handleKeyDown,
	options: optionsStore,
	plugins: pluginStore,
	onInit,
	scrollSnaps: scrollSnapsStore,
	selectedIndex: selectedIndexStore,
	scrollTo,
});

function onInit(event: CustomEvent<CarouselAPI>) {
	api = event.detail;
	apiStore.set(api);
	scrollSnapsStore.set(api.scrollSnapList());
}

onDestroy(() => {
	api?.off("select", onSelect);
});
</script>

<div
	class={cn("relative", className)}
	on:mouseenter
	on:mouseleave
	role="region"
	aria-roledescription="carousel"
	{...$$restProps}
>
	<slot />
</div>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/carousel/context.ts
```typescript
import type { EmblaCarouselSvelteType } from "embla-carousel-svelte";
import type emblaCarouselSvelte from "embla-carousel-svelte";
import { getContext, hasContext, setContext } from "svelte";
import type { HTMLAttributes } from "svelte/elements";
import type { Readable, Writable } from "svelte/store";

export type CarouselAPI = NonNullable<
	NonNullable<EmblaCarouselSvelteType["$$_attributes"]>["on:emblaInit"]
> extends (evt: CustomEvent<infer CarouselAPI>) => void
	? CarouselAPI
	: never;

type EmblaCarouselConfig = NonNullable<
	Parameters<typeof emblaCarouselSvelte>[1]
>;

export type CarouselOptions = EmblaCarouselConfig["options"];
export type CarouselPlugins = EmblaCarouselConfig["plugins"];

////

export type CarouselProps = {
	opts?: CarouselOptions;
	plugins?: CarouselPlugins;
	api?: CarouselAPI;
	orientation?: "horizontal" | "vertical";
} & HTMLAttributes<HTMLDivElement>;

const EMBLA_CAROUSEL_CONTEXT = Symbol("EMBLA_CAROUSEL_CONTEXT");

type EmblaContext = {
	api: Writable<CarouselAPI | undefined>;
	orientation: Writable<"horizontal" | "vertical">;
	scrollNext: () => void;
	scrollPrev: () => void;
	canScrollNext: Readable<boolean>;
	canScrollPrev: Readable<boolean>;
	handleKeyDown: (e: KeyboardEvent) => void;
	options: Writable<CarouselOptions>;
	plugins: Writable<CarouselPlugins>;
	onInit: (e: CustomEvent<CarouselAPI>) => void;
	scrollTo: (index: number, jump?: boolean) => void;
	scrollSnaps: Readable<number[]>;
	selectedIndex: Readable<number>;
};

export function setEmblaContext(config: EmblaContext): EmblaContext {
	setContext(EMBLA_CAROUSEL_CONTEXT, config);
	return config;
}

export function getEmblaContext(name = "This component") {
	if (!hasContext(EMBLA_CAROUSEL_CONTEXT)) {
		throw new Error(`${name} must be used within a <Carousel.Root> component`);
	}
	return getContext<ReturnType<typeof setEmblaContext>>(EMBLA_CAROUSEL_CONTEXT);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/carousel/index.ts
```typescript
export { default as Root } from "./carousel.svelte";
export { default as Content } from "./carousel-content.svelte";
export { default as Item } from "./carousel-item.svelte";
export { default as Previous } from "./carousel-previous.svelte";
export { default as Next } from "./carousel-next.svelte";

```
