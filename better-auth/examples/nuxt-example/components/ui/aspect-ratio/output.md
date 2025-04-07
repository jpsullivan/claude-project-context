/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/aspect-ratio/AspectRatio.vue
```
<script setup lang="ts">
import { type AspectRatioProps } from "radix-vue";

const props = defineProps<AspectRatioProps>();
</script>

<template>
  <AspectRatio v-bind="props">
    <slot />
  </AspectRatio>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/aspect-ratio/index.ts
```typescript
export { default as AspectRatio } from "./AspectRatio.vue";

```
