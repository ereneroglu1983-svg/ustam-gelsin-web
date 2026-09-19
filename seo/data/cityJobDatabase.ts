// data/cityJobDatabase.ts - HugAI + GERÇEK PROGRAMATİK SEO - HER ŞEHİR FARKLI DERT
import { cities, type City } from "./cities";
import { jobs, type Job } from "./jobs";

export type CityJobCombo = {
  city: City; job: Job; citySlug: string; jobSlug: string; url: string;
  seoTitle: string; seoDescription: string; metaTitle: string; metaDescription: string;
  h1: string; intro: string; fiyatM2: string; ortalamaFiyat: string;
  degiskenler: string; ilceler: string[]; faqs: { q: string; a: string }[];
};

function hash(str: string): number {
  let h = 0; for(let i=0;i<str.length;i++) h = (h*31 + str.charCodeAt(i)) % 1000000; return h;
}
function pick<T>(arr: T[], seed: string): T {
  return arr[hash(seed) % arr.length];
}

function getCityProfile(slug: string) {
  const rutubetli = ['izmir','antalya','mugla','aydin','mersin','adana','hatay','trabzon','rize','samsun','ordu','giresun','istanbul','balikesir','canakkale','yalova'];
  const soguk = ['erzurum','kars','ardahan','agri','van','mus','bitlis','hakkari','erzincan','bayburt','sivas','kayseri','ankara'];
  const buyuk = ['istanbul','ankara','izmir','bursa','antalya','adana','konya','gaziantep'];
  return {
    isRutubetli: rutubetli.includes(slug),
    isSoguk: soguk.includes(slug),
    isBuyuk: buyuk.includes(slug),
  }
}

function generateSeoTitle(city: City, job: Job): string {
  const profile = getCityProfile(city.slug);
  if(job.slug.includes('boya') && profile.isRutubetli) return `${city.name} Boya Ustası - HugAI ile Rutubet ve Küfe Kalıcı Çözüm`;
  if(job.slug.includes('boya') && profile.isSoguk) return `${city.name} Dış Cephe Boya - HugAI ile Isı Yalıtımlı Çözüm`;
  if(job.slug.includes('mantolama') || job.slug.includes('yalitim')) return `${city.name} Mantolama Ustası - HugAI Fiyat Tahmini | Hemen Ustam Gelsin`;

  const templates = [
    `${city.name} ${job.name} - HugAI ile Anında Fiyat Al`,
    `${city.name}'da ${job.name} - HugAI Analizli Teklif`,
    `${city.name} ${job.name} Ustası - HugAI ile Doğrulanmış Ustalar`,
  ];
  return pick(templates, city.slug+job.slug);
}

function generateSeoDescription(city: City, job: Job): string {
  const p = getCityProfile(city.slug);
  const raw = (city as any).districts?.[0];
  const ilce = typeof raw === 'string'? raw : (raw?.name || "Merkez");

  if(job.slug.includes('boya') && p.isRutubetli) {
    return `${city.name} ${ilce}'da rutubet ve küf mü var? Fotoğraf yükle, HugAI deniz nemi ve tuzlu havaya göre analiz etsin. ${city.name}'da rutubete dayanıklı boya yapan doğrulanmış ustalar, komisyonsuz.`;
  }
  if(job.slug.includes('boya') && p.isSoguk) {
    return `${city.name}'da dış cephe çatlaması ve ısı kaybı mı var? HugAI fotoğraflarını analiz eder. Kışın -15 dereceyi gören ${city.name}'da ısı yalıtımlı boya yapan ustalar, komisyonsuz teklif.`;
  }
  if(job.slug.includes('tesisat') && p.isSoguk) {
    return `${city.name}'da donan borular mı var? HugAI ile fotoğraf yükle, donma riskini analiz edelim. ${city.name} ${ilce}'da donmaya dayanıklı tesisat yapan ustalar burada.`;
  }

  return `${city.name} ${ilce} ve tüm ilçelerde ${job.name.toLowerCase()} için HugAI ile anında fiyat tahmini al. Fotoğraf yükle, ${p.isBuyuk? 'apartman onaylı ':''}doğrulanmış ustalar komisyonsuz teklif versin.`;
}

