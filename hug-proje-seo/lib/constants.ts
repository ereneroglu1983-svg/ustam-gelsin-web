// HUG PROJE - Merkezi sabitler
// Google Play linki ve UTM üretimi tek buradan yapılır.
// Sayfalara elle Play linki yazılmaz.

export const SITE_URL = 'https://hemenustamgelsin.com'
export const HUG_PROJE_BASE = '/hug-proje'

export const APP_NAME = 'Hemen Ustam Gelsin'
export const APP_PACKAGE = 'com.hemenustamgelsin.android'

export const PLAY_URL_CLEAN =
  `https://play.google.com/store/apps/details?id=${APP_PACKAGE}`

export type DownloadAudience = 'sahip' | 'profesyonel' | 'genel'

export const DOWNLOAD_MESSAGES: Record<DownloadAudience, string> = {
  sahip: "Projen için doğru profesyonelleri bul. Hemen Ustam Gelsin'i indir!",
  profesyonel: "Yeni proje fırsatlarını keşfet. Hemen Ustam Gelsin'e katıl!",
  genel: '81 ilde ustalar ve müşteriler Hemen Ustam Gelsin\'de buluşuyor.',
}

export function getPlayUrl(opts?: {
  source?: string
  medium?: string
  campaign?: string
  content?: string
}): string {
  const params = new URLSearchParams({
    utm_source: opts?.source ?? 'hug-proje',
    utm_medium: opts?.medium ?? 'seo',
    utm_campaign: opts?.campaign ?? 'hug-proje-indir',
  })
  if (opts?.content) params.set('utm_content', opts.content)
  return `${PLAY_URL_CLEAN}&${params.toString()}`
}

export function getHugProjeUrl(path: string): string {
  // Canonical için: query ve hash atılır, çift prefix ve çift slash önlenir.
  let clean = (path ?? '').trim()
  // Tam URL geldiyse hostname kontrolü yap, sadece hemenustamgelsin.com kabul edilir.
  if (clean.startsWith('http://') || clean.startsWith('https://')) {
    let parsed: URL
    try {
      parsed = new URL(clean)
    } catch {
      throw new Error('[getHugProjeUrl] Geçersiz URL verildi.')
    }
    if (parsed.hostname !== 'hemenustamgelsin.com') {
      throw new Error(
        `[getHugProjeUrl] Yalnızca hemenustamgelsin.com kabul edilir, gelen: ${parsed.hostname}`
      )
    }
    clean = parsed.pathname
  }
  // Query ve hash at
  clean = clean.split('?')[0].split('#')[0].trim()
  // Ana sayfa
  if (clean === '' || clean === '/') {
    return `${SITE_URL}${HUG_PROJE_BASE}/`
  }
  // Başta ve sonda slash'ları temizle
  clean = clean.replace(/^\/+/, '').replace(/\/+$/, '')
  // /hug-proje/ prefix'i ikinci kez eklenmesin
  if (clean === 'hug-proje') {
    return `${SITE_URL}${HUG_PROJE_BASE}/`
  }
  if (clean.startsWith('hug-proje/')) {
    clean = clean.slice('hug-proje/'.length)
  }
  // Çift slash oluşmasın, tek slash ile birleştir
  clean = clean.replace(/\/{2,}/g, '/')
  if (clean === '') {
    return `${SITE_URL}${HUG_PROJE_BASE}/`
  }
  return `${SITE_URL}${HUG_PROJE_BASE}/${clean}/`
}