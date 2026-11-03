// PLACEHOLDER sirnak
export const cityGeneric = { citySlug: 'sirnak', cityName: 'sirnak', note: 'Bu şehir için henüz teknik analiz eklenmedi.' };
export function getEnrichment() { return { city: cityGeneric, district: null, isFallback: true }; }
