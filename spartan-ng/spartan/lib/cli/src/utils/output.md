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
