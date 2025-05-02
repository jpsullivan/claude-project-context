/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/hover-card.stories.ts
```typescript
import { Component } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideCalendarDays } from '@ng-icons/lucide';
import { type BrnHoverCardComponent, BrnHoverCardModule } from '@spartan-ng/brain/hover-card';
import { type Meta, type StoryObj, moduleMetadata } from '@storybook/angular';
import { HlmAvatarModule } from '../avatar/helm/src';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmCardDirective } from '../card/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmHoverCardModule } from './helm/src';

@Component({
	selector: 'hover-card-example',
	standalone: true,
	imports: [BrnHoverCardModule, HlmHoverCardModule, HlmButtonDirective, NgIcon, HlmIconDirective, HlmAvatarModule],
	providers: [provideIcons({ lucideCalendarDays })],
	host: {
		class: 'flex w-full h-full justify-center py-80',
	},
	template: `
		<brn-hover-card>
			<button hlmBtn variant="link" brnHoverCardTrigger>&#64;analogjs</button>
			<hlm-hover-card-content *brnHoverCardContent class="w-80">
				<div class="flex justify-between space-x-4">
					<hlm-avatar variant="small" id="avatar-small">
						<img src="https://analogjs.org/img/logos/analog-logo.svg" alt="AnalogLogo" hlmAvatarImage />
						<span class="bg-sky-600 text-sky-50" hlmAvatarFallback>AN</span>
					</hlm-avatar>
					<div class="space-y-1">
						<h4 class="text-sm font-semibold">&#64;analogjs</h4>
						<p class="text-sm">The Angular meta-framework – build Angular applications faster.</p>
						<div class="flex items-center pt-2">
							<ng-icon hlm size="sm" name="lucideCalendarDays" class="mr-2 opacity-70" />
							<span class="text-muted-foreground text-xs">Joined December 2021</span>
						</div>
					</div>
				</div>
			</hlm-hover-card-content>
		</brn-hover-card>
	`,
})
class HoverCardExampleComponent {}

const meta: Meta<BrnHoverCardComponent> = {
	title: 'Hover Card',
	component: HlmCardDirective,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [HoverCardExampleComponent],
		}),
	],
};

export default meta;
type Story = StoryObj<BrnHoverCardComponent>;

export const Default: Story = {
	render: () => ({
		template: '<hover-card-example/>',
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/README.md
```
# ui-hover-card-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-hover-card-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-hover-card-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/hover-card/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/package.json
```json
{
	"name": "@spartan-ng/ui-hovercard-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/project.json
```json
{
	"name": "ui-hover-card-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/hover-card/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/hover-card/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/hover-card/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/hover-card/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/hover-card/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-hover-card-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmHoverCardContentComponent } from './lib/hlm-hover-card-content.component';

export { HlmHoverCardContentComponent } from './lib/hlm-hover-card-content.component';

export const HlmHoverCardImports = [HlmHoverCardContentComponent] as const;

@NgModule({
	imports: [...HlmHoverCardImports],
	exports: [...HlmHoverCardImports],
})
export class HlmHoverCardModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/src/lib/hlm-hover-card-content.component.ts
```typescript
import { Component, ElementRef, Renderer2, computed, effect, inject, input, signal } from '@angular/core';
import { hlm, injectExposedSideProvider, injectExposesStateProvider } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-hover-card-content',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	template: `
		<ng-content />
	`,
})
export class HlmHoverCardContentComponent {
	private readonly _renderer = inject(Renderer2);
	private readonly _element = inject(ElementRef);

	public readonly state = injectExposesStateProvider({ host: true }).state ?? signal('closed').asReadonly();
	public readonly side = injectExposedSideProvider({ host: true }).side ?? signal('bottom').asReadonly();

	constructor() {
		effect(() => {
			this._renderer.setAttribute(this._element.nativeElement, 'data-state', this.state());
			this._renderer.setAttribute(this._element.nativeElement, 'data-side', this.side());
		});
	}

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'z-50 w-64 rounded-md border border-border bg-popover p-4 text-popover-foreground shadow-md outline-none',
			'data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2',
			this.userClass(),
		),
	);
}

```
