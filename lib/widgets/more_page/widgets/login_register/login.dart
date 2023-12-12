import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:eqms_test/api/retrofit/rest_client.dart';
import 'package:eqms_test/style/color_guide.dart';
import 'package:eqms_test/style/text_style.dart';
import 'package:eqms_test/widgets/common_widgets/toast_message.dart';
import 'package:eqms_test/widgets/more_page/widgets/login_register/register_agree.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  final String nextRoute; // The next route to navigate to after a successful login.
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Login({Key? key, required this.nextRoute}) : super(key: key);
  // TODO: 로그인 아이디 비번 관련 validation(아예 입력하지 않은 경우)
  void _loginAction(BuildContext context) async {
    // Get the NavigatorState before the async operation
    final NavigatorState navigatorState = Navigator.of(context);
    final dio = Dio();
    late RestClient client = RestClient(dio);
    bool isLoggedIn = false;

    final password = _passwordController.value.text;

    final uniqueKey = "EQSI@A";
    final bytes = utf8.encode(password + uniqueKey);
    final hash = sha256.convert(bytes);


    final login = {
      "identification": _idController.value.text,
      "password": hash.toString()
    };

    try {
      final value = await client.getRegisterInfo(login);
      if (value.contains("로그인")){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString("username", value.split(":")[1]);
        // Use navigatorState to navigate, ensuring you're not using context after the async gap
        alertMessage("로그인되었습니다.");
        navigatorState.pushReplacementNamed(nextRoute);
      } else {
        alertMessage("이메일과 비밀번호를 확인해주세요.");
      }
    } catch (error) {
      // TODO: 기타등등 에러...
    }

  }

  @override
  Widget build(BuildContext context) {
    // Check the login state during app startup.
    // If isLoggedIn is true, navigate to the specified next route directly.
    _checkLoginState(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('로그인', style: kAppBarTitleTextStyle),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('LOGIN',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('센서지도 및 센서현황 서비스 사용에는 로그인이 필요합니다.',
                style: kMorePageRemainTextStyle),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  hintText: '아이디',
                  hintStyle: kHintTextStyle,
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: '비밀번호',
                  hintStyle: kHintTextStyle,
                  border: InputBorder.none,
                ),
                obscureText: true, // Hide the password text
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryOrange),
                  elevation: MaterialStateProperty.all<double>(0),
                  minimumSize: MaterialStateProperty.all<Size>(const Size(
                      double.infinity,
                      50)), // Width will be as wide as possible within the container
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                          horizontal: 5)), // Horizontal padding
                ),
                onPressed: () => _loginAction(context),
                child: const Text('로그인', style: kButtonTextStyle),
              ),
            ),
            const SizedBox(height: 5),
            TextButton(
                style: const ButtonStyle(
                    foregroundColor:
                        MaterialStatePropertyAll<Color>(primaryOrange)),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterAgree())
                  );
                },
                child: const Text('관리자 계정생성'))
          ],
        ),
      ),
    );
  }

  // Check the login state during app startup.
  void _checkLoginState(BuildContext context) async {
    // Get the NavigatorState before the async operation
    final NavigatorState navigatorState = Navigator.of(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Use the cached NavigatorState to navigate after the async gap
      navigatorState.pushReplacementNamed(nextRoute);
    }
  }

}
