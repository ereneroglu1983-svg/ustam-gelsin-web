// Cloudflare Pages Functions - KESIN COZUM - _redirects limitini bypass eder
// Dosya yeri: projenin kokunde /functions/_middleware.js
// Firebase functions klasorun varsa onun icine degil, kokte ayri functions klasoru olmali
// Eger kokte functions klasorun Firebase icinse, icine bu dosyayi ekle, Firebase deployu bozmaz

const TYPO_MAP = {
  "otamatik-sulama-sistemleri": "otomatik-sulama-sistemleri",
  "boya-badana": "ic-cephe-boya-ve-badana",
  "cati-yapimi-aktarma-ve-izalasyon": "cati-aktarma-ve-izolasyon",
  "uydu-internet-ve-kamera-sitemleri": "uydu-ve-kamera-sistemleri"
};

export async function onRequest(context) {
  const url = new URL(context.request.url);
  const pathname = url.pathname;

  // Sadece usta-is-ilanlari pathlerini kontrol et
  if (pathname.startsWith("/usta-is-ilanlari/")) {
    for (const [typo, correct] of Object.entries(TYPO_MAP)) {
      if (pathname.includes(typo)) {
        const newPath = pathname.replace(typo, correct);
        const destination = url.origin + newPath + url.search;
        return Response.redirect(destination, 301);
      }
    }
  }

  // Degilse normal devam
  return context.next();
}
