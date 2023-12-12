import 'package:eqms_test/widgets/more_page/widgets/more_page_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../style/text_style.dart';

class ToSettingButton extends StatefulWidget {
  const ToSettingButton({Key? key}) : super(key: key);

  @override
  ToSettingButtonState createState() => ToSettingButtonState();
}

class ToSettingButtonState extends State<ToSettingButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1), // 애니메이션 시간을 조절합니다.
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween(begin: 0.5, end: 1.0).animate(_controller); // 반짝 효과의 범위를 조절합니다.
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MorePageSetting(),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.all(20),
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
                  right: 30,
                  bottom: 15,
                  height: 110,
                  width: 110,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SvgPicture.asset(
                      'assets/speechbubble.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Positioned(
                  left: 10,
                  top: 10,
                  child: Text('지진 알림 서비스', style: kInfoTitleTextStyle),
                ),
                const Positioned(
                  left: 12,
                  top: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('국내 지진 감지 시', style: kInfoDescriptionTextStyle),
                      Text('실시간 지진 알림', style: kInfoDescriptionTextStyle),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
