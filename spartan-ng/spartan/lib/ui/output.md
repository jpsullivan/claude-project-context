/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/README.md
```
# UI library

## Overall Architecture

Components are made up out of a brain, which is a headless accessible implementation
of the component. A UI component can be an Angular component or an Angular directive applied
to an existing HTML element or a combination of both if the UI component is more complicated.

On top of these brain components we put our helmet. Our helmet adds SPARTAN-like swagger to our UI.
Most of the time our helmets are added by applying the hlm + component name directive.
An example:
`<button hlmBtn >...</button>` this applies the SPARTAN styles to the button element.

Appearance only UI components that do not provide any other functionality are also
Angular components, e.g. the `<hlm-skeleton/>` component allows you to build a skeleton UI.

## Roadmap (37/43)

- [x] Accordion
- [x] Alert
- [x] Alert Dialog
- [x] Aspect Ratio
- [x] Avatar
- [x] Badge
- [x] Button
- [ ] Calendar
- [x] Card
- [x] Checkbox
- [x] Collapsible
- [x] Combobox
- [x] Command
- [x] Context Menu
- [x] Data Table (needs better docs)
- [ ] Date Picker
- [x] Dialog
- [x] Dropdown Menu
- [x] Hover Card
- [x] Icon
- [x] Input
- [x] Input OTP
- [x] Label
- [x] Menubar
- [ ] Navigation Menu
- [x] Pagination
- [x] Popover
- [x] Progress
- [x] Radio Group
- [x] Scroll Area
- [ ] Select
- [x] Separator
- [x] Sheet
- [x] Skeleton
- [ ] Slider
- [x] Spinner
- [x] Switch
- [x] Table (needs better docs)
- [x] Tabs
- [x] Textarea (covered by hlmInput directive)
- [ ] Toast
- [x] Toggle
- [x] Tooltip
- [x] Typography

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/tabs.stories.ts
```typescript
import { BrnTabsDirective, BrnTabsImports } from '@spartan-ng/brain/tabs';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmCardImports } from '../card/helm/src';
import { HlmInputDirective } from '../input/helm/src';
import { HlmLabelDirective } from '../label/helm/src';
import { HlmTabsImports } from './helm/src';

const meta: Meta<BrnTabsDirective> = {
	title: 'Tabs',
	component: BrnTabsDirective,
	tags: ['autodocs'],
	argTypes: {
		activationMode: {
			options: ['manual', 'automatic'],
			control: {
				type: 'select',
			},
		},
	},
	decorators: [
		moduleMetadata({
			imports: [
				BrnTabsImports,
				HlmTabsImports,
				HlmCardImports,
				HlmLabelDirective,
				HlmInputDirective,
				HlmButtonDirective,
			],
		}),
	],
};

export default meta;
type Story = StoryObj<BrnTabsDirective>;
export const Default: Story = {
	render: ({ ...args }) => ({
		props: args,
		template: /* HTML */ `
			<hlm-tabs tab="account" ${argsToTemplate(args)} class="mx-auto block max-w-3xl">
				<hlm-tabs-list class="grid w-full grid-cols-2" aria-label="tabs example">
					<button hlmTabsTrigger="account">Account</button>
					<button hlmTabsTrigger="password">Password</button>
				</hlm-tabs-list>
				<div hlmTabsContent="account">
					<section hlmCard>
						<div hlmCardHeader>
							<h3 hlmCardTitle>Account</h3>
							<p hlmCardDescription>Make changes to your account here. Click save when you're done.</p>
						</div>
						<p hlmCardContent>
							<label class="my-4 block" hlmLabel>
								Name
								<input class="mt-1.5 w-full" value="Pedro Duarte" hlmInput />
							</label>
							<label class="my-4 block" hlmLabel>
								Username
								<input class="mt-1.5 w-full" placeholder="@peduarte" hlmInput />
							</label>
						</p>
						<div hlmCardFooter>
							<button hlmBtn>Save Changes</button>
						</div>
					</section>
				</div>
				<div hlmTabsContent="password">
					<section hlmCard>
						<div hlmCardHeader>
							<h3 hlmCardTitle>Password</h3>
							<p hlmCardDescription>Change your password here. After saving, you'll be logged out.</p>
						</div>
						<p hlmCardContent>
							<label class="my-4 block" hlmLabel>
								Old Password
								<input class="mt-1.5 w-full" type="password" hlmInput />
							</label>
							<label class="my-4 block" hlmLabel>
								New Password
								<input class="mt-1.5 w-full" type="password" hlmInput />
							</label>
						</p>
						<div hlmCardFooter>
							<button hlmBtn>Save Password</button>
						</div>
					</section>
				</div>
			</hlm-tabs>
		`,
	}),
};

export const Vertical: Story = {
	render: ({ activationMode }) => ({
		props: { activationMode },
		template: /* HTML */ `
			<hlm-tabs tab="account" class="mx-auto flex max-w-3xl flex-row space-x-2" orientation="vertical">
				<hlm-tabs-list orientation="vertical" aria-label="tabs example">
					<button class="w-full" hlmTabsTrigger="account">Account</button>
					<button class="w-full" hlmTabsTrigger="password">Password</button>
					<button class="w-full" hlmTabsTrigger="danger">Danger Zone</button>
				</hlm-tabs-list>
				<div hlmTabsContent="account">
					<section hlmCard>
						<div hlmCardHeader>
							<h3 hlmCardTitle>Account</h3>
							<p hlmCardDescription>Make changes to your account here. Click save when you're done.</p>
						</div>
						<p hlmCardContent>
							<label class="my-4 block" hlmLabel>
								Name
								<input class="mt-1.5 w-full" value="Pedro Duarte" hlmInput />
							</label>
							<label class="my-4 block" hlmLabel>
								Username
								<input class="mt-1.5 w-full" placeholder="@peduarte" hlmInput />
							</label>
						</p>
						<div hlmCardFooter>
							<button hlmBtn>Save Changes</button>
						</div>
					</section>
				</div>
				<div hlmTabsContent="password">
					<section hlmCard>
						<div hlmCardHeader>
							<h3 hlmCardTitle>Password</h3>
							<p hlmCardDescription>Change your password here. After saving, you'll be logged out.</p>
						</div>
						<p hlmCardContent>
							<label class="my-4 block" hlmLabel>
								Old Password
								<input class="mt-1.5 w-full" type="password" hlmInput />
							</label>
							<label class="my-4 block" hlmLabel>
								New Password
								<input class="mt-1.5 w-full" type="password" hlmInput />
							</label>
						</p>
						<div hlmCardFooter>
							<button hlmBtn>Save Password</button>
						</div>
					</section>
				</div>
				<div hlmTabsContent="danger">
					<section hlmCard>
						<div hlmCardHeader>
							<h3 hlmCardTitle>Delete Account</h3>
							<p hlmCardDescription>Are you sure you want to delete your account? You cannot undo this action.</p>
						</div>
						<div hlmCardFooter>
							<button variant="destructive" hlmBtn>Delete Account</button>
						</div>
					</section>
				</div>
			</hlm-tabs>
		`,
	}),
};

export const Paginated: Story = {
	render: () => ({
		template: /* HTML */ `
			<hlm-tabs tab="1" class="mx-auto block max-w-3xl">
				<hlm-paginated-tabs-list>
					<button hlmTabsTrigger="1">Tab 1</button>
					<button hlmTabsTrigger="2">Tab 2</button>
					<button hlmTabsTrigger="3">Tab 3</button>
					<button hlmTabsTrigger="4">Tab 4</button>
					<button hlmTabsTrigger="5">Tab 5</button>
					<button hlmTabsTrigger="6">Tab 6</button>
					<button hlmTabsTrigger="7">Tab 7</button>
					<button hlmTabsTrigger="8">Tab 8</button>
					<button hlmTabsTrigger="9">Tab 9</button>
					<button hlmTabsTrigger="10">Tab 10</button>
					<button hlmTabsTrigger="11">Tab 11</button>
					<button hlmTabsTrigger="12">Tab 12</button>
					<button hlmTabsTrigger="13">Tab 13</button>
					<button hlmTabsTrigger="14">Tab 14</button>
					<button hlmTabsTrigger="15">Tab 15</button>
					<button hlmTabsTrigger="16">Tab 16</button>
					<button hlmTabsTrigger="17">Tab 17</button>
					<button hlmTabsTrigger="18">Tab 18</button>
					<button hlmTabsTrigger="19">Tab 19</button>
					<button hlmTabsTrigger="20">Tab 20</button>
				</hlm-paginated-tabs-list>
				<div hlmTabsContent="1">Tab 1</div>
				<div hlmTabsContent="2">Tab 2</div>
				<div hlmTabsContent="3">Tab 3</div>
				<div hlmTabsContent="4">Tab 4</div>
				<div hlmTabsContent="5">Tab 5</div>
				<div hlmTabsContent="6">Tab 6</div>
				<div hlmTabsContent="7">Tab 7</div>
				<div hlmTabsContent="8">Tab 8</div>
				<div hlmTabsContent="9">Tab 9</div>
				<div hlmTabsContent="10">Tab 10</div>
				<div hlmTabsContent="11">Tab 11</div>
				<div hlmTabsContent="12">Tab 12</div>
				<div hlmTabsContent="13">Tab 13</div>
				<div hlmTabsContent="14">Tab 14</div>
				<div hlmTabsContent="15">Tab 15</div>
				<div hlmTabsContent="16">Tab 16</div>
				<div hlmTabsContent="17">Tab 17</div>
				<div hlmTabsContent="18">Tab 18</div>
				<div hlmTabsContent="19">Tab 19</div>
				<div hlmTabsContent="20">Tab 20</div>
			</hlm-tabs>
		`,
	}),
};

export const BrnOnly: Story = {
	render: () => ({
		props: { activationMode: 'automatic' },
		template: /* HTML */ `
			<div brnTabs="account" [activationMode]="activationMode" class="mx-auto block max-w-3xl">
				<div brnTabsList class="grid w-full grid-cols-2" [attr.aria-label]="'tabs example'">
					<button brnTabsTrigger="account">Account</button>
					<button brnTabsTrigger="password">Password</button>
				</div>
				<div brnTabsContent="account">Account content</div>
				<div brnTabsContent="password">Password content</div>
			</div>
		`,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/README.md
```
# ui-tabs-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-tabs-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/eslint.config.js
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
		rules: {
			'@angular-eslint/template/interactive-supports-focus': 'off',
		},
	},
];

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-tabs-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/tabs/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/package.json
```json
{
	"name": "@spartan-ng/ui-tabs-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/cdk": ">=19.0.0",
		"@angular/core": ">=19.0.0",
		"@ng-icons/core": ">=29.0.0",
		"@ng-icons/lucide": ">=29.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"@spartan-ng/ui-button-helm": "0.0.1-alpha.381",
		"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/project.json
```json
{
	"name": "ui-tabs-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/tabs/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/tabs/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/tabs/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/tabs/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/tabs/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-tabs-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmTabsContentDirective } from './lib/hlm-tabs-content.directive';
import { HlmTabsListComponent } from './lib/hlm-tabs-list.component';
import { HlmTabsPaginatedListComponent } from './lib/hlm-tabs-paginated-list.component';
import { HlmTabsTriggerDirective } from './lib/hlm-tabs-trigger.directive';
import { HlmTabsComponent } from './lib/hlm-tabs.component';

export * from './lib/hlm-tabs-content.directive';
export * from './lib/hlm-tabs-list.component';
export * from './lib/hlm-tabs-paginated-list.component';
export * from './lib/hlm-tabs-trigger.directive';
export * from './lib/hlm-tabs.component';

export const HlmTabsImports = [
	HlmTabsComponent,
	HlmTabsListComponent,
	HlmTabsTriggerDirective,
	HlmTabsContentDirective,
	HlmTabsPaginatedListComponent,
] as const;

@NgModule({
	imports: [...HlmTabsImports],
	exports: [...HlmTabsImports],
})
export class HlmTabsModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/src/lib/hlm-tabs-content.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnTabsContentDirective } from '@spartan-ng/brain/tabs';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmTabsContent]',
	standalone: true,
	hostDirectives: [{ directive: BrnTabsContentDirective, inputs: ['brnTabsContent: hlmTabsContent'] }],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmTabsContentDirective {
	public readonly contentFor = input.required<string>({ alias: 'hlmTabsContent' });

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/src/lib/hlm-tabs-list.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnTabsListDirective } from '@spartan-ng/brain/tabs';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const listVariants = cva(
	'inline-flex items-center justify-center rounded-md bg-muted p-1 text-muted-foreground',
	{
		variants: {
			orientation: {
				horizontal: 'h-10 space-x-1',
				vertical: 'mt-2 flex-col h-fit space-y-1',
			},
		},
		defaultVariants: {
			orientation: 'horizontal',
		},
	},
);
type ListVariants = VariantProps<typeof listVariants>;

@Component({
	selector: 'hlm-tabs-list',
	standalone: true,
	hostDirectives: [BrnTabsListDirective],
	template: '<ng-content/>',
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmTabsListComponent {
	public readonly orientation = input<ListVariants['orientation']>('horizontal');

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(listVariants({ orientation: this.orientation() }), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/src/lib/hlm-tabs-paginated-list.component.ts
```typescript
import { CdkObserveContent } from '@angular/cdk/observers';
import { Component, type ElementRef, computed, contentChildren, input, viewChild } from '@angular/core';
import { toObservable } from '@angular/core/rxjs-interop';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronLeft, lucideChevronRight } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { BrnTabsPaginatedListDirective, BrnTabsTriggerDirective } from '@spartan-ng/brain/tabs';
import { buttonVariants } from '@spartan-ng/ui-button-helm';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';
import { listVariants } from './hlm-tabs-list.component';

@Component({
	selector: 'hlm-paginated-tabs-list',
	imports: [CdkObserveContent, NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideChevronRight, lucideChevronLeft })],
	template: `
		<button
			#previousPaginator
			data-pagination="previous"
			type="button"
			aria-hidden="true"
			tabindex="-1"
			[class.flex]="_showPaginationControls()"
			[class.hidden]="!_showPaginationControls()"
			[class]="_paginationButtonClass()"
			[disabled]="_disableScrollBefore || null"
			(click)="_handlePaginatorClick('before')"
			(mousedown)="_handlePaginatorPress('before', $event)"
			(touchend)="_stopInterval()"
		>
			<ng-icon hlm size="base" name="lucideChevronLeft" />
		</button>

		<div #tabListContainer class="z-[1] flex grow overflow-hidden" (keydown)="_handleKeydown($event)">
			<div class="relative grow transition-transform" #tabList role="tablist" (cdkObserveContent)="_onContentChanges()">
				<div #tabListInner [class]="_tabListClass()">
					<ng-content></ng-content>
				</div>
			</div>
		</div>

		<button
			#nextPaginator
			data-pagination="next"
			type="button"
			aria-hidden="true"
			tabindex="-1"
			[class.flex]="_showPaginationControls()"
			[class.hidden]="!_showPaginationControls()"
			[class]="_paginationButtonClass()"
			[disabled]="_disableScrollAfter || null"
			(click)="_handlePaginatorClick('after')"
			(mousedown)="_handlePaginatorPress('after', $event)"
			(touchend)="_stopInterval()"
		>
			<ng-icon hlm size="base" name="lucideChevronRight" />
		</button>
	`,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmTabsPaginatedListComponent extends BrnTabsPaginatedListDirective {
	public readonly _items = contentChildren(BrnTabsTriggerDirective, { descendants: false });
	public readonly _itemsChanges = toObservable(this._items);

	public readonly _tabListContainer = viewChild.required<ElementRef<HTMLElement>>('tabListContainer');
	public readonly _tabList = viewChild.required<ElementRef<HTMLElement>>('tabList');
	public readonly _tabListInner = viewChild.required<ElementRef<HTMLElement>>('tabListInner');
	public readonly _nextPaginator = viewChild.required<ElementRef<HTMLElement>>('nextPaginator');
	public readonly _previousPaginator = viewChild.required<ElementRef<HTMLElement>>('previousPaginator');

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('flex overflow-hidden relative gap-1 flex-shrink-0', this.userClass()),
	);

	public readonly tabLisClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _tabListClass = computed(() => hlm(listVariants(), this.tabLisClass()));

	public readonly paginationButtonClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _paginationButtonClass = computed(() =>
		hlm(
			'relative z-[2] select-none disabled:cursor-default',
			buttonVariants({ variant: 'ghost', size: 'icon' }),
			this.paginationButtonClass(),
		),
	);

	protected _itemSelected(event: KeyboardEvent) {
		event.preventDefault();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/src/lib/hlm-tabs-trigger.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnTabsTriggerDirective } from '@spartan-ng/brain/tabs';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmTabsTrigger]',
	standalone: true,
	hostDirectives: [{ directive: BrnTabsTriggerDirective, inputs: ['brnTabsTrigger: hlmTabsTrigger', 'disabled'] }],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmTabsTriggerDirective {
	public readonly triggerFor = input.required<string>({ alias: 'hlmTabsTrigger' });

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'inline-flex items-center justify-center whitespace-nowrap rounded-sm px-3 py-1.5 text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow-sm',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tabs/helm/src/lib/hlm-tabs.component.ts
```typescript
import { Component, input } from '@angular/core';
import { BrnTabsDirective } from '@spartan-ng/brain/tabs';

@Component({
	selector: 'hlm-tabs',
	standalone: true,
	hostDirectives: [
		{
			directive: BrnTabsDirective,
			inputs: ['orientation', 'direction', 'activationMode', 'brnTabs: tab'],
			outputs: ['tabActivated'],
		},
	],
	template: '<ng-content/>',
})
export class HlmTabsComponent {
	public readonly tab = input.required<string>();
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/pagination.stories.ts
```typescript
import { RouterTestingModule } from '@angular/router/testing';
import type { Meta, StoryObj } from '@storybook/angular';
import { moduleMetadata } from '@storybook/angular';
import { HlmPaginationDirective, HlmPaginationImports } from './helm/src';

const meta: Meta<HlmPaginationDirective> = {
	title: 'Pagination',
	component: HlmPaginationDirective,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [HlmPaginationImports, RouterTestingModule],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmPaginationDirective>;

export const Default: Story = {
	render: () => ({
		template: `
    <nav hlmPagination>
			<ul hlmPaginationContent>
				<li hlmPaginationItem>
					<hlm-pagination-previous link="#" />
				</li>
				<li hlmPaginationItem>
					<a hlmPaginationLink link="#">1</a>
				</li>
				<li hlmPaginationItem>
					<a hlmPaginationLink link="#" isActive>2</a>
				</li>
				<li hlmPaginationItem>
					<a hlmPaginationLink link="#">3</a>
				</li>
				<li hlmPaginationItem>
					<hlm-pagination-ellipsis />
				</li>
				<li hlmPaginationItem>
					<hlm-pagination-next link="#" />
				</li>
			</ul>
		</nav>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/README.md
```
# ui-pagination-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-pagination-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/eslint.config.js
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
		rules: {
			// ideally these would be enabled
			'@angular-eslint/template/click-events-have-key-events': 'off',
			'@angular-eslint/template/interactive-supports-focus': 'off',
		},
	},
];

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-pagination-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/pagination/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/package.json
```json
{
	"name": "@spartan-ng/ui-pagination-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"peerDependencies": {
		"@angular/cdk": ">=19.0.0",
		"@angular/core": ">=19.0.0",
		"@angular/forms": ">=19.0.0",
		"@angular/router": ">=19.0.0",
		"@ng-icons/core": ">=29.0.0",
		"@ng-icons/lucide": ">=29.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"@spartan-ng/ui-button-helm": "0.0.1-alpha.381",
		"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
		"@spartan-ng/ui-select-helm": "0.0.1-alpha.381",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/project.json
```json
{
	"name": "ui-pagination-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/pagination/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/pagination/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/pagination/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/pagination/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/pagination/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-pagination-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmNumberedPaginationComponent } from './lib/hlm-numbered-pagination.component';
import { HlmPaginationContentDirective } from './lib/hlm-pagination-content.directive';
import { HlmPaginationEllipsisComponent } from './lib/hlm-pagination-ellipsis.component';
import { HlmPaginationItemDirective } from './lib/hlm-pagination-item.directive';
import { HlmPaginationLinkDirective } from './lib/hlm-pagination-link.directive';
import { HlmPaginationNextComponent } from './lib/hlm-pagination-next.component';
import { HlmPaginationPreviousComponent } from './lib/hlm-pagination-previous.component';
import { HlmPaginationDirective } from './lib/hlm-pagination.directive';

export * from './lib/hlm-numbered-pagination.component';
export * from './lib/hlm-pagination-content.directive';
export * from './lib/hlm-pagination-ellipsis.component';
export * from './lib/hlm-pagination-item.directive';
export * from './lib/hlm-pagination-link.directive';
export * from './lib/hlm-pagination-next.component';
export * from './lib/hlm-pagination-previous.component';
export * from './lib/hlm-pagination.directive';

export const HlmPaginationImports = [
	HlmPaginationDirective,
	HlmPaginationContentDirective,
	HlmPaginationItemDirective,
	HlmPaginationLinkDirective,
	HlmPaginationPreviousComponent,
	HlmPaginationNextComponent,
	HlmPaginationEllipsisComponent,
	HlmNumberedPaginationComponent,
] as const;

@NgModule({
	imports: [...HlmPaginationImports],
	exports: [...HlmPaginationImports],
})
export class HlmPaginationModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/src/lib/hlm-numbered-pagination.component.ts
```typescript
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import {
	ChangeDetectionStrategy,
	Component,
	booleanAttribute,
	computed,
	input,
	model,
	numberAttribute,
	untracked,
} from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BrnSelectImports } from '@spartan-ng/brain/select';
import { HlmSelectImports } from '@spartan-ng/ui-select-helm';
import { HlmPaginationContentDirective } from './hlm-pagination-content.directive';
import { HlmPaginationEllipsisComponent } from './hlm-pagination-ellipsis.component';
import { HlmPaginationItemDirective } from './hlm-pagination-item.directive';
import { HlmPaginationLinkDirective } from './hlm-pagination-link.directive';
import { HlmPaginationNextComponent } from './hlm-pagination-next.component';
import { HlmPaginationPreviousComponent } from './hlm-pagination-previous.component';
import { HlmPaginationDirective } from './hlm-pagination.directive';

@Component({
	selector: 'hlm-numbered-pagination',
	template: `
		<div class="flex items-center justify-between gap-2 px-4 py-2">
			<div class="flex items-center gap-1 text-nowrap text-sm text-gray-600">
				<b>{{ totalItems() }}</b>
				total items |
				<b>{{ pages().length }}</b>
				pages
			</div>

			<nav hlmPagination>
				<ul hlmPaginationContent>
					@if (showEdges() && !isFirstPageActive()) {
						<li hlmPaginationItem (click)="goToPrevious()">
							<hlm-pagination-previous />
						</li>
					}

					@for (page of pages(); track page) {
						<li hlmPaginationItem>
							@if (page === '...') {
								<hlm-pagination-ellipsis />
							} @else {
								<a hlmPaginationLink [isActive]="currentPage() === page" (click)="currentPage.set(page)">
									{{ page }}
								</a>
							}
						</li>
					}

					@if (showEdges() && !isLastPageActive()) {
						<li hlmPaginationItem (click)="goToNext()">
							<hlm-pagination-next />
						</li>
					}
				</ul>
			</nav>

			<!-- Show Page Size selector -->
			<brn-select [(ngModel)]="itemsPerPage" class="ml-auto" placeholder="Page size">
				<hlm-select-trigger class="w-fit">
					<hlm-select-value />
				</hlm-select-trigger>
				<hlm-select-content>
					@for (pageSize of pageSizesWithCurrent(); track pageSize) {
						<hlm-option [value]="pageSize">{{ pageSize }} / page</hlm-option>
					}
				</hlm-select-content>
			</brn-select>
		</div>
	`,
	imports: [
		FormsModule,
		HlmPaginationDirective,
		HlmPaginationContentDirective,
		HlmPaginationItemDirective,
		HlmPaginationPreviousComponent,
		HlmPaginationNextComponent,
		HlmPaginationLinkDirective,
		HlmPaginationEllipsisComponent,
		BrnSelectImports,
		HlmSelectImports,
	],
	changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HlmNumberedPaginationComponent {
	/**
	 * The current (active) page.
	 */
	public readonly currentPage = model.required<number>();

	/**
	 * The number of items per paginated page.
	 */
	public readonly itemsPerPage = model.required<number>();

	/**
	 * The total number of items in the collection. Only useful when
	 * doing server-side paging, where the collection size is limited
	 * to a single page returned by the server API.
	 */
	public readonly totalItems = input.required<number, NumberInput>({
		transform: numberAttribute,
	});

	/**
	 * The number of page links to show.
	 */
	public readonly maxSize = input<number, NumberInput>(7, {
		transform: numberAttribute,
	});

	/**
	 * Show the first and last page buttons.
	 */
	public readonly showEdges = input<boolean, BooleanInput>(true, {
		transform: booleanAttribute,
	});

	/**
	 * The page sizes to show.
	 * Defaults to [10, 20, 50, 100]
	 */
	public readonly pageSizes = input<number[]>([10, 20, 50, 100]);

	protected readonly pageSizesWithCurrent = computed(() => {
		const pageSizes = this.pageSizes();
		return pageSizes.includes(this.itemsPerPage())
			? pageSizes // if current page size is included, return the same array
			: [...pageSizes, this.itemsPerPage()].sort((a, b) => a - b); // otherwise, add current page size and sort the array
	});

	protected readonly isFirstPageActive = computed(() => this.currentPage() === 1);
	protected readonly isLastPageActive = computed(() => this.currentPage() === this.lastPageNumber());

	protected readonly lastPageNumber = computed(() => {
		if (this.totalItems() < 1) {
			// when there are 0 or fewer (an error case) items, there are no "pages" as such,
			// but it makes sense to consider a single, empty page as the last page.
			return 1;
		}
		return Math.ceil(this.totalItems() / this.itemsPerPage());
	});

	protected readonly pages = computed(() => {
		const correctedCurrentPage = outOfBoundCorrection(this.totalItems(), this.itemsPerPage(), this.currentPage());

		if (correctedCurrentPage !== this.currentPage()) {
			// update the current page
			untracked(() => this.currentPage.set(correctedCurrentPage));
		}

		return createPageArray(correctedCurrentPage, this.itemsPerPage(), this.totalItems(), this.maxSize());
	});

	protected goToPrevious(): void {
		this.currentPage.set(this.currentPage() - 1);
	}

	protected goToNext(): void {
		this.currentPage.set(this.currentPage() + 1);
	}

	protected goToFirst(): void {
		this.currentPage.set(1);
	}

	protected goToLast(): void {
		this.currentPage.set(this.lastPageNumber());
	}
}

type Page = number | '...';

/**
 * Checks that the instance.currentPage property is within bounds for the current page range.
 * If not, return a correct value for currentPage, or the current value if OK.
 *
 * Copied from 'ngx-pagination' package
 */
function outOfBoundCorrection(totalItems: number, itemsPerPage: number, currentPage: number): number {
	const totalPages = Math.ceil(totalItems / itemsPerPage);
	if (totalPages < currentPage && 0 < totalPages) {
		return totalPages;
	}

	if (currentPage < 1) {
		return 1;
	}

	return currentPage;
}

/**
 * Returns an array of Page objects to use in the pagination controls.
 *
 * Copied from 'ngx-pagination' package
 */
function createPageArray(
	currentPage: number,
	itemsPerPage: number,
	totalItems: number,
	paginationRange: number,
): Page[] {
	// paginationRange could be a string if passed from attribute, so cast to number.
	paginationRange = +paginationRange;
	const pages: Page[] = [];

	// Return 1 as default page number
	// Make sense to show 1 instead of empty when there are no items
	const totalPages = Math.max(Math.ceil(totalItems / itemsPerPage), 1);
	const halfWay = Math.ceil(paginationRange / 2);

	const isStart = currentPage <= halfWay;
	const isEnd = totalPages - halfWay < currentPage;
	const isMiddle = !isStart && !isEnd;

	const ellipsesNeeded = paginationRange < totalPages;
	let i = 1;

	while (i <= totalPages && i <= paginationRange) {
		let label: number | '...';
		const pageNumber = calculatePageNumber(i, currentPage, paginationRange, totalPages);
		const openingEllipsesNeeded = i === 2 && (isMiddle || isEnd);
		const closingEllipsesNeeded = i === paginationRange - 1 && (isMiddle || isStart);
		if (ellipsesNeeded && (openingEllipsesNeeded || closingEllipsesNeeded)) {
			label = '...';
		} else {
			label = pageNumber;
		}
		pages.push(label);
		i++;
	}

	return pages;
}

/**
 * Given the position in the sequence of pagination links [i],
 * figure out what page number corresponds to that position.
 *
 * Copied from 'ngx-pagination' package
 */
function calculatePageNumber(i: number, currentPage: number, paginationRange: number, totalPages: number) {
	const halfWay = Math.ceil(paginationRange / 2);
	if (i === paginationRange) {
		return totalPages;
	}

	if (i === 1) {
		return i;
	}

	if (paginationRange < totalPages) {
		if (totalPages - halfWay < currentPage) {
			return totalPages - paginationRange + i;
		}
		if (halfWay < currentPage) {
			return currentPage - halfWay + i;
		}
		return i;
	}

	return i;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/src/lib/hlm-pagination-content.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import { ClassValue } from 'clsx';

export const paginationContentVariants = cva('flex flex-row items-center gap-1', {
	variants: {},
	defaultVariants: {},
});
export type PaginationContentVariants = VariantProps<typeof paginationContentVariants>;

@Directive({
	selector: '[hlmPaginationContent]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmPaginationContentDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm(paginationContentVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/src/lib/hlm-pagination-ellipsis.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideEllipsis } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-pagination-ellipsis',
	imports: [NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideEllipsis })],
	template: `
		<span [class]="_computedClass()">
			<ng-icon hlm size="sm" name="lucideEllipsis" />
			<span class="sr-only">More pages</span>
		</span>
	`,
})
export class HlmPaginationEllipsisComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => hlm('flex h-9 w-9 items-center justify-center', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/src/lib/hlm-pagination-item.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import { ClassValue } from 'clsx';

export const paginationItemVariants = cva('', {
	variants: {},
	defaultVariants: {},
});

export type PaginationItemVariants = VariantProps<typeof paginationItemVariants>;

@Directive({
	selector: '[hlmPaginationItem]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmPaginationItemDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => hlm(paginationItemVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/src/lib/hlm-pagination-link.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { Directive, booleanAttribute, computed, input } from '@angular/core';
import { RouterLink } from '@angular/router';
import { hlm } from '@spartan-ng/brain/core';
import { type ButtonVariants, buttonVariants } from '@spartan-ng/ui-button-helm';
import { type VariantProps, cva } from 'class-variance-authority';
import { ClassValue } from 'clsx';

export const paginationLinkVariants = cva('', {
	variants: {},
	defaultVariants: {},
});
export type PaginationLinkVariants = VariantProps<typeof paginationLinkVariants>;

@Directive({
	selector: '[hlmPaginationLink]',
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
		'[attr.aria-current]': 'isActive() ? "page" : null',
	},
})
export class HlmPaginationLinkDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly isActive = input<boolean, BooleanInput>(false, { transform: booleanAttribute });
	public readonly size = input<ButtonVariants['size']>('icon');
	public readonly link = input<RouterLink['routerLink']>();

	protected readonly _computedClass = computed(() =>
		hlm(
			paginationLinkVariants(),
			this.link() === undefined ? 'cursor-pointer' : '',
			buttonVariants({
				variant: this.isActive() ? 'outline' : 'ghost',
				size: this.size(),
			}),
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/src/lib/hlm-pagination-next.component.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, Component, computed, input } from '@angular/core';
import { RouterLink } from '@angular/router';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronRight } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { ButtonVariants } from '@spartan-ng/ui-button-helm';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import { ClassValue } from 'clsx';
import { HlmPaginationLinkDirective } from './hlm-pagination-link.directive';

@Component({
	selector: 'hlm-pagination-next',
	imports: [HlmPaginationLinkDirective, NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideChevronRight })],
	template: `
		<a
			[class]="_computedClass()"
			hlmPaginationLink
			[link]="link()"
			[queryParams]="queryParams()"
			[queryParamsHandling]="queryParamsHandling()"
			[size]="size()"
			[attr.aria-label]="ariaLabel()"
		>
			<span [class.sr-only]="iconOnly()">{{ text() }}</span>
			<ng-icon hlm size="sm" name="lucideChevronRight" />
		</a>
	`,
})
export class HlmPaginationNextComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly link = input<RouterLink['routerLink']>();
	public readonly queryParams = input<RouterLink['queryParams']>();
	public readonly queryParamsHandling = input<RouterLink['queryParamsHandling']>();

	public readonly ariaLabel = input<string>('Go to next page', { alias: 'aria-label' });
	public readonly text = input<string>('Next');
	public readonly iconOnly = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	protected readonly size = computed<ButtonVariants['size']>(() => (this.iconOnly() ? 'icon' : 'default'));

	protected readonly _computedClass = computed(() => hlm('gap-1', !this.iconOnly() ? 'pr-2.5' : '', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/src/lib/hlm-pagination-previous.component.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, Component, computed, input } from '@angular/core';
import { RouterLink } from '@angular/router';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronLeft } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { ButtonVariants } from '@spartan-ng/ui-button-helm';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import { ClassValue } from 'clsx';
import { HlmPaginationLinkDirective } from './hlm-pagination-link.directive';

@Component({
	selector: 'hlm-pagination-previous',
	imports: [HlmPaginationLinkDirective, NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideChevronLeft })],
	template: `
		<a
			[class]="_computedClass()"
			hlmPaginationLink
			[link]="link()"
			[queryParams]="queryParams()"
			[queryParamsHandling]="queryParamsHandling()"
			[size]="size()"
			[attr.aria-label]="ariaLabel()"
		>
			<ng-icon hlm size="sm" name="lucideChevronLeft" />
			<span [class.sr-only]="iconOnly()">{{ text() }}</span>
		</a>
	`,
})
export class HlmPaginationPreviousComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly link = input<RouterLink['routerLink']>();
	public readonly queryParams = input<RouterLink['queryParams']>();
	public readonly queryParamsHandling = input<RouterLink['queryParamsHandling']>();

	public readonly ariaLabel = input<string>('Go to previous page', { alias: 'aria-label' });
	public readonly text = input<string>('Previous');
	public readonly iconOnly = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	protected readonly size = computed<ButtonVariants['size']>(() => (this.iconOnly() ? 'icon' : 'default'));

	protected readonly _computedClass = computed(() => hlm('gap-1', !this.iconOnly() ? 'pl-2.5' : '', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/pagination/helm/src/lib/hlm-pagination.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const paginationVariants = cva('mx-auto flex w-full justify-center', {
	variants: {},
	defaultVariants: {},
});
export type PaginationVariants = VariantProps<typeof paginationVariants>;

@Directive({
	selector: '[hlmPagination]',
	standalone: true,
	host: {
		role: 'navigation',
		'[class]': '_computedClass()',
		'[attr.aria-label]': 'ariaLabel()',
	},
})
export class HlmPaginationDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	public readonly ariaLabel = input<string>('pagination', { alias: 'aria-label' });

	protected readonly _computedClass = computed(() => hlm(paginationVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/storybook/README.md
```
# ui-storybook

This library was generated with [Nx](https://nx.dev).

## Running Storybook

Run `nx storybook ui-storybook` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/storybook/postcss.config.js
```javascript
const { join } = require('node:path');

module.exports = {
	plugins: {
		tailwindcss: {
			config: join(__dirname, 'tailwind.config.js'),
		},
		autoprefixer: {},
	},
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/storybook/project.json
```json
{
	"name": "ui-storybook",
	"$schema": "../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/storybook/src",
	"prefix": "spartan-ng",
	"tags": [],
	"projectType": "library",
	"targets": {
		"storybook": {
			"executor": "@storybook/angular:start-storybook",
			"options": {
				"port": 4400,
				"configDir": "libs/ui/storybook/.storybook",
				"browserTarget": "ui-storybook:build-storybook",
				"compodoc": false,
				"styles": ["libs/ui/storybook/.storybook/tailwind.css"]
			},
			"configurations": {
				"ci": {
					"quiet": true
				}
			}
		},
		"build-storybook": {
			"executor": "@storybook/angular:build-storybook",
			"outputs": ["{options.outputDir}"],
			"options": {
				"outputDir": "dist/storybook/ui-storybook",
				"configDir": "libs/ui/storybook/.storybook",
				"browserTarget": "ui-storybook:build-storybook",
				"compodoc": false,
				"styles": ["libs/ui/storybook/.storybook/tailwind.css"]
			},
			"configurations": {
				"ci": {
					"quiet": true
				}
			}
		},
		"static-storybook": {
			"executor": "@nx/web:file-server",
			"options": {
				"buildTarget": "ui-storybook:build-storybook",
				"staticFilePath": "dist/storybook/ui-storybook"
			},
			"configurations": {
				"ci": {
					"buildTarget": "ui-storybook:build-storybook:ci"
				}
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/storybook/tailwind.config.js
```javascript
const { createGlobPatternsForDependencies } = require('@nx/angular/tailwind');
const { join } = require('node:path');

/** @type {import('tailwindcss').Config} */
module.exports = {
	darkMode: ['class', '[data-mode="dark"]'],
	presets: [require('../../../libs/brain/hlm-tailwind-preset.js')],
	content: [join(__dirname, '../**/!(*.spec).{ts,html}'), ...createGlobPatternsForDependencies(__dirname)],
	theme: {
		extend: {},
	},
	plugins: [],
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/storybook/tsconfig.json
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
			"path": "./.storybook/tsconfig.json"
		}
	],
	"extends": "../../../tsconfig.base.json",
	"angularCompilerOptions": {
		"enableI18nLegacyMessageIdFormat": false,
		"strictInjectionParameters": true,
		"strictInputAccessModifiers": true,
		"strictTemplates": true
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/storybook/tsconfig.lib.json
```json
{
	"extends": "./tsconfig.json",
	"compilerOptions": {
		"outDir": "../../../dist/out-tsc",
		"declaration": true,
		"declarationMap": true,
		"inlineSources": true,
		"types": []
	},
	"exclude": [
		"src/**/*.spec.ts",
		"src/test-setup.ts",
		"jest.config.ts",
		"src/**/*.test.ts",
		"**/*.stories.ts",
		"**/*.stories.js"
	],
	"include": ["src/**/*.ts"]
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/storybook/src/index.ts
```typescript
// placeholder as this project is simply a wrapper for
// running storybook for all ui primitives

console.log('I should not be an empty file!');

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/tooltip.stories.ts
```typescript
import { Component, signal } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucidePlus } from '@ng-icons/lucide';
import { BrnTooltipContentDirective } from '@spartan-ng/brain/tooltip';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmTooltipComponent, HlmTooltipTriggerDirective } from './helm/src';

const meta: Meta<HlmTooltipComponent> = {
	title: 'Tooltip',
	component: HlmTooltipComponent,
	tags: ['autodocs'],
	argTypes: {},
	decorators: [
		moduleMetadata({
			imports: [
				HlmButtonDirective,
				HlmTooltipComponent,
				BrnTooltipContentDirective,
				HlmTooltipTriggerDirective,
				NgIcon,
				HlmIconDirective,
			],
			providers: [provideIcons({ lucidePlus })],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmTooltipComponent>;
export const Default: Story = {
	argTypes: {
		position: {
			control: { type: 'radio' },
			options: ['above', 'below', 'left', 'right'],
			defaultValue: 'above',
		},
	},
	render: ({ ...args }) => ({
		props: args,
		template: `
<div class='p-40'>
  <hlm-tooltip>
    <button hlmTooltipTrigger ${argsToTemplate(args)} aria-describedby='Hello world' hlmBtn variant='outline'>Test</button>
    <span *brnTooltipContent class='flex items-center'>
      Add to library <ng-icon hlm class='ml-2' size='sm' name='lucidePlus'/>
     </span>
  </hlm-tooltip>
</div>
`,
	}),
};

@Component({
	selector: 'simple-tooltip-story',
	standalone: true,
	imports: [
		HlmButtonDirective,
		HlmTooltipComponent,
		BrnTooltipContentDirective,
		HlmTooltipTriggerDirective,
		NgIcon,
		HlmIconDirective,
	],
	providers: [provideIcons({ lucidePlus })],
	template: `
		<div class="p-40">
			<button
				(click)="disabled.set(!disabled())"
				aria-describedby="Add to library"
				[hlmTooltipTrigger]="'Add to library'"
				[hlmTooltipDisabled]="disabled()"
				hlmBtn
				variant="icon"
			>
				<ng-icon hlm name="lucidePlus" size="sm" />
			</button>
		</div>
	`,
})
class SimpleTooltip {
	protected readonly disabled = signal(false);
}

export const Simple: Story = {
	render: () => ({
		moduleMetadata: {
			imports: [SimpleTooltip],
		},
		template: '<simple-tooltip-story/>',
	}),
};

@Component({
	selector: 'disabled-tooltip-story',
	standalone: true,
	imports: [
		HlmButtonDirective,
		HlmTooltipComponent,
		BrnTooltipContentDirective,
		HlmTooltipTriggerDirective,
		NgIcon,
		HlmIconDirective,
	],
	providers: [provideIcons({ lucidePlus })],
	template: `
		<div class="p-40">
			<hlm-tooltip>
				<button
					(click)="disabled.set(!disabled())"
					hlmTooltipTrigger
					[hlmTooltipDisabled]="disabled()"
					aria-describedby="Hello world"
					hlmBtn
					variant="outline"
				>
					Test
				</button>
				<span *brnTooltipContent class="flex items-center">
					Add to library
					<ng-icon hlm class="ml-2" size="sm" name="lucidePlus" />
				</span>
			</hlm-tooltip>
			<p>{{ disabled() ? 'disabled' : 'enabled' }}</p>
		</div>
	`,
})
class DisabledTooltip {
	protected readonly disabled = signal(false);
}

export const Disabled: Story = {
	render: () => ({
		moduleMetadata: {
			imports: [DisabledTooltip],
		},
		template: '<disabled-tooltip-story/>',
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/README.md
```
# ui-tooltip-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-tooltip-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/eslint.config.js
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
		},
	},
	{
		files: ['**/*.html'],
		// Override or add rules here
		rules: {},
	},
];

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-tooltip-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/tooltip/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/package.json
```json
{
	"name": "@spartan-ng/ui-tooltip-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/project.json
```json
{
	"name": "ui-tooltip-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/tooltip/helm/src",
	"prefix": "helm",
	"tags": ["scope:helm"],
	"projectType": "library",
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/tooltip/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/tooltip/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/tooltip/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/tooltip/helm/jest.config.ts",
				"passWithNoTests": true
			},
			"configurations": {
				"ci": {
					"ci": true,
					"codeCoverage": true
				}
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"],
			"options": {
				"lintFilePatterns": [
					"libs/ui/tooltip/helm/**/*.ts",
					"libs/ui/tooltip/helm/**/*.html",
					"libs/ui/tooltip/helm/package.json",
					"libs/ui/tooltip/helm/project.json"
				]
			}
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-tooltip-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmTooltipTriggerDirective } from './lib/hlm-tooltip-trigger.directive';
import { HlmTooltipComponent } from './lib/hlm-tooltip.component';

export * from './lib/hlm-tooltip-trigger.directive';
export * from './lib/hlm-tooltip.component';

export const HlmTooltipImports = [HlmTooltipComponent, HlmTooltipTriggerDirective] as const;

@NgModule({
	imports: [...HlmTooltipImports],
	exports: [...HlmTooltipImports],
})
export class HlmTooltipModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/src/lib/hlm-tooltip-trigger.directive.ts
```typescript
import { Directive } from '@angular/core';
import { BrnTooltipTriggerDirective, provideBrnTooltipDefaultOptions } from '@spartan-ng/brain/tooltip';

const DEFAULT_TOOLTIP_CONTENT_CLASSES =
	'overflow-hidden rounded-md border border-border bg-popover px-3 py-1.5 text-sm text-popover-foreground shadow-md fade-in-0 zoom-in-95 ' +
	'data-[state=open]:animate-in ' +
	'data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 ' +
	'data-[side=below]:slide-in-from-top-2 data-[side=above]:slide-in-from-bottom-2 ' +
	'data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 ';

@Directive({
	selector: '[hlmTooltipTrigger]',
	standalone: true,
	providers: [
		provideBrnTooltipDefaultOptions({
			showDelay: 150,
			hideDelay: 300,
			exitAnimationDuration: 150,
			tooltipContentClasses: DEFAULT_TOOLTIP_CONTENT_CLASSES,
		}),
	],
	hostDirectives: [
		{
			directive: BrnTooltipTriggerDirective,
			inputs: [
				'brnTooltipDisabled: hlmTooltipDisabled',
				'brnTooltipTrigger: hlmTooltipTrigger',
				'aria-describedby',
				'position',
				'positionAtOrigin',
				'hideDelay',
				'showDelay',
				'exitAnimationDuration',
				'touchGestures',
			],
		},
	],
})
export class HlmTooltipTriggerDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/tooltip/helm/src/lib/hlm-tooltip.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation } from '@angular/core';
import { BrnTooltipDirective } from '@spartan-ng/brain/tooltip';

@Component({
	selector: 'hlm-tooltip',
	encapsulation: ViewEncapsulation.None,
	changeDetection: ChangeDetectionStrategy.OnPush,
	host: {
		'[style]': '{display: "contents"}',
	},
	hostDirectives: [BrnTooltipDirective],
	template: `
		<ng-content />
	`,
})
export class HlmTooltipComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/input-otp.stories.ts
```typescript
import { BrnInputOtpComponent } from '@spartan-ng/brain/input-otp';
import { type Meta, type StoryObj, moduleMetadata } from '@storybook/angular';
import {
	HlmInputOtpDirective,
	HlmInputOtpGroupDirective,
	HlmInputOtpSeparatorComponent,
	HlmInputOtpSlotComponent,
} from './helm/src/index';

const meta: Meta<BrnInputOtpComponent> = {
	title: 'Input OTP',
	component: BrnInputOtpComponent,
	tags: ['autodocs'],
	args: {},
	argTypes: {},
	decorators: [
		moduleMetadata({
			imports: [
				BrnInputOtpComponent,
				HlmInputOtpDirective,
				HlmInputOtpGroupDirective,
				HlmInputOtpSeparatorComponent,
				HlmInputOtpSlotComponent,
			],
		}),
	],
	render: ({ ...args }) => ({
		props: args,
		template: `
		<brn-input-otp hlm maxLength="6" inputClass="disabled:cursor-not-allowed">
			<div hlmInputOtpGroup>
				<hlm-input-otp-slot index="0" />
				<hlm-input-otp-slot index="1" />
				<hlm-input-otp-slot index="2" />
			</div>
			<hlm-input-otp-separator />
			<div hlmInputOtpGroup>
				<hlm-input-otp-slot index="3" />
				<hlm-input-otp-slot index="4" />
				<hlm-input-otp-slot index="5" />
			</div>
		</brn-input-otp>
		`,
	}),
};

export default meta;

type Story = StoryObj<BrnInputOtpComponent>;

export const Default: Story = {
	args: {},
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/README.md
```
# ui-input-otp-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-input-otp-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-input-otp-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/button/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/input-otp/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/package.json
```json
{
	"name": "@spartan-ng/ui-input-otp-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"peerDependencies": {
		"@angular/cdk": "19.2.2",
		"@angular/core": ">=19.0.0",
		"@ng-icons/core": "29.10.0",
		"@ng-icons/lucide": "30.3.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/project.json
```json
{
	"name": "ui-input-otp-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/input-otp/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/input-otp/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/input-otp/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/input-otp/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/input-otp/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-input-otp-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmInputOtpFakeCaretComponent } from './lib/hlm-input-otp-fake-caret.component';
import { HlmInputOtpGroupDirective } from './lib/hlm-input-otp-group.directive';
import { HlmInputOtpSeparatorComponent } from './lib/hlm-input-otp-separator.component';
import { HlmInputOtpSlotComponent } from './lib/hlm-input-otp-slot.component';
import { HlmInputOtpDirective } from './lib/hlm-input-otp.directive';

export * from './lib/hlm-input-otp-fake-caret.component';
export * from './lib/hlm-input-otp-group.directive';
export * from './lib/hlm-input-otp-separator.component';
export * from './lib/hlm-input-otp-slot.component';
export * from './lib/hlm-input-otp.directive';

@NgModule({
	imports: [
		HlmInputOtpDirective,
		HlmInputOtpGroupDirective,
		HlmInputOtpSeparatorComponent,
		HlmInputOtpSlotComponent,
		HlmInputOtpFakeCaretComponent,
	],
	exports: [
		HlmInputOtpDirective,
		HlmInputOtpGroupDirective,
		HlmInputOtpSeparatorComponent,
		HlmInputOtpSlotComponent,
		HlmInputOtpFakeCaretComponent,
	],
})
export class HlmInputOtpModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/src/lib/hlm-input-otp-fake-caret.component.ts
```typescript
import { Component } from '@angular/core';

@Component({
	selector: 'hlm-input-otp-fake-caret',
	standalone: true,
	template: `
		<div class="pointer-events-none absolute inset-0 flex items-center justify-center">
			<div class="animate-caret-blink bg-foreground h-4 w-px duration-1000"></div>
		</div>
	`,
})
export class HlmInputOtpFakeCaretComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/src/lib/hlm-input-otp-group.directive.ts
```typescript
import { computed, Directive, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type ClassValue } from 'clsx';

@Directive({
	selector: '[hlmInputOtpGroup]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmInputOtpGroupDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => hlm('flex items-center', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/src/lib/hlm-input-otp-separator.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideDot } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import { type ClassValue } from 'clsx';

@Component({
	selector: 'hlm-input-otp-separator',
	imports: [HlmIconDirective, NgIcon],
	providers: [provideIcons({ lucideDot })],
	template: `
		<ng-icon hlm name="lucideDot" />
	`,
	host: {
		role: 'separator',
		'[class]': '_computedClass()',
	},
})
export class HlmInputOtpSeparatorComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => hlm(this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/src/lib/hlm-input-otp-slot.component.ts
```typescript
import { NumberInput } from '@angular/cdk/coercion';
import { Component, computed, input, numberAttribute } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnInputOtpSlotComponent } from '@spartan-ng/brain/input-otp';
import { type ClassValue } from 'clsx';
import { HlmInputOtpFakeCaretComponent } from './hlm-input-otp-fake-caret.component';

@Component({
	selector: 'hlm-input-otp-slot',
	imports: [BrnInputOtpSlotComponent, HlmInputOtpFakeCaretComponent],
	template: `
		<brn-input-otp-slot [index]="index()">
			<hlm-input-otp-fake-caret />
		</brn-input-otp-slot>
	`,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmInputOtpSlotComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	public readonly index = input.required<number, NumberInput>({ transform: numberAttribute });

	protected readonly _computedClass = computed(() =>
		hlm(
			'relative flex h-10 w-10 items-center justify-center border-y border-r border-input text-sm transition-all first:rounded-l-md first:border-l last:rounded-r-md',
			'has-[brn-input-otp-slot[data-active="true"]]:z-10 has-[brn-input-otp-slot[data-active="true"]]:ring-2 has-[brn-input-otp-slot[data-active="true"]]:ring-ring has-[brn-input-otp-slot[data-active="true"]]:ring-offset-background',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input-otp/helm/src/lib/hlm-input-otp.directive.ts
```typescript
import { computed, Directive, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type ClassValue } from 'clsx';

@Directive({
	selector: 'brn-input-otp [hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmInputOtpDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm('flex items-center gap-2 has-[:disabled]:opacity-50', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/calendar.stories.ts
```typescript
import { type Meta, type StoryObj, moduleMetadata } from '@storybook/angular';
import { HlmCalendarComponent } from './helm/src/lib/hlm-calendar.component';

const meta: Meta<HlmCalendarComponent<Date>> = {
	title: 'Calendar',
	component: HlmCalendarComponent,
	tags: ['autodocs'],
	args: {},
	argTypes: {},
	decorators: [
		moduleMetadata({
			imports: [HlmCalendarComponent],
		}),
	],
	render: ({ ...args }) => ({
		props: args,
		template: `
		<div class="preview flex min-h-[350px] w-full justify-center p-10 items-center">
			<hlm-calendar [(date)]="date" [min]="min" [max]="max" />
		</div>
		`,
	}),
};

export default meta;

type Story = StoryObj<HlmCalendarComponent<Date>>;

export const Default: Story = {
	args: {
		date: new Date(2024, 5, 1),
		min: new Date(2024, 4, 1),
		max: new Date(2024, 6, 1),
	},
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/helm/README.md
```
# ui-calendar-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-calendar-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/helm/eslint.config.js
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
		},
	},
	{
		files: ['**/*.html'],
		// Override or add rules here
		rules: {},
	},
];

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-calendar-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/ui/calendar/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/calendar/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/helm/package.json
```json
{
	"name": "@spartan-ng/ui-calendar-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"peerDependencies": {
		"@angular/cdk": ">=19.0.0",
		"@angular/core": ">=19.0.0",
		"@ng-icons/core": ">=29.0.0",
		"@ng-icons/lucide": ">=29.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"@spartan-ng/ui-button-helm": "0.0.1-alpha.381",
		"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
		"clsx": "^2.1.1"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/helm/project.json
```json
{
	"name": "ui-calendar-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/calendar/helm/src",
	"prefix": "brn",
	"projectType": "library",
	"tags": ["scope:help"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/calendar/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/calendar/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/calendar/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/calendar/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint"
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-calendar-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/helm/tsconfig.json
```json
{
	"compilerOptions": {
		"target": "es2022",
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmCalendarMultiComponent } from './lib/hlm-calendar-multi.component';
import { HlmCalendarComponent } from './lib/hlm-calendar.component';

export * from './lib/hlm-calendar-multi.component';
export * from './lib/hlm-calendar.component';

export const HlmCalendarImports = [HlmCalendarComponent, HlmCalendarMultiComponent] as const;

@NgModule({
	imports: [...HlmCalendarImports],
	exports: [...HlmCalendarImports],
})
export class HlmCalendarModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/helm/src/lib/hlm-calendar-multi.component.ts
```typescript
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import { Component, booleanAttribute, computed, input, model, numberAttribute, viewChild } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronLeft, lucideChevronRight } from '@ng-icons/lucide';
import {
	BrnCalendarCellButtonDirective,
	BrnCalendarCellDirective,
	BrnCalendarGridDirective,
	BrnCalendarHeaderDirective,
	BrnCalendarMultiDirective,
	BrnCalendarNextButtonDirective,
	BrnCalendarPreviousButtonDirective,
	BrnCalendarWeekDirective,
	BrnCalendarWeekdayDirective,
	Weekday,
	injectBrnCalendarI18n,
} from '@spartan-ng/brain/calendar';
import { hlm } from '@spartan-ng/brain/core';
import { injectDateAdapter } from '@spartan-ng/brain/date-time';
import { buttonVariants } from '@spartan-ng/ui-button-helm';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-calendar-multi',
	imports: [
		BrnCalendarMultiDirective,
		BrnCalendarHeaderDirective,
		BrnCalendarNextButtonDirective,
		BrnCalendarPreviousButtonDirective,
		BrnCalendarWeekdayDirective,
		BrnCalendarWeekDirective,
		BrnCalendarCellButtonDirective,
		BrnCalendarCellDirective,
		BrnCalendarGridDirective,
		NgIcon,
		HlmIconDirective,
	],
	viewProviders: [provideIcons({ lucideChevronLeft, lucideChevronRight })],
	template: `
		<div
			brnCalendarMulti
			[min]="min()"
			[max]="max()"
			[minSelection]="minSelection()"
			[maxSelection]="maxSelection()"
			[disabled]="disabled()"
			[(date)]="date"
			[dateDisabled]="dateDisabled()"
			[weekStartsOn]="weekStartsOn()"
			[defaultFocusedDate]="defaultFocusedDate()"
			[class]="_computedCalenderClass()"
		>
			<div class="inline-flex flex-col space-y-4">
				<!-- Header -->
				<div class="space-y-4">
					<div class="relative flex items-center justify-center pt-1">
						<div brnCalendarHeader class="text-sm font-medium">
							{{ heading() }}
						</div>

						<div class="flex items-center space-x-1">
							<button
								brnCalendarPreviousButton
								class="ring-offset-background focus-visible:ring-ring border-input hover:bg-accent hover:text-accent-foreground absolute left-1 inline-flex h-7 w-7 items-center justify-center whitespace-nowrap rounded-md border bg-transparent p-0 text-sm font-medium opacity-50 transition-colors hover:opacity-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50"
							>
								<ng-icon hlm name="lucideChevronLeft" size="sm" />
							</button>

							<button
								brnCalendarNextButton
								class="ring-offset-background focus-visible:ring-ring border-input hover:bg-accent hover:text-accent-foreground absolute right-1 inline-flex h-7 w-7 items-center justify-center whitespace-nowrap rounded-md border bg-transparent p-0 text-sm font-medium opacity-50 transition-colors hover:opacity-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50"
							>
								<ng-icon hlm name="lucideChevronRight" size="sm" />
							</button>
						</div>
					</div>
				</div>

				<table class="w-full border-collapse space-y-1" brnCalendarGrid>
					<thead>
						<tr class="flex">
							<th
								*brnCalendarWeekday="let weekday"
								scope="col"
								class="text-muted-foreground w-9 rounded-md text-[0.8rem] font-normal"
								[attr.aria-label]="i18n.labelWeekday(weekday)"
							>
								{{ i18n.formatWeekdayName(weekday) }}
							</th>
						</tr>
					</thead>

					<tbody role="rowgroup">
						<tr *brnCalendarWeek="let week" class="mt-2 flex w-full">
							@for (date of week; track dateAdapter.getTime(date)) {
								<td
									brnCalendarCell
									class="data-[selected]:data-[outside]:bg-accent/50 data-[selected]:bg-accent relative h-9 w-9 p-0 text-center text-sm focus-within:relative focus-within:z-20 first:data-[selected]:rounded-l-md last:data-[selected]:rounded-r-md [&:has([aria-selected].day-range-end)]:rounded-r-md"
								>
									<button brnCalendarCellButton [date]="date" [class]="btnClass">
										{{ dateAdapter.getDate(date) }}
									</button>
								</td>
							}
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	`,
})
export class HlmCalendarMultiComponent<T> {
	public readonly calendarClass = input<ClassValue>('');

	protected readonly _computedCalenderClass = computed(() => hlm('rounded-md border p-3', this.calendarClass()));

	/** Access the calendar i18n */
	protected readonly i18n = injectBrnCalendarI18n();

	/** Access the date time adapter */
	protected readonly dateAdapter = injectDateAdapter<T>();

	/** The minimum date that can be selected.*/
	public readonly min = input<T>();

	/** The maximum date that can be selected. */
	public readonly max = input<T>();

	/** The minimum selectable dates.  */
	public readonly minSelection = input<number, NumberInput>(undefined, {
		transform: numberAttribute,
	});

	/** The maximum selectable dates.  */
	public readonly maxSelection = input<number, NumberInput>(undefined, {
		transform: numberAttribute,
	});

	/** Determine if the date picker is disabled. */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** The selected value. */
	public readonly date = model<T[]>();

	/** Whether a specific date is disabled. */
	public readonly dateDisabled = input<(date: T) => boolean>(() => false);

	/** The day the week starts on */
	public readonly weekStartsOn = input<Weekday, NumberInput>(0, {
		transform: (v: unknown) => numberAttribute(v) as Weekday,
	});

	/** The default focused date. */
	public readonly defaultFocusedDate = input<T>();

	/** Access the calendar directive */
	private readonly _calendar = viewChild.required(BrnCalendarMultiDirective);

	/** Get the heading for the current month and year */
	protected heading = computed(() =>
		this.i18n.formatHeader(
			this.dateAdapter.getMonth(this._calendar().focusedDate()),
			this.dateAdapter.getYear(this._calendar().focusedDate()),
		),
	);

	protected readonly btnClass = hlm(
		buttonVariants({ variant: 'ghost' }),
		'h-9 w-9 p-0 font-normal aria-selected:opacity-100',
		'data-[outside]:text-muted-foreground data-[outside]:opacity-50 data-[outside]:aria-selected:bg-accent/50 data-[outside]:aria-selected:text-muted-foreground data-[outside]:aria-selected:opacity-30',
		'data-[today]:bg-accent data-[today]:text-accent-foreground',
		'data-[selected]:bg-primary data-[selected]:text-primary-foreground data-[selected]:hover:bg-primary data-[selected]:hover:text-primary-foreground data-[selected]:focus:bg-primary data-[selected]:focus:text-primary-foreground',
		'data-[disabled]:text-muted-foreground data-[disabled]:opacity-50',
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/calendar/helm/src/lib/hlm-calendar.component.ts
```typescript
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import { Component, booleanAttribute, computed, input, model, numberAttribute, viewChild } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronLeft, lucideChevronRight } from '@ng-icons/lucide';
import {
	BrnCalendarCellButtonDirective,
	BrnCalendarCellDirective,
	BrnCalendarDirective,
	BrnCalendarGridDirective,
	BrnCalendarHeaderDirective,
	BrnCalendarNextButtonDirective,
	BrnCalendarPreviousButtonDirective,
	BrnCalendarWeekDirective,
	BrnCalendarWeekdayDirective,
	Weekday,
	injectBrnCalendarI18n,
} from '@spartan-ng/brain/calendar';
import { hlm } from '@spartan-ng/brain/core';
import { injectDateAdapter } from '@spartan-ng/brain/date-time';
import { buttonVariants } from '@spartan-ng/ui-button-helm';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-calendar',
	imports: [
		BrnCalendarDirective,
		BrnCalendarHeaderDirective,
		BrnCalendarNextButtonDirective,
		BrnCalendarPreviousButtonDirective,
		BrnCalendarWeekdayDirective,
		BrnCalendarWeekDirective,
		BrnCalendarCellButtonDirective,
		BrnCalendarCellDirective,
		BrnCalendarGridDirective,
		NgIcon,
		HlmIconDirective,
	],
	viewProviders: [provideIcons({ lucideChevronLeft, lucideChevronRight })],
	template: `
		<div
			brnCalendar
			[min]="min()"
			[max]="max()"
			[disabled]="disabled()"
			[(date)]="date"
			[dateDisabled]="dateDisabled()"
			[weekStartsOn]="weekStartsOn()"
			[defaultFocusedDate]="defaultFocusedDate()"
			[class]="_computedCalenderClass()"
		>
			<div class="inline-flex flex-col space-y-4">
				<!-- Header -->
				<div class="space-y-4">
					<div class="relative flex items-center justify-center pt-1">
						<div brnCalendarHeader class="text-sm font-medium">
							{{ heading() }}
						</div>

						<div class="flex items-center space-x-1">
							<button
								brnCalendarPreviousButton
								class="ring-offset-background focus-visible:ring-ring border-input hover:bg-accent hover:text-accent-foreground absolute left-1 inline-flex h-7 w-7 items-center justify-center whitespace-nowrap rounded-md border bg-transparent p-0 text-sm font-medium opacity-50 transition-colors hover:opacity-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50"
							>
								<ng-icon hlm name="lucideChevronLeft" size="sm" />
							</button>

							<button
								brnCalendarNextButton
								class="ring-offset-background focus-visible:ring-ring border-input hover:bg-accent hover:text-accent-foreground absolute right-1 inline-flex h-7 w-7 items-center justify-center whitespace-nowrap rounded-md border bg-transparent p-0 text-sm font-medium opacity-50 transition-colors hover:opacity-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50"
							>
								<ng-icon hlm name="lucideChevronRight" size="sm" />
							</button>
						</div>
					</div>
				</div>

				<table class="w-full border-collapse space-y-1" brnCalendarGrid>
					<thead>
						<tr class="flex">
							<th
								*brnCalendarWeekday="let weekday"
								scope="col"
								class="text-muted-foreground w-9 rounded-md text-[0.8rem] font-normal"
								[attr.aria-label]="i18n.labelWeekday(weekday)"
							>
								{{ i18n.formatWeekdayName(weekday) }}
							</th>
						</tr>
					</thead>

					<tbody role="rowgroup">
						<tr *brnCalendarWeek="let week" class="mt-2 flex w-full">
							@for (date of week; track dateAdapter.getTime(date)) {
								<td
									brnCalendarCell
									class="data-[selected]:data-[outside]:bg-accent/50 data-[selected]:bg-accent relative h-9 w-9 p-0 text-center text-sm focus-within:relative focus-within:z-20 first:data-[selected]:rounded-l-md last:data-[selected]:rounded-r-md [&:has([aria-selected].day-range-end)]:rounded-r-md"
								>
									<button brnCalendarCellButton [date]="date" [class]="btnClass">
										{{ dateAdapter.getDate(date) }}
									</button>
								</td>
							}
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	`,
})
export class HlmCalendarComponent<T> {
	public readonly calendarClass = input<ClassValue>('');

	protected readonly _computedCalenderClass = computed(() => hlm('rounded-md border p-3', this.calendarClass()));

	/** Access the calendar i18n */
	protected readonly i18n = injectBrnCalendarI18n();

	/** Access the date time adapter */
	protected readonly dateAdapter = injectDateAdapter<T>();

	/** The minimum date that can be selected.*/
	public readonly min = input<T>();

	/** The maximum date that can be selected. */
	public readonly max = input<T>();

	/** Determine if the date picker is disabled. */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** The selected value. */
	public readonly date = model<T>();

	/** Whether a specific date is disabled. */
	public readonly dateDisabled = input<(date: T) => boolean>(() => false);

	/** The day the week starts on */
	public readonly weekStartsOn = input<Weekday, NumberInput>(0, {
		transform: (v: unknown) => numberAttribute(v) as Weekday,
	});

	/** The default focused date. */
	public readonly defaultFocusedDate = input<T>();

	/** Access the calendar directive */
	private readonly _calendar = viewChild.required(BrnCalendarDirective);

	/** Get the heading for the current month and year */
	protected heading = computed(() =>
		this.i18n.formatHeader(
			this.dateAdapter.getMonth(this._calendar().focusedDate()),
			this.dateAdapter.getYear(this._calendar().focusedDate()),
		),
	);

	protected readonly btnClass = hlm(
		buttonVariants({ variant: 'ghost' }),
		'h-9 w-9 p-0 font-normal aria-selected:opacity-100',
		'data-[outside]:text-muted-foreground data-[outside]:opacity-50 data-[outside]:aria-selected:bg-accent/50 data-[outside]:aria-selected:text-muted-foreground data-[outside]:aria-selected:opacity-30',
		'data-[today]:bg-accent data-[today]:text-accent-foreground',
		'data-[selected]:bg-primary data-[selected]:text-primary-foreground data-[selected]:hover:bg-primary data-[selected]:hover:text-primary-foreground data-[selected]:focus:bg-primary data-[selected]:focus:text-primary-foreground',
		'data-[disabled]:text-muted-foreground data-[disabled]:opacity-50',
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/card.stories.ts
```typescript
import type { Meta, StoryObj } from '@storybook/angular';
import { moduleMetadata } from '@storybook/angular';
import { HlmBadgeDirective } from '../badge/helm/src';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmInputDirective } from '../input/helm/src';
import { HlmLabelDirective } from '../label/helm/src';
import { HlmCardDirective, HlmCardImports } from './helm/src';

const meta: Meta<HlmCardDirective> = {
	title: 'Card',
	component: HlmCardDirective,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [HlmCardImports, HlmLabelDirective, HlmInputDirective, HlmButtonDirective, HlmBadgeDirective],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmCardDirective>;

export const Default: Story = {
	render: () => ({
		template: `
    <section class='max-w-lg mx-auto' hlmCard>
       <div hlmCardHeader>
        <h3 hlmCardTitle>Create new project</h3>
        <p hlmCardDescription>
          Deploy your new project in one-click.
        </p>
      </div>
      <p hlmCardContent>
       <label class='block' hlmLabel>Name
       <input class='w-full mt-1.5' placeholder='Name of your project' hlmInput>
       </label>

       <label class='block my-4' hlmLabel>Framework
       <select class='w-full mt-1.5' hlmInput>
        <option>Angular</option>
        <option>React</option>
        <option>Vue</option>
       </select>
       </label>
      </p>
      <div hlmCardFooter class='justify-between'>
        <button hlmBtn variant='ghost'>Cancel</button>
        <button hlmBtn>Create</button>
      </div>
    </section>
    `,
	}),
};

export const Transposed: Story = {
	render: () => ({
		template: `
    <section class='max-w-lg mx-auto' hlmCard>
       <div hlmCardHeader direction='row'>
        <h3 hlmCardTitle>AngularGPT</h3>
        <p hlmCardDescription>
          <span variant='secondary' hlmBadge>beta</span>
        </p>
      </div>
      <p hlmCardContent>
       <label class='block' hlmLabel>E-mail
       <input class='w-full mt-1.5' placeholder='you@spartan-ng' hlmInput>
       </label>
         <label class='block my-4' hlmLabel>Password
       <input class='w-full mt-1.5' type='password' hlmInput>
       </label>
      </p>
      <div hlmCardFooter direction='column'>
        <button hlmBtn>Sign In</button>
        <button hlmBtn variant='ghost'>Create Account</button>
      </div>
    </section>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/README.md
```
# ui-card-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-card-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-card-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/card/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/package.json
```json
{
	"name": "@spartan-ng/ui-card-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/project.json
```json
{
	"name": "ui-card-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/card/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/card/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/card/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/card/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/card/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-card-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmCardContentDirective } from './lib/hlm-card-content.directive';
import { HlmCardDescriptionDirective } from './lib/hlm-card-description.directive';
import { HlmCardFooterDirective } from './lib/hlm-card-footer.directive';
import { HlmCardHeaderDirective } from './lib/hlm-card-header.directive';
import { HlmCardTitleDirective } from './lib/hlm-card-title.directive';
import { HlmCardDirective } from './lib/hlm-card.directive';

export * from './lib/hlm-card-content.directive';
export * from './lib/hlm-card-description.directive';
export * from './lib/hlm-card-footer.directive';
export * from './lib/hlm-card-header.directive';
export * from './lib/hlm-card-title.directive';
export * from './lib/hlm-card.directive';

export const HlmCardImports = [
	HlmCardDirective,
	HlmCardHeaderDirective,
	HlmCardFooterDirective,
	HlmCardTitleDirective,
	HlmCardDescriptionDirective,
	HlmCardContentDirective,
] as const;

@NgModule({
	imports: [...HlmCardImports],
	exports: [...HlmCardImports],
})
export class HlmCardModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/lib/hlm-card-content.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const cardContentVariants = cva('p-6 pt-0', {
	variants: {},
	defaultVariants: {},
});
export type CardContentVariants = VariantProps<typeof cardContentVariants>;

@Directive({
	selector: '[hlmCardContent]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCardContentDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(cardContentVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/lib/hlm-card-description.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const cardDescriptionVariants = cva('text-sm text-muted-foreground', {
	variants: {},
	defaultVariants: {},
});
export type CardDescriptionVariants = VariantProps<typeof cardDescriptionVariants>;

@Directive({
	selector: '[hlmCardDescription]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCardDescriptionDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(cardDescriptionVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/lib/hlm-card-footer.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const cardFooterVariants = cva('flex p-6 pt-0', {
	variants: {
		direction: {
			row: 'flex-row items-center space-x-1.5',
			column: 'flex-col space-y-1.5',
		},
	},
	defaultVariants: {
		direction: 'row',
	},
});
export type CardFooterVariants = VariantProps<typeof cardFooterVariants>;

@Directive({
	selector: '[hlmCardFooter]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCardFooterDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(cardFooterVariants({ direction: this.direction() }), this.userClass()));

	public readonly direction = input<CardFooterVariants['direction']>('row');
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/lib/hlm-card-header.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const cardHeaderVariants = cva('flex p-6', {
	variants: {
		direction: {
			row: 'flex-row items-center space-x-1.5',
			column: 'flex-col space-y-1.5',
		},
	},
	defaultVariants: {
		direction: 'column',
	},
});
export type CardHeaderVariants = VariantProps<typeof cardHeaderVariants>;

@Directive({
	selector: '[hlmCardHeader]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCardHeaderDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(cardHeaderVariants({ direction: this.direction() }), this.userClass()));

	public readonly direction = input<CardHeaderVariants['direction']>('column');
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/lib/hlm-card-title.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const cardTitleVariants = cva('text-lg font-semibold leading-none tracking-tight', {
	variants: {},
	defaultVariants: {},
});
export type CardTitleVariants = VariantProps<typeof cardTitleVariants>;

@Directive({
	selector: '[hlmCardTitle]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCardTitleDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(cardTitleVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/card/helm/src/lib/hlm-card.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const cardVariants = cva(
	'rounded-lg border border-border bg-card focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 text-card-foreground shadow-sm',
	{
		variants: {},
		defaultVariants: {},
	},
);
export type CardVariants = VariantProps<typeof cardVariants>;

@Directive({
	selector: '[hlmCard]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCardDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(cardVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/core/package.json
```json

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/progress.stories.ts
```typescript
import { BrnProgressComponent, BrnProgressImports } from '@spartan-ng/brain/progress';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmLabelDirective } from '../label/helm/src';
import { HlmProgressImports } from './helm/src';

const meta: Meta<BrnProgressComponent> = {
	title: 'Progress',
	component: BrnProgressComponent,
	tags: ['autodocs'],
	args: {
		value: 30,
	},
	argTypes: {
		value: {
			control: { type: 'range', min: 0, max: 100, step: 2 },
		},
	},
	decorators: [
		moduleMetadata({
			imports: [BrnProgressImports, HlmProgressImports, HlmLabelDirective],
		}),
	],
};

export default meta;
type Story = StoryObj<BrnProgressComponent>;

export const LoadingNotStarted: Story = {
	args: {
		value: 0,
	},
	render: ({ ...args }) => ({
		props: { ...args },
		template: `
    <h2 hlmLabel id='loading'>Loading (not started)</h2>
    <brn-progress class='mt-2 mb-8' aria-labelledby='loading' hlm ${argsToTemplate(args)}>
      <brn-progress-indicator hlm/>
    </brn-progress>
    `,
	}),
};

export const LoadingStarted: Story = {
	render: ({ ...args }) => ({
		props: { ...args },
		template: `
    <h2 hlmLabel id='loading'>Loading (started)</h2>
    <brn-progress class='mt-2 mb-8' aria-labelledby='loading started' hlm ${argsToTemplate(args)}>
      <brn-progress-indicator hlm/>
    </brn-progress>
    `,
	}),
};

export const Indeterminate: Story = {
	args: {
		value: null,
	},
	render: ({ ...args }) => ({
		props: args,
		template: `
    <h2 hlmLabel id='indeterminate'>Indeterminate</h2>
    <brn-progress class='mt-2 mb-8' aria-labelledby='indeterminate' hlm ${argsToTemplate(args)}>
      <brn-progress-indicator hlm/>
    </brn-progress>
    `,
	}),
};

export const Complete: Story = {
	args: {
		value: 100,
	},
	render: ({ ...args }) => ({
		props: args,
		template: `
    <h2 hlmLabel id='complete'>Complete</h2>
    <brn-progress class='mt-2 mb-8' aria-labelledby='complete' hlm ${argsToTemplate(args)}>
      <brn-progress-indicator hlm/>
    </brn-progress>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/README.md
```
# ui-progress-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-progress-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-progress-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/progress/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/package.json
```json
{
	"name": "@spartan-ng/ui-progress-helm",
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/project.json
```json
{
	"name": "ui-progress-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/progress/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/progress/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/progress/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/progress/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/progress/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-progress-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmProgressIndicatorDirective } from './lib/hlm-progress-indicator.directive';
import { HlmProgressDirective } from './lib/hlm-progress.directive';

export * from './lib/hlm-progress-indicator.directive';
export * from './lib/hlm-progress.directive';

export const HlmProgressImports = [HlmProgressDirective, HlmProgressIndicatorDirective] as const;

@NgModule({
	imports: [...HlmProgressImports],
	exports: [...HlmProgressImports],
})
export class HlmProgressModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/src/lib/hlm-progress-indicator.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { injectBrnProgress } from '@spartan-ng/brain/progress';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmProgressIndicator],brn-progress-indicator[hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		'[class.animate-indeterminate]': 'indeterminate()',
		'[style.transform]': 'transform()',
	},
})
export class HlmProgressIndicatorDirective {
	private readonly _progress = injectBrnProgress();
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm('inline-flex transform-gpu h-full w-full flex-1 bg-primary transition-all', this.userClass()),
	);

	protected readonly transform = computed(() => `translateX(-${100 - (this._progress.value() ?? 100)}%)`);

	protected readonly indeterminate = computed(
		() => this._progress.value() === null || this._progress.value() === undefined,
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/progress/helm/src/lib/hlm-progress.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmProgress],brn-progress[hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmProgressDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('inline-flex relative h-4 w-full overflow-hidden rounded-full bg-secondary', this.userClass()),
	);
}

```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/input.stories.ts
```typescript
import { FormsModule } from '@angular/forms';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmLabelDirective } from '../label/helm/src';
import { HlmInputDirective } from './helm/src';

const meta: Meta<HlmInputDirective> = {
	title: 'Input',
	component: HlmInputDirective,
	tags: ['autodocs'],
	args: {
		size: 'default',
		error: 'auto',
	},
	argTypes: {
		size: {
			options: ['default', 'sm', 'lg'],
			control: {
				type: 'select',
			},
		},
		error: {
			options: ['auto', 'true'],
			control: {
				type: 'select',
			},
		},
	},
	decorators: [
		moduleMetadata({
			imports: [HlmInputDirective, HlmLabelDirective, HlmButtonDirective, FormsModule],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmInputDirective>;

export const Default: Story = {
	render: ({ ...args }) => ({
		props: args,
		template: `
    <input aria-label='Email' class='w-80' hlmInput ${argsToTemplate(args)} type='email' placeholder='Email'/>
    `,
	}),
};

export const File: Story = {
	render: ({ ...args }) => ({
		props: args,
		template: `
    <div class="grid w-full max-w-sm items-center gap-1.5">
      <label hlmLabel for="picture">Picture</label>
      <input class='w-80' hlmInput ${argsToTemplate(args)} id="picture" type="file" />
    </div>`,
	}),
};

export const Disabled: Story = {
	render: ({ ...args }) => ({
		props: args,
		template: `
    <input aria-label='Email' disabled class='w-80' hlmInput ${argsToTemplate(args)} type='email' placeholder='Email'/>
    `,
	}),
};

export const Required: Story = {
	render: ({ ...args }) => ({
		props: { value: '', ...args },
		template: `
    <input aria-label='Email *' [(ngModel)]="value" class='w-80' hlmInput ${argsToTemplate(args)} type='email' required placeholder='Email *'/>
    `,
	}),
};

export const Error: Story = {
	render: ({ ...args }) => ({
		props: { ...args, error: 'true' },
		template: `
    <input aria-label='Email' class='w-80' hlmInput ${argsToTemplate(args)} type='email' placeholder='Email' />
    `,
	}),
};

export const WithButton: Story = {
	name: 'With Button',
	render: ({ ...args }) => ({
		props: args,
		template: `
    <div class="flex items-center w-full max-w-sm space-x-2">
    <input aria-label='Email' class='w-80' hlmInput ${argsToTemplate(args)} type='email' placeholder='Email'/>
    <button hlmBtn>Subscribe</button>
    </div>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/helm/README.md
```
# ui-input-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-input-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-input-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/button/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/input/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/helm/package.json
```json
{
	"name": "@spartan-ng/ui-input-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@angular/forms": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/helm/project.json
```json
{
	"name": "ui-input-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/input/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/input/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/input/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/input/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/input/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-input-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmInputErrorDirective } from './lib/hlm-input-error.directive';
import { HlmInputDirective } from './lib/hlm-input.directive';

export * from './lib/hlm-input-error.directive';
export * from './lib/hlm-input.directive';

@NgModule({
	imports: [HlmInputDirective, HlmInputErrorDirective],
	exports: [HlmInputDirective, HlmInputErrorDirective],
})
export class HlmInputModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/helm/src/lib/hlm-input-error.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const inputErrorVariants = cva('text-destructive text-sm font-medium', {
	variants: {},
	defaultVariants: {},
});
export type InputErrorVariants = VariantProps<typeof inputErrorVariants>;

@Directive({
	selector: '[hlmInputError]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmInputErrorDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(inputErrorVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/input/helm/src/lib/hlm-input.directive.ts
```typescript
import { Directive, type DoCheck, Injector, computed, effect, inject, input, signal, untracked } from '@angular/core';
import { FormGroupDirective, NgControl, NgForm } from '@angular/forms';
import { hlm } from '@spartan-ng/brain/core';
import { BrnFormFieldControl } from '@spartan-ng/brain/form-field';
import { ErrorStateMatcher, ErrorStateTracker } from '@spartan-ng/brain/forms';

import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const inputVariants = cva(
	'flex rounded-md border font-normal border-input bg-transparent text-base md:text-sm ring-offset-background file:border-0 file:text-foreground file:bg-transparent file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50',
	{
		variants: {
			size: {
				default: 'h-10 py-2 px-4 file:max-md:py-0',
				sm: 'h-9 px-3 file:md:py-2 file:max-md:py-1.5',
				lg: 'h-11 px-8 file:md:py-3 file:max-md:py-2.5',
			},
			error: {
				auto: '[&.ng-invalid.ng-touched]:text-destructive [&.ng-invalid.ng-touched]:border-destructive [&.ng-invalid.ng-touched]:focus-visible:ring-destructive',
				true: 'text-destructive border-destructive focus-visible:ring-destructive',
			},
		},
		defaultVariants: {
			size: 'default',
			error: 'auto',
		},
	},
);
type InputVariants = VariantProps<typeof inputVariants>;

@Directive({
	selector: '[hlmInput]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	providers: [
		{
			provide: BrnFormFieldControl,
			useExisting: HlmInputDirective,
		},
	],
})
export class HlmInputDirective implements BrnFormFieldControl, DoCheck {
	public readonly size = input<InputVariants['size']>('default');

	public readonly error = input<InputVariants['error']>('auto');

	protected readonly state = computed(() => ({
		error: signal(this.error()),
	}));

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(inputVariants({ size: this.size(), error: this.state().error() }), this.userClass()),
	);

	private readonly _injector = inject(Injector);

	public readonly ngControl: NgControl | null = this._injector.get(NgControl, null);

	private readonly _errorStateTracker: ErrorStateTracker;

	private readonly _defaultErrorStateMatcher = inject(ErrorStateMatcher);
	private readonly _parentForm = inject(NgForm, { optional: true });
	private readonly _parentFormGroup = inject(FormGroupDirective, { optional: true });

	public readonly errorState = computed(() => this._errorStateTracker.errorState());

	constructor() {
		this._errorStateTracker = new ErrorStateTracker(
			this._defaultErrorStateMatcher,
			this.ngControl,
			this._parentFormGroup,
			this._parentForm,
		);

		effect(() => {
			const error = this._errorStateTracker.errorState();
			untracked(() => {
				if (this.ngControl) {
					this.setError(error);
				}
			});
		});
	}

	ngDoCheck() {
		this._errorStateTracker.updateErrorState();
	}

	setError(error: InputVariants['error']) {
		this.state().error.set(error);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/alert.stories.ts
```typescript
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideCircleAlert, lucideInfo } from '@ng-icons/lucide';
import type { Meta, StoryObj } from '@storybook/angular';
import { argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmAlertDirective, HlmAlertImports } from './helm/src';

const meta: Meta<HlmAlertDirective> = {
	title: 'Alert',
	component: HlmAlertDirective,
	tags: ['autodocs'],
	argTypes: {
		variant: {
			options: ['default', 'destructive'],
			control: {
				type: 'select',
			},
		},
	},
	decorators: [
		moduleMetadata({
			imports: [HlmAlertImports, NgIcon, HlmIconDirective],
			providers: [provideIcons({ lucideInfo, lucideCircleAlert })],
		}),
	],
	render: ({ ...args }) => ({
		props: args,
		template: `
     <div class='max-w-xl' hlmAlert ${argsToTemplate(args)}>
      <ng-icon hlm name='lucideInfo' hlmAlertIcon />
      <h4 hlmAlertTitle>Introducing SPARTAN helm & brain</h4>
      <p hlmAlertDesc>
        The components used on this page are also the intial building blocks of a new UI library. It is made up of
        headless UI providers, the brain components/directives, which add ARIA compliant markup and interactions. On top
        of the brain we add helm(et) directives, which add shadcn-like styles to
        our application.
      </p>
    </div>
    `,
	}),
};

export default meta;
type Story = StoryObj<HlmAlertDirective>;

export const Default: Story = {
	args: {
		variant: 'default',
	},
};

export const Destructive: Story = {
	args: {
		variant: 'destructive',
	},
	render: ({ ...args }) => ({
		props: args,
		template: `
     <div hlmAlert class='max-w-xl' ${argsToTemplate(args)}>
      <ng-icon hlm name='lucideCircleAlert' hlmAlertIcon />
      <h4 hlmAlertTitle>Something went wrong...</h4>
      <p hlmAlertDesc>
        Lorem ipsum dolor sit amet, consectetur adipisicing elit. Aliquam aperiam at autem culpa debitis eius eveniet exercitationem, facilis illo magni mollitia, necessitatibus nesciunt quam quos recusandae tempore ullam velit veniam!
      </p>
     </div>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/README.md
```
# ui-alert-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-alert-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-alert-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/alert/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/package.json
```json
{
	"name": "@spartan-ng/ui-alert-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/project.json
```json
{
	"name": "ui-alert-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/alert/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/alert/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/alert/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/alert/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/alert/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-alert-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmAlertDescriptionDirective } from './lib/hlm-alert-description.directive';
import { HlmAlertIconDirective } from './lib/hlm-alert-icon.directive';
import { HlmAlertTitleDirective } from './lib/hlm-alert-title.directive';
import { HlmAlertDirective } from './lib/hlm-alert.directive';

export * from './lib/hlm-alert-description.directive';
export * from './lib/hlm-alert-icon.directive';
export * from './lib/hlm-alert-title.directive';
export * from './lib/hlm-alert.directive';

export const HlmAlertImports = [
	HlmAlertDirective,
	HlmAlertTitleDirective,
	HlmAlertDescriptionDirective,
	HlmAlertIconDirective,
] as const;

@NgModule({
	imports: [...HlmAlertImports],
	exports: [...HlmAlertImports],
})
export class HlmAlertModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/src/lib/hlm-alert-description.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const alertDescriptionVariants = cva('text-sm [&_p]:leading-relaxed', {
	variants: {},
});
export type AlertDescriptionVariants = VariantProps<typeof alertDescriptionVariants>;

@Directive({
	selector: '[hlmAlertDesc],[hlmAlertDescription]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmAlertDescriptionDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm(alertDescriptionVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/src/lib/hlm-alert-icon.directive.ts
```typescript
import { Directive } from '@angular/core';
import { provideHlmIconConfig } from '@spartan-ng/ui-icon-helm';

@Directive({
	selector: '[hlmAlertIcon]',
	standalone: true,
	providers: [provideHlmIconConfig({ size: 'sm' })],
})
export class HlmAlertIconDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/src/lib/hlm-alert-title.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const alertTitleVariants = cva('mb-1 font-medium leading-none tracking-tight', {
	variants: {},
});
export type AlertTitleVariants = VariantProps<typeof alertTitleVariants>;

@Directive({
	selector: '[hlmAlertTitle]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmAlertTitleDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm(alertTitleVariants(), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/alert/helm/src/lib/hlm-alert.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const alertVariants = cva(
	'relative w-full rounded-lg border border-border p-4 [&>[hlmAlertIcon]]:absolute [&>[hlmAlertIcon]]:text-foreground [&>[hlmAlertIcon]]:left-4 [&>[hlmAlertIcon]]:top-4 [&>[hlmAlertIcon]+div]:translate-y-[-3px] [&>[hlmAlertIcon]~*]:pl-7',
	{
		variants: {
			variant: {
				default: 'bg-background text-foreground',
				destructive:
					'text-destructive border-destructive/50 dark:border-destructive [&>[hlmAlertIcon]]:text-destructive',
			},
		},
		defaultVariants: {
			variant: 'default',
		},
	},
);
export type AlertVariants = VariantProps<typeof alertVariants>;

@Directive({
	selector: '[hlmAlert]',
	standalone: true,
	host: {
		role: 'alert',
		'[class]': '_computedClass()',
	},
})
export class HlmAlertDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm(alertVariants({ variant: this.variant() }), this.userClass()));

	public readonly variant = input<AlertVariants['variant']>('default');
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/accordion/accordion.stories.ts
```typescript
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronDown } from '@ng-icons/lucide';
import { BrnAccordionDirective, BrnAccordionImports } from '@spartan-ng/brain/accordion';
import { HlmInputDirective } from '@spartan-ng/ui-input-helm';
import type { Meta, StoryObj } from '@storybook/angular';
import { moduleMetadata } from '@storybook/angular';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmAccordionImports } from './helm/src';

const meta: Meta<BrnAccordionDirective> = {
	title: 'Accordion',
	component: BrnAccordionDirective,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [BrnAccordionImports, HlmAccordionImports, NgIcon, HlmIconDirective, HlmInputDirective],
			providers: [provideIcons({ lucideChevronDown })],
		}),
	],
};

export default meta;
type Story = StoryObj<BrnAccordionDirective>;

export const Default: Story = {
	render: () => ({
		template: /* HTML */ `
			<hlm-accordion>
				<hlm-accordion-item>
					<button hlmAccordionTrigger>
						Is it accessible?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>Yes. It adheres to the WAI-ARIA design pattern.</hlm-accordion-content>
				</hlm-accordion-item>

				<hlm-accordion-item>
					<button hlmAccordionTrigger>
						Is it styled?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>
						Yes. It comes with default styles that match the other components' aesthetics.
					</hlm-accordion-content>
				</hlm-accordion-item>

				<hlm-accordion-item>
					<button hlmAccordionTrigger>
						Is it animated?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>
						Yes. It's animated by default, but you can disable it if you prefer.
					</hlm-accordion-content>
				</hlm-accordion-item>
			</hlm-accordion>
		`,
	}),
};

export const TwoAccordions: Story = {
	render: () => ({
		template: /* HTML */ `
			<hlm-accordion>
				<hlm-accordion-item>
					<button hlmAccordionTrigger>
						Is it accessible?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>Yes. It adheres to the WAI-ARIA design pattern.</hlm-accordion-content>
				</hlm-accordion-item>

				<hlm-accordion-item>
					<button hlmAccordionTrigger>
						Is it styled?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>
						Yes. It comes with default styles that match the other components' aesthetics.
					</hlm-accordion-content>
				</hlm-accordion-item>

				<hlm-accordion-item>
					<button hlmAccordionTrigger>
						Is it animated?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>
						Yes. It's animated by default, but you can disable it if you prefer.
					</hlm-accordion-content>
				</hlm-accordion-item>
			</hlm-accordion>

			<hlm-accordion>
				<hlm-accordion-item>
					<button hlmAccordionTrigger>
						Is it accessible?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>Yes. It adheres to the WAI-ARIA design pattern.</hlm-accordion-content>
				</hlm-accordion-item>

				<hlm-accordion-item>
					<button hlmAccordionTrigger>
						Is it styled?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>
						Yes. It comes with default styles that match the other components' aesthetics.
					</hlm-accordion-content>
				</hlm-accordion-item>

				<hlm-accordion-item>
					<button hlmAccordionTrigger>
						Is it styled?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>
						Yes. It comes with default styles that match the other components' aesthetics.
					</hlm-accordion-content>
				</hlm-accordion-item>

				<hlm-accordion-item>
					<button hlmAccordionTrigger>
						Is it styled?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>
						Yes. It comes with default styles that match the other components' aesthetics.
					</hlm-accordion-content>
				</hlm-accordion-item>
			</hlm-accordion>
		`,
	}),
};
export const SetOpenState: Story = {
	render: () => ({
		template: /* HTML */ `
			<hlm-accordion [type]="multiple">
				<hlm-accordion-item isOpened>
					<button hlmAccordionTrigger>
						Is it accessible?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>Yes. It adheres to the WAI-ARIA design pattern.</hlm-accordion-content>
				</hlm-accordion-item>

				<hlm-accordion-item>
					<button hlmAccordionTrigger>
						Is it styled?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>
						Yes. It comes with default styles that match the other components' aesthetics.
					</hlm-accordion-content>
				</hlm-accordion-item>

				<hlm-accordion-item isOpened>
					<button hlmAccordionTrigger>
						Is it animated?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>
						Yes. It's animated by default, but you can disable it if you prefer.
					</hlm-accordion-content>
				</hlm-accordion-item>
			</hlm-accordion>
		`,
	}),
};
export const WithTapable: Story = {
	render: () => ({
		template: /* HTML */ `
			<hlm-accordion>
				<hlm-accordion-item>
					<button hlmAccordionTrigger>
						Is the button tapable when closed?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>
						<button data-testid="not-tapable-when-closed">It should not be when closed</button>
					</hlm-accordion-content>
				</hlm-accordion-item>

				<hlm-accordion-item>
					<button hlmAccordionTrigger>
						Is the button tapable when open?
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>
						<button data-testid="tapable-when-open">It should be when open</button>
					</hlm-accordion-content>
				</hlm-accordion-item>
			</hlm-accordion>
		`,
	}),
};

export const AccordionWithInput: Story = {
	render: () => ({
		template: /* HTML */ `
			<hlm-accordion>
				<hlm-accordion-item>
					<button hlmAccordionTrigger>
						Enter your name
						<ng-icon name="lucideChevronDown" hlm hlmAccIcon />
					</button>
					<hlm-accordion-content>
						<div class="px-1">
							<input type="text" placeholder="Type your name here" hlmInput />
						</div>
					</hlm-accordion-content>
				</hlm-accordion-item>
			</hlm-accordion>
		`,
	}),
};

```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/skeleton/skeleton.stories.ts
```typescript
import type { Meta, StoryObj } from '@storybook/angular';
import { moduleMetadata } from '@storybook/angular';
import { HlmSkeletonComponent } from './helm/src';

const meta: Meta<HlmSkeletonComponent> = {
	title: 'Skeleton',
	component: HlmSkeletonComponent,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [HlmSkeletonComponent],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmSkeletonComponent>;

export const Default: Story = {
	render: () => ({
		template: `
   <div class='flex items-center p-4 m-4 border rounded-lg w-fit border-border space-x-4'>
      <hlm-skeleton class='w-12 h-12 rounded-full' />
      <div class='space-y-2'>
        <hlm-skeleton class='h-4 w-[250px]' />
        <hlm-skeleton class='h-4 w-[200px]' />
      </div>
    </div>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/skeleton/helm/README.md
```
# ui-skeleton-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-skeleton-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/skeleton/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/skeleton/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-skeleton-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/button/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/skeleton/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/skeleton/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/skeleton/helm/package.json
```json
{
	"name": "@spartan-ng/ui-skeleton-helm",
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/skeleton/helm/project.json
```json
{
	"name": "ui-skeleton-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/skeleton/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/skeleton/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/skeleton/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/skeleton/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/skeleton/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-skeleton-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/skeleton/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/skeleton/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/skeleton/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/skeleton/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/skeleton/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmSkeletonComponent } from './lib/hlm-skeleton.component';

export * from './lib/hlm-skeleton.component';

@NgModule({
	imports: [HlmSkeletonComponent],
	exports: [HlmSkeletonComponent],
})
export class HlmSkeletonModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/skeleton/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/skeleton/helm/src/lib/hlm-skeleton.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-skeleton',
	standalone: true,
	template: '',
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSkeletonComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('block animate-pulse rounded-md bg-muted', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/separator.stories.ts
```typescript
import { BrnSeparatorComponent } from '@spartan-ng/brain/separator';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmSeparatorDirective } from './helm/src';

const meta: Meta<BrnSeparatorComponent> = {
	title: 'Separator',
	component: BrnSeparatorComponent,
	tags: ['autodocs'],
	args: {
		orientation: 'horizontal',
		decorative: false,
	},
	argTypes: {
		orientation: {
			options: ['horizontal', 'vertical'],
			control: {
				type: 'select',
			},
			table: {
				defaultValue: { summary: 'horizontal' },
			},
		},
		decorative: {
			control: {
				type: 'boolean',
			},
			table: {
				defaultValue: { summary: 'false' },
			},
		},
	},
	decorators: [
		moduleMetadata({
			imports: [BrnSeparatorComponent, HlmSeparatorDirective],
		}),
	],
};

export default meta;
type Story = StoryObj<BrnSeparatorComponent>;

export const Default: Story = {
	render: ({ ...args }) => ({
		props: args,
		template: `
    <div>
      <div class='space-y-1'>
        <h4 class='text-sm font-medium leading-none'>Radix Primitives</h4>
        <p class='text-sm text-muted-foreground'>
          An open-source UI component library.
        </p>
      </div>
      <brn-separator hlmSeparator ${argsToTemplate(args)} class='my-4' />
      <div class='flex items-center h-5 text-sm space-x-4'>
        <div>Blog</div>
        <brn-separator decorative hlmSeparator orientation='vertical' />
        <div>Docs</div>
        <brn-separator decorative hlmSeparator orientation='vertical' />
        <div>Source</div>
      </div>
    </div>
       `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/README.md
```
# ui-separator-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-separator-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-separator-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/separator/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/package.json
```json
{
	"name": "@spartan-ng/ui-separator-helm",
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/project.json
```json
{
	"name": "ui-separator-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/separator/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/separator/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/separator/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/separator/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/separator/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-separator-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmSeparatorDirective } from './lib/hlm-separator.directive';

export * from './lib/hlm-separator.directive';

@NgModule({
	imports: [HlmSeparatorDirective],
	exports: [HlmSeparatorDirective],
})
export class HlmSeparatorModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/separator/helm/src/lib/hlm-separator.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export type HlmSeparatorOrientation = 'horizontal' | 'vertical';
@Directive({
	selector: '[hlmSeparator],brn-separator[hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSeparatorDirective {
	public readonly orientation = input<HlmSeparatorOrientation>('horizontal');
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'inline-flex shrink-0 border-0 bg-border',
			this.orientation() === 'horizontal' ? 'h-[1px] w-full' : 'h-full w-[1px]',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/hover-card.stories.ts
```typescript
import { Component } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideCalendarDays } from '@ng-icons/lucide';
import { type BrnHoverCardComponent, BrnHoverCardModule } from '@spartan-ng/brain/hover-card';
import { type Meta, type StoryObj, moduleMetadata } from '@storybook/angular';
import { HlmAvatarModule } from '../avatar/helm/src';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmCardDirective } from '../card/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmHoverCardModule } from './helm/src';

@Component({
	selector: 'hover-card-example',
	standalone: true,
	imports: [BrnHoverCardModule, HlmHoverCardModule, HlmButtonDirective, NgIcon, HlmIconDirective, HlmAvatarModule],
	providers: [provideIcons({ lucideCalendarDays })],
	host: {
		class: 'flex w-full h-full justify-center py-80',
	},
	template: `
		<brn-hover-card>
			<button hlmBtn variant="link" brnHoverCardTrigger>&#64;analogjs</button>
			<hlm-hover-card-content *brnHoverCardContent class="w-80">
				<div class="flex justify-between space-x-4">
					<hlm-avatar variant="small" id="avatar-small">
						<img src="https://analogjs.org/img/logos/analog-logo.svg" alt="AnalogLogo" hlmAvatarImage />
						<span class="bg-sky-600 text-sky-50" hlmAvatarFallback>AN</span>
					</hlm-avatar>
					<div class="space-y-1">
						<h4 class="text-sm font-semibold">&#64;analogjs</h4>
						<p class="text-sm">The Angular meta-framework – build Angular applications faster.</p>
						<div class="flex items-center pt-2">
							<ng-icon hlm size="sm" name="lucideCalendarDays" class="mr-2 opacity-70" />
							<span class="text-muted-foreground text-xs">Joined December 2021</span>
						</div>
					</div>
				</div>
			</hlm-hover-card-content>
		</brn-hover-card>
	`,
})
class HoverCardExampleComponent {}

const meta: Meta<BrnHoverCardComponent> = {
	title: 'Hover Card',
	component: HlmCardDirective,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [HoverCardExampleComponent],
		}),
	],
};

export default meta;
type Story = StoryObj<BrnHoverCardComponent>;

export const Default: Story = {
	render: () => ({
		template: '<hover-card-example/>',
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/README.md
```
# ui-hover-card-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-hover-card-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-hover-card-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/hover-card/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/package.json
```json
{
	"name": "@spartan-ng/ui-hovercard-helm",
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/project.json
```json
{
	"name": "ui-hover-card-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/hover-card/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/hover-card/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/hover-card/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/hover-card/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/hover-card/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-hover-card-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmHoverCardContentComponent } from './lib/hlm-hover-card-content.component';

export { HlmHoverCardContentComponent } from './lib/hlm-hover-card-content.component';

export const HlmHoverCardImports = [HlmHoverCardContentComponent] as const;

@NgModule({
	imports: [...HlmHoverCardImports],
	exports: [...HlmHoverCardImports],
})
export class HlmHoverCardModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/hover-card/helm/src/lib/hlm-hover-card-content.component.ts
```typescript
import { Component, ElementRef, Renderer2, computed, effect, inject, input, signal } from '@angular/core';
import { hlm, injectExposedSideProvider, injectExposesStateProvider } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-hover-card-content',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	template: `
		<ng-content />
	`,
})
export class HlmHoverCardContentComponent {
	private readonly _renderer = inject(Renderer2);
	private readonly _element = inject(ElementRef);

	public readonly state = injectExposesStateProvider({ host: true }).state ?? signal('closed').asReadonly();
	public readonly side = injectExposedSideProvider({ host: true }).side ?? signal('bottom').asReadonly();

	constructor() {
		effect(() => {
			this._renderer.setAttribute(this._element.nativeElement, 'data-state', this.state());
			this._renderer.setAttribute(this._element.nativeElement, 'data-side', this.side());
		});
	}

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'z-50 w-64 rounded-md border border-border bg-popover p-4 text-popover-foreground shadow-md outline-none',
			'data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/checkbox/checkbox.stories.ts
```typescript
import { NgIcon } from '@ng-icons/core';
import type { Meta, StoryObj } from '@storybook/angular';
import { moduleMetadata } from '@storybook/angular';

import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule } from '@angular/forms';
import { HlmButtonModule } from '../button/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmLabelDirective } from '../label/helm/src';
import { HlmCheckboxComponent, HlmCheckboxImports } from './helm/src';

@Component({
	selector: 'hlm-checkbox-component-tester',
	template: `
		<div class="flex items-center gap-4" [formGroup]="form">
			<label id="checkbox-label" for="testCheckboxDis1" hlmLabel>
				Test Disabled Checkbox with Reactive Forms
				<hlm-checkbox class="ml-2" id="testCheckboxDis1" aria-labelledby="testCheckbox" formControlName="checkbox" />
			</label>

			<button hlmBtn type="button" role="button" (click)="enableOrDisableCheckbox()">Enable or disable button</button>
		</div>
	`,
})
class HlmCheckboxComponentTester {
	form = inject(FormBuilder).group({
		checkbox: [false],
	});

	enableOrDisableCheckbox(): void {
		this.form.enabled ? this.form.disable() : this.form.enable();
	}
}

const meta: Meta<HlmCheckboxComponent> = {
	title: 'Checkbox',
	component: HlmCheckboxComponent,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [
				HlmCheckboxImports,
				HlmLabelDirective,
				NgIcon,
				HlmIconDirective,
				ReactiveFormsModule,
				HlmButtonModule,
				HlmCheckboxComponentTester,
			],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmCheckboxComponent>;

export const Default: Story = {
	render: () => ({
		template: /* HTML */ `
			<label id="checkbox-label" class="" hlmLabel>
				Test Checkbox
				<hlm-checkbox id="testCheckbox" aria-checked="mixed" aria-label="test checkbox" />
			</label>
		`,
	}),
};

export const InsideLabel: Story = {
	render: () => ({
		template: /* HTML */ `
			<label id="checkbox-label" class="flex items-center" hlmLabel>
				Test Checkbox
				<hlm-checkbox class="ml-2" id="testCheckbox" />
			</label>
		`,
	}),
};

export const LabeledWithAriaLabeledBy: Story = {
	render: () => ({
		template: /* HTML */ `
			<div id="checkbox-label" class="flex items-center">
				<label id="testCheckbox" for="testCheckboxAria" hlmLabel>Test Checkbox</label>
				<hlm-checkbox class="ml-2" id="testCheckboxAria" aria-labelledby="testCheckbox" />
			</div>
		`,
	}),
};

export const disabled: Story = {
	render: () => ({
		template: /* HTML */ `
			<div class="flex items-center">
				<label id="checkbox-label" for="testCheckboxDis1" hlmLabel>Test Checkbox</label>
				<hlm-checkbox disabled class="ml-2" id="testCheckboxDis1" aria-labelledby="testCheckbox" />
			</div>

			<div class="flex items-center pt-4">
				<hlm-checkbox disabled id="testCheckboxDis2" />
				<label class="ml-2" for="testCheckboxDis2" hlmLabel>Test Checkbox 2</label>
			</div>

			<div class="flex items-center pt-4">
				<hlm-checkbox id="testCheckboxDis3" />
				<label class="ml-2" for="testCheckboxDis3" hlmLabel>Test Checkbox 3 enabled</label>
			</div>
		`,
	}),
};

export const disabledWithForms: Story = {
	render: () => ({
		template: /* HTML */ `
			<hlm-checkbox-component-tester />
		`,
	}),
};

export const indeterminate: Story = {
	render: () => ({
		template: /* HTML */ `
			<div id="checkbox-label" class="flex items-center">
				<label id="testCheckbox" for="testCheckboxIndeterminate" hlmLabel>Test Checkbox</label>
				<hlm-checkbox
					checked="indeterminate"
					class="ml-2"
					id="testCheckboxIndeterminate"
					aria-labelledby="testCheckbox"
				/>
			</div>
		`,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/checkbox/helm/README.md
```
# ui-checkbox-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-checkbox-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/checkbox/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/checkbox/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-checkbox-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/ui/checkbox/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/checkbox/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/checkbox/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/checkbox/helm/package.json
```json
{
	"name": "@spartan-ng/ui-checkbox-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@angular/forms": ">=19.0.0",
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/checkbox/helm/project.json
```json
{
	"name": "ui-checkbox-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/checkbox/helm/src",
	"prefix": "hlm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/checkbox/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/checkbox/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/checkbox/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/checkbox/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-checkbox-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/checkbox/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/checkbox/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/checkbox/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/checkbox/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/checkbox/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmCheckboxComponent } from './lib/hlm-checkbox.component';

export * from './lib/hlm-checkbox.component';

export const HlmCheckboxImports = [HlmCheckboxComponent] as const;
@NgModule({
	imports: [...HlmCheckboxImports],
	exports: [...HlmCheckboxImports],
})
export class HlmCheckboxModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/checkbox/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/checkbox/helm/src/lib/hlm-checkbox.component.ts
```typescript
import { Component, booleanAttribute, computed, forwardRef, input, model, output, signal } from '@angular/core';
import { NG_VALUE_ACCESSOR } from '@angular/forms';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideCheck } from '@ng-icons/lucide';
import { BrnCheckboxComponent } from '@spartan-ng/brain/checkbox';
import { hlm } from '@spartan-ng/brain/core';
import type { ChangeFn, TouchFn } from '@spartan-ng/brain/forms';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';

export const HLM_CHECKBOX_VALUE_ACCESSOR = {
	provide: NG_VALUE_ACCESSOR,
	useExisting: forwardRef(() => HlmCheckboxComponent),
	multi: true,
};

@Component({
	selector: 'hlm-checkbox',
	imports: [BrnCheckboxComponent, NgIcon, HlmIconDirective],
	template: `
		<brn-checkbox
			[id]="id()"
			[name]="name()"
			[class]="_computedClass()"
			[checked]="checked()"
			[disabled]="state().disabled()"
			[required]="required()"
			[aria-label]="ariaLabel()"
			[aria-labelledby]="ariaLabelledby()"
			[aria-describedby]="ariaDescribedby()"
			(changed)="_handleChange()"
			(touched)="_onTouched?.()"
		>
			<ng-icon [class]="_computedIconClass()" hlm size="sm" name="lucideCheck" />
		</brn-checkbox>
	`,
	host: {
		class: 'contents',
		'[attr.id]': 'null',
		'[attr.aria-label]': 'null',
		'[attr.aria-labelledby]': 'null',
		'[attr.aria-describedby]': 'null',
	},
	providers: [HLM_CHECKBOX_VALUE_ACCESSOR],
	viewProviders: [provideIcons({ lucideCheck })],
})
export class HlmCheckboxComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm(
			'group inline-flex border border-foreground shrink-0 cursor-pointer items-center rounded-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring' +
				' focus-visible:ring-offset-2 focus-visible:ring-offset-background data-[state=checked]:text-background data-[state=checked]:bg-primary data-[state=unchecked]:bg-background',
			this.userClass(),
			this.state().disabled() ? 'cursor-not-allowed opacity-50' : '',
		),
	);

	protected readonly _computedIconClass = computed(() =>
		hlm('leading-none group-data-[state=unchecked]:opacity-0', this.checked() === 'indeterminate' ? 'opacity-50' : ''),
	);

	/** Used to set the id on the underlying brn element. */
	public readonly id = input<string | null>(null);

	/** Used to set the aria-label attribute on the underlying brn element. */
	public readonly ariaLabel = input<string | null>(null, { alias: 'aria-label' });

	/** Used to set the aria-labelledby attribute on the underlying brn element. */
	public readonly ariaLabelledby = input<string | null>(null, { alias: 'aria-labelledby' });

	/** Used to set the aria-describedby attribute on the underlying brn element. */
	public readonly ariaDescribedby = input<string | null>(null, { alias: 'aria-describedby' });

	/** The checked state of the checkbox. */
	public readonly checked = model<CheckboxValue>(false);

	/** The name attribute of the checkbox. */
	public readonly name = input<string | null>(null);

	/** Whether the checkbox is required. */
	public readonly required = input(false, { transform: booleanAttribute });

	/** Whether the checkbox is disabled. */
	public readonly disabled = input(false, { transform: booleanAttribute });

	protected readonly state = computed(() => ({
		disabled: signal(this.disabled()),
	}));

	public readonly changed = output<boolean>();

	protected _onChange?: ChangeFn<CheckboxValue>;
	protected _onTouched?: TouchFn;

	protected _handleChange(): void {
		if (this.state().disabled()) return;

		const previousChecked = this.checked();
		this.checked.set(previousChecked === 'indeterminate' ? true : !previousChecked);
		this._onChange?.(!previousChecked);
		this.changed.emit(!previousChecked);
	}

	/** CONROL VALUE ACCESSOR */
	writeValue(value: CheckboxValue): void {
		this.checked.set(!!value);
	}

	registerOnChange(fn: ChangeFn<CheckboxValue>): void {
		this._onChange = fn;
	}

	registerOnTouched(fn: TouchFn): void {
		this._onTouched = fn;
	}

	setDisabledState(isDisabled: boolean): void {
		this.state().disabled.set(isDisabled);
	}
}

type CheckboxValue = boolean | 'indeterminate';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/label/label.stories.ts
```typescript
import { FormsModule } from '@angular/forms';
import { BrnLabelDirective } from '@spartan-ng/brain/label';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmInputDirective } from '../input/helm/src';
import { HlmLabelDirective } from './helm/src';

const meta: Meta<{}> = {
	title: 'Label',
	component: HlmLabelDirective,
	tags: ['autodocs'],
	args: {
		variant: 'default',
		error: 'auto',
	},
	argTypes: {
		variant: {
			options: ['default'],
			control: {
				type: 'select',
			},
		},
		error: {
			options: ['auto', 'true'],
			control: {
				type: 'select',
			},
		},
		id: {
			control: 'text',
		},
	},
	decorators: [
		moduleMetadata({
			imports: [HlmInputDirective, HlmLabelDirective, BrnLabelDirective, FormsModule],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmLabelDirective>;

export const Default: Story = {
	render: ({ ...args }) => ({
		props: args,
		template: `
    <label hlmLabel ${argsToTemplate(args)}>E-Mail
        <input class='w-80' hlmInput  type='email' placeholder='Email'/>
    </label>
    `,
	}),
};

export const InputRequired: Story = {
	render: ({ ...args }) => ({
		props: { ...args, value: '' },
		template: `
    <label hlmLabel ${argsToTemplate(args)}>E-Mail *
        <input [(ngModel)]="value" class='w-80' hlmInput  type='email' placeholder='Email *' required/>
    </label>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/label/helm/README.md
```
# ui-label-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-label-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/label/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/label/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-label-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/button/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/label/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/label/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/label/helm/package.json
```json
{
	"name": "@spartan-ng/ui-label-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/label/helm/project.json
```json
{
	"name": "ui-label-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/label/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/label/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/label/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/label/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/label/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-label-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/label/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/label/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/label/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/label/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/label/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmLabelDirective } from './lib/hlm-label.directive';

export * from './lib/hlm-label.directive';

@NgModule({
	imports: [HlmLabelDirective],
	exports: [HlmLabelDirective],
})
export class HlmLabelModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/label/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/label/helm/src/lib/hlm-label.directive.ts
```typescript
import { Directive, computed, inject, input, signal } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnLabelDirective } from '@spartan-ng/brain/label';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const labelVariants = cva(
	'text-sm font-medium leading-none [&>[hlmInput]]:my-1 [&:has([hlmInput]:disabled)]:cursor-not-allowed [&:has([hlmInput]:disabled)]:opacity-70',
	{
		variants: {
			variant: {
				default: '',
			},
			error: {
				auto: '[&:has([hlmInput].ng-invalid.ng-touched)]:text-destructive',
				true: 'text-destructive',
			},
			disabled: {
				auto: '[&:has([hlmInput]:disabled)]:opacity-70',
				true: 'opacity-70',
				false: '',
			},
		},
		defaultVariants: {
			variant: 'default',
			error: 'auto',
		},
	},
);
export type LabelVariants = VariantProps<typeof labelVariants>;

@Directive({
	selector: '[hlmLabel]',
	standalone: true,
	hostDirectives: [
		{
			directive: BrnLabelDirective,
			inputs: ['id'],
		},
	],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmLabelDirective {
	private readonly _brn = inject(BrnLabelDirective, { host: true });

	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	public readonly variant = input<LabelVariants['variant']>('default');

	public readonly error = input<LabelVariants['error']>('auto');

	protected readonly state = computed(() => ({
		error: signal(this.error()),
	}));

	protected readonly _computedClass = computed(() =>
		hlm(
			labelVariants({
				variant: this.variant(),
				error: this.state().error(),
				disabled: this._brn?.dataDisabled() ?? 'auto',
			}),
			'[&.ng-invalid.ng-touched]:text-destructive',
			this.userClass(),
		),
	);

	setError(error: LabelVariants['error']): void {
		this.state().error.set(error);
	}
}

```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/spinner/spinner.stories.ts
```typescript
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmSpinnerComponent } from './helm/src';

const meta: Meta<HlmSpinnerComponent> = {
	title: 'Spinner',
	component: HlmSpinnerComponent,
	tags: ['autodocs'],
	argTypes: {
		size: {
			options: ['default', 'xs', 'sm'],
			control: {
				type: 'select',
			},
		},
	},
	decorators: [
		moduleMetadata({
			imports: [HlmSpinnerComponent],
		}),
	],
	render: ({ ...args }) => ({
		props: args,
		template: `
    <hlm-spinner ${argsToTemplate(args)}></hlm-spinner>
    `,
	}),
};

export default meta;
type Story = StoryObj<HlmSpinnerComponent>;

export const Default: Story = {};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/spinner/helm/README.md
```
# ui-spinner-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-spinner-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/spinner/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/spinner/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-spinner-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/button/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/spinner/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/spinner/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/spinner/helm/package.json
```json
{
	"name": "@spartan-ng/ui-spinner-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/spinner/helm/project.json
```json
{
	"name": "ui-spinner-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/spinner/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/spinner/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/spinner/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/spinner/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/spinner/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/spinner/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/spinner/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/spinner/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/spinner/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/spinner/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmSpinnerComponent } from './lib/hlm-spinner.component';

export * from './lib/hlm-spinner.component';

@NgModule({
	imports: [HlmSpinnerComponent],
	exports: [HlmSpinnerComponent],
})
export class HlmSpinnerModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/spinner/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/spinner/helm/src/lib/hlm-spinner.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const spinnerVariants = cva('inline-block', {
	variants: {
		variant: {
			default: 'animate-spin [&>svg]:text-foreground/30 [&>svg]:fill-accent',
		},
		size: {
			xs: 'h-4 w-4',
			sm: 'h-6 w-6',
			default: 'w-8 h-8 ',
			lg: 'w-12 h-12',
			xl: 'w-16 h-16',
		},
	},
	defaultVariants: {
		variant: 'default',
		size: 'default',
	},
});
export type SpinnerVariants = VariantProps<typeof spinnerVariants>;

@Component({
	selector: 'hlm-spinner',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		role: 'status',
	},
	template: `
		<svg aria-hidden="true" class="animate-spin" viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg">
			<path
				d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
				fill="currentColor"
			/>
			<path
				d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
				fill="currentFill"
			/>
		</svg>
		<span class="sr-only"><ng-content /></span>
	`,
})
export class HlmSpinnerComponent {
	public readonly size = input<SpinnerVariants['size']>('default');
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(spinnerVariants({ size: this.size() }), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/carousel.stories.ts
```typescript
import { argsToTemplate, Meta, moduleMetadata, StoryObj } from '@storybook/angular';

import Autoplay from 'embla-carousel-autoplay';
import { HlmCardContentDirective, HlmCardDirective } from '../card/helm/src';
import { HlmCarouselComponent, HlmCarouselImports } from './helm/src';

const meta: Meta<HlmCarouselComponent> = {
	title: 'Carousel',
	component: HlmCarouselComponent,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [HlmCarouselImports, HlmCardDirective, HlmCardContentDirective],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmCarouselComponent>;

export const Default: Story = {
	render: () => ({
		template: `
    <div class="flex items-center justify-center w-full p-4">
      <hlm-carousel class="w-full max-w-xs">
        <hlm-carousel-content>
        ${Array.from(
					{ length: 5 },
					(_, i) => `
        <hlm-carousel-item>
          <div class="p-1">
            <section hlmCard>
              <p hlmCardContent class="flex items-center justify-center p-6 aspect-square">
                <span class="text-4xl font-semibold">${i + 1}</span>
              </p>
            </section>
          </div>
        </hlm-carousel-item>
        `,
				).join('\n')}
        </hlm-carousel-content>
        <button hlm-carousel-previous></button>
        <button hlm-carousel-next></button>
      </hlm-carousel>
    </div>
    `,
	}),
};

export const Sizes: Story = {
	render: () => ({
		template: `
    <div class="flex items-center justify-center w-full p-4">
      <hlm-carousel class="w-full max-w-xs">
        <hlm-carousel-content>
					${Array.from(
						{ length: 5 },
						(_, i) => `
					<hlm-carousel-item class="md:basis-1/2 lg:basis-1/3">
						<div class="p-1">
							<section hlmCard>
								<p hlmCardContent class="flex items-center justify-center p-6 aspect-square">
									<span class="text-4xl font-semibold">${i + 1}</span>
								</p>
							</section>
						</div>
					</hlm-carousel-item>
					`,
					).join('\n')}
        </hlm-carousel-content>
        <button hlm-carousel-previous></button>
        <button hlm-carousel-next></button>
      </hlm-carousel>
    </div>
    `,
	}),
};

export const Spacing: Story = {
	render: () => ({
		template: `
    <div class="flex items-center justify-center w-full p-4">
      <hlm-carousel class="w-full max-w-xs">
        <hlm-carousel-content class="-ml-1">
					${Array.from(
						{ length: 5 },
						(_, i) => `
					<hlm-carousel-item class="pl-1 md:basis-1/2 lg:basis-1/3">
						<div class="p-1">
							<section hlmCard>
								<p hlmCardContent class="flex items-center justify-center p-6 aspect-square">
									<span class="text-4xl font-semibold">${i + 1}</span>
								</p>
							</section>
						</div>
					</hlm-carousel-item>
					`,
					).join('\n')}
        </hlm-carousel-content>
        <button hlm-carousel-previous></button>
        <button hlm-carousel-next></button>
      </hlm-carousel>
    </div>
    `,
	}),
};

export const Orientation: Story = {
	render: () => ({
		template: `
    <div class="flex items-center justify-center w-full p-4">
      <hlm-carousel class="w-full max-w-xs" orientation="vertical">
        <hlm-carousel-content class="-mt-1 h-[200px]">
					${Array.from(
						{ length: 5 },
						(_, i) => `
					<hlm-carousel-item class="pt-1 md:basis-1/2">
						<div class="p-1">
							<section hlmCard>
								<p hlmCardContent class="flex items-center justify-center p-6">
									<span class="text-4xl font-semibold">${i + 1}</span>
								</p>
							</section>
						</div>
					</hlm-carousel-item>
					`,
					).join('\n')}
        </hlm-carousel-content>
        <button hlm-carousel-previous></button>
        <button hlm-carousel-next></button>
      </hlm-carousel>
    </div>
    `,
	}),
};

export const Plugins: Story = {
	args: {
		plugins: [Autoplay({ delay: 3000 })],
	},
	render: ({ ...args }) => ({
		props: args,
		template: `
    <div class="flex items-center justify-center w-full p-4">
      <hlm-carousel class="w-full max-w-xs" ${argsToTemplate(args)}>
        <hlm-carousel-content>
        ${Array.from(
					{ length: 5 },
					(_, i) => `
        <hlm-carousel-item>
          <div class="p-1">
            <section hlmCard>
              <p hlmCardContent class="flex items-center justify-center p-6 aspect-square">
                <span class="text-4xl font-semibold">${i + 1}</span>
              </p>
            </section>
          </div>
        </hlm-carousel-item>
        `,
				).join('\n')}
        </hlm-carousel-content>
        <button hlm-carousel-previous></button>
        <button hlm-carousel-next></button>
      </hlm-carousel>
    </div>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/README.md
```
# ui-carousel-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-carousel-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/eslint.config.js
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
					type: ['attribute', 'element'],
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-carousel-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/ui/carousel/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/carousel/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/package.json
```json
{
	"name": "@spartan-ng/ui-carousel-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@ng-icons/core": ">=29.0.0",
		"@ng-icons/lucide": ">=29.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"@spartan-ng/ui-button-helm": "0.0.1-alpha.381",
		"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
		"clsx": "^2.1.1",
		"embla-carousel-angular": "19.0.0"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/project.json
```json
{
	"name": "ui-carousel-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/carousel/helm/src",
	"prefix": "hlm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/carousel/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/carousel/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/carousel/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/carousel/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-carousel-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmCarouselContentComponent } from './lib/hlm-carousel-content.component';
import { HlmCarouselItemComponent } from './lib/hlm-carousel-item.component';
import { HlmCarouselNextComponent } from './lib/hlm-carousel-next.component';
import { HlmCarouselPreviousComponent } from './lib/hlm-carousel-previous.component';
import { HlmCarouselComponent } from './lib/hlm-carousel.component';

export * from './lib/hlm-carousel-content.component';
export * from './lib/hlm-carousel-item.component';
export * from './lib/hlm-carousel-next.component';
export * from './lib/hlm-carousel-previous.component';
export * from './lib/hlm-carousel.component';

export const HlmCarouselImports = [
	HlmCarouselComponent,
	HlmCarouselContentComponent,
	HlmCarouselItemComponent,
	HlmCarouselPreviousComponent,
	HlmCarouselNextComponent,
] as const;

@NgModule({
	imports: [...HlmCarouselImports],
	exports: [...HlmCarouselImports],
})
export class HlmCarouselModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/src/lib/hlm-carousel-content.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, inject, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';
import { HlmCarouselComponent } from './hlm-carousel.component';

@Component({
	selector: 'hlm-carousel-content',
	standalone: true,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	host: {
		'[class]': '_computedClass()',
	},
	template: `
		<ng-content />
	`,
})
export class HlmCarouselContentComponent {
	private readonly _orientation = inject(HlmCarouselComponent).orientation;

	public _userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm('flex', this._orientation() === 'horizontal' ? '-ml-4' : '-mt-4 flex-col', this._userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/src/lib/hlm-carousel-item.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, inject, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';
import { HlmCarouselComponent } from './hlm-carousel.component';

@Component({
	selector: 'hlm-carousel-item',
	standalone: true,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	host: {
		'[class]': '_computedClass()',
		role: 'group',
		'aria-roledescription': 'slide',
	},
	template: `
		<ng-content />
	`,
})
export class HlmCarouselItemComponent {
	public _userClass = input<ClassValue>('', { alias: 'class' });
	private readonly _orientation = inject(HlmCarouselComponent).orientation;
	protected _computedClass = computed(() =>
		hlm(
			'min-w-0 shrink-0 grow-0 basis-full',
			this._orientation() === 'horizontal' ? 'pl-4' : 'pt-4',
			this._userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/src/lib/hlm-carousel-next.component.ts
```typescript
import {
	ChangeDetectionStrategy,
	Component,
	ViewEncapsulation,
	computed,
	effect,
	inject,
	input,
	untracked,
} from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideArrowRight } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { HlmButtonDirective, provideBrnButtonConfig } from '@spartan-ng/ui-button-helm';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';
import { HlmCarouselComponent } from './hlm-carousel.component';

@Component({
	selector: 'button[hlm-carousel-next], button[hlmCarouselNext]',
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	host: {
		'[disabled]': 'isDisabled()',
		'(click)': '_carousel.scrollNext()',
	},
	hostDirectives: [{ directive: HlmButtonDirective, inputs: ['variant', 'size'] }],
	providers: [provideIcons({ lucideArrowRight }), provideBrnButtonConfig({ variant: 'outline', size: 'icon' })],
	imports: [NgIcon, HlmIconDirective],
	template: `
		<ng-icon hlm size="sm" name="lucideArrowRight" />
		<span class="sr-only">Next slide</span>
	`,
})
export class HlmCarouselNextComponent {
	private readonly _button = inject(HlmButtonDirective);
	private readonly _carousel = inject(HlmCarouselComponent);
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	private readonly _computedClass = computed(() =>
		hlm(
			'absolute h-8 w-8 rounded-full',
			this._carousel.orientation() === 'horizontal'
				? '-right-12 top-1/2 -translate-y-1/2'
				: '-bottom-12 left-1/2 -translate-x-1/2 rotate-90',
			this.userClass(),
		),
	);
	protected readonly isDisabled = () => !this._carousel.canScrollNext();

	constructor() {
		effect(() => {
			const computedClass = this._computedClass();

			untracked(() => this._button.setClass(computedClass));
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/src/lib/hlm-carousel-previous.component.ts
```typescript
import {
	ChangeDetectionStrategy,
	Component,
	ViewEncapsulation,
	computed,
	effect,
	inject,
	input,
	untracked,
} from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideArrowLeft } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { HlmButtonDirective, provideBrnButtonConfig } from '@spartan-ng/ui-button-helm';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';
import { HlmCarouselComponent } from './hlm-carousel.component';

@Component({
	selector: 'button[hlm-carousel-previous], button[hlmCarouselPrevious]',
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	host: {
		'[disabled]': 'isDisabled()',
		'(click)': '_carousel.scrollPrev()',
	},
	hostDirectives: [{ directive: HlmButtonDirective, inputs: ['variant', 'size'] }],
	providers: [provideIcons({ lucideArrowLeft }), provideBrnButtonConfig({ variant: 'outline', size: 'icon' })],
	imports: [NgIcon, HlmIconDirective],
	template: `
		<ng-icon hlm size="sm" name="lucideArrowLeft" />
		<span class="sr-only">Previous slide</span>
	`,
})
export class HlmCarouselPreviousComponent {
	private readonly _button = inject(HlmButtonDirective);

	protected readonly _carousel = inject(HlmCarouselComponent);

	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	private readonly _computedClass = computed(() =>
		hlm(
			'absolute h-8 w-8 rounded-full',
			this._carousel.orientation() === 'horizontal'
				? '-left-12 top-1/2 -translate-y-1/2'
				: '-top-12 left-1/2 -translate-x-1/2 rotate-90',
			this.userClass(),
		),
	);
	protected readonly isDisabled = () => !this._carousel.canScrollPrev();

	constructor() {
		effect(() => {
			const computedClass = this._computedClass();

			untracked(() => this._button.setClass(computedClass));
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/src/lib/hlm-carousel.component.ts
```typescript
import {
	ChangeDetectionStrategy,
	Component,
	HostListener,
	type InputSignal,
	type Signal,
	ViewChild,
	ViewEncapsulation,
	computed,
	input,
	signal,
} from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';
import {
	EmblaCarouselDirective,
	type EmblaEventType,
	type EmblaOptionsType,
	type EmblaPluginType,
} from 'embla-carousel-angular';

@Component({
	selector: 'hlm-carousel',
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	host: {
		'[class]': '_computedClass()',
		role: 'region',
		'aria-roledescription': 'carousel',
	},
	imports: [EmblaCarouselDirective],
	template: `
		<div
			emblaCarousel
			class="overflow-hidden"
			[plugins]="plugins()"
			[options]="emblaOptions()"
			[subscribeToEvents]="['init', 'select', 'reInit']"
			(emblaChange)="onEmblaEvent($event)"
		>
			<ng-content select="hlm-carousel-content" />
		</div>
		<ng-content />
	`,
})
export class HlmCarouselComponent {
	@ViewChild(EmblaCarouselDirective) protected emblaCarousel?: EmblaCarouselDirective;

	public _userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('relative', this._userClass()));

	public orientation = input<'horizontal' | 'vertical'>('horizontal');
	public options: InputSignal<Omit<EmblaOptionsType, 'axis'> | undefined> = input();
	public plugins: InputSignal<EmblaPluginType[]> = input([] as EmblaPluginType[]);

	protected emblaOptions: Signal<EmblaOptionsType> = computed(() => ({
		...this.options(),
		axis: this.orientation() === 'horizontal' ? 'x' : 'y',
	}));

	private readonly _canScrollPrev = signal(false);
	public canScrollPrev = this._canScrollPrev.asReadonly();
	private readonly _canScrollNext = signal(false);
	public canScrollNext = this._canScrollNext.asReadonly();

	protected onEmblaEvent(event: EmblaEventType) {
		const emblaApi = this.emblaCarousel?.emblaApi;

		if (!emblaApi) {
			return;
		}

		if (event === 'select' || event === 'init' || event === 'reInit') {
			this._canScrollPrev.set(emblaApi.canScrollPrev());
			this._canScrollNext.set(emblaApi.canScrollNext());
		}
	}

	@HostListener('keydown', ['$event'])
	protected onKeydown(event: KeyboardEvent) {
		if (event.key === 'ArrowLeft') {
			event.preventDefault();
			this.emblaCarousel?.scrollPrev();
		} else if (event.key === 'ArrowRight') {
			event.preventDefault();
			this.emblaCarousel?.scrollNext();
		}
	}

	scrollPrev() {
		this.emblaCarousel?.scrollPrev();
	}

	scrollNext() {
		this.emblaCarousel?.scrollNext();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/combobox/combobox.stories.ts
```typescript
import { Component, signal } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import * as lucide from '@ng-icons/lucide';
import { BrnCommandImports } from '@spartan-ng/brain/command';
import { BrnPopoverImports } from '@spartan-ng/brain/popover';
import type { Meta, StoryObj } from '@storybook/angular';
import { moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmCommandImports } from '../command/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmPopoverContentDirective } from '../popover/helm/src';

const meta: Meta<{}> = {
	title: 'Combobox',
	decorators: [
		moduleMetadata({
			providers: [provideIcons(lucide)],
			imports: [BrnCommandImports, HlmCommandImports, NgIcon, HlmIconDirective, HlmButtonDirective],
		}),
	],
};

export default meta;
type Story = StoryObj<{}>;
type Framework = { label: string; value: string };

@Component({
	selector: 'combobox-component',
	standalone: true,
	imports: [
		BrnCommandImports,
		HlmCommandImports,
		BrnPopoverImports,
		HlmPopoverContentDirective,
		NgIcon,
		HlmIconDirective,
		HlmButtonDirective,
	],
	template: `
		<brn-popover [state]="state()" (stateChanged)="stateChanged($event)" sideOffset="5">
			<button
				class="w-[200px] justify-between"
				id="edit-profile"
				variant="outline"
				brnPopoverTrigger
				(click)="state.set('open')"
				hlmBtn
			>
				{{ currentFramework() ? currentFramework().label : 'Select framework...' }}
				<ng-icon hlm size="sm" name="lucideChevronsUpDown" />
			</button>
			<hlm-command *brnPopoverContent="let ctx" hlmPopoverContent class="w-[200px] p-0">
				<hlm-command-search>
					<ng-icon hlm name="lucideSearch" />
					<input placeholder="Search framework..." hlm-command-search-input />
				</hlm-command-search>
				<div *brnCommandEmpty hlmCommandEmpty>No results found.</div>
				<hlm-command-list>
					<hlm-command-group>
						@for (framework of frameworks; track framework) {
							<button hlm-command-item [value]="framework.value" (selected)="commandSelected(framework)">
								<ng-icon
									hlm
									[class.opacity-0]="currentFramework()?.value !== framework.value"
									name="lucideCheck"
									hlmCommandIcon
								/>
								{{ framework.label }}
							</button>
						}
					</hlm-command-group>
				</hlm-command-list>
			</hlm-command>
		</brn-popover>
	`,
})
class ComboboxComponent {
	public frameworks = [
		{
			label: 'AnalogJs',
			value: 'analogjs',
		},
		{
			label: 'Angular',
			value: 'angular',
		},
		{
			label: 'Vue',
			value: 'vue',
		},
		{
			label: 'Nuxt',
			value: 'nuxt',
		},
		{
			label: 'React',
			value: 'react',
		},
		{
			label: 'NextJs',
			value: 'nextjs',
		},
	];
	public currentFramework = signal<Framework | undefined>(undefined);
	public state = signal<'closed' | 'open'>('closed');

	stateChanged(state: 'open' | 'closed') {
		this.state.set(state);
	}

	commandSelected(framework: Framework) {
		this.state.set('closed');
		if (this.currentFramework()?.value === framework.value) {
			this.currentFramework.set(undefined);
		} else {
			this.currentFramework.set(framework);
		}
	}
}

export const Default: Story = {
	decorators: [
		moduleMetadata({
			imports: [ComboboxComponent],
		}),
	],
	render: () => ({
		template: '<combobox-component/>',
	}),
};

```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/toggle.stories.ts
```typescript
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideItalic } from '@ng-icons/lucide';
import { BrnToggleDirective } from '@spartan-ng/brain/toggle';
import { type Meta, type StoryObj, moduleMetadata } from '@storybook/angular';

import { HlmIconDirective } from '../icon/helm/src';
import { HlmToggleDirective } from './helm/src';

const meta: Meta<HlmToggleDirective> = {
	title: 'Toggle',
	component: HlmToggleDirective,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [HlmToggleDirective, BrnToggleDirective, NgIcon, HlmIconDirective],
			providers: [provideIcons({ lucideItalic })],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmToggleDirective>;

export const Default: Story = {
	render: () => ({
		template: `
    <div class='space-x-3'>
    <button aria-label='Italic Toggle' size='sm' hlmToggle><ng-icon hlm name='lucideItalic'/></button>
    <button aria-label='Italic Toggle' hlmToggle><ng-icon hlm name='lucideItalic'/></button>
    <button aria-label='Italic Toggle' size='lg' hlmToggle><ng-icon hlm name='lucideItalic'/></button>
    <button aria-label='Italic Toggle' variant='outline' hlmToggle><ng-icon hlm name='lucideItalic'/></button>
    <button aria-label='Italic Toggle' disabled hlmToggle><ng-icon hlm name='lucideItalic'/></button>
    </div>
    `,
	}),
};

export const WithText: Story = {
	name: 'With Text',
	render: () => ({
		template: `
    <div class='space-x-3'>
    <button size='sm' hlmToggle><ng-icon hlm name='lucideItalic'/> <span class='ml-2'>Italic</span></button>
    <button hlmToggle><ng-icon hlm name='lucideItalic'/> <span class='ml-2'>Italic</span></button>
    <button size='lg' hlmToggle><ng-icon hlm name='lucideItalic'/> <span class='ml-2'>Italic</span></button>
    <button variant='outline' hlmToggle><ng-icon hlm name='lucideItalic'/> <span class='ml-2'>Italic</span></button>
    <button disabled hlmToggle><ng-icon hlm name='lucideItalic'/> <span class='ml-2'>Italic</span></button>
    </div>
`,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/README.md
```
# ui-toggle-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-toggle-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-toggle-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/toggle/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/package.json
```json
{
	"name": "@spartan-ng/ui-toggle-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/project.json
```json
{
	"name": "ui-toggle-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/toggle/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/toggle/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/toggle/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/toggle/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/toggle/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-toggle-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmToggleDirective } from './lib/hlm-toggle.directive';

export * from './lib/hlm-toggle.directive';
@NgModule({
	imports: [HlmToggleDirective],
	exports: [HlmToggleDirective],
})
export class HlmToggleModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/toggle/helm/src/lib/hlm-toggle.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { cva, type VariantProps } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const toggleVariants = cva(
	'inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors hover:bg-muted hover:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=on]:bg-accent data-[state=on]:text-accent-foreground',
	{
		variants: {
			variant: {
				default: 'bg-transparent',
				outline: 'border border-input bg-transparent hover:bg-accent hover:text-accent-foreground',
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
export type ToggleVariants = VariantProps<typeof toggleVariants>;

@Directive({
	selector: '[hlmToggle],[brnToggle][hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmToggleDirective {
	public readonly variant = input<ToggleVariants['variant']>('default');
	public readonly size = input<ToggleVariants['size']>('default');
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() => {
		const variantToUse = this.variant();
		const sizeToUse = this.size();
		const userClass = this.userClass();

		return hlm(
			toggleVariants({
				variant: variantToUse,
				size: sizeToUse,
			}),
			userClass,
		);
	});
}

```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/form-field.stories.ts
```typescript
import { Component, type OnInit, inject } from '@angular/core';
import { FormBuilder, FormControl, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';
import { ErrorStateMatcher, ShowOnDirtyErrorStateMatcher } from '@spartan-ng/brain/forms';
import { BrnSelectImports } from '@spartan-ng/brain/select';
import { type Meta, type StoryObj, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective, HlmButtonModule } from '../button/helm/src';
import { HlmInputDirective } from '../input/helm/src';
import { HlmSelectImports, HlmSelectModule } from '../select/helm/src';
import { HlmFormFieldComponent, HlmFormFieldModule } from './helm/src';

const meta: Meta<HlmFormFieldComponent> = {
	title: 'Form Field',
	component: HlmFormFieldComponent,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [HlmFormFieldModule, HlmInputDirective, FormsModule, ReactiveFormsModule, HlmButtonDirective],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmFormFieldComponent>;

export const Default: Story = {
	render: ({ ...args }) => ({
		props: { name: new FormControl('', Validators.required), ...args },
		template: `
			<hlm-form-field>
			 	<input aria-label='Your Name' [formControl]="name" class='w-80' hlmInput type='text' placeholder='Your Name'/>
				<hlm-error>Your name is required</hlm-error>
			</hlm-form-field>
		`,
	}),
};

@Component({
	standalone: true,
	selector: 'form-field-error-story',
	imports: [ReactiveFormsModule, HlmFormFieldModule, HlmInputDirective],
	template: `
		<hlm-form-field>
			<input aria-label="Your Name" class="w-80" [formControl]="name" hlmInput type="text" placeholder="Your Name" />
			<hlm-error>Your name is required</hlm-error>
		</hlm-form-field>
	`,
})
class FormFieldErrorStory implements OnInit {
	name = new FormControl('', Validators.required);

	ngOnInit(): void {
		this.name.markAsTouched();
	}
}

export const Error: Story = {
	decorators: [
		moduleMetadata({
			imports: [FormFieldErrorStory],
		}),
	],
	render: () => ({
		template: '<form-field-error-story />',
	}),
};

export const Hint: Story = {
	render: ({ ...args }) => ({
		props: {
			...args,
		},
		template: `
		<hlm-form-field>
			<input aria-label='Your Name' class='w-80' hlmInput type='text' placeholder='shadcn'/>
			<hlm-hint>This is your public display name.</hlm-hint>
		</hlm-form-field>
		`,
	}),
};

@Component({
	standalone: true,
	selector: 'form-field-form-story',
	imports: [
		ReactiveFormsModule,
		HlmFormFieldModule,
		HlmSelectModule,
		HlmInputDirective,
		HlmSelectImports,
		BrnSelectImports,
		HlmButtonModule,
	],
	template: `
		<form [formGroup]="form" class="space-y-6">
			<hlm-form-field>
				<input
					aria-label="Your Name"
					formControlName="name"
					class="w-80"
					hlmInput
					type="text"
					placeholder="Your Name"
				/>
				<hlm-error>Your name is required</hlm-error>
			</hlm-form-field>
			<hlm-form-field>
				<brn-select class="inline-block" placeholder="Select some fruit" formControlName="fruit">
					<hlm-select-trigger class="w-80">
						<hlm-select-value />
					</hlm-select-trigger>
					<hlm-select-content>
						<hlm-select-label>Fruits</hlm-select-label>
						@for (option of options; track option.value) {
							<hlm-option [value]="option.value">{{ option.label }}</hlm-option>
						}
					</hlm-select-content>
				</brn-select>
				<hlm-error>The fruit is required</hlm-error>
			</hlm-form-field>

			<button type="submit" hlmBtn>Submit</button>
		</form>
	`,
})
class FormFieldFormStory {
	private _formBuilder = inject(FormBuilder);

	form = this._formBuilder.group({
		name: ['', Validators.required],
		fruit: ['', Validators.required],
	});

	options = [
		{ value: 'apple', label: 'Apple' },
		{ value: 'banana', label: 'Banana' },
		{ value: 'blueberry', label: 'Blueberry' },
		{ value: 'grapes', label: 'Grapes' },
		{ value: 'pineapple', label: 'Pineapple' },
	];
}

export const FormWithDefaultErrorStateMatcher: Story = {
	decorators: [
		moduleMetadata({
			imports: [FormFieldFormStory],
		}),
	],
	render: () => ({
		template: '<form-field-form-story />',
	}),
};

export const FormWithDirtyErrorStateMatcher: Story = {
	decorators: [
		moduleMetadata({
			imports: [FormFieldFormStory],
			providers: [{ provide: ErrorStateMatcher, useClass: ShowOnDirtyErrorStateMatcher }],
		}),
	],
	render: () => ({
		template: '<form-field-form-story />',
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/README.md
```
# ui-form-field-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-form-field-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/eslint.config.js
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
		},
	},
	{
		files: ['**/*.html'],
		// Override or add rules here
		rules: {},
	},
];

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-form-field-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/form-field/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/form-field/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/package.json
```json
{
	"name": "@spartan-ng/ui-formfield-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/project.json
```json
{
	"name": "ui-form-field-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/form-field/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/form-field/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/form-field/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/form-field/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/form-field/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-form-field-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmErrorDirective } from './lib/hlm-error.directive';
import { HlmFormFieldComponent } from './lib/hlm-form-field.component';
import { HlmHintDirective } from './lib/hlm-hint.directive';

export * from './lib/hlm-error.directive';
export * from './lib/hlm-form-field.component';
export * from './lib/hlm-hint.directive';

@NgModule({
	imports: [HlmFormFieldComponent, HlmErrorDirective, HlmHintDirective],
	exports: [HlmFormFieldComponent, HlmErrorDirective, HlmHintDirective],
})
export class HlmFormFieldModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/src/lib/form-field.spec.ts
```typescript
/* eslint-disable @angular-eslint/component-class-suffix */
/* eslint-disable @angular-eslint/component-selector */
import { Component } from '@angular/core';
import { FormControl, ReactiveFormsModule, Validators } from '@angular/forms';
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';

import { HlmInputDirective } from '@spartan-ng/ui-input-helm';

import { ErrorStateMatcher, ShowOnDirtyErrorStateMatcher } from '@spartan-ng/brain/forms';
import { HlmErrorDirective } from './hlm-error.directive';
import { HlmFormFieldComponent } from './hlm-form-field.component';
import { HlmHintDirective } from './hlm-hint.directive';

const DIRECTIVES = [HlmFormFieldComponent, HlmErrorDirective, HlmHintDirective, HlmInputDirective];

@Component({
	standalone: true,
	selector: 'single-form-field-example',
	imports: [ReactiveFormsModule, ...DIRECTIVES],
	template: `
		<hlm-form-field>
			<input
				data-testid="hlm-input"
				aria-label="Your Name"
				[formControl]="name"
				class="w-80"
				hlmInput
				type="text"
				placeholder="Your Name"
			/>
			<hlm-error data-testid="hlm-error">Your name is required</hlm-error>
			<hlm-hint data-testid="hlm-hint">This is your public display name.</hlm-hint>
		</hlm-form-field>
	`,
})
class SingleFormFieldMock {
	public name = new FormControl('', Validators.required);
}

@Component({
	standalone: true,
	selector: 'single-form-field-dirty-example',
	imports: [ReactiveFormsModule, ...DIRECTIVES],
	template: `
		<hlm-form-field>
			<input
				data-testid="hlm-input"
				aria-label="Your Name"
				[formControl]="name"
				class="w-80"
				hlmInput
				type="text"
				placeholder="Your Name"
			/>
			<hlm-error data-testid="hlm-error">Your name is required</hlm-error>
			<hlm-hint data-testid="hlm-hint">This is your public display name.</hlm-hint>
		</hlm-form-field>
	`,
	providers: [{ provide: ErrorStateMatcher, useClass: ShowOnDirtyErrorStateMatcher }],
})
class SingleFormFieldDirtyMock {
	public name = new FormControl('', Validators.required);
}

describe('Hlm Form Field Component', () => {
	const TEXT_HINT = 'This is your public display name.';
	const TEXT_ERROR = 'Your name is required';

	const setupFormField = async () => {
		const { fixture } = await render(SingleFormFieldMock);
		return {
			user: userEvent.setup(),
			fixture,
			hint: screen.getByTestId('hlm-hint'),
			error: () => screen.queryByTestId('hlm-error'),
			trigger: screen.getByTestId('hlm-input'),
		};
	};

	const setupFormFieldWithErrorStateDirty = async () => {
		const { fixture } = await render(SingleFormFieldDirtyMock);
		return {
			user: userEvent.setup(),
			fixture,
			hint: screen.getByTestId('hlm-hint'),
			error: () => screen.queryByTestId('hlm-error'),
			trigger: screen.getByTestId('hlm-input'),
		};
	};

	describe('SingleFormField', () => {
		it('should show the hint if the errorState is false', async () => {
			const { hint } = await setupFormField();

			expect(hint.textContent).toBe(TEXT_HINT);
		});

		it('should show the error if the errorState is true', async () => {
			const { user, error, trigger } = await setupFormField();

			expect(error()).toBeNull();

			await user.click(trigger);

			await user.click(document.body);

			expect(screen.queryByTestId('hlm-hint')).toBeNull();
			expect(error()?.textContent?.trim()).toBe(TEXT_ERROR);
		});
	});

	describe('SingleFormFieldDirty', () => {
		it('should not display the error if the input does not have the dirty state due to the ErrorStateMatcher', async () => {
			const { error, user, trigger } = await setupFormFieldWithErrorStateDirty();

			await user.click(trigger);

			await user.click(document.body);

			expect(error()).toBeNull();
		});

		it('should display the error if the input has the dirty state due to the ErrorStateMatcher', async () => {
			const { error, user, trigger } = await setupFormFieldWithErrorStateDirty();

			await user.click(trigger);
			await user.type(trigger, 'a');
			await user.clear(trigger);

			await user.click(document.body);

			expect(error()?.textContent?.trim()).toBe(TEXT_ERROR);
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/src/lib/hlm-error.directive.ts
```typescript
import { Directive } from '@angular/core';

@Directive({
	standalone: true,
	// eslint-disable-next-line @angular-eslint/directive-selector
	selector: 'hlm-error',
	host: {
		class: 'block text-destructive text-sm font-medium',
	},
})
export class HlmErrorDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/src/lib/hlm-form-field.component.ts
```typescript
import { Component, computed, contentChild, contentChildren, effect } from '@angular/core';
import { BrnFormFieldControl } from '@spartan-ng/brain/form-field';
import { HlmErrorDirective } from './hlm-error.directive';

@Component({
	selector: 'hlm-form-field',
	template: `
		<ng-content />

		@switch (hasDisplayedMessage()) {
			@case ('error') {
				<ng-content select="hlm-error" />
			}
			@default {
				<ng-content select="hlm-hint" />
			}
		}
	`,
	standalone: true,
	host: {
		class: 'space-y-2 block',
	},
})
export class HlmFormFieldComponent {
	public readonly control = contentChild(BrnFormFieldControl);

	public readonly errorChildren = contentChildren(HlmErrorDirective);

	protected readonly hasDisplayedMessage = computed<'error' | 'hint'>(() =>
		this.errorChildren() && this.errorChildren().length > 0 && this.control()?.errorState() ? 'error' : 'hint',
	);

	constructor() {
		effect(() => {
			if (!this.control()) {
				throw new Error('hlm-form-field must contain a BrnFormFieldControl.');
			}
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/form-field/helm/src/lib/hlm-hint.directive.ts
```typescript
import { Directive } from '@angular/core';

@Directive({
	// eslint-disable-next-line @angular-eslint/directive-selector
	selector: 'hlm-hint',
	standalone: true,
	host: {
		class: 'block text-sm text-muted-foreground',
	},
})
export class HlmHintDirective {}

```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sonner/sonner.stories.ts
```typescript
import { Component } from '@angular/core';
import type { Meta, StoryObj } from '@storybook/angular';
import { moduleMetadata } from '@storybook/angular';
import { toast } from 'ngx-sonner';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmToasterComponent } from './helm/src';

const meta: Meta<HlmToasterComponent> = {
	title: 'Sonner',
	component: HlmToasterComponent,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [HlmToasterComponent, HlmButtonDirective],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmToasterComponent>;

@Component({
	selector: 'sonner-story',
	standalone: true,
	imports: [HlmToasterComponent, HlmButtonDirective],
	template: `
		<hlm-toaster />
		<button hlmBtn (click)="showToast()">Show Toast</button>
	`,
})
export class SonnerStory {
	showToast() {
		toast('Event has been created', {
			description: 'Sunday, December 03, 2023 at 9:00 AM',
			action: {
				label: 'Undo',
				onClick: () => console.log('Undo'),
			},
		});
	}
}

export const Default: Story = {
	render: () => ({
		template: '<sonner-story />',
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sonner/helm/README.md
```
# ui-sonner-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-sonner-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sonner/helm/eslint.config.js
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
		},
	},
	{
		files: ['**/*.html'],
		// Override or add rules here
		rules: {},
	},
];

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sonner/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-sonner-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/ui/sonner/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sonner/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/sonner/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sonner/helm/package.json
```json
{
	"name": "@spartan-ng/ui-sonner-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {
		"tslib": "^2.3.0"
	},
	"peerDependencies": {
		"@angular/common": "^18.1.0",
		"@angular/core": "^18.1.0",
		"@ng-icons/lucide": "^26.3.0",
		"@spartan-ng/brain": "0.0.1-alpha.381",
		"clsx": "^2.1.1",
		"ngx-sonner": "^3.0.0"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sonner/helm/project.json
```json
{
	"name": "ui-sonner-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/sonner/helm/src",
	"prefix": "lib",
	"tags": ["scope:helm"],
	"projectType": "library",
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/sonner/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/sonner/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/sonner/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/sonner/helm/jest.config.ts"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sonner/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sonner/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sonner/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sonner/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sonner/helm/src/index.ts
```typescript
export * from './lib/hlm-toaster.component';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sonner/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sonner/helm/src/lib/hlm-toaster.component.ts
```typescript
import { ChangeDetectionStrategy, Component, booleanAttribute, computed, input, numberAttribute } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';
import { NgxSonnerToaster, type ToasterProps } from 'ngx-sonner';

@Component({
	selector: 'hlm-toaster',
	imports: [NgxSonnerToaster],
	template: `
		<ngx-sonner-toaster
			[class]="_computedClass()"
			[invert]="invert()"
			[theme]="theme()"
			[position]="position()"
			[hotKey]="hotKey()"
			[richColors]="richColors()"
			[expand]="expand()"
			[duration]="duration()"
			[visibleToasts]="visibleToasts()"
			[closeButton]="closeButton()"
			[toastOptions]="toastOptions()"
			[offset]="offset()"
			[dir]="dir()"
			[style]="userStyle()"
		/>
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HlmToasterComponent {
	public readonly invert = input<ToasterProps['invert'], boolean | string>(false, {
		transform: booleanAttribute,
	});
	public readonly theme = input<ToasterProps['theme']>('light');
	public readonly position = input<ToasterProps['position']>('bottom-right');
	public readonly hotKey = input<ToasterProps['hotkey']>(['altKey', 'KeyT']);
	public readonly richColors = input<ToasterProps['richColors'], boolean | string>(false, {
		transform: booleanAttribute,
	});
	public readonly expand = input<ToasterProps['expand'], boolean | string>(false, {
		transform: booleanAttribute,
	});
	public readonly duration = input<ToasterProps['duration'], number | string>(4000, {
		transform: numberAttribute,
	});
	public readonly visibleToasts = input<ToasterProps['visibleToasts'], number | string>(3, {
		transform: numberAttribute,
	});
	public readonly closeButton = input<ToasterProps['closeButton'], boolean | string>(false, {
		transform: booleanAttribute,
	});
	public readonly toastOptions = input<ToasterProps['toastOptions']>({
		classes: {
			toast:
				'group toast group-[.toaster]:bg-background group-[.toaster]:text-foreground group-[.toaster]:border-border group-[.toaster]:shadow-lg',
			description: 'group-[.toast]:text-muted-foreground',
			actionButton: 'group-[.toast]:bg-primary group-[.toast]:text-primary-foreground',
			cancelButton: 'group-[.toast]:bg-muted group-[.toast]:text-muted-foreground',
		},
	});
	public readonly offset = input<ToasterProps['offset']>(null);
	public readonly dir = input<ToasterProps['dir']>('auto');
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly userStyle = input<Record<string, string>>({}, { alias: 'style' });

	protected readonly _computedClass = computed(() => hlm('toaster group', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/button.stories.ts
```typescript
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from './helm/src';

const meta: Meta<HlmButtonDirective> = {
	title: 'Button',
	component: HlmButtonDirective,
	tags: ['autodocs'],
	args: {
		variant: 'default',
		size: 'default',
	},
	argTypes: {
		variant: {
			options: ['default', 'destructive', 'outline', 'secondary', 'ghost', 'link'],
			control: {
				type: 'select',
			},
		},
		size: {
			options: ['default', 'sm', 'lg', 'icon'],
			control: {
				type: 'select',
			},
		},
	},
	decorators: [
		moduleMetadata({
			imports: [HlmButtonDirective],
		}),
	],
	render: ({ ...args }) => ({
		props: args,
		template: `<button hlmBtn ${argsToTemplate(args)}>Click me</button>`,
	}),
};

export default meta;
type Story = StoryObj<HlmButtonDirective>;

export const Default: Story = {
	args: {
		variant: 'default',
		size: 'default',
	},
};

export const Destructive: Story = {
	args: {
		variant: 'destructive',
		size: 'default',
	},
};

export const Outline: Story = {
	args: {
		variant: 'outline',
		size: 'default',
	},
};

export const Secondary: Story = {
	args: {
		variant: 'secondary',
		size: 'default',
	},
};

export const Ghost: Story = {
	args: {
		variant: 'ghost',
		size: 'default',
	},
};

export const Link: Story = {
	args: {
		variant: 'link',
		size: 'default',
	},
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/README.md
```
# ui-button-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-button-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-button-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/button/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/package.json
```json
{
	"name": "@spartan-ng/ui-button-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/project.json
```json
{
	"name": "ui-button-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/button/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/button/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/button/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/button/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/button/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-button-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmButtonDirective } from './lib/hlm-button.directive';
export * from './lib/hlm-button.token';

export * from './lib/hlm-button.directive';

@NgModule({
	imports: [HlmButtonDirective],
	exports: [HlmButtonDirective],
})
export class HlmButtonModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/src/lib/hlm-button.directive.ts
```typescript
import { Directive, computed, input, signal } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';
import { injectBrnButtonConfig } from './hlm-button.token';

export const buttonVariants = cva(
	'inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none ring-offset-background',
	{
		variants: {
			variant: {
				default: 'bg-primary text-primary-foreground hover:bg-primary/90',
				destructive: 'bg-destructive text-destructive-foreground hover:bg-destructive/90',
				outline: 'border border-input hover:bg-accent hover:text-accent-foreground',
				secondary: 'bg-secondary text-secondary-foreground hover:bg-secondary/80',
				ghost: 'hover:bg-accent hover:text-accent-foreground',
				link: 'underline-offset-4 hover:underline text-primary',
			},
			size: {
				default: 'h-10 py-2 px-4',
				sm: 'h-9 px-3 rounded-md',
				lg: 'h-11 px-8 rounded-md',
				icon: 'h-10 w-10',
			},
		},
		defaultVariants: {
			variant: 'default',
			size: 'default',
		},
	},
);
export type ButtonVariants = VariantProps<typeof buttonVariants>;

@Directive({
	selector: '[hlmBtn]',
	standalone: true,
	exportAs: 'hlmBtn',
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmButtonDirective {
	private readonly _config = injectBrnButtonConfig();

	private readonly _additionalClasses = signal<ClassValue>('');

	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected readonly _computedClass = computed(() =>
		hlm(buttonVariants({ variant: this.variant(), size: this.size() }), this.userClass(), this._additionalClasses()),
	);

	public readonly variant = input<ButtonVariants['variant']>(this._config.variant);

	public readonly size = input<ButtonVariants['size']>(this._config.size);

	setClass(classes: string): void {
		this._additionalClasses.set(classes);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/button/helm/src/lib/hlm-button.token.ts
```typescript
import { InjectionToken, ValueProvider, inject } from '@angular/core';
import type { ButtonVariants } from './hlm-button.directive';

export interface BrnButtonConfig {
	variant: ButtonVariants['variant'];
	size: ButtonVariants['size'];
}

const defaultConfig: BrnButtonConfig = {
	variant: 'default',
	size: 'default',
};

const BrnButtonConfigToken = new InjectionToken<BrnButtonConfig>('BrnButtonConfig');

export function provideBrnButtonConfig(config: Partial<BrnButtonConfig>): ValueProvider {
	return { provide: BrnButtonConfigToken, useValue: { ...defaultConfig, ...config } };
}

export function injectBrnButtonConfig(): BrnButtonConfig {
	return inject(BrnButtonConfigToken, { optional: true }) ?? defaultConfig;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/date-picker.stories.ts
```typescript
import { type Meta, type StoryObj, moduleMetadata } from '@storybook/angular';
import { HlmDatePickerComponent } from './helm/src/lib/hlm-date-picker.component';

const meta: Meta<HlmDatePickerComponent<Date>> = {
	title: 'Date Picker',
	component: HlmDatePickerComponent,
	tags: ['autodocs'],
	args: {},
	argTypes: {},
	decorators: [
		moduleMetadata({
			imports: [HlmDatePickerComponent],
		}),
	],
	render: ({ ...args }) => ({
		props: args,
		template: `
		<div class="preview flex min-h-[350px] w-full justify-center p-10 items-center">
			<hlm-date-picker [min]="min" [max]="max">
                <span>Pick a date</span>
            </hlm-date-picker>
		</div>
		`,
	}),
};

export default meta;

type Story = StoryObj<HlmDatePickerComponent<Date>>;

export const Default: Story = {
	args: { min: new Date(2020, 4, 1), max: new Date(2030, 6, 1) },
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/README.md
```
# ui-calendar-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-calendar-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-calendar-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/ui/calendar/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/date-picker/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/package.json
```json
{
	"name": "@spartan-ng/ui-date-picker-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"peerDependencies": {
		"@angular/cdk": ">=19.0.0",
		"@angular/core": ">=19.0.0",
		"@angular/forms": ">=19.0.0",
		"@ng-icons/core": ">=29.0.0",
		"@ng-icons/lucide": ">=29.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"@spartan-ng/ui-calendar-helm": "0.0.1-alpha.381",
		"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
		"@spartan-ng/ui-popover-helm": "0.0.1-alpha.381",
		"clsx": "^2.1.1"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/project.json
```json
{
	"name": "ui-date-picker-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/date-picker/helm/src",
	"prefix": "brn",
	"projectType": "library",
	"tags": ["scope:help"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/date-picker/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/date-picker/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/date-picker/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/date-picker/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint"
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-date-picker-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/tsconfig.json
```json
{
	"compilerOptions": {
		"target": "es2022",
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmDatePickerMultiComponent } from './lib/hlm-date-picker-multi.component';
import { HlmDatePickerComponent } from './lib/hlm-date-picker.component';

export * from './lib/hlm-date-picker.token';

export * from './lib/hlm-date-picker-multi.component';
export * from './lib/hlm-date-picker.component';

export const HlmDatePickerImports = [HlmDatePickerComponent, HlmDatePickerMultiComponent] as const;

@NgModule({
	imports: [...HlmDatePickerImports],
	exports: [...HlmDatePickerImports],
})
export class HlmDatePickerModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/src/lib/hlm-date-picker-multi.component.ts
```typescript
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import {
	booleanAttribute,
	Component,
	computed,
	forwardRef,
	input,
	model,
	numberAttribute,
	output,
	signal,
} from '@angular/core';
import { NG_VALUE_ACCESSOR } from '@angular/forms';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideCalendar } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { BrnDialogState } from '@spartan-ng/brain/dialog';
import { type ChangeFn, type TouchFn } from '@spartan-ng/brain/forms';
import { BrnPopoverComponent, BrnPopoverContentDirective, BrnPopoverTriggerDirective } from '@spartan-ng/brain/popover';
import { HlmCalendarMultiComponent } from '@spartan-ng/ui-calendar-helm';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import { HlmPopoverContentDirective } from '@spartan-ng/ui-popover-helm';
import type { ClassValue } from 'clsx';
import { injectHlmDatePickerMultiConfig } from './hlm-date-picker-multi.token';

export const HLM_DATE_PICKER_MUTLI_VALUE_ACCESSOR = {
	provide: NG_VALUE_ACCESSOR,
	useExisting: forwardRef(() => HlmDatePickerMultiComponent),
	multi: true,
};

@Component({
	selector: 'hlm-date-picker-multi',
	imports: [
		NgIcon,
		HlmIconDirective,
		BrnPopoverComponent,
		BrnPopoverTriggerDirective,
		BrnPopoverContentDirective,
		HlmPopoverContentDirective,
		HlmCalendarMultiComponent,
	],
	providers: [HLM_DATE_PICKER_MUTLI_VALUE_ACCESSOR, provideIcons({ lucideCalendar })],
	template: `
		<brn-popover sideOffset="5" [state]="popoverState()" (stateChanged)="popoverState.set($event)">
			<button type="button" [class]="_computedClass()" [disabled]="state().disabled()" brnPopoverTrigger>
				<ng-icon hlm size="sm" name="lucideCalendar" />

				<span class="truncate">
					@if (formattedDate(); as formattedDate) {
						{{ formattedDate }}
					} @else {
						<ng-content />
					}
				</span>
			</button>

			<div hlmPopoverContent class="w-auto p-0" *brnPopoverContent="let ctx">
				<hlm-calendar-multi
					calendarClass="border-0 rounded-none"
					[date]="date()"
					[min]="min()"
					[max]="max()"
					[minSelection]="minSelection()"
					[maxSelection]="maxSelection()"
					[disabled]="state().disabled()"
					(dateChange)="_handleChange($event)"
				/>
			</div>
		</brn-popover>
	`,
	host: {
		class: 'block',
	},
})
export class HlmDatePickerMultiComponent<T> {
	private readonly _config = injectHlmDatePickerMultiConfig<T>();

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'inline-flex items-center gap-2 whitespace-nowrap rounded-md text-sm ring-offset-background transition-colors border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 px-4 py-2 w-[280px] justify-start text-left font-normal',
			'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2',
			'disabled:pointer-events-none disabled:opacity-50',
			'[&_ng-icon]:pointer-events-none [&_ng-icon]:shrink-0',
			!this.date() ? 'text-muted-foreground' : '',
			this.userClass(),
		),
	);

	/** The minimum date that can be selected.*/
	public readonly min = input<T>();

	/** The maximum date that can be selected. */
	public readonly max = input<T>();

	/** The minimum selectable dates.  */
	public readonly minSelection = input<number, NumberInput>(undefined, {
		transform: numberAttribute,
	});

	/** The maximum selectable dates.  */
	public readonly maxSelection = input<number, NumberInput>(undefined, {
		transform: numberAttribute,
	});

	/** Determine if the date picker is disabled. */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** The selected value. */
	public readonly date = model<T[]>();

	/** If true, the date picker will close when the max selection of dates is reached.. */
	public readonly autoCloseOnMaxSelection = input<boolean, BooleanInput>(this._config.autoCloseOnMaxSelection, {
		transform: booleanAttribute,
	});

	/** Defines how the date should be displayed in the UI.  */
	public readonly formatDates = input<(date: T[]) => string>(this._config.formatDates);

	/** Defines how the date should be transformed before saving to model/form. */
	public readonly transformDates = input<(date: T[]) => T[]>(this._config.transformDates);

	protected readonly popoverState = signal<BrnDialogState | null>(null);

	protected readonly state = computed(() => ({
		disabled: signal(this.disabled()),
	}));

	protected readonly formattedDate = computed(() => {
		const dates = this.date();
		return dates ? this.formatDates()(dates) : undefined;
	});

	public readonly changed = output<T[]>();

	protected _onChange?: ChangeFn<T[]>;
	protected _onTouched?: TouchFn;

	protected _handleChange(value: T[] | undefined) {
		if (value === undefined) return;

		if (this.state().disabled()) return;
		const transformedDate = this.transformDates()(value);

		this.date.set(transformedDate);
		this._onChange?.(transformedDate);
		this.changed.emit(transformedDate);

		if (this.autoCloseOnMaxSelection() && this.date()?.length === this.maxSelection()) {
			this.popoverState.set('closed');
		}
	}

	/** CONROL VALUE ACCESSOR */
	writeValue(value: T[] | null): void {
		// optional FormControl is initialized with null value
		if (value === null) return;

		this.date.set(this.transformDates()(value));
	}

	registerOnChange(fn: ChangeFn<T[]>): void {
		this._onChange = fn;
	}

	registerOnTouched(fn: TouchFn): void {
		this._onTouched = fn;
	}

	setDisabledState(isDisabled: boolean): void {
		this.state().disabled.set(isDisabled);
	}

	open() {
		this.popoverState.set('open');
	}

	close() {
		this.popoverState.set('closed');
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/src/lib/hlm-date-picker-multi.token.ts
```typescript
import { inject, InjectionToken, ValueProvider } from '@angular/core';

export interface HlmDatePickerMultiConfig<T> {
	/**
	 * If true, the date picker will close when the max selection of dates is reached.
	 */
	autoCloseOnMaxSelection: boolean;

	/**
	 * Defines how the date should be displayed in the UI.
	 *
	 * @param dates
	 * @returns formatted date
	 */
	formatDates: (dates: T[]) => string;

	/**
	 * Defines how the date should be transformed before saving to model/form.
	 *
	 * @param dates
	 * @returns transformed date
	 */
	transformDates: (dates: T[]) => T[];
}

function getDefaultConfig<T>(): HlmDatePickerMultiConfig<T> {
	return {
		formatDates: (dates) => dates.map((date) => (date instanceof Date ? date.toDateString() : `${date}`)).join(', '),
		transformDates: (dates) => dates,
		autoCloseOnMaxSelection: false,
	};
}

const HlmDatePickerMultiConfigToken = new InjectionToken<HlmDatePickerMultiConfig<unknown>>('HlmDatePickerMultiConfig');

export function provideHlmDatePickerConfig<T>(config: Partial<HlmDatePickerMultiConfig<T>>): ValueProvider {
	return { provide: HlmDatePickerMultiConfigToken, useValue: { ...getDefaultConfig(), ...config } };
}

export function injectHlmDatePickerMultiConfig<T>(): HlmDatePickerMultiConfig<T> {
	const injectedConfig = inject(HlmDatePickerMultiConfigToken, { optional: true });
	return injectedConfig ? (injectedConfig as HlmDatePickerMultiConfig<T>) : getDefaultConfig();
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/src/lib/hlm-date-picker.component.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, Component, computed, forwardRef, input, model, output, signal } from '@angular/core';
import { NG_VALUE_ACCESSOR } from '@angular/forms';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideCalendar } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { BrnDialogState } from '@spartan-ng/brain/dialog';
import { type ChangeFn, type TouchFn } from '@spartan-ng/brain/forms';
import { BrnPopoverComponent, BrnPopoverContentDirective, BrnPopoverTriggerDirective } from '@spartan-ng/brain/popover';
import { HlmCalendarComponent } from '@spartan-ng/ui-calendar-helm';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import { HlmPopoverContentDirective } from '@spartan-ng/ui-popover-helm';
import type { ClassValue } from 'clsx';
import { injectHlmDatePickerConfig } from './hlm-date-picker.token';

export const HLM_DATE_PICKER_VALUE_ACCESSOR = {
	provide: NG_VALUE_ACCESSOR,
	useExisting: forwardRef(() => HlmDatePickerComponent),
	multi: true,
};

@Component({
	selector: 'hlm-date-picker',
	imports: [
		NgIcon,
		HlmIconDirective,
		BrnPopoverComponent,
		BrnPopoverTriggerDirective,
		BrnPopoverContentDirective,
		HlmPopoverContentDirective,
		HlmCalendarComponent,
	],
	providers: [HLM_DATE_PICKER_VALUE_ACCESSOR, provideIcons({ lucideCalendar })],
	template: `
		<brn-popover sideOffset="5" [state]="popoverState()" (stateChanged)="popoverState.set($event)">
			<button type="button" [class]="_computedClass()" [disabled]="state().disabled()" brnPopoverTrigger>
				<ng-icon hlm size="sm" name="lucideCalendar" />

				<span class="truncate">
					@if (formattedDate(); as formattedDate) {
						{{ formattedDate }}
					} @else {
						<ng-content />
					}
				</span>
			</button>

			<div hlmPopoverContent class="w-auto p-0" *brnPopoverContent="let ctx">
				<hlm-calendar
					calendarClass="border-0 rounded-none"
					[date]="date()"
					[min]="min()"
					[max]="max()"
					[disabled]="state().disabled()"
					(dateChange)="_handleChange($event)"
				/>
			</div>
		</brn-popover>
	`,
	host: {
		class: 'block',
	},
})
export class HlmDatePickerComponent<T> {
	private readonly _config = injectHlmDatePickerConfig<T>();

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'inline-flex items-center gap-2 whitespace-nowrap rounded-md text-sm ring-offset-background transition-colors border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 px-4 py-2 w-[280px] justify-start text-left font-normal',
			'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2',
			'disabled:pointer-events-none disabled:opacity-50',
			'[&_ng-icon]:pointer-events-none [&_ng-icon]:shrink-0',
			!this.date() ? 'text-muted-foreground' : '',
			this.userClass(),
		),
	);

	/** The minimum date that can be selected.*/
	public readonly min = input<T>();

	/** The maximum date that can be selected. */
	public readonly max = input<T>();

	/** Determine if the date picker is disabled. */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** The selected value. */
	public readonly date = model<T>();

	/** If true, the date picker will close when a date is selected. */
	public readonly autoCloseOnSelect = input<boolean, BooleanInput>(this._config.autoCloseOnSelect, {
		transform: booleanAttribute,
	});

	/** Defines how the date should be displayed in the UI.  */
	public readonly formatDate = input<(date: T) => string>(this._config.formatDate);

	/** Defines how the date should be transformed before saving to model/form. */
	public readonly transformDate = input<(date: T) => T>(this._config.transformDate);

	protected readonly popoverState = signal<BrnDialogState | null>(null);

	protected readonly state = computed(() => ({
		disabled: signal(this.disabled()),
	}));

	protected readonly formattedDate = computed(() => {
		const date = this.date();
		return date ? this.formatDate()(date) : undefined;
	});

	public readonly changed = output<T>();

	protected _onChange?: ChangeFn<T>;
	protected _onTouched?: TouchFn;

	protected _handleChange(value: T) {
		if (this.state().disabled()) return;
		const transformedDate = this.transformDate()(value);

		this.date.set(transformedDate);
		this._onChange?.(transformedDate);
		this.changed.emit(transformedDate);

		if (this.autoCloseOnSelect()) {
			this.popoverState.set('closed');
		}
	}

	/** CONROL VALUE ACCESSOR */
	writeValue(value: T | null): void {
		// optional FormControl is initialized with null value
		if (value === null) return;

		this.date.set(this.transformDate()(value));
	}

	registerOnChange(fn: ChangeFn<T>): void {
		this._onChange = fn;
	}

	registerOnTouched(fn: TouchFn): void {
		this._onTouched = fn;
	}

	setDisabledState(isDisabled: boolean): void {
		this.state().disabled.set(isDisabled);
	}

	open() {
		this.popoverState.set('open');
	}

	close() {
		this.popoverState.set('closed');
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/date-picker/helm/src/lib/hlm-date-picker.token.ts
```typescript
import { inject, InjectionToken, ValueProvider } from '@angular/core';

export interface HlmDatePickerConfig<T> {
	/**
	 * If true, the date picker will close when a date is selected.
	 */
	autoCloseOnSelect: boolean;

	/**
	 * Defines how the date should be displayed in the UI.
	 *
	 * @param date
	 * @returns formatted date
	 */
	formatDate: (date: T) => string;

	/**
	 * Defines how the date should be transformed before saving to model/form.
	 *
	 * @param date
	 * @returns transformed date
	 */
	transformDate: (date: T) => T;
}

function getDefaultConfig<T>(): HlmDatePickerConfig<T> {
	return {
		formatDate: (date) => (date instanceof Date ? date.toDateString() : `${date}`),
		transformDate: (date) => date,
		autoCloseOnSelect: false,
	};
}

const HlmDatePickerConfigToken = new InjectionToken<HlmDatePickerConfig<unknown>>('HlmDatePickerConfig');

export function provideHlmDatePickerConfig<T>(config: Partial<HlmDatePickerConfig<T>>): ValueProvider {
	return { provide: HlmDatePickerConfigToken, useValue: { ...getDefaultConfig(), ...config } };
}

export function injectHlmDatePickerConfig<T>(): HlmDatePickerConfig<T> {
	const injectedConfig = inject(HlmDatePickerConfigToken, { optional: true });
	return injectedConfig ? (injectedConfig as HlmDatePickerConfig<T>) : getDefaultConfig();
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/scroll-area/scroll-area.stories.ts
```typescript
import { Component } from '@angular/core';
import type { Meta, StoryObj } from '@storybook/angular';
import { argsToTemplate, moduleMetadata } from '@storybook/angular';
import { NgScrollbar, NgScrollbarModule } from 'ngx-scrollbar';
import { HlmSeparatorDirective } from '../separator/helm/src';
import { HlmScrollAreaDirective } from './helm/src';

@Component({
	selector: 'scroll-area-stories',
	standalone: true,
	imports: [HlmSeparatorDirective, HlmScrollAreaDirective, NgScrollbarModule],
	template: `
		<ng-scrollbar hlm class="border-border h-72 w-48 rounded-md border">
			<div class="p-4">
				<h4 class="mb-4 text-sm font-medium leading-none">Tags</h4>
				@for (tag of tags; track tag) {
					<div class="text-sm">
						{{ tag }}
						<div hlmSeparator class="my-2"></div>
					</div>
				}
			</div>
		</ng-scrollbar>
	`,
})
class ScrollAreaStoriesComponent {
	tags = Array.from({ length: 50 }).map((_, i, a) => `v1.2.0-beta.${a.length - i}`);
}

const meta: Meta<NgScrollbar> = {
	title: 'Scroll Area',
	component: NgScrollbar,
	tags: ['autodocs'],
	args: {
		track: 'all',
		visibility: 'native',
	} as any, // this is required as storybook isn't inferring types from signals
	argTypes: {
		track: {
			options: ['vertical', 'horizontal', 'all'],
			control: {
				type: 'select',
			},
			table: {
				defaultValue: { summary: 'all' },
			},
		},
		visibility: {
			options: ['hover', 'always', 'native'],
			control: {
				type: 'select',
			},
			table: {
				defaultValue: { summary: 'native' },
			},
		},
	} as any,
	decorators: [
		moduleMetadata({
			imports: [HlmScrollAreaDirective, NgScrollbarModule, ScrollAreaStoriesComponent],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmScrollAreaDirective>;

export const Default: Story = {
	render: () => ({
		template: `
       <scroll-area-stories/>
    `,
	}),
};

export const Vertical: Story = {
	render: ({ ...args }) => ({
		props: args,
		template: `
        <ng-scrollbar hlm ${argsToTemplate(args)} class="border w-72 rounded-md border-border">
        <div class='p-6 whitespace-nowrap'>
            Lorem ipsum dolor sit amet, consectetur adipisicing elit. Accusantium architecto,<br>
        asperiores beatae consequuntur dolor ducimus et exercitationem facilis fugiat magni<br>
        nisi officiis quibusdam rem repellat reprehenderit totam veritatis voluptatibus! Nobis.
        </div>
        </ng-scrollbar>`,
	}),
};

```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/table.stories.ts
```typescript
import { TitleCasePipe } from '@angular/common';
import { Component, type TrackByFunction, computed, effect, signal, untracked } from '@angular/core';
import { toObservable, toSignal } from '@angular/core/rxjs-interop';
import { FormsModule } from '@angular/forms';
import { faker } from '@faker-js/faker';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronDown } from '@ng-icons/lucide';
import { BrnMenuModule } from '@spartan-ng/brain/menu';
import { BrnTableModule, type PaginatorState, useBrnColumnManager } from '@spartan-ng/brain/table';
import { BrnToggleGroupModule } from '@spartan-ng/brain/toggle-group';
import { type Meta, type StoryObj, moduleMetadata } from '@storybook/angular';
import { debounceTime } from 'rxjs';
import { HlmButtonDirective, HlmButtonModule } from '../button/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmInputDirective } from '../input/helm/src';
import { HlmMenuModule } from '../menu/helm/src';
import { HlmToggleGroupModule } from '../toggle-group/helm/src';
import { HlmTableComponent, HlmTableModule } from './helm/src';

const createUsers = (numUsers = 5) => {
	return Array.from({ length: numUsers }, () => ({
		name: faker.person.fullName(),
		age: faker.number.int({ min: 10, max: 100 }),
		height: faker.number.int({ min: 140, max: 210 }),
	}));
};

@Component({
	selector: 'table-story',
	standalone: true,
	imports: [
		FormsModule,
		BrnTableModule,
		HlmTableModule,
		BrnMenuModule,
		HlmMenuModule,
		HlmInputDirective,
		HlmButtonDirective,
		NgIcon,
		HlmIconDirective,
		TitleCasePipe,
	],
	providers: [provideIcons({ lucideChevronDown })],
	template: `
		<div class="flex justify-between">
			<input
				hlmInput
				placeholder="Filter by name"
				[ngModel]="_nameFilter()"
				(ngModelChange)="_rawFilterInput.set($event)"
			/>

			<button hlmBtn variant="outline" align="end" [brnMenuTriggerFor]="menu">
				Columns
				<ng-icon hlm name="lucideChevronDown" class="ml-2" size="sm" />
			</button>
			<ng-template #menu>
				<hlm-menu class="w-40">
					@for (column of _brnColumnManager.allColumns; track column) {
						<button
							hlmMenuItemCheckbox
							[disabled]="_brnColumnManager.isColumnDisabled(column.name)"
							[checked]="_brnColumnManager.isColumnVisible(column.name)"
							(triggered)="_brnColumnManager.toggleVisibility(column.name)"
						>
							<hlm-menu-item-check />
							<span>{{ column.label }}</span>
						</button>
					}
				</hlm-menu>
			</ng-template>
		</div>

		<brn-table
			hlm
			stickyHeader
			class="border-border mt-4 block h-[337px] overflow-scroll rounded-md border"
			[dataSource]="_data()"
			[displayedColumns]="_brnColumnManager.displayedColumns()"
			[trackBy]="_trackBy"
		>
			<brn-column-def name="name" class="w-40">
				<hlm-th truncate *brnHeaderDef>Name</hlm-th>
				<hlm-td truncate *brnCellDef="let element">
					{{ element.name }}
				</hlm-td>
			</brn-column-def>
			<brn-column-def name="age" class="w-40 justify-end">
				<hlm-th *brnHeaderDef>Age</hlm-th>
				<hlm-td class="tabular-nums" *brnCellDef="let element">
					{{ element.age }}
				</hlm-td>
			</brn-column-def>
			<brn-column-def name="height" class="w-40 justify-end tabular-nums">
				<hlm-th *brnHeaderDef>Height</hlm-th>
				<hlm-td *brnCellDef="let element">
					{{ element.height }}
				</hlm-td>
			</brn-column-def>
		</brn-table>
		<div
			class="mt-2 flex items-center justify-between"
			*brnPaginator="let ctx; totalElements: _totalElements(); pageSize: _pageSize(); onStateChange: _onStateChange"
		>
			<span class="text-sm tabular-nums">
				Showing entries {{ ctx.state().startIndex + 1 }} - {{ ctx.state().endIndex + 1 }} of {{ _totalElements() }}
			</span>
			<div class="flex">
				<select
					[ngModel]="_pageSize()"
					(ngModelChange)="_pageSize.set($event)"
					hlmInput
					size="sm"
					class="mr-1 inline-flex pr-8"
				>
					@for (size of _availablePageSizes; track size) {
						<option [value]="size">{{ size === 10000 ? 'All' : size }}</option>
					}
				</select>

				<div class="flex space-x-1">
					<button size="sm" variant="outline" hlmBtn [disabled]="!ctx.decrementable()" (click)="ctx.decrement()">
						Previous
					</button>
					<button size="sm" variant="outline" hlmBtn [disabled]="!ctx.incrementable()" (click)="ctx.increment()">
						Next
					</button>
				</div>
			</div>
		</div>
		<button size="sm" variant="outline" hlmBtn (click)="_loadNewUsers()">Mix it up</button>
	`,
})
class TableStory {
	private readonly _startEndIndex = signal({ start: 0, end: 0 });
	protected readonly _availablePageSizes = [10, 20, 50, 100, 10000];
	protected readonly _pageSize = signal(this._availablePageSizes[0]);

	protected readonly _brnColumnManager = useBrnColumnManager({
		name: { visible: true, label: 'Name' },
		age: { visible: false, label: 'Alter' },
		height: { visible: false, label: 'Größe' },
	});

	protected readonly _rawFilterInput = signal('');
	protected readonly _nameFilter = signal('');
	private readonly _debouncedFilter = toSignal(toObservable(this._rawFilterInput).pipe(debounceTime(300)));

	private readonly _users = signal(createUsers(20));
	private readonly _filteredUsers = computed(() =>
		this._users().filter((user) => {
			const nameFilter = this._nameFilter();
			return !nameFilter || user.name.toLowerCase().includes(nameFilter.toLowerCase());
		}),
	);
	protected readonly _data = computed(() =>
		this._filteredUsers().slice(this._startEndIndex().start, this._startEndIndex().end + 1),
	);
	protected readonly _trackBy: TrackByFunction<{ name: string }> = (_index: number, user: { name: string }) =>
		user.name;
	protected readonly _totalElements = computed(() => this._filteredUsers().length);
	protected readonly _onStateChange = (state: PaginatorState) => {
		this._startEndIndex.set({ start: state.startIndex, end: state.endIndex });
	};

	constructor() {
		// needed to sync the debounced filter to the name filter, but being able to override the
		// filter when loading new users without debounce
		effect(() => {
			const debouncedFilter = this._debouncedFilter();
			untracked(() => {
				this._nameFilter.set(debouncedFilter ?? '');
			});
		});
	}

	protected _loadNewUsers() {
		this._nameFilter.set('');
		this._users.set(createUsers(Math.random() * 200));
	}
}

@Component({
	selector: 'table-toggle-story',
	standalone: true,
	imports: [FormsModule, BrnTableModule, HlmTableModule, HlmButtonModule, BrnToggleGroupModule, HlmToggleGroupModule],
	template: `
		<brn-toggle-group
			aria-label="Show selected or all "
			hlm
			class="mb-2.5 w-full sm:w-fit"
			[ngModel]="_onlyAbove180()"
			(ngModelChange)="_setOnlyAbove180($event)"
		>
			<button class="w-full sm:w-40" variant="outline" [value]="false" hlm brnToggleGroupItem>All</button>
			<button class="w-full tabular-nums sm:w-40" variant="outline" [value]="true" hlm brnToggleGroupItem>
				Above 150
			</button>
		</brn-toggle-group>
		<brn-table
			hlm
			stickyHeader
			class="border-border mt-4 block h-[337px] overflow-scroll rounded-md border"
			[dataSource]="_data()"
			[displayedColumns]="_brnColumnManager.displayedColumns()"
			[trackBy]="_trackBy"
		>
			<brn-column-def name="name">
				<hlm-th truncate class="w-40" *brnHeaderDef>Name</hlm-th>
				<hlm-td truncate class="w-40" *brnCellDef="let element">
					{{ element.name }}
				</hlm-td>
			</brn-column-def>
			<brn-column-def name="age">
				<hlm-th class="w-40 justify-end" *brnHeaderDef>Age</hlm-th>
				<hlm-td class="w-40 justify-end tabular-nums" *brnCellDef="let element">
					{{ element.age }}
				</hlm-td>
			</brn-column-def>
			<brn-column-def name="height">
				<hlm-th class="w-40 justify-end" *brnHeaderDef>Height</hlm-th>
				<hlm-td class="w-40 justify-end tabular-nums" *brnCellDef="let element">
					{{ element.height }}
				</hlm-td>
			</brn-column-def>
		</brn-table>
		<div
			class="mt-2 flex items-center justify-between"
			*brnPaginator="let ctx; totalElements: _totalElements(); pageSize: _pageSize(); onStateChange: _onStateChange"
		>
			<span class="text-sm tabular-nums">
				Showing entries {{ ctx.state().startIndex + 1 }} - {{ ctx.state().endIndex + 1 }} of {{ _totalElements() }}
			</span>
			<div class="flex">
				<select
					[ngModel]="_pageSize()"
					(ngModelChange)="_pageSize.set($event)"
					hlmInput
					size="sm"
					class="mr-1 inline-flex pr-8"
				>
					@for (size of _availablePageSizes; track size) {
						<option [value]="size">{{ size === 10000 ? 'All' : size }}</option>
					}
				</select>

				<div class="flex space-x-1">
					<button size="sm" variant="outline" hlmBtn [disabled]="!ctx.decrementable()" (click)="ctx.decrement()">
						Previous
					</button>
					<button size="sm" variant="outline" hlmBtn [disabled]="!ctx.incrementable()" (click)="ctx.increment()">
						Next
					</button>
				</div>
			</div>
		</div>
		<button size="sm" variant="outline" hlmBtn (click)="_loadNewUsers()">Mix it up</button>
	`,
})
class TableToggleStory {
	private readonly _startEndIndex = signal({ start: 0, end: 0 });
	protected readonly _availablePageSizes = [10, 20, 50, 100, 10000];
	protected readonly _pageSize = signal(this._availablePageSizes[0]);

	protected readonly _onlyAbove180 = signal<boolean>(false);
	protected readonly _brnColumnManager = useBrnColumnManager({
		name: true,
		age: false,
		height: true,
	});

	private readonly _users = signal(createUsers(20));
	private readonly _filteredUsers = computed(() => {
		if (this._onlyAbove180()) return this._users().filter((u) => u.height > 180);
		return this._users();
	});
	protected readonly _data = computed(() =>
		this._filteredUsers().slice(this._startEndIndex().start, this._startEndIndex().end + 1),
	);
	protected readonly _trackBy: TrackByFunction<{ name: string }> = (_index: number, user: { name: string }) =>
		user.name;
	protected readonly _totalElements = computed(() => this._filteredUsers().length);
	protected readonly _onStateChange = (state: PaginatorState) => {
		this._startEndIndex.set({ start: state.startIndex, end: state.endIndex });
	};

	protected _loadNewUsers() {
		this._users.set(createUsers(Math.random() * 200));
	}

	protected _setOnlyAbove180(newVal: boolean) {
		if (newVal) {
			this._brnColumnManager.setInvisible('age');
		} else {
			this._brnColumnManager.setVisible('age');
		}
		this._onlyAbove180.set(newVal);
	}
}

@Component({
	selector: 'table-presentation-only-story',
	standalone: true,
	imports: [HlmTableModule],
	template: `
		<hlm-table>
			<hlm-trow>
				<hlm-th truncate class="w-40">Name</hlm-th>
				<hlm-th class="w-24 justify-end">Age</hlm-th>
				<hlm-th class="w-40 justify-center">Height</hlm-th>
			</hlm-trow>
			@for (row of _data(); track row) {
				<hlm-trow>
					<hlm-td truncate class="w-40">{{ row.name }}</hlm-td>
					<hlm-td class="w-24 justify-end">{{ row.age }}</hlm-td>
					<hlm-td class="w-40 justify-center">{{ row.height }}</hlm-td>
				</hlm-trow>
			}
		</hlm-table>
	`,
})
class TablePresentationOnlyStory {
	protected readonly _data = signal(createUsers(20));
}

const meta: Meta<HlmTableComponent> = {
	title: 'Table',
	component: HlmTableComponent,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [TableStory, TableToggleStory],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmTableComponent>;

export const Default: Story = {
	render: () => ({
		moduleMetadata: {
			imports: [TableStory],
		},
		template: '<table-story/>',
	}),
};

export const PresentationOnly: Story = {
	render: () => ({
		moduleMetadata: {
			imports: [TablePresentationOnlyStory],
		},
		template: '<table-presentation-only-story/>',
	}),
};

export const Toggle: Story = {
	render: () => ({
		template: '<table-toggle-story/>',
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/README.md
```
# ui-table-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-table-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-table-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/ui/table/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/table/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/package.json
```json
{
	"name": "@spartan-ng/ui-table-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/common": ">=19.0.0",
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"clsx": "^2.1.1"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/project.json
```json
{
	"name": "ui-table-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/table/helm/src",
	"prefix": "spartan-ng",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/table/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/table/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/table/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/table/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmCaptionComponent } from './lib/hlm-caption.component';
import { HlmTableComponent } from './lib/hlm-table.component';
import { HlmTableDirective } from './lib/hlm-table.directive';
import { HlmTdComponent } from './lib/hlm-td.component';
import { HlmThComponent } from './lib/hlm-th.component';
import { HlmTrowComponent } from './lib/hlm-trow.component';

export { HlmCaptionComponent } from './lib/hlm-caption.component';
export { HlmTableComponent } from './lib/hlm-table.component';
export { HlmTableDirective } from './lib/hlm-table.directive';
export { HlmTdComponent } from './lib/hlm-td.component';
export { HlmThComponent } from './lib/hlm-th.component';
export { HlmTrowComponent } from './lib/hlm-trow.component';

export const HlmTableImports = [
	HlmTableComponent,
	HlmTableDirective,
	HlmCaptionComponent,
	HlmThComponent,
	HlmTdComponent,
	HlmTrowComponent,
] as const;

@NgModule({
	imports: [...HlmTableImports],
	exports: [...HlmTableImports],
})
export class HlmTableModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/src/lib/hlm-caption.component.ts
```typescript
import {
	ChangeDetectionStrategy,
	Component,
	ViewEncapsulation,
	booleanAttribute,
	computed,
	effect,
	inject,
	input,
	untracked,
} from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';
import { HlmTableComponent } from './hlm-table.component';

let captionIdSequence = 0;

@Component({
	selector: 'hlm-caption',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		'[id]': 'id()',
	},
	template: `
		<ng-content />
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class HlmCaptionComponent {
	private readonly _table = inject(HlmTableComponent, { optional: true });

	protected readonly id = input<string | null | undefined>(`${captionIdSequence++}`);

	public readonly hidden = input(false, { transform: booleanAttribute });
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'text-center block mt-4 text-sm text-muted-foreground',
			this.hidden() ? 'sr-only' : 'order-last',
			this.userClass(),
		),
	);

	constructor() {
		effect(() => {
			const id = this.id();
			untracked(() => {
				if (!this._table) return;
				this._table.labeledBy.set(id);
			});
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/src/lib/hlm-table.component.ts
```typescript
import {
	ChangeDetectionStrategy,
	Component,
	ViewEncapsulation,
	computed,
	effect,
	input,
	signal,
	untracked,
} from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-table',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		role: 'table',
		'[attr.aria-labelledby]': 'labeledBy()',
	},
	template: `
		<ng-content />
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class HlmTableComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('flex flex-col text-sm [&_hlm-trow:last-child]:border-0', this.userClass()),
	);

	// we aria-labelledby to be settable from outside but use the input by default.
	public readonly _labeledByInput = input<string | null | undefined>(undefined, { alias: 'aria-labelledby' });
	public readonly labeledBy = signal<string | null | undefined>(undefined);

	constructor() {
		effect(() => {
			const labeledBy = this._labeledByInput();
			untracked(() => {
				this.labeledBy.set(labeledBy);
			});
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/src/lib/hlm-table.directive.ts
```typescript
import { Directive } from '@angular/core';
import { injectTableClassesSettable } from '@spartan-ng/brain/core';

@Directive({ standalone: true, selector: '[hlmTable],brn-table[hlm]' })
export class HlmTableDirective {
	private readonly _tableClassesSettable = injectTableClassesSettable({ host: true, optional: true });

	constructor() {
		this._tableClassesSettable?.setTableClasses({
			table: 'flex flex-col text-sm [&_cdk-row:last-child]:border-0',
			headerRow:
				'flex min-w-[100%] w-fit border-b border-border [&.cdk-table-sticky]:bg-background ' +
				'[&.cdk-table-sticky>*]:z-[101] [&.cdk-table-sticky]:before:z-0 [&.cdk-table-sticky]:before:block [&.cdk-table-sticky]:hover:before:bg-muted/50 [&.cdk-table-sticky]:before:absolute [&.cdk-table-sticky]:before:inset-0',
			bodyRow:
				'flex min-w-[100%] w-fit border-b border-border transition-[background-color] hover:bg-muted/50 [&:has([role=checkbox][aria-checked=true])]:bg-muted',
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/src/lib/hlm-td.component.ts
```typescript
import { NgTemplateOutlet } from '@angular/common';
import {
	ChangeDetectionStrategy,
	Component,
	ViewEncapsulation,
	booleanAttribute,
	computed,
	inject,
	input,
} from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnColumnDefComponent } from '@spartan-ng/brain/table';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-td',
	imports: [NgTemplateOutlet],
	host: {
		'[class]': '_computedClass()',
	},
	template: `
		<ng-template #content>
			<ng-content />
		</ng-template>
		@if (truncate()) {
			<span class="flex-1 truncate">
				<ng-container [ngTemplateOutlet]="content" />
			</span>
		} @else {
			<ng-container [ngTemplateOutlet]="content" />
		}
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class HlmTdComponent {
	private readonly _columnDef? = inject(BrnColumnDefComponent, { optional: true });
	public readonly truncate = input(false, { transform: booleanAttribute });

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm('flex flex-none p-4 items-center [&:has([role=checkbox])]:pr-0', this._columnDef?.class(), this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/src/lib/hlm-th.component.ts
```typescript
import { NgTemplateOutlet } from '@angular/common';
import {
	ChangeDetectionStrategy,
	Component,
	ViewEncapsulation,
	booleanAttribute,
	computed,
	inject,
	input,
} from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnColumnDefComponent } from '@spartan-ng/brain/table';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-th',
	imports: [NgTemplateOutlet],
	host: {
		'[class]': '_computedClass()',
	},
	template: `
		<ng-template #content>
			<ng-content />
		</ng-template>
		@if (truncate()) {
			<span class="flex-1 truncate">
				<ng-container [ngTemplateOutlet]="content" />
			</span>
		} @else {
			<ng-container [ngTemplateOutlet]="content" />
		}
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class HlmThComponent {
	private readonly _columnDef? = inject(BrnColumnDefComponent, { optional: true });
	public readonly truncate = input(false, { transform: booleanAttribute });

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'flex flex-none h-12 px-4 text-sm items-center font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0',
			this._columnDef?.class(),
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/table/helm/src/lib/hlm-trow.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-trow',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		role: 'row',
	},
	template: `
		<ng-content />
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class HlmTrowComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'flex flex border-b border-border transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/collapsible/collapsible.stories.ts
```typescript
import { BrnCollapsibleComponent, BrnCollapsibleImports } from '@spartan-ng/brain/collapsible';
import type { Meta, StoryObj } from '@storybook/angular';
import { argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';

const meta: Meta<BrnCollapsibleComponent> = {
	title: 'Collapsible',
	component: BrnCollapsibleComponent,
	tags: ['autodocs'],
	args: {
		disabled: false,
	},
	argTypes: {
		disabled: {
			control: {
				type: 'boolean',
			},
		},
	},
	decorators: [
		moduleMetadata({
			imports: [HlmButtonDirective, BrnCollapsibleImports],
		}),
	],
};

export default meta;
type Story = StoryObj<{}>;

export const Default: Story = {
	render: ({ ...args }) => ({
		template: `
    <brn-collapsible class="flex flex-col w-[350px] space-y-2" ${argsToTemplate(args)}>
      <div class="flex items-center justify-between px-4 space-x-4">
        <h4 class="text-sm font-semibold">
          &#64;peduarte starred 3 repositories
        </h4>
        <button brnCollapsibleTrigger hlmBtn variant="ghost" size="sm" class="p-0 w-9">
           <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4">
             <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 15L12 18.75 15.75 15m-7.5-6L12 5.25 15.75 9" />
             </svg>
            <span class="sr-only">Toggle</span>
          </button>
      </div>
      <div class="px-4 py-3 font-mono text-sm border rounded-md border-border">
        &#64;radix-ui/primitives
      </div>
      <brn-collapsible-content class="space-y-2">
        <div class="px-4 py-3 font-mono text-sm border rounded-md border-border">
          &#64;radix-ui/colors
        </div>
        <div class="px-4 py-3 font-mono text-sm border rounded-md border-border">
          &#64;stitches/react
        </div>
      </brn-collapsible-content>
    </brn-collapsible>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/context-menu.stories.ts
```typescript
import { NgIcon } from '@ng-icons/core';
import { BrnContextMenuTriggerDirective, BrnMenuTriggerDirective } from '@spartan-ng/brain/menu';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmMenuComponent, HlmMenuImports } from './helm/src';

const meta: Meta<HlmMenuComponent> = {
	title: 'Context Menu',
	component: HlmMenuComponent,
	tags: ['autodocs'],
	args: {
		variant: 'default',
	},
	argTypes: {
		variant: {
			options: ['default', 'menubar'],
			control: {
				type: 'select',
			},
		},
	},
	decorators: [
		moduleMetadata({
			imports: [
				BrnContextMenuTriggerDirective,
				BrnMenuTriggerDirective,
				HlmMenuImports,
				HlmButtonDirective,
				NgIcon,
				HlmIconDirective,
			],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmMenuComponent>;

export const Default: Story = {
	render: ({ ...args }) => ({
		props: args,
		template: `
        <div [brnCtxMenuTriggerFor]='menu'
         class='border-border flex h-[150px] w-[300px] items-center justify-center rounded-md border border-dashed text-sm'>
      Right click here
    </div>

    <ng-template #menu>
      <hlm-menu ${argsToTemplate(args)} class='w-64'>
        <hlm-menu-group>
          <button inset hlmMenuItem>
            Back
            <hlm-menu-shortcut>⌘[</hlm-menu-shortcut>
          </button>

          <button disabled inset hlmMenuItem>
            Forward
            <hlm-menu-shortcut>⌘]</hlm-menu-shortcut>
          </button>

          <button disabled inset hlmMenuItem>
            Reload
            <hlm-menu-shortcut>⌘R</hlm-menu-shortcut>
          </button>

          <button inset hlmMenuItem [brnMenuTriggerFor]='moreTools'>
            More Tools
            <hlm-menu-item-sub-indicator />
          </button>
        </hlm-menu-group>

        <hlm-menu-separator />

        <hlm-menu-group>
          <button hlmMenuItemCheckbox checked>
            <hlm-menu-item-check />
            Show Booksmarks Bar
            <hlm-menu-shortcut>⌘⇧B</hlm-menu-shortcut>
          </button>
          <button hlmMenuItemCheckbox>
            <hlm-menu-item-check />
            Show full URLs
          </button>
        </hlm-menu-group>

        <hlm-menu-separator />
        <hlm-menu-label inset>People</hlm-menu-label>
        <hlm-menu-separator />
        <hlm-menu-group>
          <button hlmMenuItemRadio checked>
            <hlm-menu-item-radio />
            Pedro Duarte
          </button>
          <button hlmMenuItemRadio>
            <hlm-menu-item-radio />
            Colm Tuite
          </button>
        </hlm-menu-group>
      </hlm-menu>
    </ng-template>

    <ng-template #moreTools>
      <hlm-sub-menu class='w-48'>
        <button hlmMenuItem>
          Save Page as...
          <hlm-menu-shortcut>⇧⌘S</hlm-menu-shortcut>
        </button>
        <button hlmMenuItem>
          Create Shortcut...
        </button>
        <button hlmMenuItem>
          Name Window...
        </button>
        <hlm-menu-separator />
        <button hlmMenuItem>Developer Tools</button>
      </hlm-sub-menu>
    </ng-template>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/dropdown-menu-bar.stories.ts
```typescript
import { NgIcon } from '@ng-icons/core';
import { BrnMenuTriggerDirective } from '@spartan-ng/brain/menu';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmMenuBarImports, HlmMenuComponent, HlmMenuImports } from './helm/src';

const meta: Meta<HlmMenuComponent> = {
	title: ' Menubar',
	component: HlmMenuComponent,
	tags: ['autodocs'],
	args: {
		variant: 'default',
	},
	argTypes: {
		variant: {
			options: ['default', 'menubar'],
			control: {
				type: 'select',
			},
		},
	},
	decorators: [
		moduleMetadata({
			imports: [
				BrnMenuTriggerDirective,
				HlmMenuImports,
				HlmMenuBarImports,
				HlmButtonDirective,
				NgIcon,
				HlmIconDirective,
			],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmMenuComponent>;

export const Default: Story = {
	render: ({ ...args }) => ({
		props: args,
		template: `
        <hlm-menu-bar class='w-fit'>
      <button hlmMenuBarItem [brnMenuTriggerFor]='file'>File</button>
      <button hlmMenuBarItem [brnMenuTriggerFor]='edit'>Edit</button>
      <button hlmMenuBarItem [brnMenuTriggerFor]='view'>View</button>
      <button hlmMenuBarItem [brnMenuTriggerFor]='profiles'>Profiles</button>
    </hlm-menu-bar>

    <ng-template #file>
      <hlm-menu ${argsToTemplate(args)} variant='menubar' class='w-48'>
        <hlm-menu-group>
          <button hlmMenuItem>
            New Tab
            <hlm-menu-shortcut>⌘T</hlm-menu-shortcut>
          </button>
          <button hlmMenuItem>
            New Window
            <hlm-menu-shortcut>⌘N</hlm-menu-shortcut>
          </button>
          <button hlmMenuItem disabled>New Incognito Window</button>

        </hlm-menu-group>

        <hlm-menu-separator />

        <button hlmMenuItem [brnMenuTriggerFor]='share'>
          Share
          <hlm-menu-item-sub-indicator />
        </button>

        <hlm-menu-separator />

        <button hlmMenuItem>
          Print...
          <hlm-menu-shortcut>⌘P</hlm-menu-shortcut>
        </button>

      </hlm-menu>
    </ng-template>
    <ng-template #share>
      <hlm-sub-menu>
        <button hlmMenuItem>
          Email link
        </button>
        <button hlmMenuItem>
          Messages
        </button>
        <button hlmMenuItem>
          Notes
        </button>
      </hlm-sub-menu>
    </ng-template>

    <ng-template #edit>
      <hlm-menu variant='menubar' class='w-48'>
        <hlm-menu-group>
          <button hlmMenuItem>
            Undo
            <hlm-menu-shortcut>⌘Z</hlm-menu-shortcut>
          </button>
          <button hlmMenuItem>
            Redo
            <hlm-menu-shortcut>⇧⌘Z</hlm-menu-shortcut>
          </button>
        </hlm-menu-group>

        <hlm-menu-separator />

        <button hlmMenuItem [brnMenuTriggerFor]='find'>
          Share
          <hlm-menu-item-sub-indicator />
        </button>

        <hlm-menu-separator />

        <button hlmMenuItem>Cut</button>
        <button hlmMenuItem>Copy</button>
        <button hlmMenuItem>Paste</button>

      </hlm-menu>
    </ng-template>
    <ng-template #find>
      <hlm-sub-menu>
        <button hlmMenuItem>
          Search the web
        </button>
        <hlm-menu-separator />
        <button hlmMenuItem>
          Find...
        </button>
        <button hlmMenuItem>
          Find Next
        </button>
        <button hlmMenuItem>
          Find Previous
        </button>
      </hlm-sub-menu>
    </ng-template>

    <ng-template #view>
      <hlm-menu variant='menubar'>
        <button hlmMenuItemCheckbox>
          <hlm-menu-item-check />
          Always Show Bookmarks Bar
        </button>
        <button hlmMenuItemCheckbox checked>
          <hlm-menu-item-check />
          Always Show Full URLs
        </button>
        <hlm-menu-separator />
        <button inset hlmMenuItem>
          Reload
          <hlm-menu-shortcut>⌘R</hlm-menu-shortcut>
        </button>
        <button inset disabled hlmMenuItem>
          Force Reload
          <hlm-menu-shortcut>⇧⌘R</hlm-menu-shortcut>
        </button>
        <hlm-menu-separator />
        <button inset hlmMenuItem>
          Toggle Fullscreen
        </button>
        <hlm-menu-separator />
        <button inset hlmMenuItem>
          Hide Sidebar
        </button>
      </hlm-menu>
    </ng-template>

    <ng-template #profiles>
      <hlm-menu variant='menubar' class='w-48'>
        <button hlmMenuItemRadio>
          <hlm-menu-item-radio />
          Andy
        </button>
        <button hlmMenuItemRadio checked>
          <hlm-menu-item-radio />
          Benoit
        </button>
        <button hlmMenuItemRadio>
          <hlm-menu-item-radio />
          Lewis
        </button>
        <hlm-menu-separator />
        <button inset hlmMenuItem>
          Edit...
        </button>
        <hlm-menu-separator />
        <button inset hlmMenuItem>
          Add Profile...
        </button>
      </hlm-menu>
    </ng-template>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/dropdown-menu.stories.ts
```typescript
import { Component } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import * as lucide from '@ng-icons/lucide';
import { BrnMenuTriggerDirective } from '@spartan-ng/brain/menu';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmMenuComponent, HlmMenuImports, HlmMenuItemCheckComponent, HlmMenuItemRadioComponent } from './helm/src';

const meta: Meta<HlmMenuComponent> = {
	title: 'Dropdown Menu',
	component: HlmMenuComponent,
	tags: ['autodocs'],
	args: {
		variant: 'default',
	},
	argTypes: {
		variant: {
			options: ['default', 'menubar'],
			control: {
				type: 'select',
			},
		},
	},
	decorators: [
		moduleMetadata({
			providers: [provideIcons(lucide)],
			imports: [BrnMenuTriggerDirective, HlmMenuImports, HlmButtonDirective, NgIcon, HlmIconDirective],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmMenuComponent>;

export const Default: Story = {
	render: ({ ...args }) => ({
		props: args,
		template: `
    <div class='w-full flex justify-center items-center pt-[20%]'>
      <button hlmBtn variant='outline' align='end' [brnMenuTriggerFor]='menu'>Open</button>
    </div>
    <ng-template #menu>
      <hlm-menu ${argsToTemplate(args)} class='w-56'>
        <hlm-menu-label>My Account</hlm-menu-label>
        <hlm-menu-separator />
        <hlm-menu-group>
          <button hlmMenuItem>
            <ng-icon hlm name='lucideUser' hlmMenuIcon />
            <span>Profile</span>
            <hlm-menu-shortcut>⇧⌘P</hlm-menu-shortcut>
          </button>

          <button hlmMenuItem>
            <ng-icon hlm name='lucideCreditCard' hlmMenuIcon />
            <span>Billing</span>
            <hlm-menu-shortcut>⌘B</hlm-menu-shortcut>
          </button>

          <button hlmMenuItem>
            <ng-icon hlm name='lucideSettings' hlmMenuIcon />
            <span>Settings</span>
            <hlm-menu-shortcut>⌘S</hlm-menu-shortcut>
          </button>

          <button hlmMenuItem>
            <ng-icon hlm name='lucideKeyboard' hlmMenuIcon />
            <span>Keyboard Shortcuts</span>
            <hlm-menu-shortcut>⌘K</hlm-menu-shortcut>
          </button>
        </hlm-menu-group>

        <hlm-menu-separator />

        <hlm-menu-group>
          <button hlmMenuItem>
            <ng-icon hlm name='lucideUsers' hlmMenuIcon />
            <span>Team</span>
            <hlm-menu-shortcut>⌘B</hlm-menu-shortcut>
          </button>

          <button hlmMenuItem [brnMenuTriggerFor]='invite'>
            <ng-icon hlm name='lucideUserPlus' hlmMenuIcon />
            <span>Invite Users</span>
            <hlm-menu-item-sub-indicator />
          </button>

          <button hlmMenuItem>
            <ng-icon hlm name='lucidePlus' hlmMenuIcon />
            <span>New Team</span>
            <hlm-menu-shortcut>⌘+T</hlm-menu-shortcut>
          </button>
        </hlm-menu-group>

        <hlm-menu-separator />

        <hlm-menu-group>
          <button hlmMenuItem [disabled]='false'>
            <ng-icon hlm name='lucideGithub' hlmMenuIcon />
            <span>Github</span>
          </button>

          <button hlmMenuItem [disabled]='true'>
            <ng-icon hlm name='lucideLifeBuoy' hlmMenuIcon />
            <span>Support</span>
          </button>

          <button hlmMenuItem disabled>
            <ng-icon hlm name='lucideCloud' hlmMenuIcon />
            <span>API</span>
          </button>
        </hlm-menu-group>

        <hlm-menu-separator />

        <button hlmMenuItem>
          <ng-icon hlm name='lucideLogOut' hlmMenuIcon />
          <span>Logout</span>
          <hlm-menu-shortcut>⇧⌘Q</hlm-menu-shortcut>
        </button>

      </hlm-menu>
    </ng-template>

    <ng-template #invite>
      <hlm-sub-menu>
        <button hlmMenuItem>
          <ng-icon hlm name='lucideMail' hlmMenuIcon />
          Email
        </button>

        <button hlmMenuItem>
          <ng-icon hlm name='lucideMessageSquare' hlmMenuIcon />
          Message
        </button>
        <hlm-menu-separator />
        <button hlmMenuItem>
          <ng-icon hlm name='lucideCirclePlus' hlmMenuIcon />
          <span>More</span>
        </button>
      </hlm-sub-menu>
    </ng-template>
    `,
	}),
};

@Component({
	selector: 'stateful-dropdown-story',
	standalone: true,
	imports: [
		BrnMenuTriggerDirective,
		HlmMenuImports,
		HlmButtonDirective,
		NgIcon,
		HlmIconDirective,
		HlmMenuItemCheckComponent,
		HlmMenuItemRadioComponent,
	],
	template: `
		<div class="flex w-full items-center justify-center pt-[20%]">
			<button hlmBtn variant="outline" align="center" [brnMenuTriggerFor]="menu">Open</button>
		</div>
		<ng-template #menu>
			<hlm-menu class="w-56">
				<hlm-menu-group>
					<hlm-menu-label>Appearance</hlm-menu-label>

					<button hlmMenuItemCheckbox [checked]="isPanel" (triggered)="isPanel = !isPanel">
						<hlm-menu-item-check />
						<span>Panel</span>
					</button>

					<button hlmMenuItemCheckbox disabled [checked]="isActivityBar" (triggered)="isActivityBar = !isActivityBar">
						<hlm-menu-item-check />
						<span>Activity Bar</span>
					</button>

					<button hlmMenuItemCheckbox [checked]="isStatusBar" (triggered)="isStatusBar = !isStatusBar">
						<hlm-menu-item-check />
						<span>Status Bar</span>
					</button>
				</hlm-menu-group>

				<hlm-menu-separator />

				<hlm-menu-label>Panel Position</hlm-menu-label>

				<hlm-menu-group>
					@for (size of panelPositions; track size) {
						<button hlmMenuItemRadio [checked]="size === selectedPosition" (triggered)="selectedPosition = size">
							<hlm-menu-item-radio />
							<span>{{ size }}</span>
						</button>
					}
				</hlm-menu-group>

				<hlm-menu-separator />

				<button hlmMenuItem (triggered)="reset()">
					<ng-icon hlm name="lucideUndo2" hlmMenuIcon />
					Reset
				</button>
			</hlm-menu>
		</ng-template>
	`,
})
class StatefulStory {
	isStatusBar = false;
	isPanel = false;
	isActivityBar = false;

	panelPositions = ['Top', 'Bottom', 'Right', 'Left'] as const;
	selectedPosition: (typeof this.panelPositions)[number] | undefined = 'Bottom';

	reset() {
		this.isStatusBar = false;
		this.isPanel = false;
		this.isActivityBar = false;
		this.selectedPosition = 'Bottom';
	}
}

export const Stateful: Story = {
	render: () => ({
		moduleMetadata: {
			imports: [StatefulStory],
		},
		template: '<stateful-dropdown-story/>',
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/README.md
```
# ui-menu-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-menu-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-menu-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/menu/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/package.json
```json
{
	"name": "@spartan-ng/ui-menu-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@ng-icons/core": ">=29.0.0",
		"@ng-icons/lucide": ">=29.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/project.json
```json
{
	"name": "ui-menu-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/menu/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/menu/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/menu/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/menu/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/menu/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-menu-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmMenuBarItemDirective } from './lib/hlm-menu-bar-item.directive';
import { HlmMenuBarComponent } from './lib/hlm-menu-bar.component';
import { HlmMenuGroupComponent } from './lib/hlm-menu-group.component';
import { HlmMenuItemCheckComponent } from './lib/hlm-menu-item-check.component';
import { HlmMenuItemCheckboxDirective } from './lib/hlm-menu-item-checkbox.directive';
import { HlmMenuItemIconDirective } from './lib/hlm-menu-item-icon.directive';
import { HlmMenuItemRadioComponent } from './lib/hlm-menu-item-radio.component';
import { HlmMenuItemRadioDirective } from './lib/hlm-menu-item-radio.directive';
import { HlmMenuItemSubIndicatorComponent } from './lib/hlm-menu-item-sub-indicator.component';
import { HlmMenuItemDirective } from './lib/hlm-menu-item.directive';
import { HlmMenuLabelComponent } from './lib/hlm-menu-label.component';
import { HlmMenuSeparatorComponent } from './lib/hlm-menu-separator.component';
import { HlmMenuShortcutComponent } from './lib/hlm-menu-shortcut.component';
import { HlmMenuComponent } from './lib/hlm-menu.component';
import { HlmSubMenuComponent } from './lib/hlm-sub-menu.component';

export * from './lib/hlm-menu-bar-item.directive';
export * from './lib/hlm-menu-bar.component';
export * from './lib/hlm-menu-group.component';
export * from './lib/hlm-menu-item-check.component';
export * from './lib/hlm-menu-item-checkbox.directive';
export * from './lib/hlm-menu-item-icon.directive';
export * from './lib/hlm-menu-item-radio.component';
export * from './lib/hlm-menu-item-radio.directive';
export * from './lib/hlm-menu-item-sub-indicator.component';
export * from './lib/hlm-menu-item.directive';
export * from './lib/hlm-menu-label.component';
export * from './lib/hlm-menu-separator.component';
export * from './lib/hlm-menu-shortcut.component';
export * from './lib/hlm-menu.component';
export * from './lib/hlm-sub-menu.component';

export const HlmMenuItemImports = [
	HlmMenuItemDirective,
	HlmMenuItemIconDirective,
	HlmMenuGroupComponent,
	HlmMenuItemSubIndicatorComponent,
	HlmMenuItemRadioComponent,
	HlmMenuItemCheckComponent,
	HlmMenuShortcutComponent,
	HlmMenuItemCheckboxDirective,
	HlmMenuItemRadioDirective,
];
export const HlmMenuStructureImports = [HlmMenuLabelComponent, HlmMenuSeparatorComponent] as const;
export const HlmMenuImports = [
	...HlmMenuItemImports,
	...HlmMenuStructureImports,
	HlmMenuComponent,
	HlmSubMenuComponent,
] as const;
export const HlmMenuBarImports = [...HlmMenuImports, HlmMenuBarComponent, HlmMenuBarItemDirective] as const;

@NgModule({
	imports: [...HlmMenuItemImports],
	exports: [...HlmMenuItemImports],
})
export class HlmMenuItemModule {}

@NgModule({
	imports: [...HlmMenuImports],
	exports: [...HlmMenuImports],
})
export class HlmMenuModule {}

@NgModule({
	imports: [...HlmMenuBarImports],
	exports: [...HlmMenuBarImports],
})
export class HlmMenuBarModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-menu-bar-item.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnMenuItemDirective } from '@spartan-ng/brain/menu';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmMenuBarItem]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [BrnMenuItemDirective],
})
export class HlmMenuBarItemDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground aria-expanded:bg-accent aria-expanded:text-accent-foreground',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-menu-bar.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnMenuBarDirective } from '@spartan-ng/brain/menu';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-menu-bar',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [BrnMenuBarDirective],
	template: '<ng-content/>',
})
export class HlmMenuBarComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm('border-border flex h-10 items-center space-x-1 rounded-md border bg-background p-1', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-menu-group.component.ts
```typescript
import { Component } from '@angular/core';
import { BrnMenuGroupDirective } from '@spartan-ng/brain/menu';

@Component({
	selector: 'hlm-menu-group',
	standalone: true,
	host: {
		class: 'block',
	},
	hostDirectives: [BrnMenuGroupDirective],
	template: `
		<ng-content />
	`,
})
export class HlmMenuGroupComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-menu-item-check.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideCheck } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-menu-item-check',
	providers: [provideIcons({ lucideCheck })],
	imports: [NgIcon, HlmIconDirective],
	template: `
		<!-- Using 1rem for size to mimick h-4 w-4 -->
		<ng-icon hlm size="1rem" name="lucideCheck" />
	`,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmMenuItemCheckComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'group-[.checked]:opacity-100 opacity-0 absolute left-2 flex h-3.5 w-3.5 items-center justify-center',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-menu-item-checkbox.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnMenuItemCheckboxDirective } from '@spartan-ng/brain/menu';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmMenuItemCheckbox]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [
		{
			directive: BrnMenuItemCheckboxDirective,
			inputs: ['disabled: disabled', 'checked: checked'],
			outputs: ['triggered: triggered'],
		},
	],
})
export class HlmMenuItemCheckboxDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'group w-full relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus-visible:bg-accent focus-visible:text-accent-foreground disabled:pointer-events-none disabled:opacity-50',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-menu-item-icon.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { provideHlmIconConfig } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmMenuIcon]',
	standalone: true,
	providers: [provideHlmIconConfig({ size: 'sm' })],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmMenuItemIconDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('mr-2', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-menu-item-radio.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideCircle } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-menu-item-radio',
	providers: [provideIcons({ lucideCircle })],
	imports: [NgIcon, HlmIconDirective],
	template: `
		<!-- Using 0.5rem for size to mimick h-2 w-2 -->
		<ng-icon hlm size="0.5rem" class="*:*:fill-current" name="lucideCircle" />
	`,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmMenuItemRadioComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'group-[.checked]:opacity-100 opacity-0 absolute left-2 flex h-3.5 w-3.5 items-center justify-center',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-menu-item-radio.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnMenuItemRadioDirective } from '@spartan-ng/brain/menu';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmMenuItemRadio]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [
		{
			directive: BrnMenuItemRadioDirective,
			inputs: ['disabled: disabled', 'checked: checked'],
			outputs: ['triggered: triggered'],
		},
	],
})
export class HlmMenuItemRadioDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'group w-full relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus-visible:bg-accent focus-visible:text-accent-foreground disabled:pointer-events-none disabled:opacity-50',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-menu-item-sub-indicator.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronRight } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-menu-item-sub-indicator',
	providers: [provideIcons({ lucideChevronRight })],
	imports: [NgIcon, HlmIconDirective],
	template: `
		<ng-icon hlm size="none" class="h-full w-full" name="lucideChevronRight" />
	`,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmMenuItemSubIndicatorComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('inline-block ml-auto h-4 w-4', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-menu-item.directive.ts
```typescript
import { Directive, Input, booleanAttribute, computed, input, signal } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnMenuItemDirective } from '@spartan-ng/brain/menu';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const hlmMenuItemVariants = cva(
	'group w-full relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus-visible:bg-accent focus-visible:text-accent-foreground disabled:pointer-events-none disabled:opacity-50',
	{
		variants: { inset: { true: 'pl-8', false: '' } },
		defaultVariants: { inset: false },
	},
);
export type HlmMenuItemVariants = VariantProps<typeof hlmMenuItemVariants>;

@Directive({
	selector: '[hlmMenuItem]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [
		{
			directive: BrnMenuItemDirective,
			inputs: ['disabled: disabled'],
			outputs: ['triggered: triggered'],
		},
	],
})
export class HlmMenuItemDirective {
	private readonly _inset = signal<boolean>(false);

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(hlmMenuItemVariants({ inset: this._inset() }), this.userClass()));

	@Input({ transform: booleanAttribute })
	public set inset(value: boolean) {
		this._inset.set(value);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-menu-label.component.ts
```typescript
import { Component, Input, booleanAttribute, computed, input, signal } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-menu-label',
	standalone: true,
	template: `
		<ng-content />
	`,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmMenuLabelComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm('block px-2 py-1.5 text-sm font-semibold', this._inset() && 'pl-8', this.userClass()),
	);

	private readonly _inset = signal<ClassValue>(false);
	@Input({ transform: booleanAttribute })
	public set inset(value: boolean) {
		this._inset.set(value);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-menu-separator.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-menu-separator',
	standalone: true,
	template: '',
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmMenuSeparatorComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('block -mx-1 my-1 h-px bg-muted', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-menu-shortcut.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-menu-shortcut',
	standalone: true,
	template: `
		<ng-content />
	`,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmMenuShortcutComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm('ml-auto font-light text-xs tracking-widest opacity-60', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-menu.component.ts
```typescript
import { Component, Input, computed, input, signal } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnMenuDirective } from '@spartan-ng/brain/menu';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const menuVariants = cva(
	'block border-border min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2',
	{
		variants: {
			variant: {
				default: 'my-0.5',
				menubar: 'my-2',
			},
		},
		defaultVariants: {
			variant: 'default',
		},
	},
);
type MenuVariants = VariantProps<typeof menuVariants>;

@Component({
	selector: 'hlm-menu',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [BrnMenuDirective],
	template: `
		<ng-content />
	`,
})
export class HlmMenuComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(menuVariants({ variant: this._variant() }), this.userClass()));

	private readonly _variant = signal<MenuVariants['variant']>('default');
	@Input()
	public set variant(value: MenuVariants['variant']) {
		this._variant.set(value);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/menu/helm/src/lib/hlm-sub-menu.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnMenuDirective } from '@spartan-ng/brain/menu';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-sub-menu',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [BrnMenuDirective],
	template: `
		<ng-content />
	`,
})
export class HlmSubMenuComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'border-border min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-lg data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/avatar.stories.ts
```typescript
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmAvatarComponent, HlmAvatarImports } from './helm/src';

const meta: Meta<HlmAvatarComponent> = {
	title: 'Avatar',
	component: HlmAvatarComponent,
	tags: ['autodocs'],
	argTypes: {
		variant: {
			options: ['small', 'medium', 'large'],
			control: {
				type: 'select',
			},
		},
	},
	decorators: [
		moduleMetadata({
			imports: [HlmAvatarImports],
		}),
	],
	render: ({ ...args }) => ({
		props: { args },
		template: `
    <hlm-avatar ${argsToTemplate(args)}>
      <img src='/mountains.jpg' alt='Spartan logo. A red spearhead with the Angular A'  hlmAvatarImage>
      <span class='bg-sky-600 text-sky-50' hlmAvatarFallback>MT</span>
    </hlm-avatar>
`,
	}),
};

export default meta;
type Story = StoryObj<HlmAvatarComponent>;

export const Small: Story = {
	args: {
		variant: 'small',
	},
};

export const Medium: Story = {
	args: {
		variant: 'medium',
	},
};

export const Large: Story = {
	args: {
		variant: 'large',
	},
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/README.md
```
# ui-avatar-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-avatar-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-avatar-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/avatar/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/package.json
```json
{
	"name": "@spartan-ng/ui-avatar-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/project.json
```json
{
	"name": "ui-avatar-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/avatar/helm/src",
	"prefix": "hlm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/avatar/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/avatar/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/avatar/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/avatar/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-avatar-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmAvatarFallbackDirective } from './lib/fallback';
import { HlmAvatarComponent } from './lib/hlm-avatar.component';
import { HlmAvatarImageDirective } from './lib/image';

export * from './lib/fallback';
export * from './lib/hlm-avatar.component';
export * from './lib/image';

export const HlmAvatarImports = [HlmAvatarFallbackDirective, HlmAvatarImageDirective, HlmAvatarComponent] as const;

@NgModule({
	imports: [...HlmAvatarImports],
	exports: [...HlmAvatarImports],
})
export class HlmAvatarModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/lib/hlm-avatar.component.spec.ts
```typescript
import { Component, Input } from '@angular/core';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { BrnAvatarFallbackDirective, BrnAvatarImageDirective } from '@spartan-ng/brain/avatar';
import { HlmAvatarComponent } from './hlm-avatar.component';

@Component({
	selector: 'hlm-mock',
	imports: [BrnAvatarImageDirective, BrnAvatarFallbackDirective, HlmAvatarComponent],
	template: `
		<hlm-avatar [class]="class" id="fallbackOnly">
			<span brnAvatarFallback>fallback</span>
		</hlm-avatar>
	`,
	standalone: true,
})
class MockComponent {
	@Input() public class = '';
}

describe('HlmAvatarComponent', () => {
	let component: HlmAvatarComponent;
	let fixture: ComponentFixture<HlmAvatarComponent>;

	beforeEach(() => {
		fixture = TestBed.createComponent(HlmAvatarComponent);
		component = fixture.componentInstance;
	});

	it('should compile', () => {
		expect(component).toBeTruthy();
	});

	it('should add the default classes if no inputs are provided', () => {
		fixture.detectChanges();
		expect(fixture.nativeElement.className).toBe('flex h-10 overflow-hidden relative rounded-full shrink-0 w-10');
	});

	it('should add any user defined classes', () => {
		const mockFixture = TestBed.createComponent(MockComponent);
		mockFixture.componentRef.setInput('class', 'test-class');
		mockFixture.detectChanges();
		const avatar = mockFixture.nativeElement.querySelector('hlm-avatar');
		expect(avatar.className).toContain('test-class');
	});

	it('should change the size when the variant is changed', () => {
		fixture.componentRef.setInput('variant', 'small');
		fixture.detectChanges();
		expect(fixture.nativeElement.className).toContain('h-6');
		expect(fixture.nativeElement.className).toContain('w-6');
		expect(fixture.nativeElement.className).toContain('text-xs');

		fixture.componentRef.setInput('variant', 'large');
		fixture.detectChanges();
		expect(fixture.nativeElement.className).toContain('h-14');
		expect(fixture.nativeElement.className).toContain('w-14');
		expect(fixture.nativeElement.className).toContain('text-lg');
	});

	it('should support brn directives', () => {
		const mockFixture = TestBed.createComponent(MockComponent);
		mockFixture.detectChanges();
		expect(mockFixture.nativeElement.querySelector('span').textContent).toBe('fallback');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/lib/hlm-avatar.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, input } from '@angular/core';
import { BrnAvatarComponent } from '@spartan-ng/brain/avatar';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const avatarVariants = cva('relative flex shrink-0 overflow-hidden rounded-full', {
	variants: {
		variant: {
			small: 'h-6 w-6 text-xs',
			medium: 'h-10 w-10',
			large: 'h-14 w-14 text-lg',
		},
	},
	defaultVariants: {
		variant: 'medium',
	},
});

export type AvatarVariants = VariantProps<typeof avatarVariants>;

@Component({
	selector: 'hlm-avatar',
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	template: `
		@if (image()?.canShow()) {
			<ng-content select="[hlmAvatarImage],[brnAvatarImage]" />
		} @else {
			<ng-content select="[hlmAvatarFallback],[brnAvatarFallback]" />
		}
	`,
})
export class HlmAvatarComponent extends BrnAvatarComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly variant = input<AvatarVariants['variant']>('medium');

	protected readonly _computedClass = computed(() =>
		hlm(avatarVariants({ variant: this.variant() }), this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/lib/fallback/hlm-avatar-fallback.directive.spec.ts
```typescript
import { Component, PLATFORM_ID } from '@angular/core';
import { type ComponentFixture, TestBed, fakeAsync } from '@angular/core/testing';
import { hexColorFor, isBright } from '@spartan-ng/brain/avatar';
import { HlmAvatarFallbackDirective } from './hlm-avatar-fallback.directive';

@Component({
	selector: 'hlm-mock',
	standalone: true,
	imports: [HlmAvatarFallbackDirective],
	template: `
		<span hlmAvatarFallback [class]="userCls" [autoColor]="autoColor">fallback2</span>
	`,
})
class HlmMockComponent {
	public userCls = '';
	public autoColor = false;
}

describe('HlmAvatarFallbackDirective', () => {
	let component: HlmMockComponent;
	let fixture: ComponentFixture<HlmMockComponent>;

	beforeEach(() => {
		fixture = TestBed.overrideProvider(PLATFORM_ID, { useValue: 'browser' }).createComponent(HlmMockComponent);
		component = fixture.componentInstance;
	});

	it('should compile', () => {
		expect(component).toBeTruthy();
	});

	it('should contain the default classes if no inputs are provided', () => {
		fixture.detectChanges();
		expect(fixture.nativeElement.querySelector('span').className).toBe(
			'bg-muted flex h-full items-center justify-center rounded-full w-full',
		);
	});

	it('should add any user defined classes', async () => {
		component.userCls = 'test-class';

		fixture.detectChanges();
		expect(fixture.nativeElement.querySelector('span').className).toContain('test-class');
	});
	it('should merge bg-destructive correctly when set as user defined class, therefore removing bg-muted', async () => {
		component.userCls = 'bg-destructive ';

		fixture.detectChanges();
		expect(fixture.nativeElement.querySelector('span').className).toContain('bg-destructive');
	});

	describe('autoColor', () => {
		beforeEach(() => {
			component.autoColor = true;
			fixture.detectChanges();
		});

		it('should remove the bg-muted class from the component', fakeAsync(() => {
			fixture.detectChanges();
			expect(fixture.nativeElement.querySelector('span').className).not.toContain('bg-muted');
		}));

		it('should remove add a text color class and hex backgroundColor style depending on its content', () => {
			const hex = hexColorFor('fallback2');
			const textCls = isBright(hex) ? 'text-black' : 'text-white';
			expect(fixture.nativeElement.querySelector('span').className).toContain(textCls);
			expect(fixture.nativeElement.querySelector('span').style.backgroundColor).toBe('rgb(144, 53, 149)');
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/lib/fallback/hlm-avatar-fallback.directive.ts
```typescript
import { Directive, computed, inject } from '@angular/core';
import { BrnAvatarFallbackDirective, hexColorFor, isBright } from '@spartan-ng/brain/avatar';
import { hlm } from '@spartan-ng/brain/core';

@Directive({
	selector: '[hlmAvatarFallback]',
	standalone: true,
	exportAs: 'avatarFallback',
	hostDirectives: [
		{
			directive: BrnAvatarFallbackDirective,
			inputs: ['class:class', 'autoColor:autoColor'],
		},
	],
	host: {
		'[class]': '_computedClass()',
		'[style.backgroundColor]': "_hex() || ''",
	},
})
export class HlmAvatarFallbackDirective {
	private readonly _brn = inject(BrnAvatarFallbackDirective);
	private readonly _hex = computed(() => {
		if (!this._brn.autoColor() || !this._brn.getTextContent()) return;
		return hexColorFor(this._brn.getTextContent());
	});

	private readonly _autoColorTextCls = computed(() => {
		const hex = this._hex();
		if (!hex) return;
		return `${isBright(hex) ? 'text-black' : 'text-white'}`;
	});

	protected readonly _computedClass = computed(() => {
		return hlm(
			'flex h-full w-full items-center justify-center rounded-full',
			this._autoColorTextCls() ?? 'bg-muted',
			this._brn?.userClass(),
		);
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/lib/fallback/index.ts
```typescript
export * from './hlm-avatar-fallback.directive';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/lib/image/hlm-avatar-image.directive.spec.ts
```typescript
import { Component } from '@angular/core';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { HlmAvatarImageDirective } from './hlm-avatar-image.directive';

@Component({
	selector: 'hlm-mock',
	standalone: true,
	imports: [HlmAvatarImageDirective],
	template: `
		<img hlmAvatarImage alt="Avatar image" [class]="userCls" />
	`,
})
class HlmMockComponent {
	public userCls = '';
}

describe('HlmAvatarImageDirective', () => {
	let component: HlmMockComponent;
	let fixture: ComponentFixture<HlmMockComponent>;

	beforeEach(() => {
		fixture = TestBed.createComponent(HlmMockComponent);
		component = fixture.componentInstance;
	});

	it('should compile', () => {
		expect(component).toBeTruthy();
	});

	it('should add the default classes if no inputs are provided', () => {
		fixture.detectChanges();
		expect(fixture.nativeElement.querySelector('img').className).toBe('aspect-square h-full object-cover w-full');
	});

	it('should add any user defined classes', async () => {
		component.userCls = 'test-class';
		fixture.detectChanges();

		// fallback uses Promise.resolve().then() so we need to wait for the next tick
		setTimeout(() => {
			expect(fixture.nativeElement.querySelector('img').className).toContain('test-class');
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/lib/image/hlm-avatar-image.directive.ts
```typescript
import { Directive, computed, inject, input } from '@angular/core';
import { BrnAvatarImageDirective } from '@spartan-ng/brain/avatar';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: 'img[hlmAvatarImage]',
	standalone: true,
	exportAs: 'avatarImage',
	hostDirectives: [BrnAvatarImageDirective],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmAvatarImageDirective {
	public canShow = inject(BrnAvatarImageDirective).canShow;

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('aspect-square object-cover h-full w-full', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/lib/image/index.ts
```typescript
export * from './hlm-avatar-image.directive';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/typography.stories.ts
```typescript
import type { Meta, StoryObj } from '@storybook/angular';
import { moduleMetadata } from '@storybook/angular';
import { hlmBlockquote, hlmH1, hlmH2, hlmH3, hlmLead, hlmP, hlmUl } from './helm/src';

const meta: Meta<{}> = {
	title: 'Typography',
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [],
		}),
	],
};

export default meta;
type Story = StoryObj<{}>;

export const Default: Story = {
	render: () => ({
		template: `
    <h1 class="${hlmH1}">The Joke Tax Chronicles</h1>
    <p class="${hlmLead} mt-4">
      Once upon a time, in a far-off land, there was a very lazy king who spent all day lounging on his throne. One day,
      his advisors came to him with a problem: the kingdom was running out of money.
    </p>
    <h2 class="${hlmH2} mt-10">The King's Plan</h2>
    <p class="${hlmP}">
      The king thought long and hard, and finally came up with a brilliant plan : he would tax the jokes in the kingdom.
    </p>
    <blockquote class="${hlmBlockquote}">
      "After all," he said, "everyone enjoys a good joke, so it's only fair that they should pay for the privilege."
    </blockquote>
    <h3 class="${hlmH3} mt-8">The Joke Tax</h3>
    <p class="${hlmP}">The king's subjects were not amused. They grumbled and complained, but the king was firm:</p>
    <ul class="${hlmUl}">
      <li>1st level of puns: 5 gold coins</li>
      <li>2nd level of jokes: 10 gold coins</li>
      <li>3rd level of one-liners : 20 gold coins</li>
    </ul>
    <p class="${hlmP}">
      As a result, people stopped telling jokes, and the kingdom fell into a gloom. But there was one person who refused
      to let the king's foolishness get him down: a court jester named Jokester.
    </p>
    <h3 class="${hlmH3} mt-8">Jokester's Revolt</h3>
    <p class="${hlmP}">
      Jokester began sneaking into the castle in the middle of the night and leaving jokes all over the place: under the
      king's pillow, in his soup, even in the royal toilet. The king was furious, but he couldn't seem to stop Jokester.
    </p>
    <p class="${hlmP}">
      And then, one day, the people of the kingdom discovered that the jokes left by Jokester were so funny that they
      couldn't help but laugh. And once they started laughing, they couldn't stop.
    </p>
    <h3 class="${hlmH3} mt-8">The People's Rebellion</h3>
    <p class="${hlmP}">
      The people of the kingdom, feeling uplifted by the laughter, started to tell jokes and puns again, and soon the
      entire kingdom was in on the joke.
    </p>
    <p class="${hlmP}">
      The king, seeing how much happier his subjects were, realized the error of his ways and repealed the joke tax.
      Jokester was declared a hero, and the kingdom lived happily ever after.
    </p>
    <p class="${hlmP}">
      The moral of the story is: never underestimate the power of a good laugh and always be careful of bad ideas.
    </p>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/README.md
```
# ui-typography-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-typography-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-typography-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/button/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/typography/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/package.json
```json
{
	"name": "@spartan-ng/ui-typography-helm",
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/project.json
```json
{
	"name": "ui-typography-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/typography/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/typography/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/typography/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/typography/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/typography/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-typography-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/src/index.ts
```typescript
export * from './lib/hlm-blockquote.directive';
export * from './lib/hlm-code.directive';
export * from './lib/hlm-h1.directive';
export * from './lib/hlm-h2.directive';
export * from './lib/hlm-h3.directive';
export * from './lib/hlm-h4.directive';
export * from './lib/hlm-large.directive';
export * from './lib/hlm-lead.directive';
export * from './lib/hlm-muted.directive';
export * from './lib/hlm-p.directive';
export * from './lib/hlm-small.directive';
export * from './lib/hlm-ul.directive';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/src/lib/hlm-blockquote.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export const hlmBlockquote = 'mt-6 border-border border-l-2 pl-6 italic';

@Directive({
	selector: '[hlmBlockquote]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmBlockquoteDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(hlmBlockquote, this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/src/lib/hlm-code.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export const hlmCode = 'relative rounded bg-muted px-[0.3rem] py-[0.2rem] font-mono text-sm font-semibold';

@Directive({
	selector: '[hlmCode]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmCodeDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(hlmCode, this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/src/lib/hlm-h1.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export const hlmH1 = 'scroll-m-20 text-4xl font-extrabold tracking-tight lg:text-5xl';

@Directive({
	selector: '[hlmH1]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmH1Directive {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(hlmH1, this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/src/lib/hlm-h2.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export const hlmH2 =
	'scroll-m-20 border-border border-b pb-2 text-3xl font-semibold tracking-tight transition-colors first:mt-0';

@Directive({
	selector: '[hlmH2]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmH2Directive {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(hlmH2, this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/src/lib/hlm-h3.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export const hlmH3 = 'scroll-m-20 text-2xl font-semibold tracking-tight';

@Directive({
	selector: '[hlmH3]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmH3Directive {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(hlmH3, this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/src/lib/hlm-h4.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export const hlmH4 = 'scroll-m-20 text-xl font-semibold tracking-tight';

@Directive({
	selector: '[hlmH4]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmH4Directive {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(hlmH4, this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/src/lib/hlm-large.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export const hlmLarge = 'text-lg font-semibold';

@Directive({
	selector: '[hlmLarge]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmLargeDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(hlmLarge, this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/src/lib/hlm-lead.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export const hlmLead = 'text-xl text-muted-foreground';

@Directive({
	selector: '[hlmLead]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmLeadDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(hlmLead, this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/src/lib/hlm-muted.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export const hlmMuted = 'text-sm text-muted-foreground';

@Directive({
	selector: '[hlmMuted]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmMutedDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(hlmMuted, this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/src/lib/hlm-p.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export const hlmP = 'leading-7 [&:not(:first-child)]:mt-6';

@Directive({
	selector: '[hlmP]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmPDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(hlmP, this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/src/lib/hlm-small.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export const hlmSmall = 'text-sm font-medium leading-none';

@Directive({
	selector: '[hlmSmall]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSmallDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(hlmSmall, this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/typography/helm/src/lib/hlm-ul.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

export const hlmUl = 'my-6 ml-6 list-disc [&>li]:mt-2';

@Directive({
	selector: '[hlmUl]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmUlDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(hlmUl, this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/aspect-ratio.stories.ts
```typescript
import type { Meta, StoryObj } from '@storybook/angular';
import { moduleMetadata } from '@storybook/angular';
import { HlmAspectRatioDirective } from './helm/src';

export type AspectRatio = { ratio: string | number };
const meta: Meta<AspectRatio> = {
	title: 'Aspect Ratio',
	component: HlmAspectRatioDirective,
	tags: ['autodocs'],
	args: { ratio: '16/9' },
	argTypes: {
		ratio: {
			options: ['16/9', '1/1', '5/4', '3/2', 1.234],
			control: {
				type: 'select',
			},
		},
	},
	decorators: [
		moduleMetadata({
			imports: [HlmAspectRatioDirective],
		}),
	],
};

export default meta;
type Story = StoryObj<AspectRatio>;

export const Default: Story = {
	args: {
		ratio: '16/9',
	},
	render: ({ ratio }) => ({
		props: {
			ratio,
		},
		template: `
      <div class='max-w-xl overflow-hidden rounded-xl drop-shadow'>
        <div [hlmAspectRatio]='ratio'>
          <img
            alt='Mountain views'
            src='/mountains.jpg'
          />
        </div>
      </div>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/helm/README.md
```
# ui-aspect-ratio-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-aspect-ratio-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-aspect-ratio-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/aspect-ratio/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/helm/package.json
```json
{
	"name": "@spartan-ng/ui-aspectratio-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/cdk": ">=19.0.0",
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/helm/project.json
```json
{
	"name": "ui-aspect-ratio-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/aspect-ratio/helm/src",
	"prefix": "hlm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/aspect-ratio/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/aspect-ratio/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/aspect-ratio/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/aspect-ratio/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-aspect-ratio-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmAspectRatioDirective } from './lib/helm-aspect-ratio.directive';

export * from './lib/helm-aspect-ratio.directive';

@NgModule({
	imports: [HlmAspectRatioDirective],
	exports: [HlmAspectRatioDirective],
})
export class HlmAspectRatioModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/helm/src/lib/helm-aspect-ratio.directive.spec.ts
```typescript
import { Component } from '@angular/core';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { HlmAspectRatioDirective } from './helm-aspect-ratio.directive';

@Component({
	selector: 'hlm-mock',
	standalone: true,
	imports: [HlmAspectRatioDirective],
	template: `
		<div [hlmAspectRatio]="ratio">
			<img
				alt="Sample image"
				src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII="
			/>
		</div>
	`,
})
class MockComponent {
	public ratio: number | undefined = 16 / 9;
}

describe('HelmAspectRatioDirective', () => {
	let component: MockComponent;
	let fixture: ComponentFixture<MockComponent>;

	beforeEach(() => {
		fixture = TestBed.createComponent(MockComponent);
		component = fixture.componentInstance;
	});

	it('should compile', () => {
		expect(component).toBeTruthy();
	});

	it('should show the image', () => {
		fixture.detectChanges();
		const img = fixture.nativeElement.querySelector('img');
		expect(img).toBeTruthy();
	});

	it('should have the correct aspect ratio', () => {
		fixture.detectChanges();
		const div = fixture.nativeElement.querySelector('div');
		expect(div.style.paddingBottom).toEqual(`${100 / (component.ratio || 1)}%`);
	});

	it('should default to an aspect ratio of 1', () => {
		component.ratio = undefined;
		fixture.detectChanges();
		const div = fixture.nativeElement.querySelector('div');
		expect(div.style.paddingBottom).toEqual('100%');
	});

	it('should fallback to an aspect ratio of 1 if the ratio is 0', () => {
		component.ratio = 0;
		fixture.detectChanges();
		const div = fixture.nativeElement.querySelector('div');
		expect(div.style.paddingBottom).toEqual('100%');
	});

	it('should fallback to an aspect ratio of 1 if the ratio is negative', () => {
		component.ratio = -1;
		fixture.detectChanges();
		const div = fixture.nativeElement.querySelector('div');
		expect(div.style.paddingBottom).toEqual('100%');
	});

	it('should add the correct styles to the image', () => {
		fixture.detectChanges();

		const img = fixture.nativeElement.querySelector('img') as HTMLImageElement;
		expect(img.classList.toString()).toBe('absolute w-full h-full object-cover');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/aspect-ratio/helm/src/lib/helm-aspect-ratio.directive.ts
```typescript
import { type NumberInput, coerceNumberProperty } from '@angular/cdk/coercion';
import { type AfterViewInit, Directive, ElementRef, computed, inject, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

const parseDividedString = (value: NumberInput): NumberInput => {
	if (typeof value !== 'string' || !value.includes('/')) return value;
	return value
		.split('/')
		.map((v) => Number.parseInt(v, 10))
		.reduce((a, b) => a / b);
};

@Directive({
	selector: '[hlmAspectRatio]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		'[style.padding-bottom]': '_computedPaddingBottom()',
	},
})
export class HlmAspectRatioDirective implements AfterViewInit {
	private readonly _el = inject<ElementRef<HTMLElement>>(ElementRef).nativeElement;

	public readonly ratio = input(1, {
		alias: 'hlmAspectRatio',
		transform: (value: NumberInput) => {
			const coerced = coerceNumberProperty(parseDividedString(value));
			return coerced <= 0 ? 1 : coerced;
		},
	});
	protected readonly _computedPaddingBottom = computed(() => `${100 / this.ratio()}%`);

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm('relative w-full', this.userClass()));

	ngAfterViewInit() {
		// support delayed addition of image to dom
		const child = this._el.firstElementChild;
		if (child) {
			child.classList.add('absolute', 'w-full', 'h-full', 'object-cover');
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/switch/switch.stories.ts
```typescript
import type { Meta, StoryObj } from '@storybook/angular';
import { argsToTemplate, moduleMetadata } from '@storybook/angular';

import { FormsModule } from '@angular/forms';
import { BrnSwitchComponent, BrnSwitchImports } from '@spartan-ng/brain/switch';
import { HlmLabelDirective } from '../label/helm/src';
import { HlmSwitchImports } from './helm/src';
import { SwitchFormComponent } from './helm/src/lib/hlm-switch-ng-model.component.ignore.spec';

const meta: Meta<BrnSwitchComponent> = {
	title: 'Switch',
	component: BrnSwitchComponent,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [BrnSwitchImports, HlmSwitchImports, HlmLabelDirective, SwitchFormComponent, FormsModule],
		}),
	],
};

export default meta;
type Story = StoryObj<BrnSwitchComponent>;

export const Default: Story = {
	render: () => ({
		template: `
       <hlm-switch id='testSwitchDefault' aria-label='test switch' />
    `,
	}),
};

export const InsideLabel: Story = {
	render: () => ({
		template: `
      <label class='flex items-center' hlmLabel> Test Switch
        <hlm-switch class='ml-2' id='testSwitchInsideLabel' />
      </label>
    `,
	}),
};

export const LabeledWithAriaLabeledBy: Story = {
	render: () => ({
		template: `
      <div class='flex items-center'>
        <label id='testSwitchLabel' for='testSwitchLabeledWithAria' hlmLabel> Test Switch </label>
        <hlm-switch class='ml-2' id='testSwitchLabeledWithAria' aria-labelledby='testSwitchLabel' />
      </div>
    `,
	}),
};

export const Disabled: Story = {
	render: () => ({
		template: `
      <div class='flex items-center'>
         <label id='testSwitchLabel' for='testSwitchDisabled' hlmLabel> Disabled Switch </label>
       <hlm-switch  disabled="true" class='ml-2' id='testSwitchDisabled' aria-labelledby='testSwitchLabel' />
      </div>
    `,
	}),
};

type FormStory = StoryObj<SwitchFormComponent>;
export const Form: FormStory = {
	render: () => ({
		template: `
    <hlm-switch-ng-model />
    `,
	}),
};

export const FormTrue: FormStory = {
	args: {
		switchValue: true,
	},
	render: ({ ...args }) => ({
		props: args,
		template: `
    <hlm-switch-ng-model  ${argsToTemplate(args)} />
    `,
	}),
};

```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/radio-group.stories.ts
```typescript
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { NgIcon } from '@ng-icons/core';
import { BrnRadioGroupDirective } from '@spartan-ng/brain/radio-group';
import { type Meta, type StoryObj, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmCodeDirective, HlmSmallDirective } from '../typography/helm/src';
import { HlmRadioGroupImports } from './helm/src';

@Component({
	selector: 'radio-group-example',
	standalone: true,
	imports: [
		HlmRadioGroupImports,
		FormsModule,
		NgIcon,
		HlmIconDirective,
		HlmButtonDirective,
		HlmCodeDirective,
		HlmSmallDirective,
	],
	template: `
		<small hlmSmall class="font-semibold">Choose a version</small>
		<hlm-radio-group class="font-mono text-sm font-medium" [(ngModel)]="version">
			<hlm-radio value="16.1.4">
				<hlm-radio-indicator indicator />
				v16.1.4
			</hlm-radio>
			<hlm-radio value="16.0.0">
				<hlm-radio-indicator indicator />
				v16.0.0
			</hlm-radio>
			<hlm-radio value="15.8.0">
				<hlm-radio-indicator indicator />
				v15.8.0
			</hlm-radio>
			<hlm-radio disabled value="15.2.0">
				<hlm-radio-indicator indicator />
				v15.2.0
			</hlm-radio>
		</hlm-radio-group>
		<div class="my-2 flex space-x-2">
			<button size="sm" hlmBtn variant="outline" (click)="version = '16.0.0'">Set to v16.0.0</button>
			<button size="sm" hlmBtn variant="outline" (click)="version = null">Reset</button>
		</div>
		<small hlmSmall class="mt-6 block font-semibold">
			Current Version:
			<code data-testid="currentVersion" hlmCode class="text-xs">{{ version ?? 'none' }}</code>
		</small>
	`,
})
class RadioGroupExampleComponent {
	version: string | null = '16.1.4';
}

const meta: Meta<BrnRadioGroupDirective> = {
	title: 'Radio Group',
	component: BrnRadioGroupDirective,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [RadioGroupExampleComponent],
			providers: [],
		}),
	],
};

export default meta;
type Story = StoryObj<BrnRadioGroupDirective>;

export const Default: Story = {
	render: () => ({
		template: '<radio-group-example/>',
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/README.md
```
# ui-radio-group-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-radio-group-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/eslint.config.js
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
			'@angular-eslint/no-output-rename': 'off',
			'@angular-eslint/no-output-native': 'off',
		},
	},
	{
		files: ['**/*.html'],
		// Override or add rules here
		rules: {},
	},
];

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-radio-group-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/radio-group/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/package.json
```json
{
	"name": "@spartan-ng/ui-radiogroup-helm",
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/project.json
```json
{
	"name": "ui-radio-group-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/radio-group/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/radio-group/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/radio-group/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/radio-group/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/radio-group/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-radio-group-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmRadioGroupComponent } from './lib/hlm-radio-group.component';
import { HlmRadioIndicatorComponent } from './lib/hlm-radio-indicator.component';
import { HlmRadioComponent } from './lib/hlm-radio.component';

export * from './lib/hlm-radio-group.component';
export * from './lib/hlm-radio-indicator.component';
export * from './lib/hlm-radio.component';

export const HlmRadioGroupImports = [HlmRadioGroupComponent, HlmRadioComponent, HlmRadioIndicatorComponent];

@NgModule({
	imports: [...HlmRadioGroupImports],
	exports: [...HlmRadioGroupImports],
})
export class HlmRadioGroupModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/src/lib/hlm-radio-group.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnRadioGroupDirective } from '@spartan-ng/brain/radio-group';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-radio-group',
	standalone: true,
	hostDirectives: [
		{
			directive: BrnRadioGroupDirective,
			inputs: ['name', 'value', 'disabled', 'required', 'direction'],
		},
	],
	host: {
		'[class]': '_computedClass()',
	},
	template: '<ng-content />',
})
export class HlmRadioGroupComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('grid gap-2', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/src/lib/hlm-radio-indicator.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

const btnLike =
	'aspect-square rounded-full ring-offset-background group-[.cdk-keyboard-focused]:ring-2 group-[.cdk-keyboard-focused]:ring-ring group-[.cdk-keyboard-focused]:ring-offset-2 group-[.brn-radio-disabled]:cursor-not-allowed group-[.brn-radio-disabled]:opacity-50';

@Component({
	selector: 'hlm-radio-indicator',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	template: `
		<div
			class="bg-foreground absolute inset-0 hidden scale-[55%] rounded-full group-[.brn-radio-checked]:inline-block"
		></div>
		<div class="border-primary ${btnLike} rounded-full border"></div>
	`,
})
export class HlmRadioIndicatorComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('relative inline-flex h-4 w-4', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/radio-group/helm/src/lib/hlm-radio.component.ts
```typescript
import { booleanAttribute, Component, computed, input, output } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnRadioChange, BrnRadioComponent } from '@spartan-ng/brain/radio-group';
import { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-radio',
	imports: [BrnRadioComponent],
	template: `
		<brn-radio
			[id]="id()"
			[class]="_computedClass()"
			[value]="value()"
			[required]="required()"
			[disabled]="disabled()"
			[aria-label]="ariaLabel()"
			[aria-labelledby]="ariaLabelledby()"
			[aria-describedby]="ariaDescribedby()"
			(change)="change.emit($event)"
		>
			<ng-content select="[target],[indicator]" indicator />
			<ng-content />
		</brn-radio>
	`,
})
export class HlmRadioComponent<T = unknown> {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'group [&.brn-radio-disabled]:text-muted-foreground flex items-center space-x-2 rtl:space-x-reverse',
			this.userClass(),
		),
	);

	/** Used to set the id on the underlying brn element. */
	public readonly id = input<string | undefined>(undefined);

	/** Used to set the aria-label attribute on the underlying brn element. */
	public readonly ariaLabel = input<string | undefined>(undefined, { alias: 'aria-label' });

	/** Used to set the aria-labelledby attribute on the underlying brn element. */
	public readonly ariaLabelledby = input<string | undefined>(undefined, { alias: 'aria-labelledby' });

	/** Used to set the aria-describedby attribute on the underlying brn element. */
	public readonly ariaDescribedby = input<string | undefined>(undefined, { alias: 'aria-describedby' });

	/**
	 * The value this radio button represents.
	 */
	public readonly value = input.required<T>();

	/** Whether the checkbox is required. */
	public readonly required = input(false, { transform: booleanAttribute });

	/** Whether the checkbox is disabled. */
	public readonly disabled = input(false, { transform: booleanAttribute });

	/**
	 * Event emitted when the checked state of this radio button changes.
	 */
	public readonly change = output<BrnRadioChange<T>>();
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/select.stories.ts
```typescript
import { CommonModule } from '@angular/common';
import {
	ChangeDetectionStrategy,
	Component,
	OnInit,
	ViewEncapsulation,
	computed,
	contentChild,
	input,
	signal,
} from '@angular/core';
import { FormControl, FormGroup, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronDown } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { BrnSelectImports, BrnSelectTriggerDirective } from '@spartan-ng/brain/select';
import { HlmButtonDirective } from '@spartan-ng/ui-button-helm';
import { HlmLabelDirective } from '@spartan-ng/ui-label-helm';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import type { ClassValue } from 'clsx';
import { HlmIconDirective } from '../icon/helm/src';
import { HlmSelectImports } from './helm/src';

interface BrnSelectStoryArgs {
	initialValue: string | string[];
	disabled: boolean;
	placeholder: string;
	multiple: boolean;
	dir: 'ltr' | 'rtl';
	selectValueTransformFn: (values: (string | undefined)[]) => string;
}

const meta: Meta<BrnSelectStoryArgs> = {
	title: 'Select',
	args: {
		disabled: false,
		placeholder: 'Select an option',
		multiple: false,
		initialValue: '',
		dir: 'ltr',
	},
	argTypes: {
		dir: { control: 'radio', options: ['ltr', 'rtl'] },
		selectValueTransformFn: { type: 'function', control: false },
	},
	decorators: [
		moduleMetadata({
			imports: [CommonModule, FormsModule, ReactiveFormsModule, BrnSelectImports, HlmSelectImports, HlmLabelDirective],
		}),
	],
};

export default meta;
type Story = StoryObj<BrnSelectStoryArgs>;

export const Default: Story = {
	render: (args) => ({
		props: { ...args },
		template: /* HTML */ `
			<hlm-select class="inline-block" ${argsToTemplate(args, { exclude: ['initialValue', 'selectValueTransformFn'] })}>
				<hlm-select-trigger class="w-56">
					<hlm-select-value />
				</hlm-select-trigger>
				<hlm-select-content>
					<hlm-select-label>Fruits</hlm-select-label>
					<hlm-option value="apple">Apple</hlm-option>
					<hlm-option value="banana">Banana</hlm-option>
					<hlm-option value="blueberry">Blueberry</hlm-option>
					<hlm-option value="grapes">Grapes</hlm-option>
					<hlm-option value="pineapple">Pineapple</hlm-option>
				</hlm-select-content>
			</hlm-select>
		`,
	}),
};

export const ReactiveFormControl: Story = {
	render: (args) => ({
		props: { ...args, fruitGroup: new FormGroup({ fruit: new FormControl(args.initialValue) }) },
		template: /* HTML */ `
			<div class="mb-3">
				<pre>Form Control Value: {{ fruitGroup.controls.fruit.value | json }}</pre>
			</div>
			<form [formGroup]="fruitGroup">
				<brn-select
					class="w-56"
					${argsToTemplate(args, { exclude: ['initialValue', 'selectValueTransformFn'] })}
					formControlName="fruit"
				>
					<hlm-select-trigger>
						<brn-select-value hlm />
					</hlm-select-trigger>
					<hlm-select-content>
						<hlm-select-label>Fruits</hlm-select-label>
						<hlm-option value="apple">Apple</hlm-option>
						<hlm-option value="banana">Banana</hlm-option>
						<hlm-option value="blueberry">Blueberry</hlm-option>
						<hlm-option value="grapes">Grapes</hlm-option>
						<hlm-option value="pineapple">Pineapple</hlm-option>
						<hlm-option>Clear</hlm-option>
					</hlm-select-content>
				</brn-select>
			</form>
		`,
	}),
};

export const DisabledOption: Story = {
	render: (args) => ({
		props: { ...args, fruitGroup: new FormGroup({ fruit: new FormControl(args.initialValue) }) },
		template: /* HTML */ `
			<div class="mb-3">
				<pre>Form Control Value: {{ fruitGroup.controls.fruit.value | json }}</pre>
			</div>
			<form [formGroup]="fruitGroup">
				<brn-select
					class="w-56"
					${argsToTemplate(args, { exclude: ['initialValue', 'selectValueTransformFn'] })}
					formControlName="fruit"
				>
					<hlm-select-trigger>
						<brn-select-value hlm />
					</hlm-select-trigger>
					<hlm-select-content>
						<hlm-select-label>Fruits</hlm-select-label>
						<hlm-option value="apple">Apple</hlm-option>
						<hlm-option data-testid="banana-option" value="banana" disabled>Banana</hlm-option>
						<hlm-option value="blueberry">Blueberry</hlm-option>
						<hlm-option value="grapes">Grapes</hlm-option>
						<hlm-option value="pineapple">Pineapple</hlm-option>
						<hlm-option>Clear</hlm-option>
					</hlm-select-content>
				</brn-select>
			</form>
		`,
	}),
};

export const SelectValueTransformFn: Story = {
	render: (args) => ({
		props: {
			...args,
			fruitGroup: new FormGroup({ fruit: new FormControl(args.initialValue) }),
			selectValueTransformFn: (values: (string | undefined)[]) => {
				return values.join(' | ');
			},
			multiple: true,
		},
		template: /* HTML */ `
			<div class="mb-3" (onClick)="console.log('CLICKED')">
				<pre>Form Control Value: {{ fruitGroup.controls.fruit.value | json }}</pre>
			</div>
			<form [formGroup]="fruitGroup">
				<brn-select
					class="w-56"
					${argsToTemplate(args, { exclude: ['initialValue', 'selectValueTransformFn'] })}
					formControlName="fruit"
				>
					<hlm-select-trigger>
						<brn-select-value hlm [transformFn]="selectValueTransformFn" />
					</hlm-select-trigger>
					<hlm-select-content>
						<hlm-select-label>Fruits</hlm-select-label>
						<hlm-option value="apple">Apple</hlm-option>
						<hlm-option data-testid="banana-option" value="banana" disabled>Banana</hlm-option>
						<hlm-option value="blueberry">Blueberry</hlm-option>
						<hlm-option value="grapes">Grapes</hlm-option>
						<hlm-option value="pineapple">Pineapple</hlm-option>
						<hlm-option>Clear</hlm-option>
					</hlm-select-content>
				</brn-select>
			</form>
		`,
	}),
};

export const ReactiveFormControlWithForAndInitialValue: Story = {
	args: {
		initialValue: 'apple',
	},
	render: (args) => ({
		props: {
			...args,
			fruitGroup: new FormGroup({
				fruit: new FormControl(args.initialValue || null, { validators: Validators.required }),
			}),
			options: [
				{ value: 'apple', label: 'Apple' },
				{ value: 'banana', label: 'Banana' },
				{ value: 'blueberry', label: 'Blueberry' },
				{ value: 'grapes', label: 'Grapes' },
				{ value: 'pineapple', label: 'Pineapple' },
			],
		},
		template: /* HTML */ `
			<div class="mb-3">
				<pre>Form Control Value: {{ fruitGroup.controls.fruit.value | json }}</pre>
			</div>
			<form [formGroup]="fruitGroup">
				<brn-select
					class="w-56"
					${argsToTemplate(args, { exclude: ['initialValue', 'selectValueTransformFn'] })}
					formControlName="fruit"
				>
					<hlm-select-trigger>
						<brn-select-value hlm />
					</hlm-select-trigger>
					<hlm-select-content>
						<hlm-select-label>Fruits</hlm-select-label>
						@for(option of options; track option.value){
						<hlm-option [value]="option.value">{{option.label}}</hlm-option>
						}
					</hlm-select-content>
				</brn-select>
				@if (fruitGroup.controls.fruit.invalid && fruitGroup.controls.fruit.touched){
				<span class="text-destructive">Required</span>
				}
			</form>
		`,
	}),
};

const appleAndBlueberry = new FormGroup({
	fruit: new FormControl(['apple', 'blueberry'], { validators: Validators.required }),
});
export const ReactiveFormControlWithForAndInitialValueAndMultiple: StoryObj<
	BrnSelectStoryArgs & { options: { value: string; label: string }[]; initialFormValue: FormGroup }
> = {
	args: {
		placeholder: 'Select multiple options',
		initialFormValue: appleAndBlueberry,
		options: [
			{ value: 'apple', label: 'Apple' },
			{ value: 'banana', label: 'Banana' },
			{ value: 'blueberry', label: 'Blueberry' },
			{ value: 'grapes', label: 'Grapes' },
			{ value: 'pineapple', label: 'Pineapple' },
		],
		multiple: true,
	},
	argTypes: {
		initialFormValue: {
			options: ['Apple', 'Apple & Blueberry', 'All'],
			mapping: {
				Apple: new FormGroup({
					fruit: new FormControl(['apple'], { validators: Validators.required }),
				}),
				'Apple & Blueberry': new FormGroup({
					fruit: new FormControl(['apple', 'blueberry'], {
						validators: Validators.required,
					}),
				}),
				All: new FormGroup({
					fruit: new FormControl(['apple', 'banana', 'blueberry', 'grapes', 'pineapple'], {
						validators: Validators.required,
					}),
				}),
			},
		},
		options: {
			control: 'inline-check',
			options: ['Apple', 'Banana', 'Blueberry', 'Grapes', 'Pineapple'],
			mapping: {
				Apple: { value: 'apple', label: 'Apple' },
				Banana: { value: 'banana', label: 'Banana' },
				Blueberry: { value: 'blueberry', label: 'Blueberry' },
				Grapes: { value: 'grapes', label: 'Grapes' },
				Pineapple: { value: 'pineapple', label: 'Pineapple' },
			},
		},
	},
	render: (args) => ({
		props: {
			...args,
		},
		template: /* HTML */ `
			<div class="mb-3">
				<pre>Form Control Value: {{ initialFormValue?.controls.fruit.value | json }}</pre>
			</div>
			<form [formGroup]="initialFormValue">
				<brn-select
					class="w-56"
					${argsToTemplate(args, { exclude: ['initialValue', 'options'] })}
					formControlName="fruit"
				>
					<hlm-select-trigger>
						<brn-select-value hlm />
					</hlm-select-trigger>
					<hlm-select-content>
						<hlm-select-label>Fruits</hlm-select-label>
						@for(option of options; track option.value){
						<hlm-option [value]="option.value">{{option.label}}</hlm-option>
						}
					</hlm-select-content>
				</brn-select>
				@if (fruitGroup?.controls.fruit.invalid && fruitGroup.controls.fruit.touched){
				<span class="text-destructive">Required</span>
				}
			</form>
		`,
	}),
};

export const ReactiveFormControlWithValidation: Story = {
	render: (args) => ({
		props: {
			...args,
			fruitGroup: new FormGroup({
				fruit: new FormControl(args.initialValue || null, { validators: Validators.required }),
			}),
		},
		template: /* HTML */ `
			<div class="mb-3">
				<pre>Form Control Value: {{ fruitGroup.controls.fruit.valueChanges | async | json }}</pre>
			</div>
			<form [formGroup]="fruitGroup">
				<brn-select
					class="w-56"
					formControlName="fruit"
					${argsToTemplate(args, { exclude: ['initialValue', 'selectValueTransformFn'] })}
				>
					<hlm-select-trigger>
						<brn-select-value hlm />
					</hlm-select-trigger>
					<hlm-select-content>
						<hlm-select-label>Fruits</hlm-select-label>
						<hlm-option value="apple">Apple</hlm-option>
						<hlm-option value="banana">Banana</hlm-option>
						<hlm-option value="blueberry">Blueberry</hlm-option>
						<hlm-option value="grapes">Grapes</hlm-option>
						<hlm-option value="pineapple">Pineapple</hlm-option>
						<hlm-option>Clear</hlm-option>
					</hlm-select-content>
				</brn-select>
				@if (fruitGroup.controls.fruit.invalid && fruitGroup.controls.fruit.touched){
				<span class="text-destructive">Required</span>
				}
			</form>
		`,
	}),
};

export const ReactiveFormControlWithValidationWithLabel: Story = {
	render: (args) => ({
		props: {
			...args,
			fruitGroup: new FormGroup({
				fruit: new FormControl(args.initialValue || null, { validators: Validators.required }),
			}),
		},
		template: /* HTML */ `
			<div class="mb-3">
				<pre>Form Control Value: {{ fruitGroup.controls.fruit.valueChanges | async | json }}</pre>
			</div>
			<form [formGroup]="fruitGroup">
				<hlm-select
					class="w-56"
					formControlName="fruit"
					${argsToTemplate(args, { exclude: ['initialValue', 'selectValueTransformFn'] })}
				>
					<label hlmLabel>Select a Fruit</label>
					<hlm-select-trigger>
						<brn-select-value hlm />
					</hlm-select-trigger>
					<hlm-select-content>
						<hlm-select-label>Fruits</hlm-select-label>
						<hlm-option value="apple">Apple</hlm-option>
						<hlm-option value="banana">Banana</hlm-option>
						<hlm-option value="blueberry">Blueberry</hlm-option>
						<hlm-option value="grapes">Grapes</hlm-option>
						<hlm-option value="pineapple">Pineapple</hlm-option>
						<hlm-option>Clear</hlm-option>
					</hlm-select-content>
				</hlm-select>
				@if (fruitGroup.controls.fruit.invalid && fruitGroup.controls.fruit.touched){
				<span class="text-destructive">Required</span>
				}
			</form>
		`,
	}),
};

export const NgModelFormControl: Story = {
	render: (args) => ({
		props: {
			...args,
			fruit: signal(args.initialValue),
		},
		template: /* HTML */ `
			<form ngForm>
				<div class="mb-3">
					<pre>Form Control Value: {{fruit() | json }}</pre>
				</div>
				<hlm-select
					class="w-56"
					${argsToTemplate(args, { exclude: ['initialValue', 'selectValueTransformFn'] })}
					[(ngModel)]="fruit"
					name="fruit"
				>
					<label hlmLabel>Select a Fruit</label>
					<hlm-select-trigger>
						<brn-select-value hlm />
					</hlm-select-trigger>
					<hlm-select-content>
						<hlm-select-label>Fruits</hlm-select-label>
						<hlm-option value="apple">Apple</hlm-option>
						<hlm-option value="banana">Banana</hlm-option>
						<hlm-option value="blueberry">Blueberry</hlm-option>
						<hlm-option value="grapes">Grapes</hlm-option>
						<hlm-option value="pineapple">Pineapple</hlm-option>
					</hlm-select-content>
				</hlm-select>
			</form>
		`,
	}),
};

export const NgModelFormControlInitialValue: Story = {
	args: {
		disabled: false,
		placeholder: 'Select an option',
		multiple: false,
		initialValue: 'apple',
		dir: 'ltr',
	},

	render: (args) => ({
		props: {
			...args,
			fruit: signal(args.initialValue),
		},

		template: `
            <form ngForm>
                <div class="mb-3">
                    <pre>Form Control Value: {{fruit() | json }}</pre>
                </div>
                <hlm-select
                    class="w-56"
                    ${argsToTemplate(args, {
											exclude: ['initialValue', 'selectValueTransformFn'],
										})}
                    [(ngModel)]="fruit"
                    name="fruit"
                >
                    <label hlmLabel>Select a Fruit</label>
                    <hlm-select-trigger>
                        <brn-select-value hlm />
                    </hlm-select-trigger>
                    <hlm-select-content>
                        <hlm-select-label>Fruits</hlm-select-label>
                        <hlm-option value="apple">Apple</hlm-option>
                        <hlm-option value="banana">Banana</hlm-option>
                        <hlm-option value="blueberry">Blueberry</hlm-option>
                        <hlm-option value="grapes">Grapes</hlm-option>
                        <hlm-option value="pineapple">Pineapple</hlm-option>
                    </hlm-select-content>
                </hlm-select>
            </form>
        `,
	}),
};

export const SelectWithLabel: Story = {
	render: (args) => ({
		props: { ...args, fruitGroup: new FormGroup({ fruit: new FormControl() }) },
		template: /* HTML */ `
			<form [formGroup]="fruitGroup">
				<hlm-select
					formControlName="fruit"
					${argsToTemplate(args, { exclude: ['initialValue', 'selectValueTransformFn'] })}
				>
					<label hlmLabel>Select a Fruit</label>
					<hlm-select-trigger class="w-56">
						<brn-select-value />
					</hlm-select-trigger>
					<hlm-select-content class="w-56">
						<hlm-select-label>Fruits</hlm-select-label>
						<hlm-option value="apple">Apple</hlm-option>
						<hlm-option value="banana">Banana</hlm-option>
						<hlm-option value="blueberry">Blueberry</hlm-option>
						<hlm-option value="grapes">Grapes</hlm-option>
						<hlm-option value="pineapple">Pineapple</hlm-option>
					</hlm-select-content>
				</hlm-select>
			</form>
		`,
	}),
};

export const Scrollable: Story = {
	render: (args) => ({
		props: { ...args, myform: new FormGroup({ timezone: new FormControl() }) },
		template: /* HTML */ `
			<form [formGroup]="myform">
				<hlm-select
					formControlName="timezone"
					${argsToTemplate(args, { exclude: ['initialValue', 'selectValueTransformFn'] })}
				>
					<hlm-select-trigger class="w-[280px]">
						<hlm-select-value />
					</hlm-select-trigger>
					<hlm-select-content class="min-w-content max-h-96">
						<hlm-select-scroll-up />

						<hlm-select-group>
							<hlm-select-label>North America</hlm-select-label>
							<hlm-option value="est">Eastern Standard Time (EST)</hlm-option>
							<hlm-option value="cst">Central Standard Time (CST)</hlm-option>
							<hlm-option value="mst">Mountain Standard Time (MST)</hlm-option>
							<hlm-option value="pst">Pacific Standard Time (PST)</hlm-option>
							<hlm-option value="akst">Alaska Standard Time (AKST)</hlm-option>
							<hlm-option value="hst">Hawaii Standard Time (HST)</hlm-option>
						</hlm-select-group>

						<hlm-select-group>
							<hlm-select-label>Europe & Africa</hlm-select-label>
							<hlm-option value="gmt">Greenwich Mean Time (GMT)</hlm-option>
							<hlm-option value="cet">Central European Time (CET)</hlm-option>
							<hlm-option value="eet">Eastern European Time (EET)</hlm-option>
							<hlm-option value="west">Western European Summer Time (WEST)</hlm-option>
							<hlm-option value="cat">Central Africa Time (CAT)</hlm-option>
							<hlm-option value="eat">East Africa Time (EAT)</hlm-option>
						</hlm-select-group>

						<hlm-select-group>
							<hlm-select-label>Asia</hlm-select-label>
							<hlm-option value="msk">Moscow Time (MSK)</hlm-option>
							<hlm-option value="ist">India Standard Time (IST)</hlm-option>
							<hlm-option value="cst_china">China Standard Time (CST)</hlm-option>
							<hlm-option value="jst">Japan Standard Time (JST)</hlm-option>
							<hlm-option value="kst">Korea Standard Time (KST)</hlm-option>
							<hlm-option value="ist_indonesia">Indonesia Central Standard Time (WITA)</hlm-option>
						</hlm-select-group>

						<hlm-select-group>
							<hlm-select-label>Australia & Pacific</hlm-select-label>
							<hlm-option value="awst">Australian Western Standard Time (AWST)</hlm-option>
							<hlm-option value="acst">Australian Central Standard Time (ACST)</hlm-option>
							<hlm-option value="aest">Australian Eastern Standard Time (AEST)</hlm-option>
							<hlm-option value="nzst">New Zealand Standard Time (NZST)</hlm-option>
							<hlm-option value="fjt">Fiji Time (FJT)</hlm-option>
						</hlm-select-group>

						<hlm-select-group>
							<hlm-select-label>South America</hlm-select-label>
							<hlm-option value="art">Argentina Time (ART)</hlm-option>
							<hlm-option value="bot">Bolivia Time (BOT)</hlm-option>
							<hlm-option value="brt">Brasilia Time (BRT)</hlm-option>
							<hlm-option value="clt">Chile Standard Time (CLT)</hlm-option>
						</hlm-select-group>

						<hlm-select-scroll-down />
					</hlm-select-content>
				</hlm-select>
			</form>
		`,
	}),
};

export const ScrollableWithStickyLabels: Story = {
	render: (args) => ({
		props: { ...args, myform: new FormGroup({ timezone: new FormControl() }) },
		template: /* HTML */ `
			<form [formGroup]="myform">
				<hlm-select
					formControlName="timezone"
					${argsToTemplate(args, { exclude: ['initialValue', 'selectValueTransformFn'] })}
				>
					<hlm-select-trigger class="w-[280px]">
						<hlm-select-value />
					</hlm-select-trigger>
					<hlm-select-content class="max-h-96" [stickyLabels]="true">
						<hlm-select-scroll-up />

						<hlm-select-group>
							<hlm-select-label>North America</hlm-select-label>
							<hlm-option value="est">Eastern Standard Time (EST)</hlm-option>
							<hlm-option value="cst">Central Standard Time (CST)</hlm-option>
							<hlm-option value="mst">Mountain Standard Time (MST)</hlm-option>
							<hlm-option value="pst">Pacific Standard Time (PST)</hlm-option>
							<hlm-option value="akst">Alaska Standard Time (AKST)</hlm-option>
							<hlm-option value="hst">Hawaii Standard Time (HST)</hlm-option>
						</hlm-select-group>

						<hlm-select-group>
							<hlm-select-label>Europe & Africa</hlm-select-label>
							<hlm-option value="gmt">Greenwich Mean Time (GMT)</hlm-option>
							<hlm-option value="cet">Central European Time (CET)</hlm-option>
							<hlm-option value="eet">Eastern European Time (EET)</hlm-option>
							<hlm-option value="west">Western European Summer Time (WEST)</hlm-option>
							<hlm-option value="cat">Central Africa Time (CAT)</hlm-option>
							<hlm-option value="eat">East Africa Time (EAT)</hlm-option>
						</hlm-select-group>

						<hlm-select-group>
							<hlm-select-label>Asia</hlm-select-label>
							<hlm-option value="msk">Moscow Time (MSK)</hlm-option>
							<hlm-option value="ist">India Standard Time (IST)</hlm-option>
							<hlm-option value="cst_china">China Standard Time (CST)</hlm-option>
							<hlm-option value="jst">Japan Standard Time (JST)</hlm-option>
							<hlm-option value="kst">Korea Standard Time (KST)</hlm-option>
							<hlm-option value="ist_indonesia">Indonesia Central Standard Time (WITA)</hlm-option>
						</hlm-select-group>

						<hlm-select-group>
							<hlm-select-label>Australia & Pacific</hlm-select-label>
							<hlm-option value="awst">Australian Western Standard Time (AWST)</hlm-option>
							<hlm-option value="acst">Australian Central Standard Time (ACST)</hlm-option>
							<hlm-option value="aest">Australian Eastern Standard Time (AEST)</hlm-option>
							<hlm-option value="nzst">New Zealand Standard Time (NZST)</hlm-option>
							<hlm-option value="fjt">Fiji Time (FJT)</hlm-option>
						</hlm-select-group>

						<hlm-select-group>
							<hlm-select-label>South America</hlm-select-label>
							<hlm-option value="art">Argentina Time (ART)</hlm-option>
							<hlm-option value="bot">Bolivia Time (BOT)</hlm-option>
							<hlm-option value="brt">Brasilia Time (BRT)</hlm-option>
							<hlm-option value="clt">Chile Standard Time (CLT)</hlm-option>
						</hlm-select-group>

						<hlm-select-scroll-down />
					</hlm-select-content>
				</hlm-select>
			</form>
		`,
	}),
};

export const CustomTrigger: Story = {
	render: (args) => ({
		props: { ...args },
		moduleMetadata: {
			imports: [CustomSelectTriggerComponent],
		},
		template: /* HTML */ `
			<hlm-select class="inline-block" ${argsToTemplate(args, { exclude: ['initialValue', 'selectValueTransformFn'] })}>
				<custom-select-trigger ngProjectAs="[brnSelectTrigger]" class="w-56">
					<hlm-select-value />
				</custom-select-trigger>
				<hlm-select-content>
					<hlm-select-label>Fruits</hlm-select-label>
					<hlm-option value="apple">Apple</hlm-option>
					<hlm-option value="banana">Banana</hlm-option>
					<hlm-option value="blueberry">Blueberry</hlm-option>
					<hlm-option value="grapes">Grapes</hlm-option>
					<hlm-option value="pineapple">Pineapple</hlm-option>
				</hlm-select-content>
			</hlm-select>
		`,
	}),
};

@Component({
	selector: 'custom-select-trigger',
	standalone: true,
	imports: [BrnSelectTriggerDirective, NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideChevronDown })],
	template: `
		<button [class]="_computedClass()" #button brnSelectTrigger type="button">
			<ng-content />
			@if (icon()) {
				<ng-content select="ng-icon" />
			} @else {
				<ng-icon hlm size="sm" class="ml-2 flex-none" name="lucideChevronDown" />
			}
		</button>
	`,
})
export class CustomSelectTriggerComponent {
	protected readonly icon = contentChild(HlmIconDirective);

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'!bg-sky-500 flex h-10 items-center justify-between rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 w-[180px]',
			this.userClass(),
		),
	);
}

export const WithLabelAndForm: Story = {
	render: () => ({
		moduleMetadata: {
			imports: [LabelAndFormComponent],
		},
		template: /* HTML */ '<label-and-form-component/>',
	}),
};
@Component({
	selector: 'label-and-form-component',
	standalone: true,
	encapsulation: ViewEncapsulation.None,
	changeDetection: ChangeDetectionStrategy.OnPush,
	imports: [
		FormsModule,
		ReactiveFormsModule,
		BrnSelectImports,
		HlmSelectImports,
		HlmLabelDirective,
		HlmButtonDirective,
	],
	providers: [],
	host: {
		class: '',
	},
	template: `
		<form class="space-y-5" (ngSubmit)="handleSubmit()">
			<label hlmLabel>
				Select a Fruit*
				<hlm-select class="w-56" [(ngModel)]="fruit" name="fruit" required>
					<hlm-select-trigger>
						<brn-select-value hlm />
					</hlm-select-trigger>
					<hlm-select-content>
						<hlm-select-label>Fruits</hlm-select-label>
						<hlm-option [value]="undefined">No fruit</hlm-option>
						<hlm-option value="apple">Apple</hlm-option>
						<hlm-option value="banana">Banana</hlm-option>
						<hlm-option value="blueberry">Blueberry</hlm-option>
						<hlm-option value="grapes">Grapes</hlm-option>
						<hlm-option value="pineapple">Pineapple</hlm-option>
					</hlm-select-content>
				</hlm-select>
			</label>
			<button hlmBtn>Submit</button>
		</form>
	`,
})
class LabelAndFormComponent {
	public fruit = signal<string | undefined>(undefined);

	public handleSubmit(): void {
		console.log(this.fruit());
	}
}

export const DynamicOptionsMultiSelect: Story = {
	render: () => ({
		moduleMetadata: {
			imports: [DynamicOptionsMultiSelectComponent],
		},
		template: /* HTML */ '<dynamic-options-multi-select-component/>',
	}),
};
@Component({
	selector: 'dynamic-options-multi-select-component',
	standalone: true,
	encapsulation: ViewEncapsulation.None,
	changeDetection: ChangeDetectionStrategy.OnPush,
	imports: [
		FormsModule,
		ReactiveFormsModule,
		BrnSelectImports,
		HlmSelectImports,
		HlmLabelDirective,
		HlmButtonDirective,
	],
	providers: [],
	host: {
		class: '',
	},
	template: `
		<form class="space-y-5">
			<div class="mb-3">
				<pre>Form Control Value: {{ fruit.value | json }}</pre>
			</div>
			<label hlmLabel>
				Select a Fruit*
				<hlm-select class="w-56" [formControl]="fruit" required [multiple]="true" placeholder="Select an option">
					<hlm-select-trigger>
						<hlm-select-value />
					</hlm-select-trigger>
					<hlm-select-content>
						<hlm-select-label>Fruits</hlm-select-label>
						@for (option of options(); track option.value) {
							<hlm-option [value]="option.value">{{ option.label }}</hlm-option>
						}
					</hlm-select-content>
				</hlm-select>
			</label>
		</form>
		<button hlmBtn class="mt-2" (click)="updateOptions()">Update Options</button>

		<button hlmBtn class="mt-2" (click)="updateDiffOptions()">Update Diff Options</button>

		<button hlmBtn class="mt-2" (click)="updatePartialOptions()">Update Partial Options</button>
	`,
})
class DynamicOptionsMultiSelectComponent implements OnInit {
	// Checking if an issue with having options as a signal
	public options = signal<{ value: number; label: string }[]>([]);
	fruit = new FormControl([1, 5]);

	ngOnInit(): void {
		this.options.set([
			{ label: 'Apple', value: 1 },
			{ label: 'Banana', value: 2 },
			{ label: 'Blueberry', value: 3 },
			{ label: 'Grapes', value: 4 },
			{ label: 'Pineapple', value: 5 },
		]);
	}

	public updateOptions() {
		// Reset same options
		this.options.set([
			{ label: 'Apple', value: 1 },
			{ label: 'Banana', value: 2 },
			{ label: 'Blueberry', value: 3 },
			{ label: 'Grapes', value: 4 },
			{ label: 'Pineapple', value: 5 },
		]);
	}

	public updateDiffOptions() {
		// Reset with different option values
		this.options.set([
			{ label: 'Apple', value: 6 },
			{ label: 'Banana', value: 7 },
			{ label: 'Blueberry', value: 8 },
			{ label: 'Grapes', value: 9 },
			{ label: 'Pineapple', value: 10 },
		]);
	}

	public updatePartialOptions() {
		// Reset with different option values
		this.options.set([
			{ label: 'Apple', value: 1 },
			{ label: 'Banana', value: 2 },
			{ label: 'Blueberry', value: 8 },
			{ label: 'Grapes', value: 9 },
			{ label: 'Pineapple', value: 10 },
		]);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/README.md
```
# ui-select-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-select-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-select-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/ui/select/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/select/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/package.json
```json
{
	"name": "@spartan-ng/ui-select-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@ng-icons/core": ">=29.0.0",
		"@ng-icons/lucide": ">=29.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/project.json
```json
{
	"name": "ui-select-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/select/helm/src",
	"prefix": "lib",
	"projectType": "library",
	"tags": [],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/select/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/select/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/select/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/select/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmSelectContentDirective } from './lib/hlm-select-content.directive';
import { HlmSelectGroupDirective } from './lib/hlm-select-group.directive';
import { HlmSelectLabelDirective } from './lib/hlm-select-label.directive';
import { HlmSelectOptionComponent } from './lib/hlm-select-option.component';
import { HlmSelectScrollDownComponent } from './lib/hlm-select-scroll-down.component';
import { HlmSelectScrollUpComponent } from './lib/hlm-select-scroll-up.component';
import { HlmSelectTriggerComponent } from './lib/hlm-select-trigger.component';
import { HlmSelectValueDirective } from './lib/hlm-select-value.directive';
import { HlmSelectDirective } from './lib/hlm-select.directive';

export * from './lib/hlm-select-content.directive';
export * from './lib/hlm-select-group.directive';
export * from './lib/hlm-select-label.directive';
export * from './lib/hlm-select-option.component';
export * from './lib/hlm-select-scroll-down.component';
export * from './lib/hlm-select-scroll-up.component';
export * from './lib/hlm-select-trigger.component';
export * from './lib/hlm-select-value.directive';
export * from './lib/hlm-select.directive';

export const HlmSelectImports = [
	HlmSelectContentDirective,
	HlmSelectTriggerComponent,
	HlmSelectOptionComponent,
	HlmSelectValueDirective,
	HlmSelectDirective,
	HlmSelectScrollUpComponent,
	HlmSelectScrollDownComponent,
	HlmSelectLabelDirective,
	HlmSelectGroupDirective,
] as const;

@NgModule({
	imports: [...HlmSelectImports],
	exports: [...HlmSelectImports],
})
export class HlmSelectModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-content.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm, injectExposedSideProvider, injectExposesStateProvider } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmSelectContent], hlm-select-content',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		'[attr.data-state]': '_stateProvider?.state() ?? "open"',
		'[attr.data-side]': '_sideProvider?.side() ?? "bottom"',
	},
})
export class HlmSelectContentDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly stickyLabels = input<boolean>(false);
	protected readonly _stateProvider = injectExposesStateProvider({ optional: true });
	protected readonly _sideProvider = injectExposedSideProvider({ optional: true });

	protected readonly _computedClass = computed(() =>
		hlm(
			'w-full relative z-50 min-w-[8rem] overflow-hidden rounded-md border border-border bg-popover text-popover-foreground shadow-md p-1 data-[side=bottom]:top-[2px] data-[side=top]:bottom-[2px] data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-group.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnSelectGroupDirective } from '@spartan-ng/brain/select';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmSelectGroup], hlm-select-group',
	hostDirectives: [BrnSelectGroupDirective],
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSelectGroupDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm(this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-label.directive.ts
```typescript
import { Directive, computed, inject, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnSelectLabelDirective } from '@spartan-ng/brain/select';
import type { ClassValue } from 'clsx';
import { HlmSelectContentDirective } from './hlm-select-content.directive';

@Directive({
	selector: '[hlmSelectLabel], hlm-select-label',
	hostDirectives: [BrnSelectLabelDirective],
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSelectLabelDirective {
	private readonly _selectContent = inject(HlmSelectContentDirective);
	private readonly _stickyLabels = computed(() => this._selectContent.stickyLabels());
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'pl-8 pr-2 text-sm font-semibold rtl:pl-2 rtl:pr-8',
			this._stickyLabels() ? 'sticky top-0 bg-popover block z-[2]' : '',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-option.component.ts
```typescript
import { ChangeDetectionStrategy, Component, computed, inject, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideCheck } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { BrnSelectOptionDirective } from '@spartan-ng/brain/select';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-option',
	changeDetection: ChangeDetectionStrategy.OnPush,
	hostDirectives: [{ directive: BrnSelectOptionDirective, inputs: ['disabled', 'value'] }],
	providers: [provideIcons({ lucideCheck })],
	host: {
		'[class]': '_computedClass()',
	},
	template: `
		<ng-content />
		<span
			[attr.dir]="_brnSelectOption.dir()"
			class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center rtl:left-auto rtl:right-2"
			[attr.data-state]="this._brnSelectOption.checkedState()"
		>
			@if (this._brnSelectOption.selected()) {
				<ng-icon hlm size="sm" aria-hidden="true" name="lucideCheck" />
			}
		</span>
	`,
	imports: [NgIcon, HlmIconDirective],
})
export class HlmSelectOptionComponent {
	protected readonly _brnSelectOption = inject(BrnSelectOptionDirective, { host: true });
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 rtl:flex-reverse rtl:pr-8 rtl:pl-2 text-sm outline-none data-[active]:bg-accent data-[active]:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-scroll-down.component.ts
```typescript
import { Component } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronDown } from '@ng-icons/lucide';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';

@Component({
	selector: 'hlm-select-scroll-down',
	imports: [NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideChevronDown })],
	host: {
		class: 'flex cursor-default items-center justify-center py-1',
	},
	template: `
		<ng-icon hlm size="sm" class="ml-2" name="lucideChevronDown" />
	`,
})
export class HlmSelectScrollDownComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-scroll-up.component.ts
```typescript
import { Component } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronUp } from '@ng-icons/lucide';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';

@Component({
	selector: 'hlm-select-scroll-up',
	imports: [NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideChevronUp })],
	host: {
		class: 'flex cursor-default items-center justify-center py-1',
	},
	template: `
		<ng-icon hlm size="sm" class="ml-2" name="lucideChevronUp" />
	`,
})
export class HlmSelectScrollUpComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-trigger.component.ts
```typescript
import { Component, computed, contentChild, inject, input } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideChevronDown } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { BrnSelectComponent, BrnSelectTriggerDirective } from '@spartan-ng/brain/select';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const selectTriggerVariants = cva(
	'flex items-center justify-between rounded-md border border-input bg-background text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50',
	{
		variants: {
			size: {
				default: 'h-10 py-2 px-4',
				sm: 'h-9 px-3',
				lg: 'h-11 px-8',
			},
			error: {
				auto: '[&.ng-invalid.ng-touched]:text-destructive [&.ng-invalid.ng-touched]:border-destructive [&.ng-invalid.ng-touched]:focus-visible:ring-destructive',
				true: 'text-destructive border-destructive focus-visible:ring-destructive',
			},
		},
		defaultVariants: {
			size: 'default',
			error: 'auto',
		},
	},
);
type SelectTriggerVariants = VariantProps<typeof selectTriggerVariants>;

@Component({
	selector: 'hlm-select-trigger',
	imports: [BrnSelectTriggerDirective, NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideChevronDown })],
	template: `
		<button [class]="_computedClass()" #button hlmInput brnSelectTrigger type="button">
			<ng-content />
			@if (icon()) {
				<ng-content select="ng-icon" />
			} @else {
				<ng-icon hlm size="sm" class="ml-2 flex-none" name="lucideChevronDown" />
			}
		</button>
	`,
})
export class HlmSelectTriggerComponent {
	protected readonly icon = contentChild(HlmIconDirective);

	protected readonly brnSelect = inject(BrnSelectComponent, { optional: true });

	public readonly _size = input<SelectTriggerVariants['size']>('default');
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	protected _computedClass = computed(() =>
		hlm(selectTriggerVariants({ size: this._size(), error: this.brnSelect?.errorState() }), this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select-value.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: 'hlm-select-value,[hlmSelectValue], brn-select-value[hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSelectValueDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() =>
		hlm(
			'!inline-block ltr:text-left rtl:text-right border-border w-[calc(100%)]] min-w-0 pointer-events-none truncate data-[placeholder]:text-muted-foreground',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/select/helm/src/lib/hlm-select.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: 'hlm-select, brn-select [hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSelectDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm('space-y-2', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/breadcrumb/breadcrumb.stories.ts
```typescript
import { RouterTestingModule } from '@angular/router/testing';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideSlash } from '@ng-icons/lucide';
import { HlmBreadCrumbImports, HlmBreadcrumbDirective } from '@spartan-ng/ui-breadcrumb-helm';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { Meta, StoryObj } from '@storybook/angular';
import { moduleMetadata } from '@storybook/angular';

const meta: Meta<HlmBreadcrumbDirective> = {
	title: 'Breadcrumb',
	component: HlmBreadcrumbDirective,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [HlmBreadCrumbImports, NgIcon, HlmIconDirective, RouterTestingModule],
			providers: [provideIcons({ lucideSlash })],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmBreadcrumbDirective>;

export const Default: Story = {
	render: () => ({
		template: /* HTML */ `
			<nav hlmBreadcrumb>
				<ol hlmBreadcrumbList>
					<li hlmBreadcrumbItem>
						<a hlmBreadcrumbLink href="/home">Home</a>
					</li>
					<li hlmBreadcrumbSeparator></li>
					<li hlmBreadcrumbItem>
						<hlm-breadcrumb-ellipsis />
					</li>
					<li hlmBreadcrumbSeparator></li>
					<li hlmBreadcrumbItem>
						<a hlmBreadcrumbLink hlmL href="/components">Components</a>
					</li>
					<li hlmBreadcrumbSeparator></li>
					<li hlmBreadcrumbItem>
						<span hlmBreadcrumbPage>Breadcrumb</span>
					</li>
				</ol>
			</nav>
		`,
	}),
};

export const Custom: Story = {
	render: () => ({
		template: /* HTML */ `
			<nav hlmBreadcrumb>
				<ol hlmBreadcrumbList>
					<li hlmBreadcrumbItem>
						<a hlmBreadcrumbLink href="/home">Home</a>
					</li>
					<li hlmBreadcrumbSeparator>
						<ng-icon hlm size="sm" name="lucideSlash" />
					</li>
					<li hlmBreadcrumbItem>
						<a hlmBreadcrumbLink href="/components">Components</a>
					</li>
					<li hlmBreadcrumbSeparator>
						<ng-icon hlm size="sm" name="lucideSlash" />
					</li>
					<li hlmBreadcrumbItem>
						<span hlmBreadcrumbPage>Breadcrumb</span>
					</li>
				</ol>
			</nav>
		`,
	}),
};

```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/icon.stories.ts
```typescript
import { Component, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { NgIcon, provideIcons } from '@ng-icons/core';
import * as lucide from '@ng-icons/lucide';
import { lucideHouse } from '@ng-icons/lucide';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmIconDirective, type IconSize } from './helm/src';

const meta: Meta<HlmIconDirective> = {
	title: 'Icon',
	component: HlmIconDirective,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [NgIcon, HlmIconDirective],
			providers: [provideIcons(lucide)],
		}),
	],
};

export default meta;
type Story = StoryObj<HlmIconDirective & NgIcon>;

export const Default: Story = {
	args: {
		name: 'lucideCheck',
		size: 'sm',
		color: 'red',
		strokeWidth: 1,
	},
	argTypes: {
		size: { control: 'select', options: ['xs', 'sm', 'base', 'lg', 'xl', 'none', '2rem', '25px', '10'] },
		name: { control: 'select', options: Object.keys(lucide) },
		color: { control: 'color' },
	},
	render: ({ ...args }) => ({
		props: args,
		template: `<ng-icon hlm ${argsToTemplate(args)} />`,
	}),
};

export const Tailwind: Story = {
	args: {
		name: 'lucideCheck',
	},
	argTypes: {
		name: { control: 'select', options: Object.keys(lucide) },
	},
	render: ({ ...args }) => ({
		props: args,
		template: `<ng-icon hlm ${argsToTemplate(args)} class="text-red-600 text-5xl" />`,
	}),
};

@Component({
	selector: 'icon-dynamic-story',
	standalone: true,
	imports: [FormsModule, NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideHouse })],
	template: /* HTML */ `
		<ng-icon hlm name="lucideHouse" [size]="size()" />
		<div>Bound property value: {{size()}}</div>

		<div class="flex flex-row gap-x-2">
			<label>
				<input type="radio" name="iconSize" [ngModel]="size()" (ngModelChange)="size.set($event)" value="xs" />
				<span>XS</span>
			</label>
			<label>
				<input type="radio" name="iconSize" [ngModel]="size()" (ngModelChange)="size.set($event)" value="sm" />
				<span>SM</span>
			</label>
			<label>
				<input type="radio" name="iconSize" [ngModel]="size()" (ngModelChange)="size.set($event)" value="base" />
				<span>Base</span>
			</label>
			<label>
				<input type="radio" name="iconSize" [ngModel]="size()" (ngModelChange)="size.set($event)" value="lg" />
				<span>LG</span>
			</label>
			<label>
				<input type="radio" name="iconSize" [ngModel]="size()" (ngModelChange)="size.set($event)" value="xl" />
				<span>XL</span>
			</label>
			<label>
				<input type="radio" name="iconSize" [ngModel]="size()" (ngModelChange)="size.set($event)" value="none" />
				<span>None</span>
			</label>
		</div>
	`,
})
class IconDynamicStory {
	protected size = signal<IconSize>('base');
}

export const Dynamic: Story = {
	decorators: [
		moduleMetadata({
			imports: [IconDynamicStory],
		}),
	],
	render: () => ({
		template: '<icon-dynamic-story/>',
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/README.md
```
# ui-icon-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-icon-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/eslint.config.js
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
		},
	},
	{
		files: ['**/*.html'],
		// Override or add rules here
		rules: {},
	},
];

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-icon-helm',
	preset: '../../../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../../../coverage/libs/ui/icon/helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/icon/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/package.json
```json
{
	"name": "@spartan-ng/ui-icon-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/project.json
```json
{
	"name": "ui-icon-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/icon/helm/src",
	"prefix": "hlm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/icon/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/icon/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/icon/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/icon/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-icon-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmIconDirective } from './lib/hlm-icon.directive';

export * from './lib/hlm-icon.directive';
export * from './lib/hlm-icon.token';

@NgModule({
	imports: [HlmIconDirective],
	exports: [HlmIconDirective],
})
export class HlmIconModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/src/lib/hlm-icon.directive.spec.ts
```typescript
import { ChangeDetectionStrategy, Component, Input } from '@angular/core';
import { By } from '@angular/platform-browser';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideCheck } from '@ng-icons/lucide';
import { type RenderResult, render } from '@testing-library/angular';
import { HlmIconDirective } from './hlm-icon.directive';

@Component({
	selector: 'hlm-mock',
	standalone: true,
	changeDetection: ChangeDetectionStrategy.OnPush,
	imports: [HlmIconDirective, NgIcon],
	providers: [provideIcons({ lucideCheck })],
	template: `
		<ng-icon hlm class="test" name="lucideCheck" [size]="size" color="red" strokeWidth="2" />
	`,
})
class HlmMockComponent {
	@Input() public size = 'base';
}

describe('HlmIconDirective', () => {
	let r: RenderResult<HlmMockComponent>;
	let icon: HTMLElement;

	beforeEach(async () => {
		r = await render(HlmMockComponent);
		icon = r.container.querySelector('ng-icon')!;
	});

	it('should add the xs size', async () => {
		await r.rerender({ componentInputs: { size: 'xs' } });
		r.fixture.detectChanges();
		expect(icon.getAttribute('style')).toContain('--ng-icon__size: 12px');
	});

	it('should add the sm size', async () => {
		await r.rerender({ componentInputs: { size: 'sm' } });
		r.fixture.detectChanges();
		expect(icon.getAttribute('style')).toContain('--ng-icon__size: 16px');
	});

	it('should add the base size', () => {
		expect(icon.getAttribute('style')).toContain('--ng-icon__size: 24px');
	});

	it('should add the lg size', async () => {
		await r.rerender({ componentInputs: { size: 'lg' } });
		r.fixture.detectChanges();
		expect(icon.getAttribute('style')).toContain('--ng-icon__size: 32px');
	});

	it('should add the xl size', async () => {
		await r.rerender({ componentInputs: { size: 'xl' } });
		r.fixture.detectChanges();
		expect(icon.getAttribute('style')).toContain('--ng-icon__size: 48px');
	});

	it('should forward the size property if the size is not a pre-defined size', async () => {
		await r.rerender({ componentInputs: { size: '2rem' } });
		r.fixture.detectChanges();
		const debugEl = r.fixture.debugElement.query(By.directive(NgIcon));
		expect(debugEl.componentInstance.size()).toBe('2rem');
		expect(icon.getAttribute('style')).toContain('--ng-icon__size: 2rem');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/src/lib/hlm-icon.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { injectHlmIconConfig } from './hlm-icon.token';

export type IconSize = 'xs' | 'sm' | 'base' | 'lg' | 'xl' | 'none' | (Record<never, never> & string);

@Directive({
	selector: 'ng-icon[hlm]',
	standalone: true,
	host: {
		'[style.--ng-icon__size]': '_computedSize()',
	},
})
export class HlmIconDirective {
	private readonly _config = injectHlmIconConfig();
	public readonly size = input<IconSize>(this._config.size);

	protected readonly _computedSize = computed(() => {
		const size = this.size();

		switch (size) {
			case 'xs':
				return '12px';
			case 'sm':
				return '16px';
			case 'base':
				return '24px';
			case 'lg':
				return '32px';
			case 'xl':
				return '48px';
			default: {
				return size;
			}
		}
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/icon/helm/src/lib/hlm-icon.token.ts
```typescript
import { InjectionToken, ValueProvider, inject } from '@angular/core';
import type { IconSize } from './hlm-icon.directive';

export interface HlmIconConfig {
	size: IconSize;
}

const defaultConfig: HlmIconConfig = {
	size: 'base',
};

const HlmIconConfigToken = new InjectionToken<HlmIconConfig>('HlmIconConfig');

export function provideHlmIconConfig(config: Partial<HlmIconConfig>): ValueProvider {
	return { provide: HlmIconConfigToken, useValue: { ...defaultConfig, ...config } };
}

export function injectHlmIconConfig(): HlmIconConfig {
	return inject(HlmIconConfigToken, { optional: true }) ?? defaultConfig;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/sheet.stories.ts
```typescript
import { BrnSheetComponent, BrnSheetContentDirective, BrnSheetTriggerDirective } from '@spartan-ng/brain/sheet';
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmButtonDirective } from '../button/helm/src';
import { HlmInputDirective } from '../input/helm/src';
import { HlmSheetImports } from './helm/src';

export type SheetProps = { side: 'top' | 'bottom' | 'left' | 'right' };
const meta: Meta<SheetProps> = {
	title: 'Sheet',
	component: BrnSheetComponent,
	tags: ['autodocs'],
	args: { side: 'left' },
	argTypes: {
		side: { control: 'select', options: ['top', 'bottom', 'left', 'right'] },
	},
	decorators: [
		moduleMetadata({
			imports: [
				BrnSheetTriggerDirective,
				BrnSheetContentDirective,
				HlmSheetImports,
				HlmButtonDirective,
				HlmInputDirective,
			],
		}),
	],
};

export default meta;
type Story = StoryObj<SheetProps>;

export const Default: Story = {
	render: ({ ...args }) => ({
		props: args,
		template: `
    <hlm-sheet ${argsToTemplate(args)}>
    <button id='edit-profile' variant='outline' brnSheetTrigger hlmBtn>Edit Profile</button>
    <hlm-sheet-content *brnSheetContent='let ctx'>
         <hlm-sheet-header>
          <h3 hlmSheetTitle>Edit Profile</h3>
          <p hlmSheetDescription>
          Make changes to your profile here. Click save when you're done.
          </p>
        </hlm-sheet-header>
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
        <hlm-sheet-footer>
          <button hlmBtn type='submit'>Save Changes</button>
        </hlm-sheet-footer>
    </hlm-sheet-content>
    </hlm-sheet>
    `,
	}),
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/README.md
```
# ui-sheet-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-sheet-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-sheet-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/sheet/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/package.json
```json
{
	"name": "@spartan-ng/ui-sheet-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/core": ">=19.0.0",
		"@ng-icons/core": ">=29.0.0",
		"@ng-icons/lucide": ">=29.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/project.json
```json
{
	"name": "ui-sheet-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/sheet/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/sheet/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/sheet/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/sheet/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/sheet/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-sheet-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { HlmSheetCloseDirective } from './lib/hlm-sheet-close.directive';
import { HlmSheetContentComponent } from './lib/hlm-sheet-content.component';
import { HlmSheetDescriptionDirective } from './lib/hlm-sheet-description.directive';
import { HlmSheetFooterComponent } from './lib/hlm-sheet-footer.component';
import { HlmSheetHeaderComponent } from './lib/hlm-sheet-header.component';
import { HlmSheetOverlayDirective } from './lib/hlm-sheet-overlay.directive';
import { HlmSheetTitleDirective } from './lib/hlm-sheet-title.directive';
import { HlmSheetComponent } from './lib/hlm-sheet.component';

export * from './lib/hlm-sheet-close.directive';
export * from './lib/hlm-sheet-content.component';
export * from './lib/hlm-sheet-description.directive';
export * from './lib/hlm-sheet-footer.component';
export * from './lib/hlm-sheet-header.component';
export * from './lib/hlm-sheet-overlay.directive';
export * from './lib/hlm-sheet-title.directive';
export * from './lib/hlm-sheet.component';

export const HlmSheetImports = [
	HlmSheetComponent,
	HlmSheetCloseDirective,
	HlmSheetContentComponent,
	HlmSheetDescriptionDirective,
	HlmSheetFooterComponent,
	HlmSheetHeaderComponent,
	HlmSheetOverlayDirective,
	HlmSheetTitleDirective,
] as const;

@NgModule({
	imports: [...HlmSheetImports],
	exports: [...HlmSheetImports],
})
export class HlmSheetModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/src/lib/hlm-sheet-close.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmSheetClose],[brnSheetClose][hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSheetCloseDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm(
			'absolute flex h-4 w-4 right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground',
			this.userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/src/lib/hlm-sheet-content.component.ts
```typescript
import { Component, ElementRef, Renderer2, computed, effect, inject, input, signal } from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideX } from '@ng-icons/lucide';
import { hlm, injectExposedSideProvider, injectExposesStateProvider } from '@spartan-ng/brain/core';
import { BrnSheetCloseDirective } from '@spartan-ng/brain/sheet';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import { cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';
import { HlmSheetCloseDirective } from './hlm-sheet-close.directive';

export const sheetVariants = cva(
	'fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:duration-300 data-[state=open]:duration-500',
	{
		variants: {
			side: {
				top: 'border-border inset-x-0 top-0 border-b data-[state=closed]:slide-out-to-top data-[state=open]:slide-in-from-top',
				bottom:
					'border-border inset-x-0 bottom-0 border-t data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom',
				left: 'border-border inset-y-0 left-0 h-full w-3/4 border-r data-[state=closed]:slide-out-to-left data-[state=open]:slide-in-from-left sm:max-w-sm',
				right:
					'border-border inset-y-0 right-0 h-full w-3/4  border-l data-[state=closed]:slide-out-to-right data-[state=open]:slide-in-from-right sm:max-w-sm',
			},
		},
		defaultVariants: {
			side: 'right',
		},
	},
);

@Component({
	selector: 'hlm-sheet-content',
	imports: [HlmSheetCloseDirective, BrnSheetCloseDirective, NgIcon, HlmIconDirective],
	providers: [provideIcons({ lucideX })],
	host: {
		'[class]': '_computedClass()',
		'[attr.data-state]': 'state()',
	},
	template: `
		<ng-content />
		<button brnSheetClose hlm>
			<span class="sr-only">Close</span>
			<ng-icon hlm size="sm" name="lucideX" />
		</button>
	`,
})
export class HlmSheetContentComponent {
	private readonly _stateProvider = injectExposesStateProvider({ host: true });
	private readonly _sideProvider = injectExposedSideProvider({ host: true });
	public state = this._stateProvider.state ?? signal('closed');
	private readonly _renderer = inject(Renderer2);
	private readonly _element = inject(ElementRef);

	constructor() {
		effect(() => {
			this._renderer.setAttribute(this._element.nativeElement, 'data-state', this.state());
		});
	}

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm(sheetVariants({ side: this._sideProvider.side() }), this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/src/lib/hlm-sheet-description.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnSheetDescriptionDirective } from '@spartan-ng/brain/sheet';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmSheetDescription]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [BrnSheetDescriptionDirective],
})
export class HlmSheetDescriptionDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('text-sm text-muted-foreground', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/src/lib/hlm-sheet-footer.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-sheet-footer',
	standalone: true,
	template: `
		<ng-content />
	`,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSheetFooterComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm('flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2', this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/src/lib/hlm-sheet-header.component.ts
```typescript
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: 'hlm-sheet-header',
	standalone: true,
	template: `
		<ng-content />
	`,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSheetHeaderComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('flex flex-col space-y-2 text-center sm:text-left', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/src/lib/hlm-sheet-overlay.directive.ts
```typescript
import { Directive, computed, effect, input, untracked } from '@angular/core';
import { hlm, injectCustomClassSettable } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmSheetOverlay],brn-sheet-overlay[hlm]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmSheetOverlayDirective {
	private readonly _classSettable = injectCustomClassSettable({ optional: true, host: true });
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/src/lib/hlm-sheet-title.directive.ts
```typescript
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { BrnSheetTitleDirective } from '@spartan-ng/brain/sheet';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[hlmSheetTitle]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	hostDirectives: [BrnSheetTitleDirective],
})
export class HlmSheetTitleDirective {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('text-lg font-semibold', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/sheet/helm/src/lib/hlm-sheet.component.ts
```typescript
import { ChangeDetectionStrategy, Component, forwardRef, ViewEncapsulation } from '@angular/core';
import { BrnDialogComponent, provideBrnDialogDefaultOptions } from '@spartan-ng/brain/dialog';
import { BrnSheetComponent, BrnSheetOverlayComponent } from '@spartan-ng/brain/sheet';
import { HlmSheetOverlayDirective } from './hlm-sheet-overlay.directive';

@Component({
	selector: 'hlm-sheet',
	imports: [BrnSheetOverlayComponent, HlmSheetOverlayDirective],
	providers: [
		{
			provide: BrnDialogComponent,
			useExisting: forwardRef(() => BrnSheetComponent),
		},
		{
			provide: BrnSheetComponent,
			useExisting: forwardRef(() => HlmSheetComponent),
		},
		provideBrnDialogDefaultOptions({
			// add custom options here
		}),
	],
	template: `
		<brn-sheet-overlay hlm />
		<ng-content />
	`,
	encapsulation: ViewEncapsulation.None,
	changeDetection: ChangeDetectionStrategy.OnPush,
	exportAs: 'hlmSheet',
})
export class HlmSheetComponent extends BrnSheetComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/badge/badge.stories.ts
```typescript
import { type Meta, type StoryObj, argsToTemplate, moduleMetadata } from '@storybook/angular';
import { HlmBadgeDirective } from './helm/src';

const meta: Meta<HlmBadgeDirective> = {
	title: 'Badge',
	component: HlmBadgeDirective,
	tags: ['autodocs'],
	argTypes: {
		variant: {
			options: ['default', 'secondary', 'destructive', 'outline'],
			control: {
				type: 'select',
			},
			table: {
				defaultValue: { summary: 'default' },
			},
		},
		size: {
			options: ['default', 'lg'],
			control: {
				type: 'select',
			},
			table: {
				defaultValue: { summary: 'default' },
			},
		},
		static: {
			control: { type: 'boolean' },
			table: {
				defaultValue: { summary: 'false' },
			},
		},
	},
	args: {
		static: false,
	},
	decorators: [
		moduleMetadata({
			imports: [HlmBadgeDirective],
		}),
	],
	render: ({ ...args }) => ({
		props: args,
		template: `
    <span hlmBadge ${argsToTemplate(args)}>I am a badge</span>
    `,
	}),
};

export default meta;
type Story = StoryObj<HlmBadgeDirective>;

export const Default: Story = {
	args: {
		variant: 'default',
	},
};

export const Destructive: Story = {
	args: {
		variant: 'destructive',
	},
};

export const Outline: Story = {
	args: {
		variant: 'outline',
	},
};

export const Secondary: Story = {
	args: {
		variant: 'secondary',
	},
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/badge/helm/README.md
```
# ui-badge-helm

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test ui-badge-helm` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/badge/helm/eslint.config.js
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/badge/helm/jest.config.ts
```typescript
export default {
	displayName: 'ui-badge-helm',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/badge/helm/ng-package.json
```json
{
	"$schema": "../../../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../../../dist/libs/ui/badge/helm",
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/badge/helm/package.json
```json
{
	"name": "@spartan-ng/ui-badge-helm",
	"version": "0.0.1-alpha.381",
	"sideEffects": false,
	"dependencies": {},
	"peerDependencies": {
		"@angular/cdk": ">=19.0.0",
		"@angular/core": ">=19.0.0",
		"@spartan-ng/brain": "0.0.1-alpha.451",
		"class-variance-authority": "^0.7.0",
		"clsx": "^2.1.1"
	},
	"publishConfig": {
		"access": "public"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/badge/helm/project.json
```json
{
	"name": "ui-badge-helm",
	"$schema": "../../../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/ui/badge/helm/src",
	"prefix": "helm",
	"projectType": "library",
	"tags": ["scope:helm"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/ui/badge/helm/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/ui/badge/helm/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/ui/badge/helm/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/ui/badge/helm/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "ui-badge-helm"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/badge/helm/tsconfig.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/badge/helm/tsconfig.lib.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/badge/helm/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/badge/helm/tsconfig.spec.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/badge/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmBadgeDirective } from './lib/hlm-badge.directive';

export * from './lib/hlm-badge.directive';

@NgModule({
	imports: [HlmBadgeDirective],
	exports: [HlmBadgeDirective],
})
export class HlmBadgeModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/badge/helm/src/test-setup.ts
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/badge/helm/src/lib/hlm-badge.directive.ts
```typescript
import type { BooleanInput } from '@angular/cdk/coercion';
import { Directive, booleanAttribute, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const badgeVariants = cva(
	'inline-flex items-center border rounded-full px-2.5 py-0.5 font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2',
	{
		variants: {
			variant: {
				default: 'bg-primary border-transparent text-primary-foreground',
				secondary: 'bg-secondary border-transparent text-secondary-foreground',
				destructive: 'bg-destructive border-transparent text-destructive-foreground',
				outline: 'text-foreground border-border',
			},
			size: {
				default: 'text-xs',
				lg: 'text-sm',
			},
			static: { true: '', false: '' },
		},
		compoundVariants: [
			{
				variant: 'default',
				static: false,
				class: 'hover:bg-primary/80',
			},
			{
				variant: 'secondary',
				static: false,
				class: 'hover:bg-secondary/80',
			},
			{
				variant: 'destructive',
				static: false,
				class: 'hover:bg-destructive/80',
			},
		],
		defaultVariants: {
			variant: 'default',
			size: 'default',
			static: false,
		},
	},
);
export type BadgeVariants = VariantProps<typeof badgeVariants>;

@Directive({
	selector: '[hlmBadge]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmBadgeDirective {
	protected readonly _computedClass = computed(() =>
		hlm(badgeVariants({ variant: this.variant(), size: this.size(), static: this.static() }), this.userClass()),
	);

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly variant = input<BadgeVariants['variant']>('default');
	public readonly static = input<BadgeVariants['static'], BooleanInput>(false, { transform: booleanAttribute });
	public readonly size = input<BadgeVariants['size']>('default');
}

```
