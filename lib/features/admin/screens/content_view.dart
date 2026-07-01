// lib/features/admin/screens/content_view.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContentView extends StatelessWidget {
  const ContentView({super.key});

  final Color primaryRed = const Color(0xFFDC143C);
  final Color cardBg = const Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeader("GENEL AYARLAR"),
        _contentTile("Kategori Düzenle", "Branş ve Hizmet Yönetimi", Icons.category, context, () => _showCategoryEditor(context)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionHeader("SÖZLEŞMELER (JSON YÖNETİMİ)"),
            IconButton(
              icon: const Icon(Icons.cloud_upload, color: Colors.white38, size: 20),
              onPressed: () => sozlesmeleriFirebaseYukle(context),
            )
          ],
        ),
        _contentTile("Müşteri Sözleşmesi", "İçerik ve KVKK Düzenleme", Icons.person_outline, context, () => _showContractEditor(context, 'musteri_sozlesme', 'Müşteri Sözleşmesi')),
        _contentTile("Usta Sözleşmesi", "Hizmet Şartları Düzenleme", Icons.engineering, context, () => _showContractEditor(context, 'usta_sozlesme', 'Usta Sözleşmesi')),
      ],
    );
  }

  Future<void> sozlesmeleriFirebaseYukle(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('config').doc('musteri_sozlesme').set({
        'metin': "HEMEN USTAM GELSİN\nKULLANICI SÖZLEŞMESİ, KİŞİSEL VERİLERİN İŞLENMESİNE İLİŞKİN AYDINLATMA METNİ VE AÇIK RIZA BEYANI\n\n1. TARAFLAR\nİşbu Kullanıcı Sözleşmesi; HEMEN USTAM GELSİN mobil uygulaması, internet sitesi ve bağlı dijital hizmetlerini kullanan gerçek veya tüzel kişi ile platformun işletmecisi arasında elektronik ortamda kurulmaktadır.\n\nKullanıcı; uygulamaya kayıt olarak, giriş yaparak, teklif göndererek, ilan oluşturarak, cüzdanına bakiye yükleyerek veya platformu herhangi bir şekilde kullanarak işbu sözleşmenin tamamını okuduğunu, anladığını ve kabul ettiğini beyan eder.\n\n2. PLATFORMUN NİTELİĞİ VE HİZMET TANIMI\nHEMEN USTAM GELSİN; tadilat, tamirat, inşaat, teknik servis ve benzeri alanlarda hizmet almak isteyen kişiler ile ilgili alanlarda hizmet sunan ustaları bir araya getiren dijital ilan, teklif ve aracılık platformudur.\n\nPlatform doğrudan hizmet sağlayıcısı değildir, müteahhit değildir, taşeron değildir, işveren değildir ve taraflar arasındaki sözleşmenin tarafı değildir.\n\nPlatform yalnızca ilan yayınlanmasını, teklif gönderilmesini, kullanıcıların eşleştirilmesini, dijital iletişim kurulmasını ve platform içi bakiye ile cüzdan kullanımını sağlayan dijital aracılık hizmeti sunmaktadır.\n\n3. ÜYELİK VE HESAP SORUMLULUĞU\nKullanıcı; kayıt sırasında verdiği tüm bilgilerin doğru olduğunu, hesabının güvenliğinden kendisinin sorumlu olduğunu, şifre ve SMS doğrulama kodlarını koruyacağını ve hesabı üzerinden yapılan işlemlerin kendisine ait sayılacağını kabul eder.\n\n4. CÜZDAN VE BAKİYE SİSTEMİ\nPlatform içerisinde kullanılmak üzere kullanıcılar tarafından dijital bakiye ve cüzdan yüklemesi yapılabilir.\n\nYüklenen bakiyeler yalnızca platform hizmetlerinde kullanılabilir. Nakit para, banka hesabı veya yatırım aracı niteliğinde değildir.\n\nPlatform içi bakiye teklif gönderme, ilan erişimi, iletişim hakkı satın alma ve platform komisyon ödemeleri amacıyla kullanılabilir.\n\n5. ÖDEME VE KOMİSYON SİSTEMİ\nPlatform üzerinde gerçekleştirilen ödemeler banka sanal POS sistemleri, ödeme kuruluşları, banka kartı, kredi kartı, havale ve EFT yöntemleriyle gerçekleştirilebilir.\n\nKullanıcı; ödeme işlemlerinin üçüncü taraf ödeme altyapıları aracılığıyla gerçekleştirildiğini kabul eder.\n\nPlatform; teklif gönderme, iletişim kurma, ilan erişimi sağlama ve platform özelliklerinden yararlanma işlemleri için belirli oranlarda komisyon veya hizmet bedeli tahsil edebilir.\n\n6. TEKLİF GÖNDERİMİ VE HİZMET KULLANIMI\nKullanıcı tarafından teklif gönderilmesi, iletişim hakkının kullanılması, müşteri bilgilerinin görüntülenmesi veya platform hizmetinin aktif kullanılması halinde ilgili dijital hizmetin sunulduğu kabul edilir.\n\nBu işlemler sonrasında kullanılan komisyon, teklif hakkı veya bakiye kullanılmış dijital hizmet kapsamında değerlendirilir.\n\n7. İADE VE İPTAL KOŞULLARI\nPlatform üzerinde kullanılan teklif gönderim hakları, iletişim hakları, görüntüleme hakları ve platform kullanım hakları dijital hizmet niteliğinde olup kullanıldıktan sonra iade edilmeyebilir.\n\nKullanıcı, platform hizmetini kullanmasıyla birlikte dijital hizmetin ifa edildiğini kabul eder.\n\n8. SORUMLULUK REDDİ\nPlatform; kullanıcılar arasında kurulan ilişkilerin tarafı değildir, verilen hizmetlerin kalitesini garanti etmez ve taraflar arasındaki ödeme, anlaşmazlık veya uyuşmazlıklardan sorumlu tutulamaz.\n\nUsta ile müşteri arasında kurulacak her türlü hukuki, ticari ve fiili ilişki tarafların kendi sorumluluğundadır.\n\n9. YASAKLI KULLANIMLAR\nKullanıcı; sahte hesap oluşturamaz, başkasına ait kart kullanamaz, yanıltıcı ilan yayınlayamaz, hukuka aykırı içerik paylaşamaz ve platform güvenliğini ihlal edemez.\n\nPlatform gerekli gördüğü durumlarda hesabı askıya alma veya üyeliği sonlandırma hakkını saklı tutar.\n\n10. KİŞİSEL VERİLERİN İŞLENMESİNE İLİŞKİN AYDINLATMA METNİ\n6698 sayılı Kişisel Verilerin Korunması Kanunu kapsamında kullanıcıların kişisel verileri hukuka uygun şekilde işlenmektedir.\n\nİşlenen veriler; ad-soyad, telefon numarası, e-posta adresi, konum bilgisi, IP adresi, cihaz bilgisi, işlem kayıtları, teklif hareketleri, ödeme hareketleri ve uygulama kullanım kayıtlarını içerebilir.\n\nKişisel veriler; kullanıcı hesabı oluşturulması, teklif süreçlerinin yürütülmesi, kullanıcı eşleştirmesi, ödeme işlemlerinin yürütülmesi, güvenlik süreçleri ve teknik sistem güvenliğinin sağlanması amacıyla işlenebilir.\n\n11. KİŞİSEL VERİLERİN PAYLAŞILMASINA İLİŞKİN AÇIK RIZA BEYANI\nKullanıcı; ad-soyad, telefon numarası, konum bilgisi, ilan detayları, iş bilgileri ve teklif bilgilerinin ilgili müşteri, ilgili usta, ödeme kuruluşları ve teknik altyapı sağlayıcıları ile paylaşılmasına açık rıza verdiğini kabul eder.\n\nKullanıcı ayrıca IP kayıtlarının, cihaz bilgilerinin, işlem zaman kayıtlarının ve teklif ile ödeme hareketlerinin güvenlik, sahteciliğin önlenmesi ve hukuki uyuşmazlıkların çözümü amacıyla kayıt altına alınabileceğini kabul eder.\n\n12. ELEKTRONİK KAYITLARIN DELİL NİTELİĞİ\nKullanıcı; sistem kayıtlarının, log kayıtlarının, IP kayıtlarının, ödeme kayıtlarının, cihaz kayıtlarının, mesajlaşma kayıtlarının ve işlem geçmişinin hukuki uyuşmazlıklarda delil niteliği taşıyacağını kabul eder.\n\n13. SÖZLEŞME DEĞİŞİKLİKLERİ\nPlatform işleticisi gerekli gördüğü durumlarda işbu sözleşmede değişiklik yapabilir.\n\n14. YETKİLİ MAHKEME VE UYGULANACAK HUKUK\nİşbu sözleşmede Türkiye Cumhuriyeti hukuku uygulanır.\n\n15. YÜRÜRLÜK\nKullanıcı, platforma kayıt olması veya platformu kullanmasıyla birlikte işbu sözleşmenin tamamını okuyup kabul ettiğini beyan eder.",
        'guncelleme_tarihi': Timestamp.now(),
      }, SetOptions(merge: true));

      await firestore.collection('config').doc('usta_sozlesme').set({
        'metin': "HEMEN USTAM GELSİN\nUSTA / HİZMET SAĞLAYICI ÜYELİK SÖZLEŞMESİ\n\nSon Güncelleme Tarihi: 05.06.2026\n\nMADDE 1 – TARAFLAR\nİşbu Sözleşme; HEMEN USTAM GELSİN mobil uygulaması ve internet platformuna üye olan hizmet sağlayıcı gerçek veya tüzel kişi ile platformun işletmecisi arasında elektronik ortamda kurulmaktadır.\n\nUsta; platforma kayıt olarak, giriş yaparak, teklif göndererek, cüzdanına bakiye yükleyerek veya platformu herhangi bir şekilde kullanarak işbu sözleşmenin tamamını okuyup kabul ettiğini beyan eder.\n\nMADDE 2 – PLATFORMUN NİTELİĞİ\nHEMEN USTAM GELSİN yalnızca hizmet almak isteyen müşteriler ile hizmet sunan ustaları bir araya getiren dijital aracılık, ilan ve teklif platformudur.\n\nPlatform işveren değildir, müteahhit değildir, taşeron değildir, hizmet sağlayıcısı değildir ve taraflar arasındaki hukuki ilişkinin tarafı değildir.\n\nPlatform yalnızca kullanıcı eşleştirmesi, ilan yayınlanması, teklif gönderimi ve iletişim kurulmasına aracılık eden dijital altyapıyı sağlamaktadır.\n\nMADDE 3 – USTANIN BAĞIMSIZLIĞI\nUsta, platform üzerinde tamamen bağımsız hareket eden bir hizmet sağlayıcıdır.\n\nUsta ile müşteri arasındaki fiyat, ödeme, iş süresi, iş kalitesi, garanti, teslim, iş güvenliği, işçilik ve malzeme dahil tüm süreçlerden münhasıran Usta sorumludur.\n\nPlatform ile Usta arasında herhangi bir işçi-işveren, acentelik, franchise, ortaklık veya temsil ilişkisi bulunmamaktadır.\n\nMADDE 4 – MESLEKİ VE YASAL YÜKÜMLÜLÜKLER\nUsta; faaliyetleri için gerekli tüm izin, ruhsat, ustalık belgesi, yetki belgesi, vergi kaydı, SGK yükümlülüğü, iş sağlığı ve güvenliği yükümlülükleri ile ilgili tüm yasal sorumlulukları yerine getirmekle yükümlüdür.\n\nUsta, yürürlükteki tüm mevzuata uygun hareket edeceğini kabul eder.\n\nMADDE 5 – HİZMET KALİTESİ VE GARANTİ\nPlatform, Usta tarafından sunulan hizmetlerin kalitesi, doğruluğu, güvenliği, süresi, hukuka uygunluğu ve garanti kapsamı konusunda hiçbir taahhüt veya garanti vermez.\n\nMüşteri ile Usta arasında doğabilecek hiçbir uyuşmazlıktan platform sorumlu tutulamaz.\n\nMADDE 6 – KOMİSYON, CÜZDAN VE TEKLİF SİSTEMİ\nPlatform üzerinde teklif gönderebilmek, müşteri iletişim bilgilerine erişebilmek veya belirli platform özelliklerinden yararlanabilmek için Usta tarafından platform cüzdanına bakiye yüklenmesi gerekebilir.\n\nYüklenen bakiyeler yalnızca platform içerisinde kullanılabilir. Nakit para niteliğinde değildir, banka hesabı değildir, faiz işletilmez ve yatırım aracı değildir.\n\nPlatform; teklif gönderimi, iletişim hakkı, ilan erişimi veya platform kullanımı karşılığında belirli oranlarda komisyon, kullanım bedeli veya hizmet bedeli tahsil edebilir.\n\nKomisyon ve kullanım ücretleri uygulama içerisinde açık şekilde gösterilir.\n\nMADDE 7 – ÖDEME, İADE VE DİJİTAL HİZMET KULLANIMI\nPlatform üzerinde gerçekleştirilen ödemeler banka sanal POS sistemleri, ödeme kuruluşları, banka kartı, kredi kartı, havale veya EFT yöntemleriyle gerçekleştirilebilir.\n\nUsta tarafından teklif gönderilmesi, müşteri iletişim bilgilerinin görüntülenmesi, platform özelliklerinin kullanılması veya dijital erişim hakkının kullanılması halinde ilgili dijital hizmetin sunulduğu kabul edilir.\n\nKullanılmış teklif hakları, iletişim hakları, komisyon kullanımları ve dijital platform hizmetleri kullanıldıktan sonra iade edilmeyebilir.\n\nPlatform; teknik hata, mükerrer tahsilat veya açık şekilde ispatlanabilen sistemsel hata halleri dışında iade yapma zorunluluğu altında değildir.\n\nMADDE 8 – SAHTE İŞLEM VE GÜVENLİK\nPlatform; sahte hesap, başkasına ait kart kullanımı, chargeback riski, dolandırıcılık şüphesi, sistem manipülasyonu ve spam faaliyetleri gibi durullarda hesabı askıya alma, bakiyeyi incelemeye alma veya üyeliği sonlandırma hakkını saklı tutar.\n\nPlatform gerekli gördüğü durumlarda işlem kayıtlarını ilgili resmi mercilerle paylaşabilir.\n\nMADDE 9 – İŞ KAZALARI VE ÜÇÜNCÜ KİŞİ ZARARLARI\nUsta’nın faaliyetleri sırasında meydana gelebilecek iş kazası, yaralanma, ölüm, meslek hastalığı, mal kaybı veya üçüncü kişilere verilecek zararlar gibi tüm durumlardan münhasıran Usta sorumludur.\n\nPlatform bu tür olaylardan hiçbir şekilde sorumlu tutulamaz.\n\nMADDE 10 – SİGORTA YÜKÜMLÜLÜKLERİ\nUsta, gerekli tüm mesleki sorumluluk sigortaları ve ilgili sigortaları yaptırmakla yükümlüdür.\n\nMADDE 11 – KİŞİSEL VERİLERİN KULLANIMI\nUsta; müşteri verilerini yalnızca hizmet amacıyla kullanacağını, üçüncü kişilerle hukuka aykırı şekilde paylaşmayacağını ve KVKK kapsamında gerekli yükümlülüklere uyacağını kabul eder.\n\nMADDE 12 – ELEKTRONİK KAYITLAR VE DELİL SÖZLEŞMESİ\nPlatform sistem kayıtları; IP kayıtları, cihaz kayıtları, ödeme kayıtları, teklif hareketleri, mesajlaşma kayıtları, işlem geçmişi ve zaman damgaları dahil olmak üzere hukuki uyuşmazlıklarda delil niteliğindedir.\n\nUsta, platform kayıtlarının münhasır delil niteliğinde sayılabileceğini kabul eder.\n\nMADDE 13 – HESABIN ASKIYA ALINMASI VE SONLANDIRILMASI\nPlatform; güvenlik, şikayet, sahte işlem şüphesi, ticari risk, sistem bütünlüğü veya hukuki nedenlerle hesap askıya alma veya tamamen kapatma hakkını saklı tutar.\n\nMADDE 14 – SORUMLULUK SINIRLAMASI\nPlatform İşleticisinin toplam sorumluluğu hiçbir durumda dolaylı zararlar, gelir kaybı, iş kaybı veya üçüncü kişi zararları dahil olmak üzere Usta tarafından platforma son 12 ay içerisinde ödenen toplam komisyon bedelini aşamaz.\n\nMADDE 15 – UYGULANACAK HUKUK VE YETKİ\nİşbu sözleşmeye Türkiye Cumhuriyeti hukuku uygulanır.\n\nUyuşmazlıklarda Salihli Mahkemeleri ve İcra Daireleri yetkilidir.\n\nMADDE 16 – KABUL BEYANI\nUsta, işbu sözleşmenin tamamını okuduğunu, anladığını ve özgür iradesiyle kabul ettiğini beyan eder.",
        'guncelleme_tarihi': Timestamp.now(),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sözleşmeler Firebase'e başarıyla yüklendi!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata oluştu: $e")));
    }
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8),
      child: Text(title, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }

  Widget _contentTile(String title, String sub, IconData icon, BuildContext context, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        leading: Icon(icon, color: primaryRed, size: 20),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        subtitle: Text(sub, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
        onTap: onTap,
      ),
    );
  }

  void _showContractEditor(BuildContext context, String docId, String title) {
    final docRef = FirebaseFirestore.instance.collection('config').doc(docId);
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<DocumentSnapshot>(
          future: docRef.get(),
          builder: (context, snapshot) {
            final data = snapshot.hasData && snapshot.data!.exists ? snapshot.data!.data() as Map<String, dynamic>? : null;
            final TextEditingController textController = TextEditingController(
                text: data?['metin'] ?? ""
            );
            return AlertDialog(
              backgroundColor: cardBg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: primaryRed)),
              title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: 400,
                height: 300,
                child: TextField(
                  controller: textController,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: Colors.black26),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("KAPAT", style: TextStyle(color: Colors.white54, fontSize: 12))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
                  onPressed: () {
                    docRef.set({
                      'metin': textController.text,
                      'guncelleme_tarihi': Timestamp.now(),
                    }, SetOptions(merge: true));
                    Navigator.pop(context);
                  },
                  child: const Text("KAYDET", style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCategoryEditor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController catController = TextEditingController();
        return AlertDialog(
          backgroundColor: cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: primaryRed)),
          title: const Text("KATEGORİ YÖNETİMİ", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: catController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Yeni Kategori...",
                    hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('config').doc('kategoriler').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || !snapshot.data!.exists) return const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2));
                      var data = snapshot.data!.data() as Map<String, dynamic>?;
                      var list = List<String>.from(data?['liste'] ?? []);
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, i) => ListTile(
                          dense: true,
                          title: Text(list[i], style: const TextStyle(color: Colors.white, fontSize: 12)),
                          trailing: IconButton(icon: Icon(Icons.delete, color: primaryRed, size: 16), onPressed: () {
                            list.removeAt(i);
                            FirebaseFirestore.instance.collection('config').doc('kategoriler').update({'liste': list});
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("KAPAT", style: TextStyle(color: Colors.white54, fontSize: 12))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryRed, padding: const EdgeInsets.symmetric(horizontal: 16)),
              onPressed: () {
                if(catController.text.isNotEmpty) {
                  FirebaseFirestore.instance.collection('config').doc('kategoriler').set({
                    'liste': FieldValue.arrayUnion([catController.text])
                  }, SetOptions(merge: true));
                  catController.clear();
                }
              },
              child: const Text("EKLE", style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        );
      },
    );
  }
}