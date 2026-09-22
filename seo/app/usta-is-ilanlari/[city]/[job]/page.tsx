import { cities, getCitySeoIntro, getCityLocative } from '../../../../data/cities'
import { jobs } from '../../../../data/jobs'
import { getUstaCityJobData } from '../../../../data/ustaJobDatabase'
import Link from 'next/link'
import { notFound } from 'next/navigation'
import type { Metadata } from 'next'

const nearbyMap: Record<string, string[]> = {
  'adana': ['mersin','osmaniye','hatay','kahramanmaras','nigde','kayseri'],'adiyaman': ['kahramanmaras','gaziantep','sanliurfa','diyarbakir','malatya'],'afyonkarahisar': ['kutahya','eskisehir','konya','isparta','denizli','usak'],'agri': ['kars','igdir','van','bitlis','mus','erzurum'],'amasya': ['samsun','tokat','corum','yozgat','cankiri'],'ankara': ['kirikkale','konya','eskisehir','cankiri','bolu','kirsehir'],'antalya': ['mugla','burdur','isparta','konya','karaman','mersin'],'artvin': ['rize','erzurum','ardahan','kars'],'aydin': ['izmir','manisa','denizli','mugla'],'balikesir': ['canakkale','bursa','kutahya','manisa','izmir'],'bilecik': ['bursa','kutahya','eskisehir','sakarya','bolu'],'bingol': ['elazig','diyarbakir','mus','erzurum','tunceli'],'bitlis': ['van','mus','siirt','batman','diyarbakir'],'bolu': ['duzce','sakarya','bursa','bilecik','eskisehir','ankara','zonguldak'],'burdur': ['antalya','isparta','afyonkarahisar','denizli','mugla'],'bursa': ['yalova','kocaeli','bilecik','kutahya','balikesir','sakarya'],'canakkale': ['balikesir','tekirdag','edirne'],'cankiri': ['ankara','bolu','karabuk','kastamonu','corum','kirikkale'],'corum': ['samsun','amasya','yozgat','kirikkale','cankiri','sinop'],'denizli': ['mugla','aydin','manisa','usak','afyonkarahisar','burdur'],'diyarbakir': ['batman','mardin','sanliurfa','adiyaman','malatya','elazig','bingol'],'edirne': ['kirklareli','tekirdag','canakkale'],'elazig': ['malatya','diyarbakir','bingol','tunceli'],'erzincan': ['erzurum','tunceli','elazig','sivas','gumushane','bayburt'],'erzurum': ['kars','agri','mus','bingol','erzincan','bayburt','rize','artvin'],'eskisehir': ['bursa','kutahya','afyonkarahisar','ankara','bolu','bilecik'],'gaziantep': ['kilis','hatay','osmaniye','kahramanmaras','adiyaman','sanliurfa'],'giresun': ['trabzon','gumushane','erzincan','sivas','ordu'],'gumushane': ['trabzon','bayburt','erzincan','giresun','rize'],'hakkari': ['van','sirnak'],'hatay': ['adana','osmaniye','gaziantep','kilis'],'isparta': ['burdur','antalya','konya','afyonkarahisar'],'mersin': ['adana','karaman','konya','nigde','antalya','kahramanmaras'],'istanbul': ['kocaeli','tekirdag','yalova','bursa','sakarya'],'izmir': ['manisa','aydin','balikesir','denizli','usak'],'kars': ['ardahan','erzurum','agri','igdir'],'kastamonu': ['sinop','corum','cankiri','karabuk','bartin'],'kayseri': ['sivas','yozgat','nevsehir','nigde','adana','kahramanmaras'],'kirklareli': ['edirne','tekirdag','istanbul'],'kirsehir': ['yozgat','nevsehir','aksaray','ankara','kirikkale'],'kocaeli': ['istanbul','sakarya','bursa','yalova'],'konya': ['ankara','aksaray','karaman','antalya','isparta','afyonkarahisar','eskisehir','nigde'],'kutahya': ['bursa','bilecik','eskisehir','afyonkarahisar','usak','manisa','balikesir'],'malatya': ['elazig','diyarbakir','adiyaman','kahramanmaras','sivas','erzincan'],'manisa': ['izmir','balikesir','kutahya','usak','denizli','aydin'],'kahramanmaras': ['osmaniye','adana','kayseri','sivas','malatya','adiyaman','gaziantep'],'mardin': ['sanliurfa','diyarbakir','batman','sirnak','siirt'],'mugla': ['aydin','denizli','burdur','antalya'],'mus': ['bingol','diyarbakir','batman','bitlis','van','agri','erzurum'],'nevsehir': ['kirsehir','aksaray','nigde','kayseri','yozgat'],'nigde': ['kayseri','adana','mersin','konya','aksaray','nevsehir'],'ordu': ['samsun','tokat','sivas','giresun'],'rize': ['trabzon','artvin','erzurum','bayburt'],'sakarya': ['kocaeli','duzce','bolu','bilecik','bursa','istanbul'],'samsun': ['ordu','tokat','amasya','corum','sinop'],'siirt': ['batman','bitlis','van','sirnak','mardin'],'sinop': ['kastamonu','corum','samsun'],'sivas': ['tokat','ordu','giresun','erzincan','malatya','kayseri','yozgat'],'tekirdag': ['istanbul','kirklareli','edirne','canakkale'],'tokat': ['amasya','samsun','ordu','sivas','yozgat'],'trabzon': ['rize','gumushane','giresun','bayburt'],'tunceli': ['erzincan','elazig','bingol','erzurum'],'sanliurfa': ['gaziantep','adiyaman','diyarbakir','mardin','sirnak'],'usak': ['manisa','kutahya','afyonkarahisar','denizli'],'van': ['agri','bitlis','siirt','sirnak','hakkari','mus'],'yozgat': ['corum','amasya','tokat','sivas','kayseri','kirsehir','cankiri','kirikkale'],'zonguldak': ['duzce','bolu','karabuk','bartin'],'aksaray': ['konya','nigde','nevsehir','kirsehir','ankara'],'bayburt': ['trabzon','rize','erzurum','erzincan','gumushane'],'karaman': ['konya','mersin','antalya'],'kirikkale': ['ankara','cankiri','corum','yozgat','kirsehir'],'batman': ['diyarbakir','mardin','siirt','bitlis','mus'],'sirnak': ['mardin','siirt','van','hakkari','sanliurfa'],'bartin': ['zonguldak','karabuk','kastamonu'],'ardahan': ['kars','artvin','erzurum'],'igdir': ['kars','agri'],'yalova': ['kocaeli','bursa','istanbul','sakarya'],'karabuk': ['bolu','kastamonu','cankiri','bartin','zonguldak'],'kilis': ['gaziantep','hatay'],'osmaniye': ['adana','hatay','gaziantep','kahramanmaras'],'duzce': ['bolu','sakarya','zonguldak'],
}

