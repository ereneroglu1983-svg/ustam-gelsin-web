// data/cities.ts - FINAL v10 - 404 FIX + İSTANBUL BUG %100 FIX + EXPORT UYUMLU
import sehirlerRaw from './sehirler.json'
import ilcelerRaw from './ilceler.json'

export type District = { name: string; slug: string; };
export type City = { name: string; slug: string; districts: District[]; region: string; plate: number; };

// %100 SAĞLAM SLUGIFY - TR BUG YOK
const slugify = (text: string) => {
  if (!text) return '';
  return text
    .toString()
    .toLowerCase() // EN-US lowercase - tr-TR kullanma!
    .replace(/İ/g, 'i')
    .replace(/ı/g, 'i')
    .replace(/ğ/g, 'g')
    .replace(/Ğ/g, 'g')
    .replace(/ü/g, 'u')
    .replace(/Ü/g, 'u')
    .replace(/ş/g, 's')
    .replace(/Ş/g, 's')
    .replace(/ö/g, 'o')
    .replace(/Ö/g, 'o')
    .replace(/ç/g, 'c')
    .replace(/Ç/g, 'c')
    .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .replace(/--+/g, '-');
};

const toProper = (text: string) => {
  if (!text) return '';
  return text
    .toString()
    .trim()
    .toLowerCase()
    .split(' ')
    .filter(Boolean)
    .map(w => w.charAt(0).toLocaleUpperCase('tr-TR') + w.slice(1))
    .join(' ');
};

const regionMap: Record<string, string> = {
  adana: "Akdeniz", adiyaman: "Güneydoğu Anadolu", afyonkarahisar: "Ege", agri: "Doğu Anadolu", amasya: "Karadeniz",
  ankara: "İç Anadolu", antalya: "Akdeniz", artvin: "Karadeniz", aydin: "Ege", balikesir: "Marmara",
  bilecik: "Marmara", bingol: "Doğu Anadolu", bitlis: "Doğu Anadolu", bolu: "Karadeniz", burdur: "Akdeniz",
  bursa: "Marmara", canakkale: "Marmara", cankiri: "İç Anadolu", corum: "Karadeniz", denizli: "Ege",
  diyarbakir: "Güneydoğu Anadolu", edirne: "Marmara", elazig: "Doğu Anadolu", erzincan: "Doğu Anadolu",
  erzurum: "Doğu Anadolu", eskisehir: "İç Anadolu", gaziantep: "Güneydoğu Anadolu", giresun: "Karadeniz",
  gumushane: "Karadeniz", hakkari: "Doğu Anadolu", hatay: "Akdeniz", isparta: "Akdeniz", mersin: "Akdeniz",
  istanbul: "Marmara", izmir: "Ege", kars: "Doğu Anadolu", kastamonu: "Karadeniz", kayseri: "İç Anadolu",
  kirklareli: "Marmara", kirsehir: "İç Anadolu", kocaeli: "Marmara", konya: "İç Anadolu", kutahya: "Ege",
  malatya: "Doğu Anadolu", manisa: "Ege", kahramanmaras: "Akdeniz", mardin: "Güneydoğu Anadolu", mugla: "Ege",
  mus: "Doğu Anadolu", nevsehir: "İç Anadolu", nigde: "İç Anadolu", ordu: "Karadeniz", rize: "Karadeniz",
  sakarya: "Marmara", samsun: "Karadeniz", siirt: "Güneydoğu Anadolu", sinop: "Karadeniz", sivas: "İç Anadolu",
  tekirdag: "Marmara", tokat: "Karadeniz", trabzon: "Karadeniz", tunceli: "Doğu Anadolu", sanliurfa: "Güneydoğu Anadolu",
  usak: "Ege", van: "Doğu Anadolu", yozgat: "İç Anadolu", zonguldak: "Karadeniz", aksaray: "İç Anadolu",
  bayburt: "Karadeniz", karaman: "İç Anadolu", kirikkale: "İç Anadolu", batman: "Güneydoğu Anadolu",
  sirnak: "Güneydoğu Anadolu", bartin: "Karadeniz", ardahan: "Doğu Anadolu", igdir: "Doğu Anadolu",
  yalova: "Marmara", karabuk: "Karadeniz", kilis: "Güneydoğu Anadolu", osmaniye: "Akdeniz", duzce: "Karadeniz",
};

