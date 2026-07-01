// lib/core/widgets/chat_floating_head.dart

import 'package:flutter/material.dart';
import '../../features/chat/screens/chat_detay_sayfasi.dart';

class ChatFloatingHead extends StatefulWidget {
  final String ilanId;
  final String aliciId;
  final String aliciAd;

  const ChatFloatingHead({
    super.key,
    required this.ilanId,
    required this.aliciId,
    required this.aliciAd
  });

  @override
  State<ChatFloatingHead> createState() => _ChatFloatingHeadState();
}

class _ChatFloatingHeadState extends State<ChatFloatingHead> {
  Offset position = const Offset(300, 500);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: _buildHead(),
        childWhenDragging: Container(),
        onDragEnd: (details) {
          setState(() => position = details.offset);
        },
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => ChatDetaySayfasi(
                ilanId: widget.ilanId,
                ustaId: widget.aliciId,
                ustaAd: widget.aliciAd,
              ),
            ));
          },
          child: _buildHead(),
        ),
      ),
    );
  }

  Widget _buildHead() {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 30),
    );
  }
}