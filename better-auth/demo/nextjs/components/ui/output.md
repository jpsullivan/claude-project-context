/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/accordion.tsx
```
"use client";

import * as React from "react";
import * as AccordionPrimitive from "@radix-ui/react-accordion";
import { ChevronDownIcon } from "@radix-ui/react-icons";

import { cn } from "@/lib/utils";

const Accordion = AccordionPrimitive.Root;

const AccordionItem = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof AccordionPrimitive.Item> & {
	ref: React.RefObject<React.ElementRef<typeof AccordionPrimitive.Item>>;
}) => (
	<AccordionPrimitive.Item
		ref={ref}
		className={cn("border-b", className)}
		{...props}
	/>
);
AccordionItem.displayName = "AccordionItem";

const AccordionTrigger = ({
	ref,
	className,
	children,
	...props
}: React.ComponentPropsWithoutRef<typeof AccordionPrimitive.Trigger> & {
	ref: React.RefObject<React.ElementRef<typeof AccordionPrimitive.Trigger>>;
}) => (
	<AccordionPrimitive.Header className="flex">
		<AccordionPrimitive.Trigger
			ref={ref}
			className={cn(
				"flex flex-1 items-center justify-between py-4 text-sm font-medium transition-all hover:underline [&[data-state=open]>svg]:rotate-180",
				className,
			)}
			{...props}
		>
			{children}
			<ChevronDownIcon className="h-4 w-4 shrink-0 text-muted-foreground transition-transform duration-200" />
		</AccordionPrimitive.Trigger>
	</AccordionPrimitive.Header>
);
AccordionTrigger.displayName = AccordionPrimitive.Trigger.displayName;

const AccordionContent = ({
	ref,
	className,
	children,
	...props
}: React.ComponentPropsWithoutRef<typeof AccordionPrimitive.Content> & {
	ref: React.RefObject<React.ElementRef<typeof AccordionPrimitive.Content>>;
}) => (
	<AccordionPrimitive.Content
		ref={ref}
		className="overflow-hidden text-sm data-[state=closed]:animate-accordion-up data-[state=open]:animate-accordion-down"
		{...props}
	>
		<div className={cn("pb-4 pt-0", className)}>{children}</div>
	</AccordionPrimitive.Content>
);
AccordionContent.displayName = AccordionPrimitive.Content.displayName;

export { Accordion, AccordionItem, AccordionTrigger, AccordionContent };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/alert-dialog.tsx
```
"use client";

import * as React from "react";
import * as AlertDialogPrimitive from "@radix-ui/react-alert-dialog";

import { cn } from "@/lib/utils";
import { buttonVariants } from "@/components/ui/button";

const AlertDialog = AlertDialogPrimitive.Root;

const AlertDialogTrigger = AlertDialogPrimitive.Trigger;

const AlertDialogPortal = AlertDialogPrimitive.Portal;

const AlertDialogOverlay = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof AlertDialogPrimitive.Overlay> & {
	ref: React.RefObject<React.ElementRef<typeof AlertDialogPrimitive.Overlay>>;
}) => (
	<AlertDialogPrimitive.Overlay
		className={cn(
			"fixed inset-0 z-50 bg-black/80 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
			className,
		)}
		{...props}
		ref={ref}
	/>
);
AlertDialogOverlay.displayName = AlertDialogPrimitive.Overlay.displayName;

const AlertDialogContent = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof AlertDialogPrimitive.Content> & {
	ref: React.RefObject<React.ElementRef<typeof AlertDialogPrimitive.Content>>;
}) => (
	<AlertDialogPortal>
		<AlertDialogOverlay />
		<AlertDialogPrimitive.Content
			ref={ref}
			className={cn(
				"fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border bg-background p-6 shadow-lg duration-200 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=closed]:slide-out-to-left-1/2 data-[state=closed]:slide-out-to-top-[48%] data-[state=open]:slide-in-from-left-1/2 data-[state=open]:slide-in-from-top-[48%] sm:rounded-lg",
				className,
			)}
			{...props}
		/>
	</AlertDialogPortal>
);
AlertDialogContent.displayName = AlertDialogPrimitive.Content.displayName;

const AlertDialogHeader = ({
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement>) => (
	<div
		className={cn(
			"flex flex-col space-y-2 text-center sm:text-left",
			className,
		)}
		{...props}
	/>
);
AlertDialogHeader.displayName = "AlertDialogHeader";

const AlertDialogFooter = ({
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement>) => (
	<div
		className={cn(
			"flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",
			className,
		)}
		{...props}
	/>
);
AlertDialogFooter.displayName = "AlertDialogFooter";

const AlertDialogTitle = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof AlertDialogPrimitive.Title> & {
	ref: React.RefObject<React.ElementRef<typeof AlertDialogPrimitive.Title>>;
}) => (
	<AlertDialogPrimitive.Title
		ref={ref}
		className={cn("text-lg font-semibold", className)}
		{...props}
	/>
);
AlertDialogTitle.displayName = AlertDialogPrimitive.Title.displayName;

const AlertDialogDescription = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof AlertDialogPrimitive.Description> & {
	ref: React.RefObject<
		React.ElementRef<typeof AlertDialogPrimitive.Description>
	>;
}) => (
	<AlertDialogPrimitive.Description
		ref={ref}
		className={cn("text-sm text-muted-foreground", className)}
		{...props}
	/>
);
AlertDialogDescription.displayName =
	AlertDialogPrimitive.Description.displayName;

const AlertDialogAction = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof AlertDialogPrimitive.Action> & {
	ref: React.RefObject<React.ElementRef<typeof AlertDialogPrimitive.Action>>;
}) => (
	<AlertDialogPrimitive.Action
		ref={ref}
		className={cn(buttonVariants(), className)}
		{...props}
	/>
);
AlertDialogAction.displayName = AlertDialogPrimitive.Action.displayName;

const AlertDialogCancel = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof AlertDialogPrimitive.Cancel> & {
	ref: React.RefObject<React.ElementRef<typeof AlertDialogPrimitive.Cancel>>;
}) => (
	<AlertDialogPrimitive.Cancel
		ref={ref}
		className={cn(
			buttonVariants({ variant: "outline" }),
			"mt-2 sm:mt-0",
			className,
		)}
		{...props}
	/>
);
AlertDialogCancel.displayName = AlertDialogPrimitive.Cancel.displayName;

