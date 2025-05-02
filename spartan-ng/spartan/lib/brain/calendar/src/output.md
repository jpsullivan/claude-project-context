/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/index.ts
```typescript
export * from './lib/brn-calendar-cell-button.directive';
export * from './lib/brn-calendar-cell.directive';
export * from './lib/brn-calendar-grid.directive';
export * from './lib/brn-calendar-header.directive';
export * from './lib/brn-calendar-next-button.directive';
export * from './lib/brn-calendar-previous-button.directive';
export * from './lib/brn-calendar-week.directive';
export * from './lib/brn-calendar-weekday.directive';
export * from './lib/brn-calendar.directive';
export * from './lib/brn-calendar.token';
export * from './lib/i18n/calendar-i18n';
export * from './lib/mode/brn-calendar-multiple.directive';

import { NgModule } from '@angular/core';
import { BrnCalendarCellButtonDirective } from './lib/brn-calendar-cell-button.directive';
import { BrnCalendarCellDirective } from './lib/brn-calendar-cell.directive';
import { BrnCalendarGridDirective } from './lib/brn-calendar-grid.directive';
import { BrnCalendarHeaderDirective } from './lib/brn-calendar-header.directive';
import { BrnCalendarNextButtonDirective } from './lib/brn-calendar-next-button.directive';
import { BrnCalendarPreviousButtonDirective } from './lib/brn-calendar-previous-button.directive';
import { BrnCalendarWeekDirective } from './lib/brn-calendar-week.directive';
import { BrnCalendarWeekdayDirective } from './lib/brn-calendar-weekday.directive';
import { BrnCalendarDirective } from './lib/brn-calendar.directive';
import { BrnCalendarMultiDirective } from './lib/mode/brn-calendar-multiple.directive';

export const BrnCalendarImports = [
	BrnCalendarCellButtonDirective,
	BrnCalendarGridDirective,
	BrnCalendarHeaderDirective,
	BrnCalendarNextButtonDirective,
	BrnCalendarPreviousButtonDirective,
	BrnCalendarWeekDirective,
	BrnCalendarWeekdayDirective,
	BrnCalendarDirective,
	BrnCalendarCellDirective,
	BrnCalendarMultiDirective,
] as const;

@NgModule({
	imports: [...BrnCalendarImports],
	exports: [...BrnCalendarImports],
})
export class BrnCalendarModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-cell-button.directive.ts
```typescript
import { Directive, ElementRef, computed, inject, input } from '@angular/core';
import { injectDateAdapter } from '@spartan-ng/brain/date-time';
import { injectBrnCalendar } from './brn-calendar.token';

@Directive({
	selector: 'button[brnCalendarCellButton]',
	standalone: true,
	host: {
		role: 'gridcell',
		'[tabindex]': 'focusable() ? 0 : -1',
		type: 'button',
		'[attr.data-outside]': "outside() ? '' : null",
		'[attr.data-today]': "today() && !selected() ? '' : null",
		'[attr.data-selected]': "selected() ? '' : null",
		'[attr.data-disabled]': "disabled() ? '' : null",
		'[attr.aria-selected]': "selected() ? 'true' : null",
		'[attr.aria-disabled]': "disabled() ? 'true' : null",
		'[disabled]': 'disabled()',
		'(click)': 'calendar.selectDate(date())',
		'(keydown.arrowLeft)': 'focusPrevious($event)',
		'(keydown.arrowRight)': 'focusNext($event)',
		'(keydown.arrowUp)': 'focusAbove($event)',
		'(keydown.arrowDown)': 'focusBelow($event)',
		'(keydown.home)': 'focusFirst($event)',
		'(keydown.end)': 'focusLast($event)',
		'(keydown.pageUp)': 'focusPreviousMonth($event)',
		'(keydown.pageDown)': 'focusNextMonth($event)',
	},
})
export class BrnCalendarCellButtonDirective<T> {
	/** Access the date adapter */
	protected readonly dateAdapter = injectDateAdapter<T>();

	/** Access the calendar component */
	protected readonly calendar = injectBrnCalendar<T>();

