

import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'signup.dart';
void main() {
  runApp(
      MaterialApp(
        title: 'home',
        initialRoute: '/',
      routes: {
          '/':(context)=>Home(),
        '/login':(context)=>Login(),
        '/signup':(context)=>Signup(),

      },
      )
  );

}



