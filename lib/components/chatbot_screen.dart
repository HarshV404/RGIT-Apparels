import 'package:flutter/material.dart';
import 'dart:async';

class ChatbotScreen extends StatefulWidget {
  // Add the onSendMessage callback
  final Function(String) onSendMessage;

  const ChatbotScreen({
    super.key, 
    required this.onSendMessage,
  });

  @override
  ChatbotScreenState createState() => ChatbotScreenState();
}

class ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage("Hi there! 👋 I'm your fashion assistant. How can I help you today? You can ask me about products, sizes, orders, or get style advice!");
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    
    _textController.clear();
    
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
      ));
      _isTyping = true;
    });
    
    // Call the onSendMessage callback to notify parent component
    widget.onSendMessage(text);
    
    // Scroll to bottom after adding user message
    _scrollToBottom();
    
    // Process the message and respond
    _processMessage(text);
  }

  void _processMessage(String text) {
    // Simulate typing delay
    Timer(const Duration(milliseconds: 800), () {
      String response = _generateResponse(text.toLowerCase());
      
      setState(() {
        _isTyping = false;
        _addBotMessage(response);
      });
      
      // Scroll to bottom after adding bot message
      _scrollToBottom();
    });
  }

  void _addBotMessage(String message) {
    _messages.add(ChatMessage(
      text: message,
      isUser: false,
    ));
  }

  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _generateResponse(String query) {
    // Simple rule-based responses
    if (query.contains('hello') || query.contains('hi') || query.contains('hey')) {
      return 'Hello! How can I help you with your fashion needs today?';
    } else if (query.contains('help')) {
      return 'I can help you with finding products, checking sizes, tracking orders, returns policy, or giving style advice. What do you need assistance with?';
    } else if (query.contains('size') || query.contains('fit')) {
      return 'Our app has a size guide for each product. For the most accurate fit, check your measurements against our size chart. Would you like me to show you how to find the size guide?';
    } else if (query.contains('return') || query.contains('exchange')) {
      return 'We offer free returns within 30 days of purchase. You can initiate a return from your order history section. Would you like me to guide you through the return process?';
    } else if (query.contains('delivery') || query.contains('shipping')) {
      return 'Standard shipping takes 3-5 business days. Express shipping is available for 1-2 day delivery. You can check your order status in the "My Orders" section. Need help finding it?';
    } else if (query.contains('payment') || query.contains('pay')) {
      return 'We accept credit/debit cards, PayPal, Apple Pay, and Google Pay. All transactions are secure and encrypted. Is there a specific payment method you\'d like to know more about?';
    } else if (query.contains('discount') || query.contains('coupon') || query.contains('promo')) {
      return 'You can enter promo codes at checkout. Sign up for our newsletter to receive a 10% discount on your first purchase! Would you like me to help you find current promotions?';
    } else if (query.contains('order') && query.contains('track')) {
      return 'You can track your order in the "My Orders" section. Would you like me to help you navigate there?';
    } else if (query.contains('cancel') && query.contains('order')) {
      return 'Orders can be canceled within 1 hour of placing them. After that, you\'ll need to wait for delivery and then return the items. Would you like to cancel a recent order?';
    } else if (query.contains('style') || query.contains('outfit') || query.contains('fashion')) {
      return 'I\'d be happy to help with style advice! Tell me what occasion you\'re shopping for, or your preferred styles, and I can make some recommendations.';
    } else if (query.contains('jeans') || query.contains('denim')) {
      return 'We have a great selection of jeans! Popular styles include skinny, straight leg, and boyfriend cuts. What style or fit are you looking for?';
    } else if (query.contains('dress')) {
      return 'Our dresses collection includes casual, formal, and everything in between! Are you looking for something specific like a maxi dress, cocktail dress, or summer dress?';
    } else if (query.contains('shoes') || query.contains('footwear')) {
      return 'Our footwear section includes sneakers, boots, heels, and flats. What type of shoes are you interested in?';
    } else if (query.contains('accessory') || query.contains('accessories') || query.contains('jewelry')) {
      return 'We have a wide range of accessories including bags, jewelry, belts, and scarves to complete your look. What kind of accessories are you looking for?';
    } else if (query.contains('sale') || query.contains('clearance')) {
      return 'Check out our "Sale" section for the latest discounts! We update it regularly with seasonal markdowns. Would you like me to help you navigate to the sale items?';
    } else if (query.contains('thanks') || query.contains('thank you')) {
      return 'You\'re welcome! Is there anything else I can help you with today?';
    } else if (query.contains('bye') || query.contains('goodbye')) {
      return 'Thanks for chatting! Feel free to come back anytime you need fashion advice or shopping assistance. Happy shopping!';
    } else {
      return 'I\'m not sure I understand. Could you rephrase that or ask about our products, sizes, orders, returns, or style advice?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(8.0),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return _messages[index];
            },
          ),
        ),
        if (_isTyping)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Typing...",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        const Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: _buildTextComposer(),
        ),
      ],
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration(
                hintText: "Ask me anything...",
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color(0xFFEEEEEE),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: () => _handleSubmitted(_textController.text),
            mini: true,
            elevation: 0,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          const SizedBox(width: 8.0),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue : const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          if (isUser) _buildUserIcon(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return const CircleAvatar(
      backgroundColor: Colors.blue,
      child: Icon(
        Icons.support_agent,
        color: Colors.white,
      ),
    );
  }

  Widget _buildUserIcon() {
    return const CircleAvatar(
      backgroundColor: Colors.grey,
      child: Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }
}