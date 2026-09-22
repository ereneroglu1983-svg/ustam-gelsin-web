// app/rehber/page.tsx - FINAL v6 - FLUTTER ILE BIREBIR AYNI TASARIM
import { collection, getDocs } from 'firebase/firestore'
import { db } from '../../lib/firebase'
import Link from 'next/link'
import type { Metadata } from 'next'
import { cities } from '../../data/cities'
import { jobs } from '../../data/jobs'

export const revalidate = 3600
export const dynamic = 'force-static'

function fixR2Url(path: string) {
  if (!path) return "";
  path = path.trim();
  const cdnBase = "https://cdn.hemenustamgelsin.com";
  const oldR2 = "https://pub-27a42c3abc764860b54d06b5cf79567f.r2.dev";
  path = path.replaceAll(oldR2, cdnBase);
  path = path.replaceAll(`${cdnBase}/ustam-gelsin-medya/`, `${cdnBase}/`);
  path = path.replaceAll("/ustam-gelsin-medya/", "/");
  path = path.replaceAll("ustam-gelsin-medya/", "");
  if (path.startsWith("http")) return path;
  if (path.startsWith("/")) return `${cdnBase}${path}`;
  return `${cdnBase}/${path}`;
}

export const metadata: Metadata = {
  title: `İnşaat Rehberi - ${jobs.length} Kategoride Usta Tavsiyeleri | Hemen Ustam Gelsin`,
  description: `Boya, elektrik, tesisat ve ${jobs.length} kategoride rehberler. ${cities.length} il için güncel.`,
  alternates: { canonical: 'https://hemenustamgelsin.com/rehber' },
  robots: { index: true, follow: true }
}

async function getBlogs(){
  try {
    const snap = await getDocs(collection(db, 'icerikler'))
    const list = snap.docs.map(d => ({ id: d.id, ...(d.data() as any) }))
    return list.sort((a:any,b:any)=>{
      const ta = a.tarih?.toDate ? a.tarih.toDate().getTime() : 0
      const tb = b.tarih?.toDate ? b.tarih.toDate().getTime() : 0
      return tb - ta
    })
  } catch { return [] }
}

async function getYeniUstalar(){
  const denenecekKoleksiyonlar = ['karisik_slider', 'ustalar', 'slider', 'users']
  for (const colName of denenecekKoleksiyonlar) {
    try {
      const snap = await getDocs(collection(db, colName))
      if (!snap.empty) {
        const list = snap.docs.map(d => ({ id: d.id, ...(d.data() as any) }))
          .filter((u:any) => u.imagePath || u.image || u.resim || u.photoURL)
        if (list.length > 0) {
          return list.sort((a:any,b:any)=>{
            const ta = a.tarih?.toDate ? a.tarih.toDate().getTime() : a.createdAt?.toDate ? a.createdAt.toDate().getTime() : 0
            const tb = b.tarih?.toDate ? b.tarih.toDate().getTime() : b.createdAt?.toDate ? b.createdAt.toDate().getTime() : 0
            return tb - ta
          }).slice(0,8)
        }
      }
    } catch {}
  }
  return []
}