export {
	AlertDialog,
	AlertDialogPortal,
	AlertDialogOverlay,
	AlertDialogTrigger,
	AlertDialogContent,
	AlertDialogHeader,
	AlertDialogFooter,
	AlertDialogTitle,
	AlertDialogDescription,
	AlertDialogAction,
	AlertDialogCancel,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/alert.tsx
```
import * as React from "react";
import { cva } from "class-variance-authority";

import { cn } from "@/lib/utils";

const alertVariants = cva(
	"relative w-full rounded-lg border px-4 py-3 text-sm [&>svg+div]:translate-y-[-3px] [&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:text-foreground [&>svg~*]:pl-7",
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

const Alert = (
	props?: React.HTMLAttributes<HTMLDivElement> & {
		variant: "default" | "destructive";
	},
) => (
	<div
		role="alert"
		className={cn(alertVariants({ variant: props?.variant }), props?.className)}
		{...props}
	/>
);
Alert.displayName = "Alert";

const AlertTitle = ({
	className,
	...props
}: React.HTMLAttributes<HTMLHeadingElement>) => (
	<h5
		className={cn("mb-1 font-medium leading-none tracking-tight", className)}
		{...props}
	/>
);
AlertTitle.displayName = "AlertTitle";

const AlertDescription = ({
	className,
	...props
}: React.HTMLAttributes<HTMLParagraphElement>) => (
	<div className={cn("text-sm [&_p]:leading-relaxed", className)} {...props} />
);
AlertDescription.displayName = "AlertDescription";

export { Alert, AlertTitle, AlertDescription };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/aspect-ratio.tsx
```
"use client";

import * as AspectRatioPrimitive from "@radix-ui/react-aspect-ratio";

const AspectRatio = AspectRatioPrimitive.Root;

export { AspectRatio };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/avatar.tsx
```
"use client";

import * as React from "react";
import * as AvatarPrimitive from "@radix-ui/react-avatar";

import { cn } from "@/lib/utils";

const Avatar = ({
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Root>) => (
	<AvatarPrimitive.Root
		className={cn(
			"relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full",
			className,
		)}
		{...props}
	/>
);
Avatar.displayName = AvatarPrimitive.Root.displayName;

const AvatarImage = ({
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Image>) => (
	<AvatarPrimitive.Image
		className={cn("aspect-square h-full w-full", className)}
		{...props}
	/>
);
AvatarImage.displayName = AvatarPrimitive.Image.displayName;

const AvatarFallback = ({
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Fallback>) => (
	<AvatarPrimitive.Fallback
		className={cn(
			"flex h-full w-full items-center justify-center rounded-full bg-muted",
			className,
		)}
		{...props}
	/>
);
AvatarFallback.displayName = AvatarPrimitive.Fallback.displayName;

export { Avatar, AvatarImage, AvatarFallback };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/badge.tsx
```
import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";

import { cn } from "@/lib/utils";

const badgeVariants = cva(
	"inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
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

export interface BadgeProps
	extends React.HTMLAttributes<HTMLDivElement>,
		VariantProps<typeof badgeVariants> {}

function Badge({ className, variant, ...props }: BadgeProps) {
	return (
		<div className={cn(badgeVariants({ variant }), className)} {...props} />
	);
}

export { Badge, badgeVariants };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/breadcrumb.tsx
```
import * as React from "react";
import { ChevronRightIcon, DotsHorizontalIcon } from "@radix-ui/react-icons";
import { Slot } from "@radix-ui/react-slot";

import { cn } from "@/lib/utils";

const Breadcrumb = ({ ref, ...props }) => (
	<nav ref={ref} aria-label="breadcrumb" {...props} />
);
Breadcrumb.displayName = "Breadcrumb";

const BreadcrumbList = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<"ol"> & {
	ref: React.RefObject<HTMLOListElement>;
}) => (
	<ol
		ref={ref}
		className={cn(
			"flex flex-wrap items-center gap-1.5 break-words text-sm text-muted-foreground sm:gap-2.5",
			className,
		)}
		{...props}
	/>
);
BreadcrumbList.displayName = "BreadcrumbList";

const BreadcrumbItem = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<"li"> & {
	ref: React.RefObject<HTMLLIElement>;
}) => (
	<li
		ref={ref}
		className={cn("inline-flex items-center gap-1.5", className)}
		{...props}
	/>
);
BreadcrumbItem.displayName = "BreadcrumbItem";

const BreadcrumbLink = ({ ref, asChild, className, ...props }) => {
	const Comp = asChild ? Slot : "a";

	return (
		<Comp
			ref={ref}
			className={cn("transition-colors hover:text-foreground", className)}
			{...props}
		/>
	);
};
BreadcrumbLink.displayName = "BreadcrumbLink";

const BreadcrumbPage = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<"span"> & {
	ref: React.RefObject<HTMLSpanElement>;
}) => (
	<span
		ref={ref}
		role="link"
		aria-disabled="true"
		aria-current="page"
		className={cn("font-normal text-foreground", className)}
		{...props}
	/>
);
BreadcrumbPage.displayName = "BreadcrumbPage";

const BreadcrumbSeparator = ({
	children,
	className,
	...props
}: React.ComponentProps<"li">) => (
	<li
		role="presentation"
		aria-hidden="true"
		className={cn("[&>svg]:size-3.5", className)}
		{...props}
	>
		{children ?? <ChevronRightIcon />}
	</li>
);
BreadcrumbSeparator.displayName = "BreadcrumbSeparator";

const BreadcrumbEllipsis = ({
	className,
	...props
}: React.ComponentProps<"span">) => (
	<span
		role="presentation"
		aria-hidden="true"
		className={cn("flex h-9 w-9 items-center justify-center", className)}
		{...props}
	>
		<DotsHorizontalIcon className="h-4 w-4" />
		<span className="sr-only">More</span>
	</span>
);
BreadcrumbEllipsis.displayName = "BreadcrumbElipssis";

export {
	Breadcrumb,
	BreadcrumbList,
	BreadcrumbItem,
	BreadcrumbLink,
	BreadcrumbPage,
	BreadcrumbSeparator,
	BreadcrumbEllipsis,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/button.tsx
```
import * as React from "react";
import { Slot } from "@radix-ui/react-slot";
import { cva, type VariantProps } from "class-variance-authority";

import { cn } from "@/lib/utils";

const buttonVariants = cva(
	"inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50",
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

export interface ButtonProps
	extends React.ButtonHTMLAttributes<HTMLButtonElement>,
		VariantProps<typeof buttonVariants> {
	asChild?: boolean;
}

const Button = ({
	className,
	variant,
	size,
	asChild = false,
	...props
}: ButtonProps) => {
	const Comp = asChild ? Slot : "button";
	return (
		<Comp
			className={cn(buttonVariants({ variant, size, className }))}
			{...props}
		/>
	);
};
Button.displayName = "Button";

export { Button, buttonVariants };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/calendar.tsx
```
"use client";

import * as React from "react";
import { ChevronLeftIcon, ChevronRightIcon } from "@radix-ui/react-icons";
import { DayPicker } from "react-day-picker";

import { cn } from "@/lib/utils";
import { buttonVariants } from "@/components/ui/button";

export type CalendarProps = React.ComponentProps<typeof DayPicker>;

function Calendar({
	className,
	classNames,
	showOutsideDays = true,
	...props
}: CalendarProps) {
	return (
		<DayPicker
			showOutsideDays={showOutsideDays}
			className={cn("p-3", className)}
			classNames={{
				months: "flex flex-col sm:flex-row space-y-4 sm:space-x-4 sm:space-y-0",
				month: "space-y-4",
				caption: "flex justify-center pt-1 relative items-center",
				caption_label: "text-sm font-medium",
				nav: "space-x-1 flex items-center",
				nav_button: cn(
					buttonVariants({ variant: "outline" }),
					"h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100",
				),
				nav_button_previous: "absolute left-1",
				nav_button_next: "absolute right-1",
				table: "w-full border-collapse space-y-1",
				head_row: "flex",
				head_cell:
					"text-muted-foreground rounded-md w-8 font-normal text-[0.8rem]",
				row: "flex w-full mt-2",
				cell: cn(
					"relative p-0 text-center text-sm focus-within:relative focus-within:z-20 [&:has([aria-selected])]:bg-accent [&:has([aria-selected].day-outside)]:bg-accent/50 [&:has([aria-selected].day-range-end)]:rounded-r-md",
					props.mode === "range"
						? "[&:has(>.day-range-end)]:rounded-r-md [&:has(>.day-range-start)]:rounded-l-md first:[&:has([aria-selected])]:rounded-l-md last:[&:has([aria-selected])]:rounded-r-md"
						: "[&:has([aria-selected])]:rounded-md",
				),
				day: cn(
					buttonVariants({ variant: "ghost" }),
					"h-8 w-8 p-0 font-normal aria-selected:opacity-100",
				),
				day_range_start: "day-range-start",
				day_range_end: "day-range-end",
				day_selected:
					"bg-primary text-primary-foreground hover:bg-primary hover:text-primary-foreground focus:bg-primary focus:text-primary-foreground",
				day_today: "bg-accent text-accent-foreground",
				day_outside:
					"day-outside text-muted-foreground opacity-50  aria-selected:bg-accent/50 aria-selected:text-muted-foreground aria-selected:opacity-30",
				day_disabled: "text-muted-foreground opacity-50",
				day_range_middle:
					"aria-selected:bg-accent aria-selected:text-accent-foreground",
				day_hidden: "invisible",
				...classNames,
			}}
			components={{
				IconLeft: ({ ...props }) => <ChevronLeftIcon className="h-4 w-4" />,
				IconRight: ({ ...props }) => <ChevronRightIcon className="h-4 w-4" />,
			}}
			{...props}
		/>
	);
}
Calendar.displayName = "Calendar";

export { Calendar };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/canvas-reveal-effect.tsx
```
"use client";
import { cn } from "@/lib/utils";
import { Canvas, useFrame, useThree } from "@react-three/fiber";
import React, { useMemo, useRef } from "react";
import * as THREE from "three";

export const CanvasRevealEffect = ({
	animationSpeed = 0.4,
	opacities = [0.3, 0.3, 0.3, 0.5, 0.5, 0.5, 0.8, 0.8, 0.8, 1],
	colors = [[0, 255, 255]],
	containerClassName,
	dotSize,
	showGradient = true,
}: {
	/**
	 * 0.1 - slower
	 * 1.0 - faster
	 */
	animationSpeed?: number;
	opacities?: number[];
	colors?: number[][];
	containerClassName?: string;
	dotSize?: number;
	showGradient?: boolean;
}) => {
	return (
		<div className={cn("h-full relative bg-white w-full", containerClassName)}>
			<div className="h-full w-full">
				<DotMatrix
					colors={colors ?? [[0, 255, 255]]}
					dotSize={dotSize ?? 3}
					opacities={
						opacities ?? [0.3, 0.3, 0.3, 0.5, 0.5, 0.5, 0.8, 0.8, 0.8, 1]
					}
					shader={`
              float animation_speed_factor = ${animationSpeed.toFixed(1)};
              float intro_offset = distance(u_resolution / 2.0 / u_total_size, st2) * 0.01 + (random(st2) * 0.15);
              opacity *= step(intro_offset, u_time * animation_speed_factor);
              opacity *= clamp((1.0 - step(intro_offset + 0.1, u_time * animation_speed_factor)) * 1.25, 1.0, 1.25);
            `}
					center={["x", "y"]}
				/>
			</div>
			{showGradient && (
				<div className="absolute inset-0 bg-gradient-to-t from-gray-950 to-[84%]" />
			)}
		</div>
	);
};

interface DotMatrixProps {
	colors?: number[][];
	opacities?: number[];
	totalSize?: number;
	dotSize?: number;
	shader?: string;
	center?: ("x" | "y")[];
}

const DotMatrix: React.FC<DotMatrixProps> = ({
	colors = [[0, 0, 0]],
	opacities = [0.04, 0.04, 0.04, 0.04, 0.04, 0.08, 0.08, 0.08, 0.08, 0.14],
	totalSize = 4,
	dotSize = 2,
	shader = "",
	center = ["x", "y"],
}) => {
	const uniforms = React.useMemo(() => {
		let colorsArray = [
			colors[0],
			colors[0],
			colors[0],
			colors[0],
			colors[0],
			colors[0],
		];
		if (colors.length === 2) {
			colorsArray = [
				colors[0],
				colors[0],
				colors[0],
				colors[1],
				colors[1],
				colors[1],
			];
		} else if (colors.length === 3) {
			colorsArray = [
				colors[0],
				colors[0],
				colors[1],
				colors[1],
				colors[2],
				colors[2],
			];
		}

		return {
			u_colors: {
				value: colorsArray.map((color) => [
					color[0] / 255,
					color[1] / 255,
					color[2] / 255,
				]),
				type: "uniform3fv",
			},
			u_opacities: {
				value: opacities,
				type: "uniform1fv",
			},
			u_total_size: {
				value: totalSize,
				type: "uniform1f",
			},
			u_dot_size: {
				value: dotSize,
				type: "uniform1f",
			},
		};
	}, [colors, opacities, totalSize, dotSize]);

	return (
		<Shader
			source={`
        precision mediump float;
        in vec2 fragCoord;

        uniform float u_time;
        uniform float u_opacities[10];
        uniform vec3 u_colors[6];
        uniform float u_total_size;
        uniform float u_dot_size;
        uniform vec2 u_resolution;
        out vec4 fragColor;
        float PHI = 1.61803398874989484820459;
        float random(vec2 xy) {
            return fract(tan(distance(xy * PHI, xy) * 0.5) * xy.x);
        }
        float map(float value, float min1, float max1, float min2, float max2) {
            return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
        }
        void main() {
            vec2 st = fragCoord.xy;
            ${
							center.includes("x")
								? "st.x -= abs(floor((mod(u_resolution.x, u_total_size) - u_dot_size) * 0.5));"
								: ""
						}
            ${
							center.includes("y")
								? "st.y -= abs(floor((mod(u_resolution.y, u_total_size) - u_dot_size) * 0.5));"
								: ""
						}
      float opacity = step(0.0, st.x);
      opacity *= step(0.0, st.y);

      vec2 st2 = vec2(int(st.x / u_total_size), int(st.y / u_total_size));

      float frequency = 5.0;
      float show_offset = random(st2);
      float rand = random(st2 * floor((u_time / frequency) + show_offset + frequency) + 1.0);
      opacity *= u_opacities[int(rand * 10.0)];
      opacity *= 1.0 - step(u_dot_size / u_total_size, fract(st.x / u_total_size));
      opacity *= 1.0 - step(u_dot_size / u_total_size, fract(st.y / u_total_size));

      vec3 color = u_colors[int(show_offset * 6.0)];

      ${shader}

      fragColor = vec4(color, opacity);
      fragColor.rgb *= fragColor.a;
        }`}
			uniforms={uniforms}
			maxFps={60}
		/>
	);
};

type Uniforms = {
	[key: string]: {
		value: number[] | number[][] | number;
		type: string;
	};
};
const ShaderMaterial = ({
	source,
	uniforms,
	maxFps = 60,
}: {
	source: string;
	hovered?: boolean;
	maxFps?: number;
	uniforms: Uniforms;
}) => {
	const { size } = useThree();
	const ref = useRef<THREE.Mesh>();
	let lastFrameTime = 0;

	useFrame(({ clock }) => {
		if (!ref.current) return;
		const timestamp = clock.getElapsedTime();
		if (timestamp - lastFrameTime < 1 / maxFps) {
			return;
		}
		lastFrameTime = timestamp;

		const material: any = ref.current.material;
		const timeLocation = material.uniforms.u_time;
		timeLocation.value = timestamp;
	});

	const getUniforms = () => {
		const preparedUniforms: any = {};

		for (const uniformName in uniforms) {
			const uniform: any = uniforms[uniformName];

			switch (uniform.type) {
				case "uniform1f":
					preparedUniforms[uniformName] = { value: uniform.value, type: "1f" };
					break;
				case "uniform3f":
					preparedUniforms[uniformName] = {
						value: new THREE.Vector3().fromArray(uniform.value),
						type: "3f",
					};
					break;
				case "uniform1fv":
					preparedUniforms[uniformName] = { value: uniform.value, type: "1fv" };
					break;
				case "uniform3fv":
					preparedUniforms[uniformName] = {
						value: uniform.value.map((v: number[]) =>
							new THREE.Vector3().fromArray(v),
						),
						type: "3fv",
					};
					break;
				case "uniform2f":
					preparedUniforms[uniformName] = {
						value: new THREE.Vector2().fromArray(uniform.value),
						type: "2f",
					};
					break;
				default:
					console.error(`Invalid uniform type for '${uniformName}'.`);
					break;
			}
		}

		preparedUniforms["u_time"] = { value: 0, type: "1f" };
		preparedUniforms["u_resolution"] = {
			value: new THREE.Vector2(size.width * 2, size.height * 2),
		}; // Initialize u_resolution
		return preparedUniforms;
	};

	// Shader material
	const material = useMemo(() => {
		const materialObject = new THREE.ShaderMaterial({
			vertexShader: `
      precision mediump float;
      in vec2 coordinates;
      uniform vec2 u_resolution;
      out vec2 fragCoord;
      void main(){
        float x = position.x;
        float y = position.y;
        gl_Position = vec4(x, y, 0.0, 1.0);
        fragCoord = (position.xy + vec2(1.0)) * 0.5 * u_resolution;
        fragCoord.y = u_resolution.y - fragCoord.y;
      }
      `,
			fragmentShader: source,
			uniforms: getUniforms(),
			glslVersion: THREE.GLSL3,
			blending: THREE.CustomBlending,
			blendSrc: THREE.SrcAlphaFactor,
			blendDst: THREE.OneFactor,
		});

		return materialObject;
	}, [size.width, size.height, source]);

	return (
		<mesh ref={ref as any}>
			<planeGeometry args={[2, 2]} />
			<primitive object={material} attach="material" />
		</mesh>
	);
};

const Shader: React.FC<ShaderProps> = ({ source, uniforms, maxFps = 60 }) => {
	return (
		<Canvas className="absolute inset-0  h-full w-full">
			<ShaderMaterial source={source} uniforms={uniforms} maxFps={maxFps} />
		</Canvas>
	);
};
interface ShaderProps {
	source: string;
	uniforms: {
		[key: string]: {
			value: number[] | number[][] | number;
			type: string;
		};
	};
	maxFps?: number;
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/card.tsx
```
import * as React from "react";

import { cn } from "@/lib/utils";

const Card = ({
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement>) => (
	<div
		className={cn(
			"rounded-xl border bg-card text-card-foreground shadow",
			className,
		)}
		{...props}
	/>
);
Card.displayName = "Card";

const CardHeader = ({
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement>) => (
	<div className={cn("flex flex-col space-y-1.5 p-6", className)} {...props} />
);
CardHeader.displayName = "CardHeader";

const CardTitle = ({
	className,
	...props
}: React.HTMLAttributes<HTMLHeadingElement>) => (
	<h3
		className={cn("font-semibold leading-none tracking-tight", className)}
		{...props}
	/>
);
CardTitle.displayName = "CardTitle";

const CardDescription = ({
	className,
	...props
}: React.HTMLAttributes<HTMLParagraphElement>) => (
	<p className={cn("text-sm text-muted-foreground", className)} {...props} />
);
CardDescription.displayName = "CardDescription";

const CardContent = ({
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement>) => (
	<div className={cn("p-6 pt-0", className)} {...props} />
);
CardContent.displayName = "CardContent";

const CardFooter = ({
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement>) => (
	<div className={cn("flex items-center p-6 pt-0", className)} {...props} />
);
CardFooter.displayName = "CardFooter";

export {
	Card,
	CardHeader,
	CardFooter,
	CardTitle,
	CardDescription,
	CardContent,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/carousel.tsx
```
"use client";

import * as React from "react";
import { ArrowLeftIcon, ArrowRightIcon } from "@radix-ui/react-icons";
import useEmblaCarousel, {
	type UseEmblaCarouselType,
} from "embla-carousel-react";

import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";

type CarouselApi = UseEmblaCarouselType[1];
type UseCarouselParameters = Parameters<typeof useEmblaCarousel>;
type CarouselOptions = UseCarouselParameters[0];
type CarouselPlugin = UseCarouselParameters[1];

type CarouselProps = {
	opts?: CarouselOptions;
	plugins?: CarouselPlugin;
	orientation?: "horizontal" | "vertical";
	setApi?: (api: CarouselApi) => void;
};

type CarouselContextProps = {
	carouselRef: ReturnType<typeof useEmblaCarousel>[0];
	api: ReturnType<typeof useEmblaCarousel>[1];
	scrollPrev: () => void;
	scrollNext: () => void;
	canScrollPrev: boolean;
	canScrollNext: boolean;
} & CarouselProps;

const CarouselContext = React.createContext<CarouselContextProps | null>(null);

function useCarousel() {
	const context = React.useContext(CarouselContext);

	if (!context) {
		throw new Error("useCarousel must be used within a <Carousel />");
	}

	return context;
}

const Carousel = ({
	ref,
	orientation = "horizontal",
	opts,
	setApi,
	plugins,
	className,
	children,
	...props
}) => {
	const [carouselRef, api] = useEmblaCarousel(
		{
			...opts,
			axis: orientation === "horizontal" ? "x" : "y",
		},
		plugins,
	);
	const [canScrollPrev, setCanScrollPrev] = React.useState(false);
	const [canScrollNext, setCanScrollNext] = React.useState(false);

	const onSelect = React.useCallback((api: CarouselApi) => {
		if (!api) {
			return;
		}

		setCanScrollPrev(api.canScrollPrev());
		setCanScrollNext(api.canScrollNext());
	}, []);

	const scrollPrev = React.useCallback(() => {
		api?.scrollPrev();
	}, [api]);

	const scrollNext = React.useCallback(() => {
		api?.scrollNext();
	}, [api]);

	const handleKeyDown = React.useCallback(
		(event: React.KeyboardEvent<HTMLDivElement>) => {
			if (event.key === "ArrowLeft") {
				event.preventDefault();
				scrollPrev();
			} else if (event.key === "ArrowRight") {
				event.preventDefault();
				scrollNext();
			}
		},
		[scrollPrev, scrollNext],
	);

	React.useEffect(() => {
		if (!api || !setApi) {
			return;
		}

		setApi(api);
	}, [api, setApi]);

	React.useEffect(() => {
		if (!api) {
			return;
		}

		onSelect(api);
		api.on("reInit", onSelect);
		api.on("select", onSelect);

		return () => {
			api?.off("select", onSelect);
		};
	}, [api, onSelect]);

	return (
		<CarouselContext.Provider
			value={{
				carouselRef,
				api: api,
				opts,
				orientation:
					orientation || (opts?.axis === "y" ? "vertical" : "horizontal"),
				scrollPrev,
				scrollNext,
				canScrollPrev,
				canScrollNext,
			}}
		>
			<div
				ref={ref}
				onKeyDownCapture={handleKeyDown}
				className={cn("relative", className)}
				role="region"
				aria-roledescription="carousel"
				{...props}
			>
				{children}
			</div>
		</CarouselContext.Provider>
	);
};
Carousel.displayName = "Carousel";

const CarouselContent = ({
	ref,
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement> & {
	ref: React.RefObject<HTMLDivElement>;
}) => {
	const { carouselRef, orientation } = useCarousel();

	return (
		<div ref={carouselRef} className="overflow-hidden">
			<div
				ref={ref}
				className={cn(
					"flex",
					orientation === "horizontal" ? "-ml-4" : "-mt-4 flex-col",
					className,
				)}
				{...props}
			/>
		</div>
	);
};
CarouselContent.displayName = "CarouselContent";

const CarouselItem = ({
	ref,
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement> & {
	ref: React.RefObject<HTMLDivElement>;
}) => {
	const { orientation } = useCarousel();

	return (
		<div
			ref={ref}
			role="group"
			aria-roledescription="slide"
			className={cn(
				"min-w-0 shrink-0 grow-0 basis-full",
				orientation === "horizontal" ? "pl-4" : "pt-4",
				className,
			)}
			{...props}
		/>
	);
};
CarouselItem.displayName = "CarouselItem";

const CarouselPrevious = ({
	ref,
	className,
	variant = "outline",
	size = "icon",
	...props
}: React.ComponentProps<typeof Button> & {
	ref: React.RefObject<HTMLButtonElement>;
}) => {
	const { orientation, scrollPrev, canScrollPrev } = useCarousel();

	return (
		<Button
			ref={ref}
			variant={variant}
			size={size}
			className={cn(
				"absolute  h-8 w-8 rounded-full",
				orientation === "horizontal"
					? "-left-12 top-1/2 -translate-y-1/2"
					: "-top-12 left-1/2 -translate-x-1/2 rotate-90",
				className,
			)}
			disabled={!canScrollPrev}
			onClick={scrollPrev}
			{...props}
		>
			<ArrowLeftIcon className="h-4 w-4" />
			<span className="sr-only">Previous slide</span>
		</Button>
	);
};
CarouselPrevious.displayName = "CarouselPrevious";

const CarouselNext = ({
	ref,
	className,
	variant = "outline",
	size = "icon",
	...props
}: React.ComponentProps<typeof Button> & {
	ref: React.RefObject<HTMLButtonElement>;
}) => {
	const { orientation, scrollNext, canScrollNext } = useCarousel();

	return (
		<Button
			ref={ref}
			variant={variant}
			size={size}
			className={cn(
				"absolute h-8 w-8 rounded-full",
				orientation === "horizontal"
					? "-right-12 top-1/2 -translate-y-1/2"
					: "-bottom-12 left-1/2 -translate-x-1/2 rotate-90",
				className,
			)}
			disabled={!canScrollNext}
			onClick={scrollNext}
			{...props}
		>
			<ArrowRightIcon className="h-4 w-4" />
			<span className="sr-only">Next slide</span>
		</Button>
	);
};
CarouselNext.displayName = "CarouselNext";

export {
	type CarouselApi,
	Carousel,
	CarouselContent,
	CarouselItem,
	CarouselPrevious,
	CarouselNext,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/chart.tsx
```
"use client";

import * as React from "react";
import * as RechartsPrimitive from "recharts";

import { cn } from "@/lib/utils";

// Format: { THEME_NAME: CSS_SELECTOR }
const THEMES = { light: "", dark: ".dark" } as const;

export type ChartConfig = {
	[k in string]: {
		label?: React.ReactNode;
		icon?: React.ComponentType;
	} & (
		| { color?: string; theme?: never }
		| { color?: never; theme: Record<keyof typeof THEMES, string> }
	);
};

type ChartContextProps = {
	config: ChartConfig;
};

const ChartContext = React.createContext<ChartContextProps | null>(null);

function useChart() {
	const context = React.useContext(ChartContext);

	if (!context) {
		throw new Error("useChart must be used within a <ChartContainer />");
	}

	return context;
}

const ChartContainer = ({ ref, id, className, children, config, ...props }) => {
	const uniqueId = React.useId();
	const chartId = `chart-${id || uniqueId.replace(/:/g, "")}`;

	return (
		<ChartContext.Provider value={{ config }}>
			<div
				data-chart={chartId}
				ref={ref}
				className={cn(
					"flex aspect-video justify-center text-xs [&_.recharts-cartesian-axis-tick_text]:fill-muted-foreground [&_.recharts-cartesian-grid_line[stroke='#ccc']]:stroke-border/50 [&_.recharts-curve.recharts-tooltip-cursor]:stroke-border [&_.recharts-dot[stroke='#fff']]:stroke-transparent [&_.recharts-layer]:outline-none [&_.recharts-polar-grid_[stroke='#ccc']]:stroke-border [&_.recharts-radial-bar-background-sector]:fill-muted [&_.recharts-rectangle.recharts-tooltip-cursor]:fill-muted [&_.recharts-reference-line_[stroke='#ccc']]:stroke-border [&_.recharts-sector[stroke='#fff']]:stroke-transparent [&_.recharts-sector]:outline-none [&_.recharts-surface]:outline-none",
					className,
				)}
				{...props}
			>
				<ChartStyle id={chartId} config={config} />
				<RechartsPrimitive.ResponsiveContainer>
					{children}
				</RechartsPrimitive.ResponsiveContainer>
			</div>
		</ChartContext.Provider>
	);
};
ChartContainer.displayName = "Chart";

const ChartStyle = ({ id, config }: { id: string; config: ChartConfig }) => {
	const colorConfig = Object.entries(config).filter(
		([_, config]) => config.theme || config.color,
	);

	if (!colorConfig.length) {
		return null;
	}

	return (
		<style
			dangerouslySetInnerHTML={{
				__html: Object.entries(THEMES)
					.map(
						([theme, prefix]) => `
${prefix} [data-chart=${id}] {
${colorConfig
	.map(([key, itemConfig]) => {
		const color =
			itemConfig.theme?.[theme as keyof typeof itemConfig.theme] ||
			itemConfig.color;
		return color ? `  --color-${key}: ${color};` : null;
	})
	.join("\n")}
}
`,
					)
					.join("\n"),
			}}
		/>
	);
};

const ChartTooltip = RechartsPrimitive.Tooltip;

const ChartTooltipContent = ({
	ref,
	active,
	payload,
	className,
	indicator = "dot",
	hideLabel = false,
	hideIndicator = false,
	label,
	labelFormatter,
	labelClassName,
	formatter,
	color,
	nameKey,
	labelKey,
}) => {
	const { config } = useChart();

	const tooltipLabel = React.useMemo(() => {
		if (hideLabel || !payload?.length) {
			return null;
		}

		const [item] = payload;
		const key = `${labelKey || item.dataKey || item.name || "value"}`;
		const itemConfig = getPayloadConfigFromPayload(config, item, key);
		const value =
			!labelKey && typeof label === "string"
				? config[label as keyof typeof config]?.label || label
				: itemConfig?.label;

		if (labelFormatter) {
			return (
				<div className={cn("font-medium", labelClassName)}>
					{labelFormatter(value, payload)}
				</div>
			);
		}

		if (!value) {
			return null;
		}

		return <div className={cn("font-medium", labelClassName)}>{value}</div>;
	}, [
		label,
		labelFormatter,
		payload,
		hideLabel,
		labelClassName,
		config,
		labelKey,
	]);

	if (!active || !payload?.length) {
		return null;
	}

	const nestLabel = payload.length === 1 && indicator !== "dot";

	return (
		<div
			ref={ref}
			className={cn(
				"grid min-w-[8rem] items-start gap-1.5 rounded-lg border border-border/50 bg-background px-2.5 py-1.5 text-xs shadow-xl",
				className,
			)}
		>
			{!nestLabel ? tooltipLabel : null}
			<div className="grid gap-1.5">
				{payload.map((item, index) => {
					const key = `${nameKey || item.name || item.dataKey || "value"}`;
					const itemConfig = getPayloadConfigFromPayload(config, item, key);
					const indicatorColor = color || item.payload.fill || item.color;

					return (
						<div
							key={item.dataKey}
							className={cn(
								"flex w-full flex-wrap items-stretch gap-2 [&>svg]:h-2.5 [&>svg]:w-2.5 [&>svg]:text-muted-foreground",
								indicator === "dot" && "items-center",
							)}
						>
							{formatter && item?.value !== undefined && item.name ? (
								formatter(item.value, item.name, item, index, item.payload)
							) : (
								<>
									{itemConfig?.icon ? (
										<itemConfig.icon />
									) : (
										!hideIndicator && (
											<div
												className={cn(
													"shrink-0 rounded-[2px] border-[--color-border] bg-[--color-bg]",
													{
														"h-2.5 w-2.5": indicator === "dot",
														"w-1": indicator === "line",
														"w-0 border-[1.5px] border-dashed bg-transparent":
															indicator === "dashed",
														"my-0.5": nestLabel && indicator === "dashed",
													},
												)}
												style={
													{
														"--color-bg": indicatorColor,
														"--color-border": indicatorColor,
													} as React.CSSProperties
												}
											/>
										)
									)}
									<div
										className={cn(
											"flex flex-1 justify-between leading-none",
											nestLabel ? "items-end" : "items-center",
										)}
									>
										<div className="grid gap-1.5">
											{nestLabel ? tooltipLabel : null}
											<span className="text-muted-foreground">
												{itemConfig?.label || item.name}
											</span>
										</div>
										{item.value && (
											<span className="font-mono font-medium tabular-nums text-foreground">
												{item.value.toLocaleString()}
											</span>
										)}
									</div>
								</>
							)}
						</div>
					);
				})}
			</div>
		</div>
	);
};
ChartTooltipContent.displayName = "ChartTooltip";

const ChartLegend = RechartsPrimitive.Legend;

const ChartLegendContent = ({
	ref,
	className,
	hideIcon = false,
	payload,
	verticalAlign = "bottom",
	nameKey,
}) => {
	const { config } = useChart();

	if (!payload?.length) {
		return null;
	}

	return (
		<div
			ref={ref}
			className={cn(
				"flex items-center justify-center gap-4",
				verticalAlign === "top" ? "pb-3" : "pt-3",
				className,
			)}
		>
			{payload.map((item) => {
				const key = `${nameKey || item.dataKey || "value"}`;
				const itemConfig = getPayloadConfigFromPayload(config, item, key);

				return (
					<div
						key={item.value}
						className={cn(
							"flex items-center gap-1.5 [&>svg]:h-3 [&>svg]:w-3 [&>svg]:text-muted-foreground",
						)}
					>
						{itemConfig?.icon && !hideIcon ? (
							<itemConfig.icon />
						) : (
							<div
								className="h-2 w-2 shrink-0 rounded-[2px]"
								style={{
									backgroundColor: item.color,
								}}
							/>
						)}
						{itemConfig?.label}
					</div>
				);
			})}
		</div>
	);
};
ChartLegendContent.displayName = "ChartLegend";

// Helper to extract item config from a payload.
function getPayloadConfigFromPayload(
	config: ChartConfig,
	payload: unknown,
	key: string,
) {
	if (typeof payload !== "object" || payload === null) {
		return undefined;
	}

	const payloadPayload =
		"payload" in payload &&
		typeof payload.payload === "object" &&
		payload.payload !== null
			? payload.payload
			: undefined;

	let configLabelKey: string = key;

	if (
		key in payload &&
		typeof payload[key as keyof typeof payload] === "string"
	) {
		configLabelKey = payload[key as keyof typeof payload] as string;
	} else if (
		payloadPayload &&
		key in payloadPayload &&
		typeof payloadPayload[key as keyof typeof payloadPayload] === "string"
	) {
		configLabelKey = payloadPayload[
			key as keyof typeof payloadPayload
		] as string;
	}

	return configLabelKey in config
		? config[configLabelKey]
		: config[key as keyof typeof config];
}

export {
	ChartContainer,
	ChartTooltip,
	ChartTooltipContent,
	ChartLegend,
	ChartLegendContent,
	ChartStyle,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/checkbox.tsx
```
"use client";

import * as React from "react";
import * as CheckboxPrimitive from "@radix-ui/react-checkbox";
import { CheckIcon } from "@radix-ui/react-icons";

import { cn } from "@/lib/utils";

const Checkbox = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof CheckboxPrimitive.Root> & {
	ref: React.RefObject<React.ElementRef<typeof CheckboxPrimitive.Root>>;
}) => (
	<CheckboxPrimitive.Root
		ref={ref}
		className={cn(
			"peer h-4 w-4 shrink-0 rounded-sm border border-primary shadow focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground",
			className,
		)}
		{...props}
	>
		<CheckboxPrimitive.Indicator
			className={cn("flex items-center justify-center text-current")}
		>
			<CheckIcon className="h-4 w-4" />
		</CheckboxPrimitive.Indicator>
	</CheckboxPrimitive.Root>
);
Checkbox.displayName = CheckboxPrimitive.Root.displayName;

export { Checkbox };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/collapsible.tsx
```
"use client";

import * as CollapsiblePrimitive from "@radix-ui/react-collapsible";

const Collapsible = CollapsiblePrimitive.Root;

const CollapsibleTrigger = CollapsiblePrimitive.CollapsibleTrigger;

const CollapsibleContent = CollapsiblePrimitive.CollapsibleContent;

export { Collapsible, CollapsibleTrigger, CollapsibleContent };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/command.tsx
```
"use client";

import * as React from "react";
import { type DialogProps } from "@radix-ui/react-dialog";
import { MagnifyingGlassIcon } from "@radix-ui/react-icons";
import { Command as CommandPrimitive } from "cmdk";

import { cn } from "@/lib/utils";
import { Dialog, DialogContent } from "@/components/ui/dialog";

const Command = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof CommandPrimitive> & {
	ref: React.RefObject<React.ElementRef<typeof CommandPrimitive>>;
}) => (
	<CommandPrimitive
		ref={ref}
		className={cn(
			"flex h-full w-full flex-col overflow-hidden rounded-md bg-popover text-popover-foreground",
			className,
		)}
		{...props}
	/>
);
Command.displayName = CommandPrimitive.displayName;

interface CommandDialogProps extends DialogProps {}

const CommandDialog = ({ children, ...props }: CommandDialogProps) => {
	return (
		<Dialog {...props}>
			<DialogContent className="overflow-hidden p-0">
				<Command className="[&_[cmdk-group-heading]]:px-2 [&_[cmdk-group-heading]]:font-medium [&_[cmdk-group-heading]]:text-muted-foreground [&_[cmdk-group]:not([hidden])_~[cmdk-group]]:pt-0 [&_[cmdk-group]]:px-2 [&_[cmdk-input-wrapper]_svg]:h-5 [&_[cmdk-input-wrapper]_svg]:w-5 [&_[cmdk-input]]:h-12 [&_[cmdk-item]]:px-2 [&_[cmdk-item]]:py-3 [&_[cmdk-item]_svg]:h-5 [&_[cmdk-item]_svg]:w-5">
					{children}
				</Command>
			</DialogContent>
		</Dialog>
	);
};

const CommandInput = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof CommandPrimitive.Input> & {
	ref: React.RefObject<React.ElementRef<typeof CommandPrimitive.Input>>;
}) => (
	<div className="flex items-center border-b px-3" cmdk-input-wrapper="">
		<MagnifyingGlassIcon className="mr-2 h-4 w-4 shrink-0 opacity-50" />
		<CommandPrimitive.Input
			ref={ref}
			className={cn(
				"flex h-10 w-full rounded-md bg-transparent py-3 text-sm outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50",
				className,
			)}
			{...props}
		/>
	</div>
);

CommandInput.displayName = CommandPrimitive.Input.displayName;

const CommandList = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof CommandPrimitive.List> & {
	ref: React.RefObject<React.ElementRef<typeof CommandPrimitive.List>>;
}) => (
	<CommandPrimitive.List
		ref={ref}
		className={cn("max-h-[300px] overflow-y-auto overflow-x-hidden", className)}
		{...props}
	/>
);

CommandList.displayName = CommandPrimitive.List.displayName;

const CommandEmpty = ({
	ref,
	...props
}: React.ComponentPropsWithoutRef<typeof CommandPrimitive.Empty> & {
	ref: React.RefObject<React.ElementRef<typeof CommandPrimitive.Empty>>;
}) => (
	<CommandPrimitive.Empty
		ref={ref}
		className="py-6 text-center text-sm"
		{...props}
	/>
);

CommandEmpty.displayName = CommandPrimitive.Empty.displayName;

const CommandGroup = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof CommandPrimitive.Group> & {
	ref: React.RefObject<React.ElementRef<typeof CommandPrimitive.Group>>;
}) => (
	<CommandPrimitive.Group
		ref={ref}
		className={cn(
			"overflow-hidden p-1 text-foreground [&_[cmdk-group-heading]]:px-2 [&_[cmdk-group-heading]]:py-1.5 [&_[cmdk-group-heading]]:text-xs [&_[cmdk-group-heading]]:font-medium [&_[cmdk-group-heading]]:text-muted-foreground",
			className,
		)}
		{...props}
	/>
);

CommandGroup.displayName = CommandPrimitive.Group.displayName;

const CommandSeparator = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof CommandPrimitive.Separator> & {
	ref: React.RefObject<React.ElementRef<typeof CommandPrimitive.Separator>>;
}) => (
	<CommandPrimitive.Separator
		ref={ref}
		className={cn("-mx-1 h-px bg-border", className)}
		{...props}
	/>
);
CommandSeparator.displayName = CommandPrimitive.Separator.displayName;

const CommandItem = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof CommandPrimitive.Item> & {
	ref: React.RefObject<React.ElementRef<typeof CommandPrimitive.Item>>;
}) => (
	<CommandPrimitive.Item
		ref={ref}
		className={cn(
			"relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none data-[disabled=true]:pointer-events-none data-[selected=true]:bg-accent data-[selected=true]:text-accent-foreground data-[disabled=true]:opacity-50",
			className,
		)}
		{...props}
	/>
);

