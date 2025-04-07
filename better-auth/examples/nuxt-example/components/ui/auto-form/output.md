/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/AutoForm.vue
```
<script setup lang="ts" generic="T extends ZodObjectOrWrapped">
import { computed, toRefs } from "vue";
import type { ZodAny, z } from "zod";
import { toTypedSchema } from "@vee-validate/zod";
import type { FormContext, GenericObject } from "vee-validate";
import {
	getBaseSchema,
	getBaseType,
	getDefaultValueInZodStack,
	getObjectFormSchema,
} from "./utils";
import type { Config, ConfigItem, Dependency, Shape } from "./interface";
import { provideDependencies } from "./dependencies";
import { Form } from "@/components/ui/form";

const props = defineProps<{
	schema: T;
	form?: FormContext<GenericObject>;
	fieldConfig?: Config<z.infer<T>>;
	dependencies?: Dependency<z.infer<T>>[];
}>();

const emits = defineEmits<{
	submit: [event: z.infer<T>];
}>();

const { dependencies } = toRefs(props);
provideDependencies(dependencies);

const shapes = computed(() => {
	// @ts-expect-error ignore {} not assignable to object
	const val: { [key in keyof T]: Shape } = {};
	const baseSchema = getObjectFormSchema(props.schema);
	const shape = baseSchema.shape;
	Object.keys(shape).forEach((name) => {
		const item = shape[name] as ZodAny;
		const baseItem = getBaseSchema(item) as ZodAny;
		let options =
			baseItem && "values" in baseItem._def
				? (baseItem._def.values as string[])
				: undefined;
		if (!Array.isArray(options) && typeof options === "object")
			options = Object.values(options);

		val[name as keyof T] = {
			type: getBaseType(item),
			default: getDefaultValueInZodStack(item),
			options,
			required: !["ZodOptional", "ZodNullable"].includes(item._def.typeName),
			schema: baseItem,
		};
	});
	return val;
});

const fields = computed(() => {
	// @ts-expect-error ignore {} not assignable to object
	const val: {
		[key in keyof z.infer<T>]: {
			shape: Shape;
			fieldName: string;
			config: ConfigItem;
		};
	} = {};
	for (const key in shapes.value) {
		const shape = shapes.value[key];
		val[key as keyof z.infer<T>] = {
			shape,
			config: props.fieldConfig?.[key] as ConfigItem,
			fieldName: key,
		};
	}
	return val;
});

const formComponent = computed(() => (props.form ? "form" : Form));
const formComponentProps = computed(() => {
	if (props.form) {
		return {
			onSubmit: props.form.handleSubmit((val) => emits("submit", val)),
		};
	} else {
		const formSchema = toTypedSchema(props.schema);
		return {
			keepValues: true,
			validationSchema: formSchema,
			onSubmit: (val: GenericObject) => emits("submit", val),
		};
	}
});
</script>

<template>
  <component
    :is="formComponent"
    v-bind="formComponentProps"
  >
    <slot name="customAutoForm" :fields="fields">
      <template v-for="(shape, key) of shapes" :key="key">
        <slot
          :shape="shape"
          :name="key.toString() as keyof z.infer<T>"
          :field-name="key.toString()"
          :config="fieldConfig?.[key as keyof typeof fieldConfig] as ConfigItem"
        >
          <AutoFormField
            :config="fieldConfig?.[key as keyof typeof fieldConfig] as ConfigItem"
            :field-name="key.toString()"
            :shape="shape"
          />
        </slot>
      </template>
    </slot>

    <slot :shapes="shapes" />
  </component>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/AutoFormField.vue
```
<script setup lang="ts" generic="U extends ZodAny">
import { computed } from "vue";
import type { Config, ConfigItem, Shape } from "./interface";
import useDependencies from "./dependencies";

const props = defineProps<{
	fieldName: string;
	shape: Shape;
	config?: ConfigItem | Config<U>;
}>();

function isValidConfig(config: any): config is ConfigItem {
	return !!config?.component;
}

