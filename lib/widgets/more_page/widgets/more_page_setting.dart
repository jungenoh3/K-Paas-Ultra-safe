import 'dart:io';
import 'package:eqms_test/style/color_guide.dart';
import 'package:eqms_test/style/text_style.dart';
import 'package:eqms_test/widgets/common_widgets/segment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class MorePageSetting extends StatefulWidget {
  const MorePageSetting({Key? key}) : super(key: key);

  @override
  MorePageSettingState createState() => MorePageSettingState();
}

class MorePageSettingState extends State<MorePageSetting> {
  late Future<bool?> isAlarmEnabledFuture;

  @override
  void initState() {
    super.initState();
    isAlarmEnabledFuture = _loadAlarmSetting();
  }

  Future<bool?> _loadAlarmSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAlarmenabled');
  }
  Future<bool> _loadPermissionStatus() async {
    PermissionStatus permissionStatus = await Permission.notification.status;
    print('${permissionStatus.isGranted}');
    // 권한이 부여된 경우 true를 반환하고 그렇지 않으면 false를 반환합니다.
    return permissionStatus.isGranted;
  }

  Future<void> _checkPermissionsAndSetAlarm(bool value) async {
    if (value) {
      bool hasPermissions = await _loadPermissionStatus();
      if (!hasPermissions) {
        _showPermissionDialog();
        return;
      }
    }

    bool? savedValue = await _saveAlarmSetting(value);

    setState(() {
      isAlarmEnabledFuture = Future.value(savedValue);
    });
  }

  Future<bool?> _saveAlarmSetting(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAlarmenabled', value);
    (() {
      isAlarmEnabledFuture = Future.value(value);
    });
    print('alarmEnabled${value}');
    return value;
  }

  Future<void> _showPermissionDialog() async {
    String message;
    if (Platform.isIOS) {
      message = 'ios 권한 설정을 통해 알림을 받을 수 있습니다.ios 설정 > 알림 > 지진안전정보(EQSI)에서 변경할 수 있습니다.';
    } else if (Platform.isAndroid) {
      message = '안드로이드 권한 설정을 통해 알림을 받을 수 있습니다. 설정 > 알림 > 지진안전정보(EQSI)에서 변경할 수 있습니다.';
    } else {
      message = '설정을 통해 알림을 받을 수 있습니다. 설정 > 알림 > 지진안전정보(EQSI)에서 변경할 수 있습니다.';
    }

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('알림받기', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(primaryBlack),
                      side: MaterialStateProperty.all(const BorderSide(color:  mediumGray, width: 0.5)),
                    ),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('닫기', style: TextStyle(fontSize: 17, color: primaryBlack)),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation:  MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(primaryOrange),
                      foregroundColor: MaterialStateProperty.all(primaryBlack),
                      side: MaterialStateProperty.all(const BorderSide(color: mediumGray, width: 0.5)),
                    ),
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();
                      if (Platform.isAndroid) {
                        const AndroidIntent intent = AndroidIntent(
                          action: 'action_application_details_settings',
                          data: 'package:com.example.eqms_test',
                        );
                        await intent.launch();
                      } else if (Platform.isIOS) {
                        final Uri url = Uri.parse('app-settings:');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      }
                    },
                    child: const Text('변경하러 가기', style: TextStyle(color: Colors.white, fontSize: 17)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('설정', style: kAppBarTitleTextStyle),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('지진 알림 설정', style: kAgreeTextStyle),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: const TextSpan(
                          style:
                              kMorePageTitleTextStyle, // Default style for the entire text
                          children: <TextSpan>[
                            TextSpan(
                                text: '센서를 통해 국내에서 감지되는 ',
                                style: kSettingDescriptionTextStyle),
                            TextSpan(
                              text: '규모 3.0 이상',
                              style: TextStyle(
                                  color:
                                      primaryOrange), // Your desired color for this part
                            ),
                            TextSpan(
                                text: ' 지진에 대한 지진 알림서비스를 제공합니다.',
                                style: kSettingDescriptionTextStyle),
                          ],
                        ),
                      ),
                      FutureBuilder<bool?>(
                        future: isAlarmEnabledFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) { // 여기서 LoadingWidget는 로딩 중을 나타내는 위젯이어야 합니다.
                          }
                          bool isAlarmEnabled = snapshot.data ?? true;
                          return Align(
                            alignment: Alignment.topRight,
                            child: CupertinoSwitch(
                              value: isAlarmEnabled,
                              onChanged: _checkPermissionsAndSetAlarm,
                              activeColor: Colors.orange,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SegmentH(size: 1),
        ],
      ),
    );
  }
}
