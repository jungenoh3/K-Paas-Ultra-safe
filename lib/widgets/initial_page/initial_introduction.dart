import 'package:eqms_test/widgets/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../style/color_guide.dart';


class InitialIntroduction extends StatefulWidget {
  const InitialIntroduction({Key? key}) : super(key: key);

  @override
  InitialIntroductionState createState() => InitialIntroductionState();
}

class InitialIntroductionState extends State<InitialIntroduction> {
  // Function to request notification permissions
  Future<void> savePermissionStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationPermission', status);

  }
  Future<void> saveAlarmStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAlarmenabled', status);

  }



  Future<void> requestNotificationPermission() async {
    await Permission.notification.request();
  }
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'images/Intro1.png',
      'images/Intro2.png',
      'images/Intro3.png',
      'images/Intro4.png',
      'images/Intro5.png',
      'images/Intro6.png',
    ];


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              flex:1,
                child:
            SizedBox()
            ),

            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Expanded(
                    child: CarouselSlider(
                      items: images.map((item) => Image.asset(item, fit: BoxFit.cover)).toList(),
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        height: double.infinity,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                  AnimatedSmoothIndicator(
                    activeIndex: selectedIndex,
                    count: images.length,
                    effect: const WormEffect(
                      activeDotColor: primaryOrange,
                      dotColor: mediumGray,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: primaryOrange,
                    shadowColor: Colors.transparent,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.7,
                      MediaQuery.of(context).size.height * 0.07,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        duration: const Duration(milliseconds: 1000),
                        child: const RootScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    '시작하기',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
