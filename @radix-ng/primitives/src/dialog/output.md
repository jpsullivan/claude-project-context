/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/README.md
```
# @radix-ng/primitives/dialog

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/index.ts
```typescript
import { NgModule } from '@angular/core';
import { RdxDialogCloseDirective } from './src/dialog-close.directive';
import { RdxDialogContentDirective } from './src/dialog-content.directive';
import { RdxDialogDescriptionDirective } from './src/dialog-description.directive';
import { RdxDialogDismissDirective } from './src/dialog-dismiss.directive';
import { RdxDialogTitleDirective } from './src/dialog-title.directive';
import { RdxDialogTriggerDirective } from './src/dialog-trigger.directive';

export * from './src/dialog-close.directive';
export * from './src/dialog-content.directive';
export * from './src/dialog-description.directive';
export * from './src/dialog-dismiss.directive';
export * from './src/dialog-ref';
export * from './src/dialog-title.directive';
export * from './src/dialog-trigger.directive';
export * from './src/dialog.config';
export * from './src/dialog.injectors';
export * from './src/dialog.providers';
export * from './src/dialog.service';

const _imports = [
    RdxDialogTriggerDirective,
    RdxDialogContentDirective,
    RdxDialogTitleDirective,
    RdxDialogCloseDirective,
    RdxDialogDescriptionDirective,
    RdxDialogDismissDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxDialogModule {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/stories/dialog.docs.mdx
````
import { Canvas, Meta } from '@storybook/blocks';
import * as DialogStories from './dialog.stories';
import * as SheetStories from './sheet.stories';

<Meta title="Primitives/Dialog" />

# Dialog

#### A window overlaid on either the primary window or another dialog window, rendering the content underneath inert.

<Canvas sourceState="hidden" of={DialogStories.Default} />

## Features
- ✅ Supports modal and non-modal modes.
- ✅ Focus is automatically trapped when modal.
- ✅ Can be controlled or uncontrolled.
- ✅ Esc closes the component automatically.

### Anatomy
Import all parts and piece them together.

```html

<button [rdxDialogTrigger]="dialog">Open Dialog</button>

<ng-template #dialog>
    <div rdxDialogContent>
        <h2 rdxDialogTitle></h2>
        <p rdxDialogDescription></p>
        <button rdxDialogClose></button>
        <button rdxDialogDismiss>X</button>
    </div>
</ng-template>
```

## Examples

### Sheet

<Canvas sourceState="hidden" of={SheetStories.Default} />

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/stories/dialog.stories.ts
```typescript
import { applicationConfig, componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { RdxDialogCloseDirective } from '../src/dialog-close.directive';
import { RdxDialogContentDirective } from '../src/dialog-content.directive';
import { RdxDialogDescriptionDirective } from '../src/dialog-description.directive';
import { RdxDialogTitleDirective } from '../src/dialog-title.directive';
import { RdxDialogTriggerDirective } from '../src/dialog-trigger.directive';
import { provideRdxDialogConfig } from '../src/dialog.providers';

const html = String.raw;

export default {
    title: 'Primitives/Dialog',
    decorators: [
        applicationConfig({
            providers: [provideRdxDialogConfig()]
        }),
        moduleMetadata({
            imports: [
                RdxDialogTriggerDirective,
                RdxDialogContentDirective,
                RdxDialogTitleDirective,
                RdxDialogCloseDirective,
                RdxDialogDescriptionDirective
            ]
        }),
        componentWrapperDecorator(
            (story) => `
                <div class="radix-themes light light-theme radix-themes-default-fonts rt-Flex rt-r-ai-start rt-r-jc-center rt-r-position-relative"
                    data-accent-color="indigo"
                    data-radius="medium"
                    data-scaling="100%"
                >
                    ${story}
                </div>`
        )
    ]
} as Meta;

type Story = StoryObj;

export const Default: Story = {
    argTypes: {
        mode: {
            options: ['default', 'sheet-right', 'sheet-bottom'],
            control: {
                type: 'select'
            }
        }
    },
    render: (args) => ({
        props: {
            config: args
        },
        template: html`
            <button class="Button violet" [rdxDialogConfig]="config" [rdxDialogTrigger]="dialog">Open Dialog</button>

            <ng-template #dialog>
                <div class="DialogContent" rdxDialogContent>
                    <h2 class="DialogTitle" rdxDialogTitle>Edit profile</h2>
                    <p class="DialogDescription" rdxDialogDescription>
                        Make changes to your profile here. Click save when you're done.
                    </p>
                    <fieldset class="Fieldset">
                        <label class="Label" htmlFor="name">Name</label>
                        <input class="Input" id="name" defaultValue="Pedro Duarte" />
                    </fieldset>
                    <fieldset class="Fieldset">
                        <label class="Label" htmlFor="username">Username</label>
                        <input class="Input" id="username" defaultValue="@peduarte" />
                    </fieldset>
                    <div style="display:flex; margin-top: 25px; justify-content: flex-end;">
                        <button class="Button green" rdxDialogClose>Save changes</button>
                    </div>
                    <button class="IconButton" rdxDialogClose aria-label="Close">X</button>
                </div>
            </ng-template>

            <style>
                /* reset */
                button,
                fieldset,
                input {
                    all: unset;
                }

                .DialogOverlay {
                    background-color: var(--black-a9);
                    position: fixed;
                    inset: 0;
                    animation: overlayShow 150ms cubic-bezier(0.16, 1, 0.3, 1);
                }

                .DialogContent {
                    background-color: white;
                    border-radius: 6px;
                    box-shadow:
                        hsl(206 22% 7% / 35%) 0px 10px 38px -10px,
                        hsl(206 22% 7% / 20%) 0px 10px 20px -15px;
                    position: fixed;
                    top: 50%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    width: 90vw;
                    max-width: 450px;
                    max-height: 85vh;
                    padding: 25px;
                    animation: contentShow 150ms cubic-bezier(0.16, 1, 0.3, 1);
                }

                .DialogContent:focus {
                    outline: none;
                }

                .DialogTitle {
                    margin: 0;
                    font-weight: 500;
                    color: var(--mauve-12);
                    font-size: 17px;
                }

                .DialogDescription {
                    margin: 10px 0 20px;
                    color: var(--mauve-11);
                    font-size: 15px;
                    line-height: 1.5;
                }

                .Button {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    border-radius: 4px;
                    padding: 0 15px;
                    font-size: 15px;
                    line-height: 1;
                    font-weight: 500;
                    height: 35px;
                }

                .Button.violet {
                    background-color: white;
                    color: var(--violet-11);
                    box-shadow: 0 2px 10px var(--black-a7);
                }

                .Button.violet:hover {
                    background-color: var(--mauve-3);
                }

                .Button.violet:focus {
                    box-shadow: 0 0 0 2px black;
                }

                .Button.green {
                    background-color: var(--green-4);
                    color: var(--green-11);
                }

                .Button.green:hover {
                    background-color: var(--green-5);
                }

                .Button.green:focus {
                    box-shadow: 0 0 0 2px var(--green-7);
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
                    position: absolute;
                    top: 10px;
                    right: 10px;
                }

                .IconButton:hover {
                    background-color: var(--violet-4);
                }

                .IconButton:focus {
                    box-shadow: 0 0 0 2px var(--violet-7);
                }

                .Fieldset {
                    display: flex;
                    gap: 20px;
                    align-items: center;
                    margin-bottom: 15px;
                }

                .Label {
                    font-size: 15px;
                    color: var(--violet-11);
                    width: 90px;
                    text-align: right;
                }

                .Input {
                    width: 100%;
                    flex: 1;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    border-radius: 4px;
                    padding: 0 10px;
                    font-size: 15px;
                    line-height: 1;
                    color: var(--violet-11);
                    box-shadow: 0 0 0 1px var(--violet-7);
                    height: 35px;
                }

                .Input:focus {
                    box-shadow: 0 0 0 2px var(--violet-8);
                }
            </style>
        `
    })
};

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/stories/sheet.docs.mdx
```
import { Canvas, Controls, Meta } from '@storybook/blocks';
import * as SheetStories from './sheet.stories';

<Meta of={SheetStories} title="Examples/Sheet" />

# Sheet

<Canvas sourceState="hidden" of={SheetStories.Default} />

<Controls />

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/stories/sheet.stories.ts
```typescript
import { applicationConfig, componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { RdxDialogCloseDirective } from '../src/dialog-close.directive';
import { RdxDialogContentDirective } from '../src/dialog-content.directive';
import { RdxDialogDescriptionDirective } from '../src/dialog-description.directive';
import { RdxDialogTitleDirective } from '../src/dialog-title.directive';
import { RdxDialogTriggerDirective } from '../src/dialog-trigger.directive';
import { provideRdxDialogConfig } from '../src/dialog.providers';

const html = String.raw;

export default {
    title: 'Examples/Sheet',
    decorators: [
        applicationConfig({
            providers: [provideRdxDialogConfig()]
        }),
        moduleMetadata({
            imports: [
                RdxDialogTriggerDirective,
                RdxDialogContentDirective,
                RdxDialogTitleDirective,
                RdxDialogCloseDirective,
                RdxDialogDescriptionDirective
            ]
        }),
        componentWrapperDecorator(
            (story) => html`
                <div
                    class="radix-themes light light-theme radix-themes-default-fonts rt-Flex rt-r-ai-start rt-r-jc-center rt-r-position-relative"
                    data-accent-color="indigo"
                    data-radius="medium"
                    data-scaling="100%"
                >
                    ${story}
                </div>
            `
        )
    ],
    argTypes: {
        mode: {
            options: ['sheet-right', 'sheet-bottom'],
            control: {
                type: 'select'
            }
        },
        backdropClass: {
            options: ['cdk-overlay-dark-backdrop', 'DialogSheetOverlay'],
            control: {
                type: 'select'
            }
        }
    },
    render: (args) => {
        return {
            props: {
                config: args
            },
            template: html`
                <button class="Button violet" [rdxDialogConfig]="config" [rdxDialogTrigger]="sheetTpl">
                    Open Sheet
                </button>

                <ng-template #sheetTpl>
                    <div class="DialogContent" rdxDialogContent>
                        <h2 class="DialogTitle" rdxDialogTitle>Edit profile</h2>
                        <p class="DialogDescription" rdxDialogDescription>
                            Make changes to your profile here. Click save when you're done.
                        </p>
                        <fieldset class="Fieldset">
                            <label class="Label" htmlFor="name">Name</label>
                            <input class="Input" id="name" defaultValue="Pedro Duarte" />
                        </fieldset>
                        <fieldset class="Fieldset">
                            <label class="Label" htmlFor="username">Username</label>
                            <input class="Input" id="username" defaultValue="@peduarte" />
                        </fieldset>
                        <div style="display:flex; margin-top: 25px; justify-content: flex-end;">
                            <button class="Button green" rdxDialogClose>Save changes</button>
                        </div>
                        <button class="IconButton" rdxDialogClose aria-label="Close">X</button>
                    </div>
                </ng-template>

                <style>
                    /* reset */
                    button,
                    fieldset,
                    input {
                        all: unset;
                    }

                    .DialogContent {
                        margin: 25px;
                    }

                    .DialogTitle {
                        margin: 0;
                        font-weight: 500;
                        color: var(--mauve-12);
                        font-size: 17px;
                    }

                    .DialogDescription {
                        margin: 10px 0 20px;
                        color: var(--mauve-11);
                        font-size: 15px;
                        line-height: 1.5;
                    }

                    .Button {
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        border-radius: 4px;
                        padding: 0 15px;
                        font-size: 15px;
                        line-height: 1;
                        font-weight: 500;
                        height: 35px;
                    }

                    .Button.violet {
                        background-color: white;
                        color: var(--violet-11);
                        box-shadow: 0 2px 10px var(--black-a7);
                    }

                    .Button.violet:hover {
                        background-color: var(--mauve-3);
                    }

                    .Button.violet:focus {
                        box-shadow: 0 0 0 2px black;
                    }

                    .Button.green {
                        background-color: var(--green-4);
                        color: var(--green-11);
                    }

                    .Button.green:hover {
                        background-color: var(--green-5);
                    }

                    .Button.green:focus {
                        box-shadow: 0 0 0 2px var(--green-7);
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
                        position: absolute;
                        top: 10px;
                        right: 10px;
                    }

                    .IconButton:hover {
                        background-color: var(--violet-4);
                    }

                    .IconButton:focus {
                        box-shadow: 0 0 0 2px var(--violet-7);
                    }

                    .Fieldset {
                        display: flex;
                        gap: 20px;
                        align-items: center;
                        margin-bottom: 15px;
                    }

                    .Label {
                        font-size: 15px;
                        color: var(--violet-11);
                        width: 90px;
                        text-align: right;
                    }

                    .Input {
                        width: 100%;
                        flex: 1;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        border-radius: 4px;
                        padding: 0 10px;
                        font-size: 15px;
                        line-height: 1;
                        color: var(--violet-11);
                        box-shadow: 0 0 0 1px var(--violet-7);
                        height: 35px;
                    }

                    .Input:focus {
                        box-shadow: 0 0 0 2px var(--violet-8);
                    }
                </style>
            `
        };
    }
} as Meta;

export const Default: StoryObj = {
    args: {
        backdropClass: 'cdk-overlay-dark-backdrop',
        mode: 'sheet-right',
        panelClasses: ['DialogSheet']
    }
};

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/stories/sheet/sheet.styles.scss
```
.DialogSheet {
    background-color: white;
    position: fixed !important;
    margin: auto;
    overflow: auto;
    display: flex;
    flex-direction: column;

    inset: 0 0 0 auto;
    width: 40rem;
    height: 100%;
    max-width: calc(100vw - 2rem);
    max-height: none;
    border-radius: 6px 0 0 6px;

    &:where(.mod-right) {
        animation: slideFromRight 250ms ease;
    }

    &:where(.mod-bottom) {
        inset: auto 0 0 0;
        width: 100%;
        height: fit-content;
        max-width: none;
        max-height: calc(100dvh - 2rem);
        border-radius: 6px 6px 0 0;

        animation: slideFromBottom 250ms ease;
    }

    @keyframes scaleIn {
        0% {
            transform: scale(0);
        }

        100% {
            transform: scale(1);
        }
    }

    @keyframes slideFromBottom {
        0% {
            transform: translateY(100%);
        }

        100% {
            transform: translateY(0);
        }
    }

    @keyframes slideFromRight {
        0% {
            transform: translateX(100%);
        }

        100% {
            transform: translateX(0);
        }
    }
}

.DialogSheetOverlay {
    background-color: var(--black-a9);
    position: fixed;
    inset: 0;
    opacity: 0.4;
    animation: overlayShow 150ms cubic-bezier(0.16, 1, 0.3, 1);
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/__tests__/dialog-content.directive.spec.ts
```typescript
import { Component, DebugElement } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { Subject } from 'rxjs';
import { RdxDialogContentDirective } from '../src/dialog-content.directive';
import { RdxDialogRef } from '../src/dialog-ref';

@Component({
    template: '<div rdxDialogContent>Dialog Content</div>',
    imports: [RdxDialogContentDirective]
})
class TestComponent {}

describe('RdxDialogContentDirective', () => {
    let fixture: ComponentFixture<TestComponent>;
    let directiveElement: DebugElement;
    let directive: RdxDialogContentDirective;
    let dialogRefMock: jest.Mocked<RdxDialogRef>;
    let closedSubject: Subject<any>;

    beforeEach(async () => {
        closedSubject = new Subject();
        dialogRefMock = {
            closed$: closedSubject.asObservable(),
            close: jest.fn(),
            dismiss: jest.fn()
        } as any;

        await TestBed.configureTestingModule({
            imports: [TestComponent],
            providers: [
                { provide: RdxDialogRef, useValue: dialogRefMock }]
        }).compileComponents();

        fixture = TestBed.createComponent(TestComponent);
        directiveElement = fixture.debugElement.query(By.directive(RdxDialogContentDirective));
        directive = directiveElement.injector.get(RdxDialogContentDirective);
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(directive).toBeTruthy();
    });

    it('should have correct initial state', () => {
        expect(directive['state']()).toBe('open');
    });

    it('should update state when dialog is closed', () => {
        closedSubject.next(undefined);
        fixture.detectChanges();
        expect(directive['state']()).toBe('closed');
    });

    it('should call dialogRef.dismiss when dismiss method is called', () => {
        directive.dismiss();
        expect(dialogRefMock.dismiss).toHaveBeenCalled();
    });

    it('should call dialogRef.dismiss when dismiss method is called', () => {
        directive.dismiss();
        expect(dialogRefMock.dismiss).toHaveBeenCalled();
    });

    it('should have correct host bindings', () => {
        const element = directiveElement.nativeElement;
        expect(element.getAttribute('role')).toBe('dialog');
        expect(element.getAttribute('aria-describedby')).toBe('true');
        expect(element.getAttribute('aria-labelledby')).toBe('true');
        expect(element.getAttribute('data-state')).toBe('open');

        closedSubject.next(undefined);
        fixture.detectChanges();

        expect(element.getAttribute('data-state')).toBe('closed');
    });
});

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/__tests__/dialog-trigger.directive.spec.ts
```typescript
import { Component, OnInit, TemplateRef, ViewChild } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { of } from 'rxjs';
import { RdxDialogRef } from '../src/dialog-ref';
import { RdxDialogTriggerDirective } from '../src/dialog-trigger.directive';
import { RdxDialogConfig } from '../src/dialog.config';
import { RdxDialogService } from '../src/dialog.service';

@Component({
    template: `
        <button [rdxDialogTrigger]="dialogTemplate" [rdxDialogConfig]="config">Open Dialog</button>
        <ng-template #dialogTemplate>Dialog Content</ng-template>
    `,
    imports: [RdxDialogTriggerDirective]
})
class TestHostComponent implements OnInit {
    @ViewChild('dialogTemplate') dialogTemplate: TemplateRef<any>;

    config: RdxDialogConfig<unknown>;

    ngOnInit() {
        this.config = {
            content: this.dialogTemplate,
            modal: true,
            ariaLabel: 'Test Dialog',
            autoFocus: 'first-tabbable',
            canClose: () => true,
            canCloseWithBackdrop: true,
            mode: 'default'
        };
    }
}

describe('RdxDialogTriggerDirective', () => {
    let fixture: ComponentFixture<TestHostComponent>;
    let directive: RdxDialogTriggerDirective;
    let dialogServiceMock: jest.Mocked<RdxDialogService>;
    let dialogRefMock: jest.Mocked<RdxDialogRef>;

    beforeEach(async () => {
        dialogRefMock = {
            closed$: of(undefined)
        } as any;

        dialogServiceMock = {
            open: jest.fn().mockReturnValue(dialogRefMock)
        } as any;

        await TestBed.configureTestingModule({
            imports: [TestHostComponent],
            providers: [
                { provide: RdxDialogService, useValue: dialogServiceMock }]
        }).compileComponents();

        fixture = TestBed.createComponent(TestHostComponent);
        fixture.detectChanges();

        const directiveEl = fixture.debugElement.query(By.directive(RdxDialogTriggerDirective));
        directive = directiveEl.injector.get(RdxDialogTriggerDirective);
    });

    it('should create', () => {
        expect(directive).toBeTruthy();
    });

    it('should have correct initial state', () => {
        expect(directive.isOpen()).toBe(false);
        expect(directive.state()).toBe('closed');
    });
});

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/src/dialog-close.directive.ts
```typescript
import { Directive, inject } from '@angular/core';
import { RdxDialogRef } from './dialog-ref';

@Directive({
    selector: '[rdxDialogClose]',
    standalone: true,
    host: {
        '(click)': 'onClick()'
    }
})
export class RdxDialogCloseDirective {
    private readonly ref = inject<RdxDialogRef>(RdxDialogRef);

    protected onClick(): void {
        this.ref.close();
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/src/dialog-content.directive.ts
```typescript
import { computed, DestroyRef, Directive, inject, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { RdxDialogRef } from './dialog-ref';
import { getState, RdxDialogResult } from './dialog.config';

@Directive({
    selector: '[rdxDialogContent]',
    standalone: true,
    host: {
        role: 'dialog',
        '[attr.aria-describedby]': '"true"',
        '[attr.aria-labelledby]': '"true"',
        '[attr.data-state]': 'state()'
    }
})
export class RdxDialogContentDirective<C = unknown> {
    private readonly dialogRef = inject<RdxDialogRef<C>>(RdxDialogRef);
    private readonly destroyRef = inject(DestroyRef);

    private readonly isOpen = signal(true);

    readonly state = computed(() => getState(this.isOpen()));

    constructor() {
        this.dialogRef.closed$.pipe(takeUntilDestroyed(this.destroyRef)).subscribe(() => {
            this.isOpen.set(false);
        });
    }

    /**
     * Closes the dialog with a specified result.
     *
     * @param result The result to be passed back when closing the dialog
     */
    close(result: RdxDialogResult<C>): void {
        this.dialogRef.close(result);
    }

    /**
     * Dismisses the dialog without a result.
     */
    dismiss(): void {
        this.dialogRef.dismiss();
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/src/dialog-description.directive.ts
```typescript
import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxDialogDescription]',
    standalone: true
})
export class RdxDialogDescriptionDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/src/dialog-dismiss.directive.ts
```typescript
import { Directive, inject } from '@angular/core';
import { RdxDialogRef } from './dialog-ref';

@Directive({
    selector: 'button[rdxDialogDismiss]',
    standalone: true,
    host: {
        type: 'button',
        '(click)': 'onClick()'
    }
})
export class RdxDialogDismissDirective {
    private readonly ref = inject<RdxDialogRef>(RdxDialogRef);

    protected onClick(): void {
        this.ref.dismiss();
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/src/dialog-ref.ts
```typescript
import { DialogRef } from '@angular/cdk/dialog';
import { filter, isObservable, map, Observable, of, take } from 'rxjs';
import { RdxDialogConfig, RdxDialogResult } from './dialog.config';

export const DISMISSED_VALUE = {} as const;

function isDismissed(v: unknown): v is typeof DISMISSED_VALUE {
    return v === DISMISSED_VALUE;
}

/**
 * Represents a reference to an open dialog.
 * Provides methods and observables to interact with and monitor the dialog's state.
 * @template C - The type of the dialog's content component
 */
export class RdxDialogRef<C = unknown> {
    closed$: Observable<RdxDialogResult<C> | undefined> = this.cdkRef.closed.pipe(
        map((res): RdxDialogResult<C> | undefined => (isDismissed(res) ? undefined : res))
    );

    dismissed$: Observable<void> = this.cdkRef.closed.pipe(
        filter((res) => res === DISMISSED_VALUE),
        map((): void => undefined)
    );

    result$: Observable<RdxDialogResult<C>> = this.cdkRef.closed.pipe(
        filter((res): res is RdxDialogResult<C> => !isDismissed(res))
    );

    /**
     * @param cdkRef - Reference to the underlying CDK dialog
     * @param config - Configuration options for the dialog
     */
    constructor(
        public readonly cdkRef: DialogRef<RdxDialogResult<C> | typeof DISMISSED_VALUE, C>,
        public readonly config: RdxDialogConfig<C>
    ) {}

    get instance(): C | null {
        return this.cdkRef.componentInstance;
    }

    /**
     * Attempts to dismiss the dialog
     * Checks the canClose condition before dismissing
     */
    dismiss(): void {
        if (!this.instance || this.config.isAlert) {
            return;
        }

        const canClose = this.config.canClose?.(this.instance) ?? true;
        const canClose$ = isObservable(canClose) ? canClose : of(canClose);
        canClose$.pipe(take(1)).subscribe((close) => {
            if (close) {
                this.cdkRef.close(DISMISSED_VALUE);
            }
        });
    }

    close(result: RdxDialogResult<C>): void {
        this.cdkRef.close(result);
    }
}

/**
 * Represents a simplified interface for dialog interaction
 * Typically used by dialog content components
 * @template R - The type of the result when closing the dialog
 */
export type RdxDialogSelfRef<R> = { dismiss(): void; close(res: R): void };

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/src/dialog-title.directive.ts
```typescript
import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxDialogTitle]',
    standalone: true
})
export class RdxDialogTitleDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/src/dialog-trigger.directive.ts
```typescript
import { computed, Directive, inject, Input, input, signal, TemplateRef } from '@angular/core';
import { RdxDialogRef } from './dialog-ref';
import { getState, RdxDialogConfig, RdxDialogState } from './dialog.config';
import { provideRdxDialog } from './dialog.providers';
import { RdxDialogService } from './dialog.service';

let nextId = 0;

/**
 * @group Components
 */
@Directive({
    selector: '[rdxDialogTrigger]',
    standalone: true,
    providers: [provideRdxDialog()],
    host: {
        type: 'button',
        '[attr.id]': 'id()',
        '[attr.aria-haspopup]': '"dialog"',
        '[attr.aria-expanded]': 'isOpen()',
        '[attr.aria-controls]': 'dialogId()',
        '[attr.data-state]': 'state()',
        '(click)': 'onClick()'
    }
})
export class RdxDialogTriggerDirective {
    private readonly dialogService = inject(RdxDialogService);

    /**
     * @group Props
     */
    readonly id = input(`rdx-dialog-trigger-${nextId++}`);
    readonly dialogId = computed(() => `rdx-dialog-${this.id()}`);

    /**
     * @group Props
     */
    @Input({ required: true, alias: 'rdxDialogTrigger' }) dialog: TemplateRef<void>;

    /**
     * @group Props
     */
    @Input({ alias: 'rdxDialogConfig' }) dialogConfig: RdxDialogConfig<unknown>;

    readonly isOpen = signal(false);
    readonly state = computed<RdxDialogState>(() => getState(this.isOpen()));

    private currentDialogRef: RdxDialogRef | null = null;

    protected onClick() {
        this.currentDialogRef = this.dialogService.open({
            ...this.dialogConfig,
            content: this.dialog
        });

        this.isOpen.set(true);

        this.currentDialogRef.closed$.subscribe(() => {
            this.isOpen.set(false);
            this.currentDialogRef = null;
        });
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/src/dialog.config.ts
```typescript
import { AutoFocusTarget, DialogConfig } from '@angular/cdk/dialog';
import { ComponentType } from '@angular/cdk/overlay';
import { TemplateRef } from '@angular/core';
import { Observable } from 'rxjs';

const ɵdialogData = Symbol.for('rdxDialogData');
const ɵdialogResult = Symbol.for('rdxDialogResult');

export type ɵDialogDataFlag = { [ɵdialogData]: unknown };
export type ɵDialogResultFlag<R> = { [ɵdialogResult]: R };

export type RdxDialogData<T> = {
    [K in keyof T]: T[K] extends ɵDialogDataFlag ? Omit<T[K], typeof ɵdialogData> : never;
}[keyof T];

type DialogRefProps<C> = { [K in keyof C]: C[K] extends ɵDialogResultFlag<unknown> ? K : never }[keyof C] & keyof C;
export type RdxDialogResult<C> =
    DialogRefProps<C> extends never ? void : C[DialogRefProps<C>] extends ɵDialogResultFlag<infer T> ? T : void;

type RdxDialogMode = 'default' | 'sheet' | 'sheet-bottom' | 'sheet-top' | 'sheet-left' | 'sheet-right';

type RdxBaseDialogConfig<C> = {
    content: ComponentType<C> | TemplateRef<C>;

    data: RdxDialogData<C>;

    modal?: boolean;

    ariaLabel?: string;

    autoFocus?: AutoFocusTarget | 'first-input' | string;

    canClose?: (comp: C) => boolean | Observable<boolean>;

    canCloseWithBackdrop?: boolean;

    cdkConfigOverride?: Partial<DialogConfig<C>>;

    mode?: RdxDialogMode;

    backdropClass?: string | string[];

    panelClasses?: string[];

    isAlert?: boolean;
};

export type RdxDialogConfig<T> =
    RdxDialogData<T> extends never
        ? Omit<RdxBaseDialogConfig<T>, 'data'>
        : RdxBaseDialogConfig<T> & { data: Required<RdxDialogData<T>> };

export type RdxDialogState = 'open' | 'closed';

export function getState(open: boolean): RdxDialogState {
    return open ? 'open' : 'closed';
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/src/dialog.injectors.ts
```typescript
import { DIALOG_DATA } from '@angular/cdk/dialog';
import { inject } from '@angular/core';
import { RdxDialogRef, RdxDialogSelfRef } from './dialog-ref';
import { ɵDialogDataFlag, ɵDialogResultFlag } from './dialog.config';

export function injectDialogData<TData>(): TData & ɵDialogDataFlag {
    return inject<TData & ɵDialogDataFlag>(DIALOG_DATA);
}

export function injectDialogRef<R = void>(): RdxDialogSelfRef<R> & ɵDialogResultFlag<R> {
    return inject<RdxDialogSelfRef<R>>(RdxDialogRef) as RdxDialogSelfRef<R> & ɵDialogResultFlag<R>;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/src/dialog.providers.ts
```typescript
import { DialogModule } from '@angular/cdk/dialog';
import { EnvironmentProviders, importProvidersFrom, makeEnvironmentProviders, Provider } from '@angular/core';
import { RdxDialogService } from './dialog.service';

/**
 * Configures the RdxDialog module by providing necessary dependencies.
 *
 * This function sets up the environment providers required for the RdxDialog to function,
 * specifically importing the Angular CDK's DialogModule.
 *
 * @returns {EnvironmentProviders} An EnvironmentProviders instance containing the DialogModule.
 */
export function provideRdxDialogConfig(): EnvironmentProviders {
    return makeEnvironmentProviders([importProvidersFrom(DialogModule)]);
}

/**
 * Provides the RdxDialogService for dependency injection.
 *
 * This function is used to make the RdxDialogService available for injection
 * in components, directives, or other services that require dialog functionality.
 *
 * @returns {Provider} A provider for the RdxDialogService.
 */
export function provideRdxDialog(): Provider {
    return RdxDialogService;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/dialog/src/dialog.service.ts
```typescript
import { Dialog } from '@angular/cdk/dialog';
import { inject, Injectable, Injector, Renderer2 } from '@angular/core';
import { filter, isObservable, merge, of, switchMap, take, takeUntil } from 'rxjs';
import { DISMISSED_VALUE, RdxDialogRef } from './dialog-ref';
import type { RdxDialogConfig, RdxDialogResult } from './dialog.config';

/**
 * Modality control: When `isModal` is set to `true`, the dialog will:
 *
 * - Have a backdrop that blocks interaction with the rest of the page
 * - Disable closing by clicking outside or pressing Escape
 * - Set `aria-modal="true"` for screen readers
 * - Automatically focus the first tabbable element in the dialog
 * - Restore focus to the element that opened the dialog when it's closed
 *
 *
 * When `isModal` is `false`, the dialog will:
 *
 * - Not have a backdrop, allowing interaction with the rest of the page
 * - Allow closing by clicking outside or pressing Escape
 * - Not set `aria-modal` attribute
 * - Not automatically manage focus
 */
@Injectable()
export class RdxDialogService {
    #cdkDialog = inject(Dialog);
    #injector = inject(Injector);

    open<C>(config: RdxDialogConfig<C>): RdxDialogRef<C> {
        let dialogRef: RdxDialogRef<C>;
        let modeClasses: string[] = [];

        switch (config.mode) {
            case 'sheet':
                modeClasses = ['mod-sheet', 'mod-right'];
                break;
            case 'sheet-right':
                modeClasses = ['mod-sheet', 'mod-right'];
                break;
            case 'sheet-bottom':
                modeClasses = ['mod-sheet', 'mod-bottom'];
                break;
            case 'sheet-left':
                modeClasses = ['mod-sheet', 'mod-left'];
                break;
            case 'sheet-top':
                modeClasses = ['mod-sheet', 'mod-top'];
                break;
        }

        const cdkRef = this.#cdkDialog.open<RdxDialogResult<C> | typeof DISMISSED_VALUE, unknown, C>(config.content, {
            ariaModal: config.modal ?? true,
            hasBackdrop: config.modal ?? true,
            data: 'data' in config ? config.data : null,
            restoreFocus: true,
            role: config.isAlert ? 'alertdialog' : 'dialog',
            disableClose: true,
            closeOnDestroy: true,
            injector: this.#injector,
            backdropClass: config.backdropClass ? config.backdropClass : 'cdk-overlay-dark-backdrop',
            panelClass: ['dialog', ...modeClasses, ...(config.panelClasses || [])],
            autoFocus: config.autoFocus === 'first-input' ? 'dialog' : (config.autoFocus ?? 'first-tabbable'),
            ariaLabel: config.ariaLabel,
            templateContext: () => ({ dialogRef: dialogRef }),
            providers: (ref) => {
                dialogRef = new RdxDialogRef(ref, config);
                return [
                    {
                        provide: RdxDialogRef,
                        useValue: dialogRef
                    }
                ];
            },
            // @FIXME
            ...(config.cdkConfigOverride || ({} as any))
        });

        if (cdkRef.componentRef) {
            cdkRef.componentRef.injector
                .get(Renderer2)
                .setStyle(cdkRef.componentRef.location.nativeElement, 'display', 'contents');
        }

        if (!config.isAlert) {
            merge(
                cdkRef.backdropClick,
                cdkRef.keydownEvents.pipe(filter((e) => e.key === 'Escape' && !e.defaultPrevented))
            )
                .pipe(
                    filter(() => config.canCloseWithBackdrop ?? true),
                    switchMap(() => {
                        const canClose =
                            (cdkRef.componentInstance && config.canClose?.(cdkRef.componentInstance)) ?? true;
                        const canClose$ = isObservable(canClose) ? canClose : of(canClose);
                        return canClose$.pipe(take(1));
                    }),

                    takeUntil(dialogRef!.closed$)
                )
                .subscribe((canClose) => {
                    if (canClose) {
                        cdkRef.close(DISMISSED_VALUE);
                    }
                });
        }

        return dialogRef!;
    }
}

```
