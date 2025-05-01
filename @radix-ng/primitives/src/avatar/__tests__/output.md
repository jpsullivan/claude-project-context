/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/avatar/__tests__/avatar-fallback.directive.spec.ts
```typescript
import { Component, PLATFORM_ID } from '@angular/core';
import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { RdxAvatarFallbackDirective } from '../src/avatar-fallback.directive';
import { RdxAvatarRootDirective } from '../src/avatar-root.directive';

@Component({
    selector: 'rdx-mock-component',
    standalone: true,
    imports: [RdxAvatarFallbackDirective, RdxAvatarRootDirective],
    template: `
        <span rdxAvatarRoot>
            <span [delayMs]="delay" rdxAvatarFallback>fallback</span>
            <span rdxAvatarFallback>fallback2</span>
        </span>
    `
})
class RdxMockComponent {
    delay = 1000;
}

describe('RdxAvatarFallbackDirective', () => {
    let component: RdxMockComponent;
    let fixture: ComponentFixture<RdxMockComponent>;

    beforeEach(() => {
        fixture = TestBed.overrideProvider(PLATFORM_ID, { useValue: 'browser' }).createComponent(RdxMockComponent);
        component = fixture.componentInstance;
    });

    it('should compile', () => {
        expect(component).toBeTruthy();
    });

    it('should hide fallback initially', () => {
        fixture.detectChanges();
        const fallbackElement = fixture.debugElement.query(By.css('span[rdxAvatarFallback]'));
        expect(fallbackElement.nativeElement.style.display).toBe('none');
    });

    it('should show fallback after delay', fakeAsync(() => {
        fixture.detectChanges();

        tick(1000);
        fixture.detectChanges();

        const fallbackElement = fixture.debugElement.query(By.css('span[rdxAvatarFallback]'));
        expect(fallbackElement.nativeElement.style.display).not.toBe('none');
    }));
});

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/avatar/__tests__/avatar-image.directive.spec.ts
```typescript
import { Component } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { RdxAvatarFallbackDirective } from '../src/avatar-fallback.directive';
import { RdxAvatarImageDirective } from '../src/avatar-image.directive';
import { RdxAvatarRootDirective } from '../src/avatar-root.directive';

@Component({
    selector: 'rdx-mock-component',
    standalone: true,
    imports: [RdxAvatarImageDirective, RdxAvatarRootDirective, RdxAvatarFallbackDirective],
    template: `
        <span rdxAvatarRoot>
            <img
                rdxAvatarImage
                alt="Angular Logo"
                src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNTAgMjUwIj4KICAgIDxwYXRoIGZpbGw9IiNERDAwMzEiIGQ9Ik0xMjUgMzBMMzEuOSA2My4ybDE0LjIgMTIzLjFMMTI1IDIzMGw3OC45LTQzLjcgMTQuMi0xMjMuMXoiIC8+CiAgICA8cGF0aCBmaWxsPSIjQzMwMDJGIiBkPSJNMTI1IDMwdjIyLjItLjFWMjMwbDc4LjktNDMuNyAxNC4yLTEyMy4xTDEyNSAzMHoiIC8+CiAgICA8cGF0aCAgZmlsbD0iI0ZGRkZGRiIgZD0iTTEyNSA1Mi4xTDY2LjggMTgyLjZoMjEuN2wxMS43LTI5LjJoNDkuNGwxMS43IDI5LjJIMTgzTDEyNSA1Mi4xem0xNyA4My4zaC0zNGwxNy00MC45IDE3IDQwLjl6IiAvPgogIDwvc3ZnPg=="
            />
            <span rdxAvatarFallback>Angular Logo</span>
        </span>
    `
})
class RdxMockComponent {}

describe('RdxAvatarImageDirective', () => {
    let component: RdxMockComponent;
    let fixture: ComponentFixture<RdxMockComponent>;

    beforeEach(() => {
        fixture = TestBed.createComponent(RdxMockComponent);
        component = fixture.componentInstance;
    });

    it('should compile', () => {
        expect(component).toBeTruthy();
    });

    it('should display the image initially', () => {
        const imgElement = fixture.debugElement.query(By.css('img[rdxAvatarImage]'));
        expect(imgElement).toBeTruthy();
        expect(imgElement.nativeElement.src).toContain('data:image/svg+xml');
    });
});

```
