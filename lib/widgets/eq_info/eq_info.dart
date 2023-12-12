import 'package:dio/dio.dart';
import 'package:eqms_test/api/retrofit/rest_client.dart';
import 'package:eqms_test/custom_googlemap/custom_googlemap.dart';
import 'package:eqms_test/custom_googlemap/models/google_maps_models.dart';
import 'package:eqms_test/custom_googlemap/widgets/custom_scrollablesheet.dart';
import 'package:eqms_test/widgets/eq_info/widgets/custom_choicechips.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class EQInfo extends StatefulWidget {
  const EQInfo({super.key});

  @override
  State<EQInfo> createState() => _EQInfoState();
}

class _EQInfoState extends State<EQInfo> {
  final dio = Dio();
  late RestClient client = RestClient(dio);

  int? _selectedIndex;
  List<CircleData> circleItems = [];
  List<ClusterData> markerItems = [];
  List<ScrollableSheetData> sheetItems = [];
  String sheetTitle = "";
  String bottomSheetTitle = "";
  String iconAssetLink = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          CustomGoogleMap(
            circleItems: circleItems,
            markerItems: markerItems,
            mode: 0,
            bottomTitle: bottomSheetTitle,
          ),
          CustomCategory(
            selectedIndex: _selectedIndex ?? -1,
            onSelected: (int? index) {
              setState(() {
                _selectedIndex = index;
              });
              _handleSelection(_selectedIndex);
            },
          ),
          CustomScrollableSheet(
            sheetItems: sheetItems,
            sheetTitle: sheetTitle,
            iconAsset: iconAssetLink,
          ), // scrollablesheet
        ],
      ),
    );
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  void _handleSelection(int? selectedIndex) {
    switch (_selectedIndex) {
      case null:
        removeData();
        break;
      case 0:
        removeData();
        getEarthquakeItems();
        break;
      case 1:
        removeData();
        getShelterItems();
        break;
      case 2:
        removeData();
        getEmergencyInstItems();
      default:
        if (circleItems.isNotEmpty) {
          circleItems.clear();
        }
        if (markerItems.isNotEmpty) {
          markerItems.clear();
        }
        if (sheetItems.isNotEmpty) {
          sheetItems.clear();
        }
        break;
    }
  }

  void removeData() {
    if (circleItems.isNotEmpty) {
      circleItems.clear();
    }
    if (markerItems.isNotEmpty) {
      markerItems.clear();
    }
    if (sheetItems.isNotEmpty) {
      sheetItems.clear();
    }
  }

  Future<void> getEarthquakeItems() async {
    try {
      List<EarthQuake> value = await client.getEarthQuake();
      if (value.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          sheetItems.add(ScrollableSheetData(
              leading: value[i].assoc_id.toString(),
              title: '임의의 주소',
              subtitle: value[i].update_time.toString(),
              trailing: null));
        }
        sheetItems.insert(
            0,
            ScrollableSheetData(
              leading: null,
              title: "-",
              subtitle: "-",
              trailing: null,
            ));
      }
      value.clear();
      value = await client.getEarthQuakeOngoing();
      if (value.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          circleItems.add(CircleData(
              id: value[i].id.toString(),
              latLng: LatLng(value[i].lat, value[i].lng),
              detail: value[i].update_time.toString(),
              mangitude: value[i].assoc_id));
        }
      }
    } catch (error) {
      print(error);
    }
    setState(() {
      // build 호출용
      sheetTitle = "최근 발생 지진";
      bottomSheetTitle = "해당 지진 정보";
      iconAssetLink = "assets/earthquake.svg";
    });
  }

  Future<void> getShelterItems() async {
    try {
      Position position = await getCurrentLocation();
      Map<String, double> queries = {
        'lat': position.latitude,
        'lon': position.longitude
      };
      print(queries);

      List<Shelter> value = await client.getShelterNear(queries);


      if (value.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          markerItems.add(ClusterData(
            id: i.toString(), // value[i].id.toString(),
            latLng: LatLng(value[i].lat, value[i].lon),
            name: value[i].shel_nm, // shelter 이름 없음
            address: value[i].address,
            detail: null,
          ));
          if (sheetItems.length < 50) {
            sheetItems.add(ScrollableSheetData(
              leading: null,
              title: value[i].shel_nm,
              subtitle: '${value[i].address} (${(i+1)*5}m 거리)',
              trailing: null,
            ));
          }
        }
        sheetItems.insert(
            0,
            ScrollableSheetData(
              leading: null,
              title: "-",
              subtitle: "-",
              trailing: null,
            ));
      }
      setState(() {
        sheetTitle = "내 주변 대피소";
        bottomSheetTitle = "해당 대피소 정보";
        iconAssetLink = "assets/shelter.svg";
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> getEmergencyInstItems() async {
    try {
      Position position = await getCurrentLocation();
      Map<String, double> queries = {
        'lat': position.latitude,
        'lon': position.longitude
      };
      List<EmergencyInst> value = await client.getEmergencyInstNear(queries);

      if (value.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          markerItems.add(ClusterData(
            id: i.toString(), // value[i].id.toString(),
            latLng: LatLng(value[i].latitude, value[i].longitude),
            name: "[${value[i].med_category}]  ${value[i].institution}",
            address: value[i].address,
            detail: null,
          ));
          if (sheetItems.length < 50) {
            sheetItems.add(ScrollableSheetData(
              leading: null,
              title: "[${value[i].med_category}]  ${value[i].institution}",
              subtitle: '${value[i].address} (${(i+1)*5}m 거리)',
              trailing: null,
            ));
          }
        }
        sheetItems.insert(
            0,
            ScrollableSheetData(
              leading: null,
              title: "-",
              subtitle: "-",
              trailing: null,
            ));
      }
      setState(() {
        sheetTitle = "응급시설";
        bottomSheetTitle = "응급시설 정보";
        iconAssetLink = "assets/emergeInst.svg";
      });
    } catch (error) {
      print(error);
    }
  }
}