CommandItem.displayName = CommandPrimitive.Item.displayName;

const CommandShortcut = ({
	className,
	...props
}: React.HTMLAttributes<HTMLSpanElement>) => {
	return (
		<span
			className={cn(
				"ml-auto text-xs tracking-widest text-muted-foreground",
				className,
			)}
			{...props}
		/>
	);
};
CommandShortcut.displayName = "CommandShortcut";

export {
	Command,
	CommandDialog,
	CommandInput,
	CommandList,
	CommandEmpty,
	CommandGroup,
	CommandItem,
	CommandShortcut,
	CommandSeparator,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/context-menu.tsx
```
"use client";

import * as React from "react";
import * as ContextMenuPrimitive from "@radix-ui/react-context-menu";
import {
	CheckIcon,
	ChevronRightIcon,
	DotFilledIcon,
} from "@radix-ui/react-icons";

import { cn } from "@/lib/utils";

const ContextMenu = ContextMenuPrimitive.Root;

const ContextMenuTrigger = ContextMenuPrimitive.Trigger;

const ContextMenuGroup = ContextMenuPrimitive.Group;

const ContextMenuPortal = ContextMenuPrimitive.Portal;

const ContextMenuSub = ContextMenuPrimitive.Sub;

const ContextMenuRadioGroup = ContextMenuPrimitive.RadioGroup;

const ContextMenuSubTrigger = ({
	ref,
	className,
	inset,
	children,
	...props
}) => (
	<ContextMenuPrimitive.SubTrigger
		ref={ref}
		className={cn(
			"flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground",
			inset && "pl-8",
			className,
		)}
		{...props}
	>
		{children}
		<ChevronRightIcon className="ml-auto h-4 w-4" />
	</ContextMenuPrimitive.SubTrigger>
);
ContextMenuSubTrigger.displayName = ContextMenuPrimitive.SubTrigger.displayName;

const ContextMenuSubContent = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof ContextMenuPrimitive.SubContent> & {
	ref: React.RefObject<
		React.ElementRef<typeof ContextMenuPrimitive.SubContent>
	>;
}) => (
	<ContextMenuPrimitive.SubContent
		ref={ref}
		className={cn(
			"z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-lg data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
			className,
		)}
		{...props}
	/>
);
ContextMenuSubContent.displayName = ContextMenuPrimitive.SubContent.displayName;

const ContextMenuContent = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof ContextMenuPrimitive.Content> & {
	ref: React.RefObject<React.ElementRef<typeof ContextMenuPrimitive.Content>>;
}) => (
	<ContextMenuPrimitive.Portal>
		<ContextMenuPrimitive.Content
			ref={ref}
			className={cn(
				"z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
				className,
			)}
			{...props}
		/>
	</ContextMenuPrimitive.Portal>
);
ContextMenuContent.displayName = ContextMenuPrimitive.Content.displayName;

const ContextMenuItem = ({ ref, className, inset, ...props }) => (
	<ContextMenuPrimitive.Item
		ref={ref}
		className={cn(
			"relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
			inset && "pl-8",
			className,
		)}
		{...props}
	/>
);
ContextMenuItem.displayName = ContextMenuPrimitive.Item.displayName;

const ContextMenuCheckboxItem = ({
	ref,
	className,
	children,
	checked,
	...props
}: React.ComponentPropsWithoutRef<typeof ContextMenuPrimitive.CheckboxItem> & {
	ref: React.RefObject<
		React.ElementRef<typeof ContextMenuPrimitive.CheckboxItem>
	>;
}) => (
	<ContextMenuPrimitive.CheckboxItem
		ref={ref}
		className={cn(
			"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
			className,
		)}
		checked={checked}
		{...props}
	>
		<span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
			<ContextMenuPrimitive.ItemIndicator>
				<CheckIcon className="h-4 w-4" />
			</ContextMenuPrimitive.ItemIndicator>
		</span>
		{children}
	</ContextMenuPrimitive.CheckboxItem>
);
ContextMenuCheckboxItem.displayName =
	ContextMenuPrimitive.CheckboxItem.displayName;

const ContextMenuRadioItem = ({
	ref,
	className,
	children,
	...props
}: React.ComponentPropsWithoutRef<typeof ContextMenuPrimitive.RadioItem> & {
	ref: React.RefObject<React.ElementRef<typeof ContextMenuPrimitive.RadioItem>>;
}) => (
	<ContextMenuPrimitive.RadioItem
		ref={ref}
		className={cn(
			"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
			className,
		)}
		{...props}
	>
		<span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
			<ContextMenuPrimitive.ItemIndicator>
				<DotFilledIcon className="h-4 w-4 fill-current" />
			</ContextMenuPrimitive.ItemIndicator>
		</span>
		{children}
	</ContextMenuPrimitive.RadioItem>
);
ContextMenuRadioItem.displayName = ContextMenuPrimitive.RadioItem.displayName;

const ContextMenuLabel = ({ ref, className, inset, ...props }) => (
	<ContextMenuPrimitive.Label
		ref={ref}
		className={cn(
			"px-2 py-1.5 text-sm font-semibold text-foreground",
			inset && "pl-8",
			className,
		)}
		{...props}
	/>
);
ContextMenuLabel.displayName = ContextMenuPrimitive.Label.displayName;

const ContextMenuSeparator = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof ContextMenuPrimitive.Separator> & {
	ref: React.RefObject<React.ElementRef<typeof ContextMenuPrimitive.Separator>>;
}) => (
	<ContextMenuPrimitive.Separator
		ref={ref}
		className={cn("-mx-1 my-1 h-px bg-border", className)}
		{...props}
	/>
);
ContextMenuSeparator.displayName = ContextMenuPrimitive.Separator.displayName;

const ContextMenuShortcut = ({
	className,
	...props
}: React.HTMLAttributes<HTMLSpanElement>) => {
	return (
		<span
			className={cn(
				"ml-auto text-xs tracking-widest text-muted-foreground",
				className,
			)}
			{...props}
		/>
	);
};
ContextMenuShortcut.displayName = "ContextMenuShortcut";

export {
	ContextMenu,
	ContextMenuTrigger,
	ContextMenuContent,
	ContextMenuItem,
	ContextMenuCheckboxItem,
	ContextMenuRadioItem,
	ContextMenuLabel,
	ContextMenuSeparator,
	ContextMenuShortcut,
	ContextMenuGroup,
	ContextMenuPortal,
	ContextMenuSub,
	ContextMenuSubContent,
	ContextMenuSubTrigger,
	ContextMenuRadioGroup,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/copy-button.tsx
```
import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Copy, Check } from "lucide-react";
import {
	Tooltip,
	TooltipContent,
	TooltipProvider,
	TooltipTrigger,
} from "@/components/ui/tooltip";