	/** Access the element ref */
	private readonly _elementRef = inject<ElementRef<HTMLButtonElement>>(ElementRef);

	/** The date this cell represents */
	public readonly date = input.required<T>();

	/** Whether this date is currently selected */
	public readonly selected = computed(() => this.calendar.isSelected(this.date()));

	/** Whether this date is focusable */
	public readonly focusable = computed(() => this.dateAdapter.isSameDay(this.calendar.focusedDate(), this.date()));

	public readonly outside = computed(() => {
		const focusedDate = this.calendar.focusedDate();
		return !this.dateAdapter.isSameMonth(this.date(), focusedDate);
	});

	/** Whether this date is today */
	public readonly today = computed(() => this.dateAdapter.isSameDay(this.date(), this.dateAdapter.now()));

	/** Whether this date is disabled */
	public readonly disabled = computed(() => this.calendar.isDateDisabled(this.date()) || this.calendar.disabled());

	/**
	 * Focus the previous cell.
	 */
	protected focusPrevious(event: Event): void {
		event.preventDefault();
		event.stopPropagation();

		// in rtl, the arrow keys are reversed.
		const targetDate = this.dateAdapter.add(this.calendar.focusedDate(), {
			days: this.getDirection() === 'rtl' ? 1 : -1,
		});

		this.calendar.setFocusedDate(targetDate);
	}

	/**
	 * Focus the next cell.
	 */
	protected focusNext(event: Event): void {
		event.preventDefault();
		event.stopPropagation();

		const targetDate = this.dateAdapter.add(this.calendar.focusedDate(), {
			days: this.getDirection() === 'rtl' ? -1 : 1,
		});

		this.calendar.setFocusedDate(targetDate);
	}

	/**
	 * Focus the above cell.
	 */
	protected focusAbove(event: Event): void {
		event.preventDefault();
		event.stopPropagation();
		this.calendar.setFocusedDate(this.dateAdapter.subtract(this.calendar.focusedDate(), { days: 7 }));
	}

	/**
	 * Focus the below cell.
	 */
	protected focusBelow(event: Event): void {
		event.preventDefault();
		event.stopPropagation();
		this.calendar.setFocusedDate(this.dateAdapter.add(this.calendar.focusedDate(), { days: 7 }));
	}

	/**
	 * Focus the first date of the month.
	 */
	protected focusFirst(event: Event): void {
		event.preventDefault();
		event.stopPropagation();
		this.calendar.setFocusedDate(this.dateAdapter.startOfMonth(this.calendar.focusedDate()));
	}

	/**
	 * Focus the last date of the month.
	 */
	protected focusLast(event: Event): void {
		event.preventDefault();
		event.stopPropagation();
		this.calendar.setFocusedDate(this.dateAdapter.endOfMonth(this.calendar.focusedDate()));
	}

	/**
	 * Focus the same date in the previous month.
	 */
	protected focusPreviousMonth(event: Event): void {
		event.preventDefault();
		event.stopPropagation();

		const date = this.dateAdapter.getDate(this.calendar.focusedDate());

		let previousMonthTarget = this.dateAdapter.startOfMonth(this.calendar.focusedDate());
		previousMonthTarget = this.dateAdapter.subtract(previousMonthTarget, { months: 1 });

		const lastDay = this.dateAdapter.endOfMonth(previousMonthTarget);

		// if we are on a date that does not exist in the previous month, we should focus the last day of the month.
		if (date > this.dateAdapter.getDate(lastDay)) {
			this.calendar.setFocusedDate(lastDay);
		} else {
			this.calendar.setFocusedDate(this.dateAdapter.set(previousMonthTarget, { day: date }));
		}
	}

	/**
	 * Focus the same date in the next month.
	 */
	protected focusNextMonth(event: Event): void {
		event.preventDefault();
		event.stopPropagation();

		const date = this.dateAdapter.getDate(this.calendar.focusedDate());

		let nextMonthTarget = this.dateAdapter.startOfMonth(this.calendar.focusedDate());
		nextMonthTarget = this.dateAdapter.add(nextMonthTarget, { months: 1 });

		const lastDay = this.dateAdapter.endOfMonth(nextMonthTarget);

		// if we are on a date that does not exist in the next month, we should focus the last day of the month.
		if (date > this.dateAdapter.getDate(lastDay)) {
			this.calendar.setFocusedDate(lastDay);
		} else {
			this.calendar.setFocusedDate(this.dateAdapter.set(nextMonthTarget, { day: date }));
		}
	}