export const cities: City[] = (sehirlerRaw as any[]).map((s: any) => {
  const sehirId = String(s.sehir_id);
  const rawName = s.sehir_adi || '';
  const properName = toProper(rawName);
  let slug = slugify(properName);
  // KRİTİK FIX: İstanbul, İzmir, Iğdır gibi İ ile başlayanlar için fallback
  if (!slug || slug.length < 2) {
    slug = slugify(rawName);
  }
  if (properName.toLowerCase().includes('istanbul')) slug = 'istanbul';
  if (properName.toLowerCase().includes('izmir')) slug = 'izmir';
  if (properName.toLowerCase().includes('igdir') || properName.toLowerCase().includes('iğdır')) slug = 'igdir';

  const districtsOfCity = (ilcelerRaw as any[]).filter((ilce: any) => String(ilce.sehir_id) === sehirId);

  const districts: District[] = districtsOfCity.map((d: any) => {
    const rawIlce = d.ilce_adi || '';
    const properIlce = toProper(rawIlce);
    let dSlug = slugify(properIlce);
    if (!dSlug || dSlug.length < 2) {
      dSlug = slugify(rawIlce);
    }
    // MANİSA KRİTİK İLÇELER İÇİN HARD FIX
    const lower = properIlce.toLowerCase();
    if (lower.includes('alaşehir')) dSlug = 'alasehir';
    if (lower.includes('gölmarmara')) dSlug = 'golmarmara';
    if (lower.includes('kırkağaç')) dSlug = 'kirkagac';
    if (lower.includes('sarıgöl')) dSlug = 'sarigol';
    if (lower.includes('şehzadeler')) dSlug = 'sehzadeler';
    if (lower.includes('gördes')) dSlug = 'gordes';
    if (lower.includes('köprübaşı')) dSlug = 'koprubasi';
    if (lower.includes('saruhanlı')) dSlug = 'saruhanli';

    return {
      name: properIlce,
      slug: dSlug
    }
  }).filter(d => d.slug && d.slug.length >= 2).sort((a,b) => a.name.localeCompare(b.name, 'tr'))

  return {
    name: properName,
    slug,
    plate: Number(sehirId),
    region: regionMap[slug] || "Marmara",
    districts
  };
}).filter(c => c.slug && c.slug.length >= 2).sort((a,b) => a.plate - b.plate);

(() => {
  if (cities.length!== 81) throw new Error(`[cities.ts] 81 il olmalı, gelen: ${cities.length}`);
  const plates = cities.map(c => c.plate).sort((a,b)=>a-b);
  for(let i=1; i<=81; i++) if(plates[i-1]!== i) throw new Error(`[cities.ts] plaka ${i} eksik`);
  for(const c of cities){
    if(!regionMap[c.slug]) throw new Error(`[cities.ts] regionMap ${c.slug} eksik - name: ${c.name}`);
    if(c.districts.length < 1) throw new Error(`[cities.ts] ${c.slug} ilçesinde 0 ilçe`);
    // slug boş mu kontrol et
    for(const d of c.districts){
      if(!d.slug || d.slug.includes('.') || d.slug.length < 2) throw new Error(`[cities.ts] ${c.slug} -> ${d.name} slug bozuk: ${d.slug}`);
    }
  }
})();

