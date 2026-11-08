// HUG PROJE - SEO / GEO Metadata + Schema - SUNUM KATMANI
// Bu dosya veri URETMEZ. Sadece data/*.ts'teki gercek kayitlardan metadata + JSON-LD uretir.
// - Canonical: lib/constants.ts -> getHugProjeUrl() tek kaynaktan
// - Title / Description: data dosyasindaki title / description aynen, elle yazilmaz
// - JSON-LD: Sahte puan, sahte yorum, sahte fiyat, sahte proje sayisi YOKTUR.
//   Sadece gercek baglantilar: ProfessionalService / Service + BreadcrumbList
// - GEO: AI / arama motoru icin ayni title / description + yapisal veri, ayri uydurma metin yok.
// - JSON-LD: SeoMeta.jsonLd SADECE burada hazirlanir, sayfaya BASILMAZ. Sayfalar jsonLdToSafeString() ile
//   <script type="application/ld+json"> olarak basar. Breadcrumb'da 404 ureten ara liste sayfasi YOKTUR.
// - Logo: hug-proje-seo/public/logo.png - kullanici yukledi, HUG PROJE logosu (siyah zeminli). LOGO'YA DOKUNULMADI, onayli.
// - Organization: Tek kimlik @id ile. HUG PROJE org @id ile tanimlanir, parentOrganization = ana HUG org @id.
//   Service provider'lar tam nesne degil, { '@id': HUG_PROJE_ORG_ID } referansidir.

import { getHugProjeUrl, getPlayUrl, HUG_PROJE_BASE, SITE_URL } from './constants'
import { profesyonelSeoSayfalari } from '../data/profesyoneller'
import { projeTurleri } from '../data/proje-turleri'
import { ihtiyaclar } from '../data/ihtiyaclar'
import { getCityBySlug, getDistrictBySlug, getCityRegion } from '../data/cities'

export const HUG_ORG_ID = `${SITE_URL}/#organization`
export const HUG_PROJE_ORG_ID = `${SITE_URL}${HUG_PROJE_BASE}/#organization`
export const HUG_PROJE_WEBSITE_ID = `${SITE_URL}${HUG_PROJE_BASE}/#website`

export type SeoMeta = {
  title: string
  description: string
  canonical: string
  robots: string
  ogTitle: string
  ogDescription: string
  ogUrl: string
  ogType: 'website'
  jsonLd: Record<string, unknown>[]
}

function baseMeta(path: string, title: string, description: string, jsonLd: Record<string, unknown>[]): SeoMeta {
  const canonical = getHugProjeUrl(path)
  return {
    title,
    description,
    canonical,
    robots: 'index, follow, max-image-preview:large',
    ogTitle: title,
    ogDescription: description,
    ogUrl: canonical,
    ogType: 'website',
    jsonLd,
  }
}

function breadcrumbJsonLd(items: { name: string; path: string }[]): Record<string, unknown> {
  return {
    '@context': 'https://schema.org',
    '@type': 'BreadcrumbList',
    itemListElement: items.map((it, i) => ({
      '@type': 'ListItem',
      position: i + 1,
      name: it.name,
      item: getHugProjeUrl(it.path),
    })),
  }
}

function orgJsonLd(): Record<string, unknown> {
  return {
    '@context': 'https://schema.org',
    '@type': 'Organization',
    '@id': HUG_PROJE_ORG_ID,
    name: 'HUG PROJE',
    url: getHugProjeUrl('/'),
    // Logo: kullanici yukledi, HUG PROJE logosu - hug-proje-seo/public/logo.png
    // Siyah zeminli logo, site zemini de siyah - arka plan buna gore.
    logo: `${SITE_URL}${HUG_PROJE_BASE}/logo.png`,
    parentOrganization: { '@type': 'Organization', '@id': HUG_ORG_ID, name: 'HUG', url: SITE_URL },
  }
}

function webSiteJsonLd(): Record<string, unknown> {
  return {
    '@context': 'https://schema.org',
    '@type': 'WebSite',
    '@id': HUG_PROJE_WEBSITE_ID,
    name: 'HUG PROJE',
    url: getHugProjeUrl('/'),
    publisher: { '@id': HUG_PROJE_ORG_ID },
  }
}

// --- Ana Sayfa ---
export function buildHomeMeta(): SeoMeta {
  const title = 'HUG PROJE | Projen İçin Doğru Profesyonelleri Bul'
  const description = 'Mimari proje, statik, elektrik, mekanik, zemin etüdü ve anahtar teslim yapım için doğru profesyonellerle eşleş. 81 ilde proje geliştirme ve profesyonel eşleştirme.'
  return baseMeta('/', title, description, [orgJsonLd(), webSiteJsonLd()])
}

// --- Profesyonel Sayfasi: /hug-proje/profesyonel/[slug] ---
export function buildProfesyonelMeta(seoSlug: string): SeoMeta | null {
  const kayit = profesyonelSeoSayfalari.find((p) => p.seoSlug === seoSlug)
  if (!kayit) return null
  const path = `/profesyonel/${kayit.seoSlug}`
  const serviceLd = {
    '@context': 'https://schema.org',
    '@type': 'ProfessionalService',
    name: kayit.pageName,
    description: kayit.description,
    url: getHugProjeUrl(path),
    areaServed: 'TR',
    provider: { '@id': HUG_PROJE_ORG_ID },
  }
  return baseMeta(path, kayit.title, kayit.description, [
    serviceLd,
    breadcrumbJsonLd([
      { name: 'HUG PROJE', path: '/' },
      { name: kayit.pageName, path },
    ]),
    orgJsonLd(),
  ])
}

