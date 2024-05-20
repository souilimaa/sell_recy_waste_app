import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sell_waste_recy_app/controllers/auth.dart';
import 'package:sell_waste_recy_app/controllers/product_controller.dart';
import 'package:sell_waste_recy_app/models/cart.dart';

import '../models/product.dart';

class Panier extends StatefulWidget {
  static List<Cart> panierList = [];

  const Panier({super.key});

  @override
  State<Panier> createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  List<Cart> panier = Panier.panierList;
  @override
  void initState() {
    super.initState();
    updateCartProducts();
  }

  double totalPanier() {
    var total = 0.0;
    for (Cart cart in panier) {
      total += cart.product.list_price * cart.quantity;
    }
    return total;
  }

  Future<void> updateCartProducts() async {
    List<Cart> updatedCart = [];
    for (Cart cart in panier) {
      Product updatedProduct = await ProductController.getProductById(cart.product.id);
      updatedCart.add(Cart(updatedProduct, cart.quantity));
    }
    setState(() {
      panier = updatedCart;
    });
  }
  String checkInStock(double qty_available,quantitytoOrder){
    if(qty_available>0){
      if(qty_available>=quantitytoOrder) {
        return 'Disponible';
      }
      int q=qty_available.toInt();
      return 'En rupture de stock (Il reste ${q} articles)';
    }
  return 'Indisponible';
  }
  @override
  Widget build(BuildContext context) {
    print(panier);
    if (Panier.panierList.length > 0) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Mon Panier',
              style: GoogleFonts.assistant(
                  textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ))),
          centerTitle: true,
          backgroundColor: Colors.green,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 0.1)),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              'Checkout Pour ${totalPanier()} MAD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              minimumSize: Size(200, 56),
            ),
          ),
        ),
        body: Container(
            child: ListView.builder(
          itemCount: panier.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.3, color: Colors.grey),
                ),
              ),
              child: IntrinsicHeight(
                  child: Container(
                margin: EdgeInsets.only(bottom: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[50]),
                        child: Image.network(
                          panier[index].product.image,
                          headers: {
                            'Cookie': 'session_id=${AuthController.sessionID}',
                          },
                          height: 90,
                          width: 90,
                        )),
                    Expanded(
                        child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  panier[index].product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    panier.removeAt(index);
                                    Panier.panierList=panier;
                                  });
                                },
                                icon: Icon(Icons.close),
                              ),
                            ],
                          ),
                         Container(
                           alignment: Alignment.centerLeft,
                           child: Text(
                             checkInStock(panier[index].product.qty_available,panier[index].quantity),
                             style: TextStyle(
                               color: checkInStock(panier[index].product.qty_available,panier[index].quantity)=='Disponible'?Colors.grey:Colors.red,
                             ),
                             textAlign: TextAlign.start,
                           ),
                         ),
                          Flexible(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${panier[index].product.list_price} MAD",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    IconButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            side: BorderSide(
                                                color: Colors
                                                    .grey),
                                          ),
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.remove,
                                      ),
                                      onPressed: () {
                                        if (panier[index].quantity == 1) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  'Le produit a été retiré du panier avec succès'),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                          setState(() {
                                            panier.removeAt(index);
                                            Panier.panierList=panier;
                                          });
                                        }
                                        else
                                        if (panier[index].quantity - 1 > 0) {
                                          panier[index].quantity--;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  'La quantité d\'articles a été mise à jour'),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                          setState(() {
                                            Panier.panierList = panier;
                                          });
                                        }
                                      }

                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        panier[index].quantity.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: BorderSide(
                                                color: Colors
                                                    .green),
                                          ),
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.green,
                                      ),
                                      onPressed:panier[index].product.qty_available>=panier[index].quantity+1?() {

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text('Produit ajouté avec succès'),
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                        setState(() {
                                          panier[index].quantity++;
                                          Panier.panierList=panier;
                                        });
                                      }:null,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
                    )),
                  ],
                ),
              )),
            );
          },
        )),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Mon Panier',
              style: GoogleFonts.assistant(
                  textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ))),
          centerTitle: true,
          backgroundColor: Colors.green,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Votre panier est vide!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Parcourez nos catégories et découvrez nos meilleures offres!',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/acceuil',
                  );
                },
                child: Text(
                  'Commencez vos Achats',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: Size(200, 56),
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}
