// app/hug-market/[city]/[category]/page.tsx - B2B LANDING - FINAL v5.1 - PLAY BANNER EKLENDI
export const dynamic = 'force-static'
import { cities } from '../../../../data/cities'
import Link from 'next/link'

const PLAY_URL_CLEAN = "https://play.google.com/store/apps/details?id=com.hemenustamgelsin.android"
const PLAY_URL_HUG = `${PLAY_URL_CLEAN}&pcampaignid=web_hug_market_banner`

type HugCat = {
  slug: string
  name: string
  shortName: string
  heroTitle: string
  heroDesc: string
  why: string[]
  productAreas: string[]
  visual: string
  imageFile: string
}

const hugCats: HugCat[] = [
  {
    slug: "banyo-mutfak",
    name: "Banyo & Mutfak",
    shortName: "Banyo Mutfak",
    heroTitle: "Banyo & Mutfak Çözüm Ortakları",
    heroDesc: "banyo ve mutfak yenileme projelerinde ürünlerinizi ihtiyaç anında projeyle buluşturun",
    why: ["Mutfak dolabı montajı","Banyo dolabı & tezgah","Seramik & vitrifiye entegrasyonu","Ankastre & aksesuar eşleşmesi"],
    productAreas: ["Mutfak Dolabı Sistemleri","Banyo Dolabı & Lavabo","Tezgah & Eviye","Duvar & Zemin Seramiği","Batarya & Vitrifiye","Aksesuar & Aydınlatma"],
    visual: "modern luxury kitchen and bathroom installation",
    imageFile: "banyo-mutfak.jpg"
  },
  {
    slug: "temizlik-hijyen",
    name: "Temizlik & Hijyen",
    shortName: "Temizlik",
    heroTitle: "Temizlik & Hijyen Çözüm Ortakları",
    heroDesc: "teslim sonrası ve tadilat temizlik ihtiyaçlarında markanızı profesyonel akışa dahil edin",
    why: ["İnşaat sonrası temizlik","Sanayi tipi süpürme","Zemin cilalama","Endüstriyel vakum"],
    productAreas: ["İnşaat Sonrası Temizlik","Endüstriyel Süpürme Makinesi","Zemin Cilalama Makinesi","Sanayi Tipi Vakum","Kimyasal & Deterjan"],
    visual: "industrial cleaning machines, floor scrubber",
    imageFile: "temizlik-hijyen.jpg"
  },
  {
    slug: "elektrik-aydinlatma",
    name: "Elektrik & Aydınlatma",
    shortName: "Elektrik",
    heroTitle: "Elektrik & Aydınlatma Çözüm Ortakları",
    heroDesc: "elektrik tesisatı ve aydınlatma projelerinde ürünlerinizi doğru usta ve proje ile buluşturun",
    why: ["Tesisat yenileme","Aydınlatma tasarımı","Akıllı ev sistemleri","Pano & sigorta"],
    productAreas: ["Kablo & Tesisat","Anahtar Priz","Aydınlatma Armatür","Spot & LED","Akıllı Ev","Sigorta & Pano"],
    visual: "electrician installing modern lighting",
    imageFile: "elektrik-aydinlatma.jpg"
  },
  {
    slug: "hirdavat-el-aletleri-is-guvenligi",
    name: "Hırdavat, El Aletleri & İş Güvenliği",
    shortName: "Hırdavat",
    heroTitle: "Hırdavat & İş Güvenliği Çözüm Ortakları",
    heroDesc: "her tadilat projesinin temel ihtiyacı olan hırdavat ve iş güvenliğini marka bazlı konumlayın",
    why: ["Her projede ihtiyaç","Usta sadakati yüksek","Sarf & ekipman","Güvenlik zorunluluğu"],
    productAreas: ["El Aletleri","Elektrikli Aletler","İş Güvenliği","Bağlantı Elemanları","Silikon & Yapıştırıcı"],
    visual: "professional craftsman with power tools",
    imageFile: "hirdavat-el-aletleri-is-guvenligi.jpg"
  },
  {
    slug: "bahce-peyzaj-dis-mekan",
    name: "Bahçe, Peyzaj & Dış Mekân",
    shortName: "Bahçe Peyzaj",
    heroTitle: "Bahçe & Peyzaj Çözüm Ortakları",
    heroDesc: "bahçe ve dış mekân projelerinde peyzaj ürünlerinizi proje bazlı satışa dahil edin",
    why: ["Peyzaj uygulamaları","Çim & sulama","Dış mekân zemin","Bahçe yapıları"],
    productAreas: ["Peyzaj Bitki","Çim & Toprak","Sulama Sistemleri","Dış Mekan Zemin","Bahçe Mobilyası","Traverten & Deck"],
    visual: "luxury villa garden with travertine patio and pergola",
    imageFile: "bahce-peyzaj-dis-mekan.jpg"
  },
  {
    slug: "tesisat-su-sistemleri",
    name: "Tesisat & Su Sistemleri",
    shortName: "Tesisat",
    heroTitle: "Tesisat & Su Sistemleri Çözüm Ortakları",
    heroDesc: "sıhhi tesisat ve su sistemleri projelerinde ürünlerinizi ihtiyaç anında projeye dahil edin",
    why: ["Sıhhi tesisat","Pis su & temiz su","Batarya & armatür","Su yalıtımı"],
    productAreas: ["Boru & Ek Parça","Batarya & Musluk","Rezervuar","Su Arıtma","Pis Su Sistemleri","Yalıtım & Conta"],
    visual: "professional plumber installing pipes",
    imageFile: "tesisat-su-sistemleri.jpg"
  },
  {
    slug: "yapi-malzemeleri-insaat",
    name: "Yapı Malzemeleri & İnşaat",
    shortName: "Yapı Malzemeleri",
    heroTitle: "Yapı Malzemeleri Çözüm Ortakları",
    heroDesc: "yapı ve inşaat projelerinde malzemelerinizi gerçek ihtiyaç listesine dahil edin",
    why: ["Kaba inşaat","İnce inşaat","Alçı & sıva","Yapı kimyasalları"],
    productAreas: ["Alçı & Sıva","Çimento & Harç","Yapı Kimyasalları","Tuğla & Blok","Demir & Profil"],
    visual: "construction materials, building site",
    imageFile: "yapi-malzemeleri-insaat.jpg"
  },
  {
    slug: "boya-dekorasyon",
    name: "Boya & Dekorasyon",
    shortName: "Boya Dekorasyon",
    heroTitle: "Boya & Dekorasyon Çözüm Ortakları",
    heroDesc: "tadilat ve yenileme projelerinde boya ve dekorasyon ürünlerinizi ihtiyaç anında doğru usta ve projeyle buluşturun",
    why: ["İç cephe uygulamaları","Dış cephe uygulamaları","Yüzey hazırlığı","Dekoratif uygulamalar"],
    productAreas: ["İç Cephe Boya Sistemleri","Dış Cephe Boya Sistemleri","Ahşap Boya & Vernikler","Metal Boya Sistemleri","Epoksi & Zemin Kaplamaları","Astar & Yüzey Hazırlık","Dekoratif Boyalar","Duvar Kağıdı & Efekt"],
    visual: "professional painter painting modern interior wall",
    imageFile: "boya-dekorasyon.jpg"
  },
  {
    slug: "cati-cephe-sistemleri",
    name: "Çatı & Cephe Sistemleri",
    shortName: "Çatı Cephe",
    heroTitle: "Çatı & Cephe Çözüm Ortakları",
    heroDesc: "çatı ve cephe yenileme projelerinde sistemlerinizi proje bazlı konumlayın",
    why: ["Çatı aktarım","Cephe kaplama","Sandviç panel","Oluk & izolasyon"],
    productAreas: ["Kiremit & Çatı","Sandviç Panel","Cephe Kaplama","Oluk & Dere","Çatı İzolasyon"],
    visual: "roof installation professional workers",
    imageFile: "cati-cephe-sistemleri.jpg"
  },
  {
    slug: "havuz-spa-sistemleri",
    name: "Havuz & Spa Sistemleri",
    shortName: "Havuz Spa",
    heroTitle: "Havuz & Spa Çözüm Ortakları",
    heroDesc: "havuz ve spa projelerinde ekipman ve kimyasallarınızı proje ihtiyacına dahil edin",
    why: ["Havuz yapımı","Bakım & kimyasal","Filtrasyon","Spa & sauna"],
    productAreas: ["Havuz Filtre & Pompa","Havuz Kaplama","Kimyasal & Bakım","Spa & Sauna"],
    visual: "luxury swimming pool construction",
    imageFile: "havuz-spa-sistemleri.jpg"
  },
  {
    slug: "isitma-sogutma-iklimlendirme",
    name: "Isıtma, Soğutma & İklimlendirme",
    shortName: "Isıtma Soğutma",
    heroTitle: "Isıtma & Soğutma Çözüm Ortakları",
    heroDesc: "kombi, klima ve iklimlendirme projelerinde ürünlerinizi ihtiyaç listesine dahil edin",
    why: ["Kombi montaj","Klima & VRF","Yerden ısıtma","Havalandırma"],
    productAreas: ["Kombi & Kazan","Klima & VRF","Yerden Isıtma","Radyatör & Vanalar","Havalandırma"],
    visual: "HVAC technician installing heat pump",
    imageFile: "isitma-sogutma-iklimlendirme.jpg"
  },
  {
    slug: "seramik-fayans-zemin",
    name: "Seramik, Fayans & Zemin",
    shortName: "Seramik Zemin",
    heroTitle: "Seramik & Zemin Çözüm Ortakları",
    heroDesc: "seramik ve zemin kaplama projelerinde koleksiyonlarınızı proje bazlı önerin",
    why: ["Banyo seramik","Mutfak seramik","Laminat & parke","Zemin kaplama"],
    productAreas: ["Banyo Seramiği","Mutfak Seramiği","Porselen & Granit","Laminat Parke","Lamine & Masif","Zemin Kaplama"],
    visual: "professional tiling, craftsman laying ceramic tiles",
    imageFile: "seramik-fayans-zemin.jpg"
  },
  {
    slug: "yalitim-izolasyon",
    name: "Yalıtım & İzolasyon",
    shortName: "Yalıtım",
    heroTitle: "Yalıtım & İzolasyon Çözüm Ortakları",
    heroDesc: "ısı ve su yalıtım projelerinde sistemlerinizi gerçek ihtiyaç anında konumlayın",
    why: ["Mantolama","Su yalıtımı","Ses yalıtımı","Temel & bodrum"],
    productAreas: ["Mantolama Sistemleri","Su Yalıtım","Isı Yalıtım Levha","Membran & Shingle","Ses Yalıtım"],
    visual: "exterior insulation installation",
    imageFile: "yalitim-izolasyon.jpg"
  },
  {
    slug: "cam-aluminyum-cephe-sistemleri",
    name: "Cam, Alüminyum & Cephe",
    shortName: "Cam Alüminyum",
    heroTitle: "Cam & Alüminyum Çözüm Ortakları",
    heroDesc: "cam balkon ve alüminyum cephe projelerinde sistemlerinizi proje bazlı dahil edin",
    why: ["Cam balkon","Giyotin cam","Alüminyum doğrama","Cephe sistemleri"],
    productAreas: ["Cam Balkon","Giyotin & Sürme","Alüminyum Doğrama","Cephe Sistemleri","Küpeşte & Korkuluk"],
    visual: "glass balcony installation, aluminum facade system",
    imageFile: "cam-aluminyum-cephe-sistemleri.jpg"
  },
  {
    slug: "yenilenebilir-enerji-guc-sistemleri",
    name: "Yenilenebilir Enerji & Güç",
    shortName: "Yenilenebilir Enerji",
    heroTitle: "Yenilenebilir Enerji Çözüm Ortakları",
    heroDesc: "GES, RES ve enerji depolama projelerinde sistemlerinizi B2B satış kanalına dahil edin",
    why: ["GES projeleri","Enerji depolama","Şarj istasyonu","Off-grid"],
    productAreas: ["GES Panel & İnverter","Enerji Depolama","EV Şarj","Offgrid Mobil","Rüzgar Sistemleri"],
    visual: "solar panel installation on roof",
    imageFile: "yenilenebilir-enerji-guc-sistemleri.jpg"
  },
  {
    slug: "celik-kapi-guvenlik-sistemleri",
    name: "Çelik Kapı & Güvenlik Sistemleri",
    shortName: "Çelik Kapı",
    heroTitle: "Çelik Kapı & Güvenlik Çözüm Ortakları",
    heroDesc: "çelik kapı ve güvenlik kilit projelerinde ürünlerinizi ihtiyaç anında projeyle buluşturun",
    why: ["Çelik kapı montaj","Güvenlik kilidi","Akıllı kilit","Yangın kapısı"],
    productAreas: ["Çelik Kapı","Yangın Kapısı","Akıllı Kilit","Çoklu Kilit Sistemi","Kapı Aksesuar"],
    visual: "modern anthracite steel security door with smart lock",
    imageFile: "celik-kapi-guvenlik-sistemleri.jpg"
  },
  {
    slug: "kapi-pencere-dograma",
    name: "Kapı, Pencere & Doğrama",
    shortName: "Kapı Pencere",
    heroTitle: "Kapı & Pencere Doğrama Çözüm Ortakları",
    heroDesc: "PVC, alüminyum doğrama ve pencere projelerinde sistemlerinizi proje bazlı dahil edin",
    why: ["PVC doğrama","Alüminyum doğrama","Sürme sistemler","Panjur & kepenk"],
    productAreas: ["PVC Pencere","Alüminyum Doğrama","Sürme Kapı","Cam Balkon Doğrama","Panjur Sistemleri"],
    visual: "PVC window and door installation",
    imageFile: "kapi-pencere-dograma.jpg"
  },
  {
    slug: "guvenlik-yangin-zayif-akim",
    name: "Güvenlik, Yangın & Zayıf Akım",
    shortName: "Güvenlik Yangın",
    heroTitle: "Güvenlik & Yangın Çözüm Ortakları",
    heroDesc: "güvenlik ve yangın algılama projelerinde sistemlerinizi proje bazlı konumlayın",
    why: ["Kamera sistemi","Yangın algılama","Alarm & geçiş","Zayıf akım"],
    productAreas: ["Kamera & Kayıt","Yangın Algılama","Alarm Sistemi","Interkom & Zil"],
    visual: "security camera installation",
    imageFile: "guvenlik-yangin-zayif-akim.jpg"
  },
  {
    slug: "asansor-yuruyen-merdiven-mekanik-tasima",
    name: "Asansör, Yürüyen Merdiven & Mekanik Taşıma",
    shortName: "Asansör",
    heroTitle: "Asansör Çözüm Ortakları",
    heroDesc: "asansör ve mekanik taşıma projelerinde sistemlerinizi B2B kanalına dahil edin",
    why: ["Asansör montaj","Bakım & revizyon","Yürüyen merdiven","Engelli platform"],
    productAreas: ["Asansör Kabin & Ray","Motor & Kumanda","Yürüyen Merdiven","Bakım & Yedek Parça"],
    visual: "elevator installation, modern elevator shaft",
    imageFile: "asansor-yuruyen-merdiven-mekanik-tasima.jpg"
  },
]

