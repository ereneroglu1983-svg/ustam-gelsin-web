// HUG PROJE - app/layout.tsx - Ortak Layout
// Bu dosya veri URETMEZ. Sadece tum HUG PROJE sayfalarinin ortak cercevesi.
// GERCEK DURUM (2026-11-06 revize, uydurma yok):
// - app/ icinde layout.tsx + page.tsx + profesyonel/[slug] + proje-turu/[slug] +
//   ihtiyac/[slug] + iller/[city] + iller/[city]/ilceler/[district] var.
// - lib/seo.ts'teki gercek mimari: /profesyonel/[slug], /proje-turu/[slug], /ihtiyac/[slug],
//   /iller/[city], /iller/[city]/ilceler/[district]. Liste route'u (/profesyonel, /proje-turu, /ihtiyac) mimaride YOK.
//   O yuzden header, olmayan liste sayfalarina link VERMEZ. Header, ana sayfadaki
//   bolumlere giden anchor'lara baglidir (#profesyoneller vb) - 404 uretmez.
// - Footer 81 il linki: data/cities.ts'ten uretilir, elle yazilmaz. Hedef /iller/[city] mimarisi
//   lib/seo.ts buildCityMeta ile aynidir.
// - public/logo.png VAR - kullanici yukledi, HUG PROJE logosu (siyah zeminli).
//   Header'da <img src="/hug-proje/logo.png"> olarak basilir, siyah header'da kutu gibi durmaz.
// - app/globals.css VAR. Tasarim (siyah + altin) burada baglanir: import './globals.css'
// - Fontlar: Fraunces + Manrope, subsets ['latin', 'latin-ext'] - Turkce karakterler
//   (g, u, s, i, I, o, c) dogru font dosyasindan gelir, yedeklere dusmez.
// - Sahte yorum, puan, kullanici sayisi, istatistik YOKTUR.

import type { Metadata } from 'next'
import type { ReactNode } from 'react'
import { Fraunces, Manrope } from 'next/font/google'
import './globals.css'
import { DOWNLOAD_MESSAGES, getHugProjeUrl, getPlayUrl, HUG_PROJE_BASE, SITE_URL } from '../lib/constants'
import { cities } from '../data/cities'

const fraunces = Fraunces({
  subsets: ['latin', 'latin-ext'],
  variable: '--font-hug-display',
  display: 'swap',
})

const manrope = Manrope({
  subsets: ['latin', 'latin-ext'],
  variable: '--font-hug-body',
  display: 'swap',
})

// --- Metadata: GERCEK DAVRANIS + CIFIT MARKA ONLEME ---
// Layout, default title + description da veriyor. Alt sayfa kendi title/description
// tanimlamazsa bu degerler MIRAS KALIR. Bu Next.js'in beklenen davranisi.
// O yuzden her alt sayfa kendi generateMetadata'sini tanimlamak ZORUNDA.
// Template: '%s' - BILINCLI olarak marka eklemez. Cunku lib/seo.ts'teki title'lar
// zaten ' | HUG PROJE' ile bitiyor (or: 'Mimar | HUG PROJE'). Template '%s | HUG PROJE'
// olsaydi alt sayfada 'Mimar | HUG PROJE | HUG PROJE' olurdu. Cift marka bu yuzden
// template'de degil, seo.ts'te tek kaynaktan onlenir. Ana sayfa metadata'si da
// app/page.tsx'te buildHomeMeta() ile ayrica tanimlanacak.
export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: {
    default: 'HUG PROJE | Projen İçin Doğru Profesyonelleri Bul',
    template: '%s',
  },
  description: 'Mimari proje, statik, elektrik, mekanik, zemin etüdü ve anahtar teslim yapım için doğru profesyonellerle eşleş.',
  robots: 'index, follow, max-image-preview:large',
  openGraph: {
    type: 'website',
    locale: 'tr_TR',
    siteName: 'HUG PROJE',
  },
}

