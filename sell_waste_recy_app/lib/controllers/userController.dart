import 'dart:convert';
import 'package:sell_waste_recy_app/models/user.dart';
import 'package:http/http.dart' as http;

import '../auth.dart';

class UserController {
  static int userId = 0;

  static Future<bool> getUserByEmail(String email) async {
    const url = "http://10.10.10.32:8017/getUserByEmail";

    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'session_id=${AuthController.sessionID}'
          },
          body: jsonEncode({'email': email}));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        bool success = jsonResponse['result']['success'];
        print(success);
        return success; // Return success value
      } else {
        print(
            'Failed to get user by email. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to get user by email. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to get user by email. Exception: $e');
    }
  }

  static Future<bool> SignUp(User u) async {
    try {
      bool isExist = await getUserByEmail(u.email);
      if (!isExist) {
        String url = 'http://10.10.10.32:8017/addUser';
        Map<String, dynamic> body = {
          "name": u.name,
          "email": u.email,
          "password": u.password,
          "phone": u.phone
        };
        Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=${AuthController.sessionID}'
        };
        http.Response response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(body),
        );
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          print(jsonResponse);
          return true;
        } else {
          print('Request failed with status: ${response.statusCode}');
          throw ("server error"); // Throw error for server issue
        }
      } else {
        return false;
      }
    } catch (error) {
      print('Error sending request: $error');
      throw ("server error"); // Throw error for server issue
    }
  }

  static Future<bool> login(User u) async {
      String url = 'http://10.10.10.32:8017/userLogin';
      Map<String, dynamic> body = {
        "email": u.email,
        "password": u.password,
      };
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Cookie': 'session_id=${AuthController.sessionID}'
      };
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        bool success = jsonResponse['result']['success'];
        if (success) {
          userId = jsonResponse['result']['user'];
          print(userId);
          return true;
        }
        else{
          return false;
        }
      }

        print('Failed to login. Status code: ${response.statusCode}');
        throw Exception('Failed to login. Status code: ${response.statusCode}');

  }


  static Future<User> getUserById(int id) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'session_id=${AuthController.sessionID}'
    };
    const url = "http://10.10.10.32:8017/getUser";
    var response = await http.post(Uri.parse(url),
        headers: headers,
        body: jsonEncode({"id": id}));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(jsonResponse);
      Map<String, dynamic> user=jsonResponse['result']['user'];
      String imageString=user['image'];
      if(imageString.isEmpty ){
        return User(user['id'],user['name'],user['email'],user['phone'],user['password'],"");
      }
      else{

        return User(user['id'],user['name'],user['email'],user['phone'],user['password'],imageString);

      }

    }

    throw Exception('Failed to get user. Status code: ${response.statusCode} }');
  }


  static Future<bool> updateUser(User u) async {
    const url = "http://10.10.10.32:8017/updateUser";
    print(u.id);
    print(u.name);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({
      'Cookie': 'session_id=${AuthController.sessionID}'
    });

    request.fields['id'] = u.id.toString();
    request.fields['name'] = u.name;
    request.fields['email'] = u.email;
    request.fields['password'] = u.password;
    request.fields['phone'] = u.phone;

    if (u.image != null) {
      var image = await http.MultipartFile.fromPath('image', u.image!.path);
      request.files.add(image);
    }

    // Send request
    var response = await request.send();
    // Read response
    var responseData = await response.stream.bytesToString();

    // Parse JSON response
    var jsonResponse = json.decode(responseData);
    if (response.statusCode == 200) {

      return jsonResponse['success'];
    } else {
      print("j");
      return false;
    }
  }


}
