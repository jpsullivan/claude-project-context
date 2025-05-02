/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/executors/release/build-update-publish/executor.spec.ts
```typescript
import * as childProcess from 'node:child_process';
import * as projectHelper from '../helpers/projects.helpers';
import * as npmPublish from '../npm-publish/executor';
import executor from './executor';

// Mock the entire child_process module
jest.mock('node:child_process', () => ({
	execSync: jest.fn(), // Mock execSync function
}));

describe('BuildUpdatePublish Executor', () => {
	it('should call update-version executor and npm publish executor with the options and context', async () => {
		const libName = 'foo';
		// eslint-disable-next-line @typescript-eslint/no-explicit-any
		const mockContext = { bar: 'bar' } as any;

		// Mock the project helper, npmPublish, and execSync
		jest.spyOn(projectHelper, 'getProjectName').mockReturnValue(libName);

		// Mock npmPublish to return { success: true }
		jest.spyOn(npmPublish, 'default').mockImplementation(async () => Promise.resolve({ success: true }));

		// execSync is already mocked globally by jest.mock
		const expectedCommand = `nx build --project ${libName}`;
		const execSyncMock = childProcess.execSync as jest.Mock;

		const output = await executor({}, mockContext);

		// Verify that all functions are called as expected
		expect(npmPublish.default).toHaveBeenCalledWith({}, mockContext);
		expect(execSyncMock).toHaveBeenCalledWith(expectedCommand);
		expect(output.success).toBe(true);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/executors/release/build-update-publish/executor.ts
```typescript
import type { ExecutorContext } from '@nx/devkit';
import { execSync } from 'node:child_process';

import { getProjectName } from '../helpers/projects.helpers';
import npmPublish from '../npm-publish/executor';

import type { BuildUpdatePublishExecutorSchema } from './schema';

export default async function runExecutor(_options: BuildUpdatePublishExecutorSchema, context: ExecutorContext) {
	execSync(`nx build --project ${getProjectName(context)}`);

	await npmPublish({}, context);

	return {
		success: true,
	};
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/executors/release/build-update-publish/schema.d.ts
```typescript
// eslint-disable-next-line @typescript-eslint/no-empty-object-type
export type BuildUpdatePublishExecutorSchema = {};

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/executors/release/build-update-publish/schema.json
```json
{
	"$schema": "http://json-schema.org/draft-07/schema",
	"version": 2,
	"title": "BuildUpdatePublish executor",
	"description": "",
	"type": "object",
	"properties": {}
}

```
