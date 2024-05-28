import 'dart:convert';
import 'package:sell_waste_recy_app/controllers/user_controller.dart';

import '../models/product.dart';
import 'package:http/http.dart' as http;

import 'auth.dart';

class ProductController {
  static Future<bool> addProduct(Product p) async {
    String url = "http://${AuthController.ip}:8017/addProduct";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers
        .addAll({'Cookie': 'session_id=${AuthController.sessionID}'});
    request.fields['name'] = p.name;
    request.fields['description'] = p.description;
    request.fields['qty_available'] = p.qty_available.toString();
    print(p.qty_available);
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

  static Future<List<Product>> getProducts() async {
    String url = "http://${AuthController.ip}:8017/getAllProducts";

    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=${AuthController.sessionID}'
        },
        body: jsonEncode({}));
    List<Product> products = [];
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> productList = jsonResponse['result']['products'];

      products = productList.map((productJson) {
        return Product(
            productJson['id'],
            productJson['name'],
            productJson['description'],
            productJson['categ_id'],
            productJson['image'],
            productJson['qty_available'],
            productJson['seller_id'],
            productJson['list_price']);
      }).toList();
      print(products);
      print('success');
      return products;
    } else {
      print('Failed to get products code: ${response.statusCode}');
      return products;
    }
  }
  static Future<List<Product>> getProductsByCategory(int categoryId) async {
    String url = "http://${AuthController.ip}:8017/getProductsByCategory";

    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=${AuthController.sessionID}'
        },
        body: jsonEncode({'id':categoryId.toString()}));
    List<Product> products = [];
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> productList = jsonResponse['result']['products'];

      products = productList.map((productJson) {
        return Product(
            productJson['id'],
            productJson['name'],
            productJson['description'],
            productJson['categ_id'],
            productJson['image'],
            productJson['qty_available'],
            productJson['seller_id'],
            productJson['list_price']);
      }).toList();
      print(products);
      print('success');
      return products;
    } else {
      print('Failed to get products code: ${response.statusCode}');
      return products;
    }
  }
  static Future<List<Product>> getSearchedProducts(String name) async {
    String url = "http://${AuthController.ip}:8017/searchProducts";

    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=${AuthController.sessionID}'
        },
        body: jsonEncode({'name': name}));
    List<Product> products = [];
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> productList = jsonResponse['result']['products'];

      products = productList.map((productJson) {
        return Product(
            productJson['id'],
            productJson['name'],
            productJson['description'],
            productJson['categ_id'],
            productJson['image'],
            productJson['qty_available'],
            productJson['seller_id'],
            productJson['list_price']);
      }).toList();
      print(products);
      print('success');
      return products;
    } else {
      print('Failed to get products code: ${response.statusCode}');
      return products;
    }
  }
  static Future<Product> getProductById(int id) async {
    String url = "http://${AuthController.ip}:8017/getProduct";

    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=${AuthController.sessionID}'
        },
        body: jsonEncode({'id': id}));
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Map<String, dynamic> product = jsonResponse['result']['product'];

      Product myProduct =Product(product['id'], product['name'], product['description'], product['categ_id'], product['image'], product['qty_available'], product['seller_id'], product['list_price']);
      return myProduct;
  }
  static Future<List<dynamic>> getProductsBySeller() async {
    String url = "http://${AuthController.ip}:8017/getProductBySeller";

    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=${AuthController.sessionID}'
        },
        body: jsonEncode({'seller_id': UserController.userId}));
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final List<dynamic> product = jsonResponse['result'];
    return product;
  }
  static Future<void> updateProduct(var productId, var qtyAvailable, var listPrice) async {
    final url = Uri.parse('http://${AuthController.ip}:8017/updateProduct');

    final response = await http.post(
      url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=${AuthController.sessionID}'
        },
        body: jsonEncode({
          'product_id': productId,
          'qty_available': qtyAvailable,
          'liste_price': listPrice
        })
    );

    if (response.statusCode == 200) {
      print('Product updated successfully');
    } else {
      print('Error updating product: ${response.reasonPhrase}');
    }
  }

}
