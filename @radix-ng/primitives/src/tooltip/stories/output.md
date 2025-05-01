/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/tooltip-anchor.component.ts
```typescript
import { Component, viewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { LucideAngularModule, MapPin, MapPinPlus, MountainSnow, TriangleAlert, X } from 'lucide-angular';
import { RdxTooltipModule } from '../index';
import { RdxTooltipAnchorDirective } from '../src/tooltip-anchor.directive';
import { RdxTooltipContentAttributesComponent } from '../src/tooltip-content-attributes.component';
import { provideRdxCdkEventService } from '../src/utils/cdk-event.service';
import { containerAlert } from './utils/constants';
import { OptionPanelBase } from './utils/option-panel-base.class';
import styles from './utils/styles.constants';
import { WithOptionPanelComponent } from './utils/with-option-panel.component';

@Component({
    selector: 'rdx-tooltip-anchor',
    providers: [provideRdxCdkEventService()],
    imports: [
        FormsModule,
        RdxTooltipModule,
        LucideAngularModule,
        RdxTooltipContentAttributesComponent,
        WithOptionPanelComponent,
        RdxTooltipAnchorDirective
    ],
    styles: styles(),
    template: `
        <p class="ExampleSubtitle">Internal Anchor (within TooltipRoot)</p>
        <tooltip-with-option-panel
            [arrowWidth]="arrowWidth()"
            [arrowHeight]="arrowHeight()"
            [openDelay]="openDelay()"
            [closeDelay]="closeDelay()"
            (onOverlayEscapeKeyDownDisabledChange)="onOverlayEscapeKeyDownDisabled.set($event)"
            (onOverlayOutsideClickDisabledChange)="onOverlayOutsideClickDisabled.set($event)"
            (arrowWidthChange)="arrowWidth.set($event)"
            (arrowHeightChange)="arrowHeight.set($event)"
            (openDelayChange)="openDelay.set($event)"
            (closeDelayChange)="closeDelay.set($event)"
        >
            <div class="ContainerAlerts">
                <lucide-angular [img]="TriangleAlert" size="16" />
                {{ containerAlert }}
            </div>
            <div class="container">
                <ng-container
                    #root1="rdxTooltipRoot"
                    [openDelay]="openDelay()"
                    [closeDelay]="closeDelay()"
                    rdxTooltipRoot
                >
                    <button class="reset IconButton InternalAnchor" rdxTooltipAnchor>
                        <lucide-angular [img]="LucideMapPinPlusInside" size="16" style="display: flex" />
                    </button>

                    <button class="reset IconButton" rdxTooltipTrigger>
                        <lucide-angular [img]="MountainSnowIcon" size="16" style="display: flex" />
                    </button>

                    <ng-template
                        [onOverlayEscapeKeyDownDisabled]="onOverlayEscapeKeyDownDisabled()"
                        [onOverlayOutsideClickDisabled]="onOverlayOutsideClickDisabled()"
                        rdxTooltipContent
                    >
                        <div class="TooltipContent" rdxTooltipContentAttributes>
                            <button class="reset TooltipClose" rdxTooltipClose aria-label="Close">
                                <lucide-angular [img]="XIcon" size="12" style="display: flex" />
                            </button>
                            Add to library
                            <div
                                class="TooltipArrow"
                                [width]="arrowWidth()"
                                [height]="arrowHeight()"
                                rdxTooltipArrow
                            ></div>
                        </div>
                    </ng-template>
                </ng-container>
            </div>
            <div class="TooltipId">ID: {{ rootDirective1()?.uniqueId() }}</div>
        </tooltip-with-option-panel>

        <p class="ExampleSubtitle">External Anchor (outside TooltipRoot)</p>
        <tooltip-with-option-panel
            [arrowWidth]="arrowWidth()"
            [arrowHeight]="arrowHeight()"
            [openDelay]="openDelay()"
            [closeDelay]="closeDelay()"
            (onOverlayEscapeKeyDownDisabledChange)="onOverlayEscapeKeyDownDisabled.set($event)"
            (onOverlayOutsideClickDisabledChange)="onOverlayOutsideClickDisabled.set($event)"
            (arrowWidthChange)="arrowWidth.set($event)"
            (arrowHeightChange)="arrowHeight.set($event)"
            (openDelayChange)="openDelay.set($event)"
            (closeDelayChange)="closeDelay.set($event)"
        >
            <div class="ContainerAlerts">
                <lucide-angular [img]="TriangleAlert" size="16" />
                {{ containerAlert }}
            </div>
            <div class="container">
                <button class="reset IconButton ExternalAnchor" #externalAnchor="rdxTooltipAnchor" rdxTooltipAnchor>
                    <lucide-angular [img]="LucideMapPinPlus" size="16" style="display: flex" />
                </button>

                <ng-container
                    #root2="rdxTooltipRoot"
                    [anchor]="externalAnchor"
                    [openDelay]="openDelay()"
                    [closeDelay]="closeDelay()"
                    rdxTooltipRoot
                >
                    <button class="reset IconButton" rdxTooltipTrigger>
                        <lucide-angular [img]="MountainSnowIcon" size="16" style="display: flex" />
                    </button>

                    <ng-template
                        [onOverlayEscapeKeyDownDisabled]="onOverlayEscapeKeyDownDisabled()"
                        [onOverlayOutsideClickDisabled]="onOverlayOutsideClickDisabled()"
                        rdxTooltipContent
                    >
                        <div class="TooltipContent" rdxTooltipContentAttributes>
                            <button class="reset TooltipClose" rdxTooltipClose aria-label="Close">
                                <lucide-angular [img]="XIcon" size="12" style="display: flex" />
                            </button>
                            Add to library
                            <div
                                class="TooltipArrow"
                                [width]="arrowWidth()"
                                [height]="arrowHeight()"
                                rdxTooltipArrow
                            ></div>
                        </div>
                    </ng-template>
                </ng-container>
            </div>
            <div class="TooltipId">ID: {{ rootDirective2()?.uniqueId() }}</div>
        </tooltip-with-option-panel>
    `
})
export class RdxTooltipAnchorComponent extends OptionPanelBase {
    readonly rootDirective1 = viewChild('root1');
    readonly rootDirective2 = viewChild('root2');

    readonly MountainSnowIcon = MountainSnow;
    readonly XIcon = X;
    readonly LucideMapPinPlusInside = MapPinPlus;
    readonly LucideMapPinPlus = MapPin;
    readonly TriangleAlert = TriangleAlert;
    readonly containerAlert = containerAlert;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/tooltip-animations.component.ts
```typescript
import { Component, signal, viewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RdxPositionAlign, RdxPositionSide } from '@radix-ng/primitives/core';
import { LucideAngularModule, MountainSnow, TriangleAlert, X } from 'lucide-angular';
import { RdxTooltipModule, RdxTooltipRootDirective } from '../index';
import { RdxTooltipContentAttributesComponent } from '../src/tooltip-content-attributes.component';
import { provideRdxCdkEventService } from '../src/utils/cdk-event.service';
import { containerAlert } from './utils/constants';
import { OptionPanelBase } from './utils/option-panel-base.class';
import styles from './utils/styles.constants';
import { WithOptionPanelComponent } from './utils/with-option-panel.component';

