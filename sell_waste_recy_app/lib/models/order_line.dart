class OrderLine{
  int? order_line_id;
var product_id;
var order_partner_id;
var price_total;
var price_unit;
var product_uom_qty;
var salesman_id;
var state;
var order_id;
var orderName;
var order_date;
OrderLine.SellerOrder(this.order_id,this.order_line_id,this.order_date,this.orderName,this.product_id,this.product_uom_qty,this.price_total,this.state);
OrderLine(this.product_id,this.order_partner_id,this.state,this.price_total,this.price_unit,this.product_uom_qty,this.salesman_id);
OrderLine.customerOrder(this.order_id,this.orderName,this.order_line_id,this.product_id,this.price_total,this.product_uom_qty,this.state,this.order_date);
  factory OrderLine.fromJson(Map<String, dynamic> json) {
    return OrderLine.customerOrder(
      json['order_id'],
      json['name'],
      json['order_line_id'],
       json['product_id'],
      json['price_total'].toDouble(),
       json['product_uom_qty'].toDouble(),
     json['state'],
      json['order_date']
    );
  }

}