'use client'
import { useState, useRef } from 'react'
import Link from 'next/link'
import { collection, addDoc, serverTimestamp } from 'firebase/firestore'
import { db } from '@/lib/firebase'

const urunOntoloji: Record<string, string[]> = {
  'Banyo & Mutfak': ['Seramik Sağlık Gereçleri & Vitrifiye Sistemleri','Banyo Mobilyaları & Dolap Sistemleri','Armatür & Batarya Sistemleri','Duş Sistemleri','Küvet, Jakuzi & Hidromasaj Sistemleri','Gömme Rezervuar & Kumanda Paneli Sistemleri','Mutfak Eviye Sistemleri','Mutfak Fonksiyonel Sistemler','Banyo Aksesuar & Tamamlayıcı Sistemleri'],
  'Temizlik & Hijyen': ['Profesyonel Yüzey & Zemin Temizlik Kimyasalları','Endüstriyel & Teknik Temizlik Sistemleri','Profesyonel Mutfak Hijyeni & Gıda Güvenliği Sistemleri','Çamaşırhane & Tekstil Hijyen Sistemleri','Dezenfeksiyon & Sterilizasyon Sistemleri','Temizlik Makine & Ekipman Sistemleri','Profesyonel Kağıt, Sarf & Tek Kullanımlık Sistemler','Hijyen Dispenser & Koku Sistemleri'],
  'Elektrik & Aydınlatma': ['Alçak Gerilim Kablo & Kablo Taşıma Sistemleri','Elektrik Dağıtım, Koruma & Pano Sistemleri','Anahtar, Priz & Mekanizma Sistemleri','Busbar, Topraklama & Yıldırımdan Korunma Sistemleri','Aydınlatma Armatür Sistemleri','LED, Aydınlatma Kontrol & Driver Sistemleri','Otomasyon, Akıllı Bina & KNX Sistemleri','Enerji Yönetim, Kompanzasyon & Kesintisiz Güç Sistemleri'],
  'Hırdavat, El Aletleri & İş Güvenliği': ['Profesyonel El Aletleri & Takım Setleri','Elektrikli & Akülü El Aletleri & Makine Sistemleri','Kesici Takım, Delici Uç & Aşındırıcı Sarf Sistemleri','Ölçüm, Lazer, Nivo & Test Cihazları','Kompresör, Pnömatik Alet & Hava Sistemleri','Bağlantı, Sabitleme & Ankraj Elemanları','Yapıştırıcı, Sızdırmazlık & Teknik Kimyasallar','Kişisel Koruyucu Donanım & İş Güvenliği Sistemleri','Takım Depolama, Taşıma & Atölye Sistemleri'],
  'Bahçe, Peyzaj & Dış Mekân': ['Profesyonel Bahçe Makine & Motor Sistemleri','Otomatik Sulama & Damlama Sistemleri','Peyzaj Zemin & Yeşil Alan Sistemleri','Dış Mekân Zemin Kaplama & Duvar Sistemleri','Pergola, Gölgeleme & Dış Mekân Yapı Sistemleri','Dış Mekân Mobilya & Aksesuar Sistemleri','Bahçe El Aletleri & Bakım Ekipmanları','Dış Mekân Aydınlatma & Elektrik Sistemleri','Ahşap, Kompozit & WPC Dış Mekân Sistemleri'],
  'Tesisat & Su Sistemleri': ['Temiz Su Tesisat & Boru Sistemleri','Atık Su, Drenaj & Yağmur Suyu Sistemleri','Fittings, Pres & Bağlantı Sistemleri','Vana, Kontrol & Armatür Sistemleri','Pompa, Hidrofor & Basınçlandırma Sistemleri','Su Depolama, Arıtma & Filtrasyon Sistemleri','Yangın Tesisat & Sprinkler Sistemleri','Altyapı, Kanalizasyon & Yağ Ayırıcı Sistemleri'],
  'Yapı Malzemeleri & İnşaat': ['Çimento & Bağlayıcı Sistemleri','Hazır Beton & Beton Katkı Sistemleri','Gazbeton, Tuğla & Duvar Blok Sistemleri','Alçı, Alçıpan & Bölme Duvar Sistemleri','Kuru Harç, Şap & Sıva Sistemleri','Yapıştırıcı, Derz & Yüzey Hazırlık Sistemleri','Donatı, Çelik Hasır & Kalıp Sistemleri','Yapısal Güçlendirme, Tamir & İnşaat Kimyasalları'],
  'Boya & Dekorasyon': ['İç Cephe Boya Sistemleri','Dış Cephe Boya & Cephe Kaplama Sistemleri','Ahşap Boya, Vernik & Ahşap Koruyucu Sistemleri','Metal Boya, Antipas & Korozyon Koruma Sistemleri','Endüstriyel, Epoksi & Zemin Kaplama Sistemleri','Koruyucu Kaplama & Yangın Geciktirici Sistemler','Astar, Macun, Alçı & Yüzey Hazırlık Sistemleri','Dekoratif, Efekt & İtalyan Boya Sistemleri'],
  'Çatı & Cephe Sistemleri': ['Çatı Kaplama Sistemleri','Endüstriyel & Sandviç Panel Çatı Sistemleri','Çatı Yalıtım, Buhar Kesici & Su Yalıtım Sistemleri','Cephe Kaplama Sistemleri','Cephe Mantolama & ETICS Isı Yalıtım Sistemleri','Cephe Alt Konstrüksiyon, Taşıyıcı & Ankraj Sistemleri','Yağmur Suyu Tahliye, Oluk & İniş Sistemleri','Çatı Aksesuar, Işıklık & Güvenlik Sistemleri'],
  'Havuz & Spa Sistemleri': ['Havuz Yapı, Betonarme & Kaplama Sistemleri','Filtrasyon, Sirkülasyon, Pompa & Vana Sistemleri','Dezenfeksiyon, Dozajlama & Tuz Klor Jeneratör Sistemleri','Havuz Isıtma & Isı Pompası Sistemleri','Havuz Aydınlatma, Robot & Temizlik Sistemleri','Havuz Otomasyon & Akıllı Kontrol Sistemleri','Havuz Örtü, Lamel Cover & Güvenlik Sistemleri','Havuz Kimyasalları & Su Bakım Sistemleri','Spa, Jakuzi, Sauna & Wellness Sistemleri'],
  'Isıtma, Soğutma & İklimlendirme': ['Kombi, Yoğuşmalı Kazan & Merkezi Isıtma Sistemleri','Radyatör, Yerden Isıtma & Isı Dağıtım Sistemleri','Isı Pompası & Hibrit Isıtma Sistemleri','Split, Multi Split & Bireysel Klima Sistemleri','VRF, Chiller, Fan Coil & Ticari İklimlendirme Sistemleri','Havalandırma, HRV & Hava Temizleme Sistemleri','Radyant, İnfrared & Endüstriyel Isıtma Sistemleri','İklimlendirme Otomasyonu & Kontrol Sistemleri'],
  'Seramik, Fayans & Zemin': ['Seramik & Porselen Karo Sistemleri','Büyük Ebat & Teknik Porselen Sistemleri','Doğal Taş, Mermer & Mozaik Sistemleri','Parke, Laminat & Ahşap Zemin Sistemleri','LVT, PVC, Vinil & Kauçuk Zemin Sistemleri','Endüstriyel, Epoksi & Yükseltilmiş Döşeme Sistemleri','Zemin Aksesuar, Profil & Uygulama Sistemleri','Dekoratif, 3D & Tasarım Zemin Sistemleri'],
  'Yalıtım & İzolasyon': ['Isı Yalıtım & Mantolama Sistemleri','Su Yalıtım & Membran Sistemleri','Çatı, Temel & Bohçalama Yalıtım Sistemleri','Cephe & Giydirme Cephe İzolasyon Sistemleri','Ses Yalıtım & Akustik Düzenleme Sistemleri','Yangın Yalıtım & Pasif Yangın Durdurucu Sistemler','Teknik İzolasyon & Tesisat Yalıtım Sistemleri','Yalıtım Aksesuar, Bant & Tamamlayıcı Sistemleri'],
  'Cam, Alüminyum & Cephe Sistemleri': ['Cam & Şişecam Sistemleri','Alüminyum Doğrama & Pencere Sistemleri','Cephe Giydirme & Curtain Wall Sistemleri','Sürme, Hebeschiebe & Katlanır Kapı Sistemleri','Küpeşte, Korkuluk & Balkon Sistemleri','Güneş Kırıcı, Louver & Gölgeleme Sistemleri','Otomatik Kapı, Fotoselli & Geçiş Sistemleri','Alüminyum Kompozit & Kaplama Aksesuar Sistemleri'],
  'Yenilenebilir Enerji & Güç Sistemleri': ['GES - Çatı Üstü Güneş Enerji Sistemleri','GES - Arazi Tipi Güneş Enerji Sistemleri','Fotovoltaik Panel Sistemleri','İnvertör Sistemleri','Güneş Montaj & Taşıyıcı Sistemleri','Enerji Depolama Sistemleri','Rüzgar Enerjisi Sistemleri (RES)','On-Grid / Off-Grid / Hibrit Enerji Sistemleri','EV Şarj Sistemleri & Altyapısı','Enerji Yönetim & İzleme Sistemleri'],
  'Kapı, Kilit & Geçiş Kontrol Sistemleri': ['Çelik Kapı & Güvenlik Kapı Sistemleri','İç Kapı, Ahşap & Melamin Kapı Sistemleri','Yangın Kapısı, Acil Çıkış & Duman Sızdırmaz Kapı Sistemleri','Endüstriyel, Seksiyonel & Garaj Kapı Sistemleri','Kilit, Barel & Silindir Güvenlik Sistemleri','Kapı Kol, Menteşe & Kapı Donanım Sistemleri','Otomatik Kapı, Fotoselli & Döner Kapı Sistemleri','Kartlı Geçiş, Turnike & Access Control Sistemleri'],
  'Güvenlik, Yangın Algılama & Zayıf Akım Sistemleri': ['Yangın Algılama, İhbar & Duman Tahliye Sistemleri','Acil Anons, Seslendirme & Acil Aydınlatma Sistemleri','CCTV, Kamera & Video Gözetim Sistemleri','Hırsız Alarm, Akıllı Ev Güvenlik & İhbar Sistemleri','İnterkom, Diafon & Görüntülü Konuşma Sistemleri','Zayıf Akım, Data, Network & Rack Kabinet Sistemleri','Personel Takip, PDKS & Ziyaretçi Yönetim Sistemleri','Paratoner, Yıldırımdan Korunma & Topraklama Sistemleri'],
  'Asansör, Yürüyen Merdiven & Mekanik Taşıma Sistemleri': ['İnsan Asansörü & Konut Asansör Sistemleri','Yük, Sedye, Araç & Monşarj Asansör Sistemleri','Yürüyen Merdiven & Yürüyen Bant Sistemleri','Panoramik, Cam & Özel Tasarım Asansör Sistemleri','Engelli Platform, Merdiven Asansörü & Lift Sistemleri','Asansör Kabin, Kapı, Ray & Aksam Sistemleri','Mekanik Otopark & Araç Park Sistemleri','Asansör Modernizasyon, Bakım & Kurtarma Sistemleri'],
}

