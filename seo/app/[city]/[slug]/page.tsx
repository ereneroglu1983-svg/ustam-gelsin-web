// 'use client' KALDIRILDI - SERVER COMPONENT
// app/[city]/[slug]/page.tsx - FINAL v16.0 - LUX KURUMSAL - PATH FIX - DÜRÜST - SLOGAN FIX - PANELLER SİLİNDİ - POSTER KORUNDU - BUILD FIX
import { cities } from '../../../data/cities'
import { jobs } from '../../../data/jobs'
import { getCityJobData } from '../../../data/cityJobDatabase'
import Link from 'next/link'
import type { Metadata } from 'next'
import { notFound } from 'next/navigation'
import UstaLiveGrid from '../../../components/UstaLiveGrid'

const SLOGAN_LINE1 = "İŞ SENİN, EMEK SENİN, KAZANÇ SENİN."
const SLOGAN_LINE2 = "ÜYELİK ÜCRETİ YOK. KOMİSYON YOK. SONRADAN KESİNTİ YOK."
const SLOGAN_FULL = `${SLOGAN_LINE1} ${SLOGAN_LINE2}`

function getLastVowel(word: string): string | null {
 for(let i = word.length - 1; i >= 0; i--){
  const ch = word[i].toLowerCase()
  if(['a','e','ı','i','o','ö','u','ü'].includes(ch)) return ch
 }
 return null
}
const hardConsonants = new Set(['f','s','t','k','ç','ş','h','p','F','S','T','K','Ç','Ş','H','P'])
function endsWithHardConsonant(word: string): boolean { return word? hardConsonants.has(word[word.length - 1]) : false }
function getLocativeSuffix(word: string): string {
 const lastVowel = getLastVowel(word)
 const isHard = endsWithHardConsonant(word)
 if(!lastVowel) return isHard? "'te" : "'de"
 const isFront = ['e','i','ö','ü'].includes(lastVowel)
 return isFront? (isHard? "'te" : "'de") : (isHard? "'ta" : "'da")
}
const loc = (name: string) => `${name}${getLocativeSuffix(name)}`
function countWords(text: string): number { return text.trim().split(/\s+/).filter(Boolean).length }
function hashString(str: string): number { let hash = 0; for(let i=0;i<str.length;i++){ hash = ((hash << 5) - hash) + str.charCodeAt(i); hash |= 0 } return Math.abs(hash) }
function pickDeterministic<T>(arr: T[], seed: string, count: number): T[] {
 if(arr.length <= count) return [...arr]
 const start = hashString(seed) % arr.length
 const result: T[] = []
 // FIX v15.1: Eski (start + i*7) % length formülü length 7'nin katı olduğunda aynı elemanı tekrar ediyordu. Artık çakışmasız.
 for(let i=0;i<count;i++){ result.push(arr[(start + i) % arr.length]) }
 return result
}

