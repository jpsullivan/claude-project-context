/Users/josh/Documents/GitHub/honojs/hono/perf-measures/type-check/scripts/generate-app.ts
```typescript
import { writeFile } from 'node:fs'
import * as path from 'node:path'

const count = 200

const generateRoutes = (count: number) => {
  let routes = `import { Hono } from '../../../src'
export const app = new Hono()`
  for (let i = 1; i <= count; i++) {
    routes += `
  .get('/route${i}/:id', (c) => {
    return c.json({
      ok: true
    })
  })`
  }
  return routes
}

const routes = generateRoutes(count)

writeFile(path.join(import.meta.dirname, '../generated/app.ts'), routes, (err) => {
  if (err) {
    throw err
  }
  console.log(`${count} routes have been written to app.ts`)
})

```
/Users/josh/Documents/GitHub/honojs/hono/perf-measures/type-check/scripts/process-results.ts
```typescript
import * as readline from 'node:readline'

async function main() {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false,
  })
  const toKebabCase = (str: string): string => {
    return str
      .replace(/([a-z])([A-Z])/g, '$1-$2')
      .replace(/[\s_\/]+/g, '-')
      .toLowerCase()
  }
  const metrics = []
  for await (const line of rl) {
    if (!line || line.trim() === '') {
      continue
    }
    const [name, value] = line.split(':')
    const unitMatch = value?.trim().match(/^(\d+(\.\d+)?)([a-zA-Z]*)$/)
    if (unitMatch) {
      const [, number, , unit] = unitMatch
      metrics.push({
        key: toKebabCase(name?.trim()),
        name: name?.trim(),
        value: parseFloat(number),
        unit: unit || undefined,
      })
    } else {
      metrics.push({
        key: toKebabCase(name?.trim()),
        name: name?.trim(),
        value: parseFloat(value?.trim()),
      })
    }
  }
  const benchmark = {
    key: 'diagnostics',
    name: 'Compiler Diagnostics',
    metrics,
  }
  console.log(JSON.stringify(benchmark, null, 2))
}

main()

```
