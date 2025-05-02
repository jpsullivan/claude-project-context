/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/popover.stories.ts
```typescript
import { NgIcon } from '@ng-icons/core';
import { BrnPopoverComponent, BrnPopoverImports } from '@spartan-ng/brain/popover';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmInputDirective } from '../input/helm/src';
import { HlmLabelDirective } from '../label/helm/src';
import { HlmPopoverImports } from './helm/src';

const meta: Meta<BrnPopoverComponent> = {
	title: 'Popover',
	component: BrnPopoverComponent,
	tags: ['autodocs'],
	args: {
		align: 'center',
		sideOffset: 4,
	},
	argTypes: {
		align: { control: 'select', options: ['start', 'center', 'end'] },
		sideOffset: { control: 'number' },
	},
	decorators: [
		moduleMetadata({
			imports: [
				BrnPopoverImports,
				HlmPopoverImports,
				HlmButtonDirective,
				HlmLabelDirective,
				HlmInputDirective,
				NgIcon,
				HlmIconDirective,
			],
		}),
	],
};

export default meta;
type Story = StoryObj<BrnPopoverComponent>;

export const Default: Story = {
	render: ({ ...args }) => ({
		props: args,
		template: `
    <brn-popover ${argsToTemplate(args)}>
    <div class='flex flex-col items-center justify-center py-80'>
        <button id='edit-profile' variant='outline' brnPopoverTrigger hlmBtn>Open Popover</button>
    </div>
    <div hlmPopoverContent class='w-80 grid gap-4' *brnPopoverContent='let ctx'>
          <div class='space-y-2'>
            <h4 class='font-medium leading-none'>Dimensions</h4>
            <p class='text-sm text-muted-foreground'>
              Set the dimensions for the layer.
            </p>
          </div>
          <div class='grid gap-2'>
            <div class='items-center grid grid-cols-3 gap-4'>
              <label hlmLabel for='width'>Width</label>
              <input hlmInput
                id='width'
                [defaultValue]="'100%'"
                class='h-8 col-span-2'
              />
            </div>
            <div class='items-center grid grid-cols-3 gap-4'>
              <label hlmLabel for='maxWidth'>Max. width</label>
              <input hlmInput
                id='maxWidth'
                [defaultValue]="'300px'"
                class='h-8 col-span-2'
              />
            </div>
            <div class='items-center grid grid-cols-3 gap-4'>
              <label hlmLabel for='height'>Height</label>
              <input hlmInput
                id='height'
                [defaultValue]="'25px'"
                class='h-8 col-span-2'
              />
            </div>
            <div class='items-center grid grid-cols-3 gap-4'>
              <label hlmLabel for='maxHeight'>Max. height</label>
              <input hlmInput
                id='maxHeight'
                [defaultValue]="'none'"
                class='h-8 col-span-2'
              />
            </div>
          </div>
    </div>
    </brn-popover>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/helm/README.md
```
# ui-popover-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-popover-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-popover-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/popover/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/helm/package.json
```json
{
	"name": "@spartan-ng/ui-popover-helm",
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/helm/project.json
```json
{
	"name": "ui-popover-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/popover/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/popover/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/popover/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/popover/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/popover/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-popover-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmPopoverCloseDirective } from './lib/hlm-popover-close.directive';
import { HlmPopoverContentDirective } from './lib/hlm-popover-content.directive';

export * from './lib/hlm-popover-close.directive';
export * from './lib/hlm-popover-content.directive';

export const HlmPopoverImports = [HlmPopoverContentDirective, HlmPopoverCloseDirective] as const;

@NgModule({
	imports: [...HlmPopoverImports],
	exports: [...HlmPopoverImports],
})
export class HlmPopoverModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/helm/src/lib/hlm-popover-close.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmPopoverClose],[brnPopoverClose][hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmPopoverCloseDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/popover/helm/src/lib/hlm-popover-content.directive.ts
```typescript
import { Directive, ElementRef, Renderer2, computed, effect, inject, input, signal } from '@angular/core';
import { hlm, injectExposesStateProvider } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmPopoverContent],[brnPopoverContent][hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmPopoverContentDirective {
	private readonly _stateProvider = injectExposesStateProvider({ host: true });
	public state = this._stateProvider.state ?? signal('closed');
	private readonly _renderer = inject(Renderer2);
	private readonly _element = inject(ElementRef);

	constructor() {
		effect(() => {
			this._renderer.setAttribute(this._element.nativeElement, 'data-state', this.state());
		});
	}

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'relative border-border w-72 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2',
			this.userClass(),
		),
	);
}

```
