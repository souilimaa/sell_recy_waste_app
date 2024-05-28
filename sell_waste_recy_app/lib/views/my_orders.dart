import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sell_waste_recy_app/controllers/order_controller.dart';
import '../controllers/auth.dart';
import '../controllers/product_controller.dart';
import '../models/order_line.dart';
import '../models/product.dart';
class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<OrderLine>? orders;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchOrders();

  }

  void fetchOrders() async {
    try {
      List<OrderLine> myOrders = await OrderController.getOrders();
      setState(() {
        orders = myOrders;
      });
    } catch (e) {
      setState(() {
        orders = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  Color getOrderStateColor(String state) {
    switch (state) {
      case 'En attente':
        return Colors.orange;
      case 'Confirmé':
        return Colors.pink;
      case 'Livré':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mes commandes',
              style: GoogleFonts.assistant(
                  textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ))),
          centerTitle: true,
          backgroundColor: Colors.green,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : (orders == null || orders!.isEmpty)
                ? Center(child: Text('No orders found'))
                : Container(
                    child: ListView.builder(
                        itemCount: orders?.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<Product>(
                              future: ProductController.getProductById(
                                  orders?[index].product_id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                     );
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData) {
                                  return Center(child: Text('No data found'));
                                } else {
                                  final product = snapshot.data!;
                                  return Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 0.3, color: Colors.grey),
                                      ),
                                    ),
                                    child: IntrinsicHeight(
                                        child: Container(
                                      margin:
                                          EdgeInsets.only(bottom: 20, top: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(20),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.grey[50]),
                                              child: Image.network(
                                                product.image,
                                                headers: {
                                                  'Cookie':
                                                      'session_id=${AuthController.sessionID}',
                                                },
                                                height: 60,
                                                width: 60,
                                              )),
                                          Expanded(
                                              child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        product.name,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${product.list_price} MAD",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "${orders?[index].orderName}/${orders?[index].order_line_id}",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    DateFormat('MMMM d, yyyy, h:mm a').format(DateTime.parse(orders![index].order_date)),
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                Spacer(),
                                                Flexible(
                                                    child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(5),
                                                      width: 90,
                                                      decoration:BoxDecoration(
                                                        color: getOrderStateColor(orders?[index].state).withOpacity(0.3),
                                                        borderRadius: BorderRadius.circular(20)
                                                      ),
                                                      child: Text(
                                                        "${orders?[index].state}",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: getOrderStateColor(orders?[index].state),
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                              ],
                                            ),
                                          )),
                                        ],
                                      ),
                                    )),
                                  );
                                }
                              });
                        })));
  }
}
