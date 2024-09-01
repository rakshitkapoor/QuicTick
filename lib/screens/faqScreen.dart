import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<FAQItem> _faqList = [
    FAQItem(
      question: "How do I book tickets using the chatbot?",
      answer: "To book tickets, simply start a conversation with our chatbot. Tell it which museum you'd like to visit and when. The chatbot will guide you through the process, asking for necessary information and helping you complete your booking.",
    ),
    FAQItem(
      question: "Which national museums are available for booking?",
      answer: "Our app caters to all national museums in the country. This includes major institutions like the National Museum of History, the National Art Gallery, and the National Science Museum. The chatbot can provide you with a full list of available museums.",
    ),
    FAQItem(
      question: "Can I book tickets for a group?",
      answer: "Yes, you can book tickets for groups. When chatting with the bot, simply mention that you're booking for a group and specify the number of people. The bot will guide you through the group booking process.",
    ),
    FAQItem(
      question: "How far in advance can I book tickets?",
      answer: "Typically, you can book tickets up to 3 months in advance. However, this may vary for special exhibitions or events. The chatbot can provide you with specific information for your chosen museum and date.",
    ),
    FAQItem(
      question: "What if I need to cancel or change my booking?",
      answer: "To cancel or modify your booking, start a new conversation with the chatbot and mention that you need to change an existing booking. The bot will ask for your booking reference and guide you through the process.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ExpansionPanelList(
                elevation: 1,
                expandedHeaderPadding: EdgeInsets.zero,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _faqList[index].isExpanded = isExpanded;
                  });
                },
                children: _faqList.map<ExpansionPanel>((FAQItem item) {
                  return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          item.question,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(item.answer),
                    ),
                    isExpanded: item.isExpanded,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQItem {
  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  String question;
  String answer;
  bool isExpanded;
}
