import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sell_waste_recy_app/views/panier.dart';
import '../controllers/auth.dart';
import '../controllers/product_controller.dart';
import '../models/cart.dart';
import '../models/product.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductDetails extends StatefulWidget {
  final int id;
  const ProductDetails({super.key, required this.id});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isInCart = false;


  @override
  void initState() {
    super.initState();
    int id = widget.id;
    for (Cart cart in Panier.panierList) {
      if (cart.product.id == id) {
        setState(() {
          isInCart = true;
        });
        break;
      }}
  }
  Cart? getProductFromCart(){
    for (Cart cart in Panier.panierList) {
      if (cart.product.id == widget.id) {
        return cart;
      }
    }
    return null;
  }

  Future<Product> fetchProduct(int id) async {
    final product = await ProductController.getProductById(id);
    return product;
  }
  bool isQuantityAvailable(var qtAvailable,var quantityToAdd){

    return qtAvailable>=quantityToAdd;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBar: FutureBuilder(
          future: fetchProduct(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey, width: 0.1)),
                  color: Colors.white,

                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${snapshot.data?.list_price} MAD",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    isInCart?( Row(
                      children: [
                        IconButton(
                          style:ButtonStyle(
                        shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.green),
                          ),
                        ),
                    ),
                          icon: Icon(Icons.remove,color: Colors.green,),
                          onPressed: () {
                            Cart? c=getProductFromCart();
                            if(c!.quantity==1){
                              Panier.panierList.remove(c);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Le produit a été retiré du panier avec succès'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              setState(() {});
                              setState(() {
                                isInCart=false;
                              });
                            }
                              else if(c.quantity-1>0){
                                c.quantity--;
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('La quantité d\'articles a été mise à jour'),
                            duration: Duration(seconds: 3),
                            ),
                            );
                            setState(() {

                            });
                              }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            getProductFromCart()!.quantity.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                          ),
                        ),
                        IconButton(
                          style:ButtonStyle(
                            shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                          icon: Icon(Icons.add,color: Colors.green,),
                          onPressed:isQuantityAvailable(snapshot.data?.qty_available,(getProductFromCart()!.quantity+1))? () {
                            Cart? c=getProductFromCart();
                            c?.quantity++;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Produit ajouté avec succès'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            setState(() {});
                          }:null,
                        ),
                      ],
                    )):(ElevatedButton(
                      onPressed:snapshot.data?.qty_available > 0 ? () {
                        Cart myElement = Cart(snapshot.data!, 1);
                        Panier.panierList.add(myElement);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Produit ajouté avec succès'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        setState(() {
                            isInCart=true;
                        });

                      }:null,
                      child:Text(
                        'Ajouter au Panier',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),


                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(200,56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    )),
                  ],
                ),
              );
            }
          },
        ),
        body: FutureBuilder(
          future: fetchProduct(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return snapshot.data == null
                  ? Center(child: CircularProgressIndicator())
                  :  SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15,right: 15,bottom: 15),
                        color: Colors.grey[50],
                        child: Image.network(
                          snapshot.data!.image,
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
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      snapshot.data!.name,
                                      style: GoogleFonts.notoSansDisplay(
                                          textStyle:TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          )),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  ElevatedButton(onPressed: (){},
                                      child: Text(
                                        snapshot.data!.qty_available>0?'En Stock':'Indisponible',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          )
                                      ))
                                ],
                              ),
                              Html(
                                data:snapshot.data!.description,
                              )

                            ],
                          ),
                        ),
                      ),
                    ],
                  ));
            }
          },
        ),
    );

}}