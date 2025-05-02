/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/tooltip.stories.ts
```typescript
import { Component, signal } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucidePlus } from '@ng-icons/lucide';
import { BrnTooltipContentDirective } from '@spartan-ng/brain/tooltip';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmTooltipComponent, HlmTooltipTriggerDirective } from './helm/src';

const meta: Meta<HlmTooltipComponent> = {
	title: 'Tooltip',
	component: HlmTooltipComponent,
	tags: ['autodocs'],
	argTypes: {},
	decorators: [
		moduleMetadata({
			imports: [
				HlmButtonDirective,
				HlmTooltipComponent,
				BrnTooltipContentDirective,
				HlmTooltipTriggerDirective,
				NgIcon,
				HlmIconDirective,
			],
			providers: [provideIcons({ lucidePlus })],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmTooltipComponent>;
export const Default: Story = {
	argTypes: {
		position: {
			control: { type: 'radio' },
			options: ['above', 'below', 'left', 'right'],
			defaultValue: 'above',
		},
	},
	render: ({ ...args }) => ({
		props: args,
		template: `
<div class='p-40'>
  <hlm-tooltip>
    <button hlmTooltipTrigger ${argsToTemplate(args)} aria-describedby='Hello world' hlmBtn variant='outline'>Test</button>
    <span *brnTooltipContent class='flex items-center'>
      Add to library <ng-icon hlm class='ml-2' size='sm' name='lucidePlus'/>
     </span>
  </hlm-tooltip>
</div>
`,
	}),
};

@Component({
	selector: 'simple-tooltip-story',
	standalone: true,
	imports: [
		HlmButtonDirective,
		HlmTooltipComponent,
		BrnTooltipContentDirective,
		HlmTooltipTriggerDirective,
		NgIcon,
		HlmIconDirective,
	],
	providers: [provideIcons({ lucidePlus })],
	template: `
		<div class="p-40">
			<button
				(click)="disabled.set(!disabled())"
				aria-describedby="Add to library"
				[hlmTooltipTrigger]="'Add to library'"
				[hlmTooltipDisabled]="disabled()"
				hlmBtn
				variant="icon"
			>
				<ng-icon hlm name="lucidePlus" size="sm" />
			</button>
		</div>
	`,
})
class SimpleTooltip {
	protected readonly disabled = signal(false);
}

export const Simple: Story = {
	render: () => ({
		moduleMetadata: {
			imports: [SimpleTooltip],
		},
		template: '<simple-tooltip-story/>',
	}),
};

@Component({
	selector: 'disabled-tooltip-story',
	standalone: true,
	imports: [
		HlmButtonDirective,
		HlmTooltipComponent,
		BrnTooltipContentDirective,
		HlmTooltipTriggerDirective,
		NgIcon,
		HlmIconDirective,
	],
	providers: [provideIcons({ lucidePlus })],
	template: `
		<div class="p-40">
			<hlm-tooltip>
				<button
					(click)="disabled.set(!disabled())"
					hlmTooltipTrigger
					[hlmTooltipDisabled]="disabled()"
					aria-describedby="Hello world"
					hlmBtn
					variant="outline"
				>
					Test
				</button>
				<span *brnTooltipContent class="flex items-center">
					Add to library
					<ng-icon hlm class="ml-2" size="sm" name="lucidePlus" />
				</span>
			</hlm-tooltip>
			<p>{{ disabled() ? 'disabled' : 'enabled' }}</p>
		</div>
	`,
})
class DisabledTooltip {
	protected readonly disabled = signal(false);
}

export const Disabled: Story = {
	render: () => ({
		moduleMetadata: {
			imports: [DisabledTooltip],
		},
		template: '<disabled-tooltip-story/>',
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/README.md
```
# ui-tooltip-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-tooltip-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/eslint.config.js
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
		},
	},
	{
		files: ['**/*.html'],
		// Override or add rules here
		rules: {},
	},
];

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-tooltip-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/tooltip/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/package.json
```json
{
	"name": "@spartan-ng/ui-tooltip-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/project.json
```json
{
	"name": "ui-tooltip-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/tooltip/helm/src",
	"prefix": "helm",
	"tags": ["scope:helm"],
	"projectType": "library",
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/tooltip/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/tooltip/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/tooltip/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/tooltip/helm/jest.config.ts",
				"passWithNoTests": true
			},
			"configurations": {
				"ci": {
					"ci": true,
					"codeCoverage": true
				}
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"],
			"options": {
				"lintFilePatterns": [
					"libs/ui/tooltip/helm/**/*.ts",
					"libs/ui/tooltip/helm/**/*.html",
					"libs/ui/tooltip/helm/package.json",
					"libs/ui/tooltip/helm/project.json"
				]
			}
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-tooltip-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmTooltipTriggerDirective } from './lib/hlm-tooltip-trigger.directive';
import { HlmTooltipComponent } from './lib/hlm-tooltip.component';

export * from './lib/hlm-tooltip-trigger.directive';
export * from './lib/hlm-tooltip.component';

export const HlmTooltipImports = [HlmTooltipComponent, HlmTooltipTriggerDirective] as const;

@NgModule({
	imports: [...HlmTooltipImports],
	exports: [...HlmTooltipImports],
})
export class HlmTooltipModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/src/lib/hlm-tooltip-trigger.directive.ts
```typescript
import { Directive } from '@angular/core';
import { BrnTooltipTriggerDirective, provideBrnTooltipDefaultOptions } from '@spartan-ng/brain/tooltip';

const DEFAULT_TOOLTIP_CONTENT_CLASSES =
	'overflow-hidden rounded-md border border-border bg-popover px-3 py-1.5 text-sm text-popover-foreground shadow-md fade-in-0 zoom-in-95 ' +
	'data-[state=open]:animate-in ' +
	'data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 ' +
	'data-[side=below]:slide-in-from-top-2 data-[side=above]:slide-in-from-bottom-2 ' +
	'data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 ';

@Directive({
	selector: '[hlmTooltipTrigger]',
	standalone: true,
	providers: [
		provideBrnTooltipDefaultOptions({
			showDelay: 150,
			hideDelay: 300,
			exitAnimationDuration: 150,
			tooltipContentClasses: DEFAULT_TOOLTIP_CONTENT_CLASSES,
		}),
	],
	hostDirectives: [
		{
			directive: BrnTooltipTriggerDirective,
			inputs: [
				'brnTooltipDisabled: hlmTooltipDisabled',
				'brnTooltipTrigger: hlmTooltipTrigger',
				'aria-describedby',
				'position',
				'positionAtOrigin',
				'hideDelay',
				'showDelay',
				'exitAnimationDuration',
				'touchGestures',
			],
		},
	],
})
export class HlmTooltipTriggerDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/src/lib/hlm-tooltip.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation } from '@angular/core';
import { BrnTooltipDirective } from '@spartan-ng/brain/tooltip';

@Component({
	selector: 'hlm-tooltip',
	encapsulation: ViewEncapsulation.None,
	changeDetection: ChangeDetectionStrategy.OnPush,
	host: {
		'[style]': '{display: "contents"}',
	},
	hostDirectives: [BrnTooltipDirective],
	template: `
		<ng-content />
	`,
})
export class HlmTooltipComponent {}

```
