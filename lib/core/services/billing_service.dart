// lib/core/services/billing_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ustam_gelsin/env.dart';

class BillingService {
  final String _apiUrl = Env.billingApiUrl;
  final String _apiKey = Env.billingApiKey;

  Future<void> createInvoiceForOffer(
      String ustaId, double tutar, String ilanId) async {

    if (_apiKey.isEmpty) {
      debugPrint("BillingService Hata: API Anahtarı bulunamadı!");
      return;
    }

    // Fatura oluşturma isteği
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode({
          "customerName": "Usta ID: $ustaId", // Dinamik veri
          "amount": tutar,
          "description": "İlan iletişim bilgisi - ID: $ilanId",
          "date": DateTime.now().toIso8601String(),
        }),
      ).timeout(const Duration(seconds: 10)); // <-- ÖNEMLİ: Zaman aşımı eklendi

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Firestore yazma işlemini tek bir "set" ile garantili hale getirdik
        await FirebaseFirestore.instance.collection('invoices').add({
          "ustaId": ustaId,
          "ilanId": ilanId, // Takibi kolaylaştırmak için ilanId eklendi
          "invoiceNo": data['invoiceNo'] ?? "Bilinmiyor",
          "pdfUrl": data['pdfUrl'] ?? "",
          "timestamp": FieldValue.serverTimestamp(),
        });

      } else {
        debugPrint("API Hata: ${response.statusCode} - ${response.body}");
        throw Exception("Fatura servisi yanıt vermedi.");
      }
    } on http.ClientException catch (e) {
      debugPrint("Bağlantı hatası: $e");
      throw Exception("Lütfen internet bağlantınızı kontrol edin.");
    } catch (e) {
      debugPrint("Fatura oluşturma hatası: $e");
      rethrow;
    }
  }
}