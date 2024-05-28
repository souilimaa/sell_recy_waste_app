import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthController {
  static String sessionID = "";
  static String ip="192.168.0.5";
  static Future<void> authenticate() async {
    var username = "somamy19@gmail.com";
    var password = "salma.04";
    String url = "http://${ip}:8017/web/session/authenticate";

    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "jsonrpc": "2.0",
          "params": {"db": "RecySales", "login": username, "password": password}
        }));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var uid = jsonResponse['result']['uid'];
      String sessionId = "";
      if (response.headers.containsKey('set-cookie')) {
        var cookies = response.headers['set-cookie']?.split(';');
        for (var cookie in cookies ?? []) {
          if (cookie.contains('session_id')) {
            sessionId = cookie.split('=').last.trim();
            break;
          }
        }
      }

      // Print or use the session_id as needed
      sessionID = sessionId;
    } else {
      throw Exception('Failed to authenticate');
    }
  }
}
