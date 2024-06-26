import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:sell_waste_recy_app/controllers/user_controller.dart';
import '../controllers/auth.dart';
import '../controllers/order_controller.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import '../models/seller_order.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class SellerOrders extends StatefulWidget {
  const SellerOrders({super.key});

  @override
  State<SellerOrders> createState() => _SellerOrdersState();
}

class _SellerOrdersState extends State<SellerOrders> {
  String selectedOrdersState = '';
  List<String> ordersList = ['En attente', 'Confirmé', 'Livré'];
  List<SellerOrder>? orders;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
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
  String getStateButton(String state){
    if(state=="En attente"){
      return "Confirmer la commande";
    }
    else if(state=="Confirmé"){
      return "Marquer comme Livré";
    }
    return '';

  }

  void fetchOrders() async {
    try {
      List<SellerOrder> myOrders = await OrderController.getOrdersBySeller();
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
  void fetchOrdersbyState(String state) async {
    try {
      if(state=="En attente"){
        state="draft";
      }
      else if(state=="Confirmé"){
        state="sent";
      }
      else if(state=="Livré"){
        state="sale";
      }
      List<SellerOrder> myOrders = await OrderController.getOrdersBySellerState(state);
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

  void sendEmail(String email_destinataire,String state, SellerOrder order,String p) async {
    String username = 'somamy19@gmail.com';
    String password = 'kholhdjtnwuytbsx';

    final smtpServer = gmail(username, password);
    final emailBody = """
  Bonjour ${order.customer.name},

  Nous avons le plaisir de vous informer que votre commande a été $state avec succès.

  Détails de la commande :

      Numéro de commande : ${order.orderLine.orderName}/${order.orderLine.order_line_id}
      Date de commande : ${order.orderLine.order_date}
      Produit commandé : ${p}
      

  Merci pour votre confiance et votre achat sur EcoTrade. 

  Cordialement,

  L'équipe EcoTrade
  """;
    final message = Message()
      ..from = Address(username, 'EcoTrade')
      ..recipients.add(email_destinataire)
      ..subject = 'Nouvelle commande reçue sur EcoTrade'
      ..text = emailBody;

    try {
      final sendReport = await send(message, smtpServer);
      print('E-mail envoyé: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('E-mail non envoyé.${e}');

    }
  }
  Future<void> _createAndSavePdf(SellerOrder order, Product product) async {
    final pdf = pw.Document();

    // Add content to the PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center, // Center align the column
            children: [
              pw.Text('Facture de la commande #${order.orderLine.orderName}/${order.orderLine.order_line_id}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18), // Increase font size
                  textAlign: pw.TextAlign.center), // Center align the text
              pw.SizedBox(height: 20),
              pw.Text('Informations sur la commande:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16), // Increase font size
                  textAlign: pw.TextAlign.center), // Center align the text
              pw.Text('Nom du produit: ${product.name}', style: pw.TextStyle(fontSize: 14)), // Increase font size
              pw.Text('Quantité: ${order.orderLine.product_uom_qty?.toInt().toString()}', style: pw.TextStyle(fontSize: 14)), // Increase font size
              pw.Text('Prix unitaire: ${product.list_price} MAD', style: pw.TextStyle(fontSize: 14)), // Increase font size
              pw.Text('Prix total: ${product.list_price*order.orderLine.product_uom_qty} MAD', style: pw.TextStyle(fontSize: 14)), // Increase font size
              pw.SizedBox(height: 20),
              pw.Text('Informations sur le client:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16), // Increase font size
                  textAlign: pw.TextAlign.center), // Center align the text
              pw.Text('Nom: ${order.customer.name}', style: pw.TextStyle(fontSize: 14)), // Increase font size
              pw.Text('Téléphone: ${order.customer.phone}', style: pw.TextStyle(fontSize: 14)), // Increase font size
              pw.SizedBox(height: 20),
              pw.Text('Adresse de livraison:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16), // Increase font size
                  textAlign: pw.TextAlign.center), // Center align the text
              pw.Text(order.adresse, style: pw.TextStyle(fontSize: 14)), // Increase font size
              pw.Text('${order.city}, ${order.region}', style: pw.TextStyle(fontSize: 14)), // Increase font size
            ],
          );
        },
      ),

    );

    try {
      // Ensure the downloads directory exists
      Directory downloadsDirectory = Directory('/storage/emulated/0/Download');
      if (!await downloadsDirectory.exists()) {
        downloadsDirectory.create(recursive: true);
      }

      // Generate a unique file name
      String fileName = 'facture_commande_${order.orderLine.orderName}_${order.orderLine.order_line_id}.pdf';
      int counter = 1;
      while (await File('${downloadsDirectory.path}/$fileName').exists()) {
        fileName = 'facture_commande_${order.orderLine.order_line_id}_$counter.pdf';
        counter++;
      }

      File pdfFile = File('${downloadsDirectory.path}/$fileName');

      // Save the PDF file
      await pdfFile.writeAsBytes(await pdf.save());

      // Open the PDF file
      await OpenFile.open(pdfFile.path);
    } catch (e) {
      print('Error: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Les Commandes',
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
        body:Column(
            children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 42,
                margin: EdgeInsets.only(top: 20, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedOrdersState = '';
                      fetchOrders();

                    });
                  },
                  child: Text(
                    'Tout',
                    style: TextStyle(
                      color: selectedOrdersState == ''
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(26)),
                      side: BorderSide(
                          color: selectedOrdersState == ''
                              ? Colors.green
                              : Colors.black,
                          width: 1.5),
                    ),
                    backgroundColor: selectedOrdersState == ''
                        ? Colors.green
                        : Colors.white,
                  ),
                ),
              ),
              ...ordersList.map((orderState) {
                return Container(
                    width: 129,
                    height: 42,
                    margin:
                    const EdgeInsets.only(top: 20, right: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedOrdersState = orderState;
                          fetchOrdersbyState(selectedOrdersState);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(26)),
                            side: BorderSide(
                                color: selectedOrdersState ==
                                    orderState
                                    ? Colors.green
                                    : Colors.black,
                                width: 1.5)),
                        backgroundColor:
                        selectedOrdersState == orderState
                            ? Colors.green
                            : Colors.white,
                      ),
                      child: Text(
                        orderState,
                        style: TextStyle(
                          color: selectedOrdersState == orderState
                              ? Colors.white
                              : Colors.black,
                          fontFamily: 'Noto Sans JP',
                        ),
                      ),
                    ));
              }),
            ],
          ),
        ),isLoading
            ? Center(child: CircularProgressIndicator())
            : (orders == null || orders!.isEmpty)
                ? Expanded(child:Center(child: Text('No orders found')))
                :

                    Expanded(
                      child: ListView.builder(
                        itemCount: orders?.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<Product>(
                            future: ProductController.getProductById(
                                orders?[index].orderLine.product_id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center();
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData) {
                                return Center(child: Text('No data found'));
                              } else {
                                final product = snapshot.data!;
                                return Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 0.3, color: Colors.grey),
                                    ),
                                  ),
                                  child: IntrinsicHeight(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(bottom: 5, top: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.grey[50],
                                            ),
                                            child: Image.network(
                                              product.image,
                                              headers: {
                                                'Cookie':
                                                    'session_id=${AuthController.sessionID}',
                                              },
                                              height: 60,
                                              width: 60,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                      "${orders?[index].orderLine.orderName}/${orders?[index].orderLine.order_line_id} ${DateFormat('MMMM d, yyyy, h:mm a').format(DateTime.parse(orders![index].orderLine.order_date))}",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Row(children: [
                                                        Text(
                                                          'Quantité: ',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                        Text(
                                                          '${orders?[index].orderLine.product_uom_qty?.toInt().toString()}',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      ])),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10),
                                                        margin: EdgeInsets.only(
                                                            top: 5, bottom: 5),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .blueGrey
                                                                .withOpacity(
                                                                    0.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Text(
                                                          "${orders?[index].customer.name}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blueGrey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10),
                                                        margin: EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .blueGrey
                                                                .withOpacity(
                                                                    0.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Text(
                                                          "${orders?[index].customer.phone}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blueGrey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "Adresse: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                "${orders?[index].adresse}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "${orders?[index].city}, ${orders?[index].region} ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        width: 90,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: getOrderStateColor(
                                                                  orders?[index]
                                                                      .orderLine
                                                                      .state)
                                                              .withOpacity(0.3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Text(
                                                          "${orders?[index].orderLine.state}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: getOrderStateColor(
                                                                orders?[index]
                                                                    .orderLine
                                                                    .state),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      orders?[index].orderLine.state!="En attente"? ElevatedButton(

                                                        onPressed:()async{
                                                          await _createAndSavePdf(orders![index],product);
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              backgroundColor: Colors.green,
                                                              content: Text('Votre facture a été téléchargée avec succès'),
                                                              duration: Duration(seconds: 4),
                                                            ),
                                                          );

                                                          },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Icon(Icons.download_sharp,color: Colors.white,),
                                                            Text('Invoice',style: TextStyle(color: Colors.white),),
                                                          ],
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:Colors.blue.shade400,
                                                        ),
                                                      ):Center()

                                                    ],


                                                  ),
                                                  SizedBox(height: 5,),
                                                  getStateButton(orders?[index].orderLine.state)!=''?Container(
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                        onPressed: () async{
                                                          bool success=await OrderController.updateOrderState(orders![index].orderLine.order_line_id,orders?[index].orderLine.state=="En attente"?'sent':'sale');
                                                          sendEmail(orders![index].customer.email,orders?[index].orderLine.state=="En attente"?'Confirmé':'Livré',orders![index],product.name);
                                                          setState(() {
                                                            if(selectedOrdersState==''){
                                                              fetchOrders();
                                                            }
                                                            else{
                                                              fetchOrdersbyState(selectedOrdersState);
                                                            }
                                                          });



                                                        },
                                                        child: Text(
                                                            getStateButton(orders?[index].orderLine.state)
                                                        )

                                                    ),
                                                  )


                                                      :Center(),





                                                ],





                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ]));
  }




}
