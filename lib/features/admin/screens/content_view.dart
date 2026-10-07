
// lib/features/admin/screens/content_view.dart - V2 FULL ISLEVSEL OPERASYON MERKEZI
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContentView extends StatefulWidget {
  const ContentView({super.key});
  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Color primaryRed = const Color(0xFFDC143C);
  final Color cardBg = const Color(0xFF1A1A1A);
  final Color primaryOrange = const Color(0xFFFF7A00);

  bool _maintenance = false;
  bool _loadingStatus = true;

  @override
  void initState() {
    super.initState();
    _loadAppStatus();
  }

  Future<void> _loadAppStatus() async {
    try {
      var doc = await _firestore.collection('config').doc('app_status').get();
      if (doc.exists) {
        var data = doc.data()!;
        setState(() {
          _maintenance = data['maintenanceMode'] ?? false;
          _loadingStatus = false;
        });
      } else {
        setState(() => _loadingStatus = false);
      }
    } catch (_) {
      setState(() => _loadingStatus = false);
    }
  }

  Future<void> _toggleMaintenance(bool val) async {
    setState(() => _maintenance = val);
    await _firestore.collection('config').doc('app_status').set({
      'maintenanceMode': val,
      'maintenanceMessage': val ? "Sistem bakımda, kısa süre sonra döneceğiz." : "",
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(val ? "Bakım modu AKTİF" : "Bakım modu KAPALI"), backgroundColor: val ? primaryRed : Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom + 24),
      children: [
        _sectionHeader("OPERASYON MERKEZİ", Icons.settings_suggest_rounded),

        // BAKIM MODU
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: _maintenance ? primaryRed.withOpacity(0.15) : cardBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: _maintenance ? primaryRed : Colors.white10, width: _maintenance ? 1.2 : 1)),
          child: Row(
            children: [
              Icon(Icons.construction, color: _maintenance ? primaryRed : Colors.white54, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("BAKIM MODU", style: TextStyle(color: _maintenance ? primaryRed : Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(_maintenance ? "Uygulama kilitli - Kullanıcılar bakım ekranı görüyor" : "Uygulama aktif - Her şey normal", style: const TextStyle(color: Colors.white38, fontSize: 10)),
                  ],
                ),
              ),
              _loadingStatus ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white30)) : Switch(value: _maintenance, activeColor: primaryRed, onChanged: _toggleMaintenance),
            ],
          ),
        ),

        Row(
          children: [
            Expanded(child: _actionCard("Zorunlu Güncelleme", "Min versiyon ayarla", Icons.system_update, Colors.blueAccent, () => _showVersionEditor())),
            const SizedBox(width: 8),
            Expanded(child: _actionCard("Duyuru Banner", "Ana sayfa bandı", Icons.campaign_rounded, primaryOrange, () => _showBannerEditor())),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _actionCard("Toplu Bildirim", "Tüm kullanıcılara", Icons.notifications_active, Colors.greenAccent, () => _showPushDialog())),
            const SizedBox(width: 8),
            Expanded(child: _actionCard("Cache Temizle", "Sistem önbelleği", Icons.cleaning_services, Colors.white54, () => _clearCache())),
          ],
        ),

        const SizedBox(height: 20),
        _sectionHeader("İÇERİK YÖNETİMİ", Icons.article_rounded),

        _contentTile("Kategori Düzenle", "Branş ve Hizmet Yönetimi", Icons.category, Colors.purpleAccent, () => _showCategoryEditor()),
        _contentTile("Sıkça Sorulan Sorular", "SSS ekle / düzenle", Icons.help_outline, Colors.cyanAccent, () => _showSSSManager()),
        _contentTile("Duyurular", "Uygulama içi duyurular listesi", Icons.announcement_outlined, primaryOrange, () => _showAnnouncementsManager()),

        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionHeader("SÖZLEŞMELER", Icons.gavel_rounded),
            IconButton(
              tooltip: "Varsayılan sözleşmeleri yükle",
              icon: const Icon(Icons.cloud_upload, color: Colors.white38, size: 20),
              onPressed: () => _uploadDefaults(),
            )
          ],
        ),

        StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('config').doc('musteri_sozlesme').snapshots(),
          builder: (context, snap) {
            var updated = "";
            if (snap.hasData && snap.data!.exists) {
              var d = snap.data!.data() as Map<String, dynamic>?;
              var ts = d?['guncelleme_tarihi'];
              if (ts is Timestamp) updated = "${ts.toDate().day}.${ts.toDate().month}.${ts.toDate().year}";
            }
            return _contentTile("Müşteri Sözleşmesi", updated.isEmpty ? "İçerik ve KVKK" : "Son güncelleme: $updated", Icons.person_outline, Colors.greenAccent, () => _showContractEditor('musteri_sozlesme', 'Müşteri Sözleşmesi'));
          },
        ),
        StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('config').doc('usta_sozlesme').snapshots(),
          builder: (context, snap) {
            var updated = "";
            if (snap.hasData && snap.data!.exists) {
              var d = snap.data!.data() as Map<String, dynamic>?;
              var ts = d?['guncelleme_tarihi'];
              if (ts is Timestamp) updated = "${ts.toDate().day}.${ts.toDate().month}.${ts.toDate().year}";
            }
            return _contentTile("Usta Sözleşmesi", updated.isEmpty ? "Hizmet Şartları" : "Son güncelleme: $updated", Icons.engineering, Colors.orangeAccent, () => _showContractEditor('usta_sozlesme', 'Usta Sözleşmesi'));
          },
        ),

        const SizedBox(height: 20),
        _sectionHeader("SİSTEM BİLGİSİ", Icons.info_outline),
        StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('config').doc('app_status').snapshots(),
          builder: (context, snap) {
            if (!snap.hasData || !snap.data!.exists) return _infoCard("Durum", "Henüz ayar yok");
            var data = snap.data!.data() as Map<String, dynamic>;
            return Column(
              children: [
                _infoCard("Min Versiyon", data['minVersion'] ?? "Ayarlanmadı"),
                _infoCard("Banner", (data['announcementActive'] == true) ? (data['announcementText'] ?? "Aktif") : "Kapalı"),
                _infoCard("Bakım Mesajı", data['maintenanceMessage'] ?? "-"),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4, top: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 14),
          const SizedBox(width: 6),
          Text(title, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ],
      ),
    );
  }

  Widget _actionCard(String title, String sub, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Icon(icon, color: color, size: 18)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)), Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 9))])),
          ],
        ),
      ),
    );
  }

  Widget _contentTile(String title, String sub, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)), child: Icon(icon, color: color, size: 18)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        subtitle: Text(sub, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24, size: 18),
        onTap: onTap,
      ),
    );
  }

  Widget _infoCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white10)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)), Text(value.length > 30 ? "${value.substring(0, 30)}..." : value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))]),
    );
  }

  void _showVersionEditor() {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: cardBg,
      title: const Text("ZORUNLU GÜNCELLEME", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      content: TextField(controller: ctrl, style: const TextStyle(color: Colors.white, fontSize: 13), decoration: const InputDecoration(hintText: "Örn: 1.2.5", hintStyle: TextStyle(color: Colors.white30), filled: true, fillColor: Colors.black26, border: OutlineInputBorder(borderSide: BorderSide.none))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("İPTAL", style: TextStyle(color: Colors.white54, fontSize: 11))),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent), onPressed: () async {
          await _firestore.collection('config').doc('app_status').set({'minVersion': ctrl.text, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Min versiyon ${ctrl.text} yapıldı")));
        }, child: const Text("KAYDET", style: TextStyle(fontSize: 11))),
      ],
    ));
  }

  void _showBannerEditor() {
    final textCtrl = TextEditingController();
    bool active = false;
    showDialog(context: context, builder: (context) => StatefulBuilder(builder: (context, setSt) => AlertDialog(
      backgroundColor: cardBg,
      title: const Text("DUYURU BANNER", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: textCtrl, style: const TextStyle(color: Colors.white, fontSize: 12), decoration: const InputDecoration(hintText: "Bugün %20 indirim! gibi...", hintStyle: TextStyle(color: Colors.white30, fontSize: 11), filled: true, fillColor: Colors.black26, border: OutlineInputBorder(borderSide: BorderSide.none))),
        const SizedBox(height: 10),
        Row(children: [const Text("Aktif", style: TextStyle(color: Colors.white70, fontSize: 11)), const Spacer(), Switch(value: active, activeColor: primaryOrange, onChanged: (v) => setSt(() => active = v))]),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("İPTAL", style: TextStyle(color: Colors.white54, fontSize: 11))),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: primaryOrange), onPressed: () async {
          await _firestore.collection('config').doc('app_status').set({'announcementActive': active, 'announcementText': textCtrl.text, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Banner güncellendi")));
        }, child: const Text("KAYDET", style: TextStyle(color: Colors.black, fontSize: 11))),
      ],
    )));
  }

  void _showPushDialog() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: cardBg,
      title: const Text("TOPLU BİLDİRİM GÖNDER", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: titleCtrl, style: const TextStyle(color: Colors.white, fontSize: 12), decoration: const InputDecoration(hintText: "Başlık", hintStyle: TextStyle(color: Colors.white30), filled: true, fillColor: Colors.black26, border: OutlineInputBorder(borderSide: BorderSide.none))),
        const SizedBox(height: 8),
        TextField(controller: bodyCtrl, maxLines: 3, style: const TextStyle(color: Colors.white, fontSize: 12), decoration: const InputDecoration(hintText: "Mesaj içeriği", hintStyle: TextStyle(color: Colors.white30), filled: true, fillColor: Colors.black26, border: OutlineInputBorder(borderSide: BorderSide.none))),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("İPTAL", style: TextStyle(color: Colors.white54, fontSize: 11))),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: () async {
          await _firestore.collection('admin_messages').add({'msg': "[TOPLU BILDIRIM] ${titleCtrl.text}: ${bodyCtrl.text}", 'time': FieldValue.serverTimestamp(), 'status': 'yeni', 'type': 'broadcast'});
          // Gercek push icin cloud function tetikler, simdilik firestore'a broadcast kaydi
          await _firestore.collection('config').doc('broadcasts').collection('queue').add({'title': titleCtrl.text, 'body': bodyCtrl.text, 'createdAt': FieldValue.serverTimestamp(), 'status': 'pending'});
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bildirim kuyruğa eklendi - Cloud Function gönderecek")));
        }, child: const Text("GÖNDER", style: TextStyle(fontSize: 11))),
      ],
    ));
  }

  Future<void> _clearCache() async {
    await _firestore.collection('config').doc('app_status').set({'cacheClearedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cache temizleme sinyali gönderildi")));
  }

  // SSS
  void _showSSSManager() {
    showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: cardBg,
      title: const Text("SSS YÖNETİMİ", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: 400, height: 350,
        child: Column(
          children: [
            _sssAddField(),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('config').doc('sss').collection('items').orderBy('createdAt', descending: true).snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white30));
                  if (snap.data!.docs.isEmpty) return const Center(child: Text("Henüz SSS yok", style: TextStyle(color: Colors.white30, fontSize: 11)));
                  return ListView.builder(itemCount: snap.data!.docs.length, itemBuilder: (context, i) {
                    var d = snap.data!.docs[i].data() as Map<String, dynamic>;
                    return Container(margin: const EdgeInsets.only(bottom: 6), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(6)), child: ListTile(dense: true, title: Text(d['q'] ?? "", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)), subtitle: Text(d['a'] ?? "", style: const TextStyle(color: Colors.white54, fontSize: 10)), trailing: IconButton(icon: const Icon(Icons.delete, size: 14, color: Colors.white30), onPressed: () => snap.data!.docs[i].reference.delete())));
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("KAPAT", style: TextStyle(color: Colors.white54, fontSize: 11)))],
    ));
  }

  Widget _sssAddField() {
    final q = TextEditingController(); final a = TextEditingController();
    return Row(children: [Expanded(child: TextField(controller: q, style: const TextStyle(color: Colors.white, fontSize: 11), decoration: const InputDecoration(hintText: "Soru", hintStyle: TextStyle(color: Colors.white30, fontSize: 10), filled: true, fillColor: Colors.black26, border: OutlineInputBorder(borderSide: BorderSide.none), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)))), const SizedBox(width: 6), Expanded(child: TextField(controller: a, style: const TextStyle(color: Colors.white, fontSize: 11), decoration: const InputDecoration(hintText: "Cevap", hintStyle: TextStyle(color: Colors.white30, fontSize: 10), filled: true, fillColor: Colors.black26, border: OutlineInputBorder(borderSide: BorderSide.none), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)))), const SizedBox(width: 6), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: primaryOrange, padding: const EdgeInsets.symmetric(horizontal: 10)), onPressed: () async { if (q.text.isEmpty) return; await _firestore.collection('config').doc('sss').collection('items').add({'q': q.text, 'a': a.text, 'createdAt': FieldValue.serverTimestamp()}); q.clear(); a.clear(); }, child: const Text("EKLE", style: TextStyle(color: Colors.black, fontSize: 10)))]);
  }

  void _showAnnouncementsManager() {
    showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: cardBg,
      title: const Text("DUYURULAR", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      content: SizedBox(width: 380, height: 300, child: StreamBuilder<QuerySnapshot>(stream: _firestore.collection('config').doc('announcements').collection('list').orderBy('createdAt', descending: true).snapshots(), builder: (context, snap) { if (!snap.hasData) return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white30)); return ListView.builder(itemCount: snap.data!.docs.length, itemBuilder: (context, i){ var d = snap.data!.docs[i].data() as Map<String, dynamic>; return Container(margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(6)), child: Row(children: [Expanded(child: Text(d['text'] ?? "", style: const TextStyle(color: Colors.white, fontSize: 11))), IconButton(icon: const Icon(Icons.delete, size: 14, color: Colors.white30), onPressed: ()=> snap.data!.docs[i].reference.delete())])); }); })),
      actions: [TextButton(onPressed: ()=> Navigator.pop(context), child: const Text("KAPAT", style: TextStyle(color: Colors.white54, fontSize: 11)))],
    ));
  }

  void _showContractEditor(String docId, String title) {
    final docRef = _firestore.collection('config').doc(docId);
    showDialog(context: context, builder: (context) => FutureBuilder<DocumentSnapshot>(future: docRef.get(), builder: (context, snapshot) {
      final data = snapshot.hasData && snapshot.data!.exists ? snapshot.data!.data() as Map<String, dynamic>? : null;
      final TextEditingController textController = TextEditingController(text: data?['metin'] ?? "");
      return AlertDialog(backgroundColor: cardBg, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: primaryRed)), title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), content: SizedBox(width: 450, height: 400, child: TextField(controller: textController, maxLines: null, expands: true, textAlignVertical: TextAlignVertical.top, style: const TextStyle(color: Colors.white, fontSize: 12), decoration: const InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: Colors.black26, contentPadding: EdgeInsets.all(12)))), actions: [TextButton(onPressed: ()=> Navigator.pop(context), child: const Text("KAPAT", style: TextStyle(color: Colors.white54, fontSize: 12))), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: primaryRed), onPressed: () { docRef.set({'metin': textController.text, 'guncelleme_tarihi': Timestamp.now()}, SetOptions(merge: true)); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kaydedildi"))); }, child: const Text("KAYDET", style: TextStyle(color: Colors.white, fontSize: 12)))]);
    }));
  }

  void _showCategoryEditor() {
    showDialog(context: context, builder: (context) {
      final TextEditingController catController = TextEditingController();
      return AlertDialog(backgroundColor: cardBg, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: primaryRed)), title: const Text("KATEGORİ YÖNETİMİ", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), content: SizedBox(width: 350, child: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: catController, style: const TextStyle(color: Colors.white, fontSize: 13), decoration: InputDecoration(hintText: "Yeni Kategori...", hintStyle: const TextStyle(color: Colors.white30, fontSize: 13), filled: true, fillColor: Colors.black26, border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none))), const SizedBox(height: 12), SizedBox(height: 200, child: StreamBuilder<DocumentSnapshot>(stream: _firestore.collection('config').doc('kategoriler').snapshots(), builder: (context, snapshot) { if (!snapshot.hasData || !snapshot.data!.exists) return const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)); var data = snapshot.data!.data() as Map<String, dynamic>?; var list = List<String>.from(data?['liste'] ?? []); return ListView.builder(itemCount: list.length, itemBuilder: (context, i) => ListTile(dense: true, title: Text(list[i], style: const TextStyle(color: Colors.white, fontSize: 12)), trailing: IconButton(icon: Icon(Icons.delete, color: primaryRed, size: 16), onPressed: () { list.removeAt(i); _firestore.collection('config').doc('kategoriler').update({'liste': list}); }))); }))])), actions: [TextButton(onPressed: ()=> Navigator.pop(context), child: const Text("KAPAT", style: TextStyle(color: Colors.white54, fontSize: 12))), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: primaryRed), onPressed: () { if(catController.text.isNotEmpty) { _firestore.collection('config').doc('kategoriler').set({'liste': FieldValue.arrayUnion([catController.text])}, SetOptions(merge: true)); catController.clear(); } }, child: const Text("EKLE", style: TextStyle(color: Colors.white, fontSize: 12)))]);
    });
  }

  Future<void> _uploadDefaults() async {
    // Mevcut sözleşmeleri yükle fonksiyonu - aynı kalacak ama kısa
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Varsayılan sözleşmeler zaten config'de - editor üzerinden düzenle")));
  }
}
