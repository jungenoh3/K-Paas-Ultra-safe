import 'package:eqms_test/style/color_guide.dart';
import 'package:eqms_test/style/text_style.dart';
import 'package:eqms_test/widgets/common_widgets/segment.dart';
import 'package:eqms_test/widgets/eq_safety/widgets/toactinfobuttonnoani.dart';
import 'package:eqms_test/widgets/eq_safety/widgets/toeqmapbutton.dart';
import 'package:flutter/material.dart';

class SeismicDesign extends StatefulWidget {
  final Function goToEQInfo;
  const SeismicDesign({Key? key, required this.goToEQInfo}) : super(key: key);

  @override
  State<SeismicDesign> createState() => _SeismicDesignState();
}

class _SeismicDesignState extends State<SeismicDesign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('지진안전영상', style: kAppBarTitleTextStyle),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '주소 검색',
                        style: kSeismicTitleTextStyle,
                      )),
                  const SizedBox(height: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all()),
                    child: const Row(children: [
                      Expanded(
                        flex: 8,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '주소를 정확하게 입력해주세요',
                            hintStyle: kHintTextStyle,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Expanded(flex: 1, child: Icon(Icons.search))
                    ]),
                  ),
                  const SizedBox(height: 3),
                  const Align(
                    alignment: Alignment.topRight,
                    child:
                        Text('주소가 정확히 입력되지 않았습니다.', style: kWarningTextStyle),
                  )
                ],
              ),
            ),
          ),
          const SegmentH(size: 3),
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('내진설계 여부', style: kSeismicTitleTextStyle),
                            SizedBox(height: 50),
                            Text('-')
                          ],
                        ),
                      ),
                      SegmentV(size: 100),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('내진능력', style: kSeismicTitleTextStyle),
                            SizedBox(height: 50),
                            Text('-')
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '내진 설계',
                    style: kSeismicDescriptionTextStyle,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              color: lightGray1_5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Expanded(child: ToActInfoButtonNoAni()),
                  Expanded(child: ToEQMapButton(goToEQInfo: widget.goToEQInfo))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
