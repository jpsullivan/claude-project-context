/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/src/index.ts
```typescript
import { NgModule } from '@angular/core';
import { HlmCarouselContentComponent } from './lib/hlm-carousel-content.component';
import { HlmCarouselItemComponent } from './lib/hlm-carousel-item.component';
import { HlmCarouselNextComponent } from './lib/hlm-carousel-next.component';
import { HlmCarouselPreviousComponent } from './lib/hlm-carousel-previous.component';
import { HlmCarouselComponent } from './lib/hlm-carousel.component';

export * from './lib/hlm-carousel-content.component';
export * from './lib/hlm-carousel-item.component';
export * from './lib/hlm-carousel-next.component';
export * from './lib/hlm-carousel-previous.component';
export * from './lib/hlm-carousel.component';

export const HlmCarouselImports = [
	HlmCarouselComponent,
	HlmCarouselContentComponent,
	HlmCarouselItemComponent,
	HlmCarouselPreviousComponent,
	HlmCarouselNextComponent,
] as const;

@NgModule({
	imports: [...HlmCarouselImports],
	exports: [...HlmCarouselImports],
})
export class HlmCarouselModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/src/test-setup.ts
```typescript
// @ts-expect-error https://thymikee.github.io/jest-preset-angular/docs/getting-started/test-environment
globalThis.ngJest = {
	testEnvironmentOptions: {
		errorOnUnknownElements: true,
		errorOnUnknownProperties: true,
	},
};
import 'jest-preset-angular/setup-jest';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/src/lib/hlm-carousel-content.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, inject, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';
import { HlmCarouselComponent } from './hlm-carousel.component';

@Component({
	selector: 'hlm-carousel-content',
	standalone: true,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	host: {
		'[class]': '_computedClass()',
	},
	template: `
		<ng-content />
	`,
})
export class HlmCarouselContentComponent {
	private readonly _orientation = inject(HlmCarouselComponent).orientation;

	public _userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() =>
		hlm('flex', this._orientation() === 'horizontal' ? '-ml-4' : '-mt-4 flex-col', this._userClass()),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/src/lib/hlm-carousel-item.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, inject, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';
import { HlmCarouselComponent } from './hlm-carousel.component';

@Component({
	selector: 'hlm-carousel-item',
	standalone: true,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	host: {
		'[class]': '_computedClass()',
		role: 'group',
		'aria-roledescription': 'slide',
	},
	template: `
		<ng-content />
	`,
})
export class HlmCarouselItemComponent {
	public _userClass = input<ClassValue>('', { alias: 'class' });
	private readonly _orientation = inject(HlmCarouselComponent).orientation;
	protected _computedClass = computed(() =>
		hlm(
			'min-w-0 shrink-0 grow-0 basis-full',
			this._orientation() === 'horizontal' ? 'pl-4' : 'pt-4',
			this._userClass(),
		),
	);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/src/lib/hlm-carousel-next.component.ts
```typescript
import {
	ChangeDetectionStrategy,
	Component,
	ViewEncapsulation,
	computed,
	effect,
	inject,
	input,
	untracked,
} from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideArrowRight } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { HlmButtonDirective, provideBrnButtonConfig } from '@spartan-ng/ui-button-helm';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';
import { HlmCarouselComponent } from './hlm-carousel.component';

@Component({
	selector: 'button[hlm-carousel-next], button[hlmCarouselNext]',
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	host: {
		'[disabled]': 'isDisabled()',
		'(click)': '_carousel.scrollNext()',
	},
	hostDirectives: [{ directive: HlmButtonDirective, inputs: ['variant', 'size'] }],
	providers: [provideIcons({ lucideArrowRight }), provideBrnButtonConfig({ variant: 'outline', size: 'icon' })],
	imports: [NgIcon, HlmIconDirective],
	template: `
		<ng-icon hlm size="sm" name="lucideArrowRight" />
		<span class="sr-only">Next slide</span>
	`,
})
export class HlmCarouselNextComponent {
	private readonly _button = inject(HlmButtonDirective);
	private readonly _carousel = inject(HlmCarouselComponent);
	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	private readonly _computedClass = computed(() =>
		hlm(
			'absolute h-8 w-8 rounded-full',
			this._carousel.orientation() === 'horizontal'
				? '-right-12 top-1/2 -translate-y-1/2'
				: '-bottom-12 left-1/2 -translate-x-1/2 rotate-90',
			this.userClass(),
		),
	);
	protected readonly isDisabled = () => !this._carousel.canScrollNext();

	constructor() {
		effect(() => {
			const computedClass = this._computedClass();

			untracked(() => this._button.setClass(computedClass));
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/src/lib/hlm-carousel-previous.component.ts
```typescript
import {
	ChangeDetectionStrategy,
	Component,
	ViewEncapsulation,
	computed,
	effect,
	inject,
	input,
	untracked,
} from '@angular/core';
import { NgIcon, provideIcons } from '@ng-icons/core';
import { lucideArrowLeft } from '@ng-icons/lucide';
import { hlm } from '@spartan-ng/brain/core';
import { HlmButtonDirective, provideBrnButtonConfig } from '@spartan-ng/ui-button-helm';
import { HlmIconDirective } from '@spartan-ng/ui-icon-helm';
import type { ClassValue } from 'clsx';
import { HlmCarouselComponent } from './hlm-carousel.component';

@Component({
	selector: 'button[hlm-carousel-previous], button[hlmCarouselPrevious]',
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	host: {
		'[disabled]': 'isDisabled()',
		'(click)': '_carousel.scrollPrev()',
	},
	hostDirectives: [{ directive: HlmButtonDirective, inputs: ['variant', 'size'] }],
	providers: [provideIcons({ lucideArrowLeft }), provideBrnButtonConfig({ variant: 'outline', size: 'icon' })],
	imports: [NgIcon, HlmIconDirective],
	template: `
		<ng-icon hlm size="sm" name="lucideArrowLeft" />
		<span class="sr-only">Previous slide</span>
	`,
})
export class HlmCarouselPreviousComponent {
	private readonly _button = inject(HlmButtonDirective);

