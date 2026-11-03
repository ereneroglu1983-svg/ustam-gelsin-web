// PLACEHOLDER erzurum
export const cityGeneric = { citySlug: 'erzurum', cityName: 'erzurum', note: 'Bu şehir için henüz teknik analiz eklenmedi.' };
export function getEnrichment() { return { city: cityGeneric, district: null, isFallback: true }; }
