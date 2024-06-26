import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/user_controller.dart';
import '../models/user.dart';

class SellerDash extends StatefulWidget {
  const SellerDash({super.key});

  @override
  State<SellerDash> createState() => _SellerDashState();
}

class _SellerDashState extends State<SellerDash> {
  late Future<User> u;

  @override
  void initState() {
    super.initState();
    u = UserController.getUserById(UserController.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Gestion des ventes',
            style: GoogleFonts.assistant(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 0),
              color: Colors.green,
            ),
            height: 90,
            child: Container(
              margin: EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 15),
              child: FutureBuilder<User>(
                future: u,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Bonjour ${snapshot.data!.name}',
                      style: GoogleFonts.jost(
                        textStyle: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    print('${snapshot.error}');
                    return Text('${snapshot.error}');
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 0),
              color: Colors.green,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(60),
                bottomLeft: Radius.circular(20),
              ),
            ),
            height: 60,
            child: Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              height: 5,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Stack(children: [
                    CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.green,
                        child: Container(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3.5,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        )),
                    Positioned(
                        top: 45,
                        left: 44,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                iconSize: 38,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/addProduct');
                                },
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  weight: 55,
                                  Icons.add,
                                  color: Colors.green,
                                ),
                              )),
                        ))
                  ]),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0),
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            height: 75,
            child: Text(
              'Ajouter Votre Produit',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.5,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/sellerProducts');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: 160,
                        padding: EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10.0, left: 10, right: 10),
                              child: FaIcon(
                                FontAwesomeIcons.boxOpen,
                                size: 55,
                                color: Colors.pinkAccent,
                              ),
                            ),
                            Text(
                              'Produits',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/sellerOrders');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: 160,
                        padding: EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10.0, left: 10, right: 10),
                              child: FaIcon(
                                FontAwesomeIcons.clipboardList,
                                size: 55,
                                color: Colors.indigo[300],
                              ),
                            ),
                            Text(
                              'Ventes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      )),
                ]),
          ),
          Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          print('Container clicked!');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: 160,
                          padding: EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10.0, left: 10, right: 10),
                                child: FaIcon(
                                  FontAwesomeIcons.peopleGroup,
                                  size: 55,
                                  color: Colors.lightBlue,
                                ),
                              ),
                              Text(
                                'Clients',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        )),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/revenue');
                        },
                        child: Container(
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10.0, left: 10, right: 10),
                                child: FaIcon(
                                  FontAwesomeIcons.sackDollar,
                                  size: 55,
                                  color: Colors.lightGreen,
                                ),
                              ),
                              Text(
                                'Revenus',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        )),
                  ]))
        ]));
  }
}