export const citySlugs = cities.map(c => c.slug);
export const getCityBySlug = (slug: string) => {
  const norm = slugify(slug);
  return cities.find(c => c.slug === norm || c.slug === slug);
};
export const getDistrictBySlug = (citySlug: string, districtSlug: string) => {
  const city = getCityBySlug(citySlug);
  if(!city) return undefined;
  const norm = slugify(districtSlug);
  return city.districts.find(d => d.slug === norm || d.slug === districtSlug);
};
export const getCityRegion = (slug: string) => regionMap[slugify(slug)] || regionMap[slug];
export const getCitySeoIntro = (citySlug: string, jobLabel: string) => {
  const city = getCityBySlug(citySlug);
  if (!city) return "";
  const top3 = city.districts.slice(0, 3).map(d => d.name).join(", ");
  return `${city.name} ${getCityRegion(citySlug)} bölgesinde yer alır. ${top3} başta olmak üzere ${city.districts.length} ilçede ${jobLabel} talepleri için usta eşleştirme ve teklif alma imkanı sunar.`;
};
export function getCityLocative(cityName: string): string {
  const map: Record<string, string> = {
    'Adana': "Adana'da", 'Adıyaman': "Adıyaman'da", 'Afyonkarahisar': "Afyonkarahisar'da",
    'Ağrı': "Ağrı'da", 'Amasya': "Amasya'da", 'Ankara': "Ankara'da", 'Antalya': "Antalya'da",
    'Artvin': "Artvin'de", 'Aydın': "Aydın'da", 'Balıkesir': "Balıkesir'de", 'Bilecik': "Bilecik'te",
    'Bingöl': "Bingöl'de", 'Bitlis': "Bitlis'te", 'Bolu': "Bolu'da", 'Burdur': "Burdur'da",
    'Bursa': "Bursa'da", 'Çanakkale': "Çanakkale'de", 'Çankırı': "Çankırı'da", 'Çorum': "Çorum'da",
    'Denizli': "Denizli'de", 'Diyarbakır': "Diyarbakır'da", 'Edirne': "Edirne'de", 'Elazığ': "Elazığ'da",
    'Erzincan': "Erzincan'da", 'Erzurum': "Erzurum'da", 'Eskişehir': "Eskişehir'de", 'Gaziantep': "Gaziantep'te",
    'Giresun': "Giresun'da", 'Gümüşhane': "Gümüşhane'de", 'Hakkari': "Hakkari'de", 'Hatay': "Hatay'da",
    'Isparta': "Isparta'da", 'Mersin': "Mersin'de", 'İstanbul': "İstanbul'da", 'İzmir': "İzmir'de",
    'Kars': "Kars'ta", 'Kastamonu': "Kastamonu'da", 'Kayseri': "Kayseri'de", 'Kırklareli': "Kırklareli'de",
    'Kırşehir': "Kırşehir'de", 'Kocaeli': "Kocaeli'de", 'Konya': "Konya'da", 'Kütahya': "Kütahya'da",
    'Malatya': "Malatya'da", 'Manisa': "Manisa'da", 'Kahramanmaraş': "Kahramanmaraş'ta",
    'Mardin': "Mardin'de", 'Muğla': "Muğla'da", 'Muş': "Muş'ta", 'Nevşehir': "Nevşehir'de",
    'Niğde': "Niğde'de", 'Ordu': "Ordu'da", 'Rize': "Rize'de", 'Sakarya': "Sakarya'da",
    'Samsun': "Samsun'da", 'Siirt': "Siirt'te", 'Sinop': "Sinop'ta", 'Sivas': "Sivas'ta",
    'Tekirdağ': "Tekirdağ'da", 'Tokat': "Tokat'ta", 'Trabzon': "Trabzon'da", 'Tunceli': "Tunceli'de",
    'Şanlıurfa': "Şanlıurfa'da", 'Uşak': "Uşak'ta", 'Van': "Van'da", 'Yozgat': "Yozgat'ta",
    'Zonguldak': "Zonguldak'ta", 'Aksaray': "Aksaray'da", 'Bayburt': "Bayburt'ta", 'Karaman': "Karaman'da",
    'Kırıkkale': "Kırıkkale'de", 'Batman': "Batman'da", 'Şırnak': "Şırnak'ta", 'Bartın': "Bartın'da",
    'Ardahan': "Ardahan'da", 'Iğdır': "Iğdır'da", 'Yalova': "Yalova'da", 'Karabük': "Karabük'te",
    'Kilis': "Kilis'te", 'Osmaniye': "Osmaniye'de", 'Düzce': "Düzce'de"
  }
  return map[cityName] || `${cityName}'da`
}