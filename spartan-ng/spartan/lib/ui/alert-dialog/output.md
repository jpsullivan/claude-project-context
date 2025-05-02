/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/alert-dialog.stories.ts
```typescript
import { BrnAlertDialogImports } from '@spartan-ng/brain/alert-dialog';
import { type Meta, type StoryObj, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmAlertDialogComponent, HlmAlertDialogImports } from './helm/src';

const meta: Meta<HlmAlertDialogComponent> = {
	title: 'Alert Dialog',
	component: HlmAlertDialogComponent,
	tags: ['autodocs'],
	args: {},
	argTypes: {},
	decorators: [
		moduleMetadata({
			imports: [BrnAlertDialogImports, HlmAlertDialogImports, HlmButtonDirective],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmAlertDialogComponent>;

export const Default: Story = {
	render: () => ({
		template: `
    <hlm-alert-dialog>
      <button id='delete-account' variant='outline' brnAlertDialogTrigger hlmBtn>Delete Account</button>
      <hlm-alert-dialog-content *brnAlertDialogContent='let ctx'>
           <hlm-alert-dialog-header>
            <h3 hlmAlertDialogTitle>Are you absolutely sure?</h3>
            <p hlmAlertDialogDescription>
            This action cannot be undone. This will permanently delete your
            account and remove your data from our servers.
            </p>
          </hlm-alert-dialog-header>
          <hlm-alert-dialog-footer>
            <button hlmAlertDialogCancel (click)='ctx.close()'>Cancel</button>
            <button hlmAlertDialogAction type='submit'>Delete account</button>
          </hlm-alert-dialog-footer>
      </hlm-alert-dialog-content>
    </hlm-alert-dialog>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/README.md
