import 'package:flutter/material.dart';
import 'theme.dart';
import 'dart:io';
import 'screens/settings.dart';
import 'screens/debughome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedPage = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }
  final _pageOptions = [
    debugHome(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedPage,
        onTap: _onItemTapped,
      ),
    );
  }

  void pushSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Settings())
    );
  }
}
