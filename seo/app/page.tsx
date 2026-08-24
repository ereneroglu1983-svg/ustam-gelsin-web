
import { cities } from '../data/cities'
import { jobs } from '../data/jobs'
import Link from 'next/link'
export default function Home(){
  return <main style={{padding:20,maxWidth:1100,margin:'0 auto'}}>
    <h1>Ustam Gelsin - 81 İl 42 İş Kolu</h1>
    <p>{cities.length * jobs.length} otomatik SEO sayfası aktif. Google için hazır.</p>
    <h2>İller</h2>
    <div style={{display:'grid',gridTemplateColumns:'repeat(auto-fill,minmax(150px,1fr))',gap:8}}>
      {cities.map(c=><Link key={c.slug} href={`/${c.slug}`} style={{padding:'8px 12px',background:'white',border:'1px solid #ddd',borderRadius:8}}>{c.name}</Link>)}
    </div>
  </main>
}
