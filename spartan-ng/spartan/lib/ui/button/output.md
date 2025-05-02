/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/button.stories.ts
```typescript
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from './helm/src';

const meta: Meta<HlmButtonDirective> = {
	title: 'Button',
	component: HlmButtonDirective,
	tags: ['autodocs'],
	args: {
		variant: 'default',
		size: 'default',
	},
	argTypes: {
		variant: {
			options: ['default', 'destructive', 'outline', 'secondary', 'ghost', 'link'],
			control: {
				type: 'select',
			},
		},
		size: {
			options: ['default', 'sm', 'lg', 'icon'],
			control: {
				type: 'select',
			},
		},
	},
	decorators: [
		moduleMetadata({
			imports: [HlmButtonDirective],
		}),
	],
	render: ({ ...args }) => ({
		props: args,
		template: `<button hlmBtn ${argsToTemplate(args)}>Click me</button>`,
	}),
};

export default meta;
type Story = StoryObj<HlmButtonDirective>;

export const Default: Story = {
	args: {
		variant: 'default',
		size: 'default',
	},
};

export const Destructive: Story = {
	args: {
		variant: 'destructive',
		size: 'default',
	},
};

export const Outline: Story = {
	args: {
		variant: 'outline',
		size: 'default',
	},
};

export const Secondary: Story = {
	args: {
		variant: 'secondary',
		size: 'default',
	},
};

export const Ghost: Story = {
	args: {
		variant: 'ghost',
		size: 'default',
	},
};

export const Link: Story = {
	args: {
		variant: 'link',
		size: 'default',
	},
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/README.md
```
# ui-button-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-button-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/eslint.config.js
```javascript
const nx = require('@nx/eslint-plugin');
const baseConfig = require('../../../../eslint.config.cjs');

module.exports = [
	...baseConfig,
	...nx.configs['flat/angular'],
	...nx.configs['flat/angular-template'],
	{
		files: ['**/*.ts'],
		rules: {
			'@angular-eslint/directive-selector': [
				'error',
				{
					type: 'attribute',
					prefix: 'hlm',
					style: 'camelCase',
				},
			],
			'@angular-eslint/component-selector': [
				'error',
				{
					type: 'element',
					prefix: 'hlm',
					style: 'kebab-case',
				},
			],
			'@angular-eslint/no-input-rename': 'off',
		},
	},
	{
		files: ['**/*.html'],
		// Override or add rules here
		rules: {},
	},
];

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-button-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	transform: {
		'^.+\\.(ts|mjs|js|html)$': [
			'jest-preset-angular',
			{
				tsconfig: '<rootDir>/tsconfig.spec.json',
				stringifyContentPathRegex: '\\.(html|svg)$',
			},
		],
	},
	transformIgnorePatterns: ['node_modules/(?!.*\\.mjs$)'],
	snapshotSerializers: [
		'jest-preset-angular/build/serializers/no-ng-attributes',
		'jest-preset-angular/build/serializers/ng-snapshot',
		'jest-preset-angular/build/serializers/html-comment',
	],
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/button/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/package.json
```json
{
	"name": "@spartan-ng/ui-button-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/project.json
```json
{
	"name": "ui-button-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/button/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/button/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/button/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/button/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/button/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-button-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/tsconfig.json
```json
{
	"compilerOptions": {
		"target": "es2022",
		"useDefineForClassFields": false,
		"forceConsistentCasingInFileNames": true,
		"strict": true,
		"noImplicitOverride": true,
		"noPropertyAccessFromIndexSignature": true,
		"noImplicitReturns": true,
		"noFallthroughCasesInSwitch": true
	},
	"files": [],
	"include": [],
	"references": [
		{
			"path": "./tsconfig.lib.json"
		},
		{
			"path": "./tsconfig.spec.json"
		}
	],
	"extends": "../../../../tsconfig.base.json",
	"angularCompilerOptions": {
		"enableI18nLegacyMessageIdFormat": false,
		"strictInjectionParameters": true,
		"strictInputAccessModifiers": true,
		"strictTemplates": true
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/tsconfig.lib.json
```json
{
	"extends": "./tsconfig.json",
	"compilerOptions": {
		"outDir": "../../../../dist/out-tsc",
		"declaration": true,
		"declarationMap": true,
		"inlineSources": true,
		"types": []
	},
	"exclude": ["src/**/*.spec.ts", "src/test-setup.ts", "jest.config.ts", "src/**/*.test.ts"],
	"include": ["src/**/*.ts"]
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/tsconfig.lib.prod.json
```json
{
	"extends": "./tsconfig.lib.json",
	"compilerOptions": {
		"declarationMap": false
	},
	"angularCompilerOptions": {
		"compilationMode": "partial"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/tsconfig.spec.json
```json
{
	"extends": "./tsconfig.json",
	"compilerOptions": {
		"outDir": "../../../../dist/out-tsc",
		"module": "commonjs",
		"target": "es2016",
		"types": ["jest", "node"]
	},
	"files": ["src/test-setup.ts"],
	"include": ["jest.config.ts", "src/**/*.test.ts", "src/**/*.spec.ts", "src/**/*.d.ts"]
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmButtonDirective } from './lib/hlm-button.directive';
export * from './lib/hlm-button.token';

export * from './lib/hlm-button.directive';

@NgModule({
	imports: [HlmButtonDirective],
	exports: [HlmButtonDirective],
})
export class HlmButtonModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/src/test-setup.ts
```typescript
// @ts-expect-error https://thymikee.github.io/jest-preset-angular/docs/getting-started/test-environment
globalThis.ngJest = {
	testEnvironmentOptions: {
		errorOnUnknownElements: true,
		errorOnUnknownProperties: true,
	},
};
import 'jest-preset-angular/setup-jest';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/src/lib/hlm-button.directive.ts
```typescript
import { Directive, computed, input, signal } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';
import { injectBrnButtonConfig } from './hlm-button.token';

export const buttonVariants = cva(
	'inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none ring-offset-background',
	{
		variants: {
			variant: {
				default: 'bg-primary text-primary-foreground hover:bg-primary/90',
				destructive: 'bg-destructive text-destructive-foreground hover:bg-destructive/90',
				outline: 'border border-input hover:bg-accent hover:text-accent-foreground',
				secondary: 'bg-secondary text-secondary-foreground hover:bg-secondary/80',
				ghost: 'hover:bg-accent hover:text-accent-foreground',
				link: 'underline-offset-4 hover:underline text-primary',
			},
			size: {
				default: 'h-10 py-2 px-4',
				sm: 'h-9 px-3 rounded-md',
				lg: 'h-11 px-8 rounded-md',
				icon: 'h-10 w-10',
			},
		},
		defaultVariants: {
			variant: 'default',
			size: 'default',
		},
	},
);
export type ButtonVariants = VariantProps<typeof buttonVariants>;

@Directive({
	selector: '[hlmBtn]',
	standalone: true,
	exportAs: 'hlmBtn',
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmButtonDirective {
	private readonly _config = injectBrnButtonConfig();

	private readonly _additionalClasses = signal<ClassValue>('');

	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm(buttonVariants({ variant: this.variant(), size: this.size() }), this.userClass(), this._additionalClasses()),
	);

	public readonly variant = input<ButtonVariants['variant']>(this._config.variant);

	public readonly size = input<ButtonVariants['size']>(this._config.size);

	setClass(classes: string): void {
		this._additionalClasses.set(classes);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/src/lib/hlm-button.token.ts
```typescript
import { InjectionToken, ValueProvider, inject } from '@angular/core';
import type { ButtonVariants } from './hlm-button.directive';

export interface BrnButtonConfig {
	variant: ButtonVariants['variant'];
	size: ButtonVariants['size'];
}

const defaultConfig: BrnButtonConfig = {
	variant: 'default',
	size: 'default',
};

const BrnButtonConfigToken = new InjectionToken<BrnButtonConfig>('BrnButtonConfig');

export function provideBrnButtonConfig(config: Partial<BrnButtonConfig>): ValueProvider {
	return { provide: BrnButtonConfigToken, useValue: { ...defaultConfig, ...config } };
}

export function injectBrnButtonConfig(): BrnButtonConfig {
	return inject(BrnButtonConfigToken, { optional: true }) ?? defaultConfig;
}

```
