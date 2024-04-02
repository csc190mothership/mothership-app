import 'package:flutter/material.dart';
import 'package:mothership/screens/item.dart';
import 'package:transparent_image/transparent_image.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

final Item testItem = Item("Test Item", "This is a test item", "https://bradynorum.com/images/myoldface.png", 20.00 as double); 
class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  var searchResults = <Widget>[Container()];

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
          onChanged: (value) {
            print(value);
            //TODO: text field queries api, then sets searchResults to the results
            //right now just has a placeholder which comes up at todays date
            if (value == "04022024") searchResults = [searchItem(testItem)];
            if (value == "") searchResults = [];
            setState(() {});
          },
        ),
      ),
      body: ListView(
        children: searchResults,
      ),
      
    );
  }


  Widget searchItem(Item item) {
    return ListTile(
      leading: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: item.imgPath,
      ), //this fade in image allows us to load images in 3 lines. living in the future.
      title: Text(item.name),
      subtitle: Text("\$" + (item.price).toString()), //sociopath iterpolation notation
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
