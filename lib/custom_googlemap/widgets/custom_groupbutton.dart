import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class CustomGroupButton extends StatelessWidget {
  final void Function(double, double, double) moveCamera;
  const CustomGroupButton({required this.moveCamera, super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: Colors.white,
      collapsedTextColor: Colors.grey[600],
      textColor: Colors.black,
      backgroundColor: Colors.white,
      initiallyExpanded: false,
      title: const Text("지역 선택"),
      children: [
        GroupButton<MapLocation>(
          isRadio: true,
          options: const GroupButtonOptions(
            mainGroupAlignment: MainGroupAlignment.start,
            crossGroupAlignment: CrossGroupAlignment.start,
            groupRunAlignment: GroupRunAlignment.start,
            groupingType: GroupingType.wrap,
          ),
          buttons: _mapLocation,
          buttonBuilder: (selected, value, context) {
            return TextButton(
              onPressed: () {
                moveCamera(value.latitude, value.longitude, value.zoomin);
              },
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.all(8.0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shadowColor: Colors.grey,
              ),
              child: Text(
                value.location,
                style: const TextStyle(
                  color: Colors.black,
                  inherit: false,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class MapLocation {
  final String location;
  final double latitude;
  final double longitude;
  final double zoomin;

  MapLocation(
      {required this.location,
      required this.latitude,
      required this.longitude,
      required this.zoomin});
}

final _mapLocation = [
  MapLocation(location: "강원", latitude: 37.830412, longitude: 128.226071, zoomin: 8),
  MapLocation(location: "경기", latitude: 37.586432, longitude: 127.046277, zoomin: 8),
  MapLocation(location: "경남", latitude: 35.4414209, longitude: 128.2417453, zoomin: 8),
  MapLocation(location: "경북", latitude: 36.6308397, longitude: 128.962578, zoomin: 8),
  MapLocation(location: "광주", latitude: 35.160032, longitude: 126.851338, zoomin: 8),
  MapLocation(location: "대구", latitude: 35.87139, longitude: 128.431445, zoomin: 10),
  MapLocation(location: "대전", latitude: 36.3504396, longitude: 127.3849508, zoomin: 8),
  MapLocation(location: "부산", latitude: 35.179816, longitude: 129.0750223, zoomin: 8),
  MapLocation(location: "서울", latitude: 37.5666103, longitude: 126.9783882, zoomin: 10),
  MapLocation(location: "세종", latitude: 36.4803512, longitude: 127.2894325, zoomin: 10),
  MapLocation(location: "울산", latitude: 35.5394773, longitude: 129.3112994, zoomin: 8),
  MapLocation(location: "인천", latitude: 37.4559418, longitude: 126.7051505, zoomin: 10),
  MapLocation(location: "전남", latitude: 34.9007274, longitude: 126.9571667, zoomin: 8),
  MapLocation(location: "전북", latitude: 35.6910153, longitude: 127.2368291, zoomin: 8),
  MapLocation(location: "제주", latitude: 33.4273366, longitude: 126.5758344, zoomin: 9),
  MapLocation(location: "충남", latitude: 36.6173379, longitude: 126.8453965, zoomin: 8),
  MapLocation(location: "충북", latitude: 36.7853718, longitude: 127.6551404, zoomin: 8),
];
