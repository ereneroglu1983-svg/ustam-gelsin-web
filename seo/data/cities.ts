// data/cities.ts

export type District = {
  name: string;
  slug: string;
};

export type City = {
  name: string;
  slug: string;
  districts: District[];
  region?: string;
  plate?: number;
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
  bilecik: "Marmara", bingol: "Doğu Anadolu", bitlis: "Doğu Anadolu", bolu: "Karadeniz", bursa: "Marmara",
  canakkale: "Marmara", cankiri: "İç Anadolu", corum: "Karadeniz", denizli: "Ege", diyarbakir: "Güneydoğu Anadolu",
  edirne: "Marmara", elazig: "Doğu Anadolu", erzincan: "Doğu Anadolu", erzurum: "Doğu Anadolu", eskisehir: "İç Anadolu",
  gaziantep: "Güneydoğu Anadolu", giresun: "Karadeniz", gumushane: "Karadeniz", hakkari: "Doğu Anadolu", hatay: "Akdeniz",
  isparta: "Akdeniz", mersin: "Akdeniz", istanbul: "Marmara", izmir: "Ege", kars: "Doğu Anadolu",
  kastamonu: "Karadeniz", kayseri: "İç Anadolu", kirklareli: "Marmara", kirsehir: "İç Anadolu", kocaeli: "Marmara",
  konya: "İç Anadolu", kutahya: "Ege", malatya: "Doğu Anadolu", manisa: "Ege", kahramanmaras: "Akdeniz",
  mardin: "Güneydoğu Anadolu", mugla: "Ege", mus: "Doğu Anadolu", nevsehir: "İç Anadolu", nigde: "İç Anadolu",
  ordu: "Karadeniz", rize: "Karadeniz", sakarya: "Marmara", samsun: "Karadeniz", siirt: "Güneydoğu Anadolu",
  sinop: "Karadeniz", sivas: "İç Anadolu", tekirdag: "Marmara", tokat: "Karadeniz", trabzon: "Karadeniz",
  tunceli: "Doğu Anadolu", sanliurfa: "Güneydoğu Anadolu", usak: "Ege", van: "Doğu Anadolu", yozgat: "İç Anadolu",
  zonguldak: "Karadeniz", aksaray: "İç Anadolu", bayburt: "Karadeniz", karaman: "İç Anadolu", kirikkale: "İç Anadolu",
  batman: "Güneydoğu Anadolu", sirnak: "Güneydoğu Anadolu", bartin: "Karadeniz", ardahan: "Doğu Anadolu", igdir: "Doğu Anadolu",
  yalova: "Marmara", karabuk: "Karadeniz", kilis: "Güneydoğu Anadolu", osmaniye: "Akdeniz", duzce: "Karadeniz",
};