function generateRichData(city: City, job: Job) {
  const raw = (city as any).districts || (city as any).ilceler || ["Merkez"];
  const ilceler: string[] = (raw as any[]).map((x: any) => typeof x === 'string'? x : (x.name || x.slug)).slice(0, 30);
  const seed = city.slug + job.slug;
  const h = hash(seed);
  const profile = getCityProfile(city.slug);

  const isPahali = ['istanbul','ankara','izmir','antalya','bursa','mugla'].includes(city.slug);
  const fiyatBase = isPahali? 180 + (h % 120) : 90 + (h % 90);
  const ortMin = isPahali? 3500 + (h % 3000) : 1800 + (h % 2000);
  const ortMax = ortMin + 4000 + (h % 6000);

  let intro = "";
  let degiskenler = "";
  let fiyatM2 = `m² ${fiyatBase}₺'den başlayan`;

  if(job.slug.includes('boya') || job.slug.includes('badana')) {
    if(profile.isRutubetli) {
      intro = `${city.name} ${ilceler[0]} bölgesinde evde rutubet, küf lekesi ve boya kabarması çok yaygın. HugAI fotoğraflarını analiz eder, denizden gelen nem ve tuzlu havanın boyaya etkisini hesaplar. Kuzey cepheli evlerde boyayı 1 yılda eskitecek rutubeti tespit eder. Biz ${city.name}'da HugAI analizine göre rutubete dayanıklı, küf önleyici astar + silinebilir silikonlu boya yapan ustalarla eşleştiriyoruz.`;
      degiskenler = `Rutubet seviyesi, küf durumu, silinebilir boya tipi, ${pick(['tuzlu hava dayanımı','HugAI nem analizi','balkon cephesi'],seed)}`;
      fiyatM2 = `HugAI rutubet analizi dahil m² ${fiyatBase}₺ - ${fiyatBase+70}₺`;
    } else if(profile.isSoguk) {
      intro = `${city.name}'da dış cephe boyası sadece estetik değil, ısı yalıtımı demek. HugAI dış cephe fotoğraflarını analiz eder, çatlak ve ısı kaybı noktalarını bulur. Kışın -20'yi gören ${city.name} ${ilceler[0]} bölgesinde mantolama olmadan boya 1 kışta çatlar. HugAI'ye göre fileli, ısı yalıtımlı, elastik boya yapan ustalarla eşleştiriyoruz.`;
      degiskenler = `Mantolama var mı?, dış cephe çatlağı, HugAI ısı analizi, ${pick(['kar ve don dayanımı','file uygulaması'],seed)}`;
      fiyatM2 = `HugAI ısı analizi dahil m² ${fiyatBase+50}₺'den başlayan`;
    } else {
      intro = `${city.name} ${ilceler[0]} bölgesinde ${job.name.toLowerCase()} için HugAI ile anında analiz. Fotoğraf yükle, HugAI metrekare ve duvar durumunu analiz etsin. ${profile.isBuyuk? 'Apartman dairesi, site yönetimi kurallarına uygun, eşyalı evde titiz çalışma.': 'Müstakil ve apartman için hızlı çözüm.'}`;
      degiskenler = `Metrekare, boya markası, kat sayısı, HugAI duvar analizi`;
    }
  }
  else if(job.slug.includes('tesisat') || job.slug.includes('su')) {
    if(profile.isSoguk) {
      intro = `${city.name}'da kışın en büyük sorun donan su boruları. HugAI bodrum ve kolon hattı fotoğraflarını analiz eder, donma riskini hesaplar. Özellikle ${ilceler[0]} bölgesinde eski binalarda risk yüksek. HugAI analizine göre boru yalıtımı yapan ustalara yönlendiriyoruz.`;
      degiskenler = `Donma riski, bina yaşı, HugAI boru analizi, ${pick(['kolon hattı','bodrumda donma'],seed)}`;
    } else {
      intro = `${city.name} ${ilceler[0]} bölgesinde su kaçağı için HugAI fotoğraftan kaçak yerini tahmin eder, ustalara iletir.`;
      degiskenler = `Kaçak yeri, HugAI analizi, fayans durumu, daire katı`;
    }
  }
  else {
    intro = `${city.name} ${ilceler[0]} bölgesinde ${job.name.toLowerCase()} için HugAI ile anında fiyat tahmini. Fotoğraf yükle, HugAI analiz etsin, ${city.name}'ın ${ilceler.length} ilçesinde doğrulanmış ustalar komisyonsuz teklif versin.`;
    degiskenler = `Metrekare, malzeme kalitesi, HugAI analizi, ${pick(['ulaşım','kat sayısı'],seed)}`;
  }

  const faqs = [
    { q: `${city.name} ${job.name} fiyatları ne kadar?`, a: `${city.name} ${ilceler[0]} için HugAI tahmini ${fiyatM2}. Ortalama ${ortMin}₺ - ${ortMax}₺. ${profile.isRutubetli && job.slug.includes('boya')? 'HugAI rutubetli bölge olduğu için küf önleyici astar önerir.':''} ${profile.isSoguk && job.slug.includes('boya')? 'HugAI soğuk bölge olduğu için ısı yalıtımlı boya önerir.':''} Net tahmin için fotoğraf yükle, HugAI analiz etsin.` },
    { q: `HugAI nasıl fiyat tahmini yapar?`, a: `HugAI fotoğraf ve ölçülerini analiz eder. ${city.name}'ın ${profile.isRutubetli? 'nemli ve rutubetli iklimini': profile.isSoguk? 'sert kışını': 'iklimini'} hesaba katar. ${degiskenler} gibi detaylara bakar ve yaklaşık maliyet çıkarır. Ustalar bu tahmine göre komisyonsuz teklif verir.` },
    { q: `${city.name}'da komisyon var mı?`, a: `Hayır. ${city.name}'da hakedişin %100'ü ustanın. Hemen Ustam Gelsin'de komisyon yok. HugAI ile şeffaf fiyat, direkt ustayla anlaşma.` },
  ];

  return {
    h1: `${city.name} ${job.name}`,
    intro, fiyatM2, ortalamaFiyat: `${ortMin}₺ - ${ortMax}₺`, degiskenler,
    ilceler: ilceler.slice(0,12),
    faqs
  }
}

