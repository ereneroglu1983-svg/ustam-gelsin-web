// lib/core/services/overlay_manager.dart

import 'package:flutter/material.dart';
import 'package:ustam_gelsin/core/widgets/chat_floating_head.dart';
import 'package:ustam_gelsin/core/services/notification_service.dart';

class OverlayManager {
  static OverlayEntry? _overlayEntry;

  static void showChatHead(String ilanId, String aliciId, String aliciAd) {
    // Navigator'ın context'ine ulaş
    final context = NotificationService.navigatorKey.currentContext;
    if (context == null || _overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => ChatFloatingHead(
        ilanId: ilanId,
        aliciId: aliciId,
        aliciAd: aliciAd,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hideChatHead() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}