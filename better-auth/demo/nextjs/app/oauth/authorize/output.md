/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/app/oauth/authorize/concet-buttons.tsx
```
"use client";

import { Button } from "@/components/ui/button";
import { CardFooter } from "@/components/ui/card";
import { client } from "@/lib/auth-client";
import { Loader2 } from "lucide-react";
import { useState } from "react";
import { toast } from "sonner";

export function ConsentBtns() {
	const [loading, setLoading] = useState(false);
	return (
		<CardFooter className="flex items-center gap-2">
			<Button
				onClick={async () => {
					setLoading(true);
					const res = await client.oauth2.consent({
						accept: true,
					});
					setLoading(false);
					if (res.data?.redirectURI) {
						window.location.href = res.data.redirectURI;
						return;
					}
					toast.error("Failed to authorize");
				}}
			>
				{loading ? <Loader2 size={15} className="animate-spin" /> : "Authorize"}
			</Button>
			<Button
				variant="outline"
				onClick={async () => {
					const res = await client.oauth2.consent({
						accept: false,
					});
					if (res.data?.redirectURI) {
						window.location.href = res.data.redirectURI;
						return;
					}
					toast.error("Failed to cancel");
				}}
			>
				Cancel
			</Button>
		</CardFooter>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/app/oauth/authorize/page.tsx
```
import { Metadata } from "next";
import { auth } from "@/lib/auth";
import { headers } from "next/headers";
import { ArrowLeftRight, ArrowUpRight, Mail, Users } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Logo } from "@/components/logo";
import Image from "next/image";
import { ConsentBtns } from "./concet-buttons";

export const metadata: Metadata = {
	title: "Authorize Application",
	description: "Grant access to your account",
};

interface AuthorizePageProps {
	searchParams: Promise<{
		redirect_uri: string;
		scope: string;
		cancel_uri: string;
		client_id: string;
	}>;
}

export default async function AuthorizePage({
	searchParams,
}: AuthorizePageProps) {
	const { redirect_uri, scope, client_id, cancel_uri } = await searchParams;
	const session = await auth.api.getSession({
		headers: await headers(),
	});
	const clientDetails = await auth.api.getOAuthClient({
		params: {
			id: client_id,
		},
		headers: await headers(),
	});

	return (
		<div className="container mx-auto py-10">
			<h1 className="text-2xl font-bold mb-6 text-center">
				Authorize Application
			</h1>
			<div className="min-h-screen bg-black text-white flex flex-col">
				<div className="flex flex-col items-center justify-center max-w-2xl mx-auto px-4">
					<div className="flex items-center gap-8 mb-8">
						<div className="w-16 h-16 border rounded-full flex items-center justify-center">
							{clientDetails.icon ? (
								<Image
									src={clientDetails.icon}
									alt="App Logo"
									className="object-cover"
									width={64}
									height={64}
								/>
							) : (
								<Logo />
							)}
						</div>
						<ArrowLeftRight className="h-6 w-6" />
						<div className="w-16 h-16 rounded-full overflow-hidden">
							<Avatar className="hidden h-16 w-16 sm:flex ">
								<AvatarImage
									src={session?.user.image || "#"}
									alt="Avatar"
									className="object-cover"
								/>
								<AvatarFallback>{session?.user.name.charAt(0)}</AvatarFallback>
							</Avatar>
						</div>
					</div>

					<h1 className="text-3xl font-semibold text-center mb-8">
						{clientDetails.name} is requesting access to your Better Auth
						account
					</h1>

					<Card className="w-full bg-zinc-900 border-zinc-800 rounded-none">
						<CardContent className="p-6">
							<div className="flex items-center justify-between p-4 bg-zinc-800 rounded-lg mb-6">
								<div>
									<div className="font-medium">{session?.user.name}</div>
									<div className="text-zinc-400">{session?.user.email}</div>
								</div>
								<ArrowUpRight className="h-5 w-5 text-zinc-400" />
							</div>
							<div className="flex flex-col gap-1">
								<div className="text-lg mb-4">
									Continuing will allow Sign in with {clientDetails.name} to:
								</div>
								{scope.includes("profile") && (
									<div className="flex items-center gap-3 text-zinc-300">
										<Users className="h-5 w-5" />
										<span>Read your Better Auth user data.</span>
									</div>
								)}

								{scope.includes("email") && (
									<div className="flex items-center gap-3 text-zinc-300">
										<Mail className="h-5 w-5" />
										<span>Read your email address.</span>
									</div>
								)}
							</div>
						</CardContent>
						<ConsentBtns />
					</Card>
				</div>
			</div>
		</div>
	);
}

```
