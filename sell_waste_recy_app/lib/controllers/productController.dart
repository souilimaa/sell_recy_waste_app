import 'dart:convert';

import '../auth.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

class ProductController{
  static Future<bool> AddProduct(Product p) async {
    const url = "http://10.10.10.32:8017/addProduct";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({
      'Cookie': 'session_id=${AuthController.sessionID}'
    });
    request.fields['name'] = p.name;
    request.fields['description'] = p.description;
    request.fields['qty_available'] = p.qty_available.toString();
    request.fields['categ_id'] = p.categ_id.toString();
    request.fields['seller_id'] = p.seller_id.toString();
    request.fields['list_price'] = p.list_price.toString();




      var image = await http.MultipartFile.fromPath('image', p.image!.path);
      request.files.add(image);

    // Send request
    var response = await request.send();
    // Read response
    var responseData = await response.stream.bytesToString();

    // Parse JSON response
    var jsonResponse = json.decode(responseData);
    if (response.statusCode == 200) {

      return jsonResponse['success'];
    } else {
      print("failed to add product ${response.statusCode}");
      return false;
    }
  }
}