const delegatedProps = computed(() => {
	if (["ZodObject", "ZodArray"].includes(props.shape?.type))
		return { schema: props.shape?.schema };
	return undefined;
});

const { isDisabled, isHidden, isRequired, overrideOptions } = useDependencies(
	props.fieldName,
);
</script>

<template>
  <component
    :is="isValidConfig(config)
      ? typeof config.component === 'string'
        ? INPUT_COMPONENTS[config.component!]
        : config.component
      : INPUT_COMPONENTS[DEFAULT_ZOD_HANDLERS[shape.type]] "
    v-if="!isHidden"
    :field-name="fieldName"
    :label="shape.schema?.description"
    :required="isRequired || shape.required"
    :options="overrideOptions || shape.options"
    :disabled="isDisabled"
    :config="config"
    v-bind="delegatedProps"
  >
    <slot />
  </component>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/AutoFormFieldArray.vue
```
<script setup lang="ts" generic="T extends z.ZodAny">
import * as z from "zod";
import { computed, provide } from "vue";
import { FieldContextKey, useField } from "vee-validate";
import type { Config } from "./interface";
import { getBaseType } from "./utils";

const props = defineProps<{
	fieldName: string;
	required?: boolean;
	config?: Config<T>;
	schema?: z.ZodArray<T>;
	disabled?: boolean;
}>();

function isZodArray(
	item: z.ZodArray<any> | z.ZodDefault<any>,
): item is z.ZodArray<any> {
	return item instanceof z.ZodArray;
}

function isZodDefault(
	item: z.ZodArray<any> | z.ZodDefault<any>,
): item is z.ZodDefault<any> {
	return item instanceof z.ZodDefault;
}

const itemShape = computed(() => {
	if (!props.schema) return;

	const schema: z.ZodAny = isZodArray(props.schema)
		? props.schema._def.type
		: isZodDefault(props.schema)
			? // @ts-expect-error missing schema
				props.schema._def.innerType._def.type
			: null;

	return {
		type: getBaseType(schema),
		schema,
	};
});

const fieldContext = useField(props.fieldName);
// @ts-expect-error ignore missing `id`
provide(FieldContextKey, fieldContext);
</script>

<template>
  <FieldArray v-slot="{ fields, remove, push }" as="section" :name="fieldName">
    <slot v-bind="props">
      <Accordion type="multiple" class="w-full" collapsible :disabled="disabled" as-child>
        <FormItem>
          <AccordionItem :value="fieldName" class="border-none">
            <AccordionTrigger>
              <AutoFormLabel class="text-base" :required="required">
                {{ schema?.description || beautifyObjectName(fieldName) }}
              </AutoFormLabel>
            </AccordionTrigger>

            <AccordionContent>
              <template v-for="(field, index) of fields" :key="field.key">
                <div class="mb-4 p-1">
                  <AutoFormField
                    :field-name="`${fieldName}[${index}]`"
                    :label="fieldName"
                    :shape="itemShape!"
                    :config="config as ConfigItem"
                  />

                  <div class="!my-4 flex justify-end">
                    <Button
                      type="button"
                      size="icon"
                      variant="secondary"
                      @click="remove(index)"
                    >
                      <TrashIcon :size="16" />
                    </Button>
                  </div>
                  <Separator v-if="!field.isLast" />
                </div>
              </template>

              <Button
                type="button"
                variant="secondary"
                class="mt-4 flex items-center"
                @click="push(null)"
              >
                <PlusIcon class="mr-2" :size="16" />
                Add
              </Button>
            </AccordionContent>

            <FormMessage />
          </AccordionItem>
        </FormItem>
      </Accordion>
    </slot>
  </FieldArray>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/AutoFormFieldBoolean.vue
```
<script setup lang="ts">
import { computed } from "vue";
import type { FieldProps } from "./interface";
import { Switch } from "@/components/ui/switch";
import { Checkbox } from "@/components/ui/checkbox";

const props = defineProps<FieldProps>();

const booleanComponent = computed(() =>
	props.config?.component === "switch" ? Switch : Checkbox,
);
</script>

