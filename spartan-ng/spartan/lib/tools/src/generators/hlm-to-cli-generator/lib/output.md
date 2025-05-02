/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/hlm-to-cli-generator/lib/add-primitive-to-supported-ui-libraries.ts
```typescript
import type { Tree } from '@nx/devkit';
import { updateJson } from 'nx/src/generators/utils/json';

export const addPrimitiveToSupportedUILibraries = (
	tree: Tree,
	supportedJsonPath: string,
	generatorName: string,
	internalName: string,
	peerDependencies: Record<string, string>,
) => {
	updateJson(tree, supportedJsonPath, (old) => ({
		...old,
		[generatorName]: {
			internalName,
			peerDependencies,
		},
	}));
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/hlm-to-cli-generator/lib/file-management.ts
```typescript
import { type Tree, generateFiles } from '@nx/devkit';
import * as path from 'node:path';
import type { HlmToCliGeneratorGeneratorSchema } from '../schema';

export const copyFilesFromHlmLibToGenerator = (
	tree: Tree,
	srcPath: string,
	filesPath: string,
	options: HlmToCliGeneratorGeneratorSchema,
) => {
	generateFiles(tree, srcPath, filesPath, options);
	tree.delete(path.join(filesPath, 'test-setup.ts'));
	recursivelyRenameToTemplate(tree, filesPath);
};

export const createSharedGeneratorFiles = (
	tree: Tree,
	projectRoot: string,
	options: HlmToCliGeneratorGeneratorSchema,
) => {
	generateFiles(tree, path.join(__dirname, '..', 'files'), projectRoot, options);
};

export const recursivelyRenameToTemplate = (tree: Tree, filePath: string) => {
	tree.children(filePath).forEach((child) => {
		const childPath = path.join(filePath, child);
		if (tree.isFile(childPath)) {
			tree.rename(childPath, `${childPath}.template`);
		} else {
			recursivelyRenameToTemplate(tree, childPath);
		}
	});
};

export const recursivelyDelete = (tree: Tree, filePath: string) => {
	tree.children(filePath).forEach((child) => {
		const childPath = path.join(filePath, child);
		if (tree.isFile(childPath)) {
			tree.delete(childPath);
		} else {
			recursivelyDelete(tree, childPath);
		}
	});
};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/hlm-to-cli-generator/lib/get-project-names.ts
```typescript
import { type Tree, getProjects } from '@nx/devkit';

export const getProjectsAndNames = (tree: Tree) => {
	const projectNames: string[] = [];
	const projects = getProjects(tree);

	projects.forEach((projectConfiguration, projectName) => {
		if (projectConfiguration.projectType === 'library' && projectName.includes('helm')) {
			projectNames.push(projectName);
		}
	});
	return { projects, projectNames };
};

```