export default async function RehberHub(){
  const blogs = await getBlogs()
  const yeniUstalar = await getYeniUstalar()
  const popularMixed = cities.slice(0,6).flatMap((c:any) => jobs.slice(0,2).map((j:any)=> ({city:c, job:j}))).slice(0,12)

  return (
    <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
      <section style={{background:'#0f2233', color:'white', padding:'36px 20px'}}>
        <div style={{maxWidth:1120, margin:'0 auto'}}>
          <h1 style={{fontSize:'clamp(26px, 3vw, 32px)', fontWeight:900, margin:0}}>📖 İnşaat Rehberi</h1>
          <p style={{color:'#a8a29e', marginTop:8, fontSize:14}}>Ev tadilatı hakkında bilmeniz gereken her şey. {blogs.length} rehber.</p>
        </div>
      </section>

      <div style={{maxWidth:1120, margin:'0 auto', padding:'20px 20px 0'}}>
        {/* BLOGLAR */}
        <div style={{display:'grid', gap:12}}>
          {blogs.map((b:any)=>{
            const tarihStr = b.tarih?.toDate ? new Date(b.tarih.toDate()).toLocaleDateString('tr-TR', {day:'numeric', month:'long', year:'numeric'}) : '31 Ağustos 2026'
            return (
              <Link key={b.id} href={`/rehber/${b.slug || b.id}`} style={{display:'flex', gap:16, background:'white', border:'1px solid #e7e5e4', borderRadius:14, padding:12, textDecoration:'none', color:'#111'}}>
                <div style={{width:132, height:96, flexShrink:0, borderRadius:10, overflow:'hidden', background:'#f5f5f4', position:'relative'}}>
                  <img src={fixR2Url(b.imagePath||'')} alt={b.baslik} style={{width:'100%', height:'100%', objectFit:'cover'}} loading="lazy" />
                  <span style={{position:'absolute', top:6, left:6, fontSize:9, fontWeight:800, background:'#ff6b00', color:'white', padding:'2px 6px', borderRadius:4}}>{(b.kategori||'TADİLAT').toUpperCase()}</span>
                </div>
                <div style={{flex:1, minWidth:0}}>
                  <span style={{fontSize:11, color:'#a8a29e'}}>📅 {tarihStr}</span>
                  <div style={{fontWeight:700, fontSize:14, lineHeight:1.3, marginTop:4}}>{b.baslik}</div>
                  <span style={{fontSize:12, color:'#2563eb', marginTop:8, display:'inline-block', fontWeight:600}}>Devamını oku →</span>
                </div>
              </Link>
            )
          })}
        </div>

        {/* YENI USTALAR */}
        {yeniUstalar.length > 0 && (
          <div style={{marginTop:32}}>
            <div style={{fontWeight:900, fontSize:16, marginBottom:12}}>Yeni Katılan Ustalar ({yeniUstalar.length})</div>
            <div style={{display:'grid', gridTemplateColumns:'repeat(auto-fill, minmax(160px, 1fr))', gap:12}}>
              {yeniUstalar.map((u:any)=>(
                <div key={u.id} style={{background:'white', border:'1px solid #e7e5e4', borderRadius:12, overflow:'hidden'}}>
                  <div style={{aspectRatio:'3/4', background:'#f5f5f4', position:'relative'}}>
                    <img src={fixR2Url(u.imagePath||u.image||u.resim||u.photoURL||'')} alt={u.baslik||'Usta'} style={{width:'100%', height:'100%', objectFit:'cover'}} loading="lazy" />
                    <div style={{position:'absolute', bottom:0, left:0, right:0, padding:8, background:'linear-gradient(to top, rgba(0,0,0,0.8), transparent)', color:'white', fontSize:11, fontWeight:700}}>{u.baslik||u.adSoyad||u.displayName||'Usta'}</div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* POPULER HIZMETLER */}
        <div style={{marginTop:32, background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:20}}>
          <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>POPÜLER HİZMETLER</div>
          <div style={{display:'flex', flexWrap:'wrap', gap:8}}>
            {popularMixed.map(({city,job}:any) => (
              <Link key={`${city.slug}-${job.slug}`} href={`/${city.slug}/${job.slug}`} style={{fontSize:12, background:'#fafaf9', border:'1px solid #e7e5e4', padding:'8px 12px', borderRadius:999, textDecoration:'none', color:'#444'}}>
                {city.name} {job.name}
              </Link>
            ))}
          </div>
        </div>

        <div style={{height:24}} />
        <div style={{height:1, background:'#e7e5e4'}} />

        {/* CHIPLER - EN ALTA GOMULDU - DARALTILMIS - FLUTTER ILE AYNI */}
        <div style={{padding:'16px 0'}}>
          <div style={{fontSize:11, fontWeight:600, color:'#a8a29e', marginBottom:8}}>Popüler Konular</div>
          <div style={{display:'flex', flexWrap:'wrap', gap:6}}>
            {['Tadilat Rehberi','Dekorasyon Fikirleri','Mutfak Tadilatı','Banyo Yenileme','Elektrik Tesisatı','Su Tesisatı','Boya Badana','Isı Yalıtım','Çatı Tamiri','Fayans Döşeme','Parke Döşeme','Alçıpan İşleri'].map(k => (
              <span key={k} style={{fontSize:9, fontWeight:500, background:'#f5f5f4', border:'1px solid #e7e5e4', padding:'4px 8px', borderRadius:6, color:'#78716c'}}>{k}</span>
            ))}
          </div>
        </div>
      </div>

      {/* FOOTER - KIRMIZI LEGO YOK - NAV FIX - FLUTTER ILE AYNI */}
      <footer style={{background:'#0f2233', padding:'28px 24px', paddingBottom:'calc(28px + env(safe-area-inset-bottom))', marginTop:16}}>
        <div style={{maxWidth:1120, margin:'0 auto', textAlign:'center'}}>
          <div style={{color:'white', fontWeight:800, fontSize:14, letterSpacing:0.5}}>HEMEN USTAM GELSİN</div>
          <div style={{color:'rgba(255,255,255,0.6)', fontSize:11, marginTop:12, lineHeight:1.4}}>İnşaat, tadilat ve dekorasyonda<br/>güvenilir ustanın adresi</div>
          <div style={{height:1, background:'rgba(255,255,255,0.1)', margin:'16px 0'}} />
          <div style={{color:'rgba(255,255,255,0.4)', fontSize:10, lineHeight:1.5}}>© 2026 Hemen Ustam Gelsin<br/>Her Hakkı Saklıdır</div>
        </div>
      </footer>
    </main>
  )
}