import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mothership/functions.dart';
import 'package:mothership/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool _isLoading = false;
  bool _redirecting = false;

  late final TextEditingController _emailController = TextEditingController();

  late final StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacementNamed('/newpassword');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildPasswordContent(),
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildPasswordContent() {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            const Text('Reset password with your email below'),
            const SizedBox(height: 18),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () async {
                if (!Functions.isEmailValid(_emailController.text)) {
                  // Show error message for invalid email format
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Enter a valid email.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  if (!_isLoading) {
                    try {
                      setState(() {
                        _isLoading = true; // Set loading state to false
                      });
                      await Functions.resetPassword(context, _emailController);
                    } finally {
                      setState(() {
                        _isLoading = false; // Set loading state to false
                      });
                      _emailController.clear();
                    }
                  }
                }
              },
              child: const Text('Send Email'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5), // Semi-transparent black color
      child: const Center(
        child: CircularProgressIndicator(), // Circular loading indicator
      ),
    );
  }
}
