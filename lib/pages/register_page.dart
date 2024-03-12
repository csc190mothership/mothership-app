import 'dart:async';

import 'package:flutter/material.dart';
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
                  await supabase.auth.signUp(email: email, password: password);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Register successful!')));
                    Navigator.of(context).pushReplacementNamed('/account');
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
          const SizedBox(height: 12),
          GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: const Text('Login?')),
        ],
      ),
    );
  }
}
