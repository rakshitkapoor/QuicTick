import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyBookings extends StatelessWidget {
  final List<Ticket> tickets = [
    Ticket(
      qrData: '123456',
      venue: 'National Science Centre, Delhi',
      date: DateTime.now().add(Duration(days: 2)),
    ),
    Ticket(
      qrData: '789012',
      venue: 'National Museum, New Delhi',
      date: DateTime.now().add(Duration(days: 5)),
    ),
    // Add more tickets as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tickets'),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return TicketCard(ticket: tickets[index]);
        },
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final Ticket ticket;

  const TicketCard({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                  child: CustomPaint(
                    painter: QrPainter(
                      data: "321234",
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
            SizedBox(height: 16),
            Text(
              ticket.venue,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('EEEE, MMM d, yyyy').format(ticket.date)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class Ticket {
  final String qrData;
  final String venue;
  final DateTime date;

  Ticket({required this.qrData, required this.venue, required this.date});
}