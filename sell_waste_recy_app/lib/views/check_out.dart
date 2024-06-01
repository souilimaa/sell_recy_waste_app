import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sell_waste_recy_app/controllers/region_controller.dart';
import 'package:sell_waste_recy_app/models/city.dart';
import 'package:sell_waste_recy_app/models/region.dart';
import 'package:sell_waste_recy_app/views/panier.dart';
import 'package:sell_waste_recy_app/views/payment.dart';

import '../controllers/city_controller.dart';
import '../controllers/user_controller.dart';
import '../models/cart.dart';
import '../models/user.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  Region? _selectedRegion;
  City? _selectedCity;
  List<Region> listRegion = [];
  List<City> listCities = [];
  double shippingPrice =100;
  final _formKey = GlobalKey<FormState>();
  String? shippingAddress;
  double? TotalAmount;
  User? u;
  Future<void> getUser() async {
    User user = await UserController.getUserById(UserController.userId);
    setState(() {
      u=user;
    });

  }

  Future<void> fetchRegions() async {
    final regions = await RegionController.getRegions();
    setState(() {
      listRegion = regions;
      if (listRegion.isNotEmpty) {
        _selectedRegion = listRegion[0];
        fetchCitiesByRegion(_selectedRegion!.id);
      }
    });
  }

  Future<void> fetchCitiesByRegion(int regionId) async {
    final cities = await CityController.getCitiesByRegion(regionId);
    setState(() {
      listCities = cities;
      _selectedCity = listCities.isNotEmpty ? listCities[0] : null;
    });
  }

  int getNumberArticles() {
    int total = 0;
    for (Cart cart in Panier.panierList) {
      total += cart.quantity;
    }
    return total;
  }

  double getTotalAmount() {
    var total = 0.0;
    for (Cart cart in Panier.panierList) {
      total += cart.product.list_price * cart.quantity;
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    getUser();
    fetchRegions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Check Out',
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
      body:  SingleChildScrollView(child:Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Province :',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: FormField<Region>(
                        builder: (FormFieldState<Region> state) {
                          return DropdownButton<Region>(
                            value: _selectedRegion,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.green,
                            ),
                            underline: Container(
                              height: 1,
                              color: Colors.green[100],
                            ),
                            items: listRegion.map((Region item) {
                              return DropdownMenuItem<Region>(
                                value: item,
                                child: Text(item.name),
                              );
                            }).toList(),
                            onChanged: (Region? newValue) {
                              setState(() {
                                _selectedRegion = newValue;
                                fetchCitiesByRegion(_selectedRegion!.id);
                              });
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Ville :',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: FormField<City>(
                        builder: (FormFieldState<City> state) {
                          return DropdownButton<City>(
                            value: _selectedCity,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.green,
                            ),
                            underline: Container(
                              height: 1,
                              color: Colors.green[100],
                            ),
                            items: listCities.map((City item) {
                              return DropdownMenuItem<City>(
                                value: item,
                                child: Text(item.name),
                              );
                            }).toList(),
                            onChanged: (City? newValue) {
                              setState(() {
                                _selectedCity = newValue;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Adresse de livraison :',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: TextFormField(
                        maxLines: 2,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Entrer votre Adresse de livraison',
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
                              borderRadius: BorderRadius.circular(7)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20)),
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
                          }
                          return null;
                        },
                        onSaved: (value) {
                          shippingAddress=value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Articles (${getNumberArticles()})',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${getTotalAmount().toStringAsFixed(2)} MAD',
                                style: TextStyle(),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Prix de livraison',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '${shippingPrice} MAD',
                                  style: TextStyle(
                                  ),
                                )
                              ]),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(width: 0.3, color: Colors.grey),
                              ),                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Prix Total',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    '${getTotalAmount()+shippingPrice} MAD',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red
                                    ),
                                  )
                                ]),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height:45,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          TotalAmount=getTotalAmount()+shippingPrice;
                          print(u?.name);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>Paiment(u?.name,_selectedRegion!,_selectedCity!,shippingAddress!,TotalAmount!)
                            ),

                          );
                        }

                      },
                      child: Text(
                        'Continuer',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: Size(200, 56),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      )),
    );
  }
}
