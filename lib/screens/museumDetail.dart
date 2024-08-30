import 'package:codesix/screens/ticketBooking.dart';
import 'package:flutter/material.dart';

class MuseumDetail extends StatelessWidget {
  const MuseumDetail({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Museum Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: "museum",
              child: Image.asset(
                "assets/images/nscdMuseum.jpg",
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'National Science Centre Delhi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'National Science Centre, Delhi is one of the largest Science Centre in Asia and it is popularly known amongst its visitors as, “A Dream Castle for One and All”. The iconic structure of the Centre is an exemplary landmark in the arena of modern architecture which is strategically located in the vicinity of the commercial exhibition hub of India i.e. Pragati Maidan Complex. The Annual footfall to the Centre is more than half a million visitors. Nobel Laureates, Eminent Scientists & Technocrats, Astronauts, Museum Professionals and many more luminaries from various fields are its regular visitors. The primary objective of the Centre is to engage , educate and entertain the visitors through thematic exhibitions, interactive educational activities and outreach programmes.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black),
                      fixedSize: MaterialStatePropertyAll(
                        Size(screenSize.width, screenSize.height * 0.07),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketBookingPage(),
                        ),
                      );
                    },
                    child: Text("Book now"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
