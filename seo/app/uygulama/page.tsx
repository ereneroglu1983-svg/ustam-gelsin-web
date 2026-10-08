// app/uygulama/page.tsx - FINAL v14.5 - Play Verified
import type { Metadata } from 'next'
import Link from 'next/link'
import Image from 'next/image'

const PLAY_URL_CLEAN = "https://play.google.com/store/apps/details?id=com.hemenustamgelsin.android"
const PLAY_URL_PAGE = `${PLAY_URL_CLEAN}&pcampaignid=web_uygulama_page`

export const metadata: Metadata = {
  title: "Hemen Ustam Gelsin Android Uygulaması | Google Play'de İndir",
  description: "Hemen Ustam Gelsin Android uygulaması ile iş ilanı oluştur, ustalardan teklif al, ustanı seç. 81 ilde 100+ kategori.",
  alternates: { canonical: "https://hemenustamgelsin.com/uygulama/" },
  openGraph: {
    title: "HUG Android Uygulaması Yayında!",
    description: "Hemen Ustam Gelsin'i Google Play'den indir.",
    images: ["/uygulama-hug-yayinda.png"]
  }
}

export default function UygulamaPage() {
  const schema = {
    "@context": "https://schema.org",
    "@type": "SoftwareApplication",
    "name": "Hemen Ustam Gelsin",
    "alternateName": "HUG",
    "operatingSystem": "Android",
    "applicationCategory": "BusinessApplication",
    "offers": { "@type": "Offer", "price": "0", "priceCurrency": "TRY" },
    "aggregateRating": { "@type": "AggregateRating", "ratingValue": "5.0", "ratingCount": "1" },
    "downloadUrl": PLAY_URL_CLEAN,
    "installUrl": PLAY_URL_CLEAN,
    "publisher": {
      "@type": "Organization",
      "name": "Hemen Ustam Gelsin",
      "url": "https://hemenustamgelsin.com"
    }
  }

  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }} />
      <main className="mx-auto max-w-5xl px-4 py-8">
        {/* HERO - MINI 440px FIXED */}
        <div className="mx-auto max-w- overflow-hidden rounded-2xl border bg-white shadow-sm">
          <Image
            src="/uygulama-hug-yayinda.png"
            alt="Hemen Ustam Gelsin Yayında"
            width={880}
            height={1200}
            priority
            className="h-auto w-full"
          />
        </div>

        <div className="mt-6 text-center">
          <h1 className="text-2xl font-bold tracking-tight sm:text-3xl">
            Hemen Ustam Gelsin Android Uygulaması
          </h1>
          <p className="mx-auto mt-3 max-w-xl text-sm text-zinc-600 sm:text-base">
            İlan oluştur, teklifleri karşılaştır, sana uygun ustayı seç. 81 il, 973 ilçe.
          </p>
          <div className="mt-5 flex flex-col items-center justify-center gap-3 sm:flex-row">
            <Link href={PLAY_URL_PAGE} target="_blank" rel="noopener"
              className="inline-flex items-center gap-2 rounded-xl bg-black px-7 py-3.5 text-sm font-semibold text-white hover:bg-zinc-800 transition"
            >
              📱 Google Play'den İndir
            </Link>
            <Link href="/indir" className="text-sm text-zinc-500 hover:text-black underline">
              Hızlı indirme linki: /indir
            </Link>
          </div>
        </div>

        <div className="mt-10 grid gap-4 sm:grid-cols-3">
          <div className="rounded-2xl border p-5 bg-white">
            <h3 className="font-semibold text-sm">1. İlan Oluştur</h3>
            <p className="mt-1.5 text-sm text-zinc-600">Şehir, hizmet ve detaylarını seçerek ilanını kolayca oluştur.</p>
          </div>
          <div className="rounded-2xl border p-5 bg-white">
            <h3 className="font-semibold text-sm">2. Teklif Al</h3>
            <p className="mt-1.5 text-sm text-zinc-600">Yakındaki doğrulanmış ustalardan anında teklifler gelsin.</p>
          </div>
          <div className="rounded-2xl border p-5 bg-white">
            <h3 className="font-semibold text-sm">3. Ustanı Seç</h3>
            <p className="mt-1.5 text-sm text-zinc-600">Puanları, yorumları ve teklifleri değerlendirerek işini ver.</p>
          </div>
        </div>
      </main>
    </>
  )
}