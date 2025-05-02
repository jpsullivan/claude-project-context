/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/dialog.stories.ts
```typescript
import { Component, HostBinding, inject } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideCheck } from '@ng-icons/lucide';
import {
	BrnDialogContentDirective,
	BrnDialogImports,
	BrnDialogRef,
	BrnDialogTriggerDirective,
	injectBrnDialogContext,
} from '@spartan-ng/brain/dialog';
import { type Meta, type StoryObj, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmInputDirective } from '../input/helm/src';
import { HlmLabelDirective } from '../label/helm/src';
import { HlmTableComponent, HlmTdComponent, HlmThComponent, HlmTrowComponent } from '../table/helm/src';
import {
	HlmDialogComponent,
	HlmDialogContentComponent,
	HlmDialogDescriptionDirective,
	HlmDialogHeaderComponent,
	HlmDialogImports,
	HlmDialogService,
	HlmDialogTitleDirective,
} from './helm/src';

const meta: Meta<HlmDialogComponent> = {
	title: 'Dialog',
	component: HlmDialogComponent,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [BrnDialogImports, HlmDialogImports, HlmLabelDirective, HlmButtonDirective, HlmInputDirective],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmDialogComponent>;

export const Default: Story = {
	render: () => ({
		template: `
    <hlm-dialog>
    <button id='edit-profile' brnDialogTrigger hlmBtn>Edit Profile</button>
    <hlm-dialog-content class='sm:max-w-[425px]' *brnDialogContent='let ctx'>
         <hlm-dialog-header>
          <h3 hlmDialogTitle>Edit profile</h3>
          <p hlmDialogDescription>
            Make changes to your profile here. Click save when you're done.
          </p>
        </hlm-dialog-header>
        <div class='py-4 grid gap-4'>
          <div class='items-center grid grid-cols-4 gap-4'>
            <label hlmLabel for='name' class='text-right'>
              Name
            </label>
            <input hlmInput id='name' value='Pedro Duarte' class='col-span-3' />
          </div>
          <div class='items-center grid grid-cols-4 gap-4'>
            <label hlmLabel for='username' class='text-right'>
              Username
            </label>
            <input hlmInput id='username' value='@peduarte' class='col-span-3' />
          </div>
        </div>
        <hlm-dialog-footer>
          <button hlmBtn type='submit'>Save changes</button>
        </hlm-dialog-footer>
    </hlm-dialog-content>
    </hlm-dialog>
    `,
	}),
};

@Component({
	selector: 'nested-dialog-story',
	standalone: true,
	imports: [
		HlmDialogComponent,
		HlmButtonDirective,
		BrnDialogTriggerDirective,
		BrnDialogContentDirective,
		HlmDialogContentComponent,
		HlmDialogHeaderComponent,
		HlmDialogDescriptionDirective,
		HlmDialogTitleDirective,
	],
	template: `
		<hlm-dialog>
			<button brnDialogTrigger hlmBtn>Open Dialog</button>
			<hlm-dialog-content *brnDialogContent>
				<hlm-dialog-header>
					<h3 hlmDialogTitle>First dialog</h3>
					<p hlmDialogDescription>Click the button below to open a nested dialog.</p>
				</hlm-dialog-header>

				<hlm-dialog>
					<button brnDialogTrigger hlmBtn class="w-full">Open Nested Dialog</button>
					<hlm-dialog-content *brnDialogContent="let ctx">
						<hlm-dialog-header>
							<h3 hlmDialogTitle>Nested dialog</h3>
							<p hlmDialogDescription>I am a nested dialog!</p>
						</hlm-dialog-header>

						<button hlmBtn (click)="ctx.close()">Close Nested Dialog</button>
					</hlm-dialog-content>
				</hlm-dialog>
			</hlm-dialog-content>
		</hlm-dialog>
	`,
})
class NestedDialogStory {}

export const NestedDialog: Story = {
	name: 'Nested Dialog',
	decorators: [
		moduleMetadata({
			imports: [NestedDialogStory],
		}),
	],
	render: () => ({
		template: '<nested-dialog-story />',
	}),
};

type ExampleUser = {
	name: string;
	email: string;
	phone: string;
};

@Component({
	selector: 'dialog-dynamic-component-story',
	standalone: true,
	imports: [HlmButtonDirective],
	template: `
		<button hlmBtn (click)="openDynamicComponent()">Select User</button>
	`,
})
class DialogDynamicComponentStory {
	private readonly _hlmDialogService = inject(HlmDialogService);

	private readonly _users: ExampleUser[] = [
		{
			name: 'Helena Chambers',
			email: 'helenachambers@chorizon.com',
			phone: '+1 (812) 588-3759',
		},
		{
			name: 'Josie Crane',
			email: 'josiecrane@hinway.com',
			phone: '+1 (884) 523-3324',
		},
		{
			name: 'Lou Hartman',
			email: 'louhartman@optyk.com',
			phone: '+1 (912) 479-3998',
		},
		{
			name: 'Lydia Zimmerman',
			email: 'lydiazimmerman@ultrasure.com',
			phone: '+1 (944) 511-2111',
		},
	];

	public openDynamicComponent() {
		const dialogRef = this._hlmDialogService.open(SelectUserComponent, {
			context: {
				users: this._users,
			},
			contentClass: 'sm:!max-w-[750px]',
		});

		dialogRef.closed$.subscribe((user) => {
			if (user) {
				console.log('Selected user:', user);
			}
		});
	}
}

@Component({
	selector: 'dynamic-content',
	standalone: true,
	imports: [
		HlmDialogHeaderComponent,
		HlmDialogTitleDirective,
		HlmDialogDescriptionDirective,
		HlmTableComponent,
		HlmThComponent,
		HlmTrowComponent,
		HlmTdComponent,
		HlmButtonDirective,
		NgIcon,
		HlmIconDirective,
	],
	providers: [provideIcons({ lucideCheck })],
	template: `
		<hlm-dialog-header>
			<h3 hlmDialogTitle>Select user</h3>
			<p hlmDialogDescription>Click a row to select a user.</p>
		</hlm-dialog-header>

		<hlm-table>
			<hlm-trow>
				<hlm-th class="w-44">Name</hlm-th>
				<hlm-th class="w-60">Email</hlm-th>
				<hlm-th class="w-48">Phone</hlm-th>
			</hlm-trow>
			@for (user of users; track user.name) {
				<button class="text-left" (click)="selectUser(user)">
					<hlm-trow>
						<hlm-td truncate class="w-44 font-medium">{{ user.name }}</hlm-td>
						<hlm-td class="w-60">{{ user.email }}</hlm-td>
						<hlm-td class="w-48">{{ user.phone }}</hlm-td>
					</hlm-trow>
				</button>
			}
		</hlm-table>
	`,
})
class SelectUserComponent {
	@HostBinding('class') private readonly _class: string = 'flex flex-col gap-4';

	private readonly _hlmDialogService = inject(HlmDialogService);
	private readonly _dialogRef = inject<BrnDialogRef<ExampleUser>>(BrnDialogRef);
	private readonly _dialogContext = injectBrnDialogContext<{ users: ExampleUser[] }>();

	protected readonly users = this._dialogContext.users;

	public selectUser(user: ExampleUser) {
		this._hlmDialogService.open(SelectUserComponent, { context: { users: [user] }, contentClass: 'sm:!max-w-[750px]' });
		// this._dialogRef.close(user);
	}
}

export const DynamicComponent: Story = {
	name: 'Dynamic Component',
	decorators: [
		moduleMetadata({
			imports: [DialogDynamicComponentStory],
		}),
	],
	render: () => ({
		template: '<dialog-dynamic-component-story />',
	}),
};

@Component({
	selector: 'nested-dialog-dynamic-first',
	standalone: true,
	imports: [
		HlmButtonDirective,
		HlmDialogContentComponent,
		HlmDialogHeaderComponent,
		HlmDialogTitleDirective,
		HlmDialogDescriptionDirective,
	],
	template: `
		<hlm-dialog-header>
			<h3 hlmDialogTitle>First dialog</h3>
			<p hlmDialogDescription>Click the button below to open a nested dialog.</p>
		</hlm-dialog-header>

		<button hlmBtn (click)="openNestedDialog()">Open Nested Dialog</button>
	`,
	host: {
		class: 'flex flex-col gap-4',
	},
})
class NestedDialogDynamicFirstComponent {
	private readonly _hlmDialogService = inject(HlmDialogService);

	public openNestedDialog() {
		this._hlmDialogService.open(NestedDialogDynamicNestedComponent);
	}
}

@Component({
	selector: 'nested-dialog-dynamic-nested',
	standalone: true,
	imports: [HlmButtonDirective, HlmDialogHeaderComponent, HlmDialogTitleDirective, HlmDialogDescriptionDirective],
	template: `
		<hlm-dialog-header>
			<h3 hlmDialogTitle>Nested dialog</h3>
			<p hlmDialogDescription>I am a nested dialog!</p>
		</hlm-dialog-header>

		<button hlmBtn (click)="close()">Close Nested Dialog</button>
	`,
	host: {
		class: 'flex flex-col gap-4',
	},
})
class NestedDialogDynamicNestedComponent {
	private readonly _brnDialogRef = inject(BrnDialogRef);

	public close() {
		this._brnDialogRef.close();
	}
}

@Component({
	selector: 'nested-dialog-dynamic-content-story',
	standalone: true,
	imports: [HlmButtonDirective],
	template: `
		<button hlmBtn (click)="openDialog()">Open Dialog</button>
	`,
})
class NestedDialogDynamicComponentStory {
	private readonly _hlmDialogService = inject(HlmDialogService);

	public openDialog() {
		this._hlmDialogService.open(NestedDialogDynamicFirstComponent);
	}
}

export const NestedDynamicComponent: Story = {
	name: 'Nested Dynamic Component',
	decorators: [
		moduleMetadata({
			imports: [NestedDialogDynamicComponentStory],
		}),
	],
	render: () => ({
		template: '<nested-dialog-dynamic-content-story />',
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/README.md
```
# ui-dialog-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-dialog-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-dialog-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/dialog/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/package.json
```json
{
	"name": "@spartan-ng/ui-dialog-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/cdk": ">=19.0.0",
		"@angular/common": ">=19.0.0",
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/project.json
```json
{
	"name": "ui-dialog-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/dialog/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/dialog/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/dialog/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/dialog/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/dialog/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-dialog-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmDialogCloseDirective } from './lib/hlm-dialog-close.directive';
import { HlmDialogContentComponent } from './lib/hlm-dialog-content.component';
import { HlmDialogDescriptionDirective } from './lib/hlm-dialog-description.directive';
import { HlmDialogFooterComponent } from './lib/hlm-dialog-footer.component';
import { HlmDialogHeaderComponent } from './lib/hlm-dialog-header.component';
import { HlmDialogOverlayDirective } from './lib/hlm-dialog-overlay.directive';
import { HlmDialogTitleDirective } from './lib/hlm-dialog-title.directive';
import { HlmDialogComponent } from './lib/hlm-dialog.component';

export * from './lib/hlm-dialog-close.directive';
export * from './lib/hlm-dialog-content.component';
export * from './lib/hlm-dialog-description.directive';
export * from './lib/hlm-dialog-footer.component';
export * from './lib/hlm-dialog-header.component';
export * from './lib/hlm-dialog-overlay.directive';
export * from './lib/hlm-dialog-title.directive';
export * from './lib/hlm-dialog.component';
export * from './lib/hlm-dialog.service';

export const HlmDialogImports = [
	HlmDialogComponent,
	HlmDialogCloseDirective,
	HlmDialogContentComponent,
	HlmDialogDescriptionDirective,
	HlmDialogFooterComponent,
	HlmDialogHeaderComponent,
	HlmDialogOverlayDirective,
	HlmDialogTitleDirective,
] as const;

@NgModule({
	imports: [...HlmDialogImports],
	exports: [...HlmDialogImports],
})
export class HlmDialogModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/src/lib/hlm-dialog-close.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmDialogClose],[brnDialogClose][hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmDialogCloseDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm(
			'absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/src/lib/hlm-dialog-content.component.ts
```typescript
import { NgComponentOutlet } from '@angular/common';
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, inject, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideX } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { BrnDialogCloseDirective, BrnDialogRef, injectBrnDialogContext } from '@spartan-ng/brain/dialog';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';
import { HlmDialogCloseDirective } from './hlm-dialog-close.directive';

@Component({
	selector: 'hlm-dialog-content',
	imports: [NgComponentOutlet, BrnDialogCloseDirective, HlmDialogCloseDirective, NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideX })],
	host: {
		'[class]': '_computedClass()',
		'[attr.data-state]': 'state()',
	},
	template: `
		@if (component) {
			<ng-container [ngComponentOutlet]="component" />
		} @else {
			<ng-content />
		}

		<button brnDialogClose hlm>
			<span class="sr-only">Close</span>
			<ng-icon hlm size="sm" name="lucideX" />
		</button>
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class HlmDialogContentComponent {
	private readonly _dialogRef = inject(BrnDialogRef);
	private readonly _dialogContext = injectBrnDialogContext({ optional: true });

	public readonly state = computed(() => this._dialogRef?.state() ?? 'closed');

	public readonly component = this._dialogContext?.$component;
	private readonly _dynamicComponentClass = this._dialogContext?.$dynamicComponentClass;

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'border-border grid w-full max-w-lg relative gap-4 border bg-background p-6 shadow-lg [animation-duration:200] data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=closed]:slide-out-to-top-[2%]  data-[state=open]:slide-in-from-top-[2%] sm:rounded-lg md:w-full',
			this.userClass(),
			this._dynamicComponentClass,
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/src/lib/hlm-dialog-description.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnDialogDescriptionDirective } from '@spartan-ng/brain/dialog';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmDialogDescription]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [BrnDialogDescriptionDirective],
})
export class HlmDialogDescriptionDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('text-sm text-muted-foreground', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/src/lib/hlm-dialog-footer.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-dialog-footer',
	standalone: true,
	template: `
		<ng-content />
	`,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmDialogFooterComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm('flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/src/lib/hlm-dialog-header.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-dialog-header',
	standalone: true,
	template: `
		<ng-content />
	`,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmDialogHeaderComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm('flex flex-col space-y-1.5 text-center sm:text-left', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/src/lib/hlm-dialog-overlay.directive.ts
```typescript
import { Directive, computed, effect, input, untracked } from '@angular/core';
import { hlm, injectCustomClassSettable } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export const hlmDialogOverlayClass =
	'bg-black/80 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0';

@Directive({
	selector: '[hlmDialogOverlay],brn-dialog-overlay[hlm]',
	standalone: true,
})
export class HlmDialogOverlayDirective {
	private readonly _classSettable = injectCustomClassSettable({ optional: true, host: true });

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm(hlmDialogOverlayClass, this.userClass()));

	constructor() {
		effect(() => {
			const newClass = this._computedClass();
			untracked(() => this._classSettable?.setClassToCustomElement(newClass));
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/src/lib/hlm-dialog-title.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnDialogTitleDirective } from '@spartan-ng/brain/dialog';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmDialogTitle]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [BrnDialogTitleDirective],
})
export class HlmDialogTitleDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('text-lg font-semibold leading-none tracking-tight', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/src/lib/hlm-dialog.component.ts
```typescript
import { ChangeDetectionStrategy, Component, forwardRef, ViewEncapsulation } from '@angular/core';
import {
	BrnDialogComponent,
	BrnDialogOverlayComponent,
	provideBrnDialogDefaultOptions,
} from '@spartan-ng/brain/dialog';
import { HlmDialogOverlayDirective } from './hlm-dialog-overlay.directive';

@Component({
	selector: 'hlm-dialog',
	imports: [BrnDialogOverlayComponent, HlmDialogOverlayDirective],
	providers: [
		{
			provide: BrnDialogComponent,
			useExisting: forwardRef(() => HlmDialogComponent),
		},
		provideBrnDialogDefaultOptions({
			// add custom options here
		}),
	],
	template: `
		<brn-dialog-overlay hlm />
		<ng-content />
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	exportAs: 'hlmDialog',
})
export class HlmDialogComponent extends BrnDialogComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/dialog/helm/src/lib/hlm-dialog.service.ts
```typescript
import type { ComponentType } from '@angular/cdk/portal';
import { Injectable, type TemplateRef, inject } from '@angular/core';
import {
	type BrnDialogOptions,
	BrnDialogService,
	DEFAULT_BRN_DIALOG_OPTIONS,
	cssClassesToArray,
} from '@spartan-ng/brain/dialog';
import { HlmDialogContentComponent } from './hlm-dialog-content.component';
import { hlmDialogOverlayClass } from './hlm-dialog-overlay.directive';

export type HlmDialogOptions<DialogContext = unknown> = BrnDialogOptions & {
	contentClass?: string;
	context?: DialogContext;
};

@Injectable({
	providedIn: 'root',
})
export class HlmDialogService {
	private readonly _brnDialogService = inject(BrnDialogService);

	public open(component: ComponentType<unknown> | TemplateRef<unknown>, options?: Partial<HlmDialogOptions>) {
		const mergedOptions = {
			...DEFAULT_BRN_DIALOG_OPTIONS,

			...(options ?? {}),
			backdropClass: cssClassesToArray(`${hlmDialogOverlayClass} ${options?.backdropClass ?? ''}`),
			context: { ...(options?.context ?? {}), $component: component, $dynamicComponentClass: options?.contentClass },
		};

		return this._brnDialogService.open(HlmDialogContentComponent, undefined, mergedOptions.context, mergedOptions);
	}
}

```
