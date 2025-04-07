/Users/josh/Documents/GitHub/honojs/hono/.vitest.config/jsx-runtime-default.ts
```typescript
import config from '../vitest.config'
config.esbuild = {
  jsx: 'automatic',
  jsxImportSource: __dirname + '/../src/jsx',
}
if (config.test) {
  config.test.include = [
    '**/src/jsx/dom/**/(*.)+(spec|test).+(ts|tsx|js)',
    'src/jsx/hooks/dom.test.tsx',
  ]
  if (config.test.coverage) {
    config.test.coverage.reportsDirectory = './coverage/raw/jsx-runtime'
  }
}
export default config

```
/Users/josh/Documents/GitHub/honojs/hono/.vitest.config/jsx-runtime-dom.ts
```typescript
import config from '../vitest.config'
config.esbuild = {
  jsx: 'automatic',
  jsxImportSource: __dirname + '/../src/jsx/dom',
}
if (config.test) {
  config.test.include = [
    '**/src/jsx/dom/**/(*.)+(spec|test).+(ts|tsx|js)',
    'src/jsx/hooks/dom.test.tsx',
  ]
  if (config.test.coverage) {
    config.test.coverage.reportsDirectory = './coverage/raw/jsx-dom'
  }
}
export default config

```
/Users/josh/Documents/GitHub/honojs/hono/.vitest.config/setup-vitest.ts
```typescript
import * as nodeCrypto from 'node:crypto'
import { vi } from 'vitest'

/**
 * crypto
 */
if (!globalThis.crypto) {
  vi.stubGlobal('crypto', nodeCrypto)
  vi.stubGlobal('CryptoKey', nodeCrypto.webcrypto.CryptoKey)
}

/**
 * Cache API
 */
type StoreMap = Map<string | Request, Response>

class MockCache {
  name: string
  store: StoreMap

  constructor(name: string, store: StoreMap) {
    this.name = name
    this.store = store
  }

  async match(key: Request | string): Promise<Response | null> {
    return this.store.get(key) || null
  }

  async keys() {
    return this.store.keys()
  }

  async put(key: Request | string, response: Response): Promise<void> {
    this.store.set(key, response)
  }
}

const globalStore: Map<string | Request, Response> = new Map()

const caches = {
  open: (name: string) => {
    return new MockCache(name, globalStore)
  },
}

vi.stubGlobal('caches', caches)

```