// 1) Anchor duzeltmesi: getHugProjeUrl('/#profesyoneller') YAPILMAZ.
// getHugProjeUrl, query ve hash'i temizler, hash kaybolur, ana sayfa acilir.
// Anchor, fonksiyonun DISINDA eklenir ve HUG_PROJE_BASE korunur:
// `${HUG_PROJE_BASE}/#profesyoneller` => '/hug-proje/#profesyoneller'
function anchorUrl(hash: string): string {
  return `${HUG_PROJE_BASE}/#${hash}`
}

export default function HugProjeLayout({ children }: { children: ReactNode }) {
  // UTM content AYRI: header ve footer karismasin
  const headerIndirUrl = getPlayUrl({ source: 'hug-proje', medium: 'seo', campaign: 'hug-proje-indir', content: 'layout-header' })
  const footerIndirUrl = getPlayUrl({ source: 'hug-proje', medium: 'seo', campaign: 'hug-proje-indir', content: 'layout-footer' })

  // Footer 81 il - cities.ts'ten, elle yazilmadi
  if (cities.length !== 81) throw new Error(`[layout.tsx] cities.ts 81 il olmali, gelen: ${cities.length}`)

  return (
    <html lang="tr" className={`${fraunces.variable} ${manrope.variable}`}>
      <body>
        {/* Klavye erisilebilirligi: ana icerige atlama */}
        <a href="#hug-proje-icerik">Ana içeriğe atla</a>
        <header className="hug-header">
          <div className="hug-header-inner">
            <a href={getHugProjeUrl('/')} className="hug-logo">
              <img src={`${HUG_PROJE_BASE}/logo.png`} alt="HUG PROJE" width={44} height={44} />
              HUG PROJE
            </a>
            {/* Masaustu navigasyonu: dogrudan gorunur, tiklama gerektirmez */}
            <nav aria-label="HUG PROJE ana navigasyon" className="hug-desktop-nav hug-nav">
              <ul>
                <li>
                  <a href={anchorUrl('profesyoneller')}>Profesyoneller</a>
                </li>
                <li>
                  <a href={anchorUrl('proje-turleri')}>Proje Türleri</a>
                </li>
                <li>
                  <a href={anchorUrl('ihtiyaclar')}>İhtiyaçlar</a>
                </li>
                <li>
                  <a href={anchorUrl('iller')}>81 İl</a>
                </li>
              </ul>
            </nav>
            {/* Mobil navigasyon: <details> JS gerektirmez, mobilde acilir kapanir */}
            <details className="hug-mobile-nav">
              <summary>Menü</summary>
              <nav aria-label="HUG PROJE mobil navigasyon" className="hug-nav">
                <ul>
                  <li>
                    <a href={anchorUrl('profesyoneller')}>Profesyoneller</a>
                  </li>
                  <li>
                    <a href={anchorUrl('proje-turleri')}>Proje Türleri</a>
                  </li>
                  <li>
                    <a href={anchorUrl('ihtiyaclar')}>İhtiyaçlar</a>
                  </li>
                  <li>
                    <a href={anchorUrl('iller')}>81 İl</a>
                  </li>
                </ul>
              </nav>
            </details>
            <a href={headerIndirUrl} className="hug-btn-gold">Uygulamayı İndir</a>
          </div>
        </header>
        {/* Atlama hedefi */}
        <main id="hug-proje-icerik" tabIndex={-1}>
          {children}
        </main>
        <footer className="hug-footer">
          <div className="hug-footer-inner">
            <p>HUG PROJE — 81 ilde proje geliştirme ve profesyonel eşleştirme.</p>
            <p>{DOWNLOAD_MESSAGES.sahip}</p>
            <a href={footerIndirUrl} className="hug-btn-gold">Hemen Ustam Gelsin&apos;i İndir</a>
            {/* 81 il baglantisi - cities.ts'ten, her biri lib/seo.ts buildCityMeta ile ayni hedef */}
            <nav aria-label="İller">
              <p>İller</p>
              <ul className="hug-pill-list">
                {cities.map((city) => (
                  <li key={city.slug}>
                    <a href={getHugProjeUrl(`/iller/${city.slug}`)}>{city.name}</a>
                  </li>
                ))}
              </ul>
            </nav>
          </div>
        </footer>
      </body>
    </html>
  )
}