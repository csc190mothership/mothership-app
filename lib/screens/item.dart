import 'package:flutter/material.dart';

class ShopItem extends StatefulWidget {
  ShopItem({super.key});
  @override
  _ShopItemState createState() => _ShopItemState();
}

class _ShopItemState extends State<ShopItem> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("item name"), //add item data to push on shopitem
      ),
    );
  }
}