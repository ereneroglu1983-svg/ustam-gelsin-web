// app/rehber/[slug]/page.tsx - FINAL v4 - TUM FIXLER + INTERNAL LINK + IMAGE FIX
import { doc, getDoc, collection, getDocs, query, where } from 'firebase/firestore'
import { db } from '../../../lib/firebase'
import Link from 'next/link'
import { cache } from 'react'
import type { Metadata } from 'next'
import { notFound } from 'next/navigation'

export const dynamic = 'force-static'
export const revalidate = 3600

function fixR2Url(path: string) {
  if (!path) return "";
  path = path.trim();
  const cdnBase = "https://cdn.hemenustamgelsin.com";
  const oldR2 = "https://pub-27a42c3abc764860b54d06b5cf79567f.r2.dev";
  path = path.replaceAll(oldR2, cdnBase);
  path = path.replaceAll(`${cdnBase}/ustam-gelsin-medya/`, `${cdnBase}/`);
  path = path.replaceAll("/ustam-gelsin-medya/", "/");
  path = path.replaceAll("ustam-gelsin-medya/", "");
  if (path.startsWith("http")) return path;
  if (path.startsWith("/")) return `${cdnBase}${path}`;
  return `${cdnBase}/${path}`;
}

// RESIM OPTIMIZASYON FIX - SENIN BUG BURADAYDI
function getOptimizedR2Url(url: string) {
  if (!url) return "";
  const cdnBase = "https://cdn.hemenustamgelsin.com";
  if (!url.startsWith(cdnBase)) return url;
  const path = url.replace(`${cdnBase}/`, '');
  // Dogru format: cdnBase/cdn-cgi/image/width=800/ + path
  return `${cdnBase}/cdn-cgi/image/width=800,quality=75,format=auto/${path}`;
}

function toISOStringSafe(value: any): string | undefined {
  if (!value) return undefined
  if (value?.toDate) {
    try { return value.toDate().toISOString() } catch {}
  }
  try { return new Date(value).toISOString() } catch { return undefined }
}

const getIcerik = cache(async (slug: string) => {
  try {
    const directSnap = await getDoc(doc(db, 'icerikler', slug))
    if (directSnap.exists()) return { id: directSnap.id, ...(directSnap.data() as any) }
    const q = query(collection(db, 'icerikler'), where('slug', '==', slug))
    const qsnap = await getDocs(q)
    if (!qsnap.empty) {
      const d = qsnap.docs[0]
      return { id: d.id, ...(d.data() as any) }
    }
    return null
  } catch {
    return null
  }
})

export async function generateStaticParams() {
  try {
    const snap = await getDocs(collection(db, 'icerikler'))
    return snap.docs.map(d => {
      const data = d.data() as any
      return { slug: data.slug || d.id }
    })
  } catch { return [] }
}

export async function generateMetadata({ params }: { params: Promise<{ slug: string }> }): Promise<Metadata> {
  const { slug } = await params
  const b = await getIcerik(slug)
  if (!b) return {}
  const canonical = `https://hemenustamgelsin.com/rehber/${b.slug || slug}`
  const imageUrl = b.imagePath ? fixR2Url(b.imagePath) : 'https://hemenustamgelsin.com/logo.png'
  const publishedDate = toISOStringSafe(b.tarih)
  return {
    title: `${b.baslik} | Hemen Ustam Gelsin`,
    description: b.aciklama || b.baslik.slice(0, 155),
    alternates: { canonical },
    openGraph: {
      title: b.baslik,
      description: b.aciklama || b.baslik.slice(0, 155),
      url: canonical,
      type: 'article',
      images: [{ url: imageUrl }],
      publishedTime: publishedDate,
      authors: ['Hemen Ustam Gelsin']
    },
    twitter: {
      card: 'summary_large_image',
      title: b.baslik,
      description: b.aciklama || b.baslik.slice(0, 155),
      images: [imageUrl]
    },
    robots: { index: true, follow: true }
  }
}

function otomatikFaqOlustur(baslik: string, kategori: string) {
  return [
    { soru: `${baslik} ne kadar tutar?`, cevap: `${kategori} işleri evin metrekaresine ve malzemeye göre değişir. Hemen Ustam Gelsin'den ücretsiz teklif alın.` },
    { soru: `En iyi ${kategori} ustasını nasıl bulurum?`, cevap: `Hemen Ustam Gelsin'e ilan bırakın; işinizin detaylarını paylaşarak uygun ustalardan teklif alabilirsiniz.` },
    { soru: `${baslik} için dikkat edilmesi gerekenler neler?`, cevap: `İşçilik kalitesi, malzeme seçimi ve zamanında teslim en önemli 3 kriterdir.` }
  ]
}