<template>
  <FormField v-slot="slotProps" :name="fieldName">
    <FormItem>
      <div class="space-y-0 mb-3 flex items-center gap-3">
        <FormControl>
          <slot v-bind="slotProps">
            <component
              :is="booleanComponent"
              v-bind="{ ...slotProps.componentField }"
              :disabled="disabled"
              :checked="slotProps.componentField.modelValue"
              @update:checked="slotProps.componentField['onUpdate:modelValue']"
            />
          </slot>
        </FormControl>
        <AutoFormLabel v-if="!config?.hideLabel" :required="required">
          {{ config?.label || beautifyObjectName(label ?? fieldName) }}
        </AutoFormLabel>
      </div>

      <FormDescription v-if="config?.description">
        {{ config.description }}
      </FormDescription>
      <FormMessage />
    </FormItem>
  </FormField>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/AutoFormFieldDate.vue
```
<script setup lang="ts">
import { DateFormatter } from "@internationalized/date";
import type { FieldProps } from "./interface";

defineProps<FieldProps>();

const df = new DateFormatter("en-US", {
	dateStyle: "long",
});
</script>

<template>
  <FormField v-slot="slotProps" :name="fieldName">
    <FormItem>
      <AutoFormLabel v-if="!config?.hideLabel" :required="required">
        {{ config?.label || beautifyObjectName(label ?? fieldName) }}
      </AutoFormLabel>
      <FormControl>
        <slot v-bind="slotProps">
          <div>
            <Popover>
              <PopoverTrigger as-child :disabled="disabled">
                <Button
                  variant="outline"
                  :class="cn(
                    'w-full justify-start text-left font-normal',
                    !slotProps.componentField.modelValue && 'text-muted-foreground',
                  )"
                >
                  <CalendarIcon class="mr-2 h-4 w-4" />
                  {{ slotProps.componentField.modelValue ? df.format(slotProps.componentField.modelValue.toDate(getLocalTimeZone())) : "Pick a date" }}
                </Button>
              </PopoverTrigger>
              <PopoverContent class="w-auto p-0">
                <Calendar initial-focus v-bind="slotProps.componentField" />
              </PopoverContent>
            </Popover>
          </div>
        </slot>
      </FormControl>

      <FormDescription v-if="config?.description">
        {{ config.description }}
      </FormDescription>
      <FormMessage />
    </FormItem>
  </FormField>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/AutoFormFieldEnum.vue
```
<script setup lang="ts">
import type { FieldProps } from "./interface";

defineProps<
	FieldProps & {
		options?: string[];
	}
>();
</script>

<template>
  <FormField v-slot="slotProps" :name="fieldName">
    <FormItem>
      <AutoFormLabel v-if="!config?.hideLabel" :required="required">
        {{ config?.label || beautifyObjectName(label ?? fieldName) }}
      </AutoFormLabel>
      <FormControl>
        <slot v-bind="slotProps">
          <RadioGroup v-if="config?.component === 'radio'" :disabled="disabled" :orientation="'vertical'" v-bind="{ ...slotProps.componentField }">
            <div v-for="(option, index) in options" :key="option" class="mb-2 flex items-center gap-3 space-y-0">
              <RadioGroupItem :id="`${option}-${index}`" :value="option" />
              <Label :for="`${option}-${index}`">{{ beautifyObjectName(option) }}</Label>
            </div>
          </RadioGroup>

          <Select v-else :disabled="disabled" v-bind="{ ...slotProps.componentField }">
            <SelectTrigger class="w-full">
              <SelectValue :placeholder="config?.inputProps?.placeholder" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem v-for="option in options" :key="option" :value="option">
                {{ beautifyObjectName(option) }}
              </SelectItem>
            </SelectContent>
          </Select>
        </slot>
      </FormControl>

      <FormDescription v-if="config?.description">
        {{ config.description }}
      </FormDescription>
      <FormMessage />
    </FormItem>
  </FormField>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/AutoFormFieldFile.vue
