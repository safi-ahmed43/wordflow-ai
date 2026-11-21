import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBubble extends StatelessWidget {
  const new({
    super.key,
    required this.isUser,
    required this.message,
  });

  final bool isUser;
  final dynamic message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 12, vertical: 8),
      margin: .symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isUser ? Colors.deepPurple : Colors.grey.shade300,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isUser ? 16 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 16),
        ),
        border: isUser ? null : Border.all(color: Colors.grey),
      ),
      child: Text(
        message['text'],
        style: GoogleFonts.inter(
          color: isUser ? Colors.white : Colors.black,
          fontSize: 16,
          height: 1.4,
        ),
      ),
    );
  }
}