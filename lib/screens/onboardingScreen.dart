import 'package:codesix/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final Shader linearGradient1 = const LinearGradient(
      colors: <Color>[Colors.white, Colors.pink],
    ).createShader(const Rect.fromLTWH(0.0, 0, 400.0, 70.0));
    final Shader linearGradient2 = const LinearGradient(
      colors: <Color>[Colors.white, Colors.orange],
    ).createShader(const Rect.fromLTWH(0.0, 0, 300.0, 70.0));

    return Container(
      color: const Color.fromARGB(255, 32, 25, 41),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => linearGradient1,
            child: Text(
              "QuicTick",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: screenSize.height*0.03),
          
          Center(
            child: LottieBuilder.network(
              "https://lottie.host/eb34e134-4795-4366-b438-ef853f5d2d50/lynIeIHiUd.json",
              repeat: true,
              frameRate: FrameRate(30),
            ),
          ),

          FilledButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.green),
              fixedSize: MaterialStatePropertyAll(
                Size(screenSize.width * 0.5, screenSize.height * 0.07),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(),
                ),
              );
            },
            child: Row(
              children: [
                Text("Get Started Now"),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
