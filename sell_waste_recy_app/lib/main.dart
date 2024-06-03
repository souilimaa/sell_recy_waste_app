import 'package:flutter/material.dart';
import 'package:sell_waste_recy_app/controllers/user_controller.dart';
import 'package:sell_waste_recy_app/models/user.dart';
import 'package:sell_waste_recy_app/views/add_product.dart';
import 'package:sell_waste_recy_app/views/add_product_next.dart';
import 'package:sell_waste_recy_app/controllers/auth.dart';
import 'package:sell_waste_recy_app/views/devenir_vendeur.dart';
import 'package:sell_waste_recy_app/views/edit_profile.dart';
import 'package:sell_waste_recy_app/views/home.dart';
import 'package:sell_waste_recy_app/views/log_in.dart';
import 'package:sell_waste_recy_app/views/my_orders.dart';
import 'package:sell_waste_recy_app/views/panier.dart';
import 'package:sell_waste_recy_app/views/profile.dart';
import 'package:sell_waste_recy_app/views/revenu.dart';
import 'package:sell_waste_recy_app/views/seller_dash.dart';
import 'package:sell_waste_recy_app/views/seller_orders.dart';
import 'package:sell_waste_recy_app/views/seller_products.dart';
import 'package:sell_waste_recy_app/views/sign_up.dart';
import 'views/acceuil.dart';

import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthController.authenticate();
  print('Authentication successful. User ID:${AuthController.sessionID}');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int userId = prefs.getInt('userId') ?? 0;
  print(userId);
  String i='/';
  if(userId!=0){
    UserController.userId=userId;
    i='/acceuil';
  }


  runApp(MaterialApp(
    title: 'home',
    initialRoute: i,
    routes: {
      '/': (context) => Home(),
      '/login': (context) => Login(),
      '/signup': (context) => Signup(),
      '/profile':(context)=>Profile(),
      '/editProfile':(context)=>EditProfile(),
      '/addProduct':(context)=>AddProduct(),
      '/addProductNext':(context)=>AddProductNext(),
      '/sellerDash':(context)=>SellerDash(),
      '/acceuil':(context)=>Acceuil(),
      '/panier':(context)=>Panier(),
      '/mesCommands':(context)=>MyOrders(),
      '/sellerOrders':(context)=>SellerOrders(),
      '/sellerProducts':(context)=>SellerProducts(),
      '/revenue':(context)=>Revenue(),
      '/sellProducts':(context)=>SellerProducts(),
      '/beSeller':(context)=>DevenirVendeur()



    },
  ));
}