interface CopyButtonProps {
	textToCopy: string;
}

export default function CopyButton({ textToCopy }: CopyButtonProps) {
	const [isCopied, setIsCopied] = useState(false);

	useEffect(() => {
		if (isCopied) {
			const timer = setTimeout(() => setIsCopied(false), 2000);
			return () => clearTimeout(timer);
		}
	}, [isCopied]);

	const handleCopy = async () => {
		try {
			await navigator.clipboard.writeText(textToCopy);
			setIsCopied(true);
		} catch (err) {
			console.error("Failed to copy text: ", err);
		}
	};

	return (
		<TooltipProvider>
			<Tooltip>
				<TooltipTrigger asChild>
					<Button
						variant="link"
						size="icon"
						onClick={handleCopy}
						className="h-8 w-8"
					>
						{isCopied ? (
							<Check className="h-4 w-4 " />
						) : (
							<Copy className="h-4 w-4" />
						)}
						<span className="sr-only">Copy to clipboard</span>
					</Button>
				</TooltipTrigger>
				<TooltipContent>
					<p>{isCopied ? "Copied!" : "Copy to clipboard"}</p>
				</TooltipContent>
			</Tooltip>
		</TooltipProvider>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/dialog.tsx
```
"use client";

import * as React from "react";
import * as DialogPrimitive from "@radix-ui/react-dialog";
import { Cross2Icon } from "@radix-ui/react-icons";

import { cn } from "@/lib/utils";

const Dialog = DialogPrimitive.Root;

const DialogTrigger = DialogPrimitive.Trigger;

const DialogPortal = DialogPrimitive.Portal;

const DialogClose = DialogPrimitive.Close;

const DialogOverlay = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof DialogPrimitive.Overlay> & {
	ref: React.RefObject<React.ElementRef<typeof DialogPrimitive.Overlay>>;
}) => (
	<DialogPrimitive.Overlay
		ref={ref}
		className={cn(
			"fixed inset-0 z-50 bg-black/80  data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
			className,
		)}
		{...props}
	/>
);
DialogOverlay.displayName = DialogPrimitive.Overlay.displayName;

const DialogContent = ({
	ref,
	className,
	children,
	...props
}: React.ComponentPropsWithoutRef<typeof DialogPrimitive.Content> & {
	ref: React.RefObject<React.ElementRef<typeof DialogPrimitive.Content>>;
}) => (
	<DialogPortal>
		<DialogOverlay />
		<DialogPrimitive.Content
			ref={ref}
			className={cn(
				"fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border bg-background p-6 shadow-lg duration-200 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=closed]:slide-out-to-left-1/2 data-[state=closed]:slide-out-to-top-[48%] data-[state=open]:slide-in-from-left-1/2 data-[state=open]:slide-in-from-top-[48%] sm:rounded-lg",
				className,
			)}
			{...props}
		>
			{children}
			<DialogPrimitive.Close className="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground">
				<Cross2Icon className="h-4 w-4" />
				<span className="sr-only">Close</span>
			</DialogPrimitive.Close>
		</DialogPrimitive.Content>
	</DialogPortal>
);
DialogContent.displayName = DialogPrimitive.Content.displayName;

const DialogHeader = ({
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement>) => (
	<div
		className={cn(
			"flex flex-col space-y-1.5 text-center sm:text-left",
			className,
		)}
		{...props}
	/>
);
DialogHeader.displayName = "DialogHeader";

const DialogFooter = ({
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement>) => (
	<div
		className={cn(
			"flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",
			className,
		)}
		{...props}
	/>
);
DialogFooter.displayName = "DialogFooter";

const DialogTitle = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof DialogPrimitive.Title> & {
	ref: React.RefObject<React.ElementRef<typeof DialogPrimitive.Title>>;
}) => (
	<DialogPrimitive.Title
		ref={ref}
		className={cn(
			"text-lg font-semibold leading-none tracking-tight",
			className,
		)}
		{...props}
	/>
);
DialogTitle.displayName = DialogPrimitive.Title.displayName;

const DialogDescription = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof DialogPrimitive.Description> & {
	ref: React.RefObject<React.ElementRef<typeof DialogPrimitive.Description>>;
}) => (
	<DialogPrimitive.Description
		ref={ref}
		className={cn("text-sm text-muted-foreground", className)}
		{...props}
	/>
);
DialogDescription.displayName = DialogPrimitive.Description.displayName;

export {
	Dialog,
	DialogPortal,
	DialogOverlay,
	DialogTrigger,
	DialogClose,
	DialogContent,
	DialogHeader,
	DialogFooter,
	DialogTitle,
	DialogDescription,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/drawer.tsx
```
"use client";

import * as React from "react";
import { Drawer as DrawerPrimitive } from "vaul";

import { cn } from "@/lib/utils";

const Drawer = ({
	shouldScaleBackground = true,
	...props
}: React.ComponentProps<typeof DrawerPrimitive.Root>) => (
	<DrawerPrimitive.Root
		shouldScaleBackground={shouldScaleBackground}
		{...props}
	/>
);
Drawer.displayName = "Drawer";

const DrawerTrigger = DrawerPrimitive.Trigger;

const DrawerPortal = DrawerPrimitive.Portal;

const DrawerClose = DrawerPrimitive.Close;

const DrawerOverlay = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof DrawerPrimitive.Overlay> & {
	ref: React.RefObject<React.ElementRef<typeof DrawerPrimitive.Overlay>>;
}) => (
	<DrawerPrimitive.Overlay
		ref={ref}
		className={cn("fixed inset-0 z-50 bg-black/80", className)}
		{...props}
	/>
);
DrawerOverlay.displayName = DrawerPrimitive.Overlay.displayName;

const DrawerContent = ({
	ref,
	className,
	children,
	...props
}: React.ComponentPropsWithoutRef<typeof DrawerPrimitive.Content> & {
	ref: React.RefObject<React.ElementRef<typeof DrawerPrimitive.Content>>;
}) => (
	<DrawerPortal>
		<DrawerOverlay />
		<DrawerPrimitive.Content
			ref={ref}
			className={cn(
				"fixed inset-x-0 bottom-0 z-50 mt-24 flex h-auto flex-col rounded-t-[10px] border bg-background",
				className,
			)}
			{...props}
		>
			<div className="mx-auto mt-4 h-2 w-[100px] rounded-full bg-muted" />
			{children}
		</DrawerPrimitive.Content>
	</DrawerPortal>
);
DrawerContent.displayName = "DrawerContent";

const DrawerHeader = ({
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement>) => (
	<div
		className={cn("grid gap-1.5 p-4 text-center sm:text-left", className)}
		{...props}
	/>
);
DrawerHeader.displayName = "DrawerHeader";

const DrawerFooter = ({
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement>) => (
	<div
		className={cn("mt-auto flex flex-col gap-2 p-4", className)}
		{...props}
	/>
);
DrawerFooter.displayName = "DrawerFooter";

const DrawerTitle = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof DrawerPrimitive.Title> & {
	ref: React.RefObject<React.ElementRef<typeof DrawerPrimitive.Title>>;
}) => (
	<DrawerPrimitive.Title
		ref={ref}
		className={cn(
			"text-lg font-semibold leading-none tracking-tight",
			className,
		)}
		{...props}
	/>
);
DrawerTitle.displayName = DrawerPrimitive.Title.displayName;

const DrawerDescription = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof DrawerPrimitive.Description> & {
	ref: React.RefObject<React.ElementRef<typeof DrawerPrimitive.Description>>;
}) => (
	<DrawerPrimitive.Description
		ref={ref}
		className={cn("text-sm text-muted-foreground", className)}
		{...props}
	/>
);
DrawerDescription.displayName = DrawerPrimitive.Description.displayName;

export {
	Drawer,
	DrawerPortal,
	DrawerOverlay,
	DrawerTrigger,
	DrawerClose,
	DrawerContent,
	DrawerHeader,
	DrawerFooter,
	DrawerTitle,
	DrawerDescription,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/dropdown-menu.tsx
```
"use client";

import * as React from "react";
import * as DropdownMenuPrimitive from "@radix-ui/react-dropdown-menu";
import {
	CheckIcon,
	ChevronRightIcon,
	DotFilledIcon,
} from "@radix-ui/react-icons";

import { cn } from "@/lib/utils";

const DropdownMenu = DropdownMenuPrimitive.Root;

const DropdownMenuTrigger = DropdownMenuPrimitive.Trigger;

const DropdownMenuGroup = DropdownMenuPrimitive.Group;

const DropdownMenuPortal = DropdownMenuPrimitive.Portal;

const DropdownMenuSub = DropdownMenuPrimitive.Sub;

const DropdownMenuRadioGroup = DropdownMenuPrimitive.RadioGroup;

const DropdownMenuSubTrigger = ({
	ref,
	className,
	inset,
	children,
	...props
}) => (
	<DropdownMenuPrimitive.SubTrigger
		ref={ref}
		className={cn(
			"flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent data-[state=open]:bg-accent",
			inset && "pl-8",
			className,
		)}
		{...props}
	>
		{children}
		<ChevronRightIcon className="ml-auto h-4 w-4" />
	</DropdownMenuPrimitive.SubTrigger>
);
DropdownMenuSubTrigger.displayName =
	DropdownMenuPrimitive.SubTrigger.displayName;

const DropdownMenuSubContent = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.SubContent> & {
	ref: React.RefObject<
		React.ElementRef<typeof DropdownMenuPrimitive.SubContent>
	>;
}) => (
	<DropdownMenuPrimitive.SubContent
		ref={ref}
		className={cn(
			"z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-lg data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
			className,
		)}
		{...props}
	/>
);
DropdownMenuSubContent.displayName =
	DropdownMenuPrimitive.SubContent.displayName;

const DropdownMenuContent = ({
	ref,
	className,
	sideOffset = 4,
	...props
}: React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.Content> & {
	ref: React.RefObject<React.ElementRef<typeof DropdownMenuPrimitive.Content>>;
}) => (
	<DropdownMenuPrimitive.Portal>
		<DropdownMenuPrimitive.Content
			ref={ref}
			sideOffset={sideOffset}
			className={cn(
				"z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md",
				"data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
				className,
			)}
			{...props}
		/>
	</DropdownMenuPrimitive.Portal>
);
DropdownMenuContent.displayName = DropdownMenuPrimitive.Content.displayName;

const DropdownMenuItem = ({ ref, className, inset, ...props }) => (
	<DropdownMenuPrimitive.Item
		ref={ref}
		className={cn(
			"relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
			inset && "pl-8",
			className,
		)}
		{...props}
	/>
);
DropdownMenuItem.displayName = DropdownMenuPrimitive.Item.displayName;

const DropdownMenuCheckboxItem = ({
	ref,
	className,
	children,
	checked,
	...props
}: React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.CheckboxItem> & {
	ref: React.RefObject<
		React.ElementRef<typeof DropdownMenuPrimitive.CheckboxItem>
	>;
}) => (
	<DropdownMenuPrimitive.CheckboxItem
		ref={ref}
		className={cn(
			"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
			className,
		)}
		checked={checked}
		{...props}
	>
		<span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
			<DropdownMenuPrimitive.ItemIndicator>
				<CheckIcon className="h-4 w-4" />
			</DropdownMenuPrimitive.ItemIndicator>
		</span>
		{children}
	</DropdownMenuPrimitive.CheckboxItem>
);
DropdownMenuCheckboxItem.displayName =
	DropdownMenuPrimitive.CheckboxItem.displayName;

const DropdownMenuRadioItem = ({
	ref,
	className,
	children,
	...props
}: React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.RadioItem> & {
	ref: React.RefObject<
		React.ElementRef<typeof DropdownMenuPrimitive.RadioItem>
	>;
}) => (
	<DropdownMenuPrimitive.RadioItem
		ref={ref}
		className={cn(
			"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
			className,
		)}
		{...props}
	>
		<span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
			<DropdownMenuPrimitive.ItemIndicator>
				<DotFilledIcon className="h-4 w-4 fill-current" />
			</DropdownMenuPrimitive.ItemIndicator>
		</span>
		{children}
	</DropdownMenuPrimitive.RadioItem>
);
DropdownMenuRadioItem.displayName = DropdownMenuPrimitive.RadioItem.displayName;

const DropdownMenuLabel = ({ ref, className, inset, ...props }) => (
	<DropdownMenuPrimitive.Label
		ref={ref}
		className={cn(
			"px-2 py-1.5 text-sm font-semibold",
			inset && "pl-8",
			className,
		)}
		{...props}
	/>
);
DropdownMenuLabel.displayName = DropdownMenuPrimitive.Label.displayName;

const DropdownMenuSeparator = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.Separator> & {
	ref: React.RefObject<
		React.ElementRef<typeof DropdownMenuPrimitive.Separator>
	>;
}) => (
	<DropdownMenuPrimitive.Separator
		ref={ref}
		className={cn("-mx-1 my-1 h-px bg-muted", className)}
		{...props}
	/>
);
DropdownMenuSeparator.displayName = DropdownMenuPrimitive.Separator.displayName;

const DropdownMenuShortcut = ({
	className,
	...props
}: React.HTMLAttributes<HTMLSpanElement>) => {
	return (
		<span
			className={cn("ml-auto text-xs tracking-widest opacity-60", className)}
			{...props}
		/>
	);
};
DropdownMenuShortcut.displayName = "DropdownMenuShortcut";

export {
	DropdownMenu,
	DropdownMenuTrigger,
	DropdownMenuContent,
	DropdownMenuItem,
	DropdownMenuCheckboxItem,
	DropdownMenuRadioItem,
	DropdownMenuLabel,
	DropdownMenuSeparator,
	DropdownMenuShortcut,
	DropdownMenuGroup,
	DropdownMenuPortal,
	DropdownMenuSub,
	DropdownMenuSubContent,
	DropdownMenuSubTrigger,
	DropdownMenuRadioGroup,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/form.tsx
```
"use client";

import * as React from "react";
import * as LabelPrimitive from "@radix-ui/react-label";
import { Slot } from "@radix-ui/react-slot";
import {
	Controller,
	ControllerProps,
	FieldPath,
	FieldValues,
	FormProvider,
	useFormContext,
} from "react-hook-form";

import { cn } from "@/lib/utils";
import { Label } from "@/components/ui/label";

const Form = FormProvider;

type FormFieldContextValue<
	TFieldValues extends FieldValues = FieldValues,
	TName extends FieldPath<TFieldValues> = FieldPath<TFieldValues>,
> = {
	name: TName;
};

const FormFieldContext = React.createContext<FormFieldContextValue>(
	{} as FormFieldContextValue,
);

const FormField = <
	TFieldValues extends FieldValues = FieldValues,
	TName extends FieldPath<TFieldValues> = FieldPath<TFieldValues>,
>({
	...props
}: ControllerProps<TFieldValues, TName>) => {
	return (
		<FormFieldContext.Provider value={{ name: props.name }}>
			<Controller {...props} />
		</FormFieldContext.Provider>
	);
};

const useFormField = () => {
	const fieldContext = React.useContext(FormFieldContext);
	const itemContext = React.useContext(FormItemContext);
	const { getFieldState, formState } = useFormContext();

	const fieldState = getFieldState(fieldContext.name, formState);

	if (!fieldContext) {
		throw new Error("useFormField should be used within <FormField>");
	}

	const { id } = itemContext;

	return {
		id,
		name: fieldContext.name,
		formItemId: `${id}-form-item`,
		formDescriptionId: `${id}-form-item-description`,
		formMessageId: `${id}-form-item-message`,
		...fieldState,
	};
};

type FormItemContextValue = {
	id: string;
};

const FormItemContext = React.createContext<FormItemContextValue>(
	{} as FormItemContextValue,
);

const FormItem = ({
	ref,
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement> & {
	ref: React.RefObject<HTMLDivElement>;
}) => {
	const id = React.useId();

	return (
		<FormItemContext.Provider value={{ id }}>
			<div ref={ref} className={cn("space-y-2", className)} {...props} />
		</FormItemContext.Provider>
	);
};
FormItem.displayName = "FormItem";

const FormLabel = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof LabelPrimitive.Root> & {
	ref: React.RefObject<React.ElementRef<typeof LabelPrimitive.Root>>;
}) => {
	const { error, formItemId } = useFormField();

	return (
		<Label
			ref={ref}
			className={cn(error && "text-destructive", className)}
			htmlFor={formItemId}
			{...props}
		/>
	);
};
FormLabel.displayName = "FormLabel";

const FormControl = ({
	ref,
	...props
}: React.ComponentPropsWithoutRef<typeof Slot> & {
	ref: React.RefObject<React.ElementRef<typeof Slot>>;
}) => {
	const { error, formItemId, formDescriptionId, formMessageId } =
		useFormField();

	return (
		<Slot
			ref={ref}
			id={formItemId}
			aria-describedby={
				!error
					? `${formDescriptionId}`
					: `${formDescriptionId} ${formMessageId}`
			}
			aria-invalid={!!error}
			{...props}
		/>
	);
};
FormControl.displayName = "FormControl";

const FormDescription = ({
	ref,
	className,
	...props
}: React.HTMLAttributes<HTMLParagraphElement> & {
	ref: React.RefObject<HTMLParagraphElement>;
}) => {
	const { formDescriptionId } = useFormField();

	return (
		<p
			ref={ref}
			id={formDescriptionId}
			className={cn("text-[0.8rem] text-muted-foreground", className)}
			{...props}
		/>
	);
};
FormDescription.displayName = "FormDescription";

const FormMessage = ({
	ref,
	className,
	children,
	...props
}: React.HTMLAttributes<HTMLParagraphElement> & {
	ref: React.RefObject<HTMLParagraphElement>;
}) => {
	const { error, formMessageId } = useFormField();
	const body = error ? String(error?.message) : children;

	if (!body) {
		return null;
	}

	return (
		<p
			ref={ref}
			id={formMessageId}
			className={cn("text-[0.8rem] font-medium text-destructive", className)}
			{...props}
		>
			{body}
		</p>
	);
};
FormMessage.displayName = "FormMessage";

export {
	useFormField,
	Form,
	FormItem,
	FormLabel,
	FormControl,
	FormDescription,
	FormMessage,
	FormField,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/hover-card.tsx
```
"use client";

import * as React from "react";
import * as HoverCardPrimitive from "@radix-ui/react-hover-card";

import { cn } from "@/lib/utils";

const HoverCard = HoverCardPrimitive.Root;

const HoverCardTrigger = HoverCardPrimitive.Trigger;

const HoverCardContent = ({
	ref,
	className,
	align = "center",
	sideOffset = 4,
	...props
}: React.ComponentPropsWithoutRef<typeof HoverCardPrimitive.Content> & {
	ref: React.RefObject<React.ElementRef<typeof HoverCardPrimitive.Content>>;
}) => (
	<HoverCardPrimitive.Content
		ref={ref}
		align={align}
		sideOffset={sideOffset}
		className={cn(
			"z-50 w-64 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
			className,
		)}
		{...props}
	/>
);
HoverCardContent.displayName = HoverCardPrimitive.Content.displayName;

export { HoverCard, HoverCardTrigger, HoverCardContent };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/input-otp.tsx
```
"use client";

import * as React from "react";
import { DashIcon } from "@radix-ui/react-icons";
import { OTPInput, OTPInputContext } from "input-otp";

import { cn } from "@/lib/utils";

const InputOTP = ({
	ref,
	className,
	containerClassName,
	...props
}: React.ComponentPropsWithoutRef<typeof OTPInput> & {
	ref: React.RefObject<React.ElementRef<typeof OTPInput>>;
}) => (
	<OTPInput
		ref={ref}
		containerClassName={cn(
			"flex items-center gap-2 has-[:disabled]:opacity-50",
			containerClassName,
		)}
		className={cn("disabled:cursor-not-allowed", className)}
		{...props}
	/>
);
InputOTP.displayName = "InputOTP";

const InputOTPGroup = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<"div"> & {
	ref: React.RefObject<React.ElementRef<"div">>;
}) => (
	<div ref={ref} className={cn("flex items-center", className)} {...props} />
);
InputOTPGroup.displayName = "InputOTPGroup";

const InputOTPSlot = ({ ref, index, className, ...props }) => {
	const inputOTPContext = React.useContext(OTPInputContext);
	const { char, hasFakeCaret, isActive } = inputOTPContext.slots[index];

	return (
		<div
			ref={ref}
			className={cn(
				"relative flex h-9 w-9 items-center justify-center border-y border-r border-input text-sm shadow-sm transition-all first:rounded-l-md first:border-l last:rounded-r-md",
				isActive && "z-10 ring-1 ring-ring",
				className,
			)}
			{...props}
		>
			{char}
			{hasFakeCaret && (
				<div className="pointer-events-none absolute inset-0 flex items-center justify-center">
					<div className="h-4 w-px animate-caret-blink bg-foreground duration-1000" />
				</div>
			)}
		</div>
	);
};
InputOTPSlot.displayName = "InputOTPSlot";

const InputOTPSeparator = ({
	ref,
	...props
}: React.ComponentPropsWithoutRef<"div"> & {
	ref: React.RefObject<React.ElementRef<"div">>;
}) => (
	<div ref={ref} role="separator" {...props}>
		<DashIcon />
	</div>
);
InputOTPSeparator.displayName = "InputOTPSeparator";

export { InputOTP, InputOTPGroup, InputOTPSlot, InputOTPSeparator };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/input.tsx
```
import * as React from "react";

import { cn } from "@/lib/utils";

export interface InputProps
	extends React.InputHTMLAttributes<HTMLInputElement> {}

const Input = ({
	ref,
	className,
	type,
	...props
}: InputProps & {
	ref: React.RefObject<HTMLInputElement>;
}) => {
	return (
		<input
			type={type}
			className={cn(
				"flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
				className,
			)}
			ref={ref}
			{...props}
		/>
	);
};
Input.displayName = "Input";

export { Input };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/label.tsx
```
"use client";
import * as LabelPrimitive from "@radix-ui/react-label";
import { cva } from "class-variance-authority";

import { cn } from "@/lib/utils";

const labelVariants = cva(
	"text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70",
);

const Label = ({ ref, className, ...props }) => (
	<LabelPrimitive.Root
		ref={ref}
		className={cn(labelVariants(), className)}
		{...props}
	/>
);
Label.displayName = LabelPrimitive.Root.displayName;

export { Label };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/menubar.tsx
```
"use client";

import * as React from "react";
import {
	CheckIcon,
	ChevronRightIcon,
	DotFilledIcon,
} from "@radix-ui/react-icons";
import * as MenubarPrimitive from "@radix-ui/react-menubar";

import { cn } from "@/lib/utils";

const MenubarMenu = MenubarPrimitive.Menu;

const MenubarGroup = MenubarPrimitive.Group;

const MenubarPortal = MenubarPrimitive.Portal;

const MenubarSub = MenubarPrimitive.Sub;

const MenubarRadioGroup = MenubarPrimitive.RadioGroup;

const Menubar = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof MenubarPrimitive.Root> & {
	ref: React.RefObject<React.ElementRef<typeof MenubarPrimitive.Root>>;
}) => (
	<MenubarPrimitive.Root
		ref={ref}
		className={cn(
			"flex h-9 items-center space-x-1 rounded-md border bg-background p-1 shadow-sm",
			className,
		)}
		{...props}
	/>
);
Menubar.displayName = MenubarPrimitive.Root.displayName;

const MenubarTrigger = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof MenubarPrimitive.Trigger> & {
	ref: React.RefObject<React.ElementRef<typeof MenubarPrimitive.Trigger>>;
}) => (
	<MenubarPrimitive.Trigger
		ref={ref}
		className={cn(
			"flex cursor-default select-none items-center rounded-sm px-3 py-1 text-sm font-medium outline-none focus:bg-accent focus:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground",
			className,
		)}
		{...props}
	/>
);
MenubarTrigger.displayName = MenubarPrimitive.Trigger.displayName;

const MenubarSubTrigger = ({ ref, className, inset, children, ...props }) => (
	<MenubarPrimitive.SubTrigger
		ref={ref}
		className={cn(
			"flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground",
			inset && "pl-8",
			className,
		)}
		{...props}
	>
		{children}
		<ChevronRightIcon className="ml-auto h-4 w-4" />
	</MenubarPrimitive.SubTrigger>
);
MenubarSubTrigger.displayName = MenubarPrimitive.SubTrigger.displayName;

const MenubarSubContent = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof MenubarPrimitive.SubContent> & {
	ref: React.RefObject<React.ElementRef<typeof MenubarPrimitive.SubContent>>;
}) => (
	<MenubarPrimitive.SubContent
		ref={ref}
		className={cn(
			"z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-lg data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
			className,
		)}
		{...props}
	/>
);
MenubarSubContent.displayName = MenubarPrimitive.SubContent.displayName;

const MenubarContent = ({
	ref,
	className,
	align = "start",
	alignOffset = -4,
	sideOffset = 8,
	...props
}: React.ComponentPropsWithoutRef<typeof MenubarPrimitive.Content> & {
	ref: React.RefObject<React.ElementRef<typeof MenubarPrimitive.Content>>;
}) => (
	<MenubarPrimitive.Portal>
		<MenubarPrimitive.Content
			ref={ref}
			align={align}
			alignOffset={alignOffset}
			sideOffset={sideOffset}
			className={cn(
				"z-50 min-w-[12rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
				className,
			)}
			{...props}
		/>
	</MenubarPrimitive.Portal>
);
MenubarContent.displayName = MenubarPrimitive.Content.displayName;

const MenubarItem = ({ ref, className, inset, ...props }) => (
	<MenubarPrimitive.Item
		ref={ref}
		className={cn(
			"relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
			inset && "pl-8",
			className,
		)}
		{...props}
	/>
);
MenubarItem.displayName = MenubarPrimitive.Item.displayName;

const MenubarCheckboxItem = ({
	ref,
	className,
	children,
	checked,
	...props
}: React.ComponentPropsWithoutRef<typeof MenubarPrimitive.CheckboxItem> & {
	ref: React.RefObject<React.ElementRef<typeof MenubarPrimitive.CheckboxItem>>;
}) => (
	<MenubarPrimitive.CheckboxItem
		ref={ref}
		className={cn(
			"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
			className,
		)}
		checked={checked}
		{...props}
	>
		<span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
			<MenubarPrimitive.ItemIndicator>
				<CheckIcon className="h-4 w-4" />
			</MenubarPrimitive.ItemIndicator>
		</span>
		{children}
	</MenubarPrimitive.CheckboxItem>
);
MenubarCheckboxItem.displayName = MenubarPrimitive.CheckboxItem.displayName;

const MenubarRadioItem = ({
	ref,
	className,
	children,
	...props
}: React.ComponentPropsWithoutRef<typeof MenubarPrimitive.RadioItem> & {
	ref: React.RefObject<React.ElementRef<typeof MenubarPrimitive.RadioItem>>;
}) => (
	<MenubarPrimitive.RadioItem
		ref={ref}
		className={cn(
			"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
			className,
		)}
		{...props}
	>
		<span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
			<MenubarPrimitive.ItemIndicator>
				<DotFilledIcon className="h-4 w-4 fill-current" />
			</MenubarPrimitive.ItemIndicator>
		</span>
		{children}
	</MenubarPrimitive.RadioItem>
);
MenubarRadioItem.displayName = MenubarPrimitive.RadioItem.displayName;

const MenubarLabel = ({ ref, className, inset, ...props }) => (
	<MenubarPrimitive.Label
		ref={ref}
		className={cn(
			"px-2 py-1.5 text-sm font-semibold",
			inset && "pl-8",
			className,
		)}
		{...props}
	/>
);
MenubarLabel.displayName = MenubarPrimitive.Label.displayName;

const MenubarSeparator = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof MenubarPrimitive.Separator> & {
	ref: React.RefObject<React.ElementRef<typeof MenubarPrimitive.Separator>>;
}) => (
	<MenubarPrimitive.Separator
		ref={ref}
		className={cn("-mx-1 my-1 h-px bg-muted", className)}
		{...props}
	/>
);
MenubarSeparator.displayName = MenubarPrimitive.Separator.displayName;

const MenubarShortcut = ({
	className,
	...props
}: React.HTMLAttributes<HTMLSpanElement>) => {
	return (
		<span
			className={cn(
				"ml-auto text-xs tracking-widest text-muted-foreground",
				className,
			)}
			{...props}
		/>
	);
};
MenubarShortcut.displayname = "MenubarShortcut";

export {
	Menubar,
	MenubarMenu,
	MenubarTrigger,
	MenubarContent,
	MenubarItem,
	MenubarSeparator,
	MenubarLabel,
	MenubarCheckboxItem,
	MenubarRadioGroup,
	MenubarRadioItem,
	MenubarPortal,
	MenubarSubContent,
	MenubarSubTrigger,
	MenubarGroup,
	MenubarSub,
	MenubarShortcut,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/navigation-menu.tsx
```
import * as React from "react";
import { ChevronDownIcon } from "@radix-ui/react-icons";
import * as NavigationMenuPrimitive from "@radix-ui/react-navigation-menu";
import { cva } from "class-variance-authority";

import { cn } from "@/lib/utils";

const NavigationMenu = ({
	ref,
	className,
	children,
	...props
}: React.ComponentPropsWithoutRef<typeof NavigationMenuPrimitive.Root> & {
	ref: React.RefObject<React.ElementRef<typeof NavigationMenuPrimitive.Root>>;
}) => (
	<NavigationMenuPrimitive.Root
		ref={ref}
		className={cn(
			"relative z-10 flex max-w-max flex-1 items-center justify-center",
			className,
		)}
		{...props}
	>
		{children}
		<NavigationMenuViewport />
	</NavigationMenuPrimitive.Root>
);
NavigationMenu.displayName = NavigationMenuPrimitive.Root.displayName;

const NavigationMenuList = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof NavigationMenuPrimitive.List> & {
	ref: React.RefObject<React.ElementRef<typeof NavigationMenuPrimitive.List>>;
}) => (
	<NavigationMenuPrimitive.List
		ref={ref}
		className={cn(
			"group flex flex-1 list-none items-center justify-center space-x-1",
			className,
		)}
		{...props}
	/>
);
NavigationMenuList.displayName = NavigationMenuPrimitive.List.displayName;

const NavigationMenuItem = NavigationMenuPrimitive.Item;

const navigationMenuTriggerStyle = cva(
	"group inline-flex h-9 w-max items-center justify-center rounded-md bg-background px-4 py-2 text-sm font-medium transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground focus:outline-none disabled:pointer-events-none disabled:opacity-50 data-[active]:bg-accent/50 data-[state=open]:bg-accent/50",
);

const NavigationMenuTrigger = ({
	ref,
	className,
	children,
	...props
}: React.ComponentPropsWithoutRef<typeof NavigationMenuPrimitive.Trigger> & {
	ref: React.RefObject<
		React.ElementRef<typeof NavigationMenuPrimitive.Trigger>
	>;
}) => (
	<NavigationMenuPrimitive.Trigger
		ref={ref}
		className={cn(navigationMenuTriggerStyle(), "group", className)}
		{...props}
	>
		{children}{" "}
		<ChevronDownIcon
			className="relative top-[1px] ml-1 h-3 w-3 transition duration-300 group-data-[state=open]:rotate-180"
			aria-hidden="true"
		/>
	</NavigationMenuPrimitive.Trigger>
);
NavigationMenuTrigger.displayName = NavigationMenuPrimitive.Trigger.displayName;

const NavigationMenuContent = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof NavigationMenuPrimitive.Content> & {
	ref: React.RefObject<
		React.ElementRef<typeof NavigationMenuPrimitive.Content>
	>;
}) => (
	<NavigationMenuPrimitive.Content
		ref={ref}
		className={cn(
			"left-0 top-0 w-full data-[motion^=from-]:animate-in data-[motion^=to-]:animate-out data-[motion^=from-]:fade-in data-[motion^=to-]:fade-out data-[motion=from-end]:slide-in-from-right-52 data-[motion=from-start]:slide-in-from-left-52 data-[motion=to-end]:slide-out-to-right-52 data-[motion=to-start]:slide-out-to-left-52 md:absolute md:w-auto ",
			className,
		)}
		{...props}
	/>
);
NavigationMenuContent.displayName = NavigationMenuPrimitive.Content.displayName;

