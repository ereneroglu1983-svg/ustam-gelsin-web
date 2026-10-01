// app/hug-market/cozum-ortagi/[category]/page.tsx - KATEGORİ ÇÖZÜM ORTAKLIĞI - 18 KATEGORİ - 81 ŞEHİR - FINAL + BREADCRUMB SCHEMA FIXED
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
  imageFile: string
  benefits: { title: string; desc: string }[]
}

const hugCats: HugCat[] = [
  {
    slug: "banyo-mutfak",
    name: "Banyo & Mutfak",
    shortName: "Banyo Mutfak",
    heroTitle: "Banyo & Mutfak Çözüm Ortakları",
    heroDesc: "banyo ve mutfak yenileme projelerinde ürünlerinizi ihtiyaç anında projeyle buluşturun, usta ve müşteri aynı ekosistemde",
    why: ["Mutfak dolabı montajı ve yenileme","Banyo dolabı, tezgah ve lavabo entegrasyonu","Seramik ve vitrifiye ile uyumlu sistem","Ankastre ve aksesuar eşleşmesi"],
    productAreas: ["Mutfak Dolabı Sistemleri","Banyo Dolabı ve Lavabo","Tezgah ve Eviye Sistemleri","Duvar ve Zemin Seramiği","Batarya ve Vitrifiye","Aksesuar ve Aydınlatma"],
    imageFile: "banyo-mutfak.jpg",
    benefits: [
      { title: "Gerçek Proje İhtiyacı", desc: "Reklam gösterimi değil, banyo mutfak yenileme anında ihtiyaç listesinde" },
      { title: "Usta ve Montaj Erişimi", desc: "Ürünü uygulayan profesyonel usta ile aynı platform" }
    ]
  },
  {
    slug: "temizlik-hijyen",
    name: "Temizlik & Hijyen",
    shortName: "Temizlik",
    heroTitle: "Temizlik & Hijyen Çözüm Ortakları",
    heroDesc: "teslim sonrası ve tadilat temizlik ihtiyaçlarında endüstriyel temizlik makineleri ve hijyen sistemlerinizi profesyonel akışa dahil edin",
    why: ["İnşaat sonrası ve tadilat sonrası derin temizlik","Sanayi tipi süpürme ve cilalama makineleri","Endüstriyel vakum ve zemin bakım","Hijyenik alan ve profesyonel kitler"],
    productAreas: ["İnşaat Sonrası Temizlik Sistemleri","Endüstriyel Süpürme Makineleri","Zemin Cilalama ve Bakım Makineleri","Sanayi Tipi Vakum Sistemleri","Hijyen ve Kimyasal Sistemler"],
    imageFile: "temizlik-hijyen.jpg",
    benefits: [
      { title: "Teslimat Anında Konumlanma", desc: "Tadilat bitiminde temizlik ihtiyacı doğar, ürününüz orada" },
      { title: "Endüstriyel Kanal", desc: "Sanayi tipi makineler için B2B profesyonel akış" }
    ]
  },
  {
    slug: "elektrik-aydinlatma",
    name: "Elektrik & Aydınlatma",
    shortName: "Elektrik",
    heroTitle: "Elektrik & Aydınlatma Çözüm Ortakları",
    heroDesc: "elektrik tesisatı ve aydınlatma projelerinde ürünlerinizi doğru usta ve proje ile buluşturun",
    why: ["Tesisat yenileme ve pano değişimi","Aydınlatma tasarımı ve armatür seçimi","Akıllı ev ve otomasyon sistemleri","Sigorta, kablo ve anahtar priz"],
    productAreas: ["Kablo ve Tesisat Sistemleri","Anahtar Priz Sistemleri","Aydınlatma Armatürleri","Spot ve LED Sistemleri","Akıllı Ev Sistemleri","Sigorta ve Pano Sistemleri"],
    imageFile: "elektrik-aydinlatma.jpg",
    benefits: [
      { title: "Teknik Eşleşme", desc: "Elektrik projesi + usta + malzeme üçlü eşleşmesi" },
      { title: "Akıllı Ev Trendi", desc: "Geleceğin projelerinde markanız konumlanır" }
    ]
  },
  {
    slug: "hirdavat-el-aletleri-is-guvenligi",
    name: "Hırdavat, El Aletleri & İş Güvenliği",
    shortName: "Hırdavat",
    heroTitle: "Hırdavat & İş Güvenliği Çözüm Ortakları",
    heroDesc: "tadilat ve yapı projelerinde kullanılan hırdavat ve iş güvenliği ürünlerinizi marka bazlı konumlayın",
    why: ["Her projede zorunlu ihtiyaç","Usta sadakati ve marka bağı yüksek","Sarf malzeme ve ekipman sürekliliği","İş güvenliği zorunluluğu ve denetim"],
    productAreas: ["El Aletleri","Elektrikli El Aletleri","İş Güvenliği Ekipmanları","Bağlantı Elemanları","Silikon ve Yapıştırıcılar"],
    imageFile: "hirdavat-el-aletleri-is-guvenligi.jpg",
    benefits: [
      { title: "Proje Genelinde Kullanım", desc: "Tadilat projelerinde sık karşılaşılan hırdavat ve sarf ihtiyaçları" },
      { title: "Usta Tercihi", desc: "Profesyonel ustaların ürün tercihlerinde marka deneyimi önemli bir rol oynar" }
    ]
  },
  {
    slug: "bahce-peyzaj-dis-mekan",
    name: "Bahçe, Peyzaj & Dış Mekân",
    shortName: "Bahçe Peyzaj",
    heroTitle: "Bahçe & Peyzaj Çözüm Ortakları",
    heroDesc: "bahçe ve dış mekân projelerinde peyzaj ürünlerinizi proje bazlı satışa dahil edin, traverten ve pergola sistemleri",
    why: ["Villa ve konut peyzaj uygulamaları","Çim ekimi ve otomatik sulama sistemleri","Traverten, deck ve dış mekân zemin","Pergola, bahçe yapıları ve mobilyalar"],
    productAreas: ["Peyzaj Bitki ve Toprak","Çim ve Sulama Sistemleri","Traverten ve Dış Zemin","Deck ve Ahşap Zemin","Bahçe Mobilyası ve Pergola","Dış Aydınlatma"],
    imageFile: "bahce-peyzaj-dis-mekan.jpg",
    benefits: [
      { title: "Geniş Kapsamlı Proje", desc: "Bahçe ve dış mekan projelerinde zemin ve peyzaj ihtiyaçları" },
      { title: "Görsel Konumlanma", desc: "Konut ve villa projelerinde dış mekan çözümleriyle görünürlük" }
    ]
  },
  {
    slug: "tesisat-su-sistemleri",
    name: "Tesisat & Su Sistemleri",
    shortName: "Tesisat",
    heroTitle: "Tesisat & Su Sistemleri Çözüm Ortakları",
    heroDesc: "sıhhi tesisat ve su sistemleri projelerinde ürünlerinizi ihtiyaç anında projeye dahil edin",
    why: ["Sıhhi tesisat ve pis su tesisatı yenileme","Temiz su, boru ve ek parça sistemleri","Batarya, musluk ve rezervuar değişimi","Su yalıtımı ve arıtma sistemleri"],
    productAreas: ["Boru ve Ek Parça Sistemleri","Batarya ve Musluk Sistemleri","Rezervuar ve Klozet İçi","Su Arıtma Sistemleri","Pis Su ve Gider Sistemleri","Yalıtım ve Conta Sistemleri"],
    imageFile: "tesisat-su-sistemleri.jpg",
    benefits: [
      { title: "Proje Odaklı İhtiyaç", desc: "Sıhhi tesisat ve su sistemleri yenileme projelerinde ürün konumlama" },
      { title: "Teknik Eşleşme", desc: "Usta ve proje ihtiyaçlarına göre ürün önerisi" }
    ]
  },
  {
    slug: "yapi-malzemeleri-insaat",
    name: "Yapı Malzemeleri & İnşaat",
    shortName: "Yapı Malzemeleri",
    heroTitle: "Yapı Malzemeleri Çözüm Ortakları",
    heroDesc: "yapı ve inşaat projelerinde malzemelerinizi gerçek ihtiyaç listesine dahil edin",
    why: ["Kaba inşaat ve ince inşaat malzemeleri","Alçı, sıva ve saten uygulamaları","Yapı kimyasalları ve harç sistemleri","Tuğla, blok, demir ve profil"],
    productAreas: ["Alçı ve Sıva Sistemleri","Çimento ve Harç Sistemleri","Yapı Kimyasalları","Tuğla ve Blok Sistemleri","Demir ve Profil Sistemleri"],
    imageFile: "yapi-malzemeleri-insaat.jpg",
    benefits: [
      { title: "Geniş Ürün Yelpazesi", desc: "Kaba ve ince inşaat uygulamalarında malzeme ihtiyaçları" },
      { title: "Proje Bazlı Kullanım", desc: "Farklı ölçeklerdeki yapı projelerinde ürün konumlama" }
    ]
  },
  {
    slug: "boya-dekorasyon",
    name: "Boya & Dekorasyon",
    shortName: "Boya Dekorasyon",
    heroTitle: "Boya & Dekorasyon Çözüm Ortakları",
    heroDesc: "tadilat ve yenileme projelerinde boya ve dekorasyon ürünlerinizi ihtiyaç anında doğru usta ve projeyle buluşturun",
    why: ["İç cephe boya ve dekoratif uygulamalar","Dış cephe boya ve mantolama üstü","Yüzey hazırlığı, astar ve zımpara","Duvar kağıdı, efekt ve İtalyan boya"],
    productAreas: ["İç Cephe Boya Sistemleri","Dış Cephe Boya Sistemleri","Ahşap Boya ve Vernikler","Metal Boya Sistemleri","Epoksi ve Zemin Kaplamaları","Astar ve Yüzey Hazırlık","Dekoratif Boyalar","Duvar Kağıdı ve Efekt"],
    imageFile: "boya-dekorasyon.jpg",
    benefits: [
      { title: "Proje Finali Konumlanması", desc: "Tadilat ve yenileme projelerinde boya ihtiyacı oluştuğunda markanızın konumlanması" },
      { title: "Renk ve Uygulama", desc: "İç ve dış cephe boya projelerinde ürün ve uygulama eşleşmesi" }
    ]
  },
  {
    slug: "cati-cephe-sistemleri",
    name: "Çatı & Cephe Sistemleri",
    shortName: "Çatı Cephe",
    heroTitle: "Çatı & Cephe Çözüm Ortakları",
    heroDesc: "çatı ve cephe yenileme projelerinde sistemlerinizi proje bazlı konumlayın",
    why: ["Çatı aktarım ve kiremit yenileme","Cephe kaplama ve sandviç panel","Oluk, dere ve izolasyon sistemleri","Çatı penceresi ve havalandırma"],
    productAreas: ["Kiremit ve Çatı Sistemleri","Sandviç Panel Sistemleri","Cephe Kaplama Sistemleri","Oluk ve Dere Sistemleri","Çatı İzolasyon Sistemleri"],
    imageFile: "cati-cephe-sistemleri.jpg",
    benefits: [
      { title: "Sistem Satışı", desc: "Tek ürün yerine komple sistem çözümüyle konumlanma" },
      { title: "Proje Kapsamı", desc: "Çatı ve cephe yenileme projelerinde ürün ve sistem ihtiyaçları" }
    ]
  },
  {
    slug: "havuz-spa-sistemleri",
    name: "Havuz & Spa Sistemleri",
    shortName: "Havuz Spa",
    heroTitle: "Havuz & Spa Çözüm Ortakları",
    heroDesc: "havuz ve spa projelerinde ekipman ve kimyasallarınızı proje ihtiyacına dahil edin",
    why: ["Havuz yapımı ve kaplama","Bakım, kimyasal ve temizlik","Filtrasyon, pompa ve tesisat","Spa, sauna ve buhar odası"],
    productAreas: ["Havuz Filtre ve Pompa Sistemleri","Havuz Kaplama Sistemleri","Kimyasal ve Bakım Ürünleri","Spa ve Sauna Sistemleri"],
    imageFile: "havuz-spa-sistemleri.jpg",
    benefits: [
      { title: "Proje ve Bakım", desc: "Havuz ve spa projelerinde yapım ve bakım ihtiyaçları" },
      { title: "Ekipman Konumlama", desc: "Filtrasyon, pompa ve kimyasal ürün gruplarında proje bazlı eşleşme" }
    ]
  },
  {
    slug: "isitma-sogutma-iklimlendirme",
    name: "Isıtma, Soğutma & İklimlendirme",
    shortName: "Isıtma Soğutma",
    heroTitle: "Isıtma & Soğutma Çözüm Ortakları",
    heroDesc: "kombi, klima ve iklimlendirme projelerinde ürünlerinizi ihtiyaç listesine dahil edin",
    why: ["Kombi montaj ve bakım","Klima ve VRF sistemleri","Yerden ısıtma ve radyatör","Havalandırma ve aspiratör"],
    productAreas: ["Kombi ve Kazan Sistemleri","Klima ve VRF Sistemleri","Yerden Isıtma Sistemleri","Radyatör ve Vana Sistemleri","Havalandırma Sistemleri"],
    imageFile: "isitma-sogutma-iklimlendirme.jpg",
    benefits: [
      { title: "Mevsimsel İhtiyaç", desc: "Isıtma ve soğutma projelerinde dönemsel talep" },
      { title: "Proje Bazlı Değişim", desc: "Kombi, klima ve iklimlendirme yenileme projelerinde ürün konumlama" }
    ]
  },
  {
    slug: "seramik-fayans-zemin",
    name: "Seramik, Fayans & Zemin",
    shortName: "Seramik Zemin",
    heroTitle: "Seramik & Zemin Çözüm Ortakları",
    heroDesc: "seramik ve zemin kaplama projelerinde koleksiyonlarınızı proje bazlı önerin",
    why: ["Banyo ve mutfak seramik yenileme","Porselen, granit ve büyük ebat","Laminat, lamine ve masif parke","Epoksi ve vinil zemin kaplama"],
    productAreas: ["Banyo Seramiği ve Fayans","Mutfak Seramiği ve Tezgah Arası","Porselen ve Granit Sistemleri","Laminat Parke Sistemleri","Lamine ve Masif Parke","Zemin Kaplama ve Süpürgelik"],
    imageFile: "seramik-fayans-zemin.jpg",
    benefits: [
      { title: "Koleksiyon Konumlama", desc: "Seramik ve zemin koleksiyonlarının proje bazlı önerisi" },
      { title: "Görsel Eşleşme", desc: "Banyo ve mutfak yenileme projelerinde ürün görselliğiyle konumlanma" }
    ]
  },
  {
    slug: "yalitim-izolasyon",
    name: "Yalıtım & İzolasyon",
    shortName: "Yalıtım",
    heroTitle: "Yalıtım & İzolasyon Çözüm Ortakları",
    heroDesc: "ısı ve su yalıtım projelerinde sistemlerinizi gerçek ihtiyaç anında konumlayın",
    why: ["Mantolama ve dış cephe ısı yalıtımı","Su yalıtımı ve temel bodrum","Ses yalıtımı ve akustik","Çatı ve teras izolasyonu"],
    productAreas: ["Mantolama Sistemleri","Su Yalıtım Sistemleri","Isı Yalıtım Levha Sistemleri","Membran ve Shingle","Ses Yalıtım Sistemleri"],
    imageFile: "yalitim-izolasyon.jpg",
    benefits: [
      { title: "Enerji Verimliliği", desc: "Isı ve su yalıtım projelerinde enerji verimliliği odaklı konumlama" },
      { title: "Proje Gereksinimleri", desc: "Mantolama ve yalıtım uygulamalarında teknik ihtiyaçlara göre eşleşme" }
    ]
  },
  {
    slug: "cam-aluminyum-cephe-sistemleri",
    name: "Cam, Alüminyum & Cephe",
    shortName: "Cam Alüminyum",
    heroTitle: "Cam & Alüminyum Çözüm Ortakları",
    heroDesc: "cam balkon ve alüminyum cephe projelerinde sistemlerinizi proje bazlı dahil edin",
    why: ["Cam balkon ve giyotin sistemleri","Sürme ve katlanır cam sistemleri","Alüminyum doğrama ve cephe","Küpeşte, korkuluk ve aksesuar"],
    productAreas: ["Cam Balkon Sistemleri","Giyotin ve Sürme Sistemler","Alüminyum Doğrama Sistemleri","Cephe Sistemleri","Küpeşte ve Korkuluk Sistemleri"],
    imageFile: "cam-aluminyum-cephe-sistemleri.jpg",
    benefits: [
      { title: "Modern Yapı Uygulamaları", desc: "Cam balkon ve alüminyum doğrama projelerinde sistem konumlama" },
      { title: "Sistem Bütünlüğü", desc: "Cam, profil ve aksesuar entegrasyonuyla proje bazlı eşleşme" }
    ]
  },
  {
    slug: "yenilenebilir-enerji-guc-sistemleri",
    name: "Yenilenebilir Enerji & Güç",
    shortName: "Yenilenebilir Enerji",
    heroTitle: "Yenilenebilir Enerji Çözüm Ortakları",
    heroDesc: "GES, RES ve enerji depolama projelerinde sistemlerinizi B2B satış kanalına dahil edin",
    why: ["GES çatı ve arazi projeleri","Enerji depolama ve batarya sistemleri","EV şarj istasyonu kurulumu","Off-grid ve mobil enerji"],
    productAreas: ["GES Panel ve İnverter Sistemleri","Enerji Depolama Sistemleri","EV Şarj İstasyonları","Offgrid Mobil Sistemler","Rüzgar ve Hibrit Sistemler"],
    imageFile: "yenilenebilir-enerji-guc-sistemleri.jpg",
    benefits: [
      { title: "Büyüyen Pazar", desc: "Yenilenebilir enerji ve enerji depolama çözümlerinde proje bazlı satış fırsatı" },
      { title: "Proje ve Teşvik Uyumlu", desc: "GES ve enerji depolama projelerinde sistem ve teşvik süreçlerine göre konumlama" }
    ]
  },
  {
    slug: "kapi-kilit-gecis-kontrol",
    name: "Kapı, Kilit & Geçiş Kontrol",
    shortName: "Kapı Kilit",
    heroTitle: "Kapı & Kilit Çözüm Ortakları",
    heroDesc: "kapı ve geçiş kontrol projelerinde ürünlerinizi ihtiyaç anında projeyle buluşturun, çelik kapı ve akıllı kilit sistemleri",
    why: ["Çelik kapı montaj ve yenileme","Oda kapısı ve iç kapı sistemleri","Kilit, kolu ve akıllı kilit","Geçiş kontrol ve kartlı sistem"],
    productAreas: ["Çelik Kapı Sistemleri","Oda Kapısı Sistemleri","Kilit ve Kolu Sistemleri","Geçiş Kontrol Sistemleri","Kapı Aksesuar ve Hidrolik"],
    imageFile: "kapi-kilit-gecis-kontrol.jpg",
    benefits: [
      { title: "Güvenlik ve Erişim", desc: "Kapı ve geçiş kontrol projelerinde güvenlik ihtiyaçlarına göre konumlama" },
      { title: "Akıllı Sistem Entegrasyonu", desc: "Akıllı kilit ve geçiş kontrol çözümlerinde proje bazlı eşleşme" }
    ]
  },
  {
    slug: "guvenlik-yangin-zayif-akim",
    name: "Güvenlik, Yangın & Zayıf Akım",
    shortName: "Güvenlik Yangın",
    heroTitle: "Güvenlik & Yangın Çözüm Ortakları",
    heroDesc: "güvenlik ve yangın algılama projelerinde sistemlerinizi proje bazlı konumlayın",
    why: ["Kamera ve kayıt sistemleri","Yangın algılama ve söndürme","Alarm ve geçiş kontrol","Interkom, zil ve zayıf akım"],
    productAreas: ["Kamera ve Kayıt Sistemleri","Yangın Algılama Sistemleri","Alarm ve Güvenlik Sistemleri","Interkom ve Zil Sistemleri","Zayıf Akım Altyapı"],
    imageFile: "guvenlik-yangin-zayif-akim.jpg",
    benefits: [
      { title: "Proje Gereksinimleri", desc: "Yangın ve güvenlik sistemlerinde proje ve mevzuat gereksinimlerine göre ürün konumlama" },
      { title: "Sistem ve Bakım", desc: "Kamera, kayıt ve güvenlik sistemlerinde kurulum ve bakım ihtiyaçları" }
    ]
  },
  {
    slug: "asansor-yuruyen-merdiven",
    name: "Asansör & Yürüyen Merdiven",
    shortName: "Asansör",
    heroTitle: "Asansör Çözüm Ortakları",
    heroDesc: "asansör ve mekanik taşıma projelerinde sistemlerinizi B2B kanalına dahil edin",
    why: ["Asansör montaj ve modernizasyon","Bakım, revizyon ve yedek parça","Yürüyen merdiven ve bant","Engelli platform ve asansörü"],
    productAreas: ["Asansör Kabin ve Ray Sistemleri","Motor ve Kumanda Sistemleri","Yürüyen Merdiven Sistemleri","Bakım ve Yedek Parça"],
    imageFile: "asansor-yuruyen-merdiven.jpg",
    benefits: [
      { title: "Proje ve Bakım", desc: "Montaj, modernizasyon, bakım ve yedek parça ihtiyaçlarında ürün konumlama" },
      { title: "Sistem ve Bileşen", desc: "Asansör ve mekanik taşıma sistemlerinde proje bazlı eşleşme" }
    ]
  },
]

