import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sell_waste_recy_app/controllers/order_controller.dart';
import 'package:sell_waste_recy_app/controllers/user_controller.dart';
import 'package:sell_waste_recy_app/models/order_line.dart';
import 'package:sell_waste_recy_app/views/my_orders.dart';
import 'package:sell_waste_recy_app/views/panier.dart';
import '../models/cart.dart';
import '../models/city.dart';
import '../models/order.dart';
import '../models/payment.dart';
import '../models/region.dart';
import 'acceuil.dart';

class Paiment extends StatefulWidget {
  final String userName;
  final Region province;
  final City city;
  final String adresse;
  double total;

  Paiment(this.userName, this.province, this.city, this.adresse, this.total,
      {super.key});

  @override
  State<Paiment> createState() => _PaimentState();
}

class _PaimentState extends State<Paiment> {
  List<Map<String, dynamic>> items = [];
  double? total;


  @override
  void initState() {
    super.initState();
    total=widget.total*0.10;

    for (Cart cartItem in Panier.panierList) {

      items.add({
        "name": cartItem.product.name,
        "quantity": cartItem.quantity,
        "price": (cartItem.product.list_price * 0.10).toStringAsFixed(2),
        "currency": "USD"
      });
    }
  }

  double getTotalAmount() {
    double total = 0;
    for (Cart cart in Panier.panierList) {
      total += cart.product.list_price * cart.quantity;
    }
    return total * 0.10;
  }

  void navigateToAcceuil() {
    Navigator.popUntil(context, ModalRoute.withName('/acceuil'));
    Navigator.pushNamed(context, '/acceuil');

  }

  int getNumberArticles() {
    int total = 0;
    for (Cart cart in Panier.panierList) {
      total += cart.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.total);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Paiement',
          style: GoogleFonts.assistant(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Adresse de Livraison',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.userName),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            'Changer',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: const ContinuousRectangleBorder(
                                  side: BorderSide.none)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(widget.adresse),
                    Text('${widget.city.name}, ${widget.province.name}'),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Articles (${getNumberArticles()})',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${(getTotalAmount() * 10).toStringAsFixed(2)} MAD',
                          style: TextStyle(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Prix de livraison',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '100.0 MAD',
                            style: TextStyle(),
                          )
                        ]),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 0.3, color: Colors.grey),
                        ),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Prix Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${(getTotalAmount() * 10 + 100).toStringAsFixed(2)} MAD',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () async {
                  double calculatedTotal = widget.total * 0.10;
                  String formattedTotal = calculatedTotal.toStringAsFixed(2);
                  double shipping= 100*0.10;
                  print(calculatedTotal);
                  print(formattedTotal);
                  print(getTotalAmount().toStringAsFixed(2));
                  print(60.80+100*0.10);


                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => PaypalCheckout(
                      sandboxMode: true,
                      clientId:
                          "AW2O7mSy5YRJ1A5_sL8ua5eEhhnObDzpBrVuViTTPet0-PAQfySwsXxOc574FzvVq7BpBvAk11vCKUKe",
                      secretKey:
                          "EMBx8gKvZMArktEFH2XurosDYwQN1MNvLKK17jraEMk8klei_tdBrt26XqynKAu3mO8zQo20fhrGzlrX",
                      returnURL: "success.snippetcoder.com",
                      cancelURL: "cancel.snippetcoder.com",
                      transactions: [
                        {
                          "amount": {
                            "total": formattedTotal,
                            "currency": "USD",
                            "details": {
                              "subtotal": getTotalAmount().toStringAsFixed(2),
                              "shipping": shipping.toStringAsFixed(2),
                              "shipping_discount": 0
                            }
                          },
                          "description": "The payment transaction description.",
                          // "payment_options": {
                          //   "allowed_payment_method":
                          //       "INSTANT_FUNDING_SOURCE"
                          // },
                          "item_list": {"items": items}

                          // shipping address is not required though
                          //   "shipping_address": {
                          //     "recipient_name": "Raman Singh",
                          //     "line1": "Delhi",
                          //     "line2": "",
                          //     "city": "Delhi",
                          //     "country_code": "IN",
                          //     "postal_code": "11001",
                          //     "phone": "+00000000",
                          //     "state": "Texas"
                          //  },
                        }
                      ],
                      note: "Contact us for any questions on your order.",
                      onSuccess: (Map params) async {
                        Map<String, dynamic> data=params['data'];
                        var payid=data['id'];
                        Map<String, dynamic> payer=data['payer'];
                        var paymentMethod=payer['payment_method'];
                        var status=payer['status'];
                        Map<String, dynamic> payer_info=payer['payer_info'];
                        var email=payer_info['email'];
                        var name='${payer_info['first_name']} ${payer_info['last_name']}';
                        var payer_id=payer_info['payer_id'];
                        Map<String, dynamic> shipping_address=payer_info['shipping_address'];
                        var city=shipping_address['city'];
                        List <dynamic> transaction=data['transactions'];
                        Map<String, dynamic> transactions = transaction[0];
                        Map<String, dynamic> amount = transactions['amount'];
                        var total = amount['total'];
                        var currency = amount['currency'];
                        List<int> sellers=[];
                        List<OrderLine> orderLines=[];
                        for(Cart panier in Panier.panierList){
                          orderLines.add(
                            OrderLine(panier.product.id,UserController.userId,'draft',panier.product.list_price*panier.quantity,panier.product.list_price,panier.quantity,panier.product.seller_id)
                          );
                          sellers.add(panier.product.seller_id);
                        }

                       Payment p=Payment(payid,payer_id,currency,city,email,UserController.userId,total,name,paymentMethod,status);
                        DateTime now = DateTime.now();
                        String formattedDateTime = now.toIso8601String();
                        Order o=Order(widget.total,widget.city.id,formattedDateTime,UserController.userId,widget.province.id,widget.adresse);
                       bool newOrder = await OrderController.addOrder(p, o, orderLines);







                        Panier.panierList = [];
                        print("onSuccess: $params");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Paiement réussi!'),
                            duration: Duration(seconds: 4),
                          ),
                        );
                        navigateToAcceuil();
                      },
                      onError: (error) {
                        print("onError: $error");
                        Navigator.pop(context);
                      },
                      onCancel: () {
                        print('cancelled:');
                      },
                    ),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  minimumSize: Size(200, 45),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.paypal_sharp,
                      color: CupertinoColors.activeBlue,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Payer avec ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Pay',
                      style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      'Pal',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