```
<script setup lang="ts">
import { ref } from "vue";
import type { FieldProps } from "./interface";

defineProps<FieldProps>();

const inputFile = ref<File>();
async function parseFileAsString(file: File | undefined): Promise<string> {
	return new Promise((resolve, reject) => {
		if (file) {
			const reader = new FileReader();
			reader.onloadend = () => {
				resolve(reader.result as string);
			};
			reader.onerror = (err) => {
				reject(err);
			};
			reader.readAsDataURL(file);
		}
	});
}
</script>

<template>
  <FormField v-slot="slotProps" :name="fieldName">
    <FormItem v-bind="$attrs">
      <AutoFormLabel v-if="!config?.hideLabel" :required="required">
        {{ config?.label || beautifyObjectName(label ?? fieldName) }}
      </AutoFormLabel>
      <FormControl>
        <slot v-bind="slotProps">
          <Input
            v-if="!inputFile"
            type="file"
            v-bind="{ ...config?.inputProps }"
            :disabled="disabled"
            @change="async (ev: InputEvent) => {
              const file = (ev.target as HTMLInputElement).files?.[0]
              inputFile = file
              const parsed = await parseFileAsString(file)
              slotProps.componentField.onInput(parsed)
            }"
          />
          <div v-else class="flex h-9 w-full items-center justify-between rounded-md border border-input bg-transparent pl-3 pr-1 py-1 text-sm shadow-sm transition-colors">
            <p>{{ inputFile?.name }}</p>
            <Button
              :size="'icon'"
              :variant="'ghost'"
              class="h-[26px] w-[26px]"
              aria-label="Remove file"
              type="button"
              @click="() => {
                inputFile = undefined
                slotProps.componentField.onInput(undefined)
              }"
            >
              <TrashIcon />
            </Button>
          </div>
        </slot>
      </FormControl>
      <FormDescription v-if="config?.description">
        {{ config.description }}
      </FormDescription>
      <FormMessage />
    </FormItem>
  </FormField>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/AutoFormFieldInput.vue
```
<script setup lang="ts">
import { computed } from "vue";
import type { FieldProps } from "./interface";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";

const props = defineProps<FieldProps>();
const inputComponent = computed(() =>
	props.config?.component === "textarea" ? Textarea : Input,
);
</script>

<template>
  <FormField v-slot="slotProps" :name="fieldName">
    <FormItem v-bind="$attrs">
      <AutoFormLabel v-if="!config?.hideLabel" :required="required">
        {{ config?.label || beautifyObjectName(label ?? fieldName) }}
      </AutoFormLabel>
      <FormControl>
        <slot v-bind="slotProps">
          <component
            :is="inputComponent"
            type="text"
            v-bind="{ ...slotProps.componentField, ...config?.inputProps }"
            :disabled="disabled"
          />
        </slot>
      </FormControl>
      <FormDescription v-if="config?.description">
        {{ config.description }}
      </FormDescription>
      <FormMessage />
    </FormItem>
  </FormField>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/AutoFormFieldNumber.vue
```
<script setup lang="ts">
import type { FieldProps } from "./interface";

defineOptions({
	inheritAttrs: false,
});

defineProps<FieldProps>();
</script>

<template>
  <FormField v-slot="slotProps" :name="fieldName">
    <FormItem>
      <AutoFormLabel v-if="!config?.hideLabel" :required="required">
        {{ config?.label || beautifyObjectName(label ?? fieldName) }}
      </AutoFormLabel>
      <FormControl>
        <slot v-bind="slotProps">
          <Input type="number" v-bind="{ ...slotProps.componentField, ...config?.inputProps }" :disabled="disabled" />
        </slot>
      </FormControl>
      <FormDescription v-if="config?.description">
        {{ config.description }}
      </FormDescription>
      <FormMessage />
    </FormItem>
  </FormField>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/AutoFormFieldObject.vue
```
<script setup lang="ts" generic="T extends ZodRawShape">
import type { ZodAny, ZodObject } from "zod";
import { computed, provide } from "vue";
import { FieldContextKey, useField } from "vee-validate";
import type { Config, Shape } from "./interface";
import { getBaseSchema, getBaseType, getDefaultValueInZodStack } from "./utils";

