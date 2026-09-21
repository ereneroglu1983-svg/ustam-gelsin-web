// data/ustaJobDatabase.ts - USTA İŞ ARAMA SEO - DÜRÜST VE ŞEFFAF
// FINAL v5 - TURKCE EK DUZELTILDI - FAKE ILAN YOK
// %0 HAKEDİŞ KOMİSYONU + %1 TEKLİF ÜCRETİ

import { cities, type City } from "./cities";
import { jobs, type Job } from "./jobs";

export type UstaCityJobCombo = {
  city: City; job: Job; citySlug: string; jobSlug: string; url: string;
  seoTitle: string; seoDescription: string; metaTitle: string; metaDescription: string;
  h1: string; intro: string; maddeler: string[]; ilceler: string[]; faqs: { q: string; a: string }[];
};

// TURKCE LOKATIF EK - Ankara'da / İzmir'de / Antep'te
export function getCityLocative(cityName: string): string {
  const lower = cityName.toLocaleLowerCase('tr-TR');
  const hardConsonants = ['f','s','t','k','ç','ş','h','p'];
  const lastChar = lower[lower.length - 1];
  const isHard = hardConsonants.includes(lastChar);
  const vowels = ['a','e','ı','i','o','ö','u','ü'];
  let lastVowel = 'a';
  for (let i = lower.length - 1; i >= 0; i--) {
    if (vowels.includes(lower[i])) {
      lastVowel = lower[i];
      break;
    }
  }
  const isKalın = ['a','ı','o','u'].includes(lastVowel);
  const suffix = isKalın? (isHard? "ta" : "da") : (isHard? "te" : "de");
  return `${cityName}'${suffix}`;
}

function hash(str: string): number {
  let h = 0;
  for(let i=0;i<str.length;i++) h = (h*31 + str.charCodeAt(i)) % 1000000;
  return h;
}
function pick<T>(arr: T[], seed: string): T {
  return arr[hash(seed) % arr.length];
}

function generateUstaSeoTitle(city: City, job: Job): string {
  const templates = [
    `${city.name} ${job.name} İş Ara - %0 Hakediş Komisyonu | Hemen Ustam Gelsin`,
    `${getCityLocative(city.name)} ${job.name} Mısın? Müşterini Bul, %0 Komisyon | Hemen Ustam Gelsin`,
  ];
  return pick(templates, city.slug+job.slug+"usta");
}

function generateUstaSeoDescription(city: City, job: Job, ilceler: string[]): string {
  const ilce1 = ilceler[0] || "Merkez";
  const ilce2 = ilceler[1] || ilce1;
  return `${getCityLocative(city.name)} ${job.name.toLowerCase()} ustasıysan yeni müşterilere ulaş. Hakedişinden komisyon kesilmez. Teklif için AI tahmini iş bedelinin %1'i kadar teklif ücreti uygulanır. ${ilce1}, ${ilce2} ve tüm ${city.name}.`;
}

function getIlceNames(city: City): string[] {
  const raw = city.districts;
  if (!raw || raw.length === 0) return ["Merkez"];
  return raw.map(d => d.name).slice(0, 30);
}

