// app/[city]/[slug]/page.tsx - FINAL v16.1 MODULAR - FIXED
// Tüm logic modüllere bölündü, burası sadece orchestration
import { cities } from '../../../data/cities'
import { jobs } from '../../../data/jobs'
import { getCityJobData } from '../../../data/cityJobDatabase'
import Link from 'next/link'
import type { Metadata } from 'next'
import { notFound } from 'next/navigation'
import UstaLiveGrid from '../../../components/UstaLiveGrid'
import Breadcrumb from '../../../components/Breadcrumb'

import { loc, countWords, hashString, pickDeterministic } from './helpers'
import { districtSEODataOverride } from './district-overrides'
import { introVariants } from './intro-variants'
import { faqTemplates, faqTopicMap } from './faq-templates'
import { nearbyMap } from './nearby-map'
import {
  getDistrictSEOData,
  buildDistrictIntro,
  getDistrictServiceLinks,
  getSiblingDistricts,
  getDistrictFAQs,
  getDistrictActionNote
} from './seo-logic'

const PLAY_URL_CLEAN = "https://play.google.com/store/apps/details?id=com.hemenustamgelsin.android"
const PLAY_URL_CITY_SLUG = `${PLAY_URL_CLEAN}&pcampaignid=web_city_slug_banner`

const SLOGAN_LINE1 = "İŞ SENİN, EMEK SENİN, KAZANÇ SENİN."
const SLOGAN_LINE2 = "ÜYELİK ÜCRETİ YOK. KOMİSYON YOK. SONRADAN KESİNTİ YOK."
const SLOGAN_FULL = `${SLOGAN_LINE1} ${SLOGAN_LINE2}`

