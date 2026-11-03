// PLACEHOLDER batman
export const cityGeneric = { citySlug: 'batman', cityName: 'batman', note: 'Bu şehir için henüz teknik analiz eklenmedi.' };
export function getEnrichment() { return { city: cityGeneric, district: null, isFallback: true }; }
