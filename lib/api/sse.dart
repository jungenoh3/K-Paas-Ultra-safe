import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;


class SensorSSE {
  bool _isSubscribed = false;
  late StreamSubscription<String> _subscription;
  final StreamController<Map<String, dynamic>> _dataStreamController = StreamController<Map<String, dynamic>>();
  final client = http.Client();
  Stream<Map<String, dynamic>> get dataStream => _dataStreamController.stream;

  Future<Map<String, dynamic>> startListening(String sensorId) async {
    print('startListening: $sensorId');

    final url = Uri.parse('http://ingress-ngi-ingress-ngin-d7bea-21029333-dbc80b33461c.kr.lb.naverncp.com/sensor/sensorKafka/server-events?sensorId=$sensorId');
    final response = await client.send(http.Request('GET', url));
    int temp_num = Random().nextInt(1000);
    if (response.statusCode == 200){
      _isSubscribed = true;
      _subscription = response.stream.transform(utf8.decoder).listen((data) {
        if (data.length > 10 && data.contains("data:{")) {
          // print(data.trim().replaceAll('\n','').split("data:")[1]);
          final valueMap = jsonDecode(data.trim().replaceAll('\n','').split("data:")[1]);
          print(valueMap);
          valueMap['x'] -= temp_num;
          valueMap['y'] -= temp_num;
          valueMap['z'] -= temp_num;

          _dataStreamController.add(valueMap);
          return valueMap;
        }
      }, onError: (error) {
        print('onError occurred: $error');
      });
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
    return {"x": 0, "y": 0, "z": 0};
  }

  void stopListening() {
    print('stopListening');
    if(_isSubscribed){
      _subscription?.cancel();
      _dataStreamController.close();
    }
    _isSubscribed = false;
  }

}