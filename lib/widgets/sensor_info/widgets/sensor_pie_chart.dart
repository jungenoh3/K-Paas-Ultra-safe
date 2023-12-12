import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../style/color_guide.dart';

class SensorPieChart extends StatefulWidget {
  final List<double>? dataValues;
  const SensorPieChart({Key? key, this.dataValues}): super(key:key);

  @override
  SensorPieChartState createState() => SensorPieChartState();
}

class SensorPieChartState extends State<SensorPieChart>
    with SingleTickerProviderStateMixin {
  int touchedIndex = -1;
  Offset? touchPosition;

  final List<String> dataTitles = [
    '정상작동',
    '이상동작',
    '연동확인',
    '예비물자',
  ];

  final List<Color> colorList = [
    const Color(0xFFFF4500),
    secondaryRed,
    const Color(0xFFFFDAB9),
    lightGray1,
  ];
  AnimationController? _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500), // 애니메이션 지속 시간
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!)
      ..addListener(() {
        setState(() {});
      });

    _animationController!.forward(); // 애니메이션 시작
  }

  @override
  Widget build(BuildContext context) {
    final dataValues = widget.dataValues ?? [5323, 10, 1187, 800];
    return Stack(
      children: [
        PieChart(
          PieChartData(
            // 기존의 PieTouchData touchCallback 코드를 찾습니다.
            pieTouchData: PieTouchData(touchCallback:
                (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
              setState(() {
                if (pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  touchPosition = null;
                } else {
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                  touchPosition = event
                      .localPosition; // 이렇게 FlTouchEvent의 localPos를 사용하여 위치 정보를 얻을 수 있습니다.
                }
              });
            }),
            startDegreeOffset: -90,
            borderData: FlBorderData(show: false),
            sectionsSpace: 0,
            centerSpaceRadius: 60,
            sections: dataValues.asMap().entries.map((entry) {
              final isTouched = touchedIndex == entry.key;
              final double fontSize = isTouched ? 20 : 16;
              final double radius = isTouched ? 60 : 50;
              return PieChartSectionData(
                color: colorList[entry.key],
                value: entry.value * _animation.value, // 애니메이션 값을 사용
                title: (entry.value * _animation.value)
                    .toStringAsFixed(0), // 애니메이션 값을 사용
                radius: radius,
                titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }).toList(),
          ),
        ),
        const Center(
          child: Text(
            '센서현황',
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Column(
            // 여기를 Column으로 변경했습니다.
            crossAxisAlignment: CrossAxisAlignment.end, // 오른쪽 정렬
            children: dataTitles.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0), // 패딩도 조금 수정했습니다.
                child: Indicator(
                  color: colorList[entry.key],
                  text: entry.value,
                  isSquare: true,
                ),
              );
            }).toList(),
          ),
        ),
        // 기존 Stack 위젯 내에 추가
        if (touchedIndex != -1 && touchPosition != null) // 툴팁 조건 확인
          Positioned(
            left: touchPosition!.dx - 50, // 툴팁 위치 조정
            top: touchPosition!.dy - 50,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      dataTitles[touchedIndex],
                      style: const TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${dataValues[touchedIndex].toStringAsFixed(0)}개",
                        style: const TextStyle(color: Colors.white, fontSize: 18)
                    )
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
}

class Indicator extends StatelessWidget {
  final Color color; // 필수
  final String text; // 필수
  final bool isSquare; // 필수

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 13),
        )
      ],
    );
  }
}
