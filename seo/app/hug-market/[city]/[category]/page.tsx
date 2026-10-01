// app/hug-market/[city]/[category]/page.tsx - B2B LANDING AĞI FINAL - RESİM İSİMLERİ İLE %100 UYUMLU
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
  imageFile: string // Gerçek dosya adı - slug ile birebir aynı!
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
    heroDesc: "teslim sonrası ve tadilat temizlik ihtiyaçlarında markanızı profesyonel akışa dahil edin - ENDÜSTRİYEL TEMİZLİK MAKİNELERİ",
    why: ["İnşaat sonrası temizlik","Sanayi tipi süpürme","Zemin cilalama","Endüstriyel vakum"],
    productAreas: ["İnşaat Sonrası Temizlik","Endüstriyel Süpürme Makinesi","Zemin Cilalama Makinesi","Sanayi Tipi Vakum","Kimyasal & Deterjan"],
    visual: "industrial cleaning machines, floor scrubber",
    imageFile: "temizlik-hijyen.jpg" // V2 ENDÜSTRİYEL MAKİNE OLAN!
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
    imageFile: "dis-mekan-bahce.jpg" // V2 EFSANE OLAN!
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
    imageFile: "yalitim-izolasyon.jpg" // (1) SİLİNDİ, DÜZGÜN İSİM!
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
  // ÇAKIŞMA ÇÖZÜLDÜ: 2 KAPI KATEGORİSİ AYRI AYRI!
  {
    slug: "celik-kapi-guvenlik-sistemleri",
    name: "Çelik Kapı & Güvenlik Sistemleri",
    shortName: "Çelik Kapı",
    heroTitle: "Çelik Kapı & Güvenlik Çözüm Ortakları",
    heroDesc: "çelik kapı ve güvenlik kilit projelerinde ürünlerinizi ihtiyaç anında projeyle buluşturun",
    why: ["Çelik kapı montaj","Güvenlik kilidi","Akıllı kilit","Yangın kapısı"],
    productAreas: ["Çelik Kapı","Yangın Kapısı","Akıllı Kilit","Çoklu Kilit Sistemi","Kapı Aksesuar"],
    visual: "modern anthracite steel security door with smart lock",
    imageFile: "celik-kapi-guvenlik-sistemleri.jpg" // V2 EFSANE OLAN!
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
    imageFile: "asansor-yuruyen-merdiven-mekanik-tasima.jpg" // KESİLMEDEN TAM İSİM!
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
    <main className="bg-[#fbfbf8] text-zinc-900">
      {/* 1. HERO - RESİM İSMİ %100 UYUMLU */}
      <section className="max-w-[1280px] mx-auto px-6 pt-10 pb-8 grid lg:grid-cols-[1.2fr_0.8fr] gap-8 items-center">
        <div>
          <div className="inline-flex items-center gap-2 text-[11px] tracking-widest uppercase bg-black text-white px-3 py-1 rounded-full">HUG MARKET • {city.name} • {cat.shortName}</div>
          <h1 className="mt-4 text-[36px] lg:text-[48px] leading-[0.95] font-black tracking-tight">{city.name} {cat.heroTitle}</h1>
          <p className="mt-4 text-[18px] leading-[1.5] text-zinc-600 max-w-[560px]">{city.name}'daki tadilat ve yenileme projelerinde {cat.heroDesc}.</p>
          <div className="mt-6 flex gap-3">
            <Link href="/hug-market/cozum-ortagi" className="bg-black text-white px-6 py-3 rounded-full text-sm font-semibold">Çözüm Ortağı Başvurusu →</Link>
            <Link href={`/hug-market/${city.slug}`} className="border border-zinc-300 px-6 py-3 rounded-full text-sm">{city.name} Kategorileri</Link>
          </div>
          <p className="mt-3 text-[11px] text-zinc-500">Kategori • Ürün Entegrasyonu • Kampanya • Proje Bazlı Satış</p>
        </div>
        <div className="relative h-[380px] bg-zinc-100 rounded-[24px] overflow-hidden border">
          {/* %100 UYUMLU - cat.imageFile kullanıyoruz, slug ile aynı! */}
          <img
            src={`/assets/hug/${cat.imageFile}`}
            alt={`${city.name} ${cat.name}`}
            className="w-full h-full object-cover absolute inset-0"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-black/10 to-transparent" />
          <div className="absolute bottom-0 p-4 z-10 text-white text-[12px] tracking-wide">Gerçek proje • Gerçek ihtiyaç • Gerçek usta • {cat.imageFile}</div>
        </div>
      </section>

      {/* 2. NEDEN BU KATEGORİ */}
      <section className="max-w-[1280px] mx-auto px-6 py-10 grid lg:grid-cols-2 gap-8">
        <div className="bg-white border rounded-[20px] p-7">
          <h2 className="text-[22px] font-bold">Neden bu kategori?</h2>
          <div className="mt-5 grid grid-cols-2 gap-3">
            {cat.why.map(w => (
              <div key={w} className="bg-[#f6f6f3] rounded-xl px-4 py-3 text-sm font-medium">{w}</div>
            ))}
          </div>
          <div className="mt-6 text-[14px] leading-6 text-zinc-600 bg-amber-50 border border-amber-200 rounded-xl p-4">
            <b>Ürününüz ihtiyaç anında karşısına çıksın.</b><br/>
            Müşteri işini oluşturur → usta projeye dahil olur → HugAI ihtiyaç listesini oluşturur → HUG MARKET uygun ürünleri eşleştirir.<br/>
            <span className="text-[12px] text-zinc-500">Bu sayfanın ticari mantığı burada. Resim: {cat.imageFile}</span>
          </div>
        </div>
        <div className="bg-black text-white rounded-[20px] p-7">
          <h3 className="text-[18px] font-bold">Bu kategoride ürününüzün konumlandığı an</h3>
          <ul className="mt-4 space-y-2 text-[14px] text-zinc-300">
            <li>• Müşteri "{city.name} {cat.shortName}" için ilan açar</li>
            <li>• Sistem proje kapsamını analiz eder</li>
            <li>• Usta teklifiyle birlikte malzeme ihtiyacı netleşir</li>
            <li>• Sizin ürününüz o ihtiyaç listesinde önerilir</li>
          </ul>
          <div className="mt-6 text-[12px] tracking-widest uppercase text-zinc-400">REKLAM DEĞİL, İHTİYAÇ EŞLEŞMESİ</div>
        </div>
      </section>

      {/* 3. NASIL ÇALIŞIR */}
      <section className="max-w-[1280px] mx-auto px-6 py-6">
        <h2 className="text-[26px] font-black">Nasıl çalışır?</h2>
        <div className="mt-6 grid lg:grid-cols-4 gap-4">
          {[
            { n: "01", t: "Proje Oluşur", d: "Müşteri yapılacak işi tanımlar." },
            { n: "02", t: "Usta Eşleşir", d: "Usta projeyi üstlenir." },
            { n: "03", t: "HugAI İhtiyacı Belirler", d: "Proje için gerekli malzeme listesi oluşturulur." },
            { n: "04", t: "Marka & Ürün Eşleşir", d: "HUG MARKET'teki uygun ürünler projeye dahil edilir." },
          ].map(s => (
            <div key={s.n} className="bg-white border rounded-[20px] p-6">
              <div className="text-[32px] font-black text-zinc-200">{s.n}</div>
              <div className="mt-2 font-bold">{s.t}</div>
              <div className="mt-1 text-sm text-zinc-600">{s.d}</div>
            </div>
          ))}
        </div>
      </section>

      {/* 4. MARKANIZ BURADA NE KAZANIYOR */}
      <section className="max-w-[1280px] mx-auto px-6 py-10">
        <h2 className="text-[26px] font-black">Markanız burada ne kazanıyor?</h2>
        <div className="mt-6 grid lg:grid-cols-4 gap-4">
          <div className="bg-white border rounded-[20px] p-6"><div className="font-bold">Gerçek İhtiyaç</div><div className="mt-2 text-sm text-zinc-600">Reklam gösterimi değil, gerçek proje ihtiyacı.</div></div>
          <div className="bg-white border rounded-[20px] p-6"><div className="font-bold">Usta Erişimi</div><div className="mt-2 text-sm text-zinc-600">Ürünü uygulayan profesyonelle aynı ekosistem.</div></div>
          <div className="bg-white border rounded-[20px] p-6"><div className="font-bold">Kategori Konumlandırması</div><div className="mt-2 text-sm text-zinc-600">Markanız ilgili ürün kategorisinde konumlanır.</div></div>
          <div className="bg-white border rounded-[20px] p-6"><div className="font-bold">Ölçülebilir Satış</div><div className="mt-2 text-sm text-zinc-600">Görüntüleme, etkileşim ve satış performansı takip edilebilir.</div></div>
        </div>
      </section>

      {/* 5. BU SAYFA NEDEN VAR */}
      <section className="max-w-[1280px] mx-auto px-6">
        <div className="bg-[#f0efe9] border rounded-[20px] p-7">
          <h3 className="font-bold">{city.name}'da kategori bazlı çözüm ortaklığı</h3>
          <p className="mt-2 text-sm text-zinc-600 max-w-3xl">HUG MARKET, yapı malzemeleri markalarını yalnızca reklam alanlarında değil, gerçek projelerin ürün ihtiyacında konumlandırmayı hedefler. Bu sayfa, <b>{city.name} + {cat.name}</b> odağında çözüm ortaklığı fırsatını tanımlar.</p>
        </div>
      </section>

      {/* 6. ÜRÜN ALANLARI */}
      <section className="max-w-[1280px] mx-auto px-6 py-10">
        <h2 className="text-[22px] font-bold">{cat.name} Ürün Alanları</h2>
        <div className="mt-4 grid lg:grid-cols-3 gap-3">
          {cat.productAreas.map(p => (
            <div key={p} className="bg-white border rounded-xl px-4 py-3 text-sm flex justify-between"><span>{p}</span><span className="text-zinc-400">→</span></div>
          ))}
        </div>
      </section>

      {/* 7. KATEGORİ LİDERİ */}
      <section className="max-w-[1280px] mx-auto px-6">
        <div className="bg-white border-2 border-black rounded-[24px] p-8 flex flex-col lg:flex-row justify-between items-start lg:items-center gap-4">
          <div><h3 className="text-[20px] font-black">Bu kategorinin çözüm ortağı olmak ister misiniz?</h3><p className="text-sm text-zinc-600 mt-1">HUG MARKET'te [{city.name} / {cat.name}] kategorisinde ürünlerinizi proje bazlı satış modeline dahil edin.</p></div>
          <Link href="/hug-market/cozum-ortagi" className="bg-black text-white px-6 py-3 rounded-full text-sm font-bold whitespace-nowrap">Çözüm Ortağı Başvurusu →</Link>
        </div>
      </section>

      {/* 8. ŞEHİR HUB */}
      <section className="max-w-[1280px] mx-auto px-6 py-10">
        <h3 className="font-bold">{city.name}'da HUG MARKET</h3>
        <div className="mt-4">
          <div className="text-[12px] uppercase tracking-widest text-zinc-500">{city.name}'da HUG MARKET Kategorileri ({hugCats.length} Kategori)</div>
          <div className="mt-3 flex flex-wrap gap-2">
            {hugCats.map(c => (
              <Link key={c.slug} href={`/hug-market/${city.slug}/${c.slug}`} className={`px-3 py-1.5 rounded-full border text-[13px] ${c.slug===cat.slug?'bg-black text-white border-black':'bg-white'}`}>{c.name}</Link>
            ))}
          </div>
        </div>
      </section>

      {/* 9. B2B CTA */}
      <section className="max-w-[1280px] mx-auto px-6 pb-16">
        <div className="bg-black text-white rounded-[32px] p-10 text-center">
          <h2 className="text-[32px] font-black leading-tight">Markanızı HUG MARKET'e Dahil Edin</h2>
          <p className="mt-3 text-zinc-300 max-w-2xl mx-auto">Ürünlerinizi gerçek projeler, profesyonel ustalar ve ihtiyaç bazlı satın alma akışıyla buluşturmak için çözüm ortaklığı başvurunuzu oluşturun.</p>
          <Link href="/hug-market/cozum-ortagi" className="mt-6 inline-block bg-white text-black px-8 py-3 rounded-full font-bold">ÇÖZÜM ORTAĞI BAŞVURUSU</Link>
          <div className="mt-4 text-[11px] tracking-widest text-zinc-500 uppercase">Kategori • Ürün Entegrasyonu • Kampanya • Proje Bazlı Satış • {cat.imageFile}</div>
        </div>
      </section>
    </main>
  )
}
