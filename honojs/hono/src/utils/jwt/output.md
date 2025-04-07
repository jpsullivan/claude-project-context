/Users/josh/Documents/GitHub/honojs/hono/src/utils/jwt/index.ts
```typescript
/**
 * @module
 * JWT utility.
 */

import { decode, sign, verify, verifyFromJwks } from './jwt'
export const Jwt = { sign, verify, decode, verifyFromJwks }

```
/Users/josh/Documents/GitHub/honojs/hono/src/utils/jwt/jwa.test.ts
```typescript
import { AlgorithmTypes } from './jwa'

describe('Types', () => {
  it('AlgorithmTypes', () => {
    expect('HS256' as AlgorithmTypes).toBe(AlgorithmTypes.HS256)
    expect('HS384' as AlgorithmTypes).toBe(AlgorithmTypes.HS384)
    expect('HS512' as AlgorithmTypes).toBe(AlgorithmTypes.HS512)
    expect('RS256' as AlgorithmTypes).toBe(AlgorithmTypes.RS256)
    expect('RS384' as AlgorithmTypes).toBe(AlgorithmTypes.RS384)
    expect('RS512' as AlgorithmTypes).toBe(AlgorithmTypes.RS512)

    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    expect(undefined as AlgorithmTypes).toBe(undefined)
    expect('' as AlgorithmTypes).toBe('')
  })
})

```
/Users/josh/Documents/GitHub/honojs/hono/src/utils/jwt/jwa.ts
```typescript
/**
 * @module
 * JSON Web Algorithms (JWA)
 * https://datatracker.ietf.org/doc/html/rfc7518
 */

export enum AlgorithmTypes {
  HS256 = 'HS256',
  HS384 = 'HS384',
  HS512 = 'HS512',
  RS256 = 'RS256',
  RS384 = 'RS384',
  RS512 = 'RS512',
  PS256 = 'PS256',
  PS384 = 'PS384',
  PS512 = 'PS512',
  ES256 = 'ES256',
  ES384 = 'ES384',
  ES512 = 'ES512',
  EdDSA = 'EdDSA',
}

export type SignatureAlgorithm = keyof typeof AlgorithmTypes

```
/Users/josh/Documents/GitHub/honojs/hono/src/utils/jwt/jws.ts
```typescript
/**
 * @module
 * JSON Web Signature (JWS)
 * https://datatracker.ietf.org/doc/html/rfc7515
 */

import { getRuntimeKey } from '../../helper/adapter'
import { decodeBase64 } from '../encode'
import type { SignatureAlgorithm } from './jwa'
import { CryptoKeyUsage, JwtAlgorithmNotImplemented } from './types'
import { utf8Encoder } from './utf8'

type KeyImporterAlgorithm = Parameters<typeof crypto.subtle.importKey>[2]
type KeyAlgorithm =
  | AlgorithmIdentifier
  | RsaHashedImportParams
  | (RsaPssParams & RsaHashedImportParams)
  | (EcdsaParams & EcKeyImportParams)
  | HmacImportParams

// Extending the JsonWebKey interface to include the "kid" property.
// https://datatracker.ietf.org/doc/html/rfc7515#section-4.1.4
export interface HonoJsonWebKey extends JsonWebKey {
  kid?: string
}

export type SignatureKey = string | HonoJsonWebKey | CryptoKey

export async function signing(
  privateKey: SignatureKey,
  alg: SignatureAlgorithm,
  data: BufferSource
): Promise<ArrayBuffer> {
  const algorithm = getKeyAlgorithm(alg)
  const cryptoKey = await importPrivateKey(privateKey, algorithm)
  return await crypto.subtle.sign(algorithm, cryptoKey, data)
}

export async function verifying(
  publicKey: SignatureKey,
  alg: SignatureAlgorithm,
  signature: BufferSource,
  data: BufferSource
): Promise<boolean> {
  const algorithm = getKeyAlgorithm(alg)
  const cryptoKey = await importPublicKey(publicKey, algorithm)
  return await crypto.subtle.verify(algorithm, cryptoKey, signature, data)
}

function pemToBinary(pem: string): Uint8Array {
  return decodeBase64(pem.replace(/-+(BEGIN|END).*/g, '').replace(/\s/g, ''))
}

async function importPrivateKey(key: SignatureKey, alg: KeyImporterAlgorithm): Promise<CryptoKey> {
  if (!crypto.subtle || !crypto.subtle.importKey) {
    throw new Error('`crypto.subtle.importKey` is undefined. JWT auth middleware requires it.')
  }
  if (isCryptoKey(key)) {
    if (key.type !== 'private' && key.type !== 'secret') {
      throw new Error(
        `unexpected key type: CryptoKey.type is ${key.type}, expected private or secret`
      )
    }
    return key
  }
  const usages = [CryptoKeyUsage.Sign]
  if (typeof key === 'object') {
    // https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/importKey#json_web_key_import
    return await crypto.subtle.importKey('jwk', key, alg, false, usages)
  }
  if (key.includes('PRIVATE')) {
    // https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/importKey#pkcs_8_import
    return await crypto.subtle.importKey('pkcs8', pemToBinary(key), alg, false, usages)
  }
  return await crypto.subtle.importKey('raw', utf8Encoder.encode(key), alg, false, usages)
}

async function importPublicKey(key: SignatureKey, alg: KeyImporterAlgorithm): Promise<CryptoKey> {
  if (!crypto.subtle || !crypto.subtle.importKey) {
    throw new Error('`crypto.subtle.importKey` is undefined. JWT auth middleware requires it.')
  }
  if (isCryptoKey(key)) {
    if (key.type === 'public' || key.type === 'secret') {
      return key
    }
    key = await exportPublicJwkFrom(key)
  }
  if (typeof key === 'string' && key.includes('PRIVATE')) {
    // https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/importKey#pkcs_8_import
    const privateKey = await crypto.subtle.importKey('pkcs8', pemToBinary(key), alg, true, [
      CryptoKeyUsage.Sign,
    ])
    key = await exportPublicJwkFrom(privateKey)
  }
  const usages = [CryptoKeyUsage.Verify]
  if (typeof key === 'object') {
    // https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/importKey#json_web_key_import
    return await crypto.subtle.importKey('jwk', key, alg, false, usages)
  }
  if (key.includes('PUBLIC')) {
    // https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/importKey#subjectpublickeyinfo_import
    return await crypto.subtle.importKey('spki', pemToBinary(key), alg, false, usages)
  }
  return await crypto.subtle.importKey('raw', utf8Encoder.encode(key), alg, false, usages)
}

// https://datatracker.ietf.org/doc/html/rfc7517
async function exportPublicJwkFrom(privateKey: CryptoKey): Promise<JsonWebKey> {
  if (privateKey.type !== 'private') {
    throw new Error(`unexpected key type: ${privateKey.type}`)
  }
  if (!privateKey.extractable) {
    throw new Error('unexpected private key is unextractable')
  }
  const jwk = await crypto.subtle.exportKey('jwk', privateKey)
  const { kty } = jwk // common
  const { alg, e, n } = jwk // rsa
  const { crv, x, y } = jwk // elliptic-curve
  return { kty, alg, e, n, crv, x, y, key_ops: [CryptoKeyUsage.Verify] }
}

function getKeyAlgorithm(name: SignatureAlgorithm): KeyAlgorithm {
  switch (name) {
    case 'HS256':
      return {
        name: 'HMAC',
        hash: {
          name: 'SHA-256',
        },
      } satisfies HmacImportParams
    case 'HS384':
      return {
        name: 'HMAC',
        hash: {
          name: 'SHA-384',
        },
      } satisfies HmacImportParams
    case 'HS512':
      return {
        name: 'HMAC',
        hash: {
          name: 'SHA-512',
        },
      } satisfies HmacImportParams
    case 'RS256':
      return {
        name: 'RSASSA-PKCS1-v1_5',
        hash: {
          name: 'SHA-256',
        },
      } satisfies RsaHashedImportParams
    case 'RS384':
      return {
        name: 'RSASSA-PKCS1-v1_5',
        hash: {
          name: 'SHA-384',
        },
      } satisfies RsaHashedImportParams
    case 'RS512':
      return {
        name: 'RSASSA-PKCS1-v1_5',
        hash: {
          name: 'SHA-512',
        },
      } satisfies RsaHashedImportParams
    case 'PS256':
      return {
        name: 'RSA-PSS',
        hash: {
          name: 'SHA-256',
        },
        saltLength: 32, // 256 >> 3
      } satisfies RsaPssParams & RsaHashedImportParams
    case 'PS384':
      return {
        name: 'RSA-PSS',
        hash: {
          name: 'SHA-384',
        },
        saltLength: 48, // 384 >> 3
      } satisfies RsaPssParams & RsaHashedImportParams
    case 'PS512':
      return {
        name: 'RSA-PSS',
        hash: {
          name: 'SHA-512',
        },
        saltLength: 64, // 512 >> 3,
      } satisfies RsaPssParams & RsaHashedImportParams
    case 'ES256':
      return {
        name: 'ECDSA',
        hash: {
          name: 'SHA-256',
        },
        namedCurve: 'P-256',
      } satisfies EcdsaParams & EcKeyImportParams
    case 'ES384':
      return {
        name: 'ECDSA',
        hash: {
          name: 'SHA-384',
        },
        namedCurve: 'P-384',
      } satisfies EcdsaParams & EcKeyImportParams
    case 'ES512':
      return {
        name: 'ECDSA',
        hash: {
          name: 'SHA-512',
        },
        namedCurve: 'P-521',
      } satisfies EcdsaParams & EcKeyImportParams
    case 'EdDSA':
      // Currently, supported only Safari and Deno, Node.js.
      // See: https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/verify
      return {
        name: 'Ed25519',
        namedCurve: 'Ed25519',
      }
    default:
      throw new JwtAlgorithmNotImplemented(name)
  }
}

function isCryptoKey(key: SignatureKey): key is CryptoKey {
  const runtime = getRuntimeKey()
  // @ts-expect-error CryptoKey hasn't exported to global in node v18
  if (runtime === 'node' && !!crypto.webcrypto) {
    // @ts-expect-error CryptoKey hasn't exported to global in node v18
    return key instanceof crypto.webcrypto.CryptoKey
  }
  return key instanceof CryptoKey
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/utils/jwt/jwt.test.ts
```typescript
/* eslint-disable @typescript-eslint/ban-ts-comment */
import { vi } from 'vitest'
import { encodeBase64 } from '../encode'
import { AlgorithmTypes } from './jwa'
import * as JWT from './jwt'
import {
  JwtAlgorithmNotImplemented,
  JwtTokenExpired,
  JwtTokenInvalid,
  JwtTokenIssuedAt,
  JwtTokenNotBefore,
  JwtTokenSignatureMismatched,
} from './types'

