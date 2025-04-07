/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/form/form-button.svelte
```
<script lang="ts">
import * as Button from "$lib/components/ui/button/index.js";

type $$Props = Button.Props;
type $$Events = Button.Events;
</script>

<Button.Root type="submit" on:click on:keydown {...$$restProps}>
	<slot />
</Button.Root>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/form/form-description.svelte
```
<script lang="ts">
import * as FormPrimitive from "formsnap";

type $$Props = FormPrimitive.DescriptionProps;
let className: $$Props["class"] = undefined;
export { className as class };
</script>

<FormPrimitive.Description
	class={cn("text-muted-foreground text-[0.8rem]", className)}
	{...$$restProps}
	let:descriptionAttrs
>
	<slot {descriptionAttrs} />
</FormPrimitive.Description>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/form/form-element-field.svelte
```
<script lang="ts" context="module">
import type { FormPathLeaves } from "sveltekit-superforms";
type T = Record<string, unknown>;
type U = FormPathLeaves<T>;
</script>

<script lang="ts" generics="T extends Record<string, unknown>, U extends FormPathLeaves<T>">
	import type { HTMLAttributes } from "svelte/elements";
	import * as FormPrimitive from "formsnap";
	import { cn } from "$lib/utils.js";

	type $$Props = FormPrimitive.ElementFieldProps<T, U> & HTMLAttributes<HTMLDivElement>;

	export let form: SuperForm<T>;
	export let name: U;

	let className: $$Props["class"] = undefined;
	export { className as class };
</script>

<FormPrimitive.ElementField {form} {name} let:constraints let:errors let:tainted let:value>
	<div class={cn("space-y-2", className)}>
		<slot {constraints} {errors} {tainted} {value} />
	</div>
</FormPrimitive.ElementField>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/form/form-field-errors.svelte
```
<script lang="ts">
import * as FormPrimitive from "formsnap";

type $$Props = FormPrimitive.FieldErrorsProps & {
	errorClasses?: string | undefined | null;
};

let className: $$Props["class"] = undefined;
export { className as class };
export let errorClasses: $$Props["class"] = undefined;
</script>

<FormPrimitive.FieldErrors
	class={cn("text-destructive text-[0.8rem] font-medium", className)}
	{...$$restProps}
	let:errors
	let:fieldErrorsAttrs
	let:errorAttrs
>
	<slot {errors} {fieldErrorsAttrs} {errorAttrs}>
		{#each errors as error}
			<div {...errorAttrs} class={cn(errorClasses)}>{error}</div>
		{/each}
	</slot>
</FormPrimitive.FieldErrors>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/form/form-field.svelte
```
<script lang="ts" context="module">
import type { FormPath } from "sveltekit-superforms";
type T = Record<string, unknown>;
type U = FormPath<T>;
</script>

<script lang="ts" generics="T extends Record<string, unknown>, U extends FormPath<T>">
	import type { HTMLAttributes } from "svelte/elements";
	import * as FormPrimitive from "formsnap";
	import { cn } from "$lib/utils.js";

	type $$Props = FormPrimitive.FieldProps<T, U> & HTMLAttributes<HTMLElement>;

	export let form: SuperForm<T>;
	export let name: U;

	let className: $$Props["class"] = undefined;
	export { className as class };
</script>

<FormPrimitive.Field {form} {name} let:constraints let:errors let:tainted let:value>
	<div class={cn("space-y-2", className)}>
		<slot {constraints} {errors} {tainted} {value} />
	</div>
</FormPrimitive.Field>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/form/form-fieldset.svelte
```
<script lang="ts" context="module">
import type { FormPath } from "sveltekit-superforms";
type T = Record<string, unknown>;
type U = FormPath<T>;
</script>

<script lang="ts" generics="T extends Record<string, unknown>, U extends FormPath<T>">
	import * as FormPrimitive from "formsnap";
	import { cn } from "$lib/utils.js";

	type $$Props = FormPrimitive.FieldsetProps<T, U>;

	export let form: SuperForm<T>;
	export let name: U;

	let className: $$Props["class"] = undefined;
	export { className as class };
</script>

<FormPrimitive.Fieldset
	{form}
	{name}
	let:constraints
	let:errors
	let:tainted
	let:value
	class={cn("space-y-2", className)}
>
	<slot {constraints} {errors} {tainted} {value} />
</FormPrimitive.Fieldset>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/form/form-label.svelte
```
<script lang="ts">
import type { Label as LabelPrimitive } from "bits-ui";
import { getFormControl } from "formsnap";

type $$Props = LabelPrimitive.Props;

let className: $$Props["class"] = undefined;
export { className as class };

const { labelAttrs } = getFormControl();
</script>

<Label {...$labelAttrs} class={cn("data-[fs-error]:text-destructive", className)} {...$$restProps}>
	<slot {labelAttrs} />
</Label>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/form/form-legend.svelte
```
<script lang="ts">
import * as FormPrimitive from "formsnap";

type $$Props = FormPrimitive.LegendProps;

let className: $$Props["class"] = undefined;
export { className as class };
</script>

<FormPrimitive.Legend
	{...$$restProps}
	class={cn("data-[fs-error]:text-destructive text-sm font-medium leading-none", className)}
	let:legendAttrs
>
	<slot {legendAttrs} />
</FormPrimitive.Legend>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/form/index.ts
```typescript
import * as FormPrimitive from "formsnap";
import Description from "./form-description.svelte";
import Label from "./form-label.svelte";
import FieldErrors from "./form-field-errors.svelte";
import Field from "./form-field.svelte";
import Button from "./form-button.svelte";
import Fieldset from "./form-fieldset.svelte";
import Legend from "./form-legend.svelte";
import ElementField from "./form-element-field.svelte";

const Control = FormPrimitive.Control;

export {
	Field,
	Control,
	Label,
	FieldErrors,
	Description,
	Fieldset,
	Legend,
	ElementField,
	Button,
	//
	Field as FormField,
	Control as FormControl,
	Description as FormDescription,
	Label as FormLabel,
	FieldErrors as FormFieldErrors,
	Fieldset as FormFieldset,
	Legend as FormLegend,
	ElementField as FormElementField,
	Button as FormButton,
};

```
