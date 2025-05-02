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
