/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/utils/constants.ts
```typescript
export const containerAlert =
    'For the sake of option panels to play with the stories, the "onOverlayEscapeKeyDown" & "onOverlayOutsideClick" events are limited to the area inside the rectangle marked with a dashed line - the events work when the area is active (focused)';

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/utils/containers.registry.ts
```typescript
import { isDevMode } from '@angular/core';
import { RdxTooltipRootDirective } from '../../src/tooltip-root.directive';
import { injectRdxCdkEventService } from '../../src/utils/cdk-event.service';

const containerRegistry: Map<HTMLElement, RdxTooltipRootDirective> = new Map();
let rdxCdkEventService: ReturnType<typeof injectRdxCdkEventService> | undefined = void 0;

const domRootClickEventCallback: (event: MouseEvent) => void = (event: MouseEvent) => {
    const target = event.target as HTMLElement;
    const containers = Array.from(containerRegistry.keys());
    const containerContainingTarget = containers
        .map((container) => {
            container.classList.remove('focused');
            return container;
        })
        .find((container) => {
            return container.contains(target);
        });
    containerContainingTarget?.classList.add('focused');
    Array.from(containerRegistry.entries()).forEach((item) => {
        if (item[0] === containerContainingTarget) {
            rdxCdkEventService?.allowPrimitiveForCdkMultiEvents(item[1], [
                'cdkOverlayOutsideClick',
                'cdkOverlayEscapeKeyDown'
            ]);
        } else {
            rdxCdkEventService?.preventPrimitiveFromCdkMultiEvents(item[1], [
                'cdkOverlayOutsideClick',
                'cdkOverlayEscapeKeyDown'
            ]);
        }
    });
};

export function registerContainer(container: HTMLElement, root: RdxTooltipRootDirective) {
    if (containerRegistry.has(container)) {
        return;
    }
    containerRegistry.set(container, root);
    if (containerRegistry.size === 1) {
        rdxCdkEventService?.addClickDomRootEventCallback(domRootClickEventCallback);
    }
}

export function deregisterContainer(container: HTMLElement) {
    if (!containerRegistry.has(container)) {
        return;
    }
    containerRegistry.delete(container);
    if (containerRegistry.size === 0) {
        rdxCdkEventService?.removeClickDomRootEventCallback(domRootClickEventCallback);
        unsetRdxCdkEventService();
    }
}

export function setRdxCdkEventService(service: typeof rdxCdkEventService) {
    isDevMode() && console.log('setRdxCdkEventService', service, rdxCdkEventService === service);
    rdxCdkEventService ??= service;
}

