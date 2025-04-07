/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/content.tsx
```
import cssText from "data-text:~style.css";
import type { PlasmoCSConfig } from "plasmo";
import { useState } from "react";
import { PageControls } from "./popup";
import { Home } from "./components/Home";
import { Toaster } from "sonner";
import { SignIn } from "./components/SignIn";
import { SignUp } from "./components/SignUp";

export const config: PlasmoCSConfig = {
	matches: ["https://www.plasmo.com/*"],
};

export const getStyle = () => {
	const style = document.createElement("style");
	style.textContent = cssText;
	return style;
};

const PlasmoOverlay = () => {
	const [page, setPage] = useState<"home" | "sign-in" | "sign-up">("home");

	return (
		<div className="min-w-[400px] w-fit h-fit min-h-[500px] overflow-hidden dark bg-background text-foreground">
			<Toaster />
			{page === "home" && <Home setPage={setPage} />}
			{page === "sign-in" && <SignIn setPage={setPage} />}
			{page === "sign-up" && <SignUp setPage={setPage} />}
			<PageControls setPage={setPage} page={page} />
		</div>
	);
};

export default PlasmoOverlay;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/popup.tsx
```
import "@/style.css";

import { useState } from "react";
import { toast, Toaster } from "sonner";

import { Home } from "./components/Home";
import { SignIn } from "./components/SignIn";
import { SignUp } from "./components/SignUp";
import { Button } from "./components/ui/button";
import { Separator } from "./components/ui/separator";
import { authClient } from "./auth/auth-client";

function IndexPopup() {
	const [page, setPage] = useState<"home" | "sign-in" | "sign-up">("home");

	return (
		<div className="min-w-[400px] w-fit h-fit min-h-[500px] overflow-hidden dark bg-background text-foreground">
			<Toaster />
			{page === "home" && <Home setPage={setPage} />}
			{page === "sign-in" && <SignIn setPage={setPage} />}
			{page === "sign-up" && <SignUp setPage={setPage} />}
			<PageControls setPage={setPage} page={page} />
		</div>
	);
}

export default IndexPopup;

