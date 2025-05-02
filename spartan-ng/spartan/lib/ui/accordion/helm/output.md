/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/README.md
```
# ui-accordion-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-accordion-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-accordion-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/accordion/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/package.json
```json
{
	"name": "@spartan-ng/ui-accordion-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@ng-icons/core": ">=29.0.0",
		"@ng-icons/lucide": ">=29.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/project.json
```json
{
	"name": "ui-accordion-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/accordion/helm/src",
	"prefix": "hlm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/accordion/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/accordion/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/accordion/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/accordion/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-accordion-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmAccordionContentComponent } from './lib/hlm-accordion-content.component';
import { HlmAccordionIconDirective } from './lib/hlm-accordion-icon.directive';
import { HlmAccordionItemDirective } from './lib/hlm-accordion-item.directive';
import { HlmAccordionTriggerDirective } from './lib/hlm-accordion-trigger.directive';
import { HlmAccordionDirective } from './lib/hlm-accordion.directive';

export * from './lib/hlm-accordion-content.component';
export * from './lib/hlm-accordion-icon.directive';
export * from './lib/hlm-accordion-item.directive';
export * from './lib/hlm-accordion-trigger.directive';
export * from './lib/hlm-accordion.directive';

export const HlmAccordionImports = [
	HlmAccordionDirective,
	HlmAccordionItemDirective,
	HlmAccordionTriggerDirective,
	HlmAccordionIconDirective,
	HlmAccordionContentComponent,
] as const;

@NgModule({
	imports: [...HlmAccordionImports],
	exports: [...HlmAccordionImports],
})
export class HlmAccordionModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/src/lib/hlm-accordion-content.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, input } from '@angular/core';
import { BrnAccordionContentComponent } from '@spartan-ng/brain/accordion';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-accordion-content',
	template: `
		<div [attr.inert]="_addInert()" style="overflow: hidden">
			<p [class]="_contentClass()">
				<ng-content />
			</p>
		</div>
	`,
	standalone: true,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmAccordionContentComponent extends BrnAccordionContentComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => {
		const gridRows = this.state() === 'open' ? 'grid-rows-[1fr]' : 'grid-rows-[0fr]';
		return hlm('text-sm transition-all grid', gridRows, this.userClass());
	});

	constructor() {
		super();
		this.setClassToCustomElement('pt-1 pb-4');
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/src/lib/hlm-accordion-icon.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { provideIcons } from '@ng-icons/core';
import { lucideChevronDown } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { provideHlmIconConfig } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';

@Directive({
	selector: 'ng-icon[hlmAccordionIcon], ng-icon[hlmAccIcon]',
	standalone: true,
	providers: [provideIcons({ lucideChevronDown }), provideHlmIconConfig({ size: 'sm' })],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmAccordionIconDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('inline-block h-4 w-4 transition-transform [animation-duration:200]', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/src/lib/hlm-accordion-item.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { BrnAccordionItemDirective } from '@spartan-ng/brain/accordion';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmAccordionItem],brn-accordion-item[hlm],hlm-accordion-item',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [
		{
			directive: BrnAccordionItemDirective,
			inputs: ['isOpened'],
		},
	],
})
export class HlmAccordionItemDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('flex flex-1 flex-col border-b border-border', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/src/lib/hlm-accordion-trigger.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { BrnAccordionTriggerDirective } from '@spartan-ng/brain/accordion';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmAccordionTrigger]',
	standalone: true,
	host: {
		'[style.--tw-ring-offset-shadow]': '"0 0 #000"',
		'[class]': '_computedClass()',
	},
	hostDirectives: [BrnAccordionTriggerDirective],
})
export class HlmAccordionTriggerDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'w-full focus-visible:outline-none text-sm focus-visible:ring-1 focus-visible:ring-ring focus-visible:ring-offset-2 flex flex-1 items-center justify-between py-4 px-0.5 font-medium underline-offset-4 hover:underline [&[data-state=open]>[hlmAccordionIcon]]:rotate-180 [&[data-state=open]>[hlmAccIcon]]:rotate-180',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/helm/src/lib/hlm-accordion.directive.ts
```typescript
import { Directive, computed, inject, input } from '@angular/core';
import { BrnAccordionDirective } from '@spartan-ng/brain/accordion';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmAccordion], hlm-accordion',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [{ directive: BrnAccordionDirective, inputs: ['type', 'dir', 'orientation'] }],
})
export class HlmAccordionDirective {
	private readonly _brn = inject(BrnAccordionDirective);

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('flex', this._brn.orientation() === 'horizontal' ? 'flex-row' : 'flex-col', this.userClass()),
	);
}

```
