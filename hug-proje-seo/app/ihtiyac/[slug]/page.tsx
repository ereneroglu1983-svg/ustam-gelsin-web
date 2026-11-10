// HUG PROJE - app/ihtiyac/[slug]/page.tsx - Ihtiyac Detay Sayfasi
// Bu dosya veri URETMEZ. Sadece data/ihtiyaclar.ts'teki gercek kaydi gosterir.
// - Metadata: lib/seo.ts -> buildIhtiyacMeta() ile ayrica tanimlanir.
//   Template '%s' oldugu icin title'daki ' | HUG PROJE' tek kalir, cift marka olmaz.
// - Slug: ihtiyaclar'daki seoSlug ile birebir, elle slug yok.
// - Olmayan slug -> notFound(), uydurma sayfa yok.
// - ID SUNUMU: baglanti icindeki anaDalId / altDalId / unvanId / uzmanlikIds / hizmetIds
//   HAM ID olarak GORUNTULENMEZ. Canonical ID'ler degistirilmez, sadece gorunumde basilmez.
//   Gosterilen ad SADECE profesyoneller.ts'teki gercek pageName'dir.
//   unvanId -> profesyonel seoSlug eslesmesi yoksa UYDURMA etiket yok, listeye alinmaz.
// - Sahte puan, yorum, kullanici sayisi, istatistik YOKTUR.
// - JSON-LD: Bu sayfada basilir: <script type="application/ld+json"> + jsonLdToSafeString()
// - Tasarim: globals.css'teki hug-* siniflariyla birebir eslesir.

import type { Metadata } from 'next'
import { notFound } from 'next/navigation'
import { buildIhtiyacMeta, jsonLdToSafeString } from '../../../lib/seo'
import { DOWNLOAD_MESSAGES, getHugProjeUrl, getPlayUrl } from '../../../lib/constants'
import { ihtiyaclar } from '../../../data/ihtiyaclar'
import { profesyonelSeoSayfalari } from '../../../data/profesyoneller'

type Props = { params: Promise<{ slug: string }> }

export function generateStaticParams() {
  return ihtiyaclar.map((i) => ({ slug: i.seoSlug }))
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params
  const meta = buildIhtiyacMeta(slug)
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

export default async function IhtiyacDetay({ params }: Props) {
  const { slug } = await params
  const kayit = ihtiyaclar.find((i) => i.seoSlug === slug)
  if (!kayit) notFound()
  const meta = buildIhtiyacMeta(slug)
  if (!meta) notFound()
  const indirUrl = getPlayUrl({ source: 'hug-proje', medium: 'seo', campaign: 'hug-proje-indir', content: `ihtiyac-${kayit.seoSlug}` })

  // Sadece profesyoneller.ts'te gercek pageName karsiligi olan unvanlar gosterilir.
  // Tekrarli unvanlar teklenir, sira baglanti sirasi korunur.
  const ilgiliProfesyoneller = kayit.baglanti
    .map((b) => profesyonelSeoSayfalari.find((pr) => pr.unvanId === b.unvanId))
    .filter((pr): pr is NonNullable<typeof pr> => !!pr)
    .filter((pr, idx, arr) => arr.findIndex((x) => x.unvanId === pr.unvanId) === idx)

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: jsonLdToSafeString(meta.jsonLd) }}
      />

      <section className="hug-hero">
        <p className="hug-hero-eyebrow">İHTİYAÇLAR</p>
        <h1 className="hug-section-title">{kayit.pageName}</h1>
        <div className="hug-hero-gold-line" aria-hidden="true" />
        <p className="hug-hero-desc">{kayit.description}</p>
        <p className="hug-hero-desc">{DOWNLOAD_MESSAGES.sahip}</p>
        <div className="hug-hero-cta">
          <a href={indirUrl} className="hug-btn-gold">Hemen Ustam Gelsin&apos;i İndir</a>
        </div>
      </section>
      {ilgiliProfesyoneller.length > 0 ? (
        <section className="hug-section">
          <div className="hug-section-head">
            <div>
              <p className="hug-section-kicker">İLGİLİ PROFESYONELLER</p>
              <h2 className="hug-section-title">İlgili Profesyoneller</h2>
            </div>
          </div>
          <ul className="hug-grid">
            {ilgiliProfesyoneller.map((pr) => (
              <li key={pr.unvanId} className="hug-card">
                <h3>{pr.pageName}</h3>
                <p>{pr.description}</p>
                <a href={getHugProjeUrl(`/profesyonel/${pr.seoSlug}`)}>İncele →</a>
              </li>
            ))}
          </ul>
        </section>
      ) : null}
    </>
  )
}