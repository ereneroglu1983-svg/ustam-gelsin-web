// app/api/revalidate/route.ts - ANINDA CANLI YAPAN SİHİR
import { revalidatePath } from 'next/cache'
import { NextRequest, NextResponse } from 'next/server'

export async function POST(req: NextRequest) {
  try {
    const { slug } = await req.json()

    // Güvenlik - sadece sen tetikle
    const secret = req.headers.get('x-secret-key')
    if (secret !== process.env.REVALIDATE_SECRET) {
      return NextResponse.json({ error: 'Yetkisiz!' }, { status: 401 })
    }

    if (slug) {
      // Tek blogu yenile
      revalidatePath(`/rehber/${slug}`)
      console.log(`✅ Revalidated: /rehber/${slug}`)
    }

    // Hub'ı da yenile
    revalidatePath('/rehber')
    revalidatePath('/sitemap.xml')

    return NextResponse.json({
      revalidated: true,
      now: Date.now(),
      slug
    })
  } catch (e: any) {
    return NextResponse.json({ error: e.message }, { status: 500 })
  }
}