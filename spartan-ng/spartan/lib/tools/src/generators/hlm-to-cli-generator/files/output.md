/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/tools/src/generators/hlm-to-cli-generator/files/generator.ts.template
```
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
  return await hlmBaseGenerator(tree, {...options, primitiveName: '<%= primitiveName %>', internalName: '<%= internalName %>', publicName: '<%= publicName %>'});
}

```
