/Users/josh/Documents/GitHub/honojs/hono/src/adapter/netlify/handler.ts
```typescript
/* eslint-disable @typescript-eslint/no-explicit-any */
import type { Hono } from '../../hono'

export const handle = (
  app: Hono<any, any>
): ((req: Request, context: any) => Response | Promise<Response>) => {
  return (req: Request, context: any) => {
    return app.fetch(req, { context })
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/netlify/index.ts
```typescript
/**
 * @module
 * Netlify Adapter for Hono.
 */

export * from './mod'

```
/Users/josh/Documents/GitHub/honojs/hono/src/adapter/netlify/mod.ts
```typescript
export { handle } from './handler'

```
