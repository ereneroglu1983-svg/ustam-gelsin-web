// data/ustaJobDatabase.ts - USTA İŞ ARAMA SEO - DÜRÜST VE ŞEFFAF - %0 HAKEDİŞ KOMİSYONU + %1 TEKLİF ÜCRETİ
import { cities, type City } from "./cities";
import { jobs, type Job } from "./jobs";

export type UstaCityJobCombo = {
  city: City; job: Job; citySlug: string; jobSlug: string; url: string;
  seoTitle: string; seoDescription: string; metaTitle: string; metaDescription: string;
  h1: string; intro: string; maddeler: string[]; ilceler: string[]; faqs: { q: string; a: string }[];
};

function hash(str: string): number {
  let h = 0; for(let i=0;i<str.length;i++) h = (h*31 + str.charCodeAt(i)) % 1000000; return h;
}
function pick<T>(arr: T[], seed: string): T {
  return arr[hash(seed) % arr.length];
}

function generateUstaSeoTitle(city: City, job: Job): string {
  const templates = [
    `${city.name} ${job.name} İş Ara - %0 Hakediş Komisyonu, Şeffaf Teklif Ücreti | Hemen Ustam Gelsin`,
    `${city.name}'de ${job.name} Mısın? Müşterini Bul, Teklifini Ver | Hemen Ustam Gelsin`,
  ];
  return pick(templates, city.slug+job.slug+"usta");
}

function generateUstaSeoDescription(city: City, job: Job, ilceler: string[]): string {
  const ilce1 = ilceler[0] || "Merkez";
  const ilce2 = ilceler[1] || ilce1;
  return `${city.name}'de ${job.name.toLowerCase()}ysan yeni müşterilere ulaş. Hemen Ustam Gelsin'de hakedişinden komisyon kesilmez. Teklif vermek için AI tahmini iş bedelinin %1'i kadar teklif ücreti uygulanır. HugAI ile analiz edilen talepleri incele, teklifini ver. ${ilce1}, ${ilce2} ve tüm ${city.name}.`;
}

