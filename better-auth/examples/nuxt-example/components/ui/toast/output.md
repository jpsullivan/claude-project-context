/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/toast/Toast.vue
```
<script setup lang="ts">
import { computed } from "vue";
import { type ToastRootEmits, useForwardPropsEmits } from "radix-vue";
import { type ToastProps } from ".";

const props = defineProps<ToastProps>();

const emits = defineEmits<ToastRootEmits>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});

const forwarded = useForwardPropsEmits(delegatedProps, emits);
</script>

<template>
  <ToastRoot
    v-bind="forwarded"
    :class="cn(toastVariants({ variant }), props.class)"
    @update:open="onOpenChange"
  >
    <slot />
  </ToastRoot>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/toast/ToastAction.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type ToastActionProps } from "radix-vue";

const props = defineProps<
	ToastActionProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <ToastAction v-bind="delegatedProps" :class="cn('inline-flex h-8 shrink-0 items-center justify-center rounded-md border bg-transparent px-3 text-sm font-medium transition-colors hover:bg-secondary focus:outline-none focus:ring-1 focus:ring-ring disabled:pointer-events-none disabled:opacity-50 group-[.destructive]:border-muted/40 group-[.destructive]:hover:border-destructive/30 group-[.destructive]:hover:bg-destructive group-[.destructive]:hover:text-destructive-foreground group-[.destructive]:focus:ring-destructive', props.class)">
    <slot />
  </ToastAction>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/toast/ToastClose.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type ToastCloseProps } from "radix-vue";

const props = defineProps<
	ToastCloseProps & {
		class?: HTMLAttributes["class"];
	}
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <ToastClose v-bind="delegatedProps" :class="cn('absolute right-1 top-1 rounded-md p-1 text-foreground/50 opacity-0 transition-opacity hover:text-foreground focus:opacity-100 focus:outline-none focus:ring-1 group-hover:opacity-100 group-[.destructive]:text-red-300 group-[.destructive]:hover:text-red-50 group-[.destructive]:focus:ring-red-400 group-[.destructive]:focus:ring-offset-red-600', props.class)">
    <Cross2Icon class="h-4 w-4" />
  </ToastClose>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/toast/ToastDescription.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type ToastDescriptionProps } from "radix-vue";

const props = defineProps<
	ToastDescriptionProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <ToastDescription :class="cn('text-sm opacity-90', props.class)" v-bind="delegatedProps">
    <slot />
  </ToastDescription>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/toast/ToastProvider.vue
```
<script setup lang="ts">
import { type ToastProviderProps } from "radix-vue";

const props = defineProps<ToastProviderProps>();
</script>

<template>
  <ToastProvider v-bind="props">
    <slot />
  </ToastProvider>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/toast/ToastTitle.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type ToastTitleProps } from "radix-vue";

const props = defineProps<
	ToastTitleProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <ToastTitle v-bind="delegatedProps" :class="cn('text-sm font-semibold [&+div]:text-xs', props.class)">
    <slot />
  </ToastTitle>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/toast/ToastViewport.vue
```
<script setup lang="ts">
import { type HTMLAttributes, computed } from "vue";
import { type ToastViewportProps } from "radix-vue";

const props = defineProps<
	ToastViewportProps & { class?: HTMLAttributes["class"] }
>();

const delegatedProps = computed(() => {
	const { class: _, ...delegated } = props;

	return delegated;
});
</script>

<template>
  <ToastViewport v-bind="delegatedProps" :class="cn('fixed top-0 z-[100] flex max-h-screen w-full flex-col-reverse p-4 sm:bottom-0 sm:right-0 sm:top-auto sm:flex-col md:max-w-[420px]', props.class)" />
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/toast/Toaster.vue
```
<script setup lang="ts">
import { useToast } from "./use-toast";

const { toasts } = useToast();
</script>

<template>
  <ToastProvider>
    <Toast v-for="toast in toasts" :key="toast.id" v-bind="toast">
      <div class="grid gap-1">
        <ToastTitle v-if="toast.title">
          {{ toast.title }}
        </ToastTitle>
        <template v-if="toast.description">
          <ToastDescription v-if="isVNode(toast.description)">
            <component :is="toast.description" />
          </ToastDescription>
          <ToastDescription v-else>
            {{ toast.description }}
          </ToastDescription>
        </template>
        <ToastClose />
      </div>
      <component :is="toast.action" />
    </Toast>
    <ToastViewport />
  </ToastProvider>
