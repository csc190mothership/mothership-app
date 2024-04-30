import 'package:flutter/material.dart';
import 'package:mothership/screens/cart.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class Product {
  final String name;
  final String imageURL;
  final double price;
  int quantity = 1;

  Product(
      {required this.name,
      required this.imageURL,
      required this.price,
      required this.quantity});

  // Convert Product instance to JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageURL': imageURL,
    };
  }

  int? incrementQuantity() {
    if (quantity != null) {
      quantity =
          quantity! + 1; // Add a null check (!) before accessing quantity
      return quantity;
    } else {
      return null; // Return null if quantity is already null
    }
  }

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
      quantity: 0,
      price: price,
    );
  }

  factory Product.fromAnotherJson(Map<String, dynamic> json) {
    // Your different JSON parsing logic goes here
    // This factory method can be tailored for a different feature or use case
    return Product(
      name: json['name'] ?? 'No name', // Assign default value if name is null
      price: json['price'] ?? 0.0, // Assign default value if price is null
      imageURL: json['imageURL'], // Assign default value if imageURL is null
      quantity:
          json['quantity'] ?? 0, // Assign default value if quantity is null
    );
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
          Center(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: _item.imageURL,
              width: 300,
            ),
          )),
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
