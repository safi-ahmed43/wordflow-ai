import 'package:flutter/material.dart';

class MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSendPressed;
  final VoidCallback? onAttachPressed;
  final bool isLoading;

  const MessageInputField({
    super.key,
    required this.controller,
    this.onSendPressed,
    this.onAttachPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.only(right: 7,top: 5,bottom: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey)
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onAttachPressed,
            icon: Icon(
              Icons.attach_file,
              size: 30,
              color: Colors.deepPurpleAccent,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Ask to WordFlow',
              ),
              minLines: 1,
              maxLines: 5,
            ),
          ),
          IconButton.filled(onPressed: onSendPressed,style: IconButton.styleFrom(
            backgroundColor: isLoading ? Colors.grey : Colors.deepPurple
          ),padding: EdgeInsets.all(10), icon: Icon(Icons.send,size: 30,))
        ],
      ),
    );
  }
}
