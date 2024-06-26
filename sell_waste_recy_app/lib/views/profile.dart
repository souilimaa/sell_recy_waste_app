import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sell_waste_recy_app/views/panier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../controllers/user_controller.dart';
import '../models/user.dart';
import '../controllers/auth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<User> u;

  @override
  void initState() {
    super.initState();
    u = UserController.getUserById(UserController.userId);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      print("hi");
      // Refetch user data whenever the widget is visible
      setState(() {
        u = UserController.getUserById(UserController.userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Profil',
            style: GoogleFonts.assistant(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Stack(children: [
                Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.green.shade200,
                        width: 2,
                      ),
                    ),
                    child: FutureBuilder<User>(
                      future: u,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          final user = snapshot.data!;
                          if (user.image != "") {
                            return CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(
                                user.image + "?v=${Random().nextInt(1000000)}",
                                headers: {
                                  'Cookie': 'session_id=${AuthController
                                      .sessionID}'
                                },
                              ),
                            );
                          } else {
                            return const CircleAvatar(
                              radius: 70,
                              backgroundImage: AssetImage(
                                  "assets/defaultupp.png"),
                            );
                          }
                        } else if (snapshot.hasError) {
                          print('${snapshot.error}');
                          return Text('${snapshot.error}');
                        }
                        return const CircularProgressIndicator();
                      },
                    )
                ),
              ]),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<User>(
              future: u,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: Colors.black,
                    ),
                  );
                } else if (snapshot.hasError) {
                  print('${snapshot.error}');
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),
            FutureBuilder<User>(
              future: u,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.phone,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  );
                } else if (snapshot.hasError) {
                  print('${snapshot.error}');
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),
            SizedBox(
              height: 60,
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft:
                        Radius.circular(50), // Adjust the radius as needed
                      ),
                    ),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/editProfile');
                          },
                          style: ButtonStyle(
                            alignment: Alignment.bottomRight,
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 28,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 14),
                                  Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 28,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/mesCommands');
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.list_alt,
                                    size: 28,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 14),
                                  Text(
                                    'Mes Commandes',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 28,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        FutureBuilder<User>(
                          future: u,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasData) {
                              if (snapshot.data?.paypal_account != false) {
                                return TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context,
                                        '/sellerDash');
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                        Colors.transparent),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.settings,
                                            size: 28,
                                            color: Colors.green,
                                          ),
                                          SizedBox(width: 14),
                                          Text(
                                            'Gestion des ventes',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        size: 28,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context,
                                        '/beSeller');
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                        Colors.transparent),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.settings,
                                            size: 28,
                                            color: Colors.green,
                                          ),
                                          SizedBox(width: 14),
                                          Text(
                                            'Devenir vendeur',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        size: 28,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } else if (snapshot.hasError) {
                              print('${snapshot.error}');
                              return Text('${snapshot.error}');
                            }
                            return const CircularProgressIndicator();
                          },
                        ),

                        SizedBox(height: 15),
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.notifications,
                                    size: 28,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 14),
                                  Text(
                                    'Notifications',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 28,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextButton(
                          onPressed: ()async{
                            Panier.panierList=[];
                            UserController.userId=0;
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.remove('userId');
                            Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);

                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                size: 28,
                                color: Colors.red,
                              ),
                              SizedBox(width: 14),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )))
          ],
        ));
  }

}
