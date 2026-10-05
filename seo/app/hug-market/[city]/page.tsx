// app/hug-market/[city]/page.tsx - ŞEHİR HUB - 81 SAYFA - 18 KATEGORİ - FINAL v4 - TRAILING SLASH FIX + BREADCRUMB
export const dynamic = 'force-static'
export const dynamicParams = false
import { cities } from '../../../data/cities'
import Link from 'next/link'
import { notFound } from 'next/navigation'
import sehirler from '../../../data/sehirler.json'
import ilceler from '../../../data/ilceler.json'

type HugCat = {
  slug: string
  name: string
  shortName: string
  heroTitle: string
  imageFile: string
  productAreas: string
}

const hugCats: HugCat[] = [
  { slug: "banyo-mutfak", name: "Banyo & Mutfak", shortName: "Banyo Mutfak", heroTitle: "Banyo & Mutfak", imageFile: "banyo-mutfak.jpg", productAreas: "Mutfak Dolabı, Banyo Dolabı, Tezgah" },
  { slug: "temizlik-hijyen", name: "Temizlik & Hijyen", shortName: "Temizlik", heroTitle: "Temizlik & Hijyen", imageFile: "temizlik-hijyen.jpg", productAreas: "Endüstriyel Makine, Süpürme, Vakum" },
  { slug: "elektrik-aydinlatma", name: "Elektrik & Aydınlatma", shortName: "Elektrik", heroTitle: "Elektrik & Aydınlatma", imageFile: "elektrik-aydinlatma.jpg", productAreas: "Kablo, Armatür, Akıllı Ev" },
  { slug: "hirdavat-el-aletleri-is-guvenligi", name: "Hırdavat & İş Güvenliği", shortName: "Hırdavat", heroTitle: "Hırdavat", imageFile: "hirdavat-el-aletleri-is-guvenligi.jpg", productAreas: "El Aletleri, İş Güvenliği" },
  { slug: "bahce-peyzaj-dis-mekan", name: "Bahçe, Peyzaj & Dış Mekân", shortName: "Bahçe Peyzaj", heroTitle: "Bahçe & Peyzaj", imageFile: "bahce-peyzaj-dis-mekan.jpg", productAreas: "Traverten, Pergola, Peyzaj" },
  { slug: "tesisat-su-sistemleri", name: "Tesisat & Su Sistemleri", shortName: "Tesisat", heroTitle: "Tesisat", imageFile: "tesisat-su-sistemleri.jpg", productAreas: "Boru, Batarya, Arıtma" },
  { slug: "yapi-malzemeleri-insaat", name: "Yapı Malzemeleri & İnşaat", shortName: "Yapı", heroTitle: "Yapı Malzemeleri", imageFile: "yapi-malzemeleri-insaat.jpg", productAreas: "Alçı, Çimento, Kimyasal" },
  { slug: "boya-dekorasyon", name: "Boya & Dekorasyon", shortName: "Boya", heroTitle: "Boya & Dekorasyon", imageFile: "boya-dekorasyon.jpg", productAreas: "İç Dış Cephe, Epoksi" },
  { slug: "cati-cephe-sistemleri", name: "Çatı & Cephe Sistemleri", shortName: "Çatı Cephe", heroTitle: "Çatı & Cephe", imageFile: "cati-cephe-sistemleri.jpg", productAreas: "Kiremit, Sandviç Panel" },
  { slug: "havuz-spa-sistemleri", name: "Havuz & Spa Sistemleri", shortName: "Havuz Spa", heroTitle: "Havuz & Spa", imageFile: "havuz-spa-sistemleri.jpg", productAreas: "Filtre, Pompa, Kimyasal" },
  { slug: "isitma-sogutma-iklimlendirme", name: "Isıtma, Soğutma & İklimlendirme", shortName: "Isıtma Soğutma", heroTitle: "Isıtma Soğutma", imageFile: "isitma-sogutma-iklimlendirme.jpg", productAreas: "Kombi, Klima, VRF" },
  { slug: "seramik-fayans-zemin", name: "Seramik, Fayans & Zemin", shortName: "Seramik", heroTitle: "Seramik & Zemin", imageFile: "seramik-fayans-zemin.jpg", productAreas: "Banyo Seramik, Parke" },
  { slug: "yalitim-izolasyon", name: "Yalıtım & İzolasyon", shortName: "Yalıtım", heroTitle: "Yalıtım & İzolasyon", imageFile: "yalitim-izolasyon.jpg", productAreas: "Mantolama, Membran" },
  { slug: "cam-aluminyum-cephe-sistemleri", name: "Cam, Alüminyum & Cephe", shortName: "Cam Alüminyum", heroTitle: "Cam & Alüminyum", imageFile: "cam-aluminyum-cephe-sistemleri.jpg", productAreas: "Cam Balkon, Giyotin" },
  { slug: "yenilenebilir-enerji-guc-sistemleri", name: "Yenilenebilir Enerji & Güç", shortName: "Yenilenebilir", heroTitle: "Yenilenebilir Enerji", imageFile: "yenilenebilir-enerji-guc-sistemleri.jpg", productAreas: "GES, Depolama, Şarj" },
  { slug: "kapi-kilit-gecis-kontrol", name: "Kapı, Kilit & Geçiş Kontrol", shortName: "Kapı Kilit", heroTitle: "Kapı & Kilit", imageFile: "kapi-kilit-gecis-kontrol.jpg", productAreas: "Çelik Kapı, Akıllı Kilit" },
  { slug: "guvenlik-yangin-zayif-akim", name: "Güvenlik, Yangın & Zayıf Akım", shortName: "Güvenlik", heroTitle: "Güvenlik & Yangın", imageFile: "guvenlik-yangin-zayif-akim.jpg", productAreas: "Kamera, Yangın Algılama" },
  { slug: "asansor-yuruyen-merdiven", name: "Asansör & Yürüyen Merdiven", shortName: "Asansör", heroTitle: "Asansör", imageFile: "asansor-yuruyen-merdiven.jpg", productAreas: "Kabin, Motor, Yürüyen" },
]

