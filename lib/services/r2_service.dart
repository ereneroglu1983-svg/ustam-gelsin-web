import 'dart:io';
import 'package:minio/minio.dart';
import '../env.dart'; // Env sınıfını içe aktardık

class R2Service {
  // Anahtarları Env üzerinden alıyoruz
  final minio = Minio(
    endPoint: Env.r2Endpoint,
    accessKey: Env.r2AccessKey,
    secretKey: Env.r2SecretKey,
  );

  final String bucket = 'ustam-gelsin-medya';

  Future<String> uploadFile(File file, String fileName) async {
    try {
      final data = await file.readAsBytes();

      await minio.putObject(
        bucket,
        fileName,
        Stream.value(data),
      );

      return "https://medya.hemenustamgelsin.com/$fileName";
    } catch (e) {
      print("R2 yükleme hatası: $e");
      rethrow;
    }
  }
}