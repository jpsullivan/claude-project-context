/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/global.css
```css
@import "tailwindcss";
@config "../tailwind.config.js";
@plugin 'tailwindcss-animate';
@custom-variant dark (&:is(.dark *));
@import "fumadocs-ui/css/black.css";
@import "fumadocs-ui/css/preset.css";
@source '../../node_modules/fumadocs-ui/dist/**/*.js';
@source '../node_modules/fumadocs-ui/dist/**/*.js';
:root {
	--fd-nav-height: 57px;

	--background: oklch(1 0 0);

	--foreground: oklch(0.147 0.004 49.25);

	--card: oklch(1 0 0);

	--card-foreground: oklch(0.147 0.004 49.25);

	--popover: oklch(1 0 0);

	--popover-foreground: oklch(0.147 0.004 49.25);

	--primary: oklch(0.216 0.006 56.043);

	--primary-foreground: oklch(0.985 0.001 106.423);

	--secondary: oklch(0.97 0.001 106.424);

	--secondary-foreground: oklch(0.216 0.006 56.043);

	--muted: oklch(0.97 0.001 106.424);

	--muted-foreground: oklch(0.553 0.013 58.071);

	--accent: oklch(0.97 0.001 106.424);

	--accent-foreground: oklch(0.216 0.006 56.043);

	--destructive: oklch(0.577 0.245 27.325);

	--destructive-foreground: oklch(0.577 0.245 27.325);

	--border: oklch(0.923 0.003 48.717);

	--input: oklch(0.923 0.003 48.717);

	--ring: oklch(0.709 0.01 56.259);

	--chart-1: oklch(0.646 0.222 41.116);

	--chart-2: oklch(0.6 0.118 184.704);

	--chart-3: oklch(0.398 0.07 227.392);

	--chart-4: oklch(0.828 0.189 84.429);

	--chart-5: oklch(0.769 0.188 70.08);

	--radius: 0.2rem;

	--sidebar: oklch(0.985 0.001 106.423);

	--sidebar-foreground: oklch(0.147 0.004 49.25);

	--sidebar-primary: oklch(0.216 0.006 56.043);

	--sidebar-primary-foreground: oklch(0.985 0.001 106.423);

	--sidebar-accent: oklch(0.97 0.001 106.424);

	--sidebar-accent-foreground: oklch(0.216 0.006 56.043);

	--sidebar-border: oklch(0.923 0.003 48.717);

	--sidebar-ring: oklch(0.709 0.01 56.259);
}

.dark {
	--background: hsl(0 0% 2%);

	--foreground: oklch(0.985 0.001 106.423);

	--card: oklch(0.147 0.004 49.25);

	--card-foreground: oklch(0.985 0.001 106.423);

	--popover: oklch(0.147 0.004 49.25);

	--popover-foreground: oklch(0.985 0.001 106.423);

	--primary: oklch(0.985 0.001 106.423);

	--primary-foreground: oklch(0.216 0.006 56.043);

	--secondary: oklch(0.268 0.007 34.298);

	--secondary-foreground: oklch(0.985 0.001 106.423);

	--muted: oklch(0.268 0.007 34.298);

	--muted-foreground: oklch(0.709 0.01 56.259);

	--accent: oklch(0.268 0.007 34.298);

	--accent-foreground: oklch(0.985 0.001 106.423);

	--destructive: oklch(0.396 0.141 25.723);

	--destructive-foreground: oklch(0.637 0.237 25.331);

	--border: oklch(0.268 0.007 34.298);

	--input: oklch(0.268 0.007 34.298);

	--ring: oklch(0.553 0.013 58.071);

	--chart-1: oklch(0.488 0.243 264.376);

	--chart-2: oklch(0.696 0.17 162.48);

	--chart-3: oklch(0.769 0.188 70.08);

	--chart-4: oklch(0.627 0.265 303.9);

	--chart-5: oklch(0.645 0.246 16.439);

	--sidebar: oklch(0.216 0.006 56.043);

	--sidebar-foreground: oklch(0.985 0.001 106.423);

	--sidebar-primary: oklch(0.488 0.243 264.376);

	--sidebar-primary-foreground: oklch(0.985 0.001 106.423);

	--sidebar-accent: oklch(0.268 0.007 34.298);

	--sidebar-accent-foreground: oklch(0.985 0.001 106.423);

	--sidebar-border: oklch(0.268 0.007 34.298);

	--sidebar-ring: oklch(0.553 0.013 58.071);
}

@theme inline {
	--color-background: var(--background);

	--color-foreground: var(--foreground);

	--color-card: var(--card);

	--color-card-foreground: var(--card-foreground);

	--color-popover: var(--popover);

	--color-popover-foreground: var(--popover-foreground);

	--color-primary: var(--primary);

	--color-primary-foreground: var(--primary-foreground);

	--color-secondary: var(--secondary);

	--color-secondary-foreground: var(--secondary-foreground);

	--color-muted: var(--muted);

	--color-muted-foreground: var(--muted-foreground);

	--color-accent: var(--accent);

	--color-accent-foreground: var(--accent-foreground);

	--color-destructive: var(--destructive);

	--color-destructive-foreground: var(--destructive-foreground);

	--color-border: var(--border);

	--color-input: var(--input);

	--color-ring: var(--ring);

	--color-chart-1: var(--chart-1);

	--color-chart-2: var(--chart-2);

	--color-chart-3: var(--chart-3);

	--color-chart-4: var(--chart-4);

	--color-chart-5: var(--chart-5);

	--radius-sm: calc(var(--radius) - 4px);

	--radius-md: calc(var(--radius) - 2px);

	--radius-lg: var(--radius);

	--radius-xl: calc(var(--radius) + 4px);

	--color-sidebar: var(--sidebar);

	--color-sidebar-foreground: var(--sidebar-foreground);

	--color-sidebar-primary: var(--sidebar-primary);

	--color-sidebar-primary-foreground: var(--sidebar-primary-foreground);

	--color-sidebar-accent: var(--sidebar-accent);

	--color-sidebar-accent-foreground: var(--sidebar-accent-foreground);

	--color-sidebar-border: var(--sidebar-border);

	--color-sidebar-ring: var(--sidebar-ring);
	--animate-accordion-down: accordion-down 0.2s ease-out;
	--animate-accordion-up: accordion-up 0.2s ease-out;

	@keyframes accordion-down {
		from {
			height: 0;
		}
		to {
			height: var(--radix-accordion-content-height);
		}
	}

	@keyframes accordion-up {
		from {
			height: var(--radix-accordion-content-height);
		}
		to {
			height: 0;
		}
	}
}

@layer base {
	* {
		@apply border-border outline-ring/50;
	}
	body {
		@apply bg-background text-foreground;
	}
}

html {
	scroll-behavior: smooth;
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/layout.config.tsx
```
import { changelogs, source } from "@/lib/source";
import { BaseLayoutProps } from "fumadocs-ui/layouts/shared";

export const baseOptions: BaseLayoutProps = {
	nav: {
		enabled: false,
	},
	links: [
		{
			text: "Documentation",
			url: "/docs",
			active: "nested-url",
		},
	],
};

