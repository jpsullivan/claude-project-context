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
