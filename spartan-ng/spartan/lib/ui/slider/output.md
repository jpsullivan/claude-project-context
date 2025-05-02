/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/slider/slider.stories.ts
```typescript
import { signal } from '@angular/core';
import { FormControl, FormGroup, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { BrnSliderImports } from '@spartan-ng/brain/slider';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmSliderImports } from './helm/src';

interface BrnSliderStoryArgs {
	value: number;
	disabled: boolean;
	min: number;
	max: number;
	step: number;
	showTicks: boolean;
}

const meta: Meta<BrnSliderStoryArgs> = {
	title: 'Slider',
	tags: ['autodocs'],
	args: {
		disabled: false,
	},
	decorators: [
		moduleMetadata({
			imports: [FormsModule, ReactiveFormsModule, HlmSliderImports, BrnSliderImports],
		}),
	],
};

export default meta;
type Story = StoryObj<BrnSliderStoryArgs>;

export const Default: Story = {
	render: (args) => ({
		props: { ...args },
		template: /* HTML */ `
			<hlm-slider ${argsToTemplate(args)} />

			<div>{{value}}</div>
		`,
	}),
};

export const Disabled: Story = {
	args: {
		value: 50,
		disabled: true,
	},
	render: ({ ...args }) => ({
		props: args,
		template: /* HTML */ `
			<hlm-slider ${argsToTemplate(args)} />
		`,
	}),
};

export const Min: Story = {
	args: {
		min: 10,
	},
	render: ({ ...args }) => ({
		props: args,
		template: /* HTML */ `
			<hlm-slider ${argsToTemplate(args)} (valueChange)="value = $event" />

			<div>{{value}}</div>
		`,
	}),
};

export const Max: Story = {
	args: {
		value: 0,
		max: 75,
	},
	render: ({ ...args }) => ({
		props: args,
		template: /* HTML */ `
			<hlm-slider ${argsToTemplate(args)} (valueChange)="value = $event" />

			<div>{{value}}</div>
		`,
	}),
};

export const MinMax: Story = {
	args: {
		min: 10,
		max: 90,
	},
	render: ({ ...args }) => ({
		props: args,
		template: /* HTML */ `
			<hlm-slider ${argsToTemplate(args)} (valueChange)="value = $event" />

			<div>{{value}}</div>
		`,
	}),
};

export const Step: Story = {
	args: {
		step: 5,
	},
	render: ({ ...args }) => ({
		props: args,
		template: /* HTML */ `
			<hlm-slider ${argsToTemplate(args)} (valueChange)="value = $event" />

			<div>{{value}}</div>
		`,
	}),
};

export const Ticks: Story = {
	args: {
		step: 5,
		showTicks: true,
	},
	render: ({ ...args }) => ({
		props: args,
		template: /* HTML */ `
			<hlm-slider ${argsToTemplate(args)} (valueChange)="value = $event" />

			<div>{{value}}</div>
		`,
	}),
};

export const TemplateDrivenForm: Story = {
	render: (args) => ({
		props: { ...args, temperature: signal('0') },
		template: /* HTML */ `
			<form ngForm>
				<div>
					<pre>{{temperature()}}</pre>
				</div>
				<hlm-slider ${argsToTemplate(args)} [(ngModel)]="temperature" name="temperature" />

				<button (click)="temperature.set(25)">Change temperature value</button>
			</form>
		`,
	}),
};

export const TemplateDrivenFormWithInitialValue: Story = {
	render: (args) => ({
		props: { ...args, temperature: signal(12) },
		template: /* HTML */ `
			<form ngForm>
				<div>
					<pre>{{temperature()}}</pre>
				</div>
				<hlm-slider ${argsToTemplate(args)} [(ngModel)]="temperature" name="temperature" />

				<button (click)="temperature.set(25)">Change temperature value</button>
			</form>
		`,
	}),
};

export const ReactiveFormControl: Story = {
	render: (args) => ({
		props: { ...args, temperatureGroup: new FormGroup({ temperature: new FormControl() }) },
		template: /* HTML */ `
			<div class="mb-3">
				<pre>Form Control Value: {{ temperatureGroup.controls.temperature.valueChanges | async | json }}</pre>
			</div>
			<form [formGroup]="temperatureGroup">
				<hlm-slider ${argsToTemplate(args)} formControlName="temperature" />
			</form>
		`,
	}),
};

export const ReactiveFormControlWithInitialValue: Story = {
	render: (args) => ({
		props: { ...args, temperatureGroup: new FormGroup({ temperature: new FormControl(26) }) },
		template: /* HTML */ `
			<div class="mb-3">
				<pre>Form Control Value: {{ temperatureGroup.controls.temperature.valueChanges | async | json }}</pre>
			</div>
			<form [formGroup]="temperatureGroup">
				<hlm-slider ${argsToTemplate(args)} formControlName="temperature" />
			</form>
		`,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/slider/helm/README.md
```
# ui-slider-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-slider-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/slider/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/slider/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-slider-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/ui/slider/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/slider/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/slider/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/slider/helm/package.json
```json
{
	"name": "@spartan-ng/ui-slider-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"clsx": "^2.1.1"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/slider/helm/project.json
```json
{
	"name": "ui-slider-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/slider/helm/src",
	"prefix": "lib",
	"projectType": "library",
	"tags": [],
	"targets": {
		"build": {
			"executor": "@nx/angular:ng-packagr-lite",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/slider/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/slider/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/slider/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/slider/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint"
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/slider/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/slider/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/slider/helm/tsconfig.lib.prod.json
```json
{
	"extends": "./tsconfig.lib.json",
	"compilerOptions": {
		"declarationMap": false
	},
	"angularCompilerOptions": {}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/slider/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/slider/helm/src/index.ts
```typescript
export * from './lib/hlm-slider.component';
import { HlmSliderComponent } from './lib/hlm-slider.component';

export const HlmSliderImports = [HlmSliderComponent] as const;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/slider/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/slider/helm/src/lib/hlm-slider.component.ts
```typescript
import { ChangeDetectionStrategy, Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import {
	BrnSliderDirective,
	BrnSliderRangeDirective,
	BrnSliderThumbDirective,
	BrnSliderTickDirective,
	BrnSliderTrackDirective,
	injectBrnSlider,
} from '@spartan-ng/brain/slider';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-slider, brn-slider [hlm]',
	changeDetection: ChangeDetectionStrategy.OnPush,
	hostDirectives: [
		{
			directive: BrnSliderDirective,
			inputs: ['value', 'disabled', 'min', 'max', 'step', 'showTicks'],
			outputs: ['valueChange'],
		},
	],
	template: `
		<div brnSliderTrack class="bg-secondary relative h-2 w-full grow overflow-hidden rounded-full">
			<div class="bg-primary absolute h-full" brnSliderRange></div>
		</div>

		@if (slider.showTicks()) {
			<div class="pointer-events-none absolute -inset-x-px top-2 h-1 w-full cursor-pointer transition-all">
				<div
					*brnSliderTick="let tick; let position = position"
					class="absolute size-1 rounded-full"
					[class.bg-secondary]="tick"
					[class.bg-primary]="!tick"
					[style.inset-inline-start.%]="position"
				></div>
			</div>
		}

		<span
			class="border-primary bg-background ring-offset-background focus-visible:ring-ring absolute block h-5 w-5 -translate-x-1/2 rounded-full border-2 transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50"
			brnSliderThumb
		></span>
	`,
	host: {
		'[class]': '_computedClass()',
	},
	imports: [BrnSliderThumbDirective, BrnSliderTrackDirective, BrnSliderRangeDirective, BrnSliderTickDirective],
})
export class HlmSliderComponent {
	protected readonly slider = injectBrnSlider();
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'w-full h-5 flex relative select-none items-center touch-none',
			this.slider.disabled() ? 'opacity-40' : '',
			this.userClass(),
		),
	);
}

```
