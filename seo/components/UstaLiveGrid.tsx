// components/UstaLiveGrid.tsx - CLIENT - CANLI FIREBASE - SEO CANAVARI - FIXED v15.4 - POSTER GARANTİLİ
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
  const raw = (u.imagePath || u.resimYolu || u['resim yolu'] || u.image || '').toString().trim()
  if(!raw) return '/assets/hug/app_logo.png'
  if(raw.startsWith('http://') || raw.startsWith('https://')) return raw
  if(raw.startsWith('/')) return raw
  const clean = raw.replace(/^\/+/, '')
  return `https://cdn.hemenustamgelsin.com/${clean}`
}

export default function UstaLiveGrid({ citySlug, districtSlug, dName, cName }: { citySlug: string, districtSlug: string, dName: string, cName: string }) {
  const [ustalar, setUstalar] = useState<any[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function fetchUsta() {
      setLoading(true)
      try {
        const hedefKey = `${citySlug}/${districtSlug}`
        let komsuListesi: string[] = []
        try {
          komsuListesi = (komsuMap as any)[hedefKey] || []
        } catch { komsuListesi = [] }

        // Önce aktif olanları çek, index sorunu olursa tümünü çekip filtrele
        let all: any[] = []
        try {
          const q = query(collection(db, "karisik_slider"), where("aktif", "==", true))
          const snap = await getDocs(q)
          all = snap.docs.map((d: any) => ({ id: d.id, ...d.data() }))
        } catch (e) {
          console.warn("aktif==true query patladı, fallback tüm collection", e)
          const snap = await getDocs(collection(db, "karisik_slider"))
          all = snap.docs.map((d: any) => ({ id: d.id, ...d.data() })).filter((x:any)=> x.aktif !== false)
        }

        const scored = all.map((u: any) => {
          const ilSlug = toSlug(u.il || u.ilRaw || u.sehir || u.city || '')
          const ilceSlug = toSlug(u.ilce || u.ilceRaw || u.ilceSlug || u.district || '')
          let tamKonumRaw = (u.tamKonum || '').toString().trim()
          // tamKonum "Manisa/Salihli" veya "manisa-salıhlı" gelebilir, tek tip slug yap
          let tamKonum = toSlug(tamKonumRaw.replace(/\//g,'-'))
          // slug -> slash formata çevir
          if(tamKonum.includes('-')) {
            // son tireden bölmeyi dene, yoksa olduğu gibi bırak
            const parts = tamKonum.split('-')
            if(parts.length>=2){
              // basit heuristic: ilçe son kelime
              // ama hedefKey zaten slug/slug formunda, o yüzden direkt toSlug ile karşılaştır
            }
          }
          // En sağlamı: il/ilce den üret
          if(!tamKonum && ilSlug && ilceSlug) tamKonum = `${ilSlug}/${ilceSlug}`
          // tamKonum hala "manisa-salihli" ise slash yap
          if(tamKonum && !tamKonum.includes('/') && tamKonum.includes('-')){
             // eğer manisa-salihli ise son - den böl
             const lastDash = tamKonum.lastIndexOf('-')
             if(lastDash>0){
               const maybeIl = tamKonum.slice(0,lastDash)
               const maybeIlce = tamKonum.slice(lastDash+1)
               // ilSlug'e yakın mı?
               if(maybeIl.length>2 && maybeIlce.length>2) tamKonum = `${maybeIl}/${maybeIlce}`
             }
          }
          // hedefKey zaten manisa/salihli formatında
          const normalizedHedef = `${citySlug}/${districtSlug}`

          let score = 0
          if (tamKonum === normalizedHedef) score = 100
          else if (komsuListesi.includes(tamKonum)) score = 80
          else if (tamKonum && tamKonum.includes('/')) {
            const [tIl, tIlce] = tamKonum.split('/')
            if(tIl === citySlug && tIlce === districtSlug) score = 100
            else if(tIl === citySlug) score = 30
          }
          // yedek skorlama
          if(score===0){
            if (ilSlug === citySlug && ilceSlug === districtSlug) score = 100
            else if (ilSlug === citySlug && ilceSlug) score = 50
            else if (ilSlug === citySlug) score = 30
          }

          return {...u, _score: score, _resolvedImage: resolveUstaImage(u), _tam: tamKonum, _il: ilSlug, _ilce: ilceSlug }
        }).filter((u: any) => u._score > 0).sort((a: any, b: any) => b._score - a._score)

        setUstalar(scored.slice(0,12))
      } catch(e){
        console.error("UstaLiveGrid fetch error:", e)
        setUstalar([])
      }
      setLoading(false)
    }
    fetchUsta()
  }, [citySlug, districtSlug])

  if(loading) {
    return (
      <div style={{display:'grid', gridTemplateColumns:'repeat(auto-fill, minmax(280px, 1fr))', gap:16}}>
        {[1,2,3].map(i=>(
          <div key={i} style={{border:'1px solid #e7e5e4', borderRadius:16, background:'white', padding:12, animation:'pulse 1.5s infinite'}}>
            <div style={{height:220, background:'#f5f5f4', borderRadius:12}} />
            <div style={{height:14, background:'#f5f5f4', borderRadius:6, marginTop:12, width:'70%'}} />
            <div style={{fontSize:12, color:'#a8a29e', marginTop:8}}>{dName} ustaları yükleniyor...</div>
          </div>
        ))}
      </div>
    )
  }

  // DATA YOKSA BİLE POSTER GÖSTER - ASLA BOŞ DÖNME
  if(ustalar.length===0) {
    return (
      <div>
        <div style={{display:'grid', gridTemplateColumns:'repeat(auto-fill, minmax(320px, 1fr))', gap:16}}>
          {[1,2,3].map(i=>(
            <div key={i} style={{border:'1px dashed #111', borderRadius:16, overflow:'hidden', background:'#FFFBF5'}}>
              <div style={{width:'100%', height:280, background:'white', display:'flex', alignItems:'center', justifyContent:'center', flexDirection:'column', padding:12}}>
                <img src="/assets/hug/app_logo.png" alt={`${dName} usta`} style={{height:80, width:'auto', objectFit:'contain'}} />
                <div style={{marginTop:12, fontWeight:900, fontSize:16}}>{dName} İçin İlk Ustalar Aranıyor</div>
                <div style={{fontSize:12, color:'#57534e', marginTop:4, textAlign:'center'}}>Bu ilçede henüz aktif poster yok. İlan verdiğinde {cName} genelindeki ustalar teklif verecek.</div>
              </div>
              <div style={{padding:12, background:'white', borderTop:'1px solid #f5f5f4'}}>
                <div style={{fontWeight:800, fontSize:13}}>{dName} - Canlı Teklif Sistemi Aktif</div>
                <div style={{fontSize:11, color:'#57534e', marginTop:4}}>İŞ SENİN, EMEK SENİN, KAZANÇ SENİN. ÜYELİK ÜCRETİ YOK.</div>
                <a href="/ilan-olustur" style={{display:'inline-block', marginTop:10, background:'#111', color:'white', padding:'8px 14px', borderRadius:10, fontWeight:800, fontSize:12, textDecoration:'none'}}>İLAN VER →</a>
              </div>
            </div>
          ))}
        </div>
        <div style={{fontSize:11, color:'#a8a29e', marginTop:10, textAlign:'center'}}>Debug: {citySlug}/{districtSlug} için eşleşen aktif kayıt bulunamadı. Firestore'da il ve ilce alanlarını kontrol et.</div>
      </div>
    )
  }

  return (
    <div style={{display:'grid', gridTemplateColumns:'repeat(auto-fill, minmax(320px, 1fr))', gap:16}}>
      {ustalar.map((u: any) => {
        const hizmetler = (u.hizmetler || u.hizmetlerRaw?.split(',') || []).slice(0,6) as string[]
        const altText = `${u.baslik || u.ad || 'Usta'} - ${cName} ${dName} ustası - ${(hizmetler[0]||'')}`.slice(0,150)
        return (
          <div key={u.id} style={{border:'1px solid #e7e5e4', borderRadius:16, overflow:'hidden', background:'white'}}>
            <div style={{width:'100%', background:'#ffffff', display:'flex', alignItems:'center', justifyContent:'center', padding:6, minHeight:240}}>
              <img
                src={u._resolvedImage}
                alt={altText}
                title={altText}
                loading="lazy"
                onError={(e:any)=>{ e.currentTarget.src='/assets/hug/app_logo.png' }}
                style={{width:'100%', height:'auto', maxHeight:700, objectFit:'contain'}}
              />
            </div>
            <div style={{padding:12, borderTop:'1px solid #f5f5f4'}}>
              <div style={{fontWeight:900, fontSize:15, lineHeight:1.2}}>{u.baslik || u.ad || `${dName} Ustası`}</div>
              <div style={{fontSize:11, color:'#57534e', marginTop:4}}>{u.ilceRaw || u.ilce || dName} • {u.ilRaw || u.il || cName} • skor:{u._score} • {u._tam}</div>
              <div style={{marginTop:8, display:'flex', flexWrap:'wrap', gap:5}}>
                {hizmetler.map((h:string,i:number)=>(
                  <span key={i} style={{fontSize:11, background:'#f0fdf4', border:'1px solid #bbf7d0', color:'#166534', padding:'3px 7px', borderRadius:999, fontWeight:600}}>{h.trim()}</span>
                ))}
              </div>
              <div style={{fontSize:10, color:'#a8a29e', marginTop:6, lineHeight:1.3}}>{(u.hizmetlerRaw || '').toString().slice(0,120)}</div>
            </div>
          </div>
        )
      })}
    </div>
  )
}