const isBirlikleri = ['Kategori Liderliği','Proje & Ürün Entegrasyonu','Marka & Kampanya Görünürlüğü','Diğer']

export default function CozumOrtagiPage() {
  const formRef = useRef<HTMLDivElement>(null)
  const journeyRef = useRef<HTMLDivElement>(null)
  const [firma, setFirma] = useState(''); const [yetkili, setYetkili] = useState(''); const [pozisyon, setPozisyon] = useState(''); const [email, setEmail] = useState(''); const [tel, setTel] = useState(''); const [web, setWeb] = useState(''); const [mesaj, setMesaj] = useState('')
  const [seciliIsBirligi, setSeciliIsBirligi] = useState<Set<string>>(new Set())
  const [seciliUrun, setSeciliUrun] = useState<Record<string, Set<string>>>(()=>{ const o:Record<string, Set<string>>={}; Object.keys(urunOntoloji).forEach(k=>o[k]=new Set()); return o })
  const [openCat, setOpenCat] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)
  const [success, setSuccess] = useState(false)

  const scrollTo = (ref: any) => ref.current?.scrollIntoView({ behavior: 'smooth' })

  const toggleUrun = (cat: string, alt: string) => {
    setSeciliUrun(prev => { const next = {...prev}; const s = new Set(next[cat]); if(s.has(alt)) s.delete(alt); else s.add(alt); next[cat]=s; return next })
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    const toplam = Object.values(seciliUrun).reduce((a,b)=>a+b.size,0)
    if(toplam===0){ alert('Lütfen en az bir ürün alanı seçin'); return }
    if(seciliIsBirligi.size===0){ alert('Lütfen en az bir iş birliği modeli seçin'); return }
    setSubmitting(true)
    try {
      const urunAlanlariObj = Object.fromEntries(
        Object.entries(seciliUrun).filter(([_,v])=>v.size>0).map(([k,v])=>[k, Array.from(v)])
      )
      const payload = {
        firma: firma.trim(),
        yetkili: yetkili.trim(),
        pozisyon: pozisyon.trim(),
        email: email.trim(),
        telefon: tel.trim(),
        webSitesi: web.trim(),
        urunAlanlari: urunAlanlariObj,
        kategoriler: Object.keys(urunAlanlariObj),
        isBirlikleri: Array.from(seciliIsBirligi),
        mesaj: mesaj.trim(),
        createdAt: serverTimestamp(),
        status: 'Yeni',
        source: 'hug-market-cozum-ortagi-web-v3'
      }
      await addDoc(collection(db, 'corporate_leads'), payload)
      setSuccess(true)
      setFirma(''); setYetkili(''); setPozisyon(''); setEmail(''); setTel(''); setWeb(''); setMesaj('')
      const empty: Record<string, Set<string>> = {}; Object.keys(urunOntoloji).forEach(k=> empty[k]=new Set()); setSeciliUrun(empty); setSeciliIsBirligi(new Set())
    } catch (err) {
      console.error(err)
      alert('Gönderilemedi, tekrar deneyin')
    } finally {
      setSubmitting(false)
    }
  }

  const totalSelected = Object.values(seciliUrun).reduce((a,b)=>a+b.size,0)

  return (
    <main className="bg-white text-zinc-900">
      <div className="sticky top-0 z-30 bg-white border-b border-zinc-200 h- lg:h- flex items-center px-4 lg:px-10 justify-between">
        <div className="flex items-center gap-3">
          <Link href="/" className="w-8 h-8 rounded-full bg-zinc-100 flex items-center justify-center">←</Link>
          <img src="/assets/web_logo.png" alt="HUG" className="h-9 lg:h-11 object-contain" onError={e=>{ (e.target as any).style.display='none' }} />
          <img src="/assets/hug/hug_logo.jpg" alt="HUG MARKET" className="h-8 lg:h-10 object-contain" />
          <div className="hidden lg:flex h-7 w-px bg-zinc-200 mx-2" />
          <span className="hidden lg:block text- font-semibold tracking-tight">Proje Odaklı Yapı Malzemeleri Ekosistemi</span>
        </div>
      </div>

      <section className="bg-[#0F0F0F] text-white px-5 lg:px-10 py-10 lg:py-20">
        <div className="max-w- mx-auto">
          <div className="inline-flex bg-[#DC143C]/15 border border-[#DC143C]/30 rounded-full px-3 py-1 text- font-bold tracking-widest text-[#DC143C]">MARKANIZ İÇİN YENİ DİJİTAL KANAL</div>
          <h1 className="mt-5 text- lg:text- leading-[1.05] font-black tracking-tight">
            Markanızı<br/>Doğru <span className="text-[#DC143C]">Usta ve</span><br/>Doğru Projeyle<br/>Buluşturun
          </h1>
          <p className="mt-4 max-w- text- lg:text- leading-6 text-white/60">© HUG MARKET Çözüm Ortaklığı ile markanızı ihtiyaç anında, sahada ürünü kullanan usta ile buluşturuyoruz. Reklam değil, ihtiyacın içinde yer alın.</p>
          <div className="mt-7 flex gap-3">
            <button onClick={()=>scrollTo(formRef)} className="bg-[#DC143C] hover:bg-[#c01035] text-white px-7 h-12 rounded-xl font-bold text-sm">Çözüm Ortağı Ol</button>
            <button onClick={()=>scrollTo(journeyRef)} className="border border-white/20 px-7 h-12 rounded-xl font-semibold text-sm">Markanızın Yolculuğu</button>
          </div>
        </div>
      </section>

      <section className="border-b border-zinc-200 bg-white px-5 lg:px-10 py-4 flex flex-wrap gap-4 lg:gap-8">
        {[
          ['Doğru İhtiyaçta Görünürlük','👁'],
          ['Usta Odaklı Ekosistem','🛠️'],
          ['Ölçülebilir Performans','📊'],
          ['Kategori Konumlandırması','📦'],
        ].map(([t, i])=>(
          <div key={t} className="flex items-center gap-2 text- font-semibold"><div className="w-7 h-7 rounded-lg bg-zinc-100 flex items-center justify-center">{i}</div>{t}</div>
        ))}
      </section>

      <section className="bg-[#FAFAFA] px-5 lg:px-10 py-10 lg:py-16">
        <div className="max-w- mx-auto">
          <h2 className="text- lg:text- font-black">Neden HUG MARKET?</h2>
          <p className="text-zinc-500 text-sm mt-1">Reklam alanı değil, ürün ihtiyacının doğal parçası olun.</p>
          <div className="mt-8 grid lg:grid-cols-2 gap-4">
            {[
              { title: 'İhtiyaç Anında Görünürlük', desc: 'Bir reklam alanında değil, gerçek bir işin içinde görünür olun. HUG MARKET’teki yolculuk, ürünle değil ihtiyaçla başlar. Müşteri Hemen Ustam Gelsin’de işini oluşturur. Ustalar teklif verir, iş alınır ve uygulama aşamasına geçilir. Tam bu noktada, yapılacak işe uygun ürün ihtiyacı ortaya çıkar. HUG MARKET, bu ihtiyacı doğru ürünlerle buluşturur. Böylece markanız, kullanıcıya rastgele gösterilen bir reklam olarak değil; gerçek bir projenin, gerçek bir ustanın ve gerçek bir satın alma ihtiyacının doğal parçası olarak karşısına çıkar.' },
              { title: 'Usta + Müşteri Eşleşmesi', desc: 'Hemen Ustam Gelsin’de müşteri işini oluşturur, usta teklifiyle projeye dahil olur. İş alındığında ise ihtiyaç duyulan ürünler ve malzemeler belirlenir. HUG MARKET, tam bu noktada devreye girerek projeyi, ustayı ve doğru ürünü aynı ekosistemde buluşturur. Böylece marka yalnızca ürünüyle değil, ürünü uygulayan usta ve gerçek proje üzerinden oluşan ihtiyaçla buluşur.' },
              { title: 'Kategori Bazlı Konumlanma', desc: 'Genel reklam değil, doğru kategoride güçlü görünürlük. HUG MARKET’te markanız, geniş ve dağınık bir reklam alanında değil; ürünlerinizin gerçekten ihtiyaç duyulduğu kategori ve projelerde konumlanır. Boya, seramik, tesisat, elektrik, yalıtım veya yapı malzemeleri… Ürününüz, ilgili işin ve proje ihtiyacının doğal akışı içinde doğru kullanıcıya ulaşır.' },
              { title: 'Raporlanabilir Performans', desc: 'Görüntüleme, etkileşim ve kampanya performansını şeffaf şekilde takip edin. Markanızın HUG ekosistemindeki görünürlüğünü yalnızca tahmini rakamlarla değil, ölçülebilir verilerle takip edin.' },
            ].map(c=>(
              <div key={c.title} className="bg-white border border-zinc-200 rounded- p-5 flex gap-3">
                <div className="w-10 h-10 rounded-xl bg-black text-white flex items-center justify-center shrink-0">◍</div>
                <div><div className="font-bold text-">{c.title}</div><div className="mt-2 text-[12.5px] leading-6 text-zinc-600 whitespace-pre-wrap">{c.desc}</div></div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section ref={journeyRef} className="px-5 lg:px-10 py-10 lg:py-16 bg-white">
        <div className="max-w- mx-auto">
          <h2 className="text- lg:text- font-black">Markanızın Yolculuğu</h2>
          <p className="text-sm text-zinc-600 mt-1">Markanız <span className="text-[#DC143C] font-black">© HUG MARKET</span>’te bir reklam alanında değil, gerçek bir projenin ihtiyaç listesinde yer alır.</p>
          <div className="mt-8 grid lg:grid-cols-5 gap-4">
            {[
              { n:'01', t:'İhtiyaç Doğar', sub:'- Müşteri', d:'Hemen Ustam Gelsin’de ilan oluşturulur' },
              { n:'02', t:'Eşleşme Olur', sub:'- Usta + Hemen Ustam Gelsin', d:'Ustalar bu ilana teklif verir' },
              { n:'03', t:'HugAI Sepeti Hazırlar', sub:'', d:'Projenin ihtiyaç listesi hazırlanır' },
              { n:'04', t:'HUG MARKET', sub:'Markayı Gösterir', d:'Ürününüz bu ihtiyacın içinde konumlanır' },
              { n:'05', t:'Satışa Dönüşür', sub:'', d:'İhtiyaç, satın almaya dönüşür' },
            ].map(s=>(
              <div key={s.n} className="bg-white border border-zinc-100 rounded-2xl p-5">
                <div className="w-16 h-16 rounded-full bg-black text-white flex items-center justify-center font-black text- border-4 border-white shadow-[0_0_0_1px_#eee]">{s.n}</div>
                <div className="mt-3 h-1 w-9 bg-[#DC143C] rounded-full" />
                <div className="mt-3 font-bold text-">{s.t}</div>
                <div className="text- font-semibold text-zinc-500">{s.sub}</div>
                <div className="mt-2 text- text-zinc-600 leading-5">{s.d}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="bg-[#0F0F0F] text-white px-5 lg:px-10 py-10 lg:py-16">
        <div className="max-w- mx-auto">
          <h2 className="text- lg:text- font-black">İş Birliği Modelleri</h2>
          <p className="text-white/50 text- mt-2">Reklam değil, projenin içinde yer alın. Marka niyetine göre konumlanın.</p>
          <div className="mt-8 grid lg:grid-cols-3 gap-4">
            {[
              { no:'01', title:'KATEGORİ LİDERLİĞİ', desc:'Kategori Sahipliği - En kapsamlı model', pop:true, items:['Kategori sahipliği & görünürlüğü','HugAI Sepet Entegrasyonu','Ürün görünürlüğü','Banner alanı','Kampanya alanları','Usta prim sistemi','Performans & dönüşüm raporu'] },
              { no:'02', title:'PROJE & ÜRÜN ENTEGRASYONU', desc:'Satış odaklı - Projenin içinde yer alın', pop:false, items:['HugAI Sepet Entegrasyonu','Proje bazlı ürün konumlandırması','Usta odaklı satış & prim','Ürün kampanyaları','Kategori bağlantısı','Dönüşüm & satış raporu'] },
              { no:'03', title:'MARKA & KAMPANYA GÖRÜNÜRLÜĞÜ', desc:'Bilinirlik odaklı - Premium görünürlük', pop:false, items:['Ana sayfa görünürlüğü','HUG banner & kategori banner','Kampanya alanları & yönlendirmesi','Marka tanıtımı','Usta odaklı iletişim','Kampanya raporu'] },
            ].map(p=>(
              <div key={p.no} className={`${p.pop?'bg-white text-black border-[#DC143C]':'bg-white/[0.06] border-white/10 text-white'} border-2 rounded- p-6`}>
                <div className="flex justify-between"><span className="text-[#DC143C] font-black text-">{p.no}</span>{p.pop && <span className="bg-[#DC143C] text-white text- font-bold px-2 py-1 rounded-full">POPÜLER</span>}</div>
                <div className="mt-3 font-black text-">{p.title}</div>
                <div className={`text- ${p.pop?'text-zinc-500':'text-white/50'}`}>{p.desc}</div>
                <div className="mt-4 border-t border-zinc-200/20 pt-4 space-y-2">
                  {p.items.map(it=><div key={it} className="flex gap-2 text-[12.5px]"><span className="text-[#DC143C]">✓</span>{it}</div>)}
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section ref={formRef} className="bg-[#FAFAFA] px-5 lg:px-10 py-10 lg:py-16">
        <div className="max-w- mx-auto bg-white rounded- border border-zinc-200 p-6 lg:p-8 shadow-[0_20px_60px_rgba(0,0,0,0.05)]">
          {success? (
            <div className="text-center py-16">
              <div className="w-16 h-16 rounded-full bg-[#DC143C] text-white flex items-center justify-center text-2xl mx-auto">✓</div>
              <div className="mt-4 font-black text-xl">Başvurunuz Alındı</div>
              <div className="mt-2 text-sm text-zinc-600">Ekibimiz 24 saat içinde dönüş yapacak.</div>
              <button onClick={()=>setSuccess(false)} className="mt-6 border rounded-full px-6 py-2 text-sm font-semibold">Yeni Başvuru</button>
            </div>
          ) : (
            <form onSubmit={handleSubmit}>
              <h2 className="text- font-black tracking-tight">ÇÖZÜM ORTAKLIĞI BAŞVURUSU</h2>
              <p className="text- text-zinc-500 mt-1 leading-5">Markanızı HUG MARKET ekosistemine dahil etmek ve çözüm ortaklığı modelimizi görüşmek için bilgilerinizi paylaşın.</p>

              <div className="mt-6 space-y-3">
                <input required value={firma} onChange={e=>setFirma(e.target.value)} placeholder="Firma Adı*" className="w-full bg-[#FAFAFA] border border-zinc-200 rounded-xl px-4 py-4 text-sm" />
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-3">
                  <input required value={yetkili} onChange={e=>setYetkili(e.target.value)} placeholder="Yetkili Ad Soyad*" className="w-full bg-[#FAFAFA] border border-zinc-200 rounded-xl px-4 py-4 text-sm" />
                  <input value={pozisyon} onChange={e=>setPozisyon(e.target.value)} placeholder="Pozisyon" className="w-full bg-[#FAFAFA] border border-zinc-200 rounded-xl px-4 py-4 text-sm" />
                </div>
                <input required type="email" value={email} onChange={e=>setEmail(e.target.value)} placeholder="Kurumsal E-posta*" className="w-full bg-[#FAFAFA] border border-zinc-200 rounded-xl px-4 py-4 text-sm" />
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-3">
                  <input required value={tel} onChange={e=>setTel(e.target.value)} placeholder="Telefon*" className="w-full bg-[#FAFAFA] border border-zinc-200 rounded-xl px-4 py-4 text-sm" />
                  <input value={web} onChange={e=>setWeb(e.target.value)} placeholder="Web Sitesi" className="w-full bg-[#FAFAFA] border border-zinc-200 rounded-xl px-4 py-4 text-sm" />
                </div>
              </div>

              <div className="mt-8">
                <div className="font-bold text-">Markanızın HUG MARKET’te yer almasını istediğiniz ürün alanlarını seçin.</div>
                <div className="text- text-zinc-500">Birden fazla alan seçebilirsiniz. {totalSelected>0 && <span className="text-[#DC143C] font-bold">{totalSelected} seçildi</span>}</div>

                <div className="mt-4 border border-zinc-300 rounded-xl overflow-hidden">
                  {Object.entries(urunOntoloji).map(([cat, alts])=>{
                    const count = seciliUrun[cat]?.size || 0
                    const isOpen = openCat===cat
                    return (
                      <div key={cat} className="border-b border-zinc-200 last:border-0">
                        <button type="button" onClick={()=>setOpenCat(isOpen? null : cat)} className="w-full flex justify-between items-center px-4 py-3.5 bg-white hover:bg-zinc-50 text-left">
                          <span className="font-bold text-">{cat}</span>
                          <span className="flex items-center gap-2">
                            {count>0 && <span className="bg-[#DC143C] text-white text- font-bold px-2.5 py-1 rounded-full">{count} seçildi</span>}
                            <span className={`transition ${isOpen?'rotate-180':''}`}>⌄</span>
                          </span>
                        </button>
                        {isOpen && (
                          <div className="px-4 pb-3 bg-white">
                            {alts.map(alt=>{
                              const checked = seciliUrun[cat].has(alt)
                              return (
                                <label key={alt} className="flex gap-2 py-2 cursor-pointer">
                                  <input type="checkbox" checked={checked} onChange={()=>toggleUrun(cat, alt)} className="mt-1 accent-[#DC143C]" />
                                  <span className="text- font-medium">{alt}</span>
                                </label>
                              )
                            })}
                          </div>
                        )}
                      </div>
                    )
                  })}
                </div>
              </div>

              <div className="mt-8">
                <div className="font-bold text-sm">İş birliği modeli*</div>
                <div className="mt-2 flex flex-wrap gap-2">
                  {isBirlikleri.map(k=>{
                    const sel = seciliIsBirligi.has(k)
                    return <button type="button" key={k} onClick={()=>{ const s=new Set(seciliIsBirligi); if(s.has(k)) s.delete(k); else s.add(k); setSeciliIsBirligi(s)}} className={`${sel?'bg-black text-white border-black':'bg-white border-zinc-300'} border rounded-full px-4 py-2 text- font-semibold`}>{k}</button>
                  })}
                </div>
              </div>

              <div className="mt-6">
                <div className="font-bold text-sm">Mesajınız</div>
                <textarea value={mesaj} onChange={e=>setMesaj(e.target.value)} rows={4} placeholder="Eklemek istedikleriniz..." className="mt-2 w-full bg-[#FAFAFA] border border-zinc-200 rounded-xl p-4 text-sm" />
              </div>

              <button disabled={submitting} className="mt-8 w-full h- bg-[#DC143C] hover:bg-[#c01035] text-white rounded-xl font-black text-sm tracking-wide">
                {submitting? 'GÖNDERİLİYOR...' : 'ÇÖZÜM ORTAKLIĞI TALEP ET'}
              </button>
            </form>
          )}
        </div>
      </section>

      <div className="bg-black text-zinc-500 text- px-5 lg:px-10 py-6">© {new Date().getFullYear()} Hemen Ustam Gelsin - HUG MARKET Çözüm Ortaklığı • 18 Kategori • 81 İl</div>
    </main>
  )
}