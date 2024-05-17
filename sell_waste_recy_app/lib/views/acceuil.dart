import 'package:flutter/material.dart';
import 'package:sell_waste_recy_app/controllers/product_controller.dart';
import 'package:sell_waste_recy_app/models/product.dart';
import '../controllers/category_controller.dart';
import '../controllers/auth.dart';
import 'menu.dart';
import '../models/category.dart';
import 'package:google_fonts/google_fonts.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  List<Category> categoriesList = [];
  List<Product> productList = [];
  Category? selectedCategory;
  String textFieldValue = '';
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchCategories() async {
    final categories = await CategoryController.getCategories();
    setState(() {
      categoriesList = categories;
    });
  }

  Future<void> fetchProducts() async {
    final products = await ProductController.getProducts();
    setState(() {
      productList = products;
    });
  }

  Future<void> fetchProductsByCategory() async {
    final products =
    await ProductController.getProductsByCategory(selectedCategory?.id);
    setState(() {
      productList = products;
    });
  }
  Future<void> fetchSearchedProducts() async {
    final products =
    await ProductController.getSearchedProducts(textFieldValue);
    setState(() {
      productList = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          margin: EdgeInsets.only(left: 8, top: 20),
          child: Text(
            'Découvrir',
            style: TextStyle(
              fontSize: 25,
              fontFamily: "Shippori Mincho",
              color: Colors.black54,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: Menu(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20, top: 15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
          // Other widgets before the GridView.builder
          Container(
          margin: const EdgeInsets.only(right: 20),
          child: Form(
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: 'Recherche',
                    suffixIcon: const Icon(
                      Icons.search,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(7)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.green, width: 1.5))
                ),
              onEditingComplete: () {
                _focusNode.unfocus();
                  fetchSearchedProducts();
                  selectedCategory = null;

          },
              onChanged: (value){
                  setState(() {
                    textFieldValue=value;
                  });
              },
          ),

        ),
      ),
      SizedBox(
        height: 16,
      ),
      Container(
        height: 180,
        width: 350,
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.green,
        ),
        child: Row(
          children: [
            Container(
              width: 154,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Découvrez notre sélection',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      '% Jusqu\'à 50%',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    width: 190,
                    height: 180,
                    child: Image.asset("assets/acceuilPic.png"))
              ],
            )
          ],
        ),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 42,
              margin: EdgeInsets.only(top: 20, right: 10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = null;
                    fetchProducts();
                    textFieldValue='';
                    _controller.text='';

                  });
                },
                child: Text(
                  'Tout',
                  style: TextStyle(
                    color: selectedCategory == null
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(26)),
                    side: BorderSide(
                        color: selectedCategory == null
                            ? Colors.green
                            : Colors.black,
                        width: 1.5),
                  ),
                  backgroundColor: selectedCategory == null
                      ? Colors.green
                      : Colors.white,
                ),
              ),
            ),
            ...categoriesList.map((category) {
              return Container(
                  width: 129,
                  height: 42,
                  margin: const EdgeInsets.only(top: 20, right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = category;
                        fetchProductsByCategory();
                        textFieldValue='';
                        _controller.text='';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(26)),
                          side: BorderSide(
                              color: selectedCategory == category
                                  ? Colors.green
                                  : Colors.black,
                              width: 1.5)),
                      backgroundColor: selectedCategory == category
                          ? Colors.green
                          : Colors.white,
                    ),
                    child: Text(
                      category.name,
                      style: TextStyle(
                        color: selectedCategory == category
                            ? Colors.white
                            : Colors.black,
                        fontFamily: 'Noto Sans JP',
                      ),
                    ),
                  ));
            }),
          ],
        ),
      ),

      Container(
        margin: const EdgeInsets.only(top: 5, right: 10),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // number of items in each row
            mainAxisSpacing: 0.0, // spacing between rows
            crossAxisSpacing: 0, // spacing between columns
            childAspectRatio: 2 / 2.73,
          ),
          itemCount: productList.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25)),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Image.network(
                        productList[index].image,
                        headers: {
                          'Cookie':
                          'session_id=${AuthController.sessionID}'
                        },
                        height: 167,
                      ),
                    ),
                  ),
                  Text(
                    productList[index].name,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${productList[index].list_price} MAD',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
      ],
    ),)
    ,
    )
    ,
    );
  }
}
