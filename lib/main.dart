import 'package:flutter/material.dart';
import 'package:mothership/pages/account_page.dart';
import 'package:mothership/pages/login_page.dart';
import 'package:mothership/pages/mfa/enroll_page.dart';
import 'package:mothership/pages/mfa/list_mfa_page.dart';
import 'package:mothership/pages/mfa/verify_page.dart';
import 'package:mothership/pages/otp_page.dart';
import 'package:mothership/pages/profile_page.dart';
import 'package:mothership/pages/register_page.dart';
import 'package:mothership/pages/splash_page.dart';
import 'package:mothership/pages/verifyemail_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/kroger_services.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://ptxjscxersbcxjkrygve.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB0eGpzY3hlcnNiY3hqa3J5Z3ZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDkwNTI3MDMsImV4cCI6MjAyNDYyODcwM30.tkam8fZ888I7DpSBPZC_dQyy1qr0vgPS3p_uHU5GEBs',
  );
  //await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mothership',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/OTP': (context) => const OTPPage(),
        '/account': (context) => const AccountPage(),
        '/profile': (context) => const ProfilePage(),
        '/mfaenroll': (context) => const MFAEnrollPage(),
        '/mfaverify': (context) => const MFAVerifyPage(),
        '/listmfa': (context) => ListMFAPage(),
        '/verifyemail': (context) => const VerifyEmailPage(),
      },
    );
  }
}
