// lib/services/teklif_pdf_service.dart - HUG MARKET Antetli Teklif PDF Service PRO V1
// Hemen Ustam Gelsin + HUG Market ortak antetli tasarım
// Tier fiyat tablosu, server-side fiyat ile uyumlu

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TeklifPdfService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<Uint8List> _buildPdf({
    required String firma,
    required String yetkili,
    required String email,
    required String kategori,
    required List<String> altAlanlar,
    required int puan,
    required int sureAy,
    required int tamFiyat,
    required int teklifFiyat,
    required String tierLabel,
  }) async {
    final doc = pw.Document();

    final aylik = (teklifFiyat / sureAy).round();
    final tarih = DateTime.now();
    final tarihStr = "${tarih.day.toString().padLeft(2, '0')}.${tarih.month.toString().padLeft(2, '0')}.${tarih.year}";
    final teklifNo = "HUG-${tarih.year}${tarih.month.toString().padLeft(2,'0')}${tarih.day.toString().padLeft(2,'0')}-${firma.substring(0, firma.length > 3 ? 3 : firma.length).toUpperCase()}";

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        build: (context) => [
          // HEADER - Siyah
          pw.Container(
            width: double.infinity,
            color: PdfColor.fromHex("#000000"),
            padding: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("HEMEN USTAM GELSİN", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 16)),
                    pw.SizedBox(height: 4),
                    pw.Text("©HUG Market • Kategori Münhasır Çözüm Ortaklığı", style: pw.TextStyle(color: PdfColor.fromHex("#AAAAAA"), fontSize: 9)),
                    pw.SizedBox(height: 2),
                    pw.Text("hemenustamgelsin.com • info@hemenustamgelsin.com", style: pw.TextStyle(color: PdfColor.fromHex("#888888"), fontSize: 7)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Sağlık Mh. Kurudere Cad. No:76/9", style: pw.TextStyle(color: PdfColor.fromHex("#AAAAAA"), fontSize: 7)),
                    pw.Text("Salihli - MANİSA", style: pw.TextStyle(color: PdfColor.fromHex("#AAAAAA"), fontSize: 7)),
                    pw.Text("0532 163 59 66", style: pw.TextStyle(color: PdfColor.fromHex("#AAAAAA"), fontSize: 7)),
                    pw.Text("D-U-N-S®: 751176741", style: pw.TextStyle(color: PdfColor.fromHex("#AAAAAA"), fontSize: 7)),
                  ],
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // TEKLIF BILGILERI
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("TEKLİF NO: $teklifNo", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#666666"))),
                        pw.SizedBox(height: 4),
                        pw.Text("TARİH: $tarihStr", style: pw.TextStyle(fontSize: 9, color: PdfColor.fromHex("#666666"))),
                        pw.SizedBox(height: 4),
                        pw.Text("GEÇERLİLİK: 15 GÜN", style: pw.TextStyle(fontSize: 9, color: PdfColor.fromHex("#666666"))),
                      ],
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: pw.BoxDecoration(color: PdfColor.fromHex("#F8F8F7"), borderRadius: pw.BorderRadius.circular(8)),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("ALICI", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#888888"))),
                          pw.Text(firma, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                          if (yetkili.isNotEmpty) pw.Text(yetkili, style: pw.TextStyle(fontSize: 9, color: PdfColor.fromHex("#555555"))),
                          pw.Text(email, style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex("#555555"))),
                        ],
                      ),
                    ),
                  ],
                ),

                pw.SizedBox(height: 24),

                pw.Text("Merhaba ${yetkili.isNotEmpty ? yetkili : firma},", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 6),
                pw.Text("$kategori kategorisinde talebiniz için özel çözüm ortaklığı teklifimiz aşağıdadır. Bu teklif, seçilen alt alanlar, münhasırlık kapsamı ve süreye göre hesaplanmıştır.", style: pw.TextStyle(fontSize: 9, color: PdfColor.fromHex("#555555"))),

                pw.SizedBox(height: 20),

                // TEKLIF TABLOSU
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(color: PdfColor.fromHex("#F8F8F7"), borderRadius: pw.BorderRadius.circular(12), border: pw.Border.all(color: PdfColor.fromHex("#EEEEEE"))),
                  child: pw.Column(
                    children: [
                      _buildRow("Kategori", kategori, isBold: true),
                      _buildRow("Tier", tierLabel, isBold: false),
                      _buildRow("Kapsam", "%$puan • ${altAlanlar.join(", ")}", isBold: false, maxLines: 3),
                      _buildRow("Süre", "$sureAy Ay • 81 İl Görünürlük", isBold: false),
                      pw.Divider(color: PdfColor.fromHex("#DDDDDD"), height: 20),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("TEKLİF BEDELİ", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                          pw.Text("$teklifFiyat TL", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                      pw.SizedBox(height: 6),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Tam Fiyat", style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex("#888888"), decoration: pw.TextDecoration.lineThrough)),
                          pw.Text("$tamFiyat TL (liste)", style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex("#888888"), decoration: pw.TextDecoration.lineThrough)),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text("Formül: $puan/100 x $tamFiyat = $teklifFiyat • Aylık: $aylik TL • Hesaplama sunucu tarafında doğrulandı", style: pw.TextStyle(fontSize: 7, color: PdfColor.fromHex("#999999"))),
                    ],
                  ),
                ),

                pw.SizedBox(height: 16),

                pw.Text("Dış açıklama metni: Çözüm ortaklığı bedeli; seçilen kategori/ürün alanları, münhasırlık kapsamı, süre ve entegrasyon kapsamına göre belirlenir. (İç fiyat tablosu webde gösterilmez)", style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex("#888888"))),

                pw.SizedBox(height: 20),

                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(color: PdfColors.white, borderRadius: pw.BorderRadius.circular(8), border: pw.Border.all(color: PdfColor.fromHex("#EEEEEE"))),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("ÖDEME BİLGİLERİ", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#888888"))),
                      pw.SizedBox(height: 6),
                      pw.Text("IBAN: TR79 0086 4011 0000 8503 0670 04", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Alıcı: Eren EROĞLU", style: pw.TextStyle(fontSize: 9)),
                      pw.Text("Açıklama: $teklifNo - $firma", style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex("#666666"))),
                      pw.SizedBox(height: 8),
                      pw.Text("©HUG Market • © Hemen Ustam Gelsin • Sağlık Mh. Kurudere Cad. No:76/9 Salihli-MANİSA", style: pw.TextStyle(fontSize: 7, color: PdfColor.fromHex("#999999"))),
                    ],
                  ),
                ),

                pw.SizedBox(height: 30),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("HEMEN USTAM GELSİN", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                        pw.Text("Eren Eroğlu", style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex("#666666"))),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("Onay / İmza", style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex("#888888"))),
                        pw.SizedBox(height: 20),
                        pw.Container(width: 100, height: 1, color: PdfColor.fromHex("#CCCCCC")),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        footer: (context) => pw.Container(
          width: double.infinity,
          color: PdfColor.fromHex("#111111"),
          padding: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("©HUG Market • © Hemen Ustam Gelsin • hemenustamgelsin.com", style: pw.TextStyle(color: PdfColor.fromHex("#888888"), fontSize: 7)),
              pw.Text("D-U-N-S®: 751176741 • 0532 163 59 66", style: pw.TextStyle(color: PdfColor.fromHex("#888888"), fontSize: 7)),
            ],
          ),
        ),
      ),
    );

    return await doc.save();
  }

  pw.Widget _buildRow(String label, String value, {bool isBold = false, int maxLines = 1}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 9, color: PdfColor.fromHex("#888888"))),
          pw.Expanded(
            child: pw.Text(
              value,
              textAlign: pw.TextAlign.right,
              maxLines: maxLines,
              style: pw.TextStyle(fontSize: 10, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> olusturVeKaydet({
    required String firma,
    required String yetkili,
    required String email,
    required String kategori,
    required List<String> altAlanlar,
    required int puan,
    required int sureAy,
    required int tamFiyat,
    required int teklifFiyat,
    required String tierLabel,
  }) async {
    try {
      final pdfBytes = await _buildPdf(
        firma: firma,
        yetkili: yetkili,
        email: email,
        kategori: kategori,
        altAlanlar: altAlanlar,
        puan: puan,
        sureAy: sureAy,
        tamFiyat: tamFiyat,
        teklifFiyat: teklifFiyat,
        tierLabel: tierLabel,
      );

      // 1. Storage'a yükle
      final fileName = "teklifler/${DateTime.now().millisecondsSinceEpoch}_${firma.replaceAll(' ', '_')}.pdf";
      final ref = _storage.ref().child(fileName);
      await ref.putData(pdfBytes, SettableMetadata(contentType: 'application/pdf'));
      final downloadUrl = await ref.getDownloadURL();

      // 2. Firestore'a kaydet
      await _firestore.collection('teklifler').add({
        'firma': firma,
        'yetkili': yetkili,
        'email': email,
        'kategori': kategori,
        'altAlanlar': altAlanlar,
        'puan': puan,
        'sureAy': sureAy,
        'tamFiyat': tamFiyat,
        'teklifFiyat': teklifFiyat,
        'tier': tierLabel,
        'pdfUrl': downloadUrl,
        'fileName': fileName,
        'olusturulmaTarihi': FieldValue.serverTimestamp(),
        'durum': 'hazirlandi',
        'teklifNo': "HUG-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2,'0')}${DateTime.now().day.toString().padLeft(2,'0')}-${firma.substring(0, firma.length > 3 ? 3 : firma.length).toUpperCase()}",
        'adres': 'Sağlık Mh. Kurudere Cad. No:76/9 Salihli-MANİSA',
        'iban': 'TR79 0086 4011 0000 8503 0670 04',
        'duns': '751176741',
      });

      // 3. Önizleme / Paylaş
      await Printing.sharePdf(bytes: pdfBytes, filename: '${firma}_teklif.pdf');

    } catch (e) {
      print("PDF Hatası: $e");
      rethrow;
    }
  }

  Future<Uint8List> olusturVeGetirBytes({
    required String firma,
    required String yetkili,
    required String email,
    required String kategori,
    required List<String> altAlanlar,
    required int puan,
    required int sureAy,
    required int tamFiyat,
    required int teklifFiyat,
    required String tierLabel,
  }) async {
    return await _buildPdf(
      firma: firma,
      yetkili: yetkili,
      email: email,
      kategori: kategori,
      altAlanlar: altAlanlar,
      puan: puan,
      sureAy: sureAy,
      tamFiyat: tamFiyat,
      teklifFiyat: teklifFiyat,
      tierLabel: tierLabel,
    );
  }
}
