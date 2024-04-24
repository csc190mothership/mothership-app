import 'package:flutter/material.dart';
import 'package:mothership/pages/login.dart';
import 'package:mothership/pages/newpassword.dart';
import 'package:mothership/pages/profile.dart';
import 'package:mothership/pages/register.dart';
import 'package:mothership/pages/resetpassword.dart';
import 'package:mothership/pages/setupaccount.dart';
import 'package:mothership/pages/splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: 'https://ptxjscxersbcxjkrygve.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB0eGpzY3hlcnNiY3hqa3J5Z3ZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDkwNTI3MDMsImV4cCI6MjAyNDYyODcwM30.tkam8fZ888I7DpSBPZC_dQyy1qr0vgPS3p_uHU5GEBs',
  );
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/account': (context) => const AccountSetupPage(),
        '/profile': (context) => const ProfilePage(),
        '/resetpassword': (context) => const ResetPasswordPage(),
        '/newpassword': (context) => const NewPasswordPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).getTheme(),
      home: const MyHomePage(),
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
    debugHome(),
    Shop(),
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
            icon: Icon(Icons.fastfood),
            label: 'Shop',
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
