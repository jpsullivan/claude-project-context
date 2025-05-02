/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-toggle-group/compat.ts
```typescript
import { convertNxGenerator } from '@nx/devkit';
import migrateRadioGenerator from './generator';

export default convertNxGenerator(migrateRadioGenerator);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-toggle-group/generator.spec.ts
```typescript
import { applicationGenerator, E2eTestRunner, UnitTestRunner } from '@nx/angular/generators';
import { Tree } from '@nx/devkit';
import { createTreeWithEmptyWorkspace } from '@nx/devkit/testing';
import { migrateToggleGroupGenerator } from './generator';

// patch some imports to avoid running the actual code
jest.mock('enquirer');
jest.mock('@nx/devkit', () => {
	const original = jest.requireActual('@nx/devkit');
	return {
		...original,
		ensurePackage: (pkg: string) => jest.requireActual(pkg),
		createProjectGraphAsync: jest.fn().mockResolvedValue({
			nodes: {},
			dependencies: {},
		}),
	};
});

describe('migrate-toggle-group generator', () => {
	let tree: Tree;

	beforeEach(async () => {
		tree = await createTreeWithEmptyWorkspace();

		await applicationGenerator(tree, {
			name: 'app',
			directory: 'app',
			skipFormat: true,
			e2eTestRunner: E2eTestRunner.None,
			unitTestRunner: UnitTestRunner.None,
			skipPackageJson: true,
			skipTests: true,
		});
	});

	it('should replace BrnToggleGroupModule with BrnToggleGroupModule, BrnToggleGroupItemDirective', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
				import { Component } from '@angular/core';
				import { BrnToggleGroupModule, BrnToggleDirective } from '@spartan-ng/brain/toggle';
				import { HlmToggleDirective, HlmToggleGroupModule } from '@spartan-ng/ui-toggle-helm';

				@Component({
					imports: [BrnToggleGroupModule, HlmToggleGroupModule, HlmButtonDirective, FormsModule, NgForOf, NgIf],
					],
					template: \`
     	<div class="flex space-x-4">
				<brn-toggle-group hlm [disabled]="disabled" [nullable]="nullable" [multiple]="multiple" [(ngModel)]="selected">
				<button variant="outline" *ngFor="let city of cities; let last = last" [value]="city" hlm brnToggle>
					{{ city.name }}
				</button>
				</brn-toggle-group>
				<button hlmBtn size="sm" (click)="setToSyracuse()">Set to Syracuse</button>
				<button hlmBtn size="sm" (click)="addCity()">Add Piraeus</button>
			</div>
					\`
				})
				export class AppModule {}
				`,
		);

		await migrateToggleGroupGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).not.toContain("import { BrnToggleGroupModule } from '@spartan-ng/brain/toggle'");
		expect(content).toContain(
			"import { BrnToggleGroupComponent, BrnToggleGroupItemDirective } from '@spartan-ng/brain/toggle-group'",
		);
		expect(content).toContain(
			"import { HlmToggleGroupDirective, HlmToggleGroupItemDirective } from '@spartan-ng/ui-toggle-group-helm'",
		);
		expect(content).toContain(
			'imports: [BrnToggleGroupComponent, BrnToggleGroupItemDirective, HlmToggleGroupDirective, HlmToggleGroupItemDirective, HlmButtonDirective, FormsModule, NgForOf, NgIf],',
		);
	});

	it('should replace brnToggle with hlmToggleGroupItem', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
				import { Component } from '@angular/core';
				import { BrnToggleGroupModule } from '@spartan-ng/brain/toggle';
				import { HlmButtonDirective, FormsModule, NgForOf, NgIf } from '@spartan-ng/ui-toggle-group-helm';
				@Component({
					imports: [BrnToggleGroupModule, HlmToggleGroupModule, HlmButtonDirective, FormsModule, NgForOf, NgIf],
					template: \`
     	<div class="flex space-x-4">
				<brn-toggle-group hlm [disabled]="disabled" [nullable]="nullable" [multiple]="multiple" [(ngModel)]="selected">
				<button variant="outline" *ngFor="let city of cities; let last = last" [value]="city" hlm brnToggle>
					{{ city.name }}
				</button>
				</brn-toggle-group>
				<button hlmBtn size="sm" (click)="setToSyracuse()">Set to Syracuse</button>
				<button hlmBtn size="sm" (click)="addCity()">Add Piraeus</button>
			</div>
					\`
				})
				export class AppModule {}
				`,
		);

		await migrateToggleGroupGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).not.toContain('brnToggle');
		expect(content).toContain('hlmToggleGroupItem');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-toggle-group/generator.ts
```typescript
import { formatFiles, Tree } from '@nx/devkit';
import { visitFiles } from '../../utils/visit-files';
import { MigrateToggleGroupGeneratorSchema } from './schema';

export async function migrateToggleGroupGenerator(tree: Tree, { skipFormat }: MigrateToggleGroupGeneratorSchema) {
	updateBrainImports(tree);
	updateHlmImports(tree);
	replaceSelector(tree);

	if (!skipFormat) {
		await formatFiles(tree);
	}
}

/**
 * Update brain imports to migrate from toggle to toggle-group
 */
function updateBrainImports(tree: Tree) {
	visitFiles(tree, '/', (path) => {
		// Filter for TypeScript files that might contain the imports we're interested in
		if (!path.endsWith('.ts')) return;

		let content = tree.read(path)?.toString();
		if (!content) return;

		// Only proceed if file has BrnToggleGroupModule from toggle but not from toggle-group
		if (
			content.includes('BrnToggleGroupModule') &&
			content.includes("from '@spartan-ng/brain/toggle'") &&
			!content.includes("from '@spartan-ng/brain/toggle-group'")
		) {
			// Remove BrnToggleGroupModule from the toggle import
			content = content.replace(
				/import\s+\{\s*([^{}]*BrnToggleGroupModule[^{}]*)\s*\}\s+from\s+['"]@spartan-ng\/brain\/toggle['"];/g,
				(_match, importList) => {
					// Remove BrnToggleGroupModule from the import list
					const newImportList = importList
						.split(',')
						.map((item) => item.trim())
						.filter((item) => item !== 'BrnToggleGroupModule')
						.join(', ');

					// If there are still imports remaining, return the modified import statement
					if (newImportList.length > 0) {
						return `import { ${newImportList} } from '@spartan-ng/brain/toggle';`;
					} else {
						// If no imports remain, remove the entire import statement
						return '';
					}
				},
			);

			// Add the new toggle-group import with BrnToggleGroupComponent and BrnToggleGroupItemDirective
			const importRegex = /import\s+.*?;/g;
			let match;
			let lastImportEndIndex = 0;

			while ((match = importRegex.exec(content)) !== null) {
				lastImportEndIndex = match.index + match[0].length;
			}

			// If we found imports, add after the last one
			if (lastImportEndIndex > 0) {
				const newImport = `\nimport { BrnToggleGroupComponent, BrnToggleGroupItemDirective } from '@spartan-ng/brain/toggle-group';`;
				content = content.substring(0, lastImportEndIndex) + newImport + content.substring(lastImportEndIndex);
			} else {
				// If no imports found, add at the beginning
				const newImport = `import { BrnToggleGroupComponent, BrnToggleGroupItemDirective } from '@spartan-ng/brain/toggle-group';\n\n`;
				content = newImport + content;
			}

			// Update component imports to include BrnToggleGroupItemDirective
			content = content.replace(
				/imports:\s*\[\s*BrnToggleGroupModule\s*,/g,
				'imports: [BrnToggleGroupComponent, BrnToggleGroupItemDirective,',
			);

			// Also handle the case where BrnToggleGroupModule is the only import
			content = content.replace(
				/imports:\s*\[\s*BrnToggleGroupModule\s*\]/g,
				'imports: [BrnToggleGroupComponent, BrnToggleGroupItemDirective]',
			);

			tree.write(path, content);
		}
	});

	return tree;
}

/**
 * Update hlm imports to migrate from toggle to toggle-group
 */
function updateHlmImports(tree: Tree) {
	visitFiles(tree, '/', (path) => {
		// Filter for TypeScript files that might contain the imports we're interested in
		if (!path.endsWith('.ts')) return;

		let content = tree.read(path)?.toString();
		if (!content) return;

		// Only proceed if file has imports from ui-toggle-helm but not from ui-toggle-group-helm
		if (
			content.includes("from '@spartan-ng/ui-toggle-helm'") &&
			!content.includes("from '@spartan-ng/ui-toggle-group-helm'")
		) {
			// Replace HlmToggleDirective and HlmToggleGroupModule with the directives
			// Handle case with HlmToggleDirective
			content = content.replace(
				/import\s+\{\s*HlmToggleDirective\s*,\s*HlmToggleGroupModule\s*\}\s+from\s+['"]@spartan-ng\/ui-toggle-helm['"];/g,
				"import { HlmToggleGroupDirective, HlmToggleGroupItemDirective } from '@spartan-ng/ui-toggle-group-helm';",
			);

			// Also handle case with just HlmToggleGroupModule
			content = content.replace(
				/import\s+\{\s*HlmToggleGroupModule\s*\}\s+from\s+['"]@spartan-ng\/ui-toggle-helm['"];/g,
				"import { HlmToggleGroupDirective, HlmToggleGroupItemDirective } from '@spartan-ng/ui-toggle-group-helm';",
			);

			// Update the imports array to replace HlmToggleGroupModule with the directives
			// For the case where HlmToggleGroupModule is in the middle of other imports
			content = content.replace('HlmToggleGroupModule', 'HlmToggleGroupDirective, HlmToggleGroupItemDirective');

			tree.write(path, content);
		}
	});

	return tree;
}

/**
 * Replace brnToggle with hlmToggleGroupItem inside the brn-toggle-group
 */
function replaceSelector(_tree: Tree) {
	visitFiles(_tree, '/', (path) => {
		if (!path.endsWith('.html') && !path.endsWith('.ts')) {
			return;
		}

		let content = _tree.read(path)?.toString();

		if (!content) return;

		// if file contains @spartan-ng/ui-toggle-group-helm
		if (content.includes('@spartan-ng/ui-toggle-group-helm')) {
			content = content.replace(/brnToggle/g, 'hlmToggleGroupItem');
		}

		_tree.write(path, content);
	});

	return true;
}

export default migrateToggleGroupGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-toggle-group/schema.d.ts
```typescript
export interface MigrateToggleGroupGeneratorSchema {
	skipFormat?: boolean;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-toggle-group/schema.json
```json
{
	"$schema": "https://json-schema.org/schema",
	"$id": "MigrateRadio",
	"title": "",
	"type": "object",
	"properties": {
		"skipFormat": {
			"type": "boolean",
			"default": false,
			"description": "Skip formatting files"
		}
	},
	"required": []
}

```
