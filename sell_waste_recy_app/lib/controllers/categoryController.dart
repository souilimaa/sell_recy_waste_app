import 'dart:convert';

import 'package:http/http.dart' as http;

import '../auth.dart';
import '../models/category.dart';

class CategoryController {
  static Future<List<Category>> getCategories() async {
    const url = "http://10.10.10.32:8017/getAllCategories";

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
      print('succsess');
      return categories;
      } else {
        print(
            'Failed to get Categories. Status code: ${response.statusCode}'
        );
        return categories;
      }

  }
}
