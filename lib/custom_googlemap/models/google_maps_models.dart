import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClusterData with ClusterItem {
  final String id;
  final LatLng latLng;
  String? name;
  final String address;
  String? detail;

  ClusterData({required this.id, required this.latLng, required this.name, required this.address, required this.detail});

  @override
  LatLng get location => latLng;
}

class CircleData{
  final String id;
  final LatLng latLng;
  final int mangitude;
  String? detail;

  CircleData({required this.id, required this.latLng,required this.detail, required this.mangitude});
}

class ScrollableSheetData {
  String? leading;
  final String title;
  final String subtitle;
  String? trailing;

  ScrollableSheetData(
      {required this.leading,
        required this.title,
        required this.subtitle,
        required this.trailing});
}