@Component({
    selector: 'rdx-tooltip-animations',
    providers: [provideRdxCdkEventService()],
    imports: [
        FormsModule,
        RdxTooltipModule,
        LucideAngularModule,
        RdxTooltipContentAttributesComponent,
        WithOptionPanelComponent
    ],
    styles: styles(true),
    template: `
        <tooltip-with-option-panel
            [arrowWidth]="arrowWidth()"
            [arrowHeight]="arrowHeight()"
            [openDelay]="openDelay()"
            [closeDelay]="closeDelay()"
            (onOverlayEscapeKeyDownDisabledChange)="onOverlayEscapeKeyDownDisabled.set($event)"
            (onOverlayOutsideClickDisabledChange)="onOverlayOutsideClickDisabled.set($event)"
            (arrowWidthChange)="arrowWidth.set($event)"
            (arrowHeightChange)="arrowHeight.set($event)"
            (openDelayChange)="openDelay.set($event)"
            (closeDelayChange)="closeDelay.set($event)"
        >
            <div class="ParamsContainer">
                <input [ngModel]="cssAnimation()" (ngModelChange)="cssAnimation.set($event)" type="checkbox" />
                CSS Animation
                <input
                    [ngModel]="cssOpeningAnimation()"
                    (ngModelChange)="cssOpeningAnimation.set($event)"
                    type="checkbox"
                />
                On Opening Animation
                <input
                    [ngModel]="cssClosingAnimation()"
                    (ngModelChange)="cssClosingAnimation.set($event)"
                    type="checkbox"
                />
                On Closing Animation
            </div>

            <div class="ContainerAlerts">
                <lucide-angular [img]="TriangleAlert" size="16" />
                {{ containerAlert }}
            </div>
            <div class="container">
                <ng-container
                    [cssAnimation]="cssAnimation()"
                    [cssOpeningAnimation]="cssOpeningAnimation()"
                    [cssClosingAnimation]="cssClosingAnimation()"
                    [openDelay]="openDelay()"
                    [closeDelay]="closeDelay()"
                    rdxTooltipRoot
                >
                    <button class="IconButton reset" rdxTooltipTrigger>
                        <lucide-angular [img]="MountainSnowIcon" size="16" style="display: flex" />
                    </button>

                    <ng-template
                        [onOverlayEscapeKeyDownDisabled]="onOverlayEscapeKeyDownDisabled()"
                        [onOverlayOutsideClickDisabled]="onOverlayOutsideClickDisabled()"
                        rdxTooltipContent
                    >
                        <div class="TooltipContent" rdxTooltipContentAttributes>
                            <button class="TooltipClose reset" rdxTooltipClose aria-label="Close">
                                <lucide-angular [img]="XIcon" size="16" style="display: flex" />
                            </button>
                            Add to library
                            <div
                                class="TooltipArrow"
                                [width]="arrowWidth()"
                                [height]="arrowHeight()"
                                rdxTooltipArrow
                            ></div>
                        </div>
                    </ng-template>
                </ng-container>
            </div>
            <div class="TooltipId">ID: {{ rootDirective()?.uniqueId() }}</div>
        </tooltip-with-option-panel>
    `
})
export class RdxTooltipAnimationsComponent extends OptionPanelBase {
    readonly rootDirective = viewChild(RdxTooltipRootDirective);

    readonly MountainSnowIcon = MountainSnow;
    readonly XIcon = X;

    readonly sides = RdxPositionSide;
    readonly aligns = RdxPositionAlign;

    cssAnimation = signal<boolean>(true);
    cssOpeningAnimation = signal(true);
    cssClosingAnimation = signal(true);
    protected readonly TriangleAlert = TriangleAlert;
    protected readonly containerAlert = containerAlert;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/tooltip-default.component.ts
```typescript
import { Component, viewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { LucideAngularModule, MountainSnow, TriangleAlert, X } from 'lucide-angular';
import { RdxTooltipModule, RdxTooltipRootDirective } from '../index';
import { RdxTooltipContentAttributesComponent } from '../src/tooltip-content-attributes.component';
import { provideRdxCdkEventService } from '../src/utils/cdk-event.service';
import { containerAlert } from './utils/constants';
import { OptionPanelBase } from './utils/option-panel-base.class';
import styles from './utils/styles.constants';
import { WithOptionPanelComponent } from './utils/with-option-panel.component';

@Component({
    selector: 'rdx-tooltip-default',
    providers: [provideRdxCdkEventService()],
    imports: [
        FormsModule,
        RdxTooltipModule,
        LucideAngularModule,
        RdxTooltipContentAttributesComponent,
        WithOptionPanelComponent
    ],
    styles: styles(),
    template: `
        <tooltip-with-option-panel
            [arrowWidth]="arrowWidth()"
            [arrowHeight]="arrowHeight()"
            [openDelay]="openDelay()"
            [closeDelay]="closeDelay()"
            (onOverlayEscapeKeyDownDisabledChange)="onOverlayEscapeKeyDownDisabled.set($event)"
            (onOverlayOutsideClickDisabledChange)="onOverlayOutsideClickDisabled.set($event)"
            (arrowWidthChange)="arrowWidth.set($event)"
            (arrowHeightChange)="arrowHeight.set($event)"
            (openDelayChange)="openDelay.set($event)"
            (closeDelayChange)="closeDelay.set($event)"
        >
            <div class="ContainerAlerts">
                <lucide-angular [img]="TriangleAlert" size="16" />
                {{ containerAlert }}
            </div>
            <div class="container">
                <ng-container [openDelay]="openDelay()" [closeDelay]="closeDelay()" rdxTooltipRoot>
                    <button class="reset IconButton" rdxTooltipTrigger>
                        <lucide-angular [img]="MountainSnowIcon" size="16" style="display: flex" />
                    </button>

