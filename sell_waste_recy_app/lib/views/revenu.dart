import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sell_waste_recy_app/controllers/order_controller.dart';
import 'package:sell_waste_recy_app/models/sales_state.dart';

class Revenue extends StatefulWidget {
  const Revenue({super.key});

  @override
  State<Revenue> createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
  late SalesState? sales;
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSalesState();
  }
  void fetchSalesState()async{
    try {
      SalesState s=await OrderController.getSalesState();
      setState(() {
        sales=s;
      });
    } catch (e) {
      setState(() {

      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Analyse des ventes',
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
        body:  isLoading
            ? Center(child: CircularProgressIndicator())
            :Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.green,width: 0)),
          child: Column(

              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
               Container(
            height:50,
          decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 0),
          color: Colors.green,
        ),),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children:[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 0),
                          color: Colors.green,
                        ),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Colors.grey.shade100,
                                        width: 1.0,
                                      ),

                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('${sales?.total_orders}'),
                                        Text(
                                          'Orders',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Colors.grey.shade100,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('${sales?.draft_orders_count}'),
                                        Text(
                                          'En attente',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Colors.grey.shade100,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('${sales?.sent_orders_count}'),
                                        Text(
                                          'Confirmé',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(

                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('${sales?.sale_orders_count}'),
                                        Text(
                                          'Livré',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(color:Colors.green,child: SizedBox(height: 10,)),
                      Container(
                          decoration: BoxDecoration(color: Colors.white,border: Border.all(color: Colors.green,width: 0)),
                        child: Column(
                          children: [
                            Container(

                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green, width: 0),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(60),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                  color: Colors.green
                              ),
                              height: 50,
                              child: Container(
                                margin: EdgeInsets.only(left: 30, right: 30),
                                height: 5,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green.shade50, width: 0),
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(color: Colors.white,border: Border.all(color: Colors.white,width: 0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green.shade50, width: 0),
                                color: Colors.green.shade50,
                              ),
                              margin: EdgeInsets.only(left: 30, right: 30),
                              child: Center(
                                child: Text(
                                  '${sales?.total_revenue} MAD',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 30, right: 30),
                              padding: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green.shade50, width: 0),
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              height: 50,
                              child: Text(
                                'Revenus',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(decoration: BoxDecoration(color: Colors.white,border: Border.all(color: Colors.white,width: 0)),child: SizedBox(height: 30,)),
                      Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent.shade700,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.all(15),
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'Revenu Totale Aujourd\'hui',
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            FaIcon(
                                              FontAwesomeIcons.sackDollar,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 40),
                                        Text(
                                          '${sales?.total_price_today} MAD',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white)
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrangeAccent,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.all(15),
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'Commandes Aujourd\'hui',
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            FaIcon(
                                              FontAwesomeIcons.clipboardList,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 40),
                                        Text(
                                          '${sales?.total_requests_today}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white,width: 0)
                            ),
                            child: SizedBox(
                              height: 30,
                            ),
                          ),
                          Container(

                            padding:  EdgeInsets.only(bottom: 30),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.all(15),
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'Total d\'unités Aujourd\'hui',
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            FaIcon(
                                              FontAwesomeIcons.clipboardList,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 40),
                                        Text(
                                          '${sales?.total_units_today.toInt().toString()}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.pinkAccent.shade100,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.all(15),
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'Commandes Acceptées',
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 40),
                                        Text(
                                          '${sales?.total_accepted_offers_today}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),




              ]),
        )

    );
  }
}
