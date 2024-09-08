import 'dart:convert';

import 'package:codesix/models/ticket_model.dart';
import 'package:codesix/widgets/ticket_card.dart';
import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class MyBookings extends StatefulWidget {
  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  final List<Ticket> tickets = [
    // Ticket(
    //   user: 'rakshit'
    //   key: '123456',
    //   venue: 'National Science Centre, Delhi',
    //   date: DateTime.now().add(Duration(days: 2)),
    // ),
    // Ticket(
    //   key: '789012',
    //   venue: 'National Museum, New Delhi',
    //   date: DateTime.now().add(Duration(days: 5)),
    // ),
    // Add more tickets as needed
  ];

  @override
  void initState() {
    super.initState();
    _getTickets();
  }

  Future<void> _getTickets() async {
    http.Response response = await http.get(
      Uri.parse("http://192.168.1.5:8000/api/tickets"),
    );
    final responseData = jsonDecode(response.body);
    print("Tickets Data: ${responseData}");

    for (var data in responseData) {
      if (data['qr_code'] != null) {
        tickets.add(Ticket(data['user'], data['slot'],
            key: data['qr_code'],
            venue: "National Science Museum",
            date: DateTime.now().add(Duration(days: 2))));
      }
    }
    print("Final Tickets List: ");
    for (var ticket in tickets) {
      print(ticket.user + " " + ticket.key + " " + ticket.slot.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tickets'),
      ),
      body: (tickets.isEmpty)
          ? Center(
              child: LottieBuilder.network(
                "https://lottie.host/9f1cd1bc-2a49-409b-8fb0-a66e23f2a755/nAmyxB8JtI.json",
                repeat: false,
                frameRate: FrameRate(30),
              ),
            )
          : ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return TicketCard(ticket: tickets[index]);
              },
            ),
    );
  }
}
