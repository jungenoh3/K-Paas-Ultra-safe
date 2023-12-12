import 'dart:async';
import 'dart:ui';
import 'package:eqms_test/api/sse.dart';
import 'package:eqms_test/custom_googlemap/models/google_maps_models.dart';
import 'package:eqms_test/custom_googlemap/widgets/custom_bottomsheet.dart';
import 'package:eqms_test/custom_googlemap/widgets/custom_floatingbutton.dart';
import 'package:eqms_test/custom_googlemap/widgets/custom_groupbutton.dart';
import 'package:eqms_test/style/color_guide.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class CustomGoogleMap extends StatefulWidget {
  final int mode;
  final String bottomTitle;
  final List<CircleData> circleItems;
  final List<ClusterData> markerItems;

  const CustomGoogleMap(
      {required this.mode,
      required this.bottomTitle,
      required this.circleItems,
      required this.markerItems,
      Key? key,})
      : super(key: key);

  @override
  State<CustomGoogleMap> createState() => CustomGoogleMapState();
}

class CustomGoogleMapState extends State<CustomGoogleMap> {
  late ClusterManager _manager;
  final Completer<GoogleMapController> _controller = Completer();
  bool _isPermissionGranted = false;
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  SensorSSE? sensorSSE;

  final CameraPosition _cameraPosition =
      const CameraPosition(target: LatLng(35.8881525, 128.6109335), zoom: 6.5);

  @override
  void initState() {
    super.initState();
    print('google_map initState');
    checkPermission().then((value) {
      setState(() {
        if (value == '위치 권한이 허가되었습니다.') {
          _isPermissionGranted = true;
        }
      });
    });
    _manager = _initClusterManager();
    _updateClusterData();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<ClusterData>(
      widget.markerItems,
      _updateMarkers,
      markerBuilder: _markerBuilder,
      levels: [1, 4, 6.8, 9, 11, 13, 15, 17, 19, 20],
    );
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  Set<Circle> _updateCircles(List<CircleData> value) {
    Set<Circle> circles = {};
    if (value.isNotEmpty) {
      for (int i = 0; i < value.length; i++) {
        circles.add(Circle(
          circleId: CircleId(value[i].id),
          center: value[i].latLng,
          fillColor: Colors.blue.withOpacity(0.5),
          radius: value[i].mangitude * 10000,
          strokeColor: Colors.blueAccent,
          strokeWidth: 1,
          onTap: () {
            BottomSheets.showItemBottomSheet(
                context,
                widget.mode,
                widget.bottomTitle,
                null,
                "진도: ${value[i].mangitude}",
                "위치: (${value[i].latLng.latitude}, ${value[i].latLng.longitude})");
          },
          consumeTapEvents: true,
        ));
      }
    }
    return circles;
  }

  @override
  void didUpdateWidget(covariant CustomGoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateClusterData();
  }

  void _updateClusterData() {
    circles.clear();
    markers.clear();
    _manager.setItems(widget.markerItems);
    circles = _updateCircles(widget.circleItems);
  }

  @override
  void dispose() {
    if (sensorSSE != null){
      print('dispose: sensorSSE dispose');
      sensorSSE!.stopListening();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('google_map build');
    return _isPermissionGranted ? buildGoogleMap() : buildPermissionDenied();
  }

  Widget buildGoogleMap() {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _cameraPosition,
          markers: markers,
          circles: circles,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          cameraTargetBounds: CameraTargetBounds(LatLngBounds(southwest: LatLng(32.972997240652575, 125.25859248865342), northeast: LatLng(39.097067, 131.545519))),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _manager.setMapId(controller.mapId);
          },
          onCameraMove: _manager.onCameraMove,
          onCameraIdle: _manager.updateMap,
          zoomControlsEnabled: false,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
        ),
        Visibility(
          visible: widget.mode == 1,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomGroupButton(
              moveCamera: moveLocation,
            ),
          ),
        ),
        Positioned(
            right: 10,
            bottom: 400,
            child: CustomFloatingButton(onMoveCamera: currentLocation)),
      ],
    );
  }

  Future<void> currentLocation() async {
    Geolocator.getCurrentPosition().then((value) async {
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 14);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  Future<void> moveLocation(
      double latitude, double longitude, double zoom) async {
    CameraPosition cameraPosition =
        CameraPosition(target: LatLng(latitude, longitude), zoom: zoom);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Widget buildPermissionDenied() {
    return const Center(
      child: Text('위치 서비스를 활성화 해주세요.'),
    );
  }

  Future<String> checkPermission() async {
    // GPS 켜져있는지
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      return '위치 서비스를 활성화 해주세요.';
    }
    // GPS 권한이 있는지
    LocationPermission checkPermission = await Geolocator.checkPermission();

    if (checkPermission == LocationPermission.denied) {
      checkPermission = await Geolocator.requestPermission();
      if (checkPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요.';
      }
    }
    if (checkPermission == LocationPermission.deniedForever) {
      return '위치 권한을 세팅에서 허가해주세요.';
    }
    return '위치 권한이 허가되었습니다.';
  }

  Future<Marker> Function(Cluster<ClusterData>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            if (!cluster.isMultiple) {
              print('widget.mode: ${widget.mode}');
              if(widget.mode == 1){
                sensorSSE = SensorSSE();
                sensorSSE!.startListening("1232971431");
              }
              BottomSheets.showItemBottomSheet(
                context,
                widget.mode,
                widget.bottomTitle,
                sensorSSE,
                cluster.items.single.name,
                cluster.items.single.address,
              );
            }
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
          // 마지막 마커 png로 표시 - 추후에 이미지 변경
          // cluster.isMultiple ? await _getMarkerBitmap(125,
          //     text: cluster.count.toString())
          //     : await bitmapDescriptorFromImgAsset(context, "assets/maps-and-flags.png", 100),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = primaryOrange;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1); // 테두리 원
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2); // 흰 테두리
    canvas.drawCircle(
        Offset(size / 2, size / 2), size / 2.8, paint1); // 제일 안에 있는 원

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  Future<BitmapDescriptor> bitmapDescriptorFromImgAsset(
    BuildContext context,
    String assetName,
    int size,
  ) async {
    ByteData data = await rootBundle.load(assetName);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: size);
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? bytes = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }
}