function validateBuildData() {
 if (cities.length!==81) throw new Error(`[BUILD FAIL] cities.length=${cities.length}`)
 const citySlugSet = new Set(cities.map(c=>c.slug))
 if (citySlugSet.size!==81) throw new Error(`[BUILD FAIL] duplicate city slug`)
 const nearbyKeys = Object.keys(nearbyMap)
 if (nearbyKeys.length!==81) throw new Error(`[BUILD FAIL] nearbyMap count=${nearbyKeys.length}`)
 const nearbyKeySet = new Set(nearbyKeys)
 for (const cSlug of citySlugSet) { if (!nearbyKeySet.has(cSlug)) throw new Error(`[BUILD FAIL] nearbyMap eksik şehir: ${cSlug}`) }
 for (const key of nearbyKeys) { if (!citySlugSet.has(key)) throw new Error(`[BUILD FAIL] nearbyMap geçersiz şehir slug: ${key}`) }
 for (const [k, vals] of Object.entries(nearbyMap)) {
  for (const v of vals) { if (!citySlugSet.has(v)) throw new Error(`[BUILD FAIL] nearbyMap[${k}] geçersiz komşu: ${v}`); if (v===k) throw new Error(`[BUILD FAIL] nearbyMap[${k}] kendisini içeriyor`) }
  if (new Set(vals).size!== vals.length) throw new Error(`[BUILD FAIL] nearbyMap[${k}] duplicate komşu var`)
 }
 if (jobs.length!==43) throw new Error(`[BUILD FAIL] jobs.length=${jobs.length}`)
 const districtCount = cities.reduce((s,c)=>s+c.districts.length,0)
 if (districtCount!==973) throw new Error(`[BUILD FAIL] districtCount=${districtCount}`)
 for (const city of cities) {
  const dSlugs = city.districts.map(d=>d.slug)
  if (new Set(dSlugs).size!== dSlugs.length) { const dup = dSlugs.find((s,i)=>dSlugs.indexOf(s)!==i); throw new Error(`[BUILD FAIL] ${city.slug} içinde duplicate ilçe slug: ${dup}`) }
 }
 const jobSet = new Set(jobs.map(j=>j.slug))
 if (cities.flatMap(c=>c.districts.map(d=>d.slug)).filter(d=>jobSet.has(d)).length>0) throw new Error(`[BUILD FAIL] JOB ∩ DISTRICT`)
 introVariants.forEach((variant, i) => { const sample = variant('Salihli', 'Manisa', "Salihli'de"); const wc = countWords(sample); if (wc < 60 || wc > 95) { throw new Error(`[BUILD FAIL] introVariants[${i}] = ${wc} kelime. Base intro 60-95 arası olmalı.`) } })
 const jobSlugSet = new Set(jobs.map(j => j.slug))
 for (const [key, data] of Object.entries(districtSEODataOverride)) {
  const [citySlug, districtSlug] = key.split('/'); if (!citySlug ||!districtSlug) throw new Error(`[BUILD FAIL] Geçersiz key: ${key}`); const city = cities.find(c => c.slug === citySlug); if (!city) throw new Error(`[BUILD FAIL] geçersiz şehir: ${key}`); const district = city.districts.find(d=>d.slug===districtSlug); if (!district) throw new Error(`[BUILD FAIL] geçersiz ilçe: ${key}`); for (const s of data.serviceFocus?? []) { if (!jobSlugSet.has(s)) throw new Error(`[BUILD FAIL] ${key} geçersiz serviceFocus: ${s}`) }; for (const s of data.nearbyPriority?? []) { if (!city.districts.some(d => d.slug === s)) throw new Error(`[BUILD FAIL] ${key} geçersiz nearbyPriority: ${s}`); if (s === districtSlug) throw new Error(`[BUILD FAIL] ${key} nearbyPriority kendisini içeriyor: ${s}`) }; if (data.nearbyPriority && new Set(data.nearbyPriority).size!== data.nearbyPriority.length) { throw new Error(`[BUILD FAIL] ${key} nearbyPriority içinde duplicate var`) }
 }
 let autoCount = 0
 for (const city of cities) { for (const district of city.districts) { const data = getDistrictSEOData(city, district); if (!data.serviceFocus.length) throw new Error(`[BUILD FAIL] ${city.slug}/${district.slug} serviceFocus boş`); if (!data.localIntro) throw new Error(`[BUILD FAIL] ${city.slug}/${district.slug} localIntro boş`); if (!data.demandNote) throw new Error(`[BUILD FAIL] ${city.slug}/${district.slug} demandNote boş`); if (!data.faqTopics.length) throw new Error(`[BUILD FAIL] ${city.slug}/${district.slug} faqTopics boş`); if (!data.nearbyPriority.length) throw new Error(`[BUILD FAIL] ${city.slug}/${district.slug} nearbyPriority boş`); const dLoc = loc(district.name); const base = introVariants[hashString(`${city.slug}/${district.slug}`) % introVariants.length](district.name, city.name, dLoc); const finalIntro = `${data.localIntro} ${base}`; const wc = countWords(finalIntro); if (wc < 75 || wc > 200) { throw new Error(`[BUILD FAIL] ${city.slug}/${district.slug} final intro = ${wc} kelime. 75-200 arası olmalı.`) }; autoCount++ } }
 if (autoCount!== 973) throw new Error(`[BUILD FAIL] count=${autoCount}`)
}

export function generateStaticParams(){
 validateBuildData()
 const params: {city: string, slug: string}[] = []
 for(const c of cities){ for(const j of jobs){ params.push({city: c.slug, slug: j.slug}) }; for(const d of c.districts){ params.push({city: c.slug, slug: d.slug}) } }
 if(params.length!== 4456) throw new Error(`[BUILD FAIL] params.length=${params.length}`)
 return params
}

