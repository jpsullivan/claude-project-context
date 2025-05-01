/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-controllable-state/CHANGELOG.md
```
# @radix-ui/react-use-controllable-state

## 1.2.2

- Updated dependencies: `@radix-ui/react-use-effect-event@0.0.2`

## 1.2.1

- Updated dependencies: `@radix-ui/react-use-effect-event@0.0.1`

## 1.2.0

- Minor improvements to `useControllableState` to enhance performance, reduce surface area for bugs, and log warnings when misused (#3455)

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-controllable-state/README.md
```
# `react-use-controllable-state`

This is an internal utility, not intended for public usage.

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-controllable-state/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-controllable-state/package.json
```json
{
  "name": "@radix-ui/react-use-controllable-state",
  "version": "1.2.2",
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
    "@radix-ui/react-use-effect-event": "workspace:*",
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
    "react": "^16.8 || ^17.0 || ^18.0 || ^19.0 || ^19.0.0-rc"
  },
  "peerDependenciesMeta": {
    "@types/react": {
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-controllable-state/tsconfig.json
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-controllable-state/src/index.ts
```typescript
export { useControllableState } from './use-controllable-state';
export { useControllableStateReducer } from './use-controllable-state-reducer';

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-controllable-state/src/use-controllable-state-reducer.tsx
```
import * as React from 'react';
import { useEffectEvent } from '@radix-ui/react-use-effect-event';

type ChangeHandler<T> = (state: T) => void;

interface UseControllableStateParams<T> {
  prop: T | undefined;
  defaultProp: T;
  onChange: ChangeHandler<T> | undefined;
  caller: string;
}

interface AnyAction {
  type: string;
}

const SYNC_STATE = Symbol('RADIX:SYNC_STATE');

interface SyncStateAction<T> {
  type: typeof SYNC_STATE;
  state: T;
}

export function useControllableStateReducer<T, S extends {}, A extends AnyAction>(
  reducer: (prevState: S & { state: T }, action: A) => S & { state: T },
  userArgs: UseControllableStateParams<T>,
  initialState: S
): [S & { state: T }, React.Dispatch<A>];

export function useControllableStateReducer<T, S extends {}, I, A extends AnyAction>(
  reducer: (prevState: S & { state: T }, action: A) => S & { state: T },
  userArgs: UseControllableStateParams<T>,
  initialArg: I,
  init: (i: I & { state: T }) => S
): [S & { state: T }, React.Dispatch<A>];

export function useControllableStateReducer<T, S extends {}, A extends AnyAction>(
  reducer: (prevState: S & { state: T }, action: A) => S & { state: T },
  userArgs: UseControllableStateParams<T>,
  initialArg: any,
  init?: (i: any) => Omit<S, 'state'>
): [S & { state: T }, React.Dispatch<A>] {
  const { prop: controlledState, defaultProp, onChange: onChangeProp, caller } = userArgs;
  const isControlled = controlledState !== undefined;

  const onChange = useEffectEvent(onChangeProp);

  // OK to disable conditionally calling hooks here because they will always run
  // consistently in the same environment. Bundlers should be able to remove the
  // code block entirely in production.
  /* eslint-disable react-hooks/rules-of-hooks */
  if (process.env.NODE_ENV !== 'production') {
    const isControlledRef = React.useRef(controlledState !== undefined);
    React.useEffect(() => {
      const wasControlled = isControlledRef.current;
      if (wasControlled !== isControlled) {
        const from = wasControlled ? 'controlled' : 'uncontrolled';
        const to = isControlled ? 'controlled' : 'uncontrolled';
        console.warn(
          `${caller} is changing from ${from} to ${to}. Components should not switch from controlled to uncontrolled (or vice versa). Decide between using a controlled or uncontrolled value for the lifetime of the component.`
        );
      }
      isControlledRef.current = isControlled;
    }, [isControlled, caller]);
  }
  /* eslint-enable react-hooks/rules-of-hooks */

  type InternalState = S & { state: T };
  const args: [InternalState] = [{ ...initialArg, state: defaultProp }];
  if (init) {
    // @ts-expect-error
    args.push(init);
  }

  const [internalState, dispatch] = React.useReducer(
    (state: InternalState, action: A | SyncStateAction<T>): InternalState => {
      if (action.type === SYNC_STATE) {
        return { ...state, state: action.state };
      }

      const next = reducer(state, action);
      if (isControlled && !Object.is(next.state, state.state)) {
        onChange(next.state);
      }
      return next;
    },
    ...args
  );

  const uncontrolledState = internalState.state;
  const prevValueRef = React.useRef(uncontrolledState);
  React.useEffect(() => {
    if (prevValueRef.current !== uncontrolledState) {
      prevValueRef.current = uncontrolledState;
      if (!isControlled) {
        onChange(uncontrolledState);
      }
    }
  }, [onChange, uncontrolledState, prevValueRef, isControlled]);

  const state = React.useMemo(() => {
    const isControlled = controlledState !== undefined;
    if (isControlled) {
      return { ...internalState, state: controlledState };
    }

    return internalState;
  }, [internalState, controlledState]);

  React.useEffect(() => {
    // Sync internal state for controlled components so that reducer is called
    // with the correct state values
    if (isControlled && !Object.is(controlledState, internalState.state)) {
      dispatch({ type: SYNC_STATE, state: controlledState });
    }
  }, [controlledState, internalState.state, isControlled]);

  return [state, dispatch as React.Dispatch<A>];
}

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-controllable-state/src/use-controllable-state.test.tsx
```
import * as React from 'react';
import { screen, cleanup, render, waitFor } from '@testing-library/react';
import { useControllableState } from './use-controllable-state';
import { afterEach, describe, it, expect, afterAll, vi } from 'vitest';
import userEvent from '@testing-library/user-event';

