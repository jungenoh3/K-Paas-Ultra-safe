import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'eq_act_info.dart';
import '../../../style/text_style.dart';

class ToActInfoButtonNoAni extends StatefulWidget {
  final String? text1;
  final String? text2;
  const ToActInfoButtonNoAni({Key? key, this.text1, this.text2}) : super(key:key);

  @override
  ToActInfoButtonNoAniState createState() => ToActInfoButtonNoAniState();
}

class ToActInfoButtonNoAniState extends State<ToActInfoButtonNoAni> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EQActInfo(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.fromLTRB(20, 30, 10, 10),
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
              bottom: -20,
              right: 30,
              height: 115,
              width: 115,
              child: SvgPicture.asset(
                'assets/runner.svg',
                fit: BoxFit.contain,
              ),
            ),
            const Positioned(
              left: 10,
              top: 10,
              child: Text('지진행동요령', style: kInfoTitleTextStyle),
            ),
            Positioned(
              left: 12,
              top: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.text1 != null)
                    Text(widget.text1!, style: kInfoDescriptionTextStyle),
                  if (widget.text2 != null)
                    Text(widget.text2!, style: kInfoDescriptionTextStyle),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
