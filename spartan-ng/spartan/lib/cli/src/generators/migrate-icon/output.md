/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-icon/compat.ts
```typescript
import { convertNxGenerator } from '@nx/devkit';
import { migrateIconGenerator } from './generator';

export default convertNxGenerator(migrateIconGenerator);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-icon/generator.spec.ts
```typescript
import { applicationGenerator, E2eTestRunner, UnitTestRunner } from '@nx/angular/generators';
import { Tree } from '@nx/devkit';
import { createTreeWithEmptyWorkspace } from '@nx/devkit/testing';
import { migrateIconGenerator } from './generator';

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

describe('migrate-icon generator', () => {
	let tree: Tree;

	beforeEach(async () => {
		tree = createTreeWithEmptyWorkspace();

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

	it('should add NgIcon import (NgModule)', async () => {
		tree.write(
			'app/src/app/app.module.ts',
			`
			import { NgModule } from '@angular/core';
			import { BrowserModule } from '@angular/platform-browser';
			import { HlmIconModule } from '@spartan-ng/ui-icon-helm';

			@NgModule({
				imports: [BrowserModule, HlmIconModule],
			})
			export class AppModule {}
			`,
		);

		await migrateIconGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.module.ts', 'utf-8');
		expect(content).toContain(`import { NgIcon } from '@ng-icons/core';`);
		expect(content).toContain(`imports: [BrowserModule, NgIcon, HlmIconModule],`);
	});

	it('should replace HlmIconComponent (NgModule)', async () => {
		tree.write(
			'app/src/app/app.module.ts',
			`
			import { NgModule } from '@angular/core';
			import { BrowserModule } from '@angular/platform-browser';
			import { HlmIconComponent } from '@spartan-ng/ui-icon-helm';

			@NgModule({
				imports: [BrowserModule, HlmIconComponent],
			})
			export class AppModule {}
			`,
		);

		await migrateIconGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.module.ts', 'utf-8');
		expect(content).toContain(`import { NgIcon } from '@ng-icons/core';`);
		expect(content).toContain(`imports: [BrowserModule, NgIcon, HlmIconDirective],`);
	});

	it('should add NgIcon import (Standalone)', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';
			import { HlmIconModule } from '@spartan-ng/ui-icon-helm';

			@Component({
				imports: [HlmIconModule],
				template: \`
					<hlm-icon size='xl' name="lucideChevronRight" />
				\`
			})
			export class AppModule {}

			`,
		);

		await migrateIconGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`import { NgIcon } from '@ng-icons/core';`);
		expect(content).toContain(`imports: [NgIcon, HlmIconModule],`);
		expect(content).toContain(`<ng-icon hlm size='xl' name="lucideChevronRight" />`);
	});

	it('should replace HlmIconComponent (Standalone)', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';
			import { HlmIconComponent } from '@spartan-ng/ui-icon-helm';

			@Component({
				imports: [HlmIconComponent],
				template: \`
					<hlm-icon size='xl' name="lucideChevronRight" />
				\`
			})
			export class AppModule {}

			`,
		);

		await migrateIconGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`import { NgIcon } from '@ng-icons/core';`);
		expect(content).toContain(`import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';`);
		expect(content).toContain(`imports: [NgIcon, HlmIconDirective],`);
		expect(content).toContain(`<ng-icon hlm size='xl' name="lucideChevronRight" />`);
	});

	it('should re-write the provideIcons import', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';
			import { provideIcons } from '@spartan-ng/ui-icon-helm';
			import { lucideChevronRight } from '@ng-icons/lucide';

			@Component({
				providers: [provideIcons({ lucideChevronRight })],
			})
			export class AppComponent {}
			`,
		);

		await migrateIconGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`import { provideIcons } from '@ng-icons/core';`);
		expect(content).toContain(`providers: [provideIcons({ lucideChevronRight })],`);
	});

	it('should add the name attribute for accordion icons', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';

			@Component({
				template: \`
					<hlm-icon hlmAccIcon name="lucideChevronDown" />
				\`
			})
			export class AppComponent {}

			`,
		);

		await migrateIconGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`<ng-icon hlm hlmAccIcon name="lucideChevronDown" />`);
	});

	it('should convert tailwind width, height and size classes', async () => {
		tree.write(
			'app/src/app/app.component.ts',
			`
			import { Component } from '@angular/core';

			@Component({
				template: \`
					<hlm-icon size="sm" name="lucideChevronRight" />
					<hlm-icon size="base" name="lucideChevronRight" />
					<hlm-icon size="lg" name="lucideChevronRight" />
					<hlm-icon size="6px" name="lucideChevronRight" />
					<hlm-icon size="8px" class="text-red-500" name="lucideChevronRight" />
					<hlm-icon size="sm" class="ml-2" name="lucideChevronUp" />
				\`
			})
			export class AppComponent {}

			`,
		);

		await migrateIconGenerator(tree, { skipFormat: true });

		const content = tree.read('app/src/app/app.component.ts', 'utf-8');
		expect(content).toContain(`<ng-icon hlm size="sm" name="lucideChevronRight" />`);
		expect(content).toContain(`<ng-icon hlm size="base" name="lucideChevronRight" />`);
		expect(content).toContain(`<ng-icon hlm size="lg" name="lucideChevronRight" />`);
		expect(content).toContain(`<ng-icon hlm size="6px" name="lucideChevronRight" />`);
		expect(content).toContain(`<ng-icon hlm size="8px" class="text-red-500" name="lucideChevronRight" />`);
		expect(content).toContain(`<ng-icon hlm size="sm" class="ml-2" name="lucideChevronUp" />`);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-icon/generator.ts
```typescript
import { formatFiles, Tree } from '@nx/devkit';
import { applyChangesToString, ChangeType, StringChange } from '@nx/devkit/src/utils/string-change';
import { isImported } from '@schematics/angular/utility/ast-utils';
import ts from 'typescript';
import { visitFiles } from '../../utils/visit-files';
import { MigrateIconGeneratorSchema } from './schema';

export async function migrateIconGenerator(tree: Tree, { skipFormat }: MigrateIconGeneratorSchema) {
	replaceImports(tree);
	replaceSelector(tree);
	replaceProvideIcons(tree);
	addAccordionIcon(tree);
	replaceTailwindClasses(tree);

	if (!skipFormat) {
		await formatFiles(tree);
	}
}

function replaceTailwindClasses(tree: Tree) {
	visitFiles(tree, '.', (path) => {
		// if this is not a html or typescript file then skip
		if (!path.endsWith('.ts') && !path.endsWith('.html')) {
			return;
		}

		let content = tree.read(path, 'utf-8');

		// if there are no icons then skip
		if (!content || !content.includes('ng-icon')) {
			return;
		}

		const changes: StringChange[] = [];

		const regex = /<ng-icon\b[^>]*>/g;

		let match;

		while ((match = regex.exec(content)) !== null) {
			const startIndex = match.index;

			// if there already is a size attribute then skip
			if (match[0].includes('size=')) {
				continue;
			}

			// get the class attribute
			const classMatch = match[0].match(/class="([^"]*)"/);

			if (!classMatch) {
				continue;
			}

			const className = classMatch[1];

			// get each class in the class attribute
			const classes = className.split(' ');

			// find any known size
			const size = classes.find((c: string) => tailwindToSize(c) !== null);

			if (!size) {
				continue;
			}

			const sizeValue = tailwindToSize(size);

			// remove the size class
			let output = match[0]
				.replace(/\b(w|h|size)-\S+\b/g, '')
				.replace(/class=(["'])(\s*)(.+?)(\s*)\1/g, 'class=$1$3$1')
				.replace(/\s*class="\s*"\s*/g, ' ');

			// add the size attribute
			output = output.replace(' hlm ', ` hlm size="${sizeValue}" `);

			// delete the original line
			changes.push({
				type: ChangeType.Delete,
				start: startIndex,
				length: match[0].length,
			});

			// insert the new line
			changes.push({
				type: ChangeType.Insert,
				index: startIndex,
				text: output,
			});
		}

		content = applyChangesToString(content, changes);

		tree.write(path, content);
	});
}

function tailwindToSize(className: string): string | null {
	// if this is not a width, height or size class then skip
	if (/\b(w|h|size)-\S+\b/.test(className) === false) {
		return null;
	}

	const [, value] = className.split('-');

	// Handle specific Tailwind keywords
	const keywordMapping = {
		full: '100%',
		screen: '100vw',
		auto: 'auto',
		min: 'min-content',
		max: 'max-content',
		fit: 'fit-content',
	};

	// Check if value is a keyword
	if (keywordMapping[value]) {
		return `${keywordMapping[value]};`;
	}

	// Convert numeric values to a number
	const numericValue = parseFloat(value);

	if (!isNaN(numericValue)) {
		const px = numericValue * 4;

		switch (px) {
			case 12:
				return 'xs';
			case 16:
				return 'sm';
			case 24:
				return 'base';
			case 32:
				return 'lg';
			case 48:
				return 'xl';
		}

		return `${px}px`;
	}

	// Handle other cases
	return null;
}

function addAccordionIcon(tree: Tree) {
	visitFiles(tree, '.', (path) => {
		// if this is not a html or typescript file then skip
		if (!path.endsWith('.ts') && !path.endsWith('.html')) {
			return;
		}

		let content = tree.read(path, 'utf-8');

		if (!content) {
			return;
		}

		// if there is no hlmAccIcon or hlmAccordionIcon then skip
		if (!content.includes('hlmAccIcon') && !content.includes('hlmAccordionIcon')) {
			return;
		}

		const changes: StringChange[] = [];

		// if an element is using hlmAccIcon or hlmAccordionIcon and has no name attribute then add the name attribute
		const regex = /<ng-icon\b[^>]*(\bhlmAccIcon\b|\bhlmAccordionIcon\b)[^>]*>/g;

		let match;
		const results: { match: string; index: number }[] = [];

		while ((match = regex.exec(content)) !== null) {
			results.push({ match: match[0], index: match.index });
		}

		if (!results.length) {
			return;
		}

		for (const { match, index } of results) {
			if (!match.includes('name=')) {
				const directive = match.includes('hlmAccIcon') ? 'hlmAccIcon' : 'hlmAccordionIcon';

				const startIndex = index + match.indexOf(directive);

				changes.push({
					type: ChangeType.Insert,
					index: startIndex + directive.length,
					text: ` name="lucideChevronDown"`,
				});
			}
		}

		content = applyChangesToString(content, changes);

		tree.write(path, content);
	});
}

function replaceProvideIcons(tree: Tree) {
	visitFiles(tree, '.', (path) => {
		// if this is not a typescript file then skip
		if (!path.endsWith('.ts')) {
			return;
		}

		let content = tree.read(path, 'utf-8');

		// if the user is importing `provideIcons` from '@spartan-ng/ui-icon-helm' then we need to replace it with `provideIcons` from '@ng-icons/core'
		if (!content || !content?.includes('provideIcons')) {
			return;
		}

		const sourceFile = ts.createSourceFile(path, content, ts.ScriptTarget.Latest, true);

		if (!isImported(sourceFile, 'provideIcons', '@spartan-ng/ui-icon-helm')) {
			return;
		}

		const changes: StringChange[] = [];

		// remove the import of provideIcons from '@spartan-ng/ui-icon-helm'
		// add the import of provideIcons from '@ng-icons/core'
		changes.push({
			type: ChangeType.Delete,
			start: content.indexOf('provideIcons'),
			length: 'provideIcons'.length,
		});

		changes.push({
			type: ChangeType.Insert,
			index: 0,
			text: `import { provideIcons } from '@ng-icons/core';\n`,
		});

		content = applyChangesToString(content, changes);

		tree.write(path, content);
	});
}

function replaceSelector(tree: Tree) {
	// if the element is `<ng-icon hlm` then we need to replace it with `<ng-icon hlm`
	// we also need to replace the closing tag `</ng-icon>` with `</ng-icon>`
	visitFiles(tree, '.', (path) => {
		// if this is not an html file or typescript file (inline templates) then skip
		if (!path.endsWith('.html') && !path.endsWith('.ts')) {
			return;
		}

		let content = tree.read(path, 'utf-8');

		if (!content) {
			return;
		}

		content = content.replace(/<hlm-icon/g, '<ng-icon hlm');
		content = content.replace(/<\/hlm-icon>/g, '</ng-icon>');

		tree.write(path, content);
	});
}

function replaceImports(tree: Tree) {
	// ng modules or standalone components will have import arrays that may need updated.
	// if the import is `HlmIconModule` then we need to also import `NgIcon`,
	// if the import is `HlmIconComponent` we need to rename it to `HlmIconDirective` and add the `NgIcon` import.
	visitFiles(tree, '.', (path) => {
		// if the file is not a typescript file then skip
		if (!path.endsWith('.ts')) {
			return;
		}

		let content = tree.read(path, 'utf-8');

		if (!content) {
			return;
		}

		// convert the content to an ast
		const sourceFile = ts.createSourceFile(path, content, ts.ScriptTarget.Latest, true);

		// find all imports of HlmIconModule or HlmIconComponent
		const imports = findHlmIconImports(sourceFile);

		// if no imports are found then skip
		if (imports.length === 0) {
			return;
		}

		const changes: StringChange[] = [];

		for (const identifier of imports) {
			// if the identifier is HlmIconModule then we need to add NgIcon to the imports
			if (identifier.getText() === 'HlmIconModule') {
				changes.push({
					type: ChangeType.Insert,
					index: identifier.getStart(),
					text: 'NgIcon, ',
				});
			}

			// if the identifier is HlmIconComponent then we need to rename it to HlmIconDirective and add NgIcon to the imports
			if (identifier.getText() === 'HlmIconComponent') {
				changes.push({
					type: ChangeType.Insert,
					index: identifier.getStart(),
					text: 'NgIcon, ',
				});
			}

			// check if the NgIcon import is already present
			if (!hasImport(content, 'NgIcon', '@ng-icons/core')) {
				changes.push({
					type: ChangeType.Insert,
					index: 0,
					text: `import { NgIcon } from '@ng-icons/core';\n`,
				});
			}
		}

		content = applyChangesToString(content, changes);

		// if there are any remaining uses of HlmIconComponent then replace them with HlmIconDirective
		content = content.replace(/HlmIconComponent/g, 'HlmIconDirective');

		tree.write(path, content);
	});
}

function findHlmIconImports(node: ts.SourceFile): ts.Node[] {
	const matches: ts.Identifier[] = [];

	const visit = (node: ts.Node) => {
		if (
			ts.isPropertyAssignment(node) &&
			node.name.getText() === 'imports' &&
			ts.isArrayLiteralExpression(node.initializer)
		) {
			// check if the array literal contains the HlmIconModule or HlmIconComponent
			node.initializer.elements.forEach((element) => {
				if (ts.isIdentifier(element)) {
					if (element.getText() === 'HlmIconModule' || element.getText() === 'HlmIconComponent') {
						matches.push(element);
					}
				}
			});
		}

		ts.forEachChild(node, visit);
	};

	visit(node);

	return matches;
}

function hasImport(contents: string, importName: string, importPath: string): boolean {
	const sourceFile = ts.createSourceFile('temp.ts', contents, ts.ScriptTarget.Latest, true);
	return isImported(sourceFile, importName, importPath);
}

export default migrateIconGenerator;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-icon/schema.d.ts
```typescript
export interface MigrateIconGeneratorSchema {
	skipFormat?: boolean;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/migrate-icon/schema.json
```json
{
	"$schema": "https://json-schema.org/schema",
	"$id": "MigrateIcon",
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
