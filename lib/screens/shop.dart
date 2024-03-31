import 'package:flutter/material.dart';

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
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search),
              onPressed: () {
                //TODO: Implement search.
              })
        ],
      ),
      body: Container(
        // Add your widget tree here
      ),
    );
  }
}