export function PageControls({
	setPage,
	page,
}: {
	setPage: (page: "home" | "sign-in" | "sign-up") => void;
	page: "home" | "sign-in" | "sign-up";
}) {
	return (
		<div className="flex flex-col w-full gap-5 px-10 mt-5 h-fit">
			<Separator />
			<div className="flex justify-center gap-4">
				{page === "home" && (
					<>
						<Button onClick={() => setPage("sign-in")}>Sign-in</Button>
						<Button onClick={() => setPage("sign-up")}>Sign-Up</Button>
						<Button
							onClick={() => {
								authClient.signOut().then(({ data, error }) => {
									if (error) {
										toast.error(error.message);
									} else {
										toast.success("You've been signed out");
									}
								});
							}}
						>
							Sign-Out
						</Button>
					</>
				)}
				{page === "sign-in" && (
					<>
						<Button onClick={() => setPage("sign-up")}>Sign-Up</Button>
						<Button onClick={() => setPage("home")}>Home</Button>
					</>
				)}
				{page === "sign-up" && (
					<>
						<Button onClick={() => setPage("sign-in")}>Sign-in</Button>
						<Button onClick={() => setPage("home")}>Home</Button>
					</>
				)}
			</div>

			<div className="flex justify-center bg-background">
				<a
					href="https://www.better-auth.com/docs/integrations/browser-extensions"
					target="_blank"
					className="underline"
				>
					Learn more about better-auth extensions
				</a>
			</div>
			<div className="h-5"></div>
		</div>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/style.css
```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
	:root {
		--background: 0 0% 100%;
		--foreground: 240 10% 3.9%;
		--card: 0 0% 100%;
		--card-foreground: 240 10% 3.9%;
		--popover: 0 0% 100%;
		--popover-foreground: 240 10% 3.9%;
		--primary: 240 5.9% 10%;
		--primary-foreground: 0 0% 98%;
		--secondary: 240 4.8% 95.9%;
		--secondary-foreground: 240 5.9% 10%;
		--muted: 240 4.8% 95.9%;
		--muted-foreground: 240 3.8% 46.1%;
		--accent: 240 4.8% 95.9%;
		--accent-foreground: 240 5.9% 10%;
		--destructive: 0 84.2% 60.2%;
		--destructive-foreground: 0 0% 98%;
		--border: 240 5.9% 90%;
		--input: 240 5.9% 90%;
		--ring: 240 5.9% 10%;
		--radius: 0.5rem;
		--chart-1: 12 76% 61%;
		--chart-2: 173 58% 39%;
		--chart-3: 197 37% 24%;
		--chart-4: 43 74% 66%;
		--chart-5: 27 87% 67%;
	}

	.dark {
		--background: 240 10% 3.9%;
		--foreground: 0 0% 98%;
		--card: 240 10% 3.9%;
		--card-foreground: 0 0% 98%;
		--popover: 240 10% 3.9%;
		--popover-foreground: 0 0% 98%;
		--primary: 0 0% 98%;
		--primary-foreground: 240 5.9% 10%;
		--secondary: 240 3.7% 15.9%;
		--secondary-foreground: 0 0% 98%;
		--muted: 240 3.7% 15.9%;
		--muted-foreground: 240 5% 64.9%;
		--accent: 240 3.7% 15.9%;
		--accent-foreground: 0 0% 98%;
		--destructive: 0 62.8% 30.6%;
		--destructive-foreground: 0 0% 98%;
		--border: 240 3.7% 15.9%;
		--input: 240 3.7% 15.9%;
		--ring: 240 4.9% 83.9%;
		--chart-1: 220 70% 50%;
		--chart-2: 160 60% 45%;
		--chart-3: 30 80% 55%;
		--chart-4: 280 65% 60%;
		--chart-5: 340 75% 55%;
	}
}

@layer base {
	* {
		@apply border-border;
	}
	body {
		@apply font-sans antialiased bg-background text-foreground;
	}
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/auth/auth-client.ts
```typescript
import { createAuthClient } from "better-auth/react";

export const authClient = createAuthClient({
	baseURL: "http://localhost:3000" /* base url of your Better Auth backend. */,
	plugins: [],
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/components/Home.tsx
```
import { authClient } from "@/auth/auth-client";

export const Home = ({
	setPage,
}: {
	setPage: (page: "home" | "sign-in" | "sign-up") => void;
}) => {
	const { data, error, isPending } = authClient.useSession();

	return (
		<>
			<h1 className="py-10 text-2xl text-center">Better Auth Extension Demo</h1>
			<h2 className="py-10 text-xl text-center text-secondary-foreground">
				{isPending
					? "Loading your session data..."
					: error
						? error.message
						: data
							? "You're Logged in 👍"
							: "You're Not logged in 😢"}
			</h2>
		</>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/components/SignIn.tsx
```
"use client";

import { authClient } from "@/auth/auth-client";
import { Button } from "@/components/ui/button";
import {
	Card,
	CardContent,
	CardDescription,
	CardHeader,
	CardTitle,
} from "@/components/ui/card";
import { Checkbox } from "@/components/ui/checkbox";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Loader2 } from "lucide-react";
import { useState } from "react";
import { toast } from "sonner";

const { signIn } = authClient;

export function SignIn({
	setPage,
}: {
	setPage: (page: "home" | "sign-in" | "sign-up") => void;
}) {
	const [email, setEmail] = useState("");
	const [password, setPassword] = useState("");
	const [loading, setLoading] = useState(false);
	const [rememberMe, setRememberMe] = useState(false);

	return (
		<Card className="max-w-md border-0">
			<CardHeader>
				<CardTitle className="text-lg md:text-xl">Sign In</CardTitle>
				<CardDescription className="text-xs md:text-sm">
					Enter your email below to login to your account
				</CardDescription>
			</CardHeader>
			<CardContent>
				<div className="grid gap-4">
					<div className="grid gap-2">
						<Label htmlFor="email">Email</Label>
						<Input
							id="email"
							type="email"
							placeholder="m@example.com"
							required
							onChange={(e) => {
								setEmail(e.target.value);
							}}
							value={email}
						/>
					</div>

					<div className="grid gap-2">
						<div className="flex items-center">
							<Label htmlFor="password">Password</Label>
							<a href="#" className="inline-block ml-auto text-sm underline">
								Forgot your password?
							</a>
						</div>

						<Input
							id="password"
							type="password"
							placeholder="password"
							autoComplete="password"
							value={password}
							onChange={(e) => setPassword(e.target.value)}
						/>
					</div>

					<div className="flex items-center gap-2">
						<Checkbox
							id="remember"
							onClick={() => {
								setRememberMe(!rememberMe);
							}}
						/>
						<Label htmlFor="remember">Remember me</Label>
					</div>

					<Button
						type="submit"
						className="w-full"
						disabled={loading}
						onClick={async () => {
							signIn.email({
								email,
								password,
								fetchOptions: {
									onResponse: () => {
										setLoading(false);
									},
									onRequest: () => {
										setLoading(true);
									},
									onError: (ctx) => {
										toast.error(ctx.error.message);
									},
									onSuccess: async () => {
										setPage("home");
									},
								},
							});
						}}
					>
						{loading ? <Loader2 size={16} className="animate-spin" /> : "Login"}
					</Button>
				</div>
			</CardContent>
		</Card>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/components/SignUp.tsx
```
"use client";

import { authClient } from "@/auth/auth-client";
import { Button } from "@/components/ui/button";
import {
	Card,
	CardContent,
	CardDescription,
	CardHeader,
	CardTitle,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Loader2 } from "lucide-react";
import { useState } from "react";
import { toast } from "sonner";

const { signUp } = authClient;

export function SignUp({
	setPage,
}: {
	setPage: (page: "home" | "sign-in" | "sign-up") => void;
}) {
	const [firstName, setFirstName] = useState("");
	const [lastName, setLastName] = useState("");
	const [email, setEmail] = useState("");
	const [password, setPassword] = useState("");
	const [passwordConfirmation, setPasswordConfirmation] = useState("");
	const [loading, setLoading] = useState(false);

	return (
		<Card className="z-50 max-w-md border-0 rounded-md rounded-t-none">
			<CardHeader>
				<CardTitle className="text-lg md:text-xl">Sign Up</CardTitle>
				<CardDescription className="text-xs md:text-sm">
					Enter your information to create an account
				</CardDescription>
			</CardHeader>
			<CardContent>
				<div className="grid gap-4">
					<div className="grid grid-cols-2 gap-4">
						<div className="grid gap-2">
							<Label htmlFor="first-name">First name</Label>
							<Input
								id="first-name"
								placeholder="Max"
								required
								onChange={(e) => {
									setFirstName(e.target.value);
								}}
								value={firstName}
							/>
						</div>
						<div className="grid gap-2">
							<Label htmlFor="last-name">Last name</Label>
							<Input
								id="last-name"
								placeholder="Robinson"
								required
								onChange={(e) => {
									setLastName(e.target.value);
								}}
								value={lastName}
							/>
						</div>
					</div>
					<div className="grid gap-2">
						<Label htmlFor="email">Email</Label>
						<Input
							id="email"
							type="email"
							placeholder="m@example.com"
							required
							onChange={(e) => {
								setEmail(e.target.value);
							}}
							value={email}
						/>
					</div>
					<div className="grid gap-2">
						<Label htmlFor="password">Password</Label>
						<Input
							id="password"
							type="password"
							value={password}
							onChange={(e) => setPassword(e.target.value)}
							autoComplete="new-password"
							placeholder="Password"
						/>
					</div>
					<div className="grid gap-2">
						<Label htmlFor="password">Confirm Password</Label>
						<Input
							id="password_confirmation"
							type="password"
							value={passwordConfirmation}
							onChange={(e) => setPasswordConfirmation(e.target.value)}
							autoComplete="new-password"
							placeholder="Confirm Password"
						/>
					</div>

					<Button
						type="submit"
						className="w-full"
						disabled={loading}
						onClick={async () => {
							await signUp.email({
								email,
								password,
								name: `${firstName} ${lastName}`,
								fetchOptions: {
									onResponse: () => {
										setLoading(false);
									},
									onRequest: () => {
										setLoading(true);
									},
									onError: (ctx) => {
										toast.error(ctx.error.message);
									},
									onSuccess: async () => {
										setPage("home");
									},
								},
							});
						}}
					>
						{loading ? (
							<Loader2 size={16} className="animate-spin" />
						) : (
							"Create an account"
						)}
					</Button>
				</div>
			</CardContent>
		</Card>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/components/ui/button.tsx
```
import * as React from "react";
import { Slot } from "@radix-ui/react-slot";
import { cva, type VariantProps } from "class-variance-authority";

import { cn } from "@/lib/utils";

const buttonVariants = cva(
	"inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
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

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
	({ className, variant, size, asChild = false, ...props }, ref) => {
		const Comp = asChild ? Slot : "button";
		return (
			<Comp
				className={cn(buttonVariants({ variant, size, className }))}
				ref={ref}
				{...props}
			/>
		);
	},
);
Button.displayName = "Button";

export { Button, buttonVariants };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/components/ui/card.tsx
```
import * as React from "react";

import { cn } from "@/lib/utils";

const Card = React.forwardRef<
	HTMLDivElement,
	React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
	<div
		ref={ref}
		className={cn(
			"rounded-xl border bg-card text-card-foreground shadow",
			className,
		)}
		{...props}
	/>
));
Card.displayName = "Card";

const CardHeader = React.forwardRef<
	HTMLDivElement,
	React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
	<div
		ref={ref}
		className={cn("flex flex-col space-y-1.5 p-6", className)}
		{...props}
	/>
));
CardHeader.displayName = "CardHeader";

const CardTitle = React.forwardRef<
	HTMLDivElement,
	React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
	<div
		ref={ref}
		className={cn("font-semibold leading-none tracking-tight", className)}
		{...props}
	/>
));
CardTitle.displayName = "CardTitle";

const CardDescription = React.forwardRef<
	HTMLDivElement,
	React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
	<div
		ref={ref}
		className={cn("text-sm text-muted-foreground", className)}
		{...props}
	/>
));
CardDescription.displayName = "CardDescription";

const CardContent = React.forwardRef<
	HTMLDivElement,
	React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
	<div ref={ref} className={cn("p-6 pt-0", className)} {...props} />
));
CardContent.displayName = "CardContent";

const CardFooter = React.forwardRef<
	HTMLDivElement,
	React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
	<div
		ref={ref}
		className={cn("flex items-center p-6 pt-0", className)}
		{...props}
	/>
));
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
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/components/ui/checkbox.tsx
```
"use client";

import * as React from "react";
import * as CheckboxPrimitive from "@radix-ui/react-checkbox";
import { Check } from "lucide-react";

import { cn } from "@/lib/utils";

const Checkbox = React.forwardRef<
	React.ElementRef<typeof CheckboxPrimitive.Root>,
	React.ComponentPropsWithoutRef<typeof CheckboxPrimitive.Root>
>(({ className, ...props }, ref) => (
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
			<Check className="h-4 w-4" />
		</CheckboxPrimitive.Indicator>
	</CheckboxPrimitive.Root>
));
Checkbox.displayName = CheckboxPrimitive.Root.displayName;

export { Checkbox };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/components/ui/input.tsx
```
import * as React from "react";

import { cn } from "@/lib/utils";

const Input = React.forwardRef<HTMLInputElement, React.ComponentProps<"input">>(
	({ className, type, ...props }, ref) => {
		return (
			<input
				type={type}
				className={cn(
					"flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-base shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
					className,
				)}
				ref={ref}
				{...props}
			/>
		);
	},
);
Input.displayName = "Input";

export { Input };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/components/ui/label.tsx
```
import * as React from "react";
import * as LabelPrimitive from "@radix-ui/react-label";
import { cva, type VariantProps } from "class-variance-authority";

import { cn } from "@/lib/utils";

const labelVariants = cva(
	"text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70",
);

const Label = React.forwardRef<
	React.ElementRef<typeof LabelPrimitive.Root>,
	React.ComponentPropsWithoutRef<typeof LabelPrimitive.Root> &
		VariantProps<typeof labelVariants>
>(({ className, ...props }, ref) => (
	<LabelPrimitive.Root
		ref={ref}
		className={cn(labelVariants(), className)}
		{...props}
	/>
));
Label.displayName = LabelPrimitive.Root.displayName;

export { Label };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/components/ui/separator.tsx
```
import * as React from "react";
import * as SeparatorPrimitive from "@radix-ui/react-separator";

import { cn } from "@/lib/utils";

const Separator = React.forwardRef<
	React.ElementRef<typeof SeparatorPrimitive.Root>,
	React.ComponentPropsWithoutRef<typeof SeparatorPrimitive.Root>
>(
	(
		{ className, orientation = "horizontal", decorative = true, ...props },
		ref,
	) => (
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
	),
);
Separator.displayName = SeparatorPrimitive.Root.displayName;

export { Separator };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/browser-extension-example/src/lib/utils.ts
```typescript
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
	return twMerge(clsx(inputs));
}

```