function generateUstaRichData(city: City, job: Job) {
  const ilceler = getIlceNames(city);
  const ilce1 = ilceler[0] || "Merkez";
  const ilce2 = ilceler[1] || ilce1;
  const cityLoc = getCityLocative(city.name);

  const h1 = `${city.name} ${job.name} İş İlanları - Günlük İş Bul`;

  const intro = `${cityLoc} ${job.name.toLowerCase()} ustasıysan sana olduğundan büyük bir şey anlatmayacağız. Hemen Ustam Gelsin yeni bir platform ve ${cityLoc} usta ağımızı büyütüyoruz. Henüz her ilçede yüzlerce ilan varmış gibi göstermiyoruz; gerçek müşteriler geldikçe gerçek talepleri ustalarla buluşturmak istiyoruz.

Müşteri talebini ve fotoğraflarını gönderiyor. HugAI bu bilgileri analiz ederek işin kapsamını ve tahmini bedelini daha anlaşılır hale getiriyor. Sen ilgilendiğin talebi inceleyip teklifini veriyorsun.

Burada önemli bir farkımız var: İşi aldığında hakedişinden komisyon kesmiyoruz. %0 komisyonla çalışırsın. Teklif gönderirken teklif ücreti uygulanır; işi aldığında kazancından komisyon kesilmez. Teklif ücreti AI tarafından hesaplanan tahmini iş bedelinin %1'i kadardır.

Örneğin AI tahmini 20.000 TL olan bir ${job.name.toLowerCase()} işi için teklif ücreti 200 TL'dir. İşi aldığında 20.000 TL'lik hakedişinden ayrıca komisyon kesilmez.`;

  const maddeler = [
    `%0 komisyonla çalışırsın. Teklif gönderirken teklif ücreti uygulanır; işi aldığında kazancından komisyon kesilmez - İşi aldığında hakedişinden ayrıca yüzde komisyon kesilmez`,
    `Teklif ücreti açık ve şeffaf - Teklif vermek için AI tahmini iş bedelinin %1'i kadar teklif ücreti uygulanır`,
    `HugAI ile analiz edilmiş talepler - Müşterinin fotoğrafları ve talebi analiz edilerek işin kapsamı daha anlaşılır hale getirilir`,
    `Gerçek müşteri talepleri - Platforma gelen talepleri incele, ilgilendiğin işe teklif ver`,
    `Birlikte büyüyelim - ${cityLoc} usta ağımız büyürken sisteme erken katılan ustalar arasında yerini al. Bugün profilinizi oluşturmanız, bölgenizde daha erken görünürlük kazanmanıza yardımcı olabilir`,
  ];

  const faqs = [
    { q: `Komisyon gerçekten %0 mı?`, a: `Evet. Hemen Ustam Gelsin, işi aldığında hakedişinden yüzde komisyon kesmez. %0 komisyonla çalışırsın. Teklif gönderirken teklif ücreti uygulanır; işi aldığında kazancından komisyon kesilmez. Teklif ücreti AI tarafından hesaplanan tahmini iş bedelinin %1'i kadardır. Ücretlendirmeyi baştan açıkça gösteriyoruz.` },
    { q: `Teklif ücreti ne kadar?`, a: `Teklif ücreti, HugAI tarafından hesaplanan tahmini iş bedelinin %1'i üzerinden belirlenir. Örneğin AI tahmini 20.000 TL olan bir işte teklif ücreti 200 TL olur. Ücreti teklif vermeden önce görürsün; sonradan sürpriz ödeme çıkmaz.` },
    { q: `İşi alırsam ayrıca komisyon öder miyim?`, a: `Hayır. Teklif ücretini ödedikten ve işi aldıktan sonra hakedişinden ayrıca komisyon kesilmez. %0 komisyonla çalışırsın.` },
    { q: `${cityLoc} gerçekten iş var mı?`, a: `Hemen Ustam Gelsin ${cityLoc} büyüyen yeni bir platform. Bu nedenle sana bugün yüzlerce ilan varmış gibi gerçek dışı rakamlar göstermiyoruz. Amacımız gerçek müşterilerin gerçek taleplerini platforma getirerek uygun ustalarla buluşturmak.` },
  ];

  return { h1, intro, maddeler, ilceler: ilceler.slice(0,12), faqs, ilce1, ilce2 };
}

export function getAllUstaCityJobCombos(): UstaCityJobCombo[] {
  return cities.flatMap(city => jobs.map(job => {
    const rich = generateUstaRichData(city, job);
    const seoTitle = generateUstaSeoTitle(city, job);
    const seoDescription = generateUstaSeoDescription(city, job, rich.ilceler);
    return {
      city, job, citySlug: city.slug, jobSlug: job.slug,
      url: `/usta-is-ilanlari/${city.slug}/${job.slug}`,
      seoTitle, seoDescription, metaTitle: seoTitle, metaDescription: seoDescription,
   ...rich
    }
  }));
}

export function getAllUstaCityJobParams(){
  return cities.flatMap(city => jobs.map(job => ({ city: city.slug, job: job.slug })));
}

export function getUstaCityJob(citySlug: string, jobSlug: string): UstaCityJobCombo | null {
  const city = cities.find(c => c.slug === citySlug);
  const job = jobs.find(j => j.slug === jobSlug);
  if(!city||!job) return null;
  const rich = generateUstaRichData(city, job);
  const seoTitle = generateUstaSeoTitle(city, job);
  const seoDescription = generateUstaSeoDescription(city, job, rich.ilceler);
  return {
    city, job, citySlug, jobSlug, url: `/usta-is-ilanlari/${citySlug}/${jobSlug}`,
    seoTitle, seoDescription, metaTitle: seoTitle, metaDescription: seoDescription,
 ...rich
  };
}

export function getUstaCityJobData(
  cityName: string,
  jobName: string,
  cityRegion: string = ""
): { intro: string; maddeler: string[]; faqs: { q: string; a: string }[]; h1: string; seoTitle: string; seoDescription: string; ilceler: string[] } {
  const city = cities.find(c => c.name === cityName);
  const job = jobs.find(j => j.name === jobName);
  if (!city ||!job) {
    return {
      h1: `${cityName} ${jobName} İş İlanları - Günlük İş Bul`,
      intro: `${getCityLocative(cityName)} ${jobName.toLowerCase()} ustasıysan...`,
      maddeler: [],
      faqs: [],
      seoTitle: `${cityName} ${jobName} İş Ara - %0 Hakediş`,
      seoDescription: `${getCityLocative(cityName)} ${jobName} iş ilanları`,
      ilceler: []
    };
  }
  const rich = generateUstaRichData(city, job);
  const seoTitle = generateUstaSeoTitle(city, job);
  const seoDescription = generateUstaSeoDescription(city, job, rich.ilceler);
  return {
    intro: rich.intro,
    maddeler: rich.maddeler,
    faqs: rich.faqs,
    h1: rich.h1,
    seoTitle,
    seoDescription,
    ilceler: rich.ilceler
  };
}

export function isValidUstaCityJob(a:string,b:string){ return!!getUstaCityJob(a,b); }