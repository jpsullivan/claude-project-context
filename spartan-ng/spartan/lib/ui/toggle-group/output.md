/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/toggle-group.stories.ts
```typescript
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideBold, lucideItalic, lucideUnderline } from '@ng-icons/lucide';
import {
	BrnToggleGroupComponent,
	BrnToggleGroupItemDirective,
	BrnToggleGroupModule,
} from '@spartan-ng/brain/toggle-group';
import type { Meta, StoryObj } from '@storybook/angular';
import { argsToTemplate, moduleMetadata } from '@storybook/angular';

import { BooleanInput } from '@angular/cdk/coercion';
import { JsonPipe } from '@angular/common';
import { Component, input, signal } from '@angular/core';
import { FormControl, FormGroup, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { hlmP } from '../typography/helm/src';
import { HlmToggleGroupDirective, HlmToggleGroupItemDirective, HlmToggleGroupModule } from './helm/src';

const meta: Meta<HlmToggleGroupDirective> = {
	title: 'Toggle Group',
	component: HlmToggleGroupDirective,
	tags: ['autodocs'],
	argTypes: {
		variant: {
			control: 'select',
			options: ['default', 'outline'],
			description: 'The visual style of the toggle group',
			defaultValue: 'default',
		},
		size: {
			control: 'select',
			options: ['default', 'sm', 'lg'],
			description: 'The size of the toggle group',
			defaultValue: 'default',
		},
		userClass: {
			control: 'text',
			description: 'Additional CSS classes to apply to the toggle group',
		},
	},
	decorators: [
		moduleMetadata({
			imports: [
				BrnToggleGroupComponent,
				// BrnToggleGroupModule,
				HlmToggleGroupModule,
				BrnToggleGroupItemDirective,
				HlmToggleGroupDirective,
				HlmToggleGroupItemDirective,
				NgIcon,
				HlmIconDirective,
			],
			providers: [provideIcons({ lucideBold, lucideItalic, lucideUnderline })],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmToggleGroupDirective>;

export const Default: Story = {
	render: (args) => ({
		template: `
		<div class="flex items-center justify-center p-4">
	 <brn-toggle-group hlm multiple="false" nullable="true" ${argsToTemplate(args)} >
	 <button aria-label="Bold Toggle" value="bold" hlmToggleGroupItem>
	   <ng-icon hlm size="sm" name="lucideBold" ${argsToTemplate(args)} />
	 </button>

	 <button aria-label="Italic Toggle" value="italic" hlmToggleGroupItem>
	   <ng-icon hlm size="sm" name="lucideItalic" ${argsToTemplate(args)} />
	 </button>

	 <button aria-label="Underline Toggle" value="underline" hlmToggleGroupItem>
	   <ng-icon hlm size="sm" name="lucideUnderline" ${argsToTemplate(args)} />
	 </button>
			</brn-toggle-group>
		</div>
		`,
	}),
};

export const Outline: Story = {
	render: (args) => ({
		template: `
		<div class="flex items-center justify-center p-4">
	<brn-toggle-group hlm size="sm" variant="outline" multiple="true" nullable="true" ${argsToTemplate(args)}>
	 <button aria-label="Bold" value="bold" hlmToggleGroupItem>
		 <ng-icon hlm size="sm" name="lucideBold" />
	 </button>

	 <button aria-label="Italic" value="italic" hlmToggleGroupItem>
	   <ng-icon hlm size="sm" name="lucideItalic" />
	 </button>

	 <button aria-label="Underline" value="underline" hlmToggleGroupItem>
	 	 <ng-icon hlm size="sm" name="lucideUnderline" />
	 </button>
	</brn-toggle-group>
		</div>
		`,
	}),
};

export const Small: Story = {
	render: (args) => ({
		template: `
	<div class="flex items-center justify-center p-4">
	<brn-toggle-group hlm size="sm" ${argsToTemplate(args)} multiple="false" nullable="true" >
	<button aria-label="Bold" value="bold" hlmToggleGroupItem>
	 <ng-icon hlm size="sm" name="lucideBold" />
	</button>
	<button aria-label="Italic" value="italic" hlmToggleGroupItem>
	  <ng-icon hlm size="sm" name="lucideItalic" />
	</button>
	<button aria-label="Underline" value="underline" hlmToggleGroupItem>
		 <ng-icon hlm size="sm" name="lucideUnderline" />
	</button>
	</brn-toggle-group>
	</div>
		`,
	}),
};

export const Large: Story = {
	render: (args) => ({
		template: `
		<div class="flex items-center justify-center p-4">
