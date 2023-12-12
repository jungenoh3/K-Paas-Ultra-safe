import 'package:dio/dio.dart';
import 'package:eqms_test/api/retrofit/rest_client.dart';
import 'package:eqms_test/style/text_style.dart';
import 'package:eqms_test/widgets/common_widgets/loading_widget.dart';
import 'package:eqms_test/widgets/common_widgets/segment.dart';
import 'package:eqms_test/widgets/sensor_info/widgets/sensor_details/sensor_details.dart';
import 'package:eqms_test/widgets/sensor_info/common_widgets/sensor_description.dart';
import 'package:eqms_test/widgets/sensor_info/widgets/sensor_pie_chart.dart';
import 'package:eqms_test/widgets/sensor_info/common_widgets/sensor_button.dart';
import 'package:flutter/material.dart';

class SensorInfo extends StatefulWidget {
  const SensorInfo({Key? key}): super(key:key);

  @override
  SensorInfoState createState() => SensorInfoState();
}

class SensorInfoState extends State<SensorInfo> {
  late Future<Map<String, dynamic>> _futureData;
  List<double>? dataValues; // 상태 변수 추가
  final dio = Dio();
  late RestClient client = RestClient(dio);

  @override
  void initState() {
    super.initState();
  }
  //TODO: 서버연결 후 활성화
  // Future<Map<String, dynamic>> fetchData() async {
  //   final response = await http.get(Uri.parse('YOUR_SERVER_URL'));
  //
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //
  //     // 응답에서 필요한 데이터 추출 및 상태 업데이트
  //     // (이 부분은 서버 응답 형식에 따라 조절해야 할 수 있습니다.)
  //     setState(() {
  //       dataValues = [
  //         data["정상작동"].toDouble(),
  //         data["이상동작"].toDouble(),
  //         data["연동확인"].toDouble(),
  //         data["예비물자"].toDouble(),
  //       ];
  //     });
  //
  //     return data;
  //   } else {
  //     throw Exception('Failed to load data from the server');
  //   }
  // }

  //TODO: 아래 코드 서버연결 후 추후 삭제
  Future<Map<String, dynamic>> fetchData() async {
    await Future.delayed(const Duration(seconds: 1)); // 1초 지연 시킴

    final Map<String, dynamic> data = {
      "정상작동": 5323.0,
      "이상동작": 10.0,
      "연동확인": 1187.0,
      "예비물자": 800.0,
    };

    setState(() {
      dataValues = [
        data["정상작동"],
        data["이상동작"],
        data["연동확인"],
        data["예비물자"],
      ];
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0.0,
        title: const Text('센서현황', style: kAppBarTitleTextStyle),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<SensorCount>(
          future: client.getSensorCount(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {

              final all_sensor = snapshot.data!.all_sensor;
              final abnormal_sensor = snapshot.data!.abnormal_sensor;
              final normal_sensor = all_sensor - abnormal_sensor;

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                        aspectRatio: 1.4,
                        child: SensorPieChart(dataValues: [normal_sensor.toDouble(), abnormal_sensor.toDouble(), 0, 0])),
                  ),
                  const SegmentH(size: 4),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SensorDescription(
                                title: '전체센서', numOfSensors: all_sensor.toInt()),
                            const SegmentV(size: 80),
                            SensorDescription(
                                title: '정상작동',
                                numOfSensors: normal_sensor.toInt() ?? 0),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SensorDescription(
                                title: '이상동작',
                                numOfSensors: abnormal_sensor.toInt() ?? 0),
                            const SegmentV(size: 80),
                            SensorDescription(
                                title: '연동확인',
                                numOfSensors: 0),
                            const SegmentV(size: 80),
                            SensorDescription(
                                title: '예비물자',
                                numOfSensors: 0),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SegmentH(size: 4),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SensorButton(
                            title: '센서현황 리스트\n센서 찾기',
                            target: '세부 리스트 확인하기',
                            route: SensorDetails(initialTabIndex: 0)),
                        SegmentV(size: 100),
                        SensorButton(
                            title: '이상센서 리스트\n',
                            target: '이상센서 확인하기',
                            route: SensorDetails(initialTabIndex: 1)),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
