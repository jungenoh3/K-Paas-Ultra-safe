// import 'package:eqms_test/api/google_map_model.dart';
import 'package:eqms_test/style/color_guide.dart';
import 'package:eqms_test/widgets/common_widgets/toast_message.dart';
import 'package:eqms_test/widgets/eq_info/eq_info.dart';
import 'package:eqms_test/widgets/eq_safety/eq_safety.dart';
import 'package:eqms_test/widgets/more_page/more_page.dart';
import 'package:eqms_test/widgets/sensor_map/sensor_map.dart';
import 'package:eqms_test/widgets/sensor_info/sensor_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  late final PageController _controller;
  int selectedIndex = 0;
  final GlobalKey<NavigatorState> eqInfoNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> eqSafetyNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> sensorMapNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> sensorDetailsNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> morePageNavigatorKey =
      GlobalKey<NavigatorState>();
  late List<Widget> widgetOptions;
  DateTime? currentBackPressTime;
  var currentTime;

  final List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/eq_info.svg'),
      activeIcon: SvgPicture.asset('assets/eq_info_selected.svg'),
      label: '지진지도',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/eq_safety.svg'),
      activeIcon: SvgPicture.asset('assets/eq_safety_selected.svg'),
      label: '지진안전',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/sensor_map.svg'),
      activeIcon: SvgPicture.asset('assets/sensor_map_selected.svg'),
      label: '센서지도',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/sensor_info.svg'),
      activeIcon: SvgPicture.asset('assets/sensor_info_selected.svg'),
      label: '센서현황',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/setting.svg'),
      activeIcon: SvgPicture.asset('assets/setting_selected.svg'),
      label: '더보기',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();

    widgetOptions = [
      Navigator(
          key: eqInfoNavigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (context) => const EQInfo());
          }),
      Navigator(
          key: eqSafetyNavigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
                builder: (context) => EQSafety(goToEQInfo: goToEQInfo));
          }),
      Navigator(
          key: sensorMapNavigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (context) => const SensorMap());
          }),
      Navigator(
          key: sensorDetailsNavigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (context) => const SensorInfo());
          }),
      Navigator(
          key: morePageNavigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (context) => const MorePage());
          }),
    ];
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when not needed
    super.dispose();
  }

  Future<void> onItemTapped(int index) async {
    if (!mounted) return;

    if (selectedIndex != index) {
      switch(index){
        case 0:
        case 1:
        case 4:
          _controller.jumpToPage(index);
          break;
        case 2:
        case 3:
          if (await isLoggedIn()){
            _controller.jumpToPage(index);
          } else {
            alertMessage('로그인 후 사용 가능합니다.');
          }
      }
      // _controller.jumpToPage(index);
    }
  }

  void onPageChanged(int index) {
    if (!mounted) return;

    setState(() => selectedIndex = index);
  }

  void goToEQInfo() {
    if (!mounted) return;

    _controller.jumpToPage(0); // 0은 EQInfo 페이지의 인덱스입니다.
    setState(() {
      selectedIndex = 0; // 바텀바의 선택된 아이템을 EQInfo로 업데이트합니다.
    });
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  BottomNavigationBar renderBottomNavigationBar() {
    return BottomNavigationBar(
      elevation: 0,
      items: bottomItems,
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      unselectedItemColor: mediumGray,
      selectedItemColor: primaryDark,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      onTap: onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: onPageChanged, // Use onPageChanged here
        children: widgetOptions,
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(height: 58, child: renderBottomNavigationBar()),
      ),
      extendBody: false,
      extendBodyBehindAppBar: true,
    );

    return MultiProvider(
      providers: [
        // ChangeNotifierProvider<GoogleMapModel>(
        //     create: (context) => GoogleMapModel())
      ],
      child: Scaffold(
        body: PageView(
          controller: _controller,
          onPageChanged: onPageChanged, // Use onPageChanged here
          children: widgetOptions,
        ),
        bottomNavigationBar: SafeArea(
          child: SizedBox(height: 58, child: renderBottomNavigationBar()),
        ),
        extendBody: false,
        extendBodyBehindAppBar: true,
      ),
    );
  }
}

Future<void> _onBackPressed(BuildContext context) async {
  print('onBackPressed');
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Do you want to exit?'),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () => SystemNavigator.pop(),
        ),
      ],
    ),
  );
}
