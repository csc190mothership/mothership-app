import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mothership/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisible = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final StreamSubscription<AuthState> _authSubscription;

  void verifyEmail() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email Verification Sent!')));
    }
  }

  @override
  void initState() {
    super.initState();
    _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        Navigator.of(context).pushReplacementNamed('/account');
      }
    });
    passwordVisible = true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(label: Text('Email')),
          ),
          TextFormField(
            obscureText: passwordVisible,
            controller: _passwordController,
            decoration: const InputDecoration(label: Text('Password')),
          ),
          const SizedBox(height: 12),
          GestureDetector(
              onTap: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
              child: const Text(
                'Show/Hide Password',
                textAlign: TextAlign.right,
              )),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () async {
                try {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  await supabase.auth.signUp(
                      email: email,
                      password: password,
                      emailRedirectTo:
                          'mfa-app://callback${Navigator.pushNamed(context, '/mfaenroll')}');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Register successful!')));
                    Timer(const Duration(seconds: 3), verifyEmail);
                    //Navigator.of(context).pushReplacementNamed('/account');
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
              child: const Text('Register')),
          ElevatedButton(
            onPressed: () async {
              if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
                /// Web Client ID that you registered with Google Cloud.
                const webClientId =
                    '357859755210-g0d3308u6esm71v2jthpcflc0p2m430m.apps.googleusercontent.com';

                /// iOS Client ID that you registered with Google Cloud.
                const iosClientId =
                    '357859755210-3a8dqcie0ripvib91cqcoiirl1lmfhb0.apps.googleusercontent.com';

                final GoogleSignIn googleSignIn = GoogleSignIn(
                  clientId: iosClientId,
                  serverClientId: webClientId,
                );
                final googleUser = await googleSignIn.signIn();
                final googleAuth = await googleUser!.authentication;
                final accessToken = googleAuth.accessToken;
                final idToken = googleAuth.idToken;

                if (accessToken == null) {
                  throw 'No Access Token found.';
                }
                if (idToken == null) {
                  throw 'No ID Token found.';
                }

                await supabase.auth.signInWithIdToken(
                  provider: OAuthProvider.google,
                  idToken: idToken,
                  accessToken: accessToken,
                );

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login successful!')));
                  Navigator.pushNamed(context, '/');
                }
              } else {
                await supabase.auth.signInWithOAuth(OAuthProvider.google);
              }
            },
            child: const Text('Login with Google'),
          ),
          const SizedBox(height: 12),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Login?')),
        ],
      ),
    );
  }
}
