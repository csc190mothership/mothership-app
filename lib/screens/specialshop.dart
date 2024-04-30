import 'package:flutter/material.dart';
import 'package:mothership/screens/cart.dart';
import 'package:mothership/utilities/kroger-services.dart';
import 'package:mothership/utilities/product.dart';
import 'package:provider/provider.dart';

class SpecialShop extends StatefulWidget {
  final String department;
  final String search1;
  final String search2;
  final String search3;
  final String search4;

  SpecialShop({
    Key? key,
    required this.department,
    required this.search1,
    required this.search2,
    required this.search3,
    required this.search4,
  }) : super(key: key);

  @override
  _SpecialShopState createState() => _SpecialShopState();
}

class _SpecialShopState extends State<SpecialShop> {
  final KrogerService _krogerService = KrogerService();
  List<Product> _products1 = [];
  List<Product> _products2 = [];
  List<Product> _products3 = [];
  List<Product> _products4 = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchList();
    //_fetchList(_products2, widget.search2);
    //_fetchList(_products3, widget.search3);
    //_fetchList(_products4, widget.search4);
  }

  void _fetchList() async {
    setState(() {
      _isLoading = true;
    });

    var products1 = await _krogerService.fetchProductData(widget.search1);
    var products2 = await _krogerService.fetchProductData(widget.search2);
    var products3 = await _krogerService.fetchProductData(widget.search3);
    var products4 = await _krogerService.fetchProductData(widget.search4);

    setState(() {
      _products1 = products1;
      _products2 = products2;
      _products3 = products3;
      _products4 = products4;
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 40),
              Row(
                children: [
                  SizedBox(width: 10),
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
                  Text(
                    widget.department,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 120),
              Text(
                widget.search1,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _isLoading
                  ? _buildLoadingIndicator()
                  : SideScrollItems(widget.search1, _products1),
              Text(widget.search2,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              _isLoading
                  ? _buildLoadingIndicator()
                  : SideScrollItems(widget.search1, _products2),
              Text(widget.search3,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              _isLoading
                  ? _buildLoadingIndicator()
                  : SideScrollItems(widget.search1, _products3),
              Text(widget.search4,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              _isLoading
                  ? _buildLoadingIndicator()
                  : SideScrollItems(widget.search1, _products4),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget SideScrollItems(String query, List<Product> prodlist) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 230,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: prodlist.length,
          itemBuilder: (BuildContext context, int index) {
            return ItemCard(prodlist[index]);
          },
        ),
      ),
    );
  }

  Widget ItemCard(Product item) {
    CartModel _cartModel = Provider.of<CartModel>(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShopItem(item: item),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFC2B2B4),
          ),
          width: 180,
          height: 220,
          child: Column(
            children: [
              Container(
                height: 100,
                width: 100,
                child: Image.network(item.imageURL),
              ),
              Container(
                height: 70,
                child: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  maxLines: 3,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("\$" + item.price.toStringAsFixed(2)),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () {
                        if (_cartModel.isItemInCart(item)) {
                          _cartModel.incrementItemQuantity(item);
                        } else {
                          _cartModel.addItemToCart(item);
                          _cartModel.incrementItemQuantity(item);
                        }
                      },
                      icon: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
