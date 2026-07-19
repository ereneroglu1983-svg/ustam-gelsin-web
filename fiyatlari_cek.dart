import 'dart:io';
import 'dart:convert';

void main() async {
  final klasorYolu = 'lib/core/calculation/meslekler';

  final dir = Directory(klasorYolu);
  if (!await dir.exists()) {
    print('❌ Klasör bulunamadı: $klasorYolu');
    return;
  }

  final Map<String, dynamic> tumKonfigler = {};

  await for (var entity in dir.list()) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final kod = await entity.readAsString();
      final dosyaAdi = entity.uri.pathSegments.last.replaceAll('.dart', '');

      final Map<String, dynamic> bulunan = {};

      // 1. SADECE GERÇEK FİYAT DEĞİŞKENLERİNİ AL
      // birimM2Fiyati, ekMaliyet, asgariBaraj, toplamFiyat gibi
      final fiyatRegex = RegExp(r'(birimM2Fiyati|tabanFiyat|tavanFiyat|ekMaliyet|asgariBaraj|toplamFiyat|nihaiSonuc|fiyat)\s*=?\s*([0-9]+\.?[0-9]*)');
      for (var m in fiyatRegex.allMatches(kod)) {
        bulunan[m.group(1)!] = double.parse(m.group(2)!);
      }

      // 2. m2 * 65.0 gibi ekstraları düzgün al
      // Senin kodundaki pattern: ekMaliyet += (m2 * 65.0)
      final ekM2Regex = RegExp(r'ekMaliyet \+= \(m2 \* ([0-9]+\.?[0-9]*)\)');
      for (var m in ekM2Regex.allMatches(kod)) {
        // Hangi işlem olduğunu bulmak için bir üst satıra bak
        final index = m.start;
        final onceki = kod.substring(index - 100 > 0? index - 100 : 0, index);
        String key = 'ek_bilinmeyen_${m.group(1)}';
        if (onceki.contains('Sıva Filesi')) key = 'siva_filesi_m2';
        else if (onceki.contains('Köşe Profili')) key = 'kose_profili_m2';
        else if (onceki.contains('Tamir')) key = 'tamir_m2';
        bulunan[key] = double.parse(m.group(1)!);
      }

      // 3. Sabit ek maliyet: ekMaliyet += 9500.0
      final sabitEkRegex = RegExp(r'ekMaliyet \+= ([0-9]+\.?[0-9]*);');
      for (var m in sabitEkRegex.allMatches(kod)) {
        final val = double.parse(m.group(1)!);
        if (val >= 500) { // 500 altı çöp olmasın
          final index = m.start;
          final onceki = kod.substring(index - 100 > 0? index - 100 : 0, index);
          String key = 'sabit_${val.toInt()}';
          if (onceki.contains('İskele')) key = 'iskele_sabit';
          bulunan[key] = val;
        }
      }

      // 4. Çarpanlar: *= 1.45
      final carpanRegex = RegExp(r'\*=\s*([0-9]+\.[0-9]+)');
      for (var m in carpanRegex.allMatches(kod)) {
        final val = double.parse(m.group(1)!);
        if (val > 1.0 && val < 5.0) { // sadece mantıklı çarpanlar
          final index = m.start;
          final onceki = kod.substring(index - 120 > 0? index - 120 : 0, index);
          String key = 'carpan_${val}';
          if (onceki.contains('Dış Cephe')) key = 'dis_cephe_carpan';
          else if (onceki.contains('Dekoratif')) key = 'dekoratif_carpan';
          bulunan[key] = val;
        }
      }

      tumKonfigler[dosyaAdi] = bulunan;
      print('✅ $dosyaAdi -> $bulunan');
    }
  }

  final outFile = File('firebase_fiyat_konfig.json');
  await outFile.writeAsString(JsonEncoder.withIndent(' ').convert(tumKonfigler));

  print('\n🎉 BİTTİ USTAM! ${tumKonfigler.length} meslek');
  print('Dosya: ${outFile.absolute.path}');
}