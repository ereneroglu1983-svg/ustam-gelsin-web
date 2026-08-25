// app/rehber/[slug]/page.tsx - OTOMATİK FAQ - SON HAL
import { doc, getDoc, collection, getDocs } from 'firebase/firestore'
import { db } from '../../../lib/firebase'

const R2_PUBLIC_URL = process.env.NEXT_PUBLIC_R2_PUBLIC_URL
export const revalidate = 3600
export const dynamic = 'force-static'

export async function generateStaticParams(){
  try {
    const snap = await getDocs(collection(db, 'icerikler'))
    return snap.docs.map(d => ({ slug: d.id }))
  } catch { return [] }
}

export async function generateMetadata({ params }: { params: Promise<{slug:string}> }){
  const { slug } = await params
  try {
    const snap = await getDoc(doc(db, 'icerikler', slug))
    if(!snap.exists()) return {}
    const b: any = snap.data()
    return { title: `${b.baslik} | Hemen Usta Gelsin`, description: b.aciklama || b.baslik }
  } catch { return {} }
}

function otomatikFaqOlustur(baslik: string, kategori: string){
  return [
    { soru: `${baslik} ne kadar tutar?`, cevap: `${kategori} işleri evin metrekaresine ve malzemeye göre değişir. Hemen Usta Gelsin'den ücretsiz teklif alarak en doğru fiyatı öğrenebilirsiniz.` },
    { soru: `En iyi ${kategori} ustasını nasıl bulurum?`, cevap: `Hemen Usta Gelsin'e ilan bırakın, doğrulanmış ${kategori} ustaları 15 dakika içinde size ulaşsın.` },
    { soru: `${baslik} için dikkat edilmesi gerekenler neler?`, cevap: `İşçilik kalitesi, malzeme seçimi ve zamanında teslim en önemli 3 kriterdir. Ustalarımızın yorumlarını kontrol etmeyi unutmayın.` }
  ]
}

export default async function RehberDetay({ params }: { params: Promise<{slug:string}> }){
  const { slug } = await params
  const snap = await getDoc(doc(db, 'icerikler', slug))
  if(!snap.exists()) return <div className="p-10 text-center">Blog bulunamadı BOSS!</div>
  const blog: any = snap.data()
  let contentText = ''
  try {
    const res = await fetch(`${R2_PUBLIC_URL}/${blog.contentPath}`, { next: { revalidate: 3600 } })
    contentText = await res.text()
  } catch { contentText = 'İçerik yüklenemedi' }
  const imageUrl = `${R2_PUBLIC_URL}/${blog.imagePath}`
  const faqs = blog.faqs?.length > 0 ? blog.faqs : otomatikFaqOlustur(blog.baslik, blog.kategori || 'tadilat')
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
      <h1 className="text-4xl font-bold leading-tight">{blog.baslik}</h1>
      <p className="text-sm text-gray-500 mt-2">{blog.kategori}</p>
      <img src={imageUrl} alt={blog.baslik} className="my-6 w-full rounded-xl object-cover" />
      <div className="whitespace-pre-wrap leading-relaxed">{contentText}</div>
      {blog.youtubeId && (<iframe className="mt-8 w-full aspect-video rounded-xl" src={`https://www.youtube.com/embed/${blog.youtubeId}`} allowFullScreen />)}
    </main>
  )
}