export function unsetRdxCdkEventService() {
    rdxCdkEventService = void 0;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/utils/option-panel-base.class.ts
```typescript
import { afterNextRender, DestroyRef, Directive, ElementRef, inject, signal, viewChildren } from '@angular/core';
import { injectDocument, RDX_POSITIONING_DEFAULTS } from '@radix-ng/primitives/core';
import { RdxTooltipRootDirective } from '../../src/tooltip-root.directive';
import { injectRdxCdkEventService } from '../../src/utils/cdk-event.service';
import { deregisterContainer, registerContainer, setRdxCdkEventService } from './containers.registry';
import { IArrowDimensions, IIgnoreClickOutsideContainer, IOpenCloseDelay } from './types';

@Directive()
export abstract class OptionPanelBase implements IIgnoreClickOutsideContainer, IArrowDimensions, IOpenCloseDelay {
    onOverlayEscapeKeyDownDisabled = signal(false);
    onOverlayOutsideClickDisabled = signal(false);

    arrowWidth = signal(RDX_POSITIONING_DEFAULTS.arrow.width);
    arrowHeight = signal(RDX_POSITIONING_DEFAULTS.arrow.height);

    openDelay = signal(500);
    closeDelay = signal(200);

    readonly elementRef = inject<ElementRef<HTMLElement>>(ElementRef);
    readonly destroyRef = inject(DestroyRef);
    readonly rootDirectives = viewChildren(RdxTooltipRootDirective);
    readonly document = injectDocument();
    readonly rdxCdkEventService = injectRdxCdkEventService();

    protected constructor() {
        afterNextRender(() => {
            this.elementRef.nativeElement.querySelectorAll<HTMLElement>('.container').forEach((container) => {
                const rootInsideContainer = this.rootDirectives().find((rootDirective) =>
                    container.contains(rootDirective.triggerDirective().elementRef.nativeElement)
                );
                if (rootInsideContainer) {
                    setRdxCdkEventService(this.rdxCdkEventService);
                    registerContainer(container, rootInsideContainer);
                    this.destroyRef.onDestroy(() => deregisterContainer(container));
                }
            });
        });
    }
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/utils/styles.constants.ts
```typescript
const appliedAnimations = `
.TooltipContent[data-state='open'][data-side='top'] {
    animation-name: rdxSlideDownAndFade;
}

.TooltipContent[data-state='open'][data-side='right'] {
    animation-name: rdxSlideLeftAndFade;
}

.TooltipContent[data-state='open'][data-side='bottom'] {
    animation-name: rdxSlideUpAndFade;
}

.TooltipContent[data-state='open'][data-side='left'] {
    animation-name: rdxSlideRightAndFade;
}

.TooltipContent[data-state='closed'][data-side='top'] {
    animation-name: rdxSlideDownAndFadeReverse;
}

.TooltipContent[data-state='closed'][data-side='right'] {
    animation-name: rdxSlideLeftAndFadeReverse;
}

.TooltipContent[data-state='closed'][data-side='bottom'] {
    animation-name: rdxSlideUpAndFadeReverse;
}

.TooltipContent[data-state='closed'][data-side='left'] {
    animation-name: rdxSlideRightAndFadeReverse;
}
`;

const animationParams = `
.TooltipContent {
    animation-duration: 400ms;
    animation-timing-function: cubic-bezier(0.16, 1, 0.3, 1);
    will-change: transform, opacity;
}
`;

const animationDefs = `
/* Opening animations */

@keyframes rdxSlideUpAndFade {
    from {
        opacity: 0;
        transform: translateY(2px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes rdxSlideRightAndFade {
    from {
        opacity: 0;
        transform: translateX(-2px);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}

@keyframes rdxSlideDownAndFade {
    from {
        opacity: 0;
        transform: translateY(-2px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes rdxSlideLeftAndFade {
    from {
        opacity: 0;
        transform: translateX(2px);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}

/* Closing animations */

@keyframes rdxSlideUpAndFadeReverse {
    from {
        opacity: 1;
        transform: translateY(0);
    }
    to {
        opacity: 0;
        transform: translateY(2px);
    }
}

@keyframes rdxSlideRightAndFadeReverse {
    from {
        opacity: 1;
        transform: translateX(0);
    }
    to {
        opacity: 0;
        transform: translateX(-2px);
    }
}

@keyframes rdxSlideDownAndFadeReverse {
    from {
        opacity: 1;
        transform: translateY(0);
    }
    to {
        opacity: 0;
        transform: translateY(-2px);
    }
}

@keyframes rdxSlideLeftAndFadeReverse {
    from {
        opacity: 1;
        transform: translateX(0);
    }
    to {
        opacity: 0;
        transform: translateX(2px);
    }
}
`;

const events = `
/* =============== Event messages =============== */

.MessagesContainer {
    padding: 20px;
}

.Message {
    color: var(--white-a12);
    font-size: 15px;
    line-height: 19px;
    font-weight: bolder;
}

.MessageId {
    font-size: 75%;
    font-weight: light;
}
`;

const params = `
/* =============== Params layout =============== */

.ParamsContainer {
    display: flex;
    column-gap: 8px;
    color: var(--white-a12);
    padding-bottom: 32px;
}
`;

function styles(withAnimations = false, withEvents = false, withParams = true) {
    return `
.container {
    height: 150px;
    display: flex;
    justify-content: center;
    gap: 80px;
    align-items: center;
    border: 3px dashed var(--white-a8);
    border-radius: 12px;
    &.focused {
        border-color: var(--white-a12);
        -webkit-box-shadow: 0px 0px 24px 0px var(--white-a12);
        -moz-box-shadow: 0px 0px 24px 0px var(--white-a12);
        box-shadow: 0px 0px 24px 0px var(--white-a12);
    }
}

.ContainerAlerts {
    display: flex;
    gap: 6px;
    color: var(--white-a8);
    font-size: 16px;
    line-height: 16px;
    margin: 0 0 24px 0;
}

/* reset */
.reset {
    all: unset;
}

.ExampleSubtitle {
    color: var(--white-a12);
    font-size: 22px;
    line-height: 26px;
    font-weight: bolder;
    margin: 46px 0 34px 16px;
    padding-top: 22px;
    &:not(:first-child) {
        border-top: 2px solid var(--gray-a8);
    }
    &:first-child {
        margin-top: 0;
    }
}

.TooltipId {
    color: var(--white-a12);
    font-size: 12px;
    line-height: 14px;
    font-weight: 800;
    margin: 1px 0 24px 22px;
}

.TooltipContent {
    border-radius: 4px;
    padding: 10px 15px;
    font-size: 15px;
    line-height: 1;
    background-color: white;
    box-shadow:
        hsl(206 22% 7% / 35%) 0px 10px 38px -10px,
        hsl(206 22% 7% / 20%) 0px 10px 20px -15px;
}

${withAnimations ? animationParams : ''}

${withAnimations ? appliedAnimations : ''}

.TooltipContent:focus {
    box-shadow:
        hsl(206 22% 7% / 35%) 0px 10px 38px -10px,
        hsl(206 22% 7% / 20%) 0px 10px 20px -15px,
        0 0 0 2px var(--violet-7);
}

.TooltipArrow {
    fill: white;
}

.TooltipClose {
    font-family: inherit;
    border-radius: 100%;
    background-color: var(--white-a12);
    height: 14px;
    width: 14px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    color: var(--violet-11);
    position: absolute;
    top: -12px;
    right: -12px;
}

.TooltipClose:hover {
    background-color: var(--violet-4);
}

.TooltipClose:focus {
    box-shadow: 0 0 0 2px var(--violet-7);
}

.IconButton {
    font-family: inherit;
    border-radius: 100%;
    height: 35px;
    width: 35px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    color: var(--violet-11);
    background-color: white;
    box-shadow: 0 2px 10px var(--black-a7);
}

.IconButton:hover {
    background-color: var(--violet-3);
}

.IconButton:focus {
    box-shadow: 0 0 0 2px black;
}

.Fieldset {
    display: flex;
    gap: 20px;
    align-items: center;
}

.Label {
    font-size: 13px;
    color: var(--violet-11);
    width: 75px;
}

.Input {
    width: 100%;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    flex: 1;
    border-radius: 4px;
    padding: 0 10px;
    font-size: 13px;
    line-height: 1;
    color: var(--violet-11);
    box-shadow: 0 0 0 1px var(--violet-7);
    height: 25px;
}

.Input:focus {
    box-shadow: 0 0 0 2px var(--violet-8);
}

.Text {
    margin: 0;
    color: var(--mauve-12);
    font-size: 15px;
    line-height: 19px;
    font-weight: 500;
}

${withAnimations ? animationDefs : ''}

${withParams ? params : ''}

${withEvents ? events : ''}
`;
}

export const animationStylesOnly = `
${animationParams}

${appliedAnimations}

${animationDefs}
`;

export const paramsAndEventsOnly = `
${params}

${events}
`;

export default styles;

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/utils/types.ts
```typescript
import { DestroyRef, ElementRef, Signal } from '@angular/core';
import { RdxTooltipRootDirective } from '../../src/tooltip-root.directive';
import { injectRdxCdkEventService } from '../../src/utils/cdk-event.service';

export interface IIgnoreClickOutsideContainer {
    onOverlayEscapeKeyDownDisabled: Signal<boolean>;
    onOverlayOutsideClickDisabled: Signal<boolean>;
    elementRef: ElementRef<Element>;
    destroyRef: DestroyRef;
    rootDirectives: Signal<ReadonlyArray<RdxTooltipRootDirective>>;
    document: Document;
    rdxCdkEventService: ReturnType<typeof injectRdxCdkEventService>;
}

export interface IArrowDimensions {
    arrowWidth: Signal<number | undefined>;
    arrowHeight: Signal<number | undefined>;
}

export interface IOpenCloseDelay {
    openDelay: Signal<number | undefined>;
    closeDelay: Signal<number | undefined>;
}

export type Message = { value: string; timeFromPrev: number };

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/utils/with-option-panel.component.ts
```typescript
import { NgTemplateOutlet } from '@angular/common';
import {
    afterNextRender,
    Component,
    computed,
    contentChild,
    ElementRef,
    inject,
    isDevMode,
    model,
    signal
} from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RdxTooltipRootDirective } from '../../src/tooltip-root.directive';
import { paramsAndEventsOnly } from './styles.constants';
import { Message } from './types';

