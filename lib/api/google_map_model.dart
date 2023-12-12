// import 'package:dio/dio.dart';
// import 'package:eqms_test/Api/Retrofit/rest_client.dart';
// import 'package:eqms_test/custom_googlemap/models/google_maps_models.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class GoogleMapModel with ChangeNotifier {
//   final dio = Dio();
//   late RestClient client = RestClient(dio);
//
//   final List<CircleData> _circleItems = [];
//   final List<ClusterData> _markerItems = [];
//   final List<ScrollableSheetData> _sheetItems = [];
//   String _sheetTitle = "";
//   String _bottomSheetTitle = "";
//   String _iconAsset = "";
//
//   List<CircleData> get circleItems => _circleItems;
//   List<ClusterData> get markerItems => _markerItems;
//   List<ScrollableSheetData> get sheetItems => _sheetItems;
//   String get sheetTitle => _sheetTitle;
//   String get bottomSheetTitle => _bottomSheetTitle;
//   String get iconAsset => _iconAsset;
//
//   Future<void> RemoveItems() async {
//     _circleItems.clear();
//     _markerItems.clear();
//     _sheetItems.clear();
//     _sheetTitle = "";
//     _bottomSheetTitle = "";
//     _iconAsset = "";
//
//     print('RemoveItems');
//
//     notifyListeners();
//   }
//
//   Future<void> EarthQuakeItems() async {
//     print('EarthQuakeItems');
//     _circleItems.clear();
//     _markerItems.clear();
//     _sheetItems.clear();
//     try {
//       List<EarthQuake> value = await client.getEarthQuake();
//       print('getEarthQuake: $value');
//       if (value.isNotEmpty) {
//         for (int i = 0; i < value.length; i++) {
//           _sheetItems.add(ScrollableSheetData(
//               leading: value[i].assoc_id.toString(),
//               title: "주소",
//               subtitle: value[i].update_time.toString(),
//               trailing: null,));
//         }
//         _sheetItems.insert(
//             0,
//             ScrollableSheetData(
//                 leading: null,
//                 title: "-",
//                 subtitle: "-",
//                 trailing: null,));
//       }
//       value.clear();
//       value = await client.getEarthQuakeOngoing();
//       print('getEarthQuakeOngoing: $value');
//       if (value.isNotEmpty) {
//         for (int i = 0; i < value.length; i++) {
//           _circleItems.add(CircleData(
//               id: value[i].id.toString(),
//               latLng: LatLng(value[i].lat, value[i].lng),
//               detail: value[i].update_time.toString(),
//               mangitude: value[i].assoc_id));
//         }
//       }
//       _sheetTitle = "최근 발생 지진";
//       _bottomSheetTitle = "해당 지진 정보";
//       _iconAsset = "assets/earthquake.svg";
//     } catch (error) {
//       print(error);
//     }
//     notifyListeners();
//   }
//
//   Future<void> ShelterItems() async {
//     print('ShelterItems');
//     _circleItems.clear();
//     _markerItems.clear();
//     _sheetItems.clear();
//     try {
//       print('ShelterItems sheet before: ${_sheetItems.length}');
//       List<Shelter> value = await client.getShelter();
//       if (value.isNotEmpty) {
//         for (int i = 0; i < value.length; i++) {
//           _markerItems.add(ClusterData(
//             id: i.toString(), // value[i].id.toString(),
//             latLng: LatLng(value[i].ycord, value[i].xcord),
//             name: value[i].vt_acmdfclty_nm, // shelter 이름 없음
//             address: value[i].dtl_adres,
//             detail: null,
//           ));
//           _sheetItems.add(ScrollableSheetData(
//               leading: null,
//               title: value[i].vt_acmdfclty_nm,
//               subtitle: value[i].dtl_adres,
//               trailing: null,));
//         }
//         _sheetItems.insert(
//             0,
//             ScrollableSheetData(
//                 leading: null,
//                 title: "-",
//                 subtitle: "-",
//                 trailing: null,));
//
//         _sheetTitle = "내 주변 대피소";
//         _bottomSheetTitle = "해당 대피소 정보";
//         _iconAsset = "assets/shelter.svg";
//       }
//     } catch (error) {
//       // TODO
//     }
//     print('ShelterItems sheet after: ${_sheetItems.length}');
//     notifyListeners();
//   }
//
//   Future<void> SensorItems() async {
//     _circleItems.clear();
//     _markerItems.clear();
//     _sheetItems.clear();
//     try {
//       List<SensorInfo> value = await client.getSensorInformation();
//       if (value.isNotEmpty) {
//         for (int i = 0; i < value.length; i++) {
//           _markerItems.add(ClusterData(
//             id: value[i].id.toString(),
//             latLng: LatLng(value[i].latitude, value[i].longitude),
//             name: value[i].deviceid,
//             address: "${value[i].address} ${value[i].level} (${value[i].facility})",
//             detail: null,
//           ));
//           _sheetItems.add(ScrollableSheetData(
//               leading: null,
//               title: "단말번호  ${value[i].deviceid.toString()}",
//               subtitle: "${value[i].address} ${value[i].level} | ${value[i].etc} ",
//               trailing: value[i].facility,));
//         }
//         _sheetItems.insert(
//             0,
//             ScrollableSheetData(
//                 leading: null,
//                 title: "-",
//                 subtitle: "-",
//                 trailing: null,));
//
//         _sheetTitle = "센서";
//         _bottomSheetTitle = "해당 센서 정보";
//         _iconAsset = "assets/sensor.svg";
//       }
//     } catch (error) {
//       // TODO
//     }
//     notifyListeners();
//   }
//
//   Future<void> EmergencyInstItems() async {
//     print('EmergencyInst');
//     _circleItems.clear();
//     _markerItems.clear();
//     _sheetItems.clear();
//     try {
//       print('Emergency sheet before: ${_sheetItems.length}');
//       List<EmergencyInst> value = await client.getEmergencyInst();
//       if (value.isNotEmpty) {
//         for (int i = 0; i < value.length; i++) {
//           _markerItems.add(ClusterData(
//             id: i.toString(), // value[i].id.toString(),
//             latLng: LatLng(value[i].latitude, value[i].longitude),
//             name: "[${value[i].med_category}]  ${value[i].institution}",
//             address: value[i].address,
//             detail: null,
//           ));
//           _sheetItems.add(ScrollableSheetData(
//               leading: null,
//               title: "[${value[i].med_category}]  ${value[i].institution}",
//               subtitle: value[i].address,
//               trailing: null,));
//         }
//         _sheetItems.insert(
//             0,
//             ScrollableSheetData(
//                 leading: null,
//                 title: "-",
//                 subtitle: "-",
//                 trailing: null,));
//
//         _sheetTitle = "응급시설";
//         _bottomSheetTitle = "응급시설 정보";
//         _iconAsset = "assets/emergeInst.svg";
//       }
//     } catch (error) {
//       // TODO
//     }
//     print('Emergency sheet after: ${_sheetItems.length}');
//     notifyListeners();
//   }
// }