const NavigationMenuLink = NavigationMenuPrimitive.Link;

const NavigationMenuViewport = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof NavigationMenuPrimitive.Viewport> & {
	ref: React.RefObject<
		React.ElementRef<typeof NavigationMenuPrimitive.Viewport>
	>;
}) => (
	<div className={cn("absolute left-0 top-full flex justify-center")}>
		<NavigationMenuPrimitive.Viewport
			className={cn(
				"origin-top-center relative mt-1.5 h-[var(--radix-navigation-menu-viewport-height)] w-full overflow-hidden rounded-md border bg-popover text-popover-foreground shadow data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-90 md:w-[var(--radix-navigation-menu-viewport-width)]",
				className,
			)}
			ref={ref}
			{...props}
		/>
	</div>
);
NavigationMenuViewport.displayName =
	NavigationMenuPrimitive.Viewport.displayName;

const NavigationMenuIndicator = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof NavigationMenuPrimitive.Indicator> & {
	ref: React.RefObject<
		React.ElementRef<typeof NavigationMenuPrimitive.Indicator>
	>;
}) => (
	<NavigationMenuPrimitive.Indicator
		ref={ref}
		className={cn(
			"top-full z-[1] flex h-1.5 items-end justify-center overflow-hidden data-[state=visible]:animate-in data-[state=hidden]:animate-out data-[state=hidden]:fade-out data-[state=visible]:fade-in",
			className,
		)}
		{...props}
	>
		<div className="relative top-[60%] h-2 w-2 rotate-45 rounded-tl-sm bg-border shadow-md" />
	</NavigationMenuPrimitive.Indicator>
);
NavigationMenuIndicator.displayName =
	NavigationMenuPrimitive.Indicator.displayName;

