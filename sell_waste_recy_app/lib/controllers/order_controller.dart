import 'dart:convert';
import 'package:sell_waste_recy_app/controllers/user_controller.dart';
import 'package:sell_waste_recy_app/models/order.dart';
import 'package:sell_waste_recy_app/models/order_line.dart';
import 'package:sell_waste_recy_app/models/payment.dart';
import 'package:http/http.dart' as http;
import 'package:sell_waste_recy_app/models/user.dart';
import '../models/sales_state.dart';
import '../models/seller_order.dart';
import 'auth.dart';

class OrderController {
  static Future<String> addOrder(Payment p,Order order,List<OrderLine> orderLines) async {
    String url = 'http://${AuthController.ip}:8017/addOrder';
    List<Map<String, dynamic>> orderLinesData = [];

    for (var orderLine in orderLines) {
      orderLinesData.add({
        'product_id': orderLine.product_id,
        'order_partner_id': orderLine.order_partner_id,
        'price_total': orderLine.price_total,
        'price_unit': orderLine.price_unit,
        'qty_to_deliver': orderLine.product_uom_qty,
        'salesman_id': orderLine.salesman_id,
        'state': orderLine.state,
      });
    }
  print(p.pay_id);
    Map<String, dynamic> body = {
     "payment":{
       "pay_id":p.pay_id ,
       "payer_id":p.payer_id,
       "currency":p.currency,
       "partner_city":p.partner_city,
       "partner_email":p.partner_email,
       "partner_id":p.partner_id,
       "partner_name":p.partner_name,
       "amount":p.amount,
       "payment_method_code":p.payment_method_code,
       "state":p.state
     },
      "order": {
        "amount_total": order.amount_total,
        "city_id": order.city_id,
        "date_order": order.date_order,
        "region_id": order.region_id,
        "partner_id": order.partner_id,
        "adresse":order.adresse
      },
      "order_lines":orderLinesData

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

    if(response.statusCode==200){
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Map<String,dynamic> result = jsonResponse['result'];
      return result['order'];
    }
return '';
  }
  static Future<List<OrderLine>> getOrders() async {
    String url = 'http://${AuthController.ip}:8017/getOrders';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'session_id=${AuthController.sessionID}'
    };
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        "partner_id": UserController.userId
      }),
    );
    List<OrderLine> orders=[];
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> result = jsonResponse['result'];
      orders =
      result.map((orderJson) => OrderLine.fromJson(orderJson)).toList();
    }
    return orders;

  }
  static Future<List<SellerOrder>> getOrdersBySeller() async {
    String url = 'http://${AuthController.ip}:8017/getOrdersBySeller';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'session_id=${AuthController.sessionID}'
    };
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        "seller_id": UserController.userId
      }),
    );
    List<SellerOrder> orders=[];
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> result = jsonResponse['result'];
      orders =
          result.map((orderJson) => SellerOrder.fromJson(orderJson)).toList();
    }
    return orders;
  }
  static Future<List<SellerOrder>> getOrdersBySellerState(String state) async {
    String url = 'http://${AuthController.ip}:8017/getOrdersBySellerState';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'session_id=${AuthController.sessionID}'
    };
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        "seller_id": UserController.userId,
        "state":state
      }),
    );
    List<SellerOrder> orders=[];
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> result = jsonResponse['result'];
      orders =
          result.map((orderJson) => SellerOrder.fromJson(orderJson)).toList();
    }
    return orders;
  }
  static Future<bool> updateOrderState(var order_line_id,String state) async {
    String url = 'http://${AuthController.ip}:8017/updateOrderLine';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'session_id=${AuthController.sessionID}'
    };
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        "order_line_id": order_line_id,
        "state":state
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Map<String, dynamic> result = jsonResponse['result'];
      return result['success'];

    }
    return false;
  }

  static Future<SalesState> getSalesState()async{
    String url = 'http://${AuthController.ip}:8017/getSellerStats';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'session_id=${AuthController.sessionID}'
    };
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        "seller_id":UserController.userId,
      }),
    );
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Map<String, dynamic> result = jsonResponse['result'];
      return SalesState(result['total_price_today'], result['total_units_today'], result['total_requests_today'], result['total_accepted_offers_today'],result['total_orders'],result['total_revenue'], result['draft_orders_count'], result['sent_orders_count'], result['sale_orders_count']);


  }

}
