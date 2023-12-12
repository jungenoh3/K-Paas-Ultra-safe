import 'package:eqms_test/style/color_guide.dart';
import 'package:eqms_test/style/text_style.dart';
import 'package:eqms_test/widgets/eq_safety/common_widgets/box_container.dart';
import 'package:eqms_test/widgets/eq_safety/common_widgets/custom_textbutton_for_pdf.dart';
import 'package:flutter/material.dart';

class EQActInfo extends StatefulWidget {
  const EQActInfo({Key? key}) : super(key: key);

  @override
  EQActInfoState createState() => EQActInfoState();
}

class EQActInfoState extends State<EQActInfo> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title:
              const Text('지진행동요령', style: kAppBarTitleTextStyle),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: <Widget>[
            const Card(
              margin: EdgeInsets.only(bottom: 10),
              child: TabBar(
                indicatorColor: primaryOrange,
                labelColor: primaryOrange,
                unselectedLabelColor: lightGray1,
                tabs: <Widget>[
                  Tab(
                    child: Center(
                        child: Text(
                      '상황별',
                      style: kTapTextStyle,
                    )),
                  ),
                  Tab(
                    child: Center(
                        child: Text(
                      '장소별',
                      style: kTapTextStyle,
                    )),
                  ),
                  Tab(
                    child: Text('몸이 불편하신분', style: kTapTextStyle),
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 15, 0),
                        child: const Align(
                          alignment: Alignment.bottomRight,
                          child: Text('내용출처 : 행정안전부', style: kSourceTextStyle),
                        ),
                      ),
                      const BoxContainer(
                        imageUrl:
                            'https://www.weather.go.kr/pews/man/img/b1_01.jpg',
                        boxTitle: '지진으로 흔들릴 때는?',
                        interpretataion:
                            '지진으로 흔들리는 동안은 탁자 아래로 들어가 몸을 보호하고. 탁자 다리를 꼭 잡습니다.',
                        colorForBox: secondaryLightBlue,
                      ),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b1_02.jpg',
                          boxTitle: '흔들림이 멈췄을 때는?',
                          interpretataion:
                              '흔들림이 멈추면 전기와 가스를 차단하고, 문을 열어 출구를 확보합니다.',
                          colorForBox: secondaryLightBlue),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b1_03.jpg',
                          boxTitle: '건물 밖으로 나갈 때는?',
                          interpretataion:
                              '건물 밖을 나갈때에는 계단을 이용하여 신속하게 이동합니다. (엘리베이터 사용 금지)\n엘리베이터 안에 있을 경우 모든 층의 버튼을 눌러 먼저 열리는 층에서 내립니다.',
                          colorForBox: secondaryLightBlue),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b1_04.jpg',
                          boxTitle: '건물 밖으로 나왔을 때는?',
                          interpretataion:
                              '건물 밖에서는 가방이나 손으로 머리를 보호하며, 건물과 거리를 두고 주위를 살피며 대피합니다.',
                          colorForBox: secondaryLightBlue),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b1_05.jpg',
                          boxTitle: '대피장소를 찾을 때는?',
                          interpretataion:
                              '떨어지는 물건에 유의하며 신속하게 운동장이나 공원 등 넓은 공간으로 대피합니다. (차량이용 금지)',
                          colorForBox: secondaryLightBlue),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b1_06.jpg',
                          boxTitle: '대피장소에 도착한 후에는?',
                          interpretataion:
                              '라디오나 공공기관의 안내 방송 등 올바른 정보에 따라 행동합니다.',
                          colorForBox: secondaryLightBlue),
                      const CustomTextButtonForPDF(
                          url:
                              'https://www.weather.go.kr/pews/man/img/bhvr.pdf',
                          fileName: 'bhvr.pdf')
                    ],
                  ),
                  ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 15, 0),
                        child: const Align(
                            alignment: Alignment.bottomRight,
                            child:
                                Text('내용출처 : 행정안전부', style: kSourceTextStyle)),
                      ),
                      const BoxContainer(
                        imageUrl:
                            'https://www.weather.go.kr/pews/man/img/b2_01.jpg',
                        boxTitle: '집 안에 있을 경우',
                        interpretataion:
                            '탁자 아래로 들어가 몸을 보호하고 흔들림이 멈추면 전기와 가스를 차단하고 문을 열어 출구를 확보한 후, 밖으로 나갑니다.',
                        colorForBox: secondaryLightGreen,
                      ),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b2_02.jpg',
                          boxTitle: '집 밖에 있을 경우',
                          interpretataion:
                              '떨어지는 유리, 간판, 담장, 전봇대에 주의하며, 건물과 거리를 두고 가방이나 손으로 머리를 보호하며, 운동장이나 공원 등 넓은 공간으로 대피합니다.',
                          colorForBox: secondaryLightGreen),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b2_03.jpg',
                          boxTitle: '고층건물에 있을 경우',
                          interpretataion:
                              '높은 층의 건물일수록 흔들림이 크고 오래 지속 될 수 있으므로 실내에서 떨어지는 물건에 더욱 주의합니다.\n※ 고층건물은 일반적으로 내진성능을 확보',
                          colorForBox: secondaryLightGreen),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b2_05.jpg',
                          boxTitle: '엘리베이터에 있을 경우',
                          interpretataion:
                              '모든 층의 버튼을 눌러 가장 먼저 열리는 층에서 내린 후 계단을 이용합니다.\n※ 지진 발생 시 엘리베이터를 타면 안됩니다.',
                          colorForBox: secondaryLightGreen),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b2_06.jpg',
                          boxTitle: '학교에 있을 경우',
                          interpretataion:
                              '책상아래로 들어가 책상다리를 꼭 잡고 몸을 보호 합니다. 흔들림이 멈추면 선생님의 안내에 따라 질서를 지키며 창문과 떨어져 운동장으로 대피합니다.',
                          colorForBox: secondaryLightGreen),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b2_10.jpg',
                          boxTitle: '백화점 · 마트에 있을 경우',
                          interpretataion:
                              '진열장에서 떨어지는 물건으로부터 몸을 보호합니다. 계단이나 기둥근처로 피해있다가, 흔들림이 멈추면 안내에 따라 침착하게 대피합니다.',
                          colorForBox: secondaryLightGreen),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b2_08.jpg',
                          boxTitle: '극장 · 경기장에 있을 경우',
                          interpretataion:
                              '흔들림이 멈출때까지 가방등 소지품으로 몸을 보호 하면서 자리에 있다가, 안내에 따라 침착하게 대피합니다.',
                          colorForBox: secondaryLightGreen),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b2_09.jpg',
                          boxTitle: '운전을 하고 있을 경우',
                          interpretataion:
                              '비상등을 켜고 서서히 속도를 줄여 도로 오른쪽에 차를 세웁니다. 라디오의 정보를 잘 듣고, 대피해야할 때에는 열쇠를 꽂아 두고 대피합니다.',
                          colorForBox: secondaryLightGreen),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b2_07.jpg',
                          boxTitle: '전철을 타고 있을 경우',
                          interpretataion:
                              '손잡이나 기둥을 잡아 넘어지지 않도록 합니다. 전철이 멈추면 안내에 따라 행동합니다.',
                          colorForBox: secondaryLightGreen),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b2_04.jpg',
                          boxTitle: '산 · 바다에 있을 경우',
                          interpretataion:
                              '산사태, 절벽 붕괴에 주의하며 급한 경사지를 피해 평탄한곳으로 대피합니다. 해안에서 지진해일특보가 발령되면 높은곳으로 이동합니다.',
                          colorForBox: secondaryLightGreen),
                      const CustomTextButtonForPDF(
                          url:
                              'https://www.weather.go.kr/pews/man/img/bhvr.pdf',
                          fileName: 'bhvr.pdf')
                    ],
                  ),
                  ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 15, 0),
                        child: const Align(
                            alignment: Alignment.bottomRight,
                            child:
                                Text('내용출처 : 행정안전부', style: kSourceTextStyle)),
                      ),
                      const BoxContainer(
                        imageUrl:
                            'https://www.weather.go.kr/pews/man/img/b3_01.png',
                        boxTitle: '시력이 좋지 않거나 시각장애가 있는 경우',
                        interpretataion:
                            '머리와 몸을 보호하고, 흔들림이 멈추면 라디오, 텔레비전 등 미디어 매체로 상황파악을 합니다. 장애물을 점검하며 천천히 움직이고, 주위사람들 에게 도움을 적극적으로 요청합니다.',
                        colorForBox: secondaryLightRed,
                      ),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b3_02.png',
                          boxTitle: '거동이 불편하거나 지체장애가 있는 경우',
                          interpretataion:
                              '휠체어, 보행기를 사용할 경우 바퀴를 잠그고 몸을 앞으로 숙여 책·방석·베개 등으로 머리와 목을 보호 합니다. 대피할 때에는 혼자서 행동하지 말고 이웃 과 함께 대피하고, 움직일 수 없을때에는 조금이라도 안전한 장소에서 도움을 기다립니다.',
                          colorForBox: secondaryLightRed),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b3_03.png',
                          boxTitle: '청력이 좋지 않거나 청각장애가 있는 경우',
                          interpretataion:
                              '머리와 몸을 보호하고, 흔들림이 멈추면 텔레비전의 자막방송 및 휴대전화 등으로 정보를 수집합니다. 움직이기 힘든 경우 호루라기 등으로 소리를 내어 장소를 알리고 도움을 받습니다.',
                          colorForBox: secondaryLightRed),
                      const BoxContainer(
                          imageUrl:
                              'https://www.weather.go.kr/pews/man/img/b3_04.png',
                          boxTitle: '정신이 불안정하거나 발달장애가 있는 경우',
                          interpretataion:
                              '급히 뛰거나 서두르지 않고, 주변 사람들과 미리 정한 대로 행동합니다. 혼란스러워 스스로 결정하지 못할 때에는 주위사람에게 도움을 요청합니다.',
                          colorForBox: secondaryLightRed),
                      const CustomTextButtonForPDF(
                          url:
                              'https://www.weather.go.kr/pews/man/img/bhvr.pdf',
                          fileName: 'bhvr.pdf')
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
