import 'package:sell_waste_recy_app/models/order_line.dart';
import 'package:sell_waste_recy_app/models/user.dart';

class SellerOrder{
  User customer;
  OrderLine orderLine;
  var city;
  var region;
  var adresse;
  SellerOrder(this.customer,this.orderLine,this.city,this.region,this.adresse);
  factory SellerOrder.fromJson(Map<String, dynamic> json) {
    return SellerOrder(
      User.order(json['customer_name'],json['customer_email'],json['customer_phone']),
      OrderLine.SellerOrder(json['order_id'],json['order_line_id'], json['order_date'], json['name'],json['product_id'],json['product_uom_qty'], json['price_total'],json['state']),
      json['city'],
      json['region'],
      json['adresse']
    );
  }
}