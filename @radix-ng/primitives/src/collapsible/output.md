/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/collapsible/README.md
```
# @radix-ng/primitives/collapsible

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/collapsible/index.ts
```typescript
export * from './src/collapsible-content.directive';
export * from './src/collapsible-root.directive';
export * from './src/collapsible-trigger.directive';

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/collapsible/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/collapsible/stories/collapsible-animation.component.ts
```typescript
import { animate, state, style, transition, trigger } from '@angular/animations';
import { Component } from '@angular/core';
import { LucideAngularModule } from 'lucide-angular';
import { RdxCollapsibleContentDirective } from '../src/collapsible-content.directive';
import { RdxCollapsibleRootDirective } from '../src/collapsible-root.directive';
import { RdxCollapsibleTriggerDirective } from '../src/collapsible-trigger.directive';

@Component({
    selector: 'rdx-collapsible-animation',
    imports: [
        RdxCollapsibleRootDirective,
        RdxCollapsibleTriggerDirective,
        RdxCollapsibleContentDirective,
        LucideAngularModule
    ],
    // prettier-ignore
    animations: [
        trigger('contentExpansion', [
            state('expanded', style({ height: '*', opacity: 1, visibility: 'visible' })),
            state('collapsed', style({ height: '0px', opacity: 0, visibility: 'hidden' })),
            transition('expanded <=> collapsed', animate('200ms cubic-bezier(.37,1.04,.68,.98)'))
        ])
    ],
    styles: `
        button {
            all: unset;
        }

        .CollapsibleRoot {
            width: 300px;
        }

        .IconButton {
            font-family: inherit;
            border-radius: 100%;
            height: 25px;
            width: 25px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: var(--violet-11);
            box-shadow: 0 2px 10px var(--black-a7);
        }

        .IconButton[data-state='closed'] {
            background-color: white;
        }

        .IconButton[data-state='open'] {
            background-color: var(--violet-3);
        }

        .IconButton:hover {
            background-color: var(--violet-3);
        }

        .IconButton:focus {
            box-shadow: 0 0 0 2px black;
        }

        .Text {
            color: var(--violet-11);
            font-size: 15px;
            line-height: 25px;
        }

        .Repository {
            background-color: white;
            border-radius: 4px;
            margin: 10px 0;
            padding: 10px;
            box-shadow: 0 2px 10px var(--black-a7);
        }
    `,
    template: `
        <div
            class="CollapsibleRoot"
            #collapsibleRoot="collapsibleRoot"
            [open]="open"
            (onOpenChange)="onOpenChange($event)"
            rdxCollapsibleRoot
        >
            <div style="display: flex; align-items: center; justify-content: space-between;">
                <span class="Text" style="color: white">&#64;peduarte starred 3 repositories</span>
                <button class="IconButton" rdxCollapsibleTrigger>
                    @if (open) {
                        <lucide-angular size="16" name="x" style="display: flex;" />
                    } @else {
                        <lucide-angular size="16" name="unfold-vertical" style="display: flex;" />
                    }
                </button>
            </div>

            <div class="Repository">
                <span class="Text">&#64;radix-ui/primitives</span>
            </div>

            <div [@contentExpansion]="collapsibleRoot.isOpen() ? 'expanded' : 'collapsed'" rdxCollapsibleContent>
                <div class="Repository">
                    <span class="Text">&#64;radix-ui/colors</span>
                </div>
                <div class="Repository">
                    <span class="Text">&#64;stitches/react</span>
                </div>
            </div>
        </div>
    `
})
export class RdxCollapsibleAnimationComponent {
    open = true;

    onOpenChange($event: boolean) {
        this.open = $event;
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/collapsible/stories/collapsible-external-triggering.component.ts
```typescript
import { Component } from '@angular/core';
import { LucideAngularModule } from 'lucide-angular';
import { RdxCollapsibleContentDirective } from '../src/collapsible-content.directive';
import { RdxCollapsibleRootDirective } from '../src/collapsible-root.directive';

