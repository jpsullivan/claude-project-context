/Users/josh/Documents/GitHub/better-auth/better-auth/examples/tanstack-example/app/routes/__root.tsx
```
import { Link, createRootRoute, useRouter } from "@tanstack/react-router";
import { Outlet, ScrollRestoration } from "@tanstack/react-router";
import { Body, Head, Html, Meta, Scripts } from "@tanstack/start";
import type * as React from "react";
import { useEffect, useState } from "react";
import { signOut, useSession } from "~/lib/auth-client";
import globalStylesheet from "~/lib/style/global.css?url";
import "~/lib/style/global.css";
import { DoorOpen, Moon, Sun } from "lucide-react";
import { toast } from "sonner";
import { Button } from "~/components/ui/button";
import {
	NavigationMenu,
	NavigationMenuItem,
	NavigationMenuLink,
	NavigationMenuList,
	navigationMenuTriggerStyle,
} from "~/components/ui/navigation-menu";
import { Toaster } from "~/components/ui/sonner";

export const Route = createRootRoute({
	meta: () => [
		{
			charSet: "utf-8",
		},
		{
			name: "viewport",
			content: "width=device-width, initial-scale=1",
		},
		{
			title: "Better Auth - TanStack Start Example",
		},
	],
	links: () => [
		{
			rel: "stylesheet",
			href: globalStylesheet,
		},
	],
	component: RootComponent,
});

function RootComponent() {
	const [theme, setTheme] = useState<"light" | "dark">("light");
	const { data, isPending, error } = useSession();
	const { navigate } = useRouter();
	console.log();

	useEffect(() => {
		if (!data?.user) {
			if (!location.pathname.includes("auth/")) {
				navigate({ to: "/auth/signin" });
			}
		} else {
			navigate({ to: "/" });
		}
		setTheme(
			window.matchMedia("(prefers-color-scheme: dark)").matches
				? "dark"
				: "light",
		);
	}, [data, navigate]);

	useEffect(() => {
		const root = window.document.documentElement;

		root.classList.remove("light", "dark");

		root.classList.add(theme);
	}, [theme]);

	return (
		<RootDocument>
			<>
				<nav className="grid grid-cols-3 items-center w-full p-4">
					<div className="flex items-center justify-center gap-2">
						<svg
							width="60"
							height="45"
							viewBox="0 0 60 45"
							fill="none"
							className="w-5 h-5"
							xmlns="http://www.w3.org/2000/svg"
						>
							<title>Better Auth</title>
							<path
								fillRule="evenodd"
								clipRule="evenodd"
								d="M0 0H15V15H30V30H15V45H0V30V15V0ZM45 30V15H30V0H45H60V15V30V45H45H30V30H45Z"
								className="fill-black dark:fill-white"
							/>
						</svg>
						<p>BETTER-AUTH</p>
						<p>x</p>
						<svg
							className="w-5 h-5"
							xmlns="http://www.w3.org/2000/svg"
							width="45"
							height="45"
							viewBox="0 0 100 100"
							fill="none"
						>
							<title>TanStack Start</title>
							<mask
								id="a"
								style={{ maskType: "alpha" }}
								maskUnits="userSpaceOnUse"
								x="0"
								y="0"
								width="100"
								height="100"
							>
								<circle cx="50" cy="50" r="50" className="fill-foreground" />
							</mask>
							<g mask="url(#a)">
								<circle
									cx="11"
									cy="119"
									r="52"
									className="fill-muted-foreground stroke-foreground"
									strokeWidth="4"
								/>
								<circle
									cx="10"
									cy="125"
									r="52"
									className="fill-muted-foreground stroke-foreground"
									strokeWidth="4"
								/>
								<circle
									cx="9"
									cy="131"
									r="52"
									className="fill-muted-foreground stroke-muted-foreground"
									strokeWidth="4"
								/>
								<circle
									cx="88"
									cy="119"
									r="52"
									className="fill-muted-foreground stroke-foreground"
									strokeWidth="4"
								/>
								<path
									className="fill-foreground"
									d="M89 35h2v5h-2zM83 34l2 1-1 4h-2zM77 31l2 1-3 4-2-1zM73 27l1 1-3 4-1-2zM70 23l1 1-4 3-1-2zM68 18v2l-4 1-1-2zM68 11l1 2-5 1-1-2zM69 6v2h-5V6z"
								/>
								<circle
									cx="89"
									cy="125"
									r="52"
									className="fill-muted-foreground stroke-foreground"
									strokeWidth="4"
								/>
								<circle
									cx="90"
									cy="131"
									r="52"
									className="fill-muted-foreground stroke-muted-foreground"
									strokeWidth="4"
								/>
								<ellipse
									cx="49.5"
									cy="119"
									rx="41.5"
									ry="51"
									className="fill-muted-foreground"
								/>
								<path
									d="M34 38v-9c1 1 2 4 5 6l7 30-8 2c-1-23-2-23-4-29Z"
									className="fill-foreground stroke-muted-foreground"
								/>
								<path
									fillRule="evenodd"
									clipRule="evenodd"
									d="M95 123c0 31-20 57-45 57S5 154 5 123c0-27 14-50 33-56l12-2c25 0 45 26 45 58Zm-45 47c22 0 39-22 39-50S72 70 50 70s-39 22-39 50 17 50 39 50Z"
									className="fill-foreground"
								/>
								<path
									d="M34 29c-4-8-11-5-14-4 2 3 5 4 9 4h5Z"
									className="fill-foreground stroke-muted-foreground"
								/>
								<path
									d="M25 38c-1 6 0 14 2 18 5-7 7-13 7-18v-9c-5 1-7 5-9 9Z"
									className="fill-muted-foreground"
								/>
								<path
									d="M34 29c-1 3-5 11-5 16m5-16c-5 1-7 5-9 9-1 6 0 14 2 18 5-7 7-13 7-18v-9Z"
									className="stroke-muted-foreground"
								/>
								<path
									d="M44 18c-10 1-11 7-10 11l4-3c5-4 6-7 6-8Z"
									className="fill-foreground stroke-muted-foreground"
								/>
								<path
									d="M34 29h7l18 4c-3-6-9-14-21-7l-4 3Z"
									className="fill-foreground"
								/>
								<path
									d="M34 29c4-2 12-5 18-1m-18 1h7l18 4c-3-6-9-14-21-7l-4 3Z"
									className="stroke-muted-foreground"
								/>
								<path
									d="M32 29a1189 1189 0 0 1-16 19c0-17 7-18 13-19h5a14 14 0 0 1-2 0Z"
									className="fill-foreground"
								/>
								<path
									d="M34 29c-5 1-7 5-9 9l-9 10c0-17 7-18 13-19h5Zm0 0c-5 2-11 3-14 10"
									className="stroke-muted-foreground"
								/>
								<path
									d="M41 29c9 2 13 10 15 14a25 25 0 0 1-22-14h7Z"
									className="fill-foreground"
								/>
								<path
									d="M34 29c3 1 11 5 15 9m-15-9h7c9 2 13 10 15 14a25 25 0 0 1-22-14Z"
									className="stroke-muted-foreground"
								/>
								<circle
									cx="91.5"
									cy="12.5"
									r="18.5"
									className="fill-foreground stroke-muted-foreground"
									strokeWidth="2"
								/>
							</g>
						</svg>
						<p>TANSTACK START.</p>
					</div>
					<div className="flex items-center justify-center gap-4">
						{data?.user ? (
							<p>Hello {data.user.name}</p>
						) : (
							<NavigationMenu>
								<NavigationMenuList>
									<NavigationMenuItem>
										<NavigationMenuLink asChild>
											<Link
												to="/auth/signin"
												className={navigationMenuTriggerStyle()}
												activeProps={{ className: "bg-accent/50" }}
											>
												Sign In
											</Link>
										</NavigationMenuLink>
									</NavigationMenuItem>
									<NavigationMenuItem>
										<NavigationMenuLink asChild>
											<Link
												to="/auth/signup"
												className={navigationMenuTriggerStyle()}
												activeProps={{ className: "bg-accent/50" }}
											>
												Sign Up
											</Link>
										</NavigationMenuLink>
									</NavigationMenuItem>
								</NavigationMenuList>
							</NavigationMenu>
						)}
					</div>
					<div className="flex items-center gap-4 justify-center">
						{data?.user && (
							<Button
								onClick={() =>
									signOut(
										{},
										{
											onError: (error) => {
												console.warn(error);
												toast.error(error.error.message);
											},
											onSuccess: () => {
												toast.success("You have been signed out!");
											},
										},
									)
								}
								variant="destructive"
							>
								<DoorOpen className="w-5 h-5" />
							</Button>
						)}
						<Button
							onClick={() => setTheme(theme === "light" ? "dark" : "light")}
						>
							{theme === "light" ? (
								<Moon onClick={() => setTheme("dark")} className="w-5 h-5" />
							) : (
								<Sun onClick={() => setTheme("light")} className="w-5 h-5" />
							)}
						</Button>
					</div>
				</nav>
				<Outlet />
			</>
			<Toaster richColors position="bottom-center" />
		</RootDocument>
	);
}

function RootDocument({ children }: { children: React.ReactNode }) {
	return (
		<Html>
			<Head>
				<Meta />
			</Head>
			<Body>
				{children}
				<ScrollRestoration />
				<Scripts />
			</Body>
		</Html>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/tanstack-example/app/routes/index.tsx
```
import {
	Card,
	CardContent,
	CardDescription,
	CardHeader,
	CardTitle,
} from "~/components/ui/card";