type DistrictSEOData = { serviceFocus: string[]; localIntro: string; demandNote: string; faqTopics: string[]; nearbyPriority: string[] }
const districtSEODataOverride: Record<string, Partial<DistrictSEOData>> = {
 'manisa/salihli': { serviceFocus: ['ic-cephe-boya-ve-badana','elektrik-tesisati','sihhi-tesisat-ve-pis-su-tesisati','fayans-seramik-ve-kalebodur','mutfak-dolabi-ve-tezgahi','laminat-lamine-ve-masif-parke','alci-siva-ve-saten-alci','pvc-dograma','klima-montaj-bakim-ve-gaz-dolumu','cati-yapimi-aktarma-ve-izolasyon'], nearbyPriority: ['turgutlu','akhisar','yunusemre','sehzadeler','soma','alasehir','ahmetli','golmarmara','gordes','kula','kirkagac','koprubasi','sarigol','saruhanli','selendi','demirci'] },
 'manisa/turgutlu': { serviceFocus: ['ic-cephe-boya-ve-badana','dis-cephe-boya-ve-mantolama','elektrik-tesisati','sihhi-tesisat-ve-pis-su-tesisati','dogalgaz-tesisati-ve-kombi-montaji-bakimi','mutfak-dolabi-ve-tezgahi','banyo-dolabi-ve-vestiyer','laminat-lamine-ve-masif-parke','oda-kapisi-ve-celik-kapi','pvc-dograma'], nearbyPriority: ['salihli','yunusemre','sehzadeler','akhisar','ahmetli','alasehir','golmarmara','soma','saruhanli','kula','kirkagac','koprubasi','sarigol','selendi','demirci','gordes'] },
 'manisa/akhisar': { serviceFocus: ['ic-cephe-boya-ve-badana','sihhi-tesisat-ve-pis-su-tesisati','elektrik-tesisati','fayans-seramik-ve-kalebodur','laminat-lamine-ve-masif-parke','mutfak-dolabi-ve-tezgahi','alci-siva-ve-saten-alci','oda-kapisi-ve-celik-kapi','klima-montaj-bakim-ve-gaz-dolumu','bahce-peyzaj-ve-cim-ekimi'], nearbyPriority: ['salihli','turgutlu','soma','kirkagac','golmarmara','gordes','yunusemre','sehzadeler','ahmetli','alasehir','kula','koprubasi','sarigol','saruhanli','selendi','demirci'] },
 'istanbul/kadikoy': { serviceFocus: ['ic-cephe-boya-ve-badana','elektrik-tesisati','sihhi-tesisat-ve-pis-su-tesisati','mutfak-dolabi-ve-tezgahi','banyo-dolabi-ve-vestiyer','laminat-lamine-ve-masif-parke','alci-siva-ve-saten-alci','klima-montaj-bakim-ve-gaz-dolumu','uydu-internet-ve-kamera-sistemleri','marangozluk-ve-mobilya-tamiri'], nearbyPriority: ['uskudar','atasehir','maltepe','besiktas'] },
 'istanbul/besiktas': { serviceFocus: ['ic-cephe-boya-ve-badana','elektrik-tesisati','sihhi-tesisat-ve-pis-su-tesisati','mutfak-dolabi-ve-tezgahi','banyo-dolabi-ve-vestiyer','laminat-lamine-ve-masif-parke','fayans-seramik-ve-kalebodur','klima-montaj-bakim-ve-gaz-dolumu','asansor-bakim-ve-onarim','cam-balkon-ve-giyotin-cam'], nearbyPriority: ['sisli','beyoglu','kadikoy','uskudar','eyupsultan'] },
 'istanbul/uskudar': { nearbyPriority: ['kadikoy','atasehir','beykoz','besiktas','eyupsultan'] }
}
const safeLocalIntroTemplates: Array<(dName: string, cName: string, dLoc: string) => string> = [
 (d,c,dL) => `${d}, ${c} ili sınırları içinde konut ve iş yeri için ilan oluşturabileceğin ilçelerden biridir ve aktif olarak hizmet vermektedir.`,
 (d,c,dL) => `${d} ilçesi ${c} içinde yer alan ve Hemen Ustam Gelsin üzerinden ilan verilebilen bölgelerden biri olarak öne çıkmaktadır.`,
 (d,c,dL) => `${c} içinde ${d} ilçesi için Hemen Ustam Gelsin üzerinden ilan oluşturarak doğrudan usta teklifi alabilirsin ve süreci başlatabilirsin.`,
 (d,c,dL) => `${d} ${c} içinde ilan oluşturulabilen ilçelerden biri olup ${dL} tadilat ve yenileme işleri için hızlıca hizmet alabilirsin ve teklif toplayabilirsin.`,
 (d,c,dL) => `${d} ilçesi ${c} genelinde Hemen Ustam Gelsin üzerinden aktif olarak ilan açılabilen ve teklif alınabilen bölgelerden biridir.`
]
const safeDemandNoteTemplates: Array<(dName: string, cName: string, dLoc: string) => string> = [
 (d,c,dL) => `${d} için oluşturulan ilanlar ilgili hizmet kategorisindeki uygun ustalara iletilir.`,
 (d,c,dL) => `${d} ilçesinde ilan verdiğinde ustalar tekliflerini iletir.`,
 (d,c,dL) => `${d} için yayınladığın ilan ${c} içindeki ilgili ustalara yönlendirilir.`,
 (d,c,dL) => `${d} ilçesi için açtığın ilan ilgili hizmet kategorisindeki ustalara iletilir.`,
 (d,c,dL) => `${d} için ilan oluşturduktan sonra teklifleri karşılaştırarak ustanı seçebilirsin.`
]
const allFaqTopics = ['usta-fiyatlari','komisyon','ilan-verme','teklif-alma','hizmetler','dis-usta','kesif','ilan-suresi','hugai']
function getAutoServiceFocus(citySlug: string, districtSlug: string): string[] { return pickDeterministic(jobs, `${citySlug}/${districtSlug}/services`, 10).map(j => j.slug) }
function getAutoLocalIntro(citySlug: string, districtSlug: string, dName: string, cName: string, dLoc: string): string { const tmpl = pickDeterministic(safeLocalIntroTemplates, `${citySlug}/${districtSlug}/localIntro`, 1)[0]; return tmpl(dName, cName, dLoc) }
function getAutoDemandNote(citySlug: string, districtSlug: string, dName: string, cName: string, dLoc: string): string { const tmpl = pickDeterministic(safeDemandNoteTemplates, `${citySlug}/${districtSlug}/demandNote`, 1)[0]; return tmpl(dName, cName, dLoc) }
function getAutoFaqTopics(citySlug: string, districtSlug: string): string[] { return pickDeterministic(allFaqTopics, `${citySlug}/${districtSlug}/faq`, 4) }
function getAutoDistrictPriority(city: typeof cities[0], districtSlug: string): string[] { return city.districts.filter(d=>d.slug!==districtSlug).map(d=>d.slug) }
function getDistrictSEOData(city: typeof cities[0], district: {slug: string, name: string}): DistrictSEOData {
 const key = `${city.slug}/${district.slug}`
 const override = districtSEODataOverride[key] || {}
 const dLoc = loc(district.name)
 return {
  serviceFocus: override.serviceFocus?? getAutoServiceFocus(city.slug, district.slug),
  localIntro: override.localIntro?? getAutoLocalIntro(city.slug, district.slug, district.name, city.name, dLoc),
  demandNote: override.demandNote?? getAutoDemandNote(city.slug, district.slug, district.name, city.name, dLoc),
  faqTopics: override.faqTopics?? getAutoFaqTopics(city.slug, district.slug),
  nearbyPriority: override.nearbyPriority?? getAutoDistrictPriority(city, district.slug)
 }
}
// v15 - DÜRÜST introlar - eski komisyon söylemleri temizlendi, yeni slogan entegre - 60-95 kelime aralığı
const introVariants: Array<(dName: string, cName: string, dLoc: string) => string> = [
 (d,c,dL) => `${dL} oluşturduğun iş ilanı hizmet alanına göre uygun ${c} ustalarına iletilir ve hızlı teklif alma imkanı sunar, süreci hızlandırır. HugAI tahmini piyasa fiyat aralığını gösterir ve bütçe planlamana net yardımcı olur, ön bilgi sağlar. ${dL} iç cephe boya, su tesisatı, elektrik tesisatı, fayans, parke, mutfak dolabı, banyo tadilatı gibi branşlarda kolayca ilan verebilirsin ve doğrudan şeffaf şekilde eşleşirsin. ${SLOGAN_FULL}`,
 (d,c,dL) => `${d} için açtığın ilan ${c} genelindeki ilgili ustaların ekranına düşer ve teklif süreci hemen başlar, bildirim gider. HugAI yaklaşık piyasa fiyat aralığını sunar ve bütçe planlamana yardımcı olur, fikir verir. ${dL} boya badana, alçı sıva, mutfak dolabı, banyo tadilatı, parke, elektrik ve su tesisatı gibi kategorilerde hizmet alabilirsin ve teklifleri karşılaştırarak en uygun ustayı seçebilirsin. Sistem tamamen şeffaf ilerler, gizli maliyet yoktur ve kazanç doğrudan ustada kalır. Platform yeni ve şeffaf bir modelle büyüyor ve birlikte kazanmaya odaklanıyor. ${SLOGAN_LINE1}`,
 (d,c,dL) => `${dL} yayınladığın ilan uygun kategorideki ${c} ustalarına iletilir ve teklif toplama süreci hızlıca başlar, ustalar görür. HugAI tahmini piyasa fiyatını gösterir ve yaklaşık maliyet aralığı hakkında net bilgi sunar, bütçeni korur. ${dL} ev ve iş yeri tadilatlarında boya, tesisat, elektrik, fayans, parke, mutfak dolabı gibi branşlarda ${c} ustalarıyla kolayca eşleşme sağlar ve süreci baştan sona güvenle yönetebilirsin. Birlikte büyüyüp birlikte kazanacağız ve şeffaf kalacağız.`,
 (d,c,dL) => `${d} için açılan ilanlar ilgili branştaki deneyimli ustalara yönlendirilir ve teklif modeli ile sorunsuz çalışır, eşleşme hızlıdır. HugAI tahmini piyasa fiyat aralığını gösterir ve detaylı ön bilgilendirme sağlar, maliyet netleşir. ${dL} iç ve dış cephe boya, seramik döşeme, parke, PVC doğrama, çatı izolasyonu, mantolama gibi hizmetlerde hızlıca ilan verebilirsin ve bütçene uygun çözümler bulabilirsin. Biz yeniyiz ama kendimize güveniyoruz ve birlikte büyümeye inanıyoruz. ${SLOGAN_LINE2}`,
 (d,c,dL) => `${dL} oluşturduğun ilan ${c} içindeki uygun ustalara iletilir ve teklif süreci anında başlar, zaman kazandırır. HugAI yaklaşık piyasa fiyatını gösterir ve bütçene göre net ön bilgi sunar, plan yaparsın. ${dL} mutfak dolabı yenileme, banyo tadilatı, elektrik tesisatı, su tesisatı, fayans, parke, boya badana gibi alanlarda güvenilir usta bulabilirsin ve detayları doğrudan konuşabilirsin. İş senin, emek senin, kazanç senin modeliyle ilerliyoruz ve gizli maliyet asla yok.`,
 (d,c,dL) => `${d} için yayınladığın ilan seçtiğin hizmet kategorisindeki profesyonel ustalara yönlendirilir ve hızlı eşleştirme yapılır, teklifler toplanır. HugAI tahmini piyasa fiyat aralığını gösterir ve yaklaşık maliyet hakkında net bilgi verir, bütçeni korur. ${dL} boya, alçı, parke, tesisat, mobilya montajı, mutfak dolabı, banyo yenileme gibi işler için tek ilan yeterli olur ve zaman kazandırır. Birlikte büyüyüp birlikte kazanacağımız bir sistem kuruyoruz ve dürüstlüğü her zaman önceliyoruz.`,
 (d,c,dL) => `${dL} ilan oluşturduğunda ilan uygun branştaki ${c} ustalarına iletilir ve ustalar tekliflerini hızla iletir, süreç hızlanır. HugAI tahmini piyasa fiyatını gösterir ve yaklaşık aralık hakkında net bilgi sunar, ön fikir verir. ${dL} iç cephe boya, dış cephe boya, elektrik tesisatı, su tesisatı, fayans döşeme, parke, mutfak dolabı gibi hizmetler için ilan açabilirsin ve süreci kolayca yönetebilirsin. Yeni bir platformuz, dürüst ve şeffaf ilerlemeyi seçiyoruz ve abartıdan uzak duruyoruz.`,
 (d,c,dL) => `${d} için oluşturulan ilanlar ${c} genelinde hizmet veren ilgili ustalara iletilir ve anında eşleştirme yapılır, bildirim iletilir. HugAI yaklaşık piyasa fiyat aralığını gösterir ve detaylı ön bilgilendirme sağlar, bütçeni planlarsın. ${dL} boya badana, alçı sıva, banyo tadilatı, parke döşeme, fayans, elektrik, su tesisatı gibi hizmetlerde usta bulman mümkün olur ve hızlıca teklif alabilirsin. İşi sen yönetirsin, süreci kontrol edersin. ${SLOGAN_FULL}`,
 (d,c,dL) => `${dL} yayınladığın ilan hizmet kategorisine göre akıllıca eşleştirilir ve uygun ustalara hızlıca iletilir, zaman kazandırır. HugAI tahmini piyasa fiyatını gösterir ve bütçe planlamana yardımcı olur, maliyet netleşir. ${dL} tesisat, elektrik, boya, parke, mantolama, mutfak dolabı, banyo yenileme gibi işler için hızlıca ilan verebilirsin ve karşılaştırma yaparak karar verebilirsin. Beraber büyüyeceğiz, kazancı usta ve müşteri birlikte görecek ve şeffaf bir düzen kuracağız.`,
 (d,c,dL) => `${dL} oluşturduğun ilan ${c} içindeki ilgili ustalara yönlendirilir ve teklif toplama hemen başlar, ustalar teklif verir. HugAI yaklaşık piyasa fiyat aralığını gösterir ve bütçe için net ön bilgi sunar, plan yaparsın. ${dL} mutfak, banyo ve salon tadilatı için kolayca ilan açabilirsin ve ihtiyacını net anlatabilirsin. Elektrik, su tesisatı, fayans, parke ve boya gibi branşlarda kaliteli hizmet alabilirsin ve süreci güvenle tamamlayabilirsin. ${SLOGAN_LINE2}`,
 (d,c,dL) => `${d} için açtığın ilan ${c} genelinde ilgili kategoride hizmet veren ustalara iletilir ve hızlı eşleştirme yapılır, teklifler gelir. HugAI tahmini piyasa fiyatını gösterir ve yaklaşık maliyet aralığı hakkında net bilgi sunar, bütçeni korur. ${dL} iç cephe boya, dış cephe boya, alçı sıva, seramik, tesisat, elektrik, parke gibi alanlarda usta bulabilirsin ve teklifleri inceleyebilirsin. Yeniyiz, iddialıyız ve birlikte kazanmaya odaklanıyoruz, yalan istatistikler olmadan dürüst büyüyoruz.`,
 (d,c,dL) => `${d} için yayınladığın ilan ${c} içindeki uygun ustalara yönlendirilir ve teklif süreci hemen başlar, ustalar görür. HugAI yaklaşık piyasa fiyat aralığını gösterir ve detaylı ön bilgilendirme sağlar, maliyet netleşir. ${dL} boya, tesisat, elektrik, fayans, parke, mutfak dolabı, banyo tadilatı gibi branşlarda kaliteli hizmet alabilirsin ve ustalarla doğrudan iletişime geçebilirsin. Platformda gizli maliyet yok, süreç baştan sona şeffaf ilerliyor ve güven üzerine kurulu şekilde yönetiliyor.`,
 (d,c,dL) => `${dL} yayınladığın ilan hizmet alanına göre profesyonelce eşleştirilir ve uygun ustalara iletilir, teklifler hızlıca toplanır. HugAI tahmini piyasa fiyat aralığını gösterir ve bütçe planlamana net yardımcı olur, ön bilgi sunar. ${dL} mutfak dolabı, banyo yenileme, boya badana, elektrik tesisatı, su tesisatı, parke, fayans gibi işler için usta bulabilirsin ve süreci hızla başlatabilirsin. ${SLOGAN_LINE1} Anlayışıyla hareket ediyoruz ve birlikte büyümeyi her zaman hedefliyoruz.`,
 (d,c,dL) => `${dL} oluşturduğun ilan ilgili branştaki ${c} ustalarına iletilir ve ustalar tekliflerini hızla iletir, eşleşme sağlanır. HugAI yaklaşık piyasa fiyatını gösterir ve detaylı ön bilgilendirme sağlar, bütçeni planlarsın. ${dL} iç cephe boya, dış cephe boya, çatı izolasyonu, PVC doğrama, su tesisatı, elektrik, parke gibi hizmetlerde ilan verebilirsin ve bütçeni koruyabilirsin. Yeni olmamıza rağmen kendimize güveniyoruz, birlikte büyüyeceğiz ve dürüst kalarak hep birlikte kazanacağız.`,
 (d,c,dL) => `${d} için açılan ilanlar seçtiğin kategoriye göre hızlıca yönlendirilir ve profesyonel eşleştirme yapılır, ustalar teklif verir. HugAI tahmini piyasa fiyat aralığını gösterir ve yaklaşık maliyet hakkında net bilgi verir, fikir edinirsin. ${dL} boya, fayans, parke, tesisat, elektrik, mantolama, mutfak dolabı, banyo gibi işlerde ilan verebilirsin ve hızlıca sonuç alabilirsin. Kazanç ustanın, iş senin, emek senin ve modelimiz tamamen şeffaf ve yalansız şekilde ilerliyor.`,
 (d,c,dL) => `${dL} yayınladığın ilan ${c} içindeki ilgili ustalara iletilir ve teklif toplama hemen başlar, ustalar dönüş yapar. HugAI yaklaşık piyasa fiyatını gösterir ve bütçe planlamana net yardımcı olur, ön bilgi sağlar. ${dL} banyo tadilatı, mutfak yenileme, boya, alçı, parke, fayans, elektrik tesisatı gibi alanlarda hizmet alabilirsin ve teklifleri kolayca karşılaştırabilirsin. Şeffaf, yalansız ve birlikte kazanmaya odaklı bir yapı kuruyoruz ve abartılı vaatlerden uzak duruyoruz.`,
 (d,c,dL) => `${dL} ilan oluşturduğunda ilan uygun kategorideki ${c} ustalarına yönlendirilir ve hızlı eşleştirme yapılır, zaman kazanırsın. HugAI tahmini piyasa fiyat aralığını gösterir ve bütçe için net ön bilgi sunar, maliyet netleşir. ${dL} iç cephe boya, dış cephe boya, elektrik tesisatı, su tesisatı, parke, fayans, mutfak dolabı gibi hizmetlerde usta bulabilirsin ve doğrudan anlaşabilirsin. Üyelik yok, komisyon yok, sonradan kesinti yok ve süreç tamamen senin kontrolünde ilerliyor.`,
 (d,c,dL) => `${d} için açtığın ilan ${c} genelindeki ilgili ustalara iletilir ve uygun ustalara anında yönlendirilir, bildirim gider. HugAI yaklaşık piyasa fiyat aralığını gösterir ve bütçe planlamana net yardımcı olur, bütçeni korur. ${dL} boya badana, alçı sıva, parke döşeme, banyo tadilatı, elektrik, su tesisatı, fayans gibi hizmetlerde ilan verebilirsin ve kısa sürede dönüş alabilirsin. Birlikte büyüyüp birlikte kazanacağız mottosuyla ilerliyoruz ve güven inşa ediyoruz.`,
 (d,c,dL) => `${dL} yayınladığın ilan hizmet kategorisine göre uygun ustalara iletilir eşleştirme yapılır ve teklif süreci başlar, ustalar görür. HugAI tahmini piyasa fiyatını gösterir ve yaklaşık maliyet aralığı hakkında net bilgi sunar, ön fikir verir. ${dL} tesisat, elektrik, boya, parke, mutfak dolabı, banyo tadilatı gibi işler için ilan verebilirsin ve bütçeni aşmadan çözüm bulabilirsin. Süreci sen yönetirsin ve kontrol sende kalır. ${SLOGAN_FULL}`,
 (d,c,dL) => `${d} için oluşturulan ilan ${c} içindeki ilgili branştaki ustalara yönlendirilir eşleştirme yapılır ve teklif toplama başlar, ustalar teklif verir. HugAI yaklaşık piyasa fiyat aralığını gösterir ve detaylı ön bilgilendirme sağlar, maliyet netleşir. ${dL} boya, fayans, parke, tesisat, elektrik, mutfak dolabı, banyo gibi işlerde tek ilan ile teklif toplayabilirsin ve hızlıca karar verebilirsin. Yeniyiz ama iddialıyız, şeffaf modelle büyüyoruz ve birlikte kazanmaya odaklanıyoruz.`,
]

