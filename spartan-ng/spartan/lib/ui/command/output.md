/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/command.stories.ts
```typescript
import { Component, HostListener, signal } from '@angular/core';
import { FormControl, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgIcon, provideIcons } from '@ng-icons/core';
import * as lucide from '@ng-icons/lucide';
import { BrnCommandDirective, BrnCommandImports } from '@spartan-ng/brain/command';
import { BrnDialogImports } from '@spartan-ng/brain/dialog';
import type { Meta, StoryObj } from '@storybook/angular';
import { moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmDialogOverlayDirective } from '../dialog/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmCodeDirective } from '../typography/helm/src';
import { HlmCommandImports } from './helm/src';

const meta: Meta<BrnCommandDirective> = {
	title: 'Command',
	component: BrnCommandDirective,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			providers: [provideIcons(lucide)],
			imports: [BrnCommandImports, HlmCommandImports, NgIcon, HlmIconDirective, HlmButtonDirective],
		}),
	],
};

export default meta;
type Story = StoryObj<BrnCommandDirective>;

export const Default: Story = {
	render: () => ({
		template: `
		<hlm-command>
  <hlm-command-search>
    <ng-icon hlm name="lucideSearch" class="inline-flex" />

    <input
      type="text"
      hlm-command-search-input
      placeholder="Type a command or search..."
    />
  </hlm-command-search>

  <hlm-command-list>
    <hlm-command-group>
      <hlm-command-group-label>Suggestions</hlm-command-group-label>

      <button hlm-command-item value="Calendar">
        <ng-icon hlm name="lucideCalendar" hlmCommandIcon />
        Calendar
      </button>
      <button disabled hlm-command-item value="Search Emoji">
        <ng-icon hlm name="lucideSmile" hlmCommandIcon />
        Search Emoji
      </button>
      <button hlm-command-item value="Calculator">
        <ng-icon hlm name="lucidePlus" hlmCommandIcon />
        Calculator
      </button>
    </hlm-command-group>

    <hlm-command-separator />

    <hlm-command-group>
      <hlm-command-group-label>Settings</hlm-command-group-label>

      <button hlm-command-item value="Profile">
        <ng-icon hlm name="lucideUser" hlmCommandIcon />
        Profile
        <hlm-command-shortcut>⌘P</hlm-command-shortcut>
      </button>
      <button hlm-command-item value="Billing">
        <ng-icon hlm name="lucideWallet" hlmCommandIcon />
        Billing
        <hlm-command-shortcut>⌘B</hlm-command-shortcut>
      </button>
      <button hlm-command-item value="Settings">
        <ng-icon hlm name="lucideCog" hlmCommandIcon />
        Settings
        <hlm-command-shortcut>⌘S</hlm-command-shortcut>
      </button>
    </hlm-command-group>
  </hlm-command-list>

  <!-- Empty state -->
  <div *brnCommandEmpty hlmCommandEmpty>No results found.</div>