export const cities: City[] = [
  { name: "Adana", slug: "adana", region: regionMap["adana"], plate: 1, districts: ['Seyhan', 'Yüreğir', 'Çukurova', 'Sarıçam', 'Ceyhan', 'Kozan', 'İmamoğlu', 'Karaisalı', 'Karataş', 'Yumurtalık', 'Pozantı', 'Aladağ', 'Feke', 'Saimbeyli', 'Tufanbeyli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Adıyaman", slug: "adiyaman", region: regionMap["adiyaman"], plate: 2, districts: ['Merkez', 'Kahta', 'Besni', 'Gölbaşı', 'Gerger', 'Çelikhan', 'Samsat', 'Sincik', 'Tut'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Afyonkarahisar", slug: "afyonkarahisar", region: regionMap["afyonkarahisar"], plate: 3, districts: ['Merkez', 'Sandıklı', 'Dinar', 'Bolvadin', 'Emirdağ', 'İhsaniye', 'Sinanpaşa', 'Şuhut', 'Çobanlar', 'İscehisar', 'Çay'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Ağrı", slug: "agri", region: regionMap["agri"], plate: 4, districts: ['Merkez', 'Patnos', 'Doğubayazıt', 'Diyadin', 'Eleşkirt', 'Tutak', 'Hamur', 'Taşlıçay'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Amasya", slug: "amasya", region: regionMap["amasya"], plate: 5, districts: ['Merkez', 'Merzifon', 'Suluova', 'Taşova', 'Göynücek', 'Hamamözü', 'Gümüşhacıköy'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Ankara", slug: "ankara", region: regionMap["ankara"], plate: 6, districts: ['Çankaya', 'Keçiören', 'Yenimahalle', 'Mamak', 'Etimesgut', 'Sincan', 'Altındağ', 'Gölbaşı', 'Pursaklar', 'Çubuk', 'Polatlı', 'Eryaman', 'Beypazarı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Antalya", slug: "antalya", region: regionMap["antalya"], plate: 7, districts: ['Muratpaşa', 'Kepez', 'Konyaaltı', 'Alanya', 'Manavgat', 'Serik', 'Kaş', 'Kemer', 'Kumluca', 'Finike', 'Korkuteli', 'Elmalı', 'Gazipaşa', 'Döşemealtı', 'Aksu'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Artvin", slug: "artvin", region: regionMap["artvin"], plate: 8, districts: ['Merkez', 'Ardanuç', 'Arhavi', 'Borçka', 'Hopa', 'Kemalpaşa', 'Murgul', 'Şavşat', 'Yusufeli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Aydın", slug: "aydin", region: regionMap["aydin"], plate: 9, districts: ['Efeler', 'Nazilli', 'Söke', 'Kuşadası', 'Didim', 'Çine', 'İncirliova', 'Germencik', 'Bozdoğan', 'Buharkent', 'Karacasu', 'Koçarlı', 'Kuyucak', 'Sultanhisar'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Balıkesir", slug: "balikesir", region: regionMap["balikesir"], plate: 10, districts: ['Altıeylül', 'Karesi', 'Ayvalık', 'Bandırma', 'Burhaniye', 'Edremit', 'Erdek', 'Gömeç', 'Gönen', 'Havran', 'Bigadiç', 'Susurluk', 'Sındırgı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bilecik", slug: "bilecik", region: regionMap["bilecik"], plate: 11, districts: ['Merkez', 'Bozüyük', 'Osmaneli', 'Söğüt', 'Gölpazarı', 'Pazaryeri', 'İnhisar', 'Yenipazar'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bingöl", slug: "bingol", region: regionMap["bingol"], plate: 12, districts: ['Merkez', 'Genç', 'Solhan', 'Karlıova', 'Adaklı', 'Kiğı', 'Yayladere', 'Yedisu'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bitlis", slug: "bitlis", region: regionMap["bitlis"], plate: 13, districts: ['Merkez', 'Tatvan', 'Ahlat', 'Güroymak', 'Hizan', 'Mutki', 'Adilcevaz'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bolu", slug: "bolu", region: regionMap["bolu"], plate: 14, districts: ['Merkez', 'Gerede', 'Mudurnu', 'Göynük', 'Mengen', 'Yeniçağa', 'Dörtdivan', 'Seben'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bursa", slug: "bursa", region: regionMap["bursa"], plate: 16, districts: ['Osmangazi', 'Nilüfer', 'Yıldırım', 'İnegöl', 'Gemlik', 'Mudanya', 'Gürsu', 'Kestel', 'Karacabey', 'Mustafakemalpaşa', 'Orhangazi', 'İznik', 'Yenişehir'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Çanakkale", slug: "canakkale", region: regionMap["canakkale"], plate: 17, districts: ['Merkez', 'Biga', 'Çan', 'Gelibolu', 'Ayvacık', 'Ezine', 'Bayramiç', 'Lapseki', 'Yenice', 'Eceabat'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Çankırı", slug: "cankiri", region: regionMap["cankiri"], plate: 18, districts: ['Merkez', 'Ilgaz', 'Çerkeş', 'Orta', 'Şabanözü', 'Kurşunlu', 'Yapraklı', 'Kızılırmak', 'Eldivan'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Çorum", slug: "corum", region: regionMap["corum"], plate: 19, districts: ['Merkez', 'Sungurlu', 'Osmancık', 'İskilip', 'Alaca', 'Bayat', 'Kargı', 'Mecitözü', 'Ortaköy', 'Laçin', 'Oğuzlar', 'Dodurga'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Denizli", slug: "denizli", region: regionMap["denizli"], plate: 20, districts: ['Merkezefendi', 'Pamukkale', 'Çivril', 'Acıpayam', 'Tavas', 'Honaz', 'Sarayköy', 'Buldan', 'Kale', 'Çal', 'Bozkurt'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Diyarbakır", slug: "diyarbakir", region: regionMap["diyarbakir"], plate: 21, districts: ['Bağlar', 'Kayapınar', 'Yenişehir', 'Sur', 'Ergani', 'Bismil', 'Silvan', 'Çınar', 'Çermik', 'Dicle', 'Eğil', 'Hani', 'Hazro', 'Kocaköy', 'Kulp', 'Lice'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Edirne", slug: "edirne", region: regionMap["edirne"], plate: 22, districts: ['Merkez', 'Keşan', 'Uzunköprü', 'İpsala', 'Havsa', 'Meriç', 'Enez', 'Süloğlu', 'Lalapaşa'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Elazığ", slug: "elazig", region: regionMap["elazig"], plate: 23, districts: ['Merkez', 'Kovancılar', 'Karakoçan', 'Palu', 'Baskil', 'Maden', 'Sivrice', 'Keban', 'Alacakaya', 'Arıcak', 'Ağın'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Erzincan", slug: "erzincan", region: regionMap["erzincan"], plate: 24, districts: ['Merkez', 'Tercan', 'Üzümlü', 'Refahiye', 'Çayırlı', 'İliç', 'Kemah', 'Kemaliye', 'Otlukbeli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Erzurum", slug: "erzurum", region: regionMap["erzurum"], plate: 25, districts: ['Yakutiye', 'Palandöken', 'Aziziye', 'Horasan', 'Oltu', 'Pasinler', 'Hınıs', 'İspir', 'Karaçoban', 'Karayazı', 'Tekman', 'Aşkale', 'Çat', 'Narman', 'Tortum'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Eskişehir", slug: "eskisehir", region: regionMap["eskisehir"], plate: 26, districts: ['Odunpazarı', 'Tepebaşı', 'Sivrihisar', 'Çifteler', 'Seyitgazi', 'Alpu', 'Mihalıççık', 'Mahmudiye', 'Beylikova', 'İnönü', 'Günyüzü', 'Han', 'Sarıcakaya', 'Mihalgazi'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Gaziantep", slug: "gaziantep", region: regionMap["gaziantep"], plate: 27, districts: ['Şahinbey', 'Şehitkamil', 'Nizip', 'İslahiye', 'Nurdağı', 'Araban', 'Oğuzeli', 'Karkamış', 'Yavuzeli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Giresun", slug: "giresun", region: regionMap["giresun"], plate: 28, districts: ['Merkez', 'Bulancak', 'Espiye', 'Görele', 'Tirebolu', 'Şebinkarahisar', 'Keşap', 'Dereli', 'Yağlıdere', 'Piraziz', 'Eynesil', 'Alucra'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Gümüşhane", slug: "gumushane", region: regionMap["gumushane"], plate: 29, districts: ['Merkez', 'Kelkit', 'Şiran', 'Torul', 'Köse', 'Kürtün'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Hakkari", slug: "hakkari", region: regionMap["hakkari"], plate: 30, districts: ['Merkez', 'Yüksekova', 'Şemdinli', 'Çukurca', 'Derecik'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Hatay", slug: "hatay", region: regionMap["hatay"], plate: 31, districts: ['Antakya', 'Defne', 'İskenderun', 'Dörtyol', 'Samandağ', 'Kırıkhan', 'Reyhanlı', 'Arsuz', 'Belen', 'Hassa', 'Altınözü', 'Payas', 'Erzin', 'Yayladağı', 'Kumlu'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Isparta", slug: "isparta", region: regionMap["isparta"], plate: 32, districts: ['Merkez', 'Yalvaç', 'Eğirdir', 'Şarkikaraağaç', 'Gelendost', 'Keçiborlu', 'Senirkent', 'Uluborlu', 'Sütçüler', 'Gönen', 'Atabey'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Mersin", slug: "mersin", region: regionMap["mersin"], plate: 33, districts: ['Mezitli', 'Yenişehir', 'Toroslar', 'Tarsus', 'Erdemli', 'Silifke', 'Akdeniz', 'Anamur', 'Mut', 'Bozyazı', 'Gülnar', 'Aydıncık', 'Çamlıyayla'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "İstanbul", slug: "istanbul", region: regionMap["istanbul"], plate: 34, districts: ['Kadıköy', 'Beşiktaş', 'Şişli', 'Üsküdar', 'Maltepe', 'Pendik', 'Başakşehir', 'Beylikdüzü', 'Esenyurt', 'Bakırköy', 'Ümraniye', 'Kartal', 'Avcılar', 'Bağcılar', 'Bahçelievler', 'Beyoğlu', 'Fatih', 'Gaziosmanpaşa', 'Küçükçekmece', 'Ataşehir', 'Sancaktepe', 'Sarıyer', 'Esenler', 'Eyüpsultan'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "İzmir", slug: "izmir", region: regionMap["izmir"], plate: 35, districts: ['Bornova', 'Karşıyaka', 'Konak', 'Buca', 'Bayraklı', 'Çiğli', 'Karabağlar', 'Gaziemir', 'Balçova', 'Narlıdere', 'Menemen', 'Torbalı', 'Çeşme', 'Urla', 'Seferihisar', 'Menderes', 'Aliağa', 'Bergama', 'Ödemiş', 'Tire', 'Kemalpaşa', 'Foça'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kars", slug: "kars", region: regionMap["kars"], plate: 36, districts: ['Merkez', 'Kağızman', 'Sarıkamış', 'Selim', 'Digor', 'Arpaçay', 'Akyaka', 'Susuz'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kastamonu", slug: "kastamonu", region: regionMap["kastamonu"], plate: 37, districts: ['Merkez', 'Tosya', 'Taşköprü', 'İnebolu', 'Cide', 'Araç', 'Bozkurt', 'Daday', 'Devrekani', 'Abana', 'Azdavay', 'Çatalzeytin', 'Doğanyurt', 'Hanönü', 'İhsangazi', 'Küre', 'Pınarbaşı', 'Seydiler', 'Şenpazar', 'Ağlı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kayseri", slug: "kayseri", region: regionMap["kayseri"], plate: 38, districts: ['Melikgazi', 'Kocasinan', 'Talas', 'Develi', 'Bünyan', 'İncesu', 'Pınarbaşı', 'Tomarza', 'Yahyalı', 'Yeşilhisar', 'Hacılar', 'Sarıoğlan', 'Akkışla', 'Felahiye', 'Özvatan', 'Sarız'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kırklareli", slug: "kirklareli", region: regionMap["kirklareli"], plate: 39, districts: ['Merkez', 'Lüleburgaz', 'Babaeski', 'Vize', 'Pınarhisar', 'Demirköy', 'Kofçaz', 'Pehlivanköy'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kırşehir", slug: "kirsehir", region: regionMap["kirsehir"], plate: 40, districts: ['Merkez', 'Kaman', 'Mucur', 'Çiçekdağı', 'Akpınar', 'Boztepe', 'Akçakent'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kocaeli", slug: "kocaeli", region: regionMap["kocaeli"], plate: 41, districts: ['İzmit', 'Gebze', 'Darıca', 'Körfez', 'Gölcük', 'Derince', 'Başiskele', 'Kartepe', 'Çayırova', 'Dilovası', 'Karamürsel', 'Kandıra'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Konya", slug: "konya", region: regionMap["konya"], plate: 42, districts: ['Selçuklu', 'Meram', 'Karatay', 'Ereğli', 'Akşehir', 'Beyşehir', 'Çumra', 'Seydişehir', 'Ilgın', 'Cihanbeyli', 'Kulu', 'Karapınar', 'Bozkır', 'Kadınhanı', 'Sarayönü', 'Emirgazi', 'Hadim', 'Hüyük', 'Doğanhisar', 'Altınekin'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kütahya", slug: "kutahya", region: regionMap["kutahya"], plate: 43, districts: ['Merkez', 'Tavşanlı', 'Simav', 'Gediz', 'Emet', 'Altıntaş', 'Domaniç', 'Hisarcık', 'Aslanapa', 'Çavdarhisar', 'Dumlupınar', 'Şaphane', 'Pazarlar'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Malatya", slug: "malatya", region: regionMap["malatya"], plate: 44, districts: ['Yeşilyurt', 'Battalgazi', 'Doğanşehir', 'Akçadağ', 'Darende', 'Hekimhan', 'Pütürge', 'Arapgir', 'Arguvan', 'Kuluncak', 'Yazıhan', 'Kale', 'Doğanyol'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Manisa", slug: "manisa", region: regionMap["manisa"], plate: 45, districts: ['Yunusemre', 'Şehzadeler', 'Akhisar', 'Turgutlu', 'Salihli', 'Soma', 'Alaşehir', 'Saruhanlı', 'Kula', 'Kırkağaç', 'Demirci', 'Gördes', 'Köprübaşı', 'Selendi', 'Sarıgöl', 'Ahmetli', 'Gölmarmara'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kahramanmaraş", slug: "kahramanmaras", region: regionMap["kahramanmaras"], plate: 46, districts: ['Onikişubat', 'Dulkadiroğlu', 'Elbistan', 'Afşin', 'Türkoğlu', 'Pazarcık', 'Göksun', 'Andırın', 'Çağlayancerit', 'Ekinözü', 'Nurhak'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Mardin", slug: "mardin", region: regionMap["mardin"], plate: 47, districts: ['Artuklu', 'Kızıltepe', 'Midyat', 'Nusaybin', 'Derik', 'Mazıdağı', 'Dargeçit', 'Savur', 'Yeşilli', 'Ömerli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Muğla", slug: "mugla", region: regionMap["mugla"], plate: 48, districts: ['Bodrum', 'Fethiye', 'Milas', 'Menteşe', 'Marmaris', 'Ortaca', 'Seydikemer', 'Yatağan', 'Dalaman', 'Köyceğiz', 'Datça', 'Ula', 'Kavaklıdere'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Muş", slug: "mus", region: regionMap["mus"], plate: 49, districts: ['Merkez', 'Bulanık', 'Malazgirt', 'Varto', 'Hasköy', 'Korkut'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Nevşehir", slug: "nevsehir", region: regionMap["nevsehir"], plate: 50, districts: ['Merkez', 'Ürgüp', 'Avanos', 'Gülşehir', 'Derinkuyu', 'Hacıbektaş', 'Kozaklı', 'Acıgöl'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Niğde", slug: "nigde", region: regionMap["nigde"], plate: 51, districts: ['Merkez', 'Bor', 'Çamardı', 'Ulukışla', 'Çiftlik', 'Altunhisar'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Ordu", slug: "ordu", region: regionMap["ordu"], plate: 52, districts: ['Altınordu', 'Ünye', 'Fatsa', 'Perşembe', 'Gölköy', 'Korgan', 'Kumru', 'Mesudiye', 'Aybastı', 'Akkuş', 'Çatalpınar', 'Çaybaşı', 'İkizce', 'Kabadüz', 'Kabataş', 'Ulubey', 'Gürgentepe', 'Gülyalı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Rize", slug: "rize", region: regionMap["rize"], plate: 53, districts: ['Merkez', 'Çayeli', 'Ardeşen', 'Pazar', 'Fındıklı', 'Güneysu', 'Kalkandere', 'İyidere', 'Derepazarı', 'Çamlıhemşin', 'Hemşin', 'İkizdere'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Sakarya", slug: "sakarya", region: regionMap["sakarya"], plate: 54, districts: ['Adapazarı', 'Serdivan', 'Erenler', 'Akyazı', 'Hendek', 'Karasu', 'Geyve', 'Sapanca', 'Arifiye', 'Ferizli', 'Kocaali', 'Pamukova', 'Söğütlü', 'Kaynarca', 'Taraklı', 'Karapürçek'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Samsun", slug: "samsun", region: regionMap["samsun"], plate: 55, districts: ['İlkadım', 'Atakum', 'Canik', 'Bafra', 'Çarşamba', 'Tekkeköy', 'Vezirköprü', 'Terme', 'Havza', 'Kavak', 'Alaçam', 'Ayvacık', 'Asarcık', 'Ladik', 'Salıpazarı', '19 Mayıs', 'Yakakent'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Siirt", slug: "siirt", region: regionMap["siirt"], plate: 56, districts: ['Merkez', 'Kurtalan', 'Pervari', 'Baykan', 'Şirvan', 'Eruh', 'Tillo'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Sinop", slug: "sinop", region: regionMap["sinop"], plate: 57, districts: ['Merkez', 'Boyabat', 'Gerze', 'Ayancık', 'Durağan', 'Türkeli', 'Erfelek', 'Dikmen', 'Saraydüzü'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Sivas", slug: "sivas", region: regionMap["sivas"], plate: 58, districts: ['Merkez', 'Şarkışla', 'Yıldızeli', 'Suşehri', 'Gemerek', 'Zara', 'Gürün', 'Divriği', 'Kangal', 'Koyulhisar', 'Hafik', 'Altınyayla', 'Ulaş', 'Doğanşar', 'Gölova', 'Akıncılar', 'İmranlı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Tekirdağ", slug: "tekirdag", region: regionMap["tekirdag"], plate: 59, districts: ['Süleymanpaşa', 'Çorlu', 'Çerkezköy', 'Kapaklı', 'Ergene', 'Malkara', 'Marmaraereğlisi', 'Saray', 'Şarköy', 'Hayrabolu', 'Muratlı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Tokat", slug: "tokat", region: regionMap["tokat"], plate: 60, districts: ['Merkez', 'Erbaa', 'Turhal', 'Niksar', 'Zile', 'Reşadiye', 'Almus', 'Pazar', 'Artova', 'Sulusaray', 'Yeşilyurt', 'Başçiftlik'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Trabzon", slug: "trabzon", region: regionMap["trabzon"], plate: 61, districts: ['Ortahisar', 'Akçaabat', 'Araklı', 'Of', 'Arsin', 'Yomra', 'Sürmene', 'Vakfıkebir', 'Maçka', 'Çaykara', 'Beşikdüzü', 'Tonya', 'Düzköy', 'Şalpazarı', 'Dernekpazarı', 'Çarşıbaşı', 'Hayrat', 'Köprübaşı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Tunceli", slug: "tunceli", region: regionMap["tunceli"], plate: 62, districts: ['Merkez', 'Pertek', 'Mazgirt', 'Çemişgezek', 'Ovacık', 'Hozat', 'Nazımiye', 'Pülümür'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Şanlıurfa", slug: "sanliurfa", region: regionMap["sanliurfa"], plate: 63, districts: ['Eyyübiye', 'Haliliye', 'Karaköprü', 'Siverek', 'Viranşehir', 'Akçakale', 'Birecik', 'Bozova', 'Ceylanpınar', 'Halfeti', 'Harran', 'Hilvan', 'Suruç'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Uşak", slug: "usak", region: regionMap["usak"], plate: 64, districts: ['Merkez', 'Banaz', 'Eşme', 'Sivaslı', 'Ulubey', 'Karahallı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Van", slug: "van", region: regionMap["van"], plate: 65, districts: ['İpekyolu', 'Erciş', 'Tuşba', 'Edremit', 'Özalp', 'Çaldıran', 'Başkale', 'Muradiye', 'Gürpınar', 'Gevaş', 'Saray', 'Çatak', 'Bahçesaray'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Yozgat", slug: "yozgat", region: regionMap["yozgat"], plate: 66, districts: ['Merkez', 'Sorgun', 'Akdağmadeni', 'Yerköy', 'Boğazlıyan', 'Sarıkaya', 'Çekerek', 'Şefaatli', 'Saraykent', 'Çayıralan', 'Çandır', 'Kadışehri', 'Aydıncık', 'Yenifakılı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Zonguldak", slug: "zonguldak", region: regionMap["zonguldak"], plate: 67, districts: ['Merkez', 'Ereğli', 'Çaycuma', 'Devrek', 'Kozlu', 'Alaplı', 'Kilimli', 'Gökçebey'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Aksaray", slug: "aksaray", region: regionMap["aksaray"], plate: 68, districts: ['Merkez', 'Ortaköy', 'Eskil', 'Gülağaç', 'Güzelyurt', 'Ağaçören', 'Sarıyahşi', 'Sultanhanı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bayburt", slug: "bayburt", region: regionMap["bayburt"], plate: 69, districts: ['Merkez', 'Demirözü', 'Aydıntepe'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Karaman", slug: "karaman", region: regionMap["karaman"], plate: 70, districts: ['Merkez', 'Ermenek', 'Ayrancı', 'Kazımkarabekar', 'Başyayla', 'Sarıveliler'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kırıkkale", slug: "kirikkale", region: regionMap["kirikkale"], plate: 71, districts: ['Merkez', 'Yahşihan', 'Keskin', 'Delice', 'Balışeyh', 'Çelebi', 'Karakeçili', 'Sulakyurt', 'Bahşili'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Batman", slug: "batman", region: regionMap["batman"], plate: 72, districts: ['Merkez', 'Kozluk', 'Sason', 'Beşiri', 'Gercüş', 'Hasankeyf'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Şırnak", slug: "sirnak", region: regionMap["sirnak"], plate: 73, districts: ['Merkez', 'Cizre', 'Silopi', 'İdil', 'Uludere', 'Beytüşşebap', 'Güçlükonak'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bartın", slug: "bartin", region: regionMap["bartin"], plate: 74, districts: ['Merkez', 'Amasra', 'Ulus', 'Kurucaşile'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Ardahan", slug: "ardahan", region: regionMap["ardahan"], plate: 75, districts: ['Merkez', 'Göle', 'Çıldır', 'Hanak', 'Posof', 'Damal'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Iğdır", slug: "igdir", region: regionMap["igdir"], plate: 76, districts: ['Merkez', 'Tuzluca', 'Aralık', 'Karakoyunlu'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Yalova", slug: "yalova", region: regionMap["yalova"], plate: 77, districts: ['Merkez', 'Çiftlikköy', 'Çınarcık', 'Altınova', 'Armutlu', 'Termal'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Karabük", slug: "karabuk", region: regionMap["karabuk"], plate: 78, districts: ['Merkez', 'Safranbolu', 'Yenice', 'Eskipazar', 'Eflani', 'Ovacık'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kilis", slug: "kilis", region: regionMap["kilis"], plate: 79, districts: ['Merkez', 'Musabeyli', 'Elbeyli', 'Polateli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Osmaniye", slug: "osmaniye", region: regionMap["osmaniye"], plate: 80, districts: ['Merkez', 'Kadirli', 'Düziçi', 'Bahçe', 'Toprakkale', 'Sumbas', 'Hasanbeyli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Düzce", slug: "duzce", region: regionMap["duzce"], plate: 81, districts: ['Merkez', 'Akçakoca', 'Kaynaşlı', 'Gölyaka', 'Çilimli', 'Cumayeri', 'Gümüşova', 'Yığılca'].map(n => ({ name: n, slug: slugify(n) })) },
];

export const citySlugs = cities.map(c => c.slug);
export const getCityBySlug = (slug: string) => cities.find(c => c.slug === slug);
export const getDistrictBySlug = (citySlug: string, districtSlug: string) => {
  const city = getCityBySlug(citySlug);
  return city?.districts.find(d => d.slug === districtSlug);
};

// --- YENİ EKLENENLER: Google'ın kopya dememesi için unique içerik üreten helper'lar ---
export const getCityRegion = (slug: string) => regionMap[slug] || "Türkiye";

export const getCitySeoIntro = (citySlug: string, jobLabel: string) => {
  const city = getCityBySlug(citySlug);
  if (!city) return "";
  const top3 = city.districts.slice(0, 3).map(d => d.name).join(", ");
  const region = city.region || "Türkiye";
  return `${city.name} ${region} bölgesinde yer alır. ${top3} başta olmak üzere ${city.districts.length} ilçede ${jobLabel} talepleri için ustalar aranıyor. ${city.name} genelinde mahallene en yakın ustayı bul, teklifini ver, kazancını koru.`;
};

export const getCitySeoTitle = (citySlug: string, jobLabel: string) => {
  const city = getCityBySlug(citySlug);
  if (!city) return `${jobLabel} - Hemen Ustam Gelsin`;
  return `${city.name} ${jobLabel} - ${city.districts[0]?.name}, ${city.districts[1]?.name} ve Tüm İlçeler | %0 Komisyon`;
};

export const getCitySeoDescription = (citySlug: string, jobLabel: string) => {
  const city = getCityBySlug(citySlug);
  if (!city) return `${jobLabel} için usta bul`;
  const districts = city.districts.slice(0, 4).map(d => d.name).join(", ");
  return `${city.name} ${jobLabel} işleri için ${districts} başta olmak üzere ${city.districts.length} ilçede %0 hakediş komisyonu ile usta bul. HugAI ile analiz edilmiş gerçek taleplere şeffaf teklif ver.`;
};