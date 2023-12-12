import 'package:flutter/material.dart';
import 'eq_act_info.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../style/text_style.dart';

class ToActInfoButton extends StatefulWidget {
  final bool animate; // Whether to animate or not
  final String? text1;
  final String? text2;
  const ToActInfoButton({Key? key, required this.animate, this.text1, this.text2}): super(key:key);

  @override
  ToActInfoButtonState createState() => ToActInfoButtonState();
}

class ToActInfoButtonState extends State<ToActInfoButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _leftToRightController;
  late Animation<double> _rightPositionAnimation;

  @override
  void initState() {
    super.initState();
    _leftToRightController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _rightPositionAnimation = Tween<double>(
      begin: 50,
      end: -20,
    ).animate(CurvedAnimation(
      parent: _leftToRightController,
      curve: Curves.easeInOut,
    ));
    _leftToRightController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.animate) {
      _leftToRightController.reset();
      _leftToRightController.forward();
    } else {
      _leftToRightController.reverse();
    }
  }

  @override
  void dispose() {
    _leftToRightController.dispose();
    super.dispose();
  }

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
            AnimatedBuilder(
              animation: _leftToRightController,
              builder: (context, child) {
                return Positioned(
                  right: _rightPositionAnimation.value, // Animate the right position
                  bottom: -28,
                  height: 130,
                  width: 130,
                  child: SvgPicture.asset(
                    'assets/runner.svg',
                    fit: BoxFit.contain,
                  ),
                );
              },
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
