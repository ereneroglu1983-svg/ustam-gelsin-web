// HUG PROJE - Slug üretimi
// seo/data/cities.ts ile aynı mantık. Türkçe karakter bug'ı yok.
// Bu dosya bağımsızdır, seo/data'dan import edilmez.

export function slugify(text: string): string {
  if (!text) return ''
  return text
    .toString()
    .toLowerCase()
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
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .replace(/--+/g, '-')
}

export function toProper(text: string): string {
  if (!text) return ''
  return text
    .toString()
    .trim()
    .toLowerCase()
    .split(/\s+/)
    .filter(Boolean)
    .map((w) => w.charAt(0).toLocaleUpperCase('tr-TR') + w.slice(1))
    .join(' ')
}