@Component({
    selector: 'tooltip-with-option-panel',
    styles: paramsAndEventsOnly,
    template: `
        <ng-content select=".ParamsContainer" />

        @if (paramsContainerCounter() > 3) {
            <hr />
        }

        <div class="ParamsContainer">
            <input
                [ngModel]="onOverlayEscapeKeyDownDisabled()"
                (ngModelChange)="onOverlayEscapeKeyDownDisabled.set($event)"
                type="checkbox"
            />
            Disable (onOverlayEscapeKeyDown) event
            <input
                [ngModel]="onOverlayOutsideClickDisabled()"
                (ngModelChange)="onOverlayOutsideClickDisabled.set($event)"
                type="checkbox"
            />
            Disable (onOverlayOutsideClick) event
        </div>

        <div class="ParamsContainer">
            Arrow width
            <input [ngModel]="arrowWidth()" (ngModelChange)="arrowWidth.set($event)" type="number" />
            Arrow height
            <input [ngModel]="arrowHeight()" (ngModelChange)="arrowHeight.set($event)" type="number" />
        </div>

        <div class="ParamsContainer">
            Open delay
            <input [ngModel]="openDelay()" (ngModelChange)="openDelay.set($event)" type="number" />
            Close delay
            <input [ngModel]="closeDelay()" (ngModelChange)="closeDelay.set($event)" type="number" />
        </div>

        <ng-content />

        @if (messages().length) {
            <button class="SkipOutsideClickPrevention" (click)="messages.set([])" type="button">Clear messages</button>
            <div class="MessagesContainer">
                @for (message of messages(); track i; let i = $index) {
                    <ng-container
                        [ngTemplateOutlet]="messageTpl"
                        [ngTemplateOutletContext]="{ message: message, index: messages().length - i }"
                    />
                }
            </div>
        }

        <ng-template #messageTpl let-message="message" let-index="index">
            <p class="Message">
                {{ index }}.
                <span class="MessageId">[({{ message.timeFromPrev }}ms) TOOLTIP ID {{ rootUniqueId() }}]</span>
                {{ message.value }}
            </p>
        </ng-template>
    `,
    imports: [
        ReactiveFormsModule,
        FormsModule,
        NgTemplateOutlet
    ]
})
export class WithOptionPanelComponent {
    onOverlayEscapeKeyDownDisabled = model(false);
    onOverlayOutsideClickDisabled = model(false);

