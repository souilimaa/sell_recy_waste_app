import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(child:Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(25, 10, 10, 5),
            child: Text(
              'Bienvenu !',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 10, 10),
            child: Text(
              ' Connectez-vous pour continuer',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 300,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Entrer votre email",
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
              ),
            ),
          ),
          Container(
            width: 300,
            margin: EdgeInsets.fromLTRB(20, 15, 20, 2),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Entrer votre mot de passe",
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
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0, 5, 20, 5),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Mot de passe oublié?',
                style: TextStyle(color: Colors.green[600]),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: 300,
            height: 45,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'LOGIN',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
              ),
            ),
          ),
          SizedBox(
            height: 50,
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
          SizedBox(height: 30),
          Text(
            'Réseaux Sociaux Login',
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
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Vous n\'avez pas de compte ?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    'Créer un compte',
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
      )
    );
  }
}