describe('isTokenHeader', () => {
  it('should return true for valid TokenHeader', () => {
    const validTokenHeader: JWT.TokenHeader = {
      alg: AlgorithmTypes.HS256,
      typ: 'JWT',
    }

    expect(JWT.isTokenHeader(validTokenHeader)).toBe(true)
  })

  it('should return false for invalid TokenHeader', () => {
    const invalidTokenHeader = {
      alg: 'invalid',
      typ: 'JWT',
    }

    expect(JWT.isTokenHeader(invalidTokenHeader)).toBe(false)
  })

  it('returns true even if the typ field is absent in a TokenHeader', () => {
    const validTokenHeader: JWT.TokenHeader = {
      alg: AlgorithmTypes.HS256,
    }

    expect(JWT.isTokenHeader(validTokenHeader)).toBe(true)
  })

  it('returns false when the typ field is present but empty', () => {
    const invalidTokenHeader = {
      alg: AlgorithmTypes.HS256,
      typ: '',
    }

    expect(JWT.isTokenHeader(invalidTokenHeader)).toBe(false)
  })
})

describe('JWT', () => {
  it('JwtAlgorithmNotImplemented', async () => {
    const payload = { message: 'hello world' }
    const secret = 'a-secret'
    const alg = ''
    let tok = ''
    let err: JwtAlgorithmNotImplemented
    try {
      tok = await JWT.sign(payload, secret, alg as AlgorithmTypes)
    } catch (e) {
      err = e as JwtAlgorithmNotImplemented
    }
    expect(tok).toBe('')
    // @ts-ignore
    expect(err).toEqual(new JwtAlgorithmNotImplemented(alg))
  })

  it('JwtTokenInvalid', async () => {
    const tok = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ'
    const secret = 'a-secret'
    let err: JwtTokenInvalid
    let authorized
    try {
      authorized = await JWT.verify(tok, secret, AlgorithmTypes.HS256)
    } catch (e) {
      err = e as JwtTokenInvalid
    }
    // @ts-ignore
    expect(err).toEqual(new JwtTokenInvalid(tok))
    expect(authorized).toBeUndefined()
  })

  it('JwtTokenNotBefore', async () => {
    const tok =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2NjQ2MDYzMzQsImV4cCI6MTY2NDYwOTkzNCwibmJmIjoiMzEwNDYwNjI2NCJ9.hpSDT_cfkxeiLWEpWVT8TDxFP3dFi27q1K7CcMcLXHc'
    const secret = 'a-secret'
    let err: JwtTokenNotBefore
    let authorized
    try {
      authorized = await JWT.verify(tok, secret, AlgorithmTypes.HS256)
    } catch (e) {
      err = e as JwtTokenNotBefore
    }
    // @ts-ignore
    expect(err).toEqual(new JwtTokenNotBefore(tok))
    expect(authorized).toBeUndefined()
  })

  it('JwtTokenExpired', async () => {
    const tok =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MzMwNDYxMDAsImV4cCI6MTYzMzA0NjQwMH0.H-OI1TWAbmK8RonvcpPaQcNvOKS9sxinEOsgKwjoiVo'
    const secret = 'a-secret'
    let err
    let authorized
    try {
      authorized = await JWT.verify(tok, secret, AlgorithmTypes.HS256)
    } catch (e) {
      err = e
    }
    expect(err).toEqual(new JwtTokenExpired(tok))
    expect(authorized).toBeUndefined()
  })

  it('JwtTokenIssuedAt', async () => {
    const now = 1633046400
    vi.useFakeTimers().setSystemTime(new Date().setTime(now * 1000))

    const iat = now + 1000 // after 1s
    const payload = { role: 'api_role', iat }
    const secret = 'a-secret'
    const tok = await JWT.sign(payload, secret, AlgorithmTypes.HS256)

    let err
    let authorized
    try {
      authorized = await JWT.verify(tok, secret, AlgorithmTypes.HS256)
    } catch (e) {
      err = e
    }
    expect(err).toEqual(new JwtTokenIssuedAt(now, iat))
    expect(authorized).toBeUndefined()
  })

  it('HS256 sign & verify & decode', async () => {
    const payload = { message: 'hello world' }
    const secret = 'a-secret'
    const tok = await JWT.sign(payload, secret, AlgorithmTypes.HS256)
    const expected =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE'
    expect(tok).toEqual(expected)

    const verifiedPayload = await JWT.verify(tok, secret, AlgorithmTypes.HS256)
    expect(verifiedPayload).not.toBeUndefined()
    expect(verifiedPayload).toEqual(payload)

    expect(JWT.decode(tok)).toEqual({
      header: {
        alg: 'HS256',
        typ: 'JWT',
      },
      payload: {
        message: 'hello world',
      },
    })
  })

  it('HS256 sign & verify', async () => {
    const payload = { message: 'hello world' }
    const secret = 'a-secret'
    const tok = await JWT.sign(payload, secret, AlgorithmTypes.HS256)
    const expected =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.B54pAqIiLbu170tGQ1rY06Twv__0qSHTA0ioQPIOvFE'
    expect(tok).toEqual(expected)

    let err = null
    let authorized
    try {
      authorized = await JWT.verify(tok, secret + 'invalid', AlgorithmTypes.HS256)
    } catch (e) {
      err = e
    }
    expect(authorized).toBeUndefined()
    expect(err instanceof JwtTokenSignatureMismatched).toBe(true)
  })

  it('HS512 sign & verify & decode', async () => {
    const payload = { message: 'hello world' }
    const secret = 'a-secret'
    const tok = await JWT.sign(payload, secret, AlgorithmTypes.HS512)
    const expected =
      'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.RqVLgExB_GXF1-9T-k4V4HjFmiuQKTEjVSiZd-YL0WERIlywZ7PfzAuTZSJU4gg8cscGamQa030cieEWrYcywg'
    expect(tok).toEqual(expected)

    const verifiedPayload = await JWT.verify(tok, secret, AlgorithmTypes.HS512)
    expect(verifiedPayload).not.toBeUndefined()
    expect(verifiedPayload).toEqual(payload)

    expect(JWT.decode(tok)).toEqual({
      header: {
        alg: 'HS512',
        typ: 'JWT',
      },
      payload: {
        message: 'hello world',
      },
    })
  })

  it('HS512 sign & verify', async () => {
    const payload = { message: 'hello world' }
    const secret = 'a-secret'
    const tok = await JWT.sign(payload, secret, AlgorithmTypes.HS512)
    const expected =
      'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.RqVLgExB_GXF1-9T-k4V4HjFmiuQKTEjVSiZd-YL0WERIlywZ7PfzAuTZSJU4gg8cscGamQa030cieEWrYcywg'
    expect(tok).toEqual(expected)

    let err = null
    let authorized
    try {
      authorized = await JWT.verify(tok, secret + 'invalid', AlgorithmTypes.HS256)
    } catch (e) {
      err = e
    }
    expect(authorized).toBeUndefined()
    expect(err instanceof JwtTokenSignatureMismatched).toBe(true)
  })

  it('HS384 sign & verify', async () => {
    const payload = { message: 'hello world' }
    const secret = 'a-secret%你好'
    const tok = await JWT.sign(payload, secret, AlgorithmTypes.HS384)
    const expected =
      'eyJhbGciOiJIUzM4NCIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.C1Br1183Oy6O7th4NDCOaI9WB75i3FMCuYlv1tCL9HggsU89T-SNutghwhJykD3r'
    expect(tok).toEqual(expected)

    let err = null
    let authorized
    try {
      authorized = await JWT.verify(tok, secret + 'invalid', AlgorithmTypes.HS256)
    } catch (e) {
      err = e
    }
    expect(authorized).toBeUndefined()
    expect(err instanceof JwtTokenSignatureMismatched).toBe(true)
  })

  it('sign & verify & decode with a custom secret', async () => {
    const payload = { message: 'hello world' }
    const algorithm = {
      name: 'HMAC',
      hash: {
        name: 'SHA-256',
      },
    }
    const secret = await crypto.subtle.importKey(
      'raw',
      Buffer.from('cefb73234d5fae4bf27662900732b52943e8d53e871fe0f353da95de4599c21d', 'hex'),
      algorithm,
      false,
      ['sign', 'verify']
    )
    const tok = await JWT.sign(payload, secret)
    const expected =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXNzYWdlIjoiaGVsbG8gd29ybGQifQ.qunGhchNXH_unqWXN6hB0Elhzr5SykSXVhklLti1aFI'
    expect(tok).toEqual(expected)

    const verifiedPayload = await JWT.verify(tok, secret)
    expect(verifiedPayload).not.toBeUndefined()
    expect(verifiedPayload).toEqual(payload)

    const invalidSecret = await crypto.subtle.importKey(
      'raw',
      Buffer.from('cefb73234d5fae4bf27662900732b52943e8d53e871fe0f353da95de41111111', 'hex'),
      algorithm,
      false,
      ['sign', 'verify']
    )
    let err = null
    let authorized
    try {
      authorized = await JWT.verify(tok, invalidSecret)
    } catch (e) {
      err = e
    }
    expect(authorized).toBeUndefined()
    expect(err instanceof JwtTokenSignatureMismatched).toBe(true)
  })

  const rsTestCases = [
    {
      alg: AlgorithmTypes.RS256,
      hash: 'SHA-256',
    },
    {
      alg: AlgorithmTypes.RS384,
      hash: 'SHA-384',
    },
    {
      alg: AlgorithmTypes.RS512,
      hash: 'SHA-512',
    },
  ]
  for (const tc of rsTestCases) {
    it(`${tc.alg} sign & verify`, async () => {
      const alg = tc.alg
      const payload = { message: 'hello world' }
      const keyPair = await generateRSAKey(tc.hash)
      const pemPrivateKey = await exportPEMPrivateKey(keyPair.privateKey)
      const pemPublicKey = await exportPEMPublicKey(keyPair.publicKey)
      const jwkPublicKey = await exportJWK(keyPair.publicKey)

      const tok = await JWT.sign(payload, pemPrivateKey, alg)
      expect(await JWT.verify(tok, pemPublicKey, alg)).toEqual(payload)
      expect(await JWT.verify(tok, pemPrivateKey, alg)).toEqual(payload)
      expect(await JWT.verify(tok, jwkPublicKey, alg)).toEqual(payload)

      const keyPair2 = await generateRSAKey(tc.hash)
      const unexpectedPemPublicKey = await exportPEMPublicKey(keyPair2.publicKey)

      let err = null
      let authorized
      try {
        authorized = await JWT.verify(tok, unexpectedPemPublicKey, alg)
      } catch (e) {
        err = e
      }
      expect(authorized).toBeUndefined()
      expect(err instanceof JwtTokenSignatureMismatched).toBe(true)
    })

    it(`${tc.alg} sign & verify w/ CryptoKey`, async () => {
      const alg = tc.alg
      const payload = { message: 'hello world' }
      const keyPair = await generateRSAKey(tc.hash)

      const tok = await JWT.sign(payload, keyPair.privateKey, alg)
      expect(await JWT.verify(tok, keyPair.privateKey, alg)).toEqual(payload)
      expect(await JWT.verify(tok, keyPair.publicKey, alg)).toEqual(payload)
    })
  }

  const psTestCases = [
    {
      alg: AlgorithmTypes.PS256,
      hash: 'SHA-256',
    },
    {
      alg: AlgorithmTypes.PS384,
      hash: 'SHA-384',
    },
    {
      alg: AlgorithmTypes.PS512,
      hash: 'SHA-512',
    },
  ]
  for (const tc of psTestCases) {
    it(`${tc.alg} sign & verify`, async () => {
      const alg = tc.alg
      const payload = { message: 'hello world' }
      const keyPair = await generateRSAPSSKey(tc.hash)
      const pemPrivateKey = await exportPEMPrivateKey(keyPair.privateKey)
      const pemPublicKey = await exportPEMPublicKey(keyPair.publicKey)
      const jwkPublicKey = await exportJWK(keyPair.publicKey)

      const tok = await JWT.sign(payload, pemPrivateKey, alg)
      expect(await JWT.verify(tok, pemPublicKey, alg)).toEqual(payload)
      expect(await JWT.verify(tok, pemPrivateKey, alg)).toEqual(payload)
      expect(await JWT.verify(tok, jwkPublicKey, alg)).toEqual(payload)

      const keyPair2 = await generateRSAPSSKey(tc.hash)
      const unexpectedPemPublicKey = await exportPEMPublicKey(keyPair2.publicKey)

      let err = null
      let authorized
      try {
        authorized = await JWT.verify(tok, unexpectedPemPublicKey, alg)
      } catch (e) {
        err = e
      }
      expect(authorized).toBeUndefined()
      expect(err instanceof JwtTokenSignatureMismatched).toBe(true)
    })

    it(`${tc.alg} sign & verify w/ CryptoKey`, async () => {
      const alg = tc.alg
      const payload = { message: 'hello world' }
      const keyPair = await generateRSAPSSKey(tc.hash)

      const tok = await JWT.sign(payload, keyPair.privateKey, alg)
      expect(await JWT.verify(tok, keyPair.privateKey, alg)).toEqual(payload)
      expect(await JWT.verify(tok, keyPair.publicKey, alg)).toEqual(payload)
    })
  }

  const esTestCases = [
    {
      alg: AlgorithmTypes.ES256,
      namedCurve: 'P-256',
    },
    {
      alg: AlgorithmTypes.ES384,
      namedCurve: 'P-384',
    },
    {
      alg: AlgorithmTypes.ES512,
      namedCurve: 'P-521',
    },
  ]
  for (const tc of esTestCases) {
    it(`${tc.alg} sign & verify`, async () => {
      const alg = tc.alg
      const payload = { message: 'hello world' }
      const keyPair = await generateECDSAKey(tc.namedCurve)
      const pemPrivateKey = await exportPEMPrivateKey(keyPair.privateKey)
      const pemPublicKey = await exportPEMPublicKey(keyPair.publicKey)
      const jwkPublicKey = await exportJWK(keyPair.publicKey)

      const tok = await JWT.sign(payload, pemPrivateKey, alg)
      expect(await JWT.verify(tok, pemPublicKey, alg)).toEqual(payload)
      expect(await JWT.verify(tok, pemPrivateKey, alg)).toEqual(payload)
      expect(await JWT.verify(tok, jwkPublicKey, alg)).toEqual(payload)

      const keyPair2 = await generateECDSAKey(tc.namedCurve)
      const unexpectedPemPublicKey = await exportPEMPublicKey(keyPair2.publicKey)

      let err = null
      let authorized
      try {
        authorized = await JWT.verify(tok, unexpectedPemPublicKey, alg)
      } catch (e) {
        err = e
      }
      expect(authorized).toBeUndefined()
      expect(err instanceof JwtTokenSignatureMismatched).toBe(true)
    })

    it(`${tc.alg} sign & verify w/ CryptoKey`, async () => {
      const alg = tc.alg
      const payload = { message: 'hello world' }
      const keyPair = await generateECDSAKey(tc.namedCurve)

      const tok = await JWT.sign(payload, keyPair.privateKey, alg)
      expect(await JWT.verify(tok, keyPair.privateKey, alg)).toEqual(payload)
      expect(await JWT.verify(tok, keyPair.publicKey, alg)).toEqual(payload)
    })
  }

  it('EdDSA sign & verify', async () => {
    const alg = 'EdDSA'
    const payload = { message: 'hello world' }
    const keyPair = await generateEd25519Key()
    const pemPrivateKey = await exportPEMPrivateKey(keyPair.privateKey)
    const pemPublicKey = await exportPEMPublicKey(keyPair.publicKey)
    const jwkPublicKey = await exportJWK(keyPair.publicKey)

    const tok = await JWT.sign(payload, pemPrivateKey, alg)
    expect(await JWT.verify(tok, pemPublicKey, alg)).toEqual(payload)
    expect(await JWT.verify(tok, pemPrivateKey, alg)).toEqual(payload)
    expect(await JWT.verify(tok, jwkPublicKey, alg)).toEqual(payload)

    const keyPair2 = await generateEd25519Key()
    const unexpectedPemPublicKey = await exportPEMPublicKey(keyPair2.publicKey)

    let err = null
    let authorized
    try {
      authorized = await JWT.verify(tok, unexpectedPemPublicKey, alg)
    } catch (e) {
      err = e
    }
    expect(authorized).toBeUndefined()
    expect(err instanceof JwtTokenSignatureMismatched).toBe(true)
  })

  it('EdDSA sign & verify w/ CryptoKey', async () => {
    const alg = 'EdDSA'
    const payload = { message: 'hello world' }
    const keyPair = await generateEd25519Key()

    const tok = await JWT.sign(payload, keyPair.privateKey, alg)
    expect(await JWT.verify(tok, keyPair.privateKey, alg)).toEqual(payload)
    expect(await JWT.verify(tok, keyPair.publicKey, alg)).toEqual(payload)
  })
})

