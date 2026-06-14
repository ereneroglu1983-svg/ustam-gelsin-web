// lib/services/ai_analysis_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// GÜVENLİK PROTOKOLÜ MADDE 3: Dosya yolu klasör yapısına göre güncellendi
import 'package:ustam_gelsin/core/theme/app_theme.dart';
import 'ai_service.dart';

class AIAnalysisScreen extends StatefulWidget {
  const AIAnalysisScreen({super.key});

  @override
  State<AIAnalysisScreen> createState() => _AIAnalysisScreenState();
}

class _AIAnalysisScreenState extends State<AIAnalysisScreen> {
  final AIService _aiService = AIService();
  final _formKey = GlobalKey<FormState>();

  // GENİŞLETİLMİŞ İŞ LİSTESİ
  final List<String> _isListesi = [
    'Boya Badana', 'Parke Döşeme', 'Mutfak Tadilatı', 'Elektrik Tesisatı',
    'Sıhhi Tesisat', 'Alçıpan & Kartonpiyer', 'Dış Cephe Mantolama',
    'Fayans & Seramik', 'Çatı Tamiri', 'Mobilya Montaj', 'Kombi Bakımı', 'Cam Balkon'
  ];

  // TÜRKİYE'NİN TÜM ŞEHİRLERİ (Alfabetik)
  final List<String> _sehirListesi = [
    'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Amasya', 'Ankara', 'Antalya', 'Artvin', 'Aydın', 'Balıkesir', 'Bilecik', 'Bingöl', 'Bitlis', 'Bolu', 'Burdur', 'Bursa', 'Çanakkale', 'Çankırı', 'Çorum', 'Denizli', 'Diyarbakır', 'Edirne', 'Elazığ', 'Erzincan', 'Erzurum', 'Eskişehir', 'Gaziantep', 'Giresun', 'Gümüşhane', 'Hakkari', 'Hatay', 'Isparta', 'Mersin', 'İstanbul', 'İzmir', 'Kars', 'Kastamonu', 'Kayseri', 'Kırklareli', 'Kırşehir', 'Kocaeli', 'Konya', 'Kütahya', 'Malatya', 'Manisa', 'Kahramanmaraş', 'Mardin', 'Muğla', 'Muş', 'Nevşehir', 'Niğde', 'Ordu', 'Rize', 'Sakarya', 'Samsun', 'Siirt', 'Sinop', 'Sivas', 'Tekirdağ', 'Tokat', 'Trabzon', 'Tunceli', 'Şanlıurfa', 'Uşak', 'Van', 'Yozgat', 'Zonguldak', 'Aksaray', 'Bayburt', 'Karaman', 'Kırıkkale', 'Batman', 'Şırnak', 'Bartın', 'Ardahan', 'Ighdır', 'Yalova', 'Karabük', 'Kilis', 'Osmaniye', 'Düzce'
  ];

  // REVİZE: İlk değerler artık statik değil, listelerin ilk elemanlarından otomatik alınıyor.
  late String _secilenIsTipi;
  late String _secilenSehir;

  final TextEditingController _m2Controller = TextEditingController();
  final TextEditingController _detayController = TextEditingController();

  bool _yukleniyor = false;
  String? _analizSonucu;

  @override
  void initState() {
    super.initState();
    // Uygulama açıldığında listelerin ilk elemanlarını otomatik seçiyoruz
    _secilenIsTipi = _isListesi.first;
    _secilenSehir = _sehirListesi.first;
  }

  void _analizYap() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _yukleniyor = true;
        _analizSonucu = null;
      });

      try {
        final sonuc = await _aiService.uzmanAnaliziAl(
          isTipi: _secilenIsTipi,
          metrekare: int.tryParse(_m2Controller.text) ?? 0,
          sehir: _secilenSehir,
          detay: _detayController.text,
        );

        setState(() {
          _analizSonucu = sonuc;
          _yukleniyor = false;
        });
      } catch (e) {
        setState(() {
          _analizSonucu = "Hata oluştu. İnternetinizi kontrol edip tekrar deneyin.";
          _yukleniyor = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGradientEnd,
      appBar: AppBar(
        title: Text("AI Maliyet Uzmanı", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Hizmet Türü"),
              _buildDropdown(_isListesi, _secilenIsTipi, (val) => setState(() => _secilenIsTipi = val!)),
              const SizedBox(height: 20),

              _buildLabel("Şehir"),
              _buildDropdown(_sehirListesi, _secilenSehir, (val) => setState(() => _secilenSehir = val!)),
              const SizedBox(height: 20),

              _buildTextField(_m2Controller, "Alan Metrekare (m2)", Icons.square_foot, isNumber: true),
              const SizedBox(height: 20),

              _buildTextField(_detayController, "Eklemek İstediğiniz Detaylar", Icons.description, maxLines: 3),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _yukleniyor ? null : _analizYap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _yukleniyor
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("HESAPLA", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),

              if (_analizSonucu != null) ...[
                const SizedBox(height: 30),
                _buildAnalizKarti(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
  );

  Widget _buildDropdown(List<String> liste, String seciliDeger, Function(String?) onChanged) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: seciliDeger,
          dropdownColor: const Color(0xFF1A237E),
          isExpanded: true,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: liste.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.multiline,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: Colors.amber),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (v) => v!.isEmpty ? "Boş geçmeyin" : null,
    );
  }

  Widget _buildAnalizKarti() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.amber),
              const SizedBox(width: 10),
              Text("AI Uzman Analizi", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          Text(_analizSonucu!, style: const TextStyle(color: Colors.black87, fontSize: 15, height: 1.5)),
        ],
      ),
    );
  }
}