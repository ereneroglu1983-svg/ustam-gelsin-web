// seo/data/seo-enrichment/index.ts - ORKESTRA ŞEFİ v4.1 - 81 İL TAM EKSİKSİZ - BUILD FIXLI
import * as adana from "./cities/01-adana";
import * as adiyaman from "./cities/02-adiyaman";
import * as afyonkarahisar from "./cities/03-afyonkarahisar";
import * as agri from "./cities/04-agri";
import * as amasya from "./cities/05-amasya";
import * as ankara from "./cities/06-ankara";
import * as antalya from "./cities/07-antalya";
import * as artvin from "./cities/08-artvin";
import * as aydin from "./cities/09-aydin";
import * as balikesir from "./cities/10-balikesir";
import * as bilecik from "./cities/11-bilecik";
import * as bingol from "./cities/12-bingol";
import * as bitlis from "./cities/13-bitlis";
import * as bolu from "./cities/14-bolu";
import * as burdur from "./cities/15-burdur";
import * as bursa from "./cities/16-bursa";
import * as canakkale from "./cities/17-canakkale";
import * as cankiri from "./cities/18-cankiri";
import * as corum from "./cities/19-corum";
import * as denizli from "./cities/20-denizli";
import * as diyarbakir from "./cities/21-diyarbakir";
import * as edirne from "./cities/22-edirne";
import * as elazig from "./cities/23-elazig";
import * as erzincan from "./cities/24-erzincan";
import * as erzurum from "./cities/25-erzurum";
import * as eskisehir from "./cities/26-eskisehir";
import * as gaziantep from "./cities/27-gaziantep";
import * as giresun from "./cities/28-giresun";
import * as gumushane from "./cities/29-gumushane";
import * as hakkari from "./cities/30-hakkari";
import * as hatay from "./cities/31-hatay";
import * as isparta from "./cities/32-isparta";
import * as mersin from "./cities/33-mersin";
import * as istanbul from "./cities/34-istanbul";
import * as izmir from "./cities/35-izmir";
import * as kars from "./cities/36-kars";
import * as kastamonu from "./cities/37-kastamonu";
import * as kayseri from "./cities/38-kayseri";
import * as kirklareli from "./cities/39-kirklareli";
import * as kirsehir from "./cities/40-kirsehir";
import * as kocaeli from "./cities/41-kocaeli";
import * as konya from "./cities/42-konya";
import * as kutahya from "./cities/43-kutahya";
import * as malatya from "./cities/44-malatya";
import * as manisa from "./cities/45-manisa";
import * as kahramanmaras from "./cities/46-kahramanmaras";
import * as mardin from "./cities/47-mardin";
import * as mugla from "./cities/48-mugla";
import * as mus from "./cities/49-mus";
import * as nevsehir from "./cities/50-nevsehir";
import * as nigde from "./cities/51-nigde";
import * as ordu from "./cities/52-ordu";
import * as rize from "./cities/53-rize";
import * as sakarya from "./cities/54-sakarya";
import * as samsun from "./cities/55-samsun";
import * as siirt from "./cities/56-siirt";
import * as sinop from "./cities/57-sinop";
import * as sivas from "./cities/58-sivas";
import * as tekirdag from "./cities/59-tekirdag";
import * as tokat from "./cities/60-tokat";
import * as trabzon from "./cities/61-trabzon";
import * as tunceli from "./cities/62-tunceli";
import * as sanliurfa from "./cities/63-sanliurfa";
import * as usak from "./cities/64-usak";
import * as van from "./cities/65-van";
import * as yozgat from "./cities/66-yozgat";
import * as zonguldak from "./cities/67-zonguldak";
import * as aksaray from "./cities/68-aksaray";
import * as bayburt from "./cities/69-bayburt";
import * as karaman from "./cities/70-karaman";
import * as kirikkale from "./cities/71-kirikkale";
import * as batman from "./cities/72-batman";
import * as sirnak from "./cities/73-sirnak";
import * as bartin from "./cities/74-bartin";
import * as ardahan from "./cities/75-ardahan";
import * as igdir from "./cities/76-igdir";
import * as yalova from "./cities/77-yalova";
import * as karabuk from "./cities/78-karabuk";
import * as kilis from "./cities/79-kilis";
import * as osmaniye from "./cities/80-osmaniye";
import * as duzce from "./cities/81-duzce";

