// PLACEHOLDER konya
export const cityGeneric = { citySlug: 'konya', cityName: 'konya', note: 'Bu şehir için henüz teknik analiz eklenmedi.' };
export function getEnrichment() { return { city: cityGeneric, district: null, isFallback: true }; }
