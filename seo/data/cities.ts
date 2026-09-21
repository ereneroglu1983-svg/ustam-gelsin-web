// data/cities.ts - FINAL v6 - SERT TİP + ÇİFT YÖNLÜ VALIDATION + SEO TEMİZLİĞİ

export type District = {
  name: string;
  slug: string;
};

export type City = {
  name: string;
  slug: string;
  districts: District[];
  region: string;
  plate: number;
};

const slugify = (text: string) =>
  text
   .toLowerCase()
   .replace(/ğ/g, 'g')
   .replace(/ü/g, 'u')
   .replace(/ş/g, 's')
   .replace(/ı/g, 'i')
   .replace(/ö/g, 'o')
   .replace(/ç/g, 'c')
   .replace(/[^a-z0-9]+/g, '-')
   .replace(/^-|-$/g, '');

const regionMap: Record<string, string> = {
  adana: "Akdeniz", adiyaman: "Güneydoğu Anadolu", afyonkarahisar: "Ege", agri: "Doğu Anadolu", amasya: "Karadeniz",
  ankara: "İç Anadolu", antalya: "Akdeniz", artvin: "Karadeniz", aydin: "Ege", balikesir: "Marmara",
  bilecik: "Marmara", bingol: "Doğu Anadolu", bitlis: "Doğu Anadolu", bolu: "Karadeniz", burdur: "Akdeniz",
  bursa: "Marmara", canakkale: "Marmara", cankiri: "İç Anadolu", corum: "Karadeniz", denizli: "Ege",
  diyarbakir: "Güneydoğu Anadolu", edirne: "Marmara", elazig: "Doğu Anadolu", erzincan: "Doğu Anadolu",
  erzurum: "Doğu Anadolu", eskisehir: "İç Anadolu", gaziantep: "Güneydoğu Anadolu", giresun: "Karadeniz",
  gumushane: "Karadeniz", hakkari: "Doğu Anadolu", hatay: "Akdeniz", isparta: "Akdeniz", mersin: "Akdeniz",
  istanbul: "Marmara", izmir: "Ege", kars: "Doğu Anadolu", kastamonu: "Karadeniz", kayseri: "İç Anadolu",
  kirklareli: "Marmara", kirsehir: "İç Anadolu", kocaeli: "Marmara", konya: "İç Anadolu", kutahya: "Ege",
  malatya: "Doğu Anadolu", manisa: "Ege", kahramanmaras: "Akdeniz", mardin: "Güneydoğu Anadolu", mugla: "Ege",
  mus: "Doğu Anadolu", nevsehir: "İç Anadolu", nigde: "İç Anadolu", ordu: "Karadeniz", rize: "Karadeniz",
  sakarya: "Marmara", samsun: "Karadeniz", siirt: "Güneydoğu Anadolu", sinop: "Karadeniz", sivas: "İç Anadolu",
  tekirdag: "Marmara", tokat: "Karadeniz", trabzon: "Karadeniz", tunceli: "Doğu Anadolu", sanliurfa: "Güneydoğu Anadolu",
  usak: "Ege", van: "Doğu Anadolu", yozgat: "İç Anadolu", zonguldak: "Karadeniz", aksaray: "İç Anadolu",
  bayburt: "Karadeniz", karaman: "İç Anadolu", kirikkale: "İç Anadolu", batman: "Güneydoğu Anadolu",
  sirnak: "Güneydoğu Anadolu", bartin: "Karadeniz", ardahan: "Doğu Anadolu", igdir: "Doğu Anadolu",
  yalova: "Marmara", karabuk: "Karadeniz", kilis: "Güneydoğu Anadolu", osmaniye: "Akdeniz", duzce: "Karadeniz",
};

