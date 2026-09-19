// app/rehber/[slug]/page.tsx - CLOUDFLARE FINAL - SEO TAM
import { doc, getDoc, collection, getDocs } from 'firebase/firestore'
import { db } from '../../../lib/firebase'
import Link from 'next/link'
import { cache } from 'react'
import type { Metadata } from 'next'

const R2_PUBLIC_URL = process.env.NEXT_PUBLIC_R2_PUBLIC_URL

export const dynamic = 'force-static'

const getIcerik = cache(async (slug: string) => {
  try {
    const snap = await getDoc(doc(db, 'icerikler', slug))
    if (!snap.exists()) return null
    return snap.data() as any
  } catch {
    return null
  }
})

export async function generateStaticParams(){
  try {
    const snap = await getDocs(collection(db, 'icerikler'))
    return snap.docs.map(d => ({ slug: d.id }))
  } catch { return [] }
}

export async function generateMetadata({ params }: { params: Promise<{slug:string}> }): Promise<Metadata>{
  const { slug } = await params
  const b = await getIcerik(slug)
  if(!b) return {}
  const canonical = `https://hemenustamgelsin.com/rehber/${slug}`
  const imageUrl = b.imagePath? `${R2_PUBLIC_URL}/${b.imagePath}` : 'https://hemenustamgelsin.com/logo.png'
  return {
    title: `${b.baslik} | Hemen Ustam Gelsin`,
    description: b.aciklama || b.baslik.slice(0,155),
    alternates: { canonical },
    openGraph: {
      title: b.baslik,
      description: b.aciklama || b.baslik.slice(0,155),
      url: canonical,
      type: 'article',
      images: [{ url: imageUrl }],
      publishedTime: b.tarih,
      authors: ['Hemen Ustam Gelsin']
    },
    twitter: {
      card: 'summary_large_image',
      title: b.baslik,
      description: b.aciklama || b.baslik.slice(0,155),
      images: [imageUrl]
    },
    robots: { index: true, follow: true }
  }
}

function otomatikFaqOlustur(baslik: string, kategori: string){
  return [
    { soru: `${baslik} ne kadar tutar?`, cevap: `${kategori} işleri evin metrekaresine ve malzemeye göre değişir. Hemen Ustam Gelsin'den ücretsiz teklif alın.` },
    { soru: `En iyi ${kategori} ustasını nasıl bulurum?`, cevap: `Hemen Usta Gelsin'e ilan bırakın, doğrulanmış ustalar 15 dk içinde ulaşsın.` },
    { soru: `${baslik} için dikkat edilmesi gerekenler neler?`, cevap: `İşçilik kalitesi, malzeme seçimi ve zamanında teslim en önemli 3 kriterdir.` }
  ]
}

export default async function RehberDetay({ params }: { params: Promise<{slug:string}> }){
  const { slug } = await params
  const blog = await getIcerik(slug)
  if(!blog) return <div className="p-10 text-center">Blog bulunamadı BOSS!</div>

  let contentText = ''
  try {
    // force-static'te no-store build'i patlatır, cache kullan
    const res = await fetch(`${R2_PUBLIC_URL}/${blog.contentPath}`, { next: { revalidate: 3600 } })
    contentText = await res.text()
  } catch { contentText = 'İçerik yüklenemedi' }

  const imageUrl = `${R2_PUBLIC_URL}/${blog.imagePath}`
  const optimizedImageUrl = `https://hemenustamgelsin.com/cdn-cgi/image/width=800,quality=75,format=auto/${imageUrl}`
  const canonical = `https://hemenustamgelsin.com/rehber/${slug}`

  const faqs = blog.faqs?.length > 0? blog.faqs : otomatikFaqOlustur(blog.baslik, blog.kategori || 'tadilat')

  const articleSchema = {
    "@context": "https://schema.org",
    "@type": "Article",
    "headline": blog.baslik,
    "description": blog.aciklama,
    "image": imageUrl,
    "author": { "@type": "Organization", "name": "Hemen Ustam Gelsin" },
    "publisher": {
      "@type": "Organization",
      "name": "Hemen Ustam Gelsin",
      "logo": { "@type": "ImageObject", "url": "https://hemenustamgelsin.com/logo.png" },
      "sameAs": [
        "https://www.linkedin.com/in/hemen-ustam-gelsin-2499b2415/",
        "https://www.instagram.com/hemenustamgelsin/",
        "https://www.facebook.com/profile.php?id=61591164702200",
        "https://x.com/Hemenustamglsn",
        "https://www.tiktok.com/@hemen_ustam_gelsin",
        "https://www.youtube.com/@HemenUstamGelsin"
      ]
    },
    "datePublished": blog.tarih,
    "mainEntityOfPage": canonical
  }

  const breadcrumbSchema = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com" },
      { "@type": "ListItem", "position": 2, "name": "İnşaat Rehberi", "item": "https://hemenustamgelsin.com/rehber" },
      { "@type": "ListItem", "position": 3, "name": blog.baslik, "item": canonical }
    ]
  }

  const faqSchema = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": faqs.map((f: any) => ({
      "@type": "Question", "name": f.soru,
      "acceptedAnswer": { "@type": "Answer", "text": f.cevap }
    }))
  }

  const isHtml = contentText.includes('<') && contentText.includes('>')

  return (
    <main className="p-6 max-w-3xl mx-auto">
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(articleSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }} />

      <Link href="/rehber" className="text-sm text-gray-500 hover:text-black">← Rehbere Dön</Link>
      <h1 className="text-4xl font-bold leading-tight mt-4">{blog.baslik}</h1>
      <p className="text-sm text-gray-500 mt-2">{blog.kategori} • {blog.tarih? new Date(blog.tarih).toLocaleDateString('tr-TR') : ''}</p>

      <img
        src={optimizedImageUrl}
        alt={blog.baslik}
        loading="lazy"
        className="my-6 w-full rounded-xl object-cover aspect-[16/9] bg-gray-100"
      />

      {/* DÜZELTME: HTML ise html olarak bas, düz metin ise pre-wrap */}
      {isHtml? (
        <div className="prose prose-neutral max-w-none leading-relaxed" dangerouslySetInnerHTML={{ __html: contentText }} />
      ) : (
        <div className="whitespace-pre-wrap leading-relaxed">{contentText}</div>
      )}

      <div className="mt-12 p-6 bg-white border rounded-xl">
        <h2 className="text-xl font-bold mb-4">Sıkça Sorulanlar</h2>
        {faqs.map((f:any,i:number)=>(
          <div key={i} className="mb-4 border-b pb-4 last:border-0">
            <h3 className="font-semibold">{f.soru}</h3>
            <p className="text-gray-600 mt-1 text-sm">{f.cevap}</p>
          </div>
        ))}
      </div>

      <div className="mt-8 grid grid-cols-2 gap-3">
        <a href="https://hemenustamgelsin.com?utm_source=seo&utm_medium=rehber_detay&utm_campaign=ilan_ver" className="p-4 bg-black text-white rounded-xl text-center font-bold">Hemen İlan Ver</a>
        <Link href="/rehber" className="p-4 bg-white border rounded-xl text-center font-bold">Diğer Yazılar</Link>
      </div>

      {blog.youtubeId && (
        <iframe
          className="mt-8 w-full aspect-video rounded-xl"
          src={`https://www.youtube.com/embed/${blog.youtubeId}`}
          loading="lazy"
          allowFullScreen
        />
      )}
    </main>
  )
}