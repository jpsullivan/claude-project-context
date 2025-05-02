/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-cell-def.directive.ts
```typescript
import { CdkCellDef } from '@angular/cdk/table';
import { Directive, TemplateRef, inject } from '@angular/core';

@Directive({
	standalone: true,
	selector: '[brnCellDef]',
	exportAs: 'brnCellDef',
})
export class BrnCellDefDirective extends CdkCellDef {
	public override template: TemplateRef<unknown>;

	constructor() {
		const template = inject<TemplateRef<unknown>>(TemplateRef);

		super(template);
		this.template = template;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-column-def.component.ts
```typescript
import {
	type CdkCellDef,
	CdkColumnDef,
	type CdkFooterCellDef,
	type CdkHeaderCellDef,
	CdkTableModule,
} from '@angular/cdk/table';
import {
	type AfterContentChecked,
	ChangeDetectionStrategy,
	Component,
	ContentChild,
	Input,
	ViewChild,
	ViewEncapsulation,
	input,
} from '@angular/core';
import { BrnCellDefDirective } from './brn-cell-def.directive';
import { BrnFooterDefDirective } from './brn-footer-def.directive';
import { BrnHeaderDefDirective } from './brn-header-def.directive';

@Component({
	selector: 'brn-column-def',
	imports: [CdkTableModule],
	template: `
		<ng-container [cdkColumnDef]="name">
			<ng-content select="[brnHeaderDef]" />
			<ng-content select="[brnCellDef]" />
			<ng-content select="[brnFooterDef]" />
		</ng-container>
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnColumnDefComponent implements AfterContentChecked {
	public get columnDef() {
		return this._columnDef;
	}

	public get cell() {
		return this._columnDef.cell;
	}

	private _name = '';
	@Input()
	public get name(): string {
		return this._name;
	}

	public set name(value: string) {
		this._name = value;
		if (!this._columnDef) return;
		this._columnDef.name = value;
	}

	public readonly class = input('');

	@ViewChild(CdkColumnDef, { static: true })
	private readonly _columnDef!: CdkColumnDef;

	@ContentChild(BrnCellDefDirective, { static: true })
	private readonly _cellDef?: CdkCellDef;
	@ContentChild(BrnFooterDefDirective, { static: true })
	private readonly _footerCellDef?: CdkFooterCellDef;
	@ContentChild(BrnHeaderDefDirective, { static: true })
	private readonly _headerCellDef?: CdkHeaderCellDef;

	public ngAfterContentChecked(): void {
		this._columnDef.name = this.name;
		if (this._cellDef) {
			this._columnDef.cell = this._cellDef;
		}
		if (this._headerCellDef) {
			this._columnDef.headerCell = this._headerCellDef;
		}
		if (this._footerCellDef) {
			this._columnDef.footerCell = this._footerCellDef;
		}
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-column-manager.spec.ts
```typescript
import { useBrnColumnManager } from './brn-column-manager';

describe('BrnColumnManager', () => {
	it('should initialize with a Record of column names to booleans', () => {
		const columnManager = useBrnColumnManager({
			name: true,
			age: false,
		});

		expect(columnManager.allColumns).toEqual(['name', 'age']);
		expect(columnManager.displayedColumns()).toEqual(['name']);
		expect(columnManager.isColumnVisible('name')).toBe(true);
		expect(columnManager.isColumnVisible('age')).toBe(false);
	});

	it('should initialize with a Record of column names to objects', () => {
		const columnManager = useBrnColumnManager({
			name: { visible: true },
			age: { visible: false },
		});

		expect(columnManager.allColumns).toEqual([
			{ name: 'name', visible: true },
			{ name: 'age', visible: false },
		]);
		expect(columnManager.displayedColumns()).toEqual(['name']);
		expect(columnManager.isColumnVisible('name')).toBe(true);
		expect(columnManager.isColumnVisible('age')).toBe(false);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-column-manager.ts
```typescript
import { type Signal, computed, signal } from '@angular/core';

type BrnColumnVisibility = Record<string, boolean> | Record<string, { visible: boolean }>;

// prettier-ignore
type AllColumnsPropertyType<T> = T extends Record<string, boolean>
	? (keyof T)[]
	: T extends Record<string, infer R>
		? (R extends { visible: boolean } ? { name: keyof T } & R : never)[]
		: never;

export class BrnColumnManager<T extends BrnColumnVisibility> {
	private readonly _initialColumnVisibility: T;
	private readonly _columnVisibility;

	public readonly allColumns: AllColumnsPropertyType<T>;
	public readonly columnVisibility;
	public readonly displayedColumns: Signal<(keyof T)[]> = computed(() => {
		return Object.entries(this._columnVisibility())
			.filter(([, value]) => (typeof value === 'boolean' ? value : value.visible))
			.map(([key]) => key);
	});

	constructor(initialColumnVisibility: T) {
		this._initialColumnVisibility = initialColumnVisibility;
		this._columnVisibility = signal(this._initialColumnVisibility);
		this._columnVisibility.set(this._initialColumnVisibility);
		this.columnVisibility = this._columnVisibility.asReadonly();
		this.allColumns = this.createAllColumns(this._initialColumnVisibility);
	}

	public readonly isColumnVisible = (columnName: string) => {
		const visibilityMap = this.columnVisibility();
		const columnEntry = visibilityMap[columnName];
		return typeof columnEntry === 'boolean' ? columnEntry : columnEntry.visible;
	};
	public readonly isColumnDisabled = (columnName: string) =>
		this.isColumnVisible(columnName) && this.displayedColumns().length === 1;

	public toggleVisibility(columnName: keyof T) {
		const visibilityMap = this._columnVisibility();
		const columnEntry = visibilityMap[columnName];
		const newVisibilityState = typeof columnEntry === 'boolean' ? !columnEntry : { visible: !columnEntry.visible };
		this._columnVisibility.set({ ...visibilityMap, [columnName]: newVisibilityState });
	}
	public setVisible(columnName: keyof T) {
		const visibilityMap = this._columnVisibility();
		const columnEntry = visibilityMap[columnName];
		const newVisibilityState = typeof columnEntry === 'boolean' ? true : { visible: true };
		this._columnVisibility.set({ ...visibilityMap, [columnName]: newVisibilityState });
	}
	public setInvisible(columnName: keyof T) {
		const visibilityMap = this._columnVisibility();
		const columnEntry = visibilityMap[columnName];
		const newVisibilityState = typeof columnEntry === 'boolean' ? false : { visible: false };
		this._columnVisibility.set({ ...visibilityMap, [columnName]: newVisibilityState });
	}

	private createAllColumns(initialColumnVisibility: T): AllColumnsPropertyType<T> {
		const keys = Object.keys(initialColumnVisibility) as (keyof T)[];
		if (this.isBooleanConfig(initialColumnVisibility)) {
			return keys as unknown as AllColumnsPropertyType<T>;
		}
		return keys.map((key) => {
			const values = initialColumnVisibility[key] as { visible: boolean };
			return {
				name: key,
				...values,
			};
		}) as AllColumnsPropertyType<T>;
	}

	private isBooleanConfig(config: any): config is Record<string, boolean> {
		return typeof Object.values(config)[0] === 'boolean';
	}
}

export const useBrnColumnManager = <T extends BrnColumnVisibility>(initialColumnVisibility: T) =>
	new BrnColumnManager(initialColumnVisibility);

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-footer-def.directive.ts
```typescript
import { CdkFooterCellDef } from '@angular/cdk/table';
import { Directive, TemplateRef, inject } from '@angular/core';

@Directive({
	standalone: true,
	selector: '[brnFooterDef]',
	exportAs: 'brnFooterDef',
})
export class BrnFooterDefDirective extends CdkFooterCellDef {
	public override template: TemplateRef<unknown>;

	constructor() {
		const template = inject<TemplateRef<unknown>>(TemplateRef);

		super(template);
		this.template = template;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-header-def.directive.ts
```typescript
import { CdkHeaderCellDef } from '@angular/cdk/table';
import { Directive, TemplateRef, inject } from '@angular/core';

@Directive({
	standalone: true,
	selector: '[brnHeaderDef]',
	exportAs: 'brnHeaderDef',
})
export class BrnHeaderDefDirective extends CdkHeaderCellDef {
	public override template: TemplateRef<unknown>;

	constructor() {
		const template = inject<TemplateRef<unknown>>(TemplateRef);

		super(template);
		this.template = template;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-paginator.directive.ts
```typescript
import {
	Directive,
	Input,
	type OnInit,
	type Signal,
	TemplateRef,
	ViewContainerRef,
	computed,
	effect,
	inject,
	numberAttribute,
	signal,
	untracked,
} from '@angular/core';

export type PaginatorState = {
	currentPage: number;
	startIndex: number;
	endIndex: number;
	pageSize: number;
	totalPages: number;
	totalElements: number | null | undefined;
};

export type PaginatorContext = {
	$implicit: {
		state: Signal<PaginatorState>;
		incrementable: Signal<boolean>;
		decrementable: Signal<boolean>;
		increment: () => void;
		decrement: () => void;
	};
};

@Directive({
	standalone: true,
	selector: '[brnPaginator]',
	exportAs: 'brnPaginator',
})
export class BrnPaginatorDirective implements OnInit {
	static ngTemplateContextGuard(_directive: BrnPaginatorDirective, _context: unknown): _context is PaginatorContext {
		return true;
	}

	private readonly _vcr = inject(ViewContainerRef);
	private readonly _template = inject(TemplateRef<unknown>);

	private readonly _state = signal<PaginatorState>({
		currentPage: 0,
		startIndex: 0,
		endIndex: 0,
		pageSize: 10,
		totalPages: 0,
		totalElements: null,
	});
	private readonly _decrementable = computed(() => 0 < this._state().startIndex);
	private readonly _incrementable = computed(() => this._state().endIndex < (this._state().totalElements ?? 0) - 1);

	@Input({ alias: 'brnPaginatorTotalElements' })
	public set totalElements(value: number | null | undefined) {
		this.calculateNewState({ newTotalElements: value, newPage: 0 });
	}

	@Input({ alias: 'brnPaginatorCurrentPage', transform: numberAttribute })
	public set currentPage(value: number) {
		this.calculateNewState({ newPage: value });
	}

	@Input({ alias: 'brnPaginatorPageSize', transform: numberAttribute })
	public set pageSize(value: number) {
		this.calculateNewState({ newPageSize: value, newPage: 0 });
	}

	@Input({ alias: 'brnPaginatorOnStateChange' })
	public onStateChange?: (state: PaginatorState) => void;

	constructor() {
		effect(() => {
			const state = this._state();
			untracked(() => {
				Promise.resolve().then(() => {
					if (this.onStateChange) {
						this.onStateChange(state);
					}
				});
			});
		});
	}

	public ngOnInit() {
		this._vcr.createEmbeddedView<PaginatorContext>(this._template, {
			$implicit: {
				state: this._state,
				increment: () => this.incrementPage(),
				decrement: () => this.decrementPage(),
				incrementable: this._incrementable,
				decrementable: this._decrementable,
			},
		});
	}

	public decrementPage(): void {
		const { currentPage } = this._state();
		if (0 < currentPage) {
			this.calculateNewState({ newPage: currentPage - 1 });
		}
	}

	public incrementPage(): void {
		const { currentPage, totalPages } = this._state();
		if (totalPages > currentPage) {
			this.calculateNewState({ newPage: currentPage + 1 });
		}
	}

	public reset(): void {
		this.currentPage = 0;
	}

	private calculateNewState({
		newPage,
		newPageSize,
		newTotalElements,
	}: Partial<{
		newPage: number;
		newPageSize: number;
		newTotalElements: number | null | undefined;
	}>) {
		const previousState = this._state();

		let currentPage = newPage ?? previousState.currentPage;
		const pageSize = newPageSize ?? previousState.pageSize;
		const totalElements = newTotalElements ?? previousState.totalElements ?? 0;

		const newTotalPages = totalElements ? Math.floor(totalElements / pageSize) : 0;

		if (newTotalPages < currentPage - 1) {
			currentPage = newTotalPages - 1;
		}

		const newStartIndex = totalElements === 0 ? 0 : Math.min(totalElements - 1, currentPage * pageSize);
		const newEndIndex = Math.min((currentPage + 1) * pageSize - 1, totalElements - 1);

		const newState = {
			currentPage: currentPage,
			startIndex: newStartIndex,
			endIndex: newEndIndex,
			pageSize: pageSize,
			totalPages: newTotalPages,
			totalElements: totalElements,
		};

		this._state.set(newState);
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/table/src/lib/brn-table.component.ts
```typescript
import { CdkRowDef, CdkTable, type CdkTableDataSourceInput, CdkTableModule } from '@angular/cdk/table';
import {
	type AfterContentInit,
	ChangeDetectionStrategy,
	Component,
	ContentChildren,
	EventEmitter,
	Input,
	Output,
	type QueryList,
	type TrackByFunction,
	ViewChild,
	ViewEncapsulation,
	booleanAttribute,
} from '@angular/core';
import { type TableClassesSettable, provideTableClassesSettableExisting } from '@spartan-ng/brain/core';
import { BrnColumnDefComponent } from './brn-column-def.component';

export type BrnTableDataSourceInput<T> = CdkTableDataSourceInput<T>;

@Component({
	selector: 'brn-table',
	imports: [CdkTableModule],
	providers: [provideTableClassesSettableExisting(<T>() => BrnTableComponent<T>)],
	template: `
		<cdk-table
			#cdkTable
			[class]="tableClasses"
			[dataSource]="dataSource"
			[fixedLayout]="fixedLayout"
			[multiTemplateDataRows]="multiTemplateDataRows"
			(contentChanged)="contentChanged.emit()"
		>
			<ng-content />

			<cdk-header-row [class]="headerRowClasses" *cdkHeaderRowDef="displayedColumns; sticky: stickyHeader" />
			@if (!customTemplateDataRows) {
				<cdk-row
					[tabindex]="!!onRowClick ? 0 : -1"
					[attr.role]="!!onRowClick ? 'button' : 'row'"
					[class.row-interactive]="!!onRowClick"
					(keydown.enter)="!!onRowClick && onRowClick(row)"
					(click)="!!onRowClick && onRowClick(row)"
					[class]="bodyRowClasses"
					*cdkRowDef="let row; columns: displayedColumns"
				/>
			}

			<ng-template cdkNoDataRow>
				<ng-content select="[brnNoDataRow]" />
			</ng-template>
		</cdk-table>
	`,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
})
export class BrnTableComponent<T> implements TableClassesSettable, AfterContentInit {
	@ViewChild('cdkTable', { read: CdkTable, static: true })
	private readonly _cdkTable?: CdkTable<T>;
	// Cdk Table Inputs / Outputs
	@Input()
	public dataSource: BrnTableDataSourceInput<T> = [];
	@Input({ transform: booleanAttribute })
	public fixedLayout = false;
	@Input({ transform: booleanAttribute })
	public multiTemplateDataRows = false;
	@Input()
	public displayedColumns: string[] = [];

	private _trackBy?: TrackByFunction<T>;
	public get trackBy(): TrackByFunction<T> | undefined {
		return this._trackBy;
	}

	@Input()
	public set trackBy(value: TrackByFunction<T>) {
		this._trackBy = value;
		if (this._cdkTable) {
			this._cdkTable.trackBy = this._trackBy;
		}
	}

	@Output()
	public readonly contentChanged: EventEmitter<void> = new EventEmitter<void>();

	// Brn Inputs / Outputs
	@Input({ transform: booleanAttribute })
	public customTemplateDataRows = false;
	@Input()
	public onRowClick: ((element: T) => void) | undefined;

	@Input({ transform: booleanAttribute })
	public stickyHeader = false;
	@Input()
	public tableClasses = '';
	@Input()
	public headerRowClasses = '';
	@Input()
	public bodyRowClasses = '';

	@ContentChildren(BrnColumnDefComponent) public columnDefComponents!: QueryList<BrnColumnDefComponent>;
	@ContentChildren(CdkRowDef) public rowDefs!: QueryList<CdkRowDef<T>>;

	// after the <ng-content> has been initialized, the column definitions are available.
	// All that's left is to add them to the table ourselves:
	public ngAfterContentInit(): void {
		this.columnDefComponents.forEach((component) => {
			if (!this._cdkTable) return;
			if (component.cell) {
				this._cdkTable.addColumnDef(component.columnDef);
			}
		});
		this.rowDefs.forEach((rowDef) => {
			if (!this._cdkTable) return;
			this._cdkTable.addRowDef(rowDef);
		});
	}

	public setTableClasses({
		table,
		headerRow,
		bodyRow,
	}: Partial<{ table: string; headerRow: string; bodyRow: string }>): void {
		if (table) {
			this.tableClasses = table;
		}
		if (headerRow) {
			this.headerRowClasses = headerRow;
		}
		if (bodyRow) {
			this.bodyRowClasses = bodyRow;
		}
	}
}

```
