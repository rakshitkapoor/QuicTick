import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({required this.message, super.key});
  final message;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width - 45,
            ),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              color: Colors.teal[50],
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
                    child: Row(
                      children: [
                        Text(
                          DateFormat('hh:mm a').format(DateTime.now()),
                          style: Theme.of(context).textTheme.labelSmall!,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.done_all),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
                Icon(Icons.person), 
      ],
    );
  }
}