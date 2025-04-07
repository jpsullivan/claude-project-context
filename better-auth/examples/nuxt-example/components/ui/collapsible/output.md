/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/collapsible/Collapsible.vue
```
<script setup lang="ts">
import { useForwardPropsEmits } from "radix-vue";
import type { CollapsibleRootEmits, CollapsibleRootProps } from "radix-vue";

const props = defineProps<CollapsibleRootProps>();
const emits = defineEmits<CollapsibleRootEmits>();

const forwarded = useForwardPropsEmits(props, emits);
</script>

<template>
  <CollapsibleRoot v-slot="{ open }" v-bind="forwarded">
    <slot :open="open" />
  </CollapsibleRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/collapsible/CollapsibleContent.vue
```
<script setup lang="ts">
import { type CollapsibleContentProps } from "radix-vue";

const props = defineProps<CollapsibleContentProps>();
</script>

<template>
  <CollapsibleContent v-bind="props" class="overflow-hidden transition-all data-[state=closed]:animate-collapsible-up data-[state=open]:animate-collapsible-down">
    <slot />
  </CollapsibleContent>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/collapsible/CollapsibleTrigger.vue
```
<script setup lang="ts">
import { type CollapsibleTriggerProps } from "radix-vue";

const props = defineProps<CollapsibleTriggerProps>();
</script>

<template>
  <CollapsibleTrigger v-bind="props">
    <slot />
  </CollapsibleTrigger>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/collapsible/index.ts
```typescript
export { default as Collapsible } from "./Collapsible.vue";
export { default as CollapsibleTrigger } from "./CollapsibleTrigger.vue";
export { default as CollapsibleContent } from "./CollapsibleContent.vue";

```