	protected readonly _carousel = inject(HlmCarouselComponent);

	public readonly userClass = input<ClassValue>('', { alias: 'class' });

	private readonly _computedClass = computed(() =>
		hlm(
			'absolute h-8 w-8 rounded-full',
			this._carousel.orientation() === 'horizontal'
				? '-left-12 top-1/2 -translate-y-1/2'
				: '-top-12 left-1/2 -translate-x-1/2 rotate-90',
			this.userClass(),
		),
	);
	protected readonly isDisabled = () => !this._carousel.canScrollPrev();

	constructor() {
		effect(() => {
			const computedClass = this._computedClass();

			untracked(() => this._button.setClass(computedClass));
		});
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/ui/carousel/helm/src/lib/hlm-carousel.component.ts
```typescript
import {
	ChangeDetectionStrategy,
	Component,
	HostListener,
	type InputSignal,
	type Signal,
	ViewChild,
	ViewEncapsulation,
	computed,
	input,
	signal,
} from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';
import {
	EmblaCarouselDirective,
	type EmblaEventType,
	type EmblaOptionsType,
	type EmblaPluginType,
} from 'embla-carousel-angular';

@Component({
	selector: 'hlm-carousel',
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	host: {
		'[class]': '_computedClass()',
		role: 'region',
		'aria-roledescription': 'carousel',
	},
	imports: [EmblaCarouselDirective],
	template: `
		<div
			emblaCarousel
			class="overflow-hidden"
			[plugins]="plugins()"
			[options]="emblaOptions()"
			[subscribeToEvents]="['init', 'select', 'reInit']"
			(emblaChange)="onEmblaEvent($event)"
		>
			<ng-content select="hlm-carousel-content" />
		</div>
		<ng-content />
	`,
})
export class HlmCarouselComponent {
	@ViewChild(EmblaCarouselDirective) protected emblaCarousel?: EmblaCarouselDirective;

	public _userClass = input<ClassValue>('', { alias: 'class' });
	protected _computedClass = computed(() => hlm('relative', this._userClass()));

	public orientation = input<'horizontal' | 'vertical'>('horizontal');
	public options: InputSignal<Omit<EmblaOptionsType, 'axis'> | undefined> = input();
	public plugins: InputSignal<EmblaPluginType[]> = input([] as EmblaPluginType[]);

	protected emblaOptions: Signal<EmblaOptionsType> = computed(() => ({
		...this.options(),
		axis: this.orientation() === 'horizontal' ? 'x' : 'y',
	}));

	private readonly _canScrollPrev = signal(false);
	public canScrollPrev = this._canScrollPrev.asReadonly();
	private readonly _canScrollNext = signal(false);
	public canScrollNext = this._canScrollNext.asReadonly();

	protected onEmblaEvent(event: EmblaEventType) {
		const emblaApi = this.emblaCarousel?.emblaApi;

		if (!emblaApi) {
			return;
		}

		if (event === 'select' || event === 'init' || event === 'reInit') {
			this._canScrollPrev.set(emblaApi.canScrollPrev());
			this._canScrollNext.set(emblaApi.canScrollNext());
		}
	}

	@HostListener('keydown', ['$event'])
	protected onKeydown(event: KeyboardEvent) {
		if (event.key === 'ArrowLeft') {
			event.preventDefault();
			this.emblaCarousel?.scrollPrev();
		} else if (event.key === 'ArrowRight') {
			event.preventDefault();
			this.emblaCarousel?.scrollNext();
		}
	}

	scrollPrev() {
		this.emblaCarousel?.scrollPrev();
	}

	scrollNext() {
		this.emblaCarousel?.scrollNext();
	}
}

```
