// app/hug-proje/proje-turu/[slug]/page.tsx - Proje Türü Detay - hug-market düzeniyle
export const dynamic = 'force-static'
export const dynamicParams = false
import Link from 'next/link'
import { notFound } from 'next/navigation'
import { projeTurleri } from '../../../../data/hug-proje-proje-turleri'
import { ihtiyaclar } from '../../../../data/hug-proje-ihtiyaclar'

const PLAY_URL_CLEAN = "https://play.google.com/store/apps/details?id=com.hemenustamgelsin.android"

export function generateStaticParams() {
  return projeTurleri.map((t) => ({ slug: t.seoSlug }))
}

export async function generateMetadata({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params
  if (slug.includes('.')) return {}
  const kayit = projeTurleri.find((t) => t.seoSlug === slug)
  if (!kayit) return {}
  const canonical = `https://hemenustamgelsin.com/hug-proje/proje-turu/${kayit.seoSlug}/`
  return {
    title: kayit.title,
    description: kayit.description,
    alternates: { canonical },
    openGraph: {
      title: kayit.title,
      description: kayit.description,
      url: canonical,
      type: 'website',
      siteName: 'Hemen Ustam Gelsin',
      images: [{ url: 'https://hemenustamgelsin.com/hug-proje/logo.png', width: 1200, height: 630, alt: 'HUG PROJE' }],
    },
    twitter: {
      card: 'summary_large_image',
      title: kayit.title,
      description: kayit.description,
      images: ['https://hemenustamgelsin.com/hug-proje/logo.png'],
    },
  }
}

export default async function ProjeTuruDetay({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params
  if (slug.includes('.')) notFound()
  const kayit = projeTurleri.find((t) => t.seoSlug === slug)
  if (!kayit) notFound()

  const indirUrl = `${PLAY_URL_CLEAN}&pcampaignid=web_hug_proje_proje_turu_${kayit.seoSlug}`

  // Sadece ihtiyaclar.ts'te gercek pageName karsiligi olan ihtiyaclar gosterilir.
  // YapiTuru / Asama ID'leri icin Turkce ad kaynagi yok, uydurma etiket yok, basilmez.
  const ilgiliIhtiyaclar = kayit.ihtiyacIds
    .map((id) => ihtiyaclar.find((i) => i.id === id))
    .filter((i): i is NonNullable<typeof i> => !!i)

  const breadcrumbSchema = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com/" },
      { "@type": "ListItem", "position": 2, "name": "HUG PROJE", "item": "https://hemenustamgelsin.com/hug-proje/" },
      { "@type": "ListItem", "position": 3, "name": kayit.pageName, "item": `https://hemenustamgelsin.com/hug-proje/proje-turu/${kayit.seoSlug}/` }
    ]
  }

  const serviceSchema = {
    "@context": "https://schema.org",
    "@type": "ProfessionalService",
    "name": kayit.pageName,
    "description": kayit.description,
    "url": `https://hemenustamgelsin.com/hug-proje/proje-turu/${kayit.seoSlug}/`,
    "areaServed": "TR"
  }

  const faqSchema = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {
        "@type": "Question",
        "name": `${kayit.pageName} nedir?`,
        "acceptedAnswer": { "@type": "Answer", "text": `${kayit.description} HUG PROJE, bu proje türü için ilgili ihtiyaçları ve profesyonelleri listeler.` }
      },
      {
        "@type": "Question",
        "name": `${kayit.pageName} için hangi profesyoneller gerekir?`,
        "acceptedAnswer": { "@type": "Answer", "text": `Bu sayfada listelenen ilgili ihtiyaçlara bağlı gerçek profesyoneller gösterilir. Uydurma etiket oluşturulmaz, sadece kayıtlardaki eşleşmeler listelenir.` }
      },
      {
        "@type": "Question",
        "name": `${kayit.pageName} projemi nasıl başlatırım?`,
        "acceptedAnswer": { "@type": "Answer", "text": `Önce bu sayfadaki ilgili ihtiyaçları inceleyin, ardından Hemen Ustam Gelsin uygulamasını indirip projeniz için eşleşme başlatın.` }
      },
      {
        "@type": "Question",
        "name": `${kayit.pageName} hangi illerde geçerli?`,
        "acceptedAnswer": { "@type": "Answer", "text": `HUG PROJE, Türkiye genelinde 81 il ve 973 ilçede proje geliştirme için profesyonel eşleştirme sağlar.` }
      }
    ]
  }

  return (
    <main className="bg-[#fbfbf8] text-zinc-900 min-h-screen">
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(serviceSchema) }} />
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
          <a href={indirUrl} target="_blank" rel="noopener" className="text- font-bold px-4 py-2 rounded-full bg-black text-white shrink-0">Uygulamayı İndir</a>
        </div>
      </div>

      <section className="max-w- mx-auto px-6 pt-12 pb-8">
        <nav className="text- text-zinc-500 mb-4 flex gap-1 items-center">
          <Link href="/" className="hover:text-black">Ana Sayfa</Link><span>/</span>
          <Link href="/hug-proje/" className="hover:text-black">HUG PROJE</Link><span>/</span>
          <span className="text-zinc-900 font-medium">{kayit.pageName}</span>
        </nav>
        <div className="inline-flex items-center gap-2 text- tracking-widest uppercase bg-black text-white px-3 py-1 rounded-full">HUG PROJE • PROJE TÜRLERİ</div>
        <h1 className="mt-4 text- lg:text- leading-[0.9] font-black tracking-tight">{kayit.pageName}</h1>
        <p className="mt-4 text- leading-[1.5] text-zinc-600 max-w-">{kayit.description}</p>
        <p className="mt-3 text- leading-[1.5] text-zinc-600 max-w-">Projen için doğru profesyonelleri bul. Hemen Ustam Gelsin&apos;i indir!</p>
        <div className="mt-6 flex gap-3 flex-wrap">
          <a href={indirUrl} target="_blank" rel="noopener" className="bg-black text-white px-6 py-3 rounded-full text-sm font-semibold">Hemen Ustam Gelsin&apos;i İndir →</a>
        </div>
      </section>

      {ilgiliIhtiyaclar.length > 0 ? (
        <section className="max-w- mx-auto px-6 pb-16">
          <h2 className="text- font-bold mb-6">İlgili İhtiyaçlar</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
            {ilgiliIhtiyaclar.map((i) => (
              <Link key={i.id} href={`/hug-proje/ihtiyac/${i.seoSlug}/`} className="group bg-white border border-zinc-100 rounded-2xl overflow-hidden hover:border-black transition-all hover:shadow-xl">
                <div className="p-4">
                  <div className="text- font-bold leading-tight">{i.pageName}</div>
                  <div className="text- text-zinc-600 mt-1">{i.description}</div>
                  <div className="mt-3 text- font-medium">İncele →</div>
                </div>
              </Link>
            ))}
          </div>
        </section>
      ) : null}

      <section className="max-w- mx-auto px-6 pb-16">
        <h2 className="text- font-bold mb-6">Sık Sorulan Sorular</h2>
        <div className="space-y-4">
          <div className="bg-white border border-zinc-100 rounded-2xl p-5">
            <h3 className="font-bold">{kayit.pageName} nedir?</h3>
            <p className="text-zinc-600 mt-1">{kayit.description} HUG PROJE, bu proje türü için ilgili ihtiyaçları ve profesyonelleri listeler.</p>
          </div>
          <div className="bg-white border border-zinc-100 rounded-2xl p-5">
            <h3 className="font-bold">{kayit.pageName} için hangi profesyoneller gerekir?</h3>
            <p className="text-zinc-600 mt-1">Bu sayfada listelenen ilgili ihtiyaçlara bağlı gerçek profesyoneller gösterilir. Uydurma etiket oluşturulmaz, sadece kayıtlardaki eşleşmeler listelenir.</p>
          </div>
          <div className="bg-white border border-zinc-100 rounded-2xl p-5">
            <h3 className="font-bold">{kayit.pageName} projemi nasıl başlatırım?</h3>
            <p className="text-zinc-600 mt-1">Önce bu sayfadaki ilgili ihtiyaçları inceleyin, ardından Hemen Ustam Gelsin uygulamasını indirip projeniz için eşleşme başlatın.</p>
          </div>
          <div className="bg-white border border-zinc-100 rounded-2xl p-5">
            <h3 className="font-bold">{kayit.pageName} hangi illerde geçerli?</h3>
            <p className="text-zinc-600 mt-1">HUG PROJE, Türkiye genelinde 81 il ve 973 ilçede proje geliştirme için profesyonel eşleştirme sağlar.</p>
          </div>
        </div>
      </section>
    </main>
  )
}