export {
	navigationMenuTriggerStyle,
	NavigationMenu,
	NavigationMenuList,
	NavigationMenuItem,
	NavigationMenuContent,
	NavigationMenuTrigger,
	NavigationMenuLink,
	NavigationMenuIndicator,
	NavigationMenuViewport,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/pagination.tsx
```
import * as React from "react";
import {
	ChevronLeftIcon,
	ChevronRightIcon,
	DotsHorizontalIcon,
} from "@radix-ui/react-icons";

import { cn } from "@/lib/utils";
import { ButtonProps, buttonVariants } from "@/components/ui/button";

const Pagination = ({ className, ...props }: React.ComponentProps<"nav">) => (
	<nav
		role="navigation"
		aria-label="pagination"
		className={cn("mx-auto flex w-full justify-center", className)}
		{...props}
	/>
);
Pagination.displayName = "Pagination";

const PaginationContent = ({
	ref,
	className,
	...props
}: React.ComponentProps<"ul"> & {
	ref: React.RefObject<HTMLUListElement>;
}) => (
	<ul
		ref={ref}
		className={cn("flex flex-row items-center gap-1", className)}
		{...props}
	/>
);
PaginationContent.displayName = "PaginationContent";

const PaginationItem = ({
	ref,
	className,
	...props
}: React.ComponentProps<"li"> & {
	ref: React.RefObject<HTMLLIElement>;
}) => <li ref={ref} className={cn("", className)} {...props} />;
PaginationItem.displayName = "PaginationItem";

type PaginationLinkProps = {
	isActive?: boolean;
} & Pick<ButtonProps, "size"> &
	React.ComponentProps<"a">;

const PaginationLink = ({
	className,
	isActive,
	size = "icon",
	...props
}: PaginationLinkProps) => (
	<a
		aria-current={isActive ? "page" : undefined}
		className={cn(
			buttonVariants({
				variant: isActive ? "outline" : "ghost",
				size,
			}),
			className,
		)}
		{...props}
	/>
);
PaginationLink.displayName = "PaginationLink";

const PaginationPrevious = ({
	className,
	...props
}: React.ComponentProps<typeof PaginationLink>) => (
	<PaginationLink
		aria-label="Go to previous page"
		size="default"
		className={cn("gap-1 pl-2.5", className)}
		{...props}
	>
		<ChevronLeftIcon className="h-4 w-4" />
		<span>Previous</span>
	</PaginationLink>
);
PaginationPrevious.displayName = "PaginationPrevious";

const PaginationNext = ({
	className,
	...props
}: React.ComponentProps<typeof PaginationLink>) => (
	<PaginationLink
		aria-label="Go to next page"
		size="default"
		className={cn("gap-1 pr-2.5", className)}
		{...props}
	>
		<span>Next</span>
		<ChevronRightIcon className="h-4 w-4" />
	</PaginationLink>
);
PaginationNext.displayName = "PaginationNext";

const PaginationEllipsis = ({
	className,
	...props
}: React.ComponentProps<"span">) => (
	<span
		aria-hidden
		className={cn("flex h-9 w-9 items-center justify-center", className)}
		{...props}
	>
		<DotsHorizontalIcon className="h-4 w-4" />
		<span className="sr-only">More pages</span>
	</span>
);
PaginationEllipsis.displayName = "PaginationEllipsis";

export {
	Pagination,
	PaginationContent,
	PaginationLink,
	PaginationItem,
	PaginationPrevious,
	PaginationNext,
	PaginationEllipsis,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/password-input.tsx
```
"use client";

import { EyeIcon, EyeOffIcon } from "lucide-react";
import * as React from "react";

import { Button } from "@/components/ui/button";
import { Input, type InputProps } from "@/components/ui/input";
import { cn } from "@/lib/utils";

const PasswordInput = ({
	ref,
	className,
	...props
}: InputProps & {
	ref: React.RefObject<HTMLInputElement>;
}) => {
	const [showPassword, setShowPassword] = React.useState(false);
	const disabled =
		props.value === "" || props.value === undefined || props.disabled;

	return (
		<div className="relative">
			<Input
				{...props}
				type={showPassword ? "text" : "password"}
				name="password_fake"
				className={cn("hide-password-toggle pr-10", className)}
				ref={ref}
			/>
			<Button
				type="button"
				variant="ghost"
				size="sm"
				className="absolute right-0 top-0 h-full px-3 py-2 hover:bg-transparent"
				onClick={() => setShowPassword((prev) => !prev)}
				disabled={disabled}
			>
				{showPassword && !disabled ? (
					<EyeIcon className="h-4 w-4" aria-hidden="true" />
				) : (
					<EyeOffIcon className="h-4 w-4" aria-hidden="true" />
				)}
				<span className="sr-only">
					{showPassword ? "Hide password" : "Show password"}
				</span>
			</Button>

			{/* hides browsers password toggles */}
			<style>{`
                .hide-password-toggle::-ms-reveal,
                .hide-password-toggle::-ms-clear {
                    visibility: hidden;
                    pointer-events: none;
                    display: none;
                }
            `}</style>
		</div>
	);
};
PasswordInput.displayName = "PasswordInput";

export { PasswordInput };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/popover.tsx
```
"use client";

import * as React from "react";
import * as PopoverPrimitive from "@radix-ui/react-popover";

import { cn } from "@/lib/utils";

const Popover = PopoverPrimitive.Root;

const PopoverTrigger = PopoverPrimitive.Trigger;

const PopoverAnchor = PopoverPrimitive.Anchor;

const PopoverContent = ({
	ref,
	className,
	align = "center",
	sideOffset = 4,
	...props
}: React.ComponentPropsWithoutRef<typeof PopoverPrimitive.Content> & {
	ref: React.RefObject<React.ElementRef<typeof PopoverPrimitive.Content>>;
}) => (
	<PopoverPrimitive.Portal>
		<PopoverPrimitive.Content
			ref={ref}
			align={align}
			sideOffset={sideOffset}
			className={cn(
				"z-50 w-72 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
				className,
			)}
			{...props}
		/>
	</PopoverPrimitive.Portal>
);
PopoverContent.displayName = PopoverPrimitive.Content.displayName;

export { Popover, PopoverTrigger, PopoverContent, PopoverAnchor };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/progress.tsx
```
"use client";

import * as React from "react";
import * as ProgressPrimitive from "@radix-ui/react-progress";

import { cn } from "@/lib/utils";

const Progress = ({
	ref,
	className,
	value,
	...props
}: React.ComponentPropsWithoutRef<typeof ProgressPrimitive.Root> & {
	ref: React.RefObject<React.ElementRef<typeof ProgressPrimitive.Root>>;
}) => (
	<ProgressPrimitive.Root
		ref={ref}
		className={cn(
			"relative h-2 w-full overflow-hidden rounded-full bg-primary/20",
			className,
		)}
		{...props}
	>
		<ProgressPrimitive.Indicator
			className="h-full w-full flex-1 bg-primary transition-all"
			style={{ transform: `translateX(-${100 - (value || 0)}%)` }}
		/>
	</ProgressPrimitive.Root>
);
Progress.displayName = ProgressPrimitive.Root.displayName;

export { Progress };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/radio-group.tsx
```
"use client";

import * as React from "react";
import { CheckIcon } from "@radix-ui/react-icons";
import * as RadioGroupPrimitive from "@radix-ui/react-radio-group";

import { cn } from "@/lib/utils";

const RadioGroup = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof RadioGroupPrimitive.Root> & {
	ref: React.RefObject<React.ElementRef<typeof RadioGroupPrimitive.Root>>;
}) => {
	return (
		<RadioGroupPrimitive.Root
			className={cn("grid gap-2", className)}
			{...props}
			ref={ref}
		/>
	);
};
RadioGroup.displayName = RadioGroupPrimitive.Root.displayName;

const RadioGroupItem = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof RadioGroupPrimitive.Item> & {
	ref: React.RefObject<React.ElementRef<typeof RadioGroupPrimitive.Item>>;
}) => {
	return (
		<RadioGroupPrimitive.Item
			ref={ref}
			className={cn(
				"aspect-square h-4 w-4 rounded-full border border-primary text-primary shadow focus:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
				className,
			)}
			{...props}
		>
			<RadioGroupPrimitive.Indicator className="flex items-center justify-center">
				<CheckIcon className="h-3.5 w-3.5 fill-primary" />
			</RadioGroupPrimitive.Indicator>
		</RadioGroupPrimitive.Item>
	);
};
RadioGroupItem.displayName = RadioGroupPrimitive.Item.displayName;

export { RadioGroup, RadioGroupItem };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/resizable.tsx
```
"use client";

import { DragHandleDots2Icon } from "@radix-ui/react-icons";
import * as ResizablePrimitive from "react-resizable-panels";

import { cn } from "@/lib/utils";

const ResizablePanelGroup = ({
	className,
	...props
}: React.ComponentProps<typeof ResizablePrimitive.PanelGroup>) => (
	<ResizablePrimitive.PanelGroup
		className={cn(
			"flex h-full w-full data-[panel-group-direction=vertical]:flex-col",
			className,
		)}
		{...props}
	/>
);

const ResizablePanel = ResizablePrimitive.Panel;

const ResizableHandle = ({
	withHandle,
	className,
	...props
}: React.ComponentProps<typeof ResizablePrimitive.PanelResizeHandle> & {
	withHandle?: boolean;
}) => (
	<ResizablePrimitive.PanelResizeHandle
		className={cn(
			"relative flex w-px items-center justify-center bg-border after:absolute after:inset-y-0 after:left-1/2 after:w-1 after:-translate-x-1/2 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring focus-visible:ring-offset-1 data-[panel-group-direction=vertical]:h-px data-[panel-group-direction=vertical]:w-full data-[panel-group-direction=vertical]:after:left-0 data-[panel-group-direction=vertical]:after:h-1 data-[panel-group-direction=vertical]:after:w-full data-[panel-group-direction=vertical]:after:-translate-y-1/2 data-[panel-group-direction=vertical]:after:translate-x-0 [&[data-panel-group-direction=vertical]>div]:rotate-90",
			className,
		)}
		{...props}
	>
		{withHandle && (
			<div className="z-10 flex h-4 w-3 items-center justify-center rounded-sm border bg-border">
				<DragHandleDots2Icon className="h-2.5 w-2.5" />
			</div>
		)}
	</ResizablePrimitive.PanelResizeHandle>
);

export { ResizablePanelGroup, ResizablePanel, ResizableHandle };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/scroll-area.tsx
```
"use client";

import * as React from "react";
import * as ScrollAreaPrimitive from "@radix-ui/react-scroll-area";

import { cn } from "@/lib/utils";

const ScrollArea = ({
	ref,
	className,
	children,
	...props
}: React.ComponentPropsWithoutRef<typeof ScrollAreaPrimitive.Root> & {
	ref: React.RefObject<React.ElementRef<typeof ScrollAreaPrimitive.Root>>;
}) => (
	<ScrollAreaPrimitive.Root
		ref={ref}
		className={cn("relative overflow-hidden", className)}
		{...props}
	>
		<ScrollAreaPrimitive.Viewport className="h-full w-full rounded-[inherit]">
			{children}
		</ScrollAreaPrimitive.Viewport>
		<ScrollBar />
		<ScrollAreaPrimitive.Corner />
	</ScrollAreaPrimitive.Root>
);
ScrollArea.displayName = ScrollAreaPrimitive.Root.displayName;

const ScrollBar = ({
	ref,
	className,
	orientation = "vertical",
	...props
}: React.ComponentPropsWithoutRef<
	typeof ScrollAreaPrimitive.ScrollAreaScrollbar
> & {
	ref: React.RefObject<
		React.ElementRef<typeof ScrollAreaPrimitive.ScrollAreaScrollbar>
	>;
}) => (
	<ScrollAreaPrimitive.ScrollAreaScrollbar
		ref={ref}
		orientation={orientation}
		className={cn(
			"flex touch-none select-none transition-colors",
			orientation === "vertical" &&
				"h-full w-2.5 border-l border-l-transparent p-[1px]",
			orientation === "horizontal" &&
				"h-2.5 flex-col border-t border-t-transparent p-[1px]",
			className,
		)}
		{...props}
	>
		<ScrollAreaPrimitive.ScrollAreaThumb className="relative flex-1 rounded-full bg-border" />
	</ScrollAreaPrimitive.ScrollAreaScrollbar>
);
ScrollBar.displayName = ScrollAreaPrimitive.ScrollAreaScrollbar.displayName;

export { ScrollArea, ScrollBar };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/select.tsx
```
"use client";

import * as React from "react";
import {
	CaretSortIcon,
	CheckIcon,
	ChevronDownIcon,
	ChevronUpIcon,
} from "@radix-ui/react-icons";
import * as SelectPrimitive from "@radix-ui/react-select";

import { cn } from "@/lib/utils";

const Select = SelectPrimitive.Root;

const SelectGroup = SelectPrimitive.Group;

const SelectValue = SelectPrimitive.Value;

const SelectTrigger = ({
	ref,
	className,
	children,
	...props
}: React.ComponentPropsWithoutRef<typeof SelectPrimitive.Trigger> & {
	ref: React.RefObject<React.ElementRef<typeof SelectPrimitive.Trigger>>;
}) => (
	<SelectPrimitive.Trigger
		ref={ref}
		className={cn(
			"flex h-9 w-full items-center justify-between whitespace-nowrap rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50 [&>span]:line-clamp-1",
			className,
		)}
		{...props}
	>
		{children}
		<SelectPrimitive.Icon asChild>
			<CaretSortIcon className="h-4 w-4 opacity-50" />
		</SelectPrimitive.Icon>
	</SelectPrimitive.Trigger>
);
SelectTrigger.displayName = SelectPrimitive.Trigger.displayName;

const SelectScrollUpButton = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof SelectPrimitive.ScrollUpButton> & {
	ref: React.RefObject<React.ElementRef<typeof SelectPrimitive.ScrollUpButton>>;
}) => (
	<SelectPrimitive.ScrollUpButton
		ref={ref}
		className={cn(
			"flex cursor-default items-center justify-center py-1",
			className,
		)}
		{...props}
	>
		<ChevronUpIcon />
	</SelectPrimitive.ScrollUpButton>
);
SelectScrollUpButton.displayName = SelectPrimitive.ScrollUpButton.displayName;

