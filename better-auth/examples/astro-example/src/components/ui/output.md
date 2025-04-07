/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/accordion.tsx
```
import { cn } from "@/libs/cn";
import type {
	AccordionContentProps,
	AccordionItemProps,
	AccordionTriggerProps,
} from "@kobalte/core/accordion";
import { Accordion as AccordionPrimitive } from "@kobalte/core/accordion";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import { type ParentProps, type ValidComponent, splitProps } from "solid-js";

export const Accordion = AccordionPrimitive;

type accordionItemProps<T extends ValidComponent = "div"> =
	AccordionItemProps<T> & {
		class?: string;
	};

export const AccordionItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, accordionItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as accordionItemProps, ["class"]);

	return (
		<AccordionPrimitive.Item class={cn("border-b", local.class)} {...rest} />
	);
};

type accordionTriggerProps<T extends ValidComponent = "button"> = ParentProps<
	AccordionTriggerProps<T> & {
		class?: string;
	}
>;

export const AccordionTrigger = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, accordionTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as accordionTriggerProps, [
		"class",
		"children",
	]);

	return (
		<AccordionPrimitive.Header class="flex" as="div">
			<AccordionPrimitive.Trigger
				class={cn(
					"flex flex-1 items-center justify-between py-4 text-sm font-medium transition-shadow hover:underline focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring [&[data-expanded]>svg]:rotate-180",
					local.class,
				)}
				{...rest}
			>
				{local.children}
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-4 w-4 text-muted-foreground transition-transform duration-200"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m6 9l6 6l6-6"
					/>
					<title>Arrow</title>
				</svg>
			</AccordionPrimitive.Trigger>
		</AccordionPrimitive.Header>
	);
};

type accordionContentProps<T extends ValidComponent = "div"> = ParentProps<
	AccordionContentProps<T> & {
		class?: string;
	}
>;

export const AccordionContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, accordionContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as accordionContentProps, [
		"class",
		"children",
	]);

	return (
		<AccordionPrimitive.Content
			class={cn(
				"animate-accordion-up overflow-hidden text-sm data-[expanded]:animate-accordion-down",
				local.class,
			)}
			{...rest}
		>
			<div class="pb-4 pt-0">{local.children}</div>
		</AccordionPrimitive.Content>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/alert-dialog.tsx
```
import { cn } from "@/libs/cn";
import type {
	AlertDialogCloseButtonProps,
	AlertDialogContentProps,
	AlertDialogDescriptionProps,
	AlertDialogTitleProps,
} from "@kobalte/core/alert-dialog";
import { AlertDialog as AlertDialogPrimitive } from "@kobalte/core/alert-dialog";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ComponentProps, ParentProps, ValidComponent } from "solid-js";
import { splitProps } from "solid-js";
import { buttonVariants } from "./button";

export const AlertDialog = AlertDialogPrimitive;
export const AlertDialogTrigger = AlertDialogPrimitive.Trigger;

type alertDialogContentProps<T extends ValidComponent = "div"> = ParentProps<
	AlertDialogContentProps<T> & {
		class?: string;
	}
>;

export const AlertDialogContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, alertDialogContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as alertDialogContentProps, [
		"class",
		"children",
	]);

	return (
		<AlertDialogPrimitive.Portal>
			<AlertDialogPrimitive.Overlay
				class={cn(
					"fixed inset-0 z-50 bg-background/80 data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0",
				)}
			/>
			<AlertDialogPrimitive.Content
				class={cn(
					"fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border bg-background p-6 shadow-lg data-[closed]:duration-200 data-[expanded]:duration-200 data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95 data-[closed]:slide-out-to-left-1/2 data-[closed]:slide-out-to-top-[48%] data-[expanded]:slide-in-from-left-1/2 data-[expanded]:slide-in-from-top-[48%] sm:rounded-lg md:w-full",
					local.class,
				)}
				{...rest}
			>
				{local.children}
			</AlertDialogPrimitive.Content>
		</AlertDialogPrimitive.Portal>
	);
};

export const AlertDialogHeader = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"flex flex-col space-y-2 text-center sm:text-left",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const AlertDialogFooter = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",
				local.class,
			)}
			{...rest}
		/>
	);
};

type alertDialogTitleProps<T extends ValidComponent = "h2"> =
	AlertDialogTitleProps<T> & {
		class?: string;
	};

export const AlertDialogTitle = <T extends ValidComponent = "h2">(
	props: PolymorphicProps<T, alertDialogTitleProps<T>>,
) => {
	const [local, rest] = splitProps(props as alertDialogTitleProps, ["class"]);

	return (
		<AlertDialogPrimitive.Title
			class={cn("text-lg font-semibold", local.class)}
			{...rest}
		/>
	);
};

type alertDialogDescriptionProps<T extends ValidComponent = "p"> =
	AlertDialogDescriptionProps<T> & {
		class?: string;
	};

export const AlertDialogDescription = <T extends ValidComponent = "p">(
	props: PolymorphicProps<T, alertDialogDescriptionProps<T>>,
) => {
	const [local, rest] = splitProps(props as alertDialogDescriptionProps, [
		"class",
	]);

	return (
		<AlertDialogPrimitive.Description
			class={cn("text-sm text-muted-foreground", local.class)}
			{...rest}
		/>
	);
};

type alertDialogCloseProps<T extends ValidComponent = "button"> =
	AlertDialogCloseButtonProps<T> & {
		class?: string;
	};

export const AlertDialogClose = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, alertDialogCloseProps<T>>,
) => {
	const [local, rest] = splitProps(props as alertDialogCloseProps, ["class"]);

	return (
		<AlertDialogPrimitive.CloseButton
			class={cn(
				buttonVariants({
					variant: "outline",
				}),
				"mt-2 md:mt-0",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const AlertDialogAction = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, alertDialogCloseProps<T>>,
) => {
	const [local, rest] = splitProps(props as alertDialogCloseProps, ["class"]);

	return (
		<AlertDialogPrimitive.CloseButton
			class={cn(buttonVariants(), local.class)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/alert.tsx
```
import { cn } from "@/libs/cn";
import type { AlertRootProps } from "@kobalte/core/alert";
import { Alert as AlertPrimitive } from "@kobalte/core/alert";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { VariantProps } from "class-variance-authority";
import { cva } from "class-variance-authority";
import type { ComponentProps, ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const alertVariants = cva(
	"relative w-full rounded-lg border px-4 py-3 text-sm [&:has(svg)]:pl-11 [&>svg+div]:translate-y-[-3px] [&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:text-foreground",
	{
		variants: {
			variant: {
				default: "bg-background text-foreground",
				destructive:
					"border-destructive/50 text-destructive dark:border-destructive [&>svg]:text-destructive",
			},
		},
		defaultVariants: {
			variant: "default",
		},
	},
);

type alertProps<T extends ValidComponent = "div"> = AlertRootProps<T> &
	VariantProps<typeof alertVariants> & {
		class?: string;
	};

export const Alert = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, alertProps<T>>,
) => {
	const [local, rest] = splitProps(props as alertProps, ["class", "variant"]);

	return (
		<AlertPrimitive
			class={cn(
				alertVariants({
					variant: props.variant,
				}),
				local.class,
			)}
			{...rest}
		/>
	);
};

export const AlertTitle = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn("font-medium leading-5 tracking-tight", local.class)}
			{...rest}
		/>
	);
};

export const AlertDescription = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div class={cn("text-sm [&_p]:leading-relaxed", local.class)} {...rest} />
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/badge.tsx
```
import { cn } from "@/libs/cn";
import type { VariantProps } from "class-variance-authority";
import { cva } from "class-variance-authority";
import { type ComponentProps, splitProps } from "solid-js";

export const badgeVariants = cva(
	"inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold transition-shadow focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring",
	{
		variants: {
			variant: {
				default:
					"border-transparent bg-primary text-primary-foreground shadow hover:bg-primary/80",
				secondary:
					"border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",
				destructive:
					"border-transparent bg-destructive text-destructive-foreground shadow hover:bg-destructive/80",
				outline: "text-foreground",
			},
		},
		defaultVariants: {
			variant: "default",
		},
	},
);

export const Badge = (
	props: ComponentProps<"div"> & VariantProps<typeof badgeVariants>,
) => {
	const [local, rest] = splitProps(props, ["class", "variant"]);

	return (
		<div
			class={cn(
				badgeVariants({
					variant: local.variant,
				}),
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/button.tsx
```
import { cn } from "@/libs/cn";
import type { ButtonRootProps } from "@kobalte/core/button";
import { Button as ButtonPrimitive } from "@kobalte/core/button";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { VariantProps } from "class-variance-authority";
import { cva } from "class-variance-authority";
import type { ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const buttonVariants = cva(
	"inline-flex items-center justify-center rounded-md text-sm font-medium transition-[color,background-color,box-shadow] focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50",
	{
		variants: {
			variant: {
				default:
					"bg-primary text-primary-foreground shadow hover:bg-primary/90",
				destructive:
					"bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90",
				outline:
					"border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground",
				secondary:
					"bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80",
				ghost: "hover:bg-accent hover:text-accent-foreground",
				link: "text-primary underline-offset-4 hover:underline",
			},
			size: {
				default: "h-9 px-4 py-2",
				sm: "h-8 rounded-md px-3 text-xs",
				lg: "h-10 rounded-md px-8",
				icon: "h-9 w-9",
			},
		},
		defaultVariants: {
			variant: "default",
			size: "default",
		},
	},
);

type buttonProps<T extends ValidComponent = "button"> = ButtonRootProps<T> &
	VariantProps<typeof buttonVariants> & {
		class?: string;
	};

export const Button = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, buttonProps<T>>,
) => {
	const [local, rest] = splitProps(props as buttonProps, [
		"class",
		"variant",
		"size",
	]);

	return (
		<ButtonPrimitive
			class={cn(
				buttonVariants({
					size: local.size,
					variant: local.variant,
				}),
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/card.tsx
```
import { cn } from "@/libs/cn";
import type { ComponentProps, ParentComponent } from "solid-js";
import { splitProps } from "solid-js";

export const Card = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"rounded-xl border bg-card text-card-foreground shadow",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const CardHeader = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div class={cn("flex flex-col space-y-1.5 p-6", local.class)} {...rest} />
	);
};

export const CardTitle: ParentComponent<ComponentProps<"h1">> = (props) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<h1
			class={cn("font-semibold leading-none tracking-tight", local.class)}
			{...rest}
		/>
	);
};

export const CardDescription: ParentComponent<ComponentProps<"h3">> = (
	props,
) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<h3 class={cn("text-sm text-muted-foreground", local.class)} {...rest} />
	);
};

export const CardContent = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return <div class={cn("p-6 pt-0", local.class)} {...rest} />;
};

export const CardFooter = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div class={cn("flex items-center p-6 pt-0", local.class)} {...rest} />
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/carousel.tsx
```
import { cn } from "@/libs/cn";
import type { CreateEmblaCarouselType } from "embla-carousel-solid";
import createEmblaCarousel from "embla-carousel-solid";
import type {
	Accessor,
	ComponentProps,
	ParentProps,
	VoidProps,
} from "solid-js";
import {
	createContext,
	createEffect,
	createMemo,
	createSignal,
	mergeProps,
	onCleanup,
	splitProps,
	useContext,
} from "solid-js";
import { Button } from "./button";

export type CarouselApi = CreateEmblaCarouselType[1];
type UseCarouselParameters = Parameters<typeof createEmblaCarousel>;
type CarouselOptions = NonNullable<UseCarouselParameters[0]>;
type CarouselPlugin = NonNullable<UseCarouselParameters[1]>;

type CarouselProps = {
	opts?: ReturnType<CarouselOptions>;
	plugins?: ReturnType<CarouselPlugin>;
	orientation?: "horizontal" | "vertical";
	setApi?: (api: CarouselApi) => void;
};

type CarouselContextProps = {
	carouselRef: ReturnType<typeof createEmblaCarousel>[0];
	api: ReturnType<typeof createEmblaCarousel>[1];
	scrollPrev: () => void;
	scrollNext: () => void;
	canScrollPrev: Accessor<boolean>;
	canScrollNext: Accessor<boolean>;
} & CarouselProps;

const CarouselContext = createContext<Accessor<CarouselContextProps> | null>(
	null,
);

const useCarousel = () => {
	const context = useContext(CarouselContext);

	if (!context) {
		throw new Error("useCarousel must be used within a <Carousel />");
	}

	return context();
};

export const Carousel = (props: ComponentProps<"div"> & CarouselProps) => {
	const merge = mergeProps<
		ParentProps<ComponentProps<"div"> & CarouselProps>[]
	>({ orientation: "horizontal" }, props);

	const [local, rest] = splitProps(merge, [
		"orientation",
		"opts",
		"setApi",
		"plugins",
		"class",
		"children",
	]);

	const [carouselRef, api] = createEmblaCarousel(
		() => ({
			...local.opts,
			axis: local.orientation === "horizontal" ? "x" : "y",
		}),
		() => (local.plugins === undefined ? [] : local.plugins),
	);
	const [canScrollPrev, setCanScrollPrev] = createSignal(false);
	const [canScrollNext, setCanScrollNext] = createSignal(false);

	const onSelect = (api: NonNullable<ReturnType<CarouselApi>>) => {
		setCanScrollPrev(api.canScrollPrev());
		setCanScrollNext(api.canScrollNext());
	};

	const scrollPrev = () => api()?.scrollPrev();

	const scrollNext = () => api()?.scrollNext();

	const handleKeyDown = (event: KeyboardEvent) => {
		if (event.key === "ArrowLeft") {
			event.preventDefault();
			scrollPrev();
		} else if (event.key === "ArrowRight") {
			event.preventDefault();
			scrollNext();
		}
	};

	createEffect(() => {
		if (!api() || !local.setApi) return;

		local.setApi(api);
	});

	createEffect(() => {
		const _api = api();
		if (_api === undefined) return;

		onSelect(_api);
		_api.on("reInit", onSelect);
		_api.on("select", onSelect);

		onCleanup(() => {
			_api.off("select", onSelect);
		});
	});

	const value = createMemo(
		() =>
			({
				carouselRef,
				api,
				opts: local.opts,
				orientation:
					local.orientation ||
					(local.opts?.axis === "y" ? "vertical" : "horizontal"),
				scrollPrev,
				scrollNext,
				canScrollPrev,
				canScrollNext,
			}) satisfies CarouselContextProps,
	);

	return (
		<CarouselContext.Provider value={value}>
			<div
				onKeyDown={handleKeyDown}
				class={cn("relative", local.class)}
				role="region"
				aria-roledescription="carousel"
				{...rest}
			>
				{local.children}
			</div>
		</CarouselContext.Provider>
	);
};

export const CarouselContent = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);
	const { carouselRef, orientation } = useCarousel();

	return (
		<div ref={carouselRef} class="overflow-hidden">
			<div
				class={cn(
					"flex",
					orientation === "horizontal" ? "-ml-4" : "-mt-4 flex-col",
					local.class,
				)}
				{...rest}
			/>
		</div>
	);
};

export const CarouselItem = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);
	const { orientation } = useCarousel();

	return (
		<div
			role="group"
			aria-roledescription="slide"
			class={cn(
				"min-w-0 shrink-0 grow-0 basis-full",
				orientation === "horizontal" ? "pl-4" : "pt-4",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const CarouselPrevious = (
	props: VoidProps<ComponentProps<typeof Button>>,
) => {
	const merge = mergeProps<VoidProps<ComponentProps<typeof Button>[]>>(
		{ variant: "outline", size: "icon" },
		props,
	);
	const [local, rest] = splitProps(merge, ["class", "variant", "size"]);
	const { orientation, scrollPrev, canScrollPrev } = useCarousel();

	return (
		<Button
			variant={local.variant}
			size={local.size}
			class={cn(
				"absolute  h-8 w-8 touch-manipulation rounded-full",
				orientation === "horizontal"
					? "-left-12 top-1/2 -translate-y-1/2"
					: "-top-12 left-1/2 -translate-x-1/2 rotate-90",
				local.class,
			)}
			disabled={!canScrollPrev()}
			onClick={scrollPrev}
			{...rest}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				viewBox="0 0 24 24"
				class="size-4"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="M5 12h14M5 12l6 6m-6-6l6-6"
				/>
				<title>Previous slide</title>
			</svg>
		</Button>
	);
};

export const CarouselNext = (
	props: VoidProps<ComponentProps<typeof Button>>,
) => {
	const merge = mergeProps<VoidProps<ComponentProps<typeof Button>[]>>(
		{ variant: "outline", size: "icon" },
		props,
	);
	const [local, rest] = splitProps(merge, ["class", "variant", "size"]);
	const { orientation, scrollNext, canScrollNext } = useCarousel();

	return (
		<Button
			variant={local.variant}
			size={local.size}
			class={cn(
				"absolute h-8 w-8 touch-manipulation rounded-full",
				orientation === "horizontal"
					? "-right-12 top-1/2 -translate-y-1/2"
					: "-bottom-12 left-1/2 -translate-x-1/2 rotate-90",
				local.class,
			)}
			disabled={!canScrollNext()}
			onClick={scrollNext}
			{...rest}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				viewBox="0 0 24 24"
				class="size-4"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="M5 12h14m-4 4l4-4m-4-4l4 4"
				/>
				<title>Next slide</title>
			</svg>
		</Button>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/checkbox.tsx
```
import { cn } from "@/libs/cn";
import type { CheckboxControlProps } from "@kobalte/core/checkbox";
import { Checkbox as CheckboxPrimitive } from "@kobalte/core/checkbox";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";

export const CheckboxLabel = CheckboxPrimitive.Label;
export const Checkbox = CheckboxPrimitive;
export const CheckboxErrorMessage = CheckboxPrimitive.ErrorMessage;
export const CheckboxDescription = CheckboxPrimitive.Description;

type checkboxControlProps<T extends ValidComponent = "div"> = VoidProps<
	CheckboxControlProps<T> & { class?: string }
>;

export const CheckboxControl = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, checkboxControlProps<T>>,
) => {
	const [local, rest] = splitProps(props as checkboxControlProps, [
		"class",
		"children",
	]);

	return (
		<>
			<CheckboxPrimitive.Input class="[&:focus-visible+div]:outline-none [&:focus-visible+div]:ring-[1.5px] [&:focus-visible+div]:ring-ring [&:focus-visible+div]:ring-offset-2 [&:focus-visible+div]:ring-offset-background" />
			<CheckboxPrimitive.Control
				class={cn(
					"h-4 w-4 shrink-0 rounded-sm border border-primary shadow transition-shadow focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring data-[disabled]:cursor-not-allowed data-[checked]:bg-primary data-[checked]:text-primary-foreground data-[disabled]:opacity-50",
					local.class,
				)}
				{...rest}
			>
				<CheckboxPrimitive.Indicator class="flex items-center justify-center text-current">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 24 24"
						class="h-4 w-4"
					>
						<path
							fill="none"
							stroke="currentColor"
							strokeLinecap="round"
							strokeLinejoin="round"
							strokeWidth="2"
							d="m5 12l5 5L20 7"
						/>
						<title>Checkbox</title>
					</svg>
				</CheckboxPrimitive.Indicator>
			</CheckboxPrimitive.Control>
		</>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/collapsible.tsx
```
import { cn } from "@/libs/cn";
import type { CollapsibleContentProps } from "@kobalte/core/collapsible";
import { Collapsible as CollapsiblePrimitive } from "@kobalte/core/collapsible";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const Collapsible = CollapsiblePrimitive;

export const CollapsibleTrigger = CollapsiblePrimitive.Trigger;

type collapsibleContentProps<T extends ValidComponent = "div"> =
	CollapsibleContentProps<T> & {
		class?: string;
	};

export const CollapsibleContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, collapsibleContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as collapsibleContentProps, ["class"]);

	return (
		<CollapsiblePrimitive.Content
			class={cn(
				"animate-collapsible-up data-[expanded]:animate-collapsible-down",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/combobox.tsx
```
import { cn } from "@/libs/cn";
import type {
	ComboboxContentProps,
	ComboboxInputProps,
	ComboboxItemProps,
	ComboboxTriggerProps,
} from "@kobalte/core/combobox";
import { Combobox as ComboboxPrimitive } from "@kobalte/core/combobox";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ParentProps, ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";

export const Combobox = ComboboxPrimitive;
export const ComboboxDescription = ComboboxPrimitive.Description;
export const ComboboxErrorMessage = ComboboxPrimitive.ErrorMessage;
export const ComboboxItemDescription = ComboboxPrimitive.ItemDescription;
export const ComboboxHiddenSelect = ComboboxPrimitive.HiddenSelect;

type comboboxInputProps<T extends ValidComponent = "input"> = VoidProps<
	ComboboxInputProps<T> & {
		class?: string;
	}
>;

export const ComboboxInput = <T extends ValidComponent = "input">(
	props: PolymorphicProps<T, comboboxInputProps<T>>,
) => {
	const [local, rest] = splitProps(props as comboboxInputProps, ["class"]);

	return (
		<ComboboxPrimitive.Input
			class={cn(
				"h-full bg-transparent text-sm placeholder:text-muted-foreground focus:outline-none disabled:cursor-not-allowed disabled:opacity-50",
				local.class,
			)}
			{...rest}
		/>
	);
};

type comboboxTriggerProps<T extends ValidComponent = "button"> = ParentProps<
	ComboboxTriggerProps<T> & {
		class?: string;
	}
>;

export const ComboboxTrigger = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, comboboxTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as comboboxTriggerProps, [
		"class",
		"children",
	]);

	return (
		<ComboboxPrimitive.Control>
			<ComboboxPrimitive.Trigger
				class={cn(
					"flex h-9 w-full items-center justify-between rounded-md border border-input px-3 shadow-sm",
					local.class,
				)}
				{...rest}
			>
				{local.children}
				<ComboboxPrimitive.Icon class="flex h-3.5 w-3.5 items-center justify-center">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 24 24"
						class="h-4 w-4 opacity-50"
					>
						<path
							fill="none"
							stroke="currentColor"
							strokeLinecap="round"
							strokeLinejoin="round"
							strokeWidth="2"
							d="m8 9l4-4l4 4m0 6l-4 4l-4-4"
						/>
						<title>Arrow</title>
					</svg>
				</ComboboxPrimitive.Icon>
			</ComboboxPrimitive.Trigger>
		</ComboboxPrimitive.Control>
	);
};

type comboboxContentProps<T extends ValidComponent = "div"> =
	ComboboxContentProps<T> & {
		class?: string;
	};

export const ComboboxContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, comboboxContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as comboboxContentProps, ["class"]);

	return (
		<ComboboxPrimitive.Portal>
			<ComboboxPrimitive.Content
				class={cn(
					"relative z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95 origin-[--kb-combobox-content-transform-origin]",
					local.class,
				)}
				{...rest}
			>
				<ComboboxPrimitive.Listbox class="p-1" />
			</ComboboxPrimitive.Content>
		</ComboboxPrimitive.Portal>
	);
};