function generateUstaRichData(city: City, job: Job) {
  const raw = (city as any).districts || (city as any).ilceler || ["Merkez"];
  const ilceler: string[] = (raw as any[]).map((x: any) => typeof x === 'string'? x : (x.name || x.slug)).slice(0, 30);
  const ilce1 = ilceler[0] || "Merkez";
  const ilce2 = ilceler[1] || ilce1;

  const h1 = `${city.name} ${job.name} - Müşterini Bul, Teklifini Ver, Kazancını Koru`;

  const intro = `${city.name}'de ${job.name.toLowerCase()}ysan sana olduğundan büyük bir şey anlatmayacağız. Hemen Ustam Gelsin yeni bir platform ve ${city.name}'deki usta ağımızı büyütüyoruz. Henüz her ilçede yüzlerce ilan varmış gibi göstermiyoruz; gerçek müşteriler geldikçe gerçek talepleri ustalarla buluşturmak istiyoruz.

Müşteri talebini ve fotoğraflarını gönderiyor. HugAI bu bilgileri analiz ederek işin kapsamını ve tahmini bedelini daha anlaşılır hale getiriyor. Sen ilgilendiğin talebi inceleyip teklifini veriyorsun.

Burada önemli bir farkımız var: İşi aldığında hakedişinden komisyon kesmiyoruz. Ancak teklif verebilmek için AI tarafından hesaplanan tahmini iş bedelinin %1'i kadar teklif ücreti uygulanıyor. Yani ücretlendirmeyi baştan açıkça söylüyoruz; sonradan sürpriz yok.

Örneğin AI tahmini 20.000 TL olan bir ${job.name.toLowerCase()} işi için teklif ücreti 200 TL'dir. İşi aldığında 20.000 TL'lik hakedişinden ayrıca yüzde komisyon kesilmez.

Bizim modelimiz basit: Gerçek talep, açık fiyatlandırma ve şeffaf bir usta-müşteri iletişimi. ${city.name}'de ${job.name.toLowerCase()} için bu sisteme ilk katılanlardan biri olmak ister misin?`;

  const maddeler = [
    `✅ Hakediş komisyonu %0 - İşi aldığında hakedişinden ayrıca yüzde komisyon kesilmez`,
    `✅ Teklif ücreti açık ve şeffaf - Teklif vermek için AI tahmini iş bedelinin %1'i kadar teklif ücreti uygulanır`,
    `✅ HugAI ile analiz edilmiş talepler - Müşterinin fotoğrafları ve talebi analiz edilerek işin kapsamı daha anlaşılır hale getirilir`,
    `✅ Gerçek müşteri talepleri - Platforma gelen talepleri incele, ilgilendiğin işe teklif ver`,
    `✅ İlk ustalardan biri ol - ${city.name}'deki usta ağımız büyürken sisteme erken katılan ustalar arasında yerini al`,
  ];

  const faqs = [
    { q: `Komisyon gerçekten %0 mı?`, a: `Evet. Hemen Ustam Gelsin, işi aldığında hakedişinden yüzde komisyon kesmez. Ancak bunu teklif ücretinden ayrı düşünmek gerekir: Teklif verebilmek için AI tarafından hesaplanan tahmini iş bedelinin %1'i kadar teklif ücreti uygulanır. Bu ücret komisyon değil, teklif verme ücretidir. Ücretlendirmeyi baştan açıkça gösteriyoruz.` },
    { q: `Teklif ücreti ne kadar?`, a: `Teklif ücreti, HugAI tarafından hesaplanan tahmini iş bedelinin %1'i üzerinden belirlenir. Örneğin AI tahmini 20.000 TL olan bir işte teklif ücreti 200 TL olur. Tahmini bedeli 15.000 TL ve altında olan işlerde minimum teklif ücreti uygulanır. Ücreti teklif vermeden önce görürsün; sonradan sürpriz ödeme çıkmaz.` },
    { q: `İşi alırsam ayrıca komisyon öder miyim?`, a: `Hayır. Teklif ücretini ödedikten ve işi aldıktan sonra hakedişinden ayrıca yüzde komisyon kesilmez. Örneğin 20.000 TL'lik işi aldığında, bu 20.000 TL üzerinden ayrıca başarı veya hakediş komisyonu ödemezsin.` },
    { q: `${city.name}'de gerçekten iş var mı?`, a: `Hemen Ustam Gelsin ${city.name}'de büyüyen yeni bir platform. Bu nedenle sana bugün yüzlerce ilan varmış gibi gerçek dışı rakamlar göstermiyoruz. ${city.name}'de ${job.name.toLowerCase()} ve benzeri talepler oldukça geniş bir alana yayılıyor. Amacımız gerçek müşterilerin gerçek taleplerini platforma getirerek uygun ustalarla buluşturmak. Platform büyüdükçe usta ve müşteri ağı da birlikte büyüyecek.` },
    { q: `HugAI ne yapıyor?`, a: `HugAI, müşterinin gönderdiği fotoğraf ve talep bilgilerini analiz ederek işin kapsamını anlamaya ve tahmini bir fiyat oluşturmaya yardımcı olur. Bu tahmin, teklif ücretinin hesaplanmasında kullanılan tahmini bedeldir; ustanın müşteriye vereceği gerçek teklif değildir. Son fiyatı usta, işi ve yerindeki koşulları değerlendirdikten sonra belirler.` },
    { q: `Müşteriye kendi fiyatımı verebilir miyim?`, a: `Evet. HugAI'nin tahmini fiyatı bağlayıcı bir satış fiyatı değildir. Talebi ve varsa fotoğrafları inceleyerek kendi işçilik, malzeme, keşif ve diğer maliyetlerini değerlendirir; müşteriye kendi teklifini sunarsın.` },
  ];

  return { h1, intro, maddeler, ilceler: ilceler.slice(0,12), faqs, ilce1, ilce2 };
}

export function getAllUstaCityJobCombos(){
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
export function getAllUstaCityJobParams(){ return cities.flatMap(city => jobs.map(job => ({ city: city.slug, job: job.slug }))); }
export function getUstaCityJob(citySlug: string, jobSlug: string){
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
export const getUstaCityJobData = getUstaCityJob;
export function isValidUstaCityJob(a:string,b:string){ return!!getUstaCityJob(a,b); }