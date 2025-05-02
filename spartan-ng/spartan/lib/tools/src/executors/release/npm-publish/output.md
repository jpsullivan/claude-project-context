/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/executors/release/npm-publish/executor.spec.ts
```typescript
import { ExecutorContext } from '@nx/devkit';
import * as child_process from 'node:child_process';
import * as process from 'node:process';
import * as projectHelpers from '../helpers/projects.helpers';
import executor from './executor';

// Mock the entire child_process module
jest.mock('node:child_process', () => ({
	execSync: jest.fn(), // Mock execSync function
}));

describe('NpmPublish Executor', () => {
	it('should execSync with a default libPath if no libPath was provided', async () => {
		const mockRoot = 'libs/my-domain/foo';
		const context = {} as unknown as ExecutorContext;

		// Mock the getRoot helper
		jest.spyOn(projectHelpers, 'getRoot').mockReturnValue(mockRoot);

		// Set the environment variable for TAG
		process.env.TAG = 'next';

		// Expected command that should be executed
		const expectedCommand = `cd ./dist/${mockRoot} && npm publish --tag next`;

		// Call the executor
		const output = await executor({}, context);

		// Check if execSync was called with the expected command
		expect(child_process.execSync).toHaveBeenCalledWith(expectedCommand);
		expect(output.success).toBe(true);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/executors/release/npm-publish/executor.ts
```typescript
import type { ExecutorContext } from '@nx/devkit';
import { execSync } from 'node:child_process';

import { getRoot } from '../helpers/projects.helpers';

import * as process from 'node:process';
import type { NpmPublishExecutorSchema } from './schema';

export default async function runExecutor(_options: NpmPublishExecutorSchema, context: ExecutorContext) {
	const tag = process.env.TAG;

	if (!tag) {
		console.log('no process.env.TAG available. returning early');
		return {
			success: false,
		};
	}

	const sourceRoot = `./dist/${getRoot(context)}`;

	console.log('running npm publish at ' + sourceRoot);

	execSync(`cd ${sourceRoot} && npm publish${tag ? ` --tag ${tag}` : ''}`);
	return {
		success: true,
	};
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/executors/release/npm-publish/schema.d.ts
```typescript
// eslint-disable-next-line @typescript-eslint/no-empty-object-type
export type NpmPublishExecutorSchema = {};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/executors/release/npm-publish/schema.json
```json
{
	"$schema": "http://json-schema.org/draft-07/schema",
	"version": 2,
	"title": "NPM publish executor",
	"description": "",
	"type": "object",
	"properties": {}
}

```
