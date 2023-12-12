import 'package:flutter/material.dart';

class SensorButton extends StatelessWidget {
  final String title;
  final String target;
  final Widget route;

  const SensorButton({
    Key? key,
    required this.title,
    required this.target,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const Text(''),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(target),
                  const Icon(Icons.arrow_forward_ios, size: 12,)
                ],
              ),
              const Text(''),
            ],
          ),
        ),
      ),
    );
  }
}
