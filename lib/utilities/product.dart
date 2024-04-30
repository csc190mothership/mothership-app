import 'package:flutter/material.dart';
import 'package:mothership/screens/cart.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class Product {
  final String name;
  final String imageURL;
  final double price;
  int quantity = 0;

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
      price = json['items'][0]['price']['regular'] * 1.0 ?? 0.0;
    }
    return Product(
        name: json['description'] ?? 'No name',
        imageURL: imageURL,
        price: price);
  }
  int incrementQuantity() {
    quantity++;
    return quantity;
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
    CartModel _cartModel = Provider.of<CartModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_item.name), //add item data to push on shopitem
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(child:
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: _item.imageURL,
                width: 300,
              ),
            )
          ),
          SizedBox(height: 20),
          Text("\$" + (_item.price).toString()),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (_cartModel.isItemInCart(widget.item)) {
                  _cartModel.incrementItemQuantity(widget.item);
                } else {
                  _cartModel.addItemToCart(widget.item);
                  _cartModel.incrementItemQuantity(widget.item);
                }
              });
            },
            child: Text("Add to Cart"),
          ),
        ],
      ),
    );
  }
}
