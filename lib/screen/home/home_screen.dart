import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:response_ai/screen/home/widgets/chat_bubble.dart';
import 'package:response_ai/screen/home/widgets/empty_placeholder.dart';
import 'package:response_ai/screen/home/widgets/meassge_input_filed.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  static const String _apiKey = 'your api-keys';
  bool _isLoading = false;
  final List<Map<String, dynamic>> _messages = [];
  Future<void> _sendMessage() async{
    final text = controller.text.trim();
    if(text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({
        'text':text,
        'isUser':true
      });
      _isLoading = true;
      controller.clear();
    });

    final reply = await _fetchResponse(text);
    if(!mounted) return;

    setState(() {
      _messages.add({
        'text': reply,
        'isUser':false
      });
      _isLoading=false;
    });

  }

  Future<String> _fetchResponse(String prompt) async {
    const maxRetries = 2;
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.8-flash:generateContent',
    );

    try {
      for (int attempt = 0; attempt <= maxRetries; attempt++) {
        final response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'X-goog-api-key': _apiKey,
          },
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': prompt}
                ]
              }
            ]
          }),
        );

        debugPrint('ATTEMPT ${attempt + 1} -> STATUS CODE: ${response.statusCode}');

        if (response.statusCode == 200) {
          final decode = jsonDecode(response.body) as Map<String, dynamic>;
          final candidates = decode['candidates'] as List<dynamic>?;
          if (candidates != null && candidates.isNotEmpty) {
            final part = candidates[0]['content']['parts'] as List<dynamic>?;
            if (part != null && part.isNotEmpty) {
              final text = part[0]['text'] as String?;
              if (text != null && text.trim().isNotEmpty) {
                return text.trim();
              }
            }
          }
          return 'No Response Received';
        }

        if (response.statusCode == 503 && attempt < maxRetries) {
          await Future.delayed(Duration(seconds: (attempt + 1) * 2));
          continue;
        }

        debugPrint('Response Body: ${response.body}');

        if (response.statusCode == 503) {
          return 'Server is currently busy (503). Please try again in a moment.';
        }
        if (response.statusCode == 429) {
          return 'Too many requests (429). Please wait a bit and try again.';
        }

        return 'Request failed (${response.statusCode}). Please try again.';
      }
    } catch (e) {
      debugPrint('FETCH ERROR: $e');
      return 'Network error. Please check your connection and try again.';
    }

    return 'Server is currently busy (503). Please try again in a moment.';
  }



  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
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
          if(_messages.isEmpty)...[
            EmptyPlaceholder(),
          ]
          // Chat Bubble
          else
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
          // Loading Progress Indicator
          if(_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                spacing: 10,
                children: [
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(),
                  ),
                  Text('Word Flow is thinking.....')
                ],
              ),
            ),
          // Message Input Filed
          MessageInputField(controller: controller,onSendPressed: _sendMessage,isLoading: _isLoading,),
        ],
      ),
    );
  }
}



