import 'package:codesix/screens/museumDetail.dart';
import 'package:codesix/widgets/MuseumCard.dart';
import 'package:flutter/material.dart';

class Museum {
  final String name;
  final String imagePath;

  Museum({required this.name, required this.imagePath});
}

class ExploreMuseums extends StatelessWidget {
  ExploreMuseums({Key? key}) : super(key: key);

  final List<Museum> museums = [
    Museum(
      name: "National Science Centre Delhi",
      imagePath: "assets/images/nscdMuseum.jpg",
    ),
    Museum(name: "National Railway Museum", imagePath: "assets/images/Railway.jpg"),
    Museum(name: "Victoria Memorial Hall, Kolkata",imagePath: "assets/images/VictoriaHall.jpg")
    // Add more museums here in the future
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore Museums"),
      ),
      body: ListView.builder(
        itemCount: museums.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MuseumDetail(),),);
            },
            child: MuseumCard(
              museum: museums[index],
            ),
          );
        },
      ),
    );
  }
}
