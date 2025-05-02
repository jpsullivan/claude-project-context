/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/lib/fallback/hlm-avatar-fallback.directive.spec.ts
```typescript
import { Component, PLATFORM_ID } from '@angular/core';
import { type ComponentFixture, TestBed, fakeAsync } from '@angular/core/testing';
import { hexColorFor, isBright } from '@spartan-ng/brain/avatar';
import { HlmAvatarFallbackDirective } from './hlm-avatar-fallback.directive';

@Component({
	selector: 'hlm-mock',
	standalone: true,
	imports: [HlmAvatarFallbackDirective],
	template: `
		<span hlmAvatarFallback [class]="userCls" [autoColor]="autoColor">fallback2</span>
	`,
})
class HlmMockComponent {
	public userCls = '';
	public autoColor = false;
}

describe('HlmAvatarFallbackDirective', () => {
	let component: HlmMockComponent;
	let fixture: ComponentFixture<HlmMockComponent>;

	beforeEach(() => {
		fixture = TestBed.overrideProvider(PLATFORM_ID, { useValue: 'browser' }).createComponent(HlmMockComponent);
		component = fixture.componentInstance;
	});

	it('should compile', () => {
		expect(component).toBeTruthy();
	});

	it('should contain the default classes if no inputs are provided', () => {
		fixture.detectChanges();
		expect(fixture.nativeElement.querySelector('span').className).toBe(
			'bg-muted flex h-full items-center justify-center rounded-full w-full',
		);
	});

	it('should add any user defined classes', async () => {
		component.userCls = 'test-class';

		fixture.detectChanges();
		expect(fixture.nativeElement.querySelector('span').className).toContain('test-class');
	});
	it('should merge bg-destructive correctly when set as user defined class, therefore removing bg-muted', async () => {
		component.userCls = 'bg-destructive ';

		fixture.detectChanges();
		expect(fixture.nativeElement.querySelector('span').className).toContain('bg-destructive');
	});

	describe('autoColor', () => {
		beforeEach(() => {
			component.autoColor = true;
			fixture.detectChanges();
		});

		it('should remove the bg-muted class from the component', fakeAsync(() => {
			fixture.detectChanges();
			expect(fixture.nativeElement.querySelector('span').className).not.toContain('bg-muted');
		}));

		it('should remove add a text color class and hex backgroundColor style depending on its content', () => {
			const hex = hexColorFor('fallback2');
			const textCls = isBright(hex) ? 'text-black' : 'text-white';
			expect(fixture.nativeElement.querySelector('span').className).toContain(textCls);
			expect(fixture.nativeElement.querySelector('span').style.backgroundColor).toBe('rgb(144, 53, 149)');
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/lib/fallback/hlm-avatar-fallback.directive.ts
```typescript
import { Directive, computed, inject } from '@angular/core';
import { BrnAvatarFallbackDirective, hexColorFor, isBright } from '@spartan-ng/brain/avatar';
import { hlm } from '@spartan-ng/brain/core';

@Directive({
	selector: '[hlmAvatarFallback]',
	standalone: true,
	exportAs: 'avatarFallback',
	hostDirectives: [
		{
			directive: BrnAvatarFallbackDirective,
			inputs: ['class:class', 'autoColor:autoColor'],
		},
	],
	host: {
		'[class]': '_computedClass()',
		'[style.backgroundColor]': "_hex() || ''",
	},
})
export class HlmAvatarFallbackDirective {
	private readonly _brn = inject(BrnAvatarFallbackDirective);
	private readonly _hex = computed(() => {
		if (!this._brn.autoColor() || !this._brn.getTextContent()) return;
		return hexColorFor(this._brn.getTextContent());
	});

	private readonly _autoColorTextCls = computed(() => {
		const hex = this._hex();
		if (!hex) return;
		return `${isBright(hex) ? 'text-black' : 'text-white'}`;
	});

	protected readonly _computedClass = computed(() => {
		return hlm(
			'flex h-full w-full items-center justify-center rounded-full',
			this._autoColorTextCls() ?? 'bg-muted',
			this._brn?.userClass(),
		);
	});
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/avatar/helm/src/lib/fallback/index.ts
```typescript
export * from './hlm-avatar-fallback.directive';

```
