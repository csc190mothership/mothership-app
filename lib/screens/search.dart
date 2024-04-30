import 'package:flutter/material.dart';
import 'package:mothership/screens/cart.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../utilities/kroger-services.dart';
import '../utilities/product.dart';
import 'dart:async';

class Search extends StatefulWidget {
  final String? searchString;

  Search({this.searchString});

  @override
  _SearchState createState() => _SearchState();

}


class _SearchState extends State<Search> {
  
  final TextEditingController _searchController = TextEditingController();
  final KrogerService _krogerService = KrogerService();
  Timer? _debounce;
  var searchResults = <Widget>[Container()];
  List<Product> _products = [];
  void _fetchData() async {
    if (_searchController.text.isEmpty) {
      // Optionally handle empty search input case
      return;
    }
    // Use the text from the controller as the search term
    var products =
        await _krogerService.fetchProductData(_searchController.text);
    setState(() {
      _products = products;
    });
  }
  //Using a debounce to prevent too many requests
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 50), () {
      _fetchData();
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchString!;
    _onSearchChanged(widget.searchString!);
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
    
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children:[
        SingleChildScrollView(
          child: 
            Column(
              children: [
                SizedBox(height:100),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    return searchItem(_products[index]);
                  },
                ),
              ],
            ),
        ),
        Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      child: TextField(
                        controller: _searchController,
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Color(0xFF0E131F)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]
      )
    );
  }

  Widget searchItem(Product item) {
    CartModel _cartModel = Provider.of<CartModel>(context);
    return ListTile(
        leading: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: item.imageURL,
          width: 50,
        ), //this fade in image allows us to load images in 3 lines. living in the future.
        title: Text(item.name),
        subtitle: Text("\$" + (item.price).toStringAsFixed(2)),
        trailing: IconButton(icon: Icon(Icons.add), onPressed: () {
          if (_cartModel.isItemInCart(item)) {
            _cartModel.incrementItemQuantity(item);
          } else {
            _cartModel.addItemToCart(item);
            _cartModel.incrementItemQuantity(item);
          }
        }
        ),
        onTap: () {
          Navigator.push(
            context,
            PageTransition(type: PageTransitionType.fade, child:ShopItem(item:item))
          );
        }
        );
  }
}
