import { cities } from '../../../../data/cities'
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
  const canonical = `https://hemenustamgelsin.com/usta-is-ilanlari/${city.slug}/${job.slug}`
  return {
    title: seoData.metaTitle,
    description: seoData.metaDescription,
    alternates: { canonical },
    openGraph: {
      title: seoData.metaTitle,
      description: seoData.metaDescription,
      url: canonical,
      type: 'website',
      locale: 'tr_TR',
      siteName: 'Hemen Ustam Gelsin'
    },
    twitter: {
      card: 'summary_large_image',
      title: seoData.metaTitle,
      description: seoData.metaDescription
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
  validThrough.setDate(now.getDate() + 60) // 60 gün geçerli

  const jobPostingSchema = {
    "@context": "https://schema.org",
    "@type": "JobPosting",
    "title": `${city.name} ${job.name} İş İlanları`,
    "description": seoData.metaDescription + "\n\n" + seoData.intro,
    "datePosted": now.toISOString(),
    "validThrough": validThrough.toISOString(),
    "employmentType": "CONTRACTOR",
    "applicantLocationRequirements": {
      "@type": "Country",
      "name": "Turkey"
    },
    "jobLocation": {
      "@type": "Place",
      "address": { "@type": "PostalAddress", "addressLocality": city.name, "addressCountry": "TR" }
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
    "mainEntity": seoData.faqs.map((faq: any) => ({
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
              <span>{city.name.toUpperCase()} • %0 HAKEDİŞ KOMİSYONU • ŞEFFAF TEKLİF ÜCRETİ</span>
            </div>
            <h1 style={{fontSize:'clamp(28px, 4vw, 42px)', fontWeight:900, lineHeight:0.92, margin:0}}>{seoData.h1}</h1>
            <p style={{fontSize:15, color:'#44403c', marginTop:16, whiteSpace:'pre-line', lineHeight:1.6}}>{seoData.intro}</p>

            <div style={{marginTop:18, display:'flex', gap:10, flexWrap:'wrap'}}>
              <a href="https://hemenustamgelsin.com" style={{background:'#111', color:'white', padding:'14px 20px', borderRadius:12, fontWeight:900, textDecoration:'none'}}>USTA OL, İŞ AL →</a>
            </div>

            <div style={{marginTop:20, background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
              <div style={{fontWeight:900, marginBottom:10}}>✅ Nasıl çalışır?</div>
              {seoData.maddeler.map((m,i)=>(<div key={i} style={{fontSize:13, color:'#44403c', marginBottom:8, lineHeight:1.5}}>{m}</div>))}
            </div>
          </div>

          <div style={{display:'grid', gap:16, alignContent:'start'}}>
            <div style={{background:'white', borderRadius:18, border:'1px solid #e7e5e4', padding:16}}>
              <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>🤖 HugAI ne yapıyor?</div>
              <div style={{fontSize:12, color:'#44403c', lineHeight:1.6}}>
                Müşterinin fotoğrafları ve talebi HugAI ile analiz edilir, işin kapsamı daha anlaşılır hale getirilir. Bu analiz, teklif ücretinin hesaplanmasında kullanılan tahmini bedeldir. Son fiyatı sen belirlersin.
              </div>
              <div style={{marginTop:12, background:'#fffbeb', border:'1px solid #fde68a', borderRadius:10, padding:10, fontSize:11}}>
                Örnek: AI tahmini 20.000 TL olan bir {job.name.toLowerCase()} işi için teklif ücreti 200 TL'dir. İşi aldığında 20.000 TL üzerinden komisyon kesilmez.
              </div>
            </div>

            <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
              <div style={{fontWeight:800, fontSize:13, marginBottom:8}}>Sık Sorulan Sorular</div>
              {seoData.faqs.map((faq:any, i:number)=>(<div key={i} style={{marginBottom:12, background:'#fafaf9', borderRadius:10, padding:10}}><div style={{fontWeight:800, fontSize:13}}>{faq.q}</div><div style={{fontSize:12, color:'#444', marginTop:4, lineHeight:1.5}}>{faq.a}</div></div>))}
            </div>
          </div>
        </div>
      </section>
    </main>
  )
}