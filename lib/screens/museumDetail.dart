import 'package:codesix/models/museum_model.dart';
import 'package:codesix/screens/ticketBooking.dart';
import 'package:flutter/material.dart';

class MuseumDetail extends StatelessWidget {
  const MuseumDetail({super.key,required this.museum});
  final Museum museum;
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
              key: key,
              tag: "museum",
              child: Image.asset(
                museum.imagePath,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    museum.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                   Text(
                    museum.desc,
                    style: const TextStyle(fontSize: 16),
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
                          builder: (context) => TicketBookingPage(museum: museum.name,),
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
