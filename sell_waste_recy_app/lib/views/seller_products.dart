import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sell_waste_recy_app/controllers/category_controller.dart';
import 'package:sell_waste_recy_app/controllers/product_controller.dart';
import '../controllers/auth.dart';
import '../models/product.dart';

class SellerProducts extends StatefulWidget {
  const SellerProducts({super.key});

  @override
  State<SellerProducts> createState() => _SellerProductsState();
}

class _SellerProductsState extends State<SellerProducts> {
  late List<dynamic> products;
  bool isLoading = true;
  var qteController = TextEditingController();
  var qty;
  var prix;
  List<GlobalKey<FormState>> _formKeys = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      List<dynamic> ps = await ProductController.getProductsBySeller();
      setState(() {
        products = ps;
        _formKeys = List.generate(ps.length, (index) => GlobalKey<FormState>());
      });
    } catch (e) {
      setState(() {
        products = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Produits',
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
      body: Column(children: [
        isLoading
            ? Center(child: CircularProgressIndicator())
            : (products == [])
                ? Expanded(child: Center(child: Text('No orders found')))
                : Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<Product>(
                          future:
                              ProductController.getProductById(products[index]),
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
                                    margin: EdgeInsets.only(bottom: 5, top: 20),
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
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                FutureBuilder<String>(
                                                  future: CategoryController
                                                      .getCategoryNameById(
                                                          product.categ_id),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return CircularProgressIndicator();
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Error: ${snapshot.error}');
                                                    } else {
                                                      return RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'Catégorie: ',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  '${snapshot.data}',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Form(
                                                  key: _formKeys[index],
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text('Quantité:',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            width: 100,
                                                            height: 35,
                                                            child:
                                                                TextFormField(
                                                              initialValue: product
                                                                  .qty_available
                                                                  .toInt()
                                                                  .toString(),
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        vertical:
                                                                            2.0,
                                                                        horizontal:
                                                                            10),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .green
                                                                        .shade100,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.green,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
                                                                focusedErrorBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.red,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
                                                                errorBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .red
                                                                        .shade100,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  final snackBar =
                                                                      SnackBar(
                                                                    content:
                                                                        Text(
                                                                      'La valeur de la quantité est invalide',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  );
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                  setState(
                                                                      () {});
                                                                  return null;
                                                                }
                                                                return null;
                                                              },
                                                              onSaved:
                                                                  (value) {
                                                                qty=value;
                                                                  },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 26),
                                                            child: Text(
                                                                'Prix :',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey)),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            width: 100,
                                                            height: 35,
                                                            child:
                                                                TextFormField(
                                                              initialValue: product
                                                                  .list_price
                                                                  .toString(),
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        vertical:
                                                                            8.0,
                                                                        horizontal:
                                                                            10),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .green
                                                                        .shade100,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.green,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
                                                                focusedErrorBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.red,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
                                                                errorBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .red
                                                                        .shade100,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  final snackBar =
                                                                      SnackBar(
                                                                    content:
                                                                        Text(
                                                                      'La valeur de Prix est invalide',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  );
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                  setState(
                                                                      () {});
                                                                  return null;
                                                                }
                                                                return null;
                                                              },
                                                              onSaved:
                                                                  (value) {
                                                                prix=value;
                                                                  },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Container(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                      onPressed: () async {
                                                        if (_formKeys[index]
                                                            .currentState!
                                                            .validate()) {
                                                          _formKeys[index]
                                                              .currentState!
                                                              .save();
                                                          await ProductController.updateProduct(products[index], qty, prix);
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                'Produit mis à jour',
                                                                style: TextStyle(color: Colors.white),
                                                              ),
                                                              backgroundColor: Colors.green,
                                                            ),
                                                          );

                                                          setState(() {

                                                          });

                                                        }
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.green.shade600,
                                                      ),
                                                      child: Text('Modifier',
                                                      style: TextStyle(color: Colors.white),
                                                      )),
                                                )
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
      ]),
    );
  }
}
