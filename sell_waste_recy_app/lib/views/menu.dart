import 'package:flutter/material.dart';
import 'package:sell_waste_recy_app/views/panier.dart';

import '../models/cart.dart';
import '../models/category.dart';

class Menu extends StatefulWidget {
  final VoidCallback? onNavigateBack;
  final Category? selectedCategory;

  Menu({Key? key, this.onNavigateBack, this.selectedCategory})
      : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  int getNumberProductInCart() {
    int total = 0;
    for (Cart cart in Panier.panierList) {
      total += cart.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      onTap: (value) {
        if (value == 0) {
          Navigator.pushNamed(context, '/acceuil');
        }
        else if (value == 1) {
          Navigator.pushNamed(context, '/panier').then((value) {
            setState(() {

            });
            widget.onNavigateBack?.call();

          });

        }
        else {
          Navigator.pushNamed(context, '/profile').then((value) {
            setState(() {

            });
            widget.onNavigateBack?.call();


          });

        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Acceuil',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              Icon(Icons.shopping_cart),
              Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    getNumberProductInCart().toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          label: 'Panier',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Paramètres',
        ),
      ],


    );
  }
}
