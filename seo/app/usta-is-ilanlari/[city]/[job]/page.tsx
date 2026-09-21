import { cities, getCitySeoIntro, getCitySeoTitle, getCitySeoDescription } from '../../../../data/cities'
import { jobs } from '../../../../data/jobs'
import { getUstaCityJobData } from '../../../../data/ustaJobDatabase'
import Link from 'next/link'
import type { Metadata } from 'next'

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
  const seoData = getUstaCityJobData(city.slug, job.slug)
  if(!seoData) return {}
  const uniqueTitle = getCitySeoTitle(city.slug, job.name)
  const uniqueDesc = getCitySeoDescription(city.slug, job.name)
  const canonical = `https://hemenustamgelsin.com/usta-is-ilanlari/${city.slug}/${job.slug}`
  return {
    title: uniqueTitle,
    description: uniqueDesc,
    alternates: { canonical },
    openGraph: {
      title: uniqueTitle,
      description: uniqueDesc,
      url: canonical,
      type: 'website',
      locale: 'tr_TR',
      siteName: 'Hemen Ustam Gelsin'
    },
    twitter: {
      card: 'summary_large_image',
      title: uniqueTitle,
      description: uniqueDesc
    },
    robots: { index: true, follow: true }
  }
}

export default async function UstaJobCityPage({params}:{params: Promise<{city:string,job:string}>}){
  const { city: citySlug, job: jobSlug } = await params
  const city = cities.find(c=>c.slug===citySlug)
  const job = jobs.find(j=>j.slug===jobSlug)
  if(!city ||!job) return <div>Sayfa bulunamadı</div>
  const seoData = getUstaCityJobData(city.slug, job.slug)
  if(!seoData) return <div>Sayfa bulunamadı</div>
  const canonical = `https://hemenustamgelsin.com/usta-is-ilanlari/${city.slug}/${job.slug}`
  const now = new Date()
  const validThrough = new Date()
  validThrough.setDate(now.getDate() + 60)
  const cityIntro = getCitySeoIntro(city.slug, job.name)
  const uniqueH1 = `${city.name} ${job.name} İş İlanları - ${city.districts.slice(0,2).map(d=>d.name).join(' ve ')} Dahil`
  const combinedIntro = `${cityIntro}\n\n${seoData.intro}`
  const uniqueDescription = `${getCitySeoDescription(city.slug, job.name)} ${seoData.intro}`
  const uniqueFaqs = seoData.faqs.map((faq: any) => ({
    q: faq.q.includes(city.name)? faq.q : `${city.name} ${faq.q}`,
    a: `${city.name} ${city.region || ''} bölgesinde ${faq.a} Özellikle ${city.districts.slice(0,3).map((d:any)=>d.name).join(', ')} ilçelerinde aktif talepler var.`
  }))

  // FIXED: Search Console hataları düzeltildi
  const jobPostingSchema = {
    "@context": "https://schema.org",
    "@type": "JobPosting",
    "title": `${city.name} ${job.name} İş İlanları - ${city.region}`,
    "description": uniqueDescription,
    "datePosted": now.toISOString(),
    "validThrough": validThrough.toISOString(),
    "employmentType": "CONTRACTOR",
    "applicantLocationRequirements": { "@type": "Country", "name": "Turkey" },
    "jobLocation": {
      "@type": "Place",
      "address": {
        "@type": "PostalAddress",
        "streetAddress": `${city.districts[0]?.name || city.name} Merkez`,
        "addressLocality": city.name,
        "addressRegion": city.region || city.name,
        "postalCode": `${city.plate? String(city.plate).padStart(2,'0') : '45'}000`,
        "addressCountry": "TR"
      }
    },
    "baseSalary": {
      "@type": "MonetaryAmount",
      "currency": "TRY",
      "value": {
        "@type": "QuantitativeValue",
        "minValue": 500,
        "maxValue": 10000,
        "unitText": "DAY"
      }
    },
    "hiringOrganization": {
      "@type": "Organization",
      "name": "Hemen Ustam Gelsin",
      "url": "https://hemenustamgelsin.com",
      "logo": "https://hemenustamgelsin.com/logo.png",
      "sameAs": [
        "https://www.linkedin.com/in/hemen-ustam-gelsin-2499b2415/",
        "https://www.instagram.com/hemenustamgelsin/",
        "https://www.facebook.com/profile.php?id=61591164702200",
        "https://x.com/Hemenustamglsn",
        "https://www.tiktok.com/@hemen_ustam_gelsin",
        "https://www.youtube.com/@HemenUstamGelsin"
      ]
    }
  }

  const breadcrumbSchema = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com/" },
      { "@type": "ListItem", "position": 2, "name": "Usta İş İlanları", "item": "https://hemenustamgelsin.com/usta-is-ilanlari" },
      { "@type": "ListItem", "position": 3, "name": `${city.name} ${job.name}`, "item": canonical }
    ]
  }

  const faqSchema = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": uniqueFaqs.map((faq: any) => ({
      "@type": "Question",
      "name": faq.q,
      "acceptedAnswer": { "@type": "Answer", "text": faq.a }
    }))
  }

  return (
    <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jobPostingSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }} />
      <div style={{maxWidth:1120, margin:'0 auto', padding:'14px 20px 0', fontSize:12, color:'#a8a29e'}}>
        <Link href={`/`} style={{color:'#78716c', textDecoration:'none'}}>Ana Sayfa</Link> <span> / </span>
        <Link href={`/usta-is-ilanlari`} style={{color:'#78716c', textDecoration:'none'}}>Usta İş İlanları</Link> <span> / </span>
        <b style={{color:'#111'}}>{city.name} {job.name}</b>
      </div>
      <section style={{ padding:'26px 20px 28px' }}>
        <div style={{maxWidth:1120, margin:'0 auto', display:'grid', gridTemplateColumns:'1.15fr 0.85fr', gap:24}}>
          <div>
            <div style={{display:'inline-flex', gap:6, background:'white', border:'1px solid #e7e5e4', borderRadius:999, padding:'6px 10px', fontSize:11, fontWeight:800, marginBottom:14}}>
              <span style={{background:'#111', color:'white', borderRadius:999, padding:'2px 8px'}}>{job.name.toUpperCase()}</span>
              <span>{city.name.toUpperCase()} {city.region?.toUpperCase()} • {city.districts.length} İLÇE • %0 HAKEDİŞ</span>
            </div>
            <h1 style={{fontSize:'clamp(28px, 4vw, 42px)', fontWeight:900, lineHeight:0.92, margin:0}}>{uniqueH1}</h1>
            <p style={{fontSize:15, color:'#44403c', marginTop:16, whiteSpace:'pre-line', lineHeight:1.6}}>{combinedIntro}</p>
            <div style={{marginTop:18, display:'flex', gap:10, flexWrap:'wrap'}}>
              <a href="https://hemenustamgelsin.com" style={{background:'#111', color:'white', padding:'14px 20px', borderRadius:12, fontWeight:900, textDecoration:'none'}}>USTA OL, İŞ AL →</a>
            </div>
            <div style={{marginTop:20, background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
              <div style={{fontWeight:900, marginBottom:10}}>✅ {city.name} Nasıl çalışır?</div>
              {seoData.maddeler.map((m:string,i:number)=>(<div key={i} style={{fontSize:13, color:'#44403c', marginBottom:8, lineHeight:1.5}}>{m.replace('{city}', city.name)}</div>))}
            </div>
            <div style={{marginTop:16, background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
              <div style={{fontWeight:900, marginBottom:10}}>📍 {city.name} Hizmet Verdiğimiz İlçeler ({city.districts.length})</div>
              <div style={{fontSize:12, color:'#44403c', lineHeight:1.8}}>
                {city.districts.map((d:any)=>d.name).join(' • ')}
              </div>
              <div style={{fontSize:11, color:'#a8a29e', marginTop:8}}>{city.name} {city.region} bölgesinde yer alır, plaka kodu {city.plate}. Yukarıdaki tüm ilçelerde {job.name.toLowerCase()} talepleri için teklif verebilirsin.</div>
            </div>
          </div>
          <div style={{display:'grid', gap:16, alignContent:'start'}}>
            <div style={{background:'white', borderRadius:18, border:'1px solid #e7e5e4', padding:16}}>
              <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>🤖 HugAI {city.name} için ne yapıyor?</div>
              <div style={{fontSize:12, color:'#44403c', lineHeight:1.6}}>
                {city.name} {city.districts[0]?.name} ve {city.districts[1]?.name} başta olmak üzere tüm ilçelerden gelen fotoğraflar ve talepler HugAI ile analiz edilir. İşin kapsamı daha anlaşılır hale getirilir.
              </div>
              <div style={{marginTop:12, background:'#fffbeb', border:'1px solid #fde68a', borderRadius:10, padding:10, fontSize:11}}>
                Örnek: AI tahmini 25.000 TL olan bir {city.name} {job.name.toLowerCase()} işi için teklif ücreti 250 TL'dir. İşi aldığında 25.000 TL üzerinden komisyon kesilmez.
              </div>
            </div>
            <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
              <div style={{fontWeight:800, fontSize:13, marginBottom:8}}>{city.name} {job.name} SSS</div>
              {uniqueFaqs.map((faq:any, i:number)=>(<div key={i} style={{marginBottom:12, background:'#fafaf9', borderRadius:10, padding:10}}><div style={{fontWeight:800, fontSize:13}}>{faq.q}</div><div style={{fontSize:12, color:'#444', marginTop:4, lineHeight:1.5}}>{faq.a}</div></div>))}
            </div>
          </div>
        </div>
      </section>
    </main>
  )
}