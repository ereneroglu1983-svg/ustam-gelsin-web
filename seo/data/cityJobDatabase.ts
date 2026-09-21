// data/cityJobDatabase.ts - FINAL v5 - ALAN ADI DÜZELTİLDİ + DİLBİLGİSİ + SOĞUK METİN DARALTILDI
import { cities, type City } from "./cities";
import { jobs, type Job } from "./jobs";

export type CityJobCombo = {
  city: City;
  job: Job;
  citySlug: string;
  jobSlug: string;
  url: string;
  seoTitle: string;
  seoDescription: string;
  metaTitle: string;
  metaDescription: string;
  h1: string;
  intro: string;
  fiyatBilgisi: string;
  fiyatAraligi: string;
  degiskenler: string;
  ilceler: string[];
  faqs: { q: string; a: string }[];
};

function hash(str: string): number {
  let h = 0;
  for (let i = 0; i < str.length; i++) h = (h * 31 + str.charCodeAt(i)) % 1000000;
  return h;
}
function pick<T>(arr: T[], seed: string): T {
  return arr[hash(seed) % arr.length];
}

function getCityProfile(slug: string) {
  const rutubetli = ['izmir','antalya','mugla','aydin','mersin','adana','hatay','trabzon','rize','samsun','ordu','giresun','istanbul','balikesir','canakkale','yalova'];
  const soguk = ['erzurum','kars','ardahan','agri','van','mus','bitlis','hakkari','erzincan','bayburt','sivas','kayseri','ankara'];
  return {
    isRutubetli: rutubetli.includes(slug),
    isSoguk: soguk.includes(slug),
  }
}

function generateSeoTitle(city: City, job: Job): string {
  const profile = getCityProfile(city.slug);
  if (job.slug === 'dis-cephe-boya-ve-mantolama' && profile.isRutubetli) {
    return `${city.name} Dış Cephe Boya - Rutubet ve Neme Dayanıklı Çözüm | Hemen Ustam Gelsin`;
  }
  if (job.slug === 'dis-cephe-boya-ve-mantolama' && profile.isSoguk) {
    return `${city.name} Dış Cephe Boya - Soğuk İklime Uygun Çözüm | Hemen Ustam Gelsin`;
  }
  if (job.slug.includes('mantolama')) {
    return `${city.name} Mantolama Ustası - HugAI Fiyat Tahmini | Hemen Ustam Gelsin`;
  }
  const templates = [
    `${city.name} ${job.name} - HugAI ile Anında Fiyat Al`,
    `${city.name}'da ${job.name} - HugAI Analizli Teklif`,
    `${city.name} ${job.name} Ustası - Hemen Ustam Gelsin`,
  ];
  return pick(templates, city.slug + job.slug);
}

function generateSeoDescription(city: City, job: Job): string {
  const p = getCityProfile(city.slug);
  if (job.slug === 'dis-cephe-boya-ve-mantolama' && p.isRutubetli) {
    return `${city.name} genelinde rutubet ve küf nedeniyle boya sorunu mu var? Fotoğraf yükle, HugAI duruma göre tahmini maliyet çıkarsın. ${city.name} genelinde rutubete dayanıklı boya yapan ustalar, ustanın hakedişinden başarı komisyonu alınmaz.`;
  }
  if (job.slug === 'dis-cephe-boya-ve-mantolama' && p.isSoguk) {
    return `${city.name} genelinde dış cephede çatlama ve yalıtım ihtiyacı mı var? Fotoğraf yükle, HugAI tahmini maliyet çıkarsın. ${city.name} genelinde ısı yalıtımına uygun boya yapan ustalar, ustanın hakedişinden başarı komisyonu alınmaz.`;
  }
  if (job.slug.includes('tesisat') && p.isSoguk) {
    return `${city.name} genelinde tesisat sorunları için fotoğraf yükle, HugAI tahmini aralık çıkarsın. ${city.name} genelinde tesisat yapan ustalar burada, ustanın hakedişinden başarı komisyonu alınmaz.`;
  }
  return `${city.name} genelinde ${job.name.toLowerCase()} için HugAI ile anında fiyat tahmini al. Fotoğraf yükle, ustalar, hakedişlerinden başarı komisyonu alınmadan teklif versin.`;
}

