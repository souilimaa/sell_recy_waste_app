import 'package:flutter/material.dart';
import 'package:sell_waste_recy_app/controllers/productController.dart';
import 'package:sell_waste_recy_app/controllers/userController.dart';

import 'models/product.dart';

class AddProductNext extends StatefulWidget {
  const AddProductNext({super.key});

  @override
  State<AddProductNext> createState() => _AddProductNextState();
}

class _AddProductNextState extends State<AddProductNext> {
  final _formKey = GlobalKey<FormState>();
  var qty_available;
  var seller_id = UserController.userId;
  var list_price;
  String isAdded='';
  bool isValidateNumber(String input) {
    if (input.contains(RegExp(r'[^\d]'))) {
      return false;
    }
    // Convert the input string to an integer
    int number = int.tryParse(input) ?? 0;
    // Check if the number is greater than 0
    return number > 0;
  }

  @override
  Widget build(BuildContext context) {
    Product newProduct = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Ajouter un Produit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Prix du Produit :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText:
                                          'Entrer le prix du produit en DH',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 15),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.green.shade100,
                                        ),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.green,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red.shade100,
                                        ),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Ce champs est obligatoire';
                                      } else if (!isValidateNumber(value)) {
                                        return 'Donnée invalide';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      list_price = value;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'Quantité en stock du Produit :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Entrer la Quantité disponible',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 15),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.green.shade100,
                                        ),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.green,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red.shade100,
                                        ),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Ce champs est obligatoire';
                                      } else if (!isValidateNumber(value)) {
                                        return 'Donnée invalide';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      qty_available = value;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  width: 300,
                                  height: 45,
                                  child: ElevatedButton(
                                      onPressed: () async{
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          Product product = Product.withoutId(
                                              newProduct.name,
                                              newProduct.description,
                                              newProduct.categ_id,
                                              newProduct.image,
                                              qty_available,
                                              seller_id,
                                              list_price);
                                          bool success = await ProductController.AddProduct(product);

                                          if (success) {
                                            print('Product added successfully');
                                            setState(() {
                                              isAdded='';
                                            });
                                          } else {
                                            print('Failed to add product');
                                            setState(() {
                                              isAdded='Failed to add this product';
                                            });

                                          }
                                        }
                                      },
                                      child: Text(
                                        'Ajouter',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade600,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      )),

                                ),
                                Text(
                                  isAdded,
                                  style: TextStyle(
                                    color:Colors.red,
                                  ),
                                )
                              ],
                            )),
                      ),
                    ]))));
  }
}
