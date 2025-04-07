/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/README.md
````
# Astro Example

This is an example of how to use Better Auth with Astro. It uses Solid for building the components.


**Implements the following features:**
Email & Password . Social Sign-in with Google . Passkeys . Email Verification . Password Reset . Two Factor Authentication . Profile Update . Session Management


## How to run

1. Clone the code sandbox (or the repo) and open it in your code editor
2. Provide .env file with the following variables
   ```txt
   GOOGLE_CLIENT_ID=
   GOOGLE_CLIENT_SECRET=
   BETTER_AUTH_SECRET=
   ```
   //if you don't have these, you can get them from the google developer console. If you don't want to use google sign-in, you can remove the google config from the `auth.ts` file.

3. Run the following commands
   ```bash
   pnpm install
   pnpm run dev
   ```
4. Open the browser and navigate to `http://localhost:3000`

````
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/astro.config.mjs
```
// @ts-check
import { defineConfig } from "astro/config";

import tailwind from "@astrojs/tailwind";

import solidJs from "@astrojs/solid-js";

// https://astro.build/config
export default defineConfig({
	output: "server",
	integrations: [
		tailwind({
			applyBaseStyles: false,
		}),
		solidJs(),
	],
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/components.json
```json
{
	"$schema": "https://shadcn-solid.com/schema.json",
	"tailwind": {
		"config": "tailwind.config.mjs",
		"css": {
			"path": "src/app.css",
			"variable": true
		},
		"color": "stone",
		"prefix": ""
	},
	"alias": {
		"component": "@/components",
		"cn": "@/libs/cn"
	}
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/package.json
```json
{
  "name": "@examples/astro",
  "type": "module",
  "private": true,
  "version": "0.0.1",
  "scripts": {
    "dev": "pnpm migrate:auth && astro dev --port 3000",
    "migrate:auth": "pnpx @better-auth/cli migrate",
    "build": "astro check && astro build",
    "preview": "astro preview"
  },
  "dependencies": {
    "@ark-ui/solid": "^3.13.0",
    "@astrojs/check": "^0.9.4",
    "@astrojs/solid-js": "^4.4.4",
    "@astrojs/tailwind": "^5.1.3",
    "@corvu/drawer": "^0.2.2",
    "@corvu/otp-field": "^0.1.4",
    "@corvu/resizable": "^0.2.3",
    "@kobalte/core": "^0.13.7",
    "@oslojs/encoding": "^1.1.0",
    "@types/better-sqlite3": "^7.6.12",
    "astro": "^4.16.18",
    "better-auth": "workspace:*",
    "better-sqlite3": "^11.6.0",
    "class-variance-authority": "^0.7.1",
    "clsx": "^2.1.1",
    "cmdk-solid": "^1.1.0",
    "embla-carousel-solid": "^8.5.1",
    "lucide-solid": "^0.445.0",
    "resend": "^4.0.1",
    "solid-js": "^1.9.4",
    "solid-sonner": "^0.2.8",
    "tailwind-merge": "^2.5.5",
    "tailwindcss": "^3.4.16",
    "tailwindcss-animate": "^1.0.7",
    "typescript": "^5.7.2",
    "ua-parser-js": "^0.7.39"
  },
  "devDependencies": {
    "@types/ua-parser-js": "^0.7.39"
  }
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/pnpm-lock.yaml
```yaml
lockfileVersion: '6.0'

settings:
  autoInstallPeers: true
  excludeLinksFromLockfile: false

dependencies:
  '@astrojs/check':
    specifier: ^0.9.3
    version: 0.9.3(typescript@5.6.2)
  '@astrojs/tailwind':
    specifier: ^5.1.1
    version: 5.1.1(astro@4.15.9)(tailwindcss@3.4.13)
  '@oslojs/encoding':
    specifier: ^1.0.0
    version: 1.0.0
  astro:
    specifier: ^4.15.9
    version: 4.15.9(typescript@5.6.2)
  better-auth:
    specifier: 0.0.10-beta.16
    version: 0.0.10-beta.16(@babel/core@7.25.2)(react@18.3.1)(solid-js@1.8.23)(vue@3.5.8)
  tailwindcss:
    specifier: ^3.4.13
    version: 3.4.13
  typescript:
    specifier: ^5.6.2
    version: 5.6.2

packages:

  /@alloc/quick-lru@5.2.0:
    resolution: {integrity: sha512-UrcABB+4bUrFABwbluTIBErXwvbsU/V7TZWfmbgJfbkwiBuziS9gxdODUyuiecfdGQ85jglMW6juS3+z5TsKLw==}
    engines: {node: '>=10'}
    dev: false

  /@ampproject/remapping@2.3.0:
    resolution: {integrity: sha512-30iZtAPgz+LTIYoeivqYo853f02jBYSd5uGnGpkFV0M3xOt9aN73erkgYAmZU43x4VfqcnLxW9Kpg3R5LC4YYw==}
    engines: {node: '>=6.0.0'}
    dependencies:
      '@jridgewell/gen-mapping': 0.3.5
      '@jridgewell/trace-mapping': 0.3.25
    dev: false

  /@astrojs/check@0.9.3(typescript@5.6.2):
    resolution: {integrity: sha512-I6Dz45bMI5YRbp4yK2LKWsHH3/kkHRGdPGruGkLap6pqxhdcNh7oCgN04Ac+haDfc9ow5BYPGPmEhkwef15GQQ==}
    hasBin: true
    peerDependencies:
      typescript: ^5.0.0
    dependencies:
      '@astrojs/language-server': 2.14.2(typescript@5.6.2)
      chokidar: 3.6.0
      fast-glob: 3.3.2
      kleur: 4.1.5
      typescript: 5.6.2
      yargs: 17.7.2
    transitivePeerDependencies:
      - prettier
      - prettier-plugin-astro
    dev: false

  /@astrojs/compiler@2.10.3:
    resolution: {integrity: sha512-bL/O7YBxsFt55YHU021oL+xz+B/9HvGNId3F9xURN16aeqDK9juHGktdkCSXz+U4nqFACq6ZFvWomOzhV+zfPw==}
    dev: false

  /@astrojs/internal-helpers@0.4.1:
    resolution: {integrity: sha512-bMf9jFihO8YP940uD70SI/RDzIhUHJAolWVcO1v5PUivxGKvfLZTLTVVxEYzGYyPsA3ivdLNqMnL5VgmQySa+g==}
    dev: false

  /@astrojs/language-server@2.14.2(typescript@5.6.2):
    resolution: {integrity: sha512-daUJ/+/2pPF3eGG4tVdXKyw0tabUDrJKwLzU8VTuNhEHIn3VZAIES6VT3+mX0lmKcMiKM8/bjZdfY+fPfmnsMA==}
    hasBin: true
    peerDependencies:
      prettier: ^3.0.0
      prettier-plugin-astro: '>=0.11.0'
    peerDependenciesMeta:
      prettier:
        optional: true
      prettier-plugin-astro:
        optional: true
    dependencies:
      '@astrojs/compiler': 2.10.3
      '@astrojs/yaml2ts': 0.2.1
      '@jridgewell/sourcemap-codec': 1.5.0
      '@volar/kit': 2.4.5(typescript@5.6.2)
      '@volar/language-core': 2.4.5
      '@volar/language-server': 2.4.5
      '@volar/language-service': 2.4.5
      '@volar/typescript': 2.4.5
      fast-glob: 3.3.2
      muggle-string: 0.4.1
      volar-service-css: 0.0.61(@volar/language-service@2.4.5)
      volar-service-emmet: 0.0.61(@volar/language-service@2.4.5)
      volar-service-html: 0.0.61(@volar/language-service@2.4.5)
      volar-service-prettier: 0.0.61(@volar/language-service@2.4.5)
      volar-service-typescript: 0.0.61(@volar/language-service@2.4.5)
      volar-service-typescript-twoslash-queries: 0.0.61(@volar/language-service@2.4.5)
      volar-service-yaml: 0.0.61(@volar/language-service@2.4.5)
      vscode-html-languageservice: 5.3.1
      vscode-uri: 3.0.8
    transitivePeerDependencies:
      - typescript
    dev: false

  /@astrojs/markdown-remark@5.2.0:
    resolution: {integrity: sha512-vWGM24KZXz11jR3JO+oqYU3T2qpuOi4uGivJ9SQLCAI01+vEkHC60YJMRvHPc+hwd60F7euNs1PeOEixIIiNQw==}
    dependencies:
      '@astrojs/prism': 3.1.0
      github-slugger: 2.0.0
      hast-util-from-html: 2.0.3
      hast-util-to-text: 4.0.2
      import-meta-resolve: 4.1.0
      mdast-util-definitions: 6.0.0
      rehype-raw: 7.0.0
      rehype-stringify: 10.0.0
      remark-gfm: 4.0.0
      remark-parse: 11.0.0
      remark-rehype: 11.1.1
      remark-smartypants: 3.0.2
      shiki: 1.18.0
      unified: 11.0.5
      unist-util-remove-position: 5.0.0
      unist-util-visit: 5.0.0
      unist-util-visit-parents: 6.0.1
      vfile: 6.0.3
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@astrojs/prism@3.1.0:
    resolution: {integrity: sha512-Z9IYjuXSArkAUx3N6xj6+Bnvx8OdUSHA8YoOgyepp3+zJmtVYJIl/I18GozdJVW1p5u/CNpl3Km7/gwTJK85cw==}
    engines: {node: ^18.17.1 || ^20.3.0 || >=21.0.0}
    dependencies:
      prismjs: 1.29.0
    dev: false

  /@astrojs/tailwind@5.1.1(astro@4.15.9)(tailwindcss@3.4.13):
    resolution: {integrity: sha512-LwurA10uIKcGRxQP2R81RvAnBT0WPKzBntXZBF4hrAefDgM5Uumn0nsGr6tdIjSARgYz4X+Cq/Vh78t3bql3yw==}
    peerDependencies:
      astro: ^3.0.0 || ^4.0.0 || ^5.0.0-beta.0
      tailwindcss: ^3.0.24
    dependencies:
      astro: 4.15.9(typescript@5.6.2)
      autoprefixer: 10.4.20(postcss@8.4.47)
      postcss: 8.4.47
      postcss-load-config: 4.0.2(postcss@8.4.47)
      tailwindcss: 3.4.13
    transitivePeerDependencies:
      - ts-node
    dev: false

  /@astrojs/telemetry@3.1.0:
    resolution: {integrity: sha512-/ca/+D8MIKEC8/A9cSaPUqQNZm+Es/ZinRv0ZAzvu2ios7POQSsVD+VOj7/hypWNsNM3T7RpfgNq7H2TU1KEHA==}
    engines: {node: ^18.17.1 || ^20.3.0 || >=21.0.0}
    dependencies:
      ci-info: 4.0.0
      debug: 4.3.7
      dlv: 1.1.3
      dset: 3.1.4
      is-docker: 3.0.0
      is-wsl: 3.1.0
      which-pm-runs: 1.1.0
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@astrojs/yaml2ts@0.2.1:
    resolution: {integrity: sha512-CBaNwDQJz20E5WxzQh4thLVfhB3JEEGz72wRA+oJp6fQR37QLAqXZJU0mHC+yqMOQ6oj0GfRPJrz6hjf+zm6zA==}
    dependencies:
      yaml: 2.5.1
    dev: false

  /@babel/code-frame@7.24.7:
    resolution: {integrity: sha512-BcYH1CVJBO9tvyIZ2jVeXgSIMvGZ2FDRvDdOIVQyuklNKSsx+eppDEBq/g47Ayw+RqNFE+URvOShmf+f/qwAlA==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@babel/highlight': 7.24.7
      picocolors: 1.1.0
    dev: false

  /@babel/compat-data@7.25.4:
    resolution: {integrity: sha512-+LGRog6RAsCJrrrg/IO6LGmpphNe5DiK30dGjCoxxeGv49B10/3XYGxPsAwrDlMFcFEvdAUavDT8r9k/hSyQqQ==}
    engines: {node: '>=6.9.0'}
    dev: false

  /@babel/core@7.25.2:
    resolution: {integrity: sha512-BBt3opiCOxUr9euZ5/ro/Xv8/V7yJ5bjYMqG/C1YAo8MIKAnumZalCN+msbci3Pigy4lIQfPUpfMM27HMGaYEA==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@ampproject/remapping': 2.3.0
      '@babel/code-frame': 7.24.7
      '@babel/generator': 7.25.6
      '@babel/helper-compilation-targets': 7.25.2
      '@babel/helper-module-transforms': 7.25.2(@babel/core@7.25.2)
      '@babel/helpers': 7.25.6
      '@babel/parser': 7.25.6
      '@babel/template': 7.25.0
      '@babel/traverse': 7.25.6
      '@babel/types': 7.25.6
      convert-source-map: 2.0.0
      debug: 4.3.7
      gensync: 1.0.0-beta.2
      json5: 2.2.3
      semver: 6.3.1
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/generator@7.25.6:
    resolution: {integrity: sha512-VPC82gr1seXOpkjAAKoLhP50vx4vGNlF4msF64dSFq1P8RfB+QAuJWGHPXXPc8QyfVWwwB/TNNU4+ayZmHNbZw==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@babel/types': 7.25.6
      '@jridgewell/gen-mapping': 0.3.5
      '@jridgewell/trace-mapping': 0.3.25
      jsesc: 2.5.2
    dev: false

  /@babel/helper-annotate-as-pure@7.24.7:
    resolution: {integrity: sha512-BaDeOonYvhdKw+JoMVkAixAAJzG2jVPIwWoKBPdYuY9b452e2rPuI9QPYh3KpofZ3pW2akOmwZLOiOsHMiqRAg==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@babel/types': 7.25.6
    dev: false

  /@babel/helper-compilation-targets@7.25.2:
    resolution: {integrity: sha512-U2U5LsSaZ7TAt3cfaymQ8WHh0pxvdHoEk6HVpaexxixjyEquMh0L0YNJNM6CTGKMXV1iksi0iZkGw4AcFkPaaw==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@babel/compat-data': 7.25.4
      '@babel/helper-validator-option': 7.24.8
      browserslist: 4.23.3
      lru-cache: 5.1.1
      semver: 6.3.1
    dev: false

  /@babel/helper-create-class-features-plugin@7.25.4(@babel/core@7.25.2):
    resolution: {integrity: sha512-ro/bFs3/84MDgDmMwbcHgDa8/E6J3QKNTk4xJJnVeFtGE+tL0K26E3pNxhYz2b67fJpt7Aphw5XcploKXuCvCQ==}
    engines: {node: '>=6.9.0'}
    peerDependencies:
      '@babel/core': ^7.0.0
    dependencies:
      '@babel/core': 7.25.2
      '@babel/helper-annotate-as-pure': 7.24.7
      '@babel/helper-member-expression-to-functions': 7.24.8
      '@babel/helper-optimise-call-expression': 7.24.7
      '@babel/helper-replace-supers': 7.25.0(@babel/core@7.25.2)
      '@babel/helper-skip-transparent-expression-wrappers': 7.24.7
      '@babel/traverse': 7.25.6
      semver: 6.3.1
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/helper-member-expression-to-functions@7.24.8:
    resolution: {integrity: sha512-LABppdt+Lp/RlBxqrh4qgf1oEH/WxdzQNDJIu5gC/W1GyvPVrOBiItmmM8wan2fm4oYqFuFfkXmlGpLQhPY8CA==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@babel/traverse': 7.25.6
      '@babel/types': 7.25.6
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/helper-module-imports@7.24.7:
    resolution: {integrity: sha512-8AyH3C+74cgCVVXow/myrynrAGv+nTVg5vKu2nZph9x7RcRwzmh0VFallJuFTZ9mx6u4eSdXZfcOzSqTUm0HCA==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@babel/traverse': 7.25.6
      '@babel/types': 7.25.6
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/helper-module-transforms@7.25.2(@babel/core@7.25.2):
    resolution: {integrity: sha512-BjyRAbix6j/wv83ftcVJmBt72QtHI56C7JXZoG2xATiLpmoC7dpd8WnkikExHDVPpi/3qCmO6WY1EaXOluiecQ==}
    engines: {node: '>=6.9.0'}
    peerDependencies:
      '@babel/core': ^7.0.0
    dependencies:
      '@babel/core': 7.25.2
      '@babel/helper-module-imports': 7.24.7
      '@babel/helper-simple-access': 7.24.7
      '@babel/helper-validator-identifier': 7.24.7
      '@babel/traverse': 7.25.6
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/helper-optimise-call-expression@7.24.7:
    resolution: {integrity: sha512-jKiTsW2xmWwxT1ixIdfXUZp+P5yURx2suzLZr5Hi64rURpDYdMW0pv+Uf17EYk2Rd428Lx4tLsnjGJzYKDM/6A==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@babel/types': 7.25.6
    dev: false

  /@babel/helper-plugin-utils@7.24.8:
    resolution: {integrity: sha512-FFWx5142D8h2Mgr/iPVGH5G7w6jDn4jUSpZTyDnQO0Yn7Ks2Kuz6Pci8H6MPCoUJegd/UZQ3tAvfLCxQSnWWwg==}
    engines: {node: '>=6.9.0'}
    dev: false

  /@babel/helper-replace-supers@7.25.0(@babel/core@7.25.2):
    resolution: {integrity: sha512-q688zIvQVYtZu+i2PsdIu/uWGRpfxzr5WESsfpShfZECkO+d2o+WROWezCi/Q6kJ0tfPa5+pUGUlfx2HhrA3Bg==}
    engines: {node: '>=6.9.0'}
    peerDependencies:
      '@babel/core': ^7.0.0
    dependencies:
      '@babel/core': 7.25.2
      '@babel/helper-member-expression-to-functions': 7.24.8
      '@babel/helper-optimise-call-expression': 7.24.7
      '@babel/traverse': 7.25.6
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/helper-simple-access@7.24.7:
    resolution: {integrity: sha512-zBAIvbCMh5Ts+b86r/CjU+4XGYIs+R1j951gxI3KmmxBMhCg4oQMsv6ZXQ64XOm/cvzfU1FmoCyt6+owc5QMYg==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@babel/traverse': 7.25.6
      '@babel/types': 7.25.6
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/helper-skip-transparent-expression-wrappers@7.24.7:
    resolution: {integrity: sha512-IO+DLT3LQUElMbpzlatRASEyQtfhSE0+m465v++3jyyXeBTBUjtVZg28/gHeV5mrTJqvEKhKroBGAvhW+qPHiQ==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@babel/traverse': 7.25.6
      '@babel/types': 7.25.6
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/helper-string-parser@7.24.8:
    resolution: {integrity: sha512-pO9KhhRcuUyGnJWwyEgnRJTSIZHiT+vMD0kPeD+so0l7mxkMT19g3pjY9GTnHySck/hDzq+dtW/4VgnMkippsQ==}
    engines: {node: '>=6.9.0'}
    dev: false

  /@babel/helper-validator-identifier@7.24.7:
    resolution: {integrity: sha512-rR+PBcQ1SMQDDyF6X0wxtG8QyLCgUB0eRAGguqRLfkCA87l7yAP7ehq8SNj96OOGTO8OBV70KhuFYcIkHXOg0w==}
    engines: {node: '>=6.9.0'}
    dev: false

  /@babel/helper-validator-option@7.24.8:
    resolution: {integrity: sha512-xb8t9tD1MHLungh/AIoWYN+gVHaB9kwlu8gffXGSt3FFEIT7RjS+xWbc2vUD1UTZdIpKj/ab3rdqJ7ufngyi2Q==}
    engines: {node: '>=6.9.0'}
    dev: false

  /@babel/helpers@7.25.6:
    resolution: {integrity: sha512-Xg0tn4HcfTijTwfDwYlvVCl43V6h4KyVVX2aEm4qdO/PC6L2YvzLHFdmxhoeSA3eslcE6+ZVXHgWwopXYLNq4Q==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@babel/template': 7.25.0
      '@babel/types': 7.25.6
    dev: false

  /@babel/highlight@7.24.7:
    resolution: {integrity: sha512-EStJpq4OuY8xYfhGVXngigBJRWxftKX9ksiGDnmlY3o7B/V7KIAc9X4oiK87uPJSc/vs5L869bem5fhZa8caZw==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@babel/helper-validator-identifier': 7.24.7
      chalk: 2.4.2
      js-tokens: 4.0.0
      picocolors: 1.1.0
    dev: false

  /@babel/parser@7.25.6:
    resolution: {integrity: sha512-trGdfBdbD0l1ZPmcJ83eNxB9rbEax4ALFTF7fN386TMYbeCQbyme5cOEXQhbGXKebwGaB/J52w1mrklMcbgy6Q==}
    engines: {node: '>=6.0.0'}
    hasBin: true
    dependencies:
      '@babel/types': 7.25.6
    dev: false

  /@babel/plugin-syntax-jsx@7.24.7(@babel/core@7.25.2):
    resolution: {integrity: sha512-6ddciUPe/mpMnOKv/U+RSd2vvVy+Yw/JfBB0ZHYjEZt9NLHmCUylNYlsbqCCS1Bffjlb0fCwC9Vqz+sBz6PsiQ==}
    engines: {node: '>=6.9.0'}
    peerDependencies:
      '@babel/core': ^7.0.0-0
    dependencies:
      '@babel/core': 7.25.2
      '@babel/helper-plugin-utils': 7.24.8
    dev: false

  /@babel/plugin-syntax-typescript@7.25.4(@babel/core@7.25.2):
    resolution: {integrity: sha512-uMOCoHVU52BsSWxPOMVv5qKRdeSlPuImUCB2dlPuBSU+W2/ROE7/Zg8F2Kepbk+8yBa68LlRKxO+xgEVWorsDg==}
    engines: {node: '>=6.9.0'}
    peerDependencies:
      '@babel/core': ^7.0.0-0
    dependencies:
      '@babel/core': 7.25.2
      '@babel/helper-plugin-utils': 7.24.8
    dev: false

  /@babel/plugin-transform-modules-commonjs@7.24.8(@babel/core@7.25.2):
    resolution: {integrity: sha512-WHsk9H8XxRs3JXKWFiqtQebdh9b/pTk4EgueygFzYlTKAg0Ud985mSevdNjdXdFBATSKVJGQXP1tv6aGbssLKA==}
    engines: {node: '>=6.9.0'}
    peerDependencies:
      '@babel/core': ^7.0.0-0
    dependencies:
      '@babel/core': 7.25.2
      '@babel/helper-module-transforms': 7.25.2(@babel/core@7.25.2)
      '@babel/helper-plugin-utils': 7.24.8
      '@babel/helper-simple-access': 7.24.7
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/plugin-transform-react-display-name@7.24.7(@babel/core@7.25.2):
    resolution: {integrity: sha512-H/Snz9PFxKsS1JLI4dJLtnJgCJRoo0AUm3chP6NYr+9En1JMKloheEiLIhlp5MDVznWo+H3AAC1Mc8lmUEpsgg==}
    engines: {node: '>=6.9.0'}
    peerDependencies:
      '@babel/core': ^7.0.0-0
    dependencies:
      '@babel/core': 7.25.2
      '@babel/helper-plugin-utils': 7.24.8
    dev: false

  /@babel/plugin-transform-react-jsx-development@7.24.7(@babel/core@7.25.2):
    resolution: {integrity: sha512-QG9EnzoGn+Qar7rxuW+ZOsbWOt56FvvI93xInqsZDC5fsekx1AlIO4KIJ5M+D0p0SqSH156EpmZyXq630B8OlQ==}
    engines: {node: '>=6.9.0'}
    peerDependencies:
      '@babel/core': ^7.0.0-0
    dependencies:
      '@babel/core': 7.25.2
      '@babel/plugin-transform-react-jsx': 7.25.2(@babel/core@7.25.2)
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/plugin-transform-react-jsx@7.25.2(@babel/core@7.25.2):
    resolution: {integrity: sha512-KQsqEAVBpU82NM/B/N9j9WOdphom1SZH3R+2V7INrQUH+V9EBFwZsEJl8eBIVeQE62FxJCc70jzEZwqU7RcVqA==}
    engines: {node: '>=6.9.0'}
    peerDependencies:
      '@babel/core': ^7.0.0-0
    dependencies:
      '@babel/core': 7.25.2
      '@babel/helper-annotate-as-pure': 7.24.7
      '@babel/helper-module-imports': 7.24.7
      '@babel/helper-plugin-utils': 7.24.8
      '@babel/plugin-syntax-jsx': 7.24.7(@babel/core@7.25.2)
      '@babel/types': 7.25.6
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/plugin-transform-react-pure-annotations@7.24.7(@babel/core@7.25.2):
    resolution: {integrity: sha512-PLgBVk3fzbmEjBJ/u8kFzOqS9tUeDjiaWud/rRym/yjCo/M9cASPlnrd2ZmmZpQT40fOOrvR8jh+n8jikrOhNA==}
    engines: {node: '>=6.9.0'}
    peerDependencies:
      '@babel/core': ^7.0.0-0
    dependencies:
      '@babel/core': 7.25.2
      '@babel/helper-annotate-as-pure': 7.24.7
      '@babel/helper-plugin-utils': 7.24.8
    dev: false

  /@babel/plugin-transform-typescript@7.25.2(@babel/core@7.25.2):
    resolution: {integrity: sha512-lBwRvjSmqiMYe/pS0+1gggjJleUJi7NzjvQ1Fkqtt69hBa/0t1YuW/MLQMAPixfwaQOHUXsd6jeU3Z+vdGv3+A==}
    engines: {node: '>=6.9.0'}
    peerDependencies:
      '@babel/core': ^7.0.0-0
    dependencies:
      '@babel/core': 7.25.2
      '@babel/helper-annotate-as-pure': 7.24.7
      '@babel/helper-create-class-features-plugin': 7.25.4(@babel/core@7.25.2)
      '@babel/helper-plugin-utils': 7.24.8
      '@babel/helper-skip-transparent-expression-wrappers': 7.24.7
      '@babel/plugin-syntax-typescript': 7.25.4(@babel/core@7.25.2)
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/preset-react@7.24.7(@babel/core@7.25.2):
    resolution: {integrity: sha512-AAH4lEkpmzFWrGVlHaxJB7RLH21uPQ9+He+eFLWHmF9IuFQVugz8eAsamaW0DXRrTfco5zj1wWtpdcXJUOfsag==}
    engines: {node: '>=6.9.0'}
    peerDependencies:
      '@babel/core': ^7.0.0-0
    dependencies:
      '@babel/core': 7.25.2
      '@babel/helper-plugin-utils': 7.24.8
      '@babel/helper-validator-option': 7.24.8
      '@babel/plugin-transform-react-display-name': 7.24.7(@babel/core@7.25.2)
      '@babel/plugin-transform-react-jsx': 7.25.2(@babel/core@7.25.2)
      '@babel/plugin-transform-react-jsx-development': 7.24.7(@babel/core@7.25.2)
      '@babel/plugin-transform-react-pure-annotations': 7.24.7(@babel/core@7.25.2)
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/preset-typescript@7.24.7(@babel/core@7.25.2):
    resolution: {integrity: sha512-SyXRe3OdWwIwalxDg5UtJnJQO+YPcTfwiIY2B0Xlddh9o7jpWLvv8X1RthIeDOxQ+O1ML5BLPCONToObyVQVuQ==}
    engines: {node: '>=6.9.0'}
    peerDependencies:
      '@babel/core': ^7.0.0-0
    dependencies:
      '@babel/core': 7.25.2
      '@babel/helper-plugin-utils': 7.24.8
      '@babel/helper-validator-option': 7.24.8
      '@babel/plugin-syntax-jsx': 7.24.7(@babel/core@7.25.2)
      '@babel/plugin-transform-modules-commonjs': 7.24.8(@babel/core@7.25.2)
      '@babel/plugin-transform-typescript': 7.25.2(@babel/core@7.25.2)
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/template@7.25.0:
    resolution: {integrity: sha512-aOOgh1/5XzKvg1jvVz7AVrx2piJ2XBi227DHmbY6y+bM9H2FlN+IfecYu4Xl0cNiiVejlsCri89LUsbj8vJD9Q==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@babel/code-frame': 7.24.7
      '@babel/parser': 7.25.6
      '@babel/types': 7.25.6
    dev: false

  /@babel/traverse@7.25.6:
    resolution: {integrity: sha512-9Vrcx5ZW6UwK5tvqsj0nGpp/XzqthkT0dqIc9g1AdtygFToNtTF67XzYS//dm+SAK9cp3B9R4ZO/46p63SCjlQ==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@babel/code-frame': 7.24.7
      '@babel/generator': 7.25.6
      '@babel/parser': 7.25.6
      '@babel/template': 7.25.0
      '@babel/types': 7.25.6
      debug: 4.3.7
      globals: 11.12.0
    transitivePeerDependencies:
      - supports-color
    dev: false

  /@babel/types@7.25.6:
    resolution: {integrity: sha512-/l42B1qxpG6RdfYf343Uw1vmDjeNhneUXtzhojE7pDgfpEypmRhI6j1kr17XCVv4Cgl9HdAiQY2x0GwKm7rWCw==}
    engines: {node: '>=6.9.0'}
    dependencies:
      '@babel/helper-string-parser': 7.24.8
      '@babel/helper-validator-identifier': 7.24.7
      to-fast-properties: 2.0.0
    dev: false

  /@better-fetch/fetch@1.1.9:
    resolution: {integrity: sha512-eeWQ4X9eewQgn8RC26oI8oW5DO8WRfD85hFOvOCbtG5UABqEh+vAmBEY7S6r56BTXzOsK+fVH204JTlvacxTew==}
    dev: false

  /@better-fetch/logger@1.1.3:
    resolution: {integrity: sha512-GuT6bbE+g10eIdUwW5ctOikryAnvb8i/c5HHttKZu1OFygVV82pX8JxyobtZZV9Z8Md03qNEV0PvaUDbBd9sHQ==}
    dependencies:
      consola: 3.2.3
    dev: false

  /@emmetio/abbreviation@2.3.3:
    resolution: {integrity: sha512-mgv58UrU3rh4YgbE/TzgLQwJ3pFsHHhCLqY20aJq+9comytTXUDNGG/SMtSeMJdkpxgXSXunBGLD8Boka3JyVA==}
    dependencies:
      '@emmetio/scanner': 1.0.4
    dev: false

  /@emmetio/css-abbreviation@2.1.8:
    resolution: {integrity: sha512-s9yjhJ6saOO/uk1V74eifykk2CBYi01STTK3WlXWGOepyKa23ymJ053+DNQjpFcy1ingpaO7AxCcwLvHFY9tuw==}
    dependencies:
      '@emmetio/scanner': 1.0.4
    dev: false

  /@emmetio/css-parser@0.4.0:
    resolution: {integrity: sha512-z7wkxRSZgrQHXVzObGkXG+Vmj3uRlpM11oCZ9pbaz0nFejvCDmAiNDpY75+wgXOcffKpj4rzGtwGaZxfJKsJxw==}
    dependencies:
      '@emmetio/stream-reader': 2.2.0
      '@emmetio/stream-reader-utils': 0.1.0
    dev: false

  /@emmetio/html-matcher@1.3.0:
    resolution: {integrity: sha512-NTbsvppE5eVyBMuyGfVu2CRrLvo7J4YHb6t9sBFLyY03WYhXET37qA4zOYUjBWFCRHO7pS1B9khERtY0f5JXPQ==}
    dependencies:
      '@emmetio/scanner': 1.0.4
    dev: false

  /@emmetio/scanner@1.0.4:
    resolution: {integrity: sha512-IqRuJtQff7YHHBk4G8YZ45uB9BaAGcwQeVzgj/zj8/UdOhtQpEIupUhSk8dys6spFIWVZVeK20CzGEnqR5SbqA==}
    dev: false

  /@emmetio/stream-reader-utils@0.1.0:
    resolution: {integrity: sha512-ZsZ2I9Vzso3Ho/pjZFsmmZ++FWeEd/txqybHTm4OgaZzdS8V9V/YYWQwg5TC38Z7uLWUV1vavpLLbjJtKubR1A==}
    dev: false

  /@emmetio/stream-reader@2.2.0:
    resolution: {integrity: sha512-fXVXEyFA5Yv3M3n8sUGT7+fvecGrZP4k6FnWWMSZVQf69kAq0LLpaBQLGcPR30m3zMmKYhECP4k/ZkzvhEW5kw==}
    dev: false

  /@emnapi/core@0.45.0:
    resolution: {integrity: sha512-DPWjcUDQkCeEM4VnljEOEcXdAD7pp8zSZsgOujk/LGIwCXWbXJngin+MO4zbH429lzeC3WbYLGjE2MaUOwzpyw==}
    requiresBuild: true
    dependencies:
      tslib: 2.7.0
    dev: false
    optional: true

  /@emnapi/runtime@0.45.0:
    resolution: {integrity: sha512-Txumi3td7J4A/xTTwlssKieHKTGl3j4A1tglBx72auZ49YK7ePY6XZricgIg9mnZT4xPfA+UPCUdnhRuEFDL+w==}
    requiresBuild: true
    dependencies:
      tslib: 2.7.0
    dev: false
    optional: true

  /@emnapi/runtime@1.2.0:
    resolution: {integrity: sha512-bV21/9LQmcQeCPEg3BDFtvwL6cwiTMksYNWQQ4KOxCZikEGalWtenoZ0wCiukJINlGCIi2KXx01g4FoH/LxpzQ==}
    requiresBuild: true
    dependencies:
      tslib: 2.7.0
    dev: false
    optional: true

  /@esbuild/aix-ppc64@0.21.5:
    resolution: {integrity: sha512-1SDgH6ZSPTlggy1yI6+Dbkiz8xzpHJEVAlF/AM1tHPLsf5STom9rwtjE4hKAF20FfXXNTFqEYXyJNWh1GiZedQ==}
    engines: {node: '>=12'}
    cpu: [ppc64]
    os: [aix]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/android-arm64@0.21.5:
    resolution: {integrity: sha512-c0uX9VAUBQ7dTDCjq+wdyGLowMdtR/GoC2U5IYk/7D1H1JYC0qseD7+11iMP2mRLN9RcCMRcjC4YMclCzGwS/A==}
    engines: {node: '>=12'}
    cpu: [arm64]
    os: [android]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/android-arm@0.21.5:
    resolution: {integrity: sha512-vCPvzSjpPHEi1siZdlvAlsPxXl7WbOVUBBAowWug4rJHb68Ox8KualB+1ocNvT5fjv6wpkX6o/iEpbDrf68zcg==}
    engines: {node: '>=12'}
    cpu: [arm]
    os: [android]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/android-x64@0.21.5:
    resolution: {integrity: sha512-D7aPRUUNHRBwHxzxRvp856rjUHRFW1SdQATKXH2hqA0kAZb1hKmi02OpYRacl0TxIGz/ZmXWlbZgjwWYaCakTA==}
    engines: {node: '>=12'}
    cpu: [x64]
    os: [android]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/darwin-arm64@0.21.5:
    resolution: {integrity: sha512-DwqXqZyuk5AiWWf3UfLiRDJ5EDd49zg6O9wclZ7kUMv2WRFr4HKjXp/5t8JZ11QbQfUS6/cRCKGwYhtNAY88kQ==}
    engines: {node: '>=12'}
    cpu: [arm64]
    os: [darwin]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/darwin-x64@0.21.5:
    resolution: {integrity: sha512-se/JjF8NlmKVG4kNIuyWMV/22ZaerB+qaSi5MdrXtd6R08kvs2qCN4C09miupktDitvh8jRFflwGFBQcxZRjbw==}
    engines: {node: '>=12'}
    cpu: [x64]
    os: [darwin]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/freebsd-arm64@0.21.5:
    resolution: {integrity: sha512-5JcRxxRDUJLX8JXp/wcBCy3pENnCgBR9bN6JsY4OmhfUtIHe3ZW0mawA7+RDAcMLrMIZaf03NlQiX9DGyB8h4g==}
    engines: {node: '>=12'}
    cpu: [arm64]
    os: [freebsd]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/freebsd-x64@0.21.5:
    resolution: {integrity: sha512-J95kNBj1zkbMXtHVH29bBriQygMXqoVQOQYA+ISs0/2l3T9/kj42ow2mpqerRBxDJnmkUDCaQT/dfNXWX/ZZCQ==}
    engines: {node: '>=12'}
    cpu: [x64]
    os: [freebsd]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/linux-arm64@0.21.5:
    resolution: {integrity: sha512-ibKvmyYzKsBeX8d8I7MH/TMfWDXBF3db4qM6sy+7re0YXya+K1cem3on9XgdT2EQGMu4hQyZhan7TeQ8XkGp4Q==}
    engines: {node: '>=12'}
    cpu: [arm64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/linux-arm@0.21.5:
    resolution: {integrity: sha512-bPb5AHZtbeNGjCKVZ9UGqGwo8EUu4cLq68E95A53KlxAPRmUyYv2D6F0uUI65XisGOL1hBP5mTronbgo+0bFcA==}
    engines: {node: '>=12'}
    cpu: [arm]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/linux-ia32@0.21.5:
    resolution: {integrity: sha512-YvjXDqLRqPDl2dvRODYmmhz4rPeVKYvppfGYKSNGdyZkA01046pLWyRKKI3ax8fbJoK5QbxblURkwK/MWY18Tg==}
    engines: {node: '>=12'}
    cpu: [ia32]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/linux-loong64@0.21.5:
    resolution: {integrity: sha512-uHf1BmMG8qEvzdrzAqg2SIG/02+4/DHB6a9Kbya0XDvwDEKCoC8ZRWI5JJvNdUjtciBGFQ5PuBlpEOXQj+JQSg==}
    engines: {node: '>=12'}
    cpu: [loong64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/linux-mips64el@0.21.5:
    resolution: {integrity: sha512-IajOmO+KJK23bj52dFSNCMsz1QP1DqM6cwLUv3W1QwyxkyIWecfafnI555fvSGqEKwjMXVLokcV5ygHW5b3Jbg==}
    engines: {node: '>=12'}
    cpu: [mips64el]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/linux-ppc64@0.21.5:
    resolution: {integrity: sha512-1hHV/Z4OEfMwpLO8rp7CvlhBDnjsC3CttJXIhBi+5Aj5r+MBvy4egg7wCbe//hSsT+RvDAG7s81tAvpL2XAE4w==}
    engines: {node: '>=12'}
    cpu: [ppc64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/linux-riscv64@0.21.5:
    resolution: {integrity: sha512-2HdXDMd9GMgTGrPWnJzP2ALSokE/0O5HhTUvWIbD3YdjME8JwvSCnNGBnTThKGEB91OZhzrJ4qIIxk/SBmyDDA==}
    engines: {node: '>=12'}
    cpu: [riscv64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/linux-s390x@0.21.5:
    resolution: {integrity: sha512-zus5sxzqBJD3eXxwvjN1yQkRepANgxE9lgOW2qLnmr8ikMTphkjgXu1HR01K4FJg8h1kEEDAqDcZQtbrRnB41A==}
    engines: {node: '>=12'}
    cpu: [s390x]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/linux-x64@0.21.5:
    resolution: {integrity: sha512-1rYdTpyv03iycF1+BhzrzQJCdOuAOtaqHTWJZCWvijKD2N5Xu0TtVC8/+1faWqcP9iBCWOmjmhoH94dH82BxPQ==}
    engines: {node: '>=12'}
    cpu: [x64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/netbsd-x64@0.21.5:
    resolution: {integrity: sha512-Woi2MXzXjMULccIwMnLciyZH4nCIMpWQAs049KEeMvOcNADVxo0UBIQPfSmxB3CWKedngg7sWZdLvLczpe0tLg==}
    engines: {node: '>=12'}
    cpu: [x64]
    os: [netbsd]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/openbsd-x64@0.21.5:
    resolution: {integrity: sha512-HLNNw99xsvx12lFBUwoT8EVCsSvRNDVxNpjZ7bPn947b8gJPzeHWyNVhFsaerc0n3TsbOINvRP2byTZ5LKezow==}
    engines: {node: '>=12'}
    cpu: [x64]
    os: [openbsd]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/sunos-x64@0.21.5:
    resolution: {integrity: sha512-6+gjmFpfy0BHU5Tpptkuh8+uw3mnrvgs+dSPQXQOv3ekbordwnzTVEb4qnIvQcYXq6gzkyTnoZ9dZG+D4garKg==}
    engines: {node: '>=12'}
    cpu: [x64]
    os: [sunos]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/win32-arm64@0.21.5:
    resolution: {integrity: sha512-Z0gOTd75VvXqyq7nsl93zwahcTROgqvuAcYDUr+vOv8uHhNSKROyU961kgtCD1e95IqPKSQKH7tBTslnS3tA8A==}
    engines: {node: '>=12'}
    cpu: [arm64]
    os: [win32]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/win32-ia32@0.21.5:
    resolution: {integrity: sha512-SWXFF1CL2RVNMaVs+BBClwtfZSvDgtL//G/smwAc5oVK/UPu2Gu9tIaRgFmYFFKrmg3SyAjSrElf0TiJ1v8fYA==}
    engines: {node: '>=12'}
    cpu: [ia32]
    os: [win32]
    requiresBuild: true
    dev: false
    optional: true

  /@esbuild/win32-x64@0.21.5:
    resolution: {integrity: sha512-tQd/1efJuzPC6rCFwEvLtci/xNFcTZknmXs98FYDfGE4wP9ClFV98nyKrzJKVPMhdDnjzLhdUyMX4PsQAPjwIw==}
    engines: {node: '>=12'}
    cpu: [x64]
    os: [win32]
    requiresBuild: true
    dev: false
    optional: true

  /@hexagon/base64@1.1.28:
    resolution: {integrity: sha512-lhqDEAvWixy3bZ+UOYbPwUbBkwBq5C1LAJ/xPC8Oi+lL54oyakv/npbA0aU2hgCsx/1NUd4IBvV03+aUBWxerw==}
    dev: false

  /@img/sharp-darwin-arm64@0.33.5:
    resolution: {integrity: sha512-UT4p+iz/2H4twwAoLCqfA9UH5pI6DggwKEGuaPy7nCVQ8ZsiY5PIcrRvD1DzuY3qYL07NtIQcWnBSY/heikIFQ==}
    engines: {node: ^18.17.0 || ^20.3.0 || >=21.0.0}
    cpu: [arm64]
    os: [darwin]
    requiresBuild: true
    optionalDependencies:
      '@img/sharp-libvips-darwin-arm64': 1.0.4
    dev: false
    optional: true

  /@img/sharp-darwin-x64@0.33.5:
    resolution: {integrity: sha512-fyHac4jIc1ANYGRDxtiqelIbdWkIuQaI84Mv45KvGRRxSAa7o7d1ZKAOBaYbnepLC1WqxfpimdeWfvqqSGwR2Q==}
    engines: {node: ^18.17.0 || ^20.3.0 || >=21.0.0}
    cpu: [x64]
    os: [darwin]
    requiresBuild: true
    optionalDependencies:
      '@img/sharp-libvips-darwin-x64': 1.0.4
    dev: false
    optional: true

  /@img/sharp-libvips-darwin-arm64@1.0.4:
    resolution: {integrity: sha512-XblONe153h0O2zuFfTAbQYAX2JhYmDHeWikp1LM9Hul9gVPjFY427k6dFEcOL72O01QxQsWi761svJ/ev9xEDg==}
    cpu: [arm64]
    os: [darwin]
    requiresBuild: true
    dev: false
    optional: true

  /@img/sharp-libvips-darwin-x64@1.0.4:
    resolution: {integrity: sha512-xnGR8YuZYfJGmWPvmlunFaWJsb9T/AO2ykoP3Fz/0X5XV2aoYBPkX6xqCQvUTKKiLddarLaxpzNe+b1hjeWHAQ==}
    cpu: [x64]
    os: [darwin]
    requiresBuild: true
    dev: false
    optional: true

  /@img/sharp-libvips-linux-arm64@1.0.4:
    resolution: {integrity: sha512-9B+taZ8DlyyqzZQnoeIvDVR/2F4EbMepXMc/NdVbkzsJbzkUjhXv/70GQJ7tdLA4YJgNP25zukcxpX2/SueNrA==}
    cpu: [arm64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@img/sharp-libvips-linux-arm@1.0.5:
    resolution: {integrity: sha512-gvcC4ACAOPRNATg/ov8/MnbxFDJqf/pDePbBnuBDcjsI8PssmjoKMAz4LtLaVi+OnSb5FK/yIOamqDwGmXW32g==}
    cpu: [arm]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@img/sharp-libvips-linux-s390x@1.0.4:
    resolution: {integrity: sha512-u7Wz6ntiSSgGSGcjZ55im6uvTrOxSIS8/dgoVMoiGE9I6JAfU50yH5BoDlYA1tcuGS7g/QNtetJnxA6QEsCVTA==}
    cpu: [s390x]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@img/sharp-libvips-linux-x64@1.0.4:
    resolution: {integrity: sha512-MmWmQ3iPFZr0Iev+BAgVMb3ZyC4KeFc3jFxnNbEPas60e1cIfevbtuyf9nDGIzOaW9PdnDciJm+wFFaTlj5xYw==}
    cpu: [x64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@img/sharp-libvips-linuxmusl-arm64@1.0.4:
    resolution: {integrity: sha512-9Ti+BbTYDcsbp4wfYib8Ctm1ilkugkA/uscUn6UXK1ldpC1JjiXbLfFZtRlBhjPZ5o1NCLiDbg8fhUPKStHoTA==}
    cpu: [arm64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@img/sharp-libvips-linuxmusl-x64@1.0.4:
    resolution: {integrity: sha512-viYN1KX9m+/hGkJtvYYp+CCLgnJXwiQB39damAO7WMdKWlIhmYTfHjwSbQeUK/20vY154mwezd9HflVFM1wVSw==}
    cpu: [x64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@img/sharp-linux-arm64@0.33.5:
    resolution: {integrity: sha512-JMVv+AMRyGOHtO1RFBiJy/MBsgz0x4AWrT6QoEVVTyh1E39TrCUpTRI7mx9VksGX4awWASxqCYLCV4wBZHAYxA==}
    engines: {node: ^18.17.0 || ^20.3.0 || >=21.0.0}
    cpu: [arm64]
    os: [linux]
    requiresBuild: true
    optionalDependencies:
      '@img/sharp-libvips-linux-arm64': 1.0.4
    dev: false
    optional: true

  /@img/sharp-linux-arm@0.33.5:
    resolution: {integrity: sha512-JTS1eldqZbJxjvKaAkxhZmBqPRGmxgu+qFKSInv8moZ2AmT5Yib3EQ1c6gp493HvrvV8QgdOXdyaIBrhvFhBMQ==}
    engines: {node: ^18.17.0 || ^20.3.0 || >=21.0.0}
    cpu: [arm]
    os: [linux]
    requiresBuild: true
    optionalDependencies:
      '@img/sharp-libvips-linux-arm': 1.0.5
    dev: false
    optional: true

  /@img/sharp-linux-s390x@0.33.5:
    resolution: {integrity: sha512-y/5PCd+mP4CA/sPDKl2961b+C9d+vPAveS33s6Z3zfASk2j5upL6fXVPZi7ztePZ5CuH+1kW8JtvxgbuXHRa4Q==}
    engines: {node: ^18.17.0 || ^20.3.0 || >=21.0.0}
    cpu: [s390x]
    os: [linux]
    requiresBuild: true
    optionalDependencies:
      '@img/sharp-libvips-linux-s390x': 1.0.4
    dev: false
    optional: true

  /@img/sharp-linux-x64@0.33.5:
    resolution: {integrity: sha512-opC+Ok5pRNAzuvq1AG0ar+1owsu842/Ab+4qvU879ippJBHvyY5n2mxF1izXqkPYlGuP/M556uh53jRLJmzTWA==}
    engines: {node: ^18.17.0 || ^20.3.0 || >=21.0.0}
    cpu: [x64]
    os: [linux]
    requiresBuild: true
    optionalDependencies:
      '@img/sharp-libvips-linux-x64': 1.0.4
    dev: false
    optional: true

  /@img/sharp-linuxmusl-arm64@0.33.5:
    resolution: {integrity: sha512-XrHMZwGQGvJg2V/oRSUfSAfjfPxO+4DkiRh6p2AFjLQztWUuY/o8Mq0eMQVIY7HJ1CDQUJlxGGZRw1a5bqmd1g==}
    engines: {node: ^18.17.0 || ^20.3.0 || >=21.0.0}
    cpu: [arm64]
    os: [linux]
    requiresBuild: true
    optionalDependencies:
      '@img/sharp-libvips-linuxmusl-arm64': 1.0.4
    dev: false
    optional: true

  /@img/sharp-linuxmusl-x64@0.33.5:
    resolution: {integrity: sha512-WT+d/cgqKkkKySYmqoZ8y3pxx7lx9vVejxW/W4DOFMYVSkErR+w7mf2u8m/y4+xHe7yY9DAXQMWQhpnMuFfScw==}
    engines: {node: ^18.17.0 || ^20.3.0 || >=21.0.0}
    cpu: [x64]
    os: [linux]
    requiresBuild: true
    optionalDependencies:
      '@img/sharp-libvips-linuxmusl-x64': 1.0.4
    dev: false
    optional: true

  /@img/sharp-wasm32@0.33.5:
    resolution: {integrity: sha512-ykUW4LVGaMcU9lu9thv85CbRMAwfeadCJHRsg2GmeRa/cJxsVY9Rbd57JcMxBkKHag5U/x7TSBpScF4U8ElVzg==}
    engines: {node: ^18.17.0 || ^20.3.0 || >=21.0.0}
    cpu: [wasm32]
    requiresBuild: true
    dependencies:
      '@emnapi/runtime': 1.2.0
    dev: false
    optional: true

  /@img/sharp-win32-ia32@0.33.5:
    resolution: {integrity: sha512-T36PblLaTwuVJ/zw/LaH0PdZkRz5rd3SmMHX8GSmR7vtNSP5Z6bQkExdSK7xGWyxLw4sUknBuugTelgw2faBbQ==}
    engines: {node: ^18.17.0 || ^20.3.0 || >=21.0.0}
    cpu: [ia32]
    os: [win32]
    requiresBuild: true
    dev: false
    optional: true

  /@img/sharp-win32-x64@0.33.5:
    resolution: {integrity: sha512-MpY/o8/8kj+EcnxwvrP4aTJSWw/aZ7JIGR4aBeZkZw5B7/Jn+tY9/VNwtcoGmdT7GfggGIU4kygOMSbYnOrAbg==}
    engines: {node: ^18.17.0 || ^20.3.0 || >=21.0.0}
    cpu: [x64]
    os: [win32]
    requiresBuild: true
    dev: false
    optional: true

  /@isaacs/cliui@8.0.2:
    resolution: {integrity: sha512-O8jcjabXaleOG9DQ0+ARXWZBTfnP4WNAqzuiJK7ll44AmxGKv/J2M4TPjxjY3znBCfvBXFzucm1twdyFybFqEA==}
    engines: {node: '>=12'}
    dependencies:
      string-width: 5.1.2
      string-width-cjs: /string-width@4.2.3
      strip-ansi: 7.1.0
      strip-ansi-cjs: /strip-ansi@6.0.1
      wrap-ansi: 8.1.0
      wrap-ansi-cjs: /wrap-ansi@7.0.0
    dev: false

  /@jridgewell/gen-mapping@0.3.5:
    resolution: {integrity: sha512-IzL8ZoEDIBRWEzlCcRhOaCupYyN5gdIK+Q6fbFdPDg6HqX6jpkItn7DFIpW9LQzXG6Df9sA7+OKnq0qlz/GaQg==}
    engines: {node: '>=6.0.0'}
    dependencies:
      '@jridgewell/set-array': 1.2.1
      '@jridgewell/sourcemap-codec': 1.5.0
      '@jridgewell/trace-mapping': 0.3.25
    dev: false

  /@jridgewell/resolve-uri@3.1.2:
    resolution: {integrity: sha512-bRISgCIjP20/tbWSPWMEi54QVPRZExkuD9lJL+UIxUKtwVJA8wW1Trb1jMs1RFXo1CBTNZ/5hpC9QvmKWdopKw==}
    engines: {node: '>=6.0.0'}
    dev: false

  /@jridgewell/set-array@1.2.1:
    resolution: {integrity: sha512-R8gLRTZeyp03ymzP/6Lil/28tGeGEzhx1q2k703KGWRAI1VdvPIXdG70VJc2pAMw3NA6JKL5hhFu1sJX0Mnn/A==}
    engines: {node: '>=6.0.0'}
    dev: false

  /@jridgewell/sourcemap-codec@1.5.0:
    resolution: {integrity: sha512-gv3ZRaISU3fjPAgNsriBRqGWQL6quFx04YMPW/zD8XMLsU32mhCCbfbO6KZFLjvYpCZ8zyDEgqsgf+PwPaM7GQ==}
    dev: false

  /@jridgewell/trace-mapping@0.3.25:
    resolution: {integrity: sha512-vNk6aEwybGtawWmy/PzwnGDOjCkLWSD2wqvjGGAgOAwCGWySYXfYoxt00IJkTF+8Lb57DwOb3Aa0o9CApepiYQ==}
    dependencies:
      '@jridgewell/resolve-uri': 3.1.2
      '@jridgewell/sourcemap-codec': 1.5.0
    dev: false

  /@levischuck/tiny-cbor@0.2.2:
    resolution: {integrity: sha512-f5CnPw997Y2GQ8FAvtuVVC19FX8mwNNC+1XJcIi16n/LTJifKO6QBgGLgN3YEmqtGMk17SKSuoWES3imJVxAVw==}
    dev: false

  /@nanostores/query@0.3.4(nanostores@0.11.3):
    resolution: {integrity: sha512-Gw5HsKflUDefhcZpVwVoIfw2Hz2+8FsInpVQOQ45EWz2FijaJll5aQWSE5JbYUsU/uAnYuKm5NM5ZgBH9HhniQ==}
    engines: {node: ^14.0.0 || ^16.0.0 || >=18.0.0}
    peerDependencies:
      nanostores: '>=0.10'
    dependencies:
      nanoevents: 9.0.0
      nanostores: 0.11.3
    dev: false

  /@nanostores/react@0.7.3(nanostores@0.11.3)(react@18.3.1):
    resolution: {integrity: sha512-/XuLAMENRu/Q71biW4AZ4qmU070vkZgiQ28gaTSNRPm2SZF5zGAR81zPE1MaMB4SeOp6ZTst92NBaG75XSspNg==}
    engines: {node: ^18.0.0 || >=20.0.0}
    peerDependencies:
      nanostores: ^0.9.0 || ^0.10.0 || ^0.11.0
      react: '>=18.0.0'
    dependencies:
      nanostores: 0.11.3
      react: 18.3.1
    dev: false

  /@nanostores/solid@0.4.2(nanostores@0.11.3)(solid-js@1.8.23):
    resolution: {integrity: sha512-8v32+C9KdRbnvP4x4Oiw/CtL1tZwbRxYfmFsPIY9PXevCgxSFnicG6VnLLtNAR7F0kl8Ec7OROHO34Ffv0KDzg==}
    peerDependencies:
      nanostores: '>=0.8.0'
      solid-js: ^1.6.0
    dependencies:
      nanostores: 0.11.3
      solid-js: 1.8.23
    dev: false

  /@nanostores/vue@0.10.0(nanostores@0.11.3)(vue@3.5.8):
    resolution: {integrity: sha512-832RAUbzRfHPs1CdqVEwfvgB2+RD/INji4Zo8bUSEfRO2pQRMMeq479gydnohGpRaa0oNwlfKo7TGFXCghq/1g==}
    engines: {node: ^18.0.0 || >=20.0.0}
    peerDependencies:
      '@nanostores/logger': '>=0.2.3'
      '@vue/devtools-api': '>=6.5.0'
      nanostores: '>=0.9.2'
      vue: '>=3.3.1'
    peerDependenciesMeta:
      '@nanostores/logger':
        optional: true
      '@vue/devtools-api':
        optional: true
    dependencies:
      nanostores: 0.11.3
      vue: 3.5.8(typescript@5.6.2)
    dev: false

  /@noble/ciphers@0.6.0:
    resolution: {integrity: sha512-mIbq/R9QXk5/cTfESb1OKtyFnk7oc1Om/8onA1158K9/OZUQFDEVy55jVTato+xmp3XX6F6Qh0zz0Nc1AxAlRQ==}
    dev: false

  /@noble/hashes@1.5.0:
    resolution: {integrity: sha512-1j6kQFb7QRru7eKN3ZDvRcP13rugwdxZqCjbiAVZfIJwgj2A65UmT4TgARXGlXgnRkORLTDTrO19ZErt7+QXgA==}
    engines: {node: ^14.21.3 || >=16}
    dev: false

  /@node-rs/argon2-android-arm-eabi@1.7.0:
    resolution: {integrity: sha512-udDqkr5P9E+wYX1SZwAVPdyfYvaF4ry9Tm+R9LkfSHbzWH0uhU6zjIwNRp7m+n4gx691rk+lqqDAIP8RLKwbhg==}
    engines: {node: '>= 10'}
    cpu: [arm]
    os: [android]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/argon2-android-arm64@1.7.0:
    resolution: {integrity: sha512-s9j/G30xKUx8WU50WIhF0fIl1EdhBGq0RQ06lEhZ0Gi0ap8lhqbE2Bn5h3/G2D1k0Dx+yjeVVNmt/xOQIRG38A==}
    engines: {node: '>= 10'}
    cpu: [arm64]
    os: [android]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/argon2-darwin-arm64@1.7.0:
    resolution: {integrity: sha512-ZIz4L6HGOB9U1kW23g+m7anGNuTZ0RuTw0vNp3o+2DWpb8u8rODq6A8tH4JRL79S+Co/Nq608m9uackN2pe0Rw==}
    engines: {node: '>= 10'}
    cpu: [arm64]
    os: [darwin]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/argon2-darwin-x64@1.7.0:
    resolution: {integrity: sha512-5oi/pxqVhODW/pj1+3zElMTn/YukQeywPHHYDbcAW3KsojFjKySfhcJMd1DjKTc+CHQI+4lOxZzSUzK7mI14Hw==}
    engines: {node: '>= 10'}
    cpu: [x64]
    os: [darwin]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/argon2-freebsd-x64@1.7.0:
    resolution: {integrity: sha512-Ify08683hA4QVXYoIm5SUWOY5DPIT/CMB0CQT+IdxQAg/F+qp342+lUkeAtD5bvStQuCx/dFO3bnnzoe2clMhA==}
    engines: {node: '>= 10'}
    cpu: [x64]
    os: [freebsd]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/argon2-linux-arm-gnueabihf@1.7.0:
    resolution: {integrity: sha512-7DjDZ1h5AUHAtRNjD19RnQatbhL+uuxBASuuXIBu4/w6Dx8n7YPxwTP4MXfsvuRgKuMWiOb/Ub/HJ3kXVCXRkg==}
    engines: {node: '>= 10'}
    cpu: [arm]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/argon2-linux-arm64-gnu@1.7.0:
    resolution: {integrity: sha512-nJDoMP4Y3YcqGswE4DvP080w6O24RmnFEDnL0emdI8Nou17kNYBzP2546Nasx9GCyLzRcYQwZOUjrtUuQ+od2g==}
    engines: {node: '>= 10'}
    cpu: [arm64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/argon2-linux-arm64-musl@1.7.0:
    resolution: {integrity: sha512-BKWS8iVconhE3jrb9mj6t1J9vwUqQPpzCbUKxfTGJfc+kNL58F1SXHBoe2cDYGnHrFEHTY0YochzXoAfm4Dm/A==}
    engines: {node: '>= 10'}
    cpu: [arm64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/argon2-linux-x64-gnu@1.7.0:
    resolution: {integrity: sha512-EmgqZOlf4Jurk/szW1iTsVISx25bKksVC5uttJDUloTgsAgIGReCpUUO1R24pBhu9ESJa47iv8NSf3yAfGv6jQ==}
    engines: {node: '>= 10'}
    cpu: [x64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/argon2-linux-x64-musl@1.7.0:
    resolution: {integrity: sha512-/o1efYCYIxjfuoRYyBTi2Iy+1iFfhqHCvvVsnjNSgO1xWiWrX0Rrt/xXW5Zsl7vS2Y+yu8PL8KFWRzZhaVxfKA==}
    engines: {node: '>= 10'}
    cpu: [x64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/argon2-wasm32-wasi@1.7.0:
    resolution: {integrity: sha512-Evmk9VcxqnuwQftfAfYEr6YZYSPLzmKUsbFIMep5nTt9PT4XYRFAERj7wNYp+rOcBenF3X4xoB+LhwcOMTNE5w==}
    engines: {node: '>=14.0.0'}
    cpu: [wasm32]
    requiresBuild: true
    dependencies:
      '@emnapi/core': 0.45.0
      '@emnapi/runtime': 0.45.0
      '@tybys/wasm-util': 0.8.3
      memfs-browser: 3.5.10302
    dev: false
    optional: true

  /@node-rs/argon2-win32-arm64-msvc@1.7.0:
    resolution: {integrity: sha512-qgsU7T004COWWpSA0tppDqDxbPLgg8FaU09krIJ7FBl71Sz8SFO40h7fDIjfbTT5w7u6mcaINMQ5bSHu75PCaA==}
    engines: {node: '>= 10'}
    cpu: [arm64]
    os: [win32]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/argon2-win32-ia32-msvc@1.7.0:
    resolution: {integrity: sha512-JGafwWYQ/HpZ3XSwP4adQ6W41pRvhcdXvpzIWtKvX+17+xEXAe2nmGWM6s27pVkg1iV2ZtoYLRDkOUoGqZkCcg==}
    engines: {node: '>= 10'}
    cpu: [ia32]
    os: [win32]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/argon2-win32-x64-msvc@1.7.0:
    resolution: {integrity: sha512-9oq4ShyFakw8AG3mRls0AoCpxBFcimYx7+jvXeAf2OqKNO+mSA6eZ9z7KQeVCi0+SOEUYxMGf5UiGiDb9R6+9Q==}
    engines: {node: '>= 10'}
    cpu: [x64]
    os: [win32]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/argon2@1.7.0:
    resolution: {integrity: sha512-zfULc+/tmcWcxn+nHkbyY8vP3+MpEqKORbszt4UkpqZgBgDAAIYvuDN/zukfTgdmo6tmJKKVfzigZOPk4LlIog==}
    engines: {node: '>= 10'}
    optionalDependencies:
      '@node-rs/argon2-android-arm-eabi': 1.7.0
      '@node-rs/argon2-android-arm64': 1.7.0
      '@node-rs/argon2-darwin-arm64': 1.7.0
      '@node-rs/argon2-darwin-x64': 1.7.0
      '@node-rs/argon2-freebsd-x64': 1.7.0
      '@node-rs/argon2-linux-arm-gnueabihf': 1.7.0
      '@node-rs/argon2-linux-arm64-gnu': 1.7.0
      '@node-rs/argon2-linux-arm64-musl': 1.7.0
      '@node-rs/argon2-linux-x64-gnu': 1.7.0
      '@node-rs/argon2-linux-x64-musl': 1.7.0
      '@node-rs/argon2-wasm32-wasi': 1.7.0
      '@node-rs/argon2-win32-arm64-msvc': 1.7.0
      '@node-rs/argon2-win32-ia32-msvc': 1.7.0
      '@node-rs/argon2-win32-x64-msvc': 1.7.0
    dev: false

  /@node-rs/bcrypt-android-arm-eabi@1.9.0:
    resolution: {integrity: sha512-nOCFISGtnodGHNiLrG0WYLWr81qQzZKYfmwHc7muUeq+KY0sQXyHOwZk9OuNQAWv/lnntmtbwkwT0QNEmOyLvA==}
    engines: {node: '>= 10'}
    cpu: [arm]
    os: [android]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/bcrypt-android-arm64@1.9.0:
    resolution: {integrity: sha512-+ZrIAtigVmjYkqZQTThHVlz0+TG6D+GDHWhVKvR2DifjtqJ0i+mb9gjo++hN+fWEQdWNGxKCiBBjwgT4EcXd6A==}
    engines: {node: '>= 10'}
    cpu: [arm64]
    os: [android]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/bcrypt-darwin-arm64@1.9.0:
    resolution: {integrity: sha512-CQiS+F9Pa0XozvkXR1g7uXE9QvBOPOplDg0iCCPRYTN9PqA5qYxhwe48G3o+v2UeQceNRrbnEtWuANm7JRqIhw==}
    engines: {node: '>= 10'}
    cpu: [arm64]
    os: [darwin]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/bcrypt-darwin-x64@1.9.0:
    resolution: {integrity: sha512-4pTKGawYd7sNEjdJ7R/R67uwQH1VvwPZ0SSUMmeNHbxD5QlwAPXdDH11q22uzVXsvNFZ6nGQBg8No5OUGpx6Ug==}
    engines: {node: '>= 10'}
    cpu: [x64]
    os: [darwin]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/bcrypt-freebsd-x64@1.9.0:
    resolution: {integrity: sha512-UmWzySX4BJhT/B8xmTru6iFif3h0Rpx3TqxRLCcbgmH43r7k5/9QuhpiyzpvKGpKHJCFNm4F3rC2wghvw5FCIg==}
    engines: {node: '>= 10'}
    cpu: [x64]
    os: [freebsd]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/bcrypt-linux-arm-gnueabihf@1.9.0:
    resolution: {integrity: sha512-8qoX4PgBND2cVwsbajoAWo3NwdfJPEXgpCsZQZURz42oMjbGyhhSYbovBCskGU3EBLoC8RA2B1jFWooeYVn5BA==}
    engines: {node: '>= 10'}
    cpu: [arm]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/bcrypt-linux-arm64-gnu@1.9.0:
    resolution: {integrity: sha512-TuAC6kx0SbcIA4mSEWPi+OCcDjTQUMl213v5gMNlttF+D4ieIZx6pPDGTaMO6M2PDHTeCG0CBzZl0Lu+9b0c7Q==}
    engines: {node: '>= 10'}
    cpu: [arm64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/bcrypt-linux-arm64-musl@1.9.0:
    resolution: {integrity: sha512-/sIvKDABOI8QOEnLD7hIj02BVaNOuCIWBKvxcJOt8+TuwJ6zmY1UI5kSv9d99WbiHjTp97wtAUbZQwauU4b9ew==}
    engines: {node: '>= 10'}
    cpu: [arm64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/bcrypt-linux-x64-gnu@1.9.0:
    resolution: {integrity: sha512-DyyhDHDsLBsCKz1tZ1hLvUZSc1DK0FU0v52jK6IBQxrj24WscSU9zZe7ie/V9kdmA4Ep57BfpWX8Dsa2JxGdgQ==}
    engines: {node: '>= 10'}
    cpu: [x64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/bcrypt-linux-x64-musl@1.9.0:
    resolution: {integrity: sha512-duIiuqQ+Lew8ASSAYm6ZRqcmfBGWwsi81XLUwz86a2HR7Qv6V4yc3ZAUQovAikhjCsIqe8C11JlAZSK6+PlXYg==}
    engines: {node: '>= 10'}
    cpu: [x64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/bcrypt-wasm32-wasi@1.9.0:
    resolution: {integrity: sha512-ylaGmn9Wjwv/D5lxtawttx3H6Uu2WTTR7lWlRHGT6Ga/MB1Vj4OjSGUW8G8zIVnKuXpGbZ92pgHlt4HUpSLctw==}
    engines: {node: '>=14.0.0'}
    cpu: [wasm32]
    requiresBuild: true
    dependencies:
      '@emnapi/core': 0.45.0
      '@emnapi/runtime': 0.45.0
      '@tybys/wasm-util': 0.8.3
      memfs-browser: 3.5.10302
    dev: false
    optional: true

  /@node-rs/bcrypt-win32-arm64-msvc@1.9.0:
    resolution: {integrity: sha512-2h86gF7QFyEzODuDFml/Dp1MSJoZjxJ4yyT2Erf4NkwsiA5MqowUhUsorRwZhX6+2CtlGa7orbwi13AKMsYndw==}
    engines: {node: '>= 10'}
    cpu: [arm64]
    os: [win32]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/bcrypt-win32-ia32-msvc@1.9.0:
    resolution: {integrity: sha512-kqxalCvhs4FkN0+gWWfa4Bdy2NQAkfiqq/CEf6mNXC13RSV673Ev9V8sRlQyNpCHCNkeXfOT9pgoBdJmMs9muA==}
    engines: {node: '>= 10'}
    cpu: [ia32]
    os: [win32]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/bcrypt-win32-x64-msvc@1.9.0:
    resolution: {integrity: sha512-2y0Tuo6ZAT2Cz8V7DHulSlv1Bip3zbzeXyeur+uR25IRNYXKvI/P99Zl85Fbuu/zzYAZRLLlGTRe6/9IHofe/w==}
    engines: {node: '>= 10'}
    cpu: [x64]
    os: [win32]
    requiresBuild: true
    dev: false
    optional: true

  /@node-rs/bcrypt@1.9.0:
    resolution: {integrity: sha512-u2OlIxW264bFUfvbFqDz9HZKFjwe8FHFtn7T/U8mYjPZ7DWYpbUB+/dkW/QgYfMSfR0ejkyuWaBBe0coW7/7ig==}
    engines: {node: '>= 10'}
    optionalDependencies:
      '@node-rs/bcrypt-android-arm-eabi': 1.9.0
      '@node-rs/bcrypt-android-arm64': 1.9.0
      '@node-rs/bcrypt-darwin-arm64': 1.9.0
      '@node-rs/bcrypt-darwin-x64': 1.9.0
      '@node-rs/bcrypt-freebsd-x64': 1.9.0
      '@node-rs/bcrypt-linux-arm-gnueabihf': 1.9.0
      '@node-rs/bcrypt-linux-arm64-gnu': 1.9.0
      '@node-rs/bcrypt-linux-arm64-musl': 1.9.0
      '@node-rs/bcrypt-linux-x64-gnu': 1.9.0
      '@node-rs/bcrypt-linux-x64-musl': 1.9.0
      '@node-rs/bcrypt-wasm32-wasi': 1.9.0
      '@node-rs/bcrypt-win32-arm64-msvc': 1.9.0
      '@node-rs/bcrypt-win32-ia32-msvc': 1.9.0
      '@node-rs/bcrypt-win32-x64-msvc': 1.9.0
    dev: false

  /@nodelib/fs.scandir@2.1.5:
    resolution: {integrity: sha512-vq24Bq3ym5HEQm2NKCr3yXDwjc7vTsEThRDnkp2DK9p1uqLR+DHurm/NOTo0KG7HYHU7eppKZj3MyqYuMBf62g==}
    engines: {node: '>= 8'}
    dependencies:
      '@nodelib/fs.stat': 2.0.5
      run-parallel: 1.2.0
    dev: false

  /@nodelib/fs.stat@2.0.5:
    resolution: {integrity: sha512-RkhPPp2zrqDAQA/2jNhnztcPAlv64XdhIp7a7454A5ovI7Bukxgt7MX7udwAu3zg1DcpPU0rz3VV1SeaqvY4+A==}
    engines: {node: '>= 8'}
    dev: false

  /@nodelib/fs.walk@1.2.8:
    resolution: {integrity: sha512-oGB+UxlgWcgQkgwo8GcEGwemoTFt3FIO9ababBmaGwXIoBKZ+GTy0pP185beGg7Llih/NSHSV2XAs1lnznocSg==}
    engines: {node: '>= 8'}
    dependencies:
      '@nodelib/fs.scandir': 2.1.5
      fastq: 1.17.1
    dev: false

  /@oslojs/asn1@0.2.2:
    resolution: {integrity: sha512-/c7DTaOdmk3Xb482b4CFnPdWLo5e2WQuozhc89KVb91kohA+VvVNTd9IPyLsZpDUf9u3iwP4HcuMEXBcYmGFnQ==}
    dependencies:
      '@oslojs/binary': 0.2.3
    dev: false

  /@oslojs/binary@0.2.3:
    resolution: {integrity: sha512-pBJvvl5wpBBmkbP8cMZvPXzxPd7WN+NDBHPEg2N6WTDSnYCCPmqghIz6W+Cw16hhAju9wgmOeHryjHFbNezr1w==}
    dev: false

  /@oslojs/crypto@0.6.0:
    resolution: {integrity: sha512-MAwQt2BwW/oLvYaX1SuVHBqBXV+3CsF7ied23LDqeVeesFTPxLLIqW6pbQ6SMUPnGEJXQx4OTfm2BYSLLvp5Hg==}
    dependencies:
      '@oslojs/asn1': 0.2.2
      '@oslojs/binary': 0.2.3
    dev: false

  /@oslojs/encoding@0.4.1:
    resolution: {integrity: sha512-hkjo6MuIK/kQR5CrGNdAPZhS01ZCXuWDRJ187zh6qqF2+yMHZpD9fAYpX8q2bOO6Ryhl3XpCT6kUX76N8hhm4Q==}
    dev: false

  /@oslojs/encoding@1.0.0:
    resolution: {integrity: sha512-dyIB0SdZgMm5BhGwdSp8rMxEFIopLKxDG1vxIBaiogyom6ZqH2aXPb6DEC2WzOOWKdPSq1cxdNeRx2wAn1Z+ZQ==}
    dev: false

  /@oslojs/jwt@0.1.0:
    resolution: {integrity: sha512-g6JHWeCl9OkHLeoaaKUZoQUfCzhn2U5hYnyoT7/Uh/HY0AGpf0odmFViW6AhPKaOOVXKITvoOArEhec1vEd6GA==}
    dependencies:
      '@oslojs/encoding': 0.4.1
    dev: false

  /@paralleldrive/cuid2@2.2.2:
    resolution: {integrity: sha512-ZOBkgDwEdoYVlSeRbYYXs0S9MejQofiVYoTbKzy/6GQa39/q5tQU2IX46+shYnUkpEl3wc+J6wRlar7r2EK2xA==}
    dependencies:
      '@noble/hashes': 1.5.0
    dev: false

  /@peculiar/asn1-android@2.3.13:
    resolution: {integrity: sha512-0VTNazDGKrLS6a3BwTDZanqq6DR/I3SbvmDMuS8Be+OYpvM6x1SRDh9AGDsHVnaCOIztOspCPc6N1m+iUv1Xxw==}
    dependencies:
      '@peculiar/asn1-schema': 2.3.13
      asn1js: 3.0.5
      tslib: 2.7.0
    dev: false

  /@peculiar/asn1-ecc@2.3.14:
    resolution: {integrity: sha512-zWPyI7QZto6rnLv6zPniTqbGaLh6zBpJyI46r1yS/bVHJXT2amdMHCRRnbV5yst2H8+ppXG6uXu/M6lKakiQ8w==}
    dependencies:
      '@peculiar/asn1-schema': 2.3.13
      '@peculiar/asn1-x509': 2.3.13
      asn1js: 3.0.5
      tslib: 2.7.0
    dev: false

  /@peculiar/asn1-rsa@2.3.13:
    resolution: {integrity: sha512-wBNQqCyRtmqvXkGkL4DR3WxZhHy8fDiYtOjTeCd7SFE5F6GBeafw3EJ94PX/V0OJJrjQ40SkRY2IZu3ZSyBqcg==}
    dependencies:
      '@peculiar/asn1-schema': 2.3.13
      '@peculiar/asn1-x509': 2.3.13
      asn1js: 3.0.5
      tslib: 2.7.0
    dev: false

  /@peculiar/asn1-schema@2.3.13:
    resolution: {integrity: sha512-3Xq3a01WkHRZL8X04Zsfg//mGaA21xlL4tlVn4v2xGT0JStiztATRkMwa5b+f/HXmY2smsiLXYK46Gwgzvfg3g==}
    dependencies:
      asn1js: 3.0.5
      pvtsutils: 1.3.5
      tslib: 2.7.0
    dev: false

  /@peculiar/asn1-x509@2.3.13:
    resolution: {integrity: sha512-PfeLQl2skXmxX2/AFFCVaWU8U6FKW1Db43mgBhShCOFS1bVxqtvusq1hVjfuEcuSQGedrLdCSvTgabluwN/M9A==}
    dependencies:
      '@peculiar/asn1-schema': 2.3.13
      asn1js: 3.0.5
      ipaddr.js: 2.2.0
      pvtsutils: 1.3.5
      tslib: 2.7.0
    dev: false

  /@pkgjs/parseargs@0.11.0:
    resolution: {integrity: sha512-+1VkjdD0QBLPodGrJUeqarH8VAIvQODIbwh9XpP5Syisf7YoQgsJKPNFoqqLQlu+VQ/tVSshMR6loPMn8U+dPg==}
    engines: {node: '>=14'}
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/pluginutils@5.1.1:
    resolution: {integrity: sha512-bVRmQqBIyGD+VMihdEV2IBurfIrdW9tD9yzJUL3CBRDbyPBVzQnBSMSgyUZHl1E335rpMRj7r4o683fXLYw8iw==}
    engines: {node: '>=14.0.0'}
    peerDependencies:
      rollup: ^1.20.0||^2.0.0||^3.0.0||^4.0.0
    peerDependenciesMeta:
      rollup:
        optional: true
    dependencies:
      '@types/estree': 1.0.6
      estree-walker: 2.0.2
      picomatch: 2.3.1
    dev: false

  /@rollup/rollup-android-arm-eabi@4.22.4:
    resolution: {integrity: sha512-Fxamp4aEZnfPOcGA8KSNEohV8hX7zVHOemC8jVBoBUHu5zpJK/Eu3uJwt6BMgy9fkvzxDaurgj96F/NiLukF2w==}
    cpu: [arm]
    os: [android]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-android-arm64@4.22.4:
    resolution: {integrity: sha512-VXoK5UMrgECLYaMuGuVTOx5kcuap1Jm8g/M83RnCHBKOqvPPmROFJGQaZhGccnsFtfXQ3XYa4/jMCJvZnbJBdA==}
    cpu: [arm64]
    os: [android]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-darwin-arm64@4.22.4:
    resolution: {integrity: sha512-xMM9ORBqu81jyMKCDP+SZDhnX2QEVQzTcC6G18KlTQEzWK8r/oNZtKuZaCcHhnsa6fEeOBionoyl5JsAbE/36Q==}
    cpu: [arm64]
    os: [darwin]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-darwin-x64@4.22.4:
    resolution: {integrity: sha512-aJJyYKQwbHuhTUrjWjxEvGnNNBCnmpHDvrb8JFDbeSH3m2XdHcxDd3jthAzvmoI8w/kSjd2y0udT+4okADsZIw==}
    cpu: [x64]
    os: [darwin]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-linux-arm-gnueabihf@4.22.4:
    resolution: {integrity: sha512-j63YtCIRAzbO+gC2L9dWXRh5BFetsv0j0va0Wi9epXDgU/XUi5dJKo4USTttVyK7fGw2nPWK0PbAvyliz50SCQ==}
    cpu: [arm]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-linux-arm-musleabihf@4.22.4:
    resolution: {integrity: sha512-dJnWUgwWBX1YBRsuKKMOlXCzh2Wu1mlHzv20TpqEsfdZLb3WoJW2kIEsGwLkroYf24IrPAvOT/ZQ2OYMV6vlrg==}
    cpu: [arm]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-linux-arm64-gnu@4.22.4:
    resolution: {integrity: sha512-AdPRoNi3NKVLolCN/Sp4F4N1d98c4SBnHMKoLuiG6RXgoZ4sllseuGioszumnPGmPM2O7qaAX/IJdeDU8f26Aw==}
    cpu: [arm64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-linux-arm64-musl@4.22.4:
    resolution: {integrity: sha512-Gl0AxBtDg8uoAn5CCqQDMqAx22Wx22pjDOjBdmG0VIWX3qUBHzYmOKh8KXHL4UpogfJ14G4wk16EQogF+v8hmA==}
    cpu: [arm64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-linux-powerpc64le-gnu@4.22.4:
    resolution: {integrity: sha512-3aVCK9xfWW1oGQpTsYJJPF6bfpWfhbRnhdlyhak2ZiyFLDaayz0EP5j9V1RVLAAxlmWKTDfS9wyRyY3hvhPoOg==}
    cpu: [ppc64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-linux-riscv64-gnu@4.22.4:
    resolution: {integrity: sha512-ePYIir6VYnhgv2C5Xe9u+ico4t8sZWXschR6fMgoPUK31yQu7hTEJb7bCqivHECwIClJfKgE7zYsh1qTP3WHUA==}
    cpu: [riscv64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-linux-s390x-gnu@4.22.4:
    resolution: {integrity: sha512-GqFJ9wLlbB9daxhVlrTe61vJtEY99/xB3C8e4ULVsVfflcpmR6c8UZXjtkMA6FhNONhj2eA5Tk9uAVw5orEs4Q==}
    cpu: [s390x]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-linux-x64-gnu@4.22.4:
    resolution: {integrity: sha512-87v0ol2sH9GE3cLQLNEy0K/R0pz1nvg76o8M5nhMR0+Q+BBGLnb35P0fVz4CQxHYXaAOhE8HhlkaZfsdUOlHwg==}
    cpu: [x64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-linux-x64-musl@4.22.4:
    resolution: {integrity: sha512-UV6FZMUgePDZrFjrNGIWzDo/vABebuXBhJEqrHxrGiU6HikPy0Z3LfdtciIttEUQfuDdCn8fqh7wiFJjCNwO+g==}
    cpu: [x64]
    os: [linux]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-win32-arm64-msvc@4.22.4:
    resolution: {integrity: sha512-BjI+NVVEGAXjGWYHz/vv0pBqfGoUH0IGZ0cICTn7kB9PyjrATSkX+8WkguNjWoj2qSr1im/+tTGRaY+4/PdcQw==}
    cpu: [arm64]
    os: [win32]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-win32-ia32-msvc@4.22.4:
    resolution: {integrity: sha512-SiWG/1TuUdPvYmzmYnmd3IEifzR61Tragkbx9D3+R8mzQqDBz8v+BvZNDlkiTtI9T15KYZhP0ehn3Dld4n9J5g==}
    cpu: [ia32]
    os: [win32]
    requiresBuild: true
    dev: false
    optional: true

  /@rollup/rollup-win32-x64-msvc@4.22.4:
    resolution: {integrity: sha512-j8pPKp53/lq9lMXN57S8cFz0MynJk8OWNuUnXct/9KCpKU7DgU3bYMJhwWmcqC0UU29p8Lr0/7KEVcaM6bf47Q==}
    cpu: [x64]
    os: [win32]
    requiresBuild: true
    dev: false
    optional: true

  /@shikijs/core@1.18.0:
    resolution: {integrity: sha512-VK4BNVCd2leY62Nm2JjyxtRLkyrZT/tv104O81eyaCjHq4Adceq2uJVFJJAIof6lT1mBwZrEo2qT/T+grv3MQQ==}
    dependencies:
      '@shikijs/engine-javascript': 1.18.0
      '@shikijs/engine-oniguruma': 1.18.0
      '@shikijs/types': 1.18.0
      '@shikijs/vscode-textmate': 9.2.2
      '@types/hast': 3.0.4
      hast-util-to-html: 9.0.3
    dev: false

  /@shikijs/engine-javascript@1.18.0:
    resolution: {integrity: sha512-qoP/aO/ATNwYAUw1YMdaip/YVEstMZEgrwhePm83Ll9OeQPuxDZd48szZR8oSQNQBT8m8UlWxZv8EA3lFuyI5A==}
    dependencies:
      '@shikijs/types': 1.18.0
      '@shikijs/vscode-textmate': 9.2.2
      oniguruma-to-js: 0.4.3
    dev: false

  /@shikijs/engine-oniguruma@1.18.0:
    resolution: {integrity: sha512-B9u0ZKI/cud+TcmF8Chyh+R4V5qQVvyDOqXC2l2a4x73PBSBc6sZ0JRAX3eqyJswqir6ktwApUUGBYePdKnMJg==}
    dependencies:
      '@shikijs/types': 1.18.0
      '@shikijs/vscode-textmate': 9.2.2
    dev: false

  /@shikijs/types@1.18.0:
    resolution: {integrity: sha512-O9N36UEaGGrxv1yUrN2nye7gDLG5Uq0/c1LyfmxsvzNPqlHzWo9DI0A4+fhW2y3bGKuQu/fwS7EPdKJJCowcVA==}
    dependencies:
      '@shikijs/vscode-textmate': 9.2.2
      '@types/hast': 3.0.4
    dev: false

  /@shikijs/vscode-textmate@9.2.2:
    resolution: {integrity: sha512-TMp15K+GGYrWlZM8+Lnj9EaHEFmOen0WJBrfa17hF7taDOYthuPPV0GWzfd/9iMij0akS/8Yw2ikquH7uVi/fg==}
    dev: false

  /@simplewebauthn/browser@10.0.0:
    resolution: {integrity: sha512-hG0JMZD+LiLUbpQcAjS4d+t4gbprE/dLYop/CkE01ugU/9sKXflxV5s0DRjdz3uNMFecatRfb4ZLG3XvF8m5zg==}
    dependencies:
      '@simplewebauthn/types': 10.0.0
    dev: false

  /@simplewebauthn/server@10.0.1:
    resolution: {integrity: sha512-djNWcRn+H+6zvihBFJSpG3fzb0NQS9c/Mw5dYOtZ9H+oDw8qn9Htqxt4cpqRvSOAfwqP7rOvE9rwqVaoGGc3hg==}
    engines: {node: '>=20.0.0'}
    dependencies:
      '@hexagon/base64': 1.1.28
      '@levischuck/tiny-cbor': 0.2.2
      '@peculiar/asn1-android': 2.3.13
      '@peculiar/asn1-ecc': 2.3.14
      '@peculiar/asn1-rsa': 2.3.13
      '@peculiar/asn1-schema': 2.3.13
      '@peculiar/asn1-x509': 2.3.13
      '@simplewebauthn/types': 10.0.0
      cross-fetch: 4.0.0
    transitivePeerDependencies:
      - encoding
    dev: false

  /@simplewebauthn/types@10.0.0:
    resolution: {integrity: sha512-SFXke7xkgPRowY2E+8djKbdEznTVnD5R6GO7GPTthpHrokLvNKw8C3lFZypTxLI7KkCfGPfhtqB3d7OVGGa9jQ==}
    dev: false

  /@ts-morph/common@0.24.0:
    resolution: {integrity: sha512-c1xMmNHWpNselmpIqursHeOHHBTIsJLbB+NuovbTTRCNiTLEr/U9dbJ8qy0jd/O2x5pc3seWuOUN5R2IoOTp8A==}
    dependencies:
      fast-glob: 3.3.2
      minimatch: 9.0.5
      mkdirp: 3.0.1
      path-browserify: 1.0.1
    dev: false

  /@tybys/wasm-util@0.8.3:
    resolution: {integrity: sha512-Z96T/L6dUFFxgFJ+pQtkPpne9q7i6kIPYCFnQBHSgSPV9idTsKfIhCss0h5iM9irweZCatkrdeP8yi5uM1eX6Q==}
    requiresBuild: true
    dependencies:
      tslib: 2.7.0
    dev: false
    optional: true

  /@types/babel__core@7.20.5:
    resolution: {integrity: sha512-qoQprZvz5wQFJwMDqeseRXWv3rqMvhgpbXFfVyWhbx9X47POIA6i/+dXefEmZKoAgOaTdaIgNSMqMIU61yRyzA==}
    dependencies:
      '@babel/parser': 7.25.6
      '@babel/types': 7.25.6
      '@types/babel__generator': 7.6.8
      '@types/babel__template': 7.4.4
      '@types/babel__traverse': 7.20.6
    dev: false

  /@types/babel__generator@7.6.8:
    resolution: {integrity: sha512-ASsj+tpEDsEiFr1arWrlN6V3mdfjRMZt6LtK/Vp/kreFLnr5QH5+DhvD5nINYZXzwJvXeGq+05iUXcAzVrqWtw==}
    dependencies:
      '@babel/types': 7.25.6
    dev: false

  /@types/babel__template@7.4.4:
    resolution: {integrity: sha512-h/NUaSyG5EyxBIp8YRxo4RMe2/qQgvyowRwVMzhYhBCONbW8PUsg4lkFMrhgZhUe5z3L3MiLDuvyJ/CaPa2A8A==}
    dependencies:
      '@babel/parser': 7.25.6
      '@babel/types': 7.25.6
    dev: false

  /@types/babel__traverse@7.20.6:
    resolution: {integrity: sha512-r1bzfrm0tomOI8g1SzvCaQHo6Lcv6zu0EA+W2kHrt8dyrHQxGzBBL4kdkzIS+jBMV+EYcMAEAqXqYaLJq5rOZg==}
    dependencies:
      '@babel/types': 7.25.6
    dev: false

  /@types/cookie@0.6.0:
    resolution: {integrity: sha512-4Kh9a6B2bQciAhf7FSuMRRkUWecJgJu9nPnx3yzpsfXX/c50REIqpHY4C82bXP90qrLtXtkDxTZosYO3UpOwlA==}
    dev: false

  /@types/debug@4.1.12:
    resolution: {integrity: sha512-vIChWdVG3LG1SMxEvI/AK+FWJthlrqlTu7fbrlywTkkaONwk/UAGaULXRlf8vkzFBLVm0zkMdCquhL5aOjhXPQ==}
    dependencies:
      '@types/ms': 0.7.34
    dev: false

  /@types/estree@1.0.5:
    resolution: {integrity: sha512-/kYRxGDLWzHOB7q+wtSUQlFrtcdUccpfy+X+9iMBpHK8QLLhx2wIPYuS5DYtR9Wa/YlZAbIovy7qVdB1Aq6Lyw==}
    dev: false

  /@types/estree@1.0.6:
    resolution: {integrity: sha512-AYnb1nQyY49te+VRAVgmzfcgjYS91mY5P0TKUDCLEM+gNnA+3T6rWITXRLYCpahpqSQbN5cE+gHpnPyXjHWxcw==}
    dev: false

  /@types/hast@3.0.4:
    resolution: {integrity: sha512-WPs+bbQw5aCj+x6laNGWLH3wviHtoCv/P3+otBhbOhJgG8qtpdAMlTCxLtsTWA7LH1Oh/bFCHsBn0TPS5m30EQ==}
    dependencies:
      '@types/unist': 3.0.3
    dev: false

  /@types/mdast@4.0.4:
    resolution: {integrity: sha512-kGaNbPh1k7AFzgpud/gMdvIm5xuECykRR+JnWKQno9TAXVa6WIVCGTPvYGekIDL4uwCZQSYbUxNBSb1aUo79oA==}
    dependencies:
      '@types/unist': 3.0.3
    dev: false

  /@types/ms@0.7.34:
    resolution: {integrity: sha512-nG96G3Wp6acyAgJqGasjODb+acrI7KltPiRxzHPXnP3NgI28bpQDRv53olbqGXbfcgF5aiiHmO3xpwEpS5Ld9g==}
    dev: false

  /@types/nlcst@2.0.3:
    resolution: {integrity: sha512-vSYNSDe6Ix3q+6Z7ri9lyWqgGhJTmzRjZRqyq15N0Z/1/UnVsno9G/N40NBijoYx2seFDIl0+B2mgAb9mezUCA==}
    dependencies:
      '@types/unist': 3.0.3
    dev: false

  /@types/node@22.6.0:
    resolution: {integrity: sha512-QyR8d5bmq+eR72TwQDfujwShHMcIrWIYsaQFtXRE58MHPTEKUNxjxvl0yS0qPMds5xbSDWtp7ZpvGFtd7dfMdQ==}
    dependencies:
      undici-types: 6.19.8
    dev: false

  /@types/set-cookie-parser@2.4.10:
    resolution: {integrity: sha512-GGmQVGpQWUe5qglJozEjZV/5dyxbOOZ0LHe/lqyWssB88Y4svNfst0uqBVscdDeIKl5Jy5+aPSvy7mI9tYRguw==}
    dependencies:
      '@types/node': 22.6.0
    dev: false

  /@types/unist@3.0.3:
    resolution: {integrity: sha512-ko/gIFJRv177XgZsZcBwnqJN5x/Gien8qNOn0D5bQU/zAzVf9Zt3BlcUiLqhV9y4ARk0GbT3tnUiPNgnTXzc/Q==}
    dev: false

  /@ungap/structured-clone@1.2.0:
    resolution: {integrity: sha512-zuVdFrMJiuCDQUMCzQaD6KL28MjnqqN8XnAqiEq9PNm/hCPTSGfrXCOfwj1ow4LFb/tNymJPwsNbVePc1xFqrQ==}
    dev: false

  /@volar/kit@2.4.5(typescript@5.6.2):
    resolution: {integrity: sha512-ZzyErW5UiDfiIuJ/lpqc2Kx5PHDGDZ/bPlPJYpRcxlrn8Z8aDhRlsLHkNKcNiH65TmNahk2kbLaiejiqu6BD3A==}
    peerDependencies:
      typescript: '*'
    dependencies:
      '@volar/language-service': 2.4.5
      '@volar/typescript': 2.4.5
      typesafe-path: 0.2.2
      typescript: 5.6.2
      vscode-languageserver-textdocument: 1.0.12
      vscode-uri: 3.0.8
    dev: false

  /@volar/language-core@2.4.5:
    resolution: {integrity: sha512-F4tA0DCO5Q1F5mScHmca0umsi2ufKULAnMOVBfMsZdT4myhVl4WdKRwCaKcfOkIEuyrAVvtq1ESBdZ+rSyLVww==}
    dependencies:
      '@volar/source-map': 2.4.5
    dev: false

  /@volar/language-server@2.4.5:
    resolution: {integrity: sha512-l5PswE0JzCtstTlwBUpikeSa3lNUBJhTuWtj9KclZTGi2Uex4RcqGOhTiDsUUtvdv/hEuYCxGq1EdJJPlQsD/g==}
    dependencies:
      '@volar/language-core': 2.4.5
      '@volar/language-service': 2.4.5
      '@volar/typescript': 2.4.5
      path-browserify: 1.0.1
      request-light: 0.7.0
      vscode-languageserver: 9.0.1
      vscode-languageserver-protocol: 3.17.5
      vscode-languageserver-textdocument: 1.0.12
      vscode-uri: 3.0.8
    dev: false

  /@volar/language-service@2.4.5:
    resolution: {integrity: sha512-xiFlL0aViGg6JhwAXyohPrdlID13uom8WQg6DWYaV8ob8RRy+zoLlBUI8SpQctwlWEO9poyrYK01revijAwkcw==}
    dependencies:
      '@volar/language-core': 2.4.5
      vscode-languageserver-protocol: 3.17.5
      vscode-languageserver-textdocument: 1.0.12
      vscode-uri: 3.0.8
    dev: false

  /@volar/source-map@2.4.5:
    resolution: {integrity: sha512-varwD7RaKE2J/Z+Zu6j3mNNJbNT394qIxXwdvz/4ao/vxOfyClZpSDtLKkwWmecinkOVos5+PWkWraelfMLfpw==}
    dev: false

  /@volar/typescript@2.4.5:
    resolution: {integrity: sha512-mcT1mHvLljAEtHviVcBuOyAwwMKz1ibXTi5uYtP/pf4XxoAzpdkQ+Br2IC0NPCvLCbjPZmbf3I0udndkfB1CDg==}
    dependencies:
      '@volar/language-core': 2.4.5
      path-browserify: 1.0.1
      vscode-uri: 3.0.8
    dev: false

  /@vscode/emmet-helper@2.9.3:
    resolution: {integrity: sha512-rB39LHWWPQYYlYfpv9qCoZOVioPCftKXXqrsyqN1mTWZM6dTnONT63Db+03vgrBbHzJN45IrgS/AGxw9iiqfEw==}
    dependencies:
      emmet: 2.4.11
      jsonc-parser: 2.3.1
      vscode-languageserver-textdocument: 1.0.12
      vscode-languageserver-types: 3.17.5
      vscode-uri: 2.1.2
    dev: false

  /@vscode/l10n@0.0.18:
    resolution: {integrity: sha512-KYSIHVmslkaCDyw013pphY+d7x1qV8IZupYfeIfzNA+nsaWHbn5uPuQRvdRFsa9zFzGeudPuoGoZ1Op4jrJXIQ==}
    dev: false

  /@vue/compiler-core@3.5.8:
    resolution: {integrity: sha512-Uzlxp91EPjfbpeO5KtC0KnXPkuTfGsNDeaKQJxQN718uz+RqDYarEf7UhQJGK+ZYloD2taUbHTI2J4WrUaZQNA==}
    dependencies:
      '@babel/parser': 7.25.6
      '@vue/shared': 3.5.8
      entities: 4.5.0
      estree-walker: 2.0.2
      source-map-js: 1.2.1
    dev: false

  /@vue/compiler-dom@3.5.8:
    resolution: {integrity: sha512-GUNHWvoDSbSa5ZSHT9SnV5WkStWfzJwwTd6NMGzilOE/HM5j+9EB9zGXdtu/fCNEmctBqMs6C9SvVPpVPuk1Eg==}
    dependencies:
      '@vue/compiler-core': 3.5.8
      '@vue/shared': 3.5.8
    dev: false

  /@vue/compiler-sfc@3.5.8:
    resolution: {integrity: sha512-taYpngQtSysrvO9GULaOSwcG5q821zCoIQBtQQSx7Uf7DxpR6CIHR90toPr9QfDD2mqHQPCSgoWBvJu0yV9zjg==}
    dependencies:
      '@babel/parser': 7.25.6
      '@vue/compiler-core': 3.5.8
      '@vue/compiler-dom': 3.5.8
      '@vue/compiler-ssr': 3.5.8
      '@vue/shared': 3.5.8
      estree-walker: 2.0.2
      magic-string: 0.30.11
      postcss: 8.4.47
      source-map-js: 1.2.1
    dev: false

  /@vue/compiler-ssr@3.5.8:
    resolution: {integrity: sha512-W96PtryNsNG9u0ZnN5Q5j27Z/feGrFV6zy9q5tzJVyJaLiwYxvC0ek4IXClZygyhjm+XKM7WD9pdKi/wIRVC/Q==}
    dependencies:
      '@vue/compiler-dom': 3.5.8
      '@vue/shared': 3.5.8
    dev: false

  /@vue/reactivity@3.5.8:
    resolution: {integrity: sha512-mlgUyFHLCUZcAYkqvzYnlBRCh0t5ZQfLYit7nukn1GR96gc48Bp4B7OIcSfVSvlG1k3BPfD+p22gi1t2n9tsXg==}
    dependencies:
      '@vue/shared': 3.5.8
    dev: false

  /@vue/runtime-core@3.5.8:
    resolution: {integrity: sha512-fJuPelh64agZ8vKkZgp5iCkPaEqFJsYzxLk9vSC0X3G8ppknclNDr61gDc45yBGTaN5Xqc1qZWU3/NoaBMHcjQ==}
    dependencies:
      '@vue/reactivity': 3.5.8
      '@vue/shared': 3.5.8
    dev: false

  /@vue/runtime-dom@3.5.8:
    resolution: {integrity: sha512-DpAUz+PKjTZPUOB6zJgkxVI3GuYc2iWZiNeeHQUw53kdrparSTG6HeXUrYDjaam8dVsCdvQxDz6ZWxnyjccUjQ==}
    dependencies:
      '@vue/reactivity': 3.5.8
      '@vue/runtime-core': 3.5.8
      '@vue/shared': 3.5.8
      csstype: 3.1.3
    dev: false

  /@vue/server-renderer@3.5.8(vue@3.5.8):
    resolution: {integrity: sha512-7AmC9/mEeV9mmXNVyUIm1a1AjUhyeeGNbkLh39J00E7iPeGks8OGRB5blJiMmvqSh8SkaS7jkLWSpXtxUCeagA==}
    peerDependencies:
      vue: 3.5.8
    dependencies:
      '@vue/compiler-ssr': 3.5.8
      '@vue/shared': 3.5.8
      vue: 3.5.8(typescript@5.6.2)
    dev: false

  /@vue/shared@3.5.8:
    resolution: {integrity: sha512-mJleSWbAGySd2RJdX1RBtcrUBX6snyOc0qHpgk3lGi4l9/P/3ny3ELqFWqYdkXIwwNN/kdm8nD9ky8o6l/Lx2A==}
    dev: false

  /acorn@8.12.1:
    resolution: {integrity: sha512-tcpGyI9zbizT9JbV6oYE477V6mTlXvvi0T0G3SNIYE2apm/G5huBa1+K89VGeovbg+jycCrfhl3ADxErOuO6Jg==}
    engines: {node: '>=0.4.0'}
    hasBin: true
    dev: false

  /ajv@8.17.1:
    resolution: {integrity: sha512-B/gBuNg5SiMTrPkC+A2+cW0RszwxYmn6VYxB/inlBStS5nx6xHIt/ehKRhIMhqusl7a8LjQoZnjCs5vhwxOQ1g==}
    dependencies:
      fast-deep-equal: 3.1.3
      fast-uri: 3.0.1
      json-schema-traverse: 1.0.0
      require-from-string: 2.0.2
    dev: false

  /ansi-align@3.0.1:
    resolution: {integrity: sha512-IOfwwBF5iczOjp/WeY4YxyjqAFMQoZufdQWDd19SEExbVLNXqvpzSJ/M7Za4/sCPmQ0+GRquoA7bGcINcxew6w==}
    dependencies:
      string-width: 4.2.3
    dev: false

  /ansi-regex@5.0.1:
    resolution: {integrity: sha512-quJQXlTSUGL2LH9SUXo8VwsY4soanhgo6LNSm84E1LBcE8s3O0wpdiRzyR9z/ZZJMlMWv37qOOb9pdJlMUEKFQ==}
    engines: {node: '>=8'}
    dev: false

  /ansi-regex@6.1.0:
    resolution: {integrity: sha512-7HSX4QQb4CspciLpVFwyRe79O3xsIZDDLER21kERQ71oaPodF8jL725AgJMFAYbooIqolJoRLuM81SpeUkpkvA==}
    engines: {node: '>=12'}
    dev: false

  /ansi-styles@3.2.1:
    resolution: {integrity: sha512-VT0ZI6kZRdTh8YyJw3SMbYm/u+NqfsAxEpWO0Pf9sq8/e94WxxOpPKx9FR1FlyCtOVDNOQ+8ntlqFxiRc+r5qA==}
    engines: {node: '>=4'}
    dependencies:
      color-convert: 1.9.3
    dev: false

  /ansi-styles@4.3.0:
    resolution: {integrity: sha512-zbB9rCJAT1rbjiVDb2hqKFHNYLxgtk8NURxZ3IZwD3F6NtxbXZQCnnSi1Lkx+IDohdPlFp222wVALIheZJQSEg==}
    engines: {node: '>=8'}
    dependencies:
      color-convert: 2.0.1
    dev: false

  /ansi-styles@6.2.1:
    resolution: {integrity: sha512-bN798gFfQX+viw3R7yrGWRqnrN2oRkEkUjjl4JNn4E8GxxbjtG3FbrEIIY3l8/hrwUwIeCZvi4QuOTP4MErVug==}
    engines: {node: '>=12'}
    dev: false

  /any-promise@1.3.0:
    resolution: {integrity: sha512-7UvmKalWRt1wgjL1RrGxoSJW/0QZFIegpeGvZG9kjp8vrRu55XTHbwnqq2GpXm9uLbcuhxm3IqX9OB4MZR1b2A==}
    dev: false

  /anymatch@3.1.3:
    resolution: {integrity: sha512-KMReFUr0B4t+D+OBkjR3KYqvocp2XaSzO55UcB6mgQMd3KbcE+mWTyvVV7D/zsdEbNnV6acZUutkiHQXvTr1Rw==}
    engines: {node: '>= 8'}
    dependencies:
      normalize-path: 3.0.0
      picomatch: 2.3.1
    dev: false

  /arctic@2.0.0-next.9:
    resolution: {integrity: sha512-VUi47ekY8oWEa+NE4AcEl5fwZF5lMn0/PCQUsPieLP8wFVXVFR+vxDKESkMQg+d8Ffd7LBLXWW/DTIgvD8zRtw==}
    dependencies:
      '@oslojs/crypto': 0.6.0
      '@oslojs/encoding': 0.4.1
      '@oslojs/jwt': 0.1.0
    dev: false

  /arg@5.0.2:
    resolution: {integrity: sha512-PYjyFOLKQ9y57JvQ6QLo8dAgNqswh8M1RMJYdQduT6xbWSgK36P/Z/v+p888pM69jMMfS8Xd8F6I1kQ/I9HUGg==}
    dev: false

  /argparse@1.0.10:
    resolution: {integrity: sha512-o5Roy6tNG4SL/FOkCAN6RzjiakZS25RLYFrcMttJqbdd8BWrnA+fGz57iN5Pb06pvBGvl5gQ0B48dJlslXvoTg==}
    dependencies:
      sprintf-js: 1.0.3
    dev: false

  /argparse@2.0.1:
    resolution: {integrity: sha512-8+9WqebbFzpX9OR+Wa6O29asIogeRMzcGtAINdpMHHyAg10f05aSFVBbcEqGf/PXw1EjAZ+q2/bEBg3DvurK3Q==}
    dev: false

  /aria-query@5.3.2:
    resolution: {integrity: sha512-COROpnaoap1E2F000S62r6A60uHZnmlvomhfyT2DlTcrY1OrBKn2UhH7qn5wTC9zMvD0AY7csdPSNwKP+7WiQw==}
    engines: {node: '>= 0.4'}
    dev: false

  /array-iterate@2.0.1:
    resolution: {integrity: sha512-I1jXZMjAgCMmxT4qxXfPXa6SthSoE8h6gkSI9BGGNv8mP8G/v0blc+qFnZu6K42vTOiuME596QaLO0TP3Lk0xg==}
    dev: false

  /asn1js@3.0.5:
    resolution: {integrity: sha512-FVnvrKJwpt9LP2lAMl8qZswRNm3T4q9CON+bxldk2iwk3FFpuwhx2FfinyitizWHsVYyaY+y5JzDR0rCMV5yTQ==}
    engines: {node: '>=12.0.0'}
    dependencies:
      pvtsutils: 1.3.5
      pvutils: 1.1.3
      tslib: 2.7.0
    dev: false

  /astro@4.15.9(typescript@5.6.2):
    resolution: {integrity: sha512-51oXq9qrZ5OPWYmEXt1kGrvWmVeWsx28SgBTzi2XW6iwcnW/wC5ONm6ol6qBGSCF93tQvZplXvuzpaw1injECA==}
    engines: {node: ^18.17.1 || ^20.3.0 || >=21.0.0, npm: '>=9.6.5', pnpm: '>=7.1.0'}
    hasBin: true
    dependencies:
      '@astrojs/compiler': 2.10.3
      '@astrojs/internal-helpers': 0.4.1
      '@astrojs/markdown-remark': 5.2.0
      '@astrojs/telemetry': 3.1.0
      '@babel/core': 7.25.2
      '@babel/plugin-transform-react-jsx': 7.25.2(@babel/core@7.25.2)
      '@babel/types': 7.25.6
      '@oslojs/encoding': 1.0.0
      '@rollup/pluginutils': 5.1.1
      '@types/babel__core': 7.20.5
      '@types/cookie': 0.6.0
      acorn: 8.12.1
      aria-query: 5.3.2
      axobject-query: 4.1.0
      boxen: 7.1.1
      ci-info: 4.0.0
      clsx: 2.1.1
      common-ancestor-path: 1.0.1
      cookie: 0.6.0
      cssesc: 3.0.0
      debug: 4.3.7
      deterministic-object-hash: 2.0.2
      devalue: 5.0.0
      diff: 5.2.0
      dlv: 1.1.3
      dset: 3.1.4
      es-module-lexer: 1.5.4
      esbuild: 0.21.5
      estree-walker: 3.0.3
      fast-glob: 3.3.2
      fastq: 1.17.1
      flattie: 1.1.1
      github-slugger: 2.0.0
      gray-matter: 4.0.3
      html-escaper: 3.0.3
      http-cache-semantics: 4.1.1
      js-yaml: 4.1.0
      kleur: 4.1.5
      magic-string: 0.30.11
      magicast: 0.3.5
      micromatch: 4.0.8
      mrmime: 2.0.0
      neotraverse: 0.6.18
      ora: 8.1.0
      p-limit: 6.1.0
      p-queue: 8.0.1
      preferred-pm: 4.0.0
      prompts: 2.4.2
      rehype: 13.0.1
      semver: 7.6.3
      shiki: 1.18.0
      string-width: 7.2.0
      strip-ansi: 7.1.0
      tinyexec: 0.3.0
      tsconfck: 3.1.3(typescript@5.6.2)
      unist-util-visit: 5.0.0
      vfile: 6.0.3
      vite: 5.4.7
      vitefu: 1.0.2(vite@5.4.7)
      which-pm: 3.0.0
      xxhash-wasm: 1.0.2
      yargs-parser: 21.1.1
      zod: 3.23.8
      zod-to-json-schema: 3.23.3(zod@3.23.8)
      zod-to-ts: 1.2.0(typescript@5.6.2)(zod@3.23.8)
    optionalDependencies:
      sharp: 0.33.5
    transitivePeerDependencies:
      - '@types/node'
      - less
      - lightningcss
      - rollup
      - sass
      - sass-embedded
      - stylus
      - sugarss
      - supports-color
      - terser
      - typescript
    dev: false

  /autoprefixer@10.4.20(postcss@8.4.47):
    resolution: {integrity: sha512-XY25y5xSv/wEoqzDyXXME4AFfkZI0P23z6Fs3YgymDnKJkCGOnkL0iTxCa85UTqaSgfcqyf3UA6+c7wUvx/16g==}
    engines: {node: ^10 || ^12 || >=14}
    hasBin: true
    peerDependencies:
      postcss: ^8.1.0
    dependencies:
      browserslist: 4.23.3
      caniuse-lite: 1.0.30001663
      fraction.js: 4.3.7
      normalize-range: 0.1.2
      picocolors: 1.1.0
      postcss: 8.4.47
      postcss-value-parser: 4.2.0
    dev: false

  /aws-ssl-profiles@1.1.2:
    resolution: {integrity: sha512-NZKeq9AfyQvEeNlN0zSYAaWrmBffJh3IELMZfRpJVWgrpEbtEpnjvzqBPf+mxoI287JohRDoa+/nsfqqiZmF6g==}
    engines: {node: '>= 6.0.0'}
    dev: false

  /axobject-query@4.1.0:
    resolution: {integrity: sha512-qIj0G9wZbMGNLjLmg1PT6v2mE9AH2zlnADJD/2tC6E00hgmhUOfEB6greHPAfLRSufHqROIUTkw6E+M3lH0PTQ==}
    engines: {node: '>= 0.4'}
    dev: false

  /bail@2.0.2:
    resolution: {integrity: sha512-0xO6mYd7JB2YesxDKplafRpsiOzPt9V02ddPCLbY1xYGPOX24NTyN50qnUxgCPcSoYMhKpAuBTjQoRZCAkUDRw==}
    dev: false

  /balanced-match@1.0.2:
    resolution: {integrity: sha512-3oSeUO0TMV67hN1AmbXsK4yaqU7tjiHlbxRDZOpH0KW9+CeX4bRAaX0Anxt0tx2MrpRpWwQaPwIlISEJhYU5Pw==}
    dev: false

  /base-64@1.0.0:
    resolution: {integrity: sha512-kwDPIFCGx0NZHog36dj+tHiwP4QMzsZ3AgMViUBKI0+V5n4U0ufTCUMhnQ04diaRI8EX/QcPfql7zlhZ7j4zgg==}
    dev: false

  /base64-js@1.5.1:
    resolution: {integrity: sha512-AKpaYlHn8t4SVbOHCy+b5+KKgvR4vrsD8vbvrbiQJps7fKDTkjkDry6ji0rUJjC0kzbNePLwzxq8iypo41qeWA==}
    dev: false

  /better-auth@0.0.10-beta.16(@babel/core@7.25.2)(react@18.3.1)(solid-js@1.8.23)(vue@3.5.8):
    resolution: {integrity: sha512-5m2gtkXTfYJuTSB0LG4Q9N+GKo42peg7JBaw2qx5zwBem0iOmRKFFznoEwJ1RuKRaDtDWuB+asWbVlNip3Fw/w==}
    hasBin: true
    dependencies:
      '@babel/preset-react': 7.24.7(@babel/core@7.25.2)
      '@babel/preset-typescript': 7.24.7(@babel/core@7.25.2)
      '@better-fetch/fetch': 1.1.9
      '@better-fetch/logger': 1.1.3
      '@nanostores/query': 0.3.4(nanostores@0.11.3)
      '@nanostores/react': 0.7.3(nanostores@0.11.3)(react@18.3.1)
      '@nanostores/solid': 0.4.2(nanostores@0.11.3)(solid-js@1.8.23)
      '@nanostores/vue': 0.10.0(nanostores@0.11.3)(vue@3.5.8)
      '@noble/ciphers': 0.6.0
      '@noble/hashes': 1.5.0
      '@oslojs/encoding': 1.0.0
      '@paralleldrive/cuid2': 2.2.2
      '@simplewebauthn/browser': 10.0.0
      '@simplewebauthn/server': 10.0.1
      arctic: 2.0.0-next.9
      better-call: 0.2.3-beta.8
      better-sqlite3: 11.3.0
      c12: 1.11.2
      chalk: 5.3.0
      commander: 12.1.0
      consola: 3.2.3
      defu: 6.1.4
      dotenv: 16.4.5
      jose: 5.9.3
      kysely: 0.27.4
      kysely-postgres-js: 2.0.0(kysely@0.27.4)(postgres@3.4.4)
      mysql2: 3.11.3
      nanoquery: 1.3.0
      nanostores: 0.11.3
      oauth4webapi: 2.17.0
      ora: 8.1.0
      oslo: 1.2.1
      pg: 8.13.0
      postgres: 3.4.4
      prompts: 2.4.2
      tiny-glob: 0.2.9
      ts-morph: 23.0.0
      zod: 3.23.8
    transitivePeerDependencies:
      - '@babel/core'
      - '@nanostores/logger'
      - '@vue/devtools-api'
      - encoding
      - magicast
      - pg-native
      - react
      - solid-js
      - supports-color
      - vue
    dev: false

  /better-call@0.2.3-beta.8:
    resolution: {integrity: sha512-cFD9x116voPbe9LSJFPIihY+2zDdhnEiVijQb8YWmXQXdC3PEZ7+lWyptJHBdtmLbao7xPt/JesH96/tm/o3wQ==}
    dependencies:
      '@better-fetch/fetch': 1.1.9
      '@types/set-cookie-parser': 2.4.10
      rou3: 0.5.1
      set-cookie-parser: 2.7.0
      typescript: 5.6.2
    dev: false

  /better-sqlite3@11.3.0:
    resolution: {integrity: sha512-iHt9j8NPYF3oKCNOO5ZI4JwThjt3Z6J6XrcwG85VNMVzv1ByqrHWv5VILEbCMFWDsoHhXvQ7oC8vgRXFAKgl9w==}
    requiresBuild: true
    dependencies:
      bindings: 1.5.0
      prebuild-install: 7.1.2
    dev: false

  /binary-extensions@2.3.0:
    resolution: {integrity: sha512-Ceh+7ox5qe7LJuLHoY0feh3pHuUDHAcRUeyL2VYghZwfpkNIy/+8Ocg0a3UuSoYzavmylwuLWQOf3hl0jjMMIw==}
    engines: {node: '>=8'}
    dev: false

  /bindings@1.5.0:
    resolution: {integrity: sha512-p2q/t/mhvuOj/UeLlV6566GD/guowlr0hHxClI0W9m7MWYkL1F0hLo+0Aexs9HSPCtR1SXQ0TD3MMKrXZajbiQ==}
    dependencies:
      file-uri-to-path: 1.0.0
    dev: false

  /bl@4.1.0:
    resolution: {integrity: sha512-1W07cM9gS6DcLperZfFSj+bWLtaPGSOHWhPiGzXmvVJbRLdG82sH/Kn8EtW1VqWVA54AKf2h5k5BbnIbwF3h6w==}
    dependencies:
      buffer: 5.7.1
      inherits: 2.0.4
      readable-stream: 3.6.2
    dev: false

  /boxen@7.1.1:
    resolution: {integrity: sha512-2hCgjEmP8YLWQ130n2FerGv7rYpfBmnmp9Uy2Le1vge6X3gZIfSmEzP5QTDElFxcvVcXlEn8Aq6MU/PZygIOog==}
    engines: {node: '>=14.16'}
    dependencies:
      ansi-align: 3.0.1
      camelcase: 7.0.1
      chalk: 5.3.0
      cli-boxes: 3.0.0
      string-width: 5.1.2
      type-fest: 2.19.0
      widest-line: 4.0.1
      wrap-ansi: 8.1.0
    dev: false

  /brace-expansion@2.0.1:
    resolution: {integrity: sha512-XnAIvQ8eM+kC6aULx6wuQiwVsnzsi9d3WxzV3FpWTGA19F621kwdbsAcFKXgKUHZWsy+mY6iL1sHTxWEFCytDA==}
    dependencies:
      balanced-match: 1.0.2
    dev: false

  /braces@3.0.3:
    resolution: {integrity: sha512-yQbXgO/OSZVD2IsiLlro+7Hf6Q18EJrKSEsdoMzKePKXct3gvD8oLcOQdIzGupr5Fj+EDe8gO/lxc1BzfMpxvA==}
    engines: {node: '>=8'}
    dependencies:
      fill-range: 7.1.1
    dev: false

  /browserslist@4.23.3:
    resolution: {integrity: sha512-btwCFJVjI4YWDNfau8RhZ+B1Q/VLoUITrm3RlP6y1tYGWIOa+InuYiRGXUBXo8nA1qKmHMyLB/iVQg5TT4eFoA==}
    engines: {node: ^6 || ^7 || ^8 || ^9 || ^10 || ^11 || ^12 || >=13.7}
    hasBin: true
    dependencies:
      caniuse-lite: 1.0.30001663
      electron-to-chromium: 1.5.27
      node-releases: 2.0.18
      update-browserslist-db: 1.1.0(browserslist@4.23.3)
    dev: false

  /buffer@5.7.1:
    resolution: {integrity: sha512-EHcyIPBQ4BSGlvjB16k5KgAJ27CIsHY/2JBmCRReo48y9rQ3MaUzWX3KVlBa4U7MyX02HdVj0K7C3WaB3ju7FQ==}
    dependencies:
      base64-js: 1.5.1
      ieee754: 1.2.1
    dev: false

  /c12@1.11.2:
    resolution: {integrity: sha512-oBs8a4uvSDO9dm8b7OCFW7+dgtVrwmwnrVXYzLm43ta7ep2jCn/0MhoUFygIWtxhyy6+/MG7/agvpY0U1Iemew==}
    peerDependencies:
      magicast: ^0.3.4
    peerDependenciesMeta:
      magicast:
        optional: true
    dependencies:
      chokidar: 3.6.0
      confbox: 0.1.7
      defu: 6.1.4
      dotenv: 16.4.5
      giget: 1.2.3
      jiti: 1.21.6
      mlly: 1.7.1
      ohash: 1.1.4
      pathe: 1.1.2
      perfect-debounce: 1.0.0
      pkg-types: 1.2.0
      rc9: 2.1.2
    dev: false

  /camelcase-css@2.0.1:
    resolution: {integrity: sha512-QOSvevhslijgYwRx6Rv7zKdMF8lbRmx+uQGx2+vDc+KI/eBnsy9kit5aj23AgGu3pa4t9AgwbnXWqS+iOY+2aA==}
    engines: {node: '>= 6'}
    dev: false

  /camelcase@7.0.1:
    resolution: {integrity: sha512-xlx1yCK2Oc1APsPXDL2LdlNP6+uu8OCDdhOBSVT279M/S+y75O30C2VuD8T2ogdePBBl7PfPF4504tnLgX3zfw==}
    engines: {node: '>=14.16'}
    dev: false

  /caniuse-lite@1.0.30001663:
    resolution: {integrity: sha512-o9C3X27GLKbLeTYZ6HBOLU1tsAcBZsLis28wrVzddShCS16RujjHp9GDHKZqrB3meE0YjhawvMFsGb/igqiPzA==}
    dev: false

  /ccount@2.0.1:
    resolution: {integrity: sha512-eyrF0jiFpY+3drT6383f1qhkbGsLSifNAjA61IUjZjmLCWjItY6LB9ft9YhoDgwfmclB2zhu51Lc7+95b8NRAg==}
    dev: false

  /chalk@2.4.2:
    resolution: {integrity: sha512-Mti+f9lpJNcwF4tWV8/OrTTtF1gZi+f8FqlyAdouralcFWFQWF2+NgCHShjkCb+IFBLq9buZwE1xckQU4peSuQ==}
    engines: {node: '>=4'}
    dependencies:
      ansi-styles: 3.2.1
      escape-string-regexp: 1.0.5
      supports-color: 5.5.0
    dev: false

  /chalk@5.3.0:
    resolution: {integrity: sha512-dLitG79d+GV1Nb/VYcCDFivJeK1hiukt9QjRNVOsUtTy1rR1YJsmpGGTZ3qJos+uw7WmWF4wUwBd9jxjocFC2w==}
    engines: {node: ^12.17.0 || ^14.13 || >=16.0.0}
    dev: false

  /character-entities-html4@2.1.0:
    resolution: {integrity: sha512-1v7fgQRj6hnSwFpq1Eu0ynr/CDEw0rXo2B61qXrLNdHZmPKgb7fqS1a2JwF0rISo9q77jDI8VMEHoApn8qDoZA==}
    dev: false

  /character-entities-legacy@3.0.0:
    resolution: {integrity: sha512-RpPp0asT/6ufRm//AJVwpViZbGM/MkjQFxJccQRHmISF/22NBtsHqAWmL+/pmkPWoIUJdWyeVleTl1wydHATVQ==}
    dev: false

  /character-entities@2.0.2:
    resolution: {integrity: sha512-shx7oQ0Awen/BRIdkjkvz54PnEEI/EjwXDSIZp86/KKdbafHh1Df/RYGBhn4hbe2+uKC9FnT5UCEdyPz3ai9hQ==}
    dev: false

  /chokidar@3.6.0:
    resolution: {integrity: sha512-7VT13fmjotKpGipCW9JEQAusEPE+Ei8nl6/g4FBAmIm0GOOLMua9NDDo/DWp0ZAxCr3cPq5ZpBqmPAQgDda2Pw==}
    engines: {node: '>= 8.10.0'}
    dependencies:
      anymatch: 3.1.3
      braces: 3.0.3
      glob-parent: 5.1.2
      is-binary-path: 2.1.0
      is-glob: 4.0.3
      normalize-path: 3.0.0
      readdirp: 3.6.0
    optionalDependencies:
      fsevents: 2.3.3
    dev: false

  /chownr@1.1.4:
    resolution: {integrity: sha512-jJ0bqzaylmJtVnNgzTeSOs8DPavpbYgEr/b0YL8/2GO3xJEhInFmhKMUnEJQjZumK7KXGFhUy89PrsJWlakBVg==}
    dev: false

  /chownr@2.0.0:
    resolution: {integrity: sha512-bIomtDF5KGpdogkLd9VspvFzk9KfpyyGlS8YFVZl7TGPBHL5snIOnxeshwVgPteQ9b4Eydl+pVbIyE1DcvCWgQ==}
    engines: {node: '>=10'}
    dev: false

  /ci-info@4.0.0:
    resolution: {integrity: sha512-TdHqgGf9odd8SXNuxtUBVx8Nv+qZOejE6qyqiy5NtbYYQOeFa6zmHkxlPzmaLxWWHsU6nJmB7AETdVPi+2NBUg==}
    engines: {node: '>=8'}
    dev: false

  /citty@0.1.6:
    resolution: {integrity: sha512-tskPPKEs8D2KPafUypv2gxwJP8h/OaJmC82QQGGDQcHvXX43xF2VDACcJVmZ0EuSxkpO9Kc4MlrA3q0+FG58AQ==}
    dependencies:
      consola: 3.2.3
    dev: false

  /cli-boxes@3.0.0:
    resolution: {integrity: sha512-/lzGpEWL/8PfI0BmBOPRwp0c/wFNX1RdUML3jK/RcSBA9T8mZDdQpqYBKtCFTOfQbwPqWEOpjqW+Fnayc0969g==}
    engines: {node: '>=10'}
    dev: false

  /cli-cursor@5.0.0:
    resolution: {integrity: sha512-aCj4O5wKyszjMmDT4tZj93kxyydN/K5zPWSCe6/0AV/AA1pqe5ZBIw0a2ZfPQV7lL5/yb5HsUreJ6UFAF1tEQw==}
    engines: {node: '>=18'}
    dependencies:
      restore-cursor: 5.1.0
    dev: false

  /cli-spinners@2.9.2:
    resolution: {integrity: sha512-ywqV+5MmyL4E7ybXgKys4DugZbX0FC6LnwrhjuykIjnK9k8OQacQ7axGKnjDXWNhns0xot3bZI5h55H8yo9cJg==}
    engines: {node: '>=6'}
    dev: false

  /cliui@8.0.1:
    resolution: {integrity: sha512-BSeNnyus75C4//NQ9gQt1/csTXyo/8Sb+afLAkzAptFuMsod9HFokGNudZpi/oQV73hnVK+sR+5PVRMd+Dr7YQ==}
    engines: {node: '>=12'}
    dependencies:
      string-width: 4.2.3
      strip-ansi: 6.0.1
      wrap-ansi: 7.0.0
    dev: false

  /clsx@2.1.1:
    resolution: {integrity: sha512-eYm0QWBtUrBWZWG0d386OGAw16Z995PiOVo2B7bjWSbHedGl5e0ZWaq65kOGgUSNesEIDkB9ISbTg/JK9dhCZA==}
    engines: {node: '>=6'}
    dev: false

  /code-block-writer@13.0.2:
    resolution: {integrity: sha512-XfXzAGiStXSmCIwrkdfvc7FS5Dtj8yelCtyOf2p2skCAfvLd6zu0rGzuS9NSCO3bq1JKpFZ7tbKdKlcd5occQA==}
    dev: false

  /color-convert@1.9.3:
    resolution: {integrity: sha512-QfAUtd+vFdAtFQcC8CCyYt1fYWxSqAiK2cSD6zDB8N3cpsEBAvRxp9zOGg6G/SHHJYAT88/az/IuDGALsNVbGg==}
    dependencies:
      color-name: 1.1.3
    dev: false

  /color-convert@2.0.1:
    resolution: {integrity: sha512-RRECPsj7iu/xb5oKYcsFHSppFNnsj/52OVTRKb4zP5onXwVF3zVmmToNcOfGC+CRDpfK/U584fMg38ZHCaElKQ==}
    engines: {node: '>=7.0.0'}
    dependencies:
      color-name: 1.1.4
    dev: false

  /color-name@1.1.3:
    resolution: {integrity: sha512-72fSenhMw2HZMTVHeCA9KCmpEIbzWiQsjN+BHcBbS9vr1mtt+vJjPdksIBNUmKAW8TFUDPJK5SUU3QhE9NEXDw==}
    dev: false

  /color-name@1.1.4:
    resolution: {integrity: sha512-dOy+3AuW3a2wNbZHIuMZpTcgjGuLU/uBL/ubcZF9OXbDo8ff4O8yVp5Bf0efS8uEoYo5q4Fx7dY9OgQGXgAsQA==}
    requiresBuild: true
    dev: false

  /color-string@1.9.1:
    resolution: {integrity: sha512-shrVawQFojnZv6xM40anx4CkoDP+fZsw/ZerEMsW/pyzsRbElpsL/DBVW7q3ExxwusdNXI3lXpuhEZkzs8p5Eg==}
    requiresBuild: true
    dependencies:
      color-name: 1.1.4
      simple-swizzle: 0.2.2
    dev: false
    optional: true

  /color@4.2.3:
    resolution: {integrity: sha512-1rXeuUUiGGrykh+CeBdu5Ie7OJwinCgQY0bc7GCRxy5xVHy+moaqkpL/jqQq0MtQOeYcrqEz4abc5f0KtU7W4A==}
    engines: {node: '>=12.5.0'}
    requiresBuild: true
    dependencies:
      color-convert: 2.0.1
      color-string: 1.9.1
    dev: false
    optional: true

  /comma-separated-tokens@2.0.3:
    resolution: {integrity: sha512-Fu4hJdvzeylCfQPp9SGWidpzrMs7tTrlu6Vb8XGaRGck8QSNZJJp538Wrb60Lax4fPwR64ViY468OIUTbRlGZg==}
    dev: false

  /commander@12.1.0:
    resolution: {integrity: sha512-Vw8qHK3bZM9y/P10u3Vib8o/DdkvA2OtPtZvD871QKjy74Wj1WSKFILMPRPSdUSx5RFK1arlJzEtA4PkFgnbuA==}
    engines: {node: '>=18'}
    dev: false

  /commander@4.1.1:
    resolution: {integrity: sha512-NOKm8xhkzAjzFx8B2v5OAHT+u5pRQc2UCa2Vq9jYL/31o2wi9mxBA7LIFs3sV5VSC49z6pEhfbMULvShKj26WA==}
    engines: {node: '>= 6'}
    dev: false

  /common-ancestor-path@1.0.1:
    resolution: {integrity: sha512-L3sHRo1pXXEqX8VU28kfgUY+YGsk09hPqZiZmLacNib6XNTCM8ubYeT7ryXQw8asB1sKgcU5lkB7ONug08aB8w==}
    dev: false

  /confbox@0.1.7:
    resolution: {integrity: sha512-uJcB/FKZtBMCJpK8MQji6bJHgu1tixKPxRLeGkNzBoOZzpnZUJm0jm2/sBDWcuBx1dYgxV4JU+g5hmNxCyAmdA==}
    dev: false

  /consola@3.2.3:
    resolution: {integrity: sha512-I5qxpzLv+sJhTVEoLYNcTW+bThDCPsit0vLNKShZx6rLtpilNpmmeTPaeqJb9ZE9dV3DGaeby6Vuhrw38WjeyQ==}
    engines: {node: ^14.18.0 || >=16.10.0}
    dev: false

  /convert-source-map@2.0.0:
    resolution: {integrity: sha512-Kvp459HrV2FEJ1CAsi1Ku+MY3kasH19TFykTz2xWmMeq6bk2NU3XXvfJ+Q61m0xktWwt+1HSYf3JZsTms3aRJg==}
    dev: false

  /cookie@0.6.0:
    resolution: {integrity: sha512-U71cyTamuh1CRNCfpGY6to28lxvNwPG4Guz/EVjgf3Jmzv0vlDp1atT9eS5dDjMYHucpHbWns6Lwf3BKz6svdw==}
    engines: {node: '>= 0.6'}
    dev: false

  /cross-fetch@4.0.0:
    resolution: {integrity: sha512-e4a5N8lVvuLgAWgnCrLr2PP0YyDOTHa9H/Rj54dirp61qXnNq46m82bRhNqIA5VccJtWBvPTFRV3TtvHUKPB1g==}
    dependencies:
      node-fetch: 2.7.0
    transitivePeerDependencies:
      - encoding
    dev: false

  /cross-spawn@7.0.3:
    resolution: {integrity: sha512-iRDPJKUPVEND7dHPO8rkbOnPpyDygcDFtWjpeWNCgy8WP2rXcxXL8TskReQl6OrB2G7+UJrags1q15Fudc7G6w==}
    engines: {node: '>= 8'}
    dependencies:
      path-key: 3.1.1
      shebang-command: 2.0.0
      which: 2.0.2
    dev: false

  /cssesc@3.0.0:
    resolution: {integrity: sha512-/Tb/JcjK111nNScGob5MNtsntNM1aCNUDipB/TkwZFhyDrrE47SOx/18wF2bbjgc3ZzCSKW1T5nt5EbFoAz/Vg==}
    engines: {node: '>=4'}
    hasBin: true
    dev: false

  /csstype@3.1.3:
    resolution: {integrity: sha512-M1uQkMl8rQK/szD0LNhtqxIPLpimGm8sOBwU7lLnCpSbTyY3yeU1Vc7l4KT5zT4s/yOxHH5O7tIuuLOCnLADRw==}
    dev: false

  /debug@4.3.7:
    resolution: {integrity: sha512-Er2nc/H7RrMXZBFCEim6TCmMk02Z8vLC2Rbi1KEBggpo0fS6l0S1nnapwmIi3yW/+GOJap1Krg4w0Hg80oCqgQ==}
    engines: {node: '>=6.0'}
    peerDependencies:
      supports-color: '*'
    peerDependenciesMeta:
      supports-color:
        optional: true
    dependencies:
      ms: 2.1.3
    dev: false

  /decode-named-character-reference@1.0.2:
    resolution: {integrity: sha512-O8x12RzrUF8xyVcY0KJowWsmaJxQbmy0/EtnNtHRpsOcT7dFk5W598coHqBVpmWo1oQQfsCqfCmkZN5DJrZVdg==}
    dependencies:
      character-entities: 2.0.2
    dev: false

  /decompress-response@6.0.0:
    resolution: {integrity: sha512-aW35yZM6Bb/4oJlZncMH2LCoZtJXTRxES17vE3hoRiowU2kWHaJKFkSBDnDR+cm9J+9QhXmREyIfv0pji9ejCQ==}
    engines: {node: '>=10'}
    dependencies:
      mimic-response: 3.1.0
    dev: false

  /deep-extend@0.6.0:
    resolution: {integrity: sha512-LOHxIOaPYdHlJRtCQfDIVZtfw/ufM8+rVj649RIHzcm/vGwQRXFt6OPqIFWsm2XEMrNIEtWR64sY1LEKD2vAOA==}
    engines: {node: '>=4.0.0'}
    dev: false

  /defu@6.1.4:
    resolution: {integrity: sha512-mEQCMmwJu317oSz8CwdIOdwf3xMif1ttiM8LTufzc3g6kR+9Pe236twL8j3IYT1F7GfRgGcW6MWxzZjLIkuHIg==}
    dev: false

  /denque@2.1.0:
    resolution: {integrity: sha512-HVQE3AAb/pxF8fQAoiqpvg9i3evqug3hoiwakOyZAwJm+6vZehbkYXZ0l4JxS+I3QxM97v5aaRNhj8v5oBhekw==}
    engines: {node: '>=0.10'}
    dev: false

  /dequal@2.0.3:
    resolution: {integrity: sha512-0je+qPKHEMohvfRTCEo3CrPG6cAzAYgmzKyxRiYSSDkS6eGJdyVJm7WaYA5ECaAD9wLB2T4EEeymA5aFVcYXCA==}
    engines: {node: '>=6'}
    dev: false

  /destr@2.0.3:
    resolution: {integrity: sha512-2N3BOUU4gYMpTP24s5rF5iP7BDr7uNTCs4ozw3kf/eKfvWSIu93GEBi5m427YoyJoeOzQ5smuu4nNAPGb8idSQ==}
    dev: false

  /detect-libc@2.0.3:
    resolution: {integrity: sha512-bwy0MGW55bG41VqxxypOsdSdGqLwXPI/focwgTYCFMbdUiBAxLg9CFzG08sz2aqzknwiX7Hkl0bQENjg8iLByw==}
    engines: {node: '>=8'}
    requiresBuild: true
    dev: false

  /deterministic-object-hash@2.0.2:
    resolution: {integrity: sha512-KxektNH63SrbfUyDiwXqRb1rLwKt33AmMv+5Nhsw1kqZ13SJBRTgZHtGbE+hH3a1mVW1cz+4pqSWVPAtLVXTzQ==}
    engines: {node: '>=18'}
    dependencies:
      base-64: 1.0.0
    dev: false

  /devalue@5.0.0:
    resolution: {integrity: sha512-gO+/OMXF7488D+u3ue+G7Y4AA3ZmUnB3eHJXmBTgNHvr4ZNzl36A0ZtG+XCRNYCkYx/bFmw4qtkoFLa+wSrwAA==}
    dev: false

  /devlop@1.1.0:
    resolution: {integrity: sha512-RWmIqhcFf1lRYBvNmr7qTNuyCt/7/ns2jbpp1+PalgE/rDQcBT0fioSMUpJ93irlUhC5hrg4cYqe6U+0ImW0rA==}
    dependencies:
      dequal: 2.0.3
    dev: false

  /didyoumean@1.2.2:
    resolution: {integrity: sha512-gxtyfqMg7GKyhQmb056K7M3xszy/myH8w+B4RT+QXBQsvAOdc3XymqDDPHx1BgPgsdAA5SIifona89YtRATDzw==}
    dev: false

  /diff@5.2.0:
    resolution: {integrity: sha512-uIFDxqpRZGZ6ThOk84hEfqWoHx2devRFvpTZcTHur85vImfaxUbTW9Ryh4CpCuDnToOP1CEtXKIgytHBPVff5A==}
    engines: {node: '>=0.3.1'}
    dev: false

  /dlv@1.1.3:
    resolution: {integrity: sha512-+HlytyjlPKnIG8XuRG8WvmBP8xs8P71y+SKKS6ZXWoEgLuePxtDoUEiH7WkdePWrQ5JBpE6aoVqfZfJUQkjXwA==}
    dev: false

  /dotenv@16.4.5:
    resolution: {integrity: sha512-ZmdL2rui+eB2YwhsWzjInR8LldtZHGDoQ1ugH85ppHKwpUHL7j7rN0Ti9NCnGiQbhaZ11FpR+7ao1dNsmduNUg==}
    engines: {node: '>=12'}
    dev: false

  /dset@3.1.4:
    resolution: {integrity: sha512-2QF/g9/zTaPDc3BjNcVTGoBbXBgYfMTTceLaYcFJ/W9kggFUkhxD/hMEeuLKbugyef9SqAx8cpgwlIP/jinUTA==}
    engines: {node: '>=4'}
    dev: false

  /eastasianwidth@0.2.0:
    resolution: {integrity: sha512-I88TYZWc9XiYHRQ4/3c5rjjfgkjhLyW2luGIheGERbNQ6OY7yTybanSpDXZa8y7VUP9YmDcYa+eyq4ca7iLqWA==}
    dev: false

  /electron-to-chromium@1.5.27:
    resolution: {integrity: sha512-o37j1vZqCoEgBuWWXLHQgTN/KDKe7zwpiY5CPeq2RvUqOyJw9xnrULzZAEVQ5p4h+zjMk7hgtOoPdnLxr7m/jw==}
    dev: false

  /emmet@2.4.11:
    resolution: {integrity: sha512-23QPJB3moh/U9sT4rQzGgeyyGIrcM+GH5uVYg2C6wZIxAIJq7Ng3QLT79tl8FUwDXhyq9SusfknOrofAKqvgyQ==}
    dependencies:
      '@emmetio/abbreviation': 2.3.3
      '@emmetio/css-abbreviation': 2.1.8
    dev: false

  /emoji-regex@10.4.0:
    resolution: {integrity: sha512-EC+0oUMY1Rqm4O6LLrgjtYDvcVYTy7chDnM4Q7030tP4Kwj3u/pR6gP9ygnp2CJMK5Gq+9Q2oqmrFJAz01DXjw==}
    dev: false

  /emoji-regex@8.0.0:
    resolution: {integrity: sha512-MSjYzcWNOA0ewAHpz0MxpYFvwg6yjy1NG3xteoqz644VCo/RPgnr1/GGt+ic3iJTzQ8Eu3TdM14SawnVUmGE6A==}
    dev: false

  /emoji-regex@9.2.2:
    resolution: {integrity: sha512-L18DaJsXSUk2+42pv8mLs5jJT2hqFkFE4j21wOmgbUqsZ2hL72NsUU785g9RXgo3s0ZNgVl42TiHp3ZtOv/Vyg==}
    dev: false

  /end-of-stream@1.4.4:
    resolution: {integrity: sha512-+uw1inIHVPQoaVuHzRyXd21icM+cnt4CzD5rW+NC1wjOUSTOs+Te7FOv7AhN7vS9x/oIyhLP5PR1H+phQAHu5Q==}
    dependencies:
      once: 1.4.0
    dev: false

  /entities@4.5.0:
    resolution: {integrity: sha512-V0hjH4dGPh9Ao5p0MoRY6BVqtwCjhz6vI5LT8AJ55H+4g9/4vbHx1I54fS0XuclLhDHArPQCiMjDxjaL8fPxhw==}
    engines: {node: '>=0.12'}
    dev: false

  /es-module-lexer@1.5.4:
    resolution: {integrity: sha512-MVNK56NiMrOwitFB7cqDwq0CQutbw+0BvLshJSse0MUNU+y1FC3bUS/AQg7oUng+/wKrrki7JfmwtVHkVfPLlw==}
    dev: false

  /esbuild@0.21.5:
    resolution: {integrity: sha512-mg3OPMV4hXywwpoDxu3Qda5xCKQi+vCTZq8S9J/EpkhB2HzKXq4SNFZE3+NK93JYxc8VMSep+lOUSC/RVKaBqw==}
    engines: {node: '>=12'}
    hasBin: true
    requiresBuild: true
    optionalDependencies:
      '@esbuild/aix-ppc64': 0.21.5
      '@esbuild/android-arm': 0.21.5
      '@esbuild/android-arm64': 0.21.5
      '@esbuild/android-x64': 0.21.5
      '@esbuild/darwin-arm64': 0.21.5
      '@esbuild/darwin-x64': 0.21.5
      '@esbuild/freebsd-arm64': 0.21.5
      '@esbuild/freebsd-x64': 0.21.5
      '@esbuild/linux-arm': 0.21.5
      '@esbuild/linux-arm64': 0.21.5
      '@esbuild/linux-ia32': 0.21.5
      '@esbuild/linux-loong64': 0.21.5
      '@esbuild/linux-mips64el': 0.21.5
      '@esbuild/linux-ppc64': 0.21.5
      '@esbuild/linux-riscv64': 0.21.5
      '@esbuild/linux-s390x': 0.21.5
      '@esbuild/linux-x64': 0.21.5
      '@esbuild/netbsd-x64': 0.21.5
      '@esbuild/openbsd-x64': 0.21.5
      '@esbuild/sunos-x64': 0.21.5
      '@esbuild/win32-arm64': 0.21.5
      '@esbuild/win32-ia32': 0.21.5
      '@esbuild/win32-x64': 0.21.5
    dev: false

  /escalade@3.2.0:
    resolution: {integrity: sha512-WUj2qlxaQtO4g6Pq5c29GTcWGDyd8itL8zTlipgECz3JesAiiOKotd8JU6otB3PACgG6xkJUyVhboMS+bje/jA==}
    engines: {node: '>=6'}
    dev: false

  /escape-string-regexp@1.0.5:
    resolution: {integrity: sha512-vbRorB5FUQWvla16U8R/qgaFIya2qGzwDrNmCZuYKrbdSUMG6I1ZCGQRefkRVhuOkIGVne7BQ35DSfo1qvJqFg==}
    engines: {node: '>=0.8.0'}
    dev: false

  /escape-string-regexp@5.0.0:
    resolution: {integrity: sha512-/veY75JbMK4j1yjvuUxuVsiS/hr/4iHs9FTT6cgTexxdE0Ly/glccBAkloH/DofkjRbZU3bnoj38mOmhkZ0lHw==}
    engines: {node: '>=12'}
    dev: false

  /esprima@4.0.1:
    resolution: {integrity: sha512-eGuFFw7Upda+g4p+QHvnW0RyTX/SVeJBDM/gCtMARO0cLuT2HcEKnTPvhjV6aGeqrCB/sbNop0Kszm0jsaWU4A==}
    engines: {node: '>=4'}
    hasBin: true
    dev: false

  /estree-walker@2.0.2:
    resolution: {integrity: sha512-Rfkk/Mp/DL7JVje3u18FxFujQlTNR2q6QfMSMB7AvCBx91NGj/ba3kCfza0f6dVDbw7YlRf/nDrn7pQrCCyQ/w==}
    dev: false

  /estree-walker@3.0.3:
    resolution: {integrity: sha512-7RUKfXgSMMkzt6ZuXmqapOurLGPPfgj6l9uRZ7lRGolvk0y2yocc35LdcxKC5PQZdn2DMqioAQ2NoWcrTKmm6g==}
    dependencies:
      '@types/estree': 1.0.6
    dev: false

  /eventemitter3@5.0.1:
    resolution: {integrity: sha512-GWkBvjiSZK87ELrYOSESUYeVIc9mvLLf/nXalMOS5dYrgZq9o5OVkbZAVM06CVxYsCwH9BDZFPlQTlPA1j4ahA==}
    dev: false

  /execa@8.0.1:
    resolution: {integrity: sha512-VyhnebXciFV2DESc+p6B+y0LjSm0krU4OgJN44qFAhBY0TJ+1V61tYD2+wHusZ6F9n5K+vl8k0sTy7PEfV4qpg==}
    engines: {node: '>=16.17'}
    dependencies:
      cross-spawn: 7.0.3
      get-stream: 8.0.1
      human-signals: 5.0.0
      is-stream: 3.0.0
      merge-stream: 2.0.0
      npm-run-path: 5.3.0
      onetime: 6.0.0
      signal-exit: 4.1.0
      strip-final-newline: 3.0.0
    dev: false

  /expand-template@2.0.3:
    resolution: {integrity: sha512-XYfuKMvj4O35f/pOXLObndIRvyQ+/+6AhODh+OKWj9S9498pHHn/IMszH+gt0fBCRWMNfk1ZSp5x3AifmnI2vg==}
    engines: {node: '>=6'}
    dev: false

  /extend-shallow@2.0.1:
    resolution: {integrity: sha512-zCnTtlxNoAiDc3gqY2aYAWFx7XWWiasuF2K8Me5WbN8otHKTUKBwjPtNpRs/rbUZm7KxWAaNj7P1a/p52GbVug==}
    engines: {node: '>=0.10.0'}
    dependencies:
      is-extendable: 0.1.1
    dev: false

  /extend@3.0.2:
    resolution: {integrity: sha512-fjquC59cD7CyW6urNXK0FBufkZcoiGG80wTuPujX590cB5Ttln20E2UB4S/WARVqhXffZl2LNgS+gQdPIIim/g==}
    dev: false

  /fast-deep-equal@3.1.3:
    resolution: {integrity: sha512-f3qQ9oQy9j2AhBe/H9VC91wLmKBCCU/gDOnKNAYG5hswO7BLKj09Hc5HYNz9cGI++xlpDCIgDaitVs03ATR84Q==}
    dev: false

  /fast-glob@3.3.2:
    resolution: {integrity: sha512-oX2ruAFQwf/Orj8m737Y5adxDQO0LAB7/S5MnxCdTNDd4p6BsyIVsv9JQsATbTSq8KHRpLwIHbVlUNatxd+1Ow==}
    engines: {node: '>=8.6.0'}
    dependencies:
      '@nodelib/fs.stat': 2.0.5
      '@nodelib/fs.walk': 1.2.8
      glob-parent: 5.1.2
      merge2: 1.4.1
      micromatch: 4.0.8
    dev: false

  /fast-uri@3.0.1:
    resolution: {integrity: sha512-MWipKbbYiYI0UC7cl8m/i/IWTqfC8YXsqjzybjddLsFjStroQzsHXkc73JutMvBiXmOvapk+axIl79ig5t55Bw==}
    dev: false

  /fastq@1.17.1:
    resolution: {integrity: sha512-sRVD3lWVIXWg6By68ZN7vho9a1pQcN/WBFaAAsDDFzlJjvoGx0P8z7V1t72grFJfJhu3YPZBuu25f7Kaw2jN1w==}
    dependencies:
      reusify: 1.0.4
    dev: false

  /file-uri-to-path@1.0.0:
    resolution: {integrity: sha512-0Zt+s3L7Vf1biwWZ29aARiVYLx7iMGnEUl9x33fbB/j3jR81u/O2LbqK+Bm1CDSNDKVtJ/YjwY7TUd5SkeLQLw==}
    dev: false

  /fill-range@7.1.1:
    resolution: {integrity: sha512-YsGpe3WHLK8ZYi4tWDg2Jy3ebRz2rXowDxnld4bkQB00cc/1Zw9AWnC0i9ztDJitivtQvaI9KaLyKrc+hBW0yg==}
    engines: {node: '>=8'}
    dependencies:
      to-regex-range: 5.0.1
    dev: false

  /find-up-simple@1.0.0:
    resolution: {integrity: sha512-q7Us7kcjj2VMePAa02hDAF6d+MzsdsAWEwYyOpwUtlerRBkOEPBCRZrAV4XfcSN8fHAgaD0hP7miwoay6DCprw==}
    engines: {node: '>=18'}
    dev: false

  /find-up@4.1.0:
    resolution: {integrity: sha512-PpOwAdQ/YlXQ2vj8a3h8IipDuYRi3wceVQQGYWxNINccq40Anw7BlsEXCMbt1Zt+OLA6Fq9suIpIWD0OsnISlw==}
    engines: {node: '>=8'}
    dependencies:
      locate-path: 5.0.0
      path-exists: 4.0.0
    dev: false

  /find-yarn-workspace-root2@1.2.16:
    resolution: {integrity: sha512-hr6hb1w8ePMpPVUK39S4RlwJzi+xPLuVuG8XlwXU3KD5Yn3qgBWVfy3AzNlDhWvE1EORCE65/Qm26rFQt3VLVA==}
    dependencies:
      micromatch: 4.0.8
      pkg-dir: 4.2.0
    dev: false

  /flattie@1.1.1:
    resolution: {integrity: sha512-9UbaD6XdAL97+k/n+N7JwX46K/M6Zc6KcFYskrYL8wbBV/Uyk0CTAMY0VT+qiK5PM7AIc9aTWYtq65U7T+aCNQ==}
    engines: {node: '>=8'}
    dev: false

  /foreground-child@3.3.0:
    resolution: {integrity: sha512-Ld2g8rrAyMYFXBhEqMz8ZAHBi4J4uS1i/CxGMDnjyFWddMXLVcDp051DZfu+t7+ab7Wv6SMqpWmyFIj5UbfFvg==}
    engines: {node: '>=14'}
    dependencies:
      cross-spawn: 7.0.3
      signal-exit: 4.1.0
    dev: false

  /fraction.js@4.3.7:
    resolution: {integrity: sha512-ZsDfxO51wGAXREY55a7la9LScWpwv9RxIrYABrlvOFBlH/ShPnrtsXeuUIfXKKOVicNxQ+o8JTbJvjS4M89yew==}
    dev: false

  /fs-constants@1.0.0:
    resolution: {integrity: sha512-y6OAwoSIf7FyjMIv94u+b5rdheZEjzR63GTyZJm5qh4Bi+2YgwLCcI/fPFZkL5PSixOt6ZNKm+w+Hfp/Bciwow==}
    dev: false

  /fs-minipass@2.1.0:
    resolution: {integrity: sha512-V/JgOLFCS+R6Vcq0slCuaeWEdNC3ouDlJMNIsacH2VtALiu9mV4LPrHc5cDl8k5aw6J8jwgWWpiTo5RYhmIzvg==}
    engines: {node: '>= 8'}
    dependencies:
      minipass: 3.3.6
    dev: false

  /fs-monkey@1.0.6:
    resolution: {integrity: sha512-b1FMfwetIKymC0eioW7mTywihSQE4oLzQn1dB6rZB5fx/3NpNEdAWeCSMB+60/AeT0TCXsxzAlcYVEFCTAksWg==}
    requiresBuild: true
    dev: false
    optional: true

  /fsevents@2.3.3:
    resolution: {integrity: sha512-5xoDfX+fL7faATnagmWPpbFtwh/R77WmMMqqHGS65C3vvB0YHrgF+B1YmZ3441tMj5n63k0212XNoJwzlhffQw==}
    engines: {node: ^8.16.0 || ^10.6.0 || >=11.0.0}
    os: [darwin]
    requiresBuild: true
    dev: false
    optional: true

  /function-bind@1.1.2:
    resolution: {integrity: sha512-7XHNxH7qX9xG5mIwxkhumTox/MIRNcOgDrxWsMt2pAr23WHp6MrRlN7FBSFpCpr+oVO0F744iUgR82nJMfG2SA==}
    dev: false

  /generate-function@2.3.1:
    resolution: {integrity: sha512-eeB5GfMNeevm/GRYq20ShmsaGcmI81kIX2K9XQx5miC8KdHaC6Jm0qQ8ZNeGOi7wYB8OsdxKs+Y2oVuTFuVwKQ==}
    dependencies:
      is-property: 1.0.2
    dev: false

  /gensync@1.0.0-beta.2:
    resolution: {integrity: sha512-3hN7NaskYvMDLQY55gnW3NQ+mesEAepTqlg+VEbj7zzqEMBVNhzcGYYeqFo/TlYz6eQiFcp1HcsCZO+nGgS8zg==}
    engines: {node: '>=6.9.0'}
    dev: false

  /get-caller-file@2.0.5:
    resolution: {integrity: sha512-DyFP3BM/3YHTQOCUL/w0OZHR0lpKeGrxotcHWcqNEdnltqFwXVfhEBQ94eIo34AfQpo0rGki4cyIiftY06h2Fg==}
    engines: {node: 6.* || 8.* || >= 10.*}
    dev: false

  /get-east-asian-width@1.2.0:
    resolution: {integrity: sha512-2nk+7SIVb14QrgXFHcm84tD4bKQz0RxPuMT8Ag5KPOq7J5fEmAg0UbXdTOSHqNuHSU28k55qnceesxXRZGzKWA==}
    engines: {node: '>=18'}
    dev: false

  /get-stream@8.0.1:
    resolution: {integrity: sha512-VaUJspBffn/LMCJVoMvSAdmscJyS1auj5Zulnn5UoYcY531UWmdwhRWkcGKnGU93m5HSXP9LP2usOryrBtQowA==}
    engines: {node: '>=16'}
    dev: false

  /giget@1.2.3:
    resolution: {integrity: sha512-8EHPljDvs7qKykr6uw8b+lqLiUc/vUg+KVTI0uND4s63TdsZM2Xus3mflvF0DDG9SiM4RlCkFGL+7aAjRmV7KA==}
    hasBin: true
    dependencies:
      citty: 0.1.6
      consola: 3.2.3
      defu: 6.1.4
      node-fetch-native: 1.6.4
      nypm: 0.3.11
      ohash: 1.1.4
      pathe: 1.1.2
      tar: 6.2.1
    dev: false

  /github-from-package@0.0.0:
    resolution: {integrity: sha512-SyHy3T1v2NUXn29OsWdxmK6RwHD+vkj3v8en8AOBZ1wBQ/hCAQ5bAQTD02kW4W9tUp/3Qh6J8r9EvntiyCmOOw==}
    dev: false

  /github-slugger@2.0.0:
    resolution: {integrity: sha512-IaOQ9puYtjrkq7Y0Ygl9KDZnrf/aiUJYUpVf89y8kyaxbRG7Y1SrX/jaumrv81vc61+kiMempujsM3Yw7w5qcw==}
    dev: false

  /glob-parent@5.1.2:
    resolution: {integrity: sha512-AOIgSQCepiJYwP3ARnGx+5VnTu2HBYdzbGP45eLw1vr3zB3vZLeyed1sC9hnbcOc9/SrMyM5RPQrkGz4aS9Zow==}
    engines: {node: '>= 6'}
    dependencies:
      is-glob: 4.0.3
    dev: false

  /glob-parent@6.0.2:
    resolution: {integrity: sha512-XxwI8EOhVQgWp6iDL+3b0r86f4d6AX6zSU55HfB4ydCEuXLXc5FcYeOu+nnGftS4TEju/11rt4KJPTMgbfmv4A==}
    engines: {node: '>=10.13.0'}
    dependencies:
      is-glob: 4.0.3
    dev: false

  /glob@10.4.5:
    resolution: {integrity: sha512-7Bv8RF0k6xjo7d4A/PxYLbUCfb6c+Vpd2/mB2yRDlew7Jb5hEXiCD9ibfO7wpk8i4sevK6DFny9h7EYbM3/sHg==}
    hasBin: true
    dependencies:
      foreground-child: 3.3.0
      jackspeak: 3.4.3
      minimatch: 9.0.5
      minipass: 7.1.2
      package-json-from-dist: 1.0.0
      path-scurry: 1.11.1
    dev: false

  /globals@11.12.0:
    resolution: {integrity: sha512-WOBp/EEGUiIsJSp7wcv/y6MO+lV9UoncWqxuFfm8eBwzWNgyfBd6Gz+IeKQ9jCmyhoH99g15M3T+QaVHFjizVA==}
    engines: {node: '>=4'}
    dev: false

  /globalyzer@0.1.0:
    resolution: {integrity: sha512-40oNTM9UfG6aBmuKxk/giHn5nQ8RVz/SS4Ir6zgzOv9/qC3kKZ9v4etGTcJbEl/NyVQH7FGU7d+X1egr57Md2Q==}
    dev: false

  /globrex@0.1.2:
    resolution: {integrity: sha512-uHJgbwAMwNFf5mLst7IWLNg14x1CkeqglJb/K3doi4dw6q2IvAAmM/Y81kevy83wP+Sst+nutFTYOGg3d1lsxg==}
    dev: false

  /graceful-fs@4.2.11:
    resolution: {integrity: sha512-RbJ5/jmFcNNCcDV5o9eTnBLJ/HszWV0P73bc+Ff4nS/rJj+YaS6IGyiOL0VoBYX+l1Wrl3k63h/KrH+nhJ0XvQ==}
    dev: false

  /gray-matter@4.0.3:
    resolution: {integrity: sha512-5v6yZd4JK3eMI3FqqCouswVqwugaA9r4dNZB1wwcmrD02QkV5H0y7XBQW8QwQqEaZY1pM9aqORSORhJRdNK44Q==}
    engines: {node: '>=6.0'}
    dependencies:
      js-yaml: 3.14.1
      kind-of: 6.0.3
      section-matter: 1.0.0
      strip-bom-string: 1.0.0
    dev: false

  /has-flag@3.0.0:
    resolution: {integrity: sha512-sKJf1+ceQBr4SMkvQnBDNDtf4TXpVhVGateu0t918bl30FnbE2m4vNLX+VWe/dpjlb+HugGYzW7uQXH98HPEYw==}
    engines: {node: '>=4'}
    dev: false

  /hasown@2.0.2:
    resolution: {integrity: sha512-0hJU9SCPvmMzIBdZFqNPXWa6dqh7WdH0cII9y+CyS8rG3nL48Bclra9HmKhVVUHyPWNH5Y7xDwAB7bfgSjkUMQ==}
    engines: {node: '>= 0.4'}
    dependencies:
      function-bind: 1.1.2
    dev: false

  /hast-util-from-html@2.0.3:
    resolution: {integrity: sha512-CUSRHXyKjzHov8yKsQjGOElXy/3EKpyX56ELnkHH34vDVw1N1XSQ1ZcAvTyAPtGqLTuKP/uxM+aLkSPqF/EtMw==}
    dependencies:
      '@types/hast': 3.0.4
      devlop: 1.1.0
      hast-util-from-parse5: 8.0.1
      parse5: 7.1.2
      vfile: 6.0.3
      vfile-message: 4.0.2
    dev: false

  /hast-util-from-parse5@8.0.1:
    resolution: {integrity: sha512-Er/Iixbc7IEa7r/XLtuG52zoqn/b3Xng/w6aZQ0xGVxzhw5xUFxcRqdPzP6yFi/4HBYRaifaI5fQ1RH8n0ZeOQ==}
    dependencies:
      '@types/hast': 3.0.4
      '@types/unist': 3.0.3
      devlop: 1.1.0
      hastscript: 8.0.0
      property-information: 6.5.0
      vfile: 6.0.3
      vfile-location: 5.0.3
      web-namespaces: 2.0.1
    dev: false

  /hast-util-is-element@3.0.0:
    resolution: {integrity: sha512-Val9mnv2IWpLbNPqc/pUem+a7Ipj2aHacCwgNfTiK0vJKl0LF+4Ba4+v1oPHFpf3bLYmreq0/l3Gud9S5OH42g==}
    dependencies:
      '@types/hast': 3.0.4
    dev: false

  /hast-util-parse-selector@4.0.0:
    resolution: {integrity: sha512-wkQCkSYoOGCRKERFWcxMVMOcYE2K1AaNLU8DXS9arxnLOUEWbOXKXiJUNzEpqZ3JOKpnha3jkFrumEjVliDe7A==}
    dependencies:
      '@types/hast': 3.0.4
    dev: false

  /hast-util-raw@9.0.4:
    resolution: {integrity: sha512-LHE65TD2YiNsHD3YuXcKPHXPLuYh/gjp12mOfU8jxSrm1f/yJpsb0F/KKljS6U9LJoP0Ux+tCe8iJ2AsPzTdgA==}
    dependencies:
      '@types/hast': 3.0.4
      '@types/unist': 3.0.3
      '@ungap/structured-clone': 1.2.0
      hast-util-from-parse5: 8.0.1
      hast-util-to-parse5: 8.0.0
      html-void-elements: 3.0.0
      mdast-util-to-hast: 13.2.0
      parse5: 7.1.2
      unist-util-position: 5.0.0
      unist-util-visit: 5.0.0
      vfile: 6.0.3
      web-namespaces: 2.0.1
      zwitch: 2.0.4
    dev: false

  /hast-util-to-html@9.0.3:
    resolution: {integrity: sha512-M17uBDzMJ9RPCqLMO92gNNUDuBSq10a25SDBI08iCCxmorf4Yy6sYHK57n9WAbRAAaU+DuR4W6GN9K4DFZesYg==}
    dependencies:
      '@types/hast': 3.0.4
      '@types/unist': 3.0.3
      ccount: 2.0.1
      comma-separated-tokens: 2.0.3
      hast-util-whitespace: 3.0.0
      html-void-elements: 3.0.0
      mdast-util-to-hast: 13.2.0
      property-information: 6.5.0
      space-separated-tokens: 2.0.2
      stringify-entities: 4.0.4
      zwitch: 2.0.4
    dev: false

  /hast-util-to-parse5@8.0.0:
    resolution: {integrity: sha512-3KKrV5ZVI8if87DVSi1vDeByYrkGzg4mEfeu4alwgmmIeARiBLKCZS2uw5Gb6nU9x9Yufyj3iudm6i7nl52PFw==}
    dependencies:
      '@types/hast': 3.0.4
      comma-separated-tokens: 2.0.3
      devlop: 1.1.0
      property-information: 6.5.0
      space-separated-tokens: 2.0.2
      web-namespaces: 2.0.1
      zwitch: 2.0.4
    dev: false

  /hast-util-to-text@4.0.2:
    resolution: {integrity: sha512-KK6y/BN8lbaq654j7JgBydev7wuNMcID54lkRav1P0CaE1e47P72AWWPiGKXTJU271ooYzcvTAn/Zt0REnvc7A==}
    dependencies:
      '@types/hast': 3.0.4
      '@types/unist': 3.0.3
      hast-util-is-element: 3.0.0
      unist-util-find-after: 5.0.0
    dev: false

  /hast-util-whitespace@3.0.0:
    resolution: {integrity: sha512-88JUN06ipLwsnv+dVn+OIYOvAuvBMy/Qoi6O7mQHxdPXpjy+Cd6xRkWwux7DKO+4sYILtLBRIKgsdpS2gQc7qw==}
    dependencies:
      '@types/hast': 3.0.4
    dev: false

  /hastscript@8.0.0:
    resolution: {integrity: sha512-dMOtzCEd3ABUeSIISmrETiKuyydk1w0pa+gE/uormcTpSYuaNJPbX1NU3JLyscSLjwAQM8bWMhhIlnCqnRvDTw==}
    dependencies:
      '@types/hast': 3.0.4
      comma-separated-tokens: 2.0.3
      hast-util-parse-selector: 4.0.0
      property-information: 6.5.0
      space-separated-tokens: 2.0.2
    dev: false

  /html-escaper@3.0.3:
    resolution: {integrity: sha512-RuMffC89BOWQoY0WKGpIhn5gX3iI54O6nRA0yC124NYVtzjmFWBIiFd8M0x+ZdX0P9R4lADg1mgP8C7PxGOWuQ==}
    dev: false

  /html-void-elements@3.0.0:
    resolution: {integrity: sha512-bEqo66MRXsUGxWHV5IP0PUiAWwoEjba4VCzg0LjFJBpchPaTfyfCKTG6bc5F8ucKec3q5y6qOdGyYTSBEvhCrg==}
    dev: false

  /http-cache-semantics@4.1.1:
    resolution: {integrity: sha512-er295DKPVsV82j5kw1Gjt+ADA/XYHsajl82cGNQG2eyoPkvgUhX+nDIyelzhIWbbsXP39EHcI6l5tYs2FYqYXQ==}
    dev: false

  /human-signals@5.0.0:
    resolution: {integrity: sha512-AXcZb6vzzrFAUE61HnN4mpLqd/cSIwNQjtNWR0euPm6y0iqx3G4gOXaIDdtdDwZmhwe82LA6+zinmW4UBWVePQ==}
    engines: {node: '>=16.17.0'}
    dev: false

  /iconv-lite@0.6.3:
    resolution: {integrity: sha512-4fCk79wshMdzMp2rH06qWrJE4iolqLhCUH+OiuIgU++RB0+94NlDL81atO7GX55uUKueo0txHNtvEyI6D7WdMw==}
    engines: {node: '>=0.10.0'}
    dependencies:
      safer-buffer: 2.1.2
    dev: false

  /ieee754@1.2.1:
    resolution: {integrity: sha512-dcyqhDvX1C46lXZcVqCpK+FtMRQVdIMN6/Df5js2zouUsqG7I6sFxitIC+7KYK29KdXOLHdu9zL4sFnoVQnqaA==}
    dev: false

  /import-meta-resolve@4.1.0:
    resolution: {integrity: sha512-I6fiaX09Xivtk+THaMfAwnA3MVA5Big1WHF1Dfx9hFuvNIWpXnorlkzhcQf6ehrqQiiZECRt1poOAkPmer3ruw==}
    dev: false

  /inherits@2.0.4:
    resolution: {integrity: sha512-k/vGaX4/Yla3WzyMCvTQOXYeIHvqOKtnqBduzTHpzpQZzAskKMhZ2K+EnBiSM9zGSoIFeMpXKxa4dYeZIQqewQ==}
    dev: false

  /ini@1.3.8:
    resolution: {integrity: sha512-JV/yugV2uzW5iMRSiZAyDtQd+nxtUnjeLt0acNdw98kKLrvuRVyB80tsREOE7yvGVgalhZ6RNXCmEHkUKBKxew==}
    dev: false

  /ipaddr.js@2.2.0:
    resolution: {integrity: sha512-Ag3wB2o37wslZS19hZqorUnrnzSkpOVy+IiiDEiTqNubEYpYuHWIf6K4psgN2ZWKExS4xhVCrRVfb/wfW8fWJA==}
    engines: {node: '>= 10'}
    dev: false

  /is-arrayish@0.3.2:
    resolution: {integrity: sha512-eVRqCvVlZbuw3GrM63ovNSNAeA1K16kaR/LRY/92w0zxQ5/1YzwblUX652i4Xs9RwAGjW9d9y6X88t8OaAJfWQ==}
    requiresBuild: true
    dev: false
    optional: true

  /is-binary-path@2.1.0:
    resolution: {integrity: sha512-ZMERYes6pDydyuGidse7OsHxtbI7WVeUEozgR/g7rd0xUimYNlvZRE/K2MgZTjWy725IfelLeVcEM97mmtRGXw==}
    engines: {node: '>=8'}
    dependencies:
      binary-extensions: 2.3.0
    dev: false

  /is-core-module@2.15.1:
    resolution: {integrity: sha512-z0vtXSwucUJtANQWldhbtbt7BnL0vxiFjIdDLAatwhDYty2bad6s+rijD6Ri4YuYJubLzIJLUidCh09e1djEVQ==}
    engines: {node: '>= 0.4'}
    dependencies:
      hasown: 2.0.2
    dev: false

  /is-docker@3.0.0:
    resolution: {integrity: sha512-eljcgEDlEns/7AXFosB5K/2nCM4P7FQPkGc/DWLy5rmFEWvZayGrik1d9/QIY5nJ4f9YsVvBkA6kJpHn9rISdQ==}
    engines: {node: ^12.20.0 || ^14.13.1 || >=16.0.0}
    hasBin: true
    dev: false

  /is-extendable@0.1.1:
    resolution: {integrity: sha512-5BMULNob1vgFX6EjQw5izWDxrecWK9AM72rugNr0TFldMOi0fj6Jk+zeKIt0xGj4cEfQIJth4w3OKWOJ4f+AFw==}
    engines: {node: '>=0.10.0'}
    dev: false

  /is-extglob@2.1.1:
    resolution: {integrity: sha512-SbKbANkN603Vi4jEZv49LeVJMn4yGwsbzZworEoyEiutsN3nJYdbO36zfhGJ6QEDpOZIFkDtnq5JRxmvl3jsoQ==}
    engines: {node: '>=0.10.0'}
    dev: false

  /is-fullwidth-code-point@3.0.0:
    resolution: {integrity: sha512-zymm5+u+sCsSWyD9qNaejV3DFvhCKclKdizYaJUuHA83RLjb7nSuGnddCHGv0hk+KY7BMAlsWeK4Ueg6EV6XQg==}
    engines: {node: '>=8'}
    dev: false

  /is-glob@4.0.3:
    resolution: {integrity: sha512-xelSayHH36ZgE7ZWhli7pW34hNbNl8Ojv5KVmkJD4hBdD3th8Tfk9vYasLM+mXWOZhFkgZfxhLSnrwRr4elSSg==}
    engines: {node: '>=0.10.0'}
    dependencies:
      is-extglob: 2.1.1
    dev: false

  /is-inside-container@1.0.0:
    resolution: {integrity: sha512-KIYLCCJghfHZxqjYBE7rEy0OBuTd5xCHS7tHVgvCLkx7StIoaxwNW3hCALgEUjFfeRk+MG/Qxmp/vtETEF3tRA==}
    engines: {node: '>=14.16'}
    hasBin: true
    dependencies:
      is-docker: 3.0.0
    dev: false

  /is-interactive@2.0.0:
    resolution: {integrity: sha512-qP1vozQRI+BMOPcjFzrjXuQvdak2pHNUMZoeG2eRbiSqyvbEf/wQtEOTOX1guk6E3t36RkaqiSt8A/6YElNxLQ==}
    engines: {node: '>=12'}
    dev: false

  /is-number@7.0.0:
    resolution: {integrity: sha512-41Cifkg6e8TylSpdtTpeLVMqvSBEVzTttHvERD741+pnZ8ANv0004MRL43QKPDlK9cGvNp6NZWZUBlbGXYxxng==}
    engines: {node: '>=0.12.0'}
    dev: false

  /is-plain-obj@4.1.0:
    resolution: {integrity: sha512-+Pgi+vMuUNkJyExiMBt5IlFoMyKnr5zhJ4Uspz58WOhBF5QoIZkFyNHIbBAtHwzVAgk5RtndVNsDRN61/mmDqg==}
    engines: {node: '>=12'}
    dev: false

  /is-property@1.0.2:
    resolution: {integrity: sha512-Ks/IoX00TtClbGQr4TWXemAnktAQvYB7HzcCxDGqEZU6oCmb2INHuOoKxbtR+HFkmYWBKv/dOZtGRiAjDhj92g==}
    dev: false

  /is-stream@3.0.0:
    resolution: {integrity: sha512-LnQR4bZ9IADDRSkvpqMGvt/tEJWclzklNgSw48V5EAaAeDd6qGvN8ei6k5p0tvxSR171VmGyHuTiAOfxAbr8kA==}
    engines: {node: ^12.20.0 || ^14.13.1 || >=16.0.0}
    dev: false

  /is-unicode-supported@1.3.0:
    resolution: {integrity: sha512-43r2mRvz+8JRIKnWJ+3j8JtjRKZ6GmjzfaE/qiBJnikNnYv/6bagRJ1kUhNk8R5EX/GkobD+r+sfxCPJsiKBLQ==}
    engines: {node: '>=12'}
    dev: false

  /is-unicode-supported@2.1.0:
    resolution: {integrity: sha512-mE00Gnza5EEB3Ds0HfMyllZzbBrmLOX3vfWoj9A9PEnTfratQ/BcaJOuMhnkhjXvb2+FkY3VuHqtAGpTPmglFQ==}
    engines: {node: '>=18'}
    dev: false

  /is-wsl@3.1.0:
    resolution: {integrity: sha512-UcVfVfaK4Sc4m7X3dUSoHoozQGBEFeDC+zVo06t98xe8CzHSZZBekNXH+tu0NalHolcJ/QAGqS46Hef7QXBIMw==}
    engines: {node: '>=16'}
    dependencies:
      is-inside-container: 1.0.0
    dev: false

  /isexe@2.0.0:
    resolution: {integrity: sha512-RHxMLp9lnKHGHRng9QFhRCMbYAcVpn69smSGcq3f36xjgVVWThj4qqLbTLlq7Ssj8B+fIQ1EuCEGI2lKsyQeIw==}
    dev: false

  /jackspeak@3.4.3:
    resolution: {integrity: sha512-OGlZQpz2yfahA/Rd1Y8Cd9SIEsqvXkLVoSw/cgwhnhFMDbsQFeZYoJJ7bIZBS9BcamUW96asq/npPWugM+RQBw==}
    dependencies:
      '@isaacs/cliui': 8.0.2
    optionalDependencies:
      '@pkgjs/parseargs': 0.11.0
    dev: false

  /jiti@1.21.6:
    resolution: {integrity: sha512-2yTgeWTWzMWkHu6Jp9NKgePDaYHbntiwvYuuJLbbN9vl7DC9DvXKOB2BC3ZZ92D3cvV/aflH0osDfwpHepQ53w==}
    hasBin: true
    dev: false

  /jose@5.9.3:
    resolution: {integrity: sha512-egLIoYSpcd+QUF+UHgobt5YzI2Pkw/H39ou9suW687MY6PmCwPmkNV/4TNjn1p2tX5xO3j0d0sq5hiYE24bSlg==}
    dev: false

  /js-tokens@4.0.0:
    resolution: {integrity: sha512-RdJUflcE3cUzKiMqQgsCu06FPu9UdIJO0beYbPhHN4k6apgJtifcoCtT9bcxOpYBtpD2kCM6Sbzg4CausW/PKQ==}
    dev: false

  /js-yaml@3.14.1:
    resolution: {integrity: sha512-okMH7OXXJ7YrN9Ok3/SXrnu4iX9yOk+25nqX4imS2npuvTYDmo/QEZoqwZkYaIDk3jVvBOTOIEgEhaLOynBS9g==}
    hasBin: true
    dependencies:
      argparse: 1.0.10
      esprima: 4.0.1
    dev: false

  /js-yaml@4.1.0:
    resolution: {integrity: sha512-wpxZs9NoxZaJESJGIZTyDEaYpl0FKSA+FB9aJiyemKhMwkxQg63h4T1KJgUGHpTqPDNRcmmYLugrRjJlBtWvRA==}
    hasBin: true
    dependencies:
      argparse: 2.0.1
    dev: false

  /jsesc@2.5.2:
    resolution: {integrity: sha512-OYu7XEzjkCQ3C5Ps3QIZsQfNpqoJyZZA99wd9aWd05NCtC5pWOkShK2mkL6HXQR6/Cy2lbNdPlZBpuQHXE63gA==}
    engines: {node: '>=4'}
    hasBin: true
    dev: false

  /json-schema-traverse@1.0.0:
    resolution: {integrity: sha512-NM8/P9n3XjXhIZn1lLhkFaACTOURQXjWhV4BA/RnOv8xvgqtqpAX9IO4mRQxSx1Rlo4tqzeqb0sOlruaOy3dug==}
    dev: false

  /json5@2.2.3:
    resolution: {integrity: sha512-XmOWe7eyHYH14cLdVPoyg+GOH3rYX++KpzrylJwSW98t3Nk+U8XOl8FWKOgwtzdb8lXGf6zYwDUzeHMWfxasyg==}
    engines: {node: '>=6'}
    hasBin: true
    dev: false

  /jsonc-parser@2.3.1:
    resolution: {integrity: sha512-H8jvkz1O50L3dMZCsLqiuB2tA7muqbSg1AtGEkN0leAqGjsUzDJir3Zwr02BhqdcITPg3ei3mZ+HjMocAknhhg==}
    dev: false

  /jsonc-parser@3.3.1:
    resolution: {integrity: sha512-HUgH65KyejrUFPvHFPbqOY0rsFip3Bo5wb4ngvdi1EpCYWUQDC5V+Y7mZws+DLkr4M//zQJoanu1SP+87Dv1oQ==}
    dev: false

  /kind-of@6.0.3:
    resolution: {integrity: sha512-dcS1ul+9tmeD95T+x28/ehLgd9mENa3LsvDTtzm3vyBEO7RPptvAD+t44WVXaUjTBRcrpFeFlC8WCruUR456hw==}
    engines: {node: '>=0.10.0'}
    dev: false

  /kleur@3.0.3:
    resolution: {integrity: sha512-eTIzlVOSUR+JxdDFepEYcBMtZ9Qqdef+rnzWdRZuMbOywu5tO2w2N7rqjoANZ5k9vywhL6Br1VRjUIgTQx4E8w==}
    engines: {node: '>=6'}
    dev: false

  /kleur@4.1.5:
    resolution: {integrity: sha512-o+NO+8WrRiQEE4/7nwRJhN1HWpVmJm511pBHUxPLtp0BUISzlBplORYSmTclCnJvQq2tKu/sgl3xVpkc7ZWuQQ==}
    engines: {node: '>=6'}
    dev: false

  /kysely-postgres-js@2.0.0(kysely@0.27.4)(postgres@3.4.4):
    resolution: {integrity: sha512-R1tWx6/x3tSatWvsmbHJxpBZYhNNxcnMw52QzZaHKg7ZOWtHib4iZyEaw4gb2hNKVctWQ3jfMxZT/ZaEMK6kBQ==}
    peerDependencies:
      kysely: '>= 0.24.0 < 1'
      postgres: '>= 3.4.0 < 4'
    dependencies:
      kysely: 0.27.4
      postgres: 3.4.4
    dev: false

  /kysely@0.27.4:
    resolution: {integrity: sha512-dyNKv2KRvYOQPLCAOCjjQuCk4YFd33BvGdf/o5bC7FiW+BB6snA81Zt+2wT9QDFzKqxKa5rrOmvlK/anehCcgA==}
    engines: {node: '>=14.0.0'}
    dev: false

  /lilconfig@2.1.0:
    resolution: {integrity: sha512-utWOt/GHzuUxnLKxB6dk81RoOeoNeHgbrXiuGk4yyF5qlRz+iIVWu56E2fqGHFrXz0QNUhLB/8nKqvRH66JKGQ==}
    engines: {node: '>=10'}
    dev: false

  /lilconfig@3.1.2:
    resolution: {integrity: sha512-eop+wDAvpItUys0FWkHIKeC9ybYrTGbU41U5K7+bttZZeohvnY7M9dZ5kB21GNWiFT2q1OoPTvncPCgSOVO5ow==}
    engines: {node: '>=14'}
    dev: false

  /lines-and-columns@1.2.4:
    resolution: {integrity: sha512-7ylylesZQ/PV29jhEDl3Ufjo6ZX7gCqJr5F7PKrqc93v7fzSymt1BpwEU8nAUXs8qzzvqhbjhK5QZg6Mt/HkBg==}
    dev: false

  /load-yaml-file@0.2.0:
    resolution: {integrity: sha512-OfCBkGEw4nN6JLtgRidPX6QxjBQGQf72q3si2uvqyFEMbycSFFHwAZeXx6cJgFM9wmLrf9zBwCP3Ivqa+LLZPw==}
    engines: {node: '>=6'}
    dependencies:
      graceful-fs: 4.2.11
      js-yaml: 3.14.1
      pify: 4.0.1
      strip-bom: 3.0.0
    dev: false

  /locate-path@5.0.0:
    resolution: {integrity: sha512-t7hw9pI+WvuwNJXwk5zVHpyhIqzg2qTlklJOf0mVxGSbe3Fp2VieZcduNYjaLDoy6p9uGpQEGWG87WpMKlNq8g==}
    engines: {node: '>=8'}
    dependencies:
      p-locate: 4.1.0
    dev: false

  /lodash@4.17.21:
    resolution: {integrity: sha512-v2kDEe57lecTulaDIuNTPy3Ry4gLGJ6Z1O3vE1krgXZNrsQ+LFTGHVxVjcXPs17LhbZVGedAJv8XZ1tvj5FvSg==}
    dev: false

  /log-symbols@6.0.0:
    resolution: {integrity: sha512-i24m8rpwhmPIS4zscNzK6MSEhk0DUWa/8iYQWxhffV8jkI4Phvs3F+quL5xvS0gdQR0FyTCMMH33Y78dDTzzIw==}
    engines: {node: '>=18'}
    dependencies:
      chalk: 5.3.0
      is-unicode-supported: 1.3.0
    dev: false

  /long@5.2.3:
    resolution: {integrity: sha512-lcHwpNoggQTObv5apGNCTdJrO69eHOZMi4BNC+rTLER8iHAqGrUVeLh/irVIM7zTw2bOXA8T6uNPeujwOLg/2Q==}
    dev: false

  /longest-streak@3.1.0:
    resolution: {integrity: sha512-9Ri+o0JYgehTaVBBDoMqIl8GXtbWg711O3srftcHhZ0dqnETqLaoIK0x17fUw9rFSlK/0NlsKe0Ahhyl5pXE2g==}
    dev: false

  /loose-envify@1.4.0:
    resolution: {integrity: sha512-lyuxPGr/Wfhrlem2CL/UcnUc1zcqKAImBDzukY7Y5F/yQiNdko6+fRLevlw1HgMySw7f611UIY408EtxRSoK3Q==}
    hasBin: true
    dependencies:
      js-tokens: 4.0.0
    dev: false

  /lru-cache@10.4.3:
    resolution: {integrity: sha512-JNAzZcXrCt42VGLuYz0zfAzDfAvJWW6AfYlDBQyDV5DClI2m5sAmK+OIO7s59XfsRsWHp02jAJrRadPRGTt6SQ==}
    dev: false

  /lru-cache@5.1.1:
    resolution: {integrity: sha512-KpNARQA3Iwv+jTA0utUVVbrh+Jlrr1Fv0e56GGzAFOXN7dk/FviaDW8LHmK52DlcH4WP2n6gI8vN1aesBFgo9w==}
    dependencies:
      yallist: 3.1.1
    dev: false

  /lru-cache@7.18.3:
    resolution: {integrity: sha512-jumlc0BIUrS3qJGgIkWZsyfAM7NCWiBcCDhnd+3NNM5KbBmLTgHVfWBcg6W+rLUsIpzpERPsvwUP7CckAQSOoA==}
    engines: {node: '>=12'}
    dev: false

  /lru.min@1.1.1:
    resolution: {integrity: sha512-FbAj6lXil6t8z4z3j0E5mfRlPzxkySotzUHwRXjlpRh10vc6AI6WN62ehZj82VG7M20rqogJ0GLwar2Xa05a8Q==}
    engines: {bun: '>=1.0.0', deno: '>=1.30.0', node: '>=8.0.0'}
    dev: false

  /magic-string@0.30.11:
    resolution: {integrity: sha512-+Wri9p0QHMy+545hKww7YAu5NyzF8iomPL/RQazugQ9+Ez4Ic3mERMd8ZTX5rfK944j+560ZJi8iAwgak1Ac7A==}
    dependencies:
      '@jridgewell/sourcemap-codec': 1.5.0
    dev: false

  /magicast@0.3.5:
    resolution: {integrity: sha512-L0WhttDl+2BOsybvEOLK7fW3UA0OQ0IQ2d6Zl2x/a6vVRs3bAY0ECOSHHeL5jD+SbOpOCUEi0y1DgHEn9Qn1AQ==}
    dependencies:
      '@babel/parser': 7.25.6
      '@babel/types': 7.25.6
      source-map-js: 1.2.1
    dev: false

  /markdown-table@3.0.3:
    resolution: {integrity: sha512-Z1NL3Tb1M9wH4XESsCDEksWoKTdlUafKc4pt0GRwjUyXaCFZ+dc3g2erqB6zm3szA2IUSi7VnPI+o/9jnxh9hw==}
    dev: false

  /mdast-util-definitions@6.0.0:
    resolution: {integrity: sha512-scTllyX6pnYNZH/AIp/0ePz6s4cZtARxImwoPJ7kS42n+MnVsI4XbnG6d4ibehRIldYMWM2LD7ImQblVhUejVQ==}
    dependencies:
      '@types/mdast': 4.0.4
      '@types/unist': 3.0.3
      unist-util-visit: 5.0.0
    dev: false

  /mdast-util-find-and-replace@3.0.1:
    resolution: {integrity: sha512-SG21kZHGC3XRTSUhtofZkBzZTJNM5ecCi0SK2IMKmSXR8vO3peL+kb1O0z7Zl83jKtutG4k5Wv/W7V3/YHvzPA==}
    dependencies:
      '@types/mdast': 4.0.4
      escape-string-regexp: 5.0.0
      unist-util-is: 6.0.0
      unist-util-visit-parents: 6.0.1
    dev: false

  /mdast-util-from-markdown@2.0.1:
    resolution: {integrity: sha512-aJEUyzZ6TzlsX2s5B4Of7lN7EQtAxvtradMMglCQDyaTFgse6CmtmdJ15ElnVRlCg1vpNyVtbem0PWzlNieZsA==}
    dependencies:
      '@types/mdast': 4.0.4
      '@types/unist': 3.0.3
      decode-named-character-reference: 1.0.2
      devlop: 1.1.0
      mdast-util-to-string: 4.0.0
      micromark: 4.0.0
      micromark-util-decode-numeric-character-reference: 2.0.1
      micromark-util-decode-string: 2.0.0
      micromark-util-normalize-identifier: 2.0.0
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
      unist-util-stringify-position: 4.0.0
    transitivePeerDependencies:
      - supports-color
    dev: false

  /mdast-util-gfm-autolink-literal@2.0.1:
    resolution: {integrity: sha512-5HVP2MKaP6L+G6YaxPNjuL0BPrq9orG3TsrZ9YXbA3vDw/ACI4MEsnoDpn6ZNm7GnZgtAcONJyPhOP8tNJQavQ==}
    dependencies:
      '@types/mdast': 4.0.4
      ccount: 2.0.1
      devlop: 1.1.0
      mdast-util-find-and-replace: 3.0.1
      micromark-util-character: 2.1.0
    dev: false

  /mdast-util-gfm-footnote@2.0.0:
    resolution: {integrity: sha512-5jOT2boTSVkMnQ7LTrd6n/18kqwjmuYqo7JUPe+tRCY6O7dAuTFMtTPauYYrMPpox9hlN0uOx/FL8XvEfG9/mQ==}
    dependencies:
      '@types/mdast': 4.0.4
      devlop: 1.1.0
      mdast-util-from-markdown: 2.0.1
      mdast-util-to-markdown: 2.1.0
      micromark-util-normalize-identifier: 2.0.0
    transitivePeerDependencies:
      - supports-color
    dev: false

  /mdast-util-gfm-strikethrough@2.0.0:
    resolution: {integrity: sha512-mKKb915TF+OC5ptj5bJ7WFRPdYtuHv0yTRxK2tJvi+BDqbkiG7h7u/9SI89nRAYcmap2xHQL9D+QG/6wSrTtXg==}
    dependencies:
      '@types/mdast': 4.0.4
      mdast-util-from-markdown: 2.0.1
      mdast-util-to-markdown: 2.1.0
    transitivePeerDependencies:
      - supports-color
    dev: false

  /mdast-util-gfm-table@2.0.0:
    resolution: {integrity: sha512-78UEvebzz/rJIxLvE7ZtDd/vIQ0RHv+3Mh5DR96p7cS7HsBhYIICDBCu8csTNWNO6tBWfqXPWekRuj2FNOGOZg==}
    dependencies:
      '@types/mdast': 4.0.4
      devlop: 1.1.0
      markdown-table: 3.0.3
      mdast-util-from-markdown: 2.0.1
      mdast-util-to-markdown: 2.1.0
    transitivePeerDependencies:
      - supports-color
    dev: false

  /mdast-util-gfm-task-list-item@2.0.0:
    resolution: {integrity: sha512-IrtvNvjxC1o06taBAVJznEnkiHxLFTzgonUdy8hzFVeDun0uTjxxrRGVaNFqkU1wJR3RBPEfsxmU6jDWPofrTQ==}
    dependencies:
      '@types/mdast': 4.0.4
      devlop: 1.1.0
      mdast-util-from-markdown: 2.0.1
      mdast-util-to-markdown: 2.1.0
    transitivePeerDependencies:
      - supports-color
    dev: false

  /mdast-util-gfm@3.0.0:
    resolution: {integrity: sha512-dgQEX5Amaq+DuUqf26jJqSK9qgixgd6rYDHAv4aTBuA92cTknZlKpPfa86Z/s8Dj8xsAQpFfBmPUHWJBWqS4Bw==}
    dependencies:
      mdast-util-from-markdown: 2.0.1
      mdast-util-gfm-autolink-literal: 2.0.1
      mdast-util-gfm-footnote: 2.0.0
      mdast-util-gfm-strikethrough: 2.0.0
      mdast-util-gfm-table: 2.0.0
      mdast-util-gfm-task-list-item: 2.0.0
      mdast-util-to-markdown: 2.1.0
    transitivePeerDependencies:
      - supports-color
    dev: false

  /mdast-util-phrasing@4.1.0:
    resolution: {integrity: sha512-TqICwyvJJpBwvGAMZjj4J2n0X8QWp21b9l0o7eXyVJ25YNWYbJDVIyD1bZXE6WtV6RmKJVYmQAKWa0zWOABz2w==}
    dependencies:
      '@types/mdast': 4.0.4
      unist-util-is: 6.0.0
    dev: false

  /mdast-util-to-hast@13.2.0:
    resolution: {integrity: sha512-QGYKEuUsYT9ykKBCMOEDLsU5JRObWQusAolFMeko/tYPufNkRffBAQjIE+99jbA87xv6FgmjLtwjh9wBWajwAA==}
    dependencies:
      '@types/hast': 3.0.4
      '@types/mdast': 4.0.4
      '@ungap/structured-clone': 1.2.0
      devlop: 1.1.0
      micromark-util-sanitize-uri: 2.0.0
      trim-lines: 3.0.1
      unist-util-position: 5.0.0
      unist-util-visit: 5.0.0
      vfile: 6.0.3
    dev: false

  /mdast-util-to-markdown@2.1.0:
    resolution: {integrity: sha512-SR2VnIEdVNCJbP6y7kVTJgPLifdr8WEU440fQec7qHoHOUz/oJ2jmNRqdDQ3rbiStOXb2mCDGTuwsK5OPUgYlQ==}
    dependencies:
      '@types/mdast': 4.0.4
      '@types/unist': 3.0.3
      longest-streak: 3.1.0
      mdast-util-phrasing: 4.1.0
      mdast-util-to-string: 4.0.0
      micromark-util-decode-string: 2.0.0
      unist-util-visit: 5.0.0
      zwitch: 2.0.4
    dev: false

  /mdast-util-to-string@4.0.0:
    resolution: {integrity: sha512-0H44vDimn51F0YwvxSJSm0eCDOJTRlmN0R1yBh4HLj9wiV1Dn0QoXGbvFAWj2hSItVTlCmBF1hqKlIyUBVFLPg==}
    dependencies:
      '@types/mdast': 4.0.4
    dev: false

  /memfs-browser@3.5.10302:
    resolution: {integrity: sha512-JJTc/nh3ig05O0gBBGZjTCPOyydaTxNF0uHYBrcc1gHNnO+KIHIvo0Y1FKCJsaei6FCl8C6xfQomXqu+cuzkIw==}
    requiresBuild: true
    dependencies:
      memfs: 3.5.3
    dev: false
    optional: true

  /memfs@3.5.3:
    resolution: {integrity: sha512-UERzLsxzllchadvbPs5aolHh65ISpKpM+ccLbOJ8/vvpBKmAWf+la7dXFy7Mr0ySHbdHrFv5kGFCUHHe6GFEmw==}
    engines: {node: '>= 4.0.0'}
    requiresBuild: true
    dependencies:
      fs-monkey: 1.0.6
    dev: false
    optional: true

  /merge-stream@2.0.0:
    resolution: {integrity: sha512-abv/qOcuPfk3URPfDzmZU1LKmuw8kT+0nIHvKrKgFrwifol/doWcdA4ZqsWQ8ENrFKkd67Mfpo/LovbIUsbt3w==}
    dev: false

  /merge2@1.4.1:
    resolution: {integrity: sha512-8q7VEgMJW4J8tcfVPy8g09NcQwZdbwFEqhe/WZkoIzjn/3TGDwtOCYtXGxA3O8tPzpczCCDgv+P2P5y00ZJOOg==}
    engines: {node: '>= 8'}
    dev: false

  /micromark-core-commonmark@2.0.1:
    resolution: {integrity: sha512-CUQyKr1e///ZODyD1U3xit6zXwy1a8q2a1S1HKtIlmgvurrEpaw/Y9y6KSIbF8P59cn/NjzHyO+Q2fAyYLQrAA==}
    dependencies:
      decode-named-character-reference: 1.0.2
      devlop: 1.1.0
      micromark-factory-destination: 2.0.0
      micromark-factory-label: 2.0.0
      micromark-factory-space: 2.0.0
      micromark-factory-title: 2.0.0
      micromark-factory-whitespace: 2.0.0
      micromark-util-character: 2.1.0
      micromark-util-chunked: 2.0.0
      micromark-util-classify-character: 2.0.0
      micromark-util-html-tag-name: 2.0.0
      micromark-util-normalize-identifier: 2.0.0
      micromark-util-resolve-all: 2.0.0
      micromark-util-subtokenize: 2.0.1
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-extension-gfm-autolink-literal@2.1.0:
    resolution: {integrity: sha512-oOg7knzhicgQ3t4QCjCWgTmfNhvQbDDnJeVu9v81r7NltNCVmhPy1fJRX27pISafdjL+SVc4d3l48Gb6pbRypw==}
    dependencies:
      micromark-util-character: 2.1.0
      micromark-util-sanitize-uri: 2.0.0
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-extension-gfm-footnote@2.1.0:
    resolution: {integrity: sha512-/yPhxI1ntnDNsiHtzLKYnE3vf9JZ6cAisqVDauhp4CEHxlb4uoOTxOCJ+9s51bIB8U1N1FJ1RXOKTIlD5B/gqw==}
    dependencies:
      devlop: 1.1.0
      micromark-core-commonmark: 2.0.1
      micromark-factory-space: 2.0.0
      micromark-util-character: 2.1.0
      micromark-util-normalize-identifier: 2.0.0
      micromark-util-sanitize-uri: 2.0.0
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-extension-gfm-strikethrough@2.1.0:
    resolution: {integrity: sha512-ADVjpOOkjz1hhkZLlBiYA9cR2Anf8F4HqZUO6e5eDcPQd0Txw5fxLzzxnEkSkfnD0wziSGiv7sYhk/ktvbf1uw==}
    dependencies:
      devlop: 1.1.0
      micromark-util-chunked: 2.0.0
      micromark-util-classify-character: 2.0.0
      micromark-util-resolve-all: 2.0.0
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-extension-gfm-table@2.1.0:
    resolution: {integrity: sha512-Ub2ncQv+fwD70/l4ou27b4YzfNaCJOvyX4HxXU15m7mpYY+rjuWzsLIPZHJL253Z643RpbcP1oeIJlQ/SKW67g==}
    dependencies:
      devlop: 1.1.0
      micromark-factory-space: 2.0.0
      micromark-util-character: 2.1.0
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-extension-gfm-tagfilter@2.0.0:
    resolution: {integrity: sha512-xHlTOmuCSotIA8TW1mDIM6X2O1SiX5P9IuDtqGonFhEK0qgRI4yeC6vMxEV2dgyr2TiD+2PQ10o+cOhdVAcwfg==}
    dependencies:
      micromark-util-types: 2.0.0
    dev: false

  /micromark-extension-gfm-task-list-item@2.1.0:
    resolution: {integrity: sha512-qIBZhqxqI6fjLDYFTBIa4eivDMnP+OZqsNwmQ3xNLE4Cxwc+zfQEfbs6tzAo2Hjq+bh6q5F+Z8/cksrLFYWQQw==}
    dependencies:
      devlop: 1.1.0
      micromark-factory-space: 2.0.0
      micromark-util-character: 2.1.0
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-extension-gfm@3.0.0:
    resolution: {integrity: sha512-vsKArQsicm7t0z2GugkCKtZehqUm31oeGBV/KVSorWSy8ZlNAv7ytjFhvaryUiCUJYqs+NoE6AFhpQvBTM6Q4w==}
    dependencies:
      micromark-extension-gfm-autolink-literal: 2.1.0
      micromark-extension-gfm-footnote: 2.1.0
      micromark-extension-gfm-strikethrough: 2.1.0
      micromark-extension-gfm-table: 2.1.0
      micromark-extension-gfm-tagfilter: 2.0.0
      micromark-extension-gfm-task-list-item: 2.1.0
      micromark-util-combine-extensions: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-factory-destination@2.0.0:
    resolution: {integrity: sha512-j9DGrQLm/Uhl2tCzcbLhy5kXsgkHUrjJHg4fFAeoMRwJmJerT9aw4FEhIbZStWN8A3qMwOp1uzHr4UL8AInxtA==}
    dependencies:
      micromark-util-character: 2.1.0
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-factory-label@2.0.0:
    resolution: {integrity: sha512-RR3i96ohZGde//4WSe/dJsxOX6vxIg9TimLAS3i4EhBAFx8Sm5SmqVfR8E87DPSR31nEAjZfbt91OMZWcNgdZw==}
    dependencies:
      devlop: 1.1.0
      micromark-util-character: 2.1.0
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-factory-space@2.0.0:
    resolution: {integrity: sha512-TKr+LIDX2pkBJXFLzpyPyljzYK3MtmllMUMODTQJIUfDGncESaqB90db9IAUcz4AZAJFdd8U9zOp9ty1458rxg==}
    dependencies:
      micromark-util-character: 2.1.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-factory-title@2.0.0:
    resolution: {integrity: sha512-jY8CSxmpWLOxS+t8W+FG3Xigc0RDQA9bKMY/EwILvsesiRniiVMejYTE4wumNc2f4UbAa4WsHqe3J1QS1sli+A==}
    dependencies:
      micromark-factory-space: 2.0.0
      micromark-util-character: 2.1.0
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-factory-whitespace@2.0.0:
    resolution: {integrity: sha512-28kbwaBjc5yAI1XadbdPYHX/eDnqaUFVikLwrO7FDnKG7lpgxnvk/XGRhX/PN0mOZ+dBSZ+LgunHS+6tYQAzhA==}
    dependencies:
      micromark-factory-space: 2.0.0
      micromark-util-character: 2.1.0
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-util-character@2.1.0:
    resolution: {integrity: sha512-KvOVV+X1yLBfs9dCBSopq/+G1PcgT3lAK07mC4BzXi5E7ahzMAF8oIupDDJ6mievI6F+lAATkbQQlQixJfT3aQ==}
    dependencies:
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-util-chunked@2.0.0:
    resolution: {integrity: sha512-anK8SWmNphkXdaKgz5hJvGa7l00qmcaUQoMYsBwDlSKFKjc6gjGXPDw3FNL3Nbwq5L8gE+RCbGqTw49FK5Qyvg==}
    dependencies:
      micromark-util-symbol: 2.0.0
    dev: false

  /micromark-util-classify-character@2.0.0:
    resolution: {integrity: sha512-S0ze2R9GH+fu41FA7pbSqNWObo/kzwf8rN/+IGlW/4tC6oACOs8B++bh+i9bVyNnwCcuksbFwsBme5OCKXCwIw==}
    dependencies:
      micromark-util-character: 2.1.0
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-util-combine-extensions@2.0.0:
    resolution: {integrity: sha512-vZZio48k7ON0fVS3CUgFatWHoKbbLTK/rT7pzpJ4Bjp5JjkZeasRfrS9wsBdDJK2cJLHMckXZdzPSSr1B8a4oQ==}
    dependencies:
      micromark-util-chunked: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-util-decode-numeric-character-reference@2.0.1:
    resolution: {integrity: sha512-bmkNc7z8Wn6kgjZmVHOX3SowGmVdhYS7yBpMnuMnPzDq/6xwVA604DuOXMZTO1lvq01g+Adfa0pE2UKGlxL1XQ==}
    dependencies:
      micromark-util-symbol: 2.0.0
    dev: false

  /micromark-util-decode-string@2.0.0:
    resolution: {integrity: sha512-r4Sc6leeUTn3P6gk20aFMj2ntPwn6qpDZqWvYmAG6NgvFTIlj4WtrAudLi65qYoaGdXYViXYw2pkmn7QnIFasA==}
    dependencies:
      decode-named-character-reference: 1.0.2
      micromark-util-character: 2.1.0
      micromark-util-decode-numeric-character-reference: 2.0.1
      micromark-util-symbol: 2.0.0
    dev: false

  /micromark-util-encode@2.0.0:
    resolution: {integrity: sha512-pS+ROfCXAGLWCOc8egcBvT0kf27GoWMqtdarNfDcjb6YLuV5cM3ioG45Ys2qOVqeqSbjaKg72vU+Wby3eddPsA==}
    dev: false

  /micromark-util-html-tag-name@2.0.0:
    resolution: {integrity: sha512-xNn4Pqkj2puRhKdKTm8t1YHC/BAjx6CEwRFXntTaRf/x16aqka6ouVoutm+QdkISTlT7e2zU7U4ZdlDLJd2Mcw==}
    dev: false

  /micromark-util-normalize-identifier@2.0.0:
    resolution: {integrity: sha512-2xhYT0sfo85FMrUPtHcPo2rrp1lwbDEEzpx7jiH2xXJLqBuy4H0GgXk5ToU8IEwoROtXuL8ND0ttVa4rNqYK3w==}
    dependencies:
      micromark-util-symbol: 2.0.0
    dev: false

  /micromark-util-resolve-all@2.0.0:
    resolution: {integrity: sha512-6KU6qO7DZ7GJkaCgwBNtplXCvGkJToU86ybBAUdavvgsCiG8lSSvYxr9MhwmQ+udpzywHsl4RpGJsYWG1pDOcA==}
    dependencies:
      micromark-util-types: 2.0.0
    dev: false

  /micromark-util-sanitize-uri@2.0.0:
    resolution: {integrity: sha512-WhYv5UEcZrbAtlsnPuChHUAsu/iBPOVaEVsntLBIdpibO0ddy8OzavZz3iL2xVvBZOpolujSliP65Kq0/7KIYw==}
    dependencies:
      micromark-util-character: 2.1.0
      micromark-util-encode: 2.0.0
      micromark-util-symbol: 2.0.0
    dev: false

  /micromark-util-subtokenize@2.0.1:
    resolution: {integrity: sha512-jZNtiFl/1aY73yS3UGQkutD0UbhTt68qnRpw2Pifmz5wV9h8gOVsN70v+Lq/f1rKaU/W8pxRe8y8Q9FX1AOe1Q==}
    dependencies:
      devlop: 1.1.0
      micromark-util-chunked: 2.0.0
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
    dev: false

  /micromark-util-symbol@2.0.0:
    resolution: {integrity: sha512-8JZt9ElZ5kyTnO94muPxIGS8oyElRJaiJO8EzV6ZSyGQ1Is8xwl4Q45qU5UOg+bGH4AikWziz0iN4sFLWs8PGw==}
    dev: false

  /micromark-util-types@2.0.0:
    resolution: {integrity: sha512-oNh6S2WMHWRZrmutsRmDDfkzKtxF+bc2VxLC9dvtrDIRFln627VsFP6fLMgTryGDljgLPjkrzQSDcPrjPyDJ5w==}
    dev: false

  /micromark@4.0.0:
    resolution: {integrity: sha512-o/sd0nMof8kYff+TqcDx3VSrgBTcZpSvYcAHIfHhv5VAuNmisCxjhx6YmxS8PFEpb9z5WKWKPdzf0jM23ro3RQ==}
    dependencies:
      '@types/debug': 4.1.12
      debug: 4.3.7
      decode-named-character-reference: 1.0.2
      devlop: 1.1.0
      micromark-core-commonmark: 2.0.1
      micromark-factory-space: 2.0.0
      micromark-util-character: 2.1.0
      micromark-util-chunked: 2.0.0
      micromark-util-combine-extensions: 2.0.0
      micromark-util-decode-numeric-character-reference: 2.0.1
      micromark-util-encode: 2.0.0
      micromark-util-normalize-identifier: 2.0.0
      micromark-util-resolve-all: 2.0.0
      micromark-util-sanitize-uri: 2.0.0
      micromark-util-subtokenize: 2.0.1
      micromark-util-symbol: 2.0.0
      micromark-util-types: 2.0.0
    transitivePeerDependencies:
      - supports-color
    dev: false

  /micromatch@4.0.8:
    resolution: {integrity: sha512-PXwfBhYu0hBCPw8Dn0E+WDYb7af3dSLVWKi3HGv84IdF4TyFoC0ysxFd0Goxw7nSv4T/PzEJQxsYsEiFCKo2BA==}
    engines: {node: '>=8.6'}
    dependencies:
      braces: 3.0.3
      picomatch: 2.3.1
    dev: false

  /mimic-fn@4.0.0:
    resolution: {integrity: sha512-vqiC06CuhBTUdZH+RYl8sFrL096vA45Ok5ISO6sE/Mr1jRbGH4Csnhi8f3wKVl7x8mO4Au7Ir9D3Oyv1VYMFJw==}
    engines: {node: '>=12'}
    dev: false

  /mimic-function@5.0.1:
    resolution: {integrity: sha512-VP79XUPxV2CigYP3jWwAUFSku2aKqBH7uTAapFWCBqutsbmDo96KY5o8uh6U+/YSIn5OxJnXp73beVkpqMIGhA==}
    engines: {node: '>=18'}
    dev: false

  /mimic-response@3.1.0:
    resolution: {integrity: sha512-z0yWI+4FDrrweS8Zmt4Ej5HdJmky15+L2e6Wgn3+iK5fWzb6T3fhNFq2+MeTRb064c6Wr4N/wv0DzQTjNzHNGQ==}
    engines: {node: '>=10'}
    dev: false

  /minimatch@9.0.5:
    resolution: {integrity: sha512-G6T0ZX48xgozx7587koeX9Ys2NYy6Gmv//P89sEte9V9whIapMNF4idKxnW2QtCcLiTWlb/wfCabAtAFWhhBow==}
    engines: {node: '>=16 || 14 >=14.17'}
    dependencies:
      brace-expansion: 2.0.1
    dev: false

  /minimist@1.2.8:
    resolution: {integrity: sha512-2yyAR8qBkN3YuheJanUpWC5U3bb5osDywNB8RzDVlDwDHbocAJveqqj1u8+SVD7jkWT4yvsHCpWqqWqAxb0zCA==}
    dev: false

  /minipass@3.3.6:
    resolution: {integrity: sha512-DxiNidxSEK+tHG6zOIklvNOwm3hvCrbUrdtzY74U6HKTJxvIDfOUL5W5P2Ghd3DTkhhKPYGqeNUIh5qcM4YBfw==}
    engines: {node: '>=8'}
    dependencies:
      yallist: 4.0.0
    dev: false

  /minipass@5.0.0:
    resolution: {integrity: sha512-3FnjYuehv9k6ovOEbyOswadCDPX1piCfhV8ncmYtHOjuPwylVWsghTLo7rabjC3Rx5xD4HDx8Wm1xnMF7S5qFQ==}
    engines: {node: '>=8'}
    dev: false

  /minipass@7.1.2:
    resolution: {integrity: sha512-qOOzS1cBTWYF4BH8fVePDBOO9iptMnGUEZwNc/cMWnTV2nVLZ7VoNWEPHkYczZA0pdoA7dl6e7FL659nX9S2aw==}
    engines: {node: '>=16 || 14 >=14.17'}
    dev: false

  /minizlib@2.1.2:
    resolution: {integrity: sha512-bAxsR8BVfj60DWXHE3u30oHzfl4G7khkSuPW+qvpd7jFRHm7dLxOjUk1EHACJ/hxLY8phGJ0YhYHZo7jil7Qdg==}
    engines: {node: '>= 8'}
    dependencies:
      minipass: 3.3.6
      yallist: 4.0.0
    dev: false

  /mkdirp-classic@0.5.3:
    resolution: {integrity: sha512-gKLcREMhtuZRwRAfqP3RFW+TK4JqApVBtOIftVgjuABpAtpxhPGaDcfvbhNvD0B8iD1oUr/txX35NjcaY6Ns/A==}
    dev: false

  /mkdirp@1.0.4:
    resolution: {integrity: sha512-vVqVZQyf3WLx2Shd0qJ9xuvqgAyKPLAiqITEtqW0oIUjzo3PePDd6fW9iFz30ef7Ysp/oiWqbhszeGWW2T6Gzw==}
    engines: {node: '>=10'}
    hasBin: true
    dev: false

  /mkdirp@3.0.1:
    resolution: {integrity: sha512-+NsyUUAZDmo6YVHzL/stxSu3t9YS1iljliy3BSDrXJ/dkn1KYdmtZODGGjLcc9XLgVVpH4KshHB8XmZgMhaBXg==}
    engines: {node: '>=10'}
    hasBin: true
    dev: false

  /mlly@1.7.1:
    resolution: {integrity: sha512-rrVRZRELyQzrIUAVMHxP97kv+G786pHmOKzuFII8zDYahFBS7qnHh2AlYSl1GAHhaMPCz6/oHjVMcfFYgFYHgA==}
    dependencies:
      acorn: 8.12.1
      pathe: 1.1.2
      pkg-types: 1.2.0
      ufo: 1.5.4
    dev: false

  /mrmime@2.0.0:
    resolution: {integrity: sha512-eu38+hdgojoyq63s+yTpN4XMBdt5l8HhMhc4VKLO9KM5caLIBvUm4thi7fFaxyTmCKeNnXZ5pAlBwCUnhA09uw==}
    engines: {node: '>=10'}
    dev: false

  /ms@2.1.3:
    resolution: {integrity: sha512-6FlzubTLZG3J2a/NVCAleEhjzq5oxgHyaCU9yYXvcLsvoVaHJq/s5xXI6/XXP6tz7R9xAOtHnSO/tXtF3WRTlA==}
    dev: false

  /muggle-string@0.4.1:
    resolution: {integrity: sha512-VNTrAak/KhO2i8dqqnqnAHOa3cYBwXEZe9h+D5h/1ZqFSTEFHdM65lR7RoIqq3tBBYavsOXV84NoHXZ0AkPyqQ==}
    dev: false

  /mysql2@3.11.3:
    resolution: {integrity: sha512-Qpu2ADfbKzyLdwC/5d4W7+5Yz7yBzCU05YWt5npWzACST37wJsB23wgOSo00qi043urkiRwXtEvJc9UnuLX/MQ==}
    engines: {node: '>= 8.0'}
    dependencies:
      aws-ssl-profiles: 1.1.2
      denque: 2.1.0
      generate-function: 2.3.1
      iconv-lite: 0.6.3
      long: 5.2.3
      lru.min: 1.1.1
      named-placeholders: 1.1.3
      seq-queue: 0.0.5
      sqlstring: 2.3.3
    dev: false

  /mz@2.7.0:
    resolution: {integrity: sha512-z81GNO7nnYMEhrGh9LeymoE4+Yr0Wn5McHIZMK5cfQCl+NDX08sCZgUc9/6MHni9IWuFLm1Z3HTCXu2z9fN62Q==}
    dependencies:
      any-promise: 1.3.0
      object-assign: 4.1.1
      thenify-all: 1.6.0
    dev: false

  /named-placeholders@1.1.3:
    resolution: {integrity: sha512-eLoBxg6wE/rZkJPhU/xRX1WTpkFEwDJEN96oxFrTsqBdbT5ec295Q+CoHrL9IT0DipqKhmGcaZmwOt8OON5x1w==}
    engines: {node: '>=12.0.0'}
    dependencies:
      lru-cache: 7.18.3
    dev: false

  /nanoassert@1.1.0:
    resolution: {integrity: sha512-C40jQ3NzfkP53NsO8kEOFd79p4b9kDXQMwgiY1z8ZwrDZgUyom0AHwGegF4Dm99L+YoYhuaB0ceerUcXmqr1rQ==}
    dev: false

  /nanoevents@9.0.0:
    resolution: {integrity: sha512-X8pU7IOpgKXVLPxYUI55ymXc8XuBE+uypfEyEFBtHkD1EX9KavYTVc+vXZHFyHKzA1TaZoVDqklLdQBBrxIuAw==}
    engines: {node: ^18.0.0 || >=20.0.0}
    dev: false

  /nanoid@3.3.7:
    resolution: {integrity: sha512-eSRppjcPIatRIMC1U6UngP8XFcz8MQWGQdt1MTBQ7NaAmvXDfvNxbvWV3x2y6CdEUciCSsDHDQZbhYaB8QEo2g==}
    engines: {node: ^10 || ^12 || ^13.7 || ^14 || >=15.0.1}
    hasBin: true
    dev: false

  /nanoquery@1.3.0:
    resolution: {integrity: sha512-eZv8Ct2PZn/CdOmD2BgLNwjhhPmxg4tXhygp0roaRer5RqBFB0gm0wHIb5VZcL0CS0r+yWQ1kBVYG7S1jUyG0A==}
    dependencies:
      nanoassert: 1.1.0
    dev: false

  /nanostores@0.11.3:
    resolution: {integrity: sha512-TUes3xKIX33re4QzdxwZ6tdbodjmn3tWXCEc1uokiEmo14sI1EaGYNs2k3bU2pyyGNmBqFGAVl6jAGWd06AVIg==}
    engines: {node: ^18.0.0 || >=20.0.0}
    dev: false

  /napi-build-utils@1.0.2:
    resolution: {integrity: sha512-ONmRUqK7zj7DWX0D9ADe03wbwOBZxNAfF20PlGfCWQcD3+/MakShIHrMqx9YwPTfxDdF1zLeL+RGZiR9kGMLdg==}
    dev: false

  /neotraverse@0.6.18:
    resolution: {integrity: sha512-Z4SmBUweYa09+o6pG+eASabEpP6QkQ70yHj351pQoEXIs8uHbaU2DWVmzBANKgflPa47A50PtB2+NgRpQvr7vA==}
    engines: {node: '>= 10'}
    dev: false

  /nlcst-to-string@4.0.0:
    resolution: {integrity: sha512-YKLBCcUYKAg0FNlOBT6aI91qFmSiFKiluk655WzPF+DDMA02qIyy8uiRqI8QXtcFpEvll12LpL5MXqEmAZ+dcA==}
    dependencies:
      '@types/nlcst': 2.0.3
    dev: false

  /node-abi@3.68.0:
    resolution: {integrity: sha512-7vbj10trelExNjFSBm5kTvZXXa7pZyKWx9RCKIyqe6I9Ev3IzGpQoqBP3a+cOdxY+pWj6VkP28n/2wWysBHD/A==}
    engines: {node: '>=10'}
    dependencies:
      semver: 7.6.3
    dev: false

  /node-fetch-native@1.6.4:
    resolution: {integrity: sha512-IhOigYzAKHd244OC0JIMIUrjzctirCmPkaIfhDeGcEETWof5zKYUW7e7MYvChGWh/4CJeXEgsRyGzuF334rOOQ==}
    dev: false

  /node-fetch@2.7.0:
    resolution: {integrity: sha512-c4FRfUm/dbcWZ7U+1Wq0AwCyFL+3nt2bEw05wfxSz+DWpWsitgmSgYmy2dQdWyKC1694ELPqMs/YzUSNozLt8A==}
    engines: {node: 4.x || >=6.0.0}
    peerDependencies:
      encoding: ^0.1.0
    peerDependenciesMeta:
      encoding:
        optional: true
    dependencies:
      whatwg-url: 5.0.0
    dev: false

  /node-releases@2.0.18:
    resolution: {integrity: sha512-d9VeXT4SJ7ZeOqGX6R5EM022wpL+eWPooLI+5UpWn2jCT1aosUQEhQP214x33Wkwx3JQMvIm+tIoVOdodFS40g==}
    dev: false

  /normalize-path@3.0.0:
    resolution: {integrity: sha512-6eZs5Ls3WtCisHWp9S2GUy8dqkpGi4BVSz3GaqiE6ezub0512ESztXUwUB6C6IKbQkY2Pnb/mD4WYojCRwcwLA==}
    engines: {node: '>=0.10.0'}
    dev: false

  /normalize-range@0.1.2:
    resolution: {integrity: sha512-bdok/XvKII3nUpklnV6P2hxtMNrCboOjAcyBuQnWEhO665FwrSNRxU+AqpsyvO6LgGYPspN+lu5CLtw4jPRKNA==}
    engines: {node: '>=0.10.0'}
    dev: false

  /npm-run-path@5.3.0:
    resolution: {integrity: sha512-ppwTtiJZq0O/ai0z7yfudtBpWIoxM8yE6nHi1X47eFR2EWORqfbu6CnPlNsjeN683eT0qG6H/Pyf9fCcvjnnnQ==}
    engines: {node: ^12.20.0 || ^14.13.1 || >=16.0.0}
    dependencies:
      path-key: 4.0.0
    dev: false

  /nypm@0.3.11:
    resolution: {integrity: sha512-E5GqaAYSnbb6n1qZyik2wjPDZON43FqOJO59+3OkWrnmQtjggrMOVnsyzfjxp/tS6nlYJBA4zRA5jSM2YaadMg==}
    engines: {node: ^14.16.0 || >=16.10.0}
    hasBin: true
    dependencies:
      citty: 0.1.6
      consola: 3.2.3
      execa: 8.0.1
      pathe: 1.1.2
      pkg-types: 1.2.0
      ufo: 1.5.4
    dev: false

  /oauth4webapi@2.17.0:
    resolution: {integrity: sha512-lbC0Z7uzAFNFyzEYRIC+pkSVvDHJTbEW+dYlSBAlCYDe6RxUkJ26bClhk8ocBZip1wfI9uKTe0fm4Ib4RHn6uQ==}
    dev: false

  /object-assign@4.1.1:
    resolution: {integrity: sha512-rJgTQnkUnH1sFw8yT6VSU3zD3sWmu6sZhIseY8VX+GRu3P6F7Fu+JNDoXfklElbLJSnc3FUQHVe4cU5hj+BcUg==}
    engines: {node: '>=0.10.0'}
    dev: false

  /object-hash@3.0.0:
    resolution: {integrity: sha512-RSn9F68PjH9HqtltsSnqYC1XXoWe9Bju5+213R98cNGttag9q9yAOTzdbsqvIa7aNm5WffBZFpWYr2aWrklWAw==}
    engines: {node: '>= 6'}
    dev: false

  /ohash@1.1.4:
    resolution: {integrity: sha512-FlDryZAahJmEF3VR3w1KogSEdWX3WhA5GPakFx4J81kEAiHyLMpdLLElS8n8dfNadMgAne/MywcvmogzscVt4g==}
    dev: false

  /once@1.4.0:
    resolution: {integrity: sha512-lNaJgI+2Q5URQBkccEKHTQOPaXdUxnZZElQTZY0MFUAuaEqe1E+Nyvgdz/aIyNi6Z9MzO5dv1H8n58/GELp3+w==}
    dependencies:
      wrappy: 1.0.2
    dev: false

  /onetime@6.0.0:
    resolution: {integrity: sha512-1FlR+gjXK7X+AsAHso35MnyN5KqGwJRi/31ft6x0M194ht7S+rWAvd7PHss9xSKMzE0asv1pyIHaJYq+BbacAQ==}
    engines: {node: '>=12'}
    dependencies:
      mimic-fn: 4.0.0
    dev: false

  /onetime@7.0.0:
    resolution: {integrity: sha512-VXJjc87FScF88uafS3JllDgvAm+c/Slfz06lorj2uAY34rlUu0Nt+v8wreiImcrgAjjIHp1rXpTDlLOGw29WwQ==}
    engines: {node: '>=18'}
    dependencies:
      mimic-function: 5.0.1
    dev: false

  /oniguruma-to-js@0.4.3:
    resolution: {integrity: sha512-X0jWUcAlxORhOqqBREgPMgnshB7ZGYszBNspP+tS9hPD3l13CdaXcHbgImoHUHlrvGx/7AvFEkTRhAGYh+jzjQ==}
    dependencies:
      regex: 4.3.2
    dev: false

  /ora@8.1.0:
    resolution: {integrity: sha512-GQEkNkH/GHOhPFXcqZs3IDahXEQcQxsSjEkK4KvEEST4t7eNzoMjxTzef+EZ+JluDEV+Raoi3WQ2CflnRdSVnQ==}
    engines: {node: '>=18'}
    dependencies:
      chalk: 5.3.0
      cli-cursor: 5.0.0
      cli-spinners: 2.9.2
      is-interactive: 2.0.0
      is-unicode-supported: 2.1.0
      log-symbols: 6.0.0
      stdin-discarder: 0.2.2
      string-width: 7.2.0
      strip-ansi: 7.1.0
    dev: false

  /oslo@1.2.1:
    resolution: {integrity: sha512-HfIhB5ruTdQv0XX2XlncWQiJ5SIHZ7NHZhVyHth0CSZ/xzge00etRyYy/3wp/Dsu+PkxMC+6+B2lS/GcKoewkA==}
    dependencies:
      '@node-rs/argon2': 1.7.0
      '@node-rs/bcrypt': 1.9.0
    dev: false

  /p-limit@2.3.0:
    resolution: {integrity: sha512-//88mFWSJx8lxCzwdAABTJL2MyWB12+eIY7MDL2SqLmAkeKU9qxRvWuSyTjm3FUmpBEMuFfckAIqEaVGUDxb6w==}
    engines: {node: '>=6'}
    dependencies:
      p-try: 2.2.0
    dev: false

  /p-limit@6.1.0:
    resolution: {integrity: sha512-H0jc0q1vOzlEk0TqAKXKZxdl7kX3OFUzCnNVUnq5Pc3DGo0kpeaMuPqxQn235HibwBEb0/pm9dgKTjXy66fBkg==}
    engines: {node: '>=18'}
    dependencies:
      yocto-queue: 1.1.1
    dev: false

  /p-locate@4.1.0:
    resolution: {integrity: sha512-R79ZZ/0wAxKGu3oYMlz8jy/kbhsNrS7SKZ7PxEHBgJ5+F2mtFW2fK2cOtBh1cHYkQsbzFV7I+EoRKe6Yt0oK7A==}
    engines: {node: '>=8'}
    dependencies:
      p-limit: 2.3.0
    dev: false

  /p-queue@8.0.1:
    resolution: {integrity: sha512-NXzu9aQJTAzbBqOt2hwsR63ea7yvxJc0PwN/zobNAudYfb1B7R08SzB4TsLeSbUCuG467NhnoT0oO6w1qRO+BA==}
    engines: {node: '>=18'}
    dependencies:
      eventemitter3: 5.0.1
      p-timeout: 6.1.2
    dev: false

  /p-timeout@6.1.2:
    resolution: {integrity: sha512-UbD77BuZ9Bc9aABo74gfXhNvzC9Tx7SxtHSh1fxvx3jTLLYvmVhiQZZrJzqqU0jKbN32kb5VOKiLEQI/3bIjgQ==}
    engines: {node: '>=14.16'}
    dev: false

  /p-try@2.2.0:
    resolution: {integrity: sha512-R4nPAVTAU0B9D35/Gk3uJf/7XYbQcyohSKdvAxIRSNghFl4e71hVoGnBNQz9cWaXxO2I10KTC+3jMdvvoKw6dQ==}
    engines: {node: '>=6'}
    dev: false

  /package-json-from-dist@1.0.0:
    resolution: {integrity: sha512-dATvCeZN/8wQsGywez1mzHtTlP22H8OEfPrVMLNr4/eGa+ijtLn/6M5f0dY8UKNrC2O9UCU6SSoG3qRKnt7STw==}
    dev: false

  /parse-latin@7.0.0:
    resolution: {integrity: sha512-mhHgobPPua5kZ98EF4HWiH167JWBfl4pvAIXXdbaVohtK7a6YBOy56kvhCqduqyo/f3yrHFWmqmiMg/BkBkYYQ==}
    dependencies:
      '@types/nlcst': 2.0.3
      '@types/unist': 3.0.3
      nlcst-to-string: 4.0.0
      unist-util-modify-children: 4.0.0
      unist-util-visit-children: 3.0.0
      vfile: 6.0.3
    dev: false

  /parse5@7.1.2:
    resolution: {integrity: sha512-Czj1WaSVpaoj0wbhMzLmWD69anp2WH7FXMB9n1Sy8/ZFF9jolSQVMu1Ij5WIyGmcBmhk7EOndpO4mIpihVqAXw==}
    dependencies:
      entities: 4.5.0
    dev: false

  /path-browserify@1.0.1:
    resolution: {integrity: sha512-b7uo2UCUOYZcnF/3ID0lulOJi/bafxa1xPe7ZPsammBSpjSWQkjNxlt635YGS2MiR9GjvuXCtz2emr3jbsz98g==}
    dev: false

  /path-exists@4.0.0:
    resolution: {integrity: sha512-ak9Qy5Q7jYb2Wwcey5Fpvg2KoAc/ZIhLSLOSBmRmygPsGwkVVt0fZa0qrtMz+m6tJTAHfZQ8FnmB4MG4LWy7/w==}
    engines: {node: '>=8'}
    dev: false

  /path-key@3.1.1:
    resolution: {integrity: sha512-ojmeN0qd+y0jszEtoY48r0Peq5dwMEkIlCOu6Q5f41lfkswXuKtYrhgoTpLnyIcHm24Uhqx+5Tqm2InSwLhE6Q==}
    engines: {node: '>=8'}
    dev: false

  /path-key@4.0.0:
    resolution: {integrity: sha512-haREypq7xkM7ErfgIyA0z+Bj4AGKlMSdlQE2jvJo6huWD1EdkKYV+G/T4nq0YEF2vgTT8kqMFKo1uHn950r4SQ==}
    engines: {node: '>=12'}
    dev: false

  /path-parse@1.0.7:
    resolution: {integrity: sha512-LDJzPVEEEPR+y48z93A0Ed0yXb8pAByGWo/k5YYdYgpY2/2EsOsksJrq7lOHxryrVOn1ejG6oAp8ahvOIQD8sw==}
    dev: false

  /path-scurry@1.11.1:
    resolution: {integrity: sha512-Xa4Nw17FS9ApQFJ9umLiJS4orGjm7ZzwUrwamcGQuHSzDyth9boKDaycYdDcZDuqYATXw4HFXgaqWTctW/v1HA==}
    engines: {node: '>=16 || 14 >=14.18'}
    dependencies:
      lru-cache: 10.4.3
      minipass: 7.1.2
    dev: false

  /pathe@1.1.2:
    resolution: {integrity: sha512-whLdWMYL2TwI08hn8/ZqAbrVemu0LNaNNJZX73O6qaIdCTfXutsLhMkjdENX0qhsQ9uIimo4/aQOmXkoon2nDQ==}
    dev: false

  /perfect-debounce@1.0.0:
    resolution: {integrity: sha512-xCy9V055GLEqoFaHoC1SoLIaLmWctgCUaBaWxDZ7/Zx4CTyX7cJQLJOok/orfjZAh9kEYpjJa4d0KcJmCbctZA==}
    dev: false

  /pg-cloudflare@1.1.1:
    resolution: {integrity: sha512-xWPagP/4B6BgFO+EKz3JONXv3YDgvkbVrGw2mTo3D6tVDQRh1e7cqVGvyR3BE+eQgAvx1XhW/iEASj4/jCWl3Q==}
    requiresBuild: true
    dev: false
    optional: true

  /pg-connection-string@2.7.0:
    resolution: {integrity: sha512-PI2W9mv53rXJQEOb8xNR8lH7Hr+EKa6oJa38zsK0S/ky2er16ios1wLKhZyxzD7jUReiWokc9WK5nxSnC7W1TA==}
    dev: false

  /pg-int8@1.0.1:
    resolution: {integrity: sha512-WCtabS6t3c8SkpDBUlb1kjOs7l66xsGdKpIPZsg4wR+B3+u9UAum2odSsF9tnvxg80h4ZxLWMy4pRjOsFIqQpw==}
    engines: {node: '>=4.0.0'}
    dev: false

  /pg-pool@3.7.0(pg@8.13.0):
    resolution: {integrity: sha512-ZOBQForurqh4zZWjrgSwwAtzJ7QiRX0ovFkZr2klsen3Nm0aoh33Ls0fzfv3imeH/nw/O27cjdz5kzYJfeGp/g==}
    peerDependencies:
      pg: '>=8.0'
    dependencies:
      pg: 8.13.0
    dev: false

  /pg-protocol@1.7.0:
    resolution: {integrity: sha512-hTK/mE36i8fDDhgDFjy6xNOG+LCorxLG3WO17tku+ij6sVHXh1jQUJ8hYAnRhNla4QVD2H8er/FOjc/+EgC6yQ==}
    dev: false

  /pg-types@2.2.0:
    resolution: {integrity: sha512-qTAAlrEsl8s4OiEQY69wDvcMIdQN6wdz5ojQiOy6YRMuynxenON0O5oCpJI6lshc6scgAY8qvJ2On/p+CXY0GA==}
    engines: {node: '>=4'}
    dependencies:
      pg-int8: 1.0.1
      postgres-array: 2.0.0
      postgres-bytea: 1.0.0
      postgres-date: 1.0.7
      postgres-interval: 1.2.0
    dev: false

  /pg@8.13.0:
    resolution: {integrity: sha512-34wkUTh3SxTClfoHB3pQ7bIMvw9dpFU1audQQeZG837fmHfHpr14n/AELVDoOYVDW2h5RDWU78tFjkD+erSBsw==}
    engines: {node: '>= 8.0.0'}
    peerDependencies:
      pg-native: '>=3.0.1'
    peerDependenciesMeta:
      pg-native:
        optional: true
    dependencies:
      pg-connection-string: 2.7.0
      pg-pool: 3.7.0(pg@8.13.0)
      pg-protocol: 1.7.0
      pg-types: 2.2.0
      pgpass: 1.0.5
    optionalDependencies:
      pg-cloudflare: 1.1.1
    dev: false

  /pgpass@1.0.5:
    resolution: {integrity: sha512-FdW9r/jQZhSeohs1Z3sI1yxFQNFvMcnmfuj4WBMUTxOrAyLMaTcE1aAMBiTlbMNaXvBCQuVi0R7hd8udDSP7ug==}
    dependencies:
      split2: 4.2.0
    dev: false

  /picocolors@1.1.0:
    resolution: {integrity: sha512-TQ92mBOW0l3LeMeyLV6mzy/kWr8lkd/hp3mTg7wYK7zJhuBStmGMBG0BdeDZS/dZx1IukaX6Bk11zcln25o1Aw==}
    dev: false

  /picomatch@2.3.1:
    resolution: {integrity: sha512-JU3teHTNjmE2VCGFzuY8EXzCDVwEqB2a8fsIvwaStHhAWJEeVd1o1QD80CU6+ZdEXXSLbSsuLwJjkCBWqRQUVA==}
    engines: {node: '>=8.6'}
    dev: false

  /pify@2.3.0:
    resolution: {integrity: sha512-udgsAY+fTnvv7kI7aaxbqwWNb0AHiB0qBO89PZKPkoTmGOgdbrHDKD+0B2X4uTfJ/FT1R09r9gTsjUjNJotuog==}
    engines: {node: '>=0.10.0'}
    dev: false

  /pify@4.0.1:
    resolution: {integrity: sha512-uB80kBFb/tfd68bVleG9T5GGsGPjJrLAUpR5PZIrhBnIaRTQRjqdJSsIKkOP6OAIFbj7GOrcudc5pNjZ+geV2g==}
    engines: {node: '>=6'}
    dev: false

  /pirates@4.0.6:
    resolution: {integrity: sha512-saLsH7WeYYPiD25LDuLRRY/i+6HaPYr6G1OUlN39otzkSTxKnubR9RTxS3/Kk50s1g2JTgFwWQDQyplC5/SHZg==}
    engines: {node: '>= 6'}
    dev: false

  /pkg-dir@4.2.0:
    resolution: {integrity: sha512-HRDzbaKjC+AOWVXxAU/x54COGeIv9eb+6CkDSQoNTt4XyWoIJvuPsXizxu/Fr23EiekbtZwmh1IcIG/l/a10GQ==}
    engines: {node: '>=8'}
    dependencies:
      find-up: 4.1.0
    dev: false

  /pkg-types@1.2.0:
    resolution: {integrity: sha512-+ifYuSSqOQ8CqP4MbZA5hDpb97n3E8SVWdJe+Wms9kj745lmd3b7EZJiqvmLwAlmRfjrI7Hi5z3kdBJ93lFNPA==}
    dependencies:
      confbox: 0.1.7
      mlly: 1.7.1
      pathe: 1.1.2
    dev: false

  /postcss-import@15.1.0(postcss@8.4.47):
    resolution: {integrity: sha512-hpr+J05B2FVYUAXHeK1YyI267J/dDDhMU6B6civm8hSY1jYJnBXxzKDKDswzJmtLHryrjhnDjqqp/49t8FALew==}
    engines: {node: '>=14.0.0'}
    peerDependencies:
      postcss: ^8.0.0
    dependencies:
      postcss: 8.4.47
      postcss-value-parser: 4.2.0
      read-cache: 1.0.0
      resolve: 1.22.8
    dev: false

  /postcss-js@4.0.1(postcss@8.4.47):
    resolution: {integrity: sha512-dDLF8pEO191hJMtlHFPRa8xsizHaM82MLfNkUHdUtVEV3tgTp5oj+8qbEqYM57SLfc74KSbw//4SeJma2LRVIw==}
    engines: {node: ^12 || ^14 || >= 16}
    peerDependencies:
      postcss: ^8.4.21
    dependencies:
      camelcase-css: 2.0.1
      postcss: 8.4.47
    dev: false

  /postcss-load-config@4.0.2(postcss@8.4.47):
    resolution: {integrity: sha512-bSVhyJGL00wMVoPUzAVAnbEoWyqRxkjv64tUl427SKnPrENtq6hJwUojroMz2VB+Q1edmi4IfrAPpami5VVgMQ==}
    engines: {node: '>= 14'}
    peerDependencies:
      postcss: '>=8.0.9'
      ts-node: '>=9.0.0'
    peerDependenciesMeta:
      postcss:
        optional: true
      ts-node:
        optional: true
    dependencies:
      lilconfig: 3.1.2
      postcss: 8.4.47
      yaml: 2.5.1
    dev: false

  /postcss-nested@6.2.0(postcss@8.4.47):
    resolution: {integrity: sha512-HQbt28KulC5AJzG+cZtj9kvKB93CFCdLvog1WFLf1D+xmMvPGlBstkpTEZfK5+AN9hfJocyBFCNiqyS48bpgzQ==}
    engines: {node: '>=12.0'}
    peerDependencies:
      postcss: ^8.2.14
    dependencies:
      postcss: 8.4.47
      postcss-selector-parser: 6.1.2
    dev: false

  /postcss-selector-parser@6.1.2:
    resolution: {integrity: sha512-Q8qQfPiZ+THO/3ZrOrO0cJJKfpYCagtMUkXbnEfmgUjwXg6z/WBeOyS9APBBPCTSiDV+s4SwQGu8yFsiMRIudg==}
    engines: {node: '>=4'}
    dependencies:
      cssesc: 3.0.0
      util-deprecate: 1.0.2
    dev: false

  /postcss-value-parser@4.2.0:
    resolution: {integrity: sha512-1NNCs6uurfkVbeXG4S8JFT9t19m45ICnif8zWLd5oPSZ50QnwMfK+H3jv408d4jw/7Bttv5axS5IiHoLaVNHeQ==}
    dev: false

  /postcss@8.4.47:
    resolution: {integrity: sha512-56rxCq7G/XfB4EkXq9Egn5GCqugWvDFjafDOThIdMBsI15iqPqR5r15TfSr1YPYeEI19YeaXMCbY6u88Y76GLQ==}
    engines: {node: ^10 || ^12 || >=14}
    dependencies:
      nanoid: 3.3.7
      picocolors: 1.1.0
      source-map-js: 1.2.1
    dev: false

  /postgres-array@2.0.0:
    resolution: {integrity: sha512-VpZrUqU5A69eQyW2c5CA1jtLecCsN2U/bD6VilrFDWq5+5UIEVO7nazS3TEcHf1zuPYO/sqGvUvW62g86RXZuA==}
    engines: {node: '>=4'}
    dev: false

  /postgres-bytea@1.0.0:
    resolution: {integrity: sha512-xy3pmLuQqRBZBXDULy7KbaitYqLcmxigw14Q5sj8QBVLqEwXfeybIKVWiqAXTlcvdvb0+xkOtDbfQMOf4lST1w==}
    engines: {node: '>=0.10.0'}
    dev: false

  /postgres-date@1.0.7:
    resolution: {integrity: sha512-suDmjLVQg78nMK2UZ454hAG+OAW+HQPZ6n++TNDUX+L0+uUlLywnoxJKDou51Zm+zTCjrCl0Nq6J9C5hP9vK/Q==}
    engines: {node: '>=0.10.0'}
    dev: false

  /postgres-interval@1.2.0:
    resolution: {integrity: sha512-9ZhXKM/rw350N1ovuWHbGxnGh/SNJ4cnxHiM0rxE4VN41wsg8P8zWn9hv/buK00RP4WvlOyr/RBDiptyxVbkZQ==}
    engines: {node: '>=0.10.0'}
    dependencies:
      xtend: 4.0.2
    dev: false

  /postgres@3.4.4:
    resolution: {integrity: sha512-IbyN+9KslkqcXa8AO9fxpk97PA4pzewvpi2B3Dwy9u4zpV32QicaEdgmF3eSQUzdRk7ttDHQejNgAEr4XoeH4A==}
    engines: {node: '>=12'}
    dev: false

  /prebuild-install@7.1.2:
    resolution: {integrity: sha512-UnNke3IQb6sgarcZIDU3gbMeTp/9SSU1DAIkil7PrqG1vZlBtY5msYccSKSHDqa3hNg436IXK+SNImReuA1wEQ==}
    engines: {node: '>=10'}
    hasBin: true
    dependencies:
      detect-libc: 2.0.3
      expand-template: 2.0.3
      github-from-package: 0.0.0
      minimist: 1.2.8
      mkdirp-classic: 0.5.3
      napi-build-utils: 1.0.2
      node-abi: 3.68.0
      pump: 3.0.2
      rc: 1.2.8
      simple-get: 4.0.1
      tar-fs: 2.1.1
      tunnel-agent: 0.6.0
    dev: false

  /preferred-pm@4.0.0:
    resolution: {integrity: sha512-gYBeFTZLu055D8Vv3cSPox/0iTPtkzxpLroSYYA7WXgRi31WCJ51Uyl8ZiPeUUjyvs2MBzK+S8v9JVUgHU/Sqw==}
    engines: {node: '>=18.12'}
    dependencies:
      find-up-simple: 1.0.0
      find-yarn-workspace-root2: 1.2.16
      which-pm: 3.0.0
    dev: false

  /prettier@2.8.7:
    resolution: {integrity: sha512-yPngTo3aXUUmyuTjeTUT75txrf+aMh9FiD7q9ZE/i6r0bPb22g4FsE6Y338PQX1bmfy08i9QQCB7/rcUAVntfw==}
    engines: {node: '>=10.13.0'}
    hasBin: true
    requiresBuild: true
    dev: false
    optional: true

  /prismjs@1.29.0:
    resolution: {integrity: sha512-Kx/1w86q/epKcmte75LNrEoT+lX8pBpavuAbvJWRXar7Hz8jrtF+e3vY751p0R8H9HdArwaCTNDDzHg/ScJK1Q==}
    engines: {node: '>=6'}
    dev: false

  /prompts@2.4.2:
    resolution: {integrity: sha512-NxNv/kLguCA7p3jE8oL2aEBsrJWgAakBpgmgK6lpPWV+WuOmY6r2/zbAVnP+T8bQlA0nzHXSJSJW0Hq7ylaD2Q==}
    engines: {node: '>= 6'}
    dependencies:
      kleur: 3.0.3
      sisteransi: 1.0.5
    dev: false

  /property-information@6.5.0:
    resolution: {integrity: sha512-PgTgs/BlvHxOu8QuEN7wi5A0OmXaBcHpmCSTehcs6Uuu9IkDIEo13Hy7n898RHfrQ49vKCoGeWZSaAK01nwVig==}
    dev: false

  /pump@3.0.2:
    resolution: {integrity: sha512-tUPXtzlGM8FE3P0ZL6DVs/3P58k9nk8/jZeQCurTJylQA8qFYzHFfhBJkuqyE0FifOsQ0uKWekiZ5g8wtr28cw==}
    dependencies:
      end-of-stream: 1.4.4
      once: 1.4.0
    dev: false

  /pvtsutils@1.3.5:
    resolution: {integrity: sha512-ARvb14YB9Nm2Xi6nBq1ZX6dAM0FsJnuk+31aUp4TrcZEdKUlSqOqsxJHUPJDNE3qiIp+iUPEIeR6Je/tgV7zsA==}
    dependencies:
      tslib: 2.7.0
    dev: false

  /pvutils@1.1.3:
    resolution: {integrity: sha512-pMpnA0qRdFp32b1sJl1wOJNxZLQ2cbQx+k6tjNtZ8CpvVhNqEPRgivZ2WOUev2YMajecdH7ctUPDvEe87nariQ==}
    engines: {node: '>=6.0.0'}
    dev: false

  /queue-microtask@1.2.3:
    resolution: {integrity: sha512-NuaNSa6flKT5JaSYQzJok04JzTL1CA6aGhv5rfLW3PgqA+M2ChpZQnAC8h8i4ZFkBS8X5RqkDBHA7r4hej3K9A==}
    dev: false

  /rc9@2.1.2:
    resolution: {integrity: sha512-btXCnMmRIBINM2LDZoEmOogIZU7Qe7zn4BpomSKZ/ykbLObuBdvG+mFq11DL6fjH1DRwHhrlgtYWG96bJiC7Cg==}
    dependencies:
      defu: 6.1.4
      destr: 2.0.3
    dev: false

  /rc@1.2.8:
    resolution: {integrity: sha512-y3bGgqKj3QBdxLbLkomlohkvsA8gdAiUQlSBJnBhfn+BPxg4bc62d8TcBW15wavDfgexCgccckhcZvywyQYPOw==}
    hasBin: true
    dependencies:
      deep-extend: 0.6.0
      ini: 1.3.8
      minimist: 1.2.8
      strip-json-comments: 2.0.1
    dev: false

  /react@18.3.1:
    resolution: {integrity: sha512-wS+hAgJShR0KhEvPJArfuPVN1+Hz1t0Y6n5jLrGQbkb4urgPE/0Rve+1kMB1v/oWgHgm4WIcV+i7F2pTVj+2iQ==}
    engines: {node: '>=0.10.0'}
    dependencies:
      loose-envify: 1.4.0
    dev: false

  /read-cache@1.0.0:
    resolution: {integrity: sha512-Owdv/Ft7IjOgm/i0xvNDZ1LrRANRfew4b2prF3OWMQLxLfu3bS8FVhCsrSCMK4lR56Y9ya+AThoTpDCTxCmpRA==}
    dependencies:
      pify: 2.3.0
    dev: false

  /readable-stream@3.6.2:
    resolution: {integrity: sha512-9u/sniCrY3D5WdsERHzHE4G2YCXqoG5FTHUiCC4SIbr6XcLZBY05ya9EKjYek9O5xOAwjGq+1JdGBAS7Q9ScoA==}
    engines: {node: '>= 6'}
    dependencies:
      inherits: 2.0.4
      string_decoder: 1.3.0
      util-deprecate: 1.0.2
    dev: false

  /readdirp@3.6.0:
    resolution: {integrity: sha512-hOS089on8RduqdbhvQ5Z37A0ESjsqz6qnRcffsMU3495FuTdqSm+7bhJ29JvIOsBDEEnan5DPu9t3To9VRlMzA==}
    engines: {node: '>=8.10.0'}
    dependencies:
      picomatch: 2.3.1
    dev: false

  /regex@4.3.2:
    resolution: {integrity: sha512-kK/AA3A9K6q2js89+VMymcboLOlF5lZRCYJv3gzszXFHBr6kO6qLGzbm+UIugBEV8SMMKCTR59txoY6ctRHYVw==}
    dev: false

  /rehype-parse@9.0.0:
    resolution: {integrity: sha512-WG7nfvmWWkCR++KEkZevZb/uw41E8TsH4DsY9UxsTbIXCVGbAs4S+r8FrQ+OtH5EEQAs+5UxKC42VinkmpA1Yw==}
    dependencies:
      '@types/hast': 3.0.4
      hast-util-from-html: 2.0.3
      unified: 11.0.5
    dev: false

  /rehype-raw@7.0.0:
    resolution: {integrity: sha512-/aE8hCfKlQeA8LmyeyQvQF3eBiLRGNlfBJEvWH7ivp9sBqs7TNqBL5X3v157rM4IFETqDnIOO+z5M/biZbo9Ww==}
    dependencies:
      '@types/hast': 3.0.4
      hast-util-raw: 9.0.4
      vfile: 6.0.3
    dev: false

  /rehype-stringify@10.0.0:
    resolution: {integrity: sha512-1TX1i048LooI9QoecrXy7nGFFbFSufxVRAfc6Y9YMRAi56l+oB0zP51mLSV312uRuvVLPV1opSlJmslozR1XHQ==}
    dependencies:
      '@types/hast': 3.0.4
      hast-util-to-html: 9.0.3
      unified: 11.0.5
    dev: false

  /rehype@13.0.1:
    resolution: {integrity: sha512-AcSLS2mItY+0fYu9xKxOu1LhUZeBZZBx8//5HKzF+0XP+eP8+6a5MXn2+DW2kfXR6Dtp1FEXMVrjyKAcvcU8vg==}
    dependencies:
      '@types/hast': 3.0.4
      rehype-parse: 9.0.0
      rehype-stringify: 10.0.0
      unified: 11.0.5
    dev: false

  /remark-gfm@4.0.0:
    resolution: {integrity: sha512-U92vJgBPkbw4Zfu/IiW2oTZLSL3Zpv+uI7My2eq8JxKgqraFdU8YUGicEJCEgSbeaG+QDFqIcwwfMTOEelPxuA==}
    dependencies:
      '@types/mdast': 4.0.4
      mdast-util-gfm: 3.0.0
      micromark-extension-gfm: 3.0.0
      remark-parse: 11.0.0
      remark-stringify: 11.0.0
      unified: 11.0.5
    transitivePeerDependencies:
      - supports-color
    dev: false

  /remark-parse@11.0.0:
    resolution: {integrity: sha512-FCxlKLNGknS5ba/1lmpYijMUzX2esxW5xQqjWxw2eHFfS2MSdaHVINFmhjo+qN1WhZhNimq0dZATN9pH0IDrpA==}
    dependencies:
      '@types/mdast': 4.0.4
      mdast-util-from-markdown: 2.0.1
      micromark-util-types: 2.0.0
      unified: 11.0.5
    transitivePeerDependencies:
      - supports-color
    dev: false

  /remark-rehype@11.1.1:
    resolution: {integrity: sha512-g/osARvjkBXb6Wo0XvAeXQohVta8i84ACbenPpoSsxTOQH/Ae0/RGP4WZgnMH5pMLpsj4FG7OHmcIcXxpza8eQ==}
    dependencies:
      '@types/hast': 3.0.4
      '@types/mdast': 4.0.4
      mdast-util-to-hast: 13.2.0
      unified: 11.0.5
      vfile: 6.0.3
    dev: false

  /remark-smartypants@3.0.2:
    resolution: {integrity: sha512-ILTWeOriIluwEvPjv67v7Blgrcx+LZOkAUVtKI3putuhlZm84FnqDORNXPPm+HY3NdZOMhyDwZ1E+eZB/Df5dA==}
    engines: {node: '>=16.0.0'}
    dependencies:
      retext: 9.0.0
      retext-smartypants: 6.1.1
      unified: 11.0.5
      unist-util-visit: 5.0.0
    dev: false

  /remark-stringify@11.0.0:
    resolution: {integrity: sha512-1OSmLd3awB/t8qdoEOMazZkNsfVTeY4fTsgzcQFdXNq8ToTN4ZGwrMnlda4K6smTFKD+GRV6O48i6Z4iKgPPpw==}
    dependencies:
      '@types/mdast': 4.0.4
      mdast-util-to-markdown: 2.1.0
      unified: 11.0.5
    dev: false

  /request-light@0.5.8:
    resolution: {integrity: sha512-3Zjgh+8b5fhRJBQZoy+zbVKpAQGLyka0MPgW3zruTF4dFFJ8Fqcfu9YsAvi/rvdcaTeWG3MkbZv4WKxAn/84Lg==}
    dev: false

  /request-light@0.7.0:
    resolution: {integrity: sha512-lMbBMrDoxgsyO+yB3sDcrDuX85yYt7sS8BfQd11jtbW/z5ZWgLZRcEGLsLoYw7I0WSUGQBs8CC8ScIxkTX1+6Q==}
    dev: false

  /require-directory@2.1.1:
    resolution: {integrity: sha512-fGxEI7+wsG9xrvdjsrlmL22OMTTiHRwAMroiEeMgq8gzoLC/PQr7RsRDSTLUg/bZAZtF+TVIkHc6/4RIKrui+Q==}
    engines: {node: '>=0.10.0'}
    dev: false

  /require-from-string@2.0.2:
    resolution: {integrity: sha512-Xf0nWe6RseziFMu+Ap9biiUbmplq6S9/p+7w7YXP/JBHhrUDDUhwa+vANyubuqfZWTveU//DYVGsDG7RKL/vEw==}
    engines: {node: '>=0.10.0'}
    dev: false

  /resolve@1.22.8:
    resolution: {integrity: sha512-oKWePCxqpd6FlLvGV1VU0x7bkPmmCNolxzjMf4NczoDnQcIWrAF+cPtZn5i6n+RfD2d9i0tzpKnG6Yk168yIyw==}
    hasBin: true
    dependencies:
      is-core-module: 2.15.1
      path-parse: 1.0.7
      supports-preserve-symlinks-flag: 1.0.0
    dev: false

  /restore-cursor@5.1.0:
    resolution: {integrity: sha512-oMA2dcrw6u0YfxJQXm342bFKX/E4sG9rbTzO9ptUcR/e8A33cHuvStiYOwH7fszkZlZ1z/ta9AAoPk2F4qIOHA==}
    engines: {node: '>=18'}
    dependencies:
      onetime: 7.0.0
      signal-exit: 4.1.0
    dev: false

  /retext-latin@4.0.0:
    resolution: {integrity: sha512-hv9woG7Fy0M9IlRQloq/N6atV82NxLGveq+3H2WOi79dtIYWN8OaxogDm77f8YnVXJL2VD3bbqowu5E3EMhBYA==}
    dependencies:
      '@types/nlcst': 2.0.3
      parse-latin: 7.0.0
      unified: 11.0.5
    dev: false

  /retext-smartypants@6.1.1:
    resolution: {integrity: sha512-onsHf34i/GzgElJgtT1K2V+31yEhWs7NJboKNxXJcmVMMPxLpgxZ9iADoMdydd6j/bHic5F/aNq0CGqElEtu2g==}
    dependencies:
      '@types/nlcst': 2.0.3
      nlcst-to-string: 4.0.0
      unist-util-visit: 5.0.0
    dev: false

  /retext-stringify@4.0.0:
    resolution: {integrity: sha512-rtfN/0o8kL1e+78+uxPTqu1Klt0yPzKuQ2BfWwwfgIUSayyzxpM1PJzkKt4V8803uB9qSy32MvI7Xep9khTpiA==}
    dependencies:
      '@types/nlcst': 2.0.3
      nlcst-to-string: 4.0.0
      unified: 11.0.5
    dev: false

  /retext@9.0.0:
    resolution: {integrity: sha512-sbMDcpHCNjvlheSgMfEcVrZko3cDzdbe1x/e7G66dFp0Ff7Mldvi2uv6JkJQzdRcvLYE8CA8Oe8siQx8ZOgTcA==}
    dependencies:
      '@types/nlcst': 2.0.3
      retext-latin: 4.0.0
      retext-stringify: 4.0.0
      unified: 11.0.5
    dev: false

  /reusify@1.0.4:
    resolution: {integrity: sha512-U9nH88a3fc/ekCF1l0/UP1IosiuIjyTh7hBvXVMHYgVcfGvt897Xguj2UOLDeI5BG2m7/uwyaLVT6fbtCwTyzw==}
    engines: {iojs: '>=1.0.0', node: '>=0.10.0'}
    dev: false

  /rollup@4.22.4:
    resolution: {integrity: sha512-vD8HJ5raRcWOyymsR6Z3o6+RzfEPCnVLMFJ6vRslO1jt4LO6dUo5Qnpg7y4RkZFM2DMe3WUirkI5c16onjrc6A==}
    engines: {node: '>=18.0.0', npm: '>=8.0.0'}
    hasBin: true
    dependencies:
      '@types/estree': 1.0.5
    optionalDependencies:
      '@rollup/rollup-android-arm-eabi': 4.22.4
      '@rollup/rollup-android-arm64': 4.22.4
      '@rollup/rollup-darwin-arm64': 4.22.4
      '@rollup/rollup-darwin-x64': 4.22.4
      '@rollup/rollup-linux-arm-gnueabihf': 4.22.4
      '@rollup/rollup-linux-arm-musleabihf': 4.22.4
      '@rollup/rollup-linux-arm64-gnu': 4.22.4
      '@rollup/rollup-linux-arm64-musl': 4.22.4
      '@rollup/rollup-linux-powerpc64le-gnu': 4.22.4
      '@rollup/rollup-linux-riscv64-gnu': 4.22.4
      '@rollup/rollup-linux-s390x-gnu': 4.22.4
      '@rollup/rollup-linux-x64-gnu': 4.22.4
      '@rollup/rollup-linux-x64-musl': 4.22.4
      '@rollup/rollup-win32-arm64-msvc': 4.22.4
      '@rollup/rollup-win32-ia32-msvc': 4.22.4
      '@rollup/rollup-win32-x64-msvc': 4.22.4
      fsevents: 2.3.3
    dev: false

  /rou3@0.5.1:
    resolution: {integrity: sha512-OXMmJ3zRk2xeXFGfA3K+EOPHC5u7RDFG7lIOx0X1pdnhUkI8MdVrbV+sNsD80ElpUZ+MRHdyxPnFthq9VHs8uQ==}
    dev: false

  /run-parallel@1.2.0:
    resolution: {integrity: sha512-5l4VyZR86LZ/lDxZTR6jqL8AFE2S0IFLMP26AbjsLVADxHdhB/c0GUsH+y39UfCi3dzz8OlQuPmnaJOMoDHQBA==}
    dependencies:
      queue-microtask: 1.2.3
    dev: false

  /safe-buffer@5.2.1:
    resolution: {integrity: sha512-rp3So07KcdmmKbGvgaNxQSJr7bGVSVk5S9Eq1F+ppbRo70+YeaDxkw5Dd8NPN+GD6bjnYm2VuPuCXmpuYvmCXQ==}
    dev: false

  /safer-buffer@2.1.2:
    resolution: {integrity: sha512-YZo3K82SD7Riyi0E1EQPojLz7kpepnSQI9IyPbHHg1XXXevb5dJI7tpyN2ADxGcQbHG7vcyRHk0cbwqcQriUtg==}
    dev: false

  /section-matter@1.0.0:
    resolution: {integrity: sha512-vfD3pmTzGpufjScBh50YHKzEu2lxBWhVEHsNGoEXmCmn2hKGfeNLYMzCJpe8cD7gqX7TJluOVpBkAequ6dgMmA==}
    engines: {node: '>=4'}
    dependencies:
      extend-shallow: 2.0.1
      kind-of: 6.0.3
    dev: false

  /semver@6.3.1:
    resolution: {integrity: sha512-BR7VvDCVHO+q2xBEWskxS6DJE1qRnb7DxzUrogb71CWoSficBxYsiAGd+Kl0mmq/MprG9yArRkyrQxTO6XjMzA==}
    hasBin: true
    dev: false

  /semver@7.6.3:
    resolution: {integrity: sha512-oVekP1cKtI+CTDvHWYFUcMtsK/00wmAEfyqKfNdARm8u1wNVhSgaX7A8d4UuIlUI5e84iEwOhs7ZPYRmzU9U6A==}
    engines: {node: '>=10'}
    hasBin: true
    dev: false

  /seq-queue@0.0.5:
    resolution: {integrity: sha512-hr3Wtp/GZIc/6DAGPDcV4/9WoZhjrkXsi5B/07QgX8tsdc6ilr7BFM6PM6rbdAX1kFSDYeZGLipIZZKyQP0O5Q==}
    dev: false

  /seroval-plugins@1.1.1(seroval@1.1.1):
    resolution: {integrity: sha512-qNSy1+nUj7hsCOon7AO4wdAIo9P0jrzAMp18XhiOzA6/uO5TKtP7ScozVJ8T293oRIvi5wyCHSM4TrJo/c/GJA==}
    engines: {node: '>=10'}
    peerDependencies:
      seroval: ^1.0
    dependencies:
      seroval: 1.1.1
    dev: false

  /seroval@1.1.1:
    resolution: {integrity: sha512-rqEO6FZk8mv7Hyv4UCj3FD3b6Waqft605TLfsCe/BiaylRpyyMC0b+uA5TJKawX3KzMrdi3wsLbCaLplrQmBvQ==}
    engines: {node: '>=10'}
    dev: false

  /set-cookie-parser@2.7.0:
    resolution: {integrity: sha512-lXLOiqpkUumhRdFF3k1osNXCy9akgx/dyPZ5p8qAg9seJzXr5ZrlqZuWIMuY6ejOsVLE6flJ5/h3lsn57fQ/PQ==}
    dev: false

  /sharp@0.33.5:
    resolution: {integrity: sha512-haPVm1EkS9pgvHrQ/F3Xy+hgcuMV0Wm9vfIBSiwZ05k+xgb0PkBQpGsAA/oWdDobNaZTH5ppvHtzCFbnSEwHVw==}
    engines: {node: ^18.17.0 || ^20.3.0 || >=21.0.0}
    requiresBuild: true
    dependencies:
      color: 4.2.3
      detect-libc: 2.0.3
      semver: 7.6.3
    optionalDependencies:
      '@img/sharp-darwin-arm64': 0.33.5
      '@img/sharp-darwin-x64': 0.33.5
      '@img/sharp-libvips-darwin-arm64': 1.0.4
      '@img/sharp-libvips-darwin-x64': 1.0.4
      '@img/sharp-libvips-linux-arm': 1.0.5
      '@img/sharp-libvips-linux-arm64': 1.0.4
      '@img/sharp-libvips-linux-s390x': 1.0.4
      '@img/sharp-libvips-linux-x64': 1.0.4
      '@img/sharp-libvips-linuxmusl-arm64': 1.0.4
      '@img/sharp-libvips-linuxmusl-x64': 1.0.4
      '@img/sharp-linux-arm': 0.33.5
      '@img/sharp-linux-arm64': 0.33.5
      '@img/sharp-linux-s390x': 0.33.5
      '@img/sharp-linux-x64': 0.33.5
      '@img/sharp-linuxmusl-arm64': 0.33.5
      '@img/sharp-linuxmusl-x64': 0.33.5
      '@img/sharp-wasm32': 0.33.5
      '@img/sharp-win32-ia32': 0.33.5
      '@img/sharp-win32-x64': 0.33.5
    dev: false
    optional: true

  /shebang-command@2.0.0:
    resolution: {integrity: sha512-kHxr2zZpYtdmrN1qDjrrX/Z1rR1kG8Dx+gkpK1G4eXmvXswmcE1hTWBWYUzlraYw1/yZp6YuDY77YtvbN0dmDA==}
    engines: {node: '>=8'}
    dependencies:
      shebang-regex: 3.0.0
    dev: false

  /shebang-regex@3.0.0:
    resolution: {integrity: sha512-7++dFhtcx3353uBaq8DDR4NuxBetBzC7ZQOhmTQInHEd6bSrXdiEyzCvG07Z44UYdLShWUyXt5M/yhz8ekcb1A==}
    engines: {node: '>=8'}
    dev: false

  /shiki@1.18.0:
    resolution: {integrity: sha512-8jo7tOXr96h9PBQmOHVrltnETn1honZZY76YA79MHheGQg55jBvbm9dtU+MI5pjC5NJCFuA6rvVTLVeSW5cE4A==}
    dependencies:
      '@shikijs/core': 1.18.0
      '@shikijs/engine-javascript': 1.18.0
      '@shikijs/engine-oniguruma': 1.18.0
      '@shikijs/types': 1.18.0
      '@shikijs/vscode-textmate': 9.2.2
      '@types/hast': 3.0.4
    dev: false

  /signal-exit@4.1.0:
    resolution: {integrity: sha512-bzyZ1e88w9O1iNJbKnOlvYTrWPDl46O1bG0D3XInv+9tkPrxrN8jUUTiFlDkkmKWgn1M6CfIA13SuGqOa9Korw==}
    engines: {node: '>=14'}
    dev: false

  /simple-concat@1.0.1:
    resolution: {integrity: sha512-cSFtAPtRhljv69IK0hTVZQ+OfE9nePi/rtJmw5UjHeVyVroEqJXP1sFztKUy1qU+xvz3u/sfYJLa947b7nAN2Q==}
    dev: false

  /simple-get@4.0.1:
    resolution: {integrity: sha512-brv7p5WgH0jmQJr1ZDDfKDOSeWWg+OVypG99A/5vYGPqJ6pxiaHLy8nxtFjBA7oMa01ebA9gfh1uMCFqOuXxvA==}
    dependencies:
      decompress-response: 6.0.0
      once: 1.4.0
      simple-concat: 1.0.1
    dev: false

  /simple-swizzle@0.2.2:
    resolution: {integrity: sha512-JA//kQgZtbuY83m+xT+tXJkmJncGMTFT+C+g2h2R9uxkYIrE2yy9sgmcLhCnw57/WSD+Eh3J97FPEDFnbXnDUg==}
    requiresBuild: true
    dependencies:
      is-arrayish: 0.3.2
    dev: false
    optional: true

  /sisteransi@1.0.5:
    resolution: {integrity: sha512-bLGGlR1QxBcynn2d5YmDX4MGjlZvy2MRBDRNHLJ8VI6l6+9FUiyTFNJ0IveOSP0bcXgVDPRcfGqA0pjaqUpfVg==}
    dev: false

  /solid-js@1.8.23:
    resolution: {integrity: sha512-0jKzMgxmU/b3k4iJmIZJW2BIArrHN+Mug0n7m7MeHvGHWiS57ZdyTmnqNMSbGRvE73QBnTiGFJc90cPPieawaA==}
    dependencies:
      csstype: 3.1.3
      seroval: 1.1.1
      seroval-plugins: 1.1.1(seroval@1.1.1)
    dev: false

  /source-map-js@1.2.1:
    resolution: {integrity: sha512-UXWMKhLOwVKb728IUtQPXxfYU+usdybtUrK/8uGE8CQMvrhOpwvzDBwj0QhSL7MQc7vIsISBG8VQ8+IDQxpfQA==}
    engines: {node: '>=0.10.0'}
    dev: false

  /space-separated-tokens@2.0.2:
    resolution: {integrity: sha512-PEGlAwrG8yXGXRjW32fGbg66JAlOAwbObuqVoJpv/mRgoWDQfgH1wDPvtzWyUSNAXBGSk8h755YDbbcEy3SH2Q==}
    dev: false

  /split2@4.2.0:
    resolution: {integrity: sha512-UcjcJOWknrNkF6PLX83qcHM6KHgVKNkV62Y8a5uYDVv9ydGQVwAHMKqHdJje1VTWpljG0WYpCDhrCdAOYH4TWg==}
    engines: {node: '>= 10.x'}
    dev: false

  /sprintf-js@1.0.3:
    resolution: {integrity: sha512-D9cPgkvLlV3t3IzL0D0YLvGA9Ahk4PcvVwUbN0dSGr1aP0Nrt4AEnTUbuGvquEC0mA64Gqt1fzirlRs5ibXx8g==}
    dev: false

  /sqlstring@2.3.3:
    resolution: {integrity: sha512-qC9iz2FlN7DQl3+wjwn3802RTyjCx7sDvfQEXchwa6CWOx07/WVfh91gBmQ9fahw8snwGEWU3xGzOt4tFyHLxg==}
    engines: {node: '>= 0.6'}
    dev: false

  /stdin-discarder@0.2.2:
    resolution: {integrity: sha512-UhDfHmA92YAlNnCfhmq0VeNL5bDbiZGg7sZ2IvPsXubGkiNa9EC+tUTsjBRsYUAz87btI6/1wf4XoVvQ3uRnmQ==}
    engines: {node: '>=18'}
    dev: false

  /string-width@4.2.3:
    resolution: {integrity: sha512-wKyQRQpjJ0sIp62ErSZdGsjMJWsap5oRNihHhu6G7JVO/9jIB6UyevL+tXuOqrng8j/cxKTWyWUwvSTriiZz/g==}
    engines: {node: '>=8'}
    dependencies:
      emoji-regex: 8.0.0
      is-fullwidth-code-point: 3.0.0
      strip-ansi: 6.0.1
    dev: false

  /string-width@5.1.2:
    resolution: {integrity: sha512-HnLOCR3vjcY8beoNLtcjZ5/nxn2afmME6lhrDrebokqMap+XbeW8n9TXpPDOqdGK5qcI3oT0GKTW6wC7EMiVqA==}
    engines: {node: '>=12'}
    dependencies:
      eastasianwidth: 0.2.0
      emoji-regex: 9.2.2
      strip-ansi: 7.1.0
    dev: false

  /string-width@7.2.0:
    resolution: {integrity: sha512-tsaTIkKW9b4N+AEj+SVA+WhJzV7/zMhcSu78mLKWSk7cXMOSHsBKFWUs0fWwq8QyK3MgJBQRX6Gbi4kYbdvGkQ==}
    engines: {node: '>=18'}
    dependencies:
      emoji-regex: 10.4.0
      get-east-asian-width: 1.2.0
      strip-ansi: 7.1.0
    dev: false

  /string_decoder@1.3.0:
    resolution: {integrity: sha512-hkRX8U1WjJFd8LsDJ2yQ/wWWxaopEsABU1XfkM8A+j0+85JAGppt16cr1Whg6KIbb4okU6Mql6BOj+uup/wKeA==}
    dependencies:
      safe-buffer: 5.2.1
    dev: false

  /stringify-entities@4.0.4:
    resolution: {integrity: sha512-IwfBptatlO+QCJUo19AqvrPNqlVMpW9YEL2LIVY+Rpv2qsjCGxaDLNRgeGsQWJhfItebuJhsGSLjaBbNSQ+ieg==}
    dependencies:
      character-entities-html4: 2.1.0
      character-entities-legacy: 3.0.0
    dev: false

  /strip-ansi@6.0.1:
    resolution: {integrity: sha512-Y38VPSHcqkFrCpFnQ9vuSXmquuv5oXOKpGeT6aGrr3o3Gc9AlVa6JBfUSOCnbxGGZF+/0ooI7KrPuUSztUdU5A==}
    engines: {node: '>=8'}
    dependencies:
      ansi-regex: 5.0.1
    dev: false

  /strip-ansi@7.1.0:
    resolution: {integrity: sha512-iq6eVVI64nQQTRYq2KtEg2d2uU7LElhTJwsH4YzIHZshxlgZms/wIc4VoDQTlG/IvVIrBKG06CrZnp0qv7hkcQ==}
    engines: {node: '>=12'}
    dependencies:
      ansi-regex: 6.1.0
    dev: false

  /strip-bom-string@1.0.0:
    resolution: {integrity: sha512-uCC2VHvQRYu+lMh4My/sFNmF2klFymLX1wHJeXnbEJERpV/ZsVuonzerjfrGpIGF7LBVa1O7i9kjiWvJiFck8g==}
    engines: {node: '>=0.10.0'}
    dev: false

  /strip-bom@3.0.0:
    resolution: {integrity: sha512-vavAMRXOgBVNF6nyEEmL3DBK19iRpDcoIwW+swQ+CbGiu7lju6t+JklA1MHweoWtadgt4ISVUsXLyDq34ddcwA==}
    engines: {node: '>=4'}
    dev: false

  /strip-final-newline@3.0.0:
    resolution: {integrity: sha512-dOESqjYr96iWYylGObzd39EuNTa5VJxyvVAEm5Jnh7KGo75V43Hk1odPQkNDyXNmUR6k+gEiDVXnjB8HJ3crXw==}
    engines: {node: '>=12'}
    dev: false

  /strip-json-comments@2.0.1:
    resolution: {integrity: sha512-4gB8na07fecVVkOI6Rs4e7T6NOTki5EmL7TUduTs6bu3EdnSycntVJ4re8kgZA+wx9IueI2Y11bfbgwtzuE0KQ==}
    engines: {node: '>=0.10.0'}
    dev: false

  /sucrase@3.35.0:
    resolution: {integrity: sha512-8EbVDiu9iN/nESwxeSxDKe0dunta1GOlHufmSSXxMD2z2/tMZpDMpvXQGsc+ajGo8y2uYUmixaSRUc/QPoQ0GA==}
    engines: {node: '>=16 || 14 >=14.17'}
    hasBin: true
    dependencies:
      '@jridgewell/gen-mapping': 0.3.5
      commander: 4.1.1
      glob: 10.4.5
      lines-and-columns: 1.2.4
      mz: 2.7.0
      pirates: 4.0.6
      ts-interface-checker: 0.1.13
    dev: false

  /supports-color@5.5.0:
    resolution: {integrity: sha512-QjVjwdXIt408MIiAqCX4oUKsgU2EqAGzs2Ppkm4aQYbjm+ZEWEcW4SfFNTr4uMNZma0ey4f5lgLrkB0aX0QMow==}
    engines: {node: '>=4'}
    dependencies:
      has-flag: 3.0.0
    dev: false

  /supports-preserve-symlinks-flag@1.0.0:
    resolution: {integrity: sha512-ot0WnXS9fgdkgIcePe6RHNk1WA8+muPa6cSjeR3V8K27q9BB1rTE3R1p7Hv0z1ZyAc8s6Vvv8DIyWf681MAt0w==}
    engines: {node: '>= 0.4'}
    dev: false

  /tailwindcss@3.4.13:
    resolution: {integrity: sha512-KqjHOJKogOUt5Bs752ykCeiwvi0fKVkr5oqsFNt/8px/tA8scFPIlkygsf6jXrfCqGHz7VflA6+yytWuM+XhFw==}
    engines: {node: '>=14.0.0'}
    hasBin: true
    dependencies:
      '@alloc/quick-lru': 5.2.0
      arg: 5.0.2
      chokidar: 3.6.0
      didyoumean: 1.2.2
      dlv: 1.1.3
      fast-glob: 3.3.2
      glob-parent: 6.0.2
      is-glob: 4.0.3
      jiti: 1.21.6
      lilconfig: 2.1.0
      micromatch: 4.0.8
      normalize-path: 3.0.0
      object-hash: 3.0.0
      picocolors: 1.1.0
      postcss: 8.4.47
      postcss-import: 15.1.0(postcss@8.4.47)
      postcss-js: 4.0.1(postcss@8.4.47)
      postcss-load-config: 4.0.2(postcss@8.4.47)
      postcss-nested: 6.2.0(postcss@8.4.47)
      postcss-selector-parser: 6.1.2
      resolve: 1.22.8
      sucrase: 3.35.0
    transitivePeerDependencies:
      - ts-node
    dev: false

  /tar-fs@2.1.1:
    resolution: {integrity: sha512-V0r2Y9scmbDRLCNex/+hYzvp/zyYjvFbHPNgVTKfQvVrb6guiE/fxP+XblDNR011utopbkex2nM4dHNV6GDsng==}
    dependencies:
      chownr: 1.1.4
      mkdirp-classic: 0.5.3
      pump: 3.0.2
      tar-stream: 2.2.0
    dev: false

  /tar-stream@2.2.0:
    resolution: {integrity: sha512-ujeqbceABgwMZxEJnk2HDY2DlnUZ+9oEcb1KzTVfYHio0UE6dG71n60d8D2I4qNvleWrrXpmjpt7vZeF1LnMZQ==}
    engines: {node: '>=6'}
    dependencies:
      bl: 4.1.0
      end-of-stream: 1.4.4
      fs-constants: 1.0.0
      inherits: 2.0.4
      readable-stream: 3.6.2
    dev: false

  /tar@6.2.1:
    resolution: {integrity: sha512-DZ4yORTwrbTj/7MZYq2w+/ZFdI6OZ/f9SFHR+71gIVUZhOQPHzVCLpvRnPgyaMpfWxxk/4ONva3GQSyNIKRv6A==}
    engines: {node: '>=10'}
    dependencies:
      chownr: 2.0.0
      fs-minipass: 2.1.0
      minipass: 5.0.0
      minizlib: 2.1.2
      mkdirp: 1.0.4
      yallist: 4.0.0
    dev: false

  /thenify-all@1.6.0:
    resolution: {integrity: sha512-RNxQH/qI8/t3thXJDwcstUO4zeqo64+Uy/+sNVRBx4Xn2OX+OZ9oP+iJnNFqplFra2ZUVeKCSa2oVWi3T4uVmA==}
    engines: {node: '>=0.8'}
    dependencies:
      thenify: 3.3.1
    dev: false

  /thenify@3.3.1:
    resolution: {integrity: sha512-RVZSIV5IG10Hk3enotrhvz0T9em6cyHBLkH/YAZuKqd8hRkKhSfCGIcP2KUY0EPxndzANBmNllzWPwak+bheSw==}
    dependencies:
      any-promise: 1.3.0
    dev: false

  /tiny-glob@0.2.9:
    resolution: {integrity: sha512-g/55ssRPUjShh+xkfx9UPDXqhckHEsHr4Vd9zX55oSdGZc/MD0m3sferOkwWtp98bv+kcVfEHtRJgBVJzelrzg==}
    dependencies:
      globalyzer: 0.1.0
      globrex: 0.1.2
    dev: false

  /tinyexec@0.3.0:
    resolution: {integrity: sha512-tVGE0mVJPGb0chKhqmsoosjsS+qUnJVGJpZgsHYQcGoPlG3B51R3PouqTgEGH2Dc9jjFyOqOpix6ZHNMXp1FZg==}
    dev: false

  /to-fast-properties@2.0.0:
    resolution: {integrity: sha512-/OaKK0xYrs3DmxRYqL/yDc+FxFUVYhDlXMhRmv3z915w2HF1tnN1omB354j8VUGO/hbRzyD6Y3sA7v7GS/ceog==}
    engines: {node: '>=4'}
    dev: false

  /to-regex-range@5.0.1:
    resolution: {integrity: sha512-65P7iz6X5yEr1cwcgvQxbbIw7Uk3gOy5dIdtZ4rDveLqhrdJP+Li/Hx6tyK0NEb+2GCyneCMJiGqrADCSNk8sQ==}
    engines: {node: '>=8.0'}
    dependencies:
      is-number: 7.0.0
    dev: false

  /tr46@0.0.3:
    resolution: {integrity: sha512-N3WMsuqV66lT30CrXNbEjx4GEwlow3v6rr4mCcv6prnfwhS01rkgyFdjPNBYd9br7LpXV1+Emh01fHnq2Gdgrw==}
    dev: false

  /trim-lines@3.0.1:
    resolution: {integrity: sha512-kRj8B+YHZCc9kQYdWfJB2/oUl9rA99qbowYYBtr4ui4mZyAQ2JpvVBd/6U2YloATfqBhBTSMhTpgBHtU0Mf3Rg==}
    dev: false

  /trough@2.2.0:
    resolution: {integrity: sha512-tmMpK00BjZiUyVyvrBK7knerNgmgvcV/KLVyuma/SC+TQN167GrMRciANTz09+k3zW8L8t60jWO1GpfkZdjTaw==}
    dev: false

  /ts-interface-checker@0.1.13:
    resolution: {integrity: sha512-Y/arvbn+rrz3JCKl9C4kVNfTfSm2/mEp5FSz5EsZSANGPSlQrpRI5M4PKF+mJnE52jOO90PnPSc3Ur3bTQw0gA==}
    dev: false

  /ts-morph@23.0.0:
    resolution: {integrity: sha512-FcvFx7a9E8TUe6T3ShihXJLiJOiqyafzFKUO4aqIHDUCIvADdGNShcbc2W5PMr3LerXRv7mafvFZ9lRENxJmug==}
    dependencies:
      '@ts-morph/common': 0.24.0
      code-block-writer: 13.0.2
    dev: false

  /tsconfck@3.1.3(typescript@5.6.2):
    resolution: {integrity: sha512-ulNZP1SVpRDesxeMLON/LtWM8HIgAJEIVpVVhBM6gsmvQ8+Rh+ZG7FWGvHh7Ah3pRABwVJWklWCr/BTZSv0xnQ==}
    engines: {node: ^18 || >=20}
    hasBin: true
    peerDependencies:
      typescript: ^5.0.0
    peerDependenciesMeta:
      typescript:
        optional: true
    dependencies:
      typescript: 5.6.2
    dev: false

  /tslib@2.7.0:
    resolution: {integrity: sha512-gLXCKdN1/j47AiHiOkJN69hJmcbGTHI0ImLmbYLHykhgeN0jVGola9yVjFgzCUklsZQMW55o+dW7IXv3RCXDzA==}
    requiresBuild: true
    dev: false

  /tunnel-agent@0.6.0:
    resolution: {integrity: sha512-McnNiV1l8RYeY8tBgEpuodCC1mLUdbSN+CYBL7kJsJNInOP8UjDDEwdk6Mw60vdLLrr5NHKZhMAOSrR2NZuQ+w==}
    dependencies:
      safe-buffer: 5.2.1
    dev: false

  /type-fest@2.19.0:
    resolution: {integrity: sha512-RAH822pAdBgcNMAfWnCBU3CFZcfZ/i1eZjwFU/dsLKumyuuP3niueg2UAukXYF0E2AAoc82ZSSf9J0WQBinzHA==}
    engines: {node: '>=12.20'}
    dev: false

  /typesafe-path@0.2.2:
    resolution: {integrity: sha512-OJabfkAg1WLZSqJAJ0Z6Sdt3utnbzr/jh+NAHoyWHJe8CMSy79Gm085094M9nvTPy22KzTVn5Zq5mbapCI/hPA==}
    dev: false

  /typescript-auto-import-cache@0.3.3:
    resolution: {integrity: sha512-ojEC7+Ci1ij9eE6hp8Jl9VUNnsEKzztktP5gtYNRMrTmfXVwA1PITYYAkpxCvvupdSYa/Re51B6KMcv1CTZEUA==}
    dependencies:
      semver: 7.6.3
    dev: false

  /typescript@5.6.2:
    resolution: {integrity: sha512-NW8ByodCSNCwZeghjN3o+JX5OFH0Ojg6sadjEKY4huZ52TqbJTJnDo5+Tw98lSy63NZvi4n+ez5m2u5d4PkZyw==}
    engines: {node: '>=14.17'}
    hasBin: true
    dev: false

  /ufo@1.5.4:
    resolution: {integrity: sha512-UsUk3byDzKd04EyoZ7U4DOlxQaD14JUKQl6/P7wiX4FNvUfm3XL246n9W5AmqwW5RSFJ27NAuM0iLscAOYUiGQ==}
    dev: false

  /undici-types@6.19.8:
    resolution: {integrity: sha512-ve2KP6f/JnbPBFyobGHuerC9g1FYGn/F8n1LWTwNxCEzd6IfqTwUQcNXgEtmmQ6DlRrC1hrSrBnCZPokRrDHjw==}
    dev: false

  /unified@11.0.5:
    resolution: {integrity: sha512-xKvGhPWw3k84Qjh8bI3ZeJjqnyadK+GEFtazSfZv/rKeTkTjOJho6mFqh2SM96iIcZokxiOpg78GazTSg8+KHA==}
    dependencies:
      '@types/unist': 3.0.3
      bail: 2.0.2
      devlop: 1.1.0
      extend: 3.0.2
      is-plain-obj: 4.1.0
      trough: 2.2.0
      vfile: 6.0.3
    dev: false

  /unist-util-find-after@5.0.0:
    resolution: {integrity: sha512-amQa0Ep2m6hE2g72AugUItjbuM8X8cGQnFoHk0pGfrFeT9GZhzN5SW8nRsiGKK7Aif4CrACPENkA6P/Lw6fHGQ==}
    dependencies:
      '@types/unist': 3.0.3
      unist-util-is: 6.0.0
    dev: false

  /unist-util-is@6.0.0:
    resolution: {integrity: sha512-2qCTHimwdxLfz+YzdGfkqNlH0tLi9xjTnHddPmJwtIG9MGsdbutfTc4P+haPD7l7Cjxf/WZj+we5qfVPvvxfYw==}
    dependencies:
      '@types/unist': 3.0.3
    dev: false

  /unist-util-modify-children@4.0.0:
    resolution: {integrity: sha512-+tdN5fGNddvsQdIzUF3Xx82CU9sMM+fA0dLgR9vOmT0oPT2jH+P1nd5lSqfCfXAw+93NhcXNY2qqvTUtE4cQkw==}
    dependencies:
      '@types/unist': 3.0.3
      array-iterate: 2.0.1
    dev: false

  /unist-util-position@5.0.0:
    resolution: {integrity: sha512-fucsC7HjXvkB5R3kTCO7kUjRdrS0BJt3M/FPxmHMBOm8JQi2BsHAHFsy27E0EolP8rp0NzXsJ+jNPyDWvOJZPA==}
    dependencies:
      '@types/unist': 3.0.3
    dev: false

  /unist-util-remove-position@5.0.0:
    resolution: {integrity: sha512-Hp5Kh3wLxv0PHj9m2yZhhLt58KzPtEYKQQ4yxfYFEO7EvHwzyDYnduhHnY1mDxoqr7VUwVuHXk9RXKIiYS1N8Q==}
    dependencies:
      '@types/unist': 3.0.3
      unist-util-visit: 5.0.0
    dev: false

  /unist-util-stringify-position@4.0.0:
    resolution: {integrity: sha512-0ASV06AAoKCDkS2+xw5RXJywruurpbC4JZSm7nr7MOt1ojAzvyyaO+UxZf18j8FCF6kmzCZKcAgN/yu2gm2XgQ==}
    dependencies:
      '@types/unist': 3.0.3
    dev: false

  /unist-util-visit-children@3.0.0:
    resolution: {integrity: sha512-RgmdTfSBOg04sdPcpTSD1jzoNBjt9a80/ZCzp5cI9n1qPzLZWF9YdvWGN2zmTumP1HWhXKdUWexjy/Wy/lJ7tA==}
    dependencies:
      '@types/unist': 3.0.3
    dev: false

  /unist-util-visit-parents@6.0.1:
    resolution: {integrity: sha512-L/PqWzfTP9lzzEa6CKs0k2nARxTdZduw3zyh8d2NVBnsyvHjSX4TWse388YrrQKbvI8w20fGjGlhgT96WwKykw==}
    dependencies:
      '@types/unist': 3.0.3
      unist-util-is: 6.0.0
    dev: false

  /unist-util-visit@5.0.0:
    resolution: {integrity: sha512-MR04uvD+07cwl/yhVuVWAtw+3GOR/knlL55Nd/wAdblk27GCVt3lqpTivy/tkJcZoNPzTwS1Y+KMojlLDhoTzg==}
    dependencies:
      '@types/unist': 3.0.3
      unist-util-is: 6.0.0
      unist-util-visit-parents: 6.0.1
    dev: false

  /update-browserslist-db@1.1.0(browserslist@4.23.3):
    resolution: {integrity: sha512-EdRAaAyk2cUE1wOf2DkEhzxqOQvFOoRJFNS6NeyJ01Gp2beMRpBAINjM2iDXE3KCuKhwnvHIQCJm6ThL2Z+HzQ==}
    hasBin: true
    peerDependencies:
      browserslist: '>= 4.21.0'
    dependencies:
      browserslist: 4.23.3
      escalade: 3.2.0
      picocolors: 1.1.0
    dev: false

  /util-deprecate@1.0.2:
    resolution: {integrity: sha512-EPD5q1uXyFxJpCrLnCc1nHnq3gOa6DZBocAIiI2TaSCA7VCJ1UJDMagCzIkXNsUYfD1daK//LTEQ8xiIbrHtcw==}
    dev: false

  /vfile-location@5.0.3:
    resolution: {integrity: sha512-5yXvWDEgqeiYiBe1lbxYF7UMAIm/IcopxMHrMQDq3nvKcjPKIhZklUKL+AE7J7uApI4kwe2snsK+eI6UTj9EHg==}
    dependencies:
      '@types/unist': 3.0.3
      vfile: 6.0.3
    dev: false

  /vfile-message@4.0.2:
    resolution: {integrity: sha512-jRDZ1IMLttGj41KcZvlrYAaI3CfqpLpfpf+Mfig13viT6NKvRzWZ+lXz0Y5D60w6uJIBAOGq9mSHf0gktF0duw==}
    dependencies:
      '@types/unist': 3.0.3
      unist-util-stringify-position: 4.0.0
    dev: false

  /vfile@6.0.3:
    resolution: {integrity: sha512-KzIbH/9tXat2u30jf+smMwFCsno4wHVdNmzFyL+T/L3UGqqk6JKfVqOFOZEpZSHADH1k40ab6NUIXZq422ov3Q==}
    dependencies:
      '@types/unist': 3.0.3
      vfile-message: 4.0.2
    dev: false

  /vite@5.4.7:
    resolution: {integrity: sha512-5l2zxqMEPVENgvzTuBpHer2awaetimj2BGkhBPdnwKbPNOlHsODU+oiazEZzLK7KhAnOrO+XGYJYn4ZlUhDtDQ==}
    engines: {node: ^18.0.0 || >=20.0.0}
    hasBin: true
    peerDependencies:
      '@types/node': ^18.0.0 || >=20.0.0
      less: '*'
      lightningcss: ^1.21.0
      sass: '*'
      sass-embedded: '*'
      stylus: '*'
      sugarss: '*'
      terser: ^5.4.0
    peerDependenciesMeta:
      '@types/node':
        optional: true
      less:
        optional: true
      lightningcss:
        optional: true
      sass:
        optional: true
      sass-embedded:
        optional: true
      stylus:
        optional: true
      sugarss:
        optional: true
      terser:
        optional: true
    dependencies:
      esbuild: 0.21.5
      postcss: 8.4.47
      rollup: 4.22.4
    optionalDependencies:
      fsevents: 2.3.3
    dev: false

  /vitefu@1.0.2(vite@5.4.7):
    resolution: {integrity: sha512-0/iAvbXyM3RiPPJ4lyD4w6Mjgtf4ejTK6TPvTNG3H32PLwuT0N/ZjJLiXug7ETE/LWtTeHw9WRv7uX/tIKYyKg==}
    peerDependencies:
      vite: ^3.0.0 || ^4.0.0 || ^5.0.0
    peerDependenciesMeta:
      vite:
        optional: true
    dependencies:
      vite: 5.4.7
    dev: false

  /volar-service-css@0.0.61(@volar/language-service@2.4.5):
    resolution: {integrity: sha512-Ct9L/w+IB1JU8F4jofcNCGoHy6TF83aiapfZq9A0qYYpq+Kk5dH+ONS+rVZSsuhsunq8UvAuF8Gk6B8IFLfniw==}
    peerDependencies:
      '@volar/language-service': ~2.4.0
    peerDependenciesMeta:
      '@volar/language-service':
        optional: true
    dependencies:
      '@volar/language-service': 2.4.5
      vscode-css-languageservice: 6.3.1
      vscode-languageserver-textdocument: 1.0.12
      vscode-uri: 3.0.8
    dev: false

  /volar-service-emmet@0.0.61(@volar/language-service@2.4.5):
    resolution: {integrity: sha512-iiYqBxjjcekqrRruw4COQHZME6EZYWVbkHjHDbULpml3g8HGJHzpAMkj9tXNCPxf36A+f1oUYjsvZt36qPg4cg==}
    peerDependencies:
      '@volar/language-service': ~2.4.0
    peerDependenciesMeta:
      '@volar/language-service':
        optional: true
    dependencies:
      '@emmetio/css-parser': 0.4.0
      '@emmetio/html-matcher': 1.3.0
      '@volar/language-service': 2.4.5
      '@vscode/emmet-helper': 2.9.3
      vscode-uri: 3.0.8
    dev: false

  /volar-service-html@0.0.61(@volar/language-service@2.4.5):
    resolution: {integrity: sha512-yFE+YmmgqIL5HI4ORqP++IYb1QaGcv+xBboI0WkCxJJ/M35HZj7f5rbT3eQ24ECLXFbFCFanckwyWJVz5KmN3Q==}
    peerDependencies:
      '@volar/language-service': ~2.4.0
    peerDependenciesMeta:
      '@volar/language-service':
        optional: true
    dependencies:
      '@volar/language-service': 2.4.5
      vscode-html-languageservice: 5.3.1
      vscode-languageserver-textdocument: 1.0.12
      vscode-uri: 3.0.8
    dev: false

  /volar-service-prettier@0.0.61(@volar/language-service@2.4.5):
    resolution: {integrity: sha512-F612nql5I0IS8HxXemCGvOR2Uxd4XooIwqYVUvk7WSBxP/+xu1jYvE3QJ7EVpl8Ty3S4SxPXYiYTsG3bi+gzIQ==}
    peerDependencies:
      '@volar/language-service': ~2.4.0
      prettier: ^2.2 || ^3.0
    peerDependenciesMeta:
      '@volar/language-service':
        optional: true
      prettier:
        optional: true
    dependencies:
      '@volar/language-service': 2.4.5
      vscode-uri: 3.0.8
    dev: false

  /volar-service-typescript-twoslash-queries@0.0.61(@volar/language-service@2.4.5):
    resolution: {integrity: sha512-99FICGrEF0r1E2tV+SvprHPw9Knyg7BdW2fUch0tf59kG+KG+Tj4tL6tUg+cy8f23O/VXlmsWFMIE+bx1dXPnQ==}
    peerDependencies:
      '@volar/language-service': ~2.4.0
    peerDependenciesMeta:
      '@volar/language-service':
        optional: true
    dependencies:
      '@volar/language-service': 2.4.5
      vscode-uri: 3.0.8
    dev: false

  /volar-service-typescript@0.0.61(@volar/language-service@2.4.5):
    resolution: {integrity: sha512-4kRHxVbW7wFBHZWRU6yWxTgiKETBDIJNwmJUAWeP0mHaKpnDGj/astdRFKqGFRYVeEYl45lcUPhdJyrzanjsdQ==}
    peerDependencies:
      '@volar/language-service': ~2.4.0
    peerDependenciesMeta:
      '@volar/language-service':
        optional: true
    dependencies:
      '@volar/language-service': 2.4.5
      path-browserify: 1.0.1
      semver: 7.6.3
      typescript-auto-import-cache: 0.3.3
      vscode-languageserver-textdocument: 1.0.12
      vscode-nls: 5.2.0
      vscode-uri: 3.0.8
    dev: false

  /volar-service-yaml@0.0.61(@volar/language-service@2.4.5):
    resolution: {integrity: sha512-L+gbDiLDQQ1rZUbJ3mf3doDsoQUa8OZM/xdpk/unMg1Vz24Zmi2Ign8GrZyBD7bRoIQDwOH9gdktGDKzRPpUNw==}
    peerDependencies:
      '@volar/language-service': ~2.4.0
    peerDependenciesMeta:
      '@volar/language-service':
        optional: true
    dependencies:
      '@volar/language-service': 2.4.5
      vscode-uri: 3.0.8
      yaml-language-server: 1.15.0
    dev: false

  /vscode-css-languageservice@6.3.1:
    resolution: {integrity: sha512-1BzTBuJfwMc3A0uX4JBdJgoxp74cjj4q2mDJdp49yD/GuAq4X0k5WtK6fNcMYr+FfJ9nqgR6lpfCSZDkARJ5qQ==}
    dependencies:
      '@vscode/l10n': 0.0.18
      vscode-languageserver-textdocument: 1.0.12
      vscode-languageserver-types: 3.17.5
      vscode-uri: 3.0.8
    dev: false

  /vscode-html-languageservice@5.3.1:
    resolution: {integrity: sha512-ysUh4hFeW/WOWz/TO9gm08xigiSsV/FOAZ+DolgJfeLftna54YdmZ4A+lIn46RbdO3/Qv5QHTn1ZGqmrXQhZyA==}
    dependencies:
      '@vscode/l10n': 0.0.18
      vscode-languageserver-textdocument: 1.0.12
      vscode-languageserver-types: 3.17.5
      vscode-uri: 3.0.8
    dev: false

  /vscode-json-languageservice@4.1.8:
    resolution: {integrity: sha512-0vSpg6Xd9hfV+eZAaYN63xVVMOTmJ4GgHxXnkLCh+9RsQBkWKIghzLhW2B9ebfG+LQQg8uLtsQ2aUKjTgE+QOg==}
    engines: {npm: '>=7.0.0'}
    dependencies:
      jsonc-parser: 3.3.1
      vscode-languageserver-textdocument: 1.0.12
      vscode-languageserver-types: 3.17.5
      vscode-nls: 5.2.0
      vscode-uri: 3.0.8
    dev: false

  /vscode-jsonrpc@6.0.0:
    resolution: {integrity: sha512-wnJA4BnEjOSyFMvjZdpiOwhSq9uDoK8e/kpRJDTaMYzwlkrhG1fwDIZI94CLsLzlCK5cIbMMtFlJlfR57Lavmg==}
    engines: {node: '>=8.0.0 || >=10.0.0'}
    dev: false

  /vscode-jsonrpc@8.2.0:
    resolution: {integrity: sha512-C+r0eKJUIfiDIfwJhria30+TYWPtuHJXHtI7J0YlOmKAo7ogxP20T0zxB7HZQIFhIyvoBPwWskjxrvAtfjyZfA==}
    engines: {node: '>=14.0.0'}
    dev: false

  /vscode-languageserver-protocol@3.16.0:
    resolution: {integrity: sha512-sdeUoAawceQdgIfTI+sdcwkiK2KU+2cbEYA0agzM2uqaUy2UpnnGHtWTHVEtS0ES4zHU0eMFRGN+oQgDxlD66A==}
    dependencies:
      vscode-jsonrpc: 6.0.0
      vscode-languageserver-types: 3.16.0
    dev: false

  /vscode-languageserver-protocol@3.17.5:
    resolution: {integrity: sha512-mb1bvRJN8SVznADSGWM9u/b07H7Ecg0I3OgXDuLdn307rl/J3A9YD6/eYOssqhecL27hK1IPZAsaqh00i/Jljg==}
    dependencies:
      vscode-jsonrpc: 8.2.0
      vscode-languageserver-types: 3.17.5
    dev: false

  /vscode-languageserver-textdocument@1.0.12:
    resolution: {integrity: sha512-cxWNPesCnQCcMPeenjKKsOCKQZ/L6Tv19DTRIGuLWe32lyzWhihGVJ/rcckZXJxfdKCFvRLS3fpBIsV/ZGX4zA==}
    dev: false

  /vscode-languageserver-types@3.16.0:
    resolution: {integrity: sha512-k8luDIWJWyenLc5ToFQQMaSrqCHiLwyKPHKPQZ5zz21vM+vIVUSvsRpcbiECH4WR88K2XZqc4ScRcZ7nk/jbeA==}
    dev: false

  /vscode-languageserver-types@3.17.5:
    resolution: {integrity: sha512-Ld1VelNuX9pdF39h2Hgaeb5hEZM2Z3jUrrMgWQAu82jMtZp7p3vJT3BzToKtZI7NgQssZje5o0zryOrhQvzQAg==}
    dev: false

  /vscode-languageserver@7.0.0:
    resolution: {integrity: sha512-60HTx5ID+fLRcgdHfmz0LDZAXYEV68fzwG0JWwEPBode9NuMYTIxuYXPg4ngO8i8+Ou0lM7y6GzaYWbiDL0drw==}
    hasBin: true
    dependencies:
      vscode-languageserver-protocol: 3.16.0
    dev: false

  /vscode-languageserver@9.0.1:
    resolution: {integrity: sha512-woByF3PDpkHFUreUa7Hos7+pUWdeWMXRd26+ZX2A8cFx6v/JPTtd4/uN0/jB6XQHYaOlHbio03NTHCqrgG5n7g==}
    hasBin: true
    dependencies:
      vscode-languageserver-protocol: 3.17.5
    dev: false

  /vscode-nls@5.2.0:
    resolution: {integrity: sha512-RAaHx7B14ZU04EU31pT+rKz2/zSl7xMsfIZuo8pd+KZO6PXtQmpevpq3vxvWNcrGbdmhM/rr5Uw5Mz+NBfhVng==}
    dev: false

  /vscode-uri@2.1.2:
    resolution: {integrity: sha512-8TEXQxlldWAuIODdukIb+TR5s+9Ds40eSJrw+1iDDA9IFORPjMELarNQE3myz5XIkWWpdprmJjm1/SxMlWOC8A==}
    dev: false

  /vscode-uri@3.0.8:
    resolution: {integrity: sha512-AyFQ0EVmsOZOlAnxoFOGOq1SQDWAB7C6aqMGS23svWAllfOaxbuFvcT8D1i8z3Gyn8fraVeZNNmN6e9bxxXkKw==}
    dev: false

  /vue@3.5.8(typescript@5.6.2):
    resolution: {integrity: sha512-hvuvuCy51nP/1fSRvrrIqTLSvrSyz2Pq+KQ8S8SXCxTWVE0nMaOnSDnSOxV1eYmGfvK7mqiwvd1C59CEEz7dAQ==}
    peerDependencies:
      typescript: '*'
    peerDependenciesMeta:
      typescript:
        optional: true
    dependencies:
      '@vue/compiler-dom': 3.5.8
      '@vue/compiler-sfc': 3.5.8
      '@vue/runtime-dom': 3.5.8
      '@vue/server-renderer': 3.5.8(vue@3.5.8)
      '@vue/shared': 3.5.8
      typescript: 5.6.2
    dev: false

  /web-namespaces@2.0.1:
    resolution: {integrity: sha512-bKr1DkiNa2krS7qxNtdrtHAmzuYGFQLiQ13TsorsdT6ULTkPLKuu5+GsFpDlg6JFjUTwX2DyhMPG2be8uPrqsQ==}
    dev: false

  /webidl-conversions@3.0.1:
    resolution: {integrity: sha512-2JAn3z8AR6rjK8Sm8orRC0h/bcl/DqL7tRPdGZ4I1CjdF+EaMLmYxBHyXuKL849eucPFhvBoxMsflfOb8kxaeQ==}
    dev: false

  /whatwg-url@5.0.0:
    resolution: {integrity: sha512-saE57nupxk6v3HY35+jzBwYa0rKSy0XR8JSxZPwgLr7ys0IBzhGviA1/TUGJLmSVqs8pb9AnvICXEuOHLprYTw==}
    dependencies:
      tr46: 0.0.3
      webidl-conversions: 3.0.1
    dev: false

  /which-pm-runs@1.1.0:
    resolution: {integrity: sha512-n1brCuqClxfFfq/Rb0ICg9giSZqCS+pLtccdag6C2HyufBrh3fBOiy9nb6ggRMvWOVH5GrdJskj5iGTZNxd7SA==}
    engines: {node: '>=4'}
    dev: false

  /which-pm@3.0.0:
    resolution: {integrity: sha512-ysVYmw6+ZBhx3+ZkcPwRuJi38ZOTLJJ33PSHaitLxSKUMsh0LkKd0nC69zZCwt5D+AYUcMK2hhw4yWny20vSGg==}
    engines: {node: '>=18.12'}
    dependencies:
      load-yaml-file: 0.2.0
    dev: false

  /which@2.0.2:
    resolution: {integrity: sha512-BLI3Tl1TW3Pvl70l3yq3Y64i+awpwXqsGBYWkkqMtnbXgrMD+yj7rhW0kuEDxzJaYXGjEW5ogapKNMEKNMjibA==}
    engines: {node: '>= 8'}
    hasBin: true
    dependencies:
      isexe: 2.0.0
    dev: false

  /widest-line@4.0.1:
    resolution: {integrity: sha512-o0cyEG0e8GPzT4iGHphIOh0cJOV8fivsXxddQasHPHfoZf1ZexrfeA21w2NaEN1RHE+fXlfISmOE8R9N3u3Qig==}
    engines: {node: '>=12'}
    dependencies:
      string-width: 5.1.2
    dev: false

  /wrap-ansi@7.0.0:
    resolution: {integrity: sha512-YVGIj2kamLSTxw6NsZjoBxfSwsn0ycdesmc4p+Q21c5zPuZ1pl+NfxVdxPtdHvmNVOQ6XSYG4AUtyt/Fi7D16Q==}
    engines: {node: '>=10'}
    dependencies:
      ansi-styles: 4.3.0
      string-width: 4.2.3
      strip-ansi: 6.0.1
    dev: false

  /wrap-ansi@8.1.0:
    resolution: {integrity: sha512-si7QWI6zUMq56bESFvagtmzMdGOtoxfR+Sez11Mobfc7tm+VkUckk9bW2UeffTGVUbOksxmSw0AA2gs8g71NCQ==}
    engines: {node: '>=12'}
    dependencies:
      ansi-styles: 6.2.1
      string-width: 5.1.2
      strip-ansi: 7.1.0
    dev: false

  /wrappy@1.0.2:
    resolution: {integrity: sha512-l4Sp/DRseor9wL6EvV2+TuQn63dMkPjZ/sp9XkghTEbV9KlPS1xUsZ3u7/IQO4wxtcFB4bgpQPRcR3QCvezPcQ==}
    dev: false

  /xtend@4.0.2:
    resolution: {integrity: sha512-LKYU1iAXJXUgAXn9URjiu+MWhyUXHsvfp7mcuYm9dSUKK0/CjtrUwFAxD82/mCWbtLsGjFIad0wIsod4zrTAEQ==}
    engines: {node: '>=0.4'}
    dev: false

  /xxhash-wasm@1.0.2:
    resolution: {integrity: sha512-ibF0Or+FivM9lNrg+HGJfVX8WJqgo+kCLDc4vx6xMeTce7Aj+DLttKbxxRR/gNLSAelRc1omAPlJ77N/Jem07A==}
    dev: false

  /y18n@5.0.8:
    resolution: {integrity: sha512-0pfFzegeDWJHJIAmTLRP2DwHjdF5s7jo9tuztdQxAhINCdvS+3nGINqPd00AphqJR/0LhANUS6/+7SCb98YOfA==}
    engines: {node: '>=10'}
    dev: false

  /yallist@3.1.1:
    resolution: {integrity: sha512-a4UGQaWPH59mOXUYnAG2ewncQS4i4F43Tv3JoAM+s2VDAmS9NsK8GpDMLrCHPksFT7h3K6TOoUNn2pb7RoXx4g==}
    dev: false

  /yallist@4.0.0:
    resolution: {integrity: sha512-3wdGidZyq5PB084XLES5TpOSRA3wjXAlIWMhum2kRcv/41Sn2emQ0dycQW4uZXLejwKvg6EsvbdlVL+FYEct7A==}
    dev: false

  /yaml-language-server@1.15.0:
    resolution: {integrity: sha512-N47AqBDCMQmh6mBLmI6oqxryHRzi33aPFPsJhYy3VTUGCdLHYjGh4FZzpUjRlphaADBBkDmnkM/++KNIOHi5Rw==}
    hasBin: true
    dependencies:
      ajv: 8.17.1
      lodash: 4.17.21
      request-light: 0.5.8
      vscode-json-languageservice: 4.1.8
      vscode-languageserver: 7.0.0
      vscode-languageserver-textdocument: 1.0.12
      vscode-languageserver-types: 3.17.5
      vscode-nls: 5.2.0
      vscode-uri: 3.0.8
      yaml: 2.2.2
    optionalDependencies:
      prettier: 2.8.7
    dev: false

  /yaml@2.2.2:
    resolution: {integrity: sha512-CBKFWExMn46Foo4cldiChEzn7S7SRV+wqiluAb6xmueD/fGyRHIhX8m14vVGgeFWjN540nKCNVj6P21eQjgTuA==}
    engines: {node: '>= 14'}
    dev: false

  /yaml@2.5.1:
    resolution: {integrity: sha512-bLQOjaX/ADgQ20isPJRvF0iRUHIxVhYvr53Of7wGcWlO2jvtUlH5m87DsmulFVxRpNLOnI4tB6p/oh8D7kpn9Q==}
    engines: {node: '>= 14'}
    hasBin: true
    dev: false

  /yargs-parser@21.1.1:
    resolution: {integrity: sha512-tVpsJW7DdjecAiFpbIB1e3qxIQsE6NoPc5/eTdrbbIC4h0LVsWhnoa3g+m2HclBIujHzsxZ4VJVA+GUuc2/LBw==}
    engines: {node: '>=12'}
    dev: false

  /yargs@17.7.2:
    resolution: {integrity: sha512-7dSzzRQ++CKnNI/krKnYRV7JKKPUXMEh61soaHKg9mrWEhzFWhFnxPxGl+69cD1Ou63C13NUPCnmIcrvqCuM6w==}
    engines: {node: '>=12'}
    dependencies:
      cliui: 8.0.1
      escalade: 3.2.0
      get-caller-file: 2.0.5
      require-directory: 2.1.1
      string-width: 4.2.3
      y18n: 5.0.8
      yargs-parser: 21.1.1
    dev: false

  /yocto-queue@1.1.1:
    resolution: {integrity: sha512-b4JR1PFR10y1mKjhHY9LaGo6tmrgjit7hxVIeAmyMw3jegXR4dhYqLaQF5zMXZxY7tLpMyJeLjr1C4rLmkVe8g==}
    engines: {node: '>=12.20'}
    dev: false

  /zod-to-json-schema@3.23.3(zod@3.23.8):
    resolution: {integrity: sha512-TYWChTxKQbRJp5ST22o/Irt9KC5nj7CdBKYB/AosCRdj/wxEMvv4NNaj9XVUHDOIp53ZxArGhnw5HMZziPFjog==}
    peerDependencies:
      zod: ^3.23.3
    dependencies:
      zod: 3.23.8
    dev: false

  /zod-to-ts@1.2.0(typescript@5.6.2)(zod@3.23.8):
    resolution: {integrity: sha512-x30XE43V+InwGpvTySRNz9kB7qFU8DlyEy7BsSTCHPH1R0QasMmHWZDCzYm6bVXtj/9NNJAZF3jW8rzFvH5OFA==}
    peerDependencies:
      typescript: ^4.9.4 || ^5.0.2
      zod: ^3
    dependencies:
      typescript: 5.6.2
      zod: 3.23.8
    dev: false

  /zod@3.23.8:
    resolution: {integrity: sha512-XBx9AXhXktjUqnepgTiE5flcKIYWi/rme0Eaj+5Y0lftuGBq+jyRu/md4WnuxqgP1ubdpNCsYEYPxrzVHD8d6g==}
    dev: false

  /zwitch@2.0.4:
    resolution: {integrity: sha512-bXE4cR/kVZhKZX/RjPEflHaKVhUVl85noU3v6b8apfQEc1x4A+zBxjZ4lN8LqGd6WZ3dl98pY4o717VFmoPp+A==}
    dev: false

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/tailwind.config.mjs
```
/** @type {import('tailwindcss').Config} */
module.exports = {
	darkMode: ["class", '[data-kb-theme="dark"]'],
	content: ["./src/**/*.{tsx,astro}"],
	prefix: "",
	theme: {
		container: {
			center: true,
			padding: "2rem",
			screens: {
				"2xl": "1400px",
			},
		},
		extend: {
			colors: {
				border: "hsl(var(--border))",
				input: "hsl(var(--input))",
				ring: "hsl(var(--ring))",
				background: "hsl(var(--background))",
				foreground: "hsl(var(--foreground))",
				primary: {
					DEFAULT: "hsl(var(--primary))",
					foreground: "hsl(var(--primary-foreground))",
				},
				secondary: {
					DEFAULT: "hsl(var(--secondary))",
					foreground: "hsl(var(--secondary-foreground))",
				},
				destructive: {
					DEFAULT: "hsl(var(--destructive))",
					foreground: "hsl(var(--destructive-foreground))",
				},
				muted: {
					DEFAULT: "hsl(var(--muted))",
					foreground: "hsl(var(--muted-foreground))",
				},
				accent: {
					DEFAULT: "hsl(var(--accent))",
					foreground: "hsl(var(--accent-foreground))",
				},
				popover: {
					DEFAULT: "hsl(var(--popover))",
					foreground: "hsl(var(--popover-foreground))",
				},
				card: {
					DEFAULT: "hsl(var(--card))",
					foreground: "hsl(var(--card-foreground))",
				},
			},
			borderRadius: {
				lg: "var(--radius)",
				md: "calc(var(--radius) - 2px)",
				sm: "calc(var(--radius) - 4px)",
			},
			keyframes: {
				"accordion-down": {
					from: { height: 0 },
					to: { height: "var(--kb-accordion-content-height)" },
				},
				"accordion-up": {
					from: { height: "var(--kb-accordion-content-height)" },
					to: { height: 0 },
				},
				"collapsible-down": {
					from: { height: 0 },
					to: { height: "var(--kb-collapsible-content-height)" },
				},
				"collapsible-up": {
					from: { height: "var(--kb-collapsible-content-height)" },
					to: { height: 0 },
				},
				"caret-blink": {
					"0%,70%,100%": { opacity: "1" },
					"20%,50%": { opacity: "0" },
				},
			},
			animation: {
				"accordion-down": "accordion-down 0.2s ease-out",
				"accordion-up": "accordion-up 0.2s ease-out",
				"collapsible-down": "collapsible-down 0.2s ease-out",
				"collapsible-up": "collapsible-up 0.2s ease-out",
				"caret-blink": "caret-blink 1.25s ease-out infinite",
			},
		},
	},
	plugins: [require("tailwindcss-animate")],
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/tsconfig.json
```json
{
	"extends": "astro/tsconfigs/strict",
	"compilerOptions": {
		"jsx": "preserve",
		"jsxImportSource": "solid-js",
		"baseUrl": "./",
		"paths": {
			"@/*": ["./src/*"]
		}
	}
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/public/favicon.svg
```
<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 128 128">
    <path d="M50.4 78.5a75.1 75.1 0 0 0-28.5 6.9l24.2-65.7c.7-2 1.9-3.2 3.4-3.2h29c1.5 0 2.7 1.2 3.4 3.2l24.2 65.7s-11.6-7-28.5-7L67 45.5c-.4-1.7-1.6-2.8-2.9-2.8-1.3 0-2.5 1.1-2.9 2.7L50.4 78.5Zm-1.1 28.2Zm-4.2-20.2c-2 6.6-.6 15.8 4.2 20.2a17.5 17.5 0 0 1 .2-.7 5.5 5.5 0 0 1 5.7-4.5c2.8.1 4.3 1.5 4.7 4.7.2 1.1.2 2.3.2 3.5v.4c0 2.7.7 5.2 2.2 7.4a13 13 0 0 0 5.7 4.9v-.3l-.2-.3c-1.8-5.6-.5-9.5 4.4-12.8l1.5-1a73 73 0 0 0 3.2-2.2 16 16 0 0 0 6.8-11.4c.3-2 .1-4-.6-6l-.8.6-1.6 1a37 37 0 0 1-22.4 2.7c-5-.7-9.7-2-13.2-6.2Z" />
    <style>
        path { fill: #000; }
        @media (prefers-color-scheme: dark) {
            path { fill: #FFF; }
        }
    </style>
</svg>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/app.css
```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
	:root {
		--background: 0 0% 100%;
		--foreground: 20 14.3% 4.1%;

		--card: 0 0% 100%;
		--card-foreground: 20 14.3% 4.1%;

		--popover: 0 0% 100%;
		--popover-foreground: 20 14.3% 4.1%;

		--primary: 24 9.8% 10%;
		--primary-foreground: 60 9.1% 97.8%;

		--secondary: 60 4.8% 95.9%;
		--secondary-foreground: 24 9.8% 10%;

		--muted: 60 4.8% 95.9%;
		--muted-foreground: 25 5.3% 44.7%;

		--accent: 60 4.8% 95.9%;
		--accent-foreground: 24 9.8% 10%;

		--destructive: 0 84.2% 60.2%;
		--destructive-foreground: 60 9.1% 97.8%;

		--border: 20 5.9% 90%;
		--input: 20 5.9% 90%;
		--ring: 20 14.3% 4.1%;

		--radius: 0.5rem;
	}

	[data-kb-theme="dark"] {
		--background: 20 14.3% 4.1%;
		--foreground: 60 9.1% 97.8%;

		--card: 20 14.3% 4.1%;
		--card-foreground: 60 9.1% 97.8%;

		--popover: 20 14.3% 4.1%;
		--popover-foreground: 60 9.1% 97.8%;

		--primary: 60 9.1% 97.8%;
		--primary-foreground: 24 9.8% 10%;

		--secondary: 12 6.5% 15.1%;
		--secondary-foreground: 60 9.1% 97.8%;

		--muted: 12 6.5% 15.1%;
		--muted-foreground: 24 5.4% 63.9%;

		--accent: 12 6.5% 15.1%;
		--accent-foreground: 60 9.1% 97.8%;

		--destructive: 0 62.8% 30.6%;
		--destructive-foreground: 60 9.1% 97.8%;

		--border: 12 6.5% 15.1%;
		--input: 12 6.5% 15.1%;
		--ring: 24 5.7% 82.9%;
	}
}

@layer base {
	* {
		@apply border-border;
	}
	body {
		@apply bg-background text-foreground;
	}
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/auth.ts
```typescript
import { betterAuth } from "better-auth";
import { passkey } from "better-auth/plugins/passkey";
import { twoFactor } from "better-auth/plugins";
import Database from "better-sqlite3";

export const auth = betterAuth({
	database: new Database("./db.sqlite"),
	account: {
		accountLinking: {
			enabled: true,
			trustedProviders: ["google"],
		},
	},
	emailAndPassword: {
		enabled: true,
	},
	socialProviders: {
		google: {
			clientId: import.meta.env.GOOGLE_CLIENT_ID!,
			clientSecret: import.meta.env.GOOGLE_CLIENT_SECRET!,
		},
		github: {
			clientId: import.meta.env.GITHUB_CLIENT_ID!,
			clientSecret: import.meta.env.GITHUB_CLIENT_SECRET!,
		},
	},
	plugins: [
		passkey(),
		twoFactor({
			otpOptions: {
				async sendOTP(user, otp) {
					console.log(`Sending OTP to ${user.email}: ${otp}`);
					// await resend.emails.send({
					// 	from: "Acme <no-reply@demo.better-auth.com>",
					// 	to: user.email,
					// 	subject: "Your OTP",
					// 	html: `Your OTP is ${otp}`,
					// });
				},
			},
		}),
	],
	rateLimit: {
		enabled: true,
	},
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/env.d.ts
```typescript
/// <reference path="../.astro/types.d.ts" />

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/middleware.ts
```typescript
import { auth } from "@/auth";
import { defineMiddleware } from "astro:middleware";

// `context` and `next` are automatically typed
export const onRequest = defineMiddleware(async (context, next) => {
	const isAuthed = await auth.api
		.getSession({
			headers: context.request.headers,
		})
		.catch((e) => {
			return null;
		});
	if (context.url.pathname === "/dashboard" && !isAuthed) {
		return context.redirect("/");
	}
	return next();
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/libs/auth-client.ts
```typescript
import { passkeyClient, twoFactorClient } from "better-auth/client/plugins";
import { createAuthClient } from "better-auth/solid";
import { createAuthClient as createVanillaClient } from "better-auth/client";
export const {
	signIn,
	signOut,
	useSession,
	signUp,
	passkey: passkeyActions,
	useListPasskeys,
	twoFactor: twoFactorActions,
	$Infer,
	updateUser,
	changePassword,
	revokeSession,
	revokeSessions,
} = createAuthClient({
	baseURL:
		process.env.NODE_ENV === "development"
			? "http://localhost:3000"
			: undefined,
	plugins: [
		passkeyClient(),
		twoFactorClient({
			twoFactorPage: "/two-factor",
		}),
	],
});

export const { useSession: useVanillaSession } = createVanillaClient({
	baseURL:
		process.env.NODE_ENV === "development"
			? "http://localhost:3000"
			: undefined,
});

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/libs/cn.ts
```typescript
import type { ClassValue } from "clsx";
import clsx from "clsx";
import { twMerge } from "tailwind-merge";

export const cn = (...classLists: ClassValue[]) => twMerge(clsx(classLists));

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/libs/types.ts
```typescript
import type { $Infer } from "./auth-client";

export type ActiveSession = typeof $Infer.Session;

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/libs/utils.ts
```typescript
export async function convertImageToBase64(file: File): Promise<string> {
	return new Promise((resolve, reject) => {
		const reader = new FileReader();
		reader.onloadend = () => resolve(reader.result as string);
		reader.onerror = reject;
		reader.readAsDataURL(file);
	});
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/loader.tsx
```
export function Loader() {
	return (
		<svg
			xmlns="http://www.w3.org/2000/svg"
			width="1em"
			height="1em"
			viewBox="0 0 24 24"
			class="animate-spin"
		>
			<path
				fill="currentColor"
				d="M12 22c5.421 0 10-4.579 10-10h-2c0 4.337-3.663 8-8 8s-8-3.663-8-8s3.663-8 8-8V2C6.579 2 2 6.58 2 12c0 5.421 4.579 10 10 10"
			></path>
		</svg>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/sign-in.tsx
```
import {
	Card,
	CardContent,
	CardDescription,
	CardFooter,
	CardHeader,
	CardTitle,
} from "@/components/ui/card";
import { TextField, TextFieldLabel, TextFieldRoot } from "./ui/textfield";
import { Button } from "./ui/button";
import { Checkbox, CheckboxControl, CheckboxLabel } from "./ui/checkbox";
import { signIn } from "@/libs/auth-client";
import { createSignal } from "solid-js";

export function SignInCard() {
	const [email, setEmail] = createSignal("");
	const [password, setPassword] = createSignal("");
	const [rememberMe, setRememberMe] = createSignal(false);
	return (
		<Card class="max-w-max">
			<CardHeader>
				<CardTitle class="text-lg md:text-xl">Sign In</CardTitle>
				<CardDescription class="text-xs md:text-sm">
					Enter your email below to login to your account
				</CardDescription>
			</CardHeader>
			<CardContent>
				<div class="grid gap-4">
					<div class="grid gap-2">
						<TextFieldRoot class="w-full">
							<TextFieldLabel for="email">Email</TextFieldLabel>
							<TextField
								type="email"
								placeholder="Email"
								value={email()}
								onInput={(e) => {
									if ("value" in e.target) setEmail(e.target.value as string);
								}}
							/>
						</TextFieldRoot>
						<TextFieldRoot class="w-full">
							<div class="flex items-center justify-between">
								<TextFieldLabel for="password">Password</TextFieldLabel>
								<a
									href="/forget-password"
									class="ml-auto inline-block text-sm underline"
								>
									Forgot your password?
								</a>
							</div>
							<TextField
								type="password"
								placeholder="Password"
								value={password()}
								onInput={(e) => {
									if ("value" in e.target)
										setPassword(e.target.value as string);
								}}
							/>
						</TextFieldRoot>
						<Checkbox
							class="flex items-center gap-2 z-50"
							onChange={(e) => {
								setRememberMe(e);
							}}
							checked={rememberMe()}
						>
							<CheckboxControl />
							<CheckboxLabel class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
								Remember Me
							</CheckboxLabel>
						</Checkbox>
						<Button
							onclick={() => {
								signIn.email({
									email: email(),
									password: password(),
									rememberMe: rememberMe(),
									fetchOptions: {
										onError(context) {
											alert(context.error.message);
										},
									},
									callbackURL: "/",
								});
							}}
						>
							Sign In
						</Button>
						<Button class="gap-2" variant="outline">
							<svg
								xmlns="http://www.w3.org/2000/svg"
								width="1.2em"
								height="1.2em"
								viewBox="0 0 24 24"
							>
								<path
									fill="currentColor"
									d="M12 2A10 10 0 0 0 2 12c0 4.42 2.87 8.17 6.84 9.5c.5.08.66-.23.66-.5v-1.69c-2.77.6-3.36-1.34-3.36-1.34c-.46-1.16-1.11-1.47-1.11-1.47c-.91-.62.07-.6.07-.6c1 .07 1.53 1.03 1.53 1.03c.87 1.52 2.34 1.07 2.91.83c.09-.65.35-1.09.63-1.34c-2.22-.25-4.55-1.11-4.55-4.92c0-1.11.38-2 1.03-2.71c-.1-.25-.45-1.29.1-2.64c0 0 .84-.27 2.75 1.02c.79-.22 1.65-.33 2.5-.33s1.71.11 2.5.33c1.91-1.29 2.75-1.02 2.75-1.02c.55 1.35.2 2.39.1 2.64c.65.71 1.03 1.6 1.03 2.71c0 3.82-2.34 4.66-4.57 4.91c.36.31.69.92.69 1.85V21c0 .27.16.59.67.5C19.14 20.16 22 16.42 22 12A10 10 0 0 0 12 2"
								></path>
							</svg>
							Continue with GitHub
						</Button>
						<Button
							class="gap-2"
							variant="outline"
							onClick={async () => {
								await signIn.social({
									provider: "google",
									callbackURL: "/dashboard",
								});
							}}
						>
							<svg
								xmlns="http://www.w3.org/2000/svg"
								width="1.2em"
								height="1.2em"
								viewBox="0 0 512 512"
							>
								<path
									fill="currentColor"
									d="m473.16 221.48l-2.26-9.59H262.46v88.22H387c-12.93 61.4-72.93 93.72-121.94 93.72c-35.66 0-73.25-15-98.13-39.11a140.08 140.08 0 0 1-41.8-98.88c0-37.16 16.7-74.33 41-98.78s61-38.13 97.49-38.13c41.79 0 71.74 22.19 82.94 32.31l62.69-62.36C390.86 72.72 340.34 32 261.6 32c-60.75 0-119 23.27-161.58 65.71C58 139.5 36.25 199.93 36.25 256s20.58 113.48 61.3 155.6c43.51 44.92 105.13 68.4 168.58 68.4c57.73 0 112.45-22.62 151.45-63.66c38.34-40.4 58.17-96.3 58.17-154.9c0-24.67-2.48-39.32-2.59-39.96"
								></path>
							</svg>
							Continue with Google
						</Button>
						<Button
							class="gap-2"
							variant="outline"
							onClick={async () => {
								await signIn.passkey({
									fetchOptions: {
										onError(context) {
											alert(context.error.message);
										},
										onSuccess(context) {
											window.location.href = "/";
										},
									},
								});
							}}
						>
							<svg
								xmlns="http://www.w3.org/2000/svg"
								width="18"
								height="18"
								viewBox="0 0 24 24"
								fill="none"
								stroke="currentColor"
								strokeWidth="2"
								strokeLinecap="round"
								strokeLinejoin="round"
								class="lucide lucide-key"
							>
								<path d="m15.5 7.5 2.3 2.3a1 1 0 0 0 1.4 0l2.1-2.1a1 1 0 0 0 0-1.4L19 4" />
								<path d="m21 2-9.6 9.6" />
								<circle cx="7.5" cy="15.5" r="5.5" />
							</svg>
							Sign-In with Passkey
						</Button>
					</div>
					<p class="text-sm text-center">
						Don't have an account yet?{" "}
						<a
							href="/sign-up"
							class="text-blue-900 dark:text-orange-200 underline"
						>
							Sign Up
						</a>
					</p>
				</div>
			</CardContent>
			<CardFooter class="flex-col">
				<div class="flex justify-center w-full border-t py-4">
					<p class="text-center text-xs text-neutral-500">
						Secured by{" "}
						<span class="text-orange-900 dark:text-orange-200">
							better-auth.
						</span>
					</p>
				</div>
			</CardFooter>
		</Card>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/sign-up.tsx
```
import {
	Card,
	CardContent,
	CardDescription,
	CardFooter,
	CardHeader,
	CardTitle,
} from "@/components/ui/card";
import { TextField, TextFieldLabel, TextFieldRoot } from "./ui/textfield";
import { Button } from "./ui/button";
import { signUp } from "@/libs/auth-client";
import { createSignal } from "solid-js";
import { convertImageToBase64 } from "@/libs/utils";

export function SignUpCard() {
	const [firstName, setFirstName] = createSignal("");
	const [lastName, setLastName] = createSignal("");
	const [email, setEmail] = createSignal("");
	const [password, setPassword] = createSignal("");
	const [image, setImage] = createSignal<File>();
	const [rememberMe, setRememberMe] = createSignal(false);
	return (
		<Card>
			<CardHeader>
				<CardTitle class="text-lg md:text-xl">Sign Up</CardTitle>
				<CardDescription class="text-xs md:text-sm">
					Enter your information to create an account
				</CardDescription>
			</CardHeader>
			<CardContent>
				<div class="grid gap-4">
					<div class="grid gap-2">
						<div class="flex items-center gap-2">
							<TextFieldRoot class="w-full">
								<TextFieldLabel for="name">First Name</TextFieldLabel>
								<TextField
									type="first-name"
									placeholder="First Name"
									value={firstName()}
									onInput={(e) => {
										if ("value" in e.target)
											setFirstName(e.target.value as string);
									}}
								/>
							</TextFieldRoot>
							<TextFieldRoot class="w-full">
								<TextFieldLabel for="name">Last Name</TextFieldLabel>
								<TextField
									type="last-name"
									placeholder="Last Name"
									value={lastName()}
									onInput={(e) => {
										if ("value" in e.target)
											setLastName(e.target.value as string);
									}}
								/>
							</TextFieldRoot>
						</div>
						<TextFieldRoot class="w-full">
							<TextFieldLabel for="email">Email</TextFieldLabel>
							<TextField
								type="email"
								placeholder="Email"
								value={email()}
								onInput={(e) => {
									if ("value" in e.target) setEmail(e.target.value as string);
								}}
							/>
						</TextFieldRoot>
						<TextFieldRoot class="w-full">
							<TextFieldLabel for="password">Password</TextFieldLabel>
							<TextField
								type="password"
								placeholder="Password"
								value={password()}
								onInput={(e) => {
									if ("value" in e.target)
										setPassword(e.target.value as string);
								}}
							/>
						</TextFieldRoot>
						<TextFieldRoot>
							<TextFieldLabel>Image</TextFieldLabel>
							<TextField
								type="file"
								accept="image/*"
								placeholder="Image"
								onChange={(e: any) => {
									const file = e.target.files?.[0];
									if ("value" in e.target) setImage(file);
								}}
							/>
						</TextFieldRoot>
						<Button
							onclick={async () => {
								signUp.email({
									name: `${firstName()} ${lastName()}`,
									image: image()
										? await convertImageToBase64(image()!)
										: undefined,
									email: email(),
									password: password(),
									callbackURL: "/",
									fetchOptions: {
										onError(context) {
											alert(context.error.message);
										},
										onSuccess(context) {
											window.location.href = "/";
										},
									},
								});
							}}
						>
							Sign Up
						</Button>
						<Button class="gap-2" variant="outline">
							<svg
								xmlns="http://www.w3.org/2000/svg"
								width="1.2em"
								height="1.2em"
								viewBox="0 0 24 24"
							>
								<path
									fill="currentColor"
									d="M12 2A10 10 0 0 0 2 12c0 4.42 2.87 8.17 6.84 9.5c.5.08.66-.23.66-.5v-1.69c-2.77.6-3.36-1.34-3.36-1.34c-.46-1.16-1.11-1.47-1.11-1.47c-.91-.62.07-.6.07-.6c1 .07 1.53 1.03 1.53 1.03c.87 1.52 2.34 1.07 2.91.83c.09-.65.35-1.09.63-1.34c-2.22-.25-4.55-1.11-4.55-4.92c0-1.11.38-2 1.03-2.71c-.1-.25-.45-1.29.1-2.64c0 0 .84-.27 2.75 1.02c.79-.22 1.65-.33 2.5-.33s1.71.11 2.5.33c1.91-1.29 2.75-1.02 2.75-1.02c.55 1.35.2 2.39.1 2.64c.65.71 1.03 1.6 1.03 2.71c0 3.82-2.34 4.66-4.57 4.91c.36.31.69.92.69 1.85V21c0 .27.16.59.67.5C19.14 20.16 22 16.42 22 12A10 10 0 0 0 12 2"
								></path>
							</svg>
							Continue with GitHub
						</Button>
						<Button class="gap-2" variant="outline">
							<svg
								xmlns="http://www.w3.org/2000/svg"
								width="1.2em"
								height="1.2em"
								viewBox="0 0 512 512"
							>
								<path
									fill="currentColor"
									d="m473.16 221.48l-2.26-9.59H262.46v88.22H387c-12.93 61.4-72.93 93.72-121.94 93.72c-35.66 0-73.25-15-98.13-39.11a140.08 140.08 0 0 1-41.8-98.88c0-37.16 16.7-74.33 41-98.78s61-38.13 97.49-38.13c41.79 0 71.74 22.19 82.94 32.31l62.69-62.36C390.86 72.72 340.34 32 261.6 32c-60.75 0-119 23.27-161.58 65.71C58 139.5 36.25 199.93 36.25 256s20.58 113.48 61.3 155.6c43.51 44.92 105.13 68.4 168.58 68.4c57.73 0 112.45-22.62 151.45-63.66c38.34-40.4 58.17-96.3 58.17-154.9c0-24.67-2.48-39.32-2.59-39.96"
								></path>
							</svg>
							Continue with Google
						</Button>
					</div>
					<p class="text-sm text-center">
						Already have an account?{" "}
						<a href="/sign-in" class="text-blue-500">
							Sign In
						</a>
					</p>
				</div>
			</CardContent>
			<CardFooter class="flex-col">
				<div class="flex justify-center w-full border-t py-4">
					<p class="text-center text-xs text-neutral-500">
						Secured by{" "}
						<span class="text-orange-900 dark:text-orange-200">
							better-auth.
						</span>
					</p>
				</div>
			</CardFooter>
		</Card>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/two-factor.tsx
```
import { createEffect, createSignal, Show } from "solid-js";
import { Button } from "./ui/button";
import {
	Card,
	CardContent,
	CardDescription,
	CardHeader,
	CardTitle,
} from "./ui/card";
import {
	OTPField,
	OTPFieldGroup,
	OTPFieldInput,
	OTPFieldSlot,
} from "./ui/otp-field";
import { twoFactorActions } from "@/libs/auth-client";

export function TwoFactorComponent() {
	const [otp, setOTP] = createSignal("");

	createEffect(() => {
		if (otp().length === 6) {
			twoFactorActions.verifyTotp({
				code: otp(),
				fetchOptions: {
					onError(context) {
						if (context.error.status === 429) {
							const retryAfter = context.response.headers.get("X-Retry-After");
							alert(
								`Too many requests. Please try again after ${retryAfter} seconds`,
							);
						} else {
							alert(
								context.error.message ||
									context.error.statusText ||
									context.error.status,
							);
						}
					},
				},
			});
		}
	});
	return (
		<main class="flex flex-col items-center justify-center min-h-[calc(100vh-10rem)]">
			<Card class="w-[350px]">
				<CardHeader>
					<CardTitle>TOTP Verification</CardTitle>
					<CardDescription>
						Enter your 6-digit TOTP code to authenticate
					</CardDescription>
				</CardHeader>
				<CardContent>
					<div class="flex flex-col gap-2  items-center">
						<OTPField
							maxLength={6}
							value={otp()}
							onValueChange={(value) => {
								setOTP(value);
							}}
						>
							<OTPFieldInput />
							<OTPFieldGroup>
								<OTPFieldSlot index={0} />
								<OTPFieldSlot index={1} />
								<OTPFieldSlot index={2} />
								<OTPFieldSlot index={3} />
								<OTPFieldSlot index={4} />
								<OTPFieldSlot index={5} />
							</OTPFieldGroup>
						</OTPField>
						<span class="text-center text-xs">
							Enter your one-time password.
						</span>
					</div>
					<div class="flex justify-center">
						<a
							href="/two-factor/email"
							class="text-xs border-b pb-1 mt-2  w-max hover:border-black transition-all"
						>
							Switch to Email Verification
						</a>
					</div>
				</CardContent>
			</Card>
		</main>
	);
}

export function TwoFactorEmail() {
	const [otp, setOTP] = createSignal("");

	createEffect(() => {
		if (otp().length === 6) {
			twoFactorActions.verifyOtp({
				code: otp(),
				fetchOptions: {
					onError(context) {
						alert(context.error.message);
					},
					onSuccess(context) {
						window.location.href = "/dashboard";
					},
				},
			});
		}
	});
	const [sentEmail, setSentEmail] = createSignal(false);
	return (
		<main class="flex flex-col items-center justify-center min-h-[calc(100vh-10rem)]">
			<Card class="w-[350px]">
				<CardHeader>
					<CardTitle>Email Verification</CardTitle>
					<CardDescription>
						Enter your 6-digit TOTP code to authenticate
					</CardDescription>
				</CardHeader>
				<CardContent>
					<Show
						when={sentEmail()}
						fallback={
							<Button
								onClick={async () => {
									await twoFactorActions.sendOtp({
										fetchOptions: {
											onSuccess(context) {
												setSentEmail(true);
											},
											onError(context) {
												alert(context.error.message);
											},
										},
									});
								}}
								class="w-full gap-2"
							>
								<svg
									xmlns="http://www.w3.org/2000/svg"
									width="1.2em"
									height="1.2em"
									viewBox="0 0 24 24"
								>
									<path
										fill="currentColor"
										d="M4 20q-.825 0-1.412-.587T2 18V6q0-.825.588-1.412T4 4h16q.825 0 1.413.588T22 6v12q0 .825-.587 1.413T20 20zm8-7.175q.125 0 .263-.038t.262-.112L19.6 8.25q.2-.125.3-.312t.1-.413q0-.5-.425-.75T18.7 6.8L12 11L5.3 6.8q-.45-.275-.875-.012T4 7.525q0 .25.1.438t.3.287l7.075 4.425q.125.075.263.113t.262.037"
									></path>
								</svg>{" "}
								Send OTP to Email
							</Button>
						}
					>
						<div class="flex flex-col gap-2  items-center">
							<OTPField
								maxLength={6}
								value={otp()}
								onValueChange={(value) => {
									setOTP(value);
								}}
							>
								<OTPFieldInput />
								<OTPFieldGroup>
									<OTPFieldSlot index={0} />
									<OTPFieldSlot index={1} />
									<OTPFieldSlot index={2} />
									<OTPFieldSlot index={3} />
									<OTPFieldSlot index={4} />
									<OTPFieldSlot index={5} />
								</OTPFieldGroup>
							</OTPField>
							<span class="text-center text-xs">
								Enter your one-time password.
							</span>
						</div>
					</Show>
					<div class="flex justify-center">
						<a
							href="/two-factor"
							class="text-xs border-b pb-1 mt-2  w-max hover:border-black transition-all"
						>
							Switch to TOTP Verification
						</a>
					</div>
				</CardContent>
			</Card>
		</main>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/user-card.tsx
```
import {
	passkeyActions,
	signOut,
	twoFactorActions,
	useListPasskeys,
	useSession,
	revokeSession,
	updateUser,
} from "@/libs/auth-client";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { UAParser } from "ua-parser-js";
import { Image, ImageFallback, ImageRoot } from "./ui/image";
import type { Session, User } from "better-auth/types";
import { createEffect, createSignal, Show } from "solid-js";
import {
	Dialog,
	DialogContent,
	DialogDescription,
	DialogFooter,
	DialogHeader,
	DialogTitle,
	DialogTrigger,
} from "./ui/dialog";
import { Button } from "./ui/button";
import { TextField, TextFieldLabel, TextFieldRoot } from "./ui/textfield";
import { convertImageToBase64 } from "@/libs/utils";
import { Loader } from "./loader";
import {
	Table,
	TableBody,
	TableCell,
	TableHead,
	TableHeader,
	TableRow,
} from "./ui/table";
import type { ActiveSession } from "@/libs/types";

export function UserCard(props: {
	activeSessions: Session[];
	initialSession: ActiveSession | null;
}) {
	const activeSessions = props.activeSessions;
	const initialSession = props.initialSession;
	const [session, setSession] = createSignal(initialSession);
	const res = useSession();
	createEffect(() => {
		setSession(res().data);
	});
	return (
		<Card class="w-full">
			<CardHeader>
				<CardTitle>User</CardTitle>
			</CardHeader>
			<CardContent class="grid gap-8 grid-cols-1">
				<div class="flex items-start justify-between">
					<div class="flex items-center gap-4">
						<ImageRoot>
							<Image src={session()?.user.image} alt="picture" />
							<ImageFallback>{session()?.user.name.charAt(0)}</ImageFallback>
						</ImageRoot>
						<div class="grid gap-1">
							<p class="text-sm font-medium leading-none">
								{session()?.user.name}
							</p>
							<p class="text-sm">{session()?.user.email}</p>
						</div>
					</div>
					<EditUserDialog user={session()?.user} />
				</div>
				<div class="border-l-2 px-2 w-max gap-1 flex flex-col">
					<p class="text-xs font-medium ">Active Sessions</p>
					{activeSessions.map((activeSession) => {
						return (
							<div>
								<div class="flex items-center gap-2 text-sm  text-black font-medium dark:text-white">
									{new UAParser(activeSession.userAgent).getDevice().type ===
									"mobile" ? (
										<svg
											xmlns="http://www.w3.org/2000/svg"
											width="1em"
											height="1em"
											viewBox="0 0 24 24"
										>
											<path
												fill="currentColor"
												d="M15.5 1h-8A2.5 2.5 0 0 0 5 3.5v17A2.5 2.5 0 0 0 7.5 23h8a2.5 2.5 0 0 0 2.5-2.5v-17A2.5 2.5 0 0 0 15.5 1m-4 21c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5s1.5.67 1.5 1.5s-.67 1.5-1.5 1.5m4.5-4H7V4h9z"
											></path>
										</svg>
									) : (
										<svg
											xmlns="http://www.w3.org/2000/svg"
											width="1em"
											height="1em"
											viewBox="0 0 24 24"
										>
											<path
												fill="currentColor"
												d="M0 20v-2h4v-1q-.825 0-1.412-.587T2 15V5q0-.825.588-1.412T4 3h16q.825 0 1.413.588T22 5v10q0 .825-.587 1.413T20 17v1h4v2zm4-5h16V5H4zm0 0V5z"
											></path>
										</svg>
									)}
									{new UAParser(activeSession.userAgent).getOS().name},{" "}
									{new UAParser(activeSession.userAgent).getBrowser().name}
									<button
										class="text-red-500 opacity-80  cursor-pointer text-xs border-muted-foreground border-red-600  underline "
										onClick={async () => {
											const res = await revokeSession({
												id: activeSession.id,
											});

											if (res.error) {
												alert(res.error.message);
											} else {
												alert("Session terminated");
											}
										}}
									>
										{activeSession.id === session()?.session.id
											? "Sign Out"
											: "Terminate"}
									</button>
								</div>
							</div>
						);
					})}
				</div>
				<div class="flex items-center justify-between">
					<Button
						variant="outline"
						class="gap-2"
						onClick={async () => {
							await signOut();
							window.location.reload();
						}}
					>
						<svg
							xmlns="http://www.w3.org/2000/svg"
							width="1.2em"
							height="1.2em"
							viewBox="0 0 24 24"
						>
							<path
								fill="currentColor"
								d="M9 20.75H6a2.64 2.64 0 0 1-2.75-2.53V5.78A2.64 2.64 0 0 1 6 3.25h3a.75.75 0 0 1 0 1.5H6a1.16 1.16 0 0 0-1.25 1v12.47a1.16 1.16 0 0 0 1.25 1h3a.75.75 0 0 1 0 1.5Zm7-4a.74.74 0 0 1-.53-.22a.75.75 0 0 1 0-1.06L18.94 12l-3.47-3.47a.75.75 0 1 1 1.06-1.06l4 4a.75.75 0 0 1 0 1.06l-4 4a.74.74 0 0 1-.53.22"
							></path>
							<path
								fill="currentColor"
								d="M20 12.75H9a.75.75 0 0 1 0-1.5h11a.75.75 0 0 1 0 1.5"
							></path>
						</svg>
						Sign Out
					</Button>
					<div>
						<TwoFactorDialog enabled={session()?.user.twoFactorEnabled} />
					</div>
				</div>
				<div class="border-y py-4 flex items-center flex-wrap justify-between gap-2">
					<div class="flex flex-col gap-2">
						<p class="text-sm">Passkeys</p>
						<div class="flex gap-2 flex-wrap">
							<AddPasskeyDialog />
							<ListPasskeys />
						</div>
					</div>
				</div>
			</CardContent>
		</Card>
	);
}

function EditUserDialog(props: { user?: User }) {
	const user = props.user;
	const [isLoading, setIsLoading] = createSignal(false);
	const [image, setImage] = createSignal<File>();
	const [name, setName] = createSignal<string>();
	const [isOpen, setIsOpen] = createSignal(false);
	return (
		<Dialog onOpenChange={setIsOpen} open={isOpen()}>
			<DialogTrigger>
				<Button variant="secondary">Edit User</Button>
			</DialogTrigger>
			<DialogContent>
				<DialogHeader>
					<DialogTitle>Edit User</DialogTitle>
					<DialogDescription>Edit User Information</DialogDescription>
				</DialogHeader>
				<div class="grid gap-2">
					<TextFieldRoot>
						<TextFieldLabel for="full-name">Full Name</TextFieldLabel>
						<TextField
							placeholder={user?.name}
							type="text"
							value={name()}
							onInput={(e) => {
								if ("value" in e.target) setName(e.target.value as string);
							}}
						/>
					</TextFieldRoot>
					<TextFieldRoot>
						<TextFieldLabel>Profile Image</TextFieldLabel>
						<TextField
							type="file"
							onChange={(e: any) => {
								const file = e.target.files?.[0];
								if ("value" in e.target) setImage(file);
							}}
						/>
					</TextFieldRoot>
				</div>
				<DialogFooter>
					<Button
						onClick={async () => {
							setIsLoading(true);
							await updateUser({
								image: image()
									? await convertImageToBase64(image()!)
									: undefined,
								name: name(),
								fetchOptions: {
									onResponse(context) {
										setIsLoading(false);
									},
									onError(context) {
										alert(context.error.message);
									},
									onSuccess() {
										alert("User Updated Successfully");
										setIsOpen(false);
									},
								},
							});
						}}
					>
						<Show fallback={<p>Update</p>} when={isLoading()}>
							<Loader />
						</Show>
					</Button>
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
}

function AddPasskeyDialog() {
	const [name, setName] = createSignal("");
	const [isLoading, setIsLoading] = createSignal(false);
	return (
		<Dialog>
			<DialogTrigger>
				<Button variant="outline">Add Passkey</Button>
			</DialogTrigger>
			<DialogContent>
				<DialogHeader>
					<DialogTitle>Register New Passkey</DialogTitle>
					<DialogDescription>
						Add a new passkey to your account
					</DialogDescription>
				</DialogHeader>
				<div class="grid gap-2">
					<TextFieldRoot>
						<TextFieldLabel for="passkey-name">
							Passkey Name (optional)
						</TextFieldLabel>
						<TextField
							type="text"
							placeholder="My Passkey"
							value={name()}
							onInput={(e) => {
								if ("value" in e.target) setName(e.target.value as string);
							}}
						/>
					</TextFieldRoot>
				</div>
				<DialogFooter>
					<Button
						onClick={async () => {
							const res = await passkeyActions.addPasskey({
								name: name(),
								fetchOptions: {
									onSuccess() {
										alert("Successfully added");
										setName("");
									},
								},
							});
							if (res?.error) {
								alert(res.error.message);
							}
						}}
					>
						<Show
							when={isLoading()}
							fallback={
								<div class="flex items-center gap-2">
									<svg
										xmlns="http://www.w3.org/2000/svg"
										width="1.2em"
										height="1.2em"
										viewBox="0 0 24 24"
									>
										<path
											fill="currentColor"
											d="M3.25 9.65q-.175-.125-.213-.312t.113-.388q1.55-2.125 3.888-3.3t4.987-1.175q2.65 0 5 1.138T20.95 8.9q.175.225.113.4t-.213.3q-.15.125-.35.113t-.35-.213q-1.375-1.95-3.537-2.987t-4.588-1.038q-2.425 0-4.55 1.038T3.95 9.5q-.15.225-.35.25t-.35-.1m11.6 12.325q-2.6-.65-4.25-2.588T8.95 14.65q0-1.25.9-2.1t2.175-.85q1.275 0 2.175.85t.9 2.1q0 .825.625 1.388t1.475.562q.85 0 1.45-.562t.6-1.388q0-2.9-2.125-4.875T12.05 7.8q-2.95 0-5.075 1.975t-2.125 4.85q0 .6.113 1.5t.537 2.1q.075.225-.012.4t-.288.25q-.2.075-.387-.012t-.263-.288q-.375-.975-.537-1.937T3.85 14.65q0-3.325 2.413-5.575t5.762-2.25q3.375 0 5.8 2.25t2.425 5.575q0 1.25-.887 2.087t-2.163.838q-1.275 0-2.187-.837T14.1 14.65q0-.825-.612-1.388t-1.463-.562q-.85 0-1.463.563T9.95 14.65q0 2.425 1.438 4.05t3.712 2.275q.225.075.3.25t.025.375q-.05.175-.2.3t-.375.075M6.5 4.425q-.2.125-.4.063t-.3-.263q-.1-.2-.05-.362T6 3.575q1.4-.75 2.925-1.15t3.1-.4q1.6 0 3.125.388t2.95 1.112q.225.125.263.3t-.038.35q-.075.175-.25.275t-.425-.025q-1.325-.675-2.738-1.037t-2.887-.363q-1.45 0-2.85.338T6.5 4.425m2.95 17.2q-1.475-1.55-2.262-3.162T6.4 14.65q0-2.275 1.65-3.838t3.975-1.562q2.325 0 4 1.563T17.7 14.65q0 .225-.137.363t-.363.137q-.2 0-.35-.137t-.15-.363q0-1.875-1.388-3.137t-3.287-1.263q-1.9 0-3.262 1.263T7.4 14.65q0 2.025.7 3.438t2.05 2.837q.15.15.15.35t-.15.35q-.15.15-.35.15t-.35-.15m7.55-1.7q-2.225 0-3.863-1.5T11.5 14.65q0-.2.138-.35t.362-.15q.225 0 .363.15t.137.35q0 1.875 1.35 3.075t3.15 1.2q.15 0 .425-.025t.575-.075q.225-.05.388.063t.212.337q.05.2-.075.35t-.325.2q-.45.125-.787.138t-.413.012"
										></path>
									</svg>
									Add Passkey
								</div>
							}
						>
							<Loader />
						</Show>
					</Button>
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
}

function ListPasskeys() {
	const passkeys = useListPasskeys();
	const [isDeletePasskey, setIsDeletePasskey] = createSignal(false);
	return (
		<Dialog>
			<DialogTrigger>
				<Button variant="outline">
					Passkeys{" "}
					{passkeys().data?.length ? `[${passkeys().data?.length}]` : ""}
				</Button>
			</DialogTrigger>
			<DialogContent>
				<DialogHeader>
					<DialogTitle>Passkeys</DialogTitle>
					<DialogDescription>List of passkeys</DialogDescription>
				</DialogHeader>
				{passkeys().data?.length ? (
					<Table>
						<TableHeader>
							<TableRow>
								<TableHead>Name</TableHead>
							</TableRow>
						</TableHeader>
						<TableBody>
							{passkeys().data?.map((passkey) => (
								<TableRow class="flex  justify-between items-center">
									<TableCell>{passkey.name || "My Passkey"}</TableCell>
									<TableCell class="text-right">
										<button
											onClick={async () => {
												const res = await passkeyActions.deletePasskey({
													id: passkey.id,
													fetchOptions: {
														onRequest: () => {
															setIsDeletePasskey(true);
														},
														onSuccess: () => {
															alert("Passkey deleted successfully");
															setIsDeletePasskey(false);
														},
														onError: (error) => {
															alert(error.error.message);
															setIsDeletePasskey(false);
														},
													},
												});
											}}
										>
											<Show
												when={isDeletePasskey()}
												fallback={
													<svg
														xmlns="http://www.w3.org/2000/svg"
														width="1em"
														height="1em"
														viewBox="0 0 24 24"
													>
														<path
															fill="currentColor"
															d="M5 21V6H4V4h5V3h6v1h5v2h-1v15zm2-2h10V6H7zm2-2h2V8H9zm4 0h2V8h-2zM7 6v13z"
														></path>
													</svg>
												}
											>
												<Loader />
											</Show>
										</button>
									</TableCell>
								</TableRow>
							))}
						</TableBody>
					</Table>
				) : (
					<p class="text-sm text-muted-foreground">No passkeys found</p>
				)}
			</DialogContent>
		</Dialog>
	);
}

function TwoFactorDialog(props: { enabled?: boolean }) {
	const [isOpen, setIsOpen] = createSignal(false);
	const [password, setPassword] = createSignal<string>();
	const [isLoading, setIsLoading] = createSignal(false);
	return (
		<Dialog onOpenChange={setIsOpen} open={isOpen()}>
			<DialogTrigger>
				<Button variant="secondary">
					{props.enabled ? "Disable 2FA" : "Enable 2FA"}
				</Button>
			</DialogTrigger>
			<DialogContent>
				<DialogHeader>
					<DialogTitle>Enable Two Factor</DialogTitle>
					<DialogDescription>
						Enable two factor authentication
					</DialogDescription>
				</DialogHeader>
				<div class="grid gap-2">
					<TextFieldRoot>
						<TextFieldLabel for="password">Password</TextFieldLabel>
						<TextField
							type="password"
							placeholder="Password"
							value={password()}
							onInput={(e) => {
								if ("value" in e.target) setPassword(e.target.value as string);
							}}
						/>
					</TextFieldRoot>
				</div>
				<DialogFooter>
					<Button
						onClick={async () => {
							if (!password()) {
								alert("Password is required!");
							}
							setIsLoading(true);
							if (props.enabled) {
								await twoFactorActions.disable({
									password: password()!,
									fetchOptions: {
										onResponse(context) {
											setIsLoading(false);
										},
										onError(context) {
											alert(context.error.message);
										},
										onSuccess() {
											alert("Two factor is disabled!");
											setIsOpen(false);
										},
									},
								});
								return;
							}
							await twoFactorActions.enable({
								password: password()!,
								fetchOptions: {
									onResponse(context) {
										setIsLoading(false);
									},
									onError(context) {
										alert(context.error.message);
									},
									onSuccess() {
										alert("Two factor successfully enabled!");
										setIsOpen(false);
									},
								},
							});
						}}
					>
						<Show
							fallback={<p>{props.enabled ? "Disable" : "Enable"}</p>}
							when={isLoading()}
						>
							<Loader />
						</Show>
					</Button>
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
}

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/accordion.tsx
```
import { cn } from "@/libs/cn";
import type {
	AccordionContentProps,
	AccordionItemProps,
	AccordionTriggerProps,
} from "@kobalte/core/accordion";
import { Accordion as AccordionPrimitive } from "@kobalte/core/accordion";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import { type ParentProps, type ValidComponent, splitProps } from "solid-js";

export const Accordion = AccordionPrimitive;

type accordionItemProps<T extends ValidComponent = "div"> =
	AccordionItemProps<T> & {
		class?: string;
	};

export const AccordionItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, accordionItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as accordionItemProps, ["class"]);

	return (
		<AccordionPrimitive.Item class={cn("border-b", local.class)} {...rest} />
	);
};

type accordionTriggerProps<T extends ValidComponent = "button"> = ParentProps<
	AccordionTriggerProps<T> & {
		class?: string;
	}
>;

export const AccordionTrigger = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, accordionTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as accordionTriggerProps, [
		"class",
		"children",
	]);

	return (
		<AccordionPrimitive.Header class="flex" as="div">
			<AccordionPrimitive.Trigger
				class={cn(
					"flex flex-1 items-center justify-between py-4 text-sm font-medium transition-shadow hover:underline focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring [&[data-expanded]>svg]:rotate-180",
					local.class,
				)}
				{...rest}
			>
				{local.children}
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-4 w-4 text-muted-foreground transition-transform duration-200"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m6 9l6 6l6-6"
					/>
					<title>Arrow</title>
				</svg>
			</AccordionPrimitive.Trigger>
		</AccordionPrimitive.Header>
	);
};

type accordionContentProps<T extends ValidComponent = "div"> = ParentProps<
	AccordionContentProps<T> & {
		class?: string;
	}
>;

export const AccordionContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, accordionContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as accordionContentProps, [
		"class",
		"children",
	]);

	return (
		<AccordionPrimitive.Content
			class={cn(
				"animate-accordion-up overflow-hidden text-sm data-[expanded]:animate-accordion-down",
				local.class,
			)}
			{...rest}
		>
			<div class="pb-4 pt-0">{local.children}</div>
		</AccordionPrimitive.Content>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/alert-dialog.tsx
```
import { cn } from "@/libs/cn";
import type {
	AlertDialogCloseButtonProps,
	AlertDialogContentProps,
	AlertDialogDescriptionProps,
	AlertDialogTitleProps,
} from "@kobalte/core/alert-dialog";
import { AlertDialog as AlertDialogPrimitive } from "@kobalte/core/alert-dialog";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ComponentProps, ParentProps, ValidComponent } from "solid-js";
import { splitProps } from "solid-js";
import { buttonVariants } from "./button";

export const AlertDialog = AlertDialogPrimitive;
export const AlertDialogTrigger = AlertDialogPrimitive.Trigger;

type alertDialogContentProps<T extends ValidComponent = "div"> = ParentProps<
	AlertDialogContentProps<T> & {
		class?: string;
	}
>;

export const AlertDialogContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, alertDialogContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as alertDialogContentProps, [
		"class",
		"children",
	]);

	return (
		<AlertDialogPrimitive.Portal>
			<AlertDialogPrimitive.Overlay
				class={cn(
					"fixed inset-0 z-50 bg-background/80 data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0",
				)}
			/>
			<AlertDialogPrimitive.Content
				class={cn(
					"fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border bg-background p-6 shadow-lg data-[closed]:duration-200 data-[expanded]:duration-200 data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95 data-[closed]:slide-out-to-left-1/2 data-[closed]:slide-out-to-top-[48%] data-[expanded]:slide-in-from-left-1/2 data-[expanded]:slide-in-from-top-[48%] sm:rounded-lg md:w-full",
					local.class,
				)}
				{...rest}
			>
				{local.children}
			</AlertDialogPrimitive.Content>
		</AlertDialogPrimitive.Portal>
	);
};

export const AlertDialogHeader = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"flex flex-col space-y-2 text-center sm:text-left",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const AlertDialogFooter = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",
				local.class,
			)}
			{...rest}
		/>
	);
};

type alertDialogTitleProps<T extends ValidComponent = "h2"> =
	AlertDialogTitleProps<T> & {
		class?: string;
	};

export const AlertDialogTitle = <T extends ValidComponent = "h2">(
	props: PolymorphicProps<T, alertDialogTitleProps<T>>,
) => {
	const [local, rest] = splitProps(props as alertDialogTitleProps, ["class"]);

	return (
		<AlertDialogPrimitive.Title
			class={cn("text-lg font-semibold", local.class)}
			{...rest}
		/>
	);
};

type alertDialogDescriptionProps<T extends ValidComponent = "p"> =
	AlertDialogDescriptionProps<T> & {
		class?: string;
	};

export const AlertDialogDescription = <T extends ValidComponent = "p">(
	props: PolymorphicProps<T, alertDialogDescriptionProps<T>>,
) => {
	const [local, rest] = splitProps(props as alertDialogDescriptionProps, [
		"class",
	]);

	return (
		<AlertDialogPrimitive.Description
			class={cn("text-sm text-muted-foreground", local.class)}
			{...rest}
		/>
	);
};

type alertDialogCloseProps<T extends ValidComponent = "button"> =
	AlertDialogCloseButtonProps<T> & {
		class?: string;
	};

export const AlertDialogClose = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, alertDialogCloseProps<T>>,
) => {
	const [local, rest] = splitProps(props as alertDialogCloseProps, ["class"]);

	return (
		<AlertDialogPrimitive.CloseButton
			class={cn(
				buttonVariants({
					variant: "outline",
				}),
				"mt-2 md:mt-0",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const AlertDialogAction = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, alertDialogCloseProps<T>>,
) => {
	const [local, rest] = splitProps(props as alertDialogCloseProps, ["class"]);

	return (
		<AlertDialogPrimitive.CloseButton
			class={cn(buttonVariants(), local.class)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/alert.tsx
```
import { cn } from "@/libs/cn";
import type { AlertRootProps } from "@kobalte/core/alert";
import { Alert as AlertPrimitive } from "@kobalte/core/alert";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { VariantProps } from "class-variance-authority";
import { cva } from "class-variance-authority";
import type { ComponentProps, ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const alertVariants = cva(
	"relative w-full rounded-lg border px-4 py-3 text-sm [&:has(svg)]:pl-11 [&>svg+div]:translate-y-[-3px] [&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:text-foreground",
	{
		variants: {
			variant: {
				default: "bg-background text-foreground",
				destructive:
					"border-destructive/50 text-destructive dark:border-destructive [&>svg]:text-destructive",
			},
		},
		defaultVariants: {
			variant: "default",
		},
	},
);

type alertProps<T extends ValidComponent = "div"> = AlertRootProps<T> &
	VariantProps<typeof alertVariants> & {
		class?: string;
	};

export const Alert = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, alertProps<T>>,
) => {
	const [local, rest] = splitProps(props as alertProps, ["class", "variant"]);

	return (
		<AlertPrimitive
			class={cn(
				alertVariants({
					variant: props.variant,
				}),
				local.class,
			)}
			{...rest}
		/>
	);
};

export const AlertTitle = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn("font-medium leading-5 tracking-tight", local.class)}
			{...rest}
		/>
	);
};

export const AlertDescription = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div class={cn("text-sm [&_p]:leading-relaxed", local.class)} {...rest} />
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/badge.tsx
```
import { cn } from "@/libs/cn";
import type { VariantProps } from "class-variance-authority";
import { cva } from "class-variance-authority";
import { type ComponentProps, splitProps } from "solid-js";

export const badgeVariants = cva(
	"inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold transition-shadow focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring",
	{
		variants: {
			variant: {
				default:
					"border-transparent bg-primary text-primary-foreground shadow hover:bg-primary/80",
				secondary:
					"border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",
				destructive:
					"border-transparent bg-destructive text-destructive-foreground shadow hover:bg-destructive/80",
				outline: "text-foreground",
			},
		},
		defaultVariants: {
			variant: "default",
		},
	},
);

export const Badge = (
	props: ComponentProps<"div"> & VariantProps<typeof badgeVariants>,
) => {
	const [local, rest] = splitProps(props, ["class", "variant"]);

	return (
		<div
			class={cn(
				badgeVariants({
					variant: local.variant,
				}),
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/button.tsx
```
import { cn } from "@/libs/cn";
import type { ButtonRootProps } from "@kobalte/core/button";
import { Button as ButtonPrimitive } from "@kobalte/core/button";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { VariantProps } from "class-variance-authority";
import { cva } from "class-variance-authority";
import type { ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const buttonVariants = cva(
	"inline-flex items-center justify-center rounded-md text-sm font-medium transition-[color,background-color,box-shadow] focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50",
	{
		variants: {
			variant: {
				default:
					"bg-primary text-primary-foreground shadow hover:bg-primary/90",
				destructive:
					"bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90",
				outline:
					"border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground",
				secondary:
					"bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80",
				ghost: "hover:bg-accent hover:text-accent-foreground",
				link: "text-primary underline-offset-4 hover:underline",
			},
			size: {
				default: "h-9 px-4 py-2",
				sm: "h-8 rounded-md px-3 text-xs",
				lg: "h-10 rounded-md px-8",
				icon: "h-9 w-9",
			},
		},
		defaultVariants: {
			variant: "default",
			size: "default",
		},
	},
);

type buttonProps<T extends ValidComponent = "button"> = ButtonRootProps<T> &
	VariantProps<typeof buttonVariants> & {
		class?: string;
	};

export const Button = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, buttonProps<T>>,
) => {
	const [local, rest] = splitProps(props as buttonProps, [
		"class",
		"variant",
		"size",
	]);

	return (
		<ButtonPrimitive
			class={cn(
				buttonVariants({
					size: local.size,
					variant: local.variant,
				}),
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/card.tsx
```
import { cn } from "@/libs/cn";
import type { ComponentProps, ParentComponent } from "solid-js";
import { splitProps } from "solid-js";

export const Card = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"rounded-xl border bg-card text-card-foreground shadow",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const CardHeader = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div class={cn("flex flex-col space-y-1.5 p-6", local.class)} {...rest} />
	);
};

export const CardTitle: ParentComponent<ComponentProps<"h1">> = (props) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<h1
			class={cn("font-semibold leading-none tracking-tight", local.class)}
			{...rest}
		/>
	);
};

export const CardDescription: ParentComponent<ComponentProps<"h3">> = (
	props,
) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<h3 class={cn("text-sm text-muted-foreground", local.class)} {...rest} />
	);
};

export const CardContent = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return <div class={cn("p-6 pt-0", local.class)} {...rest} />;
};

export const CardFooter = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div class={cn("flex items-center p-6 pt-0", local.class)} {...rest} />
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/carousel.tsx
```
import { cn } from "@/libs/cn";
import type { CreateEmblaCarouselType } from "embla-carousel-solid";
import createEmblaCarousel from "embla-carousel-solid";
import type {
	Accessor,
	ComponentProps,
	ParentProps,
	VoidProps,
} from "solid-js";
import {
	createContext,
	createEffect,
	createMemo,
	createSignal,
	mergeProps,
	onCleanup,
	splitProps,
	useContext,
} from "solid-js";
import { Button } from "./button";

export type CarouselApi = CreateEmblaCarouselType[1];
type UseCarouselParameters = Parameters<typeof createEmblaCarousel>;
type CarouselOptions = NonNullable<UseCarouselParameters[0]>;
type CarouselPlugin = NonNullable<UseCarouselParameters[1]>;

type CarouselProps = {
	opts?: ReturnType<CarouselOptions>;
	plugins?: ReturnType<CarouselPlugin>;
	orientation?: "horizontal" | "vertical";
	setApi?: (api: CarouselApi) => void;
};

type CarouselContextProps = {
	carouselRef: ReturnType<typeof createEmblaCarousel>[0];
	api: ReturnType<typeof createEmblaCarousel>[1];
	scrollPrev: () => void;
	scrollNext: () => void;
	canScrollPrev: Accessor<boolean>;
	canScrollNext: Accessor<boolean>;
} & CarouselProps;

const CarouselContext = createContext<Accessor<CarouselContextProps> | null>(
	null,
);

const useCarousel = () => {
	const context = useContext(CarouselContext);

	if (!context) {
		throw new Error("useCarousel must be used within a <Carousel />");
	}

	return context();
};

export const Carousel = (props: ComponentProps<"div"> & CarouselProps) => {
	const merge = mergeProps<
		ParentProps<ComponentProps<"div"> & CarouselProps>[]
	>({ orientation: "horizontal" }, props);

	const [local, rest] = splitProps(merge, [
		"orientation",
		"opts",
		"setApi",
		"plugins",
		"class",
		"children",
	]);

	const [carouselRef, api] = createEmblaCarousel(
		() => ({
			...local.opts,
			axis: local.orientation === "horizontal" ? "x" : "y",
		}),
		() => (local.plugins === undefined ? [] : local.plugins),
	);
	const [canScrollPrev, setCanScrollPrev] = createSignal(false);
	const [canScrollNext, setCanScrollNext] = createSignal(false);

	const onSelect = (api: NonNullable<ReturnType<CarouselApi>>) => {
		setCanScrollPrev(api.canScrollPrev());
		setCanScrollNext(api.canScrollNext());
	};

	const scrollPrev = () => api()?.scrollPrev();

	const scrollNext = () => api()?.scrollNext();

	const handleKeyDown = (event: KeyboardEvent) => {
		if (event.key === "ArrowLeft") {
			event.preventDefault();
			scrollPrev();
		} else if (event.key === "ArrowRight") {
			event.preventDefault();
			scrollNext();
		}
	};

	createEffect(() => {
		if (!api() || !local.setApi) return;

		local.setApi(api);
	});

	createEffect(() => {
		const _api = api();
		if (_api === undefined) return;

		onSelect(_api);
		_api.on("reInit", onSelect);
		_api.on("select", onSelect);

		onCleanup(() => {
			_api.off("select", onSelect);
		});
	});

	const value = createMemo(
		() =>
			({
				carouselRef,
				api,
				opts: local.opts,
				orientation:
					local.orientation ||
					(local.opts?.axis === "y" ? "vertical" : "horizontal"),
				scrollPrev,
				scrollNext,
				canScrollPrev,
				canScrollNext,
			}) satisfies CarouselContextProps,
	);

	return (
		<CarouselContext.Provider value={value}>
			<div
				onKeyDown={handleKeyDown}
				class={cn("relative", local.class)}
				role="region"
				aria-roledescription="carousel"
				{...rest}
			>
				{local.children}
			</div>
		</CarouselContext.Provider>
	);
};

export const CarouselContent = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);
	const { carouselRef, orientation } = useCarousel();

	return (
		<div ref={carouselRef} class="overflow-hidden">
			<div
				class={cn(
					"flex",
					orientation === "horizontal" ? "-ml-4" : "-mt-4 flex-col",
					local.class,
				)}
				{...rest}
			/>
		</div>
	);
};

export const CarouselItem = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);
	const { orientation } = useCarousel();

	return (
		<div
			role="group"
			aria-roledescription="slide"
			class={cn(
				"min-w-0 shrink-0 grow-0 basis-full",
				orientation === "horizontal" ? "pl-4" : "pt-4",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const CarouselPrevious = (
	props: VoidProps<ComponentProps<typeof Button>>,
) => {
	const merge = mergeProps<VoidProps<ComponentProps<typeof Button>[]>>(
		{ variant: "outline", size: "icon" },
		props,
	);
	const [local, rest] = splitProps(merge, ["class", "variant", "size"]);
	const { orientation, scrollPrev, canScrollPrev } = useCarousel();

	return (
		<Button
			variant={local.variant}
			size={local.size}
			class={cn(
				"absolute  h-8 w-8 touch-manipulation rounded-full",
				orientation === "horizontal"
					? "-left-12 top-1/2 -translate-y-1/2"
					: "-top-12 left-1/2 -translate-x-1/2 rotate-90",
				local.class,
			)}
			disabled={!canScrollPrev()}
			onClick={scrollPrev}
			{...rest}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				viewBox="0 0 24 24"
				class="size-4"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="M5 12h14M5 12l6 6m-6-6l6-6"
				/>
				<title>Previous slide</title>
			</svg>
		</Button>
	);
};

export const CarouselNext = (
	props: VoidProps<ComponentProps<typeof Button>>,
) => {
	const merge = mergeProps<VoidProps<ComponentProps<typeof Button>[]>>(
		{ variant: "outline", size: "icon" },
		props,
	);
	const [local, rest] = splitProps(merge, ["class", "variant", "size"]);
	const { orientation, scrollNext, canScrollNext } = useCarousel();

	return (
		<Button
			variant={local.variant}
			size={local.size}
			class={cn(
				"absolute h-8 w-8 touch-manipulation rounded-full",
				orientation === "horizontal"
					? "-right-12 top-1/2 -translate-y-1/2"
					: "-bottom-12 left-1/2 -translate-x-1/2 rotate-90",
				local.class,
			)}
			disabled={!canScrollNext()}
			onClick={scrollNext}
			{...rest}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				viewBox="0 0 24 24"
				class="size-4"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="M5 12h14m-4 4l4-4m-4-4l4 4"
				/>
				<title>Next slide</title>
			</svg>
		</Button>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/checkbox.tsx
```
import { cn } from "@/libs/cn";
import type { CheckboxControlProps } from "@kobalte/core/checkbox";
import { Checkbox as CheckboxPrimitive } from "@kobalte/core/checkbox";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";

export const CheckboxLabel = CheckboxPrimitive.Label;
export const Checkbox = CheckboxPrimitive;
export const CheckboxErrorMessage = CheckboxPrimitive.ErrorMessage;
export const CheckboxDescription = CheckboxPrimitive.Description;

type checkboxControlProps<T extends ValidComponent = "div"> = VoidProps<
	CheckboxControlProps<T> & { class?: string }
>;

export const CheckboxControl = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, checkboxControlProps<T>>,
) => {
	const [local, rest] = splitProps(props as checkboxControlProps, [
		"class",
		"children",
	]);

	return (
		<>
			<CheckboxPrimitive.Input class="[&:focus-visible+div]:outline-none [&:focus-visible+div]:ring-[1.5px] [&:focus-visible+div]:ring-ring [&:focus-visible+div]:ring-offset-2 [&:focus-visible+div]:ring-offset-background" />
			<CheckboxPrimitive.Control
				class={cn(
					"h-4 w-4 shrink-0 rounded-sm border border-primary shadow transition-shadow focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring data-[disabled]:cursor-not-allowed data-[checked]:bg-primary data-[checked]:text-primary-foreground data-[disabled]:opacity-50",
					local.class,
				)}
				{...rest}
			>
				<CheckboxPrimitive.Indicator class="flex items-center justify-center text-current">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 24 24"
						class="h-4 w-4"
					>
						<path
							fill="none"
							stroke="currentColor"
							strokeLinecap="round"
							strokeLinejoin="round"
							strokeWidth="2"
							d="m5 12l5 5L20 7"
						/>
						<title>Checkbox</title>
					</svg>
				</CheckboxPrimitive.Indicator>
			</CheckboxPrimitive.Control>
		</>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/collapsible.tsx
```
import { cn } from "@/libs/cn";
import type { CollapsibleContentProps } from "@kobalte/core/collapsible";
import { Collapsible as CollapsiblePrimitive } from "@kobalte/core/collapsible";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const Collapsible = CollapsiblePrimitive;

export const CollapsibleTrigger = CollapsiblePrimitive.Trigger;

type collapsibleContentProps<T extends ValidComponent = "div"> =
	CollapsibleContentProps<T> & {
		class?: string;
	};

export const CollapsibleContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, collapsibleContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as collapsibleContentProps, ["class"]);

	return (
		<CollapsiblePrimitive.Content
			class={cn(
				"animate-collapsible-up data-[expanded]:animate-collapsible-down",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/combobox.tsx
```
import { cn } from "@/libs/cn";
import type {
	ComboboxContentProps,
	ComboboxInputProps,
	ComboboxItemProps,
	ComboboxTriggerProps,
} from "@kobalte/core/combobox";
import { Combobox as ComboboxPrimitive } from "@kobalte/core/combobox";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ParentProps, ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";

export const Combobox = ComboboxPrimitive;
export const ComboboxDescription = ComboboxPrimitive.Description;
export const ComboboxErrorMessage = ComboboxPrimitive.ErrorMessage;
export const ComboboxItemDescription = ComboboxPrimitive.ItemDescription;
export const ComboboxHiddenSelect = ComboboxPrimitive.HiddenSelect;

type comboboxInputProps<T extends ValidComponent = "input"> = VoidProps<
	ComboboxInputProps<T> & {
		class?: string;
	}
>;

export const ComboboxInput = <T extends ValidComponent = "input">(
	props: PolymorphicProps<T, comboboxInputProps<T>>,
) => {
	const [local, rest] = splitProps(props as comboboxInputProps, ["class"]);

	return (
		<ComboboxPrimitive.Input
			class={cn(
				"h-full bg-transparent text-sm placeholder:text-muted-foreground focus:outline-none disabled:cursor-not-allowed disabled:opacity-50",
				local.class,
			)}
			{...rest}
		/>
	);
};

type comboboxTriggerProps<T extends ValidComponent = "button"> = ParentProps<
	ComboboxTriggerProps<T> & {
		class?: string;
	}
>;

export const ComboboxTrigger = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, comboboxTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as comboboxTriggerProps, [
		"class",
		"children",
	]);

	return (
		<ComboboxPrimitive.Control>
			<ComboboxPrimitive.Trigger
				class={cn(
					"flex h-9 w-full items-center justify-between rounded-md border border-input px-3 shadow-sm",
					local.class,
				)}
				{...rest}
			>
				{local.children}
				<ComboboxPrimitive.Icon class="flex h-3.5 w-3.5 items-center justify-center">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 24 24"
						class="h-4 w-4 opacity-50"
					>
						<path
							fill="none"
							stroke="currentColor"
							strokeLinecap="round"
							strokeLinejoin="round"
							strokeWidth="2"
							d="m8 9l4-4l4 4m0 6l-4 4l-4-4"
						/>
						<title>Arrow</title>
					</svg>
				</ComboboxPrimitive.Icon>
			</ComboboxPrimitive.Trigger>
		</ComboboxPrimitive.Control>
	);
};

type comboboxContentProps<T extends ValidComponent = "div"> =
	ComboboxContentProps<T> & {
		class?: string;
	};

export const ComboboxContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, comboboxContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as comboboxContentProps, ["class"]);

	return (
		<ComboboxPrimitive.Portal>
			<ComboboxPrimitive.Content
				class={cn(
					"relative z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95 origin-[--kb-combobox-content-transform-origin]",
					local.class,
				)}
				{...rest}
			>
				<ComboboxPrimitive.Listbox class="p-1" />
			</ComboboxPrimitive.Content>
		</ComboboxPrimitive.Portal>
	);
};

type comboboxItemProps<T extends ValidComponent = "li"> = ParentProps<
	ComboboxItemProps<T> & {
		class?: string;
	}
>;

export const ComboboxItem = <T extends ValidComponent = "li">(
	props: PolymorphicProps<T, comboboxItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as comboboxItemProps, [
		"class",
		"children",
	]);

	return (
		<ComboboxPrimitive.Item
			class={cn(
				"relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-2 pr-8 text-sm outline-none data-[disabled]:pointer-events-none data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<ComboboxPrimitive.ItemIndicator class="absolute right-2 flex h-3.5 w-3.5 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-4 w-4"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m5 12l5 5L20 7"
					/>
					<title>Checked</title>
				</svg>
			</ComboboxPrimitive.ItemIndicator>
			<ComboboxPrimitive.ItemLabel>
				{local.children}
			</ComboboxPrimitive.ItemLabel>
		</ComboboxPrimitive.Item>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/command.tsx
```
import { cn } from "@/libs/cn";
import type {
	CommandDialogProps,
	CommandEmptyProps,
	CommandGroupProps,
	CommandInputProps,
	CommandItemProps,
	CommandListProps,
	CommandRootProps,
} from "cmdk-solid";
import { Command as CommandPrimitive } from "cmdk-solid";
import type { ComponentProps, VoidProps } from "solid-js";
import { splitProps } from "solid-js";
import { Dialog, DialogContent } from "./dialog";

export const Command = (props: CommandRootProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<CommandPrimitive
			class={cn(
				"flex size-full flex-col overflow-hidden bg-popover text-popover-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const CommandList = (props: CommandListProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<CommandPrimitive.List
			class={cn(
				"max-h-[300px] overflow-y-auto overflow-x-hidden p-1",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const CommandInput = (props: VoidProps<CommandInputProps>) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div class="flex items-center border-b px-3" cmdk-input-wrapper="">
			<svg
				xmlns="http://www.w3.org/2000/svg"
				viewBox="0 0 24 24"
				class="mr-2 h-4 w-4 shrink-0 opacity-50"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="M3 10a7 7 0 1 0 14 0a7 7 0 1 0-14 0m18 11l-6-6"
				/>
				<title>Search</title>
			</svg>
			<CommandPrimitive.Input
				class={cn(
					"flex h-10 w-full rounded-md bg-transparent py-3 text-sm outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50",
					local.class,
				)}
				{...rest}
			/>
		</div>
	);
};

export const CommandItem = (props: CommandItemProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<CommandPrimitive.Item
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none aria-disabled:pointer-events-none aria-disabled:opacity-50 aria-selected:bg-accent aria-selected:text-accent-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const CommandShortcut = (props: ComponentProps<"span">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<span
			class={cn(
				"ml-auto text-xs tracking-widest text-muted-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const CommandDialog = (props: CommandDialogProps) => {
	const [local, rest] = splitProps(props, ["children"]);

	return (
		<Dialog {...rest}>
			<DialogContent class="overflow-hidden p-0">
				<Command class="[&_[cmdk-group-heading]]:px-2 [&_[cmdk-group-heading]]:font-medium [&_[cmdk-group-heading]]:text-muted-foreground [&_[cmdk-group]:not([hidden])_~[cmdk-group]]:pt-0 [&_[cmdk-group]]:px-2 [&_[cmdk-input-wrapper]_svg]:size-5 [&_[cmdk-input]]:h-12 [&_[cmdk-item]]:px-2 [&_[cmdk-item]]:py-3 [&_[cmdk-item]_svg]:size-5">
					{local.children}
				</Command>
			</DialogContent>
		</Dialog>
	);
};

export const CommandEmpty = (props: CommandEmptyProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<CommandPrimitive.Empty
			class={cn("py-6 text-center text-sm", local.class)}
			{...rest}
		/>
	);
};

export const CommandGroup = (props: CommandGroupProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<CommandPrimitive.Group
			class={cn(
				"overflow-hidden p-1 text-foreground [&_[cmdk-group-heading]]:px-2 [&_[cmdk-group-heading]]:py-1.5 [&_[cmdk-group-heading]]:text-xs [&_[cmdk-group-heading]]:font-medium [&_[cmdk-group-heading]]:text-muted-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const CommandSeparator = (props: CommandEmptyProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<CommandPrimitive.Separator
			class={cn("-mx-1 h-px bg-border", local.class)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/context-menu.tsx
```
import { cn } from "@/libs/cn";
import type {
	ContextMenuCheckboxItemProps,
	ContextMenuContentProps,
	ContextMenuGroupLabelProps,
	ContextMenuItemLabelProps,
	ContextMenuItemProps,
	ContextMenuRadioItemProps,
	ContextMenuSeparatorProps,
	ContextMenuSubContentProps,
	ContextMenuSubTriggerProps,
} from "@kobalte/core/context-menu";
import { ContextMenu as ContextMenuPrimitive } from "@kobalte/core/context-menu";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	ComponentProps,
	ParentProps,
	ValidComponent,
	VoidProps,
} from "solid-js";
import { splitProps } from "solid-js";

export const ContextMenu = ContextMenuPrimitive;
export const ContextMenuTrigger = ContextMenuPrimitive.Trigger;
export const ContextMenuGroup = ContextMenuPrimitive.Group;
export const ContextMenuSub = ContextMenuPrimitive.Sub;
export const ContextMenuRadioGroup = ContextMenuPrimitive.RadioGroup;

type contextMenuSubTriggerProps<T extends ValidComponent = "div"> = ParentProps<
	ContextMenuSubTriggerProps<T> & {
		class?: string;
		inset?: boolean;
	}
>;

export const ContextMenuSubTrigger = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, contextMenuSubTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuSubTriggerProps, [
		"class",
		"children",
		"inset",
	]);

	return (
		<ContextMenuPrimitive.SubTrigger
			class={cn(
				"flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[expanded]:bg-accent data-[expanded]:text-accent-foreground",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		>
			{local.children}
			<svg
				xmlns="http://www.w3.org/2000/svg"
				class="ml-auto h-4 w-4"
				viewBox="0 0 24 24"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="m9 6l6 6l-6 6"
				/>
				<title>Arrow</title>
			</svg>
		</ContextMenuPrimitive.SubTrigger>
	);
};

type contextMenuSubContentProps<T extends ValidComponent = "div"> =
	ContextMenuSubContentProps<T> & {
		class?: string;
	};

export const ContextMenuSubContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, contextMenuSubContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuSubContentProps, [
		"class",
	]);

	return (
		<ContextMenuPrimitive.Portal>
			<ContextMenuPrimitive.SubContent
				class={cn(
					"z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-lg data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			/>
		</ContextMenuPrimitive.Portal>
	);
};

type contextMenuContentProps<T extends ValidComponent = "div"> =
	ContextMenuContentProps<T> & {
		class?: string;
	};

export const ContextMenuContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, contextMenuContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuContentProps, ["class"]);

	return (
		<ContextMenuPrimitive.Portal>
			<ContextMenuPrimitive.Content
				class={cn(
					"z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md transition-shadow focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			/>
		</ContextMenuPrimitive.Portal>
	);
};

type contextMenuItemProps<T extends ValidComponent = "div"> =
	ContextMenuItemProps<T> & {
		class?: string;
		inset?: boolean;
	};

export const ContextMenuItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, contextMenuItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuItemProps, [
		"class",
		"inset",
	]);

	return (
		<ContextMenuPrimitive.Item
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		/>
	);
};

type contextMenuCheckboxItemProps<T extends ValidComponent = "div"> =
	ParentProps<
		ContextMenuCheckboxItemProps<T> & {
			class?: string;
		}
	>;

export const ContextMenuCheckboxItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, contextMenuCheckboxItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuCheckboxItemProps, [
		"class",
		"children",
	]);

	return (
		<ContextMenuPrimitive.CheckboxItem
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<ContextMenuPrimitive.ItemIndicator class="absolute left-2 inline-flex h-3.5 w-3.5 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-4 w-4"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m5 12l5 5L20 7"
					/>
					<title>Checkbox</title>
				</svg>
			</ContextMenuPrimitive.ItemIndicator>
			{local.children}
		</ContextMenuPrimitive.CheckboxItem>
	);
};

type contextMenuRadioItemProps<T extends ValidComponent = "div"> = ParentProps<
	ContextMenuRadioItemProps<T> & {
		class?: string;
	}
>;

export const ContextMenuRadioItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, contextMenuRadioItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuRadioItemProps, [
		"class",
		"children",
	]);

	return (
		<ContextMenuPrimitive.RadioItem
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<ContextMenuPrimitive.ItemIndicator class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-2 w-2"
				>
					<g
						fill="none"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
					>
						<path d="M0 0h24v24H0z" />
						<path
							fill="currentColor"
							d="M7 3.34a10 10 0 1 1-4.995 8.984L2 12l.005-.324A10 10 0 0 1 7 3.34"
						/>
					</g>
					<title>Radio</title>
				</svg>
			</ContextMenuPrimitive.ItemIndicator>
			{local.children}
		</ContextMenuPrimitive.RadioItem>
	);
};

type contextMenuItemLabelProps<T extends ValidComponent = "div"> =
	ContextMenuItemLabelProps<T> & {
		class?: string;
		inset?: boolean;
	};

export const ContextMenuItemLabel = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, contextMenuItemLabelProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuItemLabelProps, [
		"class",
		"inset",
	]);

	return (
		<ContextMenuPrimitive.ItemLabel
			class={cn(
				"px-2 py-1.5 text-sm font-semibold text-foreground",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		/>
	);
};

type contextMenuGroupLabelProps<T extends ValidComponent = "span"> =
	ContextMenuGroupLabelProps<T> & {
		class?: string;
		inset?: boolean;
	};

export const ContextMenuGroupLabel = <T extends ValidComponent = "span">(
	props: PolymorphicProps<T, contextMenuGroupLabelProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuGroupLabelProps, [
		"class",
		"inset",
	]);

	return (
		<ContextMenuPrimitive.GroupLabel
			as="div"
			class={cn(
				"px-2 py-1.5 text-sm font-semibold text-foreground",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		/>
	);
};

type contextMenuSeparatorProps<T extends ValidComponent = "hr"> = VoidProps<
	ContextMenuSeparatorProps<T> & {
		class?: string;
	}
>;

export const ContextMenuSeparator = <T extends ValidComponent = "hr">(
	props: PolymorphicProps<T, contextMenuSeparatorProps<T>>,
) => {
	const [local, rest] = splitProps(props as contextMenuSeparatorProps, [
		"class",
	]);

	return (
		<ContextMenuPrimitive.Separator
			class={cn("-mx-1 my-1 h-px bg-border", local.class)}
			{...rest}
		/>
	);
};

export const ContextMenuShortcut = (props: ComponentProps<"span">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<span
			class={cn(
				"ml-auto text-xs tracking-widest text-muted-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/date-picker.tsx
```
import { cn } from "@/libs/cn";
import type {
	DatePickerContentProps,
	DatePickerInputProps,
	DatePickerRangeTextProps,
	DatePickerRootProps,
	DatePickerTableCellProps,
	DatePickerTableCellTriggerProps,
	DatePickerTableHeaderProps,
	DatePickerTableProps,
	DatePickerTableRowProps,
	DatePickerViewControlProps,
	DatePickerViewProps,
	DatePickerViewTriggerProps,
} from "@ark-ui/solid";
import { DatePicker as DatePickerPrimitive } from "@ark-ui/solid";
import type { VoidProps } from "solid-js";
import { splitProps } from "solid-js";
import { buttonVariants } from "./button";

export const DatePickerLabel = DatePickerPrimitive.Label;
export const DatePickerTableHead = DatePickerPrimitive.TableHead;
export const DatePickerTableBody = DatePickerPrimitive.TableBody;
export const DatePickerClearTrigger = DatePickerPrimitive.ClearTrigger;
export const DatePickerYearSelect = DatePickerPrimitive.YearSelect;
export const DatePickerMonthSelect = DatePickerPrimitive.MonthSelect;
export const DatePickerContext = DatePickerPrimitive.Context;
export const DatePickerRootProvider = DatePickerPrimitive.RootProvider;

export const DatePicker = (props: DatePickerRootProps) => {
	return (
		<DatePickerPrimitive.Root
			format={(e) => {
				const parsedDate = new Date(Date.parse(e.toString()));

				const normalizedDate = new Date(
					parsedDate.getUTCFullYear(),
					parsedDate.getUTCMonth(),
					parsedDate.getUTCDate(),
				);

				return new Intl.DateTimeFormat("en-US", {
					dateStyle: "long",
				}).format(normalizedDate);
			}}
			{...props}
		/>
	);
};

export const DatePickerView = (props: DatePickerViewProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.View class={cn("space-y-4", local.class)} {...rest} />
	);
};

export const DatePickerViewControl = (props: DatePickerViewControlProps) => {
	const [local, rest] = splitProps(props, ["class", "children"]);

	return (
		<DatePickerPrimitive.ViewControl
			class={cn("flex items-center justify-between", local.class)}
			{...rest}
		>
			<DatePickerPrimitive.PrevTrigger
				class={cn(
					buttonVariants({
						variant: "outline",
					}),
					"h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100",
				)}
			>
				<svg
					xmlns="http://www.w3.org/2000/svg"
					class="h-4 w-4"
					viewBox="0 0 24 24"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m15 6l-6 6l6 6"
					/>
					<title>Previous</title>
				</svg>
			</DatePickerPrimitive.PrevTrigger>
			{local.children}
			<DatePickerPrimitive.NextTrigger
				class={cn(
					buttonVariants({
						variant: "outline",
					}),
					"h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100",
				)}
			>
				<svg
					xmlns="http://www.w3.org/2000/svg"
					class="h-4 w-4"
					viewBox="0 0 24 24"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m9 6l6 6l-6 6"
					/>
					<title>Next</title>
				</svg>
			</DatePickerPrimitive.NextTrigger>
		</DatePickerPrimitive.ViewControl>
	);
};

export const DatePickerRangeText = (
	props: VoidProps<DatePickerRangeTextProps>,
) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.RangeText
			class={cn("text-sm font-medium", local.class)}
			{...rest}
		/>
	);
};

export const DatePickerTable = (props: DatePickerTableProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.Table
			class={cn("w-full border-collapse space-y-1", local.class)}
			{...rest}
		/>
	);
};

export const DatePickerTableRow = (props: DatePickerTableRowProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.TableRow
			class={cn("mt-2 flex w-full", local.class)}
			{...rest}
		/>
	);
};

export const DatePickerTableHeader = (props: DatePickerTableHeaderProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.TableHeader
			class={cn(
				"w-8 flex-1 text-[0.8rem] font-normal text-muted-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const DatePickerTableCell = (props: DatePickerTableCellProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.TableCell
			class={cn(
				"flex-1 p-0 text-center text-sm",
				"has-[[data-in-range]]:bg-accent has-[[data-in-range]]:first-of-type:rounded-l-md has-[[data-in-range]]:last-of-type:rounded-r-md",
				"has-[[data-range-end]]:rounded-r-md has-[[data-range-start]]:rounded-l-md",
				"has-[[data-outside-range][data-in-range]]:bg-accent/50",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const DatePickerTableCellTrigger = (
	props: DatePickerTableCellTriggerProps,
) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.TableCellTrigger
			class={cn(
				buttonVariants({ variant: "ghost" }),
				"size-8 w-full p-0 font-normal data-[selected]:opacity-100",
				"data-[today]:bg-accent data-[today]:text-accent-foreground",
				"[&:is([data-today][data-selected])]:bg-primary [&:is([data-today][data-selected])]:text-primary-foreground",
				"data-[selected]:bg-primary data-[selected]:text-primary-foreground data-[selected]:hover:bg-primary data-[selected]:hover:text-primary-foreground",
				"data-[disabled]:text-muted-foreground data-[disabled]:opacity-50",
				"data-[outside-range]:text-muted-foreground data-[outside-range]:opacity-50",
				"[&:is([data-outside-range][data-in-range])]:bg-accent/50 [&:is([data-outside-range][data-in-range])]:text-muted-foreground [&:is([data-outside-range][data-in-range])]:opacity-30",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const DatePickerViewTrigger = (props: DatePickerViewTriggerProps) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<DatePickerPrimitive.ViewTrigger
			class={cn(buttonVariants({ variant: "ghost" }), "h-7", local.class)}
			{...rest}
		/>
	);
};

export const DatePickerContent = (props: DatePickerContentProps) => {
	const [local, rest] = splitProps(props, ["class", "children"]);

	return (
		<DatePickerPrimitive.Positioner>
			<DatePickerPrimitive.Content
				class={cn(
					"rounded-md border bg-popover p-3 text-popover-foreground shadow-md outline-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 z-50",
					local.class,
				)}
				{...rest}
			>
				{local.children}
			</DatePickerPrimitive.Content>
		</DatePickerPrimitive.Positioner>
	);
};

export const DatePickerInput = (props: DatePickerInputProps) => {
	const [local, rest] = splitProps(props, ["class", "children"]);

	return (
		<DatePickerPrimitive.Control class="flex h-9 w-full rounded-md border border-input bg-background px-3 py-1 text-sm shadow-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50">
			<DatePickerPrimitive.Input
				class={cn(
					"w-full appearance-none bg-transparent outline-none",
					local.class,
				)}
				{...rest}
			/>
			<DatePickerPrimitive.Trigger class="transition-shadow focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					class="mx-1 h-4 w-4"
					viewBox="0 0 24 24"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="M4 7a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2zm12-4v4M8 3v4m-4 4h16m-9 4h1m0 0v3"
					/>
					<title>Calendar</title>
				</svg>
			</DatePickerPrimitive.Trigger>
		</DatePickerPrimitive.Control>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/dialog.tsx
```
import { cn } from "@/libs/cn";
import type {
	DialogContentProps,
	DialogDescriptionProps,
	DialogTitleProps,
} from "@kobalte/core/dialog";
import { Dialog as DialogPrimitive } from "@kobalte/core/dialog";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ComponentProps, ParentProps, ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const Dialog = DialogPrimitive;
export const DialogTrigger = DialogPrimitive.Trigger;

type dialogContentProps<T extends ValidComponent = "div"> = ParentProps<
	DialogContentProps<T> & {
		class?: string;
	}
>;

export const DialogContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dialogContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as dialogContentProps, [
		"class",
		"children",
	]);

	return (
		<DialogPrimitive.Portal>
			<DialogPrimitive.Overlay
				class={cn(
					"fixed inset-0 z-50 bg-background/80 data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0",
				)}
				{...rest}
			/>
			<DialogPrimitive.Content
				class={cn(
					"fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border bg-background p-6 shadow-lg data-[closed]:duration-200 data-[expanded]:duration-200 data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95 data-[closed]:slide-out-to-left-1/2 data-[closed]:slide-out-to-top-[48%] data-[expanded]:slide-in-from-left-1/2 data-[expanded]:slide-in-from-top-[48%] sm:rounded-lg md:w-full",
					local.class,
				)}
				{...rest}
			>
				{local.children}
				<DialogPrimitive.CloseButton class="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-[opacity,box-shadow] hover:opacity-100 focus:outline-none focus:ring-[1.5px] focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 24 24"
						class="h-4 w-4"
					>
						<path
							fill="none"
							stroke="currentColor"
							strokeLinecap="round"
							strokeLinejoin="round"
							strokeWidth="2"
							d="M18 6L6 18M6 6l12 12"
						/>
						<title>Close</title>
					</svg>
				</DialogPrimitive.CloseButton>
			</DialogPrimitive.Content>
		</DialogPrimitive.Portal>
	);
};

type dialogTitleProps<T extends ValidComponent = "h2"> = DialogTitleProps<T> & {
	class?: string;
};

export const DialogTitle = <T extends ValidComponent = "h2">(
	props: PolymorphicProps<T, dialogTitleProps<T>>,
) => {
	const [local, rest] = splitProps(props as dialogTitleProps, ["class"]);

	return (
		<DialogPrimitive.Title
			class={cn("text-lg font-semibold text-foreground", local.class)}
			{...rest}
		/>
	);
};

type dialogDescriptionProps<T extends ValidComponent = "p"> =
	DialogDescriptionProps<T> & {
		class?: string;
	};

export const DialogDescription = <T extends ValidComponent = "p">(
	props: PolymorphicProps<T, dialogDescriptionProps<T>>,
) => {
	const [local, rest] = splitProps(props as dialogDescriptionProps, ["class"]);

	return (
		<DialogPrimitive.Description
			class={cn("text-sm text-muted-foreground", local.class)}
			{...rest}
		/>
	);
};

export const DialogHeader = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"flex flex-col space-y-2 text-center sm:text-left",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const DialogFooter = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/drawer.tsx
```
import { cn } from "@/libs/cn";
import type {
	ContentProps,
	DescriptionProps,
	DynamicProps,
	LabelProps,
} from "@corvu/drawer";
import DrawerPrimitive from "@corvu/drawer";
import type { ComponentProps, ParentProps, ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const Drawer = DrawerPrimitive;
export const DrawerTrigger = DrawerPrimitive.Trigger;
export const DrawerClose = DrawerPrimitive.Close;

type drawerContentProps<T extends ValidComponent = "div"> = ParentProps<
	ContentProps<T> & {
		class?: string;
	}
>;

export const DrawerContent = <T extends ValidComponent = "div">(
	props: DynamicProps<T, drawerContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as drawerContentProps, [
		"class",
		"children",
	]);
	const ctx = DrawerPrimitive.useContext();

	return (
		<DrawerPrimitive.Portal>
			<DrawerPrimitive.Overlay
				class="fixed inset-0 z-50 data-[transitioning]:transition-colors data-[transitioning]:duration-200"
				style={{
					"background-color": `hsl(var(--background) / ${
						0.8 * ctx.openPercentage()
					})`,
				}}
			/>
			<DrawerPrimitive.Content
				class={cn(
					"fixed inset-x-0 bottom-0 z-50 mt-24 flex h-auto flex-col rounded-t-xl border bg-background after:absolute after:inset-x-0 after:top-full after:h-[50%] after:bg-inherit data-[transitioning]:transition-transform data-[transitioning]:duration-200 md:select-none",
					local.class,
				)}
				{...rest}
			>
				<div class="mx-auto mt-4 h-2 w-[100px] rounded-full bg-muted" />
				{local.children}
			</DrawerPrimitive.Content>
		</DrawerPrimitive.Portal>
	);
};

export const DrawerHeader = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn("grid gap-1.5 p-4 text-center sm:text-left", local.class)}
			{...rest}
		/>
	);
};

export const DrawerFooter = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div class={cn("mt-auto flex flex-col gap-2 p-4", local.class)} {...rest} />
	);
};

type DrawerLabelProps = LabelProps & {
	class?: string;
};

export const DrawerLabel = <T extends ValidComponent = "h2">(
	props: DynamicProps<T, DrawerLabelProps>,
) => {
	const [local, rest] = splitProps(props as DrawerLabelProps, ["class"]);

	return (
		<DrawerPrimitive.Label
			class={cn(
				"text-lg font-semibold leading-none tracking-tight",
				local.class,
			)}
			{...rest}
		/>
	);
};

type DrawerDescriptionProps = DescriptionProps & {
	class?: string;
};

export const DrawerDescription = <T extends ValidComponent = "p">(
	props: DynamicProps<T, DrawerDescriptionProps>,
) => {
	const [local, rest] = splitProps(props as DrawerDescriptionProps, ["class"]);

	return (
		<DrawerPrimitive.Description
			class={cn("text-sm text-muted-foreground", local.class)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/dropdown-menu.tsx
```
import { cn } from "@/libs/cn";
import type {
	DropdownMenuCheckboxItemProps,
	DropdownMenuContentProps,
	DropdownMenuGroupLabelProps,
	DropdownMenuItemLabelProps,
	DropdownMenuItemProps,
	DropdownMenuRadioItemProps,
	DropdownMenuRootProps,
	DropdownMenuSeparatorProps,
	DropdownMenuSubTriggerProps,
} from "@kobalte/core/dropdown-menu";
import { DropdownMenu as DropdownMenuPrimitive } from "@kobalte/core/dropdown-menu";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ComponentProps, ParentProps, ValidComponent } from "solid-js";
import { mergeProps, splitProps } from "solid-js";

export const DropdownMenuTrigger = DropdownMenuPrimitive.Trigger;
export const DropdownMenuGroup = DropdownMenuPrimitive.Group;
export const DropdownMenuSub = DropdownMenuPrimitive.Sub;
export const DropdownMenuRadioGroup = DropdownMenuPrimitive.RadioGroup;

export const DropdownMenu = (props: DropdownMenuRootProps) => {
	const merge = mergeProps<DropdownMenuRootProps[]>({ gutter: 4 }, props);

	return <DropdownMenuPrimitive {...merge} />;
};

type dropdownMenuContentProps<T extends ValidComponent = "div"> =
	DropdownMenuContentProps<T> & {
		class?: string;
	};

export const DropdownMenuContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dropdownMenuContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuContentProps, [
		"class",
	]);

	return (
		<DropdownMenuPrimitive.Portal>
			<DropdownMenuPrimitive.Content
				class={cn(
					"min-w-8rem z-50 overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md transition-shadow focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			/>
		</DropdownMenuPrimitive.Portal>
	);
};

type dropdownMenuItemProps<T extends ValidComponent = "div"> =
	DropdownMenuItemProps<T> & {
		class?: string;
		inset?: boolean;
	};

export const DropdownMenuItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dropdownMenuItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuItemProps, [
		"class",
		"inset",
	]);

	return (
		<DropdownMenuPrimitive.Item
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		/>
	);
};

type dropdownMenuGroupLabelProps<T extends ValidComponent = "span"> =
	DropdownMenuGroupLabelProps<T> & {
		class?: string;
	};

export const DropdownMenuGroupLabel = <T extends ValidComponent = "span">(
	props: PolymorphicProps<T, dropdownMenuGroupLabelProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuGroupLabelProps, [
		"class",
	]);

	return (
		<DropdownMenuPrimitive.GroupLabel
			as="div"
			class={cn("px-2 py-1.5 text-sm font-semibold", local.class)}
			{...rest}
		/>
	);
};

type dropdownMenuItemLabelProps<T extends ValidComponent = "div"> =
	DropdownMenuItemLabelProps<T> & {
		class?: string;
	};

export const DropdownMenuItemLabel = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dropdownMenuItemLabelProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuItemLabelProps, [
		"class",
	]);

	return (
		<DropdownMenuPrimitive.ItemLabel
			as="div"
			class={cn("px-2 py-1.5 text-sm font-semibold", local.class)}
			{...rest}
		/>
	);
};

type dropdownMenuSeparatorProps<T extends ValidComponent = "hr"> =
	DropdownMenuSeparatorProps<T> & {
		class?: string;
	};

export const DropdownMenuSeparator = <T extends ValidComponent = "hr">(
	props: PolymorphicProps<T, dropdownMenuSeparatorProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuSeparatorProps, [
		"class",
	]);

	return (
		<DropdownMenuPrimitive.Separator
			class={cn("-mx-1 my-1 h-px bg-muted", local.class)}
			{...rest}
		/>
	);
};

export const DropdownMenuShortcut = (props: ComponentProps<"span">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<span
			class={cn("ml-auto text-xs tracking-widest opacity-60", local.class)}
			{...rest}
		/>
	);
};

type dropdownMenuSubTriggerProps<T extends ValidComponent = "div"> =
	ParentProps<
		DropdownMenuSubTriggerProps<T> & {
			class?: string;
		}
	>;

export const DropdownMenuSubTrigger = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dropdownMenuSubTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuSubTriggerProps, [
		"class",
		"children",
	]);

	return (
		<DropdownMenuPrimitive.SubTrigger
			class={cn(
				"flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent data-[expanded]:bg-accent",
				local.class,
			)}
			{...rest}
		>
			{local.children}
			<svg
				xmlns="http://www.w3.org/2000/svg"
				width="1em"
				height="1em"
				viewBox="0 0 24 24"
				class="ml-auto h-4 w-4"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="m9 6l6 6l-6 6"
				/>
				<title>Arrow</title>
			</svg>
		</DropdownMenuPrimitive.SubTrigger>
	);
};

type dropdownMenuSubContentProps<T extends ValidComponent = "div"> =
	DropdownMenuSubTriggerProps<T> & {
		class?: string;
	};

export const DropdownMenuSubContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dropdownMenuSubContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuSubContentProps, [
		"class",
	]);

	return (
		<DropdownMenuPrimitive.Portal>
			<DropdownMenuPrimitive.SubContent
				class={cn(
					"min-w-8rem z-50 overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			/>
		</DropdownMenuPrimitive.Portal>
	);
};

type dropdownMenuCheckboxItemProps<T extends ValidComponent = "div"> =
	ParentProps<
		DropdownMenuCheckboxItemProps<T> & {
			class?: string;
		}
	>;

export const DropdownMenuCheckboxItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dropdownMenuCheckboxItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuCheckboxItemProps, [
		"class",
		"children",
	]);

	return (
		<DropdownMenuPrimitive.CheckboxItem
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<DropdownMenuPrimitive.ItemIndicator class="absolute left-2 inline-flex h-4 w-4 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-4 w-4"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m5 12l5 5L20 7"
					/>
					<title>Checkbox</title>
				</svg>
			</DropdownMenuPrimitive.ItemIndicator>
			{props.children}
		</DropdownMenuPrimitive.CheckboxItem>
	);
};

type dropdownMenuRadioItemProps<T extends ValidComponent = "div"> = ParentProps<
	DropdownMenuRadioItemProps<T> & {
		class?: string;
	}
>;

export const DropdownMenuRadioItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, dropdownMenuRadioItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as dropdownMenuRadioItemProps, [
		"class",
		"children",
	]);

	return (
		<DropdownMenuPrimitive.RadioItem
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<DropdownMenuPrimitive.ItemIndicator class="absolute left-2 inline-flex h-4 w-4 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-2 w-2"
				>
					<g
						fill="none"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
					>
						<path d="M0 0h24v24H0z" />
						<path
							fill="currentColor"
							d="M7 3.34a10 10 0 1 1-4.995 8.984L2 12l.005-.324A10 10 0 0 1 7 3.34"
						/>
					</g>
					<title>Radio</title>
				</svg>
			</DropdownMenuPrimitive.ItemIndicator>
			{props.children}
		</DropdownMenuPrimitive.RadioItem>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/hover-card.tsx
```
import { cn } from "@/libs/cn";
import type { HoverCardContentProps } from "@kobalte/core/hover-card";
import { HoverCard as HoverCardPrimitive } from "@kobalte/core/hover-card";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const HoverCard = HoverCardPrimitive;
export const HoverCardTrigger = HoverCardPrimitive.Trigger;

type hoverCardContentProps<T extends ValidComponent = "div"> =
	HoverCardContentProps<T> & {
		class?: string;
	};

export const HoverCardContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, hoverCardContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as hoverCardContentProps, ["class"]);

	return (
		<HoverCardPrimitive.Portal>
			<HoverCardPrimitive.Content
				class={cn(
					"z-50 w-64 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			/>
		</HoverCardPrimitive.Portal>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/image.tsx
```
import { cn } from "@/libs/cn";
import type {
	ImageFallbackProps,
	ImageImgProps,
	ImageRootProps,
} from "@kobalte/core/image";
import { Image as ImagePrimitive } from "@kobalte/core/image";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

type imageRootProps<T extends ValidComponent = "span"> = ImageRootProps<T> & {
	class?: string;
};

export const ImageRoot = <T extends ValidComponent = "span">(
	props: PolymorphicProps<T, imageRootProps<T>>,
) => {
	const [local, rest] = splitProps(props as imageRootProps, ["class"]);

	return (
		<ImagePrimitive
			class={cn(
				"relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full",
				local.class,
			)}
			{...rest}
		/>
	);
};

type imageProps<T extends ValidComponent = "img"> = ImageImgProps<T> & {
	class?: string;
};

export const Image = <T extends ValidComponent = "img">(
	props: PolymorphicProps<T, imageProps<T>>,
) => {
	const [local, rest] = splitProps(props as imageProps, ["class"]);

	return (
		<ImagePrimitive.Img
			class={cn("aspect-square h-full w-full", local.class)}
			{...rest}
		/>
	);
};

type imageFallbackProps<T extends ValidComponent = "span"> =
	ImageFallbackProps<T> & {
		class?: string;
	};

export const ImageFallback = <T extends ValidComponent = "span">(
	props: PolymorphicProps<T, imageFallbackProps<T>>,
) => {
	const [local, rest] = splitProps(props as imageFallbackProps, ["class"]);

	return (
		<ImagePrimitive.Fallback
			class={cn(
				"flex h-full w-full items-center justify-center rounded-full bg-muted",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/menubar.tsx
```
import { cn } from "@/libs/cn";
import type {
	MenubarCheckboxItemProps,
	MenubarContentProps,
	MenubarItemLabelProps,
	MenubarItemProps,
	MenubarMenuProps,
	MenubarRadioItemProps,
	MenubarRootProps,
	MenubarSeparatorProps,
	MenubarSubContentProps,
	MenubarSubTriggerProps,
	MenubarTriggerProps,
} from "@kobalte/core/menubar";
import { Menubar as MenubarPrimitive } from "@kobalte/core/menubar";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ComponentProps, ParentProps, ValidComponent } from "solid-js";
import { mergeProps, splitProps } from "solid-js";

export const MenubarSub = MenubarPrimitive.Sub;
export const MenubarRadioGroup = MenubarPrimitive.RadioGroup;

type menubarProps<T extends ValidComponent = "div"> = MenubarRootProps<T> & {
	class?: string;
};

export const Menubar = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, menubarProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarProps, ["class"]);

	return (
		<MenubarPrimitive
			class={cn(
				"flex h-9 items-center space-x-1 rounded-md border bg-background p-1 shadow-sm",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const MenubarMenu = (props: MenubarMenuProps) => {
	const merge = mergeProps<MenubarMenuProps[]>({ gutter: 8, shift: -4 }, props);

	return <MenubarPrimitive.Menu {...merge} />;
};

type menubarTriggerProps<T extends ValidComponent = "button"> =
	MenubarTriggerProps<T> & {
		class?: string;
	};

export const MenubarTrigger = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, menubarTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarTriggerProps, ["class"]);

	return (
		<MenubarPrimitive.Trigger
			class={cn(
				"flex cursor-default select-none items-center rounded-sm px-3 py-1 text-sm font-medium outline-none focus:bg-accent focus:text-accent-foreground data-[expanded]:bg-accent data-[expanded]:text-accent-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

type menubarSubTriggerProps<T extends ValidComponent = "button"> = ParentProps<
	MenubarSubTriggerProps<T> & {
		class?: string;
		inset?: boolean;
	}
>;

export const MenubarSubTrigger = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, menubarSubTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarSubTriggerProps, [
		"class",
		"children",
		"inset",
	]);

	return (
		<MenubarPrimitive.SubTrigger
			class={cn(
				"flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[expanded]:bg-accent data-[expanded]:text-accent-foreground",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		>
			{local.children}
			<svg
				xmlns="http://www.w3.org/2000/svg"
				width="1em"
				height="1em"
				viewBox="0 0 24 24"
				class="ml-auto h-4 w-4"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="m9 6l6 6l-6 6"
				/>
				<title>Arrow</title>
			</svg>
		</MenubarPrimitive.SubTrigger>
	);
};

type menubarSubContentProps<T extends ValidComponent = "div"> = ParentProps<
	MenubarSubContentProps<T> & {
		class?: string;
	}
>;

export const MenubarSubContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, menubarSubContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarSubContentProps, [
		"class",
		"children",
	]);

	return (
		<MenubarPrimitive.Portal>
			<MenubarPrimitive.SubContent
				class={cn(
					"z-50 min-w-[8rem] origin-[--kb-menu-content-transform-origin] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-lg outline-none data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			>
				{local.children}
			</MenubarPrimitive.SubContent>
		</MenubarPrimitive.Portal>
	);
};

type menubarContentProps<T extends ValidComponent = "div"> = ParentProps<
	MenubarContentProps<T> & {
		class?: string;
	}
>;

export const MenubarContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, menubarContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarContentProps, [
		"class",
		"children",
	]);

	return (
		<MenubarPrimitive.Portal>
			<MenubarPrimitive.Content
				class={cn(
					"z-50 min-w-[12rem] origin-[--kb-menu-content-transform-origin] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md outline-none data-[expanded]:animate-in data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			>
				{local.children}
			</MenubarPrimitive.Content>
		</MenubarPrimitive.Portal>
	);
};

type menubarItemProps<T extends ValidComponent = "div"> =
	MenubarItemProps<T> & {
		class?: string;
		inset?: boolean;
	};

export const MenubarItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, menubarItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarItemProps, [
		"class",
		"inset",
	]);

	return (
		<MenubarPrimitive.Item
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		/>
	);
};

type menubarItemLabelProps<T extends ValidComponent = "div"> =
	MenubarItemLabelProps<T> & {
		class?: string;
		inset?: boolean;
	};

export const MenubarItemLabel = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, menubarItemLabelProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarItemLabelProps, [
		"class",
		"inset",
	]);

	return (
		<MenubarPrimitive.ItemLabel
			class={cn(
				"px-2 py-1.5 text-sm font-semibold",
				local.inset && "pl-8",
				local.class,
			)}
			{...rest}
		/>
	);
};

type menubarSeparatorProps<T extends ValidComponent = "hr"> =
	MenubarSeparatorProps<T> & {
		class?: string;
	};

export const MenubarSeparator = <T extends ValidComponent = "hr">(
	props: PolymorphicProps<T, menubarSeparatorProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarSeparatorProps, ["class"]);

	return (
		<MenubarPrimitive.Separator
			class={cn("-mx-1 my-1 h-px bg-muted", local.class)}
			{...rest}
		/>
	);
};

type menubarCheckboxItemProps<T extends ValidComponent = "div"> = ParentProps<
	MenubarCheckboxItemProps<T> & {
		class?: string;
	}
>;

export const MenubarCheckboxItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, menubarCheckboxItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarCheckboxItemProps, [
		"class",
		"children",
	]);

	return (
		<MenubarPrimitive.CheckboxItem
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<MenubarPrimitive.ItemIndicator class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-4 w-4"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m5 12l5 5L20 7"
					/>
					<title>Checkbox</title>
				</svg>
			</MenubarPrimitive.ItemIndicator>
			{local.children}
		</MenubarPrimitive.CheckboxItem>
	);
};

type menubarRadioItemProps<T extends ValidComponent = "div"> = ParentProps<
	MenubarRadioItemProps<T> & {
		class?: string;
	}
>;

export const MenubarRadioItem = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, menubarRadioItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as menubarRadioItemProps, [
		"class",
		"children",
	]);

	return (
		<MenubarPrimitive.RadioItem
			class={cn(
				"relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<MenubarPrimitive.ItemIndicator class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
					class="h-2 w-2"
				>
					<g
						fill="none"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
					>
						<path d="M0 0h24v24H0z" />
						<path
							fill="currentColor"
							d="M7 3.34a10 10 0 1 1-4.995 8.984L2 12l.005-.324A10 10 0 0 1 7 3.34"
						/>
					</g>
					<title>Radio</title>
				</svg>
			</MenubarPrimitive.ItemIndicator>
			{local.children}
		</MenubarPrimitive.RadioItem>
	);
};

export const MenubarShortcut = (props: ComponentProps<"span">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<span
			class={cn(
				"ml-auto text-xs tracking-widest text-muted-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/navigation-menu.tsx
```
import { cn } from "@/libs/cn";
import type {
	NavigationMenuContentProps,
	NavigationMenuRootProps,
	NavigationMenuTriggerProps,
} from "@kobalte/core/navigation-menu";
import { NavigationMenu as NavigationMenuPrimitive } from "@kobalte/core/navigation-menu";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import {
	type ParentProps,
	Show,
	type ValidComponent,
	mergeProps,
	splitProps,
} from "solid-js";

export const NavigationMenuItem = NavigationMenuPrimitive.Menu;
export const NavigationMenuLink = NavigationMenuPrimitive.Item;
export const NavigationMenuItemLabel = NavigationMenuPrimitive.ItemLabel;
export const NavigationMenuDescription =
	NavigationMenuPrimitive.ItemDescription;
export const NavigationMenuItemIndicator =
	NavigationMenuPrimitive.ItemIndicator;
export const NavigationMenuSub = NavigationMenuPrimitive.Sub;
export const NavigationMenuSubTrigger = NavigationMenuPrimitive.SubTrigger;
export const NavigationMenuSubContent = NavigationMenuPrimitive.SubContent;
export const NavigationMenuRadioGroup = NavigationMenuPrimitive.RadioGroup;
export const NavigationMenuRadioItem = NavigationMenuPrimitive.RadioItem;
export const NavigationMenuCheckboxItem = NavigationMenuPrimitive.CheckboxItem;
export const NavigationMenuSeparator = NavigationMenuPrimitive.Separator;

type withArrow = {
	withArrow?: boolean;
};

type navigationMenuProps<T extends ValidComponent = "ul"> = ParentProps<
	NavigationMenuRootProps<T> &
		withArrow & {
			class?: string;
		}
>;

export const NavigationMenu = <T extends ValidComponent = "ul">(
	props: PolymorphicProps<T, navigationMenuProps<T>>,
) => {
	const merge = mergeProps<navigationMenuProps<T>[]>(
		{
			get gutter() {
				return props.withArrow ? props.gutter : 6;
			},
			withArrow: false,
		},
		props,
	);
	const [local, rest] = splitProps(merge as navigationMenuProps, [
		"class",
		"children",
		"withArrow",
	]);

	return (
		<NavigationMenuPrimitive
			class={cn("flex w-max items-center justify-center gap-x-1", local.class)}
			{...rest}
		>
			{local.children}
			<NavigationMenuPrimitive.Viewport
				class={cn(
					"pointer-events-none z-50 overflow-x-clip overflow-y-visible rounded-md border bg-popover text-popover-foreground shadow",
					"h-[--kb-navigation-menu-viewport-height] w-[--kb-navigation-menu-viewport-width] transition-[width,height] duration-300",
					"origin-[--kb-menu-content-transform-origin]",
					"data-[expanded]:duration-300 data-[expanded]:animate-in data-[expanded]:fade-in data-[expanded]:zoom-in-95",
					"data-[closed]:duration-300 data-[closed]:animate-out data-[closed]:fade-out data-[closed]:zoom-out-95",
				)}
			>
				<Show when={local.withArrow}>
					<NavigationMenuPrimitive.Arrow class="transition-transform duration-300" />
				</Show>
			</NavigationMenuPrimitive.Viewport>
		</NavigationMenuPrimitive>
	);
};

type navigationMenuTriggerProps<T extends ValidComponent = "button"> =
	ParentProps<
		NavigationMenuTriggerProps<T> &
			withArrow & {
				class?: string;
			}
	>;

export const NavigationMenuTrigger = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, navigationMenuTriggerProps<T>>,
) => {
	const merge = mergeProps<navigationMenuTriggerProps<T>[]>(
		{
			get withArrow() {
				return props.as === undefined ? true : props.withArrow;
			},
		},
		props,
	);
	const [local, rest] = splitProps(merge as navigationMenuTriggerProps, [
		"class",
		"children",
		"withArrow",
	]);

	return (
		<NavigationMenuPrimitive.Trigger
			class={cn(
				"inline-flex w-max items-center justify-center rounded-md bg-background px-4 py-2 text-sm font-medium outline-none transition-colors duration-300 hover:bg-accent hover:text-accent-foreground disabled:pointer-events-none disabled:opacity-50",
				local.class,
			)}
			{...rest}
		>
			{local.children}
			<Show when={local.withArrow}>
				<NavigationMenuPrimitive.Icon
					class="ml-1 size-3 transition-transform duration-300 data-[expanded]:rotate-180"
					as="svg"
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 24 24"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m6 9l6 6l6-6"
					/>
				</NavigationMenuPrimitive.Icon>
			</Show>
		</NavigationMenuPrimitive.Trigger>
	);
};

type navigationMenuContentProps<T extends ValidComponent = "ul"> = ParentProps<
	NavigationMenuContentProps<T> & {
		class?: string;
	}
>;

export const NavigationMenuContent = <T extends ValidComponent = "ul">(
	props: PolymorphicProps<T, navigationMenuContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as navigationMenuContentProps, [
		"class",
		"children",
	]);

	return (
		<NavigationMenuPrimitive.Portal>
			<NavigationMenuPrimitive.Content
				class={cn(
					"absolute left-0 top-0 p-4 outline-none",
					"data-[motion^=from-]:duration-300 data-[motion^=from-]:animate-in data-[motion^=from-]:fade-in data-[motion=from-end]:slide-in-from-right-52 data-[motion=from-start]:slide-in-from-left-52",
					"data-[motion^=to-]:duration-300 data-[motion^=to-]:animate-out data-[motion^=to-]:fade-out data-[motion=to-end]:slide-out-to-right-52 data-[motion=to-start]:slide-out-to-left-52",
					local.class,
				)}
				{...rest}
			>
				{local.children}
			</NavigationMenuPrimitive.Content>
		</NavigationMenuPrimitive.Portal>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/number-field.tsx
```
import { cn } from "@/libs/cn";
import type {
	NumberFieldDecrementTriggerProps,
	NumberFieldDescriptionProps,
	NumberFieldErrorMessageProps,
	NumberFieldIncrementTriggerProps,
	NumberFieldInputProps,
	NumberFieldLabelProps,
	NumberFieldRootProps,
} from "@kobalte/core/number-field";
import { NumberField as NumberFieldPrimitive } from "@kobalte/core/number-field";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ComponentProps, ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";
import { textfieldLabel } from "./textfield";

export const NumberFieldHiddenInput = NumberFieldPrimitive.HiddenInput;

type numberFieldLabelProps<T extends ValidComponent = "div"> =
	NumberFieldLabelProps<T> & {
		class?: string;
	};

export const NumberFieldLabel = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, numberFieldLabelProps<T>>,
) => {
	const [local, rest] = splitProps(props as numberFieldLabelProps, ["class"]);

	return (
		<NumberFieldPrimitive.Label
			class={cn(textfieldLabel({ label: true }), local.class)}
			{...rest}
		/>
	);
};

type numberFieldDescriptionProps<T extends ValidComponent = "div"> =
	NumberFieldDescriptionProps<T> & {
		class?: string;
	};

export const NumberFieldDescription = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, numberFieldDescriptionProps<T>>,
) => {
	const [local, rest] = splitProps(props as numberFieldDescriptionProps, [
		"class",
	]);

	return (
		<NumberFieldPrimitive.Description
			class={cn(
				textfieldLabel({ description: true, label: false }),
				local.class,
			)}
			{...rest}
		/>
	);
};

type numberFieldErrorMessageProps<T extends ValidComponent = "div"> =
	NumberFieldErrorMessageProps<T> & {
		class?: string;
	};

export const NumberFieldErrorMessage = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, numberFieldErrorMessageProps<T>>,
) => {
	const [local, rest] = splitProps(props as numberFieldErrorMessageProps, [
		"class",
	]);

	return (
		<NumberFieldPrimitive.ErrorMessage
			class={cn(textfieldLabel({ error: true }), local.class)}
			{...rest}
		/>
	);
};

type numberFieldProps<T extends ValidComponent = "div"> =
	NumberFieldRootProps<T> & {
		class?: string;
	};

export const NumberField = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, numberFieldProps<T>>,
) => {
	const [local, rest] = splitProps(props as numberFieldProps, ["class"]);

	return (
		<NumberFieldPrimitive class={cn("grid gap-1.5", local.class)} {...rest} />
	);
};

export const NumberFieldGroup = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"relative rounded-md transition-shadow focus-within:outline-none focus-within:ring-[1.5px] focus-within:ring-ring",
				local.class,
			)}
			{...rest}
		/>
	);
};

type numberFieldInputProps<T extends ValidComponent = "input"> =
	NumberFieldInputProps<T> & {
		class?: string;
	};

export const NumberFieldInput = <T extends ValidComponent = "input">(
	props: PolymorphicProps<T, VoidProps<numberFieldInputProps<T>>>,
) => {
	const [local, rest] = splitProps(props as numberFieldInputProps, ["class"]);

	return (
		<NumberFieldPrimitive.Input
			class={cn(
				"flex h-9 w-full rounded-md border border-input bg-transparent px-10 py-1 text-center text-sm shadow-sm placeholder:text-muted-foreground focus-visible:outline-none disabled:cursor-not-allowed disabled:opacity-50",
				local.class,
			)}
			{...rest}
		/>
	);
};

type numberFieldDecrementTriggerProps<T extends ValidComponent = "button"> =
	VoidProps<
		NumberFieldDecrementTriggerProps<T> & {
			class?: string;
		}
	>;

export const NumberFieldDecrementTrigger = <
	T extends ValidComponent = "button",
>(
	props: PolymorphicProps<T, VoidProps<numberFieldDecrementTriggerProps<T>>>,
) => {
	const [local, rest] = splitProps(props as numberFieldDecrementTriggerProps, [
		"class",
	]);

	return (
		<NumberFieldPrimitive.DecrementTrigger
			class={cn(
				"absolute left-0 top-1/2 -translate-y-1/2 p-3 disabled:cursor-not-allowed disabled:opacity-20",
				local.class,
			)}
			{...rest}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				class="size-4"
				viewBox="0 0 24 24"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="M5 12h14"
				/>
				<title>Decreasing number</title>
			</svg>
		</NumberFieldPrimitive.DecrementTrigger>
	);
};

type numberFieldIncrementTriggerProps<T extends ValidComponent = "button"> =
	VoidProps<
		NumberFieldIncrementTriggerProps<T> & {
			class?: string;
		}
	>;

export const NumberFieldIncrementTrigger = <
	T extends ValidComponent = "button",
>(
	props: PolymorphicProps<T, numberFieldIncrementTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as numberFieldIncrementTriggerProps, [
		"class",
	]);

	return (
		<NumberFieldPrimitive.IncrementTrigger
			class={cn(
				"absolute right-0 top-1/2 -translate-y-1/2 p-3 disabled:cursor-not-allowed disabled:opacity-20",
				local.class,
			)}
			{...rest}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				class="size-4"
				viewBox="0 0 24 24"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="M12 5v14m-7-7h14"
				/>
				<title>Increase number</title>
			</svg>
		</NumberFieldPrimitive.IncrementTrigger>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/otp-field.tsx
```
import { cn } from "@/libs/cn";
import type { DynamicProps, RootProps } from "@corvu/otp-field";
import OTPFieldPrimitive from "@corvu/otp-field";
import type { ComponentProps, ValidComponent } from "solid-js";
import { Show, splitProps } from "solid-js";

export const OTPFieldInput = OTPFieldPrimitive.Input;

type OTPFieldProps<T extends ValidComponent = "div"> = RootProps<T> & {
	class?: string;
};

export const OTPField = <T extends ValidComponent = "div">(
	props: DynamicProps<T, OTPFieldProps<T>>,
) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<OTPFieldPrimitive
			class={cn(
				"flex items-center gap-2 has-[:disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const OTPFieldGroup = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return <div class={cn("flex items-center", local.class)} {...rest} />;
};

export const OTPFieldSeparator = (props: ComponentProps<"div">) => {
	return (
		<div role="separator" {...props}>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				class="size-4"
				viewBox="0 0 15 15"
			>
				<title>Separator</title>
				<path
					fill="currentColor"
					fill-rule="evenodd"
					d="M5 7.5a.5.5 0 0 1 .5-.5h4a.5.5 0 0 1 0 1h-4a.5.5 0 0 1-.5-.5"
					clip-rule="evenodd"
				/>
			</svg>
		</div>
	);
};

export const OTPFieldSlot = (
	props: ComponentProps<"div"> & { index: number },
) => {
	const [local, rest] = splitProps(props, ["class", "index"]);
	const context = OTPFieldPrimitive.useContext();
	const char = () => context.value()[local.index];
	const hasFakeCaret = () =>
		context.value().length === local.index && context.isInserting();
	const isActive = () => context.activeSlots().includes(local.index);

	return (
		<div
			class={cn(
				"relative flex size-9 items-center justify-center border-y border-r border-input text-sm shadow-sm transition-shadow first:rounded-l-md first:border-l last:rounded-r-md",
				isActive() && "z-10 ring-[1.5px] ring-ring",
				local.class,
			)}
			{...rest}
		>
			{char()}
			<Show when={hasFakeCaret()}>
				<div class="pointer-events-none absolute inset-0 flex items-center justify-center">
					<div class="h-4 w-px animate-caret-blink bg-foreground" />
				</div>
			</Show>
		</div>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/pagination.tsx
```
import { cn } from "@/libs/cn";
import type {
	PaginationEllipsisProps,
	PaginationItemProps,
	PaginationPreviousProps,
	PaginationRootProps,
} from "@kobalte/core/pagination";
import { Pagination as PaginationPrimitive } from "@kobalte/core/pagination";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { VariantProps } from "class-variance-authority";
import type { ValidComponent, VoidProps } from "solid-js";
import { mergeProps, splitProps } from "solid-js";
import { buttonVariants } from "./button";

export const PaginationItems = PaginationPrimitive.Items;

type paginationProps<T extends ValidComponent = "nav"> =
	PaginationRootProps<T> & {
		class?: string;
	};

export const Pagination = <T extends ValidComponent = "nav">(
	props: PolymorphicProps<T, paginationProps<T>>,
) => {
	const [local, rest] = splitProps(props as paginationProps, ["class"]);

	return (
		<PaginationPrimitive
			class={cn(
				"mx-auto flex w-full justify-center [&>ul]:flex [&>ul]:flex-row [&>ul]:items-center [&>ul]:gap-1",
				local.class,
			)}
			{...rest}
		/>
	);
};

type paginationItemProps<T extends ValidComponent = "button"> =
	PaginationItemProps<T> &
		Pick<VariantProps<typeof buttonVariants>, "size"> & {
			class?: string;
		};

export const PaginationItem = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, paginationItemProps<T>>,
) => {
	// @ts-expect-error - required `page`
	const merge = mergeProps<paginationItemProps[]>({ size: "icon" }, props);
	const [local, rest] = splitProps(merge as paginationItemProps, [
		"class",
		"size",
	]);

	return (
		<PaginationPrimitive.Item
			class={cn(
				buttonVariants({
					variant: "ghost",
					size: local.size,
				}),
				"aria-[current=page]:border aria-[current=page]:border-input aria-[current=page]:bg-background aria-[current=page]:shadow-sm aria-[current=page]:hover:bg-accent aria-[current=page]:hover:text-accent-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

type paginationEllipsisProps<T extends ValidComponent = "div"> = VoidProps<
	PaginationEllipsisProps<T> & {
		class?: string;
	}
>;

export const PaginationEllipsis = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, paginationEllipsisProps<T>>,
) => {
	const [local, rest] = splitProps(props as paginationEllipsisProps, ["class"]);

	return (
		<PaginationPrimitive.Ellipsis
			class={cn("flex h-9 w-9 items-center justify-center", local.class)}
			{...rest}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				viewBox="0 0 24 24"
				class="h-4 w-4"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="M4 12a1 1 0 1 0 2 0a1 1 0 1 0-2 0m7 0a1 1 0 1 0 2 0a1 1 0 1 0-2 0m7 0a1 1 0 1 0 2 0a1 1 0 1 0-2 0"
				/>
				<title>More pages</title>
			</svg>
		</PaginationPrimitive.Ellipsis>
	);
};

type paginationPreviousProps<T extends ValidComponent = "button"> =
	PaginationPreviousProps<T> &
		Pick<VariantProps<typeof buttonVariants>, "size"> & {
			class?: string;
		};

export const PaginationPrevious = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, paginationPreviousProps<T>>,
) => {
	const merge = mergeProps<paginationPreviousProps<T>[]>(
		{ size: "icon" },
		props,
	);
	const [local, rest] = splitProps(merge as paginationPreviousProps, [
		"class",
		"size",
	]);

	return (
		<PaginationPrimitive.Previous
			class={cn(
				buttonVariants({
					variant: "ghost",
					size: local.size,
				}),
				"aria-[current=page]:border aria-[current=page]:border-input aria-[current=page]:bg-background aria-[current=page]:shadow-sm aria-[current=page]:hover:bg-accent aria-[current=page]:hover:text-accent-foreground",
				local.class,
			)}
			{...rest}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				viewBox="0 0 24 24"
				class="h-4 w-4"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="m15 6l-6 6l6 6"
				/>
				<title>Previous page</title>
			</svg>
		</PaginationPrimitive.Previous>
	);
};

type paginationNextProps<T extends ValidComponent = "button"> =
	paginationPreviousProps<T>;

export const PaginationNext = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, paginationNextProps<T>>,
) => {
	const merge = mergeProps<paginationNextProps<T>[]>({ size: "icon" }, props);
	const [local, rest] = splitProps(merge as paginationNextProps, [
		"class",
		"size",
	]);

	return (
		<PaginationPrimitive.Next
			class={cn(
				buttonVariants({
					variant: "ghost",
					size: local.size,
				}),
				"aria-[current=page]:border aria-[current=page]:border-input aria-[current=page]:bg-background aria-[current=page]:shadow-sm aria-[current=page]:hover:bg-accent aria-[current=page]:hover:text-accent-foreground",
				local.class,
			)}
			{...rest}
		>
			<svg
				xmlns="http://www.w3.org/2000/svg"
				class="h-4 w-4"
				viewBox="0 0 24 24"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="m9 6l6 6l-6 6"
				/>
				<title>Next page</title>
			</svg>
		</PaginationPrimitive.Next>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/popover.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	PopoverContentProps,
	PopoverRootProps,
} from "@kobalte/core/popover";
import { Popover as PopoverPrimitive } from "@kobalte/core/popover";
import type { ParentProps, ValidComponent } from "solid-js";
import { mergeProps, splitProps } from "solid-js";

export const PopoverTrigger = PopoverPrimitive.Trigger;
export const PopoverTitle = PopoverPrimitive.Title;
export const PopoverDescription = PopoverPrimitive.Description;

export const Popover = (props: PopoverRootProps) => {
	const merge = mergeProps<PopoverRootProps[]>({ gutter: 4 }, props);

	return <PopoverPrimitive {...merge} />;
};

type popoverContentProps<T extends ValidComponent = "div"> = ParentProps<
	PopoverContentProps<T> & {
		class?: string;
	}
>;

export const PopoverContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, popoverContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as popoverContentProps, [
		"class",
		"children",
	]);

	return (
		<PopoverPrimitive.Portal>
			<PopoverPrimitive.Content
				class={cn(
					"z-50 w-72 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			>
				{local.children}
				<PopoverPrimitive.CloseButton class="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-[opacity,box-shadow] hover:opacity-100 focus:outline-none focus:ring-[1.5px] focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 24 24"
						class="h-4 w-4"
					>
						<path
							fill="none"
							stroke="currentColor"
							strokeLinecap="round"
							strokeLinejoin="round"
							strokeWidth="2"
							d="M18 6L6 18M6 6l12 12"
						/>
						<title>Close</title>
					</svg>
				</PopoverPrimitive.CloseButton>
			</PopoverPrimitive.Content>
		</PopoverPrimitive.Portal>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/progress.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ProgressRootProps } from "@kobalte/core/progress";
import { Progress as ProgressPrimitive } from "@kobalte/core/progress";
import type { ParentProps, ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const ProgressLabel = ProgressPrimitive.Label;
export const ProgressValueLabel = ProgressPrimitive.ValueLabel;

type progressProps<T extends ValidComponent = "div"> = ParentProps<
	ProgressRootProps<T> & {
		class?: string;
	}
>;

export const Progress = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, progressProps<T>>,
) => {
	const [local, rest] = splitProps(props as progressProps, [
		"class",
		"children",
	]);

	return (
		<ProgressPrimitive
			class={cn("flex w-full flex-col gap-2", local.class)}
			{...rest}
		>
			{local.children}
			<ProgressPrimitive.Track class="h-2 overflow-hidden rounded-full bg-primary/20">
				<ProgressPrimitive.Fill class="h-full w-[--kb-progress-fill-width] bg-primary transition-all duration-500 ease-linear data-[progress=complete]:bg-primary" />
			</ProgressPrimitive.Track>
		</ProgressPrimitive>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/radio-group.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { RadioGroupItemControlProps } from "@kobalte/core/radio-group";
import { RadioGroup as RadioGroupPrimitive } from "@kobalte/core/radio-group";
import type { ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";

export const RadioGroupDescription = RadioGroupPrimitive.Description;
export const RadioGroupErrorMessage = RadioGroupPrimitive.ErrorMessage;
export const RadioGroupItemDescription = RadioGroupPrimitive.ItemDescription;
export const RadioGroupItemInput = RadioGroupPrimitive.ItemInput;
export const RadioGroupItemLabel = RadioGroupPrimitive.ItemLabel;
export const RadioGroupLabel = RadioGroupPrimitive.Label;
export const RadioGroup = RadioGroupPrimitive;
export const RadioGroupItem = RadioGroupPrimitive.Item;

type radioGroupItemControlProps<T extends ValidComponent = "div"> = VoidProps<
	RadioGroupItemControlProps<T> & { class?: string }
>;

export const RadioGroupItemControl = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, radioGroupItemControlProps<T>>,
) => {
	const [local, rest] = splitProps(props as radioGroupItemControlProps, [
		"class",
	]);

	return (
		<RadioGroupPrimitive.ItemControl
			class={cn(
				"flex aspect-square h-4 w-4 items-center justify-center rounded-full border border-primary text-primary shadow transition-shadow focus:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 data-[checked]:bg-foreground",
				local.class,
			)}
			{...rest}
		>
			<RadioGroupPrimitive.ItemIndicator class="h-2 w-2 rounded-full data-[checked]:bg-background" />
		</RadioGroupPrimitive.ItemControl>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/resizable.tsx
```
import { cn } from "@/libs/cn";
import type { DynamicProps, HandleProps, RootProps } from "@corvu/resizable";
import ResizablePrimitive from "@corvu/resizable";
import type { ValidComponent, VoidProps } from "solid-js";
import { Show, splitProps } from "solid-js";

export const ResizablePanel = ResizablePrimitive.Panel;

type resizableProps<T extends ValidComponent = "div"> = RootProps<T> & {
	class?: string;
};

export const Resizable = <T extends ValidComponent = "div">(
	props: DynamicProps<T, resizableProps<T>>,
) => {
	const [local, rest] = splitProps(props as resizableProps, ["class"]);

	return <ResizablePrimitive class={cn("size-full", local.class)} {...rest} />;
};

type resizableHandleProps<T extends ValidComponent = "button"> = VoidProps<
	HandleProps<T> & {
		class?: string;
		withHandle?: boolean;
	}
>;

export const ResizableHandle = <T extends ValidComponent = "button">(
	props: DynamicProps<T, resizableHandleProps<T>>,
) => {
	const [local, rest] = splitProps(props as resizableHandleProps, [
		"class",
		"withHandle",
	]);

	return (
		<ResizablePrimitive.Handle
			class={cn(
				"flex w-px items-center justify-center bg-border transition-shadow focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring focus-visible:ring-offset-1 data-[orientation=vertical]:h-px data-[orientation=vertical]:w-full",
				local.class,
			)}
			{...rest}
		>
			<Show when={local.withHandle}>
				<div class="z-10 flex h-4 w-3 items-center justify-center rounded-sm border bg-border">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						class="h-2.5 w-2.5"
						viewBox="0 0 15 15"
					>
						<path
							fill="currentColor"
							fill-rule="evenodd"
							d="M5.5 4.625a1.125 1.125 0 1 0 0-2.25a1.125 1.125 0 0 0 0 2.25m4 0a1.125 1.125 0 1 0 0-2.25a1.125 1.125 0 0 0 0 2.25M10.625 7.5a1.125 1.125 0 1 1-2.25 0a1.125 1.125 0 0 1 2.25 0M5.5 8.625a1.125 1.125 0 1 0 0-2.25a1.125 1.125 0 0 0 0 2.25m5.125 2.875a1.125 1.125 0 1 1-2.25 0a1.125 1.125 0 0 1 2.25 0M5.5 12.625a1.125 1.125 0 1 0 0-2.25a1.125 1.125 0 0 0 0 2.25"
							clip-rule="evenodd"
						/>
						<title>Resizable handle</title>
					</svg>
				</div>
			</Show>
		</ResizablePrimitive.Handle>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/select.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	SelectContentProps,
	SelectItemProps,
	SelectTriggerProps,
} from "@kobalte/core/select";
import { Select as SelectPrimitive } from "@kobalte/core/select";
import type { ParentProps, ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const Select = SelectPrimitive;
export const SelectValue = SelectPrimitive.Value;
export const SelectDescription = SelectPrimitive.Description;
export const SelectErrorMessage = SelectPrimitive.ErrorMessage;
export const SelectItemDescription = SelectPrimitive.ItemDescription;
export const SelectHiddenSelect = SelectPrimitive.HiddenSelect;
export const SelectSection = SelectPrimitive.Section;

type selectTriggerProps<T extends ValidComponent = "button"> = ParentProps<
	SelectTriggerProps<T> & { class?: string }
>;

export const SelectTrigger = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, selectTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as selectTriggerProps, [
		"class",
		"children",
	]);

	return (
		<SelectPrimitive.Trigger
			class={cn(
				"flex h-9 w-full items-center justify-between rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background transition-shadow placeholder:text-muted-foreground focus:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
				local.class,
			)}
			{...rest}
		>
			{local.children}
			<SelectPrimitive.Icon
				as="svg"
				xmlns="http://www.w3.org/2000/svg"
				width="1em"
				height="1em"
				viewBox="0 0 24 24"
				class="flex size-4 items-center justify-center opacity-50"
			>
				<path
					fill="none"
					stroke="currentColor"
					strokeLinecap="round"
					strokeLinejoin="round"
					strokeWidth="2"
					d="m8 9l4-4l4 4m0 6l-4 4l-4-4"
				/>
			</SelectPrimitive.Icon>
		</SelectPrimitive.Trigger>
	);
};

type selectContentProps<T extends ValidComponent = "div"> =
	SelectContentProps<T> & {
		class?: string;
	};

export const SelectContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, selectContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as selectContentProps, ["class"]);

	return (
		<SelectPrimitive.Portal>
			<SelectPrimitive.Content
				class={cn(
					"relative z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			>
				<SelectPrimitive.Listbox class="p-1 focus-visible:outline-none" />
			</SelectPrimitive.Content>
		</SelectPrimitive.Portal>
	);
};

type selectItemProps<T extends ValidComponent = "li"> = ParentProps<
	SelectItemProps<T> & { class?: string }
>;

export const SelectItem = <T extends ValidComponent = "li">(
	props: PolymorphicProps<T, selectItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as selectItemProps, [
		"class",
		"children",
	]);

	return (
		<SelectPrimitive.Item
			class={cn(
				"relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-2 pr-8 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
				local.class,
			)}
			{...rest}
		>
			<SelectPrimitive.ItemIndicator class="absolute right-2 flex h-3.5 w-3.5 items-center justify-center">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					class="h-4 w-4"
					viewBox="0 0 24 24"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="m5 12l5 5L20 7"
					/>
					<title>Checked</title>
				</svg>
			</SelectPrimitive.ItemIndicator>
			<SelectPrimitive.ItemLabel>{local.children}</SelectPrimitive.ItemLabel>
		</SelectPrimitive.Item>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/separator.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { SeparatorRootProps } from "@kobalte/core/separator";
import { Separator as SeparatorPrimitive } from "@kobalte/core/separator";
import type { ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

type separatorProps<T extends ValidComponent = "hr"> = SeparatorRootProps<T> & {
	class?: string;
};

export const Separator = <T extends ValidComponent = "hr">(
	props: PolymorphicProps<T, separatorProps<T>>,
) => {
	const [local, rest] = splitProps(props as separatorProps, ["class"]);

	return (
		<SeparatorPrimitive
			class={cn(
				"shrink-0 bg-border data-[orientation=horizontal]:h-[1px] data-[orientation=vertical]:h-full data-[orientation=horizontal]:w-full data-[orientation=vertical]:w-[1px]",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/sheet.tsx
```
import { cn } from "@/libs/cn";
import type {
	DialogContentProps,
	DialogDescriptionProps,
	DialogTitleProps,
} from "@kobalte/core/dialog";
import { Dialog as DialogPrimitive } from "@kobalte/core/dialog";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { VariantProps } from "class-variance-authority";
import { cva } from "class-variance-authority";
import type { ComponentProps, ParentProps, ValidComponent } from "solid-js";
import { mergeProps, splitProps } from "solid-js";

export const Sheet = DialogPrimitive;
export const SheetTrigger = DialogPrimitive.Trigger;

export const sheetVariants = cva(
	"fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out data-[expanded]:animate-in data-[closed]:animate-out data-[expanded]:duration-200 data-[closed]:duration-200",
	{
		variants: {
			side: {
				top: "inset-x-0 top-0 border-b data-[closed]:slide-out-to-top data-[expanded]:slide-in-from-top",
				bottom:
					"inset-x-0 bottom-0 border-t data-[closed]:slide-out-to-bottom data-[expanded]:slide-in-from-bottom",
				left: "inset-y-0 left-0 h-full w-3/4 border-r data-[closed]:slide-out-to-left data-[expanded]:slide-in-from-left sm:max-w-sm",
				right:
					"inset-y-0 right-0 h-full w-3/4 border-l data-[closed]:slide-out-to-right data-[expanded]:slide-in-from-right sm:max-w-sm",
			},
		},
		defaultVariants: {
			side: "right",
		},
	},
);

type sheetContentProps<T extends ValidComponent = "div"> = ParentProps<
	DialogContentProps<T> &
		VariantProps<typeof sheetVariants> & {
			class?: string;
		}
>;

export const SheetContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, sheetContentProps<T>>,
) => {
	const merge = mergeProps<sheetContentProps<T>[]>({ side: "right" }, props);
	const [local, rest] = splitProps(merge as sheetContentProps, [
		"class",
		"children",
		"side",
	]);

	return (
		<DialogPrimitive.Portal>
			<DialogPrimitive.Overlay
				class={cn(
					"fixed inset-0 z-50 bg-background/80 data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0",
				)}
			/>
			<DialogPrimitive.Content
				class={sheetVariants({ side: local.side, class: local.class })}
				{...rest}
			>
				{local.children}
				<DialogPrimitive.CloseButton class="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-[opacity,box-shadow] hover:opacity-100 focus:outline-none focus:ring-[1.5px] focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 24 24"
						class="h-4 w-4"
					>
						<path
							fill="none"
							stroke="currentColor"
							strokeLinecap="round"
							strokeLinejoin="round"
							strokeWidth="2"
							d="M18 6L6 18M6 6l12 12"
						/>
						<title>Close</title>
					</svg>
				</DialogPrimitive.CloseButton>
			</DialogPrimitive.Content>
		</DialogPrimitive.Portal>
	);
};

type sheetTitleProps<T extends ValidComponent = "h2"> = DialogTitleProps<T> & {
	class?: string;
};

export const SheetTitle = <T extends ValidComponent = "h2">(
	props: PolymorphicProps<T, sheetTitleProps<T>>,
) => {
	const [local, rest] = splitProps(props as sheetTitleProps, ["class"]);

	return (
		<DialogPrimitive.Title
			class={cn("text-lg font-semibold text-foreground", local.class)}
			{...rest}
		/>
	);
};

type sheetDescriptionProps<T extends ValidComponent = "p"> =
	DialogDescriptionProps<T> & {
		class?: string;
	};

export const SheetDescription = <T extends ValidComponent = "p">(
	props: PolymorphicProps<T, sheetDescriptionProps<T>>,
) => {
	const [local, rest] = splitProps(props as sheetDescriptionProps, ["class"]);

	return (
		<DialogPrimitive.Description
			class={cn("text-sm text-muted-foreground", local.class)}
			{...rest}
		/>
	);
};

export const SheetHeader = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"flex flex-col space-y-2 text-center sm:text-left",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const SheetFooter = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn(
				"flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/skeleton.tsx
```
import { cn } from "@/libs/cn";
import { type ComponentProps, splitProps } from "solid-js";

export const Skeleton = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div
			class={cn("animate-pulse rounded-md bg-primary/10", local.class)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/sonner.tsx
```
import { Toaster as Sonner } from "solid-sonner";

export const Toaster = (props: Parameters<typeof Sonner>[0]) => {
	return (
		<Sonner
			class="toaster group"
			toastOptions={{
				classes: {
					toast:
						"group toast group-[.toaster]:bg-background group-[.toaster]:text-foreground group-[.toaster]:border-border group-[.toaster]:shadow-lg",
					description: "group-[.toast]:text-muted-foreground",
					actionButton:
						"group-[.toast]:bg-primary group-[.toast]:text-primary-foreground",
					cancelButton:
						"group-[.toast]:bg-muted group-[.toast]:text-muted-foreground",
				},
			}}
			{...props}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/switch.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	SwitchControlProps,
	SwitchThumbProps,
} from "@kobalte/core/switch";
import { Switch as SwitchPrimitive } from "@kobalte/core/switch";
import type { ParentProps, ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";

export const SwitchLabel = SwitchPrimitive.Label;
export const Switch = SwitchPrimitive;
export const SwitchErrorMessage = SwitchPrimitive.ErrorMessage;
export const SwitchDescription = SwitchPrimitive.Description;

type switchControlProps<T extends ValidComponent = "input"> = ParentProps<
	SwitchControlProps<T> & { class?: string }
>;

export const SwitchControl = <T extends ValidComponent = "input">(
	props: PolymorphicProps<T, switchControlProps<T>>,
) => {
	const [local, rest] = splitProps(props as switchControlProps, [
		"class",
		"children",
	]);

	return (
		<>
			<SwitchPrimitive.Input class="[&:focus-visible+div]:outline-none [&:focus-visible+div]:ring-[1.5px] [&:focus-visible+div]:ring-ring [&:focus-visible+div]:ring-offset-2 [&:focus-visible+div]:ring-offset-background" />
			<SwitchPrimitive.Control
				class={cn(
					"inline-flex h-5 w-9 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent bg-input shadow-sm transition-[color,background-color,box-shadow] data-[disabled]:cursor-not-allowed data-[checked]:bg-primary data-[disabled]:opacity-50",
					local.class,
				)}
				{...rest}
			>
				{local.children}
			</SwitchPrimitive.Control>
		</>
	);
};

type switchThumbProps<T extends ValidComponent = "div"> = VoidProps<
	SwitchThumbProps<T> & { class?: string }
>;

export const SwitchThumb = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, switchThumbProps<T>>,
) => {
	const [local, rest] = splitProps(props as switchThumbProps, ["class"]);

	return (
		<SwitchPrimitive.Thumb
			class={cn(
				"pointer-events-none block h-4 w-4 translate-x-0 rounded-full bg-background shadow-lg ring-0 transition-transform data-[checked]:translate-x-4",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/table.tsx
```
import { cn } from "@/libs/cn";
import { type ComponentProps, splitProps } from "solid-js";

export const Table = (props: ComponentProps<"table">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<div class="w-full overflow-auto">
			<table
				class={cn("w-full caption-bottom text-sm", local.class)}
				{...rest}
			/>
		</div>
	);
};

export const TableHeader = (props: ComponentProps<"thead">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return <thead class={cn("[&_tr]:border-b", local.class)} {...rest} />;
};

export const TableBody = (props: ComponentProps<"tbody">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<tbody class={cn("[&_tr:last-child]:border-0", local.class)} {...rest} />
	);
};

export const TableFooter = (props: ComponentProps<"tfoot">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<tbody
			class={cn("bg-primary font-medium text-primary-foreground", local.class)}
			{...rest}
		/>
	);
};

export const TableRow = (props: ComponentProps<"tr">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<tr
			class={cn(
				"border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const TableHead = (props: ComponentProps<"th">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<th
			class={cn(
				"h-10 px-2 text-left align-middle font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const TableCell = (props: ComponentProps<"td">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<td
			class={cn(
				"p-2 align-middle [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const TableCaption = (props: ComponentProps<"caption">) => {
	const [local, rest] = splitProps(props, ["class"]);

	return (
		<caption
			class={cn("mt-4 text-sm text-muted-foreground", local.class)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/tabs.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	TabsContentProps,
	TabsIndicatorProps,
	TabsListProps,
	TabsRootProps,
	TabsTriggerProps,
} from "@kobalte/core/tabs";
import { Tabs as TabsPrimitive } from "@kobalte/core/tabs";
import type { VariantProps } from "class-variance-authority";
import { cva } from "class-variance-authority";
import type { ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";

type tabsProps<T extends ValidComponent = "div"> = TabsRootProps<T> & {
	class?: string;
};

export const Tabs = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, tabsProps<T>>,
) => {
	const [local, rest] = splitProps(props as tabsProps, ["class"]);

	return (
		<TabsPrimitive
			class={cn("w-full data-[orientation=vertical]:flex", local.class)}
			{...rest}
		/>
	);
};

type tabsListProps<T extends ValidComponent = "div"> = TabsListProps<T> & {
	class?: string;
};

export const TabsList = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, tabsListProps<T>>,
) => {
	const [local, rest] = splitProps(props as tabsListProps, ["class"]);

	return (
		<TabsPrimitive.List
			class={cn(
				"relative flex w-full rounded-lg bg-muted p-1 text-muted-foreground data-[orientation=vertical]:flex-col data-[orientation=horizontal]:items-center data-[orientation=vertical]:items-stretch",
				local.class,
			)}
			{...rest}
		/>
	);
};

type tabsContentProps<T extends ValidComponent = "div"> =
	TabsContentProps<T> & {
		class?: string;
	};

export const TabsContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, tabsContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as tabsContentProps, ["class"]);

	return (
		<TabsPrimitive.Content
			class={cn(
				"transition-shadow duration-200 focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background data-[orientation=horizontal]:mt-2 data-[orientation=vertical]:ml-2",
				local.class,
			)}
			{...rest}
		/>
	);
};

type tabsTriggerProps<T extends ValidComponent = "button"> =
	TabsTriggerProps<T> & {
		class?: string;
	};

export const TabsTrigger = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, tabsTriggerProps<T>>,
) => {
	const [local, rest] = splitProps(props as tabsTriggerProps, ["class"]);

	return (
		<TabsPrimitive.Trigger
			class={cn(
				"peer relative z-10 inline-flex h-7 w-full items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm font-medium outline-none transition-colors disabled:pointer-events-none disabled:opacity-50 data-[selected]:text-foreground",
				local.class,
			)}
			{...rest}
		/>
	);
};

const tabsIndicatorVariants = cva(
	"absolute transition-all duration-200 outline-none",
	{
		variants: {
			variant: {
				block:
					"data-[orientation=horizontal]:bottom-1 data-[orientation=horizontal]:left-0 data-[orientation=vertical]:right-1 data-[orientation=vertical]:top-0 data-[orientation=horizontal]:h-[calc(100%-0.5rem)] data-[orientation=vertical]:w-[calc(100%-0.5rem)] bg-background shadow rounded-md peer-focus-visible:ring-[1.5px] peer-focus-visible:ring-ring peer-focus-visible:ring-offset-2 peer-focus-visible:ring-offset-background peer-focus-visible:outline-none",
				underline:
					"data-[orientation=horizontal]:-bottom-[1px] data-[orientation=horizontal]:left-0 data-[orientation=vertical]:-right-[1px] data-[orientation=vertical]:top-0 data-[orientation=horizontal]:h-[2px] data-[orientation=vertical]:w-[2px] bg-primary",
			},
		},
		defaultVariants: {
			variant: "block",
		},
	},
);

type tabsIndicatorProps<T extends ValidComponent = "div"> = VoidProps<
	TabsIndicatorProps<T> &
		VariantProps<typeof tabsIndicatorVariants> & {
			class?: string;
		}
>;

export const TabsIndicator = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, tabsIndicatorProps<T>>,
) => {
	const [local, rest] = splitProps(props as tabsIndicatorProps, [
		"class",
		"variant",
	]);

	return (
		<TabsPrimitive.Indicator
			class={cn(tabsIndicatorVariants({ variant: local.variant }), local.class)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/textarea.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { TextFieldTextAreaProps } from "@kobalte/core/text-field";
import { TextArea as TextFieldPrimitive } from "@kobalte/core/text-field";
import type { ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";

type textAreaProps<T extends ValidComponent = "textarea"> = VoidProps<
	TextFieldTextAreaProps<T> & {
		class?: string;
	}
>;

export const TextArea = <T extends ValidComponent = "textarea">(
	props: PolymorphicProps<T, textAreaProps<T>>,
) => {
	const [local, rest] = splitProps(props as textAreaProps, ["class"]);

	return (
		<TextFieldPrimitive
			class={cn(
				"flex min-h-[60px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm transition-shadow placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/textfield.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	TextFieldDescriptionProps,
	TextFieldErrorMessageProps,
	TextFieldInputProps,
	TextFieldLabelProps,
	TextFieldRootProps,
} from "@kobalte/core/text-field";
import { TextField as TextFieldPrimitive } from "@kobalte/core/text-field";
import { cva } from "class-variance-authority";
import type { ValidComponent, VoidProps } from "solid-js";
import { splitProps } from "solid-js";

type textFieldProps<T extends ValidComponent = "div"> =
	TextFieldRootProps<T> & {
		class?: string;
	};

export const TextFieldRoot = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, textFieldProps<T>>,
) => {
	const [local, rest] = splitProps(props as textFieldProps, ["class"]);

	return <TextFieldPrimitive class={cn("space-y-1", local.class)} {...rest} />;
};

export const textfieldLabel = cva(
	"text-sm data-[disabled]:cursor-not-allowed data-[disabled]:opacity-70 font-medium",
	{
		variants: {
			label: {
				true: "data-[invalid]:text-destructive",
			},
			error: {
				true: "text-destructive text-xs",
			},
			description: {
				true: "font-normal text-muted-foreground",
			},
		},
		defaultVariants: {
			label: true,
		},
	},
);

type textFieldLabelProps<T extends ValidComponent = "label"> =
	TextFieldLabelProps<T> & {
		class?: string;
	};

export const TextFieldLabel = <T extends ValidComponent = "label">(
	props: PolymorphicProps<T, textFieldLabelProps<T>>,
) => {
	const [local, rest] = splitProps(props as textFieldLabelProps, ["class"]);

	return (
		<TextFieldPrimitive.Label
			class={cn(textfieldLabel(), local.class)}
			{...rest}
		/>
	);
};

type textFieldErrorMessageProps<T extends ValidComponent = "div"> =
	TextFieldErrorMessageProps<T> & {
		class?: string;
	};

export const TextFieldErrorMessage = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, textFieldErrorMessageProps<T>>,
) => {
	const [local, rest] = splitProps(props as textFieldErrorMessageProps, [
		"class",
	]);

	return (
		<TextFieldPrimitive.ErrorMessage
			class={cn(textfieldLabel({ error: true }), local.class)}
			{...rest}
		/>
	);
};

type textFieldDescriptionProps<T extends ValidComponent = "div"> =
	TextFieldDescriptionProps<T> & {
		class?: string;
	};

export const TextFieldDescription = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, textFieldDescriptionProps<T>>,
) => {
	const [local, rest] = splitProps(props as textFieldDescriptionProps, [
		"class",
	]);

	return (
		<TextFieldPrimitive.Description
			class={cn(
				textfieldLabel({ description: true, label: false }),
				local.class,
			)}
			{...rest}
		/>
	);
};

type textFieldInputProps<T extends ValidComponent = "input"> = VoidProps<
	TextFieldInputProps<T> & {
		class?: string;
	}
>;

export const TextField = <T extends ValidComponent = "input">(
	props: PolymorphicProps<T, textFieldInputProps<T>>,
) => {
	const [local, rest] = splitProps(props as textFieldInputProps, ["class"]);

	return (
		<TextFieldPrimitive.Input
			class={cn(
				"flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-shadow file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/toast.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	ToastDescriptionProps,
	ToastListProps,
	ToastRegionProps,
	ToastRootProps,
	ToastTitleProps,
} from "@kobalte/core/toast";
import { Toast as ToastPrimitive } from "@kobalte/core/toast";
import type { VariantProps } from "class-variance-authority";
import { cva } from "class-variance-authority";
import type {
	ComponentProps,
	ValidComponent,
	VoidComponent,
	VoidProps,
} from "solid-js";
import { mergeProps, splitProps } from "solid-js";
import { Portal } from "solid-js/web";

export const toastVariants = cva(
	"group pointer-events-auto relative flex flex-col gap-3 w-full items-center justify-between overflow-hidden rounded-md border p-4 pr-6 shadow-lg transition-all data-[swipe=cancel]:translate-y-0 data-[swipe=end]:translate-y-[var(--kb-toast-swipe-end-y)] data-[swipe=move]:translate-y-[--kb-toast-swipe-move-y] data-[swipe=move]:transition-none data-[opened]:animate-in data-[closed]:animate-out data-[swipe=end]:animate-out data-[closed]:fade-out-80 data-[closed]:slide-out-to-top-full data-[closed]:sm:slide-out-to-bottom-full data-[opened]:slide-in-from-top-full data-[opened]:sm:slide-in-from-bottom-full",
	{
		variants: {
			variant: {
				default: "border bg-background",
				destructive:
					"destructive group border-destructive bg-destructive text-destructive-foreground",
			},
		},
		defaultVariants: {
			variant: "default",
		},
	},
);

type toastProps<T extends ValidComponent = "li"> = ToastRootProps<T> &
	VariantProps<typeof toastVariants> & {
		class?: string;
	};

export const Toast = <T extends ValidComponent = "li">(
	props: PolymorphicProps<T, toastProps<T>>,
) => {
	const [local, rest] = splitProps(props as toastProps, ["class", "variant"]);

	return (
		<ToastPrimitive
			class={cn(toastVariants({ variant: local.variant }), local.class)}
			{...rest}
		/>
	);
};

type toastTitleProps<T extends ValidComponent = "div"> = ToastTitleProps<T> & {
	class?: string;
};

export const ToastTitle = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, toastTitleProps<T>>,
) => {
	const [local, rest] = splitProps(props as toastTitleProps, ["class"]);

	return (
		<ToastPrimitive.Title
			class={cn("text-sm font-semibold [&+div]:text-xs", local.class)}
			{...rest}
		/>
	);
};

type toastDescriptionProps<T extends ValidComponent = "div"> =
	ToastDescriptionProps<T> & {
		class?: string;
	};

export const ToastDescription = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, toastDescriptionProps<T>>,
) => {
	const [local, rest] = splitProps(props as toastDescriptionProps, ["class"]);

	return (
		<ToastPrimitive.Description
			class={cn("text-sm opacity-90", local.class)}
			{...rest}
		/>
	);
};

type toastRegionProps<T extends ValidComponent = "div"> =
	ToastRegionProps<T> & {
		class?: string;
	};

export const ToastRegion = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, toastRegionProps<T>>,
) => {
	const merge = mergeProps<toastRegionProps[]>(
		{
			swipeDirection: "down",
		},
		props,
	);

	return (
		<Portal>
			<ToastPrimitive.Region {...merge} />
		</Portal>
	);
};

type toastListProps<T extends ValidComponent = "ol"> = VoidProps<
	ToastListProps<T> & {
		class?: string;
	}
>;

export const ToastList = <T extends ValidComponent = "ol">(
	props: PolymorphicProps<T, toastListProps<T>>,
) => {
	const [local, rest] = splitProps(props as toastListProps, ["class"]);

	return (
		<ToastPrimitive.List
			class={cn(
				"fixed top-0 z-[100] flex max-h-screen w-full flex-col-reverse gap-2 p-4 sm:bottom-0 sm:right-0 sm:top-auto sm:flex-col md:max-w-[420px]",
				local.class,
			)}
			{...rest}
		/>
	);
};

export const ToastContent = (props: ComponentProps<"div">) => {
	const [local, rest] = splitProps(props, ["class", "children"]);

	return (
		<div class={cn("flex w-full flex-col", local.class)} {...rest}>
			<div>{local.children}</div>
			<ToastPrimitive.CloseButton class="absolute right-1 top-1 rounded-md p-1 text-foreground/50 opacity-0 transition-opacity hover:text-foreground focus:opacity-100 focus:outline-none group-hover:opacity-100 group-[.destructive]:text-red-300 group-[.destructive]:hover:text-red-50">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					class="h-4 w-4"
					viewBox="0 0 24 24"
				>
					<path
						fill="none"
						stroke="currentColor"
						strokeLinecap="round"
						strokeLinejoin="round"
						strokeWidth="2"
						d="M18 6L6 18M6 6l12 12"
					/>
					<title>Close</title>
				</svg>
			</ToastPrimitive.CloseButton>
		</div>
	);
};

export const ToastProgress: VoidComponent = () => {
	return (
		<ToastPrimitive.ProgressTrack class="h-1 w-full overflow-hidden rounded-xl bg-primary/20 group-[.destructive]:bg-background/20">
			<ToastPrimitive.ProgressFill class="h-full w-[--kb-toast-progress-fill-width] bg-primary transition-all duration-150 ease-linear group-[.destructive]:bg-destructive-foreground" />
		</ToastPrimitive.ProgressTrack>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/toggle-group.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	ToggleGroupItemProps,
	ToggleGroupRootProps,
} from "@kobalte/core/toggle-group";
import { ToggleGroup as ToggleGroupPrimitive } from "@kobalte/core/toggle-group";
import type { VariantProps } from "class-variance-authority";
import type { Accessor, ParentProps, ValidComponent } from "solid-js";
import { createContext, createMemo, splitProps, useContext } from "solid-js";
import { toggleVariants } from "./toggle";

const ToggleGroupContext =
	createContext<Accessor<VariantProps<typeof toggleVariants>>>();

const useToggleGroup = () => {
	const context = useContext(ToggleGroupContext);

	if (!context) {
		throw new Error(
			"`useToggleGroup`: must be used within a `ToggleGroup` component",
		);
	}

	return context;
};

type toggleGroupProps<T extends ValidComponent = "div"> = ParentProps<
	ToggleGroupRootProps<T> &
		VariantProps<typeof toggleVariants> & {
			class?: string;
		}
>;

export const ToggleGroup = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, toggleGroupProps<T>>,
) => {
	const [local, rest] = splitProps(props as toggleGroupProps, [
		"class",
		"children",
		"size",
		"variant",
	]);

	const value = createMemo<VariantProps<typeof toggleVariants>>(() => ({
		size: local.size,
		variant: local.variant,
	}));

	return (
		<ToggleGroupPrimitive
			class={cn("flex items-center justify-center gap-1", local.class)}
			{...rest}
		>
			<ToggleGroupContext.Provider value={value}>
				{local.children}
			</ToggleGroupContext.Provider>
		</ToggleGroupPrimitive>
	);
};

type toggleGroupItemProps<T extends ValidComponent = "button"> =
	ToggleGroupItemProps<T> & {
		class?: string;
	};

export const ToggleGroupItem = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, toggleGroupItemProps<T>>,
) => {
	const [local, rest] = splitProps(props as toggleGroupItemProps, ["class"]);
	const context = useToggleGroup();

	return (
		<ToggleGroupPrimitive.Item
			class={cn(
				toggleVariants({
					variant: context().variant,
					size: context().size,
				}),
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/toggle.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type { ToggleButtonRootProps } from "@kobalte/core/toggle-button";
import { ToggleButton as ToggleButtonPrimitive } from "@kobalte/core/toggle-button";
import type { VariantProps } from "class-variance-authority";
import { cva } from "class-variance-authority";
import type { ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

export const toggleVariants = cva(
	"inline-flex items-center justify-center rounded-md text-sm font-medium transition-[box-shadow,color,background-color] hover:bg-muted hover:text-muted-foreground focus-visible:outline-none focus-visible:ring-[1.5px] focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 data-[pressed]:bg-accent data-[pressed]:text-accent-foreground",
	{
		variants: {
			variant: {
				default: "bg-transparent",
				outline:
					"border border-input bg-transparent shadow-sm hover:bg-accent hover:text-accent-foreground",
			},
			size: {
				default: "h-9 px-3",
				sm: "h-8 px-2",
				lg: "h-10 px-3",
			},
		},
		defaultVariants: {
			variant: "default",
			size: "default",
		},
	},
);

type toggleButtonProps<T extends ValidComponent = "button"> =
	ToggleButtonRootProps<T> &
		VariantProps<typeof toggleVariants> & {
			class?: string;
		};

export const ToggleButton = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, toggleButtonProps<T>>,
) => {
	const [local, rest] = splitProps(props as toggleButtonProps, [
		"class",
		"variant",
		"size",
	]);

	return (
		<ToggleButtonPrimitive
			class={cn(
				toggleVariants({ variant: local.variant, size: local.size }),
				local.class,
			)}
			{...rest}
		/>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/components/ui/tooltip.tsx
```
import { cn } from "@/libs/cn";
import type { PolymorphicProps } from "@kobalte/core/polymorphic";
import type {
	TooltipContentProps,
	TooltipRootProps,
} from "@kobalte/core/tooltip";
import { Tooltip as TooltipPrimitive } from "@kobalte/core/tooltip";
import { type ValidComponent, mergeProps, splitProps } from "solid-js";

export const TooltipTrigger = TooltipPrimitive.Trigger;

export const Tooltip = (props: TooltipRootProps) => {
	const merge = mergeProps<TooltipRootProps[]>({ gutter: 4 }, props);

	return <TooltipPrimitive {...merge} />;
};

type tooltipContentProps<T extends ValidComponent = "div"> =
	TooltipContentProps<T> & {
		class?: string;
	};

export const TooltipContent = <T extends ValidComponent = "div">(
	props: PolymorphicProps<T, tooltipContentProps<T>>,
) => {
	const [local, rest] = splitProps(props as tooltipContentProps, ["class"]);

	return (
		<TooltipPrimitive.Portal>
			<TooltipPrimitive.Content
				class={cn(
					"z-50 overflow-hidden rounded-md bg-primary px-3 py-1.5 text-xs text-primary-foreground data-[expanded]:animate-in data-[closed]:animate-out data-[closed]:fade-out-0 data-[expanded]:fade-in-0 data-[closed]:zoom-out-95 data-[expanded]:zoom-in-95",
					local.class,
				)}
				{...rest}
			/>
		</TooltipPrimitive.Portal>
	);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/layouts/root-layout.astro
```
---
import "../app.css";
---

<script is:inline>
  const getThemePreference = () => {
    if (
      typeof localStorage !== "undefined" &&
      localStorage.getItem("theme")
    ) {
      return localStorage.getItem("theme");
    }
    return window.matchMedia("(prefers-color-scheme: dark)").matches
      ? "dark"
      : "light";
  };

  const setColorMode = () => {
    const isDark = getThemePreference() === "dark";
    document.documentElement.classList[isDark ? "add" : "remove"]("dark");
  };

  if (typeof localStorage !== "undefined") {
    const observer = new MutationObserver(() => {
      const isDark = document.documentElement.classList.contains("dark");
      localStorage.setItem("theme", isDark ? "dark" : "light");
    });
    observer.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ["class"],
    });
  }

  setColorMode();

  document.addEventListener("astro:after-swap", setColorMode);
</script>


<html>
  <head>
    <meta charset="utf-8" />
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <meta name="viewport" content="width=device-width" />
    <meta name="generator" content={Astro.generator} />
    <title>Astro</title>
  </head>
  <body class="w-full h-screen flex-col items-center flex justify-center">
    <div class="w-1/2 flex justify-center">
      <slot /> 
    </div>
  </body>
</html>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/dashboard.astro
```
---
import { auth } from "@/auth";

const activeSessions = await auth.api
	.listSessions({
		headers: Astro.request.headers,
	})
	.catch((e) => {
		return [];
	});
const session = await auth.api.getSession({
	headers: Astro.request.headers,
});
---

<RootLayout>
	<UserCard activeSessions={activeSessions} initialSession={session} client:only />
</RootLayout>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/index.astro
```
---
---

<RootLayout>
  <div class="min-h-[80vh] flex flex-col items-center justify-center overflow-hidden no-visible-scrollbar px-6 md:px-0">
    <h3 class="font-bold text-xl text-black dark:text-white text-center">
      Better Auth.
    </h3>
    <p class="text-center break-words text-sm md:text-base">
      Official astro
      <a
        href="https://better-auth.com"
        target="_blank"
        class="italic underline"
      >
        better-auth
      </a>{" "}
      example. <br />
    </p> 
    <a href="/sign-in">
      <button
        id="login"
        class="bg-black mt-3 flex items-center gap-2 rounded-sm py-2 px-3 text-white text-sm"
      >
        Sign In
      </button>  
    </a>
    <a href="/dashboard">
      <button
        id="dashboard"
        class="bg-black mt-3 flex items-center gap-2 rounded-sm py-2 px-3 text-white text-sm"
      >
        Dashboard
      </button> 
    </a>
  </div>
</RootLayout>

<script>
  import { useVanillaSession } from "../libs/auth-client";
  useVanillaSession.subscribe((val) => {
    if (val.data) {
      document.getElementById("login")!.style.display = "none";
      document.getElementById("dashboard")!.style.display = "flex";
    } else {
      if(val.error){
        document.getElementById("login")!.style.display = "flex";
        document.getElementById("dashboard")!.style.display = "none";
      }
    }
  });
</script>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/sign-in.astro
```
---
---

<RootLayout>
  <SignInCard client:load />
</RootLayout>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/sign-up.astro
```
---
---

<RootLayout>
  <SignUpCard client:load />
</RootLayout>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/two-factor.astro
```
---
---

<RootLayout>
  <TwoFactorComponent client:load />
</RootLayout>

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/api/auth/[...all].ts
```typescript
import type { APIRoute } from "astro";
import { auth } from "../../../auth";

export const GET: APIRoute = async (ctx) => {
	return auth.handler(ctx.request);
};

export const ALL: APIRoute = async (ctx) => {
	return auth.handler(ctx.request);
};

```
/Users/josh/Documents/GitHub/better-auth/better-auth/examples/astro-example/src/pages/two-factor/email.astro
```
---
---

<RootLayout>
  <TwoFactorEmail client:load />
</RootLayout>

```