const expectedDistrictCounts: Record<string, number> = {
  adana: 15, adiyaman: 9, afyonkarahisar: 18, agri: 8, amasya: 7, ankara: 25, antalya: 19, artvin: 9, aydin: 17,
  balikesir: 20, bilecik: 8, bingol: 8, bitlis: 7, bolu: 9, burdur: 11, bursa: 17, canakkale: 12, cankiri: 12,
  corum: 14, denizli: 19, diyarbakir: 17, edirne: 9, elazig: 11, erzincan: 9, erzurum: 20, eskisehir: 14,
  gaziantep: 9, giresun: 16, gumushane: 6, hakkari: 5, hatay: 15, isparta: 13, mersin: 13, istanbul: 39,
  izmir: 30, kars: 8, kastamonu: 20, kayseri: 16, kirklareli: 8, kirsehir: 7, kocaeli: 12, konya: 31,
  kutahya: 13, malatya: 13, manisa: 17, kahramanmaras: 11, mardin: 10, mugla: 13, mus: 6, nevsehir: 8,
  nigde: 6, ordu: 19, rize: 12, sakarya: 16, samsun: 17, siirt: 7, sinop: 9, sivas: 17, tekirdag: 11,
  tokat: 12, trabzon: 18, tunceli: 8, sanliurfa: 13, usak: 6, van: 13, yozgat: 14, zonguldak: 8,
  aksaray: 8, bayburt: 3, karaman: 6, kirikkale: 9, batman: 6, sirnak: 7, bartin: 4, ardahan: 6,
  igdir: 4, yalova: 6, karabuk: 6, kilis: 4, osmaniye: 7, duzce: 8,
};

