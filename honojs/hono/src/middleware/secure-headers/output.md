/Users/josh/Documents/GitHub/honojs/hono/src/middleware/secure-headers/index.test.ts
```typescript
import { Hono } from '../../hono'
import { poweredBy } from '../powered-by'
import { NONCE, secureHeaders } from '.'
import type { ContentSecurityPolicyOptionHandler } from '.'

declare module '../..' {
  interface ContextVariableMap {
    ['test-scriptSrc-nonce']?: string
    ['test-styleSrc-nonce']?: string
  }
}

describe('Secure Headers Middleware', () => {
  it('default middleware', async () => {
    const app = new Hono()
    app.use('*', secureHeaders())
    app.get('/test', async (ctx) => {
      return ctx.text('test')
    })

    const res = await app.request('/test')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Frame-Options')).toEqual('SAMEORIGIN')
    expect(res.headers.get('Strict-Transport-Security')).toEqual(
      'max-age=15552000; includeSubDomains'
    )
    expect(res.headers.get('X-Download-Options')).toEqual('noopen')
    expect(res.headers.get('X-XSS-Protection')).toEqual('0')
    expect(res.headers.get('X-Powered-By')).toBeNull()
    expect(res.headers.get('X-DNS-Prefetch-Control')).toEqual('off')
    expect(res.headers.get('X-Content-Type-Options')).toEqual('nosniff')
    expect(res.headers.get('Referrer-Policy')).toEqual('no-referrer')
    expect(res.headers.get('X-Permitted-Cross-Domain-Policies')).toEqual('none')
    expect(res.headers.get('Cross-Origin-Resource-Policy')).toEqual('same-origin')
    expect(res.headers.get('Cross-Origin-Opener-Policy')).toEqual('same-origin')
    expect(res.headers.get('Origin-Agent-Cluster')).toEqual('?1')
    expect(res.headers.get('Permissions-Policy')).toBeNull()
    expect(res.headers.get('Content-Security-Policy')).toBeFalsy()
    expect(res.headers.get('Content-Security-Policy-ReportOnly')).toBeFalsy()
  })

  it('all headers enabled', async () => {
    const app = new Hono()
    app.use(
      '*',
      secureHeaders({
        contentSecurityPolicy: {
          defaultSrc: ["'self'"],
        },
        contentSecurityPolicyReportOnly: {
          defaultSrc: ["'self'"],
        },
        crossOriginEmbedderPolicy: true,
        permissionsPolicy: {
          camera: [],
        },
      })
    )
    app.get('/test', async (ctx) => {
      return ctx.text('test')
    })

    const res = await app.request('/test')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Frame-Options')).toEqual('SAMEORIGIN')
    expect(res.headers.get('Strict-Transport-Security')).toEqual(
      'max-age=15552000; includeSubDomains'
    )
    expect(res.headers.get('X-Download-Options')).toEqual('noopen')
    expect(res.headers.get('X-XSS-Protection')).toEqual('0')
    expect(res.headers.get('X-Powered-By')).toBeNull()
    expect(res.headers.get('X-DNS-Prefetch-Control')).toEqual('off')
    expect(res.headers.get('X-Content-Type-Options')).toEqual('nosniff')
    expect(res.headers.get('Referrer-Policy')).toEqual('no-referrer')
    expect(res.headers.get('X-Permitted-Cross-Domain-Policies')).toEqual('none')
    expect(res.headers.get('Cross-Origin-Resource-Policy')).toEqual('same-origin')
    expect(res.headers.get('Cross-Origin-Opener-Policy')).toEqual('same-origin')
    expect(res.headers.get('Origin-Agent-Cluster')).toEqual('?1')
    expect(res.headers.get('Cross-Origin-Embedder-Policy')).toEqual('require-corp')
    expect(res.headers.get('Permissions-Policy')).toEqual('camera=()')
    expect(res.headers.get('Content-Security-Policy')).toEqual("default-src 'self'")
    expect(res.headers.get('Content-Security-Policy-Report-Only')).toEqual("default-src 'self'")
  })

  it('specific headers disabled', async () => {
    const app = new Hono()
    app.use('*', secureHeaders({ xFrameOptions: false, xXssProtection: false }))
    app.get('/test', async (ctx) => {
      return ctx.text('test')
    })

    const res = await app.request('/test')
    expect(res).not.toBeNull()
    expect(res.status).toBe(200)
    expect(res.headers.get('X-Frame-Options')).toBeNull()
    expect(res.headers.get('Strict-Transport-Security')).toEqual(
      'max-age=15552000; includeSubDomains'
    )
    expect(res.headers.get('X-Download-Options')).toEqual('noopen')
    expect(res.headers.get('X-XSS-Protection')).toBeNull()
    expect(res.headers.get('X-Powered-By')).toBeNull()
    expect(res.headers.get('X-DNS-Prefetch-Control')).toEqual('off')
    expect(res.headers.get('X-Content-Type-Options')).toEqual('nosniff')
    expect(res.headers.get('Referrer-Policy')).toEqual('no-referrer')
    expect(res.headers.get('X-Permitted-Cross-Domain-Policies')).toEqual('none')
    expect(res.headers.get('Cross-Origin-Resource-Policy')).toEqual('same-origin')
    expect(res.headers.get('Cross-Origin-Opener-Policy')).toEqual('same-origin')
    expect(res.headers.get('Permissions-Policy')).toBeNull()
    expect(res.headers.get('Origin-Agent-Cluster')).toEqual('?1')
  })

  it('should remove x-powered-by header', async () => {
    const appBefore = new Hono()
    appBefore.use('*', secureHeaders())
    appBefore.use('*', poweredBy())

    const resBefore = await appBefore.request('/')
    expect(resBefore.headers.get('x-powered-by')).toBeFalsy()

    const appAfter = new Hono()
    appAfter.use('*', poweredBy())
    appAfter.use('*', secureHeaders())

    const resAfter = await appAfter.request('/')
    expect(resAfter.headers.get('x-powered-by')).toBe('Hono')
  })

  it('should override Strict-Transport-Security header after middleware', async () => {
    const app = new Hono()
    app.use('/test1', secureHeaders())

    app.all('*', async (c) => {
      c.res.headers.set('Strict-Transport-Security', 'Hono')
      return c.text('header updated')
    })

    const res1 = await app.request('/test1')
    expect(res1.headers.get('Strict-Transport-Security')).toEqual(
      'max-age=15552000; includeSubDomains'
    )

    const res2 = await app.request('/test2')
    expect(res2.headers.get('Strict-Transport-Security')).toEqual('Hono')
  })

  it('should use custom value when overridden', async () => {
    const app = new Hono()
    app.use(
      '/test',
      secureHeaders({
        strictTransportSecurity: 'max-age=31536000; includeSubDomains; preload;',
        xFrameOptions: 'DENY',
        xXssProtection: '1',
      })
    )

    const res = await app.request('/test')
    expect(res.headers.get('Strict-Transport-Security')).toEqual(
      'max-age=31536000; includeSubDomains; preload;'
    )
    expect(res.headers.get('X-FRAME-OPTIONS')).toEqual('DENY')
    expect(res.headers.get('X-XSS-Protection')).toEqual('1')
  })

  it('should set Permission-Policy header correctly', async () => {
    const app = new Hono()
    app.use(
      '/test',
      secureHeaders({
        permissionsPolicy: {
          fullscreen: ['self'],
          bluetooth: ['none'],
          payment: ['self', 'example.com'],
          syncXhr: [],
          camera: false,
          microphone: true,
          geolocation: ['*'],
          usb: ['self', 'https://a.example.com', 'https://b.example.com'],
          accelerometer: ['https://*.example.com'],
          gyroscope: ['src'],
          magnetometer: ['https://a.example.com', 'https://b.example.com'],
        },
      })
    )

    const res = await app.request('/test')
    expect(res.headers.get('Permissions-Policy')).toEqual(
      'fullscreen=(self), bluetooth=none, payment=(self "example.com"), sync-xhr=(), camera=none, microphone=*, ' +
        'geolocation=*, usb=(self "https://a.example.com" "https://b.example.com"), ' +
        'accelerometer=("https://*.example.com"), gyroscope=(src), ' +
        'magnetometer=("https://a.example.com" "https://b.example.com")'
    )
  })

  it('Remove X-Powered-By', async () => {
    const app = new Hono()

    app.get('/test', secureHeaders(), poweredBy(), async (c) => {
      return c.text('Hono is hot')
    })

    app.get(
      '/test2',
      secureHeaders({
        removePoweredBy: false,
      }),
      poweredBy(),
      async (c) => {
        return c.text('Hono is hot')
      }
    )

    const res = await app.request('/test')
    const poweredby = res.headers.get('X-Powered-By')
    expect(poweredby).toEqual(null)
    expect(await res.text()).toEqual('Hono is hot')

    const res2 = await app.request('/test2')
    const poweredby2 = res2.headers.get('X-Powered-By')
    expect(poweredby2).toEqual('Hono')
    expect(await res2.text()).toEqual('Hono is hot')
  })

  describe.each([
    { cspSettingName: 'contentSecurityPolicy', cspHeaderName: 'Content-Security-Policy' },
    {
      cspSettingName: 'contentSecurityPolicyReportOnly',
      cspHeaderName: 'Content-Security-Policy-Report-Only',
    },
  ])('CSP Setting ($cspSettingName)', ({ cspSettingName, cspHeaderName }) => {
    it('CSP Setting', async () => {
      const app = new Hono()
      app.use(
        '/test',
        secureHeaders({
          [cspSettingName]: {
            defaultSrc: ["'self'"],
            baseUri: ["'self'"],
            fontSrc: ["'self'", 'https:', 'data:'],
            frameAncestors: ["'self'"],
            imgSrc: ["'self'", 'data:'],
            objectSrc: ["'none'"],
            scriptSrc: ["'self'"],
            scriptSrcAttr: ["'none'"],
            styleSrc: ["'self'", 'https:', "'unsafe-inline'"],
          },
        })
      )

      app.all('*', async (c) => {
        c.res.headers.set('Strict-Transport-Security', 'Hono')
        return c.text('header updated')
      })

      const res = await app.request('/test')
      expect(res.headers.get(cspHeaderName)).toEqual(
        "default-src 'self'; base-uri 'self'; font-src 'self' https: data:; frame-ancestors 'self'; img-src 'self' data:; object-src 'none'; script-src 'self'; script-src-attr 'none'; style-src 'self' https: 'unsafe-inline'"
      )
    })

    it('CSP Setting one only', async () => {
      const app = new Hono()
      app.use(
        '/test',
        secureHeaders({
          [cspSettingName]: {
            defaultSrc: ["'self'"],
          },
        })
      )

      app.all('*', async (c) => {
        return c.text('header updated')
      })

      const res = await app.request('/test')
      expect(res.headers.get(cspHeaderName)).toEqual("default-src 'self'")
    })

    it('No CSP Setting', async () => {
      const app = new Hono()
      app.use('/test', secureHeaders({ [cspSettingName]: {} }))

      app.all('*', async (c) => {
        return c.text('header updated')
      })

      const res = await app.request('/test')
      expect(res.headers.get(cspHeaderName)).toEqual('')
    })

    it('CSP with reportTo', async () => {
      const app = new Hono()
      app.use(
        '/test1',
        secureHeaders({
          reportingEndpoints: [
            {
              name: 'endpoint-1',
              url: 'https://example.com/reports',
            },
          ],
          [cspSettingName]: {
            defaultSrc: ["'self'"],
            reportTo: 'endpoint-1',
          },
        })
      )

      app.use(
        '/test2',
        secureHeaders({
          reportTo: [
            {
              group: 'endpoint-1',
              max_age: 10886400,
              endpoints: [{ url: 'https://example.com/reports' }],
            },
          ],
          [cspSettingName]: {
            defaultSrc: ["'self'"],
            reportTo: 'endpoint-1',
          },
        })
      )

      app.use(
        '/test3',
        secureHeaders({
          reportTo: [
            {
              group: 'g1',
              max_age: 10886400,
              endpoints: [
                { url: 'https://a.example.com/reports' },
                { url: 'https://b.example.com/reports' },
              ],
            },
            {
              group: 'g2',
              max_age: 10886400,
              endpoints: [
                { url: 'https://c.example.com/reports' },
                { url: 'https://d.example.com/reports' },
              ],
            },
          ],
          [cspSettingName]: {
            defaultSrc: ["'self'"],
            reportTo: 'g2',
          },
        })
      )

      app.use(
        '/test4',
        secureHeaders({
          reportingEndpoints: [
            {
              name: 'e1',
              url: 'https://a.example.com/reports',
            },
            {
              name: 'e2',
              url: 'https://b.example.com/reports',
            },
          ],
          [cspSettingName]: {
            defaultSrc: ["'self'"],
            reportTo: 'e1',
          },
        })
      )

      app.all('*', async (c) => {
        return c.text('header updated')
      })

      const res1 = await app.request('/test1')
      expect(res1.headers.get('Reporting-Endpoints')).toEqual(
        'endpoint-1="https://example.com/reports"'
      )
      expect(res1.headers.get(cspHeaderName)).toEqual("default-src 'self'; report-to endpoint-1")

      const res2 = await app.request('/test2')
      expect(res2.headers.get('Report-To')).toEqual(
        '{"group":"endpoint-1","max_age":10886400,"endpoints":[{"url":"https://example.com/reports"}]}'
      )
      expect(res2.headers.get(cspHeaderName)).toEqual("default-src 'self'; report-to endpoint-1")

      const res3 = await app.request('/test3')
      expect(res3.headers.get('Report-To')).toEqual(
        '{"group":"g1","max_age":10886400,"endpoints":[{"url":"https://a.example.com/reports"},{"url":"https://b.example.com/reports"}]}, {"group":"g2","max_age":10886400,"endpoints":[{"url":"https://c.example.com/reports"},{"url":"https://d.example.com/reports"}]}'
      )
      expect(res3.headers.get(cspHeaderName)).toEqual("default-src 'self'; report-to g2")

      const res4 = await app.request('/test4')
      expect(res4.headers.get('Reporting-Endpoints')).toEqual(
        'e1="https://a.example.com/reports", e2="https://b.example.com/reports"'
      )
      expect(res4.headers.get(cspHeaderName)).toEqual("default-src 'self'; report-to e1")
    })

    it('CSP nonce for script-src', async () => {
      const app = new Hono()
      app.use(
        '/test',
        secureHeaders({
          [cspSettingName]: {
            scriptSrc: ["'self'", NONCE],
          },
        })
      )

      app.all('*', async (c) => {
        return c.text(`nonce: ${c.get('secureHeadersNonce')}`)
      })

      const res = await app.request('/test')
      const csp = res.headers.get(cspHeaderName)
      const nonce = csp?.match(/script-src 'self' 'nonce-([a-zA-Z0-9+/]+=*)'/)?.[1] || ''
      expect(csp).toMatch(`script-src 'self' 'nonce-${nonce}'`)
      expect(await res.text()).toEqual(`nonce: ${nonce}`)
    })

    it('CSP nonce for script-src and style-src', async () => {
      const app = new Hono()
      app.use(
        '/test',
        secureHeaders({
          [cspSettingName]: {
            scriptSrc: ["'self'", NONCE],
            styleSrc: ["'self'", NONCE],
          },
        })
      )

      app.all('*', async (c) => {
        return c.text(`nonce: ${c.get('secureHeadersNonce')}`)
      })

      const res = await app.request('/test')
      const csp = res.headers.get(cspHeaderName)
      const nonce = csp?.match(/script-src 'self' 'nonce-([a-zA-Z0-9+/]+=*)'/)?.[1] || ''
      expect(csp).toMatch(`script-src 'self' 'nonce-${nonce}'`)
      expect(csp).toMatch(`style-src 'self' 'nonce-${nonce}'`)
      expect(await res.text()).toEqual(`nonce: ${nonce}`)
    })

    it('CSP nonce by app own function', async () => {
      const app = new Hono()
      const setNonce: ContentSecurityPolicyOptionHandler = (ctx, directive) => {
        ctx.set(`test-${directive}-nonce`, directive)
        return `'nonce-${directive}'`
      }
      app.use(
        '/test',
        secureHeaders({
          [cspSettingName]: {
            scriptSrc: ["'self'", setNonce],
            styleSrc: ["'self'", setNonce],
          },
        })
      )

      app.all('*', async (c) => {
        return c.text(
          `script: ${c.get('test-scriptSrc-nonce')}, style: ${c.get('test-styleSrc-nonce')}`
        )
      })

      const res = await app.request('/test')
      const csp = res.headers.get(cspHeaderName)
      expect(csp).toMatch(`script-src 'self' 'nonce-scriptSrc'`)
      expect(csp).toMatch(`style-src 'self' 'nonce-styleSrc'`)
      expect(await res.text()).toEqual('script: scriptSrc, style: styleSrc')
    })
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/secure-headers/index.ts
```typescript
export type { ContentSecurityPolicyOptionHandler } from './secure-headers'
export { NONCE, secureHeaders } from './secure-headers'
import type { SecureHeadersVariables } from './secure-headers'
export type { SecureHeadersVariables }

