import 'package:codesix/widgets/glassMorphism.dart';
import 'package:flutter/material.dart';

class ReplyMessageCard extends StatelessWidget {
  const ReplyMessageCard({required this.message, super.key});
  final message;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        Icon(Icons.assistant), 
        Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width - 45,
            ),
            child: GlassmorphicContainer( // Replace Card with GlassmorphismContainer
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 50,
                      top: 10,
                      bottom: 20,
                    ),
                    child: Text(message,
                        style: Theme.of(context).textTheme.bodyLarge!),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 10,
                    child: Text(
                      "8:30",
                      style: Theme.of(context).textTheme.labelMedium!,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