```
# ui-alert-dialog-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-alert-dialog-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-alert-dialog-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/alert-dialog/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/package.json
```json
{
	"name": "@spartan-ng/ui-alertdialog-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"@spartan-ng/ui-button-helm": "0.0.1-alpha.381",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/project.json
```json
{
	"name": "ui-alert-dialog-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/alert-dialog/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/alert-dialog/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/alert-dialog/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/alert-dialog/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/alert-dialog/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-alert-dialog-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmAlertDialogActionButtonDirective } from './lib/hlm-alert-dialog-action-button.directive';
import { HlmAlertDialogCancelButtonDirective } from './lib/hlm-alert-dialog-cancel-button.directive';
import { HlmAlertDialogContentComponent } from './lib/hlm-alert-dialog-content.component';
import { HlmAlertDialogDescriptionDirective } from './lib/hlm-alert-dialog-description.directive';
import { HlmAlertDialogFooterComponent } from './lib/hlm-alert-dialog-footer.component';
import { HlmAlertDialogHeaderComponent } from './lib/hlm-alert-dialog-header.component';
import { HlmAlertDialogOverlayDirective } from './lib/hlm-alert-dialog-overlay.directive';
import { HlmAlertDialogTitleDirective } from './lib/hlm-alert-dialog-title.directive';
import { HlmAlertDialogComponent } from './lib/hlm-alert-dialog.component';

export * from './lib/hlm-alert-dialog-action-button.directive';
export * from './lib/hlm-alert-dialog-cancel-button.directive';
export * from './lib/hlm-alert-dialog-content.component';
export * from './lib/hlm-alert-dialog-description.directive';
export * from './lib/hlm-alert-dialog-footer.component';
export * from './lib/hlm-alert-dialog-header.component';
export * from './lib/hlm-alert-dialog-overlay.directive';
export * from './lib/hlm-alert-dialog-title.directive';
export * from './lib/hlm-alert-dialog.component';

export const HlmAlertDialogImports = [
	HlmAlertDialogContentComponent,
	HlmAlertDialogDescriptionDirective,
	HlmAlertDialogFooterComponent,
	HlmAlertDialogHeaderComponent,
	HlmAlertDialogOverlayDirective,
	HlmAlertDialogTitleDirective,
	HlmAlertDialogActionButtonDirective,
	HlmAlertDialogCancelButtonDirective,
	HlmAlertDialogComponent,
] as const;

@NgModule({
	imports: [...HlmAlertDialogImports],
	exports: [...HlmAlertDialogImports],
})
export class HlmAlertDialogModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/src/lib/hlm-alert-dialog-action-button.directive.ts
```typescript
import { Directive } from '@angular/core';
import { HlmButtonDirective } from '@spartan-ng/ui-button-helm';

@Directive({
	selector: 'button[hlmAlertDialogAction]',
	standalone: true,
	hostDirectives: [HlmButtonDirective],
})
export class HlmAlertDialogActionButtonDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/src/lib/hlm-alert-dialog-cancel-button.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { HlmButtonDirective, provideBrnButtonConfig } from '@spartan-ng/ui-button-helm';
import type { ClassValue } from 'clsx';

@Directive({
	selector: 'button[hlmAlertDialogCancel]',
	standalone: true,
	hostDirectives: [HlmButtonDirective],
	providers: [provideBrnButtonConfig({ variant: 'outline' })],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmAlertDialogCancelButtonDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm('mt-2 sm:mt-0', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/src/lib/hlm-alert-dialog-content.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, input, signal } from '@angular/core';
import { hlm, injectExposesStateProvider } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-alert-dialog-content',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		'[attr.data-state]': 'state()',
	},
	template: `
		<ng-content />
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class HlmAlertDialogContentComponent {
	private readonly _stateProvider = injectExposesStateProvider({ optional: true, host: true });
	public readonly state = this._stateProvider?.state ?? signal('closed');

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'relative grid w-full max-w-lg gap-4 border-border border bg-background p-6 shadow-lg [animation-duration:200] data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=closed]:slide-out-to-top-[2%]  data-[state=open]:slide-in-from-top-[2%] sm:rounded-lg md:w-full',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/src/lib/hlm-alert-dialog-description.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { BrnAlertDialogDescriptionDirective } from '@spartan-ng/brain/alert-dialog';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmAlertDialogDescription]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [BrnAlertDialogDescriptionDirective],
})
export class HlmAlertDialogDescriptionDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm('text-sm text-muted-foreground', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/src/lib/hlm-alert-dialog-footer.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-alert-dialog-footer',
	standalone: true,
	template: `
		<ng-content />
	`,
	host: {
		'[class]': '_computedClass()',
	},
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class HlmAlertDialogFooterComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/src/lib/hlm-alert-dialog-header.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-alert-dialog-header',
	standalone: true,
	template: `
		<ng-content />
	`,
	host: {
		'[class]': '_computedClass()',
	},
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class HlmAlertDialogHeaderComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('flex flex-col space-y-2 text-center sm:text-left', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/src/lib/hlm-alert-dialog-overlay.directive.ts
```typescript
import { Directive, computed, effect, input, untracked } from '@angular/core';
import { hlm, injectCustomClassSettable } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmAlertDialogOverlay],brn-alert-dialog-overlay[hlm]',
	standalone: true,
})
export class HlmAlertDialogOverlayDirective {
	private readonly _classSettable = injectCustomClassSettable({ optional: true, host: true });

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'bg-black/80 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0',
			this.userClass(),
		),
	);

	constructor() {
		effect(() => {
			const classValue = this._computedClass();
			untracked(() => this._classSettable?.setClassToCustomElement(classValue));
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/src/lib/hlm-alert-dialog-title.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { BrnAlertDialogTitleDirective } from '@spartan-ng/brain/alert-dialog';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmAlertDialogTitle]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [BrnAlertDialogTitleDirective],
})
export class HlmAlertDialogTitleDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm('text-lg font-semibold', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert-dialog/helm/src/lib/hlm-alert-dialog.component.ts
```typescript
import { ChangeDetectionStrategy, Component, forwardRef, ViewEncapsulation } from '@angular/core';
import {
	BRN_ALERT_DIALOG_DEFAULT_OPTIONS,
	BrnAlertDialogComponent,
	BrnAlertDialogOverlayComponent,
} from '@spartan-ng/brain/alert-dialog';
import { BrnDialogComponent, provideBrnDialogDefaultOptions } from '@spartan-ng/brain/dialog';
import { HlmAlertDialogOverlayDirective } from './hlm-alert-dialog-overlay.directive';

@Component({
	selector: 'hlm-alert-dialog',
	template: `
		<brn-alert-dialog-overlay hlm />
		<ng-content />
	`,
	providers: [
		{
			provide: BrnDialogComponent,
			useExisting: forwardRef(() => HlmAlertDialogComponent),
		},
		provideBrnDialogDefaultOptions({
			...BRN_ALERT_DIALOG_DEFAULT_OPTIONS,
		}),
	],
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	exportAs: 'hlmAlertDialog',
	imports: [BrnAlertDialogOverlayComponent, HlmAlertDialogOverlayDirective],
})
export class HlmAlertDialogComponent extends BrnAlertDialogComponent {}

```