const SelectScrollDownButton = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof SelectPrimitive.ScrollDownButton> & {
	ref: React.RefObject<
		React.ElementRef<typeof SelectPrimitive.ScrollDownButton>
	>;
}) => (
	<SelectPrimitive.ScrollDownButton
		ref={ref}
		className={cn(
			"flex cursor-default items-center justify-center py-1",
			className,
		)}
		{...props}
	>
		<ChevronDownIcon />
	</SelectPrimitive.ScrollDownButton>
);
SelectScrollDownButton.displayName =
	SelectPrimitive.ScrollDownButton.displayName;

const SelectContent = ({
	ref,
	className,
	children,
	position = "popper",
	...props
}: React.ComponentPropsWithoutRef<typeof SelectPrimitive.Content> & {
	ref: React.RefObject<React.ElementRef<typeof SelectPrimitive.Content>>;
}) => (
	<SelectPrimitive.Portal>
		<SelectPrimitive.Content
			ref={ref}
			className={cn(
				"relative z-50 max-h-96 min-w-[8rem] overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
				position === "popper" &&
					"data-[side=bottom]:translate-y-1 data-[side=left]:-translate-x-1 data-[side=right]:translate-x-1 data-[side=top]:-translate-y-1",
				className,
			)}
			position={position}
			{...props}
		>
			<SelectScrollUpButton />
			<SelectPrimitive.Viewport
				className={cn(
					"p-1",
					position === "popper" &&
						"h-[var(--radix-select-trigger-height)] w-full min-w-[var(--radix-select-trigger-width)]",
				)}
			>
				{children}
			</SelectPrimitive.Viewport>
			<SelectScrollDownButton />
		</SelectPrimitive.Content>
	</SelectPrimitive.Portal>
);
SelectContent.displayName = SelectPrimitive.Content.displayName;

const SelectLabel = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof SelectPrimitive.Label> & {
	ref: React.RefObject<React.ElementRef<typeof SelectPrimitive.Label>>;
}) => (
	<SelectPrimitive.Label
		ref={ref}
		className={cn("px-2 py-1.5 text-sm font-semibold", className)}
		{...props}
	/>
);
SelectLabel.displayName = SelectPrimitive.Label.displayName;

const SelectItem = ({
	ref,
	className,
	children,
	...props
}: React.ComponentPropsWithoutRef<typeof SelectPrimitive.Item> & {
	ref: React.RefObject<React.ElementRef<typeof SelectPrimitive.Item>>;
}) => (
	<SelectPrimitive.Item
		ref={ref}
		className={cn(
			"relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-2 pr-8 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
			className,
		)}
		{...props}
	>
		<span className="absolute right-2 flex h-3.5 w-3.5 items-center justify-center">
			<SelectPrimitive.ItemIndicator>
				<CheckIcon className="h-4 w-4" />
			</SelectPrimitive.ItemIndicator>
		</span>
		<SelectPrimitive.ItemText>{children}</SelectPrimitive.ItemText>
	</SelectPrimitive.Item>
);
SelectItem.displayName = SelectPrimitive.Item.displayName;

const SelectSeparator = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof SelectPrimitive.Separator> & {
	ref: React.RefObject<React.ElementRef<typeof SelectPrimitive.Separator>>;
}) => (
	<SelectPrimitive.Separator
		ref={ref}
		className={cn("-mx-1 my-1 h-px bg-muted", className)}
		{...props}
	/>
);
SelectSeparator.displayName = SelectPrimitive.Separator.displayName;

export {
	Select,
	SelectGroup,
	SelectValue,
	SelectTrigger,
	SelectContent,
	SelectLabel,
	SelectItem,
	SelectSeparator,
	SelectScrollUpButton,
	SelectScrollDownButton,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/separator.tsx
```
"use client";

import * as React from "react";
import * as SeparatorPrimitive from "@radix-ui/react-separator";

import { cn } from "@/lib/utils";

const Separator = ({
	ref,
	className,
	orientation = "horizontal",
	decorative = true,
	...props
}: React.ComponentPropsWithoutRef<typeof SeparatorPrimitive.Root> & {
	ref: React.RefObject<React.ElementRef<typeof SeparatorPrimitive.Root>>;
}) => (
	<SeparatorPrimitive.Root
		ref={ref}
		decorative={decorative}
		orientation={orientation}
		className={cn(
			"shrink-0 bg-border",
			orientation === "horizontal" ? "h-[1px] w-full" : "h-full w-[1px]",
			className,
		)}
		{...props}
	/>
);
Separator.displayName = SeparatorPrimitive.Root.displayName;

export { Separator };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/sheet.tsx
```
"use client";

import * as React from "react";
import * as SheetPrimitive from "@radix-ui/react-dialog";
import { Cross2Icon } from "@radix-ui/react-icons";
import { cva, type VariantProps } from "class-variance-authority";

import { cn } from "@/lib/utils";

const Sheet = SheetPrimitive.Root;

const SheetTrigger = SheetPrimitive.Trigger;

const SheetClose = SheetPrimitive.Close;

const SheetPortal = SheetPrimitive.Portal;

const SheetOverlay = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof SheetPrimitive.Overlay> & {
	ref: React.RefObject<React.ElementRef<typeof SheetPrimitive.Overlay>>;
}) => (
	<SheetPrimitive.Overlay
		className={cn(
			"fixed inset-0 z-50 bg-black/80  data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
			className,
		)}
		{...props}
		ref={ref}
	/>
);
SheetOverlay.displayName = SheetPrimitive.Overlay.displayName;

const sheetVariants = cva(
	"fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out data-[state=closed]:duration-300 data-[state=open]:duration-500 data-[state=open]:animate-in data-[state=closed]:animate-out",
	{
		variants: {
			side: {
				top: "inset-x-0 top-0 border-b data-[state=closed]:slide-out-to-top data-[state=open]:slide-in-from-top",
				bottom:
					"inset-x-0 bottom-0 border-t data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom",
				left: "inset-y-0 left-0 h-full w-3/4 border-r data-[state=closed]:slide-out-to-left data-[state=open]:slide-in-from-left sm:max-w-sm",
				right:
					"inset-y-0 right-0 h-full w-3/4 border-l data-[state=closed]:slide-out-to-right data-[state=open]:slide-in-from-right sm:max-w-sm",
			},
		},
		defaultVariants: {
			side: "right",
		},
	},
);

interface SheetContentProps
	extends React.ComponentPropsWithoutRef<typeof SheetPrimitive.Content>,
		VariantProps<typeof sheetVariants> {}

const SheetContent = ({
	ref,
	side = "right",
	className,
	children,
	...props
}: SheetContentProps & {
	ref: React.RefObject<React.ElementRef<typeof SheetPrimitive.Content>>;
}) => (
	<SheetPortal>
		<SheetOverlay />
		<SheetPrimitive.Content
			ref={ref}
			className={cn(sheetVariants({ side }), className)}
			{...props}
		>
			<SheetPrimitive.Close className="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-secondary">
				<Cross2Icon className="h-4 w-4" />
				<span className="sr-only">Close</span>
			</SheetPrimitive.Close>
			{children}
		</SheetPrimitive.Content>
	</SheetPortal>
);
SheetContent.displayName = SheetPrimitive.Content.displayName;

const SheetHeader = ({
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement>) => (
	<div
		className={cn(
			"flex flex-col space-y-2 text-center sm:text-left",
			className,
		)}
		{...props}
	/>
);
SheetHeader.displayName = "SheetHeader";

const SheetFooter = ({
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement>) => (
	<div
		className={cn(
			"flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",
			className,
		)}
		{...props}
	/>
);
SheetFooter.displayName = "SheetFooter";

const SheetTitle = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof SheetPrimitive.Title> & {
	ref: React.RefObject<React.ElementRef<typeof SheetPrimitive.Title>>;
}) => (
	<SheetPrimitive.Title
		ref={ref}
		className={cn("text-lg font-semibold text-foreground", className)}
		{...props}
	/>
);
SheetTitle.displayName = SheetPrimitive.Title.displayName;

const SheetDescription = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof SheetPrimitive.Description> & {
	ref: React.RefObject<React.ElementRef<typeof SheetPrimitive.Description>>;
}) => (
	<SheetPrimitive.Description
		ref={ref}
		className={cn("text-sm text-muted-foreground", className)}
		{...props}
	/>
);
SheetDescription.displayName = SheetPrimitive.Description.displayName;

export {
	Sheet,
	SheetPortal,
	SheetOverlay,
	SheetTrigger,
	SheetClose,
	SheetContent,
	SheetHeader,
	SheetFooter,
	SheetTitle,
	SheetDescription,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/skeleton.tsx
```
import { cn } from "@/lib/utils";

function Skeleton({
	className,
	...props
}: React.HTMLAttributes<HTMLDivElement>) {
	return (
		<div
			className={cn("animate-pulse rounded-md bg-primary/10", className)}
			{...props}
		/>
	);
}

export { Skeleton };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/slider.tsx
```
"use client";

import * as React from "react";
import * as SliderPrimitive from "@radix-ui/react-slider";

import { cn } from "@/lib/utils";

const Slider = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof SliderPrimitive.Root> & {
	ref: React.RefObject<React.ElementRef<typeof SliderPrimitive.Root>>;
}) => (
	<SliderPrimitive.Root
		ref={ref}
		className={cn(
			"relative flex w-full touch-none select-none items-center",
			className,
		)}
		{...props}
	>
		<SliderPrimitive.Track className="relative h-1.5 w-full grow overflow-hidden rounded-full bg-primary/20">
			<SliderPrimitive.Range className="absolute h-full bg-primary" />
		</SliderPrimitive.Track>
		<SliderPrimitive.Thumb className="block h-4 w-4 rounded-full border border-primary/50 bg-background shadow transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50" />
	</SliderPrimitive.Root>
);
Slider.displayName = SliderPrimitive.Root.displayName;

export { Slider };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/sonner.tsx
```
"use client";

import { useTheme } from "next-themes";
import { Toaster as Sonner } from "sonner";

type ToasterProps = React.ComponentProps<typeof Sonner>;

const Toaster = ({ ...props }: ToasterProps) => {
	const { theme = "system" } = useTheme();

	return (
		<Sonner
			theme={theme as ToasterProps["theme"]}
			className="toaster group"
			toastOptions={{
				classNames: {
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

export { Toaster };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/switch.tsx
```
"use client";

import * as React from "react";
import * as SwitchPrimitives from "@radix-ui/react-switch";

import { cn } from "@/lib/utils";

const Switch = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof SwitchPrimitives.Root> & {
	ref: React.RefObject<React.ElementRef<typeof SwitchPrimitives.Root>>;
}) => (
	<SwitchPrimitives.Root
		className={cn(
			"peer inline-flex h-5 w-9 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=unchecked]:bg-input",
			className,
		)}
		{...props}
		ref={ref}
	>
		<SwitchPrimitives.Thumb
			className={cn(
				"pointer-events-none block h-4 w-4 rounded-full bg-background shadow-lg ring-0 transition-transform data-[state=checked]:translate-x-4 data-[state=unchecked]:translate-x-0",
			)}
		/>
	</SwitchPrimitives.Root>
);
Switch.displayName = SwitchPrimitives.Root.displayName;

