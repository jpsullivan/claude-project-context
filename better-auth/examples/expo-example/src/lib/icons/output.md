/Users/josh/Documents/GitHub/better-auth/better-auth/examples/expo-example/src/lib/icons/X.tsx
```
import { X } from "lucide-react-native";
import { iconWithClassName } from "./iconWithClassName";
iconWithClassName(X);
export { X };

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/expo-example/src/lib/icons/iconWithClassName.ts
```typescript
import type { LucideIcon } from "lucide-react-native";
import { cssInterop } from "nativewind";

export function iconWithClassName(icon: LucideIcon) {
	cssInterop(icon, {
		className: {
			target: "style",
			nativeStyleToProp: {
				color: true,
				opacity: true,
			},
		},
	});
}

```
