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

  await Supabase.initialize(
    url: 'https://ptxjscxersbcxjkrygve.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB0eGpzY3hlcnNiY3hqa3J5Z3ZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDkwNTI3MDMsImV4cCI6MjAyNDYyODcwM30.tkam8fZ888I7DpSBPZC_dQyy1qr0vgPS3p_uHU5GEBs',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    );
  }
}
