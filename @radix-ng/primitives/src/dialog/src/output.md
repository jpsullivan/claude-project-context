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
