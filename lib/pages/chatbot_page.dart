import 'package:flutter/material.dart';
import 'package:rgit_apparels/components/chatbot_screen.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fashion Assistant'),
        elevation: 0,
      ),
      body: ChatbotScreen(
        onSendMessage: (message) {
          // Handle sending message to the chatbot
          print("Message sent: $message");
        },
      ),
    );
  }
}