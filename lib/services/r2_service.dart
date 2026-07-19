import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../env.dart';

class R2Service {
  String get _accessKey => Env.r2FlutterAccessKey.trim();
  String get _secretKey => Env.r2FlutterSecretKey.trim();
  String get _endpoint => Env.r2FlutterEndpoint.trim().replaceAll('https://', '').replaceAll('/', '');
  String get _bucket => 'ustam-gelsin-medya';
  String get _baseUrl => Env.r2PublicUrl.trim().replaceAll(RegExp(r'/$'), '');

  // Hem 2 hem 3 parametre
  Future<String> uploadFile(File file, String folderOrPath, [String? fileName]) async {
    final String fullPath = fileName == null ? folderOrPath : "$folderOrPath/$fileName";
    final String cleanPath = fullPath.replaceAll(' ', '_').replaceAll('//', '/');
    final bytes = await file.readAsBytes();

    final now = DateTime.now().toUtc();
    final amzDate = _formatAmzDate(now);
    final dateStamp = _formatDateStamp(now);
    const region = 'auto';
    const service = 's3';

    final host = _endpoint;
    final uri = Uri.https(host, '/$_bucket/$cleanPath');

    // --- AWS Signature V4 ---
    final payloadHash = sha256.convert(bytes).toString();
    final canonicalHeaders = 'host:$host\nx-amz-content-sha256:$payloadHash\nx-amz-date:$amzDate\n';
    final signedHeaders = 'host;x-amz-content-sha256;x-amz-date';
    final canonicalRequest = 'PUT\n/$_bucket/$cleanPath\n\n$canonicalHeaders\n$signedHeaders\n$payloadHash';
    final credentialScope = '$dateStamp/$region/$service/aws4_request';
    final stringToSign = 'AWS4-HMAC-SHA256\n$amzDate\n$credentialScope\n${sha256.convert(utf8.encode(canonicalRequest))}';

    final kDate = Hmac(sha256, utf8.encode('AWS4$_secretKey')).convert(utf8.encode(dateStamp)).bytes;
    final kRegion = Hmac(sha256, kDate).convert(utf8.encode(region)).bytes;
    final kService = Hmac(sha256, kRegion).convert(utf8.encode(service)).bytes;
    final kSigning = Hmac(sha256, kService).convert(utf8.encode('aws4_request')).bytes;
    final signature = Hmac(sha256, kSigning).convert(utf8.encode(stringToSign)).toString();

    final authHeader = 'AWS4-HMAC-SHA256 Credential=$_accessKey/$credentialScope, SignedHeaders=$signedHeaders, Signature=$signature';

    final response = await http.put(
      uri,
      headers: {
        'Host': host,
        'x-amz-date': amzDate,
        'x-amz-content-sha256': payloadHash,
        'Authorization': authHeader,
        'Content-Length': bytes.length.toString(),
        'Content-Type': 'image/jpeg',
      },
      body: bytes,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return "$_baseUrl/$cleanPath";
    } else {
      print("R2 HTTP HATA: ${response.statusCode} ${response.body}");
      throw Exception("Yükleme hatası: ${response.statusCode} ${response.body}");
    }
  }

  Future<void> deleteFile(String url) async {
    // Silme şimdilik kalsın, yükleme düzelsin yeter
    final key = url.replaceFirst("$_baseUrl/", "");
    print("Silinecek: $key - Manuel silme eklenebilir");
  }

  String _formatAmzDate(DateTime dt) {
    return "${dt.year.toString().padLeft(4,'0')}${dt.month.toString().padLeft(2,'0')}${dt.day.toString().padLeft(2,'0')}T${dt.hour.toString().padLeft(2,'0')}${dt.minute.toString().padLeft(2,'0')}${dt.second.toString().padLeft(2,'0')}Z";
  }
  String _formatDateStamp(DateTime dt) {
    return "${dt.year.toString().padLeft(4,'0')}${dt.month.toString().padLeft(2,'0')}${dt.day.toString().padLeft(2,'0')}";
  }
}