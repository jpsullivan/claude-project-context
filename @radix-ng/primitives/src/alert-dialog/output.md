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
