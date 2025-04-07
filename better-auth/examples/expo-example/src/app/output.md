/Users/josh/Documents/GitHub/better-auth/better-auth/examples/expo-example/src/app/_layout.tsx
```
import { Slot } from "expo-router";
import "../global.css";
import { SafeAreaProvider } from "react-native-safe-area-context";
import { ImageBackground, View } from "react-native";
import { StyleSheet } from "react-native";

export default function RootLayout() {
	return (
		<SafeAreaProvider>
			<ImageBackground
				className="z-0 flex items-center justify-center"
				source={require("../../assets/bg-image.jpeg")}
				resizeMode="cover"
				style={{
					...(StyleSheet.absoluteFill as any),
					width: "100%",
				}}
			>
				<View
					style={{
						position: "absolute",
						top: 0,
						left: 0,
						right: 0,
						bottom: 0,
						backgroundColor: "black",
						opacity: 0.2,
					}}
				/>
				<Slot />
			</ImageBackground>
		</SafeAreaProvider>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/expo-example/src/app/dashboard.tsx
```
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { Card, CardFooter, CardHeader } from "@/components/ui/card";
import { Text } from "@/components/ui/text";
import { authClient } from "@/lib/auth-client";
import { View } from "react-native";
import Ionicons from "@expo/vector-icons/AntDesign";
import { router } from "expo-router";
import { useEffect } from "react";

