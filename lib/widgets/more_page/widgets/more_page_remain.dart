import 'package:eqms_test/style/text_style.dart';
import 'package:eqms_test/widgets/more_page/widgets/service_agree/privacy_policy.dart';
import 'package:eqms_test/widgets/more_page/widgets/service_agree/service_use_promise.dart';
import 'package:flutter/material.dart';
import 'more_page_call.dart';

class MorePageRemain extends StatelessWidget {
  final bool isLoggedIn;
  const MorePageRemain({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int flexValue = isLoggedIn ? 4 : 5;

    return Expanded(
      flex: flexValue,
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ServiceUsePromise(),
                                ),
                              );
                            },
                            child: const Text('이용약관')),
                        const SizedBox(width: 20),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicy(),
                                ),
                              );
                            },
                            child: const Text('개인정보 처리방침'))
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Contact',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text('- 경북대학교 초연결융합기술연구소', style: kMorePageRemainTextStyle),
                    const SizedBox(height: 5),
                    const Text('- 웹사이트 주소', style: kMorePageRemainTextStyle),
                    const Text('   https://connected.knu.ac.kr/',
                        style: kMorePageRemainTextStyle),
                    const SizedBox(height: 5),
                    const Text('- 이메일', style: kMorePageRemainTextStyle),
                    const Text('   ywkwon@knu.ac.kr',
                        style: kMorePageRemainTextStyle),
                  ],
                )),
            const Expanded(flex: 2, child: MorePageCall())
          ],
        ),
      ),
    );
  }
}
