/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/radix-ui/CHANGELOG.md
````
# radix-ui

## 1.3.3

- Updated dependencies: `@radix-ui/react-one-time-password-field@0.1.3`, `@radix-ui/react-roving-focus@1.1.7`, `@radix-ui/react-menu@2.1.11`, `@radix-ui/react-menubar@1.1.11`, `@radix-ui/react-radio-group@1.3.3`, `@radix-ui/react-tabs@1.1.8`, `@radix-ui/react-toggle-group@1.1.7`, `@radix-ui/react-toolbar@1.1.7`, `@radix-ui/react-context-menu@2.2.11`, `@radix-ui/react-dropdown-menu@2.1.11`

## 1.3.2

- Updated dependencies: `@radix-ui/react-use-effect-event@0.0.2`, `@radix-ui/react-avatar@1.1.6`, `@radix-ui/react-one-time-password-field@0.1.2`, `@radix-ui/react-use-controllable-state@1.2.2`, `@radix-ui/react-accordion@1.2.7`, `@radix-ui/react-checkbox@1.2.2`, `@radix-ui/react-collapsible@1.1.7`, `@radix-ui/react-context-menu@2.2.10`, `@radix-ui/react-dialog@1.1.10`, `@radix-ui/react-dropdown-menu@2.1.10`, `@radix-ui/react-hover-card@1.1.10`, `@radix-ui/react-menubar@1.1.10`, `@radix-ui/react-navigation-menu@1.2.9`, `@radix-ui/react-popover@1.1.10`, `@radix-ui/react-radio-group@1.3.2`, `@radix-ui/react-roving-focus@1.1.6`, `@radix-ui/react-select@2.2.2`, `@radix-ui/react-slider@1.3.2`, `@radix-ui/react-switch@1.2.2`, `@radix-ui/react-tabs@1.1.7`, `@radix-ui/react-toast@1.2.10`, `@radix-ui/react-toggle@1.1.6`, `@radix-ui/react-toggle-group@1.1.6`, `@radix-ui/react-tooltip@1.2.3`, `@radix-ui/react-alert-dialog@1.1.10`, `@radix-ui/react-menu@2.1.10`, `@radix-ui/react-toolbar@1.1.6`

## 1.3.1

- Updated dependencies: `@radix-ui/react-use-effect-event@0.0.1`, `@radix-ui/react-one-time-password-field@0.1.1`, `@radix-ui/react-use-controllable-state@1.2.1`, `@radix-ui/react-accordion@1.2.6`, `@radix-ui/react-checkbox@1.2.1`, `@radix-ui/react-collapsible@1.1.6`, `@radix-ui/react-context-menu@2.2.9`, `@radix-ui/react-dialog@1.1.9`, `@radix-ui/react-dropdown-menu@2.1.9`, `@radix-ui/react-hover-card@1.1.9`, `@radix-ui/react-menubar@1.1.9`, `@radix-ui/react-navigation-menu@1.2.8`, `@radix-ui/react-popover@1.1.9`, `@radix-ui/react-radio-group@1.3.1`, `@radix-ui/react-roving-focus@1.1.5`, `@radix-ui/react-select@2.2.1`, `@radix-ui/react-slider@1.3.1`, `@radix-ui/react-switch@1.2.1`, `@radix-ui/react-tabs@1.1.6`, `@radix-ui/react-toast@1.2.9`, `@radix-ui/react-toggle@1.1.5`, `@radix-ui/react-toggle-group@1.1.5`, `@radix-ui/react-tooltip@1.2.2`, `@radix-ui/react-alert-dialog@1.1.9`, `@radix-ui/react-menu@2.1.9`, `@radix-ui/react-toolbar@1.1.5`

## 1.3.0

### Introduce new One Time Password Field primitive

This new primitive is designed to implement the common design pattern for one-time password fields displayed as separate input fields for each character. This UI is deceptively complex to implement so that interactions follow user expectations. The new primitive handles all of this complexity for you, including:

- Keyboard navigation mimicking the behavior of a single input field
- Overriding values on paste
- Password manager autofill support
- Input validation for numeric and alphanumeric values
- Auto-submit on completion
- Focus management
- Hidden input to provide a single value to form data

This API is currently unstable, and we hope you'll help us test it out! Import the primitive using the `unstable_` prefix.

```tsx
import { unstable_OneTimePasswordField as OneTimePasswordField } from 'radix-ui';

export function Verify() {
  return (
    <OneTimePasswordField.Root>
      <OneTimePasswordField.Input />
      <OneTimePasswordField.Input />
      <OneTimePasswordField.Input />
      <OneTimePasswordField.Input />
      <OneTimePasswordField.Input />
      <OneTimePasswordField.Input />
      <OneTimePasswordField.HiddenInput />
    </OneTimePasswordField.Root>
  );
}
```

