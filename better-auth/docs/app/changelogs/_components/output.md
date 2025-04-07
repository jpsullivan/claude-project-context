/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/changelogs/_components/_layout.tsx
```
import { useId } from "react";

import { Intro, IntroFooter } from "./changelog-layout";
import { StarField } from "./stat-field";

function Timeline() {
	let id = useId();

	return (
		<div className="pointer-events-none absolute inset-0 z-50 overflow-hidden lg:right-[calc(max(2rem,50%-38rem)+40rem)] lg:min-w-[32rem] lg:overflow-visible">
			<svg
				className="absolute left-[max(0px,calc(50%-18.125rem))] top-0 h-full w-1.5 lg:left-full lg:ml-1 xl:left-auto xl:right-1 xl:ml-0"
				aria-hidden="true"
			>
				<defs>
					<pattern id={id} width="6" height="8" patternUnits="userSpaceOnUse">
						<path
							d="M0 0H6M0 8H6"
							className="stroke-sky-900/10 xl:stroke-white/10 dark:stroke-white/10"
							fill="none"
						/>
					</pattern>
				</defs>
				<rect width="100%" height="100%" fill={`url(#${id})`} />
			</svg>
			someone is
		</div>
	);
}

function Glow() {
	let id = useId();

	return (
		<div className="absolute inset-0  overflow-hidden  lg:right-[calc(max(2rem,50%-38rem)+40rem)] lg:min-w-[32rem]">
			<svg
				className="absolute -bottom-48 left-[-40%] h-[80rem] w-[180%] lg:-right-40 lg:bottom-auto lg:left-auto lg:top-[-40%] lg:h-[180%] lg:w-[80rem]"
				aria-hidden="true"
			>
				<defs>
					<radialGradient id={`${id}-desktop`} cx="100%">
						<stop offset="0%" stopColor="rgba(214, 211, 209, 0.6)" />
						<stop offset="53.95%" stopColor="rgba(214, 200, 209, 0.09)" />
						<stop offset="100%" stopColor="rgba(10, 14, 23, 0)" />
					</radialGradient>
					<radialGradient id={`${id}-mobile`} cy="100%">
						<stop offset="0%" stopColor="rgba(56, 189, 248, 0.3)" />
						<stop offset="53.95%" stopColor="rgba(0, 71, 255, 0.09)" />
						<stop offset="100%" stopColor="rgba(10, 14, 23, 0)" />
					</radialGradient>
				</defs>
				<rect
					width="100%"
					height="100%"
					fill={`url(#${id}-desktop)`}
					className="hidden lg:block"
				/>
				<rect
					width="100%"
					height="100%"
					fill={`url(#${id}-mobile)`}
					className="lg:hidden"
				/>
			</svg>
			<div className="absolute inset-x-0 bottom-0 right-0 h-px bg-white mix-blend-overlay lg:left-auto lg:top-0 lg:h-auto lg:w-px" />
		</div>
	);
}

function FixedSidebar({
	main,
	footer,
}: {
	main: React.ReactNode;
	footer: React.ReactNode;
}) {
	return (
		<div className="relative   flex-none overflow-hidden px-10 lg:pointer-events-none lg:fixed lg:inset-0 lg:z-40 lg:flex lg:px-0">
			<Glow />
			<div className="relative flex w-full lg:pointer-events-auto lg:mr-[calc(max(2rem,50%-35rem)+40rem)] lg:min-w-[32rem] lg:overflow-y-auto lg:overflow-x-hidden lg:pl-[max(4rem,calc(50%-38rem))]">
				<div className="mx-auto max-w-lg lg:mx-auto  lg:flex  lg:max-w-4xl  lg:flex-col lg:before:flex-1 lg:before:pt-6">
					<div className="pb-16  pt-20 sm:pb-20 sm:pt-32 lg:py-20">
						<div className="relative pr-10">
							<StarField className="-right-44 top-14" />
							{main}
						</div>
					</div>
					<div className="flex flex-1 items-end justify-center pb-4 lg:justify-start lg:pb-6">
						{footer}
					</div>
				</div>
			</div>
		</div>
	);
}

