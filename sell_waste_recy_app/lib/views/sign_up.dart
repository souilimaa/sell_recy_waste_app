import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sell_waste_recy_app/controllers/user_controller.dart';

import '../models/user.dart';
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  var nom;
  var email;
  var phone;
  var password;
  var confirmedPassword;
  var serverError="";
  bool isEmail(String input) => EmailValidator.validate(input);

  bool isPhone(String input) {
    RegExp regex = RegExp(r'^(06|05|07)');
    RegExp digitRegex = RegExp(r'^\d+$');
    if (input.length == 10) {
      if (regex.hasMatch(input) && digitRegex.hasMatch(input)) {
        return true;
      }
    }
    return false;
  }

  bool isValidateNom(String input) {
    RegExp alphaRegex = RegExp(r'^[a-zA-Z]+$');
    if (alphaRegex.hasMatch(input)) {
      return true;
    }
    return false;
  }

  bool isConfirmedPassword(String password, String ConfirmedPassword) {
    if (password == ConfirmedPassword) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(25, 10, 10, 5),
                child: Text(
                  'Bienvenu !',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 10, 10),
                child: Text(
                  'Créer un nouveau compte',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                    hintText: "Entrer votre Nom",
                    prefixIcon: Icon(Icons.person),
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
                    } else if (!isValidateNom(value)) {
                      return 'Veuillez entrer valid nom';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    nom = value;
                  },
                ),
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextFormField(
                  //textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                    hintText: "Entrer votre email",
                    prefixIcon: Icon(Icons.mail),
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
                    } else if (!isEmail(value)) {
                      return 'Veuillez entrer valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value;
                  },
                ),
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                    hintText: "Entrer votre Numéro de téléphone",
                    prefixIcon: Icon(Icons.phone),
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
                      return 'Ce champs est requis';
                    } else if (!isPhone(value)) {
                      return 'invalid numero de telephone';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    phone = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green.shade100,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Entrer le Mot de Passe",
                    prefixIcon: Icon(Icons.lock),
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
                      return 'Ce champs est requis';
                    }
                    password = value;
                    return null;
                  },
                  onSaved: (value) {
                    password = value;
                  },
                ),
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                    hintText: "Confirmer votre mot de passe",
                    prefixIcon: Icon(Icons.lock),
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
                      return 'Ce champs est requis';
                    }
                    else if(!isConfirmedPassword(password,value)){
                      return 'Les mot de passes ne correspondent pas';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    confirmedPassword = value;
                  },
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                width: 200,
                height: 45,
                child: ElevatedButton(
                    onPressed: () async{
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        try {
                          User u = User.withoutId(nom, email, phone, password);
                          bool isCreated = await UserController.SignUp(u);
                          if (isCreated) {
                            print('User created successfully');
                            setState(() {
                              serverError = '';
                            });
                          } else {
                            print('Failed to Sign up. Email already exists.');
                            setState(() {
                              serverError ="Failed to Sign up. Email already exists.";
                            });
                          }
                        }catch (e) {
                          print('Failed to create user. Server error occurred.');
                          setState(() {
                            serverError ="Failed to create user. Server error occurred.";
                          });
                        }

                      }
                    },
                    child: Text(
                      'Créer un compte',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                    )),
              ),
              if (serverError!="")
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(
                    serverError,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                          top: BorderSide(color: Colors.grey, width: 1.5),
                          bottom: BorderSide.none,
                        )),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(7, 0, 7, 0),
                        child: Text(
                          'or',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                          top: BorderSide(color: Colors.grey, width: 1.5),
                          bottom: BorderSide.none,
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Réseaux Sociaux Sign up',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Image.asset('assets/logo_google.png'),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.facebook,
                      color: Colors.blue[900],
                      size: 48,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: FaIcon(
                      FontAwesomeIcons.twitter,
                      size: 48,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Vous avez déjà un compte ?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.green[600],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