</hlm-command>

    `,
	}),
};

@Component({
	selector: 'command-dialog-component',
	standalone: true,
	imports: [
		BrnCommandImports,
		HlmCommandImports,
		BrnDialogImports,
		HlmDialogOverlayDirective,
		NgIcon,
		HlmIconDirective,
		HlmButtonDirective,
		HlmCodeDirective,
	],
	template: `
		<div class="mx-auto flex max-w-screen-sm items-center justify-center space-x-4 py-20 text-sm">
			<p>
				Press
				<code hlmCode>⌘ + K</code>
			</p>
			<p>
				Last command:
				<code data-testid="lastCommand" hlmCode>{{ command() || 'none' }}</code>
			</p>
		</div>
		<brn-dialog [state]="state()" (stateChanged)="stateChanged($event)">
			<brn-dialog-overlay hlm />

			<hlm-command *brnDialogContent="let ctx" hlmCommandDialog class="relative mx-auto sm:w-[400px]">
				<button hlmCommandDialogCloseBtn>
					<ng-icon hlm name="lucideX" />
				</button>

				<hlm-command-search>
					<ng-icon hlm name="lucideSearch" class="inline-flex" />

					<input type="text" hlm-command-search-input placeholder="Type a command or search..." />
				</hlm-command-search>

				<hlm-command-list>
					<hlm-command-group>
						<hlm-command-group-label>Suggestions</hlm-command-group-label>

						<button hlm-command-item value="Calendar">
							<ng-icon hlm name="lucideCalendar" hlmCommandIcon />
							Calendar
						</button>
						<button hlm-command-item disabled value="Search Emoji">
							<ng-icon hlm name="lucideSmile" hlmCommandIcon />
							Search Emoji
						</button>
						<button hlm-command-item value="Calculator">
							<ng-icon hlm name="lucidePlus" hlmCommandIcon />
							Calculator
						</button>
					</hlm-command-group>

					<hlm-command-separator />

					<hlm-command-group>
						<hlm-command-group-label>Settings</hlm-command-group-label>

						<button hlm-command-item value="Profile">
							<ng-icon hlm name="lucideUser" hlmCommandIcon />
							Profile
							<hlm-command-shortcut>⌘P</hlm-command-shortcut>
						</button>
						<button hlm-command-item value="Billing">
							<ng-icon hlm name="lucideWallet" hlmCommandIcon />
							Billing
							<hlm-command-shortcut>⌘B</hlm-command-shortcut>
						</button>
						<button hlm-command-item value="Settings">
							<ng-icon hlm name="lucideCog" hlmCommandIcon />
							Settings
							<hlm-command-shortcut>⌘S</hlm-command-shortcut>
						</button>
					</hlm-command-group>
				</hlm-command-list>

				<!-- Empty state -->
				<div *brnCommandEmpty hlmCommandEmpty>No results found.</div>
			</hlm-command>
		</brn-dialog>
	`,
})
class CommandDialogComponent {
	public command = signal('');
	public state = signal<'closed' | 'open'>('closed');

	@HostListener('window:keydown', ['$event'])
	onKeyDown(event: KeyboardEvent) {
		if ((event.metaKey || event.ctrlKey) && (event.key === 'k' || event.key === 'K')) {
			this.state.set('open');
		}
	}

	stateChanged(state: 'open' | 'closed') {
		this.state.set(state);
	}

	commandSelected(selected: string) {
		this.state.set('closed');
		this.command.set(selected);
	}
}

export const Dialog: Story = {
	decorators: [
		moduleMetadata({
			imports: [CommandDialogComponent],
		}),
	],
	render: () => ({
		template: '<command-dialog-component/>',
	}),
};

@Component({
	selector: 'command-dynamic-component',
	standalone: true,
	imports: [
		BrnCommandImports,
		HlmCommandImports,
		BrnDialogImports,
		NgIcon,
		HlmIconDirective,
		HlmButtonDirective,
		FormsModule,
	],
	template: `
		<hlm-command>
			<hlm-command-search>
				<ng-icon hlm name="lucideSearch" class="inline-flex" />

				<input type="text" hlm-command-search-input placeholder="Type a command or search..." [ngModel]="search()" />
			</hlm-command-search>

			<hlm-command-list>
				<hlm-command-group>
					<hlm-command-group-label>Suggestions</hlm-command-group-label>
					@for (item of items(); track item.value) {
						<button hlm-command-item [value]="item.value" data-testid="command-item">
							<ng-icon hlm [name]="item.icon" hlmCommandIcon />
							{{ item.label }}
						</button>
					}
				</hlm-command-group>
			</hlm-command-list>

			<!-- Empty state -->
			<div *brnCommandEmpty hlmCommandEmpty>No results found.</div>
		</hlm-command>
	`,
})
class CommandDynamicComponent {
	protected readonly search = signal('P');
	protected readonly items = signal<{ label: string; value: string; icon: string; shortcut: string }[]>([
		{ label: 'Profile', value: 'Profile', icon: 'lucideUser', shortcut: '⌘P' },
		{ label: 'Billing', value: 'Billing', icon: 'lucideWallet', shortcut: '⌘B' },
		{ label: 'Search Emoji', value: 'Search Emoji', icon: 'lucideSmile', shortcut: '⌘E' },
		{ label: 'Settings', value: 'Settings', icon: 'lucideCog', shortcut: '⌘S' },
	]);
}

export const DynamicOptions: Story = {
	decorators: [
		moduleMetadata({
			imports: [CommandDynamicComponent],
		}),
	],
	render: () => ({
		template: '<command-dynamic-component/>',
	}),
};

@Component({
	selector: 'command-reactive-form-component',
	standalone: true,
	imports: [
		BrnCommandImports,
		HlmCommandImports,
		NgIcon,
		HlmIconDirective,
		HlmButtonDirective,
		FormsModule,
		ReactiveFormsModule,
	],
	template: `
		<hlm-command>
			<hlm-command-search>
				<ng-icon hlm name="lucideSearch" class="inline-flex" />

				<input
					type="text"
					hlm-command-search-input
					placeholder="Type a command or search..."
					[formControl]="searchControl"
				/>
			</hlm-command-search>

			<hlm-command-list>
				<hlm-command-group>
					<hlm-command-group-label>Suggestions</hlm-command-group-label>
					@for (item of items(); track item.value) {
						<button hlm-command-item [value]="item.value" data-testid="command-item">
							<ng-icon hlm [name]="item.icon" hlmCommandIcon />
							{{ item.label }}
						</button>
					}
				</hlm-command-group>
			</hlm-command-list>

			<!-- Empty state -->
			<div *brnCommandEmpty hlmCommandEmpty>No results found.</div>
		</hlm-command>
	`,
})
class CommandReactiveFormComponent {
	searchControl = new FormControl('R');
	protected readonly search = signal('P');
	protected readonly items = signal<{ label: string; value: string; icon: string; shortcut: string }[]>([
		{ label: 'Profile', value: 'Profile', icon: 'lucideUser', shortcut: '⌘P' },
		{ label: 'Billing', value: 'Billing', icon: 'lucideWallet', shortcut: '⌘B' },
		{ label: 'Search Emoji', value: 'Search Emoji', icon: 'lucideSmile', shortcut: '⌘E' },
		{ label: 'Settings', value: 'Settings', icon: 'lucideCog', shortcut: '⌘S' },
	]);
	public state = signal<'closed' | 'open'>('closed');
}

export const ReactiveForm: Story = {
	decorators: [
		moduleMetadata({
			imports: [CommandReactiveFormComponent],
		}),
	],
	render: () => ({
		template: '<command-reactive-form-component/>',
	}),
};

@Component({
	selector: 'command-bound-value-component',
	standalone: true,
	imports: [BrnCommandImports, HlmCommandImports, NgIcon, HlmIconDirective, HlmButtonDirective],
	template: `
		<hlm-command>
			<hlm-command-search>
				<ng-icon hlm name="lucideSearch" class="inline-flex" />

				<input type="text" hlm-command-search-input placeholder="Type a command or search..." [value]="search()" />
			</hlm-command-search>

			<hlm-command-list>
				<hlm-command-group>
					<hlm-command-group-label>Suggestions</hlm-command-group-label>
					@for (item of items(); track item.value) {
						<button hlm-command-item [value]="item.value" data-testid="command-item">
							<ng-icon hlm [name]="item.icon" hlmCommandIcon />
							{{ item.label }}
						</button>
					}
				</hlm-command-group>
			</hlm-command-list>

			<!-- Empty state -->
			<div *brnCommandEmpty hlmCommandEmpty>No results found.</div>
		</hlm-command>
	`,
})
class CommandBoundValueComponent {
	protected readonly search = signal('S');
	protected readonly items = signal<{ label: string; value: string; icon: string; shortcut: string }[]>([
		{ label: 'Profile', value: 'Profile', icon: 'lucideUser', shortcut: '⌘P' },
		{ label: 'Billing', value: 'Billing', icon: 'lucideWallet', shortcut: '⌘B' },
		{ label: 'Search Emoji', value: 'Search Emoji', icon: 'lucideSmile', shortcut: '⌘E' },
		{ label: 'Settings', value: 'Settings', icon: 'lucideCog', shortcut: '⌘S' },
	]);
}

export const BoundValue: Story = {
	decorators: [
		moduleMetadata({
			imports: [CommandBoundValueComponent],
		}),
	],
	render: () => ({
		template: '<command-bound-value-component/>',
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/README.md
```
# ui-command-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-command-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/eslint.config.js
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
					type: ['element', 'attribute'],
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-command-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/ui/command/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/command/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/package.json
```json
{
	"name": "@spartan-ng/ui-command-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/cdk": ">=19.0.0",
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"@spartan-ng/ui-button-helm": "0.0.1-alpha.381",
		"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/project.json
```json
{
	"name": "ui-command-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/command/helm/src",
	"prefix": "hlm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/command/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/command/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/command/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/command/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-command-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmCommandDialogCloseButtonDirective } from './lib/hlm-command-dialog-close-button.directive';
import { HlmCommandDialogDirective } from './lib/hlm-command-dialog.directive';
import { HlmCommandEmptyDirective } from './lib/hlm-command-empty.directive';
import { HlmCommandGroupLabelComponent } from './lib/hlm-command-group-label.component';
import { HlmCommandGroupComponent } from './lib/hlm-command-group.component';
import { HlmCommandIconDirective } from './lib/hlm-command-icon.directive';
import { HlmCommandItemComponent } from './lib/hlm-command-item.component';
import { HlmCommandListComponent } from './lib/hlm-command-list.component';
import { HlmCommandSearchInputComponent } from './lib/hlm-command-search-input.component';
import { HlmCommandSearchComponent } from './lib/hlm-command-search.component';
import { HlmCommandSeparatorComponent } from './lib/hlm-command-separator.component';
import { HlmCommandShortcutComponent } from './lib/hlm-command-shortcut.component';
import { HlmCommandComponent } from './lib/hlm-command.component';

export * from './lib/hlm-command-dialog-close-button.directive';
export * from './lib/hlm-command-dialog.directive';
export * from './lib/hlm-command-empty.directive';
export * from './lib/hlm-command-group-label.component';
export * from './lib/hlm-command-group.component';
export * from './lib/hlm-command-icon.directive';
export * from './lib/hlm-command-item.component';
export * from './lib/hlm-command-list.component';
export * from './lib/hlm-command-search-input.component';
export * from './lib/hlm-command-search.component';
export * from './lib/hlm-command-separator.component';
export * from './lib/hlm-command-shortcut.component';
export * from './lib/hlm-command.component';

export const HlmCommandImports = [
	HlmCommandComponent,
	HlmCommandItemComponent,
	HlmCommandSeparatorComponent,
	HlmCommandGroupComponent,
	HlmCommandListComponent,
	HlmCommandShortcutComponent,
	HlmCommandIconDirective,
	HlmCommandDialogCloseButtonDirective,
	HlmCommandDialogDirective,
	HlmCommandSearchInputComponent,
	HlmCommandSearchComponent,
	HlmCommandGroupLabelComponent,
	HlmCommandEmptyDirective,
] as const;

@NgModule({
	imports: [...HlmCommandImports],
	exports: [...HlmCommandImports],
})
export class HlmCommandModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/lib/hlm-command-dialog-close-button.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnDialogCloseDirective } from '@spartan-ng/brain/dialog';
import { HlmButtonDirective, provideBrnButtonConfig } from '@spartan-ng/ui-button-helm';
import { provideHlmIconConfig } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmCommandDialogCloseBtn]',
	standalone: true,
	hostDirectives: [HlmButtonDirective, BrnDialogCloseDirective],
	providers: [provideBrnButtonConfig({ variant: 'ghost' }), provideHlmIconConfig({ size: 'xs' })],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCommandDialogCloseButtonDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'absolute top-3 right-3 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-ring font-medium h-10 hover:bg-accent hover:text-accent-foreground inline-flex items-center justify-center px-4 py-2 ring-offset-background rounded-md text-sm transition-colors !h-5 !p-1 !w-5',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/lib/hlm-command-dialog.directive.ts
