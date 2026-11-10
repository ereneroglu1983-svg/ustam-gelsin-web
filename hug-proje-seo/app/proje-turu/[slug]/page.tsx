// HUG PROJE - app/proje-turu/[slug]/page.tsx - Proje Turu Detay Sayfasi
// Bu dosya veri URETMEZ. Sadece data/proje-turleri.ts'teki gercek kaydi gosterir.
// - Metadata: lib/seo.ts -> buildProjeTuruMeta() ile ayrica tanimlanir.
//   Template '%s' oldugu icin title'daki ' | HUG PROJE' tek kalir, cift marka olmaz.
// - Slug: projeTurleri'ndeki seoSlug ile birebir, elle slug yok.
// - Olmayan slug -> notFound(), uydurma sayfa yok.
// - ID SUNUMU: yapiTuruIds / ihtiyacIds / asamalar HAM ID olarak GORUNTULENMEZ.
//   Canonical ID'ler degistirilmez, sadece gorunumde basilmez.
//   Gosterilen ad SADECE ihtiyaclar.ts'teki gercek pageName'dir.
//   Eslesme yoksa UYDURMA etiket olusturulmaz, o ID gorunur listeye ALINMAZ.
//   YapiTuru ve Asama icin mevcut kaynaklarda Turkce ad karsiligi listesi YOK,
//   o yuzden onlar gorunur metin olarak basilmez.
// - Sahte puan, yorum, kullanici sayisi, istatistik YOKTUR.
// - JSON-LD: Bu sayfada basilir: <script type="application/ld+json"> + jsonLdToSafeString()
// - Tasarim: globals.css'teki hug-* siniflariyla birebir eslesir.

import type { Metadata } from 'next'
import { notFound } from 'next/navigation'
import { buildProjeTuruMeta, jsonLdToSafeString } from '../../../lib/seo'
import { DOWNLOAD_MESSAGES, getHugProjeUrl, getPlayUrl } from '../../../lib/constants'
import { projeTurleri } from '../../../data/proje-turleri'
import { ihtiyaclar } from '../../../data/ihtiyaclar'

type Props = { params: Promise<{ slug: string }> }

export function generateStaticParams() {
  return projeTurleri.map((t) => ({ slug: t.seoSlug }))
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params
  const meta = buildProjeTuruMeta(slug)
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

export default async function ProjeTuruDetay({ params }: Props) {
  const { slug } = await params
  const kayit = projeTurleri.find((t) => t.seoSlug === slug)
  if (!kayit) notFound()
  const meta = buildProjeTuruMeta(slug)
  if (!meta) notFound()
  const indirUrl = getPlayUrl({ source: 'hug-proje', medium: 'seo', campaign: 'hug-proje-indir', content: `proje-turu-${kayit.seoSlug}` })

  // Sadece ihtiyaclar.ts'te gercek pageName karsiligi olan ihtiyaclar gosterilir.
  // YapiTuru / Asama ID'leri icin Turkce ad kaynagi yok, uydurma etiket yok, basilmez.
  const ilgiliIhtiyaclar = kayit.ihtiyacIds
    .map((id) => ihtiyaclar.find((i) => i.id === id))
    .filter((i): i is NonNullable<typeof i> => !!i)

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: jsonLdToSafeString(meta.jsonLd) }}
      />

      <section className="hug-hero">
        <p className="hug-hero-eyebrow">PROJE TÜRLERİ</p>
        <h1 className="hug-section-title">{kayit.pageName}</h1>
        <div className="hug-hero-gold-line" aria-hidden="true" />
        <p className="hug-hero-desc">{kayit.description}</p>
        <p className="hug-hero-desc">{DOWNLOAD_MESSAGES.sahip}</p>
        <div className="hug-hero-cta">
          <a href={indirUrl} className="hug-btn-gold">Hemen Ustam Gelsin&apos;i İndir</a>
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