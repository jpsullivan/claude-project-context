/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/brain-secondary-entrypoint/generator.ts
```typescript
import { librarySecondaryEntryPointGenerator } from '@nx/angular/generators';
import { formatFiles, Tree } from '@nx/devkit';
import { BrainSecondaryEntrypointGeneratorSchema } from './schema';

export async function brainSecondaryEntrypointGenerator(tree: Tree, options: BrainSecondaryEntrypointGeneratorSchema) {
	await librarySecondaryEntryPointGenerator(tree, {
		name: options.name,
		library: 'brain',
		skipFormat: true,
		skipModule: true,
	});

	await formatFiles(tree);
}

export default brainSecondaryEntrypointGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/brain-secondary-entrypoint/schema.d.ts
```typescript
export interface BrainSecondaryEntrypointGeneratorSchema {
	name: string;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/brain-secondary-entrypoint/schema.json
```json
{
	"$schema": "https://json-schema.org/schema",
	"$id": "BrainSecondaryEntrypoint",
	"title": "",
	"type": "object",
	"properties": {
		"name": {
			"type": "string",
			"description": "The name of the secondary entrypoint to create.",
			"$default": {
				"$source": "argv",
				"index": 0
			},
			"x-prompt": "What name would you like to use?"
		}
	},
	"required": ["name"]
}

```