</template>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/toast/index.ts
```typescript
import type { ToastRootProps } from "radix-vue";
import type { HTMLAttributes } from "vue";

export { default as Toaster } from "./Toaster.vue";
export { default as Toast } from "./Toast.vue";
export { default as ToastViewport } from "./ToastViewport.vue";
export { default as ToastAction } from "./ToastAction.vue";
export { default as ToastClose } from "./ToastClose.vue";
export { default as ToastTitle } from "./ToastTitle.vue";
export { default as ToastDescription } from "./ToastDescription.vue";
export { default as ToastProvider } from "./ToastProvider.vue";
export { toast, useToast } from "./use-toast";

import { type VariantProps, cva } from "class-variance-authority";

export const toastVariants = cva(
	"group pointer-events-auto relative flex w-full items-center justify-between space-x-2 overflow-hidden rounded-md border p-4 pr-6 shadow-lg transition-all data-[swipe=cancel]:translate-x-0 data-[swipe=end]:translate-x-[var(--radix-toast-swipe-end-x)] data-[swipe=move]:translate-x-[var(--radix-toast-swipe-move-x)] data-[swipe=move]:transition-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[swipe=end]:animate-out data-[state=closed]:fade-out-80 data-[state=closed]:slide-out-to-right-full data-[state=open]:slide-in-from-top-full data-[state=open]:sm:slide-in-from-bottom-full",
	{
		variants: {
			variant: {
				default: "border bg-background text-foreground",
				destructive:
					"destructive group border-destructive bg-destructive text-destructive-foreground",
			},
		},
		defaultVariants: {
			variant: "default",
		},
	},
);

type ToastVariants = VariantProps<typeof toastVariants>;

export interface ToastProps extends ToastRootProps {
	class?: HTMLAttributes["class"];
	variant?: ToastVariants["variant"];
	onOpenChange?: ((value: boolean) => void) | undefined;
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/nuxt-example/components/ui/toast/use-toast.ts
```typescript
import { computed, ref } from "vue";
import type { Component, VNode } from "vue";
import type { ToastProps } from ".";

const TOAST_LIMIT = 1;
const TOAST_REMOVE_DELAY = 1000000;

export type StringOrVNode = string | VNode | (() => VNode);

type ToasterToast = ToastProps & {
	id: string;
	title?: string;
	description?: StringOrVNode;
	action?: Component;
};

const actionTypes = {
	ADD_TOAST: "ADD_TOAST",
	UPDATE_TOAST: "UPDATE_TOAST",
	DISMISS_TOAST: "DISMISS_TOAST",
	REMOVE_TOAST: "REMOVE_TOAST",
} as const;

let count = 0;

function genId() {
	count = (count + 1) % Number.MAX_VALUE;
	return count.toString();
}

type ActionType = typeof actionTypes;

type Action =
	| {
			type: ActionType["ADD_TOAST"];
			toast: ToasterToast;
	  }
	| {
			type: ActionType["UPDATE_TOAST"];
			toast: Partial<ToasterToast>;
	  }
	| {
			type: ActionType["DISMISS_TOAST"];
			toastId?: ToasterToast["id"];
	  }
	| {
			type: ActionType["REMOVE_TOAST"];
			toastId?: ToasterToast["id"];
	  };

interface State {
	toasts: ToasterToast[];
}

const toastTimeouts = new Map<string, ReturnType<typeof setTimeout>>();

function addToRemoveQueue(toastId: string) {
	if (toastTimeouts.has(toastId)) return;

	const timeout = setTimeout(() => {
		toastTimeouts.delete(toastId);
		dispatch({
			type: actionTypes.REMOVE_TOAST,
			toastId,
		});
	}, TOAST_REMOVE_DELAY);

	toastTimeouts.set(toastId, timeout);
}

const state = ref<State>({
	toasts: [],
});

function dispatch(action: Action) {
	switch (action.type) {
		case actionTypes.ADD_TOAST:
			state.value.toasts = [action.toast, ...state.value.toasts].slice(
				0,
				TOAST_LIMIT,
			);
			break;

		case actionTypes.UPDATE_TOAST:
			state.value.toasts = state.value.toasts.map((t) =>
				t.id === action.toast.id ? { ...t, ...action.toast } : t,
			);
			break;

		case actionTypes.DISMISS_TOAST: {
			const { toastId } = action;

			if (toastId) {
				addToRemoveQueue(toastId);
			} else {
				state.value.toasts.forEach((toast) => {
					addToRemoveQueue(toast.id);
				});
			}

			state.value.toasts = state.value.toasts.map((t) =>
				t.id === toastId || toastId === undefined
					? {
							...t,
							open: false,
						}
					: t,
			);
			break;
		}

		case actionTypes.REMOVE_TOAST:
			if (action.toastId === undefined) state.value.toasts = [];
			else
				state.value.toasts = state.value.toasts.filter(
					(t) => t.id !== action.toastId,
				);

			break;
	}
}

function useToast() {
	return {
		toasts: computed(() => state.value.toasts),
		toast,
		dismiss: (toastId?: string) =>
			dispatch({ type: actionTypes.DISMISS_TOAST, toastId }),
	};
}

type Toast = Omit<ToasterToast, "id">;

function toast(props: Toast) {
	const id = genId();

	const update = (props: ToasterToast) =>
		dispatch({
			type: actionTypes.UPDATE_TOAST,
			toast: { ...props, id },
		});

	const dismiss = () =>
		dispatch({ type: actionTypes.DISMISS_TOAST, toastId: id });

	dispatch({
		type: actionTypes.ADD_TOAST,
		toast: {
			...props,
			id,
			open: true,
			onOpenChange: (open: boolean) => {
				if (!open) dismiss();
			},
		},
	});

	return {
		id,
		dismiss,
		update,
	};
}

export { toast, useToast };

```