export { Switch };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/table.tsx
```
import * as React from "react";

import { cn } from "@/lib/utils";

const Table = ({
	ref,
	className,
	...props
}: React.HTMLAttributes<HTMLTableElement> & {
	ref: React.RefObject<HTMLTableElement>;
}) => (
	<div className="relative w-full overflow-auto">
		<table
			ref={ref}
			className={cn("w-full caption-bottom text-sm", className)}
			{...props}
		/>
	</div>
);
Table.displayName = "Table";

const TableHeader = ({
	ref,
	className,
	...props
}: React.HTMLAttributes<HTMLTableSectionElement> & {
	ref: React.RefObject<HTMLTableSectionElement>;
}) => (
	<thead ref={ref} className={cn("[&_tr]:border-b", className)} {...props} />
);
TableHeader.displayName = "TableHeader";

const TableBody = ({
	ref,
	className,
	...props
}: React.HTMLAttributes<HTMLTableSectionElement> & {
	ref: React.RefObject<HTMLTableSectionElement>;
}) => (
	<tbody
		ref={ref}
		className={cn("[&_tr:last-child]:border-0", className)}
		{...props}
	/>
);
TableBody.displayName = "TableBody";

const TableFooter = ({
	ref,
	className,
	...props
}: React.HTMLAttributes<HTMLTableSectionElement> & {
	ref: React.RefObject<HTMLTableSectionElement>;
}) => (
	<tfoot
		ref={ref}
		className={cn(
			"border-t bg-muted/50 font-medium [&>tr]:last:border-b-0",
			className,
		)}
		{...props}
	/>
);
TableFooter.displayName = "TableFooter";

const TableRow = ({
	ref,
	className,
	...props
}: React.HTMLAttributes<HTMLTableRowElement> & {
	ref: React.RefObject<HTMLTableRowElement>;
}) => (
	<tr
		ref={ref}
		className={cn(
			"border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted",
			className,
		)}
		{...props}
	/>
);
TableRow.displayName = "TableRow";

const TableHead = ({
	ref,
	className,
	...props
}: React.ThHTMLAttributes<HTMLTableCellElement> & {
	ref: React.RefObject<HTMLTableCellElement>;
}) => (
	<th
		ref={ref}
		className={cn(
			"h-10 px-2 text-left align-middle font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
			className,
		)}
		{...props}
	/>
);
TableHead.displayName = "TableHead";

const TableCell = ({
	ref,
	className,
	...props
}: React.TdHTMLAttributes<HTMLTableCellElement> & {
	ref: React.RefObject<HTMLTableCellElement>;
}) => (
	<td
		ref={ref}
		className={cn(
			"p-2 align-middle [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
			className,
		)}
		{...props}
	/>
);
TableCell.displayName = "TableCell";

const TableCaption = ({
	ref,
	className,
	...props
}: React.HTMLAttributes<HTMLTableCaptionElement> & {
	ref: React.RefObject<HTMLTableCaptionElement>;
}) => (
	<caption
		ref={ref}
		className={cn("mt-4 text-sm text-muted-foreground", className)}
		{...props}
	/>
);
TableCaption.displayName = "TableCaption";

export {
	Table,
	TableHeader,
	TableBody,
	TableFooter,
	TableHead,
	TableRow,
	TableCell,
	TableCaption,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/tabs.tsx
```
"use client";

import * as React from "react";
import * as TabsPrimitive from "@radix-ui/react-tabs";

import { cn } from "@/lib/utils";

const Tabs = TabsPrimitive.Root;

const TabsList = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof TabsPrimitive.List> & {
	ref: React.RefObject<React.ElementRef<typeof TabsPrimitive.List>>;
}) => (
	<TabsPrimitive.List
		ref={ref}
		className={cn(
			"inline-flex h-10 items-center justify-center rounded-md bg-muted p-1 text-muted-foreground",
			className,
		)}
		{...props}
	/>
);
TabsList.displayName = TabsPrimitive.List.displayName;

const TabsTrigger = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof TabsPrimitive.Trigger> & {
	ref: React.RefObject<React.ElementRef<typeof TabsPrimitive.Trigger>>;
}) => (
	<TabsPrimitive.Trigger
		ref={ref}
		className={cn(
			"inline-flex items-center justify-center whitespace-nowrap rounded-sm px-3 py-1.5 text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow-sm",
			className,
		)}
		{...props}
	/>
);
TabsTrigger.displayName = TabsPrimitive.Trigger.displayName;

const TabsContent = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof TabsPrimitive.Content> & {
	ref: React.RefObject<React.ElementRef<typeof TabsPrimitive.Content>>;
}) => (
	<TabsPrimitive.Content
		ref={ref}
		className={cn(
			"mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
			className,
		)}
		{...props}
	/>
);
TabsContent.displayName = TabsPrimitive.Content.displayName;

export { Tabs, TabsList, TabsTrigger, TabsContent };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/tabs2.tsx
```
"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { cn } from "@/lib/utils";

type Tab = {
	title: string;
	value: string;
	content?: string | React.ReactNode | any;
};

export const Tabs = ({
	tabs: propTabs,
	containerClassName,
	activeTabClassName,
	tabClassName,
	contentClassName,
}: {
	tabs: Tab[];
	containerClassName?: string;
	activeTabClassName?: string;
	tabClassName?: string;
	contentClassName?: string;
}) => {
	const [active, setActive] = useState<Tab>(propTabs[0]);
	const [tabs, setTabs] = useState<Tab[]>(propTabs);

	const moveSelectedTabToTop = (idx: number) => {
		const newTabs = [...propTabs];
		const selectedTab = newTabs.splice(idx, 1);
		newTabs.unshift(selectedTab[0]);
		setTabs(newTabs);
		setActive(newTabs[0]);
	};

	const [hovering, setHovering] = useState(false);

	return (
		<>
			<div
				className={cn(
					"flex flex-row items-center justify-start mt-0 [perspective:1000px] relative overflow-auto sm:overflow-visible no-visible-scrollbar border-x w-full border-t max-w-max bg-opacity-0",
					containerClassName,
				)}
			>
				{propTabs.map((tab, idx) => (
					<button
						key={tab.title}
						onClick={() => {
							moveSelectedTabToTop(idx);
						}}
						onMouseEnter={() => setHovering(true)}
						onMouseLeave={() => setHovering(false)}
						className={cn(
							"relative px-4 py-2 rounded-full opacity-80 hover:opacity-100",
							tabClassName,
						)}
						style={{
							transformStyle: "preserve-3d",
						}}
					>
						{active.value === tab.value && (
							<motion.div
								transition={{
									duration: 0.2,
									delay: 0.1,

									type: "keyframes",
								}}
								animate={{
									x: tabs.indexOf(tab) === 0 ? [0, 0, 0] : [0, 0, 0],
								}}
								className={cn(
									"absolute inset-0 bg-gray-200 dark:bg-zinc-900/90 opacity-100",
									activeTabClassName,
								)}
							/>
						)}

						<span
							className={cn(
								"relative block text-black dark:text-white",
								active.value === tab.value
									? "text-opacity-100 font-medium"
									: "opacity-40 ",
							)}
						>
							{tab.title}
						</span>
					</button>
				))}
			</div>
			<FadeInDiv
				tabs={tabs}
				active={active}
				key={active.value}
				hovering={hovering}
				className={cn("", contentClassName)}
			/>
		</>
	);
};

export const FadeInDiv = ({
	className,
	tabs,
}: {
	className?: string;
	key?: string;
	tabs: Tab[];
	active: Tab;
	hovering?: boolean;
}) => {
	const isActive = (tab: Tab) => {
		return tab.value === tabs[0].value;
	};
	return (
		<div className="relative w-full h-full">
			{tabs.map((tab, idx) => (
				<motion.div
					key={tab.value}
					style={{
						scale: 1 - idx * 0.1,
						zIndex: -idx,
						opacity: idx < 3 ? 1 - idx * 0.1 : 0,
					}}
					animate={{
						transition: {
							duration: 0.2,
							delay: 0.1,
							type: "keyframes",
						},
					}}
					className={cn(
						"w-50 h-full",
						isActive(tab) ? "" : "hidden",
						className,
					)}
				>
					{tab.content}
				</motion.div>
			))}
		</div>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/textarea.tsx
```
import * as React from "react";

import { cn } from "@/lib/utils";

export interface TextareaProps
	extends React.TextareaHTMLAttributes<HTMLTextAreaElement> {}

const Textarea = ({
	ref,
	className,
	...props
}: TextareaProps & {
	ref: React.RefObject<HTMLTextAreaElement>;
}) => {
	return (
		<textarea
			className={cn(
				"flex min-h-[60px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
				className,
			)}
			ref={ref}
			{...props}
		/>
	);
};
Textarea.displayName = "Textarea";

export { Textarea };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/toast.tsx
```
"use client";

import * as React from "react";
import { Cross2Icon } from "@radix-ui/react-icons";
import * as ToastPrimitives from "@radix-ui/react-toast";
import { cva } from "class-variance-authority";

import { cn } from "@/lib/utils";

const ToastProvider = ToastPrimitives.Provider;

const ToastViewport = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof ToastPrimitives.Viewport> & {
	ref: React.RefObject<React.ElementRef<typeof ToastPrimitives.Viewport>>;
}) => (
	<ToastPrimitives.Viewport
		ref={ref}
		className={cn(
			"fixed top-0 z-[100] flex max-h-screen w-full flex-col-reverse p-4 sm:bottom-0 sm:right-0 sm:top-auto sm:flex-col md:max-w-[420px]",
			className,
		)}
		{...props}
	/>
);
ToastViewport.displayName = ToastPrimitives.Viewport.displayName;

const toastVariants = cva(
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

const Toast = ({ ref, className, variant, ...props }) => {
	return (
		<ToastPrimitives.Root
			ref={ref}
			className={cn(toastVariants({ variant }), className)}
			{...props}
		/>
	);
};
Toast.displayName = ToastPrimitives.Root.displayName;

const ToastAction = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof ToastPrimitives.Action> & {
	ref: React.RefObject<React.ElementRef<typeof ToastPrimitives.Action>>;
}) => (
	<ToastPrimitives.Action
		ref={ref}
		className={cn(
			"inline-flex h-8 shrink-0 items-center justify-center rounded-md border bg-transparent px-3 text-sm font-medium transition-colors hover:bg-secondary focus:outline-none focus:ring-1 focus:ring-ring disabled:pointer-events-none disabled:opacity-50 group-[.destructive]:border-muted/40 group-[.destructive]:hover:border-destructive/30 group-[.destructive]:hover:bg-destructive group-[.destructive]:hover:text-destructive-foreground group-[.destructive]:focus:ring-destructive",
			className,
		)}
		{...props}
	/>
);
ToastAction.displayName = ToastPrimitives.Action.displayName;

const ToastClose = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof ToastPrimitives.Close> & {
	ref: React.RefObject<React.ElementRef<typeof ToastPrimitives.Close>>;
}) => (
	<ToastPrimitives.Close
		ref={ref}
		className={cn(
			"absolute right-1 top-1 rounded-md p-1 text-foreground/50 opacity-0 transition-opacity hover:text-foreground focus:opacity-100 focus:outline-none focus:ring-1 group-hover:opacity-100 group-[.destructive]:text-red-300 group-[.destructive]:hover:text-red-50 group-[.destructive]:focus:ring-red-400 group-[.destructive]:focus:ring-offset-red-600",
			className,
		)}
		toast-close=""
		{...props}
	>
		<Cross2Icon className="h-4 w-4" />
	</ToastPrimitives.Close>
);
ToastClose.displayName = ToastPrimitives.Close.displayName;

const ToastTitle = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof ToastPrimitives.Title> & {
	ref: React.RefObject<React.ElementRef<typeof ToastPrimitives.Title>>;
}) => (
	<ToastPrimitives.Title
		ref={ref}
		className={cn("text-sm font-semibold [&+div]:text-xs", className)}
		{...props}
	/>
);
ToastTitle.displayName = ToastPrimitives.Title.displayName;

const ToastDescription = ({
	ref,
	className,
	...props
}: React.ComponentPropsWithoutRef<typeof ToastPrimitives.Description> & {
	ref: React.RefObject<React.ElementRef<typeof ToastPrimitives.Description>>;
}) => (
	<ToastPrimitives.Description
		ref={ref}
		className={cn("text-sm opacity-90", className)}
		{...props}
	/>
);
ToastDescription.displayName = ToastPrimitives.Description.displayName;

type ToastProps = React.ComponentPropsWithoutRef<typeof Toast>;

type ToastActionElement = React.ReactElement<typeof ToastAction>;

export {
	type ToastProps,
	type ToastActionElement,
	ToastProvider,
	ToastViewport,
	Toast,
	ToastTitle,
	ToastDescription,
	ToastClose,
	ToastAction,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/toaster.tsx
```
"use client";

import { useToast } from "@/hooks/use-toast";
import {
	Toast,
	ToastClose,
	ToastDescription,
	ToastProvider,
	ToastTitle,
	ToastViewport,
} from "@/components/ui/toast";

export function Toaster() {
	const { toasts } = useToast();

	return (
		<ToastProvider>
			{toasts.map(function ({ id, title, description, action, ...props }) {
				return (
					<Toast key={id} {...props}>
						<div className="grid gap-1">
							{title && <ToastTitle>{title}</ToastTitle>}
							{description && (
								<ToastDescription>{description}</ToastDescription>
							)}
						</div>
						{action}
						<ToastClose />
					</Toast>
				);
			})}
			<ToastViewport />
		</ToastProvider>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/toggle-group.tsx
```
"use client";

import * as React from "react";
import * as ToggleGroupPrimitive from "@radix-ui/react-toggle-group";
import { type VariantProps } from "class-variance-authority";

import { cn } from "@/lib/utils";
import { toggleVariants } from "@/components/ui/toggle";

const ToggleGroupContext = React.createContext<
	VariantProps<typeof toggleVariants>
>({
	size: "default",
	variant: "default",
});

const ToggleGroup = ({ ref, className, variant, size, children, ...props }) => (
	<ToggleGroupPrimitive.Root
		ref={ref}
		className={cn("flex items-center justify-center gap-1", className)}
		{...props}
	>
		<ToggleGroupContext.Provider value={{ variant, size }}>
			{children}
		</ToggleGroupContext.Provider>
	</ToggleGroupPrimitive.Root>
);

ToggleGroup.displayName = ToggleGroupPrimitive.Root.displayName;

const ToggleGroupItem = ({
	ref,
	className,
	children,
	variant,
	size,
	...props
}) => {
	const context = React.useContext(ToggleGroupContext);

	return (
		<ToggleGroupPrimitive.Item
			ref={ref}
			className={cn(
				toggleVariants({
					variant: context.variant || variant,
					size: context.size || size,
				}),
				className,
			)}
			{...props}
		>
			{children}
		</ToggleGroupPrimitive.Item>
	);
};

ToggleGroupItem.displayName = ToggleGroupPrimitive.Item.displayName;

export { ToggleGroup, ToggleGroupItem };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/toggle.tsx
```
"use client";
import * as TogglePrimitive from "@radix-ui/react-toggle";
import { cva } from "class-variance-authority";

import { cn } from "@/lib/utils";

const toggleVariants = cva(
	"inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors hover:bg-muted hover:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 data-[state=on]:bg-accent data-[state=on]:text-accent-foreground",
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

const Toggle = ({ ref, className, variant, size, ...props }) => (
	<TogglePrimitive.Root
		ref={ref}
		className={cn(toggleVariants({ variant, size, className }))}
		{...props}
	/>
);

Toggle.displayName = TogglePrimitive.Root.displayName;

export { Toggle, toggleVariants };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/components/ui/tooltip.tsx
```
"use client";

import * as React from "react";
import * as TooltipPrimitive from "@radix-ui/react-tooltip";

import { cn } from "@/lib/utils";

const TooltipProvider = TooltipPrimitive.Provider;

const Tooltip = TooltipPrimitive.Root;

const TooltipTrigger = TooltipPrimitive.Trigger;

const TooltipContent = ({
	ref,
	className,
	sideOffset = 4,
	...props
}: React.ComponentPropsWithoutRef<typeof TooltipPrimitive.Content> & {
	ref: React.RefObject<React.ElementRef<typeof TooltipPrimitive.Content>>;
}) => (
	<TooltipPrimitive.Content
		ref={ref}
		sideOffset={sideOffset}
		className={cn(
			"z-50 overflow-hidden rounded-md bg-primary px-3 py-1.5 text-xs text-primary-foreground animate-in fade-in-0 zoom-in-95 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
			className,
		)}
		{...props}
	/>
);
TooltipContent.displayName = TooltipPrimitive.Content.displayName;

export { Tooltip, TooltipTrigger, TooltipContent, TooltipProvider };

```