### Other updates

- Updated dependencies: `@radix-ui/react-collection@1.1.4`, `@radix-ui/react-use-controllable-state@1.2.0`, `@radix-ui/react-navigation-menu@1.2.7`, `@radix-ui/react-dropdown-menu@2.1.8`, `@radix-ui/react-context-menu@2.2.8`, `@radix-ui/react-roving-focus@1.1.4`, `@radix-ui/react-toggle-group@1.1.4`, `@radix-ui/react-collapsible@1.1.5`, `@radix-ui/react-radio-group@1.3.0`, `@radix-ui/react-hover-card@1.1.8`, `@radix-ui/react-accordion@1.2.5`, `@radix-ui/react-checkbox@1.2.0`, `@radix-ui/react-menubar@1.1.8`, `@radix-ui/react-popover@1.1.8`, `@radix-ui/react-tooltip@1.2.1`, `@radix-ui/react-dialog@1.1.8`, `@radix-ui/react-select@2.2.0`, `@radix-ui/react-switch@1.2.0`, `@radix-ui/react-toggle@1.1.4`, `@radix-ui/react-toast@1.2.8`, `@radix-ui/react-tabs@1.1.5`, `@radix-ui/react-one-time-password-field@0.1.0`, `@radix-ui/react-visually-hidden@1.2.0`, `@radix-ui/react-primitive@2.1.0`, `@radix-ui/react-slider@1.3.0`, `@radix-ui/react-menu@2.1.8`, `@radix-ui/react-toolbar@1.1.4`, `@radix-ui/react-alert-dialog@1.1.8`, `@radix-ui/react-accessible-icon@1.1.4`, `@radix-ui/react-arrow@1.1.4`, `@radix-ui/react-aspect-ratio@1.1.4`, `@radix-ui/react-avatar@1.1.5`, `@radix-ui/react-dismissable-layer@1.1.7`, `@radix-ui/react-focus-scope@1.1.4`, `@radix-ui/react-form@0.1.4`, `@radix-ui/react-label@2.1.4`, `@radix-ui/react-popper@1.2.4`, `@radix-ui/react-portal@1.1.6`, `@radix-ui/react-progress@1.1.4`, `@radix-ui/react-scroll-area@1.2.5`, `@radix-ui/react-separator@1.1.4`

