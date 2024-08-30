import 'package:codesix/widgets/appDrawer.dart';
import 'package:codesix/widgets/glassMorphism.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketBookingPage extends StatefulWidget {
  const TicketBookingPage({Key? key}) : super(key: key);

  @override
  _TicketBookingPageState createState() => _TicketBookingPageState();
}

class _TicketBookingPageState extends State<TicketBookingPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

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
  }

  @override
  Widget build(BuildContext context) {
    print(ticketQuantities);
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
                      style: Theme.of(context).textTheme.headline6,
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _bookTickets() {
    var screenSize=MediaQuery.of(context).size;
    if (_formKey.currentState!.validate()) {
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
                  style: Theme.of(context).textTheme.headline6,
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
                  style: ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(screenSize.width*0.9,screenSize.width*0.13))),
                  child: Text('Confirm'),
                  onPressed: () {
                    Navigator.of(context).pop();
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
}
