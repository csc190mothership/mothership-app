import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Product {
  final String name;
  final String imageURL;
  final double price;

  Product({required this.name, required this.imageURL, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    String imageURL = "";

    if (json['images'] != null && json['images'].isNotEmpty) {
      final Map<String, dynamic>? frontImage = json['images'].firstWhere(
        (image) => image['perspective'] == 'front' && image['featured'] == true,
        orElse: () => null,
      );
      if (frontImage != null) {
        final Map<String, dynamic>? largeImage = frontImage['sizes'].firstWhere(
          (size) => size['size'] == 'large',
          orElse: () => null,
        );
        // If a large image size is found, update imageURL.
        if (largeImage != null) {
          imageURL = largeImage['url'];
        }
      }
    }

    double price = 0.0;
    if (json['items'] != null && json['items'].isNotEmpty) {
      price = json['items'][0]['price']['regular'] ?? 0.0;
    }
    return Product(
        name: json['description'] ?? 'No name',
        imageURL: imageURL,
        price: price);
  }
}

class ShopItem extends StatefulWidget {
  ShopItem({super.key, required this.item});

  final Product item;
  @override
  _ShopItemState createState() => _ShopItemState(item);
  //Items can now be passed to a shop item page
}

class _ShopItemState extends State<ShopItem> {
  late Product _item;
  _ShopItemState(Product item) {
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
            image: _item.imageURL,
          ),
          Text("\$" + (_item.price).toString()),
        ],
      ),
    );
  }
}
