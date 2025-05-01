/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/collapsible/__tests__/collapsible-content.directive.spec.ts
```typescript
import { Component } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RdxCollapsibleContentDirective } from '../src/collapsible-content.directive';
import { RdxCollapsibleRootDirective } from '../src/collapsible-root.directive';

@Component({
    selector: 'rdx-collapsible-mock-trigger',
    standalone: true,
    imports: [RdxCollapsibleRootDirective, RdxCollapsibleContentDirective],
    template: `
        <div CollapsibleRoot>
            <div CollapsibleContent>Content</div>
        </div>
    `
})
class RdxCollapsibleMockComponent {}

describe('RdxCollapsibleContentDirective', () => {
    let component: RdxCollapsibleMockComponent;
    let fixture: ComponentFixture<RdxCollapsibleMockComponent>;

    beforeEach(() => {
        fixture = TestBed.createComponent(RdxCollapsibleMockComponent);
        component = fixture.componentInstance;
    });

    it('should create an instance', () => {
        expect(component).toBeTruthy();
    });
});

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/collapsible/__tests__/collapsible-root.directive.spec.ts
```typescript
import { Component } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RdxCollapsibleRootDirective } from '../src/collapsible-root.directive';

@Component({
    selector: 'rdx-collapsible-mock-trigger',
    standalone: true,
    imports: [RdxCollapsibleRootDirective],
    template: `
        <div CollapsibleRoot></div>
    `
})
class RdxCollapsibleMockComponent {}

describe('RdxCollapsibleRootDirective', () => {
    let component: RdxCollapsibleMockComponent;
    let fixture: ComponentFixture<RdxCollapsibleMockComponent>;

    beforeEach(() => {
        fixture = TestBed.createComponent(RdxCollapsibleMockComponent);
        component = fixture.componentInstance;
    });

    it('should create an instance', () => {
        expect(component).toBeTruthy();
    });
});

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/collapsible/__tests__/collapsible-trigger.directive.spec.ts
```typescript
import { Component } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RdxCollapsibleRootDirective } from '../src/collapsible-root.directive';
import { RdxCollapsibleTriggerDirective } from '../src/collapsible-trigger.directive';

@Component({
    selector: 'rdx-collapsible-mock-trigger',
    standalone: true,
    imports: [RdxCollapsibleRootDirective, RdxCollapsibleTriggerDirective],
    template: `
        <div CollapsibleRoot>
            <button CollapsibleTrigger>Trigger</button>
        </div>
    `
})
class RdxCollapsibleMockComponent {}

describe('RdxCollapsibleTriggerDirective', () => {
    let component: RdxCollapsibleMockComponent;
    let fixture: ComponentFixture<RdxCollapsibleMockComponent>;

    beforeEach(() => {
        fixture = TestBed.createComponent(RdxCollapsibleMockComponent);
        component = fixture.componentInstance;
    });

    it('should create an instance', () => {
        expect(component).toBeTruthy();
    });
});

```
