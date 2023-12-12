import 'package:dio/dio.dart';
import 'package:eqms_test/api/retrofit/rest_client.dart';
import 'package:eqms_test/widgets/common_widgets/loading_widget.dart';
import 'package:eqms_test/widgets/sensor_info/widgets/sensor_details/sensor_info_table.dart';
import 'package:flutter/material.dart';

class SensorInfoList extends StatefulWidget {
  const SensorInfoList({Key? key}) : super(key: key);

  @override
  State<SensorInfoList> createState() => _SensorInfoListState();
}

class _SensorInfoListState extends State<SensorInfoList> {
  final dio = Dio();
  late RestClient client = RestClient(dio);
  String facilityValue = "전체";
  String regionValue = "전체";
  List<String> facilityData = [];
  List<String> regionData = [];
  final queryParameter = Map<String, String>();
  final myController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchDropButtonData();
  }

  void fetchDropButtonData(){
    client.getSensorInfoFacility().then((value) {
      facilityData = value;
      facilityData.insert(0, "전체");
    });
    client.getSensorInfoRegion().then((value) {
      regionData = value;
      regionData.insert(0, "전체");
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SensorInfo>>(
      future: client.getSensorSearch(queryParameter),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          print('길이: ${snapshot.data.length}');
          print('쿼리파라미터 ${queryParameter}');

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        controller: myController,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.deepOrange)),
                            hintText: '단말번호를 입력해주세요.'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                              setState(() {
                                if (myController.text.isNotEmpty){
                                  queryParameter['deviceid'] = myController.text;
                                } else if (queryParameter.keys.contains('deviceid')){
                                  queryParameter.remove('deviceid');
                                }
                              });
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white),
                          child: const Text("조회"),
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "조회현황",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text("행정구역", style: TextStyle(fontSize: 15)),
                    const SizedBox(
                      width: 10,
                    ),
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
                          if (value! == '전체' && queryParameter.keys.contains('region')){
                            queryParameter.remove('region');
                          } else if (value! != '전체') {
                            queryParameter['region'] = value;
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("시설"),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 75,
                      child: DropdownButton(
                        isExpanded: true,
                        value: facilityValue,
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                        items: facilityData
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          print("onChanged value: ${value}");
                          setState(() {
                            facilityValue = value!;
                            if (value! == '전체' && queryParameter.keys.contains('facility')){
                              queryParameter.remove('facility');
                            } else if (value! != '전체') {
                              queryParameter['facility'] = value;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SensorInfoTable(
                    sensorValue: snapshot.data,
                  ),
                ),
              ],
            ),
          );
        }
        return const LoadingIndicator();
      },
    );
  }

  List<String> getFacilityButtonItems(List<SensorInfo> value) {
    List<String> facility = value
        .where((element) => element.facility != null)
        .map((e) => e.facility!)
        .toSet()
        .toList(growable: true);
    facility.insert(0, "전체");
    return facility;
  }

  List<String> getRegionButtonItems(List<SensorInfo> value){
    List<String> regions = value.map((e) => e.region).toSet().toList(growable: true);
    regions.insert(0, "전체");
    return regions;
  }

}