@Component({
    selector: 'rdx-collapsible-external-triggering',
    imports: [
        RdxCollapsibleRootDirective,
        RdxCollapsibleContentDirective,
        LucideAngularModule
    ],
    styles: `
        .CollapsibleRoot {
            width: 300px;
        }

        .ExternalTrigger {
            font-family: inherit;
            border-radius: 8px;

            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: var(--violet-11);
            box-shadow: 0 2px 10px var(--black-a7);
            margin-bottom: 10px;
            padding: 4px;
        }

        .ExternalTrigger[data-state='closed'] {
            background-color: white;
        }

        .ExternalTrigger[data-state='open'] {
            background-color: var(--violet-3);
        }

        .ExternalTrigger:hover {
            background-color: var(--violet-3);
        }

        .ExternalTrigger:focus {
            box-shadow: 0 0 0 2px black;
        }

        .Text {
            color: var(--violet-11);
            font-size: 15px;
            line-height: 25px;
        }

        .Repository {
            background-color: white;
            border-radius: 4px;
            margin: 10px 0;
            padding: 10px;
            box-shadow: 0 2px 10px var(--black-a7);
        }
    `,
    template: `
        <button class="ExternalTrigger" (click)="open = !open">External Trigger</button>
        <div class="CollapsibleRoot" #collapsibleRoot="collapsibleRoot" [open]="open" rdxCollapsibleRoot>
            <div style="display: flex; align-items: center; justify-content: space-between;">
                <span class="Text" style="color: white">&#64;peduarte starred 3 repositories</span>
            </div>

            <div class="Repository">
                <span class="Text">&#64;radix-ui/primitives</span>
            </div>

            <div rdxCollapsibleContent>
                <div class="Repository">
                    <span class="Text">&#64;radix-ui/colors</span>
                </div>
                <div class="Repository">
                    <span class="Text">&#64;stitches/react</span>
                </div>
            </div>
        </div>
    `
})
export class RdxCollapsibleExternalTriggeringComponent {
    open = true;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/collapsible/stories/collapsible.docs.mdx
````
import { ArgTypes, Canvas, Meta } from '@storybook/blocks';
import * as CollapsibleStories from './collapsible.stories';
import { RdxCollapsibleRootDirective } from '../src/collapsible-root.directive';

<Meta title="Primitives/Collapsible" />

# Collapsible

#### An interactive component which expands/collapses a panel.

<Canvas sourceState="hidden" of={CollapsibleStories.Default} />

## Features

- ✅ Full keyboard navigation.
- ✅ Can be controlled or uncontrolled.

## Anatomy

```html
<div rdxCollapsibleRoot>
  <button rdxCollapsibleTrigger>Trigger</button>
  <div rdxCollapsibleContent>Content</div>
</div>
```

## Import

Get started with importing the directives:

```typescript
import {
  RdxCollapsibleRootDirective,
  RdxCollapsibleTriggerDirective,
  RdxCollapsibleContentDirective
} from '@radix-ng/primitives/collapsible';
```

## API Reference

### Root

`RdxCollapsibleRootDirective`

<ArgTypes of={RdxCollapsibleRootDirective} />

### Trigger

`RdxCollapsibleTriggerDirective`


### Content

`RdxCollapsibleContentDirective`

## Examples

### Animation

<Canvas sourceState="hidden" of={CollapsibleStories.Animation} />

### External Trigger

<Canvas sourceState="hidden" of={CollapsibleStories.ExternalTrigger} />

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/collapsible/stories/collapsible.stories.ts
```typescript
import { BrowserAnimationsModule, provideAnimations } from '@angular/platform-browser/animations';
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { LucideAngularModule, UnfoldVertical, X } from 'lucide-angular';
import { RdxCollapsibleContentDirective } from '../src/collapsible-content.directive';
import { RdxCollapsibleRootDirective } from '../src/collapsible-root.directive';
import { RdxCollapsibleTriggerDirective } from '../src/collapsible-trigger.directive';
import { RdxCollapsibleAnimationComponent } from './collapsible-animation.component';
import { RdxCollapsibleExternalTriggeringComponent } from './collapsible-external-triggering.component';

const html = String.raw;

export default {
    title: 'Primitives/Collapsible',
    decorators: [
        moduleMetadata({
            imports: [
                RdxCollapsibleRootDirective,
                RdxCollapsibleTriggerDirective,
                RdxCollapsibleContentDirective,
                RdxCollapsibleExternalTriggeringComponent,
                RdxCollapsibleAnimationComponent,
                BrowserAnimationsModule,
                LucideAngularModule,
                LucideAngularModule.pick({ X, UnfoldVertical })
            ],
            providers: [provideAnimations()]
        }),
        componentWrapperDecorator(
            (story) => html`
                <div
                    class="radix-themes light light-theme radix-themes-default-fonts"
                    data-accent-color="indigo"
                    data-radius="medium"
                    data-scaling="100%"
                >
                    ${story}
                </div>

