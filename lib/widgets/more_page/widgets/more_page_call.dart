import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../style/color_guide.dart';
import '../../../style/text_style.dart';

class MorePageCall extends StatelessWidget {
  const MorePageCall({Key? key}):super(key: key);
  final String _phone = '0539506447'; // Replace with your desired phone number.


  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri).then((value) {
      print('Phone call initiated successfully!');
    }).catchError((error) {
      print('Error initiating phone call: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _makePhoneCall(_phone);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(color: lightGray1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.call),
                SizedBox(width: 5),
                Text('문의전화', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text('평일 09:00 ~ 18:00', style: kMorePageRemainTextStyle),
      ],
    );
  }
}