	/**
	 * Get the direction of the element.
	 */
	private getDirection(): 'ltr' | 'rtl' {
		return getComputedStyle(this._elementRef.nativeElement).direction === 'rtl' ? 'rtl' : 'ltr';
	}

	focus(): void {
		this._elementRef.nativeElement.focus();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-cell.directive.ts
```typescript
import { Directive } from '@angular/core';

@Directive({
	selector: '[brnCalendarCell]',
	standalone: true,
	host: {
		role: 'presentation',
	},
})
export class BrnCalendarCellDirective {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-grid.directive.ts
```typescript
import { Directive } from '@angular/core';
import { injectBrnCalendar } from './brn-calendar.token';

@Directive({
	selector: '[brnCalendarGrid]',
	standalone: true,
	host: {
		role: 'grid',
		'[attr.aria-labelledby]': 'calendar.header()?.id()',
	},
})
export class BrnCalendarGridDirective<T> {
	/** Access the calendar component */
	protected readonly calendar = injectBrnCalendar<T>();
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-header.directive.ts
```typescript
import { Directive, input } from '@angular/core';

let uniqueId = 0;

@Directive({
	selector: '[brnCalendarHeader]',
	standalone: true,
	host: {
		'[id]': 'id()',
		'aria-live': 'polite',
		role: 'presentation',
	},
})
export class BrnCalendarHeaderDirective {
	/** The unique id for the header */
	public readonly id = input(`brn-calendar-header-${uniqueId++}`);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-next-button.directive.ts
```typescript
import { Directive, HostListener } from '@angular/core';
import { injectDateAdapter } from '@spartan-ng/brain/date-time';
import { injectBrnCalendar } from './brn-calendar.token';
import { injectBrnCalendarI18n } from './i18n/calendar-i18n';

@Directive({
	selector: '[brnCalendarNextButton]',
	standalone: true,
	host: {
		type: 'button',
		'[attr.aria-label]': 'i18n.labelNext()',
	},
})
export class BrnCalendarNextButtonDirective {
	/** Access the calendar */
	private readonly _calendar = injectBrnCalendar();

	/** Access the date adapter */
	private readonly _dateAdapter = injectDateAdapter();

	/** Access the calendar i18n */
	protected readonly i18n = injectBrnCalendarI18n();

	/** Focus the previous month */
	@HostListener('click')
	protected focusPreviousMonth(): void {
		const targetDate = this._dateAdapter.add(this._calendar.state().focusedDate(), { months: 1 });

		// if the date is disabled, but there are available dates in the month, focus the last day of the month.
		const possibleDate = this._calendar.constrainDate(targetDate);

		if (this._dateAdapter.isSameMonth(possibleDate, targetDate)) {
			// if this date is within the same month, then focus it
			this._calendar.state().focusedDate.set(possibleDate);
			return;
		}

		this._calendar.state().focusedDate.set(targetDate);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-previous-button.directive.ts
```typescript
import { Directive, HostListener } from '@angular/core';
import { injectDateAdapter } from '@spartan-ng/brain/date-time';
import { injectBrnCalendar } from './brn-calendar.token';
import { injectBrnCalendarI18n } from './i18n/calendar-i18n';

@Directive({
	selector: '[brnCalendarPreviousButton]',
	standalone: true,
	host: {
		type: 'button',
		'[attr.aria-label]': 'i18n.labelPrevious()',
	},
})
export class BrnCalendarPreviousButtonDirective {
	/** Access the calendar */
	private readonly _calendar = injectBrnCalendar();

	/** Access the date adapter */
	private readonly _dateAdapter = injectDateAdapter();

	/** Access the calendar i18n */
	protected readonly i18n = injectBrnCalendarI18n();

	/** Focus the previous month */
	@HostListener('click')
	protected focusPreviousMonth(): void {
		const targetDate = this._dateAdapter.subtract(this._calendar.state().focusedDate(), { months: 1 });

		// if the date is disabled, but there are available dates in the month, focus the last day of the month.
		const possibleDate = this._calendar.constrainDate(targetDate);

		if (this._dateAdapter.isSameMonth(possibleDate, targetDate)) {
			// if this date is within the same month, then focus it
			this._calendar.state().focusedDate.set(possibleDate);
			return;
		}

		this._calendar.state().focusedDate.set(targetDate);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-week.directive.ts
```typescript
import {
	ChangeDetectorRef,
	Directive,
	EmbeddedViewRef,
	OnDestroy,
	TemplateRef,
	ViewContainerRef,
	computed,
	effect,
	inject,
	untracked,
} from '@angular/core';
import { injectBrnCalendar } from './brn-calendar.token';

@Directive({
	standalone: true,
	selector: '[brnCalendarWeek]',
})
export class BrnCalendarWeekDirective<T> implements OnDestroy {
	/** Access the calendar */
	private readonly _calendar = injectBrnCalendar<T>();

	/** Access the view container ref */
	private readonly _viewContainerRef = inject(ViewContainerRef);

	/** Access the change detector */
	private readonly _changeDetector = inject(ChangeDetectorRef);

	/** Access the template ref */
	private readonly _templateRef = inject<TemplateRef<BrnWeekContext<T>>>(TemplateRef);

	// get the weeks to display.
	protected readonly weeks = computed(() => {
		const days = this._calendar.days();
		const weeks = [];

		for (let i = 0; i < days.length; i += 7) {
			weeks.push(days.slice(i, i + 7));
		}

		return weeks;
	});

	/** Store the view refs */
	private readonly _viewRefs: EmbeddedViewRef<BrnWeekContext<T>>[] = [];

	// Make sure the template checker knows the type of the context with which the
	// template of this directive will be rendered
	static ngTemplateContextGuard<T>(_: BrnCalendarWeekDirective<T>, ctx: unknown): ctx is BrnWeekContext<T> {
		return true;
	}

	constructor() {
		// this should use `afterRenderEffect` but it's not available in the current version
		effect(() => {
			const weeks = this.weeks();
			untracked(() => this._renderWeeks(weeks));
		});
	}

	private _renderWeeks(weeks: T[][]): void {
		// Destroy all the views when the directive is destroyed
		for (const viewRef of this._viewRefs) {
			viewRef.destroy();
		}

		this._viewRefs.length = 0;

		// Create a new view for each week
		for (const week of weeks) {
			const viewRef = this._viewContainerRef.createEmbeddedView(this._templateRef, {
				$implicit: week,
			});
			this._viewRefs.push(viewRef);
		}

		this._changeDetector.detectChanges();
	}

	ngOnDestroy(): void {
		// Destroy all the views when the directive is destroyed
		for (const viewRef of this._viewRefs) {
			viewRef.destroy();
		}
	}
}

interface BrnWeekContext<T> {
	$implicit: T[];
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar-weekday.directive.ts
```typescript
import { Directive, EmbeddedViewRef, OnDestroy, TemplateRef, ViewContainerRef, computed, inject } from '@angular/core';
import { injectDateAdapter } from '@spartan-ng/brain/date-time';
import { injectBrnCalendar } from './brn-calendar.token';

@Directive({
	standalone: true,
	selector: '[brnCalendarWeekday]',
})
export class BrnCalendarWeekdayDirective<T> implements OnDestroy {
	/** Access the calendar */
	private readonly _calendar = injectBrnCalendar<T>();

	/** Access the date time adapter */
	private readonly _dateAdapter = injectDateAdapter<T>();

	/** Access the view container ref */
	private readonly _viewContainerRef = inject(ViewContainerRef);

	/** Access the template ref */
	private readonly _templateRef = inject<TemplateRef<BrnWeekdayContext>>(TemplateRef);

	/** Get the days of the week to display in the header. */
	protected readonly weekdays = computed(() => this._calendar.days().slice(0, 7));

	/** Store the view refs */
	private readonly _viewRefs: EmbeddedViewRef<BrnWeekdayContext>[] = [];

	// Make sure the template checker knows the type of the context with which the
	// template of this directive will be rendered
	static ngTemplateContextGuard<T>(_: BrnCalendarWeekdayDirective<T>, ctx: unknown): ctx is BrnWeekdayContext {
		return true;
	}

	constructor() {
		// Create a new view for each day
		for (const day of this.weekdays()) {
			const viewRef = this._viewContainerRef.createEmbeddedView(this._templateRef, {
				$implicit: this._dateAdapter.getDay(day),
			});
			this._viewRefs.push(viewRef);
		}
	}

	ngOnDestroy(): void {
		// Destroy all the views when the directive is destroyed
		for (const viewRef of this._viewRefs) {
			viewRef.destroy();
		}
	}
}

interface BrnWeekdayContext {
	$implicit: number;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar.directive.ts
```typescript
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import {
	ChangeDetectorRef,
	Directive,
	Injector,
	afterNextRender,
	booleanAttribute,
	computed,
	contentChild,
	contentChildren,
	inject,
	input,
	model,
	numberAttribute,
	signal,
} from '@angular/core';
import { injectDateAdapter } from '@spartan-ng/brain/date-time';
import { BrnCalendarCellButtonDirective } from './brn-calendar-cell-button.directive';
import { BrnCalendarHeaderDirective } from './brn-calendar-header.directive';
import { BrnCalendar, provideBrnCalendar } from './brn-calendar.token';

@Directive({
	selector: '[brnCalendar]',
	standalone: true,
	providers: [provideBrnCalendar(BrnCalendarDirective)],
})
export class BrnCalendarDirective<T> implements BrnCalendar<T> {
	/** Access the date adapter */
	protected readonly dateAdapter = injectDateAdapter<T>();

	/** Access the change detector */
	private readonly _changeDetector = inject(ChangeDetectorRef);

	/** Access the injector */
	private readonly _injector = inject(Injector);

	/** The minimum date that can be selected.*/
	public readonly min = input<T>();

	/** The maximum date that can be selected. */
	public readonly max = input<T>();

	/** Determine if the date picker is disabled. */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** The selected value. */
	public readonly date = model<T>();

	/** Whether a specific date is disabled. */
	public readonly dateDisabled = input<(date: T) => boolean>(() => false);

	/** The day the week starts on */
	public readonly weekStartsOn = input<Weekday, NumberInput>(0, {
		transform: (v: unknown) => numberAttribute(v) as Weekday,
	});

	/** The default focused date. */
	public readonly defaultFocusedDate = input<T>();

	/** @internal Access the header */
	public readonly header = contentChild(BrnCalendarHeaderDirective);

	/** Store the cells */
	protected readonly cells = contentChildren<BrnCalendarCellButtonDirective<T>>(BrnCalendarCellButtonDirective, {
		descendants: true,
	});

	/**
	 * @internal
	 * The internal state of the component.
	 */
	public readonly state = computed(() => ({
		focusedDate: signal(this.constrainDate(this.defaultFocusedDate() ?? this.date() ?? this.dateAdapter.now())),
	}));

	/**
	 * The focused date.
	 */
	public readonly focusedDate = computed(() => this.state().focusedDate());

	/**
	 * Get all the days to display, this is the days of the current month
	 * and the days of the previous and next month to fill the grid.
	 */
	public readonly days = computed(() => {
		const weekStartsOn = this.weekStartsOn();
		const month = this.state().focusedDate();
		const days: T[] = [];

		// Get the first and last day of the month.
		let firstDay = this.dateAdapter.startOfMonth(month);
		let lastDay = this.dateAdapter.endOfMonth(month);

		// we need to subtract until we get the to starting day before or on the start of the month.
		while (this.dateAdapter.getDay(firstDay) !== weekStartsOn) {
			firstDay = this.dateAdapter.subtract(firstDay, { days: 1 });
		}

		const weekEndsOn = (weekStartsOn + 6) % 7;

		// we need to add until we get to the ending day after or on the end of the month.
		while (this.dateAdapter.getDay(lastDay) !== weekEndsOn) {
			lastDay = this.dateAdapter.add(lastDay, { days: 1 });
		}

		// collect all the days to display.
		while (firstDay <= lastDay) {
			days.push(firstDay);
			firstDay = this.dateAdapter.add(firstDay, { days: 1 });
		}

		return days;
	});

	/** @internal Constrain a date to the min and max boundaries */
	constrainDate(date: T): T {
		const min = this.min();
		const max = this.max();

		// If there is no min or max, return the date.
		if (!min && !max) {
			return date;
		}

		// If there is a min and the date is before the min, return the min.
		if (min && this.dateAdapter.isBefore(date, this.dateAdapter.startOfDay(min))) {
			return min;
		}

		// If there is a max and the date is after the max, return the max.
		if (max && this.dateAdapter.isAfter(date, this.dateAdapter.endOfDay(max))) {
			return max;
		}

		// Return the date.
		return date;
	}

	/** @internal Determine if a date is disabled */
	isDateDisabled(date: T): boolean {
		// if the calendar is disabled we can't select this date
		if (this.disabled()) {
			return true;
		}

		// if the date is outside the min and max range
		const min = this.min();
		const max = this.max();

		if (min && this.dateAdapter.isBefore(date, this.dateAdapter.startOfDay(min))) {
			return true;
		}

		if (max && this.dateAdapter.isAfter(date, this.dateAdapter.endOfDay(max))) {
			return true;
		}

		// if this specific date is disabled
		const disabledFn = this.dateDisabled();

		if (disabledFn(date)) {
			return true;
		}

		return false;
	}

	isSelected(date: T): boolean {
		const selected = this.date() as T | undefined;
		return selected !== undefined && this.dateAdapter.isSameDay(date, selected);
	}

	selectDate(date: T): void {
		if (this.isSelected(date)) {
			this.date.set(undefined);
		} else {
			this.date.set(date);
		}
		this.state().focusedDate.set(date);
	}

	/** @internal Set the focused date */
	setFocusedDate(date: T): void {
		// check if the date is disabled.
		if (this.isDateDisabled(date)) {
			return;
		}

		this.state().focusedDate.set(date);

		// wait until the cells have all updated
		afterNextRender(
			{
				write: () => {
					// focus the cell with the target date.
					const cell = this.cells().find((c) => this.dateAdapter.isSameDay(c.date(), date));

					if (cell) {
						cell.focus();
					}
				},
			},
			{
				injector: this._injector,
			},
		);

		// we must update the view to ensure the focused cell is visible.
		this._changeDetector.detectChanges();
	}
}

export type Weekday = 0 | 1 | 2 | 3 | 4 | 5 | 6;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/brn-calendar.token.ts
```typescript
import { ExistingProvider, InjectionToken, Signal, Type, WritableSignal, inject } from '@angular/core';
import { BrnCalendarHeaderDirective } from './brn-calendar-header.directive';

export interface BrnCalendar<T> {
	isSelected: (date: T) => boolean;
	selectDate: (date: T) => void;

	constrainDate: (date: T) => T;
	isDateDisabled: (date: T) => boolean;
	setFocusedDate: (date: T) => void;

	disabled: Signal<boolean>;
	focusedDate: Signal<T>;
	header: Signal<BrnCalendarHeaderDirective | undefined>;
	state: Signal<{
		focusedDate: WritableSignal<T>;
	}>;
	days: Signal<T[]>;
}

export const BrnCalendarToken = new InjectionToken<BrnCalendar<unknown>>('BrnCalendarToken');

export function provideBrnCalendar<T>(instance: Type<BrnCalendar<T>>): ExistingProvider {
	return { provide: BrnCalendarToken, useExisting: instance };
}

/**
 * Inject the calendar component.
 */
export function injectBrnCalendar<T>(): BrnCalendar<T> {
	return inject(BrnCalendarToken) as BrnCalendar<T>;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/mode/brn-calendar-multiple.directive.ts
```typescript
import { BooleanInput, NumberInput } from '@angular/cdk/coercion';
import {
	afterNextRender,
	booleanAttribute,
	ChangeDetectorRef,
	computed,
	contentChild,
	contentChildren,
	Directive,
	inject,
	Injector,
	input,
	model,
	numberAttribute,
	signal,
} from '@angular/core';
import { injectDateAdapter } from '@spartan-ng/brain/date-time';
import { BrnCalendarCellButtonDirective } from '../brn-calendar-cell-button.directive';
import { BrnCalendarHeaderDirective } from '../brn-calendar-header.directive';
import { Weekday } from '../brn-calendar.directive';
import { BrnCalendar, provideBrnCalendar } from '../brn-calendar.token';

@Directive({
	selector: '[brnCalendarMulti]',
	standalone: true,
	providers: [provideBrnCalendar(BrnCalendarMultiDirective)],
})
export class BrnCalendarMultiDirective<T> implements BrnCalendar<T> {
	// /** Access the date adapter */
	protected readonly dateAdapter = injectDateAdapter<T>();

	/** Access the change detector */
	private readonly _changeDetector = inject(ChangeDetectorRef);

	/** Access the injector */
	private readonly _injector = inject(Injector);

	/** The minimum date that can be selected.*/
	public readonly min = input<T>();

	/** The maximum date that can be selected. */
	public readonly max = input<T>();

	/** The minimum selectable dates.  */
	public readonly minSelection = input<number, NumberInput>(undefined, {
		transform: numberAttribute,
	});

	/** The maximum selectable dates.  */
	public readonly maxSelection = input<number, NumberInput>(undefined, {
		transform: numberAttribute,
	});

	/** Determine if the date picker is disabled. */
	public readonly disabled = input<boolean, BooleanInput>(false, {
		transform: booleanAttribute,
	});

	/** The selected value. */
	public readonly date = model<T[]>();

	/** Whether a specific date is disabled. */
	public readonly dateDisabled = input<(date: T) => boolean>(() => false);

	/** The day the week starts on */
	public readonly weekStartsOn = input<Weekday, NumberInput>(0, {
		transform: (v: unknown) => numberAttribute(v) as Weekday,
	});

	/** The default focused date. */
	public readonly defaultFocusedDate = input<T>();

	/** @internal Access the header */
	public readonly header = contentChild(BrnCalendarHeaderDirective);

	/** Store the cells */
	protected readonly cells = contentChildren<BrnCalendarCellButtonDirective<T>>(BrnCalendarCellButtonDirective, {
		descendants: true,
	});

	/**
	 * @internal
	 * The internal state of the component.
	 */
	public readonly state = computed(() => ({
		focusedDate: signal(this.constrainDate(this.defaultFocusedDate() ?? this.dateAdapter.now())),
	}));

	/**
	 * The focused date.
	 */
	public readonly focusedDate = computed(() => this.state().focusedDate());

	/**
	 * Get all the days to display, this is the days of the current month
	 * and the days of the previous and next month to fill the grid.
	 */
	public readonly days = computed(() => {
		const weekStartsOn = this.weekStartsOn();
		const month = this.state().focusedDate();
		const days: T[] = [];

		// Get the first and last day of the month.
		let firstDay = this.dateAdapter.startOfMonth(month);
		let lastDay = this.dateAdapter.endOfMonth(month);

		// we need to subtract until we get the to starting day before or on the start of the month.
		while (this.dateAdapter.getDay(firstDay) !== weekStartsOn) {
			firstDay = this.dateAdapter.subtract(firstDay, { days: 1 });
		}

		const weekEndsOn = (weekStartsOn + 6) % 7;

		// we need to add until we get to the ending day after or on the end of the month.
		while (this.dateAdapter.getDay(lastDay) !== weekEndsOn) {
			lastDay = this.dateAdapter.add(lastDay, { days: 1 });
		}

		// collect all the days to display.
		while (firstDay <= lastDay) {
			days.push(firstDay);
			firstDay = this.dateAdapter.add(firstDay, { days: 1 });
		}

		return days;
	});

	isSelected(date: T): boolean {
		return this.date()?.some((d) => this.dateAdapter.isSameDay(d, date)) ?? false;
	}

	selectDate(date: T): void {
		const selected = this.date() as T[] | undefined;
		if (this.isSelected(date)) {
			const minSelection = this.minSelection();
			if (selected?.length === minSelection) {
				// min selection reached, do not allow to deselect
				return;
			}

			this.date.set(selected?.filter((d) => !this.dateAdapter.isSameDay(d, date)));
		} else {
			const maxSelection = this.maxSelection();
			if (selected?.length === maxSelection) {
				// max selection reached, reset the selection to date
				this.date.set([date]);
			} else {
				// add the date to the selection
				this.date.set([...(selected ?? []), date]);
			}
		}
	}

	// same as in brn-calendar.directive.ts
	/** @internal Constrain a date to the min and max boundaries */
	constrainDate(date: T): T {
		const min = this.min();
		const max = this.max();

		// If there is no min or max, return the date.
		if (!min && !max) {
			return date;
		}

		// If there is a min and the date is before the min, return the min.
		if (min && this.dateAdapter.isBefore(date, this.dateAdapter.startOfDay(min))) {
			return min;
		}

		// If there is a max and the date is after the max, return the max.
		if (max && this.dateAdapter.isAfter(date, this.dateAdapter.endOfDay(max))) {
			return max;
		}

		// Return the date.
		return date;
	}

	/** @internal Determine if a date is disabled */
	isDateDisabled(date: T): boolean {
		// if the calendar is disabled we can't select this date
		if (this.disabled()) {
			return true;
		}

		// if the date is outside the min and max range
		const min = this.min();
		const max = this.max();

		if (min && this.dateAdapter.isBefore(date, this.dateAdapter.startOfDay(min))) {
			return true;
		}

		if (max && this.dateAdapter.isAfter(date, this.dateAdapter.endOfDay(max))) {
			return true;
		}

		// if this specific date is disabled
		const disabledFn = this.dateDisabled();

		if (disabledFn(date)) {
			return true;
		}

		return false;
	}

	/** @internal Set the focused date */
	setFocusedDate(date: T): void {
		// check if the date is disabled.
		if (this.isDateDisabled(date)) {
			return;
		}

		this.state().focusedDate.set(date);

		// wait until the cells have all updated
		afterNextRender(
			{
				write: () => {
					// focus the cell with the target date.
					const cell = this.cells().find((c) => this.dateAdapter.isSameDay(c.date(), date));

					if (cell) {
						cell.focus();
					}
				},
			},
			{
				injector: this._injector,
			},
		);

		// we must update the view to ensure the focused cell is visible.
		this._changeDetector.detectChanges();
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/calendar/src/lib/i18n/calendar-i18n.ts
```typescript
import { InjectionToken, ValueProvider, inject } from '@angular/core';

export interface BrnCalendarI18n {
	formatWeekdayName: (index: number) => string;
	formatHeader: (month: number, year: number) => string;
	labelPrevious: () => string;
	labelNext: () => string;
	labelWeekday: (index: number) => string;
}

export const BrnCalendarI18nToken = new InjectionToken<BrnCalendarI18n>('BrnCalendarI18nToken');

/**
 * Provide the calendar i18n configuration.
 */
export function provideBrnCalendarI18n(configuration: BrnCalendarI18n): ValueProvider {
	return { provide: BrnCalendarI18nToken, useValue: configuration };
}

const defaultCalendarI18n: BrnCalendarI18n = {
	formatWeekdayName: (index: number) => {
		const weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
		return weekdays[index];
	},
	formatHeader: (month: number, year: number) => {
		return new Date(year, month).toLocaleDateString(undefined, {
			month: 'long',
			year: 'numeric',
		});
	},
	labelPrevious: () => 'Go to the previous month',
	labelNext: () => 'Go to the next month',
	labelWeekday: (index: number) => {
		const weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
		return weekdays[index];
	},
};

/**
 * Inject the calendar i18n configuration.
 */
export function injectBrnCalendarI18n(): BrnCalendarI18n {
	return inject(BrnCalendarI18nToken, { optional: true }) ?? defaultCalendarI18n;
}

```
