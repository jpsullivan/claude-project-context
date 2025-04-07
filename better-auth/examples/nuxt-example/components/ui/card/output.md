/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/card/Card.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();
</script>

<template>
  <div
    :class="
      cn(
        'rounded-xl border bg-card text-card-foreground shadow',
        props.class,
      )
    "
  >
    <slot />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/card/CardContent.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();
</script>

<template>
  <div :class="cn('p-6 pt-0', props.class)">
    <slot />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/card/CardDescription.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();
</script>

<template>
  <p :class="cn('text-sm text-muted-foreground', props.class)">
    <slot />
  </p>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/card/CardFooter.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();
</script>

<template>
  <div :class="cn('flex items-center p-6 pt-0', props.class)">
    <slot />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/card/CardHeader.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();
</script>

<template>
  <div :class="cn('flex flex-col gap-y-1.5 p-6', props.class)">
    <slot />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/card/CardTitle.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();
</script>

<template>
  <h3
    :class="
      cn('font-semibold leading-none tracking-tight', props.class)
    "
  >
    <slot />
  </h3>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/card/index.ts
```typescript
export { default as Card } from "./Card.vue";
export { default as CardHeader } from "./CardHeader.vue";
export { default as CardTitle } from "./CardTitle.vue";
export { default as CardDescription } from "./CardDescription.vue";
export { default as CardContent } from "./CardContent.vue";
export { default as CardFooter } from "./CardFooter.vue";

```
