/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/helm-component/generator.ts
```typescript
import { formatFiles, generateFiles, joinPathFragments, names, readProjectConfiguration, Tree } from '@nx/devkit';
import * as path from 'path';
import { addExportStatement, addImportStatement, addToExportConstArray } from '../utils/ast';
import { HelmComponentGeneratorSchema } from './schema';

export async function helmComponentGenerator(tree: Tree, options: HelmComponentGeneratorSchema) {
	const { root } = readProjectConfiguration(tree, options.project);
	const { fileName, className } = names(options.componentName);
	const componentPath = joinPathFragments(root, 'src', 'lib');

	generateFiles(tree, path.join(__dirname, 'files'), componentPath, {
		fileName,
		componentName: `Hlm${className}Component`,
		selector: `hlm-${fileName}`,
	});

	// the path to the index.ts file
	const indexPath = joinPathFragments(root, 'src', 'index.ts');
	let sourceCode = tree.read(indexPath, 'utf-8');

	sourceCode = addImportStatement(
		sourceCode,
		`import { Hlm${className}Component } from './lib/hlm-${fileName}.component';`,
	);
	sourceCode = addExportStatement(sourceCode, `export * from './lib/hlm-${fileName}.component';`);
	sourceCode = addToExportConstArray(sourceCode, `Hlm${className}Component`);

	tree.write(indexPath, sourceCode);

	await formatFiles(tree);
}

export default helmComponentGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/helm-component/schema.d.ts
```typescript
export interface HelmComponentGeneratorSchema {
	project: string;
	componentName: string;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/helm-component/schema.json
```json
{
	"$schema": "https://json-schema.org/schema",
	"$id": "HelmComponent",
	"title": "",
	"type": "object",
	"properties": {
		"project": {
			"type": "string",
			"description": "The name of the project to add the component to.",
			"alias": "p",
			"$default": {
				"$source": "argv",
				"index": 0
			},
			"x-dropdown": "projects",
			"x-prompt": "What project would you like to add the component to?",
			"x-priority": "important"
		},
		"componentName": {
			"type": "string",
			"description": "The name of the component.",
			"x-prompt": "The name of the component?"
		}
	},
	"required": ["project", "componentName"]
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/helm-component/files/hlm-__fileName__.component.ts.template
```
import { Component, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Component({
	selector: '<%= selector %>',
	standalone: true,
	template: ``,
})
export class <%= componentName %> {
	/** The user defined classes */
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	/** The classes to apply to the component merged with the user defined classes */
	protected readonly _computedClass = computed(() => hlm('', this.userClass()));
}

```
