// HUG PROJE - app/profesyonel/[slug]/page.tsx - Profesyonel Detay Sayfasi
// Bu dosya veri URETMEZ. Sadece data/profesyoneller.ts'teki gercek kaydi gosterir.
// - Metadata: lib/seo.ts -> buildProfesyonelMeta() ile ayrica tanimlanir.
//   Template '%s' oldugu icin title'daki ' | HUG PROJE' tek kalir, cift marka olmaz.
// - Slug: profesyonelSeoSayfalari'ndaki seoSlug ile birebir, elle slug yok.
// - Olmayan slug -> notFound(), uydurma sayfa yok.
// - ID SUNUMU: uzmanlikIds / hizmetIds / onerilenYapiTuruIds HAM ID olarak GORUNTULENMEZ.
//   Or: <li>MIMARI_PROJE</li> YOK. Canonical ID'ler degistirilmez, ama kullaniciya
//   ham kod gosterilmez. Gosterilen ad SADECE mevcut veri kaynagindaki gercek
//   kullaniciya donuk addir: ihtiyaclar.ts'teki pageName.
//   Eslesme yoksa UYDURMA etiket olusturulmaz, o ID gorunur listeye ALINMAZ.
//   YapiTuru icin mevcut kaynaklarda Turkce ad karsiligi YOK (MASTER_YAPI_TURU_IDS
//   sadece ID seti), o yuzden yapi turu listesi gorunur metin olarak basilmez.
// - Sahte puan, yorum, kullanici sayisi, istatistik YOKTUR.
// - JSON-LD: Bu sayfada basilir: <script type="application/ld+json"> + jsonLdToSafeString()
// - Tasarim: globals.css'teki hug-* siniflariyla birebir eslesir.

import type { Metadata } from 'next'
import { notFound } from 'next/navigation'
import { buildProfesyonelMeta, jsonLdToSafeString } from '../../../lib/seo'
import { DOWNLOAD_MESSAGES, getHugProjeUrl, getPlayUrl } from '../../../lib/constants'
import { profesyonelSeoSayfalari } from '../../../data/profesyoneller'
import { ihtiyaclar } from '../../../data/ihtiyaclar'

type Props = { params: Promise<{ slug: string }> }

export function generateStaticParams() {
  return profesyonelSeoSayfalari.map((pr) => ({ slug: pr.seoSlug }))
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params
  const meta = buildProfesyonelMeta(slug)
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

export default async function ProfesyonelDetay({ params }: Props) {
  const { slug } = await params
  const kayit = profesyonelSeoSayfalari.find((pr) => pr.seoSlug === slug)
  if (!kayit) notFound()
  const meta = buildProfesyonelMeta(slug)
  if (!meta) notFound()
  const indirUrl = getPlayUrl({ source: 'hug-proje', medium: 'seo', campaign: 'hug-proje-indir', content: `profesyonel-${kayit.seoSlug}` })

  // Sadece ihtiyaclar.ts'te gercek pageName karsiligi olan ID'ler gosterilir.
  // Or: hizmetIds icindeki STATIK_PROJE -> ihtiyaclar.ts'te 'Statik Proje'.
  // Karsiligi olmayan ID (or: KONSEPT_TASARIM, KONUT_VILLA) icin uydurma etiket YOK, listeye alinmaz.
  // Canonical ID'ler data'da aynen durur, sadece gorunumde basilmez.
  const ilgiliIhtiyaclar = Array.from(new Set([...kayit.uzmanlikIds, ...kayit.hizmetIds]))
    .map((id) => ihtiyaclar.find((i) => i.id === id))
    .filter((i): i is NonNullable<typeof i> => !!i)

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: jsonLdToSafeString(meta.jsonLd) }}
      />

      <section className="hug-hero">
        <p className="hug-hero-eyebrow">PROFESYONELLER</p>
        <h1 className="hug-section-title">{kayit.pageName}</h1>
        <div className="hug-hero-gold-line" aria-hidden="true" />
        <p className="hug-hero-desc">{kayit.description}</p>
        <p className="hug-hero-desc">{DOWNLOAD_MESSAGES.profesyonel}</p>
        <div className="hug-hero-cta">
          <a href={indirUrl} className="hug-btn-gold">Hemen Ustam Gelsin&apos;e Katıl</a>
        </div>
      </section>
      {ilgiliIhtiyaclar.length > 0 ? (
        <section className="hug-section">
          <div className="hug-section-head">
            <div>
              <p className="hug-section-kicker">İLGİLİ İHTİYAÇLAR</p>
              <h2 className="hug-section-title">İlgili İhtiyaçlar</h2>
            </div>
          </div>
          <ul className="hug-grid">
            {ilgiliIhtiyaclar.map((i) => (
              <li key={i.id} className="hug-card">
                <h3>{i.pageName}</h3>
                <p>{i.description}</p>
                <a href={getHugProjeUrl(`/ihtiyac/${i.seoSlug}`)}>İncele →</a>
              </li>
            ))}
          </ul>
        </section>
      ) : null}
    </>
  )
}