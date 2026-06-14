import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class BillingService {
  // Entegrasyon bilgileri buraya girilecek
  final String _apiUrl = "https://entegrator-api-adresi.com/v1/create-invoice";
  final String _apiKey = "YOUR_API_KEY_HERE";

  /// Usta teklif verdiğinde faturayı otomatik tetikleyen fonksiyon
  Future<void> createInvoiceForOffer(
      String ustaId, double tutar, String ilanId) async {

    final invoiceData = {
      "customerName": "Usta Adı/Ünvanı", // Firestore'dan çekilecek
      "amount": tutar,
      "description": "İlan iletişim bilgisi satış bedeli - İlan ID: $ilanId",
      "date": DateTime.now().toIso8601String(),
    };

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode(invoiceData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Fatura başarılı kesildiyse Firebase'e kaydet
        await FirebaseFirestore.instance.collection('invoices').add({
          "ustaId": ustaId,
          "invoiceNo": data['invoiceNo'],
          "pdfUrl": data['pdfUrl'],
          "timestamp": FieldValue.serverTimestamp(),
        });
        print("Fatura başarıyla oluşturuldu.");
      } else {
        throw Exception("Fatura oluşturulamadı: ${response.body}");
      }
    } catch (e) {
      print("BillingService Hata: $e");
      rethrow;
    }
  }
}