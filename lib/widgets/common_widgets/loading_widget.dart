import 'package:flutter/material.dart';
import '../../style/color_guide.dart';
class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final TextStyle? loadingTextStyle;

  const LoadingIndicator({Key? key, this.color, this.loadingTextStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130, // Adjust to your need
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: color ?? primaryOrange,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Flexible(
            child: Text(
              'Loading...',
              style: loadingTextStyle ?? const TextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
