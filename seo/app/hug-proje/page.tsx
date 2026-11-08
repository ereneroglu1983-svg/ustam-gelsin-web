// app/hug-proje/page.tsx - HUG PROJE ANA HUB - hug-market düzeniyle
export const dynamic = 'force-static'
import Link from 'next/link'
import { cities } from '../../data/cities'
import { profesyonelSeoSayfalari } from '../../data/hug-proje-profesyoneller'
import { projeTurleri } from '../../data/hug-proje-proje-turleri'
import { ihtiyaclar } from '../../data/hug-proje-ihtiyaclar'

const PLAY_URL = "https://play.google.com/store/apps/details?id=com.hemenustamgelsin.android&pcampaignid=web_hug_proje_main"

export const metadata = {
  title: 'HUG PROJE | Projen İçin Doğru Profesyonelleri Bul',
  description: 'Mimari proje, statik, elektrik, mekanik, zemin etüdü ve anahtar teslim yapım için doğru profesyonellerle eşleş. 81 ilde proje geliştirme ve profesyonel eşleştirme.',
  alternates: { canonical: 'https://hemenustamgelsin.com/hug-proje/' },
  openGraph: {
    title: 'HUG PROJE | Projen İçin Doğru Profesyonelleri Bul',
    description: 'Mimari proje, statik, elektrik, mekanik, zemin etüdü ve anahtar teslim yapım için doğru profesyonellerle eşleş. 81 ilde proje geliştirme ve profesyonel eşleştirme.',
    url: 'https://hemenustamgelsin.com/hug-proje/',
    type: 'website',
    locale: 'tr_TR',
    siteName: 'HUG PROJE',
  },
}

export default function Page() {
  const faqSchema = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {
        "@type": "Question",
        "name": "HUG PROJE nedir?",
        "acceptedAnswer": { "@type": "Answer", "text": "HUG PROJE, Türkiye genelinde arsa sahiplerini, yatırımcıları, bina ve site yönetimlerini; mimarlar, mühendisler, müteahhitler ve diğer proje profesyonelleriyle buluşturan proje geliştirme ve eşleştirme platformudur." }
      },
      {
        "@type": "Question",
        "name": "HUG PROJE ile hangi profesyonelleri bulabilirim?",
        "acceptedAnswer": { "@type": "Answer", "text": "Mimar, iç mimar, peyzaj mimarı, inşaat mühendisi, elektrik mühendisi, makine mühendisi ve diğer proje profesyonellerini bulabilirsiniz. Profesyoneller listesinden ihtiyacınıza uygun başlığı seçin." }
      },
      {
        "@type": "Question",
        "name": "HUG PROJE hangi illerde hizmet veriyor?",
        "acceptedAnswer": { "@type": "Answer", "text": "HUG PROJE, Türkiye genelinde 81 ilde proje geliştirme ve profesyonel eşleştirme için hizmet veriyor. İller listesinden ilinizi seçerek o ildeki sayfaya ulaşabilirsiniz." }
      }
    ]
  }

  return (
    <main className="bg-[#fbfbf8] text-zinc-900 min-h-screen">
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }} />
      {/* HEADER - hug-market düzeni */}
      <div className="sticky top-0 z-30 bg-white/80 backdrop-blur-xl border-b border-zinc-100">
        <div className="max-w- mx-auto px-6 h- flex items-center justify-between overflow-hidden">
          <div className="flex items-center gap-3 min-w-0">
            <div className="shrink-0 w- h- overflow-hidden flex items-center">