async function exportPEMPrivateKey(key: CryptoKey): Promise<string> {
  const exported = await crypto.subtle.exportKey('pkcs8', key)
  const pem = `-----BEGIN PRIVATE KEY-----\n${encodeBase64(exported)}\n-----END PRIVATE KEY-----`
  return pem
}

async function exportPEMPublicKey(key: CryptoKey): Promise<string> {
  const exported = await crypto.subtle.exportKey('spki', key)
  const pem = `-----BEGIN PUBLIC KEY-----\n${encodeBase64(exported)}\n-----END PUBLIC KEY-----`
  return pem
}

async function exportJWK(key: CryptoKey): Promise<JsonWebKey> {
  return await crypto.subtle.exportKey('jwk', key)
}

async function generateRSAKey(hash: string): Promise<CryptoKeyPair> {
  return await crypto.subtle.generateKey(
    {
      hash,
      modulusLength: 2048,
      publicExponent: new Uint8Array([1, 0, 1]),
      name: 'RSASSA-PKCS1-v1_5',
    },
    true,
    ['sign', 'verify']
  )
}

async function generateRSAPSSKey(hash: string): Promise<CryptoKeyPair> {
  return await crypto.subtle.generateKey(
    {
      hash,
      modulusLength: 2048,
      publicExponent: new Uint8Array([1, 0, 1]),
      name: 'RSA-PSS',
    },
    true,
    ['sign', 'verify']
  )
}

