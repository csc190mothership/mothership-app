//register screen
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mothership"),
      ),
      body: const Center(
        child: Text("Welcome to Mothership register!"),
      ),
    );
  }
}
