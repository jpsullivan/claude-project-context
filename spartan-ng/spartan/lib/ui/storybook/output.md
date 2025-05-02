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
