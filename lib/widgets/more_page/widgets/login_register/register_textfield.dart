import 'package:eqms_test/style/color_guide.dart';
import 'package:eqms_test/style/text_style.dart';
import 'package:flutter/material.dart';

class RegisterTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isValid;
  final String errorMessage;
  final String? hintText;
  final Function? onChanged;
  final bool isPassword;
  final TextInputType keyboardType;

  const RegisterTextField({
    Key? key, // Add this line
    required this.label,
    required this.controller,
    required this.isValid,
    required this.errorMessage,
    this.hintText,
    this.onChanged,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Text(label, style: kRegisterTextStyle),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: (text) {
                    if (onChanged != null) onChanged!(text);
                  },
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: hintText ?? label,
                    hintStyle: kHintTextStyle,
                    border: InputBorder.none,
                  ),
                  keyboardType: keyboardType,
                  obscureText: isPassword,
                ),
              ),
            ],
          ),
          if (!isValid)
            Positioned(
              right: 0,
              bottom: -2,
              child: Text(
                errorMessage,
                style: const TextStyle(color: secondaryRed),
              ),
            ),
        ],
      ),
    );
  }
}
