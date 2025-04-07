/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/app/dashboard/change-plan.tsx
```
import { Button } from "@/components/ui/button";
import {
	Dialog,
	DialogContent,
	DialogDescription,
	DialogHeader,
	DialogTitle,
	DialogTrigger,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { client } from "@/lib/auth-client";
import { cn } from "@/lib/utils";
import { ArrowUpFromLine, CreditCard, RefreshCcw } from "lucide-react";
import { useId, useState } from "react";
import { toast } from "sonner";

function Component(props: {
	currentPlan?: string;
	isTrial?: boolean;
}) {
	const [selectedPlan, setSelectedPlan] = useState("starter");
	const id = useId();
	return (
		<Dialog>
			<DialogTrigger asChild>
				<Button
					variant={!props.currentPlan ? "default" : "outline"}
					size="sm"
					className={cn(
						"gap-2",
						!props.currentPlan &&
							" bg-gradient-to-br from-purple-100 to-stone-300",
					)}
				>
					{props.currentPlan ? (
						<RefreshCcw className="opacity-80" size={14} strokeWidth={2} />
					) : (
						<ArrowUpFromLine className="opacity-80" size={14} strokeWidth={2} />
					)}
					{props.currentPlan ? "Change Plan" : "Upgrade Plan"}
				</Button>
			</DialogTrigger>
			<DialogContent>
				<div className="mb-2 flex flex-col gap-2">
					<div
						className="flex size-11 shrink-0 items-center justify-center rounded-full border border-border"
						aria-hidden="true"
					>
						{props.currentPlan ? (
							<RefreshCcw className="opacity-80" size={16} strokeWidth={2} />
						) : (
							<CreditCard className="opacity-80" size={16} strokeWidth={2} />
						)}
					</div>
					<DialogHeader>
						<DialogTitle className="text-left">
							{!props.currentPlan ? "Upgrade" : "Change"} your plan
						</DialogTitle>
						<DialogDescription className="text-left">
							Pick one of the following plans.
						</DialogDescription>
					</DialogHeader>
				</div>

				<form className="space-y-5">
					<RadioGroup
						className="gap-2"
						defaultValue="2"
						value={selectedPlan}
						onValueChange={(value) => setSelectedPlan(value)}
					>
						<div className="relative flex w-full items-center gap-2 rounded-lg border border-input px-4 py-3 shadow-sm shadow-black/5 has-[[data-state=checked]]:border-ring has-[[data-state=checked]]:bg-accent">
							<RadioGroupItem
								value="starter"
								id={`${id}-1`}
								aria-describedby={`${id}-1-description`}
								className="order-1 after:absolute after:inset-0"
							/>
							<div className="grid grow gap-1">
								<Label htmlFor={`${id}-1`}>Starter</Label>
								<p
									id={`${id}-1-description`}
									className="text-xs text-muted-foreground"
								>
									$50/month
								</p>
							</div>
						</div>
						<div className="relative flex w-full items-center gap-2 rounded-lg border border-input px-4 py-3 shadow-sm shadow-black/5 has-[[data-state=checked]]:border-ring has-[[data-state=checked]]:bg-accent">
							<RadioGroupItem
								value="professional"
								id={`${id}-2`}
								aria-describedby={`${id}-2-description`}
								className="order-1 after:absolute after:inset-0"
							/>
							<div className="grid grow gap-1">
								<Label htmlFor={`${id}-2`}>Professional</Label>
								<p
									id={`${id}-2-description`}
									className="text-xs text-muted-foreground"
								>
									$99/month
								</p>
							</div>
						</div>
						<div className="relative flex w-full items-center gap-2 rounded-lg border border-input px-4 py-3 shadow-sm shadow-black/5 has-[[data-state=checked]]:border-ring has-[[data-state=checked]]:bg-accent">
							<RadioGroupItem
								value="enterprise"
								id={`${id}-3`}
								aria-describedby={`${id}-3-description`}
								className="order-1 after:absolute after:inset-0"
							/>
							<div className="grid grow gap-1">
								<Label htmlFor={`${id}-3`}>Enterprise</Label>
								<p
									id={`${id}-3-description`}
									className="text-xs text-muted-foreground"
								>
									Contact our sales team
								</p>
							</div>
						</div>
					</RadioGroup>

					<div className="space-y-3">
						<p className="text-xs text-white/70 text-center">
							note: all upgrades takes effect immediately and you'll be charged
							the new amount on your next billing cycle.
						</p>
					</div>

					<div className="grid gap-2">
						<Button
							type="button"
							className="w-full"
							disabled={
								selectedPlan === props.currentPlan?.toLowerCase() &&
								!props.isTrial
							}
							onClick={async () => {
								if (selectedPlan === "enterprise") {
									return;
								}
								await client.subscription.upgrade(
									{
										plan: selectedPlan,
									},
									{
										onError: (ctx) => {
											toast.error(ctx.error.message);
										},
									},
								);
							}}
						>
							{selectedPlan === props.currentPlan?.toLowerCase()
								? props.isTrial
									? "Upgrade"
									: "Current Plan"
								: selectedPlan === "starter"
									? !props.currentPlan
										? "Upgrade"
										: "Downgrade"
									: selectedPlan === "professional"
										? "Upgrade"
										: "Contact us"}
						</Button>
						{props.currentPlan && (
							<Button
								type="button"
								variant="destructive"
								className="w-full"
								onClick={async () => {
									await client.subscription.cancel(
										{
											returnUrl: "/dashboard",
										},
										{
											onError: (ctx) => {
												toast.error(ctx.error.message);
											},
										},
									);
								}}
							>
								Cancel Plan
							</Button>
						)}
					</div>
				</form>
			</DialogContent>
		</Dialog>
	);
}

export { Component };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/app/dashboard/client.tsx
```
"use client";

