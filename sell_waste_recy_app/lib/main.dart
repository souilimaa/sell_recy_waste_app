import 'package:flutter/material.dart';
import 'addProductNext.dart';
import 'home.dart';
import 'login.dart';
import 'signup.dart';
import 'profile.dart';
import 'auth.dart';
import 'editProfile.dart';
import 'addProduct.dart';
void main() async {

  await AuthController.authenticate();
  print('Authentication successful. User ID:${AuthController.sessionID}');

  runApp(MaterialApp(
    title: 'home',
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/login': (context) => Login(),
      '/signup': (context) => Signup(),
      '/profile':(context)=>Profile(),
      '/editProfile':(context)=>EditProfile(),
      '/addProduct':(context)=>AddProduct(),
      '/addProductNext':(context)=>AddProductNext()
    },
  ));
}
