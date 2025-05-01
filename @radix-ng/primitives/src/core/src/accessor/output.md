/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/core/src/accessor/provide-value-accessor.ts
````typescript
import { Provider, Type } from '@angular/core';
import { NG_VALUE_ACCESSOR } from '@angular/forms';

/**
 * Include in the providers section of a component which utilizes ControlValueAccessor to redundant code.
 *
 * ```ts
 * @Directive({
 *   providers: [provideValueAccessor(ExampleDirective)]
 *}
 * export class ExampleDirective{}
 * ```
 */
export function provideValueAccessor(type: Type<never>): Provider {
    return {
        provide: NG_VALUE_ACCESSOR,
        useExisting: type,
        multi: true
    };
}

````