export function ManageAccount() {
	return (
		<div className="flex items-center gap-2">
			<p>Manage Account</p>
		</div>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/app/dashboard/organization-card.tsx
```
"use client";

import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
	Dialog,
	DialogClose,
	DialogContent,
	DialogDescription,
	DialogFooter,
	DialogHeader,
	DialogTitle,
	DialogTrigger,
} from "@/components/ui/dialog";
import {
	DropdownMenu,
	DropdownMenuContent,
	DropdownMenuItem,
	DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
	Select,
	SelectContent,
	SelectItem,
	SelectTrigger,
	SelectValue,
} from "@/components/ui/select";
import {
	organization,
	useListOrganizations,
	useSession,
} from "@/lib/auth-client";
import { ActiveOrganization, Session } from "@/lib/auth-types";
import { ChevronDownIcon, PlusIcon } from "@radix-ui/react-icons";
import { Loader2, MailPlus } from "lucide-react";
import { useState, useEffect } from "react";
import { toast } from "sonner";
import { AnimatePresence, motion } from "framer-motion";
import CopyButton from "@/components/ui/copy-button";
import Image from "next/image";

export function OrganizationCard(props: {
	session: Session | null;
	activeOrganization: ActiveOrganization | null;
}) {
	const organizations = useListOrganizations();
	const [optimisticOrg, setOptimisticOrg] = useState<ActiveOrganization | null>(
		props.activeOrganization,
	);
	const [isRevoking, setIsRevoking] = useState<string[]>([]);
	const inviteVariants = {
		hidden: { opacity: 0, height: 0 },
		visible: { opacity: 1, height: "auto" },
		exit: { opacity: 0, height: 0 },
	};

	const { data } = useSession();
	const session = data || props.session;

	const currentMember = optimisticOrg?.members.find(
		(member) => member.userId === session?.user.id,
	);

	return (
		<Card>
			<CardHeader>
				<CardTitle>Organization</CardTitle>
				<div className="flex justify-between">
					<DropdownMenu>
						<DropdownMenuTrigger asChild>
							<div className="flex items-center gap-1 cursor-pointer">
								<p className="text-sm">
									<span className="font-bold"></span>{" "}
									{optimisticOrg?.name || "Personal"}
								</p>

								<ChevronDownIcon />
							</div>
						</DropdownMenuTrigger>
						<DropdownMenuContent align="start">
							<DropdownMenuItem
								className=" py-1"
								onClick={async () => {
									organization.setActive({
										organizationId: null,
									});
									setOptimisticOrg(null);
								}}
							>
								<p className="text-sm sm">Personal</p>
							</DropdownMenuItem>
							{organizations.data?.map((org) => (
								<DropdownMenuItem
									className=" py-1"
									key={org.id}
									onClick={async () => {
										if (org.id === optimisticOrg?.id) {
											return;
										}
										setOptimisticOrg({
											members: [],
											invitations: [],
											...org,
										});
										const { data } = await organization.setActive({
											organizationId: org.id,
										});
										setOptimisticOrg(data);
									}}
								>
									<p className="text-sm sm">{org.name}</p>
								</DropdownMenuItem>
							))}
						</DropdownMenuContent>
					</DropdownMenu>
					<div>
						<CreateOrganizationDialog />
					</div>
				</div>
				<div className="flex items-center gap-2">
					<Avatar className="rounded-none">
						<AvatarImage
							className="object-cover w-full h-full rounded-none"
							src={optimisticOrg?.logo || undefined}
						/>
						<AvatarFallback className="rounded-none">
							{optimisticOrg?.name?.charAt(0) || "P"}
						</AvatarFallback>
					</Avatar>
					<div>
						<p>{optimisticOrg?.name || "Personal"}</p>
						<p className="text-xs text-muted-foreground">
							{optimisticOrg?.members.length || 1} members
						</p>
					</div>
				</div>
			</CardHeader>
			<CardContent>
				<div className="flex gap-8 flex-col md:flex-row">
					<div className="flex flex-col gap-2 flex-grow">
						<p className="font-medium border-b-2 border-b-foreground/10">
							Members
						</p>
						<div className="flex flex-col gap-2">
							{optimisticOrg?.members.map((member) => (
								<div
									key={member.id}
									className="flex justify-between items-center"
								>
									<div className="flex items-center gap-2">
										<Avatar className="sm:flex w-9 h-9">
											<AvatarImage
												src={member.user.image || undefined}
												className="object-cover"
											/>
											<AvatarFallback>
												{member.user.name?.charAt(0)}
											</AvatarFallback>
										</Avatar>
										<div>
											<p className="text-sm">{member.user.name}</p>
											<p className="text-xs text-muted-foreground">
												{member.role}
											</p>
										</div>
									</div>
									{member.role !== "owner" &&
										(currentMember?.role === "owner" ||
											currentMember?.role === "admin") && (
											<Button
												size="sm"
												variant="destructive"
												onClick={() => {
													organization.removeMember({
														memberIdOrEmail: member.id,
													});
												}}
											>
												{currentMember?.id === member.id ? "Leave" : "Remove"}
											</Button>
										)}
								</div>
							))}
							{!optimisticOrg?.id && (
								<div>
									<div className="flex items-center gap-2">
										<Avatar>
											<AvatarImage src={session?.user.image || undefined} />
											<AvatarFallback>
												{session?.user.name?.charAt(0)}
											</AvatarFallback>
										</Avatar>
										<div>
											<p className="text-sm">{session?.user.name}</p>
											<p className="text-xs text-muted-foreground">Owner</p>
										</div>
									</div>
								</div>
							)}
						</div>
					</div>
					<div className="flex flex-col gap-2 flex-grow">
						<p className="font-medium border-b-2 border-b-foreground/10">
							Invites
						</p>
						<div className="flex flex-col gap-2">
							<AnimatePresence>
								{optimisticOrg?.invitations
									.filter((invitation) => invitation.status === "pending")
									.map((invitation) => (
										<motion.div
											key={invitation.id}
											className="flex items-center justify-between"
											variants={inviteVariants}
											initial="hidden"
											animate="visible"
											exit="exit"
											layout
										>
											<div>
												<p className="text-sm">{invitation.email}</p>
												<p className="text-xs text-muted-foreground">
													{invitation.role}
												</p>
											</div>
											<div className="flex items-center gap-2">
												<Button
													disabled={isRevoking.includes(invitation.id)}
													size="sm"
													variant="destructive"
													onClick={() => {
														organization.cancelInvitation(
															{
																invitationId: invitation.id,
															},
															{
																onRequest: () => {
																	setIsRevoking([...isRevoking, invitation.id]);
																},
																onSuccess: () => {
																	toast.message(
																		"Invitation revoked successfully",
																	);
																	setIsRevoking(
																		isRevoking.filter(
																			(id) => id !== invitation.id,
																		),
																	);
																	setOptimisticOrg({
																		...optimisticOrg,
																		invitations:
																			optimisticOrg?.invitations.filter(
																				(inv) => inv.id !== invitation.id,
																			),
																	});
																},
																onError: (ctx) => {
																	toast.error(ctx.error.message);
																	setIsRevoking(
																		isRevoking.filter(
																			(id) => id !== invitation.id,
																		),
																	);
																},
															},
														);
													}}
												>
													{isRevoking.includes(invitation.id) ? (
														<Loader2 className="animate-spin" size={16} />
													) : (
														"Revoke"
													)}
												</Button>
												<div>
													<CopyButton
														textToCopy={`${window.location.origin}/accept-invitation/${invitation.id}`}
													/>
												</div>
											</div>
										</motion.div>
									))}
							</AnimatePresence>
							{optimisticOrg?.invitations.length === 0 && (
								<motion.p
									className="text-sm text-muted-foreground"
									initial={{ opacity: 0 }}
									animate={{ opacity: 1 }}
									exit={{ opacity: 0 }}
								>
									No Active Invitations
								</motion.p>
							)}
							{!optimisticOrg?.id && (
								<Label className="text-xs text-muted-foreground">
									You can&apos;t invite members to your personal workspace.
								</Label>
							)}
						</div>
					</div>
				</div>
				<div className="flex justify-end w-full mt-4">
					<div>
						<div>
							{optimisticOrg?.id && (
								<InviteMemberDialog
									setOptimisticOrg={setOptimisticOrg}
									optimisticOrg={optimisticOrg}
								/>
							)}
						</div>
					</div>
				</div>
			</CardContent>
		</Card>
	);
}

function CreateOrganizationDialog() {
	const [name, setName] = useState("");
	const [slug, setSlug] = useState("");
	const [loading, setLoading] = useState(false);
	const [open, setOpen] = useState(false);
	const [isSlugEdited, setIsSlugEdited] = useState(false);
	const [logo, setLogo] = useState<string | null>(null);

	useEffect(() => {
		if (!isSlugEdited) {
			const generatedSlug = name.trim().toLowerCase().replace(/\s+/g, "-");
			setSlug(generatedSlug);
		}
	}, [name, isSlugEdited]);

	useEffect(() => {
		if (open) {
			setName("");
			setSlug("");
			setIsSlugEdited(false);
			setLogo(null);
		}
	}, [open]);

	const handleLogoChange = (e: React.ChangeEvent<HTMLInputElement>) => {
		if (e.target.files && e.target.files[0]) {
			const file = e.target.files[0];
			const reader = new FileReader();
			reader.onloadend = () => {
				setLogo(reader.result as string);
			};
			reader.readAsDataURL(file);
		}
	};

	return (
		<Dialog open={open} onOpenChange={setOpen}>
			<DialogTrigger asChild>
				<Button size="sm" className="w-full gap-2" variant="default">
					<PlusIcon />
					<p>New Organization</p>
				</Button>
			</DialogTrigger>
			<DialogContent className="sm:max-w-[425px] w-11/12">
				<DialogHeader>
					<DialogTitle>New Organization</DialogTitle>
					<DialogDescription>
						Create a new organization to collaborate with your team.
					</DialogDescription>
				</DialogHeader>
				<div className="flex flex-col gap-4">
					<div className="flex flex-col gap-2">
						<Label>Organization Name</Label>
						<Input
							placeholder="Name"
							value={name}
							onChange={(e) => setName(e.target.value)}
						/>
					</div>
					<div className="flex flex-col gap-2">
						<Label>Organization Slug</Label>
						<Input
							value={slug}
							onChange={(e) => {
								setSlug(e.target.value);
								setIsSlugEdited(true);
							}}
							placeholder="Slug"
						/>
					</div>
					<div className="flex flex-col gap-2">
						<Label>Logo</Label>
						<Input type="file" accept="image/*" onChange={handleLogoChange} />
						{logo && (
							<div className="mt-2">
								<Image
									src={logo}
									alt="Logo preview"
									className="w-16 h-16 object-cover"
									width={16}
									height={16}
								/>
							</div>
						)}
					</div>
				</div>
				<DialogFooter>
					<Button
						disabled={loading}
						onClick={async () => {
							setLoading(true);
							await organization.create(
								{
									name: name,
									slug: slug,
									logo: logo || undefined,
								},
								{
									onResponse: () => {
										setLoading(false);
									},
									onSuccess: () => {
										toast.success("Organization created successfully");
										setOpen(false);
									},
									onError: (error) => {
										toast.error(error.error.message);
										setLoading(false);
									},
								},
							);
						}}
					>
						{loading ? (
							<Loader2 className="animate-spin" size={16} />
						) : (
							"Create"
						)}
					</Button>
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
}

function InviteMemberDialog({
	setOptimisticOrg,
	optimisticOrg,
}: {
	setOptimisticOrg: (org: ActiveOrganization | null) => void;
	optimisticOrg: ActiveOrganization | null;
}) {
	const [open, setOpen] = useState(false);
	const [email, setEmail] = useState("");
	const [role, setRole] = useState("member");
	const [loading, setLoading] = useState(false);
	return (
		<Dialog>
			<DialogTrigger asChild>
				<Button size="sm" className="w-full gap-2" variant="secondary">
					<MailPlus size={16} />
					<p>Invite Member</p>
				</Button>
			</DialogTrigger>
			<DialogContent className="sm:max-w-[425px] w-11/12">
				<DialogHeader>
					<DialogTitle>Invite Member</DialogTitle>
					<DialogDescription>
						Invite a member to your organization.
					</DialogDescription>
				</DialogHeader>
				<div className="flex flex-col gap-2">
					<Label>Email</Label>
					<Input
						placeholder="Email"
						value={email}
						onChange={(e) => setEmail(e.target.value)}
					/>
					<Label>Role</Label>
					<Select value={role} onValueChange={setRole}>
						<SelectTrigger>
							<SelectValue placeholder="Select a role" />
						</SelectTrigger>
						<SelectContent>
							<SelectItem value="admin">Admin</SelectItem>
							<SelectItem value="member">Member</SelectItem>
						</SelectContent>
					</Select>
				</div>
				<DialogFooter>
					<DialogClose>
						<Button
							disabled={loading}
							onClick={async () => {
								const invite = organization.inviteMember({
									email: email,
									role: role as "member",
									fetchOptions: {
										throw: true,
										onSuccess: (ctx) => {
											if (optimisticOrg) {
												setOptimisticOrg({
													...optimisticOrg,
													invitations: [
														...(optimisticOrg?.invitations || []),
														ctx.data,
													],
												});
											}
										},
									},
								});
								toast.promise(invite, {
									loading: "Inviting member...",
									success: "Member invited successfully",
									error: (error) => error.error.message,
								});
							}}
						>
							Invite
						</Button>
					</DialogClose>
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/app/dashboard/page.tsx
```
import { auth } from "@/lib/auth";
import { headers } from "next/headers";
import { redirect } from "next/navigation";
import UserCard from "./user-card";
import { OrganizationCard } from "./organization-card";
import AccountSwitcher from "@/components/account-switch";

export default async function DashboardPage() {
	const [session, activeSessions, deviceSessions, organization, subscriptions] =
		await Promise.all([
			auth.api.getSession({
				headers: await headers(),
			}),
			auth.api.listSessions({
				headers: await headers(),
			}),
			auth.api.listDeviceSessions({
				headers: await headers(),
			}),
			auth.api.getFullOrganization({
				headers: await headers(),
			}),
			auth.api.listActiveSubscriptions({
				headers: await headers(),
			}),
		]).catch((e) => {
			console.log(e);
			throw redirect("/sign-in");
		});
	return (
		<div className="w-full">
			<div className="flex gap-4 flex-col">
				<AccountSwitcher
					sessions={JSON.parse(JSON.stringify(deviceSessions))}
				/>
				<UserCard
					session={JSON.parse(JSON.stringify(session))}
					activeSessions={JSON.parse(JSON.stringify(activeSessions))}
					subscription={subscriptions.find(
						(sub) => sub.status === "active" || sub.status === "trialing",
					)}
				/>
				<OrganizationCard
					session={JSON.parse(JSON.stringify(session))}
					activeOrganization={JSON.parse(JSON.stringify(organization))}
				/>
			</div>
		</div>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/app/dashboard/upgrade-button.tsx
```
"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Sparkles } from "lucide-react";

export default function UpgradeButton() {
	const [isHovered, setIsHovered] = useState(false);

	return (
		<motion.button
			className="relative overflow-hidden px-6 py-3 rounded-md bg-gradient-to-r from-gray-900 to-black text-white font-bold text-lg shadow-lg transition-all duration-300 ease-out transform hover:scale-105 hover:shadow-xl"
			onHoverStart={() => setIsHovered(true)}
			onHoverEnd={() => setIsHovered(false)}
			whileHover={{ scale: 1.05 }}
			whileTap={{ scale: 0.95 }}
		>
			<span className="relative z-10 flex items-center justify-center">
				<Sparkles className="w-5 h-5 mr-2" />
				Upgrade to Pro
			</span>
			<motion.div
				className="absolute inset-0 bg-gradient-to-r from-gray-800 to-gray-700"
				initial={{ opacity: 0 }}
				animate={{ opacity: isHovered ? 1 : 0 }}
				transition={{ duration: 0.3 }}
			/>
			<motion.div
				className="absolute inset-0 bg-white opacity-10"
				initial={{ scale: 0, x: "100%", y: "100%" }}
				animate={{ scale: isHovered ? 2 : 0, x: "0%", y: "0%" }}
				transition={{ duration: 0.4, ease: "easeOut" }}
				style={{ borderRadius: "2px" }}
			/>
		</motion.button>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/demo/nextjs/app/dashboard/user-card.tsx
```
"use client";

import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import {
	Card,
	CardContent,
	CardFooter,
	CardHeader,
	CardTitle,
} from "@/components/ui/card";
import { Alert, AlertTitle, AlertDescription } from "@/components/ui/alert";
import { Checkbox } from "@/components/ui/checkbox";
import {
	Dialog,
	DialogContent,
	DialogDescription,
	DialogFooter,
	DialogHeader,
	DialogTitle,
	DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { PasswordInput } from "@/components/ui/password-input";
import { client, signOut, useSession } from "@/lib/auth-client";
import { Session } from "@/lib/auth-types";
import { MobileIcon } from "@radix-ui/react-icons";
import {
	Edit,
	Fingerprint,
	Laptop,
	Loader2,
	LogOut,
	Plus,
	QrCode,
	ShieldCheck,
	ShieldOff,
	StopCircle,
	Trash,
	X,
} from "lucide-react";
import Image from "next/image";
import { useRouter } from "next/navigation";
import { useState } from "react";
import { toast } from "sonner";
import { UAParser } from "ua-parser-js";
import {
	Table,
	TableBody,
	TableCell,
	TableHead,
	TableHeader,
	TableRow,
} from "@/components/ui/table";
import QRCode from "react-qr-code";
import CopyButton from "@/components/ui/copy-button";
import { Badge } from "@/components/ui/badge";
import { useQuery } from "@tanstack/react-query";
import { SubscriptionTierLabel } from "@/components/tier-labels";
import { Component } from "./change-plan";
import { Subscription } from "@better-auth/stripe";

export default function UserCard(props: {
	session: Session | null;
	activeSessions: Session["session"][];
	subscription?: Subscription;
}) {
	const router = useRouter();
	const { data, isPending } = useSession();
	const session = data || props.session;
	const [isTerminating, setIsTerminating] = useState<string>();
	const [isPendingTwoFa, setIsPendingTwoFa] = useState<boolean>(false);
	const [twoFaPassword, setTwoFaPassword] = useState<string>("");
	const [twoFactorDialog, setTwoFactorDialog] = useState<boolean>(false);
	const [twoFactorVerifyURI, setTwoFactorVerifyURI] = useState<string>("");
	const [isSignOut, setIsSignOut] = useState<boolean>(false);
	const [emailVerificationPending, setEmailVerificationPending] =
		useState<boolean>(false);
	const { data: subscription } = useQuery({
		queryKey: ["subscriptions"],
		initialData: props.subscription ? props.subscription : null,
		queryFn: async () => {
			const res = await client.subscription.list({
				fetchOptions: {
					throw: true,
				},
			});
			return res.length ? res[0] : null;
		},
	});
	return (
		<Card>
			<CardHeader>
				<CardTitle>User</CardTitle>
			</CardHeader>
			<CardContent className="grid gap-8 grid-cols-1">
				<div className="flex flex-col gap-2">
					<div className="flex items-start justify-between">
						<div className="flex items-center gap-4">
							<Avatar className="hidden h-9 w-9 sm:flex ">
								<AvatarImage
									src={session?.user.image || undefined}
									alt="Avatar"
									className="object-cover"
								/>
								<AvatarFallback>{session?.user.name.charAt(0)}</AvatarFallback>
							</Avatar>
							<div className="grid">
								<div className="flex items-center gap-1">
									<p className="text-sm font-medium leading-none">
										{session?.user.name}
									</p>
									{!!subscription && (
										<Badge
											className="w-min p-px rounded-full"
											variant="outline"
										>
											<svg
												xmlns="http://www.w3.org/2000/svg"
												width="1.2em"
												height="1.2em"
												viewBox="0 0 24 24"
											>
												<path
													fill="currentColor"
													d="m9.023 21.23l-1.67-2.814l-3.176-.685l.312-3.277L2.346 12L4.49 9.546L4.177 6.27l3.177-.685L9.023 2.77L12 4.027l2.977-1.258l1.67 2.816l3.176.684l-.312 3.277L21.655 12l-2.142 2.454l.311 3.277l-3.177.684l-1.669 2.816L12 19.973zm1.927-6.372L15.908 9.9l-.708-.72l-4.25 4.25l-2.15-2.138l-.708.708z"
												></path>
											</svg>
										</Badge>
									)}
								</div>
								<p className="text-sm">{session?.user.email}</p>
							</div>
						</div>
						<EditUserDialog />
					</div>
					<div className="flex items-center justify-between">
						<div>
							<SubscriptionTierLabel
								tier={subscription?.plan?.toLowerCase() as "starter"}
							/>
						</div>
						<Component
							currentPlan={subscription?.plan?.toLowerCase() as "starter"}
							isTrial={subscription?.status === "trialing"}
						/>
					</div>
				</div>

				{session?.user.emailVerified ? null : (
					<Alert>
						<AlertTitle>Verify Your Email Address</AlertTitle>
						<AlertDescription className="text-muted-foreground">
							Please verify your email address. Check your inbox for the
							verification email. If you haven't received the email, click the
							button below to resend.
						</AlertDescription>
						<Button
							size="sm"
							variant="secondary"
							className="mt-2"
							onClick={async () => {
								await client.sendVerificationEmail(
									{
										email: session?.user.email || "",
									},
									{
										onRequest(context) {
											setEmailVerificationPending(true);
										},
										onError(context) {
											toast.error(context.error.message);
											setEmailVerificationPending(false);
										},
										onSuccess() {
											toast.success("Verification email sent successfully");
											setEmailVerificationPending(false);
										},
									},
								);
							}}
						>
							{emailVerificationPending ? (
								<Loader2 size={15} className="animate-spin" />
							) : (
								"Resend Verification Email"
							)}
						</Button>
					</Alert>
				)}

				<div className="border-l-2 px-2 w-max gap-1 flex flex-col">
					<p className="text-xs font-medium ">Active Sessions</p>
					{props.activeSessions
						.filter((session) => session.userAgent)
						.map((session) => {
							return (
								<div key={session.id}>
									<div className="flex items-center gap-2 text-sm  text-black font-medium dark:text-white">
										{new UAParser(session.userAgent || "").getDevice().type ===
										"mobile" ? (
											<MobileIcon />
										) : (
											<Laptop size={16} />
										)}
										{new UAParser(session.userAgent || "").getOS().name},{" "}
										{new UAParser(session.userAgent || "").getBrowser().name}
										<button
											className="text-red-500 opacity-80  cursor-pointer text-xs border-muted-foreground border-red-600  underline "
											onClick={async () => {
												setIsTerminating(session.id);
												const res = await client.revokeSession({
													token: session.token,
												});

												if (res.error) {
													toast.error(res.error.message);
												} else {
													toast.success("Session terminated successfully");
												}
												router.refresh();
												setIsTerminating(undefined);
											}}
										>
											{isTerminating === session.id ? (
												<Loader2 size={15} className="animate-spin" />
											) : session.id === props.session?.session.id ? (
												"Sign Out"
											) : (
												"Terminate"
											)}
										</button>
									</div>
								</div>
							);
						})}
				</div>
				<div className="border-y py-4 flex items-center flex-wrap justify-between gap-2">
					<div className="flex flex-col gap-2">
						<p className="text-sm">Passkeys</p>
						<div className="flex gap-2 flex-wrap">
							<AddPasskey />
							<ListPasskeys />
						</div>
					</div>
					<div className="flex flex-col gap-2">
						<p className="text-sm">Two Factor</p>
						<div className="flex gap-2">
							{!!session?.user.twoFactorEnabled && (
								<Dialog>
									<DialogTrigger asChild>
										<Button variant="outline" className="gap-2">
											<QrCode size={16} />
											<span className="md:text-sm text-xs">Scan QR Code</span>
										</Button>
									</DialogTrigger>
									<DialogContent className="sm:max-w-[425px] w-11/12">
										<DialogHeader>
											<DialogTitle>Scan QR Code</DialogTitle>
											<DialogDescription>
												Scan the QR code with your TOTP app
											</DialogDescription>
										</DialogHeader>

										{twoFactorVerifyURI ? (
											<>
												<div className="flex items-center justify-center">
													<QRCode value={twoFactorVerifyURI} />
												</div>
												<div className="flex gap-2 items-center justify-center">
													<p className="text-sm text-muted-foreground">
														Copy URI to clipboard
													</p>
													<CopyButton textToCopy={twoFactorVerifyURI} />
												</div>
											</>
										) : (
											<div className="flex flex-col gap-2">
												<PasswordInput
													value={twoFaPassword}
													onChange={(e) => setTwoFaPassword(e.target.value)}
													placeholder="Enter Password"
												/>
												<Button
													onClick={async () => {
														if (twoFaPassword.length < 8) {
															toast.error(
																"Password must be at least 8 characters",
															);
															return;
														}
														await client.twoFactor.getTotpUri(
															{
																password: twoFaPassword,
															},
															{
																onSuccess(context) {
																	setTwoFactorVerifyURI(context.data.totpURI);
																},
															},
														);
														setTwoFaPassword("");
													}}
												>
													Show QR Code
												</Button>
											</div>
										)}
									</DialogContent>
								</Dialog>
							)}
							<Dialog open={twoFactorDialog} onOpenChange={setTwoFactorDialog}>
								<DialogTrigger asChild>
									<Button
										variant={
											session?.user.twoFactorEnabled ? "destructive" : "outline"
										}
										className="gap-2"
									>
										{session?.user.twoFactorEnabled ? (
											<ShieldOff size={16} />
										) : (
											<ShieldCheck size={16} />
										)}
										<span className="md:text-sm text-xs">
											{session?.user.twoFactorEnabled
												? "Disable 2FA"
												: "Enable 2FA"}
										</span>
									</Button>
								</DialogTrigger>
								<DialogContent className="sm:max-w-[425px] w-11/12">
									<DialogHeader>
										<DialogTitle>
											{session?.user.twoFactorEnabled
												? "Disable 2FA"
												: "Enable 2FA"}
										</DialogTitle>
										<DialogDescription>
											{session?.user.twoFactorEnabled
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
											<PasswordInput
												id="password"
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
												if (twoFaPassword.length < 8 && !twoFactorVerifyURI) {
													toast.error("Password must be at least 8 characters");
													return;
												}
												setIsPendingTwoFa(true);
												if (session?.user.twoFactorEnabled) {
													const res = await client.twoFactor.disable({
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
														await client.twoFactor.verifyTotp({
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
													const res = await client.twoFactor.enable({
														password: twoFaPassword,
														fetchOptions: {
															onError(context) {
																toast.error(context.error.message);
															},
															onSuccess(ctx) {
																setTwoFactorVerifyURI(ctx.data.totpURI);
																// toast.success("2FA enabled successfully");
																// setTwoFactorDialog(false);
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
											) : session?.user.twoFactorEnabled ? (
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
				</div>
			</CardContent>
			<CardFooter className="gap-2 justify-between items-center">
				<ChangePassword />
				{session?.session.impersonatedBy ? (
					<Button
						className="gap-2 z-10"
						variant="secondary"
						onClick={async () => {
							setIsSignOut(true);
							await client.admin.stopImpersonating();
							setIsSignOut(false);
							toast.info("Impersonation stopped successfully");
							router.push("/admin");
						}}
						disabled={isSignOut}
					>
						<span className="text-sm">
							{isSignOut ? (
								<Loader2 size={15} className="animate-spin" />
							) : (
								<div className="flex items-center gap-2">
									<StopCircle size={16} color="red" />
									Stop Impersonation
								</div>
							)}
						</span>
					</Button>
				) : (
					<Button
						className="gap-2 z-10"
						variant="secondary"
						onClick={async () => {
							setIsSignOut(true);
							await signOut({
								fetchOptions: {
									onSuccess() {
										router.push("/");
									},
								},
							});
							setIsSignOut(false);
						}}
						disabled={isSignOut}
					>
						<span className="text-sm">
							{isSignOut ? (
								<Loader2 size={15} className="animate-spin" />
							) : (
								<div className="flex items-center gap-2">
									<LogOut size={16} />
									Sign Out
								</div>
							)}
						</span>
					</Button>
				)}
			</CardFooter>
		</Card>
	);
}

async function convertImageToBase64(file: File): Promise<string> {
	return new Promise((resolve, reject) => {
		const reader = new FileReader();
		reader.onloadend = () => resolve(reader.result as string);
		reader.onerror = reject;
		reader.readAsDataURL(file);
	});
}

function ChangePassword() {
	const [currentPassword, setCurrentPassword] = useState<string>("");
	const [newPassword, setNewPassword] = useState<string>("");
	const [confirmPassword, setConfirmPassword] = useState<string>("");
	const [loading, setLoading] = useState<boolean>(false);
	const [open, setOpen] = useState<boolean>(false);
	const [signOutDevices, setSignOutDevices] = useState<boolean>(false);
	return (
		<Dialog open={open} onOpenChange={setOpen}>
			<DialogTrigger asChild>
				<Button className="gap-2 z-10" variant="outline" size="sm">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						width="1em"
						height="1em"
						viewBox="0 0 24 24"
					>
						<path
							fill="currentColor"
							d="M2.5 18.5v-1h19v1zm.535-5.973l-.762-.442l.965-1.693h-1.93v-.884h1.93l-.965-1.642l.762-.443L4 9.066l.966-1.643l.761.443l-.965 1.642h1.93v.884h-1.93l.965 1.693l-.762.442L4 10.835zm8 0l-.762-.442l.966-1.693H9.308v-.884h1.93l-.965-1.642l.762-.443L12 9.066l.966-1.643l.761.443l-.965 1.642h1.93v.884h-1.93l.965 1.693l-.762.442L12 10.835zm8 0l-.762-.442l.966-1.693h-1.931v-.884h1.93l-.965-1.642l.762-.443L20 9.066l.966-1.643l.761.443l-.965 1.642h1.93v.884h-1.93l.965 1.693l-.762.442L20 10.835z"
						></path>
					</svg>
					<span className="text-sm text-muted-foreground">Change Password</span>
				</Button>
			</DialogTrigger>
			<DialogContent className="sm:max-w-[425px] w-11/12">
				<DialogHeader>
					<DialogTitle>Change Password</DialogTitle>
					<DialogDescription>Change your password</DialogDescription>
				</DialogHeader>
				<div className="grid gap-2">
					<Label htmlFor="current-password">Current Password</Label>
					<PasswordInput
						id="current-password"
						value={currentPassword}
						onChange={(e) => setCurrentPassword(e.target.value)}
						autoComplete="new-password"
						placeholder="Password"
					/>
					<Label htmlFor="new-password">New Password</Label>
					<PasswordInput
						value={newPassword}
						onChange={(e) => setNewPassword(e.target.value)}
						autoComplete="new-password"
						placeholder="New Password"
					/>
					<Label htmlFor="password">Confirm Password</Label>
					<PasswordInput
						value={confirmPassword}
						onChange={(e) => setConfirmPassword(e.target.value)}
						autoComplete="new-password"
						placeholder="Confirm Password"
					/>
					<div className="flex gap-2 items-center">
						<Checkbox
							onCheckedChange={(checked) =>
								checked ? setSignOutDevices(true) : setSignOutDevices(false)
							}
						/>
						<p className="text-sm">Sign out from other devices</p>
					</div>
				</div>
				<DialogFooter>
					<Button
						onClick={async () => {
							if (newPassword !== confirmPassword) {
								toast.error("Passwords do not match");
								return;
							}
							if (newPassword.length < 8) {
								toast.error("Password must be at least 8 characters");
								return;
							}
							setLoading(true);
							const res = await client.changePassword({
								newPassword: newPassword,
								currentPassword: currentPassword,
								revokeOtherSessions: signOutDevices,
							});
							setLoading(false);
							if (res.error) {
								toast.error(
									res.error.message ||
										"Couldn't change your password! Make sure it's correct",
								);
							} else {
								setOpen(false);
								toast.success("Password changed successfully");
								setCurrentPassword("");
								setNewPassword("");
								setConfirmPassword("");
							}
						}}
					>
						{loading ? (
							<Loader2 size={15} className="animate-spin" />
						) : (
							"Change Password"
						)}
					</Button>
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
}

function EditUserDialog() {
	const { data, isPending, error } = useSession();
	const [name, setName] = useState<string>();
	const router = useRouter();
	const [image, setImage] = useState<File | null>(null);
	const [imagePreview, setImagePreview] = useState<string | null>(null);
	const handleImageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
		const file = e.target.files?.[0];
		if (file) {
			setImage(file);
			const reader = new FileReader();
			reader.onloadend = () => {
				setImagePreview(reader.result as string);
			};
			reader.readAsDataURL(file);
		}
	};
	const [open, setOpen] = useState<boolean>(false);
	const [isLoading, setIsLoading] = useState<boolean>(false);
	return (
		<Dialog open={open} onOpenChange={setOpen}>
			<DialogTrigger asChild>
				<Button size="sm" className="gap-2" variant="secondary">
					<Edit size={13} />
					Edit User
				</Button>
			</DialogTrigger>
			<DialogContent className="sm:max-w-[425px] w-11/12">
				<DialogHeader>
					<DialogTitle>Edit User</DialogTitle>
					<DialogDescription>Edit user information</DialogDescription>
				</DialogHeader>
				<div className="grid gap-2">
					<Label htmlFor="name">Full Name</Label>
					<Input
						id="name"
						type="name"
						placeholder={data?.user.name}
						required
						onChange={(e) => {
							setName(e.target.value);
						}}
					/>
					<div className="grid gap-2">
						<Label htmlFor="image">Profile Image</Label>
						<div className="flex items-end gap-4">
							{imagePreview && (
								<div className="relative w-16 h-16 rounded-sm overflow-hidden">
									<Image
										src={imagePreview}
										alt="Profile preview"
										layout="fill"
										objectFit="cover"
									/>
								</div>
							)}
							<div className="flex items-center gap-2 w-full">
								<Input
									id="image"
									type="file"
									accept="image/*"
									onChange={handleImageChange}
									className="w-full text-muted-foreground"
								/>
								{imagePreview && (
									<X
										className="cursor-pointer"
										onClick={() => {
											setImage(null);
											setImagePreview(null);
										}}
									/>
								)}
							</div>
						</div>
					</div>
				</div>
				<DialogFooter>
					<Button
						disabled={isLoading}
						onClick={async () => {
							setIsLoading(true);
							await client.updateUser({
								image: image ? await convertImageToBase64(image) : undefined,
								name: name ? name : undefined,
								fetchOptions: {
									onSuccess: () => {
										toast.success("User updated successfully");
									},
									onError: (error) => {
										toast.error(error.error.message);
									},
								},
							});
							setName("");
							router.refresh();
							setImage(null);
							setImagePreview(null);
							setIsLoading(false);
							setOpen(false);
						}}
					>
						{isLoading ? (
							<Loader2 size={15} className="animate-spin" />
						) : (
							"Update"
						)}
					</Button>
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
}

function AddPasskey() {
	const [isOpen, setIsOpen] = useState(false);
	const [passkeyName, setPasskeyName] = useState("");
	const [isLoading, setIsLoading] = useState(false);

	const handleAddPasskey = async () => {
		if (!passkeyName) {
			toast.error("Passkey name is required");
			return;
		}
		setIsLoading(true);
		const res = await client.passkey.addPasskey({
			name: passkeyName,
		});
		if (res?.error) {
			toast.error(res?.error.message);
		} else {
			setIsOpen(false);
			toast.success("Passkey added successfully. You can now use it to login.");
		}
		setIsLoading(false);
	};
	return (
		<Dialog open={isOpen} onOpenChange={setIsOpen}>
			<DialogTrigger asChild>
				<Button variant="outline" className="gap-2 text-xs md:text-sm">
					<Plus size={15} />
					Add New Passkey
				</Button>
			</DialogTrigger>
			<DialogContent className="sm:max-w-[425px] w-11/12">
				<DialogHeader>
					<DialogTitle>Add New Passkey</DialogTitle>
					<DialogDescription>
						Create a new passkey to securely access your account without a
						password.
					</DialogDescription>
				</DialogHeader>
				<div className="grid gap-2">
					<Label htmlFor="passkey-name">Passkey Name</Label>
					<Input
						id="passkey-name"
						value={passkeyName}
						onChange={(e) => setPasskeyName(e.target.value)}
					/>
				</div>
				<DialogFooter>
					<Button
						disabled={isLoading}
						type="submit"
						onClick={handleAddPasskey}
						className="w-full"
					>
						{isLoading ? (
							<Loader2 size={15} className="animate-spin" />
						) : (
							<>
								<Fingerprint className="mr-2 h-4 w-4" />
								Create Passkey
							</>
						)}
					</Button>
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
}

function ListPasskeys() {
	const { data } = client.useListPasskeys();
	const [isOpen, setIsOpen] = useState(false);
	const [passkeyName, setPasskeyName] = useState("");

	const handleAddPasskey = async () => {
		if (!passkeyName) {
			toast.error("Passkey name is required");
			return;
		}
		setIsLoading(true);
		const res = await client.passkey.addPasskey({
			name: passkeyName,
		});
		setIsLoading(false);
		if (res?.error) {
			toast.error(res?.error.message);
		} else {
			toast.success("Passkey added successfully. You can now use it to login.");
		}
	};
	const [isLoading, setIsLoading] = useState(false);
	const [isDeletePasskey, setIsDeletePasskey] = useState<boolean>(false);
	return (
		<Dialog open={isOpen} onOpenChange={setIsOpen}>
			<DialogTrigger asChild>
				<Button variant="outline" className="text-xs md:text-sm">
					<Fingerprint className="mr-2 h-4 w-4" />
					<span>Passkeys {data?.length ? `[${data?.length}]` : ""}</span>
				</Button>
			</DialogTrigger>
			<DialogContent className="sm:max-w-[425px] w-11/12">
				<DialogHeader>
					<DialogTitle>Passkeys</DialogTitle>
					<DialogDescription>List of passkeys</DialogDescription>
				</DialogHeader>
				{data?.length ? (
					<Table>
						<TableHeader>
							<TableRow>
								<TableHead>Name</TableHead>
							</TableRow>
						</TableHeader>
						<TableBody>
							{data.map((passkey) => (
								<TableRow
									key={passkey.id}
									className="flex  justify-between items-center"
								>
									<TableCell>{passkey.name || "My Passkey"}</TableCell>
									<TableCell className="text-right">
										<button
											onClick={async () => {
												const res = await client.passkey.deletePasskey({
													id: passkey.id,
													fetchOptions: {
														onRequest: () => {
															setIsDeletePasskey(true);
														},
														onSuccess: () => {
															toast("Passkey deleted successfully");
															setIsDeletePasskey(false);
														},
														onError: (error) => {
															toast.error(error.error.message);
															setIsDeletePasskey(false);
														},
													},
												});
											}}
										>
											{isDeletePasskey ? (
												<Loader2 size={15} className="animate-spin" />
											) : (
												<Trash
													size={15}
													className="cursor-pointer text-red-600"
												/>
											)}
										</button>
									</TableCell>
								</TableRow>
							))}
						</TableBody>
					</Table>
				) : (
					<p className="text-sm text-muted-foreground">No passkeys found</p>
				)}
				{!data?.length && (
					<div className="flex flex-col gap-2">
						<div className="flex flex-col gap-2">
							<Label htmlFor="passkey-name" className="text-sm">
								New Passkey
							</Label>
							<Input
								id="passkey-name"
								value={passkeyName}
								onChange={(e) => setPasskeyName(e.target.value)}
								placeholder="My Passkey"
							/>
						</div>
						<Button type="submit" onClick={handleAddPasskey} className="w-full">
							{isLoading ? (
								<Loader2 size={15} className="animate-spin" />
							) : (
								<>
									<Fingerprint className="mr-2 h-4 w-4" />
									Create Passkey
								</>
							)}
						</Button>
					</div>
				)}
				<DialogFooter>
					<Button onClick={() => setIsOpen(false)}>Close</Button>
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
}

```
