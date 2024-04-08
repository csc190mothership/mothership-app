import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';



class Item {
  final String name;
  final String description;
  final String imgPath;
  final double price;
  const Item(this.name, this.description, this.imgPath, this.price);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imgPath': imgPath,
      'price': price,
    };
  }
}


class ShopItem extends StatefulWidget {
  
  ShopItem({super.key, required this.item});
  
  final Item item;
  @override
  _ShopItemState createState() => _ShopItemState(item);
  //Items can now be passed to a shop item page
}

class _ShopItemState extends State<ShopItem> {

  late Item _item;
  _ShopItemState(Item item) {
    _item = item;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_item.name), //add item data to push on shopitem
      ),
      body: Column(
        children: [
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: _item.imgPath,
          ),
          Text(_item.description),
          Text("\$" + (_item.price).toString()),
        ],
      ),
    );
  }
}