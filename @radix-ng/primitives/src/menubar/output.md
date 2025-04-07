/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menubar/README.md
```
# @radix-ng/primitives/menubar

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menubar/index.ts
```typescript
import { NgModule } from '@angular/core';
import { RdxMenuBarContentDirective } from './src/menubar-content.directive';
import { RdxMenubarItemCheckboxDirective } from './src/menubar-item-checkbox.directive';
import { RdxMenubarItemIndicatorDirective } from './src/menubar-item-indicator.directive';
import { RdxMenubarItemRadioDirective } from './src/menubar-item-radio.directive';
import { RdxMenuBarItemDirective } from './src/menubar-item.directive';
import { RdxMenubarRadioGroupDirective } from './src/menubar-radio-group.directive';
import { RdxMenuBarRootDirective } from './src/menubar-root.directive';
import { RdxMenubarSeparatorDirective } from './src/menubar-separator.directive';
import { RdxMenuBarTriggerDirective } from './src/menubar-trigger.directive';

export * from './src/menubar-content.directive';
export * from './src/menubar-item-checkbox.directive';
export * from './src/menubar-item-indicator.directive';
export * from './src/menubar-item-radio.directive';
export * from './src/menubar-item.directive';
export * from './src/menubar-radio-group.directive';
export * from './src/menubar-root.directive';
export * from './src/menubar-separator.directive';
export * from './src/menubar-trigger.directive';

const menubarImports = [
    RdxMenuBarContentDirective,
    RdxMenuBarTriggerDirective,
    RdxMenubarSeparatorDirective,
    RdxMenubarItemCheckboxDirective,
    RdxMenuBarRootDirective,
    RdxMenuBarItemDirective,
    RdxMenubarItemIndicatorDirective,
    RdxMenubarItemRadioDirective,
    RdxMenubarRadioGroupDirective
];

@NgModule({
    imports: [...menubarImports],
    exports: [...menubarImports]
})
export class MenubarModule {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menubar/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menubar/src/menubar-content.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxMenuContentDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarContent]',
    hostDirectives: [RdxMenuContentDirective]
})
export class RdxMenuBarContentDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menubar/src/menubar-group.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxMenuGroupDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarGroup]',
    hostDirectives: [RdxMenuGroupDirective]
})
export class RdxMenubarGroupDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menubar/src/menubar-item-checkbox.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxMenuItemCheckboxDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarCheckboxItem]',
    hostDirectives: [
        {
            directive: RdxMenuItemCheckboxDirective,
            inputs: ['checked', 'disabled']
        }
    ]
})
export class RdxMenubarItemCheckboxDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menubar/src/menubar-item-indicator.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxMenuItemIndicatorDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarItemIndicator]',
    hostDirectives: [RdxMenuItemIndicatorDirective]
})
export class RdxMenubarItemIndicatorDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menubar/src/menubar-item-radio.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxMenuItemRadioDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarItemRadio]',
    hostDirectives: [
        {
            directive: RdxMenuItemRadioDirective,
            inputs: ['disabled', 'checked']
        }
    ]
})
export class RdxMenubarItemRadioDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menubar/src/menubar-item.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxMenuItemDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarItem]',
    hostDirectives: [
        {
            directive: RdxMenuItemDirective,
            inputs: ['disabled'],
            outputs: ['onSelect']
        }
    ]
})
export class RdxMenuBarItemDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menubar/src/menubar-radio-group.directive.ts
```typescript
import { CdkMenuGroup } from '@angular/cdk/menu';
import { Directive } from '@angular/core';

@Directive({
    selector: '[RdxMenuBarRadioGroup]',
    hostDirectives: [CdkMenuGroup]
})
export class RdxMenubarRadioGroupDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menubar/src/menubar-root.directive.ts
```typescript
import { CdkMenuBar } from '@angular/cdk/menu';
import { Directive } from '@angular/core';

@Directive({
    selector: '[RdxMenuBarRoot]',
    hostDirectives: [CdkMenuBar],
    host: {
        tabindex: '0',
        '[attr.data-orientation]': '"horizontal"'
    }
})
export class RdxMenuBarRootDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menubar/src/menubar-separator.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxMenuSeparatorDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarSeparator]',
    hostDirectives: [RdxMenuSeparatorDirective]
})
export class RdxMenubarSeparatorDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/menubar/src/menubar-trigger.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxMenuTriggerDirective } from '@radix-ng/primitives/menu';

@Directive({
    selector: '[RdxMenuBarTrigger]',
    hostDirectives: [
        {
            directive: RdxMenuTriggerDirective,
            inputs: [
                'disabled',
                'menuTriggerFor',
                'sideOffset',
                'side',
                'align',
                'alignOffset'
            ]
        }
    ]
})
export class RdxMenuBarTriggerDirective {}

```
