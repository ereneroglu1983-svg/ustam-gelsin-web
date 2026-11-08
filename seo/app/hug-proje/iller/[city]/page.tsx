// app/hug-proje/iller/[city]/page.tsx - İl Sayfası - hug-market düzeniyle
export const dynamic = 'force-static'
export const dynamicParams = false
import Link from 'next/link'
import { notFound } from 'next/navigation'
import { cities } from '../../../../data/cities'
import ilcelerData from '../../../../data/ilceler.json'

const PROJE_ETIKETI = 'Proje Geliştirme'
const PLAY_URL_CLEAN = "https://play.google.com/store/apps/details?id=com.hemenustamgelsin.android"

export function generateStaticParams() {
  return cities.map((c) => ({ city: c.slug }))
}

export async function generateMetadata({ params }: { params: Promise<{ city: string }> }) {
  const { city: citySlug } = await params
  if (citySlug.includes('.')) return {}
  const city = cities.find((c) => c.slug === citySlug)
  if (!city) return {}
  const canonical = `https://hemenustamgelsin.com/hug-proje/iller/${city.slug}/`
  const title = `${city.name} ${PROJE_ETIKETI} | HUG PROJE`
  const description = `${city.name} ${PROJE_ETIKETI} için doğru profesyonelleri bulun. Mimari proje, statik, elektrik, mekanik ve anahtar teslim yapım için ${city.name} genelinde proje geliştirme ve profesyonel eşleştirme.`
  return {
    title,
    description,
    alternates: { canonical },
    openGraph: {
      title,
      description,
      url: canonical,
      type: 'website',
      siteName: 'Hemen Ustam Gelsin',
      images: [{ url: 'https://hemenustamgelsin.com/hug-proje/logo.png', width: 1200, height: 630, alt: 'HUG PROJE' }],
    },
    twitter: {
      card: 'summary_large_image',
      title,
      description,
      images: ['https://hemenustamgelsin.com/hug-proje/logo.png'],
    },
  }
}

