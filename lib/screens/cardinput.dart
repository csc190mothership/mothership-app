import 'package:flutter/material.dart';
import 'package:mothership/main.dart';
import 'package:mothership/screens/shop.dart';
import 'package:page_transition/page_transition.dart';

class CardInputPage extends StatefulWidget {
  @override
  _CardInputPageState createState() => _CardInputPageState();
}

class _CardInputPageState extends State<CardInputPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Input Page'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
              ),
              keyboardType: TextInputType.number,
              maxLength: 16,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Expiration Date',
                    ),
                    maxLength: 5,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                  ),
                ),
              ],
            ),
            ElevatedButton(onPressed:() {
                          showSnackBar(context, 'Order Complete!');
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: MyHomePage()),
                          );
                        }, child: Text("Complete Order"))
          ],
        ),
      ),
    );
  }
  
  void showSnackBar(BuildContext context, String s) {
    final snackBar = SnackBar(content: Text(s));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
}