describe('useControllableState', () => {
  afterEach(cleanup);

  describe('given a controlled value', () => {
    it('should initially use the controlled value', () => {
      render(<ControlledComponent />);
      const checkbox = screen.getByRole('checkbox');
      expect(checkbox).toHaveAttribute('aria-checked', 'false');
    });

    it('should update the value when set internally', async () => {
      render(<ControlledComponent />);
      const checkbox = screen.getByRole('checkbox');
      userEvent.click(checkbox);
      await waitFor(() => {
        expect(checkbox).toHaveAttribute('aria-checked', 'true');
      });
    });

    it('should update the value when set externally', async () => {
      render(<ControlledComponent defaultChecked />);
      const checkbox = screen.getByRole('checkbox');
      const clearButton = screen.getByText('Clear value');
      userEvent.click(clearButton);
      await waitFor(() => {
        expect(checkbox).toHaveAttribute('aria-checked', 'false');
      });
    });
  });

  describe('given a default value', () => {
    it('should initially use the default value', () => {
      render(<UncontrolledComponent defaultChecked />);
      const checkbox = screen.getByRole('checkbox');
      expect(checkbox).toHaveAttribute('aria-checked', 'true');
    });

    it('should update the value', async () => {
      render(<UncontrolledComponent defaultChecked />);
      const checkbox = screen.getByRole('checkbox');
      userEvent.click(checkbox);
      await waitFor(() => {
        expect(checkbox).toHaveAttribute('aria-checked', 'false');
      });
    });
  });

  describe('switching between controlled and uncontrolled', () => {
    const consoleMock = vi.spyOn(console, 'warn').mockImplementation(() => void 0);
    afterAll(() => {
      consoleMock.mockReset();
    });

    describe('controlled to uncontrolled', () => {
      it('should warn', async () => {
        render(<UnstableComponent defaultChecked />);
        const clearButton = screen.getByText('Clear value');
        userEvent.click(clearButton);
        await waitFor(() => {
          expect(consoleMock).toHaveBeenLastCalledWith(
            'Checkbox is changing from controlled to uncontrolled. Components should not switch from controlled to uncontrolled (or vice versa). Decide between using a controlled or uncontrolled value for the lifetime of the component.'
          );
        });
      });
    });

    describe('uncontrolled to controlled', () => {
      it('should warn', async () => {
        render(<UnstableComponent />);
        const checkbox = screen.getByRole('checkbox');
        userEvent.click(checkbox);
        await waitFor(() => {
          expect(consoleMock).toHaveBeenLastCalledWith(
            'Checkbox is changing from uncontrolled to controlled. Components should not switch from controlled to uncontrolled (or vice versa). Decide between using a controlled or uncontrolled value for the lifetime of the component.'
          );
        });
      });
    });
  });
});

function ControlledComponent({ defaultChecked }: { defaultChecked?: boolean }) {
  const [checked, setChecked] = React.useState(defaultChecked ?? false);
  return (
    <div>
      <Checkbox checked={checked} onChange={setChecked} />
      <button type="button" onClick={() => setChecked(false)}>
        Clear value
      </button>
    </div>
  );
}

