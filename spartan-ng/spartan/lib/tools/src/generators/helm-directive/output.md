/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/helm-directive/generator.ts
```typescript
import { formatFiles, generateFiles, joinPathFragments, names, readProjectConfiguration, Tree } from '@nx/devkit';
import * as path from 'path';
import { addExportStatement, addImportStatement, addToExportConstArray } from '../utils/ast';
import { HelmDirectiveGeneratorSchema } from './schema';

export async function helmDirectiveGenerator(tree: Tree, options: HelmDirectiveGeneratorSchema) {
	const { root } = readProjectConfiguration(tree, options.project);
	const { fileName, className } = names(options.directiveName);
	const directivePath = joinPathFragments(root, 'src', 'lib');

	generateFiles(tree, path.join(__dirname, 'files'), directivePath, {
		fileName,
		directiveName: `Hlm${className}Directive`,
		selector: `hlm${className}`,
	});

	// the path to the index.ts file
	const indexPath = joinPathFragments(root, 'src', 'index.ts');
	let sourceCode = tree.read(indexPath, 'utf-8');

	sourceCode = addImportStatement(
		sourceCode,
		`import { Hlm${className}Directive } from './lib/hlm-${fileName}.directive';`,
	);
	sourceCode = addExportStatement(sourceCode, `export * from './lib/hlm-${fileName}.directive';`);
	sourceCode = addToExportConstArray(sourceCode, `Hlm${className}Directive`);

	tree.write(indexPath, sourceCode);

	await formatFiles(tree);
}

export default helmDirectiveGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/helm-directive/schema.d.ts
```typescript
export interface HelmDirectiveGeneratorSchema {
	project: string;
	directiveName: string;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/helm-directive/schema.json
```json
{
	"$schema": "https://json-schema.org/schema",
	"$id": "HelmComponent",
	"title": "",
	"type": "object",
	"properties": {
		"project": {
			"type": "string",
			"description": "The name of the project to add the directive to.",
			"alias": "p",
			"$default": {
				"$source": "argv",
				"index": 0
			},
			"x-dropdown": "projects",
			"x-prompt": "What project would you like to add the directive to?",
			"x-priority": "important"
		},
		"directiveName": {
			"type": "string",
			"description": "The name of the directive.",
			"x-prompt": "The name of the directive?"
		}
	},
	"required": ["project", "directiveName"]
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/helm-directive/files/hlm-__fileName__.directive.ts.template
```
import { Directive, computed, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[<%= selector %>]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
})
export class <%= directiveName %> {
	/** The user defined classes */
	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	/** The classes to apply merged with the user defined classes */
	protected readonly _computedClass = computed(() => hlm('', this.userClass()));
}

```
