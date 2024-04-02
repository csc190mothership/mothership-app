import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

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
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            print(value);
            //TODO: text field queries api, then sets searchResults to the results
            //right now just has a placeholder which comes up at todays date
            if (value == "04022024") searchResults = [searchItem('https://bradynorum.com/images/myoldface.png','Today\'s Example Item', "9.10")];
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
}

Widget searchItem(String imgUrl, String title, String price) {
  return ListTile(
    leading: FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: imgUrl,
    ), //this fade in image allows us to load images in 3 lines. living in the future.
    title: Text(title),
    subtitle: Text("\$$price"), //sociopath iterpolation notation
    onTap: () {print("sorry i havent implemented an item page yet");} //TODO: navigate to item page
    //basically push a custom page with item deets. make a new file :D
  );
}