```typescript
import { Directive, ElementRef, Renderer2, computed, contentChild, effect, inject, input, signal } from '@angular/core';
import { BrnCommandSearchInputToken } from '@spartan-ng/brain/command';
import { hlm, injectExposesStateProvider } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmCommandDialog]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCommandDialogDirective {
	private readonly _stateProvider = injectExposesStateProvider({ host: true });
	public readonly state = this._stateProvider.state ?? signal('closed').asReadonly();
	private readonly _renderer = inject(Renderer2);
	private readonly _element = inject(ElementRef);

	/** Access the search field */
	private readonly _searchInput = contentChild(BrnCommandSearchInputToken, { read: ElementRef });

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=closed]:slide-out-to-top-[2%]  data-[state=open]:slide-in-from-top-[2%]',
			this.userClass(),
		),
	);

	constructor() {
		effect(() => {
			this._renderer.setAttribute(this._element.nativeElement, 'data-state', this.state());

			const searchInput = this._searchInput();

			if (this.state() === 'open' && searchInput) {
				searchInput.nativeElement.focus();
			}
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/lib/hlm-command-empty.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmCommandEmpty]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCommandEmptyDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm('py-6 text-center text-sm', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/lib/hlm-command-group-label.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';

@Component({
	standalone: true,
	selector: 'hlm-command-group-label',
	template: '<ng-content />',
	host: {
		role: 'presentation',
		'[class]': '_computedClass()',
	},
})
export class HlmCommandGroupLabelComponent {
	/*** The user defined class  */
	public readonly userClass = input<string>('', { alias: 'class' });

	/*** The styles to apply  */
	protected readonly _computedClass = computed(() =>
		hlm('font-medium px-2 py-1.5 text-muted-foreground text-xs', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/lib/hlm-command-group.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { BrnCommandGroupDirective } from '@spartan-ng/brain/command';
import { hlm } from '@spartan-ng/brain/core';

@Component({
	standalone: true,
	selector: 'hlm-command-group',
	template: '<ng-content />',
	hostDirectives: [
		{
			directive: BrnCommandGroupDirective,
			inputs: ['id'],
		},
	],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCommandGroupComponent {
	/*** The user defined class  */
	public readonly userClass = input<string>('', { alias: 'class' });

	/*** The styles to apply  */
	protected readonly _computedClass = computed(() =>
		hlm('flex flex-col overflow-hidden p-1 text-foreground data-[hidden]:hidden', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/lib/hlm-command-icon.directive.ts
```typescript
import { Directive } from '@angular/core';
import { provideHlmIconConfig } from '@spartan-ng/ui-icon-helm';

