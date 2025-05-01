/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/collapsible/CHANGELOG.md
```
# @radix-ui/react-collapsible

## 1.1.7

- Updated dependencies: `@radix-ui/react-use-controllable-state@1.2.2`

## 1.1.6

- Updated dependencies: `@radix-ui/react-use-controllable-state@1.2.1`

## 1.1.5

- Minor improvements to `useControllableState` to enhance performance, reduce surface area for bugs, and log warnings when misused (#3455)
- Updated dependencies: `@radix-ui/react-use-controllable-state@1.2.0`, `@radix-ui/react-primitive@2.1.0`

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/collapsible/README.md
```
# `react-collapsible`

View docs [here](https://radix-ui.com/primitives/docs/components/collapsible).

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/collapsible/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/collapsible/package.json
```json
{
  "name": "@radix-ui/react-collapsible",
  "version": "1.1.7",
  "license": "MIT",
  "source": "./src/index.ts",
  "main": "./src/index.ts",
  "module": "./src/index.ts",
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
      }
    }
  },
  "files": [
    "dist",
    "README.md"
  ],
  "sideEffects": false,
  "scripts": {
    "lint": "eslint --max-warnings 0 src",
    "clean": "rm -rf dist",
    "typecheck": "tsc --noEmit",
    "build": "radix-build"
  },
  "dependencies": {
    "@radix-ui/primitive": "workspace:*",
    "@radix-ui/react-compose-refs": "workspace:*",
    "@radix-ui/react-context": "workspace:*",
    "@radix-ui/react-id": "workspace:*",
    "@radix-ui/react-presence": "workspace:*",
    "@radix-ui/react-primitive": "workspace:*",
    "@radix-ui/react-use-controllable-state": "workspace:*",
    "@radix-ui/react-use-layout-effect": "workspace:*"
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/collapsible/tsconfig.json
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/collapsible/src/collapsible.test.tsx
```
import React from 'react';
import { axe } from 'vitest-axe';
import type { RenderResult } from '@testing-library/react';
import { cleanup, render, fireEvent } from '@testing-library/react';
import { Collapsible, CollapsibleTrigger, CollapsibleContent } from './collapsible';
import { afterEach, describe, it, beforeEach, vi, expect } from 'vitest';

const TRIGGER_TEXT = 'Trigger';
const CONTENT_TEXT = 'Content';

const CollapsibleTest = (props: React.ComponentProps<typeof Collapsible>) => (
  <Collapsible {...props}>
    <CollapsibleTrigger>{TRIGGER_TEXT}</CollapsibleTrigger>
    <CollapsibleContent>{CONTENT_TEXT}</CollapsibleContent>
  </Collapsible>
);

describe('given a default Collapsible', () => {
  let rendered: RenderResult;
  let trigger: HTMLElement;
  let content: HTMLElement | null;

  afterEach(cleanup);

  beforeEach(() => {
    rendered = render(<CollapsibleTest />);
    trigger = rendered.getByText(TRIGGER_TEXT);
  });

  it('should have no accessibility violations', async () => {
    expect(await axe(rendered.container)).toHaveNoViolations();
  });

  describe('when clicking the trigger', () => {
    beforeEach(async () => {
      fireEvent.click(trigger);
      content = rendered.queryByText(CONTENT_TEXT);
    });

    it('should open the content', () => {
      expect(content).toBeVisible();
    });

    describe('and clicking the trigger again', () => {
      beforeEach(() => {
        fireEvent.click(trigger);
      });

      it('should close the content', () => {
        expect(content).not.toBeVisible();
      });
    });
  });
});

describe('given an open uncontrolled Collapsible', () => {
  let rendered: RenderResult;
  let content: HTMLElement | null;
  const onOpenChange = vi.fn();

  afterEach(cleanup);

  beforeEach(() => {
    rendered = render(<CollapsibleTest defaultOpen onOpenChange={onOpenChange} />);
  });

  describe('when clicking the trigger', () => {
    beforeEach(async () => {
      const trigger = rendered.getByText(TRIGGER_TEXT);
      content = rendered.getByText(CONTENT_TEXT);
      fireEvent.click(trigger);
    });

    it('should close the content', () => {
      expect(content).not.toBeVisible();
    });

    it('should call `onOpenChange` prop with `false` value', () => {
      expect(onOpenChange).toHaveBeenCalledWith(false);
    });
  });
});

describe('given an open controlled Collapsible', () => {
  let rendered: RenderResult;
  let content: HTMLElement;
  const onOpenChange = vi.fn();

  afterEach(cleanup);

  beforeEach(() => {
    rendered = render(<CollapsibleTest open onOpenChange={onOpenChange} />);
    content = rendered.getByText(CONTENT_TEXT);
  });

  describe('when clicking the trigger', () => {
    beforeEach(() => {
      const trigger = rendered.getByText(TRIGGER_TEXT);
      fireEvent.click(trigger);
    });

    it('should call `onOpenChange` prop with `false` value', () => {
      expect(onOpenChange).toHaveBeenCalledWith(false);
    });

    it('should not close the content', () => {
      expect(content).toBeVisible();
    });
  });
});

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/collapsible/src/collapsible.tsx
```
import * as React from 'react';
import { composeEventHandlers } from '@radix-ui/primitive';
import { createContextScope } from '@radix-ui/react-context';
import { useControllableState } from '@radix-ui/react-use-controllable-state';
import { useLayoutEffect } from '@radix-ui/react-use-layout-effect';
import { useComposedRefs } from '@radix-ui/react-compose-refs';
import { Primitive } from '@radix-ui/react-primitive';
import { Presence } from '@radix-ui/react-presence';
import { useId } from '@radix-ui/react-id';

import type { Scope } from '@radix-ui/react-context';

/* -------------------------------------------------------------------------------------------------
 * Collapsible
 * -----------------------------------------------------------------------------------------------*/

const COLLAPSIBLE_NAME = 'Collapsible';

type ScopedProps<P> = P & { __scopeCollapsible?: Scope };
const [createCollapsibleContext, createCollapsibleScope] = createContextScope(COLLAPSIBLE_NAME);

type CollapsibleContextValue = {
  contentId: string;
  disabled?: boolean;
  open: boolean;
  onOpenToggle(): void;
};

const [CollapsibleProvider, useCollapsibleContext] =
  createCollapsibleContext<CollapsibleContextValue>(COLLAPSIBLE_NAME);

type CollapsibleElement = React.ElementRef<typeof Primitive.div>;
type PrimitiveDivProps = React.ComponentPropsWithoutRef<typeof Primitive.div>;
interface CollapsibleProps extends PrimitiveDivProps {
  defaultOpen?: boolean;
  open?: boolean;
  disabled?: boolean;
  onOpenChange?(open: boolean): void;
}

const Collapsible = React.forwardRef<CollapsibleElement, CollapsibleProps>(
  (props: ScopedProps<CollapsibleProps>, forwardedRef) => {
    const {
      __scopeCollapsible,
      open: openProp,
      defaultOpen,
      disabled,
      onOpenChange,
      ...collapsibleProps
    } = props;

    const [open, setOpen] = useControllableState({
      prop: openProp,
      defaultProp: defaultOpen ?? false,
      onChange: onOpenChange,
      caller: COLLAPSIBLE_NAME,
    });

    return (
      <CollapsibleProvider
        scope={__scopeCollapsible}
        disabled={disabled}
        contentId={useId()}
        open={open}
        onOpenToggle={React.useCallback(() => setOpen((prevOpen) => !prevOpen), [setOpen])}
      >
        <Primitive.div
          data-state={getState(open)}
          data-disabled={disabled ? '' : undefined}
          {...collapsibleProps}
          ref={forwardedRef}
        />
      </CollapsibleProvider>
    );
  }
);

Collapsible.displayName = COLLAPSIBLE_NAME;

/* -------------------------------------------------------------------------------------------------
 * CollapsibleTrigger
 * -----------------------------------------------------------------------------------------------*/

const TRIGGER_NAME = 'CollapsibleTrigger';

type CollapsibleTriggerElement = React.ElementRef<typeof Primitive.button>;
type PrimitiveButtonProps = React.ComponentPropsWithoutRef<typeof Primitive.button>;
interface CollapsibleTriggerProps extends PrimitiveButtonProps {}

const CollapsibleTrigger = React.forwardRef<CollapsibleTriggerElement, CollapsibleTriggerProps>(
  (props: ScopedProps<CollapsibleTriggerProps>, forwardedRef) => {
    const { __scopeCollapsible, ...triggerProps } = props;
    const context = useCollapsibleContext(TRIGGER_NAME, __scopeCollapsible);
    return (
      <Primitive.button
        type="button"
        aria-controls={context.contentId}
        aria-expanded={context.open || false}
        data-state={getState(context.open)}
        data-disabled={context.disabled ? '' : undefined}
        disabled={context.disabled}
        {...triggerProps}
        ref={forwardedRef}
        onClick={composeEventHandlers(props.onClick, context.onOpenToggle)}
      />
    );
  }
);

CollapsibleTrigger.displayName = TRIGGER_NAME;

/* -------------------------------------------------------------------------------------------------
 * CollapsibleContent
 * -----------------------------------------------------------------------------------------------*/

const CONTENT_NAME = 'CollapsibleContent';

type CollapsibleContentElement = CollapsibleContentImplElement;
interface CollapsibleContentProps extends Omit<CollapsibleContentImplProps, 'present'> {
  /**
   * Used to force mounting when more control is needed. Useful when
   * controlling animation with React animation libraries.
   */
  forceMount?: true;
}

const CollapsibleContent = React.forwardRef<CollapsibleContentElement, CollapsibleContentProps>(
  (props: ScopedProps<CollapsibleContentProps>, forwardedRef) => {
    const { forceMount, ...contentProps } = props;
    const context = useCollapsibleContext(CONTENT_NAME, props.__scopeCollapsible);
    return (
      <Presence present={forceMount || context.open}>
        {({ present }) => (
          <CollapsibleContentImpl {...contentProps} ref={forwardedRef} present={present} />
        )}
      </Presence>
    );
  }
);

CollapsibleContent.displayName = CONTENT_NAME;

/* -----------------------------------------------------------------------------------------------*/

type CollapsibleContentImplElement = React.ElementRef<typeof Primitive.div>;
interface CollapsibleContentImplProps extends PrimitiveDivProps {
  present: boolean;
}

const CollapsibleContentImpl = React.forwardRef<
  CollapsibleContentImplElement,
  CollapsibleContentImplProps
>((props: ScopedProps<CollapsibleContentImplProps>, forwardedRef) => {
  const { __scopeCollapsible, present, children, ...contentProps } = props;
  const context = useCollapsibleContext(CONTENT_NAME, __scopeCollapsible);
  const [isPresent, setIsPresent] = React.useState(present);
  const ref = React.useRef<CollapsibleContentImplElement>(null);
  const composedRefs = useComposedRefs(forwardedRef, ref);
  const heightRef = React.useRef<number | undefined>(0);
  const height = heightRef.current;
  const widthRef = React.useRef<number | undefined>(0);
  const width = widthRef.current;
  // when opening we want it to immediately open to retrieve dimensions
  // when closing we delay `present` to retrieve dimensions before closing
  const isOpen = context.open || isPresent;
  const isMountAnimationPreventedRef = React.useRef(isOpen);
  const originalStylesRef = React.useRef<Record<string, string>>(undefined);

  React.useEffect(() => {
    const rAF = requestAnimationFrame(() => (isMountAnimationPreventedRef.current = false));
    return () => cancelAnimationFrame(rAF);
  }, []);

  useLayoutEffect(() => {
    const node = ref.current;
    if (node) {
      originalStylesRef.current = originalStylesRef.current || {
        transitionDuration: node.style.transitionDuration,
        animationName: node.style.animationName,
      };
      // block any animations/transitions so the element renders at its full dimensions
      node.style.transitionDuration = '0s';
      node.style.animationName = 'none';

      // get width and height from full dimensions
      const rect = node.getBoundingClientRect();
      heightRef.current = rect.height;
      widthRef.current = rect.width;

      // kick off any animations/transitions that were originally set up if it isn't the initial mount
      if (!isMountAnimationPreventedRef.current) {
        node.style.transitionDuration = originalStylesRef.current.transitionDuration!;
        node.style.animationName = originalStylesRef.current.animationName!;
      }

      setIsPresent(present);
    }
    /**
     * depends on `context.open` because it will change to `false`
     * when a close is triggered but `present` will be `false` on
     * animation end (so when close finishes). This allows us to
     * retrieve the dimensions *before* closing.
     */
  }, [context.open, present]);

  return (
    <Primitive.div
      data-state={getState(context.open)}
      data-disabled={context.disabled ? '' : undefined}
      id={context.contentId}
      hidden={!isOpen}
      {...contentProps}
      ref={composedRefs}
      style={{
        [`--radix-collapsible-content-height` as any]: height ? `${height}px` : undefined,
        [`--radix-collapsible-content-width` as any]: width ? `${width}px` : undefined,
        ...props.style,
      }}
    >
      {isOpen && children}
    </Primitive.div>
  );
});

/* -----------------------------------------------------------------------------------------------*/

function getState(open?: boolean) {
  return open ? 'open' : 'closed';
}

const Root = Collapsible;
const Trigger = CollapsibleTrigger;
const Content = CollapsibleContent;

export {
  createCollapsibleScope,
  //
  Collapsible,
  CollapsibleTrigger,
  CollapsibleContent,
  //
  Root,
  Trigger,
  Content,
};
export type { CollapsibleProps, CollapsibleTriggerProps, CollapsibleContentProps };

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/collapsible/src/index.ts
```typescript
'use client';
export {
  createCollapsibleScope,
  //
  Collapsible,
  CollapsibleTrigger,
  CollapsibleContent,
  //
  Root,
  Trigger,
  Content,
} from './collapsible';
export type {
  CollapsibleProps,
  CollapsibleTriggerProps,
  CollapsibleContentProps,
} from './collapsible';

```