                    <ng-template
                        [onOverlayEscapeKeyDownDisabled]="onOverlayEscapeKeyDownDisabled()"
                        [onOverlayOutsideClickDisabled]="onOverlayOutsideClickDisabled()"
                        rdxTooltipContent
                    >
                        <div class="TooltipContent" rdxTooltipContentAttributes>
                            <button class="reset TooltipClose" rdxTooltipClose aria-label="Close">
                                <lucide-angular [img]="XIcon" size="12" style="display: flex" />
                            </button>
                            Add to library
                            <div
                                class="TooltipArrow"
                                [width]="arrowWidth()"
                                [height]="arrowHeight()"
                                rdxTooltipArrow
                            ></div>
                        </div>
                    </ng-template>
                </ng-container>
            </div>
            <div class="TooltipId">ID: {{ rootDirective()?.uniqueId() }}</div>
        </tooltip-with-option-panel>
    `
})
export class RdxTooltipDefaultComponent extends OptionPanelBase {
    readonly rootDirective = viewChild(RdxTooltipRootDirective);

    readonly MountainSnowIcon = MountainSnow;
    readonly XIcon = X;
    protected readonly TriangleAlert = TriangleAlert;
    protected readonly containerAlert = containerAlert;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/tooltip-events.components.ts
```typescript
import { Component, viewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RdxPositionAlign, RdxPositionSide } from '@radix-ng/primitives/core';
import { LucideAngularModule, MountainSnow, TriangleAlert, X } from 'lucide-angular';
import { RdxTooltipModule, RdxTooltipRootDirective } from '../index';
import { RdxTooltipContentAttributesComponent } from '../src/tooltip-content-attributes.component';
import { provideRdxCdkEventService } from '../src/utils/cdk-event.service';
import { containerAlert } from './utils/constants';
import { OptionPanelBase } from './utils/option-panel-base.class';
import styles from './utils/styles.constants';
import { WithOptionPanelComponent } from './utils/with-option-panel.component';

@Component({
    selector: 'rdx-tooltip-events',
    providers: [provideRdxCdkEventService()],
    imports: [
        RdxTooltipModule,
        LucideAngularModule,
        FormsModule,
        RdxTooltipContentAttributesComponent,
        WithOptionPanelComponent
    ],
    styles: `
        ${styles()}
    `,
    template: `
        <tooltip-with-option-panel
            [arrowWidth]="arrowWidth()"
            [arrowHeight]="arrowHeight()"
            [openDelay]="openDelay()"
            [closeDelay]="closeDelay()"
            (onOverlayEscapeKeyDownDisabledChange)="onOverlayEscapeKeyDownDisabled.set($event)"
            (onOverlayOutsideClickDisabledChange)="onOverlayOutsideClickDisabled.set($event)"
            (arrowWidthChange)="arrowWidth.set($event)"
            (arrowHeightChange)="arrowHeight.set($event)"
            (openDelayChange)="openDelay.set($event)"
            (closeDelayChange)="closeDelay.set($event)"
        >
            <div class="ContainerAlerts">
                <lucide-angular [img]="TriangleAlert" size="16" />
                {{ containerAlert }}
            </div>
            <div class="container">
                <ng-container [openDelay]="openDelay()" [closeDelay]="closeDelay()" rdxTooltipRoot>
                    <button class="reset IconButton" rdxTooltipTrigger>
                        <lucide-angular [img]="MountainSnowIcon" size="16" style="display: flex" />
                    </button>

                    <ng-template
                        [onOverlayEscapeKeyDownDisabled]="onOverlayEscapeKeyDownDisabled()"
                        [onOverlayOutsideClickDisabled]="onOverlayOutsideClickDisabled()"
                        [sideOffset]="8"
                        rdxTooltipContent
                    >
                        <div class="TooltipContent" rdxTooltipContentAttributes>
                            <button class="reset TooltipClose" rdxTooltipClose aria-label="Close">
                                <lucide-angular [img]="XIcon" size="12" style="display: flex" />
                            </button>
                            Add to library
                            <div
                                class="TooltipArrow"
                                [width]="arrowWidth()"
                                [height]="arrowHeight()"
                                rdxTooltipArrow
                            ></div>
                        </div>
                    </ng-template>
                </ng-container>
            </div>
            <div class="TooltipId">ID: {{ rootDirective()?.uniqueId() }}</div>
        </tooltip-with-option-panel>
    `
})
export class RdxTooltipEventsComponent extends OptionPanelBase {
    readonly rootDirective = viewChild(RdxTooltipRootDirective);

    readonly MountainSnowIcon = MountainSnow;
    readonly XIcon = X;

    protected readonly sides = RdxPositionSide;
    protected readonly aligns = RdxPositionAlign;
    protected readonly containerAlert = containerAlert;
    protected readonly TriangleAlert = TriangleAlert;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/tooltip-initially-open.component.ts
```typescript
import { Component, viewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { LucideAngularModule, MountainSnow, TriangleAlert, X } from 'lucide-angular';
import { RdxTooltipModule, RdxTooltipRootDirective } from '../index';
import { RdxTooltipContentAttributesComponent } from '../src/tooltip-content-attributes.component';
import { provideRdxCdkEventService } from '../src/utils/cdk-event.service';
import { containerAlert } from './utils/constants';
import { OptionPanelBase } from './utils/option-panel-base.class';
import styles from './utils/styles.constants';
import { WithOptionPanelComponent } from './utils/with-option-panel.component';

@Component({
    selector: 'rdx-tooltip-initially-open',
    providers: [provideRdxCdkEventService()],
    imports: [
        FormsModule,
        RdxTooltipModule,
        LucideAngularModule,
        RdxTooltipContentAttributesComponent,
        WithOptionPanelComponent
    ],
    styles: styles(),
    template: `
        <tooltip-with-option-panel
            [arrowWidth]="arrowWidth()"
            [arrowHeight]="arrowHeight()"
            [openDelay]="openDelay()"
            [closeDelay]="closeDelay()"
            (onOverlayEscapeKeyDownDisabledChange)="onOverlayEscapeKeyDownDisabled.set($event)"
            (onOverlayOutsideClickDisabledChange)="onOverlayOutsideClickDisabled.set($event)"
            (arrowWidthChange)="arrowWidth.set($event)"
            (arrowHeightChange)="arrowHeight.set($event)"
            (openDelayChange)="openDelay.set($event)"
            (closeDelayChange)="closeDelay.set($event)"
        >
            <div class="ContainerAlerts">
                <lucide-angular [img]="TriangleAlert" size="16" />
                {{ containerAlert }}
            </div>
            <div class="container">
                <ng-container [defaultOpen]="true" [openDelay]="openDelay()" [closeDelay]="closeDelay()" rdxTooltipRoot>
                    <button class="reset IconButton" rdxTooltipTrigger>
                        <lucide-angular [img]="MountainSnowIcon" size="16" style="display: flex" />
                    </button>

