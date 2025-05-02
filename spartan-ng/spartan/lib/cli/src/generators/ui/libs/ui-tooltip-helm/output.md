/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tooltip-helm/generator.ts
```typescript
import { Tree } from '@nx/devkit';
import hlmBaseGenerator from '../../../base/generator';
import type { HlmBaseGeneratorSchema } from '../../../base/schema';

export async function generator(tree: Tree, options: HlmBaseGeneratorSchema) {
	return await hlmBaseGenerator(tree, {
		...options,
		primitiveName: 'tooltip',
		internalName: 'ui-tooltip-helm',
		publicName: 'ui-tooltip-helm',
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tooltip-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';
import { HlmTooltipTriggerDirective } from './lib/hlm-tooltip-trigger.directive';
import { HlmTooltipComponent } from './lib/hlm-tooltip.component';

export * from './lib/hlm-tooltip-trigger.directive';
export * from './lib/hlm-tooltip.component';

export const HlmTooltipImports = [HlmTooltipComponent, HlmTooltipTriggerDirective] as const;

@NgModule({
	imports: [...HlmTooltipImports],
	exports: [...HlmTooltipImports],
})
export class HlmTooltipModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tooltip-helm/files/lib/hlm-tooltip-trigger.directive.ts.template
```
import { Directive } from '@angular/core';
import { BrnTooltipTriggerDirective, provideBrnTooltipDefaultOptions } from '@spartan-ng/brain/tooltip';

const DEFAULT_TOOLTIP_CONTENT_CLASSES =
	'overflow-hidden rounded-md border border-border bg-popover px-3 py-1.5 text-sm text-popover-foreground shadow-md fade-in-0 zoom-in-95 ' +
	'data-[state=open]:animate-in ' +
	'data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 ' +
	'data-[side=below]:slide-in-from-top-2 data-[side=above]:slide-in-from-bottom-2 ' +
	'data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 ';

@Directive({
	selector: '[hlmTooltipTrigger]',
	standalone: true,
	providers: [
		provideBrnTooltipDefaultOptions({
			showDelay: 150,
			hideDelay: 300,
			exitAnimationDuration: 150,
			tooltipContentClasses: DEFAULT_TOOLTIP_CONTENT_CLASSES,
		}),
	],
	hostDirectives: [
		{
			directive: BrnTooltipTriggerDirective,
			inputs: [
				'brnTooltipDisabled: hlmTooltipDisabled',
				'brnTooltipTrigger: hlmTooltipTrigger',
				'aria-describedby',
				'position',
				'positionAtOrigin',
				'hideDelay',
				'showDelay',
				'exitAnimationDuration',
				'touchGestures',
			],
		},
	],
})
export class HlmTooltipTriggerDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-tooltip-helm/files/lib/hlm-tooltip.component.ts.template
```
import { ChangeDetectionStrategy, Component, ViewEncapsulation } from '@angular/core';
import { BrnTooltipDirective } from '@spartan-ng/brain/tooltip';

@Component({
	selector: 'hlm-tooltip',
	encapsulation: ViewEncapsulation.None,
	changeDetection: ChangeDetectionStrategy.OnPush,
	host: {
		'[style]': '{display: "contents"}',
	},
	hostDirectives: [BrnTooltipDirective],
	template: `
		<ng-content />
	`,
})
export class HlmTooltipComponent {}

```
