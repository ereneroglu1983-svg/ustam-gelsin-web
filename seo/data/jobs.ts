// data/jobs.ts

export type Job = {
  name: string;
  slug: string;
};

export const jobs: Job[] = [
  { name: "İç Cephe Boya ve Badana", slug: "ic-cephe-boya-ve-badana" },
  { name: "Dış Cephe Boya ve Mantolama", slug: "dis-cephe-boya-ve-mantolama" },
  { name: "Duvar Kağıdı ve Poster Uygulaması", slug: "duvar-kagidi-ve-poster-uygulamasi" },
  { name: "İtalyan Boya ve Dekoratif Sıva", slug: "italyan-boya-ve-dekoratif-siva" },
  { name: "Asma Tavan", slug: "asma-tavan" },
  { name: "Gergi Tavan Sistemleri", slug: "gergi-tavan-sistemleri" },
  { name: "Kartonpiyer, Stropiyer ve Çıtalama", slug: "kartonpiyer-stropiyer-ve-citalama" },
  { name: "Alçı Sıva ve Saten Alçı", slug: "alci-siva-ve-saten-alci" },
  { name: "Bölme Duvar (Alçıpan/Betoban/Cam)", slug: "bolme-duvar-alcipan-betoban-cam" },
  { name: "Fayans, Seramik ve Kalebodur", slug: "fayans-seramik-ve-kalebodur" },
  { name: "Laminat, Lamine ve Masif Parke", slug: "laminat-lamine-ve-masif-parke" },
  { name: "Mermer, Granit ve Traverten", slug: "mermer-granit-ve-traverten" },
  { name: "Epoksi Zemin Kaplama", slug: "epoksi-zemin-kaplama" },
  { name: "Sistre Cila İşleri", slug: "sistre-cila-isleri" },
  { name: "Sıhhi Tesisat ve Pis Su Tesisatı", slug: "sihhi-tesisat-ve-pis-su-tesisati" },
  { name: "Elektrik Tesisatı", slug: "elektrik-tesisati" },
  { name: "Doğalgaz Tesisatı ve Kombi Montajı/Bakımı", slug: "dogalgaz-tesisati-ve-kombi-montaji-bakimi" },
  { name: "Güneş Enerjisi ve Termosifon", slug: "gunes-enerjisi-ve-termosifon" },
  { name: "Yerden Isıtma Sistemleri", slug: "yerden-isitma-sistemleri" },
  { name: "Klima Montaj, Bakım ve Gaz Dolumu", slug: "klima-montaj-bakim-ve-gaz-dolumu" },
  { name: "PVC Doğrama", slug: "pvc-dograma" },
  { name: "Alüminyum Doğrama ve Cephe", slug: "aluminyum-dograma-ve-cephe" },
  { name: "Cam Balkon ve Giyotin Cam", slug: "cam-balkon-ve-giyotin-cam" },
  { name: "Oda Kapısı ve Çelik Kapı", slug: "oda-kapisi-ve-celik-kapi" },
  { name: "Sineklik ve Panjur Sistemleri", slug: "sineklik-ve-panjur-sistemleri" },
  { name: "Mutfak Dolabı ve Tezgahı", slug: "mutfak-dolabi-ve-tezgahi" },
  { name: "Banyo Dolabı ve Vestiyer", slug: "banyo-dolabi-ve-vestiyer" },
  { name: "Gömme Dolap ve Ray Dolap", slug: "gomme-dolap-ve-ray-dolap" },
  { name: "Marangozluk ve Mobilya Tamiri", slug: "marangozluk-ve-mobilya-tamiri" },
  { name: "Çatı Yapımı Aktarma ve İzolasyon", slug: "cati-yapimi-aktarma-ve-izalasyon" },
  { name: "Sandviç Panel ve Şıngıl Kaplama", slug: "sandvic-panel-ve-singil-kaplama" },
  { name: "Temel ve Bodrum Su Yalıtımı", slug: "temel-ve-bodrum-su-yalitimi" },
  { name: "Bahçe Peyzaj ve Çim Ekimi", slug: "bahce-peyzaj-ve-cim-ekimi" },
  { name: "Otomatik Sulama Sistemleri", slug: "otamatik-sulama-sistemleri" },
  { name: "Havuz Yapımı ve Bakımı", slug: "havuz-yapimi-ve-bakimi" },
  { name: "Ferforje Korkuluk ve Bahçe Kapısı", slug: "ferforje-korkuluk-ve-bahce-kapisi" },
  { name: "Konteyner, Bungalov ve Prefabrik", slug: "konteyner-bungalov-ve-prefabrik" },
  { name: "Uydu, İnternet ve Kamera Sistemleri", slug: "uydu-internet-ve-kamera-sitemleri" },
  { name: "Asansör Bakım ve Onarım", slug: "asansor-bakim-ve-onarim" },
  { name: "Anahtar Teslim Komple Tadilat", slug: "anahtar-teslim-komple-tadilat" },
  { name: "Çilingir", slug: "cilingir" },
  { name: "Temizlik Hizmetleri", slug: "temizlik-hizmetleri" },
  { name: "Yenilenebilir Enerji", slug: "yenilenebilir-enerji" },
];

export const jobSlugs = jobs.map(j => j.slug);
export const getJobBySlug = (slug: string) => jobs.find(j => j.slug === slug);