export function getAllCityJobCombos(){ return cities.flatMap(city => jobs.map(job => { const rich = generateRichData(city, job); return { city, job, citySlug: city.slug, jobSlug: job.slug, url: `/${city.slug}/${job.slug}`, seoTitle: generateSeoTitle(city,job), seoDescription: generateSeoDescription(city,job), metaTitle: generateSeoTitle(city,job), metaDescription: generateSeoDescription(city,job),...rich } })); }
export function getAllCityJobParams(){ return cities.flatMap(city => jobs.map(job => ({ city: city.slug, job: job.slug }))); }
export function getCityJob(citySlug: string, jobSlug: string){ const city = cities.find(c => c.slug === citySlug); const job = jobs.find(j => j.slug === jobSlug); if(!city||!job) return null; const rich = generateRichData(city,job); return { city, job, citySlug, jobSlug, url: `/${citySlug}/${jobSlug}`, seoTitle: generateSeoTitle(city,job), seoDescription: generateSeoDescription(city,job), metaTitle: generateSeoTitle(city,job), metaDescription: generateSeoDescription(city,job),...rich }; }
export const getCityJobData = getCityJob;
export function isValidCityJob(a:string,b:string){ return!!getCityJob(a,b); }
export const TOTAL_COMBOS = cities.length * jobs.length;