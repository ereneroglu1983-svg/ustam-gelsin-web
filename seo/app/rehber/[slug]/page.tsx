// app/rehber/[slug]/page.tsx - CLOUDFLARE FINAL
import { doc, getDoc, collection, getDocs } from 'firebase/firestore'
import { db } from '../../../lib/firebase'
import Link from 'next/link'
import { cache } from 'react'

const R2_PUBLIC_URL = process.env.NEXT_PUBLIC_R2_PUBLIC_URL

// Cloudflare export'te revalidate çalışmaz, o yüzden sildim
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

export async function generateMetadata({ params }: { params: Promise<{slug:string}> }){
  const { slug } = await params
  const b = await getIcerik(slug)
  if(!b) return {}
  return {
    title: `${b.baslik} | Hemen Usta Gelsin`,
    description: b.aciklama || b.baslik.slice(0,155),
  }
}

function otomatikFaqOlustur(baslik: string, kategori: string){
  return [
    { soru: `${baslik} ne kadar tutar?`, cevap: `${kategori} işleri evin metrekaresine ve malzemeye göre değişir. Hemen Usta Gelsin'den ücretsiz teklif alın.` },
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
    const res = await fetch(`${R2_PUBLIC_URL}/${blog.contentPath}`, { cache: 'no-store' })
    contentText = await res.text()
  } catch { contentText = 'İçerik yüklenemedi' }

  const imageUrl = `${R2_PUBLIC_URL}/${blog.imagePath}`
  // Cloudflare resize: 800px'e düşür, webp yap
  const optimizedImageUrl = `https://hemenustamgelsin.com/cdn-cgi/image/width=800,quality=75,format=auto/${imageUrl}`

  const faqs = blog.faqs?.length > 0? blog.faqs : otomatikFaqOlustur(blog.baslik, blog.kategori || 'tadilat')

  const faqSchema = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": faqs.map((f: any) => ({
      "@type": "Question", "name": f.soru,
      "acceptedAnswer": { "@type": "Answer", "text": f.cevap }
    }))
  }

  return (
    <main className="p-6 max-w-3xl mx-auto">
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }} />
      <Link href="/rehber" className="text-sm text-gray-500 hover:text-black">← Rehbere Dön</Link>
      <h1 className="text-4xl font-bold leading-tight mt-4">{blog.baslik}</h1>
      <p className="text-sm text-gray-500 mt-2">{blog.kategori}</p>

      <img
        src={optimizedImageUrl}
        alt={blog.baslik}
        loading="lazy"
        className="my-6 w-full rounded-xl object-cover aspect-[16/9] bg-gray-100"
      />

      <div className="whitespace-pre-wrap leading-relaxed text-">{contentText}</div>

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
        <Link href="/" className="p-4 bg-black text-white rounded-xl text-center font-bold">Hemen İlan Ver</Link>
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