import { twoFactor, useSession } from "~/lib/auth-client";
import { UAParser } from "ua-parser-js";
import { Laptop, Loader2, Phone, ShieldCheck, ShieldOff } from "lucide-react";
import { useState } from "react";
import {
	Dialog,
	DialogContent,
	DialogDescription,
	DialogFooter,
	DialogHeader,
	DialogTitle,
	DialogTrigger,
} from "~/components/ui/dialog";
import { Button } from "~/components/ui/button";
import { Label } from "~/components/ui/label";
import { Input } from "~/components/ui/input";
import { toast } from "sonner";
import QRCode from "react-qr-code";
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/")({
	component: Home,
});

function Home() {
	const { data } = useSession();
	const [twoFactorDialog, setTwoFactorDialog] = useState(false);
	const [twoFaPassword, setTwoFaPassword] = useState("");
	const [isPendingTwoFa, setIsPendingTwoFa] = useState(false);
	const [twoFactorVerifyURI, setTwoFactorVerifyURI] = useState<string>("");
	return (
		<div className="container flex justify-center items-center min-h-[80vh]">
			<Card className="w-fit">
				{data?.user && (
					<>
						<CardHeader>
							<CardTitle>Welcome, {data.user.name}!</CardTitle>
							<CardDescription>
								You are signed in as {data.user.email}.
							</CardDescription>
						</CardHeader>
						<CardContent className="flex flex-col gap-2 justify-start">
							<div className="flex flex-col">
								<div className="flex items-center gap-2">
									{new UAParser(data.session.userAgent).getDevice().type ===
									"mobile" ? (
										<Phone />
									) : (
										<Laptop size={16} />
									)}
									{new UAParser(data.session.userAgent).getOS().name},{" "}
									{new UAParser(data.session.userAgent).getBrowser().name}
								</div>
							</div>
							<div className="flex flex-col gap-2">
								<div className="flex gap-2">
									<Dialog
										open={twoFactorDialog}
										onOpenChange={setTwoFactorDialog}
									>
										<DialogTrigger asChild>
											<Button
												variant={
													data?.user.twoFactorEnabled
														? "destructive"
														: "outline"
												}
												className="gap-2"
											>
												{data?.user.twoFactorEnabled ? (
													<ShieldOff size={16} />
												) : (
													<ShieldCheck size={16} />
												)}
												<span className="md:text-sm text-xs">
													{data?.user.twoFactorEnabled
														? "Disable 2FA"
														: "Enable 2FA"}
												</span>
											</Button>
										</DialogTrigger>
										<DialogContent className="sm:max-w-[425px] w-11/12">
											<DialogHeader>
												<DialogTitle>
													{data?.user.twoFactorEnabled
														? "Disable 2FA"
														: "Enable 2FA"}
												</DialogTitle>
												<DialogDescription>
													{data?.user.twoFactorEnabled
														? "Disable the second factor authentication from your account"
														: "Enable 2FA to secure your account"}
												</DialogDescription>
											</DialogHeader>

											{twoFactorVerifyURI ? (
												<div className="flex flex-col gap-2">
													<div className="flex items-center justify-center">
														<QRCode value={twoFactorVerifyURI} />
													</div>
													<Label htmlFor="password">
														Scan the QR code with your TOTP app
													</Label>
													<Input
														value={twoFaPassword}
														onChange={(e) => setTwoFaPassword(e.target.value)}
														placeholder="Enter OTP"
													/>
												</div>
											) : (
												<div className="flex flex-col gap-2">
													<Label htmlFor="password">Password</Label>
													<Input
														id="password"
														type="password"
														placeholder="Password"
														value={twoFaPassword}
														onChange={(e) => setTwoFaPassword(e.target.value)}
													/>
												</div>
											)}
											<DialogFooter>
												<Button
													disabled={isPendingTwoFa}
													onClick={async () => {
														if (
															twoFaPassword.length < 8 &&
															!twoFactorVerifyURI
														) {
															toast.error(
																"Password must be at least 8 characters",
															);
															return;
														}
														setIsPendingTwoFa(true);
														if (data?.user.twoFactorEnabled) {
															const res = await twoFactor.disable({
																//@ts-ignore
																password: twoFaPassword,
																fetchOptions: {
																	onError(context) {
																		toast.error(context.error.message);
																	},
																	onSuccess() {
																		toast("2FA disabled successfully");
																		setTwoFactorDialog(false);
																	},
																},
															});
														} else {
															if (twoFactorVerifyURI) {
																await twoFactor.verifyTotp({
																	code: twoFaPassword,
																	fetchOptions: {
																		onError(context) {
																			setIsPendingTwoFa(false);
																			setTwoFaPassword("");
																			toast.error(context.error.message);
																		},
																		onSuccess() {
																			toast("2FA enabled successfully");
																			setTwoFactorVerifyURI("");
																			setIsPendingTwoFa(false);
																			setTwoFaPassword("");
																			setTwoFactorDialog(false);
																		},
																	},
																});
																return;
															}
															await twoFactor.enable({
																password: twoFaPassword,
																fetchOptions: {
																	onError(context) {
																		toast.error(context.error.message);
																	},
																	onSuccess(ctx) {
																		setTwoFactorVerifyURI(ctx.data.totpURI);
																	},
																},
															});
														}
														setIsPendingTwoFa(false);
														setTwoFaPassword("");
													}}
												>
													{isPendingTwoFa ? (
														<Loader2 size={15} className="animate-spin" />
													) : data?.user.twoFactorEnabled ? (
														"Disable 2FA"
													) : (
														"Enable 2FA"
													)}
												</Button>
											</DialogFooter>
										</DialogContent>
									</Dialog>
								</div>
							</div>
						</CardContent>
					</>
				)}
			</Card>
		</div>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/tanstack-example/app/routes/auth/signin.tsx
```
import { createFileRoute } from "@tanstack/react-router";
import { LoginForm } from "~/components/login-form";

export const Route = createFileRoute("/auth/signin")({
	component: SignIn,
});

function SignIn() {
	return (
		<div className="container">
			<LoginForm />
		</div>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/tanstack-example/app/routes/auth/signup.tsx
```
import { createFileRoute } from "@tanstack/react-router";
import { RegisterForm } from "~/components/register-form";

export const Route = createFileRoute("/auth/signup")({
	component: SignUp,
});

function SignUp() {
	return (
		<div className="container">
			<RegisterForm />
		</div>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/tanstack-example/app/routes/auth/two-factor.tsx
```
import { createFileRoute } from "@tanstack/react-router";
import { AlertCircle, CheckCircle2 } from "lucide-react";
import { useState } from "react";
import { Button } from "~/components/ui/button";
import {
	Card,
	CardContent,
	CardDescription,
	CardHeader,
	CardTitle,
} from "~/components/ui/card";
import { Input } from "~/components/ui/input";
import { Label } from "~/components/ui/label";
import { twoFactor } from "~/lib/auth-client";

export const Route = createFileRoute("/auth/two-factor")({
	component: TwoFactor,
});

function TwoFactor() {
	const [totpCode, setTotpCode] = useState("");
	const [error, setError] = useState("");
	const [success, setSuccess] = useState(false);

	const handleSubmit = (e: React.FormEvent) => {
		e.preventDefault();
		if (totpCode.length !== 6 || !/^\d+$/.test(totpCode)) {
			setError("TOTP code must be 6 digits");
			return;
		}
		twoFactor
			.verifyTotp({
				code: totpCode,
			})
			.then((res) => {
				if (res.data?.session) {
					setSuccess(true);
					setError("");
				} else {
					setError("Invalid TOTP code");
				}
			});
	};
	return (
		<main className="flex flex-col items-center justify-center min-h-[calc(100vh-10rem)]">
			<Card className="w-[350px]">
				<CardHeader>
					<CardTitle>TOTP Verification</CardTitle>
					<CardDescription>
						Enter your 6-digit TOTP code to authenticate
					</CardDescription>
				</CardHeader>
				<CardContent>
					{!success ? (
						<form onSubmit={handleSubmit}>
							<div className="space-y-2">
								<Label htmlFor="totp">TOTP Code</Label>
								<Input
									id="totp"
									type="text"
									pattern="\d{6}"
									maxLength={6}
									value={totpCode}
									onChange={(e) => setTotpCode(e.target.value)}
									placeholder="Enter 6-digit code"
									required
								/>
							</div>
							{error && (
								<div className="flex items-center mt-2 text-red-500">
									<AlertCircle className="w-4 h-4 mr-2" />
									<span className="text-sm">{error}</span>
								</div>
							)}
							<Button type="submit" className="w-full mt-4">
								Verify
							</Button>
						</form>
					) : (
						<div className="flex flex-col items-center justify-center space-y-2">
							<CheckCircle2 className="w-12 h-12 text-green-500" />
							<p className="text-lg font-semibold">Verification Successful</p>
						</div>
					)}
				</CardContent>
			</Card>
		</main>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/tanstack-example/app/routes/api/auth/$.ts
```typescript
import { createAPIFileRoute } from "@tanstack/start/api";
import { auth } from "~/lib/auth";

export const APIRoute = createAPIFileRoute("/api/auth/$")({
	GET: ({ request }) => {
		return auth.handler(request);
	},
	POST: ({ request }) => {
		return auth.handler(request);
	},
});

```