<brn-toggle-group hlm ${argsToTemplate(args)} multiple="false" nullable="true" size="lg">
	 <button aria-label="Bold" value="bold" hlmToggleGroupItem>
		 <ng-icon hlm size="lg" name="lucideBold" />
	 </button>

	 <button aria-label="Italic" value="italic" hlmToggleGroupItem>
	   <ng-icon hlm size="lg" name="lucideItalic" />
	 </button>

	 <button aria-label="Underline" value="underline" hlmToggleGroupItem>
	 	 <ng-icon hlm size="lg" name="lucideUnderline" />
	 </button>
	</brn-toggle-group>
		</div>
		`,
	}),
};

export const Disabled: Story = {
	render: () => ({
		template: `
	<div class="flex items-center justify-center p-4">
  <brn-toggle-group hlm multiple="false" nullable="true" size="sm" disabled>
	<button aria-label="Bold" value="bold" hlmToggleGroupItem>
		 <ng-icon hlm size="sm" name="lucideBold" />
	</button>
	<button aria-label="Italic" value="italic" hlmToggleGroupItem>
	  <ng-icon hlm size="sm" name="lucideItalic" />
	</button>
	<button aria-label="Underline" value="underline" hlmToggleGroupItem>
		 <ng-icon hlm size="sm" name="lucideUnderline" />
	</button>
	</brn-toggle-group>
	</div>
		`,
	}),
};

type City = { name: string; population: number };
const CITIES = [
	{
		name: 'Sparta',
		population: 23234233,
	},
	{
		name: 'Athens',
		population: 989889,
	},
	{
		name: 'Corinth',
		population: 988989,
	},
	{
		name: 'Syracuse',
		population: 998889,
	},
];

@Component({
	selector: 'hlm-toggle-group-story',
	standalone: true,
	imports: [BrnToggleGroupModule, HlmToggleGroupModule, HlmToggleGroupItemDirective, HlmButtonDirective, FormsModule],
	template: `
		<div class="flex space-x-4 p-4">
			<brn-toggle-group
				hlm
				[disabled]="disabled()"
				[nullable]="nullable()"
				[multiple]="multiple()"
				[(ngModel)]="selected"
				variant="merged"
			>
				@for (city of cities; track city.name; let last = $last) {
					<button [value]="city" hlmToggleGroupItem>
						{{ city.name }}
					</button>
				}
			</brn-toggle-group>

			<button hlmBtn size="sm" (click)="setToSyracuse()">Set to Syracuse</button>
			<button hlmBtn size="sm" (click)="addCity()">Add Piraeus</button>
		</div>

		<p class="${hlmP}">{{ multiple() ? 'Cities selected' : 'City selected' }}: {{ selectedCities }}</p>
	`,
})
class HlmToggleGroupStoryComponent {
	public multiple = input<BooleanInput>(false);
	public nullable = input<BooleanInput>(false);
	public disabled = input<BooleanInput>(false);
	public defaultValue = input<City | City[] | undefined>(undefined);
	public selected = signal<City | City[] | undefined>(undefined);

	private _cities: City[] = [...CITIES];
	public get cities(): City[] {
		return this._cities;
	}

	ngOnInit() {
		this.selected.set(this.defaultValue());
	}

	get selectedCities() {
		if (!this.selected()) {
			return this.multiple() ? 'No cities selected' : 'No city selected';
		}

		if (Array.isArray(this.selected())) {
			const selectedArray = this.selected() as City[];
			if (selectedArray.length === 0) return 'No cities selected';

			return selectedArray.map((c) => c.name).join(',');
		}

		// At this point, selected must be a single City
		const selectedCity = this.selected() as City;
		return selectedCity.name;
	}

	setToSyracuse() {
		this.selected.set(this.multiple() ? [this.cities[3]] : this.cities[3]);
	}

	addCity() {
		this.cities.push({
			name: 'Piraeus',
			population: 998889,
		});
	}
}

export const ToggleGroupSingleNullable: Story = {
	name: 'Toggle Group - Single Nullable',
	decorators: [
		moduleMetadata({
			imports: [HlmToggleGroupStoryComponent],
		}),
	],
	render: () => ({
		template: '<hlm-toggle-group-story nullable="true"/>',
	}),
};

export const ToggleGroupMultipleNullable: Story = {
	name: 'Toggle Group - Multiple Nullable',
	decorators: [
		moduleMetadata({
			imports: [HlmToggleGroupStoryComponent],
		}),
	],
	render: () => ({
		template: '<hlm-toggle-group-story nullable="true" multiple="true"/>',
	}),
};

export const ToggleGroupSingle: StoryObj<{ defaultValue: City }> = {
	name: 'Toggle Group - Single',
	decorators: [
		moduleMetadata({
			imports: [HlmToggleGroupStoryComponent],
		}),
	],
	args: {
		defaultValue: CITIES[0],
	},
	render: ({ defaultValue }) => ({
		props: { defaultValue },
		template: '<hlm-toggle-group-story nullable="false" [defaultValue]="defaultValue"/>',
	}),
};

export const ToggleGroupDisabled: Story = {
	name: 'Toggle Group - Disabled',
	decorators: [
		moduleMetadata({
			imports: [HlmToggleGroupStoryComponent],
		}),
	],
	render: () => ({
		template: '<hlm-toggle-group-story [disabled]="true"/>',
	}),
};

export const ToggleGroupMultiple: StoryObj<{ defaultValue: City[] }> = {
	name: 'Toggle Group - Multiple',
	decorators: [
		moduleMetadata({
			imports: [HlmToggleGroupStoryComponent],
		}),
	],
	args: {
		defaultValue: [CITIES[0]],
	},
	render: ({ defaultValue }) => ({
		props: { defaultValue },
		template: '<hlm-toggle-group-story multiple="true" [defaultValue]="defaultValue"/>',
	}),
};

@Component({
	selector: 'hlm-toggle-group-form-story',
	standalone: true,
	imports: [
		BrnToggleGroupModule,
		HlmToggleGroupModule,
		HlmToggleGroupItemDirective,
		FormsModule,
		ReactiveFormsModule,
		JsonPipe,
	],
	template: `
		<form class="flex space-x-4 p-4" [formGroup]="citiesForm">
			<brn-toggle-group hlm formControlName="selectedCity" variant="merged">
				@for (city of cities; track city.name; let last = $last) {
					<button [value]="city" hlmToggleGroupItem>
						{{ city.name }}
					</button>
				}
			</brn-toggle-group>
		</form>

		<pre class="${hlmP}" data-testid="selectedCity">{{ citiesForm.controls.selectedCity?.getRawValue()?.name }}</pre>
	`,
})
class HlmToggleGroupFormStoryComponent {
	protected readonly cities: City[] = CITIES;
	protected readonly citiesForm = new FormGroup({
		selectedCity: new FormControl(CITIES[0]),
	});
}

export const ToggleGroupForm: Story = {
	name: 'Toggle Group - Form',
	decorators: [
		moduleMetadata({
			imports: [HlmToggleGroupFormStoryComponent],
		}),
	],
	render: () => ({
		template: '<hlm-toggle-group-form-story/>',
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/README.md
```
# ui-toggle-group-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-toggle-group-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-toggle-group-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/toggle-group/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/package.json
```json
{
	"name": "@spartan-ng/ui-toggle-group-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=18.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/project.json
```json
{
	"name": "ui-toggle-group-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/toggle-group/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/toggle-group/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/toggle-group/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/toggle-group/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/toggle-group/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-toggle-group-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmToggleGroupDirective } from './lib/hlm-toggle-group.directive';
import { HlmToggleGroupItemDirective } from './lib/hlm-toggle-item.directive';

export * from './lib/hlm-toggle-group.directive';
export * from './lib/hlm-toggle-item.directive';

@NgModule({
	imports: [HlmToggleGroupItemDirective, HlmToggleGroupDirective],
	exports: [HlmToggleGroupItemDirective, HlmToggleGroupDirective],
})
export class HlmToggleGroupModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/src/lib/hlm-toggle-group.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { VariantProps } from 'class-variance-authority';
import type { ClassValue } from 'clsx';
import { provideHlmToggleGroup } from './hlm-toggle-group.token';
import { toggleGroupItemVariants } from './hlm-toggle-item.directive';

type ToggleGroupItemVariants = VariantProps<typeof toggleGroupItemVariants>;
@Directive({
	selector: 'brn-toggle-group[hlm],[hlmToggleGroup]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	providers: [provideHlmToggleGroup(HlmToggleGroupDirective)],
})
export class HlmToggleGroupDirective {
	public readonly variant = input<ToggleGroupItemVariants['variant']>('default');
	public readonly size = input<ToggleGroupItemVariants['size']>('default');
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm('inline-flex items-center gap-x-2 focus:[&>[hlm][brnToggle]]:z-10', {
			'gap-x-0 rounded-md first-of-type:[&>[hlmToggleGroupItem]]:rounded-l-md last-of-type:[&>[hlmToggleGroupItem]]:rounded-r-md [&>[hlmToggleGroupItem][variant="outline"]]:-mx-[0.5px] [&>[hlmToggleGroupItem]]:rounded-none':
				this.variant() === 'merged',
			[String(this.userClass())]: !!this.userClass(),
		}),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/src/lib/hlm-toggle-group.token.ts
```typescript
import { ExistingProvider, InjectionToken, Type, inject } from '@angular/core';
import type { HlmToggleGroupDirective } from './hlm-toggle-group.directive';

const HlmToggleGroupToken = new InjectionToken<HlmToggleGroupDirective>('HlmToggleGroupToken');

export function provideHlmToggleGroup(config: Type<HlmToggleGroupDirective>): ExistingProvider {
	return { provide: HlmToggleGroupToken, useExisting: config };
}

export function injectHlmToggleGroup(): HlmToggleGroupDirective {
	return inject(HlmToggleGroupToken, { optional: true }) as HlmToggleGroupDirective;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle-group/helm/src/lib/hlm-toggle-item.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';
import { injectHlmToggleGroup } from './hlm-toggle-group.token';

export const toggleGroupItemVariants = cva(
	'inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors hover:bg-muted hover:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=on]:bg-accent data-[state=on]:text-accent-foreground',
	{
		variants: {
			variant: {
				default: 'bg-transparent',
				outline: 'border border-input bg-transparent hover:bg-accent hover:text-accent-foreground',
				merged:
					'border border-l-0 first-of-type:border-l border-input bg-transparent hover:bg-accent hover:text-accent-foreground',
			},
			size: {
				default: 'h-9 px-3',
				sm: 'h-8 px-2',
				lg: 'h-10 px-3',
			},
		},
		defaultVariants: {
			variant: 'default',
			size: 'default',
		},
	},
);
type ToggleGroupItemVariants = VariantProps<typeof toggleGroupItemVariants>;

@Directive({
	selector: '[hlmToggleGroupItem],[brnToggleGroupItem][hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmToggleGroupItemDirective {
	private readonly _parentGroup = injectHlmToggleGroup();
	public readonly variant = input<ToggleGroupItemVariants['variant']>('default');
	public readonly size = input<ToggleGroupItemVariants['size']>('default');
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => {
		const variantToUse = this._parentGroup?.variant() ?? this.variant();
		const sizeToUse = this._parentGroup?.size() ?? this.size();
		const userClass = this._parentGroup?.userClass() ?? this.userClass();
		return hlm(
			toggleGroupItemVariants({
				variant: variantToUse,
				size: sizeToUse,
			}),
			userClass,
		);
	});
}

```