export const cities: City[] = [
  { name: "Adana", slug: "adana", region: regionMap["adana"], plate: 1, districts: ['Aladağ','Ceyhan','Çukurova','Feke','İmamoğlu','Karaisalı','Karataş','Kozan','Pozantı','Saimbeyli','Sarıçam','Seyhan','Tufanbeyli','Yumurtalık','Yüreğir'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Adıyaman", slug: "adiyaman", region: regionMap["adiyaman"], plate: 2, districts: ['Besni','Çelikhan','Gerger','Gölbaşı','Kahta','Merkez','Samsat','Sincik','Tut'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Afyonkarahisar", slug: "afyonkarahisar", region: regionMap["afyonkarahisar"], plate: 3, districts: ['Başmakçı','Bayat','Bolvadin','Çay','Çobanlar','Dazkırı','Dinar','Emirdağ','Evciler','Hocalar','İhsaniye','İscehisar','Kızılören','Merkez','Sandıklı','Sinanpaşa','Sultandağı','Şuhut'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Ağrı", slug: "agri", region: regionMap["agri"], plate: 4, districts: ['Diyadin','Doğubayazıt','Eleşkirt','Hamur','Merkez','Patnos','Taşlıçay','Tutak'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Amasya", slug: "amasya", region: regionMap["amasya"], plate: 5, districts: ['Göynücek','Gümüşhacıköy','Hamamözü','Merkez','Merzifon','Suluova','Taşova'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Ankara", slug: "ankara", region: regionMap["ankara"], plate: 6, districts: ['Akyurt','Altındağ','Ayaş','Bala','Beypazarı','Çamlıdere','Çankaya','Çubuk','Elmadağ','Etimesgut','Evren','Gölbaşı','Güdül','Haymana','Kahramankazan','Kalecik','Keçiören','Kızılcahamam','Mamak','Nallıhan','Polatlı','Pursaklar','Sincan','Şereflikoçhisar','Yenimahalle'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Antalya", slug: "antalya", region: regionMap["antalya"], plate: 7, districts: ['Akseki','Aksu','Alanya','Demre','Döşemealtı','Elmalı','Finike','Gazipaşa','Gündoğmuş','İbradı','Kaş','Kemer','Kepez','Konyaaltı','Korkuteli','Kumluca','Manavgat','Muratpaşa','Serik'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Artvin", slug: "artvin", region: regionMap["artvin"], plate: 8, districts: ['Ardanuç','Arhavi','Borçka','Hopa','Kemalpaşa','Merkez','Murgul','Şavşat','Yusufeli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Aydın", slug: "aydin", region: regionMap["aydin"], plate: 9, districts: ['Bozdoğan','Buharkent','Çine','Didim','Efeler','Germencik','İncirliova','Karacasu','Karpuzlu','Koçarlı','Köşk','Kuşadası','Kuyucak','Nazilli','Söke','Sultanhisar','Yenipazar'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Balıkesir", slug: "balikesir", region: regionMap["balikesir"], plate: 10, districts: ['Altıeylül','Ayvalık','Balya','Bandırma','Bigadiç','Burhaniye','Dursunbey','Edremit','Erdek','Gömeç','Gönen','Havran','İvrindi','Karesi','Kepsut','Manyas','Marmara','Savaştepe','Sındırgı','Susurluk'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bilecik", slug: "bilecik", region: regionMap["bilecik"], plate: 11, districts: ['Bozüyük','Gölpazarı','İnhisar','Merkez','Osmaneli','Pazaryeri','Söğüt','Yenipazar'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bingöl", slug: "bingol", region: regionMap["bingol"], plate: 12, districts: ['Adaklı','Genç','Karlıova','Kiğı','Merkez','Solhan','Yayladere','Yedisu'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bitlis", slug: "bitlis", region: regionMap["bitlis"], plate: 13, districts: ['Adilcevaz','Ahlat','Güroymak','Hizan','Merkez','Mutki','Tatvan'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bolu", slug: "bolu", region: regionMap["bolu"], plate: 14, districts: ['Dörtdivan','Gerede','Göynük','Kıbrıscık','Mengen','Merkez','Mudurnu','Seben','Yeniçağa'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Burdur", slug: "burdur", region: regionMap["burdur"], plate: 15, districts: ['Ağlasun','Altınyayla','Bucak','Çavdır','Çeltikçi','Gölhisar','Karamanlı','Kemer','Merkez','Tefenni','Yeşilova'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bursa", slug: "bursa", region: regionMap["bursa"], plate: 16, districts: ['Büyükorhan','Gemlik','Gürsu','Harmancık','İnegöl','İznik','Karacabey','Keles','Kestel','Mudanya','Mustafakemalpaşa','Nilüfer','Orhaneli','Osmangazi','Yenişehir','Yıldırım','Orhangazi'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Çanakkale", slug: "canakkale", region: regionMap["canakkale"], plate: 17, districts: ['Ayvacık','Bayramiç','Biga','Bozcaada','Çan','Eceabat','Ezine','Gelibolu','Gökçeada','Lapseki','Merkez','Yenice'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Çankırı", slug: "cankiri", region: regionMap["cankiri"], plate: 18, districts: ['Atkaracalar','Bayramören','Çerkeş','Eldivan','Ilgaz','Kızılırmak','Korgun','Kurşunlu','Merkez','Orta','Şabanözü','Yapraklı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Çorum", slug: "corum", region: regionMap["corum"], plate: 19, districts: ['Alaca','Bayat','Boğazkale','Dodurga','İskilip','Kargı','Laçin','Mecitözü','Merkez','Oğuzlar','Ortaköy','Osmancık','Sungurlu','Uğurludağ'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Denizli", slug: "denizli", region: regionMap["denizli"], plate: 20, districts: ['Acıpayam','Babadağ','Baklan','Bekilli','Beyağaç','Bozkurt','Buldan','Çal','Çameli','Çardak','Çivril','Güney','Honaz','Kale','Merkezefendi','Pamukkale','Sarayköy','Serinhisar','Tavas'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Diyarbakır", slug: "diyarbakir", region: regionMap["diyarbakir"], plate: 21, districts: ['Bağlar','Bismil','Çermik','Çınar','Çüngüş','Dicle','Eğil','Ergani','Hani','Hazro','Kayapınar','Kocaköy','Kulp','Lice','Silvan','Sur','Yenişehir'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Edirne", slug: "edirne", region: regionMap["edirne"], plate: 22, districts: ['Enez','Havsa','İpsala','Keşan','Lalapaşa','Meriç','Merkez','Süloğlu','Uzunköprü'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Elazığ", slug: "elazig", region: regionMap["elazig"], plate: 23, districts: ['Ağın','Alacakaya','Arıcak','Baskil','Karakoçan','Keban','Kovancılar','Maden','Merkez','Palu','Sivrice'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Erzincan", slug: "erzincan", region: regionMap["erzincan"], plate: 24, districts: ['Çayırlı','İliç','Kemah','Kemaliye','Merkez','Otlukbeli','Refahiye','Tercan','Üzümlü'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Erzurum", slug: "erzurum", region: regionMap["erzurum"], plate: 25, districts: ['Aşkale','Aziziye','Çat','Hınıs','Horasan','İspir','Karaçoban','Karayazı','Köprüköy','Narman','Oltu','Olur','Palandöken','Pasinler','Pazaryolu','Şenkaya','Tekman','Tortum','Uzundere','Yakutiye'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Eskişehir", slug: "eskisehir", region: regionMap["eskisehir"], plate: 26, districts: ['Alpu','Beylikova','Çifteler','Günyüzü','Han','İnönü','Mahmudiye','Mihalgazi','Mihalıççık','Odunpazarı','Sarıcakaya','Seyitgazi','Sivrihisar','Tepebaşı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Gaziantep", slug: "gaziantep", region: regionMap["gaziantep"], plate: 27, districts: ['Araban','İslahiye','Karkamış','Nizip','Nurdağı','Oğuzeli','Şahinbey','Şehitkamil','Yavuzeli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Giresun", slug: "giresun", region: regionMap["giresun"], plate: 28, districts: ['Alucra','Bulancak','Çamoluk','Çanakçı','Dereli','Doğankent','Espiye','Eynesil','Görele','Güce','Keşap','Merkez','Piraziz','Şebinkarahisar','Tirebolu','Yağlıdere'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Gümüşhane", slug: "gumushane", region: regionMap["gumushane"], plate: 29, districts: ['Kelkit','Köse','Kürtün','Merkez','Şiran','Torul'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Hakkari", slug: "hakkari", region: regionMap["hakkari"], plate: 30, districts: ['Çukurca','Derecik','Merkez','Şemdinli','Yüksekova'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Hatay", slug: "hatay", region: regionMap["hatay"], plate: 31, districts: ['Altınözü','Antakya','Arsuz','Belen','Defne','Dörtyol','Erzin','Hassa','İskenderun','Kırıkhan','Kumlu','Payas','Reyhanlı','Samandağ','Yayladağı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Isparta", slug: "isparta", region: regionMap["isparta"], plate: 32, districts: ['Aksu','Atabey','Eğirdir','Gelendost','Gönen','Keçiborlu','Merkez','Senirkent','Sütçüler','Şarkikaraağaç','Uluborlu','Yalvaç','Yenişarbademli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Mersin", slug: "mersin", region: regionMap["mersin"], plate: 33, districts: ['Akdeniz','Anamur','Aydıncık','Bozyazı','Çamlıyayla','Erdemli','Gülnar','Mezitli','Mut','Silifke','Tarsus','Toroslar','Yenişehir'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "İstanbul", slug: "istanbul", region: regionMap["istanbul"], plate: 34, districts: ['Adalar','Arnavutköy','Ataşehir','Avcılar','Bağcılar','Bahçelievler','Bakırköy','Başakşehir','Bayrampaşa','Beşiktaş','Beykoz','Beylikdüzü','Beyoğlu','Büyükçekmece','Çatalca','Çekmeköy','Esenler','Esenyurt','Eyüpsultan','Fatih','Gaziosmanpaşa','Güngören','Kadıköy','Kağıthane','Kartal','Küçükçekmece','Maltepe','Pendik','Sancaktepe','Sarıyer','Silivri','Sultanbeyli','Sultangazi','Şile','Şişli','Tuzla','Ümraniye','Üsküdar','Zeytinburnu'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "İzmir", slug: "izmir", region: regionMap["izmir"], plate: 35, districts: ['Aliağa','Balçova','Bayındır','Bayraklı','Bergama','Beydağ','Bornova','Buca','Çeşme','Çiğli','Dikili','Foça','Gaziemir','Güzelbahçe','Karabağlar','Karaburun','Karşıyaka','Kemalpaşa','Kınık','Kiraz','Konak','Menderes','Menemen','Narlıdere','Ödemiş','Seferihisar','Selçuk','Tire','Torbalı','Urla'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kars", slug: "kars", region: regionMap["kars"], plate: 36, districts: ['Akyaka','Arpaçay','Digor','Kağızman','Merkez','Sarıkamış','Selim','Susuz'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kastamonu", slug: "kastamonu", region: regionMap["kastamonu"], plate: 37, districts: ['Abana','Ağlı','Araç','Azdavay','Bozkurt','Cide','Çatalzeytin','Daday','Devrekani','Doğanyurt','Hanönü','İhsangazi','İnebolu','Küre','Merkez','Pınarbaşı','Seydiler','Şenpazar','Taşköprü','Tosya'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kayseri", slug: "kayseri", region: regionMap["kayseri"], plate: 38, districts: ['Akkışla','Bünyan','Develi','Felahiye','Hacılar','İncesu','Kocasinan','Melikgazi','Özvatan','Pınarbaşı','Sarıoğlan','Sarız','Talas','Tomarza','Yahyalı','Yeşilhisar'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kırklareli", slug: "kirklareli", region: regionMap["kirklareli"], plate: 39, districts: ['Babaeski','Demirköy','Kofçaz','Lüleburgaz','Merkez','Pehlivanköy','Pınarhisar','Vize'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kırşehir", slug: "kirsehir", region: regionMap["kirsehir"], plate: 40, districts: ['Akçakent','Akpınar','Boztepe','Çiçekdağı','Kaman','Merkez','Mucur'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kocaeli", slug: "kocaeli", region: regionMap["kocaeli"], plate: 41, districts: ['Başiskele','Çayırova','Darıca','Derince','Dilovası','Gebze','Gölcük','İzmit','Kandıra','Karamürsel','Kartepe','Körfez'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Konya", slug: "konya", region: regionMap["konya"], plate: 42, districts: ['Ahırlı','Akören','Akşehir','Altınekin','Beyşehir','Bozkır','Cihanbeyli','Çeltik','Çumra','Derbent','Derebucak','Doğanhisar','Emirgazi','Ereğli','Güneysınır','Hadim','Halkapınar','Hüyük','Ilgın','Kadınhanı','Karapınar','Karatay','Kulu','Meram','Sarayönü','Selçuklu','Seydişehir','Taşkent','Tuzlukçu','Yalıhüyük','Yunak'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kütahya", slug: "kutahya", region: regionMap["kutahya"], plate: 43, districts: ['Altıntaş','Aslanapa','Çavdarhisar','Domaniç','Dumlupınar','Emet','Gediz','Hisarcık','Merkez','Pazarlar','Simav','Şaphane','Tavşanlı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Malatya", slug: "malatya", region: regionMap["malatya"], plate: 44, districts: ['Akçadağ','Arapgir','Arguvan','Battalgazi','Darende','Doğanşehir','Doğanyol','Hekimhan','Kale','Kuluncak','Pütürge','Yazıhan','Yeşilyurt'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Manisa", slug: "manisa", region: regionMap["manisa"], plate: 45, districts: ['Ahmetli','Akhisar','Alaşehir','Demirci','Gölmarmara','Gördes','Kırkağaç','Köprübaşı','Kula','Salihli','Sarıgöl','Saruhanlı','Selendi','Soma','Şehzadeler','Turgutlu','Yunusemre'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kahramanmaraş", slug: "kahramanmaras", region: regionMap["kahramanmaras"], plate: 46, districts: ['Afşin','Andırın','Çağlayancerit','Dulkadiroğlu','Ekinözü','Elbistan','Göksun','Nurhak','Onikişubat','Pazarcık','Türkoğlu'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Mardin", slug: "mardin", region: regionMap["mardin"], plate: 47, districts: ['Artuklu','Dargeçit','Derik','Kızıltepe','Mazıdağı','Midyat','Nusaybin','Ömerli','Savur','Yeşilli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Muğla", slug: "mugla", region: regionMap["mugla"], plate: 48, districts: ['Bodrum','Dalaman','Datça','Fethiye','Kavaklıdere','Köyceğiz','Marmaris','Menteşe','Milas','Ortaca','Seydikemer','Ula','Yatağan'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Muş", slug: "mus", region: regionMap["mus"], plate: 49, districts: ['Bulanık','Hasköy','Korkut','Malazgirt','Merkez','Varto'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Nevşehir", slug: "nevsehir", region: regionMap["nevsehir"], plate: 50, districts: ['Acıgöl','Avanos','Derinkuyu','Gülşehir','Hacıbektaş','Kozaklı','Merkez','Ürgüp'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Niğde", slug: "nigde", region: regionMap["nigde"], plate: 51, districts: ['Altunhisar','Bor','Çamardı','Çiftlik','Merkez','Ulukışla'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Ordu", slug: "ordu", region: regionMap["ordu"], plate: 52, districts: ['Akkuş','Altınordu','Aybastı','Çamaş','Çatalpınar','Çaybaşı','Fatsa','Gölköy','Gülyalı','Gürgentepe','İkizce','Kabadüz','Kabataş','Korgan','Kumru','Mesudiye','Perşembe','Ulubey','Ünye'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Rize", slug: "rize", region: regionMap["rize"], plate: 53, districts: ['Ardeşen','Çamlıhemşin','Çayeli','Derepazarı','Fındıklı','Güneysu','Hemşin','İkizdere','İyidere','Kalkandere','Merkez','Pazar'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Sakarya", slug: "sakarya", region: regionMap["sakarya"], plate: 54, districts: ['Adapazarı','Akyazı','Arifiye','Erenler','Ferizli','Geyve','Hendek','Karapürçek','Karasu','Kaynarca','Kocaali','Pamukova','Sapanca','Serdivan','Söğütlü','Taraklı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Samsun", slug: "samsun", region: regionMap["samsun"], plate: 55, districts: ['19 Mayıs','Alaçam','Asarcık','Atakum','Ayvacık','Bafra','Canik','Çarşamba','Havza','İlkadım','Kavak','Ladik','Salıpazarı','Tekkeköy','Terme','Vezirköprü','Yakakent'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Siirt", slug: "siirt", region: regionMap["siirt"], plate: 56, districts: ['Baykan','Eruh','Kurtalan','Merkez','Pervari','Şirvan','Tillo'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Sinop", slug: "sinop", region: regionMap["sinop"], plate: 57, districts: ['Ayancık','Boyabat','Dikmen','Durağan','Erfelek','Gerze','Merkez','Saraydüzü','Türkeli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Sivas", slug: "sivas", region: regionMap["sivas"], plate: 58, districts: ['Akıncılar','Altınyayla','Divriği','Doğanşar','Gemerek','Gölova','Gürün','Hafik','İmranlı','Kangal','Koyulhisar','Merkez','Şarkışla','Suşehri','Ulaş','Yıldızeli','Zara'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Tekirdağ", slug: "tekirdag", region: regionMap["tekirdag"], plate: 59, districts: ['Çerkezköy','Çorlu','Ergene','Hayrabolu','Kapaklı','Malkara','Marmaraereğlisi','Muratlı','Saray','Süleymanpaşa','Şarköy'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Tokat", slug: "tokat", region: regionMap["tokat"], plate: 60, districts: ['Almus','Artova','Başçiftlik','Erbaa','Merkez','Niksar','Pazar','Reşadiye','Sulusaray','Turhal','Yeşilyurt','Zile'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Trabzon", slug: "trabzon", region: regionMap["trabzon"], plate: 61, districts: ['Akçaabat','Araklı','Arsin','Beşikdüzü','Çarşıbaşı','Çaykara','Dernekpazarı','Düzköy','Hayrat','Köprübaşı','Maçka','Of','Ortahisar','Sürmene','Şalpazarı','Tonya','Vakfıkebir','Yomra'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Tunceli", slug: "tunceli", region: regionMap["tunceli"], plate: 62, districts: ['Çemişgezek','Hozat','Mazgirt','Merkez','Nazımiye','Ovacık','Pertek','Pülümür'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Şanlıurfa", slug: "sanliurfa", region: regionMap["sanliurfa"], plate: 63, districts: ['Akçakale','Birecik','Bozova','Ceylanpınar','Eyyübiye','Halfeti','Haliliye','Harran','Hilvan','Karaköprü','Siverek','Suruç','Viranşehir'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Uşak", slug: "usak", region: regionMap["usak"], plate: 64, districts: ['Banaz','Eşme','Karahallı','Merkez','Sivaslı','Ulubey'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Van", slug: "van", region: regionMap["van"], plate: 65, districts: ['Bahçesaray','Başkale','Çaldıran','Çatak','Edremit','Erciş','Gevaş','Gürpınar','İpekyolu','Muradiye','Özalp','Saray','Tuşba'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Yozgat", slug: "yozgat", region: regionMap["yozgat"], plate: 66, districts: ['Akdağmadeni','Aydıncık','Boğazlıyan','Çandır','Çayıralan','Çekerek','Kadışehri','Merkez','Saraykent','Sarıkaya','Şefaatli','Sorgun','Yenifakılı','Yerköy'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Zonguldak", slug: "zonguldak", region: regionMap["zonguldak"], plate: 67, districts: ['Alaplı','Çaycuma','Devrek','Ereğli','Gökçebey','Kilimli','Kozlu','Merkez'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Aksaray", slug: "aksaray", region: regionMap["aksaray"], plate: 68, districts: ['Ağaçören','Eskil','Gülağaç','Güzelyurt','Merkez','Ortaköy','Sarıyahşi','Sultanhanı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bayburt", slug: "bayburt", region: regionMap["bayburt"], plate: 69, districts: ['Aydıntepe','Demirözü','Merkez'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Karaman", slug: "karaman", region: regionMap["karaman"], plate: 70, districts: ['Ayrancı','Başyayla','Ermenek','Kazımkarabekir','Merkez','Sarıveliler'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kırıkkale", slug: "kirikkale", region: regionMap["kirikkale"], plate: 71, districts: ['Bahşili','Balışeyh','Çelebi','Delice','Karakeçili','Keskin','Merkez','Sulakyurt','Yahşihan'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Batman", slug: "batman", region: regionMap["batman"], plate: 72, districts: ['Beşiri','Gercüş','Hasankeyf','Kozluk','Merkez','Sason'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Şırnak", slug: "sirnak", region: regionMap["sirnak"], plate: 73, districts: ['Beytüşşebap','Cizre','Güçlükonak','İdil','Merkez','Silopi','Uludere'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bartın", slug: "bartin", region: regionMap["bartin"], plate: 74, districts: ['Amasra','Merkez','Kurucaşile','Ulus'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Ardahan", slug: "ardahan", region: regionMap["ardahan"], plate: 75, districts: ['Çıldır','Damal','Göle','Hanak','Merkez','Posof'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Iğdır", slug: "igdir", region: regionMap["igdir"], plate: 76, districts: ['Aralık','Karakoyunlu','Merkez','Tuzluca'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Yalova", slug: "yalova", region: regionMap["yalova"], plate: 77, districts: ['Altınova','Armutlu','Çiftlikköy','Çınarcık','Merkez','Termal'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Karabük", slug: "karabuk", region: regionMap["karabuk"], plate: 78, districts: ['Eflani','Eskipazar','Merkez','Ovacık','Safranbolu','Yenice'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kilis", slug: "kilis", region: regionMap["kilis"], plate: 79, districts: ['Elbeyli','Merkez','Musabeyli','Polateli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Osmaniye", slug: "osmaniye", region: regionMap["osmaniye"], plate: 80, districts: ['Bahçe','Düziçi','Hasanbeyli','Kadirli','Merkez','Sumbas','Toprakkale'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Düzce", slug: "duzce", region: regionMap["duzce"], plate: 81, districts: ['Akçakoca','Cumayeri','Çilimli','Gölyaka','Gümüşova','Kaynaşlı','Merkez','Yığılca'].map(n => ({ name: n, slug: slugify(n) })) },
];

// --- VALIDATION - v6 FINAL ---
(() => {
  const slugs = cities.map(c => c.slug);
  const names = cities.map(c => c.name);

  if (cities.length!== 81) throw new Error(`[cities.ts] cities.length=${cities.length}, 81 olmalı`);

  // Plate sert kontrol - nullable bitti, tip artık zorunlu
  const plates = cities.map(c => c.plate);
  if (plates.some(p => typeof p!== 'number')) {
    throw new Error(`[cities.ts] tüm şehirlerin plaka numarası olmalı`);
  }
  const sortedPlates = [...plates].sort((a, b) => a - b);
  for (let i = 1; i <= 81; i++) {
    if (sortedPlates[i - 1]!== i) {
      throw new Error(`[cities.ts] plaka ${i} eksik/hatalı, bulunan: ${sortedPlates.join(',')}`);
    }
  }

  if (new Set(slugs).size!== slugs.length) throw new Error(`[cities.ts] duplicate city slug var`);
  if (new Set(names).size!== names.length) throw new Error(`[cities.ts] duplicate city name var`);

  // regionMap <-> cities çift yönlü
  const regionKeys = Object.keys(regionMap);
  if (regionKeys.length!== 81) throw new Error(`[cities.ts] regionMap ${regionKeys.length} anahtar, 81 olmalı`);

  // expectedDistrictCounts <-> cities çift yönlü
  const expectedDistrictKeys = Object.keys(expectedDistrictCounts);
  if (expectedDistrictKeys.length!== 81) {
    throw new Error(`[cities.ts] expectedDistrictCounts ${expectedDistrictKeys.length} anahtar, 81 olmalı`);
  }
  for (const key of expectedDistrictKeys) {
    if (!slugs.includes(key)) {
      throw new Error(`[cities.ts] expectedDistrictCounts içinde fazla/olmayan şehir: ${key}`);
    }
  }

  for (const c of cities) {
    if (!regionMap[c.slug]) throw new Error(`[cities.ts] regionMap içinde ${c.slug} eksik`);
    if (c.region!== regionMap[c.slug]) throw new Error(`[cities.ts] ${c.slug} region uyuşmazlığı`);
    if (!/^[a-z0-9-]+$/.test(c.slug)) throw new Error(`[cities.ts] ${c.slug} slug format hatalı`);
    if (c.districts.length < 2) {
      throw new Error(`[cities.ts] ${c.slug} için en az 2 ilçe olmalı`);
    }

    const expected = expectedDistrictCounts[c.slug];
    if (typeof expected!== 'number') {
      throw new Error(`[cities.ts] ${c.slug} için expectedDistrictCounts tanımı eksik`);
    }
    if (c.districts.length!== expected) {
      throw new Error(`[cities.ts] ${c.name}: ${c.districts.length} ilçe var, ${expected} olmalı`);
    }

    const dNames = c.districts.map(d => d.name);
    const dSlugs = c.districts.map(d => d.slug);
    if (new Set(dNames).size!== dNames.length) throw new Error(`[cities.ts] ${c.slug} içinde duplicate district name`);
    if (new Set(dSlugs).size!== dSlugs.length) throw new Error(`[cities.ts] ${c.slug} içinde duplicate district slug`);
    for (const ds of dSlugs) {
      if (!/^[a-z0-9-]+$/.test(ds)) throw new Error(`[cities.ts] ${c.slug} district slug ${ds} format hatalı`);
    }
  }
  for (const rk of regionKeys) {
    if (!slugs.includes(rk)) throw new Error(`[cities.ts] regionMap içinde fazla anahtar: ${rk}`);
  }
})();

export const citySlugs = cities.map(c => c.slug);
export const getCityBySlug = (slug: string) => cities.find(c => c.slug === slug);
export const getDistrictBySlug = (citySlug: string, districtSlug: string) => {
  const city = getCityBySlug(citySlug);
  return city?.districts.find(d => d.slug === districtSlug);
};

// --- SEO HELPERLAR ---
export const getCityRegion = (slug: string) => {
  const region = regionMap[slug];
  if (!region) throw new Error(`[cities.ts] getCityRegion: ${slug} için region bulunamadı`);
  return region;
};

export const getCitySeoIntro = (citySlug: string, jobLabel: string) => {
  const city = getCityBySlug(citySlug);
  if (!city) return "";
  const top3 = city.districts.slice(0, 3).map(d => d.name).join(", ");
  return `${city.name} ${getCityRegion(citySlug)} bölgesinde yer alır. ${top3} başta olmak üzere ${city.districts.length} ilçede ${jobLabel} talepleri için usta eşleştirme ve teklif alma imkanı sunar.`;
};

export const getCitySeoTitle = (citySlug: string, jobLabel: string) => {
  const city = getCityBySlug(citySlug);
  if (!city) return `${jobLabel} - Hemen Ustam Gelsin`;
  return `${city.name} ${jobLabel} - ${city.districts[0].name}, ${city.districts[1].name} ve Tüm İlçeler | Ustanın Hakedişinden %0 Komisyon`;
};

export const getCitySeoDescription = (citySlug: string, jobLabel: string) => {
  const city = getCityBySlug(citySlug);
  if (!city) return `${jobLabel} için usta bul`;
  const districts = city.districts.slice(0, 4).map(d => d.name).join(", ");
  return `${city.name} ${jobLabel} işleri için ${districts} başta olmak üzere ${city.districts.length} ilçede usta eşleştirme ve teklif alma. Ustanın hakedişinden başarı komisyonu alınmaz. HugAI destekli keşif ve fiyat tahmini ile şeffaf teklif al.`;
};