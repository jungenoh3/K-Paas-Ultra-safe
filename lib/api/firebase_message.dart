import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eqms_test/Api/Retrofit/rest_client.dart';
import 'package:eqms_test/widgets/eq_occur/eq_ocuur.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('handleBackgroundMessage');

  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message?.data}');

}

class FirebaseMessageApi {
  final GlobalKey<NavigatorState> navigatorKey;
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final dio = Dio();
  late RestClient client = RestClient(dio);

  FirebaseMessageApi({required this.navigatorKey});

  void handleMessage(RemoteMessage? message){
    print('handleMessage');
    print('message:' + message.toString());

    if (message == null ){ return; }
    else {
      print('message: ${message}');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Payload: ${message?.data}');

      // 지금은 에러가 나서 닫았습니다.

      final navigator = navigatorKey.currentState;
      if (navigator != null) {
        // final routeName = '/eqoccur';
        navigator.push<Object>(
          MaterialPageRoute(builder: (BuildContext context) {
            return EqOccur(messageData: message.data,);
          })
        );
        // navigator.pushNamed(routeName); // 이걸로 지진 데이터 전달하기
      }
    }
  }

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  Future initLocalNotification() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher2');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
        settings,
        onDidReceiveNotificationResponse: (payload) {
          final message = RemoteMessage.fromMap(jsonDecode(payload.payload.toString()));
          handleMessage(message);
        }
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage); // terminated -> open
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage); // background -> open
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message data: ${message.data}');

      final notification = message.notification;
      if (notification == null) { return; }
      else {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                _androidChannel.id,
                _androidChannel.name,
                channelDescription: _androidChannel.description,
                icon: '@drawable/ic_launcher',
                // other properties...
              ),
              iOS: DarwinNotificationDetails()
          ),
          payload: jsonEncode(message.toMap()),
        );
      }
    });
  }

  Future<void> checkInitNotifiaction() async {
    final fcmToken = await _firebaseMessaging.getToken();
    print('Token: ${fcmToken}');

    String result = await client.postFcmToken(fcmToken!);

    if (result == "subscribed") {
      print("subscribed");
    } else if (result == "already subscribed") {
      print("already subscribed");
    }
    initPushNotifications();
    initLocalNotification();

    // final url = Uri.parse('http://-/FCMToken/check');
    // try {
    //   final http.Response response = await http.post(url, body: fCMToken)
    //       .timeout(const Duration(seconds: 10), onTimeout: () {
    //     throw TimeoutException('10초가 지났습니다.');
    //   });
    //
    //   if (response.statusCode >= 500) {
    //     print('Server error. Status code: ${response.statusCode}');
    //     return;
    //   }
    //
    //   final responseBody = response.body;
    //   if (responseBody == "subscribed") {
    //     print("subscribed");
    //   } else if (responseBody == "already subscribed") {
    //     print("already subscribed");
    //   }
    //   initPushNotifications();
    //   initLocalNotification();
    // } on TimeoutException catch (e) {
    //   print('Timeout Exception: $e');
    //   return;
    // } on SocketException catch (e) {
    //   print('Socket Exception. error code: $e');
    //   return;
    // }

  }

  Future<bool> _getAlarmSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAlarmEnabled') ?? true;
  }

  Future<void> initNotifications() async {
    bool isAlarmEnabled = await _getAlarmSetting();
    if (!isAlarmEnabled) {
      print('Notifications are disabled in settings.');
      return;
    }
    final isMessageEnabled = await _firebaseMessaging.requestPermission();
    if (isMessageEnabled.authorizationStatus == AuthorizationStatus.authorized ||
        isMessageEnabled.authorizationStatus == AuthorizationStatus.provisional) {
      print('메세지 권한이 허가되었습니다.');
      checkInitNotifiaction();
    } else {
      print('메세지 권한을 허가해주세요.');
    }
    return;
  }
}
