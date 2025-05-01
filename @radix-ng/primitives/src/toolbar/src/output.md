/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toolbar/src/toolbar-button.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, Directive, effect, inject, input, signal } from '@angular/core';
import { RdxRovingFocusItemDirective } from '@radix-ng/primitives/roving-focus';

@Directive({
    selector: '[rdxToolbarButton]',
    hostDirectives: [{ directive: RdxRovingFocusItemDirective, inputs: ['focusable'] }]
})
export class RdxToolbarButtonDirective {
    private readonly rdxRovingFocusItemDirective = inject(RdxRovingFocusItemDirective);

    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    private readonly isDisabled = signal(this.disabled());

    #disableChanges = effect(() => {
        this.rdxRovingFocusItemDirective.focusable = !this.isDisabled();
    });
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toolbar/src/toolbar-link.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxRovingFocusItemDirective } from '@radix-ng/primitives/roving-focus';

@Directive({
    selector: '[rdxToolbarLink]',
    hostDirectives: [{ directive: RdxRovingFocusItemDirective, inputs: ['focusable'] }],
    host: {
        '(keydown)': 'onKeyDown($event)'
    }
})
export class RdxToolbarLinkDirective {
    onKeyDown($event: KeyboardEvent) {
        if ($event.key === ' ') ($event.currentTarget as HTMLElement)?.click();
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toolbar/src/toolbar-root.directive.ts
```typescript
import { Directive, input } from '@angular/core';
import { RdxRovingFocusGroupDirective } from '@radix-ng/primitives/roving-focus';
import { provideRootContext } from './toolbar-root.token';

@Directive({
    selector: '[rdxToolbarRoot]',
    hostDirectives: [{ directive: RdxRovingFocusGroupDirective, inputs: ['dir', 'orientation', 'loop'] }],
    providers: [provideRootContext()],
    host: {
        role: 'toolbar',
        '[attr.aria-orientation]': 'orientation()'
    }
})
export class RdxToolbarRootDirective {
    readonly orientation = input<'horizontal' | 'vertical'>('horizontal');
    readonly dir = input<'ltr' | 'rtl'>('ltr');
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toolbar/src/toolbar-root.token.ts
```typescript
import { inject, InjectionToken, Provider } from '@angular/core';
import { RdxToolbarRootDirective } from './toolbar-root.directive';

export const RDX_TOOLBAR_ROOT_TOKEN = new InjectionToken<RdxToolbarRootDirective>('RdxToolbarRootDirective');

export function injectRootContext(): RdxToolbarRootDirective {
    return inject(RDX_TOOLBAR_ROOT_TOKEN);
}

export function provideRootContext(): Provider {
    return {
        provide: RDX_TOOLBAR_ROOT_TOKEN,
        useExisting: RdxToolbarRootDirective
    };
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toolbar/src/toolbar-separator.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxSeparatorRootDirective } from '@radix-ng/primitives/separator';

@Directive({
    selector: '[rdxToolbarSeparator]',
    hostDirectives: [{ directive: RdxSeparatorRootDirective, inputs: ['orientation', 'decorative'] }]
})
export class RdxToolbarSeparatorDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toolbar/src/toolbar-toggle-group.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxToggleGroupWithoutFocusDirective } from '@radix-ng/primitives/toggle-group';

// TODO: set rovingFocus - false
@Directive({
    selector: '[rdxToolbarToggleGroup]',
    hostDirectives: [{ directive: RdxToggleGroupWithoutFocusDirective, inputs: ['value', 'type', 'disabled'] }]
})
export class RdxToolbarToggleGroupDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/toolbar/src/toolbar-toggle-item.directive.ts
```typescript
import { Directive } from '@angular/core';
import { RdxToggleGroupItemDirective } from '@radix-ng/primitives/toggle-group';

@Directive({
    selector: '[rdxToolbarToggleItem]',
    hostDirectives: [{ directive: RdxToggleGroupItemDirective, inputs: ['value', 'disabled'] }]
})
export class RdxToolbarToggleItemDirective {}

```
