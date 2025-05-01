/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/alert-dialog/README.md
```
# @radix-ng/primitives/alert-dialog

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/alert-dialog/index.ts
```typescript
import { NgModule } from '@angular/core';
import { RdxAlertDialogCancelDirective } from './src/alert-dialog-cancel.directive';
import { RdxAlertDialogContentDirective } from './src/alert-dialog-content.directive';
import { RdxAlertDialogRootDirective } from './src/alert-dialog-root.directive';
import { RdxAlertDialogTitleDirective } from './src/alert-dialog-title.directive';
import { RdxAlertDialogTriggerDirective } from './src/alert-dialog-trigger.directive';

export * from './src/alert-dialog-cancel.directive';
export * from './src/alert-dialog-content.directive';
export * from './src/alert-dialog-root.directive';
export * from './src/alert-dialog-title.directive';
export * from './src/alert-dialog-trigger.directive';

export * from './src/alert-dialog.service';

const _imports = [
    RdxAlertDialogRootDirective,
    RdxAlertDialogContentDirective,
    RdxAlertDialogCancelDirective,
    RdxAlertDialogTriggerDirective,
    RdxAlertDialogTitleDirective
];

@NgModule({
    imports: [..._imports],
    exports: [..._imports]
})
export class RdxAlertDialogModule {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/alert-dialog/ng-package.json
```json
{
    "lib": {
        "entryFile": "index.ts"
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/alert-dialog/stories/alert-dialog.stories.ts
```typescript
import { OverlayModule } from '@angular/cdk/overlay';
import { PortalModule } from '@angular/cdk/portal';
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { RdxAlertDialogCancelDirective } from '../src/alert-dialog-cancel.directive';
import { RdxAlertDialogContentDirective } from '../src/alert-dialog-content.directive';
import { RdxAlertDialogRootDirective } from '../src/alert-dialog-root.directive';
import { RdxAlertDialogTitleDirective } from '../src/alert-dialog-title.directive';
import { RdxAlertDialogTriggerDirective } from '../src/alert-dialog-trigger.directive';
import { RdxAlertDialogService } from '../src/alert-dialog.service';

export default {
    title: 'Primitives/Alert Dialog',
    decorators: [
        moduleMetadata({
            imports: [
                RdxAlertDialogContentDirective,
                RdxAlertDialogRootDirective,
                RdxAlertDialogTitleDirective,
                RdxAlertDialogTriggerDirective,
                RdxAlertDialogCancelDirective,
                OverlayModule,
                PortalModule
            ],
            providers: [RdxAlertDialogService]
        }),
        componentWrapperDecorator(
            (story) =>
                `
                    <div class="radix-themes light light-theme"
                      data-radius="medium"
                      data-scaling="100%">${story}</div>`
        )
    ]
} as Meta;

type Story = StoryObj;

export const Default: Story = {
    render: (args) => ({
        props: args,
        template: `

<div rdxAlertDialogRoot [content]="alertDialogContent">
    <button rdxAlertDialogTrigger class="Button violet">Delete account</button>
    <ng-template #alertDialogContent>
        <div rdxAlertDialogContent maxWidth="450" class="AlertDialogContent">
            <h2 rdxAlertDialogTitle class="AlertDialogTitle">Are you absolutely sure?</h2>
            <p class="AlertDialogDescription">
               This action cannot be undone. This will permanently delete your account and remove your data from our servers.
            </p>
            <div style="display: flex; gap: 3px; margin-top: 4px; justify-content: flex-end;">
                <button rdxAlertDialogCancel class="Button mauve">Cancel</button>
                <button class="Button red">Revoke access</button>
            </div>
        </div>
    </ng-template>
</div>

<style>

.AlertDialogContent {
  background-color: white;
  border-radius: 6px;
  box-shadow: hsl(206 22% 7% / 35%) 0px 10px 38px -10px, hsl(206 22% 7% / 20%) 0px 10px 20px -15px;
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 90vw;
  max-width: 500px;
  max-height: 85vh;
  padding: 25px;
  animation: contentShow 150ms cubic-bezier(0.16, 1, 0.3, 1);
}

.AlertDialogTitle {
  margin: 0;
  color: var(--mauve-12);
  font-size: 17px;
  font-weight: 500;
}

.AlertDialogDescription {
  margin-bottom: 20px;
  color: var(--mauve-11);
  font-size: 15px;
  line-height: 1.5;
}

button {
  all: unset;
}
Button {
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
.Button.red {
  background-color: var(--red-4);
  color: var(--red-11);
}
.Button.red:hover {
  background-color: var(--red-5);
}
.Button.red:focus {
  box-shadow: 0 0 0 2px var(--red-7);
}
.Button.mauve {
  background-color: var(--mauve-4);
  color: var(--mauve-11);
}
.Button.mauve:hover {
  background-color: var(--mauve-5);
}
.Button.mauve:focus {
  box-shadow: 0 0 0 2px var(--mauve-7);
}
</style>

`
    })
};

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/alert-dialog/src/alert-dialog-cancel.directive.ts
```typescript
import { Directive, inject } from '@angular/core';
import { RdxAlertDialogService } from './alert-dialog.service';

@Directive({
    selector: '[rdxAlertDialogCancel]',
    standalone: true,
    host: {
        '(click)': 'onClick()'
    }
})
export class RdxAlertDialogCancelDirective {
    private readonly alertDialogService = inject(RdxAlertDialogService);

    onClick() {
        this.alertDialogService.close();
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/alert-dialog/src/alert-dialog-content.directive.ts
```typescript
import { CdkTrapFocus } from '@angular/cdk/a11y';
import { Directive, ElementRef, inject, Input, Renderer2 } from '@angular/core';

@Directive({
    selector: '[rdxAlertDialogContent]',
    standalone: true,
    hostDirectives: [
        {
            directive: CdkTrapFocus
        }
    ],
    host: {
        '[attr.data-state]': '"open"',
        '[attr.cdkTrapFocusAutoCapture]': 'true'
    }
})
export class RdxAlertDialogContentDirective {
    private readonly renderer = inject(Renderer2);
    private readonly elementRef = inject(ElementRef);

