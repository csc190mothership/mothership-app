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
      totalPrice += item.price * item.quantity;
    }
    totalPrice = double.parse(totalPrice.toStringAsFixed(2));
    return totalPrice;
  }
  bool isItemInCart(Product item) {
    return cartItems.contains(item);
  }
  void incrementItemQuantity(Product item) {
    int index = cartItems.indexOf(item);
    if (index != -1) {
      cartItems[index].quantity++;
      notifyListeners();
    }
  }
  void decrementItemQuantity(Product item) {
    int index = cartItems.indexOf(item);
    if (index != -1) {
      cartItems[index].quantity--;
      if (cartItems[index].quantity == 0) {
        removeItemFromCart(index);
      }
      notifyListeners();
    }
  }
}


class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          
          var totalPrice = cart.calculateTotalPrice(cart.cartItems).toStringAsFixed(2);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 45, left: 20),
                  child: Text(
                    "Cart",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                  padding: EdgeInsets.all(12.0),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
          cart.cartItems[index].quantity.toString() + "x \$" + cart.cartItems[index].price.toString(),
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                cart.decrementItemQuantity(cart.cartItems[index]);
              },
            ),
            Text(
              cart.cartItems[index].quantity.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                cart.incrementItemQuantity(cart.cartItems[index]);
              },
            ),
          ],
        ),
        ), 
      
      Divider(),
    ]
    );


  }
}
