// app/hakkimizda/page.tsx - P0.1 Kurumsal Kimlik Merkezi - v1.1 PLAY BANNER
import type { Metadata } from 'next'
import Link from 'next/link'

const PLAY_URL_CLEAN = "https://play.google.com/store/apps/details?id=com.hemenustamgelsin.android"
const PLAY_URL_ABOUT = `${PLAY_URL_CLEAN}&pcampaignid=web_hakkimizda_banner`

const OFFICIAL_IDENTITY = "Hemen Ustam Gelsin, Türkiye genelinde 81 il ve 973 ilçede müşterileri uygun ustalarla buluşturan ve teklif almalarını sağlayan %0 komisyonlu bir usta bulma ve usta-müşteri eşleştirme platformudur. Platform, HugAI ile iş kapsamı ve maliyet tahminini destekler; HUG MARKET ile gerekli malzemelerin çözüm ortakları üzerinden temin edilmesini sağlar."

export const metadata: Metadata = {
  title: 'Hakkımızda - Hemen Ustam Gelsin | %0 Komisyonlu Usta Platformu',
  description: 'Hemen Ustam Gelsin, Türkiye’de %0 komisyonla usta ve müşteriyi buluşturan platformdur. Amacımız, kuruluş hikayemiz, HugAI ve HUG MARKET ekosistemimiz.',
  alternates: { canonical: 'https://hemenustamgelsin.com/hakkimizda/' },
}