function generateRichData(city: City, job: Job) {
  const ilceler: string[] = city.districts.map(d => d.name);
  const seed = city.slug + job.slug;
  const profile = getCityProfile(city.slug);

  let intro = "";
  let degiskenler = "";
  const fiyatBilgisi = `HugAI tahmini sonrası belirlenir`;
  const fiyatAraligi = `HugAI keşfi sonrası belirlenir`;

  if (job.slug === 'dis-cephe-boya-ve-mantolama') {
    if (profile.isRutubetli) {
      intro = `${city.name} genelinde rutubet ve küf lekesi nedeniyle boya kabarması yaygın görülür. HugAI yüklediğin fotoğraflara göre duvarın durumuna bakarak sana özel tahmini maliyet aralığı çıkarır. ${city.name} genelinde rutubete dayanıklı boya uygulaması yapan ustalarla eşleştiriyoruz.`;
      degiskenler = `Rutubet seviyesi, küf durumu, boya tipi, ${pick(['cephe yönü','havalandırma durumu','HugAI görsel analizi'], seed)}`;
    } else if (profile.isSoguk) {
      intro = `${city.name} genelinde dış cephe boyası kış koşullarında daha çabuk yıpranabilir. HugAI yüklediğin fotoğraflara göre genel durumu değerlendirerek sana özel tahmini maliyet çıkarır. ${city.name} genelinde yalıtıma uygun boya uygulaması yapan ustalarla eşleştiriyoruz.`;
      degiskenler = `Mantolama durumu, dış cephe çatlağı, HugAI görsel analizi, ${pick(['bina yaşı','kat sayısı'], seed)}`;
    } else {
      intro = `${city.name} genelinde dış cephe boya ve mantolama için HugAI ile anında analiz. Fotoğraf yükle, HugAI duvar durumuna göre sana özel tahmini aralık çıkarsın.`;
      degiskenler = `Mantolama durumu, metrekare, kat sayısı, HugAI görsel analizi`;
    }
  }
  else if (job.slug === 'ic-cephe-boya-ve-badana' || job.slug === 'italyan-boya-ve-dekoratif-siva') {
    if (profile.isRutubetli) {
      intro = `${city.name} genelinde iç cephede rutubet ve küf nedeniyle boya kabarması yaygın görülür. HugAI yüklediğin fotoğraflara göre duvarın durumuna bakarak sana özel tahmini maliyet aralığı çıkarır. ${city.name} genelinde iç cephe boya uygulaması yapan ustalarla eşleştiriyoruz.`;
      degiskenler = `Rutubet seviyesi, küf durumu, boya tipi, ${pick(['oda sayısı','HugAI görsel analizi'], seed)}`;
    } else {
      intro = `${city.name} genelinde ${job.name.toLowerCase()} için HugAI ile anında analiz. Fotoğraf yükle, HugAI duvar durumuna göre sana özel tahmini aralık çıkarsın. ${city.name} genelinde uygun ustalarla hızlı eşleşme.`;
      degiskenler = `Metrekare, boya markası, kat sayısı, HugAI görsel analizi`;
    }
  }
  else if (job.slug.includes('tesisat')) {
    if (profile.isSoguk) {
      intro = `${city.name} genelinde kış aylarında tesisat sorunları daha sık yaşanır. HugAI yüklediğin fotoğraflara göre tesisatın genel durumuna bakarak sana özel tahmini maliyet aralığı çıkarır. ${city.name} genelinde tesisat işi yapan ustalara yönlendiriyoruz.`;
      degiskenler = `Bina yaşı, tesisat tipi, HugAI görsel analizi, ${pick(['kolon hattı','bodrum durumu'], seed)}`;
    } else {
      intro = `${city.name} genelinde su kaçağı ve tesisat sorunları için fotoğraf yükle, HugAI görsel duruma göre sana özel tahmini aralık çıkarsın. ${city.name} genelinde uygun ustalarla eşleştiriyoruz.`;
      degiskenler = `Kaçak yeri, HugAI görsel analizi, fayans durumu, daire katı`;
    }
  }
  else {
    intro = `${city.name} genelinde ${job.name.toLowerCase()} için HugAI ile anında fiyat tahmini. Fotoğraf yükle, HugAI görsel analize göre sana özel tahmini aralık çıkarsın, ${city.name}'ın ${ilceler.length} ilçesinde uygun ustalar ustanın hakedişinden başarı komisyonu alınmadan teklif versin.`;
    degiskenler = `Metrekare, malzeme kalitesi, HugAI görsel analizi, ${pick(['ulaşım','kat sayısı'], seed)}`;
  }

  const faqs = [
    {
      q: `${city.name} ${job.name} fiyatları ne kadar?`,
      a: `${city.name} genelinde fiyat HugAI analizine göre sana özel belirlenir, sabit liste fiyatı yoktur. ${profile.isRutubetli && job.slug === 'dis-cephe-boya-ve-mantolama' ? 'Rutubetli bölge olduğu için küf önleyici astar gündeme gelebilir.' : ''} ${profile.isSoguk && job.slug === 'dis-cephe-boya-ve-mantolama' ? 'Soğuk bölge olduğu için ısı yalıtımına uygun ürünler gündeme gelebilir.' : ''} Net tahmin için fotoğraf yükle, HugAI görsel analiz yapsın.`
    },
    {
      q: `HugAI nasıl fiyat tahmini yapar?`,
      a: `HugAI fotoğraf ve verdiğin bilgilere göre analiz eder. ${city.name}'ın ${profile.isRutubetli ? 'nemli iklimini' : profile.isSoguk ? 'kış koşullarını' : 'iklimini'} dikkate alarak sana özel yaklaşık bir aralık çıkarır. ${degiskenler} gibi detaylara bakar ve tahmini maliyet oluşturur. Bu tahmin sadece sana gösterilir, ustalar kendi yerinde keşfine göre teklif verir.`
    },
    {
      q: `${city.name}'da komisyon var mı?`,
      a: `Hayır. ${city.name} genelinde ustanın hakedişinden başarı komisyonu alınmaz. HugAI ile şeffaf fiyat aralığı görür, direkt ustayla anlaşırsın.`
    },
  ];

  return {
    h1: `${city.name} ${job.name}`,
    intro,
    fiyatBilgisi,
    fiyatAraligi,
    ilceler,
    faqs,
  }
}