export async function generateStaticParams() {
  const out = []
  for (const city of cities) {
    if (city.slug === 'cozum-ortagi' || city.slug === 'cozum-ortakligi') continue
    for (const cat of hugCats) {
      out.push({ city: city.slug, category: cat.slug })
    }
  }
  return out
}

export async function generateMetadata({ params }: { params: Promise<{ city: string, category: string }> }) {
  const { city: citySlug, category: catSlug } = await params
  if (citySlug.includes('.') || catSlug.includes('.')) return {}
  if (citySlug === 'cozum-ortagi' || citySlug === 'cozum-ortakligi') return {}
  const city = cities.find(c => c.slug === citySlug)
  const cat = hugCats.find(c => c.slug === catSlug)
  if(!city ||!cat) return {}
  return {
    title: `${city.name} ${cat.name} Çözüm Ortakları | HUG MARKET`,
    description: `${city.name}'daki tadilat ve yenileme projelerinde ${cat.name.toLowerCase()} ürünlerinizi ihtiyaç anında doğru usta ve projeyle buluşturun. Kategori bazlı tek çözüm ortağı.`,
  }
}

export default async function Page({ params }: { params: Promise<{ city: string, category: string }> }) {
  const { city: citySlug, category: catSlug } = await params
  if (citySlug.includes('.') || catSlug.includes('.')) {
    const { notFound } = await import('next/navigation')
    notFound()
  }
  const city = cities.find(c => c.slug === citySlug)!
  const cat = hugCats.find(c => c.slug === catSlug)!

  const breadcrumbSchema = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com/" },
      { "@type": "ListItem", "position": 2, "name": "HUG MARKET", "item": "https://hemenustamgelsin.com/hug-market/" },
      { "@type": "ListItem", "position": 3, "name": `${city.name}`, "item": `https://hemenustamgelsin.com/hug-market/${city.slug}/` },
      { "@type": "ListItem", "position": 4, "name": `${cat.name}`, "item": `https://hemenustamgelsin.com/hug-market/${city.slug}/${cat.slug}/` }
    ]
  }

  return (
    <main className="bg-[#fcfcfa] text-zinc-900">
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />

      <div className="sticky top-0 z-30 bg-white/80 backdrop-blur-xl border-b border-zinc-100">
        <div className="max-w- mx-auto px-6 h- flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="flex items-center justify-center shrink-0" style={{ height: '36px' }}>
              <img src="/assets/hug/hug_logo.jpg" alt="HUG MARKET" style={{ height: '36px', width: 'auto', maxWidth: '180px', objectFit: 'contain', display: 'block' }} />
            </div>
            <div className="h-6 w-px bg-zinc-200 shrink-0" />
            <span className="text- font-semibold tracking-tight">Proje Odaklı Yapı Malzemeleri Ekosistemi</span>
          </div>
          <Link href="/hug-market/cozum-ortagi/" className="text- font-bold px-4 py-2 rounded-full bg-black text-white shrink-0">Çözüm Ortağı Ol</Link>
        </div>
      </div>

      <section className="max-w- mx-auto px-6 pt-6">
        <nav className="text- text-zinc-500 mb-4 flex gap-1 items-center flex-wrap">
          <Link href="/" className="hover:text-black">Ana Sayfa</Link><span>/</span>
          <Link href="/hug-market/" className="hover:text-black">HUG MARKET</Link><span>/</span>
          <Link href={`/hug-market/${city.slug}/`} className="hover:text-black">{city.name}</Link><span>/</span>
          <span className="text-zinc-900 font-medium">{cat.name}</span>
        </nav>
      </section>

      {/* PLAY BANNER - HUG MARKET */}
      <div className="max-w- mx-auto px-6">
        <div style={{background:'#111', borderRadius:12, padding:'12px 16px', display:'flex', justifyContent:'space-between', alignItems:'center', gap:12, flexWrap:'wrap'}}>
          <div style={{display:'flex', alignItems:'center', gap:12}}>
            <div style={{width:36, height:36, background:'#ff214f', borderRadius:8, display:'grid', placeItems:'center', fontSize:18, color:'white'}}>🛒</div>
            <div>
              <div style={{color:'white', fontWeight:800, fontSize:14}}>HUG MARKET uygulaması içinde! Hemen Ustam Gelsin'i indir</div>
              <div style={{color:'#a1a1aa', fontSize:12}}>{city.name} {cat.name} ürünlerini uygulama içinden yönet</div>
            </div>
          </div>
          <a href={PLAY_URL_HUG} target="_blank" rel="noopener" style={{background:'white', color:'black', padding:'10px 16px', borderRadius:10, fontWeight:800, fontSize:13, textDecoration:'none'}}> Google Play →</a>
        </div>
      </div>

      <section className="bg-[#0a0a0a] text-white relative overflow-hidden mt-6">
        <div className="max-w- mx-auto px-6 py-16 lg:py-24 grid lg:grid-cols-[1.1fr_0.9fr] gap-12 items-center">
          <div>
            <div className="inline-flex items-center rounded-full bg-[#1a0a0f] border border-[#2a1520] px-4 py-1.5 text- tracking-widest text-[#ff2a5a] uppercase font-bold">
              MARKANIZ İÇİN YENİ DİJİTAL KANAL • {city.name.toUpperCase()} • {cat.shortName.toUpperCase()}
            </div>
            <h1 className="mt-6 text- lg:text- leading-[0.9] font-black tracking-[-0.04em]">
              {city.name}’da<br />
              {cat.shortName}’ı<br />
              <span className="text-[#ff214f]">Doğru Proje</span> ile<br />
              Buluşturun
            </h1>
            <p className="mt-6 text- lg:text- leading-[1.6] text-zinc-400 max-w-">
              {city.name}’daki tadilat ve yenileme projelerinde {cat.heroDesc}. <span className="text-white">© HUG MARKET Çözüm Ortaklığı</span> ile markanız ihtiyaç anında, sahada ürünü kullanan usta ile buluşur. Reklam değil, ihtiyacın içinde yer alın.
            </p>
            <div className="mt-8 flex gap-3">
              <Link href="/hug-market/cozum-ortagi/" className="bg-[#ff214f] hover:bg-[#e01d46] text-white px-7 py-3.5 rounded-full text- font-bold transition">Çözüm Ortağı Ol</Link>
            </div>
          </div>

          <div className="relative">
            <div className="relative h- lg:h- rounded- overflow-hidden border border-white/10 bg-zinc-900">
              <img src={`/assets/hug/${cat.imageFile}`} alt={`${city.name} ${cat.name}`} className="w-full h-full object-cover" />
              <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/10 to-transparent" />
            </div>
          </div>
        </div>
      </section>

      <section className="max-w- mx-auto px-6 py-16">
        <div className="flex justify-between items-end">
          <div>
            <h2 className="text- lg:text- font-black tracking-tight">Neden bu kategori?</h2>
          </div>
        </div>
        <div className="mt-8 grid lg:grid-cols-4 gap-4">
          {cat.why.map((w, i) => (
            <div key={w} className="bg-white border border-zinc-100 rounded- p-6">
              <div className="w-10 h-10 bg-black rounded-xl flex items-center justify-center text-white font-black text-">0{i+1}</div>
              <div className="mt-4 font-bold text-">{w}</div>
            </div>
          ))}
        </div>
      </section>

      <section className="max-w- mx-auto px-6 pb-20">
        <div className="bg-black text-white rounded- p-10 lg:p-14 text-center relative overflow-hidden">
          <div className="relative">
            <h2 className="text- lg:text- font-black">Markanızı HUG MARKET’e Dahil Edin</h2>
            <div className="mt-6 flex gap-3 justify-center flex-wrap">
              <Link href="/hug-market/cozum-ortagi/" className="bg-white text-black px-10 py-4 rounded-full font-bold">ÇÖZÜM ORTAĞI BAŞVURUSU</Link>
              <a href={PLAY_URL_HUG} target="_blank" rel="noopener" className="bg-[#ff214f] text-white px-10 py-4 rounded-full font-bold">📱 UYGULAMAYI İNDİR</a>
            </div>
          </div>
        </div>
      </section>
    </main>
  )
}