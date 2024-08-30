import 'package:codesix/screens/chatBotScreen.dart';
import 'package:codesix/screens/ticketBooking.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('ChatBot'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChatBotScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Ticket Booking'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TicketBookingPage()),
              );
            },
          ),
          // Add more ListTiles for more pages
        ],
      ),
    );
  }
}