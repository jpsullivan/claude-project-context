/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/README.md
```
# brain

This library was generated with [Nx](https://nx.dev).

## Running unit tests

Run `nx test brain` to execute the unit tests.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/eslint.config.cjs
```
const nx = require('@nx/eslint-plugin');
const baseConfig = require('../../eslint.config.cjs');

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
					prefix: 'brn',
					style: 'camelCase',
				},
			],
			'@angular-eslint/component-selector': [
				'error',
				{
					type: 'element',
					prefix: 'brn',
					style: 'kebab-case',
				},
			],
			// we may want to enable these at some point
			'@angular-eslint/template/click-events-have-key-events': 'off',
			'@angular-eslint/template/interactive-supports-focus': 'off',
			'@angular-eslint/template/label-has-associated-control': 'off',
			'@angular-eslint/no-input-rename': 'off',
			'@angular-eslint/no-output-rename': 'off',
			'@angular-eslint/no-output-native': 'off',
		},
	},
	{
		files: ['**/tests/*.ts'],
		rules: {
			'@angular-eslint/directive-selector': 'off',
			'@angular-eslint/component-selector': 'off',
		},
	},
	{
		files: ['**/*.html'],
		// Override or add rules here
		rules: {
			// we may want to enable these at some point
			'@angular-eslint/template/click-events-have-key-events': 'off',
			'@angular-eslint/template/interactive-supports-focus': 'off',
			'@angular-eslint/template/label-has-associated-control': 'off',
		},
	},
];

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/hlm-tailwind-preset.css
```css
@plugin "tailwindcss-animate";

@theme {
	--color-border: hsl(var(--border));
	--color-input: hsl(var(--input));
	--color-ring: hsl(var(--ring));
	--color-background: hsl(var(--background));
	--color-foreground: hsl(var(--foreground));
	--color-primary: hsl(var(--primary));
	--color-primary-foreground: hsl(var(--primary-foreground));
	--color-secondary: hsl(var(--secondary));
	--color-secondary-foreground: hsl(var(--secondary-foreground));
	--color-destructive: hsl(var(--destructive));
	--color-destructive-foreground: hsl(var(--destructive-foreground));
	--color-muted: hsl(var(--muted));
	--color-muted-foreground: hsl(var(--muted-foreground));
	--color-accent: hsl(var(--accent));
	--color-accent-foreground: hsl(var(--accent-foreground));
	--color-popover: hsl(var(--popover));
	--color-popover-foreground: hsl(var(--popover-foreground));
	--color-card: hsl(var(--card));
	--color-card-foreground: hsl(var(--card-foreground));

	--radius-lg: var(--radius);
	--radius-md: calc(var(--radius) - 2px);
	--radius-sm: calc(var(--radius) - 4px);

	--animate-indeterminate: indeterminate 4s ease-in-out;
}

@keyframes indeterminate {
	0% {
		transform: translateX(-100%) scaleX(0.5);
	}
	100% {
		transform: translateX(100%) scaleX(0.5);
	}
}

@utility container {
  margin-inline: auto;
  padding-inline: 2rem;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/hlm-tailwind-preset.js
```javascript
const { fontFamily } = require('tailwindcss/defaultTheme');

/** @type {import('tailwindcss').Config} */
module.exports = {
	theme: {
		container: {
			center: true,
			padding: '2rem',
			screens: {
				'2xl': '1400px',
			},
		},
		extend: {
			colors: {
				border: 'hsl(var(--border))',
				input: 'hsl(var(--input))',
				ring: 'hsl(var(--ring))',
				background: 'hsl(var(--background))',
				foreground: 'hsl(var(--foreground))',
				primary: {
					DEFAULT: 'hsl(var(--primary))',
					foreground: 'hsl(var(--primary-foreground))',
				},
				secondary: {
					DEFAULT: 'hsl(var(--secondary))',
					foreground: 'hsl(var(--secondary-foreground))',
				},
				destructive: {
					DEFAULT: 'hsl(var(--destructive))',
					foreground: 'hsl(var(--destructive-foreground))',
				},
				muted: {
					DEFAULT: 'hsl(var(--muted))',
					foreground: 'hsl(var(--muted-foreground))',
				},
				accent: {
					DEFAULT: 'hsl(var(--accent))',
					foreground: 'hsl(var(--accent-foreground))',
				},
				popover: {
					DEFAULT: 'hsl(var(--popover))',
					foreground: 'hsl(var(--popover-foreground))',
				},
				card: {
					DEFAULT: 'hsl(var(--card))',
					foreground: 'hsl(var(--card-foreground))',
				},
			},
			borderRadius: {
				lg: 'var(--radius)',
				md: 'calc(var(--radius) - 2px)',
				sm: 'calc(var(--radius) - 4px)',
			},
			fontFamily: {
				sans: ['var(--font-sans)', ...fontFamily.sans],
			},
			keyframes: {
				indeterminate: {
					'0%': {
						transform: 'translateX(-100%) scaleX(0.5)',
					},
					'100%': {
						transform: 'translateX(100%) scaleX(0.5)',
					},
				},
				'caret-blink': {
					'0%,70%,100%': { opacity: '1' },
					'20%,50%': { opacity: '0' },
				},
			},
			animation: {
				indeterminate: 'indeterminate 4s infinite ease-in-out',
				'caret-blink': 'caret-blink 1.25s ease-out infinite',
			},
		},
	},
	plugins: [require('tailwindcss-animate')],
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/jest.config.ts
```typescript
export default {
	displayName: 'brain',
	preset: '../../jest.preset.cjs',
	setupFilesAfterEnv: ['<rootDir>/src/test-setup.ts'],
	coverageDirectory: '../../coverage/libs/brain',
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/ng-package.json
```json
{
	"$schema": "../../node_modules/ng-packagr/ng-package.schema.json",
	"dest": "../../dist/libs/brain",
	"lib": {
		"entryFile": "src/index.ts"
	},
	"assets": ["hlm-tailwind-preset.js", "hlm-tailwind-preset.css"]
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/package.json
```json
{
	"name": "@spartan-ng/brain",
	"version": "0.0.1-alpha.451",
	"sideEffects": false,
	"exports": {
		"./hlm-tailwind-preset": {
			"default": "./hlm-tailwind-preset.js"
		},
		"./hlm-tailwind-preset.css": "./hlm-tailwind-preset.css"
	},
	"peerDependencies": {
		"@angular/cdk": ">=19.0.0",
		"@angular/common": ">=19.0.0",
		"@angular/core": ">=19.0.0",
		"@angular/forms": ">=19.0.0",
		"clsx": ">=2.0.0",
		"luxon": ">=3.0.0",
		"rxjs": ">=6.6.0",
		"tailwind-merge": ">=2.5.0",
		"tailwindcss": ">=3.3.0",
		"tailwindcss-animate": ">=1.0.7"
	},
	"peerDependenciesMeta": {
		"luxon": {
			"optional": true
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/project.json
```json
{
	"name": "brain",
	"$schema": "../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/brain/src",
	"prefix": "brn",
	"projectType": "library",
	"tags": ["scope:brain"],
	"targets": {
		"build": {
			"executor": "@nx/angular:package",
			"outputs": ["{workspaceRoot}/dist/{projectRoot}"],
			"options": {
				"project": "libs/brain/ng-package.json"
			},
			"configurations": {
				"production": {
					"tsConfig": "libs/brain/tsconfig.lib.prod.json"
				},
				"development": {
					"tsConfig": "libs/brain/tsconfig.lib.json"
				}
			},
			"defaultConfiguration": "production"
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/brain/jest.config.ts"
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint"
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "brain"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tsconfig.json
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
	"extends": "../../tsconfig.base.json",
	"angularCompilerOptions": {
		"enableI18nLegacyMessageIdFormat": false,
		"strictInjectionParameters": true,
		"strictInputAccessModifiers": true,
		"strictTemplates": true
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tsconfig.lib.json
```json
{
	"extends": "./tsconfig.json",
	"compilerOptions": {
		"outDir": "../../dist/out-tsc",
		"declaration": true,
		"declarationMap": true,
		"inlineSources": true,
		"types": []
	},
	"exclude": ["**/*.spec.ts", "test-setup.ts", "jest.config.ts", "**/*.test.ts"],
	"include": ["**/*.ts"]
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tsconfig.lib.prod.json
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tsconfig.spec.json
```json
{
	"extends": "./tsconfig.json",
	"compilerOptions": {
		"outDir": "../../dist/out-tsc",
		"module": "commonjs",
		"target": "es2016",
		"types": ["jest", "node"]
	},
	"files": ["src/test-setup.ts"],
	"include": ["jest.config.ts", "**/*.test.ts", "**/*.spec.ts", "**/*.d.ts"]
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tabs/README.md
```
# @spartan-ng/brain/tabs

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/tabs`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tabs/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tabs/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnTabsListDirective } from './lib/brn-tabs-list.directive';
import { BrnTabsContentDirective, BrnTabsDirective, BrnTabsTriggerDirective } from './lib/brn-tabs-trigger.directive';

export * from './lib/brn-tabs-list.directive';
export * from './lib/brn-tabs-paginated-list.directive';
export * from './lib/brn-tabs-trigger.directive';

export const BrnTabsImports = [
	BrnTabsDirective,
	BrnTabsListDirective,
	BrnTabsTriggerDirective,
	BrnTabsContentDirective,
] as const;

@NgModule({
	imports: [...BrnTabsImports],
	exports: [...BrnTabsImports],
})
export class BrnTabsModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tabs/src/lib/brn-tabs-list.directive.ts
```typescript
import { FocusKeyManager } from '@angular/cdk/a11y';
import { type AfterContentInit, Directive, ElementRef, contentChildren, inject } from '@angular/core';
import { fromEvent } from 'rxjs';
import { take } from 'rxjs/operators';
import { BrnTabsDirective, BrnTabsTriggerDirective } from './brn-tabs-trigger.directive';

@Directive({
	selector: '[brnTabsList]',
	standalone: true,
	host: {
		role: 'tablist',
		'[attr.aria-orientation]': '_orientation()',
		'[attr.data-orientation]': '_orientation()',
	},
	exportAs: 'brnTabsList',
})
export class BrnTabsListDirective implements AfterContentInit {
	private readonly _root = inject(BrnTabsDirective);

	protected readonly _orientation = this._root.$orientation;
	private readonly _direction = this._root.$direction;
	private readonly _activeTab = this._root.$activeTab;
	private readonly _tabs = this._root.$tabs;
	private readonly _elementRef = inject<ElementRef<HTMLElement>>(ElementRef);
	private readonly _keyDownListener = fromEvent(this._elementRef.nativeElement, 'keydown');

	private _keyManager?: FocusKeyManager<BrnTabsTriggerDirective>;

	public triggers = contentChildren(BrnTabsTriggerDirective, { descendants: true });

	public ngAfterContentInit() {
		this._keyManager = new FocusKeyManager<BrnTabsTriggerDirective>(this.triggers())
			.withHorizontalOrientation(this._direction())
			.withHomeAndEnd()
			.withPageUpDown()
			.withWrap();

		// needed because by default the index is set to -1, which means first interaction is skipped
		this._keyDownListener.pipe(take(1)).subscribe(() => {
			const currentTabKey = this._activeTab();
			const tabs = this._tabs();
			let activeIndex = 0;
			if (currentTabKey) {
				const currentTab = tabs[currentTabKey];
				if (currentTab) {
					activeIndex = this.triggers().indexOf(currentTab.trigger);
				}
			}
			this._keyManager?.setActiveItem(activeIndex);
		});

		this._keyDownListener.subscribe((event) => {
			if ('key' in event) {
				if (this._orientation() === 'horizontal') {
					if (event.key === 'ArrowUp' || event.key === 'ArrowDown') return;
				}
				if (this._orientation() === 'vertical') {
					if (event.key === 'ArrowLeft' || event.key === 'ArrowRight') return;
				}
			}
			this._keyManager?.onKeydown(event as KeyboardEvent);
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tabs/src/lib/brn-tabs-paginated-list.directive.ts
```typescript
/**
 * We are building on shoulders of giants here and adapt the implementation provided by the incredible Angular
 * team: https://github.com/angular/components/blob/main/src/material/tabs/paginated-tab-header.ts
 * Check them out! Give them a try! Leave a star! Their work is incredible!
 */

/**
 * @license
 * Copyright Google LLC All Rights Reserved.
 *
 * Use of this source code is governed by an MIT-style license that can be
 * found in the LICENSE file at https://angular.io/license
 */

import { FocusKeyManager, type FocusableOption } from '@angular/cdk/a11y';
import { type Direction, Directionality } from '@angular/cdk/bidi';
import { ENTER, SPACE, hasModifierKey } from '@angular/cdk/keycodes';
import { SharedResizeObserver } from '@angular/cdk/observers/private';
import { Platform, normalizePassiveListenerOptions } from '@angular/cdk/platform';
import { ViewportRuler } from '@angular/cdk/scrolling';
import {
	ANIMATION_MODULE_TYPE,
	type AfterContentChecked,
	type AfterContentInit,
	type AfterViewInit,
	ChangeDetectorRef,
	Directive,
	ElementRef,
	Injector,
	NgZone,
	type OnDestroy,
	Signal,
	afterNextRender,
	booleanAttribute,
	computed,
	effect,
	inject,
	input,
	output,
	signal,
} from '@angular/core';
import { EMPTY, Observable, type Observer, Subject, fromEvent, merge, of as observableOf, timer } from 'rxjs';
import { debounceTime, filter, skip, startWith, switchMap, takeUntil } from 'rxjs/operators';
import { BrnTabsDirective } from './brn-tabs-trigger.directive';

/** Config used to bind passive event listeners */
const passiveEventListenerOptions = normalizePassiveListenerOptions({
	passive: true,
}) as EventListenerOptions;

/**
 * The directions that scrolling can go in when the header's tabs exceed the header width. 'After'
 * will scroll the header towards the end of the tabs list and 'before' will scroll towards the
 * beginning of the list.
 */
export type ScrollDirection = 'after' | 'before';

/**
 * Amount of milliseconds to wait before starting to scroll the header automatically.
 * Set a little conservatively in order to handle fake events dispatched on touch devices.
 */
const HEADER_SCROLL_DELAY = 650;

/**
 * Interval in milliseconds at which to scroll the header
 * while the user is holding their pointer.
 */
const HEADER_SCROLL_INTERVAL = 100;

/** Item inside a paginated tab header. */
export type BrnPaginatedTabHeaderItem = FocusableOption & { elementRef: ElementRef };

/**
 * Base class for a tab header that supported pagination.
 * @docs-private
 */
@Directive()
export abstract class BrnTabsPaginatedListDirective
	implements AfterContentChecked, AfterContentInit, AfterViewInit, OnDestroy
{
	public abstract _items: Signal<ReadonlyArray<BrnPaginatedTabHeaderItem>>;
	public abstract _itemsChanges: Observable<ReadonlyArray<BrnPaginatedTabHeaderItem>>;
	public abstract _tabListContainer: Signal<ElementRef<HTMLElement>>;
	public abstract _tabList: Signal<ElementRef<HTMLElement>>;
	public abstract _tabListInner: Signal<ElementRef<HTMLElement>>;
	public abstract _nextPaginator: Signal<ElementRef<HTMLElement>>;
	public abstract _previousPaginator: Signal<ElementRef<HTMLElement>>;

	/** The distance in pixels that the tab labels should be translated to the left. */
	private _scrollDistance = 0;

	/** Whether the header should scroll to the selected index after the view has been checked. */
	private _selectedIndexChanged = false;

	private readonly _root = inject(BrnTabsDirective);
	private readonly _activeTab = this._root.$activeTab;
	private readonly _tabs = this._root.$tabs;

	/** Emits when the component is destroyed. */
	protected readonly _destroyed = new Subject<void>();

	/** Whether the controls for pagination should be displayed */
	public _showPaginationControls = signal(false);

	/** Whether the tab list can be scrolled more towards the end of the tab label list. */
	public _disableScrollAfter = true;

	/** Whether the tab list can be scrolled more towards the beginning of the tab label list. */
	public _disableScrollBefore = true;

	/**
	 * The number of tab labels that are displayed on the header. When this changes, the header
	 * should re-evaluate the scroll position.
	 */
	private _tabLabelCount!: number;

	/** Whether the scroll distance has changed and should be applied after the view is checked. */
	private _scrollDistanceChanged!: boolean;

	/** Used to manage focus between the tabs. */
	private _keyManager!: FocusKeyManager<BrnPaginatedTabHeaderItem>;

	/** Cached text content of the header. */
	private _currentTextContent!: string;

	/** Stream that will stop the automated scrolling. */
	private readonly _stopScrolling = new Subject<void>();

	/**
	 * Whether pagination should be disabled. This can be used to avoid unnecessary
	 * layout recalculations if it's known that pagination won't be required.
	 */
	public disablePagination = input(false, { transform: booleanAttribute });

	/** The index of the active tab. */
	private readonly _selectedIndex = computed(() => {
		const currentTabKey = this._activeTab();
		const tabs = this._tabs();

		let activeIndex = 0;
		if (currentTabKey && this._items()) {
			const currentTab = tabs[currentTabKey];
			if (currentTab) {
				activeIndex = this._items().indexOf(currentTab.trigger);
			}
		}

		return activeIndex;
	});

	/** Event emitted when the option is selected. */
	public readonly selectFocusedIndex = output<number>();

	/** Event emitted when a label is focused. */
	public readonly indexFocused = output<number>();

	private readonly _sharedResizeObserver = inject(SharedResizeObserver);

	private readonly _injector = inject(Injector);

	protected _elementRef: ElementRef<HTMLElement> = inject(ElementRef);
	protected _changeDetectorRef: ChangeDetectorRef = inject(ChangeDetectorRef);
	private readonly _viewportRuler: ViewportRuler = inject(ViewportRuler);
	private readonly _dir = inject(Directionality, { optional: true });
	private readonly _ngZone: NgZone = inject(NgZone);
	private readonly _platform: Platform = inject(Platform);
	public _animationMode = inject(ANIMATION_MODULE_TYPE, { optional: true });

	constructor() {
		// Bind the `mouseleave` event on the outside since it doesn't change anything in the view.
		this._ngZone.runOutsideAngular(() => {
			fromEvent(this._elementRef.nativeElement, 'mouseleave')
				.pipe(takeUntil(this._destroyed))
				.subscribe(() => {
					this._stopInterval();
				});
		});

		effect(() => {
			const selectedIndex = this._selectedIndex();

			if (selectedIndex !== 0) {
				this._selectedIndexChanged = true;
				if (this._keyManager) {
					this._keyManager.updateActiveItem(selectedIndex);
				}
			}
		});
	}

	/** Called when the user has selected an item via the keyboard. */
	protected abstract _itemSelected(event: KeyboardEvent): void;

	ngAfterViewInit() {
		// We need to handle these events manually, because we want to bind passive event listeners.
		fromEvent(this._previousPaginator().nativeElement, 'touchstart', passiveEventListenerOptions)
			.pipe(takeUntil(this._destroyed))
			.subscribe(() => {
				this._handlePaginatorPress('before');
			});

		fromEvent(this._nextPaginator().nativeElement, 'touchstart', passiveEventListenerOptions)
			.pipe(takeUntil(this._destroyed))
			.subscribe(() => {
				this._handlePaginatorPress('after');
			});
	}

	ngAfterContentInit() {
		const dirChange = this._dir ? this._dir.change : observableOf('ltr');
		// We need to debounce resize events because the alignment logic is expensive.
		// If someone animates the width of tabs, we don't want to realign on every animation frame.
		// Once we haven't seen any more resize events in the last 32ms (~2 animaion frames) we can
		// re-align.
		const resize = this._sharedResizeObserver
			.observe(this._elementRef.nativeElement)
			.pipe(debounceTime(32), takeUntil(this._destroyed));
		// Note: We do not actually need to watch these events for proper functioning of the tabs,
		// the resize events above should capture any viewport resize that we care about. However,
		// removing this is fairly breaking for screenshot tests, so we're leaving it here for now.
		const viewportResize = this._viewportRuler.change(150).pipe(takeUntil(this._destroyed));

		const realign = () => {
			this.updatePagination();
		};

		this._keyManager = new FocusKeyManager<BrnPaginatedTabHeaderItem>(this._items())
			.withHorizontalOrientation(this._getLayoutDirection())
			.withHomeAndEnd()
			.withWrap()
			// Allow focus to land on disabled tabs, as per https://w3c.github.io/aria-practices/#kbd_disabled_controls
			.skipPredicate(() => false);

		this._keyManager.updateActiveItem(this._selectedIndex());

		// Note: We do not need to realign after the first render for proper functioning of the tabs
		// the resize events above should fire when we first start observing the element. However,
		// removing this is fairly breaking for screenshot tests, so we're leaving it here for now.
		afterNextRender(realign, { injector: this._injector });

		// On dir change or resize, realign the ink bar and update the orientation of
		// the key manager if the direction has changed.
		merge(dirChange, viewportResize, resize, this._itemsChanges, this._itemsResized())
			.pipe(takeUntil(this._destroyed))
			.subscribe(() => {
				// We need to defer this to give the browser some time to recalculate
				// the element dimensions. The call has to be wrapped in `NgZone.run`,
				// because the viewport change handler runs outside of Angular.
				this._ngZone.run(() => {
					Promise.resolve().then(() => {
						// Clamp the scroll distance, because it can change with the number of tabs.
						this._scrollDistance = Math.max(0, Math.min(this._getMaxScrollDistance(), this._scrollDistance));
						realign();
					});
				});
				this._keyManager.withHorizontalOrientation(this._getLayoutDirection());
			});

		// If there is a change in the focus key manager we need to emit the `indexFocused`
		// event in order to provide a public event that notifies about focus changes. Also we realign
		// the tabs container by scrolling the new focused tab into the visible section.
		this._keyManager.change.subscribe((newFocusIndex) => {
			this.indexFocused.emit(newFocusIndex);
			this._setTabFocus(newFocusIndex);
		});
	}

	/** Sends any changes that could affect the layout of the items. */
	private _itemsResized(): Observable<ResizeObserverEntry[]> {
		if (typeof ResizeObserver !== 'function') {
			return EMPTY;
		}

		return this._itemsChanges.pipe(
			startWith(this._items()),
			switchMap(
				(tabItems: ReadonlyArray<BrnPaginatedTabHeaderItem>) =>
					new Observable((observer: Observer<ResizeObserverEntry[]>) =>
						this._ngZone.runOutsideAngular(() => {
							const resizeObserver = new ResizeObserver((entries) => observer.next(entries));
							for (const tabItem of tabItems) {
								resizeObserver.observe(tabItem.elementRef.nativeElement);
							}
							return () => {
								resizeObserver.disconnect();
							};
						}),
					),
			),
			// Skip the first emit since the resize observer emits when an item
			// is observed for new items when the tab is already inserted
			skip(1),
			// Skip emissions where all the elements are invisible since we don't want
			// the header to try and re-render with invalid measurements. See #25574.
			filter((entries) => entries.some((e) => e.contentRect.width > 0 && e.contentRect.height > 0)),
		);
	}

	ngAfterContentChecked(): void {
		// If the number of tab labels have changed, check if scrolling should be enabled
		if (this._tabLabelCount !== this._items().length) {
			this.updatePagination();
			this._tabLabelCount = this._items().length;
			this._changeDetectorRef.markForCheck();
		}

		// If the selected index has changed, scroll to the label and check if the scrolling controls
		// should be disabled.
		if (this._selectedIndexChanged) {
			this._scrollToLabel(this._selectedIndex());
			this._checkScrollingControls();
			this._selectedIndexChanged = false;
			this._changeDetectorRef.markForCheck();
		}

		// If the scroll distance has been changed (tab selected, focused, scroll controls activated),
		// then translate the header to reflect this.
		if (this._scrollDistanceChanged) {
			this._updateTabScrollPosition();
			this._scrollDistanceChanged = false;
			this._changeDetectorRef.markForCheck();
		}
	}

	ngOnDestroy() {
		this._keyManager?.destroy();
		this._destroyed.next();
		this._destroyed.complete();
		this._stopScrolling.complete();
	}

	/** Handles keyboard events on the header. */
	_handleKeydown(event: KeyboardEvent) {
		// We don't handle any key bindings with a modifier key.
		if (hasModifierKey(event)) {
			return;
		}

		switch (event.keyCode) {
			case ENTER:
			case SPACE:
				if (this.focusIndex !== this._selectedIndex()) {
					const item = this._items()[this.focusIndex];

					if (item && !item.disabled) {
						this.selectFocusedIndex.emit(this.focusIndex);
						this._itemSelected(event);
					}
				}
				break;
			default:
				this._keyManager.onKeydown(event);
		}
	}

	/**
	 * Callback for when the MutationObserver detects that the content has changed.
	 */
	_onContentChanges() {
		const textContent = this._elementRef.nativeElement.textContent;

		// We need to diff the text content of the header, because the MutationObserver callback
		// will fire even if the text content didn't change which is inefficient and is prone
		// to infinite loops if a poorly constructed expression is passed in (see #14249).
		if (textContent !== this._currentTextContent) {
			this._currentTextContent = textContent || '';

			// The content observer runs outside the `NgZone` by default, which
			// means that we need to bring the callback back in ourselves.
			this._ngZone.run(() => {
				this.updatePagination();
				this._changeDetectorRef.markForCheck();
			});
		}
	}

	/**
	 * Updates the view whether pagination should be enabled or not.
	 *
	 * WARNING: Calling this method can be very costly in terms of performance. It should be called
	 * as infrequently as possible from outside of the Tabs component as it causes a reflow of the
	 * page.
	 */
	updatePagination() {
		this._checkPaginationEnabled();
		this._checkScrollingControls();
		this._updateTabScrollPosition();
	}

	/** Tracks which element has focus; used for keyboard navigation */
	public get focusIndex(): number {
		return this._keyManager ? (this._keyManager.activeItemIndex ?? 0) : 0;
	}

	/** When the focus index is set, we must manually send focus to the correct label */
	public set focusIndex(value: number) {
		if (!this._isValidIndex(value) || this.focusIndex === value || !this._keyManager) {
			return;
		}

		this._keyManager.setActiveItem(value);
	}

	/**
	 * Determines if an index is valid.  If the tabs are not ready yet, we assume that the user is
	 * providing a valid index and return true.
	 */
	_isValidIndex(index: number): boolean {
		return this._items() ? !!this._items()[index] : true;
	}

	/**
	 * Sets focus on the HTML element for the label wrapper and scrolls it into the view if
	 * scrolling is enabled.
	 */
	_setTabFocus(tabIndex: number) {
		if (this._showPaginationControls()) {
			this._scrollToLabel(tabIndex);
		}

		if (this._items()?.length) {
			this._items()[tabIndex].focus();

			// Do not let the browser manage scrolling to focus the element, this will be handled
			// by using translation. In LTR, the scroll left should be 0. In RTL, the scroll width
			// should be the full width minus the offset width.
			const containerEl = this._tabListContainer().nativeElement;
			const dir = this._getLayoutDirection();

			if (dir === 'ltr') {
				containerEl.scrollLeft = 0;
			} else {
				containerEl.scrollLeft = containerEl.scrollWidth - containerEl.offsetWidth;
			}
		}
	}

	/** The layout direction of the containing app. */
	_getLayoutDirection(): Direction {
		return this._dir && this._dir.value === 'rtl' ? 'rtl' : 'ltr';
	}

	/** Performs the CSS transformation on the tab list that will cause the list to scroll. */
	_updateTabScrollPosition() {
		if (this.disablePagination()) {
			return;
		}

		const scrollDistance = this.scrollDistance;
		const translateX = this._getLayoutDirection() === 'ltr' ? -scrollDistance : scrollDistance;

		// Don't use `translate3d` here because we don't want to create a new layer. A new layer
		// seems to cause flickering and overflow in Internet Explorer. For example, the ink bar
		// and ripples will exceed the boundaries of the visible tab bar.
		// See: https://github.com/angular/components/issues/10276
		// We round the `transform` here, because transforms with sub-pixel precision cause some
		// browsers to blur the content of the element.
		this._tabList().nativeElement.style.transform = `translateX(${Math.round(translateX)}px)`;

		// Setting the `transform` on IE will change the scroll offset of the parent, causing the
		// position to be thrown off in some cases. We have to reset it ourselves to ensure that
		// it doesn't get thrown off. Note that we scope it only to IE and Edge, because messing
		// with the scroll position throws off Chrome 71+ in RTL mode (see #14689).
		if (this._platform.TRIDENT || this._platform.EDGE) {
			this._tabListContainer().nativeElement.scrollLeft = 0;
		}
	}

	/** Sets the distance in pixels that the tab header should be transformed in the X-axis. */
	public get scrollDistance(): number {
		return this._scrollDistance;
	}
	public set scrollDistance(value: number) {
		this._scrollTo(value);
	}

	/**
	 * Moves the tab list in the 'before' or 'after' direction (towards the beginning of the list or
	 * the end of the list, respectively). The distance to scroll is computed to be a third of the
	 * length of the tab list view window.
	 *
	 * This is an expensive call that forces a layout reflow to compute box and scroll metrics and
	 * should be called sparingly.
	 */
	_scrollHeader(direction: ScrollDirection) {
		const viewLength = this._tabListContainer().nativeElement.offsetWidth;

		// Move the scroll distance one-third the length of the tab list's viewport.
		const scrollAmount = ((direction === 'before' ? -1 : 1) * viewLength) / 3;

		return this._scrollTo(this._scrollDistance + scrollAmount);
	}

	/** Handles click events on the pagination arrows. */
	_handlePaginatorClick(direction: ScrollDirection) {
		this._stopInterval();
		this._scrollHeader(direction);
	}

	/**
	 * Moves the tab list such that the desired tab label (marked by index) is moved into view.
	 *
	 * This is an expensive call that forces a layout reflow to compute box and scroll metrics and
	 * should be called sparingly.
	 */
	_scrollToLabel(labelIndex: number) {
		if (this.disablePagination()) {
			return;
		}

		const selectedLabel = this._items() ? this._items()[labelIndex] : null;

		if (!selectedLabel) {
			return;
		}

		// The view length is the visible width of the tab labels.
		const viewLength = this._tabListContainer().nativeElement.offsetWidth;
		const { offsetLeft, offsetWidth } = selectedLabel.elementRef.nativeElement;

		let labelBeforePos: number;
		let labelAfterPos: number;
		if (this._getLayoutDirection() === 'ltr') {
			labelBeforePos = offsetLeft;
			labelAfterPos = labelBeforePos + offsetWidth;
		} else {
			labelAfterPos = this._tabListInner().nativeElement.offsetWidth - offsetLeft;
			labelBeforePos = labelAfterPos - offsetWidth;
		}

		const beforeVisiblePos = this.scrollDistance;
		const afterVisiblePos = this.scrollDistance + viewLength;

		if (labelBeforePos < beforeVisiblePos) {
			// Scroll header to move label to the before direction
			this.scrollDistance -= beforeVisiblePos - labelBeforePos;
		} else if (labelAfterPos > afterVisiblePos) {
			// Scroll header to move label to the after direction
			this.scrollDistance += Math.min(labelAfterPos - afterVisiblePos, labelBeforePos - beforeVisiblePos);
		}
	}

	/**
	 * Evaluate whether the pagination controls should be displayed. If the scroll width of the
	 * tab list is wider than the size of the header container, then the pagination controls should
	 * be shown.
	 *
	 * This is an expensive call that forces a layout reflow to compute box and scroll metrics and
	 * should be called sparingly.
	 */
	_checkPaginationEnabled() {
		if (this.disablePagination()) {
			this._showPaginationControls.set(false);
		} else {
			const isEnabled = this._tabListInner().nativeElement.scrollWidth > this._elementRef.nativeElement.offsetWidth;

			if (!isEnabled) {
				this.scrollDistance = 0;
			}

			if (isEnabled !== this._showPaginationControls()) {
				this._changeDetectorRef.markForCheck();
			}

			this._showPaginationControls.set(isEnabled);
		}
	}

	/**
	 * Evaluate whether the before and after controls should be enabled or disabled.
	 * If the header is at the beginning of the list (scroll distance is equal to 0) then disable the
	 * before button. If the header is at the end of the list (scroll distance is equal to the
	 * maximum distance we can scroll), then disable the after button.
	 *
	 * This is an expensive call that forces a layout reflow to compute box and scroll metrics and
	 * should be called sparingly.
	 */
	_checkScrollingControls() {
		if (this.disablePagination()) {
			this._disableScrollAfter = this._disableScrollBefore = true;
		} else {
			// Check if the pagination arrows should be activated.
			this._disableScrollBefore = this.scrollDistance === 0;
			this._disableScrollAfter = this.scrollDistance === this._getMaxScrollDistance();
			this._changeDetectorRef.markForCheck();
		}
	}

	/**
	 * Determines what is the maximum length in pixels that can be set for the scroll distance. This
	 * is equal to the difference in width between the tab list container and tab header container.
	 *
	 * This is an expensive call that forces a layout reflow to compute box and scroll metrics and
	 * should be called sparingly.
	 */
	_getMaxScrollDistance(): number {
		const lengthOfTabList = this._tabListInner().nativeElement.scrollWidth;
		const viewLength = this._tabListContainer().nativeElement.offsetWidth;
		return lengthOfTabList - viewLength || 0;
	}

	/** Stops the currently-running paginator interval.  */
	_stopInterval() {
		this._stopScrolling.next();
	}

	/**
	 * Handles the user pressing down on one of the paginators.
	 * Starts scrolling the header after a certain amount of time.
	 * @param direction In which direction the paginator should be scrolled.
	 */
	_handlePaginatorPress(direction: ScrollDirection, mouseEvent?: MouseEvent) {
		// Don't start auto scrolling for right mouse button clicks. Note that we shouldn't have to
		// null check the `button`, but we do it so we don't break tests that use fake events.
		if (mouseEvent && mouseEvent.button !== null && mouseEvent.button !== 0) {
			return;
		}

		// Avoid overlapping timers.
		this._stopInterval();

		// Start a timer after the delay and keep firing based on the interval.
		timer(HEADER_SCROLL_DELAY, HEADER_SCROLL_INTERVAL)
			// Keep the timer going until something tells it to stop or the component is destroyed.
			.pipe(takeUntil(merge(this._stopScrolling, this._destroyed)))
			.subscribe(() => {
				const { maxScrollDistance, distance } = this._scrollHeader(direction);

				// Stop the timer if we've reached the start or the end.
				if (distance === 0 || distance >= maxScrollDistance) {
					this._stopInterval();
				}
			});
	}

	/**
	 * Scrolls the header to a given position.
	 * @param position Position to which to scroll.
	 * @returns Information on the current scroll distance and the maximum.
	 */
	private _scrollTo(position: number) {
		if (this.disablePagination()) {
			return { maxScrollDistance: 0, distance: 0 };
		}

		const maxScrollDistance = this._getMaxScrollDistance();
		this._scrollDistance = Math.max(0, Math.min(maxScrollDistance, position));

		// Mark that the scroll distance has changed so that after the view is checked, the CSS
		// transformation can move the header.
		this._scrollDistanceChanged = true;
		this._checkScrollingControls();

		return { maxScrollDistance, distance: this._scrollDistance };
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tabs/src/lib/brn-tabs-trigger.directive.ts
```typescript
import {
	Directive,
	ElementRef,
	Input,
	computed,
	effect,
	inject,
	input,
	model,
	output,
	signal,
	untracked,
} from '@angular/core';

@Directive({
	selector: '[brnTabsContent]',
	standalone: true,
	host: {
		role: 'tabpanel',
		tabindex: '0',
		'[id]': 'contentId()',
		'[attr.aria-labelledby]': 'labelId()',
		'[hidden]': '_isSelected() === false',
	},
	exportAs: 'brnTabsContent',
})
export class BrnTabsContentDirective {
	private readonly _root = inject(BrnTabsDirective);
	private readonly _elementRef = inject(ElementRef);

	public readonly contentFor = input.required<string>({ alias: 'brnTabsContent' });
	protected readonly _isSelected = computed(() => this._root.$activeTab() === this.contentFor());
	protected contentId = computed(() => `brn-tabs-content-${this.contentFor()}`);
	protected labelId = computed(() => `brn-tabs-label-${this.contentFor()}`);

	constructor() {
		effect(() => {
			const contentFor = this.contentFor();
			untracked(() => this._root.registerContent(contentFor, this));
		});
	}

	public focus() {
		this._elementRef.nativeElement.focus();
	}
}

export type BrnTabsOrientation = 'horizontal' | 'vertical';
export type BrnTabsDirection = 'ltr' | 'rtl';
export type BrnActivationMode = 'automatic' | 'manual';

@Directive({
	selector: '[brnTabs]',
	standalone: true,
	host: {
		'[attr.data-orientation]': 'orientation()',
		'[attr.dir]': 'direction()',
	},
	exportAs: 'brnTabs',
})
export class BrnTabsDirective {
	public readonly orientation = input<BrnTabsOrientation>('horizontal');
	/** internal **/
	public $orientation = this.orientation;

	public readonly direction = input<BrnTabsDirection>('ltr');
	/** internal **/
	public $direction = this.direction;

	public readonly _activeTab = model<string | undefined>(undefined, { alias: 'brnTabs' });
	/** internal **/
	public $activeTab = this._activeTab.asReadonly();

	public readonly activationMode = input<BrnActivationMode>('automatic');
	/** internal **/
	public $activationMode = this.activationMode;

	public readonly tabActivated = output<string>();

	private readonly _tabs = signal<{
		[key: string]: { trigger: BrnTabsTriggerDirective; content: BrnTabsContentDirective };
	}>({});
	public readonly $tabs = this._tabs.asReadonly();

	public registerTrigger(key: string, trigger: BrnTabsTriggerDirective) {
		this._tabs.update((tabs) => ({ ...tabs, [key]: { trigger, content: tabs[key]?.content } }));
	}

	public registerContent(key: string, content: BrnTabsContentDirective) {
		this._tabs.update((tabs) => ({ ...tabs, [key]: { trigger: tabs[key]?.trigger, content } }));
	}

	emitTabActivated(key: string) {
		this.tabActivated.emit(key);
	}

	setActiveTab(key: string) {
		this._activeTab.set(key);
	}
}

@Directive({
	selector: 'button[brnTabsTrigger]',
	standalone: true,
	host: {
		'[id]': 'labelId()',
		type: 'button',
		role: 'tab',
		'[tabindex]': 'selected() ? "0": "-1"',
		'[attr.aria-selected]': 'selected()',
		'[attr.aria-controls]': 'contentId()',
		'[attr.data-state]': "selected() ? 'active' : 'inactive'",
		'[attr.data-orientation]': '_orientation()',
		'[attr.data-disabled]': "disabled ? '' : undefined",
		'(click)': 'activate()',
	},
	exportAs: 'brnTabsTrigger',
})
export class BrnTabsTriggerDirective {
	public readonly elementRef = inject(ElementRef);

	private readonly _root = inject(BrnTabsDirective);

	protected readonly _orientation = this._root.$orientation;

	public readonly triggerFor = input.required<string>({ alias: 'brnTabsTrigger' });
	public readonly selected = computed(() => this._root.$activeTab() === this.triggerFor());
	protected readonly contentId = computed(() => `brn-tabs-content-${this.triggerFor()}`);
	protected readonly labelId = computed(() => `brn-tabs-label-${this.triggerFor()}`);

	// leaving this as an @input to be compatible with the `FocusKeyManager` used in the `BrnTabsListDirective`
	@Input()
	public disabled = false;

	constructor() {
		effect(() => {
			const triggerFor = this.triggerFor();
			untracked(() => this._root.registerTrigger(triggerFor, this));
		});
	}

	public focus() {
		this.elementRef.nativeElement.focus();
		if (this._root.$activationMode() === 'automatic') {
			this.activate();
		}
	}

	public activate() {
		if (!this.triggerFor()) return;
		this._root.setActiveTab(this.triggerFor());
		this._root.emitTabActivated(this.triggerFor());
	}

	public get key(): string | undefined {
		return this.triggerFor();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/date-time/README.md
```
# @spartan-ng/brain/date-time

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/date-time`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/date-time/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/date-time/src/index.ts
```typescript
export * from './lib/date-adapter';
export * from './lib/native-date-adapter';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/date-time/src/lib/date-adapter.ts
```typescript
import { ClassProvider, InjectionToken, Type, inject } from '@angular/core';
import { BrnNativeDateAdapter } from './native-date-adapter';

/**
 * An abstraction that can be used to create and modify date time objects
 * immutably regardless of the underlying implementation.
 */
export interface BrnDateAdapter<T> {
	/**
	 * Create a new date time object.
	 */
	create(values: BrnDateUnits): T;

	/**
	 * Create a new date with the current date and time.
	 */
	now(): T;

	/**
	 * Set the year of the date time object based on a duration.
	 */
	set(date: T, values: BrnDateUnits): T;

	/**
	 * Add a duration to the date time object.
	 */
	add(date: T, duration: BrnDuration): T;

	/**
	 * Subtract a duration from the date time object.
	 */
	subtract(date: T, duration: BrnDuration): T;

	/**
	 * Compare two date time objects.
	 */
	compare(a: T, b: T): number;

	/**
	 * Determine if two date time objects are equal.
	 */
	isEqual(a: T, b: T): boolean;

	/**
	 * Determine if a date time object is before another.
	 */
	isBefore(a: T, b: T): boolean;

	/**
	 * Determine if a date time object is after another.
	 */
	isAfter(a: T, b: T): boolean;

	/**
	 * Determine if two date objects are on the same day.
	 */
	isSameDay(a: T, b: T): boolean;

	/**
	 * Determine if two date objects are on the same month.
	 */
	isSameMonth(a: T, b: T): boolean;

	/**
	 * Determine if two date objects are on the same year.
	 */
	isSameYear(a: T, b: T): boolean;

	/**
	 * Get the year.
	 */
	getYear(date: T): number;

	/**
	 * Get the month.
	 */
	getMonth(date: T): number;

	/**
	 * Get the date.
	 */
	getDate(date: T): number;

	/**
	 * Get the day.
	 */
	getDay(date: T): number;

	/**
	 * Get the hours.
	 */
	getHours(date: T): number;

	/**
	 * Get the minutes.
	 */
	getMinutes(date: T): number;

	/**
	 * Get the seconds.
	 */
	getSeconds(date: T): number;

	/**
	 * Get the milliseconds.
	 */
	getMilliseconds(date: T): number;

	/**
	 * Get the time.
	 */
	getTime(date: T): number;

	/**
	 * Get the first day of the month.
	 */
	startOfMonth(date: T): T;

	/**
	 * Get the last day of the month.
	 */
	endOfMonth(date: T): T;

	/**
	 * Get the start of the day.
	 */
	startOfDay(date: T): T;

	/**
	 * Get the end of the day.
	 */
	endOfDay(date: T): T;
}

export interface BrnDateUnits {
	/**
	 * The year.
	 */
	year?: number;

	/**
	 * The month.
	 */
	month?: number;

	/**
	 * The day.
	 */
	day?: number;

	/**
	 * The hour.
	 */
	hour?: number;

	/**
	 * The minute.
	 */
	minute?: number;

	/**
	 * The second.
	 */
	second?: number;

	/**
	 * The millisecond.
	 */
	millisecond?: number;
}

export interface BrnDuration {
	/**
	 * The years.
	 */
	years?: number;

	/**
	 * The months.
	 */
	months?: number;

	/**
	 * The days.
	 */
	days?: number;

	/**
	 * The hours.
	 */
	hours?: number;

	/**
	 * The minutes.
	 */
	minutes?: number;

	/**
	 * The seconds.
	 */
	seconds?: number;

	/**
	 * The milliseconds.
	 */
	milliseconds?: number;
}

export const BrnDateAdapterToken = new InjectionToken<BrnDateAdapter<unknown>>('BrnDateAdapterToken');

/**
 * Inject the DateAdapter instance
 */
export function injectDateAdapter<T>(): BrnDateAdapter<T> {
	return (inject(BrnDateAdapterToken, { optional: true }) as BrnDateAdapter<T>) ?? new BrnNativeDateAdapter();
}

/**
 * Provide the DateAdapter instance
 */
export function provideDateAdapter<T>(adapter: Type<BrnDateAdapter<T>>): ClassProvider {
	return { provide: BrnDateAdapterToken, useClass: adapter };
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/date-time/src/lib/native-date-adapter.ts
```typescript
import type { BrnDateAdapter, BrnDateUnits, BrnDuration } from './date-adapter';

export class BrnNativeDateAdapter implements BrnDateAdapter<Date> {
	/**
	 * Create a new date time object.
	 */
	create({ day, hour, minute, month, second, year, millisecond }: BrnDateUnits): Date {
		const now = new Date();

		return new Date(
			year ?? now.getFullYear(),
			month ?? now.getMonth(),
			day ?? now.getDate(),
			hour ?? now.getHours(),
			minute ?? now.getMinutes(),
			second ?? now.getSeconds(),
			millisecond ?? now.getMilliseconds(),
		);
	}

	/**
	 * Create a new date with the current date and time.
	 */
	now(): Date {
		return new Date();
	}

	/**
	 * Set the year of the date time object based on a duration.
	 */
	set(date: Date, values: BrnDateUnits): Date {
		return new Date(
			values.year ?? date.getFullYear(),
			values.month ?? date.getMonth(),
			values.day ?? date.getDate(),
			values.hour ?? date.getHours(),
			values.minute ?? date.getMinutes(),
			values.second ?? date.getSeconds(),
			values.millisecond ?? date.getMilliseconds(),
		);
	}

	/**
	 * Add a duration to the date time object.
	 */
	add(date: Date, duration: BrnDuration): Date {
		return new Date(
			date.getFullYear() + (duration.years ?? 0),
			date.getMonth() + (duration.months ?? 0),
			date.getDate() + (duration.days ?? 0),
			date.getHours() + (duration.hours ?? 0),
			date.getMinutes() + (duration.minutes ?? 0),
			date.getSeconds() + (duration.seconds ?? 0),
			date.getMilliseconds() + (duration.milliseconds ?? 0),
		);
	}

	/**
	 * Subtract a duration from the date time object
	 */
	subtract(date: Date, duration: BrnDuration): Date {
		return new Date(
			date.getFullYear() - (duration.years ?? 0),
			date.getMonth() - (duration.months ?? 0),
			date.getDate() - (duration.days ?? 0),
			date.getHours() - (duration.hours ?? 0),
			date.getMinutes() - (duration.minutes ?? 0),
			date.getSeconds() - (duration.seconds ?? 0),
			date.getMilliseconds() - (duration.milliseconds ?? 0),
		);
	}

	/**
	 * Compare two date time objects
	 */
	compare(a: Date, b: Date): number {
		const diff = a.getTime() - b.getTime();
		return diff === 0 ? 0 : diff > 0 ? 1 : -1;
	}

	/**
	 * Determine if two date time objects are equal.
	 */
	isEqual(a: Date, b: Date): boolean {
		return a.getTime() === b.getTime();
	}

	/**
	 * Determine if a date time object is before another.
	 */
	isBefore(a: Date, b: Date): boolean {
		return a.getTime() < b.getTime();
	}

	/**
	 * Determine if a date time object is after another.
	 */
	isAfter(a: Date, b: Date): boolean {
		return a.getTime() > b.getTime();
	}

	/**
	 * Determine if two date objects are on the same day.
	 */
	isSameDay(a: Date, b: Date): boolean {
		return this.isSameYear(a, b) && this.isSameMonth(a, b) && a.getDate() === b.getDate();
	}

	/**
	 * Determine if two date objects are on the same month.
	 */
	isSameMonth(a: Date, b: Date): boolean {
		return this.isSameYear(a, b) && a.getMonth() === b.getMonth();
	}

	/**
	 * Determine if two date objects are on the same year.
	 */
	isSameYear(a: Date, b: Date): boolean {
		return a.getFullYear() === b.getFullYear();
	}

	/**
	 * Get the year.
	 */
	getYear(date: Date): number {
		return date.getFullYear();
	}

	/**
	 * Get the month.
	 */
	getMonth(date: Date): number {
		return date.getMonth();
	}

	/**
	 * Get the day.
	 */
	getDay(date: Date): number {
		return date.getDay();
	}

	/**
	 * Get the date.
	 */
	getDate(date: Date): number {
		return date.getDate();
	}

	/**
	 * Get the hours.
	 */
	getHours(date: Date): number {
		return date.getHours();
	}

	/**
	 * Get the minutes.
	 */
	getMinutes(date: Date): number {
		return date.getMinutes();
	}

	/**
	 * Get the seconds.
	 */
	getSeconds(date: Date): number {
		return date.getSeconds();
	}

	/**
	 * Get the milliseconds.
	 */
	getMilliseconds(date: Date): number {
		return date.getMilliseconds();
	}

	/**
	 * Get the first day of the month.
	 */
	startOfMonth(date: Date): Date {
		return new Date(date.getFullYear(), date.getMonth(), 1);
	}

	/**
	 * Get the last day of the month.
	 */
	endOfMonth(date: Date): Date {
		return new Date(date.getFullYear(), date.getMonth() + 1, 0);
	}

	/**
	 * Get the start of the day.
	 */
	startOfDay(date: Date): Date {
		return new Date(date.getFullYear(), date.getMonth(), date.getDate());
	}

	/**
	 * Get the end of the day.
	 */
	endOfDay(date: Date): Date {
		return new Date(date.getFullYear(), date.getMonth(), date.getDate(), 23, 59, 59, 999);
	}

	/**
	 * Get the time.
	 */
	getTime(date: Date): number {
		return date.getTime();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tooltip/README.md
```
# @spartan-ng/brain/tooltip

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/tooltip`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tooltip/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tooltip/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { BrnTooltipContentComponent } from './lib/brn-tooltip-content.component';
import { BrnTooltipContentDirective } from './lib/brn-tooltip-content.directive';
import { BrnTooltipTriggerDirective } from './lib/brn-tooltip-trigger.directive';
import { BrnTooltipDirective } from './lib/brn-tooltip.directive';

export * from './lib/brn-tooltip-content.component';
export * from './lib/brn-tooltip-content.directive';
export * from './lib/brn-tooltip-trigger.directive';
export * from './lib/brn-tooltip.directive';
export * from './lib/brn-tooltip.token';

export const BrnTooltipImports = [
	BrnTooltipDirective,
	BrnTooltipContentDirective,
	BrnTooltipTriggerDirective,
	BrnTooltipContentComponent,
] as const;

@NgModule({
	imports: [...BrnTooltipImports],
	exports: [...BrnTooltipImports],
})
export class BrnTooltipModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tooltip/src/lib/brn-tooltip-content.component.ts
```typescript
/**
 * We are building on shoulders of giants here and adapt the implementation provided by the incredible Angular
 * team: https://github.com/angular/components/blob/main/src/material/tooltip/tooltip.ts
 * Check them out! Give them a try! Leave a star! Their work is incredible!
 */

import { isPlatformBrowser, NgTemplateOutlet } from '@angular/common';
import {
	ChangeDetectionStrategy,
	ChangeDetectorRef,
	Component,
	ElementRef,
	inject,
	type OnDestroy,
	PLATFORM_ID,
	Renderer2,
	signal,
	type TemplateRef,
	viewChild,
	ViewEncapsulation,
} from '@angular/core';
import { Subject } from 'rxjs';

/**
 * Internal component that wraps the tooltip's content.
 * @docs-private
 */
@Component({
	selector: 'brn-tooltip-content',
	template: `
		<div
			(mouseenter)="_contentHovered.set(true)"
			(mouseleave)="_contentHovered.set(false)"
			[class]="_tooltipClasses()"
			[style.visibility]="'hidden'"
			#tooltip
		>
			@if (_isTypeOfString(content)) {
				{{ content }}
			} @else {
				<ng-container [ngTemplateOutlet]="content" />
			}
		</div>
	`,
	encapsulation: ViewEncapsulation.None,
	changeDetection: ChangeDetectionStrategy.OnPush,
	host: {
		// Forces the element to have a layout in IE and Edge. This fixes issues where the element
		// won't be rendered if the animations are disabled or there is no web animations polyfill.
		'[style.zoom]': 'isVisible() ? 1 : null',
		'(mouseleave)': '_handleMouseLeave($event)',
		'aria-hidden': 'true',
	},
	imports: [NgTemplateOutlet],
})
export class BrnTooltipContentComponent implements OnDestroy {
	private readonly _cdr = inject(ChangeDetectorRef);
	private readonly _isBrowser = isPlatformBrowser(inject(PLATFORM_ID));
	private readonly _renderer2 = inject(Renderer2);

	protected readonly _contentHovered = signal(false);

	public readonly _tooltipClasses = signal('');
	public readonly side = signal('above');
	/** Message to display in the tooltip */
	public content: string | TemplateRef<unknown> | null = null;

	/** The timeout ID of any current timer set to show the tooltip */
	private _showTimeoutId: ReturnType<typeof setTimeout> | undefined;
	/** The timeout ID of any current timer set to hide the tooltip */
	private _hideTimeoutId: ReturnType<typeof setTimeout> | undefined;
	/** The timeout ID of any current timer set to animate the tooltip */
	private _animateTimeoutId: ReturnType<typeof setTimeout> | undefined;

	/** Element that caused the tooltip to open. */
	public _triggerElement?: HTMLElement;

	/** Amount of milliseconds to delay the closing sequence. */
	public _mouseLeaveHideDelay = 0;
	/** Amount of milliseconds of closing animation. */
	public _exitAnimationDuration = 0;

	/** Reference to the internal tooltip element. */
	public _tooltip = viewChild('tooltip', { read: ElementRef<HTMLElement> });

	/** Whether interactions on the page should close the tooltip */
	private _closeOnInteraction = false;

	/** Whether the tooltip is currently visible. */
	private _isVisible = false;

	/** Subject for notifying that the tooltip has been hidden from the view */
	private readonly _onHide: Subject<void> = new Subject();
	public readonly afterHidden = this._onHide.asObservable();

	/**
	 * Shows the tooltip with originating from the provided origin
	 * @param delay Amount of milliseconds to the delay showing the tooltip.
	 */
	show(delay: number): void {
		// Cancel the delayed hide if it is scheduled
		if (this._hideTimeoutId !== null) {
			clearTimeout(this._hideTimeoutId);
		}
		if (this._animateTimeoutId !== null) {
			clearTimeout(this._animateTimeoutId);
		}
		this._showTimeoutId = setTimeout(() => {
			this._toggleDataAttributes(true, this.side());
			this._toggleVisibility(true);
			this._showTimeoutId = undefined;
		}, delay);
	}

	/**
	 * Begins to hide the tooltip after the provided delay in ms.
	 * @param delay Amount of milliseconds to delay hiding the tooltip.
	 * @param exitAnimationDuration Time before hiding to finish animation
	 * */
	hide(delay: number, exitAnimationDuration: number): void {
		// Cancel the delayed show if it is scheduled
		if (this._showTimeoutId !== null) {
			clearTimeout(this._showTimeoutId);
		}
		// start out animation at delay minus animation delay or immediately if possible
		this._animateTimeoutId = setTimeout(
			() => {
				this._animateTimeoutId = undefined;
				if (this._contentHovered()) return;
				this._toggleDataAttributes(false, this.side());
			},
			Math.max(delay, 0),
		);
		this._hideTimeoutId = setTimeout(() => {
			this._hideTimeoutId = undefined;
			if (this._contentHovered()) return;
			this._toggleVisibility(false);
		}, delay + exitAnimationDuration);
	}

	/** Whether the tooltip is being displayed. */
	isVisible(): boolean {
		return this._isVisible;
	}

	ngOnDestroy() {
		this._cancelPendingAnimations();
		this._onHide.complete();
		this._triggerElement = undefined;
	}

	_isTypeOfString(content: unknown): content is string {
		return typeof content === 'string';
	}

	/**
	 * Interactions on the HTML body should close the tooltip immediately as defined in the
	 * material design spec.
	 * https://material.io/design/components/tooltips.html#behavior
	 */
	_handleBodyInteraction(): void {
		if (this._closeOnInteraction) {
			this.hide(0, 0);
		}
	}

	/**
	 * Marks that the tooltip needs to be checked in the next change detection run.
	 * Mainly used for rendering the initial text before positioning a tooltip, which
	 * can be problematic in components with OnPush change detection.
	 */
	_markForCheck(): void {
		this._cdr.markForCheck();
	}

	_handleMouseLeave({ relatedTarget }: MouseEvent) {
		if (!relatedTarget || !this._triggerElement?.contains(relatedTarget as Node)) {
			if (this.isVisible()) {
				this.hide(this._mouseLeaveHideDelay, this._exitAnimationDuration);
			} else {
				this._finalize(false);
			}
		}
		this._contentHovered.set(false);
	}

	/** Cancels any pending animation sequences. */
	_cancelPendingAnimations() {
		if (this._showTimeoutId !== null) {
			clearTimeout(this._showTimeoutId);
		}

		if (this._hideTimeoutId !== null) {
			clearTimeout(this._hideTimeoutId);
		}

		this._showTimeoutId = this._hideTimeoutId = undefined;
	}

	private _finalize(toVisible: boolean) {
		if (toVisible) {
			this._closeOnInteraction = true;
		} else if (!this.isVisible()) {
			this._onHide.next();
		}
	}

	/** Toggles the visibility of the tooltip element. */
	private _toggleVisibility(isVisible: boolean) {
		// We set the classes directly here ourselves so that toggling the tooltip state
		// isn't bound by change detection. This allows us to hide it even if the
		// view ref has been detached from the CD tree.
		const tooltip = this._tooltip()?.nativeElement;
		if (!tooltip || !this._isBrowser) return;
		this._renderer2.setStyle(tooltip, 'visibility', isVisible ? 'visible' : 'hidden');
		if (isVisible) {
			this._renderer2.removeStyle(tooltip, 'display');
		} else {
			this._renderer2.setStyle(tooltip, 'display', 'none');
		}
		this._isVisible = isVisible;
	}

	private _toggleDataAttributes(isVisible: boolean, side: string) {
		// We set the classes directly here ourselves so that toggling the tooltip state
		// isn't bound by change detection. This allows us to hide it even if the
		// view ref has been detached from the CD tree.
		const tooltip = this._tooltip()?.nativeElement;
		if (!tooltip || !this._isBrowser) return;
		this._renderer2.setAttribute(tooltip, 'data-side', side);
		this._renderer2.setAttribute(tooltip, 'data-state', isVisible ? 'open' : 'closed');
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tooltip/src/lib/brn-tooltip-content.directive.ts
```typescript
import { Directive, TemplateRef, inject } from '@angular/core';
import { BrnTooltipDirective } from './brn-tooltip.directive';

@Directive({
	selector: '[brnTooltipContent]',
	standalone: true,
})
export class BrnTooltipContentDirective {
	private readonly _brnTooltipDirective = inject(BrnTooltipDirective, { optional: true });
	private readonly _tpl = inject(TemplateRef);

	constructor() {
		if (!this._brnTooltipDirective || !this._tpl) return;
		this._brnTooltipDirective.tooltipTemplate.set(this._tpl);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tooltip/src/lib/brn-tooltip-trigger.directive.ts
```typescript
/**
 * We are building on shoulders of giants here and adapt the implementation provided by the incredible Angular
 * team: https://github.com/angular/components/blob/main/src/material/tooltip/tooltip.ts
 * Check them out! Give them a try! Leave a star! Their work is incredible!
 */

/**
 * @license
 * Copyright Google LLC All Rights Reserved.
 *
 * Use of this source code is governed by an MIT-style license that can be
 * found in the LICENSE file at https://angular.io/license
 */
import { AriaDescriber, FocusMonitor } from '@angular/cdk/a11y';
import { Directionality } from '@angular/cdk/bidi';
import { hasModifierKey } from '@angular/cdk/keycodes';
import {
	type ConnectedPosition,
	type ConnectionPositionPair,
	type FlexibleConnectedPositionStrategy,
	type HorizontalConnectionPos,
	type OriginConnectionPosition,
	Overlay,
	type OverlayConnectionPosition,
	type OverlayRef,
	ScrollDispatcher,
	type ScrollStrategy,
	type VerticalConnectionPos,
} from '@angular/cdk/overlay';
import { normalizePassiveListenerOptions, Platform } from '@angular/cdk/platform';
import { ComponentPortal } from '@angular/cdk/portal';
import { DOCUMENT } from '@angular/common';
import {
	type AfterViewInit,
	booleanAttribute,
	computed,
	Directive,
	effect,
	ElementRef,
	inject,
	InjectionToken,
	input,
	isDevMode,
	NgZone,
	numberAttribute,
	type OnDestroy,
	type Provider,
	signal,
	type TemplateRef,
	untracked,
	ViewContainerRef,
} from '@angular/core';
import { brnDevMode } from '@spartan-ng/brain/core';
import { Subject } from 'rxjs';
import { take, takeUntil } from 'rxjs/operators';
import { BrnTooltipContentComponent } from './brn-tooltip-content.component';
import { BrnTooltipDirective } from './brn-tooltip.directive';
import { injectBrnTooltipDefaultOptions } from './brn-tooltip.token';
import { computedPrevious } from './computed-previous';

export type TooltipPosition = 'left' | 'right' | 'above' | 'below' | 'before' | 'after';
export type TooltipTouchGestures = 'auto' | 'on' | 'off';

/** Time in ms to throttle repositioning after scroll events. */
export const SCROLL_THROTTLE_MS = 20;

export function getBrnTooltipInvalidPositionError(position: string) {
	return Error(`Tooltip position "${position}" is invalid.`);
}

/** Injection token that determines the scroll handling while a tooltip is visible. */
export const BRN_TOOLTIP_SCROLL_STRATEGY = new InjectionToken<() => ScrollStrategy>('brn-tooltip-scroll-strategy');
export const BRN_TOOLTIP_SCROLL_STRATEGY_FACTORY_PROVIDER: Provider = {
	provide: BRN_TOOLTIP_SCROLL_STRATEGY,
	deps: [Overlay],
	useFactory:
		(overlay: Overlay): (() => ScrollStrategy) =>
		() =>
			overlay.scrollStrategies.reposition({ scrollThrottle: SCROLL_THROTTLE_MS }),
};

const PANEL_CLASS = 'tooltip-panel';

/** Options used to bind passive event listeners. */
const passiveListenerOptions = normalizePassiveListenerOptions({ passive: true });

/**
 * Time between the user putting the pointer on a tooltip
 * trigger and the long press event being fired.
 */
const LONGPRESS_DELAY = 500;

// These constants were taken from MDC's `numbers` object.
const MIN_VIEWPORT_TOOLTIP_THRESHOLD = 8;
const UNBOUNDED_ANCHOR_GAP = 8;

@Directive({
	selector: '[brnTooltipTrigger]',
	standalone: true,
	exportAs: 'brnTooltipTrigger',
	providers: [BRN_TOOLTIP_SCROLL_STRATEGY_FACTORY_PROVIDER],
	host: {
		class: 'brn-tooltip-trigger',
		'[class.brn-tooltip-disabled]': 'brnTooltipDisabled()',
	},
})
export class BrnTooltipTriggerDirective implements OnDestroy, AfterViewInit {
	private readonly _tooltipDirective = inject(BrnTooltipDirective, { optional: true });
	private readonly _tooltipComponent = BrnTooltipContentComponent;
	private readonly _cssClassPrefix: string = 'brn';
	private readonly _destroyed = new Subject<void>();
	private readonly _passiveListeners: (readonly [string, EventListenerOrEventListenerObject])[] = [];
	private readonly _defaultOptions = injectBrnTooltipDefaultOptions();

	private readonly _overlay = inject(Overlay);
	private readonly _elementRef = inject(ElementRef<HTMLElement>);
	private readonly _scrollDispatcher = inject(ScrollDispatcher);
	private readonly _viewContainerRef = inject(ViewContainerRef);
	private readonly _ngZone = inject(NgZone);
	private readonly _platform = inject(Platform);
	private readonly _ariaDescriber = inject(AriaDescriber);
	private readonly _focusMonitor = inject(FocusMonitor);
	private readonly _dir = inject(Directionality);
	private readonly _scrollStrategy = inject(BRN_TOOLTIP_SCROLL_STRATEGY);
	private readonly _document = inject(DOCUMENT);

	private _portal?: ComponentPortal<BrnTooltipContentComponent>;
	private _viewInitialized = false;
	private _pointerExitEventsInitialized = false;
	private readonly _viewportMargin = 8;
	private _currentPosition?: TooltipPosition;
	private _touchstartTimeout?: ReturnType<typeof setTimeout>;

	private _overlayRef: OverlayRef | null = null;
	private _tooltipInstance: BrnTooltipContentComponent | null = null;

	/** Allows the user to define the position of the tooltip relative to the parent element */

	public readonly position = input<TooltipPosition>(this._defaultOptions?.position ?? 'above');

	/**
	 * Whether tooltip should be relative to the click or touch origin
	 * instead of outside the element bounding box.
	 */

	public readonly positionAtOrigin = input(this._defaultOptions?.positionAtOrigin ?? false, {
		transform: booleanAttribute,
	});

	/** Disables the display of the tooltip. */

	public readonly brnTooltipDisabled = input(false, { transform: booleanAttribute });

	/** The default delay in ms before showing the tooltip after show is called */

	public readonly showDelay = input(this._defaultOptions?.showDelay ?? 0, { transform: numberAttribute });

	/** The default delay in ms before hiding the tooltip after hide is called */

	public readonly hideDelay = input(this._defaultOptions?.hideDelay ?? 0, { transform: numberAttribute });

	/** The default duration in ms that exit animation takes before hiding */

	public readonly exitAnimationDuration = input(this._defaultOptions?.exitAnimationDuration ?? 0, {
		transform: numberAttribute,
	});

	/** The default delay in ms before hiding the tooltip after hide is called */

	public readonly _tooltipContentClasses = input<string>(this._defaultOptions?.tooltipContentClasses ?? '', {
		alias: 'tooltipContentClasses',
	});
	public readonly tooltipContentClasses = computed(() => signal(this._tooltipContentClasses()));

	/**
	 * How touch gestures should be handled by the tooltip. On touch devices the tooltip directive
	 * uses a long press gesture to show and hide, however it can conflict with the native browser
	 * gestures. To work around the conflict, Angular Material disables native gestures on the
	 * trigger, but that might not be desirable on particular elements (e.g. inputs and draggable
	 * elements). The different values for this option configure the touch event handling as follows:
	 * - `auto` - Enables touch gestures for all elements, but tries to avoid conflicts with native
	 *   browser gestures on particular elements. In particular, it allows text selection on inputs
	 *   and textareas, and preserves the native browser dragging on elements marked as `draggable`.
	 * - `on` - Enables touch gestures for all elements and disables native
	 *   browser gestures with no exceptions.
	 * - `off` - Disables touch gestures. Note that this will prevent the tooltip from
	 *   showing on touch devices.
	 */

	public readonly touchGestures = input<TooltipTouchGestures>(this._defaultOptions?.touchGestures ?? 'auto');

	/** The message to be used to describe the aria in the tooltip */

	public readonly _ariaDescribedBy = input('', { alias: 'aria-describedby' });
	public readonly ariaDescribedBy = computed(() => signal(this._ariaDescribedBy()));
	public readonly ariaDescribedByPrevious = computedPrevious(this.ariaDescribedBy);

	/** The content to be displayed in the tooltip */

	public readonly brnTooltipTrigger = input<string | TemplateRef<unknown> | null>(null);
	public readonly brnTooltipTriggerState = computed(() => {
		if (this._tooltipDirective) {
			return this._tooltipDirective.tooltipTemplate();
		}
		return this.brnTooltipTrigger();
	});

	constructor() {
		this._dir.change.pipe(takeUntil(this._destroyed)).subscribe(() => {
			if (this._overlayRef) {
				this._updatePosition(this._overlayRef);
			}
		});

		this._viewportMargin = MIN_VIEWPORT_TOOLTIP_THRESHOLD;

		this._initBrnTooltipTriggerEffect();
		this._initAriaDescribedByPreviousEffect();
		this._initTooltipContentClassesEffect();
		this._initPositionEffect();
		this._initPositionAtOriginEffect();
		this._initBrnTooltipDisabledEffect();
		this._initExitAnimationDurationEffect();
		this._initHideDelayEffect();
	}
	setTooltipContentClasses(tooltipContentClasses: string) {
		this.tooltipContentClasses().set(tooltipContentClasses);
	}
	setAriaDescribedBy(ariaDescribedBy: string) {
		this.ariaDescribedBy().set(ariaDescribedBy);
	}

	private _initPositionEffect(): void {
		effect(() => {
			if (this._overlayRef) {
				this._updatePosition(this._overlayRef);
				this._tooltipInstance?.show(0);
				this._overlayRef.updatePosition();
			}
		});
	}

	private _initBrnTooltipDisabledEffect(): void {
		effect(() => {
			if (this.brnTooltipDisabled()) {
				this.hide(0);
			} else {
				this._setupPointerEnterEventsIfNeeded();
			}
		});
	}

	private _initPositionAtOriginEffect(): void {
		effect(() => {
			// Needed that the effect got triggered
			// eslint-disable-next-line @typescript-eslint/naming-convention
			const _ = this.positionAtOrigin();
			this._detach();
			this._overlayRef = null;
		});
	}

	private _initTooltipContentClassesEffect(): void {
		effect(() => {
			if (this._tooltipInstance) {
				this._tooltipInstance._tooltipClasses.set(this.tooltipContentClasses()() ?? '');
			}
		});
	}

	private _initAriaDescribedByPreviousEffect(): void {
		effect(() => {
			const ariaDescribedBy = this.ariaDescribedBy()();
			this._ariaDescriber.removeDescription(
				this._elementRef.nativeElement,
				untracked(() => this.ariaDescribedByPrevious()()),
				'tooltip',
			);

			if (ariaDescribedBy && !this._isTooltipVisible()) {
				this._ngZone.runOutsideAngular(() => {
					// The `AriaDescriber` has some functionality that avoids adding a description if it's the
					// same as the `aria-label` of an element, however we can't know whether the tooltip trigger
					// has a data-bound `aria-label` or when it'll be set for the first time. We can avoid the
					// issue by deferring the description by a tick so Angular has time to set the `aria-label`.
					Promise.resolve().then(() => {
						this._ariaDescriber.describe(this._elementRef.nativeElement, ariaDescribedBy, 'tooltip');
					});
				});
			}
		});
	}

	private _initBrnTooltipTriggerEffect(): void {
		effect(() => {
			const brnTooltipTriggerState = this.brnTooltipTriggerState();
			const isTooltipVisible = this._isTooltipVisible();
			untracked(() => {
				if (!brnTooltipTriggerState && isTooltipVisible) {
					this.hide(0);
				} else {
					this._setupPointerEnterEventsIfNeeded();
					this._updateTooltipContent();
				}
			});
		});
	}

	private _initExitAnimationDurationEffect(): void {
		effect(() => {
			if (this._tooltipInstance) {
				this._tooltipInstance._exitAnimationDuration = this.exitAnimationDuration();
			}
		});
	}

	private _initHideDelayEffect(): void {
		effect(() => {
			if (this._tooltipInstance) {
				this._tooltipInstance._mouseLeaveHideDelay = this.hideDelay();
			}
		});
	}

	ngAfterViewInit(): void {
		// This needs to happen after view init so the initial values for all inputs have been set.
		this._viewInitialized = true;
		this._setupPointerEnterEventsIfNeeded();

		this._focusMonitor
			.monitor(this._elementRef)
			.pipe(takeUntil(this._destroyed))
			.subscribe((origin) => {
				// Note that the focus monitor runs outside the Angular zone.
				if (!origin) {
					this._ngZone.run(() => this.hide(0));
				} else if (origin === 'keyboard') {
					this._ngZone.run(() => this.show());
				}
			});

		if (brnDevMode && !this.ariaDescribedBy()) {
			console.warn('BrnTooltip: "aria-describedby" attribute is required for accessibility');
		}
	}

	/**
	 * Dispose the tooltip when destroyed.
	 */
	ngOnDestroy(): void {
		const nativeElement = this._elementRef.nativeElement;

		clearTimeout(this._touchstartTimeout);

		if (this._overlayRef) {
			this._overlayRef.dispose();
			this._tooltipInstance = null;
		}

		// Clean up the event listeners set in the constructor
		this._passiveListeners.forEach(([event, listener]) =>
			nativeElement.removeEventListener(event, listener, passiveListenerOptions),
		);
		this._passiveListeners.length = 0;

		this._destroyed.next();
		this._destroyed.complete();

		this._ariaDescriber.removeDescription(nativeElement, this.ariaDescribedBy()(), 'tooltip');
		this._focusMonitor.stopMonitoring(nativeElement);
	}

	/** Shows the tooltip after the delay in ms, defaults to tooltip-delay-show or 0ms if no input */
	show(delay: number = this.showDelay(), origin?: { x: number; y: number }): void {
		if (this.brnTooltipDisabled() || this._isTooltipVisible()) {
			this._tooltipInstance?._cancelPendingAnimations();
			return;
		}

		const overlayRef = this._createOverlay(origin);
		this._detach();
		this._portal = this._portal || new ComponentPortal(this._tooltipComponent, this._viewContainerRef);
		const instance = (this._tooltipInstance = overlayRef.attach(this._portal).instance);
		instance._triggerElement = this._elementRef.nativeElement;
		instance._mouseLeaveHideDelay = this.hideDelay();
		instance._tooltipClasses.set(this.tooltipContentClasses()());
		instance._exitAnimationDuration = this.exitAnimationDuration();
		instance.side.set(this._currentPosition ?? 'above');
		instance.afterHidden.pipe(takeUntil(this._destroyed)).subscribe(() => this._detach());
		this._updateTooltipContent();
		instance.show(delay);
	}

	/** Hides the tooltip after the delay in ms, defaults to tooltip-delay-hide or 0ms if no input */
	hide(delay: number = this.hideDelay(), exitAnimationDuration: number = this.exitAnimationDuration()): void {
		const instance = this._tooltipInstance;
		if (instance) {
			if (instance.isVisible()) {
				instance.hide(delay, exitAnimationDuration);
			} else {
				instance._cancelPendingAnimations();
				this._detach();
			}
		}
	}

	toggle(origin?: { x: number; y: number }): void {
		this._isTooltipVisible() ? this.hide() : this.show(undefined, origin);
	}

	_isTooltipVisible(): boolean {
		return !!this._tooltipInstance && this._tooltipInstance.isVisible();
	}

	private _createOverlay(origin?: { x: number; y: number }): OverlayRef {
		if (this._overlayRef) {
			const existingStrategy = this._overlayRef.getConfig().positionStrategy as FlexibleConnectedPositionStrategy;

			if ((!this.positionAtOrigin() || !origin) && existingStrategy._origin instanceof ElementRef) {
				return this._overlayRef;
			}

			this._detach();
		}

		const scrollableAncestors = this._scrollDispatcher.getAncestorScrollContainers(this._elementRef);

		// Create connected position strategy that listens for scroll events to reposition.
		const strategy = this._overlay
			.position()
			.flexibleConnectedTo(this.positionAtOrigin() ? origin || this._elementRef : this._elementRef)
			.withTransformOriginOn(`.${this._cssClassPrefix}-tooltip`)
			.withFlexibleDimensions(false)
			.withViewportMargin(this._viewportMargin)
			.withScrollableContainers(scrollableAncestors);

		strategy.positionChanges.pipe(takeUntil(this._destroyed)).subscribe((change) => {
			this._updateCurrentPositionClass(change.connectionPair);

			if (this._tooltipInstance) {
				if (change.scrollableViewProperties.isOverlayClipped && this._tooltipInstance.isVisible()) {
					// After position changes occur and the overlay is clipped by
					// a parent scrollable then close the tooltip.
					this._ngZone.run(() => this.hide(0));
				}
			}
		});

		this._overlayRef = this._overlay.create({
			direction: this._dir,
			positionStrategy: strategy,
			panelClass: `${this._cssClassPrefix}-${PANEL_CLASS}`,
			scrollStrategy: this._scrollStrategy(),
		});

		this._updatePosition(this._overlayRef);

		this._overlayRef
			.detachments()
			.pipe(takeUntil(this._destroyed))
			.subscribe(() => this._detach());

		this._overlayRef
			.outsidePointerEvents()
			.pipe(takeUntil(this._destroyed))
			.subscribe(() => this._tooltipInstance?._handleBodyInteraction());

		this._overlayRef
			.keydownEvents()
			.pipe(takeUntil(this._destroyed))
			.subscribe((event) => {
				if (this._isTooltipVisible() && event.key === 'Escape' && !hasModifierKey(event)) {
					event.preventDefault();
					event.stopPropagation();
					this._ngZone.run(() => this.hide(0));
				}
			});

		if (this._defaultOptions?.disableTooltipInteractivity) {
			this._overlayRef.addPanelClass(`${this._cssClassPrefix}-tooltip-panel-non-interactive`);
		}

		return this._overlayRef;
	}

	private _detach(): void {
		if (this._overlayRef?.hasAttached()) {
			this._overlayRef.detach();
		}

		this._tooltipInstance = null;
	}

	private _updatePosition(overlayRef: OverlayRef) {
		const position = overlayRef.getConfig().positionStrategy as FlexibleConnectedPositionStrategy;
		const origin = this._getOrigin();
		const overlay = this._getOverlayPosition();

		position.withPositions([
			this._addOffset({ ...origin.main, ...overlay.main }),
			this._addOffset({ ...origin.fallback, ...overlay.fallback }),
		]);
	}

	/** Adds the configured offset to a position. Used as a hook for child classes. */
	protected _addOffset(position: ConnectedPosition): ConnectedPosition {
		const offset = UNBOUNDED_ANCHOR_GAP;
		const isLtr = !this._dir || this._dir.value === 'ltr';

		if (position.originY === 'top') {
			position.offsetY = -offset;
		} else if (position.originY === 'bottom') {
			position.offsetY = offset;
		} else if (position.originX === 'start') {
			position.offsetX = isLtr ? -offset : offset;
		} else if (position.originX === 'end') {
			position.offsetX = isLtr ? offset : -offset;
		}

		return position;
	}

	/**
	 * Returns the origin position and a fallback position based on the user's position preference.
	 * The fallback position is the inverse of the origin (e.g. `'below' -> 'above'`).
	 */
	_getOrigin(): { main: OriginConnectionPosition; fallback: OriginConnectionPosition } {
		const isLtr = !this._dir || this._dir.value === 'ltr';
		const position = this.position();
		let originPosition: OriginConnectionPosition;

		if (position === 'above' || position === 'below') {
			originPosition = { originX: 'center', originY: position === 'above' ? 'top' : 'bottom' };
		} else if (position === 'before' || (position === 'left' && isLtr) || (position === 'right' && !isLtr)) {
			originPosition = { originX: 'start', originY: 'center' };
		} else if (position === 'after' || (position === 'right' && isLtr) || (position === 'left' && !isLtr)) {
			originPosition = { originX: 'end', originY: 'center' };
		} else if (typeof isDevMode() === 'undefined' || isDevMode()) {
			throw getBrnTooltipInvalidPositionError(position);
		}

		const { x, y } = this._invertPosition(originPosition!.originX, originPosition!.originY);

		return {
			main: originPosition!,
			fallback: { originX: x, originY: y },
		};
	}

	/** Returns the overlay position and a fallback position based on the user's preference */
	_getOverlayPosition(): { main: OverlayConnectionPosition; fallback: OverlayConnectionPosition } {
		const isLtr = !this._dir || this._dir.value === 'ltr';
		const position = this.position();
		let overlayPosition: OverlayConnectionPosition;

		if (position === 'above') {
			overlayPosition = { overlayX: 'center', overlayY: 'bottom' };
		} else if (position === 'below') {
			overlayPosition = { overlayX: 'center', overlayY: 'top' };
		} else if (position === 'before' || (position === 'left' && isLtr) || (position === 'right' && !isLtr)) {
			overlayPosition = { overlayX: 'end', overlayY: 'center' };
		} else if (position === 'after' || (position === 'right' && isLtr) || (position === 'left' && !isLtr)) {
			overlayPosition = { overlayX: 'start', overlayY: 'center' };
		} else if (typeof isDevMode() === 'undefined' || isDevMode()) {
			throw getBrnTooltipInvalidPositionError(position);
		}

		const { x, y } = this._invertPosition(overlayPosition!.overlayX, overlayPosition!.overlayY);

		return {
			main: overlayPosition!,
			fallback: { overlayX: x, overlayY: y },
		};
	}

	/** Updates the tooltip message and repositions the overlay according to the new message length */
	private _updateTooltipContent(): void {
		// Must wait for the template to be painted to the tooltip so that the overlay can properly
		// calculate the correct positioning based on the size of the tek-pate.
		if (this._tooltipInstance) {
			this._tooltipInstance.content = this.brnTooltipTriggerState();
			this._tooltipInstance._markForCheck();

			this._ngZone.onMicrotaskEmpty.pipe(take(1), takeUntil(this._destroyed)).subscribe(() => {
				if (this._tooltipInstance) {
					this._overlayRef?.updatePosition();
				}
			});
		}
	}

	/** Inverts an overlay position. */
	private _invertPosition(x: HorizontalConnectionPos, y: VerticalConnectionPos) {
		if (this.position() === 'above' || this.position() === 'below') {
			if (y === 'top') {
				y = 'bottom';
			} else if (y === 'bottom') {
				y = 'top';
			}
		} else {
			if (x === 'end') {
				x = 'start';
			} else if (x === 'start') {
				x = 'end';
			}
		}

		return { x, y };
	}

	/** Updates the class on the overlay panel based on the current position of the tooltip. */
	private _updateCurrentPositionClass(connectionPair: ConnectionPositionPair): void {
		const { overlayY, originX, originY } = connectionPair;
		let newPosition: TooltipPosition;

		// If the overlay is in the middle along the Y axis,
		// it means that it's either before or after.
		if (overlayY === 'center') {
			// Note that since this information is used for styling, we want to
			// resolve `start` and `end` to their real values, otherwise consumers
			// would have to remember to do it themselves on each consumption.
			if (this._dir && this._dir.value === 'rtl') {
				newPosition = originX === 'end' ? 'left' : 'right';
			} else {
				newPosition = originX === 'start' ? 'left' : 'right';
			}
		} else {
			newPosition = overlayY === 'bottom' && originY === 'top' ? 'above' : 'below';
		}

		if (newPosition !== this._currentPosition) {
			this._tooltipInstance?.side.set(newPosition);
			this._currentPosition = newPosition;
		}
	}

	/** Binds the pointer events to the tooltip trigger. */
	private _setupPointerEnterEventsIfNeeded(): void {
		// Optimization: Defer hooking up events if there's no content or the tooltip is disabled.
		if (
			this.brnTooltipDisabled() ||
			!this.brnTooltipTriggerState() ||
			!this._viewInitialized ||
			this._passiveListeners.length
		) {
			return;
		}

		// The mouse events shouldn't be bound on mobile devices, because they can prevent the
		// first tap from firing its click event or can cause the tooltip to open for clicks.
		if (this._platformSupportsMouseEvents()) {
			this._passiveListeners.push([
				'mouseenter',
				(event) => {
					this._setupPointerExitEventsIfNeeded();
					let point = undefined;
					if ((event as MouseEvent).x !== undefined && (event as MouseEvent).y !== undefined) {
						point = event as MouseEvent;
					}
					this.show(undefined, point);
				},
			]);
		} else if (this.touchGestures() !== 'off') {
			this._disableNativeGesturesIfNecessary();

			this._passiveListeners.push([
				'touchstart',
				(event) => {
					const touch = (event as TouchEvent).targetTouches?.[0];
					const origin = touch ? { x: touch.clientX, y: touch.clientY } : undefined;
					// Note that it's important that we don't `preventDefault` here,
					// because it can prevent click events from firing on the element.
					this._setupPointerExitEventsIfNeeded();
					clearTimeout(this._touchstartTimeout);
					this._touchstartTimeout = setTimeout(() => this.show(undefined, origin), LONGPRESS_DELAY);
				},
			]);
		}

		this._addListeners(this._passiveListeners);
	}

	private _setupPointerExitEventsIfNeeded(): void {
		if (this._pointerExitEventsInitialized) {
			return;
		}
		this._pointerExitEventsInitialized = true;

		const exitListeners: (readonly [string, EventListenerOrEventListenerObject])[] = [];
		if (this._platformSupportsMouseEvents()) {
			exitListeners.push(
				[
					'mouseleave',
					(event) => {
						const newTarget = (event as MouseEvent).relatedTarget as Node | null;
						if (!newTarget || !this._overlayRef?.overlayElement.contains(newTarget)) {
							this.hide();
						}
					},
				],
				['wheel', (event) => this._wheelListener(event as WheelEvent)],
			);
		} else if (this.touchGestures() !== 'off') {
			this._disableNativeGesturesIfNecessary();
			const touchendListener = () => {
				clearTimeout(this._touchstartTimeout);
				this.hide(this._defaultOptions?.touchendHideDelay);
			};

			exitListeners.push(['touchend', touchendListener], ['touchcancel', touchendListener]);
		}

		this._addListeners(exitListeners);
		this._passiveListeners.push(...exitListeners);
	}

	private _addListeners(listeners: (readonly [string, EventListenerOrEventListenerObject])[]) {
		listeners.forEach(([event, listener]) => {
			this._elementRef.nativeElement.addEventListener(event, listener, passiveListenerOptions);
		});
	}

	private _platformSupportsMouseEvents(): boolean {
		return !this._platform.IOS && !this._platform.ANDROID;
	}

	/** Listener for the `wheel` event on the element. */
	private _wheelListener(event: WheelEvent) {
		if (this._isTooltipVisible()) {
			const elementUnderPointer = this._document.elementFromPoint(event.clientX, event.clientY);
			const element = this._elementRef.nativeElement;

			// On non-touch devices we depend on the `mouseleave` event to close the tooltip, but it
			// won't fire if the user scrolls away using the wheel without moving their cursor. We
			// work around it by finding the element under the user's cursor and closing the tooltip
			// if it's not the trigger.
			if (elementUnderPointer !== element && !element.contains(elementUnderPointer)) {
				this.hide();
			}
		}
	}

	/** Disables the native browser gestures, based on how the tooltip has been configured. */
	private _disableNativeGesturesIfNecessary(): void {
		const gestures = this.touchGestures();

		if (gestures !== 'off') {
			const element = this._elementRef.nativeElement;
			const style = element.style;

			// If gestures are set to `auto`, we don't disable text selection on inputs and
			// textareas, because it prevents the user from typing into them on iOS Safari.
			if (gestures === 'on' || (element.nodeName !== 'INPUT' && element.nodeName !== 'TEXTAREA')) {
				// eslint-disable-next-line @typescript-eslint/no-explicit-any
				style.userSelect = (style as any).msUserSelect = style.webkitUserSelect = (style as any).MozUserSelect = 'none';
			}

			// If we have `auto` gestures and the element uses native HTML dragging,
			// we don't set `-webkit-user-drag` because it prevents the native behavior.
			if (gestures === 'on' || !element.draggable) {
				// eslint-disable-next-line @typescript-eslint/no-explicit-any
				(style as any).webkitUserDrag = 'none';
			}

			style.touchAction = 'none';
			// eslint-disable-next-line @typescript-eslint/no-explicit-any
			(style as any).webkitTapHighlightColor = 'transparent';
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tooltip/src/lib/brn-tooltip.directive.ts
```typescript
import { Directive, type TemplateRef, signal } from '@angular/core';

@Directive({
	selector: '[brnTooltip]',
	standalone: true,
})
export class BrnTooltipDirective {
	public readonly tooltipTemplate = signal<TemplateRef<unknown> | null>(null);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tooltip/src/lib/brn-tooltip.token.ts
```typescript
import { inject, InjectionToken, ValueProvider } from '@angular/core';
import { TooltipPosition, TooltipTouchGestures } from './brn-tooltip-trigger.directive';

export interface BrnTooltipOptions {
	/** Default delay when the tooltip is shown. */
	showDelay: number;
	/** Default delay when the tooltip is hidden. */
	hideDelay: number;
	/** Default delay when hiding the tooltip on a touch device. */
	touchendHideDelay: number;
	/** Default exit animation duration for the tooltip. */
	exitAnimationDuration: number;
	/** Default touch gesture handling for tooltips. */
	touchGestures?: TooltipTouchGestures;
	/** Default position for tooltips. */
	position?: TooltipPosition;
	/**
	 * Default value for whether tooltips should be positioned near the click or touch origin
	 * instead of outside the element bounding box.
	 */
	positionAtOrigin?: boolean;
	/** Disables the ability for the user to interact with the tooltip element. */
	disableTooltipInteractivity?: boolean;
	/** Default classes for the tooltip content. */
	tooltipContentClasses?: string;
}

export const defaultOptions: BrnTooltipOptions = {
	showDelay: 0,
	hideDelay: 0,
	exitAnimationDuration: 0,
	touchendHideDelay: 1500,
};

const BRN_TOOLTIP_DEFAULT_OPTIONS = new InjectionToken<BrnTooltipOptions>('brn-tooltip-default-options', {
	providedIn: 'root',
	factory: () => defaultOptions,
});

export function provideBrnTooltipDefaultOptions(options: Partial<BrnTooltipOptions>): ValueProvider {
	return { provide: BRN_TOOLTIP_DEFAULT_OPTIONS, useValue: { ...defaultOptions, ...options } };
}

export function injectBrnTooltipDefaultOptions(): BrnTooltipOptions {
	return inject(BRN_TOOLTIP_DEFAULT_OPTIONS, { optional: true }) ?? defaultOptions;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tooltip/src/lib/computed-previous.spec.ts
```typescript
import { signal } from '@angular/core';
import { computedPrevious } from './computed-previous';

describe(computedPrevious.name, () => {
	it('should work properly', () => {
		const value = signal(0);
		const previous = computedPrevious(value);

		expect(value()).toEqual(0);
		expect(previous()).toEqual(0);

		value.set(1);

		expect(value()).toEqual(1);
		expect(previous()).toEqual(0);

		value.set(2);

		expect(value()).toEqual(2);
		expect(previous()).toEqual(1);

		value.set(2);

		expect(value()).toEqual(2);
		expect(previous()).toEqual(1);

		value.set(3);

		expect(value()).toEqual(3);
		expect(previous()).toEqual(2);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/tooltip/src/lib/computed-previous.ts
````typescript
import { computed, type Signal, untracked } from '@angular/core';

/**
 * Returns a signal that emits the previous value of the given signal.
 * The first time the signal is emitted, the previous value will be the same as the current value.
 *
 * @example
 * ```ts
 * const value = signal(0);
 * const previous = computedPrevious(value);
 *
 * effect(() => {
 *  console.log('Current value:', value());
 *  console.log('Previous value:', previous());
 * });
 *
 * Logs:
 * // Current value: 0
 * // Previous value: 0
 *
 * value.set(1);
 *
 * Logs:
 * // Current value: 1
 * // Previous value: 0
 *
 * value.set(2);
 *
 * Logs:
 * // Current value: 2
 * // Previous value: 1
 *```
 *
 * @param computation Signal to compute previous value for
 * @returns Signal that emits previous value of `s`
 */
export function computedPrevious<T>(computation: Signal<T>): Signal<T> {
	let current = null as T;
	let previous = untracked(() => computation()); // initial value is the current value

	return computed(() => {
		current = computation();
		const result = previous;
		previous = current;
		return result;
	});
}

````
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/input-otp/README.md
```
# @spartan-ng/brain/input-otp

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/input-otp`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/input-otp/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/input-otp/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { BrnInputOtpSlotComponent } from './lib/brn-input-otp-slot.component';
import { BrnInputOtpComponent } from './lib/brn-input-otp.component';

export * from './lib/brn-input-otp-slot.component';
export * from './lib/brn-input-otp.component';

@NgModule({
	imports: [BrnInputOtpComponent, BrnInputOtpSlotComponent],
	exports: [BrnInputOtpComponent, BrnInputOtpSlotComponent],
})
export class BrnInputOtpModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/input-otp/src/lib/brn-input-otp-slot.component.ts
```typescript
import { NumberInput } from '@angular/cdk/coercion';
import { Component, computed, input, numberAttribute } from '@angular/core';
import { injectBrnInputOtp } from './brn-input-otp.token';

@Component({
	selector: 'brn-input-otp-slot',
	standalone: true,
	template: `
		{{ slot().char }}

		@if (slot().hasFakeCaret) {
			<ng-content />
		}
	`,
	host: {
		'[attr.data-active]': 'slot().isActive',
	},
})
export class BrnInputOtpSlotComponent {
	/** Access the input-otp component */
	protected readonly inputOtp = injectBrnInputOtp();

	public readonly index = input.required<number, NumberInput>({ transform: numberAttribute });

	public readonly slot = computed(() => this.inputOtp.context()[this.index()]);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/input-otp/src/lib/brn-input-otp.component.ts
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
import { ControlValueAccessor, FormsModule, NG_VALUE_ACCESSOR } from '@angular/forms';
import { ChangeFn, TouchFn } from '@spartan-ng/brain/forms';
import { provideBrnInputOtp } from './brn-input-otp.token';

export const BRN_INPUT_OTP_VALUE_ACCESSOR = {
	provide: NG_VALUE_ACCESSOR,
	useExisting: forwardRef(() => BrnInputOtpComponent),
	multi: true,
};

export type InputMode = 'text' | 'tel' | 'url' | 'email' | 'numeric' | 'decimal' | 'search';

@Component({
	selector: 'brn-input-otp',
	imports: [FormsModule],
	template: `
		<ng-content />
		<div [style]="containerStyles()">
			<input
				[class]="inputClass()"
				autocomplete="one-time-code"
				data-slot="input-otp"
				[style]="inputStyles()"
				[disabled]="state().disabled()"
				[inputMode]="inputMode()"
				[ngModel]="value()"
				(input)="onInputChange($event)"
				(paste)="onPaste($event)"
				(focus)="focused.set(true)"
				(blur)="focused.set(false)"
			/>
		</div>
	`,
	host: {
		'[style]': 'hostStyles()',
		'data-input-otp-container': 'true',
	},
	providers: [BRN_INPUT_OTP_VALUE_ACCESSOR, provideBrnInputOtp(BrnInputOtpComponent)],
})
export class BrnInputOtpComponent implements ControlValueAccessor {
	/** Whether the input has focus. */
	protected readonly focused = signal<boolean>(false);

	public readonly hostStyles = input<string>(
		'position: relative; cursor: text; user-select: none; pointer-events: none;',
	);

	public readonly inputStyles = input<string>(
		'position: absolute; inset: 0; width: 100%; height: 100%; display: flex; textAlign: left; opacity: 1; color: transparent; pointerEvents: all; background: transparent; caret-color: transparent; border: 0px solid transparent; outline: transparent solid 0px; box-shadow: none; line-height: 1; letter-spacing: -0.5em; font-family: monospace; font-variant-numeric: tabular-nums;',
	);

	public readonly containerStyles = input<string>('position: absolute; inset: 0; pointer-events: none;');

	/** Determine if the date picker is disabled. */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** The number of slots. */
	public readonly maxLength = input.required<number, NumberInput>({ transform: numberAttribute });

	/** Virtual keyboard appearance on mobile */
	public readonly inputMode = input<InputMode>('numeric');

	public readonly inputClass = input<string>('');

	/**
	 * Defines how the pasted text should be transformed before saving to model/form.
	 * Allows pasting text which contains extra characters like spaces, dashes, etc. and are longer than the maxLength.
	 *
	 * "XXX-XXX": (pastedText) => pastedText.replaceAll('-', '')
	 * "XXX XXX": (pastedText) => pastedText.replaceAll(/\s+/g, '')
	 */
	public readonly transformPaste = input<(pastedText: string, maxLength: number) => string>((text) => text);

	/** The value controlling the input */
	public readonly value = model('');

	public readonly context = computed(() => {
		const value = this.value();
		const focused = this.focused();
		const maxLength = this.maxLength();
		const slots = Array.from({ length: this.maxLength() }).map((_, slotIndex) => {
			const char = value[slotIndex] !== undefined ? value[slotIndex] : null;

			const isActive =
				focused && (value.length === slotIndex || (value.length === maxLength && slotIndex === maxLength - 1));

			return {
				char,
				isActive,
				hasFakeCaret: isActive && value.length === slotIndex,
			};
		});

		return slots;
	});

	/** Emitted when the input is complete, triggered through input or paste.  */
	public readonly completed = output<string>();

	protected readonly state = computed(() => ({
		disabled: signal(this.disabled()),
	}));

	protected _onChange?: ChangeFn<string>;
	protected _onTouched?: TouchFn;

	protected onInputChange(event: Event) {
		let newValue = (event.target as HTMLInputElement).value;
		const maxLength = this.maxLength();

		if (newValue.length > maxLength) {
			// Replace the last character when max length is exceeded
			newValue = newValue.slice(0, maxLength - 1) + newValue.slice(-1);
		}

		this.updateValue(newValue, maxLength);
	}

	protected onPaste(event: ClipboardEvent) {
		event.preventDefault();
		const clipboardData = event.clipboardData?.getData('text/plain') || '';

		const maxLength = this.maxLength();

		const content = this.transformPaste()(clipboardData, maxLength);
		const newValue = content.slice(0, maxLength);

		this.updateValue(newValue, maxLength);
	}

	/** CONTROL VALUE ACCESSOR */
	writeValue(value: string | null): void {
		// optional FormControl is initialized with null value
		if (value === null) return;

		this.updateValue(value, this.maxLength());
	}

	registerOnChange(fn: ChangeFn<string>): void {
		this._onChange = fn;
	}

	registerOnTouched(fn: TouchFn): void {
		this._onTouched = fn;
	}

	setDisabledState(isDisabled: boolean): void {
		this.state().disabled.set(isDisabled);
	}

	private isCompleted(newValue: string, previousValue: string, maxLength: number) {
		return newValue !== previousValue && previousValue.length < maxLength && newValue.length === maxLength;
	}

	private updateValue(newValue: string, maxLength: number) {
		const previousValue = this.value();

		this.value.set(newValue);
		this._onChange?.(newValue);

		if (this.isCompleted(newValue, previousValue, maxLength)) {
			this.completed.emit(newValue);
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/input-otp/src/lib/brn-input-otp.token.ts
```typescript
import { ExistingProvider, inject, InjectionToken, Type } from '@angular/core';
import { BrnInputOtpComponent } from './brn-input-otp.component';

export const BrnInputOtpToken = new InjectionToken<BrnInputOtpComponent>('BrnInputOtpToken');

export function injectBrnInputOtp(): BrnInputOtpComponent {
	return inject(BrnInputOtpToken) as BrnInputOtpComponent;
}

export function provideBrnInputOtp(inputOtp: Type<BrnInputOtpComponent>): ExistingProvider {
	return { provide: BrnInputOtpToken, useExisting: inputOtp };
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/README.md
```
# @spartan-ng/brain/calendar

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/calendar`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/index.ts
```typescript
export * from './lib/brn-calendar-cell-button.directive';
export * from './lib/brn-calendar-cell.directive';
export * from './lib/brn-calendar-grid.directive';
export * from './lib/brn-calendar-header.directive';
export * from './lib/brn-calendar-next-button.directive';
export * from './lib/brn-calendar-previous-button.directive';
export * from './lib/brn-calendar-week.directive';
export * from './lib/brn-calendar-weekday.directive';
export * from './lib/brn-calendar.directive';
export * from './lib/brn-calendar.token';
export * from './lib/i18n/calendar-i18n';
export * from './lib/mode/brn-calendar-multiple.directive';

import { NgModule } from '@angular/core';
import { BrnCalendarCellButtonDirective } from './lib/brn-calendar-cell-button.directive';
import { BrnCalendarCellDirective } from './lib/brn-calendar-cell.directive';
import { BrnCalendarGridDirective } from './lib/brn-calendar-grid.directive';
import { BrnCalendarHeaderDirective } from './lib/brn-calendar-header.directive';
import { BrnCalendarNextButtonDirective } from './lib/brn-calendar-next-button.directive';
import { BrnCalendarPreviousButtonDirective } from './lib/brn-calendar-previous-button.directive';
import { BrnCalendarWeekDirective } from './lib/brn-calendar-week.directive';
import { BrnCalendarWeekdayDirective } from './lib/brn-calendar-weekday.directive';
import { BrnCalendarDirective } from './lib/brn-calendar.directive';
import { BrnCalendarMultiDirective } from './lib/mode/brn-calendar-multiple.directive';

export const BrnCalendarImports = [
	BrnCalendarCellButtonDirective,
	BrnCalendarGridDirective,
	BrnCalendarHeaderDirective,
	BrnCalendarNextButtonDirective,
	BrnCalendarPreviousButtonDirective,
	BrnCalendarWeekDirective,
	BrnCalendarWeekdayDirective,
	BrnCalendarDirective,
	BrnCalendarCellDirective,
	BrnCalendarMultiDirective,
] as const;

@NgModule({
	imports: [...BrnCalendarImports],
	exports: [...BrnCalendarImports],
})
export class BrnCalendarModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-cell-button.directive.ts
```typescript
import { Directive, ElementRef, computed, inject, input } from '@angular/core';
import { injectDateAdapter } from '@spartan-ng/brain/date-time';
import { injectBrnCalendar } from './brn-calendar.token';

@Directive({
	selector: 'button[brnCalendarCellButton]',
	standalone: true,
	host: {
		role: 'gridcell',
		'[tabindex]': 'focusable() ? 0 : -1',
		type: 'button',
		'[attr.data-outside]': "outside() ? '' : null",
		'[attr.data-today]': "today() && !selected() ? '' : null",
		'[attr.data-selected]': "selected() ? '' : null",
		'[attr.data-disabled]': "disabled() ? '' : null",
		'[attr.aria-selected]': "selected() ? 'true' : null",
		'[attr.aria-disabled]': "disabled() ? 'true' : null",
		'[disabled]': 'disabled()',
		'(click)': 'calendar.selectDate(date())',
		'(keydown.arrowLeft)': 'focusPrevious($event)',
		'(keydown.arrowRight)': 'focusNext($event)',
		'(keydown.arrowUp)': 'focusAbove($event)',
		'(keydown.arrowDown)': 'focusBelow($event)',
		'(keydown.home)': 'focusFirst($event)',
		'(keydown.end)': 'focusLast($event)',
		'(keydown.pageUp)': 'focusPreviousMonth($event)',
		'(keydown.pageDown)': 'focusNextMonth($event)',
	},
})
export class BrnCalendarCellButtonDirective<T> {
	/** Access the date adapter */
	protected readonly dateAdapter = injectDateAdapter<T>();

	/** Access the calendar component */
	protected readonly calendar = injectBrnCalendar<T>();

	/** Access the element ref */
	private readonly _elementRef = inject<ElementRef<HTMLButtonElement>>(ElementRef);

	/** The date this cell represents */
	public readonly date = input.required<T>();

	/** Whether this date is currently selected */
	public readonly selected = computed(() => this.calendar.isSelected(this.date()));

	/** Whether this date is focusable */
	public readonly focusable = computed(() => this.dateAdapter.isSameDay(this.calendar.focusedDate(), this.date()));

	public readonly outside = computed(() => {
		const focusedDate = this.calendar.focusedDate();
		return !this.dateAdapter.isSameMonth(this.date(), focusedDate);
	});

	/** Whether this date is today */
	public readonly today = computed(() => this.dateAdapter.isSameDay(this.date(), this.dateAdapter.now()));

	/** Whether this date is disabled */
	public readonly disabled = computed(() => this.calendar.isDateDisabled(this.date()) || this.calendar.disabled());

	/**
	 * Focus the previous cell.
	 */
	protected focusPrevious(event: Event): void {
		event.preventDefault();
		event.stopPropagation();

		// in rtl, the arrow keys are reversed.
		const targetDate = this.dateAdapter.add(this.calendar.focusedDate(), {
			days: this.getDirection() === 'rtl' ? 1 : -1,
		});

		this.calendar.setFocusedDate(targetDate);
	}

	/**
	 * Focus the next cell.
	 */
	protected focusNext(event: Event): void {
		event.preventDefault();
		event.stopPropagation();

		const targetDate = this.dateAdapter.add(this.calendar.focusedDate(), {
			days: this.getDirection() === 'rtl' ? -1 : 1,
		});

		this.calendar.setFocusedDate(targetDate);
	}

	/**
	 * Focus the above cell.
	 */
	protected focusAbove(event: Event): void {
		event.preventDefault();
		event.stopPropagation();
		this.calendar.setFocusedDate(this.dateAdapter.subtract(this.calendar.focusedDate(), { days: 7 }));
	}

	/**
	 * Focus the below cell.
	 */
	protected focusBelow(event: Event): void {
		event.preventDefault();
		event.stopPropagation();
		this.calendar.setFocusedDate(this.dateAdapter.add(this.calendar.focusedDate(), { days: 7 }));
	}

	/**
	 * Focus the first date of the month.
	 */
	protected focusFirst(event: Event): void {
		event.preventDefault();
		event.stopPropagation();
		this.calendar.setFocusedDate(this.dateAdapter.startOfMonth(this.calendar.focusedDate()));
	}

	/**
	 * Focus the last date of the month.
	 */
	protected focusLast(event: Event): void {
		event.preventDefault();
		event.stopPropagation();
		this.calendar.setFocusedDate(this.dateAdapter.endOfMonth(this.calendar.focusedDate()));
	}

	/**
	 * Focus the same date in the previous month.
	 */
	protected focusPreviousMonth(event: Event): void {
		event.preventDefault();
		event.stopPropagation();

		const date = this.dateAdapter.getDate(this.calendar.focusedDate());

		let previousMonthTarget = this.dateAdapter.startOfMonth(this.calendar.focusedDate());
		previousMonthTarget = this.dateAdapter.subtract(previousMonthTarget, { months: 1 });

		const lastDay = this.dateAdapter.endOfMonth(previousMonthTarget);

		// if we are on a date that does not exist in the previous month, we should focus the last day of the month.
		if (date > this.dateAdapter.getDate(lastDay)) {
			this.calendar.setFocusedDate(lastDay);
		} else {
			this.calendar.setFocusedDate(this.dateAdapter.set(previousMonthTarget, { day: date }));
		}
	}

	/**
	 * Focus the same date in the next month.
	 */
	protected focusNextMonth(event: Event): void {
		event.preventDefault();
		event.stopPropagation();

		const date = this.dateAdapter.getDate(this.calendar.focusedDate());

		let nextMonthTarget = this.dateAdapter.startOfMonth(this.calendar.focusedDate());
		nextMonthTarget = this.dateAdapter.add(nextMonthTarget, { months: 1 });

		const lastDay = this.dateAdapter.endOfMonth(nextMonthTarget);

		// if we are on a date that does not exist in the next month, we should focus the last day of the month.
		if (date > this.dateAdapter.getDate(lastDay)) {
			this.calendar.setFocusedDate(lastDay);
		} else {
			this.calendar.setFocusedDate(this.dateAdapter.set(nextMonthTarget, { day: date }));
		}
	}

	/**
	 * Get the direction of the element.
	 */
	private getDirection(): 'ltr' | 'rtl' {
		return getComputedStyle(this._elementRef.nativeElement).direction === 'rtl' ? 'rtl' : 'ltr';
	}

	focus(): void {
		this._elementRef.nativeElement.focus();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-cell.directive.ts
```typescript
import { Directive } from '@angular/core';

@Directive({
	selector: '[brnCalendarCell]',
	standalone: true,
	host: {
		role: 'presentation',
	},
})
export class BrnCalendarCellDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-grid.directive.ts
```typescript
import { Directive } from '@angular/core';
import { injectBrnCalendar } from './brn-calendar.token';

@Directive({
	selector: '[brnCalendarGrid]',
	standalone: true,
	host: {
		role: 'grid',
		'[attr.aria-labelledby]': 'calendar.header()?.id()',
	},
})
export class BrnCalendarGridDirective<T> {
	/** Access the calendar component */
	protected readonly calendar = injectBrnCalendar<T>();
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-header.directive.ts
```typescript
import { Directive, input } from '@angular/core';

let uniqueId = 0;

@Directive({
	selector: '[brnCalendarHeader]',
	standalone: true,
	host: {
		'[id]': 'id()',
		'aria-live': 'polite',
		role: 'presentation',
	},
})
export class BrnCalendarHeaderDirective {
	/** The unique id for the header */
	public readonly id = input(`brn-calendar-header-${uniqueId++}`);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-next-button.directive.ts
```typescript
import { Directive, HostListener } from '@angular/core';
import { injectDateAdapter } from '@spartan-ng/brain/date-time';
import { injectBrnCalendar } from './brn-calendar.token';
import { injectBrnCalendarI18n } from './i18n/calendar-i18n';

@Directive({
	selector: '[brnCalendarNextButton]',
	standalone: true,
	host: {
		type: 'button',
		'[attr.aria-label]': 'i18n.labelNext()',
	},
})
export class BrnCalendarNextButtonDirective {
	/** Access the calendar */
	private readonly _calendar = injectBrnCalendar();

	/** Access the date adapter */
	private readonly _dateAdapter = injectDateAdapter();

	/** Access the calendar i18n */
	protected readonly i18n = injectBrnCalendarI18n();

	/** Focus the previous month */
	@HostListener('click')
	protected focusPreviousMonth(): void {
		const targetDate = this._dateAdapter.add(this._calendar.state().focusedDate(), { months: 1 });

		// if the date is disabled, but there are available dates in the month, focus the last day of the month.
		const possibleDate = this._calendar.constrainDate(targetDate);

		if (this._dateAdapter.isSameMonth(possibleDate, targetDate)) {
			// if this date is within the same month, then focus it
			this._calendar.state().focusedDate.set(possibleDate);
			return;
		}

		this._calendar.state().focusedDate.set(targetDate);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-previous-button.directive.ts
```typescript
import { Directive, HostListener } from '@angular/core';
import { injectDateAdapter } from '@spartan-ng/brain/date-time';
import { injectBrnCalendar } from './brn-calendar.token';
import { injectBrnCalendarI18n } from './i18n/calendar-i18n';

@Directive({
	selector: '[brnCalendarPreviousButton]',
	standalone: true,
	host: {
		type: 'button',
		'[attr.aria-label]': 'i18n.labelPrevious()',
	},
})
export class BrnCalendarPreviousButtonDirective {
	/** Access the calendar */
	private readonly _calendar = injectBrnCalendar();

	/** Access the date adapter */
	private readonly _dateAdapter = injectDateAdapter();

	/** Access the calendar i18n */
	protected readonly i18n = injectBrnCalendarI18n();

	/** Focus the previous month */
	@HostListener('click')
	protected focusPreviousMonth(): void {
		const targetDate = this._dateAdapter.subtract(this._calendar.state().focusedDate(), { months: 1 });

		// if the date is disabled, but there are available dates in the month, focus the last day of the month.
		const possibleDate = this._calendar.constrainDate(targetDate);

		if (this._dateAdapter.isSameMonth(possibleDate, targetDate)) {
			// if this date is within the same month, then focus it
			this._calendar.state().focusedDate.set(possibleDate);
			return;
		}

		this._calendar.state().focusedDate.set(targetDate);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-week.directive.ts
```typescript
import {
	ChangeDetectorRef,
	Directive,
	EmbeddedViewRef,
	OnDestroy,
	TemplateRef,
	ViewContainerRef,
	computed,
	effect,
	inject,
	untracked,
} from '@angular/core';
import { injectBrnCalendar } from './brn-calendar.token';

@Directive({
	standalone: true,
	selector: '[brnCalendarWeek]',
})
export class BrnCalendarWeekDirective<T> implements OnDestroy {
	/** Access the calendar */
	private readonly _calendar = injectBrnCalendar<T>();

	/** Access the view container ref */
	private readonly _viewContainerRef = inject(ViewContainerRef);

	/** Access the change detector */
	private readonly _changeDetector = inject(ChangeDetectorRef);

	/** Access the template ref */
	private readonly _templateRef = inject<TemplateRef<BrnWeekContext<T>>>(TemplateRef);

	// get the weeks to display.
	protected readonly weeks = computed(() => {
		const days = this._calendar.days();
		const weeks = [];

		for (let i = 0; i < days.length; i += 7) {
			weeks.push(days.slice(i, i + 7));
		}

		return weeks;
	});

	/** Store the view refs */
	private readonly _viewRefs: EmbeddedViewRef<BrnWeekContext<T>>[] = [];

	// Make sure the template checker knows the type of the context with which the
	// template of this directive will be rendered
	static ngTemplateContextGuard<T>(_: BrnCalendarWeekDirective<T>, ctx: unknown): ctx is BrnWeekContext<T> {
		return true;
	}

	constructor() {
		// this should use `afterRenderEffect` but it's not available in the current version
		effect(() => {
			const weeks = this.weeks();
			untracked(() => this._renderWeeks(weeks));
		});
	}

	private _renderWeeks(weeks: T[][]): void {
		// Destroy all the views when the directive is destroyed
		for (const viewRef of this._viewRefs) {
			viewRef.destroy();
		}

		this._viewRefs.length = 0;

		// Create a new view for each week
		for (const week of weeks) {
			const viewRef = this._viewContainerRef.createEmbeddedView(this._templateRef, {
				$implicit: week,
			});
			this._viewRefs.push(viewRef);
		}

		this._changeDetector.detectChanges();
	}

	ngOnDestroy(): void {
		// Destroy all the views when the directive is destroyed
		for (const viewRef of this._viewRefs) {
			viewRef.destroy();
		}
	}
}

interface BrnWeekContext<T> {
	$implicit: T[];
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-weekday.directive.ts
```typescript
import { Directive, EmbeddedViewRef, OnDestroy, TemplateRef, ViewContainerRef, computed, inject } from '@angular/core';
import { injectDateAdapter } from '@spartan-ng/brain/date-time';
import { injectBrnCalendar } from './brn-calendar.token';

@Directive({
	standalone: true,
	selector: '[brnCalendarWeekday]',
})
export class BrnCalendarWeekdayDirective<T> implements OnDestroy {
	/** Access the calendar */
	private readonly _calendar = injectBrnCalendar<T>();

	/** Access the date time adapter */
	private readonly _dateAdapter = injectDateAdapter<T>();

	/** Access the view container ref */
	private readonly _viewContainerRef = inject(ViewContainerRef);

	/** Access the template ref */
	private readonly _templateRef = inject<TemplateRef<BrnWeekdayContext>>(TemplateRef);

	/** Get the days of the week to display in the header. */
	protected readonly weekdays = computed(() => this._calendar.days().slice(0, 7));

	/** Store the view refs */
	private readonly _viewRefs: EmbeddedViewRef<BrnWeekdayContext>[] = [];

	// Make sure the template checker knows the type of the context with which the
	// template of this directive will be rendered
	static ngTemplateContextGuard<T>(_: BrnCalendarWeekdayDirective<T>, ctx: unknown): ctx is BrnWeekdayContext {
		return true;
	}

	constructor() {
		// Create a new view for each day
		for (const day of this.weekdays()) {
			const viewRef = this._viewContainerRef.createEmbeddedView(this._templateRef, {
				$implicit: this._dateAdapter.getDay(day),
			});
			this._viewRefs.push(viewRef);
		}
	}

	ngOnDestroy(): void {
		// Destroy all the views when the directive is destroyed
		for (const viewRef of this._viewRefs) {
			viewRef.destroy();
		}
	}
}

interface BrnWeekdayContext {
	$implicit: number;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar.directive.ts
```typescript
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import {
	ChangeDetectorRef,
	Directive,
	Injector,
	afterNextRender,
	booleanAttribute,
	computed,
	contentChild,
	contentChildren,
	inject,
	input,
	model,
	numberAttribute,
	signal,
} from '@angular/core';
import { injectDateAdapter } from '@spartan-ng/brain/date-time';
import { BrnCalendarCellButtonDirective } from './brn-calendar-cell-button.directive';
import { BrnCalendarHeaderDirective } from './brn-calendar-header.directive';
import { BrnCalendar, provideBrnCalendar } from './brn-calendar.token';

@Directive({
	selector: '[brnCalendar]',
	standalone: true,
	providers: [provideBrnCalendar(BrnCalendarDirective)],
})
export class BrnCalendarDirective<T> implements BrnCalendar<T> {
	/** Access the date adapter */
	protected readonly dateAdapter = injectDateAdapter<T>();

	/** Access the change detector */
	private readonly _changeDetector = inject(ChangeDetectorRef);

	/** Access the injector */
	private readonly _injector = inject(Injector);

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

	/** @internal Access the header */
	public readonly header = contentChild(BrnCalendarHeaderDirective);

	/** Store the cells */
	protected readonly cells = contentChildren<BrnCalendarCellButtonDirective<T>>(BrnCalendarCellButtonDirective, {
		descendants: true,
	});

	/**
	 * @internal
	 * The internal state of the component.
	 */
	public readonly state = computed(() => ({
		focusedDate: signal(this.constrainDate(this.defaultFocusedDate() ?? this.date() ?? this.dateAdapter.now())),
	}));

	/**
	 * The focused date.
	 */
	public readonly focusedDate = computed(() => this.state().focusedDate());

	/**
	 * Get all the days to display, this is the days of the current month
	 * and the days of the previous and next month to fill the grid.
	 */
	public readonly days = computed(() => {
		const weekStartsOn = this.weekStartsOn();
		const month = this.state().focusedDate();
		const days: T[] = [];

		// Get the first and last day of the month.
		let firstDay = this.dateAdapter.startOfMonth(month);
		let lastDay = this.dateAdapter.endOfMonth(month);

		// we need to subtract until we get the to starting day before or on the start of the month.
		while (this.dateAdapter.getDay(firstDay) !== weekStartsOn) {
			firstDay = this.dateAdapter.subtract(firstDay, { days: 1 });
		}

		const weekEndsOn = (weekStartsOn + 6) % 7;

		// we need to add until we get to the ending day after or on the end of the month.
		while (this.dateAdapter.getDay(lastDay) !== weekEndsOn) {
			lastDay = this.dateAdapter.add(lastDay, { days: 1 });
		}

		// collect all the days to display.
		while (firstDay <= lastDay) {
			days.push(firstDay);
			firstDay = this.dateAdapter.add(firstDay, { days: 1 });
		}

		return days;
	});

	/** @internal Constrain a date to the min and max boundaries */
	constrainDate(date: T): T {
		const min = this.min();
		const max = this.max();

		// If there is no min or max, return the date.
		if (!min && !max) {
			return date;
		}

		// If there is a min and the date is before the min, return the min.
		if (min && this.dateAdapter.isBefore(date, this.dateAdapter.startOfDay(min))) {
			return min;
		}

		// If there is a max and the date is after the max, return the max.
		if (max && this.dateAdapter.isAfter(date, this.dateAdapter.endOfDay(max))) {
			return max;
		}

		// Return the date.
		return date;
	}

	/** @internal Determine if a date is disabled */
	isDateDisabled(date: T): boolean {
		// if the calendar is disabled we can't select this date
		if (this.disabled()) {
			return true;
		}

		// if the date is outside the min and max range
		const min = this.min();
		const max = this.max();

		if (min && this.dateAdapter.isBefore(date, this.dateAdapter.startOfDay(min))) {
			return true;
		}

		if (max && this.dateAdapter.isAfter(date, this.dateAdapter.endOfDay(max))) {
			return true;
		}

		// if this specific date is disabled
		const disabledFn = this.dateDisabled();

		if (disabledFn(date)) {
			return true;
		}

		return false;
	}

	isSelected(date: T): boolean {
		const selected = this.date() as T | undefined;
		return selected !== undefined && this.dateAdapter.isSameDay(date, selected);
	}

	selectDate(date: T): void {
		if (this.isSelected(date)) {
			this.date.set(undefined);
		} else {
			this.date.set(date);
		}
		this.state().focusedDate.set(date);
	}

	/** @internal Set the focused date */
	setFocusedDate(date: T): void {
		// check if the date is disabled.
		if (this.isDateDisabled(date)) {
			return;
		}

		this.state().focusedDate.set(date);

		// wait until the cells have all updated
		afterNextRender(
			{
				write: () => {
					// focus the cell with the target date.
					const cell = this.cells().find((c) => this.dateAdapter.isSameDay(c.date(), date));

					if (cell) {
						cell.focus();
					}
				},
			},
			{
				injector: this._injector,
			},
		);

		// we must update the view to ensure the focused cell is visible.
		this._changeDetector.detectChanges();
	}
}

export type Weekday = 0 | 1 | 2 | 3 | 4 | 5 | 6;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar.token.ts
```typescript
import { ExistingProvider, InjectionToken, Signal, Type, WritableSignal, inject } from '@angular/core';
import { BrnCalendarHeaderDirective } from './brn-calendar-header.directive';

export interface BrnCalendar<T> {
	isSelected: (date: T) => boolean;
	selectDate: (date: T) => void;

	constrainDate: (date: T) => T;
	isDateDisabled: (date: T) => boolean;
	setFocusedDate: (date: T) => void;

	disabled: Signal<boolean>;
	focusedDate: Signal<T>;
	header: Signal<BrnCalendarHeaderDirective | undefined>;
	state: Signal<{
		focusedDate: WritableSignal<T>;
	}>;
	days: Signal<T[]>;
}

export const BrnCalendarToken = new InjectionToken<BrnCalendar<unknown>>('BrnCalendarToken');

export function provideBrnCalendar<T>(instance: Type<BrnCalendar<T>>): ExistingProvider {
	return { provide: BrnCalendarToken, useExisting: instance };
}

/**
 * Inject the calendar component.
 */
export function injectBrnCalendar<T>(): BrnCalendar<T> {
	return inject(BrnCalendarToken) as BrnCalendar<T>;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/mode/brn-calendar-multiple.directive.ts
```typescript
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import {
	afterNextRender,
	booleanAttribute,
	ChangeDetectorRef,
	computed,
	contentChild,
	contentChildren,
	Directive,
	inject,
	Injector,
	input,
	model,
	numberAttribute,
	signal,
} from '@angular/core';
import { injectDateAdapter } from '@spartan-ng/brain/date-time';
import { BrnCalendarCellButtonDirective } from '../brn-calendar-cell-button.directive';
import { BrnCalendarHeaderDirective } from '../brn-calendar-header.directive';
import { Weekday } from '../brn-calendar.directive';
import { BrnCalendar, provideBrnCalendar } from '../brn-calendar.token';

@Directive({
	selector: '[brnCalendarMulti]',
	standalone: true,
	providers: [provideBrnCalendar(BrnCalendarMultiDirective)],
})
export class BrnCalendarMultiDirective<T> implements BrnCalendar<T> {
	// /** Access the date adapter */
	protected readonly dateAdapter = injectDateAdapter<T>();

	/** Access the change detector */
	private readonly _changeDetector = inject(ChangeDetectorRef);

	/** Access the injector */
	private readonly _injector = inject(Injector);

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

	/** @internal Access the header */
	public readonly header = contentChild(BrnCalendarHeaderDirective);

	/** Store the cells */
	protected readonly cells = contentChildren<BrnCalendarCellButtonDirective<T>>(BrnCalendarCellButtonDirective, {
		descendants: true,
	});

	/**
	 * @internal
	 * The internal state of the component.
	 */
	public readonly state = computed(() => ({
		focusedDate: signal(this.constrainDate(this.defaultFocusedDate() ?? this.dateAdapter.now())),
	}));

	/**
	 * The focused date.
	 */
	public readonly focusedDate = computed(() => this.state().focusedDate());

	/**
	 * Get all the days to display, this is the days of the current month
	 * and the days of the previous and next month to fill the grid.
	 */
	public readonly days = computed(() => {
		const weekStartsOn = this.weekStartsOn();
		const month = this.state().focusedDate();
		const days: T[] = [];

		// Get the first and last day of the month.
		let firstDay = this.dateAdapter.startOfMonth(month);
		let lastDay = this.dateAdapter.endOfMonth(month);

		// we need to subtract until we get the to starting day before or on the start of the month.
		while (this.dateAdapter.getDay(firstDay) !== weekStartsOn) {
			firstDay = this.dateAdapter.subtract(firstDay, { days: 1 });
		}

		const weekEndsOn = (weekStartsOn + 6) % 7;

		// we need to add until we get to the ending day after or on the end of the month.
		while (this.dateAdapter.getDay(lastDay) !== weekEndsOn) {
			lastDay = this.dateAdapter.add(lastDay, { days: 1 });
		}

		// collect all the days to display.
		while (firstDay <= lastDay) {
			days.push(firstDay);
			firstDay = this.dateAdapter.add(firstDay, { days: 1 });
		}

		return days;
	});

	isSelected(date: T): boolean {
		return this.date()?.some((d) => this.dateAdapter.isSameDay(d, date)) ?? false;
	}

	selectDate(date: T): void {
		const selected = this.date() as T[] | undefined;
		if (this.isSelected(date)) {
			const minSelection = this.minSelection();
			if (selected?.length === minSelection) {
				// min selection reached, do not allow to deselect
				return;
			}

			this.date.set(selected?.filter((d) => !this.dateAdapter.isSameDay(d, date)));
		} else {
			const maxSelection = this.maxSelection();
			if (selected?.length === maxSelection) {
				// max selection reached, reset the selection to date
				this.date.set([date]);
			} else {
				// add the date to the selection
				this.date.set([...(selected ?? []), date]);
			}
		}
	}

	// same as in brn-calendar.directive.ts
	/** @internal Constrain a date to the min and max boundaries */
	constrainDate(date: T): T {
		const min = this.min();
		const max = this.max();

		// If there is no min or max, return the date.
		if (!min && !max) {
			return date;
		}

		// If there is a min and the date is before the min, return the min.
		if (min && this.dateAdapter.isBefore(date, this.dateAdapter.startOfDay(min))) {
			return min;
		}

		// If there is a max and the date is after the max, return the max.
		if (max && this.dateAdapter.isAfter(date, this.dateAdapter.endOfDay(max))) {
			return max;
		}

		// Return the date.
		return date;
	}

	/** @internal Determine if a date is disabled */
	isDateDisabled(date: T): boolean {
		// if the calendar is disabled we can't select this date
		if (this.disabled()) {
			return true;
		}

		// if the date is outside the min and max range
		const min = this.min();
		const max = this.max();

		if (min && this.dateAdapter.isBefore(date, this.dateAdapter.startOfDay(min))) {
			return true;
		}

		if (max && this.dateAdapter.isAfter(date, this.dateAdapter.endOfDay(max))) {
			return true;
		}

		// if this specific date is disabled
		const disabledFn = this.dateDisabled();

		if (disabledFn(date)) {
			return true;
		}

		return false;
	}

	/** @internal Set the focused date */
	setFocusedDate(date: T): void {
		// check if the date is disabled.
		if (this.isDateDisabled(date)) {
			return;
		}

		this.state().focusedDate.set(date);

		// wait until the cells have all updated
		afterNextRender(
			{
				write: () => {
					// focus the cell with the target date.
					const cell = this.cells().find((c) => this.dateAdapter.isSameDay(c.date(), date));

					if (cell) {
						cell.focus();
					}
				},
			},
			{
				injector: this._injector,
			},
		);

		// we must update the view to ensure the focused cell is visible.
		this._changeDetector.detectChanges();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/i18n/calendar-i18n.ts
```typescript
import { InjectionToken, ValueProvider, inject } from '@angular/core';

export interface BrnCalendarI18n {
	formatWeekdayName: (index: number) => string;
	formatHeader: (month: number, year: number) => string;
	labelPrevious: () => string;
	labelNext: () => string;
	labelWeekday: (index: number) => string;
}

export const BrnCalendarI18nToken = new InjectionToken<BrnCalendarI18n>('BrnCalendarI18nToken');

/**
 * Provide the calendar i18n configuration.
 */
export function provideBrnCalendarI18n(configuration: BrnCalendarI18n): ValueProvider {
	return { provide: BrnCalendarI18nToken, useValue: configuration };
}

const defaultCalendarI18n: BrnCalendarI18n = {
	formatWeekdayName: (index: number) => {
		const weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
		return weekdays[index];
	},
	formatHeader: (month: number, year: number) => {
		return new Date(year, month).toLocaleDateString(undefined, {
			month: 'long',
			year: 'numeric',
		});
	},
	labelPrevious: () => 'Go to the previous month',
	labelNext: () => 'Go to the next month',
	labelWeekday: (index: number) => {
		const weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
		return weekdays[index];
	},
};

/**
 * Inject the calendar i18n configuration.
 */
export function injectBrnCalendarI18n(): BrnCalendarI18n {
	return inject(BrnCalendarI18nToken, { optional: true }) ?? defaultCalendarI18n;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/forms/README.md
```
# @spartan-ng/brain/forms

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/forms`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/forms/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/forms/src/index.ts
```typescript
export * from './lib/control-value-accessor';
export * from './lib/error-options';
export * from './lib/error-state-tracker';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/forms/src/lib/control-value-accessor.ts
```typescript
export type ChangeFn<T> = (value: T) => void;
export type TouchFn = () => void;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/forms/src/lib/error-options.ts
```typescript
import { Injectable } from '@angular/core';
import type { AbstractControl, FormGroupDirective, NgForm } from '@angular/forms';

/** Error state matcher that matches when a control is invalid and dirty. */
@Injectable()
export class ShowOnDirtyErrorStateMatcher implements ErrorStateMatcher {
	isInvalid(control: AbstractControl | null, form: FormGroupDirective | NgForm | null): boolean {
		return !!(control && control.invalid && (control.dirty || (form && form.submitted)));
	}
}

/** Provider that defines how form controls behave with regards to displaying error messages. */
@Injectable({ providedIn: 'root' })
export class ErrorStateMatcher {
	isInvalid(control: AbstractControl | null, form: FormGroupDirective | NgForm | null): boolean {
		return !!(control && control.invalid && (control.touched || (form && form.submitted)));
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/forms/src/lib/error-state-tracker.ts
```typescript
import { signal } from '@angular/core';
import type { AbstractControl, FormGroupDirective, NgControl, NgForm } from '@angular/forms';
import type { ErrorStateMatcher } from './error-options';

export class ErrorStateTracker {
	/** Whether the tracker is currently in an error state. */
	public readonly errorState = signal(false);

	/** User-defined matcher for the error state. */
	public matcher: ErrorStateMatcher | null = null;

	constructor(
		private readonly _defaultMatcher: ErrorStateMatcher | null,
		public ngControl: NgControl | null,
		private readonly _parentFormGroup: FormGroupDirective | null,
		private readonly _parentForm: NgForm | null,
	) {}

	/** Updates the error state based on the provided error state matcher. */
	updateErrorState() {
		const oldState = this.errorState();
		const parent = this._parentFormGroup || this._parentForm;
		const matcher = this.matcher || this._defaultMatcher;
		const control = this.ngControl ? (this.ngControl.control as AbstractControl) : null;
		const newState = matcher?.isInvalid(control, parent) ?? false;

		if (newState !== oldState) {
			this.errorState.set(newState);
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/README.md
```
# @spartan-ng/brain/core

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/core`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/index.ts
```typescript
export * from './helpers/custom-element-class-settable';
export * from './helpers/dev-mode';
export * from './helpers/exposes-side';
export * from './helpers/exposes-state';
export * from './helpers/hlm';
export * from './helpers/table-classes-settable';
export * from './helpers/zone-free';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/create-injection-token.ts
```typescript
import { type InjectOptions, InjectionToken, type Provider, type Type, forwardRef, inject } from '@angular/core';

type InjectFn<TTokenValue> = {
	(): TTokenValue;
	(injectOptions: InjectOptions & { optional?: false }): TTokenValue;
	(injectOptions: InjectOptions & { optional: true }): TTokenValue | null;
};

type ProvideFn<TTokenValue> = (value: TTokenValue) => Provider;

type ProvideExistingFn<TTokenValue> = (valueFactory: () => Type<TTokenValue>) => Provider;

export type CreateInjectionTokenReturn<TTokenValue> = [
	InjectFn<TTokenValue>,
	ProvideFn<TTokenValue>,
	ProvideExistingFn<TTokenValue>,
	InjectionToken<TTokenValue>,
];

export function createInjectionToken<TTokenValue>(description: string): CreateInjectionTokenReturn<TTokenValue> {
	const token = new InjectionToken<TTokenValue>(description);

	const provideFn = (value: TTokenValue) => {
		return { provide: token, useValue: value };
	};

	const provideExistingFn = (value: () => TTokenValue) => {
		return { provide: token, useExisting: forwardRef(value) };
	};

	const injectFn = (options: InjectOptions = {}) => {
		return inject(token, options);
	};

	return [injectFn, provideFn, provideExistingFn, token] as CreateInjectionTokenReturn<TTokenValue>;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/custom-element-class-settable.ts
```typescript
import { createInjectionToken } from './create-injection-token';

export interface CustomElementClassSettable {
	setClassToCustomElement: (newClass: string) => void;
}

export const [
	injectCustomClassSettable,
	provideCustomClassSettable,
	provideCustomClassSettableExisting,
	SET_CLASS_TO_CUSTOM_ELEMENT_TOKEN,
] = createInjectionToken<CustomElementClassSettable>('@spartan-ng SET_CLASS_TO_CUSTOM_ELEMENT_TOKEN');

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/dev-mode.ts
```typescript
declare const ngDevMode: boolean;
/**
 * Set by Angular to true when in development mode.
 * Allows for tree-shaking code that is only used in development.
 */
export const brnDevMode = ngDevMode;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/exposes-side.ts
```typescript
import type { Signal } from '@angular/core';
import { createInjectionToken } from './create-injection-token';

export interface ExposesSide {
	side: Signal<'top' | 'bottom' | 'left' | 'right'>;
}

export const [
	injectExposedSideProvider,
	provideExposedSideProvider,
	provideExposedSideProviderExisting,
	EXPOSES_SIDE_TOKEN,
] = createInjectionToken<ExposesSide>('@spartan-ng EXPOSES_SIDE_TOKEN');

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/exposes-state.ts
```typescript
import type { Signal } from '@angular/core';
import { createInjectionToken } from './create-injection-token';

export interface ExposesState {
	state: Signal<'open' | 'closed'>;
}

export const [
	injectExposesStateProvider,
	provideExposesStateProvider,
	provideExposesStateProviderExisting,
	EXPOSES_STATE_TOKEN,
] = createInjectionToken<ExposesState>('@spartan-ng EXPOSES_STATE_TOKEN');

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/hlm.ts
```typescript
import { type ClassValue, clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function hlm(...inputs: ClassValue[]) {
	return twMerge(clsx(inputs));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/table-classes-settable.ts
```typescript
import { createInjectionToken } from './create-injection-token';

export interface TableClassesSettable {
	setTableClasses: (classes: Partial<{ table: string; headerRow: string; bodyRow: string }>) => void;
}

export const [
	injectTableClassesSettable,
	provideTableClassesSettable,
	provideTableClassesSettableExisting,
	SET_TABLE_CLASSES_TOKEN,
] = createInjectionToken<TableClassesSettable>('@spartan-ng SET_TABLE_CLASSES_TOKEN');

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/core/src/helpers/zone-free.ts
```typescript
/**
 * We are building on shoulders of giants here and use the implementation provided by the incredible TaigaUI
 * team: https://github.com/taiga-family/taiga-ui/blob/main/projects/cdk/observables/zone-free.ts#L22
 * Check them out! Give them a try! Leave a star! Their work is incredible!
 */
import type { NgZone } from '@angular/core';
import { type MonoTypeOperatorFunction, Observable, pipe } from 'rxjs';

export function brnZoneFull<T>(zone: NgZone): MonoTypeOperatorFunction<T> {
	return (source) =>
		new Observable((subscriber) =>
			source.subscribe({
				next: (value) => zone.run(() => subscriber.next(value)),
				error: (error: unknown) => zone.run(() => subscriber.error(error)),
				complete: () => zone.run(() => subscriber.complete()),
			}),
		);
}

export function brnZoneFree<T>(zone: NgZone): MonoTypeOperatorFunction<T> {
	return (source) => new Observable((subscriber) => zone.runOutsideAngular(() => source.subscribe(subscriber)));
}

export function brnZoneOptimized<T>(zone: NgZone): MonoTypeOperatorFunction<T> {
	return pipe(brnZoneFree(zone), brnZoneFull(zone));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/progress/README.md
```
# @spartan-ng/brain/progress

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/progress`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/progress/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/progress/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnProgressIndicatorComponent } from './lib/brn-progress-indicator.component';
import { BrnProgressComponent } from './lib/brn-progress.component';
export { injectBrnProgress } from './lib/brn-progress.token';

export * from './lib/brn-progress-indicator.component';
export * from './lib/brn-progress.component';

export const BrnProgressImports = [BrnProgressComponent, BrnProgressIndicatorComponent] as const;

@NgModule({
	imports: [...BrnProgressImports],
	exports: [...BrnProgressImports],
})
export class BrnProgressModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/progress/src/lib/brn-progress-indicator.component.ts
```typescript
import { Component } from '@angular/core';
import { injectBrnProgress } from './brn-progress.token';

@Component({
	selector: 'brn-progress-indicator',
	standalone: true,
	template: '',
	host: {
		'[attr.data-state]': 'progress.state()',
		'[attr.data-value]': 'progress.value()',
		'[attr.data-max]': 'progress.max()',
	},
})
export class BrnProgressIndicatorComponent {
	protected readonly progress = injectBrnProgress();
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/progress/src/lib/brn-progress.component.spec.ts
```typescript
import { Component } from '@angular/core';
import { render } from '@testing-library/angular';
import { BrnProgressModule } from '../index';
import { BrnProgressIndicatorComponent } from './brn-progress-indicator.component';
import { BrnProgressComponent, BrnProgressLabelFn } from './brn-progress.component';

@Component({
	imports: [BrnProgressModule],
	template: `
		<brn-progress [value]="value" [max]="max" [getValueLabel]="getValueLabel">
			<brn-progress-indicator />
		</brn-progress>
	`,
})
class TestHostComponent {
	public value: number | null | undefined = 0;
	public max = 100;
	public getValueLabel: BrnProgressLabelFn = (value, max) => `${Math.round((value / max) * 100)}%`;
}

describe('BrnProgressComponent', () => {
	it('should initialize with default values and set aria attributes', async () => {
		const { container } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
		});
		const progressBar = container.querySelector('brn-progress');

		expect(progressBar?.getAttribute('aria-valuemax')).toBe('100');
		expect(progressBar?.getAttribute('aria-valuemin')).toBe('0');
		expect(progressBar?.getAttribute('aria-valuenow')).toBe('0');
		expect(progressBar?.getAttribute('aria-valuetext')).toBe('0%');
	});

	it('should display "indeterminate" state when value is null or undefined', async () => {
		const { fixture, container } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
			componentProperties: { value: null },
		});
		fixture.detectChanges();

		const progressBar = container.querySelector('brn-progress');
		expect(progressBar?.getAttribute('data-state')).toBe('indeterminate');
		expect(progressBar?.getAttribute('aria-valuetext')).toBe(null);
	});

	it('should set aria attributes based on provided value and max', async () => {
		const { fixture, container } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
			componentProperties: { value: 50, max: 200 },
		});
		fixture.detectChanges();

		const progressBar = container.querySelector('brn-progress');
		expect(progressBar?.getAttribute('aria-valuenow')).toBe('50');
		expect(progressBar?.getAttribute('aria-valuemax')).toBe('200');
		expect(progressBar?.getAttribute('aria-valuetext')).toBe('25%');
	});

	it('should set state to "complete" when value equals max', async () => {
		const { fixture, container } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
			componentProperties: { value: 100, max: 100 },
		});
		fixture.detectChanges();

		const progressBar = container.querySelector('brn-progress');
		expect(progressBar?.getAttribute('data-state')).toBe('complete');
	});

	it('should set state to "loading" when value is within bounds and not equal to max', async () => {
		const { fixture, container } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
			componentProperties: { value: 50, max: 100 },
		});
		fixture.detectChanges();

		const progressBar = container.querySelector('brn-progress');
		expect(progressBar?.getAttribute('data-state')).toBe('loading');
	});

	it('should throw an error if value is out of bounds', async () => {
		const { fixture } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
		});

		expect(() => {
			fixture.componentInstance.value = 150;
			fixture.detectChanges();
		}).toThrow('Value must be 0 or greater and less or equal to max');

		expect(() => {
			fixture.componentInstance.value = -10;
			fixture.detectChanges();
		}).toThrow('Value must be 0 or greater and less or equal to max');
	});

	it('should throw an error if max is set to a negative number', async () => {
		const { fixture } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
		});

		expect(() => {
			fixture.componentInstance.max = -50;
			fixture.detectChanges();
		}).toThrow('Value must be 0 or greater and less or equal to max');
	});

	it('should reflect state, value, and max in BrnProgressIndicatorComponent', async () => {
		const { fixture, container } = await render(TestHostComponent, {
			imports: [BrnProgressComponent, BrnProgressIndicatorComponent],
			componentProperties: { value: 30, max: 100 },
		});
		fixture.detectChanges();

		const indicator = container.querySelector('brn-progress-indicator');
		expect(indicator?.getAttribute('data-state')).toBe('loading');
		expect(indicator?.getAttribute('data-value')).toBe('30');
		expect(indicator?.getAttribute('data-max')).toBe('100');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/progress/src/lib/brn-progress.component.ts
```typescript
import { type NumberInput } from '@angular/cdk/coercion';
import { Component, OnChanges, SimpleChanges, computed, input, numberAttribute } from '@angular/core';
import { provideBrnProgress } from './brn-progress.token';

@Component({
	selector: 'brn-progress',
	standalone: true,
	template: '<ng-content/>',
	exportAs: 'brnProgress',
	providers: [provideBrnProgress(BrnProgressComponent)],
	host: {
		role: 'progressbar',
		'[attr.aria-valuemax]': 'max()',
		'[attr.aria-valuemin]': '0',
		'[attr.aria-valuenow]': 'value()',
		'[attr.aria-valuetext]': 'label()',
		'[attr.data-state]': 'state()',
		'[attr.data-value]': 'value()',
		'[attr.data-max]': 'max()',
	},
})
export class BrnProgressComponent implements OnChanges {
	public readonly value = input<number | null | undefined, NumberInput>(undefined, {
		transform: (value) => (value === undefined || value === null ? undefined : Number(value)),
	});
	public readonly max = input<number, NumberInput>(100, { transform: numberAttribute });
	public readonly getValueLabel = input<BrnProgressLabelFn>((value, max) => `${Math.round((value / max) * 100)}%`);
	protected readonly label = computed(() => {
		const value = this.value();
		return value === null || value === undefined ? undefined : this.getValueLabel()(value, this.max());
	});

	protected readonly state = computed(() => {
		const value = this.value();
		const max = this.max();

		return value === null || value === undefined ? 'indeterminate' : value === max ? 'complete' : 'loading';
	});

	ngOnChanges(changes: SimpleChanges): void {
		if ('value' in changes || 'max' in changes) {
			this.validate();
		}
	}

	private validate(): void {
		// validate that the value is within the bounds of the max
		const value = this.value();
		const max = this.max();

		if (value === null || value === undefined) {
			return;
		}

		if (value > max || value < 0) {
			throw Error('Value must be 0 or greater and less or equal to max');
		}

		if (max < 0) {
			throw Error('max must be greater than 0');
		}
	}
}

export type BrnProgressLabelFn = (value: number, max: number) => string;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/progress/src/lib/brn-progress.token.ts
```typescript
import { ExistingProvider, InjectionToken, Type, inject } from '@angular/core';
import type { BrnProgressComponent } from './brn-progress.component';

const BrnProgressToken = new InjectionToken<BrnProgressComponent>('BrnProgressComponent');

export function provideBrnProgress(progress: Type<BrnProgressComponent>): ExistingProvider {
	return { provide: BrnProgressToken, useExisting: progress };
}

export function injectBrnProgress(): BrnProgressComponent {
	return inject(BrnProgressToken);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/README.md
```
# @spartan-ng/brain/alert-dialog

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/alert-dialog`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnAlertDialogContentDirective } from './lib/brn-alert-dialog-content.directive';
import { BrnAlertDialogDescriptionDirective } from './lib/brn-alert-dialog-description.directive';
import { BrnAlertDialogOverlayComponent } from './lib/brn-alert-dialog-overlay.component';
import { BrnAlertDialogTitleDirective } from './lib/brn-alert-dialog-title.directive';
import { BrnAlertDialogTriggerDirective } from './lib/brn-alert-dialog-trigger.directive';
import { BrnAlertDialogComponent } from './lib/brn-alert-dialog.component';

export * from './lib/brn-alert-dialog-content.directive';
export * from './lib/brn-alert-dialog-description.directive';
export * from './lib/brn-alert-dialog-overlay.component';
export * from './lib/brn-alert-dialog-title.directive';
export * from './lib/brn-alert-dialog-trigger.directive';
export * from './lib/brn-alert-dialog.component';

export const BrnAlertDialogImports = [
	BrnAlertDialogComponent,
	BrnAlertDialogOverlayComponent,
	BrnAlertDialogTriggerDirective,
	BrnAlertDialogContentDirective,
	BrnAlertDialogTitleDirective,
	BrnAlertDialogDescriptionDirective,
] as const;

@NgModule({
	imports: [...BrnAlertDialogImports],
	exports: [...BrnAlertDialogImports],
})
export class BrnAlertDialogModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/src/lib/brn-alert-dialog-content.directive.ts
```typescript
import { Directive } from '@angular/core';
import { provideExposesStateProviderExisting } from '@spartan-ng/brain/core';
import { BrnDialogContentDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: '[brnAlertDialogContent]',
	standalone: true,
	providers: [provideExposesStateProviderExisting(() => BrnAlertDialogContentDirective)],
})
export class BrnAlertDialogContentDirective<T> extends BrnDialogContentDirective<T> {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/src/lib/brn-alert-dialog-description.directive.ts
```typescript
import { Directive } from '@angular/core';
import { BrnDialogDescriptionDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: '[brnAlertDialogDescription]',
	standalone: true,
	host: {
		'[id]': '_id()',
	},
})
export class BrnAlertDialogDescriptionDirective extends BrnDialogDescriptionDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/src/lib/brn-alert-dialog-overlay.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation } from '@angular/core';
import { provideCustomClassSettableExisting } from '@spartan-ng/brain/core';
import { BrnDialogOverlayComponent } from '@spartan-ng/brain/dialog';

@Component({
	selector: 'brn-alert-dialog-overlay',
	standalone: true,
	providers: [provideCustomClassSettableExisting(() => BrnAlertDialogOverlayComponent)],
	template: '',
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnAlertDialogOverlayComponent extends BrnDialogOverlayComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/src/lib/brn-alert-dialog-title.directive.ts
```typescript
import { Directive } from '@angular/core';
import { BrnDialogTitleDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: '[brnAlertDialogTitle]',
	standalone: true,
	host: {
		'[id]': '_id()',
	},
})
export class BrnAlertDialogTitleDirective extends BrnDialogTitleDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/src/lib/brn-alert-dialog-trigger.directive.ts
```typescript
import { Directive, effect, input, untracked } from '@angular/core';
import { BrnDialogTriggerDirective } from '@spartan-ng/brain/dialog';
import type { BrnAlertDialogComponent } from './brn-alert-dialog.component';

@Directive({
	selector: 'button[brnAlertDialogTrigger],button[brnAlertDialogTriggerFor]',
	standalone: true,
	host: {
		'[id]': 'id()',
		'aria-haspopup': 'dialog',
		'[attr.aria-expanded]': "state() === 'open' ? 'true': 'false'",
		'[attr.data-state]': 'state()',
		'[attr.aria-controls]': 'dialogId',
	},
})
export class BrnAlertDialogTriggerDirective extends BrnDialogTriggerDirective {
	public readonly brnAlertDialogTriggerFor = input<BrnAlertDialogComponent | undefined>();

	constructor() {
		super();
		effect(() => {
			const brnDialog = this.brnAlertDialogTriggerFor();
			untracked(() => {
				if (brnDialog) {
					this.mutableBrnDialogTriggerFor().set(brnDialog);
				}
			});
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/alert-dialog/src/lib/brn-alert-dialog.component.ts
```typescript
import { ChangeDetectionStrategy, Component, forwardRef, ViewEncapsulation } from '@angular/core';
import { BrnDialogComponent, BrnDialogDefaultOptions, provideBrnDialogDefaultOptions } from '@spartan-ng/brain/dialog';

export const BRN_ALERT_DIALOG_DEFAULT_OPTIONS: Partial<BrnDialogDefaultOptions> = {
	closeOnBackdropClick: false,
	closeOnOutsidePointerEvents: false,
	role: 'alertdialog',
};

@Component({
	selector: 'brn-alert-dialog',
	standalone: true,
	template: `
		<ng-content />
	`,
	providers: [
		{
			provide: BrnDialogComponent,
			useExisting: forwardRef(() => BrnAlertDialogComponent),
		},
		provideBrnDialogDefaultOptions(BRN_ALERT_DIALOG_DEFAULT_OPTIONS),
	],
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	exportAs: 'brnAlertDialog',
})
export class BrnAlertDialogComponent extends BrnDialogComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/accordion/README.md
```
# @spartan-ng/brain/accordion

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/accordion`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/accordion/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/accordion/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnAccordionContentComponent } from './lib/brn-accordion-content.component';
import {
	BrnAccordionDirective,
	BrnAccordionItemDirective,
	BrnAccordionTriggerDirective,
} from './lib/brn-accordion.directive';

export * from './lib/brn-accordion-content.component';
export * from './lib/brn-accordion.directive';

export const BrnAccordionImports = [
	BrnAccordionDirective,
	BrnAccordionContentComponent,
	BrnAccordionItemDirective,
	BrnAccordionTriggerDirective,
] as const;

@NgModule({
	imports: [...BrnAccordionImports],
	exports: [...BrnAccordionImports],
})
export class BrnAccordionModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/accordion/src/lib/brn-accordion-content.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, inject, signal } from '@angular/core';
import type { CustomElementClassSettable } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';
import { BrnAccordionItemDirective } from './brn-accordion.directive';

@Component({
	selector: 'brn-accordion-content',
	standalone: true,
	host: {
		'[attr.data-state]': 'state()',
		'[attr.aria-labelledby]': 'ariaLabeledBy',
		role: 'region',
		'[id]': 'id',
	},
	template: `
		<div [attr.inert]="_addInert()" style="overflow: hidden">
			<p [class]="_contentClass()">
				<ng-content />
			</p>
		</div>
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnAccordionContentComponent implements CustomElementClassSettable {
	private readonly _item = inject(BrnAccordionItemDirective);

	public readonly state = this._item.state;
	public readonly id = `brn-accordion-content-${this._item.id}`;
	public readonly ariaLabeledBy = `brn-accordion-trigger-${this._item.id}`;

	protected readonly _addInert = computed(() => (this.state() === 'closed' ? true : undefined));
	protected readonly _contentClass = signal<ClassValue>('');

	constructor() {
		if (!this._item) {
			throw Error('Accordion Content can only be used inside an AccordionItem. Add brnAccordionItem to parent.');
		}
	}

	public setClassToCustomElement(classes: ClassValue) {
		this._contentClass.set(classes);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/accordion/src/lib/brn-accordion.directive.spec.ts
```typescript
import { createEvent, fireEvent, render, screen, waitFor } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import {
	BrnAccordionDirective,
	BrnAccordionItemDirective,
	BrnAccordionTriggerDirective,
} from './brn-accordion.directive';

describe('BrnAccordionDirective', () => {
	const setup = async () => {
		const container = await render(
			`
      <div brnAccordion aria-label="acco">
        <div brnAccordionItem>
          <button brnAccordionTrigger aria-label="trigger">
            Is it accessible?
          </button>
          asdf
        </div>
        <div brnAccordionItem>
          <button brnAccordionTrigger aria-label="trigger">
            Is it styled?
          </button>
            Yes. It comes with default styles that match the other components' aesthetics.
        </div>
        <div brnAccordionItem>
          <button brnAccordionTrigger aria-label="trigger">
            Is it animated?
          </button>
            Yes. It's animated by default, but you can disable it if you prefer.
        </div>
      </div>
    `,
			{
				imports: [BrnAccordionDirective, BrnAccordionItemDirective, BrnAccordionTriggerDirective],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			triggers: screen.getAllByLabelText('trigger'),
			accordion: screen.getByLabelText('acco'),
		};
	};
	const setupMulti = async () => {
		const container = await render(
			`
      <div brnAccordion type="multiple" orientation="horizontal" aria-label="acco">
        <div brnAccordionItem>
          <button brnAccordionTrigger aria-label="trigger">
            Is it accessible?
          </button>
          asdf
        </div>
        <div brnAccordionItem>
          <button brnAccordionTrigger aria-label="trigger">
            Is it styled?
          </button>
            Yes. It comes with default styles that match the other components' aesthetics.
        </div>
        <div brnAccordionItem>
          <button brnAccordionTrigger aria-label="trigger">
            Is it animated?
          </button>
            Yes. It's animated by default, but you can disable it if you prefer.
        </div>
      </div>
    `,
			{
				imports: [BrnAccordionDirective, BrnAccordionItemDirective, BrnAccordionTriggerDirective],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			triggers: screen.getAllByLabelText('trigger'),
			accordion: screen.getByLabelText('acco'),
		};
	};
	const setupWithInput = async () => {
		const container = await render(
			`
      <div brnAccordion aria-label="acco">
        <div brnAccordionItem>
          <button brnAccordionTrigger aria-label="trigger">
           	Enter your name
          </button>

          <input data-testid="accordion-input" />
        </div>
      </div>
    `,
			{
				imports: [BrnAccordionDirective, BrnAccordionItemDirective, BrnAccordionTriggerDirective],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			trigger: screen.getByLabelText('trigger'),
			accordion: screen.getByLabelText('acco'),
			input: screen.getByTestId('accordion-input'),
		};
	};
	const validateOpenClosed = async (triggers: HTMLElement[], accordion: HTMLElement, openedTriggers: boolean[]) => {
		await waitFor(() => {
			expect(triggers[0]).toHaveAttribute('data-state', openedTriggers[0] ? 'open' : 'closed');
			expect(triggers[1]).toHaveAttribute('data-state', openedTriggers[1] ? 'open' : 'closed');
			expect(triggers[2]).toHaveAttribute('data-state', openedTriggers[2] ? 'open' : 'closed');
			const anyOpen = openedTriggers.some((t) => t);
			expect(accordion).toHaveAttribute('data-state', anyOpen ? 'open' : 'closed');
		});
	};

	describe('single accordion', () => {
		it('initial state all datastate closed', async () => {
			const { triggers, accordion } = await setup();
			await validateOpenClosed(triggers, accordion, [false, false, false]);
			expect(accordion).toHaveAttribute('data-orientation', 'vertical');
		});
		it('should open the trigger on click ', async () => {
			const { user, triggers, accordion } = await setup();
			await user.click(triggers[0]);
			await validateOpenClosed(triggers, accordion, [true, false, false]);
			await user.click(triggers[1]);
			await validateOpenClosed(triggers, accordion, [false, true, false]);
			await user.click(triggers[1]);
			await validateOpenClosed(triggers, accordion, [false, false, false]);
			await user.click(triggers[2]);
			await validateOpenClosed(triggers, accordion, [false, false, true]);
			await user.click(triggers[1]);
			await validateOpenClosed(triggers, accordion, [false, true, false]);
		});
		it('should open the trigger on enter and space ', async () => {
			const { user, triggers, accordion } = await setup();
			await user.keyboard('[Tab][Enter]');
			await validateOpenClosed(triggers, accordion, [true, false, false]);
			await user.keyboard('[Tab][Enter]');
			await validateOpenClosed(triggers, accordion, [false, true, false]);
			await user.keyboard('[Space]');
			await validateOpenClosed(triggers, accordion, [false, false, false]);
			await user.keyboard('[Tab][Enter]');
			await validateOpenClosed(triggers, accordion, [false, false, true]);
			await user.keyboard('{Shift>}[Tab]{/Shift}[Space]');
			await validateOpenClosed(triggers, accordion, [false, true, false]);
		});
		it('should open the trigger on enter and space and prevent default for enter also on second entry', async () => {
			const { user, accordion } = await setup();
			const keyboardEventEnter = createEvent.keyDown(accordion, {
				key: 'Enter',
				code: 'Enter',
				which: 13,
				keyCode: 13,
			});
			await user.keyboard('[Tab][Tab]');
			fireEvent(accordion, keyboardEventEnter);
			expect(keyboardEventEnter.defaultPrevented).toBe(true);
		});
	});
	describe('multi accordion', () => {
		it('initial state all datastate closed', async () => {
			const { triggers, accordion } = await setupMulti();
			await validateOpenClosed(triggers, accordion, [false, false, false]);
			expect(accordion).toHaveAttribute('data-orientation', 'horizontal');
		});
		it('should open the trigger on click ', async () => {
			const { user, triggers, accordion } = await setupMulti();

			await user.click(triggers[0]);
			await validateOpenClosed(triggers, accordion, [true, false, false]);
			await user.click(triggers[1]);
			await validateOpenClosed(triggers, accordion, [true, true, false]);
			await user.click(triggers[1]);
			await validateOpenClosed(triggers, accordion, [true, false, false]);
			await user.click(triggers[2]);
			await validateOpenClosed(triggers, accordion, [true, false, true]);
			await user.click(triggers[1]);
			await validateOpenClosed(triggers, accordion, [true, true, true]);
		});
	});
	describe('accordion with input', () => {
		it('should allow typing space', async () => {
			const { user, trigger, input } = await setupWithInput();

			// Open the accordion and tab to the input
			await user.click(trigger);
			await user.tab();

			expect(trigger).toHaveAttribute('data-state', 'open');
			expect(input).toHaveFocus();

			// Type a name with a space
			await user.type(input, 'John Doe');
			expect(input).toHaveValue('John Doe');

			// Go back to the trigger and hit space
			await user.tab({ shift: true });
			await user.keyboard('[Space]');

			// Trigger should be closed
			expect(trigger).toHaveAttribute('data-state', 'closed');
			expect(trigger).toHaveFocus();
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/accordion/src/lib/brn-accordion.directive.ts
```typescript
import { FocusKeyManager, FocusMonitor } from '@angular/cdk/a11y';
import { coerceBooleanProperty } from '@angular/cdk/coercion';
import {
	type AfterContentInit,
	Directive,
	ElementRef,
	HostListener,
	type OnDestroy,
	computed,
	contentChildren,
	effect,
	inject,
	input,
	signal,
	untracked,
} from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { fromEvent } from 'rxjs';

@Directive({
	selector: '[brnAccordionItem]',
	standalone: true,
	host: {
		'[attr.data-state]': 'state()',
	},
	exportAs: 'brnAccordionItem',
})
export class BrnAccordionItemDirective {
	private static _itemIdGenerator = 0;
	private readonly _accordion = inject(BrnAccordionDirective);
	public readonly isOpened = input(false, { transform: coerceBooleanProperty });

	public readonly id = BrnAccordionItemDirective._itemIdGenerator++;
	public readonly state = computed(() => (this._accordion.openItemIds().includes(this.id) ? 'open' : 'closed'));

	constructor() {
		if (!this._accordion) {
			throw Error('Accordion trigger can only be used inside an Accordion. Add brnAccordion to ancestor.');
		}
		effect(() => {
			const isOpened = this.isOpened();
			untracked(() => {
				if (isOpened) {
					this._accordion.openItem(this.id);
				} else {
					this._accordion.closeItem(this.id);
				}
			});
		});
	}
}

@Directive({
	selector: '[brnAccordionTrigger]',
	standalone: true,
	host: {
		'[attr.data-state]': 'state()',
		'[attr.aria-expanded]': 'state() === "open"',
		'[attr.aria-controls]': 'ariaControls',
		role: 'heading',
		'aria-level': '3',
		'[id]': 'id',
	},
})
export class BrnAccordionTriggerDirective {
	private readonly _accordion = inject(BrnAccordionDirective);
	private readonly _item = inject(BrnAccordionItemDirective);
	private readonly _elementRef = inject(ElementRef);

	public readonly state = this._item.state;
	public readonly id = `brn-accordion-trigger-${this._item.id}`;
	public readonly ariaControls = `brn-accordion-content-${this._item.id}`;

	constructor() {
		if (!this._accordion) {
			throw Error('Accordion trigger can only be used inside an Accordion. Add brnAccordion to ancestor.');
		}

		if (!this._item) {
			throw Error('Accordion trigger can only be used inside an AccordionItem. Add brnAccordionItem to parent.');
		}

		fromEvent(this._elementRef.nativeElement, 'focus')
			.pipe(takeUntilDestroyed())
			.subscribe(() => {
				this._accordion.setActiveItem(this);
			});
	}

	@HostListener('click', ['$event'])
	@HostListener('keyup.space', ['$event'])
	@HostListener('keyup.enter', ['$event'])
	protected toggle(event: Event): void {
		event.preventDefault();
		this._accordion.toggleItem(this._item.id);
	}

	public focus() {
		this._elementRef.nativeElement.focus();
	}
}

const HORIZONTAL_KEYS_TO_PREVENT_DEFAULT = [
	'ArrowLeft',
	'ArrowRight',
	'PageDown',
	'PageUp',
	'Home',
	'End',
	' ',
	'Enter',
];
const VERTICAL_KEYS_TO_PREVENT_DEFAULT = ['ArrowUp', 'ArrowDown', 'PageDown', 'PageUp', 'Home', 'End', ' ', 'Enter'];

@Directive({
	selector: '[brnAccordion]',
	standalone: true,
	host: {
		'[attr.data-state]': 'state()',
		'[attr.data-orientation]': 'orientation()',
	},
	exportAs: 'brnAccordion',
})
export class BrnAccordionDirective implements AfterContentInit, OnDestroy {
	private readonly _el = inject(ElementRef);
	private _keyManager?: FocusKeyManager<BrnAccordionTriggerDirective>;
	private readonly _focusMonitor = inject(FocusMonitor);

	private readonly _focused = signal<boolean>(false);
	private readonly _openItemIds = signal<number[]>([]);
	public readonly openItemIds = this._openItemIds.asReadonly();
	public readonly state = computed(() => (this._openItemIds().length > 0 ? 'open' : 'closed'));

	public triggers = contentChildren(BrnAccordionTriggerDirective, { descendants: true });

	public readonly type = input<'single' | 'multiple'>('single');
	public readonly dir = input<'ltr' | 'rtl' | null>(null);
	public readonly orientation = input<'horizontal' | 'vertical'>('vertical');

	public ngAfterContentInit() {
		this._keyManager = new FocusKeyManager<BrnAccordionTriggerDirective>(this.triggers())
			.withHomeAndEnd()
			.withPageUpDown()
			.withWrap();

		if (this.orientation() === 'horizontal') {
			this._keyManager.withHorizontalOrientation(this.dir() ?? 'ltr').withVerticalOrientation(false);
		}

		this._el.nativeElement.addEventListener('keydown', (event: KeyboardEvent) => {
			const target = event.target as HTMLElement;

			if (target.tagName === 'INPUT') return;

			this._keyManager?.onKeydown(event);
			this.preventDefaultEvents(event);
		});
		this._focusMonitor.monitor(this._el, true).subscribe((origin) => this._focused.set(origin !== null));
	}

	ngOnDestroy(): void {
		this._focusMonitor.stopMonitoring(this._el);
	}

	public setActiveItem(item: BrnAccordionTriggerDirective) {
		this._keyManager?.setActiveItem(item);
	}

	public toggleItem(id: number) {
		if (this._openItemIds().includes(id)) {
			this.closeItem(id);
			return;
		}
		this.openItem(id);
	}

	public openItem(id: number) {
		if (this.type() === 'single') {
			this._openItemIds.set([id]);
			return;
		}
		this._openItemIds.update((ids) => [...ids, id]);
	}
	public closeItem(id: number) {
		this._openItemIds.update((ids) => ids.filter((openId) => id !== openId));
	}

	private preventDefaultEvents(event: KeyboardEvent) {
		if (!this._focused()) return;
		if (!('key' in event)) return;

		const keys =
			this.orientation() === 'horizontal' ? HORIZONTAL_KEYS_TO_PREVENT_DEFAULT : VERTICAL_KEYS_TO_PREVENT_DEFAULT;
		if (keys.includes(event.key) && event.code !== 'NumpadEnter') {
			event.preventDefault();
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/separator/README.md
```
# @spartan-ng/brain/separator

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/separator`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/separator/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/separator/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { BrnSeparatorComponent } from './lib/brn-separator.component';

export * from './lib/brn-separator.component';

@NgModule({
	imports: [BrnSeparatorComponent],
	exports: [BrnSeparatorComponent],
})
export class BrnSeparatorModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/separator/src/lib/brn-separator.component.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { Component, booleanAttribute, computed, input } from '@angular/core';

export type BrnSeparatorOrientation = 'horizontal' | 'vertical';

@Component({
	selector: 'brn-separator',
	standalone: true,
	template: '',
	host: {
		'[role]': 'role()',
		'[attr.aria-orientation]': 'ariaOrientation()',
		'[attr.data-orientation]': 'orientation()',
	},
})
export class BrnSeparatorComponent {
	public readonly orientation = input<BrnSeparatorOrientation>('horizontal');
	public readonly decorative = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

	protected readonly role = computed(() => (this.decorative() ? 'none' : 'separator'));
	protected readonly ariaOrientation = computed(() =>
		this.decorative() ? undefined : this.orientation() === 'vertical' ? 'vertical' : undefined,
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/hover-card/README.md
```
# @spartan-ng/brain/hover-card

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/hover-card`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/hover-card/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/hover-card/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { BrnHoverCardContentDirective, BrnHoverCardTriggerDirective } from './lib/brn-hover-card-content.service';
import { BrnHoverCardComponent } from './lib/brn-hover-card.component';

export * from './lib/brn-hover-card-content.service';
export * from './lib/brn-hover-card.component';
export * from './lib/createHoverObservable';

export const BrnHoverCardImports = [
	BrnHoverCardComponent,
	BrnHoverCardContentDirective,
	BrnHoverCardTriggerDirective,
] as const;

@NgModule({
	imports: [...BrnHoverCardImports],
	exports: [...BrnHoverCardImports],
})
export class BrnHoverCardModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/hover-card/src/lib/brn-hover-card-content.service.ts
```typescript
import { FocusMonitor } from '@angular/cdk/a11y';
import {
	type ConnectedOverlayPositionChange,
	type ConnectedPosition,
	type FlexibleConnectedPositionStrategy,
	Overlay,
	type OverlayConfig,
	OverlayPositionBuilder,
	type OverlayRef,
} from '@angular/cdk/overlay';
import { TemplatePortal } from '@angular/cdk/portal';
import {
	computed,
	Directive,
	effect,
	ElementRef,
	inject,
	Injectable,
	input,
	NgZone,
	type OnDestroy,
	type OnInit,
	type Signal,
	signal,
	TemplateRef,
	untracked,
	ViewContainerRef,
} from '@angular/core';
import { toSignal } from '@angular/core/rxjs-interop';
import {
	type ExposesSide,
	type ExposesState,
	provideExposedSideProviderExisting,
	provideExposesStateProviderExisting,
} from '@spartan-ng/brain/core';
import { BehaviorSubject, fromEvent, merge, Observable, of, Subject } from 'rxjs';
import { delay, distinctUntilChanged, filter, map, share, switchMap, takeUntil, tap } from 'rxjs/operators';
import { createHoverObservable } from './createHoverObservable';

@Directive({
	selector: '[brnHoverCardContent]',
	standalone: true,
	exportAs: 'brnHoverCardContent',
	providers: [
		provideExposedSideProviderExisting(() => BrnHoverCardContentDirective),
		provideExposesStateProviderExisting(() => BrnHoverCardContentDirective),
	],
})
export class BrnHoverCardContentDirective implements ExposesState, ExposesSide {
	private readonly _contentService = inject(BrnHoverCardContentService);
	public readonly state = this._contentService.state;
	public readonly side = this._contentService.side;
	public readonly template = inject(TemplateRef);
}

/**
 * We are building on shoulders of giants here and use the implementation provided by the incredible TaigaUI
 * team: https://github.com/taiga-family/taiga-ui/blob/main/projects/core/directives/dropdown/dropdown-hover.directive.ts
 * Check them out! Give them a try! Leave a star! Their work is incredible!
 */

export type BrnHoverCardOptions = Partial<
	{
		attachTo: ElementRef;
		attachPositions: ConnectedPosition[];
		align: 'top' | 'bottom';
		sideOffset: number;
	} & OverlayConfig
>;

const topFirstPositions: ConnectedPosition[] = [
	{
		originX: 'center',
		originY: 'top',
		overlayX: 'center',
		overlayY: 'bottom',
	},
	{
		originX: 'center',
		originY: 'bottom',
		overlayX: 'center',
		overlayY: 'top',
	},
];
const bottomFirstPositions: ConnectedPosition[] = [
	{
		originX: 'center',
		originY: 'bottom',
		overlayX: 'center',
		overlayY: 'top',
	},
	{
		originX: 'center',
		originY: 'top',
		overlayX: 'center',
		overlayY: 'bottom',
	},
];

@Injectable()
export class BrnHoverCardContentService {
	private readonly _overlay = inject(Overlay);
	private readonly _zone = inject(NgZone);
	private readonly _psBuilder = inject(OverlayPositionBuilder);

	private readonly _content = signal<TemplatePortal<unknown> | null>(null);
	private readonly _state = signal<'open' | 'closed'>('closed');

	private _config: BrnHoverCardOptions = {};
	private _overlayRef?: OverlayRef;
	private _positionStrategy?: FlexibleConnectedPositionStrategy;
	private _destroyed$ = new Subject<void>();

	private readonly _positionChangesObservables$ = new BehaviorSubject<
		Observable<ConnectedOverlayPositionChange> | undefined
	>(undefined);
	private readonly _overlayHoveredObservables$ = new BehaviorSubject<Observable<boolean> | undefined>(undefined);

	public readonly positionChanges$: Observable<ConnectedOverlayPositionChange> = this._positionChangesObservables$.pipe(
		switchMap((positionChangeObservable) => (positionChangeObservable ? positionChangeObservable : of(undefined))),
		filter((change): change is NonNullable<ConnectedOverlayPositionChange> => change !== undefined && change !== null),
	);
	public readonly hovered$: Observable<boolean> = this._overlayHoveredObservables$.pipe(
		switchMap((overlayHoveredObservable) => (overlayHoveredObservable ? overlayHoveredObservable : of(false))),
	);

	public readonly state = this._state.asReadonly();
	public readonly side: Signal<'top' | 'bottom' | 'left' | 'right'> = toSignal(
		this.positionChanges$.pipe(
			map<ConnectedOverlayPositionChange, 'top' | 'bottom' | 'left' | 'right'>((change) =>
				// todo: better translation or adjusting hlm to take that into account
				change.connectionPair.originY === 'center'
					? change.connectionPair.originX === 'start'
						? 'left'
						: 'right'
					: change.connectionPair.originY,
			),
		),
		{ initialValue: 'bottom' },
	);

	public setConfig(config: BrnHoverCardOptions) {
		this._config = config;
		if (config.attachTo) {
			this._positionStrategy = this._psBuilder
				.flexibleConnectedTo(config.attachTo)
				.withPositions((config.attachPositions ?? config.align === 'top') ? topFirstPositions : bottomFirstPositions)
				.withDefaultOffsetY(config.sideOffset ?? 0);
			this._config = {
				...this._config,
				positionStrategy: this._positionStrategy,
				scrollStrategy: this._overlay.scrollStrategies.reposition(),
			};
			this._positionChangesObservables$.next(this._positionStrategy.positionChanges);
		}
		this._overlayRef = this._overlay.create(this._config);
	}

	public setContent(value: TemplateRef<unknown> | BrnHoverCardContentDirective, vcr: ViewContainerRef) {
		this._content.set(new TemplatePortal<unknown>(value instanceof TemplateRef ? value : value.template, vcr));

		if (!this._overlayRef) {
			this._overlayRef = this._overlay.create(this._config);
		}
	}

	public setState(newState: 'open' | 'closed') {
		this._state.set(newState);
	}

	public show() {
		const content = this._content();
		if (!content || !this._overlayRef) return;

		this._overlayRef?.detach();
		this._overlayRef?.attach(content);

		this._destroyed$ = new Subject<void>();

		this._overlayHoveredObservables$.next(
			createHoverObservable(this._overlayRef.hostElement, this._zone, this._destroyed$),
		);
	}

	public hide() {
		this._overlayRef?.detach();
		this._destroyed$.next();
		this._destroyed$.complete();
		this._destroyed$ = new Subject<void>();
	}
}

@Directive({
	selector: '[brnHoverCardTrigger]:not(ng-container),[brnHoverCardTriggerFor]:not(ng-container)',
	standalone: true,
	exportAs: 'brnHoverCardTrigger',
})
export class BrnHoverCardTriggerDirective implements OnInit, OnDestroy {
	private readonly _destroy$ = new Subject<void>();
	private readonly _vcr = inject(ViewContainerRef);
	private readonly _zone = inject(NgZone);
	private readonly _el = inject(ElementRef);
	private readonly _contentService = inject(BrnHoverCardContentService);
	private readonly _focusMonitor = inject(FocusMonitor);

	public readonly focused$: Observable<boolean> = this._focusMonitor.monitor(this._el).pipe(map((e) => e !== null));

	public readonly hovered$: Observable<boolean> = merge(
		fromEvent(this._el.nativeElement, 'click').pipe(map(() => false)),
		createHoverObservable(this._el.nativeElement, this._zone, this._destroy$),
		this._contentService.hovered$,
		this.focused$,
	).pipe(distinctUntilChanged());
	public readonly showing$: Observable<boolean> = this.hovered$.pipe(
		// we set the state to open here because we are about to open show the content
		tap((visible) => visible && this._contentService.setState('open')),
		switchMap((visible) => {
			// we are delaying based on the configure-able input
			return of(visible).pipe(delay(visible ? this.showDelay() : this.hideDelay()));
		}),
		switchMap((visible) => {
			// don't do anything when we are in the process of showing the content
			if (visible) return of(visible);
			// we set the state to closed here to trigger any animations for the element leaving
			this._contentService.setState('closed');
			// then delay to wait for the leaving animation to finish
			return of(visible).pipe(delay(this.animationDelay()));
		}),
		distinctUntilChanged(),
		share(),
		takeUntil(this._destroy$),
	);

	public showDelay = input(300);
	public hideDelay = input(500);
	public animationDelay = input(100);
	public sideOffset = input(5);
	public align = input<'top' | 'bottom'>('bottom');

	public readonly brnHoverCardTriggerFor = input<TemplateRef<unknown> | BrnHoverCardContentDirective | undefined>(
		undefined,
	);
	public readonly mutableBrnHoverCardTriggerFor = computed(() => signal(this.brnHoverCardTriggerFor()));
	private readonly _brnHoverCardTriggerForState = computed(() => this.mutableBrnHoverCardTriggerFor()());

	constructor() {
		effect(() => {
			const value = this._brnHoverCardTriggerForState();
			untracked(() => {
				if (value) {
					this._contentService.setContent(value, this._vcr);
				}
			});
		});
	}

	public ngOnInit() {
		this._contentService.setConfig({ attachTo: this._el, align: this.align(), sideOffset: this.sideOffset() });
		this.showing$.subscribe((isHovered) => {
			if (isHovered) {
				this._contentService.show();
			} else {
				this._contentService.hide();
			}
		});
	}

	public ngOnDestroy() {
		this._destroy$.next();
		this._destroy$.complete();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/hover-card/src/lib/brn-hover-card.component.ts
```typescript
import { type AfterContentInit, Component, contentChild } from '@angular/core';
import {
	BrnHoverCardContentDirective,
	BrnHoverCardContentService,
	BrnHoverCardTriggerDirective,
} from './brn-hover-card-content.service';

@Component({
	selector: 'brn-hover-card',
	standalone: true,
	providers: [BrnHoverCardContentService],
	template: `
		<ng-content />
	`,
})
export class BrnHoverCardComponent implements AfterContentInit {
	private readonly _trigger = contentChild(BrnHoverCardTriggerDirective);
	private readonly _content = contentChild(BrnHoverCardContentDirective);

	public ngAfterContentInit() {
		if (!this._trigger() || !this._content()) return;
		this._trigger()?.mutableBrnHoverCardTriggerFor().set(this._content());
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/hover-card/src/lib/createHoverObservable.ts
```typescript
import type { NgZone } from '@angular/core';
import { brnZoneOptimized } from '@spartan-ng/brain/core';
import { Observable, Subject, fromEvent, merge } from 'rxjs';
import { distinctUntilChanged, filter, map, takeUntil } from 'rxjs/operators';

function movedOut({ currentTarget, relatedTarget }: MouseEvent): boolean {
	return !isElement(relatedTarget) || !isElement(currentTarget) || !currentTarget.contains(relatedTarget);
}

export function isElement(node?: Element | EventTarget | Node | null): node is Element {
	return !!node && 'nodeType' in node && node.nodeType === Node.ELEMENT_NODE;
}

export const createHoverObservable = (
	nativeElement: HTMLElement,
	zone: NgZone,
	destroyed$: Subject<void>,
): Observable<boolean> => {
	return merge(
		fromEvent(nativeElement, 'mouseenter').pipe(map(() => true)),
		fromEvent(nativeElement, 'mouseleave').pipe(map(() => false)),
		// Hello, Safari
		fromEvent<MouseEvent>(nativeElement, 'mouseout').pipe(
			filter(movedOut),
			map(() => false),
		),
		/**
		 * NOTE: onmouseout events don't trigger when objects move under mouse in Safari
		 * https://bugs.webkit.org/show_bug.cgi?id=4117
		 */
		fromEvent(nativeElement, 'transitionend').pipe(map(() => nativeElement.matches(':hover'))),
	).pipe(distinctUntilChanged(), brnZoneOptimized(zone), takeUntil(destroyed$));
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/checkbox/README.md
```
# @spartan-ng/brain/checkbox

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/checkbox`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/checkbox/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/checkbox/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnCheckboxComponent } from './lib/brn-checkbox.component';

export * from './lib/brn-checkbox.component';

export const BrnCheckboxImports = [BrnCheckboxComponent] as const;

@NgModule({
	imports: [...BrnCheckboxImports],
	exports: [...BrnCheckboxImports],
})
export class BrnCheckboxModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/checkbox/src/lib/brn-checkbox-ng-model.spec.ts
```typescript
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';

import { Component, input, model } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BrnCheckboxComponent } from './brn-checkbox.component';

@Component({
	selector: 'brn-checkbox-ng-model',
	standalone: true,
	template: `
		<label>
			Airplane mode is: {{ airplaneMode() ? 'on' : 'off' }}
			<brn-checkbox [disabled]="disabled()" [(ngModel)]="airplaneMode"></brn-checkbox>
		</label>
	`,
	imports: [BrnCheckboxComponent, FormsModule],
})
export class BrnCheckboxNgModelSpecComponent {
	public readonly disabled = input(false);

	public readonly airplaneMode = model(false);
}

describe('BrnCheckboxComponentNgModelIntegration', () => {
	const setup = async (airplaneMode = false, disabled = false) => {
		const container = await render(BrnCheckboxNgModelSpecComponent, {
			componentInputs: {
				disabled,
				airplaneMode,
			},
		});
		const labelMatch = airplaneMode ? /airplane mode is: on/i : /airplane mode is: off/i;
		return {
			user: userEvent.setup(),
			container,
			checkboxElement: screen.getByLabelText(labelMatch),
			labelElement: screen.getByText(labelMatch),
		};
	};

	it('click should toggle value correctly', async () => {
		const { labelElement, user, container } = await setup();
		expect(labelElement).toBeInTheDocument();
		await user.click(labelElement);
		await screen.findByDisplayValue('on');
		expect(container.fixture.componentInstance.airplaneMode()).toBe(true);
	});

	it('should set input as default correctly and click should toggle then', async () => {
		const { labelElement, user, container } = await setup(true);

		await user.click(labelElement);
		await screen.findByDisplayValue('off');
		expect(container.fixture.componentInstance.airplaneMode()).toBe(false);

		await user.click(labelElement);
		await screen.findByDisplayValue('on');
		expect(container.fixture.componentInstance.airplaneMode()).toBe(true);
	});

	it('should set input as default correctly and enter should toggle then', async () => {
		const { user, container } = await setup(true);

		await user.keyboard('[Tab][Enter]');
		expect(container.fixture.componentInstance.airplaneMode()).toBe(false);

		await user.keyboard('[Enter]');
		expect(container.fixture.componentInstance.airplaneMode()).toBe(true);
	});

	it('should do nothing when disabled', async () => {
		const { labelElement, user, container } = await setup(false, true);

		await user.click(labelElement);
		await screen.findByDisplayValue('off');
		expect(container.fixture.componentInstance.airplaneMode()).toBe(false);

		await user.click(labelElement);
		await screen.findByDisplayValue('off');
		expect(container.fixture.componentInstance.airplaneMode()).toBe(false);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/checkbox/src/lib/brn-checkbox.component.spec.ts
```typescript
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import { axe } from 'jest-axe';
import { BrnCheckboxComponent } from './brn-checkbox.component';

describe('BrnCheckboxComponent', () => {
	const setup = async () => {
		const container = await render(
			`
     <brn-checkbox id='checkboxId' name='checkboxName' data-testid='checkbox' aria-label='checkbox'>
      </brn-checkbox>
    `,
			{
				imports: [BrnCheckboxComponent],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			checkboxElement: screen.getByLabelText('checkbox'),
		};
	};

	const setupInsideLabel = async () => {
		const container = await render(
			`
     <label data-testid='label'>
     Checkbox Inside Label
     <brn-checkbox id='checkboxId' data-testid='checkbox' name='checkboxName'>
      </brn-checkbox>
      </label>
    `,
			{
				imports: [BrnCheckboxComponent],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			checkboxElement: screen.getByLabelText(/checkbox inside label/i),
			labelElement: screen.getByText(/checkbox inside label/i),
		};
	};
	const setupInsideLabelDisabled = async () => {
		const container = await render(
			`
     <label data-testid='label'>
     Checkbox Inside Label
     <brn-checkbox disabled id='checkboxId' data-testid='checkbox' name='checkboxName'>
      </brn-checkbox>
      </label>
    `,
			{
				imports: [BrnCheckboxComponent],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			checkboxElement: screen.getByLabelText(/checkbox inside label/i),
			labelElement: screen.getByText(/checkbox inside label/i),
		};
	};

	const setupOutsideLabelWithAriaLabelledBy = async () => {
		const container = await render(
			`
     <!-- need for because arialabelledby only provides accessible name -->
     <label id='labelId' for='checkboxId' data-testid='label'>
     Checkbox Outside Label with ariaLabelledBy
     </label>
     <brn-checkbox id='checkboxId' name='checkboxName' data-testid='checkbox' aria-labelledby='labelId'>
      </brn-checkbox>
    `,
			{
				imports: [BrnCheckboxComponent],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			checkboxElement: screen.getByLabelText(/checkbox outside label with arialabelledby/i),
			labelElement: screen.getByText(/checkbox outside label with arialabelledby/i),
		};
	};

	const setupOutsideLabelWithForAndId = async () => {
		const container = await render(
			`
     <label for='checkboxId' data-testid='label'>
     Checkbox Outside Label with id
     </label>
     <brn-checkbox id='checkboxId' name='checkboxName' data-testid='checkbox'>
      </brn-checkbox>
    `,
			{
				imports: [BrnCheckboxComponent],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			checkboxElement: screen.getByLabelText(/checkbox outside label with id/i),
			labelElement: screen.getByText(/checkbox outside label with id/i),
		};
	};
	const setupOutsideLabelWithForAndIdDisabled = async () => {
		const container = await render(
			`
     <label for='checkboxId' data-testid='label'>
     Checkbox Outside Label with id
     </label>
     <brn-checkbox disabled id='checkboxId' name='checkboxName' data-testid='checkbox'>
      </brn-checkbox>
    `,
			{
				imports: [BrnCheckboxComponent],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			checkboxElement: screen.getByLabelText(/checkbox outside label with id/i),
			labelElement: screen.getByText(/checkbox outside label with id/i),
		};
	};

	type Options = Partial<{ focus: boolean; focusVisible: boolean; disabled: boolean }>;

	const validateAttributes = async (
		inputElement: HTMLElement,
		checkboxElement: HTMLElement,
		shouldBeChecked: boolean,
		opts?: Options,
	) => {
		expect(inputElement).toBeInTheDocument();
		expect(inputElement).toHaveAttribute('role', 'checkbox');
		expect(inputElement).toHaveAttribute('id', 'checkboxId');
		expect(inputElement).toHaveAttribute('name', 'checkboxName');
		expect(await axe(inputElement)).toHaveNoViolations();

		expect(checkboxElement).toHaveAttribute('id', 'checkboxId-checkbox');
		expect(checkboxElement).toHaveAttribute('name', 'checkboxName-checkbox');
		expect(checkboxElement).toHaveAttribute('data-state', shouldBeChecked ? 'checked' : 'unchecked');
		expect(checkboxElement).toHaveAttribute('data-disabled', `${!!opts?.disabled}`);
		expect(checkboxElement).toHaveAttribute('data-focus', `${!!opts?.focus}`);
		expect(checkboxElement).toHaveAttribute('data-focus-visible', `${!!opts?.focusVisible}`);
		expect(await axe(checkboxElement)).toHaveNoViolations();
	};
	const validateCheckboxOn = async (opts?: Options) => {
		const inputElement = await screen.findByDisplayValue('on');
		const checkboxElement = await screen.findByTestId('checkbox');

		await validateAttributes(inputElement, checkboxElement, true, opts);
	};
	const validateCheckboxOff = async (opts?: Options) => {
		const inputElement = await screen.findByDisplayValue('off');
		const checkboxElement = await screen.findByTestId('checkbox');

		await validateAttributes(inputElement, checkboxElement, false, opts);
	};

	describe('with aria-label', () => {
		it('unchecked by default', async () => {
			await setup();
			await validateCheckboxOff();
		});
		it('mouse click on element toggles', async () => {
			const { user, checkboxElement } = await setup();
			await validateCheckboxOff();
			await user.click(checkboxElement);
			await validateCheckboxOn({ focus: true });
			await user.click(checkboxElement);
			await validateCheckboxOff({ focus: true });
		});
		it('focus with tab and enter toggles', async () => {
			const { user } = await setup();
			const options = { focus: true, focusVisible: true };
			await validateCheckboxOff();
			await user.keyboard('[Tab][Enter]');
			await validateCheckboxOn(options);
			await user.keyboard('[Enter]');
			await validateCheckboxOff(options);
			await user.keyboard('[Enter]');
			await validateCheckboxOn(options);
		});
		it('focus with tab and space toggles', async () => {
			const { user } = await setup();
			const options = { focus: true, focusVisible: true };
			await validateCheckboxOff();
			await user.keyboard('[Tab][Space]');
			await validateCheckboxOn(options);
			await user.keyboard('[Space]');
			await validateCheckboxOff(options);
			await user.keyboard('[Space]');
			await validateCheckboxOn(options);
		});
	});

	describe('inside <label>', () => {
		it('unchecked by default', async () => {
			await setupInsideLabel();
			await validateCheckboxOff();
		});
		it('mouse click on element toggles', async () => {
			const { user, labelElement } = await setupInsideLabel();
			await validateCheckboxOff();
			await user.click(labelElement);
			await validateCheckboxOn({ focus: true });
			await user.click(labelElement);
			await validateCheckboxOff({ focus: true });
		});
		it('focus with tab and enter toggles', async () => {
			const { user } = await setupInsideLabel();
			const options = { focus: true, focusVisible: true };
			await validateCheckboxOff();
			await user.keyboard('[Tab][Enter]');
			await validateCheckboxOn(options);
			await user.keyboard('[Enter]');
			await validateCheckboxOff(options);
			await user.keyboard('[Enter]');
			await validateCheckboxOn(options);
		});
		it('focus with tab and space toggles', async () => {
			const { user } = await setupInsideLabel();
			const options = { focus: true, focusVisible: true };
			await validateCheckboxOff();
			await user.keyboard('[Tab][Space]');
			await validateCheckboxOn(options);
			await user.keyboard('[Space]');
			await validateCheckboxOff(options);
			await user.keyboard('[Space]');
			await validateCheckboxOn(options);
		});
		it('disabled', async () => {
			const { user } = await setupInsideLabelDisabled();
			// await validateCheckboxOff({ focus: false, focusVisible: false, disabled: true });
			const options = { focus: false, focusVisible: false, disabled: true };
			await user.keyboard('[Tab][Space]');
			await validateCheckboxOff(options);
			await user.keyboard('[Space]');
			await validateCheckboxOff(options);
			await user.keyboard('[Space]');
			await validateCheckboxOff(options);
			const label = await screen.findByTestId('label');
			expect(label).toHaveAttribute('data-disabled', 'true');
		});
	});

	describe('outside <label> with aria-labelledby', () => {
		it('unchecked by default', async () => {
			await setupOutsideLabelWithAriaLabelledBy();
			await validateCheckboxOff();
		});
		it('mouse click on element toggles', async () => {
			const { user, labelElement } = await setupOutsideLabelWithAriaLabelledBy();
			await validateCheckboxOff();
			await user.click(labelElement);
			await validateCheckboxOn({ focus: true });
			await user.click(labelElement);
			await validateCheckboxOff({ focus: true });
		});
		it('focus with tab and enter toggles', async () => {
			const { user } = await setupOutsideLabelWithAriaLabelledBy();
			const options = { focus: true, focusVisible: true };
			await validateCheckboxOff();
			await user.keyboard('[Tab][Enter]');
			await validateCheckboxOn(options);
			await user.keyboard('[Enter]');
			await validateCheckboxOff(options);
			await user.keyboard('[Enter]');
			await validateCheckboxOn(options);
		});
		it('focus with tab and space toggles', async () => {
			const { user } = await setupOutsideLabelWithAriaLabelledBy();
			const options = { focus: true, focusVisible: true };
			await validateCheckboxOff();
			await user.keyboard('[Tab][Space]');
			await validateCheckboxOn(options);
			await user.keyboard('[Space]');
			await validateCheckboxOff(options);
			await user.keyboard('[Space]');
			await validateCheckboxOn(options);
		});
	});

	describe('outside <label> with for and id', () => {
		it('unchecked by default', async () => {
			await setupOutsideLabelWithForAndId();
			await validateCheckboxOff();
		});
		it('mouse click on element toggles', async () => {
			const { user, labelElement } = await setupOutsideLabelWithForAndId();
			await validateCheckboxOff();
			await user.click(labelElement);
			await validateCheckboxOn({ focus: true });
			await user.click(labelElement);
			await validateCheckboxOff({ focus: true });
		});
		it('focus with tab and enter toggles', async () => {
			const { user } = await setupOutsideLabelWithForAndId();
			const options = { focus: true, focusVisible: true };
			await validateCheckboxOff();
			await user.keyboard('[Tab][Enter]');
			await validateCheckboxOn(options);
			await user.keyboard('[Enter]');
			await validateCheckboxOff(options);
			await user.keyboard('[Enter]');
			await validateCheckboxOn(options);
		});
		it('focus with tab and space toggles', async () => {
			const { user } = await setupOutsideLabelWithForAndId();
			const options = { focus: true, focusVisible: true };
			await validateCheckboxOff();
			await user.keyboard('[Tab][Space]');
			await validateCheckboxOn(options);
			await user.keyboard('[Space]');
			await validateCheckboxOff(options);
			await user.keyboard('[Space]');
			await validateCheckboxOn(options);
			const label = await screen.findByTestId('label');
			expect(label).toHaveAttribute('data-disabled', 'false');
		});
		it('sets data-disabled to the label toggles do not change anything', async () => {
			const { user } = await setupOutsideLabelWithForAndIdDisabled();
			const options = { focus: false, focusVisible: false, disabled: true };
			await validateCheckboxOff(options);
			await user.keyboard('[Tab][Space]');
			await validateCheckboxOff(options);
			await user.keyboard('[Space]');
			await validateCheckboxOff(options);
			await user.keyboard('[Space]');
			await validateCheckboxOff(options);
			const label = await screen.findByTestId('label');
			expect(label).toHaveAttribute('data-disabled', 'true');
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/checkbox/src/lib/brn-checkbox.component.ts
```typescript
import { FocusMonitor } from '@angular/cdk/a11y';
import { NgStyle, isPlatformBrowser } from '@angular/common';
import {
	type AfterContentInit,
	ChangeDetectionStrategy,
	Component,
	ElementRef,
	HostListener,
	type OnDestroy,
	PLATFORM_ID,
	Renderer2,
	ViewEncapsulation,
	booleanAttribute,
	computed,
	effect,
	forwardRef,
	inject,
	input,
	model,
	output,
	signal,
	viewChild,
} from '@angular/core';
import { NG_VALUE_ACCESSOR } from '@angular/forms';
import { ChangeFn, TouchFn } from '@spartan-ng/brain/forms';

export const BRN_CHECKBOX_VALUE_ACCESSOR = {
	provide: NG_VALUE_ACCESSOR,
	useExisting: forwardRef(() => BrnCheckboxComponent),
	multi: true,
};

export function indeterminateBooleanAttribute(value: unknown): boolean | 'indeterminate' {
	if (value === 'indeterminate') return 'indeterminate';
	return booleanAttribute(value);
}

const CONTAINER_POST_FIX = '-checkbox';

@Component({
	selector: 'brn-checkbox',
	imports: [NgStyle],
	template: `
		<input
			#checkBox
			tabindex="-1"
			type="checkbox"
			role="checkbox"
			[ngStyle]="{
				position: 'absolute',
				width: '1px',
				height: '1px',
				padding: '0',
				margin: '-1px',
				overflow: 'hidden',
				clip: 'rect(0, 0, 0, 0)',
				whiteSpace: 'nowrap',
				borderWidth: '0',
			}"
			[id]="id() ?? ''"
			[name]="name() ?? ''"
			[value]="_value()"
			[checked]="isChecked()"
			[required]="required()"
			[attr.aria-label]="ariaLabel()"
			[attr.aria-labelledby]="ariaLabelledby()"
			[attr.aria-describedby]="ariaDescribedby()"
			[attr.aria-required]="required() || null"
			[attr.aria-checked]="_ariaChecked()"
		/>
		<ng-content />
	`,
	host: {
		'[attr.tabindex]': 'state().disabled() ? "-1" : "0"',
		'[attr.data-state]': '_dataState()',
		'[attr.data-focus-visible]': 'focusVisible()',
		'[attr.data-focus]': 'focused()',
		'[attr.data-disabled]': 'state().disabled()',
		'[attr.aria-labelledby]': 'null',
		'[attr.aria-label]': 'null',
		'[attr.aria-describedby]': 'null',
		'[attr.id]': 'hostId()',
		'[attr.name]': 'hostName()',
	},
	providers: [BRN_CHECKBOX_VALUE_ACCESSOR],
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnCheckboxComponent implements AfterContentInit, OnDestroy {
	private readonly _renderer = inject(Renderer2);
	private readonly _elementRef = inject(ElementRef);
	private readonly _focusMonitor = inject(FocusMonitor);
	private readonly _isBrowser = isPlatformBrowser(inject(PLATFORM_ID));

	private readonly _focusVisible = signal(false);
	public readonly focusVisible = this._focusVisible.asReadonly();
	private readonly _focused = signal(false);
	public readonly focused = this._focused.asReadonly();

	public readonly checked = model<BrnCheckboxValue>(false);
	public readonly isChecked = this.checked.asReadonly();

	protected readonly _dataState = computed(() => {
		const checked = this.checked();
		if (checked === 'indeterminate') return 'indeterminate';
		return checked ? 'checked' : 'unchecked';
	});
	protected readonly _ariaChecked = computed(() => {
		const checked = this.checked();
		if (checked === 'indeterminate') return 'mixed';
		return checked ? 'true' : 'false';
	});
	protected readonly _value = computed(() => {
		const checked = this.checked();
		if (checked === 'indeterminate') return '';
		return checked ? 'on' : 'off';
	});

	/** Used to set the id on the underlying input element. */
	public readonly id = input<string | null>(null);
	protected readonly hostId = computed(() => (this.id() ? this.id() + CONTAINER_POST_FIX : null));

	/** Used to set the name attribute on the underlying input element. */
	public readonly name = input<string | null>(null);
	protected readonly hostName = computed(() => (this.name() ? this.name() + CONTAINER_POST_FIX : null));

	/** Used to set the aria-label attribute on the underlying input element. */
	public readonly ariaLabel = input<string | null>(null, { alias: 'aria-label' });

	/** Used to set the aria-labelledby attribute on the underlying input element. */
	public readonly ariaLabelledby = input<string | null>(null, { alias: 'aria-labelledby' });

	public readonly ariaDescribedby = input<string | null>(null, { alias: 'aria-describedby' });

	public readonly required = input(false, { transform: booleanAttribute });

	public readonly disabled = input(false, { transform: booleanAttribute });

	protected readonly state = computed(() => ({
		disabled: signal(this.disabled()),
	}));

	// eslint-disable-next-line @typescript-eslint/no-empty-function
	protected _onChange: ChangeFn<BrnCheckboxValue> = () => {};
	// eslint-disable-next-line @typescript-eslint/no-empty-function
	private _onTouched: TouchFn = () => {};

	public readonly checkbox = viewChild.required<ElementRef<HTMLInputElement>>('checkBox');

	public readonly changed = output<BrnCheckboxValue>();

	constructor() {
		effect(() => {
			const parent = this._renderer.parentNode(this._elementRef.nativeElement);
			if (!parent) return;
			// check if parent is a label and assume it is for this checkbox
			if (parent?.tagName === 'LABEL') {
				this._renderer.setAttribute(parent, 'data-disabled', this.state().disabled() ? 'true' : 'false');
				return;
			}
			if (!this._isBrowser) return;

			const label = parent?.querySelector(`label[for="${this.id()}"]`);
			if (!label) return;
			this._renderer.setAttribute(label, 'data-disabled', this.state().disabled() ? 'true' : 'false');
		});
	}

	@HostListener('click', ['$event'])
	@HostListener('keyup.space', ['$event'])
	@HostListener('keyup.enter', ['$event'])
	toggle(event: Event) {
		if (this.state().disabled()) return;
		event.preventDefault();
		const previousChecked = this.checked();
		this.checked.set(previousChecked === 'indeterminate' ? true : !previousChecked);
		this._onChange(!previousChecked);
		this.changed.emit(!previousChecked);
	}

	ngAfterContentInit() {
		this._focusMonitor.monitor(this._elementRef, true).subscribe((focusOrigin) => {
			if (focusOrigin) this._focused.set(true);
			if (focusOrigin === 'keyboard' || focusOrigin === 'program') {
				this._focusVisible.set(true);
			}
			if (!focusOrigin) {
				// When a focused element becomes disabled, the browser *immediately* fires a blur event.
				// Angular does not expect events to be raised during change detection, so any state
				// change (such as a form control's ng-touched) will cause a changed-after-checked error.
				// See https://github.com/angular/angular/issues/17793. To work around this, we defer
				// telling the form control it has been touched until the next tick.
				Promise.resolve().then(() => {
					this._focusVisible.set(false);
					this._focused.set(false);
					this._onTouched();
				});
			}
		});

		this.checkbox().nativeElement.indeterminate = this.checked() === 'indeterminate';
		if (this.checkbox().nativeElement.indeterminate) {
			this.checkbox().nativeElement.value = 'indeterminate';
		} else {
			this.checkbox().nativeElement.value = this.checked() ? 'on' : 'off';
		}
		this.checkbox().nativeElement.dispatchEvent(new Event('change'));
	}

	ngOnDestroy() {
		this._focusMonitor.stopMonitoring(this._elementRef);
	}

	writeValue(value: BrnCheckboxValue): void {
		if (value === 'indeterminate') {
			this.checked.set('indeterminate');
		} else {
			this.checked.set(!!value);
		}
	}

	registerOnChange(fn: ChangeFn<BrnCheckboxValue>): void {
		this._onChange = fn;
	}

	registerOnTouched(fn: TouchFn): void {
		this._onTouched = fn;
	}

	/** Implemented as a part of ControlValueAccessor. */
	setDisabledState(isDisabled: boolean): void {
		this.state().disabled.set(isDisabled);
	}

	/**
	 * If the space key is pressed, prevent the default action to stop the page from scrolling.
	 */
	@HostListener('keydown.space', ['$event'])
	protected preventScrolling(event: KeyboardEvent): void {
		event.preventDefault();
	}
}

type BrnCheckboxValue = boolean | 'indeterminate';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/label/README.md
```
# @spartan-ng/brain/label

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/label`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/label/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/label/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { BrnLabelDirective } from './lib/brn-label.directive';

export * from './lib/brn-label.directive';

@NgModule({
	imports: [BrnLabelDirective],
	exports: [BrnLabelDirective],
})
export class BrnLabelModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/label/src/lib/brn-label.directive.ts
```typescript
import { isPlatformBrowser } from '@angular/common';
import { Directive, ElementRef, type OnInit, PLATFORM_ID, inject, input, signal } from '@angular/core';
import { NgControl } from '@angular/forms';

let nextId = 0;

@Directive({
	selector: '[brnLabel]',
	standalone: true,
	host: {
		'[id]': 'id()',
		'[class.ng-invalid]': 'this._ngControl?.invalid || null',
		'[class.ng-dirty]': 'this._ngControl?.dirty || null',
		'[class.ng-valid]': 'this._ngControl?.valid || null',
		'[class.ng-touched]': 'this._ngControl?.touched || null',
	},
})
export class BrnLabelDirective implements OnInit {
	protected readonly _ngControl = inject(NgControl, { optional: true });

	public readonly id = input<string>(`brn-label-${nextId++}`);

	private readonly _isBrowser = isPlatformBrowser(inject(PLATFORM_ID));
	private readonly _element = inject(ElementRef).nativeElement;
	private _changes?: MutationObserver;
	private readonly _dataDisabled = signal<boolean | 'auto'>('auto');
	public readonly dataDisabled = this._dataDisabled.asReadonly();

	ngOnInit(): void {
		if (!this._isBrowser) return;
		this._changes = new MutationObserver((mutations: MutationRecord[]) => {
			mutations.forEach((mutation: MutationRecord) => {
				if (mutation.attributeName !== 'data-disabled') return;
				// eslint-disable-next-line
				const state = (mutation.target as any).attributes.getNamedItem(mutation.attributeName)?.value === 'true';
				this._dataDisabled.set(state ?? 'auto');
			});
		});
		this._changes?.observe(this._element, {
			attributes: true,
			childList: true,
			characterData: true,
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/README.md
```
# @spartan-ng/brain/slider

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/slider`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/index.ts
```typescript
import { BrnSliderRangeDirective } from './lib/brn-slider-range.directive';
import { BrnSliderThumbDirective } from './lib/brn-slider-thumb.directive';
import { BrnSliderTickDirective } from './lib/brn-slider-tick.directive';
import { BrnSliderTrackDirective } from './lib/brn-slider-track.directive';
import { BrnSliderDirective } from './lib/brn-slider.directive';

export * from './lib/brn-slider-range.directive';
export * from './lib/brn-slider-thumb.directive';
export * from './lib/brn-slider-tick.directive';
export * from './lib/brn-slider-track.directive';
export * from './lib/brn-slider.directive';
export * from './lib/brn-slider.token';

export const BrnSliderImports = [
	BrnSliderDirective,
	BrnSliderTrackDirective,
	BrnSliderThumbDirective,
	BrnSliderRangeDirective,
	BrnSliderTickDirective,
] as const;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/brn-slider-range.directive.ts
```typescript
import { Directive } from '@angular/core';
import { injectBrnSlider } from './brn-slider.token';

@Directive({
	selector: '[brnSliderRange]',
	host: {
		'[attr.data-disabled]': 'slider.disabled()',
		'[style.width.%]': 'slider.percentage()',
	},
})
export class BrnSliderRangeDirective {
	/** Access the slider */
	protected readonly slider = injectBrnSlider();
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/brn-slider-thumb.directive.ts
```typescript
import { DOCUMENT, isPlatformServer } from '@angular/common';
import { computed, Directive, ElementRef, HostListener, inject, PLATFORM_ID } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { fromEvent } from 'rxjs';
import { switchMap, takeUntil } from 'rxjs/operators';
import { injectBrnSlider } from './brn-slider.token';

@Directive({
	selector: '[brnSliderThumb]',
	host: {
		role: 'slider',
		'[attr.aria-valuenow]': 'slider.value()',
		'[attr.aria-valuemin]': 'slider.min()',
		'[attr.aria-valuemax]': 'slider.max()',
		'[attr.tabindex]': 'slider.disabled() ? -1 : 0',
		'[attr.data-disabled]': 'slider.disabled()',
		'[style.inset-inline-start]': 'thumbOffset()',
	},
})
export class BrnSliderThumbDirective {
	protected readonly slider = injectBrnSlider();
	private readonly _document = inject<Document>(DOCUMENT);
	private readonly _elementRef = inject<ElementRef<HTMLElement>>(ElementRef);
	private readonly _platform = inject(PLATFORM_ID);

	/**
	 * Offsets the thumb centre point while sliding to ensure it remains
	 * within the bounds of the slider when reaching the edges.
	 * Based on https://github.com/radix-ui/primitives/blob/main/packages/react/slider/src/slider.tsx
	 */
	protected readonly thumbOffset = computed(() => {
		// we can't compute the offset on the server
		if (isPlatformServer(this._platform)) {
			return this.slider.percentage() + '%';
		}

		const halfWidth = this._elementRef.nativeElement.offsetWidth / 2;
		const offset = this.linearScale([0, 50], [0, halfWidth]);
		const thumbInBoundsOffset = halfWidth - offset(this.slider.percentage());
		const percent = this.slider.percentage();

		return `calc(${percent}% + ${thumbInBoundsOffset}px)`;
	});

	constructor() {
		const mousedown = fromEvent<MouseEvent>(this._elementRef.nativeElement, 'pointerdown');
		const mouseup = fromEvent<MouseEvent>(this._document, 'pointerup');
		const mousemove = fromEvent<MouseEvent>(this._document, 'pointermove');

		// Listen for mousedown events on the slider thumb
		mousedown
			.pipe(
				switchMap(() => mousemove.pipe(takeUntil(mouseup))),
				takeUntilDestroyed(),
			)
			.subscribe(this.dragThumb.bind(this));
	}

	/** @internal */
	private dragThumb(event: MouseEvent): void {
		if (this.slider.disabled()) {
			return;
		}

		const rect = this.slider.track()?.elementRef.nativeElement.getBoundingClientRect();

		if (!rect) {
			return;
		}

		const percentage = (event.clientX - rect.left) / rect.width;

		this.slider.setValue(
			this.slider.min() + (this.slider.max() - this.slider.min()) * Math.max(0, Math.min(1, percentage)),
		);
	}

	/**
	 * Handle keyboard events.
	 * @param event
	 */
	@HostListener('keydown', ['$event'])
	protected handleKeydown(event: KeyboardEvent): void {
		const dir = getComputedStyle(this._elementRef.nativeElement).direction;
		let multiplier = event.shiftKey ? 10 : 1;
		const value = this.slider.value();

		// if the slider is RTL, flip the multiplier
		if (dir === 'rtl') {
			multiplier = event.shiftKey ? -10 : -1;
		}

		switch (event.key) {
			case 'ArrowLeft':
				this.slider.setValue(Math.max(value - this.slider.step() * multiplier, this.slider.min()));
				event.preventDefault();
				break;
			case 'ArrowRight':
				this.slider.setValue(Math.min(value + this.slider.step() * multiplier, this.slider.max()));
				event.preventDefault();
				break;
			case 'Home':
				this.slider.setValue(this.slider.min());
				event.preventDefault();
				break;
			case 'End':
				this.slider.setValue(this.slider.max());
				event.preventDefault();
				break;
		}
	}

	private linearScale(input: readonly [number, number], output: readonly [number, number]): (value: number) => number {
		return (value: number) => {
			if (input[0] === input[1] || output[0] === output[1]) return output[0];
			const ratio = (output[1] - output[0]) / (input[1] - input[0]);
			return output[0] + ratio * (value - input[0]);
		};
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/brn-slider-tick.directive.ts
```typescript
import { Directive, effect, EmbeddedViewRef, inject, OnDestroy, TemplateRef, ViewContainerRef } from '@angular/core';
import { injectBrnSlider } from './brn-slider.token';

@Directive({
	selector: '[brnSliderTick]',
})
export class BrnSliderTickDirective implements OnDestroy {
	private readonly _slider = injectBrnSlider();
	private readonly _templateRef = inject<TemplateRef<BrnSliderTickContext>>(TemplateRef);
	private readonly _viewContainer = inject(ViewContainerRef);
	private _ticks: EmbeddedViewRef<BrnSliderTickContext>[] = [];

	constructor() {
		effect(() => {
			const ticks = this._slider.ticks();

			// remove any existing ticks
			this._ticks.forEach((tick) => this._viewContainer.remove(this._viewContainer.indexOf(tick)));

			// create new ticks
			this._ticks = [];

			ticks.forEach((tick, index) => {
				const view = this._viewContainer.createEmbeddedView(this._templateRef, {
					$implicit: tick,
					index,
					position: (index / (ticks.length - 1)) * 100,
				});
				this._ticks.push(view);
			});
		});
	}

	ngOnDestroy(): void {
		this._ticks.forEach((tick) => this._viewContainer.remove(this._viewContainer.indexOf(tick)));
	}
}

interface BrnSliderTickContext {
	$implicit: number;
	index: number;
	position: number;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/brn-slider-track.directive.ts
```typescript
import { Directive, ElementRef, HostListener, inject } from '@angular/core';
import { provideBrnSliderTrack } from './brn-slider-track.token';
import { injectBrnSlider } from './brn-slider.token';

@Directive({
	selector: '[brnSliderTrack]',
	providers: [provideBrnSliderTrack(BrnSliderTrackDirective)],
	host: {
		'[attr.data-disabled]': 'slider.disabled()',
	},
})
export class BrnSliderTrackDirective {
	/** Access the slider */
	protected readonly slider = injectBrnSlider();

	/** @internal Access the slider track */
	public readonly elementRef = inject<ElementRef<HTMLElement>>(ElementRef);

	constructor() {
		this.slider.track.set(this);
	}

	@HostListener('mousedown', ['$event'])
	protected moveThumbToPoint(event: MouseEvent): void {
		if (this.slider.disabled()) {
			return;
		}

		const position = event.clientX;
		const rect = this.elementRef.nativeElement.getBoundingClientRect();
		const percentage = (position - rect.left) / rect.width;

		// update the value based on the position
		this.slider.setValue(this.slider.min() + (this.slider.max() - this.slider.min()) * percentage);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/brn-slider-track.token.ts
```typescript
import { ExistingProvider, inject, InjectionToken, Type } from '@angular/core';
import type { BrnSliderTrackDirective } from './brn-slider-track.directive';

export const BrnSliderTrackToken = new InjectionToken<BrnSliderTrackDirective>('BrnSliderTrackToken');

export function provideBrnSliderTrack(slider: Type<BrnSliderTrackDirective>): ExistingProvider {
	return { provide: BrnSliderTrackToken, useExisting: slider };
}

export function injectBrnSliderTrack(): BrnSliderTrackDirective {
	return inject(BrnSliderTrackToken);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/brn-slider.directive.ts
```typescript
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import {
	booleanAttribute,
	ChangeDetectorRef,
	computed,
	Directive,
	ElementRef,
	inject,
	input,
	linkedSignal,
	model,
	numberAttribute,
	OnInit,
	signal,
} from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { ChangeFn, TouchFn } from '@spartan-ng/brain/forms';
import type { BrnSliderTrackDirective } from './brn-slider-track.directive';
import { provideBrnSlider } from './brn-slider.token';

@Directive({
	selector: '[brnSlider]',
	exportAs: 'brnSlider',
	providers: [
		provideBrnSlider(BrnSliderDirective),
		{
			provide: NG_VALUE_ACCESSOR,
			useExisting: BrnSliderDirective,
			multi: true,
		},
	],
	host: {
		'aria-orientation': 'horizontal',
		'(focusout)': '_onTouched?.()',
	},
})
export class BrnSliderDirective implements ControlValueAccessor, OnInit {
	private readonly _changeDetectorRef = inject(ChangeDetectorRef);
	private readonly _elementRef = inject<ElementRef<HTMLElement>>(ElementRef);

	public readonly value = model<number>(0);

	public readonly min = input<number, NumberInput>(0, {
		transform: numberAttribute,
	});

	public readonly max = input<number, NumberInput>(100, {
		transform: numberAttribute,
	});

	public readonly step = input<number, NumberInput>(1, {
		transform: numberAttribute,
	});

	public readonly _disabled = input<boolean, BooleanInput>(false, {
		alias: 'disabled',
		transform: booleanAttribute,
	});

	/** Whether we should show tick marks */
	public readonly showTicks = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** @internal */
	public readonly ticks = computed(() => {
		const value = this.value();

		if (!this.showTicks()) {
			return [];
		}

		let numActive = Math.max(Math.floor((value - this.min()) / this.step()), 0);
		let numInactive = Math.max(Math.floor((this.max() - value) / this.step()), 0);

		const direction = getComputedStyle(this._elementRef.nativeElement).direction;

		direction === 'rtl' ? numInactive++ : numActive++;

		return Array(numActive).fill(true).concat(Array(numInactive).fill(false));
	});

	/** @internal */
	public readonly disabled = linkedSignal(() => this._disabled());

	/** @internal */
	public readonly percentage = computed(() => ((this.value() - this.min()) / (this.max() - this.min())) * 100);

	/** @internal Store the on change callback */
	protected _onChange?: ChangeFn<number>;

	/** @internal Store the on touched callback */
	protected _onTouched?: TouchFn;

	/** @internal Store the track */
	public readonly track = signal<BrnSliderTrackDirective | null>(null);

	ngOnInit(): void {
		// ensure the value is within the min and max range
		if (this.value() < this.min()) {
			this.value.set(this.min());
		}
		if (this.value() > this.max()) {
			this.value.set(this.max());
		}
	}

	registerOnChange(fn: (value: number) => void): void {
		this._onChange = fn;
	}

	registerOnTouched(fn: () => void): void {
		this._onTouched = fn;
	}

	setDisabledState(isDisabled: boolean): void {
		this.disabled.set(isDisabled);
	}

	writeValue(value: number): void {
		const clampedValue = clamp(value, [this.min(), this.max()]);
		this.value.set(clampedValue);

		if (value !== clampedValue) {
			this._onChange?.(clampedValue);
		}

		this._changeDetectorRef.detectChanges();
	}

	setValue(value: number): void {
		const decimalCount = getDecimalCount(this.step());
		const snapToStep = roundValue(
			Math.round((value - this.min()) / this.step()) * this.step() + this.min(),
			decimalCount,
		);

		value = clamp(snapToStep, [this.min(), this.max()]);

		this.value.set(value);
		this._onChange?.(value);
	}
}

function roundValue(value: number, decimalCount: number): number {
	const rounder = Math.pow(10, decimalCount);
	return Math.round(value * rounder) / rounder;
}

function getDecimalCount(value: number): number {
	return (String(value).split('.')[1] || '').length;
}

function clamp(value: number, [min, max]: [number, number]): number {
	return Math.min(max, Math.max(min, value));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/brn-slider.token.ts
```typescript
import { ExistingProvider, inject, InjectionToken, Type } from '@angular/core';
import type { BrnSliderDirective } from './brn-slider.directive';

const BrnSliderToken = new InjectionToken<BrnSliderDirective>('BrnSliderToken');

export function provideBrnSlider(slider: Type<BrnSliderDirective>): ExistingProvider {
	return { provide: BrnSliderToken, useExisting: slider };
}

export function injectBrnSlider(): BrnSliderDirective {
	return inject(BrnSliderToken);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/tests/brn-slider-reactive-form.spec.ts
```typescript
import { render } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import { ReactiveFormSliderComponent } from './brn-slider-states.component';

async function setupSlider() {
	const { getByRole, getByTestId, fixture } = await render(ReactiveFormSliderComponent);

	return {
		fixture,
		thumb: getByRole('slider'),
		changeValueBtn: getByTestId('change-value-btn'),
		valueIndicatorPre: getByTestId('value-indicator-pre'),
	};
}

describe('Reactive Form Slider State', () => {
	it('should reflect the correct value indicator and the related aria attributes when selecting a value between min and max', async () => {
		const { thumb, valueIndicatorPre, fixture } = await setupSlider();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 46');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('46');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

		fixture.componentInstance.changeValue(25);
		fixture.detectChanges();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 25');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('25');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
	});

	it('Should reflect the correct value indicator and the related aria attributes when selecting a value below min', async () => {
		const { thumb, valueIndicatorPre, fixture } = await setupSlider();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 46');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('46');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

		fixture.componentInstance.changeValue(-25);
		fixture.detectChanges();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 0');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
	});

	it('Should reflect the correct value indicator and the related aria attributes when selecting a value after max', async () => {
		const { fixture, thumb, valueIndicatorPre } = await setupSlider();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 46');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('46');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

		//simulate slider dragging/selecting a value
		fixture.componentInstance.changeValue(225);
		fixture.detectChanges();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 100');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('100');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
	});

	it('Should reflect the correct value indicator and the related aria attributes when changing the slider value', async () => {
		const { thumb, fixture, changeValueBtn, valueIndicatorPre } = await setupSlider();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 46');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('46');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

		//simulate slider dragging/selecting a value
		fixture.componentInstance.changeValue(225);
		fixture.detectChanges();

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 100');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('100');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

		//change slider value using a button
		await userEvent.click(changeValueBtn);

		expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 24');
		expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('24');
		expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
		expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/tests/brn-slider-states.component.ts
```typescript
import { Component, model } from '@angular/core';
import { FormControl, FormGroup, FormsModule, ReactiveFormsModule } from '@angular/forms';
import {
	BrnSliderDirective,
	BrnSliderRangeDirective,
	BrnSliderThumbDirective,
	BrnSliderTrackDirective,
} from '../../index';

@Component({
	template: `
		<div>
			<pre data-testid="value-indicator-pre">Temperature: {{ temperature() }}</pre>
		</div>
		<form ngForm>
			<div brnSlider aria-label="fallback-label" [min]="0" [(ngModel)]="temperature" name="temperature">
				<div brnSliderTrack>
					<div brnSliderRange></div>
				</div>

				<span brnSliderThumb></span>
			</div>
		</form>
		<button data-testid="change-value-btn" (click)="changeValue(24)">Change temperature value</button>
	`,
	imports: [FormsModule, BrnSliderDirective, BrnSliderThumbDirective, BrnSliderTrackDirective, BrnSliderRangeDirective],
})
export class TemplateDrivenFormSliderComponent {
	public readonly temperature = model<number>(0);

	changeValue(value: number) {
		this.temperature.set(value);
	}
}

@Component({
	template: `
		<div>
			<pre data-testid="value-indicator-pre">
				Temperature: {{ temperatureGroup.controls.temperature.getRawValue() }}
			</pre
			>
		</div>
		<form [formGroup]="temperatureGroup">
			<div brnSlider aria-label="fallback-label" [min]="0" formControlName="temperature">
				<div brnSliderTrack>
					<div brnSliderRange></div>
				</div>

				<span brnSliderThumb></span>
			</div>
		</form>
		<button data-testid="change-value-btn" (click)="changeValue(24)">Change temperature value</button>
	`,
	imports: [
		ReactiveFormsModule,
		BrnSliderDirective,
		BrnSliderThumbDirective,
		BrnSliderTrackDirective,
		BrnSliderRangeDirective,
	],
})
export class ReactiveFormSliderComponent {
	public readonly temperature = model<number>(46);

	protected readonly temperatureGroup = new FormGroup({
		temperature: new FormControl<number>(this.temperature()),
	});

	changeValue(value: number) {
		this.temperatureGroup.controls.temperature.patchValue(value);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/slider/src/lib/tests/brn-slider-template-driven-form.spec.ts
```typescript
import { render } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import { TemplateDrivenFormSliderComponent } from './brn-slider-states.component';

async function setupSlider() {
	const { fixture, getByRole, getByTestId } = await render(TemplateDrivenFormSliderComponent);

	return {
		fixture,
		thumb: getByRole('slider'),
		changeValueBtn: getByTestId('change-value-btn'),
		valueIndicatorPre: getByTestId('value-indicator-pre'),
	};
}

async function setupSliderWithInitialValue(initialValue: number) {
	const { getByRole, getByTestId, fixture } = await render(TemplateDrivenFormSliderComponent, {
		componentInputs: { temperature: initialValue },
	});

	return {
		fixture,
		thumb: getByRole('slider'),
		changeValueBtn: getByTestId('change-value-btn'),
		valueIndicatorPre: getByTestId('value-indicator-pre'),
	};
}

describe('Template Driven Form Slider State', () => {
	describe('Default Initial Value', () => {
		it('Should reflect the correct value indicator and the related aria attributes when selecting a value between min and max', async () => {
			const { thumb, fixture, valueIndicatorPre } = await setupSlider();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 0');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(25);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 25');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('25');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});

		it('Should reflect the correct value indicator and the related aria attributes when selecting a value below min', async () => {
			const { thumb, valueIndicatorPre, fixture } = await setupSlider();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 0');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(-25);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 0');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});

		it('Should reflect the correct value indicator and the related aria attributes when selecting a value after max', async () => {
			const { thumb, valueIndicatorPre, fixture } = await setupSlider();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 0');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(225);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 100');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('100');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});

		it('Should reflect the correct value indicator and the related aria attributes when changing the slider value', async () => {
			const { fixture, thumb, changeValueBtn, valueIndicatorPre } = await setupSlider();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 0');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(225);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 100');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('100');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//change slider value using a button
			await userEvent.click(changeValueBtn);

			fixture.detectChanges();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 24');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('24');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});
	});

	describe('With Initial Value', () => {
		it('Should reflect the correct value indicator and the related aria attributes when selecting a value between min and max', async () => {
			const { fixture, thumb, valueIndicatorPre } = await setupSliderWithInitialValue(12);

			fixture.detectChanges();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 12');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('12');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(25);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 25');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('25');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});

		it('Should reflect the correct value indicator and the related aria attributes when selecting a value below min', async () => {
			const { fixture, thumb, valueIndicatorPre } = await setupSliderWithInitialValue(67);

			fixture.detectChanges();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 67');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('67');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(-25);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 0');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});

		it('Should reflect the correct value indicator and the related aria attributes when selecting a value after max', async () => {
			const { fixture, thumb, valueIndicatorPre } = await setupSliderWithInitialValue(34);

			fixture.detectChanges();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 34');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('34');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(225);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 100');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('100');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});

		it('Should reflect the correct value indicator and the related aria attributes when changing the slider value', async () => {
			const { fixture, thumb, changeValueBtn, valueIndicatorPre } = await setupSliderWithInitialValue(88);

			fixture.detectChanges();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 88');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('88');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//simulate slider dragging/selecting a value
			fixture.componentInstance.changeValue(225);
			fixture.detectChanges();
			await fixture.whenStable();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 100');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('100');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');

			//change slider value using a button
			await userEvent.click(changeValueBtn);

			fixture.detectChanges();

			expect(valueIndicatorPre.textContent?.trim()).toBe('Temperature: 24');
			expect(thumb.getAttribute('aria-valuenow')?.trim()).toBe('24');
			expect(thumb.getAttribute('aria-valuemin')?.trim()).toBe('0');
			expect(thumb.getAttribute('aria-valuemax')?.trim()).toBe('100');
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/date-time-luxon/README.md
```
# @spartan-ng/brain/date-time-luxon

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/date-time-luxon`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/date-time-luxon/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/date-time-luxon/src/index.ts
```typescript
export * from './lib/date-adapter';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/date-time-luxon/src/lib/date-adapter.ts
```typescript
import { BrnDateAdapter, BrnDateUnits, BrnDuration } from '@spartan-ng/brain/date-time';
import { DateTime } from 'luxon';

export class BrnLuxonDateAdapter implements BrnDateAdapter<DateTime> {
	now() {
		return DateTime.now();
	}

	set(date: DateTime, values: BrnDateUnits) {
		return date.set(values);
	}

	add(date: DateTime, duration: BrnDuration) {
		return date.plus(duration);
	}

	subtract(date: DateTime, duration: BrnDuration) {
		return date.minus(duration);
	}

	compare(a: DateTime, b: DateTime): number {
		if (a < b) {
			return -1;
		}

		if (a > b) {
			return 1;
		}

		return 0;
	}

	isEqual(a: DateTime, b: DateTime): boolean {
		return a.equals(b);
	}

	isBefore(a: DateTime, b: DateTime): boolean {
		return a < b;
	}

	isAfter(a: DateTime, b: DateTime): boolean {
		return a > b;
	}

	isSameDay(a: DateTime, b: DateTime): boolean {
		return a.hasSame(b, 'day') && a.hasSame(b, 'month') && a.hasSame(b, 'year');
	}

	isSameMonth(a: DateTime, b: DateTime): boolean {
		return a.hasSame(b, 'month') && a.hasSame(b, 'year');
	}

	isSameYear(a: DateTime, b: DateTime): boolean {
		return a.hasSame(b, 'year');
	}

	getYear(date: DateTime): number {
		return date.year;
	}

	getMonth(date: DateTime): number {
		return date.month;
	}

	getDate(date: DateTime): number {
		return date.day;
	}

	getDay(date: DateTime): number {
		return date.weekday;
	}

	getHours(date: DateTime): number {
		return date.hour;
	}

	getMinutes(date: DateTime): number {
		return date.minute;
	}

	getSeconds(date: DateTime): number {
		return date.second;
	}

	getMilliseconds(date: DateTime): number {
		return date.millisecond;
	}

	getTime(date: DateTime<boolean>): number {
		return date.toMillis();
	}

	startOfMonth(date: DateTime) {
		return date.startOf('month');
	}

	endOfMonth(date: DateTime) {
		return date.endOf('month');
	}

	startOfDay(date: DateTime) {
		return date.startOf('day');
	}

	endOfDay(date: DateTime) {
		return date.endOf('day');
	}

	create(values: BrnDateUnits) {
		return DateTime.fromObject(values);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle-group/README.md
```
# @spartan-ng/brain/toggle-group

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/toggle-group`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle-group/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle-group/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { BrnToggleGroupComponent } from './lib/brn-toggle-group.component';
import { BrnToggleGroupItemDirective } from './lib/brn-toggle-item.directive';

export * from './lib/brn-toggle-group.component';
export * from './lib/brn-toggle-item.directive';

@NgModule({
	imports: [BrnToggleGroupItemDirective, BrnToggleGroupComponent],
	exports: [BrnToggleGroupItemDirective, BrnToggleGroupComponent],
})
export class BrnToggleGroupModule {}

@NgModule({
	imports: [BrnToggleGroupItemDirective],
	exports: [BrnToggleGroupItemDirective],
})
export class BrnToggleGroupItemModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle-group/src/lib/brn-toggle-group.component.spec.ts
```typescript
import { Component, Input } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { fireEvent, render } from '@testing-library/angular';
import { BrnToggleGroupComponent } from './brn-toggle-group.component';
import { BrnToggleGroupItemDirective } from './brn-toggle-item.directive';

@Component({
	standalone: true,
	imports: [BrnToggleGroupItemDirective, BrnToggleGroupComponent],
	template: `
		<brn-toggle-group [(value)]="value" [disabled]="disabled" [multiple]="multiple">
			<button brnToggleGroupItem value="option-1">Option 1</button>
			<button brnToggleGroupItem value="option-2">Option 2</button>
			<button brnToggleGroupItem value="option-3">Option 3</button>
		</brn-toggle-group>
	`,
})
class BrnToggleGroupDirectiveSpecComponent {
	@Input() public value?: string | string[];
	@Input() public disabled = false;
	@Input() public multiple = false;
}

@Component({
	standalone: true,
	imports: [BrnToggleGroupItemDirective, BrnToggleGroupComponent, FormsModule],
	template: `
		<brn-toggle-group [(ngModel)]="value" [multiple]="multiple">
			<button brnToggleGroupItem value="option-1">Option 1</button>
			<button brnToggleGroupItem value="option-2">Option 2</button>
			<button brnToggleGroupItem value="option-3">Option 3</button>
		</brn-toggle-group>
	`,
})
class BrnToggleGroupDirectiveFormSpecComponent {
	@Input() public value?: string | string[];
	@Input() public multiple = false;
}

describe('BrnToggleGroupDirective', () => {
	it('should allow only a single selected toggle button when multiple is false', async () => {
		const { getAllByRole } = await render(BrnToggleGroupDirectiveSpecComponent);
		const buttons = getAllByRole('button');

		expect(buttons[0]).toHaveAttribute('data-state', 'off');
		expect(buttons[1]).toHaveAttribute('data-state', 'off');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');

		await fireEvent.click(buttons[0]);
		expect(buttons[0]).toHaveAttribute('data-state', 'on');
		expect(buttons[1]).toHaveAttribute('data-state', 'off');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');

		await fireEvent.click(buttons[1]);
		expect(buttons[0]).toHaveAttribute('data-state', 'off');
		expect(buttons[1]).toHaveAttribute('data-state', 'on');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');
	});

	it('should allow multiple selected toggle buttons when multiple is true', async () => {
		const { getAllByRole, detectChanges } = await render(BrnToggleGroupDirectiveSpecComponent, {
			inputs: {
				multiple: true,
			},
		});
		const buttons = getAllByRole('button');

		expect(buttons[0]).toHaveAttribute('data-state', 'off');
		expect(buttons[1]).toHaveAttribute('data-state', 'off');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');

		await fireEvent.click(buttons[0]);
		detectChanges();
		expect(buttons[0]).toHaveAttribute('data-state', 'on');
		expect(buttons[1]).toHaveAttribute('data-state', 'off');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');

		await fireEvent.click(buttons[1]);
		detectChanges();
		expect(buttons[0]).toHaveAttribute('data-state', 'on');
		expect(buttons[1]).toHaveAttribute('data-state', 'on');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');
	});

	it('should disable all toggle buttons when disabled is true', async () => {
		const { getAllByRole } = await render(BrnToggleGroupDirectiveSpecComponent, {
			inputs: {
				disabled: true,
			},
		});
		const buttons = getAllByRole('button');

		expect(buttons[0]).toHaveAttribute('disabled');
		expect(buttons[1]).toHaveAttribute('disabled');
		expect(buttons[2]).toHaveAttribute('disabled');
	});

	it('should initially select the button with the provided value (multiple = false)', async () => {
		const { getAllByRole, detectChanges } = await render(BrnToggleGroupDirectiveFormSpecComponent, {
			inputs: {
				value: 'option-2',
			},
		});
		detectChanges();
		const buttons = getAllByRole('button');

		expect(buttons[0]).toHaveAttribute('data-state', 'off');
		expect(buttons[1]).toHaveAttribute('data-state', 'on');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');
	});

	it('should initially select the buttons with the provided values (multiple = true)', async () => {
		const { getAllByRole, detectChanges } = await render(BrnToggleGroupDirectiveFormSpecComponent, {
			inputs: {
				value: ['option-1', 'option-3'],
				multiple: true,
			},
		});
		detectChanges();
		const buttons = getAllByRole('button');

		expect(buttons[0]).toHaveAttribute('data-state', 'on');
		expect(buttons[1]).toHaveAttribute('data-state', 'off');
		expect(buttons[2]).toHaveAttribute('data-state', 'on');
	});

	it('should initially select the button with the provided value (multiple = false) using ngModel', async () => {
		const { getAllByRole, detectChanges } = await render(BrnToggleGroupDirectiveFormSpecComponent, {
			inputs: {
				value: 'option-2',
			},
		});
		detectChanges();
		const buttons = getAllByRole('button');

		expect(buttons[0]).toHaveAttribute('data-state', 'off');
		expect(buttons[1]).toHaveAttribute('data-state', 'on');
		expect(buttons[2]).toHaveAttribute('data-state', 'off');
	});

	it('should initially select the buttons with the provided values (multiple = true) using ngModel', async () => {
		const { getAllByRole, detectChanges } = await render(BrnToggleGroupDirectiveFormSpecComponent, {
			inputs: {
				value: ['option-1', 'option-3'],
				multiple: true,
			},
		});
		detectChanges();
		const buttons = getAllByRole('button');

		expect(buttons[0]).toHaveAttribute('data-state', 'on');
		expect(buttons[1]).toHaveAttribute('data-state', 'off');
		expect(buttons[2]).toHaveAttribute('data-state', 'on');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle-group/src/lib/brn-toggle-group.component.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { Component, booleanAttribute, computed, forwardRef, input, model, output, signal } from '@angular/core';
import { type ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { provideBrnToggleGroup } from './brn-toggle-group.token';
import { BrnToggleGroupItemDirective } from './brn-toggle-item.directive';

export const BRN_BUTTON_TOGGLE_GROUP_VALUE_ACCESSOR = {
	provide: NG_VALUE_ACCESSOR,
	useExisting: forwardRef(() => BrnToggleGroupComponent),
	multi: true,
};

export class BrnButtonToggleChange<T = unknown> {
	constructor(
		public source: BrnToggleGroupItemDirective<T>,
		public value: ToggleValue<T>,
	) {}
}

@Component({
	selector: 'brn-toggle-group',
	standalone: true,
	providers: [provideBrnToggleGroup(BrnToggleGroupComponent), BRN_BUTTON_TOGGLE_GROUP_VALUE_ACCESSOR],
	host: {
		role: 'group',
		class: 'brn-button-toggle-group',
		'[attr.aria-disabled]': 'state().disabled()',
		'[attr.data-disabled]': 'state().disabled()',
		'[attr.data-vertical]': 'vertical()',
		'(focusout)': 'onTouched()',
	},
	exportAs: 'brnToggleGroup',
	template: `
		<ng-content />
	`,
})
export class BrnToggleGroupComponent<T = unknown> implements ControlValueAccessor {
	/**
	 * The method to be called in order to update ngModel.
	 */
	// eslint-disable-next-line @typescript-eslint/no-empty-function
	private _onChange: (value: ToggleValue<T>) => void = () => {};

	/** onTouch function registered via registerOnTouch (ControlValueAccessor). */
	// eslint-disable-next-line @typescript-eslint/no-empty-function
	protected onTouched: () => void = () => {};

	/** Whether the button toggle group has a vertical orientation */
	public readonly vertical = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** Value of the toggle group. */
	public readonly value = model<ToggleValue<T>>(undefined);

	/** Whether no button toggles need to be selected. */
	public readonly nullable = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** Whether multiple button toggles can be selected. */
	public readonly multiple = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** Whether the button toggle group is disabled. */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** The internal state of the component. This can be replaced with linkedSignal in the future. */
	public readonly state = computed(() => ({
		disabled: signal(this.disabled()),
	}));

	/** Emit event when the group value changes. */
	public readonly change = output<BrnButtonToggleChange<T>>();

	writeValue(value: ToggleValue<T>): void {
		this.value.set(value);
	}

	registerOnChange(fn: (value: ToggleValue<T>) => void) {
		this._onChange = fn;
	}

	registerOnTouched(fn: () => void) {
		this.onTouched = fn;
	}

	setDisabledState(isDisabled: boolean): void {
		this.state().disabled.set(isDisabled);
	}

	/**
	 * @internal
	 * Determines whether a value can be set on the group.
	 */
	canDeselect(value: ToggleValue<T>): boolean {
		// if null values are allowed, the group can always be nullable
		if (this.nullable()) return true;

		const currentValue = this.value();

		if (this.multiple() && Array.isArray(currentValue)) {
			return !(currentValue.length === 1 && currentValue[0] === value);
		}

		return currentValue !== value;
	}

	/**
	 * @internal
	 * Selects a value.
	 */
	select(value: T, source: BrnToggleGroupItemDirective<T>): void {
		if (this.state().disabled() || this.isSelected(value)) {
			return;
		}

		const currentValue = this.value();

		// emit the valueChange event here as we should only emit based on user interaction
		if (this.multiple()) {
			this.emitSelectionChange([...((currentValue ?? []) as T[]), value], source);
		} else {
			this.emitSelectionChange(value, source);
		}

		this._onChange(this.value());
		this.change.emit(new BrnButtonToggleChange<T>(source, this.value()));
	}

	/**
	 * @internal
	 * Deselects a value.
	 */
	deselect(value: T, source: BrnToggleGroupItemDirective<T>): void {
		if (this.state().disabled() || !this.isSelected(value) || !this.canDeselect(value)) {
			return;
		}

		const currentValue = this.value();

		if (this.multiple()) {
			this.emitSelectionChange(
				((currentValue ?? []) as T[]).filter((v) => v !== value),
				source,
			);
		} else if (currentValue === value) {
			this.emitSelectionChange(null, source);
		}
	}

	/**
	 * @internal
	 * Determines whether a value is selected.
	 */
	isSelected(value: T): boolean {
		const currentValue = this.value();

		if (
			currentValue == null ||
			currentValue === undefined ||
			(Array.isArray(currentValue) && currentValue.length === 0)
		) {
			return false;
		}

		if (this.multiple()) {
			return (currentValue as T[])?.includes(value);
		}
		return currentValue === value;
	}

	/** Update the value of the group */
	private emitSelectionChange(value: ToggleValue<T>, source: BrnToggleGroupItemDirective<T>): void {
		this.value.set(value);
		this._onChange(value);
		this.change.emit(new BrnButtonToggleChange<T>(source, this.value()));
	}
}

type ToggleValue<T> = T | T[] | null | undefined;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle-group/src/lib/brn-toggle-group.token.ts
```typescript
import { ExistingProvider, InjectionToken, Type, inject } from '@angular/core';
import type { BrnToggleGroupComponent } from './brn-toggle-group.component';

const BrnToggleGroupToken = new InjectionToken<BrnToggleGroupComponent>('BrnToggleGroupToken');

export function injectBrnToggleGroup<T>(): BrnToggleGroupComponent<T> | null {
	return inject(BrnToggleGroupToken, { optional: true }) as BrnToggleGroupComponent<T> | null;
}

export function provideBrnToggleGroup<T>(value: Type<BrnToggleGroupComponent<T>>): ExistingProvider {
	return { provide: BrnToggleGroupToken, useExisting: value };
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle-group/src/lib/brn-toggle-item.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { ChangeDetectorRef, Directive, booleanAttribute, computed, inject, input, model } from '@angular/core';
import { injectBrnToggleGroup } from './brn-toggle-group.token';

@Directive({
	selector: 'button[hlmToggleGroupItem], button[brnToggleGroupItem]',
	standalone: true,
	host: {
		'[id]': 'id()',
		'[attr.disabled]': 'disabled() || group?.disabled() ? true : null',
		'[attr.data-disabled]': 'disabled() || group?.disabled() ? true : null',
		'[attr.data-state]': '_state()',
		'[attr.aria-pressed]': 'isOn()',
		'(click)': 'toggle()',
	},
})
export class BrnToggleGroupItemDirective<T> {
	private static _uniqueId = 0;

	private readonly _changeDetector = inject(ChangeDetectorRef);

	/** Access the toggle group if available. */
	protected readonly group = injectBrnToggleGroup<T>();

	/** The id of the toggle. */
	public readonly id = input(`brn-toggle-group-item-${BrnToggleGroupItemDirective._uniqueId++}`);

	/** The value this toggle represents. */
	public readonly value = input<T>();

	/** Whether the toggle is disabled. */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** The current state of the toggle when not used in a group. */
	public readonly state = model<'on' | 'off'>('off');

	/** Whether the toggle is responds to click events. */
	public readonly disableToggleClick = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** Whether the toggle is in the on state. */
	protected readonly isOn = computed(() => this._state() === 'on');

	/** The current state that reflects the group state or the model state. */
	protected readonly _state = computed(() => {
		if (this.group) {
			return this.group.isSelected(this.value() as T) ? 'on' : 'off';
		}
		return this.state();
	});

	toggle(): void {
		if (this.disableToggleClick()) return;

		if (this.group) {
			if (this.isOn()) {
				this.group.deselect(this.value() as T, this);
			} else {
				this.group.select(this.value() as T, this);
			}
		} else {
			this.state.set(this.isOn() ? 'off' : 'on');
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle/README.md
```
# @spartan-ng/brain/toggle

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/toggle`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { BrnToggleDirective } from './lib/brn-toggle.directive';

export * from './lib/brn-toggle.directive';

@NgModule({
	imports: [BrnToggleDirective],
	exports: [BrnToggleDirective],
})
export class BrnToggleModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle/src/lib/brn-toggle.directive.spec.ts
```typescript
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import { BrnToggleDirective } from './brn-toggle.directive';

describe('BrnToggleDirective', () => {
	const setup = async (disabled = false) => {
		const container = await render(
			`
     <button ${disabled ? 'disabled' : ''} brnToggle>Toggle</button>
    `,
			{
				imports: [BrnToggleDirective],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			toggle: screen.getByRole('button'),
		};
	};

	it('should be toggled off by default and then toggle between on and off on for click', async () => {
		const { toggle, container, user } = await setup();
		expect(toggle).not.toHaveAttribute('data-disabled');
		expect(toggle).not.toHaveAttribute('disabled');

		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');

		await user.click(toggle);
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'on');

		await user.click(toggle);
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');
	});

	it('should be toggled off by default and then toggle between on and off on for enter', async () => {
		const { toggle, container, user } = await setup();
		expect(toggle).not.toHaveAttribute('data-disabled');
		expect(toggle).not.toHaveAttribute('disabled');

		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');

		await user.keyboard('[Tab][Enter]');
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'on');

		await user.keyboard('[Enter]');
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');
	});

	it('should be toggled off by default and then toggle between on and off on for space', async () => {
		const { toggle, container, user } = await setup();
		expect(toggle).not.toHaveAttribute('data-disabled');
		expect(toggle).not.toHaveAttribute('disabled');

		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');

		await user.keyboard('[Tab][Space]');
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'on');

		await user.keyboard('[Space]');
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');
	});

	it('should add correct id, aria and disabled toggling when disabled', async () => {
		const { toggle, container, user } = await setup(true);
		expect(toggle).toHaveAttribute('data-state', 'off');
		expect(toggle).toHaveAttribute('id', expect.stringMatching(/brn-toggle-\d+/));
		expect(toggle).toHaveAttribute('data-disabled');
		expect(toggle).toHaveAttribute('disabled');

		await user.keyboard('[Tab][Space]');
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');

		await user.click(toggle);
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');

		await user.keyboard('[Enter]');
		container.detectChanges();
		expect(toggle).toHaveAttribute('data-state', 'off');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/toggle/src/lib/brn-toggle.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { ChangeDetectorRef, Directive, booleanAttribute, computed, inject, input, model } from '@angular/core';

@Directive({
	selector: 'button[hlmToggle], button[brnToggle]',
	standalone: true,
	host: {
		'[id]': 'id()',
		'[attr.disabled]': 'disabled() ? true : null',
		'[attr.data-disabled]': 'disabled() ? true : null',
		'[attr.data-state]': '_state()',
		'[attr.aria-pressed]': 'isOn()',
		'(click)': 'toggle()',
	},
})
export class BrnToggleDirective<T> {
	private static _uniqueId = 0;

	private readonly _changeDetector = inject(ChangeDetectorRef);

	/** The id of the toggle. */
	public readonly id = input(`brn-toggle-${BrnToggleDirective._uniqueId++}`);

	/** The value this toggle represents. */
	public readonly value = input<T>();

	/** Whether the toggle is disabled. */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** The current state of the toggle when not used in a group. */
	public readonly state = model<'on' | 'off'>('off');

	/** Whether the toggle is responds to click events. */
	public readonly disableToggleClick = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** Whether the toggle is in the on state. */
	protected readonly isOn = computed(() => this._state() === 'on');

	/** The current state that reflects the group state or the model state. */
	protected readonly _state = computed(() => {
		return this.state();
	});

	toggle(): void {
		if (this.disableToggleClick()) return;

		this.state.set(this.isOn() ? 'off' : 'on');
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/README.md
```
# @spartan-ng/brain/dialog

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/dialog`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnDialogCloseDirective } from './lib/brn-dialog-close.directive';
import { BrnDialogContentDirective } from './lib/brn-dialog-content.directive';
import { BrnDialogDescriptionDirective } from './lib/brn-dialog-description.directive';
import { BrnDialogOverlayComponent } from './lib/brn-dialog-overlay.component';
import { BrnDialogTitleDirective } from './lib/brn-dialog-title.directive';
import { BrnDialogTriggerDirective } from './lib/brn-dialog-trigger.directive';
import { BrnDialogComponent } from './lib/brn-dialog.component';

export * from './lib/brn-dialog-close.directive';
export * from './lib/brn-dialog-content.directive';
export * from './lib/brn-dialog-description.directive';
export * from './lib/brn-dialog-options';
export * from './lib/brn-dialog-overlay.component';
export * from './lib/brn-dialog-ref';
export * from './lib/brn-dialog-state';
export * from './lib/brn-dialog-title.directive';
export * from './lib/brn-dialog-token';
export * from './lib/brn-dialog-trigger.directive';
export * from './lib/brn-dialog-utils';
export * from './lib/brn-dialog.component';
export * from './lib/brn-dialog.service';

export const BrnDialogImports = [
	BrnDialogComponent,
	BrnDialogOverlayComponent,
	BrnDialogTriggerDirective,
	BrnDialogCloseDirective,
	BrnDialogContentDirective,
	BrnDialogTitleDirective,
	BrnDialogDescriptionDirective,
] as const;

@NgModule({
	imports: [...BrnDialogImports],
	exports: [...BrnDialogImports],
})
export class BrnDialogModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-close.directive.ts
```typescript
import { coerceNumberProperty } from '@angular/cdk/coercion';
import { Directive, inject, input } from '@angular/core';
import { BrnDialogRef } from './brn-dialog-ref';

@Directive({
	selector: 'button[brnDialogClose]',
	standalone: true,
	host: {
		'(click)': 'close()',
	},
})
export class BrnDialogCloseDirective {
	private readonly _brnDialogRef = inject(BrnDialogRef);

	public readonly delay = input<number | undefined, number>(undefined, { transform: coerceNumberProperty });

	public close() {
		this._brnDialogRef.close(undefined, this.delay());
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-content.directive.ts
```typescript
import { computed, Directive, effect, inject, input, TemplateRef, untracked } from '@angular/core';
import { provideExposesStateProviderExisting } from '@spartan-ng/brain/core';
import { BrnDialogRef } from './brn-dialog-ref';
import { BrnDialogComponent } from './brn-dialog.component';

@Directive({
	selector: '[brnDialogContent]',
	standalone: true,
	providers: [provideExposesStateProviderExisting(() => BrnDialogContentDirective)],
})
export class BrnDialogContentDirective<T> {
	private readonly _brnDialog = inject(BrnDialogComponent, { optional: true });
	private readonly _brnDialogRef = inject(BrnDialogRef, { optional: true });
	private readonly _template = inject(TemplateRef);
	public readonly state = computed(() => this._brnDialog?.stateComputed() ?? this._brnDialogRef?.state() ?? 'closed');

	public readonly className = input<string | null | undefined>(undefined, { alias: 'class' });

	public readonly context = input<T | undefined>(undefined);

	constructor() {
		if (!this._brnDialog) return;
		this._brnDialog.registerTemplate(this._template);
		effect(() => {
			const context = this.context();
			if (!this._brnDialog || !context) return;
			untracked(() => this._brnDialog?.setContext(context));
		});
		effect(() => {
			if (!this._brnDialog) return;
			const newClass = this.className();
			untracked(() => this._brnDialog?.setPanelClass(newClass));
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-description.directive.ts
```typescript
import { Directive, effect, inject, signal } from '@angular/core';
import { BrnDialogRef } from './brn-dialog-ref';

@Directive({
	selector: '[brnDialogDescription]',
	standalone: true,
	host: {
		'[id]': '_id()',
	},
})
export class BrnDialogDescriptionDirective {
	private readonly _brnDialogRef = inject(BrnDialogRef);

	protected _id = signal(`brn-dialog-description-${this._brnDialogRef?.dialogId}`);

	constructor() {
		effect(() => {
			this._brnDialogRef.setAriaDescribedBy(this._id());
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-options.ts
```typescript
import type { AutoFocusTarget } from '@angular/cdk/dialog';
import type {
	ConnectedPosition,
	FlexibleConnectedPositionStrategyOrigin,
	PositionStrategy,
	ScrollStrategy,
} from '@angular/cdk/overlay';
import type { ElementRef, StaticProvider } from '@angular/core';

export type BrnDialogOptions = {
	id: string;
	role: 'dialog' | 'alertdialog';
	hasBackdrop: boolean;
	panelClass: string | string[];
	backdropClass: string | string[];
	positionStrategy: PositionStrategy | null | undefined;
	scrollStrategy: ScrollStrategy | null | undefined;
	restoreFocus: boolean | string | ElementRef;
	closeDelay: number;
	closeOnOutsidePointerEvents: boolean;
	closeOnBackdropClick: boolean;
	attachTo: FlexibleConnectedPositionStrategyOrigin | null | undefined;
	attachPositions: ConnectedPosition[];
	autoFocus: AutoFocusTarget | (Record<never, never> & string);
	disableClose: boolean;
	ariaDescribedBy: string | null | undefined;
	ariaLabelledBy: string | null | undefined;
	ariaLabel: string | null | undefined;
	ariaModal: boolean;
	providers?: StaticProvider[] | (() => StaticProvider[]);
};

export const DEFAULT_BRN_DIALOG_OPTIONS: Readonly<Partial<BrnDialogOptions>> = {
	role: 'dialog',
	attachPositions: [],
	attachTo: null,
	autoFocus: 'first-tabbable',
	backdropClass: '',
	closeDelay: 100,
	closeOnBackdropClick: true,
	closeOnOutsidePointerEvents: false,
	hasBackdrop: true,
	panelClass: '',
	positionStrategy: null,
	restoreFocus: true,
	scrollStrategy: null,
	disableClose: false,
	ariaLabel: undefined,
	ariaModal: true,
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-overlay.component.ts
```typescript
import { ChangeDetectionStrategy, Component, effect, inject, input, untracked, ViewEncapsulation } from '@angular/core';
import { provideCustomClassSettableExisting } from '@spartan-ng/brain/core';
import { BrnDialogComponent } from './brn-dialog.component';

@Component({
	selector: 'brn-dialog-overlay',
	standalone: true,
	template: '',
	providers: [provideCustomClassSettableExisting(() => BrnDialogOverlayComponent)],
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnDialogOverlayComponent {
	private readonly _brnDialog = inject(BrnDialogComponent);

	public readonly className = input<string | null | undefined>(undefined, { alias: 'class' });

	setClassToCustomElement(newClass: string) {
		this._brnDialog.setOverlayClass(newClass);
	}
	constructor() {
		effect(() => {
			if (!this._brnDialog) return;
			const newClass = this.className();
			untracked(() => this._brnDialog.setOverlayClass(newClass));
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-ref.ts
```typescript
import type { DialogRef } from '@angular/cdk/dialog';
import type { Signal, WritableSignal } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { take } from 'rxjs/operators';
import type { BrnDialogOptions } from './brn-dialog-options';
import type { BrnDialogState } from './brn-dialog-state';
import { cssClassesToArray } from './brn-dialog-utils';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export class BrnDialogRef<DialogResult = any> {
	private readonly _closing$ = new Subject<void>();
	public readonly closing$ = this._closing$.asObservable();

	public readonly closed$: Observable<DialogResult | undefined>;

	private _previousTimeout: ReturnType<typeof setTimeout> | undefined;

	public get open() {
		return this.state() === 'open';
	}

	constructor(
		private readonly _cdkDialogRef: DialogRef<DialogResult>,
		private readonly _open: WritableSignal<boolean>,
		public readonly state: Signal<BrnDialogState>,
		public readonly dialogId: number,
		private readonly _options?: BrnDialogOptions,
	) {
		this.closed$ = this._cdkDialogRef.closed.pipe(take(1));
	}

	public close(result?: DialogResult, delay: number = this._options?.closeDelay ?? 0) {
		if (!this.open || this._options?.disableClose) return;

		this._closing$.next();
		this._open.set(false);

		if (this._previousTimeout) {
			clearTimeout(this._previousTimeout);
		}

		this._previousTimeout = setTimeout(() => {
			this._cdkDialogRef.close(result);
		}, delay);
	}

	public setPanelClass(paneClass: string | null | undefined) {
		this._cdkDialogRef.config.panelClass = cssClassesToArray(paneClass);
	}

	public setOverlayClass(overlayClass: string | null | undefined) {
		this._cdkDialogRef.config.backdropClass = cssClassesToArray(overlayClass);
	}

	public setAriaDescribedBy(ariaDescribedBy: string | null | undefined) {
		this._cdkDialogRef.config.ariaDescribedBy = ariaDescribedBy;
	}

	public setAriaLabelledBy(ariaLabelledBy: string | null | undefined) {
		this._cdkDialogRef.config.ariaLabelledBy = ariaLabelledBy;
	}

	public setAriaLabel(ariaLabel: string | null | undefined) {
		this._cdkDialogRef.config.ariaLabel = ariaLabel;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-state.ts
```typescript
export type BrnDialogState = 'closed' | 'open';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-title.directive.ts
```typescript
import { Directive, effect, inject, signal } from '@angular/core';
import { BrnDialogRef } from './brn-dialog-ref';

@Directive({
	selector: '[brnDialogTitle]',
	standalone: true,
	host: {
		'[id]': '_id()',
	},
})
export class BrnDialogTitleDirective {
	private readonly _brnDialogRef = inject(BrnDialogRef);

	protected _id = signal(`brn-dialog-title-${this._brnDialogRef?.dialogId}`);

	constructor() {
		effect(() => {
			this._brnDialogRef.setAriaLabelledBy(this._id());
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-token.ts
```typescript
import { inject, InjectionToken, ValueProvider } from '@angular/core';
import { BrnDialogOptions } from './brn-dialog-options';

export interface BrnDialogDefaultOptions {
	/** A connected position as specified by the user. */
	attachPositions: BrnDialogOptions['attachPositions'];

	/** Options for where to set focus to automatically on dialog open */
	autoFocus: BrnDialogOptions['autoFocus'];

	/** The delay in milliseconds before the dialog closes. */
	closeDelay: number;

	/** Close dialog on backdrop click */
	closeOnBackdropClick: boolean;

	/** Close dialog on outside pointer event */
	closeOnOutsidePointerEvents: boolean;

	/** Whether the dialog closes with the escape key or pointer events outside the panel element. */
	disableClose: boolean;

	/** Whether the dialog has a backdrop. */
	hasBackdrop: boolean;

	/** Strategy to use when positioning the dialog */
	positionStrategy: BrnDialogOptions['positionStrategy'];

	/** Whether the dialog should restore focus to the previously-focused element upon closing. */
	restoreFocus: BrnDialogOptions['restoreFocus'];

	/** The role of the dialog */
	role: BrnDialogOptions['role'];

	/** Scroll strategy to be used for the dialog. */
	scrollStrategy: BrnDialogOptions['scrollStrategy'] | 'close' | 'reposition';
}

export const defaultOptions: BrnDialogDefaultOptions = {
	attachPositions: [],
	autoFocus: 'first-tabbable',
	closeDelay: 100,
	closeOnBackdropClick: true,
	closeOnOutsidePointerEvents: false,
	disableClose: false,
	hasBackdrop: true,
	positionStrategy: null,
	restoreFocus: true,
	role: 'dialog',
	scrollStrategy: null,
};

const BRN_DIALOG_DEFAULT_OPTIONS = new InjectionToken<BrnDialogDefaultOptions>('brn-dialog-default-options', {
	providedIn: 'root',
	factory: () => defaultOptions,
});

export function provideBrnDialogDefaultOptions(options: Partial<BrnDialogDefaultOptions>): ValueProvider {
	return { provide: BRN_DIALOG_DEFAULT_OPTIONS, useValue: { ...defaultOptions, ...options } };
}

export function injectBrnDialogDefaultOptions(): BrnDialogDefaultOptions {
	return inject(BRN_DIALOG_DEFAULT_OPTIONS, { optional: true }) ?? defaultOptions;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-trigger.directive.ts
```typescript
import { computed, Directive, effect, inject, input, type Signal, signal } from '@angular/core';
import { BrnDialogRef } from './brn-dialog-ref';
import type { BrnDialogState } from './brn-dialog-state';
import { BrnDialogComponent } from './brn-dialog.component';

let idSequence = 0;

@Directive({
	selector: 'button[brnDialogTrigger],button[brnDialogTriggerFor]',
	standalone: true,
	host: {
		'[id]': 'id()',
		'(click)': 'open()',
		'aria-haspopup': 'dialog',
		'[attr.aria-expanded]': "state() === 'open' ? 'true': 'false'",
		'[attr.data-state]': 'state()',
		'[attr.aria-controls]': 'dialogId',
	},
	exportAs: 'brnDialogTrigger',
})
export class BrnDialogTriggerDirective {
	protected _brnDialog = inject(BrnDialogComponent, { optional: true });
	protected readonly _brnDialogRef = inject(BrnDialogRef, { optional: true });

	public readonly id = input(`brn-dialog-trigger-${idSequence++}`);

	public readonly state: Signal<BrnDialogState> = this._brnDialogRef?.state ?? signal('closed');
	public readonly dialogId = `brn-dialog-${this._brnDialogRef?.dialogId ?? idSequence++}`;

	public readonly brnDialogTriggerFor = input<BrnDialogComponent | undefined>(undefined, {
		alias: 'brnDialogTriggerFor',
	});
	public readonly mutableBrnDialogTriggerFor = computed(() => signal(this.brnDialogTriggerFor()));
	public readonly brnDialogTriggerForState = computed(() => this.mutableBrnDialogTriggerFor()());

	constructor() {
		effect(() => {
			const brnDialog = this.brnDialogTriggerForState();
			if (!brnDialog) return;
			this._brnDialog = brnDialog;
		});
	}

	open() {
		this._brnDialog?.open();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog-utils.ts
```typescript
// brn-dialog-utils.ts

export const cssClassesToArray = (classes: string | string[] | undefined | null, defaultClass = ''): string[] => {
	if (typeof classes === 'string') {
		const splitClasses = classes.trim().split(' ');
		if (splitClasses.length === 0) {
			return [defaultClass];
		}
		return splitClasses;
	}
	return classes ?? [];
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog.component.ts
```typescript
import { OverlayPositionBuilder, ScrollStrategy, ScrollStrategyOptions } from '@angular/cdk/overlay';
import {
	booleanAttribute,
	ChangeDetectionStrategy,
	Component,
	computed,
	effect,
	type EffectRef,
	inject,
	Injector,
	input,
	numberAttribute,
	output,
	runInInjectionContext,
	signal,
	type TemplateRef,
	untracked,
	ViewContainerRef,
	ViewEncapsulation,
} from '@angular/core';
import { take } from 'rxjs/operators';
import { type BrnDialogOptions } from './brn-dialog-options';
import type { BrnDialogRef } from './brn-dialog-ref';
import type { BrnDialogState } from './brn-dialog-state';
import { injectBrnDialogDefaultOptions } from './brn-dialog-token';
import { BrnDialogService } from './brn-dialog.service';

@Component({
	selector: 'brn-dialog',
	standalone: true,
	template: `
		<ng-content />
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	exportAs: 'brnDialog',
})
export class BrnDialogComponent {
	private readonly _dialogService = inject(BrnDialogService);
	private readonly _vcr = inject(ViewContainerRef);
	public readonly positionBuilder = inject(OverlayPositionBuilder);
	public readonly ssos = inject(ScrollStrategyOptions);
	private readonly _injector = inject(Injector);

	protected readonly _defaultOptions = injectBrnDialogDefaultOptions();

	private _context = {};
	public readonly stateComputed = computed(() => this._dialogRef()?.state() ?? 'closed');

	private _contentTemplate: TemplateRef<unknown> | undefined;
	private readonly _dialogRef = signal<BrnDialogRef | undefined>(undefined);
	private _dialogStateEffectRef?: EffectRef;
	private readonly _backdropClass = signal<string | null | undefined>(null);
	private readonly _panelClass = signal<string | null | undefined>(null);

	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	public readonly closed = output<any>();

	public readonly stateChanged = output<BrnDialogState>();

	public readonly state = input<BrnDialogState | null>(null);

	public readonly role = input<BrnDialogOptions['role']>(this._defaultOptions.role);

	public readonly hasBackdrop = input(this._defaultOptions.hasBackdrop, { transform: booleanAttribute });

	public readonly positionStrategy = input<BrnDialogOptions['positionStrategy']>(this._defaultOptions.positionStrategy);
	public readonly mutablePositionStrategy = computed(() => signal(this.positionStrategy()));
	private readonly _positionStrategyState = computed(() => this.mutablePositionStrategy()());

	public readonly scrollStrategy = input<BrnDialogOptions['scrollStrategy'] | 'close' | 'reposition' | null>(
		this._defaultOptions.scrollStrategy,
	);

	protected _options = computed<Partial<BrnDialogOptions>>(() => {
		const scrollStrategyInput = this.scrollStrategy();
		let scrollStrategy: ScrollStrategy | null | undefined;

		if (scrollStrategyInput === 'close') {
			scrollStrategy = this.ssos.close();
		} else if (scrollStrategyInput === 'reposition') {
			scrollStrategy = this.ssos.reposition();
		} else {
			scrollStrategy = scrollStrategyInput;
		}

		return {
			role: this.role(),
			hasBackdrop: this.hasBackdrop(),
			positionStrategy: this._positionStrategyState(),
			scrollStrategy,
			restoreFocus: this.restoreFocus(),
			closeOnOutsidePointerEvents: this._closeOnOutsidePointerEventsState(),
			closeOnBackdropClick: this.closeOnBackdropClick(),
			attachTo: this._attachToState(),
			attachPositions: this._attachPositionsState(),
			autoFocus: this.autoFocus(),
			closeDelay: this.closeDelay(),
			disableClose: this.disableClose(),
			backdropClass: this._backdropClass() ?? '',
			panelClass: this._panelClass() ?? '',
			ariaDescribedBy: this._ariaDescribedByState(),
			ariaLabelledBy: this._ariaLabelledByState(),
			ariaLabel: this._ariaLabelState(),
			ariaModal: this._ariaModalState(),
		};
	});

	constructor() {
		effect(() => {
			const state = this.state();
			if (state === 'open') {
				untracked(() => this.open());
			}
			if (state === 'closed') {
				untracked(() => this.close());
			}
		});
	}

	public readonly restoreFocus = input<BrnDialogOptions['restoreFocus']>(this._defaultOptions.restoreFocus);

	public readonly closeOnOutsidePointerEvents = input(this._defaultOptions.closeOnOutsidePointerEvents, {
		transform: booleanAttribute,
	});
	public readonly mutableCloseOnOutsidePointerEvents = computed(() => signal(this.closeOnOutsidePointerEvents()));
	private readonly _closeOnOutsidePointerEventsState = computed(() => this.mutableCloseOnOutsidePointerEvents()());

	public readonly closeOnBackdropClick = input(this._defaultOptions.closeOnBackdropClick, {
		transform: booleanAttribute,
	});

	public readonly attachTo = input<BrnDialogOptions['attachTo']>(null);
	public readonly mutableAttachTo = computed(() => signal(this.attachTo()));
	private readonly _attachToState = computed(() => this.mutableAttachTo()());

	public readonly attachPositions = input<BrnDialogOptions['attachPositions']>(this._defaultOptions.attachPositions);
	public readonly mutableAttachPositions = computed(() => signal(this.attachPositions()));
	private readonly _attachPositionsState = computed(() => this.mutableAttachPositions()());

	public readonly autoFocus = input<BrnDialogOptions['autoFocus']>(this._defaultOptions.autoFocus);

	public readonly closeDelay = input(this._defaultOptions.closeDelay, {
		transform: numberAttribute,
	});

	public readonly disableClose = input(this._defaultOptions.disableClose, { transform: booleanAttribute });

	public readonly ariaDescribedBy = input<BrnDialogOptions['ariaDescribedBy']>(null, {
		alias: 'aria-describedby',
	});
	private readonly _mutableAriaDescribedBy = computed(() => signal(this.ariaDescribedBy()));
	private readonly _ariaDescribedByState = computed(() => this._mutableAriaDescribedBy()());

	public readonly ariaLabelledBy = input<BrnDialogOptions['ariaLabelledBy']>(null, { alias: 'aria-labelledby' });
	private readonly _mutableAriaLabelledBy = computed(() => signal(this.ariaLabelledBy()));
	private readonly _ariaLabelledByState = computed(() => this._mutableAriaLabelledBy()());

	public readonly ariaLabel = input<BrnDialogOptions['ariaLabel']>(null, { alias: 'aria-label' });
	private readonly _mutableAriaLabel = computed(() => signal(this.ariaLabel()));
	private readonly _ariaLabelState = computed(() => this._mutableAriaLabel()());

	public readonly ariaModal = input(true, { alias: 'aria-modal', transform: booleanAttribute });
	private readonly _mutableAriaModal = computed(() => signal(this.ariaModal()));
	private readonly _ariaModalState = computed(() => this._mutableAriaModal()());

	public open<DialogContext>() {
		if (!this._contentTemplate || this._dialogRef()) return;

		this._dialogStateEffectRef?.destroy();

		const dialogRef = this._dialogService.open<DialogContext>(
			this._contentTemplate,
			this._vcr,
			this._context as DialogContext,
			this._options(),
		);

		this._dialogRef.set(dialogRef);

		runInInjectionContext(this._injector, () => {
			this._dialogStateEffectRef = effect(() => {
				const state = dialogRef.state();
				untracked(() => this.stateChanged.emit(state));
			});
		});

		dialogRef.closed$.pipe(take(1)).subscribe((result) => {
			this._dialogRef.set(undefined);
			this.closed.emit(result);
		});
	}

	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	public close(result?: any, delay?: number) {
		this._dialogRef()?.close(result, delay ?? this._options().closeDelay);
	}

	public registerTemplate(template: TemplateRef<unknown>) {
		this._contentTemplate = template;
	}

	public setOverlayClass(overlayClass: string | null | undefined) {
		this._backdropClass.set(overlayClass);
		this._dialogRef()?.setOverlayClass(overlayClass);
	}

	public setPanelClass(panelClass: string | null | undefined) {
		this._panelClass.set(panelClass ?? '');
		this._dialogRef()?.setPanelClass(panelClass);
	}

	public setContext(context: unknown) {
		// eslint-disable-next-line @typescript-eslint/ban-ts-comment
		// @ts-expect-error
		this._context = { ...this._context, ...context };
	}

	public setAriaDescribedBy(ariaDescribedBy: string | null | undefined) {
		this._mutableAriaDescribedBy().set(ariaDescribedBy);
		this._dialogRef()?.setAriaDescribedBy(ariaDescribedBy);
	}

	public setAriaLabelledBy(ariaLabelledBy: string | null | undefined) {
		this._mutableAriaLabelledBy().set(ariaLabelledBy);
		this._dialogRef()?.setAriaLabelledBy(ariaLabelledBy);
	}

	public setAriaLabel(ariaLabel: string | null | undefined) {
		this._mutableAriaLabel().set(ariaLabel);
		this._dialogRef()?.setAriaLabel(ariaLabel);
	}

	public setAriaModal(ariaModal: boolean) {
		this._mutableAriaModal().set(ariaModal);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/dialog/src/lib/brn-dialog.service.ts
```typescript
import { DIALOG_DATA, Dialog } from '@angular/cdk/dialog';
import { type ComponentType, OverlayPositionBuilder, ScrollStrategyOptions } from '@angular/cdk/overlay';
import {
	type EffectRef,
	type InjectOptions,
	Injectable,
	Injector,
	RendererFactory2,
	type StaticProvider,
	type TemplateRef,
	type ViewContainerRef,
	computed,
	effect,
	inject,
	runInInjectionContext,
	signal,
} from '@angular/core';
import { Subject } from 'rxjs';
import { filter, takeUntil } from 'rxjs/operators';
import type { BrnDialogOptions } from './brn-dialog-options';
import { BrnDialogRef } from './brn-dialog-ref';
import type { BrnDialogState } from './brn-dialog-state';
import { cssClassesToArray } from './brn-dialog-utils';

let dialogSequence = 0;

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type BrnDialogContext<T> = T & { close: (result?: any) => void };

/** @deprecated `injectBrnDialogCtx` will no longer be supported once components are stable. Use `injectBrnDialogContext` instead.  */
export const injectBrnDialogCtx = <T>(): BrnDialogContext<T> => {
	return inject(DIALOG_DATA);
};

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const injectBrnDialogContext = <DialogContext = any>(options: InjectOptions = {}) => {
	return inject(DIALOG_DATA, options) as DialogContext;
};

@Injectable({ providedIn: 'root' })
export class BrnDialogService {
	private readonly _cdkDialog = inject(Dialog);
	private readonly _rendererFactory = inject(RendererFactory2);
	private readonly _renderer = this._rendererFactory.createRenderer(null, null);
	private readonly _positionBuilder = inject(OverlayPositionBuilder);
	private readonly _sso = inject(ScrollStrategyOptions);
	private readonly _injector = inject(Injector);

	public open<DialogContext>(
		content: ComponentType<unknown> | TemplateRef<unknown>,
		vcr?: ViewContainerRef,
		context?: DialogContext,
		options?: Partial<BrnDialogOptions>,
	) {
		if (options?.id && this._cdkDialog.getDialogById(options.id)) {
			throw new Error(`Dialog with ID: ${options.id} already exists`);
		}

		const positionStrategy =
			options?.positionStrategy ??
			(options?.attachTo && options?.attachPositions && options?.attachPositions?.length > 0
				? this._positionBuilder?.flexibleConnectedTo(options.attachTo).withPositions(options.attachPositions ?? [])
				: this._positionBuilder.global().centerHorizontally().centerVertically());

		let brnDialogRef!: BrnDialogRef;
		let effectRef!: EffectRef;

		// eslint-disable-next-line @typescript-eslint/no-explicit-any
		const contextOrData: BrnDialogContext<any> = {
			...context,
			// eslint-disable-next-line @typescript-eslint/no-explicit-any
			close: (result: any = undefined) => brnDialogRef.close(result, options?.closeDelay),
		};

		const destroyed$ = new Subject<void>();
		const open = signal<boolean>(true);
		const state = computed<BrnDialogState>(() => (open() ? 'open' : 'closed'));
		const dialogId = dialogSequence++;

		// eslint-disable-next-line @typescript-eslint/ban-ts-comment
		// @ts-ignore
		const cdkDialogRef = this._cdkDialog.open(content, {
			id: options?.id ?? `brn-dialog-${dialogId}`,
			role: options?.role,
			viewContainerRef: vcr,
			templateContext: () => ({
				$implicit: contextOrData,
			}),
			data: contextOrData,
			hasBackdrop: options?.hasBackdrop,
			panelClass: cssClassesToArray(options?.panelClass),
			backdropClass: cssClassesToArray(options?.backdropClass, 'bg-transparent'),
			positionStrategy,
			scrollStrategy: options?.scrollStrategy ?? this._sso?.block(),
			restoreFocus: options?.restoreFocus,
			disableClose: true,
			autoFocus: options?.autoFocus ?? 'first-tabbable',
			ariaDescribedBy: options?.ariaDescribedBy ?? `brn-dialog-description-${dialogId}`,
			ariaLabelledBy: options?.ariaLabelledBy ?? `brn-dialog-title-${dialogId}`,
			ariaLabel: options?.ariaLabel,
			ariaModal: options?.ariaModal,
			providers: (cdkDialogRef) => {
				brnDialogRef = new BrnDialogRef(cdkDialogRef, open, state, dialogId, options as BrnDialogOptions);

				runInInjectionContext(this._injector, () => {
					effectRef = effect(() => {
						if (overlay) {
							this._renderer.setAttribute(overlay, 'data-state', state());
						}
						if (backdrop) {
							this._renderer.setAttribute(backdrop, 'data-state', state());
						}
					});
				});

				const providers: StaticProvider[] = [
					{
						provide: BrnDialogRef,
						useValue: brnDialogRef,
					},
				];

				if (options?.providers) {
					if (typeof options.providers === 'function') {
						providers.push(...options.providers());
					}

					if (Array.isArray(options.providers)) {
						providers.push(...options.providers);
					}
				}

				return providers;
			},
		});

		const overlay = cdkDialogRef.overlayRef.overlayElement;
		const backdrop = cdkDialogRef.overlayRef.backdropElement;

		if (options?.closeOnOutsidePointerEvents) {
			cdkDialogRef.outsidePointerEvents.pipe(takeUntil(destroyed$)).subscribe(() => {
				brnDialogRef.close(undefined, options?.closeDelay);
			});
		}

		if (options?.closeOnBackdropClick) {
			cdkDialogRef.backdropClick.pipe(takeUntil(destroyed$)).subscribe(() => {
				brnDialogRef.close(undefined, options?.closeDelay);
			});
		}

		if (!options?.disableClose) {
			cdkDialogRef.keydownEvents
				.pipe(
					filter((e) => e.key === 'Escape'),
					takeUntil(destroyed$),
				)
				.subscribe(() => {
					brnDialogRef.close(undefined, options?.closeDelay);
				});
		}

		cdkDialogRef.closed.pipe(takeUntil(destroyed$)).subscribe(() => {
			effectRef?.destroy();
			destroyed$.next();
		});

		return brnDialogRef;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/form-field/README.md
```
# @spartan-ng/brain/form-field

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/form-field`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/form-field/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/form-field/src/index.ts
```typescript
export * from './lib/brn-form-field-control';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/form-field/src/lib/brn-form-field-control.ts
```typescript
import { Directive, type Signal, signal } from '@angular/core';
import type { AbstractControlDirective, NgControl } from '@angular/forms';

@Directive()
export class BrnFormFieldControl {
	/** Gets the AbstractControlDirective for this control. */
	public readonly ngControl: NgControl | AbstractControlDirective | null = null;

	/** Whether the control is in an error state. */
	public readonly errorState: Signal<boolean> = signal(false);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/popover/README.md
```
# @spartan-ng/brain/popover

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/popover`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/popover/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/popover/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnPopoverCloseDirective } from './lib/brn-popover-close.directive';
import { BrnPopoverContentDirective } from './lib/brn-popover-content.directive';
import { BrnPopoverTriggerDirective } from './lib/brn-popover-trigger.directive';
import { BrnPopoverComponent } from './lib/brn-popover.component';

export * from './lib/brn-popover-close.directive';
export * from './lib/brn-popover-content.directive';
export * from './lib/brn-popover-trigger.directive';
export * from './lib/brn-popover.component';

export const BrnPopoverImports = [
	BrnPopoverComponent,
	BrnPopoverTriggerDirective,
	BrnPopoverCloseDirective,
	BrnPopoverContentDirective,
] as const;

@NgModule({
	imports: [...BrnPopoverImports],
	exports: [...BrnPopoverImports],
})
export class BrnPopoverModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/popover/src/lib/brn-popover-close.directive.ts
```typescript
import { Directive } from '@angular/core';
import { BrnDialogCloseDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: 'button[brnPopoverClose]',
	standalone: true,
})
export class BrnPopoverCloseDirective extends BrnDialogCloseDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/popover/src/lib/brn-popover-content.directive.ts
```typescript
import { Directive } from '@angular/core';
import { provideExposesStateProviderExisting } from '@spartan-ng/brain/core';
import { BrnDialogContentDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: '[brnPopoverContent]',
	standalone: true,
	providers: [provideExposesStateProviderExisting(() => BrnPopoverContentDirective)],
})
export class BrnPopoverContentDirective<T> extends BrnDialogContentDirective<T> {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/popover/src/lib/brn-popover-trigger.directive.ts
```typescript
import { Directive, ElementRef, effect, inject, input, untracked } from '@angular/core';
import { BrnDialogTriggerDirective } from '@spartan-ng/brain/dialog';
import type { BrnPopoverComponent } from './brn-popover.component';

@Directive({
	selector: 'button[brnPopoverTrigger],button[brnPopoverTriggerFor]',
	standalone: true,
	host: {
		'[id]': 'id()',
		'aria-haspopup': 'dialog',
		'[attr.aria-expanded]': "state() === 'open' ? 'true': 'false'",
		'[attr.data-state]': 'state()',
		'[attr.aria-controls]': 'dialogId',
	},
})
export class BrnPopoverTriggerDirective extends BrnDialogTriggerDirective {
	private readonly _host = inject(ElementRef, { host: true });

	public readonly brnPopoverTriggerFor = input<BrnPopoverComponent | undefined>(undefined, {
		alias: 'brnPopoverTriggerFor',
	});

	constructor() {
		super();
		if (!this._brnDialog) return;
		this._brnDialog.mutableAttachTo().set(this._host.nativeElement);
		this._brnDialog.mutableCloseOnOutsidePointerEvents().set(true);

		effect(() => {
			const brnDialog = this.brnPopoverTriggerFor();
			untracked(() => {
				if (!brnDialog) return;
				brnDialog.mutableAttachTo().set(this._host.nativeElement);
				brnDialog.mutableCloseOnOutsidePointerEvents().set(true);
				this.mutableBrnDialogTriggerFor().set(brnDialog);
			});
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/popover/src/lib/brn-popover.component.ts
```typescript
import {
	ChangeDetectionStrategy,
	Component,
	effect,
	forwardRef,
	input,
	numberAttribute,
	untracked,
	ViewEncapsulation,
} from '@angular/core';
import { BrnDialogComponent, BrnDialogDefaultOptions, provideBrnDialogDefaultOptions } from '@spartan-ng/brain/dialog';

export const BRN_POPOVER_DIALOG_DEFAULT_OPTIONS: Partial<BrnDialogDefaultOptions> = {
	hasBackdrop: false,
	scrollStrategy: 'reposition',
};

export type BrnPopoverAlign = 'start' | 'center' | 'end';

@Component({
	selector: 'brn-popover',
	standalone: true,
	template: `
		<ng-content />
	`,
	providers: [
		{
			provide: BrnDialogComponent,
			useExisting: forwardRef(() => BrnPopoverComponent),
		},
		provideBrnDialogDefaultOptions(BRN_POPOVER_DIALOG_DEFAULT_OPTIONS),
	],
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	exportAs: 'brnPopover',
})
export class BrnPopoverComponent extends BrnDialogComponent {
	public readonly align = input<BrnPopoverAlign>('center');
	public readonly sideOffset = input(0, { transform: numberAttribute });

	constructor() {
		super();
		this.setAriaDescribedBy('');
		this.setAriaLabelledBy('');

		effect(() => {
			const align = this.align();
			untracked(() => {
				this.mutableAttachPositions().set([
					{
						originX: align,
						originY: 'bottom',
						overlayX: align,
						overlayY: 'top',
					},
					{
						originX: align,
						originY: 'top',
						overlayX: align,
						overlayY: 'bottom',
					},
				]);
			});
			untracked(() => {
				this.applySideOffset(this.sideOffset());
			});
		});
		effect(() => {
			const sideOffset = this.sideOffset();
			untracked(() => {
				this.applySideOffset(sideOffset);
			});
		});
	}

	private applySideOffset(sideOffset: number) {
		this.mutableAttachPositions().update((positions) =>
			positions.map((position) => ({
				...position,
				offsetY: position.originY === 'top' ? -sideOffset : sideOffset,
			})),
		);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/README.md
```
# @spartan-ng/brain/table

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/table`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { BrnCellDefDirective } from './lib/brn-cell-def.directive';
import { BrnColumnDefComponent } from './lib/brn-column-def.component';
import { BrnFooterDefDirective } from './lib/brn-footer-def.directive';
import { BrnHeaderDefDirective } from './lib/brn-header-def.directive';
import { BrnPaginatorDirective } from './lib/brn-paginator.directive';
import { BrnTableComponent } from './lib/brn-table.component';

export { BrnCellDefDirective } from './lib/brn-cell-def.directive';
export { BrnColumnDefComponent } from './lib/brn-column-def.component';
export { BrnColumnManager, useBrnColumnManager } from './lib/brn-column-manager';
export { BrnFooterDefDirective } from './lib/brn-footer-def.directive';
export { BrnHeaderDefDirective } from './lib/brn-header-def.directive';
export { BrnPaginatorDirective, PaginatorContext, PaginatorState } from './lib/brn-paginator.directive';
export { BrnTableComponent } from './lib/brn-table.component';

export const BrnTableImports = [
	BrnCellDefDirective,
	BrnColumnDefComponent,
	BrnFooterDefDirective,
	BrnHeaderDefDirective,
	BrnTableComponent,
	BrnPaginatorDirective,
] as const;

@NgModule({
	imports: [...BrnTableImports],
	exports: [...BrnTableImports],
})
export class BrnTableModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-cell-def.directive.ts
```typescript
import { CdkCellDef } from '@angular/cdk/table';
import { Directive, TemplateRef, inject } from '@angular/core';

@Directive({
	standalone: true,
	selector: '[brnCellDef]',
	exportAs: 'brnCellDef',
})
export class BrnCellDefDirective extends CdkCellDef {
	public override template: TemplateRef<unknown>;

	constructor() {
		const template = inject<TemplateRef<unknown>>(TemplateRef);

		super(template);
		this.template = template;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-column-def.component.ts
```typescript
import {
	type CdkCellDef,
	CdkColumnDef,
	type CdkFooterCellDef,
	type CdkHeaderCellDef,
	CdkTableModule,
} from '@angular/cdk/table';
import {
	type AfterContentChecked,
	ChangeDetectionStrategy,
	Component,
	ContentChild,
	Input,
	ViewChild,
	ViewEncapsulation,
	input,
} from '@angular/core';
import { BrnCellDefDirective } from './brn-cell-def.directive';
import { BrnFooterDefDirective } from './brn-footer-def.directive';
import { BrnHeaderDefDirective } from './brn-header-def.directive';

@Component({
	selector: 'brn-column-def',
	imports: [CdkTableModule],
	template: `
		<ng-container [cdkColumnDef]="name">
			<ng-content select="[brnHeaderDef]" />
			<ng-content select="[brnCellDef]" />
			<ng-content select="[brnFooterDef]" />
		</ng-container>
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnColumnDefComponent implements AfterContentChecked {
	public get columnDef() {
		return this._columnDef;
	}

	public get cell() {
		return this._columnDef.cell;
	}

	private _name = '';
	@Input()
	public get name(): string {
		return this._name;
	}

	public set name(value: string) {
		this._name = value;
		if (!this._columnDef) return;
		this._columnDef.name = value;
	}

	public readonly class = input('');

	@ViewChild(CdkColumnDef, { static: true })
	private readonly _columnDef!: CdkColumnDef;

	@ContentChild(BrnCellDefDirective, { static: true })
	private readonly _cellDef?: CdkCellDef;
	@ContentChild(BrnFooterDefDirective, { static: true })
	private readonly _footerCellDef?: CdkFooterCellDef;
	@ContentChild(BrnHeaderDefDirective, { static: true })
	private readonly _headerCellDef?: CdkHeaderCellDef;

	public ngAfterContentChecked(): void {
		this._columnDef.name = this.name;
		if (this._cellDef) {
			this._columnDef.cell = this._cellDef;
		}
		if (this._headerCellDef) {
			this._columnDef.headerCell = this._headerCellDef;
		}
		if (this._footerCellDef) {
			this._columnDef.footerCell = this._footerCellDef;
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-column-manager.spec.ts
```typescript
import { useBrnColumnManager } from './brn-column-manager';

describe('BrnColumnManager', () => {
	it('should initialize with a Record of column names to booleans', () => {
		const columnManager = useBrnColumnManager({
			name: true,
			age: false,
		});

		expect(columnManager.allColumns).toEqual(['name', 'age']);
		expect(columnManager.displayedColumns()).toEqual(['name']);
		expect(columnManager.isColumnVisible('name')).toBe(true);
		expect(columnManager.isColumnVisible('age')).toBe(false);
	});

	it('should initialize with a Record of column names to objects', () => {
		const columnManager = useBrnColumnManager({
			name: { visible: true },
			age: { visible: false },
		});

		expect(columnManager.allColumns).toEqual([
			{ name: 'name', visible: true },
			{ name: 'age', visible: false },
		]);
		expect(columnManager.displayedColumns()).toEqual(['name']);
		expect(columnManager.isColumnVisible('name')).toBe(true);
		expect(columnManager.isColumnVisible('age')).toBe(false);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-column-manager.ts
```typescript
import { type Signal, computed, signal } from '@angular/core';

type BrnColumnVisibility = Record<string, boolean> | Record<string, { visible: boolean }>;

// prettier-ignore
type AllColumnsPropertyType<T> = T extends Record<string, boolean>
	? (keyof T)[]
	: T extends Record<string, infer R>
		? (R extends { visible: boolean } ? { name: keyof T } & R : never)[]
		: never;

export class BrnColumnManager<T extends BrnColumnVisibility> {
	private readonly _initialColumnVisibility: T;
	private readonly _columnVisibility;

	public readonly allColumns: AllColumnsPropertyType<T>;
	public readonly columnVisibility;
	public readonly displayedColumns: Signal<(keyof T)[]> = computed(() => {
		return Object.entries(this._columnVisibility())
			.filter(([, value]) => (typeof value === 'boolean' ? value : value.visible))
			.map(([key]) => key);
	});

	constructor(initialColumnVisibility: T) {
		this._initialColumnVisibility = initialColumnVisibility;
		this._columnVisibility = signal(this._initialColumnVisibility);
		this._columnVisibility.set(this._initialColumnVisibility);
		this.columnVisibility = this._columnVisibility.asReadonly();
		this.allColumns = this.createAllColumns(this._initialColumnVisibility);
	}

	public readonly isColumnVisible = (columnName: string) => {
		const visibilityMap = this.columnVisibility();
		const columnEntry = visibilityMap[columnName];
		return typeof columnEntry === 'boolean' ? columnEntry : columnEntry.visible;
	};
	public readonly isColumnDisabled = (columnName: string) =>
		this.isColumnVisible(columnName) && this.displayedColumns().length === 1;

	public toggleVisibility(columnName: keyof T) {
		const visibilityMap = this._columnVisibility();
		const columnEntry = visibilityMap[columnName];
		const newVisibilityState = typeof columnEntry === 'boolean' ? !columnEntry : { visible: !columnEntry.visible };
		this._columnVisibility.set({ ...visibilityMap, [columnName]: newVisibilityState });
	}
	public setVisible(columnName: keyof T) {
		const visibilityMap = this._columnVisibility();
		const columnEntry = visibilityMap[columnName];
		const newVisibilityState = typeof columnEntry === 'boolean' ? true : { visible: true };
		this._columnVisibility.set({ ...visibilityMap, [columnName]: newVisibilityState });
	}
	public setInvisible(columnName: keyof T) {
		const visibilityMap = this._columnVisibility();
		const columnEntry = visibilityMap[columnName];
		const newVisibilityState = typeof columnEntry === 'boolean' ? false : { visible: false };
		this._columnVisibility.set({ ...visibilityMap, [columnName]: newVisibilityState });
	}

	private createAllColumns(initialColumnVisibility: T): AllColumnsPropertyType<T> {
		const keys = Object.keys(initialColumnVisibility) as (keyof T)[];
		if (this.isBooleanConfig(initialColumnVisibility)) {
			return keys as unknown as AllColumnsPropertyType<T>;
		}
		return keys.map((key) => {
			const values = initialColumnVisibility[key] as { visible: boolean };
			return {
				name: key,
				...values,
			};
		}) as AllColumnsPropertyType<T>;
	}

	private isBooleanConfig(config: any): config is Record<string, boolean> {
		return typeof Object.values(config)[0] === 'boolean';
	}
}

export const useBrnColumnManager = <T extends BrnColumnVisibility>(initialColumnVisibility: T) =>
	new BrnColumnManager(initialColumnVisibility);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-footer-def.directive.ts
```typescript
import { CdkFooterCellDef } from '@angular/cdk/table';
import { Directive, TemplateRef, inject } from '@angular/core';

@Directive({
	standalone: true,
	selector: '[brnFooterDef]',
	exportAs: 'brnFooterDef',
})
export class BrnFooterDefDirective extends CdkFooterCellDef {
	public override template: TemplateRef<unknown>;

	constructor() {
		const template = inject<TemplateRef<unknown>>(TemplateRef);

		super(template);
		this.template = template;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-header-def.directive.ts
```typescript
import { CdkHeaderCellDef } from '@angular/cdk/table';
import { Directive, TemplateRef, inject } from '@angular/core';

@Directive({
	standalone: true,
	selector: '[brnHeaderDef]',
	exportAs: 'brnHeaderDef',
})
export class BrnHeaderDefDirective extends CdkHeaderCellDef {
	public override template: TemplateRef<unknown>;

	constructor() {
		const template = inject<TemplateRef<unknown>>(TemplateRef);

		super(template);
		this.template = template;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-paginator.directive.ts
```typescript
import {
	Directive,
	Input,
	type OnInit,
	type Signal,
	TemplateRef,
	ViewContainerRef,
	computed,
	effect,
	inject,
	numberAttribute,
	signal,
	untracked,
} from '@angular/core';

export type PaginatorState = {
	currentPage: number;
	startIndex: number;
	endIndex: number;
	pageSize: number;
	totalPages: number;
	totalElements: number | null | undefined;
};

export type PaginatorContext = {
	$implicit: {
		state: Signal<PaginatorState>;
		incrementable: Signal<boolean>;
		decrementable: Signal<boolean>;
		increment: () => void;
		decrement: () => void;
	};
};

@Directive({
	standalone: true,
	selector: '[brnPaginator]',
	exportAs: 'brnPaginator',
})
export class BrnPaginatorDirective implements OnInit {
	static ngTemplateContextGuard(_directive: BrnPaginatorDirective, _context: unknown): _context is PaginatorContext {
		return true;
	}

	private readonly _vcr = inject(ViewContainerRef);
	private readonly _template = inject(TemplateRef<unknown>);

	private readonly _state = signal<PaginatorState>({
		currentPage: 0,
		startIndex: 0,
		endIndex: 0,
		pageSize: 10,
		totalPages: 0,
		totalElements: null,
	});
	private readonly _decrementable = computed(() => 0 < this._state().startIndex);
	private readonly _incrementable = computed(() => this._state().endIndex < (this._state().totalElements ?? 0) - 1);

	@Input({ alias: 'brnPaginatorTotalElements' })
	public set totalElements(value: number | null | undefined) {
		this.calculateNewState({ newTotalElements: value, newPage: 0 });
	}

	@Input({ alias: 'brnPaginatorCurrentPage', transform: numberAttribute })
	public set currentPage(value: number) {
		this.calculateNewState({ newPage: value });
	}

	@Input({ alias: 'brnPaginatorPageSize', transform: numberAttribute })
	public set pageSize(value: number) {
		this.calculateNewState({ newPageSize: value, newPage: 0 });
	}

	@Input({ alias: 'brnPaginatorOnStateChange' })
	public onStateChange?: (state: PaginatorState) => void;

	constructor() {
		effect(() => {
			const state = this._state();
			untracked(() => {
				Promise.resolve().then(() => {
					if (this.onStateChange) {
						this.onStateChange(state);
					}
				});
			});
		});
	}

	public ngOnInit() {
		this._vcr.createEmbeddedView<PaginatorContext>(this._template, {
			$implicit: {
				state: this._state,
				increment: () => this.incrementPage(),
				decrement: () => this.decrementPage(),
				incrementable: this._incrementable,
				decrementable: this._decrementable,
			},
		});
	}

	public decrementPage(): void {
		const { currentPage } = this._state();
		if (0 < currentPage) {
			this.calculateNewState({ newPage: currentPage - 1 });
		}
	}

	public incrementPage(): void {
		const { currentPage, totalPages } = this._state();
		if (totalPages > currentPage) {
			this.calculateNewState({ newPage: currentPage + 1 });
		}
	}

	public reset(): void {
		this.currentPage = 0;
	}

	private calculateNewState({
		newPage,
		newPageSize,
		newTotalElements,
	}: Partial<{
		newPage: number;
		newPageSize: number;
		newTotalElements: number | null | undefined;
	}>) {
		const previousState = this._state();

		let currentPage = newPage ?? previousState.currentPage;
		const pageSize = newPageSize ?? previousState.pageSize;
		const totalElements = newTotalElements ?? previousState.totalElements ?? 0;

		const newTotalPages = totalElements ? Math.floor(totalElements / pageSize) : 0;

		if (newTotalPages < currentPage - 1) {
			currentPage = newTotalPages - 1;
		}

		const newStartIndex = totalElements === 0 ? 0 : Math.min(totalElements - 1, currentPage * pageSize);
		const newEndIndex = Math.min((currentPage + 1) * pageSize - 1, totalElements - 1);

		const newState = {
			currentPage: currentPage,
			startIndex: newStartIndex,
			endIndex: newEndIndex,
			pageSize: pageSize,
			totalPages: newTotalPages,
			totalElements: totalElements,
		};

		this._state.set(newState);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-table.component.ts
```typescript
import { CdkRowDef, CdkTable, type CdkTableDataSourceInput, CdkTableModule } from '@angular/cdk/table';
import {
	type AfterContentInit,
	ChangeDetectionStrategy,
	Component,
	ContentChildren,
	EventEmitter,
	Input,
	Output,
	type QueryList,
	type TrackByFunction,
	ViewChild,
	ViewEncapsulation,
	booleanAttribute,
} from '@angular/core';
import { type TableClassesSettable, provideTableClassesSettableExisting } from '@spartan-ng/brain/core';
import { BrnColumnDefComponent } from './brn-column-def.component';

export type BrnTableDataSourceInput<T> = CdkTableDataSourceInput<T>;

@Component({
	selector: 'brn-table',
	imports: [CdkTableModule],
	providers: [provideTableClassesSettableExisting(<T>() => BrnTableComponent<T>)],
	template: `
		<cdk-table
			#cdkTable
			[class]="tableClasses"
			[dataSource]="dataSource"
			[fixedLayout]="fixedLayout"
			[multiTemplateDataRows]="multiTemplateDataRows"
			(contentChanged)="contentChanged.emit()"
		>
			<ng-content />

			<cdk-header-row [class]="headerRowClasses" *cdkHeaderRowDef="displayedColumns; sticky: stickyHeader" />
			@if (!customTemplateDataRows) {
				<cdk-row
					[tabindex]="!!onRowClick ? 0 : -1"
					[attr.role]="!!onRowClick ? 'button' : 'row'"
					[class.row-interactive]="!!onRowClick"
					(keydown.enter)="!!onRowClick && onRowClick(row)"
					(click)="!!onRowClick && onRowClick(row)"
					[class]="bodyRowClasses"
					*cdkRowDef="let row; columns: displayedColumns"
				/>
			}

			<ng-template cdkNoDataRow>
				<ng-content select="[brnNoDataRow]" />
			</ng-template>
		</cdk-table>
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnTableComponent<T> implements TableClassesSettable, AfterContentInit {
	@ViewChild('cdkTable', { read: CdkTable, static: true })
	private readonly _cdkTable?: CdkTable<T>;
	// Cdk Table Inputs / Outputs
	@Input()
	public dataSource: BrnTableDataSourceInput<T> = [];
	@Input({ transform: booleanAttribute })
	public fixedLayout = false;
	@Input({ transform: booleanAttribute })
	public multiTemplateDataRows = false;
	@Input()
	public displayedColumns: string[] = [];

	private _trackBy?: TrackByFunction<T>;
	public get trackBy(): TrackByFunction<T> | undefined {
		return this._trackBy;
	}

	@Input()
	public set trackBy(value: TrackByFunction<T>) {
		this._trackBy = value;
		if (this._cdkTable) {
			this._cdkTable.trackBy = this._trackBy;
		}
	}

	@Output()
	public readonly contentChanged: EventEmitter<void> = new EventEmitter<void>();

	// Brn Inputs / Outputs
	@Input({ transform: booleanAttribute })
	public customTemplateDataRows = false;
	@Input()
	public onRowClick: ((element: T) => void) | undefined;

	@Input({ transform: booleanAttribute })
	public stickyHeader = false;
	@Input()
	public tableClasses = '';
	@Input()
	public headerRowClasses = '';
	@Input()
	public bodyRowClasses = '';

	@ContentChildren(BrnColumnDefComponent) public columnDefComponents!: QueryList<BrnColumnDefComponent>;
	@ContentChildren(CdkRowDef) public rowDefs!: QueryList<CdkRowDef<T>>;

	// after the <ng-content> has been initialized, the column definitions are available.
	// All that's left is to add them to the table ourselves:
	public ngAfterContentInit(): void {
		this.columnDefComponents.forEach((component) => {
			if (!this._cdkTable) return;
			if (component.cell) {
				this._cdkTable.addColumnDef(component.columnDef);
			}
		});
		this.rowDefs.forEach((rowDef) => {
			if (!this._cdkTable) return;
			this._cdkTable.addRowDef(rowDef);
		});
	}

	public setTableClasses({
		table,
		headerRow,
		bodyRow,
	}: Partial<{ table: string; headerRow: string; bodyRow: string }>): void {
		if (table) {
			this.tableClasses = table;
		}
		if (headerRow) {
			this.headerRowClasses = headerRow;
		}
		if (bodyRow) {
			this.bodyRowClasses = bodyRow;
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/collapsible/README.md
```
# @spartan-ng/brain/collapsible

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/collapsible`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/collapsible/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/collapsible/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnCollapsibleContentComponent } from './lib/brn-collapsible-content.component';
import { BrnCollapsibleTriggerDirective } from './lib/brn-collapsible-trigger.directive';
import { BrnCollapsibleComponent } from './lib/brn-collapsible.component';

export * from './lib/brn-collapsible-content.component';
export * from './lib/brn-collapsible-trigger.directive';
export * from './lib/brn-collapsible.component';

export const BrnCollapsibleImports = [
	BrnCollapsibleComponent,
	BrnCollapsibleTriggerDirective,
	BrnCollapsibleContentComponent,
] as const;

@NgModule({
	imports: [...BrnCollapsibleImports],
	exports: [...BrnCollapsibleImports],
})
export class BrnCollapsibleModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/collapsible/src/lib/brn-collapsible-content.component.ts
```typescript
import { isPlatformServer } from '@angular/common';
import { Component, ElementRef, OnInit, PLATFORM_ID, effect, inject, input, signal, untracked } from '@angular/core';
import { BrnCollapsibleComponent } from './brn-collapsible.component';

@Component({
	selector: 'brn-collapsible-content',
	standalone: true,
	host: {
		'[hidden]': '!collapsible?.expanded()',
		'[attr.data-state]': 'collapsible?.expanded() ? "open" : "closed"',
		'[id]': 'collapsible?.contentId()',
		'[style.--brn-collapsible-content-width.px]': 'width()',
		'[style.--brn-collapsible-content-height.px]': 'height()',
	},
	template: `
		<ng-content />
	`,
})
export class BrnCollapsibleContentComponent implements OnInit {
	protected readonly collapsible = inject(BrnCollapsibleComponent, { optional: true });
	private readonly _elementRef = inject<ElementRef<HTMLElement>>(ElementRef);
	private readonly _platformId = inject(PLATFORM_ID);
	/**
	 * The id of the collapsible content element.
	 */
	public readonly id = input<string | null | undefined>();
	protected readonly width = signal<number | null>(null);
	protected readonly height = signal<number | null>(null);

	constructor() {
		if (!this.collapsible) {
			throw Error('Collapsible trigger directive can only be used inside a brn-collapsible element.');
		}

		effect(() => {
			const id = this.id();
			const collapsible = this.collapsible;
			if (!id || !collapsible) return;
			untracked(() => collapsible.contentId.set(id));
		});
	}

	ngOnInit(): void {
		if (isPlatformServer(this._platformId)) {
			return;
		}

		// ensure the element is not hidden when measuring its size
		this._elementRef.nativeElement.hidden = false;

		const { width, height } = this._elementRef.nativeElement.getBoundingClientRect();
		this.width.set(width);
		this.height.set(height);

		// we force the element to be hidden again if collapsed after measuring its size
		// this is handled by the host binding, but it can cause a flicker if we don't do this here manually
		this._elementRef.nativeElement.hidden = this.collapsible?.expanded() ?? false;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/collapsible/src/lib/brn-collapsible-trigger.directive.ts
```typescript
import { Directive, inject } from '@angular/core';
import { BrnCollapsibleComponent } from './brn-collapsible.component';

@Directive({
	selector: 'button[brnCollapsibleTrigger]',
	standalone: true,
	host: {
		'[attr.data-state]': 'collapsible?.expanded() ? "open" : "closed"',
		'[attr.disabled]': 'collapsible?.disabled() ? true : undefined',
		'[attr.aria-expanded]': 'collapsible?.expanded()',
		'[attr.aria-controls]': 'collapsible?.contentId()',
		'(click)': 'toggle()',
	},
})
export class BrnCollapsibleTriggerDirective {
	protected readonly collapsible = inject(BrnCollapsibleComponent, { optional: true });

	constructor() {
		if (!this.collapsible) {
			throw Error('Collapsible trigger directive can only be used inside a brn-collapsible element.');
		}
	}

	toggle(): void {
		this.collapsible?.toggle();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/collapsible/src/lib/brn-collapsible.component.spec.ts
```typescript
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import { axe } from 'jest-axe';
import { BrnCollapsibleContentComponent } from './brn-collapsible-content.component';
import { BrnCollapsibleTriggerDirective } from './brn-collapsible-trigger.directive';
import { BrnCollapsibleComponent } from './brn-collapsible.component';

describe('BrnCollapsibleComponent', () => {
	const setup = async (id?: string, disabled = false) => {
		const container = await render(
			`
     <brn-collapsible ${disabled ? 'disabled' : ''} data-testid='root'>
      <div>
        <h4>&#64;peduarte starred 3 repositories</h4>
        <button brnCollapsibleTrigger data-testid='trigger'>Toggle</button>
      </div>
      <div>&#64;radix-ui/primitives</div>
      <brn-collapsible-content ${id ? `id=${id}` : ''} data-testid='content'>
        <div>&#64;radix-ui/colors</div>
        <div>&#64;stitches/react</div>
      </brn-collapsible-content>
    </brn-collapsible>
    `,
			{
				imports: [BrnCollapsibleComponent, BrnCollapsibleContentComponent, BrnCollapsibleTriggerDirective],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			triggerElement: screen.getByTestId('trigger'),
		};
	};

	type Options = {
		root: HTMLElement;
		trigger: HTMLElement;
		content: HTMLElement;
		id?: string;
	};
	const validateAttributes = async ({ root, trigger, content, id }: Options) => {
		const idMatcher = id ?? expect.stringContaining('brn-collapsible-content');
		expect(root).toBeInTheDocument();
		expect(await axe(root)).toHaveNoViolations();

		expect(trigger).toBeInTheDocument();
		expect(trigger).toHaveAttribute('aria-controls', idMatcher);
		expect(await axe(trigger)).toHaveNoViolations();

		expect(content).toBeInTheDocument();
		expect(content).toHaveAttribute('id', idMatcher);
		expect(await axe(trigger)).toHaveNoViolations();
	};
	const validateOpen = async (id?: string) => {
		const root = await screen.findByTestId('root');
		const trigger = await screen.findByTestId('trigger');
		const content = await screen.findByTestId('content');

		expect(root).toHaveAttribute('data-state', 'open');
		expect(trigger).toHaveAttribute('data-state', 'open');
		expect(trigger).toHaveAttribute('aria-expanded', 'true');
		expect(content).toHaveAttribute('data-state', 'open');

		await validateAttributes({ root, trigger, content, id });
	};
	const validateClosed = async (id?: string) => {
		const root = await screen.findByTestId('root');
		const trigger = await screen.findByTestId('trigger');
		const content = await screen.findByTestId('content');

		expect(root).toHaveAttribute('data-state', 'closed');
		expect(trigger).toHaveAttribute('data-state', 'closed');
		expect(trigger).toHaveAttribute('aria-expanded', 'false');
		expect(content).toHaveAttribute('data-state', 'closed');

		await validateAttributes({ root, trigger, content, id });
	};

	it('not given id on content should create id and set it to aria-described. by default collapsible is closed', async () => {
		await setup();
		await validateClosed();
	});

	it('given id on content should use id and set it to aria-described. by default collapsible is closed', async () => {
		await setup('hello-world');
		await validateClosed('hello-world');
	});

	it('mouse click on element toggles collapsible', async () => {
		const { user, container, triggerElement } = await setup();
		await validateClosed();
		await user.click(triggerElement);
		container.detectChanges();
		await validateOpen();
		await user.click(triggerElement);
		container.detectChanges();
		await validateClosed();
	});

	it('focus with tab and enter toggles collapsible', async () => {
		const { user, container } = await setup();
		await validateClosed();
		await user.keyboard('[Tab][Enter]');
		container.detectChanges();
		await validateOpen();
		await user.keyboard('[Enter]');
		container.detectChanges();
		await validateClosed();
		await user.keyboard('[Enter]');
		container.detectChanges();
		await validateOpen();
	});

	it('focus with tab and space toggles collapsible', async () => {
		const { user, container } = await setup();
		await validateClosed();
		await user.keyboard('[Tab][Space]');
		container.detectChanges();
		await validateOpen();
		await user.keyboard('[Space]');
		container.detectChanges();
		await validateClosed();
		await user.keyboard('[Space]');
		container.detectChanges();
		await validateOpen();
	});

	it('disabled adds correct aria attributes and prevents toggle', async () => {
		const { user, container, triggerElement } = await setup(undefined, true);
		const root = await screen.findByTestId('root');

		expect(root).toHaveAttribute('disabled');
		expect(triggerElement).toHaveAttribute('disabled');

		await validateClosed();
		await user.click(triggerElement);
		container.detectChanges();
		await validateClosed();
		await user.keyboard('[Enter]');
		container.detectChanges();
		await validateClosed();
		await user.keyboard('[Space]');
		container.detectChanges();
		await validateClosed();
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/collapsible/src/lib/brn-collapsible.component.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { ChangeDetectionStrategy, Component, booleanAttribute, input, model, signal } from '@angular/core';

let collapsibleContentIdSequence = 0;

export type BrnCollapsibleState = 'open' | 'closed';

@Component({
	selector: 'brn-collapsible',
	standalone: true,
	host: {
		'[attr.data-state]': 'expanded() ? "open" : "closed"',
		'[attr.disabled]': 'disabled() ? true : undefined',
	},
	template: `
		<ng-content />
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
})
export class BrnCollapsibleComponent {
	public readonly contentId = signal(`brn-collapsible-content-${collapsibleContentIdSequence++}`);

	/**
	 * The expanded or collapsed state of the collapsible component.
	 */
	public readonly expanded = model<boolean>(false);

	/**
	 * The disabled state of the collapsible component.
	 */
	public readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

	/**
	 * Toggles the expanded state of the collapsible component.
	 */
	public toggle(): void {
		this.expanded.update((expanded) => !expanded);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/menu/README.md
```
# @spartan-ng/brain/menu

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/menu`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/menu/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/menu/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnContextMenuTriggerDirective } from './lib/brn-context-menu-trigger.directive';
import { BrnMenuBarDirective } from './lib/brn-menu-bar.directive';
import { BrnMenuGroupDirective } from './lib/brn-menu-group.directive';
import { BrnMenuItemCheckboxDirective } from './lib/brn-menu-item-checkbox.directive';
import { BrnMenuItemRadioDirective } from './lib/brn-menu-item-radio.directive';
import { BrnMenuItemDirective } from './lib/brn-menu-item.directive';
import { BrnMenuTriggerDirective } from './lib/brn-menu-trigger.directive';
import { BrnMenuDirective } from './lib/brn-menu.directive';

export * from './lib/brn-context-menu-trigger.directive';
export * from './lib/brn-menu-bar.directive';
export * from './lib/brn-menu-group.directive';
export * from './lib/brn-menu-item-checkbox.directive';
export * from './lib/brn-menu-item-radio.directive';
export * from './lib/brn-menu-item.directive';
export * from './lib/brn-menu-trigger.directive';
export * from './lib/brn-menu.directive';

export const BrnMenuItemImports = [
	BrnMenuGroupDirective,
	BrnMenuItemDirective,
	BrnMenuItemRadioDirective,
	BrnMenuItemCheckboxDirective,
] as const;
export const BrnMenuImports = [BrnMenuTriggerDirective, BrnMenuDirective, ...BrnMenuItemImports] as const;
export const BrnMenuBarImports = [...BrnMenuImports, BrnMenuBarDirective] as const;
export const BrnContextMenuImports = [...BrnMenuImports, BrnContextMenuTriggerDirective] as const;

@NgModule({
	imports: [...BrnMenuItemImports],
	exports: [...BrnMenuItemImports],
})
export class BrnMenuItemModule {}

@NgModule({
	imports: [...BrnMenuImports],
	exports: [...BrnMenuImports],
})
export class BrnMenuModule {}

@NgModule({
	imports: [...BrnMenuBarImports],
	exports: [...BrnMenuBarImports],
})
export class BrnMenuBarModule {}

@NgModule({
	imports: [...BrnContextMenuImports],
	exports: [...BrnContextMenuImports],
})
export class BrnContextMenuModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/menu/src/lib/brn-context-menu-trigger.directive.ts
```typescript
import { CdkContextMenuTrigger } from '@angular/cdk/menu';
import { Directive, effect, inject, input, type TemplateRef } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { BrnMenuAlign, getBrnMenuAlign } from './brn-menu-align';

@Directive({
	selector: '[brnCtxMenuTriggerFor]',
	standalone: true,
	hostDirectives: [CdkContextMenuTrigger],
})
export class BrnContextMenuTriggerDirective {
	private readonly _cdkTrigger = inject(CdkContextMenuTrigger, { host: true });
	public brnCtxMenuTriggerFor = input<TemplateRef<unknown> | null>(null);
	public brnCtxMenuTriggerData = input<unknown>(undefined);
	public readonly align = input<BrnMenuAlign>(undefined);

	constructor() {
		// once the trigger opens we wait until the next tick and then grab the last position
		// used to position the menu. we store this in our trigger which the brnMenu directive has
		// access to through DI
		this._cdkTrigger.opened.pipe(takeUntilDestroyed()).subscribe(() =>
			setTimeout(
				() =>
					// eslint-disable-next-line
					((this._cdkTrigger as any)._spartanLastPosition = // eslint-disable-next-line
						(this._cdkTrigger as any).overlayRef._positionStrategy._lastPosition),
			),
		);

		effect(() => (this._cdkTrigger.menuTemplateRef = this.brnCtxMenuTriggerFor()));
		effect(() => (this._cdkTrigger.menuData = this.brnCtxMenuTriggerData()));
		effect(() => {
			const align = this.align();
			if (!align) return;
			this._cdkTrigger.menuPosition = getBrnMenuAlign(align);
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/menu/src/lib/brn-menu-align.ts
```typescript
import { ConnectedPosition } from '@angular/cdk/overlay';

export type BrnMenuAlign = 'start' | 'center' | 'end' | undefined;
export const getBrnMenuAlign = (align: Exclude<BrnMenuAlign, undefined>): ConnectedPosition[] => [
	{
		originX: align,
		originY: 'bottom',
		overlayX: align,
		overlayY: 'top',
	},
	{
		originX: align,
		originY: 'top',
		overlayX: align,
		overlayY: 'bottom',
	},
];

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/menu/src/lib/brn-menu-bar.directive.ts
```typescript
import { CdkMenuBar } from '@angular/cdk/menu';
import { Directive } from '@angular/core';

@Directive({
	selector: '[brnMenuBar]',
	standalone: true,
	hostDirectives: [CdkMenuBar],
})
export class BrnMenuBarDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/menu/src/lib/brn-menu-group.directive.ts
```typescript
import { CdkMenuGroup } from '@angular/cdk/menu';
import { Directive } from '@angular/core';

@Directive({
	selector: '[brnMenuGroup]',
	standalone: true,
	hostDirectives: [CdkMenuGroup],
})
export class BrnMenuGroupDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/menu/src/lib/brn-menu-item-checkbox.directive.ts
```typescript
import { CdkMenuItemCheckbox } from '@angular/cdk/menu';
import { booleanAttribute, Directive, effect, inject, input } from '@angular/core';
import { outputFromObservable } from '@angular/core/rxjs-interop';

@Directive({
	selector: '[brnMenuItemCheckbox]',
	standalone: true,
	hostDirectives: [CdkMenuItemCheckbox],
	host: {
		'[class.checked]': 'checked()',
		'[disabled]': 'disabled()',
	},
})
export class BrnMenuItemCheckboxDirective {
	private readonly _cdkMenuItem = inject(CdkMenuItemCheckbox);
	public readonly checked = input(this._cdkMenuItem.checked, { transform: booleanAttribute });
	public readonly disabled = input(this._cdkMenuItem.disabled, { transform: booleanAttribute });
	public readonly triggered = outputFromObservable(this._cdkMenuItem.triggered);

	constructor() {
		effect(() => (this._cdkMenuItem.disabled = this.disabled()));
		effect(() => (this._cdkMenuItem.checked = this.checked()));
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/menu/src/lib/brn-menu-item-radio.directive.ts
```typescript
import { CdkMenuItemRadio } from '@angular/cdk/menu';
import { booleanAttribute, Directive, effect, inject, input } from '@angular/core';
import { outputFromObservable } from '@angular/core/rxjs-interop';

@Directive({
	selector: '[brnMenuItemRadio]',
	standalone: true,
	hostDirectives: [CdkMenuItemRadio],
	host: {
		'[class.checked]': 'checked()',
		'[disabled]': 'disabled()',
	},
})
export class BrnMenuItemRadioDirective {
	private readonly _cdkMenuItem = inject(CdkMenuItemRadio);
	public readonly checked = input(this._cdkMenuItem.checked, { transform: booleanAttribute });
	public readonly disabled = input(this._cdkMenuItem.disabled, { transform: booleanAttribute });
	public readonly triggered = outputFromObservable(this._cdkMenuItem.triggered);

	constructor() {
		effect(() => (this._cdkMenuItem.disabled = this.disabled()));
		effect(() => (this._cdkMenuItem.checked = this.checked()));
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/menu/src/lib/brn-menu-item.directive.ts
```typescript
import { CdkMenuItem } from '@angular/cdk/menu';
import { booleanAttribute, Directive, effect, inject, input } from '@angular/core';
import { outputFromObservable } from '@angular/core/rxjs-interop';

@Directive({
	selector: '[brnMenuItem]',
	standalone: true,
	hostDirectives: [CdkMenuItem],
	host: {
		'[disabled]': 'disabled()',
	},
})
export class BrnMenuItemDirective {
	private readonly _cdkMenuItem = inject(CdkMenuItem);
	public readonly disabled = input(this._cdkMenuItem.disabled, { transform: booleanAttribute });
	public readonly triggered = outputFromObservable(this._cdkMenuItem.triggered);

	constructor() {
		effect(() => (this._cdkMenuItem.disabled = this.disabled()));
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/menu/src/lib/brn-menu-trigger.directive.ts
```typescript
import { CdkMenuTrigger } from '@angular/cdk/menu';
import { Directive, effect, inject, input } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { BrnMenuAlign, getBrnMenuAlign } from './brn-menu-align';

@Directive({
	selector: '[brnMenuTriggerFor]',
	standalone: true,
	hostDirectives: [
		{
			directive: CdkMenuTrigger,
			inputs: ['cdkMenuTriggerFor: brnMenuTriggerFor', 'cdkMenuTriggerData: brnMenuTriggerData'],
			outputs: ['cdkMenuOpened: brnMenuOpened', 'cdkMenuClosed: brnMenuClosed'],
		},
	],
})
export class BrnMenuTriggerDirective {
	private readonly _cdkTrigger = inject(CdkMenuTrigger, { host: true });
	public readonly align = input<BrnMenuAlign>(undefined);

	constructor() {
		// once the trigger opens we wait until the next tick and then grab the last position
		// used to position the menu. we store this in our trigger which the brnMenu directive has
		// access to through DI
		this._cdkTrigger.opened.pipe(takeUntilDestroyed()).subscribe(() =>
			setTimeout(
				() =>
					// eslint-disable-next-line
					((this._cdkTrigger as any)._spartanLastPosition = // eslint-disable-next-line
						(this._cdkTrigger as any).overlayRef._positionStrategy._lastPosition),
			),
		);

		effect(() => {
			const align = this.align();
			if (!align) return;
			this._cdkTrigger.menuPosition = getBrnMenuAlign(align);
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/menu/src/lib/brn-menu.directive.ts
```typescript
import { CdkMenu } from '@angular/cdk/menu';
import { Directive, inject, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

@Directive({
	selector: '[brnMenu],[brnSubMenu]',
	standalone: true,
	host: {
		'[attr.data-state]': '_state()',
		'[attr.data-side]': '_side()',
	},
	hostDirectives: [CdkMenu],
})
export class BrnMenuDirective {
	private readonly _host = inject(CdkMenu);

	protected readonly _state = signal('open');
	protected readonly _side = signal('top');

	constructor() {
		this.setSideWithDarkMagic();
		// this is a best effort, but does not seem to work currently
		// TODO: figure out a way for us to know the host is about to be closed. might not be possible with CDK
		this._host.closed.pipe(takeUntilDestroyed()).subscribe(() => this._state.set('closed'));
	}

	private setSideWithDarkMagic() {
		/**
		 * This is an ugly workaround to at least figure out the correct side of where a submenu
		 * will appear and set the attribute to the host accordingly
		 *
		 * First of all we take advantage of the menu stack not being aware of the root
		 * object immediately after it is added. This code executes before the root element is added,
		 * which means the stack is still empty and the peek method returns undefined.
		 */
		const isRoot = this._host.menuStack.peek() === undefined;
		setTimeout(() => {
			// our menu trigger directive leaves the last position used for use immediately after opening
			// we can access it here and determine the correct side.
			// eslint-disable-next-line
			const ps = (this._host as any)._parentTrigger._spartanLastPosition;
			if (!ps) {
				// if we have no last position we default to the most likely option
				// I hate that we have to do this and hope we can revisit soon and improve
				this._side.set(isRoot ? 'top' : 'left');
				return;
			}
			const side = isRoot ? ps.originY : ps.originX === 'end' ? 'right' : 'left';
			this._side.set(side);
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/README.md
```
# @spartan-ng/brain/avatar

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/avatar`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnAvatarComponent } from './lib/brn-avatar.component';
import { BrnAvatarFallbackDirective } from './lib/fallback';
import { BrnAvatarImageDirective } from './lib/image';

export * from './lib/brn-avatar.component';
export * from './lib/fallback';
export * from './lib/image';
export * from './lib/util';

export const BrnAvatarImports = [BrnAvatarComponent, BrnAvatarFallbackDirective, BrnAvatarImageDirective] as const;

@NgModule({
	imports: [...BrnAvatarImports],
	exports: [...BrnAvatarImports],
})
export class BrnAvatarModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/brn-avatar.component.spec.ts
```typescript
import { Component } from '@angular/core';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { BrnAvatarComponent } from './brn-avatar.component';
import { BrnAvatarFallbackDirective } from './fallback/brn-avatar-fallback.directive';
import { BrnAvatarImageDirective } from './image/brn-avatar-image.directive';

@Component({
	selector: 'brn-mock',
	imports: [BrnAvatarImageDirective, BrnAvatarFallbackDirective, BrnAvatarComponent],
	template: `
		<brn-avatar id="empty">
			<p>empty</p>
		</brn-avatar>
		<brn-avatar id="fallbackOnly">
			<span brnAvatarFallback>fallback</span>
		</brn-avatar>
		<brn-avatar id="noSrc">
			<img brnAvatarImage alt="Avatar image" />
			<span brnAvatarFallback>fallback</span>
		</brn-avatar>
		<brn-avatar id="good">
			<img
				brnAvatarImage
				alt="Avatar image"
				src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII="
			/>
			<span brnAvatarFallback>fallback</span>
		</brn-avatar>
	`,
	standalone: true,
})
class MockComponent {}

describe('BrnAvatarComponent', () => {
	let component: MockComponent;
	let fixture: ComponentFixture<MockComponent>;

	beforeEach(() => {
		fixture = TestBed.createComponent(MockComponent);
		component = fixture.componentInstance;
		fixture.autoDetectChanges();
	});
	it('should compile', () => {
		expect(component).toBeTruthy();
	});

	it('should render the fallback when no image is provided', () => {
		const fallback = fixture.nativeElement.querySelector('#fallbackOnly span');
		expect(fallback.textContent).toEqual('fallback');
	});

	it('should not render anything when no image or fallback is provided', () => {
		const empty = fixture.nativeElement.querySelector('#empty p');
		expect(empty).toBeFalsy();
	});

	it('should render the fallback when provided and image with no src', () => {
		const fallback = fixture.nativeElement.querySelector('#noSrc span');
		expect(fallback.textContent).toEqual('fallback');
	});

	it('should not render the fallback, but rather the image when provided with a valid src', () => {
		// delay test to allow for image to resolve
		setTimeout(() => {
			const img = fixture.debugElement.query(By.css('#good img'));
			expect(img).toBeTruthy();
			const fallback = fixture.nativeElement.querySelector('#good span');
			expect(fallback).toBeFalsy();
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/brn-avatar.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation, contentChild } from '@angular/core';
import { BrnAvatarImageDirective } from './image';

@Component({
	selector: 'brn-avatar',
	standalone: true,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	template: `
		@if (image()?.canShow()) {
			<ng-content select="[brnAvatarImage]" />
		} @else {
			<ng-content select="[brnAvatarFallback]" />
		}
	`,
})
export class BrnAvatarComponent {
	protected readonly image = contentChild(BrnAvatarImageDirective);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/util/hex-color-for.spec.ts
```typescript
import { faker } from '@faker-js/faker';
import { hexColorFor } from './hex-color-for';

describe('hexColorFor', () => {
	it('should return a text color of white and a pink-ish background for John Doe', () => {
		const generated = hexColorFor('John Doe');
		expect(generated).toBe('#a55c80');
	});

	it('should return a text color of white and a blue-ish background for Jane Doe', () => {
		const generated = hexColorFor('Jane Doe');
		expect(generated).toBe('#485fa7');
	});

	it('should return different colors for different names', () => {
		expect(hexColorFor(faker.person.fullName())).not.toBe(hexColorFor(faker.person.fullName()));
	});

	it('should return the same style when given the same name', () => {
		const name = faker.person.fullName();
		expect(hexColorFor(name)).toBe(hexColorFor(name));
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/util/hex-color-for.ts
```typescript
function hashString(str: string) {
	let h;
	for (let i = 0; i < str.length; i++) h = (Math.imul(31, h || 0) + str.charCodeAt(i)) | 0;

	return h || 0;
}

function hashManyTimes(times: number, str: string) {
	let h = hashString(str);

	for (let i = 0; i < times; i++) h = hashString(String(h));

	return h;
}

export function hexColorFor(str: string) {
	const hash = str.length <= 2 ? hashManyTimes(5, str) : hashString(str);

	let color = '#';

	for (let i = 0; i < 3; i += 1) {
		const value = (hash >> (i * 8)) & 0xff;
		color += `00${value.toString(16)}`.slice(-2);
	}

	return color;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/util/index.ts
```typescript
export * from './hex-color-for';
export * from './initials.pipe';
export * from './is-bright';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/util/initials.pipe.spec.ts
```typescript
import { faker } from '@faker-js/faker';
import { InitialsPipe } from './initials.pipe';

describe('InitialsPipe', () => {
	const pipe = new InitialsPipe();

	it('should compile', () => {
		expect(pipe).toBeTruthy();
	});

	it('should return an empty string, when an empty string is provided', () => {
		expect(pipe.transform('')).toBe('');
		expect(pipe.transform(' ')).toBe('');
	});

	it.skip('should return the uppercased initials of a provided name', () => {
		const name = 'John Doe';
		const otherName = 'Mary Ann Smith';
		const randomName = faker.person.fullName();

		expect(pipe.transform(name)).toBe('JD');
		expect(pipe.transform(otherName)).toBe('MS');
		expect(pipe.transform(randomName)).toBe(
			`${randomName.charAt(0).toLocaleUpperCase()}${randomName.charAt(randomName.indexOf(' ') + 1).toLocaleUpperCase()}`,
		);
	});

	it('should not capitalize the initials, when the capitalize flag is set to false', () => {
		const name = 'john Doe';
		const otherName = 'mary ann smith';
		const randomName = `${faker.person.firstName()} ${faker.person.lastName()}`;

		expect(pipe.transform(name, false)).toBe('jD');
		expect(pipe.transform(otherName, false)).toBe('ms');
		expect(pipe.transform(randomName, false)).toBe(
			`${randomName.charAt(0)}${randomName.charAt(randomName.lastIndexOf(' ') + 1)}`,
		);
	});

	it('should return all initials when the firstAndLastOnly flag is set to false', () => {
		const name = 'Mary Ann       Smith';

		expect(pipe.transform(name, true, false)).toBe('MAS');
	});

	it('should split the name by the provided delimiter', () => {
		const name = 'Mary:Ann:Smith: ';

		expect(pipe.transform(name, true, true, ':')).toBe('MS');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/util/initials.pipe.ts
```typescript
import { Pipe, type PipeTransform } from '@angular/core';

const toInitial =
	(capitalize = true) =>
	(word: string) => {
		const initial = word.charAt(0);
		return capitalize ? initial.toLocaleUpperCase() : initial;
	};

const firstAndLast = (initials: string[]) => `${initials[0]}${initials[initials.length - 1]}`;

@Pipe({
	name: 'initials',
	standalone: true,
})
export class InitialsPipe implements PipeTransform {
	transform(name: string, capitalize = true, firstAndLastOnly = true, delimiter = ' '): string {
		if (!name) return '';

		const initials = name.trim().split(delimiter).filter(Boolean).map(toInitial(capitalize));

		if (firstAndLastOnly && initials.length > 1) return firstAndLast(initials);

		return initials.join('');
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/util/is-bright.spec.ts
```typescript
import { isBright } from './is-bright';

describe('isBright', () => {
	it('should return true for white hex code', () => {
		expect(isBright('#ffffff')).toBe(true);
	});

	it('should return false for black hex code', () => {
		expect(isBright('#000000')).toBe(false);
	});

	it('should return true for a light hex code', () => {
		expect(isBright('#e394bb')).toBe(true);
	});

	it('should return false for a dark hex code', () => {
		expect(isBright('#485fa7')).toBe(false);
	});

	it('should support hex color shorthand, with our without hash & ignore capitalization', () => {
		expect(isBright('ffffff')).toBe(true);
		expect(isBright('#fff')).toBe(true);
		expect(isBright('fff')).toBe(true);
		expect(isBright('#FFF')).toBe(true);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/util/is-bright.ts
```typescript
const isShortHand = (hex: string) => hex.length === 3;

const cleanup = (hex: string) => {
	const noHash = hex.replace('#', '').trim().toLowerCase();

	if (!isShortHand(noHash)) return noHash;

	return noHash
		.split('')
		.map((char) => char + char)
		.join('');
};

export const isBright = (hex: string) => Number.parseInt(cleanup(hex), 16) > 0xffffff / 1.25;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/fallback/brn-avatar-fallback.directive.spec.ts
```typescript
import { Component, PLATFORM_ID } from '@angular/core';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { BrnAvatarFallbackDirective } from './brn-avatar-fallback.directive';

@Component({
	selector: 'brn-mock',
	standalone: true,
	imports: [BrnAvatarFallbackDirective],
	template: `
		<span *brnAvatarFallback>fallback</span>
		<span brnAvatarFallback>fallback2</span>
	`,
})
class BrnMockComponent {}

describe('BrnAvatarFallbackDirective', () => {
	let component: BrnMockComponent;
	let fixture: ComponentFixture<BrnMockComponent>;

	beforeEach(() => {
		fixture = TestBed.overrideProvider(PLATFORM_ID, { useValue: 'browser' }).createComponent(BrnMockComponent);
		component = fixture.componentInstance;
	});

	it('should compile', () => {
		expect(component).toBeTruthy();
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/fallback/brn-avatar-fallback.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { Directive, ElementRef, booleanAttribute, inject, input } from '@angular/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[brnAvatarFallback]',
	standalone: true,
	exportAs: 'avatarFallback',
})
export class BrnAvatarFallbackDirective {
	private readonly _element = inject(ElementRef).nativeElement;

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly autoColor = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

	getTextContent(): string {
		return this._element.textContent;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/fallback/index.ts
```typescript
export * from './brn-avatar-fallback.directive';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/image/brn-avatar-image.directive.spec.ts
```typescript
import { Component } from '@angular/core';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { BrnAvatarImageDirective } from './brn-avatar-image.directive';

@Component({
	selector: 'brn-mock',
	standalone: true,
	imports: [BrnAvatarImageDirective],
	template: `
		<div id="bad">
			<img brnAvatarImage #bad="avatarImage" alt="Avatar image" />
			<span>{{ bad.canShow() }}</span>
		</div>
		<div id="unloaded">
			<img
				src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII="
				brnAvatarImage
				alt="Avatar image"
				#unloaded="avatarImage"
			/>
			<span>{{ unloaded.canShow() }}</span>
		</div>
		<div id="loaded">
			<img
				src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII="
				brnAvatarImage
				alt="Avatar image"
				#good="avatarImage"
			/>
			<span>{{ good.canShow() }}</span>
		</div>
	`,
})
class BrnMockComponent {}

describe('BrnAvatarImageDirective', () => {
	let component: BrnMockComponent;
	let fixture: ComponentFixture<BrnMockComponent>;

	beforeEach(() => {
		fixture = TestBed.createComponent(BrnMockComponent);
		component = fixture.componentInstance;
	});

	it('should compile', () => {
		expect(component).toBeTruthy();
	});

	it('should return false when image has no src', () => {
		fixture.detectChanges();
		const bad = fixture.nativeElement.querySelector('#bad');
		expect(bad.querySelector('span').textContent).toEqual('false');
	});

	it('should return false when image has a valid src but isnt loaded', async () => {
		fixture.detectChanges();
		await fixture.whenRenderingDone();
		const unloaded = fixture.nativeElement.querySelector('#unloaded');
		expect(unloaded.querySelector('span').textContent).toEqual('false');
	});

	it('should return true when the image is loaded without error', async () => {
		fixture.debugElement.query(By.css('#loaded img')).triggerEventHandler('load', null);
		fixture.detectChanges();
		const unloaded = fixture.nativeElement.querySelector('#loaded');
		expect(unloaded.querySelector('span').textContent).toEqual('true');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/image/brn-avatar-image.directive.ts
```typescript
import { Directive, HostListener, computed, signal } from '@angular/core';

@Directive({
	selector: 'img[brnAvatarImage]',
	standalone: true,
	exportAs: 'avatarImage',
})
export class BrnAvatarImageDirective {
	private readonly _loaded = signal(false);

	@HostListener('error')
	private onError() {
		this._loaded.set(false);
	}

	@HostListener('load')
	private onLoad() {
		this._loaded.set(true);
	}

	public canShow = computed(() => this._loaded());
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/image/index.ts
```typescript
export * from './brn-avatar-image.directive';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/switch/README.md
```
# @spartan-ng/brain/switch

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/switch`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/switch/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/switch/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnSwitchThumbComponent } from './lib/brn-switch-thumb.component';
import { BrnSwitchComponent } from './lib/brn-switch.component';

export * from './lib/brn-switch-thumb.component';
export * from './lib/brn-switch.component';

export const BrnSwitchImports = [BrnSwitchComponent, BrnSwitchThumbComponent] as const;

@NgModule({
	imports: [...BrnSwitchImports],
	exports: [...BrnSwitchImports],
})
export class BrnSwitchModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/switch/src/lib/brn-switch-ng-model.spec.ts
```typescript
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';

import { Component, Input } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BrnSwitchThumbComponent } from './brn-switch-thumb.component';
import { BrnSwitchComponent } from './brn-switch.component';

@Component({
	selector: 'brn-switch-ng-model',
	template: `
		<label>
			Airplane mode is: {{ airplaneMode ? 'on' : 'off' }}
			<brn-switch [disabled]="disabled" [(ngModel)]="airplaneMode">
				<brn-switch-thumb />
			</brn-switch>
		</label>
	`,
	imports: [BrnSwitchComponent, BrnSwitchThumbComponent, FormsModule],
})
export class BrnSwitchNgModelSpecComponent {
	@Input()
	public disabled = false;
	@Input()
	public airplaneMode = false;
}

describe('BrnSwitchComponentNgModelIntegration', () => {
	const setup = async (airplaneMode = false, disabled = false) => {
		const container = await render(BrnSwitchNgModelSpecComponent, {
			componentInputs: {
				disabled,
				airplaneMode,
			},
		});
		const labelMatch = airplaneMode ? /airplane mode is: on/i : /airplane mode is: off/i;
		return {
			user: userEvent.setup(),
			container,
			switchElement: screen.getByLabelText(labelMatch),
			labelElement: screen.getByText(labelMatch),
		};
	};

	it('click should toggle value correctly', async () => {
		const { labelElement, user, container } = await setup();
		expect(labelElement).toBeInTheDocument();
		await user.click(labelElement);
		expect(await screen.findByRole('switch')).toHaveAttribute('value', 'on');
		expect(container.fixture.componentInstance.airplaneMode).toBe(true);
	});

	it('should set input as default correctly and click should toggle then', async () => {
		const { labelElement, user, container } = await setup(true);

		await user.click(labelElement);
		expect(await screen.findByRole('switch')).toHaveAttribute('value', 'off');
		expect(container.fixture.componentInstance.airplaneMode).toBe(false);

		await user.click(labelElement);
		expect(await screen.findByRole('switch')).toHaveAttribute('value', 'on');
		expect(container.fixture.componentInstance.airplaneMode).toBe(true);
	});

	it('should set input as default correctly and enter should toggle then', async () => {
		const { user, container } = await setup(true);

		await user.keyboard('[Tab][Enter]');
		expect(container.fixture.componentInstance.airplaneMode).toBe(false);

		await user.keyboard('[Enter]');
		expect(container.fixture.componentInstance.airplaneMode).toBe(true);
	});

	it('should do nothing when disabled', async () => {
		const { labelElement, user, container } = await setup(false, true);

		await user.click(labelElement);
		expect(await screen.findByRole('switch')).toHaveAttribute('value', 'off');
		expect(container.fixture.componentInstance.airplaneMode).toBe(false);

		await user.click(labelElement);
		expect(await screen.findByRole('switch')).toHaveAttribute('value', 'off');
		expect(container.fixture.componentInstance.airplaneMode).toBe(false);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/switch/src/lib/brn-switch-thumb.component.ts
```typescript
import { Component } from '@angular/core';

@Component({
	selector: 'brn-switch-thumb',
	template: '',
	host: {
		role: 'presentation',
		'(click)': '$event.preventDefault()',
	},
})
export class BrnSwitchThumbComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/switch/src/lib/brn-switch.component.spec.ts
```typescript
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import { axe } from 'jest-axe';
import { BrnSwitchThumbComponent } from './brn-switch-thumb.component';
import { BrnSwitchComponent } from './brn-switch.component';

describe('BrnSwitchComponent', () => {
	const setup = async () => {
		const container = await render(
			`
     <brn-switch id='switchId' name='switchName' data-testid='brnSwitch' aria-label='switch'>
             <brn-switch-thumb />
      </brn-switch>
    `,
			{
				imports: [BrnSwitchComponent, BrnSwitchThumbComponent],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			containerElement: screen.getByLabelText('switch'),
		};
	};

	const setupInsideLabel = async () => {
		const container = await render(
			`
     <label>
     Switch Inside Label
     <brn-switch id='switchId' data-testid='brnSwitch' name='switchName'>
             <brn-switch-thumb />
      </brn-switch>
      </label>
    `,
			{
				imports: [BrnSwitchComponent, BrnSwitchThumbComponent],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			containerElement: screen.getByLabelText(/switch inside label/i),
			labelElement: screen.getByText(/switch inside label/i),
		};
	};

	const setupOutsideLabelWithAriaLabelledBy = async () => {
		const container = await render(
			`
     <!-- need for because arialabelledby only provides accessible name -->
     <label id='labelId' for='switchId'>
     Switch Outside Label with ariaLabelledBy
     </label>
     <brn-switch id='switchId' name='switchName' data-testid='brnSwitch' aria-labelledby='labelId'>
             <brn-switch-thumb />
      </brn-switch>
    `,
			{
				imports: [BrnSwitchComponent, BrnSwitchThumbComponent],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			containerElement: screen.getByLabelText(/switch outside label with arialabelledby/i),
			labelElement: screen.getByText(/switch outside label with arialabelledby/i),
		};
	};

	const setupOutsideLabelWithForAndId = async () => {
		const container = await render(
			`
     <label for='switchId'>
     Switch Outside Label with id
     </label>
     <brn-switch id='switchId' name='switchName' data-testid='brnSwitch'>
             <brn-switch-thumb />
      </brn-switch>
    `,
			{
				imports: [BrnSwitchComponent, BrnSwitchThumbComponent],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			containerElement: screen.getByLabelText(/switch outside label with id/i),
			labelElement: screen.getByText(/switch outside label with id/i),
		};
	};

	type Options = Partial<{ focus: boolean; focusVisible: boolean; disabled: boolean }>;

	const validateAttributes = async (
		switchElement: HTMLElement,
		containerElement: HTMLElement,
		shouldBeChecked: boolean,
		opts?: Options,
	) => {
		expect(switchElement).toBeInTheDocument();
		expect(switchElement).toHaveAttribute('type', 'button');
		expect(switchElement).toHaveAttribute('id', 'switchId');
		expect(switchElement).toHaveAttribute('name', 'switchName');
		expect(await axe(switchElement)).toHaveNoViolations();

		expect(containerElement).toHaveAttribute('id', 'switchId-switch');
		expect(containerElement).toHaveAttribute('name', 'switchName-switch');
		expect(containerElement).toHaveAttribute('data-state', shouldBeChecked ? 'checked' : 'unchecked');
		expect(containerElement).toHaveAttribute('data-disabled', `${!!opts?.disabled}`);
		expect(containerElement).toHaveAttribute('data-focus', `${!!opts?.focus}`);
		expect(containerElement).toHaveAttribute('data-focus-visible', `${!!opts?.focusVisible}`);
		expect(await axe(containerElement)).toHaveNoViolations();
	};
	const validateSwitchOn = async (opts?: Options) => {
		const switchElement = await screen.findByRole('switch');
		const containerElement = await screen.findByTestId('brnSwitch');

		await validateAttributes(switchElement, containerElement, true, opts);
	};
	const validateSwitchOff = async (opts?: Options) => {
		const switchElement = await screen.findByRole('switch');
		const containerElement = await screen.findByTestId('brnSwitch');

		await validateAttributes(switchElement, containerElement, false, opts);
	};

	describe('with aria-label', () => {
		it('unchecked by default', async () => {
			await setup();
			await validateSwitchOff();
		});
		it('mouse click on element toggles', async () => {
			const { user, containerElement } = await setup();
			await validateSwitchOff();
			await user.click(containerElement);
			await validateSwitchOn({ focus: true });
			await user.click(containerElement);
			await validateSwitchOff({ focus: true });
		});
		it('focus with tab and enter toggles', async () => {
			const { user } = await setup();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Enter]');
			await validateSwitchOn(options);
			await user.keyboard('[Enter]');
			await validateSwitchOff(options);
			await user.keyboard('[Enter]');
			await validateSwitchOn(options);
		});
		it('focus with tab and space toggles', async () => {
			const { user } = await setup();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Space]');
			await validateSwitchOn(options);
			await user.keyboard('[Space]');
			await validateSwitchOff(options);
			await user.keyboard('[Space]');
			await validateSwitchOn(options);
		});
	});

	describe('inside <label>', () => {
		it('unchecked by default', async () => {
			await setupInsideLabel();
			await validateSwitchOff();
		});
		it('mouse click on element toggles', async () => {
			const { user, labelElement } = await setupInsideLabel();
			await validateSwitchOff();
			await user.click(labelElement);
			await validateSwitchOn({ focus: true });
			await user.click(labelElement);
			await validateSwitchOff({ focus: true });
		});
		it('focus with tab and enter toggles', async () => {
			const { user } = await setupInsideLabel();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Enter]');
			await validateSwitchOn(options);
			await user.keyboard('[Enter]');
			await validateSwitchOff(options);
			await user.keyboard('[Enter]');
			await validateSwitchOn(options);
		});
		it('focus with tab and space toggles', async () => {
			const { user } = await setupInsideLabel();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Space]');
			await validateSwitchOn(options);
			await user.keyboard('[Space]');
			await validateSwitchOff(options);
			await user.keyboard('[Space]');
			await validateSwitchOn(options);
		});
	});

	describe('outside <label> with aria-labelledby', () => {
		it('unchecked by default', async () => {
			await setupOutsideLabelWithAriaLabelledBy();
			await validateSwitchOff();
		});
		it('mouse click on element toggles', async () => {
			const { user, labelElement } = await setupOutsideLabelWithAriaLabelledBy();
			await validateSwitchOff();
			await user.click(labelElement);
			await validateSwitchOn({ focus: true });
			await user.click(labelElement);
			await validateSwitchOff({ focus: true });
		});
		it('focus with tab and enter toggles', async () => {
			const { user } = await setupOutsideLabelWithAriaLabelledBy();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Enter]');
			await validateSwitchOn(options);
			await user.keyboard('[Enter]');
			await validateSwitchOff(options);
			await user.keyboard('[Enter]');
			await validateSwitchOn(options);
		});
		it('focus with tab and space toggles', async () => {
			const { user } = await setupOutsideLabelWithAriaLabelledBy();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Space]');
			await validateSwitchOn(options);
			await user.keyboard('[Space]');
			await validateSwitchOff(options);
			await user.keyboard('[Space]');
			await validateSwitchOn(options);
		});
	});

	describe('outside <label> with for and id', () => {
		it('unchecked by default', async () => {
			await setupOutsideLabelWithForAndId();
			await validateSwitchOff();
		});
		it('mouse click on element toggles', async () => {
			const { user, labelElement } = await setupOutsideLabelWithForAndId();
			await validateSwitchOff();
			await user.click(labelElement);
			await validateSwitchOn({ focus: true });
			await user.click(labelElement);
			await validateSwitchOff({ focus: true });
		});
		it('focus with tab and enter toggles', async () => {
			const { user } = await setupOutsideLabelWithForAndId();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Enter]');
			await validateSwitchOn(options);
			await user.keyboard('[Enter]');
			await validateSwitchOff(options);
			await user.keyboard('[Enter]');
			await validateSwitchOn(options);
		});
		it('focus with tab and space toggles', async () => {
			const { user } = await setupOutsideLabelWithForAndId();
			const options = { focus: true, focusVisible: true };
			await validateSwitchOff();
			await user.keyboard('[Tab][Space]');
			await validateSwitchOn(options);
			await user.keyboard('[Space]');
			await validateSwitchOff(options);
			await user.keyboard('[Space]');
			await validateSwitchOn(options);
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/switch/src/lib/brn-switch.component.ts
```typescript
import { FocusMonitor } from '@angular/cdk/a11y';
import { BooleanInput } from '@angular/cdk/coercion';
import { DOCUMENT, isPlatformBrowser } from '@angular/common';
import {
	type AfterContentInit,
	booleanAttribute,
	ChangeDetectionStrategy,
	ChangeDetectorRef,
	Component,
	computed,
	DestroyRef,
	effect,
	ElementRef,
	forwardRef,
	inject,
	input,
	linkedSignal,
	model,
	type OnDestroy,
	output,
	PLATFORM_ID,
	Renderer2,
	signal,
	viewChild,
	ViewEncapsulation,
} from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { NG_VALUE_ACCESSOR } from '@angular/forms';
import { ChangeFn, TouchFn } from '@spartan-ng/brain/forms';

export const BRN_SWITCH_VALUE_ACCESSOR = {
	provide: NG_VALUE_ACCESSOR,
	useExisting: forwardRef(() => BrnSwitchComponent),
	multi: true,
};

const CONTAINER_POST_FIX = '-switch';

let uniqueIdCounter = 0;

@Component({
	selector: 'brn-switch',
	template: `
		<button
			#switch
			role="switch"
			type="button"
			[class]="class()"
			[id]="getSwitchButtonId(state().id) ?? ''"
			[name]="getSwitchButtonId(state().name) ?? ''"
			[value]="checked() ? 'on' : 'off'"
			[attr.aria-checked]="checked()"
			[attr.aria-label]="ariaLabel() || null"
			[attr.aria-labelledby]="mutableAriaLabelledby() || null"
			[attr.aria-describedby]="ariaDescribedby() || null"
			[attr.data-state]="checked() ? 'checked' : 'unchecked'"
			[attr.data-focus-visible]="focusVisible()"
			[attr.data-focus]="focused()"
			[attr.data-disabled]="state().disabled()"
			[disabled]="state().disabled()"
			[tabIndex]="tabIndex()"
			(click)="$event.preventDefault(); toggle()"
		>
			<ng-content select="brn-switch-thumb" />
		</button>
	`,
	host: {
		'[style]': '{display: "contents"}',
		'[attr.id]': 'state().id',
		'[attr.name]': 'state().name',
		'[attr.aria-labelledby]': 'null',
		'[attr.aria-label]': 'null',
		'[attr.aria-describedby]': 'null',
		'[attr.data-state]': 'checked() ? "checked" : "unchecked"',
		'[attr.data-focus-visible]': 'focusVisible()',
		'[attr.data-focus]': 'focused()',
		'[attr.data-disabled]': 'state().disabled()',
	},
	providers: [BRN_SWITCH_VALUE_ACCESSOR],
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnSwitchComponent implements AfterContentInit, OnDestroy {
	private readonly _destroyRef = inject(DestroyRef);
	private readonly _renderer = inject(Renderer2);
	private readonly _isBrowser = isPlatformBrowser(inject(PLATFORM_ID));
	private readonly _elementRef = inject<ElementRef<HTMLElement>>(ElementRef);
	private readonly _focusMonitor = inject(FocusMonitor);
	private readonly _cdr = inject(ChangeDetectorRef);
	private readonly _document = inject(DOCUMENT);

	protected readonly focusVisible = signal(false);
	protected readonly focused = signal(false);

	/**
	 * Whether the switch is checked.
	 * Can be bound with [(checked)]
	 */
	public readonly checked = model<boolean>(false);

	/**
	 * Sets the ID on the switch.
	 * When provided, the inner button gets this ID without the '-switch' suffix.
	 */
	public readonly id = input<string | null>(uniqueIdCounter++ + '');

	/**
	 * Sets the name on the switch.
	 * When provided, the inner button gets this name without a '-switch' suffix.
	 */
	public readonly name = input<string | null>(null);

	/**
	 * Sets class set on the inner button
	 */
	public readonly class = input<string | null>(null);

	/**
	 * Sets the aria-label attribute for accessibility.
	 */
	public readonly ariaLabel = input<string | null>(null, { alias: 'aria-label' });

	/**
	 * Sets the aria-labelledby attribute for accessibility.
	 */
	public readonly ariaLabelledby = input<string | null>(null, { alias: 'aria-labelledby' });
	public readonly mutableAriaLabelledby = linkedSignal(() => this.ariaLabelledby());

	/**
	 * Sets the aria-describedby attribute for accessibility.
	 */
	public readonly ariaDescribedby = input<string | null>(null, { alias: 'aria-describedby' });

	/**
	 * Whether the switch is required in a form.
	 */
	public readonly required = input(false, { transform: booleanAttribute });

	/**
	 * Whether the switch is disabled.
	 */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/**
	 * tabIndex of the switch.
	 */
	public readonly tabIndex = input(0);

	/**
	 * Event emitted when the switch value changes.
	 */
	public readonly changed = output<boolean>();

	/**
	 * Event emitted when the switch is blurred (loses focus).
	 */
	public readonly touched = output<void>();

	// eslint-disable-next-line @typescript-eslint/no-empty-function
	protected _onChange: ChangeFn<boolean> = () => {};
	// eslint-disable-next-line @typescript-eslint/no-empty-function
	private _onTouched: TouchFn = () => {};

	public readonly switch = viewChild.required<ElementRef<HTMLInputElement>>('switch');

	protected readonly state = computed(() => {
		const name = this.name();
		const id = this.id();
		return {
			disabled: signal(this.disabled()),
			name: name ? name + CONTAINER_POST_FIX : null,
			id: id ? id + CONTAINER_POST_FIX : null,
		};
	});

	constructor() {
		effect(() => {
			const state = this.state();
			const isDisabled = state.disabled();

			if (!this._elementRef.nativeElement || !this._isBrowser) return;

			const newLabelId = state.id + '-label';
			const switchButtonId = this.getSwitchButtonId(state.id);
			const labelElement =
				this._elementRef.nativeElement.closest('label') ??
				this._document.querySelector(`label[for="${switchButtonId}"]`);

			if (!labelElement) return;
			const existingLabelId = labelElement.id;

			this._renderer.setAttribute(labelElement, 'data-disabled', isDisabled ? 'true' : 'false');
			this.mutableAriaLabelledby.set(existingLabelId || newLabelId);

			if (!existingLabelId || existingLabelId.length === 0) {
				this._renderer.setAttribute(labelElement, 'id', newLabelId);
			}
		});
	}

	protected toggle(): void {
		if (this.state().disabled()) return;

		this.checked.update((checked) => !checked);
		this._onChange(this.checked());
		this.changed.emit(this.checked());
	}

	ngAfterContentInit() {
		this._focusMonitor
			.monitor(this._elementRef, true)
			.pipe(takeUntilDestroyed(this._destroyRef))
			.subscribe((focusOrigin) => {
				if (focusOrigin) this.focused.set(true);
				if (focusOrigin === 'keyboard' || focusOrigin === 'program') {
					this.focusVisible.set(true);
					this._cdr.markForCheck();
				}
				if (!focusOrigin) {
					// When a focused element becomes disabled, the browser *immediately* fires a blur event.
					// Angular does not expect events to be raised during change detection, so any state
					// change (such as a form control's ng-touched) will cause a changed-after-checked error.
					// See https://github.com/angular/angular/issues/17793. To work around this, we defer
					// telling the form control it has been touched until the next tick.
					Promise.resolve().then(() => {
						this.focusVisible.set(false);
						this.focused.set(false);
						this._onTouched();
						this.touched.emit();
						this._cdr.markForCheck();
					});
				}
			});

		if (!this.switch()) return;
		this.switch().nativeElement.value = this.checked() ? 'on' : 'off';
		this.switch().nativeElement.dispatchEvent(new Event('change'));
	}

	ngOnDestroy() {
		this._focusMonitor.stopMonitoring(this._elementRef);
	}

	/** We intercept the id passed to the wrapper component and pass it to the underlying button switch control **/
	protected getSwitchButtonId(idPassedToContainer: string | null | undefined): string | null {
		return idPassedToContainer ? idPassedToContainer.replace(CONTAINER_POST_FIX, '') : null;
	}

	writeValue(value: boolean): void {
		this.checked.set(Boolean(value));
	}

	registerOnChange(fn: ChangeFn<boolean>): void {
		this._onChange = fn;
	}

	registerOnTouched(fn: TouchFn): void {
		this._onTouched = fn;
	}

	/** Implemented as a part of ControlValueAccessor. */
	setDisabledState(isDisabled: boolean): void {
		this.state().disabled.set(isDisabled);
		this._cdr.markForCheck();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/README.md
```
# @spartan-ng/brain/command

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/command`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { BrnCommandEmptyDirective } from './lib/brn-command-empty.directive';
import { BrnCommandGroupDirective } from './lib/brn-command-group.directive';
import { BrnCommandItemDirective } from './lib/brn-command-item.directive';
import { BrnCommandListDirective } from './lib/brn-command-list.directive';
import { BrnCommandSearchInputDirective } from './lib/brn-command-search-input.directive';
import { BrnCommandDirective } from './lib/brn-command.directive';

export * from './lib/brn-command-empty.directive';
export * from './lib/brn-command-group.directive';
export * from './lib/brn-command-item.directive';
export * from './lib/brn-command-item.token';
export * from './lib/brn-command-list.directive';
export * from './lib/brn-command-search-input.directive';
export * from './lib/brn-command-search-input.token';
export * from './lib/brn-command.directive';
export * from './lib/brn-command.token';

export const BrnCommandImports = [
	BrnCommandEmptyDirective,
	BrnCommandGroupDirective,
	BrnCommandItemDirective,
	BrnCommandListDirective,
	BrnCommandSearchInputDirective,
	BrnCommandDirective,
] as const;

@NgModule({
	imports: [...BrnCommandImports],
	exports: [...BrnCommandImports],
})
export class BrnCommandModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command-empty.directive.ts
```typescript
import { computed, Directive, effect, inject, TemplateRef, ViewContainerRef } from '@angular/core';
import { injectBrnCommand } from './brn-command.token';

@Directive({
	standalone: true,
	selector: '[brnCommandEmpty]',
})
export class BrnCommandEmptyDirective {
	private readonly _templateRef = inject<TemplateRef<void>>(TemplateRef);
	private readonly _viewContainerRef = inject(ViewContainerRef);
	private readonly _command = injectBrnCommand();

	/** Determine if the command has any visible items */
	private readonly _visible = computed(() => this._command.items().some((item) => item.visible()));

	constructor() {
		effect(() => {
			if (this._visible()) {
				this._viewContainerRef.clear();
			} else {
				this._viewContainerRef.createEmbeddedView(this._templateRef);
			}
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command-group.directive.ts
```typescript
import { computed, contentChildren, Directive, input } from '@angular/core';
import { BrnCommandItemToken } from './brn-command-item.token';

@Directive({
	selector: '[brnCommandGroup]',
	standalone: true,
	host: {
		role: 'group',
		'[attr.data-hidden]': '!visible() ? "" : null',
		'[id]': 'id()',
	},
})
export class BrnCommandGroupDirective {
	private static _id = 0;

	/** The id of the command list */
	public readonly id = input<string>(`brn-command-group-${BrnCommandGroupDirective._id++}`);

	/** Get the items in the group */
	private readonly _items = contentChildren(BrnCommandItemToken, {
		descendants: true,
	});

	/** Determine if there are any visible items in the group */
	protected readonly visible = computed(() => this._items().some((item) => item.visible()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command-item.directive.ts
```typescript
import { Highlightable } from '@angular/cdk/a11y';
import { BooleanInput } from '@angular/cdk/coercion';
import { isPlatformBrowser } from '@angular/common';
import {
	booleanAttribute,
	computed,
	Directive,
	ElementRef,
	HostListener,
	inject,
	input,
	OnInit,
	output,
	PLATFORM_ID,
	signal,
} from '@angular/core';
import { provideBrnCommandItem } from './brn-command-item.token';
import { injectBrnCommand } from './brn-command.token';

@Directive({
	selector: 'button[brnCommandItem]',
	standalone: true,
	providers: [provideBrnCommandItem(BrnCommandItemDirective)],
	host: {
		type: 'button',
		role: 'option',
		tabIndex: '-1',
		'[id]': 'id()',
		'[attr.disabled]': '_disabled() ? true : null',
		'[attr.data-value]': 'value()',
		'[attr.data-hidden]': "!visible() ? '' : null",
		'[attr.aria-selected]': 'active()',
		'[attr.data-selected]': "active() ? '' : null",
	},
})
export class BrnCommandItemDirective implements Highlightable, OnInit {
	private static _id = 0;

	private readonly _platform = inject(PLATFORM_ID);

	private readonly _elementRef = inject<ElementRef<HTMLElement>>(ElementRef);

	/** Access the command component */
	private readonly _command = injectBrnCommand();

	/** A unique id for the item */
	public readonly id = input(`brn-command-item-${BrnCommandItemDirective._id++}`);

	/** The value this item represents. */
	public readonly value = input.required<string>();

	/** Whether the item is disabled. */
	public readonly _disabled = input<boolean, BooleanInput>(false, {
		alias: 'disabled',
		transform: booleanAttribute,
	});

	/** Expose disabled as a value - used by the Highlightable interface */
	public get disabled() {
		return this._disabled();
	}

	/** Whether the item is initialized, this is to prevent accessing the value-input before the component is initialized.
	 * The brn-command-empty directive accesses the value before the component is initialized, which causes an error.
	 */
	private readonly _initialized = signal(false);

	/** Whether the item is selected. */
	protected readonly active = signal(false);

	/** Emits when the item is selected. */
	public readonly selected = output<void>();

	/** @internal Determine if this item is visible based on the current search query */
	public readonly visible = computed(() => {
		return this._command.filter()(this.safeValue(), this._command.search());
	});

	/** @internal Get the value of the item, with check if it has been initialized to avoid errors */
	public safeValue = computed(() => {
		if (!this._initialized()) {
			return '';
		}
		return this.value();
	});

	/** @internal Get the display value */
	public getLabel(): string {
		return this.safeValue();
	}

	/** @internal */
	setActiveStyles(): void {
		this.active.set(true);

		// ensure the item is in view
		if (isPlatformBrowser(this._platform)) {
			this._elementRef.nativeElement.scrollIntoView({ block: 'nearest' });
		}
	}

	/** @internal */
	setInactiveStyles(): void {
		this.active.set(false);
	}

	@HostListener('click')
	protected onClick(): void {
		this._command.keyManager.setActiveItem(this);
		this.selected.emit();
	}

	ngOnInit(): void {
		this._initialized.set(true);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command-item.token.ts
```typescript
import { ExistingProvider, InjectionToken, Type } from '@angular/core';
import type { BrnCommandItemDirective } from './brn-command-item.directive';

export const BrnCommandItemToken = new InjectionToken<BrnCommandItemDirective>('BrnCommandItemToken');

export function provideBrnCommandItem(command: Type<BrnCommandItemDirective>): ExistingProvider {
	return { provide: BrnCommandItemToken, useExisting: command };
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command-list.directive.ts
```typescript
import { Directive, input } from '@angular/core';

@Directive({
	standalone: true,
	selector: '[brnCommandList]',
	host: {
		role: 'listbox',
		'[id]': 'id()',
	},
})
export class BrnCommandListDirective {
	private static _id = 0;

	/** The id of the command list */
	public readonly id = input<string>(`brn-command-list-${BrnCommandListDirective._id++}`);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command-search-input.directive.ts
```typescript
import { computed, Directive, effect, ElementRef, Inject, input, Optional, Renderer2, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { COMPOSITION_BUFFER_MODE, DefaultValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { startWith } from 'rxjs/operators';
import { provideBrnCommandSearchInput } from './brn-command-search-input.token';
import { injectBrnCommand } from './brn-command.token';

@Directive({
	selector: 'input[brnCommandSearchInput]',
	standalone: true,
	providers: [
		provideBrnCommandSearchInput(BrnCommandSearchInputDirective),
		{
			provide: NG_VALUE_ACCESSOR,
			useExisting: BrnCommandSearchInputDirective,
			multi: true,
		},
	],
	host: {
		role: 'combobox',
		'aria-autocomplete': 'list',
		'[attr.aria-activedescendant]': '_activeDescendant()',
		'(keydown)': 'onKeyDown($event)',
		'(input)': 'onInput()',
	},
})
export class BrnCommandSearchInputDirective extends DefaultValueAccessor {
	private readonly _command = injectBrnCommand();

	/** The initial value of the search input */
	public readonly value = input<string>('');

	/** @internal The mutable value of the search input */
	public readonly mutableValue = computed(() => signal(this.value()));

	/** @internal The "real" value of the search input */
	public readonly valueState = computed(() => this.mutableValue()());

	/** The id of the active option */
	protected readonly _activeDescendant = signal<string | undefined>(undefined);

	constructor(
		renderer: Renderer2,
		private readonly elementRef: ElementRef,
		@Optional() @Inject(COMPOSITION_BUFFER_MODE) compositionMode: boolean,
	) {
		super(renderer, elementRef, compositionMode);
		this._command.keyManager.change
			.pipe(startWith(this._command.keyManager.activeItemIndex), takeUntilDestroyed())
			.subscribe(() => this._activeDescendant.set(this._command.keyManager.activeItem?.id()));
		effect(() => {
			this.elementRef.nativeElement.value = this.valueState();
		});
	}
	/** Listen for changes to the input value */
	protected onInput(): void {
		this.mutableValue().set(this.elementRef.nativeElement.value);
	}

	/** Listen for keydown events */
	protected onKeyDown(event: KeyboardEvent): void {
		this._command.keyManager.onKeydown(event);
	}

	/** CONROL VALUE ACCESSOR */
	override writeValue(value: string | null): void {
		super.writeValue(value);
		if (value) {
			this.mutableValue().set(value);
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command-search-input.token.ts
```typescript
import { ExistingProvider, InjectionToken, Type } from '@angular/core';
import type { BrnCommandSearchInputDirective } from './brn-command-search-input.directive';

export const BrnCommandSearchInputToken = new InjectionToken<BrnCommandSearchInputDirective>(
	'BrnCommandSearchInputToken',
);

export function provideBrnCommandSearchInput(command: Type<BrnCommandSearchInputDirective>): ExistingProvider {
	return { provide: BrnCommandSearchInputToken, useExisting: command };
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command.directive.ts
```typescript
import { ActiveDescendantKeyManager } from '@angular/cdk/a11y';
import { isPlatformBrowser } from '@angular/common';
import {
	AfterViewInit,
	computed,
	contentChild,
	contentChildren,
	Directive,
	effect,
	HostListener,
	inject,
	Injector,
	input,
	output,
	PLATFORM_ID,
	untracked,
} from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { BrnCommandItemToken } from './brn-command-item.token';
import { BrnCommandSearchInputDirective } from './brn-command-search-input.directive';
import { provideBrnCommand } from './brn-command.token';

@Directive({
	selector: '[brnCommand]',
	standalone: true,
	providers: [provideBrnCommand(BrnCommandDirective)],
	host: {
		'[id]': 'id()',
	},
})
export class BrnCommandDirective implements AfterViewInit {
	private static _id = 0;

	private readonly _platform = inject(PLATFORM_ID);

	private readonly _injector = inject(Injector);

	/** The id of the command */
	public readonly id = input<string>(`brn-command-${BrnCommandDirective._id++}`);

	/** The default filter function */
	private readonly _defaultFilter = (value: string, search: string) =>
		value.toLowerCase().includes(search.toLowerCase());

	/** A custom filter function to use when searching. */
	public readonly filter = input<CommandFilter>(this._defaultFilter);

	/** when the selection has changed */
	public readonly valueChange = output<string>();

	/** @internal The search query */
	public readonly search = computed(() => this._searchInput()?.valueState() ?? '');

	/** Access the search input if present */
	private readonly _searchInput = contentChild(BrnCommandSearchInputDirective, {
		descendants: true,
	});

	/** @internal Access all the items within the commmand */
	public readonly items = contentChildren(BrnCommandItemToken, {
		descendants: true,
	});

	/** @internal The key manager for managing active descendant */
	public readonly keyManager = new ActiveDescendantKeyManager(this.items, this._injector);

	constructor() {
		this.keyManager
			.withVerticalOrientation()
			.withHomeAndEnd()
			.withWrap()
			.skipPredicate((item) => item.disabled || !item.visible());

		// When clearing the search input we also want to reset the active item to the first one
		effect(() => {
			const searchInput = this.search();
			untracked(() => {
				const activeItemIsVisible = this.keyManager.activeItem?.visible();
				if ((searchInput !== undefined && searchInput.length === 0) || !activeItemIsVisible) {
					this.keyManager.setFirstItemActive();
				}
			});
		});

		this.keyManager.change.pipe(takeUntilDestroyed()).subscribe(() => {
			const value = this.keyManager.activeItem?.safeValue();
			if (value) {
				this.valueChange.emit(value);
			}
		});
	}

	ngAfterViewInit(): void {
		if (isPlatformBrowser(this._platform) && this.items().length) {
			this.keyManager.setActiveItem(0);
		}
	}

	@HostListener('keydown.enter')
	protected selectActiveItem(): void {
		this.keyManager.activeItem?.selected.emit();
	}
}

export type CommandFilter = (value: string, search: string) => boolean;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/command/src/lib/brn-command.token.ts
```typescript
import { ExistingProvider, inject, InjectionToken, Type } from '@angular/core';
import type { BrnCommandDirective } from './brn-command.directive';

export const BrnCommandToken = new InjectionToken<BrnCommandDirective>('BrnCommandToken');

export function provideBrnCommand(command: Type<BrnCommandDirective>): ExistingProvider {
	return { provide: BrnCommandToken, useExisting: command };
}

export function injectBrnCommand(): BrnCommandDirective {
	return inject(BrnCommandToken);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/radio-group/README.md
```
# @spartan-ng/brain/radio-group

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/radio-group`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/radio-group/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/radio-group/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnRadioGroupDirective } from './lib/brn-radio-group.directive';
import { BrnRadioComponent } from './lib/brn-radio.component';

export * from './lib/brn-radio-group.directive';
export * from './lib/brn-radio.component';

export const BrnRadioGroupImports = [BrnRadioGroupDirective, BrnRadioComponent] as const;

@NgModule({
	imports: [...BrnRadioGroupImports],
	exports: [...BrnRadioGroupImports],
})
export class BrnRadioGroupModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/radio-group/src/lib/brn-radio-group.directive.ts
```typescript
/* eslint-disable @typescript-eslint/no-empty-function */
import { BooleanInput } from '@angular/cdk/coercion';
import {
	booleanAttribute,
	contentChildren,
	Directive,
	forwardRef,
	input,
	linkedSignal,
	model,
	output,
} from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { ChangeFn, TouchFn } from '@spartan-ng/brain/forms';
import { provideBrnRadioGroupToken } from './brn-radio-group.token';
import { BrnRadioChange, BrnRadioComponent } from './brn-radio.component';

export const BRN_RADIO_GROUP_CONTROL_VALUE_ACCESSOR = {
	provide: NG_VALUE_ACCESSOR,
	useExisting: forwardRef(() => BrnRadioGroupDirective),
	multi: true,
};

@Directive({
	selector: '[brnRadioGroup]',
	standalone: true,
	providers: [BRN_RADIO_GROUP_CONTROL_VALUE_ACCESSOR, provideBrnRadioGroupToken(BrnRadioGroupDirective)],
	host: {
		role: 'radiogroup',
		'[dir]': 'direction()',
		'(focusout)': 'onTouched()',
	},
})
export class BrnRadioGroupDirective<T = unknown> implements ControlValueAccessor {
	private static _nextUniqueId = 0;

	protected onChange: ChangeFn<T> = () => {};

	protected onTouched: TouchFn = () => {};

	public readonly name = input(`brn-radio-group-${BrnRadioGroupDirective._nextUniqueId++}`);

	/**
	 * The value of the selected radio button.
	 */
	public readonly value = model<T>();

	/**
	 * Whether the radio group is disabled.
	 */
	public disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/**
	 * Whether the radio group should be required.
	 */
	public readonly required = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/**
	 * The direction of the radio group.
	 */
	public readonly direction = input<'ltr' | 'rtl' | null>('ltr');

	/**
	 * Event emitted when the group value changes.
	 */
	public readonly change = output<BrnRadioChange<T>>();

	/**
	 * The internal disabled state of the radio group. This could be switched to a linkedSignal when we can drop v18 support.
	 * @internal
	 */
	public readonly disabledState = linkedSignal(() => this.disabled());

	/**
	 * Access the radio buttons within the group.
	 * @internal
	 */
	public readonly radioButtons = contentChildren(BrnRadioComponent, { descendants: true });

	writeValue(value: T): void {
		this.value.set(value);
	}

	registerOnChange(fn: ChangeFn<T>): void {
		this.onChange = fn;
	}

	registerOnTouched(fn: TouchFn): void {
		this.onTouched = fn;
	}

	setDisabledState(isDisabled: boolean): void {
		this.disabledState.set(isDisabled);
	}

	/**
	 * Select a radio button.
	 * @internal
	 */
	select(radioButton: BrnRadioComponent<T>, value: T): void {
		if (this.value() === value) {
			return;
		}

		this.value.set(value);
		this.onChange(value);
		this.change.emit(new BrnRadioChange<T>(radioButton, value));
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/radio-group/src/lib/brn-radio-group.token.ts
```typescript
import { ExistingProvider, inject, InjectionToken, Type } from '@angular/core';
import type { BrnRadioGroupDirective } from './brn-radio-group.directive';

const BrnRadioGroupToken = new InjectionToken<BrnRadioGroupDirective<unknown>>('BrnRadioGroupToken');

export function provideBrnRadioGroupToken<T>(directive: Type<BrnRadioGroupDirective<T>>): ExistingProvider {
	return { provide: BrnRadioGroupToken, useExisting: directive };
}

export function injectBrnRadioGroup<T = unknown>(): BrnRadioGroupDirective<T> {
	return inject(BrnRadioGroupToken) as BrnRadioGroupDirective<T>;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/radio-group/src/lib/brn-radio.component.spec.ts
```typescript
import { FormControl, FormGroup, ReactiveFormsModule } from '@angular/forms';
import { render } from '@testing-library/angular';
import { BrnRadioGroupModule } from '../index';

describe('BrnRadioComponent', () => {
	it('should disable the radio button when disabled is true (reactive forms)', async () => {
		const form = new FormGroup({
			radioGroup: new FormControl('16.1.4'),
		});

		form.disable();

		const { getAllByRole } = await render(
			`
			<form [formGroup]="form">

      <div brnRadioGroup formControlName="radioGroup">
        <brn-radio value="16.1.4">16.1.4</brn-radio>
        <brn-radio value="16.0.0">16.0.0</brn-radio>
        <brn-radio value="15.3.0">15.3.0</brn-radio>
      </div>
    </form>
			`,
			{
				imports: [ReactiveFormsModule, BrnRadioGroupModule],
				componentProperties: {
					form,
				},
			},
		);

		const radioButtons = getAllByRole('radio');
		radioButtons.forEach((button) => expect(button).toBeDisabled());
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/radio-group/src/lib/brn-radio.component.ts
```typescript
import { FocusMonitor } from '@angular/cdk/a11y';
import { BooleanInput } from '@angular/cdk/coercion';
import {
	ChangeDetectionStrategy,
	Component,
	ElementRef,
	type OnDestroy,
	ViewEncapsulation,
	booleanAttribute,
	computed,
	inject,
	input,
	output,
	viewChild,
} from '@angular/core';
import { injectBrnRadioGroup } from './brn-radio-group.token';

export class BrnRadioChange<T> {
	constructor(
		public source: BrnRadioComponent<T>,
		public value: T,
	) {}
}

@Component({
	selector: 'brn-radio',
	standalone: true,
	host: {
		class: 'brn-radio',
		'[attr.id]': 'hostId()',
		'[class.brn-radio-checked]': 'checked()',
		'[class.brn-radio-disabled]': 'disabledState()',
		'[attr.data-checked]': 'checked()',
		'[attr.data-disabled]': 'disabledState()',
		'[attr.data-value]': 'value()',
		// Needs to be removed since it causes some a11y issues (see #21266).
		'[attr.tabindex]': 'null',
		'[attr.aria-label]': 'null',
		'[attr.aria-labelledby]': 'null',
		'[attr.aria-describedby]': 'null',
		// Note: under normal conditions focus shouldn't land on this element, however it may be
		// programmatically set, for example inside of a focus trap, in this case we want to forward
		// the focus to the native element.
		'(focus)': 'inputElement().nativeElement.focus()',
	},
	exportAs: 'brnRadio',
	encapsulation: ViewEncapsulation.None,
	changeDetection: ChangeDetectionStrategy.OnPush,
	template: `
		<div
			data-slot="indicator"
			style="display: flex; height: fit-content; width: fit-content"
			(click)="onTouchTargetClick($event)"
		>
			<ng-content select="[target],[indicator]" />
		</div>
		<input
			#input
			style="position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0, 0, 0, 0); white-space: nowrap; border-width: 0;"
			type="radio"
			[id]="inputId()"
			[checked]="checked()"
			[disabled]="disabledState()"
			[tabIndex]="tabIndex()"
			[attr.name]="radioGroup.name()"
			[attr.value]="value()"
			[required]="required()"
			[attr.aria-label]="ariaLabel()"
			[attr.aria-labelledby]="ariaLabelledby()"
			[attr.aria-describedby]="ariaDescribedby()"
			(change)="onInputInteraction($event)"
			(click)="onInputClick($event)"
		/>
		<label [for]="inputId()" data-slot="label">
			<ng-content />
		</label>
	`,
})
export class BrnRadioComponent<T = unknown> implements OnDestroy {
	private static _nextUniqueId = 0;
	private readonly _focusMonitor = inject(FocusMonitor);
	private readonly _elementRef = inject(ElementRef);
	protected readonly radioGroup = injectBrnRadioGroup<T>();

	/**
	 * Whether the radio button is disabled.
	 */
	public readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

	/**
	 * Whether the radio button is disabled or the radio group is disabled.
	 */
	protected readonly disabledState = computed(() => this.disabled() || this.radioGroup.disabledState());

	/**
	 * Whether the radio button is checked.
	 */
	protected readonly checked = computed(() => this.radioGroup.value() === this.value());

	protected readonly tabIndex = computed(() => {
		const disabled = this.disabledState();
		const checked = this.checked();
		const hasSelectedRadio = this.radioGroup.value() !== undefined;
		const isFirstRadio = this.radioGroup.radioButtons()[0] === this;

		if (disabled || (!checked && (hasSelectedRadio || !isFirstRadio))) {
			return -1;
		}
		return 0;
	});

	/**
	 * The unique ID for the radio button input. If none is supplied, it will be auto-generated.
	 */
	public readonly id = input<string | undefined>(undefined);

	public readonly ariaLabel = input<string | undefined>(undefined, { alias: 'aria-label' });

	public readonly ariaLabelledby = input<string | undefined>(undefined, { alias: 'aria-labelledby' });

	public readonly ariaDescribedby = input<string | undefined>(undefined, { alias: 'aria-describedby' });

	/**
	 * The value this radio button represents.
	 */
	public readonly value = input.required<T>();

	/**
	 * Whether the radio button is required.
	 */
	public readonly required = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/**
	 * Event emitted when the checked state of this radio button changes.
	 */
	public readonly change = output<BrnRadioChange<T>>();

	protected readonly hostId = computed(() =>
		this.id() ? this.id() : `brn-radio-${++BrnRadioComponent._nextUniqueId}`,
	);

	protected readonly inputId = computed(() => `${this.hostId()}-input`);

	protected readonly inputElement = viewChild.required<ElementRef<HTMLInputElement>>('input');

	constructor() {
		this._focusMonitor.monitor(this._elementRef, true);
	}

	ngOnDestroy(): void {
		this._focusMonitor.stopMonitoring(this._elementRef);
	}

	/** Dispatch change event with current value. */
	private emitChangeEvent(): void {
		this.change.emit(new BrnRadioChange(this, this.value()));
	}

	protected onInputClick(event: Event): void {
		// We have to stop propagation for click events on the visual hidden input element.
		// By default, when a user clicks on a label element, a generated click event will be
		// dispatched on the associated input element. Since we are using a label element as our
		// root container, the click event on the `radio-button` will be executed twice.
		// The real click event will bubble up, and the generated click event also tries to bubble up.
		// This will lead to multiple click events.
		// Preventing bubbling for the second event will solve that issue.
		event.stopPropagation();
	}

	protected onInputInteraction(event: Event): void {
		// We always have to stop propagation on the change event.
		// Otherwise the change event, from the input element, will bubble up and
		// emit its event object to the `change` output.
		event.stopPropagation();

		if (!this.checked() && !this.disabledState()) {
			this.emitChangeEvent();
			this.radioGroup.select(this, this.value());
		}
	}

	/** Triggered when the user clicks on the touch target. */
	protected onTouchTargetClick(event: Event): void {
		this.onInputInteraction(event);

		if (!this.disabledState()) {
			// Normally the input should be focused already, but if the click
			// comes from the touch target, then we might have to focus it ourselves.
			this.inputElement().nativeElement.focus();
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/README.md
```
# @spartan-ng/brain/select

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/select`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import {
	BrnSelectContentComponent,
	BrnSelectScrollDownDirective,
	BrnSelectScrollUpDirective,
} from './lib/brn-select-content.component';
import { BrnSelectGroupDirective } from './lib/brn-select-group.directive';
import { BrnSelectLabelDirective } from './lib/brn-select-label.directive';
import { BrnSelectOptionDirective } from './lib/brn-select-option.directive';
import { BrnSelectPlaceholderDirective } from './lib/brn-select-placeholder.directive';
import { BrnSelectTriggerDirective } from './lib/brn-select-trigger.directive';
import { BrnSelectValueComponent } from './lib/brn-select-value.component';
import { BrnSelectValueDirective } from './lib/brn-select-value.directive';
import { BrnSelectComponent } from './lib/brn-select.component';
export * from './lib/brn-select-content.component';
export * from './lib/brn-select-group.directive';
export * from './lib/brn-select-label.directive';
export * from './lib/brn-select-option.directive';
export * from './lib/brn-select-placeholder.directive';
export * from './lib/brn-select-trigger.directive';
export * from './lib/brn-select-value.component';
export * from './lib/brn-select-value.directive';
export * from './lib/brn-select.component';

export const BrnSelectImports = [
	BrnSelectComponent,
	BrnSelectContentComponent,
	BrnSelectTriggerDirective,
	BrnSelectOptionDirective,
	BrnSelectValueComponent,
	BrnSelectScrollDownDirective,
	BrnSelectScrollUpDirective,
	BrnSelectGroupDirective,
	BrnSelectLabelDirective,
	BrnSelectValueDirective,
	BrnSelectPlaceholderDirective,
] as const;

@NgModule({
	imports: [...BrnSelectImports],
	exports: [...BrnSelectImports],
})
export class BrnSelectModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/brn-select-content.component.ts
```typescript
import { NgTemplateOutlet } from '@angular/common';
import {
	AfterContentInit,
	ChangeDetectionStrategy,
	Component,
	DestroyRef,
	ElementRef,
	Injector,
	afterNextRender,
	contentChild,
	contentChildren,
	effect,
	inject,
	signal,
	untracked,
	viewChild,
} from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { BrnSelectOptionDirective } from './brn-select-option.directive';

import { ActiveDescendantKeyManager } from '@angular/cdk/a11y';
import { Directive } from '@angular/core';
import { Subject, fromEvent, interval } from 'rxjs';
import { takeUntil } from 'rxjs/operators';
import { provideBrnSelectContent } from './brn-select-content.token';
import { injectBrnSelect } from './brn-select.token';

const SCROLLBY_PIXELS = 100;

@Directive({
	selector: '[brnSelectScrollUp], brn-select-scroll-up, hlm-select-scroll-up:not(noHlm)',
	standalone: true,
	host: {
		'aria-hidden': 'true',
		'(mouseenter)': 'startEmittingEvents()',
	},
})
export class BrnSelectScrollUpDirective {
	private readonly _el = inject(ElementRef);
	private readonly _selectContent = inject(BrnSelectContentComponent);

	private readonly _endReached = new Subject<boolean>();
	private readonly _destroyRef = inject(DestroyRef);

	public startEmittingEvents(): void {
		const mouseLeave$ = fromEvent(this._el.nativeElement, 'mouseleave');

		interval(100)
			.pipe(takeUntil(mouseLeave$), takeUntil(this._endReached), takeUntilDestroyed(this._destroyRef))
			.subscribe(() => this._selectContent.moveFocusUp());
	}

	public stopEmittingEvents(): void {
		this._endReached.next(true);
	}
}

@Directive({
	selector: '[brnSelectScrollDown], brn-select-scroll-down, hlm-select-scroll-down:not(noHlm)',
	standalone: true,
	host: {
		'aria-hidden': 'true',
		'(mouseenter)': 'startEmittingEvents()',
	},
})
export class BrnSelectScrollDownDirective {
	private readonly _el = inject(ElementRef);
	private readonly _selectContent = inject(BrnSelectContentComponent);

	private readonly _endReached = new Subject<boolean>();
	private readonly _destroyRef = inject(DestroyRef);

	public startEmittingEvents(): void {
		const mouseLeave$ = fromEvent(this._el.nativeElement, 'mouseleave');

		interval(100)
			.pipe(takeUntil(mouseLeave$), takeUntil(this._endReached), takeUntilDestroyed(this._destroyRef))
			.subscribe(() => this._selectContent.moveFocusDown());
	}

	public stopEmittingEvents(): void {
		this._endReached.next(true);
	}
}

@Component({
	selector: 'brn-select-content, hlm-select-content:not(noHlm)',
	imports: [NgTemplateOutlet],
	providers: [provideBrnSelectContent(BrnSelectContentComponent)],
	changeDetection: ChangeDetectionStrategy.OnPush,
	host: {
		role: 'listbox',
		tabindex: '0',
		'[attr.aria-multiselectable]': '_select.multiple()',
		'[attr.aria-disabled]': '_select.disabled() || _select._formDisabled()',
		'aria-orientation': 'vertical',
		'[attr.aria-activedescendant]': 'keyManager?.activeItem?.id()',
		'[attr.aria-labelledBy]': '_select.labelId()',
		'[attr.aria-controlledBy]': "_select.id() +'--trigger'",
		'[id]': "_select.id() + '--content'",
		'[attr.dir]': '_select.dir()',
		'(keydown)': 'keyManager?.onKeydown($event)',
		'(keydown.enter)': 'selectActiveItem($event)',
		'(keydown.space)': 'selectActiveItem($event)',
	},
	styles: [
		`
			:host {
				display: flex;
				box-sizing: border-box;
				flex-direction: column;
				outline: none;
				pointer-events: auto;
			}

			[data-brn-select-viewport] {
				scrollbar-width: none;
				-ms-overflow-style: none;
				-webkit-overflow-scrolling: touch;
			}

			[data-brn-select-viewport]::-webkit-scrollbar {
				display: none;
			}
		`,
	],
	template: `
		<ng-template #scrollUp>
			<ng-content select="hlm-select-scroll-up" />
			<ng-content select="brnSelectScrollUp" />
		</ng-template>
		<ng-container *ngTemplateOutlet="canScrollUp() && scrollUpBtn() ? scrollUp : null" />
		<div
			data-brn-select-viewport
			#viewport
			(scroll)="handleScroll()"
			style="flex: 1 1 0%;
			position: relative;
			width:100%;
			overflow:auto;
			min-height: 36px;
      padding-bottom: 2px;
      margin-bottom: -2px;"
		>
			<ng-content />
		</div>
		<ng-template #scrollDown>
			<ng-content select="brnSelectScrollDown" />
			<ng-content select="hlm-select-scroll-down" />
		</ng-template>
		<ng-container *ngTemplateOutlet="canScrollDown() && scrollDownBtn() ? scrollDown : null" />
	`,
})
export class BrnSelectContentComponent<T> implements AfterContentInit {
	private readonly _elementRef: ElementRef<HTMLElement> = inject(ElementRef);
	private readonly _injector = inject(Injector);
	protected readonly _select = injectBrnSelect<T>();
	protected readonly canScrollUp = signal(false);
	protected readonly canScrollDown = signal(false);
	protected readonly viewport = viewChild.required<ElementRef<HTMLElement>>('viewport');
	protected readonly scrollUpBtn = contentChild(BrnSelectScrollUpDirective);
	protected readonly scrollDownBtn = contentChild(BrnSelectScrollDownDirective);
	private readonly _options = contentChildren(BrnSelectOptionDirective, { descendants: true });

	/** @internal */
	public keyManager: ActiveDescendantKeyManager<BrnSelectOptionDirective<T>> | null = null;

	constructor() {
		effect(() => {
			this._select.open() && afterNextRender(() => this.updateArrowDisplay(), { injector: this._injector });
		});
	}

	ngAfterContentInit(): void {
		this.keyManager = new ActiveDescendantKeyManager(this._options, this._injector)
			.withHomeAndEnd()
			.withVerticalOrientation()
			.withTypeAhead()
			.withAllowedModifierKeys(['shiftKey'])
			.withWrap()
			.skipPredicate((option) => option._disabled());

		effect(
			() => {
				// any time the select is opened, we need to focus the first selected option or the first option
				const open = this._select.open();
				const options = this._options();

				if (!open || !options.length) {
					return;
				}

				untracked(() => {
					const selectedOption = options.find((option) => option.selected());

					if (selectedOption) {
						this.keyManager?.setActiveItem(selectedOption);
					} else {
						this.keyManager?.setFirstItemActive();
					}
				});
			},
			{ injector: this._injector },
		);
	}

	public updateArrowDisplay(): void {
		const { scrollTop, scrollHeight, clientHeight } = this.viewport().nativeElement;
		this.canScrollUp.set(scrollTop > 0);
		const maxScroll = scrollHeight - clientHeight;
		this.canScrollDown.set(Math.ceil(scrollTop) < maxScroll);
	}

	public handleScroll(): void {
		this.updateArrowDisplay();
	}

	public focusList(): void {
		this._elementRef.nativeElement.focus();
	}

	public moveFocusUp(): void {
		this.viewport().nativeElement.scrollBy({ top: -SCROLLBY_PIXELS, behavior: 'smooth' });
		if (this.viewport().nativeElement.scrollTop === 0) {
			this.scrollUpBtn()?.stopEmittingEvents();
		}
	}

	public moveFocusDown(): void {
		this.viewport().nativeElement.scrollBy({ top: SCROLLBY_PIXELS, behavior: 'smooth' });
		const viewportSize = this._elementRef.nativeElement.scrollHeight;
		const viewportScrollPosition = this.viewport().nativeElement.scrollTop;
		if (
			viewportSize + viewportScrollPosition + SCROLLBY_PIXELS >
			this.viewport().nativeElement.scrollHeight + SCROLLBY_PIXELS / 2
		) {
			this.scrollDownBtn()?.stopEmittingEvents();
		}
	}

	setActiveOption(option: BrnSelectOptionDirective<T>): void {
		const index = this._options().findIndex((o) => o === option);

		if (index === -1) {
			return;
		}

		this.keyManager?.setActiveItem(index);
	}

	protected selectActiveItem(event: KeyboardEvent): void {
		event.preventDefault();

		const activeOption = this.keyManager?.activeItem;

		if (activeOption) {
			this._select.selectOption(activeOption.value()!);
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/brn-select-content.token.ts
```typescript
import { ExistingProvider, inject, InjectionToken, Type } from '@angular/core';
import type { BrnSelectContentComponent } from './brn-select-content.component';

const BrnSelectContentToken = new InjectionToken<BrnSelectContentComponent<unknown>>('BrnSelectContentToken');

export function injectBrnSelectContent<T>(): BrnSelectContentComponent<T> {
	return inject(BrnSelectContentToken) as BrnSelectContentComponent<T>;
}

export function provideBrnSelectContent(select: Type<BrnSelectContentComponent<unknown>>): ExistingProvider {
	return { provide: BrnSelectContentToken, useExisting: select };
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/brn-select-group.directive.ts
```typescript
import { Directive, signal } from '@angular/core';

@Directive({
	selector: '[brnSelectGroup]',
	standalone: true,
	host: {
		role: 'group',
		'[attr.aria-labelledby]': 'labelledBy()',
	},
})
export class BrnSelectGroupDirective {
	public readonly labelledBy = signal('');
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/brn-select-label.directive.ts
```typescript
import { Directive, inject } from '@angular/core';
import { BrnLabelDirective } from '@spartan-ng/brain/label';
import { BrnSelectGroupDirective } from './brn-select-group.directive';

@Directive({
	selector: '[brnSelectLabel]',
	hostDirectives: [BrnLabelDirective],
	standalone: true,
})
export class BrnSelectLabelDirective {
	private readonly _group = inject(BrnSelectGroupDirective, { optional: true });
	private readonly _label = inject(BrnLabelDirective, { host: true });

	constructor() {
		this._group?.labelledBy.set(this._label.id());
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/brn-select-option.directive.ts
```typescript
import type { Highlightable } from '@angular/cdk/a11y';
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, computed, Directive, ElementRef, inject, input, signal } from '@angular/core';
import { injectBrnSelectContent } from './brn-select-content.token';
import { injectBrnSelect } from './brn-select.token';

let nextId = 0;

@Directive({
	selector: '[brnOption]',
	standalone: true,
	host: {
		role: 'option',
		'[id]': 'id()',
		'[attr.aria-selected]': 'selected()',
		'[attr.aria-disabled]': '_disabled()',
		'(click)': 'select()',
		'[attr.dir]': '_select.dir()',
		'[attr.data-active]': "_active() ? '' : undefined",
		'[attr.data-disabled]': "_disabled() ? '' : undefined",
		'(mouseenter)': 'activate()',
	},
})
export class BrnSelectOptionDirective<T> implements Highlightable {
	protected readonly _select = injectBrnSelect();
	protected readonly _content = injectBrnSelectContent<T>();
	public readonly elementRef = inject(ElementRef);
	public readonly id = input(`brn-option-${nextId++}`);
	public readonly value = input<T>();

	// we use "_disabled" here because disabled is already defined in the Highlightable interface
	public readonly _disabled = input<boolean, BooleanInput>(false, {
		alias: 'disabled',
		transform: booleanAttribute,
	});

	public get disabled(): boolean {
		return this._disabled();
	}

	public readonly selected = computed(() => this.value() !== undefined && this._select.isSelected(this.value()));
	protected readonly _active = signal(false);
	public readonly checkedState = computed(() => (this.selected() ? 'checked' : 'unchecked'));
	public readonly dir = this._select.dir;

	public select(): void {
		if (this._disabled()) {
			return;
		}

		if (this._select.multiple()) {
			this._select.toggleSelect(this.value());
			return;
		}

		this._select.selectOption(this.value());
	}

	/** Get the label for this element which is required by the FocusableOption interface. */
	getLabel(): string {
		return this.elementRef.nativeElement.textContent?.trim() ?? '';
	}

	setActiveStyles(): void {
		this._active.set(true);

		// scroll the option into view if it is not visible
		this.elementRef.nativeElement.scrollIntoView({ block: 'nearest' });
	}

	setInactiveStyles(): void {
		this._active.set(false);
	}

	protected activate(): void {
		if (this._disabled()) {
			return;
		}
		this._content.setActiveOption(this);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/brn-select-placeholder.directive.ts
```typescript
import { Directive, inject, TemplateRef } from '@angular/core';

@Directive({
	standalone: true,
	selector: '[brnSelectPlaceholder], [hlmSelectPlaceholder]',
})
export class BrnSelectPlaceholderDirective {
	/** @internale */
	public readonly templateRef = inject<TemplateRef<void>>(TemplateRef);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/brn-select-trigger.directive.ts
```typescript
import { isPlatformBrowser } from '@angular/common';
import { type AfterViewInit, Directive, ElementRef, OnDestroy, PLATFORM_ID, computed, inject } from '@angular/core';
import { NgControl } from '@angular/forms';
import { injectBrnSelect } from './brn-select.token';

@Directive({
	selector: '[brnSelectTrigger]',
	standalone: true,
	host: {
		type: 'button',
		role: 'combobox',
		'[attr.id]': '_triggerId()',
		'[disabled]': '_disabled()',
		'[attr.aria-expanded]': '_select.open()',
		'[attr.aria-controls]': '_contentId()',
		'[attr.aria-labelledBy]': '_labelledBy()',
		'aria-autocomplete': 'none',
		'[attr.dir]': '_select.dir()',
		'[class.ng-invalid]': '_ngControl?.invalid || null',
		'[class.ng-dirty]': '_ngControl?.dirty || null',
		'[class.ng-valid]': '_ngControl?.valid || null',
		'[class.ng-touched]': '_ngControl?.touched || null',
		'[class.ng-untouched]': '_ngControl?.untouched || null',
		'[class.ng-pristine]': '_ngControl?.pristine || null',
		'(keydown.ArrowDown)': '_select.show()',
	},
})
export class BrnSelectTriggerDirective<T> implements AfterViewInit, OnDestroy {
	private readonly _elementRef = inject(ElementRef);
	protected readonly _select = injectBrnSelect<T>();
	protected readonly _ngControl = inject(NgControl, { optional: true });
	private readonly _platform = inject(PLATFORM_ID);
	protected readonly _triggerId = computed(() => `${this._select.id()}--trigger`);
	protected readonly _contentId = computed(() => `${this._select.id()}--content`);
	protected readonly _disabled = computed(() => this._select.disabled() || this._select._formDisabled());
	protected readonly _labelledBy = computed(() => {
		const value = this._select.value();

		if (Array.isArray(value) && value.length > 0) {
			return `${this._select.labelId()} ${this._select.id()}--value`;
		}
		return this._select.labelId();
	});

	private _resizeObserver?: ResizeObserver;

	constructor() {
		this._select.trigger.set(this);
	}

	ngAfterViewInit() {
		this._select.triggerWidth.set(this._elementRef.nativeElement.offsetWidth);

		// if we are on the client, listen for element resize events
		if (isPlatformBrowser(this._platform)) {
			this._resizeObserver = new ResizeObserver(() =>
				this._select.triggerWidth.set(this._elementRef.nativeElement.offsetWidth),
			);

			this._resizeObserver.observe(this._elementRef.nativeElement);
		}
	}

	ngOnDestroy(): void {
		this._resizeObserver?.disconnect();
	}

	focus(): void {
		this._elementRef.nativeElement.focus();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/brn-select-value.component.ts
```typescript
import { NgTemplateOutlet } from '@angular/common';
import { ChangeDetectionStrategy, Component, computed, contentChild, input } from '@angular/core';
import { BrnSelectPlaceholderDirective } from './brn-select-placeholder.directive';
import { BrnSelectValueDirective } from './brn-select-value.directive';
import { injectBrnSelect } from './brn-select.token';

@Component({
	selector: 'brn-select-value, hlm-select-value',
	imports: [NgTemplateOutlet],
	template: `
		@if (_showPlaceholder()) {
			<ng-container [ngTemplateOutlet]="customPlaceholderTemplate()?.templateRef ?? defaultPlaceholderTemplate" />
		} @else {
			<ng-container
				[ngTemplateOutlet]="customValueTemplate()?.templateRef ?? defaultValueTemplate"
				[ngTemplateOutletContext]="{ $implicit: _select.value() }"
			/>
		}

		<ng-template #defaultValueTemplate>{{ value() }}</ng-template>
		<ng-template #defaultPlaceholderTemplate>{{ placeholder() }}</ng-template>
	`,
	host: {
		'[id]': 'id()',
		'[attr.data-placeholder]': '_showPlaceholder() ? "" : null',
	},
	styles: [
		`
			:host {
				display: -webkit-box;
				-webkit-box-orient: vertical;
				-webkit-line-clamp: 1;
				white-space: nowrap;
				pointer-events: none;
			}
		`,
	],
	changeDetection: ChangeDetectionStrategy.OnPush,
})
export class BrnSelectValueComponent<T> {
	protected readonly _select = injectBrnSelect<T>();
	public readonly id = computed(() => `${this._select.id()}--value`);
	public readonly placeholder = computed(() => this._select.placeholder());

	protected readonly _showPlaceholder = computed(
		() => this.value() === null || this.value() === undefined || this.value() === '',
	);

	/** Allow a custom value template */
	protected readonly customValueTemplate = contentChild(BrnSelectValueDirective, { descendants: true });
	protected readonly customPlaceholderTemplate = contentChild(BrnSelectPlaceholderDirective, { descendants: true });

	protected readonly value = computed(() => {
		const value = this._values();

		if (value.length === 0) {
			return null;
		}

		// remove any selected values that are not in the options list
		const existingOptions = value.filter((val) =>
			this._select.options().some((option) => this._select.compareWith()(option.value(), val)),
		);
		const selectedOption = existingOptions.map((val) =>
			this._select.options().find((option) => this._select.compareWith()(option.value(), val)),
		);

		if (selectedOption.length === 0) {
			return null;
		}

		const selectedLabels = selectedOption.map((option) => option?.getLabel());

		if (this._select.dir() === 'rtl') {
			selectedLabels.reverse();
		}
		return this.transformFn()(selectedLabels);
	});

	/** Normalize the values as an array */
	protected readonly _values = computed(() =>
		Array.isArray(this._select.value()) ? (this._select.value() as T[]) : ([this._select.value()] as T[]),
	);

	public readonly transformFn = input<(values: (string | undefined)[]) => any>((values) => (values ?? []).join(', '));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/brn-select-value.directive.ts
```typescript
import { Directive, inject, TemplateRef } from '@angular/core';

@Directive({
	standalone: true,
	selector: '[brnSelectValue], [hlmSelectValue]',
})
export class BrnSelectValueDirective<T> {
	/** @internale */
	public readonly templateRef = inject<TemplateRef<BrnSelectValueContext<T>>>(TemplateRef);
}

export interface BrnSelectValueContext<T> {
	$implicit: T | T[];
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/brn-select.component.ts
```typescript
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import { CdkListboxModule } from '@angular/cdk/listbox';
import {
	CdkConnectedOverlay,
	type ConnectedOverlayPositionChange,
	type ConnectedPosition,
	OverlayModule,
} from '@angular/cdk/overlay';
import {
	ChangeDetectionStrategy,
	Component,
	type DoCheck,
	Injector,
	type Signal,
	afterNextRender,
	booleanAttribute,
	computed,
	contentChild,
	contentChildren,
	inject,
	input,
	model,
	numberAttribute,
	signal,
	viewChild,
} from '@angular/core';
import { takeUntilDestroyed, toObservable, toSignal } from '@angular/core/rxjs-interop';
import { type ControlValueAccessor, FormGroupDirective, NgControl, NgForm } from '@angular/forms';
import {
	type ExposesSide,
	type ExposesState,
	provideExposedSideProviderExisting,
	provideExposesStateProviderExisting,
} from '@spartan-ng/brain/core';
import { BrnFormFieldControl } from '@spartan-ng/brain/form-field';
import { ChangeFn, ErrorStateMatcher, ErrorStateTracker, TouchFn } from '@spartan-ng/brain/forms';
import { BrnLabelDirective } from '@spartan-ng/brain/label';
import { Subject, of } from 'rxjs';
import { delay, map, switchMap } from 'rxjs/operators';
import { BrnSelectContentComponent } from './brn-select-content.component';
import { BrnSelectOptionDirective } from './brn-select-option.directive';
import { BrnSelectTriggerDirective } from './brn-select-trigger.directive';
import { provideBrnSelect } from './brn-select.token';

export type BrnReadDirection = 'ltr' | 'rtl';

let nextId = 0;

@Component({
	selector: 'brn-select, hlm-select',
	imports: [OverlayModule, CdkListboxModule],
	changeDetection: ChangeDetectionStrategy.OnPush,
	providers: [
		provideExposedSideProviderExisting(() => BrnSelectComponent),
		provideExposesStateProviderExisting(() => BrnSelectComponent),
		provideBrnSelect(BrnSelectComponent),
		{
			provide: BrnFormFieldControl,
			useExisting: BrnSelectComponent,
		},
	],
	template: `
		@if (!selectLabel() && placeholder()) {
			<label class="hidden" [attr.id]="labelId()">{{ placeholder() }}</label>
		} @else {
			<ng-content select="label[hlmLabel],label[brnLabel]" />
		}

		<div cdk-overlay-origin (click)="toggle()" #trigger="cdkOverlayOrigin">
			<ng-content select="hlm-select-trigger,[brnSelectTrigger]" />
		</div>

		<ng-template
			cdk-connected-overlay
			cdkConnectedOverlayLockPosition
			cdkConnectedOverlayHasBackdrop
			cdkConnectedOverlayBackdropClass="cdk-overlay-transparent-backdrop"
			[cdkConnectedOverlayOrigin]="trigger"
			[cdkConnectedOverlayOpen]="_delayedExpanded()"
			[cdkConnectedOverlayPositions]="_positions"
			[cdkConnectedOverlayWidth]="triggerWidth() > 0 ? triggerWidth() : 'auto'"
			(backdropClick)="hide()"
			(detach)="hide()"
			(positionChange)="_positionChanges$.next($event)"
		>
			<ng-content />
		</ng-template>
	`,
})
export class BrnSelectComponent<T = unknown>
	implements ControlValueAccessor, DoCheck, ExposesSide, ExposesState, BrnFormFieldControl
{
	private readonly _defaultErrorStateMatcher = inject(ErrorStateMatcher);
	private readonly _parentForm = inject(NgForm, { optional: true });
	private readonly _injector = inject(Injector);
	private readonly _parentFormGroup = inject(FormGroupDirective, { optional: true });
	public readonly ngControl = inject(NgControl, { optional: true, self: true });

	public readonly id = input<string>(`brn-select-${nextId++}`);
	public readonly multiple = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});
	public readonly placeholder = input<string>('');
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});
	public readonly dir = input<BrnReadDirection>('ltr');
	public readonly closeDelay = input<number, NumberInput>(100, {
		transform: numberAttribute,
	});

	public readonly open = model<boolean>(false);
	public readonly value = model<T | T[]>();
	public readonly compareWith = input<(o1: T, o2: T) => boolean>((o1, o2) => o1 === o2);
	public readonly _formDisabled = signal(false);

	/** Label provided by the consumer. */
	protected readonly selectLabel = contentChild(BrnLabelDirective, { descendants: false });

	/** Overlay pane containing the options. */
	protected readonly selectContent = contentChild.required(BrnSelectContentComponent);

	/** @internal */
	public readonly options = contentChildren(BrnSelectOptionDirective, { descendants: true });

	/** @internal Derive the selected options to filter out the unselected options */
	public readonly selectedOptions = computed(() => this.options().filter((option) => option.selected()));

	/** Overlay pane containing the options. */
	protected readonly _overlayDir = viewChild.required(CdkConnectedOverlay);
	public readonly trigger = signal<BrnSelectTriggerDirective<T> | null>(null);
	public readonly triggerWidth = signal<number>(0);

	protected readonly _delayedExpanded = toSignal(
		toObservable(this.open).pipe(
			switchMap((expanded) => (!expanded ? of(expanded).pipe(delay(this.closeDelay())) : of(expanded))),
			takeUntilDestroyed(),
		),
		{ initialValue: false },
	);

	public readonly state = computed(() => (this.open() ? 'open' : 'closed'));

	protected readonly _positionChanges$ = new Subject<ConnectedOverlayPositionChange>();

	public readonly side: Signal<'top' | 'bottom' | 'left' | 'right'> = toSignal(
		this._positionChanges$.pipe(
			map<ConnectedOverlayPositionChange, 'top' | 'bottom' | 'left' | 'right'>((change) =>
				// todo: better translation or adjusting hlm to take that into account
				change.connectionPair.originY === 'center'
					? change.connectionPair.originX === 'start'
						? 'left'
						: 'right'
					: change.connectionPair.originY,
			),
		),
		{ initialValue: 'bottom' },
	);

	public readonly labelId = computed(() => this.selectLabel()?.id ?? `${this.id()}--label`);

	// eslint-disable-next-line @typescript-eslint/no-empty-function
	private _onChange: ChangeFn<T | T[]> = () => {};
	// eslint-disable-next-line @typescript-eslint/no-empty-function
	private _onTouched: TouchFn = () => {};

	/*
	 * This position config ensures that the top "start" corner of the overlay
	 * is aligned with with the top "start" of the origin by default (overlapping
	 * the trigger completely). If the panel cannot fit below the trigger, it
	 * will fall back to a position above the trigger.
	 */
	protected _positions: ConnectedPosition[] = [
		{
			originX: 'start',
			originY: 'bottom',
			overlayX: 'start',
			overlayY: 'top',
		},
		{
			originX: 'end',
			originY: 'bottom',
			overlayX: 'end',
			overlayY: 'top',
		},
		{
			originX: 'start',
			originY: 'top',
			overlayX: 'start',
			overlayY: 'bottom',
		},
		{
			originX: 'end',
			originY: 'top',
			overlayX: 'end',
			overlayY: 'bottom',
		},
	];

	public errorStateTracker: ErrorStateTracker;

	public readonly errorState = computed(() => this.errorStateTracker.errorState());

	constructor() {
		if (this.ngControl !== null) {
			this.ngControl.valueAccessor = this;
		}

		this.errorStateTracker = new ErrorStateTracker(
			this._defaultErrorStateMatcher,
			this.ngControl,
			this._parentFormGroup,
			this._parentForm,
		);
	}

	ngDoCheck() {
		this.errorStateTracker.updateErrorState();
	}

	public toggle(): void {
		if (this.open()) {
			this.hide();
		} else {
			this.show();
		}
	}

	public show(): void {
		if (this.open() || this.disabled() || this._formDisabled() || this.options()?.length == 0) {
			return;
		}

		this.open.set(true);
		afterNextRender(() => this.selectContent().focusList(), { injector: this._injector });
	}

	public hide(): void {
		if (!this.open()) return;

		this.open.set(false);
		this._onTouched();

		// restore focus to the trigger
		this.trigger()?.focus();
	}

	public writeValue(value: T): void {
		this.value.set(value);
	}

	public registerOnChange(fn: ChangeFn<T | T[]>): void {
		this._onChange = fn;
	}

	public registerOnTouched(fn: TouchFn): void {
		this._onTouched = fn;
	}

	public setDisabledState(isDisabled: boolean) {
		this._formDisabled.set(isDisabled);
	}

	selectOption(value: T): void {
		// if this is a multiple select we need to add the value to the array
		if (this.multiple()) {
			const currentValue = this.value() as T[];
			const newValue = currentValue ? [...currentValue, value] : [value];
			this.value.set(newValue);
		} else {
			this.value.set(value);
		}

		this._onChange?.(this.value() as T | T[]);

		// if this is single select close the dropdown
		if (!this.multiple()) {
			this.hide();
		}
	}

	deselectOption(value: T): void {
		if (this.multiple()) {
			const currentValue = this.value() as T[];
			this.value.set(currentValue.filter((val) => !this.compareWith()(val, value)));
		} else {
			this.value.set(null as T);
		}

		this._onChange?.(this.value() as T | T[]);
	}

	toggleSelect(value: T): void {
		if (this.isSelected(value)) {
			this.deselectOption(value);
		} else {
			this.selectOption(value);
		}
	}

	isSelected(value: T): boolean {
		const selection = this.value();

		if (Array.isArray(selection)) {
			return selection.some((val) => this.compareWith()(val, value));
		} else if (value !== undefined) {
			return this.compareWith()(selection as T, value);
		}

		return false;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/brn-select.token.ts
```typescript
import { ExistingProvider, inject, InjectionToken, Type } from '@angular/core';
import type { BrnSelectComponent } from './brn-select.component';

const BrnSelectToken = new InjectionToken<BrnSelectComponent>('BrnSelectToken');

export function injectBrnSelect<T>(): BrnSelectComponent<T> {
	return inject(BrnSelectToken) as BrnSelectComponent<T>;
}

export function provideBrnSelect(select: Type<BrnSelectComponent>): ExistingProvider {
	return { provide: BrnSelectToken, useExisting: select };
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/tests/brn-select.component.numbers.spec.ts
```typescript
import { signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import { BrnSelectImports } from '../../index';

describe('BrnSelectComponent NumberValues', () => {
	beforeAll(() => {
		global.ResizeObserver = jest.fn().mockImplementation(() => ({
			observe: jest.fn(),
			unobserve: jest.fn(),
			disconnect: jest.fn(),
		}));
		window.HTMLElement.prototype.scrollIntoView = jest.fn();
	});

	const setup = async () => {
		const selectedValue = signal(15);
		const container = await render(
			`
			 <brn-select class="inline-block" [(ngModel)]="selectedValue" [multiple]="multiple">
			   <button brnSelectTrigger class='w-56' data-testid="brn-select-trigger">
			     <brn-select-value data-testid="brn-select-value" />
			   </button>
			   <brn-select-content class="w-56" data-testid="brn-select-content">
			     <label brnSelectLabel>Numbers</label>
			     <div brnOption [value]="0">0</div>
			     <div brnOption [value]="5">5</div>
			     <div brnOption [value]="10">10</div>
			     <div brnOption [value]="15">15</div>
			     <div brnOption [value]="20">20</div>
			   </brn-select-content>
			 </brn-select>
      `,
			{
				imports: [...BrnSelectImports, FormsModule],
				componentProperties: {
					selectedValue,
					multiple: false,
				},
			},
		);
		return {
			user: userEvent.setup(),
			container,
			trigger: screen.getByTestId('brn-select-trigger'),
			selectedValue,
			value: screen.getByTestId('brn-select-value'),
		};
	};

	it('should display the correct value after render', async () => {
		const { container, user, trigger, value, selectedValue } = await setup();
		// without rerenderung
		container.detectChanges();
		expect(value.textContent?.trim()).toBe('15');

		await user.click(trigger);
		const options = await screen.getAllByRole('option');

		await user.click(options[0]);
		expect(trigger.textContent?.trim()).toBe('0');
		expect(selectedValue()).toBe(0);

		await user.click(options[1]);
		expect(selectedValue()).toBe(5);
		expect(trigger.textContent?.trim()).toBe('5');

		await user.click(options[2]);
		expect(trigger.textContent?.trim()).toBe('10');
		expect(selectedValue()).toBe(10);
	});

	it('should display the correct value after render when multiple is true', async () => {
		const { container, user, trigger, value } = await setup();
		const selectedValue = signal([15]);
		await container.rerender({
			componentProperties: {
				multiple: true,
				selectedValue,
			},
		});
		container.detectChanges();
		expect(value.textContent?.trim()).toBe('15');
		expect(selectedValue()).toEqual([15]);

		await user.click(trigger);
		const options = await screen.getAllByRole('option');

		await user.click(options[1]);
		expect(selectedValue()).toEqual([15, 5]);
		expect(trigger.textContent?.trim()).toBe('15, 5');

		await user.click(options[2]);
		expect(trigger.textContent?.trim()).toBe('15, 5, 10');
		expect(selectedValue()).toEqual([15, 5, 10]);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/tests/brn-select.component.spec.ts
```typescript
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import { BrnSelectImports } from '../../index';

describe('BrnSelectComponent', () => {
	beforeAll(() => {
		global.ResizeObserver = jest.fn().mockImplementation(() => ({
			observe: jest.fn(),
			unobserve: jest.fn(),
			disconnect: jest.fn(),
		}));
		window.HTMLElement.prototype.scrollIntoView = jest.fn();
	});

	const setup = async () => {
		const openChangeSpy = jest.fn();
		const valueChangeSpy = jest.fn();
		const container = await render(
			`
            <brn-select class="inline-block" [multiple]="multiple" (openChange)="openChange($event)" (valueChange)="valueChange($event)">
			<button brnSelectTrigger class='w-56' data-testid="brn-select-trigger">
				<brn-select-value />
			</button>
			<brn-select-content class="w-56" data-testid="brn-select-content">
				<label brnSelectLabel>Fruits</label>
				<div brnOption value="apple">Apple</div>
				<div brnOption value="banana">Banana</div>
				<div brnOption value="blueberry">Blueberry</div>
				<div brnOption value="grapes">Grapes</div>
				<div brnOption value="pineapple">Pineapple</div>
				<div brnOption value="disabled" [disabled]="true">Disabled Option</div>
		  </brn-select-content>
		</brn-select>
    `,
			{
				imports: [...BrnSelectImports],
				componentProperties: {
					multiple: true,
					openChange: openChangeSpy,
					valueChange: valueChangeSpy,
				},
			},
		);
		return {
			user: userEvent.setup(),
			container,
			trigger: screen.getByTestId('brn-select-trigger'),
			openChangeSpy,
			valueChangeSpy,
		};
	};

	describe('default', () => {
		it('openChanged should emit event on open and close', async () => {
			const { user, trigger, openChangeSpy } = await setup();
			await user.click(trigger);
			expect(openChangeSpy).toHaveBeenCalledTimes(1);
			await user.click(trigger);
			expect(openChangeSpy).toHaveBeenCalledTimes(2);
		});
		it('should add data-disabled to a disabled option', async () => {
			const { user, trigger } = await setup();
			await user.click(trigger);
			const disabledOption = await screen.getByText('Disabled Option');

			expect(disabledOption).toHaveAttribute('data-disabled');
			await user.click(disabledOption);
			expect(trigger.textContent).not.toContain('Disabled Option');
		});

		it('should add data-placeholder to the value when no value is selected', async () => {
			const { container, user, trigger } = await setup();
			const value = container.container.querySelector('brn-select-value');
			expect(value).toHaveAttribute('data-placeholder');

			await user.click(trigger);
			const options = await screen.getAllByRole('option');
			await userEvent.click(options[0]);
			expect(value).not.toHaveAttribute('data-placeholder');
		});

		it('single mode: valueChange should emit event on selection', async () => {
			const { user, trigger, container, openChangeSpy, valueChangeSpy } = await setup();
			container.rerender({
				componentProperties: {
					multiple: false,
					openChange: openChangeSpy,
					valueChange: valueChangeSpy,
				},
			});
			await user.click(trigger);
			const options = await screen.getAllByRole('option');
			await user.click(options[0]);
			expect(valueChangeSpy).toHaveBeenCalledWith('apple');
		});

		it('multi mode: valueChange should emit event on selection', async () => {
			const { user, trigger, valueChangeSpy } = await setup();
			await user.click(trigger);
			const options = await screen.getAllByRole('option');
			await user.click(options[0]);
			expect(valueChangeSpy).toHaveBeenCalledWith(['apple']);
			await user.click(options[1]);
			expect(valueChangeSpy).toHaveBeenCalledWith(['apple', 'banana']);
		});
	});

	describe('multiple option select', () => {
		it('when multiple true -> false with multiple selected values, should reset', async () => {
			const { user, trigger, container } = await setup();
			await user.click(trigger);
			const options = await screen.getAllByRole('option');
			await user.click(options[0]);
			await user.click(options[1]);
			expect(trigger.textContent).toContain(`${options[0].textContent}, ${options[1].textContent}`);
			container.rerender({
				componentProperties: {
					multiple: false,
				},
			});
			expect(trigger.textContent).toContain('');
		});

		it('when multiple true -> false with single value, should retain value', async () => {
			const { user, trigger, container } = await setup();
			await user.click(trigger);
			const options = await screen.getAllByRole('option');
			await user.click(options[0]);
			expect(trigger.textContent).toContain(`${options[0].textContent}`);
			container.rerender({
				componentProperties: {
					multiple: false,
				},
			});
			expect(trigger.textContent).toContain(`${options[0].textContent}`);
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/tests/select-multi-mode.spec.ts
```typescript
import { Validators } from '@angular/forms';
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import {
	SelectMultiValueTestComponent,
	SelectMultiValueWithInitialValueTestComponent,
	SelectMultiValueWithInitialValueWithForLoopTestComponent,
} from './select-reactive-form';
import { getFormControlStatus, getFormValidationClasses } from './utils';

describe('Brn Select Component in multi-mode', () => {
	beforeAll(() => {
		global.ResizeObserver = jest.fn().mockImplementation(() => ({
			observe: jest.fn(),
			unobserve: jest.fn(),
			disconnect: jest.fn(),
		}));
		window.HTMLElement.prototype.scrollIntoView = jest.fn();
	});

	const DEFAULT_LABEL = 'Select a Fruit';

	const setupWithFormValidationMulti = async () => {
		const { fixture } = await render(SelectMultiValueTestComponent);
		return {
			user: userEvent.setup(),
			fixture,
			trigger: screen.getByTestId('brn-select-trigger'),
			value: screen.getByTestId('brn-select-value'),
		};
	};

	const setupWithFormValidationMultiWithInitialValue = async () => {
		const { fixture } = await render(SelectMultiValueWithInitialValueTestComponent);
		return {
			user: userEvent.setup(),
			fixture,
			trigger: screen.getByTestId('brn-select-trigger'),
			value: screen.getByTestId('brn-select-value'),
		};
	};

	const setupWithFormValidationMultiWithInitialValueWithForLoop = async () => {
		const { fixture } = await render(SelectMultiValueWithInitialValueWithForLoopTestComponent);
		return {
			user: userEvent.setup(),
			fixture,
			trigger: screen.getByTestId('brn-select-trigger'),
			value: screen.getByTestId('brn-select-value'),
			updateOptionsBtn: screen.getByTestId('update-options-btn'),
			updatePartialOptionsBtn: screen.getByTestId('partial-options-btn'),
			updateDiffOptionsBtn: screen.getByTestId('diff-options-btn'),
		};
	};

	describe('form validation - multi mode', () => {
		it('should become dirty only after an actual user option selection', async () => {
			const { user, fixture, trigger } = await setupWithFormValidationMulti();
			const cmpInstance = fixture.componentInstance;

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual([]);

			// open
			await user.click(trigger);
			// close
			await user.click(trigger);

			// Patch Value
			expect(cmpInstance.form?.get('fruit')?.patchValue(['apple', 'banana', 'blueberry']));

			// validate patch value
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'banana', 'blueberry']);
			fixture.detectChanges();

			const afterValuePatchExpected = {
				untouched: false,
				touched: true,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterValuePatchExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterValuePatchExpected);
		});

		// should have correct status when initialized with no value and as optional
		it('should reflect correct form control status with no initial value', async () => {
			const { fixture, trigger, value } = await setupWithFormValidationMulti();
			const cmpInstance = fixture.componentInstance as SelectMultiValueTestComponent;

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(value.textContent?.trim()).toBe(DEFAULT_LABEL);
			expect(cmpInstance.form?.get('fruit')?.value).toEqual([]);
		});

		it('should reflect correct form control status with initial value', async () => {
			const { fixture, trigger, value } = await setupWithFormValidationMultiWithInitialValue();
			const cmpInstance = fixture.componentInstance;

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(value.textContent?.trim()).toBe('Apple, Blueberry');
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'blueberry']);
		});

		it('should reflect correct form control status and value after first user selection with no initial value', async () => {
			const { fixture, trigger, user } = await setupWithFormValidationMulti();
			const cmpInstance = fixture.componentInstance;

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual([]);

			// open select
			await user.click(trigger);

			// Make 1st selection
			const options = await screen.getAllByRole('option');
			await user.click(options[1]);

			// status prior to closing select
			const afterFirstSelectionExpected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: false,
				dirty: true,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterFirstSelectionExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterFirstSelectionExpected);

			// close select
			await user.click(trigger);

			// validate status and value
			const afterClose = {
				untouched: false,
				touched: true,
				valid: true,
				invalid: false,
				pristine: false,
				dirty: true,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterClose);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterClose);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['banana']);
		});

		it('should reflect correct form control status and value after patching value with no initial value', async () => {
			const { fixture, trigger } = await setupWithFormValidationMulti();
			const cmpInstance = fixture.componentInstance;

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual([]);

			expect(cmpInstance.form?.get('fruit')?.patchValue(['apple', 'banana', 'blueberry']));

			// validate patch value
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'banana', 'blueberry']);

			const afterValuePatchExpected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterValuePatchExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterValuePatchExpected);
		});

		it('should reflect correct form control status and value after first user selection with initial value', async () => {
			const { fixture, trigger, user } = await setupWithFormValidationMulti();
			const cmpInstance = fixture.componentInstance;

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual([]);

			// open select
			await user.click(trigger);

			// Make 1st selection
			const options = await screen.getAllByRole('option');
			await user.click(options[1]);

			// status prior to closing select
			const afterFirstSelectionExpected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: false,
				dirty: true,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterFirstSelectionExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterFirstSelectionExpected);

			// close select
			await user.click(trigger);

			// validate status and value
			const afterCloseExpected = {
				untouched: false,
				touched: true,
				valid: true,
				invalid: false,
				pristine: false,
				dirty: true,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterCloseExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterCloseExpected);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['banana']);
		});

		it('should reflect correct form control status and value after patching value with initial value', async () => {
			const { fixture, trigger } = await setupWithFormValidationMulti();
			const cmpInstance = fixture.componentInstance;

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual([]);

			expect(cmpInstance.form?.get('fruit')?.patchValue(['apple', 'banana', 'blueberry']));

			// validate patch value
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'banana', 'blueberry']);

			const afterValuePatchExpected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterValuePatchExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterValuePatchExpected);
		});

		/**
		 * Update Options
		 */
		it('should reset display but not value if options change and are completely different', async () => {
			const { fixture, trigger, updateDiffOptionsBtn, user } =
				await setupWithFormValidationMultiWithInitialValueWithForLoop();
			const cmpInstance = fixture.componentInstance;

			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'pineapple']);

			// update with
			await user.click(updateDiffOptionsBtn);

			//display should be updated
			expect(trigger).toHaveTextContent('Select a Fruit');

			// value should remain same
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'pineapple']);
		});

		it('should update display but not value if options updated and only some options are same', async () => {
			const { fixture, trigger, updatePartialOptionsBtn, user } =
				await setupWithFormValidationMultiWithInitialValueWithForLoop();
			const cmpInstance = fixture.componentInstance;

			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'pineapple']);

			// actionBtn.
			await user.click(updatePartialOptionsBtn);

			//display should be updated
			expect(trigger).toHaveTextContent('Apple');

			// expect value to remain same
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'pineapple']);
		});

		it('should maintain exact display and value if options updated but exactly same', async () => {
			const { fixture, trigger, updateOptionsBtn, user } =
				await setupWithFormValidationMultiWithInitialValueWithForLoop();
			const cmpInstance = fixture.componentInstance;

			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'pineapple']);

			// actionBtn.
			user.click(updateOptionsBtn);

			// open select
			await user.click(trigger);

			// display should be same
			expect(trigger).toHaveTextContent('Apple, Pineapple');

			// value should be same
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'pineapple']);
		});
	});

	describe('form validation - multi mode and required', () => {
		/**
		 * No Initial Value
		 */
		it('should reflect correct form control status with no initial value', async () => {
			const { fixture, trigger, value } = await setupWithFormValidationMulti();
			const cmpInstance = fixture.componentInstance;

			cmpInstance.form?.get('fruit')?.addValidators(Validators.required);
			cmpInstance.form?.get('fruit')?.updateValueAndValidity();
			fixture.detectChanges();

			const expected = {
				untouched: true,
				touched: false,
				valid: false,
				invalid: true,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(value.textContent?.trim()).toBe(DEFAULT_LABEL);
			expect(cmpInstance.form?.get('fruit')?.value).toEqual([]);
		});

		/**
		 * Initial Value
		 */
		// should initialize with correct status and initial value when required
		it('should reflect correct form control status with initial value', async () => {
			const { fixture, trigger, value } = await setupWithFormValidationMultiWithInitialValue();
			const cmpInstance = fixture.componentInstance;

			cmpInstance.form?.get('fruit')?.addValidators(Validators.required);
			cmpInstance.form?.get('fruit')?.updateValueAndValidity();
			fixture.detectChanges();

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(value.textContent?.trim()).toBe('Apple, Blueberry');
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'blueberry']);
		});

		/**
		 * User Selection with no initial value
		 */
		it('should reflect correct form control status and value after first user selection with no initial value', async () => {
			const { fixture, trigger, user } = await setupWithFormValidationMulti();
			const cmpInstance = fixture.componentInstance;

			cmpInstance.form?.get('fruit')?.addValidators(Validators.required);
			cmpInstance.form?.get('fruit')?.updateValueAndValidity();
			fixture.detectChanges();

			const expected = {
				untouched: true,
				touched: false,
				valid: false,
				invalid: true,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual([]);

			// open select
			await user.click(trigger);

			// Make 1st selection
			const options = await screen.getAllByRole('option');
			await user.click(options[1]);

			// status prior to closing select
			const afterFirstSelectioneExpected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: false,
				dirty: true,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterFirstSelectioneExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterFirstSelectioneExpected);

			// close select
			await user.click(trigger);

			// validate status and value
			const afterCloseExpected = {
				untouched: false,
				touched: true,
				valid: true,
				invalid: false,
				pristine: false,
				dirty: true,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterCloseExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterCloseExpected);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['banana']);
		});

		/**
		 * User Selection with initial value
		 */
		it('should reflect correct form control status and value after first user selection with initial value', async () => {
			const { fixture, trigger, user } = await setupWithFormValidationMultiWithInitialValue();
			const cmpInstance = fixture.componentInstance;

			cmpInstance.form?.get('fruit')?.addValidators(Validators.required);
			cmpInstance.form?.get('fruit')?.updateValueAndValidity();
			fixture.detectChanges();

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'blueberry']);

			// open select
			await user.click(trigger);

			// Make 1st selection
			const options = await screen.getAllByRole('option');
			await user.click(options[1]);

			// status prior to closing select
			const afterFirstSelectionExpected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: false,
				dirty: true,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterFirstSelectionExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterFirstSelectionExpected);

			// close select
			await user.click(trigger);

			// validate status and value
			const afterCloseExpected = {
				untouched: false,
				touched: true,
				valid: true,
				invalid: false,
				pristine: false,
				dirty: true,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterCloseExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterCloseExpected);
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'blueberry', 'banana']);
		});

		/**
		 * User Selection with initial value when options are dynamically added with a for-loop
		 */
		it('should reflect correct form control status and value after first user selection with initial value with dynamic options', async () => {
			const { fixture, trigger, value, user } = await setupWithFormValidationMultiWithInitialValueWithForLoop();
			const cmpInstance = fixture.componentInstance as SelectMultiValueWithInitialValueWithForLoopTestComponent;

			cmpInstance.form?.get('fruit')?.addValidators(Validators.required);
			cmpInstance.form?.get('fruit')?.updateValueAndValidity();
			fixture.detectChanges();

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			fixture.detectChanges();

			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'pineapple']);

			expect(value.textContent?.trim()).toBe('Apple, Pineapple');

			// open select
			await user.click(trigger);

			// Make 1st selection
			const options = await screen.getAllByRole('option');
			await user.click(options[1]);

			// status prior to closing select
			const afterFirstSelectionExpected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: false,
				dirty: true,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterFirstSelectionExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterFirstSelectionExpected);

			// close select
			await user.click(trigger);

			// validate status and value
			const afterCloseExpected = {
				untouched: false,
				touched: true,
				valid: true,
				invalid: false,
				pristine: false,
				dirty: true,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterCloseExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterCloseExpected);
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'pineapple', 'banana']);
		});

		/**
		 * Patch value with no initial value
		 */
		it('should reflect correct form control status and value after patching value with no initial value', async () => {
			const { fixture, trigger } = await setupWithFormValidationMulti();
			const cmpInstance = fixture.componentInstance;

			// Setting to be required
			cmpInstance.form?.get('fruit')?.addValidators(Validators.required);
			cmpInstance.form?.get('fruit')?.updateValueAndValidity();
			fixture.detectChanges();

			const expected = {
				untouched: true,
				touched: false,
				valid: false,
				invalid: true,
				pristine: true,
				dirty: false,
			};

			// Some issue
			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual([]);

			expect(cmpInstance.form?.get('fruit')?.patchValue(['apple', 'banana', 'blueberry']));

			// validate patch value
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'banana', 'blueberry']);
			fixture.detectChanges();

			const afterValuePatchExpected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterValuePatchExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterValuePatchExpected);
		});

		/**
		 * Patch value with initial value
		 */
		it('should reflect correct form control status and value after patching value with initial value', async () => {
			const { fixture, trigger } = await setupWithFormValidationMultiWithInitialValue();
			const cmpInstance = fixture.componentInstance;

			// Setting to be required
			cmpInstance.form?.get('fruit')?.addValidators(Validators.required);
			cmpInstance.form?.get('fruit')?.updateValueAndValidity();
			fixture.detectChanges();

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'blueberry']);

			expect(cmpInstance.form?.get('fruit')?.patchValue(['apple', 'banana', 'blueberry']));

			// validate patch value
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['apple', 'banana', 'blueberry']);

			const afterValuePatchExpected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterValuePatchExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterValuePatchExpected);
		});
	});

	describe('deselect option - multi mode', () => {
		it('should reflect correct form control status with no initial value', async () => {
			const { fixture, trigger, user } = await setupWithFormValidationMulti();
			const cmpInstance = fixture.componentInstance as SelectMultiValueTestComponent;

			expect(cmpInstance.form?.get('fruit')?.value).toEqual([]);

			// open select
			await user.click(trigger);

			const options = await screen.getAllByRole('option');
			await user.click(options[1]);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual(['banana']);
			expect(screen.getByTestId('brn-select-value').textContent?.trim()).toBe('Banana');

			await user.click(options[1]);

			expect(trigger).toHaveTextContent('Select a Fruit');
			expect(cmpInstance.form?.get('fruit')?.value).toEqual([]);
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/tests/select-ng-model-form.ts
```typescript
import { Component, signal } from '@angular/core';

@Component({
	selector: 'select-ngmodel-form',
	template: `
		<form ngForm>
			<div class="mb-3">
				<pre>Form Control Value: {{ fruit() | json }}</pre>
			</div>
			<hlm-select class="w-56" ${argsToTemplate(args, { exclude: ['initialValue'] })} [(ngModel)]="fruit" name="fruit">
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
	// eslint-disable-next-line @angular-eslint/prefer-standalone
	standalone: false,
})
export class SelectNgModelComponent {
	public fruit = signal('');
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/tests/select-reactive-form.ts
```typescript
import { ChangeDetectionStrategy, Component, OnInit, signal, viewChild } from '@angular/core';
import { FormControl, FormGroup, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { BrnSelectComponent, BrnSelectImports } from '../../';

@Component({
	imports: [FormsModule, ReactiveFormsModule, BrnSelectImports],
	selector: 'select-reactive-field-fixture',
	template: `
		<form [formGroup]="fruitGroup">
			<brn-select class="w-56" formControlName="fruit" placeholder="Select a Fruit">
				<button brnSelectTrigger data-testid="brn-select-trigger">
					<brn-select-value />
				</button>
				<brn-select-content class="w-56" data-testid="brn-select-content">
					<label brnSelectLabel>Fruits</label>
					<div brnOption value="apple">Apple</div>
					<div brnOption value="banana">Banana</div>
					<div brnOption value="blueberry">Blueberry</div>
					<div brnOption value="grapes">Grapes</div>
					<div brnOption value="pineapple">Pineapple</div>
					<div>Clear</div>
				</brn-select-content>
			</brn-select>
			@if (fruitGroup.controls.fruit.invalid && fruitGroup.controls.fruit.touched) {
				<span class="text-destructive">Required</span>
			}
		</form>
	`,
})
export class SelectReactiveFieldComponent {
	public fruitGroup = new FormGroup({ fruit: new FormControl() });
}

@Component({
	imports: [FormsModule, ReactiveFormsModule, BrnSelectImports],
	selector: 'select-reactive-field-fixture',
	template: `
		<form [formGroup]="form">
			<brn-select class="w-56" formControlName="fruit" placeholder="Select a Fruit">
				<button brnSelectTrigger data-testid="brn-select-trigger">
					<brn-select-value data-testid="brn-select-value" />
				</button>
				<brn-select-content class="w-56" data-testid="brn-select-content">
					<label brnSelectLabel>Fruits</label>
					<div brnOption value="apple">Apple</div>
					<div brnOption value="banana">Banana</div>
					<div brnOption value="blueberry">Blueberry</div>
					<div brnOption value="grapes">Grapes</div>
					<div brnOption value="pineapple">Pineapple</div>
					<div>Clear</div>
				</brn-select-content>
			</brn-select>
			@if (form.controls.fruit.invalid && form.controls.fruit.touched) {
				<span class="text-destructive">Required</span>
			}
		</form>
	`,
})
export class SelectSingleValueTestComponent {
	public form = new FormGroup({ fruit: new FormControl(null) });

	public brnSelectComponent = viewChild(BrnSelectComponent);
}

@Component({
	imports: [FormsModule, ReactiveFormsModule, BrnSelectImports],
	selector: 'select-reactive-field-fixture',
	template: `
		<form [formGroup]="form">
			<brn-select class="w-56" formControlName="fruit" placeholder="Select a Fruit">
				<button brnSelectTrigger data-testid="brn-select-trigger">
					<brn-select-value data-testid="brn-select-value" />
				</button>
				<brn-select-content class="w-56" data-testid="brn-select-content">
					<label brnSelectLabel>Fruits</label>
					<div brnOption value="apple">Apple</div>
					<div brnOption value="banana">Banana</div>
					<div brnOption value="blueberry">Blueberry</div>
					<div brnOption value="grapes">Grapes</div>
					<div brnOption value="pineapple">Pineapple</div>
					<div>Clear</div>
				</brn-select-content>
			</brn-select>
			@if (form.controls.fruit.invalid && form.controls.fruit.touched) {
				<span class="text-destructive">Required</span>
			}
		</form>
	`,
})
export class SelectSingleValueWithInitialValueTestComponent {
	public form = new FormGroup({ fruit: new FormControl('apple') });
}

@Component({
	imports: [FormsModule, ReactiveFormsModule, BrnSelectImports],
	selector: 'select-reactive-field-fixture',
	template: `
		<form [formGroup]="form">
			<brn-select class="w-56" formControlName="fruit" placeholder="Select a Fruit">
				<button brnSelectTrigger data-testid="brn-select-trigger">
					<brn-select-value data-testid="brn-select-value" />
				</button>
				<brn-select-content class="w-56" data-testid="brn-select-content">
					<label brnSelectLabel>Fruits</label>
					<div brnOption value="apple">Apple</div>
					<div brnOption value="banana">Banana</div>
					<div brnOption value="blueberry">Blueberry</div>
					<div brnOption value="grapes">Grapes</div>
					<div brnOption value="pineapple">Pineapple</div>
					<div>Clear</div>
				</brn-select-content>
			</brn-select>
			@if (form.controls.fruit.invalid && form.controls.fruit.touched) {
				<span class="text-destructive">Required</span>
			}
		</form>
	`,
})
export class SelectSingleValueWithInitialValueWithAsyncUpdateTestComponent {
	public form = new FormGroup({ fruit: new FormControl('apple') });

	constructor() {
		// queueMicrotask(() => {
		// 	this.form.patchValue({ fruit: 'apple' });
		// });
		setTimeout(() => {
			this.form.patchValue({ fruit: 'apple' });
		});
	}
}

@Component({
	imports: [FormsModule, ReactiveFormsModule, BrnSelectImports],
	selector: 'select-reactive-field-fixture',
	template: `
		<form [formGroup]="form">
			<brn-select class="w-56" formControlName="fruit" placeholder="Select a Fruit" [multiple]="true">
				<button brnSelectTrigger data-testid="brn-select-trigger">
					<brn-select-value data-testid="brn-select-value" />
				</button>
				<brn-select-content class="w-56" data-testid="brn-select-content">
					<label brnSelectLabel>Fruits</label>
					<div brnOption value="apple">Apple</div>
					<div brnOption value="banana">Banana</div>
					<div brnOption value="blueberry">Blueberry</div>
					<div brnOption value="grapes">Grapes</div>
					<div brnOption value="pineapple">Pineapple</div>
					<div>Clear</div>
				</brn-select-content>
			</brn-select>
			@if (form.controls.fruit.invalid && form.controls.fruit.touched) {
				<span class="text-destructive">Required</span>
			}
		</form>
	`,
})
export class SelectMultiValueTestComponent {
	public form = new FormGroup({ fruit: new FormControl<string[]>([]) });
}

@Component({
	imports: [FormsModule, ReactiveFormsModule, BrnSelectImports],
	selector: 'select-reactive-field-fixture',
	template: `
		<form [formGroup]="form">
			<brn-select class="w-56" formControlName="fruit" placeholder="Select a Fruit" [multiple]="true">
				<button brnSelectTrigger data-testid="brn-select-trigger">
					<brn-select-value data-testid="brn-select-value" />
				</button>
				<brn-select-content class="w-56" data-testid="brn-select-content">
					<label brnSelectLabel>Fruits</label>
					<div brnOption value="apple">Apple</div>
					<div brnOption value="banana">Banana</div>
					<div brnOption value="blueberry">Blueberry</div>
					<div brnOption value="grapes">Grapes</div>
					<div brnOption value="pineapple">Pineapple</div>
					<div>Clear</div>
				</brn-select-content>
			</brn-select>
			@if (form.controls.fruit.invalid && form.controls.fruit.touched) {
				<span class="text-destructive">Required</span>
			}
		</form>
	`,
})
export class SelectMultiValueWithInitialValueTestComponent {
	public form = new FormGroup({ fruit: new FormControl(['apple', 'blueberry']) });
}

@Component({
	imports: [FormsModule, ReactiveFormsModule, BrnSelectImports],
	selector: 'select-reactive-field-fixture',
	changeDetection: ChangeDetectionStrategy.OnPush,
	template: `
		<form [formGroup]="form">
			<brn-select class="w-56" formControlName="fruit" placeholder="Select a Fruit" [multiple]="true">
				<button brnSelectTrigger data-testid="brn-select-trigger">
					<brn-select-value data-testid="brn-select-value" />
				</button>
				<brn-select-content class="w-56" data-testid="brn-select-content">
					<label brnSelectLabel>Fruits</label>
					@for (selectOption of options(); track selectOption.value) {
						<div brnOption [value]="selectOption.value">{{ selectOption.label }}</div>
					}
				</brn-select-content>
			</brn-select>
			@if (form.controls.fruit.invalid && form.controls.fruit.touched) {
				<span class="text-destructive">Required</span>
			}
		</form>

		<button (click)="updateOptions()" data-testid="update-options-btn">Update Options</button>
		<button (click)="updatePartialOptions()" data-testid="partial-options-btn">Partial Options</button>
		<button (click)="updateDiffOptions()" data-testid="diff-options-btn">Diff Options</button>
	`,
})
export class SelectMultiValueWithInitialValueWithForLoopTestComponent implements OnInit {
	public options = signal<{ value: string; label: string }[]>([]);
	public form = new FormGroup({ fruit: new FormControl(['apple', 'pineapple']) });

	ngOnInit(): void {
		this.options.set([
			{ label: 'Apple', value: 'apple' },
			{ label: 'Banana', value: 'banana' },
			{ label: 'Blueberry', value: 'blueberry' },
			{ label: 'Grapes', value: 'grapes' },
			{ label: 'Pineapple', value: 'pineapple' },
		]);
	}

	public updateOptions() {
		// Reset same options
		this.options.set([
			{ label: 'Apple', value: 'apple' },
			{ label: 'Banana', value: 'banana' },
			{ label: 'Blueberry', value: 'blueberry' },
			{ label: 'Grapes', value: 'grapes' },
			{ label: 'Pineapple', value: 'pineapple' },
		]);
	}

	public updateDiffOptions() {
		// Reset with different option values
		this.options.set([
			{ label: 'Coconut', value: 'coconut' },
			{ label: 'Grapefruit', value: 'grapefruit' },
			{ label: 'Kiwi', value: 'kiwi' },
			{ label: 'Pomegranate', value: 'pomegranate' },
			{ label: 'Watermelon', value: 'watermelon' },
		]);
	}

	public updatePartialOptions() {
		// Reset with different option values
		this.options.set([
			{ label: 'Apple', value: 'apple' },
			{ label: 'Banana', value: 'banana' },
			{ label: 'Blueberry', value: 'blueberry' },
			{ label: 'Pomegranate', value: 'pomegranate' },
			{ label: 'Watermelon', value: 'watermelon' },
		]);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/tests/select-single-mode.spec.ts
```typescript
import { Validators } from '@angular/forms';
import { render, screen } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import {
	SelectSingleValueTestComponent,
	SelectSingleValueWithInitialValueTestComponent,
	SelectSingleValueWithInitialValueWithAsyncUpdateTestComponent,
} from './select-reactive-form';
import { getFormControlStatus, getFormValidationClasses } from './utils';

describe('Brn Select Component in single-mode', () => {
	const DEFAULT_LABEL = 'Select a Fruit';
	const INITIAL_VALUE_TEXT = 'Apple';
	const INITIAL_VALUE = 'apple';

	beforeAll(() => {
		global.ResizeObserver = jest.fn().mockImplementation(() => ({
			observe: jest.fn(),
			unobserve: jest.fn(),
			disconnect: jest.fn(),
		}));

		window.HTMLElement.prototype.scrollIntoView = jest.fn();
	});

	const setupWithFormValidation = async () => {
		const { fixture } = await render(SelectSingleValueTestComponent);
		return {
			user: userEvent.setup(),
			fixture,
			trigger: screen.getByTestId('brn-select-trigger'),
			value: screen.getByTestId('brn-select-value'),
		};
	};

	const setupWithFormValidationAndInitialValue = async () => {
		const { fixture } = await render(SelectSingleValueWithInitialValueTestComponent);
		return {
			user: userEvent.setup(),
			fixture,
			trigger: screen.getByTestId('brn-select-trigger'),
			value: screen.getByTestId('brn-select-value'),
		};
	};

	const setupWithFormValidationAndInitialValueAndAsyncUpdate = async () => {
		const { fixture } = await render(SelectSingleValueWithInitialValueWithAsyncUpdateTestComponent);
		return {
			user: userEvent.setup(),
			fixture,
			trigger: screen.getByTestId('brn-select-trigger'),
			value: screen.getByTestId('brn-select-value'),
		};
	};

	describe('form validation - single mode', () => {
		it('should reflect correct formcontrol status and value with no initial value', async () => {
			const { fixture, trigger, value } = await setupWithFormValidation();
			const cmpInstance = fixture.componentInstance as SelectSingleValueTestComponent;

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(value.textContent?.trim()).toBe(DEFAULT_LABEL);
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(null);
		});

		it('should reflect correct formcontrol status and value with initial value', async () => {
			const { fixture, trigger, value } = await setupWithFormValidationAndInitialValue();
			const cmpInstance = fixture.componentInstance;

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(value.textContent?.trim()).toBe(INITIAL_VALUE_TEXT);
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(INITIAL_VALUE);
		});

		it('should reflect correct formcontrol status after first user selection with no initial value', async () => {
			const { user, trigger, fixture, value } = await setupWithFormValidation();
			const cmpInstance = fixture.componentInstance as SelectSingleValueTestComponent;

			expect(value.textContent?.trim()).toBe(DEFAULT_LABEL);
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(null);

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			// Open Select
			await user.click(trigger);

			const afterOpenExpected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterOpenExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterOpenExpected);

			// Select option
			const options = await screen.getAllByRole('option');
			await user.click(options[1]);

			const afterSelectionExpected = {
				untouched: false,
				touched: true,
				valid: true,
				invalid: false,
				pristine: false,
				dirty: true,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterSelectionExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterSelectionExpected);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual('banana');
		});

		it('should reflect correct formcontrol status after first user selection with initial value', async () => {
			const { user, trigger, fixture, value } = await setupWithFormValidationAndInitialValue();
			const cmpInstance = fixture.componentInstance as SelectSingleValueWithInitialValueTestComponent;

			expect(value.textContent?.trim()).toBe(INITIAL_VALUE_TEXT);
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(INITIAL_VALUE);

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			// Open Select
			await user.click(trigger);

			const afterOpenExpected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterOpenExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterOpenExpected);

			// Select option
			const options = await screen.getAllByRole('option');
			await user.click(options[1]);

			const afterSelectionExpected = {
				untouched: false,
				touched: true,
				valid: true,
				invalid: false,
				pristine: false,
				dirty: true,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterSelectionExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterSelectionExpected);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual('banana');
			expect(screen.getByTestId('brn-select-value').textContent?.trim()).toBe('Banana');
		});

		it('should reflect correct formcontrol status after first user selection with initial value and async update', async () => {
			const { user, trigger, fixture, value } = await setupWithFormValidationAndInitialValueAndAsyncUpdate();
			const cmpInstance = fixture.componentInstance as SelectSingleValueWithInitialValueTestComponent;

			expect(value.textContent?.trim()).toBe(INITIAL_VALUE_TEXT);
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(INITIAL_VALUE);

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			// Open Select
			await user.click(trigger);

			const afterOpenExpected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterOpenExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterOpenExpected);

			// Select option
			const options = await screen.getAllByRole('option');
			await user.click(options[1]);

			const afterSelectionExpected = {
				untouched: false,
				touched: true,
				valid: true,
				invalid: false,
				pristine: false,
				dirty: true,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(afterSelectionExpected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(afterSelectionExpected);

			expect(cmpInstance.form?.get('fruit')?.value).toEqual('banana');
			expect(value.textContent?.trim()).toBe('Banana');
		});
	});

	describe('form validation - single mode and required', () => {
		it('should reflect correct formcontrol status with no initial value', async () => {
			const { fixture, trigger, value } = await setupWithFormValidation();
			const cmpInstance = fixture.componentInstance as SelectSingleValueTestComponent;

			cmpInstance.form?.get('fruit')?.addValidators(Validators.required);
			cmpInstance.form?.get('fruit')?.updateValueAndValidity();
			fixture.detectChanges();

			const expected = {
				untouched: true,
				touched: false,
				valid: false,
				invalid: true,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(value.textContent?.trim()).toBe(DEFAULT_LABEL);
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(null);
		});

		it('should have the errorState in true when the select has been triggered and no option has been selected', async () => {
			const { user, fixture, trigger } = await setupWithFormValidation();
			const cmpInstance = fixture.componentInstance as SelectSingleValueTestComponent;

			cmpInstance.form?.get('fruit')?.addValidators(Validators.required);
			cmpInstance.form?.get('fruit')?.updateValueAndValidity();
			fixture.detectChanges();

			// open
			await user.click(trigger);
			// close
			await user.click(trigger);

			expect(cmpInstance.brnSelectComponent()?.errorState()).toBeTruthy();
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(null);
		});

		it('should reflect initial single value set on formcontrol', async () => {
			const { fixture, trigger, value } = await setupWithFormValidationAndInitialValue();
			const cmpInstance = fixture.componentInstance as SelectSingleValueTestComponent;

			const expected = {
				untouched: true,
				touched: false,
				valid: true,
				invalid: false,
				pristine: true,
				dirty: false,
			};

			expect(getFormControlStatus(cmpInstance.form?.get('fruit'))).toStrictEqual(expected);
			expect(getFormValidationClasses(trigger)).toStrictEqual(expected);

			expect(value.textContent?.trim()).toBe(INITIAL_VALUE_TEXT);
			expect(cmpInstance.form?.get('fruit')?.value).toEqual(INITIAL_VALUE);
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/select/src/lib/tests/utils.ts
```typescript
import type { AbstractControl } from '@angular/forms';

export interface ExpectedFormStatus {
	[key: string]: boolean | string | null;
	untouched: boolean | string | null;
	valid: boolean | string | null;
	pristine: boolean | string | null;
	touched: boolean | string | null;
	invalid: boolean | string | null;
	dirty: boolean | string | null;
}

export const getFormControlStatus = (
	formControl: AbstractControl<string | string[] | null, string | string[] | null> | null,
) => {
	const actualValues: ExpectedFormStatus = {
		untouched: null,
		valid: null,
		pristine: null,
		touched: null,
		invalid: null,
		dirty: null,
	};
	for (const status in actualValues) {
		actualValues[status] = formControl?.[status as keyof typeof formControl] as boolean;
	}
	return actualValues;
};

export const getFormValidationClasses = (el: HTMLElement): ExpectedFormStatus => {
	const actualValues: ExpectedFormStatus = {
		untouched: null,
		valid: null,
		pristine: null,
		touched: null,
		invalid: null,
		dirty: null,
	};
	for (const status in actualValues) {
		actualValues[status] = el.classList.contains(`ng-${status}`);
	}
	return actualValues;
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/README.md
```
# @spartan-ng/brain/sheet

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/sheet`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnSheetCloseDirective } from './lib/brn-sheet-close.directive';
import { BrnSheetContentDirective } from './lib/brn-sheet-content.directive';
import { BrnSheetDescriptionDirective } from './lib/brn-sheet-description.directive';
import { BrnSheetOverlayComponent } from './lib/brn-sheet-overlay.component';
import { BrnSheetTitleDirective } from './lib/brn-sheet-title.directive';
import { BrnSheetTriggerDirective } from './lib/brn-sheet-trigger.directive';
import { BrnSheetComponent } from './lib/brn-sheet.component';

export * from './lib/brn-sheet-close.directive';
export * from './lib/brn-sheet-content.directive';
export * from './lib/brn-sheet-description.directive';
export * from './lib/brn-sheet-overlay.component';
export * from './lib/brn-sheet-title.directive';
export * from './lib/brn-sheet-trigger.directive';
export * from './lib/brn-sheet.component';

export const BrnSheetImports = [
	BrnSheetComponent,
	BrnSheetOverlayComponent,
	BrnSheetTriggerDirective,
	BrnSheetCloseDirective,
	BrnSheetContentDirective,
	BrnSheetTitleDirective,
	BrnSheetDescriptionDirective,
] as const;

@NgModule({
	imports: [...BrnSheetImports],
	exports: [...BrnSheetImports],
})
export class BrnSheetModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/lib/brn-sheet-close.directive.ts
```typescript
import { Directive } from '@angular/core';
import { BrnDialogCloseDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: 'button[brnSheetClose]',
	standalone: true,
})
export class BrnSheetCloseDirective extends BrnDialogCloseDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/lib/brn-sheet-content.directive.ts
```typescript
import { Directive, inject } from '@angular/core';
import {
	type ExposesSide,
	provideExposedSideProviderExisting,
	provideExposesStateProviderExisting,
} from '@spartan-ng/brain/core';
import { BrnDialogContentDirective } from '@spartan-ng/brain/dialog';
import { BrnSheetComponent } from './brn-sheet.component';

@Directive({
	selector: '[brnSheetContent]',
	standalone: true,
	providers: [
		provideExposesStateProviderExisting(() => BrnSheetContentDirective),
		provideExposedSideProviderExisting(() => BrnSheetContentDirective),
	],
})
export class BrnSheetContentDirective<T> extends BrnDialogContentDirective<T> implements ExposesSide {
	public readonly side = inject(BrnSheetComponent).side;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/lib/brn-sheet-description.directive.ts
```typescript
import { Directive } from '@angular/core';
import { BrnDialogDescriptionDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: '[brnSheetDescription]',
	standalone: true,
	host: {
		'[id]': '_id()',
	},
})
export class BrnSheetDescriptionDirective extends BrnDialogDescriptionDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/lib/brn-sheet-overlay.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation } from '@angular/core';
import { provideCustomClassSettableExisting } from '@spartan-ng/brain/core';
import { BrnDialogOverlayComponent } from '@spartan-ng/brain/dialog';

@Component({
	selector: 'brn-sheet-overlay',
	standalone: true,
	providers: [provideCustomClassSettableExisting(() => BrnSheetOverlayComponent)],
	template: '',
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnSheetOverlayComponent extends BrnDialogOverlayComponent {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/lib/brn-sheet-title.directive.ts
```typescript
import { Directive } from '@angular/core';
import { BrnDialogTitleDirective } from '@spartan-ng/brain/dialog';

@Directive({
	selector: '[brnSheetTitle]',
	standalone: true,
	host: {
		'[id]': '_id()',
	},
})
export class BrnSheetTitleDirective extends BrnDialogTitleDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/lib/brn-sheet-trigger.directive.ts
```typescript
import { Directive, inject, input } from '@angular/core';
import { BrnDialogTriggerDirective } from '@spartan-ng/brain/dialog';
import { BrnSheetComponent } from './brn-sheet.component';

@Directive({
	selector: 'button[brnSheetTrigger]',
	standalone: true,
})
export class BrnSheetTriggerDirective extends BrnDialogTriggerDirective {
	private readonly _sheet = inject(BrnSheetComponent, { optional: true });

	public side = input<'top' | 'bottom' | 'left' | 'right' | undefined>(undefined);

	override open() {
		const side = this.side();
		if (this._sheet && side) {
			this._sheet.sideInputState().set(side);
		}
		super.open();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/sheet/src/lib/brn-sheet.component.ts
```typescript
import {
	ChangeDetectionStrategy,
	Component,
	computed,
	effect,
	forwardRef,
	input,
	signal,
	untracked,
	ViewEncapsulation,
} from '@angular/core';
import { BrnDialogComponent } from '@spartan-ng/brain/dialog';

@Component({
	selector: 'brn-sheet',
	standalone: true,
	template: `
		<ng-content />
	`,
	providers: [
		{
			provide: BrnDialogComponent,
			useExisting: forwardRef(() => BrnSheetComponent),
		},
	],
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	exportAs: 'brnSheet',
})
export class BrnSheetComponent extends BrnDialogComponent {
	public readonly sideInput = input<'top' | 'bottom' | 'left' | 'right'>('top', { alias: 'side' });
	public readonly sideInputState = computed(() => signal(this.sideInput()));
	public readonly side = computed(() => this.sideInputState().asReadonly()());
	constructor() {
		super();
		effect(() => {
			const side = this.side();
			untracked(() => {
				if (side === 'top') {
					this.mutablePositionStrategy().set(this.positionBuilder.global().top());
				}
				if (side === 'bottom') {
					this.mutablePositionStrategy().set(this.positionBuilder.global().bottom());
				}
				if (side === 'left') {
					this.mutablePositionStrategy().set(this.positionBuilder.global().left());
				}
				if (side === 'right') {
					this.mutablePositionStrategy().set(this.positionBuilder.global().right());
				}
			});
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/src/index.ts
```typescript
// this file can't be empty, otherwise the build will fail
export default true;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/src/test-setup.ts
```typescript
import '@testing-library/jest-dom';
import { setupZoneTestEnv } from 'jest-preset-angular/setup-env/zone';

setupZoneTestEnv();

import { toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

```