async function generateECDSAKey(namedCurve: string): Promise<CryptoKeyPair> {
  return await crypto.subtle.generateKey(
    {
      name: 'ECDSA',
      namedCurve,
    },
    true,
    ['sign', 'verify']
  )
}

async function generateEd25519Key(): Promise<CryptoKeyPair> {
  return await crypto.subtle.generateKey(
    {
      name: 'Ed25519',
      namedCurve: 'Ed25519',
    },
    true,
    ['sign', 'verify']
  )
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/utils/jwt/jwt.ts
```typescript
/**
 * @module
 * JSON Web Token (JWT)
 * https://datatracker.ietf.org/doc/html/rfc7519
 */

import { decodeBase64Url, encodeBase64Url } from '../../utils/encode'
import { AlgorithmTypes } from './jwa'
import type { SignatureAlgorithm } from './jwa'
import { signing, verifying } from './jws'
import type { HonoJsonWebKey, SignatureKey } from './jws'
import {
  JwtHeaderInvalid,
  JwtHeaderRequiresKid,
  JwtTokenExpired,
  JwtTokenInvalid,
  JwtTokenIssuedAt,
  JwtTokenNotBefore,
  JwtTokenSignatureMismatched,
} from './types'
import type { JWTPayload } from './types'
import { utf8Decoder, utf8Encoder } from './utf8'

const encodeJwtPart = (part: unknown): string =>
  encodeBase64Url(utf8Encoder.encode(JSON.stringify(part)).buffer).replace(/=/g, '')

const encodeSignaturePart = (buf: ArrayBufferLike): string => encodeBase64Url(buf).replace(/=/g, '')

const decodeJwtPart = (part: string): TokenHeader | JWTPayload | undefined =>
  JSON.parse(utf8Decoder.decode(decodeBase64Url(part)))

export interface TokenHeader {
  alg: SignatureAlgorithm
  typ?: 'JWT'
  kid?: string
}

export function isTokenHeader(obj: unknown): obj is TokenHeader {
  if (typeof obj === 'object' && obj !== null) {
    const objWithAlg = obj as { [key: string]: unknown }
    return (
      'alg' in objWithAlg &&
      Object.values(AlgorithmTypes).includes(objWithAlg.alg as AlgorithmTypes) &&
      (!('typ' in objWithAlg) || objWithAlg.typ === 'JWT')
    )
  }
  return false
}

export const sign = async (
  payload: JWTPayload,
  privateKey: SignatureKey,
  alg: SignatureAlgorithm = 'HS256'
): Promise<string> => {
  const encodedPayload = encodeJwtPart(payload)
  let encodedHeader
  if (typeof privateKey === 'object' && 'alg' in privateKey) {
    alg = privateKey.alg as SignatureAlgorithm
    encodedHeader = encodeJwtPart({ alg, typ: 'JWT', kid: privateKey.kid })
  } else {
    encodedHeader = encodeJwtPart({ alg, typ: 'JWT' })
  }

  const partialToken = `${encodedHeader}.${encodedPayload}`

  const signaturePart = await signing(privateKey, alg, utf8Encoder.encode(partialToken))
  const signature = encodeSignaturePart(signaturePart)

  return `${partialToken}.${signature}`
}

export const verify = async (
  token: string,
  publicKey: SignatureKey,
  alg: SignatureAlgorithm = 'HS256'
): Promise<JWTPayload> => {
  const tokenParts = token.split('.')
  if (tokenParts.length !== 3) {
    throw new JwtTokenInvalid(token)
  }

  const { header, payload } = decode(token)
  if (!isTokenHeader(header)) {
    throw new JwtHeaderInvalid(header)
  }
  const now = (Date.now() / 1000) | 0
  if (payload.nbf && payload.nbf > now) {
    throw new JwtTokenNotBefore(token)
  }
  if (payload.exp && payload.exp <= now) {
    throw new JwtTokenExpired(token)
  }
  if (payload.iat && now < payload.iat) {
    throw new JwtTokenIssuedAt(now, payload.iat)
  }

  const headerPayload = token.substring(0, token.lastIndexOf('.'))
  const verified = await verifying(
    publicKey,
    alg,
    decodeBase64Url(tokenParts[2]),
    utf8Encoder.encode(headerPayload)
  )
  if (!verified) {
    throw new JwtTokenSignatureMismatched(token)
  }

  return payload
}

export const verifyFromJwks = async (
  token: string,
  options: {
    keys?: HonoJsonWebKey[] | (() => Promise<HonoJsonWebKey[]>)
    jwks_uri?: string
  },
  init?: RequestInit
): Promise<JWTPayload> => {
  const header = decodeHeader(token)

  if (!isTokenHeader(header)) {
    throw new JwtHeaderInvalid(header)
  }
  if (!header.kid) {
    throw new JwtHeaderRequiresKid(header)
  }

  let keys = typeof options.keys === 'function' ? await options.keys() : options.keys

  if (options.jwks_uri) {
    const response = await fetch(options.jwks_uri, init)
    if (!response.ok) {
      throw new Error(`failed to fetch JWKS from ${options.jwks_uri}`)
    }
    const data = (await response.json()) as { keys?: JsonWebKey[] }
    if (!data.keys) {
      throw new Error('invalid JWKS response. "keys" field is missing')
    }
    if (!Array.isArray(data.keys)) {
      throw new Error('invalid JWKS response. "keys" field is not an array')
    }
    if (keys) {
      keys.push(...data.keys)
    } else {
      keys = data.keys
    }
  } else if (!keys) {
    throw new Error('verifyFromJwks requires options for either "keys" or "jwks_uri" or both')
  }

  const matchingKey = keys.find((key) => key.kid === header.kid)
  if (!matchingKey) {
    throw new JwtTokenInvalid(token)
  }

  return await verify(token, matchingKey, matchingKey.alg as SignatureAlgorithm)
}

export const decode = (token: string): { header: TokenHeader; payload: JWTPayload } => {
  try {
    const [h, p] = token.split('.')
    const header = decodeJwtPart(h) as TokenHeader
    const payload = decodeJwtPart(p) as JWTPayload
    return {
      header,
      payload,
    }
  } catch {
    throw new JwtTokenInvalid(token)
  }
}

export const decodeHeader = (token: string): TokenHeader => {
  try {
    const [h] = token.split('.')
    return decodeJwtPart(h) as TokenHeader
  } catch {
    throw new JwtTokenInvalid(token)
  }
}

```
/Users/josh/Documents/GitHub/honojs/hono/src/utils/jwt/types.ts
```typescript
/**
 * @module
 * Type definitions for JWT utilities.
 */

export class JwtAlgorithmNotImplemented extends Error {
  constructor(alg: string) {
    super(`${alg} is not an implemented algorithm`)
    this.name = 'JwtAlgorithmNotImplemented'
  }
}

export class JwtTokenInvalid extends Error {
  constructor(token: string) {
    super(`invalid JWT token: ${token}`)
    this.name = 'JwtTokenInvalid'
  }
}

export class JwtTokenNotBefore extends Error {
  constructor(token: string) {
    super(`token (${token}) is being used before it's valid`)
    this.name = 'JwtTokenNotBefore'
  }
}