    @Input() set maxWidth(value: string) {
        this.renderer.setStyle(this.elementRef.nativeElement, 'maxWidth', value);
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/alert-dialog/src/alert-dialog-root.directive.ts
```typescript
import { Directive, inject, Input, TemplateRef, ViewContainerRef } from '@angular/core';
import { RdxAlertDialogService } from './alert-dialog.service';

@Directive({
    selector: '[rdxAlertDialogRoot]',
    standalone: true
})
export class RdxAlertDialogRootDirective {
    private readonly viewContainerRef = inject(ViewContainerRef);
    private readonly alertDialogService = inject(RdxAlertDialogService);

    @Input() set content(template: TemplateRef<any>) {
        this.alertDialogService.setDialogContent(this.viewContainerRef, template);
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/alert-dialog/src/alert-dialog-title.directive.ts
```typescript
import { Directive } from '@angular/core';

@Directive({
    selector: '[rdxAlertDialogTitle]',
    standalone: true
})
export class RdxAlertDialogTitleDirective {}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/alert-dialog/src/alert-dialog-trigger.directive.ts
```typescript
import { Directive, inject } from '@angular/core';
import { RdxAlertDialogService } from './alert-dialog.service';

@Directive({
    selector: '[rdxAlertDialogTrigger]',
    standalone: true,
    host: {
        '(click)': 'handleClick()'
    }
})
export class RdxAlertDialogTriggerDirective {
    private readonly alertDialogService = inject(RdxAlertDialogService);

    handleClick() {
        this.alertDialogService.open();
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/alert-dialog/src/alert-dialog.service.ts
```typescript
import { Overlay, OverlayRef } from '@angular/cdk/overlay';
import { TemplatePortal } from '@angular/cdk/portal';
import { Injectable, TemplateRef, ViewContainerRef } from '@angular/core';

@Injectable({
    providedIn: 'root'
})
export class RdxAlertDialogService {
    private overlayRef: OverlayRef | null | undefined;
    private dialogContent:
        | {
              viewContainerRef: ViewContainerRef;
              template: TemplateRef<any>;
          }
        | undefined;

    constructor(private overlay: Overlay) {}

    setDialogContent(viewContainerRef: ViewContainerRef, template: TemplateRef<any>) {
        this.dialogContent = { viewContainerRef, template };
    }

    open() {
        if (!this.dialogContent) {
            throw new Error('Dialog content is not set');
        }

        this.overlayRef = this.overlay.create({
            hasBackdrop: true,
            backdropClass: 'cdk-overlay-dark-backdrop',
            positionStrategy: this.overlay.position().global().centerHorizontally().centerVertically()
        });

        const templatePortal = new TemplatePortal(this.dialogContent.template, this.dialogContent.viewContainerRef);
        this.overlayRef.attach(templatePortal);

        this.overlayRef.keydownEvents().subscribe((event) => {
            if (event.key === 'Escape' || event.code === 'Escape') {
                this.close();
            }
        });
        this.overlayRef.backdropClick().subscribe(() => this.close());
    }

    close() {
        if (this.overlayRef) {
            this.overlayRef.dispose();
            this.overlayRef = null;
        }
    }
}

```