                    <ng-template
                        [onOverlayEscapeKeyDownDisabled]="onOverlayEscapeKeyDownDisabled()"
                        [onOverlayOutsideClickDisabled]="onOverlayOutsideClickDisabled()"
                        [sideOffset]="8"
                        rdxTooltipContent
                    >
                        <div class="TooltipContent" rdxTooltipContentAttributes>
                            <button class="reset TooltipClose" rdxTooltipClose aria-label="Close">
                                <lucide-angular [img]="XIcon" size="12" style="display: flex" />
                            </button>
                            Add to library
                            <div
                                class="TooltipArrow"
                                [width]="arrowWidth()"
                                [height]="arrowHeight()"
                                rdxTooltipArrow
                            ></div>
                        </div>
                    </ng-template>
                </ng-container>
            </div>
            <div class="TooltipId">ID: {{ rootDirective()?.uniqueId() }}</div>
        </tooltip-with-option-panel>
    `
})
export class RdxTooltipInitiallyOpenComponent extends OptionPanelBase {
    readonly rootDirective = viewChild(RdxTooltipRootDirective);

    readonly MountainSnowIcon = MountainSnow;
    readonly XIcon = X;
    protected readonly containerAlert = containerAlert;
    protected readonly TriangleAlert = TriangleAlert;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/tooltip-multiple.component.ts
```typescript
import { Component, viewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RdxPositionAlign, RdxPositionSide } from '@radix-ng/primitives/core';
import { LucideAngularModule, MountainSnow, TriangleAlert, X } from 'lucide-angular';
import { RdxTooltipModule } from '../index';
import { RdxTooltipContentAttributesComponent } from '../src/tooltip-content-attributes.component';
import { provideRdxCdkEventService } from '../src/utils/cdk-event.service';
import { containerAlert } from './utils/constants';
import { OptionPanelBase } from './utils/option-panel-base.class';
import styles from './utils/styles.constants';
import { WithOptionPanelComponent } from './utils/with-option-panel.component';

@Component({
    selector: 'rdx-tooltip-multiple',
    providers: [provideRdxCdkEventService()],
    imports: [
        FormsModule,
        RdxTooltipModule,
        LucideAngularModule,
        RdxTooltipContentAttributesComponent,
        WithOptionPanelComponent
    ],
    styles: styles(),
    template: `
        <p class="ExampleSubtitle">Tooltip #1</p>
        <tooltip-with-option-panel
            [arrowWidth]="arrowWidth()"
            [arrowHeight]="arrowHeight()"
            [openDelay]="openDelay()"
            [closeDelay]="closeDelay()"
            (onOverlayEscapeKeyDownDisabledChange)="onOverlayEscapeKeyDownDisabled.set($event)"
            (onOverlayOutsideClickDisabledChange)="onOverlayOutsideClickDisabled.set($event)"
            (arrowWidthChange)="arrowWidth.set($event)"
            (arrowHeightChange)="arrowHeight.set($event)"
            (openDelayChange)="openDelay.set($event)"
            (closeDelayChange)="closeDelay.set($event)"
        >
            <div class="ContainerAlerts">
                <lucide-angular [img]="TriangleAlert" size="16" />
                {{ containerAlert }}
            </div>
            <div class="container">
                <ng-container
                    #root1="rdxTooltipRoot"
                    [openDelay]="openDelay()"
                    [closeDelay]="closeDelay()"
                    rdxTooltipRoot
                >
                    <button class="reset IconButton" rdxTooltipTrigger>
                        <lucide-angular [img]="MountainSnowIcon" size="16" style="display: flex" />
                    </button>

                    <ng-template
                        [onOverlayEscapeKeyDownDisabled]="onOverlayEscapeKeyDownDisabled()"
                        [onOverlayOutsideClickDisabled]="onOverlayOutsideClickDisabled()"
                        rdxTooltipContent
                    >
                        <div class="TooltipContent" rdxTooltipContentAttributes>
                            <button class="reset TooltipClose" rdxTooltipClose aria-label="Close">
                                <lucide-angular [img]="XIcon" size="12" style="display: flex" />
                            </button>
                            Add to library
                            <div
                                class="TooltipArrow"
                                [width]="arrowWidth()"
                                [height]="arrowHeight()"
                                rdxTooltipArrow
                            ></div>
                        </div>
                    </ng-template>
                </ng-container>
            </div>
            <div class="TooltipId">ID: {{ rootDirective1()?.uniqueId() }}</div>
        </tooltip-with-option-panel>

        <p class="ExampleSubtitle">Tooltip #2</p>
        <tooltip-with-option-panel
            [arrowWidth]="arrowWidth()"
            [arrowHeight]="arrowHeight()"
            [openDelay]="openDelay()"
            [closeDelay]="closeDelay()"
            (onOverlayEscapeKeyDownDisabledChange)="onOverlayEscapeKeyDownDisabled.set($event)"
            (onOverlayOutsideClickDisabledChange)="onOverlayOutsideClickDisabled.set($event)"
            (arrowWidthChange)="arrowWidth.set($event)"
            (arrowHeightChange)="arrowHeight.set($event)"
            (openDelayChange)="openDelay.set($event)"
            (closeDelayChange)="closeDelay.set($event)"
        >
            <div class="ContainerAlerts">
                <lucide-angular [img]="TriangleAlert" size="16" />
                {{ containerAlert }}
            </div>
            <div class="ContainerAlerts">
                <lucide-angular [img]="TriangleAlert" size="16" />
                <code>[side]="'left'"</code>
                <code>[align]="'start'"</code>
                <code>[sideOffset]="16"</code>
                <code>[alignOffset]="16"</code>
            </div>
            <div class="container">
                <ng-container
                    #root2="rdxTooltipRoot"
                    [openDelay]="openDelay()"
                    [closeDelay]="closeDelay()"
                    rdxTooltipRoot
                >
                    <button class="reset IconButton" rdxTooltipTrigger>
                        <lucide-angular [img]="MountainSnowIcon" size="16" style="display: flex" />
                    </button>

                    <ng-template
                        [side]="RdxPositionSide.Left"
                        [align]="RdxPositionAlign.Start"
                        [sideOffset]="16"
                        [alignOffset]="16"
                        [onOverlayEscapeKeyDownDisabled]="onOverlayEscapeKeyDownDisabled()"
                        [onOverlayOutsideClickDisabled]="onOverlayOutsideClickDisabled()"
                        rdxTooltipContent
                    >
                        <div class="TooltipContent" rdxTooltipContentAttributes>
                            <button class="reset TooltipClose" rdxTooltipClose aria-label="Close">
                                <lucide-angular [img]="XIcon" size="12" style="display: flex" />
                            </button>
                            Add to library
                            <div
                                class="TooltipArrow"
                                [width]="arrowWidth()"
                                [height]="arrowHeight()"
                                rdxTooltipArrow
                            ></div>
                        </div>
                    </ng-template>
                </ng-container>
            </div>
            <div class="TooltipId">ID: {{ rootDirective2()?.uniqueId() }}</div>
        </tooltip-with-option-panel>

        <p class="ExampleSubtitle">Tooltip #3</p>
        <tooltip-with-option-panel
            [arrowWidth]="arrowWidth()"
            [arrowHeight]="arrowHeight()"
            [openDelay]="openDelay()"
            [closeDelay]="closeDelay()"
            (onOverlayEscapeKeyDownDisabledChange)="onOverlayEscapeKeyDownDisabled.set($event)"
            (onOverlayOutsideClickDisabledChange)="onOverlayOutsideClickDisabled.set($event)"
            (arrowWidthChange)="arrowWidth.set($event)"
            (arrowHeightChange)="arrowHeight.set($event)"
            (openDelayChange)="openDelay.set($event)"
            (closeDelayChange)="closeDelay.set($event)"
        >
            <div class="ContainerAlerts">
                <lucide-angular [img]="TriangleAlert" size="16" />
                {{ containerAlert }}
            </div>
            <div class="ContainerAlerts">
                <lucide-angular [img]="TriangleAlert" size="16" />
                <code>[side]="'right'"</code>
                <code>[align]="'end'"</code>
                <code>[sideOffset]="60"</code>
                <code>[alignOffset]="60"</code>
            </div>
            <div class="container">
                <ng-container
                    #root3="rdxTooltipRoot"
                    [openDelay]="openDelay()"
                    [closeDelay]="closeDelay()"
                    rdxTooltipRoot
                >
                    <button class="reset IconButton" rdxTooltipTrigger>
                        <lucide-angular [img]="MountainSnowIcon" size="16" style="display: flex" />
                    </button>

                    <ng-template
                        [side]="RdxPositionSide.Right"
                        [align]="RdxPositionAlign.End"
                        [sideOffset]="60"
                        [alignOffset]="60"
                        [onOverlayEscapeKeyDownDisabled]="onOverlayEscapeKeyDownDisabled()"
                        [onOverlayOutsideClickDisabled]="onOverlayOutsideClickDisabled()"
                        rdxTooltipContent
                    >
                        <div class="TooltipContent" rdxTooltipContentAttributes>
                            <button class="reset TooltipClose" rdxTooltipClose aria-label="Close">
                                <lucide-angular [img]="XIcon" size="12" style="display: flex" />
                            </button>
                            Add to library
                            <div
                                class="TooltipArrow"
                                [width]="arrowWidth()"
                                [height]="arrowHeight()"
                                rdxTooltipArrow
                            ></div>
                        </div>
                    </ng-template>
                </ng-container>
            </div>
            <div class="TooltipId">ID: {{ rootDirective3()?.uniqueId() }}</div>
        </tooltip-with-option-panel>
    `
})
export class RdxTooltipMultipleComponent extends OptionPanelBase {
    readonly rootDirective1 = viewChild('root1');
    readonly rootDirective2 = viewChild('root2');
    readonly rootDirective3 = viewChild('root3');