    arrowWidth = model<number>(0);
    arrowHeight = model<number>(0);

    openDelay = model<number>(0);
    closeDelay = model<number>(0);

    readonly elementRef = inject<ElementRef<HTMLElement>>(ElementRef);

    readonly rootDirective = contentChild.required(RdxTooltipRootDirective);

    readonly paramsContainerCounter = signal(0);

    readonly messages = signal<Message[]>([]);
    readonly rootUniqueId = computed(() => this.rootDirective().uniqueId());

    /**
     * There should be only one container. If there is more, en error is thrown.
     */
    containers: Element[] | undefined = void 0;
    paramsContainers: Element[] | undefined = void 0;

    previousMessageTimestamp: number | undefined = void 0;

    timeFromPrev = () => {
        const now = Date.now();
        const timeFromPrev =
            typeof this.previousMessageTimestamp === 'undefined' ? 0 : Date.now() - this.previousMessageTimestamp;
        this.previousMessageTimestamp = now;
        return timeFromPrev;
    };

    constructor() {
        afterNextRender({
            read: () => {
                this.rootDirective().contentDirective().onOpen.subscribe(this.onOpen);
                this.rootDirective().contentDirective().onClosed.subscribe(this.onClose);
                this.rootDirective().contentDirective().onOverlayOutsideClick.subscribe(this.onOverlayOutsideClick);
                this.rootDirective().contentDirective().onOverlayEscapeKeyDown.subscribe(this.onOverlayEscapeKeyDown);

                /**
                 * There should be only one container. If there is more, en error is thrown.
                 */
                this.containers = Array.from(this.elementRef.nativeElement?.querySelectorAll('.container') ?? []);
                if (this.containers.length > 1) {
                    if (isDevMode()) {
                        console.error('<story>.elementRef.nativeElement', this.elementRef.nativeElement);
                        console.error('<story>.containers', this.containers);
                        throw Error('each story should have only one container!');
                    }
                }
                this.paramsContainers = Array.from(
                    this.elementRef.nativeElement?.querySelectorAll('.ParamsContainer') ?? []
                );

                this.paramsContainerCounter.set(this.paramsContainers.length ?? 0);
            }
        });
    }

    private inContainers(element: Element) {
        return !!this.containers?.find((container) => container.contains(element));
    }

    private inParamsContainers(element: Element) {
        return !!this.paramsContainers?.find((container) => container.contains(element));
    }

    private onOverlayEscapeKeyDown = () => {
        this.addMessage({
            value: `[TooltipRoot] Escape clicked! (disabled: ${this.onOverlayEscapeKeyDownDisabled()})`,
            timeFromPrev: this.timeFromPrev()
        });
    };

    private onOverlayOutsideClick = () => {
        this.addMessage({
            value: `[TooltipRoot] Mouse clicked outside the tooltip! (disabled: ${this.onOverlayOutsideClickDisabled()})`,
            timeFromPrev: this.timeFromPrev()
        });
    };

    private onOpen = () => {
        this.addMessage({ value: '[TooltipContent] Open', timeFromPrev: this.timeFromPrev() });
    };

    private onClose = () => {
        this.addMessage({ value: '[TooltipContent] Closed', timeFromPrev: this.timeFromPrev() });
    };

    protected addMessage = (message: Message) => {
        this.messages.update((messages) => {
            return [
                message,
                ...messages
            ];
        });
    };
}

```
