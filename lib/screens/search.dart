import 'package:flutter/material.dart';
//import 'package:mothership/screens/item.dart';
import 'package:transparent_image/transparent_image.dart';
import '../utilities/kroger-services.dart';
import '../utilities/product.dart';
import 'dart:async';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

//final Item testItem = Item("Test Item", "This is a test item",
//"https://bradynorum.com/images/myoldface.png", 20.00 as double);

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
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          // onChanged: (value) {
          //   print(value);
          //   //TODO: text field queries api, then sets searchResults to the results
          //   //right now just has a placeholder which comes up at todays date
          //   //_fetchData();
          //   //if (value == "04022024") searchResults = [searchItem(testItem)];
          //   //if (value == "") searchResults = [];
          //   searchResults = _products.map((item) => searchItem(item)).toList();
          //   setState(() {});
          // },
        ),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return searchItem(_products[index]);
        },
      ),
    );
  }

  Widget searchItem(Product item) {
    return ListTile(
        leading: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: item.imageURL,
        ), //this fade in image allows us to load images in 3 lines. living in the future.
        title: Text(item.name),
        subtitle: Text(
            "\$" + (item.price).toString()), //sociopath iterpolation notation
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShopItem(item: item)),
          );
        }
        //basically push a custom page with item deets. make a new file :D
        );
  }
}
