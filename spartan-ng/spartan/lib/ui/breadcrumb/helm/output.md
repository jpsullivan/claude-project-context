/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/README.md
```
# ui-breadcrumb-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-breadcrumb-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-breadcrumb-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/breadcrumb/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/package.json
```json
{
	"name": "@spartan-ng/ui-breadcrumb-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@angular/router": ">=19.0.0",
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/project.json
```json
{
	"name": "ui-breadcrumb-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/breadcrumb/helm/src",
	"prefix": "hlm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/breadcrumb/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/breadcrumb/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/breadcrumb/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/breadcrumb/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-breadcrumb-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmBreadcrumbEllipsisComponent } from './lib/breadcrumb-ellipsis.component';
import { HlmBreadcrumbItemDirective } from './lib/breadcrumb-item.directive';
import { HlmBreadcrumbLinkDirective } from './lib/breadcrumb-link.directive';
import { HlmBreadcrumbListDirective } from './lib/breadcrumb-list.directive';
import { HlmBreadcrumbPageDirective } from './lib/breadcrumb-page.directive';
import { HlmBreadcrumbSeparatorComponent } from './lib/breadcrumb-separator.component';
import { HlmBreadcrumbDirective } from './lib/breadcrumb.directive';

export * from './lib/breadcrumb-ellipsis.component';
export * from './lib/breadcrumb-item.directive';
export * from './lib/breadcrumb-link.directive';
export * from './lib/breadcrumb-list.directive';
export * from './lib/breadcrumb-page.directive';
export * from './lib/breadcrumb-separator.component';
export * from './lib/breadcrumb.directive';

export const HlmBreadCrumbImports = [
	HlmBreadcrumbDirective,
	HlmBreadcrumbEllipsisComponent,
	HlmBreadcrumbSeparatorComponent,
	HlmBreadcrumbItemDirective,
	HlmBreadcrumbLinkDirective,
	HlmBreadcrumbPageDirective,
	HlmBreadcrumbListDirective,
] as const;

@NgModule({
	imports: [...HlmBreadCrumbImports],
	exports: [...HlmBreadCrumbImports],
})
export class HlmBreadCrumbModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/lib/breadcrumb-ellipsis.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideEllipsis } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-breadcrumb-ellipsis',
	imports: [NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideEllipsis })],
	template: `
		<span role="presentation" aria-hidden="true" [class]="_computedClass()">
			<ng-icon hlm size="sm" name="lucideEllipsis" />
			<span class="sr-only">More</span>
		</span>
	`,
})
export class HlmBreadcrumbEllipsisComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => hlm('flex h-9 w-9 items-center justify-center', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/lib/breadcrumb-item.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmBreadcrumbItem]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmBreadcrumbItemDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => hlm('inline-flex items-center gap-1.5', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/lib/breadcrumb-link.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { RouterLink } from '@angular/router';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmBreadcrumbLink]',
	standalone: true,
	hostDirectives: [
		{
			directive: RouterLink,
			inputs: [
				'target',
				'queryParams',
				'fragment',
				'queryParamsHandling',
				'state',
				'info',
				'relativeTo',
				'preserveFragment',
				'skipLocationChange',
				'replaceUrl',
				'routerLink: link',
			],
		},
	],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmBreadcrumbLinkDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly link = input<RouterLink['routerLink']>();

	protected readonly _computedClass = computed(() => hlm('transition-colors hover:text-foreground', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/lib/breadcrumb-list.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmBreadcrumbList]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmBreadcrumbListDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm('flex flex-wrap items-center gap-1.5 break-words text-sm text-muted-foreground sm:gap-2.5', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/lib/breadcrumb-page.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmBreadcrumbPage]',
	standalone: true,
	host: {
		role: 'link',
		'[class]': '_computedClass()',
		'[attr.aria-disabled]': 'disabled',
		'[attr.aria-current]': 'page',
	},
})
export class HlmBreadcrumbPageDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => hlm('font-normal text-foreground', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/lib/breadcrumb-separator.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronRight } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	// eslint-disable-next-line @angular-eslint/component-selector
	selector: '[hlmBreadcrumbSeparator]',
	imports: [NgIcon],
	providers: [provideIcons({ lucideChevronRight })],
	host: {
		role: 'presentation',
		'[class]': '_computedClass()',
		'[attr.aria-hidden]': 'true',
	},
	template: `
		<ng-content>
			<ng-icon name="lucideChevronRight" />
		</ng-content>
	`,
})
export class HlmBreadcrumbSeparatorComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm('[&>ng-icon]:text-[14px] [&>ng-icon]:flex!', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/helm/src/lib/breadcrumb.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmBreadcrumb]',
	standalone: true,
	host: {
		role: 'navigation',
		'[class]': '_computedClass()',
		'[attr.aria-label]': 'ariaLabel()',
	},
})
export class HlmBreadcrumbDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly ariaLabel = input<string>('breadcrumb', { alias: 'aria-label' });

	protected readonly _computedClass = computed(() => hlm(this.userClass()));
}

```
