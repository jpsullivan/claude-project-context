/Users/josh/Documents/GitHub/honojs/hono/perf-measures/tsconfig.json
```json
{
  "extends": "../tsconfig.json",
  "compilerOptions": {
    "module": "esnext",
    "noEmit": true,
    "rootDir": "..",
    "strict": true
  },
  "include": [
    "**/*.ts",
    "**/*.tsx"
  ]
}

```
/Users/josh/Documents/GitHub/honojs/hono/perf-measures/bundle-check/scripts/check-bundle-size.ts
```typescript
import * as esbuild from 'esbuild'
import * as fs from 'node:fs'
import * as os from 'os'
import * as path from 'path'

async function main() {
  const tempDir = os.tmpdir()
  const tempFilePath = path.join(tempDir, 'bundle.tmp.js')

  try {
    await esbuild.build({
      entryPoints: ['dist/index.js'],
      bundle: true,
      minify: true,
      format: 'esm' as esbuild.Format,
      target: 'es2022',
      outfile: tempFilePath,
    })

    const bundleSize = fs.statSync(tempFilePath).size
    const metrics = []

    metrics.push({
      key: 'bundle-size-b',
      name: 'Bundle Size (B)',
      value: bundleSize,
      unit: 'B',
    })

    metrics.push({
      key: 'bundle-size-kb',
      name: 'Bundle Size (KB)',
      value: parseFloat((bundleSize / 1024).toFixed(2)),
      unit: 'K',
    })

    const benchmark = {
      key: 'bundle-size-check',
      name: 'Bundle size check',
      metrics,
    }
    console.log(JSON.stringify(benchmark, null, 2))
  } catch (error) {
    console.error('Build failed:', error)
  } finally {
    if (fs.existsSync(tempFilePath)) {
      fs.unlinkSync(tempFilePath)
    }
  }
}

main()

```
/Users/josh/Documents/GitHub/honojs/hono/perf-measures/type-check/client.ts
```typescript
import { hc } from '../../src/client'
import type { app } from './generated/app'

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const client = hc<typeof app>('/')

```
/Users/josh/Documents/GitHub/honojs/hono/perf-measures/type-check/tsconfig.build.json
```json
{
    "extends": "../tsconfig.json",
    "include": ["client.ts"]
}

```
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
