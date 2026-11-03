// PLACEHOLDER kars
export const cityGeneric = { citySlug: 'kars', cityName: 'kars', note: 'Bu şehir için henüz teknik analiz eklenmedi.' };
export function getEnrichment() { return { city: cityGeneric, district: null, isFallback: true }; }