    readonly MountainSnowIcon = MountainSnow;
    readonly XIcon = X;
    readonly RdxPositionSide = RdxPositionSide;
    readonly RdxPositionAlign = RdxPositionAlign;
    protected readonly containerAlert = containerAlert;
    protected readonly TriangleAlert = TriangleAlert;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/tooltip-positioning.component.ts
```typescript
import { Component, signal, viewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RdxPositionAlign, RdxPositionSide } from '@radix-ng/primitives/core';
import { LucideAngularModule, MountainSnow, TriangleAlert, X } from 'lucide-angular';
import { RdxTooltipModule, RdxTooltipRootDirective } from '../index';
import { RdxTooltipContentAttributesComponent } from '../src/tooltip-content-attributes.component';
import { provideRdxCdkEventService } from '../src/utils/cdk-event.service';
import { containerAlert } from './utils/constants';
import { OptionPanelBase } from './utils/option-panel-base.class';
import styles from './utils/styles.constants';
import { WithOptionPanelComponent } from './utils/with-option-panel.component';

@Component({
    selector: 'rdx-tooltip-positioning',
    providers: [provideRdxCdkEventService()],
    imports: [
        FormsModule,
        RdxTooltipModule,
        LucideAngularModule,
        RdxTooltipContentAttributesComponent,
        WithOptionPanelComponent
    ],
    styles: styles(),
    template: `
        <tooltip-with-option-panel
            [arrowWidth]="arrowWidth()"
            [arrowHeight]="arrowHeight()"
            [openDelay]="openDelay()"
            [closeDelay]="closeDelay()"
            (onOverlayEscapeKeyDownDisabledChange)="onOverlayEscapeKeyDownDisabled.set($event)"
            (onOverlayOutsideClickDisabledChange)="onOverlayOutsideClickDisabled.set($event)"
            (arrowWidthChange)="arrowWidth.set($event)"
            (arrowHeightChange)="arrowHeight.set($event)"
            (openDelayChange)="openDelay.set($event)"
            (closeDelayChange)="closeDelay.set($event)"
        >
            <div class="ParamsContainer">
                Side:
                <select [ngModel]="selectedSide()" (ngModelChange)="selectedSide.set($event)">
                    <option [value]="sides.Top">{{ sides.Top }}</option>
                    <option [value]="sides.Bottom">{{ sides.Bottom }}</option>
                    <option [value]="sides.Left">{{ sides.Left }}</option>
                    <option [value]="sides.Right">{{ sides.Right }}</option>
                </select>
                Align:
                <select [ngModel]="selectedAlign()" (ngModelChange)="selectedAlign.set($event)">
                    <option [value]="aligns.Center">{{ aligns.Center }}</option>
                    <option [value]="aligns.Start">{{ aligns.Start }}</option>
                    <option [value]="aligns.End">{{ aligns.End }}</option>
                </select>
                SideOffset:
                <input [ngModel]="sideOffset()" (ngModelChange)="sideOffset.set($event)" type="number" />
                AlignOffset:
                <input [ngModel]="alignOffset()" (ngModelChange)="alignOffset.set($event)" type="number" />
            </div>

