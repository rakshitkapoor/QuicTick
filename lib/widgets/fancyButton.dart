import 'package:flutter/material.dart';

class FancyBookButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FancyBookButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [            
            Text(
              'Book Tickets Now',
              style: TextStyle(fontSize: 18,color: Colors.white),
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}