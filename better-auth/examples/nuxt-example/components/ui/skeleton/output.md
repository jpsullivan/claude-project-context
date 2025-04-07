/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/skeleton/Skeleton.vue
```
<script setup lang="ts">
import type { HTMLAttributes } from "vue";

interface SkeletonProps {
	class?: HTMLAttributes["class"];
}

const props = defineProps<SkeletonProps>();
</script>

<template>
  <div :class="cn('animate-pulse rounded-md bg-primary/10', props.class)" />
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/skeleton/index.ts
```typescript
export { default as Skeleton } from "./Skeleton.vue";

```
