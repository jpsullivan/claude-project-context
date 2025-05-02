/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/auto-increment-version/generator.spec.ts
```typescript
import { type Tree, readProjectConfiguration } from '@nx/devkit';
import { createTreeWithEmptyWorkspace } from '@nx/devkit/testing';

import autoIncrementVersion from './generator';

describe('replace-cli-version generator', () => {
	let tree: Tree;

	beforeEach(() => {
		tree = createTreeWithEmptyWorkspace();
	});

	it.skip('should run successfully', async () => {
		await autoIncrementVersion(tree);
		const config = readProjectConfiguration(tree, 'test');
		expect(config).toBeDefined();
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/auto-increment-version/generator.ts
```typescript
import { type Tree, formatFiles, readJsonFile } from '@nx/devkit';
import replaceCliVersionGenerator from '../replace-cli-version/generator';
import replaceUiVersionGenerator from '../replace-ui-version/generator';

export default async function autoIncrementVersion(tree: Tree): Promise<void> {
	const oldVersion = readJsonFile('libs/brain/package.json').version as string;
	const [prefix, branchAndNumber] = oldVersion.split('-');
	const [branch, versionNumber] = branchAndNumber.split('.');
	const newVersionNumber = +versionNumber + 1;

	const newVersion = `${prefix}-${branch}.${newVersionNumber}`;

	console.log(
		`preparing release with auto-incremented version ${newVersion} which should be 1 more than ${oldVersion}`,
	);

	await replaceUiVersionGenerator(tree, { newVersion });
	await replaceCliVersionGenerator(tree, { newVersion });

	await formatFiles(tree);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/auto-increment-version/schema.json
```json
{
	"$schema": "http://json-schema.org/schema",
	"$id": "AutoIncrementVersionGenerator",
	"title": "",
	"type": "object",
	"properties": {}
}

```
