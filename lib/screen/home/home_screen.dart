import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:response_ai/screen/home/widgets/chat_bubble.dart';
import 'package:response_ai/screen/home/widgets/meassge_input_filed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List _messages = [
    {
      'text': 'Hello! What content would you like me to generate today?',
      'isUser': false,
    },
    {'text': 'Write a short caption for a coding project.', 'isUser': true},
    {
      'text': 'Turning ideas into clean code, one widget at a time. 🚀',
      'isUser': false,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 4,
          children: [
            Icon(Icons.all_inclusive, color: Colors.deepPurpleAccent, size: 35),
            Text(
              'WordFlow',
              style: GoogleFonts.abrilFatface(
                color: Colors.deepPurpleAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat Bubble
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isUser = message['isUser'];

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: ChatBubble(isUser: isUser, message: message),
                );
              },
            ),
          ),
          // Message Input Filed
          MessageInputField(),
        ],
      ),
    );
  }
}



