// PLACEHOLDER izmir
export const cityGeneric = { citySlug: 'izmir', cityName: 'izmir', note: 'Bu şehir için henüz teknik analiz eklenmedi.' };
export function getEnrichment() { return { city: cityGeneric, district: null, isFallback: true }; }