import { allDistricts, getAllDistricts, getPriorityDistricts } from "./_registry";

const cityModules: Record<string, { getEnrichment: (districtSlug?: string) => any }> = {
  "adana": adana,
  "adiyaman": adiyaman,
  "afyonkarahisar": afyonkarahisar,
  "agri": agri,
  "amasya": amasya,
  "ankara": ankara,
  "antalya": antalya,
  "artvin": artvin,
  "aydin": aydin,
  "balikesir": balikesir,
  "bilecik": bilecik,
  "bingol": bingol,
  "bitlis": bitlis,
  "bolu": bolu,
  "burdur": burdur,
  "bursa": bursa,
  "canakkale": canakkale,
  "cankiri": cankiri,
  "corum": corum,
  "denizli": denizli,
  "diyarbakir": diyarbakir,
  "edirne": edirne,
  "elazig": elazig,
  "erzincan": erzincan,
  "erzurum": erzurum,
  "eskisehir": eskisehir,
  "gaziantep": gaziantep,
  "giresun": giresun,
  "gumushane": gumushane,
  "hakkari": hakkari,
  "hatay": hatay,
  "isparta": isparta,
  "mersin": mersin,
  "istanbul": istanbul,
  "izmir": izmir,
  "kars": kars,
  "kastamonu": kastamonu,
  "kayseri": kayseri,
  "kirklareli": kirklareli,
  "kirsehir": kirsehir,
  "kocaeli": kocaeli,
  "konya": konya,
  "kutahya": kutahya,
  "malatya": malatya,
  "manisa": manisa as any,
  "kahramanmaras": kahramanmaras,
  "mardin": mardin,
  "mugla": mugla,
  "mus": mus,
  "nevsehir": nevsehir,
  "nigde": nigde,
  "ordu": ordu,
  "rize": rize,
  "sakarya": sakarya,
  "samsun": samsun,
  "siirt": siirt,
  "sinop": sinop,
  "sivas": sivas,
  "tekirdag": tekirdag,
  "tokat": tokat,
  "trabzon": trabzon,
  "tunceli": tunceli,
  "sanliurfa": sanliurfa,
  "usak": usak,
  "van": van,
  "yozgat": yozgat,
  "zonguldak": zonguldak,
  "aksaray": aksaray,
  "bayburt": bayburt,
  "karaman": karaman,
  "kirikkale": kirikkale,
  "batman": batman,
  "sirnak": sirnak,
  "bartin": bartin,
  "ardahan": ardahan,
  "igdir": igdir,
  "yalova": yalova,
  "karabuk": karabuk,
  "kilis": kilis,
  "osmaniye": osmaniye,
  "duzce": duzce,
};

export type EnrichmentResult = ReturnType<typeof manisa.getEnrichment> | null;

export function getEnrichment(citySlug: string, districtSlug?: string): EnrichmentResult {
  const mod = (cityModules as any)[citySlug];
  if (mod && mod.getEnrichment) {
    const result = mod.getEnrichment(districtSlug);
    if (result?.city?.note?.includes("henüz")) {
      return null;
    }
    return result;
  }
  return null;
}

export function isCityActive(citySlug: string): boolean {
  const mod = (cityModules as any)[citySlug];
  if (!mod) return false;
  if (citySlug === "manisa") return true;
  const test = mod.getEnrichment();
  return !(test?.city?.note?.includes("henüz"));
}

export { allDistricts, getAllDistricts, getPriorityDistricts };
export const activeCities = ["manisa"] as const;
export const allCities = Object.keys(cityModules);
