/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/sonner/Sonner.vue
```
<script lang="ts" setup>
import { type ToasterProps } from "vue-sonner";

const props = defineProps<ToasterProps>();
</script>

<template>
  <Sonner
    class="toaster group"
    v-bind="props"
    :toast-options="{
      classes: {
        toast: 'group toast group-[.toaster]:bg-background group-[.toaster]:text-foreground group-[.toaster]:border-border group-[.toaster]:shadow-lg',
        description: 'group-[.toast]:text-muted-foreground',
        actionButton:
          'group-[.toast]:bg-primary group-[.toast]:text-primary-foreground',
        cancelButton:
          'group-[.toast]:bg-muted group-[.toast]:text-muted-foreground',
      },
    }"
  />
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/sonner/index.ts
```typescript
export { default as Toaster } from "./Sonner.vue";

```
