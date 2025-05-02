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
