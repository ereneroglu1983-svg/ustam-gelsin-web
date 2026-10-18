// app/hug-market/page.tsx - ANA HUB - ORJINAL KART YAPISI - FINAL v4
export const dynamic = 'force-static'
import Link from 'next/link'
import { cities } from '../../data/cities'

const PLAY_URL = "https://play.google.com/store/apps/details?id=com.hemenustamgelsin.android&pcampaignid=web_hug_market_main_v4"

export const metadata = {
  title: 'HUG MARKET - 81 İlde Yapı Malzemeleri Çözüm Ortakları',
  description: '81 ilde 18 kategoride yapı malzemeleri B2B çözüm ortaklığı.'
}

export default function Page(){
  const activeCities = cities.filter(c =>!['cozum-ortagi','cozum-ortakligi'].includes(c.slug))

  return (
    <main className="bg-[#fbfbf8] text-zinc-900 min-h-screen">
      {/* HEADER - FIX */}
      <div className="sticky top-0 z-30 bg-white/80 backdrop-blur-xl border-b border-zinc-100">
        <div className="max-w- mx-auto px-6 h- flex items-center justify-between overflow-hidden">
          <div className="flex items-center gap-3 min-w-0">
            <div className="shrink-0 w- h- overflow-hidden flex items-center">
              <img src="/assets/hug/hug_logo.jpg" alt="HUG" style={{ height: '36px', width: '140px', objectFit: 'contain', objectPosition: 'left center', display: 'block' }} />
            </div>
            <div className="hidden md:block h-6 w-px bg-zinc-200" />
            <span className="hidden lg:block text- font-semibold tracking-tight">Proje Odaklı B2B Ekosistem</span>
          </div>
          <Link href="/hug-market/cozum-ortagi/" className="text- font-bold px-4 py-2 rounded-full bg-black text-white shrink-0">Çözüm Ortağı Ol</Link>
        </div>
      </div>

      {/* HERO - Senin orjinal hero dilin */}
      <section className="max-w- mx-auto px-6 pt-8 pb-4">
        <div className="inline-flex items-center gap-2 text- tracking-widest uppercase bg-black text-white px-3 py-1 rounded-full">HUG MARKET • 81 İL • 18 KATEGORİ</div>
        <h1 className="mt-4 text- lg:text- leading-[0.9] font-black tracking-tight">Malzemeni Rafta Değil,<br/><span className="text-[#ff214f]">Projede Sat.</span></h1>
        <p className="mt-3 text- leading-[1.5] text-zinc-600 max-w-">81 ilde tadilat projelerinde 18 kategoride tek çözüm ortağı modeli. Şehrini seç, kategori lideri ol.</p>
      </section>

      {/* 81 ŞEHİR - ORJINAL KART YAPIN */}
      <section id="sehirler" className="max-w- mx-auto px-6 pb-16">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text- font-bold">Şehrini Seç, Kategori Lideri Ol →</h2>
          <div className="text- px-3 py-1.5 bg-black text-white rounded-full">{activeCities.length} ŞEHİR AKTİF</div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {activeCities.map(city => (
            <Link
              key={city.slug}
              href={`/hug-market/${city.slug}/`}
              className="group bg-white border border-zinc-100 rounded-2xl overflow-hidden hover:border-black transition-all hover:shadow-xl"
            >
              <div className="relative h- bg-zinc-100 overflow-hidden">
                <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />
                <div className="absolute top-3 left-3 bg-white/90 backdrop-blur px-2.5 py-1 rounded-full text- font-bold tracking-widest uppercase">{city.slug.toUpperCase()}</div>
                <div className="absolute bottom-0 p-4 text-white">
                  <div className="text- font-bold leading-tight">{city.name}</div>
                  <div className="text- text-white/70 mt-1">18 kategori • Tek çözüm ortağı</div>
                </div>
                <div className="absolute top-3 right-3 w-7 h-7 rounded-full bg-white text-black grid place-items-center text- group-hover:bg-black group-hover:text-white transition-colors">→</div>
              </div>
              <div className="p-4 flex justify-between items-center bg-white">
                <div className="text- font-medium">{city.name} HUG MARKET →</div>
                <div className="w-7 h-7 rounded-full bg-black text-white grid place-items-center text-">→</div>
              </div>
            </Link>
          ))}
        </div>
      </section>

      {/* CTA - Orjinalindeki gibi */}
      <section className="max-w- mx-auto px-6 pb-16">
        <div className="bg-black text-white rounded-2xl p-10 text-center">
          <h2 className="text- font-black leading-tight">Reklam Verme. Projenin İçinde Ol.</h2>
          <div className="mt-6 flex gap-3 justify-center flex-wrap">
            <Link href="/hug-market/cozum-ortagi/" className="bg-white text-black px-8 py-3 rounded-full font-bold text-">ÇÖZÜM ORTAĞI BAŞVURUSU</Link>
            <a href={PLAY_URL} target="_blank" className="bg-[#ff214f] text-white px-8 py-3 rounded-full font-bold text-">📱 UYGULAMAYI İNDİR</a>
          </div>
        </div>
      </section>
    </main>
  )
}