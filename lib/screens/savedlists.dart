import 'package:flutter/material.dart';

class SavedListsPage extends StatefulWidget {
  @override
  _SavedListsPageState createState() => _SavedListsPageState();
}

class _SavedListsPageState extends State<SavedListsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Lists'),
      ),
      body: Container(
        child: Center(
          child: Text('Saved Lists Page'),
        ),
      ),
    );
  }
}