/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/direction/README.md
```
# `react-direction`

View docs [here](https://radix-ui.com/primitives/docs/utilities/direction).

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/direction/eslint.config.mjs
```
// @ts-check
import { configs } from '@repo/eslint-config/react-package';

export default configs;

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/direction/package.json
```json
{
  "name": "@radix-ui/react-direction",
  "version": "1.1.1",
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/direction/tsconfig.json
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
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/direction/src/direction.tsx
```
import * as React from 'react';

type Direction = 'ltr' | 'rtl';
const DirectionContext = React.createContext<Direction | undefined>(undefined);

/* -------------------------------------------------------------------------------------------------
 * Direction
 * -----------------------------------------------------------------------------------------------*/

interface DirectionProviderProps {
  children?: React.ReactNode;
  dir: Direction;
}
const DirectionProvider: React.FC<DirectionProviderProps> = (props) => {
  const { dir, children } = props;
  return <DirectionContext.Provider value={dir}>{children}</DirectionContext.Provider>;
};

/* -----------------------------------------------------------------------------------------------*/

function useDirection(localDir?: Direction) {
  const globalDir = React.useContext(DirectionContext);
  return localDir || globalDir || 'ltr';
}

const Provider = DirectionProvider;

export {
  useDirection,
  //
  Provider,
  //
  DirectionProvider,
};

```
/Users/josh/Documents/GitHub/radix-ui/primitives/packages/react/direction/src/index.ts
```typescript
export {
  useDirection,
  //
  Provider,
  //
  DirectionProvider,
} from './direction';

```
