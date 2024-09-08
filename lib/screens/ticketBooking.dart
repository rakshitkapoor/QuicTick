import 'dart:convert';
import 'dart:math';
import 'package:codesix/constants/museum_list.dart';
import 'package:codesix/screens/dashboard.dart';
import 'package:codesix/widgets/appDrawer.dart';
import 'package:codesix/widgets/glassMorphism.dart';
import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class TicketBookingPage extends StatefulWidget {
  const TicketBookingPage({Key? key,this.museum}) : super(key: key);
  final String? museum;
  @override
  _TicketBookingPageState createState() => _TicketBookingPageState();
}

class _TicketBookingPageState extends State<TicketBookingPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  var totalAmount = 0.0;
  String _randomNumbers = '';
  String? storedRandomNumber;
  late Razorpay _razorpay;
  bool _isPaymentProcessed = false;

  final Map<String, double> ticketPrices = {
    'General Entry': 70,
    'General Entry (Group >25)': 60,
    'General Entry (BPL Card)': 20,
    'Students Entry (School Group)': 25,
    'Students Entry (Govt/MCD School)': 10,
    '3D Film': 40,
    'SDL/Taramandal (Adult)': 20,
    'SDL/Taramandal (Children)': 20,
    'SOS Entry (Adult)': 50,
    'Holoshow Entry (Adult)': 40,
    'Fantasy Ride': 80,
    'Package (All Inclusive)': 250,
  };

  Map<String, int> ticketQuantities = {};

  @override
  void initState() {
    super.initState();
    ticketQuantities =
        Map.fromIterable(ticketPrices.keys, key: (k) => k, value: (_) => 0);
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
                Text("Venue: National Science Centre, Delhi"),
                Text(
                    "Date: ${DateFormat('EEEE, MMM d, yyyy').format(selectedDate!)}"),
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

  @override
  Widget build(BuildContext context) {
    print(DateTime.utc);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Book Museum Tickets'),
        elevation: 2,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildDatePicker(),
                    SizedBox(height: 16),
                    _buildTimePicker(),
                    SizedBox(height: 24),
                    Text(
                      'Select Tickets',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _buildTicketList().length,
                        itemBuilder: (context, index) {
                          return _buildTicketList()[index];
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    // Have to take input on which dates are free
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Select Date',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          selectedDate != null
              ? DateFormat('EEEE, MMM d, yyyy').format(selectedDate!)
              : 'Tap to select date',
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && _isTimeValid(picked)) {
      setState(() {
        selectedTime = picked;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a time after the current time.')),
      );
    }
  }

  bool _isTimeValid(TimeOfDay picked) {
    final now = TimeOfDay.now();
    if (picked.hour > now.hour ||
        (picked.hour == now.hour && picked.minute > now.minute)) {
      return true;
    }
    return false;
  }

  Widget _buildTimePicker() {
    return InkWell(
      onTap: () => _selectTime(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Select Time',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.access_time),
        ),
        child: Text(
          selectedTime != null
              ? selectedTime!.format(context)
              : 'Tap to select time',
        ),
      ),
    );
  }

  List<Widget> _buildTicketList() {
    return ticketPrices.entries.map((entry) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.key,
                        style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 4),
                    Text('₹${entry.value.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: ticketQuantities[entry.key] == 0
                        ? null
                        : () {
                            setState(() {
                              ticketQuantities[entry.key] =
                                  ticketQuantities[entry.key]! - 1;
                            });
                          },
                  ),
                  Text('${ticketQuantities[entry.key]}',
                      style: Theme.of(context).textTheme.titleMedium),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        ticketQuantities[entry.key] =
                            ticketQuantities[entry.key]! + 1;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildBottomBar() {
    double totalPrice = ticketPrices.entries.fold(
        0, (sum, entry) => sum + (entry.value * ticketQuantities[entry.key]!));
    totalAmount = totalPrice;
    return GlassmorphicContainer(
      blurStrength: 10,
      bgColor: Colors.teal,
      padding: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total: ₹${totalPrice.toStringAsFixed(2)}',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.black),
          ),
          FilledButton.tonalIcon(
            icon: Icon(Icons.arrow_outward),
            onPressed: _bookTickets,
            label: Text("Book Now"),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _PostTicket(String key) async {
    try {
      // Generate the current date and time in the required format
      String bookedAt = DateTime.now().toUtc().toIso8601String() + 'Z';

      // Post the ticket details to the server
      final response = await http.post(
        Uri.parse("http://192.168.1.5:8000/api/tickets/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": 1,
          "user": "rakshit",
          "booked_at": bookedAt,
          "qr_code": key,
          "slot": 2,
          "venue": widget.museum
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

  void _bookTickets() {
    var screenSize = MediaQuery.of(context).size;
    if (_formKey.currentState!.validate() ||
        selectedDate == null ||
        selectedTime == null) {
      // Ensure at least one ticket is selected
      if (ticketQuantities.values.every((quantity) => quantity == 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select at least one ticket')),
        );
        return;
      }

      // TODO: Implement booking logic
      String bookingSummary = ticketQuantities.entries
          .where((entry) => entry.value > 0)
          .map((entry) => '${entry.key}: ${entry.value}')
          .join('\n');

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
                  'Date: ${DateFormat('EEEE, MMM d, yyyy').format(selectedDate!)}',
                ),
                Text('Time: ${selectedTime!.format(context)}'),
                SizedBox(height: 16),
                Text('Tickets:'),
                Text(bookingSummary),
                SizedBox(height: 16),
                FilledButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                        Size(screenSize.width * 0.9, screenSize.width * 0.13)),
                  ),
                  child: Text('Confirm'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _isPaymentProcessed = false;
                    print("Amount: $totalAmount");
                    var options = {
                      'key': 'rzp_test_Y821RY8RBBNuvj',
                      'amount': totalAmount * 100,
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }
}
