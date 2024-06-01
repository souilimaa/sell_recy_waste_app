import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/user_controller.dart';

class DevenirVendeur extends StatefulWidget {
  const DevenirVendeur({super.key});

  @override
  State<DevenirVendeur> createState() => _DevenirVendeurState();
}

class _DevenirVendeurState extends State<DevenirVendeur> {
  final _formKey = GlobalKey<FormState>();
  var paypal_account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          title: Text(
            textAlign: TextAlign.center,
            'Devenir vendeur',
            style: GoogleFonts.assistant(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "Bienvenue sur l\'espace vendeur de l\'application",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
              )),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.recycling,
                    color: Colors.green[600],
                    size: 29,
                  ),
                  SizedBox(width: 2.5),
                  Text('EcoTrade',
                      style: TextStyle(
                          color: Colors.green[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 18)
                  ,textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Center(
                child: Form(
                    key: _formKey,
                    child: Container(
                        color: Colors.white,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Compte Paypal :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Entrer votre compte paypal',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green.shade100,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(20)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(20)),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red.shade100,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ce champs est obligatoire';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    paypal_account = value;
                                  },
                                ),
                              ),
                              SizedBox(height: 30,),
                              Container(
                                height: 48,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        bool success =
                                            await UserController.devenirVendeur(paypal_account);

                                        if (success) {
                                          print('User est vendeur successfully');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text('Félicitations ! Vous êtes maintenant un vendeur sur l\'application EcoTrade.!'),
                                              duration: Duration(seconds: 4),
                                            ),
                                          );
                                          Navigator.pushNamed(
                                              context, '/profile');
                                        } else {
                                          print('Failed to devenir user');
                                        }
                                      }
                                    },
                                    child: Text(
                                        'Devenir vendeur',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade600,
                                    )),
                              )
                            ]))))
          ]),
        ));
  }
}
