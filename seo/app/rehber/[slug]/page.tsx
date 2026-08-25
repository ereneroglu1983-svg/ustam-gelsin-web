// app/rehber/[slug]/page.tsx - TAM HALİ - DÜZELTİLDİ
import { doc, getDoc, collection, getDocs } from 'firebase/firestore'
import { db } from '../../../lib/firebase'

const R2_PUBLIC_URL = process.env.NEXT_PUBLIC_R2_PUBLIC_URL

export const revalidate = 3600
export const dynamic = 'force-static'

export async function generateStaticParams(){
  try {
    const snap = await getDocs(collection(db, 'icerikler'))
    return snap.docs.map(d => ({ slug: d.id }))
  } catch {
    return []
  }
}

export async function generateMetadata({ params }: { params: Promise<{slug:string}> }){
  const { slug } = await params
  try {
    const snap = await getDoc(doc(db, 'icerikler', slug))
    if(!snap.exists()) return {}
    const b: any = snap.data()
    return {
      title: `${b.baslik} | Hemen Usta Gelsin`,
      description: b.baslik,
    }
  } catch {
    return {}
  }
}

export default async function RehberDetay({ params }: { params: Promise<{slug:string}> }){
  const { slug } = await params
  const ref = doc(db, 'icerikler', slug)
  const snap = await getDoc(ref)

  if(!snap.exists()) return <div className="p-10 text-center">Blog bulunamadı BOSS!</div>

  const blog: any = snap.data()

  let contentText = ''
  try {
    const res = await fetch(`${R2_PUBLIC_URL}/${blog.contentPath}`, { next: { revalidate: 3600 } })
    contentText = await res.text()
  } catch {
    contentText = 'İçerik yüklenemedi'
  }

  const imageUrl = `${R2_PUBLIC_URL}/${blog.imagePath}`

  return (
    <main className="p-6 max-w-3xl mx-auto">
      <h1 className="text-4xl font-bold leading-tight">{blog.baslik}</h1>
      <p className="text-sm text-gray-500 mt-2">{blog.kategori}</p>
      <img src={imageUrl} alt={blog.baslik} className="my-6 w-full rounded-xl object-cover" />
      <div className="whitespace-pre-wrap leading-relaxed text-">{contentText}</div>
      {blog.youtubeId && (
        <iframe
          className="mt-8 w-full aspect-video rounded-xl"
          src={`https://www.youtube.com/embed/${blog.youtubeId}`}
          allowFullScreen
        />
      )}
    </main>
  )
}