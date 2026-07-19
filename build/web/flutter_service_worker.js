'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "6941594e756409de797bfc11c39a2d3b",
"assets/AssetManifest.bin.json": "d2ed209e13929c36032c7ba2621a7ba8",
"assets/AssetManifest.json": "42e048d668495d11ca6eb895d320e090",
"assets/assets/3D_secure.png": "929645f29d76702b3049b29208c82750",
"assets/assets/app_logo.png": "0079053a64f430910d84ddd5db76877e",
"assets/assets/config/app_catalog.json": "eec65f3e3de375459f00d73d0f2d07d3",
"assets/assets/data/biz_kimiz.json": "acbb344992dd83faea10db61992c460e",
"assets/assets/data/firebase_fiyatlar/alci_siva.json": "70c012d7db98dd7fc84500fceb9875af",
"assets/assets/data/firebase_fiyatlar/aluminyum_cephe.json": "1acbb8793090b4e3a3510c3e31879c21",
"assets/assets/data/firebase_fiyatlar/asansor_servis.json": "314e2f5bb475cd773866d1bd0a6b1b04",
"assets/assets/data/firebase_fiyatlar/asma_tavan.json": "db31f27988bfdb67adf789524726e773",
"assets/assets/data/firebase_fiyatlar/bahce_peyzaj.json": "656ce1694f445925fdbe2c5ab75a426e",
"assets/assets/data/firebase_fiyatlar/banyo_vestiyer.json": "6eec5e9706b44e77baf0ace2aef41b33",
"assets/assets/data/firebase_fiyatlar/bina_temizlik_hesaplayici.json": "6859b5964a1946210b28e19ea3888499",
"assets/assets/data/firebase_fiyatlar/bolme_duvar.json": "95e9aa979d0788aab6188ef1a8bbfb08",
"assets/assets/data/firebase_fiyatlar/cam_balkon.json": "f475ac05ced4f090e747ab2db9ea7098",
"assets/assets/data/firebase_fiyatlar/cati_isleri.json": "6db452a6ce72b4019e0dd178400c49a3",
"assets/assets/data/firebase_fiyatlar/cilingir.json": "0a5bcbf928b95e8aa9cd720705096dcf",
"assets/assets/data/firebase_fiyatlar/dis_cephe.json": "9ff4d62711b647de4dd57f5f8a42b9e3",
"assets/assets/data/firebase_fiyatlar/dogalgaz_kombi.json": "304a2c6ff65478b5925e342c414f251b",
"assets/assets/data/firebase_fiyatlar/duvar_kagidi.json": "3b07d4449dd2f4e0a9450b9f0f83a2c2",
"assets/assets/data/firebase_fiyatlar/elektrikli_arac.json": "168d09603432e1da94413eec24ea60bf",
"assets/assets/data/firebase_fiyatlar/elektrik_tesisat.json": "d8c02c4bede9f7bcd9c0eedd71074d36",
"assets/assets/data/firebase_fiyatlar/enerji_depolama.json": "62fcf65d7e44e55b6455f5500e7b3ca8",
"assets/assets/data/firebase_fiyatlar/epoksi_zemin.json": "3b3eb7b637dde2486da1b210c8ab11c9",
"assets/assets/data/firebase_fiyatlar/fayans_seramik.json": "51e4fc79b5375e76256ab0bed3826478",
"assets/assets/data/firebase_fiyatlar/ferforje_metal.json": "88bccad9648413e7296115fab6097b0e",
"assets/assets/data/firebase_fiyatlar/gergi_tavan.json": "36d53fc2be262d5b2d6232dfc5f95df1",
"assets/assets/data/firebase_fiyatlar/ges.json": "1dac0d76f7ea0c0d8237c380848d8aad",
"assets/assets/data/firebase_fiyatlar/gomme_dolap.json": "cc3500089551a90aefdbf0751820259f",
"assets/assets/data/firebase_fiyatlar/gunes_enerjisi.json": "dddb5828d96b40322c8b768fd836741b",
"assets/assets/data/firebase_fiyatlar/havuz_sistemleri.json": "03bac3835188e1aade8656778b205b33",
"assets/assets/data/firebase_fiyatlar/ic_boya.json": "77790cd0efee1a98662a2d346f3011b7",
"assets/assets/data/firebase_fiyatlar/italyan_boya.json": "5db9851307b729391bc04294b584f23b",
"assets/assets/data/firebase_fiyatlar/kapi_sistemleri.json": "80a9bbc94c318e28531e0af7add5e9ab",
"assets/assets/data/firebase_fiyatlar/kartonpiyer.json": "975fea5c30c867356ce933fbe49d4285",
"assets/assets/data/firebase_fiyatlar/klima_servis.json": "16561c14e5e534b275c83bf12fcd9ef2",
"assets/assets/data/firebase_fiyatlar/komple_tadilat.json": "ecab72dfffe9518af53ca8257171e02b",
"assets/assets/data/firebase_fiyatlar/marangozluk.json": "9fe285f42e624634739dfe34d6ea9eca",
"assets/assets/data/firebase_fiyatlar/mermer_granit.json": "1120cf7600d7535c207f30b209124b79",
"assets/assets/data/firebase_fiyatlar/mutfak_dolabi.json": "b4cabeb7fb1009a1ca1385c41632c163",
"assets/assets/data/firebase_fiyatlar/off_grid_mobil_enerji.json": "c767e402c3739a7be2c1bdbb25a9d9a5",
"assets/assets/data/firebase_fiyatlar/otomatik_sulama.json": "4d0297dae286cde911599c8d3c6e8184",
"assets/assets/data/firebase_fiyatlar/panel_singil.json": "5658efc37a823ea9cef4429319115872",
"assets/assets/data/firebase_fiyatlar/parke_doseme.json": "3c884fcb1023d97a460086eeab1905f4",
"assets/assets/data/firebase_fiyatlar/prefabrik_yapi.json": "a0d4ed6b92d8f1c2519281b99b018074",
"assets/assets/data/firebase_fiyatlar/pvc_dograma.json": "bdc7a0ed4f9bf42d84bfa3a4de1fcc68",
"assets/assets/data/firebase_fiyatlar/res.json": "0dc6b719b2e91fc37e34ceaa4b2b99e6",
"assets/assets/data/firebase_fiyatlar/sihhi_tesisat.json": "9bd6547e61f6b9052f38e06cbd1795c1",
"assets/assets/data/firebase_fiyatlar/sineklik_panjur.json": "a5ad3efe541bc90834aab9370ace3abc",
"assets/assets/data/firebase_fiyatlar/sistre_cila.json": "68a20b413b27acdbc3ed0d741c5f32e0",
"assets/assets/data/firebase_fiyatlar/su_yalitimi.json": "8b37e48429ba55d84d41a2b964f55fb1",
"assets/assets/data/firebase_fiyatlar/temizlik_hizmetleri.json": "69edf4cc1a1e3cedb826319b03222ebc",
"assets/assets/data/firebase_fiyatlar/uydu_kamera.json": "5a11cd16c0057fdbda017112a8aeb233",
"assets/assets/data/ilceler.json": "dcfdac5d940b2ffd229a7d5b6fefdeef",
"assets/assets/data/is_kollari.json": "5c633a8dc4dc1037122349ab46283098",
"assets/assets/data/is_kolu_detaylari.json": "e90e6540190be74c90b936cb0f2df7ce",
"assets/assets/data/meslekler.json": "5a70068e560784442a6ee02fd607360d",
"assets/assets/data/musteri_sozlesme.json": "bf4e8a54490deccf6d2294c01dfa22ac",
"assets/assets/data/sehirler.json": "e3a4abcdf518580da3ee4b89816e883e",
"assets/assets/data/usta_sozlesme.json": "b705a178b0111df391ece16c8bc89dfa",
"assets/assets/data/yorumlar.json": "0c57fcbeda76d42fc639c0275b3d0e5c",
"assets/assets/facebook.png": "66269cebdf316d0281b2d1c5a7ab46fd",
"assets/assets/images/acil_logo.png": "0edd04e5a5eb54b3a015a9daa3b71c82",
"assets/assets/images/acil_usta_logo.png": "0edd04e5a5eb54b3a015a9daa3b71c82",
"assets/assets/images/ai_page.png": "838c2673a25699e50a496440928321f0",
"assets/assets/images/destek_iletisim.png": "e1265d374ea12558e09ff5fbec765bb5",
"assets/assets/images/nasil_calisir.png": "a29c4534b8e72885d4119895b96a29e2",
"assets/assets/images/usta_rozet.png": "32fe862af5efd993fd309e10ae6978f8",
"assets/assets/instagram.png": "ad1f04fb5523f79944629d55ec2d113d",
"assets/assets/iyzico.png": "6dc8df3b5214f4b1811b1e9aae953b3f",
"assets/assets/kesinti_yok.png": "402123efbe6f0c96db8e2dbe2dd269c8",
"assets/assets/kesinti_yok_2.png": "b44d209eb0615f0db12e5484e26de59b",
"assets/assets/linkedin.png": "67dfdb36367f1ec8996106c981bde9cb",
"assets/assets/master.png": "2a1417f2347e39968422653375c8682b",
"assets/assets/meslek_resimleri/alcisiva.png": "04d4b5a1abd492d093d28b00c99ac555",
"assets/assets/meslek_resimleri/aluminyum.png": "01d345bcb34b0ebec5f638da1d7a6628",
"assets/assets/meslek_resimleri/anahtar_teslim.png": "e5ddb8404c7cc607f99dbf6ec35166c5",
"assets/assets/meslek_resimleri/asansor.png": "9a55d07efd675337411193a85447047a",
"assets/assets/meslek_resimleri/asmatavan.png": "a6e5ea14a9fdbeab7346c79035336f56",
"assets/assets/meslek_resimleri/banyo.png": "66749361f596695b852e0289aef32088",
"assets/assets/meslek_resimleri/boya.png": "f4f9098dc1f130f5f54dce07b9bebfa7",
"assets/assets/meslek_resimleri/cambalkon.png": "b0018317842767ff5d633be6205eb475",
"assets/assets/meslek_resimleri/cambolme.png": "9ec36c08c4e02e68189f28d1c315850a",
"assets/assets/meslek_resimleri/camera.png": "a465b5875d3dbcb1f15049f6c8bf1478",
"assets/assets/meslek_resimleri/cati.png": "265ebf53f47346c744d0075c4d5d3d1f",
"assets/assets/meslek_resimleri/cilingir.png": "bba900e133a288db513cfdbf78904fcd",
"assets/assets/meslek_resimleri/dogalgaz.png": "e1903a7241c4729c37465cf995032c07",
"assets/assets/meslek_resimleri/duvarkagidi.png": "7991cc03ddad0c4ecccef26c9a961f9a",
"assets/assets/meslek_resimleri/elektrik.png": "01b8cf267cbba5baf1a60af431a5edbb",
"assets/assets/meslek_resimleri/epoksi.png": "a23092b8725e295d1f76c2a4146acc41",
"assets/assets/meslek_resimleri/ferforje.png": "f6b932cda9ad9b017b93c32e4d112d92",
"assets/assets/meslek_resimleri/gergitavan.png": "b3825f9ce6ba228aa70bff5f52e3a065",
"assets/assets/meslek_resimleri/gomme.png": "ec157e35e047d6e51b6a62157e46de9d",
"assets/assets/meslek_resimleri/gunes.png": "83715be076b2e0fc7f528428052eecb3",
"assets/assets/meslek_resimleri/havuz.png": "8fd30bb270166b7c245c667a7eedfa71",
"assets/assets/meslek_resimleri/italyan.png": "205f5150ccce4d523336b6688f0135f1",
"assets/assets/meslek_resimleri/kapi.png": "9dfe9c94578ae5238578ac188932313c",
"assets/assets/meslek_resimleri/kartonpiyer.png": "759785942a479b276b155e42f8d7e272",
"assets/assets/meslek_resimleri/klima.png": "fc1774d286a3c83a1f53d8502cc5eeb8",
"assets/assets/meslek_resimleri/laminat.png": "790dcea5f975d7b402ccbe7254673da9",
"assets/assets/meslek_resimleri/mantoloma.png": "7030a6eba3e7450abf5193b7ac4e5353",
"assets/assets/meslek_resimleri/marangoz.png": "a23c142f47a3ce7f18802082f6174262",
"assets/assets/meslek_resimleri/mermer.png": "38530730ad1a1da8f0bd6af85b941cdb",
"assets/assets/meslek_resimleri/mutfak.png": "c183a609c4e870234a5248a8deb365cd",
"assets/assets/meslek_resimleri/panjur.png": "6abc5d0db5782fc7719498fdef82ba5e",
"assets/assets/meslek_resimleri/peyzaj.png": "107e8190af291b0b6016a8458f818618",
"assets/assets/meslek_resimleri/prefabrik.png": "d481a868de51482b8dcc1b698e017a1a",
"assets/assets/meslek_resimleri/pvc.png": "bb28760b544bfef847f2e696b4c01114",
"assets/assets/meslek_resimleri/sandvic.png": "5375c640cccc812fe9d4ed04b543773f",
"assets/assets/meslek_resimleri/seramik.png": "3b2c347bd4d420a4057fd67019806f45",
"assets/assets/meslek_resimleri/sihhi.png": "a5e113b0463ae3745bd180410504eb4a",
"assets/assets/meslek_resimleri/sistre.png": "cc338363b25f0ad26905aab7af2833b4",
"assets/assets/meslek_resimleri/sulama.png": "e14981df0c09e70d017b412a0f7cd614",
"assets/assets/meslek_resimleri/temel.png": "495b95c2b6600f0819b73c41ebc21853",
"assets/assets/meslek_resimleri/temizlik.png": "189a3350764d84cd6c6c1c7aaaae4f20",
"assets/assets/meslek_resimleri/yenilenebilir_enerji.png": "86468a5b701bc616955298ff68e7be83",
"assets/assets/meslek_resimleri/yerdenisitma.png": "f1de4df517cc357008001b595d104baf",
"assets/assets/tiktok.png": "266c1e57260c6cdfd71c2fcfcaf00047",
"assets/assets/troy.png": "3b2f8561e28e28bbbe61e4b8e08f6ec3",
"assets/assets/usta.png": "69ca782134ef8a5cf6f7d3a037423e56",
"assets/assets/usta_register.png": "c0b7d8067490ddb1b8f30d1547ab829a",
"assets/assets/visa.png": "9a53800e27019783278798f5bbd6101a",
"assets/assets/web_logo.png": "ec6df28c93be998b593a5652a6193944",
"assets/assets/x.png": "0c58658f8706f9bd6dadc496fbc0ffcb",
"assets/assets/youtube.png": "6f386e3b9422637067a36041d284db98",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "3304b6d4c1414332c1671c39f86db78d",
"assets/NOTICES": "39291b5acb6181713994498a9526430f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/flutter_inappwebview_web/assets/web/web_support.js": "509ae636cfdd93e49b5a6eaf0f06d79f",
"assets/packages/youtube_player_iframe/assets/player.html": "663ba81294a9f52b1afe96815bb6ecf9",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "f1368b915c7f2f2fde7a4e21a1cf9cbe",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "c762b7d58ccbf04662f1831ccd2cf7cc",
"/": "c762b7d58ccbf04662f1831ccd2cf7cc",
"main.dart.js": "1df4b998329b8e54f442496e35c0bdd9",
"manifest.json": "a7d59e559ae293f944fc51247845f0a5",
"splash/img/dark-1x.png": "5d4cfe7660b44d785a7a675f750a3262",
"splash/img/dark-2x.png": "3483c36c6e3bce665d8e7efa252180fb",
"splash/img/dark-3x.png": "9c9b24ff1e38909fc396d37ea4b855b5",
"splash/img/dark-4x.png": "5350e20deafc56c3b9dee90ec2e67683",
"splash/img/light-1x.png": "5d4cfe7660b44d785a7a675f750a3262",
"splash/img/light-2x.png": "3483c36c6e3bce665d8e7efa252180fb",
"splash/img/light-3x.png": "9c9b24ff1e38909fc396d37ea4b855b5",
"splash/img/light-4x.png": "5350e20deafc56c3b9dee90ec2e67683",
"version.json": "abccd82a43cb99dec0f8355cbda53a87",
"_redirects": "efcb9ebacb36cba426b97251509f4ccb"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
