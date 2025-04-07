/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/textarea/index.ts
```typescript
import Root from "./textarea.svelte";

type FormTextareaEvent<T extends Event = Event> = T & {
	currentTarget: EventTarget & HTMLTextAreaElement;
};

type TextareaEvents = {
	blur: FormTextareaEvent<FocusEvent>;
	change: FormTextareaEvent<Event>;
	click: FormTextareaEvent<MouseEvent>;
	focus: FormTextareaEvent<FocusEvent>;
	keydown: FormTextareaEvent<KeyboardEvent>;
	keypress: FormTextareaEvent<KeyboardEvent>;
	keyup: FormTextareaEvent<KeyboardEvent>;
	mouseover: FormTextareaEvent<MouseEvent>;
	mouseenter: FormTextareaEvent<MouseEvent>;
	mouseleave: FormTextareaEvent<MouseEvent>;
	paste: FormTextareaEvent<ClipboardEvent>;
	input: FormTextareaEvent<InputEvent>;
};

export {
	Root,
	//
	Root as Textarea,
	type TextareaEvents,
	type FormTextareaEvent,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/svelte-kit-example/src/lib/components/ui/textarea/textarea.svelte
```
<script lang="ts">
import type { HTMLTextareaAttributes } from "svelte/elements";
import type { TextareaEvents } from "./index.js";

type $$Props = HTMLTextareaAttributes;
type $$Events = TextareaEvents;

let className: $$Props["class"] = undefined;
export let value: $$Props["value"] = undefined;
export { className as class };

// Workaround for https://github.com/sveltejs/svelte/issues/9305
// Fixed in Svelte 5, but not backported to 4.x.
export let readonly: $$Props["readonly"] = undefined;
</script>

<textarea
	class={cn(
		"border-input placeholder:text-muted-foreground focus-visible:ring-ring flex min-h-[60px] w-full rounded-md border bg-transparent px-3 py-2 text-sm shadow-sm focus-visible:outline-none focus-visible:ring-1 disabled:cursor-not-allowed disabled:opacity-50",
		className
	)}
	bind:value
	{readonly}
	on:blur
	on:change
	on:click
	on:focus
	on:keydown
	on:keypress
	on:keyup
	on:mouseover
	on:mouseenter
	on:mouseleave
	on:paste
	on:input
	{...$$restProps}
></textarea>

```
