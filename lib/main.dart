import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mothership/screens/cart.dart';
import 'package:mothership/screens/loginscreens/login.dart';
import 'package:mothership/screens/loginscreens/newpassword.dart';
import 'package:mothership/screens/loginscreens/profile.dart';
import 'package:mothership/screens/loginscreens/register.dart';
import 'package:mothership/screens/loginscreens/resetpassword.dart';
import 'package:mothership/screens/loginscreens/setupaccount.dart';
import 'package:mothership/screens/loginscreens/splash.dart';
import 'package:mothership/screens/wallet.dart';
import 'package:mothership/themeprovider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/settings.dart';
import 'screens/shop.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: 'https://ptxjscxersbcxjkrygve.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB0eGpzY3hlcnNiY3hqa3J5Z3ZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDkwNTI3MDMsImV4cCI6MjAyNDYyODcwM30.tkam8fZ888I7DpSBPZC_dQyy1qr0vgPS3p_uHU5GEBs',
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => CartModel()),
    ],
    child: const MyApp(),
  ));
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).getTheme(),
      home: const SplashPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

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
    Shop(),
    CartPage(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
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
}