                <style>
                    button {
                        all: unset;
                    }
                    .CollapsibleRoot {
                        width: 300px;
                    }

                    .IconButton {
                        font-family: inherit;
                        border-radius: 100%;
                        height: 25px;
                        width: 25px;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        color: var(--violet-11);
                        box-shadow: 0 2px 10px var(--black-a7);
                    }

                    .IconButton[data-state='closed'] {
                        background-color: white;
                    }

                    .IconButton[data-state='open'] {
                        background-color: var(--violet-3);
                    }

                    .IconButton:hover {
                        background-color: var(--violet-3);
                    }

                    .IconButton:focus {
                        box-shadow: 0 0 0 2px black;
                    }

                    .Text {
                        color: var(--violet-11);
                        font-size: 15px;
                        line-height: 25px;
                    }

                    .Repository {
                        background-color: white;
                        border-radius: 4px;
                        margin: 10px 0;
                        padding: 10px;
                        box-shadow: 0 2px 10px var(--black-a7);
                    }
                </style>
            `
        )
    ]
} as Meta;

type Story = StoryObj;

export const Default: Story = {
    render: () => ({
        template: html`
            <div class="CollapsibleRoot" rdxCollapsibleRoot [open]="true" #collapsibleRoot="collapsibleRoot">
                <div style="display: flex; align-items: center; justify-content: space-between;">
                    <span class="Text" style="color: white">&#64;peduarte starred 3 repositories</span>
                    <button class="IconButton" rdxCollapsibleTrigger>
                        @if (collapsibleRoot.isOpen()) {
                        <lucide-angular size="16" name="x" style="display: flex;"></lucide-angular>
                        } @else {
                        <lucide-angular size="16" name="unfold-vertical" style="display: flex;"></lucide-angular>
                        }
                    </button>
                </div>

                <div class="Repository">
                    <span class="Text">&#64;radix-ui/primitives</span>
                </div>

                <div rdxCollapsibleContent>
                    <div class="Repository">
                        <span class="Text">&#64;radix-ui/colors</span>
                    </div>
                    <div class="Repository">
                        <span class="Text">&#64;stitches/react</span>
                    </div>
                </div>
            </div>
        `
    })
};

export const ExternalTrigger: Story = {
    render: () => ({
        template: html`
            <div
                class="radix-themes light light-theme radix-themes-default-fonts"
                data-accent-color="indigo"
                data-radius="medium"
                data-scaling="100%"
            >
                <rdx-collapsible-external-triggering></rdx-collapsible-external-triggering>
            </div>
        `
    })
};

export const Animation: Story = {
    render: () => ({
        template: html`
            <div
                class="radix-themes light light-theme radix-themes-default-fonts"
                data-accent-color="indigo"
                data-radius="medium"
                data-scaling="100%"
            >
                <rdx-collapsible-animation></rdx-collapsible-animation>
            </div>
        `
    })
};

```
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
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/collapsible/src/collapsible-content.directive.ts
```typescript
import { Directive, ElementRef, inject } from '@angular/core';
import { RdxCollapsibleContentToken } from './collapsible-content.token';
import { RdxCollapsibleRootDirective } from './collapsible-root.directive';

@Directive({
    selector: '[rdxCollapsibleContent]',
    providers: [
        {
            provide: RdxCollapsibleContentToken,
            useExisting: RdxCollapsibleContentDirective
        }
    ],
    host: {
        '[attr.data-state]': 'collapsible.getState()',
        '[attr.data-disabled]': 'getDisabled()'
    }
})
export class RdxCollapsibleContentDirective {
    protected readonly collapsible = inject(RdxCollapsibleRootDirective);

    /**
     * Reference to CollapsibleContent host element
     * @ignore
     */
    readonly elementRef = inject<ElementRef<HTMLElement>>(ElementRef);

    getDisabled(): string | undefined {
        return this.collapsible.disabled() ? 'disabled' : undefined;
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/collapsible/src/collapsible-content.token.ts
```typescript
import { InjectionToken } from '@angular/core';
import { RdxCollapsibleContentDirective } from './collapsible-content.directive';

export const RdxCollapsibleContentToken = new InjectionToken<RdxCollapsibleContentDirective>(
    'RdxCollapsibleContentToken'
);

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/collapsible/src/collapsible-root.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { booleanAttribute, contentChild, Directive, inject, InjectionToken, input, Input, output } from '@angular/core';
import { asyncScheduler } from 'rxjs';
import { RdxCollapsibleContentToken } from './collapsible-content.token';

const RdxCollapsibleRootToken = new InjectionToken<RdxCollapsibleRootDirective>('RdxCollapsibleRootToken');

export function injectCollapsible(): RdxCollapsibleRootDirective {
    return inject(RdxCollapsibleRootDirective);
}

export type RdxCollapsibleState = 'open' | 'closed';

/**
 * @group Components
 */
@Directive({
    selector: '[rdxCollapsibleRoot]',
    exportAs: 'collapsibleRoot',
    providers: [{ provide: RdxCollapsibleRootToken, useExisting: RdxCollapsibleRootDirective }],
    host: {
        '[attr.data-state]': 'getState()',
        '[attr.data-disabled]': 'disabled() ? "" : undefined'
    }
})
export class RdxCollapsibleRootDirective {
    /**
     * Reference to RdxCollapsibleContent directive
     */
    private readonly contentDirective = contentChild.required(RdxCollapsibleContentToken);