type comboboxItemProps<T extends ValidComponent = "li"> = ParentProps<
	ComboboxItemProps<T> & {
		class?: string;
	}
>;

export const ComboboxItem = <T extends ValidComponent = "li">(
	props: PolymorphicProps<T, comboboxItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as comboboxItemProps, [
		"class",
		"children",
	]);

	return (
		<ComboboxPrimitive.Item
			class={cn(
				"relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-2 pr-8 text-sm outline-none data-[disabled]:pointer-events-none data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<ComboboxPrimitive.ItemIndicator class="absolute right-2 flex h-3.5 w-3.5 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-4 w-4"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m5 12l5 5L20 7"
					/>
					<title>Checked</title>
				</svg>
			</ComboboxPrimitive.ItemIndicator>
			<ComboboxPrimitive.ItemLabel>
				{local.children}
			</ComboboxPrimitive.ItemLabel>
		</ComboboxPrimitive.Item>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/command.tsx
```
import { cn } from "@/libs/cn";
import type {
	CommandDialogProps,
	CommandEmptyProps,
	CommandGroupProps,
	CommandInputProps,
	CommandItemProps,
	CommandListProps,
	CommandRootProps,
} from "cmdk-solid";
import { Command as CommandPrimitive } from "cmdk-solid";
import type { ComponentProps, VoidProps } from "solid-js";
import { splitProps } from "solid-js";
import { Dialog, DialogContent } from "./dialog";

export const Command = (props: CommandRootProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<CommandPrimitive
			class={cn(
				"flex size-full flex-col overflow-hidden bg-popover text-popover-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const CommandList = (props: CommandListProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<CommandPrimitive.List
			class={cn(
				"max-h-[300px] overflow-y-auto overflow-x-hidden p-1",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const CommandInput = (props: VoidProps<CommandInputProps>) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div class="flex items-center border-b px-3" cmdk-input-wrapper="">
			<svg
				xmlns="http://www.w3.org/2000/svg"
				viewBox="0 0 24 24"
				class="mr-2 h-4 w-4 shrink-0 opacity-50"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="M3 10a7 7 0 1 0 14 0a7 7 0 1 0-14 0m18 11l-6-6"
				/>
				<title>Search</title>
			</svg>
			<CommandPrimitive.Input
				class={cn(
					"flex h-10 w-full rounded-md bg-transparent py-3 text-sm outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50",
					local.class,
				)}
				{...rest}
			/>
		</div>
	);
};

export const CommandItem = (props: CommandItemProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<CommandPrimitive.Item
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none aria-disabled:pointer-events-none aria-disabled:opacity-50 aria-selected:bg-accent aria-selected:text-accent-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const CommandShortcut = (props: ComponentProps<"span">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<span
			class={cn(
				"ml-auto text-xs tracking-widest text-muted-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const CommandDialog = (props: CommandDialogProps) => {
	const [local, rest] = splitProps(props, ["children"]);

	return (
		<Dialog {...rest}>
			<DialogContent class="overflow-hidden p-0">
				<Command class="[&_[cmdk-group-heading]]:px-2 [&_[cmdk-group-heading]]:font-medium [&_[cmdk-group-heading]]:text-muted-foreground [&_[cmdk-group]:not([hidden])_~[cmdk-group]]:pt-0 [&_[cmdk-group]]:px-2 [&_[cmdk-input-wrapper]_svg]:size-5 [&_[cmdk-input]]:h-12 [&_[cmdk-item]]:px-2 [&_[cmdk-item]]:py-3 [&_[cmdk-item]_svg]:size-5">
					{local.children}
				</Command>
			</DialogContent>
		</Dialog>
	);
};

export const CommandEmpty = (props: CommandEmptyProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<CommandPrimitive.Empty
			class={cn("py-6 text-center text-sm", local.class)}
			{...rest}
		/>
	);
};

export const CommandGroup = (props: CommandGroupProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<CommandPrimitive.Group
			class={cn(
				"overflow-hidden p-1 text-foreground [&_[cmdk-group-heading]]:px-2 [&_[cmdk-group-heading]]:py-1.5 [&_[cmdk-group-heading]]:text-xs [&_[cmdk-group-heading]]:font-medium [&_[cmdk-group-heading]]:text-muted-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const CommandSeparator = (props: CommandEmptyProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<CommandPrimitive.Separator
			class={cn("-mx-1 h-px bg-border", local.class)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/context-menu.tsx
```
import { cn } from "@/libs/cn";
import type {
	ContextMenuCheckboxItemProps,
	ContextMenuContentProps,
	ContextMenuGroupLabelProps,
	ContextMenuItemLabelProps,
	ContextMenuItemProps,
	ContextMenuRadioItemProps,
	ContextMenuSeparatorProps,
	ContextMenuSubContentProps,
	ContextMenuSubTriggerProps,
} from "@kobalte/core/context-menu";
import { ContextMenu as ContextMenuPrimitive } from "@kobalte/core/context-menu";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	ComponentProps,
	ParentProps,
	ValidComponent,
	VoidProps,
} from "solid-js";
import { splitProps } from "solid-js";

export const ContextMenu = ContextMenuPrimitive;
export const ContextMenuTrigger = ContextMenuPrimitive.Trigger;
export const ContextMenuGroup = ContextMenuPrimitive.Group;
export const ContextMenuSub = ContextMenuPrimitive.Sub;
export const ContextMenuRadioGroup = ContextMenuPrimitive.RadioGroup;

type contextMenuSubTriggerProps<T extends ValidComponent = "div"> = ParentProps<
	ContextMenuSubTriggerProps<T> & {
		class?: string;
		inset?: boolean;
	}
>;

export const ContextMenuSubTrigger = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, contextMenuSubTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuSubTriggerProps, [
		"class",
		"children",
		"inset",
	]);

	return (
		<ContextMenuPrimitive.SubTrigger
			class={cn(
				"flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[expanded]:bg-accent data-[expanded]:text-accent-foreground",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		>
			{local.children}
			<svg
				xmlns="http://www.w3.org/2000/svg"
				class="ml-auto h-4 w-4"
				viewBox="0 0 24 24"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="m9 6l6 6l-6 6"
				/>
				<title>Arrow</title>
			</svg>
		</ContextMenuPrimitive.SubTrigger>
	);
};

type contextMenuSubContentProps<T extends ValidComponent = "div"> =
	ContextMenuSubContentProps<T> & {
		class?: string;
	};

export const ContextMenuSubContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, contextMenuSubContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuSubContentProps, [
		"class",
	]);

	return (
		<ContextMenuPrimitive.Portal>
			<ContextMenuPrimitive.SubContent
				class={cn(
					"z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-lg data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			/>
		</ContextMenuPrimitive.Portal>
	);
};

type contextMenuContentProps<T extends ValidComponent = "div"> =
	ContextMenuContentProps<T> & {
		class?: string;
	};

export const ContextMenuContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, contextMenuContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuContentProps, ["class"]);

	return (
		<ContextMenuPrimitive.Portal>
			<ContextMenuPrimitive.Content
				class={cn(
					"z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md transition-shadow focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			/>
		</ContextMenuPrimitive.Portal>
	);
};

type contextMenuItemProps<T extends ValidComponent = "div"> =
	ContextMenuItemProps<T> & {
		class?: string;
		inset?: boolean;
	};

export const ContextMenuItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, contextMenuItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuItemProps, [
		"class",
		"inset",
	]);

	return (
		<ContextMenuPrimitive.Item
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		/>
	);
};

