// app/hug-market-sitemap.xml/route.ts
export const dynamic = 'force-static'
export const revalidate = 86400

export async function GET() {
  const cats = ["banyo-mutfak","temizlik-hijyen","elektrik-aydinlatma","hirdavat-el-aletleri-is-guvenligi","bahce-peyzaj-dis-mekan","tesisat-su-sistemleri","yapi-malzemeleri-insaat","boya-dekorasyon","cati-cephe-sistemleri","havuz-spa-sistemleri","isitma-sogutma-iklimlendirme","seramik-fayans-zemin","yalitim-izolasyon","cam-aluminyum-cephe-sistemleri","yenilenebilir-enerji-guc-sistemleri","kapi-kilit-gecis-kontrol","guvenlik-yangin-zayif-akim","asansor-yuruyen-merdiven"]
  const cities = ["adana","adiyaman","afyonkarahisar","agri","amasya","ankara","antalya","artvin","aydin","balikesir","bilecik","bingol","bitlis","bolu","burdur","bursa","canakkale","cankiri","corum","denizli","diyarbakir","edirne","elazig","erzincan","erzurum","eskisehir","gaziantep","giresun","gumushane","hakkari","hatay","isparta","mersin","istanbul","izmir","kars","kastamonu","kayseri","kirklareli","kirsehir","kocaeli","konya","kutahya","malatya","manisa","kahramanmaras","mardin","mugla","mus","nevsehir","nigde","ordu","rize","sakarya","samsun","siirt","sinop","sivas","tekirdag","tokat","trabzon","tunceli","sanliurfa","usak","van","yozgat","zonguldak","aksaray","bayburt","karaman","kirikkale","batman","sirnak","bartin","ardahan","igdir","yalova","karabuk","kilis","osmaniye","duzce"]

  const urls = [
    "https://hemenustamgelsin.com/hug-market",
    "https://hemenustamgelsin.com/hug-market/cozum-ortagi",
    ...cats.map(c => `https://hemenustamgelsin.com/hug-market/cozum-ortakligi/${c}`),
    ...cities.flatMap(city => cats.map(cat => `https://hemenustamgelsin.com/hug-market/${city}/${cat}`))
  ]

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls.map(u => `  <url><loc>${u}</loc><changefreq>weekly</changefreq><priority>0.8</priority></url>`).join("\n")}
</urlset>`

  return new Response(xml, {
    headers: {
      "Content-Type": "application/xml; charset=utf-8",
      "Cache-Control": "public, max-age=3600"
    },
  })
}