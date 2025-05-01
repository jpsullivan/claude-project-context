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