function getNearbyCities(currentSlug: string) {
  const slugs = nearbyMap[currentSlug] || []
  return cities.filter(c => slugs.includes(c.slug)).slice(0,6)
}
function getRelatedJobs(currentJobSlug: string) {
  return jobs.filter(j => j.slug!== currentJobSlug).slice(0,6)
}

export function generateStaticParams(){
  const params: {city: string, job: string}[] = []
  for(const c of cities){
    for(const j of jobs){
      params.push({city: c.slug, job: j.slug})
    }
  }
  return params
}

export async function generateMetadata({params}:{params: Promise<{city:string,job:string}>}): Promise<Metadata>{
  const { city: citySlug, job: jobSlug } = await params
  const city = cities.find(c=>c.slug===citySlug)
  const job = jobs.find(j=>j.slug===jobSlug)
  if(!city ||!job) return {}
  const seoData = getUstaCityJobData(city.name, job.name, city.region || '')
  if(!seoData) return {}
  const uniqueTitle = `${city.name} ${job.name} Ustası İş İlanları | ${city.name} ${job.name} İşi Ara - %0 Komisyon`
  const uniqueDesc = `${getCityLocative(city.name)} ${job.name.toLowerCase()} ustası işi arıyorsan doğru yerdesin. ${city.name} ${job.name.toLowerCase()} ustası iş ilanları, gerçek müşteri talepleri, komisyonsuz müşteri bul. Ücretsiz kayıt ol, %0 komisyonla iş al.`
  const canonical = `https://hemenustamgelsin.com/usta-is-ilanlari/${city.slug}/${job.slug}`
  return {
    title: uniqueTitle,
    description: uniqueDesc,
    alternates: { canonical },
    openGraph: { title: uniqueTitle, description: uniqueDesc, url: canonical, type: 'website', locale: 'tr_TR', siteName: 'Hemen Ustam Gelsin' },
    twitter: { card: 'summary_large_image', title: uniqueTitle, description: uniqueDesc },
    robots: { index: true, follow: true }
  }
}