export function getAllCityJobCombos() {
  return cities.flatMap(city => jobs.map(job => {
    const rich = generateRichData(city, job);
    return {
      city, job, citySlug: city.slug, jobSlug: job.slug,
      url: `/${city.slug}/${job.slug}`,
      seoTitle: generateSeoTitle(city, job),
      seoDescription: generateSeoDescription(city, job),
      metaTitle: generateSeoTitle(city, job),
      metaDescription: generateSeoDescription(city, job),
      ...rich
    }
  }));
}
export function getAllCityJobParams() { return cities.flatMap(city => jobs.map(job => ({ city: city.slug, job: job.slug }))); }
export function getCityJob(citySlug: string, jobSlug: string) {
  const city = cities.find(c => c.slug === citySlug);
  const job = jobs.find(j => j.slug === jobSlug);
  if (!city || !job) return null;
  const rich = generateRichData(city, job);
  return {
    city, job, citySlug, jobSlug,
    url: `/${citySlug}/${jobSlug}`,
    seoTitle: generateSeoTitle(city, job),
    seoDescription: generateSeoDescription(city, job),
    metaTitle: generateSeoTitle(city, job),
    metaDescription: generateSeoDescription(city, job),
    ...rich
  };
}
export const getCityJobData = getCityJob;
export function isValidCityJob(a: string, b: string) { return !!getCityJob(a, b); }
export const TOTAL_COMBOS = cities.length * jobs.length;