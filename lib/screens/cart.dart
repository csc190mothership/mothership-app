import 'package:flutter/material.dart';
import 'package:mothership/utilities/product.dart';
import 'package:provider/provider.dart';




//cart data saved as long as app is open via this CartModel which is launched in main
class CartModel with ChangeNotifier {
  List<Product> cartItems = [];

  void addItemToCart(Product item) {
    cartItems.add(item);
    notifyListeners();
  }

  void removeItemFromCart(int index) {
    cartItems.removeAt(index);
    notifyListeners();
  }

  double calculateTotalPrice(List<Product> cartItems) {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += item.price;
    }
    totalPrice = double.parse(totalPrice.toStringAsFixed(2));
    return totalPrice;
  }
}


class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          
          var totalPrice = cart.calculateTotalPrice(cart.cartItems).toString();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: cart.cartItems.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      return cartItem(index, cart);
                    },
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).primaryColor,
                child:
                  Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$" + totalPrice),
                      
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement the payment process or checkout
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Pay Now',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              
            ],
          );
        },
      ),
    );
  }


  Widget cartItem(int index, CartModel cart) {
    return Column(
      children:[ListTile(
        leading: Image.network(
          cart.cartItems[index].imageURL,
          height: 36,
        ),
        title: Text(
          cart.cartItems[index].name, 
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          cart.cartItems[index].price.toString(),
          style: const TextStyle(fontSize: 16),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            cart.removeItemFromCart(index);
          },
        ), 
      ),
      Divider(),
    ]
    );


  }
}
