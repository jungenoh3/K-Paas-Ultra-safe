import 'package:dio/dio.dart';
import 'package:eqms_test/api/retrofit/rest_client.dart';
import 'package:eqms_test/widgets/common_widgets/loading_widget.dart';
import 'package:eqms_test/widgets/sensor_info/widgets/sensor_details/sensor_abnormal_table.dart';
import 'package:flutter/material.dart';

class SensorAbnormalList extends StatefulWidget {
  const SensorAbnormalList({super.key});

  @override
  State<SensorAbnormalList> createState() => _SensorAbnormalListState();
}

class _SensorAbnormalListState extends State<SensorAbnormalList> {
  final dio = Dio();
  late RestClient client = RestClient(dio);
  String abnormalValue = "전체";
  String regionValue = "전체";
  List<String> regionData = [];
  List<String> abnormalData = [
    "전체",
    "가속도",
    "기압계",
    "온도계",
    "Fault Message"
  ];
  final queryParameter = Map<String, String>();

  @override
  void initState() {
    super.initState();
    fetchDropButtonData();
  }

  void fetchDropButtonData(){
    client.getSensorAbnormalRegion().then((value) {
      regionData = value;
      regionData.insert(0, "전체");
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: client.getSensorAbnormalSearch(queryParameter),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData){
            print('sensorabnormallist size: ${MediaQuery.of(context).size.height}');

            print(queryParameter);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "현황",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text("행정구역", style: TextStyle(fontSize: 15)),
                        const SizedBox(width: 10),
                        DropdownButton(
                          value: regionValue,
                          items: regionData
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              regionValue = value!;
                              if (value! == '전체' &&
                                  queryParameter.keys.contains('region')) {
                                queryParameter.remove('region');
                              } else if (value! != '전체' ){
                                queryParameter['region'] = value;
                              }
                            });
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("이상정보필터"),
                        const SizedBox(width: 10),
                        Container(
                          width: 75,
                          child: DropdownButton(
                            isExpanded: true,
                            value: abnormalValue,
                            items: abnormalData
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                abnormalValue = value!;
                                if (value! == '전체' && queryParameter.keys.contains('sensorData')) {
                                  queryParameter.remove('sensorData');
                                }
                                else if (value! != '전체') {
                                  switch (value!) {
                                    case "가속도":
                                      queryParameter["sensorData"] = "accelerator";
                                      break;
                                    case "기압계":
                                      queryParameter["sensorData"] = "pressure";
                                      break;
                                    case "온도계":
                                      queryParameter["sensorData"] = "temperature";
                                      break;
                                    case "Fault Message":
                                      queryParameter["sensorData"] = "fault_message";
                                      break;

                                  }
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: SensorAbnormalTable(sensorValue: snapshot.data)),
                ],
              ),
            );
          }
          return LoadingIndicator();
        });
  }

  List<String> getRegionButtonItems(List<SensorAbnormal> value) {
    List<String> regions =
        value.map((e) => e.region).toSet().toList(growable: true);
    regions.insert(0, "전체");
    return regions;
  }
}
