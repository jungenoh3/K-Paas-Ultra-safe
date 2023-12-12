import 'package:dio/dio.dart';
import 'package:eqms_test/api/retrofit/rest_client.dart';
import 'package:eqms_test/widgets/sensor_info/widgets/sensor_details/sensor_abnormal_list.dart';
import 'package:eqms_test/widgets/sensor_info/widgets/sensor_details/sensor_info_list.dart';
import 'package:flutter/material.dart';

class SensorDetails extends StatefulWidget {
  final int initialTabIndex;
  const SensorDetails({Key? key, this.initialTabIndex = 0})
      : super(key: key);
  @override
  State<SensorDetails> createState() => _SensorDetailsState();
}

class _SensorDetailsState extends State<SensorDetails> with TickerProviderStateMixin {
  final dio = Dio();
  late RestClient client = RestClient(dio);
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: widget.initialTabIndex,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "세부센서현황",
          style: TextStyle(color: Colors.black),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.deepOrange,
          unselectedLabelColor: Colors.black,
          labelColor: Colors.deepOrange,
          labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(
              child: Center(
                child: Text('센서 현황 리스트'),
              ),
            ),
            Tab(
              child: Center(
                child: Text('이상 센서 리스트'),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SensorInfoList(),
          SensorAbnormalList(),
        ],
      ),
    );
  }
}

