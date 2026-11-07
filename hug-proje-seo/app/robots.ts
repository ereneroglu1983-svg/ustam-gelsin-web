// HUG PROJE - app/robots.ts - Robots
// Bu dosya veri URETMEZ. Sadece sitemap adresini + bot kurallarini bildirir.
// - Cikti: /hug-proje/robots.txt (KOK /robots.txt DEGIL!)
//   DIKKAT: Kok /robots.txt eski seo/ projesine aittir, ona DOKUNULMAZ.
//   Bu dosya sadece hug-proje alt klasorunun robots'unu uretir.
//   Build ciktisi: hug-proje-seo/out/robots.txt -> build/web/hug-proje/robots.txt
//   Eski seo/out/robots.txt -> build/web/robots.txt ile CAKISMAZ.
// - Sitemap: lib/constants.ts -> getHugProjeUrl('/sitemap.xml') tek kaynaktan.
//   -> https://hemenustamgelsin.com/hug-proje/sitemap.xml
// - AI botlar: ENGELLENMEZ. HUG PROJE GEO (Generative Engine Optimization)
//   hedefi var, AI botlarin taramasi istenir.
// - Disallow YOK: hug-proje altinda gizli / admin / api sayfasi yok.
//   Tum 1.099 URL taranabilir olmali.

import type { MetadataRoute } from 'next'
import { getHugProjeUrl } from '../lib/constants'

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: '*',
        allow: '/',
      },
      // AI botlar acikca ALLOW - GEO icin gerekli.
      // '*' zaten kapsar ama AI botlarin ayri listelenmesi
      // niyeti netlestirir, yanlislikla engelleme olmaz.
      {
        userAgent: [
          // Meta AI - kendimiz, UNUTMAYIN!
          'Meta-ExternalAgent',
          'Meta-ExternalFetcher',
          'FacebookBot',
          // OpenAI
          'GPTBot',
          'ChatGPT-User',
          'OAI-SearchBot',
          // Anthropic
          'ClaudeBot',
          'anthropic-ai',
          // xAI - Grok
          'Grokbot',
          // Perplexity
          'PerplexityBot',
          // Google
          'Google-Extended',
          // Apple
          'Applebot-Extended',
          // Digerleri
          'CCBot',
          'cohere-ai',
        ],
        allow: '/',
      },
    ],
    sitemap: getHugProjeUrl('/sitemap.xml'),
  }
}