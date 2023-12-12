import 'package:eqms_test/style/text_style.dart';
import 'package:eqms_test/widgets/common_widgets/loading_widget.dart';
import 'package:eqms_test/widgets/common_widgets/segment.dart';
import 'package:eqms_test/widgets/more_page/widgets/login_register/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/service_introduction.dart';
import 'widgets/more_page_setting.dart';
import 'widgets/more_page_button.dart';
import 'widgets/more_page_remain.dart';

Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

Future<String?> getUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

class MorePage extends StatefulWidget {
  const MorePage({super.key});
  @override
  MorePageState createState() => MorePageState();
}

class MorePageState extends State<MorePage> {
  bool? isLoggedIn;
  @override
  void initState() {
    super.initState();
    checkLoginStatus().then((value) => setState(() => isLoggedIn = value));
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    if (mounted) {
      // Check if the widget is still in the widget tree
      setState(() => isLoggedIn = false);

      // Navigate to the route you want to switch to after logging out
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const MorePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      return  const Center(child: LoadingIndicator()); // Show loading while checking login status
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0.0,

          title: const Text('더보기', style: kAppBarTitleTextStyle),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder<bool>(
          future: checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingIndicator()); // 로딩 중
            } else if (snapshot.data == true) {
              return FutureBuilder<String?>(
                future: getUserName(),
                builder: (context, nameSnapshot) {
                  if (nameSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: LoadingIndicator()); // 로딩 중
                  } else {
                    return Column(
                      children: [
                        MorePageButton(
                            title: '${nameSnapshot.data}님 안녕하세요!',
                            isLoggedIn: true),
                        const SegmentH(size: 1),
                        MorePageButton(title: '로그아웃', logoutFunction: logout),
                        const SegmentH(size: 1),
                        const MorePageButton(
                            title: '서비스 소개', route: ServiceIntroduction()),
                        const SegmentH(size: 1),
                        const MorePageButton(
                          title: '설정',
                          route: MorePageSetting(),
                        ),
                        const SegmentH(size: 1),
                        MorePageButton(
                            title: '홈페이지',
                            url: Uri.parse('https://connected.knu.ac.kr/')),
                        const SegmentH(size: 1),
                        MorePageButton(
                            title: '라인 지진 알림서비스',
                            url: Uri.parse('https://line.me/R/ti/p/%40336fgjcu')),
                        const MorePageRemain(isLoggedIn: true) // 또는 false

                        // 여기에 추가 버튼을 삽입할 수 있음
                      ],
                    );
                  }
                },
              );
            } else {
              return Column(
                children: [
                  MorePageButton(
                      title: '로그인 및 계정 추가',
                      route: Login(nextRoute: '/morepage')),
                  const SegmentH(size: 1),
                  const MorePageButton(
                      title: '서비스 소개', route: ServiceIntroduction()),
                  const SegmentH(size: 1),
                  const MorePageButton(title: '설정', route: MorePageSetting()),
                  const SegmentH(size: 1),
                  MorePageButton(
                      title: '홈페이지',
                      url: Uri.parse('https://connected.knu.ac.kr/')),
                  const SegmentH(size: 1),
                  MorePageButton(
                      title: '라인 지진 알림서비스',
                      url: Uri.parse('https://line.me/R/ti/p/%40336fgjcu')),
                  const MorePageRemain(isLoggedIn: false)

                  // 여기에 추가 버튼을 삽입할 수 있음
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
