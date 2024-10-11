import 'dart:convert';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:codesix/constants/dummyList.dart';
import 'package:codesix/screens/dashboard.dart';
import 'package:codesix/screens/ticketBooking.dart';
import 'package:codesix/widgets/appDrawer.dart';
import 'package:codesix/widgets/customIconContainer.dart';
import 'package:codesix/widgets/fancyButton.dart';
import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:custom_qr_generator/qr_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:codesix/widgets/own_message_card.dart';
import 'package:codesix/widgets/reply_message_card.dart';
import 'package:codesix/widgets/glassmorphism.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// import 'package:codesix/services/chat_service.dart'; // You'll need to create this

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _chatMessages = [];
  bool _isTyping = false;
  bool intentFound = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool showTicketsNow = false;
  bool _isPaymentProcessed = false;
  late Razorpay _razorpay;
    String _randomNumbers = '';
  String? storedRandomNumber;
  late var ticket_info;

  @override
  void initState() {
    super.initState();
    // Initialize with a welcome message
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInSine,
    ));
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

    void _handlePaymentSuccess(PaymentSuccessResponse response) {
    var screenSize = MediaQuery.of(context).size;
    if (!_isPaymentProcessed) {
      _isPaymentProcessed = true;
      _generateRandomNumbers();
      print("Payment Success");
      print("Random Number: $storedRandomNumber");

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: screenSize.width,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min, // Set this to take minimum vertical space
              children: <Widget>[
                Text(
                  'Booking Confirmation',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Container(
                  child: CustomPaint(
                    painter: QrPainter(
                      data: _randomNumbers,
                      options: const QrOptions(
                        shapes: QrShapes(
                          darkPixel:
                              QrPixelShapeRoundCorners(cornerFraction: 0.05),
                          frame: QrFrameShapeCircle(),
                          ball: QrBallShapeCircle(),
                        ),
                        colors: QrColors(
                          dark: QrColorSolid(Colors.black),
                          light: QrColorSolid(Colors.black),
                        ),
                      ),
                    ),
                    size: const Size(150, 150),
                  ),
                ),
                Text("Venue: ${ticket_info['museum_location']}"),
                Text(
                    "Date: ${ticket_info['visit_date']}"),
                FilledButton(
                  onPressed: () async{
                    await _PostTicket(_randomNumbers);
                     Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dashboard(),
                        ));
                  },
                  child: const Text("Okay"),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed! Please try again.')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  void _generateRandomNumbers() {
    print("Generating Random Number");
    final _random = Random();
    _randomNumbers =
        (_random.nextInt(900000) + 1000000).toString(); // 7-digit string
    storedRandomNumber = _randomNumbers; // store the generated random number
    print("Random Number Generated: $storedRandomNumber");
  }

    Future<void> _PostTicket(String key) async {
    try {
      // Post the ticket details to the server
      final response = await http.post(
        Uri.parse("http://192.168.1.5:8000/api/tickets/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": 1,
          "user": "rakshit",
          "qr_code": key,
          "slot": 2,
          "venue": ticket_info['museum_location'],
        }),
      );

      // Handle the HTTP response
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        print('Ticket posted successfully: ${response.body}');
      } else {
        // If the server returns an error response, throw an exception
        print('Failed to post ticket: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle any errors that occur during the HTTP request
      print('Error posting ticket: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
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
        Uri.parse("http://192.168.1.5:5000/process"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'input_string': req}),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print("Body: ${responseData['ticket']}");
        // check for tickets in the response
        if (responseData.containsKey('ticket')) {
          ticket_info=responseData['ticket'];
          _showConfirmation(responseData['ticket']);
        }
        if (!responseData.containsKey('output')) {
          throw Exception("Response not found");
        }
        // print("Response: ${responseData['intent']}");
        if (responseData['intent'] == 'book_ticket' ||
            responseData['intent'] == 'parchi_kaatna') intentFound = true;
        setState(() {
          _chatMessages.add({
            'msg': responseData['output'],
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

  void _showConfirmation(dynamic ticket) {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: screenSize.width,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min, // Set this to take minimum vertical space
            children: <Widget>[
              Text(
                'Booking Confirmation',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 16),
              Text(
                'Venue: ${ticket['museum_location']}',
              ),
              SizedBox(height: 16),
              Text(
                'Visit Date: ${ticket['visit_date']}',
              ),
              // SizedBox(height: 16),
              Text(
                'Ticket: ${ticket['ticket_type']}',
              ),
              // SizedBox(height: 16),
              Text(
                'Amount/ticket: ₹70',
              ),
              // Text('Time: ${selectedTime!.format(context)}'),
              // SizedBox(height: 16),
              // Text('Tickets:'),
              // Text(bookingSummary),
              // SizedBox(height: 16),
              FilledButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                      Size(screenSize.width * 0.9, screenSize.width * 0.13)),
                ),
                child: Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _isPaymentProcessed = false;
                  var options = {
                    'key': 'rzp_test_Y821RY8RBBNuvj',
                    'amount': 70,
                    'currency': 'INR',
                    'name': 'Acme Corp.',
                    'description': 'Fine T-Shirt',
                    'prefill': {
                      'contact': '9625232065',
                      'email': 'test@razorpay.com'
                    }
                  };
                  _razorpay.open(options);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Booking successful!')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_chatMessages);
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text("New Chat"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _chatMessages.isEmpty
                      ? SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: screenSize.height -
                                  AppBar().preferredSize.height -
                                  MediaQuery.of(context).padding.top -
                                  MediaQuery.of(context).viewInsets.bottom -
                                  100, // Approximate height of input area
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LottieBuilder.network(
                                    "https://lottie.host/3fa0d2f7-a3ba-4bad-a89a-405cead743ad/DdlGxRptf0.json",
                                    repeat: true,
                                  ),
                                  const SizedBox(height: 20),
                                  TyperAnimatedTextKit(
                                    text: const [
                                      'How may I help you?',
                                      "Show me my bookings",
                                      "Nearby Attractions",
                                      "Book tickets!",
                                      "What's the cost of Tickets"
                                    ],
                                    textStyle: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _chatMessages.length,
                          itemBuilder: (context, index) {
                            return _chatMessages[index]['chatIndex'] == 0
                                ? OwnMessageCard(
                                    message: _chatMessages[index]['msg'])
                                : ReplyMessageCard(
                                    message: _chatMessages[index]['msg']);
                          },
                        ),
                  if (intentFound)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom:
                          60, // Adjust this value to position the button above the input area
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FancyBookButton(
                            onPressed: () {
                              intentFound = false;
                              // Navigate to booking screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TicketBookingPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
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
            ),
          ],
        ),
      ),
    );
  }
}