type contextMenuCheckboxItemProps<T extends ValidComponent = "div"> =
	ParentProps<
		ContextMenuCheckboxItemProps<T> & {
			class?: string;
		}
	>;

export const ContextMenuCheckboxItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, contextMenuCheckboxItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuCheckboxItemProps, [
		"class",
		"children",
	]);

	return (
		<ContextMenuPrimitive.CheckboxItem
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<ContextMenuPrimitive.ItemIndicator class="absolute left-2 inline-flex h-3.5 w-3.5 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-4 w-4"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m5 12l5 5L20 7"
					/>
					<title>Checkbox</title>
				</svg>
			</ContextMenuPrimitive.ItemIndicator>
			{local.children}
		</ContextMenuPrimitive.CheckboxItem>
	);
};

type contextMenuRadioItemProps<T extends ValidComponent = "div"> = ParentProps<
	ContextMenuRadioItemProps<T> & {
		class?: string;
	}
>;

export const ContextMenuRadioItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, contextMenuRadioItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuRadioItemProps, [
		"class",
		"children",
	]);

	return (
		<ContextMenuPrimitive.RadioItem
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<ContextMenuPrimitive.ItemIndicator class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-2 w-2"
				>
					<g
						fill="none"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
					>
						<path d="M0 0h24v24H0z" />
						<path
							fill="currentColor"
							d="M7 3.34a10 10 0 1 1-4.995 8.984L2 12l.005-.324A10 10 0 0 1 7 3.34"
						/>
					</g>
					<title>Radio</title>
				</svg>
			</ContextMenuPrimitive.ItemIndicator>
			{local.children}
		</ContextMenuPrimitive.RadioItem>
	);
};

type contextMenuItemLabelProps<T extends ValidComponent = "div"> =
	ContextMenuItemLabelProps<T> & {
		class?: string;
		inset?: boolean;
	};

export const ContextMenuItemLabel = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, contextMenuItemLabelProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuItemLabelProps, [
		"class",
		"inset",
	]);

	return (
		<ContextMenuPrimitive.ItemLabel
			class={cn(
				"px-2 py-1.5 text-sm font-semibold text-foreground",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		/>
	);
};

type contextMenuGroupLabelProps<T extends ValidComponent = "span"> =
	ContextMenuGroupLabelProps<T> & {
		class?: string;
		inset?: boolean;
	};

export const ContextMenuGroupLabel = <T extends ValidComponent = "span">(
	props: PolymorphicProps<T, contextMenuGroupLabelProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuGroupLabelProps, [
		"class",
		"inset",
	]);

	return (
		<ContextMenuPrimitive.GroupLabel
			as="div"
			class={cn(
				"px-2 py-1.5 text-sm font-semibold text-foreground",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		/>
	);
};

type contextMenuSeparatorProps<T extends ValidComponent = "hr"> = VoidProps<
	ContextMenuSeparatorProps<T> & {
		class?: string;
	}
>;

export const ContextMenuSeparator = <T extends ValidComponent = "hr">(
	props: PolymorphicProps<T, contextMenuSeparatorProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuSeparatorProps, [
		"class",
	]);

	return (
		<ContextMenuPrimitive.Separator
			class={cn("-mx-1 my-1 h-px bg-border", local.class)}
			{...rest}
		/>
	);
};

export const ContextMenuShortcut = (props: ComponentProps<"span">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<span
			class={cn(
				"ml-auto text-xs tracking-widest text-muted-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/date-picker.tsx
```
import { cn } from "@/libs/cn";
import type {
	DatePickerContentProps,
	DatePickerInputProps,
	DatePickerRangeTextProps,
	DatePickerRootProps,
	DatePickerTableCellProps,
	DatePickerTableCellTriggerProps,
	DatePickerTableHeaderProps,
	DatePickerTableProps,
	DatePickerTableRowProps,
	DatePickerViewControlProps,
	DatePickerViewProps,
	DatePickerViewTriggerProps,
} from "@ark-ui/solid";
import { DatePicker as DatePickerPrimitive } from "@ark-ui/solid";
import type { VoidProps } from "solid-js";
import { splitProps } from "solid-js";
import { buttonVariants } from "./button";

export const DatePickerLabel = DatePickerPrimitive.Label;
export const DatePickerTableHead = DatePickerPrimitive.TableHead;
export const DatePickerTableBody = DatePickerPrimitive.TableBody;
export const DatePickerClearTrigger = DatePickerPrimitive.ClearTrigger;
export const DatePickerYearSelect = DatePickerPrimitive.YearSelect;
export const DatePickerMonthSelect = DatePickerPrimitive.MonthSelect;
export const DatePickerContext = DatePickerPrimitive.Context;
export const DatePickerRootProvider = DatePickerPrimitive.RootProvider;

export const DatePicker = (props: DatePickerRootProps) => {
	return (
		<DatePickerPrimitive.Root
			format={(e) => {
				const parsedDate = new Date(Date.parse(e.toString()));

				const normalizedDate = new Date(
					parsedDate.getUTCFullYear(),
					parsedDate.getUTCMonth(),
					parsedDate.getUTCDate(),
				);

				return new Intl.DateTimeFormat("en-US", {
					dateStyle: "long",
				}).format(normalizedDate);
			}}
			{...props}
		/>
	);
};

export const DatePickerView = (props: DatePickerViewProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.View class={cn("space-y-4", local.class)} {...rest} />
	);
};

export const DatePickerViewControl = (props: DatePickerViewControlProps) => {
	const [local, rest] = splitProps(props, ["class", "children"]);

	return (
		<DatePickerPrimitive.ViewControl
			class={cn("flex items-center justify-between", local.class)}
			{...rest}
		>
			<DatePickerPrimitive.PrevTrigger
				class={cn(
					buttonVariants({
						variant: "outline",
					}),
					"h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100",
				)}
			>
				<svg
					xmlns="http://www.w3.org/2000/svg"
					class="h-4 w-4"
					viewBox="0 0 24 24"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m15 6l-6 6l6 6"
					/>
					<title>Previous</title>
				</svg>
			</DatePickerPrimitive.PrevTrigger>
			{local.children}
			<DatePickerPrimitive.NextTrigger
				class={cn(
					buttonVariants({
						variant: "outline",
					}),
					"h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100",
				)}
			>
				<svg
					xmlns="http://www.w3.org/2000/svg"
					class="h-4 w-4"
					viewBox="0 0 24 24"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m9 6l6 6l-6 6"
					/>
					<title>Next</title>
				</svg>
			</DatePickerPrimitive.NextTrigger>
		</DatePickerPrimitive.ViewControl>
	);
};

export const DatePickerRangeText = (
	props: VoidProps<DatePickerRangeTextProps>,
) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.RangeText
			class={cn("text-sm font-medium", local.class)}
			{...rest}
		/>
	);
};

export const DatePickerTable = (props: DatePickerTableProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.Table
			class={cn("w-full border-collapse space-y-1", local.class)}
			{...rest}
		/>
	);
};

export const DatePickerTableRow = (props: DatePickerTableRowProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.TableRow
			class={cn("mt-2 flex w-full", local.class)}
			{...rest}
		/>
	);
};

export const DatePickerTableHeader = (props: DatePickerTableHeaderProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.TableHeader
			class={cn(
				"w-8 flex-1 text-[0.8rem] font-normal text-muted-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const DatePickerTableCell = (props: DatePickerTableCellProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.TableCell
			class={cn(
				"flex-1 p-0 text-center text-sm",
				"has-[[data-in-range]]:bg-accent has-[[data-in-range]]:first-of-type:rounded-l-md has-[[data-in-range]]:last-of-type:rounded-r-md",
				"has-[[data-range-end]]:rounded-r-md has-[[data-range-start]]:rounded-l-md",
				"has-[[data-outside-range][data-in-range]]:bg-accent/50",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const DatePickerTableCellTrigger = (
	props: DatePickerTableCellTriggerProps,
) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.TableCellTrigger
			class={cn(
				buttonVariants({ variant: "ghost" }),
				"size-8 w-full p-0 font-normal data-[selected]:opacity-100",
				"data-[today]:bg-accent data-[today]:text-accent-foreground",
				"[&:is([data-today][data-selected])]:bg-primary [&:is([data-today][data-selected])]:text-primary-foreground",
				"data-[selected]:bg-primary data-[selected]:text-primary-foreground data-[selected]:hover:bg-primary data-[selected]:hover:text-primary-foreground",
				"data-[disabled]:text-muted-foreground data-[disabled]:opacity-50",
				"data-[outside-range]:text-muted-foreground data-[outside-range]:opacity-50",
				"[&:is([data-outside-range][data-in-range])]:bg-accent/50 [&:is([data-outside-range][data-in-range])]:text-muted-foreground [&:is([data-outside-range][data-in-range])]:opacity-30",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const DatePickerViewTrigger = (props: DatePickerViewTriggerProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.ViewTrigger
			class={cn(buttonVariants({ variant: "ghost" }), "h-7", local.class)}
			{...rest}
		/>
	);
};

export const DatePickerContent = (props: DatePickerContentProps) => {
	const [local, rest] = splitProps(props, ["class", "children"]);

	return (
		<DatePickerPrimitive.Positioner>
			<DatePickerPrimitive.Content
				class={cn(
					"rounded-md border bg-popover p-3 text-popover-foreground shadow-md outline-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 z-50",
					local.class,
				)}
				{...rest}
			>
				{local.children}
			</DatePickerPrimitive.Content>
		</DatePickerPrimitive.Positioner>
	);
};

export const DatePickerInput = (props: DatePickerInputProps) => {
	const [local, rest] = splitProps(props, ["class", "children"]);

	return (
		<DatePickerPrimitive.Control class="flex h-9 w-full rounded-md border border-input bg-background px-3 py-1 text-sm shadow-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50">
			<DatePickerPrimitive.Input
				class={cn(
					"w-full appearance-none bg-transparent outline-none",
					local.class,
				)}
				{...rest}
			/>
			<DatePickerPrimitive.Trigger class="transition-shadow focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					class="mx-1 h-4 w-4"
					viewBox="0 0 24 24"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="M4 7a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2zm12-4v4M8 3v4m-4 4h16m-9 4h1m0 0v3"
					/>
					<title>Calendar</title>
				</svg>
			</DatePickerPrimitive.Trigger>
		</DatePickerPrimitive.Control>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/dialog.tsx
```
import { cn } from "@/libs/cn";
import type {
	DialogContentProps,
	DialogDescriptionProps,
	DialogTitleProps,
} from "@kobalte/core/dialog";
import { Dialog as DialogPrimitive } from "@kobalte/core/dialog";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ComponentProps, ParentProps, ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const Dialog = DialogPrimitive;
export const DialogTrigger = DialogPrimitive.Trigger;

type dialogContentProps<T extends ValidComponent = "div"> = ParentProps<
	DialogContentProps<T> & {
		class?: string;
	}
>;

export const DialogContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dialogContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as dialogContentProps, [
		"class",
		"children",
	]);

	return (
		<DialogPrimitive.Portal>
			<DialogPrimitive.Overlay
				class={cn(
					"fixed inset-0 z-50 bg-background/80 data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0",
				)}
				{...rest}
			/>
			<DialogPrimitive.Content
				class={cn(
					"fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border bg-background p-6 shadow-lg data-[closed]:duration-200 data-[expanded]:duration-200 data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95 data-[closed]:slide-out-to-left-1/2 data-[closed]:slide-out-to-top-[48%] data-[expanded]:slide-in-from-left-1/2 data-[expanded]:slide-in-from-top-[48%] sm:rounded-lg md:w-full",
					local.class,
				)}
				{...rest}
			>
				{local.children}
				<DialogPrimitive.CloseButton class="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-[opacity,box-shadow] hover:opacity-100 focus:outline-none focus:ring-[1.5px] focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 24 24"
						class="h-4 w-4"
					>
						<path
							fill="none"
							stroke="currentColor"
							strokeLinecap="round"
							strokeLinejoin="round"
							strokeWidth="2"
							d="M18 6L6 18M6 6l12 12"
						/>
						<title>Close</title>
					</svg>
				</DialogPrimitive.CloseButton>
			</DialogPrimitive.Content>
		</DialogPrimitive.Portal>
	);
};

type dialogTitleProps<T extends ValidComponent = "h2"> = DialogTitleProps<T> & {
	class?: string;
};

export const DialogTitle = <T extends ValidComponent = "h2">(
	props: PolymorphicProps<T, dialogTitleProps<T>>,
) => {
	const [local, rest] = splitProps(props as dialogTitleProps, ["class"]);

	return (
		<DialogPrimitive.Title
			class={cn("text-lg font-semibold text-foreground", local.class)}
			{...rest}
		/>
	);
};

type dialogDescriptionProps<T extends ValidComponent = "p"> =
	DialogDescriptionProps<T> & {
		class?: string;
	};

export const DialogDescription = <T extends ValidComponent = "p">(
	props: PolymorphicProps<T, dialogDescriptionProps<T>>,
) => {
	const [local, rest] = splitProps(props as dialogDescriptionProps, ["class"]);

	return (
		<DialogPrimitive.Description
			class={cn("text-sm text-muted-foreground", local.class)}
			{...rest}
		/>
	);
};

export const DialogHeader = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"flex flex-col space-y-2 text-center sm:text-left",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const DialogFooter = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/drawer.tsx
```
import { cn } from "@/libs/cn";
import type {
	ContentProps,
	DescriptionProps,
	DynamicProps,
	LabelProps,
} from "@corvu/drawer";
import DrawerPrimitive from "@corvu/drawer";
import type { ComponentProps, ParentProps, ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const Drawer = DrawerPrimitive;
export const DrawerTrigger = DrawerPrimitive.Trigger;
export const DrawerClose = DrawerPrimitive.Close;

type drawerContentProps<T extends ValidComponent = "div"> = ParentProps<
	ContentProps<T> & {
		class?: string;
	}
>;

export const DrawerContent = <T extends ValidComponent = "div">(
	props: DynamicProps<T, drawerContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as drawerContentProps, [
		"class",
		"children",
	]);
	const ctx = DrawerPrimitive.useContext();

	return (
		<DrawerPrimitive.Portal>
			<DrawerPrimitive.Overlay
				class="fixed inset-0 z-50 data-[transitioning]:transition-colors data-[transitioning]:duration-200"
				style={{
					"background-color": `hsl(var(--background) / ${
						0.8 * ctx.openPercentage()
					})`,
				}}
			/>
			<DrawerPrimitive.Content
				class={cn(
					"fixed inset-x-0 bottom-0 z-50 mt-24 flex h-auto flex-col rounded-t-xl border bg-background after:absolute after:inset-x-0 after:top-full after:h-[50%] after:bg-inherit data-[transitioning]:transition-transform data-[transitioning]:duration-200 md:select-none",
					local.class,
				)}
				{...rest}
			>
				<div class="mx-auto mt-4 h-2 w-[100px] rounded-full bg-muted" />
				{local.children}
			</DrawerPrimitive.Content>
		</DrawerPrimitive.Portal>
	);
};

export const DrawerHeader = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn("grid gap-1.5 p-4 text-center sm:text-left", local.class)}
			{...rest}
		/>
	);
};

export const DrawerFooter = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div class={cn("mt-auto flex flex-col gap-2 p-4", local.class)} {...rest} />
	);
};

type DrawerLabelProps = LabelProps & {
	class?: string;
};

export const DrawerLabel = <T extends ValidComponent = "h2">(
	props: DynamicProps<T, DrawerLabelProps>,
) => {
	const [local, rest] = splitProps(props as DrawerLabelProps, ["class"]);

	return (
		<DrawerPrimitive.Label
			class={cn(
				"text-lg font-semibold leading-none tracking-tight",
				local.class,
			)}
			{...rest}
		/>
	);
};

type DrawerDescriptionProps = DescriptionProps & {
	class?: string;
};

export const DrawerDescription = <T extends ValidComponent = "p">(
	props: DynamicProps<T, DrawerDescriptionProps>,
) => {
	const [local, rest] = splitProps(props as DrawerDescriptionProps, ["class"]);

	return (
		<DrawerPrimitive.Description
			class={cn("text-sm text-muted-foreground", local.class)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/dropdown-menu.tsx
```
import { cn } from "@/libs/cn";
import type {
	DropdownMenuCheckboxItemProps,
	DropdownMenuContentProps,
	DropdownMenuGroupLabelProps,
	DropdownMenuItemLabelProps,
	DropdownMenuItemProps,
	DropdownMenuRadioItemProps,
	DropdownMenuRootProps,
	DropdownMenuSeparatorProps,
	DropdownMenuSubTriggerProps,
} from "@kobalte/core/dropdown-menu";
import { DropdownMenu as DropdownMenuPrimitive } from "@kobalte/core/dropdown-menu";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ComponentProps, ParentProps, ValidComponent } from "solid-js";
import { mergeProps, splitProps } from "solid-js";

export const DropdownMenuTrigger = DropdownMenuPrimitive.Trigger;
export const DropdownMenuGroup = DropdownMenuPrimitive.Group;
export const DropdownMenuSub = DropdownMenuPrimitive.Sub;
export const DropdownMenuRadioGroup = DropdownMenuPrimitive.RadioGroup;

export const DropdownMenu = (props: DropdownMenuRootProps) => {
	const merge = mergeProps<DropdownMenuRootProps[]>({ gutter: 4 }, props);

	return <DropdownMenuPrimitive {...merge} />;
};

type dropdownMenuContentProps<T extends ValidComponent = "div"> =
	DropdownMenuContentProps<T> & {
		class?: string;
	};

export const DropdownMenuContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dropdownMenuContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuContentProps, [
		"class",
	]);

	return (
		<DropdownMenuPrimitive.Portal>
			<DropdownMenuPrimitive.Content
				class={cn(
					"min-w-8rem z-50 overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md transition-shadow focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			/>
		</DropdownMenuPrimitive.Portal>
	);
};

type dropdownMenuItemProps<T extends ValidComponent = "div"> =
	DropdownMenuItemProps<T> & {
		class?: string;
		inset?: boolean;
	};

export const DropdownMenuItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dropdownMenuItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuItemProps, [
		"class",
		"inset",
	]);

	return (
		<DropdownMenuPrimitive.Item
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		/>
	);
};

