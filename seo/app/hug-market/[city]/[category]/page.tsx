// app/hug-market/[city]/[category]/page.tsx - B2B LANDING AĞI FINAL - PREMIUM COZUM-ORTAGI STANDARTI
export const dynamic = 'force-static'
import { cities } from '../../../../data/cities'
import Link from 'next/link'

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
    slug: "dis-mekan-bahce",
    name: "Bahçe, Peyzaj & Dış Mekân",
    shortName: "Bahçe Peyzaj",
    heroTitle: "Bahçe & Peyzaj Çözüm Ortakları",
    heroDesc: "bahçe ve dış mekân projelerinde peyzaj ürünlerinizi proje bazlı satışa dahil edin",
    why: ["Peyzaj uygulamaları","Çim & sulama","Dış mekân zemin","Bahçe yapıları"],
    productAreas: ["Peyzaj Bitki","Çim & Toprak","Sulama Sistemleri","Dış Mekan Zemin","Bahçe Mobilyası","Traverten & Deck"],
    visual: "luxury villa garden with travertine patio and pergola",
    imageFile: "dis-mekan-bahce.jpg"
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
    for (const cat of hugCats) {
      out.push({ city: city.slug, category: cat.slug })
    }
  }
  return out
}

export async function generateMetadata({ params }: { params: Promise<{ city: string, category: string }> }) {
  const { city: citySlug, category: catSlug } = await params
  const city = cities.find(c => c.slug === citySlug)
  const cat = hugCats.find(c => c.slug === catSlug)
  if(!city || !cat) return {}
  return {
    title: `${city.name} ${cat.name} Çözüm Ortakları | HUG MARKET`,
    description: `${city.name}'daki tadilat ve yenileme projelerinde ${cat.name.toLowerCase()} ürünlerinizi ihtiyaç anında doğru usta ve projeyle buluşturun. Kategori bazlı tek çözüm ortağı.`,
  }
}