const faqTemplates = [
 { q: (d:string)=> `${d} usta fiyatları nasıl belirleniyor?`, a: (d:string,c:string,dL:string)=> `${dL} fiyatlar HugAI tahmini piyasa fiyat aralığı olarak gösterilir. Teklif doğrudan ustadan gelir. ${SLOGAN_FULL}`, topic: 'usta-fiyatlari' },
 { q: (d:string)=> `${d} için ek komisyon var mı?`, a: (d:string,c:string,dL:string)=> `Hayır. ${SLOGAN_LINE2} Modelimiz budur: ${SLOGAN_LINE1}`, topic: 'komisyon' },
 { q: (d:string)=> `${d} ilanına nasıl teklif alırım?`, a: (d:string,c:string,dL:string)=> `${dL} ilan oluşturduğunda ilan ${c} içindeki ilgili kategorideki ustalara iletilir. Ustalar tekliflerini iletir ve sen uygun olanı seçerek iletişime geçebilirsin.`, topic: 'ilan-verme' },
 { q: (d:string)=> `${d} hangi hizmetlerde usta bulabilirim?`, a: (d:string,c:string,dL:string)=> `${dL} boya, alçı, fayans, parke, tesisat, elektrik, doğalgaz, çatı, mutfak dolabı ve banyo tadilatı gibi tüm branşlarda ilan açabilirsin.`, topic: 'hizmetler' },
 { q: (d:string)=> `${d} dışından usta gelebilir mi?`, a: (d:string,c:string,dL:string)=> `Evet. ${c} genelindeki ustalar ${dL} için teklif verebilir. İlanın uygun ustalara iletilir, teklif verenler arasından seçim yapabilirsin.`, topic: 'dis-usta' },
 { q: (d:string)=> `${d} ön analiz ücreti var mı?`, a: (d:string,c:string,dL:string)=> `${dL} HugAI tahmini piyasa fiyat aralığını ücretsiz olarak gösterir. Detaylı değerlendirme gerekirse usta ile doğrudan görüşebilirsin.`, topic: 'kesif' },
 { q: (d:string)=> `${d} için nasıl ilan oluştururum?`, a: (d:string,c:string,dL:string)=> `${dL} iş detaylarını ve ölçülerini ekleyerek ilan oluşturabilirsin. İlan yayınlandığında uygun ustalara iletilir.`, topic: 'ilan-verme' },
 { q: (d:string)=> `${d} ustaları nasıl seçiliyor?`, a: (d:string,c:string,dL:string)=> `${dL} ilan oluşturduğunda sistem hizmet kategorine göre uygun ${c} ustalarına iletim yapar. Ustalar teklif verir, sen de uygun olanı seçersin.`, topic: 'teklif-alma' },
 { q: (d:string)=> `${d} için HugAI ne yapar?`, a: (d:string,c:string,dL:string)=> `HugAI ${dL} için tahmini piyasa fiyat aralığını gösterir ve bütçe planlamana yardımcı olur. Bu aralık ${c} koşullarına göre ön bilgilendirme amaçlıdır ve kesin fiyat değildir.`, topic: 'hugai' },
 { q: (d:string)=> `${d} ilanım ne kadar süre yayında kalır?`, a: (d:string,c:string,dL:string)=> `${dL} oluşturduğun ilan teklifler gelene kadar yayında kalır. Teklifleri karşılaştırarak dilediğin zaman ustanı seçebilirsin.`, topic: 'ilan-suresi' }
]
const faqTopicMap: Record<string, number[]> = { 'usta-fiyatlari': [0], 'komisyon': [1], 'ilan-verme': [2,6], 'teklif-alma': [7,2], 'hizmetler': [3], 'dis-usta': [4], 'kesif': [5,8], 'ilan-suresi': [9], 'hugai': [8,0] }
const nearbyMap: Record<string, string[]> = {
 'adana': ['mersin','osmaniye','hatay','kahramanmaras','nigde','kayseri'],'adiyaman': ['kahramanmaras','gaziantep','sanliurfa','diyarbakir','malatya'],'afyonkarahisar': ['kutahya','eskisehir','konya','isparta','denizli','usak'],'agri': ['kars','igdir','van','bitlis','mus','erzurum'],'amasya': ['samsun','tokat','corum','yozgat','cankiri'],'ankara': ['kirikkale','konya','eskisehir','cankiri','bolu','kirsehir'],'antalya': ['mugla','burdur','isparta','konya','karaman','mersin'],'artvin': ['rize','erzurum','ardahan','kars'],'aydin': ['izmir','manisa','denizli','mugla'],'balikesir': ['canakkale','bursa','kutahya','manisa','izmir'],'bilecik': ['bursa','kutahya','eskisehir','sakarya','bolu'],'bingol': ['elazig','diyarbakir','mus','erzurum','tunceli'],'bitlis': ['van','mus','siirt','batman','diyarbakir'],'bolu': ['duzce','sakarya','bursa','bilecik','eskisehir','ankara','zonguldak'],'burdur': ['antalya','isparta','afyonkarahisar','denizli','mugla'],'bursa': ['yalova','kocaeli','bilecik','kutahya','balikesir','sakarya'],'canakkale': ['balikesir','tekirdag','edirne'],'cankiri': ['ankara','bolu','karabuk','kastamonu','corum','kirikkale'],'corum': ['samsun','amasya','yozgat','kirikkale','cankiri','sinop'],'denizli': ['mugla','aydin','manisa','usak','afyonkarahisar','burdur'],'diyarbakir': ['batman','mardin','sanliurfa','adiyaman','malatya','elazig','bingol'],'edirne': ['kirklareli','tekirdag','canakkale'],'elazig': ['malatya','diyarbakir','bingol','tunceli'],'erzincan': ['erzurum','tunceli','elazig','sivas','gumushane','bayburt'],'erzurum': ['kars','agri','mus','bingol','erzincan','bayburt','rize','artvin'],'eskisehir': ['bursa','kutahya','afyonkarahisar','ankara','bolu','bilecik'],'gaziantep': ['kilis','hatay','osmaniye','kahramanmaras','adiyaman','sanliurfa'],'giresun': ['trabzon','gumushane','erzincan','sivas','ordu'],'gumushane': ['trabzon','bayburt','erzincan','giresun','rize'],'hakkari': ['van','sirnak'],'hatay': ['adana','osmaniye','gaziantep','kilis'],'isparta': ['burdur','antalya','konya','afyonkarahisar'],'mersin': ['adana','karaman','konya','nigde','antalya','kahramanmaras'],'istanbul': ['kocaeli','tekirdag','yalova','bursa','sakarya'],'izmir': ['manisa','aydin','balikesir','denizli','usak'],'kars': ['ardahan','erzurum','agri','igdir'],'kastamonu': ['sinop','corum','cankiri','karabuk','bartin'],'kayseri': ['sivas','yozgat','nevsehir','nigde','adana','kahramanmaras'],'kirklareli': ['edirne','tekirdag','istanbul'],'kirsehir': ['yozgat','nevsehir','aksaray','ankara','kirikkale'],'kocaeli': ['istanbul','sakarya','bursa','yalova'],'konya': ['ankara','aksaray','karaman','antalya','isparta','afyonkarahisar','eskisehir','nigde'],'kutahya': ['bursa','bilecik','eskisehir','afyonkarahisar','usak','manisa','balikesir'],'malatya': ['elazig','diyarbakir','adiyaman','kahramanmaras','sivas','erzincan'],'manisa': ['izmir','balikesir','kutahya','usak','denizli','aydin'],'kahramanmaras': ['osmaniye','adana','kayseri','sivas','malatya','adiyaman','gaziantep'],'mardin': ['sanliurfa','diyarbakir','batman','sirnak','siirt'],'mugla': ['aydin','denizli','burdur','antalya'],'mus': ['bingol','diyarbakir','batman','bitlis','van','agri','erzurum'],'nevsehir': ['kirsehir','aksaray','nigde','kayseri','yozgat'],'nigde': ['kayseri','adana','mersin','konya','aksaray','nevsehir'],'ordu': ['samsun','tokat','sivas','giresun'],'rize': ['trabzon','artvin','erzurum','bayburt'],'sakarya': ['kocaeli','duzce','bolu','bilecik','bursa','istanbul'],'samsun': ['ordu','tokat','amasya','corum','sinop'],'siirt': ['batman','bitlis','van','sirnak','mardin'],'sinop': ['kastamonu','corum','samsun'],'sivas': ['tokat','ordu','giresun','erzincan','malatya','kayseri','yozgat'],'tekirdag': ['istanbul','kirklareli','edirne','canakkale'],'tokat': ['amasya','samsun','ordu','sivas','yozgat'],'trabzon': ['rize','gumushane','giresun','bayburt'],'tunceli': ['erzincan','elazig','bingol','erzurum'],'sanliurfa': ['gaziantep','adiyaman','diyarbakir','mardin','sirnak'],'usak': ['manisa','kutahya','afyonkarahisar','denizli'],'van': ['agri','bitlis','siirt','sirnak','hakkari','mus'],'yozgat': ['corum','amasya','tokat','sivas','kayseri','kirsehir','cankiri','kirikkale'],'zonguldak': ['duzce','bolu','karabuk','bartin'],'aksaray': ['konya','nigde','nevsehir','kirsehir','ankara'],'bayburt': ['trabzon','rize','erzurum','erzincan','gumushane'],'karaman': ['konya','mersin','antalya'],'kirikkale': ['ankara','cankiri','corum','yozgat','kirsehir'],'batman': ['diyarbakir','mardin','siirt','bitlis','mus'],'sirnak': ['mardin','siirt','van','hakkari','sanliurfa'],'bartin': ['zonguldak','karabuk','kastamonu'],'ardahan': ['kars','artvin','erzurum'],'igdir': ['kars','agri'],'yalova': ['kocaeli','bursa','istanbul','sakarya'],'karabuk': ['bolu','kastamonu','cankiri','bartin','zonguldak'],'kilis': ['gaziantep','hatay'],'osmaniye': ['adana','hatay','gaziantep','kahramanmaras'],'duzce': ['bolu','sakarya','zonguldak'],
}
function validateBuildData() {
 if (cities.length!==81) throw new Error(`[BUILD FAIL] cities.length=${cities.length}`)
 const citySlugSet = new Set(cities.map(c=>c.slug))
 if (citySlugSet.size!==81) throw new Error(`[BUILD FAIL] duplicate city slug`)
 const nearbyKeys = Object.keys(nearbyMap)
 if (nearbyKeys.length!==81) throw new Error(`[BUILD FAIL] nearbyMap count=${nearbyKeys.length}`)
 const nearbyKeySet = new Set(nearbyKeys)
 for (const cSlug of citySlugSet) { if (!nearbyKeySet.has(cSlug)) throw new Error(`[BUILD FAIL] nearbyMap eksik şehir: ${cSlug}`) }
 for (const key of nearbyKeys) { if (!citySlugSet.has(key)) throw new Error(`[BUILD FAIL] nearbyMap geçersiz şehir slug: ${key}`) }
 for (const [k, vals] of Object.entries(nearbyMap)) {
  for (const v of vals) { if (!citySlugSet.has(v)) throw new Error(`[BUILD FAIL] nearbyMap[${k}] geçersiz komşu: ${v}`); if (v===k) throw new Error(`[BUILD FAIL] nearbyMap[${k}] kendisini içeriyor`) }
  if (new Set(vals).size!== vals.length) throw new Error(`[BUILD FAIL] nearbyMap[${k}] duplicate komşu var`)
 }
 if (jobs.length!==43) throw new Error(`[BUILD FAIL] jobs.length=${jobs.length}`)
 const districtCount = cities.reduce((s,c)=>s+c.districts.length,0)
 if (districtCount!==973) throw new Error(`[BUILD FAIL] districtCount=${districtCount}`)
 for (const city of cities) {
  const dSlugs = city.districts.map(d=>d.slug)
  if (new Set(dSlugs).size!== dSlugs.length) { const dup = dSlugs.find((s,i)=>dSlugs.indexOf(s)!==i); throw new Error(`[BUILD FAIL] ${city.slug} içinde duplicate ilçe slug: ${dup}`) }
 }
 const jobSet = new Set(jobs.map(j=>j.slug))
 if (cities.flatMap(c=>c.districts.map(d=>d.slug)).filter(d=>jobSet.has(d)).length>0) throw new Error(`[BUILD FAIL] JOB ∩ DISTRICT`)
 introVariants.forEach((variant, i) => { const sample = variant('Salihli', 'Manisa', "Salihli'de"); const wc = countWords(sample); if (wc < 60 || wc > 95) { throw new Error(`[BUILD FAIL] introVariants[${i}] = ${wc} kelime. Base intro 60-95 arası olmalı.`) } })
 const jobSlugSet = new Set(jobs.map(j => j.slug))
 for (const [key, data] of Object.entries(districtSEODataOverride)) {
  const [citySlug, districtSlug] = key.split('/'); if (!citySlug ||!districtSlug) throw new Error(`[BUILD FAIL] Geçersiz key: ${key}`); const city = cities.find(c => c.slug === citySlug); if (!city) throw new Error(`[BUILD FAIL] geçersiz şehir: ${key}`); const district = city.districts.find(d=>d.slug===districtSlug); if (!district) throw new Error(`[BUILD FAIL] geçersiz ilçe: ${key}`); for (const s of data.serviceFocus?? []) { if (!jobSlugSet.has(s)) throw new Error(`[BUILD FAIL] ${key} geçersiz serviceFocus: ${s}`) }; for (const s of data.nearbyPriority?? []) { if (!city.districts.some(d => d.slug === s)) throw new Error(`[BUILD FAIL] ${key} geçersiz nearbyPriority: ${s}`); if (s === districtSlug) throw new Error(`[BUILD FAIL] ${key} nearbyPriority kendisini içeriyor: ${s}`) }; if (data.nearbyPriority && new Set(data.nearbyPriority).size!== data.nearbyPriority.length) { throw new Error(`[BUILD FAIL] ${key} nearbyPriority içinde duplicate var`) }
 }
 let autoCount = 0
 for (const city of cities) { for (const district of city.districts) { const data = getDistrictSEOData(city, district); if (!data.serviceFocus.length) throw new Error(`[BUILD FAIL] ${city.slug}/${district.slug} serviceFocus boş`); if (!data.localIntro) throw new Error(`[BUILD FAIL] ${city.slug}/${district.slug} localIntro boş`); if (!data.demandNote) throw new Error(`[BUILD FAIL] ${city.slug}/${district.slug} demandNote boş`); if (!data.faqTopics.length) throw new Error(`[BUILD FAIL] ${city.slug}/${district.slug} faqTopics boş`); if (!data.nearbyPriority.length) throw new Error(`[BUILD FAIL] ${city.slug}/${district.slug} nearbyPriority boş`); const dLoc = loc(district.name); const base = introVariants[hashString(`${city.slug}/${district.slug}`) % introVariants.length](district.name, city.name, dLoc); const finalIntro = `${data.localIntro} ${base}`; const wc = countWords(finalIntro); if (wc < 75 || wc > 145) { throw new Error(`[BUILD FAIL] ${city.slug}/${district.slug} final intro = ${wc} kelime. 75-145 arası olmalı.`) }; autoCount++ } }
 if (autoCount!== 973) throw new Error(`[BUILD FAIL] count=${autoCount}`)
}
export function generateStaticParams(){
 validateBuildData()
 const params: {city: string, slug: string}[] = []
 for(const c of cities){ for(const j of jobs){ params.push({city: c.slug, slug: j.slug}) }; for(const d of c.districts){ params.push({city: c.slug, slug: d.slug}) } }
 if(params.length!== 4456) throw new Error(`[BUILD FAIL] params.length=${params.length}`)
 return params
}
export async function generateMetadata({params}:{params: Promise<{city:string,slug:string}>}): Promise<Metadata>{
 const { city: citySlug, slug } = await params
 const city = cities.find(c=>c.slug===citySlug)
 if(!city) notFound()
 const job = jobs.find(j=>j.slug===slug)
 if(job){ const seoData = getCityJobData(city.slug, job.slug); if(!seoData) notFound(); const canonical = `https://hemenustamgelsin.com/${city.slug}/${job.slug}`; return { title: seoData.metaTitle, description: seoData.metaDescription, alternates: { canonical }, openGraph: { title: seoData.metaTitle, description: seoData.metaDescription, url: canonical, type: 'website', locale: 'tr_TR', siteName: 'Hemen Ustam Gelsin' }, twitter: { card: 'summary_large_image', title: seoData.metaTitle, description: seoData.metaDescription }, robots: { index: true, follow: true } } }
 const district = city.districts.find(d=>d.slug===slug)
 if(district){ const dLoc = loc(district.name); const title = `${district.name} Ustaları | ${city.name} – ${SLOGAN_LINE1}`; const description = `${dLoc} usta bul, teklif al. ${SLOGAN_FULL} HugAI tahmini fiyatı ve doğrudan teklif sistemiyle işini başlat.`; const canonical = `https://hemenustamgelsin.com/${city.slug}/${district.slug}`; return { title, description, alternates: { canonical }, openGraph: { title, description, url: canonical, type: 'website', locale: 'tr_TR', siteName: 'Hemen Ustam Gelsin' }, twitter: { card: 'summary_large_image', title, description }, robots: { index: true, follow: true } } }
 notFound()
}
function getNearbyCities(currentSlug: string) { return cities.filter(c => (nearbyMap[currentSlug]||[]).includes(c.slug)).slice(0,12) }
function buildDistrictIntro(dName: string, cName: string, dLoc: string, city: typeof cities[0], district: {slug: string, name: string}): string {
 const seoData = getDistrictSEOData(city, district)
 const introIdx = hashString(`${city.slug}/${district.slug}`) % introVariants.length
 return `${seoData.localIntro} ${introVariants[introIdx](dName, cName, dLoc)}`
}
function getDistrictServiceLinks(city: typeof cities[0], district: {slug: string, name: string}){ return getDistrictSEOData(city, district).serviceFocus.map(slug=>jobs.find(j=>j.slug===slug)).filter(Boolean) as typeof jobs }
function getSiblingDistricts(city: typeof cities[0], district: {slug: string, name: string}){ return city.districts.filter(d=>d.slug!==district.slug) as typeof city.districts }
function getDistrictFAQs(city: typeof cities[0], district: {slug: string, name: string}, dName: string, cName: string, dLoc: string){
 const seoData = getDistrictSEOData(city, district)
 let pool = faqTemplates
 const wantedTopics = new Set(seoData.faqTopics)
 const filteredIndices: number[] = []
 for(const topic of wantedTopics) for(const idx of (faqTopicMap[topic] || [])) if(!filteredIndices.includes(idx)) filteredIndices.push(idx)
 if(filteredIndices.length >= 3) pool = filteredIndices.map(i=>faqTemplates[i]).filter(Boolean)
 return pickDeterministic(pool, `${city.slug}/${district.slug}`, 4).map(t=>({ q: t.q(dName), a: t.a(dName, cName, dLoc) }))
}
function getDistrictActionNote(city: typeof cities[0], district: {slug: string, name: string}){ return getDistrictSEOData(city, district).demandNote }

