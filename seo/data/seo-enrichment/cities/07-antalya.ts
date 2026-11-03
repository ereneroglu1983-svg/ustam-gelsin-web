// PLACEHOLDER antalya
export const cityGeneric = { citySlug: 'antalya', cityName: 'antalya', note: 'Bu şehir için henüz teknik analiz eklenmedi.' };
export function getEnrichment() { return { city: cityGeneric, district: null, isFallback: true }; }
