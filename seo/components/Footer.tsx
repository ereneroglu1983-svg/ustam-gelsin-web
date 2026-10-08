// components/Footer.tsx - P0.1 Kısa Doğal Marka Tanımı
import Link from 'next/link'

export default function Footer(){
  return (
    <footer style={{background:'#111', borderTop:'1px solid #222', padding:'40px 20px', marginTop:60}}>
      <div style={{maxWidth:1100, margin:'0 auto'}}>
        <div style={{display:'grid', gridTemplateColumns:'repeat(auto-fit,minmax(200px,1fr))', gap:32}}>
          <div>
            <div style={{fontWeight:900, color:'white', fontSize:16}}>Hemen Ustam Gelsin</div>
            <p style={{color:'#a8a29e', fontSize:13, lineHeight:1.6, marginTop:8}}>
              %0 komisyonlu usta bulma ve teklif alma platformu.
            </p>
            <p style={{color:'#78716c', fontSize:11, marginTop:8}}>
              © 2024-2026 Hemen Ustam Gelsin
            </p>
          </div>
          <div>
            <div style={{fontWeight:700, color:'white', fontSize:12, letterSpacing:1}}>PLATFORM</div>
            <div style={{marginTop:10, display:'flex', flexDirection:'column', gap:8}}>
              <Link href="/hakkimizda/" style={{color:'#a8a29e', fontSize:13, textDecoration:'none'}}>Hakkımızda</Link>
              <Link href="/hugai/" style={{color:'#a8a29e', fontSize:13, textDecoration:'none'}}>HugAI Nedir?</Link>
              <Link href="/hug-market/" style={{color:'#a8a29e', fontSize:13, textDecoration:'none'}}>HUG MARKET</Link>
              <Link href="/rehber/" style={{color:'#a8a29e', fontSize:13, textDecoration:'none'}}>Rehber</Link>
            </div>
          </div>
          <div>
            <div style={{fontWeight:700, color:'white', fontSize:12, letterSpacing:1}}>POPÜLER</div>
            <div style={{marginTop:10, display:'flex', flexDirection:'column', gap:8}}>
              <Link href="/istanbul/elektrik-tesisati/" style={{color:'#a8a29e', fontSize:13, textDecoration:'none'}}>Elektrik Ustası</Link>
              <Link href="/istanbul/boya-badana/" style={{color:'#a8a29e', fontSize:13, textDecoration:'none'}}>Boya Badana</Link>
              <Link href="/usta-is-ilanlari/" style={{color:'#a8a29e', fontSize:13, textDecoration:'none'}}>Usta İş İlanları</Link>
            </div>
          </div>
        </div>
      </div>
    </footer>
  )
}