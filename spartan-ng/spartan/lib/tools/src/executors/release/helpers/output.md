/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/executors/release/helpers/projects.helpers.spec.ts
```typescript
import { ExecutorContext } from '@nx/devkit';
import { getProjectName, getRoot } from './projects.helpers';

describe('executor project helper', () => {
	it('should return the project name', () => {
		const projectName = 'foo';
		expect(getProjectName({ projectName } as unknown as ExecutorContext)).toBe(projectName);
	});

	it('should get the root of the project', () => {
		const expectedRoot = 'libs/foo';
		const context = {
			projectName: 'foo',
			projectsConfigurations: {
				projects: {
					foo: {
						root: expectedRoot,
					},
				},
			},
		} as unknown as ExecutorContext;

		expect(getRoot(context)).toBe(expectedRoot);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/executors/release/helpers/projects.helpers.ts
```typescript
import type { ExecutorContext } from '@nx/devkit';

export function getProjectName(context: ExecutorContext): string {
	return context.projectName;
}

export function getRoot(context: ExecutorContext): string {
	const projectsConfiguration = context.projectsConfigurations.projects;
	const projectName = getProjectName(context);
	return projectsConfiguration[projectName].root;
}

```