export async function generateMetadata({params}:{params: Promise<{city:string,slug:string}>}): Promise<Metadata>{
 const { city: citySlug, slug } = await params
 if (slug.includes('.') || citySlug.includes('.')) return {}
 const city = cities.find(c=>c.slug===citySlug)
 if(!city) return {}
 const job = jobs.find(j=>j.slug===slug)
 if(job){ const seoData = getCityJobData(city.slug, job.slug); if(!seoData) return {}; const canonical = `https://hemenustamgelsin.com/${city.slug}/${job.slug}/`; return { title: seoData.metaTitle, description: seoData.metaDescription, alternates: { canonical }, openGraph: { title: seoData.metaTitle, description: seoData.metaDescription, url: canonical, type: 'website', locale: 'tr_TR', siteName: 'Hemen Ustam Gelsin' }, twitter: { card: 'summary_large_image', title: seoData.metaTitle, description: seoData.metaDescription }, robots: { index: true, follow: true } } }
 const district = city.districts.find(d=>d.slug===slug)
 if(district){ const dLoc = loc(district.name); const title = `${district.name} Ustaları | ${city.name} – ${SLOGAN_LINE1}`; const description = `${dLoc} usta bul, teklif al. ${SLOGAN_FULL} HugAI tahmini fiyatı ve doğrudan teklif sistemiyle işini başlat.`; const canonical = `https://hemenustamgelsin.com/${city.slug}/${district.slug}/`; return { title, description, alternates: { canonical }, openGraph: { title, description, url: canonical, type: 'website', locale: 'tr_TR', siteName: 'Hemen Ustam Gelsin' }, twitter: { card: 'summary_large_image', title, description }, robots: { index: true, follow: true } } }
 return {}
}

function getNearbyCities(currentSlug: string) { return cities.filter(c => (nearbyMap[currentSlug]||[]).includes(c.slug)).slice(0,12) }

