import 'package:flutter/material.dart';
import 'search.dart';
import 'package:page_transition/page_transition.dart';

class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.fade, child:Search())
                );
              })
        ],
      ),
      body: Container(
        //TODO: SHOP UI
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO: route to cart
        },
        child: const Icon(Icons.shopping_cart),
      )
    );
  }
  
}


