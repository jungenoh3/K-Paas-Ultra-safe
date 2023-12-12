import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../style/text_style.dart';

class ToEQMapButton extends StatelessWidget {
  final Function goToEQInfo;
  final String? text1;
  final String? text2;
  const ToEQMapButton({Key? key, this.text1, this.text2, required this.goToEQInfo}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        goToEQInfo();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.fromLTRB(10, 30, 20, 10),
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
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: -100,
              child: Center(
                child: SizedBox(
                  height: 110,
                  width: 110,
                  child: SvgPicture.asset(
                    'assets/map.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            Positioned(
              right: 68,
              bottom: 10,
              height: 35,
              width: 35,
              child: SvgPicture.asset('assets/mappoint.svg'),
            ),
            Positioned(
              right: 45,
              bottom: 30,
              height: 25,
              width: 25,
              child: SvgPicture.asset('assets/mappoint.svg'),
            ),
            Positioned(
              right: 100,
              bottom: 40,
              height: 20,
              width: 20,
              child: SvgPicture.asset('assets/mappoint.svg'),
            ),
            const Positioned(
              left: 10,
              top: 10,
              child: Text('지진지도', style: kInfoTitleTextStyle),
            ),
            Positioned(
              left: 12,
              top: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (text1 != null)
                    Text(text1!, style: kInfoDescriptionTextStyle),
                  if (text2 != null)
                    Text(text2!, style: kInfoDescriptionTextStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