@Directive({
	standalone: true,
	selector: '[hlmCommandIcon]',
	host: {
		class: 'inline-flex mr-2 w-4 h-4',
	},
	providers: [provideHlmIconConfig({ size: 'sm' })],
})
export class HlmCommandIconDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/lib/hlm-command-item.component.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, Component, computed, input, output } from '@angular/core';
import { BrnCommandItemDirective } from '@spartan-ng/brain/command';
import { hlm } from '@spartan-ng/brain/core';

@Component({
	standalone: true,
	selector: 'button[hlm-command-item]',
	template: `
		<ng-content />
	`,
	hostDirectives: [
		{
			directive: BrnCommandItemDirective,
			inputs: ['value', 'disabled', 'id'],
			outputs: ['selected'],
		},
	],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCommandItemComponent {
	/** The value this item represents. */
	public readonly value = input<string>();

	/** Whether the item is disabled. */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** Emits when the item is selected. */
	public readonly selected = output<void>();

	/*** The user defined class  */
	public readonly userClass = input<string>('', { alias: 'class' });

	/*** The styles to apply  */
	protected readonly _computedClass = computed(() =>
		hlm(
			'text-start aria-selected:bg-accent aria-selected:text-accent-foreground cursor-default disabled:opacity-50 disabled:pointer-events-none hover:bg-accent/50 items-center outline-none px-2 py-1.5 relative flex rounded-sm select-none text-sm data-[hidden]:hidden',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/lib/hlm-command-list.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { BrnCommandListDirective } from '@spartan-ng/brain/command';
import { hlm } from '@spartan-ng/brain/core';

@Component({
	standalone: true,
	selector: 'hlm-command-list',
	template: '<ng-content />',
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [
		{
			directive: BrnCommandListDirective,
			inputs: ['id'],
		},
	],
})
export class HlmCommandListComponent {
	/** The user defined class  */
	public readonly userClass = input<string>('', { alias: 'class' });

	/** The styles to apply  */
	protected readonly _computedClass = computed(() =>
		hlm('max-h-[300px] overflow-x-hidden overflow-y-auto', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/lib/hlm-command-search-input.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { BrnCommandSearchInputDirective } from '@spartan-ng/brain/command';
import { hlm } from '@spartan-ng/brain/core';

@Component({
	standalone: true,
	selector: 'input[hlm-command-search-input]',
	template: '',
	hostDirectives: [{ directive: BrnCommandSearchInputDirective, inputs: ['value'] }],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCommandSearchInputComponent {
	/*** The user defined class  */
	public readonly userClass = input<string>('', { alias: 'class' });

	/*** The styles to apply  */
	protected readonly _computedClass = computed(() =>
		hlm(
			'bg-transparent disabled:cursor-not-allowed disabled:opacity-50 h-11 outline-none placeholder:text-muted-foreground py-3 text-sm w-full',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/lib/hlm-command-search.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { provideHlmIconConfig } from '@spartan-ng/ui-icon-helm';

@Component({
	standalone: true,
	selector: 'hlm-command-search',
	template: `
		<ng-content />
	`,
	host: {
		'[class]': '_computedClass()',
	},
	providers: [provideHlmIconConfig({ size: 'sm' })],
})
export class HlmCommandSearchComponent {
	/*** The user defined class  */
	public readonly userClass = input<string>('', { alias: 'class' });

	/*** The styles to apply  */
	protected readonly _computedClass = computed(() =>
		hlm('relative [&_ng-icon]:flex-none border-b border-border flex items-center px-3 space-x-2', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/lib/hlm-command-separator.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';

@Component({
	standalone: true,
	selector: 'hlm-command-separator',
	template: '',
	host: {
		role: 'separator',
		'[class]': '_computedClass()',
	},
})
export class HlmCommandSeparatorComponent {
	/*** The user defined class  */
	public readonly userClass = input<string>('', { alias: 'class' });

	/*** The styles to apply  */
	protected readonly _computedClass = computed(() => hlm('h-px block w-full border-b border-border', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/lib/hlm-command-shortcut.component.ts
```typescript
import { Component } from '@angular/core';

@Component({
	standalone: true,
	selector: 'hlm-command-shortcut',
	template: '<ng-content />',
	host: {
		class: 'font-light ml-auto opacity-60 text-xs tracking-widest',
	},
})
export class HlmCommandShortcutComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/command/helm/src/lib/hlm-command.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { BrnCommandDirective } from '@spartan-ng/brain/command';
import { hlm } from '@spartan-ng/brain/core';

@Component({
	standalone: true,
	selector: 'hlm-command',
	template: `
		<ng-content />
	`,
	hostDirectives: [
		{
			directive: BrnCommandDirective,
			inputs: ['id', 'filter'],
			outputs: ['valueChange'],
		},
	],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCommandComponent {
	/*** The user defined class */
	public readonly userClass = input<string>('', { alias: 'class' });

	/*** The styles to apply  */
	protected readonly _computedClass = computed(() =>
		hlm(
			'w-96 bg-popover border border-border flex flex-col h-full overflow-hidden rounded-md text-popover-foreground',
			this.userClass(),
		),
	);
}

```
