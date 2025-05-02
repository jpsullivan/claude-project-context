/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/accordion/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnAccordionContentComponent } from './lib/brn-accordion-content.component';
import {
	BrnAccordionDirective,
	BrnAccordionItemDirective,
	BrnAccordionTriggerDirective,
} from './lib/brn-accordion.directive';

export * from './lib/brn-accordion-content.component';
export * from './lib/brn-accordion.directive';

export const BrnAccordionImports = [
	BrnAccordionDirective,
	BrnAccordionContentComponent,
	BrnAccordionItemDirective,
	BrnAccordionTriggerDirective,
] as const;

@NgModule({
	imports: [...BrnAccordionImports],
	exports: [...BrnAccordionImports],
})
export class BrnAccordionModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/accordion/src/lib/brn-accordion-content.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation, computed, inject, signal } from '@angular/core';
import type { CustomElementClassSettable } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';
import { BrnAccordionItemDirective } from './brn-accordion.directive';

@Component({
	selector: 'brn-accordion-content',
	standalone: true,
	host: {
		'[attr.data-state]': 'state()',
		'[attr.aria-labelledby]': 'ariaLabeledBy',
		role: 'region',
		'[id]': 'id',
	},
	template: `
		<div [attr.inert]="_addInert()" style="overflow: hidden">
			<p [class]="_contentClass()">
				<ng-content />
			</p>
		</div>
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnAccordionContentComponent implements CustomElementClassSettable {
	private readonly _item = inject(BrnAccordionItemDirective);

	public readonly state = this._item.state;
	public readonly id = `brn-accordion-content-${this._item.id}`;
	public readonly ariaLabeledBy = `brn-accordion-trigger-${this._item.id}`;

	protected readonly _addInert = computed(() => (this.state() === 'closed' ? true : undefined));
	protected readonly _contentClass = signal<ClassValue>('');

	constructor() {
		if (!this._item) {
			throw Error('Accordion Content can only be used inside an AccordionItem. Add brnAccordionItem to parent.');
		}
	}

	public setClassToCustomElement(classes: ClassValue) {
		this._contentClass.set(classes);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/accordion/src/lib/brn-accordion.directive.spec.ts
```typescript
import { createEvent, fireEvent, render, screen, waitFor } from '@testing-library/angular';
import userEvent from '@testing-library/user-event';
import {
	BrnAccordionDirective,
	BrnAccordionItemDirective,
	BrnAccordionTriggerDirective,
} from './brn-accordion.directive';

describe('BrnAccordionDirective', () => {
	const setup = async () => {
		const container = await render(
			`
      <div brnAccordion aria-label="acco">
        <div brnAccordionItem>
          <button brnAccordionTrigger aria-label="trigger">
            Is it accessible?
          </button>
          asdf
        </div>
        <div brnAccordionItem>
          <button brnAccordionTrigger aria-label="trigger">
            Is it styled?
          </button>
            Yes. It comes with default styles that match the other components' aesthetics.
        </div>
        <div brnAccordionItem>
          <button brnAccordionTrigger aria-label="trigger">
            Is it animated?
          </button>
            Yes. It's animated by default, but you can disable it if you prefer.
        </div>
      </div>
    `,
			{
				imports: [BrnAccordionDirective, BrnAccordionItemDirective, BrnAccordionTriggerDirective],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			triggers: screen.getAllByLabelText('trigger'),
			accordion: screen.getByLabelText('acco'),
		};
	};
	const setupMulti = async () => {
		const container = await render(
			`
      <div brnAccordion type="multiple" orientation="horizontal" aria-label="acco">
        <div brnAccordionItem>
          <button brnAccordionTrigger aria-label="trigger">
            Is it accessible?
          </button>
          asdf
        </div>
        <div brnAccordionItem>
          <button brnAccordionTrigger aria-label="trigger">
            Is it styled?
          </button>
            Yes. It comes with default styles that match the other components' aesthetics.
        </div>
        <div brnAccordionItem>
          <button brnAccordionTrigger aria-label="trigger">
            Is it animated?
          </button>
            Yes. It's animated by default, but you can disable it if you prefer.
        </div>
      </div>
    `,
			{
				imports: [BrnAccordionDirective, BrnAccordionItemDirective, BrnAccordionTriggerDirective],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			triggers: screen.getAllByLabelText('trigger'),
			accordion: screen.getByLabelText('acco'),
		};
	};
	const setupWithInput = async () => {
		const container = await render(
			`
      <div brnAccordion aria-label="acco">
        <div brnAccordionItem>
          <button brnAccordionTrigger aria-label="trigger">
           	Enter your name
          </button>

          <input data-testid="accordion-input" />
        </div>
      </div>
    `,
			{
				imports: [BrnAccordionDirective, BrnAccordionItemDirective, BrnAccordionTriggerDirective],
			},
		);
		return {
			user: userEvent.setup(),
			container,
			trigger: screen.getByLabelText('trigger'),
			accordion: screen.getByLabelText('acco'),
			input: screen.getByTestId('accordion-input'),
		};
	};
	const validateOpenClosed = async (triggers: HTMLElement[], accordion: HTMLElement, openedTriggers: boolean[]) => {
		await waitFor(() => {
			expect(triggers[0]).toHaveAttribute('data-state', openedTriggers[0] ? 'open' : 'closed');
			expect(triggers[1]).toHaveAttribute('data-state', openedTriggers[1] ? 'open' : 'closed');
			expect(triggers[2]).toHaveAttribute('data-state', openedTriggers[2] ? 'open' : 'closed');
			const anyOpen = openedTriggers.some((t) => t);
			expect(accordion).toHaveAttribute('data-state', anyOpen ? 'open' : 'closed');
		});
	};

	describe('single accordion', () => {
		it('initial state all datastate closed', async () => {
			const { triggers, accordion } = await setup();
			await validateOpenClosed(triggers, accordion, [false, false, false]);
			expect(accordion).toHaveAttribute('data-orientation', 'vertical');
		});
		it('should open the trigger on click ', async () => {
			const { user, triggers, accordion } = await setup();
			await user.click(triggers[0]);
			await validateOpenClosed(triggers, accordion, [true, false, false]);
			await user.click(triggers[1]);
			await validateOpenClosed(triggers, accordion, [false, true, false]);
			await user.click(triggers[1]);
			await validateOpenClosed(triggers, accordion, [false, false, false]);
			await user.click(triggers[2]);
			await validateOpenClosed(triggers, accordion, [false, false, true]);
			await user.click(triggers[1]);
			await validateOpenClosed(triggers, accordion, [false, true, false]);
		});
		it('should open the trigger on enter and space ', async () => {
			const { user, triggers, accordion } = await setup();
			await user.keyboard('[Tab][Enter]');
			await validateOpenClosed(triggers, accordion, [true, false, false]);
			await user.keyboard('[Tab][Enter]');
			await validateOpenClosed(triggers, accordion, [false, true, false]);
			await user.keyboard('[Space]');
			await validateOpenClosed(triggers, accordion, [false, false, false]);
			await user.keyboard('[Tab][Enter]');
			await validateOpenClosed(triggers, accordion, [false, false, true]);
			await user.keyboard('{Shift>}[Tab]{/Shift}[Space]');
			await validateOpenClosed(triggers, accordion, [false, true, false]);
		});
		it('should open the trigger on enter and space and prevent default for enter also on second entry', async () => {
			const { user, accordion } = await setup();
			const keyboardEventEnter = createEvent.keyDown(accordion, {
				key: 'Enter',
				code: 'Enter',
				which: 13,
				keyCode: 13,
			});
			await user.keyboard('[Tab][Tab]');
			fireEvent(accordion, keyboardEventEnter);
			expect(keyboardEventEnter.defaultPrevented).toBe(true);
		});
	});
	describe('multi accordion', () => {
		it('initial state all datastate closed', async () => {
			const { triggers, accordion } = await setupMulti();
			await validateOpenClosed(triggers, accordion, [false, false, false]);
			expect(accordion).toHaveAttribute('data-orientation', 'horizontal');
		});
		it('should open the trigger on click ', async () => {
			const { user, triggers, accordion } = await setupMulti();

			await user.click(triggers[0]);
			await validateOpenClosed(triggers, accordion, [true, false, false]);
			await user.click(triggers[1]);
			await validateOpenClosed(triggers, accordion, [true, true, false]);
			await user.click(triggers[1]);
			await validateOpenClosed(triggers, accordion, [true, false, false]);
			await user.click(triggers[2]);
			await validateOpenClosed(triggers, accordion, [true, false, true]);
			await user.click(triggers[1]);
			await validateOpenClosed(triggers, accordion, [true, true, true]);
		});
	});
	describe('accordion with input', () => {
		it('should allow typing space', async () => {
			const { user, trigger, input } = await setupWithInput();

			// Open the accordion and tab to the input
			await user.click(trigger);
			await user.tab();

			expect(trigger).toHaveAttribute('data-state', 'open');
			expect(input).toHaveFocus();

			// Type a name with a space
			await user.type(input, 'John Doe');
			expect(input).toHaveValue('John Doe');

			// Go back to the trigger and hit space
			await user.tab({ shift: true });
			await user.keyboard('[Space]');

			// Trigger should be closed
			expect(trigger).toHaveAttribute('data-state', 'closed');
			expect(trigger).toHaveFocus();
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/accordion/src/lib/brn-accordion.directive.ts
```typescript
import { FocusKeyManager, FocusMonitor } from '@angular/cdk/a11y';
import { coerceBooleanProperty } from '@angular/cdk/coercion';
import {
	type AfterContentInit,
	Directive,
	ElementRef,
	HostListener,
	type OnDestroy,
	computed,
	contentChildren,
	effect,
	inject,
	input,
	signal,
	untracked,
} from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { fromEvent } from 'rxjs';

@Directive({
	selector: '[brnAccordionItem]',
	standalone: true,
	host: {
		'[attr.data-state]': 'state()',
	},
	exportAs: 'brnAccordionItem',
})
export class BrnAccordionItemDirective {
	private static _itemIdGenerator = 0;
	private readonly _accordion = inject(BrnAccordionDirective);
	public readonly isOpened = input(false, { transform: coerceBooleanProperty });

	public readonly id = BrnAccordionItemDirective._itemIdGenerator++;
	public readonly state = computed(() => (this._accordion.openItemIds().includes(this.id) ? 'open' : 'closed'));

	constructor() {
		if (!this._accordion) {
			throw Error('Accordion trigger can only be used inside an Accordion. Add brnAccordion to ancestor.');
		}
		effect(() => {
			const isOpened = this.isOpened();
			untracked(() => {
				if (isOpened) {
					this._accordion.openItem(this.id);
				} else {
					this._accordion.closeItem(this.id);
				}
			});
		});
	}
}

@Directive({
	selector: '[brnAccordionTrigger]',
	standalone: true,
	host: {
		'[attr.data-state]': 'state()',
		'[attr.aria-expanded]': 'state() === "open"',
		'[attr.aria-controls]': 'ariaControls',
		role: 'heading',
		'aria-level': '3',
		'[id]': 'id',
	},
})
export class BrnAccordionTriggerDirective {
	private readonly _accordion = inject(BrnAccordionDirective);
	private readonly _item = inject(BrnAccordionItemDirective);
	private readonly _elementRef = inject(ElementRef);

	public readonly state = this._item.state;
	public readonly id = `brn-accordion-trigger-${this._item.id}`;
	public readonly ariaControls = `brn-accordion-content-${this._item.id}`;

	constructor() {
		if (!this._accordion) {
			throw Error('Accordion trigger can only be used inside an Accordion. Add brnAccordion to ancestor.');
		}

		if (!this._item) {
			throw Error('Accordion trigger can only be used inside an AccordionItem. Add brnAccordionItem to parent.');
		}

		fromEvent(this._elementRef.nativeElement, 'focus')
			.pipe(takeUntilDestroyed())
			.subscribe(() => {
				this._accordion.setActiveItem(this);
			});
	}

	@HostListener('click', ['$event'])
	@HostListener('keyup.space', ['$event'])
	@HostListener('keyup.enter', ['$event'])
	protected toggle(event: Event): void {
		event.preventDefault();
		this._accordion.toggleItem(this._item.id);
	}

	public focus() {
		this._elementRef.nativeElement.focus();
	}
}

const HORIZONTAL_KEYS_TO_PREVENT_DEFAULT = [
	'ArrowLeft',
	'ArrowRight',
	'PageDown',
	'PageUp',
	'Home',
	'End',
	' ',
	'Enter',
];
const VERTICAL_KEYS_TO_PREVENT_DEFAULT = ['ArrowUp', 'ArrowDown', 'PageDown', 'PageUp', 'Home', 'End', ' ', 'Enter'];

@Directive({
	selector: '[brnAccordion]',
	standalone: true,
	host: {
		'[attr.data-state]': 'state()',
		'[attr.data-orientation]': 'orientation()',
	},
	exportAs: 'brnAccordion',
})
export class BrnAccordionDirective implements AfterContentInit, OnDestroy {
	private readonly _el = inject(ElementRef);
	private _keyManager?: FocusKeyManager<BrnAccordionTriggerDirective>;
	private readonly _focusMonitor = inject(FocusMonitor);

	private readonly _focused = signal<boolean>(false);
	private readonly _openItemIds = signal<number[]>([]);
	public readonly openItemIds = this._openItemIds.asReadonly();
	public readonly state = computed(() => (this._openItemIds().length > 0 ? 'open' : 'closed'));

	public triggers = contentChildren(BrnAccordionTriggerDirective, { descendants: true });

	public readonly type = input<'single' | 'multiple'>('single');
	public readonly dir = input<'ltr' | 'rtl' | null>(null);
	public readonly orientation = input<'horizontal' | 'vertical'>('vertical');

	public ngAfterContentInit() {
		this._keyManager = new FocusKeyManager<BrnAccordionTriggerDirective>(this.triggers())
			.withHomeAndEnd()
			.withPageUpDown()
			.withWrap();

		if (this.orientation() === 'horizontal') {
			this._keyManager.withHorizontalOrientation(this.dir() ?? 'ltr').withVerticalOrientation(false);
		}

		this._el.nativeElement.addEventListener('keydown', (event: KeyboardEvent) => {
			const target = event.target as HTMLElement;

			if (target.tagName === 'INPUT') return;

			this._keyManager?.onKeydown(event);
			this.preventDefaultEvents(event);
		});
		this._focusMonitor.monitor(this._el, true).subscribe((origin) => this._focused.set(origin !== null));
	}

	ngOnDestroy(): void {
		this._focusMonitor.stopMonitoring(this._el);
	}

	public setActiveItem(item: BrnAccordionTriggerDirective) {
		this._keyManager?.setActiveItem(item);
	}

	public toggleItem(id: number) {
		if (this._openItemIds().includes(id)) {
			this.closeItem(id);
			return;
		}
		this.openItem(id);
	}

	public openItem(id: number) {
		if (this.type() === 'single') {
			this._openItemIds.set([id]);
			return;
		}
		this._openItemIds.update((ids) => [...ids, id]);
	}
	public closeItem(id: number) {
		this._openItemIds.update((ids) => ids.filter((openId) => id !== openId));
	}

	private preventDefaultEvents(event: KeyboardEvent) {
		if (!this._focused()) return;
		if (!('key' in event)) return;

		const keys =
			this.orientation() === 'horizontal' ? HORIZONTAL_KEYS_TO_PREVENT_DEFAULT : VERTICAL_KEYS_TO_PREVENT_DEFAULT;
		if (keys.includes(event.key) && event.code !== 'NumpadEnter') {
			event.preventDefault();
		}
	}
}

```
