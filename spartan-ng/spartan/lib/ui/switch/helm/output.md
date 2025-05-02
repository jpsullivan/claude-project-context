/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/README.md
```
# ui-switch-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-switch-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-switch-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/ui/switch/helm',
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
	testPathIgnorePatterns: ['<rootDir>/src/lib/hlm-switch-ng-model.component.ignore.spec.ts'],
	snapshotSerializers: [
		'jest-preset-angular/build/serializers/no-ng-attributes',
		'jest-preset-angular/build/serializers/ng-snapshot',
		'jest-preset-angular/build/serializers/html-comment',
	],
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/switch/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/package.json
```json
{
	"name": "@spartan-ng/ui-switch-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/cdk": ">=19.0.0",
		"@angular/core": ">=19.0.0",
		"@angular/forms": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/project.json
```json
{
	"name": "ui-switch-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/switch/helm/src",
	"prefix": "hlm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/switch/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/switch/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/switch/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/switch/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-switch-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmSwitchThumbDirective } from './lib/hlm-switch-thumb.directive';
import { HlmSwitchComponent } from './lib/hlm-switch.component';

export * from './lib/hlm-switch-thumb.directive';
export * from './lib/hlm-switch.component';

export const HlmSwitchImports = [HlmSwitchComponent, HlmSwitchThumbDirective] as const;
@NgModule({
	imports: [...HlmSwitchImports],
	exports: [...HlmSwitchImports],
})
export class HlmSwitchModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/src/lib/hlm-switch-ng-model.component.ignore.spec.ts
```typescript
import { Component, Input } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HlmSwitchComponent } from './hlm-switch.component';
@Component({
	selector: 'hlm-switch-ng-model',
	template: `
		<!-- eslint-disable-next-line @angular-eslint/template/label-has-associated-control -->
		<label class="flex items-center" hlmLabel>
			test switch
			<hlm-switch [(ngModel)]="switchValue" id="testSwitchForm" (changed)="handleChange($event)" />
		</label>

		<p data-testid="switchValue">{{ switchValue }}</p>
		<p data-testid="changedValue">{{ changedValueTo }}</p>
	`,
	imports: [HlmSwitchComponent, FormsModule],
})
export class SwitchFormComponent {
	@Input()
	public switchValue = false;

	protected changedValueTo: boolean | undefined;

	handleChange(value: boolean) {
		this.changedValueTo = value;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/src/lib/hlm-switch-thumb.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: 'brn-switch-thumb[hlm],[hlmSwitchThumb]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSwitchThumbDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm(
			'block h-5 w-5 rounded-full bg-background shadow-lg ring-0 transition-transform group-data-[state=checked]:translate-x-5 group-data-[state=unchecked]:translate-x-0',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/helm/src/lib/hlm-switch.component.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { Component, booleanAttribute, computed, forwardRef, input, model, output, signal } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { hlm } from '@spartan-ng/brain/core';
import { ChangeFn, TouchFn } from '@spartan-ng/brain/forms';
import { BrnSwitchComponent, BrnSwitchThumbComponent } from '@spartan-ng/brain/switch';
import type { ClassValue } from 'clsx';
import { HlmSwitchThumbDirective } from './hlm-switch-thumb.directive';
export const HLM_SWITCH_VALUE_ACCESSOR = {
	provide: NG_VALUE_ACCESSOR,
	useExisting: forwardRef(() => HlmSwitchComponent),
	multi: true,
};

@Component({
	selector: 'hlm-switch',
	imports: [BrnSwitchThumbComponent, BrnSwitchComponent, HlmSwitchThumbDirective],
	host: {
		class: 'contents',
		'[attr.id]': 'null',
		'[attr.aria-label]': 'null',
		'[attr.aria-labelledby]': 'null',
		'[attr.aria-describedby]': 'null',
	},
	template: `
		<brn-switch
			[class]="_computedClass()"
			[checked]="checked()"
			(changed)="handleChange($event)"
			(touched)="_onTouched?.()"
			[disabled]="disabled()"
			[id]="id()"
			[aria-label]="ariaLabel()"
			[aria-labelledby]="ariaLabelledby()"
			[aria-describedby]="ariaDescribedby()"
		>
			<brn-switch-thumb hlm />
		</brn-switch>
	`,
	providers: [HLM_SWITCH_VALUE_ACCESSOR],
})
export class HlmSwitchComponent implements ControlValueAccessor {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'group inline-flex h-[24px] w-[44px] shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=unchecked]:bg-input',
			this.disabled() ? 'cursor-not-allowed opacity-50' : '',
			this.userClass(),
		),
	);

	/** The checked state of the switch. */
	public readonly checked = model<boolean>(false);

	/** The disabled state of the switch. */
	public readonly disabledInput = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
		alias: 'disabled',
	});

	/** Used to set the id on the underlying brn element. */
	public readonly id = input<string | null>(null);

	/** Used to set the aria-label attribute on the underlying brn element. */
	public readonly ariaLabel = input<string | null>(null, { alias: 'aria-label' });

	/** Used to set the aria-labelledby attribute on the underlying brn element. */
	public readonly ariaLabelledby = input<string | null>(null, { alias: 'aria-labelledby' });

	/** Used to set the aria-describedby attribute on the underlying brn element. */
	public readonly ariaDescribedby = input<string | null>(null, { alias: 'aria-describedby' });

	/** Emits when the checked state of the switch changes. */
	public readonly changed = output<boolean>();

	private readonly _writableDisabled = computed(() => signal(this.disabledInput()));

	public readonly disabled = computed(() => this._writableDisabled()());

	protected _onChange?: ChangeFn<boolean>;
	protected _onTouched?: TouchFn;

	protected handleChange(value: boolean): void {
		this.checked.set(value);
		this._onChange?.(value);
		this.changed.emit(value);
	}

	/** CONROL VALUE ACCESSOR */

	writeValue(value: boolean): void {
		this.checked.set(Boolean(value));
	}

	registerOnChange(fn: ChangeFn<boolean>): void {
		this._onChange = fn;
	}

	registerOnTouched(fn: TouchFn): void {
		this._onTouched = fn;
	}

	setDisabledState(isDisabled: boolean): void {
		this._writableDisabled().set(isDisabled);
	}
}

```