    /**
     * Determines whether a directive is available for interaction.
     * When true, prevents the user from interacting with the collapsible.
     *
     * @group Props
     */
    readonly disabled = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

    /**
     * The controlled open state of the collapsible.
     * Sets the state of the directive. `true` - expanded, `false` - collapsed
     *
     * @group Props
     * @defaultValue false
     */
    @Input() set open(value: boolean) {
        if (value !== this._open) {
            this.onOpenChange.emit(value);
        }

        this._open = value;
        this.setPresence();
    }

    get open(): boolean {
        return this._open;
    }

    /**
     * Stores collapsible state
     */
    private _open = false;

    /**
     * Emitted with new value when directive state changed.
     * Event handler called when the open state of the collapsible changes.
     *
     * @group Emits
     */
    readonly onOpenChange = output<boolean>();

    /**
     * Allows to change directive state
     * @param {boolean | undefined} value
     * @ignore
     */
    setOpen(value?: boolean) {
        if (this.disabled()) {
            return;
        }

        if (value === undefined) {
            this.open = !this.open;
        } else {
            this.open = value;
        }

        this.setPresence();
    }

    /**
     * Returns directive state (open | closed)
     * @ignore
     */
    getState(): RdxCollapsibleState {
        return this.open ? 'open' : 'closed';
    }

    /**
     * Returns current directive state
     * @ignore
     */
    isOpen(): boolean {
        return this.open;
    }

    /**
     * Controls visibility of content
     */
    private setPresence(): void {
        if (!this.contentDirective) {
            return;
        }

        if (this.isOpen()) {
            this.contentDirective().elementRef.nativeElement.removeAttribute('hidden');
        } else {
            asyncScheduler.schedule(() => {
                const animations = this.contentDirective().elementRef.nativeElement.getAnimations();

                if (animations === undefined || animations.length === 0) {
                    this.contentDirective().elementRef.nativeElement.setAttribute('hidden', '');
                }
            });
        }
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/collapsible/src/collapsible-trigger.directive.ts
```typescript
import { Directive } from '@angular/core';
import { injectCollapsible, RdxCollapsibleState } from './collapsible-root.directive';

@Directive({
    selector: '[rdxCollapsibleTrigger]',
    host: {
        '[attr.data-state]': 'getState()',
        '[attr.data-disabled]': 'getDisabled()',
        '[attr.aria-expanded]': 'getState() === "open" ? "true" : "false"',
        '[disabled]': 'getDisabled()',

        '(click)': 'onOpenToggle()'
    }
})
export class RdxCollapsibleTriggerDirective {
    /**
     * Reference to CollapsibleRoot
     * @private
     * @ignore
     */
    private readonly collapsible = injectCollapsible();

    /**
     * Called on trigger clicked
     */
    onOpenToggle(): void {
        this.collapsible.setOpen();
    }

    /**
     * Returns current directive state (open | closed)
     * @ignore
     */
    getState(): RdxCollapsibleState {
        return this.collapsible.getState();
    }

    /**
     * Returns current trigger state
     * @ignore
     */
    getDisabled(): string | undefined {
        return this.collapsible.disabled() ? 'disabled' : undefined;
    }
}

```
