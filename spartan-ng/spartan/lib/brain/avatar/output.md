/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/README.md
```
# @spartan-ng/brain/avatar

Secondary entry point of `@spartan-ng/brain`. It can be used by importing from `@spartan-ng/brain/avatar`.

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/ng-package.json
```json
{
	"lib": {
		"entryFile": "src/index.ts"
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/index.ts
```typescript
import { NgModule } from '@angular/core';

import { BrnAvatarComponent } from './lib/brn-avatar.component';
import { BrnAvatarFallbackDirective } from './lib/fallback';
import { BrnAvatarImageDirective } from './lib/image';

export * from './lib/brn-avatar.component';
export * from './lib/fallback';
export * from './lib/image';
export * from './lib/util';

export const BrnAvatarImports = [BrnAvatarComponent, BrnAvatarFallbackDirective, BrnAvatarImageDirective] as const;

@NgModule({
	imports: [...BrnAvatarImports],
	exports: [...BrnAvatarImports],
})
export class BrnAvatarModule {}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/brn-avatar.component.spec.ts
```typescript
import { Component } from '@angular/core';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { BrnAvatarComponent } from './brn-avatar.component';
import { BrnAvatarFallbackDirective } from './fallback/brn-avatar-fallback.directive';
import { BrnAvatarImageDirective } from './image/brn-avatar-image.directive';

@Component({
	selector: 'brn-mock',
	imports: [BrnAvatarImageDirective, BrnAvatarFallbackDirective, BrnAvatarComponent],
	template: `
		<brn-avatar id="empty">
			<p>empty</p>
		</brn-avatar>
		<brn-avatar id="fallbackOnly">
			<span brnAvatarFallback>fallback</span>
		</brn-avatar>
		<brn-avatar id="noSrc">
			<img brnAvatarImage alt="Avatar image" />
			<span brnAvatarFallback>fallback</span>
		</brn-avatar>
		<brn-avatar id="good">
			<img
				brnAvatarImage
				alt="Avatar image"
				src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII="
			/>
			<span brnAvatarFallback>fallback</span>
		</brn-avatar>
	`,
	standalone: true,
})
class MockComponent {}

describe('BrnAvatarComponent', () => {
	let component: MockComponent;
	let fixture: ComponentFixture<MockComponent>;

	beforeEach(() => {
		fixture = TestBed.createComponent(MockComponent);
		component = fixture.componentInstance;
		fixture.autoDetectChanges();
	});
	it('should compile', () => {
		expect(component).toBeTruthy();
	});

	it('should render the fallback when no image is provided', () => {
		const fallback = fixture.nativeElement.querySelector('#fallbackOnly span');
		expect(fallback.textContent).toEqual('fallback');
	});

	it('should not render anything when no image or fallback is provided', () => {
		const empty = fixture.nativeElement.querySelector('#empty p');
		expect(empty).toBeFalsy();
	});

	it('should render the fallback when provided and image with no src', () => {
		const fallback = fixture.nativeElement.querySelector('#noSrc span');
		expect(fallback.textContent).toEqual('fallback');
	});

	it('should not render the fallback, but rather the image when provided with a valid src', () => {
		// delay test to allow for image to resolve
		setTimeout(() => {
			const img = fixture.debugElement.query(By.css('#good img'));
			expect(img).toBeTruthy();
			const fallback = fixture.nativeElement.querySelector('#good span');
			expect(fallback).toBeFalsy();
		});
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/brn-avatar.component.ts
```typescript
import { ChangeDetectionStrategy, Component, ViewEncapsulation, contentChild } from '@angular/core';
import { BrnAvatarImageDirective } from './image';

@Component({
	selector: 'brn-avatar',
	standalone: true,
	changeDetection: ChangeDetectionStrategy.OnPush,
	encapsulation: ViewEncapsulation.None,
	template: `
		@if (image()?.canShow()) {
			<ng-content select="[brnAvatarImage]" />
		} @else {
			<ng-content select="[brnAvatarFallback]" />
		}
	`,
})
export class BrnAvatarComponent {
	protected readonly image = contentChild(BrnAvatarImageDirective);
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/util/hex-color-for.spec.ts
```typescript
import { faker } from '@faker-js/faker';
import { hexColorFor } from './hex-color-for';

describe('hexColorFor', () => {
	it('should return a text color of white and a pink-ish background for John Doe', () => {
		const generated = hexColorFor('John Doe');
		expect(generated).toBe('#a55c80');
	});

	it('should return a text color of white and a blue-ish background for Jane Doe', () => {
		const generated = hexColorFor('Jane Doe');
		expect(generated).toBe('#485fa7');
	});

	it('should return different colors for different names', () => {
		expect(hexColorFor(faker.person.fullName())).not.toBe(hexColorFor(faker.person.fullName()));
	});

	it('should return the same style when given the same name', () => {
		const name = faker.person.fullName();
		expect(hexColorFor(name)).toBe(hexColorFor(name));
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/util/hex-color-for.ts
```typescript
function hashString(str: string) {
	let h;
	for (let i = 0; i < str.length; i++) h = (Math.imul(31, h || 0) + str.charCodeAt(i)) | 0;

	return h || 0;
}

function hashManyTimes(times: number, str: string) {
	let h = hashString(str);

	for (let i = 0; i < times; i++) h = hashString(String(h));

	return h;
}

export function hexColorFor(str: string) {
	const hash = str.length <= 2 ? hashManyTimes(5, str) : hashString(str);

	let color = '#';

	for (let i = 0; i < 3; i += 1) {
		const value = (hash >> (i * 8)) & 0xff;
		color += `00${value.toString(16)}`.slice(-2);
	}

	return color;
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/util/index.ts
```typescript
export * from './hex-color-for';
export * from './initials.pipe';
export * from './is-bright';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/util/initials.pipe.spec.ts
```typescript
import { faker } from '@faker-js/faker';
import { InitialsPipe } from './initials.pipe';

describe('InitialsPipe', () => {
	const pipe = new InitialsPipe();

	it('should compile', () => {
		expect(pipe).toBeTruthy();
	});

	it('should return an empty string, when an empty string is provided', () => {
		expect(pipe.transform('')).toBe('');
		expect(pipe.transform(' ')).toBe('');
	});

	it.skip('should return the uppercased initials of a provided name', () => {
		const name = 'John Doe';
		const otherName = 'Mary Ann Smith';
		const randomName = faker.person.fullName();

		expect(pipe.transform(name)).toBe('JD');
		expect(pipe.transform(otherName)).toBe('MS');
		expect(pipe.transform(randomName)).toBe(
			`${randomName.charAt(0).toLocaleUpperCase()}${randomName.charAt(randomName.indexOf(' ') + 1).toLocaleUpperCase()}`,
		);
	});

	it('should not capitalize the initials, when the capitalize flag is set to false', () => {
		const name = 'john Doe';
		const otherName = 'mary ann smith';
		const randomName = `${faker.person.firstName()} ${faker.person.lastName()}`;

		expect(pipe.transform(name, false)).toBe('jD');
		expect(pipe.transform(otherName, false)).toBe('ms');
		expect(pipe.transform(randomName, false)).toBe(
			`${randomName.charAt(0)}${randomName.charAt(randomName.lastIndexOf(' ') + 1)}`,
		);
	});

	it('should return all initials when the firstAndLastOnly flag is set to false', () => {
		const name = 'Mary Ann       Smith';

		expect(pipe.transform(name, true, false)).toBe('MAS');
	});

	it('should split the name by the provided delimiter', () => {
		const name = 'Mary:Ann:Smith: ';

		expect(pipe.transform(name, true, true, ':')).toBe('MS');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/util/initials.pipe.ts
```typescript
import { Pipe, type PipeTransform } from '@angular/core';

const toInitial =
	(capitalize = true) =>
	(word: string) => {
		const initial = word.charAt(0);
		return capitalize ? initial.toLocaleUpperCase() : initial;
	};

const firstAndLast = (initials: string[]) => `${initials[0]}${initials[initials.length - 1]}`;

@Pipe({
	name: 'initials',
	standalone: true,
})
export class InitialsPipe implements PipeTransform {
	transform(name: string, capitalize = true, firstAndLastOnly = true, delimiter = ' '): string {
		if (!name) return '';

		const initials = name.trim().split(delimiter).filter(Boolean).map(toInitial(capitalize));

		if (firstAndLastOnly && initials.length > 1) return firstAndLast(initials);

		return initials.join('');
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/util/is-bright.spec.ts
```typescript
import { isBright } from './is-bright';

describe('isBright', () => {
	it('should return true for white hex code', () => {
		expect(isBright('#ffffff')).toBe(true);
	});

	it('should return false for black hex code', () => {
		expect(isBright('#000000')).toBe(false);
	});

	it('should return true for a light hex code', () => {
		expect(isBright('#e394bb')).toBe(true);
	});

	it('should return false for a dark hex code', () => {
		expect(isBright('#485fa7')).toBe(false);
	});

	it('should support hex color shorthand, with our without hash & ignore capitalization', () => {
		expect(isBright('ffffff')).toBe(true);
		expect(isBright('#fff')).toBe(true);
		expect(isBright('fff')).toBe(true);
		expect(isBright('#FFF')).toBe(true);
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/util/is-bright.ts
```typescript
const isShortHand = (hex: string) => hex.length === 3;

const cleanup = (hex: string) => {
	const noHash = hex.replace('#', '').trim().toLowerCase();

	if (!isShortHand(noHash)) return noHash;

	return noHash
		.split('')
		.map((char) => char + char)
		.join('');
};

export const isBright = (hex: string) => Number.parseInt(cleanup(hex), 16) > 0xffffff / 1.25;

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/fallback/brn-avatar-fallback.directive.spec.ts
```typescript
import { Component, PLATFORM_ID } from '@angular/core';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { BrnAvatarFallbackDirective } from './brn-avatar-fallback.directive';

@Component({
	selector: 'brn-mock',
	standalone: true,
	imports: [BrnAvatarFallbackDirective],
	template: `
		<span *brnAvatarFallback>fallback</span>
		<span brnAvatarFallback>fallback2</span>
	`,
})
class BrnMockComponent {}

describe('BrnAvatarFallbackDirective', () => {
	let component: BrnMockComponent;
	let fixture: ComponentFixture<BrnMockComponent>;

	beforeEach(() => {
		fixture = TestBed.overrideProvider(PLATFORM_ID, { useValue: 'browser' }).createComponent(BrnMockComponent);
		component = fixture.componentInstance;
	});

	it('should compile', () => {
		expect(component).toBeTruthy();
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/fallback/brn-avatar-fallback.directive.ts
```typescript
import { BooleanInput } from '@angular/cdk/coercion';
import { Directive, ElementRef, booleanAttribute, inject, input } from '@angular/core';
import type { ClassValue } from 'clsx';

@Directive({
	selector: '[brnAvatarFallback]',
	standalone: true,
	exportAs: 'avatarFallback',
})
export class BrnAvatarFallbackDirective {
	private readonly _element = inject(ElementRef).nativeElement;

	public readonly userClass = input<ClassValue>('', { alias: 'class' });
	public readonly autoColor = input<boolean, BooleanInput>(false, { transform: booleanAttribute });

	getTextContent(): string {
		return this._element.textContent;
	}
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/fallback/index.ts
```typescript
export * from './brn-avatar-fallback.directive';

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/image/brn-avatar-image.directive.spec.ts
```typescript
import { Component } from '@angular/core';
import { type ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { BrnAvatarImageDirective } from './brn-avatar-image.directive';

@Component({
	selector: 'brn-mock',
	standalone: true,
	imports: [BrnAvatarImageDirective],
	template: `
		<div id="bad">
			<img brnAvatarImage #bad="avatarImage" alt="Avatar image" />
			<span>{{ bad.canShow() }}</span>
		</div>
		<div id="unloaded">
			<img
				src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII="
				brnAvatarImage
				alt="Avatar image"
				#unloaded="avatarImage"
			/>
			<span>{{ unloaded.canShow() }}</span>
		</div>
		<div id="loaded">
			<img
				src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII="
				brnAvatarImage
				alt="Avatar image"
				#good="avatarImage"
			/>
			<span>{{ good.canShow() }}</span>
		</div>
	`,
})
class BrnMockComponent {}

describe('BrnAvatarImageDirective', () => {
	let component: BrnMockComponent;
	let fixture: ComponentFixture<BrnMockComponent>;

	beforeEach(() => {
		fixture = TestBed.createComponent(BrnMockComponent);
		component = fixture.componentInstance;
	});

	it('should compile', () => {
		expect(component).toBeTruthy();
	});

	it('should return false when image has no src', () => {
		fixture.detectChanges();
		const bad = fixture.nativeElement.querySelector('#bad');
		expect(bad.querySelector('span').textContent).toEqual('false');
	});

	it('should return false when image has a valid src but isnt loaded', async () => {
		fixture.detectChanges();
		await fixture.whenRenderingDone();
		const unloaded = fixture.nativeElement.querySelector('#unloaded');
		expect(unloaded.querySelector('span').textContent).toEqual('false');
	});

	it('should return true when the image is loaded without error', async () => {
		fixture.debugElement.query(By.css('#loaded img')).triggerEventHandler('load', null);
		fixture.detectChanges();
		const unloaded = fixture.nativeElement.querySelector('#loaded');
		expect(unloaded.querySelector('span').textContent).toEqual('true');
	});
});

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/image/brn-avatar-image.directive.ts
```typescript
import { Directive, HostListener, computed, signal } from '@angular/core';

@Directive({
	selector: 'img[brnAvatarImage]',
	standalone: true,
	exportAs: 'avatarImage',
})
export class BrnAvatarImageDirective {
	private readonly _loaded = signal(false);

	@HostListener('error')
	private onError() {
		this._loaded.set(false);
	}

	@HostListener('load')
	private onLoad() {
		this._loaded.set(true);
	}

	public canShow = computed(() => this._loaded());
}

```
/Users/josh/Documents/GitHub/spartan-ng/spartan/libs/brain/avatar/src/lib/image/index.ts
```typescript
export * from './brn-avatar-image.directive';

```
