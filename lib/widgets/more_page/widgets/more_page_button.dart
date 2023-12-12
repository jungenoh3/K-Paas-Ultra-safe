import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // add to open web browser
import '../../../style/color_guide.dart';
import '../../../style/text_style.dart';
import 'dart:io';
class MorePageButton extends StatelessWidget {
  // Change to StatelessWidget
  final String title;
  final Widget? route;
  final Uri? url;
  final bool? isLoggedIn;
  final VoidCallback? logoutFunction;

  const MorePageButton(
      {Key? key,
      required this.title,
      this.route,
      this.url,
      this.isLoggedIn,
      this.logoutFunction})
      : super(key: key);


  Future<void> _launchUrl(Uri url) async {
    LaunchMode mode;

    if (Platform.isAndroid) {
      mode = LaunchMode.externalNonBrowserApplication; // Mode for Android
    } else if (Platform.isIOS) {
      mode = LaunchMode.inAppWebView; // Mode for iOS
    } else {
      throw Exception('Platform not supported');
    }

    if (!await launchUrl(url, mode: mode)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          if (route != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => route!,
              ),
            );
          } else if (url != null) {
            _launchUrl(url!);
          } else if (logoutFunction != null) {
            logoutFunction!(); // Call the logout function if it exists
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  if (isLoggedIn == true)
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: mediumGray),
                            borderRadius: BorderRadius.circular(100)),
                        child: const Icon(Icons.person,size: 30,)),
                  if (isLoggedIn == true) const SizedBox(width: 10),
                  Text(title, style: kMorePageTitleTextStyle),
                ],
              ),
              if (isLoggedIn != true) const Icon(Icons.arrow_forward_ios, size: 12),
            ],
          ),
        ),
      ),
    );
  }
}
