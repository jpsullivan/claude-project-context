/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/carousel/Carousel.vue
```
<script setup lang="ts">
import { useProvideCarousel } from "./useCarousel";
import type {
	CarouselEmits,
	CarouselProps,
	WithClassAsProps,
} from "./interface";

const props = withDefaults(defineProps<CarouselProps & WithClassAsProps>(), {
	orientation: "horizontal",
});

const emits = defineEmits<CarouselEmits>();

const {
	canScrollNext,
	canScrollPrev,
	carouselApi,
	carouselRef,
	orientation,
	scrollNext,
	scrollPrev,
} = useProvideCarousel(props, emits);

defineExpose({
	canScrollNext,
	canScrollPrev,
	carouselApi,
	carouselRef,
	orientation,
	scrollNext,
	scrollPrev,
});

function onKeyDown(event: KeyboardEvent) {
	const prevKey = props.orientation === "vertical" ? "ArrowUp" : "ArrowLeft";
	const nextKey = props.orientation === "vertical" ? "ArrowDown" : "ArrowRight";

	if (event.key === prevKey) {
		event.preventDefault();
		scrollPrev();

		return;
	}

	if (event.key === nextKey) {
		event.preventDefault();
		scrollNext();
	}
}
</script>

<template>
  <div
    :class="cn('relative', props.class)"
    role="region"
    aria-roledescription="carousel"
    tabindex="0"
    @keydown="onKeyDown"
  >
    <slot :can-scroll-next :can-scroll-prev :carousel-api :carousel-ref :orientation :scroll-next :scroll-prev />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/carousel/CarouselContent.vue
```
<script setup lang="ts">
import { useCarousel } from "./useCarousel";
import type { WithClassAsProps } from "./interface";

defineOptions({
	inheritAttrs: false,
});

const props = defineProps<WithClassAsProps>();

const { carouselRef, orientation } = useCarousel();
</script>

<template>
  <div ref="carouselRef" class="overflow-hidden">
    <div
      :class="
        cn(
          'flex',
          orientation === 'horizontal' ? '-ml-4' : '-mt-4 flex-col',
          props.class,
        )"
      v-bind="$attrs"
    >
      <slot />
    </div>
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/carousel/CarouselItem.vue
```
<script setup lang="ts">
import { useCarousel } from "./useCarousel";
import type { WithClassAsProps } from "./interface";

const props = defineProps<WithClassAsProps>();

const { orientation } = useCarousel();
</script>

<template>
  <div
    role="group"
    aria-roledescription="slide"
    :class="cn(
      'min-w-0 shrink-0 grow-0 basis-full',
      orientation === 'horizontal' ? 'pl-4' : 'pt-4',
      props.class,
    )"
  >
    <slot />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/carousel/CarouselNext.vue
```
<script setup lang="ts">
import { useCarousel } from "./useCarousel";
import type { WithClassAsProps } from "./interface";

const props = defineProps<WithClassAsProps>();

const { orientation, canScrollNext, scrollNext } = useCarousel();
</script>

<template>
  <Button
    :disabled="!canScrollNext"
    :class="cn(
      'touch-manipulation absolute h-8 w-8 rounded-full p-0',
      orientation === 'horizontal'
        ? '-right-12 top-1/2 -translate-y-1/2'
        : '-bottom-12 left-1/2 -translate-x-1/2 rotate-90',
      props.class,
    )"
    variant="outline"
    @click="scrollNext"
  >
    <slot>
      <ArrowRightIcon class="h-4 w-4 text-current" />
      <span class="sr-only">Next Slide</span>
    </slot>
  </Button>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/carousel/CarouselPrevious.vue
```
<script setup lang="ts">
import { useCarousel } from "./useCarousel";
import type { WithClassAsProps } from "./interface";

const props = defineProps<WithClassAsProps>();

const { orientation, canScrollPrev, scrollPrev } = useCarousel();
</script>

<template>
  <Button
    :disabled="!canScrollPrev"
    :class="cn(
      'touch-manipulation absolute h-8 w-8 rounded-full p-0',
      orientation === 'horizontal'
        ? '-left-12 top-1/2 -translate-y-1/2'
        : '-top-12 left-1/2 -translate-x-1/2 rotate-90',
      props.class,
    )"
    variant="outline"
    @click="scrollPrev"
  >
    <slot>
      <ArrowLeftIcon class="h-4 w-4 text-current" />
      <span class="sr-only">Previous Slide</span>
    </slot>
  </Button>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/carousel/index.ts
```typescript
export { default as Carousel } from "./Carousel.vue";
export { default as CarouselContent } from "./CarouselContent.vue";
export { default as CarouselItem } from "./CarouselItem.vue";
export { default as CarouselPrevious } from "./CarouselPrevious.vue";
export { default as CarouselNext } from "./CarouselNext.vue";
export { useCarousel } from "./useCarousel";

export type { UnwrapRefCarouselApi as CarouselApi } from "./interface";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/carousel/interface.ts
```typescript
import type { HTMLAttributes, UnwrapRef } from "vue";
import type useEmblaCarousel from "embla-carousel-vue";
import type { EmblaCarouselVueType } from "embla-carousel-vue";

type CarouselApi = EmblaCarouselVueType[1];
type UseCarouselParameters = Parameters<typeof useEmblaCarousel>;
type CarouselOptions = UseCarouselParameters[0];
type CarouselPlugin = UseCarouselParameters[1];

export type UnwrapRefCarouselApi = UnwrapRef<CarouselApi>;

export interface CarouselProps {
	opts?: CarouselOptions;
	plugins?: CarouselPlugin;
	orientation?: "horizontal" | "vertical";
}

export interface CarouselEmits {
	(e: "init-api", payload: UnwrapRefCarouselApi): void;
}

export interface WithClassAsProps {
	class?: HTMLAttributes["class"];
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/carousel/useCarousel.ts
```typescript
import { createInjectionState } from "@vueuse/core";
import emblaCarouselVue from "embla-carousel-vue";
import { onMounted, ref } from "vue";
import type {
	UnwrapRefCarouselApi as CarouselApi,
	CarouselEmits,
	CarouselProps,
} from "./interface";

const [useProvideCarousel, useInjectCarousel] = createInjectionState(
	({ opts, orientation, plugins }: CarouselProps, emits: CarouselEmits) => {
		const [emblaNode, emblaApi] = emblaCarouselVue(
			{
				...opts,
				axis: orientation === "horizontal" ? "x" : "y",
			},
			plugins,
		);

		function scrollPrev() {
			emblaApi.value?.scrollPrev();
		}
		function scrollNext() {
			emblaApi.value?.scrollNext();
		}

		const canScrollNext = ref(false);
		const canScrollPrev = ref(false);

		function onSelect(api: CarouselApi) {
			canScrollNext.value = api?.canScrollNext() || false;
			canScrollPrev.value = api?.canScrollPrev() || false;
		}

		onMounted(() => {
			if (!emblaApi.value) return;

			emblaApi.value?.on("init", onSelect);
			emblaApi.value?.on("reInit", onSelect);
			emblaApi.value?.on("select", onSelect);

			emits("init-api", emblaApi.value);
		});

		return {
			carouselRef: emblaNode,
			carouselApi: emblaApi,
			canScrollPrev,
			canScrollNext,
			scrollPrev,
			scrollNext,
			orientation,
		};
	},
);

function useCarousel() {
	const carouselState = useInjectCarousel();

	if (!carouselState)
		throw new Error("useCarousel must be used within a <Carousel />");

	return carouselState;
}

export { useCarousel, useProvideCarousel };

```
