/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-aspect-ratio-helm/files/index.ts.template
```
import { NgModule } from '@angular/core';
import { HlmAspectRatioDirective } from './lib/helm-aspect-ratio.directive';

export * from './lib/helm-aspect-ratio.directive';

@NgModule({
	imports: [HlmAspectRatioDirective],
	exports: [HlmAspectRatioDirective],
})
export class HlmAspectRatioModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-aspect-ratio-helm/files/lib/helm-aspect-ratio.directive.spec.ts.template
```
import { Component } from '@angular/core';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { HlmAspectRatioDirective } from './helm-aspect-ratio.directive';

@Component({
	selector: 'hlm-mock',
	standalone: true,
	imports: [HlmAspectRatioDirective],
	template: `
		<div [hlmAspectRatio]="ratio">
			<img
				alt="Sample image"
				src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII="
			/>
		</div>
	`,
})
class MockComponent {
	public ratio: number | undefined = 16 / 9;
}

describe('HelmAspectRatioDirective', () => {
	let component: MockComponent;
	let fixture: ComponentFixture<MockComponent>;

	beforeEach(() => {
		fixture = TestBed.createComponent(MockComponent);
		component = fixture.componentInstance;
	});

	it('should compile', () => {
		expect(component).toBeTruthy();
	});

	it('should show the image', () => {
		fixture.detectChanges();
		const img = fixture.nativeElement.querySelector('img');
		expect(img).toBeTruthy();
	});

	it('should have the correct aspect ratio', () => {
		fixture.detectChanges();
		const div = fixture.nativeElement.querySelector('div');
		expect(div.style.paddingBottom).toEqual(`${100 / (component.ratio || 1)}%`);
	});

	it('should default to an aspect ratio of 1', () => {
		component.ratio = undefined;
		fixture.detectChanges();
		const div = fixture.nativeElement.querySelector('div');
		expect(div.style.paddingBottom).toEqual('100%');
	});

	it('should fallback to an aspect ratio of 1 if the ratio is 0', () => {
		component.ratio = 0;
		fixture.detectChanges();
		const div = fixture.nativeElement.querySelector('div');
		expect(div.style.paddingBottom).toEqual('100%');
	});

	it('should fallback to an aspect ratio of 1 if the ratio is negative', () => {
		component.ratio = -1;
		fixture.detectChanges();
		const div = fixture.nativeElement.querySelector('div');
		expect(div.style.paddingBottom).toEqual('100%');
	});

	it('should add the correct styles to the image', () => {
		fixture.detectChanges();

		const img = fixture.nativeElement.querySelector('img') as HTMLImageElement;
		expect(img.classList.toString()).toBe('absolute w-full h-full object-cover');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/cli/src/generators/ui/libs/ui-aspect-ratio-helm/files/lib/helm-aspect-ratio.directive.ts.template
```
import { type NumberInput, coerceNumberProperty } from '@angular/cdk/coercion';
import { type AfterViewInit, Directive, ElementRef, computed, inject, input } from '@angular/core';
import { hlm } from '@spartan-ng/brain/core';
import type { ClassValue } from 'clsx';

const parseDividedString = (value: NumberInput): NumberInput => {
	if (typeof value !== 'string' || !value.includes('/')) return value;
	return value
		.split('/')
		.map((v) => Number.parseInt(v, 10))
		.reduce((a, b) => a / b);
};

@Directive({
	selector: '[hlmAspectRatio]',
	standalone: true,
	host: {
		'[class]': '_computedClass()',
		'[style.padding-bottom]': '_computedPaddingBottom()',
	},
})
export class HlmAspectRatioDirective implements AfterViewInit {
	private readonly _el = inject<ElementRef<HTMLElement>>(ElementRef).nativeElement;

	public readonly ratio = input(1, {
		alias: 'hlmAspectRatio',
		transform: (value: NumberInput) => {
			const coerced = coerceNumberProperty(parseDividedString(value));
			return coerced <= 0 ? 1 : coerced;
		},
	});
	protected readonly _computedPaddingBottom = computed(() => `${100 / this.ratio()}%`);

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	protected readonly _computedClass = computed(() => hlm('relative w-full', this.userClass()));

	ngAfterViewInit() {
		// support delayed addition of image to dom
		const child = this._el.firstElementChild;
		if (child) {
			child.classList.add('absolute', 'w-full', 'h-full', 'object-cover');
		}
	}
}

```
