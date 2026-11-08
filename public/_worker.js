const MAP = {
  "otamatik-sulama-sistemleri": "otomatik-sulama-sistemleri",
  "boya-badana": "ic-cephe-boya-ve-badana",
  "cati-yapimi-aktarma-ve-izalasyon": "cati-aktarma-ve-izolasyon",
  "uydu-internet-ve-kamera-sitemleri": "uydu-ve-kamera-sistemleri"
};

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;

    if (path.startsWith("/usta-is-ilanlari/")) {
      for (const [typo, correct] of Object.entries(MAP)) {
        if (path.includes(typo)) {
          const newPath = path.replace(typo, correct);
          return Response.redirect(url.origin + newPath + url.search, 301);
        }
      }
    }
    // degilse normal dosyayi ver
    return env.ASSETS.fetch(request);
  }
}
