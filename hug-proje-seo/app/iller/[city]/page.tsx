// HUG PROJE - app/iller/[city]/page.tsx - Il Sayfasi
// Bu dosya veri URETMEZ. Sadece data/cities.ts'teki gercek ili gosterir.
// - Metadata: lib/seo.ts -> buildCityMeta() ile ayrica tanimlanir.
//   Template '%s' oldugu icin title'daki ' | HUG PROJE' tek kalir, cift marka olmaz.
// - Proje etiketi: 'Proje Geliştirme' - tum il sayfalarinda ayni, uydurma degil.
// - Slug: cities.ts'teki slug ile birebir, elle slug yok.
// - Olmayan il -> notFound(), uydurma sayfa yok.
// - Ilce listesi: cities.ts'teki districts'ten, elle ilce yok.
// - Sahte puan, yorum, kullanici sayisi, istatistik YOKTUR.
// - JSON-LD: Bu sayfada basilir: <script type="application/ld+json"> + jsonLdToSafeString()
// - Tasarim: globals.css'teki hug-* siniflariyla birebir eslesir.

import type { Metadata } from 'next'
import { notFound } from 'next/navigation'
import { buildCityMeta, jsonLdToSafeString } from '../../../lib/seo'
import { DOWNLOAD_MESSAGES, getHugProjeUrl, getPlayUrl } from '../../../lib/constants'
import { cities, getCityBySlug, getCitySeoIntro } from '../../../data/cities'

const PROJE_ETIKETI = 'Proje Geliştirme'

type Props = { params: Promise<{ city: string }> }

export function generateStaticParams() {
  return cities.map((c) => ({ city: c.slug }))
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { city } = await params
  const meta = buildCityMeta(city, PROJE_ETIKETI)
  if (!meta) return {}
  return {
    title: meta.title,
    description: meta.description,
    alternates: { canonical: meta.canonical },
    robots: meta.robots,
    openGraph: {
      title: meta.ogTitle,
      description: meta.ogDescription,
      url: meta.ogUrl,
      type: 'website',
      locale: 'tr_TR',
      siteName: 'HUG PROJE',
    },
  }
}

export default async function IlSayfasi({ params }: Props) {
  const { city: citySlug } = await params
  const city = getCityBySlug(citySlug)
  if (!city) notFound()
  const meta = buildCityMeta(citySlug, PROJE_ETIKETI)
  if (!meta) notFound()
  const indirUrl = getPlayUrl({ source: 'hug-proje', medium: 'seo', campaign: 'hug-proje-indir', content: `il-${city.slug}` })
  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: jsonLdToSafeString(meta.jsonLd) }}
      />

      <section className="hug-hero">
        <p className="hug-hero-eyebrow">81 İL • {city.name.toUpperCase()}</p>
        <h1 className="hug-section-title">{city.name} {PROJE_ETIKETI}</h1>
        <div className="hug-hero-gold-line" aria-hidden="true" />
        <p className="hug-hero-desc">{getCitySeoIntro(city.slug, PROJE_ETIKETI)}</p>
        <p className="hug-hero-desc">{DOWNLOAD_MESSAGES.sahip}</p>
        <div className="hug-hero-cta">
          <a href={indirUrl} className="hug-btn-gold">Hemen Ustam Gelsin&apos;i İndir</a>
        </div>
      </section>
      <section className="hug-section">
        <div className="hug-section-head">
          <div>
            <p className="hug-section-kicker">İLÇELER</p>
            <h2 className="hug-section-title">{city.name} İlçeleri</h2>
          </div>
        </div>
        <ul className="hug-pill-list">
          {city.districts.map((d) => (
            <li key={d.slug}>
              <a href={getHugProjeUrl(`/iller/${city.slug}/ilceler/${d.slug}`)}>{d.name}</a>
            </li>
          ))}
        </ul>
      </section>
    </>
  )
}