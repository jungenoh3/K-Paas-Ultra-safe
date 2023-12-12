import 'package:eqms_test/style/color_guide.dart';
import 'package:eqms_test/style/text_style.dart';
import 'package:eqms_test/widgets/more_page/widgets/login_register/register.dart';
import 'package:eqms_test/widgets/more_page/widgets/service_agree/privacy_policy.dart';
import 'package:eqms_test/widgets/more_page/widgets/service_agree/service_use_promise.dart';
import 'package:flutter/material.dart';

class RegisterAgree extends StatefulWidget {
  const RegisterAgree({Key? key}) : super(key: key);

  @override
  RegisterAgreeState createState() => RegisterAgreeState();
}

class RegisterAgreeState extends State<RegisterAgree>
    with TickerProviderStateMixin {
  bool _allAgree = false;
  bool _serviceAgree = false;
  bool _privacyAgree = false;

  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  void _checkAllAgree() {
    if (_serviceAgree && _privacyAgree) {
      _allAgree = true;
    } else {
      _allAgree = false;
    }
  }

  onChangedServiceAgree(bool? value) {
    setState(() {
      _serviceAgree = value!;
      _checkAllAgree();
    });
  }

  onChangedPrivacyAgree(bool? value) {
    setState(() {
      _privacyAgree = value!;
      _checkAllAgree();
    });
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animations = List.generate(
        6,
        (index) => Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(0.1 + 0.10 * index, 1, curve: Curves.ease),
              ),
            ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
        title: const Text('약관동의', style: kAppBarTitleTextStyle),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _animations[0],
                child: const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('서비스 약관에 동의해주세요!', style: kAgreeTextStyle)),
                ),
              ),
              FadeTransition(
                opacity: _animations[1],
                child: const SizedBox(height: 50),
              ),
              FadeTransition(
                opacity: _animations[2],
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: primaryOrange,
                      value: _allAgree,
                      onChanged: (bool? value) {
                        setState(() {
                          _allAgree = value!;
                          _serviceAgree = value;
                          _privacyAgree = value;
                        });
                      },
                    ),
                    const SizedBox(width: 0),
                    const Text('전체동의',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              FadeTransition(
                opacity: _animations[3], // 새로운 애니메이션 인덱스
                child: const Divider(
                  color: lightGray1,
                  height: 20, // Divider 위젯 자체의 높이를 지정합니다.
                  thickness: 1, // 선의 두께를 지정합니다.
                  indent: 18, // 왼쪽에서 시작하는 위치를 지정합니다.
                  endIndent: 18, // 오른쪽에서 끝나는 위치를 지정합니다.
                ),
              ),
              FadeTransition(
                opacity: _animations[4],
                child: Row(
                  children: [
                    Checkbox(
                        activeColor: primaryOrange,
                        value: _serviceAgree,
                        onChanged: onChangedServiceAgree),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ServiceUsePromise()));
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('[필수] 서비스 이용약관 동의'),
                              Icon(Icons.arrow_forward_ios, size: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FadeTransition(
                opacity: _animations[5],
                child: Row(
                  children: [
                    Checkbox(
                        activeColor: primaryOrange,
                        value: _privacyAgree,
                        onChanged: onChangedPrivacyAgree),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicy()));
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('[필수] 개인정보 수집 및 이용 동의'),
                              Icon(Icons.arrow_forward_ios, size: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 150),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (_serviceAgree && _privacyAgree) {
                          return primaryOrange;
                        }
                        return lightGray1;
                      },
                    ),
                    elevation: MaterialStateProperty.all<double>(0),
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size(double.infinity, 50)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(horizontal: 5)),
                  ),
                  onPressed: _serviceAgree && _privacyAgree
                      ? () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()));
                        }
                      : null,
                  child: Text('동의하고 진행하기',
                      style: (_serviceAgree && _privacyAgree)
                          ? kButtonTextStyle
                          : kUnidentifiedButtonTextStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