type dropdownMenuGroupLabelProps<T extends ValidComponent = "span"> =
	DropdownMenuGroupLabelProps<T> & {
		class?: string;
	};

export const DropdownMenuGroupLabel = <T extends ValidComponent = "span">(
	props: PolymorphicProps<T, dropdownMenuGroupLabelProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuGroupLabelProps, [
		"class",
	]);

	return (
		<DropdownMenuPrimitive.GroupLabel
			as="div"
			class={cn("px-2 py-1.5 text-sm font-semibold", local.class)}
			{...rest}
		/>
	);
};

type dropdownMenuItemLabelProps<T extends ValidComponent = "div"> =
	DropdownMenuItemLabelProps<T> & {
		class?: string;
	};

export const DropdownMenuItemLabel = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dropdownMenuItemLabelProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuItemLabelProps, [
		"class",
	]);

	return (
		<DropdownMenuPrimitive.ItemLabel
			as="div"
			class={cn("px-2 py-1.5 text-sm font-semibold", local.class)}
			{...rest}
		/>
	);
};

type dropdownMenuSeparatorProps<T extends ValidComponent = "hr"> =
	DropdownMenuSeparatorProps<T> & {
		class?: string;
	};

export const DropdownMenuSeparator = <T extends ValidComponent = "hr">(
	props: PolymorphicProps<T, dropdownMenuSeparatorProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuSeparatorProps, [
		"class",
	]);

	return (
		<DropdownMenuPrimitive.Separator
			class={cn("-mx-1 my-1 h-px bg-muted", local.class)}
			{...rest}
		/>
	);
};

export const DropdownMenuShortcut = (props: ComponentProps<"span">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<span
			class={cn("ml-auto text-xs tracking-widest opacity-60", local.class)}
			{...rest}
		/>
	);
};

type dropdownMenuSubTriggerProps<T extends ValidComponent = "div"> =
	ParentProps<
		DropdownMenuSubTriggerProps<T> & {
			class?: string;
		}
	>;

export const DropdownMenuSubTrigger = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dropdownMenuSubTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuSubTriggerProps, [
		"class",
		"children",
	]);

	return (
		<DropdownMenuPrimitive.SubTrigger
			class={cn(
				"flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent data-[expanded]:bg-accent",
				local.class,
			)}
			{...rest}
		>
			{local.children}
			<svg
				xmlns="http://www.w3.org/2000/svg"
				width="1em"
				height="1em"
				viewBox="0 0 24 24"
				class="ml-auto h-4 w-4"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="m9 6l6 6l-6 6"
				/>
				<title>Arrow</title>
			</svg>
		</DropdownMenuPrimitive.SubTrigger>
	);
};

type dropdownMenuSubContentProps<T extends ValidComponent = "div"> =
	DropdownMenuSubTriggerProps<T> & {
		class?: string;
	};

export const DropdownMenuSubContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dropdownMenuSubContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuSubContentProps, [
		"class",
	]);

	return (
		<DropdownMenuPrimitive.Portal>
			<DropdownMenuPrimitive.SubContent
				class={cn(
					"min-w-8rem z-50 overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			/>
		</DropdownMenuPrimitive.Portal>
	);
};

type dropdownMenuCheckboxItemProps<T extends ValidComponent = "div"> =
	ParentProps<
		DropdownMenuCheckboxItemProps<T> & {
			class?: string;
		}
	>;

export const DropdownMenuCheckboxItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dropdownMenuCheckboxItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuCheckboxItemProps, [
		"class",
		"children",
	]);

	return (
		<DropdownMenuPrimitive.CheckboxItem
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<DropdownMenuPrimitive.ItemIndicator class="absolute left-2 inline-flex h-4 w-4 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-4 w-4"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m5 12l5 5L20 7"
					/>
					<title>Checkbox</title>
				</svg>
			</DropdownMenuPrimitive.ItemIndicator>
			{props.children}
		</DropdownMenuPrimitive.CheckboxItem>
	);
};

type dropdownMenuRadioItemProps<T extends ValidComponent = "div"> = ParentProps<
	DropdownMenuRadioItemProps<T> & {
		class?: string;
	}
>;

