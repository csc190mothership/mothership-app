import 'package:flutter/material.dart';
import 'package:mothership/screens/specialshop.dart';
import 'search.dart';
import 'package:page_transition/page_transition.dart';

class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                child: TextField(
                  controller: _searchController,
                  cursorColor: Color(0xFF0E131F),
                  style: TextStyle(
                    color: Color(0xFF0E131F),
                  ),
                  onSubmitted: (value) {
                    _searchController.text = '';
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: Search(searchString: value)),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'What can we help you find?',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Color(0xFF0E131F)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,

                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.9, 0),
                    padding: EdgeInsets.symmetric(
                        vertical: 16), // Add vertical padding of 16
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Color(0xFFC2B2B4),
                  ),
                  onPressed: () {
                    //TODO: Orders Page
                  },
                  child: Text("Past Orders",
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Popular Departments",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 400,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SpecialShopButton(Color(0xFF53B175), "Produce",
                          "assets/images/produce.png", () {
                        PushSpecialShop(
                            "Produce", "Lettuce", "Apple", "Grapes", "Tomato");
                      }),
                      SpecialShopButton(
                          Color(0xFFA53F2B), "Meat", "assets/images/meat.png",
                          () {
                        PushSpecialShop("Meat", "Ground Beef", "Chicken",
                            "Hot Dog", "Turkey");
                      }),
                      SpecialShopButton(Color.fromARGB(255, 100, 74, 62),
                          "Alcohol", "assets/images/beer.png", () {
                        PushSpecialShop(
                            "Alcohol", "Beer", "Wine", "Josh", "Hard Seltzer");
                      }),
                      SpecialShopButton(Color.fromARGB(255, 185, 185, 185),
                          "Dairy", "assets/images/dairy.png", () {
                        PushSpecialShop(
                            "Dairy", "Milk", "Yogurt", "Ice Cream", "Cheese");
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget SpecialShopButton(color, name, image, onPressed) {
    return ElevatedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Column(
        children: [
          Image.asset(image, height: 100),
          Text(
            name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void PushSpecialShop(
      String dept, String s1, String s2, String s3, String s4) {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.fade,
          child: SpecialShop(
              department: dept,
              search1: s1,
              search2: s2,
              search3: s3,
              search4: s4)),
    );
  }
}