export default function Dashboard() {
	const { data: session, isPending } = authClient.useSession();
	useEffect(() => {
		if (!session && !isPending) {
			router.push("/");
		}
	}, [session, isPending]);
	return (
		<Card className="w-10/12">
			<CardHeader>
				<View className="flex-row items-center gap-2">
					<Avatar alt="user-image">
						<AvatarImage
							source={{
								uri: session?.user?.image || "",
							}}
						/>
						<AvatarFallback>
							<Text>{session?.user?.name[0]}</Text>
						</AvatarFallback>
					</Avatar>
					<View>
						<Text className="font-bold">{session?.user?.name}</Text>
						<Text className="text-sm">{session?.user?.email}</Text>
					</View>
				</View>
			</CardHeader>
			<CardFooter className="justify-between">
				<Button
					variant="default"
					size="sm"
					className="flex-row items-center gap-2	"
				>
					<Ionicons name="edit" size={16} color="white" />
					<Text>Edit User</Text>
				</Button>
				<Button
					variant="secondary"
					className="flex-row items-center gap-2"
					size="sm"
					onPress={async () => {
						await authClient.signOut({
							fetchOptions: {
								onSuccess: () => {
									router.push("/");
								},
							},
						});
					}}
				>
					<Ionicons name="logout" size={14} color="black" />
					<Text>Sign Out</Text>
				</Button>
			</CardFooter>
		</Card>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/expo-example/src/app/forget-password.tsx
```
import { Button } from "@/components/ui/button";
import {
	Card,
	CardDescription,
	CardFooter,
	CardHeader,
	CardTitle,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Text } from "@/components/ui/text";
import { authClient } from "@/lib/auth-client";
import { useState } from "react";
import { View } from "react-native";
import Icons from "@expo/vector-icons/AntDesign";
import { router } from "expo-router";

export default function ForgetPassword() {
	const [email, setEmail] = useState("");
	return (
		<Card className="w-10/12 ">
			<CardHeader>
				<CardTitle>Forget Password</CardTitle>
				<CardDescription>
					Enter your email to reset your password
				</CardDescription>
			</CardHeader>
			<View className="px-6 mb-2">
				<Input
					autoCapitalize="none"
					placeholder="Email"
					value={email}
					onChangeText={(text) => setEmail(text)}
				/>
			</View>
			<CardFooter>
				<View className="w-full gap-2">
					<Button
						onPress={() => {
							authClient.forgetPassword({
								email,
								redirectTo: "/reset-password",
							});
						}}
						className="w-full"
						variant="default"
					>
						<Text>Send Email</Text>
					</Button>
					<Button
						onPress={() => {
							router.push("/");
						}}
						className="w-full flex-row gap-4 items-center"
						variant="outline"
					>
						<Icons name="arrowleft" size={18} />
						<Text>Back to Sign In</Text>
					</Button>
				</View>
			</CardFooter>
		</Card>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/expo-example/src/app/index.tsx
```
import Ionicons from "@expo/vector-icons/AntDesign";
import { Button } from "@/components/ui/button";
import { Card, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Text } from "@/components/ui/text";
import { authClient } from "@/lib/auth-client";
import { Image, View } from "react-native";
import { Separator } from "@/components/ui/separator";
import { Input } from "@/components/ui/input";
import { useEffect, useState } from "react";
import { router, useNavigationContainerRef } from "expo-router";

export default function Index() {
	const { data: isAuthenticated } = authClient.useSession();
	const navContainerRef = useNavigationContainerRef();
	const [email, setEmail] = useState("");
	const [password, setPassword] = useState("");

	useEffect(() => {
		if (isAuthenticated) {
			if (navContainerRef.isReady()) {
				router.push("/dashboard");
			}
		}
	}, [isAuthenticated, navContainerRef.isReady()]);
	return (
		<Card className="z-50 mx-6 backdrop-blur-lg bg-gray-200/70">
			<CardHeader className="flex items-center justify-center gap-8">
				<Image
					source={require("../../assets/images/logo.png")}
					style={{
						width: 40,
						height: 40,
					}}
				/>
				<CardTitle>Sign In to your account</CardTitle>
			</CardHeader>
			<View className="px-6 flex gap-2">
				<Button
					onPress={() => {
						authClient.signIn.social({
							provider: "google",
							callbackURL: "/dashboard",
						});
					}}
					variant="secondary"
					className="flex flex-row gap-2 items-center bg-white/50"
				>
					<Ionicons name="google" size={16} />
					<Text>Sign In with Google</Text>
				</Button>
				<Button
					variant="secondary"
					className="flex flex-row gap-2 items-center bg-white/50"
					onPress={() => {
						authClient.signIn.social({
							provider: "github",
							callbackURL: "/dashboard",
						});
					}}
				>
					<Ionicons name="github" size={16} />
					<Text>Sign In with Github</Text>
				</Button>
			</View>
			<View className="flex-row gap-2 w-full items-center px-6 my-4">
				<Separator className="flex-grow w-3/12" />
				<Text>or continue with</Text>
				<Separator className="flex-grow w-3/12" />
			</View>
			<View className="px-6">
				<Input
					placeholder="Email Address"
					className="rounded-b-none border-b-0"
					value={email}
					onChangeText={(text) => {
						setEmail(text);
					}}
				/>
				<Input
					placeholder="Password"
					className="rounded-t-none"
					secureTextEntry
					value={password}
					onChangeText={(text) => {
						setPassword(text);
					}}
				/>
			</View>
			<CardFooter>
				<View className="w-full">
					<Button
						variant="link"
						className="w-full"
						onPress={() => {
							router.push("/forget-password");
						}}
					>
						<Text className="underline text-center">Forget Password?</Text>
					</Button>
					<Button
						onPress={() => {
							authClient.signIn.email(
								{
									email,
									password,
								},
								{
									onError: (ctx) => {
										alert(ctx.error.message);
									},
								},
							);
						}}
					>
						<Text>Continue</Text>
					</Button>
					<Text className="text-center mt-2">
						Don't have an account?{" "}
						<Text
							className="underline"
							onPress={() => {
								router.push("/sign-up");
							}}
						>
							Create Account
						</Text>
					</Text>
				</View>
			</CardFooter>
		</Card>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/expo-example/src/app/sign-up.tsx
```
import { Button } from "@/components/ui/button";
import { Card, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Text } from "@/components/ui/text";
import { authClient } from "@/lib/auth-client";
import { KeyboardAvoidingView, View } from "react-native";
import { Image } from "react-native";
import { useRouter } from "expo-router";
import { useState } from "react";

export default function SignUp() {
	const router = useRouter();
	const [email, setEmail] = useState("");
	const [password, setPassword] = useState("");
	const [name, setName] = useState("");
	return (
		<Card className="z-50 mx-6">
			<CardHeader className="flex items-center justify-center gap-8">
				<Image
					source={require("../../assets/images/logo.png")}
					style={{
						width: 40,
						height: 40,
					}}
				/>
				<CardTitle>Create new Account</CardTitle>
			</CardHeader>
			<View className="px-6">
				<KeyboardAvoidingView>
					<Input
						placeholder="Name"
						className="rounded-b-none border-b-0"
						value={name}
						onChangeText={(text) => {
							setName(text);
						}}
					/>
				</KeyboardAvoidingView>
				<KeyboardAvoidingView>
					<Input
						placeholder="Email"
						className="rounded-b-none border-b-0"
						value={email}
						onChangeText={(text) => {
							setEmail(text);
						}}
						autoCapitalize="none"
					/>
				</KeyboardAvoidingView>

				<KeyboardAvoidingView>
					<Input
						placeholder="Password"
						secureTextEntry
						className="rounded-t-none"
						value={password}
						onChangeText={(text) => {
							setPassword(text);
						}}
					/>
				</KeyboardAvoidingView>
			</View>
			<CardFooter>
				<View className="w-full mt-2">
					<Button
						onPress={async () => {
							const res = await authClient.signUp.email(
								{
									email,
									password,
									name,
								},
								{
									onError: (ctx) => {
										alert(ctx.error.message);
									},
									onSuccess: (ctx) => {
										router.push("/dashboard");
									},
								},
							);
							console.log(res);
						}}
					>
						<Text>Sign Up</Text>
					</Button>
					<Text className="text-center mt-2">
						Already have an account?{" "}
						<Text
							className="underline"
							onPress={() => {
								router.push("/");
							}}
						>
							Sign In
						</Text>
					</Text>
				</View>
			</CardFooter>
		</Card>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/expo-example/src/app/api/auth/[...route]+api.ts
```typescript
import { auth } from "@/lib/auth";

export const GET = (request: Request) => {
	return auth.handler(request);
};

export const POST = (request: Request) => {
	return auth.handler(request);
};

```