export const docsOptions = {
	...baseOptions,
	tree: source.pageTree,
};
export const changelogOptions = {
	...baseOptions,
	tree: changelogs.pageTree,
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/layout.tsx
```
import { Navbar } from "@/components/nav-bar";
import "./global.css";
import { RootProvider } from "fumadocs-ui/provider";
import type { ReactNode } from "react";
import { NavbarProvider } from "@/components/nav-mobile";
import { GeistMono } from "geist/font/mono";
import { GeistSans } from "geist/font/sans";
import { baseUrl, createMetadata } from "@/lib/metadata";
import { Analytics } from "@vercel/analytics/react";
import { ThemeProvider } from "@/components/theme-provider";
import { Toaster } from "@/components/ui/sonner";

export const metadata = createMetadata({
	title: {
		template: "%s | Better Auth",
		default: "Better Auth",
	},
	description: "The most comprehensive authentication library for TypeScript.",
	metadataBase: baseUrl,
});

export default function Layout({ children }: { children: ReactNode }) {
	return (
		<html lang="en" suppressHydrationWarning>
			<head>
				<link rel="icon" href="/favicon/favicon.ico" sizes="any" />
				<script
					dangerouslySetInnerHTML={{
						__html: `
                    try {
                      if (localStorage.theme === 'dark' || ((!('theme' in localStorage) || localStorage.theme === 'system') && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                        document.querySelector('meta[name="theme-color"]').setAttribute('content')
                      }
                    } catch (_) {}
                  `,
					}}
				/>
			</head>
			<body
				className={`${GeistSans.variable} ${GeistMono.variable} bg-background font-sans relative `}
			>
				<ThemeProvider
					attribute="class"
					defaultTheme="dark"
					enableSystem
					disableTransitionOnChange
				>
					<RootProvider
						theme={{
							enableSystem: true,
							defaultTheme: "dark",
						}}
					>
						<NavbarProvider>
							<Navbar />
							{children}
							<Toaster />
						</NavbarProvider>
					</RootProvider>
					<Analytics />
				</ThemeProvider>
			</body>
		</html>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/not-found.tsx
```
import Section from "@/components/landing/section";
import Link from "next/link";
import { Logo } from "@/components/logo";
export default function NotFound() {
	return (
		<div className="h-full relative overflow-hidden">
			<Section
				className="mb-1 h-[92.3vh] overflow-y-hidden"
				crosses
				crossesOffset="lg:translate-y-[5.25rem]"
				customPaddings
				id="404"
			>
				<div className="relative flex flex-col h-full items-center justify-center dark:bg-black bg-white text-black dark:text-white">
					<div className="relative mb-8">
						<Logo className="w-10 h-10" />
					</div>
					<h1 className="text-8xl font-normal">404</h1>
					<p className="text-sm mb-8">Need help? Visit the docs</p>
					<div className="flex flex-col items-center gap-6">
						<Link
							href="/docs"
							className="hover:shadow-sm dark:border-stone-100 dark:hover:shadow-sm border-2 border-black bg-white px-4 py-1.5 text-sm uppercase text-black shadow-[1px_1px_rgba(0,0,0),2px_2px_rgba(0,0,0),3px_3px_rgba(0,0,0),4px_4px_rgba(0,0,0),5px_5px_0px_0px_rgba(0,0,0)] transition duration-200 md:px-8 dark:shadow-[1px_1px_rgba(255,255,255),2px_2px_rgba(255,255,255),3px_3px_rgba(255,255,255),4px_4px_rgba(255,255,255),5px_5px_0px_0px_rgba(255,255,255)]"
						>
							Go to docs
						</Link>
					</div>
				</div>
			</Section>
		</div>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/page.tsx
```
import Section from "@/components/landing/section";
import Hero from "@/components/landing/hero";
import Features from "@/components/features";

async function getGitHubStars() {
	try {
		const response = await fetch(
			"https://api.github.com/repos/better-auth/better-auth",
			{
				next: {
					revalidate: 60,
				},
			},
		);
		if (!response?.ok) {
			return null;
		}
		const json = await response.json();
		const stars = parseInt(json.stargazers_count).toLocaleString();
		return stars;
	} catch {
		return null;
	}
}

export default async function HomePage() {
	const stars = await getGitHubStars();
	return (
		<main className="h-min mx-auto overflow-x-hidden">
			<Section
				className="mb-1 overflow-y-clip"
				crosses
				crossesOffset="lg:translate-y-[5.25rem]"
				customPaddings
				id="hero"
			>
				<Hero />
				<Features stars={stars} />
				<hr className="h-px bg-gray-200" />
			</Section>
		</main>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/v1/bg-line.tsx
```
"use client";
import { cn } from "@/lib/utils";
import { motion } from "framer-motion";
import React from "react";

export const BackgroundLines = ({
	children,
	className,
	svgOptions,
}: {
	children: React.ReactNode;
	className?: string;
	svgOptions?: {
		duration?: number;
	};
}) => {
	return (
		<div
			className={cn(
				"h-[20rem] md:h-screen w-full bg-white dark:bg-black",
				className,
			)}
		>
			<SVG svgOptions={svgOptions} />
			{children}
		</div>
	);
};

const pathVariants = {
	initial: { strokeDashoffset: 800, strokeDasharray: "50 800" },
	animate: {
		strokeDashoffset: 0,
		strokeDasharray: "20 800",
		opacity: [0, 1, 1, 0],
	},
};

const SVG = ({
	svgOptions,
}: {
	svgOptions?: {
		duration?: number;
	};
}) => {
	const paths = [
		"M720 450C720 450 742.459 440.315 755.249 425.626C768.039 410.937 778.88 418.741 789.478 401.499C800.076 384.258 817.06 389.269 826.741 380.436C836.423 371.603 851.957 364.826 863.182 356.242C874.408 347.657 877.993 342.678 898.867 333.214C919.741 323.75 923.618 319.88 934.875 310.177C946.133 300.474 960.784 300.837 970.584 287.701C980.384 274.564 993.538 273.334 1004.85 263.087C1016.15 252.84 1026.42 250.801 1038.22 242.1C1050.02 233.399 1065.19 230.418 1074.63 215.721C1084.07 201.024 1085.49 209.128 1112.65 194.884C1139.8 180.64 1132.49 178.205 1146.43 170.636C1160.37 163.066 1168.97 158.613 1181.46 147.982C1193.95 137.35 1191.16 131.382 1217.55 125.645C1243.93 119.907 1234.19 118.899 1254.53 100.846C1274.86 82.7922 1275.12 92.8914 1290.37 76.09C1305.62 59.2886 1313.91 62.1868 1323.19 56.7536C1332.48 51.3204 1347.93 42.8082 1361.95 32.1468C1375.96 21.4855 1374.06 25.168 1397.08 10.1863C1420.09 -4.79534 1421.41 -3.16992 1431.52 -15.0078",
		"M720 450C720 450 741.044 435.759 753.062 410.636C765.079 385.514 770.541 386.148 782.73 370.489C794.918 354.83 799.378 353.188 811.338 332.597C823.298 312.005 825.578 306.419 843.707 295.493C861.837 284.568 856.194 273.248 877.376 256.48C898.558 239.713 887.536 227.843 909.648 214.958C931.759 202.073 925.133 188.092 941.063 177.621C956.994 167.151 952.171 154.663 971.197 135.041C990.222 115.418 990.785 109.375 999.488 96.1291C1008.19 82.8827 1011.4 82.2181 1032.65 61.8861C1053.9 41.5541 1045.74 48.0281 1064.01 19.5798C1082.29 -8.86844 1077.21 -3.89415 1093.7 -19.66C1110.18 -35.4258 1105.91 -46.1146 1127.68 -60.2834C1149.46 -74.4523 1144.37 -72.1024 1154.18 -97.6802C1163.99 -123.258 1165.6 -111.332 1186.21 -135.809C1206.81 -160.285 1203.29 -160.861 1220.31 -177.633C1237.33 -194.406 1236.97 -204.408 1250.42 -214.196",
		"M720 450C720 450 712.336 437.768 690.248 407.156C668.161 376.544 672.543 394.253 665.951 365.784C659.358 337.316 647.903 347.461 636.929 323.197C625.956 298.933 626.831 303.639 609.939 281.01C593.048 258.381 598.7 255.282 582.342 242.504C565.985 229.726 566.053 217.66 559.169 197.116C552.284 176.572 549.348 171.846 529.347 156.529C509.345 141.211 522.053 134.054 505.192 115.653C488.33 97.2527 482.671 82.5627 473.599 70.7833C464.527 59.0039 464.784 50.2169 447 32.0721C429.215 13.9272 436.29 0.858563 423.534 -12.6868C410.777 -26.2322 407.424 -44.0808 394.364 -56.4916C381.303 -68.9024 373.709 -72.6804 365.591 -96.1992C357.473 -119.718 358.364 -111.509 338.222 -136.495C318.08 -161.481 322.797 -149.499 315.32 -181.761C307.843 -214.023 294.563 -202.561 285.795 -223.25C277.026 -243.94 275.199 -244.055 258.602 -263.871",
		"M720 450C720 450 738.983 448.651 790.209 446.852C841.436 445.052 816.31 441.421 861.866 437.296C907.422 433.172 886.273 437.037 930.656 436.651C975.04 436.264 951.399 432.343 1001.57 425.74C1051.73 419.138 1020.72 425.208 1072.85 424.127C1124.97 423.047 1114.39 420.097 1140.02 414.426C1165.65 408.754 1173.1 412.143 1214.55 411.063C1256.01 409.983 1242.78 406.182 1285.56 401.536C1328.35 396.889 1304.66 400.796 1354.41 399.573C1404.16 398.35 1381.34 394.315 1428.34 389.376C1475.35 384.438 1445.96 386.509 1497.93 385.313C1549.9 384.117 1534.63 382.499 1567.23 381.48",
		"M720 450C720 450 696.366 458.841 682.407 472.967C668.448 487.093 673.23 487.471 647.919 492.882C622.608 498.293 636.85 499.899 609.016 512.944C581.182 525.989 596.778 528.494 571.937 533.778C547.095 539.062 551.762 548.656 536.862 556.816C521.962 564.975 515.626 563.279 497.589 575.159C479.552 587.04 484.343 590.435 461.111 598.728C437.879 607.021 442.512 605.226 423.603 618.397C404.694 631.569 402.411 629.541 390.805 641.555C379.2 653.568 369.754 658.175 353.238 663.929C336.722 669.683 330.161 674.689 312.831 684.116C295.5 693.543 288.711 698.815 278.229 704.041C267.747 709.267 258.395 712.506 240.378 726.65C222.361 740.795 230.097 738.379 203.447 745.613C176.797 752.847 193.747 752.523 166.401 767.148C139.056 781.774 151.342 783.641 130.156 791.074C108.97 798.507 116.461 802.688 96.0974 808.817C75.7334 814.946 83.8553 819.505 59.4513 830.576C35.0473 841.648 48.2548 847.874 21.8337 853.886C-4.58739 859.898 10.5966 869.102 -16.396 874.524",
		"M720 450C720 450 695.644 482.465 682.699 506.197C669.755 529.929 671.059 521.996 643.673 556.974C616.286 591.951 625.698 590.8 606.938 615.255C588.178 639.71 592.715 642.351 569.76 665.92C546.805 689.49 557.014 687.498 538.136 722.318C519.258 757.137 520.671 760.818 503.256 774.428C485.841 788.038 491.288 790.063 463.484 831.358C435.681 872.653 437.554 867.001 425.147 885.248C412.74 903.495 411.451 911.175 389.505 934.331C367.559 957.486 375.779 966.276 352.213 990.918C328.647 1015.56 341.908 1008.07 316.804 1047.24C291.699 1086.42 301.938 1060.92 276.644 1100.23C251.349 1139.54 259.792 1138.78 243.151 1153.64",
		"M719.974 450C719.974 450 765.293 459.346 789.305 476.402C813.318 493.459 825.526 487.104 865.093 495.586C904.659 504.068 908.361 510.231 943.918 523.51C979.475 536.789 963.13 535.277 1009.79 547.428C1056.45 559.579 1062.34 555.797 1089.82 568.96C1117.31 582.124 1133.96 582.816 1159.12 592.861C1184.28 602.906 1182.84 603.359 1233.48 614.514C1284.12 625.67 1254.63 632.207 1306.33 644.465C1358.04 656.723 1359.27 656.568 1378.67 670.21C1398.07 683.852 1406.16 676.466 1456.34 692.827C1506.51 709.188 1497.73 708.471 1527.54 715.212",
		"M720 450C720 450 727.941 430.821 734.406 379.251C740.87 327.681 742.857 359.402 757.864 309.798C772.871 260.194 761.947 271.093 772.992 244.308C784.036 217.524 777.105 200.533 786.808 175.699C796.511 150.864 797.141 144.333 808.694 107.307C820.247 70.2821 812.404 88.4169 819.202 37.1016C826 -14.2137 829.525 -0.990829 839.341 -30.3874C849.157 -59.784 844.404 -61.5924 855.042 -98.7516C865.68 -135.911 862.018 -144.559 876.924 -167.488C891.83 -190.418 886.075 -213.535 892.87 -237.945C899.664 -262.355 903.01 -255.031 909.701 -305.588C916.393 -356.144 917.232 -330.612 925.531 -374.777",
		"M720 450C720 450 722.468 499.363 726.104 520.449C729.739 541.535 730.644 550.025 738.836 589.07C747.028 628.115 743.766 639.319 746.146 659.812C748.526 680.306 754.006 693.598 757.006 732.469C760.007 771.34 760.322 765.244 763.893 805.195C767.465 845.146 769.92 822.227 773.398 868.469C776.875 914.71 776.207 901.365 778.233 940.19C780.259 979.015 782.53 990.477 787.977 1010.39C793.424 1030.3 791.788 1060.01 797.243 1082.24C802.698 1104.47 801.758 1130.29 808.181 1149.64C814.604 1168.99 813.135 1171.5 818.026 1225.28C822.918 1279.06 820.269 1267.92 822.905 1293.75",
		"M720 450C720 450 737.033 492.46 757.251 515.772C777.468 539.084 768.146 548.687 785.517 570.846C802.887 593.005 814.782 609.698 824.589 634.112C834.395 658.525 838.791 656.702 855.55 695.611C872.31 734.519 875.197 724.854 890.204 764.253C905.21 803.653 899.844 790.872 919.927 820.763C940.01 850.654 939.071 862.583 954.382 886.946C969.693 911.309 968.683 909.254 993.997 945.221C1019.31 981.187 1006.67 964.436 1023.49 1007.61C1040.32 1050.79 1046.15 1038.25 1059.01 1073.05C1071.88 1107.86 1081.39 1096.19 1089.45 1131.96C1097.51 1167.73 1106.52 1162.12 1125.77 1196.89",
		"M720 450C720 450 687.302 455.326 670.489 467.898C653.676 480.47 653.159 476.959 626.58 485.127C600.002 493.295 599.626 495.362 577.94 503.841C556.254 512.319 556.35 507.426 533.958 517.44C511.566 527.454 505.82 526.441 486.464 539.172C467.108 551.904 461.312 546.36 439.357 553.508C417.402 560.657 406.993 567.736 389.393 572.603C371.794 577.47 371.139 583.76 344.54 587.931C317.941 592.102 327.375 593.682 299.411 607.275C271.447 620.868 283.617 615.022 249.868 622.622C216.119 630.223 227.07 630.86 203.77 638.635C180.47 646.41 168.948 652.487 156.407 657.28C143.866 662.073 132.426 669.534 110.894 675.555C89.3615 681.575 90.3234 680.232 61.1669 689.897C32.0105 699.562 34.3696 702.021 15.9011 709.789C-2.56738 717.558 2.38861 719.841 -29.9494 729.462C-62.2873 739.083 -52.5552 738.225 -77.4307 744.286",
		"M720 450C720 450 743.97 465.061 754.884 490.648C765.798 516.235 781.032 501.34 791.376 525.115C801.72 548.889 808.417 538.333 829.306 564.807C850.195 591.281 852.336 582.531 865.086 601.843C877.835 621.155 874.512 621.773 902.383 643.857C930.255 665.94 921.885 655.976 938.025 681.74C954.164 707.505 959.384 709.719 977.273 720.525C995.162 731.33 994.233 731.096 1015.92 757.676C1037.61 784.257 1025.74 768.848 1047.82 795.343C1069.91 821.837 1065.95 815.45 1085.93 834.73C1105.91 854.009 1110.53 848.089 1124.97 869.759C1139.4 891.428 1140.57 881.585 1158.53 911.499C1176.5 941.414 1184.96 933.829 1194.53 948.792C1204.09 963.755 1221.35 973.711 1232.08 986.224C1242.8 998.738 1257.34 1015.61 1269.99 1026.53C1282.63 1037.45 1293.81 1040.91 1307.21 1064.56",
		"M720 450C720 450 718.24 412.717 716.359 397.31C714.478 381.902 713.988 362.237 710.785 344.829C707.582 327.42 708.407 322.274 701.686 292.106C694.965 261.937 699.926 270.857 694.84 240.765C689.753 210.674 693.055 217.076 689.674 184.902C686.293 152.728 686.041 149.091 682.676 133.657C679.311 118.223 682.23 106.005 681.826 80.8297C681.423 55.6545 677.891 60.196 675.66 30.0226C673.429 -0.150848 672.665 -7.94842 668.592 -26.771C664.52 -45.5935 664.724 -43.0755 661.034 -78.7766C657.343 -114.478 658.509 -103.181 653.867 -133.45C649.226 -163.719 650.748 -150.38 647.052 -182.682C643.357 -214.984 646.125 -214.921 645.216 -238.402C644.307 -261.883 640.872 -253.4 637.237 -291.706C633.602 -330.012 634.146 -309.868 630.717 -343.769C627.288 -377.669 628.008 -370.682 626.514 -394.844",
		"M720 450C720 450 730.384 481.55 739.215 507.557C748.047 533.564 751.618 537.619 766.222 562.033C780.825 586.447 774.187 582.307 787.606 618.195C801.025 654.082 793.116 653.536 809.138 678.315C825.16 703.095 815.485 717.073 829.898 735.518C844.311 753.964 845.351 773.196 852.197 786.599C859.042 800.001 862.876 805.65 872.809 845.974C882.742 886.297 885.179 874.677 894.963 903.246C904.747 931.816 911.787 924.243 921.827 961.809C931.867 999.374 927.557 998.784 940.377 1013.59C953.197 1028.4 948.555 1055.77 966.147 1070.54C983.739 1085.31 975.539 1105.69 988.65 1125.69C1001.76 1145.69 1001.82 1141.59 1007.54 1184.37C1013.27 1227.15 1018.98 1198.8 1029.67 1241.58",
		"M720 450C720 450 684.591 447.135 657.288 439.014C629.985 430.894 618.318 435.733 600.698 431.723C583.077 427.714 566.975 425.639 537.839 423.315C508.704 420.991 501.987 418.958 476.29 413.658C450.592 408.359 460.205 410.268 416.97 408.927C373.736 407.586 396.443 401.379 359.262 396.612C322.081 391.844 327.081 393.286 300.224 391.917C273.368 390.547 264.902 385.49 241.279 382.114C217.655 378.739 205.497 378.95 181.98 377.253C158.464 375.556 150.084 369.938 117.474 366.078C84.8644 362.218 81.5401 361.501 58.8734 358.545C36.2067 355.59 33.6442 351.938 -3.92281 346.728C-41.4898 341.519 -18.6466 345.082 -61.4654 341.179C-104.284 337.275 -102.32 338.048 -121.821 332.369",
		"M720 450C720 450 714.384 428.193 708.622 410.693C702.86 393.193 705.531 397.066 703.397 372.66C701.264 348.254 697.8 345.181 691.079 330.466C684.357 315.751 686.929 312.356 683.352 292.664C679.776 272.973 679.079 273.949 674.646 255.07C670.213 236.192 670.622 244.371 665.271 214.561C659.921 184.751 659.864 200.13 653.352 172.377C646.841 144.623 647.767 151.954 644.123 136.021C640.48 120.088 638.183 107.491 636.127 96.8178C634.072 86.1443 632.548 77.5871 626.743 54.0492C620.938 30.5112 622.818 28.9757 618.613 16.577C614.407 4.17831 615.555 -13.1527 608.752 -24.5691C601.95 -35.9855 603.375 -51.0511 599.526 -60.1492C595.678 -69.2472 593.676 -79.3623 587.865 -100.431C582.053 -121.5 584.628 -117.913 578.882 -139.408C573.137 -160.903 576.516 -161.693 571.966 -182.241C567.416 -202.789 567.42 -198.681 562.834 -218.28C558.248 -237.879 555.335 -240.47 552.072 -260.968C548.808 -281.466 547.605 -280.956 541.772 -296.427C535.94 -311.898 537.352 -315.211 535.128 -336.018C532.905 -356.826 531.15 -360.702 524.129 -377.124",
		"M720 450C720 450 711.433 430.82 707.745 409.428C704.056 388.035 704.937 381.711 697.503 370.916C690.069 360.121 691.274 359.999 685.371 334.109C679.469 308.22 677.496 323.883 671.24 294.303C664.984 264.724 667.608 284.849 662.065 258.116C656.522 231.383 656.357 229.024 647.442 216.172C638.527 203.319 640.134 192.925 635.555 178.727C630.976 164.529 630.575 150.179 624.994 139.987C619.413 129.794 615.849 112.779 612.251 103.074C608.654 93.3696 606.942 85.6729 603.041 63.0758C599.14 40.4787 595.242 36.9267 589.533 23.8967C583.823 10.8666 581.18 -2.12401 576.96 -14.8333C572.739 -27.5425 572.696 -37.7703 568.334 -51.3441C563.972 -64.9179 562.14 -67.2124 556.992 -93.299C551.844 -119.386 550.685 -109.743 544.056 -129.801C537.428 -149.859 534.97 -151.977 531.034 -170.076C527.099 -188.175 522.979 -185.119 519.996 -207.061C517.012 -229.004 511.045 -224.126 507.478 -247.077C503.912 -270.029 501.417 -271.033 495.534 -287C489.651 -302.968 491.488 -300.977 484.68 -326.317C477.872 -351.657 476.704 -348.494 472.792 -363.258",
		"M720 450C720 450 723.524 466.673 728.513 497.319C733.503 527.964 731.894 519.823 740.001 542.706C748.108 565.589 744.225 560.598 748.996 588.365C753.766 616.131 756.585 602.096 761.881 636.194C767.178 670.293 768.155 649.089 771.853 679.845C775.551 710.6 775.965 703.738 781.753 724.555C787.54 745.372 787.248 758.418 791.422 773.79C795.596 789.162 798.173 807.631 804.056 819.914C809.938 832.197 806.864 843.07 811.518 865.275C816.171 887.48 816.551 892.1 822.737 912.643C828.922 933.185 830.255 942.089 833.153 956.603C836.052 971.117 839.475 969.242 846.83 1003.98C854.185 1038.71 850.193 1028.86 854.119 1048.67C858.045 1068.48 857.963 1074.39 863.202 1094.94C868.44 1115.49 867.891 1108.03 874.497 1138.67C881.102 1169.31 880.502 1170.72 887.307 1186.56C894.111 1202.4 890.388 1209.75 896.507 1231.25C902.627 1252.76 902.54 1245.39 906.742 1279.23",
		"M720 450C720 450 698.654 436.893 669.785 424.902C640.916 412.91 634.741 410.601 615.568 402.586C596.396 394.571 594.829 395.346 568.66 378.206C542.492 361.067 547.454 359.714 514.087 348.978C480.721 338.242 479.79 334.731 467.646 329.846C455.502 324.96 448.63 312.156 416.039 303.755C383.448 295.354 391.682 293.73 365.021 280.975C338.36 268.219 328.715 267.114 309.809 252.575C290.903 238.036 277.185 246.984 259.529 230.958C241.873 214.931 240.502 224.403 211.912 206.241C183.323 188.078 193.288 190.89 157.03 181.714C120.772 172.538 127.621 170.109 108.253 154.714C88.8857 139.319 75.4927 138.974 56.9647 132.314C38.4366 125.654 33.8997 118.704 4.77584 106.7C-24.348 94.6959 -19.1326 90.266 -46.165 81.9082",
		"M720 450C720 450 711.596 475.85 701.025 516.114C690.455 556.378 697.124 559.466 689.441 579.079C681.758 598.693 679.099 597.524 675.382 642.732C671.665 687.94 663.4 677.024 657.844 700.179C652.288 723.333 651.086 724.914 636.904 764.536C622.723 804.158 631.218 802.853 625.414 827.056C619.611 851.259 613.734 856.28 605.94 892.262C598.146 928.244 595.403 924.314 588.884 957.785C582.364 991.255 583.079 991.176 575.561 1022.63C568.044 1054.08 566.807 1058.45 558.142 1084.32C549.476 1110.2 553.961 1129.13 542.367 1149.25C530.772 1169.37 538.268 1180.37 530.338 1207.27C522.407 1234.17 520.826 1245.53 512.156 1274.2",
		"M720 450C720 450 730.571 424.312 761.424 411.44C792.277 398.569 772.385 393.283 804.069 377.232C835.752 361.182 829.975 361.373 848.987 342.782C867.999 324.192 877.583 330.096 890.892 303.897C904.201 277.698 910.277 282.253 937.396 264.293C964.514 246.333 949.357 246.834 978.7 230.438C1008.04 214.042 990.424 217.952 1021.51 193.853C1052.6 169.753 1054.28 184.725 1065.97 158.075C1077.65 131.425 1087.76 139.068 1111.12 120.345C1134.49 101.622 1124.9 104.858 1151.67 86.3162C1178.43 67.7741 1167.09 66.2676 1197.53 47.2606C1227.96 28.2536 1225.78 23.2186 1239.27 12.9649C1252.76 2.7112 1269.32 -9.47929 1282.88 -28.5587C1296.44 -47.6381 1305.81 -41.3853 1323.82 -62.7027C1341.83 -84.0202 1340.32 -82.3794 1368.98 -98.9326",
	];

	const colors = [
		"#46A5CA",
		"#8C2F2F",
		"#4FAE4D",
		"#D6590C",
		"#811010",
		"#247AFB",
		"#A534A0",
		"#A8A438",
		"#D6590C",
		"#46A29C",
		"#670F6D",
		"#D7C200",
		"#59BBEB",
		"#504F1C",
		"#55BC54",
		"#4D3568",
		"#9F39A5",
		"#363636",
		"#860909",
		"#6A286F",
		"#604483",
	];
	return (
		<motion.svg
			viewBox="0 0 1440 900"
			fill="none"
			xmlns="http://www.w3.org/2000/svg"
			initial={{ opacity: 0 }}
			animate={{ opacity: 1 }}
			transition={{ duration: 1 }}
			className="absolute inset-0 w-full h-full"
		>
			{paths.map((path, idx) => (
				<motion.path
					d={path}
					stroke={colors[idx]}
					strokeWidth="2.3"
					strokeLinecap="round"
					variants={pathVariants}
					initial="initial"
					animate="animate"
					transition={{
						duration: svgOptions?.duration || 10,
						ease: "linear",
						repeat: Infinity,
						repeatType: "loop",
						delay: Math.floor(Math.random() * 10),
						repeatDelay: Math.floor(Math.random() * 10 + 2),
					}}
					key={`path-first-${idx}`}
				/>
			))}

			{/* duplicate for more paths */}
			{paths.map((path, idx) => (
				<motion.path
					d={path}
					stroke={colors[idx]}
					strokeWidth="2.3"
					strokeLinecap="round"
					variants={pathVariants}
					initial="initial"
					animate="animate"
					transition={{
						duration: svgOptions?.duration || 10,
						ease: "linear",
						repeat: Infinity,
						repeatType: "loop",
						delay: Math.floor(Math.random() * 10),
						repeatDelay: Math.floor(Math.random() * 10 + 2),
					}}
					key={`path-second-${idx}`}
				/>
			))}
		</motion.svg>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/v1/page.tsx
```
import { ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { BackgroundLines } from "./bg-line";
import Link from "next/link";
import { DiscordLogoIcon, GitHubLogoIcon } from "@radix-ui/react-icons";
import { Metadata } from "next";

export const metadata: Metadata = {
	title: "V1.0 Release",
	description: "Better Auth V1.0 release notes",
	openGraph: {
		images: "https://better-auth.com/v1-og.png",
		title: "V1.0 Release",
		description: "Better Auth V1.0 release notes",
		url: "https://better-auth.com/v1",
		type: "article",
		siteName: "Better Auth",
	},
	twitter: {
		images: "https://better-auth.com/v1-og.png",
		card: "summary_large_image",
		site: "@better_auth",
		creator: "@better_auth",
		title: "V1.0 Release",
		description: "Better Auth V1.0 release notes",
	},
};

export default function V1Ship() {
	return (
		<div className="min-h-screen bg-transparent overflow-hidden">
			<div className="h-[50vh] bg-transparent/10 relative">
				<BackgroundLines>
					<div className="absolute bottom-1/3 left-1/2 transform -translate-x-1/2 text-center">
						<h1 className="text-5xl mb-4">V1.0 - nov.22</h1>
						<p className="text-lg text-gray-400 max-w-xl mx-auto">
							We are excited to announce the Better Auth V1.0 release.
						</p>
					</div>
				</BackgroundLines>
			</div>

			<div className="relative py-24">
				<div className="absolute inset-0 z-0">
					<div className="grid grid-cols-12 h-full">
						{Array(12)
							.fill(null)
							.map((_, i) => (
								<div
									key={i}
									className="border-l border-dashed border-stone-100 dark:border-white/10 h-full"
								/>
							))}
					</div>
					<div className="grid grid-rows-12 w-full absolute top-0">
						{Array(12)
							.fill(null)
							.map((_, i) => (
								<div
									key={i}
									className="border-t border-dashed border-stone-100 dark:border-stone-900/60 w-full"
								/>
							))}
					</div>
				</div>
				<div className="max-w-6xl mx-auto px-6 relative z-10">
					<h2 className="text-3xl font-bold mb-12 font-geist text-center">
						What does V1 means?
					</h2>
					<p>
						Since introducing Better Auth, the community's excitement has been
						incredibly motivating—thank you! <br /> <br />
						V1 is an important milestone, but it simply means we believe you can
						use it in production and that we'll strive to keep the APIs stable
						until the next major version. However, we'll continue improving,
						adding new features, and fixing bugs at the same pace as before.
						<br /> <br />
						If you were using Better Auth for production, we recommend updating
						to V1 as soon as possible. There are some breaking changes, feel
						free to join us on{" "}
						<Link href="https://discord.com/better-auth">Discord</Link>, and
						we'll gladly assist.
					</p>
				</div>
			</div>

			<ReleaseRelated />

			<div className="border-t border-white/10">
				<div className="max-w-4xl mx-auto px-6 py-24">
					<h2 className="text-3xl font-bold mb-12 font-geist">Changelog</h2>
					<div className="space-y-8">
						<ChangelogItem
							version="1.0.0"
							date="2024"
							changes={[
								"feat: Open API Docs",
								"docs: Sign In Box Builder",
								"feat: default memory adapter. If no database is provided, it will use memory adapter",
								"feat: New server only endpoints for Organization and Two Factor plugins",
								"refactor: all core tables now have `createdAt` and `updatedAt` fields",
								"refactor: accounts now store `expiresAt` for both refresh and access tokens",
								"feat: Email OTP forget password flow",
								"docs: NextAuth.js migration guide",
								"feat: sensitive endpoints now check for fresh tokens",
								"feat: two-factor now have different interface for redirect and callback",
								"and a lot more bug fixes and improvements...",
							]}
						/>
					</div>
				</div>
			</div>
		</div>
	);
}

function ReleaseRelated() {
	return (
		<div className="relative dark:bg-transparent/10 bg-zinc-100 border-b-2 border-white/10 rounded-none py-24">
			<div className="absolute inset-0 z-0">
				<div className="grid grid-rows-12 w-full absolute top-0">
					{Array(12)
						.fill(null)
						.map((_, i) => (
							<div
								key={i}
								className="border-t border-dashed border-white/10 w-full"
							/>
						))}
				</div>
			</div>
			<div className="max-w-6xl mx-auto px-6 relative z-10">
				<div className="grid grid-cols-1 md:grid-cols-3 gap-8">
					<div>
						<h3 className="text-xl font-semibold mb-4">Install Latest</h3>
						<div className="dark:bg-white/5 bg-black/10 rounded-lg p-4 mb-2">
							<code className="text-sm font-mono">
								npm i better-auth@latest
							</code>
						</div>
						<p className="text-sm text-gray-400">
							Get the latest{" "}
							<a href="#" className="underline">
								Node.js and npm
							</a>
							.
						</p>
					</div>
					<div>
						<h3 className="text-xl font-semibold mb-4">Adopt the new Schema</h3>
						<div className="dark:bg-white/5 bg-black/10 rounded-lg p-4 mb-2">
							<code className="text-sm font-mono ">
								pnpx @better-auth/cli migrate
								<br />
							</code>
						</div>
						<p className="text-sm text-gray-400">
							Ensure you have the latest{" "}
							<code className="text-xs dark:bg-white/5 bg-black/10 px-1 py-0.5 rounded">
								schema required
							</code>{" "}
							by Better Auth.
							<code className="text-xs dark:bg-white/5 bg-black/10 px-1 py-0.5 rounded">
								You can also
							</code>{" "}
							add them manually. Read the{" "}
							<a
								href="/docs/concepts/database#core-schema"
								className="underline"
							>
								Core Schema
							</a>{" "}
							for full instructions.
						</p>
					</div>
					<div>
						<h3 className="text-xl font-semibold mb-4">
							Check out the change log, the new UI Builder, OpenAPI Docs, and
							more
						</h3>
						<p className="text-sm text-gray-400 mb-4">
							We have some exciting new features and updates that you should
							check out.
						</p>
						<Link
							className="w-full"
							href="https://github.com/better-auth/better-auth"
						>
							<Button variant="outline" className="w-full justify-between">
								<div className="flex items-center gap-2">
									<GitHubLogoIcon fontSize={10} />
									Star on GitHub
								</div>
								<ArrowRight className="w-4 h-4" />
							</Button>
						</Link>
						<Link className="w-full" href="https://discord.gg/GYC3W7tZzb">
							<Button
								variant="outline"
								className="w-full justify-between border-t-0"
							>
								<div className="flex items-center gap-2">
									<DiscordLogoIcon />
									Join Discord
								</div>
								<ArrowRight className="w-4 h-4" />
							</Button>
						</Link>
					</div>
				</div>
			</div>
		</div>
	);
}

function ChangelogItem({
	version,
	date,
	changes,
}: {
	version: string;
	date: string;
	changes: string[];
}) {
	return (
		<div className="border-l-2 border-white/10 pl-6 relative">
			<div className="absolute w-3 h-3 bg-white rounded-full -left-[7px] top-2" />
			<div className="flex items-center gap-4 mb-4">
				<h3 className="text-xl font-bold font-geist">{version}</h3>
				<span className="text-sm text-gray-400">{date}</span>
			</div>
			<ul className="space-y-3">
				{changes.map((change, i) => (
					<li key={i} className="text-gray-400">
						{change}
					</li>
				))}
			</ul>
		</div>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/v1/_components/v1-text.tsx
```
export const ShipText = () => {
	const voxels = [
		// V
		[0, 0],
		[0, 1],
		[0, 2],
		[1, 3],
		[2, 2],
		[2, 1],
		[2, 0],
		// 1
		[4, 0],
		[4, 1],
		[4, 2],
		[4, 3],
		// .
		[6, 3],
		// 0
		[8, 0],
		[8, 1],
		[8, 2],
		[8, 3],
		[9, 0],
		[9, 3],
		[10, 0],
		[10, 1],
		[10, 2],
		[10, 3],
	];

	return (
		<div className="flex justify-center items-center mb-0 h-[80%]">
			<div className="grid grid-cols-11 gap-2">
				{Array.from({ length: 44 }).map((_, index) => {
					const row = Math.floor(index / 11);
					const col = index % 11;
					const isActive = voxels.some(([x, y]) => x === col && y === row);
					return (
						<div
							key={index}
							className={`w-8 h-8 ${
								isActive
									? "bg-gradient-to-tr from-stone-100 via-white/90 to-zinc-900"
									: "bg-transparent"
							}`}
						/>
					);
				})}
			</div>
		</div>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/llms.txt/route.ts
```typescript
import * as fs from "node:fs/promises";
import fg from "fast-glob";
import matter from "gray-matter";
import { remark } from "remark";
import remarkGfm from "remark-gfm";
import { remarkInstall } from "fumadocs-docgen";
import remarkStringify from "remark-stringify";
import remarkMdx from "remark-mdx";

export const revalidate = false;

export async function GET() {
	// all scanned content
	const files = await fg(["./content/docs/**/*.mdx"]);

	const scan = files.map(async (file) => {
		const fileContent = await fs.readFile(file);
		const { content, data } = matter(fileContent.toString());

		const processed = await processContent(content);
		return `file: ${file}
meta: ${JSON.stringify(data, null, 2)}
        
${processed}`;
	});

	const scanned = await Promise.all(scan);

	return new Response(scanned.join("\n\n"));
}

async function processContent(content: string): Promise<string> {
	const file = await remark()
		.use(remarkMdx)
		// gfm styles
		.use(remarkGfm)
		// your remark plugins
		.use(remarkInstall, { persist: { id: "package-manager" } })
		// to string
		.use(remarkStringify)
		.process(content);

	return String(file);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/docs/layout.tsx
```
import { DocsLayout } from "fumadocs-ui/layouts/docs";
import type { ReactNode } from "react";
import { docsOptions } from "../layout.config";
import ArticleLayout from "@/components/side-bar";
import { cn } from "@/lib/utils";

export default function Layout({ children }: { children: ReactNode }) {
	return (
		<DocsLayout
			{...docsOptions}
			sidebar={{
				component: (
					<div
						className={cn(
							"[--fd-tocnav-height:36px] md:mr-[268px] lg:mr-[286px] xl:[--fd-toc-width:286px] xl:[--fd-tocnav-height:0px] ",
						)}
					>
						<ArticleLayout />
					</div>
				),
			}}
		>
			{children}
		</DocsLayout>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/docs/[[...slug]]/page.tsx
```
import { source } from "@/lib/source";
import { DocsPage, DocsBody, DocsTitle } from "fumadocs-ui/page";
import { notFound } from "next/navigation";
import { absoluteUrl } from "@/lib/utils";
import DatabaseTable from "@/components/mdx/database-tables";
import { cn } from "@/lib/utils";
import { Step, Steps } from "fumadocs-ui/components/steps";
import { Tab, Tabs } from "fumadocs-ui/components/tabs";
import { GenerateSecret } from "@/components/generate-secret";
import { AnimatePresence } from "@/components/ui/fade-in";
import { TypeTable } from "fumadocs-ui/components/type-table";
import { Features } from "@/components/blocks/features";
import { ForkButton } from "@/components/fork-button";
import Link from "next/link";
import defaultMdxComponents from "fumadocs-ui/mdx";
import { File, Folder, Files } from "fumadocs-ui/components/files";
import { createTypeTable } from "fumadocs-typescript/ui";
import { Accordion, Accordions } from "fumadocs-ui/components/accordion";
import { Card, Cards } from "fumadocs-ui/components/card";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { contents } from "@/components/sidebar-content";
import { Endpoint } from "@/components/endpoint";
import { DividerText } from "@/components/divider-text";

const { AutoTypeTable } = createTypeTable();

export default async function Page({
	params,
}: {
	params: Promise<{ slug?: string[] }>;
}) {
	const { slug } = await params;
	const page = source.getPage(slug);

	if (!page) {
		notFound();
	}

	const { nextPage, prevPage } = getPageLinks(page.url);

	const MDX = page.data.body;

	return (
		<DocsPage
			toc={page.data.toc}
			full={page.data.full}
			editOnGithub={{
				owner: "better-auth",
				repo: "better-auth",
				sha: "main",
				path: `/docs/content/docs/${page.file.path}`,
			}}
			tableOfContent={{
				style: "clerk",
				header: <div className="w-10 h-4"></div>,
			}}
			footer={{
				enabled: true,
				component: <div className="w-10 h-4" />,
			}}
		>
			<DocsTitle>{page.data.title}</DocsTitle>
			<DocsBody>
				<MDX
					components={{
						...defaultMdxComponents,
						Link: ({
							className,
							...props
						}: React.ComponentProps<typeof Link>) => (
							<Link
								className={cn(
									"font-medium underline underline-offset-4",
									className,
								)}
								{...props}
							/>
						),
						Step,
						Steps,
						File,
						Folder,
						Files,
						Tab,
						Tabs,
						AutoTypeTable,
						GenerateSecret,
						AnimatePresence,
						TypeTable,
						Features,
						ForkButton,
						DatabaseTable,
						Accordion,
						Accordions,
						Endpoint,
						Callout: ({ children, ...props }) => (
							<defaultMdxComponents.Callout
								{...props}
								className={cn(
									props,
									"bg-none rounded-none border-dashed border-border",
									props.type === "info" && "border-l-blue-500/50",
									props.type === "warn" && "border-l-amber-700/50",
									props.type === "error" && "border-l-red-500/50",
								)}
							>
								{children}
							</defaultMdxComponents.Callout>
						),
						DividerText,
						iframe: (props) => (
							<iframe {...props} className="w-full h-[500px]" />
						),
					}}
				/>

				<Cards className="mt-16">
					{prevPage ? (
						<Card
							href={prevPage.url}
							className="[&>p]:ml-1 [&>p]:truncate [&>p]:w-full"
							description={<>{prevPage.data.description}</>}
							title={
								<div className="flex items-center gap-1">
									<ChevronLeft className="size-4" />
									{prevPage.data.title}
								</div>
							}
						/>
					) : (
						<div></div>
					)}
					{nextPage ? (
						<Card
							href={nextPage.url}
							description={<>{nextPage.data.description}</>}
							title={
								<div className="flex items-center gap-1">
									{nextPage.data.title}
									<ChevronRight className="size-4" />
								</div>
							}
							className="flex flex-col items-end text-right [&>p]:ml-1 [&>p]:truncate [&>p]:w-full"
						/>
					) : (
						<div></div>
					)}
				</Cards>
			</DocsBody>
		</DocsPage>
	);
}

export async function generateStaticParams() {
	const res = source.getPages().map((page) => ({
		slug: page.slugs,
	}));
	return source.generateParams();
}

export async function generateMetadata({
	params,
}: {
	params: Promise<{ slug?: string[] }>;
}) {
	const { slug } = await params;
	const page = source.getPage(slug);
	if (page == null) notFound();
	const baseUrl = process.env.NEXT_PUBLIC_URL || process.env.VERCEL_URL;
	const url = new URL(`${baseUrl}/api/og`);
	const { title, description } = page.data;
	const pageSlug = page.file.path;
	url.searchParams.set("type", "Documentation");
	url.searchParams.set("mode", "dark");
	url.searchParams.set("heading", `${title}`);

	return {
		title,
		description,
		openGraph: {
			title,
			description,
			type: "website",
			url: absoluteUrl(`docs/${pageSlug}`),
			images: [
				{
					url: url.toString(),
					width: 1200,
					height: 630,
					alt: title,
				},
			],
		},
		twitter: {
			card: "summary_large_image",
			title,
			description,
			images: [url.toString()],
		},
	};
}

function getPageLinks(path: string) {
	const current_category_index = contents.findIndex(
		(x) => x.list.find((x) => x.href === path)!,
	)!;
	const current_category = contents[current_category_index];
	if (!current_category) return { nextPage: undefined, prevPage: undefined };

	// user's current page.
	const current_page = current_category.list.find((x) => x.href === path)!;

	// the next page in the array.
	let next_page = current_category.list.filter((x) => !x.group)[
		current_category.list
			.filter((x) => !x.group)
			.findIndex((x) => x.href === current_page.href) + 1
	];
	//if there isn't a next page, then go to next cat's page.
	if (!next_page) {
		// get next cat
		let next_category = contents[current_category_index + 1];
		// if doesn't exist, return to first cat.
		if (!next_category) next_category = contents[0];

		next_page = next_category.list[0];
		if (next_page.group) {
			next_page = next_category.list[1];
		}
	}
	// the prev page in the array.
	let prev_page = current_category.list.filter((x) => !x.group)[
		current_category.list
			.filter((x) => !x.group)
			.findIndex((x) => x.href === current_page.href) - 1
	];
	// if there isn't a prev page, then go to prev cat's page.
	if (!prev_page) {
		// get prev cat
		let prev_category = contents[current_category_index - 1];
		// if doesn't exist, return to last cat.
		if (!prev_category) prev_category = contents[contents.length - 1];
		prev_page = prev_category.list[prev_category.list.length - 1];
		if (prev_page.group) {
			prev_page = prev_category.list[prev_category.list.length - 2];
		}
	}

	const pages = source.getPages();
	let next_page2 = pages.find((x) => x.url === next_page.href);
	let prev_page2 = pages.find((x) => x.url === prev_page.href);
	if (path === "/docs/introduction") prev_page2 = undefined;
	return { nextPage: next_page2, prevPage: prev_page2 };
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/changelogs/layout.tsx
```
import type { ReactNode } from "react";
export default function Layout({ children }: { children: ReactNode }) {
	return <div>{children}</div>;
}

```
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
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/changelogs/[[...slug]]/page.tsx
```
import { changelogs } from "@/lib/source";
import { notFound } from "next/navigation";
import { absoluteUrl, formatDate } from "@/lib/utils";
import DatabaseTable from "@/components/mdx/database-tables";
import { cn } from "@/lib/utils";
import { Step, Steps } from "fumadocs-ui/components/steps";
import { Tab, Tabs } from "fumadocs-ui/components/tabs";
import { GenerateSecret } from "@/components/generate-secret";
import { AnimatePresence } from "@/components/ui/fade-in";
import { TypeTable } from "fumadocs-ui/components/type-table";
import { Features } from "@/components/blocks/features";
import { ForkButton } from "@/components/fork-button";
import Link from "next/link";
import defaultMdxComponents from "fumadocs-ui/mdx";
import { File, Folder, Files } from "fumadocs-ui/components/files";
import { Accordion, Accordions } from "fumadocs-ui/components/accordion";
import { Pre } from "fumadocs-ui/components/codeblock";
import { DocsBody } from "fumadocs-ui/page";
import ChangelogPage, { Glow } from "../_components/default-changelog";
import { IconLink } from "../_components/changelog-layout";
import { BookIcon, GitHubIcon, XIcon } from "../_components/icons";
import { DiscordLogoIcon } from "@radix-ui/react-icons";
import { StarField } from "../_components/stat-field";
import { CalendarClockIcon } from "lucide-react";

const metaTitle = "Changelogs";
const metaDescription = "Latest changes , fixes and updates.";
const ogImage = "https://better-auth.com/release-og/changelog-og.png";

export default async function Page({
	params,
}: {
	params: Promise<{ slug?: string[] }>;
}) {
	const { slug } = await params;
	const page = changelogs.getPage(slug);
	if (!slug) {
		//@ts-ignore
		return <ChangelogPage />;
	}
	if (!page) {
		notFound();
	}
	const MDX = page.data?.body;
	const toc = page.data?.toc;
	const { title, description, date } = page.data;
	return (
		<div className="md:grid md:grid-cols-2 items-start">
			<div className="bg-gradient-to-tr hidden md:block overflow-hidden px-12 py-24 md:py-0 -mt-[100px] md:h-dvh relative md:sticky top-0 from-transparent dark:via-stone-950/5 via-stone-100/30 to-stone-200/20 dark:to-transparent/10">
				<StarField className="top-1/2 -translate-y-1/2 left-1/2 -translate-x-1/2" />
				<Glow />

				<div className="flex flex-col md:justify-center max-w-xl mx-auto h-full">
					<h1 className="mt-14 font-sans font-semibold tracking-tighter text-5xl">
						{title}{" "}
					</h1>

					<p className="text-sm text-gray-600 dark:text-gray-300">
						{description}
					</p>
					<div className="text-gray-600 dark:text-gray-300 flex items-center gap-x-1">
						<CalendarClockIcon className="w-4 h-4" />
						<p>{formatDate(date)}</p>
					</div>
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
				<div className="absolute top-0 left-0 h-full -translate-x-full w-px bg-gradient-to-b from-black/5 dark:from-white/10 via-black/3 dark:via-white/5 to-transparent"></div>
				<DocsBody>
					<MDX
						components={{
							...defaultMdxComponents,
							Link: ({
								className,
								...props
							}: React.ComponentProps<typeof Link>) => (
								<Link
									className={cn(
										"font-medium underline underline-offset-4",
										className,
									)}
									{...props}
								/>
							),
							Step,
							Steps,
							File,
							Folder,
							Files,
							Tab,
							Tabs,
							Pre: Pre,
							GenerateSecret,
							AnimatePresence,
							TypeTable,
							Features,
							ForkButton,
							DatabaseTable,
							Accordion,
							Accordions,
						}}
					/>
				</DocsBody>
			</div>
		</div>
	);
}

export async function generateMetadata({
	params,
}: {
	params: Promise<{ slug?: string[] }>;
}) {
	const { slug } = await params;
	if (!slug) {
		return {
			metadataBase: new URL("https://better-auth.com/changelogs"),
			title: metaTitle,
			description: metaDescription,
			openGraph: {
				title: metaTitle,
				description: metaDescription,
				images: [
					{
						url: ogImage,
					},
				],
				url: "https://better-auth.com/changelogs",
			},
			twitter: {
				card: "summary_large_image",
				title: metaTitle,
				description: metaDescription,
				images: [ogImage],
			},
		};
	}
	const page = changelogs.getPage(slug);
	if (page == null) notFound();
	const baseUrl = process.env.NEXT_PUBLIC_URL || process.env.VERCEL_URL;
	const url = new URL(`${baseUrl}/release-og/${slug.join("")}.png`);
	const { title, description } = page.data;

	return {
		title,
		description,
		openGraph: {
			title,
			description,
			type: "website",
			url: absoluteUrl(`changelogs/${slug.join("")}`),
			images: [
				{
					url: url.toString(),
					width: 1200,
					height: 630,
					alt: title,
				},
			],
		},
		twitter: {
			card: "summary_large_image",
			title,
			description,
			images: [url.toString()],
		},
	};
}

export function generateStaticParams() {
	return changelogs.generateParams();
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/api/search/route.ts
```typescript
import { source } from "@/lib/source";
import { createFromSource } from "fumadocs-core/search/server";

export const { GET } = createFromSource(source);

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/api/og/route.tsx
```
import { ImageResponse } from "@vercel/og";
import { z } from "zod";
export const runtime = "edge";

const ogSchema = z.object({
	heading: z.string(),
	mode: z.string(),
	type: z.string(),
});
export async function GET(req: Request) {
	try {
		const geist = await fetch(
			new URL("../../../assets/Geist.ttf", import.meta.url),
		).then((res) => res.arrayBuffer());
		const geistMono = await fetch(
			new URL("../../../assets/GeistMono.ttf", import.meta.url),
		).then((res) => res.arrayBuffer());
		const url = new URL(req.url);
		const urlParamsValues = Object.fromEntries(url.searchParams);
		const validParams = ogSchema.parse(urlParamsValues);
		const { heading, type } = validParams;
		const trueHeading =
			heading.length > 140 ? `${heading.substring(0, 140)}...` : heading;

		const paint = "#fff";

		const fontSize = trueHeading.length > 100 ? "30px" : "60px";
		return new ImageResponse(
			<div
				tw="flex w-full relative flex-col p-12"
				style={{
					color: paint,
					backgroundColor: "transparent",
					border: "1px solid rgba(255, 255, 255, 0.1)",
					boxShadow: "0 -20px 80px -20px rgba(28, 12, 12, 0.1) inset",
					background: "#0a0505",
				}}
			>
				<div
					tw={`relative flex flex-col w-full h-full border-2 border-[${paint}]/20 p-10}`}
				>
					<svg
						style={{
							position: "absolute",
							top: "-9px",
							right: "-9px",
						}}
						width="17"
						height="17"
						fill="none"
					>
						<path
							d="M7 1a1 1 0 0 0-1-1H5a1 1 0 0 0-1 1v2a1 1 0 0 1-1 1H1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1h2a1 1 0 0 1 1 1v2a1 1 0 0 0 1 1h1a1 1 0 0 0 1-1V8a1 1 0 0 1 1-1h2a1 1 0 0 0 1-1V5a1 1 0 0 0-1-1H8a1 1 0 0 1-1-1V1z"
							fill="#d0cfd1d3"
						/>
					</svg>

					<svg
						style={{
							position: "absolute",
							top: "-9px",
							left: "-9px",
						}}
						width="17"
						height="17"
						fill="none"
					>
						<path
							d="M7 1a1 1 0 0 0-1-1H5a1 1 0 0 0-1 1v2a1 1 0 0 1-1 1H1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1h2a1 1 0 0 1 1 1v2a1 1 0 0 0 1 1h1a1 1 0 0 0 1-1V8a1 1 0 0 1 1-1h2a1 1 0 0 0 1-1V5a1 1 0 0 0-1-1H8a1 1 0 0 1-1-1V1z"
							fill="#cacaca"
						/>
					</svg>
					<svg
						style={{
							position: "absolute",
							bottom: "-9px",
							left: "-9px",
						}}
						width="17"
						height="17"
						fill="none"
					>
						<path
							d="M7 1a1 1 0 0 0-1-1H5a1 1 0 0 0-1 1v2a1 1 0 0 1-1 1H1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1h2a1 1 0 0 1 1 1v2a1 1 0 0 0 1 1h1a1 1 0 0 0 1-1V8a1 1 0 0 1 1-1h2a1 1 0 0 0 1-1V5a1 1 0 0 0-1-1H8a1 1 0 0 1-1-1V1z"
							fill="#cacaca"
						/>
					</svg>
					<svg
						style={{
							position: "absolute",
							bottom: "-9px",
							right: "-9px",
						}}
						width="17"
						height="17"
						fill="none"
					>
						<path
							d="M7 1a1 1 0 0 0-1-1H5a1 1 0 0 0-1 1v2a1 1 0 0 1-1 1H1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1h2a1 1 0 0 1 1 1v2a1 1 0 0 0 1 1h1a1 1 0 0 0 1-1V8a1 1 0 0 1 1-1h2a1 1 0 0 0 1-1V5a1 1 0 0 0-1-1H8a1 1 0 0 1-1-1V1z"
							fill="#cacaca"
						/>
					</svg>
					<div tw="flex flex-col flex-1 py-10">
						<svg
							width="100"
							height="95"
							viewBox="0 0 60 45"
							fill="none"
							className="mb-10"
							xmlns="http://www.w3.org/2000/svg"
						>
							<path
								fillRule="evenodd"
								stroke={paint}
								clipRule="evenodd"
								d="M0 0H15V15H30V30H15V45H0V30V15V0ZM45 30V15H30V0H45H60V15V30V45H45H30V30H45Z"
								fill="white"
							/>
						</svg>
						<div
							style={{ fontFamily: "GeistMono", fontWeight: "normal" }}
							tw="relative flex mt-10 text-xl uppercase font-bold gap-2 items-center"
						>
							{type === "documentaiton" ? (
								<svg
									xmlns="http://www.w3.org/2000/svg"
									width="1.2em"
									height="1.2em"
									viewBox="0 0 24 24"
								>
									<path
										fill="currentColor"
										fillRule="evenodd"
										d="M4.172 3.172C3 4.343 3 6.229 3 10v4c0 3.771 0 5.657 1.172 6.828S7.229 22 11 22h2c3.771 0 5.657 0 6.828-1.172S21 17.771 21 14v-4c0-3.771 0-5.657-1.172-6.828S16.771 2 13 2h-2C7.229 2 5.343 2 4.172 3.172M8 9.25a.75.75 0 0 0 0 1.5h8a.75.75 0 0 0 0-1.5zm0 4a.75.75 0 0 0 0 1.5h5a.75.75 0 0 0 0-1.5z"
										clipRule="evenodd"
									></path>
								</svg>
							) : null}
							{type}
						</div>
						<div
							tw="flex max-w-[70%] mt-5 tracking-tighter leading-[1.1] text-[30px] font-bold"
							style={{
								fontWeight: "bold",
								marginLeft: "-3px",
								fontSize,

								fontFamily: "GeistMono",
							}}
						>
							{trueHeading}
						</div>
					</div>
					<div tw="flex items-center w-full justify-between">
						<div
							tw="flex text-xl"
							style={{ fontFamily: "GeistSans", fontWeight: "semibold" }}
						>
							Better Auth.
						</div>
						<div tw="flex gap-2 items-center text-xl">
							<svg
								xmlns="http://www.w3.org/2000/svg"
								width="1.2em"
								height="1.2em"
								viewBox="0 0 24 24"
							>
								<path
									fill="currentColor"
									d="M12 2A10 10 0 0 0 2 12c0 4.42 2.87 8.17 6.84 9.5c.5.08.66-.23.66-.5v-1.69c-2.77.6-3.36-1.34-3.36-1.34c-.46-1.16-1.11-1.47-1.11-1.47c-.91-.62.07-.6.07-.6c1 .07 1.53 1.03 1.53 1.03c.87 1.52 2.34 1.07 2.91.83c.09-.65.35-1.09.63-1.34c-2.22-.25-4.55-1.11-4.55-4.92c0-1.11.38-2 1.03-2.71c-.1-.25-.45-1.29.1-2.64c0 0 .84-.27 2.75 1.02c.79-.22 1.65-.33 2.5-.33s1.71.11 2.5.33c1.91-1.29 2.75-1.02 2.75-1.02c.55 1.35.2 2.39.1 2.64c.65.71 1.03 1.6 1.03 2.71c0 3.82-2.34 4.66-4.57 4.91c.36.31.69.92.69 1.85V21c0 .27.16.59.67.5C19.14 20.16 22 16.42 22 12A10 10 0 0 0 12 2"
								></path>
							</svg>
							<span
								style={{
									fontFamily: "GeistSans",
								}}
								tw="flex ml-2"
							>
								github.com/better-auth/better-auth
							</span>
						</div>
					</div>
				</div>
			</div>,
			{
				width: 1200,
				height: 630,
				fonts: [
					{
						name: "Geist",
						data: geist,
						weight: 400,
						style: "normal",
					},
					{
						name: "GeistMono",
						data: geistMono,
						weight: 700,
						style: "normal",
					},
				],
			},
		);
	} catch (err) {
		console.log({ err });
		return new Response("Failed to generate the og image", { status: 500 });
	}
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/api/og-release/route.tsx
```
import { ImageResponse } from "@vercel/og";
import { z } from "zod";
export const runtime = "edge";

const ogSchema = z.object({
	heading: z.string(),
	description: z.string().optional(),
	date: z.string().optional(),
});

export async function GET(req: Request) {
	try {
		const geist = await fetch(
			new URL("../../../assets/Geist.ttf", import.meta.url),
		).then((res) => res.arrayBuffer());

		const url = new URL(req.url);
		const urlParamsValues = Object.fromEntries(url.searchParams);
		const validParams = ogSchema.parse(urlParamsValues);

		const { heading, description, date } = validParams;
		const trueHeading =
			heading.length > 140 ? `${heading.substring(0, 140)}...` : heading;

		return new ImageResponse(
			<div
				tw="flex w-full h-full relative flex-col"
				style={{
					background:
						"radial-gradient(circle 230px at 0% 0%, #000000, #000000)",
					fontFamily: "Geist",
					color: "white",
				}}
			>
				<div
					tw="flex w-full h-full relative"
					style={{
						borderRadius: "10px",
						border: "1px solid rgba(32, 34, 34, 0.5)",
					}}
				>
					<div
						tw="absolute"
						style={{
							width: "350px",
							height: "120px",
							borderRadius: "100px",
							background: "#c7c7c7",
							opacity: 0.21,
							filter: "blur(35px)",
							transform: "rotate(50deg)",
							top: "18%",
							left: "0%",
						}}
					/>

					<div
						tw="flex flex-col w-full relative h-full p-8"
						style={{
							gap: "14px",
							position: "relative",
							zIndex: 999,
						}}
					>
						<div
							tw="absolute bg-repeat w-full h-full"
							style={{
								width: "100%",
								height: "100%",
								zIndex: 999,

								background:
									"url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEuMSIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHhtbG5zOnN2Z2pzPSJodHRwOi8vc3ZnanMuZGV2L3N2Z2pzIiB2aWV3Qm94PSIwIDAgODAwIDgwMCIgd2lkdGg9IjgwMCIgaGVpZ2h0PSI4MDAiPjxnIHN0cm9rZS13aWR0aD0iMy41IiBzdHJva2U9ImhzbGEoMCwgMCUsIDEwMCUsIDEuMDApIiBmaWxsPSJub25lIiBvcGFjaXR5PSIwLjUiPjxyZWN0IHdpZHRoPSI0MDAiIGhlaWdodD0iNDAwIiB4PSIwIiB5PSIwIiBvcGFjaXR5PSIwLjE1Ij48L3JlY3Q+PGNpcmNsZSByPSIxMC44NTUyNjMxNTc4OTQ3MzYiIGN4PSIwIiBjeT0iMCIgZmlsbD0iaHNsYSgwLCAwJSwgMTAwJSwgMS4wMCkiIHN0cm9rZT0ibm9uZSI+PC9jaXJjbGU+PHJlY3Qgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHg9IjQwMCIgeT0iMCIgb3BhY2l0eT0iMC4xNSI+PC9yZWN0PjxjaXJjbGUgcj0iMTAuODU1MjYzMTU3ODk0NzM2IiBjeD0iNDAwIiBjeT0iMCIgZmlsbD0iaHNsYSgwLCAwJSwgMTAwJSwgMS4wMCkiIHN0cm9rZT0ibm9uZSI+PC9jaXJjbGU+PHJlY3Qgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHg9IjgwMCIgeT0iMCIgb3BhY2l0eT0iMC4xNSI+PC9yZWN0PjxjaXJjbGUgcj0iMTAuODU1MjYzMTU3ODk0NzM2IiBjeD0iODAwIiBjeT0iMCIgZmlsbD0iaHNsYSgwLCAwJSwgMTAwJSwgMS4wMCkiIHN0cm9rZT0ibm9uZSI+PC9jaXJjbGU+PHJlY3Qgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHg9IjAiIHk9IjQwMCIgb3BhY2l0eT0iMC4xNSI+PC9yZWN0PjxjaXJjbGUgcj0iMTAuODU1MjYzMTU3ODk0NzM2IiBjeD0iMCIgY3k9IjQwMCIgZmlsbD0iaHNsYSgwLCAwJSwgMTAwJSwgMS4wMCkiIHN0cm9rZT0ibm9uZSI+PC9jaXJjbGU+PHJlY3Qgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHg9IjQwMCIgeT0iNDAwIiBvcGFjaXR5PSIwLjE1Ij48L3JlY3Q+PGNpcmNsZSByPSIxMC44NTUyNjMxNTc4OTQ3MzYiIGN4PSI0MDAiIGN5PSI0MDAiIGZpbGw9ImhzbGEoMCwgMCUsIDEwMCUsIDEuMDApIiBzdHJva2U9Im5vbmUiPjwvY2lyY2xlPjxyZWN0IHdpZHRoPSI0MDAiIGhlaWdodD0iNDAwIiB4PSI4MDAiIHk9IjQwMCIgb3BhY2l0eT0iMC4xNSI+PC9yZWN0PjxjaXJjbGUgcj0iMTAuODU1MjYzMTU3ODk0NzM2IiBjeD0iODAwIiBjeT0iNDAwIiBmaWxsPSJoc2xhKDAsIDAlLCAxMDAlLCAxLjAwKSIgc3Ryb2tlPSJub25lIj48L2NpcmNsZT48cmVjdCB3aWR0aD0iNDAwIiBoZWlnaHQ9IjQwMCIgeD0iMCIgeT0iODAwIiBvcGFjaXR5PSIwLjE1Ij48L3JlY3Q+PGNpcmNsZSByPSIxMC44NTUyNjMxNTc4OTQ3MzYiIGN4PSIwIiBjeT0iODAwIiBmaWxsPSJoc2xhKDAsIDAlLCAxMDAlLCAxLjAwKSIgc3Ryb2tlPSJub25lIj48L2NpcmNsZT48cmVjdCB3aWR0aD0iNDAwIiBoZWlnaHQ9IjQwMCIgeD0iNDAwIiB5PSI4MDAiIG9wYWNpdHk9IjAuMTUiPjwvcmVjdD48Y2lyY2xlIHI9IjEwLjg1NTI2MzE1Nzg5NDczNiIgY3g9IjQwMCIgY3k9IjgwMCIgZmlsbD0iaHNsYSgwLCAwJSwgMTAwJSwgMS4wMCkiIHN0cm9rZT0ibm9uZSI+PC9jaXJjbGU+PHJlY3Qgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHg9IjgwMCIgeT0iODAwIiBvcGFjaXR5PSIwLjE1Ij48L3JlY3Q+PGNpcmNsZSByPSIxMC44NTUyNjM1NTc4OTQ3MzYiIGN4PSI4MDAiIGN5PSI4MDAiIGZpbGw9ImhzbGEoMCwgMCUsIDEwMCUsIDEuMDApIiBzdHJva2U9Im5vbmUiPjwvY2lyY2xlPjwvZz48L3N2Zz4=')",
								backgroundSize: "25px 25px",
								display: "flex",
								alignItems: "flex-start",
								justifyContent: "flex-start",
								position: "relative",
								flexDirection: "column",
								textAlign: "left",
								paddingLeft: "170px",
								gap: "14px",
							}}
						/>
						<div
							tw="flex text-6xl absolute bottom-56 isolate font-bold"
							style={{
								paddingLeft: "170px",
								paddingTop: "200px",
								background: "linear-gradient(45deg, #000000 4%, #fff, #000)",
								backgroundClip: "text",
								color: "transparent",
							}}
						>
							{trueHeading}
						</div>

						<div
							tw="flex absolute bottom-44 z-[999] text-2xl"
							style={{
								paddingLeft: "170px",
								background:
									"linear-gradient(10deg, #d4d4d8, 04%, #fff, #d4d4d8)",
								backgroundClip: "text",
								opacity: 0.7,
								color: "transparent",
							}}
						>
							{description}
						</div>

						<div
							tw="flex text-2xl absolute bottom-28 z-[999]"
							style={{
								paddingLeft: "170px",
								background:
									"linear-gradient(10deg, #d4d4d8, 04%, #fff, #d4d4d8)",
								backgroundClip: "text",
								opacity: 0.8,
								color: "transparent",
							}}
						>
							{date}
						</div>
					</div>

					{/* Lines */}
					<div
						tw="absolute top-10% w-full h-px"
						style={{
							background: "linear-gradient(90deg, #888888 30%, #1d1f1f 70%)",
						}}
					/>
					<div
						tw="absolute bottom-10% w-full h-px"
						style={{
							background: "#2c2c2c",
						}}
					/>
					<div
						tw="absolute left-10% h-full w-px"
						style={{
							background: "linear-gradient(180deg, #747474 30%, #222424 70%)",
						}}
					/>
					<div
						tw="absolute right-10% h-full w-px"
						style={{
							background: "#2c2c2c",
						}}
					/>
				</div>
			</div>,
			{
				width: 1200,
				height: 630,
				fonts: [
					{
						name: "Geist",
						data: geist,
						weight: 400,
						style: "normal",
					},
				],
			},
		);
	} catch (err) {
		console.log({ err });
		return new Response("Failed to generate the OG image", { status: 500 });
	}
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/community/page.tsx
```
import CommunityHeader from "./_components/header";
import Stats from "./_components/stats";
import Section from "@/components/landing/section";
type NpmPackageResp = {
	downloads: number;
	start: string;
	end: string;
	package: string;
};
async function getNPMPackageDownloads() {
	const res = await fetch(
		`https://api.npmjs.org/downloads/point/last-year/better-auth`,
		{
			next: { revalidate: 60 },
		},
	);

	const npmStat: NpmPackageResp = await res.json();
	return npmStat;
}
async function getGitHubStars() {
	try {
		const response = await fetch(
			"https://api.github.com/repos/better-auth/better-auth",
			{
				next: {
					revalidate: 60,
				},
			},
		);
		if (!response?.ok) {
			return null;
		}
		const json = await response.json();
		const stars = parseInt(json.stargazers_count).toLocaleString();
		return stars;
	} catch {
		return null;
	}
}
export default async function CommunityPage() {
	const npmDownloads = await getNPMPackageDownloads();
	return (
		<Section
			id="hero"
			className="relative md:px-[3.4rem] md:pl-[3.9rem] md:max-w-7xl md:mx-auto overflow-hidden"
			crosses={false}
			crossesOffset=""
			customPaddings
		>
			<div className="min-h-screen w-full bg-transparent">
				<div className="overflow-hidden flex flex-col w-full bg-transparent/10 relative">
					<div className="h-[45vh]">
						<CommunityHeader />
					</div>
					<div className="relative py-0">
						<div className="absolute inset-0 z-0">
							<div className="grid grid-cols-12 h-full">
								{Array(12)
									.fill(null)
									.map((_, i) => (
										<div
											key={i}
											className="border-l border-dashed border-stone-100 dark:border-white/10 h-full"
										/>
									))}
							</div>
							<div className="grid grid-rows-12 w-full absolute top-0">
								{Array(12)
									.fill(null)
									.map((_, i) => (
										<div
											key={i}
											className="border-t border-dashed border-stone-100 dark:border-stone-900/60 w-full"
										/>
									))}
							</div>
						</div>
					</div>
					<div className="w-full md:mx-auto overflow-hidden">
						<Stats npmDownloads={npmDownloads.downloads} />
					</div>
				</div>
			</div>
		</Section>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/community/_components/header.tsx
```
import { IconLink } from "@/app/changelogs/_components/changelog-layout";
import { GitHubIcon, XIcon } from "@/app/changelogs/_components/icons";
export default function CommunityHeader() {
	return (
		<div className="h-full flex flex-col justify-center items-center text-white">
			<div className="max-w-6xl mx-auto px-4 py-16">
				<div className="text-center mb-16">
					<h1 className="text-4xl tracking-tighter md:text-5xl mt-3 font-normal mb-6 text-stone-800 dark:text-white">
						Open Source Community
					</h1>
					<p className="dark:text-gray-400 max-w-md mx-auto text-stone-800">
						join <span className="italic font-bold">better-auth</span> community
						to get help, share ideas, and stay up-to-date.
					</p>
					<div className="flex justify-center items-center mt-6 space-x-6">
						<IconLink
							href="https://x.com/better_auth"
							icon={XIcon}
							className="flex-none text-gray-600 dark:text-gray-300"
						>
							X (formerly Twitter)
						</IconLink>
						<IconLink
							href="https://github.com/better-auth/better-auth"
							icon={GitHubIcon}
							className="flex-none text-gray-600 dark:text-gray-300"
						>
							GitHub
						</IconLink>
					</div>
				</div>
			</div>
		</div>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/community/_components/stats.tsx
```
"use client";
import { ArrowUpRight } from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { kFormatter } from "@/lib/utils";
export default function Stats({ npmDownloads }: { npmDownloads: number }) {
	return (
		<div className="relative">
			<div className="md:mx-auto w-full">
				<div className="border border-input rounded-none overflow-hidden border-l-0 border-r-0">
					<div className="grid grid-cols-1 md:grid-cols-3 divide-y md:divide-y-0 md:divide-x divide-input">
						<div className="flex pt-5 dark:[box-shadow:0_-20px_80px_-20px_#dfbf9f1f_inset] flex-col items-center justify-between">
							<div className="relative flex flex-col p-3">
								<div className="inline-flex dark:[border:1px_solid_rgba(255,255,255,.1)] dark:[box-shadow:0_-20px_80px_-20px_#8686f01f_inset] border rounded-full items-center justify-center p-1 w-[4.0em] h-[4.0em] mx-auto mb-4">
									<svg
										xmlns="http://www.w3.org/2000/svg"
										width="4em"
										height="4em"
										viewBox="0 0 24 24"
										className="my-2"
									>
										<path
											fill="currentColor"
											d="M19.27 5.33C17.94 4.71 16.5 4.26 15 4a.1.1 0 0 0-.07.03c-.18.33-.39.76-.53 1.09a16.1 16.1 0 0 0-4.8 0c-.14-.34-.35-.76-.54-1.09c-.01-.02-.04-.03-.07-.03c-1.5.26-2.93.71-4.27 1.33c-.01 0-.02.01-.03.02c-2.72 4.07-3.47 8.03-3.1 11.95c0 .02.01.04.03.05c1.8 1.32 3.53 2.12 5.24 2.65c.03.01.06 0 .07-.02c.4-.55.76-1.13 1.07-1.74c.02-.04 0-.08-.04-.09c-.57-.22-1.11-.48-1.64-.78c-.04-.02-.04-.08-.01-.11c.11-.08.22-.17.33-.25c.02-.02.05-.02.07-.01c3.44 1.57 7.15 1.57 10.55 0c.02-.01.05-.01.07.01c.11.09.22.17.33.26c.04.03.04.09-.01.11c-.52.31-1.07.56-1.64.78c-.04.01-.05.06-.04.09c.32.61.68 1.19 1.07 1.74c.03.01.06.02.09.01c1.72-.53 3.45-1.33 5.25-2.65c.02-.01.03-.03.03-.05c.44-4.53-.73-8.46-3.1-11.95c-.01-.01-.02-.02-.04-.02M8.52 14.91c-1.03 0-1.89-.95-1.89-2.12s.84-2.12 1.89-2.12c1.06 0 1.9.96 1.89 2.12c0 1.17-.84 2.12-1.89 2.12m6.97 0c-1.03 0-1.89-.95-1.89-2.12s.84-2.12 1.89-2.12c1.06 0 1.9.96 1.89 2.12c0 1.17-.83 2.12-1.89 2.12"
										></path>
									</svg>
								</div>
								<span className="text-xl uppercase tracking-tighter font-bold font-mono bg-gradient-to-b dark:from-stone-200 dark:via-stone-400 dark:to-stone-700 bg-clip-text text-transparent drop-shadow-[0_0_10px_rgba(255,255,255,0.1)] from-stone-800 via-stone-600 to-stone-400">
									Discord
								</span>
							</div>

							<div className="flex items-end  w-full gap-2 mt-4 text-gray-400">
								<Link
									className="w-full"
									href="https://discord.gg/Mh3DaacaFs"
									target="_blank"
								>
									<Button
										variant="outline"
										className="group duration-500 cursor-pointer text-gray-400 flex items-center gap-2 text-md hover:bg-transparent border-l-input/50 border-r-input/50 md:border-r-0 md:border-l-0 border-t-[1px] border-t-input py-7 w-full hover:text-white"
									>
										<span className="uppercase font-mono">
											Join Our Discord
										</span>
										<ArrowUpRight className="w-6 h-6 opacity-20 ml-2 group-hover:opacity-100 text-black group-hover:duration-700 dark:text-white" />
									</Button>
								</Link>
							</div>
						</div>

						<div className="flex pt-5 w-full dark:[box-shadow:0_-20px_80px_-20px_#dfbf9f1f_inset] flex-col items-center justify-between">
							<div className="relative p-3">
								<span className="text-[70px] tracking-tighter font-bold font-mono bg-gradient-to-b dark:from-stone-200 dark:via-stone-400 dark:to-stone-700 bg-clip-text text-transparent drop-shadow-[0_0_10px_rgba(255,255,255,0.1)] from-stone-800 via-stone-600 to-stone-400">
									{parseInt(kFormatter(npmDownloads) as string)}k+
								</span>
							</div>
							<div className="flex -p-8 items-end w-full gap-2 mt-4 text-gray-400">
								<Link
									className="w-full"
									href="https://www.npmjs.com/package/better-auth"
									target="_blank"
								>
									<Button
										variant="outline"
										className="group duration-500 cursor-pointer text-gray-400 flex items-center gap-2 text-md hover:bg-transparent  border-l-input/50 border-r-input/50 md:border-r-0 md:border-l-0 border-t-[1px] border-t-input py-7 w-full hover:text-white"
									>
										<svg
											xmlns="http://www.w3.org/2000/svg"
											width="1.5em"
											height="1.5em"
											viewBox="0 0 128 128"
										>
											<path
												fill="#000"
												d="M0 7.062C0 3.225 3.225 0 7.062 0h113.88c3.838 0 7.063 3.225 7.063 7.062v113.88c0 3.838-3.225 7.063-7.063 7.063H7.062c-3.837 0-7.062-3.225-7.062-7.063zm23.69 97.518h40.395l.05-58.532h19.494l-.05 58.581h19.543l.05-78.075l-78.075-.1l-.1 78.126z"
											></path>
											<path
												fill="#fff"
												d="M25.105 65.52V26.512H40.96c8.72 0 26.274.034 39.008.075l23.153.075v77.866H83.645v-58.54H64.057v58.54H25.105z"
											></path>
										</svg>
										<span className="uppercase font-mono">Downloads</span>
										<ArrowUpRight className="w-6 h-6 opacity-20 ml-2 group-hover:opacity-100 text-black group-hover:duration-700 dark:text-white" />
									</Button>
								</Link>
							</div>
						</div>

						<div className="flex pt-5 dark:[box-shadow:0_-20px_80px_-20px_#dfbf9f1f_inset] flex-col items-center justify-between">
							<div className="relative flex flex-col p-3">
								<div className="inline-flex dark:[border:1px_solid_rgba(255,255,255,.1)] dark:[box-shadow:0_-20px_80px_-20px_#8686f01f_inset] border rounded-full items-center justify-center p-1 w-[4.0em] h-[4.0em] mx-auto mb-4">
									<svg
										xmlns="http://www.w3.org/2000/svg"
										width="4em"
										height="4em"
										viewBox="0 0 24 24"
										className="my-2"
									>
										<path
											fill="currentColor"
											d="M10.75 13.04c0-.57-.47-1.04-1.04-1.04s-1.04.47-1.04 1.04a1.04 1.04 0 1 0 2.08 0m3.34 2.37c-.45.45-1.41.61-2.09.61s-1.64-.16-2.09-.61a.26.26 0 0 0-.38 0a.26.26 0 0 0 0 .38c.71.71 2.07.77 2.47.77s1.76-.06 2.47-.77a.26.26 0 0 0 0-.38c-.1-.1-.27-.1-.38 0m.2-3.41c-.57 0-1.04.47-1.04 1.04s.47 1.04 1.04 1.04s1.04-.47 1.04-1.04S14.87 12 14.29 12"
										></path>
										<path
											fill="currentColor"
											d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10s10-4.48 10-10S17.52 2 12 2m5.8 11.33c.02.14.03.29.03.44c0 2.24-2.61 4.06-5.83 4.06s-5.83-1.82-5.83-4.06c0-.15.01-.3.03-.44c-.51-.23-.86-.74-.86-1.33a1.455 1.455 0 0 1 2.47-1.05c1.01-.73 2.41-1.19 3.96-1.24l.74-3.49c.01-.07.05-.13.11-.16c.06-.04.13-.05.2-.04l2.42.52a1.04 1.04 0 1 1 .93 1.5c-.56 0-1.01-.44-1.04-.99l-2.17-.46l-.66 3.12c1.53.05 2.9.52 3.9 1.24a1.455 1.455 0 1 1 1.6 2.38"
										></path>
									</svg>
								</div>
								<span className="text-xl uppercase tracking-tighter font-bold font-mono bg-gradient-to-b dark:from-stone-200 dark:via-stone-400 dark:to-stone-700 bg-clip-text text-transparent drop-shadow-[0_0_10px_rgba(255,255,255,0.1)] from-stone-800 via-stone-600 to-stone-400">
									Reddit
								</span>
							</div>
							<div className="flex items-end w-full gap-2 mt-4 text-gray-400">
								<Link
									className="w-full"
									href="https://reddit.com/r/better_auth"
									target="_blank"
								>
									<Button
										variant="outline"
										className="group duration-500 cursor-pointer text-gray-400 flex items-center gap-2 text-md hover:bg-transparent border-l-input/50 border-r-input/50 md:border-r-0 md:border-l-0  border-t-[1px] border-t-input py-7 w-full hover:text-white"
									>
										<span className="uppercase font-mono">Join Subreddit</span>
										<ArrowUpRight className="w-6 h-6 opacity-20 ml-2 group-hover:opacity-100 text-black group-hover:duration-700 dark:text-white" />
									</Button>
								</Link>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/docs/app/reference/route.ts
```typescript
import { ApiReference } from "@scalar/nextjs-api-reference";

const config = {
	spec: {
		url: "/openapi.yml",
	},
};

export const GET = ApiReference(config);

```
