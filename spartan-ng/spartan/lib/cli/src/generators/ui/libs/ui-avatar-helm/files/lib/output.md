/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/hlm-avatar.component.spec.ts.template
```
import { Component, Input } from '@angular/core';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { BrnAvatarFallbackDirective, BrnAvatarImageDirective } from '@spartan-ng/brain/avatar';
import { HlmAvatarComponent } from './hlm-avatar.component';

@Component({
	selector: 'hlm-mock',
	imports: [BrnAvatarImageDirective, BrnAvatarFallbackDirective, HlmAvatarComponent],
	template: `
		<hlm-avatar [class]="class" id="fallbackOnly">
			<span brnAvatarFallback>fallback</span>
		</hlm-avatar>
	`,
	standalone: true,
})
class MockComponent {
	@Input() public class = '';
}

describe('HlmAvatarComponent', () => {
	let component: HlmAvatarComponent;
	let fixture: ComponentFixture<HlmAvatarComponent>;

	beforeEach(() => {
		fixture = TestBed.createComponent(HlmAvatarComponent);
		component = fixture.componentInstance;
	});

	it('should compile', () => {
		expect(component).toBeTruthy();
	});

	it('should add the default classes if no inputs are provided', () => {
		fixture.detectChanges();
		expect(fixture.nativeElement.className).toBe('flex h-10 overflow-hidden relative rounded-full shrink-0 w-10');
	});

	it('should add any user defined classes', () => {
		const mockFixture = TestBed.createComponent(MockComponent);
		mockFixture.componentRef.setInput('class', 'test-class');
		mockFixture.detectChanges();
		const avatar = mockFixture.nativeElement.querySelector('hlm-avatar');
		expect(avatar.className).toContain('test-class');
	});

	it('should change the size when the variant is changed', () => {
		fixture.componentRef.setInput('variant', 'small');
		fixture.detectChanges();
		expect(fixture.nativeElement.className).toContain('h-6');
		expect(fixture.nativeElement.className).toContain('w-6');
		expect(fixture.nativeElement.className).toContain('text-xs');

		fixture.componentRef.setInput('variant', 'large');
		fixture.detectChanges();
		expect(fixture.nativeElement.className).toContain('h-14');
		expect(fixture.nativeElement.className).toContain('w-14');
		expect(fixture.nativeElement.className).toContain('text-lg');
	});

	it('should support brn directives', () => {
		const mockFixture = TestBed.createComponent(MockComponent);
		mockFixture.detectChanges();
		expect(mockFixture.nativeElement.querySelector('span').textContent).toBe('fallback');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/hlm-avatar.component.ts.template
```
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, input } from '@angular/core';
import { BrnAvatarComponent } from '@spartan-ng/brain/avatar';
import { hlm } from '@spartan-ng/brain/core';
import { type VariantProps, cva } from 'class-variance-authority';
import type { ClassValue } from 'clsx';

export const avatarVariants = cva('relative flex shrink-0 overflow-hidden rounded-full', {
	variants: {
		variant: {
			small: 'h-6 w-6 text-xs',
			medium: 'h-10 w-10',
			large: 'h-14 w-14 text-lg',
		},
	},
	defaultVariants: {
		variant: 'medium',
	},
});

export type AvatarVariants = VariantProps<typeof avatarVariants>;

@Component({
	selector: 'hlm-avatar',
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	standalone: true,
	host: {
		'[class]': '_computedClass()',
	},
	template: `
		@if (image()?.canShow()) {
			<ng-content select="[hlmAvatarImage],[brnAvatarImage]" />
		} @else {
			<ng-content select="[hlmAvatarFallback],[brnAvatarFallback]" />
		}
	`,
})
export class HlmAvatarComponent extends BrnAvatarComponent {
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly variant = input<AvatarVariants['variant']>('medium');

	protected readonly _computedClass = computed(() =>
		hlm(avatarVariants({ variant: this.variant() }), this.userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/fallback/hlm-avatar-fallback.directive.spec.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/fallback/hlm-avatar-fallback.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/fallback/index.ts.template
```
export * from './hlm-avatar-fallback.directive';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/image/hlm-avatar-image.directive.spec.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/image/hlm-avatar-image.directive.ts.template
```
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
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-avatar-helm/files/lib/image/index.ts.template
```
export * from './hlm-avatar-image.directive';

```