export async function generateStaticParams() {
  return cities
  .filter(c => c.slug!== 'cozum-ortagi')
  .map(c => ({ city: c.slug }))
}

export async function generateMetadata({ params }: { params: Promise<{ city: string }> }) {
  const { city: citySlug } = await params
  if (citySlug === 'cozum-ortagi') return {}
  const city = cities.find(c => c.slug === citySlug)
  if(!city) return {}
  return {
    title: `${city.name} HUG MARKET Çözüm Ortakları | 18 Kategori Yapı Malzemeleri B2B`,
    description: `${city.name}'daki tadilat ve yenileme projelerinde 18 kategoride yapı malzemesi çözüm ortaklığı. Banyo, mutfak, boya, seramik, tesisat, elektrik ve tüm yapı kategorileri.`,
  }
}

export default async function CityHubPage({ params }: { params: Promise<{ city: string }> }) {
  const { city: citySlug } = await params

  if (citySlug === 'cozum-ortagi') {
    notFound()
  }

  const city = cities.find(c => c.slug === citySlug)
  if (!city) {
    notFound()
  }

  const sehirData = (sehirler as any[]).find(s =>
    s.sehir_adi?.toLowerCase() === city.name.toLowerCase() ||
    s.sehir_adi?.toLowerCase().includes(city.name.toLowerCase())
  )
  const sehirId = sehirData?.sehir_id
  const cityIlceler = sehirId? (ilceler as any[]).filter(i => i.sehir_id === sehirId) : []

  const breadcrumbSchema = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {
        "@type": "ListItem",
        "position": 1,
        "name": "Ana Sayfa",
        "item": "https://hemenustamgelsin.com/"
      },
      {
        "@type": "ListItem",
        "position": 2,
        "name": "HUG MARKET",
        "item": "https://hemenustamgelsin.com/hug-market/"
      },
      {
        "@type": "ListItem",
        "position": 3,
        "name": `${city.name} HUG MARKET`,
        "item": `https://hemenustamgelsin.com/hug-market/${city.slug}/`
      }
    ]
  }

  return (
    <main className="bg-[#fbfbf8] text-zinc-900">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }}
      />

      <div className="sticky top-0 z-30 bg-white/80 backdrop-blur-xl border-b border-zinc-100">
        <div className="max-w- mx-auto px-6 h- flex items-center justify-between overflow-hidden">
          <div className="flex items-center gap-3">
            <div className="flex items-center justify-center shrink-0" style={{ height: '36px' }}>
              <img
                src="/assets/hug/hug_logo.jpg"
                alt="HUG MARKET"
                style={{ height: '36px', width: 'auto', maxWidth: '180px', objectFit: 'contain', display: 'block' }}
              />
            </div>
            <div className="h-6 w-px bg-zinc-200 shrink-0" />
            <span className="text- font-semibold tracking-tight truncate">Proje Odaklı Yapı Malzemeleri Ekosistemi</span>
          </div>
          <Link href="/hug-market/cozum-ortagi/" className="text- font-bold px-4 py-2 rounded-full bg-black text-white shrink-0">Çözüm Ortağı Ol</Link>
        </div>
      </div>

      <section className="max-w- mx-auto px-6 pt-12 pb-8">
        <nav className="text- text-zinc-500 mb-4 flex gap-1 items-center">
          <Link href="/" className="hover:text-black">Ana Sayfa</Link>
          <span>/</span>
          <Link href="/hug-market/" className="hover:text-black">HUG MARKET</Link>
          <span>/</span>
          <span className="text-zinc-900 font-medium">{city.name}</span>
        </nav>
        <div className="inline-flex items-center gap-2 text- tracking-widest uppercase bg-black text-white px-3 py-1 rounded-full">HUG MARKET • {city.name} • 18 KATEGORİ</div>
        <h1 className="mt-4 text- lg:text- leading-[0.9] font-black tracking-tight">{city.name} HUG MARKET<br/>Çözüm Ortakları</h1>
        <p className="mt-4 text- leading-[1.5] text-zinc-600 max-w-">{city.name}'daki konut, tadilat ve yenileme projelerinde 18 ana kategoride yapı malzemelerinizi gerçek proje ihtiyaçlarıyla buluşturun. Her kategoride tek çözüm ortağı.</p>
        <div className="mt-6 flex gap-3">
          <Link href="/hug-market/cozum-ortagi/" className="bg-black text-white px-6 py-3 rounded-full text-sm font-semibold">Çözüm Ortağı Ol →</Link>
          <span className="border border-zinc-300 px-6 py-3 rounded-full text-sm text-zinc-600">{cityIlceler.length || city.districts?.length || ''} İlçe • 18 Kategori • Proje Bazlı Satış</span>
        </div>
      </section>

      <section className="max-w- mx-auto px-6 pb-12">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text- font-bold">{city.name}'da HUG MARKET Kategorileri</h2>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {hugCats.map(cat => (
            <Link key={cat.slug} href={`/hug-market/${city.slug}/${cat.slug}/`} className="group bg-white border rounded- overflow-hidden hover:border-black transition-all hover:shadow-xl">
              <div className="relative h- bg-zinc-100 overflow-hidden">
                <img
                  src={`/assets/hug/${cat.imageFile}`}
                  alt={`${city.name} ${cat.name}`}
                  className="w-full h-full object-cover absolute inset-0 group-hover:scale-[1.03] transition-transform duration-500"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />
                <div className="absolute top-3 left-3 bg-white/90 backdrop-blur px-2.5 py-1 rounded-full text- font-bold tracking-widest uppercase">{cat.shortName}</div>
                <div className="absolute bottom-0 p-4 text-white">
                  <div className="text- font-bold leading-tight">{cat.name}</div>
                  <div className="text- text-white/70 mt-1">{cat.productAreas}</div>
                </div>
              </div>
              <div className="p-4 flex justify-between items-center">
                <div className="text- font-medium">{city.name} {cat.heroTitle} →</div>
                <div className="w-7 h-7 rounded-full bg-black text-white grid place-items-center text-">→</div>
              </div>
            </Link>
          ))}
        </div>
      </section>

      <section className="max-w- mx-auto px-6 pb-12">
        <h3 className="text- font-bold mb-4">{city.name} İlçeleri - HUG MARKET Hizmet Alanı</h3>
        <div className="bg-white border rounded- p-6">
          <div className="flex flex-wrap gap-2">
            {cityIlceler.length > 0? cityIlceler.map((ilce: any) => (
              <span key={ilce.ilce_id} className="px-3 py-1.5 bg-[#f6f6f3] border rounded-full text-">{ilce.ilce_adi}</span>
            )) : (city.districts || []).map((d: any) => {
              const name = typeof d === 'string'? d : d.name || d.slug
              return <span key={name} className="px-3 py-1.5 bg-[#f6f6f3] border rounded-full text-">{name}</span>
            })}
          </div>
          <p className="mt-4 text- text-zinc-600">{city.name}'daki {cityIlceler.length || city.districts?.length || 0} ilçede aktif usta ağı ve proje eşleşmesi.</p>
        </div>
      </section>

      <section className="max-w- mx-auto px-6 pb-16">
        <div className="bg-black text-white rounded- p-10 text-center">
          <h2 className="text- font-black leading-tight">{city.name}'da Kategori Lideri Olun</h2>
          <p className="mt-3 text-zinc-300 max-w-2xl mx-auto">18 kategoriden birinde çözüm ortağı olun, {city.name}'daki tüm tadilat projelerinde ürünleriniz ihtiyaç listesinde önerilsin.</p>
          <Link href="/hug-market/cozum-ortagi/" className="mt-6 inline-block bg-white text-black px-8 py-3 rounded-full font-bold">ÇÖZÜM ORTAĞI BAŞVURUSU</Link>
        </div>
      </section>
    </main>
  )
}