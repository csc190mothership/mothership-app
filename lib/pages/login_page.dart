import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mothership/main.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
      appBar: AppBar(title: const Text('Login')),
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
                  await supabase.auth
                      .signInWithPassword(email: email, password: password);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login successful!')));
                    Navigator.pushNamed(context, '/');
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
              child: const Text('Login')),
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
          /*
          ElevatedButton(
            onPressed: () async {
              final rawNonce = supabase.auth.generateRawNonce();
              final hashedNonce =
                  sha256.convert(utf8.encode(rawNonce)).toString();

              final credential = await SignInWithApple.getAppleIDCredential(
                scopes: [
                  AppleIDAuthorizationScopes.email,
                  AppleIDAuthorizationScopes.fullName,
                ],
                nonce: hashedNonce,
              );

              final idToken = credential.identityToken;
              if (idToken == null) {
                throw const AuthException(
                    'Could not find ID Token from generated credential.');
              }

              await supabase.auth.signInWithIdToken(
                provider: OAuthProvider.apple,
                idToken: idToken,
                nonce: rawNonce,
              );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login successful!')));
                Navigator.pushNamed(context, '/');
              }
            },
            child: const Text('Login with Apple'),
          ),
          */
          const SizedBox(height: 12),
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
