import 'package:codesix/screens/aboutUs.dart';
import 'package:codesix/screens/chatBotScreen.dart';
import 'package:codesix/screens/exploreMuseums.dart';
import 'package:codesix/screens/faqScreen.dart';
import 'package:codesix/screens/myBookings.dart';
import 'package:codesix/widgets/glassMorphism.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  Map<String, String> exporeMap = {
    'Museums': "Explore all the museums across the country",
    'My Bookings': "View your upcoming & past booking",
    'About Us': "Learn more about our mission.",
    'FAQ': "Find answers to common questions."
  };

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("DashBoard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rakshit Kapoor",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const Text(
                      "@rakshitKapoor1305",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(width: screenSize.width * 0.05),
                Image.asset("assets/images/user.png"),
              ],
            ),
            SizedBox(
              height: screenSize.height * 0.01,
            ),
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
                      builder: (context) => ChatBotScreen(),
                    ));
              },
              child: Text(
                "Talk to ChatBot",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.05,
            ),
            Text(
              "Explore",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),

            // grid view

            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemCount: 4,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () {
                    switch (index) {
                      case 0:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExploreMuseums(),
                          ),
                        );
                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyBookings(),
                          ),
                        );
                      case 2:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutUs(),
                          ),
                        );
                      case 3:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FaqScreen(),
                          ),
                        );
                    }
                  },
                  child: GlassmorphicContainer(
                    borderRadius: 25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/explore$index.png",
                                scale: 1.8,
                                filterQuality: FilterQuality.high,
                              ),
                              SizedBox(height: screenSize.height * 0.01),
                              Text(
                                exporeMap.keys.elementAt(index),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              SizedBox(height: screenSize.height * 0.002),
                              Text(
                                exporeMap.values.elementAt(index),
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
