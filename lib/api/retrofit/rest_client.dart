import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'http://ingress-ngi-ingress-ngin-d7bea-21029333-dbc80b33461c.kr.lb.naverncp.com')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST('/fcm/check')
  Future<String> postFcmToken(@Body() String fcmToken);

  @POST('/users/register')
  Future<String> postUserInfo(@Queries() Map<String, String> registerData);

  @GET('/users/login')
  Future<String> getRegisterInfo(@Queries() Map<String, String> loginData);


  @GET('/sensor/sensor/count')
  Future<SensorCount> getSensorCount();

  @GET('/sensor/sensor-info/all')
  Future<List<SensorInfo>> getSensorInformation();

  @GET('/sensor/sensor-info/region')
  Future<List<String>> getSensorInfoRegion();

  @GET('/sensor/sensor-info/facility')
  Future<List<String>> getSensorInfoFacility();

  @GET('/sensor/sensor-info/search')
  Future<List<SensorInfo>> getSensorSearch(@Queries() Map<String, String> queries);


  @GET('/sensor/sensor-abnormal/region')
  Future<List<String>> getSensorAbnormalRegion();

  @GET('/sensor/sensor-abnormal/facility')
  Future<List<String>> getSensorAbnormalFacility();

  @GET('/sensor/sensor-abnormal/search')
  Future<List<SensorAbnormal>> getSensorAbnormalSearch(@Queries() Map<String, String> queries);


  @GET('/data/shelterData')
  Future<List<Shelter>> getShelter();

  @GET('/data/shelterNearData')
  Future<List<Shelter>> getShelterNear(@Queries() Map<String, double> queries);

  @GET('/data/emergencyData')
  Future<List<EmergencyInst>> getEmergencyInst();

  @GET('/data/emergencyNearData')
  Future<List<EmergencyInst>> getEmergencyInstNear(@Queries() Map<String, double> queries);

  @GET('/alarm/earthquake/ongoing')
  Future<List<EarthQuake>> getEarthQuakeOngoing();

  @GET('/alarm/earthquake/all')
  Future<List<EarthQuake>> getEarthQuake();



}

@JsonSerializable()
class User {
  String name;
  String identification;
  String password;
  String phoneNumber;
  String email;

  User({required this.name, required this.identification, required this.password, required this.phoneNumber, required this.email});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class SensorCount {
  int abnormal_sensor;
  int all_sensor;

  SensorCount({required this.abnormal_sensor, required this.all_sensor});
  factory SensorCount.fromJson(Map<String, dynamic> json) => _$SensorCountFromJson(json);
  Map<String, dynamic> toJson() => _$SensorCountToJson(this);
}

@JsonSerializable()
class SensorInfo {
  int id;
  String deviceid;
  double latitude;
  double longitude;
  String address;
  String manu_comp;
  String? facility;
  String level;
  String? etc;
  String region;

  SensorInfo({required this.id, required this.deviceid, required this.latitude, required this.longitude,
    required this.address, required this.manu_comp, this.facility, required this.level, required this.etc, required this.region});

  factory SensorInfo.fromJson(Map<String, dynamic> json) => _$SensorInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SensorInfoToJson(this);
}

@JsonSerializable()
class SensorAbnormal {
  int id;
  String deviceid;
  String? accelerator;
  String? pressure;
  String? temperature;
  String? noise_class;
  String? fault_message;
  String address;
  String region;

  SensorAbnormal({required this.id, required this.deviceid, required this.accelerator, required this.pressure,
    required this.temperature, required this.noise_class, this.fault_message, required this.address, required this.region});

  factory SensorAbnormal.fromJson(Map<String, dynamic> json) => _$SensorAbnormalFromJson(json);
  Map<String, dynamic> toJson() => _$SensorAbnormalToJson(this);
}

@JsonSerializable()
class Shelter {
  String shel_nm;
  String address;
  double lon;
  double lat;

  Shelter({required this.shel_nm, required this.address, required this.lon, required this.lat});

  factory Shelter.fromJson(Map<String, dynamic> json) => _$ShelterFromJson(json);
  Map<String, dynamic> toJson() => _$ShelterToJson(this);
}

@JsonSerializable()
class EarthQuake {
  int id;
  int assoc_id;
  double lat;
  double lng;
  DateTime update_time;

  EarthQuake({required this.id, required this.assoc_id, required this.lat, required this.lng, required this.update_time});

  factory EarthQuake.fromJson(Map<String, dynamic> json) => _$EarthQuakeFromJson(json);
  Map<String, dynamic> toJson() => _$EarthQuakeToJson(this);
}

@JsonSerializable()
class EmergencyInst {
  String institution;
  String address;
  String med_category;
  double latitude;
  double longitude;

  EmergencyInst({required this.institution, required this.address, required this.med_category, required this.latitude, required this.longitude});

  factory EmergencyInst.fromJson(Map<String, dynamic> json) => _$EmergencyInstFromJson(json);
  Map<String, dynamic> toJson() => _$EmergencyInstToJson(this);
}