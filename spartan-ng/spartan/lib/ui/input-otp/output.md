/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/input-otp.stories.ts
```typescript
import { BrnInputOtpComponent } from '@spartan-ng/brain/input-otp';
import { type Meta, type StoryObj, moduleMetadata } from '@storybook/angular';
import {
	HlmInputOtpDirective,
	HlmInputOtpGroupDirective,
	HlmInputOtpSeparatorComponent,
	HlmInputOtpSlotComponent,
} from './helm/src/index';

const meta: Meta<BrnInputOtpComponent> = {
	title: 'Input OTP',
	component: BrnInputOtpComponent,
	tags: ['autodocs'],
	args: {},
	argTypes: {},
	decorators: [
		moduleMetadata({
			imports: [
				BrnInputOtpComponent,
				HlmInputOtpDirective,
				HlmInputOtpGroupDirective,
				HlmInputOtpSeparatorComponent,
				HlmInputOtpSlotComponent,
			],
		}),
	],
	render: ({ ...args }) => ({
		props: args,
		template: `
		<brn-input-otp hlm maxLength="6" inputClass="disabled:cursor-not-allowed">
			<div hlmInputOtpGroup>
				<hlm-input-otp-slot index="0" />
				<hlm-input-otp-slot index="1" />
				<hlm-input-otp-slot index="2" />
			</div>
			<hlm-input-otp-separator />
			<div hlmInputOtpGroup>
				<hlm-input-otp-slot index="3" />
				<hlm-input-otp-slot index="4" />
				<hlm-input-otp-slot index="5" />
			</div>
		</brn-input-otp>
		`,
	}),
};

export default meta;

type Story = StoryObj<BrnInputOtpComponent>;

export const Default: Story = {
	args: {},
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/README.md
```
# ui-input-otp-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-input-otp-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-input-otp-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/button/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/input-otp/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/package.json
```json
{
	"name": "@spartan-ng/ui-input-otp-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"peerDependencies": {
		"@angular/cdk": "19.2.2",
		"@angular/core": ">=19.0.0",
		"@ng-icons/core": "29.10.0",
		"@ng-icons/lucide": "30.3.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/project.json
```json
{
	"name": "ui-input-otp-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/input-otp/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/input-otp/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/input-otp/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/input-otp/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/input-otp/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-input-otp-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmInputOtpFakeCaretComponent } from './lib/hlm-input-otp-fake-caret.component';
import { HlmInputOtpGroupDirective } from './lib/hlm-input-otp-group.directive';
import { HlmInputOtpSeparatorComponent } from './lib/hlm-input-otp-separator.component';
import { HlmInputOtpSlotComponent } from './lib/hlm-input-otp-slot.component';
import { HlmInputOtpDirective } from './lib/hlm-input-otp.directive';

export * from './lib/hlm-input-otp-fake-caret.component';
export * from './lib/hlm-input-otp-group.directive';
export * from './lib/hlm-input-otp-separator.component';
export * from './lib/hlm-input-otp-slot.component';
export * from './lib/hlm-input-otp.directive';

@NgModule({
	imports: [
		HlmInputOtpDirective,
		HlmInputOtpGroupDirective,
		HlmInputOtpSeparatorComponent,
		HlmInputOtpSlotComponent,
		HlmInputOtpFakeCaretComponent,
	],
	exports: [
		HlmInputOtpDirective,
		HlmInputOtpGroupDirective,
		HlmInputOtpSeparatorComponent,
		HlmInputOtpSlotComponent,
		HlmInputOtpFakeCaretComponent,
	],
})
export class HlmInputOtpModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/src/lib/hlm-input-otp-fake-caret.component.ts
```typescript
import { Component } from '@angular/core';

@Component({
	selector: 'hlm-input-otp-fake-caret',
	standalone: true,
	template: `
		<div class="pointer-events-none absolute inset-0 flex items-center justify-center">
			<div class="animate-caret-blink bg-foreground h-4 w-px duration-1000"></div>
		</div>
	`,
})
export class HlmInputOtpFakeCaretComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/src/lib/hlm-input-otp-group.directive.ts
```typescript
import { computed, Directive, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type ClassValue } from 'clsx';

@Directive({
	selector: '[hlmInputOtpGroup]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmInputOtpGroupDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => hlm('flex items-center', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/src/lib/hlm-input-otp-separator.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideDot } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import { type ClassValue } from 'clsx';

@Component({
	selector: 'hlm-input-otp-separator',
	imports: [HlmIconDirective, NgIcon],
	providers: [provideIcons({ lucideDot })],
	template: `
		<ng-icon hlm name="lucideDot" />
	`,
	host: {
		role: 'separator',
		'[class]': '_computedClass()',
	},
})
export class HlmInputOtpSeparatorComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => hlm(this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/src/lib/hlm-input-otp-slot.component.ts
```typescript
import { NumberInput } from '@angular/cdk/coercion';
import { Component, computed, input, numberAttribute } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnInputOtpSlotComponent } from '@spartan-ng/brain/input-otp';
import { type ClassValue } from 'clsx';
import { HlmInputOtpFakeCaretComponent } from './hlm-input-otp-fake-caret.component';

@Component({
	selector: 'hlm-input-otp-slot',
	imports: [BrnInputOtpSlotComponent, HlmInputOtpFakeCaretComponent],
	template: `
		<brn-input-otp-slot [index]="index()">
			<hlm-input-otp-fake-caret />
		</brn-input-otp-slot>
	`,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmInputOtpSlotComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	public readonly index = input.required<number, NumberInput>({ transform: numberAttribute });

	protected readonly _computedClass = computed(() =>
		hlm(
			'relative flex h-10 w-10 items-center justify-center border-y border-r border-input text-sm transition-all first:rounded-l-md first:border-l last:rounded-r-md',
			'has-[brn-input-otp-slot[data-active="true"]]:z-10 has-[brn-input-otp-slot[data-active="true"]]:ring-2 has-[brn-input-otp-slot[data-active="true"]]:ring-ring has-[brn-input-otp-slot[data-active="true"]]:ring-offset-background',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/src/lib/hlm-input-otp.directive.ts
```typescript
import { computed, Directive, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type ClassValue } from 'clsx';

@Directive({
	selector: 'brn-input-otp [hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmInputOtpDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm('flex items-center gap-2 has-[:disabled]:opacity-50', this.userClass()),
	);
}

```
