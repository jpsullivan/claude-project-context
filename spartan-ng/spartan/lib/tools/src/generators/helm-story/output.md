/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/helm-story/generator.ts
```typescript
import { formatFiles, generateFiles, names, readJson, readProjectConfiguration, Tree } from '@nx/devkit';
import * as path from 'path';
import { HelmStoryGeneratorSchema } from './schema';

export async function helmStoryGenerator(tree: Tree, options: HelmStoryGeneratorSchema) {
	const { root, name } = readProjectConfiguration(tree, options.project);

	if (!name) {
		throw new Error(`Could not find project name in workspace: ${options.project}`);
	}

	// names are in the format ui-checkbox-helm, we want to discard ui- and -helm
	const normalizedName = name.replace(/^ui-/, '').replace(/-helm$/, '');

	// derive the story name from the normalizedName - e.g. radio-button => Radio Button
	const storyName = normalizedName
		.split('-')
		.map((part) => part.charAt(0).toUpperCase() + part.slice(1))
		.join(' ');

	// derive the imports name from the normalizedName - e.g. radio-button => HlmRadioButtonImports
	const componentImports = `Hlm${normalizedName
		.split('-')
		.map((part) => part.charAt(0).toUpperCase() + part.slice(1))
		.join('')}Imports`;

	const { name: importPath } = readJson(tree, path.join(root, 'package.json'));

	const projectRoot = path.join(root, '..');

	generateFiles(tree, path.join(__dirname, 'files'), projectRoot, {
		fileName: names(options.componentName).fileName,
		componentName: options.componentName,
		componentImports,
		importPath,
		storyName,
	});

	await formatFiles(tree);
}

export default helmStoryGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/helm-story/schema.d.ts
```typescript
export interface HelmStoryGeneratorSchema {
	project: string;
	componentName: string;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/helm-story/schema.json
```json
{
	"$schema": "https://json-schema.org/schema",
	"$id": "HelmStory",
	"title": "",
	"type": "object",
	"properties": {
		"project": {
			"type": "string",
			"description": "The name of the project to add the story to.",
			"alias": "p",
			"$default": {
				"$source": "argv",
				"index": 0
			},
			"x-dropdown": "projects",
			"x-prompt": "What project would you like to add the story to?",
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/helm-story/files/__fileName__.stories.ts.template
```
import type { Meta, StoryObj } from '@storybook/angular';
import { moduleMetadata } from '@storybook/angular';
import { <%= componentName %>, <%= componentImports %>} from '<%= importPath %>';

export default {
	title: '<%= storyName %>',
	component: <%= componentName %>,
	tags: ['autodocs'],
	decorators: [
		moduleMetadata({
			imports: [<%= componentImports %>],
		}),
	],
} as Meta<<%= componentName %>>

type Story = StoryObj<<%= componentName %>>;

export const Default: Story = {
	render: () => ({
		template: `

		`,
	}),
};

```
