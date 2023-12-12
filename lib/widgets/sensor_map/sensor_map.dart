import 'package:dio/dio.dart';
import 'package:eqms_test/api/retrofit/rest_client.dart';
import 'package:eqms_test/custom_googlemap/custom_googlemap.dart';
import 'package:eqms_test/custom_googlemap/models/google_maps_models.dart';
import 'package:eqms_test/custom_googlemap/widgets/custom_scrollablesheet.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SensorMap extends StatefulWidget {
  const SensorMap({super.key});

  @override
  State<SensorMap> createState() => _SensorMapState();
}

class _SensorMapState extends State<SensorMap> {
  final dio = Dio();
  late RestClient client = RestClient(dio);

  List<CircleData> circleItems = [];
  List<ClusterData> markerItems = [];
  List<ScrollableSheetData> sheetItems = [];
  String sheetTitle = "";
  String bottomSheetTitle = "";
  String iconAssetLink = "";

  @override
  void initState() {
    super.initState();
    getSensorItems();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            CustomGoogleMap(
                mode: 1,
                circleItems: circleItems,
                markerItems: markerItems,
                bottomTitle: bottomSheetTitle,
            ),
            CustomScrollableSheet(
              sheetItems: sheetItems,
              sheetTitle: sheetTitle,
              iconAsset: iconAssetLink,
            ),
          ],
        ),
      );
  }

  Future<void> getSensorItems() async {
    try {
      List<SensorInfo> value = await client.getSensorInformation();
      if (value.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          markerItems.add(ClusterData(
            id: value[i].id.toString(),
            latLng: LatLng(value[i].latitude, value[i].longitude),
            name: "임의 센서 장치", // value[i].deviceid,
            address: "임의 주소", // "${value[i].address} ${value[i].level} (${value[i].facility})",
            detail: null,
          ));
          sheetItems.add(ScrollableSheetData(
            leading: null,
            title: "단말번호: (임의 번호)", // ${value[i].deviceid.toString()}",
            subtitle: "임의 주소", // "${value[i].address} ${value[i].level} | ${value[i].etc} ",
            trailing: "임의 시설" // value[i].facility,
          ));
        }
        sheetItems.insert(
            0,
            ScrollableSheetData(
              leading: null,
              title: "-",
              subtitle: "-",
              trailing: null,));

        setState(() {
          sheetTitle = "센서";
          bottomSheetTitle = "해당 센서 정보";
          iconAssetLink = "assets/sensor.svg";
        });

      }
    } catch (error) {
      print(error);
    }
  }


}
