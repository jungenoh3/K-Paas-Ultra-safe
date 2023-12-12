import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/to_setting_button.dart';
import 'widgets/toactinfobutton.dart';
import 'widgets/toseismicdesignbutton.dart';
import '../../style/color_guide.dart';
import '../../style/text_style.dart';

class EQSafety extends StatefulWidget {
  final Function goToEQInfo;
  const EQSafety({Key? key, required this.goToEQInfo}) : super(key: key);

  @override
  EQSafetyState createState() => EQSafetyState();
}

class EQSafetyState extends State<EQSafety> with TickerProviderStateMixin {
  AnimationController? _lastController;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    _lastController = AnimationController(
      duration: const Duration(seconds: 1), // 애니메이션 시간을 조절합니다.
      vsync: this,
    )..repeat(reverse: true);

    _animation1 = Tween(begin: 0.0, end: 2.0).animate(_lastController!);
    _animation2 = Tween(begin: 0.0, end: 3.0).animate(_lastController!);
    _animation3 = Tween(begin: 0.0, end: 4.0).animate(_lastController!);
  }

  @override
  void dispose() {
    _lastController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray2,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: const Text('지진안전정보', style: kAppBarTitleTextStyle),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: ToActInfoButton(
                      animate: true, text1: '지진 발생 시', text2: '행동 가이드')),
              Expanded(child: ToSeismicDesignButton(goToEQInfo: widget.goToEQInfo)),
            ],
          )),
          const ToSettingButton(),
          Expanded(
              child: GestureDetector(
            onTap: () {
              widget.goToEQInfo();
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 100,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white),
              child: Stack(
                children: [
                  Positioned(
                      right: 20,
                      bottom: -50,
                      height: 140,
                      width: 140,
                      child: SvgPicture.asset(
                        'assets/map.svg',
                        fit: BoxFit.contain,
                      )),
                  AnimatedBuilder(
                    animation: _lastController!,
                    builder: (BuildContext context, Widget? child) {
                      return Stack(
                        children: [
                          Positioned(
                            right: 68,
                            bottom: 5 + 3 * _animation1.value,
                            height: 45,
                            width: 45,
                            child: SvgPicture.asset('assets/mappoint.svg'),
                          ),
                          Positioned(
                            right: 45,
                            bottom: 25 + 4 * _animation2.value,
                            height: 35,
                            width: 35,
                            child: SvgPicture.asset('assets/mappoint.svg'),
                          ),
                          Positioned(
                            right: 100,
                            bottom: 30 + 5 * _animation3.value,
                            height: 30,
                            width: 30,
                            child: SvgPicture.asset('assets/mappoint.svg'),
                          ),
                        ],
                      );
                    },
                  ),
                  const Positioned(
                    left: 10,
                    top: 10,
                    child: Text('지진지도', style: kInfoTitleTextStyle),
                  ),
                  const Positioned(
                    left: 12,
                    top: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('최근 발생 지진, 대피소, 응급시설 등',
                            style: kInfoDescriptionTextStyle),
                        Text('다양한 지진 관련 정보 지도 제공',
                            style: kInfoDescriptionTextStyle),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
