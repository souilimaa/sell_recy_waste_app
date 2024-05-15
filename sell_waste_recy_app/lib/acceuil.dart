import 'package:flutter/material.dart';

import 'controllers/categoryController.dart';
import 'models/category.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  List<Category> categoriesList = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final categories = await CategoryController.getCategories();
    setState(() {
      categoriesList = categories;
    });
  }
  @override
  Widget build(BuildContext context) {
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

      body: Column(
        children: [
        SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categoriesList.length, (index) {
            return Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.all(8.0),
              color: Colors.blue[(index % 9 + 1) * 100],
              child: Center(
                child: Text(
                  'Item $index',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }),
        ),
      ),

        ],
      ),
    );
  }
}
