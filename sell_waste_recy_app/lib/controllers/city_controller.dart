import 'dart:convert';
import '../models/city.dart';
import 'auth.dart';
import 'package:http/http.dart' as http;

class CityController{
  static Future<List<City>> getCitiesByRegion(int regionId) async {
    print("regino ${regionId}");
    String url = "http://${AuthController.ip}:8017/getCitiesByRegionId";

    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=${AuthController.sessionID}'
        },
    body: jsonEncode({'id':regionId}));

    List<City> cities = [];
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> cityList = jsonResponse['result']['cities'];

      cities = cityList.map((cityJson) {
        return City.jsonToCity(cityJson);
      }).toList();
      print('getting cities success ');
      return cities;
    } else {
      print('Failed to get cities code: ${response.statusCode}');
      return cities;
    }
  }
}