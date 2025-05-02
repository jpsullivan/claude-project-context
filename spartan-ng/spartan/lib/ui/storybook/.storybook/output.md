/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/storybook/.storybook/main.js
```javascript
const config = {
	stories: ['../../**/*.@(mdx|stories.@(js|jsx|ts|tsx))'],
	addons: ['@storybook/addon-essentials', '@storybook/addon-a11y', '@storybook/addon-themes'],

	framework: {
		name: '@storybook/angular',
		options: {},
	},

	//👈 Configures the static asset folder in Storybook
	staticDirs: ['../public'],

	docs: {},
};

export default config;

// To customize your webpack configuration you can use the webpackFinal field.
// Check https://storybook.js.org/docs/react/builders/webpack#extending-storybooks-webpack-config
// and https://nx.dev/packages/storybook/documents/custom-builder-configs

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/storybook/.storybook/preview.js
```javascript
import { withThemeByClassName } from '@storybook/addon-themes';

export const decorators = [
	withThemeByClassName({
		themes: {
			light: 'light',
			dark: 'dark',
		},
		defaultTheme: 'light',
	}),
];

const preview = {
	decorators,

	parameters: {
		options: {
			storySort: {
				method: 'alphabetical',
			},
		},
	},

	tags: ['autodocs'],
};

export default preview;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/storybook/.storybook/tailwind.css
```css
@import '@angular/cdk/overlay-prebuilt.css';

@tailwind base;
@tailwind components;
@tailwind utilities;

.sb-story {
	@apply bg-background;
}

select {
	background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='M6 8l4 4 4-4'/%3e%3c/svg%3e");
	background-position: right 0.5rem center;
	background-repeat: no-repeat;
	background-size: 1.5em 1.5em;
	-webkit-print-color-adjust: exact;
	appearance: none;
	display: inline-flex;
	text-align: center;
	justify-content: center;
	align-items: center;
}

:root {
	--background: 0 0% 100%;
	--foreground: 240 10% 3.9%;
	--font-sans: '';
	--muted: 240 4.8% 95.9%;
	--muted-foreground: 240 3.8% 46.1%;
	--popover: 0 0% 100%;
	--popover-foreground: 240 10% 3.9%;
	--card: 0 0% 100%;
	--card-foreground: 240 10% 3.9%;
	--border: 240 5.9% 90%;
	--input: 240 5.9% 90%;
	--primary: 240 5.9% 10%;
	--primary-foreground: 0 0% 98%;
	--secondary: 240 4.8% 95.9%;
	--secondary-foreground: 240 5.9% 10%;
	--accent: 240 4.8% 95.9%;
	--accent-foreground: 240 5.9% 10%;
	--destructive: 0 84.2% 60.2%;
	--destructive-foreground: 0 0% 98%;
	--ring: 240 5% 64.9%;
	--radius: 0.5rem;
	color-scheme: light;
}

.dark,
[data-mode='dark'] {
	--background: 240 10% 3.9%;
	--foreground: 0 0% 98%;
	--font-sans: '';
	--muted: 240 3.7% 15.9%;
	--muted-foreground: 240 5% 64.9%;
	--popover: 240 10% 3.9%;
	--popover-foreground: 0 0% 98%;
	--card: 240 10% 3.9%;
	--card-foreground: 0 0% 98%;
	--border: 240 3.7% 15.9%;
	--input: 240 3.7% 15.9%;
	--primary: 0 0% 98%;
	--primary-foreground: 240 5.9% 10%;
	--secondary: 240 3.7% 15.9%;
	--secondary-foreground: 0 0% 98%;
	--accent: 240 3.7% 15.9%;
	--accent-foreground: 0 0% 98%;
	--destructive: 0 62.8% 30.6%;
	--destructive-foreground: 0 85.7% 97.3%;
	--ring: 240 3.7% 15.9%;
	color-scheme: dark;
}

@layer base {
	* {
		@apply border-border;
	}
	body {
		@apply font-sans antialiased bg-background text-foreground;
		font-feature-settings: 'rlig' 1, 'calt' 1;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/storybook/.storybook/tsconfig.json
```json
{
	"extends": "../tsconfig.json",
	"compilerOptions": {
		"emitDecoratorMetadata": true
	},

	"exclude": ["../../**/*.spec.ts"],
	"include": [
		"../../**/*.stories.ts",
		"../../**/*.stories.js",
		"../../**/*.stories.jsx",
		"../../**/*.stories.tsx",
		"../../**/*.stories.mdx",
		"*.js"
	]
}

```
