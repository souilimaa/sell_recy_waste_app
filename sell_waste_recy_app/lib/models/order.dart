import 'order_line.dart';

class Order{
  int ? order_id;
  String ?name;
  double ?amount_total;
  int ?city_id;
  var date_order=null;
  int?  partner_id;
  int? region_id;
  String? adresse;
  List<OrderLine>? orderLines;
  Order(this.amount_total,this.city_id,this.date_order,this.partner_id,this.region_id,this.adresse);
  Order.OrderCustomer(this.order_id,this.name,this.orderLines);
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order.OrderCustomer(
      json['order_id'],
      json['name'],
      (json['order_lines'] as List)
          .map((orderLineJson) => OrderLine.fromJson(orderLineJson))
          .toList(),
    );
  }
}