// --- Proje Turu Sayfasi: /hug-proje/proje-turu/[slug] ---
export function buildProjeTuruMeta(seoSlug: string): SeoMeta | null {
  const kayit = projeTurleri.find((t) => t.seoSlug === seoSlug)
  if (!kayit) return null
  const path = `/proje-turu/${kayit.seoSlug}`
  const serviceLd = {
    '@context': 'https://schema.org',
    '@type': 'Service',
    name: kayit.pageName,
    description: kayit.description,
    url: getHugProjeUrl(path),
    areaServed: 'TR',
    provider: { '@id': HUG_PROJE_ORG_ID },
  }
  return baseMeta(path, kayit.title, kayit.description, [
    serviceLd,
    breadcrumbJsonLd([
      { name: 'HUG PROJE', path: '/' },
      { name: kayit.pageName, path },
    ]),
    orgJsonLd(),
  ])
}

// --- Ihtiyac Sayfasi: /hug-proje/ihtiyac/[slug] ---
export function buildIhtiyacMeta(seoSlug: string): SeoMeta | null {
  const kayit = ihtiyaclar.find((i) => i.seoSlug === seoSlug)
  if (!kayit) return null
  const path = `/ihtiyac/${kayit.seoSlug}`
  const serviceLd = {
    '@context': 'https://schema.org',
    '@type': 'Service',
    name: kayit.pageName,
    description: kayit.description,
    url: getHugProjeUrl(path),
    areaServed: 'TR',
    provider: { '@id': HUG_PROJE_ORG_ID },
  }
  return baseMeta(path, kayit.title, kayit.description, [
    serviceLd,
    breadcrumbJsonLd([
      { name: 'HUG PROJE', path: '/' },
      { name: kayit.pageName, path },
    ]),
    orgJsonLd(),
  ])
}

// --- Sehir Sayfasi: /hug-proje/iller/[city] ---
export function buildCityMeta(citySlug: string, projeLabel: string): SeoMeta | null {
  const city = getCityBySlug(citySlug)
  if (!city) return null
  const path = `/iller/${city.slug}`
  const title = `${city.name} ${projeLabel} | HUG PROJE`
  const description = `${city.name} ${getCityRegion(city.slug)} bölgesinde yer alır. ${city.districts.slice(0, 3).map((d) => d.name).join(', ')} başta olmak üzere ${city.districts.length} ilçede ${projeLabel} için proje geliştirme ve profesyonel eşleştirme imkanı sunar.`
  return baseMeta(path, title, description, [
    {
      '@context': 'https://schema.org',
      '@type': 'Service',
      name: `${city.name} ${projeLabel}`,
      description,
      url: getHugProjeUrl(path),
      areaServed: { '@type': 'City', name: city.name },
      provider: { '@id': HUG_PROJE_ORG_ID },
    },
    breadcrumbJsonLd([
      { name: 'HUG PROJE', path: '/' },
      { name: city.name, path },
    ]),
    orgJsonLd(),
  ])
}

// --- Ilce Sayfasi: /hug-proje/iller/[city]/ilceler/[district] ---
export function buildDistrictMeta(citySlug: string, districtSlug: string, projeLabel: string): SeoMeta | null {
  const city = getCityBySlug(citySlug)
  const district = getDistrictBySlug(citySlug, districtSlug)
  if (!city || !district) return null
  const path = `/iller/${city.slug}/ilceler/${district.slug}`
  const title = `${city.name} ${district.name} ${projeLabel} | HUG PROJE`
  const description = `${city.name} ${district.name} için ${projeLabel} projenizde doğru profesyonellerle eşleşin.`
  return baseMeta(path, title, description, [
    {
      '@context': 'https://schema.org',
      '@type': 'Service',
      name: `${city.name} ${district.name} ${projeLabel}`,
      description,
      url: getHugProjeUrl(path),
      areaServed: { '@type': 'AdministrativeArea', name: `${city.name} ${district.name}` },
      provider: { '@id': HUG_PROJE_ORG_ID },
    },
    breadcrumbJsonLd([
      { name: 'HUG PROJE', path: '/' },
      { name: city.name, path: `/iller/${city.slug}` },
      { name: district.name, path },
    ]),
    orgJsonLd(),
  ])
}

// --- JSON-LD Render Helper ---
// Next.js Metadata API jsonLd'i kendiliginden eklemez. O yuzden her sayfa
// kendi generateMetadata + render'inda meta.jsonLd'yi bu helper ile basar:
// <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdToSafeString(meta.jsonLd) }} />
// KRITIK: Kaynakta cift ters egik ('\\u003c') yazilir, yoksa JS bunu '<' yapar, escape olmaz.
// Cikti: '</script>' YOK, '\u003c/script\u003e' VAR. Test edildi.
export function jsonLdToSafeString(jsonLd: Record<string, unknown>[]): string {
  return JSON.stringify(jsonLd).replace(/</g, '\\u003c').replace(/>/g, '\\u003e').replace(/&/g, '\\u0026').replace(/\u2028/g, '\\u2028').replace(/\u2029/g, '\\u2029')
}

export function getDownloadCta(audience: 'sahip' | 'profesyonel' | 'genel', content: string): string {
  return getPlayUrl({ source: 'hug-proje', medium: 'seo', campaign: 'hug-proje-indir', content })
}

;(() => {
  // Tum SEO slug'lari tekil mi? Data dosyalari kendi icinde kontrol ediyor, burada capraz tekrar yok.
  const allSlugs = [
    ...profesyonelSeoSayfalari.map((p) => `profesyonel/${p.seoSlug}`),
    ...projeTurleri.map((t) => `proje-turu/${t.seoSlug}`),
    ...ihtiyaclar.map((i) => `ihtiyac/${i.seoSlug}`),
  ]
  if (new Set(allSlugs).size !== allSlugs.length) throw new Error('[seo.ts] SEO path tekrari var')
})()