// seo/data/seo-enrichment/_registry.ts - REVIZE v5 - JSON BAĞLANTILI
// Artık 973 ilçe hardcoded değil, data/ilceler.json'dan geliyor

import ilcelerRaw from '../ilceler.json';
import sehirlerRaw from '../sehirler.json';

type Ilce = { name: string; slug: string; citySlug: string; sehir?: string; city?: string };

// ilceler.json formatını normalize et
const allIlceler = (ilcelerRaw as any[]).map((d: any) => ({
  slug: d.slug || d.name?.toLocaleLowerCase('tr-TR').replace(/ /g, '-'),
  citySlug: (d.citySlug || d.sehir || d.city || '').toLocaleLowerCase('tr-TR'),
  name: d.name
}));

// 81 ili otomatik oluştur
export const allDistricts: Record<string, string[]> = {};

allIlceler.forEach((ilce) => {
  const city = ilce.citySlug;
  if (!city) return;
  if (!allDistricts[city]) allDistricts[city] = [];
  if (!allDistricts[city].includes(ilce.slug)) {
    allDistricts[city].push(ilce.slug);
  }
});

// 81 il garantilensin diye sehirler.json'dan da ekle (boş kalan olursa)
(sehirlerRaw as any[]).forEach((c: any) => {
  const slug = (c.slug || c.name || '').toLocaleLowerCase('tr-TR');
  if (slug && !allDistricts[slug]) {
    allDistricts[slug] = [];
  }
});

export const priorityDistricts = allDistricts;
export const getPriorityDistricts = (citySlug: string) => allDistricts[citySlug] || [];
export const getAllDistricts = (citySlug: string) => allDistricts[citySlug] || [];
export const cityCount = Object.keys(allDistricts).length;

// Log - build'de kaç ilçe geldi görelim
console.log(`[registry] ${cityCount} şehir, ${allIlceler.length} ilçe yüklendi`);