export default async function UnifiedCitySlugPage({params}:{params: Promise<{city:string,slug:string}>}){
 const { city: citySlug, slug } = await params
 const city = cities.find(c=>c.slug===citySlug)
 if(!city) notFound()
 const job = jobs.find(j=>j.slug===slug)
 if(job){
  const seoData = getCityJobData(city.slug, job.slug)
  if(!seoData) notFound()
  const ilceler = seoData.ilceler?? []
  const firstIlce = ilceler[0] || city.name
  const ilceCount = ilceler.length
  const s = job.slug.toLowerCase()
  let icon = '🛠', color = '#111'
  if(s.includes('boya')) { icon='🎨'; color='#db2777' }
  if(s.includes('elektrik')) { icon='⚡'; color='#f59e0b' }
  if(s.includes('tesisat')||s.includes('su')) { icon='🚿'; color='#0ea5e9' }
  if(s.includes('fayans')) { icon='🧱'; color='#a16207' }
  if(s.includes('klima')) { icon='❄'; color='#06b6d4' }
  if(s.includes('tavan')) { icon='🏗'; color='#57534e' }
  const pageUrl = `https://hemenustamgelsin.com/${city.slug}/${job.slug}`
  const serviceSchema = { "@context": "https://schema.org", "@type": "Service", "@id": `${pageUrl}#service`, "name": seoData.h1, "serviceType": job.name, "description": seoData.metaDescription, "provider": { "@id": "https://hemenustamgelsin.com/#organization" }, "areaServed": [{ "@type": "City", "name": city.name },...ilceler.map((d: string) => ({ "@type": "AdministrativeArea", "name": d }))], "url": pageUrl }
  const breadcrumbSchema = { "@context": "https://schema.org", "@type": "BreadcrumbList", "itemListElement": [ { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com" }, { "@type": "ListItem", "position": 2, "name": `${city.name} Ustaları`, "item": `https://hemenustamgelsin.com/${city.slug}` }, { "@type": "ListItem", "position": 3, "name": `${city.name} ${job.name}`, "item": pageUrl } ] }
  const faqSchema = { "@context": "https://schema.org", "@type": "FAQPage", "mainEntity": seoData.faqs.map((f: any) => ({ "@type": "Question", "name": f.q, "acceptedAnswer": { "@type": "Answer", "text": f.a } })) }
  return (
   <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
    <header style={{background:'rgba(255,255,255,0.92)', backdropFilter:'blur(12px)', borderBottom:'1px solid #e7e5e4', padding:'14px 20px', position:'sticky', top:0, zIndex:50}}>
     <div style={{maxWidth:1120, margin:'0 auto', display:'flex', alignItems:'center', justifyContent:'space-between', gap:12}}>
      <div style={{display:'flex', alignItems:'center', gap:12}}>
       <Link href="/" style={{display:'flex', alignItems:'center', gap:12, textDecoration:'none'}}>
        <img
         src="/assets/hug/app_logo.png"
         alt="Hemen Ustam Gelsin" style={{height:72, width:'auto', objectFit:'contain'}}
        />
        <div style={{width:1, height:32, background:'#e7e5e4'}} />
        <img
         src="/assets/hug/hug_logo.jpg"
         alt="Hug Market" style={{height:60, width:'auto', objectFit:'contain', borderRadius:8}}
        />
        <div style={{display:'flex', flexDirection:'column', lineHeight:1, marginLeft:4}}>
         <span style={{fontWeight:900, fontSize:17, letterSpacing:0.8, color:'#111'}}>HEMEN <span style={{color:'#111'}}>USTAM</span> <span style={{color:'#dc2626'}}>GELSİN</span></span>
         <span style={{fontSize:9.5, color:'#78716c', fontWeight:700, letterSpacing:0.3, marginTop:2, textTransform:'uppercase'}}>LÜX KURUMSAL • {SLOGAN_LINE1}</span>
        </div>
       </Link>
      </div>
      <div style={{display:'flex', alignItems:'center', gap:8}}>
       <Link href="/usta-kayit" style={{fontSize:12, fontWeight:800, color:'#44403c', background:'white', border:'1px solid #e7e5e4', padding:'10px 16px', borderRadius:999, textDecoration:'none'}}>USTA GİRİŞİ</Link>
       <Link href="/ilan-olustur" style={{fontSize:12, fontWeight:900, color:'white', background:'#111', padding:'10px 18px', borderRadius:999, textDecoration:'none', letterSpacing:0.5, boxShadow:'0 4px 12px rgba(0,0,0,0.12)'}}>İLAN VER →</Link>
      </div>
     </div>
    </header>
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(serviceSchema) }} />
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }} />
    <div style={{maxWidth:1120, margin:'0 auto', padding:'14px 20px 0', fontSize:12, color:'#a8a29e'}}><Link href={`/${city.slug}`} style={{color:'#78716c', textDecoration:'none'}}>{city.name} Ustaları</Link> <span> / </span> <b style={{color:'#111'}}>{job.name}</b></div>
    <section style={{ background: `radial-gradient(800px 400px at 15% 0%, ${color}15 0%, transparent 60%), #FFFBF5`, padding:'26px 20px 28px' }}>
     <style>{`@media(max-width:768px){.job-hero{grid-template-columns:1fr!important}.job-content{grid-template-columns:1fr!important}}`}</style>
     <div className="job-hero" style={{maxWidth:1120, margin:'0 auto', display:'grid', gridTemplateColumns:'1.15fr 0.85fr', gap:24}}>
      <div>
       <div style={{display:'inline-flex', gap:6, background:'white', border:'1px solid #e7e5e4', borderRadius:999, padding:'6px 10px', fontSize:11, fontWeight:800, marginBottom:14}}><span style={{background:color, color:'white', borderRadius:999, padding:'2px 8px'}}>{icon} {job.name.toUpperCase()}</span><span>{city.name.toUpperCase()} • HugAI • {SLOGAN_LINE1}</span></div>
       <h1 style={{fontSize:'clamp(28px, 4vw, 48px)', fontWeight:900, lineHeight:0.92, margin:0}}>{seoData.h1}<br/> HugAI Destekli Yaklaşık Fiyat Aralığı</h1>
       <p style={{fontSize:16, color:'#44403c', marginTop:12, maxWidth:560}}>{seoData.intro}</p>
       <div style={{marginTop:18, display:'flex', gap:10, flexWrap:'wrap'}}>
        <a href="https://hemenustamgelsin.com/ilan-olustur" style={{background:'#111', color:'white', padding:'14px 20px', borderRadius:12, fontWeight:900, textDecoration:'none'}}>HEMEN İLAN VER →</a>
        <a href="https://hemenustamgelsin.com/usta-kayit" style={{background:'white', color:'#111', padding:'14px 20px', borderRadius:12, fontWeight:800, border:'1px solid #e7e5e4', textDecoration:'none'}}>USTA OL, {city.name.toUpperCase()}'DA İŞ AL</a>
       </div>
      </div>
      <div style={{background:'white', borderRadius:18, border:'1px solid #e7e5e4', padding:16}}>
       <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>NASIL ÇALIŞIR?</div>
       <div style={{display:'grid', gap:10}}>
        <div style={{background:'#fafaf9', borderRadius:12, padding:'12px 10px'}}><div style={{fontWeight:800, fontSize:12}}>1. İhtiyacını Anlat</div><div style={{fontSize:11, color:'#57534e', marginTop:2}}>{city.name} {job.name.toLowerCase()} için iş detaylarını ve ölçülerini ekle, 2 dakikada ilan ver.</div></div>
        <div style={{background:'#f0fdf4', border:'1px solid #bbf7d0', borderRadius:12, padding:'12px 10px'}}><div style={{fontWeight:800, fontSize:12}}>2. HugAI Yaklaşık Fiyatı Göstersin</div><div style={{fontSize:11, color:'#166534', marginTop:2}}>HugAI tahmini piyasa fiyat aralığını gösterir ve bütçe planlamana yardımcı olur.</div></div>
        <div style={{background:'#fafaf9', borderRadius:12, padding:'12px 10px'}}><div style={{fontWeight:800, fontSize:12}}>3. Teklifleri Karşılaştır</div><div style={{fontSize:11, color:'#57534e', marginTop:2}}>{city.name} {firstIlce} dahil ustalar tekliflerini iletir, sen uygun olanı seçerek iletişime geçebilirsin.</div></div>
       </div>
      </div>
     </div>
    </section>
    <section className="job-content" style={{maxWidth:1120, margin:'0 auto', padding:'18px 20px 60px', display:'grid', gridTemplateColumns:'1.2fr 0.8fr', gap:18}}>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <h3>✅ Neden {city.name}'da {job.name} için Hemen Ustam Gelsin?</h3>
      <ul style={{fontSize:13, color:'#44403c', lineHeight:1.6}}>
       <li>{city.name} {firstIlce} için HugAI tahmini piyasa fiyatı - {seoData.fiyatBilgisi}</li>
       <li>{city.name} genelinde {ilceCount} ilçede usta eşleştirme ve teklif alma</li>
       <li>{SLOGAN_FULL}</li>
      </ul>
      <h4>Sık Sorulan Sorular</h4>{seoData.faqs.map((faq:any, i:number)=>(<div key={i} style={{marginBottom:10, background:'#fafaf9', borderRadius:10, padding:10}}><div style={{fontWeight:800, fontSize:13}}>{faq.q}</div><div style={{fontSize:12, color:'#444', marginTop:4}}>{faq.a}</div></div>))}
     </div>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <div style={{fontWeight:800, fontSize:13, marginBottom:8}}>{city.name} Yakın Çevresi - {job.name}</div>
      <div style={{display:'flex', flexWrap:'wrap', gap:6}}>{getNearbyCities(city.slug).map((c)=>(<Link key={c.slug} href={`/${c.slug}/${job.slug}`} style={{fontSize:12, padding:'7px 12px', background:'#fafaf9', border:'1px solid #e7e5e4', borderRadius:999, textDecoration:'none', color:'#444'}}>{c.name} {job.name}</Link>))}</div>
     </div>
    </section>
   </main>
  )
 }

 const district = city.districts.find(d=>d.slug===slug)
 if(district){
  const dName = district.name
  const cName = city.name
  const dLoc = loc(dName)
  const introText = buildDistrictIntro(dName, cName, dLoc, city, district)
  const localNote = getDistrictActionNote(city, district)
  const siblingDistricts = getSiblingDistricts(city, district)
  const districtServices = getDistrictServiceLinks(city, district)
  const faqs = getDistrictFAQs(city, district, dName, cName, dLoc)
  const canonical = `https://hemenustamgelsin.com/${city.slug}/${district.slug}`
  const title = `${dName} Ustaları | ${city.name} – ${SLOGAN_LINE1}`
  const h1 = `${dName} Ustaları – ${cName}`
  const breadcrumbSchema = { "@context": "https://schema.org", "@type": "BreadcrumbList", "@id": `${canonical}#breadcrumb`, "itemListElement": [ { "@type": "ListItem", "position": 1, "name": "Ana Sayfa", "item": "https://hemenustamgelsin.com" }, { "@type": "ListItem", "position": 2, "name": cName, "item": `https://hemenustamgelsin.com/${city.slug}` }, { "@type": "ListItem", "position": 3, "name": dName, "item": canonical } ] }
  const faqSchema = { "@context": "https://schema.org", "@type": "FAQPage", "mainEntity": faqs.map(f => ({ "@type": "Question", "name": f.q, "acceptedAnswer": { "@type": "Answer", "text": f.a } })) }
  const serviceSchema = { "@context": "https://schema.org", "@type": "Service", "@id": `${canonical}#service`, "name": `${dName} Ustaları`, "serviceType": "Usta ve Tadilat Hizmetleri", "description": `${dLoc} usta hizmetleri. ${SLOGAN_FULL}`, "provider": { "@id": "https://hemenustamgelsin.com/#organization" }, "areaServed": [{ "@type": "City", "name": cName }, { "@type": "AdministrativeArea", "name": dName }], "url": canonical }
  const webPageSchema = { "@context": "https://schema.org", "@type": "WebPage", "@id": canonical, "name": title, "description": `${dLoc} usta bul, teklif al. ${SLOGAN_FULL}`, "isPartOf": { "@id": "https://hemenustamgelsin.com/#website" }, "about": { "@id": `${canonical}#service` }, "breadcrumb": { "@id": `${canonical}#breadcrumb` } }

  return (
   <main style={{background:'#FFFBF5', minHeight:'100vh'}}>
    <header style={{background:'white', borderBottom:'1px solid #e7e5e4', padding:'10px 20px', position:'sticky', top:0, zIndex:50}}>
     <div style={{maxWidth:1120, margin:'0 auto', display:'flex', alignItems:'center', gap:12}}>
      <img src="/assets/hug/app_logo.png" alt="Hemen Ustam Gelsin" style={{height:72, width:'auto', objectFit:'contain'}} />
      <img src="/assets/hug/hug_logo.jpg" alt="Hug Market" style={{height:60, width:'auto', objectFit:'contain', borderLeft:'1px solid #e7e5e4', paddingLeft:14, marginLeft:6}} />
      <div style={{display:'flex', flexDirection:'column', lineHeight:1.1, marginLeft:8}}>
       <span style={{fontWeight:900, fontSize:18, letterSpacing:0.5}}>HEMEN <span style={{color:'#111'}}>USTAM</span> <span style={{color:'#dc2626'}}>GELSİN</span></span>
       <span style={{fontSize:11, color:'#111', fontWeight:800, lineHeight:1.3}}>{SLOGAN_LINE1} {SLOGAN_LINE2}</span>
      </div>
     </div>
    </header>
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbSchema) }} />
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }} />
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(serviceSchema) }} />
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(webPageSchema) }} />
    <div style={{maxWidth:1120, margin:'0 auto', padding:'14px 20px 0', fontSize:12, color:'#a8a29e'}}><Link href="/" style={{color:'#78716c', textDecoration:'none'}}>Ana Sayfa</Link><span> / </span><Link href={`/${city.slug}`} style={{color:'#78716c', textDecoration:'none'}}>{cName}</Link><span> / </span><b style={{color:'#111'}}>{dName}</b></div>

    <section style={{maxWidth:1120, margin:'0 auto', padding:'20px 20px 0'}}>
     <div style={{background:'#FFFBF5', border:'1px solid #111', borderRadius:12, padding:'12px 14px', fontSize:13, fontWeight:700, color:'#111'}}>
      {dLoc} usta bul. {SLOGAN_FULL} • {localNote}
     </div>
    </section>

    <section style={{maxWidth:1120, margin:'0 auto', padding:'20px 20px'}}>
     <h1 style={{fontSize:'clamp(28px, 4vw, 42px)', fontWeight:900, margin:0}}>{h1}</h1>
     <p style={{fontSize:15, color:'#44403c', marginTop:12, lineHeight:1.7, maxWidth:760}}>{introText}</p>
    </section>

    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 20px'}}>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <div style={{fontWeight:900, fontSize:16}}>BİRLİKTE BÜYÜYÜP BİRLİKTE KAZANACAĞIZ</div>
      <div style={{fontSize:13, color:'#57534e', marginTop:8, lineHeight:1.6}}>
       Biz yeni bir platformuz. Şu an için abartılı sayılar paylaşmıyoruz. Kendimize güveniyoruz, şeffaf ilerliyoruz ve her yeni ilanda sistemimiz güçleniyor.
       Amacımız {dName} ve {cName} genelinde usta ile müşteriyi doğrudan, komisyonsuz ve dürüst bir şekilde buluşturmak. Yalansız, şişirme istatistik olmadan büyüyoruz.
      </div>
      <div style={{marginTop:10, display:'flex', gap:8, flexWrap:'wrap'}}>
       <span style={{fontSize:11, padding:'6px 10px', background:'#fafaf9', border:'1px solid #e7e5e4', borderRadius:999, fontWeight:700}}>🚀 YENİYİZ</span>
       <span style={{fontSize:11, padding:'6px 10px', background:'#f0fdf4', border:'1px solid #bbf7d0', borderRadius:999, fontWeight:700}}>🤝 ŞEFFAFIZ</span>
       <span style={{fontSize:11, padding:'6px 10px', background:'#fffbeb', border:'1px solid #fde68a', borderRadius:999, fontWeight:700}}>💪 KENDİMİZE GÜVENİYORUZ</span>
      </div>
     </div>
    </section>

    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 20px'}}>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <div style={{fontWeight:900, fontSize:16, marginBottom:14}}>{dName} Ustaları - Canlı</div>
      <UstaLiveGrid citySlug={city.slug} districtSlug={district.slug} dName={dName} cName={cName} />
     </div>
    </section>

    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 20px'}}>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>NASIL ÇALIŞIR?</div>
      <div style={{display:'grid', gridTemplateColumns:'repeat(auto-fit, minmax(200px, 1fr))', gap:12}}>
       <div style={{background:'#fafaf9', borderRadius:12, padding:12}}><b>1. İşini belirt</b><div style={{fontSize:12, color:'#57534e', marginTop:4}}>{dLoc} ihtiyacını anlat.</div></div>
       <div style={{background:'#f0fdf4', border:'1px solid #bbf7d0', borderRadius:12, padding:12}}><b>2. HugAI tahmini fiyatı gör</b><div style={{fontSize:12, color:'#166534', marginTop:4}}>HugAI {dName} için tahmini piyasa fiyat aralığını gösterir.</div></div>
       <div style={{background:'#fafaf9', borderRadius:12, padding:12}}><b>3. Teklifleri karşılaştır</b><div style={{fontSize:12, color:'#57534e', marginTop:4}}>{cName} ustaları {dName} için tekliflerini iletir.</div></div>
       <div style={{background:'#fafaf9', borderRadius:12, padding:12}}><b>4. Ustanı seç</b><div style={{fontSize:12, color:'#57534e', marginTop:4}}>{dLoc} uygun usta ile iletişime geç ve süreci başlat.</div></div>
      </div>
     </div>
    </section>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 20px'}}>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>{dName} İçin Hizmetler</div>
      <div style={{display:'flex', flexWrap:'wrap', gap:8}}>
       {districtServices.map(s=>(<Link key={s.slug} href={`/${city.slug}/${s.slug}`} style={{fontSize:12, padding:'8px 12px', background:'#fafaf9', border:'1px solid #e7e5e4', borderRadius:999, textDecoration:'none', color:'#444'}}>{cName} {s.name}</Link>))}
      </div>
     </div>
    </section>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 20px'}}>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <div style={{fontWeight:900, fontSize:14, marginBottom:12}}>{cName} Diğer İlçeler - {siblingDistricts.length} ilçe tamamı</div>
      <div style={{display:'flex', flexWrap:'wrap', gap:8}}>
       {siblingDistricts.map(d=>(<Link key={d.slug} href={`/${city.slug}/${d.slug}`} style={{fontSize:12, padding:'8px 12px', background:'#fffbeb', border:'1px solid #fde68a', borderRadius:999, textDecoration:'none', color:'#92400e'}}>{d.name}</Link>))}
      </div>
     </div>
    </section>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 20px'}}><Link href={`/${city.slug}`} style={{fontSize:13, fontWeight:800, color:'#111', textDecoration:'none', background:'white', border:'1px solid #e7e5e4', padding:'10px 14px', borderRadius:12, display:'inline-block'}}>← {cName} Ustalarına Dön</Link></section>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 20px'}}>
     <div style={{background:'white', border:'1px solid #e7e5e4', borderRadius:16, padding:18}}>
      <h3 style={{marginTop:0}}>Sık Sorulan Sorular - {dName}</h3>
      {faqs.map((f,i)=>(<div key={i} style={{marginBottom:10, background:'#fafaf9', borderRadius:10, padding:12}}><div style={{fontWeight:800, fontSize:13}}>{f.q}</div><div style={{fontSize:12, color:'#444', marginTop:4}}>{f.a}</div></div>))}
     </div>
    </section>
    <section style={{maxWidth:1120, margin:'0 auto', padding:'0 20px 40px', display:'flex', gap:10, flexWrap:'wrap'}}>
     <a href="https://hemenustamgelsin.com/ilan-olustur" style={{background:'#111', color:'white', padding:'14px 20px', borderRadius:12, fontWeight:900, textDecoration:'none'}}>İLAN VER →</a>
     <a href="https://hemenustamgelsin.com/ilan-olustur" style={{background:'white', color:'#111', padding:'14px 20px', borderRadius:12, fontWeight:800, border:'1px solid #e7e5e4', textDecoration:'none'}}>TEKLİF AL</a>
    </section>
   </main>
  )
 }
 notFound()
}
