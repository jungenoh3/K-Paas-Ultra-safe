import 'package:eqms_test/api/firebase_message.dart';
import 'package:eqms_test/widgets/eq_occur/eq_ocuur.dart';
import 'package:eqms_test/widgets/initial_page/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessageApi(navigatorKey: navigatorKey).initNotifications();

  // android 환경의 java.lang.NullPointerException 오류 해결
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
    mapsImplementation.initializeWithRenderer(AndroidMapRenderer.latest);
  }

  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    //잠시 알림앱 개발을 위해 이렇게 해놓음.
    home: const SplashScreen(),
    // home: const EqOccur(),
    routes: {
      '/eqoccur': (context) => EqOccur(messageData: null,),
    },
    debugShowCheckedModeBanner: false,
  ));
}
