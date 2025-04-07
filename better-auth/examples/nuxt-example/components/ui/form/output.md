/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/form/FormControl.vue
```
<script lang="ts" setup>
import { useFormField } from "./useFormField";

const { error, formItemId, formDescriptionId, formMessageId } = useFormField();
</script>

<template>
  <Slot
    :id="formItemId"
    :aria-describedby="!error ? `${formDescriptionId}` : `${formDescriptionId} ${formMessageId}`"
    :aria-invalid="!!error"
  >
    <slot />
  </Slot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/form/FormDescription.vue
```
<script lang="ts" setup>
import type { HTMLAttributes } from "vue";
import { useFormField } from "./useFormField";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();

const { formDescriptionId } = useFormField();
</script>

<template>
  <p
    :id="formDescriptionId"
    :class="cn('text-sm text-muted-foreground', props.class)"
  >
    <slot />
  </p>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/form/FormItem.vue
```
<script lang="ts" setup>
import { type HTMLAttributes, provide } from "vue";
import { useId } from "radix-vue";
import { FORM_ITEM_INJECTION_KEY } from "./injectionKeys";

const props = defineProps<{
	class?: HTMLAttributes["class"];
}>();

const id = useId();
provide(FORM_ITEM_INJECTION_KEY, id);
</script>

<template>
  <div :class="cn('space-y-2', props.class)">
    <slot />
  </div>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/form/FormLabel.vue
```
<script lang="ts" setup>
import type { HTMLAttributes } from "vue";
import type { LabelProps } from "radix-vue";
import { useFormField } from "./useFormField";

const props = defineProps<LabelProps & { class?: HTMLAttributes["class"] }>();

const { error, formItemId } = useFormField();
</script>

<template>
  <Label
    :class="cn(
      error && 'text-destructive',
      props.class,
    )"
    :for="formItemId"
  >
    <slot />
  </Label>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/form/FormMessage.vue
```
<script lang="ts" setup>
import { useFormField } from "./useFormField";

const { name, formMessageId } = useFormField();
</script>

<template>
  <ErrorMessage
    :id="formMessageId"
    as="p"
    :name="toValue(name)"
    class="text-[0.8rem] font-medium text-destructive"
  />
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/form/index.ts
```typescript
export {
	Form,
	Field as FormField,
	FieldArray as FormFieldArray,
} from "vee-validate";
export { default as FormItem } from "./FormItem.vue";
export { default as FormLabel } from "./FormLabel.vue";
export { default as FormControl } from "./FormControl.vue";
export { default as FormMessage } from "./FormMessage.vue";
export { default as FormDescription } from "./FormDescription.vue";
export { FORM_ITEM_INJECTION_KEY } from "./injectionKeys";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/form/injectionKeys.ts
```typescript
import type { InjectionKey } from "vue";

export const FORM_ITEM_INJECTION_KEY = Symbol() as InjectionKey<string>;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/form/useFormField.ts
```typescript
import {
	FieldContextKey,
	useFieldError,
	useIsFieldDirty,
	useIsFieldTouched,
	useIsFieldValid,
} from "vee-validate";
import { inject } from "vue";
import { FORM_ITEM_INJECTION_KEY } from "./injectionKeys";

export function useFormField() {
	const fieldContext = inject(FieldContextKey);
	const fieldItemContext = inject(FORM_ITEM_INJECTION_KEY);

	if (!fieldContext)
		throw new Error("useFormField should be used within <FormField>");

	const { name } = fieldContext;
	const id = fieldItemContext;

	const fieldState = {
		valid: useIsFieldValid(name),
		isDirty: useIsFieldDirty(name),
		isTouched: useIsFieldTouched(name),
		error: useFieldError(name),
	};

	return {
		id,
		name,
		formItemId: `${id}-form-item`,
		formDescriptionId: `${id}-form-item-description`,
		formMessageId: `${id}-form-item-message`,
		...fieldState,
	};
}

```
