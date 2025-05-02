/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/README.md
```
# ui-scroll-area-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-scroll-area-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/eslint.config.js
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
	{
		files: ['**/*.json'],
		rules: {
			'@nx/dependency-checks': [
				'error',
				{
					ignoredDependencies: ['ngx-scrollbar', 'jest-preset-angular'],
				},
			],
		},
		languageOptions: {
			parser: require('jsonc-eslint-parser'),
		},
	},
];

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-scroll-area-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/ui/scroll-area/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/scroll-area/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/package.json
```json
{
	"name": "@spartan-ng/ui-scrollarea-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"clsx": "^2.1.1",
		"ngx-scrollbar": ">=16.0.0"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/project.json
```json
{
	"name": "ui-scroll-area-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/scroll-area/helm/src",
	"prefix": "hlm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/scroll-area/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/scroll-area/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/scroll-area/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/scroll-area/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-scroll-area-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmScrollAreaDirective } from './lib/hlm-scroll-area.directive';

export * from './lib/hlm-scroll-area.directive';

@NgModule({
	imports: [HlmScrollAreaDirective],
	exports: [HlmScrollAreaDirective],
})
export class HlmScrollAreaModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/helm/src/lib/hlm-scroll-area.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: 'ng-scrollbar[hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		'[style.--scrollbar-border-radius.px]': '100',
		'[style.--scrollbar-offset]': '3',
		'[style.--scrollbar-thumb-color]': '"hsl(var(--border))"',
		'[style.--scrollbar-thumb-hover-color]': '"hsl(var(--border))"',
		'[style.--scrollbar-thickness]': '7',
	},
})
export class HlmScrollAreaDirective {
	protected readonly _computedClass = computed(() => hlm('block', this.userClass()));
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
}

```
