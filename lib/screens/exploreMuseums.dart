import 'package:codesix/constants/museum_list.dart';
import 'package:codesix/screens/museumDetail.dart';
import 'package:codesix/widgets/MuseumCard.dart';
import 'package:flutter/material.dart';

class ExploreMuseums extends StatelessWidget {
  ExploreMuseums({Key? key}) : super(key: key);

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MuseumDetail(
                    museum: museums[index],
                  ),
                ),
              );
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
