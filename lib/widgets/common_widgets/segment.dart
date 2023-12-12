import 'package:eqms_test/style/color_guide.dart';
import 'package:flutter/material.dart';

class SegmentH extends StatelessWidget {
  final double size;
  const SegmentH({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: lightGray1_5,
      ),
    );
  }
}

class SegmentV extends StatelessWidget {
  final double size;
  const SegmentV(
      {Key? key,
        required this.size})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height :size,
      width: 2,
      decoration: const BoxDecoration(
          color: lightGray1_5
      ),
    );
  }
}
