// app/[city]/[slug]/faq-templates.ts - ADIM 3 - Sadece FAQ şablonları
// Senin v16.1'deki FAQ'ların aynısı

export const faqTemplates = [
 { q: (d:string)=> `${d} usta fiyatları nasıl belirleniyor?`, a: (d:string,c:string,dL:string)=> `${dL} fiyatlar HugAI tahmini piyasa fiyat aralığı olarak gösterilir. Teklif doğrudan ustadan gelir. İŞ SENİN, EMEK SENİN, KAZANÇ SENİN. ÜYELİK ÜCRETİ YOK. KOMİSYON YOK. SONRADAN KESİNTİ YOK.`, topic: 'usta-fiyatlari' },
 { q: (d:string)=> `${d} için ek komisyon var mı?`, a: (d:string,c:string,dL:string)=> `Hayır. ÜYELİK ÜCRETİ YOK. KOMİSYON YOK. SONRADAN KESİNTİ YOK. Modelimiz budur: İŞ SENİN, EMEK SENİN, KAZANÇ SENİN.`, topic: 'komisyon' },
 { q: (d:string)=> `${d} ilanına nasıl teklif alırım?`, a: (d:string,c:string,dL:string)=> `${dL} ilan oluşturduğunda ilan ${c} içindeki ilgili kategorideki ustalara iletilir. Ustalar tekliflerini iletir ve sen uygun olanı seçerek iletişime geçebilirsin.`, topic: 'ilan-verme' },
 { q: (d:string)=> `${d} hangi hizmetlerde usta bulabilirim?`, a: (d:string,c:string,dL:string)=> `${dL} boya, alçı, fayans, parke, tesisat, elektrik, doğalgaz, çatı, mutfak dolabı ve banyo tadilatı gibi tüm branşlarda ilan açabilirsin.`, topic: 'hizmetler' },
 { q: (d:string)=> `${d} dışından usta gelebilir mi?`, a: (d:string,c:string,dL:string)=> `Evet. ${c} genelindeki ustalar ${dL} için teklif verebilir. İlanın uygun ustalara iletilir, teklif verenler arasından seçim yapabilirsin.`, topic: 'dis-usta' },
 { q: (d:string)=> `${d} ön analiz ücreti var mı?`, a: (d:string,c:string,dL:string)=> `${dL} HugAI tahmini piyasa fiyat aralığını ücretsiz olarak gösterir. Detaylı değerlendirme gerekirse usta ile doğrudan görüşebilirsin.`, topic: 'kesif' },
 { q: (d:string)=> `${d} için nasıl ilan oluştururum?`, a: (d:string,c:string,dL:string)=> `${dL} iş detaylarını ve ölçülerini ekleyerek ilan oluşturabilirsin. İlan yayınlandığında uygun ustalara iletilir.`, topic: 'ilan-verme' },
 { q: (d:string)=> `${d} ustaları nasıl seçiliyor?`, a: (d:string,c:string,dL:string)=> `${dL} ilan oluşturduğunda sistem hizmet kategorine göre uygun ${c} ustalarına iletim yapar. Ustalar teklif verir, sen de uygun olanı seçersin.`, topic: 'teklif-alma' },
 { q: (d:string)=> `${d} için HugAI ne yapar?`, a: (d:string,c:string,dL:string)=> `HugAI ${dL} için tahmini piyasa fiyat aralığını gösterir ve bütçe planlamana yardımcı olur. Bu aralık ${c} koşullarına göre ön bilgilendirme amaçlıdır ve kesin fiyat değildir.`, topic: 'hugai' },
 { q: (d:string)=> `${d} ilanım ne kadar süre yayında kalır?`, a: (d:string,c:string,dL:string)=> `${dL} oluşturduğun ilan teklifler gelene kadar yayında kalır. Teklifleri karşılaştırarak dilediğin zaman ustanı seçebilirsin.`, topic: 'ilan-suresi' }
]

export const faqTopicMap: Record<string, number[]> = {
 'usta-fiyatlari': [0],
 'komisyon': [1],
 'ilan-verme': [2,6],
 'teklif-alma': [7,2],
 'hizmetler': [3],
 'dis-usta': [4],
 'kesif': [5,8],
 'ilan-suresi': [9],
 'hugai': [8,0]
}