export default async function RehberDetay({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params
  const blog = await getIcerik(slug)
  if (!blog) notFound()

  let contentText = ''
  const fixedContentUrl = blog.contentPath ? fixR2Url(blog.contentPath) : ''
  if (fixedContentUrl) {
    try {
      const res = await fetch(fixedContentUrl, { next: { revalidate: 3600 } })
      if (res.ok) contentText = await res.text()
    } catch {
      contentText = 'İçerik yüklenemedi'
    }
  }

  const imageUrl = blog.imagePath ? fixR2Url(blog.imagePath) : 'https://hemenustamgelsin.com/logo.png'
  const optimizedImageUrl = getOptimizedR2Url(imageUrl)
  const canonical = `https://hemenustamgelsin.com/rehber/${blog.slug || slug}`
  const publishedDate = toISOStringSafe(blog.tarih)
  const faqs = blog.faqs?.length > 0 ? blog.faqs : otomatikFaqOlustur(blog.baslik, blog.kategori || 'tadilat')

  // INTERNAL LINK ICIN KATEGORI SLUG
  const kategoriSlug = (blog.kategori || 'tadilat').toLowerCase().replaceAll('ı','i').replaceAll('ş','s').replaceAll('ğ','g').replaceAll('ü','u').replaceAll('ö','o').replaceAll('ç','c').trim().replace(/\s+/g, '-')

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
    "datePublished": publishedDate,
    "dateModified": publishedDate,
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

  const isHtml = contentText.trim().startsWith('<') && (contentText.includes('<p') || contentText.includes('<h') || contentText.includes('<div'))

  return (
    <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(articleSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }} />

      <div style={{maxWidth:800, margin:'0 auto', padding:'24px 20px 60px'}}>
        <Link href="/rehber" style={{fontSize:13, color:'#78716c', textDecoration:'none'}}>← Rehbere Dön</Link>
        <h1 style={{fontSize:'clamp(24px, 4vw, 32px)', fontWeight:900, lineHeight:1.2, marginTop:12}}>{blog.baslik}</h1>
        <p style={{fontSize:12, color:'#a8a29e', marginTop:8}}>{blog.kategori} • {publishedDate ? new Date(publishedDate).toLocaleDateString('tr-TR') : ''}</p>

        <img src={optimizedImageUrl} alt={blog.baslik} loading="lazy" style={{marginTop:20, width:'100%', borderRadius:16, objectFit:'cover', aspectRatio:'16/9', background:'#f5f5f4'}} />

        <div style={{marginTop:24, background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:20}}>
          {isHtml ? (
            <div style={{lineHeight:1.7}} dangerouslySetInnerHTML={{ __html: contentText }} />
          ) : (
            <div style={{whiteSpace:'pre-wrap', lineHeight:1.7}}>{contentText}</div>
          )}

          {/* INTERNAL LINK CANAVARI - ORGANIK MUSTERI ICIN */}
          <div style={{marginTop:24, padding:16, background:'#FFF7ED', border:'1px solid #FFEDD5', borderRadius:12}}>
            <div style={{fontWeight:700, fontSize:14, marginBottom:8}}>💡 Bu iş için usta mı arıyorsun?</div>
            <div style={{display:'flex', flexWrap:'wrap', gap:8}}>
              <Link href={`/ustalar/${kategoriSlug}`} style={{fontSize:13, background:'#111', color:'white', padding:'8px 12px', borderRadius:8, textDecoration:'none'}}>{blog.kategori} Ustaları</Link>
              <Link href="/rehber" style={{fontSize:13, background:'white', border:'1px solid #e7e5e4', padding:'8px 12px', borderRadius:8, textDecoration:'none', color:'#111'}}>Tüm Rehberler</Link>
              <a href={`https://hemenustamgelsin.com/ustalar/${kategoriSlug}`} style={{fontSize:13, background:'white', border:'1px solid #e7e5e4', padding:'8px 12px', borderRadius:8, textDecoration:'none', color:'#111'}}>Ücretsiz Teklif Al</a>
            </div>
          </div>
        </div>

        <div style={{marginTop:24, background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:20}}>
          <div style={{fontWeight:800, fontSize:16, marginBottom:12}}>Sıkça Sorulanlar</div>
          {faqs.map((f: any, i: number) => (
            <div key={i} style={{marginBottom:16, borderBottom: i === faqs.length-1 ? '0' : '1px solid #f5f5f4', paddingBottom:16}}>
              <div style={{fontWeight:600, fontSize:14}}>{f.soru}</div>
              <div style={{color:'#57534e', marginTop:4, fontSize:13}}>{f.cevap}</div>
            </div>
          ))}
        </div>

        <div style={{marginTop:24, display:'grid', gridTemplateColumns:'1fr 1fr', gap:12}}>
          <a href="https://hemenustamgelsin.com?utm_source=seo&utm_medium=rehber_detay" style={{padding:14, background:'#111', color:'white', borderRadius:12, textAlign:'center', fontWeight:800, textDecoration:'none'}}>Hemen İlan Ver</a>
          <Link href="/rehber" style={{padding:14, background:'white', border:'1px solid #e7e5e4', borderRadius:12, textAlign:'center', fontWeight:800, textDecoration:'none', color:'#111'}}>Diğer Yazılar</Link>
        </div>

        {blog.youtubeId && (
          <iframe style={{marginTop:24, width:'100%', aspectRatio:'16/9', borderRadius:16, border:'0'}} src={`https://www.youtube.com/embed/${blog.youtubeId}`} loading="lazy" allowFullScreen />
        )}
      </div>
    </main>
  )
}