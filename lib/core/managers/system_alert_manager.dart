import 'package:cloud_firestore/cloud_firestore.dart';

class SystemAlertManager {
  static Future<void> logError(String message) async {
    await FirebaseFirestore.instance.collection('system_alerts').add({
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}