<img src="/hug-proje/logo.png" alt="HUG PROJE" style={{ height: '36px', width: '140px', objectFit: 'contain', objectPosition: 'left center', display: 'block' }} />            </div>
            <div className="hidden md:block h-6 w-px bg-zinc-200" />
            <span className="hidden lg:block text- font-semibold tracking-tight">Proje Geliştirme ve Profesyonel Eşleştirme</span>
          </div>
          <a href={PLAY_URL} target="_blank" rel="noopener" className="text- font-bold px-4 py-2 rounded-full bg-black text-white shrink-0">Uygulamayı İndir</a>
        </div>
      </div>

      {/* HERO - eski koddan, yazı aynen */}
      <section className="max-w- mx-auto px-6 pt-8 pb-4">
        <div className="inline-flex items-center gap-2 text- tracking-widest uppercase bg-black text-white px-3 py-1 rounded-full">HEMEN USTAM GELSİN • PROJE GELİŞTİRME</div>
        <h1 className="mt-4 text- lg:text- leading-[0.9] font-black tracking-tight">HUG PROJE</h1>
        <p className="mt-3 text- leading-[1.5] text-zinc-600 max-w-">BÜYÜK PROJELER • YAPI • TEKNİK</p>
        <p className="mt-3 text- leading-[1.5] text-zinc-600 max-w-">Türkiye genelinde arsa sahiplerini, yatırımcıları, bina ve site yönetimlerini; mimarlar, mühendisler, müteahhitler ve diğer proje profesyonelleriyle buluşturan proje geliştirme ve eşleştirme platformudur.</p>
        <p className="mt-3 text- leading-[1.5] text-zinc-600 max-w-">Projen için doğru profesyonelleri bul. Hemen Ustam Gelsin&apos;i indir!</p>
        <div className="mt-6 flex gap-3 flex-wrap">
          <a href={PLAY_URL} target="_blank" rel="noopener" className="bg-black text-white px-6 py-3 rounded-full text-sm font-semibold">Hemen Ustam Gelsin&apos;i İndir</a>
          <a href={PLAY_URL} target="_blank" rel="noopener" className="bg-white border border-black px-6 py-3 rounded-full text-sm font-semibold">Hemen Ustam Gelsin&apos;e Katıl</a>
        </div>
      </section>

      {/* PROFESYONELLER - eski koddan, liste aynen */}
      <section id="profesyoneller" className="max-w- mx-auto px-6 pb-16">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text- font-bold">Projen İçin Doğru Profesyonelleri Bul</h2>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {profesyonelSeoSayfalari.map((pr) => (
            <Link key={pr.seoSlug} href={`/hug-proje/profesyonel/${pr.seoSlug}/`} className="group bg-white border border-zinc-100 rounded-2xl overflow-hidden hover:border-black transition-all hover:shadow-xl">
              <div className="p-4">
                <div className="text- font-bold leading-tight">{pr.pageName}</div>
                <div className="text- text-zinc-600 mt-1">{pr.description}</div>
                <div className="mt-3 text- font-medium">İncele →</div>
              </div>
            </Link>
          ))}
        </div>
        <p className="mt-6 text- text-zinc-600">Yeni proje fırsatlarını keşfet. Hemen Ustam Gelsin&apos;e katıl!</p>
      </section>

      {/* PROJE TÜRLERİ */}
      <section id="proje-turleri" className="max-w- mx-auto px-6 pb-16">
        <h2 className="text- font-bold mb-6">Proje Türleri</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {projeTurleri.map((t) => (
            <Link key={t.seoSlug} href={`/hug-proje/proje-turu/${t.seoSlug}/`} className="group bg-white border border-zinc-100 rounded-2xl overflow-hidden hover:border-black transition-all hover:shadow-xl">
              <div className="p-4">
                <div className="text- font-bold leading-tight">{t.pageName}</div>
                <div className="text- text-zinc-600 mt-1">{t.description}</div>
                <div className="mt-3 text- font-medium">İncele →</div>
              </div>
            </Link>
          ))}
        </div>
      </section>

      {/* İHTİYAÇLAR */}
      <section id="ihtiyaclar" className="max-w- mx-auto px-6 pb-16">
        <h2 className="text- font-bold mb-6">İhtiyaçlar</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {ihtiyaclar.map((i) => (
            <Link key={i.seoSlug} href={`/hug-proje/ihtiyac/${i.seoSlug}/`} className="group bg-white border border-zinc-100 rounded-2xl overflow-hidden hover:border-black transition-all hover:shadow-xl">
              <div className="p-4">
                <div className="text- font-bold leading-tight">{i.pageName}</div>
                <div className="text- text-zinc-600 mt-1">{i.description}</div>
                <div className="mt-3 text- font-medium">İncele →</div>
              </div>
            </Link>
          ))}
        </div>
      </section>

      {/* 81 İL */}
      <section id="iller" className="max-w- mx-auto px-6 pb-16">
        <h2 className="text- font-bold mb-6">81 İl</h2>
        <div className="flex flex-wrap gap-2">
          {cities.map((c) => (
            <Link key={c.slug} href={`/hug-proje/iller/${c.slug}/`} className="px-3 py-1.5 bg-white border rounded-full text- hover:border-black">{c.name}</Link>
          ))}
        </div>
      </section>

      {/* CTA */}
      <section className="max-w- mx-auto px-6 pb-16">
        <div className="bg-black text-white rounded-2xl p-10 text-center">
          <h2 className="text- font-black leading-tight">Projen İçin Doğru Profesyonelleri Bul.</h2>
          <div className="mt-6 flex gap-3 justify-center flex-wrap">
            <a href={PLAY_URL} target="_blank" rel="noopener" className="bg-white text-black px-8 py-3 rounded-full font-bold text-">UYGULAMAYI İNDİR</a>
          </div>
        </div>
      </section>
    </main>
  )
}