export default async function UstaJobCityPage({params}:{params: Promise<{city:string,job:string}>}){
  const { city: citySlug, job: jobSlug } = await params
  const city = cities.find(c=>c.slug===citySlug)
  const job = jobs.find(j=>j.slug===jobSlug)
  if(!city ||!job) notFound()
  const seoData = getUstaCityJobData(city.name, job.name, city.region || '')
  if(!seoData) notFound()
  const canonical = `https://hemenustamgelsin.com/usta-is-ilanlari/${city.slug}/${job.slug}`
  const cityIntro = getCitySeoIntro(city.slug, job.name)
  const cityLoc = getCityLocative(city.name)
  const uniqueH1 = `${city.name} ${job.name} Ustası İş İlanları`
  const uniqueH2 = `${city.name} ${job.name} Ustası Olarak Günlük İş Bul, Komisyonsuz Müşteri Bul`
  const districtLine = city.districts.slice(0,3).map(d => d.name).join(', ')
  const ustaIntro = `${city.name} ${job.name.toLowerCase()} ustası işi arıyorsan doğru yerdesin.\n\n${cityLoc} ${city.districts.length} ilçeden gelen ${job.name.toLowerCase()} talepleri için komisyonsuz müşteri bulabilirsin. ${job.name} ustası olarak iş arıyorum diyorsan, ücretsiz kayıt ol, kazancın cebinde kalsın.\n\n${cityIntro}`
  const normalizedSeoFaqs = seoData.faqs.map(faq => ({
    q: faq.q.includes(city.name)? faq.q : `${city.name} ${faq.q}`,
    a: faq.a.includes(city.name)? faq.a : `${cityLoc} ${faq.a}`
  }))
  const allFaqs = [
    { q: `${city.name} ${job.name} ustası iş ilanları nerede?`, a: `${cityLoc} ${job.name.toLowerCase()} ustası iş ilanları Hemen Ustam Gelsin'de yayınlanıyor. ${districtLine} dahil tüm ilçelerden gelen gerçek müşteri taleplerini takip edebilirsin. Ücretsiz kayıt ol, %0 komisyonla çalışırsın. Teklif gönderirken teklif ücreti uygulanır; işi aldığında kazancından komisyon kesilmez.` },
    { q: `${city.name} ${job.name} ustası işi nasıl bulunur?`, a: `${cityLoc} ${job.name.toLowerCase()} ustası işi bulmak için platforma ücretsiz kayıt olman yeterli. ${cityLoc} ${job.name.toLowerCase()} arayan gerçek müşteriler seni bulur. %0 komisyonla çalışırsın. Teklif gönderirken teklif ücreti uygulanır; işi aldığında kazancından komisyon kesilmez.` },
    { q: `Komisyonsuz ${job.name} ustası platformu var mı?`, a: `Evet. Hemen Ustam Gelsin %0 komisyonlu usta platformu. ${city.name} ${job.name.toLowerCase()} işlerinde kazancının tamamı cebinde kalır. Gerçek müşteri talepleriyle çalışırsın. Teklif gönderirken teklif ücreti uygulanır; işi aldığında komisyon kesilmez.` },
...normalizedSeoFaqs
  ]
  const visibleFaqs = allFaqs.slice(0,4)
  const collectionSchema = {
    "@context": "https://schema.org",
    "@type": "CollectionPage",
    "name": `${city.name} ${job.name} Ustası İş İlanları`,
    "description": `${city.name} ${job.name.toLowerCase()} ustası iş ilanları, gerçek müşteri talepleri`,
    "url": canonical,
    "isPartOf": { "@type": "Website", "name": "Hemen Ustam Gelsin", "url": "https://hemenustamgelsin.com" }
  }
  const breadcrumbSchema = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com/" },
      { "@type": "ListItem", "position": 2, "name": "Usta İş İlanları", "item": "https://hemenustamgelsin.com/usta-is-ilanlari" },
      { "@type": "ListItem", "position": 3, "name": `${city.name} ${job.name} Ustası İş İlanları`, "item": canonical }
    ]
  }
  const faqSchema = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": visibleFaqs.map(faq => ({
      "@type": "Question",
      "name": faq.q,
      "acceptedAnswer": { "@type": "Answer", "text": faq.a }
    }))
  }
  const nearbyCities = getNearbyCities(city.slug)
  const relatedJobs = getRelatedJobs(job.slug)
  return (
    <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(collectionSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }} />
      <div style={{maxWidth:1120, margin:'0 auto', padding:'14px 20px 0', fontSize:12, color:'#a8a29e'}}>
        <Link href={`/`} style={{color:'#78716c', textDecoration:'none'}}>Ana Sayfa</Link> <span> / </span>
        <Link href={`/usta-is-ilanlari`} style={{color:'#78716c', textDecoration:'none'}}>Usta İş İlanları</Link> <span> / </span>
        <b style={{color:'#111'}}>{city.name} {job.name} Ustası İş İlanları</b>
      </div>
      <section style={{ padding:'26px 20px 28px' }}>
        <div style={{maxWidth:1120, margin:'0 auto', display:'grid', gridTemplateColumns:'1.15fr 0.85fr', gap:24}}>
          <div>
            <div style={{display:'inline-flex', gap:6, background:'white', border:'1px solid #e7e5e4', borderRadius:999, padding:'6px 10px', fontSize:11, fontWeight:800, marginBottom:14}}>
              <span style={{background:'#111', color:'white', borderRadius:999, padding:'2px 8px'}}>{job.name.toUpperCase()} USTASI İŞ İLANLARI</span>
              <span>{city.name.toUpperCase()} • {city.districts.length} İLÇE • %0 KOMİSYON</span>
            </div>
            <h1 style={{fontSize:'clamp(28px, 4vw, 42px)', fontWeight:900, lineHeight:0.92, margin:0}}>{uniqueH1}</h1>
            <h2 style={{fontSize:16, fontWeight:700, color:'#44403c', marginTop:12}}>{uniqueH2}</h2>
            <p style={{fontSize:15, color:'#44403c', marginTop:12, whiteSpace:'pre-line', lineHeight:1.6}}>{ustaIntro}</p>
            <div style={{marginTop:18, display:'flex', gap:10, flexWrap:'wrap'}}>
              <Link href="/home" style={{background:'#111', color:'white', padding:'14px 20px', borderRadius:12, fontWeight:900, textDecoration:'none'}}>ÜCRETSİZ KAYIT OL, İŞ AL →</Link>
            </div>
            <div style={{marginTop:20, background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
              <div style={{fontWeight:900, marginBottom:10}}>✅ {city.name} {job.name} Ustası İşi Nasıl Bulunur?</div>
              <div style={{fontSize:13, color:'#44403c', lineHeight:1.8}}>
                <div>1. <b>Ücretsiz kayıt ol:</b> {city.name} {job.name.toLowerCase()} ustası olarak 2 dakikada kayıt ol.</div>
                <div>2. <b>Bölgende görünür ol:</b> {districtLine} dahil {city.districts.length} ilçeden gelen gerçek talepler seni bulsun.</div>
                <div>3. <b>%0 komisyonla çalış:</b> Teklif gönderirken teklif ücreti uygulanır; işi aldığında kazancından komisyon kesilmez.</div>
              </div>
            </div>
          </div>
          <div style={{display:'grid', gap:16, alignContent:'start'}}>
            <div style={{background:'#111', color:'white', borderRadius:18, padding:16}}>
              <div style={{fontWeight:900, fontSize:14, marginBottom:8}}>💰 Kazancın Cebinde Kalır</div>
              <div style={{fontSize:12, lineHeight:1.6, color:'#e7e5e4'}}>{city.name} {job.name.toLowerCase()} ustası işlerinde %0 komisyonla çalışırsın. Teklif ücreti uygulanır; işi aldığında komisyon kesilmez.</div>
              <div style={{marginTop:12, background:'white', color:'#111', borderRadius:10, padding:10, fontSize:12, fontWeight:800, textAlign:'center'}}>%0 KOMİSYON - KAZANCIN CEBİNDE KALIR</div>
            </div>
            <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
              <div style={{fontWeight:800, fontSize:13, marginBottom:12}}>{city.name} {job.name} Ustası SSS</div>
              {visibleFaqs.map((faq, i)=>(<div key={i} style={{marginBottom:12, background:'#fafaf9', borderRadius:10, padding:10}}><div style={{fontWeight:800, fontSize:13}}>{faq.q}</div><div style={{fontSize:12, color:'#444', marginTop:4, lineHeight:1.5}}>{faq.a}</div></div>))}
            </div>
            <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
              <div style={{fontWeight:800, fontSize:13, marginBottom:12}}>{city.name} {job.name} Ustası - İlçelerde İş Ara</div>
              <div style={{display:'flex', flexWrap:'wrap', gap:6}}>
                {city.districts.slice(0,12).map(d => (
                  <Link key={d.slug} href={`/usta-is-ilanlari/${city.slug}/${job.slug}#${d.slug}`} style={{fontSize:12, background:'#fafaf9', border:'1px solid #e7e5e4', padding:'6px 10px', borderRadius:999, textDecoration:'none', color:'#44403c'}}>{d.name} {job.name} Ustası İşi</Link>
                ))}
              </div>
              <div style={{fontSize:11, color:'#a8a29e', marginTop:10}}>{city.name} {cityLoc} {city.districts.length} ilçede gerçek {job.name.toLowerCase()} taleplerini takip et, %0 komisyonla iş al.</div>
            </div>
          </div>
        </div>
      </section>
      <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 60px', display:'grid', gridTemplateColumns:'1fr 1fr', gap:18}}>
        <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
          <div style={{fontWeight:800, fontSize:13, marginBottom:12}}>📍 Yakın Şehirlerde {job.name} Ustası İş İlanları</div>
          <div style={{display:'flex', flexWrap:'wrap', gap:6}}>
            {nearbyCities.map(c=>(<Link key={c.slug} href={`/usta-is-ilanlari/${c.slug}/${job.slug}`} style={{fontSize:12, padding:'7px 12px', background:'#fafaf9', border:'1px solid #e7e5e4', borderRadius:999, textDecoration:'none', color:'#444'}}>{c.name} {job.name} Ustası İş İlanları</Link>))}
          </div>
        </div>
        <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
          <div style={{fontWeight:800, fontSize:13, marginBottom:12}}>🛠 {city.name} Diğer Usta İş İlanları</div>
          <div style={{display:'flex', flexWrap:'wrap', gap:6}}>
            {relatedJobs.map(rj=>(<Link key={rj.slug} href={`/usta-is-ilanlari/${city.slug}/${rj.slug}`} style={{fontSize:12, padding:'7px 12px', background:'#fafaf9', border:'1px solid #e7e5e4', borderRadius:999, textDecoration:'none', color:'#444'}}>{city.name} {rj.name} Ustası İş İlanları</Link>))}
          </div>
        </div>
      </section>
    </main>
  )
}