export async function generateStaticParams() {
  return hugCats.map(c => ({ category: c.slug }))
}

export async function generateMetadata({ params }: { params: Promise<{ category: string }> }) {
  const { category: catSlug } = await params
  const cat = hugCats.find(c => c.slug === catSlug)
  if(!cat) return {}
  return {
    title: `${cat.name} Çözüm Ortaklığı | HUG MARKET Kategori Lideri - 81 İl`,
    description: `${cat.name.toLowerCase()} markaları için HUG MARKET çözüm ortaklığı. 81 ilde ${cat.productAreas.slice(0,3).join(', ').toLowerCase()} projelerinde ürünlerinizi ihtiyaç anında doğru usta ve projeyle buluşturun. Kategori bazlı tek çözüm ortağı.`,
  }
}

export default async function CategoryPartnershipPage({ params }: { params: Promise<{ category: string }> }) {
  const { category: catSlug } = await params
  const cat = hugCats.find(c => c.slug === catSlug)!

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
        "item": "https://hemenustamgelsin.com/hug-market"
      },
      {
        "@type": "ListItem",
        "position": 3,
        "name": "Çözüm Ortaklığı",
        "item": "https://hemenustamgelsin.com/hug-market/cozum-ortagi"
      },
      {
        "@type": "ListItem",
        "position": 4,
        "name": `${cat.name}`,
        "item": `https://hemenustamgelsin.com/hug-market/cozum-ortagi/${cat.slug}`
      }
    ]
  }

  return (
    <main className="bg-[#fbfbf8] text-zinc-900">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }}
      />

      {/* 1. HERO */}
      <section className="max-w- mx-auto px-6 pt-10 pb-8 grid lg:grid-cols-[1.2fr_0.8fr] gap-8 items-center">
        <div>
          <nav className="text- text-zinc-500 mb-4 flex gap-1 items-center flex-wrap">
            <Link href="/" className="hover:text-black">Ana Sayfa</Link>
            <span>/</span>
            <Link href="/hug-market" className="hover:text-black">HUG MARKET</Link>
            <span>/</span>
            <Link href="/hug-market/cozum-ortagi" className="hover:text-black">Çözüm Ortaklığı</Link>
            <span>/</span>
            <span className="text-zinc-900 font-medium">{cat.name}</span>
          </nav>
          <div className="inline-flex items-center gap-2 text- tracking-widest uppercase bg-black text-white px-3 py-1 rounded-full">HUG MARKET • {cat.shortName} • 81 İL</div>
          <h1 className="mt-4 text- lg:text- leading-[0.95] font-black tracking-tight">{cat.heroTitle}</h1>
          <p className="mt-4 text- leading-[1.5] text-zinc-600 max-w-">{cat.heroDesc}.</p>
          <div className="mt-6 flex gap-3">
            <Link href="/hug-market/cozum-ortagi" className="bg-black text-white px-6 py-3 rounded-full text-sm font-semibold">Çözüm Ortağı Başvurusu →</Link>
            <Link href="/hug-market" className="border border-zinc-300 px-6 py-3 rounded-full text-sm">Tüm Kategoriler</Link>
          </div>
          <p className="mt-3 text- text-zinc-500">Kategori • Ürün Entegrasyonu • 81 İl • Proje Bazlı Satış</p>
        </div>
        <div className="relative h- bg-zinc-100 rounded- overflow-hidden border">
          <img src={`/assets/hug/${cat.imageFile}`} alt={cat.name} className="w-full h-full object-cover absolute inset-0" />
          <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-black/10 to-transparent" />
          <div className="absolute bottom-0 p-4 z-10 text-white text- tracking-wide">Gerçek proje • Gerçek ihtiyaç • 81 il • {cat.name}</div>
        </div>
      </section>

      {/* 2. NEDEN BU KATEGORİ */}
      <section className="max-w- mx-auto px-6 py-10 grid lg:grid-cols-2 gap-8">
        <div className="bg-white border rounded- p-7">
          <h2 className="text- font-bold">Neden {cat.name} kategorisi?</h2>
          <div className="mt-5 grid grid-cols-2 gap-3">
            {cat.why.map(w => (
              <div key={w} className="bg-[#f6f6f3] rounded-xl px-4 py-3 text-sm font-medium">{w}</div>
            ))}
          </div>
          <div className="mt-6 text- leading-6 text-zinc-600 bg-amber-50 border border-amber-200 rounded-xl p-4">
            <b>Ürününüz ihtiyaç anında karşısına çıksın.</b><br/>
            Müşteri işini oluşturur → usta projeye dahil olur → HugAI ihtiyaç listesini oluşturur → HUG MARKET uygun ürünleri eşleştirir.<br/>
            <span className="text- text-zinc-500">81 ilde aynı ticari mantık çalışır.</span>
          </div>
        </div>
        <div className="bg-black text-white rounded- p-7">
          <h3 className="text- font-bold">Markanız burada ne kazanıyor?</h3>
          <div className="mt-5 space-y-4">
            {cat.benefits.map(b => (
              <div key={b.title} className="border-b border-white/10 pb-4 last:border-0">
                <div className="font-bold text-">{b.title}</div>
                <div className="text- text-zinc-400 mt-1">{b.desc}</div>
              </div>
            ))}
          </div>
          <ul className="mt-6 space-y-2 text- text-zinc-300">
            <li>• 81 ilde proje eşleşmesi</li>
            <li>• Gerçek ihtiyaç anında konumlanma</li>
            <li>• Proje ihtiyacı oluştuğunda ürün konumlanması</li>
          </ul>
          <div className="mt-6 text- tracking-widest uppercase text-zinc-400">REKLAM DEĞİL, İHTİYAÇ EŞLEŞMESİ</div>
        </div>
      </section>

      {/* 3. NASIL ÇALIŞIR */}
      <section className="max-w- mx-auto px-6 py-6">
        <h2 className="text- font-black">Nasıl çalışır?</h2>
        <div className="mt-6 grid lg:grid-cols-4 gap-4">
          {[
            { n: "01", t: "Proje Oluşur", d: "Müşteri 81 ilden birinde işini tanımlar." },
            { n: "02", t: "Usta Eşleşir", d: "O şehirdeki uzman usta projeyi üstlenir." },
            { n: "03", t: "HugAI İhtiyacı Belirler", d: "Proje için gerekli malzeme listesi oluşturulur." },
            { n: "04", t: "Marka & Ürün Eşleşir", d: `${cat.name} kategorisindeki ihtiyaç, çözüm ortağı ürünleriyle eşleştirilir.` },
          ].map(s => (
            <div key={s.n} className="bg-white border rounded- p-6">
              <div className="text- font-black text-zinc-200">{s.n}</div>
              <div className="mt-2 font-bold">{s.t}</div>
              <div className="mt-1 text-sm text-zinc-600">{s.d}</div>
            </div>
          ))}
        </div>
      </section>

      {/* 4. ÜRÜN ALANLARI */}
      <section className="max-w- mx-auto px-6 py-10">
        <h2 className="text- font-bold">{cat.name} Ürün Alanları</h2>
        <div className="mt-4 grid lg:grid-cols-3 gap-3">
          {cat.productAreas.map(p => (
            <div key={p} className="bg-white border rounded-xl px-4 py-3 text-sm flex justify-between"><span>{p}</span><span className="text-zinc-400">→</span></div>
          ))}
        </div>
      </section>

      {/* 5. 81 İLDE GÖRÜNÜRLÜK */}
      <section className="max-w- mx-auto px-6 py-10">
        <h2 className="text- font-black">81 İlde {cat.name} Çözüm Ortaklığı</h2>
        <p className="mt-2 text-sm text-zinc-600 max-w-3xl">{cat.name} kategorisinde Türkiye'nin 81 ilindeki proje ağına ve ilgili malzeme ihtiyaçlarına ulaşın. 81 ilde proje bazlı satış modeline dahil olun.</p>
        <div className="mt-6 grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-3">
          {cities.map(city => (
            <Link key={city.slug} href={`/hug-market/${city.slug}/${cat.slug}`} className="bg-white border rounded-xl px-3 py-2.5 text- hover:bg-black hover:text-white hover:border-black transition-colors flex justify-between items-center group">
              <span>{city.name}</span>
              <span className="text-zinc-400 group-hover:text-white">→</span>
            </Link>
          ))}
        </div>
        <div className="mt-4 text- text-zinc-500">81 il • 973 ilçe • {cat.name} odaklı proje eşleşmesi</div>
      </section>

      {/* 6. KATEGORİ LİDERİ CTA */}
      <section className="max-w- mx-auto px-6 pb-8">
        <div className="bg-white border-2 border-black rounded- p-8 flex flex-col lg:flex-row justify-between items-start lg:items-center gap-4">
          <div><h3 className="text- font-black">Bu kategorinin çözüm ortağı olmak ister misiniz?</h3><p className="text-sm text-zinc-600 mt-1">HUG MARKET'te {cat.name} kategorisinde 81 ilde ürünlerinizi proje bazlı satış modeline dahil edin.</p></div>
          <Link href="/hug-market/cozum-ortagi" className="bg-black text-white px-6 py-3 rounded-full text-sm font-bold whitespace-nowrap">Çözüm Ortağı Başvurusu →</Link>
        </div>
      </section>

      {/* 7. DİĞER KATEGORİLER */}
      <section className="max-w- mx-auto px-6 pb-10">
        <h3 className="font-bold">Diğer HUG MARKET Kategorileri</h3>
        <div className="mt-3 flex flex-wrap gap-2">
          {hugCats.map(c => (
            <Link key={c.slug} href={`/hug-market/cozum-ortagi/${c.slug}`} className={`px-3 py-1.5 rounded-full border text- ${c.slug===cat.slug?'bg-black text-white border-black':'bg-white hover:border-black'}`}>{c.name}</Link>
          ))}
        </div>
      </section>

      {/* 8. FINAL B2B CTA */}
      <section className="max-w- mx-auto px-6 pb-16">
        <div className="bg-black text-white rounded- p-10 text-center">
          <h2 className="text- font-black leading-tight">Markanızı HUG MARKET'e Dahil Edin</h2>
          <p className="mt-3 text-zinc-300 max-w-2xl mx-auto">Ürünlerinizi 81 ilde proje bazlı satış modeli, usta eşleşmesi ve ihtiyaç bazlı satın alma akışıyla buluşturmak için çözüm ortaklığı başvurunuzu oluşturun.</p>
          <Link href="/hug-market/cozum-ortagi" className="mt-6 inline-block bg-white text-black px-8 py-3 rounded-full font-bold">ÇÖZÜM ORTAĞI BAŞVURUSU</Link>
          <div className="mt-4 text- tracking-widest text-zinc-500 uppercase">18 Kategori • 81 İl • Ürün Entegrasyonu • Proje Bazlı Satış</div>
        </div>
      </section>
    </main>
  )
}