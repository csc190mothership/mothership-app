import 'package:flutter/material.dart';

class debugHome extends StatefulWidget {
  @override
  _debugHomeState createState() => _debugHomeState();
}

class _debugHomeState extends State<debugHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mothership"),
        
      ),
      body: const Center(
        child: Text("Welcome to Mothership debug home!"),
      ),
    );
  }
}