````
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/radix-ui/README.md
```
[![Radix Primitives Logo](https://raw.githubusercontent.com/radix-ui/primitives/main/primitives.png)](https://radix-ui.com/primitives)

# Radix Primitives

**An open-source UI component library for building high-quality, accessible design systems and web apps.**

Radix Primitives is a low-level UI component library with a focus on accessibility, customization and developer experience. You can use these components either as the base layer of your design system, or adopt them incrementally.

---

## Documentation

For full documentation, visit [radix-ui.com/docs/primitives](https://radix-ui.com/docs/primitives).

## Releases

For changelog, visit [radix-ui.com/docs/primitives/overview/releases](https://radix-ui.com/docs/primitives/overview/releases).

---

## Community

- [Discord](https://discord.com/invite/7Xb99uG) - To get involved with the Radix community, ask questions and share tips.
- [Twitter](https://twitter.com/radix_ui) - To receive updates, announcements, blog posts, and general Radix tips.

## Thanks

<a href="https://www.chromatic.com/"><img src="https://user-images.githubusercontent.com/321738/84662277-e3db4f80-af1b-11ea-88f5-91d67a5e59f6.png" width="153" height="30" alt="Chromatic" /></a>

Thanks to [Chromatic](https://www.chromatic.com/) for providing the visual testing platform that helps us review UI changes and catch visual regressions.

---

## License

Licensed under the MIT License, Copyright © 2022-present [WorkOS](https://workos.com).

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/radix-ui/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/radix-ui/package.json
```json
{
  "name": "radix-ui",
  "version": "1.3.3",
  "license": "MIT",
  "source": "./src/index.ts",
  "main": "./src/index.ts",
  "module": "./src/index.ts",
  "exports": {
    ".": "./src/index.ts",
    "./*": "./src/*.ts"
  },
  "publishConfig": {
    "main": "./dist/index.js",
    "module": "./dist/index.mjs",
    "types": "./dist/index.d.ts",
    "exports": {
      ".": {
        "import": {
          "types": "./dist/index.d.mts",
          "default": "./dist/index.mjs"
        },
        "require": {
          "types": "./dist/index.d.ts",
          "default": "./dist/index.js"
        }
      },
      "./*": {
        "import": {
          "types": "./dist/*.d.mts",
          "default": "./dist/*.mjs"
        },
        "require": {
          "types": "./dist/*.d.ts",
          "default": "./dist/*.js"
        }
      }
    }
  },
  "files": [
    "dist",
    "src",
    "README.md"
  ],
  "sideEffects": false,
  "scripts": {
    "lint": "eslint --max-warnings 0 src",
    "clean": "rm -rf dist",
    "typecheck": "tsc --noEmit",
    "build:esm": "tsc",
    "build:cjs": "tsc --module commonjs --moduleResolution node --outDir dist/cjs",
    "// build": "pnpm run --parallel \"/^build:.*/\"",
    "build": "radix-build"
  },
  "dependencies": {
    "@radix-ui/primitive": "workspace:*",
    "@radix-ui/react-accessible-icon": "workspace:*",
    "@radix-ui/react-accordion": "workspace:*",
    "@radix-ui/react-alert-dialog": "workspace:*",
    "@radix-ui/react-arrow": "workspace:*",
    "@radix-ui/react-aspect-ratio": "workspace:*",
    "@radix-ui/react-avatar": "workspace:*",
    "@radix-ui/react-checkbox": "workspace:*",
    "@radix-ui/react-collapsible": "workspace:*",
    "@radix-ui/react-collection": "workspace:*",
    "@radix-ui/react-compose-refs": "workspace:*",
    "@radix-ui/react-context": "workspace:*",
    "@radix-ui/react-context-menu": "workspace:*",
    "@radix-ui/react-dialog": "workspace:*",
    "@radix-ui/react-direction": "workspace:*",
    "@radix-ui/react-dismissable-layer": "workspace:*",
    "@radix-ui/react-dropdown-menu": "workspace:*",
    "@radix-ui/react-focus-guards": "workspace:*",
    "@radix-ui/react-focus-scope": "workspace:*",
    "@radix-ui/react-form": "workspace:*",
    "@radix-ui/react-hover-card": "workspace:*",
    "@radix-ui/react-label": "workspace:*",
    "@radix-ui/react-menu": "workspace:*",
    "@radix-ui/react-menubar": "workspace:*",
    "@radix-ui/react-navigation-menu": "workspace:*",
    "@radix-ui/react-one-time-password-field": "workspace:*",
    "@radix-ui/react-popover": "workspace:*",
    "@radix-ui/react-popper": "workspace:*",
    "@radix-ui/react-portal": "workspace:*",
    "@radix-ui/react-presence": "workspace:*",
    "@radix-ui/react-primitive": "workspace:*",
    "@radix-ui/react-progress": "workspace:*",
    "@radix-ui/react-radio-group": "workspace:*",
    "@radix-ui/react-roving-focus": "workspace:*",
    "@radix-ui/react-scroll-area": "workspace:*",
    "@radix-ui/react-select": "workspace:*",
    "@radix-ui/react-separator": "workspace:*",
    "@radix-ui/react-slider": "workspace:*",
    "@radix-ui/react-slot": "workspace:*",
    "@radix-ui/react-switch": "workspace:*",
    "@radix-ui/react-tabs": "workspace:*",
    "@radix-ui/react-toast": "workspace:*",
    "@radix-ui/react-toggle": "workspace:*",
    "@radix-ui/react-toggle-group": "workspace:*",
    "@radix-ui/react-toolbar": "workspace:*",
    "@radix-ui/react-tooltip": "workspace:*",
    "@radix-ui/react-use-callback-ref": "workspace:*",
    "@radix-ui/react-use-controllable-state": "workspace:*",
    "@radix-ui/react-use-effect-event": "workspace:*",
    "@radix-ui/react-use-escape-keydown": "workspace:*",
    "@radix-ui/react-use-is-hydrated": "workspace:*",
    "@radix-ui/react-use-layout-effect": "workspace:*",
    "@radix-ui/react-use-size": "workspace:*",
    "@radix-ui/react-visually-hidden": "workspace:*"
  },
  "devDependencies": {
    "@repo/builder": "workspace:*",
    "@repo/eslint-config": "workspace:*",
    "@repo/typescript-config": "workspace:*",
    "@types/react": "^19.0.7",
    "@types/react-dom": "^19.0.3",
    "eslint": "^9.18.0",
    "react": "^19.1.0",
    "react-dom": "^19.1.0",
    "typescript": "^5.7.3"
  },
  "peerDependencies": {
    "@types/react": "*",
    "@types/react-dom": "*",
    "react": "^16.8 || ^17.0 || ^18.0 || ^19.0 || ^19.0.0-rc",
    "react-dom": "^16.8 || ^17.0 || ^18.0 || ^19.0 || ^19.0.0-rc"
  },
  "peerDependenciesMeta": {
    "@types/react": {
      "optional": true
    },
    "@types/react-dom": {
      "optional": true
    }
  },
  "homepage": "https://radix-ui.com/primitives",
  "repository": {
    "type": "git",
    "url": "git+https://github.com/radix-ui/primitives.git"
  },
  "bugs": {
    "url": "https://github.com/radix-ui/primitives/issues"
  }
}

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/radix-ui/tsconfig.json
```json
{
  "extends": "@repo/typescript-config/react-library.json",
  "compilerOptions": {
    "outDir": "dist",
    "types": ["@repo/typescript-config/react-library"]
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/radix-ui/src/index.ts
```typescript
export * as AccessibleIcon from '@radix-ui/react-accessible-icon';
export * as Accordion from '@radix-ui/react-accordion';
export * as AlertDialog from '@radix-ui/react-alert-dialog';
export * as AspectRatio from '@radix-ui/react-aspect-ratio';
export * as Avatar from '@radix-ui/react-avatar';
export * as Checkbox from '@radix-ui/react-checkbox';
export * as Collapsible from '@radix-ui/react-collapsible';
export * as ContextMenu from '@radix-ui/react-context-menu';
export * as Dialog from '@radix-ui/react-dialog';
export * as Direction from '@radix-ui/react-direction';
export * as DropdownMenu from '@radix-ui/react-dropdown-menu';
export * as Form from '@radix-ui/react-form';
export * as HoverCard from '@radix-ui/react-hover-card';
export * as Label from '@radix-ui/react-label';
export * as Menubar from '@radix-ui/react-menubar';
export * as NavigationMenu from '@radix-ui/react-navigation-menu';
export * as unstable_OneTimePasswordField from '@radix-ui/react-one-time-password-field';
export * as Popover from '@radix-ui/react-popover';
export * as Portal from '@radix-ui/react-portal';
export * as Progress from '@radix-ui/react-progress';
export * as RadioGroup from '@radix-ui/react-radio-group';
export * as ScrollArea from '@radix-ui/react-scroll-area';
export * as Select from '@radix-ui/react-select';
export * as Separator from '@radix-ui/react-separator';
export * as Slider from '@radix-ui/react-slider';
export * as Slot from '@radix-ui/react-slot';
export * as Switch from '@radix-ui/react-switch';
export * as Tabs from '@radix-ui/react-tabs';
export * as Toast from '@radix-ui/react-toast';
export * as Toggle from '@radix-ui/react-toggle';
export * as ToggleGroup from '@radix-ui/react-toggle-group';
export * as Toolbar from '@radix-ui/react-toolbar';
export * as Tooltip from '@radix-ui/react-tooltip';
export * as VisuallyHidden from '@radix-ui/react-visually-hidden';

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/radix-ui/src/internal.ts
```typescript
import { Primitive as BasePrimitive, dispatchDiscreteCustomEvent } from '@radix-ui/react-primitive';
export * as Arrow from '@radix-ui/react-arrow';
export * as Collection from '@radix-ui/react-collection';
export { composeRefs, useComposedRefs } from '@radix-ui/react-compose-refs';
export * as Context from '@radix-ui/react-context';
export * as DismissableLayer from '@radix-ui/react-dismissable-layer';
export * as FocusGuards from '@radix-ui/react-focus-guards';
export * as FocusScope from '@radix-ui/react-focus-scope';
export * as Menu from '@radix-ui/react-menu';
export * as Popper from '@radix-ui/react-popper';
export * as Presence from '@radix-ui/react-presence';
export type { PrimitivePropsWithRef } from '@radix-ui/react-primitive';
export * as RovingFocus from '@radix-ui/react-roving-focus';
export { useCallbackRef } from '@radix-ui/react-use-callback-ref';
export {
  useControllableState,
  useControllableStateReducer,
} from '@radix-ui/react-use-controllable-state';
export { useEffectEvent } from '@radix-ui/react-use-effect-event';
export { useEscapeKeydown } from '@radix-ui/react-use-escape-keydown';
export { useIsHydrated } from '@radix-ui/react-use-is-hydrated';
export { useLayoutEffect } from '@radix-ui/react-use-layout-effect';
export { useSize } from '@radix-ui/react-use-size';
export { composeEventHandlers } from '@radix-ui/primitive';

const Primitive = BasePrimitive as typeof BasePrimitive & {
  Root: typeof BasePrimitive;
  dispatchDiscreteCustomEvent: typeof dispatchDiscreteCustomEvent;
};
Primitive.dispatchDiscreteCustomEvent = dispatchDiscreteCustomEvent;
Primitive.Root = BasePrimitive;
export { Primitive };

```
