import 'dart:convert';

import 'package:codesix/constants/dummyList.dart';
import 'package:codesix/widgets/appDrawer.dart';
import 'package:codesix/widgets/customIconContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:codesix/widgets/own_message_card.dart';
import 'package:codesix/widgets/reply_message_card.dart';
import 'package:codesix/widgets/glassmorphism.dart';
import 'package:http/http.dart' as http;

// import 'package:codesix/services/chat_service.dart'; // You'll need to create this

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _chatMessages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Initialize with a welcome message
    _getBotResponse("Welcome");
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final userMessage = _textController.text;
    setState(() {
      _chatMessages.add({
        'msg': userMessage,
        'chatIndex': 0,
      });
      _isTyping = true;
    });

    _textController.clear();
    _scrollToBottom();

    // Call the API with the user's message
    await _getBotResponse(userMessage);

    setState(() {
      _isTyping = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _getBotResponse(String req) async {
    try {
      http.Response response = await http.post(
        Uri.parse("http://10.12.46.204:5000/process"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'input_string': req}),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          _chatMessages.add({
            'msg': responseData['processed_string'],
            'chatIndex': 1,
          });
        });
      } else {
        throw Exception('Failed to get response from the server');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _chatMessages.add({
          'msg': "Sorry, I couldn't process your request. Please try again.",
          'chatIndex': 1,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text("New Chat"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  return _chatMessages[index]['chatIndex'] == 0
                      ? OwnMessageCard(message: _chatMessages[index]['msg'])
                      : ReplyMessageCard(message: _chatMessages[index]['msg']);
                },
              ),
            ),
            if (_isTyping)
              SpinKitThreeBounce(
                color: Colors.black,
                size: screenSize.width * 0.045,
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: GlassmorphicContainer(
                      padding: 3,
                      child: TextFormField(
                        controller: _textController,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          hintText: "Type a message",
                          prefixIcon: CustomIconContainer(iconData: Icons.add),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _sendMessage,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}