export class JwtTokenExpired extends Error {
  constructor(token: string) {
    super(`token (${token}) expired`)
    this.name = 'JwtTokenExpired'
  }
}

export class JwtTokenIssuedAt extends Error {
  constructor(currentTimestamp: number, iat: number) {
    super(`Incorrect "iat" claim must be a older than "${currentTimestamp}" (iat: "${iat}")`)
    this.name = 'JwtTokenIssuedAt'
  }
}

export class JwtHeaderInvalid extends Error {
  constructor(header: object) {
    super(`jwt header is invalid: ${JSON.stringify(header)}`)
    this.name = 'JwtHeaderInvalid'
  }
}

export class JwtHeaderRequiresKid extends Error {
  constructor(header: object) {
    super(`required "kid" in jwt header: ${JSON.stringify(header)}`)
    this.name = 'JwtHeaderRequiresKid'
  }
}

export class JwtTokenSignatureMismatched extends Error {
  constructor(token: string) {
    super(`token(${token}) signature mismatched`)
    this.name = 'JwtTokenSignatureMismatched'
  }
}

export enum CryptoKeyUsage {
  Encrypt = 'encrypt',
  Decrypt = 'decrypt',
  Sign = 'sign',
  Verify = 'verify',
  DeriveKey = 'deriveKey',
  DeriveBits = 'deriveBits',
  WrapKey = 'wrapKey',
  UnwrapKey = 'unwrapKey',
}

/**
 * JWT Payload
 */
export type JWTPayload = {
  [key: string]: unknown
  /**
   * The token is checked to ensure it has not expired.
   */
  exp?: number
  /**
   * The token is checked to ensure it is not being used before a specified time.
   */
  nbf?: number
  /**
   * The token is checked to ensure it is not issued in the future.
   */
  iat?: number
}

export type { HonoJsonWebKey } from './jws'

```
/Users/josh/Documents/GitHub/honojs/hono/src/utils/jwt/utf8.ts
```typescript
/**
 * @module
 * Functions for encoding/decoding UTF8.
 */

export const utf8Encoder: TextEncoder = new TextEncoder()
export const utf8Decoder: TextDecoder = new TextDecoder()

```