const props = defineProps<{
	fieldName: string;
	required?: boolean;
	config?: Config<T>;
	schema?: ZodObject<T>;
	disabled?: boolean;
}>();

const shapes = computed(() => {
	// @ts-expect-error ignore {} not assignable to object
	const val: { [key in keyof T]: Shape } = {};

	if (!props.schema) return;
	const shape = getBaseSchema(props.schema)?.shape;
	if (!shape) return;
	Object.keys(shape).forEach((name) => {
		const item = shape[name] as ZodAny;
		const baseItem = getBaseSchema(item) as ZodAny;
		let options =
			baseItem && "values" in baseItem._def
				? (baseItem._def.values as string[])
				: undefined;
		if (!Array.isArray(options) && typeof options === "object")
			options = Object.values(options);

		val[name as keyof T] = {
			type: getBaseType(item),
			default: getDefaultValueInZodStack(item),
			options,
			required: !["ZodOptional", "ZodNullable"].includes(item._def.typeName),
			schema: item,
		};
	});
	return val;
});

const fieldContext = useField(props.fieldName);
// @ts-expect-error ignore missing `id`
provide(FieldContextKey, fieldContext);
</script>

<template>
  <section>
    <slot v-bind="props">
      <Accordion type="single" as-child class="w-full" collapsible :disabled="disabled">
        <FormItem>
          <AccordionItem :value="fieldName" class="border-none">
            <AccordionTrigger>
              <AutoFormLabel class="text-base" :required="required">
                {{ schema?.description || beautifyObjectName(fieldName) }}
              </AutoFormLabel>
            </AccordionTrigger>
            <AccordionContent class="p-1 space-y-5">
              <template v-for="(shape, key) in shapes" :key="key">
                <AutoFormField
                  :config="config?.[key as keyof typeof config] as ConfigItem"
                  :field-name="`${fieldName}.${key.toString()}`"
                  :label="key.toString()"
                  :shape="shape"
                />
              </template>
            </AccordionContent>
          </AccordionItem>
        </FormItem>
      </Accordion>
    </slot>
  </section>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/AutoFormLabel.vue
```
<script setup lang="ts">
defineProps<{
	required?: boolean;
}>();
</script>

<template>
  <FormLabel>
    <slot />
    <span v-if="required" class="text-destructive"> *</span>
  </FormLabel>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/constant.ts
```typescript
import AutoFormFieldArray from "./AutoFormFieldArray.vue";
import AutoFormFieldBoolean from "./AutoFormFieldBoolean.vue";
import AutoFormFieldDate from "./AutoFormFieldDate.vue";
import AutoFormFieldEnum from "./AutoFormFieldEnum.vue";
import AutoFormFieldFile from "./AutoFormFieldFile.vue";
import AutoFormFieldInput from "./AutoFormFieldInput.vue";
import AutoFormFieldNumber from "./AutoFormFieldNumber.vue";
import AutoFormFieldObject from "./AutoFormFieldObject.vue";

export const INPUT_COMPONENTS = {
	date: AutoFormFieldDate,
	select: AutoFormFieldEnum,
	radio: AutoFormFieldEnum,
	checkbox: AutoFormFieldBoolean,
	switch: AutoFormFieldBoolean,
	textarea: AutoFormFieldInput,
	number: AutoFormFieldNumber,
	string: AutoFormFieldInput,
	file: AutoFormFieldFile,
	array: AutoFormFieldArray,
	object: AutoFormFieldObject,
};

/**
 * Define handlers for specific Zod types.
 * You can expand this object to support more types.
 */