export default async function IlSayfasi({ params }: { params: Promise<{ city: string }> }) {
  const { city: citySlug } = await params
  if (citySlug.includes('.')) notFound()
  const city: any = cities.find((c) => c.slug === citySlug)
  if (!city) notFound()

  const indirUrl = `${PLAY_URL_CLEAN}&pccampaignid=web_hug_proje_il_${city.slug}`

  // İlçeler: önce cities içindeki districts, yoksa ilceler.json'dan - hug-market düzeni
  const districts: any[] = city.districts?.length
    ? city.districts
    : (ilcelerData as any[]).filter((d: any) => d.sehir_slug === city.slug || d.city_slug === city.slug || d.il_slug === city.slug || d.sehir === city.name)

  const intro = `${city.name} ${PROJE_ETIKETI} için doğru profesyonelleri bulun. ${city.name} genelinde arsa sahiplerini, yatırımcıları, bina ve site yönetimlerini; mimarlar, mühendisler, müteahhitler ve diğer proje profesyonelleriyle buluşturuyoruz.`

  const breadcrumbSchema = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com/" },
      { "@type": "ListItem", "position": 2, "name": "HUG PROJE", "item": "https://hemenustamgelsin.com/hug-proje/" },
      { "@type": "ListItem", "position": 3, "name": `${city.name} ${PROJE_ETIKETI}`, "item": `https://hemenustamgelsin.com/hug-proje/iller/${city.slug}/` }
    ]
  }

  const serviceSchema = {
    "@context": "https://schema.org",
    "@type": "ProfessionalService",
    "name": `${city.name} ${PROJE_ETIKETI}`,
    "description": intro,
    "url": `https://hemenustamgelsin.com/hug-proje/iller/${city.slug}/`,
    "areaServed": city.name
  }

  const faqSchema = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {
        "@type": "Question",
        "name": `${city.name} Proje Geliştirme nedir?`,
        "acceptedAnswer": { "@type": "Answer", "text": `${intro} İlçenizi seçip ilgili ilçe sayfasından devam edebilirsiniz.` }
      },
      {
        "@type": "Question",
        "name": `${city.name} için hangi profesyoneller var?`,
        "acceptedAnswer": { "@type": "Answer", "text": `HUG PROJE'de mimar, mühendis, müteahhit ve diğer proje profesyonelleri bulunur. Profesyoneller ve proje türleri sayfalarından size uygun olanı seçebilirsiniz.` }
      },
      {
        "@type": "Question",
        "name": `${city.name} Proje Geliştirme için nasıl başvuru yaparım?`,
        "acceptedAnswer": { "@type": "Answer", "text": `Önce ilçenizi seçin, ardından Hemen Ustam Gelsin uygulamasını indirip projeniz için eşleşme başlatın.` }
      },
      {
        "@type": "Question",
        "name": `${city.name} dışında başka illerde de geçerli mi?`,
        "acceptedAnswer": { "@type": "Answer", "text": `Evet. HUG PROJE, Türkiye genelinde 81 il ve 973 ilçede proje geliştirme için profesyonel eşleştirme sağlar.` }
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
          <span className="text-zinc-900 font-medium">{city.name} {PROJE_ETIKETI}</span>
        </nav>
        <div className="inline-flex items-center gap-2 text- tracking-widest uppercase bg-black text-white px-3 py-1 rounded-full">81 İL • {city.name.toLocaleUpperCase('tr-TR')}</div>
        <h1 className="mt-4 text- lg:text- leading-[0.9] font-black tracking-tight">{city.name} {PROJE_ETIKETI}</h1>
        <p className="mt-4 text- leading-[1.5] text-zinc-600 max-w-">{intro}</p>
        <p className="mt-3 text- leading-[1.5] text-zinc-600 max-w-">Projen için doğru profesyonelleri bul. Hemen Ustam Gelsin&apos;i indir!</p>
        <div className="mt-6 flex gap-3 flex-wrap">
          <a href={indirUrl} target="_blank" rel="noopener" className="bg-black text-white px-6 py-3 rounded-full text-sm font-semibold">Hemen Ustam Gelsin&apos;i İndir →</a>
        </div>
      </section>

      <section className="max-w- mx-auto px-6 pb-16">
        <h2 className="text- font-bold mb-6">{city.name} İlçeleri</h2>
        <div className="flex flex-wrap gap-2">
          {districts.map((d: any) => (
            <Link key={d.slug} href={`/hug-proje/iller/${city.slug}/ilceler/${d.slug}/`} className="px-3 py-1.5 bg-white border rounded-full text- hover:border-black">{d.name}</Link>
          ))}
        </div>
      </section>

      <section className="max-w- mx-auto px-6 pb-16">
        <h2 className="text- font-bold mb-6">Sık Sorulan Sorular</h2>
        <div className="space-y-4">
          <div className="bg-white border border-zinc-100 rounded-2xl p-5">
            <h3 className="font-bold">{city.name} Proje Geliştirme nedir?</h3>
            <p className="text-zinc-600 mt-1">{intro} İlçenizi seçip ilgili ilçe sayfasından devam edebilirsiniz.</p>
          </div>
          <div className="bg-white border border-zinc-100 rounded-2xl p-5">
            <h3 className="font-bold">{city.name} için hangi profesyoneller var?</h3>
            <p className="text-zinc-600 mt-1">HUG PROJE&apos;de mimar, mühendis, müteahhit ve diğer proje profesyonelleri bulunur. Profesyoneller ve proje türleri sayfalarından size uygun olanı seçebilirsiniz.</p>
          </div>
          <div className="bg-white border border-zinc-100 rounded-2xl p-5">
            <h3 className="font-bold">{city.name} Proje Geliştirme için nasıl başvuru yaparım?</h3>
            <p className="text-zinc-600 mt-1">Önce ilçenizi seçin, ardından Hemen Ustam Gelsin uygulamasını indirip projeniz için eşleşme başlatın.</p>
          </div>
          <div className="bg-white border border-zinc-100 rounded-2xl p-5">
            <h3 className="font-bold">{city.name} dışında başka illerde de geçerli mi?</h3>
            <p className="text-zinc-600 mt-1">Evet. HUG PROJE, Türkiye genelinde 81 il ve 973 ilçede proje geliştirme için profesyonel eşleştirme sağlar.</p>
          </div>
        </div>
      </section>
    </main>
  )
}