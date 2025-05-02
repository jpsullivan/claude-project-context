/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/lib/image/hlm-avatar-image.directive.spec.ts
```typescript
import { Component } from '@angular/core';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { HlmAvatarImageDirective } from './hlm-avatar-image.directive';

@Component({
	selector: 'hlm-mock',
	standalone: true,
	imports: [HlmAvatarImageDirective],
	template: `
		<img hlmAvatarImage alt="Avatar image" [class]="userCls" />
	`,
})
class HlmMockComponent {
	public userCls = '';
}

describe('HlmAvatarImageDirective', () => {
	let component: HlmMockComponent;
	let fixture: ComponentFixture<HlmMockComponent>;

	beforeEach(() => {
		fixture = TestBed.createComponent(HlmMockComponent);
		component = fixture.componentInstance;
	});

	it('should compile', () => {
		expect(component).toBeTruthy();
	});

	it('should add the default classes if no inputs are provided', () => {
		fixture.detectChanges();
		expect(fixture.nativeElement.querySelector('img').className).toBe('aspect-square h-full object-cover w-full');
	});

	it('should add any user defined classes', async () => {
		component.userCls = 'test-class';
		fixture.detectChanges();

		// fallback uses Promise.resolve().then() so we need to wait for the next tick
		setTimeout(() => {
			expect(fixture.nativeElement.querySelector('img').className).toContain('test-class');
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/lib/image/hlm-avatar-image.directive.ts
```typescript
import { Directive, computed, inject, input } from '@angular/core';
import { BrnAvatarImageDirective } from '@spartan-ng/brain/avatar';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: 'img[hlmAvatarImage]',
	standalone: true,
	exportAs: 'avatarImage',
	hostDirectives: [BrnAvatarImageDirective],
	host: {
		'[class]': '_computedClass()',
	},
})
export class HlmAvatarImageDirective {
	public canShow = inject(BrnAvatarImageDirective).canShow;

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('aspect-square object-cover h-full w-full', this.userClass()));
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/lib/image/index.ts
```typescript
export * from './hlm-avatar-image.directive';

```
