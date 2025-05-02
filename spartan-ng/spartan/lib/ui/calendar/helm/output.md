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
