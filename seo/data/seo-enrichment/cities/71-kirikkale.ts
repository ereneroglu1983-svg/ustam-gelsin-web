// PLACEHOLDER kirikkale
export const cityGeneric = { citySlug: 'kirikkale', cityName: 'kirikkale', note: 'Bu şehir için henüz teknik analiz eklenmedi.' };
export function getEnrichment() { return { city: cityGeneric, district: null, isFallback: true }; }
