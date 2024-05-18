import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';

class ProductDetails extends StatefulWidget {
  final int id;
  ProductDetails({required this.id});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Product? myProduct;

  @override
  void initState() {
    super.initState();
    int id = widget.id;
    fetchProduct(id);
  }


  Future<void> fetchProduct(int id) async {
    final product = await ProductController.getProductById(id);
    setState(() {
      myProduct = product;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 0.1)),
            color: Colors.white,

          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${myProduct?.list_price} MAD",
                style: TextStyle(
                  fontSize: 21,

                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Ajouter au Panier',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.3,
                  ),


                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(200,56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: myProduct == null
            ? Center(child: CircularProgressIndicator())
            :  SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(left: 15,right: 15,bottom: 15),
              color: Colors.grey[50],
              child: Image.network(
                myProduct!.image,
                headers: {'Cookie': 'session_id=${AuthController.sessionID}'},
                height: 350,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),

                ),
              ),
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      myProduct!.name,
                      style: GoogleFonts.notoSansDisplay(
                        textStyle:TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      myProduct!.description,
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
    );

}}