// HUG PROJE - app/iller/[city]/ilceler/[district]/page.tsx - Ilce Sayfasi
// Bu dosya veri URETMEZ. Sadece data/cities.ts'teki gercek il + ilceyi gosterir.
// - URL: /hug-proje/iller/[city]/ilceler/[district] - kararlaştırılmış hiyerarşi ile birebir.
// - Metadata: lib/seo.ts -> buildDistrictMeta() ile ayrica tanimlanir.
//   Template '%s' oldugu icin title'daki ' | HUG PROJE' tek kalir, cift marka olmaz.
// - Olmayan il / ilce -> notFound(), uydurma sayfa yok.
// - Sahte puan, yorum, kullanici sayisi, istatistik, proje sayisi YOKTUR.
// - Ince icerik karari (ONEMLI): Onceki revizede 973 ilcenin hepsine ayni
//   44 baglanti (14 profesyonel + 11 proje turu + 19 ihtiyac) basilmisti.
//   Bu GERI ALINDI. Neden: Hepsi ayni olunca sayfalar birbirinden
//   farklilasmiyor, olcekli kopya icerik riski olusuyor.
//   Elimizde ilceye ozel iliski YOK, uydurmak yasak.
//   Yerine sadece DOGURULANABILIR iliski konuldu:
//   Ayni ildeki diger ilceler (cities.ts'ten, gercek).
//   Or: Bodrum -> Mugla'nin diger 12 ilcesi, Cesme -> Izmir'in diger 29 ilcesi.
//   Boylece sayfalar 81 il grubuna bolunur, hepsi ayni olmaz.
// - JSON-LD: Bu sayfada basilir: <script type="application/ld+json"> + jsonLdToSafeString()
// - Tasarim: globals.css'teki hug-* siniflariyla birebir eslesir.
// - Turkce buyuk harf: toUpperCase() YOK, toLocaleUpperCase('tr-TR') VAR.

import type { Metadata } from 'next'
import { notFound } from 'next/navigation'
import { buildDistrictMeta, jsonLdToSafeString } from '../../../../../lib/seo'
import { DOWNLOAD_MESSAGES, getHugProjeUrl, getPlayUrl } from '../../../../../lib/constants'
import { cities, getCityBySlug, getDistrictBySlug } from '../../../../../data/cities'

const PROJE_ETIKETI = 'Proje Geliştirme'

type Props = { params: Promise<{ city: string; district: string }> }

export function generateStaticParams() {
  return cities.flatMap((c) => c.districts.map((d) => ({ city: c.slug, district: d.slug })))
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { city, district } = await params
  const meta = buildDistrictMeta(city, district, PROJE_ETIKETI)
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

export default async function IlceSayfasi({ params }: Props) {
  const { city: citySlug, district: districtSlug } = await params
  const city = getCityBySlug(citySlug)
  const district = getDistrictBySlug(citySlug, districtSlug)
  if (!city || !district) notFound()
  const meta = buildDistrictMeta(citySlug, districtSlug, PROJE_ETIKETI)
  if (!meta) notFound()
  const indirUrl = getPlayUrl({ source: 'hug-proje', medium: 'seo', campaign: 'hug-proje-indir', content: `ilce-${city.slug}-${district.slug}` })
  const digerIlceler = city.districts.filter((d) => d.slug !== district.slug)
  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: jsonLdToSafeString(meta.jsonLd) }}
      />

      <section className="hug-hero">
        <p className="hug-hero-eyebrow">{city.name.toLocaleUpperCase('tr-TR')} • {district.name.toLocaleUpperCase('tr-TR')}</p>
        <h1 className="hug-section-title">{city.name} {district.name} {PROJE_ETIKETI}</h1>
        <div className="hug-hero-gold-line" aria-hidden="true" />
        <p className="hug-hero-desc">{city.name} {district.name} için {PROJE_ETIKETI} projenizde doğru profesyonellerle eşleşin.</p>
        <p className="hug-hero-desc">{DOWNLOAD_MESSAGES.sahip}</p>
        <div className="hug-hero-cta">
          <a href={indirUrl} className="hug-btn-gold">Hemen Ustam Gelsin&apos;i İndir</a>
        </div>
      </section>

      <section className="hug-section">
        <div className="hug-section-head">
          <div>
            <p className="hug-section-kicker">{city.name.toLocaleUpperCase('tr-TR')}</p>
            <h2 className="hug-section-title">{city.name} Diğer İlçeler</h2>
            <p className="hug-section-desc">{city.name} ilindeki diğer ilçelerde de {PROJE_ETIKETI} projeniz için doğru profesyonellerle eşleşin.</p>
          </div>
        </div>
        <ul className="hug-pill-list">
          {digerIlceler.map((d) => (
            <li key={d.slug}>
              <a href={getHugProjeUrl(`/iller/${city.slug}/ilceler/${d.slug}`)}>{d.name}</a>
            </li>
          ))}
        </ul>
      </section>
    </>
  )
}