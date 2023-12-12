import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SensorDescription extends StatelessWidget {
  final String title;
  final int numOfSensors;

  const SensorDescription({
    Key? key,
    required this.title,
    required this.numOfSensors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical:10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 45),
            Align(
              alignment: Alignment.bottomRight,
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: NumberFormat('#,##0').format(numOfSensors),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black), // Adjust style as needed
                    ),
                    const TextSpan(
                      text: '개',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black), // Adjust style as needed
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