export default async function UnifiedCitySlugPage({params}:{params: Promise<{city:string,slug:string}>}){
 const { city: citySlug, slug } = await params
 if (slug.includes('.') || citySlug.includes('.') || slug === 'favicon' || slug === 'robots') notFound()
 const city = cities.find(c=>c.slug===citySlug)
 if(!city) notFound()
 const job = jobs.find(j=>j.slug===slug)
 if(job){
  const seoData = getCityJobData(city.slug, job.slug)
  if(!seoData) notFound()
  const ilceler = seoData.ilceler?? []
  const firstIlce = ilceler[0] || city.name
  const ilceCount = ilceler.length
  const s = job.slug.toLowerCase()
  let icon = '🛠', color = '#111'
  if(s.includes('boya')) { icon='🎨'; color='#db2777' }
  if(s.includes('elektrik')) { icon='⚡'; color='#f59e0b' }
  if(s.includes('tesisat')||s.includes('su')) { icon='🚿'; color='#0ea5e9' }
  if(s.includes('fayans')) { icon='🧱'; color='#a16207' }
  if(s.includes('klima')) { icon='❄'; color='#06b6d4' }
  if(s.includes('tavan')) { icon='🏗'; color='#57534e' }
  const pageUrl = `https://hemenustamgelsin.com/${city.slug}/${job.slug}/`
  const serviceSchema = { "@context": "https://schema.org", "@type": "Service", "@id": `${pageUrl}#service`, "name": seoData.h1, "serviceType": job.name, "description": seoData.metaDescription, "provider": { "@id": "https://hemenustamgelsin.com/#organization" }, "areaServed": [{ "@type": "City", "name": city.name },...ilceler.map((d: string) => ({ "@type": "AdministrativeArea", "name": d }))], "url": pageUrl }
  const breadcrumbSchema = { "@context": "https://schema.org", "@type": "BreadcrumbList", "itemListElement": [ { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com/" }, { "@type": "ListItem", "position": 2, "name": `${city.name} Ustaları`, "item": `https://hemenustamgelsin.com/${city.slug}/` }, { "@type": "ListItem", "position": 3, "name": `${city.name} ${job.name}`, "item": pageUrl } ] }
  const faqSchema = { "@context": "https://schema.org", "@type": "FAQPage", "mainEntity": seoData.faqs.map((f: any) => ({ "@type": "Question", "name": f.q, "acceptedAnswer": { "@type": "Answer", "text": f.a } })) }
  return (
   <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
    <header style={{background:'rgba(255,255,255,0.92)', backdropFilter:'blur(12px)', borderBottom:'1px solid #e7e5e4', padding:'14px 20px', position:'sticky', top:0, zIndex:50}}>
     <div style={{maxWidth:1120, margin:'0 auto', display:'flex', alignItems:'center', justifyContent:'space-between', gap:12}}>
      <div style={{display:'flex', alignItems:'center', gap:12}}>
       <Link href="/" style={{display:'flex', alignItems:'center', gap:12, textDecoration:'none'}}>
        <img src="/assets/hug/app_logo.png" alt="Hemen Ustam Gelsin" style={{height:72, width:'auto', objectFit:'contain'}} />
        <div style={{width:1, height:32, background:'#e7e5e4'}} />
        <img src="/assets/hug/hug_logo.jpg" alt="Hug Market" style={{height:60, width:'auto', objectFit:'contain', borderRadius:8}} />
        <div style={{display:'flex', flexDirection:'column', lineHeight:1, marginLeft:4}}>
         <span style={{fontWeight:900, fontSize:17, letterSpacing:0.8, color:'#111'}}>HEMEN <span style={{color:'#111'}}>USTAM</span> <span style={{color:'#dc2626'}}>GELSİN</span></span>
         <span style={{fontSize:9.5, color:'#78716c', fontWeight:700, letterSpacing:0.3, marginTop:2, textTransform:'uppercase'}}>LÜX KURUMSAL • {SLOGAN_LINE1}</span>
        </div>
       </Link>
      </div>
      <div style={{display:'flex', alignItems:'center', gap:8}}>
       <Link href="/usta-kayit" style={{fontSize:12, fontWeight:800, color:'#44403c', background:'white', border:'1px solid #e7e5e4', padding:'10px 16px', borderRadius:999, textDecoration:'none'}}>USTA GİRİŞİ</Link>
       <Link href="/ilan-olustur" style={{fontSize:12, fontWeight:900, color:'white', background:'#111', padding:'10px 18px', borderRadius:999, textDecoration:'none', letterSpacing:0.5, boxShadow:'0 4px 12px rgba(0,0,0,0.12)'}}>İLAN VER →</Link>
      </div>
     </div>
    </header>
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(serviceSchema) }} />
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }} />
    <div style={{maxWidth:1120, margin:'0 auto', padding:'14px 20px 0'}}>
      <Breadcrumb items={[{ name: `${city.name} Ustaları`, href: `/${city.slug}/` }, { name: `${city.name} ${job.name}`, href: `/${city.slug}/${job.slug}/` }]} />
    </div>
    <div style={{maxWidth:1120, margin:'12px auto 0', padding:'0 20px'}}>
      <div style={{background:'#111', borderRadius:14, padding:'12px 16px', display:'flex', justifyContent:'space-between', alignItems:'center', gap:12, flexWrap:'wrap'}}>
        <div style={{display:'flex', alignItems:'center', gap:12}}>
          <div style={{width:36, height:36, background:'white', borderRadius:8, display:'grid', placeItems:'center', fontSize:20}}>📱</div>
          <div>
            <div style={{color:'white', fontWeight:800, fontSize:14}}>{city.name} {job.name} YAYINDA! %0 Komisyon</div>
            <div style={{color:'#a8a29e', fontSize:12}}>Uygulamadan ilan ver, {city.name}'da daha hızlı teklif al.</div>
          </div>
        </div>
        <a href={PLAY_URL_CITY_SLUG} target="_blank" rel="noopener" style={{background:'white', color:'black', padding:'10px 16px', borderRadius:10, fontWeight:800, fontSize:13, textDecoration:'none', whiteSpace:'nowrap'}}>【entity-Google Play¦canonical_name=Google Play】'den İndir →</a>
      </div>
    </div>
    <section style={{ background: `radial-gradient(800px 400px at 15% 0%, ${color}15 0%, transparent 60%), #FFFBF5`, padding:'26px 20px 28px' }}>
     <style>{`@media(max-width:768px){.job-hero{grid-template-columns:1fr!important}.job-content{grid-template-columns:1fr!important}}`}</style>
     <div className="job-hero" style={{maxWidth:1120, margin:'0 auto', display:'grid', gridTemplateColumns:'1.15fr 0.85fr', gap:24}}>
      <div>
       <div style={{display:'inline-flex', gap:6, background:'white', border:'1px solid #e7e5e4', borderRadius:999, padding:'6px 10px', fontSize:11, fontWeight:800, marginBottom:14}}><span style={{background:color, color:'white', borderRadius:999, padding:'2px 8px'}}>{icon} {job.name.toUpperCase()}</span><span>{city.name.toUpperCase()} • HugAI • {SLOGAN_LINE1}</span></div>
       <h1 style={{fontSize:'clamp(28px, 4vw, 48px)', fontWeight:900, lineHeight:0.92, margin:0}}>{seoData.h1}<br/> HugAI Destekli Yaklaşık Fiyat Aralığı</h1>
       <p style={{fontSize:16, color:'#44403c', marginTop:12, maxWidth:560}}>{seoData.intro}</p>
       <div style={{marginTop:18, display:'flex', gap:10, flexWrap:'wrap'}}>
        <a href="https://hemenustamgelsin.com/ilan-olustur/" style={{background:'#111', color:'white', padding:'14px 20px', borderRadius:12, fontWeight:900, textDecoration:'none'}}>HEMEN İLAN VER →</a>
        <a href="https://hemenustamgelsin.com/usta-kayit/" style={{background:'white', color:'#111', padding:'14px 20px', borderRadius:12, fontWeight:800, border:'1px solid #e7e5e4', textDecoration:'none'}}>USTA OL, {city.name.toUpperCase()}'DA İŞ AL</a>
       </div>
      </div>
      <div style={{background:'white', borderRadius:18, border:'1px solid #e7e5e4', padding:16}}>
       <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>NASIL ÇALIŞIR?</div>
       <div style={{display:'grid', gap:10}}>
        <div style={{background:'#fafaf9', borderRadius:12, padding:'12px 10px'}}><div style={{fontWeight:800, fontSize:12}}>1. İhtiyacını Anlat</div><div style={{fontSize:11, color:'#57534e', marginTop:2}}>{city.name} {job.name.toLowerCase()} için iş detaylarını ve ölçülerini ekle, 2 dakikada ilan ver.</div></div>
        <div style={{background:'#f0fdf4', border:'1px solid #bbf7d0', borderRadius:12, padding:'12px 10px'}}><div style={{fontWeight:800, fontSize:12}}>2. HugAI Yaklaşık Fiyatı Göstersin</div><div style={{fontSize:11, color:'#166534', marginTop:2}}>HugAI tahmini piyasa fiyat aralığını gösterir ve bütçe planlamana yardımcı olur.</div></div>
        <div style={{background:'#fafaf9', borderRadius:12, padding:'12px 10px'}}><div style={{fontWeight:800, fontSize:12}}>3. Teklifleri Karşılaştır</div><div style={{fontSize:11, color:'#57534e', marginTop:2}}>{city.name} {firstIlce} dahil ustalar tekliflerini iletir, sen uygun olanı seçerek iletişime geçebilirsin.</div></div>
       </div>
      </div>
     </div>
    </section>
    <section className="job-content" style={{maxWidth:1120, margin:'0 auto', padding:'18px 20px 60px', display:'grid', gridTemplateColumns:'1.2fr 0.8fr', gap:18}}>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <h3>✅ Neden {city.name}'da {job.name} için Hemen Ustam Gelsin?</h3>
      <ul style={{fontSize:13, color:'#44403c', lineHeight:1.6}}>
       <li>{city.name} {firstIlce} için HugAI tahmini piyasa fiyatı - {seoData.fiyatBilgisi}</li>
       <li>{city.name} genelinde {ilceCount} ilçede usta eşleştirme ve teklif alma</li>
       <li>{SLOGAN_FULL}</li>
      </ul>
      <h4>Sık Sorulan Sorular</h4>{seoData.faqs.map((faq:any, i:number)=>(<div key={i} style={{marginBottom:10, background:'#fafaf9', borderRadius:10, padding:10}}><div style={{fontWeight:800, fontSize:13}}>{faq.q}</div><div style={{fontSize:12, color:'#444', marginTop:4}}>{faq.a}</div></div>))}
     </div>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <div style={{fontWeight:800, fontSize:13, marginBottom:8}}>{city.name} Yakın Çevresi - {job.name}</div>
      <div style={{display:'flex', flexWrap:'wrap', gap:6}}>{getNearbyCities(city.slug).map((c)=>(<Link key={c.slug} href={`/${c.slug}/${job.slug}/`} style={{fontSize:12, padding:'7px 12px', background:'#fafaf9', border:'1px solid #e7e5e4', borderRadius:999, textDecoration:'none', color:'#444'}}>{c.name} {job.name}</Link>))}</div>
     </div>
    </section>
   </main>
  )
 }

 const district = city.districts.find(d=>d.slug===slug)
 if(district){
  const dName = district.name
  const cName = city.name
  const dLoc = loc(dName)
  const introText = buildDistrictIntro(dName, cName, dLoc, city, district)
  const localNote = getDistrictActionNote(city, district)
  const siblingDistricts = getSiblingDistricts(city, district)
  const districtServices = getDistrictServiceLinks(city, district)
  const faqs = getDistrictFAQs(city, district, dName, cName, dLoc)
  const canonical = `https://hemenustamgelsin.com/${city.slug}/${district.slug}/`
  const title = `${dName} Ustaları | ${city.name} – ${SLOGAN_LINE1}`
  const h1 = `${dName} Ustaları – ${cName}`
  const breadcrumbSchema = { "@context": "https://schema.org", "@type": "BreadcrumbList", "@id": `${canonical}#breadcrumb`, "itemListElement": [ { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com/" }, { "@type": "ListItem", "position": 2, "name": cName, "item": `https://hemenustamgelsin.com/${city.slug}/` }, { "@type": "ListItem", "position": 3, "name": dName, "item": canonical } ] }
  const faqSchema = { "@context": "https://schema.org", "@type": "FAQPage", "mainEntity": faqs.map(f => ({ "@type": "Question", "name": f.q, "acceptedAnswer": { "@type": "Answer", "text": f.a } })) }
  const serviceSchema = { "@context": "https://schema.org", "@type": "Service", "@id": `${canonical}#service`, "name": `${dName} Ustaları`, "serviceType": "Usta ve Tadilat Hizmetleri", "description": `${dLoc} usta hizmetleri. ${SLOGAN_FULL}`, "provider": { "@id": "https://hemenustamgelsin.com/#organization" }, "areaServed": [{ "@type": "City", "name": cName }, { "@type": "AdministrativeArea", "name": dName }], "url": canonical }
  const webPageSchema = { "@context": "https://schema.org", "@type": "WebPage", "@id": canonical, "name": title, "description": `${dLoc} usta bul, teklif al. ${SLOGAN_FULL}`, "isPartOf": { "@id": "https://hemenustamgelsin.com/#website" }, "about": { "@id": `${canonical}#service` }, "breadcrumb": { "@id": `${canonical}#breadcrumb` } }
  return (
   <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
    <header style={{background:'white', borderBottom:'1px solid #e7e5e4', padding:'10px 20px', position:'sticky', top:0, zIndex:50}}>
     <div style={{maxWidth:1120, margin:'0 auto', display:'flex', alignItems:'center', gap:12}}>
      <img src="/assets/hug/app_logo.png" alt="Hemen Ustam Gelsin" style={{height:72, width:'auto', objectFit:'contain'}} />
      <img src="/assets/hug/hug_logo.jpg" alt="Hug Market" style={{height:60, width:'auto', objectFit:'contain', borderLeft:'1px solid #e7e5e4', paddingLeft:14, marginLeft:6}} />
      <div style={{display:'flex', flexDirection:'column', lineHeight:1.1, marginLeft:8}}>
       <span style={{fontWeight:900, fontSize:18, letterSpacing:0.5}}>HEMEN <span style={{color:'#111'}}>USTAM</span> <span style={{color:'#dc2626'}}>GELSİN</span></span>
       <span style={{fontSize:11, color:'#111', fontWeight:800, lineHeight:1.3}}>{SLOGAN_LINE1} {SLOGAN_LINE2}</span>
      </div>
     </div>
    </header>
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }} />
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(serviceSchema) }} />
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(webPageSchema) }} />
    <div style={{maxWidth:1120, margin:'0 auto', padding:'14px 20px 0'}}>
      <Breadcrumb items={[{ name: cName, href: `/${city.slug}/` }, { name: dName, href: `/${city.slug}/${district.slug}/` }]} />
    </div>
    <div style={{maxWidth:1120, margin:'12px auto 0', padding:'0 20px'}}>
      <div style={{background:'#111', borderRadius:14, padding:'12px 16px', display:'flex', justifyContent:'space-between', alignItems:'center', gap:12, flexWrap:'wrap'}}>
        <div style={{display:'flex', alignItems:'center', gap:12}}>
          <div style={{width:36, height:36, background:'white', borderRadius:8, display:'grid', placeItems:'center', fontSize:20}}>📱</div>
          <div>
            <div style={{color:'white', fontWeight:800, fontSize:14}}>{dName} YAYINDA! %0 Komisyon - Uygulamadan Bul</div>
            <div style={{color:'#a8a29e', fontSize:12}}>{dLoc} ustanı mobil uygulamadan bul, hızlı teklif al.</div>
          </div>
        </div>
        <a href={PLAY_URL_CITY_SLUG} target="_blank" rel="noopener" style={{background:'white', color:'black', padding:'10px 16px', borderRadius:10, fontWeight:800, fontSize:13, textDecoration:'none', whiteSpace:'nowrap'}}>【entity-Google Play¦canonical_name=Google Play】'den İndir →</a>
      </div>
    </div>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'20px 20px 0'}}>
     <div style={{background:'#FFFBF5', border:'1px solid #111', borderRadius:12, padding:'12px 14px', fontSize:13, fontWeight:700, color:'#111'}}>
      {dLoc} usta bul. {SLOGAN_FULL} • {localNote}
     </div>
    </section>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'20px 20px'}}>
     <h1 style={{fontSize:'clamp(28px, 4vw, 42px)', fontWeight:900, margin:0}}>{h1}</h1>
     <p style={{fontSize:15, color:'#44403c', marginTop:12, lineHeight:1.7, maxWidth:760}}>{introText}</p>
    </section>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 20px'}}>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <div style={{fontWeight:900, fontSize:16}}>BİRLİKTE BÜYÜYÜP BİRLİKTE KAZANACAĞIZ</div>
      <div style={{fontSize:13, color:'#57534e', marginTop:8, lineHeight:1.6}}>
       Biz yeni bir platformuz. Şu an için abartılı sayılar paylaşmıyoruz. Kendimize güveniyoruz, şeffaf ilerliyoruz ve her yeni ilanda sistemimiz güçleniyor.
       Amacımız {dName} ve {cName} genelinde usta ile müşteriyi doğrudan, komisyonsuz ve dürüst bir şekilde buluşturmak. Yalansız, şişirme istatistik olmadan büyüyoruz.
      </div>
      <div style={{marginTop:10, display:'flex', gap:8, flexWrap:'wrap'}}>
       <span style={{fontSize:11, padding:'6px 10px', background:'#fafaf9', border:'1px solid #e7e5e4', borderRadius:999, fontWeight:700}}>🚀 YENİYİZ</span>
       <span style={{fontSize:11, padding:'6px 10px', background:'#f0fdf4', border:'1px solid #bbf7d0', borderRadius:999, fontWeight:700}}>🤝 ŞEFFAFIZ</span>
       <span style={{fontSize:11, padding:'6px 10px', background:'#fffbeb', border:'1px solid #fde68a', borderRadius:999, fontWeight:700}}>💪 KENDİMİZE GÜVENİYORUZ</span>
      </div>
     </div>
    </section>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 20px'}}>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <div style={{fontWeight:900, fontSize:16, marginBottom:14}}>{dName} Ustaları - Canlı</div>
      <UstaLiveGrid citySlug={city.slug} districtSlug={district.slug} dName={dName} cName={cName} />
     </div>
    </section>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 20px'}}>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>NASIL ÇALIŞIR?</div>
      <div style={{display:'grid', gridTemplateColumns:'repeat(auto-fit, minmax(200px, 1fr))', gap:12}}>
       <div style={{background:'#fafaf9', borderRadius:12, padding:12}}><b>1. İşini belirt</b><div style={{fontSize:12, color:'#57534e', marginTop:4}}>{dLoc} ihtiyacını anlat.</div></div>
       <div style={{background:'#f0fdf4', border:'1px solid #bbf7d0', borderRadius:12, padding:12}}><b>2. HugAI tahmini fiyatı gör</b><div style={{fontSize:12, color:'#166534', marginTop:4}}>HugAI {dName} için tahmini piyasa fiyat aralığını gösterir.</div></div>
       <div style={{background:'#fafaf9', borderRadius:12, padding:12}}><b>3. Teklifleri karşılaştır</b><div style={{fontSize:12, color:'#57534e', marginTop:4}}>{cName} ustaları {dName} için tekliflerini iletir.</div></div>
       <div style={{background:'#fafaf9', borderRadius:12, padding:12}}><b>4. Ustanı seç</b><div style={{fontSize:12, color:'#57534e', marginTop:4}}>{dLoc} uygun usta ile iletişime geç ve süreci başlat.</div></div>
      </div>
     </div>
    </section>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 20px'}}>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>{dName} İçin Hizmetler</div>
      <div style={{display:'flex', flexWrap:'wrap', gap:8}}>
       {districtServices.map(s=>(<Link key={s.slug} href={`/${city.slug}/${s.slug}/`} style={{fontSize:12, padding:'8px 12px', background:'#fafaf9', border:'1px solid #e7e5e4', borderRadius:999, textDecoration:'none', color:'#444'}}>{cName} {s.name}</Link>))}
      </div>
     </div>
    </section>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 20px'}}>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>{cName} Diğer İlçeler - {siblingDistricts.length} ilçe tamamı</div>
      <div style={{display:'flex', flexWrap:'wrap', gap:8}}>
       {siblingDistricts.map(d=>(<Link key={d.slug} href={`/${city.slug}/${d.slug}/`} style={{fontSize:12, padding:'8px 12px', background:'#fffbeb', border:'1px solid #fde68a', borderRadius:999, textDecoration:'none', color:'#92400e'}}>{d.name}</Link>))}
      </div>
     </div>
    </section>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 20px'}}><Link href={`/${city.slug}/`} style={{fontSize:13, fontWeight:800, color:'#111', textDecoration:'none', background:'white', border:'1px solid #e7e5e4', padding:'10px 14px', borderRadius:12, display:'inline-block'}}>← {cName} Ustalarına Dön</Link></section>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 20px'}}>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <h3 style={{marginTop:0}}>Sık Sorulan Sorular - {dName}</h3>
      {faqs.map((f,i)=>(<div key={i} style={{marginBottom:10, background:'#fafaf9', borderRadius:10, padding:12}}><div style={{fontWeight:800, fontSize:13}}>{f.q}</div><div style={{fontSize:12, color:'#444', marginTop:4}}>{f.a}</div></div>))}
     </div>
    </section>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 40px', display:'flex', gap:10, flexWrap:'wrap'}}>
     <a href="https://www.hemenustamgelsin.com/" style={{background:'#111', color:'white', padding:'14px 20px', borderRadius:12, fontWeight:900, textDecoration:'none'}}>İLAN VER →</a>
     <a href="https://www.hemenustamgelsin.com/" style={{background:'white', color:'#111', padding:'14px 20px', borderRadius:12, fontWeight:800, border:'1px solid #e7e5e4', textDecoration:'none'}}>TEKLİF AL</a>
    </section>
   </main>
  )
 }
 notFound()
}