// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:mothership/main.dart';
import 'package:mothership/utilities/product.dart';
import 'package:provider/provider.dart';

// Cart data saved as long as app is open via this CartModel which is launched in main
class CartModel with ChangeNotifier {
  List<Product> cartItems = [];

  Future<void> fetchCartData(BuildContext context) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        final response = await supabase
            .from('profiles')
            .select('cart_items')
            .eq('id', userId)
            .single();

        final data = response['cart_items'] as List<dynamic>?;

        if (data != null) {
          cartItems =
              data.map((item) => Product.fromAnotherJson(item)).toList();
          notifyListeners();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected error occurred.')),
      );
    }
  }

  Future<void> uploadCartData() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        final jsonData = cartItems.map((product) => product.toJson()).toList();
        await supabase
            .from('profiles')
            .update({'cart_items': jsonData}).eq('id', userId);
      }
    } catch (e) {
      //
    }
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in cartItems) {
      // Check if quantity is not null before using it in the calculation
      if (item.quantity != null) {
        totalPrice += item.price * item.quantity!;
      }
    }
    return double.parse(totalPrice.toStringAsFixed(2));
  }

  bool isItemInCart(Product item) {
    return cartItems.contains(item);
  }

  void incrementItemQuantity(Product item) {
    int index = cartItems.indexOf(item);
    if (index != -1) {
      // Check if quantity is not null before incrementing it
      if (cartItems[index].quantity != null) {
        // increment the quantity by 1
        cartItems[index].quantity =
            (cartItems[index].quantity! + 1).clamp(0, double.infinity.toInt());
        notifyListeners();
      }
    }
    uploadCartData(); // Call uploadCartData to save changes to the database
  }

  void decrementItemQuantity(Product item) {
    int index = cartItems.indexOf(item);
    if (index != -1) {
      // Check if quantity is not null before decrementing it
      if (cartItems[index].quantity != null) {
        // Decrement the quantity by 1 if it's not null
        cartItems[index].quantity =
            (cartItems[index].quantity! - 1).clamp(0, double.infinity.toInt());

        // If the quantity becomes zero, remove the item from the cart
        if (cartItems[index].quantity == 0) {
          removeItemFromCart(item);
        }
        notifyListeners();
      }
    }
    uploadCartData(); // Call uploadCartData to save changes to the database
  }

  void addItemToCart(Product item) {
    if (isItemInCart(item) == false) {
      cartItems.add(item);
      notifyListeners();
      uploadCartData(); // Call uploadCartData to save changes to the database
    }
  }

  void removeItemFromCart(Product item) {
    cartItems.remove(item);
    notifyListeners();
    uploadCartData(); // Call uploadCartData to save changes to the database
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
    uploadCartData(); // Call uploadCartData to save changes to the database
  }
}

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    // Fetch cart data when the CartPage is initialized
    Provider.of<CartModel>(context, listen: false).fetchCartData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          var totalPrice = cart.calculateTotalPrice().toStringAsFixed(2);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 45, left: 20),
                child: Text(
                  "Cart",
                  style: TextStyle(
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
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$$totalPrice"),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement the payment process or checkout
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
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
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<CartModel>(context, listen: false)
                              .clearCart();
                        },
                        child: Text('Clear Cart'),
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
      children: [
        ListTile(
          leading: Image.network(
            cart.cartItems[index].imageURL,
            height: 36,
          ),
          title: Text(
            cart.cartItems[index].name,
            style: const TextStyle(fontSize: 18),
          ),
          subtitle: Text(
            "${cart.cartItems[index].quantity}x \$${cart.cartItems[index].price}",
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
        const Divider(),
      ],
    );
  }
}
