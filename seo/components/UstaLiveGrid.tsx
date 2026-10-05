// components/UstaLiveGrid.tsx - CLIENT - CANLI FIREBASE - SEO CANAVARI
"use client"
import { useEffect, useState } from 'react'
import { collection, getDocs, query, where } from 'firebase/firestore'
import { db } from '@/lib/firebase'
import komsuMap from '../data/komsu-ilceler.json'

function toSlug(str: string): string {
  if(!str) return ''
  return str.toString()
.replace(/İ/g,'i').replace(/I/g,'i')
.toLocaleLowerCase('tr-TR')
.replace(/ç/g,'c').replace(/ğ/g,'g').replace(/ı/g,'i').replace(/ö/g,'o').replace(/ş/g,'s').replace(/ü/g,'u')
.normalize('NFD').replace(/[\u0300-\u036f]/g, '')
.replace(/[^a-z0-9]+/g,'-').replace(/^-|-$/g,'')
}
function resolveUstaImage(u: any): string {
  const raw = (u.imagePath || u.resimYolu || u['resim yolu'] || '').toString().trim()
  if(!raw) return '/app_logo.png'
  if(raw.startsWith('http://') || raw.startsWith('https://')) return raw
  const clean = raw.replace(/^\/+/, '')
  return `https://cdn.hemenustamgelsin.com/${clean}`
}

export default function UstaLiveGrid({ citySlug, districtSlug, dName, cName }: { citySlug: string, districtSlug: string, dName: string, cName: string }) {
  const [ustalar, setUstalar] = useState<any[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function fetchUsta() {
      try {
        const hedefKey = `${citySlug}/${districtSlug}`
        const komsuListesi: string[] = (komsuMap as any)[hedefKey] || []
        const q = query(collection(db, "karisik_slider"), where("aktif", "==", true))
        const snap = await getDocs(q)
        const all = snap.docs.map((d: any) => ({ id: d.id,...d.data() })) as any[]
        const scored = all.map((u: any) => {
          const ilSlug = toSlug(u.il || u.ilRaw || u.sehir || '')
          const ilceSlug = toSlug(u.ilce || u.ilceRaw || u.ilceSlug || '')
          let tamKonum = (u.tamKonum || '').toString()
          tamKonum = toSlug(tamKonum.replace(/\//g,' ').replace(/-/g,'/'))
          if(!tamKonum && ilSlug && ilceSlug) tamKonum = `${ilSlug}/${ilceSlug}`
          let score = 0
          if (tamKonum === hedefKey) score = 100
          else if (komsuListesi.includes(tamKonum)) score = 80
          else if (ilSlug === citySlug && ilceSlug === districtSlug) score = 100
          else if (ilSlug === citySlug && ilceSlug) score = 50
          else if (ilSlug === citySlug) score = 30
          return {...u, _score: score, _resolvedImage: resolveUstaImage(u) }
        }).filter((u: any) => u._score > 0).sort((a: any, b: any) => b._score - a._score)
        setUstalar(scored.slice(0,12))
      } catch(e){ console.error(e) }
      setLoading(false)
    }
    fetchUsta()
  }, [citySlug, districtSlug])

  if(loading) return <div style={{fontSize:13, color:'#a8a29e', padding:12}}>Buca ustaları yükleniyor...</div>
  if(ustalar.length===0) return <div style={{fontSize:13, color:'#a8a29e', padding:12}}>Bu ilçede henüz aktif usta kaydı yok. İlan ver, {cName} genelinden teklif al.</div>

  return (
    <div style={{display:'grid', gridTemplateColumns:'repeat(auto-fill, minmax(320px, 1fr))', gap:16}}>
      {ustalar.map((u: any) => {
        const hizmetler = (u.hizmetler || []).slice(0,6) as string[]
        const altText = `${u.baslik} - ${dName} ${(hizmetler[0]||'')} ustası - ${cName}`.slice(0,150)
        return (
          <div key={u.id} style={{border:'1px solid #e7e5e4', borderRadius:16, overflow:'hidden', background:'white'}}>
            <div style={{width:'100%', background:'#ffffff', display:'flex', alignItems:'center', justifyContent:'center', padding:6}}>
              <img src={u._resolvedImage} alt={altText} title={altText} loading="lazy" style={{width:'100%', height:'auto', maxHeight:700, objectFit:'contain'}} />
            </div>
            <div style={{padding:12, borderTop:'1px solid #f5f5f4'}}>
              <div style={{fontWeight:900, fontSize:15, lineHeight:1.2}}>{u.baslik} - {dName} Ustası</div>
              <div style={{fontSize:11, color:'#57534e', marginTop:4}}>{u.ilceRaw} • {u.ilRaw}</div>
              <div style={{marginTop:8, display:'flex', flexWrap:'wrap', gap:5}}>
                {hizmetler.map((h:string,i:number)=>(
                  <span key={i} style={{fontSize:11, background:'#f0fdf4', border:'1px solid #bbf7d0', color:'#166534', padding:'3px 7px', borderRadius:999, fontWeight:600}}>{h}</span>
                ))}
              </div>
              <div style={{fontSize:10, color:'#a8a29e', marginTop:6, lineHeight:1.3}}>{(u.hizmetlerRaw || '').slice(0,120)}</div>
            </div>
          </div>
        )
      })}
    </div>
  )
}