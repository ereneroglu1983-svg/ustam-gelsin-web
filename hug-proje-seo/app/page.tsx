// HUG PROJE - app/page.tsx - Ana Sayfa
// Bu dosya veri URETMEZ. Sadece data/*.ts'teki gercek kayitlari listeler.
// - Metadata: lib/seo.ts -> buildHomeMeta() ile ayrica tanimlanir (layout'daki default'a birakilmaz).
//   Template '%s' oldugu icin buildHomeMeta title'indaki ' | HUG PROJE' tek kalir, cift marka olmaz.
// - Id'ler: layout'taki anchorUrl ile birebir ayni: #profesyoneller, #proje-turleri, #ihtiyaclar, #iller
// - Linkler: lib/seo.ts mimarisi ile ayni: /profesyonel/[slug], /proje-turu/[slug], /ihtiyac/[slug], /iller/[city]
// - Sahte puan, yorum, kullanici sayisi, istatistik YOKTUR.
// - JSON-LD: Bu sayfada basilir: <script type="application/ld+json"> + jsonLdToSafeString()
// - Tasarim: globals.css'teki hug-* siniflariyla birebir eslesir. Sinif yoksa tasarim uygulanmaz.

import type { Metadata } from 'next'
import { buildHomeMeta, jsonLdToSafeString } from '../lib/seo'
import { DOWNLOAD_MESSAGES, getHugProjeUrl, getPlayUrl } from '../lib/constants'
import { profesyonelSeoSayfalari } from '../data/profesyoneller'
import { projeTurleri } from '../data/proje-turleri'
import { ihtiyaclar } from '../data/ihtiyaclar'
import { cities } from '../data/cities'

export function generateMetadata(): Metadata {
  const home = buildHomeMeta()
  return {
    title: home.title,
    description: home.description,
    alternates: { canonical: home.canonical },
    robots: home.robots,
    openGraph: {
      title: home.ogTitle,
      description: home.ogDescription,
      url: home.ogUrl,
      type: 'website',
      locale: 'tr_TR',
      siteName: 'HUG PROJE',
    },
  }
}

export default function HugProjeHome() {
  const meta = buildHomeMeta()
  const indirSahip = getPlayUrl({ source: 'hug-proje', medium: 'seo', campaign: 'hug-proje-indir', content: 'home-sahip' })
  const indirProfesyonel = getPlayUrl({ source: 'hug-proje', medium: 'seo', campaign: 'hug-proje-indir', content: 'home-profesyonel' })
  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: jsonLdToSafeString(meta.jsonLd) }}
      />

      <section className="hug-hero">
        <p className="hug-hero-eyebrow">HEMEN USTAM GELSİN • PROJE GELİŞTİRME</p>
        <h1 className="hug-hero-title">HUG PROJE</h1>
        <div className="hug-hero-gold-line" aria-hidden="true" />
        <p className="hug-hero-sub">BÜYÜK PROJELER • YAPI • TEKNİK</p>
        <p className="hug-hero-desc">Türkiye genelinde arsa sahiplerini, yatırımcıları, bina ve site yönetimlerini; mimarlar, mühendisler, müteahhitler ve diğer proje profesyonelleriyle buluşturan proje geliştirme ve eşleştirme platformudur.</p>
        <p className="hug-hero-desc">{DOWNLOAD_MESSAGES.sahip}</p>
        <div className="hug-hero-cta">
          <a href={indirSahip} className="hug-btn-gold">Hemen Ustam Gelsin&apos;i İndir</a>
          <a href={indirProfesyonel} className="hug-btn-outline">Hemen Ustam Gelsin&apos;e Katıl</a>
        </div>
      </section>

      <section id="profesyoneller" className="hug-section">
        <div className="hug-section-head">
          <div>
            <p className="hug-section-kicker">PROFESYONELLER</p>
            <h2 className="hug-section-title">Projen İçin Doğru Profesyonelleri Bul</h2>
          </div>
        </div>
        <ul className="hug-grid">
          {profesyonelSeoSayfalari.map((pr) => (
            <li key={pr.seoSlug} className="hug-card">
              <h3>{pr.pageName}</h3>
              <p>{pr.description}</p>
              <a href={getHugProjeUrl(`/profesyonel/${pr.seoSlug}`)}>İncele →</a>
            </li>
          ))}
        </ul>
        <p className="hug-section-desc">{DOWNLOAD_MESSAGES.profesyonel}</p>
        <p>
          <a href={indirProfesyonel} className="hug-btn-outline">Hemen Ustam Gelsin&apos;e Katıl</a>
        </p>
      </section>

      <section id="proje-turleri" className="hug-section">
        <div className="hug-section-head">
          <div>
            <p className="hug-section-kicker">PROJE TÜRLERİ</p>
            <h2 className="hug-section-title">Proje Türleri</h2>
          </div>
        </div>
        <ul className="hug-grid">
          {projeTurleri.map((t) => (
            <li key={t.seoSlug} className="hug-card">
              <h3>{t.pageName}</h3>
              <p>{t.description}</p>
              <a href={getHugProjeUrl(`/proje-turu/${t.seoSlug}`)}>İncele →</a>
            </li>
          ))}
        </ul>
      </section>

      <section id="ihtiyaclar" className="hug-section">
        <div className="hug-section-head">
          <div>
            <p className="hug-section-kicker">İHTİYAÇLAR</p>
            <h2 className="hug-section-title">İhtiyaçlar</h2>
          </div>
        </div>
        <ul className="hug-grid">
          {ihtiyaclar.map((i) => (
            <li key={i.seoSlug} className="hug-card">
              <h3>{i.pageName}</h3>
              <p>{i.description}</p>
              <a href={getHugProjeUrl(`/ihtiyac/${i.seoSlug}`)}>İncele →</a>
            </li>
          ))}
        </ul>
      </section>

      <section id="iller" className="hug-section">
        <div className="hug-section-head">
          <div>
            <p className="hug-section-kicker">81 İL</p>
            <h2 className="hug-section-title">81 İl</h2>
          </div>
        </div>
        <ul className="hug-pill-list">
          {cities.map((c) => (
            <li key={c.slug}>
              <a href={getHugProjeUrl(`/iller/${c.slug}`)}>{c.name}</a>
            </li>
          ))}
        </ul>
      </section>
    </>
  )
}