import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,

          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15,10,10),
            child: Row(
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
                        fontSize: 18)),
              ],
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: Image.asset('assets/HomePic.jpg'),
            ),
            Center(
                child: Text('Bonjour !',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ))),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              'Ensemble, commençons à recycler pour un monde meilleur en vendant vos matériaux recyclables dès aujourd\'hui.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            )),
            SizedBox(
              height: 30,
            ),
            Center(
                child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                'LOGIN',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                minimumSize: Size(300, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
              ),
            )),
            SizedBox(
              height: 10,
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                          color: Colors.green[600],
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(300, 45),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                        side: BorderSide(color: Colors.green.shade600,width: 2),
                      ),
                    ))),
          ],
        ));
  }
}
