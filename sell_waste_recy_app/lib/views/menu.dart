import 'package:flutter/material.dart';
import 'package:sell_waste_recy_app/views/profile.dart';

import 'edit_profile.dart';
import 'log_in.dart';
class Menu extends StatefulWidget {
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    EditProfile(),
    Login(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Navigate to the corresponding screen
          void _home() {
            Navigator.popUntil(context, ModalRoute.withName('/acceuil'));
          }
          switch (index) {
            case 0:
              _home();
              _currentIndex = index;
                break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
              setState(() {
                _currentIndex = index;
              });              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
              setState(() {
                _currentIndex = index;
              });              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Acceuil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,

    );

  }
}
