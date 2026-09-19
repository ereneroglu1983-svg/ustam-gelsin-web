// data/cities.ts

export type District = {
  name: string;
  slug: string;
};

export type City = {
  name: string;
  slug: string;
  districts: District[];
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

export const cities: City[] = [
  { name: "Adana", slug: "adana", districts: ['Seyhan', 'Yüreğir', 'Çukurova', 'Sarıçam', 'Ceyhan', 'Kozan', 'İmamoğlu', 'Karaisalı', 'Karataş', 'Yumurtalık', 'Pozantı', 'Aladağ', 'Feke', 'Saimbeyli', 'Tufanbeyli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Adıyaman", slug: "adiyaman", districts: ['Merkez', 'Kahta', 'Besni', 'Gölbaşı', 'Gerger', 'Çelikhan', 'Samsat', 'Sincik', 'Tut'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Afyonkarahisar", slug: "afyonkarahisar", districts: ['Merkez', 'Sandıklı', 'Dinar', 'Bolvadin', 'Emirdağ', 'İhsaniye', 'Sinanpaşa', 'Şuhut', 'Çobanlar', 'İscehisar', 'Çay'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Ağrı", slug: "agri", districts: ['Merkez', 'Patnos', 'Doğubayazıt', 'Diyadin', 'Eleşkirt', 'Tutak', 'Hamur', 'Taşlıçay'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Amasya", slug: "amasya", districts: ['Merkez', 'Merzifon', 'Suluova', 'Taşova', 'Göynücek', 'Hamamözü', 'Gümüşhacıköy'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Ankara", slug: "ankara", districts: ['Çankaya', 'Keçiören', 'Yenimahalle', 'Mamak', 'Etimesgut', 'Sincan', 'Altındağ', 'Gölbaşı', 'Pursaklar', 'Çubuk', 'Polatlı', 'Eryaman', 'Beypazarı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Antalya", slug: "antalya", districts: ['Muratpaşa', 'Kepez', 'Konyaaltı', 'Alanya', 'Manavgat', 'Serik', 'Kaş', 'Kemer', 'Kumluca', 'Finike', 'Korkuteli', 'Elmalı', 'Gazipaşa', 'Döşemealtı', 'Aksu'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Artvin", slug: "artvin", districts: ['Merkez', 'Ardanuç', 'Arhavi', 'Borçka', 'Hopa', 'Kemalpaşa', 'Murgul', 'Şavşat', 'Yusufeli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Aydın", slug: "aydin", districts: ['Efeler', 'Nazilli', 'Söke', 'Kuşadası', 'Didim', 'Çine', 'İncirliova', 'Germencik', 'Bozdoğan', 'Buharkent', 'Karacasu', 'Koçarlı', 'Kuyucak', 'Sultanhisar'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Balıkesir", slug: "balikesir", districts: ['Altıeylül', 'Karesi', 'Ayvalık', 'Bandırma', 'Burhaniye', 'Edremit', 'Erdek', 'Gömeç', 'Gönen', 'Havran', 'Bigadiç', 'Susurluk', 'Sındırgı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bilecik", slug: "bilecik", districts: ['Merkez', 'Bozüyük', 'Osmaneli', 'Söğüt', 'Gölpazarı', 'Pazaryeri', 'İnhisar', 'Yenipazar'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bingöl", slug: "bingol", districts: ['Merkez', 'Genç', 'Solhan', 'Karlıova', 'Adaklı', 'Kiğı', 'Yayladere', 'Yedisu'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bitlis", slug: "bitlis", districts: ['Merkez', 'Tatvan', 'Ahlat', 'Güroymak', 'Hizan', 'Mutki', 'Adilcevaz'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bolu", slug: "bolu", districts: ['Merkez', 'Gerede', 'Mudurnu', 'Göynük', 'Mengen', 'Yeniçağa', 'Dörtdivan', 'Seben'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bursa", slug: "bursa", districts: ['Osmangazi', 'Nilüfer', 'Yıldırım', 'İnegöl', 'Gemlik', 'Mudanya', 'Gürsu', 'Kestel', 'Karacabey', 'Mustafakemalpaşa', 'Orhangazi', 'İznik', 'Yenişehir'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Çanakkale", slug: "canakkale", districts: ['Merkez', 'Biga', 'Çan', 'Gelibolu', 'Ayvacık', 'Ezine', 'Bayramiç', 'Lapseki', 'Yenice', 'Eceabat'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Çankırı", slug: "cankiri", districts: ['Merkez', 'Ilgaz', 'Çerkeş', 'Orta', 'Şabanözü', 'Kurşunlu', 'Yapraklı', 'Kızılırmak', 'Eldivan'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Çorum", slug: "corum", districts: ['Merkez', 'Sungurlu', 'Osmancık', 'İskilip', 'Alaca', 'Bayat', 'Kargı', 'Mecitözü', 'Ortaköy', 'Laçin', 'Oğuzlar', 'Dodurga'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Denizli", slug: "denizli", districts: ['Merkezefendi', 'Pamukkale', 'Çivril', 'Acıpayam', 'Tavas', 'Honaz', 'Sarayköy', 'Buldan', 'Kale', 'Çal', 'Bozkurt'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Diyarbakır", slug: "diyarbakir", districts: ['Bağlar', 'Kayapınar', 'Yenişehir', 'Sur', 'Ergani', 'Bismil', 'Silvan', 'Çınar', 'Çermik', 'Dicle', 'Eğil', 'Hani', 'Hazro', 'Kocaköy', 'Kulp', 'Lice'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Edirne", slug: "edirne", districts: ['Merkez', 'Keşan', 'Uzunköprü', 'İpsala', 'Havsa', 'Meriç', 'Enez', 'Süloğlu', 'Lalapaşa'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Elazığ", slug: "elazig", districts: ['Merkez', 'Kovancılar', 'Karakoçan', 'Palu', 'Baskil', 'Maden', 'Sivrice', 'Keban', 'Alacakaya', 'Arıcak', 'Ağın'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Erzincan", slug: "erzincan", districts: ['Merkez', 'Tercan', 'Üzümlü', 'Refahiye', 'Çayırlı', 'İliç', 'Kemah', 'Kemaliye', 'Otlukbeli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Erzurum", slug: "erzurum", districts: ['Yakutiye', 'Palandöken', 'Aziziye', 'Horasan', 'Oltu', 'Pasinler', 'Hınıs', 'İspir', 'Karaçoban', 'Karayazı', 'Tekman', 'Aşkale', 'Çat', 'Narman', 'Tortum'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Eskişehir", slug: "eskisehir", districts: ['Odunpazarı', 'Tepebaşı', 'Sivrihisar', 'Çifteler', 'Seyitgazi', 'Alpu', 'Mihalıççık', 'Mahmudiye', 'Beylikova', 'İnönü', 'Günyüzü', 'Han', 'Sarıcakaya', 'Mihalgazi'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Gaziantep", slug: "gaziantep", districts: ['Şahinbey', 'Şehitkamil', 'Nizip', 'İslahiye', 'Nurdağı', 'Araban', 'Oğuzeli', 'Karkamış', 'Yavuzeli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Giresun", slug: "giresun", districts: ['Merkez', 'Bulancak', 'Espiye', 'Görele', 'Tirebolu', 'Şebinkarahisar', 'Keşap', 'Dereli', 'Yağlıdere', 'Piraziz', 'Eynesil', 'Alucra'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Gümüşhane", slug: "gumushane", districts: ['Merkez', 'Kelkit', 'Şiran', 'Torul', 'Köse', 'Kürtün'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Hakkari", slug: "hakkari", districts: ['Merkez', 'Yüksekova', 'Şemdinli', 'Çukurca', 'Derecik'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Hatay", slug: "hatay", districts: ['Antakya', 'Defne', 'İskenderun', 'Dörtyol', 'Samandağ', 'Kırıkhan', 'Reyhanlı', 'Arsuz', 'Belen', 'Hassa', 'Altınözü', 'Payas', 'Erzin', 'Yayladağı', 'Kumlu'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Isparta", slug: "isparta", districts: ['Merkez', 'Yalvaç', 'Eğirdir', 'Şarkikaraağaç', 'Gelendost', 'Keçiborlu', 'Senirkent', 'Uluborlu', 'Sütçüler', 'Gönen', 'Atabey'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Mersin", slug: "mersin", districts: ['Mezitli', 'Yenişehir', 'Toroslar', 'Tarsus', 'Erdemli', 'Silifke', 'Akdeniz', 'Anamur', 'Mut', 'Bozyazı', 'Gülnar', 'Aydıncık', 'Çamlıyayla'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "İstanbul", slug: "istanbul", districts: ['Kadıköy', 'Beşiktaş', 'Şişli', 'Üsküdar', 'Maltepe', 'Pendik', 'Başakşehir', 'Beylikdüzü', 'Esenyurt', 'Bakırköy', 'Ümraniye', 'Kartal', 'Avcılar', 'Bağcılar', 'Bahçelievler', 'Beyoğlu', 'Fatih', 'Gaziosmanpaşa', 'Küçükçekmece', 'Ataşehir', 'Sancaktepe', 'Sarıyer', 'Esenler', 'Eyüpsultan'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "İzmir", slug: "izmir", districts: ['Bornova', 'Karşıyaka', 'Konak', 'Buca', 'Bayraklı', 'Çiğli', 'Karabağlar', 'Gaziemir', 'Balçova', 'Narlıdere', 'Menemen', 'Torbalı', 'Çeşme', 'Urla', 'Seferihisar', 'Menderes', 'Aliağa', 'Bergama', 'Ödemiş', 'Tire', 'Kemalpaşa', 'Foça'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kars", slug: "kars", districts: ['Merkez', 'Kağızman', 'Sarıkamış', 'Selim', 'Digor', 'Arpaçay', 'Akyaka', 'Susuz'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kastamonu", slug: "kastamonu", districts: ['Merkez', 'Tosya', 'Taşköprü', 'İnebolu', 'Cide', 'Araç', 'Bozkurt', 'Daday', 'Devrekani', 'Abana', 'Azdavay', 'Çatalzeytin', 'Doğanyurt', 'Hanönü', 'İhsangazi', 'Küre', 'Pınarbaşı', 'Seydiler', 'Şenpazar', 'Ağlı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kayseri", slug: "kayseri", districts: ['Melikgazi', 'Kocasinan', 'Talas', 'Develi', 'Bünyan', 'İncesu', 'Pınarbaşı', 'Tomarza', 'Yahyalı', 'Yeşilhisar', 'Hacılar', 'Sarıoğlan', 'Akkışla', 'Felahiye', 'Özvatan', 'Sarız'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kırklareli", slug: "kirklareli", districts: ['Merkez', 'Lüleburgaz', 'Babaeski', 'Vize', 'Pınarhisar', 'Demirköy', 'Kofçaz', 'Pehlivanköy'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kırşehir", slug: "kirsehir", districts: ['Merkez', 'Kaman', 'Mucur', 'Çiçekdağı', 'Akpınar', 'Boztepe', 'Akçakent'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kocaeli", slug: "kocaeli", districts: ['İzmit', 'Gebze', 'Darıca', 'Körfez', 'Gölcük', 'Derince', 'Başiskele', 'Kartepe', 'Çayırova', 'Dilovası', 'Karamürsel', 'Kandıra'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Konya", slug: "konya", districts: ['Selçuklu', 'Meram', 'Karatay', 'Ereğli', 'Akşehir', 'Beyşehir', 'Çumra', 'Seydişehir', 'Ilgın', 'Cihanbeyli', 'Kulu', 'Karapınar', 'Bozkır', 'Kadınhanı', 'Sarayönü', 'Emirgazi', 'Hadim', 'Hüyük', 'Doğanhisar', 'Altınekin'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kütahya", slug: "kutahya", districts: ['Merkez', 'Tavşanlı', 'Simav', 'Gediz', 'Emet', 'Altıntaş', 'Domaniç', 'Hisarcık', 'Aslanapa', 'Çavdarhisar', 'Dumlupınar', 'Şaphane', 'Pazarlar'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Malatya", slug: "malatya", districts: ['Yeşilyurt', 'Battalgazi', 'Doğanşehir', 'Akçadağ', 'Darende', 'Hekimhan', 'Pütürge', 'Arapgir', 'Arguvan', 'Kuluncak', 'Yazıhan', 'Kale', 'Doğanyol'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Manisa", slug: "manisa", districts: ['Yunusemre', 'Şehzadeler', 'Akhisar', 'Turgutlu', 'Salihli', 'Soma', 'Alaşehir', 'Saruhanlı', 'Kula', 'Kırkağaç', 'Demirci', 'Gördes', 'Köprübaşı', 'Selendi', 'Sarıgöl', 'Ahmetli', 'Gölmarmara'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kahramanmaraş", slug: "kahramanmaras", districts: ['Onikişubat', 'Dulkadiroğlu', 'Elbistan', 'Afşin', 'Türkoğlu', 'Pazarcık', 'Göksun', 'Andırın', 'Çağlayancerit', 'Ekinözü', 'Nurhak'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Mardin", slug: "mardin", districts: ['Artuklu', 'Kızıltepe', 'Midyat', 'Nusaybin', 'Derik', 'Mazıdağı', 'Dargeçit', 'Savur', 'Yeşilli', 'Ömerli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Muğla", slug: "mugla", districts: ['Bodrum', 'Fethiye', 'Milas', 'Menteşe', 'Marmaris', 'Ortaca', 'Seydikemer', 'Yatağan', 'Dalaman', 'Köyceğiz', 'Datça', 'Ula', 'Kavaklıdere'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Muş", slug: "mus", districts: ['Merkez', 'Bulanık', 'Malazgirt', 'Varto', 'Hasköy', 'Korkut'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Nevşehir", slug: "nevsehir", districts: ['Merkez', 'Ürgüp', 'Avanos', 'Gülşehir', 'Derinkuyu', 'Hacıbektaş', 'Kozaklı', 'Acıgöl'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Niğde", slug: "nigde", districts: ['Merkez', 'Bor', 'Çamardı', 'Ulukışla', 'Çiftlik', 'Altunhisar'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Ordu", slug: "ordu", districts: ['Altınordu', 'Ünye', 'Fatsa', 'Perşembe', 'Gölköy', 'Korgan', 'Kumru', 'Mesudiye', 'Aybastı', 'Akkuş', 'Çatalpınar', 'Çaybaşı', 'İkizce', 'Kabadüz', 'Kabataş', 'Ulubey', 'Gürgentepe', 'Gülyalı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Rize", slug: "rize", districts: ['Merkez', 'Çayeli', 'Ardeşen', 'Pazar', 'Fındıklı', 'Güneysu', 'Kalkandere', 'İyidere', 'Derepazarı', 'Çamlıhemşin', 'Hemşin', 'İkizdere'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Sakarya", slug: "sakarya", districts: ['Adapazarı', 'Serdivan', 'Erenler', 'Akyazı', 'Hendek', 'Karasu', 'Geyve', 'Sapanca', 'Arifiye', 'Ferizli', 'Kocaali', 'Pamukova', 'Söğütlü', 'Kaynarca', 'Taraklı', 'Karapürçek'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Samsun", slug: "samsun", districts: ['İlkadım', 'Atakum', 'Canik', 'Bafra', 'Çarşamba', 'Tekkeköy', 'Vezirköprü', 'Terme', 'Havza', 'Kavak', 'Alaçam', 'Ayvacık', 'Asarcık', 'Ladik', 'Salıpazarı', '19 Mayıs', 'Yakakent'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Siirt", slug: "siirt", districts: ['Merkez', 'Kurtalan', 'Pervari', 'Baykan', 'Şirvan', 'Eruh', 'Tillo'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Sinop", slug: "sinop", districts: ['Merkez', 'Boyabat', 'Gerze', 'Ayancık', 'Durağan', 'Türkeli', 'Erfelek', 'Dikmen', 'Saraydüzü'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Sivas", slug: "sivas", districts: ['Merkez', 'Şarkışla', 'Yıldızeli', 'Suşehri', 'Gemerek', 'Zara', 'Gürün', 'Divriği', 'Kangal', 'Koyulhisar', 'Hafik', 'Altınyayla', 'Ulaş', 'Doğanşar', 'Gölova', 'Akıncılar', 'İmranlı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Tekirdağ", slug: "tekirdag", districts: ['Süleymanpaşa', 'Çorlu', 'Çerkezköy', 'Kapaklı', 'Ergene', 'Malkara', 'Marmaraereğlisi', 'Saray', 'Şarköy', 'Hayrabolu', 'Muratlı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Tokat", slug: "tokat", districts: ['Merkez', 'Erbaa', 'Turhal', 'Niksar', 'Zile', 'Reşadiye', 'Almus', 'Pazar', 'Artova', 'Sulusaray', 'Yeşilyurt', 'Başçiftlik'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Trabzon", slug: "trabzon", districts: ['Ortahisar', 'Akçaabat', 'Araklı', 'Of', 'Arsin', 'Yomra', 'Sürmene', 'Vakfıkebir', 'Maçka', 'Çaykara', 'Beşikdüzü', 'Tonya', 'Düzköy', 'Şalpazarı', 'Dernekpazarı', 'Çarşıbaşı', 'Hayrat', 'Köprübaşı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Tunceli", slug: "tunceli", districts: ['Merkez', 'Pertek', 'Mazgirt', 'Çemişgezek', 'Ovacık', 'Hozat', 'Nazımiye', 'Pülümür'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Şanlıurfa", slug: "sanliurfa", districts: ['Eyyübiye', 'Haliliye', 'Karaköprü', 'Siverek', 'Viranşehir', 'Akçakale', 'Birecik', 'Bozova', 'Ceylanpınar', 'Halfeti', 'Harran', 'Hilvan', 'Suruç'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Uşak", slug: "usak", districts: ['Merkez', 'Banaz', 'Eşme', 'Sivaslı', 'Ulubey', 'Karahallı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Van", slug: "van", districts: ['İpekyolu', 'Erciş', 'Tuşba', 'Edremit', 'Özalp', 'Çaldıran', 'Başkale', 'Muradiye', 'Gürpınar', 'Gevaş', 'Saray', 'Çatak', 'Bahçesaray'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Yozgat", slug: "yozgat", districts: ['Merkez', 'Sorgun', 'Akdağmadeni', 'Yerköy', 'Boğazlıyan', 'Sarıkaya', 'Çekerek', 'Şefaatli', 'Saraykent', 'Çayıralan', 'Çandır', 'Kadışehri', 'Aydıncık', 'Yenifakılı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Zonguldak", slug: "zonguldak", districts: ['Merkez', 'Ereğli', 'Çaycuma', 'Devrek', 'Kozlu', 'Alaplı', 'Kilimli', 'Gökçebey'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Aksaray", slug: "aksaray", districts: ['Merkez', 'Ortaköy', 'Eskil', 'Gülağaç', 'Güzelyurt', 'Ağaçören', 'Sarıyahşi', 'Sultanhanı'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bayburt", slug: "bayburt", districts: ['Merkez', 'Demirözü', 'Aydıntepe'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Karaman", slug: "karaman", districts: ['Merkez', 'Ermenek', 'Ayrancı', 'Kazımkarabekar', 'Başyayla', 'Sarıveliler'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kırıkkale", slug: "kirikkale", districts: ['Merkez', 'Yahşihan', 'Keskin', 'Delice', 'Balışeyh', 'Çelebi', 'Karakeçili', 'Sulakyurt', 'Bahşili'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Batman", slug: "batman", districts: ['Merkez', 'Kozluk', 'Sason', 'Beşiri', 'Gercüş', 'Hasankeyf'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Şırnak", slug: "sirnak", districts: ['Merkez', 'Cizre', 'Silopi', 'İdil', 'Uludere', 'Beytüşşebap', 'Güçlükonak'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Bartın", slug: "bartin", districts: ['Merkez', 'Amasra', 'Ulus', 'Kurucaşile'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Ardahan", slug: "ardahan", districts: ['Merkez', 'Göle', 'Çıldır', 'Hanak', 'Posof', 'Damal'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Iğdır", slug: "igdir", districts: ['Merkez', 'Tuzluca', 'Aralık', 'Karakoyunlu'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Yalova", slug: "yalova", districts: ['Merkez', 'Çiftlikköy', 'Çınarcık', 'Altınova', 'Armutlu', 'Termal'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Karabük", slug: "karabuk", districts: ['Merkez', 'Safranbolu', 'Yenice', 'Eskipazar', 'Eflani', 'Ovacık'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Kilis", slug: "kilis", districts: ['Merkez', 'Musabeyli', 'Elbeyli', 'Polateli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Osmaniye", slug: "osmaniye", districts: ['Merkez', 'Kadirli', 'Düziçi', 'Bahçe', 'Toprakkale', 'Sumbas', 'Hasanbeyli'].map(n => ({ name: n, slug: slugify(n) })) },
  { name: "Düzce", slug: "duzce", districts: ['Merkez', 'Akçakoca', 'Kaynaşlı', 'Gölyaka', 'Çilimli', 'Cumayeri', 'Gümüşova', 'Yığılca'].map(n => ({ name: n, slug: slugify(n) })) },
];

export const citySlugs = cities.map(c => c.slug);
export const getCityBySlug = (slug: string) => cities.find(c => c.slug === slug);
export const getDistrictBySlug = (citySlug: string, districtSlug: string) => {
  const city = getCityBySlug(citySlug);
  return city?.districts.find(d => d.slug === districtSlug);
};