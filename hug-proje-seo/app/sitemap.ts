// HUG PROJE - app/sitemap.ts - Tek Sitemap
// Bu dosya veri URETMEZ. Sadece data/*.ts'teki gercek kayitlardan URL uretir.
// - Mimari KARARI: generateSitemaps() YOK, parcali sitemap YOK.
//   Neden: Toplam 1.099 URL (1 ana + 81 il + 973 ilce + 14 profesyonel
//   + 11 proje turu + 19 ihtiyac) tek sitemap icin cok kucuk.
//   50.000 URL sinirinin yaninda parcalama gereksiz, yonetim kolayligi
//   icin adres karmasasi yaratmaya degmez.
//   Onceki taslakta generateSitemaps() vardi, YANLISTI: yorumdaki
//   /hug-proje/sitemap-main.xml gibi adresler uretilmez. Next.js
//   generateSitemaps() -> /hug-proje/sitemap/[id].xml uretir
//   (or: /hug-proje/sitemap/main.xml) ve index varsayimi belirsizdi.
//   Bu belirsizligi tasimamak icin tek dosya secildi.
// - Cikti: Tek dosya -> /hug-proje/sitemap.xml
// - lastmod YOK: icerik degismeden her build'de build tarihi basmak yanlis.
//   seo/app/sitemap.ts'teki hata burada tekrarlanmaz. Icerik degisince eklenir.
// - Canonical: lib/constants.ts -> getHugProjeUrl() tek kaynaktan.
// - 404 ureten ara liste sayfasi YOK: /profesyonel, /proje-turu, /ihtiyac, /iller
//   sitemap'e EKLENMEZ, sadece gercek sayfalar var.
// - Sahte URL, sahte sayfa YOKTUR.

import type { MetadataRoute } from 'next'
import { getHugProjeUrl } from '../lib/constants'
import { profesyonelSeoSayfalari } from '../data/profesyoneller'
import { projeTurleri } from '../data/proje-turleri'
import { ihtiyaclar } from '../data/ihtiyaclar'
import { cities } from '../data/cities'

<<<<<<< HEAD
export const dynamic = 'force-static'

=======
>>>>>>> b7540fb6 (fix: hug-proje ignore + deploy-hug-pro - node_modules yok)
function toEntry(
  path: string,
  priority: number,
  changeFrequency: MetadataRoute.Sitemap[number]['changeFrequency'],
): MetadataRoute.Sitemap[number] {
  return {
    url: getHugProjeUrl(path),
    priority,
    changeFrequency,
  }
}

export default function sitemap(): MetadataRoute.Sitemap {
  return [
    // Ana sayfa
    toEntry('/', 1.0, 'weekly'),

    // 81 il
    ...cities.map((c) => toEntry(`/iller/${c.slug}`, 0.9, 'weekly')),

    // 973 ilce
    ...cities.flatMap((c) =>
      c.districts.map((d) => toEntry(`/iller/${c.slug}/ilceler/${d.slug}`, 0.8, 'monthly')),
    ),

    // 14 profesyonel
    ...profesyonelSeoSayfalari.map((p) => toEntry(`/profesyonel/${p.seoSlug}`, 0.9, 'weekly')),

    // 11 proje turu
    ...projeTurleri.map((t) => toEntry(`/proje-turu/${t.seoSlug}`, 0.9, 'weekly')),

    // 19 ihtiyac
    ...ihtiyaclar.map((i) => toEntry(`/ihtiyac/${i.seoSlug}`, 0.9, 'weekly')),
  ]
}