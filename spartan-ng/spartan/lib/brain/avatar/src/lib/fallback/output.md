/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/fallback/brn-avatar-fallback.directive.spec.ts
```typescript
import { Component, PLATFORM_ID } from '@angular/core';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { BrnAvatarFallbackDirective } from './brn-avatar-fallback.directive';

@Component({
	selector: 'brn-mock',
	standalone: true,
	imports: [BrnAvatarFallbackDirective],
	template: `
		<span *brnAvatarFallback>fallback</span>
		<span brnAvatarFallback>fallback2</span>
	`,
})
class BrnMockComponent {}

describe('BrnAvatarFallbackDirective', () => {
	let component: BrnMockComponent;
	let fixture: ComponentFixture<BrnMockComponent>;

	beforeEach(() => {
		fixture = TestBed.overrideProvider(PLATFORM_ID, { useValue: 'browser' }).createComponent(BrnMockComponent);
		component = fixture.componentInstance;
	});

	it('should compile', () => {
		expect(component).toBeTruthy();
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/fallback/brn-avatar-fallback.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { Directive, ElementRef, booleanAttribute, inject, input } from '@angular/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[brnAvatarFallback]',
	standalone: true,
	exportAs: 'avatarFallback',
})
export class BrnAvatarFallbackDirective {
	private readonly _element = inject(ElementRef).nativeElement;

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly autoColor = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

	getTextContent(): string {
		return this._element.textContent;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/fallback/index.ts
```typescript
export * from './brn-avatar-fallback.directive';

```