export default function HakkimizdaPage(){
  const aboutSchema = {
    "@context": "https://schema.org",
    "@type": "AboutPage",
    "name": "Hakkımızda - Hemen Ustam Gelsin",
    "url": "https://hemenustamgelsin.com/hakkimizda/",
    "description": OFFICIAL_IDENTITY,
    "mainEntity": {
      "@type": "Organization",
      "name": "Hemen Ustam Gelsin",
      "description": OFFICIAL_IDENTITY
    }
  }

  return (
    <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(aboutSchema) }} />

      <section style={{background:'#111', color:'white', padding:'60px 20px'}}>
        <div style={{maxWidth:900, margin:'0 auto'}}>
          <div style={{fontSize:11, fontWeight:800, letterSpacing:1, color:'#a8a29e'}}>KURUMSAL</div>
          <h1 style={{fontSize:'clamp(32px,5vw,48px)', fontWeight:900, margin:'8px 0 0', lineHeight:1}}>Hakkımızda</h1>
          <p style={{color:'#a8a29e', fontSize:16, marginTop:14, maxWidth:600, lineHeight:1.6}}>{OFFICIAL_IDENTITY}</p>
          <div style={{marginTop:20, display:'flex', gap:10, flexWrap:'wrap'}}>
            <a href={PLAY_URL_ABOUT} target="_blank" rel="noopener" style={{background:'white', color:'black', padding:'12px 20px', borderRadius:10, fontWeight:800, fontSize:13, textDecoration:'none'}}>📱 Uygulamayı İndir →</a>
            <Link href="/" style={{background:'transparent', color:'white', border:'1px solid #333', padding:'12px 20px', borderRadius:10, fontWeight:800, fontSize:13, textDecoration:'none'}}>Ana Sayfa</Link>
          </div>
        </div>
      </section>

      <section style={{maxWidth:900, margin:'0 auto', padding:'32px 20px', display:'flex', flexDirection:'column', gap:24}}>

        <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:24}}>
          <h2 style={{fontSize:18, fontWeight:800, margin:0}}>Kuruluş Amacımız</h2>
          <p style={{fontSize:14, lineHeight:1.7, color:'#44403c', marginTop:10}}>
            Usta bulma sürecindeki komisyon, şişirilmiş fiyat ve güvensizlik problemini çözmek için kurulduk.
            Türkiye'de her ilçede, her iş kolunda müşterinin doğrudan ustaya ulaşabildiği, aracı maliyeti olmadan teklif alabildiği bir sistem kurmak istiyoruz.
          </p>
        </div>

        <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:24}}>
          <h2 style={{fontSize:18, fontWeight:800, margin:0}}>%0 Komisyon Modeli</h2>
          <p style={{fontSize:14, lineHeight:1.7, color:'#44403c', marginTop:10}}>
            Platform olarak yapılan işten komisyon almıyoruz. Müşteri ilan verir, usta teklif verir. Anlaşma olursa hakedişin %100'ü ustanın.
            Bu model hem ustanın kazancını korur hem de müşteriye yansıyan fiyatı şişirmez.
          </p>
        </div>

        <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:24}}>
          <h2 style={{fontSize:18, fontWeight:800, margin:0}}>Usta - Müşteri Akışı Nasıl Çalışır?</h2>
          <ol style={{fontSize:14, lineHeight:1.7, color:'#44403c', marginTop:10, paddingLeft:18}}>
            <li>Müşteri ihtiyacını anlatır, ilan oluşturur (il, ilçe, iş kolu).</li>
            <li>Bölgedeki uygun ve aktif ustalara bildirim gider.</li>
            <li>Ustalar teklif verir.</li>
            <li>Müşteri teklifleri karşılaştırır, doğrudan ustayla iletişime geçer.</li>
          </ol>
        </div>

        <div style={{display:'grid', gridTemplateColumns:'repeat(auto-fit,minmax(280px,1fr))', gap:16}}>
          <div style={{background:'#111', color:'white', borderRadius:16, padding:24}}>
            <h3 style={{fontSize:16, fontWeight:800, margin:0}}>HugAI</h3>
            <p style={{fontSize:13, lineHeight:1.6, color:'#a8a29e', marginTop:8}}>
              Hemen Ustam Gelsin'in iş kapsamı ve maliyet tahminini destekleyen yapay zekâ sistemidir. İlanınıza göre işin kapsamını analiz eder ve bütçe aralığı oluşturmanıza yardımcı olur.
            </p>
            <Link href="/hugai/" style={{display:'inline-block', marginTop:12, color:'white', fontSize:12, fontWeight:700, textDecoration:'none', border:'1px solid #333', padding:'8px 12px', borderRadius:8}}>HugAI Nedir? →</Link>
          </div>
          <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:24}}>
            <h3 style={{fontSize:16, fontWeight:800, margin:0}}>HUG MARKET</h3>
            <p style={{fontSize:13, lineHeight:1.6, color:'#44403c', marginTop:8}}>
              HUG MARKET, Hemen Ustam Gelsin ekosisteminde ustaların ihtiyaç duyduğu malzemelerin çözüm ortakları üzerinden temin edilmesini sağlayan malzeme ekosistemidir.
            </p>
            <Link href="/hug-market/" style={{display:'inline-block', marginTop:12, color:'#111', fontSize:12, fontWeight:700, textDecoration:'none', border:'1px solid #e7e5e4', padding:'8px 12px', borderRadius:8}}>HUG MARKET →</Link>
          </div>
        </div>

        <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:24}}>
          <h2 style={{fontSize:18, fontWeight:800, margin:0}}>Gelecek Vizyonu</h2>
          <p style={{fontSize:14, lineHeight:1.7, color:'#44403c', marginTop:10}}>
            Hedefimiz sadece bir ilan platformu olmak değil. Türkiye'nin 81 il ve 973 ilçesinde her ustanın dijital kimliğe, her müşterinin de şeffaf teklife eriştiği, malzeme tedariğinden iş takibine kadar uçtan uca bir usta ekosistemi kurmak.
          </p>
        </div>

        {/* PLAY BANNER - FINAL */}
        <div style={{background:'#111', borderRadius:16, padding:20, display:'flex', justifyContent:'space-between', alignItems:'center', gap:16, flexWrap:'wrap'}}>
          <div style={{display:'flex', alignItems:'center', gap:12}}>
            <div style={{width:44, height:44, background:'white', borderRadius:10, display:'grid', placeItems:'center', fontSize:22}}>🔧</div>
            <div>
              <div style={{color:'white', fontWeight:900, fontSize:16}}>Hemen Ustam Gelsin - Uygulama YAYINDA!</div>
              <div style={{color:'#a8a29e', fontSize:13, marginTop:2}}>81 il, 973 ilçe, %0 komisyon - Android uygulamasını indir</div>
            </div>
          </div>
          <a href={PLAY_URL_ABOUT} target="_blank" rel="noopener" style={{background:'white', color:'black', padding:'14px 20px', borderRadius:10, fontWeight:900, fontSize:14, textDecoration:'none', whiteSpace:'nowrap'}}> Google Play'den İndir →</a>
        </div>

      </section>
    </main>
  )
}