declare module '../..' {
  interface ContextVariableMap extends SecureHeadersVariables {}
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/secure-headers/permissions-policy.ts
```typescript
// https://github.com/w3c/webappsec-permissions-policy/blob/main/features.md

export type PermissionsPolicyDirective =
  | StandardizedFeatures
  | ProposedFeatures
  | ExperimentalFeatures

/**
 * These features have been declared in a published version of the respective specification.
 */
type StandardizedFeatures =
  | 'accelerometer'
  | 'ambientLightSensor'
  | 'attributionReporting'
  | 'autoplay'
  | 'battery'
  | 'bluetooth'
  | 'camera'
  | 'chUa'
  | 'chUaArch'
  | 'chUaBitness'
  | 'chUaFullVersion'
  | 'chUaFullVersionList'
  | 'chUaMobile'
  | 'chUaModel'
  | 'chUaPlatform'
  | 'chUaPlatformVersion'
  | 'chUaWow64'
  | 'computePressure'
  | 'crossOriginIsolated'
  | 'directSockets'
  | 'displayCapture'
  | 'encryptedMedia'
  | 'executionWhileNotRendered'
  | 'executionWhileOutOfViewport'
  | 'fullscreen'
  | 'geolocation'
  | 'gyroscope'
  | 'hid'
  | 'identityCredentialsGet'
  | 'idleDetection'
  | 'keyboardMap'
  | 'magnetometer'
  | 'microphone'
  | 'midi'
  | 'navigationOverride'
  | 'payment'
  | 'pictureInPicture'
  | 'publickeyCredentialsGet'
  | 'screenWakeLock'
  | 'serial'
  | 'storageAccess'
  | 'syncXhr'
  | 'usb'
  | 'webShare'
  | 'windowManagement'
  | 'xrSpatialTracking'

/**
 * These features have been proposed, but the definitions have not yet been integrated into their respective specs.
 */
type ProposedFeatures =
  | 'clipboardRead'
  | 'clipboardWrite'
  | 'gemepad'
  | 'sharedAutofill'
  | 'speakerSelection'

/**
 * These features generally have an explainer only, but may be available for experimentation by web developers.
 */
type ExperimentalFeatures =
  | 'allScreensCapture'
  | 'browsingTopics'
  | 'capturedSurfaceControl'
  | 'conversionMeasurement'
  | 'digitalCredentialsGet'
  | 'focusWithoutUserActivation'
  | 'joinAdInterestGroup'
  | 'localFonts'
  | 'runAdAuction'
  | 'smartCard'
  | 'syncScript'
  | 'trustTokenRedemption'
  | 'unload'
  | 'verticalScroll'

```
/Users/josh/Documents/GitHub/honojs/hono/src/middleware/secure-headers/secure-headers.ts
````typescript
/**
 * @module
 * Secure Headers Middleware for Hono.
 */

import type { Context } from '../../context'
import type { MiddlewareHandler } from '../../types'
import { encodeBase64 } from '../../utils/encode'
import type { PermissionsPolicyDirective } from './permissions-policy'

export type SecureHeadersVariables = {
  secureHeadersNonce?: string
}

export type ContentSecurityPolicyOptionHandler = (ctx: Context, directive: string) => string
type ContentSecurityPolicyOptionValue = (string | ContentSecurityPolicyOptionHandler)[]

interface ContentSecurityPolicyOptions {
  defaultSrc?: ContentSecurityPolicyOptionValue
  baseUri?: ContentSecurityPolicyOptionValue
  childSrc?: ContentSecurityPolicyOptionValue
  connectSrc?: ContentSecurityPolicyOptionValue
  fontSrc?: ContentSecurityPolicyOptionValue
  formAction?: ContentSecurityPolicyOptionValue
  frameAncestors?: ContentSecurityPolicyOptionValue
  frameSrc?: ContentSecurityPolicyOptionValue
  imgSrc?: ContentSecurityPolicyOptionValue
  manifestSrc?: ContentSecurityPolicyOptionValue
  mediaSrc?: ContentSecurityPolicyOptionValue
  objectSrc?: ContentSecurityPolicyOptionValue
  reportTo?: string
  sandbox?: ContentSecurityPolicyOptionValue
  scriptSrc?: ContentSecurityPolicyOptionValue
  scriptSrcAttr?: ContentSecurityPolicyOptionValue
  scriptSrcElem?: ContentSecurityPolicyOptionValue
  styleSrc?: ContentSecurityPolicyOptionValue
  styleSrcAttr?: ContentSecurityPolicyOptionValue
  styleSrcElem?: ContentSecurityPolicyOptionValue
  upgradeInsecureRequests?: ContentSecurityPolicyOptionValue
  workerSrc?: ContentSecurityPolicyOptionValue
}

interface ReportToOptions {
  group: string
  max_age: number
  endpoints: ReportToEndpoint[]
}

interface ReportToEndpoint {
  url: string
}

interface ReportingEndpointOptions {
  name: string
  url: string
}

type PermissionsPolicyValue = '*' | 'self' | 'src' | 'none' | string

type PermissionsPolicyOptions = Partial<
  Record<PermissionsPolicyDirective, PermissionsPolicyValue[] | boolean>
>

type overridableHeader = boolean | string

interface SecureHeadersOptions {
  contentSecurityPolicy?: ContentSecurityPolicyOptions
  contentSecurityPolicyReportOnly?: ContentSecurityPolicyOptions
  crossOriginEmbedderPolicy?: overridableHeader
  crossOriginResourcePolicy?: overridableHeader
  crossOriginOpenerPolicy?: overridableHeader
  originAgentCluster?: overridableHeader
  referrerPolicy?: overridableHeader
  reportingEndpoints?: ReportingEndpointOptions[]
  reportTo?: ReportToOptions[]
  strictTransportSecurity?: overridableHeader
  xContentTypeOptions?: overridableHeader
  xDnsPrefetchControl?: overridableHeader
  xDownloadOptions?: overridableHeader
  xFrameOptions?: overridableHeader
  xPermittedCrossDomainPolicies?: overridableHeader
  xXssProtection?: overridableHeader
  removePoweredBy?: boolean
  permissionsPolicy?: PermissionsPolicyOptions
}

type HeadersMap = {
  [key in keyof SecureHeadersOptions]: [string, string]
}

const HEADERS_MAP: HeadersMap = {
  crossOriginEmbedderPolicy: ['Cross-Origin-Embedder-Policy', 'require-corp'],
  crossOriginResourcePolicy: ['Cross-Origin-Resource-Policy', 'same-origin'],
  crossOriginOpenerPolicy: ['Cross-Origin-Opener-Policy', 'same-origin'],
  originAgentCluster: ['Origin-Agent-Cluster', '?1'],
  referrerPolicy: ['Referrer-Policy', 'no-referrer'],
  strictTransportSecurity: ['Strict-Transport-Security', 'max-age=15552000; includeSubDomains'],
  xContentTypeOptions: ['X-Content-Type-Options', 'nosniff'],
  xDnsPrefetchControl: ['X-DNS-Prefetch-Control', 'off'],
  xDownloadOptions: ['X-Download-Options', 'noopen'],
  xFrameOptions: ['X-Frame-Options', 'SAMEORIGIN'],
  xPermittedCrossDomainPolicies: ['X-Permitted-Cross-Domain-Policies', 'none'],
  xXssProtection: ['X-XSS-Protection', '0'],
}

const DEFAULT_OPTIONS: SecureHeadersOptions = {
  crossOriginEmbedderPolicy: false,
  crossOriginResourcePolicy: true,
  crossOriginOpenerPolicy: true,
  originAgentCluster: true,
  referrerPolicy: true,
  strictTransportSecurity: true,
  xContentTypeOptions: true,
  xDnsPrefetchControl: true,
  xDownloadOptions: true,
  xFrameOptions: true,
  xPermittedCrossDomainPolicies: true,
  xXssProtection: true,
  removePoweredBy: true,
  permissionsPolicy: {},
}

type SecureHeadersCallback = (
  ctx: Context,
  headersToSet: [string, string | string[]][]
) => [string, string][]

const generateNonce = () => {
  const arrayBuffer = new Uint8Array(16)
  crypto.getRandomValues(arrayBuffer)
  return encodeBase64(arrayBuffer.buffer)
}

export const NONCE: ContentSecurityPolicyOptionHandler = (ctx) => {
  const key = 'secureHeadersNonce'
  const init = ctx.get(key)
  const nonce = init || generateNonce()
  if (init == null) {
    ctx.set(key, nonce)
  }
  return `'nonce-${nonce}'`
}

/**
 * Secure Headers Middleware for Hono.
 *
 * @see {@link https://hono.dev/docs/middleware/builtin/secure-headers}
 *
 * @param {Partial<SecureHeadersOptions>} [customOptions] - The options for the secure headers middleware.
 * @param {ContentSecurityPolicyOptions} [customOptions.contentSecurityPolicy] - Settings for the Content-Security-Policy header.
 * @param {ContentSecurityPolicyOptions} [customOptions.contentSecurityPolicyReportOnly] - Settings for the Content-Security-Policy-Report-Only header.
 * @param {overridableHeader} [customOptions.crossOriginEmbedderPolicy=false] - Settings for the Cross-Origin-Embedder-Policy header.
 * @param {overridableHeader} [customOptions.crossOriginResourcePolicy=true] - Settings for the Cross-Origin-Resource-Policy header.
 * @param {overridableHeader} [customOptions.crossOriginOpenerPolicy=true] - Settings for the Cross-Origin-Opener-Policy header.
 * @param {overridableHeader} [customOptions.originAgentCluster=true] - Settings for the Origin-Agent-Cluster header.
 * @param {overridableHeader} [customOptions.referrerPolicy=true] - Settings for the Referrer-Policy header.
 * @param {ReportingEndpointOptions[]} [customOptions.reportingEndpoints] - Settings for the Reporting-Endpoints header.
 * @param {ReportToOptions[]} [customOptions.reportTo] - Settings for the Report-To header.
 * @param {overridableHeader} [customOptions.strictTransportSecurity=true] - Settings for the Strict-Transport-Security header.
 * @param {overridableHeader} [customOptions.xContentTypeOptions=true] - Settings for the X-Content-Type-Options header.
 * @param {overridableHeader} [customOptions.xDnsPrefetchControl=true] - Settings for the X-DNS-Prefetch-Control header.
 * @param {overridableHeader} [customOptions.xDownloadOptions=true] - Settings for the X-Download-Options header.
 * @param {overridableHeader} [customOptions.xFrameOptions=true] - Settings for the X-Frame-Options header.
 * @param {overridableHeader} [customOptions.xPermittedCrossDomainPolicies=true] - Settings for the X-Permitted-Cross-Domain-Policies header.
 * @param {overridableHeader} [customOptions.xXssProtection=true] - Settings for the X-XSS-Protection header.
 * @param {boolean} [customOptions.removePoweredBy=true] - Settings for remove X-Powered-By header.
 * @param {PermissionsPolicyOptions} [customOptions.permissionsPolicy] - Settings for the Permissions-Policy header.
 * @returns {MiddlewareHandler} The middleware handler function.
 *
 * @example
 * ```ts
 * const app = new Hono()
 * app.use(secureHeaders())
 * ```
 */
export const secureHeaders = (customOptions?: SecureHeadersOptions): MiddlewareHandler => {
  const options = { ...DEFAULT_OPTIONS, ...customOptions }
  const headersToSet = getFilteredHeaders(options)
  const callbacks: SecureHeadersCallback[] = []

  if (options.contentSecurityPolicy) {
    const [callback, value] = getCSPDirectives(options.contentSecurityPolicy)
    if (callback) {
      callbacks.push(callback)
    }
    headersToSet.push(['Content-Security-Policy', value as string])
  }

  if (options.contentSecurityPolicyReportOnly) {
    const [callback, value] = getCSPDirectives(options.contentSecurityPolicyReportOnly)
    if (callback) {
      callbacks.push(callback)
    }
    headersToSet.push(['Content-Security-Policy-Report-Only', value as string])
  }

  if (options.permissionsPolicy && Object.keys(options.permissionsPolicy).length > 0) {
    headersToSet.push([
      'Permissions-Policy',
      getPermissionsPolicyDirectives(options.permissionsPolicy),
    ])
  }

  if (options.reportingEndpoints) {
    headersToSet.push(['Reporting-Endpoints', getReportingEndpoints(options.reportingEndpoints)])
  }

  if (options.reportTo) {
    headersToSet.push(['Report-To', getReportToOptions(options.reportTo)])
  }

  return async function secureHeaders(ctx, next) {
    // should evaluate callbacks before next()
    // some callback calls ctx.set() for embedding nonce to the page
    const headersToSetForReq =
      callbacks.length === 0
        ? headersToSet
        : callbacks.reduce((acc, cb) => cb(ctx, acc), headersToSet)
    await next()
    setHeaders(ctx, headersToSetForReq)

    if (options?.removePoweredBy) {
      ctx.res.headers.delete('X-Powered-By')
    }
  }
}

function getFilteredHeaders(options: SecureHeadersOptions): [string, string][] {
  return Object.entries(HEADERS_MAP)
    .filter(([key]) => options[key as keyof SecureHeadersOptions])
    .map(([key, defaultValue]) => {
      const overrideValue = options[key as keyof SecureHeadersOptions]
      return typeof overrideValue === 'string' ? [defaultValue[0], overrideValue] : defaultValue
    })
}

function getCSPDirectives(
  contentSecurityPolicy: ContentSecurityPolicyOptions
): [SecureHeadersCallback | undefined, string | string[]] {
  const callbacks: ((ctx: Context, values: string[]) => void)[] = []
  const resultValues: string[] = []

  for (const [directive, value] of Object.entries(contentSecurityPolicy)) {
    const valueArray = Array.isArray(value) ? value : [value]

    valueArray.forEach((value, i) => {
      if (typeof value === 'function') {
        const index = i * 2 + 2 + resultValues.length
        callbacks.push((ctx, values) => {
          values[index] = value(ctx, directive)
        })
      }
    })

    resultValues.push(
      directive.replace(/[A-Z]+(?![a-z])|[A-Z]/g, (match, offset) =>
        offset ? '-' + match.toLowerCase() : match.toLowerCase()
      ),
      ...valueArray.flatMap((value) => [' ', value]),
      '; '
    )
  }
  resultValues.pop()

  return callbacks.length === 0
    ? [undefined, resultValues.join('')]
    : [
        (ctx, headersToSet) =>
          headersToSet.map((values) => {
            if (
              values[0] === 'Content-Security-Policy' ||
              values[0] === 'Content-Security-Policy-Report-Only'
            ) {
              const clone = values[1].slice() as unknown as string[]
              callbacks.forEach((cb) => {
                cb(ctx, clone)
              })
              return [values[0], clone.join('')]
            } else {
              return values as [string, string]
            }
          }),
        resultValues,
      ]
}

function getPermissionsPolicyDirectives(policy: PermissionsPolicyOptions): string {
  return Object.entries(policy)
    .map(([directive, value]) => {
      const kebabDirective = camelToKebab(directive)

      if (typeof value === 'boolean') {
        return `${kebabDirective}=${value ? '*' : 'none'}`
      }

      if (Array.isArray(value)) {
        if (value.length === 0) {
          return `${kebabDirective}=()`
        }
        if (value.length === 1 && (value[0] === '*' || value[0] === 'none')) {
          return `${kebabDirective}=${value[0]}`
        }
        const allowlist = value.map((item) => (['self', 'src'].includes(item) ? item : `"${item}"`))
        return `${kebabDirective}=(${allowlist.join(' ')})`
      }

      return ''
    })
    .filter(Boolean)
    .join(', ')
}

function camelToKebab(str: string): string {
  return str.replace(/([a-z\d])([A-Z])/g, '$1-$2').toLowerCase()
}

function getReportingEndpoints(
  reportingEndpoints: SecureHeadersOptions['reportingEndpoints'] = []
): string {
  return reportingEndpoints.map((endpoint) => `${endpoint.name}="${endpoint.url}"`).join(', ')
}

function getReportToOptions(reportTo: SecureHeadersOptions['reportTo'] = []): string {
  return reportTo.map((option) => JSON.stringify(option)).join(', ')
}

function setHeaders(ctx: Context, headersToSet: [string, string][]) {
  headersToSet.forEach(([header, value]) => {
    ctx.res.headers.set(header, value)
  })
}

````
