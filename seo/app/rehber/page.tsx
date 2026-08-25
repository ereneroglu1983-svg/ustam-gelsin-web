// app/rehber/page.tsx - DÜZELTİLDİ
import { collection, getDocs, orderBy, query } from 'firebase/firestore'
import { db } from '../../lib/firebase'
import Link from 'next/link'

export const revalidate = 3600
export const dynamic = 'force-static'

async function getBlogs(){
  try {
    const q = query(collection(db, 'icerikler'), orderBy('tarih', 'desc'))
    const snap = await getDocs(q)
    return snap.docs.map(d => d.data() as any)
  } catch {
    return []
  }
}

export default async function RehberHub(){
  const blogs = await getBlogs()
  return (
    <main className="p-6 max-w-5xl mx-auto">
      <h1 className="text-3xl font-bold">İnşaat Rehberi</h1>
      <div className="grid gap-4 mt-6 md:grid-cols-2">
        {blogs.map((b:any)=>(
          <Link key={b.slug} href={`/rehber/${b.slug}`} className="border p-4 rounded hover:shadow">
            <h2 className="font-bold">{b.baslik}</h2>
            <p className="text-sm text-gray-500">{b.kategori}</p>
          </Link>
        ))}
      </div>
    </main>
  )
}