function UncontrolledComponent({ defaultChecked }: { defaultChecked?: boolean }) {
  return <Checkbox defaultChecked={defaultChecked} />;
}

function UnstableComponent({ defaultChecked }: { defaultChecked?: boolean }) {
  const [checked, setChecked] = React.useState(defaultChecked);
  return (
    <div>
      <Checkbox checked={checked} onChange={setChecked} />
      <button type="button" onClick={() => setChecked(undefined)}>
        Clear value
      </button>
    </div>
  );
}

function Checkbox(props: {
  checked?: boolean;
  defaultChecked?: boolean;
  onChange?: (value: boolean) => void;
}) {
  const [checked, setChecked] = useControllableState({
    defaultProp: props.defaultChecked ?? false,
    prop: props.checked,
    onChange: props.onChange,
    caller: 'Checkbox',
  });

  return (
    <button
      type="button"
      role="checkbox"
      aria-checked={checked}
      onKeyDown={(e) => void (e.key === 'Enter' && e.preventDefault())}
      onClick={() => setChecked((c) => !c)}
    />
  );
}

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/use-controllable-state/src/use-controllable-state.tsx
```
import * as React from 'react';
import { useLayoutEffect } from '@radix-ui/react-use-layout-effect';

// Prevent bundlers from trying to optimize the import
const useInsertionEffect: typeof useLayoutEffect =
  (React as any)[' useInsertionEffect '.trim().toString()] || useLayoutEffect;

type ChangeHandler<T> = (state: T) => void;
type SetStateFn<T> = React.Dispatch<React.SetStateAction<T>>;

interface UseControllableStateParams<T> {
  prop?: T | undefined;
  defaultProp: T;
  onChange?: ChangeHandler<T>;
  caller?: string;
}

export function useControllableState<T>({
  prop,
  defaultProp,
  onChange = () => {},
  caller,
}: UseControllableStateParams<T>): [T, SetStateFn<T>] {
  const [uncontrolledProp, setUncontrolledProp, onChangeRef] = useUncontrolledState({
    defaultProp,
    onChange,
  });
  const isControlled = prop !== undefined;
  const value = isControlled ? prop : uncontrolledProp;

  // OK to disable conditionally calling hooks here because they will always run
  // consistently in the same environment. Bundlers should be able to remove the
  // code block entirely in production.
  /* eslint-disable react-hooks/rules-of-hooks */
  if (process.env.NODE_ENV !== 'production') {
    const isControlledRef = React.useRef(prop !== undefined);
    React.useEffect(() => {
      const wasControlled = isControlledRef.current;
      if (wasControlled !== isControlled) {
        const from = wasControlled ? 'controlled' : 'uncontrolled';
        const to = isControlled ? 'controlled' : 'uncontrolled';
        console.warn(
          `${caller} is changing from ${from} to ${to}. Components should not switch from controlled to uncontrolled (or vice versa). Decide between using a controlled or uncontrolled value for the lifetime of the component.`
        );
      }
      isControlledRef.current = isControlled;
    }, [isControlled, caller]);
  }
  /* eslint-enable react-hooks/rules-of-hooks */

  const setValue = React.useCallback<SetStateFn<T>>(
    (nextValue) => {
      if (isControlled) {
        const value = isFunction(nextValue) ? nextValue(prop) : nextValue;
        if (value !== prop) {
          onChangeRef.current?.(value);
        }
      } else {
        setUncontrolledProp(nextValue);
      }
    },
    [isControlled, prop, setUncontrolledProp, onChangeRef]
  );

  return [value, setValue];
}

function useUncontrolledState<T>({
  defaultProp,
  onChange,
}: Omit<UseControllableStateParams<T>, 'prop'>): [
  Value: T,
  setValue: React.Dispatch<React.SetStateAction<T>>,
  OnChangeRef: React.RefObject<ChangeHandler<T> | undefined>,
] {
  const [value, setValue] = React.useState(defaultProp);
  const prevValueRef = React.useRef(value);

  const onChangeRef = React.useRef(onChange);
  useInsertionEffect(() => {
    onChangeRef.current = onChange;
  }, [onChange]);

  React.useEffect(() => {
    if (prevValueRef.current !== value) {
      onChangeRef.current?.(value);
      prevValueRef.current = value;
    }
  }, [value, prevValueRef]);

  return [value, setValue, onChangeRef];
}

function isFunction(value: unknown): value is (...args: any[]) => any {
  return typeof value === 'function';
}

```