export const DEFAULT_ZOD_HANDLERS: {
	[key: string]: keyof typeof INPUT_COMPONENTS;
} = {
	ZodString: "string",
	ZodBoolean: "checkbox",
	ZodDate: "date",
	ZodEnum: "select",
	ZodNativeEnum: "select",
	ZodNumber: "number",
	ZodArray: "array",
	ZodObject: "object",
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/dependencies.ts
```typescript
import type * as z from "zod";
import type { Ref } from "vue";
import { computed, ref, watch } from "vue";
import { useFieldValue, useFormValues } from "vee-validate";
import { createContext } from "radix-vue";
import { type Dependency, DependencyType, type EnumValues } from "./interface";
import { getFromPath, getIndexIfArray } from "./utils";

export const [injectDependencies, provideDependencies] = createContext<
	Ref<Dependency<z.infer<z.ZodObject<any>>>[] | undefined>
>("AutoFormDependencies");

export default function useDependencies(fieldName: string) {
	const form = useFormValues();
	// parsed test[0].age => test.age
	const currentFieldName = fieldName.replace(/\[\d+\]/g, "");
	const currentFieldValue = useFieldValue<any>(fieldName);

	if (!form)
		throw new Error("useDependencies should be used within <AutoForm>");

	const dependencies = injectDependencies();
	const isDisabled = ref(false);
	const isHidden = ref(false);
	const isRequired = ref(false);
	const overrideOptions = ref<EnumValues | undefined>();

	const currentFieldDependencies = computed(() =>
		dependencies.value?.filter(
			(dependency) => dependency.targetField === currentFieldName,
		),
	);

	function getSourceValue(dep: Dependency<any>) {
		const source = dep.sourceField as string;
		const index = getIndexIfArray(fieldName) ?? -1;
		const [sourceLast, ...sourceInitial] = source.split(".").toReversed();
		const [_targetLast, ...targetInitial] = (dep.targetField as string)
			.split(".")
			.toReversed();

		if (index >= 0 && sourceInitial.join(",") === targetInitial.join(",")) {
			const [_currentLast, ...currentInitial] = fieldName
				.split(".")
				.toReversed();
			return getFromPath(form.value, currentInitial.join(".") + sourceLast);
		}

		return getFromPath(form.value, source);
	}

	const sourceFieldValues = computed(() =>
		currentFieldDependencies.value?.map((dep) => getSourceValue(dep)),
	);

	const resetConditionState = () => {
		isDisabled.value = false;
		isHidden.value = false;
		isRequired.value = false;
		overrideOptions.value = undefined;
	};

	watch(
		[sourceFieldValues, dependencies],
		() => {
			resetConditionState();
			currentFieldDependencies.value?.forEach((dep) => {
				const sourceValue = getSourceValue(dep);
				const conditionMet = dep.when(sourceValue, currentFieldValue.value);

				switch (dep.type) {
					case DependencyType.DISABLES:
						if (conditionMet) isDisabled.value = true;

						break;
					case DependencyType.REQUIRES:
						if (conditionMet) isRequired.value = true;

						break;
					case DependencyType.HIDES:
						if (conditionMet) isHidden.value = true;

						break;
					case DependencyType.SETS_OPTIONS:
						if (conditionMet) overrideOptions.value = dep.options;

						break;
				}
			});
		},
		{ immediate: true, deep: true },
	);

	return {
		isDisabled,
		isHidden,
		isRequired,
		overrideOptions,
	};
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/index.ts
```typescript
export { getObjectFormSchema, getBaseSchema, getBaseType } from "./utils";
export type { Config, ConfigItem, FieldProps } from "./interface";

export { default as AutoForm } from "./AutoForm.vue";
export { default as AutoFormField } from "./AutoFormField.vue";
export { default as AutoFormLabel } from "./AutoFormLabel.vue";

export { default as AutoFormFieldArray } from "./AutoFormFieldArray.vue";
export { default as AutoFormFieldBoolean } from "./AutoFormFieldBoolean.vue";
export { default as AutoFormFieldDate } from "./AutoFormFieldDate.vue";
export { default as AutoFormFieldEnum } from "./AutoFormFieldEnum.vue";
export { default as AutoFormFieldFile } from "./AutoFormFieldFile.vue";
export { default as AutoFormFieldInput } from "./AutoFormFieldInput.vue";
export { default as AutoFormFieldNumber } from "./AutoFormFieldNumber.vue";
export { default as AutoFormFieldObject } from "./AutoFormFieldObject.vue";

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/interface.ts
```typescript
import type { Component, InputHTMLAttributes } from "vue";
import type { ZodAny, z } from "zod";
import type { INPUT_COMPONENTS } from "./constant";

export interface FieldProps {
	fieldName: string;
	label?: string;
	required?: boolean;
	config?: ConfigItem;
	disabled?: boolean;
}

export interface Shape {
	type: string;
	default?: any;
	required?: boolean;
	options?: string[];
	schema?: ZodAny;
}

export interface ConfigItem {
	/** Value for the `FormLabel` */
	label?: string;
	/** Value for the `FormDescription` */
	description?: string;
	/** Pick which component to be rendered. */
	component?: keyof typeof INPUT_COMPONENTS | Component;
	/** Hide `FormLabel`. */
	hideLabel?: boolean;
	inputProps?: InputHTMLAttributes;
}

// Define a type to unwrap an array
type UnwrapArray<T> = T extends (infer U)[] ? U : never;

export type Config<SchemaType extends object> = {
	// If SchemaType.key is an object, create a nested Config, otherwise ConfigItem
	[Key in keyof SchemaType]?: SchemaType[Key] extends any[]
		? UnwrapArray<Config<SchemaType[Key]>>
		: SchemaType[Key] extends object
			? Config<SchemaType[Key]>
			: ConfigItem;
};

export enum DependencyType {
	DISABLES,
	REQUIRES,
	HIDES,
	SETS_OPTIONS,
}

interface BaseDependency<SchemaType extends z.infer<z.ZodObject<any, any>>> {
	sourceField: keyof SchemaType;
	type: DependencyType;
	targetField: keyof SchemaType;
	when: (sourceFieldValue: any, targetFieldValue: any) => boolean;
}

export type ValueDependency<SchemaType extends z.infer<z.ZodObject<any, any>>> =
	BaseDependency<SchemaType> & {
		type:
			| DependencyType.DISABLES
			| DependencyType.REQUIRES
			| DependencyType.HIDES;
	};

export type EnumValues = readonly [string, ...string[]];

export type OptionsDependency<
	SchemaType extends z.infer<z.ZodObject<any, any>>,
> = BaseDependency<SchemaType> & {
	type: DependencyType.SETS_OPTIONS;

	// Partial array of values from sourceField that will trigger the dependency
	options: EnumValues;
};

export type Dependency<SchemaType extends z.infer<z.ZodObject<any, any>>> =
	| ValueDependency<SchemaType>
	| OptionsDependency<SchemaType>;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/auto-form/utils.ts
```typescript
import type { z } from "zod";

// TODO: This should support recursive ZodEffects but TypeScript doesn't allow circular type definitions.
export type ZodObjectOrWrapped =
	| z.ZodObject<any, any>
	| z.ZodEffects<z.ZodObject<any, any>>;

/**
 * Beautify a camelCase string.
 * e.g. "myString" -> "My String"
 */
export function beautifyObjectName(string: string) {
	// Remove bracketed indices
	// if numbers only return the string
	let output = string.replace(/\[\d+\]/g, "").replace(/([A-Z])/g, " $1");
	output = output.charAt(0).toUpperCase() + output.slice(1);
	return output;
}

/**
 * Parse string and extract the index
 * @param string
 * @returns index or undefined
 */
export function getIndexIfArray(string: string) {
	const indexRegex = /\[(\d+)\]/;
	// Match the index
	const match = string.match(indexRegex);
	// Extract the index (number)
	const index = match ? Number.parseInt(match[1]) : undefined;
	return index;
}

/**
 * Get the lowest level Zod type.
 * This will unpack optionals, refinements, etc.
 */
export function getBaseSchema<
	ChildType extends z.ZodAny | z.AnyZodObject = z.ZodAny,
>(schema: ChildType | z.ZodEffects<ChildType>): ChildType | null {
	if (!schema) return null;
	if ("innerType" in schema._def)
		return getBaseSchema(schema._def.innerType as ChildType);

	if ("schema" in schema._def)
		return getBaseSchema(schema._def.schema as ChildType);

	return schema as ChildType;
}

/**
 * Get the type name of the lowest level Zod type.
 * This will unpack optionals, refinements, etc.
 */
export function getBaseType(schema: z.ZodAny) {
	const baseSchema = getBaseSchema(schema);
	return baseSchema ? baseSchema._def.typeName : "";
}

/**
 * Search for a "ZodDefault" in the Zod stack and return its value.
 */
export function getDefaultValueInZodStack(schema: z.ZodAny): any {
	const typedSchema = schema as unknown as z.ZodDefault<
		z.ZodNumber | z.ZodString
	>;

	if (typedSchema._def.typeName === "ZodDefault")
		return typedSchema._def.defaultValue();

	if ("innerType" in typedSchema._def) {
		return getDefaultValueInZodStack(
			typedSchema._def.innerType as unknown as z.ZodAny,
		);
	}
	if ("schema" in typedSchema._def) {
		return getDefaultValueInZodStack(
			(typedSchema._def as any).schema as z.ZodAny,
		);
	}

	return undefined;
}

export function getObjectFormSchema(
	schema: ZodObjectOrWrapped,
): z.ZodObject<any, any> {
	if (schema?._def.typeName === "ZodEffects") {
		const typedSchema = schema as z.ZodEffects<z.ZodObject<any, any>>;
		return getObjectFormSchema(typedSchema._def.schema);
	}
	return schema as z.ZodObject<any, any>;
}

function isIndex(value: unknown): value is number {
	return Number(value) >= 0;
}
/**
 * Constructs a path with dot paths for arrays to use brackets to be compatible with vee-validate path syntax
 */
export function normalizeFormPath(path: string): string {
	const pathArr = path.split(".");
	if (!pathArr.length) return "";

	let fullPath = String(pathArr[0]);
	for (let i = 1; i < pathArr.length; i++) {
		if (isIndex(pathArr[i])) {
			fullPath += `[${pathArr[i]}]`;
			continue;
		}

		fullPath += `.${pathArr[i]}`;
	}

	return fullPath;
}

type NestedRecord = Record<string, unknown> | { [k: string]: NestedRecord };
/**
 * Checks if the path opted out of nested fields using `[fieldName]` syntax
 */
export function isNotNestedPath(path: string) {
	return /^\[.+\]$/.test(path);
}
function isObject(obj: unknown): obj is Record<string, unknown> {
	return (
		obj !== null && !!obj && typeof obj === "object" && !Array.isArray(obj)
	);
}
function isContainerValue(value: unknown): value is Record<string, unknown> {
	return isObject(value) || Array.isArray(value);
}
function cleanupNonNestedPath(path: string) {
	if (isNotNestedPath(path)) return path.replace(/\[|\]/g, "");

	return path;
}

/**
 * Gets a nested property value from an object
 */
export function getFromPath<TValue = unknown>(
	object: NestedRecord | undefined,
	path: string,
): TValue | undefined;
export function getFromPath<TValue = unknown, TFallback = TValue>(
	object: NestedRecord | undefined,
	path: string,
	fallback?: TFallback,
): TValue | TFallback;
export function getFromPath<TValue = unknown, TFallback = TValue>(
	object: NestedRecord | undefined,
	path: string,
	fallback?: TFallback,
): TValue | TFallback | undefined {
	if (!object) return fallback;

	if (isNotNestedPath(path))
		return object[cleanupNonNestedPath(path)] as TValue | undefined;

	const resolvedValue = (path || "")
		.split(/\.|\[(\d+)\]/)
		.filter(Boolean)
		.reduce((acc, propKey) => {
			if (isContainerValue(acc) && propKey in acc) return acc[propKey];

			return fallback;
		}, object as unknown);

	return resolvedValue as TValue | undefined;
}

```
