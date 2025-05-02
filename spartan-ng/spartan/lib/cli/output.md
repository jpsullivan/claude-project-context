/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/README.md
```
# cli

This library was generated with [Nx](https://nx.dev).

## Building

Run `nx build cli` to build the library.

## Running unit tests

Run `nx test cli` to execute the unit tests via [Jest](https://jestjs.io).

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/eslint.config.cjs
```
const baseConfig = require('../../eslint.config.cjs');

module.exports = [
	...baseConfig,
	{
		files: ['**/*.ts', '**/*.tsx', '**/*.js', '**/*.jsx'],
		rules: {},
	},
	{
		files: ['**/*.ts', '**/*.tsx'],
		rules: {
			'@angular-eslint/prefer-output-readonly': 'off',
		},
	},
	{
		files: ['**/*.js', '**/*.jsx'],
		rules: {},
	},
	{
		files: ['**/*.json'],
		rules: {
			'@nx/nx-plugin-checks': 'error',
			'@nx/dependency-checks': [
				'error',
				{
					ignoredDependencies: ['@nx/js', '@nx/devkit', '@nx/angular', 'enquirer', 'semver', 'tslib'],
				},
			],
		},
		languageOptions: {
			parser: require('jsonc-eslint-parser'),
		},
	},
];

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/executors.json
```json
{
	"executors": {}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/generators.json
```json
{
	"generators": {
		"ui": {
			"factory": "./src/generators/ui/generator",
			"schema": "./src/generators/ui/schema.json",
			"description": "spartan-ng ui generator"
		},
		"ui-theme": {
			"factory": "./src/generators/theme/generator",
			"schema": "./src/generators/theme/schema.json",
			"description": "spartan-ng theme generator"
		},
		"migrate-brain-imports": {
			"factory": "./src/generators/migrate-brain-imports/generator",
			"schema": "./src/generators/migrate-brain-imports/schema.json",
			"description": "Migrate Brain imports to use secondary entrypoints."
		},
		"migrate-scroll-area": {
			"factory": "./src/generators/migrate-scroll-area/generator",
			"schema": "./src/generators/migrate-scroll-area/schema.json",
			"description": "Migrate hlm-scroll-area to ngx-scrollbar"
		},
		"migrate-icon": {
			"factory": "./src/generators/migrate-icon/generator",
			"schema": "./src/generators/migrate-icon/schema.json",
			"description": "Migrate hlm-icon to ng-icon"
		},
		"migrate-radio": {
			"factory": "./src/generators/migrate-radio/generator",
			"schema": "./src/generators/migrate-radio/schema.json",
			"description": "Migrate brn-radio to hlm-radio"
		},
		"migrate-toggle-group": {
			"factory": "./src/generators/migrate-toggle-group/generator",
			"schema": "./src/generators/migrate-toggle-group/schema.json",
			"description": "Migrate brn-toggle-group from @spartan-ng/brain/toggle to @spartan-ng/brain/toggle-group"
		},
		"migrate-select": {
			"factory": "./src/generators/migrate-select/generator",
			"schema": "./src/generators/migrate-select/schema.json",
			"description": "Migrate brn-select and hlm-select to use openChange and active descendants"
		},
		"migrate-core": {
			"factory": "./src/generators/migrate-core/generator",
			"schema": "./src/generators/migrate-core/schema.json",
			"description": "Migrate core library to brain core entrypoing"
		},
		"healthcheck": {
			"factory": "./src/generators/healthcheck/generator",
			"schema": "./src/generators/healthcheck/schema.json",
			"description": "Run a healthcheck on the project to identify any potential issues or outdated code."
		},
		"migrate-helm-libraries": {
			"factory": "./src/generators/migrate-helm-libraries/generator",
			"schema": "./src/generators/migrate-helm-libraries/schema.json",
			"description": "Migrate Helm libraries to their latest versions"
		}
	},
	"schematics": {
		"ui": {
			"factory": "./src/generators/ui/compat",
			"schema": "./src/generators/ui/schema.json",
			"description": "spartan-ng ui generator"
		},
		"ui-theme": {
			"factory": "./src/generators/theme/compat",
			"schema": "./src/generators/theme/schema.json",
			"description": "spartan-ng theme generator"
		},
		"migrate-brain-imports": {
			"factory": "./src/generators/migrate-brain-imports/compat",
			"schema": "./src/generators/migrate-brain-imports/schema.json",
			"description": "Migrate Brain imports to use secondary entrypoints."
		},
		"migrate-scroll-area": {
			"factory": "./src/generators/migrate-scroll-area/compat",
			"schema": "./src/generators/migrate-scroll-area/schema.json",
			"description": "Migrate hlm-scroll-area to ngx-scrollbar"
		},
		"migrate-icon": {
			"factory": "./src/generators/migrate-icon/compat",
			"schema": "./src/generators/migrate-icon/schema.json",
			"description": "Migrate hlm-icon to ng-icon"
		},
		"migrate-radio": {
			"factory": "./src/generators/migrate-radio/compat",
			"schema": "./src/generators/migrate-radio/schema.json",
			"description": "Migrate brn-radio to hlm-radio"
		},
		"migrate-select": {
			"factory": "./src/generators/migrate-select/compat",
			"schema": "./src/generators/migrate-select/schema.json",
			"description": "Migrate brn-select and hlm-select to use openChange and active descendants"
		},
		"migrate-core": {
			"factory": "./src/generators/migrate-scroll-area/compat",
			"schema": "./src/generators/migrate-core/schema.json",
			"description": "Migrate core library to brain core entrypoing"
		},
		"healthcheck": {
			"factory": "./src/generators/healthcheck/compat",
			"schema": "./src/generators/healthcheck/schema.json",
			"description": "Run a healthcheck on the project to identify any potential issues or outdated code."
		},
		"migrate-helm-libraries": {
			"factory": "./src/generators/migrate-helm-libraries/compat",
			"schema": "./src/generators/migrate-helm-libraries/schema.json",
			"description": "Migrate Helm libraries to their latest versions"
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/jest.config.ts
```typescript
export default {
	displayName: 'cli',
	preset: '../../jest.preset.cjs',
	testEnvironment: 'node',
	transform: {
		'^.+\\.[tj]s$': ['ts-jest', { tsconfig: '<rootDir>/tsconfig.spec.json' }],
	},
	moduleFileExtensions: ['ts', 'js', 'html'],
	coverageDirectory: '../../coverage/libs/cli',
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/package.json
```json
{
	"name": "@spartan-ng/cli",
	"version": "0.0.1-alpha.451",
	"type": "commonjs",
	"dependencies": {
		"@nx/angular": ">=20.0.0",
		"@nx/devkit": ">=20.0.0",
		"@nx/js": ">=20.0.0",
		"@nx/workspace": ">=20.0.0",
		"@phenomnomnominal/tsquery": "^6.1.3",
		"@schematics/angular": ">=19.0.0",
		"enquirer": "2.3.6",
		"jsonc-eslint-parser": "^2.1.0",
		"nx": ">=20.0.0",
		"picocolors": "^1.1.1",
		"semver": "7.5.4",
		"typescript": ">=5.0.0"
	},
	"peerDependencies": {
		"tslib": "^2.3.0"
	},
	"publishConfig": {
		"access": "public"
	},
	"executors": "./executors.json",
	"generators": "./generators.json",
	"schematics": "./generators.json"
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/project.json
```json
{
	"name": "cli",
	"$schema": "../../node_modules/nx/schemas/project-schema.json",
	"sourceRoot": "libs/cli/src",
	"projectType": "library",
	"tags": ["scope:cli"],
	"targets": {
		"build": {
			"executor": "@nx/js:tsc",
			"outputs": ["{options.outputPath}"],
			"options": {
				"outputPath": "dist/libs/cli",
				"main": "libs/cli/src/index.ts",
				"tsConfig": "libs/cli/tsconfig.lib.json",
				"assets": [
					"libs/cli/*.md",
					{
						"input": "./libs/cli/src",
						"glob": "**/!(*.ts)",
						"output": "./src"
					},
					{
						"input": "./libs/cli/src",
						"glob": "**/*.d.ts",
						"output": "./src"
					},
					{
						"input": "./libs/cli",
						"glob": "generators.json",
						"output": "."
					},
					{
						"input": "./libs/cli",
						"glob": "executors.json",
						"output": "."
					}
				]
			}
		},
		"lint": {
			"executor": "@nx/eslint:lint",
			"outputs": ["{options.outputFile}"]
		},
		"test": {
			"executor": "@nx/jest:jest",
			"outputs": ["{workspaceRoot}/coverage/{projectRoot}"],
			"options": {
				"jestConfig": "libs/cli/jest.config.ts"
			}
		},
		"release": {
			"executor": "@spartan-ng/tools:build-update-publish",
			"options": {
				"libName": "cli"
			}
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/tsconfig.json
```json
{
	"extends": "../../tsconfig.base.json",
	"compilerOptions": {
		"module": "commonjs"
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
	]
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/tsconfig.lib.json
```json
{
	"extends": "./tsconfig.json",
	"compilerOptions": {
		"outDir": "../../dist/out-tsc",
		"declaration": true,
		"types": ["node"],
		"resolveJsonModule": true
	},
	"include": ["src/**/*.ts"],
	"exclude": ["jest.config.ts", "src/**/*.spec.ts", "src/**/*.test.ts"]
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/tsconfig.spec.json
```json
{
	"extends": "./tsconfig.json",
	"compilerOptions": {
		"outDir": "../../dist/out-tsc",
		"module": "commonjs",
		"types": ["jest", "node"],
		"resolveJsonModule": true
	},
	"include": ["jest.config.ts", "src/**/*.test.ts", "src/**/*.spec.ts", "src/**/*.d.ts"]
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/index.ts
```typescript
export * from './generators/migrate-brain-imports/generator';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/utils/config.ts
```typescript
import { type Tree, readJson } from '@nx/devkit';
import { prompt } from 'enquirer';

const configPath = 'components.json';

export type Config = {
	componentsPath: string;
};

export async function getOrCreateConfig(tree: Tree, defaults?: Partial<Config>): Promise<Config> {
	if (tree.exists(configPath)) {
		return readJson(tree, configPath) as Promise<Config>; // TODO: Parse with zod and handle errors
	}

	console.log('Configuration file not found, creating a new one...');

	const { componentsPath } = (await prompt([
		{
			type: 'input',
			required: true,
			name: 'componentsPath',
			message: 'Choose a directory to place your spartan libraries, e.g. libs/ui',
			initial: defaults?.componentsPath ?? 'libs/ui',
			skip: !!defaults?.componentsPath,
		},
	])) as { componentsPath: string };

	const config = { componentsPath };

	tree.write(configPath, JSON.stringify(config, null, 2));

	return config;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/utils/get-project-names.ts
```typescript
import { type Tree, getProjects } from '@nx/devkit';

export const getProjectsAndNames = (tree: Tree) => {
	const projectNames: string[] = [];
	const projects = getProjects(tree);

	projects.forEach((projectConfiguration, projectName) => {
		if (projectConfiguration.projectType === 'application') {
			projectNames.push(projectName);
		}
	});
	return { projects, projectNames };
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/utils/hlm-class.ts
```typescript
import { Tree } from '@nx/devkit';
import { tsquery } from '@phenomnomnominal/tsquery';

export function hasHelmClasses(tree: Tree, path: string, { component, classes }: HasHelmClassesSchema): boolean {
	const content = tree.read(path, 'utf-8');

	if (!content) {
		return false;
	}

	const ast = tsquery.ast(content);

	// find the component class if it exists
	const componentClass = tsquery.query(ast, `ClassDeclaration:has(Identifier[name="${component}"])`);

	if (componentClass.length === 0) {
		return false;
	}

	// try and find the _computedClass property string
	const computedClass = tsquery.query(
		componentClass[0],
		`PropertyDeclaration:has(Identifier[name="_computedClass"]) CallExpression CallExpression:has(Identifier[name="hlm"]) StringLiteral`,
	);

	if (computedClass.length === 0) {
		return false;
	}

	// get the computed class value
	const classesString = computedClass[0].getText();
	const classesArray = classesString.split(' ');

	// check if the classes exist
	return classes.some((c) => classesArray.includes(c));
}

interface HasHelmClassesSchema {
	/**
	 * The name of the components that need to be checked.
	 */
	component: string;
	/**
	 * The classes that need to be checked for.
	 */
	classes: string[];
}

export function updateHelmClasses(
	tree: Tree,
	path: string,
	{ component, classesToAdd, classesToRemove }: UpdateHelmClassesSchema,
): string {
	const content = tree.read(path, 'utf-8');

	if (!content) {
		return;
	}

	const ast = tsquery.ast(content);

	// find the component class if it exists
	const componentClass = tsquery.query(ast, `ClassDeclaration:has(Identifier[name="${component}"])`);

	if (componentClass.length === 0) {
		return;
	}

	// try and find the _computedClass property string
	const computedClass = tsquery.query(
		componentClass[0],
		`PropertyDeclaration:has(Identifier[name="_computedClass"]) CallExpression CallExpression:has(Identifier[name="hlm"]) StringLiteral`,
	);

	if (computedClass.length === 0) {
		return;
	}

	// get the computed class value
	const classes = computedClass[0].getText();
	let modifiedClasses = classes.split(' ');

	// remove the classes that need to be removed
	modifiedClasses = modifiedClasses.filter((c) => !classesToRemove.includes(c));

	// add the classes that need to be added
	modifiedClasses = modifiedClasses.concat(classesToAdd);

	// update the classes
	const updatedClasses = modifiedClasses.join(' ');

	// replace the original classes with the updated classes
	const updatedContent = content.replace(classes, updatedClasses);

	tree.write(path, updatedContent);
}

interface UpdateHelmClassesSchema {
	/**
	 * The name of the components that need to be updated.
	 */
	component: string;
	/**
	 * The classes that need to be removed from the components.
	 */
	classesToRemove: string[];
	/**
	 * The classes that need to be added to the components.
	 */
	classesToAdd: string[];
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/utils/tsconfig.ts
```typescript
import { readJson, Tree } from '@nx/devkit';
import { getRootTsConfigPathInTree } from '@nx/js';
import type { CompilerOptions } from 'typescript';

interface TsConfig {
	compilerOptions?: CompilerOptions;
	include?: string[];
	exclude?: string[];
	references?: { path: string }[];
}

export function readTsConfigPathsFromTree(tree: Tree, tsConfig?: string) {
	tsConfig ??= getRootTsConfigPathInTree(tree);

	try {
		const { compilerOptions } = readJson(tree, tsConfig) as TsConfig;
		return compilerOptions?.paths ?? {};
	} catch {
		return {};
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/utils/version-utils.ts
```typescript
import { type Tree, readJson } from '@nx/devkit';
import { clean, coerce } from 'semver';

export function getInstalledPackageVersion(
	tree: Tree,
	packageName: string,
	defaultVersion?: string,
	raw = false,
): string | null {
	const pkgJson = readJson(tree, 'package.json');
	const installedPackageVersion = pkgJson.dependencies?.[packageName] || pkgJson.devDependencies?.[packageName];
	if (!installedPackageVersion && !defaultVersion) {
		return null;
	}

	if (!installedPackageVersion || installedPackageVersion === 'latest' || installedPackageVersion === 'next') {
		return clean(defaultVersion) ?? coerce(defaultVersion).version;
	}

	return (raw ? installedPackageVersion : clean(installedPackageVersion)) ?? coerce(installedPackageVersion).version;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/utils/visit-files.ts
```typescript
import { Tree, visitNotIgnoredFiles } from '@nx/devkit';

export function visitFiles(tree: Tree, dirPath: string, visitor: (path: string) => void): void {
	visitNotIgnoredFiles(tree, dirPath, (path) => {
		// if the file is part of the generators we want to skip as we don't want it updating the code that is performing the updates
		if (path.includes('libs/cli/src/generators')) {
			return;
		}
		visitor(path);
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/add-dependent-primitive.ts
```typescript
import { prompt } from 'enquirer';
import { getDependentPrimitives } from './primivite-deps';
import type { Primitive } from './primivites';

export const addDependentPrimitives = async (primitivesToCreate: string[], shouldPrompt?: boolean) => {
	const dependentPrimitives = getDependentPrimitives(primitivesToCreate as Primitive[]);

	for await (const primitive of dependentPrimitives) {
		const promptName = `install${primitive.charAt(0).toUpperCase() + primitive.slice(1)}`;
		const installPrimitive = shouldPrompt
			? (
					await prompt({
						type: 'confirm',
						name: promptName,
						initial: true,
						message: `Some of the primitives you are trying to install depend on the ${primitive} primitive. Do you want to add it to your project?`,
					})
				)[promptName]
			: true;
		if (installPrimitive) {
			primitivesToCreate.push(primitive);
		}
	}
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/compat.ts
```typescript
import { convertNxGenerator } from '@nx/devkit';
import hlmUIGenerator from './generator';
import type { HlmUIGeneratorSchema } from './schema';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export default convertNxGenerator((tree: any, schema: HlmUIGeneratorSchema & { angularCli?: boolean }) =>
	hlmUIGenerator(tree, { ...schema, angularCli: true }),
);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/generator.ts
```typescript
import { type GeneratorCallback, type Tree, runTasksInSerial } from '@nx/devkit';
import { prompt } from 'enquirer';
import { Config, getOrCreateConfig } from '../../utils/config';
import { addDependentPrimitives } from './add-dependent-primitive';
import type { HlmUIGeneratorSchema } from './schema';

export default async function hlmUIGenerator(tree: Tree, options: HlmUIGeneratorSchema & { angularCli?: boolean }) {
	const tasks: GeneratorCallback[] = [];
	const config = await getOrCreateConfig(tree, {
		componentsPath: options.directory,
	});
	const availablePrimitives: PrimitiveDefinitions = await import('./supported-ui-libraries.json').then(
		(m) => m.default,
	);
	const availablePrimitiveNames = [...Object.keys(availablePrimitives), 'collapsible', 'menubar', 'contextmenu'];
	let response: { primitives: string[] } = { primitives: [] };
	if (options.name && availablePrimitiveNames.includes(options.name)) {
		response.primitives.push(options.name);
	} else {
		response = await prompt({
			type: 'multiselect',
			required: true,
			name: 'primitives',
			message: 'Choose which primitives you want to copy',
			choices: ['all', ...availablePrimitiveNames.sort()],
		});
	}
	tasks.push(
		...(await createPrimitiveLibraries(response, availablePrimitiveNames, availablePrimitives, tree, options, config)),
	);

	return runTasksInSerial(...tasks);
}

export async function createPrimitiveLibraries(
	response: {
		primitives: string[];
	},
	availablePrimitiveNames: string[],
	availablePrimitives: PrimitiveDefinitions,
	tree: Tree,
	options: HlmUIGeneratorSchema & { angularCli?: boolean; installPeerDependencies?: boolean },
	config: Config,
) {
	const allPrimitivesSelected = response.primitives.includes('all');
	const primitivesToCreate = allPrimitivesSelected ? availablePrimitiveNames : response.primitives;
	const tasks: GeneratorCallback[] = [];

	if (!response.primitives.includes('all') || options.installPeerDependencies) {
		await addDependentPrimitives(primitivesToCreate, false);
	}
	await replaceContextAndMenuBar(primitivesToCreate, allPrimitivesSelected);

	if (primitivesToCreate.length === 1 && primitivesToCreate[0] === 'collapsible') {
		return tasks;
	}

	// Use Promise.all() to handle parallel execution of primitive library creation tasks
	const installTasks = await Promise.all(
		primitivesToCreate.map(async (primitiveName) => {
			if (primitiveName === 'collapsible') return;

			const internalName = availablePrimitives[primitiveName].internalName;
			const peerDependencies = removeHelmKeys(availablePrimitives[primitiveName].peerDependencies);
			const { generator } = await import(
				// eslint-disable-next-line @typescript-eslint/ban-ts-comment
				// @ts-ignore
				`./libs/${internalName}/generator`
			);
			return generator(tree, {
				internalName: '',
				publicName: '',
				primitiveName: '',
				peerDependencies,
				directory: options.directory ?? config.componentsPath,
				tags: options.tags,
				rootProject: options.rootProject,
				angularCli: options.angularCli,
			});
		}),
	);

	tasks.push(...installTasks.filter(Boolean));

	return tasks;
}

const replaceContextAndMenuBar = async (primtivesToCreate: string[], silent = false) => {
	const contextIndex = primtivesToCreate.indexOf('contextmenu');
	if (contextIndex >= 0) {
		if (!silent) {
			await prompt({
				type: 'confirm',
				name: 'contextMenu',
				message: 'The context menu is implemented as part of the menu-helm primitive. Adding menu primitive.',
			});
		}
		primtivesToCreate.splice(contextIndex, 1);
	}
	const menubarIndex = primtivesToCreate.indexOf('menubar');
	if (menubarIndex >= 0) {
		if (!silent) {
			await prompt({
				type: 'confirm',
				name: 'menubar',
				message: 'The menubar is implemented as part of the menu-helm primitive. Adding menu primitive.',
			});
		}
		primtivesToCreate.splice(menubarIndex, 1);
	}
};

const removeHelmKeys = (obj: Record<string, string>) =>
	Object.fromEntries(Object.entries(obj).filter(([key]) => !key.toLowerCase().includes('helm')));

interface PrimitiveDefinitions {
	[componentName: string]: {
		internalName: string;
		peerDependencies: Record<string, string>;
	};
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/primivite-deps.ts
```typescript
import type { Primitive } from './primivites';

export const primitiveDependencies: Record<Primitive, Primitive[]> = {
	accordion: ['icon'],
	alert: ['icon'],
	alertdialog: ['button'],
	aspectratio: [],
	avatar: [],
	badge: [],
	breadcrumb: ['icon'],
	button: [],
	calendar: ['button', 'icon'],
	card: [],
	carousel: [],
	checkbox: ['icon'],
	collapsible: [],
	command: ['button', 'icon'],
	contextmenu: [],
	datepicker: ['calendar', 'icon', 'popover'],
	dialog: [],
	formfield: [],
	hovercard: [],
	icon: [],
	input: ['formfield'],
	label: [],
	menu: ['icon'],
	menubar: [],
	pagination: ['button', 'icon'],
	popover: [],
	progress: [],
	radiogroup: [],
	scrollarea: [],
	select: ['icon', 'formfield'],
	separator: [],
	sheet: [],
	skeleton: [],
	sonner: ['icon'],
	spinner: [],
	switch: [],
	table: [],
	tabs: [],
	toggle: [],
	tooltip: [],
};

export const getDependentPrimitives = (primitives: Primitive[]): Primitive[] => {
	const dependentPrimitives = new Set<Primitive>();

	for (const primitive of primitives) {
		const deps = primitiveDependencies[primitive] ?? [];
		for (const dep of deps) {
			if (!primitives.includes(dep)) {
				// only add the dependent primitive if it's not already in the list of primitives to create
				dependentPrimitives.add(dep);
			}
		}
	}

	return Array.from(dependentPrimitives);
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/primivites.ts
```typescript
export type Primitive =
	| 'accordion'
	| 'alert'
	| 'alertdialog'
	| 'aspectratio'
	| 'avatar'
	| 'badge'
	| 'breadcrumb'
	| 'button'
	| 'calendar'
	| 'card'
	| 'carousel'
	| 'checkbox'
	| 'collapsible'
	| 'command'
	| 'contextmenu'
	| 'datepicker'
	| 'dialog'
	| 'formfield'
	| 'hovercard'
	| 'icon'
	| 'input'
	| 'label'
	| 'menu'
	| 'menubar'
	| 'pagination'
	| 'popover'
	| 'progress'
	| 'radiogroup'
	| 'scrollarea'
	| 'select'
	| 'separator'
	| 'sheet'
	| 'skeleton'
	| 'sonner'
	| 'spinner'
	| 'switch'
	| 'table'
	| 'tabs'
	| 'toggle'
	| 'tooltip';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/schema.d.ts
```typescript
export interface HlmUIGeneratorSchema {
	name?: string;
	directory?: string;
	rootProject?: boolean;
	tags?: string;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/schema.json
```json
{
	"$schema": "http://json-schema.org/draft-07/schema",
	"$id": "HlmUIGeneratorSchema",
	"title": "",
	"type": "object",
	"properties": {
		"name": {
			"type": "string",
			"description": "Primitive name",
			"$default": {
				"$source": "argv",
				"index": 0
			}
		},
		"directory": {
			"type": "string",
			"description": "A directory where the libraries are placed.",
			"x-priority": "important"
		},
		"tags": {
			"type": "string",
			"description": "Add tags to the library (used for linting)."
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/supported-ui-libraries.json
```json
{
	"accordion": {
		"internalName": "ui-accordion-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@ng-icons/core": ">=29.0.0",
			"@ng-icons/lucide": ">=29.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
			"clsx": "^2.1.1"
		}
	},
	"alert": {
		"internalName": "ui-alert-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
			"class-variance-authority": "^0.7.0",
			"clsx": "^2.1.1"
		}
	},
	"alertdialog": {
		"internalName": "ui-alert-dialog-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"@spartan-ng/ui-button-helm": "0.0.1-alpha.381",
			"clsx": "^2.1.1"
		}
	},
	"aspectratio": {
		"internalName": "ui-aspect-ratio-helm",
		"peerDependencies": {
			"@angular/cdk": ">=19.0.0",
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"clsx": "^2.1.1"
		}
	},
	"avatar": {
		"internalName": "ui-avatar-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"class-variance-authority": "^0.7.0",
			"clsx": "^2.1.1"
		}
	},
	"badge": {
		"internalName": "ui-badge-helm",
		"peerDependencies": {
			"@angular/cdk": ">=19.0.0",
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"class-variance-authority": "^0.7.0",
			"clsx": "^2.1.1"
		}
	},
	"breadcrumb": {
		"internalName": "ui-breadcrumb-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@angular/router": ">=19.0.0",
			"@ng-icons/core": ">=29.0.0",
			"@ng-icons/lucide": ">=29.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
			"clsx": "^2.1.1"
		}
	},
	"button": {
		"internalName": "ui-button-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"class-variance-authority": "^0.7.0",
			"clsx": "^2.1.1"
		}
	},
	"calendar": {
		"internalName": "ui-calendar-helm",
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
	},
	"card": {
		"internalName": "ui-card-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"class-variance-authority": "^0.7.0",
			"clsx": "^2.1.1"
		}
	},
	"command": {
		"internalName": "ui-command-helm",
		"peerDependencies": {
			"@angular/cdk": ">=19.0.0",
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"@spartan-ng/ui-button-helm": "0.0.1-alpha.381",
			"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
			"clsx": "^2.1.1"
		}
	},
	"datepicker": {
		"internalName": "ui-date-picker-helm",
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
	},
	"dialog": {
		"internalName": "ui-dialog-helm",
		"peerDependencies": {
			"@angular/cdk": ">=19.0.0",
			"@angular/common": ">=19.0.0",
			"@angular/core": ">=19.0.0",
			"@ng-icons/core": ">=29.0.0",
			"@ng-icons/lucide": ">=29.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
			"clsx": "^2.1.1"
		}
	},
	"icon": {
		"internalName": "ui-icon-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0"
		}
	},
	"input": {
		"internalName": "ui-input-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@angular/forms": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"class-variance-authority": "^0.7.0",
			"clsx": "^2.1.1"
		}
	},
	"label": {
		"internalName": "ui-label-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"class-variance-authority": "^0.7.0",
			"clsx": "^2.1.1"
		}
	},
	"menu": {
		"internalName": "ui-menu-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@ng-icons/core": ">=29.0.0",
			"@ng-icons/lucide": ">=29.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
			"class-variance-authority": "^0.7.0",
			"clsx": "^2.1.1"
		}
	},
	"popover": {
		"internalName": "ui-popover-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"clsx": "^2.1.1"
		}
	},
	"progress": {
		"internalName": "ui-progress-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"clsx": "^2.1.1"
		}
	},
	"radiogroup": {
		"internalName": "ui-radio-group-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"clsx": "^2.1.1"
		}
	},
	"scrollarea": {
		"internalName": "ui-scroll-area-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"clsx": "^2.1.1",
			"ngx-scrollbar": ">=16.0.0"
		}
	},
	"separator": {
		"internalName": "ui-separator-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"clsx": "^2.1.1"
		}
	},
	"sheet": {
		"internalName": "ui-sheet-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@ng-icons/core": ">=29.0.0",
			"@ng-icons/lucide": ">=29.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
			"class-variance-authority": "^0.7.0",
			"clsx": "^2.1.1"
		}
	},
	"skeleton": {
		"internalName": "ui-skeleton-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"clsx": "^2.1.1"
		}
	},
	"spinner": {
		"internalName": "ui-spinner-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"class-variance-authority": "^0.7.0",
			"clsx": "^2.1.1"
		}
	},
	"switch": {
		"internalName": "ui-switch-helm",
		"peerDependencies": {
			"@angular/cdk": ">=19.0.0",
			"@angular/core": ">=19.0.0",
			"@angular/forms": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"clsx": "^2.1.1"
		}
	},
	"tabs": {
		"internalName": "ui-tabs-helm",
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
		}
	},
	"toggle": {
		"internalName": "ui-toggle-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"class-variance-authority": "^0.7.0",
			"clsx": "^2.1.1"
		}
	},
	"toggle-group": {
		"internalName": "ui-toggle-group-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.436",
			"class-variance-authority": "^0.7.0",
			"clsx": "^2.1.1"
		}
	},
	"typography": {
		"internalName": "ui-typography-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"clsx": "^2.1.1"
		}
	},
	"table": {
		"internalName": "ui-table-helm",
		"peerDependencies": {
			"@angular/common": ">=19.0.0",
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"clsx": "^2.1.1"
		}
	},
	"hovercard": {
		"internalName": "ui-hover-card-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"clsx": "^2.1.1"
		}
	},
	"checkbox": {
		"internalName": "ui-checkbox-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@angular/forms": ">=19.0.0",
			"@ng-icons/core": ">=29.0.0",
			"@ng-icons/lucide": ">=29.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
			"clsx": "^2.1.1"
		}
	},
	"tooltip": {
		"internalName": "ui-tooltip-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451"
		}
	},
	"pagination": {
		"internalName": "ui-pagination-helm",
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
		}
	},
	"carousel": {
		"internalName": "ui-carousel-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@ng-icons/core": ">=29.0.0",
			"@ng-icons/lucide": ">=29.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"@spartan-ng/ui-button-helm": "0.0.1-alpha.381",
			"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
			"clsx": "^2.1.1",
			"embla-carousel-angular": "19.0.0"
		}
	},
	"select": {
		"internalName": "ui-select-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@ng-icons/core": ">=29.0.0",
			"@ng-icons/lucide": ">=29.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
			"class-variance-authority": "^0.7.0",
			"clsx": "^2.1.1"
		}
	},
	"sonner": {
		"internalName": "ui-sonner-helm",
		"peerDependencies": {
			"@angular/common": "^18.1.0",
			"@angular/core": "^18.1.0",
			"@ng-icons/lucide": "^26.3.0",
			"@spartan-ng/brain": "0.0.1-alpha.381",
			"clsx": "^2.1.1",
			"ngx-sonner": "^3.0.0"
		}
	},
	"formfield": {
		"internalName": "ui-form-field-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451"
		}
	},
	"slider": {
		"internalName": "ui-slider-helm",
		"peerDependencies": {
			"@angular/core": ">=19.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"clsx": "^2.1.1"
		}
	},
	"togglegroup": {
		"internalName": "ui-toggle-group-helm",
		"peerDependencies": {
			"@angular/core": ">=18.0.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"class-variance-authority": "^0.7.0",
			"clsx": "^2.1.1"
		}
	},
	"inputotp": {
		"internalName": "ui-input-otp-helm",
		"peerDependencies": {
			"@angular/cdk": "19.2.2",
			"@angular/core": ">=19.0.0",
			"@ng-icons/core": "29.10.0",
			"@ng-icons/lucide": "30.3.0",
			"@spartan-ng/brain": "0.0.1-alpha.451",
			"@spartan-ng/ui-icon-helm": "0.0.1-alpha.381",
			"clsx": "^2.1.1"
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'pagination',
		internalName: 'ui-pagination-helm',
		publicName: 'ui-pagination-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-numbered-pagination.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-pagination-content.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-pagination-ellipsis.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-pagination-item.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-pagination-link.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-pagination-next.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-pagination-previous.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-pagination-helm/files/lib/hlm-pagination.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-table-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'table',
		internalName: 'ui-table-helm',
		publicName: 'ui-table-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-table-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-table-helm/files/lib/hlm-caption.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-table-helm/files/lib/hlm-table.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-table-helm/files/lib/hlm-table.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-table-helm/files/lib/hlm-td.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-table-helm/files/lib/hlm-th.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-table-helm/files/lib/hlm-trow.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tabs-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'tabs',
		internalName: 'ui-tabs-helm',
		publicName: 'ui-tabs-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tabs-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tabs-helm/files/lib/hlm-tabs-content.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tabs-helm/files/lib/hlm-tabs-list.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tabs-helm/files/lib/hlm-tabs-paginated-list.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tabs-helm/files/lib/hlm-tabs-trigger.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tabs-helm/files/lib/hlm-tabs.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-separator-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'separator',
		internalName: 'ui-separator-helm',
		publicName: 'ui-separator-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-separator-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';
import { HlmSeparatorDirective } from './lib/hlm-separator.directive';

export * from './lib/hlm-separator.directive';

@NgModule({
	imports: [HlmSeparatorDirective],
	exports: [HlmSeparatorDirective],
})
export class HlmSeparatorModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-separator-helm/files/lib/hlm-separator.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-toggle-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'toggle',
		internalName: 'ui-toggle-helm',
		publicName: 'ui-toggle-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-toggle-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';
import { HlmToggleDirective } from './lib/hlm-toggle.directive';

export * from './lib/hlm-toggle.directive';
@NgModule({
	imports: [HlmToggleDirective],
	exports: [HlmToggleDirective],
})
export class HlmToggleModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-toggle-helm/files/lib/hlm-toggle.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-select-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'select',
		internalName: 'ui-select-helm',
		publicName: 'ui-select-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-select-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-select-helm/files/lib/hlm-select-content.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-select-helm/files/lib/hlm-select-group.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-select-helm/files/lib/hlm-select-label.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-select-helm/files/lib/hlm-select-option.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-select-helm/files/lib/hlm-select-scroll-down.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-select-helm/files/lib/hlm-select-scroll-up.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-select-helm/files/lib/hlm-select-trigger.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-select-helm/files/lib/hlm-select-value.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-select-helm/files/lib/hlm-select.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-toggle-group-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'togglegroup',
		internalName: 'ui-toggle-group-helm',
		publicName: 'ui-togglegroup-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-toggle-group-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-toggle-group-helm/files/lib/hlm-toggle-group.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-toggle-group-helm/files/lib/hlm-toggle-group.token.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-toggle-group-helm/files/lib/hlm-toggle-item.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-card-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'card',
		internalName: 'ui-card-helm',
		publicName: 'ui-card-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-card-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-card-helm/files/lib/hlm-card-content.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-card-helm/files/lib/hlm-card-description.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-card-helm/files/lib/hlm-card-footer.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-card-helm/files/lib/hlm-card-header.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-card-helm/files/lib/hlm-card-title.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-card-helm/files/lib/hlm-card.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'menu',
		internalName: 'ui-menu-helm',
		publicName: 'ui-menu-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-menu-bar-item.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-menu-bar.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-menu-group.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-menu-item-check.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-menu-item-checkbox.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-menu-item-icon.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-menu-item-radio.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-menu-item-radio.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-menu-item-sub-indicator.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-menu-item.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-menu-label.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-menu-separator.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-menu-shortcut.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-menu.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-menu-helm/files/lib/hlm-sub-menu.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-hover-card-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'hovercard',
		internalName: 'ui-hover-card-helm',
		publicName: 'ui-hovercard-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-hover-card-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-hover-card-helm/files/lib/hlm-hover-card-content.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-icon-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'icon',
		internalName: 'ui-icon-helm',
		publicName: 'ui-icon-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-icon-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-icon-helm/files/lib/hlm-icon.directive.spec.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-icon-helm/files/lib/hlm-icon.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-icon-helm/files/lib/hlm-icon.token.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-spinner-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'spinner',
		internalName: 'ui-spinner-helm',
		publicName: 'ui-spinner-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-spinner-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';
import { HlmSpinnerComponent } from './lib/hlm-spinner.component';

export * from './lib/hlm-spinner.component';

@NgModule({
	imports: [HlmSpinnerComponent],
	exports: [HlmSpinnerComponent],
})
export class HlmSpinnerModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-spinner-helm/files/lib/hlm-spinner.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-badge-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'badge',
		internalName: 'ui-badge-helm',
		publicName: 'ui-badge-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-badge-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';
import { HlmBadgeDirective } from './lib/hlm-badge.directive';

export * from './lib/hlm-badge.directive';

@NgModule({
	imports: [HlmBadgeDirective],
	exports: [HlmBadgeDirective],
})
export class HlmBadgeModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-badge-helm/files/lib/hlm-badge.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tooltip-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'tooltip',
		internalName: 'ui-tooltip-helm',
		publicName: 'ui-tooltip-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tooltip-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tooltip-helm/files/lib/hlm-tooltip-trigger.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tooltip-helm/files/lib/hlm-tooltip.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'avatar',
		internalName: 'ui-avatar-helm',
		publicName: 'ui-avatar-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/hlm-avatar.component.spec.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/hlm-avatar.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/fallback/hlm-avatar-fallback.directive.spec.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/fallback/hlm-avatar-fallback.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/fallback/index.ts.template
```
export * from './hlm-avatar-fallback.directive';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/image/hlm-avatar-image.directive.spec.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/image/hlm-avatar-image.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/image/index.ts.template
```
export * from './hlm-avatar-image.directive';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-accordion-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'accordion',
		internalName: 'ui-accordion-helm',
		publicName: 'ui-accordion-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-accordion-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-accordion-helm/files/lib/hlm-accordion-content.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-accordion-helm/files/lib/hlm-accordion-icon.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-accordion-helm/files/lib/hlm-accordion-item.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-accordion-helm/files/lib/hlm-accordion-trigger.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-accordion-helm/files/lib/hlm-accordion.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-form-field-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'formfield',
		internalName: 'ui-form-field-helm',
		publicName: 'ui-formfield-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-form-field-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-form-field-helm/files/lib/form-field.spec.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-form-field-helm/files/lib/hlm-error.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-form-field-helm/files/lib/hlm-form-field.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-form-field-helm/files/lib/hlm-hint.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-dialog-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'alertdialog',
		internalName: 'ui-alert-dialog-helm',
		publicName: 'ui-alertdialog-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-dialog-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-dialog-helm/files/lib/hlm-alert-dialog-action-button.directive.ts.template
```
import { Directive } from '@angular/core';
import { HlmButtonDirective } from '@spartan-ng/ui-button-helm';

@Directive({
	selector: 'button[hlmAlertDialogAction]',
	standalone: true,
	hostDirectives: [HlmButtonDirective],
})
export class HlmAlertDialogActionButtonDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-dialog-helm/files/lib/hlm-alert-dialog-cancel-button.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-dialog-helm/files/lib/hlm-alert-dialog-content.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-dialog-helm/files/lib/hlm-alert-dialog-description.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-dialog-helm/files/lib/hlm-alert-dialog-footer.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-dialog-helm/files/lib/hlm-alert-dialog-header.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-dialog-helm/files/lib/hlm-alert-dialog-overlay.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-dialog-helm/files/lib/hlm-alert-dialog-title.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-dialog-helm/files/lib/hlm-alert-dialog.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-dialog-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'dialog',
		internalName: 'ui-dialog-helm',
		publicName: 'ui-dialog-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-dialog-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-dialog-helm/files/lib/hlm-dialog-close.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-dialog-helm/files/lib/hlm-dialog-content.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-dialog-helm/files/lib/hlm-dialog-description.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-dialog-helm/files/lib/hlm-dialog-footer.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-dialog-helm/files/lib/hlm-dialog-header.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-dialog-helm/files/lib/hlm-dialog-overlay.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-dialog-helm/files/lib/hlm-dialog-title.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-dialog-helm/files/lib/hlm-dialog.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-dialog-helm/files/lib/hlm-dialog.service.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-input-otp-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'inputotp',
		internalName: 'ui-input-otp-helm',
		publicName: 'ui-inputotp-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-input-otp-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-input-otp-helm/files/lib/hlm-input-otp-fake-caret.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-input-otp-helm/files/lib/hlm-input-otp-group.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-input-otp-helm/files/lib/hlm-input-otp-separator.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-input-otp-helm/files/lib/hlm-input-otp-slot.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-input-otp-helm/files/lib/hlm-input-otp.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-button-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'button',
		internalName: 'ui-button-helm',
		publicName: 'ui-button-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-button-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-button-helm/files/lib/hlm-button.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-button-helm/files/lib/hlm-button.token.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-label-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'label',
		internalName: 'ui-label-helm',
		publicName: 'ui-label-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-label-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';
import { HlmLabelDirective } from './lib/hlm-label.directive';

export * from './lib/hlm-label.directive';

@NgModule({
	imports: [HlmLabelDirective],
	exports: [HlmLabelDirective],
})
export class HlmLabelModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-label-helm/files/lib/hlm-label.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-breadcrumb-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'breadcrumb',
		internalName: 'ui-breadcrumb-helm',
		publicName: 'ui-breadcrumb-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-breadcrumb-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-breadcrumb-helm/files/lib/breadcrumb-ellipsis.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-breadcrumb-helm/files/lib/breadcrumb-item.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-breadcrumb-helm/files/lib/breadcrumb-link.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-breadcrumb-helm/files/lib/breadcrumb-list.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-breadcrumb-helm/files/lib/breadcrumb-page.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-breadcrumb-helm/files/lib/breadcrumb-separator.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-breadcrumb-helm/files/lib/breadcrumb.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'command',
		internalName: 'ui-command-helm',
		publicName: 'ui-command-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/files/lib/hlm-command-dialog-close-button.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/files/lib/hlm-command-dialog.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/files/lib/hlm-command-empty.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/files/lib/hlm-command-group-label.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/files/lib/hlm-command-group.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/files/lib/hlm-command-icon.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/files/lib/hlm-command-item.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/files/lib/hlm-command-list.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/files/lib/hlm-command-search-input.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/files/lib/hlm-command-search.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/files/lib/hlm-command-separator.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/files/lib/hlm-command-shortcut.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-command-helm/files/lib/hlm-command.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-slider-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'slider',
		internalName: 'ui-slider-helm',
		publicName: 'ui-slider-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-slider-helm/files/index.ts.template
```
export * from './lib/hlm-slider.component';
import { HlmSliderComponent } from './lib/hlm-slider.component';

export const HlmSliderImports = [HlmSliderComponent] as const;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-slider-helm/files/lib/hlm-slider.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-date-picker-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'datepicker',
		internalName: 'ui-date-picker-helm',
		publicName: 'ui-datepicker-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-date-picker-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-date-picker-helm/files/lib/hlm-date-picker-multi.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-date-picker-helm/files/lib/hlm-date-picker-multi.token.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-date-picker-helm/files/lib/hlm-date-picker.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-date-picker-helm/files/lib/hlm-date-picker.token.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-radio-group-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'radiogroup',
		internalName: 'ui-radio-group-helm',
		publicName: 'ui-radiogroup-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-radio-group-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-radio-group-helm/files/lib/hlm-radio-group.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-radio-group-helm/files/lib/hlm-radio-indicator.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-radio-group-helm/files/lib/hlm-radio.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-calendar-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'calendar',
		internalName: 'ui-calendar-helm',
		publicName: 'ui-calendar-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-calendar-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-calendar-helm/files/lib/hlm-calendar-multi.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-calendar-helm/files/lib/hlm-calendar.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-popover-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'popover',
		internalName: 'ui-popover-helm',
		publicName: 'ui-popover-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-popover-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-popover-helm/files/lib/hlm-popover-close.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-popover-helm/files/lib/hlm-popover-content.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'sheet',
		internalName: 'ui-sheet-helm',
		publicName: 'ui-sheet-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet-close.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet-content.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet-description.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet-footer.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet-header.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet-overlay.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet-title.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sheet-helm/files/lib/hlm-sheet.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-typography-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'typography',
		internalName: 'ui-typography-helm',
		publicName: 'ui-typography-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-typography-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-typography-helm/files/lib/hlm-blockquote.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-typography-helm/files/lib/hlm-code.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-typography-helm/files/lib/hlm-h1.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-typography-helm/files/lib/hlm-h2.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-typography-helm/files/lib/hlm-h3.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-typography-helm/files/lib/hlm-h4.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-typography-helm/files/lib/hlm-large.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-typography-helm/files/lib/hlm-lead.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-typography-helm/files/lib/hlm-muted.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-typography-helm/files/lib/hlm-p.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-typography-helm/files/lib/hlm-small.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-typography-helm/files/lib/hlm-ul.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-scroll-area-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'scrollarea',
		internalName: 'ui-scroll-area-helm',
		publicName: 'ui-scrollarea-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-scroll-area-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';
import { HlmScrollAreaDirective } from './lib/hlm-scroll-area.directive';

export * from './lib/hlm-scroll-area.directive';

@NgModule({
	imports: [HlmScrollAreaDirective],
	exports: [HlmScrollAreaDirective],
})
export class HlmScrollAreaModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-scroll-area-helm/files/lib/hlm-scroll-area.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'alert',
		internalName: 'ui-alert-helm',
		publicName: 'ui-alert-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-helm/files/lib/hlm-alert-description.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-helm/files/lib/hlm-alert-icon.directive.ts.template
```
import { Directive } from '@angular/core';
import { provideHlmIconConfig } from '@spartan-ng/ui-icon-helm';

@Directive({
	selector: '[hlmAlertIcon]',
	standalone: true,
	providers: [provideHlmIconConfig({ size: 'sm' })],
})
export class HlmAlertIconDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-helm/files/lib/hlm-alert-title.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-alert-helm/files/lib/hlm-alert.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-skeleton-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'skeleton',
		internalName: 'ui-skeleton-helm',
		publicName: 'ui-skeleton-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-skeleton-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';
import { HlmSkeletonComponent } from './lib/hlm-skeleton.component';

export * from './lib/hlm-skeleton.component';

@NgModule({
	imports: [HlmSkeletonComponent],
	exports: [HlmSkeletonComponent],
})
export class HlmSkeletonModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-skeleton-helm/files/lib/hlm-skeleton.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sonner-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'sonner',
		internalName: 'ui-sonner-helm',
		publicName: 'ui-sonner-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sonner-helm/files/index.ts.template
```
export * from './lib/hlm-toaster.component';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-sonner-helm/files/lib/hlm-toaster.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-aspect-ratio-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'aspectratio',
		internalName: 'ui-aspect-ratio-helm',
		publicName: 'ui-aspectratio-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-aspect-ratio-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';
import { HlmAspectRatioDirective } from './lib/helm-aspect-ratio.directive';

export * from './lib/helm-aspect-ratio.directive';

@NgModule({
	imports: [HlmAspectRatioDirective],
	exports: [HlmAspectRatioDirective],
})
export class HlmAspectRatioModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-aspect-ratio-helm/files/lib/helm-aspect-ratio.directive.spec.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-aspect-ratio-helm/files/lib/helm-aspect-ratio.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-progress-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'progress',
		internalName: 'ui-progress-helm',
		publicName: 'ui-progress-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-progress-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-progress-helm/files/lib/hlm-progress-indicator.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-progress-helm/files/lib/hlm-progress.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-switch-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'switch',
		internalName: 'ui-switch-helm',
		publicName: 'ui-switch-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-switch-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-switch-helm/files/lib/hlm-switch-ng-model.component.ignore.spec.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-switch-helm/files/lib/hlm-switch-thumb.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-switch-helm/files/lib/hlm-switch.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-checkbox-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'checkbox',
		internalName: 'ui-checkbox-helm',
		publicName: 'ui-checkbox-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-checkbox-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-checkbox-helm/files/lib/hlm-checkbox.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-input-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'input',
		internalName: 'ui-input-helm',
		publicName: 'ui-input-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-input-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-input-helm/files/lib/hlm-input-error.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-input-helm/files/lib/hlm-input.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-carousel-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'carousel',
		internalName: 'ui-carousel-helm',
		publicName: 'ui-carousel-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-carousel-helm/files/index.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-carousel-helm/files/lib/hlm-carousel-content.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-carousel-helm/files/lib/hlm-carousel-item.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-carousel-helm/files/lib/hlm-carousel-next.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-carousel-helm/files/lib/hlm-carousel-previous.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-carousel-helm/files/lib/hlm-carousel.component.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-radio/compat.ts
```typescript
import { convertNxGenerator } from '@nx/devkit';
import migrateRadioGenerator from './generator';

export default convertNxGenerator(migrateRadioGenerator);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-radio/generator.spec.ts
```typescript
import { applicationGenerator, E2eTestRunner, UnitTestRunner } from '@nx/angular/generators';
import { Tree } from '@nx/devkit';
import { createTreeWithEmptyWorkspace } from '@nx/devkit/testing';
import { migrateRadioGenerator } from './generator';

// patch some imports to avoid running the actual code
jest.mock('enquirer');
jest.mock('@nx/devkit', () => {
	const original = jest.requireActual('@nx/devkit');
	return {
		...original,
		ensurePackage: (pkg: string) => jest.requireActual(pkg),
		createProjectGraphAsync: jest.fn().mockResolvedValue({
			nodes: {},
			dependencies: {},
		}),
	};
});

describe('migrate-radio generator', () => {
	let tree: Tree;

	beforeEach(async () => {
		tree = createTreeWithEmptyWorkspace();

		await applicationGenerator(tree, {
			name: 'app',
			directory: 'app',
			skipFormat: true,
			e2eTestRunner: E2eTestRunner.None,
			unitTestRunner: UnitTestRunner.None,
			skipPackageJson: true,
			skipTests: true,
		});
	});

	it('should remove BrnRadioComponent and replace HlmRadioDirective with HlmRadioComponent (NgModule)', async () => {
		tree.write(
			'app/src/app/app.module.ts',
			`
			import { NgModule } from '@angular/core';
			import { BrowserModule } from '@angular/platform-browser';
			import { BrnRadioComponent } from '@spartan-ng/brain/radio-group';
			import { HlmRadioDirective, HlmRadioGroupComponent } from '@spartan-ng/ui-radiogroup-helm';

			@NgModule({
				imports: [BrowserModule, BrnRadioComponent, HlmRadioDirective, HlmRadioGroupComponent],
			})
			export class AppModule {}
			`,
		);

		await migrateRadioGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.module.ts', 'utf-8');
		expect(content).not.toContain(`import { BrnRadioComponent } from '@spartan-ng/brain/radio-group';`);
		expect(content).toContain(
			`import { HlmRadioComponent, HlmRadioGroupComponent } from '@spartan-ng/ui-radiogroup-helm';`,
		);
		expect(content).toContain(`imports: [BrowserModule, HlmRadioComponent, HlmRadioGroupComponent],`);
	});

	it('should replace BrnRadioComponent template (Standalone)', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
				import { Component } from '@angular/core';
				import { BrnRadioComponent } from '@spartan-ng/brain/radio-group';
				import { HlmRadioDirective, HlmRadioGroupComponent } from '@spartan-ng/ui-radiogroup-helm';
				@Component({
					imports: [BrnRadioComponent, HlmRadioDirective, HlmRadioGroupComponent],
					template: \`
						<hlm-radio-group class="font-mono text-sm font-medium" [(ngModel)]="version">
							<brn-radio hlm value="16.1.4">
								v16.1.4
							</brn-radio>
						</hlm-radio-group>
					\`
				})
				export class AppModule {}
				`,
		);

		await migrateRadioGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).not.toContain(`import { BrnRadioComponent } from '@spartan-ng/brain/radio-group';`);
		expect(content).toContain(
			`import { HlmRadioComponent, HlmRadioGroupComponent } from '@spartan-ng/ui-radiogroup-helm';`,
		);
		expect(content).toContain(`imports: [HlmRadioComponent, HlmRadioGroupComponent],`);
		expect(content).toContain(`<hlm-radio value="16.1.4">`);
	});
	it('should replace BrnRadioComponent also if the hlm is not directly after the brn-radio tag (Standalone)', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
				import { Component } from '@angular/core';
				import { BrnRadioComponent } from '@spartan-ng/brain/radio-group';
				import { HlmRadioDirective, HlmRadioGroupComponent } from '@spartan-ng/ui-radiogroup-helm';

				@Component({
					imports: [BrnRadioComponent, HlmRadioDirective, HlmRadioGroupComponent],
					template: \`
						<hlm-radio-group class="font-mono text-sm font-medium" [(ngModel)]="version">
							<brn-radio
			hlm
value="16.1.5">
								should be replaced 1
							</brn-radio>
							<brn-radio class="hlm" value="16.1.4">
								should not be replaced
							</brn-radio>
							<brn-radio class="hlm replace-me" value="hlm" hlm>
								should be replaced 2
							</brn-radio>

						</hlm-radio-group>
					\`
				})
				export class AppModule {}
				`,
		);

		await migrateRadioGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`<brn-radio class="hlm" value="16.1.4">`);
		expect(content).toContain(`<hlm-radio class="hlm replace-me" value="hlm">`);
		expect(content).toContain(`<hlm-radio value="16.1.5">`);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-radio/generator.ts
```typescript
import { formatFiles, Tree } from '@nx/devkit';
import { visitFiles } from '../../utils/visit-files';
import { MigrateRadioGeneratorSchema } from './schema';

export async function migrateRadioGenerator(tree: Tree, { skipFormat }: MigrateRadioGeneratorSchema) {
	updateImports(tree);
	replaceSelector(tree);

	if (!skipFormat) {
		await formatFiles(tree);
	}
}

function replaceSelector(tree: Tree) {
	// if the element is `<brn-radio hlm` then we need to replace it with `<hlm-radio`
	// we also need to replace the closing tag `</brn-radio>` with `</hlm-radio>`
	visitFiles(tree, '.', (path) => {
		// if this is not an html file or typescript file (inline templates) then skip
		if (!path.endsWith('.html') && !path.endsWith('.ts')) {
			return;
		}

		let content = tree.read(path, 'utf-8');

		if (!content) {
			return;
		}

		// <brn-radio hlm but between
		content = replaceBrnRadioHlm(content);
		content = content.replace(/<\/brn-radio>/g, '</hlm-radio>');

		tree.write(path, content);
	});
}

function replaceBrnRadioHlm(input) {
	// Split input to handle multiple tags separately
	return input
		.split(/(?=<)/)
		.map((tag) => {
			// Skip if not a brn-radio tag
			if (!tag.startsWith('<brn-radio')) {
				return tag;
			}

			// Remove line breaks, tabs, and other whitespace within the tag
			// Replace with a single space
			tag = tag.replace(/\s+/g, ' ');

			// Check if standalone hlm attribute exists
			const hasHlm = / hlm(?=[\s>])/.test(tag);

			if (hasHlm) {
				// Remove the hlm attribute and convert to hlm-radio
				return tag
					.replace(/<brn-radio/, '<hlm-radio')
					.replace(/ hlm(?=[\s>])/, '')
					.replace(/\s+>/g, '>')
					.replace(/\s+/g, ' ');
			}

			return tag;
		})
		.join('');
}
/**
 * Update imports remove BrnRadioComponent import and replace HlmRadioDirective with HlmRadioComponent
 */
function updateImports(tree: Tree) {
	visitFiles(tree, '/', (path) => {
		const content = tree.read(path).toString('utf-8');

		if (content.includes('@spartan-ng/brain/radio-group') || content.includes('@spartan-ng/ui-radiogroup-helm')) {
			const updatedContent = content
				// Handle `import { BrnRadioComponent } from '@spartan-ng/brain/radio-group';`
				.replace("import { BrnRadioComponent } from '@spartan-ng/brain/radio-group';", '')
				// Remove `BrnRadioComponent` with optional comma and whitespace
				.replace(/BrnRadioComponent,?\s?/, '')
				// Replace all `HlmRadioDirective` with `HlmRadioComponent`
				.replaceAll('HlmRadioDirective', 'HlmRadioComponent');

			tree.write(path, updatedContent);
		}
	});
}

export default migrateRadioGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-radio/schema.d.ts
```typescript
export interface MigrateRadioGeneratorSchema {
	skipFormat?: boolean;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-radio/schema.json
```json
{
	"$schema": "https://json-schema.org/schema",
	"$id": "MigrateRadio",
	"title": "",
	"type": "object",
	"properties": {
		"skipFormat": {
			"type": "boolean",
			"default": false,
			"description": "Skip formatting files"
		}
	},
	"required": []
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-icon/compat.ts
```typescript
import { convertNxGenerator } from '@nx/devkit';
import { migrateIconGenerator } from './generator';

export default convertNxGenerator(migrateIconGenerator);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-icon/generator.spec.ts
```typescript
import { applicationGenerator, E2eTestRunner, UnitTestRunner } from '@nx/angular/generators';
import { Tree } from '@nx/devkit';
import { createTreeWithEmptyWorkspace } from '@nx/devkit/testing';
import { migrateIconGenerator } from './generator';

// patch some imports to avoid running the actual code
jest.mock('enquirer');
jest.mock('@nx/devkit', () => {
	const original = jest.requireActual('@nx/devkit');
	return {
		...original,
		ensurePackage: (pkg: string) => jest.requireActual(pkg),
		createProjectGraphAsync: jest.fn().mockResolvedValue({
			nodes: {},
			dependencies: {},
		}),
	};
});

describe('migrate-icon generator', () => {
	let tree: Tree;

	beforeEach(async () => {
		tree = createTreeWithEmptyWorkspace();

		await applicationGenerator(tree, {
			name: 'app',
			directory: 'app',
			skipFormat: true,
			e2eTestRunner: E2eTestRunner.None,
			unitTestRunner: UnitTestRunner.None,
			skipPackageJson: true,
			skipTests: true,
		});
	});

	it('should add NgIcon import (NgModule)', async () => {
		tree.write(
			'app/src/app/app.module.ts',
			`
			import { NgModule } from '@angular/core';
			import { BrowserModule } from '@angular/platform-browser';
			import { HlmIconModule } from '@spartan-ng/ui-icon-helm';

			@NgModule({
				imports: [BrowserModule, HlmIconModule],
			})
			export class AppModule {}
			`,
		);

		await migrateIconGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.module.ts', 'utf-8');
		expect(content).toContain(`import { NgIcon } from '@ng-icons/core';`);
		expect(content).toContain(`imports: [BrowserModule, NgIcon, HlmIconModule],`);
	});

	it('should replace HlmIconComponent (NgModule)', async () => {
		tree.write(
			'app/src/app/app.module.ts',
			`
			import { NgModule } from '@angular/core';
			import { BrowserModule } from '@angular/platform-browser';
			import { HlmIconComponent } from '@spartan-ng/ui-icon-helm';

			@NgModule({
				imports: [BrowserModule, HlmIconComponent],
			})
			export class AppModule {}
			`,
		);

		await migrateIconGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.module.ts', 'utf-8');
		expect(content).toContain(`import { NgIcon } from '@ng-icons/core';`);
		expect(content).toContain(`imports: [BrowserModule, NgIcon, HlmIconDirective],`);
	});

	it('should add NgIcon import (Standalone)', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';
			import { HlmIconModule } from '@spartan-ng/ui-icon-helm';

			@Component({
				imports: [HlmIconModule],
				template: \`
					<hlm-icon size='xl' name="lucideChevronRight" />
				\`
			})
			export class AppModule {}

			`,
		);

		await migrateIconGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`import { NgIcon } from '@ng-icons/core';`);
		expect(content).toContain(`imports: [NgIcon, HlmIconModule],`);
		expect(content).toContain(`<ng-icon hlm size='xl' name="lucideChevronRight" />`);
	});

	it('should replace HlmIconComponent (Standalone)', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';
			import { HlmIconComponent } from '@spartan-ng/ui-icon-helm';

			@Component({
				imports: [HlmIconComponent],
				template: \`
					<hlm-icon size='xl' name="lucideChevronRight" />
				\`
			})
			export class AppModule {}

			`,
		);

		await migrateIconGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`import { NgIcon } from '@ng-icons/core';`);
		expect(content).toContain(`import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';`);
		expect(content).toContain(`imports: [NgIcon, HlmIconDirective],`);
		expect(content).toContain(`<ng-icon hlm size='xl' name="lucideChevronRight" />`);
	});

	it('should re-write the provideIcons import', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';
			import { provideIcons } from '@spartan-ng/ui-icon-helm';
			import { lucideChevronRight } from '@ng-icons/lucide';

			@Component({
				providers: [provideIcons({ lucideChevronRight })],
			})
			export class AppComponent {}
			`,
		);

		await migrateIconGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`import { provideIcons } from '@ng-icons/core';`);
		expect(content).toContain(`providers: [provideIcons({ lucideChevronRight })],`);
	});

	it('should add the name attribute for accordion icons', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';

			@Component({
				template: \`
					<hlm-icon hlmAccIcon name="lucideChevronDown" />
				\`
			})
			export class AppComponent {}

			`,
		);

		await migrateIconGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`<ng-icon hlm hlmAccIcon name="lucideChevronDown" />`);
	});

	it('should convert tailwind width, height and size classes', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';

			@Component({
				template: \`
					<hlm-icon size="sm" name="lucideChevronRight" />
					<hlm-icon size="base" name="lucideChevronRight" />
					<hlm-icon size="lg" name="lucideChevronRight" />
					<hlm-icon size="6px" name="lucideChevronRight" />
					<hlm-icon size="8px" class="text-red-500" name="lucideChevronRight" />
					<hlm-icon size="sm" class="ml-2" name="lucideChevronUp" />
				\`
			})
			export class AppComponent {}

			`,
		);

		await migrateIconGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`<ng-icon hlm size="sm" name="lucideChevronRight" />`);
		expect(content).toContain(`<ng-icon hlm size="base" name="lucideChevronRight" />`);
		expect(content).toContain(`<ng-icon hlm size="lg" name="lucideChevronRight" />`);
		expect(content).toContain(`<ng-icon hlm size="6px" name="lucideChevronRight" />`);
		expect(content).toContain(`<ng-icon hlm size="8px" class="text-red-500" name="lucideChevronRight" />`);
		expect(content).toContain(`<ng-icon hlm size="sm" class="ml-2" name="lucideChevronUp" />`);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-icon/generator.ts
```typescript
import { formatFiles, Tree } from '@nx/devkit';
import { applyChangesToString, ChangeType, StringChange } from '@nx/devkit/src/utils/string-change';
import { isImported } from '@schematics/angular/utility/ast-utils';
import ts from 'typescript';
import { visitFiles } from '../../utils/visit-files';
import { MigrateIconGeneratorSchema } from './schema';

export async function migrateIconGenerator(tree: Tree, { skipFormat }: MigrateIconGeneratorSchema) {
	replaceImports(tree);
	replaceSelector(tree);
	replaceProvideIcons(tree);
	addAccordionIcon(tree);
	replaceTailwindClasses(tree);

	if (!skipFormat) {
		await formatFiles(tree);
	}
}

function replaceTailwindClasses(tree: Tree) {
	visitFiles(tree, '.', (path) => {
		// if this is not a html or typescript file then skip
		if (!path.endsWith('.ts') && !path.endsWith('.html')) {
			return;
		}

		let content = tree.read(path, 'utf-8');

		// if there are no icons then skip
		if (!content || !content.includes('ng-icon')) {
			return;
		}

		const changes: StringChange[] = [];

		const regex = /<ng-icon\b[^>]*>/g;

		let match;

		while ((match = regex.exec(content)) !== null) {
			const startIndex = match.index;

			// if there already is a size attribute then skip
			if (match[0].includes('size=')) {
				continue;
			}

			// get the class attribute
			const classMatch = match[0].match(/class="([^"]*)"/);

			if (!classMatch) {
				continue;
			}

			const className = classMatch[1];

			// get each class in the class attribute
			const classes = className.split(' ');

			// find any known size
			const size = classes.find((c: string) => tailwindToSize(c) !== null);

			if (!size) {
				continue;
			}

			const sizeValue = tailwindToSize(size);

			// remove the size class
			let output = match[0]
				.replace(/\b(w|h|size)-\S+\b/g, '')
				.replace(/class=(["'])(\s*)(.+?)(\s*)\1/g, 'class=$1$3$1')
				.replace(/\s*class="\s*"\s*/g, ' ');

			// add the size attribute
			output = output.replace(' hlm ', ` hlm size="${sizeValue}" `);

			// delete the original line
			changes.push({
				type: ChangeType.Delete,
				start: startIndex,
				length: match[0].length,
			});

			// insert the new line
			changes.push({
				type: ChangeType.Insert,
				index: startIndex,
				text: output,
			});
		}

		content = applyChangesToString(content, changes);

		tree.write(path, content);
	});
}

function tailwindToSize(className: string): string | null {
	// if this is not a width, height or size class then skip
	if (/\b(w|h|size)-\S+\b/.test(className) === false) {
		return null;
	}

	const [, value] = className.split('-');

	// Handle specific Tailwind keywords
	const keywordMapping = {
		full: '100%',
		screen: '100vw',
		auto: 'auto',
		min: 'min-content',
		max: 'max-content',
		fit: 'fit-content',
	};

	// Check if value is a keyword
	if (keywordMapping[value]) {
		return `${keywordMapping[value]};`;
	}

	// Convert numeric values to a number
	const numericValue = parseFloat(value);

	if (!isNaN(numericValue)) {
		const px = numericValue * 4;

		switch (px) {
			case 12:
				return 'xs';
			case 16:
				return 'sm';
			case 24:
				return 'base';
			case 32:
				return 'lg';
			case 48:
				return 'xl';
		}

		return `${px}px`;
	}

	// Handle other cases
	return null;
}

function addAccordionIcon(tree: Tree) {
	visitFiles(tree, '.', (path) => {
		// if this is not a html or typescript file then skip
		if (!path.endsWith('.ts') && !path.endsWith('.html')) {
			return;
		}

		let content = tree.read(path, 'utf-8');

		if (!content) {
			return;
		}

		// if there is no hlmAccIcon or hlmAccordionIcon then skip
		if (!content.includes('hlmAccIcon') && !content.includes('hlmAccordionIcon')) {
			return;
		}

		const changes: StringChange[] = [];

		// if an element is using hlmAccIcon or hlmAccordionIcon and has no name attribute then add the name attribute
		const regex = /<ng-icon\b[^>]*(\bhlmAccIcon\b|\bhlmAccordionIcon\b)[^>]*>/g;

		let match;
		const results: { match: string; index: number }[] = [];

		while ((match = regex.exec(content)) !== null) {
			results.push({ match: match[0], index: match.index });
		}

		if (!results.length) {
			return;
		}

		for (const { match, index } of results) {
			if (!match.includes('name=')) {
				const directive = match.includes('hlmAccIcon') ? 'hlmAccIcon' : 'hlmAccordionIcon';

				const startIndex = index + match.indexOf(directive);

				changes.push({
					type: ChangeType.Insert,
					index: startIndex + directive.length,
					text: ` name="lucideChevronDown"`,
				});
			}
		}

		content = applyChangesToString(content, changes);

		tree.write(path, content);
	});
}

function replaceProvideIcons(tree: Tree) {
	visitFiles(tree, '.', (path) => {
		// if this is not a typescript file then skip
		if (!path.endsWith('.ts')) {
			return;
		}

		let content = tree.read(path, 'utf-8');

		// if the user is importing `provideIcons` from '@spartan-ng/ui-icon-helm' then we need to replace it with `provideIcons` from '@ng-icons/core'
		if (!content || !content?.includes('provideIcons')) {
			return;
		}

		const sourceFile = ts.createSourceFile(path, content, ts.ScriptTarget.Latest, true);

		if (!isImported(sourceFile, 'provideIcons', '@spartan-ng/ui-icon-helm')) {
			return;
		}

		const changes: StringChange[] = [];

		// remove the import of provideIcons from '@spartan-ng/ui-icon-helm'
		// add the import of provideIcons from '@ng-icons/core'
		changes.push({
			type: ChangeType.Delete,
			start: content.indexOf('provideIcons'),
			length: 'provideIcons'.length,
		});

		changes.push({
			type: ChangeType.Insert,
			index: 0,
			text: `import { provideIcons } from '@ng-icons/core';\n`,
		});

		content = applyChangesToString(content, changes);

		tree.write(path, content);
	});
}

function replaceSelector(tree: Tree) {
	// if the element is `<ng-icon hlm` then we need to replace it with `<ng-icon hlm`
	// we also need to replace the closing tag `</ng-icon>` with `</ng-icon>`
	visitFiles(tree, '.', (path) => {
		// if this is not an html file or typescript file (inline templates) then skip
		if (!path.endsWith('.html') && !path.endsWith('.ts')) {
			return;
		}

		let content = tree.read(path, 'utf-8');

		if (!content) {
			return;
		}

		content = content.replace(/<hlm-icon/g, '<ng-icon hlm');
		content = content.replace(/<\/hlm-icon>/g, '</ng-icon>');

		tree.write(path, content);
	});
}

function replaceImports(tree: Tree) {
	// ng modules or standalone components will have import arrays that may need updated.
	// if the import is `HlmIconModule` then we need to also import `NgIcon`,
	// if the import is `HlmIconComponent` we need to rename it to `HlmIconDirective` and add the `NgIcon` import.
	visitFiles(tree, '.', (path) => {
		// if the file is not a typescript file then skip
		if (!path.endsWith('.ts')) {
			return;
		}

		let content = tree.read(path, 'utf-8');

		if (!content) {
			return;
		}

		// convert the content to an ast
		const sourceFile = ts.createSourceFile(path, content, ts.ScriptTarget.Latest, true);

		// find all imports of HlmIconModule or HlmIconComponent
		const imports = findHlmIconImports(sourceFile);

		// if no imports are found then skip
		if (imports.length === 0) {
			return;
		}

		const changes: StringChange[] = [];

		for (const identifier of imports) {
			// if the identifier is HlmIconModule then we need to add NgIcon to the imports
			if (identifier.getText() === 'HlmIconModule') {
				changes.push({
					type: ChangeType.Insert,
					index: identifier.getStart(),
					text: 'NgIcon, ',
				});
			}

			// if the identifier is HlmIconComponent then we need to rename it to HlmIconDirective and add NgIcon to the imports
			if (identifier.getText() === 'HlmIconComponent') {
				changes.push({
					type: ChangeType.Insert,
					index: identifier.getStart(),
					text: 'NgIcon, ',
				});
			}

			// check if the NgIcon import is already present
			if (!hasImport(content, 'NgIcon', '@ng-icons/core')) {
				changes.push({
					type: ChangeType.Insert,
					index: 0,
					text: `import { NgIcon } from '@ng-icons/core';\n`,
				});
			}
		}

		content = applyChangesToString(content, changes);

		// if there are any remaining uses of HlmIconComponent then replace them with HlmIconDirective
		content = content.replace(/HlmIconComponent/g, 'HlmIconDirective');

		tree.write(path, content);
	});
}

function findHlmIconImports(node: ts.SourceFile): ts.Node[] {
	const matches: ts.Identifier[] = [];

	const visit = (node: ts.Node) => {
		if (
			ts.isPropertyAssignment(node) &&
			node.name.getText() === 'imports' &&
			ts.isArrayLiteralExpression(node.initializer)
		) {
			// check if the array literal contains the HlmIconModule or HlmIconComponent
			node.initializer.elements.forEach((element) => {
				if (ts.isIdentifier(element)) {
					if (element.getText() === 'HlmIconModule' || element.getText() === 'HlmIconComponent') {
						matches.push(element);
					}
				}
			});
		}

		ts.forEachChild(node, visit);
	};

	visit(node);

	return matches;
}

function hasImport(contents: string, importName: string, importPath: string): boolean {
	const sourceFile = ts.createSourceFile('temp.ts', contents, ts.ScriptTarget.Latest, true);
	return isImported(sourceFile, importName, importPath);
}

export default migrateIconGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-icon/schema.d.ts
```typescript
export interface MigrateIconGeneratorSchema {
	skipFormat?: boolean;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-icon/schema.json
```json
{
	"$schema": "https://json-schema.org/schema",
	"$id": "MigrateIcon",
	"title": "",
	"type": "object",
	"properties": {
		"skipFormat": {
			"type": "boolean",
			"default": false,
			"description": "Skip formatting files"
		}
	},
	"required": []
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-select/compat.ts
```typescript
import { convertNxGenerator } from '@nx/devkit';
import migrateSelectGenerator from './generator';

export default convertNxGenerator(migrateSelectGenerator);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-select/generator.spec.ts
```typescript
import { applicationGenerator, E2eTestRunner, UnitTestRunner } from '@nx/angular/generators';
import { Tree } from '@nx/devkit';
import { createTreeWithEmptyWorkspace } from '@nx/devkit/testing';
import { migrateSelectGenerator } from './generator';

// patch some imports to avoid running the actual code
jest.mock('enquirer');
jest.mock('@nx/devkit', () => {
	const original = jest.requireActual('@nx/devkit');
	return {
		...original,
		ensurePackage: (pkg: string) => jest.requireActual(pkg),
		createProjectGraphAsync: jest.fn().mockResolvedValue({
			nodes: {},
			dependencies: {},
		}),
	};
});

describe('migrate-select generator', () => {
	let tree: Tree;

	beforeEach(async () => {
		tree = createTreeWithEmptyWorkspace();

		await applicationGenerator(tree, {
			name: 'app',
			directory: 'app',
			skipFormat: true,
			e2eTestRunner: E2eTestRunner.None,
			unitTestRunner: UnitTestRunner.None,
			skipPackageJson: true,
			skipTests: true,
		});
	});

	it('should rename (openedChange) to (openChange) on select elements', async () => {
		tree.write(
			'app/src/app/app.component.html',
			`
				<brn-select (openedChange)="onOpenedChange($event)"></brn-select>
				<brn-select (openedChange)="onOpenedChange($event)" />
				<brn-select hlm (openedChange)="onOpenedChange($event)"></brn-select>
				<brn-select hlm (openedChange)="onOpenedChange($event)" />
				<hlm-select (openedChange)="onOpenedChange($event)"></hlm-select>
				<hlm-select (openedChange)="onOpenedChange($event)" />

				<!-- This is not a select, so it should not be changed -->
				<div (openedChange)="onOpenedChange($event)"></div>
			`,
		);

		await migrateSelectGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.html', 'utf-8');
		expect(content).toBe(`
				<brn-select (openChange)="onOpenedChange($event)"></brn-select>
				<brn-select (openChange)="onOpenedChange($event)" />
				<brn-select hlm (openChange)="onOpenedChange($event)"></brn-select>
				<brn-select hlm (openChange)="onOpenedChange($event)" />
				<hlm-select (openChange)="onOpenedChange($event)"></hlm-select>
				<hlm-select (openChange)="onOpenedChange($event)" />

				<!-- This is not a select, so it should not be changed -->
				<div (openedChange)="onOpenedChange($event)"></div>
			`);
	});

	it('should migrate the hlm-select-option classes', () => {
		tree.write(
			'app/src/app/hlm-select-option.component.ts',
			`import { ChangeDetectionStrategy, Component, computed, inject, input } from '@angular/core';
			import { NgIcon, provideIcons } from '@ng-icons/core';
			import { lucideCheck } from '@ng-icons/lucide';
			import { hlm } from '@spartan-ng/brain/core';
			import { BrnSelectOptionDirective } from '@spartan-ng/brain/select';
			import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
			import type { ClassValue } from 'clsx';

			@Component({
				selector: 'hlm-option',
				standalone: true,
				changeDetection: ChangeDetectionStrategy.OnPush,
				hostDirectives: [{ directive: BrnSelectOptionDirective, inputs: ['disabled', 'value'] }],
				providers: [provideIcons({ lucideCheck })],
				host: {
					'[class]': '_computedClass()',
				},
				template: \`
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
				\`,
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
			`,
		);

		migrateSelectGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/hlm-select-option.component.ts', 'utf-8');

		// extract the string literal from the hlm function
		const matches = content.match(/hlm\(\s*(['"])(.*?)\1/s);
		const classes = matches[2];

		expect(classes).toBe(
			'relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 rtl:flex-reverse rtl:pr-8 rtl:pl-2 text-sm outline-none data-[active]:bg-accent data-[active]:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50',
		);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-select/generator.ts
```typescript
import { formatFiles, Tree } from '@nx/devkit';
import { updateHelmClasses } from '../../utils/hlm-class';
import { visitFiles } from '../../utils/visit-files';
import { MigrateSelectGeneratorSchema } from './schema';

export async function migrateSelectGenerator(tree: Tree, { skipFormat }: MigrateSelectGeneratorSchema) {
	replaceOpenChangeEvent(tree);
	replaceFocusClasses(tree);

	if (!skipFormat) {
		await formatFiles(tree);
	}
}

function replaceOpenChangeEvent(tree: Tree) {
	// if the element is `<brn-select`, '<hlm-select' and it has an `(openedChange)` event, we need to replace it with `(openChange)`
	visitFiles(tree, '.', (path) => {
		// if this is not an html file or typescript file (inline templates) then skip
		if (!path.endsWith('.html') && !path.endsWith('.ts')) {
			return;
		}

		let content = tree.read(path, 'utf-8');

		if (!content) {
			return;
		}

		// find all the brn-select or hlm-select elements that have an `(openedChange)` event
		content = content.replace(/<(brn-select|hlm-select)[^>]*\(\s*openedChange\s*\)=/g, (match) =>
			match.replace(/\(\s*openedChange\s*\)/, '(openChange)'),
		);

		tree.write(path, content);
	});
}

function replaceFocusClasses(tree: Tree) {
	// update the hlm classes
	visitFiles(tree, '.', (path) => {
		// if this is not a typescript file then skip
		if (!path.endsWith('.ts')) {
			return;
		}

		updateHelmClasses(tree, path, {
			component: 'HlmSelectOptionComponent',
			classesToRemove: ['focus:bg-accent', 'focus:text-accent-foreground'],
			classesToAdd: ['data-[active]:bg-accent', 'data-[active]:text-accent-foreground'],
		});
	});
}

export default migrateSelectGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-select/schema.d.ts
```typescript
export interface MigrateSelectGeneratorSchema {
	skipFormat?: boolean;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-select/schema.json
```json
{
	"$schema": "https://json-schema.org/schema",
	"$id": "MigrateSelect",
	"title": "",
	"type": "object",
	"properties": {
		"skipFormat": {
			"type": "boolean",
			"default": false,
			"description": "Skip formatting files"
		}
	},
	"required": []
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/compat.ts
```typescript
import { convertNxGenerator } from '@nx/devkit';
import { healthcheckGenerator } from './generator';
import { HealthcheckGeneratorSchema } from './schema';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export default convertNxGenerator((tree: any, schema: HealthcheckGeneratorSchema & { angularCli?: boolean }) =>
	healthcheckGenerator(tree, { ...schema, angularCli: true }),
);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/generator.spec.ts
```typescript
import { readJson, Tree, writeJson } from '@nx/devkit';
import { createTreeWithEmptyWorkspace } from '@nx/devkit/testing';
import { healthcheckGenerator } from './generator';

describe('healthcheck generator', () => {
	let tree: Tree;

	beforeEach(async () => {
		tree = createTreeWithEmptyWorkspace();

		writeJson(tree, 'package.json', {
			dependencies: {
				'@spartan-ng/brain': '0.0.1-alpha.300',
				'@spartan-ng/ui-checkbox-brain': '0.0.1-alpha.300',
			},
			devDependencies: {
				'@spartan-ng/cli': '0.0.1-alpha.300',
			},
		});

		// add a file with legacy imports
		tree.write(
			'libs/my-lib/src/index.ts',
			`
			import { BrnCheckbox } from '@spartan-ng/ui-checkbox-brain';
			import { hlm } from '@spartan-ng/ui-core';
		`,
		);

		// add a file with a helm icon
		tree.write(
			'libs/my-lib/src/app.component.html',
			`
			<hlm-icon />
			<hlm-scroll-area />
		`,
		);

		await healthcheckGenerator(tree, { skipFormat: true, autoFix: true });
	});

	it('should update to latest dependencies', () => {
		const packageJson = readJson(tree, 'package.json');

		expect(packageJson.dependencies['@spartan-ng/brain']).not.toEqual('0.0.1-alpha.300');
		expect(packageJson.devDependencies['@spartan-ng/cli']).not.toEqual('0.0.1-alpha.300');
	});

	it('should update brain imports', () => {
		const contents = tree.read('libs/my-lib/src/index.ts', 'utf-8');

		expect(contents).not.toContain('@spartan-ng/ui-checkbox-brain');
		expect(contents).toContain('@spartan-ng/brain/checkbox');

		// check if package.json was updated
		const packageJson = readJson(tree, 'package.json');
		expect(packageJson.dependencies['@spartan-ng/ui-checkbox-brain']).toBeUndefined();
	});

	it('should update core imports', () => {
		const contents = tree.read('libs/my-lib/src/index.ts', 'utf-8');

		expect(contents).not.toContain('@spartan-ng/ui-core');
		expect(contents).toContain('@spartan-ng/brain/core');
	});

	it('should update helm icons', () => {
		const contents = tree.read('libs/my-lib/src/app.component.html', 'utf-8');

		expect(contents).not.toContain('<hlm-icon');
		expect(contents).toContain('<ng-icon hlm');
	});

	it('should update helm scroll areas', () => {
		const contents = tree.read('libs/my-lib/src/app.component.html', 'utf-8');

		expect(contents).not.toContain('<hlm-scroll-area');
		expect(contents).toContain('<ng-scrollbar hlm');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/generator.ts
```typescript
import { formatFiles, logger, Tree } from '@nx/devkit';
import { Healthcheck, HealthcheckReport, HealthcheckStatus, isHealthcheckFixable } from './healthchecks';
import { brainImportsHealthcheck } from './healthchecks/brain-imports';
import { brainRadioHealthcheck } from './healthchecks/brn-radio';
import { brainToggleHealthcheck } from './healthchecks/brn-toggle-group';
import { coreImportsHealthcheck } from './healthchecks/core-imports';
import { helmIconHealthcheck } from './healthchecks/hlm-icon';
import { scrollAreaHealthcheck } from './healthchecks/hlm-scroll-area';
import { selectHealthcheck } from './healthchecks/hlm-select';
import { versionHealthcheck } from './healthchecks/version';
import { HealthcheckGeneratorSchema } from './schema';
import { promptUser } from './utils/prompt';
import { printReport } from './utils/reporter';
import { runHealthcheck } from './utils/runner';

export async function healthcheckGenerator(tree: Tree, options: HealthcheckGeneratorSchema & { angularCli?: boolean }) {
	logger.info('Running healthchecks...');

	const healthchecks: Healthcheck[] = [
		versionHealthcheck,
		brainImportsHealthcheck,
		coreImportsHealthcheck,
		helmIconHealthcheck,
		scrollAreaHealthcheck,
		brainRadioHealthcheck,
		selectHealthcheck,
		brainToggleHealthcheck,
	];

	const failedReports: HealthcheckReport[] = [];

	for (const healthcheck of healthchecks) {
		const report = await runHealthcheck(tree, healthcheck);
		printReport(report);

		if (report.status === HealthcheckStatus.Failure) {
			failedReports.push(report);
		}
	}

	for (const report of failedReports) {
		if (report.fixable && isHealthcheckFixable(report.healthcheck)) {
			const fix = options.autoFix || (await promptUser(report.healthcheck.prompt));

			if (fix) {
				await report.healthcheck.fix(tree, { angularCli: options.angularCli });
			}
		}
	}

	if (!options.skipFormat) {
		await formatFiles(tree);
	}
}

export default healthcheckGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/healthchecks.ts
```typescript
import { Tree } from '@nx/devkit';

export type Healthcheck = StandardHealthcheck | FixableHealthcheck;

interface StandardHealthcheck {
	/**
	 * The name of the healthcheck.
	 */
	name: string;

	/**
	 * Determine whether or not anything in the project needs to be fixed.
	 */
	detect(tree: Tree, failure: HealthcheckFailureFn, skip: HealthcheckSkippedFn): void | Promise<void>;
}

interface FixableHealthcheck extends StandardHealthcheck {
	/**
	 * Fix any issues found by the check method. Return true if the issue was fixed, false if it was not.
	 */
	fix(tree: Tree, context: HealthcheckContext): boolean | Promise<boolean>;
	/**
	 * The auto fix prompt message.
	 */
	prompt: string;
}

export enum HealthcheckStatus {
	Success,
	Failure,
	Skipped,
}

export enum HealthcheckSeverity {
	Error,
	Warning,
}

export type HealthcheckFailureFn = (issue: string, severity: HealthcheckSeverity, fixable: boolean) => void;
export type HealthcheckSkippedFn = (reason: string) => void;

/**
 * Determine if a healthcheck is fixable.
 */
export function isHealthcheckFixable(healthcheck: Healthcheck): healthcheck is FixableHealthcheck {
	return 'fix' in healthcheck;
}

export interface HealthcheckReport {
	/**
	 * The name of the healthcheck.
	 */
	name: string;

	/**
	 * The healthcheck.
	 */
	healthcheck: Healthcheck;

	/**
	 * The status of the healthcheck.
	 */
	status: HealthcheckStatus;

	/**
	 * The list of issues that were found by the healthcheck.
	 */
	issues?: HealthcheckIssue[];

	/**
	 * If the healthcheck was skipped, this message will be displayed to the user.
	 */
	reason?: string;

	/**
	 * Whether or not the healthcheck can be fixed.
	 */
	fixable: boolean;
}

export interface HealthcheckIssue {
	/**
	 * The details of the issue that was found by the healthcheck.
	 */
	details: string;

	/**
	 * The severity of the issue.
	 */
	severity: HealthcheckSeverity;
}

interface HealthcheckContext {
	angularCli?: boolean;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/schema.d.ts
```typescript
export interface HealthcheckGeneratorSchema {
	autoFix?: boolean;
	skipFormat?: boolean;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/schema.json
```json
{
	"$schema": "http://json-schema.org/draft-07/schema",
	"$id": "Healthcheck",
	"title": "",
	"type": "object",
	"properties": {
		"autoFix": {
			"type": "boolean",
			"default": false,
			"description": "Automatically fix any issues"
		},
		"skipFormat": {
			"type": "boolean",
			"default": false,
			"description": "Skip formatting files"
		}
	},
	"required": []
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/healthchecks/brain-imports.ts
```typescript
import { visitNotIgnoredFiles } from '@nx/devkit';
import { migrateBrainImportsGenerator } from '../../migrate-brain-imports/generator';
import importMap from '../../migrate-brain-imports/import-map';
import { Healthcheck, HealthcheckSeverity } from '../healthchecks';

export const brainImportsHealthcheck: Healthcheck = {
	name: 'Brain imports',
	async detect(tree, failure) {
		visitNotIgnoredFiles(tree, '/', (file) => {
			// if the file is a .ts or .json file, check for brain imports/packages
			if (!file.endsWith('.ts') || file.endsWith('.json')) {
				return;
			}

			const contents = tree.read(file, 'utf-8');

			if (!contents) {
				return;
			}

			for (const [importPath, brainPackage] of Object.entries(importMap)) {
				if (contents.includes(importPath)) {
					failure(
						`The import ${importPath} is deprecated. Please use the ${brainPackage} package instead.`,
						HealthcheckSeverity.Error,
						true,
					);
				}
			}
		});
	},
	fix: async (tree) => {
		await migrateBrainImportsGenerator(tree, { skipFormat: true });
		return true;
	},
	prompt: 'Would you like to migrate brain imports?',
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/healthchecks/brn-radio.ts
```typescript
import { visitNotIgnoredFiles } from '@nx/devkit';
import { migrateRadioGenerator } from '../../migrate-radio/generator';
import { Healthcheck, HealthcheckSeverity } from '../healthchecks';

export const brainRadioHealthcheck: Healthcheck = {
	name: 'Brain Radio',
	async detect(tree, failure) {
		visitNotIgnoredFiles(tree, '/', (file) => {
			// if the file is a .ts or .htlm file, check for brain radio
			if (!file.endsWith('.ts') && !file.endsWith('.html')) {
				return;
			}

			const contents = tree.read(file, 'utf-8');

			if (!contents) {
				return;
			}

			if (contents.includes('<brn-radio')) {
				failure(
					`The <brn-radio> component is deprecated. Please use the <hlm-radio> instead.`,
					HealthcheckSeverity.Error,
					true,
				);
			}
		});
	},
	fix: async (tree) => {
		await migrateRadioGenerator(tree, { skipFormat: true });
		return true;
	},
	prompt: 'Would you like to migrate brain radio?',
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/healthchecks/brn-toggle-group.ts
```typescript
import { visitNotIgnoredFiles } from '@nx/devkit';
import { migrateToggleGroupGenerator } from '../../migrate-toggle-group/generator';
import { Healthcheck, HealthcheckSeverity } from '../healthchecks';

export const brainToggleHealthcheck: Healthcheck = {
	name: 'Brain Toggle Group',
	async detect(tree, failure) {
		visitNotIgnoredFiles(tree, '/', (file) => {
			// if the file is a .ts or .htlm file, check for helm icons
			if (!file.endsWith('.ts') && !file.endsWith('.html')) {
				return;
			}

			const contents = tree.read(file, 'utf-8');

			if (!contents) {
				return;
			}

			if (
				contents.includes("BrnToggleGroupModule } from '@spartan-ng/brain/toggle'") ||
				contents.includes("import { BrnToggleGroupModule } from '@spartan-ng/brain/toggle'") ||
				(contents.includes('BrnToggleGroupModule') && contents.includes('@spartan-ng/brain/toggle')) ||
				contents.includes("HlmToggleGroupModule } from '@spartan-ng/ui-toggle-helm'") ||
				(contents.includes('HlmToggleGroupModule') && contents.includes('@spartan-ng/ui-toggle-helm'))
			) {
				failure(
					'The <brn-toggle-group> component from the toggle brain package is deprecated. Please use the <brn-toggle-group> from the toggle-group package instead.',
					HealthcheckSeverity.Error,
					true,
				);
			}
		});
	},
	fix: async (tree) => {
		await migrateToggleGroupGenerator(tree, { skipFormat: true });
		return true;
	},
	prompt: 'Would you like to migrate toggle-group?',
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/healthchecks/core-imports.ts
```typescript
import { visitNotIgnoredFiles } from '@nx/devkit';
import { migrateCoreGenerator } from '../../migrate-core/generator';
import { Healthcheck, HealthcheckSeverity } from '../healthchecks';

export const coreImportsHealthcheck: Healthcheck = {
	name: 'Core imports',
	async detect(tree, failure) {
		visitNotIgnoredFiles(tree, '/', (file) => {
			// if the file is a .ts file, check for core imports
			if (!file.endsWith('.ts')) {
				return;
			}

			const contents = tree.read(file, 'utf-8');

			if (!contents) {
				return;
			}

			if (contents.includes('@spartan-ng/ui-core')) {
				failure(
					`The import @spartan-ng/ui-core is deprecated. Please use the @spartan-ng/brain/core package instead.`,
					HealthcheckSeverity.Error,
					true,
				);
			}
		});
	},
	fix: async (tree) => {
		await migrateCoreGenerator(tree, { skipFormat: true });
		return true;
	},
	prompt: 'Would you like to migrate core imports?',
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/healthchecks/hlm-icon.ts
```typescript
import { visitNotIgnoredFiles } from '@nx/devkit';
import { migrateIconGenerator } from '../../migrate-icon/generator';
import { Healthcheck, HealthcheckSeverity } from '../healthchecks';

export const helmIconHealthcheck: Healthcheck = {
	name: 'Helm Icons',
	async detect(tree, failure) {
		visitNotIgnoredFiles(tree, '/', (file) => {
			// if the file is a .ts or .htlm file, check for helm icons
			if (!file.endsWith('.ts') && !file.endsWith('.html')) {
				return;
			}

			const contents = tree.read(file, 'utf-8');

			if (!contents) {
				return;
			}

			if (contents.includes('<hlm-icon')) {
				failure(
					`The <hlm-icon> component is deprecated. Please use the <ng-icon hlm> instead.`,
					HealthcheckSeverity.Error,
					true,
				);
			}
		});
	},
	fix: async (tree) => {
		await migrateIconGenerator(tree, { skipFormat: true });
		return true;
	},
	prompt: 'Would you like to migrate helm icons?',
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/healthchecks/hlm-scroll-area.ts
```typescript
import { visitNotIgnoredFiles } from '@nx/devkit';
import { migrateScrollAreaGenerator } from '../../migrate-scroll-area/generator';
import { Healthcheck, HealthcheckSeverity } from '../healthchecks';

export const scrollAreaHealthcheck: Healthcheck = {
	name: 'Helm Scroll Area',
	async detect(tree, failure) {
		visitNotIgnoredFiles(tree, '/', (file) => {
			// if the file is a .ts or .htlm file, check for helm icons
			if (!file.endsWith('.ts') && !file.endsWith('.html')) {
				return;
			}

			const contents = tree.read(file, 'utf-8');

			if (!contents) {
				return;
			}

			if (contents.includes('<hlm-scroll-area')) {
				failure(
					`The <hlm-scroll-area> component is deprecated. Please use the <ng-scrollbar hlm> instead.`,
					HealthcheckSeverity.Error,
					true,
				);
			}
		});
	},
	fix: async (tree) => {
		await migrateScrollAreaGenerator(tree, { skipFormat: true });
		return true;
	},
	prompt: 'Would you like to migrate helm scroll areas?',
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/healthchecks/hlm-select.ts
```typescript
import { visitNotIgnoredFiles } from '@nx/devkit';
import { hasHelmClasses } from '../../../utils/hlm-class';
import migrateSelectGenerator from '../../migrate-select/generator';
import { Healthcheck, HealthcheckSeverity } from '../healthchecks';

export const selectHealthcheck: Healthcheck = {
	name: 'Helm Select',
	async detect(tree, failure) {
		visitNotIgnoredFiles(tree, '/', (file) => {
			// if the file is a .ts or .htlm file, check for helm icons
			if (!file.endsWith('.ts') && !file.endsWith('.html')) {
				return;
			}

			const contents = tree.read(file, 'utf-8');

			if (!contents) {
				return;
			}

			// check if the legacy openedChange event is being used
			if (/<(brn-select|hlm-select)[^>]*\(\s*openedChange\s*\)=/g.test(contents)) {
				failure('Select is using the renamed openedChange event.', HealthcheckSeverity.Error, true);
			}

			// check if the legacy focus classes are being used
			if (
				hasHelmClasses(tree, file, {
					component: 'HlmSelectOptionComponent',
					classes: ['focus:bg-accent', 'focus:text-accent-foreground'],
				})
			) {
				failure('Select option is using the legacy focus classes.', HealthcheckSeverity.Error, true);
			}
		});
	},
	fix: async (tree) => {
		await migrateSelectGenerator(tree, { skipFormat: true });
		return true;
	},
	prompt: 'Would you like to migrate selects?',
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/healthchecks/version.ts
```typescript
import { readJson } from '@nx/devkit';
import { PackageJson } from 'nx/src/utils/package-json';
import * as semver from 'semver';
import { Healthcheck, HealthcheckSeverity } from '../healthchecks';

export const versionHealthcheck: Healthcheck = {
	name: 'Spartan - Dependency Check',
	async detect(tree, failure, skip) {
		// If there is no package.json, skip this healthcheck
		if (!tree.exists('package.json')) {
			skip('No package.json found.');
			return;
		}

		// read the package.json
		const packageJson = readJson(tree, 'package.json');

		// merge the dependencies and devDependencies
		const dependencies = { ...packageJson.dependencies, ...packageJson.devDependencies };

		const dependenciesToCheck = ['@spartan-ng/brain', '@spartan-ng/cli'];

		for (const dep of dependenciesToCheck) {
			if (!dependencies[dep]) {
				failure(`The dependency ${dep} is not installed.`, HealthcheckSeverity.Error, true);
				continue;
			}

			const installedVersion = dependencies[dep];

			// check if the installed version is the latest version
			const request = await fetch(`https://registry.npmjs.org/${dep}/latest`);

			if (!request.ok) {
				failure(`Failed to fetch metadata for ${dep}.`, HealthcheckSeverity.Error, false);
				continue;
			}

			const metadata = (await request.json()) as PackageJson;

			if (!semver.satisfies(metadata.version, installedVersion)) {
				failure(
					`The installed version of ${dep} is not the latest version. The latest version is ${metadata.version}.`,
					HealthcheckSeverity.Warning,
					true,
				);
				continue;
			}
		}
	},
	fix: async (tree) => {
		const packageJson = readJson(tree, 'package.json');
		const dependencies = { ...packageJson.dependencies, ...packageJson.devDependencies };
		const dependenciesToCheck = ['@spartan-ng/brain', '@spartan-ng/cli'];

		for (const dep of dependenciesToCheck) {
			if (!dependencies[dep]) {
				return false;
			}

			const request = await fetch(`https://registry.npmjs.org/${dep}/latest`);

			if (!request.ok) {
				return false;
			}

			const metadata = (await request.json()) as PackageJson;

			// update the dependency to the latest version in the respective section
			if (packageJson.dependencies[dep]) {
				packageJson.dependencies[dep] = `^${metadata.version}`;
			} else {
				packageJson.devDependencies[dep] = `^${metadata.version}`;
			}
		}

		tree.write('package.json', JSON.stringify(packageJson, null, 2));

		return true;
	},
	prompt: 'Would you like to update to the latest versions of the dependencies?',
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/utils/prompt.ts
```typescript
export function promptUser(question: string): Promise<boolean> {
	return new Promise((resolve) => {
		process.stdout.write(`${question} (y/n): `);

		process.stdin.setEncoding('utf8');
		process.stdin.once('data', (data) => {
			const answer = data.toString().trim().toLowerCase();
			if (['yes', 'y'].includes(answer)) {
				resolve(true);
			} else if (['no', 'n'].includes(answer)) {
				resolve(false);
			} else {
				console.log('Invalid response. Please answer with "yes" or "no".');
				resolve(promptUser(question));
			}
		});
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/utils/reporter.ts
```typescript
import { logger } from '@nx/devkit';
import pc from 'picocolors';
import { HealthcheckReport, HealthcheckSeverity, HealthcheckStatus } from '../healthchecks';

export function printReport(report: HealthcheckReport): void {
	logger.log(`${getStatus(report.status)} ${report.name}`);

	// if this was a failure log the instructions
	if (report.status === HealthcheckStatus.Failure) {
		for (const issue of report.issues) {
			logger.log(`\t\t ${getSeverity(issue.severity)} ${issue.details}`);
		}
	}

	// if the healthcheck was skipped, log the reason
	if (report.status === HealthcheckStatus.Skipped) {
		logger.log(`\t\t ${pc.yellow(report.reason)}`);
	}
}

function getStatus(result: HealthcheckStatus) {
	switch (result) {
		case HealthcheckStatus.Success:
			return pc.green('[ ✔ ]');
		case HealthcheckStatus.Failure:
			return pc.red('[ ✖ ]');
		case HealthcheckStatus.Skipped:
			return pc.yellow('[ ! ]');
	}
}

function getSeverity(severity: HealthcheckSeverity) {
	switch (severity) {
		case HealthcheckSeverity.Error:
			return pc.red('✖');
		case HealthcheckSeverity.Warning:
			return pc.yellow('!');
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/healthcheck/utils/runner.ts
```typescript
import { Tree } from '@nx/devkit';
import {
	Healthcheck,
	HealthcheckFailureFn,
	HealthcheckReport,
	HealthcheckSeverity,
	HealthcheckStatus,
	isHealthcheckFixable,
} from '../healthchecks';

export async function runHealthcheck(tree: Tree, healthcheck: Healthcheck): Promise<HealthcheckReport> {
	const report: HealthcheckReport = {
		name: healthcheck.name,
		status: HealthcheckStatus.Success,
		fixable: false,
		healthcheck,
	};

	const failure: HealthcheckFailureFn = (details: string, severity: HealthcheckSeverity, fixable: boolean) => {
		// check if this issue already exists
		if (report.issues?.some((issue) => issue.details === details)) {
			return;
		}

		report.status = HealthcheckStatus.Failure;
		report.issues ??= [];
		report.issues.push({ details, severity });
		report.fixable = report.fixable || (fixable && isHealthcheckFixable(healthcheck));
	};

	const skip = (reason: string) => {
		report.status = HealthcheckStatus.Skipped;
		report.reason = reason;
	};

	await coercePromise(healthcheck.detect(tree, failure, skip));

	return report;
}

function coercePromise<T>(value: T | Promise<T>): Promise<T> {
	return value instanceof Promise ? value : Promise.resolve(value);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/theme/compat.ts
```typescript
import { convertNxGenerator } from '@nx/devkit';
import addThemeToApplicationGenerator from './generator';

export default convertNxGenerator(addThemeToApplicationGenerator);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/theme/generator.spec.ts
```typescript
import { applicationGenerator, E2eTestRunner, setupTailwindGenerator, UnitTestRunner } from '@nx/angular/generators';
import { readProjectConfiguration, Tree, updateJson } from '@nx/devkit';
import { createTreeWithEmptyWorkspace } from 'nx/src/devkit-testing-exports';
import { addThemeToApplicationStyles } from './libs/add-theme-to-application-styles';

jest.mock('@nx/devkit', () => {
	const original = jest.requireActual('@nx/devkit');
	return {
		...original,
		// eslint-disable-next-line @typescript-eslint/no-empty-function
		ensurePackage: () => {},
		createProjectGraphAsync: jest.fn().mockResolvedValue({
			nodes: {},
			dependencies: {},
		}),
	};
});

describe('Theme generator', () => {
	let tree: Tree;

	beforeEach(async () => {
		tree = createTreeWithEmptyWorkspace();
		await applicationGenerator(tree, {
			directory: 'website',
			e2eTestRunner: E2eTestRunner.None,
			linter: 'none',
			name: 'website',
			skipFormat: true,
			unitTestRunner: UnitTestRunner.None,
			standalone: true,
			skipTests: true,
		});
	});

	describe('Tailwind v3', () => {
		beforeEach(async () => {
			await setupTailwindGenerator(tree, {
				project: 'website',
				skipFormat: true,
			});
		});

		it('should not add the Tailwind 4 preset global stylesheet', async () => {
			const project = readProjectConfiguration(tree, 'website');

			addThemeToApplicationStyles(
				tree,
				{
					theme: 'zinc',
					project: 'website',
					radius: 2,
					addCdkStyles: true,
				},
				project,
			);

			const styles = tree.read('website/src/styles.css', 'utf8');

			expect(styles).not.toContain('@import "@spartan-ng/brain/hlm-tailwind-preset.css";');
		});
	});

	describe('Tailwind v4', () => {
		beforeEach(async () => {
			updateJson(tree, 'package.json', (json) => {
				json.devDependencies = {
					...json.devDependencies,
					tailwindcss: '^4.0.0',
				};
				return json;
			});

			tree.write('website/src/styles.css', '@import "tailwindcss";');
		});

		it('should add the Tailwind 4 preset global stylesheet', async () => {
			const project = readProjectConfiguration(tree, 'website');

			addThemeToApplicationStyles(
				tree,
				{
					theme: 'zinc',
					project: 'website',
					radius: 2,
					addCdkStyles: true,
				},
				project,
			);

			const styles = tree.read('website/src/styles.css', 'utf8');

			expect(styles).toContain('@import "@spartan-ng/brain/hlm-tailwind-preset.css";');
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/theme/generator.ts
```typescript
import type { ProjectConfiguration, Tree } from '@nx/devkit';
import { prompt } from 'enquirer';
import { getProjectsAndNames } from '../../utils/get-project-names';
import { addThemeToApplicationStyles } from './libs/add-theme-to-application-styles';
import { SupportedRadii, type SupportedTheme, SupportedThemes } from './libs/supported-theme-generator-map';

export default async function addThemeToApplicationGenerator(tree: Tree) {
	const { projects, projectNames } = getProjectsAndNames(tree);

	const response: { app: string } = await prompt({
		type: 'select',
		required: true,
		name: 'app',
		message: 'Choose which application you want to add the theme to:',
		choices: projectNames,
	});
	const project: ProjectConfiguration | undefined = projects.get(response.app);

	if (!project) return;

	const themeOptions: {
		theme: SupportedTheme;
		radius: string;
		addCdkStyles: boolean;
		stylesEntryPoint?: string;
		prefix?: string;
	} = await prompt([
		{
			type: 'select',
			required: true,
			name: 'theme',
			message:
				'Choose which theme to apply. You can always re-run this generator and add a custom prefix to add other themes.',
			choices: SupportedThemes,
		},
		{
			type: 'select',
			required: true,
			name: 'radius',
			initial: 2,
			message: 'Which corner radius do you want to use with your theme:',
			choices: [...SupportedRadii],
		},
		{
			type: 'input',
			name: 'stylesEntryPoint',
			message:
				"Path to the styles entry point relative to the workspace root. If not provided the generator will do its best to find it and it will error if it can't.",
		},
		{
			type: 'input',
			name: 'prefix',
			message:
				"Prefix class name applied to your theme's style definitions: e.g., theme-rose, theme-zinc. Leave empty for global theme.",
		},
	]);

	addThemeToApplicationStyles(
		tree,
		{
			project: project.name,
			radius: Number.parseFloat(themeOptions.radius),
			theme: themeOptions.theme,
			addCdkStyles: themeOptions.addCdkStyles,
			stylesEntryPoint: themeOptions.stylesEntryPoint,
			prefix: themeOptions.prefix,
		},
		project,
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/theme/schema.json
```json
{
	"$schema": "http://json-schema.org/draft-07/schema",
	"$id": "HlmThemeGeneratorSchema",
	"title": "",
	"type": "object",
	"properties": {}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/theme/libs/add-theme-to-application-styles.ts
```typescript
// All credit goes to the incredible folks at Nx who use this code to update the app styles when adding tailwind
// Check out the code here: https://github.com/nrwl/nx/blob/master/packages/angular/src/generators/setup-tailwind/lib/update-application-styles.ts

import { type ProjectConfiguration, type Tree, joinPathFragments, readJson, stripIndents } from '@nx/devkit';
import { type PackageJson } from 'nx/src/utils/package-json';
import * as semver from 'semver';
import { type SupportedTheme, SupportedThemeGeneratorMap } from './supported-theme-generator-map';

export interface AddThemeToApplicationStylesOptions {
	project: string;
	theme: SupportedTheme;
	radius: number;
	addCdkStyles: boolean;
	stylesEntryPoint?: string;
	prefix?: string;
}

export function addThemeToApplicationStyles(
	tree: Tree,
	options: AddThemeToApplicationStylesOptions,
	project: ProjectConfiguration,
): void {
	const packageJson = readJson<PackageJson>(tree, 'package.json');

	let tailwindVersion = 3;

	if ('tailwindcss' in packageJson.devDependencies) {
		const version = packageJson.devDependencies['tailwindcss'];
		tailwindVersion = semver.coerce(version)?.major ?? 3;
	}

	const tailwindImport = tailwindVersion === 4 ? '@import "@spartan-ng/brain/hlm-tailwind-preset.css";' : '';

	const prefix = options.prefix ? ` .${options.prefix}` : '';
	let stylesEntryPoint = options.stylesEntryPoint;

	if (stylesEntryPoint && !tree.exists(stylesEntryPoint)) {
		throw new Error(`The provided styles entry point "${stylesEntryPoint}" could not be found.`);
	}

	if (!stylesEntryPoint) {
		stylesEntryPoint = findStylesEntryPoint(tree, project);

		if (!stylesEntryPoint) {
			throw new Error(
				stripIndents`Could not find a styles entry point for project "${options.project}".
        Please specify a styles entry point using the "stylesEntryPoint" option.`,
			);
		}
	}

	const stylesEntryPointContent = tree.read(stylesEntryPoint, 'utf-8');

	const CDK_IMPORT = `@import '@angular/cdk/overlay-prebuilt.css';`;
	const ckdOverlayImport = stylesEntryPointContent.includes(CDK_IMPORT) ? '' : CDK_IMPORT;

	const rootFontSans = stylesEntryPointContent.includes('--font-sans')
		? ''
		: `:root {
     --font-sans: ''
     }`;

	tree.write(
		stylesEntryPoint,
		stripIndents`
    ${ckdOverlayImport}

    ${stylesEntryPointContent}
    ${tailwindImport}

    ${rootFontSans}
    ${SupportedThemeGeneratorMap[options.theme](options.radius, prefix)}

    @layer base {
      * {
        @apply border-border;
      }
    }`,
	);
}

function findStylesEntryPoint(tree: Tree, project: ProjectConfiguration): string | undefined {
	// first check for common names
	const possibleStylesEntryPoints = [
		joinPathFragments(project.sourceRoot ?? project.root, 'styles.css'),
		joinPathFragments(project.sourceRoot ?? project.root, 'styles.scss'),
		joinPathFragments(project.sourceRoot ?? project.root, 'styles.sass'),
		joinPathFragments(project.sourceRoot ?? project.root, 'styles.less'),
	];

	const stylesEntryPoint = possibleStylesEntryPoints.find((s) => tree.exists(s));
	if (stylesEntryPoint) {
		return stylesEntryPoint;
	}

	// then check for the specified styles in the build configuration if it exists
	const styles: Array<string | { input: string; inject: boolean }> = project.targets?.build.options?.styles;

	if (!styles) {
		return undefined;
	}

	// find the first style that belongs to the project source
	const style = styles.find((s) =>
		typeof s === 'string'
			? s.startsWith(project.root) && tree.exists(s)
			: s.input.startsWith(project.root) && s.inject !== false && tree.exists(s.input),
	);

	if (!style) {
		return undefined;
	}

	return typeof style === 'string' ? style : style.input;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/theme/libs/supported-theme-generator-map.ts
```typescript
export const SupportedThemeGeneratorMap = {
	zinc: (radius: number, prefix = '') => `
:root${prefix} {
    --background: 0 0% 100%;
    --foreground: 240 10% 3.9%;
    --card: 0 0% 100%;
    --card-foreground: 240 10% 3.9%;
    --popover: 0 0% 100%;;
    --popover-foreground: 240 10% 3.9%;
    --primary: 240 5.9% 10%;
    --primary-foreground: 0 0% 98%;
    --secondary: 240 4.8% 95.9%;
    --secondary-foreground: 240 5.9% 10%;
    --muted: 240 4.8% 95.9%;
    --muted-foreground: 240 3.8% 46.1%;
    --accent: 240 4.8% 95.9%;
    --accent-foreground: 240 5.9% 10%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 0 0% 98%;
    --border: 240 5.9% 90%;
    --input: 240 5.9% 90%;
    --ring: 240 5.9% 10%;
    --radius: ${radius}rem;
    color-scheme: light;
  }

  .dark${prefix} {
    --background: 240 10% 3.9%;
    --foreground: 0 0% 98%;
    --card: 240 10% 3.9%;
    --card-foreground: 0 0% 98%;
    --popover: 240 10% 3.9%;
    --popover-foreground: 0 0% 98%;
    --primary: 0 0% 98%;
    --primary-foreground: 240 5.9% 10%;
    --secondary: 240 3.7% 15.9%;
    --secondary-foreground: 0 0% 98%;
    --muted: 240 3.7% 15.9%;
    --muted-foreground: 240 5% 64.9%;
    --accent: 240 3.7% 15.9%;
    --accent-foreground: 0 0% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 0 0% 98%;
    --border: 240 3.7% 15.9%;
    --input: 240 3.7% 15.9%;
    --ring: 240 4.9% 83.9%;
    color-scheme: dark;
  }
`,
	slate: (radius: number, prefix = '') => `
:root${prefix} {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --primary: 222.2 47.4% 11.2%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;
    --accent: 210 40% 96.1%;
    --accent-foreground: 222.2 47.4% 11.2%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --ring: 222.2 84% 4.9%;
    --radius: ${radius}rem;
    color-scheme: light;
  }

  .dark${prefix} {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
    --popover: 222.2 84% 4.9%;
    --popover-foreground: 210 40% 98%;
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --primary: 210 40% 98%;
    --primary-foreground: 222.2 47.4% 11.2%;
    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
    --ring: 212.7 26.8% 83.9;
    color-scheme: dark;
  }
`,
	stone: (radius: number, prefix = '') => `
:root${prefix} {
   --background: 0 0% 100%;
    --foreground: 20 14.3% 4.1%;
    --muted: 60 4.8% 95.9%;
    --muted-foreground: 25 5.3% 44.7%;
    --popover: 0 0% 100%;
    --popover-foreground: 20 14.3% 4.1%;
    --card: 0 0% 100%;
    --card-foreground: 20 14.3% 4.1%;
    --border: 20 5.9% 90%;
    --input: 20 5.9% 90%;
    --primary: 24 9.8% 10%;
    --primary-foreground: 60 9.1% 97.8%;
    --secondary: 60 4.8% 95.9%;
    --secondary-foreground: 24 9.8% 10%;
    --accent: 60 4.8% 95.9%;
    --accent-foreground: 24 9.8% 10%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 60 9.1% 97.8%;
    --ring: 20 14.3% 4.1%;
    --radius: ${radius}rem;
    color-scheme: light;
  }

  .dark${prefix} {
    --background: 20 14.3% 4.1%;
    --foreground: 60 9.1% 97.8%;
    --muted: 12 6.5% 15.1%;
    --muted-foreground: 24 5.4% 63.9%;
    --popover: 20 14.3% 4.1%;
    --popover-foreground: 60 9.1% 97.8%;
    --card: 20 14.3% 4.1%;
    --card-foreground: 60 9.1% 97.8%;
    --border: 12 6.5% 15.1%;
    --input: 12 6.5% 15.1%;
    --primary: 60 9.1% 97.8%;
    --primary-foreground: 24 9.8% 10%;
    --secondary: 12 6.5% 15.1%;
    --secondary-foreground: 60 9.1% 97.8%;
    --accent: 12 6.5% 15.1%;
    --accent-foreground: 60 9.1% 97.8%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 60 9.1% 97.8%;
    --ring: 24 5.7% 82.9%;
    color-scheme: dark;
  }
`,
	gray: (radius: number, prefix = '') => `
:root${prefix} {
    --background: 0 0% 100%;
    --foreground: 224 71.4% 4.1%;
    --muted: 220 14.3% 95.9%;
    --muted-foreground: 220 8.9% 46.1%;
    --popover: 0 0% 100%;
    --popover-foreground: 224 71.4% 4.1%;
    --card: 0 0% 100%;
    --card-foreground: 224 71.4% 4.1%;
    --border: 220 13% 91%;
    --input: 220 13% 91%;
    --primary: 220.9 39.3% 11%;
    --primary-foreground: 210 20% 98%;
    --secondary: 220 14.3% 95.9%;
    --secondary-foreground: 220.9 39.3% 11%;
    --accent: 220 14.3% 95.9%;
    --accent-foreground: 220.9 39.3% 11%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 20% 98%;
    --ring: 224 71.4% 4.1%;
    --radius: ${radius}rem;
    color-scheme: light;
  }

  .dark${prefix} {
    --background: 224 71.4% 4.1%;
    --foreground: 210 20% 98%;
    --muted: 215 27.9% 16.9%;
    --muted-foreground: 217.9 10.6% 64.9%;
    --popover: 224 71.4% 4.1%;
    --popover-foreground: 210 20% 98%;
    --card: 224 71.4% 4.1%;
    --card-foreground: 210 20% 98%;
    --border: 215 27.9% 16.9%;
    --input: 215 27.9% 16.9%;
    --primary: 210 20% 98%;
    --primary-foreground: 220.9 39.3% 11%;
    --secondary: 215 27.9% 16.9%;
    --secondary-foreground: 210 20% 98%;
    --accent: 215 27.9% 16.9%;
    --accent-foreground: 210 20% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 20% 98%;
    --ring: 216 12.2% 83.9%;
    color-scheme: dark;
  }
`,
	neutral: (radius: number, prefix = '') => `
:root${prefix} {
    --background: 0 0% 100%;
    --foreground: 0 0% 3.9%;
    --muted: 0 0% 96.1%;
    --muted-foreground: 0 0% 45.1%;
    --popover: 0 0% 100%;
    --popover-foreground: 0 0% 3.9%;
    --card: 0 0% 100%;
    --card-foreground: 0 0% 3.9%;
    --border: 0 0% 89.8%;
    --input: 0 0% 89.8%;
    --primary: 0 0% 9%;
    --primary-foreground: 0 0% 98%;
    --secondary: 0 0% 96.1%;
    --secondary-foreground: 0 0% 9%;
    --accent: 0 0% 96.1%;
    --accent-foreground: 0 0% 9%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 0 0% 98%;
    --ring: 0 0% 3.9%;
    --radius: ${radius}rem;
    color-scheme: light;
  }

  .dark${prefix} {
    --background: 0 0% 3.9%;
    --foreground: 0 0% 98%;
    --muted: 0 0% 14.9%;
    --muted-foreground: 0 0% 63.9%;
    --popover: 0 0% 3.9%;
    --popover-foreground: 0 0% 98%;
    --card: 0 0% 3.9%;
    --card-foreground: 0 0% 98%;
    --border: 0 0% 14.9%;
    --input: 0 0% 14.9%;
    --primary: 0 0% 98%;
    --primary-foreground: 0 0% 9%;
    --secondary: 0 0% 14.9%;
    --secondary-foreground: 0 0% 98%;
    --accent: 0 0% 14.9%;
    --accent-foreground: 0 0% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 0 0% 98%;
    --ring: 0 0% 83.1%;
    color-scheme: dark;
  }
`,
	red: (radius: number, prefix = '') => `
:root${prefix} {
    --background: 0 0% 100%;
    --foreground: 0 0% 3.9%;
    --muted: 0 0% 96.1%;
    --muted-foreground: 0 0% 45.1%;
    --popover: 0 0% 100%;
    --popover-foreground: 0 0% 3.9%;
    --card: 0 0% 100%;
    --card-foreground: 0 0% 3.9%;
    --border: 0 0% 89.8%;
    --input: 0 0% 89.8%;
    --primary: 0 72.2% 50.6%;
    --primary-foreground: 0 85.7% 97.3%;
    --secondary: 0 0% 96.1%;
    --secondary-foreground: 0 0% 9%;
    --accent: 0 0% 96.1%;
    --accent-foreground: 0 0% 9%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 0 0% 98%;
    --ring: 0 72.2% 50.6%;
    --radius: ${radius}rem;
    color-scheme: light;
  }

  .dark${prefix} {
    --background: 0 0% 3.9%;
    --foreground: 0 0% 98%;
    --muted: 0 0% 14.9%;
    --muted-foreground: 0 0% 63.9%;
    --popover: 0 0% 3.9%;
    --popover-foreground: 0 0% 98%;
    --card: 0 0% 3.9%;
    --card-foreground: 0 0% 98%;
    --border: 0 0% 14.9%;
    --input: 0 0% 14.9%;
    --primary: 0 72.2% 50.6%;
    --primary-foreground: 0 85.7% 97.3%;
    --secondary: 0 0% 14.9%;
    --secondary-foreground: 0 0% 98%;
    --accent: 0 0% 14.9%;
    --accent-foreground: 0 0% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 0 0% 98%;
    --ring: 0 72.2% 50.6%;
    color-scheme: dark;
  }
`,
	rose: (radius: number, prefix = '') => `
:root${prefix} {
    --background: 0 0% 100%;
    --foreground: 240 10% 3.9%;
    --card: 0 0% 100%;
    --card-foreground: 240 10% 3.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 240 10% 3.9%;
    --primary: 346.8 77.2% 49.8%;
    --primary-foreground: 355.7 100% 97.3%;
    --secondary: 240 4.8% 95.9%;
    --secondary-foreground: 240 5.9% 10%;
    --muted: 240 4.8% 95.9%;
    --muted-foreground: 240 3.8% 46.1%;
    --accent: 240 4.8% 95.9%;
    --accent-foreground: 240 5.9% 10%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 0 0% 98%;
    --border: 240 5.9% 90%;
    --input: 240 5.9% 90%;
    --ring: 346.8 77.2% 49.8%;
    --radius: ${radius}rem;
    color-scheme: light;
  }

  .dark${prefix} {
    --background: 20 14.3% 4.1%;
    --foreground: 0 0% 95%;
    --card: 24 9.8% 10%;
    --card-foreground: 0 0% 95%;
    --popover: 0 0% 9%;
    --popover-foreground: 0 0% 95%;
    --primary: 346.8 77.2% 49.8%;
    --primary-foreground: 355.7 100% 97.3%;
    --secondary: 240 3.7% 15.9%;
    --secondary-foreground: 0 0% 98%;
    --muted: 0 0% 15%;
    --muted-foreground: 240 5% 64.9%;
    --accent: 12 6.5% 15.1%;
    --accent-foreground: 0 0% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 0 85.7% 97.3%;
    --border: 240 3.7% 15.9%;
    --input: 240 3.7% 15.9%;
    --ring: 346.8 77.2% 49.8%;
    color-scheme: dark;
  }
`,
	blue: (radius: number, prefix = '') => `
:root${prefix} {
    --background: 0 0% 100%;
    --foreground: 240 10% 3.9%;
    --card: 0 0% 100%;
    --card-foreground: 240 10% 3.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 240 10% 3.9%;
    --primary: 346.8 77.2% 49.8%;
    --primary-foreground: 355.7 100% 97.3%;
    --secondary: 240 4.8% 95.9%;
    --secondary-foreground: 240 5.9% 10%;
    --muted: 240 4.8% 95.9%;
    --muted-foreground: 240 3.8% 46.1%;
    --accent: 240 4.8% 95.9%;
    --accent-foreground: 240 5.9% 10%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 0 0% 98%;
    --border: 240 5.9% 90%;
    --input: 240 5.9% 90%;
    --ring: 346.8 77.2% 49.8%;
    --radius: ${radius}rem;
    color-scheme: light;
  }

  .dark${prefix} {
    --background: 20 14.3% 4.1%;
    --foreground: 0 0% 95%;
    --card: 24 9.8% 10%;
    --card-foreground: 0 0% 95%;
    --popover: 0 0% 9%;
    --popover-foreground: 0 0% 95%;
    --primary: 346.8 77.2% 49.8%;
    --primary-foreground: 355.7 100% 97.3%;
    --secondary: 240 3.7% 15.9%;
    --secondary-foreground: 0 0% 98%;
    --muted: 0 0% 15%;
    --muted-foreground: 240 5% 64.9%;
    --accent: 12 6.5% 15.1%;
    --accent-foreground: 0 0% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 0 85.7% 97.3%;
    --border: 240 3.7% 15.9%;
    --input: 240 3.7% 15.9%;
    --ring: 346.8 77.2% 49.8%;
    color-scheme: dark;
  }
`,
	green: (radius: number, prefix = '') => `
:root${prefix} {
    --background: 0 0% 100%;
    --foreground: 240 10% 3.9%;
    --card: 0 0% 100%;
    --card-foreground: 240 10% 3.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 240 10% 3.9%;
    --primary: 142.1 76.2% 36.3%;
    --primary-foreground: 355.7 100% 97.3%;
    --secondary: 240 4.8% 95.9%;
    --secondary-foreground: 240 5.9% 10%;
    --muted: 240 4.8% 95.9%;
    --muted-foreground: 240 3.8% 46.1%;
    --accent: 240 4.8% 95.9%;
    --accent-foreground: 240 5.9% 10%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 0 0% 98%;
    --border: 240 5.9% 90%;
    --input: 240 5.9% 90%;
    --ring: 142.1 76.2% 36.3%;
    --radius: ${radius}rem;
    color-scheme: light;
  }

  .dark${prefix} {
    --background: 20 14.3% 4.1%;
    --foreground: 0 0% 95%;
    --card: 24 9.8% 10%;
    --card-foreground: 0 0% 95%;
    --popover: 0 0% 9%;
    --popover-foreground: 0 0% 95%;
    --primary: 142.1 70.6% 45.3%;
    --primary-foreground: 144.9 80.4% 10%;
    --secondary: 240 3.7% 15.9%;
    --secondary-foreground: 0 0% 98%;
    --muted: 0 0% 15%;
    --muted-foreground: 240 5% 64.9%;
    --accent: 12 6.5% 15.1%;
    --accent-foreground: 0 0% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 0 85.7% 97.3%;
    --border: 240 3.7% 15.9%;
    --input: 240 3.7% 15.9%;
    --ring: 142.4 71.8% 29.2%;
    color-scheme: dark;
  }
`,
	orange: (radius: number, prefix = '') => `
:root${prefix} {
    --background: 0 0% 100%;
    --foreground: 20 14.3% 4.1%;
    --card: 0 0% 100%;
    --card-foreground: 20 14.3% 4.1%;
    --popover: 0 0% 100%;
    --popover-foreground: 20 14.3% 4.1%;
    --primary: 24.6 95% 53.1%;
    --primary-foreground: 60 9.1% 97.8%;
    --secondary: 60 4.8% 95.9%;
    --secondary-foreground: 24 9.8% 10%;
    --muted: 60 4.8% 95.9%;
    --muted-foreground: 25 5.3% 44.7%;
    --accent: 60 4.8% 95.9%;
    --accent-foreground: 24 9.8% 10%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 60 9.1% 97.8%;
    --border: 20 5.9% 90%;
    --input: 20 5.9% 90%;
    --ring: 24.6 95% 53.1%;
    --radius: ${radius}rem;
    color-scheme: light;
  }

  .dark${prefix} {
    --background: 20 14.3% 4.1%;
    --foreground: 60 9.1% 97.8%;
    --card: 20 14.3% 4.1%;
    --card-foreground: 60 9.1% 97.8%;
    --popover: 20 14.3% 4.1%;
    --popover-foreground: 60 9.1% 97.8%;
    --primary: 20.5 90.2% 48.2%;
    --primary-foreground: 60 9.1% 97.8%;
    --secondary: 12 6.5% 15.1%;
    --secondary-foreground: 60 9.1% 97.8%;
    --muted: 12 6.5% 15.1%;
    --muted-foreground: 24 5.4% 63.9%;
    --accent: 12 6.5% 15.1%;
    --accent-foreground: 60 9.1% 97.8%;
    --destructive: 0 72.2% 50.6%;
    --destructive-foreground: 60 9.1% 97.8%;
    --border: 12 6.5% 15.1%;
    --input: 12 6.5% 15.1%;
    --ring: 20.5 90.2% 48.2%;
    color-scheme: dark;
  }
`,
	yellow: (radius: number, prefix = '') => `
:root${prefix} {
    --background: 0 0% 100%;
    --foreground: 20 14.3% 4.1%;
    --muted: 60 4.8% 95.9%;
    --muted-foreground: 25 5.3% 44.7%;
    --popover: 0 0% 100%;
    --popover-foreground: 20 14.3% 4.1%;
    --card: 0 0% 100%;
    --card-foreground: 20 14.3% 4.1%;
    --border: 20 5.9% 90%;
    --input: 20 5.9% 90%;
    --primary: 47.9 95.8% 53.1%;
    --primary-foreground: 26 83.3% 14.1%;
    --secondary: 60 4.8% 95.9%;
    --secondary-foreground: 24 9.8% 10%;
    --accent: 60 4.8% 95.9%;
    --accent-foreground: 24 9.8% 10%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 60 9.1% 97.8%;
    --ring: 20 14.3% 4.1%;
    --radius: ${radius}rem;
    color-scheme: light;
  }

  .dark${prefix} {
    --background: 20 14.3% 4.1%;
    --foreground: 60 9.1% 97.8%;
    --muted: 12 6.5% 15.1%;
    --muted-foreground: 24 5.4% 63.9%;
    --popover: 20 14.3% 4.1%;
    --popover-foreground: 60 9.1% 97.8%;
    --card: 20 14.3% 4.1%;
    --card-foreground: 60 9.1% 97.8%;
    --border: 12 6.5% 15.1%;
    --input: 12 6.5% 15.1%;
    --primary: 47.9 95.8% 53.1%;
    --primary-foreground: 26 83.3% 14.1%;
    --secondary: 12 6.5% 15.1%;
    --secondary-foreground: 60 9.1% 97.8%;
    --accent: 12 6.5% 15.1%;
    --accent-foreground: 60 9.1% 97.8%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 60 9.1% 97.8%;
    --ring: 35.5 91.7% 32.9%;
    color-scheme: dark;
  }
`,
	violet: (radius: number, prefix = '') => `
:root${prefix} {
    --background: 0 0% 100%;
    --foreground: 224 71.4% 4.1%;
    --muted: 220 14.3% 95.9%;
    --muted-foreground: 220 8.9% 46.1%;
    --popover: 0 0% 100%;
    --popover-foreground: 224 71.4% 4.1%;
    --card: 0 0% 100%;
    --card-foreground: 224 71.4% 4.1%;
    --border: 220 13% 91%;
    --input: 220 13% 91%;
    --primary: 262.1 83.3% 57.8%;
    --primary-foreground: 210 20% 98%;
    --secondary: 220 14.3% 95.9%;
    --secondary-foreground: 220.9 39.3% 11%;
    --accent: 220 14.3% 95.9%;
    --accent-foreground: 220.9 39.3% 11%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 20% 98%;
    --ring: 262.1 83.3% 57.8%;
    --radius: ${radius}rem;
    color-scheme: light;
  }

  .dark${prefix} {
    --background: 224 71.4% 4.1%;
    --foreground: 210 20% 98%;
    --muted: 215 27.9% 16.9%;
    --muted-foreground: 217.9 10.6% 64.9%;
    --popover: 224 71.4% 4.1%;
    --popover-foreground: 210 20% 98%;
    --card: 224 71.4% 4.1%;
    --card-foreground: 210 20% 98%;
    --border: 215 27.9% 16.9%;
    --input: 215 27.9% 16.9%;
    --primary: 263.4 70% 50.4%;
    --primary-foreground: 210 20% 98%;
    --secondary: 215 27.9% 16.9%;
    --secondary-foreground: 210 20% 98%;
    --accent: 215 27.9% 16.9%;
    --accent-foreground: 210 20% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 20% 98%;
    --ring: 263.4 70% 50.4%;
    color-scheme: dark;
  }
`,
};

export const SupportedThemes = Object.keys(SupportedThemeGeneratorMap);

export type SupportedTheme = keyof typeof SupportedThemeGeneratorMap;

export const SupportedRadii = ['0', '0.3', '0.5', '0.75', '1.0'] as const;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-helm-libraries/compat.ts
```typescript
import { convertNxGenerator } from '@nx/devkit';
import migrateHelmLibrariesGenerator from './generator';
import { MigrateHelmLibrariesGeneratorSchema } from './schema';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export default convertNxGenerator((tree: any, schema: MigrateHelmLibrariesGeneratorSchema & { angularCli?: boolean }) =>
	migrateHelmLibrariesGenerator(tree, { ...schema, angularCli: true }),
);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-helm-libraries/generator.ts
```typescript
import { formatFiles, logger, Tree, updateJson } from '@nx/devkit';
import { getRootTsConfigPathInTree } from '@nx/js';
import { removeGenerator } from '@nx/workspace';
import { prompt } from 'enquirer';
import { dirname, join } from 'path';
import { getOrCreateConfig } from '../../utils/config';
import { readTsConfigPathsFromTree } from '../../utils/tsconfig';
import { createPrimitiveLibraries } from '../ui/generator';
import { MigrateHelmLibrariesGeneratorSchema } from './schema';

export async function migrateHelmLibrariesGenerator(tree: Tree, options: MigrateHelmLibrariesGeneratorSchema) {
	// Detect the libraries that are already installed
	const existingLibraries = await detectLibraries(tree);

	if (existingLibraries.length === 0) {
		logger.info('No libraries to migrate');
		return;
	}

	// if we are running in Jest we can't use the enquirer prompt
	if (process.env.JEST_WORKER_ID) {
		return;
	}

	// allow the user to select which libraries to migrate
	const selectedLibraries = await prompt({
		type: 'multiselect',
		name: 'libraries',
		message: 'The following libraries are installed. Select the ones you want to replace with the latest version:',
		choices: ['all', ...existingLibraries],
	});

	// prompt the user to confirm their actions as this will overwrite the existing libraries and remove any customizations
	const confirmation = (await prompt({
		type: 'confirm',
		name: 'confirm',
		message:
			'Are you sure you want to update the selected libraries? This will overwrite the existing libraries and remove any customizations.',
	})) as { confirm: boolean };

	if (!confirmation.confirm) {
		logger.info('Aborting migration.');
		return;
	}

	let { libraries } = selectedLibraries as { libraries: string[] };

	if (libraries.length === 0) {
		logger.info('No libraries will be updated.');
		return;
	}

	// if the user selected all libraries then we will update all libraries
	if (libraries.includes('all')) {
		libraries = existingLibraries;
	}

	await removeExistingLibraries(tree, options, libraries);
	await regenerateLibraries(tree, options, libraries);

	await formatFiles(tree);
}

export default migrateHelmLibrariesGenerator;

async function detectLibraries(tree: Tree) {
	const supportedLibraries = (await import('../ui/supported-ui-libraries.json').then(
		(m) => m.default,
	)) as SupportedLibraries;
	const tsconfigPaths = readTsConfigPathsFromTree(tree);

	// store the list of libraries in the tsconfig
	const existingLibraries: string[] = [];

	for (const libraryName in supportedLibraries) {
		const library = supportedLibraries[libraryName];
		if (tsconfigPaths[`@spartan-ng/${library.internalName}`]) {
			existingLibraries.push(libraryName);
		}
	}

	return existingLibraries;
}

async function removeExistingLibraries(tree: Tree, options: MigrateHelmLibrariesGeneratorSchema, libraries: string[]) {
	const tsconfigPaths = readTsConfigPathsFromTree(tree);

	for (const library of libraries) {
		// get the tsconfig path for the library
		const tsconfigPath = tsconfigPaths[`@spartan-ng/ui-${library}-helm`];

		if (!tsconfigPath) {
			throw new Error(`Could not find tsconfig path for library ${library}`);
		}

		// if there is more than one path then we assume we should use the first one
		const path = tsconfigPath[0];

		// if we are in the Nx CLI we can use the nx generator to remove a library
		if (!options.angularCli) {
			await removeGenerator(tree, {
				projectName: `ui-${library}-helm`,
				forceRemove: true,
				skipFormat: true,
				importPath: `@spartan-ng/ui-${library}-helm`,
			});
		} else {
			// get the directory of the path e.g. ./libs/ui/ui-aspectratio-helm/src/index.ts
			// we want to remove the directory ./libs/ui/ui-aspectratio-helm so we need to remove the last part of the path
			// and the src directory
			const directory = dirname(path).replace(/\/src$/, '');

			// recursively remove all files in the directory
			deleteFiles(tree, directory);

			// remove the path from the tsconfig
			updateJson(tree, getRootTsConfigPathInTree(tree), (json) => {
				delete json.compilerOptions.paths[`@spartan-ng/ui-${library}-helm`];
				return json;
			});
		}
	}
}

async function regenerateLibraries(tree: Tree, options: MigrateHelmLibrariesGeneratorSchema, libraries: string[]) {
	const supportedLibraries = (await import('../ui/supported-ui-libraries.json').then(
		(m) => m.default,
	)) as SupportedLibraries;
	const config = await getOrCreateConfig(tree);

	await createPrimitiveLibraries(
		{
			primitives: libraries,
		},
		Object.keys(supportedLibraries),
		supportedLibraries,
		tree,
		{ ...options, installPeerDependencies: true },
		config,
	);
}

function deleteFiles(tree: Tree, path: string) {
	if (tree.isFile(path)) {
		tree.delete(path);
		return;
	}

	const files = tree.children(path);

	for (const file of files) {
		deleteFiles(tree, join(path, file));
	}
}

type SupportedLibraries = Record<string, SupportedLibrary>;

interface SupportedLibrary {
	internalName: string;
	peerDependencies: Record<string, string>;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-helm-libraries/schema.d.ts
```typescript
export interface MigrateHelmLibrariesGeneratorSchema {
	directory?: string;
	rootProject?: boolean;
	tags?: string;
	angularCli?: boolean;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-helm-libraries/schema.json
```json
{
	"$schema": "https://json-schema.org/schema",
	"$id": "MigrateHelmLibraries",
	"title": "",
	"type": "object",
	"properties": {
		"directory": {
			"type": "string",
			"description": "A directory where the libraries are placed. If not specified, the default directory will be used."
		},
		"tags": {
			"type": "string",
			"description": "Add tags to the library (used for linting)."
		}
	},
	"required": []
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-scroll-area/compat.ts
```typescript
import { convertNxGenerator } from '@nx/devkit';
import { migrateScrollAreaGenerator } from './generator';

export default convertNxGenerator(migrateScrollAreaGenerator);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-scroll-area/generator.spec.ts
```typescript
import { applicationGenerator, E2eTestRunner, UnitTestRunner } from '@nx/angular/generators';
import { Tree } from '@nx/devkit';
import { createTreeWithEmptyWorkspace } from '@nx/devkit/testing';
import { migrateScrollAreaGenerator } from './generator';

// patch some imports to avoid running the actual code
jest.mock('enquirer');
jest.mock('@nx/devkit', () => {
	const original = jest.requireActual('@nx/devkit');
	return {
		...original,
		ensurePackage: (pkg: string) => jest.requireActual(pkg),
		createProjectGraphAsync: jest.fn().mockResolvedValue({
			nodes: {},
			dependencies: {},
		}),
	};
});

describe('migrate-scroll-area generator', () => {
	let tree: Tree;

	beforeEach(async () => {
		tree = createTreeWithEmptyWorkspace();

		await applicationGenerator(tree, {
			name: 'app',
			directory: 'app',
			skipFormat: true,
			e2eTestRunner: E2eTestRunner.None,
			unitTestRunner: UnitTestRunner.None,
			skipPackageJson: true,
			skipTests: true,
		});
	});

	it('should add NgScrollbarImport (NgModule)', async () => {
		tree.write(
			'app/src/app/app.module.ts',
			`
			import { NgModule } from '@angular/core';
			import { BrowserModule } from '@angular/platform-browser';
			import { HlmScrollAreaModule } from '@spartan-ng/hlm-scroll-area';

			@NgModule({
				imports: [BrowserModule, HlmScrollAreaModule],
			})
			export class AppModule {}

			`,
		);

		await migrateScrollAreaGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.module.ts', 'utf-8');
		expect(content).toContain(`import { NgScrollbarModule } from 'ngx-scrollbar';`);
		expect(content).toContain(`imports: [BrowserModule, NgScrollbarModule, HlmScrollAreaModule],`);
	});

	it('should replace HlmScrollAreaComponent (NgModule)', async () => {
		tree.write(
			'app/src/app/app.module.ts',
			`
			import { NgModule } from '@angular/core';
			import { BrowserModule } from '@angular/platform-browser';
			import { HlmScrollAreaComponent } from '@spartan-ng/hlm-scroll-area';

			@NgModule({
				imports: [BrowserModule, HlmScrollAreaComponent],
			})
			export class AppModule {}

			`,
		);

		await migrateScrollAreaGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.module.ts', 'utf-8');
		expect(content).toContain(`import { NgScrollbarModule } from 'ngx-scrollbar';`);
		expect(content).toContain(`imports: [BrowserModule, NgScrollbarModule, HlmScrollAreaDirective],`);
	});

	it('should add NgScrollbarImport (Standalone)', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';
			import { HlmScrollAreaModule } from '@spartan-ng/hlm-scroll-area';

			@Component({
				imports: [HlmScrollAreaModule],
				template: \`
					<hlm-scroll-area class="w-48 border h-72 rounded-md border-border">Content</hlm-scroll-area>
				\`
			})
			export class AppModule {}

			`,
		);

		await migrateScrollAreaGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`import { NgScrollbarModule } from 'ngx-scrollbar';`);
		expect(content).toContain(`imports: [NgScrollbarModule, HlmScrollAreaModule],`);
		expect(content).toContain(
			`<ng-scrollbar hlm class="w-48 border h-72 rounded-md border-border">Content</ng-scrollbar>`,
		);
	});

	it('should replace HlmScrollAreaComponent (Standalone)', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';
			import { HlmScrollAreaComponent } from '@spartan-ng/hlm-scroll-area';

			@Component({
				imports: [HlmScrollAreaComponent],
				template: \`
					<hlm-scroll-area class="w-48 border h-72 rounded-md border-border">Content</hlm-scroll-area>
				\`
			})
			export class AppModule {}

			`,
		);

		await migrateScrollAreaGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`import { NgScrollbarModule } from 'ngx-scrollbar';`);
		expect(content).toContain(`import { HlmScrollAreaDirective } from '@spartan-ng/hlm-scroll-area';`);
		expect(content).toContain(`imports: [NgScrollbarModule, HlmScrollAreaDirective],`);
		expect(content).toContain(
			`<ng-scrollbar hlm class="w-48 border h-72 rounded-md border-border">Content</ng-scrollbar>`,
		);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-scroll-area/generator.ts
```typescript
import { formatFiles, Tree, visitNotIgnoredFiles } from '@nx/devkit';
import { applyChangesToString, ChangeType, StringChange } from '@nx/devkit/src/utils/string-change';
import { isImported } from '@schematics/angular/utility/ast-utils';
import ts from 'typescript';
import { MigrateScrollAreaGeneratorSchema } from './schema';

export async function migrateScrollAreaGenerator(tree: Tree, { skipFormat }: MigrateScrollAreaGeneratorSchema) {
	replaceImports(tree);
	replaceSelector(tree);

	if (!skipFormat) {
		await formatFiles(tree);
	}
}

function replaceSelector(tree: Tree) {
	// if the element is `<hlm-scroll-area` then we need to replace it with `<ng-scrollbar hlm`
	// we also need to replace the closing tag `</hlm-scroll-area>` with `</ng-scrollbar>`
	visitNotIgnoredFiles(tree, '.', (path) => {
		// if this is not an html file or typescript file (inline templates) then skip
		if (!path.endsWith('.html') && !path.endsWith('.ts')) {
			return;
		}

		let content = tree.read(path, 'utf-8');

		if (!content) {
			return;
		}

		content = content.replace(/<hlm-scroll-area/g, '<ng-scrollbar hlm');
		content = content.replace(/<\/hlm-scroll-area>/g, '</ng-scrollbar>');

		tree.write(path, content);
	});
}

function replaceImports(tree: Tree) {
	// ng modules or standalone components will have import arrays that may need updated.
	// if the import is `HlmScrollAreaModule` then we need to also import `NgScrollbarModule`,
	// if the import is `HlmScrollAreaComponent` we need to rename it to `HlmScrollAreaDirective` and add the `NgScrollbarModule` import.
	visitNotIgnoredFiles(tree, '.', (path) => {
		// if the file is not a typescript file then skip
		if (!path.endsWith('.ts')) {
			return;
		}

		let content = tree.read(path, 'utf-8');

		if (!content) {
			return;
		}

		// convert the content to an ast
		const sourceFile = ts.createSourceFile(path, content, ts.ScriptTarget.Latest, true);

		// find all imports of HlmScrollAreaModule or HlmScrollAreaComponent
		const imports = findHlmScrollAreaImports(sourceFile);

		// if no imports are found then skip
		if (imports.length === 0) {
			return;
		}

		const changes: StringChange[] = [];

		for (const identifier of imports) {
			// if the identifier is HlmScrollAreaModule then we need to add NgScrollbarModule to the imports
			if (identifier.getText() === 'HlmScrollAreaModule') {
				changes.push({
					type: ChangeType.Insert,
					index: identifier.getStart(),
					text: 'NgScrollbarModule, ',
				});
			}

			// if the identifier is HlmScrollAreaComponent then we need to rename it to HlmScrollAreaDirective and add NgScrollbarModule to the imports
			if (identifier.getText() === 'HlmScrollAreaComponent') {
				changes.push({
					type: ChangeType.Insert,
					index: identifier.getStart(),
					text: 'NgScrollbarModule, ',
				});
			}

			// check if the NgScrollbarModule import is already present
			if (!hasImport(content, 'NgScrollbarModule', 'ngx-scrollbar')) {
				changes.push({
					type: ChangeType.Insert,
					index: 0,
					text: `import { NgScrollbarModule } from 'ngx-scrollbar';\n`,
				});
			}
		}

		content = applyChangesToString(content, changes);

		// if there are any remaining uses of HlmScrollAreaComponent then replace them with HlmScrollAreaDirective
		content = content.replace(/HlmScrollAreaComponent/g, 'HlmScrollAreaDirective');

		tree.write(path, content);
	});
}

function findHlmScrollAreaImports(node: ts.SourceFile): ts.Node[] {
	const matches: ts.Identifier[] = [];

	const visit = (node: ts.Node) => {
		if (
			ts.isPropertyAssignment(node) &&
			node.name.getText() === 'imports' &&
			ts.isArrayLiteralExpression(node.initializer)
		) {
			// check if the array literal contains the HlmScrollAreaModule or HlmScrollAreaComponent
			node.initializer.elements.forEach((element) => {
				if (ts.isIdentifier(element)) {
					if (element.getText() === 'HlmScrollAreaModule' || element.getText() === 'HlmScrollAreaComponent') {
						matches.push(element);
					}
				}
			});
		}

		ts.forEachChild(node, visit);
	};

	visit(node);

	return matches;
}

function hasImport(contents: string, importName: string, importPath: string): boolean {
	const sourceFile = ts.createSourceFile('temp.ts', contents, ts.ScriptTarget.Latest, true);
	return isImported(sourceFile, importName, importPath);
}

export default migrateScrollAreaGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-scroll-area/schema.d.ts
```typescript
export interface MigrateScrollAreaGeneratorSchema {
	skipFormat?: boolean;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-scroll-area/schema.json
```json
{
	"$schema": "http://json-schema.org/draft-07/schema",
	"$id": "MigrateScrollArea",
	"title": "",
	"type": "object",
	"properties": {
		"skipFormat": {
			"type": "boolean",
			"default": false,
			"description": "Skip formatting files"
		}
	},
	"required": []
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-toggle-group/compat.ts
```typescript
import { convertNxGenerator } from '@nx/devkit';
import migrateRadioGenerator from './generator';

export default convertNxGenerator(migrateRadioGenerator);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-toggle-group/generator.spec.ts
```typescript
import { applicationGenerator, E2eTestRunner, UnitTestRunner } from '@nx/angular/generators';
import { Tree } from '@nx/devkit';
import { createTreeWithEmptyWorkspace } from '@nx/devkit/testing';
import { migrateToggleGroupGenerator } from './generator';

// patch some imports to avoid running the actual code
jest.mock('enquirer');
jest.mock('@nx/devkit', () => {
	const original = jest.requireActual('@nx/devkit');
	return {
		...original,
		ensurePackage: (pkg: string) => jest.requireActual(pkg),
		createProjectGraphAsync: jest.fn().mockResolvedValue({
			nodes: {},
			dependencies: {},
		}),
	};
});

describe('migrate-toggle-group generator', () => {
	let tree: Tree;

	beforeEach(async () => {
		tree = await createTreeWithEmptyWorkspace();

		await applicationGenerator(tree, {
			name: 'app',
			directory: 'app',
			skipFormat: true,
			e2eTestRunner: E2eTestRunner.None,
			unitTestRunner: UnitTestRunner.None,
			skipPackageJson: true,
			skipTests: true,
		});
	});

	it('should replace BrnToggleGroupModule with BrnToggleGroupModule, BrnToggleGroupItemDirective', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
				import { Component } from '@angular/core';
				import { BrnToggleGroupModule, BrnToggleDirective } from '@spartan-ng/brain/toggle';
				import { HlmToggleDirective, HlmToggleGroupModule } from '@spartan-ng/ui-toggle-helm';

				@Component({
					imports: [BrnToggleGroupModule, HlmToggleGroupModule, HlmButtonDirective, FormsModule, NgForOf, NgIf],
					],
					template: \`
     	<div class="flex space-x-4">
				<brn-toggle-group hlm [disabled]="disabled" [nullable]="nullable" [multiple]="multiple" [(ngModel)]="selected">
				<button variant="outline" *ngFor="let city of cities; let last = last" [value]="city" hlm brnToggle>
					{{ city.name }}
				</button>
				</brn-toggle-group>
				<button hlmBtn size="sm" (click)="setToSyracuse()">Set to Syracuse</button>
				<button hlmBtn size="sm" (click)="addCity()">Add Piraeus</button>
			</div>
					\`
				})
				export class AppModule {}
				`,
		);

		await migrateToggleGroupGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).not.toContain("import { BrnToggleGroupModule } from '@spartan-ng/brain/toggle'");
		expect(content).toContain(
			"import { BrnToggleGroupComponent, BrnToggleGroupItemDirective } from '@spartan-ng/brain/toggle-group'",
		);
		expect(content).toContain(
			"import { HlmToggleGroupDirective, HlmToggleGroupItemDirective } from '@spartan-ng/ui-toggle-group-helm'",
		);
		expect(content).toContain(
			'imports: [BrnToggleGroupComponent, BrnToggleGroupItemDirective, HlmToggleGroupDirective, HlmToggleGroupItemDirective, HlmButtonDirective, FormsModule, NgForOf, NgIf],',
		);
	});

	it('should replace brnToggle with hlmToggleGroupItem', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
				import { Component } from '@angular/core';
				import { BrnToggleGroupModule } from '@spartan-ng/brain/toggle';
				import { HlmButtonDirective, FormsModule, NgForOf, NgIf } from '@spartan-ng/ui-toggle-group-helm';
				@Component({
					imports: [BrnToggleGroupModule, HlmToggleGroupModule, HlmButtonDirective, FormsModule, NgForOf, NgIf],
					template: \`
     	<div class="flex space-x-4">
				<brn-toggle-group hlm [disabled]="disabled" [nullable]="nullable" [multiple]="multiple" [(ngModel)]="selected">
				<button variant="outline" *ngFor="let city of cities; let last = last" [value]="city" hlm brnToggle>
					{{ city.name }}
				</button>
				</brn-toggle-group>
				<button hlmBtn size="sm" (click)="setToSyracuse()">Set to Syracuse</button>
				<button hlmBtn size="sm" (click)="addCity()">Add Piraeus</button>
			</div>
					\`
				})
				export class AppModule {}
				`,
		);

		await migrateToggleGroupGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).not.toContain('brnToggle');
		expect(content).toContain('hlmToggleGroupItem');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-toggle-group/generator.ts
```typescript
import { formatFiles, Tree } from '@nx/devkit';
import { visitFiles } from '../../utils/visit-files';
import { MigrateToggleGroupGeneratorSchema } from './schema';

export async function migrateToggleGroupGenerator(tree: Tree, { skipFormat }: MigrateToggleGroupGeneratorSchema) {
	updateBrainImports(tree);
	updateHlmImports(tree);
	replaceSelector(tree);

	if (!skipFormat) {
		await formatFiles(tree);
	}
}

/**
 * Update brain imports to migrate from toggle to toggle-group
 */
function updateBrainImports(tree: Tree) {
	visitFiles(tree, '/', (path) => {
		// Filter for TypeScript files that might contain the imports we're interested in
		if (!path.endsWith('.ts')) return;

		let content = tree.read(path)?.toString();
		if (!content) return;

		// Only proceed if file has BrnToggleGroupModule from toggle but not from toggle-group
		if (
			content.includes('BrnToggleGroupModule') &&
			content.includes("from '@spartan-ng/brain/toggle'") &&
			!content.includes("from '@spartan-ng/brain/toggle-group'")
		) {
			// Remove BrnToggleGroupModule from the toggle import
			content = content.replace(
				/import\s+\{\s*([^{}]*BrnToggleGroupModule[^{}]*)\s*\}\s+from\s+['"]@spartan-ng\/brain\/toggle['"];/g,
				(_match, importList) => {
					// Remove BrnToggleGroupModule from the import list
					const newImportList = importList
						.split(',')
						.map((item) => item.trim())
						.filter((item) => item !== 'BrnToggleGroupModule')
						.join(', ');

					// If there are still imports remaining, return the modified import statement
					if (newImportList.length > 0) {
						return `import { ${newImportList} } from '@spartan-ng/brain/toggle';`;
					} else {
						// If no imports remain, remove the entire import statement
						return '';
					}
				},
			);

			// Add the new toggle-group import with BrnToggleGroupComponent and BrnToggleGroupItemDirective
			const importRegex = /import\s+.*?;/g;
			let match;
			let lastImportEndIndex = 0;

			while ((match = importRegex.exec(content)) !== null) {
				lastImportEndIndex = match.index + match[0].length;
			}

			// If we found imports, add after the last one
			if (lastImportEndIndex > 0) {
				const newImport = `\nimport { BrnToggleGroupComponent, BrnToggleGroupItemDirective } from '@spartan-ng/brain/toggle-group';`;
				content = content.substring(0, lastImportEndIndex) + newImport + content.substring(lastImportEndIndex);
			} else {
				// If no imports found, add at the beginning
				const newImport = `import { BrnToggleGroupComponent, BrnToggleGroupItemDirective } from '@spartan-ng/brain/toggle-group';\n\n`;
				content = newImport + content;
			}

			// Update component imports to include BrnToggleGroupItemDirective
			content = content.replace(
				/imports:\s*\[\s*BrnToggleGroupModule\s*,/g,
				'imports: [BrnToggleGroupComponent, BrnToggleGroupItemDirective,',
			);

			// Also handle the case where BrnToggleGroupModule is the only import
			content = content.replace(
				/imports:\s*\[\s*BrnToggleGroupModule\s*\]/g,
				'imports: [BrnToggleGroupComponent, BrnToggleGroupItemDirective]',
			);

			tree.write(path, content);
		}
	});

	return tree;
}

/**
 * Update hlm imports to migrate from toggle to toggle-group
 */
function updateHlmImports(tree: Tree) {
	visitFiles(tree, '/', (path) => {
		// Filter for TypeScript files that might contain the imports we're interested in
		if (!path.endsWith('.ts')) return;

		let content = tree.read(path)?.toString();
		if (!content) return;

		// Only proceed if file has imports from ui-toggle-helm but not from ui-toggle-group-helm
		if (
			content.includes("from '@spartan-ng/ui-toggle-helm'") &&
			!content.includes("from '@spartan-ng/ui-toggle-group-helm'")
		) {
			// Replace HlmToggleDirective and HlmToggleGroupModule with the directives
			// Handle case with HlmToggleDirective
			content = content.replace(
				/import\s+\{\s*HlmToggleDirective\s*,\s*HlmToggleGroupModule\s*\}\s+from\s+['"]@spartan-ng\/ui-toggle-helm['"];/g,
				"import { HlmToggleGroupDirective, HlmToggleGroupItemDirective } from '@spartan-ng/ui-toggle-group-helm';",
			);

			// Also handle case with just HlmToggleGroupModule
			content = content.replace(
				/import\s+\{\s*HlmToggleGroupModule\s*\}\s+from\s+['"]@spartan-ng\/ui-toggle-helm['"];/g,
				"import { HlmToggleGroupDirective, HlmToggleGroupItemDirective } from '@spartan-ng/ui-toggle-group-helm';",
			);

			// Update the imports array to replace HlmToggleGroupModule with the directives
			// For the case where HlmToggleGroupModule is in the middle of other imports
			content = content.replace('HlmToggleGroupModule', 'HlmToggleGroupDirective, HlmToggleGroupItemDirective');

			tree.write(path, content);
		}
	});

	return tree;
}

/**
 * Replace brnToggle with hlmToggleGroupItem inside the brn-toggle-group
 */
function replaceSelector(_tree: Tree) {
	visitFiles(_tree, '/', (path) => {
		if (!path.endsWith('.html') && !path.endsWith('.ts')) {
			return;
		}

		let content = _tree.read(path)?.toString();

		if (!content) return;

		// if file contains @spartan-ng/ui-toggle-group-helm
		if (content.includes('@spartan-ng/ui-toggle-group-helm')) {
			content = content.replace(/brnToggle/g, 'hlmToggleGroupItem');
		}

		_tree.write(path, content);
	});

	return true;
}

export default migrateToggleGroupGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-toggle-group/schema.d.ts
```typescript
export interface MigrateToggleGroupGeneratorSchema {
	skipFormat?: boolean;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-toggle-group/schema.json
```json
{
	"$schema": "https://json-schema.org/schema",
	"$id": "MigrateRadio",
	"title": "",
	"type": "object",
	"properties": {
		"skipFormat": {
			"type": "boolean",
			"default": false,
			"description": "Skip formatting files"
		}
	},
	"required": []
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-brain-imports/compat.ts
```typescript
import { convertNxGenerator } from '@nx/devkit';
import { migrateBrainImportsGenerator } from './generator';

export default convertNxGenerator(migrateBrainImportsGenerator);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-brain-imports/generator.ts
```typescript
import { formatFiles, Tree, visitNotIgnoredFiles } from '@nx/devkit';
import { getPackageManagerCommand, logger, readJson, updateJson } from 'nx/src/devkit-exports';
import type { PackageJson } from 'nx/src/utils/package-json';
import { basename } from 'path';
import imports from './import-map';
import { MigrateBrainImportsGeneratorSchema } from './schema';
import { isBinaryPath } from './utils/binary-extensions';

export async function migrateBrainImportsGenerator(tree: Tree, options: MigrateBrainImportsGeneratorSchema) {
	if (!options.skipInstall) {
		ensureBrainPackageIsInstalled(tree);
	}

	for (const [from, to] of Object.entries(imports)) {
		replaceBrainPackageWithSecondaryEntrypoint(tree, options, from, to as string);
	}

	if (!options.skipFormat) {
		await formatFiles(tree);
	}
}

function ensureBrainPackageIsInstalled(tree: Tree) {
	// read the root package.json
	const packageJson = readJson<PackageJson>(tree, 'package.json');

	// merge all dependencies so we easily search for the cli package
	const deps = { ...packageJson.dependencies, ...packageJson.devDependencies };

	// check if the brain package is installed
	if (deps['@spartan-ng/brain']) {
		return;
	}

	// the brain package version should be the same as the cli package
	updateJson<PackageJson>(tree, 'package.json', (packageJson) => {
		packageJson.dependencies['@spartan-ng/brain'] = deps['@spartan-ng/cli'];
		return packageJson;
	});

	const { install } = getPackageManagerCommand();

	logger.warn(
		`The @spartan-ng/brain package has been added to your dependencies. Please run '${install}' to install the package.`,
	);
}

export function replaceBrainPackageWithSecondaryEntrypoint(
	tree: Tree,
	options: MigrateBrainImportsGeneratorSchema,
	oldImport: string,
	newImport: string,
): void {
	if (!options.skipInstall) {
		removePackageInDependencies(tree, oldImport);
	}

	replaceUsages(tree, oldImport, newImport);
}

function removePackageInDependencies(tree: Tree, oldPackageName: string) {
	visitNotIgnoredFiles(tree, '.', (path) => {
		if (basename(path) !== 'package.json') {
			return;
		}

		try {
			updateJson<PackageJson>(tree, path, (packageJson) => {
				for (const deps of [
					packageJson.dependencies ?? {},
					packageJson.devDependencies ?? {},
					packageJson.peerDependencies ?? {},
					packageJson.optionalDependencies ?? {},
				]) {
					if (oldPackageName in deps) {
						delete deps[oldPackageName];
					}
				}
				return packageJson;
			});
		} catch (e) {
			console.warn(`Could not remove ${oldPackageName} in ${path}.`);
		}
	});
}

// based on https://github.com/nrwl/nx/blob/master/packages/devkit/src/utils/replace-package.ts
function replaceUsages(tree: Tree, oldPackageName: string, newPackageName: string) {
	visitNotIgnoredFiles(tree, '.', (path) => {
		if (isBinaryPath(path)) {
			return;
		}

		const ignoredFiles = [
			'yarn.lock',
			'package-lock.json',
			'pnpm-lock.yaml',
			'bun.lockb',
			'CHANGELOG.md',
			// this is relevant for this repo only - and this file is auto-generated
			'supported-ui-libraries.json',
			// we don't want to replace usages in the import map as these are used to detect the usages
			'import-map.ts',
		];
		if (ignoredFiles.includes(basename(path))) {
			return;
		}

		try {
			const contents = tree.read(path).toString();

			if (!contents.includes(oldPackageName)) {
				return;
			}

			tree.write(path, contents.replace(new RegExp(oldPackageName, 'g'), newPackageName));
		} catch {
			logger.warn(`Could not replace ${oldPackageName} with ${newPackageName} in ${path}.`);
		}
	});
}

export default migrateBrainImportsGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-brain-imports/import-map.ts
```typescript
export default {
	'@spartan-ng/ui-checkbox-brain': '@spartan-ng/brain/checkbox',
	'@spartan-ng/ui-avatar-brain': '@spartan-ng/brain/avatar',
	'@spartan-ng/ui-accordion-brain': '@spartan-ng/brain/accordion',
	'@spartan-ng/ui-label-brain': '@spartan-ng/brain/label',
	'@spartan-ng/ui-slider-brain': '@spartan-ng/brain/slider',
	'@spartan-ng/ui-alert-dialog-brain': '@spartan-ng/brain/alert-dialog',
	'@spartan-ng/ui-calendar-brain': '@spartan-ng/brain/calendar',
	'@spartan-ng/ui-collapsible-brain': '@spartan-ng/brain/collapsible',
	'@spartan-ng/ui-command-brain': '@spartan-ng/brain/command',
	'@spartan-ng/ui-dialog-brain': '@spartan-ng/brain/dialog',
	'@spartan-ng/ui-form-field-brain': '@spartan-ng/brain/form-field',
	'@spartan-ng/ui-forms-brain': '@spartan-ng/brain/forms',
	'@spartan-ng/ui-hover-card-brain': '@spartan-ng/brain/hover-card',
	'@spartan-ng/ui-menu-brain': '@spartan-ng/brain/menu',
	'@spartan-ng/ui-popover-brain': '@spartan-ng/brain/popover',
	'@spartan-ng/ui-progress-brain': '@spartan-ng/brain/progress',
	'@spartan-ng/ui-radio-group-brain': '@spartan-ng/brain/radio-group',
	'@spartan-ng/ui-select-brain': '@spartan-ng/brain/select',
	'@spartan-ng/ui-separator-brain': '@spartan-ng/brain/separator',
	'@spartan-ng/ui-sheet-brain': '@spartan-ng/brain/sheet',
	'@spartan-ng/ui-switch-brain': '@spartan-ng/brain/switch',
	'@spartan-ng/ui-table-brain': '@spartan-ng/brain/table',
	'@spartan-ng/ui-tabs-brain': '@spartan-ng/brain/tabs',
	'@spartan-ng/ui-toggle-brain': '@spartan-ng/brain/toggle',
	'@spartan-ng/ui-toggle-group-brain': '@spartan-ng/brain/toggle-group',
	'@spartan-ng/ui-tooltip-brain': '@spartan-ng/brain/tooltip',
	'@spartan-ng/ui-date-time-brain': '@spartan-ng/brain/date-time',
	'@spartan-ng/ui-date-time-luxon-brain': '@spartan-ng/brain/date-time-luxon',
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-brain-imports/schema.d.ts
```typescript
export interface MigrateBrainImportsGeneratorSchema {
	skipInstall?: boolean;
	skipFormat?: boolean;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-brain-imports/schema.json
```json
{
	"$schema": "http://json-schema.org/draft-07/schema",
	"$id": "MigrateBrainImports",
	"title": "",
	"type": "object",
	"properties": {
		"skipFormat": {
			"type": "boolean",
			"description": "Skip formatting the code after migration."
		},
		"skipInstall": {
			"type": "boolean",
			"description": "Whether to verify the brain package is installed."
		}
	},
	"required": []
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-brain-imports/utils/binary-extensions.ts
```typescript
import { extname } from 'path';

// based on https://github.com/nrwl/nx/blob/master/packages/devkit/src/utils/binary-extensions.ts
const binaryExtensions = new Set([
	'.3dm',
	'.3ds',
	'.3g2',
	'.3gp',
	'.7z',
	'.a',
	'.aac',
	'.adp',
	'.ai',
	'.aif',
	'.aiff',
	'.als',
	'.alz',
	'.ape',
	'.apk',
	'.appimage',
	'.ar',
	'.arj',
	'.asf',
	'.au',
	'.avi',
	'.bak',
	'.baml',
	'.bh',
	'.bin',
	'.bk',
	'.bmp',
	'.btif',
	'.bz2',
	'.bzip2',
	'.cab',
	'.caf',
	'.cgm',
	'.class',
	'.cmx',
	'.cpio',
	'.cr2',
	'.cur',
	'.dat',
	'.dcm',
	'.deb',
	'.dex',
	'.djvu',
	'.dll',
	'.dmg',
	'.dng',
	'.doc',
	'.docm',
	'.docx',
	'.dot',
	'.dotm',
	'.dra',
	'.DS_Store',
	'.dsk',
	'.dts',
	'.dtshd',
	'.dvb',
	'.dwg',
	'.dxf',
	'.ecelp4800',
	'.ecelp7470',
	'.ecelp9600',
	'.egg',
	'.eol',
	'.eot',
	'.epub',
	'.exe',
	'.f4v',
	'.fbs',
	'.fh',
	'.fla',
	'.flac',
	'.flatpak',
	'.fli',
	'.flv',
	'.fpx',
	'.fst',
	'.fvt',
	'.g3',
	'.gh',
	'.gif',
	'.glb',
	'.graffle',
	'.gz',
	'.gzip',
	'.h261',
	'.h263',
	'.h264',
	'.icns',
	'.ico',
	'.ief',
	'.img',
	'.ipa',
	'.iso',
	'.jar',
	'.jpeg',
	'.jpg',
	'.jpgv',
	'.jpm',
	'.jxr',
	'.key',
	'.keystore',
	'.ktx',
	'.lha',
	'.lib',
	'.lvp',
	'.lz',
	'.lzh',
	'.lzma',
	'.lzo',
	'.m3u',
	'.m4a',
	'.m4v',
	'.mar',
	'.mdi',
	'.mht',
	'.mid',
	'.midi',
	'.mj2',
	'.mka',
	'.mkv',
	'.mmr',
	'.mng',
	'.mobi',
	'.mov',
	'.movie',
	'.mp3',
	'.mp4',
	'.mp4a',
	'.mpeg',
	'.mpg',
	'.mpga',
	'.msi',
	'.mxu',
	'.nef',
	'.npx',
	'.npy',
	'.numbers',
	'.nupkg',
	'.o',
	'.odp',
	'.ods',
	'.odt',
	'.oga',
	'.ogg',
	'.ogv',
	'.otf',
	'.ott',
	'.pages',
	'.pbm',
	'.pbf',
	'.pcx',
	'.pdb',
	'.pdf',
	'.pea',
	'.pgm',
	'.pic',
	'.pkg',
	'.plist',
	'.png',
	'.pnm',
	'.pot',
	'.potm',
	'.potx',
	'.ppa',
	'.ppam',
	'.ppm',
	'.pps',
	'.ppsm',
	'.ppsx',
	'.ppt',
	'.pptm',
	'.pptx',
	'.psd',
	'.pxd',
	'.pxz',
	'.pya',
	'.pyc',
	'.pyo',
	'.pyv',
	'.qt',
	'.rar',
	'.ras',
	'.raw',
	'.resources',
	'.rgb',
	'.rip',
	'.rlc',
	'.rmf',
	'.rmvb',
	'.rpm',
	'.rtf',
	'.rz',
	'.s3m',
	'.s7z',
	'.scpt',
	'.sgi',
	'.shar',
	'.snap',
	'.sil',
	'.sketch',
	'.slk',
	'.smv',
	'.snk',
	'.so',
	'.stl',
	'.suo',
	'.sub',
	'.swf',
	'.tar',
	'.tbz',
	'.tbz2',
	'.tga',
	'.tgz',
	'.thmx',
	'.tif',
	'.tiff',
	'.tlz',
	'.ttc',
	'.ttf',
	'.txz',
	'.udf',
	'.uvh',
	'.uvi',
	'.uvm',
	'.uvp',
	'.uvs',
	'.uvu',
	'.viv',
	'.vob',
	'.war',
	'.wav',
	'.wax',
	'.wbmp',
	'.wdp',
	'.weba',
	'.webm',
	'.webp',
	'.whl',
	'.wim',
	'.wm',
	'.wma',
	'.wmv',
	'.wmx',
	'.woff',
	'.woff2',
	'.wrm',
	'.wvx',
	'.xbm',
	'.xif',
	'.xla',
	'.xlam',
	'.xls',
	'.xlsb',
	'.xlsm',
	'.xlsx',
	'.xlt',
	'.xltm',
	'.xltx',
	'.xm',
	'.xmind',
	'.xpi',
	'.xpm',
	'.xwd',
	'.xz',
	'.z',
	'.zip',
	'.zipx',
]);

export function isBinaryPath(path: string): boolean {
	return binaryExtensions.has(extname(path).toLowerCase());
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-core/compat.ts
```typescript
import { convertNxGenerator } from '@nx/devkit';
import { migrateCoreGenerator } from './generator';

export default convertNxGenerator(migrateCoreGenerator);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-core/generator.spec.ts
```typescript
import { applicationGenerator, E2eTestRunner, UnitTestRunner } from '@nx/angular/generators';
import { Tree } from '@nx/devkit';
import { createTreeWithEmptyWorkspace } from '@nx/devkit/testing';
import { migrateCoreGenerator } from './generator';
import { MigrateCoreGeneratorSchema } from './schema';

// patch some imports to avoid running the actual code
jest.mock('enquirer');
jest.mock('@nx/devkit', () => {
	const original = jest.requireActual('@nx/devkit');
	return {
		...original,
		ensurePackage: (pkg: string) => jest.requireActual(pkg),
		createProjectGraphAsync: jest.fn().mockResolvedValue({
			nodes: {},
			dependencies: {},
		}),
	};
});

describe('migrate-core generator', () => {
	let tree: Tree;
	const options: MigrateCoreGeneratorSchema = { skipFormat: true };

	beforeEach(async () => {
		tree = createTreeWithEmptyWorkspace();

		await applicationGenerator(tree, {
			name: 'app',
			directory: 'app',
			skipFormat: true,
			e2eTestRunner: E2eTestRunner.None,
			unitTestRunner: UnitTestRunner.None,
			skipPackageJson: true,
			skipTests: true,
		});
	});

	it('should update the import statements', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';
			import { hlm } from '@spartan-ng/ui-core';

			@Component({
				template: \`
				\`
			})
			export class AppComponent {}
			`,
		);

		await migrateCoreGenerator(tree, options);

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`import { hlm } from '@spartan-ng/brain/core';`);
	});

	it('should update the import statements with multiple imports', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';
			import { hlm, brnZoneFull, createInjectionToken, ExposesState } from '@spartan-ng/ui-core';

			@Component({
				template: \`
				\`
			})
			export class AppComponent {}
			`,
		);

		await migrateCoreGenerator(tree, options);

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(
			`import { hlm, brnZoneFull, createInjectionToken, ExposesState } from '@spartan-ng/brain/core';`,
		);
	});

	it('should import type only imports', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';
			import type { hlm } from '@spartan-ng/ui-core';

			@Component({
				template: \`
				\`
			})
			export class AppComponent {}
			`,
		);

		await migrateCoreGenerator(tree, options);

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`import type { hlm } from '@spartan-ng/brain/core';`);
	});

	it('should update default imports', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';
			import hlm from '@spartan-ng/ui-core';

			@Component({
				template: \`
				\`
			})
			export class AppComponent {}
			`,
		);

		await migrateCoreGenerator(tree, options);

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`import hlm from '@spartan-ng/brain/core';`);
	});

	it('should update star imports', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';
			import * as hlm from '@spartan-ng/ui-core';

			@Component({
				template: \`
				\`
			})
			export class AppComponent {}
			`,
		);

		await migrateCoreGenerator(tree, options);

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`import * as hlm from '@spartan-ng/brain/core';`);
	});

	it('should update exports', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			export { hlm } from '@spartan-ng/ui-core';
			`,
		);
		await migrateCoreGenerator(tree, options);

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`export { hlm } from '@spartan-ng/brain/core';`);
	});

	it('should update star exports', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			export * from '@spartan-ng/ui-core';
			`,
		);
		await migrateCoreGenerator(tree, options);

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`export * from '@spartan-ng/brain/core';`);
	});

	it('should update the tailwind config file', async () => {
		tree.write(
			'app/tailwind.config.js',
			`
/** @type {import('tailwindcss').Config} */
module.exports = {
	presets: [require('@spartan-ng/ui-core/hlm-tailwind-preset')],
	content: [
		'./src/**/*.{html,ts}',
	],
	theme: {
		extend: {},
	},
	plugins: [],
};
			`,
		);

		await migrateCoreGenerator(tree, options);

		const content = tree.read('app/tailwind.config.js', 'utf-8');
		expect(content).toContain(`/** @type {import('tailwindcss').Config} */
module.exports = {
	presets: [require('@spartan-ng/brain/hlm-tailwind-preset')],
	content: [
		'./src/**/*.{html,ts}',
	],
	theme: {
		extend: {},
	},
	plugins: [],
};`);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-core/generator.ts
```typescript
import { formatFiles, Tree } from '@nx/devkit';
import { visitFiles } from '../../utils/visit-files';
import { MigrateCoreGeneratorSchema } from './schema';

export async function migrateCoreGenerator(tree: Tree, options: MigrateCoreGeneratorSchema) {
	updateImports(tree);
	updateTailwindConfig(tree);

	if (!options.skipFormat) {
		await formatFiles(tree);
	}
}

/**
 * Update imports from @spartan-ng/ui-core to @spartan-ng/brain/core
 */
function updateImports(tree: Tree) {
	visitFiles(tree, '/', (path) => {
		const content = tree.read(path).toString('utf-8');

		if (content.includes('@spartan-ng/ui-core')) {
			const updatedCode = content
				// Handle `import { ... } from '@spartan-ng/ui-core';`
				.replace(/import\s+\{[^}]*\}\s+from\s+['"]@spartan-ng\/ui-core['"];/g, (match) =>
					match.replace('@spartan-ng/ui-core', '@spartan-ng/brain/core'),
				)
				// Handle `import type { ... } from '@spartan-ng/ui-core';`
				.replace(/import\s+type\s+\{[^}]*\}\s+from\s+['"]@spartan-ng\/ui-core['"];/g, (match) =>
					match.replace('@spartan-ng/ui-core', '@spartan-ng/brain/core'),
				)
				// Handle `export { ... } from '@spartan-ng/ui-core';`
				.replace(/export\s+\{[^}]*\}\s+from\s+['"]@spartan-ng\/ui-core['"];/g, (match) =>
					match.replace('@spartan-ng/ui-core', '@spartan-ng/brain/core'),
				)
				// Handle `import * as name from '@spartan-ng/ui-core';`
				.replace(/import\s+\*\s+as\s+\w+\s+from\s+['"]@spartan-ng\/ui-core['"];/g, (match) =>
					match.replace('@spartan-ng/ui-core', '@spartan-ng/brain/core'),
				)
				// Handle `import defaultExport from '@spartan-ng/ui-core';`
				.replace(/import\s+\w+\s+from\s+['"]@spartan-ng\/ui-core['"];/g, (match) =>
					match.replace('@spartan-ng/ui-core', '@spartan-ng/brain/core'),
				)
				// Handle `export * from '@spartan-ng/ui-core';`
				.replace(/export\s+\*\s+from\s+['"]@spartan-ng\/ui-core['"];/g, (match) =>
					match.replace('@spartan-ng/ui-core', '@spartan-ng/brain/core'),
				);

			tree.write(path, updatedCode);
		}
	});
}

/**
 * Update the tailwind config file
 */
function updateTailwindConfig(tree: Tree) {
	visitFiles(tree, '/', (path) => {
		// technically the tailwind config file could be anywhere and named anything
		// but all we need to do is a simple string replace '@spartan-ng/ui-core/hlm-tailwind-preset' with '@spartan-ng/brain/hlm-tailwind-preset'
		const content = tree.read(path).toString('utf-8');

		if (content.includes('@spartan-ng/ui-core/hlm-tailwind-preset')) {
			const updatedCode = content.replace(
				/@spartan-ng\/ui-core\/hlm-tailwind-preset/g,
				'@spartan-ng/brain/hlm-tailwind-preset',
			);

			tree.write(path, updatedCode);
		}
	});
}

export default migrateCoreGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-core/schema.d.ts
```typescript
export interface MigrateCoreGeneratorSchema {
	skipFormat?: boolean;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-core/schema.json
```json
{
	"$schema": "http://json-schema.org/draft-07/schema",
	"$id": "MigrateCore",
	"title": "",
	"type": "object",
	"properties": {
		"skipFormat": {
			"type": "boolean",
			"default": false,
			"description": "Skip formatting files"
		}
	},
	"required": []
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/base/generator.ts
```typescript
import {
	type GeneratorCallback,
	type Tree,
	addDependenciesToPackageJson,
	generateFiles,
	joinPathFragments,
	runTasksInSerial,
} from '@nx/devkit';
import { addTsConfigPath } from '@nx/js';
import * as path from 'node:path';
import { readTsConfigPathsFromTree } from '../../utils/tsconfig';
import { getInstalledPackageVersion } from '../../utils/version-utils';
import { buildDependencyArray, buildDevDependencyArray } from './lib/build-dependency-array';
import { getTargetLibraryDirectory } from './lib/get-target-library-directory';
import { initializeAngularLibrary } from './lib/initialize-angular-library';
import type { HlmBaseGeneratorSchema } from './schema';
import { FALLBACK_ANGULAR_VERSION } from './versions';

export async function hlmBaseGenerator(tree: Tree, options: HlmBaseGeneratorSchema) {
	const tasks: GeneratorCallback[] = [];
	const targetLibDir = getTargetLibraryDirectory(options, tree);

	const existingPathsByAlias = readTsConfigPathsFromTree(tree);
	const tsConfigAliasToUse = `@spartan-ng/${options.publicName}`;

	if (Object.keys(existingPathsByAlias).includes(tsConfigAliasToUse)) {
		console.log(`Skipping ${tsConfigAliasToUse}. It's already installed!`);
		return runTasksInSerial(...tasks);
	}

	if (options.angularCli) {
		addTsConfigPath(tree, tsConfigAliasToUse, [`.${path.sep}${joinPathFragments(targetLibDir, 'src', 'index.ts')}`]);
	} else {
		tasks.push(await initializeAngularLibrary(tree, options));
	}

	generateFiles(
		tree,
		path.join(__dirname, '..', 'ui', 'libs', options.internalName, 'files'),
		path.join(targetLibDir, 'src'),
		options,
	);

	const angularVersion = getInstalledPackageVersion(tree, '@angular/core', FALLBACK_ANGULAR_VERSION, true);
	const existingCdkVersion = getInstalledPackageVersion(tree, '@angular/cdk', FALLBACK_ANGULAR_VERSION, true);
	const dependencies = buildDependencyArray(options, angularVersion, existingCdkVersion);
	const devDependencies = buildDevDependencyArray();

	tasks.push(addDependenciesToPackageJson(tree, dependencies, devDependencies));
	return runTasksInSerial(...tasks);
}

export default hlmBaseGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/base/schema.d.ts
```typescript
export interface HlmBaseGeneratorSchema {
	primitiveName: string;
	internalName: string;
	publicName: string;
	directory?: string;
	rootProject?: boolean;
	tags?: string;
	peerDependencies?: Record<string, string>;
	angularCli?: boolean;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/base/schema.json
```json
{
	"$schema": "http://json-schema.org/draft-07/schema",
	"$id": "HlmBaseGeneratorSchema",
	"title": "",
	"type": "object",
	"properties": {
		"directory": {
			"type": "string",
			"description": "A directory where the lib is placed.",
			"x-priority": "important"
		},
		"tags": {
			"type": "string",
			"description": "Add tags to the library (used for linting)."
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/base/versions.ts
```typescript
// angular dependency
export const FALLBACK_ANGULAR_VERSION = '^18.0.0';
// ng-icon dependency
export const NG_ICONS_VERSION = '^29.10.0';
// spartan dependencies
export const SPARTAN_BRAIN_VERSION = '0.0.1-alpha.381';
// dev dependencies
export const TAILWIND_MERGE_VERSION = '^2.2.0';
export const TAILWINDCSS_VERSION = '^3.0.2';
export const TAILWIND_ANIMATE_VERSION = '^1.0.6';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/base/lib/build-dependency-array.ts
```typescript
import type { HlmBaseGeneratorSchema } from '../schema';
import {
	NG_ICONS_VERSION,
	SPARTAN_BRAIN_VERSION,
	TAILWINDCSS_VERSION,
	TAILWIND_ANIMATE_VERSION,
	TAILWIND_MERGE_VERSION,
} from '../versions';

export function buildDependencyArray(
	options: HlmBaseGeneratorSchema,
	angularVersion: string,
	existingCdkVersion: string,
) {
	let dependencies: Record<string, string> = {
		'@angular/cdk': existingCdkVersion ?? angularVersion,
		'@spartan-ng/brain': SPARTAN_BRAIN_VERSION,
	};

	if (options.peerDependencies) {
		dependencies = { ...dependencies, ...options.peerDependencies };
	}

	if (options.primitiveName === 'icon') {
		dependencies = { ...dependencies, '@ng-icons/core': NG_ICONS_VERSION };
	}
	return dependencies;
}

export function buildDevDependencyArray() {
	return {
		'tailwind-merge': TAILWIND_MERGE_VERSION,
		tailwindcss: TAILWINDCSS_VERSION,
		'tailwindcss-animate': TAILWIND_ANIMATE_VERSION,
	};
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/base/lib/get-target-library-directory.ts
```typescript
import { type Tree, extractLayoutDirectory, getWorkspaceLayout } from '@nx/devkit';
import * as path from 'node:path';
import type { HlmBaseGeneratorSchema } from '../schema';

export function getTargetLibraryDirectory(options: HlmBaseGeneratorSchema, tree: Tree) {
	const { layoutDirectory, projectDirectory } = extractLayoutDirectory(options.directory);
	const workspaceLayout = getWorkspaceLayout(tree);
	const baseLibsDir = layoutDirectory ?? workspaceLayout.libsDir;
	const libsDir = options.rootProject ? '.' : baseLibsDir;
	return path.join(libsDir, projectDirectory, options.publicName);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/base/lib/initialize-angular-library.ts
```typescript
import { type Tree, joinPathFragments } from '@nx/devkit';
import type { HlmBaseGeneratorSchema } from '../schema';

export async function initializeAngularLibrary(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await (
		await import(
			// eslint-disable-next-line @typescript-eslint/ban-ts-comment
			// @ts-ignore
			'@nx/angular/generators'
		)
	).libraryGenerator(tree, {
		name: options.publicName,
		skipFormat: true,
		simpleName: true,
		buildable: true,
		importPath: `@spartan-ng/${options.publicName}`,
		prefix: 'hlm',
		skipModule: true,
		directory: joinPathFragments(options.directory, options.publicName),
		tags: options.tags,
	});
}

```
