import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mothership/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        Navigator.pushNamed(context, '/');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(label: Text('Email')),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () async {
                try {
                  final email = _emailController.text.trim();
                  await supabase.auth
                      .signInWithOtp(email: email, shouldCreateUser: false);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Check your email!')));
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VerifyOtpScreen(email: email)));
                  }
                } on AuthException catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(error.message),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ));
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Error occured, please retry.'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ));
                }
              },
              child: const Text('Send OTP')),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Register?')),
        ],
      ),
    );
  }
}

// screens/verify_otp_screen.dart
class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({super.key, required this.email});

  final String email;
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the 6-digit code',
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                try {
                  await Supabase.instance.client.auth.verifyOTP(
                    email: email,
                    token: _otpController.text,
                    type: OtpType.email,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login successful!')));
                  Navigator.pushNamed(context, '/');
                } catch (err) {
                  scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('Something went wrong')));
                }
              },
              child: const Text('Verify OTP'),
            )
          ],
        ),
      ),
    );
  }
}
