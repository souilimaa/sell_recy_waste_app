import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/category.dart';
import 'auth.dart';

class CategoryController {
  static Future<List<Category>> getCategories() async {
    String url = "http://${AuthController.ip}:8017/getAllCategories";

      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'session_id=${AuthController.sessionID}'
          },
        body:json.encode({})

    );
    List<Category> categories=[];
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> categoryList = jsonResponse['result']['categories'];

      categories = categoryList.map((categoryJson) {
        return Category(categoryJson['id'], categoryJson['name']);
      }).toList();
      print(categories);
      print('success');
      return categories;
      } else {
        print(
            'Failed to get Categories. Status code: ${response.statusCode}'
        );
        return categories;
      }
  }
  static Future<String> getCategoryNameById(int categoryId) async {
    final url = Uri.parse('http://${AuthController.ip}:8017/getCategoryById');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session_id=${AuthController.sessionID}'
      },
      body: jsonEncode({
        'categ_id': categoryId,
      }
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final Map<String, dynamic> result = data['result'];
      if (result['success'] == true) {
        return result['category_name'];
      }
    }
    return '';
  }
}
