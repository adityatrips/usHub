import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key, required this.text, required this.desc});

  final String text;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 13, 71, 161),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              text.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              desc,
              style: const TextStyle(
                fontSize: 14,
                letterSpacing: 0.1,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
