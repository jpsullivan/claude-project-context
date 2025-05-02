/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/toggle.stories.ts
```typescript
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideItalic } from '@ng-icons/lucide';
import { BrnToggleDirective } from '@spartan-ng/brain/toggle';
import { type Meta, type StoryObj, moduleMetadata } from '@storybook/angular';

import { HlmIconDirective } from '../icon/helm/src';
import { HlmToggleDirective } from './helm/src';

const meta: Meta<HlmToggleDirective> = {
	title: 'Toggle',
	component: HlmToggleDirective,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [HlmToggleDirective, BrnToggleDirective, NgIcon, HlmIconDirective],
			providers: [provideIcons({ lucideItalic })],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmToggleDirective>;

export const Default: Story = {
	render: () => ({
		template: `
    <div class='space-x-3'>
    <button aria-label='Italic Toggle' size='sm' hlmToggle><ng-icon hlm name='lucideItalic'/></button>
    <button aria-label='Italic Toggle' hlmToggle><ng-icon hlm name='lucideItalic'/></button>
    <button aria-label='Italic Toggle' size='lg' hlmToggle><ng-icon hlm name='lucideItalic'/></button>
    <button aria-label='Italic Toggle' variant='outline' hlmToggle><ng-icon hlm name='lucideItalic'/></button>
    <button aria-label='Italic Toggle' disabled hlmToggle><ng-icon hlm name='lucideItalic'/></button>
    </div>
    `,
	}),
};

export const WithText: Story = {
	name: 'With Text',
	render: () => ({
		template: `
    <div class='space-x-3'>
    <button size='sm' hlmToggle><ng-icon hlm name='lucideItalic'/> <span class='ml-2'>Italic</span></button>
    <button hlmToggle><ng-icon hlm name='lucideItalic'/> <span class='ml-2'>Italic</span></button>
    <button size='lg' hlmToggle><ng-icon hlm name='lucideItalic'/> <span class='ml-2'>Italic</span></button>
    <button variant='outline' hlmToggle><ng-icon hlm name='lucideItalic'/> <span class='ml-2'>Italic</span></button>
    <button disabled hlmToggle><ng-icon hlm name='lucideItalic'/> <span class='ml-2'>Italic</span></button>
    </div>
`,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/README.md
```
# ui-toggle-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-toggle-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-toggle-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/toggle/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/package.json
```json
{
	"name": "@spartan-ng/ui-toggle-helm",
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/project.json
```json
{
	"name": "ui-toggle-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/toggle/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/toggle/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/toggle/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/toggle/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/toggle/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-toggle-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmToggleDirective } from './lib/hlm-toggle.directive';

export * from './lib/hlm-toggle.directive';
@NgModule({
	imports: [HlmToggleDirective],
	exports: [HlmToggleDirective],
})
export class HlmToggleModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/src/lib/hlm-toggle.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { cva, type VariantProps } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const toggleVariants = cva(
	'inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors hover:bg-muted hover:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=on]:bg-accent data-[state=on]:text-accent-foreground',
	{
		variants: {
			variant: {
				default: 'bg-transparent',
				outline: 'border border-input bg-transparent hover:bg-accent hover:text-accent-foreground',
			},
			size: {
				default: 'h-9 px-3',
				sm: 'h-8 px-2',
				lg: 'h-10 px-3',
			},
		},
		defaultVariants: {
			variant: 'default',
			size: 'default',
		},
	},
);
export type ToggleVariants = VariantProps<typeof toggleVariants>;

@Directive({
	selector: '[hlmToggle],[brnToggle][hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmToggleDirective {
	public readonly variant = input<ToggleVariants['variant']>('default');
	public readonly size = input<ToggleVariants['size']>('default');
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => {
		const variantToUse = this.variant();
		const sizeToUse = this.size();
		const userClass = this.userClass();

		return hlm(
			toggleVariants({
				variant: variantToUse,
				size: sizeToUse,
			}),
			userClass,
		);
	});
}

```
