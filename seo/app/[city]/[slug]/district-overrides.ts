// app/[city]/[slug]/district-overrides.ts - FINAL v5.1 - FIXED - 41 İLÇE
// FIX: duplicate serviceFocus temizlendi, nearbyPriority city/district -> district formatına çevrildi, şehir dışı ilçeler silindi

export type DistrictSEOData = {
  localIntro: string;
  demandNote: string;
  serviceFocus: string[];
  faqTopics: string[];
  nearbyPriority: string[];
};

export const districtSEODataOverride: Record<string, DistrictSEOData> = {
  "istanbul/besiktas": {
    localIntro: "Beşiktaş'ta Levent ve Etiler'in modern rezidanslarından Bebek ve Arnavutköy'ün karakterli apartmanlarına kadar her yapının yenileme ihtiyacı farklıdır. Hemen Ustam Gelsin üzerinden iç mimari, özel ölçülü mobilya, banyo dönüşümü ve dekoratif boya işleri için ihtiyacına uygun ustalardan teklif alabilir; kapsamı ve maliyeti işe başlamadan netleştirebilirsin.",
    demandNote: "Levent ve Etiler'de özel mutfak, banyo yenileme ve dekoratif boya; eski apartmanlarda tesisat ve iç mekân dönüşümü öne çıkar.",
    serviceFocus: ["anahtar-teslim-komple-tadilat", "mutfak-dolabi-ve-tezgahi", "banyo-dolabi-ve-vestiyer", "asma-tavan", "italyan-boya-ve-dekoratif-siva", "ic-cephe-boya-ve-badana", "laminat-lamine-ve-masif-parke", "fayans-seramik-ve-kalebodur", "elektrik-tesisati", "cam-balkon-ve-giyotin-cam"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "hugai", "komisyon"],
    nearbyPriority: ["sisli", "kagithane", "beyoglu", "sariyer", "kadikoy", "uskudar"]
  },
  "istanbul/kadikoy": {
    localIntro: "Kadıköy'de Moda'nın eski apartmanları, Fenerbahçe'nin köklü konutları ve Caddebostan'ın modern daireleri aynı tadilat yaklaşımıyla ele alınamaz. İç mekânın yenilenmesi, mutfak ve banyo dolaplarının ölçüye göre hazırlanması, zemin kaplamalarının değiştirilmesi ve tesisatın elden geçirilmesi gibi işler için Hemen Ustam Gelsin'de ihtiyacını tanımlayarak uygun ustalara ulaşabilirsin.",
    demandNote: "Moda ve Yeldeğirmeni'nde eski daire yenileme; Caddebostan ve Fenerbahçe'de mutfak, banyo ve dekorasyon işleri öne çıkar.",
    serviceFocus: ["anahtar-teslim-komple-tadilat", "mutfak-dolabi-ve-tezgahi", "banyo-dolabi-ve-vestiyer", "italyan-boya-ve-dekoratif-siva", "asma-tavan", "laminat-lamine-ve-masif-parke", "fayans-seramik-ve-kalebodur", "ic-cephe-boya-ve-badana", "elektrik-tesisati", "cam-balkon-ve-giyotin-cam"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "hugai", "komisyon"],
    nearbyPriority: ["atasehir", "uskudar", "maltepe", "umraniye", "beykoz", "besiktas"]
  },
  "istanbul/sisli": {
    localIntro: "Şişli'de Nişantaşı'nın yenilenen daireleri, Bomonti'nin yeni konutları ve Mecidiyeköy'ün yoğun apartman dokusu birbirinden farklı uygulamalar gerektirir. Alanı verimli kullanan özel dolaplar, çağdaş banyo tasarımları, alçıpan ve aydınlatma çözümleri kadar eski yapılardaki elektrik ve su tesisatı da önemlidir. Hemen Ustam Gelsin, bu işleri ayrı ayrı tanımlayıp uygun ustalara ulaşmanı kolaylaştırır.",
    demandNote: "Nişantaşı'nda dekorasyon ve özel imalat; Bomonti ile Mecidiyeköy'de daire tadilatı, tesisat ve zemin yenileme öne çıkar.",
    serviceFocus: ["anahtar-teslim-komple-tadilat", "mutfak-dolabi-ve-tezgahi", "banyo-dolabi-ve-vestiyer", "asma-tavan", "italyan-boya-ve-dekoratif-siva", "elektrik-tesisati", "laminat-lamine-ve-masif-parke", "ic-cephe-boya-ve-badana", "fayans-seramik-ve-kalebodur", "cam-balkon-ve-giyotin-cam"],
    faqTopics: ["usta-fiyatlari", "komisyon", "hugai", "ilan-verme"],
    nearbyPriority: ["besiktas", "beyoglu", "kagithane", "sariyer", "fatih", "beylikduzu"]
  },
  "istanbul/fatih": {
    localIntro: "Fatih'te Balat ve Fener'in tarihî dokusu, Aksaray'ın yoğun apartmanları ve Kocamustafapaşa'nın yerleşik mahalleleri farklı bakım ihtiyaçları doğurur. Eski yapılarda tesisat yenilemesi, nem ve su sızıntısı sorunları, çatı bakımı ve iç cephe onarımı dikkatle planlanmalıdır. Hemen Ustam Gelsin üzerinden işin kapsamını belirterek boya, seramik, tesisat ve tadilat ustalarından teklif isteyebilirsin.",
    demandNote: "Balat ve Fener'de eski yapıların dikkatli yenilenmesi; Aksaray ve çevresinde tesisat, boya ve banyo onarımı öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "fayans-seramik-ve-kalebodur", "anahtar-teslim-komple-tadilat", "laminat-lamine-ve-masif-parke", "cati-yapimi-aktarma-ve-izolasyon", "dis-cephe-boya-ve-mantolama", "temel-ve-bodrum-su-yalitimi", "pvc-dograma"],
    faqTopics: ["usta-fiyatlari", "hizmetler", "ilan-verme", "hugai"],
    nearbyPriority: ["beyoglu", "eyupsultan", "zeytinburnu", "bayrampasa", "sisli", "uskudar"]
  },
  "istanbul/uskudar": {
    localIntro: "Üsküdar'da Kuzguncuk'un geleneksel evleri, Çengelköy'ün bahçeli konutları ve Acıbadem'in apartmanları farklı uzmanlıklar gerektirir. Ahşap detayların korunması, çatı ve dış cephe bakımı, banyo yenileme ve su tesisatı onarımı gibi işlerde yapının mevcut durumunu doğru değerlendirmek önemlidir. Hemen Ustam Gelsin ile işini tarif ederek ilgili ustalara ulaşabilir, teklifleri karşılaştırabilirsin.",
    demandNote: "Kuzguncuk ve Çengelköy'de eski ev bakımı; Acıbadem'de daire tadilatı, banyo yenileme ve tesisat işleri öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "mutfak-dolabi-ve-tezgahi", "banyo-dolabi-ve-vestiyer", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "fayans-seramik-ve-kalebodur", "laminat-lamine-ve-masif-parke", "dis-cephe-boya-ve-mantolama", "cati-yapimi-aktarma-ve-izolasyon", "anahtar-teslim-komple-tadilat"],
    faqTopics: ["usta-fiyatlari", "komisyon", "hizmetler", "ilan-verme"],
    nearbyPriority: ["kadikoy", "umraniye", "beykoz", "atasehir", "fatih", "besiktas"]
  },
  "istanbul/atasehir": {
    localIntro: "Ataşehir'de Barbaros ve Küçükbakkalköy çevresindeki yüksek katlı konutlarla İçerenköy'ün yerleşik mahallelerinde farklı yenileme ihtiyaçları ortaya çıkar. Site dairelerinde mutfak ve banyo dönüşümü, gömme dolap, aydınlatma ve zemin kaplamaları öne çıkarken eski dairelerde tesisat ve yüzey onarımları gerekebilir. Hemen Ustam Gelsin'de iş kapsamını belirterek uygun ustalardan teklif alabilirsin.",
    demandNote: "Barbaros ve Küçükbakkalköy'de modern daire dekorasyonu; İçerenköy'de mutfak, banyo ve tesisat yenilemeleri öne çıkar.",
    serviceFocus: ["anahtar-teslim-komple-tadilat", "mutfak-dolabi-ve-tezgahi", "banyo-dolabi-ve-vestiyer", "asma-tavan", "italyan-boya-ve-dekoratif-siva", "elektrik-tesisati", "laminat-lamine-ve-masif-parke", "fayans-seramik-ve-kalebodur", "ic-cephe-boya-ve-badana", "cam-balkon-ve-giyotin-cam"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "hugai", "komisyon"],
    nearbyPriority: ["kadikoy", "umraniye", "maltepe", "sancaktepe", "uskudar", "pendik"]
  },
  "istanbul/beylikduzu": {
    localIntro: "Beylikdüzü'nde Adnan Kahveci'nin site yaşamı, Barış Mahallesi'nin yerleşik konutları ve Gürpınar'ın farklı yapı tipleri ev sahiplerine değişen bakım ihtiyaçları sunar. Yeni dairelerde montaj ve ince işler; mevcut yapılarda balkon yalıtımı, PVC doğrama, tesisat ve dış cephe bakımı gündeme gelir. Hemen Ustam Gelsin üzerinden yapılacak işi ayrıntılı anlatarak uygun ustalardan fiyat teklifi isteyebilirsin.",
    demandNote: "Adnan Kahveci'de yeni daire ince işleri; Gürpınar ve Barış'ta tesisat, pencere, boya ve yalıtım işleri öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "dis-cephe-boya-ve-mantolama", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "pvc-dograma", "mutfak-dolabi-ve-tezgahi", "fayans-seramik-ve-kalebodur", "laminat-lamine-ve-masif-parke", "cati-yapimi-aktarma-ve-izolasyon", "temel-ve-bodrum-su-yalitimi"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "komisyon", "hizmetler"],
    nearbyPriority: ["esenyurt", "avcilar", "buyukcekmece", "basaksehir", "kucukcekmece", "silivri"]
  },
  "istanbul/esenyurt": {
    localIntro: "Esenyurt'ta Mehterçeşme'nin yoğun yerleşimi, Cumhuriyet Mahallesi'nin konutları ve Saadetdere çevresindeki farklı yapı tipleri bakım ihtiyacını çeşitlendirir. Su kaçağı, elektrik arızası, pencere ayarı, boya ve banyo onarımı gibi işlerde hızlı erişim önemlidir; apartmanlarda ortak alan ve dış cephe sorunları da ayrıca değerlendirilmelidir. Hemen Ustam Gelsin'de ihtiyacını açıklayıp ilgili ustalardan teklif alabilirsin.",
    demandNote: "Mehterçeşme ve Saadetdere'de tesisat, elektrik ve boya onarımı; sitelerde banyo, pencere ve ortak alan işleri öne çıkar.",
    serviceFocus: ["sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "pvc-dograma", "ic-cephe-boya-ve-badana", "dis-cephe-boya-ve-mantolama", "cati-yapimi-aktarma-ve-izolasyon", "temel-ve-bodrum-su-yalitimi", "fayans-seramik-ve-kalebodur", "laminat-lamine-ve-masif-parke", "anahtar-teslim-komple-tadilat"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "komisyon", "hugai"],
    nearbyPriority: ["beylikduzu", "avcilar", "basaksehir", "buyukcekmece", "arnavutkoy", "kucukcekmece"]
  },
  "istanbul/pendik": {
    localIntro: "Pendik'te Kurtköy ve Yenişehir'in gelişen konut alanlarıyla Kaynarca'nın yerleşik mahalleleri farklı iş kollarında usta ihtiyacı oluşturur. Yeni dairelerde montaj ve ince işler, eski yapılarda tesisat ve boya yenilemeleri; müstakil evlerde ise çatı, dış cephe ve bahçe bakımı öne çıkar. Hemen Ustam Gelsin ile işini tanımlayarak konutunun ihtiyacına uygun ustalardan teklif isteyebilirsin.",
    demandNote: "Kurtköy ve Yenişehir'de yeni konut montajı; Kaynarca'da tesisat, boya, PVC doğrama ve çatı işleri öne çıkar.",
    serviceFocus: ["sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "pvc-dograma", "cati-yapimi-aktarma-ve-izolasyon", "dis-cephe-boya-ve-mantolama", "ic-cephe-boya-ve-badana", "fayans-seramik-ve-kalebodur", "laminat-lamine-ve-masif-parke", "temel-ve-bodrum-su-yalitimi", "mutfak-dolabi-ve-tezgahi"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "hizmetler", "hugai"],
    nearbyPriority: ["tuzla", "kartal", "sultanbeyli", "sancaktepe", "atasehir", "maltepe"]
  },
  "istanbul/basaksehir": {
    localIntro: "Başakşehir'de Kayaşehir'in yeni konutları, Başak Mahallesi'nin site yaşamı ve Bahçeşehir çevresindeki farklı konut tipleri ayrı uygulamalar gerektirir. Taşınma öncesi boya ve montaj, mutfak-banyo yenilemesi, elektrik düzenlemeleri ve balkon yalıtımı gibi işler için apartman yönetimi kuralları ve çalışma koşulları da planlamaya dahil edilmelidir. Hemen Ustam Gelsin, ihtiyacına uygun usta bulma sürecini kolaylaştırır.",
    demandNote: "Kayaşehir'de yeni daire montajı; Bahçeşehir ve Başak'ta mutfak-banyo yenileme, boya ve yalıtım işleri öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "dis-cephe-boya-ve-mantolama", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "mutfak-dolabi-ve-tezgahi", "banyo-dolabi-ve-vestiyer", "fayans-seramik-ve-kalebodur", "asma-tavan", "pvc-dograma", "laminat-lamine-ve-masif-parke"],
    faqTopics: ["usta-fiyatlari", "komisyon", "ilan-verme", "hugai"],
    nearbyPriority: ["esenyurt", "kucukcekmece", "bagcilar", "avcilar", "arnavutkoy", "beylikduzu"]
  },
  "izmir/konak": {
    localIntro: "Konak'ta Alsancak'ın eski apartmanları, Göztepe ve Güzelyalı'nın yerleşik konutlarıyla Kemeraltı çevresindeki ticari yapılar birbirinden farklı ustalıklar gerektirir. Tesisatın yenilenmesi, banyo seramikleri, iç cephe boyası ve dükkân düzenlemelerinde yapının mevcut durumu doğru değerlendirilmelidir. Hemen Ustam Gelsin ile evin veya iş yerin için gereken hizmeti belirterek ilgili ustalardan teklif isteyebilirsin.",
    demandNote: "Alsancak'ta daire ve iş yeri yenileme; Göztepe ile Güzelyalı'da banyo, boya ve tesisat işleri öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "fayans-seramik-ve-kalebodur", "anahtar-teslim-komple-tadilat", "mutfak-dolabi-ve-tezgahi", "laminat-lamine-ve-masif-parke", "asma-tavan", "dis-cephe-boya-ve-mantolama", "pvc-dograma"],
    faqTopics: ["usta-fiyatlari", "komisyon", "ilan-verme", "hizmetler"],
    nearbyPriority: ["bayrakli", "karabaglar", "balcova", "buca", "karsiyaka", "bornova"]
  },
  "izmir/karsiyaka": {
    localIntro: "Karşıyaka'da Bostanlı'nın apartmanları, Mavişehir'in site konutları ve Alaybey'in yerleşik yapı dokusu farklı yenileme seçenekleri sunar. Mutfak ve banyo dönüşümü, balkon su yalıtımı, pencere bakımı ve iç mekân dekorasyonu özellikle konut sahiplerinin değerlendirdiği işlerdir. Hemen Ustam Gelsin'de ihtiyacını ayrıntılı yazarak uygun ustalara ulaşabilir, işin kapsamına göre teklifleri karşılaştırabilirsin.",
    demandNote: "Mavişehir'de site dairesi yenileme; Bostanlı ve Alaybey'de banyo, mutfak, balkon yalıtımı ve boya işleri öne çıkar.",
    serviceFocus: ["anahtar-teslim-komple-tadilat", "mutfak-dolabi-ve-tezgahi", "banyo-dolabi-ve-vestiyer", "italyan-boya-ve-dekoratif-siva", "asma-tavan", "pvc-dograma", "fayans-seramik-ve-kalebodur", "temel-ve-bodrum-su-yalitimi", "laminat-lamine-ve-masif-parke", "ic-cephe-boya-ve-badana"],
    faqTopics: ["usta-fiyatlari", "hizmetler", "ilan-verme", "hugai"],
    nearbyPriority: ["bayrakli", "cigli", "bornova", "konak", "menemen", "kemalpasa"]
  },
  "izmir/bornova": {
    localIntro: "Bornova'da Kazımdirik'in apartmanları, Erzene'nin yerleşik mahalleleri ve Evka 3'ün konut alanları farklı bütçe ve kapsamda tadilat ihtiyacı doğurur. Kiracı değişiminde boya ve küçük onarımlar; uzun süre kullanılan dairelerde banyo, mutfak, zemin ve tesisat yenilemeleri gündeme gelir. Hemen Ustam Gelsin üzerinden işini net biçimde tanımlayarak uygun ustalardan teklif alabilirsin.",
    demandNote: "Kazımdirik ve Erzene'de kiracı öncesi boya ve tesisat; Evka 3'te banyo, mutfak ve daire yenileme işleri öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "mutfak-dolabi-ve-tezgahi", "anahtar-teslim-komple-tadilat", "fayans-seramik-ve-kalebodur", "laminat-lamine-ve-masif-parke", "pvc-dograma", "asma-tavan", "temel-ve-bodrum-su-yalitimi"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "komisyon", "hugai"],
    nearbyPriority: ["bayrakli", "karsiyaka", "konak", "buca", "kemalpasa", "cigli"]
  },
  "izmir/buca": {
    localIntro: "Buca'da Şirinyer'in hareketli yerleşimi, Adatepe'nin konutları ve İnönü Mahallesi çevresindeki apartmanlarda hem günlük onarımlar hem de kapsamlı yenilemeler yapılır. Taşınma öncesi boya, elektrik ve su tesisatı tamiri, seramik değişimi ve mutfak dolabı yenilemesi gibi işlerde kapsamı önceden belirlemek maliyet karşılaştırmasını kolaylaştırır. Hemen Ustam Gelsin ile ilgili ustalara ulaşabilirsin.",
    demandNote: "Şirinyer'de boya ve küçük onarımlar; Adatepe ve İnönü çevresinde banyo, mutfak ve tesisat işleri öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "fayans-seramik-ve-kalebodur", "mutfak-dolabi-ve-tezgahi", "anahtar-teslim-komple-tadilat", "laminat-lamine-ve-masif-parke", "pvc-dograma", "temel-ve-bodrum-su-yalitimi", "dis-cephe-boya-ve-mantolama"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "komisyon", "hizmetler"],
    nearbyPriority: ["konak", "karabaglar", "gaziemir", "bornova", "balcova", "torbali"]
  },
  "izmir/bayrakli": {
    localIntro: "Bayraklı'da Manavkuyu ve Mansuroğlu'nun yüksek katlı konutlarıyla Osmangazi'nin yerleşik apartmanları farklı bakım gereksinimleri taşır. Daire yenilemelerinde banyo ve mutfak düzenlemeleri, elektrik tesisatı, pencere bakımı ve su sızıntılarının giderilmesi öne çıkar. Hemen Ustam Gelsin'de yapılacak işi açıkça belirterek ilgili ustalardan teklif isteyebilir, kararını iş kapsamı üzerinden verebilirsin.",
    demandNote: "Manavkuyu ve Mansuroğlu'nda daire yenileme; Osmangazi'de tesisat, pencere, banyo ve boya onarımları öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "elektrik-tesisati", "sihhi-tesisat-ve-pis-su-tesisati", "mutfak-dolabi-ve-tezgahi", "banyo-dolabi-ve-vestiyer", "fayans-seramik-ve-kalebodur", "asma-tavan", "pvc-dograma", "temel-ve-bodrum-su-yalitimi", "laminat-lamine-ve-masif-parke"],
    faqTopics: ["usta-fiyatlari", "komisyon", "hizmetler", "hugai"],
    nearbyPriority: ["bornova", "karsiyaka", "konak", "cigli", "kemalpasa", "buca"]
  },
  "izmir/karabaglar": {
    localIntro: "Karabağlar'da Bozyaka, Esentepe ve Yeşilyurt çevresindeki yerleşik konutlarda eski yapıların bakımıyla daire içi yenilemeler birlikte görülür. Dış cephe ve çatı onarımı, su tesisatı, elektrik işleri ve banyo yenilemelerinde binanın yaşı ile mevcut malzeme durumu önemlidir. Hemen Ustam Gelsin üzerinden ihtiyacını tanımlayarak boya, tesisat, seramik ve yalıtım alanlarında çalışan ustalara ulaşabilirsin.",
    demandNote: "Bozyaka ve Esentepe'de eski daire yenileme; Yeşilyurt çevresinde boya, tesisat ve dış cephe bakımı öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "dis-cephe-boya-ve-mantolama", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "cati-yapimi-aktarma-ve-izolasyon", "fayans-seramik-ve-kalebodur", "pvc-dograma", "temel-ve-bodrum-su-yalitimi", "anahtar-teslim-komple-tadilat", "laminat-lamine-ve-masif-parke"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "komisyon", "hizmetler"],
    nearbyPriority: ["konak", "buca", "gaziemir", "balcova", "bornova", "torbali"]
  },
  "izmir/cesme": {
    localIntro: "Çeşme'de Alaçatı'nın taş evleri, Ilıca'nın yazlık konutları ve Dalyan çevresindeki villalar aynı bakım planına ihtiyaç duymaz. Sezon öncesinde havuz sistemleri, bahçe peyzajı ve sulama altyapısı kontrol edilirken dış cephe kaplamaları, çatı yalıtımı ve tesisat da deniz havası ile kullanım sıklığı dikkate alınarak ele alınmalıdır. Hemen Ustam Gelsin üzerinden ihtiyacına uygun ustalara ulaşabilirsin.",
    demandNote: "Alaçatı ve Ilıca'da sezon öncesi villa bakımı, havuz, peyzaj, sulama ve dış cephe yenilemesi öne çıkar.",
    serviceFocus: ["havuz-yapimi-ve-bakimi", "bahce-peyzaj-ve-cim-ekimi", "otomatik-sulama-sistemleri", "gunes-enerjisi-ve-termosifon", "dis-cephe-boya-ve-mantolama", "cati-yapimi-aktarma-ve-izolasyon", "elektrik-tesisati", "sihhi-tesisat-ve-pis-su-tesisati", "fayans-seramik-ve-kalebodur", "ic-cephe-boya-ve-badana"],
    faqTopics: ["usta-fiyatlari", "hizmetler", "ilan-verme", "hugai"],
    nearbyPriority: ["urla", "karaburun", "seferihisar", "guzelbahce", "konak", "menemen"]
  },
  "izmir/urla": {
    localIntro: "Urla'da İskele ve Zeytinalanı'nın konutlarıyla Kuşçular çevresindeki bahçeli evler, iç mekân tadilatından dış alan düzenlemesine kadar farklı uzmanlıklar gerektirir. Bahçe peyzajı, otomatik sulama ve havuz bakımının yanında çatı yalıtımı, dış cephe yenilemesi ve mutfak düzenlemeleri de planlanabilir. Hemen Ustam Gelsin ile işin ayrıntılarını paylaşarak uygun ustalardan teklif alabilirsin.",
    demandNote: "İskele ve Kuşçular çevresinde bahçeli ev bakımı, sulama, peyzaj, çatı yalıtımı ve villa tadilatı öne çıkar.",
    serviceFocus: ["bahce-peyzaj-ve-cim-ekimi", "otomatik-sulama-sistemleri", "yenilenebilir-enerji", "havuz-yapimi-ve-bakimi", "cati-yapimi-aktarma-ve-izolasyon", "dis-cephe-boya-ve-mantolama", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "mutfak-dolabi-ve-tezgahi", "fayans-seramik-ve-kalebodur"],
    faqTopics: ["usta-fiyatlari", "hizmetler", "ilan-verme", "komisyon"],
    nearbyPriority: ["cesme", "guzelbahce", "seferihisar", "konak", "karabaglar", "balcova"]
  },
  "izmir/balcova": {
    localIntro: "Balçova'da Teleferik çevresindeki konutlar, Eğitim Mahallesi'nin apartmanları ve Korutürk'teki yerleşimler farklı yenileme ihtiyaçları taşır. Banyo ve mutfak tadilatı, su sızıntılarının giderilmesi, balkon yalıtımı ve pencere bakımı apartmanlarda öne çıkarken bahçeli evlerde peyzaj düzenlemesi de gündeme gelir. Hemen Ustam Gelsin ile işin kapsamını anlatarak ilgili ustalardan teklif isteyebilirsin.",
    demandNote: "Teleferik ve Korutürk çevresinde banyo, mutfak, su yalıtımı ve tesisat işleri; bahçeli evlerde peyzaj öne çıkar.",
    serviceFocus: ["mutfak-dolabi-ve-tezgahi", "banyo-dolabi-ve-vestiyer", "anahtar-teslim-komple-tadilat", "fayans-seramik-ve-kalebodur", "sihhi-tesisat-ve-pis-su-tesisati", "temel-ve-bodrum-su-yalitimi", "ic-cephe-boya-ve-badana", "pvc-dograma", "bahce-peyzaj-ve-cim-ekimi", "elektrik-tesisati"],
    faqTopics: ["usta-fiyatlari", "komisyon", "ilan-verme", "hugai"],
    nearbyPriority: ["konak", "karabaglar", "guzelbahce", "urla", "buca", "gaziemir"]
  },
  "izmir/cigli": {
    localIntro: "Çiğli'de Ataşehir'in site konutları, Egekent'in yerleşim alanları ve Balatçık çevresindeki yeni projeler farklı aşamalarda usta ihtiyacı oluşturur. Yeni dairelerde boya, seramik ve montaj işleri; mevcut konutlarda PVC doğrama, tesisat, banyo yenileme ve dış cephe yalıtımı öne çıkar. Hemen Ustam Gelsin üzerinden işini tarif ederek ihtiyacına uygun ustalardan teklif alabilirsin.",
    demandNote: "Balatçık ve Egekent'te yeni daire ince işleri; Ataşehir'de banyo, tesisat, pencere ve boya yenilemesi öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "dis-cephe-boya-ve-mantolama", "pvc-dograma", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "fayans-seramik-ve-kalebodur", "mutfak-dolabi-ve-tezgahi", "anahtar-teslim-komple-tadilat", "cati-yapimi-aktarma-ve-izolasyon", "temel-ve-bodrum-su-yalitimi"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "komisyon", "hizmetler"],
    nearbyPriority: ["karsiyaka", "bayrakli", "bornova", "menemen", "konak", "kemalpasa"]
  },
  "ankara/cankaya": {
    localIntro: "Çankaya'da Oran ve Çukurambar'ın modern konutlarıyla Bahçelievler ve Ayrancı'nın yerleşik apartmanları farklı dekorasyon ve bakım kararları gerektirir. Özel ölçülü mutfaklar, banyo dönüşümleri, gömme dolaplar, aydınlatma ve dekoratif boya kapsamlı yenilemelerde öne çıkar. Hemen Ustam Gelsin ile projenin kapsamını anlatarak ilgili ustalardan teklif alabilir, uygulama seçeneklerini değerlendirebilirsin.",
    demandNote: "Oran ve Çukurambar'da modern dekorasyon ve özel imalat; Ayrancı ile Bahçelievler'de daire yenileme öne çıkar.",
    serviceFocus: ["anahtar-teslim-komple-tadilat", "mutfak-dolabi-ve-tezgahi", "banyo-dolabi-ve-vestiyer", "asma-tavan", "italyan-boya-ve-dekoratif-siva", "elektrik-tesisati", "laminat-lamine-ve-masif-parke", "fayans-seramik-ve-kalebodur", "ic-cephe-boya-ve-badana", "cam-balkon-ve-giyotin-cam"],
    faqTopics: ["usta-fiyatlari", "komisyon", "hugai", "ilan-verme"],
    nearbyPriority: ["yenimahalle", "golbasi", "etimesgut", "mamak", "altindag", "kecioren"]
  },
  "ankara/kecioren": {
    localIntro: "Keçiören'de Etlik'in yoğun apartmanları, Ovacık'ın gelişen konutları ve Ayvalı'nın yerleşik mahalleleri bakım ihtiyacını çeşitlendirir. Eski dairelerde elektrik ve su tesisatı, banyo ve zemin yenilemeleri; yeni konutlarda montaj, boya ve ince işler gündeme gelir. Hemen Ustam Gelsin üzerinden yapılacak işi net biçimde tarif ederek uygun ustalardan fiyat teklifi alabilirsin.",
    demandNote: "Etlik ve Ayvalı'da eski daire onarımları; Ovacık'ta yeni konut montajı, boya ve tesisat işleri öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "fayans-seramik-ve-kalebodur", "mutfak-dolabi-ve-tezgahi", "anahtar-teslim-komple-tadilat", "pvc-dograma", "dis-cephe-boya-ve-mantolama", "cati-yapimi-aktarma-ve-izolasyon", "laminat-lamine-ve-masif-parke"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "hizmetler", "komisyon"],
    nearbyPriority: ["altindag", "yenimahalle", "pursaklar", "mamak", "cankaya", "etimesgut"]
  },
  "ankara/etimesgut": {
    localIntro: "Etimesgut'ta Eryaman'ın site daireleri, Elvankent'in yerleşik konutları ve Bağlıca'nın gelişen yapılaşması farklı iş planları gerektirir. Taşınma öncesi boya, mutfak montajı ve zemin uygulamalarının yanı sıra tesisat, PVC doğrama ve banyo yenilemeleri de gündeme gelir. Hemen Ustam Gelsin'de yapılacak işi ve beklentini belirterek ihtiyacına uygun ustalara ulaşabilirsin.",
    demandNote: "Eryaman ve Elvankent'te daire yenileme ve montaj; Bağlıca'da yeni konut ince işleri ile tesisat öne çıkar.",
    serviceFocus: ["sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "pvc-dograma", "ic-cephe-boya-ve-badana", "mutfak-dolabi-ve-tezgahi", "fayans-seramik-ve-kalebodur", "laminat-lamine-ve-masif-parke", "dis-cephe-boya-ve-mantolama", "anahtar-teslim-komple-tadilat", "cati-yapimi-aktarma-ve-izolasyon"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "komisyon", "hugai"],
    nearbyPriority: ["sincan", "yenimahalle", "cankaya", "golbasi", "kecioren", "pursaklar"]
  },
  "ankara/mamak": {
    localIntro: "Mamak'ta Abidinpaşa'nın yerleşik apartmanları, Ege Mahallesi çevresindeki konutlar ve Natoyolu boyunca gelişen alanlar farklı bakım ihtiyaçları taşır. Çatı ve dış cephe onarımları, su tesisatı, elektrik arızaları ve banyo yenilemeleri özellikle eski yapılarda dikkatli planlama gerektirir. Hemen Ustam Gelsin üzerinden yapılacak işi açıklayarak uygun ustalardan teklif alabilir, onarım seçeneklerini karşılaştırabilirsin.",
    demandNote: "Abidinpaşa ve Ege çevresinde eski daire onarımı; Natoyolu'nda boya, tesisat, çatı ve dış cephe işleri öne çıkar.",
    serviceFocus: ["sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "ic-cephe-boya-ve-badana", "dis-cephe-boya-ve-mantolama", "cati-yapimi-aktarma-ve-izolasyon", "fayans-seramik-ve-kalebodur", "pvc-dograma", "temel-ve-bodrum-su-yalitimi", "anahtar-teslim-komple-tadilat", "laminat-lamine-ve-masif-parke"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "hizmetler", "komisyon"],
    nearbyPriority: ["altindag", "cankaya", "kecioren", "pursaklar", "golbasi", "yenimahalle"]
  },
  "ankara/yenimahalle": {
    localIntro: "Yenimahalle'de Batıkent'in planlı konut alanları, Demetevler'in apartmanları ve Ostim çevresindeki ticari yapılar farklı usta profilleri gerektirir. Evlerde mutfak-banyo yenileme ve tesisat; iş yerlerinde elektrik düzenlemesi, dayanıklı zeminler ve bölme duvar uygulamaları öne çıkar. Hemen Ustam Gelsin ile konut veya iş yeri için gereken işi tanımlayıp ilgili ustalardan teklif isteyebilirsin.",
    demandNote: "Batıkent'te site dairesi tadilatı; Demetevler'de tesisat ve boya, Ostim çevresinde iş yeri bakım işleri öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "pvc-dograma", "fayans-seramik-ve-kalebodur", "mutfak-dolabi-ve-tezgahi", "dis-cephe-boya-ve-mantolama", "cati-yapimi-aktarma-ve-izolasyon", "laminat-lamine-ve-masif-parke", "asma-tavan"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "komisyon", "hugai"],
    nearbyPriority: ["etimesgut", "kecioren", "altindag", "cankaya", "sincan", "pursaklar"]
  },
  "ankara/sincan": {
    localIntro: "Sincan'da Törekent'in yeni konutları, Fatih'in yerleşik mahalleleri ve Yenikent çevresindeki müstakil evler farklı bakım ihtiyaçları doğurur. Dairelerde boya, elektrik ve su tesisatı onarımları; müstakil yapılarda çatı aktarımı, pencere yenilemesi ve dış cephe yalıtımı gündeme gelir. Hemen Ustam Gelsin üzerinden işini tanımlayarak uygun ustalardan teklif alabilir, ihtiyaçlarını önceliklendirebilirsin.",
    demandNote: "Törekent'te yeni konut ince işleri; Fatih ve Yenikent çevresinde tesisat, çatı, PVC doğrama ve yalıtım öne çıkar.",
    serviceFocus: ["sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "pvc-dograma", "cati-yapimi-aktarma-ve-izolasyon", "dis-cephe-boya-ve-mantolama", "ic-cephe-boya-ve-badana", "temel-ve-bodrum-su-yalitimi", "fayans-seramik-ve-kalebodur", "mutfak-dolabi-ve-tezgahi", "laminat-lamine-ve-masif-parke"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "hizmetler", "komisyon"],
    nearbyPriority: ["etimesgut", "yenimahalle", "pursaklar", "kecioren", "altindag", "golbasi"]
  },
  "ankara/golbasi": {
    localIntro: "Gölbaşı'nda İncek'in villaları, Bahçelievler'in yerleşik konutları ve Tulumtaş çevresindeki bahçeli yapılar iç ve dış mekân işlerini birlikte gündeme getirebilir. Peyzaj, otomatik sulama ve havuz uygulamalarının yanı sıra çatı yalıtımı, dış cephe, mutfak yenileme ve elektrik altyapısı da proje kapsamına girebilir. Hemen Ustam Gelsin ile ihtiyacını ayrıntılı anlatarak ilgili ustalardan teklif alabilirsin.",
    demandNote: "İncek ve Tulumtaş'ta villa yenileme, bahçe peyzajı, havuz ve sulama; konutlarda çatı ve mutfak işleri öne çıkar.",
    serviceFocus: ["bahce-peyzaj-ve-cim-ekimi", "otomatik-sulama-sistemleri", "havuz-yapimi-ve-bakimi", "anahtar-teslim-komple-tadilat", "mutfak-dolabi-ve-tezgahi", "dis-cephe-boya-ve-mantolama", "cati-yapimi-aktarma-ve-izolasyon", "yenilenebilir-enerji", "elektrik-tesisati", "sihhi-tesisat-ve-pis-su-tesisati"],
    faqTopics: ["usta-fiyatlari", "hizmetler", "ilan-verme", "hugai"],
    nearbyPriority: ["cankaya", "mamak", "etimesgut", "altindag", "yenimahalle", "sincan"]
  },
  "ankara/pursaklar": {
    localIntro: "Pursaklar'da Saray'ın konut alanları, Merkez'in yerleşik mahalleleri ve Fatih çevresindeki apartmanlarda yeni montaj işleriyle mevcut yapıların bakımı birlikte görülür. Boya, pencere ve tesisat onarımları, çatı yenilemesi ve dış cephe yalıtımı için işin kapsamını önceden belirlemek hem fiyat tekliflerini hem de uygulama planını karşılaştırmayı kolaylaştırır. Hemen Ustam Gelsin üzerinden ilgili ustalara ulaşabilirsin.",
    demandNote: "Saray ve Fatih çevresinde konut montajı, PVC doğrama, tesisat, çatı aktarımı ve dış cephe yalıtımı öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "pvc-dograma", "cati-yapimi-aktarma-ve-izolasyon", "dis-cephe-boya-ve-mantolama", "fayans-seramik-ve-kalebodur", "temel-ve-bodrum-su-yalitimi", "mutfak-dolabi-ve-tezgahi", "laminat-lamine-ve-masif-parke"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "komisyon", "hizmetler"],
    nearbyPriority: ["altindag", "kecioren", "yenimahalle", "sincan", "etimesgut", "mamak"]
  },
  "ankara/altindag": {
    localIntro: "Altındağ'da Ulus ve Hamamönü'nün tarihî yapı dokusu, Aydınlıkevler'in yerleşik apartmanlarıyla farklı bakım kararları gerektirir. Eski yapılarda çatı, dış cephe, su ve elektrik tesisatı değerlendirilirken iç mekân yenilemesinin mevcut mimari özellikleri gözetmesi önemlidir. Hemen Ustam Gelsin üzerinden boya, seramik, tesisat ve çatı işlerini ayrı ayrı tanımlayarak uygun ustalardan teklif alabilirsin.",
    demandNote: "Ulus ve Hamamönü'nde eski yapıların dikkatli onarımı; Aydınlıkevler'de tesisat, boya ve banyo yenileme öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "dis-cephe-boya-ve-mantolama", "cati-yapimi-aktarma-ve-izolasyon", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "fayans-seramik-ve-kalebodur", "pvc-dograma", "temel-ve-bodrum-su-yalitimi", "anahtar-teslim-komple-tadilat", "laminat-lamine-ve-masif-parke"],
    faqTopics: ["usta-fiyatlari", "hizmetler", "ilan-verme", "komisyon"],
    nearbyPriority: ["cankaya", "kecioren", "mamak", "yenimahalle", "pursaklar", "golbasi"]
  },
  "antalya/muratpasa": {
    localIntro: "Muratpaşa'da Lara ve Fener'in konutları, Çağlayan'ın yerleşik mahalleleri ve şehir merkezindeki apartmanlar farklı bakım ihtiyaçları doğurur. Nem ve sıcaklık koşullarına uygun boya, balkon ve teras su yalıtımı, banyo yenileme, tesisat bakımı ve pencere onarımları özellikle önemlidir. Hemen Ustam Gelsin üzerinden yapılacak işi tarif ederek evin için uygun ustalardan teklif alabilirsin.",
    demandNote: "Lara ve Fener'de banyo, balkon yalıtımı ve daire yenileme; merkezde tesisat, boya ve pencere bakımı öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "fayans-seramik-ve-kalebodur", "anahtar-teslim-komple-tadilat", "pvc-dograma", "temel-ve-bodrum-su-yalitimi", "dis-cephe-boya-ve-mantolama", "mutfak-dolabi-ve-tezgahi", "laminat-lamine-ve-masif-parke"],
    faqTopics: ["usta-fiyatlari", "hizmetler", "ilan-verme", "komisyon"],
    nearbyPriority: ["konyaalti", "kepez", "aksu", "dosemealti", "serik", "manavgat"]
  },
  "antalya/konyaalti": {
    localIntro: "Konyaaltı'nda Liman ve Hurma'nın gelişen site konutlarıyla Gürsu'nun yerleşik apartmanlarında hem iç mekân hem dış alan uygulamaları gündeme gelir. Mutfak ve banyo yenilemesi, balkon yalıtımı ve pencere bakımı yanında bahçeli konutlarda peyzaj, sulama ve havuz bakımı da planlanabilir. Hemen Ustam Gelsin üzerinden işin ayrıntılarını paylaşarak ilgili ustalardan teklif isteyebilirsin.",
    demandNote: "Hurma ve Liman'da site dairesi yenileme; Gürsu'da banyo, balkon yalıtımı, boya ve dış alan işleri öne çıkar.",
    serviceFocus: ["anahtar-teslim-komple-tadilat", "mutfak-dolabi-ve-tezgahi", "banyo-dolabi-ve-vestiyer", "fayans-seramik-ve-kalebodur", "dis-cephe-boya-ve-mantolama", "temel-ve-bodrum-su-yalitimi", "bahce-peyzaj-ve-cim-ekimi", "otomatik-sulama-sistemleri", "elektrik-tesisati", "laminat-lamine-ve-masif-parke"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "hugai", "hizmetler"],
    nearbyPriority: ["muratpasa", "kepez", "dosemealti", "aksu", "serik", "manavgat"]
  },
  "antalya/kepez": {
    localIntro: "Kepez'de Varsak'ın gelişen yerleşimleri, Dokuma'nın köklü mahalleleri ve Şafak çevresindeki konutlar farklı bakım ihtiyaçları taşır. Su tesisatı ve elektrik arızaları, boya, PVC pencere değişimi, çatı onarımı ve dış cephe yalıtımı günlük konut bakımında öne çıkar. Hemen Ustam Gelsin ile işini net biçimde anlatarak uygun ustalara ulaşabilir ve teklifleri karşılaştırabilirsin.",
    demandNote: "Varsak'ta yeni konut işleri; Dokuma ve Şafak çevresinde tesisat, pencere, boya ve çatı onarımı öne çıkar.",
    serviceFocus: ["sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "pvc-dograma", "ic-cephe-boya-ve-badana", "dis-cephe-boya-ve-mantolama", "cati-yapimi-aktarma-ve-izolasyon", "fayans-seramik-ve-kalebodur", "temel-ve-bodrum-su-yalitimi", "anahtar-teslim-komple-tadilat", "mutfak-dolabi-ve-tezgahi"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "komisyon", "hizmetler"],
    nearbyPriority: ["muratpasa", "konyaalti", "aksu", "dosemealti", "serik", "manavgat"]
  },
  "antalya/alanya": {
    localIntro: "Alanya'da Mahmutlar ve Kestel'in apartman siteleriyle Oba'nın konutları ve villaları, yıl boyunca bakım ve sezon öncesi hazırlık ihtiyacı doğurur. Havuz ekipmanları, peyzaj, otomatik sulama ve güneş enerjisi uygulamaları dış alanlarda öne çıkarken dairelerde banyo, seramik, tesisat ve dış cephe yenilemeleri önemlidir. Hemen Ustam Gelsin ile ihtiyacına uygun ustaları bulma sürecini başlatabilirsin.",
    demandNote: "Mahmutlar ve Oba'da daire yenileme; villa ve tatil konutlarında havuz, peyzaj, sulama ve güneş enerjisi işleri öne çıkar.",
    serviceFocus: ["havuz-yapimi-ve-bakimi", "bahce-peyzaj-ve-cim-ekimi", "otomatik-sulama-sistemleri", "yenilenebilir-enerji", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "fayans-seramik-ve-kalebodur", "dis-cephe-boya-ve-mantolama", "anahtar-teslim-komple-tadilat", "pvc-dograma"],
    faqTopics: ["usta-fiyatlari", "hizmetler", "ilan-verme", "hugai"],
    nearbyPriority: ["manavgat", "gazipasa", "serik", "aksu", "muratpasa", "kepez"]
  },
  "antalya/manavgat": {
    localIntro: "Manavgat'ta Side ve Evrenseki çevresindeki turizm konutlarıyla Ilıca'nın yerleşimleri, sezonluk kullanım ve sürekli ikamet nedeniyle farklı bakım programları gerektirir. Havuz bakımı, peyzaj, sulama altyapısı ve dış cephe işleri turizm sezonu öncesinde planlanabilir; evlerde ise tesisat, banyo ve seramik yenilemeleri gündeme gelir. Hemen Ustam Gelsin ile yapılacak işi açıklayıp ilgili ustalardan teklif alabilirsin.",
    demandNote: "Side ve Evrenseki'de sezon öncesi havuz, peyzaj ve dış cephe bakımı; konutlarda tesisat ve banyo işleri öne çıkar.",
    serviceFocus: ["havuz-yapimi-ve-bakimi", "bahce-peyzaj-ve-cim-ekimi", "otomatik-sulama-sistemleri", "yenilenebilir-enerji", "dis-cephe-boya-ve-mantolama", "cati-yapimi-aktarma-ve-izolasyon", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "fayans-seramik-ve-kalebodur", "anahtar-teslim-komple-tadilat"],
    faqTopics: ["usta-fiyatlari", "hizmetler", "ilan-verme", "komisyon"],
    nearbyPriority: ["alanya", "serik", "aksu", "muratpasa", "kepez", "gazipasa"]
  },
  "manisa/yunusemre": {
    localIntro: "Yunusemre'de Uncubozköy ve Güzelyurt'un gelişen konutlarıyla Muradiye'nin farklı yerleşim dokusu yeni montajlardan mevcut evlerin bakımına kadar çeşitli ihtiyaçlar doğurur. Taşınma öncesi boya, mutfak montajı ve zemin işleri kadar tesisat yenilemesi, banyo tadilatı ve dış cephe yalıtımı da önemlidir. Hemen Ustam Gelsin ile ihtiyacını belirterek ilgili ustalardan teklif isteyebilirsin.",
    demandNote: "Uncubozköy ve Güzelyurt'ta daire dekorasyonu; Muradiye'de yeni konut işleri, tesisat ve dış cephe bakımı öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "dis-cephe-boya-ve-mantolama", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "mutfak-dolabi-ve-tezgahi", "fayans-seramik-ve-kalebodur", "laminat-lamine-ve-masif-parke", "pvc-dograma", "anahtar-teslim-komple-tadilat", "cati-yapimi-aktarma-ve-izolasyon"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "komisyon", "hugai"],
    nearbyPriority: ["sehzadeler", "turgutlu", "salihli", "akhisar", "soma", "alasehir"]
  },
  "manisa/sehzadeler": {
    localIntro: "Şehzadeler'de Yarhasanlar ve 1. Anafartalar çevresindeki şehir içi apartmanlarla Nurlupınar'ın yerleşik konutlarında bakım ve yenileme ihtiyaçları çeşitlilik gösterir. Eski yapılarda su ve elektrik tesisatı, banyo seramikleri ve çatı onarımı; daire içlerinde ise boya, zemin ve mutfak yenilemeleri öne çıkar. Hemen Ustam Gelsin üzerinden işin kapsamını belirterek uygun ustalardan teklif alabilirsin.",
    demandNote: "Yarhasanlar ve Nurlupınar'da eski daire yenileme, tesisat ve boya; apartmanlarda çatı ve dış cephe bakımı öne çıkar.",
    serviceFocus: ["ic-cephe-boya-ve-badana", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "fayans-seramik-ve-kalebodur", "anahtar-teslim-komple-tadilat", "cati-yapimi-aktarma-ve-izolasyon", "dis-cephe-boya-ve-mantolama", "pvc-dograma", "temel-ve-bodrum-su-yalitimi", "laminat-lamine-ve-masif-parke"],
    faqTopics: ["usta-fiyatlari", "hizmetler", "ilan-verme", "komisyon"],
    nearbyPriority: ["yunusemre", "turgutlu", "akhisar", "salihli", "soma", "alasehir"]
  },
  "manisa/akhisar": {
    localIntro: "Akhisar'da Ragıpbey ve Hürriyet'in şehir içi konutlarıyla Efendi Mahallesi çevresindeki farklı yapı tipleri, tadilat ve bakım ihtiyaçlarını çeşitlendirir. Müstakil evlerde çatı aktarımı ve dış cephe yenilemesi; apartmanlarda tesisat, boya, seramik ve banyo işleri öne çıkar. Hemen Ustam Gelsin üzerinden yapılacak işi tanımlayarak yerel ustalardan teklif alabilir, kararını kapsam ve maliyet üzerinden verebilirsin.",
    demandNote: "Ragıpbey ve Hürriyet'te daire yenileme; müstakil evlerde çatı, dış cephe, tesisat ve banyo işleri öne çıkar.",
    serviceFocus: ["cati-yapimi-aktarma-ve-izolasyon", "dis-cephe-boya-ve-mantolama", "sihhi-tesisat-ve-pis-su-tesisati", "ic-cephe-boya-ve-badana", "elektrik-tesisati", "fayans-seramik-ve-kalebodur", "pvc-dograma", "anahtar-teslim-komple-tadilat", "mutfak-dolabi-ve-tezgahi", "temel-ve-bodrum-su-yalitimi"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "hizmetler", "komisyon"],
    nearbyPriority: ["salihli", "sehzadeler", "yunusemre", "turgutlu", "soma", "alasehir"]
  },
  "manisa/salihli": {
    localIntro: "Salihli'de kalbin attığı yer Çınarlı Caddesi, yani herkesin bildiği Cafeler Caddesi. Lüks cafeler, restoranlar ve butik dükkanlar neredeyse her sezon iç mimari yeniliyor, cephe değiştiriyor, ışıklandırma ve dekorasyon yaptırıyor. Kurtuluş ve Barış Mahallesi tarafında ise Salihli'nin en lüks villaları var; havuz bakımı, bahçe peyzajı, otomatik sulama, dış cephe yenileme ve anahtar teslim tadilat sürekli talep görüyor. Merkezde Sağlık, Cumhuriyet, Aksoy ve Eski Cami mahallelerinde hem eski apartmanların tesisat, banyo ve mutfak yenilemesi hem de esnaf dükkanlarının komple tadilatı Hemen Ustam Gelsin üzerinden tek yerden çözülüyor.",
    demandNote: "Cafeler Caddesi'nde (Çınarlı) iç mimari ve iş yeri tadilatı; Kurtuluş ve Barış'ta lüks villa bakımı; Sağlık, Cumhuriyet, Aksoy ve Eski Cami'de daire ve dükkan yenileme öne çıkar.",
    serviceFocus: ["anahtar-teslim-komple-tadilat", "italyan-boya-ve-dekoratif-siva", "mutfak-dolabi-ve-tezgahi", "banyo-dolabi-ve-vestiyer", "asma-tavan", "fayans-seramik-ve-kalebodur", "bahce-peyzaj-ve-cim-ekimi", "havuz-yapimi-ve-bakimi", "elektrik-tesisati", "cam-balkon-ve-giyotin-cam"],
    faqTopics: ["usta-fiyatlari", "hizmetler", "hugai", "komisyon"],
    nearbyPriority: ["turgutlu", "akhisar", "alasehir", "sehzadeler", "yunusemre", "soma"]
  },
  "manisa/turgutlu": {
    localIntro: "Turgutlu'da Ergenekon ve Selvilitepe'nin konutlarıyla İstasyonaltı çevresindeki ticari ve yerleşim alanları farklı ustalıklar gerektirir. Eski binalarda çatı aktarımı, dış cephe mantolama ve tesisat yenilemesi; yeni dairelerde boya, seramik ve mutfak montajı öne çıkar. Hemen Ustam Gelsin ile işin kapsamını belirterek uygun ustalardan teklif alabilir, bakım ve yenileme seçeneklerini değerlendirebilirsin.",
    demandNote: "Ergenekon ve İstasyonaltı'nda çatı, mantolama ve tesisat; yeni dairelerde boya, seramik ve mutfak işleri öne çıkar.",
    serviceFocus: ["dis-cephe-boya-ve-mantolama", "cati-yapimi-aktarma-ve-izolasyon", "sihhi-tesisat-ve-pis-su-tesisati", "elektrik-tesisati", "ic-cephe-boya-ve-badana", "pvc-dograma", "fayans-seramik-ve-kalebodur", "temel-ve-bodrum-su-yalitimi", "mutfak-dolabi-ve-tezgahi", "laminat-lamine-ve-masif-parke"],
    faqTopics: ["usta-fiyatlari", "komisyon", "hugai", "ilan-verme"],
    nearbyPriority: ["yunusemre", "sehzadeler", "salihli", "akhisar", "soma", "alasehir"]
  },
  "manisa/soma": {
    localIntro: "Soma'da İnönü ve Atatürk mahalleleriyle Turgutalp çevresindeki konutlarda düzenli bakım, eski yapı onarımı ve enerji verimliliğini artırmaya yönelik uygulamalar önem taşır. Çatı ve dış cephe yalıtımı, su tesisatı, pencere bakımı ve iç cephe boyası özellikle değerlendirilmesi gereken işler arasındadır. Hemen Ustam Gelsin üzerinden ihtiyacını belirterek ilgili ustalardan teklif alabilirsin.",
    demandNote: "İnönü ve Turgutalp çevresinde çatı ve ısı yalıtımı, tesisat, pencere ve boya yenilemeleri öne çıkar.",
    serviceFocus: ["dis-cephe-boya-ve-mantolama", "cati-yapimi-aktarma-ve-izolasyon", "sihhi-tesisat-ve-pis-su-tesisati", "ic-cephe-boya-ve-badana", "elektrik-tesisati", "pvc-dograma", "fayans-seramik-ve-kalebodur", "temel-ve-bodrum-su-yalitimi", "anahtar-teslim-komple-tadilat", "laminat-lamine-ve-masif-parke"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "hizmetler", "komisyon"],
    nearbyPriority: ["akhisar", "sehzadeler", "yunusemre", "salihli", "turgutlu", "alasehir"]
  },
  "manisa/alasehir": {
    localIntro: "Alaşehir'de Kurtuluş ve Sakarya çevresindeki şehir içi konutlarla Ilıca çevresindeki farklı yerleşimler bakım ve yenileme ihtiyaçlarını çeşitlendirir. Çatı ve dış cephe onarımları, su tesisatı, boya ve banyo tadilatları evlerde öne çıkarken bahçeli yapılarda sulama altyapısı ve çevre düzenlemesi de planlanabilir. Hemen Ustam Gelsin üzerinden ihtiyacını tarif ederek ilgili ustalardan teklif isteyebilirsin.",
    demandNote: "Kurtuluş ve Ilıca çevresinde çatı, dış cephe ve tesisat onarımı; bahçeli konutlarda sulama ve peyzaj işleri öne çıkar.",
    serviceFocus: ["cati-yapimi-aktarma-ve-izolasyon", "dis-cephe-boya-ve-mantolama", "sihhi-tesisat-ve-pis-su-tesisati", "ic-cephe-boya-ve-badana", "elektrik-tesisati", "bahce-peyzaj-ve-cim-ekimi", "otomatik-sulama-sistemleri", "pvc-dograma", "fayans-seramik-ve-kalebodur", "temel-ve-bodrum-su-yalitimi"],
    faqTopics: ["usta-fiyatlari", "ilan-verme", "komisyon", "hizmetler"],
    nearbyPriority: ["salihli", "turgutlu", "akhisar", "sehzadeler", "yunusemre", "soma"]
  }
};