export default async function Page({ params }: { params: Promise<{ city: string, category: string }> }) {
  const { city: citySlug, category: catSlug } = await params
  const city = cities.find(c => c.slug === citySlug)!
  const cat = hugCats.find(c => c.slug === catSlug)!

  return (
    <main className="bg-[#fcfcfa] text-zinc-900">
      {/* TOP BAR - COZUM ORTAGI STANDARTI */}
      <div className="sticky top-0 z-30 bg-white/80 backdrop-blur-xl border-b border-zinc-100">
        <div className="max-w-[1280px] mx-auto px-6 h-[64px] flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 bg-black rounded-xl flex items-center justify-center text-white font-black text-[10px]">HUG</div>
            <div className="h-6 w-px bg-zinc-200" />
            <span className="text-[13px] font-semibold tracking-tight">Proje Odaklı Yapı Malzemeleri Ekosistemi</span>
          </div>
          <Link href="/hug-market/cozum-ortagi" className="text-[12px] font-bold px-4 py-2 rounded-full bg-black text-white">Çözüm Ortağı Ol</Link>
        </div>
      </div>

      {/* 1. HERO - SIYAH PREMIUM - COZUM ORTAGI ILE AYNI */}
      <section className="bg-[#0a0a0a] text-white relative overflow-hidden">
        <div className="max-w-[1280px] mx-auto px-6 py-16 lg:py-24 grid lg:grid-cols-[1.1fr_0.9fr] gap-12 items-center">
          <div>
            <div className="inline-flex items-center rounded-full bg-[#1a0a0f] border border-[#2a1520] px-4 py-1.5 text-[10px] tracking-widest text-[#ff2a5a] uppercase font-bold">
              MARKANIZ İÇİN YENİ DİJİTAL KANAL • {city.name.toUpperCase()} • {cat.shortName.toUpperCase()}
            </div>
            <h1 className="mt-6 text-[40px] lg:text-[64px] leading-[0.9] font-black tracking-[-0.04em]">
              {city.name}’da<br />
              {cat.shortName}’ı<br />
              <span className="text-[#ff214f]">Doğru Proje</span> ile<br />
              Buluşturun
            </h1>
            <p className="mt-6 text-[16px] lg:text-[18px] leading-[1.6] text-zinc-400 max-w-[520px]">
              {city.name}’daki tadilat ve yenileme projelerinde {cat.heroDesc}. <span className="text-white">© HUG MARKET Çözüm Ortaklığı</span> ile markanız ihtiyaç anında, sahada ürünü kullanan usta ile buluşur. Reklam değil, ihtiyacın içinde yer alın.
            </p>
            <div className="mt-8 flex gap-3">
              <Link href="/hug-market/cozum-ortagi" className="bg-[#ff214f] hover:bg-[#e01d46] text-white px-7 py-3.5 rounded-full text-[14px] font-bold transition">Çözüm Ortağı Ol</Link>
              <Link href={`/hug-market/${city.slug}`} className="border border-white/20 hover:bg-white/10 px-7 py-3.5 rounded-full text-[14px] font-bold transition">Markanızın Yolculuğu</Link>
            </div>
            <div className="mt-6 flex gap-2 text-[10px] tracking-widest uppercase text-zinc-500">
              <span className="bg-white/10 px-3 py-1 rounded-full">Kategori</span>
              <span className="bg-white/10 px-3 py-1 rounded-full">Ürün Entegrasyonu</span>
              <span className="bg-white/10 px-3 py-1 rounded-full">Proje Bazlı</span>
            </div>
          </div>

          {/* HERO IMAGE - KÜÇÜLTÜLMÜŞ, KONTROLLÜ - ASLA DEV DEĞİL */}
          <div className="relative">
            <div className="relative h-[380px] lg:h-[480px] rounded-[32px] overflow-hidden border border-white/10 bg-zinc-900">
              <img
                src={`/assets/hug/${cat.imageFile}`}
                alt={`${city.name} ${cat.name}`}
                className="w-full h-full object-cover"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/10 to-transparent" />
              <div className="absolute bottom-4 left-4 right-4 flex justify-between items-end">
                <div className="bg-black/60 backdrop-blur-md px-3 py-1.5 rounded-full text-[10px] tracking-widest uppercase text-white/80 border border-white/10">
                  GERÇEK PROJE • GERÇEK İHTİYAÇ • {cat.imageFile}
                </div>
                <div className="bg-white text-black px-3 py-1.5 rounded-full text-[11px] font-bold">HUG MARKET</div>
              </div>
            </div>
            {/* Glow */}
            <div className="absolute -inset-4 bg-[#ff214f]/20 blur-[60px] -z-10 rounded-[40px]" />
          </div>
        </div>
      </section>

      {/* 2. NEDEN BU KATEGORI - 4 KART PREMIUM */}
      <section className="max-w-[1280px] mx-auto px-6 py-16">
        <div className="flex justify-between items-end">
          <div>
            <h2 className="text-[28px] lg:text-[36px] font-black tracking-tight">Neden bu kategori?</h2>
            <p className="mt-2 text-zinc-500 text-[15px]">Reklam alanı değil, ürün ihtiyacının doğal parçası olun.</p>
          </div>
          <div className="hidden lg:block text-[12px] text-zinc-400">{city.name} • {cat.name} • 4 Temel Dinamik</div>
        </div>

        <div className="mt-8 grid lg:grid-cols-4 gap-4">
          {cat.why.map((w, i) => (
            <div key={w} className="bg-white border border-zinc-100 rounded-[20px] p-6 shadow-[0_1px_2px_rgba(0,0,0,0.04)] hover:shadow-[0_8px_24px_rgba(0,0,0,0.06)] transition">
              <div className="w-10 h-10 bg-black rounded-xl flex items-center justify-center text-white font-black text-[12px]">0{i+1}</div>
              <div className="mt-4 font-bold text-[16px]">{w}</div>
              <div className="mt-2 text-[13px] text-zinc-500 leading-[1.5]">Bu proje tipinde ustalar aktif olarak malzeme önerir, HUG MARKET tam bu anda devreye girer.</div>
              <div className="mt-4 text-[11px] tracking-widest uppercase text-zinc-400">© HUG MARKET • İhtiyaç Anı</div>
            </div>
          ))}
        </div>

        {/* Ticari Mantık Kutusu */}
        <div className="mt-6 bg-[#fff8e6] border border-amber-200 rounded-[20px] p-6 flex flex-col lg:flex-row gap-4 items-start">
          <div className="w-8 h-8 bg-amber-500 rounded-full flex items-center justify-center text-white font-bold text-[14px] shrink-0">!</div>
          <div>
            <div className="font-bold text-[14px]">Ürününüz ihtiyaç anında karşısına çıksın.</div>
            <div className="text-[13px] text-zinc-600 mt-1">Müşteri işini oluşturur → usta projeye dahil olur → HugAI ihtiyaç listesini oluşturur → HUG MARKET uygun ürünleri eşleştirir.</div>
            <div className="text-[11px] text-zinc-400 mt-2">Bu sayfanın ticari mantığı burada. Görsel referans: {cat.imageFile}</div>
          </div>
        </div>
      </section>

      {/* 3. KONUM & REKLAM DEGIL BANDI - 2'LI PREMIUM KART */}
      <section className="max-w-[1280px] mx-auto px-6 grid lg:grid-cols-2 gap-4">
        <div className="bg-white border border-zinc-100 rounded-[24px] p-8">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-black rounded-xl flex items-center justify-center">👁️</div>
            <div className="font-bold text-[18px]">İhtiyaç Anında Görünürlük</div>
          </div>
          <p className="mt-4 text-[14px] text-zinc-600 leading-[1.6]">Bir reklam alanında değil, gerçek bir işin içinde görünür olun. <span className="text-[#ff214f] font-bold">© HUG MARKET</span>’teki yolculuk, ürünle değil ihtiyaçla başlar.</p>
          <div className="mt-6 space-y-2">
            <div className="bg-[#f6f6f3] rounded-xl px-4 py-3 text-[13px] flex gap-2"><span className="text-zinc-400">•</span> Müşteri "{city.name} {cat.shortName}" için ilan açar</div>
            <div className="bg-[#f6f6f3] rounded-xl px-4 py-3 text-[13px] flex gap-2"><span className="text-zinc-400">•</span> Sistem proje kapsamını analiz eder</div>
            <div className="bg-[#f6f6f3] rounded-xl px-4 py-3 text-[13px] flex gap-2"><span className="text-zinc-400">•</span> Usta teklifiyle birlikte malzeme ihtiyacı netleşir</div>
            <div className="bg-black text-white rounded-xl px-4 py-3 text-[13px] flex gap-2"><span className="text-[#ff214f]">•</span> Sizin ürününüz o ihtiyaç listesinde önerilir</div>
          </div>
        </div>

        <div className="bg-black text-white rounded-[24px] p-8 relative overflow-hidden">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-white/10 rounded-xl flex items-center justify-center">⚙️</div>
            <div className="font-bold text-[18px]">Usta + Müşteri Eşleşmesi</div>
          </div>
          <p className="mt-4 text-[14px] text-zinc-400 leading-[1.6]"><span className="text-[#ff214f] font-bold">© Hemen Ustam Gelsin</span>’de müşteri işini oluşturur, usta teklifiyle projeye dahil olur. İş alındığında ise ihtiyaç duyulan ürünler ve malzemeler belirlenir.</p>
          <div className="mt-6 bg-white/5 border border-white/10 rounded-xl p-4 text-[13px] text-zinc-300">
            <span className="text-[#ff214f] font-bold">© HUG MARKET</span>, tam bu noktada devreye girerek projeyi, ustayı ve doğru ürünü aynı ekosistemde buluşturur. Böylece marka yalnızca ürünüyle değil, ürünü uygulayan usta ve gerçek proje üzerinden oluşan ihtiyaçla buluşur.
          </div>
          <div className="mt-8 inline-flex bg-[#ff214f] px-4 py-2 rounded-full text-[10px] font-bold tracking-widest uppercase">REKLAM DEĞİL, İHTİYAÇ EŞLEŞMESİ</div>
        </div>
      </section>

      {/* 4. NASIL CALISIR - 01-04 TIMELINE - COZUM ORTAGI ILE AYNI */}
      <section className="max-w-[1280px] mx-auto px-6 py-16">
        <h2 className="text-[28px] font-black tracking-tight">Markanızın Yolculuğu</h2>
        <p className="text-zinc-500 text-[14px] mt-1">Markanız © HUG MARKET’te bir reklam alanında değil, gerçek bir projenin ihtiyaç listesinde yer alır.</p>

        <div className="mt-10 grid lg:grid-cols-4 gap-6 relative">
          {/* çizgi */}
          <div className="hidden lg:block absolute top-[32px] left-[8%] right-[8%] h-px bg-zinc-200" />
          {[
            { n: "01", t: "İhtiyaç Doğar", sub: "- Müşteri", d: "Hemen Ustam Gelsin’de ilan oluşturulur" },
            { n: "02", t: "Eşleşme Olur", sub: "- Usta + Hemen Ustam Gelsin", d: "Ustalar bu ilana teklif verir" },
            { n: "03", t: "HugAI Sepeti Hazırlar", sub: "", d: "Projenin ihtiyaç listesi hazırlanır" },
            { n: "04", t: "HUG MARKET", sub: "Markayı Gösterir", d: "Ürününüz bu ihtiyacın içinde konumlanır" },
          ].map(s => (
            <div key={s.n} className="relative">
              <div className="w-[64px] h-[64px] bg-black text-white rounded-full flex items-center justify-center font-black text-[18px] border-4 border-white shadow-[0_0_0_1px_#eee]">{s.n}</div>
              <div className="mt-4 h-1 w-8 bg-[#ff214f] rounded-full" />
              <div className="mt-3 font-bold text-[15px]">{s.t}</div>
              <div className="text-[12px] text-zinc-500">{s.sub}</div>
              <div className="mt-2 text-[13px] text-zinc-600">{s.d}</div>
            </div>
          ))}
        </div>
      </section>

      {/* 5. IS BIRLIGI MODELLERI - SIYAH BANT */}
      <section className="bg-[#0a0a0a] text-white">
        <div className="max-w-[1280px] mx-auto px-6 py-16">
          <h2 className="text-[32px] font-black tracking-tight">İş Birliği Modelleri</h2>
          <p className="text-zinc-400 text-[14px] mt-2">Reklam değil, projenin içinde yer alın. Marka niyetine göre konumlanın.</p>

          <div className="mt-8 grid lg:grid-cols-3 gap-4">
            <div className="bg-white text-black rounded-[24px] p-7 border-2 border-[#ff214f] relative">
              <div className="flex justify-between items-start">
                <div className="text-[#ff214f] font-black text-[14px]">01</div>
                <div className="bg-[#ff214f] text-white text-[10px] font-bold px-2.5 py-1 rounded-full uppercase tracking-widest">POPÜLER</div>
              </div>
              <div className="mt-3 font-black text-[16px] uppercase">KATEGORİ LİDERLİĞİ</div>
              <div className="text-[12px] text-zinc-500">Kategori Sahipliği - En kapsamlı model</div>
              <div className="mt-6 space-y-3 text-[13px]">
                <div className="flex gap-2"><span className="text-[#ff214f]">✓</span> Kategori sahipliği & görünürlüğü</div>
                <div className="flex gap-2"><span className="text-[#ff214f]">✓</span> HugAI Sepet Entegrasyonu</div>
                <div className="flex gap-2"><span className="text-[#ff214f]">✓</span> Ürün görünürlüğü</div>
                <div className="flex gap-2"><span className="text-[#ff214f]">✓</span> Banner alanı</div>
              </div>
            </div>

            <div className="bg-white/[0.06] border border-white/10 rounded-[24px] p-7">
              <div className="text-[#ff214f] font-black text-[14px]">02</div>
              <div className="mt-3 font-black text-[16px] uppercase">PROJE & ÜRÜN ENTEGRASYONU</div>
              <div className="text-[12px] text-zinc-400">Satış odaklı - Projenin içinde yer alın</div>
              <div className="mt-6 space-y-3 text-[13px] text-zinc-300">
                <div className="flex gap-2"><span className="text-[#ff214f]">✓</span> HugAI Sepet Entegrasyonu</div>
                <div className="flex gap-2"><span className="text-[#ff214f]">✓</span> Proje bazlı ürün konumlandırması</div>
                <div className="flex gap-2"><span className="text-[#ff214f]">✓</span> Usta odaklı satış & prim</div>
              </div>
            </div>

            <div className="bg-white/[0.06] border border-white/10 rounded-[24px] p-7">
              <div className="text-[#ff214f] font-black text-[14px]">03</div>
              <div className="mt-3 font-black text-[16px] uppercase">MARKA & KAMPANYA GÖRÜNÜRLÜĞÜ</div>
              <div className="text-[12px] text-zinc-400">Bilinirlik odaklı - Premium görünürlük</div>
              <div className="mt-6 space-y-3 text-[13px] text-zinc-300">
                <div className="flex gap-2"><span className="text-[#ff214f]">✓</span> Ana sayfa görünürlüğü</div>
                <div className="flex gap-2"><span className="text-[#ff214f]">✓</span> HUG banner & kategori banner</div>
                <div className="flex gap-2"><span className="text-[#ff214f]">✓</span> Kampanya alanları & yönlendirmesi</div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* 6. URUN ALANLARI - PILLS */}
      <section className="max-w-[1280px] mx-auto px-6 py-16">
        <h2 className="text-[24px] font-black">{city.name} {cat.name} Ürün Alanları</h2>
        <div className="mt-6 grid lg:grid-cols-3 gap-3">
          {cat.productAreas.map(p => (
            <div key={p} className="bg-white border border-zinc-100 rounded-full px-5 py-3.5 text-[14px] flex justify-between items-center hover:bg-black hover:text-white transition cursor-pointer group">
              <span className="font-medium">{p}</span><span className="text-zinc-400 group-hover:text-white">→</span>
            </div>
          ))}
        </div>
      </section>

      {/* 7. HANGI KATEGORILER - PILL CLOUD - COZUM ORTAGI ILE AYNI */}
      <section className="max-w-[1280px] mx-auto px-6 pb-10">
        <h2 className="text-[20px] font-bold text-zinc-400">Hangi kategoriler?</h2>
        <div className="mt-4 flex flex-wrap gap-2">
          {hugCats.map(c => (
            <Link key={c.slug} href={`/hug-market/${city.slug}/${c.slug}`} className={`px-4 py-2 rounded-full border text-[13px] font-medium transition ${c.slug===cat.slug?'bg-black text-white border-black':'bg-[#f5f5f4] border-transparent hover:bg-black hover:text-white text-zinc-600'}`}>
              {c.name}
            </Link>
          ))}
        </div>
      </section>

      {/* 8. FINAL CTA - SIYAH DEV */}
      <section className="max-w-[1280px] mx-auto px-6 pb-20">
        <div className="bg-black text-white rounded-[32px] p-10 lg:p-14 text-center relative overflow-hidden">
          <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_0%,#ff214f22,transparent_60%)]" />
          <div className="relative">
            <h2 className="text-[36px] lg:text-[48px] font-black leading-[0.95] tracking-tight">Markanızı HUG<br/>MARKET’e Dahil Edin</h2>
            <p className="mt-4 text-zinc-400 max-w-2xl mx-auto text-[15px]">Ürünlerinizi gerçek projeler, profesyonel ustalar ve ihtiyaç bazlı satın alma akışıyla buluşturmak için çözüm ortaklığı başvurunuzu oluşturun.</p>
            <Link href="/hug-market/cozum-ortagi" className="mt-8 inline-block bg-white text-black px-10 py-4 rounded-full font-bold text-[14px] hover:bg-zinc-100 transition">ÇÖZÜM ORTAĞI BAŞVURUSU</Link>
            <div className="mt-6 text-[10px] tracking-[0.2em] text-zinc-500 uppercase">Kategori • Ürün Entegrasyonu • {cat.imageFile}</div>
          </div>
        </div>
      </section>
    </main>
  )
}