export function Layout({ children }: { children: React.ReactNode }) {
	return (
		<>
			<FixedSidebar main={<Intro />} footer={<IntroFooter />} />
			<div />
			<div className="relative flex-auto">
				<Timeline />
				<main className="grid grid-cols-12 col-span-5 ml-auto space-y-20 py-20 sm:space-y-32 sm:py-32">
					{children}
				</main>
			</div>
		</>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/changelogs/_components/changelog-layout.tsx
```
import Link from "next/link";
import { useId } from "react";

import clsx from "clsx";
import { DiscordLogoIcon } from "@radix-ui/react-icons";

function BookIcon(props: React.ComponentPropsWithoutRef<"svg">) {
	return (
		<svg viewBox="0 0 16 16" aria-hidden="true" fill="currentColor" {...props}>
			<path d="M7 3.41a1 1 0 0 0-.668-.943L2.275 1.039a.987.987 0 0 0-.877.166c-.25.192-.398.493-.398.812V12.2c0 .454.296.853.725.977l3.948 1.365A1 1 0 0 0 7 13.596V3.41ZM9 13.596a1 1 0 0 0 1.327.946l3.948-1.365c.429-.124.725-.523.725-.977V2.017c0-.32-.147-.62-.398-.812a.987.987 0 0 0-.877-.166L9.668 2.467A1 1 0 0 0 9 3.41v10.186Z" />
		</svg>
	);
}

function GitHubIcon(props: React.ComponentPropsWithoutRef<"svg">) {
	return (
		<svg viewBox="0 0 16 16" aria-hidden="true" fill="currentColor" {...props}>
			<path d="M8 .198a8 8 0 0 0-8 8 7.999 7.999 0 0 0 5.47 7.59c.4.076.547-.172.547-.384 0-.19-.007-.694-.01-1.36-2.226.482-2.695-1.074-2.695-1.074-.364-.923-.89-1.17-.89-1.17-.725-.496.056-.486.056-.486.803.056 1.225.824 1.225.824.714 1.224 1.873.87 2.33.666.072-.518.278-.87.507-1.07-1.777-.2-3.644-.888-3.644-3.954 0-.873.31-1.586.823-2.146-.09-.202-.36-1.016.07-2.118 0 0 .67-.214 2.2.82a7.67 7.67 0 0 1 2-.27 7.67 7.67 0 0 1 2 .27c1.52-1.034 2.19-.82 2.19-.82.43 1.102.16 1.916.08 2.118.51.56.82 1.273.82 2.146 0 3.074-1.87 3.75-3.65 3.947.28.24.54.73.54 1.48 0 1.07-.01 1.93-.01 2.19 0 .21.14.46.55.38A7.972 7.972 0 0 0 16 8.199a8 8 0 0 0-8-8Z" />
		</svg>
	);
}

function FeedIcon(props: React.ComponentPropsWithoutRef<"svg">) {
	return (
		<svg viewBox="0 0 16 16" aria-hidden="true" fill="currentColor" {...props}>
			<path
				fillRule="evenodd"
				clipRule="evenodd"
				d="M2.5 3a.5.5 0 0 1 .5-.5h.5c5.523 0 10 4.477 10 10v.5a.5.5 0 0 1-.5.5h-.5a.5.5 0 0 1-.5-.5v-.5A8.5 8.5 0 0 0 3.5 4H3a.5.5 0 0 1-.5-.5V3Zm0 4.5A.5.5 0 0 1 3 7h.5A5.5 5.5 0 0 1 9 12.5v.5a.5.5 0 0 1-.5.5H8a.5.5 0 0 1-.5-.5v-.5a4 4 0 0 0-4-4H3a.5.5 0 0 1-.5-.5v-.5Zm0 5a1 1 0 1 1 2 0 1 1 0 0 1-2 0Z"
			/>
		</svg>
	);
}

function XIcon(props: React.ComponentPropsWithoutRef<"svg">) {
	return (
		<svg viewBox="0 0 16 16" aria-hidden="true" fill="currentColor" {...props}>
			<path d="M9.51762 6.77491L15.3459 0H13.9648L8.90409 5.88256L4.86212 0H0.200195L6.31244 8.89547L0.200195 16H1.58139L6.92562 9.78782L11.1942 16H15.8562L9.51728 6.77491H9.51762ZM7.62588 8.97384L7.00658 8.08805L2.07905 1.03974H4.20049L8.17706 6.72795L8.79636 7.61374L13.9654 15.0075H11.844L7.62588 8.97418V8.97384Z" />
		</svg>
	);
}

export function Intro() {
	return (
		<>
			<h1 className="mt-14  font-sans  font-semibold tracking-tighter text-5xl">
				All of the changes made will be{" "}
				<span className="">available here.</span>
			</h1>
			<p className="mt-4 text-sm text-gray-600 dark:text-gray-300">
				Better Auth is comprehensive authentication library for TypeScript that
				provides a wide range of features to make authentication easier and more
				secure.
			</p>
			<hr className="h-px bg-gray-300 mt-5" />
			<div className="mt-8 flex flex-wrap text-gray-600 dark:text-gray-300  justify-center gap-x-1 gap-y-3 sm:gap-x-2 lg:justify-start">
				<IconLink
					href="/docs"
					icon={BookIcon}
					className="flex-none text-gray-600 dark:text-gray-300"
				>
					Documentation
				</IconLink>
				<IconLink
					href="https://github.com/better-auth/better-auth"
					icon={GitHubIcon}
					className="flex-none text-gray-600 dark:text-gray-300"
				>
					GitHub
				</IconLink>
				<IconLink
					href="https://discord.com/better-auth"
					icon={DiscordLogoIcon}
					className="flex-none text-gray-600 dark:text-gray-300"
				>
					Community
				</IconLink>
			</div>
		</>
	);
}

export function IntroFooter() {
	return (
		<p className="flex items-baseline gap-x-2 text-[0.8125rem]/6 text-gray-500">
			Brought to you by{" "}
			<IconLink href="#" icon={XIcon} compact>
				BETTER-AUTH.
			</IconLink>
		</p>
	);
}

export function SignUpForm() {
	let id = useId();

	return (
		<form className="relative isolate mt-8 flex items-center pr-1">
			<label htmlFor={id} className="sr-only">
				Email address
			</label>

			<div className="absolute inset-0 -z-10 rounded-lg transition peer-focus:ring-4 peer-focus:ring-sky-300/15" />
			<div className="absolute inset-0 -z-10 rounded-lg bg-white/2.5 ring-1 ring-white/15 transition peer-focus:ring-sky-300" />
		</form>
	);
}

export function IconLink({
	children,
	className,
	compact = false,
	icon: Icon,
	...props
}: React.ComponentPropsWithoutRef<typeof Link> & {
	compact?: boolean;
	icon?: React.ComponentType<{ className?: string }>;
}) {
	return (
		<Link
			{...props}
			className={clsx(
				className,
				"group relative isolate flex items-center px-2 py-0.5 text-[0.8125rem]/6 font-medium text-black/70 dark:text-white/30 transition-colors hover:text-stone-300 rounded-none",
				compact ? "gap-x-2" : "gap-x-3",
			)}
		>
			<span className="absolute inset-0 -z-10 scale-75 rounded-lg bg-white/5 opacity-0 transition group-hover:scale-100 group-hover:opacity-100" />
			{Icon && <Icon className="h-4 w-4 flex-none" />}
			<span className="self-baseline text-black/70 dark:text-white">
				{children}
			</span>
		</Link>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/changelogs/_components/default-changelog.tsx
```
import Link from "next/link";
import { useId } from "react";
import { cn } from "@/lib/utils";
import { IconLink } from "./changelog-layout";
import { BookIcon, GitHubIcon, XIcon } from "./icons";
import { DiscordLogoIcon } from "@radix-ui/react-icons";
import { StarField } from "./stat-field";
import { betterFetch } from "@better-fetch/fetch";
import Markdown from "react-markdown";
import defaultMdxComponents from "fumadocs-ui/mdx";
import rehypeHighlight from "rehype-highlight";
import "highlight.js/styles/dark.css";

export const dynamic = "force-static";
const ChangelogPage = async () => {
	const { data: releases } = await betterFetch<
		{
			id: number;
			tag_name: string;
			name: string;
			body: string;
			html_url: string;
			prerelease: boolean;
			published_at: string;
		}[]
	>("https://api.github.com/repos/better-auth/better-auth/releases");

	const messages = releases
		?.filter((release) => !release.prerelease)
		.map((release) => ({
			tag: release.tag_name,
			title: release.name,
			content: getContent(release.body),
			date: new Date(release.published_at).toLocaleDateString("en-US", {
				year: "numeric",
				month: "short",
				day: "numeric",
			}),
			url: release.html_url,
		}));

	function getContent(content: string) {
		const lines = content.split("\n");
		const newContext = lines.map((line) => {
			if (line.startsWith("- ")) {
				const mainContent = line.split(";")[0];
				const context = line.split(";")[2];
				const mentions = context
					?.split(" ")
					.filter((word) => word.startsWith("@"))
					.map((mention) => {
						const username = mention.replace("@", "");
						const avatarUrl = `https://github.com/${username}.png`;
						return `[![${mention}](${avatarUrl})](https://github.com/${username})`;
					});
				if (!mentions) {
					return line;
				}
				// Remove &nbsp
				return mainContent.replace(/&nbsp/g, "") + " – " + mentions.join(" ");
			}
			return line;
		});
		return newContext.join("\n");
	}

	return (
		<div className="grid md:grid-cols-2 items-start">
			<div className="bg-gradient-to-tr overflow-hidden px-12 py-24 md:py-0 -mt-[100px] md:h-dvh relative md:sticky top-0 from-transparent dark:via-stone-950/5 via-stone-100/30 to-stone-200/20 dark:to-transparent/10">
				<StarField className="top-1/2 -translate-y-1/2 left-1/2 -translate-x-1/2" />
				<Glow />

				<div className="flex flex-col md:justify-center max-w-xl mx-auto h-full">
					<h1 className="mt-14 font-sans font-semibold tracking-tighter text-5xl">
						All of the changes made will be{" "}
						<span className="">available here.</span>
					</h1>
					<p className="mt-4 text-sm text-gray-600 dark:text-gray-300">
						Better Auth is comprehensive authentication library for TypeScript
						that provides a wide range of features to make authentication easier
						and more secure.
					</p>
					<hr className="h-px bg-gray-300 mt-5" />
					<div className="mt-8 flex flex-wrap text-gray-600 dark:text-gray-300 gap-x-1 gap-y-3 sm:gap-x-2">
						<IconLink
							href="/docs"
							icon={BookIcon}
							className="flex-none text-gray-600 dark:text-gray-300"
						>
							Documentation
						</IconLink>
						<IconLink
							href="https://github.com/better-auth/better-auth"
							icon={GitHubIcon}
							className="flex-none text-gray-600 dark:text-gray-300"
						>
							GitHub
						</IconLink>
						<IconLink
							href="https://discord.com/better-auth"
							icon={DiscordLogoIcon}
							className="flex-none text-gray-600 dark:text-gray-300"
						>
							Community
						</IconLink>
					</div>
					<p className="flex items-baseline absolute bottom-4 max-md:left-1/2 max-md:-translate-x-1/2 gap-x-2 text-[0.8125rem]/6 text-gray-500">
						<IconLink href="https://x.com/better_auth" icon={XIcon} compact>
							BETTER-AUTH.
						</IconLink>
					</p>
				</div>
			</div>
			<div className="px-4 relative md:px-8 pb-12 md:py-12">
				<div className="absolute top-0 left-0 mb-2 w-2 h-full -translate-x-full bg-gradient-to-b from-black/10 dark:from-white/20 from-50% to-50% to-transparent bg-[length:100%_5px] bg-repeat-y"></div>

				<div className="max-w-2xl relative">
					<Markdown
						rehypePlugins={[[rehypeHighlight]]}
						components={{
							pre: (props) => (
								<defaultMdxComponents.pre
									{...props}
									className={cn(props.className, " ml-10 my-2")}
								/>
							),
							h2: (props) => (
								<h2
									id={props.children?.toString().split("date=")[0].trim()} // Extract ID dynamically
									className="text-2xl relative mb-6 font-bold flex-col flex justify-center tracking-tighter before:content-[''] before:block before:h-[65px] before:-mt-[10px]"
									{...props}
								>
									<div className="sticky top-0 left-[-9.9rem] hidden md:block">
										<time className="flex gap-2 items-center text-gray-500 dark:text-white/80 text-sm md:absolute md:left-[-9.8rem] font-normal tracking-normal">
											{props.children?.toString().includes("date=") &&
												props.children?.toString().split("date=")[1]}

											<div className="w-4 h-[1px] dark:bg-white/60 bg-black" />
										</time>
									</div>
									<Link
										href={
											props.children
												?.toString()
												.split("date=")[0]
												.trim()
												.endsWith(".00")
												? `/changelogs/${props.children
														?.toString()
														.split("date=")[0]
														.trim()}`
												: `#${props.children
														?.toString()
														.split("date=")[0]
														.trim()}`
										}
									>
										{props.children?.toString().split("date=")[0].trim()}
									</Link>
									<p className="text-xs font-normal opacity-60 hidden">
										{props.children?.toString().includes("date=") &&
											props.children?.toString().split("date=")[1]}
									</p>
								</h2>
							),
							h3: (props) => (
								<h3 className="text-xl tracking-tighter py-1" {...props}>
									{props.children?.toString()?.trim()}
									<hr className="h-[1px] my-1 mb-2 bg-input" />
								</h3>
							),
							p: (props) => <p className="my-0 ml-10 text-sm" {...props} />,
							ul: (props) => (
								<ul
									className="list-disc ml-10 text-[0.855rem] text-gray-600 dark:text-gray-300"
									{...props}
								/>
							),
							li: (props) => <li className="my-1" {...props} />,
							a: ({ className, ...props }: any) => (
								<Link
									target="_blank"
									className={cn("font-medium underline", className)}
									{...props}
								/>
							),
							strong: (props) => (
								<strong className="font-semibold" {...props} />
							),
							img: (props) => (
								<img
									className="rounded-full w-6 h-6 border opacity-70 inline-block"
									{...props}
									style={{ maxWidth: "100%" }}
								/>
							),
						}}
					>
						{messages
							?.map((message) => {
								return `
## ${message.title} date=${message.date}

${message.content}
								`;
							})
							.join("\n")}
					</Markdown>
				</div>
			</div>
		</div>
	);
};

export default ChangelogPage;

export function Glow() {
	let id = useId();

	return (
		<div className="absolute inset-0 -z-10 overflow-hidden bg-gradient-to-tr from-transparent dark:via-stone-950/5 via-stone-100/30 to-stone-200/20 dark:to-transparent/10">
			<svg
				className="absolute -bottom-48 left-[-40%] h-[80rem] w-[180%] lg:-right-40 lg:bottom-auto lg:left-auto lg:top-[-40%] lg:h-[180%] lg:w-[80rem]"
				aria-hidden="true"
			>
				<defs>
					<radialGradient id={`${id}-desktop`} cx="100%">
						<stop offset="0%" stopColor="rgba(41, 37, 36, 0.4)" />
						<stop offset="53.95%" stopColor="rgba(28, 25, 23, 0.09)" />
						<stop offset="100%" stopColor="rgba(0, 0, 0, 0)" />
					</radialGradient>
					<radialGradient id={`${id}-mobile`} cy="100%">
						<stop offset="0%" stopColor="rgba(41, 37, 36, 0.3)" />
						<stop offset="53.95%" stopColor="rgba(28, 25, 23, 0.09)" />
						<stop offset="100%" stopColor="rgba(0, 0, 0, 0)" />
					</radialGradient>
				</defs>
				<rect
					width="100%"
					height="100%"
					fill={`url(#${id}-desktop)`}
					className="hidden lg:block"
				/>
				<rect
					width="100%"
					height="100%"
					fill={`url(#${id}-mobile)`}
					className="lg:hidden"
				/>
			</svg>
			<div className="absolute inset-x-0 bottom-0 right-0 h-px dark:bg-white/5 mix-blend-overlay lg:left-auto lg:top-0 lg:h-auto lg:w-px" />
		</div>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/changelogs/_components/fmt-dates.tsx
```
import { cn } from "@/lib/utils";

const dateFormatter = new Intl.DateTimeFormat("en-US", {
	year: "numeric",
	month: "short",
	day: "numeric",
	timeZone: "UTC",
});

export function FormattedDate({
	date,
	...props
}: React.ComponentPropsWithoutRef<"time"> & { date: string | Date }) {
	date = typeof date === "string" ? new Date(date) : date;

	return (
		<time
			className={cn(props.className, "")}
			dateTime={date.toISOString()}
			{...props}
		>
			{dateFormatter.format(date)}
		</time>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/changelogs/_components/icons.tsx
```
export function BookIcon(props: React.ComponentPropsWithoutRef<"svg">) {
	return (
		<svg viewBox="0 0 16 16" aria-hidden="true" fill="currentColor" {...props}>
			<path d="M7 3.41a1 1 0 0 0-.668-.943L2.275 1.039a.987.987 0 0 0-.877.166c-.25.192-.398.493-.398.812V12.2c0 .454.296.853.725.977l3.948 1.365A1 1 0 0 0 7 13.596V3.41ZM9 13.596a1 1 0 0 0 1.327.946l3.948-1.365c.429-.124.725-.523.725-.977V2.017c0-.32-.147-.62-.398-.812a.987.987 0 0 0-.877-.166L9.668 2.467A1 1 0 0 0 9 3.41v10.186Z" />
		</svg>
	);
}

export function GitHubIcon(props: React.ComponentPropsWithoutRef<"svg">) {
	return (
		<svg viewBox="0 0 16 16" aria-hidden="true" fill="currentColor" {...props}>
			<path d="M8 .198a8 8 0 0 0-8 8 7.999 7.999 0 0 0 5.47 7.59c.4.076.547-.172.547-.384 0-.19-.007-.694-.01-1.36-2.226.482-2.695-1.074-2.695-1.074-.364-.923-.89-1.17-.89-1.17-.725-.496.056-.486.056-.486.803.056 1.225.824 1.225.824.714 1.224 1.873.87 2.33.666.072-.518.278-.87.507-1.07-1.777-.2-3.644-.888-3.644-3.954 0-.873.31-1.586.823-2.146-.09-.202-.36-1.016.07-2.118 0 0 .67-.214 2.2.82a7.67 7.67 0 0 1 2-.27 7.67 7.67 0 0 1 2 .27c1.52-1.034 2.19-.82 2.19-.82.43 1.102.16 1.916.08 2.118.51.56.82 1.273.82 2.146 0 3.074-1.87 3.75-3.65 3.947.28.24.54.73.54 1.48 0 1.07-.01 1.93-.01 2.19 0 .21.14.46.55.38A7.972 7.972 0 0 0 16 8.199a8 8 0 0 0-8-8Z" />
		</svg>
	);
}

export function FeedIcon(props: React.ComponentPropsWithoutRef<"svg">) {
	return (
		<svg viewBox="0 0 16 16" aria-hidden="true" fill="currentColor" {...props}>
			<path
				fillRule="evenodd"
				clipRule="evenodd"
				d="M2.5 3a.5.5 0 0 1 .5-.5h.5c5.523 0 10 4.477 10 10v.5a.5.5 0 0 1-.5.5h-.5a.5.5 0 0 1-.5-.5v-.5A8.5 8.5 0 0 0 3.5 4H3a.5.5 0 0 1-.5-.5V3Zm0 4.5A.5.5 0 0 1 3 7h.5A5.5 5.5 0 0 1 9 12.5v.5a.5.5 0 0 1-.5.5H8a.5.5 0 0 1-.5-.5v-.5a4 4 0 0 0-4-4H3a.5.5 0 0 1-.5-.5v-.5Zm0 5a1 1 0 1 1 2 0 1 1 0 0 1-2 0Z"
			/>
		</svg>
	);
}

export function XIcon(props: React.ComponentPropsWithoutRef<"svg">) {
	return (
		<svg viewBox="0 0 16 16" aria-hidden="true" fill="currentColor" {...props}>
			<path d="M9.51762 6.77491L15.3459 0H13.9648L8.90409 5.88256L4.86212 0H0.200195L6.31244 8.89547L0.200195 16H1.58139L6.92562 9.78782L11.1942 16H15.8562L9.51728 6.77491H9.51762ZM7.62588 8.97384L7.00658 8.08805L2.07905 1.03974H4.20049L8.17706 6.72795L8.79636 7.61374L13.9654 15.0075H11.844L7.62588 8.97418V8.97384Z" />
		</svg>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/changelogs/_components/stat-field.tsx
```
"use client";

import { useEffect, useId, useRef } from "react";
import clsx from "clsx";
import { animate, Segment } from "motion/react";

type Star = [x: number, y: number, dim?: boolean, blur?: boolean];

const stars: Array<Star> = [
	[4, 4, true, true],
	[4, 44, true],
	[36, 22],
	[50, 146, true, true],
	[64, 43, true, true],
	[76, 30, true],
	[101, 116],
	[140, 36, true],
	[149, 134],
	[162, 74, true],
	[171, 96, true, true],
	[210, 56, true, true],
	[235, 90],
	[275, 82, true, true],
	[306, 6],
	[307, 64, true, true],
	[380, 68, true],
	[380, 108, true, true],
	[391, 148, true, true],
	[405, 18, true],
	[412, 86, true, true],
	[426, 210, true, true],
	[427, 56, true, true],
	[538, 138],
	[563, 88, true, true],
	[611, 154, true, true],
	[637, 150],
	[651, 146, true],
	[682, 70, true, true],
	[683, 128],
	[781, 82, true, true],
	[785, 158, true],
	[832, 146, true, true],
	[852, 89],
];

const constellations: Array<Array<Star>> = [
	[
		[247, 103],
		[261, 86],
		[307, 104],
		[357, 36],
	],
	[
		[586, 120],
		[516, 100],
		[491, 62],
		[440, 107],
		[477, 180],
		[516, 100],
	],
	[
		[733, 100],
		[803, 120],
		[879, 113],
		[823, 164],
		[803, 120],
	],
];

function Star({
	blurId,
	point: [cx, cy, dim, blur],
}: {
	blurId: string;
	point: Star;
}) {
	let groupRef = useRef<React.ElementRef<"g">>(null);
	let ref = useRef<React.ElementRef<"circle">>(null);

	useEffect(() => {
		if (!groupRef.current || !ref.current) {
			return;
		}

		let delay = Math.random() * 2;

		let animations = [
			animate(groupRef.current, { opacity: 1 }, { duration: 4, delay }),
			animate(
				ref.current,
				{
					opacity: dim ? [0.2, 0.5] : [1, 0.6],
					scale: dim ? [1, 1.2] : [1.2, 1],
				},
				{
					duration: 10,
					delay,
				},
			),
		];

		return () => {
			for (let animation of animations) {
				animation.cancel();
			}
		};
	}, [dim]);

	return (
		<g ref={groupRef} className="opacity-0">
			<circle
				ref={ref}
				cx={cx}
				cy={cy}
				r={1}
				style={{
					transformOrigin: `${cx / 16}rem ${cy / 16}rem`,
					opacity: dim ? 0.2 : 1,
					transform: `scale(${dim ? 1 : 1.2})`,
				}}
				filter={blur ? `url(#${blurId})` : undefined}
			/>
		</g>
	);
}

function Constellation({
	points,
	blurId,
}: {
	points: Array<Star>;
	blurId: string;
}) {
	let ref = useRef<React.ElementRef<"path">>(null);
	let uniquePoints = points.filter(
		(point, pointIndex) =>
			points.findIndex((p) => String(p) === String(point)) === pointIndex,
	);
	let isFilled = uniquePoints.length !== points.length;

	useEffect(() => {
		if (!ref.current) {
			return;
		}

		let sequence: Array<Segment> = [
			[
				ref.current,
				{ strokeDashoffset: 0, visibility: "visible" },
				{ duration: 5, delay: Math.random() * 3 + 2 },
			],
		];

		if (isFilled) {
			sequence.push([
				ref.current,
				{ fill: "rgb(255 255 255 / 0.02)" },
				{ duration: 1 },
			]);
		}

		let animation = animate(sequence);

		return () => {
			animation.cancel();
		};
	}, [isFilled]);

	return (
		<>
			<path
				ref={ref}
				stroke="white"
				strokeOpacity="0.2"
				strokeDasharray={1}
				strokeDashoffset={1}
				pathLength={1}
				fill="transparent"
				d={`M ${points.join("L")}`}
				className="invisible"
			/>
			{uniquePoints.map((point, pointIndex) => (
				<Star key={pointIndex} point={point} blurId={blurId} />
			))}
		</>
	);
}

export function StarField({ className }: { className?: string }) {
	let blurId = useId();

	return (
		<svg
			viewBox="0 0 881 211"
			fill="white"
			aria-hidden="true"
			className={clsx(
				"pointer-events-none absolute w-[55.0625rem] origin-top-right rotate-[30deg] overflow-visible opacity-70",
				className,
			)}
		>
			<defs>
				<filter id={blurId}>
					<feGaussianBlur in="SourceGraphic" stdDeviation=".5" />
				</filter>
			</defs>
			{constellations.map((points, constellationIndex) => (
				<Constellation
					key={constellationIndex}
					points={points}
					blurId={blurId}
				/>
			))}
			{stars.map((point, pointIndex) => (
				<Star key={pointIndex} point={point} blurId={blurId} />
			))}
		</svg>
	);
}

```
