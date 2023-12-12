import 'package:eqms_test/widgets/root_screen.dart';
import 'package:flutter/material.dart';
import './initial_introduction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final String? routeName;
  const SplashScreen({Key? key, this.routeName}): super(key:key);
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late bool isFirstTime;
  String? get routeName => widget.routeName;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    navigateAfterSplash();
  }

  Future<void> setFirstTimeFalse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', false);
  }

  Future<void> navigateAfterSplash() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstTime = prefs.getBool('first_time') ?? true;

    Timer(
      const Duration(milliseconds: 2000),
          () async {
        if (isFirstTime) {
          await setFirstTimeFalse();

          _navigatorKey.currentState!.pushReplacement(PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 1000),
            child: const InitialIntroduction(),
          ));
        } else {
          if (routeName != null) {
            _navigatorKey.currentState!.pushReplacementNamed(routeName!);
          } else {
            _navigatorKey.currentState!.pushReplacement(PageTransition(
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 1000),
              child: const RootScreen(),
            ));
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const String imageLogoName = 'images/LOGO.png';
    const String labLogoName = 'images/초연결융합기술연구소로고세로.png';
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          home: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.27375),
                Image.asset(
                  imageLogoName,
                  width: double.infinity,
                  height: screenHeight * 0.30,
                ),
                const Expanded(child: SizedBox()),
                Image.asset(
                  labLogoName,
                  width: screenWidth * 0.516666,
                  height: screenHeight * 0.0759375,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    child: Text(
                      "© Copyright 2023, 초연결융합기술연구소",
                      style: TextStyle(
                        fontSize: screenWidth * (14 / 360),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0625,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