export const DropdownMenuRadioItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dropdownMenuRadioItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuRadioItemProps, [
		"class",
		"children",
	]);

	return (
		<DropdownMenuPrimitive.RadioItem
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<DropdownMenuPrimitive.ItemIndicator class="absolute left-2 inline-flex h-4 w-4 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-2 w-2"
				>
					<g
						fill="none"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
					>
						<path d="M0 0h24v24H0z" />
						<path
							fill="currentColor"
							d="M7 3.34a10 10 0 1 1-4.995 8.984L2 12l.005-.324A10 10 0 0 1 7 3.34"
						/>
					</g>
					<title>Radio</title>
				</svg>
			</DropdownMenuPrimitive.ItemIndicator>
			{props.children}
		</DropdownMenuPrimitive.RadioItem>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/hover-card.tsx
```
import { cn } from "@/libs/cn";
import type { HoverCardContentProps } from "@kobalte/core/hover-card";
import { HoverCard as HoverCardPrimitive } from "@kobalte/core/hover-card";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const HoverCard = HoverCardPrimitive;
export const HoverCardTrigger = HoverCardPrimitive.Trigger;

type hoverCardContentProps<T extends ValidComponent = "div"> =
	HoverCardContentProps<T> & {
		class?: string;
	};

export const HoverCardContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, hoverCardContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as hoverCardContentProps, ["class"]);

	return (
		<HoverCardPrimitive.Portal>
			<HoverCardPrimitive.Content
				class={cn(
					"z-50 w-64 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			/>
		</HoverCardPrimitive.Portal>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/image.tsx
```
import { cn } from "@/libs/cn";
import type {
	ImageFallbackProps,
	ImageImgProps,
	ImageRootProps,
} from "@kobalte/core/image";
import { Image as ImagePrimitive } from "@kobalte/core/image";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

type imageRootProps<T extends ValidComponent = "span"> = ImageRootProps<T> & {
	class?: string;
};

export const ImageRoot = <T extends ValidComponent = "span">(
	props: PolymorphicProps<T, imageRootProps<T>>,
) => {
	const [local, rest] = splitProps(props as imageRootProps, ["class"]);

	return (
		<ImagePrimitive
			class={cn(
				"relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full",
				local.class,
			)}
			{...rest}
		/>
	);
};

type imageProps<T extends ValidComponent = "img"> = ImageImgProps<T> & {
	class?: string;
};

export const Image = <T extends ValidComponent = "img">(
	props: PolymorphicProps<T, imageProps<T>>,
) => {
	const [local, rest] = splitProps(props as imageProps, ["class"]);

	return (
		<ImagePrimitive.Img
			class={cn("aspect-square h-full w-full", local.class)}
			{...rest}
		/>
	);
};

type imageFallbackProps<T extends ValidComponent = "span"> =
	ImageFallbackProps<T> & {
		class?: string;
	};

export const ImageFallback = <T extends ValidComponent = "span">(
	props: PolymorphicProps<T, imageFallbackProps<T>>,
) => {
	const [local, rest] = splitProps(props as imageFallbackProps, ["class"]);

	return (
		<ImagePrimitive.Fallback
			class={cn(
				"flex h-full w-full items-center justify-center rounded-full bg-muted",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/menubar.tsx
```
import { cn } from "@/libs/cn";
import type {
	MenubarCheckboxItemProps,
	MenubarContentProps,
	MenubarItemLabelProps,
	MenubarItemProps,
	MenubarMenuProps,
	MenubarRadioItemProps,
	MenubarRootProps,
	MenubarSeparatorProps,
	MenubarSubContentProps,
	MenubarSubTriggerProps,
	MenubarTriggerProps,
} from "@kobalte/core/menubar";
import { Menubar as MenubarPrimitive } from "@kobalte/core/menubar";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ComponentProps, ParentProps, ValidComponent } from "solid-js";
import { mergeProps, splitProps } from "solid-js";

export const MenubarSub = MenubarPrimitive.Sub;
export const MenubarRadioGroup = MenubarPrimitive.RadioGroup;

type menubarProps<T extends ValidComponent = "div"> = MenubarRootProps<T> & {
	class?: string;
};

export const Menubar = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, menubarProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarProps, ["class"]);

	return (
		<MenubarPrimitive
			class={cn(
				"flex h-9 items-center space-x-1 rounded-md border bg-background p-1 shadow-sm",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const MenubarMenu = (props: MenubarMenuProps) => {
	const merge = mergeProps<MenubarMenuProps[]>({ gutter: 8, shift: -4 }, props);

	return <MenubarPrimitive.Menu {...merge} />;
};

type menubarTriggerProps<T extends ValidComponent = "button"> =
	MenubarTriggerProps<T> & {
		class?: string;
	};

export const MenubarTrigger = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, menubarTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarTriggerProps, ["class"]);

	return (
		<MenubarPrimitive.Trigger
			class={cn(
				"flex cursor-default select-none items-center rounded-sm px-3 py-1 text-sm font-medium outline-none focus:bg-accent focus:text-accent-foreground data-[expanded]:bg-accent data-[expanded]:text-accent-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

type menubarSubTriggerProps<T extends ValidComponent = "button"> = ParentProps<
	MenubarSubTriggerProps<T> & {
		class?: string;
		inset?: boolean;
	}
>;

export const MenubarSubTrigger = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, menubarSubTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarSubTriggerProps, [
		"class",
		"children",
		"inset",
	]);

	return (
		<MenubarPrimitive.SubTrigger
			class={cn(
				"flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[expanded]:bg-accent data-[expanded]:text-accent-foreground",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		>
			{local.children}
			<svg
				xmlns="http://www.w3.org/2000/svg"
				width="1em"
				height="1em"
				viewBox="0 0 24 24"
				class="ml-auto h-4 w-4"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="m9 6l6 6l-6 6"
				/>
				<title>Arrow</title>
			</svg>
		</MenubarPrimitive.SubTrigger>
	);
};

type menubarSubContentProps<T extends ValidComponent = "div"> = ParentProps<
	MenubarSubContentProps<T> & {
		class?: string;
	}
>;

export const MenubarSubContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, menubarSubContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarSubContentProps, [
		"class",
		"children",
	]);

	return (
		<MenubarPrimitive.Portal>
			<MenubarPrimitive.SubContent
				class={cn(
					"z-50 min-w-[8rem] origin-[--kb-menu-content-transform-origin] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-lg outline-none data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			>
				{local.children}
			</MenubarPrimitive.SubContent>
		</MenubarPrimitive.Portal>
	);
};

type menubarContentProps<T extends ValidComponent = "div"> = ParentProps<
	MenubarContentProps<T> & {
		class?: string;
	}
>;

export const MenubarContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, menubarContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarContentProps, [
		"class",
		"children",
	]);

	return (
		<MenubarPrimitive.Portal>
			<MenubarPrimitive.Content
				class={cn(
					"z-50 min-w-[12rem] origin-[--kb-menu-content-transform-origin] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md outline-none data-[expanded]:animate-in data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			>
				{local.children}
			</MenubarPrimitive.Content>
		</MenubarPrimitive.Portal>
	);
};

type menubarItemProps<T extends ValidComponent = "div"> =
	MenubarItemProps<T> & {
		class?: string;
		inset?: boolean;
	};

export const MenubarItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, menubarItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarItemProps, [
		"class",
		"inset",
	]);

	return (
		<MenubarPrimitive.Item
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		/>
	);
};

type menubarItemLabelProps<T extends ValidComponent = "div"> =
	MenubarItemLabelProps<T> & {
		class?: string;
		inset?: boolean;
	};

export const MenubarItemLabel = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, menubarItemLabelProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarItemLabelProps, [
		"class",
		"inset",
	]);

	return (
		<MenubarPrimitive.ItemLabel
			class={cn(
				"px-2 py-1.5 text-sm font-semibold",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		/>
	);
};

type menubarSeparatorProps<T extends ValidComponent = "hr"> =
	MenubarSeparatorProps<T> & {
		class?: string;
	};

export const MenubarSeparator = <T extends ValidComponent = "hr">(
	props: PolymorphicProps<T, menubarSeparatorProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarSeparatorProps, ["class"]);

	return (
		<MenubarPrimitive.Separator
			class={cn("-mx-1 my-1 h-px bg-muted", local.class)}
			{...rest}
		/>
	);
};

type menubarCheckboxItemProps<T extends ValidComponent = "div"> = ParentProps<
	MenubarCheckboxItemProps<T> & {
		class?: string;
	}
>;

export const MenubarCheckboxItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, menubarCheckboxItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarCheckboxItemProps, [
		"class",
		"children",
	]);

	return (
		<MenubarPrimitive.CheckboxItem
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<MenubarPrimitive.ItemIndicator class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-4 w-4"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m5 12l5 5L20 7"
					/>
					<title>Checkbox</title>
				</svg>
			</MenubarPrimitive.ItemIndicator>
			{local.children}
		</MenubarPrimitive.CheckboxItem>
	);
};

type menubarRadioItemProps<T extends ValidComponent = "div"> = ParentProps<
	MenubarRadioItemProps<T> & {
		class?: string;
	}
>;

export const MenubarRadioItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, menubarRadioItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarRadioItemProps, [
		"class",
		"children",
	]);

	return (
		<MenubarPrimitive.RadioItem
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<MenubarPrimitive.ItemIndicator class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-2 w-2"
				>
					<g
						fill="none"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
					>
						<path d="M0 0h24v24H0z" />
						<path
							fill="currentColor"
							d="M7 3.34a10 10 0 1 1-4.995 8.984L2 12l.005-.324A10 10 0 0 1 7 3.34"
						/>
					</g>
					<title>Radio</title>
				</svg>
			</MenubarPrimitive.ItemIndicator>
			{local.children}
		</MenubarPrimitive.RadioItem>
	);
};

export const MenubarShortcut = (props: ComponentProps<"span">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<span
			class={cn(
				"ml-auto text-xs tracking-widest text-muted-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/navigation-menu.tsx
```
import { cn } from "@/libs/cn";
import type {
	NavigationMenuContentProps,
	NavigationMenuRootProps,
	NavigationMenuTriggerProps,
} from "@kobalte/core/navigation-menu";
import { NavigationMenu as NavigationMenuPrimitive } from "@kobalte/core/navigation-menu";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import {
	type ParentProps,
	Show,
	type ValidComponent,
	mergeProps,
	splitProps,
} from "solid-js";

export const NavigationMenuItem = NavigationMenuPrimitive.Menu;
export const NavigationMenuLink = NavigationMenuPrimitive.Item;
export const NavigationMenuItemLabel = NavigationMenuPrimitive.ItemLabel;
export const NavigationMenuDescription =
	NavigationMenuPrimitive.ItemDescription;
export const NavigationMenuItemIndicator =
	NavigationMenuPrimitive.ItemIndicator;
export const NavigationMenuSub = NavigationMenuPrimitive.Sub;
export const NavigationMenuSubTrigger = NavigationMenuPrimitive.SubTrigger;
export const NavigationMenuSubContent = NavigationMenuPrimitive.SubContent;
export const NavigationMenuRadioGroup = NavigationMenuPrimitive.RadioGroup;
export const NavigationMenuRadioItem = NavigationMenuPrimitive.RadioItem;
export const NavigationMenuCheckboxItem = NavigationMenuPrimitive.CheckboxItem;
export const NavigationMenuSeparator = NavigationMenuPrimitive.Separator;

type withArrow = {
	withArrow?: boolean;
};

type navigationMenuProps<T extends ValidComponent = "ul"> = ParentProps<
	NavigationMenuRootProps<T> &
		withArrow & {
			class?: string;
		}
>;

export const NavigationMenu = <T extends ValidComponent = "ul">(
	props: PolymorphicProps<T, navigationMenuProps<T>>,
) => {
	const merge = mergeProps<navigationMenuProps<T>[]>(
		{
			get gutter() {
				return props.withArrow ? props.gutter : 6;
			},
			withArrow: false,
		},
		props,
	);
	const [local, rest] = splitProps(merge as navigationMenuProps, [
		"class",
		"children",
		"withArrow",
	]);

	return (
		<NavigationMenuPrimitive
			class={cn("flex w-max items-center justify-center gap-x-1", local.class)}
			{...rest}
		>
			{local.children}
			<NavigationMenuPrimitive.Viewport
				class={cn(
					"pointer-events-none z-50 overflow-x-clip overflow-y-visible rounded-md border bg-popover text-popover-foreground shadow",
					"h-[--kb-navigation-menu-viewport-height] w-[--kb-navigation-menu-viewport-width] transition-[width,height] duration-300",
					"origin-[--kb-menu-content-transform-origin]",
					"data-[expanded]:duration-300 data-[expanded]:animate-in data-[expanded]:fade-in data-[expanded]:zoom-in-95",
					"data-[closed]:duration-300 data-[closed]:animate-out data-[closed]:fade-out data-[closed]:zoom-out-95",
				)}
			>
				<Show when={local.withArrow}>
					<NavigationMenuPrimitive.Arrow class="transition-transform duration-300" />
				</Show>
			</NavigationMenuPrimitive.Viewport>
		</NavigationMenuPrimitive>
	);
};

type navigationMenuTriggerProps<T extends ValidComponent = "button"> =
	ParentProps<
		NavigationMenuTriggerProps<T> &
			withArrow & {
				class?: string;
			}
	>;

export const NavigationMenuTrigger = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, navigationMenuTriggerProps<T>>,
) => {
	const merge = mergeProps<navigationMenuTriggerProps<T>[]>(
		{
			get withArrow() {
				return props.as === undefined ? true : props.withArrow;
			},
		},
		props,
	);
	const [local, rest] = splitProps(merge as navigationMenuTriggerProps, [
		"class",
		"children",
		"withArrow",
	]);

	return (
		<NavigationMenuPrimitive.Trigger
			class={cn(
				"inline-flex w-max items-center justify-center rounded-md bg-background px-4 py-2 text-sm font-medium outline-none transition-colors duration-300 hover:bg-accent hover:text-accent-foreground disabled:pointer-events-none disabled:opacity-50",
				local.class,
			)}
			{...rest}
		>
			{local.children}
			<Show when={local.withArrow}>
				<NavigationMenuPrimitive.Icon
					class="ml-1 size-3 transition-transform duration-300 data-[expanded]:rotate-180"
					as="svg"
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m6 9l6 6l6-6"
					/>
				</NavigationMenuPrimitive.Icon>
			</Show>
		</NavigationMenuPrimitive.Trigger>
	);
};

type navigationMenuContentProps<T extends ValidComponent = "ul"> = ParentProps<
	NavigationMenuContentProps<T> & {
		class?: string;
	}
>;

export const NavigationMenuContent = <T extends ValidComponent = "ul">(
	props: PolymorphicProps<T, navigationMenuContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as navigationMenuContentProps, [
		"class",
		"children",
	]);

	return (
		<NavigationMenuPrimitive.Portal>
			<NavigationMenuPrimitive.Content
				class={cn(
					"absolute left-0 top-0 p-4 outline-none",
					"data-[motion^=from-]:duration-300 data-[motion^=from-]:animate-in data-[motion^=from-]:fade-in data-[motion=from-end]:slide-in-from-right-52 data-[motion=from-start]:slide-in-from-left-52",
					"data-[motion^=to-]:duration-300 data-[motion^=to-]:animate-out data-[motion^=to-]:fade-out data-[motion=to-end]:slide-out-to-right-52 data-[motion=to-start]:slide-out-to-left-52",
					local.class,
				)}
				{...rest}
			>
				{local.children}
			</NavigationMenuPrimitive.Content>
		</NavigationMenuPrimitive.Portal>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/number-field.tsx
```
import { cn } from "@/libs/cn";
import type {
	NumberFieldDecrementTriggerProps,
	NumberFieldDescriptionProps,
	NumberFieldErrorMessageProps,
	NumberFieldIncrementTriggerProps,
	NumberFieldInputProps,
	NumberFieldLabelProps,
	NumberFieldRootProps,
} from "@kobalte/core/number-field";
import { NumberField as NumberFieldPrimitive } from "@kobalte/core/number-field";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ComponentProps, ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";
import { textfieldLabel } from "./textfield";

export const NumberFieldHiddenInput = NumberFieldPrimitive.HiddenInput;

type numberFieldLabelProps<T extends ValidComponent = "div"> =
	NumberFieldLabelProps<T> & {
		class?: string;
	};

export const NumberFieldLabel = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, numberFieldLabelProps<T>>,
) => {
	const [local, rest] = splitProps(props as numberFieldLabelProps, ["class"]);

	return (
		<NumberFieldPrimitive.Label
			class={cn(textfieldLabel({ label: true }), local.class)}
			{...rest}
		/>
	);
};

type numberFieldDescriptionProps<T extends ValidComponent = "div"> =
	NumberFieldDescriptionProps<T> & {
		class?: string;
	};

export const NumberFieldDescription = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, numberFieldDescriptionProps<T>>,
) => {
	const [local, rest] = splitProps(props as numberFieldDescriptionProps, [
		"class",
	]);

	return (
		<NumberFieldPrimitive.Description
			class={cn(
				textfieldLabel({ description: true, label: false }),
				local.class,
			)}
			{...rest}
		/>
	);
};

type numberFieldErrorMessageProps<T extends ValidComponent = "div"> =
	NumberFieldErrorMessageProps<T> & {
		class?: string;
	};

export const NumberFieldErrorMessage = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, numberFieldErrorMessageProps<T>>,
) => {
	const [local, rest] = splitProps(props as numberFieldErrorMessageProps, [
		"class",
	]);

	return (
		<NumberFieldPrimitive.ErrorMessage
			class={cn(textfieldLabel({ error: true }), local.class)}
			{...rest}
		/>
	);
};

type numberFieldProps<T extends ValidComponent = "div"> =
	NumberFieldRootProps<T> & {
		class?: string;
	};

export const NumberField = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, numberFieldProps<T>>,
) => {
	const [local, rest] = splitProps(props as numberFieldProps, ["class"]);

	return (
		<NumberFieldPrimitive class={cn("grid gap-1.5", local.class)} {...rest} />
	);
};

export const NumberFieldGroup = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"relative rounded-md transition-shadow focus-within:outline-none focus-within:ring-[1.5px] focus-within:ring-ring",
				local.class,
			)}
			{...rest}
		/>
	);
};

type numberFieldInputProps<T extends ValidComponent = "input"> =
	NumberFieldInputProps<T> & {
		class?: string;
	};

export const NumberFieldInput = <T extends ValidComponent = "input">(
	props: PolymorphicProps<T, VoidProps<numberFieldInputProps<T>>>,
) => {
	const [local, rest] = splitProps(props as numberFieldInputProps, ["class"]);

	return (
		<NumberFieldPrimitive.Input
			class={cn(
				"flex h-9 w-full rounded-md border border-input bg-transparent px-10 py-1 text-center text-sm shadow-sm placeholder:text-muted-foreground focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-50",
				local.class,
			)}
			{...rest}
		/>
	);
};

type numberFieldDecrementTriggerProps<T extends ValidComponent = "button"> =
	VoidProps<
		NumberFieldDecrementTriggerProps<T> & {
			class?: string;
		}
	>;

export const NumberFieldDecrementTrigger = <
	T extends ValidComponent = "button",
>(
	props: PolymorphicProps<T, VoidProps<numberFieldDecrementTriggerProps<T>>>,
) => {
	const [local, rest] = splitProps(props as numberFieldDecrementTriggerProps, [
		"class",
	]);

	return (
		<NumberFieldPrimitive.DecrementTrigger
			class={cn(
				"absolute left-0 top-1/2 -translate-y-1/2 p-3 disabled:cursor-not-allowed disabled:opacity-20",
				local.class,
			)}
			{...rest}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				class="size-4"
				viewBox="0 0 24 24"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="M5 12h14"
				/>
				<title>Decreasing number</title>
			</svg>
		</NumberFieldPrimitive.DecrementTrigger>
	);
};

type numberFieldIncrementTriggerProps<T extends ValidComponent = "button"> =
	VoidProps<
		NumberFieldIncrementTriggerProps<T> & {
			class?: string;
		}
	>;

export const NumberFieldIncrementTrigger = <
	T extends ValidComponent = "button",
>(
	props: PolymorphicProps<T, numberFieldIncrementTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as numberFieldIncrementTriggerProps, [
		"class",
	]);

	return (
		<NumberFieldPrimitive.IncrementTrigger
			class={cn(
				"absolute right-0 top-1/2 -translate-y-1/2 p-3 disabled:cursor-not-allowed disabled:opacity-20",
				local.class,
			)}
			{...rest}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				class="size-4"
				viewBox="0 0 24 24"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="M12 5v14m-7-7h14"
				/>
				<title>Increase number</title>
			</svg>
		</NumberFieldPrimitive.IncrementTrigger>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/otp-field.tsx
```
import { cn } from "@/libs/cn";
import type { DynamicProps, RootProps } from "@corvu/otp-field";
import OTPFieldPrimitive from "@corvu/otp-field";
import type { ComponentProps, ValidComponent } from "solid-js";
import { Show, splitProps } from "solid-js";

export const OTPFieldInput = OTPFieldPrimitive.Input;

type OTPFieldProps<T extends ValidComponent = "div"> = RootProps<T> & {
	class?: string;
};

export const OTPField = <T extends ValidComponent = "div">(
	props: DynamicProps<T, OTPFieldProps<T>>,
) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<OTPFieldPrimitive
			class={cn(
				"flex items-center gap-2 has-[:disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const OTPFieldGroup = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return <div class={cn("flex items-center", local.class)} {...rest} />;
};

export const OTPFieldSeparator = (props: ComponentProps<"div">) => {
	return (
		<div role="separator" {...props}>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				class="size-4"
				viewBox="0 0 15 15"
			>
				<title>Separator</title>
				<path
					fill="currentColor"
					fill-rule="evenodd"
					d="M5 7.5a.5.5 0 0 1 .5-.5h4a.5.5 0 0 1 0 1h-4a.5.5 0 0 1-.5-.5"
					clip-rule="evenodd"
				/>
			</svg>
		</div>
	);
};

export const OTPFieldSlot = (
	props: ComponentProps<"div"> & { index: number },
) => {
	const [local, rest] = splitProps(props, ["class", "index"]);
	const context = OTPFieldPrimitive.useContext();
	const char = () => context.value()[local.index];
	const hasFakeCaret = () =>
		context.value().length === local.index && context.isInserting();
	const isActive = () => context.activeSlots().includes(local.index);

	return (
		<div
			class={cn(
				"relative flex size-9 items-center justify-center border-y border-r border-input text-sm shadow-sm transition-shadow first:rounded-l-md first:border-l last:rounded-r-md",
				isActive() && "z-10 ring-[1.5px] ring-ring",
				local.class,
			)}
			{...rest}
		>
			{char()}
			<Show when={hasFakeCaret()}>
				<div class="pointer-events-none absolute inset-0 flex items-center justify-center">
					<div class="h-4 w-px animate-caret-blink bg-foreground" />
				</div>
			</Show>
		</div>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/pagination.tsx
```
import { cn } from "@/libs/cn";
import type {
	PaginationEllipsisProps,
	PaginationItemProps,
	PaginationPreviousProps,
	PaginationRootProps,
} from "@kobalte/core/pagination";
import { Pagination as PaginationPrimitive } from "@kobalte/core/pagination";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { VariantProps } from "class-variance-authority";
import type { ValidComponent, VoidProps } from "solid-js";
import { mergeProps, splitProps } from "solid-js";
import { buttonVariants } from "./button";

export const PaginationItems = PaginationPrimitive.Items;

type paginationProps<T extends ValidComponent = "nav"> =
	PaginationRootProps<T> & {
		class?: string;
	};

export const Pagination = <T extends ValidComponent = "nav">(
	props: PolymorphicProps<T, paginationProps<T>>,
) => {
	const [local, rest] = splitProps(props as paginationProps, ["class"]);

	return (
		<PaginationPrimitive
			class={cn(
				"mx-auto flex w-full justify-center [&>ul]:flex [&>ul]:flex-row [&>ul]:items-center [&>ul]:gap-1",
				local.class,
			)}
			{...rest}
		/>
	);
};

type paginationItemProps<T extends ValidComponent = "button"> =
	PaginationItemProps<T> &
		Pick<VariantProps<typeof buttonVariants>, "size"> & {
			class?: string;
		};

export const PaginationItem = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, paginationItemProps<T>>,
) => {
	// @ts-expect-error - required `page`
	const merge = mergeProps<paginationItemProps[]>({ size: "icon" }, props);
	const [local, rest] = splitProps(merge as paginationItemProps, [
		"class",
		"size",
	]);

	return (
		<PaginationPrimitive.Item
			class={cn(
				buttonVariants({
					variant: "ghost",
					size: local.size,
				}),
				"aria-[current=page]:border aria-[current=page]:border-input aria-[current=page]:bg-background aria-[current=page]:shadow-sm aria-[current=page]:hover:bg-accent aria-[current=page]:hover:text-accent-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

type paginationEllipsisProps<T extends ValidComponent = "div"> = VoidProps<
	PaginationEllipsisProps<T> & {
		class?: string;
	}
>;

export const PaginationEllipsis = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, paginationEllipsisProps<T>>,
) => {
	const [local, rest] = splitProps(props as paginationEllipsisProps, ["class"]);

	return (
		<PaginationPrimitive.Ellipsis
			class={cn("flex h-9 w-9 items-center justify-center", local.class)}
			{...rest}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				viewBox="0 0 24 24"
				class="h-4 w-4"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="M4 12a1 1 0 1 0 2 0a1 1 0 1 0-2 0m7 0a1 1 0 1 0 2 0a1 1 0 1 0-2 0m7 0a1 1 0 1 0 2 0a1 1 0 1 0-2 0"
				/>
				<title>More pages</title>
			</svg>
		</PaginationPrimitive.Ellipsis>
	);
};

type paginationPreviousProps<T extends ValidComponent = "button"> =
	PaginationPreviousProps<T> &
		Pick<VariantProps<typeof buttonVariants>, "size"> & {
			class?: string;
		};

export const PaginationPrevious = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, paginationPreviousProps<T>>,
) => {
	const merge = mergeProps<paginationPreviousProps<T>[]>(
		{ size: "icon" },
		props,
	);
	const [local, rest] = splitProps(merge as paginationPreviousProps, [
		"class",
		"size",
	]);

	return (
		<PaginationPrimitive.Previous
			class={cn(
				buttonVariants({
					variant: "ghost",
					size: local.size,
				}),
				"aria-[current=page]:border aria-[current=page]:border-input aria-[current=page]:bg-background aria-[current=page]:shadow-sm aria-[current=page]:hover:bg-accent aria-[current=page]:hover:text-accent-foreground",
				local.class,
			)}
			{...rest}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				viewBox="0 0 24 24"
				class="h-4 w-4"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="m15 6l-6 6l6 6"
				/>
				<title>Previous page</title>
			</svg>
		</PaginationPrimitive.Previous>
	);
};

type paginationNextProps<T extends ValidComponent = "button"> =
	paginationPreviousProps<T>;

export const PaginationNext = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, paginationNextProps<T>>,
) => {
	const merge = mergeProps<paginationNextProps<T>[]>({ size: "icon" }, props);
	const [local, rest] = splitProps(merge as paginationNextProps, [
		"class",
		"size",
	]);

	return (
		<PaginationPrimitive.Next
			class={cn(
				buttonVariants({
					variant: "ghost",
					size: local.size,
				}),
				"aria-[current=page]:border aria-[current=page]:border-input aria-[current=page]:bg-background aria-[current=page]:shadow-sm aria-[current=page]:hover:bg-accent aria-[current=page]:hover:text-accent-foreground",
				local.class,
			)}
			{...rest}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				class="h-4 w-4"
				viewBox="0 0 24 24"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="m9 6l6 6l-6 6"
				/>
				<title>Next page</title>
			</svg>
		</PaginationPrimitive.Next>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/popover.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	PopoverContentProps,
	PopoverRootProps,
} from "@kobalte/core/popover";
import { Popover as PopoverPrimitive } from "@kobalte/core/popover";
import type { ParentProps, ValidComponent } from "solid-js";
import { mergeProps, splitProps } from "solid-js";

export const PopoverTrigger = PopoverPrimitive.Trigger;
export const PopoverTitle = PopoverPrimitive.Title;
export const PopoverDescription = PopoverPrimitive.Description;

export const Popover = (props: PopoverRootProps) => {
	const merge = mergeProps<PopoverRootProps[]>({ gutter: 4 }, props);

	return <PopoverPrimitive {...merge} />;
};

type popoverContentProps<T extends ValidComponent = "div"> = ParentProps<
	PopoverContentProps<T> & {
		class?: string;
	}
>;

export const PopoverContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, popoverContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as popoverContentProps, [
		"class",
		"children",
	]);

	return (
		<PopoverPrimitive.Portal>
			<PopoverPrimitive.Content
				class={cn(
					"z-50 w-72 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			>
				{local.children}
				<PopoverPrimitive.CloseButton class="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-[opacity,box-shadow] hover:opacity-100 focus:outline-none focus:ring-[1.5px] focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 24 24"
						class="h-4 w-4"
					>
						<path
							fill="none"
							stroke="currentColor"
							strokeLinecap="round"
							strokeLinejoin="round"
							strokeWidth="2"
							d="M18 6L6 18M6 6l12 12"
						/>
						<title>Close</title>
					</svg>
				</PopoverPrimitive.CloseButton>
			</PopoverPrimitive.Content>
		</PopoverPrimitive.Portal>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/progress.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ProgressRootProps } from "@kobalte/core/progress";
import { Progress as ProgressPrimitive } from "@kobalte/core/progress";
import type { ParentProps, ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const ProgressLabel = ProgressPrimitive.Label;
export const ProgressValueLabel = ProgressPrimitive.ValueLabel;

type progressProps<T extends ValidComponent = "div"> = ParentProps<
	ProgressRootProps<T> & {
		class?: string;
	}
>;

export const Progress = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, progressProps<T>>,
) => {
	const [local, rest] = splitProps(props as progressProps, [
		"class",
		"children",
	]);

	return (
		<ProgressPrimitive
			class={cn("flex w-full flex-col gap-2", local.class)}
			{...rest}
		>
			{local.children}
			<ProgressPrimitive.Track class="h-2 overflow-hidden rounded-full bg-primary/20">
				<ProgressPrimitive.Fill class="h-full w-[--kb-progress-fill-width] bg-primary transition-all duration-500 ease-linear data-[progress=complete]:bg-primary" />
			</ProgressPrimitive.Track>
		</ProgressPrimitive>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/radio-group.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { RadioGroupItemControlProps } from "@kobalte/core/radio-group";
import { RadioGroup as RadioGroupPrimitive } from "@kobalte/core/radio-group";
import type { ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";

export const RadioGroupDescription = RadioGroupPrimitive.Description;
export const RadioGroupErrorMessage = RadioGroupPrimitive.ErrorMessage;
export const RadioGroupItemDescription = RadioGroupPrimitive.ItemDescription;
export const RadioGroupItemInput = RadioGroupPrimitive.ItemInput;
export const RadioGroupItemLabel = RadioGroupPrimitive.ItemLabel;
export const RadioGroupLabel = RadioGroupPrimitive.Label;
export const RadioGroup = RadioGroupPrimitive;
export const RadioGroupItem = RadioGroupPrimitive.Item;

type radioGroupItemControlProps<T extends ValidComponent = "div"> = VoidProps<
	RadioGroupItemControlProps<T> & { class?: string }
>;

export const RadioGroupItemControl = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, radioGroupItemControlProps<T>>,
) => {
	const [local, rest] = splitProps(props as radioGroupItemControlProps, [
		"class",
	]);

	return (
		<RadioGroupPrimitive.ItemControl
			class={cn(
				"flex aspect-square h-4 w-4 items-center justify-center rounded-full border border-primary text-primary shadow transition-shadow focus:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 data-[checked]:bg-foreground",
				local.class,
			)}
			{...rest}
		>
			<RadioGroupPrimitive.ItemIndicator class="h-2 w-2 rounded-full data-[checked]:bg-background" />
		</RadioGroupPrimitive.ItemControl>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/resizable.tsx
```
import { cn } from "@/libs/cn";
import type { DynamicProps, HandleProps, RootProps } from "@corvu/resizable";
import ResizablePrimitive from "@corvu/resizable";
import type { ValidComponent, VoidProps } from "solid-js";
import { Show, splitProps } from "solid-js";

export const ResizablePanel = ResizablePrimitive.Panel;

type resizableProps<T extends ValidComponent = "div"> = RootProps<T> & {
	class?: string;
};

export const Resizable = <T extends ValidComponent = "div">(
	props: DynamicProps<T, resizableProps<T>>,
) => {
	const [local, rest] = splitProps(props as resizableProps, ["class"]);

	return <ResizablePrimitive class={cn("size-full", local.class)} {...rest} />;
};

type resizableHandleProps<T extends ValidComponent = "button"> = VoidProps<
	HandleProps<T> & {
		class?: string;
		withHandle?: boolean;
	}
>;

export const ResizableHandle = <T extends ValidComponent = "button">(
	props: DynamicProps<T, resizableHandleProps<T>>,
) => {
	const [local, rest] = splitProps(props as resizableHandleProps, [
		"class",
		"withHandle",
	]);

	return (
		<ResizablePrimitive.Handle
			class={cn(
				"flex w-px items-center justify-center bg-border transition-shadow focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring focus-visible:ring-offset-1 data-[orientation=vertical]:h-px data-[orientation=vertical]:w-full",
				local.class,
			)}
			{...rest}
		>
			<Show when={local.withHandle}>
				<div class="z-10 flex h-4 w-3 items-center justify-center rounded-sm border bg-border">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						class="h-2.5 w-2.5"
						viewBox="0 0 15 15"
					>
						<path
							fill="currentColor"
							fill-rule="evenodd"
							d="M5.5 4.625a1.125 1.125 0 1 0 0-2.25a1.125 1.125 0 0 0 0 2.25m4 0a1.125 1.125 0 1 0 0-2.25a1.125 1.125 0 0 0 0 2.25M10.625 7.5a1.125 1.125 0 1 1-2.25 0a1.125 1.125 0 0 1 2.25 0M5.5 8.625a1.125 1.125 0 1 0 0-2.25a1.125 1.125 0 0 0 0 2.25m5.125 2.875a1.125 1.125 0 1 1-2.25 0a1.125 1.125 0 0 1 2.25 0M5.5 12.625a1.125 1.125 0 1 0 0-2.25a1.125 1.125 0 0 0 0 2.25"
							clip-rule="evenodd"
						/>
						<title>Resizable handle</title>
					</svg>
				</div>
			</Show>
		</ResizablePrimitive.Handle>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/select.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	SelectContentProps,
	SelectItemProps,
	SelectTriggerProps,
} from "@kobalte/core/select";
import { Select as SelectPrimitive } from "@kobalte/core/select";
import type { ParentProps, ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const Select = SelectPrimitive;
export const SelectValue = SelectPrimitive.Value;
export const SelectDescription = SelectPrimitive.Description;
export const SelectErrorMessage = SelectPrimitive.ErrorMessage;
export const SelectItemDescription = SelectPrimitive.ItemDescription;
export const SelectHiddenSelect = SelectPrimitive.HiddenSelect;
export const SelectSection = SelectPrimitive.Section;

type selectTriggerProps<T extends ValidComponent = "button"> = ParentProps<
	SelectTriggerProps<T> & { class?: string }
>;

export const SelectTrigger = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, selectTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as selectTriggerProps, [
		"class",
		"children",
	]);

	return (
		<SelectPrimitive.Trigger
			class={cn(
				"flex h-9 w-full items-center justify-between rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background transition-shadow placeholder:text-muted-foreground focus:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
				local.class,
			)}
			{...rest}
		>
			{local.children}
			<SelectPrimitive.Icon
				as="svg"
				xmlns="http://www.w3.org/2000/svg"
				width="1em"
				height="1em"
				viewBox="0 0 24 24"
				class="flex size-4 items-center justify-center opacity-50"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="m8 9l4-4l4 4m0 6l-4 4l-4-4"
				/>
			</SelectPrimitive.Icon>
		</SelectPrimitive.Trigger>
	);
};

type selectContentProps<T extends ValidComponent = "div"> =
	SelectContentProps<T> & {
		class?: string;
	};

export const SelectContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, selectContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as selectContentProps, ["class"]);

	return (
		<SelectPrimitive.Portal>
			<SelectPrimitive.Content
				class={cn(
					"relative z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			>
				<SelectPrimitive.Listbox class="p-1 focus-visible:outline-none" />
			</SelectPrimitive.Content>
		</SelectPrimitive.Portal>
	);
};

type selectItemProps<T extends ValidComponent = "li"> = ParentProps<
	SelectItemProps<T> & { class?: string }
>;

export const SelectItem = <T extends ValidComponent = "li">(
	props: PolymorphicProps<T, selectItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as selectItemProps, [
		"class",
		"children",
	]);

	return (
		<SelectPrimitive.Item
			class={cn(
				"relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-2 pr-8 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<SelectPrimitive.ItemIndicator class="absolute right-2 flex h-3.5 w-3.5 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					class="h-4 w-4"
					viewBox="0 0 24 24"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m5 12l5 5L20 7"
					/>
					<title>Checked</title>
				</svg>
			</SelectPrimitive.ItemIndicator>
			<SelectPrimitive.ItemLabel>{local.children}</SelectPrimitive.ItemLabel>
		</SelectPrimitive.Item>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/separator.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { SeparatorRootProps } from "@kobalte/core/separator";
import { Separator as SeparatorPrimitive } from "@kobalte/core/separator";
import type { ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

type separatorProps<T extends ValidComponent = "hr"> = SeparatorRootProps<T> & {
	class?: string;
};

export const Separator = <T extends ValidComponent = "hr">(
	props: PolymorphicProps<T, separatorProps<T>>,
) => {
	const [local, rest] = splitProps(props as separatorProps, ["class"]);

	return (
		<SeparatorPrimitive
			class={cn(
				"shrink-0 bg-border data-[orientation=horizontal]:h-[1px] data-[orientation=vertical]:h-full data-[orientation=horizontal]:w-full data-[orientation=vertical]:w-[1px]",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/sheet.tsx
```
import { cn } from "@/libs/cn";
import type {
	DialogContentProps,
	DialogDescriptionProps,
	DialogTitleProps,
} from "@kobalte/core/dialog";
import { Dialog as DialogPrimitive } from "@kobalte/core/dialog";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { VariantProps } from "class-variance-authority";
import { cva } from "class-variance-authority";
import type { ComponentProps, ParentProps, ValidComponent } from "solid-js";
import { mergeProps, splitProps } from "solid-js";

export const Sheet = DialogPrimitive;
export const SheetTrigger = DialogPrimitive.Trigger;

export const sheetVariants = cva(
	"fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out data-[expanded]:animate-in data-[closed]:animate-out data-[expanded]:duration-200 data-[closed]:duration-200",
	{
		variants: {
			side: {
				top: "inset-x-0 top-0 border-b data-[closed]:slide-out-to-top data-[expanded]:slide-in-from-top",
				bottom:
					"inset-x-0 bottom-0 border-t data-[closed]:slide-out-to-bottom data-[expanded]:slide-in-from-bottom",
				left: "inset-y-0 left-0 h-full w-3/4 border-r data-[closed]:slide-out-to-left data-[expanded]:slide-in-from-left sm:max-w-sm",
				right:
					"inset-y-0 right-0 h-full w-3/4 border-l data-[closed]:slide-out-to-right data-[expanded]:slide-in-from-right sm:max-w-sm",
			},
		},
		defaultVariants: {
			side: "right",
		},
	},
);

type sheetContentProps<T extends ValidComponent = "div"> = ParentProps<
	DialogContentProps<T> &
		VariantProps<typeof sheetVariants> & {
			class?: string;
		}
>;

export const SheetContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, sheetContentProps<T>>,
) => {
	const merge = mergeProps<sheetContentProps<T>[]>({ side: "right" }, props);
	const [local, rest] = splitProps(merge as sheetContentProps, [
		"class",
		"children",
		"side",
	]);

	return (
		<DialogPrimitive.Portal>
			<DialogPrimitive.Overlay
				class={cn(
					"fixed inset-0 z-50 bg-background/80 data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0",
				)}
			/>
			<DialogPrimitive.Content
				class={sheetVariants({ side: local.side, class: local.class })}
				{...rest}
			>
				{local.children}
				<DialogPrimitive.CloseButton class="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-[opacity,box-shadow] hover:opacity-100 focus:outline-none focus:ring-[1.5px] focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 24 24"
						class="h-4 w-4"
					>
						<path
							fill="none"
							stroke="currentColor"
							strokeLinecap="round"
							strokeLinejoin="round"
							strokeWidth="2"
							d="M18 6L6 18M6 6l12 12"
						/>
						<title>Close</title>
					</svg>
				</DialogPrimitive.CloseButton>
			</DialogPrimitive.Content>
		</DialogPrimitive.Portal>
	);
};

type sheetTitleProps<T extends ValidComponent = "h2"> = DialogTitleProps<T> & {
	class?: string;
};

export const SheetTitle = <T extends ValidComponent = "h2">(
	props: PolymorphicProps<T, sheetTitleProps<T>>,
) => {
	const [local, rest] = splitProps(props as sheetTitleProps, ["class"]);

	return (
		<DialogPrimitive.Title
			class={cn("text-lg font-semibold text-foreground", local.class)}
			{...rest}
		/>
	);
};

type sheetDescriptionProps<T extends ValidComponent = "p"> =
	DialogDescriptionProps<T> & {
		class?: string;
	};

export const SheetDescription = <T extends ValidComponent = "p">(
	props: PolymorphicProps<T, sheetDescriptionProps<T>>,
) => {
	const [local, rest] = splitProps(props as sheetDescriptionProps, ["class"]);

	return (
		<DialogPrimitive.Description
			class={cn("text-sm text-muted-foreground", local.class)}
			{...rest}
		/>
	);
};

export const SheetHeader = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"flex flex-col space-y-2 text-center sm:text-left",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const SheetFooter = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/skeleton.tsx
```
import { cn } from "@/libs/cn";
import { type ComponentProps, splitProps } from "solid-js";

export const Skeleton = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn("animate-pulse rounded-md bg-primary/10", local.class)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/sonner.tsx
```
import { Toaster as Sonner } from "solid-sonner";

export const Toaster = (props: Parameters<typeof Sonner>[0]) => {
	return (
		<Sonner
			class="toaster group"
			toastOptions={{
				classes: {
					toast:
						"group toast group-[.toaster]:bg-background group-[.toaster]:text-foreground group-[.toaster]:border-border group-[.toaster]:shadow-lg",
					description: "group-[.toast]:text-muted-foreground",
					actionButton:
						"group-[.toast]:bg-primary group-[.toast]:text-primary-foreground",
					cancelButton:
						"group-[.toast]:bg-muted group-[.toast]:text-muted-foreground",
				},
			}}
			{...props}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/switch.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	SwitchControlProps,
	SwitchThumbProps,
} from "@kobalte/core/switch";
import { Switch as SwitchPrimitive } from "@kobalte/core/switch";
import type { ParentProps, ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";

export const SwitchLabel = SwitchPrimitive.Label;
export const Switch = SwitchPrimitive;
export const SwitchErrorMessage = SwitchPrimitive.ErrorMessage;
export const SwitchDescription = SwitchPrimitive.Description;

type switchControlProps<T extends ValidComponent = "input"> = ParentProps<
	SwitchControlProps<T> & { class?: string }
>;

export const SwitchControl = <T extends ValidComponent = "input">(
	props: PolymorphicProps<T, switchControlProps<T>>,
) => {
	const [local, rest] = splitProps(props as switchControlProps, [
		"class",
		"children",
	]);

	return (
		<>
			<SwitchPrimitive.Input class="[&:focus-visible+div]:outline-none [&:focus-visible+div]:ring-[1.5px] [&:focus-visible+div]:ring-ring [&:focus-visible+div]:ring-offset-2 [&:focus-visible+div]:ring-offset-background" />
			<SwitchPrimitive.Control
				class={cn(
					"inline-flex h-5 w-9 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent bg-input shadow-sm transition-[color,background-color,box-shadow] data-[disabled]:cursor-not-allowed data-[checked]:bg-primary data-[disabled]:opacity-50",
					local.class,
				)}
				{...rest}
			>
				{local.children}
			</SwitchPrimitive.Control>
		</>
	);
};

type switchThumbProps<T extends ValidComponent = "div"> = VoidProps<
	SwitchThumbProps<T> & { class?: string }
>;

export const SwitchThumb = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, switchThumbProps<T>>,
) => {
	const [local, rest] = splitProps(props as switchThumbProps, ["class"]);

	return (
		<SwitchPrimitive.Thumb
			class={cn(
				"pointer-events-none block h-4 w-4 translate-x-0 rounded-full bg-background shadow-lg ring-0 transition-transform data-[checked]:translate-x-4",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/table.tsx
```
import { cn } from "@/libs/cn";
import { type ComponentProps, splitProps } from "solid-js";

export const Table = (props: ComponentProps<"table">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div class="w-full overflow-auto">
			<table
				class={cn("w-full caption-bottom text-sm", local.class)}
				{...rest}
			/>
		</div>
	);
};

export const TableHeader = (props: ComponentProps<"thead">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return <thead class={cn("[&_tr]:border-b", local.class)} {...rest} />;
};

export const TableBody = (props: ComponentProps<"tbody">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<tbody class={cn("[&_tr:last-child]:border-0", local.class)} {...rest} />
	);
};

export const TableFooter = (props: ComponentProps<"tfoot">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<tbody
			class={cn("bg-primary font-medium text-primary-foreground", local.class)}
			{...rest}
		/>
	);
};

export const TableRow = (props: ComponentProps<"tr">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<tr
			class={cn(
				"border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const TableHead = (props: ComponentProps<"th">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<th
			class={cn(
				"h-10 px-2 text-left align-middle font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const TableCell = (props: ComponentProps<"td">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<td
			class={cn(
				"p-2 align-middle [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const TableCaption = (props: ComponentProps<"caption">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<caption
			class={cn("mt-4 text-sm text-muted-foreground", local.class)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/tabs.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	TabsContentProps,
	TabsIndicatorProps,
	TabsListProps,
	TabsRootProps,
	TabsTriggerProps,
} from "@kobalte/core/tabs";
import { Tabs as TabsPrimitive } from "@kobalte/core/tabs";
import type { VariantProps } from "class-variance-authority";
import { cva } from "class-variance-authority";
import type { ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";

type tabsProps<T extends ValidComponent = "div"> = TabsRootProps<T> & {
	class?: string;
};

export const Tabs = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, tabsProps<T>>,
) => {
	const [local, rest] = splitProps(props as tabsProps, ["class"]);

	return (
		<TabsPrimitive
			class={cn("w-full data-[orientation=vertical]:flex", local.class)}
			{...rest}
		/>
	);
};

type tabsListProps<T extends ValidComponent = "div"> = TabsListProps<T> & {
	class?: string;
};

export const TabsList = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, tabsListProps<T>>,
) => {
	const [local, rest] = splitProps(props as tabsListProps, ["class"]);

	return (
		<TabsPrimitive.List
			class={cn(
				"relative flex w-full rounded-lg bg-muted p-1 text-muted-foreground data-[orientation=vertical]:flex-col data-[orientation=horizontal]:items-center data-[orientation=vertical]:items-stretch",
				local.class,
			)}
			{...rest}
		/>
	);
};

type tabsContentProps<T extends ValidComponent = "div"> =
	TabsContentProps<T> & {
		class?: string;
	};

export const TabsContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, tabsContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as tabsContentProps, ["class"]);

	return (
		<TabsPrimitive.Content
			class={cn(
				"transition-shadow duration-200 focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background data-[orientation=horizontal]:mt-2 data-[orientation=vertical]:ml-2",
				local.class,
			)}
			{...rest}
		/>
	);
};

type tabsTriggerProps<T extends ValidComponent = "button"> =
	TabsTriggerProps<T> & {
		class?: string;
	};

export const TabsTrigger = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, tabsTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as tabsTriggerProps, ["class"]);

	return (
		<TabsPrimitive.Trigger
			class={cn(
				"peer relative z-10 inline-flex h-7 w-full items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm font-medium outline-none transition-colors disabled:pointer-events-none disabled:opacity-50 data-[selected]:text-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

const tabsIndicatorVariants = cva(
	"absolute transition-all duration-200 outline-none",
	{
		variants: {
			variant: {
				block:
					"data-[orientation=horizontal]:bottom-1 data-[orientation=horizontal]:left-0 data-[orientation=vertical]:right-1 data-[orientation=vertical]:top-0 data-[orientation=horizontal]:h-[calc(100%-0.5rem)] data-[orientation=vertical]:w-[calc(100%-0.5rem)] bg-background shadow rounded-md peer-focus-visible:ring-[1.5px] peer-focus-visible:ring-ring peer-focus-visible:ring-offset-2 peer-focus-visible:ring-offset-background peer-focus-visible:outline-none",
				underline:
					"data-[orientation=horizontal]:-bottom-[1px] data-[orientation=horizontal]:left-0 data-[orientation=vertical]:-right-[1px] data-[orientation=vertical]:top-0 data-[orientation=horizontal]:h-[2px] data-[orientation=vertical]:w-[2px] bg-primary",
			},
		},
		defaultVariants: {
			variant: "block",
		},
	},
);

type tabsIndicatorProps<T extends ValidComponent = "div"> = VoidProps<
	TabsIndicatorProps<T> &
		VariantProps<typeof tabsIndicatorVariants> & {
			class?: string;
		}
>;

export const TabsIndicator = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, tabsIndicatorProps<T>>,
) => {
	const [local, rest] = splitProps(props as tabsIndicatorProps, [
		"class",
		"variant",
	]);

	return (
		<TabsPrimitive.Indicator
			class={cn(tabsIndicatorVariants({ variant: local.variant }), local.class)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/textarea.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { TextFieldTextAreaProps } from "@kobalte/core/text-field";
import { TextArea as TextFieldPrimitive } from "@kobalte/core/text-field";
import type { ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";

type textAreaProps<T extends ValidComponent = "textarea"> = VoidProps<
	TextFieldTextAreaProps<T> & {
		class?: string;
	}
>;

export const TextArea = <T extends ValidComponent = "textarea">(
	props: PolymorphicProps<T, textAreaProps<T>>,
) => {
	const [local, rest] = splitProps(props as textAreaProps, ["class"]);

	return (
		<TextFieldPrimitive
			class={cn(
				"flex min-h-[60px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm transition-shadow placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/textfield.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	TextFieldDescriptionProps,
	TextFieldErrorMessageProps,
	TextFieldInputProps,
	TextFieldLabelProps,
	TextFieldRootProps,
} from "@kobalte/core/text-field";
import { TextField as TextFieldPrimitive } from "@kobalte/core/text-field";
import { cva } from "class-variance-authority";
import type { ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";

type textFieldProps<T extends ValidComponent = "div"> =
	TextFieldRootProps<T> & {
		class?: string;
	};

export const TextFieldRoot = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, textFieldProps<T>>,
) => {
	const [local, rest] = splitProps(props as textFieldProps, ["class"]);

	return <TextFieldPrimitive class={cn("space-y-1", local.class)} {...rest} />;
};

export const textfieldLabel = cva(
	"text-sm data-[disabled]:cursor-not-allowed data-[disabled]:opacity-70 font-medium",
	{
		variants: {
			label: {
				true: "data-[invalid]:text-destructive",
			},
			error: {
				true: "text-destructive text-xs",
			},
			description: {
				true: "font-normal text-muted-foreground",
			},
		},
		defaultVariants: {
			label: true,
		},
	},
);

type textFieldLabelProps<T extends ValidComponent = "label"> =
	TextFieldLabelProps<T> & {
		class?: string;
	};

export const TextFieldLabel = <T extends ValidComponent = "label">(
	props: PolymorphicProps<T, textFieldLabelProps<T>>,
) => {
	const [local, rest] = splitProps(props as textFieldLabelProps, ["class"]);

	return (
		<TextFieldPrimitive.Label
			class={cn(textfieldLabel(), local.class)}
			{...rest}
		/>
	);
};

type textFieldErrorMessageProps<T extends ValidComponent = "div"> =
	TextFieldErrorMessageProps<T> & {
		class?: string;
	};

export const TextFieldErrorMessage = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, textFieldErrorMessageProps<T>>,
) => {
	const [local, rest] = splitProps(props as textFieldErrorMessageProps, [
		"class",
	]);

	return (
		<TextFieldPrimitive.ErrorMessage
			class={cn(textfieldLabel({ error: true }), local.class)}
			{...rest}
		/>
	);
};

type textFieldDescriptionProps<T extends ValidComponent = "div"> =
	TextFieldDescriptionProps<T> & {
		class?: string;
	};

export const TextFieldDescription = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, textFieldDescriptionProps<T>>,
) => {
	const [local, rest] = splitProps(props as textFieldDescriptionProps, [
		"class",
	]);

	return (
		<TextFieldPrimitive.Description
			class={cn(
				textfieldLabel({ description: true, label: false }),
				local.class,
			)}
			{...rest}
		/>
	);
};

type textFieldInputProps<T extends ValidComponent = "input"> = VoidProps<
	TextFieldInputProps<T> & {
		class?: string;
	}
>;

export const TextField = <T extends ValidComponent = "input">(
	props: PolymorphicProps<T, textFieldInputProps<T>>,
) => {
	const [local, rest] = splitProps(props as textFieldInputProps, ["class"]);

	return (
		<TextFieldPrimitive.Input
			class={cn(
				"flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-shadow file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/toast.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	ToastDescriptionProps,
	ToastListProps,
	ToastRegionProps,
	ToastRootProps,
	ToastTitleProps,
} from "@kobalte/core/toast";
import { Toast as ToastPrimitive } from "@kobalte/core/toast";
import type { VariantProps } from "class-variance-authority";
import { cva } from "class-variance-authority";
import type {
	ComponentProps,
	ValidComponent,
	VoidComponent,
	VoidProps,
} from "solid-js";
import { mergeProps, splitProps } from "solid-js";
import { Portal } from "solid-js/web";

export const toastVariants = cva(
	"group pointer-events-auto relative flex flex-col gap-3 w-full items-center justify-between overflow-hidden rounded-md border p-4 pr-6 shadow-lg transition-all data-[swipe=cancel]:translate-y-0 data-[swipe=end]:translate-y-[var(--kb-toast-swipe-end-y)] data-[swipe=move]:translate-y-[--kb-toast-swipe-move-y] data-[swipe=move]:transition-none data-[opened]:animate-in data-[closed]:animate-out data-[swipe=end]:animate-out data-[closed]:fade-out-80 data-[closed]:slide-out-to-top-full data-[closed]:sm:slide-out-to-bottom-full data-[opened]:slide-in-from-top-full data-[opened]:sm:slide-in-from-bottom-full",
	{
		variants: {
			variant: {
				default: "border bg-background",
				destructive:
					"destructive group border-destructive bg-destructive text-destructive-foreground",
			},
		},
		defaultVariants: {
			variant: "default",
		},
	},
);

type toastProps<T extends ValidComponent = "li"> = ToastRootProps<T> &
	VariantProps<typeof toastVariants> & {
		class?: string;
	};

export const Toast = <T extends ValidComponent = "li">(
	props: PolymorphicProps<T, toastProps<T>>,
) => {
	const [local, rest] = splitProps(props as toastProps, ["class", "variant"]);

	return (
		<ToastPrimitive
			class={cn(toastVariants({ variant: local.variant }), local.class)}
			{...rest}
		/>
	);
};

type toastTitleProps<T extends ValidComponent = "div"> = ToastTitleProps<T> & {
	class?: string;
};

export const ToastTitle = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, toastTitleProps<T>>,
) => {
	const [local, rest] = splitProps(props as toastTitleProps, ["class"]);

	return (
		<ToastPrimitive.Title
			class={cn("text-sm font-semibold [&+div]:text-xs", local.class)}
			{...rest}
		/>
	);
};

type toastDescriptionProps<T extends ValidComponent = "div"> =
	ToastDescriptionProps<T> & {
		class?: string;
	};

export const ToastDescription = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, toastDescriptionProps<T>>,
) => {
	const [local, rest] = splitProps(props as toastDescriptionProps, ["class"]);

	return (
		<ToastPrimitive.Description
			class={cn("text-sm opacity-90", local.class)}
			{...rest}
		/>
	);
};

type toastRegionProps<T extends ValidComponent = "div"> =
	ToastRegionProps<T> & {
		class?: string;
	};

export const ToastRegion = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, toastRegionProps<T>>,
) => {
	const merge = mergeProps<toastRegionProps[]>(
		{
			swipeDirection: "down",
		},
		props,
	);

	return (
		<Portal>
			<ToastPrimitive.Region {...merge} />
		</Portal>
	);
};

type toastListProps<T extends ValidComponent = "ol"> = VoidProps<
	ToastListProps<T> & {
		class?: string;
	}
>;

export const ToastList = <T extends ValidComponent = "ol">(
	props: PolymorphicProps<T, toastListProps<T>>,
) => {
	const [local, rest] = splitProps(props as toastListProps, ["class"]);

	return (
		<ToastPrimitive.List
			class={cn(
				"fixed top-0 z-[100] flex max-h-screen w-full flex-col-reverse gap-2 p-4 sm:bottom-0 sm:right-0 sm:top-auto sm:flex-col md:max-w-[420px]",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const ToastContent = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class", "children"]);

	return (
		<div class={cn("flex w-full flex-col", local.class)} {...rest}>
			<div>{local.children}</div>
			<ToastPrimitive.CloseButton class="absolute right-1 top-1 rounded-md p-1 text-foreground/50 opacity-0 transition-opacity hover:text-foreground focus:opacity-100 focus:outline-none group-hover:opacity-100 group-[.destructive]:text-red-300 group-[.destructive]:hover:text-red-50">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					class="h-4 w-4"
					viewBox="0 0 24 24"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="M18 6L6 18M6 6l12 12"
					/>
					<title>Close</title>
				</svg>
			</ToastPrimitive.CloseButton>
		</div>
	);
};

export const ToastProgress: VoidComponent = () => {
	return (
		<ToastPrimitive.ProgressTrack class="h-1 w-full overflow-hidden rounded-xl bg-primary/20 group-[.destructive]:bg-background/20">
			<ToastPrimitive.ProgressFill class="h-full w-[--kb-toast-progress-fill-width] bg-primary transition-all duration-150 ease-linear group-[.destructive]:bg-destructive-foreground" />
		</ToastPrimitive.ProgressTrack>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/toggle-group.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	ToggleGroupItemProps,
	ToggleGroupRootProps,
} from "@kobalte/core/toggle-group";
import { ToggleGroup as ToggleGroupPrimitive } from "@kobalte/core/toggle-group";
import type { VariantProps } from "class-variance-authority";
import type { Accessor, ParentProps, ValidComponent } from "solid-js";
import { createContext, createMemo, splitProps, useContext } from "solid-js";
import { toggleVariants } from "./toggle";

const ToggleGroupContext =
	createContext<Accessor<VariantProps<typeof toggleVariants>>>();

const useToggleGroup = () => {
	const context = useContext(ToggleGroupContext);

	if (!context) {
		throw new Error(
			"`useToggleGroup`: must be used within a `ToggleGroup` component",
		);
	}

	return context;
};

type toggleGroupProps<T extends ValidComponent = "div"> = ParentProps<
	ToggleGroupRootProps<T> &
		VariantProps<typeof toggleVariants> & {
			class?: string;
		}
>;

export const ToggleGroup = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, toggleGroupProps<T>>,
) => {
	const [local, rest] = splitProps(props as toggleGroupProps, [
		"class",
		"children",
		"size",
		"variant",
	]);

	const value = createMemo<VariantProps<typeof toggleVariants>>(() => ({
		size: local.size,
		variant: local.variant,
	}));

	return (
		<ToggleGroupPrimitive
			class={cn("flex items-center justify-center gap-1", local.class)}
			{...rest}
		>
			<ToggleGroupContext.Provider value={value}>
				{local.children}
			</ToggleGroupContext.Provider>
		</ToggleGroupPrimitive>
	);
};

type toggleGroupItemProps<T extends ValidComponent = "button"> =
	ToggleGroupItemProps<T> & {
		class?: string;
	};

export const ToggleGroupItem = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, toggleGroupItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as toggleGroupItemProps, ["class"]);
	const context = useToggleGroup();

	return (
		<ToggleGroupPrimitive.Item
			class={cn(
				toggleVariants({
					variant: context().variant,
					size: context().size,
				}),
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/toggle.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ToggleButtonRootProps } from "@kobalte/core/toggle-button";
import { ToggleButton as ToggleButtonPrimitive } from "@kobalte/core/toggle-button";
import type { VariantProps } from "class-variance-authority";
import { cva } from "class-variance-authority";
import type { ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const toggleVariants = cva(
	"inline-flex items-center justify-center rounded-md text-sm font-medium transition-[box-shadow,color,background-color] hover:bg-muted hover:text-muted-foreground focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 data-[pressed]:bg-accent data-[pressed]:text-accent-foreground",
	{
		variants: {
			variant: {
				default: "bg-transparent",
				outline:
					"border border-input bg-transparent shadow-sm hover:bg-accent hover:text-accent-foreground",
			},
			size: {
				default: "h-9 px-3",
				sm: "h-8 px-2",
				lg: "h-10 px-3",
			},
		},
		defaultVariants: {
			variant: "default",
			size: "default",
		},
	},
);

type toggleButtonProps<T extends ValidComponent = "button"> =
	ToggleButtonRootProps<T> &
		VariantProps<typeof toggleVariants> & {
			class?: string;
		};

export const ToggleButton = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, toggleButtonProps<T>>,
) => {
	const [local, rest] = splitProps(props as toggleButtonProps, [
		"class",
		"variant",
		"size",
	]);

	return (
		<ToggleButtonPrimitive
			class={cn(
				toggleVariants({ variant: local.variant, size: local.size }),
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/tooltip.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	TooltipContentProps,
	TooltipRootProps,
} from "@kobalte/core/tooltip";
import { Tooltip as TooltipPrimitive } from "@kobalte/core/tooltip";
import { type ValidComponent, mergeProps, splitProps } from "solid-js";

export const TooltipTrigger = TooltipPrimitive.Trigger;

export const Tooltip = (props: TooltipRootProps) => {
	const merge = mergeProps<TooltipRootProps[]>({ gutter: 4 }, props);

	return <TooltipPrimitive {...merge} />;
};

type tooltipContentProps<T extends ValidComponent = "div"> =
	TooltipContentProps<T> & {
		class?: string;
	};

export const TooltipContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, tooltipContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as tooltipContentProps, ["class"]);

	return (
		<TooltipPrimitive.Portal>
			<TooltipPrimitive.Content
				class={cn(
					"z-50 overflow-hidden rounded-md bg-primary px-3 py-1.5 text-xs text-primary-foreground data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			/>
		</TooltipPrimitive.Portal>
	);
};

```
