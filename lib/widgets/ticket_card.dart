import 'package:codesix/constants/museum_list.dart';
import 'package:codesix/models/museum_model.dart';
import 'package:codesix/models/ticket_model.dart';
import 'package:codesix/widgets/Qr_widget.dart';
import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:custom_qr_generator/qr_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class TicketCard extends StatefulWidget {
  final Ticket ticket;

  const TicketCard({Key? key, required this.ticket}) : super(key: key);

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  Museum _getMusuemByName(String name) {
    return museums.firstWhere((musuem) => musuem.name == name);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var museum = _getMusuemByName(widget.ticket.venue);

    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 8.0,
      child: Stack(
        children: [
          // Background image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              museum.imagePath,
              fit: BoxFit.cover,
              height: screenSize.height * 0.19,
              width: double.infinity,
            ),
          ),
          Container(
            height: screenSize.height * 0.19,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),

          ExpansionTile(
            collapsedTextColor: Colors.white,
            collapsedIconColor: Colors.white,
            childrenPadding: const EdgeInsets.all(3),
            textColor: Colors.teal.shade100,
            iconColor: Colors.teal.shade100,
            enableFeedback: true,
          
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.qr_code),
                SizedBox(width: screenSize.width * 0.01),
                Text(
                  "View Ticket",
                  style: TextStyle(fontSize: screenSize.height * 0.018),
                ),
              ],
            ),
          
            title: Text(
              widget.ticket.venue,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            // collapsedBackgroundColor: Colors.white,
            visualDensity: VisualDensity.comfortable,
            children: [
              Container(
                height: screenSize.height * 0.12,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name: ${widget.ticket.user}"),
                          Text("Venue: ${widget.ticket.venue}")
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: qr_widget(
                        qr_key: widget.ticket.key,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