            <div class="ParamsContainer">
                <input
                    [ngModel]="disableAlternatePositions()"
                    (ngModelChange)="disableAlternatePositions.set($event)"
                    type="checkbox"
                />
                Disable alternate positions (to see the result, scroll the page to make the tooltip cross the viewport
                boundary)
            </div>

            <div class="ContainerAlerts">
                <lucide-angular [img]="TriangleAlert" size="16" />
                {{ containerAlert }}
            </div>
            <div class="container">
                <ng-container [openDelay]="openDelay()" [closeDelay]="closeDelay()" rdxTooltipRoot>
                    <button class="reset IconButton" rdxTooltipTrigger>
                        <lucide-angular [img]="MountainSnowIcon" size="16" style="display: flex" />
                    </button>

                    <ng-template
                        [sideOffset]="sideOffset()"
                        [alignOffset]="alignOffset()"
                        [side]="selectedSide()"
                        [align]="selectedAlign()"
                        [alternatePositionsDisabled]="disableAlternatePositions()"
                        [onOverlayEscapeKeyDownDisabled]="onOverlayEscapeKeyDownDisabled()"
                        [onOverlayOutsideClickDisabled]="onOverlayOutsideClickDisabled()"
                        rdxTooltipContent
                    >
                        <div class="TooltipContent" rdxTooltipContentAttributes>
                            <button class="reset TooltipClose" rdxTooltipClose aria-label="Close">
                                <lucide-angular [img]="XIcon" size="12" style="display: flex" />
                            </button>
                            Add to library
                            <div
                                class="TooltipArrow"
                                [width]="arrowWidth()"
                                [height]="arrowHeight()"
                                rdxTooltipArrow
                            ></div>
                        </div>
                    </ng-template>
                </ng-container>
            </div>
            <div class="TooltipId">ID: {{ rootDirective()?.uniqueId() }}</div>
        </tooltip-with-option-panel>
    `
})
export class RdxTooltipPositioningComponent extends OptionPanelBase {
    readonly rootDirective = viewChild(RdxTooltipRootDirective);

    readonly selectedSide = signal(RdxPositionSide.Top);
    readonly selectedAlign = signal(RdxPositionAlign.Center);
    readonly sideOffset = signal<number | undefined>(void 0);
    readonly alignOffset = signal<number | undefined>(void 0);
    readonly disableAlternatePositions = signal(false);

    readonly sides = RdxPositionSide;
    readonly aligns = RdxPositionAlign;

    readonly MountainSnowIcon = MountainSnow;
    readonly XIcon = X;
    protected readonly containerAlert = containerAlert;
    protected readonly TriangleAlert = TriangleAlert;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/tooltip-triggering.component.ts
```typescript
import { Component, signal, viewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { LucideAngularModule, MountainSnow, TriangleAlert, X } from 'lucide-angular';
import { RdxTooltipModule } from '../index';
import { RdxTooltipContentAttributesComponent } from '../src/tooltip-content-attributes.component';
import { provideRdxCdkEventService } from '../src/utils/cdk-event.service';
import { containerAlert } from './utils/constants';
import { OptionPanelBase } from './utils/option-panel-base.class';
import styles from './utils/styles.constants';
import { WithOptionPanelComponent } from './utils/with-option-panel.component';

@Component({
    selector: 'rdx-tooltip-triggering',
    providers: [provideRdxCdkEventService()],
    imports: [
        FormsModule,
        RdxTooltipModule,
        LucideAngularModule,
        RdxTooltipContentAttributesComponent,
        WithOptionPanelComponent
    ],
    styles: styles(),
    template: `
        <p class="ExampleSubtitle">Initially closed</p>
        <tooltip-with-option-panel
            [arrowWidth]="arrowWidth()"
            [arrowHeight]="arrowHeight()"
            [openDelay]="openDelay()"
            [closeDelay]="closeDelay()"
            (onOverlayEscapeKeyDownDisabledChange)="onOverlayEscapeKeyDownDisabled.set($event)"
            (onOverlayOutsideClickDisabledChange)="onOverlayOutsideClickDisabled.set($event)"
            (arrowWidthChange)="arrowWidth.set($event)"
            (arrowHeightChange)="arrowHeight.set($event)"
            (openDelayChange)="openDelay.set($event)"
            (closeDelayChange)="closeDelay.set($event)"
        >
            <div class="ParamsContainer">
                <button (mouseup)="triggerOpenFalse()" type="button">Open: {{ isOpenFalse() }}</button>
                onOpenChange count: {{ counterOpenFalse() }}
            </div>

            <div class="ParamsContainer">
                <input
                    [ngModel]="externalControlFalse()"
                    (ngModelChange)="externalControlFalse.set($event)"
                    type="checkbox"
                />
                External control
            </div>

            <div class="ContainerAlerts">
                <lucide-angular [img]="TriangleAlert" size="16" />
                {{ containerAlert }}
            </div>
            <div class="container">
                <ng-container
                    #root1="rdxTooltipRoot"
                    [open]="isOpenFalse()"
                    [openDelay]="openDelay()"
                    [closeDelay]="closeDelay()"
                    [externalControl]="externalControlFalse()"
                    rdxTooltipRoot
                >
                    <button class="reset IconButton" rdxTooltipTrigger>
                        <lucide-angular [img]="MountainSnowIcon" size="16" style="display: flex" />
                    </button>

                    <ng-template
                        [sideOffset]="8"
                        [onOverlayEscapeKeyDownDisabled]="onOverlayEscapeKeyDownDisabled()"
                        [onOverlayOutsideClickDisabled]="onOverlayOutsideClickDisabled()"
                        (onOpen)="countOpenFalse(true)"
                        (onClosed)="countOpenFalse(false)"
                        rdxTooltipContent
                    >
                        <div class="TooltipContent" rdxTooltipContentAttributes>
                            <button class="reset TooltipClose" rdxTooltipClose aria-label="Close">
                                <lucide-angular [img]="XIcon" size="12" style="display: flex" />
                            </button>
                            Add to library
                            <div
                                class="TooltipArrow"
                                [width]="arrowWidth()"
                                [height]="arrowHeight()"
                                rdxTooltipArrow
                            ></div>
                        </div>
                    </ng-template>
                </ng-container>
            </div>
            <div class="TooltipId">ID: {{ rootDirective1()?.uniqueId() }}</div>
        </tooltip-with-option-panel>

        <p class="ExampleSubtitle">Initially open</p>
        <tooltip-with-option-panel
            [arrowWidth]="arrowWidth()"
            [arrowHeight]="arrowHeight()"
            [openDelay]="openDelay()"
            [closeDelay]="closeDelay()"
            (onOverlayEscapeKeyDownDisabledChange)="onOverlayEscapeKeyDownDisabled.set($event)"
            (onOverlayOutsideClickDisabledChange)="onOverlayOutsideClickDisabled.set($event)"
            (arrowWidthChange)="arrowWidth.set($event)"
            (arrowHeightChange)="arrowHeight.set($event)"
            (openDelayChange)="openDelay.set($event)"
            (closeDelayChange)="closeDelay.set($event)"
        >
            <div class="ParamsContainer">
                <button (mouseup)="triggerOpenTrue()" type="button">Open: {{ isOpenTrue() }}</button>
                <span>onOpenChange count: {{ counterOpenTrue() }}</span>
            </div>

            <div class="ParamsContainer">
                <input
                    [ngModel]="externalControlTrue()"
                    (ngModelChange)="externalControlTrue.set($event)"
                    type="checkbox"
                />
                External control
            </div>

            <div class="ContainerAlerts">
                <lucide-angular [img]="TriangleAlert" size="16" />
                {{ containerAlert }}
            </div>
            <div class="container">
                <ng-container
                    #root2="rdxTooltipRoot"
                    [open]="isOpenTrue()"
                    [openDelay]="openDelay()"
                    [closeDelay]="closeDelay()"
                    [externalControl]="externalControlTrue()"
                    rdxTooltipRoot
                >
                    <button class="reset IconButton" rdxTooltipTrigger>
                        <lucide-angular [img]="MountainSnowIcon" size="16" style="display: flex" />
                    </button>

                    <ng-template
                        [sideOffset]="8"
                        [onOverlayEscapeKeyDownDisabled]="onOverlayEscapeKeyDownDisabled()"
                        [onOverlayOutsideClickDisabled]="onOverlayOutsideClickDisabled()"
                        (onOpen)="countOpenTrue(true)"
                        (onClosed)="countOpenTrue(false)"
                        rdxTooltipContent
                    >
                        <div class="TooltipContent" rdxTooltipContentAttributes>
                            <button class="reset TooltipClose" rdxTooltipClose aria-label="Close">
                                <lucide-angular [img]="XIcon" size="12" style="display: flex" />
                            </button>
                            Add to library
                            <div
                                class="TooltipArrow"
                                [width]="arrowWidth()"
                                [height]="arrowHeight()"
                                rdxTooltipArrow
                            ></div>
                        </div>
                    </ng-template>
                </ng-container>
            </div>
            <div class="TooltipId">ID: {{ rootDirective2()?.uniqueId() }}</div>
        </tooltip-with-option-panel>
    `
})
export class RdxTooltipTriggeringComponent extends OptionPanelBase {
    readonly rootDirective1 = viewChild('root1');
    readonly rootDirective2 = viewChild('root2');

    readonly MountainSnowIcon = MountainSnow;
    readonly XIcon = X;

    isOpenFalse = signal(false);
    counterOpenFalse = signal(0);
    externalControlFalse = signal(true);

    isOpenTrue = signal(true);
    counterOpenTrue = signal(0);
    externalControlTrue = signal(true);

    triggerOpenFalse(): void {
        this.isOpenFalse.update((value) => !value);
    }

    countOpenFalse(open: boolean): void {
        this.isOpenFalse.set(open);
        this.counterOpenFalse.update((value) => value + 1);
    }

    triggerOpenTrue(): void {
        this.isOpenTrue.update((value) => !value);
    }

    countOpenTrue(open: boolean): void {
        this.isOpenTrue.set(open);
        this.counterOpenTrue.update((value) => value + 1);
    }

    protected readonly containerAlert = containerAlert;
    protected readonly TriangleAlert = TriangleAlert;
}

```
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/tooltip.docs.mdx
````
import {ArgTypes, Canvas, Markdown, Meta, Source} from '@storybook/blocks';
import * as TooltipStories from "./tooltip.stories";
import {RdxTooltipRootDirective} from "../src/tooltip-root.directive";
import {RdxTooltipContentDirective} from "../src/tooltip-content.directive";
import {RdxTooltipArrowDirective} from "../src/tooltip-arrow.directive";
import {RdxTooltipAnchorDirective} from "../src/tooltip-anchor.directive";
import {RdxTooltipTriggerDirective} from "../src/tooltip-trigger.directive";
import {RdxTooltipCloseDirective} from "../src/tooltip-close.directive";
import {animationStylesOnly} from "./utils/styles.constants";
import {RdxTooltipContentAttributesComponent} from "../src/tooltip-content-attributes.component";

<Meta title="Primitives/Tooltip" />

# Tooltip

#### A popup that displays information related to an element when the element receives keyboard focus or the mouse hovers over it.

<br />
<br />

## Examples
### Default

<Canvas sourceState="hidden" of={TooltipStories.Default} />

### Multiple

<Canvas sourceState="hidden" of={TooltipStories.Multiple} />

### Events

<Canvas sourceState="hidden" of={TooltipStories.Events} />

### Positioning

<Canvas sourceState="hidden" of={TooltipStories.Positioning} />

### External Triggering

<Canvas sourceState="hidden" of={TooltipStories.ExternalTriggering} />

### Anchor

<Canvas sourceState="hidden" of={TooltipStories.Anchor} />

### Initially Open

<Canvas sourceState="hidden" of={TooltipStories.InitiallyOpen} />

### Animations

<Canvas sourceState="hidden" of={TooltipStories.Animations} />

### Animation Styles

<Source type="code" language="css" code={`${animationStylesOnly}`} />


## Features

- ✅ Opens when the trigger is clicked.
- ✅ Closes when the trigger is clicked again or when pressing escape.
- ✅ Controllable from outside.

## Anatomy

```html
<ng-container rdxTooltipRoot>
    <button class="IconButton" rdxTooltipTrigger>+</button>

    <ng-template rdxTooltipContent>
        <div class="TooltipContent" rdxTooltipContentAttributes>
            <button class="TooltipClose" rdxTooltipClose aria-label="Close">X</button>
            Tooltip Content
            <div class="TooltipArrow" rdxTooltipArrow></div>
        </div>
    </ng-template>
</ng-container>
```

## Import

Get started with importing the directives:

<Source type="code" language="typescript" code={`import {
  RdxTooltipRootDirective,
  RdxTooltipRootTrigger,
  RdxTooltipContentDirective,
  RdxTooltipArrowDirective,
  RdxTooltipAnchorDirective,
  RdxTooltipCloseDirective
} from '@radix-ng/primitives/tooltip';`} />

or

<Source type="code" language="typescript" code={`import { RdxTooltipModule } from '@radix-ng/primitives/tooltip';`} />

## API Reference

### Root
`RdxTooltipRootDirective`

Contains all the parts of a tooltip.

<ArgTypes of={RdxTooltipRootDirective} />

### Trigger
`RdxTooltipTriggerDirective`

The button that toggles the tooltip. By default, the TooltipContent will position itself against the trigger.

<Markdown>
{`
| Data attribute | Value          |
|----------------|----------------|
| [data-state]   | <code>"closed" | "open" (type RdxTooltipState)</code>
`}
</Markdown>

### Anchor
`RdxTooltipAnchorDirective`

An optional element to position the TooltipContent against. If this part is not used, the content will position alongside the TooltipTrigger.

### Content
`RdxTooltipContentDirective`

The component that pops out when the tooltip is open.

<ArgTypes of={RdxTooltipContentDirective} />

### Content Attributes
`RdxTooltipContentAttributesComponent`

A component with the content attributes that are necessary to run animations.

<ArgTypes of={RdxTooltipContentAttributesComponent} />

<Markdown>
{`
| Data attribute | Value          |
|----------------|----------------|
| [data-state]   | <code>"closed" | "open" (enum RdxTooltipState)</code>
| [data-side]    | <code>"left"   | "right" | "bottom" | "top" (enum RdxPositionSide)</code>
| [data-align]   | <code>"start"  | "end" | "center" (enum RdxPositionAlign)</code>
`}
</Markdown>

### Arrow
`RdxTooltipArrowDirective`

An optional arrow element to render alongside the tooltip. This can be used to help visually link the trigger with the TooltipContent. Must be rendered inside TooltipContent.

<ArgTypes of={RdxTooltipArrowDirective} />

### Close
`RdxTooltipCloseDirective`

An optional close button element to render alongside the tooltip. This can be used to close the TooltipContent. Must be rendered inside TooltipContent.

````
/Users/josh/Documents/GitHub/radix-ng/primitives/packages/primitives/tooltip/stories/tooltip.stories.ts
```typescript
import { provideAnimations } from '@angular/platform-browser/animations';
import { componentWrapperDecorator, Meta, moduleMetadata, StoryObj } from '@storybook/angular';
import { LucideAngularModule, MountainSnow, X } from 'lucide-angular';
import { RdxTooltipModule } from '../index';
import { RdxTooltipAnchorComponent } from './tooltip-anchor.component';
import { RdxTooltipAnimationsComponent } from './tooltip-animations.component';
import { RdxTooltipDefaultComponent } from './tooltip-default.component';
import { RdxTooltipEventsComponent } from './tooltip-events.components';
import { RdxTooltipInitiallyOpenComponent } from './tooltip-initially-open.component';
import { RdxTooltipMultipleComponent } from './tooltip-multiple.component';
import { RdxTooltipPositioningComponent } from './tooltip-positioning.component';
import { RdxTooltipTriggeringComponent } from './tooltip-triggering.component';

const html = String.raw;

export default {
    title: 'Primitives/Tooltip',
    decorators: [
        moduleMetadata({
            imports: [
                RdxTooltipModule,
                RdxTooltipDefaultComponent,
                RdxTooltipEventsComponent,
                RdxTooltipPositioningComponent,
                RdxTooltipTriggeringComponent,
                RdxTooltipMultipleComponent,
                RdxTooltipAnimationsComponent,
                RdxTooltipInitiallyOpenComponent,
                RdxTooltipAnchorComponent,
                LucideAngularModule,
                LucideAngularModule.pick({ MountainSnow, X })
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
            `
        )
    ]
} as Meta;

type Story = StoryObj;

export const Default: Story = {
    render: () => ({
        template: html`
            <rdx-tooltip-default></rdx-tooltip-default>
        `
    })
};

export const Multiple: Story = {
    render: () => ({
        template: html`
            <rdx-tooltip-multiple></rdx-tooltip-multiple>
        `
    })
};

export const Events: Story = {
    render: () => ({
        template: html`
            <rdx-tooltip-events></rdx-tooltip-events>
        `
    })
};

export const Positioning: Story = {
    render: () => ({
        template: html`
            <rdx-tooltip-positioning></rdx-tooltip-positioning>
        `
    })
};

export const ExternalTriggering: Story = {
    render: () => ({
        template: html`
            <rdx-tooltip-triggering></rdx-tooltip-triggering>
        `
    })
};

export const Anchor: Story = {
    render: () => ({
        template: html`
            <rdx-tooltip-anchor></rdx-tooltip-anchor>
        `
    })
};

export const InitiallyOpen: Story = {
    render: () => ({
        template: html`
            <rdx-tooltip-initially-open></rdx-tooltip-initially-open>
        `
    })
};

export const Animations: Story = {
    render: () => ({
        template: html`
            <rdx-tooltip-animations></rdx-tooltip-animations>
        `
    })
};

```
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
