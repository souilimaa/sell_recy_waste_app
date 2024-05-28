import 'dart:convert';
import '../models/region.dart';
import 'auth.dart';
import 'package:http/http.dart' as http;

class RegionController{
  static Future<List<Region>> getRegions() async {
    String url = "http://${AuthController.ip}:8017/getRegions";

    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=${AuthController.sessionID}'
        },
        body: jsonEncode({}));
    List<Region> regions = [];
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> regionList = jsonResponse['result']['regions'];

      regions = regionList.map((regionJson) {
        return Region.jsonToRegion(regionJson);
      }).toList();
      print(regions);
      print('getting regions success');
      return regions;
    } else {
      print('Failed to get regions code: ${response.statusCode}');
      return regions;
    }
  }
}