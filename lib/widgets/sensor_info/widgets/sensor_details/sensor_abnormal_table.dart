import 'package:eqms_test/api/retrofit/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';


List<Sensor> sensors = <Sensor>[];
const int _rowsPerPage = 8;

class SensorAbnormalTable extends StatefulWidget {
  final List<SensorAbnormal> sensorValue;
  const SensorAbnormalTable({required this.sensorValue, Key? key})
      : super(key: key);

  @override
  SensorAbnormalTableState createState() => SensorAbnormalTableState();
}

class SensorAbnormalTableState extends State<SensorAbnormalTable> {
  late SensorDataSource sensorDataSource;

  @override
  void initState() {
    super.initState();
    updateSensorData();
  }

  @override
  void didUpdateWidget(covariant SensorAbnormalTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateSensorData();
  }

  void updateSensorData() {
    sensors = getSensorData();
    sensorDataSource = SensorDataSource(sensorData: sensors);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sensorValue.isEmpty) {
      return const Center(child: Text('데이터가 없습니다.'));
    }
    return LayoutBuilder(builder: (context, constraint) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SfDataGrid(
              source: sensorDataSource,
              columnWidthMode: ColumnWidthMode.fill,
              columns: <GridColumn>[
                GridColumn(
                    columnName: 'id',
                    autoFitPadding: const EdgeInsets.all(5.0),
                    label: Container(
                        padding: const EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        child: const Text(
                          '단말번호',
                        ))),
                GridColumn(
                    columnName: 'address',
                    autoFitPadding: const EdgeInsets.all(5.0),
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          '주소 (상세)',
                          overflow: TextOverflow.clip,
                        ))),
                GridColumn(
                    columnName: 'accelerator',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          '가속도',
                          overflow: TextOverflow.ellipsis,
                        ))),
                GridColumn(
                    columnName: 'pressure',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('온도'))),
                GridColumn(
                    columnName: 'temperature',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('기압계'))),
                GridColumn(
                    columnName: 'fault_message',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('Fault Message'))),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: SfDataPagerTheme(
              data: SfDataPagerThemeData(
                selectedItemColor: Colors.deepOrange,
                itemBorderColor: Colors.transparent,
                itemBorderRadius: BorderRadius.circular(5),
              ),
              child: SfDataPager(
                itemWidth: 30,
                itemHeight: 40,
                delegate: sensorDataSource,
                pageCount: (sensors.length / _rowsPerPage)
                    .ceilToDouble(), // employees.length / _rowsPerPage,
                direction: Axis.horizontal,
              ),
            ),
          )
        ],
      );
    });
  }

  List<Sensor> getSensorData() {
    return widget.sensorValue
        .map((e) => Sensor(e.deviceid, e.address, e.accelerator, e.pressure,
            e.temperature, e.fault_message))
        .toList();
  }
}

class Sensor {
  Sensor(this.id, this.address, this.accelerator, this.pressure,
      this.temperature, this.faultMessage);

  final String id;
  final String address;
  final String? accelerator;
  final String? pressure;
  final String? temperature;
  final String? faultMessage;
}

class SensorDataSource extends DataGridSource {
  List<Sensor> _paginatedSensors = [];

  SensorDataSource({required List<Sensor> sensorData}) {
    _paginatedSensors =
        sensors.getRange(0, _rowsPerPage).toList(growable: false);
    buildPaginatedDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          e.value.toString(),
          style: const TextStyle(fontSize: 11),
        ),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    // print('startIndex: ${startIndex}, endIndex: ${endIndex}, employees.length: ${employees.length}');
    if (startIndex < sensors.length && endIndex <= sensors.length) {
      _paginatedSensors =
          sensors.getRange(startIndex, endIndex).toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else if (startIndex < sensors.length) {
      _paginatedSensors =
          sensors.getRange(startIndex, sensors.length).toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      _paginatedSensors = [];
    }
    return true;
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = _paginatedSensors
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'id', value: '임의 아이디'),// e.id),
              DataGridCell<String>(columnName: 'address', value: '임의 주소'),// e.address),
              DataGridCell<String>(
                  columnName: 'accelerator', value: e.accelerator),
              DataGridCell<String>(columnName: 'pressure', value: e.pressure),
              DataGridCell<String>(
                  columnName: 'temperature', value: e.temperature),
              DataGridCell<String>(
                  columnName: 'faultMessage', value: e.faultMessage),
            ]))
        .toList();
  }
}
